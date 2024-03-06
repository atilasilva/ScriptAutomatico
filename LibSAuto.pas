unit LibSAuto;

interface

uses untPrincipal, Inifiles, SysUtils, Forms, Controls, Messages;

const
  NO_STRING  = '';
  LINEFEED   = #13+#10;
  NOMEARQINI = 'SAConfig.ini';
  CAMINHOPADRAOATUALIZA = 'C:\Renal-Manager\Src';
  PARAM001   = '/h'; //Inicia "hidden" para atualização no cliente.

  DEFAULTUSERNAME = 'sysdba';
  DEFAULTPASSWORD = 'fmc_clinicas';
  DEFAULTDATABASENAME = 'RENALMGR.GDB';

  //Constantes para erros
  SAUTOERROR001 = 'Caminho para as bases não definido.';
  SAUTOERROR002 = 'Nenhuma base encontrada no diretório.';
  SAUTOERROR003 = 'Ocorreu um erro durante o processamento da base.';
  SAUTOERROR004 = 'O diretório selecionado deve conter as bases separadas por sub-diretórios.';
  SAUTOERROR005 = 'O script de atualização não foi encontrado ou já foi executado. Contacte o suporte.';
  SAUTOERROR006 = 'O caminho informado para a base é inválido. Favor executar o Configurador Renal.';
  SAUTOERROR007 = 'Ocorreram um ou mais erros ao executar script. Contacte o suporte informando o erro.';
  SAUTOERROR008 = 'Script executado com sucesso.';
  SAUTOERROR009 = 'O arquivo de configurações de bases do Renal Manager está inválido ou não foi encontrado. Favor executar o Configurador Renal.';
  SAUTOERROR010 = 'Selecione uma unidade.';

type
  TConfiguracoesSAuto = class
    class function GetUsuarioPadrao: string;
    class function GetSenhaPadrao: string;
    class function GetDefaultDatabaseName: string;
  end;

var
  IniReg: TIniFile;

procedure ControlNavigation(Sender: TObject; var Key: Char);

implementation

procedure ControlNavigation(Sender: TObject; var Key: Char);
begin
  if Key = #13
   then begin
    TForm(Sender).Perform(wm_NextDlgCtl,0,0);
    Key := #0;
   end;
end;

{ TConfiguracoesSAuto }

class function TConfiguracoesSAuto.GetDefaultDatabaseName: string;
begin
  Result := IniReg.ReadString('Database', 'DefaultName', DEFAULTDATABASENAME)
end;

class function TConfiguracoesSAuto.GetSenhaPadrao;
begin
  Result := IniReg.ReadString('Database', 'Senha', DEFAULTPASSWORD);

  if Result = NO_STRING
   then Result := DEFAULTPASSWORD
end;

class function TConfiguracoesSAuto.GetUsuarioPadrao;
begin
  Result := IniReg.ReadString('Database', 'Username', DEFAULTUSERNAME);

  if Result = NO_STRING
   then Result := DEFAULTUSERNAME
end;

initialization
  IniReg := TIniFile.Create(ExtractFilePath(Application.ExeName) + NOMEARQINI);
 
finalization
  IniReg.Free

end.

