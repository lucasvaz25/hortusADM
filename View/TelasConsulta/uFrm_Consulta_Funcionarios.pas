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
  Vcl.Buttons;

type
  TFrm_Consulta_Funcionario = class( TFrm_Consulta )
  private
    { Private declarations }
  public
    { Public declarations }
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
  UFrm_Cad_Funcionario;
{$R *.dfm}

{ TFrm_Consulta_Funcionario }

procedure TFrm_Consulta_Funcionario.Alterar;
begin
  inherited;

end;

procedure TFrm_Consulta_Funcionario.Consultar;
begin
  inherited;

end;

procedure TFrm_Consulta_Funcionario.Excluir;
begin
  inherited;

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
begin

end;

end.