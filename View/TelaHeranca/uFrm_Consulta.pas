unit uFrm_Consulta;

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
  UFrm_Base,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  VazEdit,
  Vcl.Buttons,
  Vcl.WinXCtrls,
  Vcl.Imaging.Pngimage,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids;

type
  TFrm_Consulta = class( TFrm_Base )
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    PnlRodape: TPanel;
    PnlCabecalho: TPanel;
    EdPesquisar: TVazEdit;
    PnlGrid: TPanel;
    DBGrid1: TDBGrid;
    RgFiltro: TRadioGroup;
    LblConsulta: TLabel;
    PnlNovo: TPanel;
    BtnNovo: TSpeedButton;
    PnlAlterar: TPanel;
    BtnAlterar: TSpeedButton;
    PnlExcluir: TPanel;
    BtnExcluir: TSpeedButton;
    PnlSair: TPanel;
    BtnSair: TSpeedButton;
    BtnPesquisar: TSpeedButton;
    procedure DBGrid1DrawColumnCell( Sender: TObject; const Rect: TRect;
                DataCol: Integer; Column: TColumn; State: TGridDrawState );
    procedure RgFiltroClick( Sender: TObject );
    procedure BtnSairClick( Sender: TObject );
    procedure BtnNovoClick( Sender: TObject );
    procedure BtnAlterarClick( Sender: TObject );
    procedure BtnExcluirClick( Sender: TObject );
    procedure BtnPesquisarClick( Sender: TObject );
    procedure FormShow( Sender: TObject );
    procedure EdPesquisarKeyPress( Sender: TObject; var Key: Char );
    procedure FormCreate( Sender: TObject );
  private
    { Private declarations }
  protected
  public
    { Public declarations }
    IsSelecionar: Boolean;
    procedure Novo; virtual;
    procedure Alterar; virtual;
    procedure Excluir; virtual;
    procedure Sair; virtual;
    procedure Consultar; virtual;
    procedure ChangePesquisa;
  end;

var
  Frm_Consulta: TFrm_Consulta;

implementation

{$R *.dfm}


procedure TFrm_Consulta.Alterar;
begin

end;

procedure TFrm_Consulta.BtnAlterarClick( Sender: TObject );
begin
  inherited;
  Self.Alterar;
end;

procedure TFrm_Consulta.BtnExcluirClick( Sender: TObject );
begin
  inherited;
  Self.Excluir;
end;

procedure TFrm_Consulta.BtnNovoClick( Sender: TObject );
begin
  inherited;
  Self.Novo;
end;

procedure TFrm_Consulta.BtnPesquisarClick( Sender: TObject );
begin
  inherited;
  Self.Consultar;
end;

procedure TFrm_Consulta.BtnSairClick( Sender: TObject );
begin
  inherited;
  Self.Sair;
end;

procedure TFrm_Consulta.ChangePesquisa;
begin
  case RgFiltro.ItemIndex of
    0:
      begin
        EdPesquisar.NumbersOnly := True;
        LblConsulta.Caption     := 'Consultar por c�digo';
        EdPesquisar.TextHint    := 'digite a sua consulta';
        EdPesquisar.Enabled     := True;
        EdPesquisar.Clear;
      end;

    1:
      begin
        EdPesquisar.NumbersOnly := False;
        LblConsulta.Caption     := 'Consultar por descri��o';
        EdPesquisar.TextHint    := 'digite a sua consulta';
        EdPesquisar.Enabled     := True;
        EdPesquisar.Clear;
      end;

    2:
      begin
        LblConsulta.Caption  := 'Consultar todos';
        EdPesquisar.TextHint := 'Consultar todos';
        EdPesquisar.Enabled  := False;
        EdPesquisar.Clear;
        Self.Consultar;
      end;
  end;
end;

procedure TFrm_Consulta.Consultar;
begin

end;

procedure TFrm_Consulta.DBGrid1DrawColumnCell( Sender: TObject;
            const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState );
begin
  inherited;

  // zebrando
  if Odd( DBGrid1.DataSource.DataSet.RecNo ) then
    DBGrid1.Canvas.Brush.Color := $00E8E8E8
  else
    DBGrid1.Canvas.Brush.Color := ClWhite;

  // mudando cor sele��o
  if ( GdSelected in State ) then
  begin
    DBGrid1.Canvas.Brush.Color := $00CE7200;
    DBGrid1.Canvas.Font.Color  := ClWhite;
    DBGrid1.Canvas.Font.Style  := [ FsBold ];
  end;

  DBGrid1.Canvas.FillRect( Rect );
  DBGrid1.DefaultDrawColumnCell( Rect, DataCol, Column, State );

end;

procedure TFrm_Consulta.EdPesquisarKeyPress( Sender: TObject; var Key: Char );
begin
  inherited;
  if ( Key = #13 ) then
    Self.Consultar;
end;

procedure TFrm_Consulta.Excluir;
begin

end;

procedure TFrm_Consulta.FormCreate( Sender: TObject );
begin
  inherited;
  IsSelecionar := False;
end;

procedure TFrm_Consulta.FormShow( Sender: TObject );
begin
  inherited;
  RgFiltro.ItemIndex := 2; // todos;
  ChangePesquisa;
end;

procedure TFrm_Consulta.Novo;
begin

end;

procedure TFrm_Consulta.RgFiltroClick( Sender: TObject );
begin
  inherited;
  Self.ChangePesquisa;
end;

procedure TFrm_Consulta.Sair;
begin
  Close;
end;

end.
