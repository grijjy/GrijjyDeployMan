unit View.Main;

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
  View.Configurations,
  Model.Common,
  Model.DelphiProjectFile,
  Model.GrijjyDeployFile;

type
  TViewMain = class(TForm)
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
    FViewConfigurations: TViewConfigurations;
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
      const ADst: TDelphiProjectFile); overload;
    procedure ApplyDeployment(const ASrcDir, ADstDir: String;
      const AEntry: TDeployEntry; const APlatform: TTargetPlatform;
      const ADst: TDelphiProjectFile); overload;
    procedure SetModified(const AValue: Boolean);
    procedure ViewConfigurationsHide(Sender: TObject);
  private
    class function ConfigurationsToString(const AConfigs: TArray<String>): String; static;
  public
    { Public declarations }
  end;

var
  ViewMain: TViewMain;

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

procedure TViewMain.ActionAddFileExecute(Sender: TObject);
begin
  if (not OpenDialogFile.Execute) then
    Exit;

  OpenDialogFile.DefaultFolder := '';
  var LocalName := OpenDialogFile.FileName;
  LocalName := ExtractRelativePath(FDeployFile.Directory, LocalName);
  var Entry := FDeployFile.Add(FActivePlatform, LocalName, '.\', False, False);
  ShowEntry(Entry, True);
  SetModified(True);
end;

procedure TViewMain.ActionAddFolderExecute(Sender: TObject);
begin
  var Dir := FLastDir;
  if (not SelectDirectory('Select folder to add', '', Dir)) then
    Exit;

  FLastDir := Dir;
  Dir := ExtractRelativePath(FDeployFile.Directory, Dir);
  var Entry := FDeployFile.Add(FActivePlatform, Dir, '.\', True, False);
  ShowEntry(Entry, True);
  SetModified(True);
end;

procedure TViewMain.ActionDeleteExecute(Sender: TObject);
begin
  var Entry: TDeployEntry;
  var HasDeleted := False;
  for var I := ListViewEntries.Items.Count - 1 downto 0 do
  begin
    var Item := ListViewEntries.Items[I];
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

procedure TViewMain.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TViewMain.ActionImportExecute(Sender: TObject);
begin
  if (not CheckSave) then
    Exit;

  if (OpenDialogDproj.Execute) then
    Import(OpenDialogDproj.FileName);
end;

procedure TViewMain.ActionOpenExecute(Sender: TObject);
begin
  if (not CheckSave) then
    Exit;

  if (OpenDialogGrdeploy.Execute) then
    Open(OpenDialogGrdeploy.FileName);
end;

procedure TViewMain.ActionSaveExecute(Sender: TObject);
begin
  Save;
end;

procedure TViewMain.ApplyDeployment(const ASrcDir, ADstDir: String;
  const AEntry: TDeployEntry; const APlatform: TTargetPlatform;
  const ADst: TDelphiProjectFile);
begin
  for var Filename in TDirectory.GetFiles(ASrcDir) do
  begin
    var LocalName := TPath.GetFileName(Filename);
    LocalName := TPath.Combine(TPath.Combine(AEntry.LocalName, ADstDir), LocalName);

    var RemoteDir := TPath.Combine(AEntry.RemoteDir, ADstDir);
    ADst.Add(LocalName, RemoteDir, APlatform, AEntry.Configurations);
  end;

  if (AEntry.IncludeSubDirectories) then
  begin
    var SR: TSearchRec;
    if (FindFirst(IncludeTrailingPathDelimiter(ASrcDir) + '*.*', faDirectory, SR) = 0) then
    repeat
      if (SR.Name[1] <> '.') and ((SR.Attr and faDirectory) <> 0) then
        ApplyDeployment(TPath.Combine(ASrcDir, SR.Name),
          TPath.Combine(ADstDir, SR.Name), AEntry, APlatform, ADst);
    until (FindNext(SR) <> 0);
    FindClose(SR);
  end;
end;

procedure TViewMain.ApplyDeployment(const ASrc: TDeployFile;
  const ADst: TDelphiProjectFile);
begin
  for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
  begin
    for var Entry in ASrc.DeployEntries[P].Values do
    begin
      if (Entry.IsDirectory) then
      begin
        TDirectory.SetCurrentDirectory(FDeployFile.Directory);
        var FullDirectory := TPath.GetFullPath(Entry.LocalName);
        ApplyDeployment(FullDirectory, '', Entry, P, ADst);
      end
      else
        ADst.Add(Entry.LocalName, Entry.RemoteDir, P, Entry.Configurations);
    end;
  end;
end;

procedure TViewMain.ButtonConfigurationsClick(Sender: TObject);
begin
  var Entry: TDeployEntry;
  var Item := ListViewEntries.Selected;
  if (Item = nil) or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry)) then
    Exit;

  FViewConfigurations.SetSelectedConfigurations(Entry.Configurations);

  var P := Point(0, ButtonConfigurations.Height);
  P := ButtonConfigurations.ClientToScreen(P);
  FViewConfigurations.SetBounds(P.X, P.Y, FViewConfigurations.Width, FViewConfigurations.Height);
  FViewConfigurations.Show;
end;

procedure TViewMain.CheckBoxSubDirsClick(Sender: TObject);
begin
  var Entry: TDeployEntry;
  var Item := ListViewEntries.Selected;
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

function TViewMain.CheckSave: Boolean;
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

procedure TViewMain.ComboBoxTargetDirChange(Sender: TObject);
begin
  var Entry: TDeployEntry;
  var Item := ListViewEntries.Selected;
  if (Item = nil) or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry)) then
    Exit;

  Entry.RemoteDir := ComboBoxTargetDir.Text;
  FDeployFile.DeployEntries[FActivePlatform].AddOrSetValue(Item.Caption, Entry);
  Item.SubItems[0] := Entry.RemoteDir;
  SetModified(True);
end;

class function TViewMain.ConfigurationsToString(
  const AConfigs: TArray<String>): String;
begin
  if (AConfigs = nil) then
    Exit('(All)');

  Result := '[' + AConfigs[0];
  for var I := 1 to Length(AConfigs) - 1 do
    Result := Result + ', ' + AConfigs[I];

  Result := Result + ']';
end;

procedure TViewMain.FormActivate(Sender: TObject);
begin
  if Assigned(FViewConfigurations) and (FViewConfigurations.Visible) then
    FViewConfigurations.Hide;
end;

procedure TViewMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckSave;
end;

procedure TViewMain.FormCreate(Sender: TObject);
begin
  FViewConfigurations := TViewConfigurations.Create(Application);
  FViewConfigurations.OnHide := ViewConfigurationsHide;

  if (ParamCount > 0) then
  begin
    var Filename := ParamStr(1);
    if TFile.Exists(Filename) then
    begin
      Open(Filename);
      Exit;
    end;
  end;
  UpdateControls;
end;

procedure TViewMain.FormDestroy(Sender: TObject);
begin
  FDeployFile.Free;
end;

procedure TViewMain.Import(const ADProjFilename: String);
begin
  var DprojFile := TDelphiProjectFile.Create(ADProjFilename);
  try
    DprojFile.Load;

    FreeAndNil(FDeployFile);
    FDeployFile := TDeployFile.Create(TPath.ChangeExtension(ADProjFilename, '.grdeploy'));
    FDeployFile.Configurations := DprojFile.Configurations;

    for var P := Low(TTargetPlatform) to High(TTargetPlatform) do
    begin
      for var Src in DprojFile.DeployFiles[P].Values do
      begin
        var Dst: TDeployEntry;
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

procedure TViewMain.ListViewEntriesClick(Sender: TObject);
begin
  var Entry: TDeployEntry;
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

procedure TViewMain.Open(const AFilename: String);
begin
  FreeAndNil(FDeployFile);
  FDeployFile := TDeployFile.Create(AFilename);
  FDeployFile.Load;

  var DprojFile := TDelphiProjectFile.Create(
    TPath.ChangeExtension(FDeployFile.Filename, '.dproj'));
  try
    DprojFile.Load;
    FDeployFile.Configurations := DprojFile.Configurations;
  finally
    DprojFile.Free;
  end;

  ShowSettings;
  SetModified(False);
end;

procedure TViewMain.Save;
begin
  if Assigned(FDeployFile) then
  begin
    var DprojFile := TDelphiProjectFile.Create(
      TPath.ChangeExtension(FDeployFile.Filename, '.dproj'));
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

procedure TViewMain.SetModified(const AValue: Boolean);
begin
  if (AValue <> FModified) then
  begin
    FModified := AValue;
    UpdateCaption;
  end;
end;

procedure TViewMain.ShowEntry(const AEntry: TDeployEntry;
  const AActivate: Boolean);
begin
  var Item := ListViewEntries.Items.Add;
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
    for var I := 0 to ListViewEntries.Items.Count - 1 do
      ListViewEntries.Items[I].Selected := (ListViewEntries.Items[I] = Item);
    ListViewEntriesClick(ListViewEntries);
  end;
end;

procedure TViewMain.ShowSettings(const APlatform: TTargetPlatform);
begin
  FActivePlatform := APlatform;
  ComboBoxTargetDir.Items.BeginUpdate;
  try
    ComboBoxTargetDir.Items.Clear;
    ComboBoxTargetDir.Items.Add('.\');
    case APlatform of
      TTargetPlatform.iOS: ComboBoxTargetDir.Items.Add('StartUp\Documents\');
      TTargetPlatform.Android:
        begin
          ComboBoxTargetDir.Items.Add('assets\internal');
          ComboBoxTargetDir.Items.Add('assets\external');
          ComboBoxTargetDir.Items.Add('res\values\');
        end;
      TTargetPlatform.MacOS:
        begin
          ComboBoxTargetDir.Items.Add('Contents\MacOS\');
          ComboBoxTargetDir.Items.Add('Contents\Resources\');
          ComboBoxTargetDir.Items.Add('Contents\Resources\StartUp\');
        end;
      TTargetPlatform.Linux: ComboBoxTargetDir.Items.Add('StartUp\');
    else
    end;
  finally
    ComboBoxTargetDir.Items.EndUpdate;
  end;

  if Assigned(FDeployFile) then
  begin
    ListViewEntries.Items.BeginUpdate;
    try
      ListViewEntries.Items.Clear;

      for var Entry in FDeployFile.DeployEntries[APlatform].Values do
        ShowEntry(Entry, False);
    finally
      ListViewEntries.Items.EndUpdate;
    end;
  end;

  UpdateControls;
end;

procedure TViewMain.ShowSettings;
begin
  TabControl.TabIndex := 0;
  FViewConfigurations.SetAllConfigurations(FDeployFile.Configurations);
  UpdateCaption;
  OpenDialogFile.DefaultFolder := FDeployFile.Directory;
  FLastDir := FDeployFile.Directory;
  ShowSettings(TTargetPlatform.iOS);
end;

procedure TViewMain.TabControlChange(Sender: TObject);
begin
  case TabControl.TabIndex of
    0: ShowSettings(TTargetPlatform.iOS);
    1: ShowSettings(TTargetPlatform.Android);
    2: ShowSettings(TTargetPlatform.MacOS);
    3: ShowSettings(TTargetPlatform.Linux);
  else
  end;
end;

procedure TViewMain.UpdateCaption;
begin
  var S := '';
  if (FModified) then
    S := '*';

  if Assigned(FDeployFile) then
    S := S + TPath.GetFileName(FDeployFile.Filename) + ' - ';
  Caption := S + 'Grijjy Deployment Manager';
end;

procedure TViewMain.UpdateControls;
begin
  var B := (ListViewEntries.Selected <> nil);
  ActionDelete.Enabled := B;

  B := B and (ListViewEntries.SelCount = 1);
  LabelTargetDir.Enabled := B;
  ComboBoxTargetDir.Enabled := B;
  CheckBoxSubDirs.Enabled := B and (ListViewEntries.Selected.ImageIndex = II_FOLDER);
  ButtonConfigurations.Enabled := B;
end;

procedure TViewMain.ViewConfigurationsHide(Sender: TObject);
begin
  var Entry: TDeployEntry;
  var Item := ListViewEntries.Selected;
  if (Item = nil) or (not FDeployFile.DeployEntries[FActivePlatform].TryGetValue(Item.Caption, Entry)) then
    Exit;

  Entry.Configurations := FViewConfigurations.GetSelectedConfigurations;
  FDeployFile.DeployEntries[FActivePlatform].AddOrSetValue(Item.Caption, Entry);

  Item.SubItems[2] := ConfigurationsToString(Entry.Configurations);
  SetModified(True);
end;

end.
