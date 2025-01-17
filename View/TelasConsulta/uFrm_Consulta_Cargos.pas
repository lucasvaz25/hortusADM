unit uFrm_Consulta_Cargos;

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
  Datasnap.DBClient,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VazEdit,
  Vcl.Imaging.Pngimage,
  Vcl.Buttons,
  UCargosController;

type
  TFrm_Consulta_Cargos = class( TFrm_Consulta )
    TDset_Cargos: TClientDataSet;
    TDset_Cargoscodigo: TIntegerField;
    TDset_Cargoscargo: TStringField;
    TDset_Cargosdept: TStringField;
    DsCargos: TDataSource;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    CargoControl: TCargosController;

    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Cargos: TFrm_Consulta_Cargos;

implementation

uses
  UCargos,
  UFilterSearch,
  System.Contnrs,
  UFrm_Cad_Cargo;
{$R *.dfm}

{ TFrm_Consulta_Cargos }

procedure TFrm_Consulta_Cargos.Alterar;
var
  Frm: TFrm_Cad_Cargo;
  Aux: TCargos;
begin
  inherited;

  if TDset_Cargos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TCargos.Create;
  try
    if CargoControl.Recuperar( TDset_Cargoscodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Cargo.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.CargoControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Cargos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Cargos.EmptyDataSet;

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

    Lista := CargoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Cargos.Append;
        TDset_Cargoscodigo.Value   := TCargos( Lista.Items[ I ] ).Codigo;
        TDset_Cargoscargo.AsString := TCargos( Lista.Items[ I ] ).Cargo;
        TDset_Cargosdept.AsString  := TCargos( Lista.Items[ I ] ).Departamento.Departamento;
        TDset_Cargos.Post;
      end;
    end;
    TDset_Cargos.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Cargos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Cargos.Excluir;
begin
  inherited;
  if TDset_Cargos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Cargoscodigo.AsInteger ) + ' - '
              + TDset_Cargoscargo.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if CargoControl.Deletar( TDset_Cargoscodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Cargos.FormCreate( Sender: TObject );
begin
  inherited;
  CargoControl := nil;
  CargoControl.GetInstance( CargoControl, Self );

  TDset_Cargos.AfterScroll := nil;
  if ( not TDset_Cargos.IsEmpty ) then
    TDset_Cargos.EmptyDataSet;
  TDset_Cargos.Active := False;
  TDset_Cargos.DisableControls;
  TDset_Cargos.CreateDataSet;

  TDset_Cargos.Open;
end;

procedure TFrm_Consulta_Cargos.FormDestroy( Sender: TObject );
begin
  CargoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Cargos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Cargos.Novo;
var
  Frm: TFrm_Cad_Cargo;
begin
  inherited;

  Frm := TFrm_Cad_Cargo.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Cargos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Cargos.SelecionaRegistro;
var
  Aux: TCargos;
begin
  Aux := TCargos.Create;
  try
    CargoControl.Recuperar( TDset_Cargoscodigo.Value, TObject( Aux ) );
    CargoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
