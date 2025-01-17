unit uFrm_Cad_Fornecedor;

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
  Vcl.Imaging.Pngimage,
  UFornecedoresController,
  UCidadesController,
  UCondicaoPagamentoController;

type
  TFrm_Cad_Fornecedor = class( TFrm_Cadastro )
    LblNome: TLabel;
    EdNome: TVazEdit;
    LblNomeFantasia: TLabel;
    EdNomeFantasia: TVazEdit;
    LblIE: TLabel;
    EdIE: TVazEdit;
    EdTelefone: TVazMaskEdit;
    LblTelefone: TLabel;
    LblEmail: TLabel;
    EdEmail: TVazEdit;
    EdCEP: TVazMaskEdit;
    EdLogradouro: TVazEdit;
    LblLogradouro: TLabel;
    LblBairro: TLabel;
    EdBairro: TVazEdit;
    EdNum: TVazEdit;
    LblNum: TLabel;
    EdCidade: TVazEdit;
    LblCidade: TLabel;
    EdUF: TVazEdit;
    LblUF: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    LblCEP: TLabel;
    EdContato: TVazEdit;
    LblContato: TLabel;
    EdSite: TVazEdit;
    Lblsite: TLabel;
    EdCNPJ: TVazMaskEdit;
    LblCNPJ: TLabel;
    RgTpPessoa: TRadioGroup;
    EdCodCidade: TVazEdit;
    LblCodCidade: TLabel;
    LblCodCondPag: TLabel;
    EdCodCondPag: TVazEdit;
    LblCondPag: TLabel;
    EdCondPag: TVazEdit;
    PnlPesquisaCondPag: TPanel;
    ImgPesquisaCondPag: TImage;
    RgSexo: TRadioGroup;
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure EdCodCidadeExit( Sender: TObject );
    procedure EdCodCidadeKeyPress( Sender: TObject; var Key: Char );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure RgTpPessoaClick( Sender: TObject );
    procedure EdCodCondPagExit( Sender: TObject );
    procedure EdCodCondPagKeyPress( Sender: TObject; var Key: Char );
    procedure ImgPesquisaCondPagClick( Sender: TObject );
  private
    { Private declarations }
    CidadeControl: TCidadesController;
    CondPagControl: TCondicaoPagamentoController;
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultarCondPag;
    procedure PesquisaBtnCondPag;
    procedure ConsultarCidade;
    procedure PesquisaBtnCidade;
    function GetTpDoc: string;
    procedure ChangeTpPessoa;
    procedure BlockFields;
    procedure UnlockFields;
  public
    { Public declarations }
    FornecedorControl: TFornecedoresController;
    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Fornecedor: TFrm_Cad_Fornecedor;

implementation

uses
  System.Contnrs,
  UEnum,
  UFilterSearch,
  UCondicaoPagamento,
  UCidades,
  UFornecedores,
  UFrm_Consulta_Cidades,
  UFrm_Consulta_CondicaoPagamento;

{$R *.dfm}

{ TFrm_Cad_Fornecedor }

procedure TFrm_Cad_Fornecedor.BlockFields;
begin
  EdNome.Enabled         := False;
  EdNomeFantasia.Enabled := False;
  RgTpPessoa.Enabled     := False;
  RgSexo.Enabled         := False;
  EdCNPJ.Enabled         := False;
  EdIE.Enabled           := False;
end;

procedure TFrm_Cad_Fornecedor.ChangeTpPessoa;
begin
  RgSexo.Visible := ( RgTpPessoa.ItemIndex = 0 );

  if ( RgTpPessoa.ItemIndex = 0 ) then
  begin
    EdNomeFantasia.TextHint := 'Digite o Apelido do fornecedor';
    LblNomeFantasia.Caption := 'Apelido';
    EdCNPJ.TypeMask         := TtmCPF;
    LblCNPJ.Caption         := 'CPF*';
    EdIE.TextHint           := 'Digite o RG';
    EdIE.NumbersOnly        := True;
    LblIE.Caption           := 'RG';
  end
  else
  begin
    EdNomeFantasia.TextHint := 'Digite o Nome Fantasia do fornecedor';
    LblNomeFantasia.Caption := 'Nome Fantasia';
    EdCNPJ.TypeMask         := TtmCNPJ;
    LblCNPJ.Caption         := 'CNPJ*';
    EdIE.TextHint           := 'Digite a Inscri��o estadual';
    EdIE.NumbersOnly        := False;
    LblIE.Caption           := 'IE';
  end;

end;

procedure TFrm_Cad_Fornecedor.ConsultarCidade;
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
        FornecedorControl.GetEntity.Cidade.CopiarDados( TCidade( List[ 0 ] ) );

        if RgTpPessoa.ItemIndex = 0 then
          if FornecedorControl.GetEntity.Cidade.Estado.Pais.Nome = 'BRASIL' then
            LblIE.Caption := 'RG*'
          else
            LblIE.Caption := 'RG';
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

procedure TFrm_Cad_Fornecedor.ConsultarCondPag;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCondPag.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodCondPag.Text );
      List                := CondPagControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCondPag.Text := TCondicaoPagamento( List[ 0 ] ).CondPag;
        FornecedorControl.GetEntity.CondPagamento.CopiarDados
                    ( TCondicaoPagamento( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Condi��o de Pagamento n�o encontrado!!' );
        EdCodCondPag.Clear;
        EdCondPag.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Fornecedor.EdCodCidadeExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarCidade;
end;

procedure TFrm_Cad_Fornecedor.EdCodCidadeKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarCidade;
end;

procedure TFrm_Cad_Fornecedor.EdCodCondPagExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarCondPag;
end;

procedure TFrm_Cad_Fornecedor.EdCodCondPagKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarCondPag;
end;

procedure TFrm_Cad_Fornecedor.FormCreate( Sender: TObject );
begin
  inherited;
  FornecedorControl := nil;
  FornecedorControl.GetInstance( FornecedorControl, Self );

  CondPagControl := nil;
  CondPagControl.GetInstance( CondPagControl, Self );

  CidadeControl := nil;
  CidadeControl.GetInstance( CidadeControl, Self );
end;

procedure TFrm_Cad_Fornecedor.FormShow( Sender: TObject );
begin
  inherited;
  if not( EdCodigo.Text = '0' ) then
    BlockFields
  else
    UnlockFields;

  Self.ChangeTpPessoa;
end;

function TFrm_Cad_Fornecedor.GetTpDoc: string;
begin
  if ( Length( EdCNPJ.Text ) = 11 ) then
    Result := 'CPF'
  else if ( Length( EdCNPJ.Text ) = 14 ) then
    Result := 'CNPJ'
  else
    Result := '';
end;

procedure TFrm_Cad_Fornecedor.ImgPesquisaCondPagClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaBtnCondPag;
end;

procedure TFrm_Cad_Fornecedor.ImgPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaBtnCidade;
end;

procedure TFrm_Cad_Fornecedor.PesquisaBtnCidade;
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
    FornecedorControl.GetEntity.Cidade.CopiarDados( Frm.CidadeControl.GetEntity );

    if RgTpPessoa.ItemIndex = 0 then
      if FornecedorControl.GetEntity.Cidade.Estado.Pais.Nome = 'BRASIL' then
        LblIE.Caption := 'RG*'
      else
        LblIE.Caption := 'RG';
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Fornecedor.PesquisaBtnCondPag;
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
    FornecedorControl.GetEntity.CondPagamento.CopiarDados
                ( Frm.CondPagControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Fornecedor.PopulaForm;
begin
  with FornecedorControl.GetEntity do
  begin
    EdCodigo.Text        := IntToStr( Codigo );
    EdNome.Text          := Nome;
    EdIE.Text            := RG;
    EdBairro.Text        := Bairro;
    EdCNPJ.Text          := CPF;
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
    EdContato.Text       := Contato;
    EdSite.Text          := Site;
    RgTpPessoa.ItemIndex := Integer( TpPessoa );
    RgSexo.ItemIndex     := Integer( Sexo );
  end;
end;

procedure TFrm_Cad_Fornecedor.PopulaObj;
begin
  with FornecedorControl.GetEntity do
  begin
    Codigo                := StrToInt( EdCodigo.Text );
    Nome                  := UpperCase( EdNome.Text );
    RG                    := EdIE.Text;
    Bairro                := UpperCase( EdBairro.Text );
    CPF                   := EdCNPJ.Text;
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
    Contato               := EdContato.Text;
    Site                  := EdSite.Text;
    TpPessoa              := TTipoPessoa( RgTpPessoa.ItemIndex );
    Sexo                  := TSexo( RgSexo.ItemIndex );
  end;
end;

procedure TFrm_Cad_Fornecedor.RgTpPessoaClick( Sender: TObject );
begin
  inherited;
  Self.ChangeTpPessoa;
end;

procedure TFrm_Cad_Fornecedor.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Fornecedor.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := FornecedorControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := FornecedorControl.Inserir( Aux )
    else
      Salvou := FornecedorControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end
end;

procedure TFrm_Cad_Fornecedor.UnlockFields;
begin
  EdNome.Enabled         := True;
  EdNomeFantasia.Enabled := True;
  RgTpPessoa.Enabled     := True;
  RgSexo.Enabled         := True;
  EdCNPJ.Enabled         := True;
  EdIE.Enabled           := True;
end;

function TFrm_Cad_Fornecedor.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdNome.Text ) < 3 then
  begin
    MessageDlg( 'Informe um fornecedor v�lido!!', MtInformation, [ MbOK ], 0 );
    EdNome.SetFocus;
    Exit;
  end;

  if ( EdCodCidade.Text = '' ) or ( EdCidade.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma Cidade v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCidade.SetFocus;
    Exit;
  end;

  // if ( EdCondPag.Text = '' ) or ( EdCodCondPag.Text = '' ) then
  // begin
  // MessageDlg( 'Insira uma Condi��o de Pagamento v�lida!!', MtInformation, [ MbOK ], 0 );
  // EdCodCondPag.SetFocus;
  // Exit;
  // end;

  if RgTpPessoa.ItemIndex = 0 then
  begin
    if not Self.ValidarCPF( EdCNPJ.Text ) then
    begin
      MessageDlg( 'Informe um CPF v�lido!!', MtInformation, [ MbOK ], 0 );
      EdCNPJ.SetFocus;
      Exit;
    end;

    if ( RgSexo.ItemIndex < 0 ) then
    begin
      MessageDlg( 'Informe o sexo do fornecedor!!', MtInformation, [ MbOK ], 0 );
      RgSexo.SetFocus;
      Exit;
    end;

    if ( Pos( '*', LblIE.Caption ) > 0 ) then
    begin
      if EdIE.Text = '' then
      begin
        MessageDlg( 'Informe um RG v�lido!!', MtInformation, [ MbOK ], 0 );
        EdIE.SetFocus;
        Exit;
      end;
    end;

  end
  else
  begin
    // validacaoCNPJ
  end;

  if ( EdCodCondPag.Text = '' ) or ( EdCondPag.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma condi��o de pagamento v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCodCondPag.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if FornecedorControl.VerificaExisteCPF_CNPJ( UpperCase( EdCNPJ.Text ) ) then
    begin
      MessageDlg( 'J� existe um Fornecedor com esse '
                  + GetTpDoc + '!!', MtInformation, [ MbOK ], 0 );
      EdNome.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
