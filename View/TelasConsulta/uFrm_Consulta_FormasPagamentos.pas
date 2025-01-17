unit uFrm_Consulta_FormasPagamentos;

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
  UFormasPagamentosController,
  Datasnap.DBClient;

type
  TFrm_Consulta_FormasPagamentos = class( TFrm_Consulta )
    DsFormaPgto: TDataSource;
    TDset_FormaPgto: TClientDataSet;
    TDset_FormaPgtocodigo: TIntegerField;
    TDset_FormaPgtoformapgto: TStringField;
    TDset_FormaPgtodatacad: TDateField;
    TDset_FormaPgtousercad: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    FormaPgtoControl: TFormasPagamentosController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_FormasPagamentos: TFrm_Consulta_FormasPagamentos;

implementation

uses
  System.Contnrs,
  UFormasPagamentos,
  UFilterSearch,
  UFrm_Cad_FormasPagamentos;
{$R *.dfm}

{ TFrm_Consulta_FormasPagamentos }

procedure TFrm_Consulta_FormasPagamentos.Alterar;
var
  Frm: TFrm_Cad_FormasPagamentos;
  Aux: TFormasPagamentos;
begin
  inherited;

  if TDset_FormaPgto.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TFormasPagamentos.Create;
  try
    if FormaPgtoControl.Recuperar( TDset_FormaPgtocodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_FormasPagamentos.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.FormaPgtoControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_FormasPagamentos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_FormaPgto.EmptyDataSet;

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

    Lista := FormaPgtoControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_FormaPgto.Append;
        TDset_FormaPgtocodigo.Value       := TFormasPagamentos( Lista.Items[ I ] ).Codigo;
        TDset_FormaPgtoformapgto.AsString := TFormasPagamentos( Lista.Items[ I ] ).FormaPagamento;
        TDset_FormaPgtodatacad.AsDateTime := TFormasPagamentos( Lista.Items[ I ] ).DataCad;
        TDset_FormaPgtousercad.AsString   := TFormasPagamentos( Lista.Items[ I ] ).UserCad;
        TDset_FormaPgto.Post;
      end;
    end;
    TDset_FormaPgto.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_FormasPagamentos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_FormasPagamentos.Excluir;
begin
  inherited;
  if TDset_FormaPgto.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_FormaPgtocodigo.AsInteger ) + ' - '
              + TDset_FormaPgtoformapgto.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if FormaPgtoControl.Deletar( TDset_FormaPgtocodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_FormasPagamentos.FormCreate( Sender: TObject );
begin
  inherited;
  FormaPgtoControl := nil;
  FormaPgtoControl.GetInstance( FormaPgtoControl, Self );

  TDset_FormaPgto.AfterScroll := nil;
  if ( not TDset_FormaPgto.IsEmpty ) then
    TDset_FormaPgto.EmptyDataSet;
  TDset_FormaPgto.Active := False;
  TDset_FormaPgto.DisableControls;
  TDset_FormaPgto.CreateDataSet;

  TDset_FormaPgto.Open;
end;

procedure TFrm_Consulta_FormasPagamentos.FormDestroy( Sender: TObject );
begin
  FormaPgtoControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_FormasPagamentos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_FormasPagamentos.Novo;
var
  Frm: TFrm_Cad_FormasPagamentos;
begin
  inherited;

  Frm := TFrm_Cad_FormasPagamentos.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_FormasPagamentos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_FormasPagamentos.SelecionaRegistro;
var
  Aux: TFormasPagamentos;
begin
  Aux := TFormasPagamentos.Create;
  try
    FormaPgtoControl.Recuperar( TDset_FormaPgtocodigo.Value, TObject( Aux ) );
    FormaPgtoControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
