unit uToolsSistema;

interface

uses
  System.SysUtils,
  Vcl.Dialogs;

type
  TToolsSistema = class
  public
    class function ValidarCPF( const Value: string ): Boolean;
    class function GetDefaultDate( const ADate, Field: string ): TDateTime;
  end;

implementation

{ TToolsSistema }

class function TToolsSistema.GetDefaultDate( const ADate, Field: string ): TDateTime;
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

class function TToolsSistema.ValidarCPF( const Value: string ): Boolean;
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

end.
