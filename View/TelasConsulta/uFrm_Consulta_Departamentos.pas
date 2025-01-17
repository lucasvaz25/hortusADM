unit uFrm_Consulta_Departamentos;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Contnrs,
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
  UDepartamentos,
  UDepartamentosController;

type
  TFrm_Consulta_Departamentos = class( TFrm_Consulta )
    DsDept: TDataSource;
    TDset_Dept: TClientDataSet;
    TDset_Deptcodigo: TIntegerField;
    TDset_Deptdepartamento: TStringField;
    TDset_Deptdatacad: TDateTimeField;
    procedure FormCreate( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    DeptControl: TDepartamentosController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_Consulta_Departamentos: TFrm_Consulta_Departamentos;

implementation

uses
  UFilterSearch,
  UFrm_Cad_Departamento;
{$R *.dfm}

{ TFrm_Consulta_Departamentos }

procedure TFrm_Consulta_Departamentos.Alterar;
var
  Frm: TFrm_Cad_Departamento;
  Aux: TDepartamentos;
begin
  inherited;

  if TDset_Dept.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  Aux := TDepartamentos.Create;
  try
    if DeptControl.Recuperar( TDset_Deptcodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Departamento.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.DeptControl.GetEntity.CopiarDados( Aux );
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

procedure TFrm_Consulta_Departamentos.Consultar;
var
  Lista: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Dept.EmptyDataSet;

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

    Lista := DeptControl.Consulta( VFilter );
    if Lista <> nil then
    begin
      for I := 0 to Lista.Count - 1 do
      begin
        TDset_Dept.Append;
        TDset_Deptcodigo.Value          := TDepartamentos( Lista.Items[ I ] ).Codigo;
        TDset_Deptdepartamento.AsString := TDepartamentos( Lista.Items[ I ] ).Departamento;
        TDset_Deptdatacad.AsDateTime    := TDepartamentos( Lista.Items[ I ] ).DataCad;
        TDset_Dept.Post;
      end;
    end;
    TDset_Dept.EnableControls;
  finally
    VFilter.Free;
    Lista.Free;
  end;
end;

procedure TFrm_Consulta_Departamentos.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_Consulta_Departamentos.Excluir;
begin
  inherited;
  if TDset_Dept.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Deptcodigo.AsInteger ) + ' - '
              + TDset_Deptdepartamento.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if DeptControl.Deletar( TDset_Deptcodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_Consulta_Departamentos.FormCreate( Sender: TObject );
begin
  inherited;
  DeptControl := nil;
  DeptControl.GetInstance( DeptControl, Self );

  TDset_Dept.AfterScroll := nil;
  if ( not TDset_Dept.IsEmpty ) then
    TDset_Dept.EmptyDataSet;
  TDset_Dept.Active := False;
  TDset_Dept.DisableControls;
  TDset_Dept.CreateDataSet;

  TDset_Dept.Open;
end;

procedure TFrm_Consulta_Departamentos.FormDestroy( Sender: TObject );
begin
  DeptControl.Destroy;
  inherited;
end;

procedure TFrm_Consulta_Departamentos.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta_Departamentos.Novo;
var
  Frm: TFrm_Cad_Departamento;
begin
  inherited;

  Frm := TFrm_Cad_Departamento.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;
end;

procedure TFrm_Consulta_Departamentos.Sair;
begin
  inherited;

end;

procedure TFrm_Consulta_Departamentos.SelecionaRegistro;
var
  Aux: TDepartamentos;
begin
  Aux := TDepartamentos.Create;
  try
    DeptControl.Recuperar( TDset_Deptcodigo.Value, TObject( Aux ) );
    DeptControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
