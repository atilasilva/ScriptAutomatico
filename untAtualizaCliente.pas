unit untAtualizaCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Animate, GIFCtrl, IB, untLogin, objExecuteScriptAtualizaCliente;

type
  TfrmAtualizaCliente = class(TForm)
    pnl1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    btnConfima: TButton;
    lbl1: TLabel;
    btnNaoConfirma: TButton;
    procedure btnConfimaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNaoConfirmaClick(Sender: TObject);
  private
    { Private declarations }
  public
    ExecuteScriptAtualizaCliente: TExecuteScriptAtualizaCliente;
    function LoginBases: string;
    procedure RealizaLogin;
    { Public declarations }
  end;

var
  frmAtualizaCliente: TfrmAtualizaCliente;

implementation

uses untPrincipal, LibSAuto, LibAtualizaCliente;

var
  IniSections: TStringList;

{$R *.dfm}

procedure TfrmAtualizaCliente.btnConfimaClick(Sender: TObject);
begin
  try
   ExecuteScriptAtualizaCliente.Execute;

  finally
   if not ExecuteScriptAtualizaCliente.ProcessHasFatalErrors    
    then begin
     Application.MessageBox(SAUTOERROR008,
       PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
     Application.Terminate
    end
   else
    begin
     Application.MessageBox(PChar(ExecuteScriptAtualizaCliente.ErroCorrente),
       PChar(Application.Title), MB_OK + MB_ICONSTOP);
    end
  end
end;

procedure TfrmAtualizaCliente.FormCreate(Sender: TObject);
begin
  ExecuteScriptAtualizaCliente := TExecuteScriptAtualizaCliente.Create;
  IniSections                  := TStringList.Create;
  
  RealizaLogin
end;

procedure TfrmAtualizaCliente.FormDestroy(Sender: TObject);
begin
  ExecuteScriptAtualizaCliente.Free;
  IniSections.Free
end;

function TfrmAtualizaCliente.LoginBases: string;

  procedure CarregaBases;
  var
    Index: integer;

  begin
    with frmLogin do
     begin
      CmbUnidade.Items.Clear;

      for Index := 0 to Pred(IniSections.Count) do
       CmbUnidade.Items.Append(IniSections[Index] + ' - ' + IniRegLocal.ReadString(IniSections[Index], 'Clinica', NO_STRING));
     end
  end;

begin
  frmLogin := TFrmLogin.Create(Self);

  with frmLogin do
   begin
    CarregaBases;
    ShowModal;

    if ModalResult = mrOk
     then Result := Copy(CmbUnidade.Text,1,4)
     else Result := NO_STRING;

    Close
   end
end;

procedure TfrmAtualizaCliente.btnNaoConfirmaClick(Sender: TObject);
begin
  Close
end;

procedure TfrmAtualizaCliente.RealizaLogin;
var
  IDDatabase: string;
  
begin
  TConfiguracoesRenalManager.GetDatabaseList(IniSections);

  if IniSections.Count > 1
   then begin
    IDDatabase := LoginBases;

    if IDDatabase = NO_STRING
     then Application.Terminate;

    ExecuteScriptAtualizaCliente.PathDatabaseName := TConfiguracoesRenalManager.GetPathDatabaseName(IDDatabase);
    ExecuteScriptAtualizaCliente.IP               := TConfiguracoesRenalManager.GetIP(IDDatabase)
   end
  else
   if IniSections.Count = 1
    then begin
     ExecuteScriptAtualizaCliente.PathDatabaseName := TConfiguracoesRenalManager.GetPathDatabaseName(IniSections[0]);
     ExecuteScriptAtualizaCliente.IP               := TConfiguracoesRenalManager.GetIP(IniSections[0])
    end
   else
    begin
     Application.MessageBox(PChar(SAUTOERROR009),
       PChar(Application.Title), MB_OK + MB_ICONSTOP);
     Abort
    end
end;

end.
