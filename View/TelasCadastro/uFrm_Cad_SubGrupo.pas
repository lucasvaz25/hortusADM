unit uFrm_Cad_SubGrupo;

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
  UFrm_Cadastro,
  Vcl.Buttons,
  Vcl.StdCtrls,
  VazEdit,
  Vcl.ExtCtrls,
  Vcl.DBCtrls,
  Vcl.Imaging.Pngimage,
  USubGrupos,
  USubGruposController,
  UGruposController,
  Data.DB,
  Datasnap.DBClient;

type
  TFrm_Cad_SubGrupo = class( TFrm_Cadastro )
    LblSubGrupo: TLabel;
    EdSubGrupo: TVazEdit;
    LblObs: TLabel;
    EdObs: TMemo;
    LblGrupo: TLabel;
    EdGrupo: TVazEdit;
    EdCodGrupo: TVazEdit;
    LblCodigoGrupo: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    BtnPesquisar: TSpeedButton;
    procedure FormCreate( Sender: TObject );
    procedure BtnPesquisarClick( Sender: TObject );
    procedure EdCodGrupoExit( Sender: TObject );
    procedure EdCodGrupoKeyPress( Sender: TObject; var Key: Char );
  private
    { Private declarations }
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultaGrupoCod;
  public
    { Public declarations }
    SubGrupoControl: TSubGruposController;
    GrupoControl: TGruposController;

    procedure Salvar; override;
    procedure Sair; override;

  end;

var
  Frm_Cad_SubGrupo: TFrm_Cad_SubGrupo;

implementation

uses
  UFilterSearch,
  UGrupos,
  UFrm_Consulta_Grupos;
{$R *.dfm}

{ TFrm_Cad_SubGrupo }

procedure TFrm_Cad_SubGrupo.BtnPesquisarClick( Sender: TObject );
var
  Frm: TFrm_Consulta_Grupos;
begin
  inherited;
  Frm := TFrm_Consulta_Grupos.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdGrupo.Text    := Frm.GrupoControl.GetEntity.Grupo;
    EdCodGrupo.Text := IntToStr( Frm.GrupoControl.GetEntity.Codigo );
    SubGrupoControl.GetEntity.Grupo.CopiarDados( Frm.GrupoControl.GetEntity );
  finally
    Frm.Release;
  end;

end;

procedure TFrm_Cad_SubGrupo.ConsultaGrupoCod;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodGrupo.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodGrupo.Text );
      List                := GrupoControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        SubGrupoControl.GetEntity.Grupo.CopiarDados( TGrupos( List[ 0 ] ) );
        EdGrupo.Text := TGrupos( List[ 0 ] ).Grupo;
      end
      else
      begin
        ShowMessage( 'Grupo n�o encontrado!!' );
        EdGrupo.Clear;
        EdGrupo.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_SubGrupo.EdCodGrupoExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaGrupoCod;
end;

procedure TFrm_Cad_SubGrupo.EdCodGrupoKeyPress( Sender: TObject; var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaGrupoCod;
end;

procedure TFrm_Cad_SubGrupo.FormCreate( Sender: TObject );
begin
  inherited;
  SubGrupoControl := nil;
  SubGrupoControl.GetInstance( SubGrupoControl, Self );

  GrupoControl := nil;
  GrupoControl.GetInstance( GrupoControl, Self );

end;

procedure TFrm_Cad_SubGrupo.PopulaForm;
begin
  with SubGrupoControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdSubGrupo.Text           := Subgrupo;
    EdObs.Text                := Obs;
    EdCodGrupo.Text           := IntToStr( Grupo.Codigo );
    EdGrupo.Text              := Grupo.Grupo;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_SubGrupo.PopulaObj;
begin
  with SubGrupoControl.GetEntity do
  begin
    Codigo   := StrToInt( EdCodigo.Text );
    SubGrupo := UpperCase( EdSubGrupo.Text );
    Obs      := UpperCase( EdObs.Text );
    DataCad  := Date;
    UserCad  := UpperCase( 'lucas' );
  end;
end;

procedure TFrm_Cad_SubGrupo.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_SubGrupo.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := SubGrupoControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := SubGrupoControl.Inserir( Aux )
    else
      Salvou := SubGrupoControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_SubGrupo.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdSubGrupo.Text ) < 3 then
  begin
    MessageDlg( 'Insira um SubGrupo v�lido!!', MtInformation, [ MbOK ], 0 );
    EdSubGrupo.SetFocus;
    Exit;
  end;

  if ( EdCodGrupo.Text = '' ) or ( EdGrupo.Text = '' ) then
  begin
    MessageDlg( 'Selecione um Grupo v�lido!!', MtInformation, [ MbOK ], 0 );
    EdGrupo.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if SubGrupoControl.VerificaExiste( UpperCase( EdSubGrupo.Text ) ) then
    begin
      MessageDlg( 'J� existe um SubGrupo com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdSubGrupo.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
