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

  UChamadasInterfaces,
  Vcl.Buttons,
  Vcl.Imaging.Jpeg,
  System.ImageList,
  Vcl.ImgList,
  Vcl.CategoryButtons,
  Vcl.Imaging.Pngimage;

type
  TFRM_Principal = class( TForm )
    SplitView1: TSplitView;
    ImageList1: TImageList;
    PnlTop: TPanel;
    Image1: TImage;
    PnlMenu: TPanel;
    BtnMenu: TSpeedButton;
    CategoryButtons1: TCategoryButtons;
    CategoryButtons2: TCategoryButtons;
    Panel1: TPanel;
    CtbLocais: TCategoryButtons;
    CtbEstoque: TCategoryButtons;
    CtbAdmin: TCategoryButtons;
    CtbFinan: TCategoryButtons;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure BtnFecharClick( Sender: TObject );

    procedure Paises1Click( Sender: TObject );
    procedure Estados1Click( Sender: TObject );
    procedure Cidades1Click( Sender: TObject );
    procedure Grupos1Click( Sender: TObject );
    procedure SubGrupos1Click( Sender: TObject );
    procedure BtnMenuClick( Sender: TObject );
    procedure SplitView1Opened( Sender: TObject );
    procedure SplitView1Closed( Sender: TObject );
    procedure CategoryButtons2Categories0Items0Click( Sender: TObject );
    procedure Departamentos1Click( Sender: TObject );
    procedure CategoryButtons1Categories0Items0Click( Sender: TObject );
    procedure Unidades1Click( Sender: TObject );
    procedure Depositos1Click( Sender: TObject );
    procedure Cargos1Click( Sender: TObject );
    procedure Clientes1Click( Sender: TObject );
    procedure Fornecedores1Click( Sender: TObject );
    procedure Funcionarios1Click( Sender: TObject );
    procedure Produtos1Click( Sender: TObject );
    procedure OrdemdeProduo1Click( Sender: TObject );
    procedure CondiodePagamento1Click( Sender: TObject );
    procedure FormasdePagamentos1Click( Sender: TObject );
    procedure SplitView1MouseMove( Sender: TObject; Shift: TShiftState; X,
                Y: Integer );
    procedure CategoryButtons1Categories0Items4Click( Sender: TObject );
    procedure CtbLocaisMouseLeave( Sender: TObject );
    procedure CategoryButtons3Categories0Items0Click( Sender: TObject );
    procedure CategoryButtons3Categories0Items1Click( Sender: TObject );
    procedure CategoryButtons3Categories0Items2Click( Sender: TObject );
    procedure CtbEstoqueCategories0Items3Click( Sender: TObject );
    procedure CtbEstoqueCategories0Items2Click( Sender: TObject );
    procedure CtbEstoqueCategories0Items1Click( Sender: TObject );
    procedure CtbEstoqueCategories0Items0Click( Sender: TObject );
    procedure CategoryButtons1Categories0Items2Click( Sender: TObject );
    procedure CtbEstoqueMouseLeave( Sender: TObject );
    procedure CtbEstoqueCategories0Items4Click( Sender: TObject );
    procedure CtbEstoqueCategories0Items5Click( Sender: TObject );
    procedure CtbAdminCategories0Items0Click( Sender: TObject );
    procedure CtbAdminCategories0Items1Click( Sender: TObject );
    procedure CtbAdminCategories0Items2Click( Sender: TObject );
    procedure CtbAdminCategories0Items3Click( Sender: TObject );
    procedure CtbAdminCategories0Items4Click( Sender: TObject );
    procedure CtbAdminMouseLeave( Sender: TObject );
    procedure CtbAdminCategories0Items5Click( Sender: TObject );
    procedure CtbFinanCategories0Items0Click( Sender: TObject );
    procedure CtbFinanCategories0Items1Click( Sender: TObject );
    procedure CtbFinanMouseLeave( Sender: TObject );
    procedure CtbAdminSelectedItemChange( Sender: TObject;
                const Button: TButtonItem );

  private
    { Private declarations }
    ChamadaInter: TchamadasInterfaces;
    Rect: TRect;
    procedure ChamaSubmenu( Menu, SubMenu: TCategoryButtons; Rect: TRect );
  public
    { Public declarations }
  end;

var
  FRM_Principal: TFRM_Principal;

implementation

uses
  UFrm_Cad_Ordem_Producao;
{$R *.dfm}


procedure TFRM_Principal.BtnFecharClick( Sender: TObject );
begin
  Close;
end;

procedure TFRM_Principal.BtnMenuClick( Sender: TObject );
begin
  SplitView1.Opened := not SplitView1.Opened;
end;

procedure TFRM_Principal.Cargos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaCargos;
end;

procedure TFRM_Principal.CategoryButtons1Categories0Items0Click(
            Sender: TObject );
begin
  ChamaSubmenu( CategoryButtons1, CtbAdmin, Rect );
end;

procedure TFRM_Principal.CategoryButtons1Categories0Items2Click(
            Sender: TObject );
begin
  Self.ChamaSubmenu( CategoryButtons1, CtbEstoque, Rect );
end;

procedure TFRM_Principal.CategoryButtons1Categories0Items4Click(
            Sender: TObject );
begin
  Self.ChamaSubmenu( CategoryButtons1, CtbLocais, Rect );
end;

procedure TFRM_Principal.CategoryButtons2Categories0Items0Click(
            Sender: TObject );
begin
  Self.Close;
end;

procedure TFRM_Principal.CategoryButtons3Categories0Items0Click(
            Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaPaises;
end;

procedure TFRM_Principal.CategoryButtons3Categories0Items1Click(
            Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaEstados;
end;

procedure TFRM_Principal.CategoryButtons3Categories0Items2Click(
            Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaCidades;
end;

procedure TFRM_Principal.CtbLocaisMouseLeave( Sender: TObject );
begin
  CtbLocais.Visible := False;
end;

procedure TFRM_Principal.Cidades1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaCidades;
end;

procedure TFRM_Principal.Clientes1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaClientes;
end;

procedure TFRM_Principal.CondiodePagamento1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaCondPagamento;
end;

procedure TFRM_Principal.CtbAdminCategories0Items0Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaClientes;
end;

procedure TFRM_Principal.CtbAdminCategories0Items1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaFornecedores;
end;

procedure TFRM_Principal.CtbAdminCategories0Items2Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaFuncionarios;
end;

procedure TFRM_Principal.CtbAdminCategories0Items3Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaCargos;
end;

procedure TFRM_Principal.CtbAdminCategories0Items4Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaDepartamentos;
end;

procedure TFRM_Principal.CtbAdminCategories0Items5Click( Sender: TObject );
begin
  CtbAdmin.Tag := 0;
  CtbFinan.Tag := 3;
  ChamaSubmenu( CtbAdmin, CtbFinan, Rect );
end;

procedure TFRM_Principal.CtbAdminMouseLeave( Sender: TObject );
begin
  if not CtbFinan.Visible then
    CtbAdmin.Visible := False;
end;

procedure TFRM_Principal.CtbAdminSelectedItemChange( Sender: TObject;
            const Button: TButtonItem );
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do // se selecionar outro btn do menu pai o submenu � escondido
  begin
    if TCategoryButtons( Components[ I ] ).Tag = 2 then
      TCategoryButtons( Components[ I ] ).Visible := False;
  end;
end;

procedure TFRM_Principal.CtbEstoqueCategories0Items0Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaDepositos;
end;

procedure TFRM_Principal.CtbEstoqueCategories0Items1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaOrdemProducao;
end;

procedure TFRM_Principal.CtbEstoqueCategories0Items2Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaProdutos;
end;

procedure TFRM_Principal.CtbEstoqueCategories0Items3Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaUnidades;
end;

procedure TFRM_Principal.CtbEstoqueCategories0Items4Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaGrupos;
end;

procedure TFRM_Principal.CtbEstoqueCategories0Items5Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaSubGrupos;
end;

procedure TFRM_Principal.CtbEstoqueMouseLeave( Sender: TObject );
begin
  CtbEstoque.Visible := False;
end;

procedure TFRM_Principal.CtbFinanCategories0Items0Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaFormaPgto;
end;

procedure TFRM_Principal.CtbFinanCategories0Items1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaCondPagamento;
end;

procedure TFRM_Principal.CtbFinanMouseLeave( Sender: TObject );
begin
  CtbFinan.Visible := False;
end;

procedure TFRM_Principal.Departamentos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaDepartamentos;
end;

procedure TFRM_Principal.Depositos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaDepositos;
end;

procedure TFRM_Principal.Estados1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaEstados;
end;

procedure TFRM_Principal.FormasdePagamentos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaFormaPgto;
end;

procedure TFRM_Principal.FormCreate( Sender: TObject );
begin
  CtbLocais.Visible  := False;
  CtbEstoque.Visible := False;
  CtbAdmin.Visible   := False;
  CtbFinan.Visible   := False;

  ChamadaInter := TchamadasInterfaces.Create( Self );
end;

procedure TFRM_Principal.FormDestroy( Sender: TObject );
begin
  ChamadaInter.Free;
end;

procedure TFRM_Principal.Fornecedores1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaFornecedores;
end;

procedure TFRM_Principal.Funcionarios1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaFuncionarios;
end;

procedure TFRM_Principal.Grupos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaGrupos;
end;

procedure TFRM_Principal.OrdemdeProduo1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaOrdemProducao;
end;

procedure TFRM_Principal.Paises1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaPaises;
end;

procedure TFRM_Principal.Produtos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaProdutos;
end;

procedure TFRM_Principal.SplitView1Closed( Sender: TObject );
begin
  CategoryButtons1.ShowHint := not SplitView1.Opened;
end;

procedure TFRM_Principal.SplitView1MouseMove( Sender: TObject;
            Shift: TShiftState; X, Y: Integer );
begin
  CtbLocais.Visible := False;
end;

procedure TFRM_Principal.SplitView1Opened( Sender: TObject );
begin
  CategoryButtons1.ShowHint := not SplitView1.Opened;
end;

procedure TFRM_Principal.SubGrupos1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaSubGrupos;
end;

procedure TFRM_Principal.Unidades1Click( Sender: TObject );
begin
  ChamadaInter.ChamadaConsultaUnidades;
end;

procedure TFRM_Principal.ChamaSubmenu( Menu, SubMenu: TCategoryButtons; Rect: TRect );
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if ( Components[ I ] is TCategoryButtons ) then
    begin
      if ( TCategoryButtons( Components[ I ] ).Tag = 1 ) or
                  ( TCategoryButtons( Components[ I ] ).Tag = 2 ) then
      begin
        TCategoryButtons( Components[ I ] ).Visible := False;
        TCategoryButtons( Components[ I ] ).Tag     := 0;
      end;
    end;
  end;

  Rect := Menu.Categories.CategoryButtons.GetButtonRect( Menu.Categories.CategoryButtons.SelectedItem );

  if SubMenu.Tag = 3 then // tag 3 � submenu de submenu
  begin
    SubMenu.Left := Menu.Categories[ 0 ].Items[ 0 ].CategoryButtons.Width;
    SubMenu.Top  := Rect.Top + Menu.Top;
    SubMenu.Tag  := 2; // seta tag 2 para pode esconder somente quando outro btn for selecionado
    Menu.Tag     := 1;
  end
  else
  begin
    SubMenu.Left := Menu.Categories[ 0 ].Items[ 0 ].CategoryButtons.Width - Menu.Categories[ 0 ].Items[ 0 ].CategoryButtons.Width;
    SubMenu.Top  := Rect.Top;
    SubMenu.Tag  := 1;
  end;

  SubMenu.Visible := True;

  SubMenu.Show;
end;

end.
