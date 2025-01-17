unit uFrm_cad_Produtos;

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
  Vcl.Imaging.Pngimage,
  UFornecedoresController,
  UUnidadesController,
  USubGruposController,
  UProdutosController;

type
  TFrm_Cad_Produto = class( TFrm_Cadastro )
    LblDescricao: TLabel;
    Edproduto: TVazEdit;
    LblVlrCusto: TLabel;
    EdVlrCusto: TVazEdit;
    EdVlrVenda: TVazEdit;
    LblVlrVenda: TLabel;
    LblUnidade: TLabel;
    PnlImage: TPanel;
    PnlInserirImagem: TPanel;
    PnlRemoverImage: TPanel;
    BtnInserirImagem: TSpeedButton;
    BtnRemoverImage: TSpeedButton;
    ImgProduto: TImage;
    LblImageProduto: TLabel;
    EdEstoque: TVazEdit;
    LblEstoque: TLabel;
    EdFornecedor: TVazEdit;
    LblFornecedor: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    EdSubGrupo: TVazEdit;
    LblSubGrupo: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    EdGrupo: TVazEdit;
    LblGrupo: TLabel;
    EdObs: TMemo;
    LblObs: TLabel;
    EdUnidade: TVazEdit;
    Panel2: TPanel;
    Image2: TImage;
    EdCodUnidade: TVazEdit;
    LblCodFormaPagamento: TLabel;
    EdCodFornecedor: TVazEdit;
    Label1: TLabel;
    EdCodSubgrupo: TVazEdit;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    procedure FormCreate( Sender: TObject );
    procedure EdVlrVendaEnter( Sender: TObject );
    procedure EdCodUnidadeExit( Sender: TObject );
    procedure Image2Click( Sender: TObject );
    procedure EdCodFornecedorExit( Sender: TObject );
    procedure EdCodFornecedorKeyPress( Sender: TObject; var Key: Char );
    procedure EdCodUnidadeKeyPress( Sender: TObject; var Key: Char );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure EdCodSubgrupoExit( Sender: TObject );
    procedure EdCodSubgrupoKeyPress( Sender: TObject; var Key: Char );
    procedure Image1Click( Sender: TObject );
    procedure BtnInserirImagemClick( Sender: TObject );
  private
    { Private declarations }
    FornecedorControl: TFornecedoresController;
    UnidadeControl: TUnidadesController;
    SubgrupoControl: TSubGruposController;

    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;

    procedure ConsultaFornecedor;
    procedure ConsultaUnidade;
    procedure ConsultaSubgrupo;

    procedure PesquisaFornecedor;
    procedure PesquisaUnidade;
    procedure PesquisaSubgrupo;
  public
    { Public declarations }
    ProdutoControl: TProdutosController;
    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Produto: TFrm_Cad_Produto;

implementation

uses
  System.Contnrs,
  UFornecedores,
  UUnidades,
  USubGrupos,
  UFilterSearch,
  UFrm_Consulta_Fornecedores,
  UFrm_Consulta_Unidades,
  UFrm_Consulta_SubGrupos;
{$R *.dfm}

{ TFrm_Cad_Produto }

procedure TFrm_Cad_Produto.BtnInserirImagemClick( Sender: TObject );
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    ImgProduto.Picture.LoadFromFile( OpenDialog1.Files[ 0 ] );
  end;
end;

procedure TFrm_Cad_Produto.ConsultaFornecedor;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodFornecedor.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodFornecedor.Text );
      List                := FornecedorControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdFornecedor.Text    := TFornecedores( List[ 0 ] ).Nome;
        EdCodFornecedor.Text := TFornecedores( List[ 0 ] ).Codigo.ToString;
        FornecedorControl.GetEntity.CopiarDados( TFornecedores( List[ 0 ] ) );
        ProdutoControl.GetEntity.Fornecedor.CopiarDados( TFornecedores( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Fornecedor n�o encontrada!!' );
        EdFornecedor.Clear;
        EdCodFornecedor.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Produto.ConsultaSubgrupo;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodSubgrupo.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodSubgrupo.Text );
      List                := SubgrupoControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdSubGrupo.Text    := TSubGrupos( List[ 0 ] ).Subgrupo;
        EdCodSubgrupo.Text := TSubGrupos( List[ 0 ] ).Codigo.ToString;
        EdGrupo.Text       := TSubGrupos( List[ 0 ] ).Grupo.Grupo;
        SubgrupoControl.GetEntity.CopiarDados( TSubGrupos( List[ 0 ] ) );
        ProdutoControl.GetEntity.SubGrupo.CopiarDados( TSubGrupos( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'SubGrupo n�o encontrado!!' );
        EdSubGrupo.Clear;
        EdGrupo.Clear;
        EdCodSubgrupo.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Produto.ConsultaUnidade;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodUnidade.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodUnidade.Text );
      List                := UnidadeControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdUnidade.Text    := TUnidades( List[ 0 ] ).Unidade;
        EdCodUnidade.Text := TUnidades( List[ 0 ] ).Codigo.ToString;
        UnidadeControl.GetEntity.CopiarDados( TUnidades( List[ 0 ] ) );
        ProdutoControl.GetEntity.Unidade.CopiarDados( TUnidades( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Unidade n�o encontrada!!' );
        EdUnidade.Clear;
        EdCodUnidade.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Produto.EdCodFornecedorExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaFornecedor;
end;

procedure TFrm_Cad_Produto.EdCodFornecedorKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaFornecedor;
end;

procedure TFrm_Cad_Produto.EdCodSubgrupoExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaSubgrupo;
end;

procedure TFrm_Cad_Produto.EdCodSubgrupoKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaSubgrupo;
end;

procedure TFrm_Cad_Produto.EdCodUnidadeExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaUnidade;
end;

procedure TFrm_Cad_Produto.EdCodUnidadeKeyPress( Sender: TObject; var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaUnidade;
end;

procedure TFrm_Cad_Produto.EdVlrVendaEnter( Sender: TObject );
begin
  inherited;
  FormatCurrency( Sender );
end;

procedure TFrm_Cad_Produto.FormCreate( Sender: TObject );
begin
  inherited;
  ProdutoControl := nil;
  ProdutoControl.GetInstance( ProdutoControl, Self );

  UnidadeControl := nil;
  UnidadeControl.GetInstance( UnidadeControl, Self );

  FornecedorControl := nil;
  FornecedorControl.GetInstance( FornecedorControl, Self );

  SubgrupoControl := nil;
  SubgrupoControl.GetInstance( SubgrupoControl, Self );
end;

procedure TFrm_Cad_Produto.Image1Click( Sender: TObject );
begin
  inherited;
  Self.PesquisaSubgrupo;
end;

procedure TFrm_Cad_Produto.Image2Click( Sender: TObject );
begin
  inherited;
  Self.PesquisaUnidade;
end;

procedure TFrm_Cad_Produto.ImgPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaFornecedor;
end;

procedure TFrm_Cad_Produto.PesquisaFornecedor;
var
  Frm: TFrm_Consulta_Fornecedores;
begin
  inherited;
  Frm := TFrm_Consulta_Fornecedores.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdFornecedor.Text    := Frm.FornecedorControl.GetEntity.Nome;
    EdCodFornecedor.Text := IntToStr( Frm.FornecedorControl.GetEntity.Codigo );
    FornecedorControl.GetEntity.CopiarDados( Frm.FornecedorControl.GetEntity );
    ProdutoControl.GetEntity.Fornecedor.CopiarDados( Frm.FornecedorControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Produto.PesquisaSubgrupo;
var
  Frm: TFrm_Consulta_SubGrupos;
begin
  inherited;
  Frm := TFrm_Consulta_SubGrupos.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdSubGrupo.Text    := Frm.SubGrupoControl.GetEntity.Subgrupo;
    EdCodSubgrupo.Text := IntToStr( Frm.SubGrupoControl.GetEntity.Codigo );
    SubGrupoControl.GetEntity.CopiarDados( Frm.SubGrupoControl.GetEntity );
    ProdutoControl.GetEntity.SubGrupo.CopiarDados( Frm.SubGrupoControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Produto.PesquisaUnidade;
var
  Frm: TFrm_Consulta_Unidades;
begin
  inherited;
  Frm := TFrm_Consulta_Unidades.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdUnidade.Text    := Frm.UnidadeControl.GetEntity.Unidade;
    EdCodUnidade.Text := IntToStr( Frm.UnidadeControl.GetEntity.Codigo );
    UnidadeControl.GetEntity.CopiarDados( Frm.UnidadeControl.GetEntity );
    ProdutoControl.GetEntity.Unidade.CopiarDados( Frm.UnidadeControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Produto.PopulaForm;
begin
  inherited;
  with ProdutoControl.GetEntity do
  begin
    EdCodigo.Text        := Codigo.ToString;
    Edproduto.Text       := Produto;
    EdCodUnidade.Text    := Unidade.Codigo.ToString;
    EdUnidade.Text       := Unidade.Unidade;
    EdVlrVenda.Text      := FormatFloat( 'R$ 0.00#', PrecoVenda );
    EdCodFornecedor.Text := Fornecedor.Codigo.ToString;
    EdFornecedor.Text    := Fornecedor.Nome;
    EdCodSubgrupo.Text   := SubGrupo.Codigo.ToString;
    EdSubGrupo.Text      := SubGrupo.Subgrupo;
    EdGrupo.Text         := SubGrupo.Grupo.Grupo;
    EdObs.Text           := Obs;
    ImgProduto.Picture.LoadFromStream( Imagem );

    if PrecoCusto > 0 then
      EdVlrCusto.Text := FormatFloat( 'R$ 0.00#', PrecoCusto );

    LblUsuarioDataCad.Caption       := 'Usu�rio Cad.:' + UserCad + ' - Data Cad.' + DateToStr( DataCad );
    LblUsuarioDataAlteracao.Caption := 'Usu�rio Alt.:' + UserAlt + ' - Data Alt.' + DateToStr( DataAlt );
  end;

end;

procedure TFrm_Cad_Produto.PopulaObj;
begin
  with ProdutoControl.GetEntity do
  begin
    Codigo     := StrToInt( EdCodigo.Text );
    Produto    := Edproduto.Text;
    PrecoVenda := StrToCurr( StringReplace( EdVlrVenda.Text, 'R$', '', [ RfReplaceAll, RfIgnoreCase ] ) );

    if Length( EdVlrCusto.Text ) > 0 then
      PrecoCusto := StrToCurr( StringReplace( EdVlrCusto.Text, 'R$', '', [ RfReplaceAll, RfIgnoreCase ] ) );

    Obs := EdObs.Text;
    ImgProduto.Picture.SaveToStream( Imagem );

    if ( Codigo = 0 ) then
    begin
      Datacad := Date;
      UserCad := 'LUCAS';
    end
    else
    begin
      DataAlt := Date;
      UserAlt := 'LUCAS';
    end;
  end;
end;

procedure TFrm_Cad_Produto.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Produto.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := ProdutoControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := ProdutoControl.Inserir( Aux )
    else
      Salvou := ProdutoControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_Produto.ValidaForm: Boolean;
begin
  Result := False;

  if Length( Edproduto.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Produto v�lido!!', MtInformation, [ MbOK ], 0 );
    Edproduto.SetFocus;
    Exit;
  end;

  if ( EdCodUnidade.Text = '' ) or ( EdUnidade.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma Unidade v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCodUnidade.SetFocus;
    Exit;
  end;

  if ( EdCodFornecedor.Text = '' ) or ( EdFornecedor.Text = '' ) then
  begin
    MessageDlg( 'Selecione um Fornecedor v�lido!!', MtInformation, [ MbOK ], 0 );
    EdCodFornecedor.SetFocus;
    Exit;
  end;

  if ( EdCodSubgrupo.Text = '' ) or ( EdSubGrupo.Text = '' ) then
  begin
    MessageDlg( 'Selecione um SubGrupo v�lido!!', MtInformation, [ MbOK ], 0 );
    EdCodSubgrupo.SetFocus;
    Exit;
  end;

  if Length( EdVlrVenda.Text ) = 0 then
  begin
    MessageDlg( 'Insira um Pre�o de Venda V�lido!!', MtInformation, [ MbOK ], 0 );
    EdVlrVenda.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if ProdutoControl.VerificaExiste( UpperCase( Edproduto.Text ) ) then
    begin
      MessageDlg( 'J� existe um Produto com esse nome!!', MtInformation, [ MbOK ], 0 );
      Edproduto.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
