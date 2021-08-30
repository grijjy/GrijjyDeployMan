unit Model.DelphiProjectFile;

interface

uses
  { NOTE: If you get compilation errors here because a unit cannot be found,
    then make sure you clone this repository recursively. For example:
    > git clone --recursive https://github.com/grijjy/GrijjyDeployMan }
  System.Generics.Collections,
  Neslib.Xml,
  Model.Common;

type
  { Reads/writes parts of Delphi .dproj files.
    NOTE: there are also .deployproj files. However, these are temporary files
    that Delphi recreates from the .dproj files. }
  TDelphiProjectFile = class
  public type
    { Represents a single deployed file in a Delphi project file. }
    TDeployFile = record
    {$REGION 'Internal Declarations'}
    private
      FLocalName: String;
      FRemoteDir: String;
      FRemoteName: String;
    {$ENDREGION 'Internal Declarations'}
    public
      procedure Initialize;

      { The name of the file (including directory) on the local file system. }
      property LocalName: String read FLocalName write FLocalName;

      { The target directory (on the device) }
      property RemoteDir: String read FRemoteDir write FRemoteDir;

      { The target filename (on the device) }
      property RemoteName: String read FRemoteName write FRemoteName;
    end;

    { An array of deployed files per platform }
    TDeployFilesByPlatform = array [TTargetPlatform] of TDictionary<String, TDeployFile>;
  {$REGION 'Internal Declarations'}
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
  {$ENDREGION 'Internal Declarations'}
  public
    { Creates a Delphi project file wrapper.

      Parameters:
        AFilename: the name (including path) of the .dproj file.

      This will load the file, without investigating it. To investigate the
      file and extract the needed data, call Load.}
    constructor Create(const AFilename: String);
    destructor Destroy; override;

    { Clears any extracted data (the Configurations and DeployFiles properties) }
    procedure Clear;

    { Loads and extracts the Configurations and DeployFile properties from the
      file. }
    procedure Load;

    { Saves the project file, including any changes made by calling Clear and
      Add. }
    procedure Save;

    { Adds a file to be deployed.

      Parameters:
        ALocalName: the name (including directory) on the local file system of
          the file to be deployed.
        ARemoteDirectory: the target directory on the device to deploy to.
        APlatform: the target platform for the file (iOS or Android)
        AForConfigurations: the build configurations to add the file to.
          Can be nil (empty) to apply to all configurations. }
    procedure Add(const ALocalName, ARemoteDir: String;
      const APlatform: TTargetPlatform;
      const AForConfigurations: TArray<String>);

    { The build configurations found in the projectc file. }
    property Configurations: TArray<String> read FConfigurations;

    { All deployed files per platform. }
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
  * iOSDevice64
  * iOSSimulator
  * Android
  * Android64 }

{ TDelphiProjectFile.TDeployFile }

procedure TDelphiProjectFile.TDeployFile.Initialize;
begin
  FLocalName := '';
  FRemoteDir := '';
  FRemoteName := '';
end;

{ TDelphiProjectFile }

procedure TDelphiProjectFile.Add(const ALocalName, ARemoteDir: String;
  const APlatform: TTargetPlatform; const AForConfigurations: TArray<String>);
const
  PLATFORM_NAMES: array [TTargetPlatform, 0..2] of String =
   (('', '', ''),                        // Unknown
    ('iOSDevice64', 'iOSSimulator', ''), // iOS
    ('Android', 'Android64', ''));       // Android
begin
  if (FDeploymentElement = nil) then
    Exit;

  for var Config in FConfigurations do
  begin
    if MatchesConfiguration(Config, AForConfigurations) then
    begin
      var Key := ALocalName + '~' + Config;
      var DeployFile: TXmlNode;
      if (not FDeployFileElements.TryGetValue(Key, DeployFile)) then
      begin
        DeployFile := FDeploymentElement.AddElement('DeployFile');
        DeployFile.AddAttribute('LocalName', ALocalName);
        DeployFile.AddAttribute('Configuration', Config);
        DeployFile.AddAttribute('Class', 'File');
        FDeployFileElements.Add(Key, DeployFile);
      end;

      for var I := 0 to Length(PLATFORM_NAMES[APlatform]) - 1 do
      begin
        var PlatformName := PLATFORM_NAMES[APlatform, I];
        if (PlatformName = '') then
          Break;

        var Platf := DeployFile.AddElement('Platform');
        Platf.AddAttribute('Name', PlatformName);

        var Prop: TXmlNode;
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

procedure TDelphiProjectFile.Clear;
begin
  FDeployFileElements.Clear;
  FConfigurations := nil;
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployFiles[P].Clear;
end;

constructor TDelphiProjectFile.Create(const AFilename: String);
begin
  inherited Create;
  FFilename := AFilename;
  FDeployFileElements := TDictionary<String, TXmlNode>.Create;
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployFiles[P] := TDictionary<String, TDeployFile>.Create;
  FDocument := TXmlDocument.Create;
  try
    FDocument.Load(AFilename);
  except
    raise Exception.Create('Unable to load ' + AFilename);
  end;
end;

destructor TDelphiProjectFile.Destroy;
begin
  FDeployFileElements.Free;
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployFiles[P].Free;
  inherited;
end;

procedure TDelphiProjectFile.Load;
begin
  Clear;
  var Root := FDocument.DocumentElement;
  for var Element in Root do
  begin
    var Name := Element.Value;
    if (Name = 'ItemGroup') then
      LoadItemGroup(Element)
    else if (Name = 'ProjectExtensions') then
      LoadProjectExtensions(Element);
  end;
end;

procedure TDelphiProjectFile.LoadBorlandProject(const AElement: TXmlNode);
begin
  for var Child in AElement do
  begin
    if (Child.Value = 'Deployment') then
      LoadDeployment(Child);
  end;
end;

procedure TDelphiProjectFile.LoadBuildConfiguration(const AElement: TXmlNode);
begin
  var Name := AElement.AttributeByName('Include').Value;
  if (Name <> 'Base') then
  begin
    for var I := 0 to Length(FConfigurations) - 1 do
    begin
      if (FConfigurations[I] = Name) then
        Exit;
    end;

    FConfigurations := FConfigurations + [Name];
  end;
end;

function TDelphiProjectFile.LoadDeployFile(const AElement: TXmlNode): Boolean;
begin
  Result := False;
  if (AElement.AttributeByName('Class').Value <> 'File') then
    Exit;

  var LocalName := AElement.AttributeByName('LocalName').Value;
  if (LocalName = '') then
    Exit;

  for var Child in AElement do
  begin
    if (Child.Value = 'Platform') then
      LoadPlatform(LocalName, Child);
  end;

  Result := True;
end;

procedure TDelphiProjectFile.LoadDeployment(const AElement: TXmlNode);
var
  ElementsToDelete: TArray<TXmlNode>;
begin
  FDeploymentElement := AElement;
  SetLength(ElementsToDelete, 16);
  var Count := 0;
  for var Child in AElement do
  begin
    if (Child.Value = 'DeployFile') then
    begin
      if LoadDeployFile(Child) then
      begin
        if (Count >= Length(ElementsToDelete)) then
          SetLength(ElementsToDelete, GrowCollection(Count, Count + 1));

        ElementsToDelete[Count] := Child;
        Inc(Count);
      end;
    end;
  end;

  for var I := 0 to Count - 1 do
    AElement.RemoveChild(ElementsToDelete[I]);
end;

procedure TDelphiProjectFile.LoadItemGroup(const AElement: TXmlNode);
begin
  for var Child in AElement do
  begin
    if (Child.Value = 'BuildConfiguration') then
      LoadBuildConfiguration(Child);
  end;
end;

procedure TDelphiProjectFile.LoadPlatform(const ALocalName: String;
  const AElement: TXmlNode);
begin
  var Platf: TTargetPlatform;
  var Name := AElement.AttributeByName('Name').Value;
  if (Name = 'Android') then
    Platf := TTargetPlatform.Android
  else if (Name = 'iOSDevice64') or (Name = 'iOSSimulator') then
    Platf := TTargetPlatform.iOS
  else
    Exit;

  if (FDeployFiles[Platf].ContainsKey(ALocalName)) then
    Exit;

  var DeployFile: TDeployFile;
  DeployFile.Initialize;
  DeployFile.LocalName := ALocalName;

  for var Child in AElement do
  begin
    if (Child.Value = 'RemoteName') then
      DeployFile.RemoteName := Child.Text
    else if (Child.Value = 'RemoteDir') then
      DeployFile.RemoteDir := Child.Text
  end;

  FDeployFiles[Platf].Add(ALocalName, DeployFile);
end;

procedure TDelphiProjectFile.LoadProjectExtensions(const AElement: TXmlNode);
begin
  for var Child in AElement do
  begin
    if (Child.Value = 'BorlandProject') then
      LoadBorlandProject(Child);
  end;
end;

class function TDelphiProjectFile.MatchesConfiguration(const AConfig: String;
  const AConfigs: TArray<String>): Boolean;
begin
  if (AConfigs = nil) then
    Exit(True);

  for var I := 0 to Length(AConfigs) - 1 do
  begin
    if (AConfigs[I] = AConfig) then
      Exit(True);
  end;

  Result := False;
end;

procedure TDelphiProjectFile.Save;
begin
  ValidateDocument;

  var BackupFilename := FFilename + '.bak';
  if (TFile.Exists(BackupFilename)) then
    TFile.Delete(BackupFilename);

  if (TFile.Exists(FFilename)) then
    TFile.Move(FFilename, BackupFilename);

  FDocument.Save(FFilename, [TXmlOutputOption.Indent]);
end;

procedure TDelphiProjectFile.ValidateDocument;
var
  ElementsToDelete: TArray<TXmlNode>;
begin
  { Sanity check. A previous version of DeployMan could add empty
    <ProjectExtensions/> element to the XML. While this is still valid XML,
    MSBuild allows only one <ProjectExtensions> element in the project.

    So we remove any empty <ProjectExtensions> elements }
  ElementsToDelete := nil;
  var Root := FDocument.DocumentElement;
  for var Element in Root do
  begin
    if (Element.Value = 'ProjectExtensions') and (Element.FirstChild = nil) then
      ElementsToDelete := ElementsToDelete + [Element];
  end;

  for var Element in ElementsToDelete do
    Root.RemoveChild(Element);
end;

end.
