program SAuto;

uses
  Forms,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal},
  objExecuteScript in 'objExecuteScript.pas',
  LibSAuto in 'LibSAuto.pas',
  untConfiguracoes in 'untConfiguracoes.pas' {frmConfiguracoes},
  untAtualizaCliente in 'untAtualizaCliente.pas' {frmAtualizaCliente},
  untLogin in 'untLogin.pas' {frmLogin},
  objExecuteScriptAtualizaCliente in 'objExecuteScriptAtualizaCliente.pas',
  LibAtualizaCliente in 'LibAtualizaCliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Script Automático - Renal Manager';

  if ParamStr(1) = PARAM001
   then Application.CreateForm(TfrmAtualizaCliente, frmAtualizaCliente);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
