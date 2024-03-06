unit untConfiguracoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmConfiguracoes = class(TForm)
    pnlProxy: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtSenha: TEdit;
    edtUsuario: TEdit;
    Panel7: TPanel;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    edtDefaultDatabaseName: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfiguracoes: TfrmConfiguracoes;

implementation

uses untPrincipal, LibSAuto;

{$R *.dfm}

procedure TfrmConfiguracoes.FormShow(Sender: TObject);
begin
  if not(TConfiguracoesSAuto.GetUsuarioPadrao = DEFAULTUSERNAME)
   then edtUsuario.Text             := TConfiguracoesSAuto.GetUsuarioPadrao;

  if not(TConfiguracoesSAuto.GetSenhaPadrao = DEFAULTPASSWORD)
   then edtSenha.Text               := TConfiguracoesSAuto.GetSenhaPadrao;

  edtDefaultDatabaseName.Text := TConfiguracoesSAuto.GetDefaultDatabaseName
end;

procedure TfrmConfiguracoes.BitBtn1Click(Sender: TObject);
begin
  Close
end;

procedure TfrmConfiguracoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  IniReg.WriteString('Database', 'Username', edtUsuario.Text);
  IniReg.WriteString('Database', 'Senha', edtSenha.Text);
  IniReg.WriteString('Database', 'DefaultName', edtDefaultDatabaseName.Text);

  Action := caFree
end;

end.
