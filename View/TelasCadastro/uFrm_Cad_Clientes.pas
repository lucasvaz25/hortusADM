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
  Vcl.Imaging.Pngimage,

  UClientesController,
  UCondicaoPagamentoController,
  UCidadesController;

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
    LblCondPag: TLabel;
    EdCodCidade: TVazEdit;
    LblCodCidade: TLabel;
    EdCodCondPag: TVazEdit;
    LblCodCondPag: TLabel;
    EdCondPag: TVazEdit;
    PnlPesquisaCondPag: TPanel;
    ImgPesquisaCondPag: TImage;
    procedure RgTpPessoaClick( Sender: TObject );
  private
    { Private declarations }
    CondPagControl: TCondicaoPagamentoController;
    CidadeControl: TCidadesController;
    procedure FormatInterface;
    procedure PopulaObj;
    procedure PopulaForm;
    function ValidaForm: Boolean;
    procedure ConsultarCondPag;
    procedure PesquisaBtnCondPag;
    procedure ConsultarCidade;
    procedure PesquisaBtnCidade;
  public
    { Public declarations }
    ClienteControl: TClientesController;

    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Clientes: TFrm_Cad_Clientes;

implementation

uses
  System.Contnrs,
  UToolsSistema,
  UFilterSearch,
  UCondicaoPagamento,
  UCidades,
  UClientes,
  UFrm_Consulta_CondicaoPagamento,
  UFrm_Consulta_Cidades;

{$R *.dfm}


procedure TFrm_Cad_Clientes.ConsultarCidade;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCidade.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.RecuperarObj := True;
      Filtro.Codigo       := StrToInt( EdCodCidade.Text );
      List                := CidadeControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCidade.Text := TCidade( List[ 0 ] ).Cidade;
        EdUF.Text     := TCidade( List[ 0 ] ).Estado.UF;
        ClienteControl.GetEntity.Cidade.CopiarDados( TCidade( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Cidade n�o encontrado!!' );
        EdCodCidade.Clear;
        EdCidade.SetFocus;
        EdUF.Clear;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Clientes.ConsultarCondPag;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCondPag.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.RecuperarObj := True;
      Filtro.Codigo       := StrToInt( EdCodCondPag.Text );
      List                := CondPagControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCondPag.Text := TCondicaoPagamento( List[ 0 ] ).CondPag;
        ClienteControl.GetEntity.CondPagamento.CopiarDados( TCondicaoPagamento( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Condi��o de Pagamento n�o encontrada!!' );
        EdCodCondPag.Clear;
        EdCondPag.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Clientes.FormatInterface;
begin
  case RgTpPessoa.ItemIndex of
    0:
      begin
        LblNome.Caption         := 'Cliente*';
        EdNome.TextHint         := 'Digite o nome do cliente';
        LblNomeFantasia.Caption := 'Apelido';
        EdNomeFantasia.TextHint := 'Digite o apelido do cliente';
        LblCPF.Enabled          := True;
        EdCPF.Enabled           := True;
        LblCPF.Caption          := 'CPF*';
        EdCPF.TypeMask          := TtmCPF;
        LblRG.Caption           := 'RG*';
        LblDtNasc.Caption       := 'Data Nascimento';
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
        LblDtNasc.Caption       := 'Data Funda��o';
        RgSexo.Visible          := False;
      end;
  end;
end;

procedure TFrm_Cad_Clientes.PesquisaBtnCidade;
var
  Frm: TFrm_Consulta_Cidades;
begin
  inherited;
  Frm := TFrm_Consulta_Cidades.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdCidade.Text    := Frm.CidadeControl.GetEntity.Cidade;
    EdCodCidade.Text := IntToStr( Frm.CidadeControl.GetEntity.Codigo );
    ClienteControl.GetEntity.Cidade.CopiarDados( Frm.CidadeControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Clientes.PesquisaBtnCondPag;
var
  Frm: TFrm_Consulta_CondicaoPagamento;
begin
  inherited;
  Frm := TFrm_Consulta_CondicaoPagamento.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdCondPag.Text    := Frm.CondPagControl.GetEntity.CondPag;
    EdCodCondPag.Text := IntToStr( Frm.CondPagControl.GetEntity.Codigo );
    ClienteControl.GetEntity.CondPagamento.CopiarDados
                ( Frm.CondPagControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Clientes.PopulaForm;
begin
  with ClienteControl.GetEntity do
  begin
    EdCodigo.Text        := IntToStr( Codigo );
    EdNome.Text          := Nome;
    EdRG.Text            := RG;
    EdBairro.Text        := Bairro;
    EdCPF.Text           := CPF;
    EdCEP.Text           := CEP;
    EdNum.Text           := Numero;
    EdNomeFantasia.Text  := Apelido;
    EdLogradouro.Text    := Endereco;
    EdTelefone.Text      := Telefone;
    EdEmail.Text         := Email;
    EdCidade.Text        := Cidade.Cidade;
    EdCodCidade.Text     := IntToStr( Cidade.Codigo );
    EdUF.Text            := Cidade.Estado.UF;
    EdCondPag.Text       := CondPagamento.CondPag;
    EdCodCondPag.Text    := IntToStr( CondPagamento.Codigo );
    RgTpPessoa.ItemIndex := Integer( TpPessoa );
  end;
end;

procedure TFrm_Cad_Clientes.PopulaObj;
begin
  with ClienteControl.GetEntity do
  begin
    Codigo                := StrToInt( EdCodigo.Text );
    Nome                  := UpperCase( EdNome.Text );
    RG                    := EdRG.Text;
    Bairro                := UpperCase( EdBairro.Text );
    CPF                   := EdCPF.Text;
    CEP                   := EdCEP.Text;
    Numero                := EdNum.Text;
    Apelido               := EdNomeFantasia.Text;
    Endereco              := EdLogradouro.Text;
    Telefone              := EdTelefone.Text;
    Email                 := EdEmail.Text;
    Cidade.Cidade         := EdCidade.Text;
    Cidade.Codigo         := StrToInt( EdCodCidade.Text );
    Cidade.Estado.UF      := EdUF.Text;
    CondPagamento.CondPag := EdCondPag.Text;
    CondPagamento.Codigo  := StrToInt( EdCodCondPag.Text );
    // TpPessoa              := TTipoPessoa( RgTpPessoa.ItemIndex );
  end;
end;

procedure TFrm_Cad_Clientes.RgTpPessoaClick( Sender: TObject );
begin
  inherited;
  Self.FormatInterface;
end;

procedure TFrm_Cad_Clientes.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Clientes.Salvar;
begin
  inherited;
  if Salvou then
    Self.Sair;
end;

function TFrm_Cad_Clientes.ValidaForm: Boolean;
begin

end;

end.
