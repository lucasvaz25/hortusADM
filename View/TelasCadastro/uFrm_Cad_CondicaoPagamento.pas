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
  UFormasPagamentosController,
  System.ImageList,
  Vcl.ImgList,
  Vcl.ComCtrls;

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
    ImageList1: TImageList;
    TDset_Parcelasbotao: TIntegerField;
    TDset_Parcelascod_formapgto: TIntegerField;
    ProgressBar1: TProgressBar;
    LblTotalPorcentagem: TLabel;
    procedure FormCreate( Sender: TObject );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure EdCodFormaPagamentoExit( Sender: TObject );
    procedure EdCodFormaPagamentoKeyPress( Sender: TObject; var Key: Char );
    procedure DBGrid1DrawColumnCell( Sender: TObject; const Rect: TRect;
                DataCol: Integer; Column: TColumn; State: TGridDrawState );
    procedure BtnInserirListaClick( Sender: TObject );
    procedure BtnEditarClick( Sender: TObject );
    procedure DBGrid1CellClick( Column: TColumn );
    procedure EdTxJurosEnter( Sender: TObject );
  private
    { Private declarations }
    TotalPorcentagem: Double;
    FormaPgtoControl: TFormasPagamentosController;
    ParcelaControl: TParcelasController;
    procedure PopulaObj;
    procedure PopulaForm; override;
    procedure PopularListaParcelas;
    procedure PopularDataSetParcelas;
    function ValidaForm: Boolean;
    procedure ConsultaFormaPgto;
    procedure PesquisaFormaPgto;

    procedure InserirParcela;
    procedure EditarParcela;
    procedure ExcluirParcela;

    function ValidarParcela: Boolean;
    procedure CalcPorcentagem( ADataSet: TDataSet );
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

procedure TFrm_Cad_CondicaoPagamento.BtnEditarClick( Sender: TObject );
begin
  inherited;
  Self.EditarParcela;
end;

procedure TFrm_Cad_CondicaoPagamento.BtnInserirListaClick( Sender: TObject );
begin
  inherited;
  if ValidarParcela then
  begin
    Self.InserirParcela;
    EdParcelas.Text := TDset_Parcelas.RecordCount.ToString;
    Self.CalcPorcentagem( TDset_Parcelas );
  end;
end;

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
        FormaPgtoControl.GetEntity.CopiarDados( TFormasPagamentos( List[ 0 ] ) );
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

procedure TFrm_Cad_CondicaoPagamento.DBGrid1CellClick( Column: TColumn );
var
  RecID, ClickCol: Integer;
  Pt: TPoint;
  Coord: TGridCoord;
  TotalRateado: Currency;
begin
  inherited;

  Pt       := DBGrid1.ScreenToClient( Mouse.CursorPos );
  Coord    := DBGrid1.MouseCoord( Pt.X, Pt.Y );
  ClickCol := Coord.X;
  if ( ClickCol = 4 ) then
  begin
    Self.ExcluirParcela;
  end;

end;

procedure TFrm_Cad_CondicaoPagamento.DBGrid1DrawColumnCell( Sender: TObject;
            const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState );
begin
  inherited;
  // zebrando
  if Odd( DBGrid1.DataSource.DataSet.RecNo ) then
    DBGrid1.Canvas.Brush.Color := $00E8E8E8
  else
    DBGrid1.Canvas.Brush.Color := ClWhite;

  // mudando cor sele��o
  if ( GdSelected in State ) then
  begin
    DBGrid1.Canvas.Brush.Color := $00CE7200;
    DBGrid1.Canvas.Font.Color  := ClWhite;
    DBGrid1.Canvas.Font.Style  := [ FsBold ];
  end;

  DBGrid1.Canvas.FillRect( Rect );
  DBGrid1.DefaultDrawColumnCell( Rect, DataCol, Column, State );

  // if UpperCase( Column.Field.FieldName ) = 'BOTAO' then
  // begin
  // Column.Title.Caption := '';
  // DBGrid1.Canvas.FillRect( Rect );
  // ImageList1.Draw( DBGrid1.Canvas, Rect.Left + 24, Rect.Top + 1, 2 );
  // end;
  // if Column.Index = 4 then
  // begin
  // Column.Title.Caption := '';
  // DBGrid1.Canvas.FillRect( Rect );
  // ImageList1.Draw( DBGrid1.Canvas, Rect.Left + 5, Rect.Top + 1, 2 );
  // end;
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

procedure TFrm_Cad_CondicaoPagamento.EditarParcela;
begin
  if TDset_Parcelas.IsEmpty then
  begin
    MessageDlg( 'Nenhum Item Selecionado!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  TDset_Parcelas.Last;
  TDset_Parcelas.Delete;
  EdParcelas.Text := TDset_Parcelas.RecordCount.ToString;
  Self.CalcPorcentagem( TDset_Parcelas );
  // with TDset_Parcelas do
  // begin
  // EdDias.Text              := FieldByName( 'dias' ).AsInteger.ToString;
  // EdPorcentagem.Text       := FieldByName( 'porcentagem' ).AsFloat.ToString;
  // EdCodFormaPagamento.Text := FieldByName( 'cod_formapgto' ).AsInteger.ToString;
  // EdFormaPagamento.Text    := FieldByName( 'formapagamento' ).AsString;
  // Self.ConsultaFormaPgto;
  // TDset_Parcelas.Delete;
  // end;
end;

procedure TFrm_Cad_CondicaoPagamento.EdTxJurosEnter( Sender: TObject );
begin
  inherited;
  Self.FormatNumeroDecimais( Sender );
end;

procedure TFrm_Cad_CondicaoPagamento.ExcluirParcela;
begin
  if not( TDset_Parcelas.IsEmpty ) then
  begin
    TDset_Parcelas.Delete;
    Self.CalcPorcentagem( TDset_Parcelas );
  end;
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

procedure TFrm_Cad_CondicaoPagamento.InserirParcela;
begin
  with TDset_Parcelas do
  begin
    Append;
    FieldByName( 'numero' ).AsInteger        := RecordCount + 1;
    FieldByName( 'dias' ).AsInteger          := StrToInt( EdDias.Text );
    FieldByName( 'porcentagem' ).AsFloat     := StrToFloat( EdPorcentagem.Text );
    FieldByName( 'formapagamento' ).AsString := FormaPgtoControl.GetEntity.FormaPagamento;
    FieldByName( 'cod_formapgto' ).AsInteger := FormaPgtoControl.GetEntity.Codigo;
    Post;
  end;
  TDset_Parcelas.EnableControls;

  EdDias.Clear;
  EdPorcentagem.Clear;
  EdCodFormaPagamento.Clear;
  EdFormaPagamento.Clear;
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
    FormaPgtoControl.GetEntity.CopiarDados( Frm.FormaPgtoControl.GetEntity );
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
    EdTxJuros.Text                  := FormatFloat( '0.00##', TxJuros );
    EdMulta.Text                    := FormatFloat( '0.00##', Multa );
    EdDesconto.Text                 := FormatFloat( '0.00##', Desconto );
    LblUsuarioDataCad.Caption       := 'Usu�rio Cad.:' + UserCad + ' - Data Cad.' + DateToStr( DataCad );
    LblUsuarioDataAlteracao.Caption := 'Usu�rio Alt.:' + UserAlt + ' - Data Alt.' + DateToStr( DataAlt );
  end;
  Self.PopularDataSetParcelas;
  Self.CalcPorcentagem( TDset_Parcelas );
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

    if EdDesconto.Text = '' then
      Desconto := 0
    else
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
          TDset_Parcelascod_formapgto.AsInteger := Parcela.FormaPagamento.Codigo;
          TDset_Parcelas.Post;
        end;
        TDset_Parcelas.EnableControls;
      end;
  end;
end;

procedure TFrm_Cad_CondicaoPagamento.PopularListaParcelas;
var
  I: Integer;
  Formapgto: TFormasPagamentos;
  Parcela: TParcelas;
begin
  if TDset_Parcelas.IsEmpty then
  begin
    MessageDlg( 'N�o Exitem Parcelas Lan�adas!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;

  CondPagControl.GetEntity.ListaParcelas.Clear;

  Formapgto := TFormasPagamentos.Create;
  try
    TDset_Parcelas.First;
    for I := 0 to TDset_Parcelas.RecordCount - 1 do
    begin
      if not FormaPgtoControl.Recuperar( TDset_Parcelascod_formapgto.AsInteger, TObject( Formapgto ) ) then
      begin
        MessageDlg( 'N�o foi poss�vel encontrar a forma de pagamento da parcela: '
                    + TDset_Parcelasnumero.AsInteger.ToString + '!', MtInformation, [ MbOK ], 0 );
        Exit;
      end;

      with Parcela do
      begin
        Parcela := TParcelas.Create;
        FormaPagamento.CopiarDados( Formapgto );
        Dias        := TDset_Parcelasdias.AsInteger;
        Numero      := I + 1;
        Porcentagem := TDset_Parcelasporcentagem.AsFloat;
        CodCondPgto := CondPagControl.GetEntity.Codigo;
      end;

      CondPagControl.GetEntity.ListaParcelas.Add( Parcela );
      TDset_Parcelas.Next;
    end;
  finally
    Formapgto.Free;
  end;
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
    begin
      Self.PopularListaParcelas;
      if ParcelaControl.ExcluirListaParcelas( TCondicaoPagamento( Aux ).Codigo ) then
        if ParcelaControl.InserirLista( TCondicaoPagamento( Aux ).ListaParcelas ) then
          Self.Sair;
    end;

  end;
end;

procedure TFrm_Cad_CondicaoPagamento.CalcPorcentagem( ADataSet: TDataSet );
begin
  TotalPorcentagem := 0;
  ADataSet.First;
  while not( ADataSet.Eof ) do
  begin
    TotalPorcentagem := TotalPorcentagem + ADataSet.FieldByName( 'porcentagem' ).AsFloat;
    ADataSet.Next;
  end;
  LblTotalPorcentagem.Caption := 'Total ' + TotalPorcentagem.ToString + '%';
  ProgressBar1.Position       := Trunc( TotalPorcentagem );
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

  if ( TotalPorcentagem < 100 ) then
  begin
    MessageDlg( 'O total de porcentagem das parcelas deve ser igual a 100%!', MtInformation, [ MbOK ], 0 );
    EdDias.SetFocus;
    Exit;
  end;

  if EdTxJuros.Text = '' then
  begin
    MessageDlg( 'Informe uma taxa de juros v�lida!', MtInformation, [ MbOK ], 0 );
    EdTxJuros.SetFocus;
    Exit;
  end;

  if EdMulta.Text = '' then
  begin
    MessageDlg( 'Informe uma multa v�lida!', MtInformation, [ MbOK ], 0 );
    EdMulta.SetFocus;
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

function TFrm_Cad_CondicaoPagamento.ValidarParcela: Boolean;
begin
  Result := False;

  if EdDias.Text = '' then
  begin
    MessageDlg( 'Insira um valor v�lido para Dias da Parcela!', MtInformation, [ MbOK ], 0 );
    EdDias.SetFocus;
    Exit;
  end;

  if not( TDset_Parcelas.IsEmpty ) then
  begin
    TDset_Parcelas.Last;

    if ( StrToInt( EdDias.Text ) <= TDset_Parcelasdias.Value ) then
    begin
      MessageDlg( 'Os dias da parcela n�o podem ser inferior ou igual aos dias da parcela anterior!', MtInformation, [ MbOK ], 0 );
      EdDias.SetFocus;
      Exit;
    end;
  end;

  if EdPorcentagem.Text = '' then
  begin
    MessageDlg( 'Insira um valor v�lido para Porcentagem ' + Chr( 39 ) + '%' + Chr( 39 ) + ' da Parcela!', MtInformation, [ MbOK ], 0 );
    EdPorcentagem.SetFocus;
    Exit;
  end;

  if ( EdCodFormaPagamento.Text = '' ) or ( EdFormaPagamento.Text = '' ) then
  begin
    MessageDlg( 'Insira uma forma de pagamento v�lida para a Parcela!', MtInformation, [ MbOK ], 0 );
    EdPorcentagem.SetFocus;
    Exit;
  end;

  if not( TotalPorcentagem < 100 ) then
  begin
    MessageDlg( 'O total de porcentagem das parcelas j� atingiu 100%!', MtInformation, [ MbOK ], 0 );
    EdPorcentagem.SetFocus;
    Exit;
  end;

  if ( TotalPorcentagem + StrToFloat( EdPorcentagem.Text ) ) > 100 then
  begin
    MessageDlg( 'O valor de porcentagem informado � superior a 100%!', MtInformation, [ MbOK ], 0 );
    EdPorcentagem.SetFocus;
    Exit;
  end;

  Result := True;
end;

end.
