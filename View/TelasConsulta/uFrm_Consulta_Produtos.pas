unit uFrm_Consulta_Produtos;

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
  UFrm_Consulta,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VazEdit,
  Vcl.Imaging.Pngimage,
  Vcl.Buttons,
  Datasnap.DBClient,
  UProdutosController;

type
  TFrm_Consulta_Produtos = class( TFrm_Consulta )
    TDset_Produtos: TClientDataSet;
    DsProdutos: TDataSource;
    TDset_Produtoscodigo: TIntegerField;
    TDset_Produtosproduto: TStringField;
    TDset_ProdutosprecoVenda: TCurrencyField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    ProdutoControl: TProdutosController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Produtos: TFrm_Consulta_Produtos;

implementation

uses
  System.Contnrs,
  UProdutos,
  UFilterSearch,
  UFrm_cad_Produtos;
{$R *.dfm}

{ TFrm_Consulta_Produtos }

procedure TFrm_Consulta_Produtos.Alterar;
var
  Frm: TFrm_Cad_Produto;
  Aux: TProdutos;
begin
  inherited;

  if TDset_Produtos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TProdutos.Create;
  try
    if ProdutoControl.Recuperar( TDset_Produtoscodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Produto.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.ProdutoControl.GetEntity.CopiarDados( Aux );
        Frm.ShowModal;
        if Frm.Salvou then
          Self.Consultar;
      finally
        Frm.Free;
      end;
    end;
  finally
    Aux.Free;
  end;
end;

procedure TFrm_Consulta_Produtos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Produtos.EmptyDataSet;

  VFilter := TFilterSearch.Create;
  Lista   := TObjectList.Create;
  try
    case RgFiltro.ItemIndex of
      0:
        begin
          if EdPesquisar.Text = '' then
          begin
            MessageDlg( 'Informe um c�digo v�lido!!', MtInformation, [ MbOK ], 0 );
            EdPesquisar.SetFocus;
            Exit;
          end;

          VFilter.TipoConsulta := TpCCodigo;
          VFilter.Codigo       := StrToInt( EdPesquisar.Text );
        end;
      1:
        begin
          if Length( EdPesquisar.Text ) < 3 then
          begin
            MessageDlg( 'Digite ao menos 3 caracteres para consulta!!', MtInformation, [ MbOK ], 0 );
            EdPesquisar.SetFocus;
            Exit;
          end;
          VFilter.TipoConsulta := TpCParam;
          VFilter.Parametro    := Uppercase( EdPesquisar.Text );
        end;
      2:
        begin
          VFilter.TipoConsulta := TpCTODOS;
        end;
    end;

    Lista := ProdutoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Produtos.Append;
        TDset_Produtoscodigo.Value          := TProdutos( Lista.Items[ I ] ).Codigo;
        TDset_Produtosproduto.AsString      := TProdutos( Lista.Items[ I ] ).Produto;
        TDset_ProdutosprecoVenda.AsCurrency := TProdutos( Lista.Items[ I ] ).PrecoVenda;
        TDset_Produtos.Post;
      end;
    end;
    TDset_Produtos.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Produtos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Produtos.Excluir;
begin
  inherited;
  if TDset_Produtos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Produtoscodigo.AsInteger ) + ' - '
              + TDset_Produtosproduto.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if ProdutoControl.Deletar( TDset_Produtoscodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Produtos.FormCreate( Sender: TObject );
begin
  inherited;
  ProdutoControl := nil;
  ProdutoControl.GetInstance( ProdutoControl, Self );

  TDset_Produtos.AfterScroll := nil;
  if ( not TDset_Produtos.IsEmpty ) then
    TDset_Produtos.EmptyDataSet;
  TDset_Produtos.Active := False;
  TDset_Produtos.DisableControls;
  TDset_Produtos.CreateDataSet;

  TDset_Produtos.Open;
end;

procedure TFrm_Consulta_Produtos.FormDestroy( Sender: TObject );
begin
  ProdutoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Produtos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Produtos.Novo;
var
  Frm: TFrm_Cad_Produto;
begin
  inherited;

  Frm := TFrm_Cad_Produto.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Produtos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Produtos.SelecionaRegistro;
var
  Aux: TProdutos;
begin
  Aux := TProdutos.Create;
  try
    ProdutoControl.Recuperar( TDset_Produtoscodigo.Value, TObject( Aux ) );
    ProdutoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
