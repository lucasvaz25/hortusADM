unit uFrm_Consulta_CondicaoPagamento;

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

  UParcelasController,
  UCondicaoPagamentoController,
  Datasnap.DBClient;

type
  TFrm_Consulta_CondicaoPagamento = class( TFrm_Consulta )
    DsCondPag: TDataSource;
    TDset_CondPag: TClientDataSet;
    TDset_CondPagCodigo: TIntegerField;
    TDset_CondPagcondpag: TStringField;
    TDset_CondPagparcelas: TIntegerField;
    TDset_CondPagdatacad: TDateField;
    TDset_CondPagusercad: TStringField;
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    CondPagControl: TCondicaoPagamentoController;
    Parcelacontrol: TParcelasController;

    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_CondicaoPagamento: TFrm_Consulta_CondicaoPagamento;

implementation

uses
  UCondicaoPagamento,
  UFilterSearch,
  System.Contnrs,
  UFrm_Cad_CondicaoPagamento;
{$R *.dfm}

{ TFrm_Consulta_CondicaoPagamento }

procedure TFrm_Consulta_CondicaoPagamento.Alterar;
var
  Aux: TCondicaoPagamento;
  Frm: TFrm_Cad_CondicaoPagamento;
begin
  inherited;
  if TDset_CondPag.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TCondicaoPagamento.Create;
  try
    if CondPagControl.Recuperar( TDset_CondPagcodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_CondicaoPagamento.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.CondPagControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_CondicaoPagamento.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_CondPag.EmptyDataSet;

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

    Lista := CondPagControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_CondPag.Append;
        TDset_CondPagcodigo.Value       := TCondicaoPagamento( Lista.Items[ I ] ).Codigo;
        TDset_CondPagcondpag.AsString   := TCondicaoPagamento( Lista.Items[ I ] ).CondPag;
        TDset_CondPagparcelas.AsInteger := TCondicaoPagamento( Lista.Items[ I ] ).Parcelas;
        TDset_CondPagdatacad.AsDateTime := TCondicaoPagamento( Lista.Items[ I ] ).DataCad;
        TDset_CondPagusercad.AsString   := TCondicaoPagamento( Lista.Items[ I ] ).UserCad;
        TDset_CondPag.Post;
      end;
    end;
    TDset_CondPag.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_CondicaoPagamento.Excluir;
begin
  inherited;
  if TDset_CondPag.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_CondPagCodigo.AsInteger ) + ' - '
              + TDset_CondPagcondpag.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if Parcelacontrol.ExcluirListaParcelas( TDset_CondPagCodigo.AsInteger ) then
      if CondPagControl.Deletar( TDset_CondPagCodigo.AsInteger ) then
        Self.Consultar;
  end;
end;

procedure TFrm_Consulta_CondicaoPagamento.FormCreate( Sender: TObject );
begin
  inherited;
  CondPagControl := nil;
  CondPagControl.GetInstance( CondPagControl, Self );

  Parcelacontrol := nil;
  Parcelacontrol.GetInstance( Parcelacontrol, Self );

  TDset_CondPag.AfterScroll := nil;
  if ( not TDset_CondPag.IsEmpty ) then
    TDset_CondPag.EmptyDataSet;
  TDset_CondPag.Active := False;
  TDset_CondPag.DisableControls;
  TDset_CondPag.CreateDataSet;

  TDset_CondPag.Open;
end;

procedure TFrm_Consulta_CondicaoPagamento.Novo;
var
  Frm: TFrm_Cad_CondicaoPagamento;
begin
  inherited;

  Frm := TFrm_Cad_CondicaoPagamento.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_CondicaoPagamento.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_CondicaoPagamento.SelecionaRegistro;
var
  Aux: TCondicaoPagamento;
begin
  Aux := TCondicaoPagamento.Create;
  try
    CondPagControl.Recuperar( TDset_CondPagCodigo.Value, TObject( Aux ) );
    CondPagControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
