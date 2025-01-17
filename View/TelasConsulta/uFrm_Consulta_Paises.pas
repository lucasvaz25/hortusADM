unit uFrm_Consulta_Paises;

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
  Datasnap.DBClient,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,
  VazEdit,
  Vcl.Imaging.Pngimage,
  UPaises,
  UPaisesController,
  UFilterSearch,
  Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TFrm_ConsultaPaises = class( TFrm_Consulta )
    TDset_Paises: TClientDataSet;
    DsPaises: TDataSource;
    TDset_Paisescodigo: TIntegerField;
    TDset_Paisesnome: TStringField;
    TDset_Paisessigla: TStringField;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure DBGrid1DblClick( Sender: TObject );
  private
    { Private declarations }
  public
    { Public declarations }
    PaisControl: TPaisesController;
    procedure Novo; override;
    procedure Alterar; override;
    procedure Excluir; override;
    procedure Sair; override;
    procedure Consultar; override;

    procedure SelecionaRegistro;
  end;

var
  Frm_ConsultaPaises: TFrm_ConsultaPaises;

implementation

uses
  UFrm_Cad_Paises;

{$R *.dfm}


procedure TFrm_ConsultaPaises.Alterar;
var
  Frm: TFrm_Cad_Paises;
  Aux: TPais;
begin
  inherited;

  if TDset_Paises.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;

  Aux := TPais.Create;
  try
    if PaisControl.Recuperar( TDset_Paisescodigo.Value, TObject( Aux ) ) then
    begin
      Frm := TFrm_Cad_Paises.Create( Self );
      try
        Frm.EdCodigo.Text := IntToStr( Aux.Codigo );
        Frm.Paiscontrol.GetEntity.CopiarDados( Aux );
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

procedure TFrm_ConsultaPaises.Consultar;
var
  ListaPais: TObjectlist;
  I: Integer;
  VFilter: TFilterSearch;
begin
  TDset_Paises.EmptyDataSet;

  VFilter   := TFilterSearch.Create;
  ListaPais := TObjectList.Create;
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

    ListaPais := PaisControl.Consulta( VFilter );
    if ListaPais <> nil then
    begin
      for I := 0 to ListaPais.Count - 1 do
      begin
        TDset_Paises.Append;
        TDset_Paisescodigo.Value   := TPais( ListaPais.Items[ I ] ).Codigo;
        TDset_Paisesnome.AsString  := TPais( ListaPais.Items[ I ] ).Nome;
        TDset_Paisessigla.AsString := TPais( ListaPais.Items[ I ] ).Sigla;
        TDset_Paises.Post;
      end;
    end;
    TDset_Paises.EnableControls;
  finally
    VFilter.Free;
    ListaPais.Free;
  end;
end;

procedure TFrm_ConsultaPaises.DBGrid1DblClick( Sender: TObject );
begin
  inherited;
  if IsSelecionar then
    Self.SelecionaRegistro;
end;

procedure TFrm_ConsultaPaises.Excluir;
begin
  inherited;
  if TDset_Paises.IsEmpty then
  begin
    MessageDlg( 'Nenhum registro selecionado!!', MtInformation, [ MbOK ], 0 );
    Exit;
  end;
  if MessageDlg( 'Tem certeza que deseja Excluir o registro: ' +
              IntToStr( TDset_Paisescodigo.AsInteger ) + ' - '
              + TDset_Paisesnome.AsString + '?', MtInformation, [ MbNo, MbYes ], 0 ) = MrYes then
  begin
    if PaisControl.Deletar( TDset_Paisescodigo.AsInteger ) then
      Self.Consultar;
  end;
end;

procedure TFrm_ConsultaPaises.FormCreate( Sender: TObject );
begin
  inherited;
  PaisControl := nil;
  PaisControl.GetInstance( PaisControl, Self );

  TDset_Paises.AfterScroll := nil;
  if ( not TDset_Paises.IsEmpty ) then
    TDset_Paises.EmptyDataSet;
  TDset_Paises.Active := False;
  TDset_Paises.DisableControls;
  TDset_Paises.CreateDataSet;

  TDset_Paises.Open;
end;

procedure TFrm_ConsultaPaises.FormDestroy( Sender: TObject );
begin
  PaisControl.Free;
  inherited;
end;

procedure TFrm_ConsultaPaises.FormShow( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_ConsultaPaises.Novo;
var
  Frm: TFrm_Cad_Paises;
begin
  inherited;

  Frm := TFrm_Cad_Paises.Create( Self );
  try
    Frm.EdCodigo.Text := IntToStr( 0 );
    Frm.ShowModal;
    if Frm.Salvou then
      Self.Consultar;
  finally
    Frm.Free;
  end;

end;

procedure TFrm_ConsultaPaises.Sair;
begin
  inherited;

end;

procedure TFrm_ConsultaPaises.SelecionaRegistro;
var
  Aux: TPais;
begin
  Aux := TPais.Create;
  try
    PaisControl.Recuperar( TDset_Paisescodigo.Value, TObject( Aux ) );
    PaisControl.GetEntity.CopiarDados( Aux );
    Self.Close;
  finally
    Aux.Free;
  end;
end;

end.
