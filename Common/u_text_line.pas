unit u_text_line;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs;

type

{ TLineSegment }

TLineSegment = class
private
  FText: string;
  FTextLength: integer;
  FIsValid: boolean;
public
  constructor Create(text: string; isValid: boolean);
  property Text: string read FText write FText;
  property TextLength: integer read FTextLength write FTextLength;
  property IsValid: boolean read FIsValid write FIsValid;
end;

{ TTextLine }

TTextLine = class(TObjectList)
private
  FId: integer;
  FLayerIdx: integer;
  FRawText: string;
  FKeep: boolean;
  FRemoved: boolean;
protected
  function GetItem(index: integer): TLineSegment;
  procedure SetItem(Index: integer; AObject: TLineSegment);
public
  constructor Create(lineId: integer; layerIdx: integer);
  destructor Destroy; override;
  function Add(AObject: TLineSegment): integer; reintroduce; virtual;
  function Remove(AObject: TLineSegment): integer; reintroduce; virtual;
  function LineText: string;
  function IsValid: boolean;
  property Items[index: integer]: TLineSegment read GetItem write SetItem; default;
  property Id: integer read FId write FId;
  property LayerIdx: integer read FLayerIdx write FLayerIdx;
  property RawText: string read FRawText write FRawText;
  property Keep: boolean read FKeep write FKeep;
  property Removed: boolean read FRemoved write FRemoved;
end;

{ TTextLines }

TTextLines = class(TObjectList)
private

protected
  function GetItem(index: integer): TTextLine;
  procedure SetItem(Index: integer; AObject: TTextLine);
public
  constructor Create;
  destructor Destroy; override;
  function Add(AObject: TTextLine): integer; reintroduce; virtual;
  function Remove(AObject: TTextLine): integer; reintroduce; virtual;
  property Items[index: integer]: TTextLine read GetItem write SetItem; default;
end;

implementation

{ TTextLines }

function TTextLines.GetItem(index: integer): TTextLine;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TTextLine
  except
  end;
end;

procedure TTextLines.SetItem(Index: integer; AObject: TTextLine);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TTextLines.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

destructor TTextLines.Destroy;
begin
  inherited Destroy;
end;

function TTextLines.Add(AObject: TTextLine): integer;
begin
  Result := inherited Add(AObject);
end;

function TTextLines.Remove(AObject: TTextLine): integer;
begin
  Result := inherited Remove(AObject);
end;

{ TLineSegment }

constructor TLineSegment.Create(text: string; isValid: boolean);
begin
  inherited Create;
  FText := text;
  FIsValid := isValid;
  FTextLength := Length(text);
end;

{ TTextLine }

function TTextLine.GetItem(index: integer): TLineSegment;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TLineSegment
  except
  end;
end;

procedure TTextLine.SetItem(Index: integer; AObject: TLineSegment);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TTextLine.Create(lineId: integer; layerIdx: integer);
begin
  inherited Create;
  OwnsObjects := True;
  FId := lineId;
  FLayerIdx := layerIdx;
  FKeep := false;
  FRemoved := false;
end;

destructor TTextLine.Destroy;
begin
  inherited Destroy;
end;

function TTextLine.Add(AObject: TLineSegment): integer;
begin
  Result := inherited Add(AObject);
end;

function TTextLine.Remove(AObject: TLineSegment): integer;
begin
  Result := inherited Remove(AObject);
end;

function TTextLine.LineText: string;
var
  text: string;
  i: integer;
begin
  text := '';
  for i:=0 to Count - 1 do
  begin
    text := text + Items[i].Text;
  end;

  result := text;
end;

function TTextLine.IsValid: boolean;
var
  text: string;
  i: integer;
begin
  result := true;
  i := 0;
  while (result and (i < Count)) do
  begin
    result := Items[i].IsValid;
    inc(i);
  end;
end;

end.
