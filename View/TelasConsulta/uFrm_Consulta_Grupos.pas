unit uFrm_Consulta_Grupos;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Contnrs,
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
  UGrupos,
  UGruposController,
  Datasnap.DBClient;

type
  TFrm_Consulta_Grupos = class( TFrm_Consulta )
    DsGrupos: TDataSource;
    TDset_Grupos: TClientDataSet;
    TDset_Gruposcodigo: TIntegerField;
    TDset_Gruposgrupo: TStringField;
    TDset_Gruposdatacad: TDateTimeField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    GrupoControl: TGruposController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Grupos: TFrm_Consulta_Grupos;

implementation

uses
  UFilterSearch,
  UFrm_Cad_Grupo;
{$R *.dfm}

{ TFrm_Consulta_Grupos }

procedure TFrm_Consulta_Grupos.Alterar;
var
  Frm: TFrm_Cad_Grupo;
  Aux: TGrupos;
begin
  inherited;

  if TDset_Grupos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TGrupos.Create;
  try
    if GrupoControl.Recuperar( TDset_Gruposcodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Grupo.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.GrupoControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Grupos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Grupos.EmptyDataSet;

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

    Lista := GrupoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Grupos.Append;
        TDset_Gruposcodigo.Value       := TGrupos( Lista.Items[ I ] ).Codigo;
        TDset_Gruposgrupo.AsString     := TGrupos( Lista.Items[ I ] ).Grupo;
        TDset_Gruposdatacad.AsDateTime := TGrupos( Lista.Items[ I ] ).DataCad;
        TDset_Grupos.Post;
      end;
    end;
    TDset_Grupos.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Grupos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Grupos.Excluir;
begin
  inherited;
  if TDset_Grupos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Gruposcodigo.AsInteger ) + ' - '
              + TDset_Gruposgrupo.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if GrupoControl.Deletar( TDset_Gruposcodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Grupos.FormCreate( Sender: TObject );
begin
  inherited;

  GrupoControl := nil;
  GrupoControl.GetInstance( GrupoControl, Self );

  TDset_Grupos.AfterScroll := nil;
  if ( not TDset_Grupos.IsEmpty ) then
    TDset_Grupos.EmptyDataSet;
  TDset_Grupos.Active := False;
  TDset_Grupos.DisableControls;
  TDset_Grupos.CreateDataSet;

  TDset_Grupos.Open;
end;

procedure TFrm_Consulta_Grupos.FormDestroy( Sender: TObject );
begin
  GrupoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Grupos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Grupos.Novo;
var
  Frm: TFrm_Cad_Grupo;
begin
  inherited;

  Frm := TFrm_Cad_Grupo.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Grupos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Grupos.SelecionaRegistro;
var
  Aux: TGrupos;
begin
  Aux := TGrupos.Create;
  try
    GrupoControl.Recuperar( TDset_Gruposcodigo.Value, TObject( Aux ) );
    GrupoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
