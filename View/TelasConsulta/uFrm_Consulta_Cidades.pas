unit uFrm_Consulta_Cidades;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Contnrs,
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

  UCidades,
  UCidadesController,
  UFilterSearch;

type
  TFrm_Consulta_Cidades = class( TFrm_Consulta )
    DsCidades: TDataSource;
    TDset_Cidades: TClientDataSet;
    TDset_Cidadescodigo: TIntegerField;
    TDset_Cidadescidade: TStringField;
    TDset_Cidadesuf: TStringField;
    TDset_Cidadespais: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    CidadeControl: TCidadesController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Cidades: TFrm_Consulta_Cidades;

implementation

uses
  UFrm_Cad_Cidades;
{$R *.dfm}

{ TFrm_Consulta_Cidades }

procedure TFrm_Consulta_Cidades.Alterar;
var
  Frm: TFrm_Cad_Cidades;
  Aux: TCidade;
begin
  inherited;

  if TDset_Cidades.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;

  Aux := TCidade.Create;
  try
    if CidadeControl.Recuperar( TDset_Cidadescodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Cidades.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.CidadeControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Cidades.Consultar;
var
  ListaCidades: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Cidades.EmptyDataSet;

  VFilter      := TFilterSearch.Create;
  ListaCidades := TObjectList.Create;
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

    ListaCidades := CidadeControl.Consulta( VFilter );
    if ListaCidades <> nil then
    begin
      for I := 0 to ListaCidades.Count - 1 do
      begin
        TDset_Cidades.Append;
        TDset_Cidadescodigo.Value    := TCidade( ListaCidades.Items[ I ] ).Codigo;
        TDset_Cidadescidade.AsString := TCidade( ListaCidades.Items[ I ] ).Cidade;
        TDset_Cidadespais.AsString   := TCidade( ListaCidades.Items[ I ] ).Estado.Pais.Nome;
        TDset_Cidadesuf.AsString     := TCidade( ListaCidades.Items[ I ] ).Estado.UF;
        TDset_Cidades.Post;
      end;
    end;
    TDset_Cidades.EnableControls;
  finally
    VFilter.Free;
    ListaCidades.Free;
  end;

end;

procedure TFrm_Consulta_Cidades.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Cidades.Excluir;
begin
  inherited;
  if TDset_Cidades.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Cidadescodigo.AsInteger ) + ' - '
              + TDset_Cidadescidade.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if CidadeControl.Deletar( TDset_Cidadescodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Cidades.FormCreate( Sender: TObject );
begin
  inherited;
  CidadeControl := nil;
  CidadeControl.GetInstance( CidadeControl, Self );

  TDset_Cidades.AfterScroll := nil;
  if ( not TDset_Cidades.IsEmpty ) then
    TDset_Cidades.EmptyDataSet;
  TDset_Cidades.Active := False;
  TDset_Cidades.DisableControls;
  TDset_Cidades.CreateDataSet;

  TDset_Cidades.Open;
end;

procedure TFrm_Consulta_Cidades.FormDestroy( Sender: TObject );
begin
  CidadeControl.Free;
  inherited;
end;

procedure TFrm_Consulta_Cidades.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Cidades.Novo;
var
  Frm: TFrm_Cad_Cidades;
begin
  inherited;

  Frm := TFrm_Cad_Cidades.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Cidades.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Cidades.SelecionaRegistro;
var
  Aux: TCidade;
begin
  Aux := TCidade.Create;
  try
    CidadeControl.Recuperar( TDset_Cidadescodigo.Value, TObject( Aux ) );
    CidadeControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
