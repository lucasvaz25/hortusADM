unit uFrm_Cadastro;

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
  Vcl.Buttons;

type
  TFrm_Cadastro = class( TFrm_Base )
    EdCodigo: TVazEdit;
    LblCodigo: TLabel;
    LblUsuarioDataCad: TLabel;
    LblUsuarioDataAlteracao: TLabel;
    BtnSalvar: TSpeedButton;
    PnlSalvar: TPanel;
    PnlSair: TPanel;
    BtnSair: TSpeedButton;
    procedure BtnSalvarMouseLeave( Sender: TObject );
    procedure BtnSalvarMouseMove( Sender: TObject; Shift: TShiftState; X,
                Y: Integer );
    procedure BtnSairClick( Sender: TObject );
    procedure BtnSalvarClick( Sender: TObject );
    procedure FormShow( Sender: TObject );
  protected
    procedure FormatCurrency( Sender: TObject );
    procedure FormatNumeroDecimais( Sender: TObject );
    procedure FormatDDD( Sender: TObject );
    procedure IsDataAtual( Sender: TObject );
    procedure UpperCaseField;
    procedure ClearFieldsDate;
    procedure PopulaForm; virtual;

    function ValidarCPF( const Value: string ): Boolean;
    function GetDefaultDate( const ADate, Field: string ): TDateTime;

  public
    { Public declarations }
    Salvou: Boolean;
    procedure LimparCampos;
    procedure Salvar; virtual;
    procedure Sair; virtual;
    procedure ConhecaObj( Obj: TObject; Objcontrol: TObject ); virtual;
  end;

var
  Frm_Cadastro: TFrm_Cadastro;

implementation

uses
  VazMaskEdit,
  Vcl.DBCtrls,
  Vcl.ComCtrls;

{$R *.dfm}


procedure TFrm_Cadastro.BtnSairClick( Sender: TObject );
begin
  inherited;
  Self.Sair;
end;

procedure TFrm_Cadastro.BtnSalvarClick( Sender: TObject );
begin
  inherited;
  Self.Salvar;
end;

procedure TFrm_Cadastro.BtnSalvarMouseLeave( Sender: TObject );
begin
  inherited;
  PnlSalvar.Color := $00FF8000;
end;

procedure TFrm_Cadastro.BtnSalvarMouseMove( Sender: TObject; Shift: TShiftState;
            X, Y: Integer );
begin
  inherited;
  PnlSalvar.Color := $00FFB164;
end;

procedure TFrm_Cadastro.ClearFieldsDate;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if ( Components[ I ] is TVazMaskEdit ) and
                ( TVazMaskEdit( Components[ I ] ).
                EditText = '30/12/1899' ) then
      TVazMaskEdit( Components[ I ] ).Clear;

end;

procedure TFrm_Cadastro.ConhecaObj( Obj, Objcontrol: TObject );
begin

end;

procedure TFrm_Cadastro.FormShow( Sender: TObject );
begin
  inherited;
  UppercaseField;
  if EdCodigo.Text = '0' then
    Self.LimparCampos
  else
  begin
    Self.PopulaForm;
    Self.ClearFieldsDate;
  end;
end;

function TFrm_Cadastro.GetDefaultDate( const ADate, Field: string ): TDateTime;
begin
  if not( ADate.Equals( '__/__/____' ) ) then
  begin
    if not( TryStrToDate( ADate, Result ) ) then
    begin
      MessageDlg( 'Data Inv�lida!' + #13#10 + 'Campo: ' +
                  Field + '.', MtError, [ MbOK ], 0 );
      Abort;
    end;
  end
  else
    Result := 0;
end;

procedure TFrm_Cadastro.IsDataAtual( Sender: TObject );
var
  ADate: TDateTime;
  DataStr: string;
begin
  if Sender.ClassType = TVazMaskEdit then
  begin
    DataStr := TVazMaskEdit( Sender ).EditText;

    if not( DataStr.Equals( '__/__/____' ) ) then
    begin
      if ( TryStrToDate( DataStr, ADate ) ) then
      begin
        if ( ADate > Now ) then
        begin
          MessageDlg( 'A data do campo n�o pode ser superior a data atual: ' + DateToStr( Date ) + ' !', MtInformation, [ MbOK ], 0 );
          TVazMaskEdit( Sender ).Clear;
          TVazMaskEdit( Sender ).SetFocus;
          Abort;
        end;
      end
      else
      begin
        MessageDlg( 'Data Inv�lida!', MtError, [ MbOK ], 0 );
        TVazMaskEdit( Sender ).Clear;
        TVazMaskEdit( Sender ).SetFocus;
        Abort;
      end;
    end;
  end;

end;

procedure TFrm_Cadastro.LimparCampos;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if ( Components[ I ] is TVazEdit ) then
    begin
      if not( Components[ I ].Name = 'edCodigo' ) then
        TVazEdit( Components[ I ] ).Clear
    end
    else if ( Components[ I ] is TVazMaskEdit ) then
      TVazMaskEdit( Components[ I ] ).Clear
    else if ( Components[ I ] is TEdit ) then
      TEdit( Components[ I ] ).Clear
    else if ( Components[ I ] is TMemo ) then
      TMemo( Components[ I ] ).Clear
    else if ( Components[ I ] is TDateTimePicker ) then
      TDateTimePicker( Components[ I ] ).Date := Date
    else if ( Components[ I ] is TDBLookupComboBox ) then
      TDBLookupComboBox( Components[ I ] ).KeyValue := Null;
  end;
end;

procedure TFrm_Cadastro.PopulaForm;
begin

end;

procedure TFrm_Cadastro.Sair;
begin
  Close;
end;

procedure TFrm_Cadastro.Salvar;
begin

end;

procedure TFrm_Cadastro.UppercaseField;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if ( Components[ I ] is TVazEdit ) then
      TVazEdit( Components[ I ] ).CharCase := EcUpperCase
    else if ( Components[ I ] is TVazMaskEdit ) then
      TVazMaskEdit( Components[ I ] ).CharCase := EcUpperCase
    else if ( Components[ I ] is TEdit ) then
      TEdit( Components[ I ] ).CharCase := EcUpperCase
    else if ( Components[ I ] is TMemo ) then
      TMemo( Components[ I ] ).CharCase := EcUpperCase;
  end;

end;

function TFrm_Cadastro.ValidarCPF( const Value: string ): Boolean;
var
  NumCPF: array [ 1 .. 11 ] of Integer;
  I, Resto, Soma: Integer;
begin

  if not( Value.Length = 11 ) then
  begin
    Result := False;
    Exit;
  end;

  for I         := Low( Value ) to High( Value ) do
    NumCPF[ I ] := StrToInt( Value[ I ] );

  /// ////   1� digito
  Soma   := 0;
  for I  := 1 to 9 do
    Soma := Soma + ( NumCPF[ I ] * ( 11 - I ) );

  Resto := ( Soma * 10 ) mod 11;

  if ( Resto = 10 ) or ( Resto = 11 ) then
    Resto := 0;

  if not( Resto = NumCPF[ 10 ] ) then
  begin
    Result := False;
    Exit;
  end;

  /// ////   2� digito
  Soma   := 0;
  for I  := 1 to 10 do
    Soma := Soma + ( NumCPF[ I ] * ( 12 - I ) );

  Resto := ( Soma * 10 ) mod 11;

  if ( Resto = 10 ) or ( Resto = 11 ) then
    Resto := 0;

  if not( Resto = NumCPF[ 11 ] ) then
  begin
    Result := False;
    Exit;
  end;

  Result := True;
end;

procedure TFrm_Cadastro.FormatCurrency( Sender: TObject );
var
  Value: Currency;
  Str: string;
begin
  if Length( TVazEdit( Sender ).Text ) > 0 then
  begin
    Str := StringReplace( TVazEdit( Sender ).Text, 'R$', '', [ RfReplaceAll, RfIgnoreCase ] );
    try
      Value := StrToCurr( Str );
    except
      MessageDlg( 'Valor Inv�lido!', MtInformation, [ MbOK ], 0 );
      TVazEdit( Sender ).Clear;
      TVazEdit( Sender ).SetFocus;
      Exit;
    end;

    TVazEdit( Sender ).Text := FormatFloat( 'R$ 0.00##', Value );
  end;
end;

procedure TFrm_Cadastro.FormatDDD( Sender: TObject );
var
  Value: Double;
  Str: string;
begin
  if Length( TVazEdit( Sender ).Text ) > 0 then
  begin
    Str := StringReplace( TVazEdit( Sender ).Text, '+', '', [ RfReplaceAll, RfIgnoreCase ] );
    try
      Value := StrToInt( Str );
    except
      MessageDlg( 'Valor Inv�lido!', MtInformation, [ MbOK ], 0 );
      TVazEdit( Sender ).Clear;
      TVazEdit( Sender ).SetFocus;
      Exit;
    end;

    TVazEdit( Sender ).Text := FormatFloat( '+0', Value );
  end;
end;

procedure TFrm_Cadastro.FormatNumeroDecimais( Sender: TObject );
var
  Value: Real;
  Str: string;
begin
  if Length( TVazEdit( Sender ).Text ) > 0 then
  begin
    Str := TVazEdit( Sender ).Text;
    try
      Value := StrToFloat( Str );
    except
      MessageDlg( 'Valor Inv�lido!', MtInformation, [ MbOK ], 0 );
      TVazEdit( Sender ).Clear;
      TVazEdit( Sender ).SetFocus;
      Exit;
    end;

    TVazEdit( Sender ).Text := FormatFloat( '0.00##', Value );
  end;
end;

end.
