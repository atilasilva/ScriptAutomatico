unit untPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, ToolEdit, StdCtrls, Buttons, ExtCtrls, jpeg,
  objExecuteScript, untConfiguracoes, IBSQLMonitor, DB,
  IBDatabase, ComCtrls, Inifiles, IBScript, ShellCtrls;

type
  TfrmPrincipal = class(TForm)
    lstStatusBox: TListBox;
    Label1: TLabel;
    Image1: TImage;
    Panel3: TPanel;
    Label12: TLabel;
    Label9: TLabel;
    Label15: TLabel;
    sbGerarAcertos: TSpeedButton;
    SpeedButton1: TSpeedButton;
    sbConfiguracoes: TSpeedButton;
    Panel1: TPanel;
    Label14: TLabel;
    Label4: TLabel;
    Image4: TImage;
    Label5: TLabel;
    mmoScript: TMemo;
    Label3: TLabel;
    Label6: TLabel;
    tvCaminhoBases: TShellTreeView;
    Label2: TLabel;
    pnl1: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    dlgOpenAddScript: TOpenDialog;
    SpeedButton4: TSpeedButton;
    ibsqlmntr1: TIBSQLMonitor;
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbGerarAcertosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbConfiguracoesClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ibsqlmntr1SQL(EventText: String; EventTime: TDateTime);
    procedure tvCaminhoBasesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    ExecuteScript: TExecuteScript;

    procedure CarregaParametros;
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses LibSAuto;

{$R *.dfm}

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.sbGerarAcertosClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  lstStatusBox.Items.Append('Processo iniciado. ' + DateTimeToStr(Now));
  CarregaParametros;
  ExecuteScript.IniciaScript;
  Screen.Cursor := crArrow
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  ExecuteScript := TExecuteScript.Create
end;

procedure TfrmPrincipal.CarregaParametros;
begin
  with ExecuteScript do
   begin
    CaminhoRaiz  := tvCaminhoBases.SelectedFolder.PathName;
    CaminhoBases := Self.tvCaminhoBases.Selected;
    StatusBox    := Self.lstStatusBox;
    Script       := mmoScript.Lines.Text;
   end
end;

procedure TfrmPrincipal.sbConfiguracoesClick(Sender: TObject);
begin
  frmConfiguracoes := TFrmConfiguracoes.Create(Self);
  frmConfiguracoes.ShowModal
end;

procedure TfrmPrincipal.SpeedButton2Click(Sender: TObject);
begin
  lstStatusBox.Clear;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  ExecuteScript.Free;
end;

procedure TfrmPrincipal.SpeedButton3Click(Sender: TObject);
var
  Texto: TStringList;

begin
  Texto := TStringList.Create;

  try
   dlgOpenAddScript.InitialDir := tvCaminhoBases.SelectedFolder.PathName;

   if not dlgOpenAddScript.Execute
    then Exit;

   Texto.LoadFromFile(dlgOpenAddScript.FileName);
   mmoScript.Lines.Text := mmoScript.Lines.Text + Texto.Text +#13+#10

  finally
   Texto.Free
  end
end;

procedure TfrmPrincipal.SpeedButton4Click(Sender: TObject);
begin
  mmoScript.Clear
end;

procedure TfrmPrincipal.ibsqlmntr1SQL(EventText: String;
  EventTime: TDateTime);
begin
  if Pos('Connect', EventText) = 0
   then lstStatusBox.Items.Text := lstStatusBox.Items.Text +#13+#10+ DateTimeToStr(EventTime) + ' - ' + EventText
   else lstStatusBox.Items.Text := lstStatusBox.Items.Text +#13+#10+ DateTimeToStr(EventTime) + ' - ' + EventText + ' ' + ExecuteScript.BaseEmProcessamento;

  lstStatusBox.ItemIndex := Pred(lstStatusBox.Items.Count);
  lstStatusBox.Repaint 
end;

procedure TfrmPrincipal.tvCaminhoBasesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5
   then tvCaminhoBases.Refresh(tvCaminhoBases.Selected.Parent)
end;

end.

