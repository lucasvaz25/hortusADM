unit uFrm_Cad_Paises;

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
  UPaises,
  UPaisesController;

type
  TFrm_Cad_Paises = class( TFrm_Cadastro )
    EdDDI: TVazEdit;
    LblDDI: TLabel;
    LblSigla: TLabel;
    EdSigla: TVazEdit;
    LblPais: TLabel;
    EdPais: TVazEdit;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
  private
    { Private declarations }
    NomePais: string;
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
  public
    { Public declarations }
    Paiscontrol: TPaisesController;
    procedure Salvar; override;
    procedure Sair; override;

  end;

var
  Frm_Cad_Paises: TFrm_Cad_Paises;

implementation

{$R *.dfm}

{ TFrm_Cad_Paises }

procedure TFrm_Cad_Paises.FormCreate( Sender: TObject );
begin
  inherited;
  Paiscontrol := nil;
  Paiscontrol.GetInstance( Paiscontrol, Self );
end;

procedure TFrm_Cad_Paises.FormDestroy( Sender: TObject );
begin
  Paiscontrol.Free;
  inherited;
end;

procedure TFrm_Cad_Paises.PopulaForm;
begin
  with PaisControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdPais.Text               := Nome;
    NomePais                  := Nome;
    EdSigla.Text              := Sigla;
    EdDDI.Text                := DDI;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_Paises.PopulaObj;
begin
  with PaisControl.GetEntity do
  begin
    Codigo  := StrToInt( EdCodigo.Text );
    Nome    := UpperCase( EdPais.Text );
    Sigla   := UpperCase( EdSigla.Text );
    DDI     := UpperCase( EdDDI.Text );
    DataCad := Date;
    UserCad := UpperCase( 'lucas' );
  end;

end;

procedure TFrm_Cad_Paises.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Paises.Salvar;
var
  Aux: TObject;
begin
  inherited;

  if ValidaForm then
  begin

    PopulaObj;

    Aux := Paiscontrol.GetEntity;

    if EdCodigo.Text = '0' then
      Salvou := Paiscontrol.Inserir( Aux )
    else
      Salvou := Paiscontrol.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_Paises.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdPais.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Pa�s v�lido!!', MtInformation, [ MbOK ], 0 );
    EdPais.SetFocus;
    Exit;
  end;

  if ( EdSigla.Text = '' ) then
  begin
    MessageDlg( 'Insira uma Sigla v�lida!!', MtInformation, [ MbOK ], 0 );
    EdSigla.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
  begin
    if Paiscontrol.VerificaExiste( UpperCase( EdPais.Text ) ) then
    begin
      MessageDlg( 'J� existe um Pa�s com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdPais.SetFocus;
      Exit;
    end;
  end
  else
  begin
    if ( NomePais <> EdPais.Text ) then
      if Paiscontrol.VerificaExiste( UpperCase( EdPais.Text ) ) then
      begin
        MessageDlg( 'J� existe um Pa�s com esse nome!!', MtInformation, [ MbOK ], 0 );
        EdPais.SetFocus;
        Exit;
      end;
  end;

  Result := True;
end;

end.
