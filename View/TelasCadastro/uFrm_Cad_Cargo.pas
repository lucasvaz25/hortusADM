unit uFrm_Cad_Cargo;

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
  Vcl.Imaging.Pngimage,
  Vcl.ExtCtrls,
  Vcl.DBCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  VazEdit,
  UDepartamentosController,
  UCargosController;

type
  TFrm_Cad_Cargo = class( TFrm_Cadastro )
    LblCargo: TLabel;
    EdCargo: TVazEdit;
    LblDepartamento: TLabel;
    EdDepartamento: TVazEdit;
    EdCodDept: TVazEdit;
    LblCodDept: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    BtnPesquisar: TSpeedButton;
    ChkObrigatorioCNH: TCheckBox;
    procedure BtnPesquisarClick( Sender: TObject );
    procedure EdCodDeptKeyPress( Sender: TObject; var Key: Char );
    procedure EdCodDeptExit( Sender: TObject );
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultaDept;
    procedure PesquisaDept;
  public
    { Public declarations }
    DeptControl: TDepartamentosController;
    CargoControl: TCargosController;

    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Cargo: TFrm_Cad_Cargo;

implementation

uses
  UFilterSearch,
  UFrm_Consulta_Departamentos,
  UDepartamentos;
{$R *.dfm}

{ TFrm_Cad_Cargo }

procedure TFrm_Cad_Cargo.BtnPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaDept;
end;

procedure TFrm_Cad_Cargo.ConsultaDept;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodDept.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodDept.Text );
      List                := DeptControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdDepartamento.Text := TDepartamentos( List[ 0 ] ).Departamento;
        CargoControl.GetEntity.Departamento.CopiarDados( TDepartamentos( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Departamento n�o encontrado!!' );
        EdCodDept.Clear;
        EdDepartamento.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Cargo.EdCodDeptExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaDept;
end;

procedure TFrm_Cad_Cargo.EdCodDeptKeyPress( Sender: TObject; var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaDept;
end;

procedure TFrm_Cad_Cargo.FormCreate( Sender: TObject );
begin
  inherited;
  CargoControl := nil;
  CargoControl.GetInstance( CargoControl, Self );

  DeptControl := nil;
  DeptControl.GetInstance( DeptControl, Self );
end;

procedure TFrm_Cad_Cargo.PesquisaDept;
var
  Frm: TFrm_Consulta_Departamentos;
begin
  inherited;
  Frm := TFrm_Consulta_Departamentos.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdDepartamento.Text := Frm.DeptControl.GetEntity.Departamento;
    EdCodDept.Text      := IntToStr( Frm.DeptControl.GetEntity.Codigo );
    CargoControl.GetEntity.Departamento.CopiarDados( Frm.DeptControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Cargo.PopulaForm;
begin
  inherited;
  with CargoControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    ChkObrigatorioCNH.Checked := IsObrigatorioCNH;
    EdCargo.Text              := Cargo;
    EdCodDept.Text            := IntToStr( Departamento.Codigo );
    EdDepartamento.Text       := Departamento.Departamento;
    LblUsuarioDataCad.Caption := 'Usu�rio: ' + Usercad + ' - Data Cadastro :' + Datetostr( DataCad );
  end;
end;

procedure TFrm_Cad_Cargo.PopulaObj;
begin
  with CargoControl.GetEntity do
  begin
    Codigo           := StrToInt( EdCodigo.Text );
    Cargo            := UpperCase( EdCargo.Text );
    IsObrigatorioCNH := ChkObrigatorioCNH.Checked;
    DataCad          := Date;
    UserCad          := UpperCase( 'lucas' );
  end;
end;

procedure TFrm_Cad_Cargo.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Cargo.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := CargoControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := CargoControl.Inserir( Aux )
    else
      Salvou := CargoControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_Cargo.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdCargo.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Cargo v�lido!!', MtInformation, [ MbOK ], 0 );
    EdCargo.SetFocus;
    Exit;
  end;

  if ( EdCodDept.Text = '' ) or ( EdDepartamento.Text = '' ) then
  begin
    MessageDlg( 'Selecione um Departamento v�lido!!', MtInformation, [ MbOK ], 0 );
    EdDepartamento.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if CargoControl.VerificaExiste( UpperCase( EdCargo.Text ) ) then
    begin
      MessageDlg( 'J� existe um Cargo com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdCargo.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
