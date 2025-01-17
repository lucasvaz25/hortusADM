unit uFrm_Consulta_Unidades;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Contnrs,
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
  UUnidadesController;

type
  TFrm_Consulta_Unidades = class( TFrm_Consulta )
    DsUnidades: TDataSource;
    TDset_Unidades: TClientDataSet;
    TDset_UnidadesCodigo: TIntegerField;
    TDset_UnidadesUnidade: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    UnidadeControl: TUnidadesController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Unidades: TFrm_Consulta_Unidades;

implementation

uses
  UFrm_Cad_Unidades,
  UFilterSearch,
  UUnidades;
{$R *.dfm}

{ TFrm_Consulta_Unidades }

procedure TFrm_Consulta_Unidades.Alterar;
var
  Frm: TFrm_Cad_Unidades;
  Aux: TUnidades;
begin
  inherited;

  if TDset_Unidades.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;

  Aux := TUnidades.Create;
  try
    if UnidadeControl.Recuperar( TDset_Unidadescodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Unidades.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.UnidadeControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Unidades.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Unidades.EmptyDataSet;

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

    Lista := UnidadeControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Unidades.Append;
        TDset_Unidadescodigo.Value     := TUnidades( Lista.Items[ I ] ).Codigo;
        TDset_UnidadesUnidade.AsString := TUnidades( Lista.Items[ I ] ).Unidade;
        TDset_Unidades.Post;
      end;
    end;
    TDset_Unidades.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Unidades.Excluir;
begin
  inherited;
  if TDset_Unidades.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Unidadescodigo.AsInteger ) + ' - '
              + TDset_UnidadesUnidade.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if UnidadeControl.Deletar( TDset_Unidadescodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Unidades.FormCreate( Sender: TObject );
begin
  inherited;
  UnidadeControl := nil;
  UnidadeControl.GetInstance( UnidadeControl, Self );

  TDset_Unidades.AfterScroll := nil;
  if ( not TDset_Unidades.IsEmpty ) then
    TDset_Unidades.EmptyDataSet;
  TDset_Unidades.Active := False;
  TDset_Unidades.DisableControls;
  TDset_Unidades.CreateDataSet;

  TDset_Unidades.Open;
end;

procedure TFrm_Consulta_Unidades.FormDestroy( Sender: TObject );
begin
  UnidadeControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Unidades.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Unidades.Novo;
var
  Frm: TFrm_Cad_Unidades;
begin
  inherited;

  Frm := TFrm_Cad_Unidades.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Unidades.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Unidades.SelecionaRegistro;
var
  Aux: TUnidades;
begin
  Aux := TUnidades.Create;
  try
    UnidadeControl.Recuperar( TDset_Unidadescodigo.Value, TObject( Aux ) );
    UnidadeControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
