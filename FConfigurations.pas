unit FConfigurations;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls,
  Vcl.CheckLst, Vcl.ExtCtrls;

type
  TFormConfigurations = class(TForm)
    ListConfigurations: TCheckListBox;
    ToolBar: TToolBar;
    ToolButtonAll: TToolButton;
    ToolButtonNone: TToolButton;
    PanelContainer: TPanel;
    ToolButtonClose: TToolButton;
    ToolButton1: TToolButton;
    procedure ToolButtonAllClick(Sender: TObject);
    procedure ToolButtonNoneClick(Sender: TObject);
    procedure ToolButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetConfigurations(const AConfigurations: TArray<String>);
    procedure SetSelectedConfigurations(const AConfigurations: TArray<String>);
    function GetSelectedConfigurations: TArray<String>;
  end;

implementation

{$R *.dfm}

{ TFormConfigurations }

function TFormConfigurations.GetSelectedConfigurations: TArray<String>;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ListConfigurations.Items.Count - 1 do
  begin
    if (ListConfigurations.Checked[I]) then
      Result := Result + [ListConfigurations.Items[I]];
  end;

  if (Length(Result) = ListConfigurations.Items.Count) then
    { Nil means all }
    Result := nil;
end;

procedure TFormConfigurations.SetConfigurations(
  const AConfigurations: TArray<String>);
var
  Config: String;
begin
  ListConfigurations.Items.BeginUpdate;
  try
    ListConfigurations.Items.Clear;
    for Config in AConfigurations do
      ListConfigurations.Items.Add(Config);
  finally
    ListConfigurations.Items.EndUpdate;
  end;
  ClientHeight := ToolBar.Height + (Length(AConfigurations) * ListConfigurations.ItemHeight) + 2;
end;

procedure TFormConfigurations.SetSelectedConfigurations(
  const AConfigurations: TArray<String>);
var
  Config: String;
  Index: Integer;
begin
  if (AConfigurations = nil) then
  begin
    ListConfigurations.CheckAll(TCheckBoxState.cbChecked);
    Exit;
  end;

  ListConfigurations.CheckAll(TCheckBoxState.cbUnchecked);
  for Config in AConfigurations do
  begin
    Index := ListConfigurations.Items.IndexOf(Config);
    if (Index >= 0) then
      ListConfigurations.Checked[Index] := True;
  end;
end;

procedure TFormConfigurations.ToolButtonAllClick(Sender: TObject);
begin
  ListConfigurations.CheckAll(TCheckBoxState.cbChecked);
end;

procedure TFormConfigurations.ToolButtonCloseClick(Sender: TObject);
begin
  Hide;
end;

procedure TFormConfigurations.ToolButtonNoneClick(Sender: TObject);
begin
  ListConfigurations.CheckAll(TCheckBoxState.cbUnchecked);
end;

end.
