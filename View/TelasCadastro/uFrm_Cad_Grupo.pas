unit uFrm_Cad_Grupo;

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
  Vcl.StdCtrls,
  Vcl.Buttons,
  VazEdit,
  Vcl.ExtCtrls,
  UGrupos,
  UGruposController;

type
  TFrm_Cad_Grupo = class( TFrm_Cadastro )
    EdGrupo: TVazEdit;
    LblGrupo: TLabel;
    EdObs: TMemo;
    LblObs: TLabel;
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
  private
    { Private declarations }
    procedure PopulaObj;
    procedure PopulaForm;
    function ValidaForm: Boolean;
  public
    { Public declarations }
    GrupoControl: TGruposController;

    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Grupo: TFrm_Cad_Grupo;

implementation

{$R *.dfm}

{ TFrm_Cad_Grupo }

procedure TFrm_Cad_Grupo.FormCreate( Sender: TObject );
begin
  inherited;
  GrupoControl := nil;
  GrupoControl.GetInstance( GrupoControl, Self );

end;

procedure TFrm_Cad_Grupo.FormShow( Sender: TObject );
begin
  inherited;
  if not( EdCodigo.Text = '0' ) then
    PopulaForm;
end;

procedure TFrm_Cad_Grupo.PopulaForm;
begin
  with GrupoControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdGrupo.Text              := Grupo;
    EdObs.Text                := Obs;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_Grupo.PopulaObj;
begin
  with GrupoControl.GetEntity do
  begin
    Codigo  := StrToInt( EdCodigo.Text );
    Grupo   := UpperCase( EdGrupo.Text );
    Obs     := UpperCase( EdObs.Text );
    DataCad := Date;
    UserCad := UpperCase( 'lucas' );
  end;
end;

procedure TFrm_Cad_Grupo.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Grupo.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := GrupoControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := GrupoControl.Inserir( Aux )
    else
      Salvou := GrupoControl.Editar( Aux );

    Self.Sair;
  end;
end;

function TFrm_Cad_Grupo.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdGrupo.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Grupo v�lido!!', MtInformation, [ MbOK ], 0 );
    EdGrupo.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if GrupoControl.VerificaExiste( UpperCase( EdGrupo.Text ) ) then
    begin
      MessageDlg( 'J� existe um Grupo com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdGrupo.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.