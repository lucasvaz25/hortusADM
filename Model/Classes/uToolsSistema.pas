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
var
  IsValid: Boolean;
begin

  if ( ADate.Equals( '__/__/____' ) ) then
    IsValid := False
  else
    IsValid := ( ADate.Length > 0 );

  if ( IsValid ) then
  begin
    if not TryStrToDate( ADate, Result ) then
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
begin
  Result := not( Value.Length = 11 );
end;

end.
