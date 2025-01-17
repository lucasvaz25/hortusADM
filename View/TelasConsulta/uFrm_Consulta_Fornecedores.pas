unit uFrm_Consulta_Fornecedores;

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
  UFornecedoresController;

type
  TFrm_Consulta_Fornecedores = class( TFrm_Consulta )
    TDsetFornecedor: TClientDataSet;
    DsFornecedor: TDataSource;
    TDsetFornecedorfornecedor: TStringField;
    TDsetFornecedorcnpj: TStringField;
    TDsetFornecedorcidade: TStringField;
    TDsetFornecedorcodigo: TIntegerField;
    TDsetFornecedortelefone: TStringField;
    procedure DBGrid1DblClick( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    FornecedorControl: TFornecedoresController;

    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Fornecedores: TFrm_Consulta_Fornecedores;

implementation

uses
  UFornecedores,
  UFilterSearch,
  System.Contnrs,
  UFrm_Cad_Fornecedor;
{$R *.dfm}

{ TFrm_Consulta1 }

procedure TFrm_Consulta_Fornecedores.Alterar;
var
  Frm: TFrm_Cad_Fornecedor;
  Aux: TFornecedores;
begin
  inherited;

  if TDsetFornecedor.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TFornecedores.Create;
  try
    if FornecedorControl.Recuperar
                ( TDsetFornecedorcodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Fornecedor.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.FornecedorControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Fornecedores.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDsetFornecedor.EmptyDataSet;

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

    Lista := FornecedorControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDsetFornecedor.Append;
        TDsetFornecedorcodigo.Value        := TFornecedores( Lista.Items[ I ] ).Codigo;
        TDsetFornecedorfornecedor.AsString := TFornecedores( Lista.Items[ I ] ).Nome;
        TDsetFornecedorcnpj.AsString       := TFornecedores( Lista.Items[ I ] ).CPF;
        TDsetFornecedortelefone.AsString   := TFornecedores( Lista.Items[ I ] ).Telefone;
        TDsetFornecedorcidade.AsString     := TFornecedores( Lista.Items[ I ] ).Cidade.GetCidadeUF;
        TDsetFornecedor.Post;
      end;
    end;
    TDsetFornecedor.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Fornecedores.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Fornecedores.Excluir;
begin
  inherited;
  if TDsetFornecedor.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDsetFornecedorcodigo.AsInteger ) + ' - '
              + TDsetFornecedorfornecedor.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if FornecedorControl.Deletar( TDsetFornecedorcodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Fornecedores.FormCreate( Sender: TObject );
begin
  inherited;
  FornecedorControl := nil;
  FornecedorControl.GetInstance( FornecedorControl, Self );

  TDsetFornecedor.AfterScroll := nil;
  if ( not TDsetFornecedor.IsEmpty ) then
    TDsetFornecedor.EmptyDataSet;
  TDsetFornecedor.Active := False;
  TDsetFornecedor.DisableControls;
  TDsetFornecedor.CreateDataSet;

  TDsetFornecedor.Open;
end;

procedure TFrm_Consulta_Fornecedores.FormDestroy( Sender: TObject );
begin
  FornecedorControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Fornecedores.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Fornecedores.Novo;
var
  Frm: TFrm_Cad_Fornecedor;
begin
  inherited;

  Frm := TFrm_Cad_Fornecedor.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Fornecedores.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Fornecedores.SelecionaRegistro;
var
  Aux: TFornecedores;
begin
  Aux := TFornecedores.Create;
  try
    FornecedorControl.Recuperar( TDsetFornecedorcodigo.Value, TObject( Aux ) );
    FornecedorControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
