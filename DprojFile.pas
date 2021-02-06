unit dprojFile;

interface

uses
  { NOTE: If you get compilation errors here because a unit cannot be found,
    then make sure you clone this repository recursively. For example:
    > git clone --recursive https://github.com/grijjy/GrijjyDeployMan }
  System.Generics.Collections,
  Neslib.Xml,
  Common;

type
  { Reads/writes parts of Delphi .dproj files.
    NOTE: there are also .deployproj files. However, these are temporary files
    that Delphi recreates from the .dproj files. }
  TDprojFile = class
  public type
    TDeployFile = record
    private
      FLocalName: String;
      FRemoteDir: String;
      FRemoteName: String;
    public
      procedure Initialize;

      property LocalName: String read FLocalName write FLocalName;
      property RemoteDir: String read FRemoteDir write FRemoteDir;
      property RemoteName: String read FRemoteName write FRemoteName;
    end;

    TDeployFilesByPlatform = array [TTargetPlatform] of TDictionary<String, TDeployFile>;
  private
    FFilename: String;
    FDocument: IXmlDocument;
    FDeploymentElement: TXmlNode;
    FDeployFileElements: TDictionary<String, TXmlNode>;
    FConfigurations: TArray<String>;
    FDeployFiles: TDeployFilesByPlatform;
  private
    procedure LoadItemGroup(const AElement: TXmlNode);
    procedure LoadBuildConfiguration(const AElement: TXmlNode);
    procedure LoadProjectExtensions(const AElement: TXmlNode);
    procedure LoadBorlandProject(const AElement: TXmlNode);
    procedure LoadDeployment(const AElement: TXmlNode);
    function LoadDeployFile(const AElement: TXmlNode): Boolean;
    procedure LoadPlatform(const ALocalName: String; const AElement: TXmlNode);
    procedure ValidateDocument;
  private
    class function MatchesConfiguration(const AConfig: String;
      const AConfigs: TArray<String>): Boolean; static;
  public
    constructor Create(const AFilename: String);
    destructor Destroy; override;

    procedure Clear;
    procedure Load;
    procedure Save;

    procedure Add(const ALocalName, ARemoteDir: String;
      const APlatform: TTargetPlatform;
      const AForConfigurations: TArray<String>);

    property Configurations: TArray<String> read FConfigurations;
    property DeployFiles: TDeployFilesByPlatform read FDeployFiles;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Neslib.Xml.Types;

{ Format of .dproj files, as far as needed for our purposes:

  <Project>
  <ItemGroup>
  <BuildConfiguration Include="Base">
  <Key>Base</Key>
  </BuildConfiguration>
  <BuildConfiguration Include="Release">
  <Key>Cfg_2</Key>
  <CfgParent>Base</CfgParent>
  </BuildConfiguration>
  </ItemGroup>
  <ProjectExtensions>
  <BorlandProject>
  <Deployment Version="3">
  <DeployFile LocalName="Deploy\file1.txt" Configuration="Debug" Class="File">
  <Platform Name="Android">
  <RemoteDir>assets\internal\</RemoteDir>
  <RemoteName>file1.txt</RemoteName>
  <Overwrite>true</Overwrite>
  </Platform>
  <Platform Name="iOSDevice32">
  <RemoteDir>.\testdir</RemoteDir>
  <RemoteName>file1.txt</RemoteName>
  <Overwrite>true</Overwrite>
  </Platform>
  </DeployFile>
  </Deployment>
  </BorlandProject>
  </ProjectExtensions>
  </Project>

  * Each build configuration (Debug, Release etc.) has a <BuildConfiguration>
  entry. The "Base" configuration should be ignored.
  * <DeployFile> is used for all sorts of files, including the project binaries,
  splash screens and resources. Custom files that you add manually always have
  a Class of "File". All other classes are managed by Delphi and should be
  ignored.
  * If <RemoteDir> is not given, it is set to '.\'

  Supported platforms:
  * Win32
  * Win64
  * iOSDevice32
  * iOSDevice64
  * iOSSimulator
  * Android
  * Android64 }

{ TDprojFile.TDeployFile }

procedure TDprojFile.TDeployFile.Initialize;
begin
  FLocalName := '';
  FRemoteDir := '';
  FRemoteName := '';
end;

{ TDprojFile }

procedure TDprojFile.Add(const ALocalName, ARemoteDir: String;
  const APlatform: TTargetPlatform; const AForConfigurations: TArray<String>);
const
  PLATFORM_NAMES: array [TTargetPlatform, 0..2] of String =
   (('', '', ''),                                   // Unknown
    ('iOSDevice32', 'iOSDevice64', 'iOSSimulator'), // iOS
    ('Android', 'Android64', ''));                  // Android
var
  DeployFile, Platf, Prop: TXmlNode;
  Key, Config, PlatformName: String;
  I: Integer;
begin
  if (FDeploymentElement = nil) then
    Exit;

  for Config in FConfigurations do
  begin
    if MatchesConfiguration(Config, AForConfigurations) then
    begin
      Key := ALocalName + '~' + Config;
      if (not FDeployFileElements.TryGetValue(Key, DeployFile)) then
      begin
        DeployFile := FDeploymentElement.AddElement('DeployFile');
        DeployFile.AddAttribute('LocalName', ALocalName);
        DeployFile.AddAttribute('Configuration', Config);
        DeployFile.AddAttribute('Class', 'File');
        FDeployFileElements.Add(Key, DeployFile);
      end;

      for I := 0 to 2 do
      begin
        PlatformName := PLATFORM_NAMES[APlatform, I];
        if (PlatformName = '') then
          Break;

        Platf := DeployFile.AddElement('Platform');
        Platf.AddAttribute('Name', PlatformName);

        if (ARemoteDir <> '') and (ARemoteDir <> '.\') then
        begin
          Prop := Platf.AddElement('RemoteDir');
          Prop.AddText(ARemoteDir);
        end;

        Prop := Platf.AddElement('RemoteName');
        Prop.AddText(TPath.GetFileName(ALocalName));

        Prop := Platf.AddElement('Overwrite');
        Prop.AddText('true');
      end;
    end;
  end;
end;

procedure TDprojFile.Clear;
var
  P: TTargetPlatform;
begin
  FDeployFileElements.Clear;
  FConfigurations := nil;
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployFiles[P].Clear;
end;

constructor TDprojFile.Create(const AFilename: String);
var
  P: TTargetPlatform;
begin
  inherited Create;
  FFilename := AFilename;
  FDeployFileElements := TDictionary<String, TXmlNode>.Create;
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployFiles[P] := TDictionary<String, TDeployFile>.Create;
  FDocument := TXmlDocument.Create;
  try
    FDocument.Load(AFilename);
  except
    raise Exception.Create('Unable to load ' + AFilename);
  end;
end;

destructor TDprojFile.Destroy;
var
  P: TTargetPlatform;
begin
  FDeployFileElements.Free;
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployFiles[P].Free;
  inherited;
end;

procedure TDprojFile.Load;
var
  Root, Element: TXmlNode;
  Name: String;
begin
  Clear;
  Root := FDocument.DocumentElement;
  for Element in Root do
  begin
    Name := Element.Value;
    if (Name = 'ItemGroup') then
      LoadItemGroup(Element)
    else if (Name = 'ProjectExtensions') then
      LoadProjectExtensions(Element);
  end;
end;

procedure TDprojFile.LoadBorlandProject(const AElement: TXmlNode);
var
  Element: TXmlNode;
begin
  for Element in AElement do
  begin
    if (Element.Value = 'Deployment') then
      LoadDeployment(Element);
  end;
end;

procedure TDprojFile.LoadBuildConfiguration(const AElement: TXmlNode);
var
  Attr: TXmlAttribute;
  Name: String;
  I: Integer;
begin
  Attr := AElement.AttributeByName('Include');
  if (Attr = nil) then
    Exit;

  Name := Attr.Name;
  if (Name <> 'Base') then
  begin
    for I := 0 to Length(FConfigurations) - 1 do
      if (FConfigurations[I] = Name) then
        Exit;

    FConfigurations := FConfigurations + [Name];
  end;
end;

function TDprojFile.LoadDeployFile(const AElement: TXmlNode): Boolean;
var
  Attr: TXmlAttribute;
  Element: TXmlNode;
  LocalName: String;
begin
  Result := False;
  Attr := AElement.AttributeByName('Class');
  if (Attr.Name <> 'File') then
    Exit;

  Attr := AElement.AttributeByName('LocalName');
  LocalName := Attr.Name;
  if (LocalName = '') then
    Exit;

  for Element in AElement do
  begin
    if (Element.Value = 'Platform') then
      LoadPlatform(LocalName, Element);
  end;

  Result := True;
end;

procedure TDprojFile.LoadDeployment(const AElement: TXmlNode);
var
  Element: TXmlNode;
  ElementsToDelete: TArray<TXmlNode>;
  I, Count: Integer;
begin
  FDeploymentElement := AElement;
  SetLength(ElementsToDelete, 16);
  Count := 0;
  for Element in AElement do
  begin
    if (Element.Value = 'DeployFile') then
    begin
      if LoadDeployFile(Element) then
      begin
        if (Count >= Length(ElementsToDelete)) then
          SetLength(ElementsToDelete, GrowCollection(Count, Count + 1));

        ElementsToDelete[Count] := Element;
        Inc(Count);
      end;
    end;
  end;

  for I := 0 to Count - 1 do
    AElement.RemoveChild(ElementsToDelete[I]);
end;

procedure TDprojFile.LoadItemGroup(const AElement: TXmlNode);
var
  Element: TXmlNode;
begin
  for Element in AElement do
  begin
    if (Element.Value = 'BuildConfiguration') then
      LoadBuildConfiguration(Element);
  end;
end;

procedure TDprojFile.LoadPlatform(const ALocalName: String;
  const AElement: TXmlNode);
var
  Name: String;
  P: TTargetPlatform;
  F: TDeployFile;
  Attr: TXmlAttribute;
  Element: TXmlNode;
begin
  Attr := AElement.AttributeByName('Name');
  Name := Attr.Name;
  if (Name = 'Android') then
    P := TTargetPlatform.Android
  else if (Name = 'iOSDevice32') or (Name = 'iOSDevice64') or (Name = 'iOSSimulator') then
    P := TTargetPlatform.iOS
  else
    Exit;

  if (FDeployFiles[P].ContainsKey(ALocalName)) then
    Exit;

  F.Initialize;
  F.LocalName := ALocalName;

  for Element in AElement do
  begin
    if (Element.Value = 'RemoteName') then
      F.RemoteName := Element.Text
    else if (Element.Value = 'RemoteDir') then
      F.RemoteDir := Element.Text
  end;

  FDeployFiles[P].Add(ALocalName, F);
end;

procedure TDprojFile.LoadProjectExtensions(const AElement: TXmlNode);
var
  Element: TXmlNode;
begin
  for Element in AElement do
  begin
    if (Element.Value = 'BorlandProject') then
      LoadBorlandProject(Element);
  end;
end;

class function TDprojFile.MatchesConfiguration(const AConfig: String;
  const AConfigs: TArray<String>): Boolean;
var
  I: Integer;
begin
  if (AConfigs = nil) then
    Exit(True);

  for I := 0 to Length(AConfigs) - 1 do
  begin
    if (AConfigs[I] = AConfig) then
      Exit(True);
  end;

  Result := False;
end;

procedure TDprojFile.Save;
var
  BackupFilename: String;
begin
  ValidateDocument;

  BackupFilename := FFilename + '.bak';
  if (TFile.Exists(BackupFilename)) then
    TFile.Delete(BackupFilename);

  if (TFile.Exists(FFilename)) then
    TFile.Move(FFilename, BackupFilename);

  FDocument.Save(FFilename, [TXmlOutputOption.Indent]);
end;

procedure TDprojFile.ValidateDocument;
var
  Root, Element: TXmlNode;
  ElementsToDelete: TArray<TXmlNode>;
begin
  { Sanity check. A previous version of DeployMan could add empty
    <ProjectExtensions/> element to the XML. While this is still valid XML,
    MSBuild allows only one <ProjectExtensions> element in the project.

    So we remove any empty <ProjectExtensions> elements }
  ElementsToDelete := nil;
  Root := FDocument.DocumentElement;
  for Element in Root do
  begin
    if (Element.Value = 'ProjectExtensions') and (Element.FirstChild = nil) then
      ElementsToDelete := ElementsToDelete + [Element];
  end;

  for Element in ElementsToDelete do
    Root.RemoveChild(Element);
end;

end.
