unit uFrm_Cad_Clientes;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  UFrm_Cadastro,
  Vcl.Buttons,
  Vcl.StdCtrls,
  VazEdit,
  Vcl.ExtCtrls,
  Vcl.Mask,
  VazMaskEdit,
  Vcl.ComCtrls,
  Vcl.Imaging.Pngimage;

type
  TFrm_Cad_Clientes = class( TFrm_Cadastro )
    LblNome: TLabel;
    EdNome: TVazEdit;
    RgTpPessoa: TRadioGroup;
    EdNomeFantasia: TVazEdit;
    LblNomeFantasia: TLabel;
    LblCPF: TLabel;
    EdCPF: TVazMaskEdit;
    EdDtNasc: TDateTimePicker;
    LblDtNasc: TLabel;
    RgSexo: TRadioGroup;
    EdCEP: TVazMaskEdit;
    LblCEP: TLabel;
    EdLogradouro: TVazEdit;
    LblLogradouro: TLabel;
    EdNum: TVazEdit;
    LblNum: TLabel;
    LblBairro: TLabel;
    EdBairro: TVazEdit;
    LblCidade: TLabel;
    EdCidade: TVazEdit;
    EdUF: TVazEdit;
    LblUF: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    EdTelefone: TVazMaskEdit;
    LblTelefone: TLabel;
    EdEmail: TVazEdit;
    LblEmail: TLabel;
    EdRG: TVazEdit;
    LblRG: TLabel;
    CbCondPag: TComboBox;
    LblCondPag: TLabel;
    procedure RgTpPessoaClick( Sender: TObject );
  private
    { Private declarations }
    procedure FormatInterface;
  public
    { Public declarations }
  end;

var
  Frm_Cad_Clientes: TFrm_Cad_Clientes;

implementation

{$R *.dfm}


procedure TFrm_Cad_Clientes.FormatInterface;
begin
  case RgTpPessoa.ItemIndex of
    0:
      begin
        LblNome.Caption         := 'Nome*';
        EdNome.TextHint         := 'Digite o nome do cliente';
        LblNomeFantasia.Caption := 'Apelido';
        EdNomeFantasia.TextHint := 'Digite o apelido do cliente';
        LblCPF.Enabled          := True;
        EdCPF.Enabled           := True;
        LblCPF.Caption          := 'CPF*';
        EdCPF.TypeMask          := TtmCPF;
        LblRG.Caption           := 'RG*';
        LblDtNasc.Enabled       := True;
        EdDtNasc.Enabled        := True;
        RgSexo.Visible          := True;
      end;
    1:
      begin
        LblNome.Caption         := 'Raz�o Social*';
        EdNome.TextHint         := 'Digite a Raz�o Social da empresa';
        LblNomeFantasia.Caption := 'Nome Fantasia';
        EdNomeFantasia.TextHint := 'Digite o nome fantasia da empresa';
        LblCPF.Enabled          := True;
        EdCPF.Enabled           := True;
        LblCPF.Caption          := 'CNPJ*';
        EdCPF.TypeMask          := TtmCNPJ;
        LblRG.Caption           := 'IE';
        LblDtNasc.Enabled       := False;
        EdDtNasc.Enabled        := False;
        RgSexo.Visible          := False;
      end;
  end;
end;

procedure TFrm_Cad_Clientes.RgTpPessoaClick( Sender: TObject );
begin
  inherited;
  Self.FormatInterface;
end;

end.
