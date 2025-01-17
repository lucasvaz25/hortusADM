unit uFrm_Cad_Unidades;

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
  UUnidadesController;

type
  TFrm_Cad_Unidades = class( TFrm_Cadastro )
    EdUnidade: TVazEdit;
    LblUnidade: TLabel;
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
  public
    { Public declarations }
    UnidadeControl: TUnidadesController;
    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Unidades: TFrm_Cad_Unidades;

implementation

uses
  UFilterSearch,
  UUnidades;
{$R *.dfm}

{ TFrm_Cad_Unidades }

procedure TFrm_Cad_Unidades.FormCreate( Sender: TObject );
begin
  inherited;
  UnidadeControl := nil;
  UnidadeControl.GetInstance( UnidadeControl, Self );
end;

procedure TFrm_Cad_Unidades.PopulaForm;
begin
  with UnidadeControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdUnidade.Text            := Unidade;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_Unidades.PopulaObj;
begin
  with UnidadeControl.GetEntity do
  begin
    Codigo  := StrToInt( EdCodigo.Text );
    Unidade := UpperCase( EdUnidade.Text );
    DataCad := Date;
    UserCad := UpperCase( 'lucas' );
  end;
end;

procedure TFrm_Cad_Unidades.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Unidades.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := UnidadeControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := UnidadeControl.Inserir( Aux )
    else
      Salvou := UnidadeControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_Unidades.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdUnidade.Text ) < 3 then
  begin
    MessageDlg( 'Insira uma unidade v�lida!!', MtInformation, [ MbOK ], 0 );
    EdUnidade.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if UnidadeControl.VerificaExiste( UpperCase( EdUnidade.Text ) ) then
    begin
      MessageDlg( 'J� existe uma unidade com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdUnidade.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
