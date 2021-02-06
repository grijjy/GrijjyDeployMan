program DeployMan;

uses
  Vcl.Forms,
  View.Main in 'Views\View.Main.pas' {ViewMain},
  Model.DelphiProjectFile in 'Models\Model.DelphiProjectFile.pas',
  Model.Common in 'Models\Model.Common.pas',
  Model.GrijjyDeployFile in 'Models\Model.GrijjyDeployFile.pas',
  View.Configurations in 'Views\View.Configurations.pas' {ViewConfigurations};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewMain, ViewMain);
  Application.Run;
end.
