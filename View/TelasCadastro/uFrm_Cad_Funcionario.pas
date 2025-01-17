unit uFrm_Cad_Funcionario;

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
  Vcl.Mask,
  VazMaskEdit,
  Vcl.ComCtrls,
  Vcl.Imaging.Pngimage,
  Vcl.DBCtrls,
  UCargosController,
  UCidadesController,
  UFuncionariosController;

type
  TFrm_Cad_Funcionario = class( TFrm_Cadastro )
    LblNome: TLabel;
    EdNome: TVazEdit;
    LblNomeFantasia: TLabel;
    EdApelido: TVazEdit;
    EdCEP: TVazMaskEdit;
    LblCEP: TLabel;
    RgSexo: TRadioGroup;
    EdNum: TVazEdit;
    LblNum: TLabel;
    EdLogradouro: TVazEdit;
    LblLogradouro: TLabel;
    EdBairro: TVazEdit;
    LblBairro: TLabel;
    EdCidade: TVazEdit;
    LblCidade: TLabel;
    EdUF: TVazEdit;
    LblUF: TLabel;
    EdTelefone: TVazMaskEdit;
    LblTelefone: TLabel;
    LblEmail: TLabel;
    EdEmail: TVazEdit;
    EdCPF: TVazMaskEdit;
    LblCPF: TLabel;
    EdRG: TVazEdit;
    LblRG: TLabel;
    LblDtAdmissao: TLabel;
    LblDtDemissao: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    EdNumCNH: TVazEdit;
    LblCNH: TLabel;
    LblCategoria: TLabel;
    LblValCNH: TLabel;
    LblCargo: TLabel;
    EdSalario: TVazEdit;
    LblSalario: TLabel;
    LblCodCidade: TLabel;
    EdCodCidade: TVazEdit;
    LblCodCargao: TLabel;
    EdCodCargo: TVazEdit;
    EdCargo: TVazEdit;
    PnlPesquisaCargo: TPanel;
    ImgCargo: TImage;
    EdDtDemissao: TVazMaskEdit;
    EdDtAdmissao: TVazMaskEdit;
    EdValCNH: TVazMaskEdit;
    EdCategoria: TComboBox;
    procedure FormCreate( Sender: TObject );
    procedure EdCodCidadeExit( Sender: TObject );
    procedure EdCodCidadeKeyPress( Sender: TObject; var Key: Char );
    procedure EdCodCargoExit( Sender: TObject );
    procedure EdCodCargoKeyPress( Sender: TObject; var Key: Char );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure ImgCargoClick( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure EdSalarioExit( Sender: TObject );
    procedure EdDtAdmissaoExit( Sender: TObject );
  private
    { Private declarations }
    CidadeControl: TCidadesController;
    CargoControl: TCargosController;
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultarCargo;
    procedure PesquisaBtnCargo;
    procedure ConsultarCidade;
    procedure PesquisaBtnCidade;
    procedure VerificaObrigatorioCNH;
    procedure UnlockFields;
    procedure BlockFields;

  public
    { Public declarations }
    FuncionarioControl: TFuncionariosController;
    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Funcionario: TFrm_Cad_Funcionario;

implementation

uses
  System.Contnrs,
  UEnum,
  UFilterSearch,
  UCargos,
  UCidades,
  UFuncionarios,
  UFrm_Consulta_Cidades,
  UFrm_Consulta_Cargos;
{$R *.dfm}

{ TFrm_Cad_Funcionario }

procedure TFrm_Cad_Funcionario.ConsultarCargo;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCargo.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.Codigo       := StrToInt( EdCodCargo.Text );
      List                := CargoControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCargo.Text := TCargos( List[ 0 ] ).Cargo;
        FuncionarioControl.GetEntity.Cargo.CopiarDados( TCargos( List[ 0 ] ) );
        Self.VerificaObrigatorioCNH;
      end
      else
      begin
        ShowMessage( 'Cargo n�o encontrado!!' );
        EdCodCargo.Clear;
        EdCargo.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Funcionario.ConsultarCidade;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCidade.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.RecuperarObj := True;
      Filtro.Codigo       := StrToInt( EdCodCidade.Text );
      List                := CidadeControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCidade.Text := TCidade( List[ 0 ] ).Cidade;
        EdUF.Text     := TCidade( List[ 0 ] ).Estado.UF;
        FuncionarioControl.GetEntity.Cidade.CopiarDados( TCidade( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Cidade n�o encontrado!!' );
        EdCodCidade.Clear;
        EdCidade.SetFocus;
        EdUF.Clear;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Funcionario.EdCodCargoExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarCargo;
end;

procedure TFrm_Cad_Funcionario.EdCodCargoKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarCargo;
end;

procedure TFrm_Cad_Funcionario.EdCodCidadeExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarCidade;
end;

procedure TFrm_Cad_Funcionario.EdCodCidadeKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarCidade;
end;

procedure TFrm_Cad_Funcionario.EdDtAdmissaoExit( Sender: TObject );
begin
  inherited;
  Self.IsDataAtual( Sender );
end;

procedure TFrm_Cad_Funcionario.EdSalarioExit( Sender: TObject );
begin
  inherited;
  Self.FormatCurrency( Sender );
end;

procedure TFrm_Cad_Funcionario.FormCreate( Sender: TObject );
begin
  inherited;
  FuncionarioControl := nil;
  FuncionarioControl.GetInstance( FuncionarioControl, Self );

  CargoControl := nil;
  CargoControl.GetInstance( CargoControl, Self );

  CidadeControl := nil;
  CidadeControl.GetInstance( CidadeControl, Self );
end;

procedure TFrm_Cad_Funcionario.FormShow( Sender: TObject );
begin
  inherited;
  if not( EdCodigo.Text = '0' ) then
    BlockFields
  else
    UnlockFields;
end;

procedure TFrm_Cad_Funcionario.ImgCargoClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaBtnCargo;
end;

procedure TFrm_Cad_Funcionario.ImgPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaBtnCidade;
end;

procedure TFrm_Cad_Funcionario.PesquisaBtnCargo;
var
  Frm: TFrm_Consulta_Cargos;
begin
  inherited;
  Frm := TFrm_Consulta_Cargos.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdCargo.Text    := Frm.CargoControl.GetEntity.Cargo;
    EdCodCargo.Text := IntToStr( Frm.CargoControl.GetEntity.Codigo );
    FuncionarioControl.GetEntity.Cargo.CopiarDados( Frm.CargoControl.GetEntity );
    Self.VerificaObrigatorioCNH;
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Funcionario.PesquisaBtnCidade;
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
    FuncionarioControl.GetEntity.Cidade.CopiarDados( Frm.CidadeControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Funcionario.PopulaForm;
begin
  with FuncionarioControl.GetEntity do
  begin
    EdCodigo.Text         := IntToStr( Codigo );
    EdNome.Text           := Nome;
    EdRG.Text             := RG;
    EdBairro.Text         := Bairro;
    EdCPF.Text            := CPF;
    EdCEP.Text            := CEP;
    EdNum.Text            := Numero;
    RgSexo.ItemIndex      := Integer( Sexo );
    EdApelido.Text        := Apelido;
    EdLogradouro.Text     := Endereco;
    EdTelefone.Text       := Telefone;
    EdEmail.Text          := Email;
    EdSalario.Text        := FormatCurr( 'R$ 0.00#', Salario );
    EdNumCNH.Text         := CNH;
    EdCategoria.ItemIndex := Ord( Categoria );
    EdCidade.Text         := Cidade.Cidade;
    EdCodCidade.Text      := IntToStr( Cidade.Codigo );
    EdUF.Text             := Cidade.Estado.UF;
    EdCargo.Text          := Cargo.Cargo;
    EdCodCargo.Text       := IntToStr( Cargo.Codigo );
    EdDtAdmissao.EditText := DateToStr( Data_Admissao );
    EdDtDemissao.EditText := DateToStr( Data_Demissao );
    EdValCNH.EditText     := DateToStr( ValidadeCNH );
  end;
end;

procedure TFrm_Cad_Funcionario.PopulaObj;
begin
  with FuncionarioControl.GetEntity do
  begin
    Codigo    := StrToInt( EdCodigo.Text );
    Nome      := UpperCase( EdNome.Text );
    RG        := EdRG.Text;
    Bairro    := UpperCase( EdBairro.Text );
    CPF       := EdCPF.Text;
    CEP       := EdCEP.Text;
    Numero    := EdNum.Text;
    Sexo      := TSexo( RgSexo.ItemIndex );
    Apelido   := UpperCase( EdApelido.Text );
    Endereco  := UpperCase( EdLogradouro.Text );
    Telefone  := EdTelefone.Text;
    Email     := EdEmail.Text;
    Salario   := StrToCurr( StringReplace( EdSalario.Text, 'R$', '', [ RfReplaceAll, RfIgnoreCase ] ) );
    CNH       := EdNumCNH.Text;
    Categoria := TCategoriaCNH( EdCategoria.ItemIndex );
    DataCad   := Date;
    UserCad   := UpperCase( 'lucas' );

    Data_Admissao := Self.GetDefaultDate
                ( EdDtAdmissao.EditText, 'Data Admiss�o' );

    Data_Demissao := Self.GetDefaultDate
                ( EdDtDemissao.EditText, 'Data Demiss�o' );

    ValidadeCNH := Self.GetDefaultDate
                ( EdValCNH.EditText, 'Val. CNH' );
  end;
end;

procedure TFrm_Cad_Funcionario.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Funcionario.UnlockFields;
begin
  EdNome.Enabled := True;
  RgSexo.Enabled := True;
  EdCPF.Enabled  := True;
  EdRg.Enabled   := True;
end;

procedure TFrm_Cad_Funcionario.BlockFields;
begin
  EdNome.Enabled := False;
  RgSexo.Enabled := False;
  EdCPF.Enabled  := False;
  EdRg.Enabled   := False;
end;

procedure TFrm_Cad_Funcionario.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := FuncionarioControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := FuncionarioControl.Inserir( Aux )
    else
      Salvou := FuncionarioControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end
end;

function TFrm_Cad_Funcionario.ValidaForm: Boolean;
var
  DtDemissao, DtAdmissao, DtCNH: TDateTime;
begin
  Result := False;

  if Length( EdNome.Text ) < 3 then
  begin
    MessageDlg( 'Informe um nome de Funcion�rio v�lido!!', MtInformation, [ MbOK ], 0 );
    EdNome.SetFocus;
    Exit;
  end;

  if not Self.ValidarCPF( EdCPF.Text ) then
  begin
    MessageDlg( 'Informe um CPF v�lido!!', MtInformation, [ MbOK ], 0 );
    EdCPF.SetFocus;
    Exit;
  end;

  if ( EdCodCidade.Text = '' ) or ( EdCidade.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma Cidade v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCidade.SetFocus;
    Exit;
  end;

  if ( EdCargo.Text = '' ) or ( EdCodCargo.Text = '' ) then
  begin
    MessageDlg( 'Insira um Cargo v�lido!!', MtInformation, [ MbOK ], 0 );
    EdCargo.SetFocus;
    Exit;
  end;

  if ( RgSexo.ItemIndex < 0 ) then
  begin
    MessageDlg( 'Informe o sexo do funcion�rio!!', MtInformation, [ MbOK ], 0 );
    RgSexo.SetFocus;
    Exit;
  end;

  DtAdmissao := Self.GetDefaultDate
              ( EdDtAdmissao.EditText, 'Data Admiss�o' );
  if DtAdmissao = 0 then
  begin
    MessageDlg( 'Informe uma data de admiss�o v�lida!!', MtInformation, [ MbOK ], 0 );
    EdDtAdmissao.Clear;
    EdDtAdmissao.SetFocus;
    Exit;
  end;

  DtDemissao := Self.GetDefaultDate
              ( EdDtDemissao.EditText, 'Data Demiss�o' );
  if ( DtDemissao > 0 ) then
  begin
    DtAdmissao := Self.GetDefaultDate
                ( EdDtAdmissao.EditText, 'Data Admiss�o' );
    if ( DtAdmissao > DtDemissao ) then
    begin
      MessageDlg( 'Data de demiss�o n�o pode ser anterior a data de admiss�o!!', MtInformation, [ MbOK ], 0 );
      EdDtDemissao.SetFocus;
      Exit;
    end;
  end;

  if FuncionarioControl.GetEntity.Cargo.IsObrigatorioCNH then
  begin
    if EdNumCNH.Text = '' then
    begin
      MessageDlg( 'Insira um N�mero de CNH v�lido!!', MtInformation, [ MbOK ], 0 );
      EdNumCNH.SetFocus;
      Exit;
    end;
    if EdCategoria.Text = '' then
    begin
      MessageDlg( 'Insira uma categoria de CNH v�lida!!', MtInformation, [ MbOK ], 0 );
      EdCategoria.SetFocus;
      Exit;
    end;
    DtCNH := Self.GetDefaultDate
                ( EdValCNH.EditText, 'Val. CNH' );

    if DtCNH = 0 then
    begin
      MessageDlg( 'Informe uma Data de Validade da CNH v�lida!!', MtInformation, [ MbOK ], 0 );
      EdValCNH.Clear;
      EdValCNH.SetFocus;
      Exit;
    end;

    if DtCNH < Date then
    begin
      MessageDlg( 'Insira uma Data de Validade da CNH vencida!!', MtInformation, [ MbOK ], 0 );
      EdValCNH.SetFocus;
      Exit;
    end;
  end;

  if ( EdSalario.Text = '' ) then
  begin
    MessageDlg( 'Informe o Sal�rio do funcion�rio!!', MtInformation, [ MbOK ], 0 );
    EdSalario.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if FuncionarioControl.VerificaExisteCPF( UpperCase( EdCPF.Text ) ) then
    begin
      MessageDlg( 'J� existe um Funcion�rio com esse CPF!!', MtInformation, [ MbOK ], 0 );
      EdNome.SetFocus;
      Exit;
    end;

  Result := True;
end;

procedure TFrm_Cad_Funcionario.VerificaObrigatorioCNH;
begin
  if FuncionarioControl.GetEntity.Cargo.IsObrigatorioCNH then
  begin
    LblCNH.Caption       := 'CNH*';
    LblCategoria.Caption := 'Categoria*';
    LblValCNH.Caption    := 'Val. CNH*';
  end
  else
  begin
    LblCNH.Caption       := 'CNH';
    LblCategoria.Caption := 'Categoria';
    LblValCNH.Caption    := 'Val. CNH';
  end;
end;

end.
