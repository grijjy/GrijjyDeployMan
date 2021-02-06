unit grdeployFile;

interface

uses
  { NOTE: If you get compilation errors here because a unit cannot be found,
    then make sure you clone this repository recursively. For example:
    > git clone --recursive https://github.com/grijjy/GrijjyDeployMan }
  System.Generics.Collections,
  Grijjy.Bson,
  Grijjy.Bson.IO,
  Grijjy.Bson.Serialization,
  Common;

type
  TDeployEntry = record
  public
    LocalName: String;
    RemoteDir: String;
    Configurations: TArray<String>;
    IsDirectory: Boolean;
    IncludeSubDirectories: Boolean;
  public
    procedure Initialize;
  end;

type
  TDeployEntries = TArray<TDeployEntry>;

type
  TDeployData = record
  public
    Configurations: TArray<String>;
    iOS: TDeployEntries;
    Android: TDeployEntries;
  public
    procedure Initialize;
  end;

type
  TgrDeployEntriesByPlatform = array [TTargetPlatform] of TDictionary<String, TDeployEntry>;

type
  { Represents a .grdeploy file containing the settings for DeployMan }
  TDeployFile = class
  private
    FFilename: String;
    FDirectory: String;
    FConfigurations: TArray<String>;
    FDeployEntries: TgrDeployEntriesByPlatform;
  private
    procedure AddEntries(const APlatform: TTargetPlatform;
      const AEntries: TDeployEntries);
  public
    constructor Create(const AFilename: String);
    destructor Destroy; override;

    procedure Clear;
    procedure Load;
    procedure Save;

    function Add(const APlatform: TTargetPlatform; const ALocalName,
      ARemoteDir: String; const AIsDirectory,
      AIncludeSubDirectories: Boolean): TDeployEntry;
    function Remove(const ALocalName: String; const APlatform: TTargetPlatform): Boolean;

    property Filename: String read FFilename;
    property Directory: String read FDirectory;
    property DeployEntries: TgrDeployEntriesByPlatform read FDeployEntries;
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
var
  Dict: TDictionary<String, TDeployEntry>;
  Entry: TDeployEntry;
  I: Integer;
begin
  Dict := FDeployEntries[APlatform];
  for I := 0 to Length(AEntries) - 1 do
  begin
    Entry := AEntries[I];
    if (Entry.RemoteDir = '') then
      Entry.RemoteDir := '.\';
    Dict.AddOrSetValue(Entry.LocalName, Entry);
  end;
end;

procedure TDeployFile.Clear;
var
  P: TTargetPlatform;
begin
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployEntries[P].Clear;
end;

constructor TDeployFile.Create(const AFilename: String);
var
  P: TTargetPlatform;
begin
  inherited Create;
  FFilename := AFilename;
  FDirectory := IncludeTrailingPathDelimiter(TPath.GetDirectoryName(AFilename));
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployEntries[P] := TDictionary<String, TDeployEntry>.Create;
end;

destructor TDeployFile.Destroy;
var
  P: TTargetPlatform;
begin
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    FDeployEntries[P].Free;
  inherited;
end;

procedure TDeployFile.Load;
var
  Data: TDeployData;
  Reader: TStreamReader;
  Json: String;
begin
  Clear;
  if (not TFile.Exists(FFilename)) then
    Exit;

  Reader := TStreamReader.Create(FFilename);
  try
    Json := Reader.ReadToEnd;
  finally
    Reader.Free;
  end;

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
var
  BackupFilename, Json: String;
  Data: TDeployData;
  Writer: TStreamWriter;
begin
  BackupFilename := FFilename + '.bak';
  if (TFile.Exists(BackupFilename)) then
    TFile.Delete(BackupFilename);

  if (TFile.Exists(FFilename)) then
    TFile.Move(FFilename, BackupFilename);

  Data.Configurations := FConfigurations;
  Data.iOS := FDeployEntries[TTargetPlatform.iOS].Values.ToArray;
  Data.Android := FDeployEntries[TTargetPlatform.Android].Values.ToArray;

  TgoBsonSerializer.Serialize(Data, TgoJsonWriterSettings.Pretty, Json);
  Writer := TStreamWriter.Create(FFilename);
  try
    Writer.Write(Json);
  finally
    Writer.Free;
  end;
end;

end.
