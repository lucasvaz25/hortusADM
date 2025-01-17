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
    EdCodPais: TVazEdit;
    LblCodDept: TLabel;
    procedure ImgPesquisarMouseMove( Sender: TObject; Shift: TShiftState; X,
                Y: Integer );
    procedure ImgPesquisarMouseLeave( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure BtnPesquisarClick( Sender: TObject );
    procedure EdCodPaisExit( Sender: TObject );
    procedure EdCodPaisKeyPress( Sender: TObject; var Key: Char );
  private
    { Private declarations }
    NomeEstado: string;
    PaisControl: TPaisesController;

    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultarPais;
    procedure PesquisaBtnPais;
  public
    { Public declarations }
    EstadoControl: TEstadosController;

    procedure Salvar; override;
    procedure Sair; override;

  end;

var
  Frm_Cad_Estados: TFrm_Cad_Estados;

implementation

uses
  System.Contnrs,
  UEnum,
  UFilterSearch,
  UPaises,
  UEstados,
  UFrm_Consulta_Paises;
{$R *.dfm}


procedure TFrm_Cad_Estados.BtnPesquisarClick( Sender: TObject );
begin
  Self.PesquisaBtnPais;
end;

procedure TFrm_Cad_Estados.ConsultarPais;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodPais.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.RecuperarObj := True;
      Filtro.Codigo       := StrToInt( EdCodPais.Text );
      List                := PaisControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdPais.Text := TPais( List[ 0 ] ).Nome;
        EstadoControl.GetEntity.Pais.CopiarDados( TPais( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Pa�s n�o encontrado!!' );
        EdCodPais.Clear;
        EdCodPais.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Estados.EdCodPaisExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarPais;
end;

procedure TFrm_Cad_Estados.EdCodPaisKeyPress( Sender: TObject; var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarPais;
end;

procedure TFrm_Cad_Estados.FormCreate( Sender: TObject );
begin
  inherited;
  PaisControl := nil;
  PaisControl.GetInstance( PaisControl, Self );

  EstadoControl := nil;
  EstadoControl.GetInstance( EstadoControl, Self );
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

procedure TFrm_Cad_Estados.PesquisaBtnPais;
var
  Frm: TFrm_ConsultaPaises;
begin
  inherited;
  Frm := TFrm_ConsultaPaises.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdPais.Text    := Frm.PaisControl.GetEntity.Nome;
    EdCodPais.Text := IntToStr( Frm.PaisControl.GetEntity.Codigo );
    Estadocontrol.GetEntity.Pais.CopiarDados
                ( Frm.PaisControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Estados.PopulaForm;
begin
  with EstadoControl.GetEntity do
  begin
    EdCodigo.Text             := IntToStr( Codigo );
    EdEstado.Text             := Estado;
    NomeEstado                := Estado;
    EdCodPais.Text            := Pais.Codigo.ToString;
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
  Aux: TObject;
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

    if Salvou then
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
  begin
    if Estadocontrol.VerificaExiste( UpperCase( EdEstado.Text ) ) then
    begin
      MessageDlg( 'J� existe um Estado com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdEstado.SetFocus;
      Exit;
    end;
  end
  else
  begin
    if ( NomeEstado <> EdEstado.Text ) then
      if Estadocontrol.VerificaExiste( UpperCase( EdEstado.Text ) ) then
      begin
        MessageDlg( 'J� existe um Estado com esse nome!!', MtInformation, [ MbOK ], 0 );
        EdEstado.SetFocus;
        Exit;
      end;
  end;

  Result := True;
end;

end.
