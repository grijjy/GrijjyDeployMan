unit FMain;

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  System.Actions,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Menus,
  Vcl.ImgList,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ToolWin,
  Vcl.ActnList,
  Vcl.FileCtrl,
  FConfigurations,
  Common,
  dprojFile,
  grdeployFile;

type
  TFormMain = class(TForm)
    MenuFile: TMenuItem;
    MenuImport: TMenuItem;
    OpenDialogDproj: TFileOpenDialog;
    MainMenu: TMainMenu;
    OpenDialogGrdeploy: TFileOpenDialog;
    MenuOpen: TMenuItem;
    MenuSave: TMenuItem;
    N1: TMenuItem;
    MenuExit: TMenuItem;
    ImageList: TImageList;
    TabControl: TTabControl;
    ListViewEntries: TListView;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    ButtonAddFile: TToolButton;
    ButtonAddFolder: TToolButton;
    ButtonDelete: TToolButton;
    ToolButton1: TToolButton;
    ActionList: TActionList;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionImport: TAction;
    ActionExit: TAction;
    ActionAddFile: TAction;
    ActionAddFolder: TAction;
    ActionDelete: TAction;
    PanelTools: TPanel;
    LabelTargetDir: TLabel;
    ToolButton2: TToolButton;
    ComboBoxTargetDir: TComboBox;
    CheckBoxSubDirs: TCheckBox;
    PopupMenuList: TPopupMenu;
    PopupMenuAddFile: TMenuItem;
    PopupMenuAddFolder: TMenuItem;
    N2: TMenuItem;
    PopupMenuDelete: TMenuItem;
    OpenDialogFile: TFileOpenDialog;
    ToolBarConfigurations: TToolBar;
    ButtonConfigurations: TToolButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionImportExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionAddFileExecute(Sender: TObject);
    procedure ActionAddFolderExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ListViewEntriesClick(Sender: TObject);
    procedure ComboBoxTargetDirChange(Sender: TObject);
    procedure CheckBoxSubDirsClick(Sender: TObject);
    procedure ButtonConfigurationsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FModified: Boolean;
    FDeployFile: TDeployFile;
    FActivePlatform: TTargetPlatform;
    FLastDir: String;
    FFormConfigurations: TFormConfigurations;
    procedure Open(const AFilename: String);
    procedure Import(const ADProjFilename: String);
    function CheckSave: Boolean;
    procedure Save;
    procedure ShowSettings; overload;
    procedure ShowSettings(const APlatform: TTargetPlatform); overload;
    procedure ShowEntry(const AEntry: TDeployEntry;
      const AActivate: Boolean);
    procedure UpdateControls;
    procedure UpdateCaption;
    procedure ApplyDeployment(const ASrc: TDeployFile;
      const ADst: TDprojFile); overload;
    procedure ApplyDeployment(const ASrcDir, ADstDir: String;
      const AEntry: TDeployEntry; const APlatform: TTargetPlatform;
      const ADst: TDprojFile); overload;
    procedure SetModified(const AValue: Boolean);
    procedure FormConfigurationsHide(Sender: TObject);
  private
    class function ConfigurationsToString(const AConfigs: TArray<String>): String; static;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  System.Types,
  System.UITypes,
  System.IOUtils;

const
  II_FILE   = 2;
  II_FOLDER = 3;

const
  YES_NO: array [Boolean] of String = ('No', 'Yes');

procedure TFormMain.ActionAddFileExecute(Sender: TObject);
var
  Entry: TDeployEntry;
  LocalName: String;
begin
  if (not OpenDialogFile.Execute) then
    Exit;

  OpenDialogFile.DefaultFolder := '';
  LocalName := OpenDialogFile.FileName;
  LocalName := ExtractRelativePath(FDeployFile.Directory, LocalName);
  Entry := FDeployFile.Add(FActivePlatform, LocalName, '.\', False, False);
  ShowEntry(Entry, True);
  SetModified(True);
end;

procedure TFormMain.ActionAddFolderExecute(Sender: TObject);
var
  Dir: String;
  Entry: TDeployEntry;
begin
  Dir := FLastDir;
  if (not SelectDirectory('Select folder to add', '', Dir)) then
    Exit;

  FLastDir := Dir;
  Dir := ExtractRelativePath(FDeployFile.Directory, Dir);
  Entry := FDeployFile.Add(FActivePlatform, Dir, '.\', True, False);
  ShowEntry(Entry, True);
  SetModified(True);
end;

procedure TFormMain.ActionDeleteExecute(Sender: TObject);
var
  I: Integer;
  Item: TListItem;
  Entry: TDeployEntry;
  HasDeleted: Boolean;
begin
  HasDeleted := False;
  for I := ListViewEntries.Items.Count - 1 downto 0 do
  begin
    Item := ListViewEntries.Items[I];
    if (Item.Selected) and FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry) then
    begin
      if (FDeployFile.Remove(Entry.LocalName, FActivePlatform)) then
      begin
        Item.Delete;
        HasDeleted := True;
      end;
    end;
  end;

  if (HasDeleted) then
  begin
    SetModified(True);
    UpdateControls;
  end;
end;

procedure TFormMain.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.ActionImportExecute(Sender: TObject);
begin
  if (not CheckSave) then
    Exit;

  if (OpenDialogDproj.Execute) then
    Import(OpenDialogDproj.FileName);
end;

procedure TFormMain.ActionOpenExecute(Sender: TObject);
begin
  if (not CheckSave) then
    Exit;

  if (OpenDialogGrdeploy.Execute) then
    Open(OpenDialogGrdeploy.FileName);
end;

procedure TFormMain.ActionSaveExecute(Sender: TObject);
begin
  Save;
end;

procedure TFormMain.ApplyDeployment(const ASrcDir, ADstDir: String;
  const AEntry: TDeployEntry; const APlatform: TTargetPlatform;
  const ADst: TDprojFile);
var
  Filename, LocalName, RemoteDir: String;
  SR: TSearchRec;
begin
  for Filename in TDirectory.GetFiles(ASrcDir) do
  begin
    LocalName := TPath.GetFileName(Filename);
    LocalName := TPath.Combine(TPath.Combine(AEntry.LocalName, ADstDir), LocalName);

    RemoteDir := TPath.Combine(AEntry.RemoteDir, ADstDir);
    ADst.Add(LocalName, RemoteDir, APlatform, AEntry.Configurations);
  end;

  if (AEntry.IncludeSubDirectories) then
  begin
    if (FindFirst(IncludeTrailingPathDelimiter(ASrcDir) + '*.*', faDirectory, SR) = 0) then
    repeat
      if (SR.Name[1] <> '.') and ((SR.Attr and faDirectory) <> 0) then
        ApplyDeployment(TPath.Combine(ASrcDir, SR.Name),
          TPath.Combine(ADstDir, SR.Name), AEntry, APlatform, ADst);
    until (FindNext(SR) <> 0);
    FindClose(SR);
  end;
end;

procedure TFormMain.ApplyDeployment(const ASrc: TDeployFile;
  const ADst: TDprojFile);
var
  P: TTargetPlatform;
  Entry: TDeployEntry;
  FullDirectory: String;
begin
  for P := Low(TTargetPlatform) to High(TTargetPlatform) do
  begin
    for Entry in ASrc.DeployEntries[P].Values do
    begin
      if (Entry.IsDirectory) then
      begin
        TDirectory.SetCurrentDirectory(FDeployFile.Directory);
        FullDirectory := TPath.GetFullPath(Entry.LocalName);
        ApplyDeployment(FullDirectory, '', Entry, P, ADst);
      end
      else
        ADst.Add(Entry.LocalName, Entry.RemoteDir, P, Entry.Configurations);
    end;
  end;
end;

procedure TFormMain.ButtonConfigurationsClick(Sender: TObject);
var
  Item: TListItem;
  Entry: TDeployEntry;
  P: TPoint;
begin
  Item := ListViewEntries.Selected;
  if (Item = nil) or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry)) then
    Exit;

  FFormConfigurations.SetSelectedConfigurations(Entry.Configurations);

  P := Point(0, ButtonConfigurations.Height);
  P := ButtonConfigurations.ClientToScreen(P);
  FFormConfigurations.SetBounds(P.X, P.Y, FFormConfigurations.Width, FFormConfigurations.Height);
  FFormConfigurations.Show;
end;

procedure TFormMain.CheckBoxSubDirsClick(Sender: TObject);
var
  Item: TListItem;
  Entry: TDeployEntry;
begin
  Item := ListViewEntries.Selected;
  if (ListViewEntries.SelCount <> 1) or (Item = nil)
    or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry))
  then
    Exit;

  if (not Entry.IsDirectory) then
    Exit;

  Entry.IncludeSubDirectories := CheckBoxSubDirs.Checked;
  FDeployFile.DeployEntries[FActivePlatform].AddOrSetValue(Item.Caption, Entry);
  Item.SubItems[1] := YES_NO[Entry.IncludeSubDirectories];
  SetModified(True);
end;

function TFormMain.CheckSave: Boolean;
begin
  if (not FModified) or (FDeployFile = nil) then
    Exit(True);

  case MessageDlg('Project has changed. Save changes?', TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], 0)
  of
    mrYes:
      begin
        Save;
        Result := True;
      end;

    mrNo:
      Result := True;
  else
    Result := False;
  end;
end;

procedure TFormMain.ComboBoxTargetDirChange(Sender: TObject);
var
  Item: TListItem;
  Entry: TDeployEntry;
begin
  Item := ListViewEntries.Selected;
  if (Item = nil) or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry)) then
    Exit;

  Entry.RemoteDir := ComboBoxTargetDir.Text;
  FDeployFile.DeployEntries[FActivePlatform].AddOrSetValue(Item.Caption, Entry);
  Item.SubItems[0] := Entry.RemoteDir;
  SetModified(True);
end;

class function TFormMain.ConfigurationsToString(
  const AConfigs: TArray<String>): String;
var
  I: Integer;
begin
  if (AConfigs = nil) then
    Exit('(All)');

  Result := '[' + AConfigs[0];
  for I := 1 to Length(AConfigs) - 1 do
    Result := Result + ', ' + AConfigs[I];

  Result := Result + ']';
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  if Assigned(FFormConfigurations) and (FFormConfigurations.Visible) then
    FFormConfigurations.Hide;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckSave;
end;

procedure TFormMain.FormConfigurationsHide(Sender: TObject);
var
  Item: TListItem;
  Entry: TDeployEntry;
begin
  Item := ListViewEntries.Selected;
  if (Item = nil) or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry)) then
    Exit;

  Entry.Configurations := FFormConfigurations.GetSelectedConfigurations;
  FDeployFile.DeployEntries[FActivePlatform].AddOrSetValue(Item.Caption, Entry);

  Item.SubItems[2] := ConfigurationsToString(Entry.Configurations);
  SetModified(True);
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Filename: String;
begin
  FFormConfigurations := TFormConfigurations.Create(Application);
  FFormConfigurations.OnHide := FormConfigurationsHide;

  if (ParamCount > 0) then
  begin
    Filename := ParamStr(1);
    if TFile.Exists(Filename) then
    begin
      Open(Filename);
      Exit;
    end;
  end;
  UpdateControls;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FDeployFile.Free;
end;

procedure TFormMain.Import(const ADProjFilename: String);
var
  P: TTargetPlatform;
  Src: TDprojFile.TDeployFile;
  Dst: TDeployEntry;
  DprojFile: TDprojFile;
begin
  DprojFile := TDprojFile.Create(ADProjFilename);
  try
    DprojFile.Load;

    FreeAndNil(FDeployFile);
    FDeployFile := TDeployFile.Create(TPath.ChangeExtension(ADProjFilename, '.grdeploy'));
    FDeployFile.Configurations := DprojFile.Configurations;

    for P := Low(TTargetPlatform) to High(TTargetPlatform) do
    begin
      for Src in DprojFile.DeployFiles[P].Values do
      begin
        Dst.Initialize;
        Dst.LocalName := Src.LocalName;
        Dst.RemoteDir := Src.RemoteDir;
        FDeployFile.DeployEntries[P].AddOrSetValue(Dst.LocalName, Dst);
      end;
    end;
  finally
    DprojFile.Free;
  end;

  ShowSettings;
  SetModified(True);
end;

procedure TFormMain.ListViewEntriesClick(Sender: TObject);
var
  Entry: TDeployEntry;
begin
  if (ListViewEntries.SelCount = 1) and Assigned(ListViewEntries.Selected)
    and (FDeployFile.DeployEntries[FActivePlatform].TryGetValue(ListViewEntries.Selected.Caption, Entry)) then
  begin
    ComboBoxTargetDir.Text := Entry.RemoteDir;
    CheckBoxSubDirs.Checked := Entry.IncludeSubDirectories;
  end
  else
  begin
    ComboBoxTargetDir.Text := '';
    CheckBoxSubDirs.Checked := False;
  end;
  UpdateControls;
end;

procedure TFormMain.Open(const AFilename: String);
begin
  FreeAndNil(FDeployFile);
  FDeployFile := TDeployFile.Create(AFilename);
  FDeployFile.Load;

  ShowSettings;
  SetModified(False);
end;

procedure TFormMain.Save;
var
  DprojFile: TDprojFile;
begin
  if Assigned(FDeployFile) then
  begin
    DprojFile := TDprojFile.Create(TPath.ChangeExtension(FDeployFile.Filename, '.dproj'));
    try
      DprojFile.Load;

      ApplyDeployment(FDeployFile, DprojFile);

      DprojFile.Save;
    finally
      DprojFile.Free;
    end;
    FDeployFile.Save;
  end;

  SetModified(False);
end;

procedure TFormMain.SetModified(const AValue: Boolean);
begin
  if (AValue <> FModified) then
  begin
    FModified := AValue;
    UpdateCaption;
  end;
end;

procedure TFormMain.ShowEntry(const AEntry: TDeployEntry;
  const AActivate: Boolean);
var
  Item: TListItem;
  I: Integer;
begin
  Item := ListViewEntries.Items.Add;
  if (AEntry.IsDirectory) then
    Item.ImageIndex := II_FOLDER
  else
    Item.ImageIndex := II_FILE;
  Item.Caption := AEntry.LocalName;
  Item.SubItems.Add(AEntry.RemoteDir);

  if (AEntry.IsDirectory) then
    Item.SubItems.Add(YES_NO[AEntry.IncludeSubDirectories])
  else
    Item.SubItems.Add('');

  Item.SubItems.Add(ConfigurationsToString(AEntry.Configurations));

  if AActivate then
  begin
    for I := 0 to ListViewEntries.Items.Count - 1 do
      ListViewEntries.Items[I].Selected := (ListViewEntries.Items[I] = Item);
    ListViewEntriesClick(ListViewEntries);
  end;
end;

procedure TFormMain.ShowSettings(const APlatform: TTargetPlatform);
var
  Entry: TDeployEntry;
begin
  FActivePlatform := APlatform;
  ComboBoxTargetDir.Items.BeginUpdate;
  try
    ComboBoxTargetDir.Items.Clear;
    ComboBoxTargetDir.Items.Add('.\');
    if (APlatform = TTargetPlatform.iOS) then
      ComboBoxTargetDir.Items.Add('StartUp\Documents\')
    else
    begin
      ComboBoxTargetDir.Items.Add('assets\internal');
      ComboBoxTargetDir.Items.Add('assets\external');
      ComboBoxTargetDir.Items.Add('res\values\');
    end;
  finally
    ComboBoxTargetDir.Items.EndUpdate;
  end;

  if Assigned(FDeployFile) then
  begin
    ListViewEntries.Items.BeginUpdate;
    try
      ListViewEntries.Items.Clear;

      for Entry in FDeployFile.DeployEntries[APlatform].Values do
        ShowEntry(Entry, False);
    finally
      ListViewEntries.Items.EndUpdate;
    end;
  end;

  UpdateControls;
end;

procedure TFormMain.ShowSettings;
begin
  TabControl.TabIndex := 0;
  FFormConfigurations.SetConfigurations(FDeployFile.Configurations);
  UpdateCaption;
  OpenDialogFile.DefaultFolder := FDeployFile.Directory;
  FLastDir := FDeployFile.Directory;
  ShowSettings(TTargetPlatform.iOS);
end;

procedure TFormMain.TabControlChange(Sender: TObject);
begin
  if (TabControl.TabIndex = 0) then
    ShowSettings(TTargetPlatform.iOS)
  else
    ShowSettings(TTargetPlatform.Android);
end;

procedure TFormMain.UpdateCaption;
var
  S: String;
begin
  if (FModified) then
    S := '*'
  else
    S := '';

  if Assigned(FDeployFile) then
    S := S + TPath.GetFileName(FDeployFile.Filename) + ' - ';
  Caption := S + 'DeployMan';
end;

procedure TFormMain.UpdateControls;
var
  B: Boolean;
begin
  B := (ListViewEntries.Selected <> nil);
  ActionDelete.Enabled := B;

  B := B and (ListViewEntries.SelCount = 1);
  LabelTargetDir.Enabled := B;
  ComboBoxTargetDir.Enabled := B;
  CheckBoxSubDirs.Enabled := B and (ListViewEntries.Selected.ImageIndex = II_FOLDER);
  ButtonConfigurations.Enabled := B;
end;

end.
