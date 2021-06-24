unit uFrm_Cad_CondicaoPagamento;

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
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Datasnap.DBClient,
  Vcl.Imaging.Pngimage,
  UCondicaoPagamentoController,
  UParcelasController,
  UFormasPagamentosController;

type
  TFrm_Cad_CondicaoPagamento = class( TFrm_Cadastro )
    EdCondPag: TVazEdit;
    LblCondPag: TLabel;
    EdParcelas: TVazEdit;
    LblParcelas: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    TDset_Parcelas: TClientDataSet;
    DsParcelas: TDataSource;
    TDset_Parcelasnumero: TIntegerField;
    TDset_Parcelasdias: TIntegerField;
    TDset_ParcelasFormaPagamento: TStringField;
    LbltxJuros: TLabel;
    EdTxJuros: TVazEdit;
    LblMulta: TLabel;
    EdMulta: TVazEdit;
    LblDesconto: TLabel;
    EdDesconto: TVazEdit;
    EdDias: TVazEdit;
    LblDias: TLabel;
    Panel3: TPanel;
    LblParcela: TLabel;
    LblPorcentagem: TLabel;
    EdPorcentagem: TVazEdit;
    EdFormaPagamento: TVazEdit;
    LblFormaPagamento: TLabel;
    EdCodFormaPagamento: TVazEdit;
    LblCodFormaPagamento: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    PnlInserirLista: TPanel;
    BtnInserirLista: TSpeedButton;
    PnlEditar: TPanel;
    BtnEditar: TSpeedButton;
    TDset_Parcelasporcentagem: TFloatField;
    procedure FormCreate( Sender: TObject );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure EdCodFormaPagamentoExit( Sender: TObject );
    procedure EdCodFormaPagamentoKeyPress( Sender: TObject; var Key: Char );
  private
    { Private declarations }
    FormaPgtoControl: TFormasPagamentosController;
    ParcelaControl: TParcelasController;
    procedure PopulaObj;
    procedure PopulaForm; override;
    procedure PopularListaParcelas;
    procedure PopularDataSetParcelas;
    function ValidaForm: Boolean;
    procedure ConsultaFormaPgto;
    procedure PesquisaFormaPgto;
  public
    { Public declarations }
    CondPagControl: TCondicaoPagamentoController;
    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_CondicaoPagamento: TFrm_Cad_CondicaoPagamento;

implementation

uses
  UFormasPagamentos,
  UParcelas,
  UCondicaoPagamento,
  UFilterSearch,
  UFrm_Consulta_FormasPagamentos,
  System.Contnrs;
{$R *.dfm}

{ TFrm_Cad_CondicaoPagamento }

procedure TFrm_Cad_CondicaoPagamento.ConsultaFormaPgto;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodFormaPagamento.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodFormaPagamento.Text );
      List                := FormaPgtoControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdFormaPagamento.Text    := TFormasPagamentos( List[ 0 ] ).FormaPagamento;
        EdCodFormaPagamento.Text := TFormasPagamentos( List[ 0 ] ).Codigo.ToString;
        ParcelaControl.GetEntity.FormaPagamento.CopiarDados( TFormasPagamentos( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Forma de Pagamento n�o encontrada!!' );
        EdFormaPagamento.Clear;
        EdCodFormaPagamento.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_CondicaoPagamento.EdCodFormaPagamentoExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaFormaPgto;
end;

procedure TFrm_Cad_CondicaoPagamento.EdCodFormaPagamentoKeyPress(
            Sender: TObject; var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaFormaPgto;
end;

procedure TFrm_Cad_CondicaoPagamento.FormCreate( Sender: TObject );
begin
  inherited;
  CondPagControl := nil;
  CondPagControl.GetInstance( CondPagControl, Self );

  ParcelaControl := nil;
  ParcelaControl.GetInstance( ParcelaControl, Self );

  FormaPgtoControl := nil;
  FormaPgtoControl.GetInstance( FormaPgtoControl, Self );

  TDset_Parcelas.AfterScroll := nil;
  if ( not TDset_Parcelas.IsEmpty ) then
    TDset_Parcelas.EmptyDataSet;
  TDset_Parcelas.Active := False;
  TDset_Parcelas.DisableControls;
  TDset_Parcelas.CreateDataSet;

  TDset_Parcelas.Open;
end;

procedure TFrm_Cad_CondicaoPagamento.ImgPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaFormaPgto;
end;

procedure TFrm_Cad_CondicaoPagamento.PesquisaFormaPgto;
var
  Frm: TFrm_Consulta_FormasPagamentos;
begin
  inherited;
  Frm := TFrm_Consulta_FormasPagamentos.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdFormaPagamento.Text    := Frm.FormaPgtoControl.GetEntity.FormaPagamento;
    EdCodFormaPagamento.Text := IntToStr( Frm.FormaPgtoControl.GetEntity.Codigo );
    ParcelaControl.GetEntity.FormaPagamento.CopiarDados( Frm.FormaPgtoControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_CondicaoPagamento.PopulaForm;
begin
  inherited;
  with CondPagControl.GetEntity do
  begin
    EdCodigo.Text                   := Codigo.ToString;
    EdCondPag.Text                  := CondPag;
    EdParcelas.Text                 := Parcelas.ToString;
    EdTxJuros.Text                  := FloatToStr( TxJuros );
    EdMulta.Text                    := FloatToStr( Multa );
    EdDesconto.Text                 := FloatToStr( Desconto );
    LblUsuarioDataCad.Caption       := 'Usu�rio Cad.:' + UserCad + ' - Data Cad.' + DateToStr( DataCad );
    LblUsuarioDataAlteracao.Caption := 'Usu�rio Alt.:' + UserAlt + ' - Data Alt.' + DateToStr( DataAlt );
  end;
  Self.PopularDataSetParcelas;
end;

procedure TFrm_Cad_CondicaoPagamento.PopulaObj;
begin
  with CondPagControl.GetEntity do
  begin
    Codigo   := StrToInt( EdCodigo.Text );
    CondPag  := EdCondPag.Text;
    Parcelas := StrToInt( EdParcelas.Text );
    TxJuros  := StrToFloat( EdTxJuros.Text );
    Multa    := StrToFloat( EdMulta.Text );
    Desconto := StrToFloat( EdDesconto.Text );

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

procedure TFrm_Cad_CondicaoPagamento.PopularDataSetParcelas;
var
  Parcela: TParcelas;
begin
  with CondPagControl.GetEntity do
  begin
    if not( ListaParcelas = nil ) then
      if ( ListaParcelas.Count > 0 ) then
      begin
        for Parcela in ListaParcelas do
        begin
          TDset_Parcelas.Append;
          TDset_Parcelasnumero.AsInteger        := Parcela.Numero;
          TDset_Parcelasdias.AsInteger          := Parcela.Dias;
          TDset_Parcelasporcentagem.AsFloat     := Parcela.Porcentagem;
          TDset_ParcelasFormaPagamento.AsString := Parcela.FormaPagamento.FormaPagamento;
          TDset_Parcelas.Post;
        end;
        TDset_Parcelas.EnableControls;
      end;
  end;
end;

procedure TFrm_Cad_CondicaoPagamento.PopularListaParcelas;
begin

end;

procedure TFrm_Cad_CondicaoPagamento.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_CondicaoPagamento.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := CondPagControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := CondPagControl.Inserir( Aux )
    else
      Salvou := CondPagControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_CondicaoPagamento.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdCondPag.Text ) < 3 then
  begin
    MessageDlg( 'Informe uma Condi��o de Pagamento V�lida!', MtInformation, [ MbOK ], 0 );
    EdCondPag.SetFocus;
    Exit;
  end;

  if TDset_Parcelas.IsEmpty then
  begin
    MessageDlg( 'N�o � permitido Condi��o de Pagamento sem nenhum parcela lan�ada!', MtInformation, [ MbOK ], 0 );
    EdDias.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if CondPagControl.VerificaExiste( UpperCase( EdCondPag.Text ) ) then
    begin
      MessageDlg( 'J� existe uma Condi��o de Pagamento com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdCondPag.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
