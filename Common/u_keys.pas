//CreoSource Inc. (info@creosource.com)
//Classes representing single key strokes and list of key strokes
unit U_Keys;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs;

type

  TKeyState = (ksNone, ksDown, ksUp);

  //class representing a key

  { TKey }
  TKey = class
  private
    FKey: word;
    FValue: string;
    FDisplayText: string;
    FSaveValue: string;
    FShiftedValue: string;
    FShowShiftedValue: boolean; //Whether or not to show shifted value
    FMultiValue: string; //Value when multiple keys and not with modifier
    FModifiers: string;
    FUpDown: TKeyState;
    FWriteDownUp: boolean; //In macro mode, write - for down and + for up, when disabled only write once
    FDiffPressRel: boolean; //In macro mode, does it have different press & release
    FConvertToUnicode: boolean; //Convert key to unicode
    FDisplaySize: integer;
    FFontName: string;
    FOtherDisplayText: string;
    FImageName: string;
    FSearchText: string;
  public
    //constructor Create(iKey: word; sValue: string; sSaveValue: string = '';
    //  sShiftedValue: string = ''; sMultiValue: string = '';
    //  sModifiers: string = ''; WriteDownUp: boolean = True; DiffPressRel: boolean = False);
    constructor Create(iKey: word; sValue: string; sDisplayText: string = ''; sSaveValue: string = ''; sMultiValue: string = ''; sShiftedValue: string = '';
      bConvertToUnicode: boolean = false; bShowShiftedValue: boolean = false;
      sModifiers: string = ''; WriteDownUp: boolean = True; DiffPressRel: boolean = False; iDisplaySize: integer = 0; sFontName: string = '';
      sOtherDisplayText: string = ''; sSearchText: string = ''; ImageName: string = ''; UpDown: TKeyState = ksNone);
    function CopyKey: TKey;
    function Compare(aKey: TKey): boolean;
    property Key: word read FKey;
    property Value: string read FValue write FValue;
    property DisplayText: string read FDisplayText write FDisplayText;
    property SaveValue: string read FSaveValue write FSaveValue;
    property ShiftedValue: string read FShiftedValue write FShiftedValue;
    property ShowShiftedValue: boolean read FShowShiftedValue write FShowShiftedValue;
    property MultiValue: string read FMultiValue write FMultiValue;
    property Modifiers: string read FModifiers write FModifiers;
    property WriteDownUp: boolean read FWriteDownUp write FWriteDownUp;
    property DiffPressRel: boolean read FDiffPressRel write FDiffPressRel;
    property ConvertToUnicode: boolean read FConvertToUnicode write FConvertToUnicode;
    property FontName: string read FFontName write FFontName;
    property DisplaySize: integer read FDisplaySize write FDisplaySize;
    property OtherDisplayText: string read FOtherDisplayText write FOtherDisplayText;
    property SearchText: string read FSearchText write FSearchText;
    property ImageName: string read FImageName write FImageName;
    property UpDown: TKeyState read FUpDown write FUpDown;
  end;

  //List of Keys

  { TKeyList }

  TKeyList = class(TObjectList)
  private
    FGuid: TGuid;
    FTriggerKey: integer;
    FLayerIdx: integer;
    FMacroIdx: integer;
    FMultiKey: boolean;
    FCoTrigger1: TKey;
    FCoTrigger2: TKey;
    FCoTrigger3: TKey;
    FCoTrigger4: TKey;
    FMacroSpeed: integer;
    FMacroRptFreq: integer;
    FIsNew: boolean;
  protected
    function GetItem(index: integer): TKey;
    procedure SetItem(Index: integer; AObject: TKey);
    function GetCountCoTriggers: integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AObject: TKey): integer; reintroduce; virtual;
    function Remove(AObject: TKey): integer; reintroduce; virtual;
    procedure Assign(aKeyList: TKeyList; coTriggers: boolean = false);
    function Compare(aKeyList: TKeyList): boolean;
    function ContrainsKey(aKey: TKey): boolean;
    property Items[index: integer]: TKey read GetItem write SetItem; default;
    property Guid: TGuid read FGuid;
    property TriggerKey: integer read FTriggerKey write FTriggerKey;
    property LayerIdx: integer read FLayerIdx write FLayerIdx;
    property MultiKey: boolean read FMultiKey write FMultiKey;
    property MacroIdx: integer read FMacroIdx write FMacroIdx;
    property CoTrigger1: TKey read FCoTrigger1 write FCoTrigger1;
    property CoTrigger2: TKey read FCoTrigger2 write FCoTrigger2;
    property CoTrigger3: TKey read FCoTrigger3 write FCoTrigger3;
    property CoTrigger4: TKey read FCoTrigger4 write FCoTrigger4;
    property MacroSpeed: integer read FMacroSpeed write FMacroSpeed;
    property MacroRptFreq: integer read FMacroRptFreq write FMacroRptFreq;
    property CountCoTriggers: integer read GetCountCoTriggers;
    property IsNew: boolean read FIsNew write FIsNew;
  end;

implementation

uses u_const;

{ TKey }

constructor TKey.Create(iKey: word; sValue: string; sDisplayText: string; sSaveValue: string; sMultiValue: string;
  sShiftedValue: string; bConvertToUnicode: boolean; bShowShiftedValue: boolean; sModifiers: string;
  WriteDownUp: boolean; DiffPressRel: boolean; iDisplaySize: integer; sFontName: string; sOtherDisplayText: string;
  sSearchText: string = ''; ImageName: string = ''; UpDown: TKeyState = ksNone);
begin
  inherited Create;
  FKey := iKey;
  FValue := sValue;
  if sDisplayText = '' then
    FDisplayText := FValue
  else
    FDisplayText := sDisplayText;
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
  FFontName := sFontName;
  FDisplaySize := iDisplaySize;
  if sOtherDisplayText = '' then
    FOtherDisplayText := sDisplayText
  else
    FOtherDisplayText := sOtherDisplayText;
  FSearchText := sSearchText;
  FImageName := ImageName;
  FUpDown := UpDown;
end;

//Creates a new key from the current key
function TKey.CopyKey: TKey;
begin
  Result := nil;
  if self <> nil then
    Result := TKey.Create(self.Key, self.Value, self.DisplayText, self.SaveValue, self.MultiValue, self.ShiftedValue,
      self.ConvertToUnicode, self.ShowShiftedValue, self.Modifiers, self.WriteDownUp,
      self.DiffPressRel, self.DisplaySize, self.FontName, self.OtherDisplayText, self.SearchText, self.ImageName, self.FUpDown);
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
      (self.DisplayText = aKey.DisplayText) and
      (self.SaveValue = aKey.SaveValue) and
      (self.ShiftedValue = aKey.ShiftedValue) and
      (self.ConvertToUnicode = aKey.ConvertToUnicode) and
      (self.ShowShiftedValue = aKey.ShowShiftedValue) and
      (self.MultiValue = aKey.MultiValue) and
      (self.Modifiers = aKey.Modifiers) and
      (self.WriteDownUp = aKey.WriteDownUp) and
      (self.DiffPressRel = aKey.DiffPressRel) and
      (self.FontName = aKey.FontName) and
      (self.DisplaySize = aKey.DisplaySize) and
      (self.OtherDisplayText = aKey.OtherDisplayText) and
      (self.SearchText = aKey.SearchText) and
      (self.ImageName = aKey.ImageName) and
      (self.UpDown = aKey.UpDown);
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

function TKeyList.GetCountCoTriggers: integer;
begin
  result := 0;
  if (CoTrigger1 <> nil) then
    inc(result);
  if (CoTrigger2 <> nil) then
    inc(result);
  if (CoTrigger3 <> nil) then
    inc(result);
  if (CoTrigger4 <> nil) then
    inc(result);
end;

constructor TKeyList.Create;
begin
  inherited Create;
  OwnsObjects := True;
  FTriggerKey := -1;
  LayerIdx := -1;
  FMultiKey := False;
  FIsNew := false;
  CreateGUID(FGuid);
  if (GApplication in [APPL_FSEDGE, APPL_FSPRO]) then
  begin
    FMacroSpeed := DEFAULT_MACRO_SPEED_FS;
    FMacroRptFreq := DEFAULT_MACRO_FREQ_FS;
  end
  else
  begin
    FMacroSpeed := DEFAULT_MACRO_SPEED_RGB;
    FMacroRptFreq := DEFAULT_MACRO_FREQ_RGB;
  end;
end;

destructor TKeyList.Destroy;
var
  i:integer;
begin
  if (FCoTrigger1 <> nil) then
    FreeAndNil(FCoTrigger1);
  if (FCoTrigger2 <> nil) then
    FreeAndNil(FCoTrigger2);
  if (FCoTrigger3 <> nil) then
    FreeAndNil(FCoTrigger3);
  if (FCoTrigger4 <> nil) then
    FreeAndNil(FCoTrigger4);
  inherited Destroy;
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
procedure TKeyList.Assign(aKeyList: TKeyList; coTriggers: boolean = false);
var
  i: integer;
begin
  if (self <> nil) and (aKeyList <> nil) then
  begin
    self.Clear;
    self.FTriggerKey := aKeyList.FTriggerKey;
    self.FLayerIdx := aKeyList.FLayerIdx;
    self.FMultiKey := aKeyList.FMultiKey;
    if (coTriggers) then
    begin
      self.FCoTrigger1 := aKeyList.FCoTrigger1.CopyKey;
      self.FCoTrigger2 := aKeyList.FCoTrigger2.CopyKey;
      self.FCoTrigger3 := aKeyList.FCoTrigger3.CopyKey;
      self.FCoTrigger4 := aKeyList.FCoTrigger4.CopyKey;
    end;
    self.FMacroIdx := aKeyList.FMacroIdx;
    self.FMacroSpeed := aKeyList.FMacroSpeed;
    self.FMacroRptFreq := aKeyList.FMacroRptFreq;
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

function TKeyList.ContrainsKey(aKey: TKey): boolean;
var
  i:integer;
begin
  result := false;
  for i := 0 to self.Count - 1 do
  begin
    if Self[i].Key = aKey.Key then
    begin
      result := true;
      break;
    end;
  end;
end;

end.















