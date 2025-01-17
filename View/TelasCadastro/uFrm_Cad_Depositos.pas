unit uFrm_Cad_Depositos;

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
  UDepositosController,
  UCidadesController,
  Vcl.Mask,
  VazMaskEdit;

type
  TFrm_Cad_Depositos = class( TFrm_Cadastro )
    EdDeposito: TVazEdit;
    LblDeposito: TLabel;
    LblEndereco: TLabel;
    EdEndereco: TVazEdit;
    LblNum: TLabel;
    EdNum: TVazEdit;
    EdBairro: TVazEdit;
    LblBairro: TLabel;
    EdCidade: TVazEdit;
    EdUF: TVazEdit;
    LblCidade: TLabel;
    LblUF: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    EdObs: TMemo;
    LblObs: TLabel;
    EdCEP: TVazMaskEdit;
    LblCEP: TLabel;
    EdCodCidade: TVazEdit;
    LblCodDept: TLabel;
    procedure FormCreate( Sender: TObject );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure EdCodCidadeExit( Sender: TObject );
    procedure EdCodCidadeKeyPress( Sender: TObject; var Key: Char );
  private
    { Private declarations }
    CidadeControl: TCidadesController;
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultaCidade;
    procedure PesquisaCidade;
  public
    { Public declarations }
    DepositoControl: TDepositosController;
    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Depositos: TFrm_Cad_Depositos;

implementation

uses
  UFilterSearch,
  UFrm_Consulta_Cidades,
  System.Contnrs,
  Ucidades,
  UDepositos;
{$R *.dfm}

{ TFrm_Cad_Depositos }

procedure TFrm_Cad_Depositos.ConsultaCidade;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCidade.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodCidade.Text );
      List                := CidadeControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCidade.Text    := TCidade( List[ 0 ] ).Cidade;
        EdCodCidade.Text := TCidade( List[ 0 ] ).Codigo.ToString;
        EdUF.Text        := TCidade( List[ 0 ] ).Estado.UF;
        DepositoControl.GetEntity.Cidade.CopiarDados( TCidade( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Cidade n�o encontrada!!' );
        EdCodCidade.Clear;
        EdCidade.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Depositos.EdCodCidadeExit( Sender: TObject );
begin
  inherited;
  Self.ConsultaCidade;
end;

procedure TFrm_Cad_Depositos.EdCodCidadeKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultaCidade;
end;

procedure TFrm_Cad_Depositos.FormCreate( Sender: TObject );
begin
  inherited;
  DepositoControl := nil;
  DepositoControl.GetInstance( DepositoControl, Self );

  CidadeControl := nil;
  CidadeControl.GetInstance( CidadeControl, Self );
end;

procedure TFrm_Cad_Depositos.ImgPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaCidade;
end;

procedure TFrm_Cad_Depositos.PesquisaCidade;
var
  Frm: TFrm_Consulta_Cidades;
begin
  inherited;
  Frm := TFrm_Consulta_Cidades.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdCidade.Text    := Frm.CidadeControl.GetEntity.Cidade;
    EdCodCidade.Text := IntToStr( Frm.CidadeControl.GetEntity.Codigo );
    DepositoControl.GetEntity.Cidade.CopiarDados( Frm.CidadeControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Depositos.PopulaForm;
begin
  inherited;
  with DepositoControl.GetEntity do
  begin
    EdCodigo.Text    := IntToStr( Codigo );
    EdDeposito.Text  := Deposito;
    EdEndereco.Text  := Logradouro;
    EdNum.Text       := Numero;
    EdBairro.Text    := Bairro;
    EdCEP.Text       := CEP;
    EdCodCidade.Text := Cidade.Codigo.ToString;
    EdCidade.Text    := Cidade.Cidade;
    EdUF.Text        := Cidade.Estado.UF;
    EdObs.Text       := Obs;
  end;
end;

procedure TFrm_Cad_Depositos.PopulaObj;
begin
  with DepositoControl.GetEntity do
  begin
    Codigo        := StrToInt( EdCodigo.Text );
    Deposito      := EdDeposito.Text;
    Logradouro    := EdEndereco.Text;
    Numero        := EdNum.Text;
    Bairro        := EdBairro.Text;
    CEP           := EdCEP.Text;
    Cidade.Cidade := EdCidade.Text;
    DataCad       := Date;
    UserCad       := UpperCase( 'lucas' );
    Obs           := EdObs.Text;
  end;
end;

procedure TFrm_Cad_Depositos.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Depositos.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := DepositoControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := DepositoControl.Inserir( Aux )
    else
      Salvou := DepositoControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end;
end;

function TFrm_Cad_Depositos.ValidaForm: Boolean;
begin
  Result := False;

  if Length( EdDeposito.Text ) < 3 then
  begin
    MessageDlg( 'Insira um Dep�sito v�lido!!', MtInformation, [ MbOK ], 0 );
    EdDeposito.SetFocus;
    Exit;
  end;

  if ( EdCodCidade.Text = '' ) or ( EdCidade.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma Cidade v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCidade.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if DepositoControl.VerificaExiste( UpperCase( EdDeposito.Text ) ) then
    begin
      MessageDlg( 'J� existe um Dep�sito com esse nome!!', MtInformation, [ MbOK ], 0 );
      EdDeposito.SetFocus;
      Exit;
    end;

  Result := True;
end;

end.
