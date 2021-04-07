unit uFrm_Cad_Fornecedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrm_Cadastro, Vcl.Buttons,
  Vcl.StdCtrls, VazEdit, Vcl.ExtCtrls, Vcl.Mask, VazMaskEdit,
  Vcl.Imaging.pngimage;

type
  TFrm_Cad_Fornecedor = class(TFrm_Cadastro)
    lblNome: TLabel;
    edNome: TVazEdit;
    lblNomeFantasia: TLabel;
    edNomeFantasia: TVazEdit;
    lblIE: TLabel;
    edIE: TVazEdit;
    edTelefone: TVazMaskEdit;
    lblTelefone: TLabel;
    lblEmail: TLabel;
    edEmail: TVazEdit;
    edCEP: TVazMaskEdit;
    edLogradouro: TVazEdit;
    lblLogradouro: TLabel;
    lblBairro: TLabel;
    edBairro: TVazEdit;
    edNum: TVazEdit;
    lblNum: TLabel;
    edCidade: TVazEdit;
    lblCidade: TLabel;
    edUF: TVazEdit;
    lblUF: TLabel;
    pnlPesquisar: TPanel;
    imgPesquisar: TImage;
    lblCEP: TLabel;
    edContato: TVazEdit;
    lblContato: TLabel;
    edSite: TVazEdit;
    lblsite: TLabel;
    edCNPJ: TVazMaskEdit;
    lblCNPJ: TLabel;
    rgTpPessoa: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Cad_Fornecedor: TFrm_Cad_Fornecedor;

implementation

{$R *.dfm}

end.