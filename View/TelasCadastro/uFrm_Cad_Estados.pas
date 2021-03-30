unit uFrm_Cad_Estados;

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
  Vcl.Imaging.Pngimage,
  UEstados,
  UPaises,
  UPaisesController,
  UEstadosController;

type
  TFrm_Cad_Estados = class( TFrm_Cadastro )
    EdEstado: TVazEdit;
    LblEstado: TLabel;
    EdUF: TVazEdit;
    LblUF: TLabel;
    EdPais: TVazEdit;
    LblPais: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    BalloonHint1: TBalloonHint;
    BtnPesquisar: TSpeedButton;
    procedure ImgPesquisarMouseMove( Sender: TObject; Shift: TShiftState; X,
                Y: Integer );
    procedure ImgPesquisarMouseLeave( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure BtnPesquisarClick( Sender: TObject );
  private
    { Private declarations }

    procedure PopulaObj;
    procedure PopulaForm;
    function ValidaForm: Boolean;
  public
    { Public declarations }
    PaisControl: TPaisesController;
    EstadoControl: TEstadosController;

    procedure Salvar; override;
    procedure Sair; override;

  end;

var
  Frm_Cad_Estados: TFrm_Cad_Estados;

implementation

uses
  UFrm_Consulta_Paises;
{$R *.dfm}


procedure TFrm_Cad_Estados.BtnPesquisarClick( Sender: TObject );
var
  Frm: TFrm_ConsultaPaises;
begin
  inherited;
  //
  Frm := TFrm_ConsultaPaises.Create( Self );
  Frm.ShowModal;
  EdPais.Text := Frm.PaisControl.GetEntity.Nome;
  EstadoControl.GetEntity.Pais.CopiarDados( Frm.PaisControl.GetEntity );
  Frm.Release;
end;

procedure TFrm_Cad_Estados.FormCreate( Sender: TObject );
begin
  inherited;
  PaisControl := nil;
  PaisControl.GetInstance( PaisControl, Self );

  EstadoControl := nil;
  EstadoControl.GetInstance( EstadoControl, Self );
end;

procedure TFrm_Cad_Estados.FormShow( Sender: TObject );
begin
  inherited;
  if not( EdCodigo.Text = '0' ) then
    PopulaForm;
end;

procedure TFrm_Cad_Estados.ImgPesquisarMouseLeave( Sender: TObject );
begin
  inherited;
  PnlPesquisar.Color := $00FF8000;
end;

procedure TFrm_Cad_Estados.ImgPesquisarMouseMove( Sender: TObject;
            Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  PnlPesquisar.Color := $00FFB164;
end;

procedure TFrm_Cad_Estados.PopulaForm;
begin
  with EstadoControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdEstado.Text             := Estado;
    EdPais.Text               := Pais.Nome;
    EdUF.Text                 := UF;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_Estados.PopulaObj;
begin
  with EstadoControl.GetEntity do
  begin
    Codigo  := StrToInt( EdCodigo.Text );
    Estado  := UpperCase( EdEstado.Text );
    UF      := UpperCase( EdUF.Text );
    DataCad := Date;
    UserCad := UpperCase( 'lucas' );
  end;
end;

procedure TFrm_Cad_Estados.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Estados.Salvar;
var
  Aux: TEstado;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := EstadoControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := EstadoControl.Inserir( Aux )
    else
      Salvou := EstadoControl.Editar( Aux );

    Self.Sair;
  end;
end;

function TFrm_Cad_Estados.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdEstado.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Estado v�lido!!', MtInformation, [ MbOK ], 0 );
    EdEstado.SetFocus;
    Exit;
  end;

  if Length( EdPais.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Pa�s v�lido!!', MtInformation, [ MbOK ], 0 );
    EdPais.SetFocus;
    Exit;
  end;

  // somente obrigat�rio se pais for brasil
  if EstadoControl.GetEntity.Pais.Codigo = 1 then
    if ( EdUF.Text = '' ) then
    begin
      MessageDlg( 'Insira uma UF v�lida!!', MtInformation, [ MbOK ], 0 );
      EdUF.SetFocus;
      Exit;
    end;

  if EdCodigo.Text = '0' then
    if Estadocontrol.VerificaExiste( UpperCase( EdEstado.Text ) ) then
    begin
      MessageDlg( 'J� existe um Estado com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdEstado.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
