//CreoSource Inc. (info@creosource.com)
//Classes representing single key strokes and list of key strokes
unit U_Keys;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs, u_const;

type
  //class representing a key

  { TKey }

  TKey = class
  private
    FKey: word;
    FValue: string;
    FSaveValue: string;
    FShiftedValue: string;
    FShowShiftedValue: boolean; //Whether or not to show shifted value
    FMultiValue: string; //Value when multiple keys and not with modifier
    FModifiers: string;
    FWriteDownUp: boolean; //In macro mode, write - for down and + for up, when disabled only write once
    FDiffPressRel: boolean; //In macro mode, does it have different press & release
    FConvertToUnicode: boolean; //Convert key to unicode
  public
    //constructor Create(iKey: word; sValue: string; sSaveValue: string = '';
    //  sShiftedValue: string = ''; sMultiValue: string = '';
    //  sModifiers: string = ''; WriteDownUp: boolean = True; DiffPressRel: boolean = False);
    constructor Create(iKey: word; sValue: string; sSaveValue: string = ''; sMultiValue: string = ''; sShiftedValue: string = '';
      bConvertToUnicode: boolean = false; bShowShiftedValue: boolean = false;
      sModifiers: string = ''; WriteDownUp: boolean = True; DiffPressRel: boolean = False);
    function CopyKey: TKey;
    function Compare(aKey: TKey): boolean;
    property Key: word read FKey;
    property Value: string read FValue write FValue;
    property SaveValue: string read FSaveValue write FSaveValue;
    property ShiftedValue: string read FShiftedValue write FShiftedValue;
    property ShowShiftedValue: boolean read FShowShiftedValue write FShowShiftedValue;
    property MultiValue: string read FMultiValue write FMultiValue;
    property Modifiers: string read FModifiers write FModifiers;
    property WriteDownUp: boolean read FWriteDownUp write FWriteDownUp;
    property DiffPressRel: boolean read FDiffPressRel write FDiffPressRel;
    property ConvertToUnicode: boolean read FConvertToUnicode write FConvertToUnicode;
  end;

  //List of Keys

  { TKeyList }

  TKeyList = class(TObjectList)
  private
    FMultiKey: boolean;
  protected
    function GetItem(index: integer): TKey;
    procedure SetItem(Index: integer; AObject: TKey);
  public
    constructor Create;
    function Add(AObject: TKey): integer; reintroduce; virtual;
    function Remove(AObject: TKey): integer; reintroduce; virtual;
    procedure Assign(aKeyList: TKeyList);
    function Compare(aKeyList: TKeyList): boolean;
    property Items[index: integer]: TKey read GetItem write SetItem; default;
    property MultiKey: boolean read FMultiKey write FMultiKey;
  end;

implementation

{ TKey }

//constructor TKey.Create(iKey: word; sValue: string; sSaveValue: string = '';
//  sShiftedValue: string = ''; sMultiValue: string = ''; sModifiers: string = '';
//  WriteDownUp: boolean = True; DiffPressRel: boolean = False);
//begin
//  inherited Create;
//  FKey := iKey;
//  FValue := sValue;
//  //If sSaveValue is empty, takes the same value as sValue
//  if sSaveValue = '' then
//    FSaveValue := FValue
//  else
//    FSaveValue := sSaveValue;
//  FShiftedValue := sShiftedValue;
//  FMultiValue := sMultiValue;
//  FModifiers := sModifiers;
//  FWriteDownUp := WriteDownUp;
//  FDiffPressRel := DiffPressRel;
//end;

constructor TKey.Create(iKey: word; sValue: string; sSaveValue: string; sMultiValue: string;
  sShiftedValue: string; bConvertToUnicode: boolean; bShowShiftedValue: boolean; sModifiers: string;
  WriteDownUp: boolean; DiffPressRel: boolean);
begin
  inherited Create;
  FKey := iKey;
  FValue := sValue;
  //If sSaveValue is empty, takes the same value as sValue
  if sSaveValue = '' then
    FSaveValue := FValue
  else
    FSaveValue := sSaveValue;
  FConvertToUnicode := bConvertToUnicode;
  FShowShiftedValue := bShowShiftedValue;
  FMultiValue := sMultiValue;
  FShiftedValue := sShiftedValue;
  FModifiers := sModifiers;
  FWriteDownUp := WriteDownUp;
  FDiffPressRel := DiffPressRel;
end;

//Creates a new key from the current key
function TKey.CopyKey: TKey;
begin
  Result := nil;
  if self <> nil then
    Result := TKey.Create(self.Key, self.Value, self.SaveValue, self.MultiValue, self.ShiftedValue,
      self.ConvertToUnicode, self.ShowShiftedValue, self.Modifiers, self.WriteDownUp,
      self.DiffPressRel);

  //JM temp disable
  //if self <> nil then
  //  Result := TKey.Create(self.Key, self.Value, self.SaveValue,
  //    self.ShiftedValue, self.MultiValue, self.Modifiers, self.WriteDownUp, self.DiffPressRel);
end;

//Compares current key to key passed in parameter
function TKey.Compare(aKey: TKey): boolean;
begin
  result := false;
  if aKey <> nil then
  begin
    result := (self.Key = aKey.Key) and
      (self.Key = aKey.Key) and
      (self.Value = aKey.Value) and
      (self.SaveValue = aKey.SaveValue) and
      (self.ShiftedValue = aKey.ShiftedValue) and
      (self.MultiValue = aKey.MultiValue) and
      (self.Modifiers = aKey.Modifiers) and
      (self.WriteDownUp = aKey.WriteDownUp) and
      (self.DiffPressRel = aKey.DiffPressRel);
  end;
end;

{ TKeyList }

function TKeyList.GetItem(index: integer): TKey;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TKey
  except
    //do nothing
    //on E : Exception do HandleExcept(E, True, 'Error in TKey.GetItem. Index out of range.');
  end;
end;

procedure TKeyList.SetItem(Index: integer; AObject: TKey);
begin
  try
    inherited Items[Index] := AObject
  except
    //do nothing
    //on E : Exception do HandleExcept(E, True, 'Error in TKeyList.SetItem. Index out of range.');
  end;
end;

constructor TKeyList.Create;
begin
  inherited Create;
  OwnsObjects := True;
  FMultiKey := False;
end;

function TKeyList.Add(AObject: TKey): integer;
begin
  Result := inherited Add(AObject);
end;

function TKeyList.Remove(AObject: TKey): integer;
begin
  Result := inherited Remove(AObject);
end;

//Assigns all values from another key list
procedure TKeyList.Assign(aKeyList: TKeyList);
var
  i: integer;
begin
  if (self <> nil) and (aKeyList <> nil) then
  begin
    self.Clear;
    self.FMultiKey := aKeyList.FMultiKey;
    for i := 0 to aKeyList.Count - 1 do
    begin
      self.Add(aKeyList.Items[i].CopyKey);
    end;
  end;
end;

//Compares the key list to the list passed in parameter
function TKeyList.Compare(aKeyList: TKeyList): boolean;
var
  i:integer;
begin
  result := false;
  if aKeyList <> nil then
  begin
    //Checks if they are both multikeys and same number of key items
    result := (self.FMultiKey = aKeyList.MultiKey) and
       (self.Count = aKeyList.Count);

    if result then
    begin
      i := 0;
      //Compares all keys to makre sure they are the same
      While (i < self.Count) and (result) do
      begin
        result := self.Items[i].Compare(aKeyList.Items[i]);
        inc(i);
      end;
    end;
  end;
end;

end.















