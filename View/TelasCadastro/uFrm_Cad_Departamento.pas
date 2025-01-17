unit uFrm_Cad_Departamento;

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
  UDepartamentos,
  UDepartamentosController;

type
  TFrm_Cad_Departamento = class( TFrm_Cadastro )
    LblDepartamento: TLabel;
    EdDepartamento: TVazEdit;
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
  public
    { Public declarations }
    DeptControl: TDepartamentosController;

    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Departamento: TFrm_Cad_Departamento;

implementation

{$R *.dfm}

{ TFrm_Cad_Departamento }

procedure TFrm_Cad_Departamento.FormCreate( Sender: TObject );
begin
  inherited;
  DeptControl := nil;
  DeptControl.GetInstance( DeptControl, Self );
end;

procedure TFrm_Cad_Departamento.PopulaForm;
begin
  with DeptControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdDepartamento.Text       := Departamento;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_Departamento.PopulaObj;
begin
  with DeptControl.GetEntity do
  begin
    Codigo       := StrToInt( EdCodigo.Text );
    Departamento := UpperCase( EdDepartamento.Text );
    DataCad      := Date;
    UserCad      := UpperCase( 'lucas' );
  end;
end;

procedure TFrm_Cad_Departamento.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Departamento.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := DeptControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := DeptControl.Inserir( Aux )
    else
      Salvou := DeptControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_Departamento.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdDepartamento.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Departamento v�lido!!', MtInformation, [ MbOK ], 0 );
    EdDepartamento.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if DeptControl.VerificaExiste( UpperCase( EdDepartamento.Text ) ) then
    begin
      MessageDlg( 'J� existe um Departamento com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdDepartamento.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
