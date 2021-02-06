unit Model.GrijjyDeployFile;

interface

uses
  { NOTE: If you get compilation errors here because a unit cannot be found,
    then make sure you clone this repository recursively. For example:
    > git clone --recursive https://github.com/grijjy/GrijjyDeployMan }
  System.Generics.Collections,
  Grijjy.Bson,
  Grijjy.Bson.IO,
  Grijjy.Bson.Serialization,
  Model.Common;

type
  { Represents a single entry in a .grdeploy file }
  TDeployEntry = record
  public
    { The name of the file or directory to deploy (on the local file system) }
    LocalName: String;

    { The target directory on the device }
    RemoteDir: String;

    { The build configurations to which this entry applies.
      Can be nil (empty) to apply to all build configurations. }
    Configurations: TArray<String>;

    { Whether LocalName is a directory or not }
    IsDirectory: Boolean;

    { Whether to deploy all subdirectories of LocalName as well (only applies
      when IsDirectory is True). }
    IncludeSubDirectories: Boolean;
  public
    procedure Initialize;
  end;

type
  TDeployEntries = TArray<TDeployEntry>;

type
  { All the settings in a .grdeploy file packed into a record for easy
    JSON serialization }
  TDeployData = record
  public
    { All build configurations from the original .dproj file. }
    Configurations: TArray<String>;

    { All deployment entries for the iOS platform }
    iOS: TDeployEntries;

    { All deployment entries for the Android platform }
    Android: TDeployEntries;
  public
    procedure Initialize;
  end;

type
  TDeployEntriesByPlatform = array [TTargetPlatform] of TDictionary<String, TDeployEntry>;

type
  { Represents a .grdeploy file containing the settings for DeployMan }
  TDeployFile = class
  {$REGION 'Internal Declarations'}
  private
    FFilename: String;
    FDirectory: String;
    FConfigurations: TArray<String>;
    FDeployEntries: TDeployEntriesByPlatform;
  private
    procedure AddEntries(const APlatform: TTargetPlatform;
      const AEntries: TDeployEntries);
  {$ENDREGION 'Internal Declarations'}
  public
    { Creates an instance.

      Parameters:
        AFilename: the name of the .grdeploy file (can include a directory).

      NOTE: The file is not loaded (yet). Use Load to load it. }
    constructor Create(const AFilename: String);
    destructor Destroy; override;

    { Clears the deployment file. }
    procedure Clear;

    { Loads the deployment settings file from disk. }
    procedure Load;

    { Saves the deployment settings file from disk. }
    procedure Save;

    { Adds a file or directory to be deployed.

      Parameters:
        APlatform: the target platform (iOS or Android)
        ALocalName: the name of the file or directory to deploy (on the local
          file system)
        ARemoteDir: the target directory on the device to deploy to.
        AIsDirectory: whether ALocalName is a directory or not
        AIncludeSubDirectories: whether to deploy all subdirectories of
          ALocalName as well (only applies when AIsDirectory is True).

      Returns:
        The entry for these settings. }
    function Add(const APlatform: TTargetPlatform; const ALocalName,
      ARemoteDir: String; const AIsDirectory,
      AIncludeSubDirectories: Boolean): TDeployEntry;

    { Removes a file or directory from deployment.

      Parameters:
        ALocalName: the name of the file or directory to remove (on the local
          file system)
        APlatform: the target platform (iOS or Android)

      Returns:
        True if there was an entry for ALocalName, of False if not. }
    function Remove(const ALocalName: String; const APlatform: TTargetPlatform): Boolean;

    { The name of the .grdeploy file (including directory, if given) }
    property Filename: String read FFilename;

    { The directory that contains (or will contain) the .grdeploy file) }
    property Directory: String read FDirectory;

    { The deployment entries by platform }
    property DeployEntries: TDeployEntriesByPlatform read FDeployEntries;

    { All build configurations, as present in the original .dproj file. }
    property Configurations: TArray<String> read FConfigurations write FConfigurations;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils;

{ TDeployEntry }

procedure TDeployEntry.Initialize;
begin
  LocalName := '';
  RemoteDir := '';
  IsDirectory := False;
  IncludeSubDirectories := False;
end;

{ TDeployData }

procedure TDeployData.Initialize;
begin
  Configurations := nil;
  iOS := nil;
  Android := nil;
end;

{ TDeployFile }

function TDeployFile.Add(const APlatform: TTargetPlatform; const ALocalName,
  ARemoteDir: String; const AIsDirectory,
  AIncludeSubDirectories: Boolean): TDeployEntry;
begin
  Assert(not FDeployEntries[APlatform].ContainsKey(ALocalName));
  Result.Initialize;
  Result.LocalName := ALocalName;
  Result.RemoteDir := ARemoteDir;
  Result.IsDirectory := AIsDirectory;
  Result.IncludeSubDirectories := AIncludeSubDirectories;
  FDeployEntries[APlatform].Add(ALocalName, Result);
end;

procedure TDeployFile.AddEntries(const APlatform: TTargetPlatform;
  const AEntries: TDeployEntries);
begin
  var Dict := FDeployEntries[APlatform];
  for var I := 0 to Length(AEntries) - 1 do
  begin
    var Entry := AEntries[I];
    if (Entry.RemoteDir = '') then
      Entry.RemoteDir := '.\';
    Dict.AddOrSetValue(Entry.LocalName, Entry);
  end;
end;

procedure TDeployFile.Clear;
begin
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployEntries[P].Clear;
end;

constructor TDeployFile.Create(const AFilename: String);
begin
  inherited Create;
  FFilename := AFilename;
  FDirectory := IncludeTrailingPathDelimiter(TPath.GetDirectoryName(AFilename));
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployEntries[P] := TDictionary<String, TDeployEntry>.Create;
end;

destructor TDeployFile.Destroy;
begin
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployEntries[P].Free;
  inherited;
end;

procedure TDeployFile.Load;
begin
  Clear;
  if (not TFile.Exists(FFilename)) then
    Exit;

  var Json: String;
  var Reader := TStreamReader.Create(FFilename);
  try
    Json := Reader.ReadToEnd;
  finally
    Reader.Free;
  end;

  var Data: TDeployData;
  Data.Initialize;
  TgoBsonSerializer.Deserialize(Json, Data);
  FConfigurations := Data.Configurations;
  AddEntries(TTargetPlatform.iOS, Data.iOS);
  AddEntries(TTargetPlatform.Android, Data.Android);
end;

function TDeployFile.Remove(const ALocalName: String;
  const APlatform: TTargetPlatform): Boolean;
begin
  Result := FDeployEntries[APlatform].ContainsKey(ALocalName);
  if (Result) then
    FDeployEntries[APlatform].Remove(ALocalName);
end;

procedure TDeployFile.Save;
begin
  var BackupFilename := FFilename + '.bak';
  if (TFile.Exists(BackupFilename)) then
    TFile.Delete(BackupFilename);

  if (TFile.Exists(FFilename)) then
    TFile.Move(FFilename, BackupFilename);

  var Data: TDeployData;
  Data.Configurations := FConfigurations;
  Data.iOS := FDeployEntries[TTargetPlatform.iOS].Values.ToArray;
  Data.Android := FDeployEntries[TTargetPlatform.Android].Values.ToArray;

  var Json: String;
  TgoBsonSerializer.Serialize(Data, TgoJsonWriterSettings.Pretty, Json);

  var Writer := TStreamWriter.Create(FFilename);
  try
    Writer.Write(Json);
  finally
    Writer.Free;
  end;
end;

end.
