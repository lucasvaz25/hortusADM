unit uFRM_Principal;

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
  Vcl.ExtCtrls,
  Vcl.WinXPanels,
  Vcl.WinXCtrls,
  Vcl.OleCtrls,
  SHDocVw,
  Soap.InvokeRegistry,
  System.Net.URLClient,
  Soap.Rio,
  Soap.SOAPHTTPClient,
  Vcl.WinXCalendars,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.ToolWin,
  Vcl.StdCtrls,
  System.Win.TaskbarCore,
  Vcl.Taskbar,
  UFrm_Cad_Paises,
  UFrm_Cad_Estados,
  UFrm_Cad_Cidades,
  UFrm_Cad_Fornecedor,
  UFrm_cad_Produtos,
  UFrm_Cad_Funcionario,
  UFrm_Cad_Clientes,
  UFrm_Cad_Cargo,
  UFrm_Cad_Grupo,
  UFrm_Cad_SubGrupo,
  UFrm_Cad_Departamento,
  UFrm_Consulta_Paises,
  UFrm_Consulta_Estados,
  UDM,
  UFrm_Venda;

type
  TFRM_Principal = class( TForm )
    StatusBar1: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure Button2Click( Sender: TObject );
  private
    { Private declarations }
    // DM: TDM;
  public
    { Public declarations }
  end;

var
  FRM_Principal: TFRM_Principal;

implementation

{$R *.dfm}


procedure TFRM_Principal.Button1Click( Sender: TObject );
var
  Cad: TFrm_ConsultaPaises;
begin
  Cad := TFrm_ConsultaPaises.Create( Self );
  // Cad.PaisControl.SetDM( DM );
  Cad.ShowModal;
end;

procedure TFRM_Principal.Button2Click( Sender: TObject );
var
  Cad: TFrm_Consulta_Estados;
begin
  Cad := TFrm_Consulta_Estados.Create( Self );
  Cad.ShowModal;
end;

procedure TFRM_Principal.FormCreate( Sender: TObject );
begin
  // DM := TDM.Create( Self );

end;

procedure TFRM_Principal.FormDestroy( Sender: TObject );
begin
  // if Assigned( DM ) then
  // FreeAndNil( DM );
end;

end.
