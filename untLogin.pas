unit untLogin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, Winsock,  GIFCtrl , ShellApi,Animate,
  RxGIF;

type
  TfrmLogin = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    IP: TLabel;
    BitBtn2: TBitBtn;
    VERSAO: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    RxGIFAnimator1: TRxGIFAnimator;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    SpeedButton2: TBitBtn;
    speedbutton1: TBitBtn;
    Label8: TLabel;
    Image1: TImage;
    CmbUnidade: TComboBox;
    procedure CmbUnidadeExit(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure speedbutton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses LibSAuto;

{$R *.DFM}

procedure TfrmLogin.CmbUnidadeExit(Sender: TObject);
begin
  if SpeedButton2.Focused
   then Exit;

  if CmbUnidade.Text = NO_STRING
   then begin
    Application.MessageBox(SAUTOERROR010,
      PChar(Application.Title), MB_OK + MB_ICONWARNING);
    CmbUnidade.setfocus;
    Abort;
   end;

  speedbutton1.Enabled := true;
end;

procedure TfrmLogin.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close
end;

procedure TfrmLogin.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Return) and (Self.Enabled)
   then Speedbutton1.Click
end;

procedure TfrmLogin.speedbutton1Click(Sender: TObject);
begin
  ModalResult := mrOk
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  ControlNavigation(Sender, Key)
end;

end.
