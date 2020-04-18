//OLD FILE NOT USED ANYMORE

//CreoSource Inc. (info@creosource.com)
//Constants and utility fonctions
unit u_const_pedal;

{$mode objfpc}{$H+}
{$ifdef Darwin}
  {$modeswitch objectivec1}
{$endif}

interface

uses
  Classes, SysUtils, lcltype, FileUtil, Controls, LazUTF8 , Graphics, Buttons
  {$ifdef Win32}, Windows, jwawinuser{$endif}
  {$ifdef Linux}, LCLIntf{$endif}
  {$ifdef Darwin},LCLIntf, CocoaUtils, CocoaAll{$endif};

type
  TPedal = (pNone, pLeft, pMiddle, pRight, pJack1, pJack2, pJack3, pJack4);

  TKeyState = (ksNone, ksDown, ksUp);

  TSaveState = (ssNone, ssModifed);

  TModifiers = (moShift, moAlt, moCtrl, moWin);

  TMouseEvent = (meNone, meLeftClick, meMiddleClick, meRightClick);

  TKeyMode = (kmSingle, kmMulti);

  TTransitionState = (tsPressed, tsReleased); //KeySate Down or Up
  TExtendedState = (esNormal, esExtended);
  //Extended key, Normal or Extended (ex: Alt or Left Alt)
  PKeystrokeData = ^TKeystrokeData;

  TKeystrokeData = record
    VirtualKey: WPARAM;
    KeyStroke: LPARAM;
    KeyState: TKeyboardState;
  end;

  TLogFile = record
    FileName: string;
    FileDate: TDateTime;
  end;

  TLogFiles = array of TLogFile;

  TPedalText = record
    PedalText: string;
    MultiKey: boolean;
  end;

  TPedalPos = record
    iStart: integer;
    iEnd: integer;
  end;

  TPedalsPos = array of TPedalPos;

  TCustomButton = record
    Caption: string;
    Width: integer;
    OnClick: TNotifyEvent;
    Kind: TBitBtnKind;
  end;
  TCustomButtons = array of TCustomButton;

var
  GApplicationName: string; //Name of application
  GApplicationTitle: string; //Title of application
  GApplicationPath: string; //Application start path
  GPedalsFile: string; //Location of Pedals.txt file
  GPedalsFilePath: string; //Location of Pedals.txt file folder
  GDemoMode: boolean; //Demo Mode
  GDesktopMode: boolean; //Desktop Mode
  GVersionFile: string; //Location of the version.txt file
  KINESIS_DARK_GRAY_FS: TColor; //Kinesis dark gray color for FS app

function MapShiftToVirutalKey(sShift: TShiftStateEnum): word;
function IsModifier(Key: word): boolean;
//function GetCharFromVirtualKey(Key: word): string;
procedure SortArry(var aLogFiles: TLogFiles);
procedure SetFont(aObject : TWinControl; fontName: string);
//function GetCharFromVKey(vkey: Word): string;
//function VKeytoWideString (Key : Word) : WideString;
function LengthUTF8(value: string): integer;
function KeyToUnicode(Key: Word; Shift: boolean = false; AltGr: boolean = false) : UnicodeString;
function ConvertToEnUS(Key: Word): integer;
function ConvertToLayout(Key: Word): integer;
function GetCurrentKeyoardLayout: string;
function IsDarkTheme:boolean;

const
  VK_NUMPADENTER = 10000; //User-defined keypad enter
  VK_MOUSE_LEFT = 10001; //User-defined left mouse
  VK_MOUSE_MIDDLE = 10002; //User-defined middle mouse
  VK_MOUSE_RIGHT = 10003; //User-defined right mouse
  VK_SPEED1 = 10005; //User-defined slow output (speed1)
  VK_SPEED3 = 10006; //User-defined default output (speed3)
  VK_125MS = 10007; //User-defined 125ms delay
  VK_500MS = 10008; //User-defined 500ms delay
  VK_CALC = 10009; //User-defined calculator
  VK_SHUTDOWN = 10010; //User-defined shutdown
  VK_DIF_PRESS_REL = 10011; //User-defined different press and release
  VK_SPEED5 = 10012; //User-defined fast output (speed5)

  TAG_MULTI_KEY = 1; //Tag for menu items that can only be used in multi keys
  TAG_SINGLE_KEY = 2; //Tag for menu items that can only be used in single keys
  TAG_BOTH_KEY = 3; //Tag for menu items that can be used in multi keys and single keys
  LOG_FILES_TO_KEEP = 100; //Number of log files to keep
  DOUBLECLICK_TEXT = 'lmouse-dblclick'; //text for left mouse double click

  //List of MenuItem names
  miLeftMouse = 'miLeftMouse';
  miMiddleMouse = 'miMiddleMouse';
  miRightMouse = 'miRightMouse';
  miMouseDblClick = 'miMouseDblClick';
  miCut = 'miCut';
  miCopy = 'miCopy';
  miPaste = 'miPaste';
  miSelectAll = 'miSelectAll';
  miUndo = 'miUndo';
  miWebFwd = 'miWebFwd';
  miWebBack = 'miWebBack';
  miAltTab = 'miAltTab';
  miCtrlAltDel = 'miCtrlAltDel';
  miWinKey = 'miWinKey';
  miCmdTab = 'miCmdTab';
  miSnipClip = 'miSnipClip';
  miSnipFile = 'miSnipFile';
  miForceQuit = 'miForceQuit';
  miVolMute = 'miVolMute';
  miVolMin = 'miVolMin';
  miVolPlus = 'miVolPlus';
  miPlay = 'miPlay';
  miPrev = 'miPrev';
  miNext = 'miNext';
  miCalc = 'miCalc';
  miSpeed1 = 'miSpeed1';
  miSpeed3 = 'miSpeed3';
  miSpeed5 = 'miSpeed5';
  mi125 = 'mi125';
  mi500 = 'mi500';
  miDifPressRel = 'miDifPressRel';
  TEXT_SEPARATOR = '-'; //For popupmenu separator

  //Modifier short values
  SHIFT_MOD = 'S';
  CTRL_MOD = 'C';
  ALT_MOD = 'A';
  WIN_MOD = 'W';

  //Values for keys from text file
  LEFT_PEDAL_TEXT = 'lpedal';
  MIDDLE_PEDAL_TEXT = 'mpedal';
  RIGHT_PEDAL_TEXT = 'rpedal';
  JACK1_PEDAL_TEXT = 'jack1';
  JACK2_PEDAL_TEXT = 'jack2';
  JACK3_PEDAL_TEXT = 'jack3';
  JACK4_PEDAL_TEXT = 'jack4';

  LEFT_PEDAL_TEXT_SINGLE = '[lpedal]';
  MIDDLE_PEDAL_TEXT_SINGLE = '[mpedal]';
  RIGHT_PEDAL_TEXT_SINGLE = '[rpedal]';
  JACK1_PEDAL_TEXT_SINGLE = '[jack1]';
  JACK2_PEDAL_TEXT_SINGLE = '[jack2]';
  JACK3_PEDAL_TEXT_SINGLE = '[jack3]';
  JACK4_PEDAL_TEXT_SINGLE = '[jack4]';

  LEFT_PEDAL_TEXT_MULTI = '{lpedal}';
  MIDDLE_PEDAL_TEXT_MULTI = '{mpedal}';
  RIGHT_PEDAL_TEXT_MULTI = '{rpedal}';
  JACK1_PEDAL_TEXT_MULTI = '{jack1}';
  JACK2_PEDAL_TEXT_MULTI = '{jack2}';
  JACK3_PEDAL_TEXT_MULTI = '{jack3}';
  JACK4_PEDAL_TEXT_MULTI = '{jack4}';

  //Constants for key start and end
  SK_START = '[';
  SK_END = ']';
  MK_START = '{';
  MK_END = '}';

  //Various constants
  DIFF_PRESS_REL_TEXT = '{ }';


  //Keyboard layouts
  ENGLISH_US_LAYOUT_NAME = '00000409';
  //ENGLISH_US_VAL = 67699721;
  ENGLISH_US_LAYOUT_VALUE = 1033;

  DEFAULT_DIAG_HEIGHT_PEDAL = 175;

  PEDAL_TROUBLESHOOT = 'https://kinesis-ergo.com/support/savant-elite2/';

implementation

//Maps a Shift state to a virtual key
function MapShiftToVirutalKey(sShift: TShiftStateEnum): word;
begin
  if sShift = ssShift then
    Result := LCLType.VK_SHIFT
  else if sShift = ssCtrl then
    Result := LCLType.VK_CONTROL
  else if sShift = ssAlt then
    Result := LCLType.VK_MENU
  else if sShift = ssMeta then
    Result := LCLType.VK_LWIN
  else
    Result := 0;
end;

//Returns true if modifier key is pressed (left or right alt, shift, windows, ctrl)
function IsModifier(Key: word): boolean;
begin
  Result := False;

  if (Key = VK_MENU) or (Key = VK_LMENU) or (Key = VK_RMENU) or
    (Key = VK_SHIFT) or (Key = VK_LSHIFT) or (Key = VK_RSHIFT) or
    (Key = VK_CONTROL) or (Key = VK_LCONTROL) or (Key = VK_RCONTROL) or
    (Key = VK_LWIN) or (Key = VK_RWIN) then
    Result := True;
end;

//Not used...
//When using different keyboard than US English, use this function to get shifted actions in the layout
//doesn't work well with é and some french characters
//function GetCharFromVirtualKey(Key: word): string;
//var
//  keyboardState: TKeyboardState;
//  asciiResult: integer;
//begin
//  keyboardState := [''];
//  GetKeyboardState(keyboardState);
//  SetLength(Result, 2);
//  asciiResult := ToAscii(Key, MapVirtualKey(Key, 0), keyboardState, @Result[1], 0);
//  case asciiResult of
//    0: Result := '';
//    1: SetLength(Result, 1);
//    2: ;
//    else
//      Result := '';
//  end;
//end;

//Sorts an array of log files oldest files first
procedure SortArry(var aLogFiles: TLogFiles);
var
  tempLogFile: TLogFile;
  Current, Next, Records: integer;
begin
  Records := Length(aLogFiles);
  tempLogFile := aLogFiles[0];
  for Current := 0 to Records - 1 do
  begin
    tempLogFile := aLogFiles[Current];
    for Next := Current + 1 to Records - 1 do
    begin
      if (aLogFiles[Next].FileDate < aLogFiles[Current].FileDate) then
      begin
        aLogFiles[Current] := aLogFiles[Next];
        aLogFiles[Next] := tempLogFile;
      end;
    end;
  end;
end;

procedure SetFont(aObject: TWinControl; fontName: string);
var
  i:integer;
begin
  aObject.Font.Name := fontName;
  for i := 0 to aObject.ComponentCount - 1 do
  begin
    if aObject.Components[i].InheritsFrom(TWinControl) then
       TWinControl(aObject.Components[i]).Font.Name := fontName;
    if aObject.Components[i].InheritsFrom(TGraphicControl) then
       TGraphicControl(aObject.Components[i]).Font.Name := fontName;
  end;
end;

//Decodes UTF8 string to get real length (UTF8 caracters are 2 bytes in length)
function LengthUTF8(value: string): integer;
begin
  result := Length(UTF8Decode(value));
end;

//Converts key to unicode value
function KeyToUnicode(Key: Word; Shift: boolean = false; AltGr: boolean = false): UnicodeString;
var
   keyboardState: array[0..256] of Byte;
   UnicodeKeys : array[0..256] of WideChar;
   i:integer;
begin
  //Reset arrays
  for i := 0 to 256 do
      keyboardState[i] := 0;

  for i := 0 to 256 do
      UnicodeKeys[i] := #0;

  //Set Shift pressed
  if Shift then
    keyboardState[VK_SHIFT] := 128;

  //Set AltGr or Alt+Ctrl pressed
  if AltGr then
  begin
    keyboardState[VK_CONTROL] := 128;
    keyboardState[VK_MENU] := 128;
  end;

  //Call Windows ToUnicode function
  //Must call twice to eliminate Dead-Keys
  {$ifdef Win32}
  ToUnicode(Key, 0, keyboardState, UnicodeKeys, 256, 0);
  ToUnicode(Key, 0, keyboardState, UnicodeKeys, 256, 0);
  {$endif}
  //Return lower case char converted to utf-8
  try
    if (UnicodeKeys[0] = #0) then
       result := ''
    else
       result := LazUTF8.SysToUTF8(UnicodeKeys[0]);
  except
    result := ''
  end;
end;

//Converts a key to English US equivalent
function ConvertToEnUS(Key: Word): integer;
var
   scanCode: word;
begin
  //Gets currenty keyboard scan Code
  {$ifdef Win32}
  scanCode := MapVirtualKey(Key, 0);

  //Converts to English US virtual code
  result := MapVirtualKeyEx(scanCode, 1, ENGLISH_US_LAYOUT_VALUE);
  {$endif}
end;

//Converts an English US key to current keyboard layout equivalent
function ConvertToLayout(Key: Word): integer;
var
   scanCode: word;
begin
  //Gets English US Scan Code
  {$ifdef Win32}
  scanCode := MapVirtualKeyEx(Key, 0, ENGLISH_US_LAYOUT_VALUE);

  //Converts to current keyboard virtual code
  result := MapVirtualKey(scanCode, 1);
  {$endif}
end;

//Return KeyboardLayout for the user
function GetCurrentKeyoardLayout: string;
var
  {$ifdef Win32}LayoutName: array [0 .. KL_NAMELENGTH + 1] of Char; {$endif}
  layout: string;
begin
  layout := ENGLISH_US_LAYOUT_NAME;
  {$ifdef Win32}
  try
    if (GetKeyboardLayoutName(@LayoutName)) then
      layout := StrPas(LayoutName);
  except
  end;
  {$endif}
  result := layout;
end;

// Retrieve key's string value from user preferences. Result is encoded using NSStrToStr's default encoding.
function GetPrefString(const KeyName : string) : string;
begin
  Result := '';
  {$ifdef Darwin}
  Result := NSStringToString(NSUserDefaults.standardUserDefaults.stringForKey(NSStr(@KeyName[1])));
  {$endif}
end;

// IsDarkTheme: Detects if the Dark Theme (true) has been enabled or not (false)
function IsDarkTheme:boolean;
begin
  Result := false;
  {$ifdef Darwin}
  Result := pos('DARK',UpperCase(GetPrefString('AppleInterfaceStyle')))>0;
  {$endif}
end;

//function GetCharFromVKey(vkey: Word): string;
//{$ifdef Win32}
//var
//  keystate: TKeyboardState;
//  retcode: Integer;
//{$endif}
//begin
//  {$ifdef Win32}
//  Win32Check(GetKeyboardState(keystate));
//  SetLength(Result, 2);
//  retcode := ToAscii(vkey,
//    MapVirtualKey(vkey, 0),
//    keystate, @Result[1],
//    0);
//  case retcode of
//    0: Result := ''; // no character
//    1: SetLength(Result, 1);
//    2:;
//    else
//      Result := ''; // retcode < 0 indicates a dead key
//  end;
//  {$else}
//    Result := '';
//  {$endif}
//end;

//function VKeytoWideString (Key : Word) : WideString;
//{$ifdef Win32}
//var
//  WBuff         : array [0..255] of WideChar;
//  KeyboardState : TKeyboardState;
//  UResult       : Integer;
//  i: integer;
//{$endif}
//begin
//  Result := '';
//  {$ifdef Win32}
//  GetKeyBoardState(KeyboardState);
//  ZeroMemory(@WBuff[0], SizeOf(WBuff));
//  UResult := ToUnicode(key, 0, KeyboardState, WBuff, Length(WBuff), 0);
//  if UResult > 0 then
//    SetString(Result, WBuff, UResult)
//  else if UResult = -1 then
//    Result := WBuff;
//  {$endif}
//end;

initialization
  KINESIS_DARK_GRAY_FS := RGB(38, 38, 38);
  GApplicationTitle := 'Savant Elite2 SmartSet App';
  GDemoMode := false;
  GDesktopMode := false;
  //Windows
  {$ifdef Win32}
  GApplicationName := 'Savant Elite2 SmartSet App (Win)';
  GApplicationPath := IncludeTrailingBackslash(ExtractFileDir(ParamStr(0)));
  {$endif}

  //MacOS
  {$ifdef Darwin}
  GApplicationName := 'Savant Elite2 SmartSet App (Mac)';

  //Try to get the executable path from ParamStr(0)
  GApplicationPath := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  if GApplicationPath <> '' then
  begin
    //Go back 3 folders to get application bundle path
    GApplicationPath := Copy(GApplicationPath, 0, LastDelimiter('/', GApplicationPath) - 1);
    GApplicationPath := Copy(GApplicationPath, 0, LastDelimiter('/', GApplicationPath) - 1);
    GApplicationPath := Copy(GApplicationPath, 0, LastDelimiter('/', GApplicationPath) - 1);
    GApplicationPath := IncludeTrailingBackslash(Copy(GApplicationPath, 0, LastDelimiter('/', GApplicationPath) - 1));
  end;
  {$endif}

  //Warning ParamStr(0) might not work correctly on Mac OS
  GPedalsFilePath := IncludeTrailingBackslash(GApplicationPath + 'active');
  GPedalsFile := GPedalsFilePath + 'pedals.txt';
  GVersionFile := GPedalsFilePath + 'version.txt';

end.
