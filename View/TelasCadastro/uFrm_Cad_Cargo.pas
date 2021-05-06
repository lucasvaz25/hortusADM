unit uFrm_Cad_Cargo;

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
  Vcl.Imaging.Pngimage,
  Vcl.ExtCtrls,
  Vcl.DBCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  VazEdit,
  UCargosController;

type
  TFrm_Cad_Cargo = class( TFrm_Cadastro )
    LblCargo: TLabel;
    EdCargo: TVazEdit;
    LkpDepartamento: TDBLookupComboBox;
    LblDepartamento: TLabel;
    Pnlbotoes: TPanel;
    PnlNovoCad: TPanel;
    ImgNovoCad: TImage;
    BtnNovoCad: TSpeedButton;
    PnlAlterarCad: TPanel;
    ImgAlterarCad: TImage;
    BtnAlterarCad: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
    CargoControl: TCargosController;
  end;

var
  Frm_Cad_Cargo: TFrm_Cad_Cargo;

implementation

uses
  UCargos;
{$R *.dfm}

end.
