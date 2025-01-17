unit uFrm_Consulta_SubGrupos;

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
  USubGrupos,
  USubGruposController;

type
  TFrm_Consulta_SubGrupos = class( TFrm_Consulta )
    DsSubGrupos: TDataSource;
    TDset_SubGrupos: TClientDataSet;
    TDset_SubGruposcodigo: TIntegerField;
    TDset_SubGrupossubgrupo: TStringField;
    TDset_SubGruposgrupo: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    SubGrupoControl: TSubGruposController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_SubGrupos: TFrm_Consulta_SubGrupos;

implementation

uses
  UFilterSearch,
  UFrm_Cad_SubGrupo;
{$R *.dfm}

{ TFrm_Consulta_SubGrupos }

procedure TFrm_Consulta_SubGrupos.Alterar;
var
  Frm: TFrm_Cad_SubGrupo;
  Aux: TSubGrupos;
begin
  inherited;

  if TDset_SubGrupos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TSubGrupos.Create;
  try
    if SubGrupoControl.Recuperar( TDset_SubGruposcodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_SubGrupo.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.SubGrupoControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_SubGrupos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_SubGrupos.EmptyDataSet;

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

    Lista := SubGrupoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_SubGrupos.Append;
        TDset_SubGruposcodigo.Value      := TSubGrupos( Lista.Items[ I ] ).Codigo;
        TDset_SubGrupossubgrupo.AsString := TSubGrupos( Lista.Items[ I ] ).Subgrupo;
        TDset_SubGruposgrupo.AsString    := TSubGrupos( Lista.Items[ I ] ).Grupo.Grupo;
        TDset_SubGrupos.Post;
      end;
    end;
    TDset_SubGrupos.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_SubGrupos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_SubGrupos.Excluir;
begin
  inherited;
  if TDset_SubGrupos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_SubGruposcodigo.AsInteger ) + ' - '
              + TDset_SubGrupossubgrupo.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if SubGrupoControl.Deletar( TDset_SubGruposcodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_SubGrupos.FormCreate( Sender: TObject );
begin
  inherited;
  SubGrupoControl := nil;
  SubGrupoControl.GetInstance( SubGrupoControl, Self );

  TDset_SubGrupos.AfterScroll := nil;
  if ( not TDset_SubGrupos.IsEmpty ) then
    TDset_SubGrupos.EmptyDataSet;
  TDset_SubGrupos.Active := False;
  TDset_SubGrupos.DisableControls;
  TDset_SubGrupos.CreateDataSet;

  TDset_SubGrupos.Open;
end;

procedure TFrm_Consulta_SubGrupos.FormDestroy( Sender: TObject );
begin
  SubGrupoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_SubGrupos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_SubGrupos.Novo;
var
  Frm: TFrm_Cad_SubGrupo;
begin
  inherited;

  Frm := TFrm_Cad_SubGrupo.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_SubGrupos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_SubGrupos.SelecionaRegistro;
var
  Aux: TSubGrupos;
begin
  Aux := TSubGrupos.Create;
  try
    SubGrupoControl.Recuperar( TDset_SubGruposcodigo.Value, TObject( Aux ) );
    SubGrupoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
