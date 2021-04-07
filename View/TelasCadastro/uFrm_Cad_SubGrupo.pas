unit uFrm_Cad_SubGrupo;

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
    LkpGrupo: TDBLookupComboBox;
    Pnlbotoes: TPanel;
    PnlNovoCad: TPanel;
    ImgNovoCad: TImage;
    BtnNovoCad: TSpeedButton;
    PnlAlterarCad: TPanel;
    ImgAlterarCad: TImage;
    BtnAlterarCad: TSpeedButton;
    DsGrupo: TDataSource;
    TDset_Grupo: TClientDataSet;
    TDset_Grupocodigo: TIntegerField;
    TDset_Grupogrupo: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure BtnNovoCadClick( Sender: TObject );
  private
    { Private declarations }
    procedure PopulaObj;
    procedure PopulaForm;
    function ValidaForm: Boolean;
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
  UFrm_Cad_Grupo;
{$R *.dfm}

{ TFrm_Cad_SubGrupo }

procedure TFrm_Cad_SubGrupo.BtnNovoCadClick( Sender: TObject );
var
  Form: TFrm_Cad_Grupo;
begin
  inherited;
  Form := TFrm_Cad_Grupo.Create( Self );
  try
    Form.ShowModal;
    if Form.Salvou then
    begin
      GrupoControl.PopularLkpGrupo( TDset_Grupo );
      LkpGrupo.KeyValue := Form.GrupoControl.GetEntity.Codigo;
    end;
  finally
    Form.Free;
  end;
  // if LkpGrupo.KeyValue = Null then

end;

procedure TFrm_Cad_SubGrupo.FormCreate( Sender: TObject );
begin
  inherited;
  SubGrupoControl := nil;
  SubGrupoControl.GetInstance( SubGrupoControl, Self );

  GrupoControl := nil;
  GrupoControl.GetInstance( GrupoControl, Self );

  TDset_Grupo.AfterScroll := nil;
  if ( not TDset_Grupo.IsEmpty ) then
    TDset_Grupo.EmptyDataSet;
  TDset_Grupo.Active := False;
  TDset_Grupo.DisableControls;
  TDset_Grupo.CreateDataSet;

  TDset_Grupo.Open;

  GrupoControl.PopularLkpGrupo( TDset_Grupo );

end;

procedure TFrm_Cad_SubGrupo.FormShow( Sender: TObject );
begin
  inherited;
  if not( EdCodigo.Text = '0' ) then
    PopulaForm;
end;

procedure TFrm_Cad_SubGrupo.PopulaForm;
begin
  with SubGrupoControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdSubGrupo.Text           := Subgrupo;
    EdObs.Text                := Obs;
    LkpGrupo.KeyValue         := Grupo.Codigo;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_SubGrupo.PopulaObj;
begin
  with SubGrupoControl.GetEntity do
  begin
    Codigo       := StrToInt( EdCodigo.Text );
    SubGrupo     := UpperCase( EdSubGrupo.Text );
    Obs          := UpperCase( EdObs.Text );
    Grupo.Codigo := LkpGrupo.KeyValue;
    DataCad      := Date;
    UserCad      := UpperCase( 'lucas' );
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

  if LkpGrupo.Text = '' then
  begin
    MessageDlg( 'Selecione um Grupo v�lido!!', MtInformation, [ MbOK ], 0 );
    LkpGrupo.SetFocus;
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