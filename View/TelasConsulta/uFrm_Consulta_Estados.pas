unit uFrm_Consulta_Estados;

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
  System.Contnrs,
  VazEdit,
  Vcl.Imaging.Pngimage,
  Vcl.Buttons,
  UEstados,
  UEstadosController,
  Datasnap.DBClient;

type
  TFrm_Consulta_Estados = class( TFrm_Consulta )
    DsEstados: TDataSource;
    TDset_Estados: TClientDataSet;
    TDset_Estadoscodigo: TIntegerField;
    TDset_Estadosestado: TStringField;
    TDset_Estadospais: TStringField;
    TDset_EstadosUF: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    EstadoControl: TEstadosController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Estados: TFrm_Consulta_Estados;

implementation

uses
  UFilterSearch,
  UFrm_Cad_Estados;
{$R *.dfm}

{ TFrm_Consulta_Estados }

procedure TFrm_Consulta_Estados.Alterar;
var
  Frm: TFrm_Cad_Estados;
  Aux: TEstado;
begin
  inherited;

  if TDset_Estados.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TEstado.Create;
  try
    if EstadoControl.Recuperar( TDset_Estadoscodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Estados.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.EstadoControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Estados.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Estados.EmptyDataSet;

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

    Lista := EstadoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Estados.Append;
        TDset_Estadoscodigo.Value    := TEstado( Lista.Items[ I ] ).Codigo;
        TDset_Estadosestado.AsString := TEstado( Lista.Items[ I ] ).Estado;
        TDset_EstadosUF.AsString     := TEstado( Lista.Items[ I ] ).UF;
        TDset_Estadospais.AsString   := TEstado( Lista.Items[ I ] ).Pais.Nome;
        TDset_Estados.Post;
      end;
    end;
    TDset_Estados.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Estados.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Estados.Excluir;
begin
  inherited;
  if TDset_Estados.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Estadoscodigo.AsInteger ) + ' - '
              + TDset_Estadosestado.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if EstadoControl.Deletar( TDset_Estadoscodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Estados.FormCreate( Sender: TObject );
begin
  inherited;

  EstadoControl := nil;
  EstadoControl.GetInstance( EstadoControl, Self );

  TDset_Estados.AfterScroll := nil;
  if ( not TDset_Estados.IsEmpty ) then
    TDset_Estados.EmptyDataSet;
  TDset_Estados.Active := False;
  TDset_Estados.DisableControls;
  TDset_Estados.CreateDataSet;

  TDset_Estados.Open;
end;

procedure TFrm_Consulta_Estados.FormDestroy( Sender: TObject );
begin
  EstadoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Estados.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Estados.Novo;
var
  Frm: TFrm_Cad_Estados;
begin
  inherited;

  Frm := TFrm_Cad_Estados.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Estados.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Estados.SelecionaRegistro;
var
  Aux: TEstado;
begin
  Aux := TEstado.Create;
  try
    EstadoControl.Recuperar( TDset_Estadoscodigo.Value, TObject( Aux ) );
    EstadoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
