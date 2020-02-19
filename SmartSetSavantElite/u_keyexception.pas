unit u_keyexception;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs, u_const;

type
  { TKeyException }
  TKeyException = class
  private
    FOriginalKey: word;
    FOriginalValue: string;
    FReplacementKey: word;
    FReplacementValue: string;
  public
    constructor Create(iOriginalKey, iReplacementKey: word; sOriginalValue, sReplacementValue: string);
    property OriginalKey: word read FOriginalKey write FOriginalKey;
    property OriginalValue: string read FOriginalValue write FOriginalValue;
    property ReplacementKey: word read FReplacementKey write FReplacementKey;
    property ReplacementValue: string read FReplacementValue write FReplacementValue;
  end;

  { TKeyboardLayoutList }

  { TKeyExceptionList }

  TKeyExceptionList = class(TObjectList)
  private
  protected
    function GetItem(index: integer): TKeyException;
    procedure SetItem(Index: integer; AObject: TKeyException);
  public
    constructor Create;
    function GetReplacementKey(iOriginalKey: word): TKeyException;
    function GetReplacementKey(sOriginalValue: string): TKeyException;
    function Add(AObject: TKeyException): integer; reintroduce; virtual;
    function Remove(AObject: TKeyException): integer; reintroduce; virtual;
    property Items[index: integer]: TKeyException read GetItem write SetItem; default;
  end;

implementation

{ TKeyboardLayoutList }

function TKeyExceptionList.GetItem(index: integer): TKeyException;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TKeyException
  except
  end;
end;

procedure TKeyExceptionList.SetItem(Index: integer; AObject: TKeyException);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TKeyExceptionList.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

function TKeyExceptionList.GetReplacementKey(iOriginalKey: word): TKeyException;
var
  i:integer;
begin
  result := nil;

  for i := 0 to self.Count - 1 do
    if (self[i].OriginalKey = iOriginalKey) then
      result := self[i];
end;

function TKeyExceptionList.GetReplacementKey(sOriginalValue: string
  ): TKeyException;
var
  i:integer;
begin
  result := nil;

  for i := 0 to self.Count - 1 do
    if (UpperCase(self[i].OriginalValue) = UpperCase(sOriginalValue)) then
      result := self[i];
end;

function TKeyExceptionList.Add(AObject: TKeyException): integer;
begin
  Result := inherited Add(AObject);
end;

function TKeyExceptionList.Remove(AObject: TKeyException): integer;
begin
  Result := inherited Remove(AObject);
end;

{ TKeyException }

constructor TKeyException.Create(iOriginalKey, iReplacementKey: word; sOriginalValue, sReplacementValue: string);
begin
  FOriginalKey := iOriginalKey;
  FOriginalValue := sOriginalValue;
  FReplacementKey := iReplacementKey;
  FReplacementValue := sReplacementValue;
end;

end.

