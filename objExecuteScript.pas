unit objExecuteScript;

interface

uses SysUtils, StdCtrls, Forms, DBTables, IBScript, IBDatabase, IB, Dialogs, ComCtrls;

type
  TExecuteScript = class
  private
    IBDatabase:    TIBDatabase;
    IBTransacao:   TIBTransaction;
    IBScript:      TIBScript;

    FStatusBox:    TListBox;
    FScript:       string;

    FUsuario:      string;
    FSenha:        string;
    FCaminhoBases: TTreeNode;
    FDefaultName:  string;
    FCaminhoRaiz:  string;
    FBaseEmProcessamento: string;
    FContinuarScriptIgnorandoErros: boolean;
    FErroCorrente: string;
    FProcessHasErrors: boolean;
  protected
    procedure SetStatusBox(const Value: TListBox);
    procedure SetScript(const Value: string);
    procedure SetCaminhoBases(const Value: TTreeNode);
    procedure SetCaminhoRaiz(const Value: string);
    procedure SetBaseEmProcessamento(const Value: string);
    procedure SetContinuarScriptIgnorandoErros(const Value: boolean);
    procedure SetErroCorrente(const Value: string);
    procedure SetProcessHasErrors(const Value: boolean);

    procedure TreeviewToListaDiretorios(TreeNode: TTreeNode);
    procedure DeleteFromListaDiretorios(var ListaDiretorios: string; Item: string);
    procedure GetNextDiretorio;
    procedure AbrePrimeiroArquivo;
    function AbreProximoArquivo: integer;

    procedure BeforeIniciaScript;
    procedure AfterScriptComplete;
    procedure ClearPropertys;

    procedure IBScriptExecuteError(Sender: TObject; Error,
      SQLText: string; LineIndex: integer; var Ignore: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    property CaminhoBases: TTreeNode                read FCaminhoBases        write SetCaminhoBases;
    property StatusBox:    TListBox                 read FStatusBox           write SetStatusBox;
    property Script:       string                   read FScript              write SetScript;
    property CaminhoRaiz:  string                   read FCaminhoRaiz         write SetCaminhoRaiz;
    property BaseEmProcessamento: string            read FBaseEmProcessamento write SetBaseEmProcessamento;
    property Usuario: string                        read FUsuario             write FUsuario;
    property Senha: string                          read FSenha               write FSenha;
    property ContinuarScriptIgnorandoErros: boolean read FContinuarScriptIgnorandoErros write SetContinuarScriptIgnorandoErros;
    property ErroCorrente: string                   read FErroCorrente        write SetErroCorrente;
    property ProcessHasErrors: boolean              read FProcessHasErrors    write SetProcessHasErrors;

    procedure Execute;
    procedure IniciaScript;
    procedure AbreDatabase(Caminho: string);
  end;

implementation

uses LibSAuto;

var
  ListaDiretorios, Diretorio: string;

{ TExecuteScript }

procedure TExecuteScript.AbreDatabase(Caminho: string);
begin
  Application.ProcessMessages;

  BaseEmProcessamento := Caminho;

  IBDatabase.Close;
  IBDatabase.DatabaseName       := Caminho;
  IBDatabase.TraceFlags         := [tfQPrepare,tfQExecute,tfQFetch,tfError,tfStmt,tfConnect,tfTransact,tfBlob,tfService,tfMisc];
  IBDatabase.LoginPrompt        := false;
  IBDatabase.DefaultTransaction := IBTransacao;
  IBDatabase.Params.Append('user_name=' + FUsuario);
  IBDatabase.Params.Append('password='  + FSenha);
  IBDatabase.Open;
end;

procedure TExecuteScript.AbrePrimeiroArquivo;
begin
  Diretorio := FileSearch(FDefaultName, ListaDiretorios);

  if Diretorio = NO_STRING
   then begin
    if FileExists(CaminhoRaiz + '\' + FDefaultName)
     then AbreDatabase(CaminhoRaiz + '\' + FDefaultName)
     else
      begin
       StatusBox.Items.Append(SAUTOERROR004);
       Abort
      end
   end
  else AbreDatabase(Diretorio)
end;

function TExecuteScript.AbreProximoArquivo: integer;
begin
  GetNextDiretorio;

  if Diretorio = NO_STRING
   then Result := 0
   else
    begin
     AbreDatabase(Diretorio);
     Result := 1
    end
end;

procedure TExecuteScript.AfterScriptComplete;
begin
  if IBDatabase.Connected
   then IBDatabase.Close;
end;

procedure TExecuteScript.BeforeIniciaScript;
begin
  ClearPropertys;

  if not Assigned(CaminhoBases)
   then begin
    StatusBox.Items.Append(SAUTOERROR001);
    Abort;
   end;

  TreeviewToListaDiretorios(CaminhoBases)
end;

procedure TExecuteScript.ClearPropertys;
begin
  FDefaultName  := TConfiguracoesSAuto.GetDefaultDatabaseName;
  FUsuario      := TConfiguracoesSAuto.GetUsuarioPadrao;
  FSenha        := TConfiguracoesSAuto.GetSenhaPadrao;

  BaseEmProcessamento := NO_STRING;
  FErroCorrente       := NO_STRING
end;

constructor TExecuteScript.Create;
begin
  IBDatabase   := TIBDatabase.Create(nil);
  IBScript     := TIBScript.Create(nil);
  IBScript.OnExecuteError := IBScriptExecuteError;

  IBTransacao  := TIBTransaction.Create(nil);
  IBTransacao.Params.Add('read_committed');
  IBTransacao.Params.Add('rec_version');
  IBTransacao.Params.Add('nowait');

  FCaminhoBases := nil;
  FStatusBox    := nil;

  FContinuarScriptIgnorandoErros := true;

  ClearPropertys
end;

procedure TExecuteScript.DeleteFromListaDiretorios(
  var ListaDiretorios: string; Item: string);
begin
  ListaDiretorios := Copy(ListaDiretorios, 1, Pred(Pos(Item, ListaDiretorios))) +
                     Copy(ListaDiretorios, Pos(Item, ListaDiretorios) + Length(Item) + 1, Length(ListaDiretorios))
end;

destructor TExecuteScript.Destroy;
begin
  IBDatabase.Free;
  IBScript.Free;
  IBTransacao.Free;

  inherited
end;

procedure TExecuteScript.Execute;
begin
  ErroCorrente := NO_STRING;

  IBScript.Database       := IBDatabase;
  IBScript.Script.Text    := Script;
  IBScript.ExecuteScript
end;

procedure TExecuteScript.GetNextDiretorio;
begin
  DeleteFromListaDiretorios(ListaDiretorios, ExtractFileDir(Diretorio));
  Diretorio := FileSearch(FDefaultName, ListaDiretorios);
end;

procedure TExecuteScript.IBScriptExecuteError(Sender: TObject; Error,
  SQLText: String; LineIndex: Integer; var Ignore: Boolean);
begin
  Ignore := FContinuarScriptIgnorandoErros;
  ErroCorrente := Error
end;

procedure TExecuteScript.IniciaScript;
begin
  BeforeIniciaScript;
  AbrePrimeiroArquivo;

  repeat Execute until AbreProximoArquivo = 0;

  AfterScriptComplete
end;

procedure TExecuteScript.SetBaseEmProcessamento(const Value: string);
begin
  FBaseEmProcessamento := Value;
end;

procedure TExecuteScript.SetCaminhoBases(const Value: TTreeNode);
begin
  FCaminhoBases := Value;
end;

procedure TExecuteScript.SetCaminhoRaiz(const Value: string);
begin
  FCaminhoRaiz := Value;
end;

procedure TExecuteScript.SetContinuarScriptIgnorandoErros(
  const Value: Boolean);
begin
  FContinuarScriptIgnorandoErros := Value;
end;

procedure TExecuteScript.SetErroCorrente(const Value: string);
begin
  FErroCorrente := Value;

  FProcessHasErrors := not(FErroCorrente = NO_STRING)
end;

procedure TExecuteScript.SetProcessHasErrors(const Value: boolean);
begin
  FProcessHasErrors := Value;
end;

procedure TExecuteScript.SetScript(const Value: string);
begin
  FScript := Value;
end;

procedure TExecuteScript.SetStatusBox(const Value: TListBox);
begin
  FStatusBox := Value;
end;

procedure TExecuteScript.TreeviewToListaDiretorios(TreeNode: TTreeNode);
var
  TempNode, TempNodeAux: TTreeNode;

begin
  TempNode        := TreeNode;
  ListaDiretorios := NO_STRING;

  if not TempNode.Expanded
   then TempNode.Expand(false);

  TempNodeAux := TempNode.GetFirstChild;

  if not Assigned(TempNodeAux)
   then ListaDiretorios := CaminhoRaiz
   else
    begin
     repeat
      ListaDiretorios := ListaDiretorios + CaminhoRaiz + '\' + TempNodeAux.Text + ';';
      TempNodeAux := TempNode.GetNextChild(TempNodeAux);

     until not Assigned(TempNodeAux);

     ListaDiretorios := Copy(ListaDiretorios, 0, Pred(Length(ListaDiretorios)))
    end
end;

end.
