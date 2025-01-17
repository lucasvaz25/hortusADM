unit uFrm_Consulta_Depositos;

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
  UDepositosController,
  Datasnap.DBClient;

type
  TFrm_Consulta_Depositos = class( TFrm_Consulta )
    TDset_Depositos: TClientDataSet;
    TDset_Depositoscodigo: TIntegerField;
    DsDepositos: TDataSource;
    TDset_Depositosdeposito: TStringField;
    TDset_Depositoscidade: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    DepositoControl: TDepositosController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Depositos: TFrm_Consulta_Depositos;

implementation

uses
  System.Contnrs,
  UDepositos,
  UFilterSearch,
  UFrm_Cad_Depositos;
{$R *.dfm}

{ TFrm_Consulta_Depositos }

procedure TFrm_Consulta_Depositos.Alterar;
var
  Frm: TFrm_Cad_Depositos;
  Aux: TDepositos;
begin
  inherited;

  if TDset_Depositos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TDepositos.Create;
  try
    if DepositoControl.Recuperar( TDset_Depositoscodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Depositos.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.DepositoControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Depositos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Depositos.EmptyDataSet;

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

    Lista := DepositoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Depositos.Append;
        TDset_Depositoscodigo.Value      := TDepositos( Lista.Items[ I ] ).Codigo;
        TDset_Depositosdeposito.AsString := TDepositos( Lista.Items[ I ] ).Deposito;
        TDset_Depositoscidade.AsString   := TDepositos( Lista.Items[ I ] ).Cidade.GetCidadeUF;
        TDset_Depositos.Post;
      end;
    end;
    TDset_Depositos.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Depositos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Depositos.Excluir;
begin
  inherited;
  if TDset_Depositos.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Depositoscodigo.AsInteger ) + ' - '
              + TDset_Depositosdeposito.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if DepositoControl.Deletar( TDset_Depositoscodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Depositos.FormCreate( Sender: TObject );
begin
  inherited;
  DepositoControl := nil;
  DepositoControl.GetInstance( DepositoControl, Self );

  TDset_Depositos.AfterScroll := nil;
  if ( not TDset_Depositos.IsEmpty ) then
    TDset_Depositos.EmptyDataSet;
  TDset_Depositos.Active := False;
  TDset_Depositos.DisableControls;
  TDset_Depositos.CreateDataSet;

  TDset_Depositos.Open;
end;

procedure TFrm_Consulta_Depositos.FormDestroy( Sender: TObject );
begin
  DepositoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Depositos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Depositos.Novo;
var
  Frm: TFrm_Cad_Depositos;
begin
  inherited;

  Frm := TFrm_Cad_Depositos.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Depositos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Depositos.SelecionaRegistro;
var
  Aux: TDepositos;
begin
  Aux := TDepositos.Create;
  try
    DepositoControl.Recuperar( TDset_Depositoscodigo.Value, TObject( Aux ) );
    DepositoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
