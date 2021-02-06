program DeployMan;

uses
  Vcl.Forms,
  FMain in 'FMain.pas' {FormMain},
  dprojFile in 'dprojFile.pas',
  Common in 'Common.pas',
  grdeployFile in 'grdeployFile.pas',
  FConfigurations in 'FConfigurations.pas' {FormConfigurations};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
