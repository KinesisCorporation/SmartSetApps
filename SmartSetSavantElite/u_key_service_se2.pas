//CreoSource Inc. (info@creosource.com)
//Business logic for key configuration utility
//Contains key list for all inputs as well as supported keys
unit u_key_service_se2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, u_keys, LCLType, u_const, u_keyboardlayout;

type
  //KeyService contains all logic for key inputs

  { TKeyServiceSE2 }

  TKeyServiceSE2 = class
  private
    //FActivePedal: TKeyList;
    FCurrentPedal: TPedal;

    FCurrentKBLayout: string;

    //List of supported keys from programming guide
    FConfigKeys: TKeyList;
    FActiveModifiers: TKeyList;
    FTempKeys: TKeyList;

    //List of supported keyboard layouts
    FKeyboardLayouts: TKeyboardLayoutList;

    //Left, Middle and Right keys
    FLPKeys: TKeyList;
    FMPKeys: TKeyList;
    FRPKeys: TKeyList;

    //Jack1 to 4 keys
    FJ1Keys: TKeyList;
    FJ2Keys: TKeyList;
    FJ3Keys: TKeyList;
    FJ4Keys: TKeyList;
    function IsNumericKey(aKey: TKey): boolean;
    function IsAlphaKey(aKey: TKey): boolean;
    function IsShiftableKey(aKey: TKey): boolean;
    function GetModifierValues(aKey: TKey): string;
    procedure FillModifiersFromValues(aKeyList: TKeyList; sModifiers: string);
    function GetActivePedal: TKeyList;
    procedure ConvertFromTextFileFmt(aKeyList: TKeyList; pedalText: string);
    function GetKeyText(aKey: TKey; defaultValue: string = ''; checkAltGr: boolean = false): string;
    function IsAltGr(aKey: TKey): boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function FindKeyConfig(iKey: word): TKey; overload;
    function FindKeyConfig(sKey: string): TKey; overload;
    procedure AddModifier(key: word);
    procedure RemoveModifier(key: word);
    procedure ClearModifiers;
    function IsWinKeyDown: boolean;
    function AddKey(iKey: word; modifiers: string): boolean;
    function RemoveLastKey: boolean;
    function GetModifierText: string;
    function BackupKeyList: boolean;
    function RestoreKeyList: boolean;
    function LoadKeysFromFile(pedal: TKeyList; pedalText: TPedalText): boolean;
    function GetOutputText(aPedal: TKeyList; var aPedalsPos: TPedalsPos): string;
    function ConvertToTextFileFmt(aKeyList: TKeyList): TPedalText;
    function ActivePedalModified: boolean;
    procedure LoadKeyConfig;
    procedure LoadKeyboardLayouts;
    procedure UpdateCurrentKeyboardLayout;
    function GetReplacementKey(aKey: word; saving: boolean): string;

    property CurrentPedal: TPedal read FCurrentPedal write FCurrentPedal;
    property ActivePedal: TKeyList read GetActivePedal;

    property ConfigKeys: TKeyList read FConfigKeys write FConfigKeys;
    property ActiveModifiers: TKeyList read FActiveModifiers write FActiveModifiers;
    property TempKeys: TKeyList read FTempKeys write FTempKeys;
    property KeyboardLayouts: TKeyboardLayoutList read FKeyboardLayouts write FKeyboardLayouts;
    property LPKeys: TKeyList read FLPKeys write FLPKeys;
    property MPKeys: TKeyList read FMPKeys write FMPKeys;
    property RPKeys: TKeyList read FRPKeys write FRPKeys;
    property J1Keys: TKeyList read FJ1Keys write FJ1Keys;
    property J2Keys: TKeyList read FJ2Keys write FJ2Keys;
    property J3Keys: TKeyList read FJ3Keys write FJ3Keys;
    property J4Keys: TKeyList read FJ4Keys write FJ4Keys;
  end;

implementation

{ TKeyServiceSE2 }

constructor TKeyServiceSE2.Create;
begin
  inherited Create;
  FCurrentPedal := pNone;
  FCurrentKBLayout := '';
  FConfigKeys := TKeyList.Create;
  FActiveModifiers := TKeyList.Create;
  FTempKeys := TKeyList.Create;
  KeyboardLayouts := TKeyboardLayoutList.Create;
  FLPKeys := TKeyList.Create;
  FMPKeys := TKeyList.Create;
  FRPKeys := TKeyList.Create;
  FJ1Keys := TKeyList.Create;
  FJ2Keys := TKeyList.Create;
  FJ3Keys := TKeyList.Create;
  FJ4Keys := TKeyList.Create;

  LoadKeyConfig;
  LoadKeyboardLayouts;
  UpdateCurrentKeyboardLayout;
end;

destructor TKeyServiceSE2.Destroy;
begin
  FreeAndNil(FConfigKeys);
  FreeAndNil(FActiveModifiers);
  FreeAndNil(FLPKeys);
  FreeAndNil(FMPKeys);
  FreeAndNil(FRPKeys);
  FreeAndNil(FJ1Keys);
  FreeAndNil(FJ2Keys);
  FreeAndNil(FJ3Keys);
  FreeAndNil(FJ4Keys);
  FreeAndNil(FTempKeys);
  FreeAndNil(FKeyboardLayouts);
  inherited Destroy;
end;

//Load key config
procedure TKeyServiceSE2.LoadKeyConfig;
var
  i: integer;
begin
  self.ConfigKeys.Clear;
  //Control keys
  self.ConfigKeys.Add(TKey.Create(VK_ESCAPE, 'escape'));
  self.ConfigKeys.Add(TKey.Create(VK_PAUSE, 'pause'));
  self.ConfigKeys.Add(TKey.Create(VK_PRINT, 'prtscr'));
  self.ConfigKeys.Add(TKey.Create(VK_SNAPSHOT, 'prtscr'));
  self.ConfigKeys.Add(TKey.Create(VK_SCROLL, 'scroll'));
  self.ConfigKeys.Add(TKey.Create(VK_TAB, 'tab'));
  self.ConfigKeys.Add(TKey.Create(VK_CAPITAL, 'caps'));
  self.ConfigKeys.Add(TKey.Create(VK_SPACE, 'space', 'space', ' '));///UTF8String(#$e2#$90#$a3)));
  //When multi-key and no modifiers, show empty space
  self.ConfigKeys.Add(TKey.Create(VK_INSERT, 'insert'));
  self.ConfigKeys.Add(TKey.Create(VK_HOME, 'home'));
  self.ConfigKeys.Add(TKey.Create(VK_END, 'end'));
  self.ConfigKeys.Add(TKey.Create(VK_NEXT, 'pdown'));
  self.ConfigKeys.Add(TKey.Create(VK_PRIOR, 'pup'));
  self.ConfigKeys.Add(TKey.Create(VK_RIGHT, 'right'));
  self.ConfigKeys.Add(TKey.Create(VK_LEFT, 'left'));
  self.ConfigKeys.Add(TKey.Create(VK_UP, 'up'));
  self.ConfigKeys.Add(TKey.Create(VK_DOWN, 'down'));
  self.ConfigKeys.Add(TKey.Create(VK_SHIFT, 'shift'));
  self.ConfigKeys.Add(TKey.Create(VK_LSHIFT, 'lshift'));
  self.ConfigKeys.Add(TKey.Create(VK_RSHIFT, 'rshift'));
  self.ConfigKeys.Add(TKey.Create(VK_CONTROL, 'ctrl'));
  self.ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctrl'));
  self.ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctrl'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMLOCK, 'numlk'));
  //Windows
  {$ifdef Win64}
  self.ConfigKeys.Add(TKey.Create(VK_RETURN, 'enter'));
  self.ConfigKeys.Add(TKey.Create(VK_BACK, 'bspace'));
  self.ConfigKeys.Add(TKey.Create(VK_DELETE, 'delete'));
  self.ConfigKeys.Add(TKey.Create(VK_MENU, 'alt'));
  self.ConfigKeys.Add(TKey.Create(VK_LMENU, 'lalt'));
  self.ConfigKeys.Add(TKey.Create(VK_RMENU, 'ralt'));
  //self.ConfigKeys.Add(TKey.create(, 'Windows', 'win'));
  self.ConfigKeys.Add(TKey.Create(VK_LWIN, 'win'));
  self.ConfigKeys.Add(TKey.Create(VK_RWIN, 'win'));
  {$endif}

  //MacOS
  {$ifdef Darwin}
  self.ConfigKeys.Add(TKey.Create(VK_RETURN, 'return', 'enter'));
  self.ConfigKeys.Add(TKey.Create(VK_BACK, 'delete', 'bspace'));
  self.ConfigKeys.Add(TKey.Create(VK_DELETE, 'fwd-delete', 'delete'));
  self.ConfigKeys.Add(TKey.Create(VK_MENU, 'opt', 'alt'));
  self.ConfigKeys.Add(TKey.Create(VK_LMENU, 'lopt', 'lalt'));
  self.ConfigKeys.Add(TKey.Create(VK_RMENU, 'ropt', 'ralt'));
  self.ConfigKeys.Add(TKey.Create(VK_LWIN, 'cmd', 'win'));
  self.ConfigKeys.Add(TKey.Create(VK_RWIN, 'cmd', 'win'));
  {$endif}

  //F1 to F24
  self.ConfigKeys.Add(TKey.Create(VK_F1, 'F1'));
  self.ConfigKeys.Add(TKey.Create(VK_F2, 'F2'));
  self.ConfigKeys.Add(TKey.Create(VK_F3, 'F3'));
  self.ConfigKeys.Add(TKey.Create(VK_F4, 'F4'));
  self.ConfigKeys.Add(TKey.Create(VK_F5, 'F5'));
  self.ConfigKeys.Add(TKey.Create(VK_F6, 'F6'));
  self.ConfigKeys.Add(TKey.Create(VK_F7, 'F7'));
  self.ConfigKeys.Add(TKey.Create(VK_F8, 'F8'));
  self.ConfigKeys.Add(TKey.Create(VK_F9, 'F9'));
  self.ConfigKeys.Add(TKey.Create(VK_F10, 'F10'));
  self.ConfigKeys.Add(TKey.Create(VK_F11, 'F11'));
  self.ConfigKeys.Add(TKey.Create(VK_F12, 'F12'));
  self.ConfigKeys.Add(TKey.Create(VK_F13, 'F13'));
  self.ConfigKeys.Add(TKey.Create(VK_F14, 'F14'));
  self.ConfigKeys.Add(TKey.Create(VK_F15, 'F15'));
  self.ConfigKeys.Add(TKey.Create(VK_F16, 'F16'));
  self.ConfigKeys.Add(TKey.Create(VK_F17, 'F17'));
  self.ConfigKeys.Add(TKey.Create(VK_F18, 'F18'));
  self.ConfigKeys.Add(TKey.Create(VK_F19, 'F19'));
  self.ConfigKeys.Add(TKey.Create(VK_F20, 'F20'));
  self.ConfigKeys.Add(TKey.Create(VK_F21, 'F21'));
  self.ConfigKeys.Add(TKey.Create(VK_F22, 'F22'));
  self.ConfigKeys.Add(TKey.Create(VK_F23, 'F23'));
  self.ConfigKeys.Add(TKey.Create(VK_F24, 'F24'));

  //Character keys
  self.ConfigKeys.Add(TKey.Create(VK_LCL_EQUAL, '=', '', '=', '=', '+', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_MINUS, '-', '', 'hyphen', '-', '_', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_SLASH, '/', '', '/', '/', '?', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_BACKSLASH, '\', '', '\', '\', '|', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_QUOTE, '''', '', '''', '''', '"', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_TILDE, '`', '', '`', '`', '~', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_SEMI_COMMA, ';', '', ';', ';', ':', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_COMMA, ',', '', ',', ',', '<', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_POINT, '.', '', '.', '.', '>', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_OPEN_BRACKET, '[', '', 'obrack', '[', '{', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_LCL_CLOSE_BRACKET, ']', '', 'cbrack', ']', '}', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_OEM_102, 'intl-\', '', 'intl-\', 'intl-\', 'intl-\', true, true)); //International <> key between Left Shift and Z

  //Numpad keys
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD0, 'kp0'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD1, 'kp1'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD2, 'kp2'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD3, 'kp3'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD4, 'kp4'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD5, 'kp5'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD6, 'kp6'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD7, 'kp7'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD8, 'kp8'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPAD9, 'kp9'));
  self.ConfigKeys.Add(TKey.Create(VK_DIVIDE, 'kp/', 'kpdiv'));
  self.ConfigKeys.Add(TKey.Create(VK_MULTIPLY, 'kp*', 'kpmult'));
  self.ConfigKeys.Add(TKey.Create(VK_SUBTRACT, 'kp-', 'kpmin'));
  self.ConfigKeys.Add(TKey.Create(VK_ADD, 'kp+', 'kpplus'));
  self.ConfigKeys.Add(TKey.Create(VK_DECIMAL, 'kp.'));
  self.ConfigKeys.Add(TKey.Create(VK_NUMPADENTER, 'kpenter', 'kpenter'));

  //0 to 9
  self.ConfigKeys.Add(TKey.Create(VK_0, '0', '', '0', '0', ')', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_1, '1', '', '1', '1', '!', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_2, '2', '', '2', '2', '@', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_3, '3', '', '3', '3', '#', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_4, '4', '', '4', '4', '$', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_5, '5', '', '5', '5', '%', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_6, '6', '', '6', '6', '^', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_7, '7', '', '7', '7', '&', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_8, '8', '', '8', '8', '*', true, true));
  self.ConfigKeys.Add(TKey.Create(VK_9, '9', '', '9', '9', '(', true, true));

  //a to z
  for i := VK_A to VK_Z do
    self.ConfigKeys.Add(TKey.Create(i, LowerCase(Chr(i)), '', LowerCase(Chr(i)), LowerCase(Chr(i)), Chr(i),
      true, true));

  //Custom for special events
  self.ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmouse'));
  self.ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmouse'));
  self.ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmouse'));
  self.ConfigKeys.Add(TKey.Create(VK_SPEED1, 'speed1', '', 'speed1', '', '', false, false, '', False));
  self.ConfigKeys.Add(TKey.Create(VK_SPEED3, 'speed3', '', 'speed3', '', '', false, false, '', False));
  self.ConfigKeys.Add(TKey.Create(VK_SPEED5, 'speed5', '', 'speed5', '', '', false, false, '', False));
  self.ConfigKeys.Add(TKey.Create(VK_125MS, 'd125', '', 'd125', '', '', false, false, '', False));
  self.ConfigKeys.Add(TKey.Create(VK_500MS, 'd500', '', 'd500', '', '', false, false, '', False));
  self.ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute'));
  self.ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-'));
  self.ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+'));
  self.ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'play'));
  self.ConfigKeys.Add(TKey.Create(VK_MEDIA_PREV_TRACK, 'prev'));
  self.ConfigKeys.Add(TKey.Create(VK_MEDIA_NEXT_TRACK, 'next'));
  self.ConfigKeys.Add(TKey.Create(VK_CALC, 'calc'));
  self.ConfigKeys.Add(TKey.Create(VK_SHUTDOWN, 'shutdn'));
  self.ConfigKeys.Add(TKey.Create(VK_DIF_PRESS_REL, '{ }', ' '));
end;

//Old Method, not used anymore
//Load keyboard layouts
procedure TKeyServiceSE2.LoadKeyboardLayouts;
//var
//  keyboardLayout: TKeyboardLayout;
begin
  //self.KeyboardLayouts.Add(TKeyboardLayout.Create('00000409', 'English (US)'));
  //
  ////French Canadian
  //keyboardLayout := TKeyboardLayout.Create('00001009', 'English (Canadian)');
  ////Add exceptions here...
  //self.KeyboardLayouts.Add(keyboardLayout);
  //
  ////German (Germany)
  //keyboardLayout := TKeyboardLayout.Create('00000407', 'German (Germany)');
  //
  ////German key exceptions when loading and saving (original key, replacement key, original value, replacement value)
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_EQUAL, VK_LCL_CLOSE_BRACKET, '=', 'cbrack'));
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_MINUS, VK_LCL_OPEN_BRACKET, '-', 'obrack'));
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_TILDE, VK_LCL_BACKSLASH, '`', '\'));
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_BACKSLASH, VK_LCL_SLASH, '\', '/'));
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_CLOSE_BRACKET, VK_LCL_EQUAL, ']', '='));
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_OPEN_BRACKET, VK_LCL_SEMI_COMMA, '[', ';'));
  //keyboardLayout.KeyExceptions.Add(TKeyException.Create(VK_LCL_SLASH, VK_LCL_TILDE, '/', '`'));
  //
  //self.KeyboardLayouts.Add(keyboardLayout);
end;

procedure TKeyServiceSE2.UpdateCurrentKeyboardLayout;
begin
  FCurrentKBLayout := GetCurrentKeyoardLayout;//KeyboardLayouts.FindByKBLayout(GetCurrentKeyoardLayout);
end;

//Checks for replacement key values (non US English drivers)
function TKeyServiceSE2.GetReplacementKey(aKey: word; saving: boolean): string;
var
  returnKey: word;
  key: TKey;
begin
  result := '';
  {$ifdef Win64}
  if (FCurrentKBLayout <> ENGLISH_US_LAYOUT_NAME) then
  begin
    if (saving) then
      returnKey := ConvertToEnUS(aKey)
    else
      returnKey := ConvertToLayout(aKey);
    key := FindKeyConfig(returnKey);
    if key <> nil then
      result := key.SaveValue;
  end;
  {$endif}
end;

//Old Method, not used anymore....
//Checks for replacement key values (non US English drivers)
//function TKeyServiceSE2.GetReplacementKey(aKey: word): string;
//var
//  keyException: TKeyException;
//begin
//   result := '';
//   if (FCurrentKBLayout <> nil) then
//   begin
//     keyException := FCurrentKBLayout.KeyExceptions.GetReplacementKey(aKey);
//     if (keyException <> nil) then
//       result := keyException.ReplacementValue;
//   end;
//end;

//Finds and returns the key in list of configurable keys using virtual key
function TKeyServiceSE2.FindKeyConfig(iKey: word): TKey;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ConfigKeys.Count - 1 do
  begin
    if ConfigKeys[i] <> nil then
      if ConfigKeys[i].Key = iKey then
      begin
        Result := ConfigKeys[i];
        break;
      end;
  end;
end;

//Finds and returns the key in list of configurable keys using string key
function TKeyServiceSE2.FindKeyConfig(sKey: string): TKey;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ConfigKeys.Count - 1 do
  begin
    if ConfigKeys[i] <> nil then
      if AnsiLowerCase(ConfigKeys[i].SaveValue) = AnsiLowerCase(sKey) then
      begin
        Result := ConfigKeys[i];
        break;
      end;
  end;
end;

//Checks if key is numeric (ascii 48 to 57)
function TKeyServiceSE2.IsNumericKey(aKey: TKey): boolean;
begin
  Result := (aKey.Key >= VK_0) and (aKey.Key <= VK_9);
end;

//Checks if key is alphabetic (ascii lowercase 65 to 90 or uppercase 97 to 122)
function TKeyServiceSE2.IsAlphaKey(aKey: TKey): boolean;
begin
  Result := (aKey.Key >= VK_A) and (aKey.Key <= VK_Z);
end;

//Not used
//Returns true if shiftable key pressed
function TKeyServiceSE2.IsShiftableKey(aKey: TKey): boolean;
begin
  Result := ((aKey.Key >= VK_0) and (aKey.Key <= VK_9)) or
    ((aKey.Key >= VK_A) and (aKey.Key <= VK_Z)) or
    (aKey.Key in [VK_LCL_EQUAL, VK_LCL_MINUS, VK_LCL_SLASH,
    VK_LCL_BACKSLASH, VK_LCL_QUOTE, VK_LCL_TILDE, VK_LCL_SEMI_COMMA,
    VK_LCL_COMMA, VK_LCL_POINT, VK_LCL_CLOSE_BRACKET, VK_LCL_OPEN_BRACKET]);
end;

//Returns values of modifiers
function TKeyServiceSE2.GetModifierValues(aKey: TKey): string;
var
  i: integer;
begin
  Result := '';
  if aKey <> nil then
  begin
    if aKey.Modifiers <> '' then
    begin
      for i := 0 to Length(aKey.Modifiers) do
      begin
        if Pos(SHIFT_MOD, string(aKey.Modifiers[i])) <> 0 then
          Result := Result + FindKeyConfig(VK_SHIFT).Value + '+';
        if Pos(CTRL_MOD, string(aKey.Modifiers[i])) <> 0 then
          Result := Result + FindKeyConfig(VK_CONTROL).Value + '+';
        if Pos(ALT_MOD, string(aKey.Modifiers[i])) <> 0 then
          Result := Result + FindKeyConfig(VK_MENU).Value + '+';
        if Pos(WIN_MOD, string(aKey.Modifiers[i])) <> 0 then
          Result := Result + FindKeyConfig(VK_LWIN).Value + '+';
      end;
    end;
  end;
end;

//Takes a list of modifiers in string and fills a list of keys with the values
procedure TKeyServiceSE2.FillModifiersFromValues(aKeyList: TKeyList; sModifiers: string);
var
  i: integer;
begin
  if sModifiers <> '' then
  begin
    for i := 0 to Length(sModifiers) do
    begin
      if Pos(SHIFT_MOD, string(sModifiers[i])) <> 0 then
        aKeyList.Add(FindKeyConfig(VK_SHIFT).CopyKey);
      if Pos(CTRL_MOD, string(sModifiers[i])) <> 0 then
        aKeyList.Add(FindKeyConfig(VK_CONTROL).CopyKey);
      if Pos(ALT_MOD, string(sModifiers[i])) <> 0 then
        aKeyList.Add(FindKeyConfig(VK_MENU).CopyKey);
      if Pos(WIN_MOD, string(sModifiers[i])) <> 0 then
        aKeyList.Add(FindKeyConfig(VK_LWIN).CopyKey);
    end;
  end;
end;

//Returns text value of modifiers
function TKeyServiceSE2.GetModifierText: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FActiveModifiers.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ',';
    if FActiveModifiers.Items[i].Key = VK_SHIFT then
      Result := Result + SHIFT_MOD
    else if FActiveModifiers.Items[i].Key = VK_CONTROL then
      Result := Result + CTRL_MOD
    else if FActiveModifiers.Items[i].Key = VK_MENU then
      Result := Result + ALT_MOD
    else if (FActiveModifiers.Items[i].Key = VK_LWIN) or
      (FActiveModifiers.Items[i].Key = VK_RWIN) then
      Result := Result + WIN_MOD;
  end;
end;

//Backup keylist to a temp list
function TKeyServiceSE2.BackupKeyList: boolean;
begin
  result := false;
  if ActivePedal <> nil then
  begin
    FTempKeys.Assign(ActivePedal);
    result := true;
  end;
end;

//Restores keylist from temp list
function TKeyServiceSE2.RestoreKeyList: boolean;
begin
  result := false;
  if ActivePedal <> nil then
  begin
    ActivePedal.Assign(FTempKeys);
    result := true;
  end;
end;

//Returns current active pedal
function TKeyServiceSE2.GetActivePedal: TKeyList;
begin
  case CurrentPedal of
    pLeft: Result := LPKeys;
    pMiddle: Result := MPKeys;
    pRight: Result := RPKeys;
    pJack1: Result := J1Keys;
    pJack2: Result := J2Keys;
    pJack3: Result := J3Keys;
    pJack4: Result := J4Keys;
    else
      Result := nil;
  end;
end;

//Returns the output value for the edit field
function TKeyServiceSE2.GetOutputText(aPedal: TKeyList; var aPedalsPos: TPedalsPos): string;
var
  i: integer;
  aKey: TKey;
  idxMouseDblClick: integer;
  pedalCount: integer;
  initLength: integer;
  DiffPressRelText: string;
  keyText: string;
  keyTextAltGr: string;

  procedure AddPedalPos(iStart, iEnd: integer);
  begin
    SetLength(aPedalsPos, Length(aPedalsPos) + 1);
    aPedalsPos[Length(aPedalsPos) - 1].iStart := iStart;
    aPedalsPos[Length(aPedalsPos) - 1].iEnd := iEnd;
  end;

begin
  Result := '';
  idxMouseDblClick := -1;
  aPedalsPos := nil;

  if aPedal <> nil then
  begin
    pedalCount := aPedal.Count - 1;
    for i := 0 to pedalCount do
    begin
      aKey := aPedal.Items[i];
      initLength := LengthUTF8(Result);//Length(Result);
      DiffPressRelText := '';

      //If key combo has Different Press & Release, add different press and release text value
      if (aKey.DiffPressRel) and (aKey.Modifiers <> '') then
        DiffPressRelText := '+' + DIFF_PRESS_REL_TEXT;

      //Check for mouse double click
      if (aKey.Key = VK_MOUSE_LEFT) and ((i + 2) <= pedalCount) then
      begin
        //First key is left pedal, next is 125ms, and third is left pedal
        if (aPedal.Items[i + 1].Key = VK_125MS) and (aPedal.Items[i + 2].Key = VK_MOUSE_LEFT) then
        begin
          idxMouseDblClick := i;
          Result := Result + '{' + DOUBLECLICK_TEXT + '}';
          AddPedalPos(initLength, LengthUTF8(Result));
        end;
      end;

      //If not mouse double click or mouse double click done
      if (idxMouseDblClick = -1) or (i > (idxMouseDblClick + 2)) then
      begin
        idxMouseDblClick := -1;
        keyText := GetKeyText(aKey);
        keyTextAltGr := '';

        //Returns shifted value if shift + key pressed (and shifted value available)
        if (aKey.Modifiers = SHIFT_MOD) and (aKey.ShowShiftedValue) then
        begin
          if DiffPressRelText <> '' then
            Result := Result + '{' + keyText + DiffPressRelText + '}'
          else
            Result := Result + keyText;
        end
        //Returns modifier value (Ctrl, Shfit, Alt, Win) + key value
        else if (aKey.Modifiers <> '') and not (IsModifier(aKey.Key)) then
        begin
          {$ifdef Win64}
          if (IsAltGr(aKey)) then
            keyTextAltGr := GetKeyText(aKey, '', true);
          {$endif}

          //Shows AltGr value if keyboard layout supports it
          if (keyTextAltGr <> '') then
          begin
            if DiffPressRelText <> '' then
              Result := Result + '{' + keyTextAltGr + DiffPressRelText + '}'
            else
              Result := Result + keyTextAltGr;
          end
          else
          begin
            Result := Result + '{' + GetModifierValues(aKey) + keyText + DiffPressRelText + '}';
            AddPedalPos(initLength, LengthUTF8(Result));
          end;
        end
        //If has MultiValue and multikey, returns the multivalue
        else if (aKey.MultiValue <> '') and (aPedal.MultiKey) then
        begin
          Result := Result + GetKeyText(aKey, aKey.MultiValue);
        end
        //Returns value in square braquets for single key
        else
        begin
          if aPedal.MultiKey then
             Result := Result + '{' + keyText + '}'
          else
              Result := Result + '[' + keyText + ']';

          if not(IsAlphaKey(aKey)) and not(IsNumericKey(aKey)) then
            AddPedalPos(initLength, LengthUTF8(Result));
        end;
      end;
    end;
  end;
end;

//Returns key Text
function TKeyServiceSE2.GetKeyText(aKey: TKey; defaultValue: string; checkAltGr: boolean): string;
begin
  {$ifdef Win64}
    if (aKey.ConvertToUnicode) then
      result := KeyToUnicode(aKey.Key, (aKey.Modifiers = SHIFT_MOD) and (aKey.ShowShiftedValue), checkAltGr)
    else if (defaultValue <> '') then
      result := defaultValue
    else
      result := aKey.Value;
  {$endif}
  {$ifdef Darwin}
  if (aKey.Modifiers = SHIFT_MOD) and (aKey.ShowShiftedValue) then
    result := aKey.ShiftedValue
  else if (defaultValue <> '') then
    result := defaultValue
  else
    result := aKey.Value;
  {$endif}
end;

//Checks if AltGr pressed (Ctrl + Alt)
function TKeyServiceSE2.IsAltGr(aKey: TKey): boolean;
begin
  if (Pos(CTRL_MOD, aKey.Modifiers) <> 0) and
    (Pos(ALT_MOD, aKey.Modifiers) <> 0) and
    (Length(aKey.Modifiers) = 3) then  //Lenght = 3 (there's a comman in the value)
    result := true
  else
    result := false;
end;

//Loads pedals from file content
function TKeyServiceSE2.LoadKeysFromFile(pedal: TKeyList; pedalText: TPedalText): boolean;
begin
  Result := False;

  if (pedal <> nil) then
  begin
    pedal.Clear;
    pedal.MultiKey := pedalText.MultiKey;
    ConvertFromTextFileFmt(pedal, pedalText.PedalText);
    result := true;
  end;
end;

//Converts keys from pedals file to program keys
procedure TKeyServiceSE2.ConvertFromTextFileFmt(aKeyList: TKeyList; pedalText: string);
var
  aKey, newKey: TKey;
  sKey: string;
  keyState: TKeyState;
  keyStart, keyEnd: integer;
  lastKey: integer;
  previousKey: TKey;
  replacementKey: string;
begin
  lastKey := 0;
  if pedalText <> '' then
  begin
    //Validates first key if matches single-key or multi-key sequences
    if ((aKeyList.MultiKey) and (Copy(pedalText, 1, 1) = MK_START)) or
      ((not aKeyList.MultiKey) and (Copy(pedalText, 1, 1) = SK_START)) then
    begin
      ClearModifiers;
      While (pedalText <> '') do
      begin
        if aKeyList.MultiKey then
        begin
          keyStart := Pos(MK_START, pedalText);
          keyEnd := Pos(MK_END, pedalText);
          sKey := Copy(pedalText, keyStart + 1, keyEnd - 2);
          if copy(sKey, 1, 1) = '-' then  //Checks for keyup or keydown
            keyState := ksDown
          else if copy(sKey, 1, 1) = '+' then
            keyState := ksUp
          else
            keyState := ksNone;
          if keyState <> ksNone then
            sKey := Copy(sKey, 2, Length(sKey)); //removes - or +
          Delete(pedalText, 1, keyEnd); //removes key from string

          if sKey <> '' then
          begin
            aKey := FindKeyConfig(sKey);

            //Checks for replacement key values (US English)
            if aKey <> nil then
            begin
              replacementKey := GetReplacementKey(aKey.Key, false);
              if (replacementKey <> '') then
                aKey := FindKeyConfig(replacementKey);
            end;

            if aKey <> nil then
            begin
              if IsModifier(aKey.Key) then
              begin
                //Adds to list of active modifiers
                if (keyState = ksDown) then
                  AddModifier(aKey.key)
                else if (keyState = ksUp) then
                begin
                  //If last key is the same key, then adds modifier as single key down
                  if lastKey = aKey.Key then
                  begin
                    newKey := aKey.CopyKey;
                    aKeyList.Add(newKey);
                  end;
                  RemoveModifier(aKey.Key);
                end
                else
                begin
                  //v.0.9.1 - bug correction if no keyState (+ or -) and modifier add as single key
                  newKey := aKey.CopyKey;
                  aKeyList.Add(newKey);
                end;
              end
              else if (keyState in [ksNone, ksDown]) then //Only add key on key down or key none
              begin
                //Get the previous key
                if aKeyList.Count > 0 then
                  previousKey := aKeyList.Items[aKeyList.Count - 1];

                //If there are modifiers and we find Different Press and Release, we assign it to previous key
                if (ActiveModifiers.Count > 0) and (aKey.Key = VK_DIF_PRESS_REL) and (previousKey <> nil) then
                begin
                  previousKey.DiffPressRel := true;
                end
                else //Add the key
                begin
                  newKey := akey.CopyKey;
                  newKey.Modifiers := GetModifierText; //Gets modifier values
                  aKeyList.Add(newKey); //Adds key
                end;
              end;
              lastKey := aKey.Key;
            end;
          end
          else
            pedalText := '';
        end
        else
        begin
          aKey := FindKeyConfig(Copy(pedalText, 2, LastDelimiter(SK_END, pedalText) - 2));
          if aKey <> nil then
          begin
            newKey := aKey.CopyKey;
            aKeyList.Add(newKey);
          end;
          pedalText := '';
        end;
      end;
    end;
  end;
  ClearModifiers;
end;

//Converts keys from program to format for the text file
function TKeyServiceSE2.ConvertToTextFileFmt(aKeyList: TKeyList): TPedalText;
var
  i, j: integer;
  isShiftLast, isShiftNext: boolean;
  tempModifiers: TKeyList;
  tempText: string;
  saveValue: string;

  function GetSaveValue(aKey: TKey): string;
  var
    value: string;
    replacementKey: string;
  begin
      value := aKey.SaveValue;
      replacementKey := GetReplacementKey(aKey.Key, true);
      if (replacementKey <> '') then
         value := replacementKey;

      result := value;
  end;

begin
  Result.MultiKey := false;
  Result.PedalText := '';
  tempText := '';

  if aKeyList = nil then
    exit;

  Result.MultiKey := aKeyList.MultiKey;
  if aKeyList.MultiKey then
  begin
    tempModifiers := TKeyList.Create;
    for i := 0 to aKeyList.Count - 1 do
    begin
      isShiftLast := False;
      isShiftNext := False;
      tempModifiers.Clear;

      //Fills list of modifiers
      FillModifiersFromValues(tempModifiers, aKeyList[i].Modifiers);

      //Gets the save value
      saveValue := GetSaveValue(aKeyList[i]);

      //Checks if last key had shift modifier
      if (i >= 1) then
        if (aKeyList[i - 1].Modifiers = SHIFT_MOD) then
          isShiftLast := True;

      if (i < aKeyList.Count - 1) then
        if (aKeyList[i + 1].Modifiers = SHIFT_MOD) then
          isShiftNext := True;

      //Writes modifiers first with - (except for shift if previous key has shift too)
      if ((aKeyList[i].Modifiers <> SHIFT_MOD) or (not isShiftLast)) and (not IsModifier(aKeyList[i].Key)) then
      begin
        for j := 0 to tempModifiers.Count - 1 do
          tempText := tempText + '{-' + tempModifiers.Items[j].SaveValue + '}';
      end;

      //If different press & release with combination, write using the old method with up and down value
      if (aKeyList[i].DiffPressRel) then
      begin
        //Writes the key - and + if WriteDownUp is enabled, else writes only the value
        if aKeyList[i].WriteDownUp then
          tempText := tempText + '{-' + saveValue + '}' + DIFF_PRESS_REL_TEXT +
          '{+' + saveValue + '}'
        else
          tempText := tempText + '{' + saveValue + '}';
      end
      else  //Write the key value, only need the - / + for modifiers
        tempText := tempText + '{' + saveValue + '}';

      //Writes modifiers last with + (except for shift if next key has shift too)
      if ((aKeyList[i].Modifiers <> SHIFT_MOD) or (not isShiftNext)) and (not IsModifier(aKeyList[i].Key)) then
      begin
        for j := 0 to tempModifiers.Count - 1 do
          tempText := tempText + '{+' + tempModifiers.Items[j].SaveValue + '}';
      end;
    end;
    FreeAndNil(tempModifiers);
  end
  else if (aKeyList.Count > 0) then
  begin
    //Gets the save value
    saveValue := GetSaveValue(aKeyList.Items[0]);
    tempText := '[' + saveValue + ']';
  end;
  Result.PedalText := tempText;
end;

//Returns true if ActivePedal has been modified
function TKeyServiceSE2.ActivePedalModified: boolean;
begin
  result := false;
  if ActivePedal <> nil then
    result := not ActivePedal.Compare(TempKeys); //if keylists are not the same
end;

//Adds key to list of keys and returns output value
function TKeyServiceSE2.AddKey(iKey: word; modifiers: string): boolean;
var
  aKey: TKey;
  newKey: TKey;
begin
  Result := false;
  if ActivePedal <> nil then
  begin
    aKey := FindKeyConfig(iKey);
    if (aKey <> nil) and (ActivePedal <> nil) then
    begin
      newKey := aKey.CopyKey;

      //If multi key allows modifiers
      if ActivePedal.MultiKey then
        newKey.Modifiers := modifiers
      else //If single key, clears list of current keys
        ActivePedal.Clear;

      //Add keypress to active pedal
      ActivePedal.Add(newKey);

      //Returns complet output text
      Result := True;
    end;
  end;
end;

//Removes last key
function TKeyServiceSE2.RemoveLastKey: boolean;
begin
  Result := false;
  if ActivePedal <> nil then
  begin
    if ActivePedal.Count >= 1 then
    begin;
      ActivePedal.Remove(ActivePedal.Items[ActivePedal.Count -1]);
      result := true;
    end;
  end;
end;

//Adds modifier to list of active modifiers
procedure TKeyServiceSE2.AddModifier(key: word);
var
  i: integer;
  found: boolean;
  aKey: TKey;
  newKey: TKey;
begin
  found := False;
  aKey := FindKeyConfig(key);
  if aKey <> nil then
  begin
    for i := 0 to ActiveModifiers.Count - 1 do
    begin
      if ActiveModifiers[i] <> nil then
        if ActiveModifiers[i].Key = aKey.Key then
        begin
          found := True; //already exists
          break;
        end;
    end;

    if not (found) then
    begin
      newKey := aKey.CopyKey;
      ActiveModifiers.Add(newKey);
    end;
  end;
end;

//Removes modifier from list of active modifiers
procedure TKeyServiceSE2.RemoveModifier(key: word);
var
  i: integer;
  aKey: TKey;
begin
  aKey := FindKeyConfig(key);
  if aKey <> nil then
  begin
    for i := ActiveModifiers.Count - 1 downto 0 do
    begin
      if ActiveModifiers[i] <> nil then
        if ActiveModifiers[i].Key = aKey.Key then
          ActiveModifiers.Delete(i);
    end;
  end;
end;

//Clears all modifiers
procedure TKeyServiceSE2.ClearModifiers;
begin
  ActiveModifiers.Clear;
end;

//Checks if windows key is down
function TKeyServiceSE2.IsWinKeyDown: boolean;
var
  i:integer;
begin
  result := false;

  for i := 0 to ActiveModifiers.Count - 1 do
    if ActiveModifiers.Items[i].Key in [VK_LWIN, VK_RWIN] then
      result := true;
end;

end.
