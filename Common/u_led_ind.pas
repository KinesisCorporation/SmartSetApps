unit u_led_ind;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs, Graphics;

type
  TIndFunction = (ifDisable, ifNKRO, ifGameMode, ifProfile, ifCaps, ifLayer, ifNumLock, ifScrollLock, ifBattery);

  //class representing a led indicator

  { TLedInd }

  TLedInd = class
  private
    FFnToken: TIndFunction;
    FLayerIdx: integer;
    FIndColor: array[0..5] of TColor;
    function GetIndColor(i: integer): TColor;
    procedure SetIndColor(i: integer; color: TColor);
    function GetFnTokenText: string;
  public
    constructor Create;
    procedure Reset;
    procedure SetAllColor(color: TColor);
    property FnToken: TIndFunction read FFnToken write FFnToken;
    property FnTokenText: string read GetFnTokenText;
    property LayerIdx: Integer read FLayerIdx write FLayerIdx;
    property IndColor[i: integer]: TColor read GetIndColor write SetIndColor;
  end;

  //List of led indicators

  { TLedIndList }

  TLedIndList = class(TObjectList)
  private
  protected
    function GetItem(index: integer): TLedInd;
    procedure SetItem(Index: integer; AObject: TLedInd);
  public
    constructor Create(nbOfLeds: integer);
    destructor Destroy; override;
    function Add(AObject: TLedInd): integer; reintroduce; virtual;
    function Remove(AObject: TLedInd): integer; reintroduce; virtual;
    procedure ResetAll;
    property Items[index: integer]: TLedInd read GetItem write SetItem; default;
  end;

implementation

uses u_const;

{ TLedIndList }

function TLedIndList.GetItem(index: integer): TLedInd;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TLedInd
  except
    //do nothing
    //on E : Exception do HandleExcept(E, True, 'Error in TKey.GetItem. Index out of range.');
  end;
end;

procedure TLedIndList.SetItem(Index: integer; AObject: TLedInd);
begin
  try
    inherited Items[Index] := AObject
  except
    //do nothing
    //on E : Exception do HandleExcept(E, True, 'Error in TKeyList.SetItem. Index out of range.');
  end;
end;

constructor TLedIndList.Create(nbOfLeds: integer);
var
  i:integer;
  ledInd: TLedInd;
begin
  inherited Create;
  OwnsObjects := True;
  for i := 0 to nbOfLeds - 1 do
  begin
    ledInd := TLedInd.Create;
    Add(ledInd);
  end;
end;

destructor TLedIndList.Destroy;
begin
  inherited Destroy;
end;

function TLedIndList.Add(AObject: TLedInd): integer;
begin
  Result := inherited Add(AObject);
end;

function TLedIndList.Remove(AObject: TLedInd): integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TLedIndList.ResetAll;
var
  i: integer;
begin
  for i:= 0 to Count - 1 do
  begin
    Items[i].Reset;
  end;
end;

{ TLedInd }

function TLedInd.GetIndColor(i: integer): TColor;
begin
  if (Length(FIndColor) >= i) then
    result := FIndColor[i]
  else
    result := clNone;
end;

procedure TLedInd.SetIndColor(i: integer; color: TColor);
begin
  if (Length(FIndColor) >= i) then
    FIndColor[i] := color;
end;

function TLedInd.GetFnTokenText: string;
begin
  result := '';
  if (FnToken = ifGameMode) then
    result := 'Game Mode'
  else if (FnToken = ifNKRO) then
    result := 'NKRO Mode'
  else if (FnToken = ifScrollLock) then
    result := 'Scroll Lock'
  else if (FnToken = ifNumLock) then
    result := 'Num Lock'
  else if (FnToken = ifCaps) then
    result := 'Caps Lock'
  else if (FnToken = ifLayer) then
    result := 'Layer'
  else if (FnToken = ifProfile) then
    result := 'Profile'
  else if (FnToken = ifBattery) then
    result := 'Battery'
  else if (FnToken = ifDisable) then
    result := 'Disable';
end;

constructor TLedInd.Create;
begin
  inherited Create;
  Reset;
end;

procedure TLedInd.Reset;
var
  i: integer;
begin
  FFnToken := TIndFunction.ifDisable;
  FLayerIdx := -1;
  SetAllColor(clBlack);
end;

procedure TLedInd.SetAllColor(color: TColor);
var
  i: integer;
begin
  for i:= 0 to Length(FIndColor) - 1 do
  begin
    FIndColor[i] := color;
  end;
end;

end.















