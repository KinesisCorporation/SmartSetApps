unit u_KeyboardLayout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs, u_const, u_keyexception;

type
  { TKeyboardLayout }
  TKeyboardLayout = class
  private
    FKBLayout: string;
    FName: string;
    FKeyExceptions: TKeyExceptionList;
  public
    constructor Create(sKBLayout, sName: string);
    property KBLayout: string read FKBLayout write FKBLayout;
    property Name: string read FName write FName;
    property KeyExceptions: TKeyExceptionList read FKeyExceptions write FKeyExceptions;
  end;

  { TKeyboardLayoutList }
  TKeyboardLayoutList = class(TObjectList)
  private
  protected
    function GetItem(index: integer): TKeyboardLayout;
    procedure SetItem(Index: integer; AObject: TKeyboardLayout);
  public
    constructor Create;
    function Add(AObject: TKeyboardLayout): integer; reintroduce; virtual;
    function Remove(AObject: TKeyboardLayout): integer; reintroduce; virtual;
    property Items[index: integer]: TKeyboardLayout read GetItem write SetItem; default;
    function IsValidKBLayout(sKBLayout: string): boolean;
    function FindByKBLayout(sKBLayout: string): TKeyboardLayout;
  end;

implementation

{ TKeyboardLayoutList }

function TKeyboardLayoutList.GetItem(index: integer): TKeyboardLayout;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TKeyboardLayout
  except
  end;
end;

procedure TKeyboardLayoutList.SetItem(Index: integer; AObject: TKeyboardLayout);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TKeyboardLayoutList.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

function TKeyboardLayoutList.Add(AObject: TKeyboardLayout): integer;
begin
  Result := inherited Add(AObject);
end;

function TKeyboardLayoutList.Remove(AObject: TKeyboardLayout): integer;
begin
  Result := inherited Remove(AObject);
end;

function TKeyboardLayoutList.IsValidKBLayout(sKBLayout: string): boolean;
var
  i:integer;
begin
  result := false;

  for i := 0 to self.Count - 1 do
    if (UpperCase(self[i].KBLayout) = UpperCase(sKBLayout)) then
      result := true;
end;

function TKeyboardLayoutList.FindByKBLayout(sKBLayout: string): TKeyboardLayout;
var
  i:integer;
begin
  result := nil;

  for i := 0 to self.Count - 1 do
    if (UpperCase(self[i].KBLayout) = UpperCase(sKBLayout)) then
      result := self[i];
end;

{ TKeyboardLayout }

constructor TKeyboardLayout.Create(sKBLayout, sName: string);
begin
  FKBLayout := sKBLayout;
  FName := sName;
  KeyExceptions := TKeyExceptionList.Create;
end;

end.

