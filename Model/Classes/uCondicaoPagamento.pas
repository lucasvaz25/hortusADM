unit uCondicaoPagamento;

interface

uses
  UGeral;

type
  TCondicaoPagamento = class( TGeral )
  private
    FCondPag: string;
    procedure SetCondPag( const Value: string );
  public
    constructor Create;
    destructor Destroy;
    procedure Free;

    property CondPag: string read FCondPag write SetCondPag;

    procedure CopiarDados( Value: TCondicaoPagamento );
  end;

implementation

{ TCondicaoPagamento }

procedure TCondicaoPagamento.CopiarDados( Value: TCondicaoPagamento );
begin
  inherited CopiarDados( Value );
  FCondPag := Value.CondPag;
end;

constructor TCondicaoPagamento.Create;
begin
  inherited Create;
end;

destructor TCondicaoPagamento.Destroy;
begin
  inherited;
end;

procedure TCondicaoPagamento.Free;
begin
  if Assigned( Self ) then
    Self.Destroy;
end;

procedure TCondicaoPagamento.SetCondPag( const Value: string );
begin
  FCondPag := Value;
end;

end.
