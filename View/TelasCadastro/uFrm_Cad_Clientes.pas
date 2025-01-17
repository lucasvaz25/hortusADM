unit uFrm_Cad_Clientes;

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

  UClientesController,
  UCondicaoPagamentoController,
  UCidadesController;

type
  TFrm_Cad_Clientes = class( TFrm_Cadastro )
    LblNome: TLabel;
    EdNome: TVazEdit;
    RgTpPessoa: TRadioGroup;
    EdNomeFantasia: TVazEdit;
    LblNomeFantasia: TLabel;
    LblCPF: TLabel;
    EdCPF: TVazMaskEdit;
    LblDtNasc: TLabel;
    RgSexo: TRadioGroup;
    EdCEP: TVazMaskEdit;
    LblCEP: TLabel;
    EdLogradouro: TVazEdit;
    LblLogradouro: TLabel;
    EdNum: TVazEdit;
    LblNum: TLabel;
    LblBairro: TLabel;
    EdBairro: TVazEdit;
    LblCidade: TLabel;
    EdCidade: TVazEdit;
    EdUF: TVazEdit;
    LblUF: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    EdTelefone: TVazMaskEdit;
    LblTelefone: TLabel;
    EdEmail: TVazEdit;
    LblEmail: TLabel;
    EdRG: TVazEdit;
    LblRG: TLabel;
    LblCondPag: TLabel;
    EdCodCidade: TVazEdit;
    LblCodCidade: TLabel;
    EdCodCondPag: TVazEdit;
    LblCodCondPag: TLabel;
    EdCondPag: TVazEdit;
    PnlPesquisaCondPag: TPanel;
    ImgPesquisaCondPag: TImage;
    EdDtNasc: TVazMaskEdit;
    procedure RgTpPessoaClick( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure ImgPesquisarClick( Sender: TObject );
    procedure EdCodCidadeExit( Sender: TObject );
    procedure EdCodCidadeKeyPress( Sender: TObject; var Key: Char );
    procedure EdCodCondPagExit( Sender: TObject );
    procedure EdCodCondPagKeyPress( Sender: TObject; var Key: Char );
    procedure ImgPesquisaCondPagClick( Sender: TObject );
    procedure FormShow( Sender: TObject );
  private
    { Private declarations }
    CondPagControl: TCondicaoPagamentoController;
    CidadeControl: TCidadesController;
    procedure FormatInterface;
    procedure PopulaObj;
    procedure PopulaForm; override;
    function ValidaForm: Boolean;
    procedure ConsultarCondPag;
    procedure PesquisaBtnCondPag;
    procedure ConsultarCidade;
    procedure PesquisaBtnCidade;
    function GetTpDoc: string;

    procedure BlockFields;
    procedure UnlockFields;
  public
    { Public declarations }
    ClienteControl: TClientesController;

    procedure Salvar; override;
    procedure Sair; override;
  end;

var
  Frm_Cad_Clientes: TFrm_Cad_Clientes;

implementation

uses
  System.Contnrs,
  UFilterSearch,
  UCondicaoPagamento,
  UCidades,
  UClientes,
  UEnum,
  UFrm_Consulta_CondicaoPagamento,
  UFrm_Consulta_Cidades;

{$R *.dfm}


procedure TFrm_Cad_Clientes.BlockFields;
begin
  EdNome.Enabled         := False;
  EdNomeFantasia.Enabled := False;
  RgTpPessoa.Enabled     := False;
  RgSexo.Enabled         := False;
  EdCPF.Enabled          := False;
  EdRG.Enabled           := False;
end;

procedure TFrm_Cad_Clientes.ConsultarCidade;
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
        ClienteControl.GetEntity.Cidade.CopiarDados( TCidade( List[ 0 ] ) );

        if RgTpPessoa.ItemIndex = 0 then
          if ClienteControl.GetEntity.Cidade.Estado.Pais.Nome = 'BRASIL' then
            LblRG.Caption := 'RG*'
          else
            LblRG.Caption := 'RG';
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

procedure TFrm_Cad_Clientes.ConsultarCondPag;
var
  Filtro: TFilterSearch;
  List: TObjectlist;
begin
  if EdCodCondPag.Text <> '' then
  begin
    Filtro := TFilterSearch.Create;
    try
      Filtro.TipoConsulta := TpCCodigo;
      Filtro.RecuperarObj := True;
      Filtro.Codigo       := StrToInt( EdCodCondPag.Text );
      List                := CondPagControl.Consulta( Filtro );
      if List.Count > 0 then
      begin
        EdCondPag.Text := TCondicaoPagamento( List[ 0 ] ).CondPag;
        ClienteControl.GetEntity.CondPagamento.CopiarDados( TCondicaoPagamento( List[ 0 ] ) );
      end
      else
      begin
        ShowMessage( 'Condi��o de Pagamento n�o encontrada!!' );
        EdCodCondPag.Clear;
        EdCondPag.SetFocus;
      end;
    finally
      Filtro.Free;
    end;
  end;
end;

procedure TFrm_Cad_Clientes.EdCodCidadeExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarCidade;
end;

procedure TFrm_Cad_Clientes.EdCodCidadeKeyPress( Sender: TObject; var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarCidade;
end;

procedure TFrm_Cad_Clientes.EdCodCondPagExit( Sender: TObject );
begin
  inherited;
  Self.ConsultarCondPag;
end;

procedure TFrm_Cad_Clientes.EdCodCondPagKeyPress( Sender: TObject;
            var Key: Char );
begin
  inherited;
  if Key = #13 then
    Self.ConsultarCondPag;
end;

procedure TFrm_Cad_Clientes.FormatInterface;
begin
  case RgTpPessoa.ItemIndex of
    0:
      begin
        LblNome.Caption         := 'Cliente*';
        EdNome.TextHint         := 'Digite o nome do cliente';
        LblNomeFantasia.Caption := 'Apelido';
        EdNomeFantasia.TextHint := 'Digite o apelido do cliente';
        LblCPF.Enabled          := True;
        EdCPF.Enabled           := True;
        LblCPF.Caption          := 'CPF*';
        EdCPF.TypeMask          := TtmCPF;
        LblRG.Caption           := 'RG*';
        LblDtNasc.Caption       := 'Data Nascimento';
        RgSexo.Visible          := True;
        RgSexo.Caption          := 'Sexo*';
      end;
    1:
      begin
        LblNome.Caption         := 'Raz�o Social*';
        EdNome.TextHint         := 'Digite a Raz�o Social da empresa';
        LblNomeFantasia.Caption := 'Nome Fantasia';
        EdNomeFantasia.TextHint := 'Digite o nome fantasia da empresa';
        LblCPF.Enabled          := True;
        EdCPF.Enabled           := True;
        LblCPF.Caption          := 'CNPJ*';
        EdCPF.TypeMask          := TtmCNPJ;
        LblRG.Caption           := 'IE';
        LblDtNasc.Caption       := 'Data Funda��o';
        RgSexo.Visible          := False;
      end;
  end;
end;

procedure TFrm_Cad_Clientes.FormCreate( Sender: TObject );
begin
  inherited;
  ClienteControl := nil;
  ClienteControl.GetInstance( ClienteControl, Self );

  CondPagControl := nil;
  CondPagControl.GetInstance( CondPagControl, Self );

  CidadeControl := nil;
  CidadeControl.GetInstance( CidadeControl, Self );
end;

procedure TFrm_Cad_Clientes.FormShow( Sender: TObject );
begin
  inherited;
  if not( EdCodigo.Text = '0' ) then
    BlockFields
  else
    UnlockFields;
end;

procedure TFrm_Cad_Clientes.PesquisaBtnCidade;
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
    ClienteControl.GetEntity.Cidade.CopiarDados( Frm.CidadeControl.GetEntity );

    if RgTpPessoa.ItemIndex = 0 then
      if ClienteControl.GetEntity.Cidade.Estado.Pais.Nome = 'BRASIL' then
        LblRG.Caption := 'RG*'
      else
        LblRG.Caption := 'RG';

  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Clientes.PesquisaBtnCondPag;
var
  Frm: TFrm_Consulta_CondicaoPagamento;
begin
  inherited;
  Frm := TFrm_Consulta_CondicaoPagamento.Create( Self );
  try
    Frm.IsSelecionar := True;
    Frm.ShowModal;
    EdCondPag.Text    := Frm.CondPagControl.GetEntity.CondPag;
    EdCodCondPag.Text := IntToStr( Frm.CondPagControl.GetEntity.Codigo );
    ClienteControl.GetEntity.CondPagamento.CopiarDados
                ( Frm.CondPagControl.GetEntity );
  finally
    Frm.Release;
  end;
end;

procedure TFrm_Cad_Clientes.PopulaForm;
begin
  with ClienteControl.GetEntity do
  begin
    EdCodigo.Text        := IntToStr( Codigo );
    EdNome.Text          := Nome;
    EdRG.Text            := RG;
    EdBairro.Text        := Bairro;
    EdCPF.Text           := CPF;
    EdCEP.Text           := CEP;
    EdNum.Text           := Numero;
    EdNomeFantasia.Text  := Apelido;
    EdLogradouro.Text    := Endereco;
    EdTelefone.Text      := Telefone;
    EdEmail.Text         := Email;
    EdCidade.Text        := Cidade.Cidade;
    EdCodCidade.Text     := IntToStr( Cidade.Codigo );
    EdUF.Text            := Cidade.Estado.UF;
    EdCondPag.Text       := CondPagamento.CondPag;
    EdCodCondPag.Text    := IntToStr( CondPagamento.Codigo );
    RgTpPessoa.ItemIndex := Integer( TpPessoa );
    EdDtNasc.EditText    := DateToStr( DataNasc );
    RgSexo.ItemIndex     := Integer( Sexo );
  end;
end;

procedure TFrm_Cad_Clientes.PopulaObj;
begin
  with ClienteControl.GetEntity do
  begin
    Codigo   := StrToInt( EdCodigo.Text );
    DataCad  := Now;
    DataAlt  := Now;
    UserCad  := 'LUCAS';
    UserAlt  := 'LUCAS';
    Nome     := EdNome.Text;
    Apelido  := EdNomeFantasia.Text;
    CEP      := EdCEP.Text;
    Endereco := EdLogradouro.Text;
    Numero   := EdNum.Text;
    Bairro   := EdBairro.Text;
    // Cidade.Codigo;
    Telefone             := EdTelefone.Text;
    Email                := EdEmail.Text;
    CPF                  := EdCPF.Text;
    RG                   := EdRG.Text;
    Sexo                 := TSexo( RgSexo.ItemIndex );
    DataNasc             := Self.GetDefaultDate( EdDtNasc.EditText, 'Data Nascimento' );
    TpPessoa             := TTipoPessoa( RgTpPessoa.ItemIndex );
    CondPagamento.Codigo := StrToInt( EdCodCondPag.Text );
  end;
end;

procedure TFrm_Cad_Clientes.RgTpPessoaClick( Sender: TObject );
begin
  inherited;
  Self.FormatInterface;
end;

procedure TFrm_Cad_Clientes.Sair;
begin
  inherited;

end;

procedure TFrm_Cad_Clientes.Salvar;
var
  Aux: TObject;
begin
  inherited;
  if ValidaForm then
  begin

    PopulaObj;
    Aux := ClienteControl.GetEntity;
    if EdCodigo.Text = '0' then
      Salvou := ClienteControl.Inserir( Aux )
    else
      Salvou := ClienteControl.Editar( Aux );

    if Salvou then
      Self.Sair;
  end
end;

procedure TFrm_Cad_Clientes.UnlockFields;
begin
  EdNome.Enabled         := True;
  EdNomeFantasia.Enabled := True;
  RgTpPessoa.Enabled     := True;
  RgSexo.Enabled         := True;
  EdCPF.Enabled          := True;
  EdRG.Enabled           := True;
end;

function TFrm_Cad_Clientes.ValidaForm: Boolean;
var
  DtNascimento: TDateTime;
begin
  Result := False;

  if Length( EdNome.Text ) < 3 then
  begin
    MessageDlg( 'Informe um nome de Cliente v�lido!!', MtInformation, [ MbOK ], 0 );
    EdNome.SetFocus;
    Exit;
  end;

  if ( EdCodCidade.Text = '' ) or ( EdCidade.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma Cidade v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCidade.SetFocus;
    Exit;
  end;

  if RgTpPessoa.ItemIndex = 0 then
  begin
    if not Self.ValidarCPF( EdCPF.Text ) then
    begin
      MessageDlg( 'Informe um CPF v�lido!!', MtInformation, [ MbOK ], 0 );
      EdCPF.SetFocus;
      Exit;
    end;

    if ( RgSexo.ItemIndex < 0 ) then
    begin
      MessageDlg( 'Informe o sexo do Cliente!!', MtInformation, [ MbOK ], 0 );
      RgSexo.SetFocus;
      Exit;
    end;

    if ( Pos( '*', LblRG.Caption ) > 0 ) then
    begin
      if EdRG.Text = '' then
      begin
        MessageDlg( 'Informe um RG v�lido!!', MtInformation, [ MbOK ], 0 );
        EdRG.SetFocus;
        Exit;
      end;
    end;
  end
  else
  begin
    // validacaoCNPJ
  end;

  DtNascimento := Self.GetDefaultDate
              ( EdDtNasc.EditText, 'Data Nascimento' );

  if ( EdCodCondPag.Text = '' ) or ( EdCondPag.Text = '' ) then
  begin
    MessageDlg( 'Selecione uma condi��o de pagamento v�lida!!', MtInformation, [ MbOK ], 0 );
    EdCodCondPag.SetFocus;
    Exit;
  end;

  if EdCodigo.Text = '0' then
    if ClienteControl.VerificaExisteCPF_CNPJ( UpperCase( EdCPF.Text ) ) then
    begin
      MessageDlg( 'J� existe um Cliente com esse '
                  + GetTpDoc + '!!', MtInformation, [ MbOK ], 0 );
      EdNome.SetFocus;
      Exit;
    end;

  Result := True;
end;

function TFrm_Cad_Clientes.GetTpDoc: string;
begin
  if ( Length( EdCPF.Text ) = 11 ) then
    Result := 'CPF'
  else if ( Length( EdCPF.Text ) = 14 ) then
    Result := 'CNPJ'
  else
    Result := '';
end;

procedure TFrm_Cad_Clientes.ImgPesquisaCondPagClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaBtnCondPag;
end;

procedure TFrm_Cad_Clientes.ImgPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.PesquisaBtnCidade;
end;

end.
