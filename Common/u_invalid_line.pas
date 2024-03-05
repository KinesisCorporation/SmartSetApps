unit u_invalid_line;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs;

type

{ TInvalidItem }

TInvalidItem = class
private
  FText: string;
  FLayerIdx: integer;
  FLength: integer;
  FIsValid: boolean;
public
  constructor Create(text: string; layerIdx: integer; isValid: boolean);
  property Text: string read FText write FText;
  property LayerIdx: integer read FLayerIdx write FLayerIdx;
  property Length: integer read FLength write FLength;
  property IsValid: boolean read FIsValid write FIsValid;
end;

{ TInvalidLine }

TInvalidLine = class(TObjectList)
private

protected
  function GetItem(index: integer): TInvalidItem;
  procedure SetItem(Index: integer; AObject: TInvalidItem);
public
  constructor Create;
  destructor Destroy; override;
  function Add(AObject: TInvalidItem): integer; reintroduce; virtual;
  function Remove(AObject: TInvalidItem): integer; reintroduce; virtual;
  property Items[index: integer]: TInvalidItem read GetItem write SetItem; default;
end;

{ TInvalidLine }

{ TInvalidLines }

TInvalidLines = class(TObjectList)
private

protected
  function GetItem(index: integer): TInvalidLine;
  procedure SetItem(Index: integer; AObject: TInvalidLine);
public
  constructor Create;
  destructor Destroy; override;
  function Add(AObject: TInvalidLine): integer; reintroduce; virtual;
  function Remove(AObject: TInvalidLine): integer; reintroduce; virtual;
  property Items[index: integer]: TInvalidLine read GetItem write SetItem; default;
end;

implementation

{ TInvalidLines }

function TInvalidLines.GetItem(index: integer): TInvalidLine;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TInvalidLine
  except
  end;
end;

procedure TInvalidLines.SetItem(Index: integer; AObject: TInvalidLine);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TInvalidLines.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

destructor TInvalidLines.Destroy;
begin
  inherited Destroy;
end;

function TInvalidLines.Add(AObject: TInvalidLine): integer;
begin
  Result := inherited Add(AObject);
end;

function TInvalidLines.Remove(AObject: TInvalidLine): integer;
begin
  Result := inherited Remove(AObject);
end;

{ TInvalidItem }

constructor TInvalidItem.Create(text: string; layerIdx: integer; isValid: boolean);
begin
  inherited Create;
  FText := text;
  FLayerIdx = layerIdx;
  FIsValid := isValid;
  FLength := Length(text);
end;

{ TInvalidLine }

function TInvalidLine.GetItem(index: integer): TInvalidItem;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TInvalidItem
  except
  end;
end;

procedure TInvalidLine.SetItem(Index: integer; AObject: TInvalidItem);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TInvalidLine.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

destructor TInvalidLine.Destroy;
begin
  inherited Destroy;
end;

function TInvalidLine.Add(AObject: TInvalidItem): integer;
begin
  Result := inherited Add(AObject);
end;

function TInvalidLine.Remove(AObject: TInvalidItem): integer;
begin
  Result := inherited Remove(AObject);
end;

end.

