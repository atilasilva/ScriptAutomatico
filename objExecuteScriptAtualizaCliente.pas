unit objExecuteScriptAtualizaCliente;

interface

uses SysUtils, objExecuteScript, Forms, Classes;

type
  TExecuteScriptAtualizaCliente = class
  private
    FExecuteScript: TExecuteScript;
    FProcessHasErrors: boolean;
    FErroCorrente: string;
    FProcessHasFatalErrors: boolean;
    FIP: string;
    FPathDatabaseName: string;
  protected
    procedure SetExecuteScript(const Value: TExecuteScript);
    procedure SetErroCorrente(const Value: string);
    procedure SetProcessHasErrors(const Value: boolean);
    procedure SetProcessHasFatalErrors(const Value: boolean);
    procedure SetIP(const Value: string);
    procedure SetPathDatabaseName(const Value: string);

    procedure CreateError(Error: string; Fatal: boolean = true);
  public
    constructor Create;
    destructor Destroy; override;

    property ExecuteScript: TExecuteScript read FExecuteScript write SetExecuteScript;
    property ErroCorrente: string read FErroCorrente  write SetErroCorrente;
    property ProcessHasErrors: boolean read FProcessHasErrors    write SetProcessHasErrors;
    property ProcessHasFatalErrors: boolean read FProcessHasFatalErrors    write SetProcessHasFatalErrors;
    property PathDatabaseName: string read FPathDatabaseName write SetPathDatabaseName;
    property IP: string read FIP write SetIP;

    procedure Execute;
  end;

implementation

uses LibSAuto;

{ TExecuteScriptAtualizaCliente }

constructor TExecuteScriptAtualizaCliente.Create;
begin
  ExecuteScript := TExecuteScript.Create;
end;

procedure TExecuteScriptAtualizaCliente.CreateError(Error: string; Fatal: boolean = true);
begin
  ErroCorrente          := Error;
  ProcessHasFatalErrors := Fatal
end;

destructor TExecuteScriptAtualizaCliente.Destroy;
begin
  ExecuteScript.Free;

  inherited;
end;

procedure TExecuteScriptAtualizaCliente.Execute;
var
  SR:        TSearchRec;
  Index:     Integer;
  ScriptSQL: TStringList;

begin
  ScriptSQL := TStringList.Create;

  try
   Index := FindFirst(ExtractFilePath(Application.ExeName) + '*.sql', faAnyFile, SR);

   if not(Index = 0)
    then begin
     CreateError(SAUTOERROR005 + LINEFEED + 'Caminho padrão para os scripts: ' + ExtractFilePath(Application.ExeName));
     Abort
    end;

   with ExecuteScript do
    begin
     Usuario := TConfiguracoesSAuto.GetUsuarioPadrao;
     Senha   := TConfiguracoesSAuto.GetSenhaPadrao;

     ContinuarScriptIgnorandoErros := false;

     if IP = NO_STRING
      then try AbreDatabase(PathDatabaseName) except CreateError(SAUTOERROR006 + LINEFEED + 'Caminho: ' + PathDatabaseName + '.'); Abort end
      else try AbreDatabase(IP + ':' + PathDatabaseName) except CreateError(SAUTOERROR006 + LINEFEED + 'Caminho: ' + IP + ':' + PathDatabaseName + '.'); Abort end;

     while Index = 0 do
      begin
       ScriptSQL.LoadFromFile(ExtractFilePath(Application.ExeName) + SR.Name);
       Script := ScriptSQL.Text;

       Execute;

       if ProcessHasErrors
        then begin
         CreateError(SAUTOERROR007 + LINEFEED + 'Erro: ' + ErroCorrente);
         DeleteFile(ExtractFilePath(Application.ExeName) + SR.Name);
         Abort
        end;

       if FileExists(ExtractFilePath(Application.ExeName) + ChangeFileExt(SR.Name, '.sbk'))
        then DeleteFile(ExtractFilePath(Application.ExeName) + ChangeFileExt(SR.Name, '.sbk'));
        
       RenameFile(ExtractFilePath(Application.ExeName) + SR.Name, ExtractFilePath(Application.ExeName) + ChangeFileExt(SR.Name, '.sbk'));
       Index := FindNext(SR)
      end
    end
  finally
   ScriptSQL.Free;
  end
end;

procedure TExecuteScriptAtualizaCliente.SetErroCorrente(
  const Value: string);
begin
  FErroCorrente := Value;

  FProcessHasErrors := not(FErroCorrente = NO_STRING)
end;

procedure TExecuteScriptAtualizaCliente.SetExecuteScript(
  const Value: TExecuteScript);
begin
  FExecuteScript := Value;
end;

procedure TExecuteScriptAtualizaCliente.SetIP(const Value: string);
begin
  FIP := Value;
end;

procedure TExecuteScriptAtualizaCliente.SetPathDatabaseName(
  const Value: string);
begin
  FPathDatabaseName := Value;
end;

procedure TExecuteScriptAtualizaCliente.SetProcessHasErrors(
  const Value: boolean);
begin
  FProcessHasErrors := Value;
end;

procedure TExecuteScriptAtualizaCliente.SetProcessHasFatalErrors(
  const Value: boolean);
begin
  FProcessHasFatalErrors := Value;
end;

end.
