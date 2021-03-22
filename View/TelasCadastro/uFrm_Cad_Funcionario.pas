unit uFrm_Cad_Funcionario;

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
  Vcl.Buttons,
  Vcl.StdCtrls,
  VazEdit,
  Vcl.ExtCtrls,
  Vcl.Mask,
  VazMaskEdit,
  Vcl.ComCtrls,
  Vcl.Imaging.Pngimage,
  Vcl.DBCtrls;

type
  TFrm_Cad_Funcionario = class( TFrm_Cadastro )
    LblNome: TLabel;
    EdNome: TVazEdit;
    LblNomeFantasia: TLabel;
    EdNomeFantasia: TVazEdit;
    EdCEP: TVazMaskEdit;
    LblCEP: TLabel;
    RgSexo: TRadioGroup;
    EdNum: TVazEdit;
    LblNum: TLabel;
    EdLogradouro: TVazEdit;
    LblLogradouro: TLabel;
    EdBairro: TVazEdit;
    LblBairro: TLabel;
    EdCidade: TVazEdit;
    LblCidade: TLabel;
    EdUF: TVazEdit;
    LblUF: TLabel;
    EdTelefone: TVazMaskEdit;
    LblTelefone: TLabel;
    LblEmail: TLabel;
    EdEmail: TVazEdit;
    EdCPF: TVazMaskEdit;
    LblCPF: TLabel;
    EdRG: TVazEdit;
    LblRG: TLabel;
    EdDtAdmissao: TDateTimePicker;
    LblDtAdmissao: TLabel;
    EdDtDemissao: TDateTimePicker;
    LblDtDemissao: TLabel;
    PnlPesquisar: TPanel;
    ImgPesquisar: TImage;
    EdNumCNH: TVazEdit;
    LblCNH: TLabel;
    EdCategoria: TVazEdit;
    LblCategoria: TLabel;
    EdValCNH: TDateTimePicker;
    LblValCNH: TLabel;
    LkpCargo: TDBLookupComboBox;
    LblCargo: TLabel;
    Pnlbotoes: TPanel;
    PnlNovoCad: TPanel;
    ImgNovoCad: TImage;
    BtnNovoCad: TSpeedButton;
    PnlAlterarCad: TPanel;
    ImgAlterarCad: TImage;
    BtnAlterarCad: TSpeedButton;
    edSalario: TVazEdit;
    lblSalario: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Cad_Funcionario: TFrm_Cad_Funcionario;

implementation

{$R *.dfm}


end.
