unit uFrm_Cad_Departamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrm_Cadastro, Vcl.Buttons,
  Vcl.StdCtrls, VazEdit, Vcl.ExtCtrls;

type
  TFrm_Cad_Departamento = class(TFrm_Cadastro)
    lblDepartamento: TLabel;
    edDepartamento: TVazEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Cad_Departamento: TFrm_Cad_Departamento;

implementation

{$R *.dfm}

end.
