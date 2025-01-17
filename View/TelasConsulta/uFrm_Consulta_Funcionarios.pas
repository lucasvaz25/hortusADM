unit uFrm_Consulta_Funcionarios;

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
  UFrm_Consulta,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VazEdit,
  Vcl.Imaging.Pngimage,
  Vcl.Buttons,
  Datasnap.DBClient,
  UFuncionariosController;

type
  TFrm_Consulta_Funcionario = class( TFrm_Consulta )
    DsFuncionarios: TDataSource;
    TDset_Funcionarios: TClientDataSet;
    TDset_Funcionarioscodigo: TIntegerField;
    TDset_Funcionariosfuncionario: TStringField;
    TDset_Funcionarioscpf: TStringField;
    TDset_Funcionarioscargo: TStringField;
    procedure DBGrid1DblClick( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    FuncionarioControl: TFuncionariosController;

    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Funcionario: TFrm_Consulta_Funcionario;

implementation

uses
  UFuncionarios,
  UFilterSearch,
  System.Contnrs,
  UFrm_Cad_Funcionario;
{$R *.dfm}

{ TFrm_Consulta_Funcionario }

procedure TFrm_Consulta_Funcionario.Alterar;
var
  Frm: TFrm_Cad_Funcionario;
  Aux: TFuncionarios;
begin
  inherited;

  if TDset_Funcionarios.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TFuncionarios.Create;
  try
    if FuncionarioControl.Recuperar( TDset_Funcionarioscodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Funcionario.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.FuncionarioControl.GetEntity.CopiarDados( Aux );
        Frm.ShowModal;
        if Frm.Salvou then
          Self.Consultar;
      finally
        Frm.Free;
      end;
    end;
  finally
    Aux.Free;
  end;
end;

procedure TFrm_Consulta_Funcionario.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Funcionarios.EmptyDataSet;

  VFilter := TFilterSearch.Create;
  Lista   := TObjectList.Create;
  try
    case RgFiltro.ItemIndex of
      0:
        begin
          if EdPesquisar.Text = '' then
          begin
            MessageDlg( 'Informe um c�digo v�lido!!', MtInformation, [ MbOK ], 0 );
            EdPesquisar.SetFocus;
            Exit;
          end;

          VFilter.TipoConsulta := TpCCodigo;
          VFilter.Codigo       := StrToInt( EdPesquisar.Text );
        end;
      1:
        begin
          if Length( EdPesquisar.Text ) < 3 then
          begin
            MessageDlg( 'Digite ao menos 3 caracteres para consulta!!', MtInformation, [ MbOK ], 0 );
            EdPesquisar.SetFocus;
            Exit;
          end;
          VFilter.TipoConsulta := TpCParam;
          VFilter.Parametro    := Uppercase( EdPesquisar.Text );
        end;
      2:
        begin
          VFilter.TipoConsulta := TpCTODOS;
        end;
    end;

    Lista := FuncionarioControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Funcionarios.Append;
        TDset_Funcionarioscodigo.Value         := TFuncionarios( Lista.Items[ I ] ).Codigo;
        TDset_Funcionarioscargo.AsString       := TFuncionarios( Lista.Items[ I ] ).Cargo.Cargo;
        TDset_FuncionariosCPF.AsString         := TFuncionarios( Lista.Items[ I ] ).CPF;
        TDset_Funcionariosfuncionario.AsString := TFuncionarios( Lista.Items[ I ] ).Nome;
        TDset_Funcionarios.Post;
      end;
    end;
    TDset_Funcionarios.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Funcionario.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Funcionario.Excluir;
begin
  inherited;
  if TDset_Funcionarios.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Funcionarioscodigo.AsInteger ) + ' - '
              + TDset_Funcionariosfuncionario.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if FuncionarioControl.Deletar( TDset_Funcionarioscodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Funcionario.FormCreate( Sender: TObject );
begin
  inherited;
  FuncionarioControl := nil;
  FuncionarioControl.GetInstance( FuncionarioControl, Self );

  TDset_Funcionarios.AfterScroll := nil;
  if ( not TDset_Funcionarios.IsEmpty ) then
    TDset_Funcionarios.EmptyDataSet;
  TDset_Funcionarios.Active := False;
  TDset_Funcionarios.DisableControls;
  TDset_Funcionarios.CreateDataSet;

  TDset_Funcionarios.Open;
end;

procedure TFrm_Consulta_Funcionario.FormDestroy( Sender: TObject );
begin
  FuncionarioControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Funcionario.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Funcionario.Novo;
var
  Frm: TFrm_Cad_Funcionario;
begin
  inherited;

  Frm := TFrm_Cad_Funcionario.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Funcionario.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Funcionario.SelecionaRegistro;
var
  Aux: TFuncionarios;
begin
  Aux := TFuncionarios.Create;
  try
    FuncionarioControl.Recuperar( TDset_Funcionarioscodigo.Value, TObject( Aux ) );
    FuncionarioControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
