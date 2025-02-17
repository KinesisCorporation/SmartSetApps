//CreoSource Inc. (info@creosource.com)
//Constants and utility fonctions
unit u_const;

{$mode objfpc}{$H+}
{$ifdef Darwin}
  {$modeswitch objectivec1}
{$endif}


interface

uses
  {$ifdef Win64}Windows, shlobj, w32internetaccess, {$endif}
  LCLIntf,
  {$ifdef Darwin}ns_url_request, CocoaUtils, CocoaAll, {$endif}
  lcltype, Classes, SysUtils, FileUtil, Controls, Graphics, character, LazUTF8, U_Keys, Buttons,
  internetaccess, LazFileUtils, u_kinesis_device, registry, ExtCtrls, u_led_ind;

type
  TPedal = (pNone, pLeft, pMiddle, pRight, pJack1, pJack2, pJack3, pJack4);

  TSaveState = (ssNone, ssModified);

  TMacroState = (mstNone, mstEdit, mstEditTrigger, mstNew);

  TModifiers = (moShift, moAlt, moCtrl, moWin);

  TMouseEvent = (meNone, meLeftClick, meMiddleClick, meRightClick);

  TKeyMode = (kmSingle, kmMulti);

  TMsgDlgTypeApp  = (mtWarning, mtError, mtInformation, mtConfirmation,
                    mtCustom, mtFSEdge, mtFSPro);

  TLedMode = (lmNone, lmFreestyle, lmMonochrome, lmBreathe, lmSpectrum,
              lmWave, lmFrozenWave, lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound,
              lmLoop, lmPulse, lmRain, lmPitchBlack, lmDisabled);

  TZoneType = (ztAll, ztNumber, ztWASD, ztFunction, ztGame, ztArrow, ztLeftModule, ztRightModule,
               ztHyperspace, ztHome, ztModifiers, ztMedia, ztNavigation);

  TProfileMode = (pmNone, pmSelect, pmSaveAs);

  TCusWinState = (cwNormal, cwMaximized);

  TFormPosition = (fpMiddle, fpTopLeft, fpTopRight, fpBotLeft, fpBotRight);

  TMenuActionType = (maNone, maMacro, maHyperspace, maMultimedia, maMouseClicks,
                    maFuncKeys, maFnAccess, maFullKeypad, maKeypadActions,
                    maAltLayouts, maMacModifiers, maPreHotkeys,
                    maTapHold, maBacklight, maMultimodifiers, maSpecialActions,
                    maDisable, maFreestyle, maMonochrome, maBreathe,
                    maWave, maSpectrum, maReactive, maRipple, maFireball,
                    maStarlight, maRebound, maLoop, maPulse, maRain,
                    maDisableLed, maFreestyleEdge, maMonochromeEdge, maBreatheEdge,
                    maWaveEdge, maFrozenWaveEdge, maSpectrumEdge, maLoopEdge, maReboundEdge,
                    maPulseEdge, maDisableEdge, maLetters, maNumbers, maNavKeys, maPunctuation,
                    maModifiers, maQuickThumbKeys);

  TTransitionState = (tsPressed, tsReleased); //KeySate Down or Up
  TExtendedState = (esNormal, esExtended);
  //Extended key, Normal or Extended (ex: Alt or Left Alt)
  PKeystrokeData = ^TKeystrokeData;
  TRestoreType = (rtAll, rtKey, rtMacro);

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

  TKeyPos = record
    iStart: integer;
    iEnd: integer;
  end;

  TStateSettings = record
    StartupFile: string;
    StartupFileNumber: integer;
    LayoutFile: string;
    LedFile: string;
    PitchBlackMode: boolean;
    OffMode: boolean;
    ThumbMode: string;
    KeyClickTone: boolean;
    ToggleTone: boolean;
    MacroDisable: boolean;
    MacroSpeed: integer;
    StatusPlaySpeed: integer;
    PowerUser: boolean;
    VDriveStartup: boolean;
    GameMode: boolean;
    ProgramLock: boolean;
    LedMode: string;
    Country: string;
  end;

  TAppSettings = record
    AppIntroMsg: boolean;
    SaveAsMsg: boolean;
    SaveMsg: boolean;
    SaveMsgLighting: boolean;
    SaveSettingsMsg: boolean;
    MultiplayMsg: boolean;
    SpeedMsg: boolean;
    CopyMacroMsg: boolean;
    ResetKeyMsg: boolean;
    WindowsComboMsg: boolean;
    UpDownKeystrokeMsg: boolean;
    AppCheckFirmMsg: boolean;
    CustColor1: TColor;
    CustColor2: TColor;
    CustColor3: TColor;
    CustColor4: TColor;
    CustColor5: TColor;
    CustColor6: TColor;
    CustColor7: TColor;
    CustColor8: TColor;
    CustColor9: TColor;
    CustColor10: TColor;
    CustColor11: TColor;
    CustColor12: TColor;
  end;

  TCustomButton = record
    Caption: string;
    Width: integer;
    OnClick: TNotifyEvent;
    Kind: TBitBtnKind;
  end;

  TFirmwareInfo = record
    ModelName: string;
    VersionKBD: string;
    MajorKBD: integer;
    MinorKBD: integer;
    RevisionKBD: integer;
    VersionLED: string;
    MajorLED: integer;
    MinorLED: integer;
    RevisionLED: integer;
  end;
//
//  TInvalidLine = record
//    LineText: string;
//    LayerIdx: integer;
//  end;

  TCustomButtons = array of TCustomButton;
  //TInvalidLines = array of TInvalidLine;

  TKeysPos = array of TKeyPos;

  TPedalPos = record
    iStart: integer;
    iEnd: integer;
  end;
  TPedalsPos = array of TPedalPos;

{$ifdef Win64}
type
    LPDWORD = ^DWORD;
function AddFontMemResourceEx(pbFont: Pointer; cbFont: DWORD; pdv: Pointer; pcFonts: LPDWORD): LongWord; stdcall;
  external 'gdi32.dll' Name 'AddFontMemResourceEx';
function RemoveFontMemResourceEx(fh: LongWord): LongBool; stdcall;
  external 'gdi32.dll' Name 'RemoveFontMemResourceEx';
{$endif}

var
  GActiveDevice: TDevice; //Active Device
  GApplication: integer; //Id of application
  GApplicationName: string; //Name of application
  GApplicationTitle: string; //Title of application
  GApplicationPath: string; //Application start path
  GMasterAppId: integer; //Id of master application
  GExecutablePath: string; //Executable path
  //GPedalsFile: string; //Location of Pedals.txt file
  //GPedalsFilePath: string; //Location of Pedals.txt file folder
  GLayoutFilePath: string; //Location of layout file folder (FS Edge)
  GLedFilePath: string; //Location of led file folder (FS Edge)
  GSettingsFilePath: string; //Location of settings files (FS Edge)
  //GFirmwareFilePath: string; //Location of settings files (FS Edge)
  //GVersionFile: string; //Location of the version file
  //GStateFile: string; //Location of state.txt file
  GAppSettingsFile: string; //Location of appsettings.txt file
  GDebugMode: boolean; //Debug Mode On or Off
  GDebugFirmware: boolean; //Debug Firmware On or Off
  GDevMode: boolean; //Dev Mode On or Off
  GDesktopMode: boolean; //Desktop Mode
  GDemoMode: boolean; //Demo Mode
  GShowAllNotifs: boolean; //Show all notifications
  GHideAllNotifs: boolean; //Hide all notifications
  KINESIS_BLUE: TColor; //Kinesis blue color
  KINESIS_BLUE_EDGE: TColor; //Kinesis blue color for FS app
  KINESIS_ORANGE: TColor; //Kinesis orange color
  KINESIS_LIGHT_GRAY_FS: TColor; //Kinesis light gray color for FS app
  KINESIS_DARK_GRAY_FS: TColor; //Kinesis dark gray color for FS app
  KINESIS_GRAY_EDGE2: TColor; //Kinesis gray color for Edge v2 app
  KINESIS_DARK_GRAY_RGB: TColor; //Kinesis dark gray color for RGB app
  KINESIS_MED_GRAY_RGB: TColor; //Kinesis medium gray color for RGB app
  KINESIS_FONT_COLOR_RGB: TColor; //Kinesis font color for RGB app
  KINESIS_LIGHT_GRAY_ADV360: TColor;
  KINESIS_LIGHTER_GRAY_ADV360: TColor;
  KINESIS_DARK_GRAY_ADV360: TColor;
  KINESIS_GREEN_OFFICE: TColor;
  KINESIS_GRAY_BACKCOLOR: TColor;
  KINESIS_BUTTON_ADV360: TColor;

function MapShiftToVirutalKey(sShift: TShiftStateEnum): word;
function IsModifier(Key: word): boolean;
//function GetCharFromVirtualKey(Key: word): string;
procedure SortArry(var aLogFiles: TLogFiles);
procedure SetFont(aObject : TWinControl; fontName: string);
procedure SetFontColor(aObject: TWinControl; fontColor: TColor);
//function GetCharFromVKey(vkey: Word): string;
//function VKeytoWideString (Key : Word) : WideString;
function LengthUTF8(value: string): integer;
function KeyToUnicode(Key: Word; Shift: boolean = false; AltGr: boolean = false) : UnicodeString;
function ConvertToEnUS(Key: Word): integer;
function ConvertToLayout(Key: Word): integer;
function GetCurrentKeyoardLayout: string;
function GetConfigKeys: TKeyList;
function CanUseUnicode: boolean;
function ConvertToInt(value: string; invalidValue: integer = -1): integer;
function IsLeftShift(key: word): boolean;
function IsLeftCtrl(key: word): boolean;
function IsLeftAlt(key: word): boolean;
function IsLeftWin(key: word): boolean;
function IsRightShift(key: word): boolean;
function IsRightCtrl(key: word): boolean;
function IsRightAlt(key: word): boolean;
function GetIndexOfString(value: string; fileContent: TStringList): integer;
function GetPosOfNthString(value: string; search: string; nth: integer): integer;
function GetIndexOfNumber(value: string): integer;
function IsPreWin8: boolean;
function GetAvailableDrives: TStringList;
function GetVolumeLabel(DriveChar: Char): string;
function SetBaseDirectory(init: boolean = false): boolean;
function GetHTMLColor(color: TColor): string;
function GetColorHTML(html: string): TColor;
function RGBColorToString(color: Tcolor; setNoneAsBlack: boolean = false): string;
function RGBStringToColor(var sRGB: string; defaultColor: TColor = clNone): Tcolor;
function LedSpeedToString(LedSpeed: integer): string;
function LedDirectionToString(LedDirection: integer): string;
procedure ResetAppPaths;
function GetKeyModifierText(iKey: integer): string;
function ReadURLGet(url:string):string;
function GetDesktopDirectory: string;
procedure GetVersionNumbers(versionNumber: string; var major: integer; var minor: integer; var revision: integer);
function IsVersionEqual(sourceMajor, sourceMinor, sourceRevision: integer; destMajor, destMinor, destRevision: integer): boolean;
function IsVersionBiggerOrEqual(sourceMajor, sourceMinor, sourceRevision: integer; destMajor, destMinor, destRevision: integer): boolean;
function IsVersionSmaller(sourceMajor, sourceMinor, sourceRevision: integer; destMajor, destMinor, destRevision: integer): boolean;
function GetPrefString(const KeyName : string) : string;
function IsDarkTheme:boolean;
function GetDeviceInformation(aDevice: TDevice): boolean;
function LoadFontFromRes(FontName: string):THandle;
function SaveToRegistry(keyName: string; value: string): boolean;
function ReadFromRegistry(keyName: string): string;
function ShowNotification(hideNotif: boolean): boolean;
function IsGen2Device(device: integer): boolean;
function CheckMultimodifier(value: string): boolean;
function GetCurrentKeyMac(key: word): word;

const
  //START OF VIRTUAL KEY OPTIONS
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
  VK_PROGRAM = 10013; //User-defined Program button (keyboard)
  VK_KEYPAD = 10014; //User-defined Keypad button (keyboard)
  VK_KEYPAD_SHIFT = 10016; //User-defined Keypad Shift button (keyboard)
  VK_FUNCTION = 10017; //User-defined Function/Fn button (keyboard)
  //NOT USED, VK_BRIGHTNESS = 10018; //User-defined Brightness button (keyboard)
  VK_NULL = 10019; //User-defined Null button (keyboard)
  VK_FN_TOGGLE = 10020; //User-defined Fn Toggle button (FS Edge)
  VK_FN_SHIFT = 10021; //User-defined Fn Shift button (FS Edge)
  VK_LED = 10022; //User-defined Led button (FS Edge)
  VK_MIC_MUTE = 10023; //User-defined Led button (FS Edge)
  VK_HK1 = 10024; //User-defined HK button (FS Edge)
  VK_HK2 = 10025; //User-defined HK button (FS Edge)
  VK_HK3 = 10026; //User-defined HK button (FS Edge)
  VK_HK4 = 10027; //User-defined HK button (FS Edge)
  VK_HK5 = 10028; //User-defined HK button (FS Edge)
  VK_HK6 = 10029; //User-defined HK button (FS Edge)
  VK_HK7 = 10030; //User-defined HK button (FS Edge)
  VK_HK8 = 10031; //User-defined HK button (FS Edge)
  VK_HK9 = 10032; //User-defined HK button (FS Edge)
  VK_HK10 = 10033; //User-defined HK button (FS Edge)
  VK_LSPACE = 10034; //User-defined Left Space (FS Edge)
  VK_RSPACE = 10035; //User-defined Left Space (FS Edge)
  VK_MOUSE_BTN4 = 10036; //User-defined mouse button 4
  VK_MOUSE_BTN5 = 10037; //User-defined mouse button 5
  VK_LCMD_MAC = 10038; //Left Cmd button (FS Edge / Mac Only)
  VK_LPEDAL = 10039; //Left pedal Adv2
  VK_MPEDAL = 10040; //Middle pedal Adv2
  VK_RPEDAL = 10041; //Right pedal Adv2
  VK_KEYPAD_TOGGLE = 10042; //User-defined Keypad Toggle button (keyboard)
  //FOR ADVANTAGE 2
  VK_KP_MENU = 10043;
  VK_KP_PLAY = 10044;
  VK_KP_PREV = 10045;
  VK_KP_NEXT = 10046;
  VK_KP_CALC = 10047;
  VK_KP_KPSHIFT = 10048;
  VK_KP_MUTE = 10049;
  VK_KP_VOLDOWN = 10050;
  VK_KP_VOLUP = 10051;
  VK_KP_NUMLCK = 10052;
  VK_KP_EQUAL = 10053;
  VK_KP_DIVIDE = 10054;
  VK_KP_MULT = 10055;
  VK_KP_0 = 10056;
  VK_KP_1 = 10057;
  VK_KP_2 = 10058;
  VK_KP_3 = 10059;
  VK_KP_4 = 10060;
  VK_KP_5 = 10061;
  VK_KP_6 = 10062;
  VK_KP_7 = 10063;
  VK_KP_8 = 10064;
  VK_KP_9 = 10065;
  VK_KP_MIN = 10066;
  VK_KP_PLUS = 10067;
  VK_KP_ENTER1 = 10068;
  VK_KP_ENTER2 = 10069;
  VK_KP_PERI = 10070;
  //FOR ADVANTAGE 2
  VK_HK0 = 10071; //User-defined HK button (FS Edge v2)
  VK_DVORAK = 10072; //User-defined Dvorak option (FS Edge v2)
  VK_COLEMAK = 10073;  //User-defined Colemak option (FS Edge v2)
  VK_NUMERIC_RIGHT = 10074; //User-defined Numeric Right Side option (FS Edge v2)
  VK_NUMERIC_LEFT = 10075; //User-defined Numeric Left Side option (FS Edge v2)
  VK_CUT = 10076;
  VK_COPY = 10077;
  VK_PASTE = 10078;
  VK_SELECTALL = 10079;
  VK_UNDO = 10080;
  VK_REDO = 10081;
  VK_DESKTOP = 10082;
  VK_LASTAPP = 10083;
  VK_CTRLALTDEL = 10084;
  VK_RAND_DELAY = 10087; //Random timing delay
  VK_MIN_DELAY = 10086; //Minimum timing delay (1)
  VK_MAX_DELAY = 11085; //Maximum timing delay (999)
  VK_MOUSE_DBL_125 = 11086; //Mouse double-click 125 ms
  VK_FS2_HOTKEYS = 11087; //FreeStyle2 Hotkeys
  VK_FSPRO_HOTKEYS = 11088; //FreeStyle Pro Hotkeys
  VK_WORKMAN = 11089; //Workman Hotkeys
  VK_HYPER = 11090; //Hyper Hotkey
  VK_MEH = 11091; //Hyper Hotkey
  VK_MAC_MODIFIERS = 11092; //Mac Modifiers Hotkeys
  VK_MSPACE = 11093; //User-defined Middle Space (TKO)
  VK_TYPING_1 = 11094; //User-defined Hyperspace Configs
  VK_TYPING_2 = 11095; //User-defined Hyperspace Configs
  VK_TYPING_3 = 11096; //User-defined Hyperspace Configs
  VK_CODING_1 = 11097; //User-defined Hyperspace Configs
  VK_CODING_2 = 11098; //User-defined Hyperspace Configs
  VK_CODING_3 = 11099; //User-defined Hyperspace Configs
  VK_CODING_4 = 11100; //User-defined Hyperspace Configs
  VK_CODING_5 = 11101; //User-defined Hyperspace Configs
  VK_OVERWATCH1 = 11102; //User-defined Hyperspace Configs
  VK_FORTNITE = 11103; //User-defined Hyperspace Configs
  VK_CSGO1 = 11104; //User-defined Hyperspace Configs
  VK_WARCRAFT = 11105; //User-defined Hyperspace Configs
  VK_MINECRAFT = 11106; //User-defined Hyperspace Configs
  VK_VALORANT = 11107; //User-defined Hyperspace Configs
  VK_LEAGUE = 11108; //User-defined Hyperspace Configs
  VK_APEX = 11109; //User-defined Hyperspace Configs
  VK_DESTINY2 = 11110; //User-defined Hyperspace Configs
  VK_OVERWATCH2 = 11111; //User-defined Hyperspace Configs
  VK_CSGO2 = 11112; //User-defined Hyperspace Configs
  //TKO Edge lighting START
  VK_EDGE_L1 = 11113;
  VK_EDGE_L2 = 11114;
  VK_EDGE_L3 = 11115;
  VK_EDGE_L4 = 11116;
  VK_EDGE_L5 = 11117;
  VK_EDGE_L6 = 11118;
  VK_EDGE_L7 = 11119;
  VK_EDGE_L8 = 11120;
  VK_EDGE_L9 = 11121;
  VK_EDGE_B1 = 11122;
  VK_EDGE_B2 = 11123;
  VK_EDGE_B3 = 11124;
  VK_EDGE_B4 = 11125;
  VK_EDGE_B5 = 11126;
  VK_EDGE_B6 = 11127;
  VK_EDGE_B7 = 11128;
  VK_EDGE_B8 = 11129;
  VK_EDGE_B9 = 11130;
  VK_EDGE_B10 = 11131;
  VK_EDGE_B11 = 11132;
  VK_EDGE_B12 = 11133;
  VK_EDGE_B13 = 11134;
  VK_EDGE_B14 = 11135;
  VK_EDGE_B15 = 11136;
  VK_EDGE_R1 = 11137;
  VK_EDGE_R2 = 11138;
  VK_EDGE_R3 = 11139;
  VK_EDGE_R4 = 11140;
  VK_EDGE_R5 = 11141;
  VK_EDGE_R6 = 11142;
  VK_EDGE_R7 = 11143;
  VK_EDGE_R8 = 11144;
  VK_EDGE_R9 = 11145;
  //TKO Edge lighting END
  VK_SMARTSET = 11146;
  VK_MEDIA_FORWARD = 11147;
  VK_MEDIA_REWIND = 11148;
  VK_MEDIA_PAUSE = 11149;
  VK_MEDIA_EJECT = 11150;
  VK_MEDIA_PLAY = 11151;
  VK_MEDIA_RECORD = 11152;
  VK_MEDIA_RANDOM_PLAY = 11153;
  VK_MEDIA_PLAY_SKIP = 11154;
  VK_MOUSE_SCROLL_UP = 11155;
  VK_MOUSE_SCROLL_DOWN = 11156;
  VK_MOUSE_MOVE_LEFT = 11157;
  VK_MOUSE_MOVE_RIGHT = 11158;
  VK_MOUSE_MOVE_UP = 11159;
  VK_MOUSE_MOVE_DOWN = 11160;
  VK_LED_PLUS = 11161;
  VK_LED_MINUS = 11162;
  VK_BASE_LAYER_SHIFT = 11163;
  VK_BASE_LAYER_TOGGLE = 11164;
  VK_KP_LAYER_SHIFT = 11165;
  VK_KP_LAYER_TOGGLE = 11166;
  VK_FN1_LAYER_SHIFT = 11167;
  VK_FN1_LAYER_TOGGLE= 11168;
  VK_FN2_LAYER_SHIFT = 11169;
  VK_FN2_LAYER_TOGGLE= 11170;
  VK_FN3_LAYER_SHIFT = 11171;
  VK_FN3_LAYER_TOGGLE = 11172;
  VK_STOP_MACRO_PLAYBACK = 11173;
  VK_PROFILE_0 = 11174;
  VK_PROFILE_1 = 11175;
  VK_PROFILE_2 = 11176;
  VK_PROFILE_3 = 11177;
  VK_PROFILE_4 = 11178;
  VK_PROFILE_5 = 11179;
  VK_PROFILE_6 = 11180;
  VK_PROFILE_7 = 11181;
  VK_PROFILE_8 = 11182;
  VK_PROFILE_9 = 11183;
  VK_LED_PROFILE = 11184;
  VK_LED_LAYER = 11185;
  VK_LED_CAPS_LOCK = 11186;
  VK_LED_NUM_LOCK = 11187;
  VK_LED_SCROLL_LOCK = 11188;
  VK_LED_NKRO_MODE = 11189;
  VK_LED_GAME_MODE = 11190;  //Not used anymore
  VK_LED_DISABLE = 11191;
  VK_MACRO_SPEED_1 = 11192;
  VK_MACRO_SPEED_2 = 11193;
  VK_MACRO_SPEED_3 = 11194;
  VK_MACRO_SPEED_4 = 11195;
  VK_MACRO_SPEED_5 = 11196;
  VK_MACRO_SPEED_6 = 11197;
  VK_MACRO_SPEED_7 = 11198;
  VK_MACRO_SPEED_8 = 11199;
  VK_MACRO_SPEED_9 = 11200;
  VK_LFN_LAYER_SHIFT = 11201;
  VK_RFN_LAYER_SHIFT = 11202;
  VK_UP_KEYSTROKE = 11203;
  VK_DOWN_KEYSTROKE = 11204;
  VK_QTK_MAC_MODE = 11205;
  VK_QTK_LINUX_MODE = 11206;
  VK_PEDAL = 11207;
  //END OF VIRTUAL KEY OPTIONS

  MAPVK_VK_TO_VSC = 0;
  MAPVK_VSC_TO_VK = 1;
  MAPVK_VK_TO_CHAR = 2;
  MAPVK_VSC_TO_VK_EX = 3;

  TAG_MULTI_KEY = 1; //Tag for menu items that can only be used in multi keys
  TAG_SINGLE_KEY = 2; //Tag for menu items that can only be used in single keys
  TAG_BOTH_KEY = 3; //Tag for menu items that can be used in multi keys and single keys
  LOG_FILES_TO_KEEP = 100; //Number of log files to keep
  DOUBLECLICK_TEXT = 'lmouse-dblclick'; //text for left mouse double click
  SKIP_SEARCH = 'SKIP_SEARCH';

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
  SHIFT_MOD = 'S ';
  L_SHIFT_MOD = 'LS';
  R_SHIFT_MOD = 'RS';
  CTRL_MOD = 'C ';
  L_CTRL_MOD = 'LC';
  R_CTRL_MOD = 'RC';
  ALT_MOD = 'A ';
  L_ALT_MOD = 'LA';
  R_ALT_MOD = 'RA';
  WIN_MOD = 'W ';
  L_WIN_MOD = 'LW';
  R_WIN_MOD = 'RW';

  //Values for keys from teKeyboardHookProcxt file
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

  //Constants for loading/saving
  SK_START = '[';
  SK_END = ']';
  MK_START = '{';
  MK_END = '}';
  SEPARATOR = '>';
  KEYPAD_KEY = 'kp-';
  KEYPAD_KEY_EDGE = 'fn ';
  KP_PREFIX_LENGTH = 3;
  LAYER_PREFIX = 'LAYER=';
  ADV360_LAYER_PREFIX = '<';
  ADV360_LAYER_SUFFIX = '>';
  TEXT_LAYER_DEFAULT = '<base>';
  TEXT_LAYER_KP = '<keypad>';
  TEXT_LAYER_FN1 = '<function1>';
  TEXT_LAYER_FN2 = '<function2>';
  TEXT_LAYER_FN3 = '<function3>';

  //Various constants
  DIFF_PRESS_REL_TEXT = '{ }';
  MACRO_SPEED_TEXT = 'speed';
  MACRO_SPEED_TEXT_EDGE = 's';
  MACRO_REPEAT_EDGE = 'x';
  GLOBAL_SPEED = 'Global';
  MACRO_FREQ_MIN_ADV2 = 0;
  MACRO_FREQ_MIN_FS = 0;
  MACRO_FREQ_MIN_RGB = 1;
  MACRO_FREQ_MIN_ADV360 = 1;
  MACRO_FREQ_MAX_FS = 9;
  MACRO_FREQ_MAX_RGB = 9;
  MACRO_FREQ_MAX_ADV360 = 9;
  DEFAULT_MACRO_FREQ_ADV2 = 0;
  DEFAULT_MACRO_FREQ_FS = 0;
  DEFAULT_MACRO_FREQ_RGB = 1;
  DEFAULT_MACRO_FREQ_ADV360 = 1;
  MACRO_SPEED_MIN_ADV2 = 0;
  MACRO_SPEED_MIN_FS = 0;
  MACRO_SPEED_MIN_RGB = 1;
  MACRO_SPEED_MIN_ADV360 = 1;
  MACRO_SPEED_MAX_ADV2 = 9;
  MACRO_SPEED_MAX_FS = 9;
  MACRO_SPEED_MAX_RGB = 9;
  MACRO_SPEED_MAX_ADV360 = 9;
  LED_SPEED_MIN = 1;
  LED_SPEED_MAX = 9;
  DEFAULT_MACRO_SPEED_ADV2 = 0;
  DEFAULT_MACRO_SPEED_FS = 0;
  DEFAULT_MACRO_SPEED_RGB = 5;
  DEFAULT_LED_SPEED = 5;
  QWERTY_LAYOUT_TEXT = 'qwerty';
  DVORAK_LAYOUT_TEXT = 'dvorak';
  UNICODE_FONT = 'Cambria Math';
  DEFAULT_DIAG_HEIGHT_ADV2 = 175;
  DEFAULT_DIAG_HEIGHT_FS = 175;
  DEFAULT_DIAG_HEIGHT_RGB = 210;
  DEFAULT_DIAG_HEIGHT_PEDAL = 175;
  LED_SPEED_EDGE = 'spd';
  LED_DIR_EDGE = 'dir';
  LED_DIR_DOWN = 'down';
  LED_DIR_DOWN_INT = 0;
  LED_DIR_LEFT = 'left';
  LED_DIR_LEFT_INT = 1;
  LED_DIR_UP = 'up';
  LED_DIR_UP_INT = 2;
  LED_DIR_RIGHT = 'right';
  LED_DIR_RIGHT_INT = 3;
  DEFAULT_LED_DIR_INT = LED_DIR_LEFT_INT;
  DEFAULT_LED_COLOR = clLime;
  DEFAULT_LED_COLOR_BASE = clBlack;

  //Keyboard layouts
  ENGLISH_US_LAYOUT_NAME = '00000409';
  //ENGLISH_US_VAL = 67699721;
  ENGLISH_US_LAYOUT_VALUE = 1033;

  //Keyboard layers
  TOPLAYER_IDX = 0;
  BOTLAYER_IDX = 1;
  LAYER_QWERTY = 0;
  LAYER_DVORAK = 1;
  LAYER_BASE_360 = 0;
  LAYER_KEYPAD_360 = 1;
  LAYER_FN1_360 = 2;
  LAYER_FN2_360 = 3;
  LAYER_FN3_360 = 4;

  //Config modes
  CONFIG_LAYOUT = 0;
  CONFIG_LIGHTING = 1;
  CONFIG_EDGE_LIGHTING = 2;

  //Application IDs
  APPL_PEDAL = 0;
  APPL_ADV2 = 1;
  APPL_FSEDGE = 2;
  APPL_FSPRO = 3;
  APPL_RGB = 4;
  APPL_CROSSKP = 5;
  APPL_TKO = 6;
  APPL_ADV360 = 7;
  APPL_ADV360PRO = 8;

  //Master app ID
  APPL_MASTER_GAMING = 100;
  APPL_MASTER_OFFICE = 200;
  APPL_KINESIS_APP = 900;

  //Led modes
  LED_MONO = '[mono]';
  LED_BREATHE = '[breathe]';
  LED_SPECTRUM = '[spectrum]';
  LED_WAVE = '[wave]';
  LED_REACTIVE = '[reactive]';
  LED_STARLIGHT = '[star]';
  LED_REBOUND = '[rebound]';
  LED_RIPPLE = '[ripple]';
  LED_FIREBALL = '[fireball]';
  LED_LOOP = '[loop]';
  LED_PULSE = '[pulse]';
  LED_RAIN = '[rain]';
  LED_PITCH_BLACK = '[black]';
  LED_OFF = '0';

  //Led indicators
  LED_IND_START = '[ind';
  LED_NKRO = '[nkro]';
  LED_SCROLL_LOCK = '[sclk]';
  LED_NUM_LOCK = '[nmlk]';
  LED_CAPS = '[caps]';
  LED_PROFILE = '[prof]';
  LED_BATTERY = '[batt]';
  LED_NULL = '[null]';

  //Edge modes
  EDGE_MONO = '[mono_edge]';
  EDGE_BREATHE = '[breathe_edge]';
  EDGE_SPECTRUM = '[spectrum_edge]';
  EDGE_WAVE = '[wave_edge]';
  EDGE_REBOUND = '[rebound_edge]';
  EDGE_LOOP = '[loop_edge]';
  EDGE_PULSE = '[pulse_edge]';
  EDGE_FROZENWAVE = '[frozenwave_edge]';

  //Misc constants
  HELP_TITLE_OFFICE = 'Kinesis Ergo SmartSet App';
  HELP_TITLE_GAMING = 'Kinesis Gaming SmartSet App';
  USER_MANUAL_FSEDGE = 'User Manual-SmartSet App.pdf';
  USER_MANUAL_ADV2 = 'SmartSet App Help.pdf';
  KB_SETTINGS_FILE = 'kbd_settings.txt';
  ADV360_SETTINGS_FILE = 'settings.txt';
  APP_SETTINGS_FILE = 'app_settings.txt';
  ADV2_STATE_FILE = 'state.txt';
  VERSION_FILE = 'version.txt';
  VERSION_FILE_ADV360 = 'settings.txt';
  VERSION_FILE_PEDAL = 'pedals.txt';
  VERSION_FOLDER = 'firmware';
  VERSION_FOLDER_ADV360 = 'settings';
  VERSION_FOLDER_ADV2 = 'active';
  VERSION_FOLDER_PEDAL = 'active';
  MACRO_COUNT_FS = 3;
  MAX_MACRO_FS = 24;
  MAX_MACRO_RGB = 100;
  MAX_MACRO_ADV360 = 100;
  MAX_MACRO_FS_PRIOR_340 = 24;
  MAX_MACRO_FS_340_PLUS = 100;
  MAX_KEYSTROKES_FS = 7200;
  MAX_KEYSTROKES_RGB = 7200;
  MAX_KEYSTROKES_MACRO_FS = 300;
  MAX_KEYSTROKES_MACRO_ADV360 = 500;
  DISABLE_NOTIF = 100;
  FILE_LAYOUT = 'layout';
  FILE_LED = 'led';
  PITCH_BLACK = 'P';
  BREATHE = 'B';
  KINESIS_URL = 'https://kinesis-ergo.com/';
  KINESIS_GAMING_URL = 'https://gaming.kinesis-ergo.com/';
  FSEDGE_TUTORIAL = 'https://www.youtube.com/playlist?list=PLJql6LYXw-uOcHFihFhnZhJGb854SRy7Z';
  RGB_TUTORIAL = 'https://www.youtube.com/playlist?list=PLJql6LYXw-uOjCXMkLf7Ur3Jm9Dsqf_KD';
  TKO_TUTORIAL = 'https://www.youtube.com/playlist?list=PLJql6LYXw-uNVIBnNgfaWtxnbzMFkAF8C';
  ADV360_TUTORIAL = 'https://www.youtube.com/playlist?list=PLcsFMh_3_h0b_TJAf6qlHX97A-vnne2-N';
  RGB_HELP = 'https://gaming.kinesis-ergo.com/fs-edge-rgb-support/';
  TKO_HELP = 'https://gaming.kinesis-ergo.com/tko-support/';
  ADV360_HELP = 'https://kinesis-ergo.com/support/kb360/';
  MASTER_GAMING_HELP = 'https://gaming.kinesis-ergo.com/support/#support-for-my-device';
  MASTER_OFFICE_HELP = 'https://kinesis-ergo.com/support/#support-for-my-device';
  FSEDGE_MANUAL = 'https://gaming.kinesis-ergo.com/fs-edge-support/#manuals';
  FSPRO_MANUAL = 'https://kinesis-ergo.com/support/freestyle-pro/#manuals';
  ADV2_MANUAL = 'https://kinesis-ergo.com/support/advantage2/#manuals';
  RGB_MANUAL = 'https://gaming.kinesis-ergo.com/fs-edge-rgb-support/#manuals';
  TKO_MANUAL = 'https://gaming.kinesis-ergo.com/tko-support/#manuals';
  PEDAL_MANUAL = 'https://kinesis-ergo.com/support/savant-elite2/#manuals';
  ADV360_MANUAL = ADV360_HELP + '#manuals';
  FSPRO_TUTORIAL = 'https://www.youtube.com/playlist?list=PLcsFMh_3_h0Z7Gx0T5N7TTzceorPHXJr5';
  ADV2_TUTORIAL = 'https://www.youtube.com/playlist?list=PLcsFMh_3_h0aNmELoR6kakcNf7AInoEfW';
  PEDAL_TUTORIAL = 'https://www.youtube.com/';
  FSPRO_TROUBLESHOOT = 'https://kinesis-ergo.com/support/freestyle-pro/';
  FSEDGE_TROUBLESHOOT = 'https://gaming.kinesis-ergo.com/fs-edge-support/';
  RGB_TROUBLESHOOT = 'https://gaming.kinesis-ergo.com/fs-edge-rgb-support/';
  TKO_TROUBLESHOOT = 'https://gaming.kinesis-ergo.com/tko-support/';
  ADV2_TROUBLESHOOT = 'https://kinesis-ergo.com/support/advantage2/';
  ADV360_TROUBLESHOOT = ADV360_HELP;
  PEDAL_TROUBLESHOOT = 'https://kinesis-ergo.com/support/savant-elite2/';
  FSPRO_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
  FSEDGE_SUPPORT = 'https://gaming.kinesis-ergo.com/contact-tech-support/';
  ADV2_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
  ADV360_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
  PEDAL_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
  MASTER_GAMING_SUPPORT = 'https://gaming.kinesis-ergo.com/contact-tech-support/';
  MASTER_OFFICE_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
  RGB_FIRMWARE = 'https://gaming.kinesis-ergo.com/fs-edge-rgb-support/#firmware';
  TKO_FIRMWARE = 'https://gaming.kinesis-ergo.com/tko-support/#firmware';
  ADV360_FIRMWARE = ADV360_HELP + '#firmware-updates';
  MODEL_NAME_FSPRO = 'FS PRO';
  MODEL_NAME_FSEDGE = 'FS EDGE';
  ADV2_2MB = '2MB';
  ADV2_4MB = '4MB';
  MIN_LAYOUT_FILE = 1;
  MAX_LAYOUT_FILE = 9;
  MIN_LED_FILE = 1;
  MAX_LED_FILE = 9;
  DEFAULT_CUST_COLOR = clNone;
  RGB_DRIVE = 'FS EDGE RGB';
  FSEDGE_DRIVE = 'FS EDGE';
  FSPRO_DRIVE = 'FS PRO';
  ADV2_DRIVE = 'ADVANTAGE2';
  ADV2_DRIVE_2 = 'KINESIS KB';
  ADV2_DRIVE_3 = 'ADV2';
  PEDAL_DRIVE = 'SE2';
  PEDAL_DRIVE_2 = 'KINESIS FP';
  CROSSKP_DRIVE = 'CROSSFIRE KEYPAD';
  TKO_DRIVE = 'TKO';
  ADV360_DRIVE = 'ADV360';
  TAP_AND_HOLD = 't&h';
  DEFAULT_SPEED_TAP_HOLD = 250;
  MAX_TAP_HOLD = 10;
  MAX_IMPORT_SIZE = 50;
  MIN_TIMING_DELAY = 1;
  MAX_TIMING_DELAY = 999;
  REGISTRY_KINESIS = 'SOFTWARE\KINESIS';

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

procedure SetFontColor(aObject: TWinControl; fontColor: TColor);
var
  i:integer;
  name: string;
begin
  aObject.Font.Color := fontColor;
  for i := 0 to aObject.ControlCount - 1 do
  begin
    if aObject.Controls[i].InheritsFrom(TWinControl) then
    begin
      name := TWinControl(aObject.Controls[i]).Name;
      TWinControl(aObject.Controls[i]).Font.Color := fontColor;

      if (aObject.Controls[i] is TPanel) then
        SetFontColor(TPanel(aObject.Controls[i]), fontColor);
    end

    //if aObject.Components[i].InheritsFrom(TGraphicControl) and not(aObject.Components[i].InheritsFrom(THSSpeedButton)) then
    //   TGraphicControl(aObject.Components[i]).Font.Color := fontColor;
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
  {$ifdef Win64}
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
  {$ifdef Win64}
  //Gets currenty keyboard scan Code
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
  {$ifdef Win64}
  //Gets English US Scan Code
  scanCode := MapVirtualKeyEx(Key, 0, ENGLISH_US_LAYOUT_VALUE);

  //Converts to current keyboard virtual code
  result := MapVirtualKey(scanCode, 1);
  {$endif}
end;

//Return KeyboardLayout for the user
function GetCurrentKeyoardLayout: string;
var
  {$ifdef Win64}LayoutName: array [0 .. KL_NAMELENGTH + 1] of Char; {$endif}
  layout: string;
begin
  layout := ENGLISH_US_LAYOUT_NAME;
  {$ifdef Win64}
  try
    if (GetKeyboardLayoutName(@LayoutName)) then
      layout := StrPas(LayoutName);
  except
  end;
  {$endif}
  result := layout;
end;

//Checks if we can use Unicode characters
function CanUseUnicode: boolean;
begin
  result := false;
  {$ifdef Win64}
  result := (Win32MajorVersion >= 10); //Windows 10 and up
  {$endif}
end;

//Checks if we can use Unicode characters
function IsPreWin8: boolean;
begin
  result := false;
  {$ifdef Win64}
  result := (Win32MajorVersion <= 6) and (Win32MinorVersion < 2);
  {$endif}
end;

//Converts a string to Int, if error returns invalidValue
function ConvertToInt(value: string; invalidValue: integer): integer;
var
  tempVal, code: integer;
begin
  Val(value, tempVal, code);
  if (code = 0) then
    result := tempVal
  else
    result := invalidValue;
end;

function IsLeftShift(key: word): boolean;
begin
  result := (key = VK_LSHIFT);
end;

function IsLeftCtrl(key: word): boolean;
begin
  result := (key = VK_LCONTROL);
end;

function IsLeftAlt(key: word): boolean;
begin
  result := (key = VK_LMENU);
end;

function IsLeftWin(key: word): boolean;
begin
  result := (key = VK_LWIN);
end;

function IsRightShift(key: word): boolean;
begin
  result := (key = VK_RSHIFT);
end;

function IsRightCtrl(key: word): boolean;
begin
  result := (key = VK_RCONTROL);
end;

function IsRightAlt(key: word): boolean;
begin
  result := (key = VK_RMENU);
end;

function GetIndexOfString(value: string; fileContent: TStringList): integer;
var
  i:integer;
begin
  result := -1;
  if (fileContent <> nil) then
  begin
    for i := 0 to fileContent.Count - 1 do
    begin
      if (Pos(AnsiLowerCase(value), AnsiLowerCase(fileContent[i])) > 0) then
      begin
        result := i;
        break;
      end;
    end;
  end;
end;

function GetPosOfNthString(value: string; search: string; nth: integer): integer;
var
  strLength: integer;
  idx: integer;
  searchCount: integer;
begin
  result := -1;

  searchCount := 0;
  strLength := Length(value);
  idx := 1;
  while ((idx <= strLength) and (searchCount < nth)) do
  begin
    if (AnsiUpperCase(Copy(value, idx, Length(search))) = AnsiUpperCase(search)) then
      inc(searchCount);

    if (searchCount = nth) then
      result := idx;

    inc(idx);
  end;
end;

function GetIndexOfNumber(value: string): integer;
var
  i:integer;
begin
  result := -1;
  for i := 1 to Length(value) do
  begin
    if IsNumber(value, i) then
    begin
      result := i;
      break;
    end;
  end;
end;

function GetAvailableDrives: TStringList;
var
{$ifdef Win64}
  Drive: Char;
  DriveLetter: string;
  OldMode: Word;
{$endif}
  aListDrives: TStringList;
begin
  aListDrives := TStringList.Create;
  {$ifdef Win64}
  // Empty Floppy or Zip drives can generate a Windows error.
  // We disable system errors during the listing.
  // Note that another way to skip these errors would be to use DEVICE_IO_CONTROL.
  OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try

    // Search all drive letters
    for Drive := 'A' to 'Z' do
    begin
      DriveLetter := Drive + ':\';

      case GetDriveType(PChar(DriveLetter)) of
       DRIVE_REMOVABLE: aListDrives.Add(DriveLetter);
       DRIVE_FIXED:     aListDrives.Add(DriveLetter);
       DRIVE_REMOTE:    aListDrives.Add(DriveLetter);
       DRIVE_CDROM:     aListDrives.Add(DriveLetter);
       DRIVE_RAMDISK:   aListDrives.Add(DriveLetter);
      end;
    end;

  finally
    // Restores previous Windows error mode.
    SetErrorMode(OldMode);
  end;
  {$endif}
  result := aListDrives;
end;

function GetVolumeLabel(DriveChar: Char): string;
{$ifdef Win64}
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeInfo:  array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
  Buf: array [0..MAX_PATH] of Char;
{$endif}
begin
  result := '';
  {$ifdef Win64}
  GetVolumeInformation(PChar(DriveChar + ':\'),
  Buf, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed,
  VolumeFlags, nil, 0);

  SetString(Result, Buf, StrLen(Buf));   { Set return result }
  Result:=AnsiUpperCase(Result);
  {$endif}
end;

function SetBaseDirectory(init: boolean = false): boolean;
var
  driveList: TStringList;
  i: integer;
  dirFirmware: string;
  driveName: string;
  firmwareFolder: string;
  firmwareFile: string;
  driveName1: string;
  driveName2: string;
  driveName3: string;
  kbDrive: string;
begin
  result := false;
  firmwareFolder := VERSION_FOLDER;
  firmwareFile := VERSION_FILE;
  driveName1 := '';
  driveName2 := '';
  driveName3 := '';
  if (GApplication = APPL_FSEDGE) then
  begin
     driveName1 := FSEDGE_DRIVE;
     driveName2 := FSPRO_DRIVE;
  end
  else if (GApplication = APPL_FSPRO) then
  begin
     driveName1 := FSPRO_DRIVE;
     driveName2 := FSEDGE_DRIVE;
  end
  else if (GApplication = APPL_ADV2) then
  begin
     driveName1 := ADV2_DRIVE;
     driveName2 := ADV2_DRIVE_2;
     driveName3 := ADV2_DRIVE_3;
     firmwareFolder := VERSION_FOLDER_ADV2;
  end
  else if (GApplication = APPL_PEDAL) then
  begin
     driveName1 := PEDAL_DRIVE;
     driveName2 := PEDAL_DRIVE_2;
     firmwareFolder := VERSION_FOLDER_PEDAL;
  end
  else if (GApplication = APPL_RGB) then
     driveName1 := RGB_DRIVE
  else if (GApplication = APPl_TKO) then
     driveName1 := TKO_DRIVE
  else if (GApplication = APPL_ADV360) then
  begin
    driveName1 := ADV360_DRIVE;
    firmwareFolder := VERSION_FOLDER_ADV360;
    firmwareFile := VERSION_FILE_ADV360;
  end;
  GApplicationPath := GExecutablePath;
  if not DirectoryExists(GApplicationPath + firmwareFolder) then
  begin
    GDesktopMode := true;
    {$ifdef Win64}
    driveList := GetAvailableDrives;
    for i := 0 to driveList.Count - 1 do
    begin
      dirFirmware := IncludeTrailingBackslash(driveList[i] + firmwareFolder);
      driveName := UpperCase(Trim(GetVolumeLabel(driveList[i][1])));

      if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + firmwareFile)) and
         ((driveName = driveName1) or (driveName = driveName2) or (driveName = driveName3)) then
      begin
        GApplicationPath := IncludeTrailingBackslash(driveList[i]);
        result := true;
      end;
    end;
    FreeAndNil(driveList);
    {$endif}

    //MacOS
    {$ifdef Darwin}
    for i := 1 to 3 do
    begin
      case i of
       1: kbDrive := driveName1;
       2: kbDrive := driveName2;
       3: kbDrive := driveName3;
      end;
      if (kbDrive <> '') then
      begin

        driveName := IncludeTrailingBackslash('/VOLUMES/' + kbDrive);
        dirFirmware := IncludeTrailingBackslash(driveName + firmwareFolder);

        if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + firmwareFile)) then
        begin
          GApplicationPath := IncludeTrailingBackslash(driveName);
          result := true;
        end;
      end;
    end;
    {$endif}
  end;

  if (result) then
     ResetAppPaths;
end;

procedure ResetAppPaths;
begin
  //Warning ParamStr(0) might not work correctly on Mac OS
  //GPedalsFilePath := IncludeTrailingBackslash(GApplicationPath + 'active');
  GLayoutFilePath := IncludeTrailingBackslash(GApplicationPath + 'layouts');
  GLedFilePath := IncludeTrailingBackslash(GApplicationPath + 'lighting');
  GSettingsFilePath := IncludeTrailingBackslash(GApplicationPath + 'settings');
  //GFirmwareFilePath := IncludeTrailingBackslash(GApplicationPath + 'firmware');
  //GPedalsFile := GPedalsFilePath + 'pedals.txt';
  //GVersionFile := GPedalsFilePath + VERSION_FILE;
  //GStateFile := GPedalsFilePath + ADV2_STATE_FILE;
  GDebugMode := FileExists(GApplicationPath + 'debug.on');
  GDebugFirmware := FileExists(GApplicationPath + 'debug_firm.on');
  GDevMode := FileExists(GApplicationPath + 'devmode.on');
end;

//New Gen2 Device 2021+
function IsGen2Device(device: integer): boolean;
begin
  result := (device in [APPL_ADV360]);
end;

function CheckMultimodifier(value: string): boolean;
begin
  value := value.ToLower;

  result := value.Contains('[caws]') or
    value.Contains('[cawx]') or
    value.Contains('[cxws]') or
    value.Contains('[caxs]') or
    value.Contains('[xaws]') or
    value.Contains('[caxx]') or
    value.Contains('[cxwx]') or
    value.Contains('[cxxs]') or
    value.Contains('[xawx]') or
    value.Contains('[xaxs]') or
    value.Contains('[xxws]');
end;

//Get right or left key for each modifier
function GetCurrentKeyMac(key: word): word;
begin
  result := key;

  if Key = VK_SHIFT then
  begin
    result := VK_LSHIFT;
  end
  else if Key = VK_LBUTTON then
  begin
    result := VK_LWIN;
  end
  else if Key = VK_MENU THEN
  begin
    result := VK_LMENU;
  end
  else if Key = VK_CONTROL then
  begin
    result := VK_LCONTROL;
  end;
end;

function GetKeyModifierText(iKey: integer): string;
begin
  Result := '';
  if iKey = VK_SHIFT then
    Result := SHIFT_MOD
  else if iKey = VK_LSHIFT then
    Result := L_SHIFT_MOD
  else if iKey = VK_RSHIFT then
    Result := R_SHIFT_MOD
  else if iKey = VK_CONTROL then
    Result := CTRL_MOD
  else if iKey = VK_LCONTROL then
    Result := L_CTRL_MOD
  else if iKey = VK_RCONTROL then
    Result := R_CTRL_MOD
  else if iKey = VK_MENU then
    Result := ALT_MOD
  else if iKey = VK_LMENU then
    Result := L_ALT_MOD
  else if iKey = VK_RMENU then
    Result := R_ALT_MOD
  else if (iKey = VK_LWIN) then
    Result := L_WIN_MOD
  else if (iKey = VK_RWIN) then
    Result := R_WIN_MOD;
end;

//Initializes and returns list of Configurable Keys
function GetConfigKeys: TKeyList;
var
  i: integer;
  ConfigKeys: TKeyList;
  mediaFontSize: integer;
  smallFontSize: integer;
begin
  ConfigKeys := TKeyList.Create;

  if (GApplication in [APPL_RGB, APPL_TKO]) then
    smallFontSize := 9
  else
  begin
    smallFontSize := 8;
    {$ifdef Darwin}
    smallFontSize := 9;
    if (GApplication in [APPL_ADV360]) then
      smallFontSize := 7;
    {$endif}
  end;

  //Clear all keys
  ConfigKeys.Clear;

  if (GApplication in [APPL_ADV2, APPL_PEDAL]) then //Older apps (Pedal and Adv2)
  begin
    ConfigKeys.Add(TKey.Create(VK_ESCAPE, 'escape', 'Esc', '', '', '', false, false, '', true, false, 0, '', 'Escape'));
    ConfigKeys.Add(TKey.Create(VK_SNAPSHOT, 'prtscr', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize, '', 'Print Screen')); //Print screen key
    ConfigKeys.Add(TKey.Create(VK_PRINT, 'prtscr', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize, '', 'Print Screen', SKIP_SEARCH)); //Old print key...
    ConfigKeys.Add(TKey.Create(VK_SCROLL, 'scroll', 'Scroll' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Scroll Lock'));
    ConfigKeys.Add(TKey.Create(VK_SPACE, 'space', 'Space', 'space', ' '));///UTFString(#$e2#$90#$a3)));
    ConfigKeys.Add(TKey.Create(VK_INSERT, 'insert', 'Insert'));
    ConfigKeys.Add(TKey.Create(VK_NEXT, 'pdown', 'Page' + #10 + 'Down', '', '', '', false, false, '', true, false, 0, '', 'Page Down'));
    ConfigKeys.Add(TKey.Create(VK_PRIOR, 'pup', 'Page' + #10 + 'Up', '', '', '', false, false, '', true, false, 0, '', 'Page Up'));
    ConfigKeys.Add(TKey.Create(VK_PAUSE, 'pause', 'Pause' + #10 + 'Break', '', '', '', false, false, '', true, false, smallFontSize, '', 'Pause Break'));
    ConfigKeys.Add(TKey.Create(VK_RIGHT, 'right', UnicodeToUTF8(8594), '', '', '', false, false, '', true, false, 16, UNICODE_FONT, '', 'Right'));
    ConfigKeys.Add(TKey.Create(VK_LEFT, 'left', UnicodeToUTF8(8592), '', '', '', false, false, '', true, false, 16, UNICODE_FONT, '', 'Left'));
    ConfigKeys.Add(TKey.Create(VK_UP, 'up', UnicodeToUTF8(8593), '', '', '', false, false, '', true, false, 16, UNICODE_FONT, '', 'Up'));
    ConfigKeys.Add(TKey.Create(VK_DOWN, 'down', UnicodeToUTF8(8595), '', '', '', false, false, '', true, false, 16, UNICODE_FONT, '', 'Down'));
    ConfigKeys.Add(TKey.Create(VK_LSHIFT, 'lshift', 'Left' + #10 + 'Shift', '', '', '', false, false, '', true, false, 0, '', 'Left Shift'));
    ConfigKeys.Add(TKey.Create(VK_RSHIFT, 'rshift', 'Right' + #10 + 'Shift', '', '', '', false, false, '', true, false, 0, '', 'Right Shift'));
    ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctrl', 'Left' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Left Ctrl'));
    ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctrl', 'Right' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Right Ctrl'));
    ConfigKeys.Add(TKey.Create(VK_NUMLOCK, 'numlk', 'Num' + #10 + 'Lock', '', '', '', false, false, '', true, false, 0, '', 'Num Lock'));
    ConfigKeys.Add(TKey.Create(VK_KP_NUMLCK, 'numlk', 'Num' + #10 + 'Lock', '', '', '', false, false, '', true, false, 0, '', 'Num Lock', SKIP_SEARCH));

    //Special chars
    ConfigKeys.Add(TKey.Create(VK_LCL_EQUAL, '=', '+' + #10 + '=', '=', '=', '+', true, true, '', True, False, 0, '', '', 'Equals'));
    ConfigKeys.Add(TKey.Create(VK_LCL_MINUS, '-', '_' + #10 + '-', 'hyphen', '-', '_', true, true, '', True, False, 0, '', '', 'Hyphen'));
    ConfigKeys.Add(TKey.Create(VK_LCL_SLASH, '/', '?' + #10 + '/', '/', '/', '?', true, true, '', True, False, 0, '', '', 'Forward slash'));
    ConfigKeys.Add(TKey.Create(VK_LCL_BACKSLASH, '\', '|' + #10 + '\', '\', '\', '|', true, true, '', True, False, 0, '', '', 'Back slash'));
    ConfigKeys.Add(TKey.Create(VK_LCL_QUOTE, '''', '"' + #10 + '''', '''', '''', '"', true, true, '', True, False, 0, '', '', 'Apostrophe'));
    ConfigKeys.Add(TKey.Create(VK_LCL_TILDE, '`', '~' + #10 + '`', '`', '`', '~', true, true, '', True, False, 0, '', '', 'Hash'));
    ConfigKeys.Add(TKey.Create(VK_LCL_SEMI_COMMA, ';', ':' + #10 + ';', ';', ';', ':', true, true, '', True, False, 0, '', '', 'Semi Colon'));
    ConfigKeys.Add(TKey.Create(VK_LCL_COMMA, ',', '<' + #10 + ',', ',', ',', '<', true, true, '', True, False, 0, '', '', 'Comma'));
    ConfigKeys.Add(TKey.Create(VK_LCL_POINT, '.', '>' + #10 + '.', '.', '.', '>', true, true, '', True, False, 0, '', '', 'Period'));
    ConfigKeys.Add(TKey.Create(VK_LCL_OPEN_BRACKET, '[', '{' + #10 + '[', 'obrack', '[', '{', true, true, '', True, False, 0, '', '', 'Open Bracket'));
    ConfigKeys.Add(TKey.Create(VK_LCL_CLOSE_BRACKET, ']', '}' + #10 + ']', 'cbrack', ']', '}', true, true, '', True, False, 0, '', '', 'Close Bracket'));
    ConfigKeys.Add(TKey.Create(VK_OEM_102, 'intl-\', '', 'intl-\', 'intl-\', 'intl-\', true, true, '', True, False, 0, '', '', 'International Key'));  //International <> key between Left Shift and Z

    //Keypad keys
    ConfigKeys.Add(TKey.Create(VK_NUMPAD0, 'kp0', '0', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_0, 'kp0', '0', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 0'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD1, 'kp1', '1', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_1, 'kp1', '1', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 1'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD2, 'kp2', '2', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_2, 'kp2', '2', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 2'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD3, 'kp3', '3', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_3, 'kp3', '3', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 3'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD4, 'kp4', '4', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_4, 'kp4', '4', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 4'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD5, 'kp5', '5', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_5, 'kp5', '5', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 5'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD6, 'kp6', '6', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_6, 'kp6', '6', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 6'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD7, 'kp7', '7', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_7, 'kp7', '7', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 7'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD8, 'kp8', '8', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_8, 'kp8', '8', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 8'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD9, 'kp9', '9', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_KP_9, 'kp9', '9', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 9'));
    ConfigKeys.Add(TKey.Create(VK_DIVIDE, 'kp/', '/', 'kpdiv', '', '', false, false, '', true, false, 0, '', '', 'Keypad divide'));
    ConfigKeys.Add(TKey.Create(VK_KP_DIVIDE, 'kp/', '/', 'kpdiv', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_MULTIPLY, 'kp*', '*', 'kpmult', '', '', false, false, '', true, false, 0, '', '', 'Keypad multiply'));
    ConfigKeys.Add(TKey.Create(VK_KP_MULT, 'kp*', '*', 'kpmult', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_SUBTRACT, 'kp-', '-', 'kpmin', '', '', false, false, '', true, false, 0, '', '', 'Keypad minus'));
    ConfigKeys.Add(TKey.Create(VK_KP_MIN, 'kp-', '-', 'kpmin', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_ADD, 'kp+', '+', 'kpplus', '', '', false, false, '', true, false, 0, '', '', 'Keypad add'));
    ConfigKeys.Add(TKey.Create(VK_KP_PLUS, 'kp+', '+', 'kpplus', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_DECIMAL, 'kp.', '.', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad period'));
    ConfigKeys.Add(TKey.Create(VK_KP_PERI, 'kp.', '.', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_NUMPADENTER, 'kpenter', 'Kp' + #10 + 'Enter', 'kpenter', '', '', false, false, '', true, false, 0, '', 'Keypad Enter'));
    //ConfigKeys.Add(TKey.Create(VK_OEM_NEC_EQUAL, 'kp=', '='));
    ConfigKeys.Add(TKey.Create(VK_KP_EQUAL, 'kp=', '=', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad Equals'));

    //Number keys
    ConfigKeys.Add(TKey.Create(VK_0, '0', ')' + #10 + '0', '0', '0', ')', true, true, '', true, false, 0, '', '0 )'));
    ConfigKeys.Add(TKey.Create(VK_1, '1', '!' + #10 + '1', '1', '1', '!', true, true, '', true, false, 0, '', '1 !'));
    ConfigKeys.Add(TKey.Create(VK_2, '2', '@' + #10 + '2', '2', '2', '@', true, true, '', true, false, 0, '', '2 @'));
    ConfigKeys.Add(TKey.Create(VK_3, '3', '#' + #10 + '3', '3', '3', '#', true, true, '', true, false, 0, '', '3 #'));
    ConfigKeys.Add(TKey.Create(VK_4, '4', '$' + #10 + '4', '4', '4', '$', true, true, '', true, false, 0, '', '4 $'));
    ConfigKeys.Add(TKey.Create(VK_5, '5', '%' + #10 + '5', '5', '5', '%', true, true, '', true, false, 0, '', '5 %'));
    ConfigKeys.Add(TKey.Create(VK_6, '6', '^' + #10 + '6', '6', '6', '^', true, true, '', true, false, 0, '', '6 ^'));
    ConfigKeys.Add(TKey.Create(VK_7, '7', '&' + #10 + '7', '7', '7', '&', true, true, '', true, false, 0, '', '7 &'));
    ConfigKeys.Add(TKey.Create(VK_8, '8', '*' + #10 + '8', '8', '8', '*', true, true, '', true, false, 0, '', '8 *'));
    ConfigKeys.Add(TKey.Create(VK_9, '9', '(' + #10 + '9', '9', '9', '(', true, true, '', true, false, 0, '', '9 ('));

    //Mouse actions
    if (GApplication in [APPL_ADV2]) then
    begin
      ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmouse', 'Left' + #10 + 'Mouse', '', '', '', false, false, '', true, false, smallFontSize));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmouse', 'Middle' + #10 + 'Mouse', '', '', '', false, false, '', true, false, smallFontSize));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmouse', 'Right' + #10 + 'Mouse', '', '', '', false, false, '', true, false, smallFontSize));
    end
    else if (GApplication in [APPL_PEDAL]) then
    begin
      ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmouse', '', '', '', '', false, false, '', true, false, 0, '', '', 'Left Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmouse', '', '', '', '', false, false, '', true, false, 0, '', '', 'Middle Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmouse', '', '', '', '', false, false, '', true, false, 0, '', '', 'Right Mouse'));
    end;

    //Misc keys
    ConfigKeys.Add(TKey.Create(VK_KEYPAD_TOGGLE, 'kptoggle', 'Key-' + #10 + 'pad', '', '', '', false, false, '', true, false, smallFontSize, '', 'Keypad'));
    ConfigKeys.Add(TKey.Create(VK_APPS, 'menu', 'PC' + #10 + 'Menu'));
    ConfigKeys.Add(TKey.Create(VK_KP_MENU, 'menu', 'PC' + #10 + 'Menu', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_SHUTDOWN, 'shutdn', 'Shut' + #10 + 'down'));
    ConfigKeys.Add(TKey.Create(VK_MIC_MUTE, 'micmute', 'Mic' + #10 + 'Mute', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_FN_TOGGLE, 'fntoggle', 'Fn' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_FN_SHIFT, 'fnshift', 'Fn' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_HYPER, 'hyper', 'Hyper'));
    ConfigKeys.Add(TKey.Create(VK_MEH, 'meh', 'Meh'));
  end
  else //Newer devices and Gen2 devices
  begin
    //START COMMON Gen1 and Gen2
    ConfigKeys.Add(TKey.Create(VK_ESCAPE, 'esc', 'Esc', '', '', '', false, false, '', true, false, 0, '', 'Escape'));
    ConfigKeys.Add(TKey.Create(VK_SNAPSHOT, 'prnt', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize ,'', 'Print Screen')); //Print screen key
    ConfigKeys.Add(TKey.Create(VK_PRINT, 'prnt', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize, '', 'Print Screen')); //Old print key...
    ConfigKeys.Add(TKey.Create(VK_SPACE, 'spc', 'Space', 'spc', ' '));
    ConfigKeys.Add(TKey.Create(VK_INSERT, 'insert', 'Insert', 'ins'));
    ConfigKeys.Add(TKey.Create(VK_RIGHT, 'rght', UnicodeToUTF8(8594), '', '', '', false, false, '', true, false, 10, UNICODE_FONT, '', 'Right'));
    ConfigKeys.Add(TKey.Create(VK_UP, 'up', UnicodeToUTF8(8593), '', '', '', false, false, '', true, false, 10, UNICODE_FONT, '', 'Up'));

    //Keypad keys
    ConfigKeys.Add(TKey.Create(VK_NUMPAD0, 'kp0', '0', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 0'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD1, 'kp1', '1', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 1'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD2, 'kp2', '2', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 2'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD3, 'kp3', '3', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 3'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD4, 'kp4', '4', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 4'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD5, 'kp5', '5', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 5'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD6, 'kp6', '6', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 6'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD7, 'kp7', '7', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 7'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD8, 'kp8', '8', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 8'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD9, 'kp9', '9', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad 9'));
    ConfigKeys.Add(TKey.Create(VK_DIVIDE, 'kp/', '/', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad divide'));
    ConfigKeys.Add(TKey.Create(VK_MULTIPLY, 'kp*', '*', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad multiply'));
    ConfigKeys.Add(TKey.Create(VK_SUBTRACT, 'kp-', '-', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad substract'));
    ConfigKeys.Add(TKey.Create(VK_ADD, 'kp+', '+', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad add'));
    ConfigKeys.Add(TKey.Create(VK_DECIMAL, 'kp.', '.', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad period'));
    ConfigKeys.Add(TKey.Create(VK_KP_EQUAL, 'kp=', '=', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad equals'));
    //ConfigKeys.Add(TKey.Create(VK_OEM_NEC_EQUAL, 'kp=', '='));

    //Number keys
    ConfigKeys.Add(TKey.Create(VK_0, '0', '0 )', '0', '0', ')', true, true));
    ConfigKeys.Add(TKey.Create(VK_1, '1', '1 !', '1', '1', '!', true, true));
    ConfigKeys.Add(TKey.Create(VK_2, '2', '2 @', '2', '2', '@', true, true));
    ConfigKeys.Add(TKey.Create(VK_3, '3', '3 #', '3', '3', '#', true, true));
    ConfigKeys.Add(TKey.Create(VK_4, '4', '4 $', '4', '4', '$', true, true));
    ConfigKeys.Add(TKey.Create(VK_5, '5', '5 %', '5', '5', '%', true, true));
    ConfigKeys.Add(TKey.Create(VK_6, '6', '6 ^', '6', '6', '^', true, true));
    ConfigKeys.Add(TKey.Create(VK_7, '7', '7 &', '7', '7', '&', true, true));
    ConfigKeys.Add(TKey.Create(VK_8, '8', '8 *', '8', '8', '*', true, true));
    ConfigKeys.Add(TKey.Create(VK_9, '9', '9 (', '9', '9', '(', true, true));

    //Misc keys
    ConfigKeys.Add(TKey.Create(VK_FN_TOGGLE, 'fntog', 'Fn' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_FN_SHIFT, 'fnshf', 'Fn' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize));

    //END COMMON Gen1 and Gen2

    if IsGen2Device(GApplication) then //Gen2 devices (Adv360, 2021+)
    begin
      ConfigKeys.Add(TKey.Create(VK_NEXT, 'pgdn', 'Page' + #10 + 'Down', '', '', '', false, false, '', true, false, 0, '', 'Page Down'));
      ConfigKeys.Add(TKey.Create(VK_PRIOR, 'pgup', 'Page' + #10 + 'Up', '', '', '', false, false, '', true, false, 0, '', 'Page Up'));
      ConfigKeys.Add(TKey.Create(VK_SCROLL, 'sclk', 'Scroll' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Scroll Lock'));
      ConfigKeys.Add(TKey.Create(VK_PAUSE, 'paus', 'Pause' + #10 + 'Break', '', '', '', false, false, '', true, false, smallFontSize, '', 'Pause Break'));
      ConfigKeys.Add(TKey.Create(VK_LEFT, 'left', UnicodeToUTF8(8592), '', '', '', false, false, '', true, false, 10, UNICODE_FONT, '', 'Left'));
      ConfigKeys.Add(TKey.Create(VK_DOWN, 'down', UnicodeToUTF8(8595), '', '', '', false, false, '', true, false, 10, UNICODE_FONT, '', 'Down'));
      ConfigKeys.Add(TKey.Create(VK_LSHIFT, 'lshf', 'Left' + #10 + 'Shift', '', '', '', false, false, '', true, false, 0, '', 'Left Shift'));
      ConfigKeys.Add(TKey.Create(VK_RSHIFT, 'rshf', 'Right' + #10 + 'Shift', '', '', '', false, false, '', true, false, 0, '', 'Right Shift'));
      {$ifdef Win64}
      ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctr', 'Left' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Left Ctrl'));
      ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctr', 'Right' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Right Ctrl'));
      {$endif}
      {$ifdef Darwin}
      ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctr', 'Left' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Left Control'));
      ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctr', 'Right' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Right Control'));
      {$endif}
      {$ifdef Linux}
      ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctr', 'Left' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Left Ctrl'));
      ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctr', 'Right' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Right Ctrl'));
      {$endif}
      ConfigKeys.Add(TKey.Create(VK_NUMLOCK, 'nmlk', 'Num' + #10 + 'Lock', '', '', '', false, false, '', true, false, 0, '', 'Num Lock'));
      ConfigKeys.Add(TKey.Create(VK_KP_NUMLCK, 'nmlk', 'Num' + #10 + 'Lock', '', '', '', false, false, '', true, false, 0, '', 'Num Lock'));

      //Special chars
      ConfigKeys.Add(TKey.Create(VK_LCL_EQUAL, '=', '= +', 'eql', '=', '+', true, true, '', true, false, 0, '', '', 'Equals'));
      ConfigKeys.Add(TKey.Create(VK_LCL_MINUS, '-', '- _', 'hyph', '-', '_', true, true, '', true, false, 0, '', '', 'Hyphen'));
      ConfigKeys.Add(TKey.Create(VK_LCL_SLASH, '/', '/ ?', 'fsls', '/', '?', true, true, '', true, false, 0, '', '', 'Forward slash'));
      ConfigKeys.Add(TKey.Create(VK_LCL_BACKSLASH, '\', '\ |', 'bsls', '\', '|', true, true, '', true, false, 0, '', '', 'Back slash'));
      ConfigKeys.Add(TKey.Create(VK_LCL_QUOTE, '''', ''' "', 'apos', '''', '"', true, true, '', true, false, 0, '', '', 'Apostrophe'));
      ConfigKeys.Add(TKey.Create(VK_LCL_TILDE, '`', '` ~', 'grav', '`', '~', true, true, '', true, false, 0, '', '', 'Hash'));
      ConfigKeys.Add(TKey.Create(VK_LCL_SEMI_COMMA, ';', '; :', 'scol', ';', ':', true, true, '', true, false, 0, '', '', 'Semi Colon'));
      ConfigKeys.Add(TKey.Create(VK_LCL_COMMA, ',', ', <', 'comm', ',', '<', true, true, '', true, false, 0, '', '', 'Comma'));
      ConfigKeys.Add(TKey.Create(VK_LCL_POINT, '.', '. >', 'perd', '.', '>', true, true, '', true, false, 0, '', '', 'Period'));
      ConfigKeys.Add(TKey.Create(VK_LCL_OPEN_BRACKET, '[', '[ {', 'obrk', '[', '{', true, true, '', true, false, 0, '', '', 'Open Bracket'));
      ConfigKeys.Add(TKey.Create(VK_LCL_CLOSE_BRACKET, ']', '] }', 'cbrk', ']', '}', true, true, '', true, false, 0, '', '', 'Close Bracket'));
      ConfigKeys.Add(TKey.Create(VK_OEM_102, 'intl-\', '', 'int#', 'intl-\', 'intl-\', true, true, '', true, false, 0, '', '', 'International Key')); //International <> key between Left Shift and Z

      //Keypad
      ConfigKeys.Add(TKey.Create(VK_NUMPADENTER, 'kpen', 'Kp' + #10 + 'Enter', '', '', '', false, false, '', true, false, 0, '', '', 'Keypad Enter'));

      //Mouse actions
      ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmou', 'Left' + #10 + 'Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmou', 'Middle' + #10 + 'Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmou', 'Right' + #10 + 'Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_BTN4, '4mou', 'Mouse' + #10 + 'Btn 4'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_BTN5, '5mou', 'Mouse' + #10 + 'Btn 5'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_SCROLL_UP, 'sumo', 'Mouse' + #10 + 'Scroll Up'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_SCROLL_DOWN, 'sdmo', 'Mouse' + #10 + 'Scroll Down'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MOVE_LEFT, 'moul', 'Mouse' + #10 + 'Move Left'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MOVE_RIGHT, 'mour', 'Mouse' + #10 + 'Move Right'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MOVE_UP, 'mouu', 'Mouse' + #10 + 'Move Up'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MOVE_DOWN, 'moud', 'Mouse' + #10 + 'Move Down'));

      //Misc keys
      ConfigKeys.Add(TKey.Create(VK_KEYPAD_TOGGLE, 'kp', 'Kp' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'Keypad Toggle'));
      ConfigKeys.Add(TKey.Create(VK_APPS, 'app', 'App'));
      ConfigKeys.Add(TKey.Create(VK_KP_MENU, 'app', 'App'));
      ConfigKeys.Add(TKey.Create(VK_SHUTDOWN, 'pwdn', 'Power'));
      ConfigKeys.Add(TKey.Create(VK_MIC_MUTE, 'mmut', 'Mic' + #10 + 'Mute', '', '', '', false, false, '', true, false, smallFontSize));
      ConfigKeys.Add(TKey.Create(VK_HYPER, 'hypr', 'Hyper'));
      ConfigKeys.Add(TKey.Create(VK_MEH, 'meh', 'Meh'));
    end
    else //Newer Gen1 devices (RGB, FS Edge, FS Pro, TKO)
    begin
      ConfigKeys.Add(TKey.Create(VK_NEXT, 'pdn', 'Page' + #10 + 'Down', '', '', '', false, false, '', true, false, 0, '', 'Page Down'));
      ConfigKeys.Add(TKey.Create(VK_PRIOR, 'pup', 'Page' + #10 + 'Up', '', '', '', false, false, '', true, false, 0, '', 'Page Up'));
      ConfigKeys.Add(TKey.Create(VK_SCROLL, 'scrlk', 'Scroll' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Scroll Lock'));
      ConfigKeys.Add(TKey.Create(VK_PAUSE, 'pause', 'Pause' + #10 + 'Break', '', '', '', false, false, '', true, false, smallFontSize, '', 'Pause Break'));
      ConfigKeys.Add(TKey.Create(VK_LEFT, 'lft', UnicodeToUTF8(8592), '', '', '', false, false, '', true, false, 10, UNICODE_FONT, '', 'Left'));
      ConfigKeys.Add(TKey.Create(VK_DOWN, 'dwn', UnicodeToUTF8(8595), '', '', '', false, false, '', true, false, 10, UNICODE_FONT, '', 'Down'));
      ConfigKeys.Add(TKey.Create(VK_LSHIFT, 'lshift', 'Left' + #10 + 'Shift', 'lshft', '', '', false, false, '', true, false, 0, '', 'Left Shift'));
      ConfigKeys.Add(TKey.Create(VK_RSHIFT, 'rshift', 'Right' + #10 + 'Shift', 'rshft', '', '', false, false, '', true, false, 0, '', 'Right Shift'));
      ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctrl', 'Left' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Left Ctrl'));
      ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctrl', 'Right' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Right Ctrl'));
      ConfigKeys.Add(TKey.Create(VK_NUMLOCK, 'numlk', 'Num' + #10 + 'Lock', '', '', '', false, false, '', true, false, 0, '', 'Num Lock'));
      ConfigKeys.Add(TKey.Create(VK_KP_NUMLCK, 'numlk', 'Num' + #10 + 'Lock', '', '', '', false, false, '', true, false, 0, '', 'Num Lock'));

      //Special chars
      ConfigKeys.Add(TKey.Create(VK_LCL_EQUAL, '=', '= +', '=', '=', '+', true, true, '', true, false, 0, '', '', 'Equals'));
      ConfigKeys.Add(TKey.Create(VK_LCL_MINUS, '-', '- _', 'hyph', '-', '_', true, true, '', true, false, 0, '', '', 'Hyphen'));
      ConfigKeys.Add(TKey.Create(VK_LCL_SLASH, '/', '/ ?', '/', '/', '?', true, true, '', true, false, 0, '', '', 'Forward slash'));
      ConfigKeys.Add(TKey.Create(VK_LCL_BACKSLASH, '\', '\ |', '\', '\', '|', true, true, '', true, false, 0, '', '', 'Back slash'));
      ConfigKeys.Add(TKey.Create(VK_LCL_QUOTE, '''', ''' "', 'apos', '''', '"', true, true, '', true, false, 0, '', '', 'Apostrophe'));
      ConfigKeys.Add(TKey.Create(VK_LCL_TILDE, '`', '` ~', 'tilde', '`', '~', true, true, '', true, false, 0, '', '', 'Hash'));
      ConfigKeys.Add(TKey.Create(VK_LCL_SEMI_COMMA, ';', '; :', 'colon', ';', ':', true, true, '', true, false, 0, '', '', 'Semi Colon'));
      ConfigKeys.Add(TKey.Create(VK_LCL_COMMA, ',', ', <', 'com', ',', '<', true, true, '', true, false, 0, '', '', 'Comma'));
      ConfigKeys.Add(TKey.Create(VK_LCL_POINT, '.', '. >', 'per', '.', '>', true, true, '', true, false, 0, '', '', 'Period'));
      ConfigKeys.Add(TKey.Create(VK_LCL_OPEN_BRACKET, '[', '[ {', 'obrk', '[', '{', true, true, '', true, false, 0, '', '', 'Open Bracket'));
      ConfigKeys.Add(TKey.Create(VK_LCL_CLOSE_BRACKET, ']', '] }', 'cbrk', ']', '}', true, true, '', true, false, 0, '', '', 'Close Bracket'));
      ConfigKeys.Add(TKey.Create(VK_OEM_102, 'intl-\', '', 'intl\', 'intl-\', 'intl-\', true, true, '', true, false, 0, '', '', 'International Key')); //International <> key between Left Shift and Z

      //Keypad
      ConfigKeys.Add(TKey.Create(VK_NUMPADENTER, 'kpenter', 'Kp' + #10 + 'Enter', 'kpent', '', '', false, false, '', true, false, 0, '', '', 'Keypad Enter'));

      //Mouse actions
      ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmous', 'Left' + #10 + 'Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmous', 'Middle' + #10 + 'Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmous', 'Right' + #10 + 'Mouse'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_BTN4, 'mous4', 'Mouse' + #10 + 'Btn 4'));
      ConfigKeys.Add(TKey.Create(VK_MOUSE_BTN5, 'mous5', 'Mouse' + #10 + 'Btn 5'));

      //Misc keys
      ConfigKeys.Add(TKey.Create(VK_KEYPAD_TOGGLE, 'kptoggle', 'Key-' + #10 + 'pad', '', '', '', false, false, '', true, false, smallFontSize, '', 'Keypad'));
      ConfigKeys.Add(TKey.Create(VK_APPS, 'menu', 'PC' + #10 + 'Menu'));
      ConfigKeys.Add(TKey.Create(VK_KP_MENU, 'menu', 'PC' + #10 + 'Menu'));
      ConfigKeys.Add(TKey.Create(VK_SHUTDOWN, 'shutdn', 'Shut' + #10 + 'down', 'shtdn'));
      ConfigKeys.Add(TKey.Create(VK_MIC_MUTE, 'micmute', 'Mic' + #10 + 'Mute', '', '', '', false, false, '', true, false, smallFontSize));
      ConfigKeys.Add(TKey.Create(VK_HYPER, 'hyper', 'Hyper'));
      ConfigKeys.Add(TKey.Create(VK_MEH, 'meh', 'Meh'));
    end;
  end;

  //Common to all devices
  ConfigKeys.Add(TKey.Create(VK_TAB, 'tab', 'Tab'));
  ConfigKeys.Add(TKey.Create(VK_CAPITAL, 'caps', 'Caps' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Caps Lock'));
  ConfigKeys.Add(TKey.Create(VK_LSPACE, 'lspc', 'Space', 'lspc', ' ', '', false, false, '', true, false, 0, '', 'Left Space')); //User-Defined key for FSEdge
  ConfigKeys.Add(TKey.Create(VK_RSPACE, 'rspc', 'Space', 'rspc', ' ', '', false, false, '', true, false, 0, '', 'Right Space')); //User-Defined key for FSEdge
  ConfigKeys.Add(TKey.Create(VK_MSPACE, 'mspc', 'Space', 'mspc', ' ', '', false, false, '', true, false, 0, '', 'Middle Space')); //User-Defined key for FSEdge
  ConfigKeys.Add(TKey.Create(VK_HOME, 'home', 'Home'));
  ConfigKeys.Add(TKey.Create(VK_END, 'end', 'End'));

  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_SHIFT, 'Shift', 'Shift', 'shift'));
    ConfigKeys.Add(TKey.Create(VK_CONTROL, 'Ctrl', 'Ctrl', 'ctrl'));
  end;

  //F1 to F24
  ConfigKeys.Add(TKey.Create(VK_F1, 'F1'));
  ConfigKeys.Add(TKey.Create(VK_F2, 'F2'));
  ConfigKeys.Add(TKey.Create(VK_F3, 'F3'));
  ConfigKeys.Add(TKey.Create(VK_F4, 'F4'));
  ConfigKeys.Add(TKey.Create(VK_F5, 'F5'));
  ConfigKeys.Add(TKey.Create(VK_F6, 'F6'));
  ConfigKeys.Add(TKey.Create(VK_F7, 'F7'));
  ConfigKeys.Add(TKey.Create(VK_F8, 'F8'));
  ConfigKeys.Add(TKey.Create(VK_F9, 'F9'));
  ConfigKeys.Add(TKey.Create(VK_F10, 'F10'));
  ConfigKeys.Add(TKey.Create(VK_F11, 'F11'));
  ConfigKeys.Add(TKey.Create(VK_F12, 'F12'));
  ConfigKeys.Add(TKey.Create(VK_F13, 'F13'));
  ConfigKeys.Add(TKey.Create(VK_F14, 'F14'));
  ConfigKeys.Add(TKey.Create(VK_F15, 'F15'));
  ConfigKeys.Add(TKey.Create(VK_F16, 'F16'));
  ConfigKeys.Add(TKey.Create(VK_F17, 'F17'));
  ConfigKeys.Add(TKey.Create(VK_F18, 'F18'));
  ConfigKeys.Add(TKey.Create(VK_F19, 'F19'));
  ConfigKeys.Add(TKey.Create(VK_F20, 'F20'));
  ConfigKeys.Add(TKey.Create(VK_F21, 'F21'));
  ConfigKeys.Add(TKey.Create(VK_F22, 'F22'));
  ConfigKeys.Add(TKey.Create(VK_F23, 'F23'));
  ConfigKeys.Add(TKey.Create(VK_F24, 'F24'));

  //a to z
  for i := VK_A to VK_Z do
    ConfigKeys.Add(TKey.Create(i, LowerCase(Chr(i)), UpperCase(Chr(i)), LowerCase(Chr(i)), LowerCase(Chr(i)), Chr(i),
      true, true));

  //Windows specific
  {$ifdef Win64}
  if (GApplication in [APPL_ADV2, APPL_PEDAL]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'enter', 'Enter', '', '', '', false, false, '', true, false, 0, '', 'Enter'));
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspace',  'Back' + #10 + 'Space', '', '', '', false, false, '', true, false, 0, '', 'Backspace'));
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'delete', 'Delete'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'ent', 'Enter', '', '', '', false, false, '', true, false, 0, '', 'Enter'));
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspc',  'Back' + #10 + 'Space', '', '', '', false, false, '', true, false, 0, '', 'Backspace'));
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'del', 'Delete'));
  end;

  ConfigKeys.Add(TKey.Create(VK_LMENU, 'lalt', 'Left' + #10 + 'Alt', '', '', '', false, false, '', true, false, 0, '', 'Left Alt'));
  ConfigKeys.Add(TKey.Create(VK_RMENU, 'ralt', 'Right' + #10 + 'Alt', '', '', '', false, false, '', true, false, 0, '', 'Right Alt'));
  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'win', 'Left' + #10 + 'Win'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'win', 'Right' + #10 + 'Win'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'lwin', 'Left' + #10 + 'Win', '', '', '', false, false, '', true, false, 0, '', 'Left Win'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Right' + #10 + 'Win', '', '', '', false, false, '', true, false, 0, '', 'Right Win'));
  end;

  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_MENU, 'alt', 'Alt'));
  end;
  {$endif}

  //Linux specific
  {$ifdef Linux}
  if (GApplication in [APPL_ADV2, APPL_PEDAL]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'enter', 'Enter', '', '', '', false, false, '', true, false, 0, '', 'Enter'));
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspace',  'Back' + #10 + 'Space', '', '', '', false, false, '', true, false, 0, '', 'Backspace'));
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'delete', 'Delete'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'ent', 'Enter', '', '', '', false, false, '', true, false, 0, '', 'Enter'));
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspc',  'Back' + #10 + 'Space', '', '', '', false, false, '', true, false, 0, '', 'Backspace'));
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'del', 'Delete'));
  end;

  ConfigKeys.Add(TKey.Create(VK_LMENU, 'lalt', 'Left' + #10 + 'Alt', '', '', '', false, false, '', true, false, 0, '', 'Left Alt'));
  ConfigKeys.Add(TKey.Create(VK_RMENU, 'ralt', 'Right' + #10 + 'Alt', '', '', '', false, false, '', true, false, 0, '', 'Right Alt'));
  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'win', 'Left' + #10 + 'Win'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'win', 'Right' + #10 + 'Win'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'lwin', 'Left' + #10 + 'Win', '', '', '', false, false, '', true, false, 0, '', 'Left Win'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Right' + #10 + 'Win', '', '', '', false, false, '', true, false, 0, '', 'Right Win'));
  end;

  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_MENU, 'alt', 'Alt'));
  end;
  {$endif}

  //MacOS specific
  {$ifdef Darwin}
  if (GApplication in [APPL_ADV2, APPL_PEDAL]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'enter', 'Return'));
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspace',  'Delete'));
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'delete', 'Fwd ' + #10 + 'Delete', '', '', '', false, false, '', true, false, 0, '', 'Fwd Delete'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'ent', 'Return'));
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspc',  'Delete'));
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'del', 'Fwd ' + #10 + 'Delete', '', '', '', false, false, '', true, false, 0, '', 'Fwd Delete'));
  end;
  if (GApplication in [APPL_FSEDGE, APPL_FSPRO]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LMENU, 'lalt', 'Left' + #10 + 'Opt', '', '', '', false, false, '', true, False, 0, '', 'Left Option'));
    ConfigKeys.Add(TKey.Create(VK_RMENU, 'ralt', 'Right' + #10 + 'Opt', '', '', '', false, false, '', true, False, 0, '', 'Right Option'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LMENU, 'lopt', 'Left' + #10 + 'Opt', 'lalt', '', '', false, false, '', true, False, 0, '', 'Left Option'));
    ConfigKeys.Add(TKey.Create(VK_RMENU, 'ropt', 'Right' + #10 + 'Opt', 'ralt', '', '', false, false, '', true, False, 0, '', 'Right Option'));
  end;

  if (IsGen2Device(GApplication)) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'lwin', 'Cmd', '', '', '', false, false, '', true, false, 0, '', 'Cmd', 'Command'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Right' + #10 + 'Cmd', '', '', '', false, false, '', true, false, 0, '', 'Right Cmd', 'Right Command'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'Cmd', 'Cmd', 'lwin', '', '', false, false, '', true, false, 0, '', '', 'Command'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Right' + #10 + 'Cmd', '', '', '', false, false, '', true, false, 0, '', '', 'Right Command'));
    ConfigKeys.Add(TKey.Create(VK_LCMD_MAC, 'lwin', 'Left' + #10 + 'Cmd', '', '', '', false, false, '', true, false, 0, '', '', 'Left Command'));
  end;

  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_MENU, 'Opt', 'Opt', 'alt', '', '', false, false, '', true, false, 0, '', '', 'Option'));
  end;
  {$endif}

  //Custom for special events
  ConfigKeys.Add(TKey.Create(VK_SPEED1, 'speed1', '', 'speed1', '', '', false, false, '', False, FALSE, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_SPEED3, 'speed3', '', 'speed3', '', '', false, false, '', False, FALSE, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_SPEED5, 'speed5', '', 'speed5', '', '', false, false, '', False, FALSE, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_1, 's1', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_2, 's2', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_3, 's3', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_4, 's4', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_5, 's5', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_6, 's6', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_7, 's7', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_8, 's8', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_MACRO_SPEED_9, 's9', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  if not(GApplication in [APPL_RGB, APPL_TKO]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_125MS, 'd125', '', 'd125', '', '', false, false, '', False, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_500MS, 'd500', '', 'd500', '', '', false, false, '', False, false, 0, '', '', SKIP_SEARCH));
  end;
  ConfigKeys.Add(TKey.Create(VK_RAND_DELAY, 'dran', '', 'dran', '', '', false, false, '', False, FALSE, 0, '', '', SKIP_SEARCH));

  //Timing delays 1 to 999
  for i := MIN_TIMING_DELAY to MAX_TIMING_DELAY do
    ConfigKeys.Add(TKey.Create(VK_MIN_DELAY + (i - 1), 'd' + Format('%.3d', [i]), '', 'd' + Format('%.3d', [i]), '', '', false, false, '', False, false, 0, '', '', SKIP_SEARCH));

  //Media keys with unicode
  mediaFontSize := 4;
  if (CanUseUnicode) then
  begin
    if (GApplication in [APPL_RGB, APPL_TKO]) then
    begin
      ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute', UnicodeToUTF8(128264), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Mute'));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-', UnicodeToUTF8(128265), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Volume Down'));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+', UnicodeToUTF8(128266), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Volume Up'))
    end
    else
    begin
      ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute', UnicodeToUTF8(128360), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Mute'));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-', UnicodeToUTF8(128361), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Volume Down'));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+', UnicodeToUTF8(128362), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Volume Up'));
    end;

    ConfigKeys.Add(TKey.Create(VK_MEDIA_STOP, 'stop', UnicodeToUTF8(9724), '', '', '', false, false, '', true, false, 0, UNICODE_FONT, '', 'Stop'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PREV_TRACK, 'prev', UnicodeToUTF8(9198), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Previous Track'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_NEXT_TRACK, 'next', UnicodeToUTF8(9197), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Next Track'));
    ConfigKeys.Add(TKey.Create(VK_KP_PLAY, 'play', UnicodeToUTF8(9199), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Play/Pause'));
    ConfigKeys.Add(TKey.Create(VK_KP_PREV, 'prev', UnicodeToUTF8(9198), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Previous'));
    ConfigKeys.Add(TKey.Create(VK_KP_NEXT, 'next', UnicodeToUTF8(9197), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Next'));
    ConfigKeys.Add(TKey.Create(VK_KP_MUTE, 'mute', UnicodeToUTF8(128360), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Mute'));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLDOWN, 'vol-', UnicodeToUTF8(128361), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Volume Down'));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLUP, 'vol+', UnicodeToUTF8(128362), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Volume Up'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_FORWARD, 'fwrd', UnicodeToUTF8(9193), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Forward'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_REWIND, 'rewd', UnicodeToUTF8(9194), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Rewind'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PAUSE, 'cpau', UnicodeToUTF8(9208), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Pause'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_EJECT, 'ejct', UnicodeToUTF8(9167), '', '', '', false, false, '', true, false, 0, UNICODE_FONT, '', 'Eject'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_RECORD, 'recr', UnicodeToUTF8(9210), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Record'));
    ConfigKeys.Add(TKey.Create(VK_NULL, 'null', UnicodeToUTF8(8855), '', '', '', false, false, '', true, false, 0, UNICODE_FONT, '', 'Null'));

    if IsGen2Device(GApplication) then
    begin
      ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY, 'play', UnicodeToUTF8(9654), '', '', '', false, false, '', true, false, 0, UNICODE_FONT, '', 'Play'));
      ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'plpa', UnicodeToUTF8(9199), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Play/Pause'));
      ConfigKeys.Add(TKey.Create(VK_LED, 'ledt', UnicodeToUTF8(9728), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Led'))
    end
    else
    begin
      ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'play', UnicodeToUTF8(9199), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Play/Pause'));
      ConfigKeys.Add(TKey.Create(VK_LED, 'LED', UnicodeToUTF8(9728), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Led'));
    end;
    ConfigKeys.Add(TKey.Create(VK_LED_PLUS, 'led+', UnicodeToUTF8(128262), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Led +'));
    ConfigKeys.Add(TKey.Create(VK_LED_MINUS, 'led-', UnicodeToUTF8(128261), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, '', 'Led -'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute', 'Mute'));
    ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-', 'Vol-', '', '', '', false, false, '', true, false, 0, '', '', 'Volume Down'));
    ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+', 'Vol+', '', '', '', false, false, '', true, false, 0, '', '', 'Volume Up'));

    ConfigKeys.Add(TKey.Create(VK_MEDIA_STOP, 'stop', 'Stop'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PREV_TRACK, 'prev', 'Prev', '', '', '', false, false, '', true, false, 0, '', '', 'Previous Track'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_NEXT_TRACK, 'next', 'Next', '', '', '', false, false, '', true, false, 0, '', '', 'Next Track'));
    ConfigKeys.Add(TKey.Create(VK_KP_PLAY, 'play', 'Play'));
    ConfigKeys.Add(TKey.Create(VK_KP_PREV, 'prev', 'Prev', '', '', '', false, false, '', true, false, 0, '', '', 'Previous'));
    ConfigKeys.Add(TKey.Create(VK_KP_NEXT, 'next', 'Next'));
    ConfigKeys.Add(TKey.Create(VK_KP_MUTE, 'mute', 'Mute'));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLDOWN, 'vol-', 'Vol-', '', '', '', false, false, '', true, false, 0, '', '', 'Volume Down'));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLUP, 'vol+', 'Vol+', '', '', '', false, false, '', true, false, 0, '', '', 'Volume Up'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_FORWARD, 'fwrd', 'Forward'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_REWIND, 'rewd', 'Rewind'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PAUSE, 'cpau', 'Pause'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_EJECT, 'ejct', 'Eject'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_RECORD, 'recr', 'Record'));

    if IsGen2Device(GApplication) then
    begin
      ConfigKeys.Add(TKey.Create(VK_NULL, 'null', 'NUL', '', '', '', false, false, '', true, false, 0, '', '', 'Null'));
      ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY, 'play',  'Play'));
      ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'plpa', 'Play' + #10 + 'Pause'));
      ConfigKeys.Add(TKey.Create(VK_LED, 'ledt', 'LED'))
    end
    else
    begin
      ConfigKeys.Add(TKey.Create(VK_NULL, 'null', ' ', '', '', '', false, false, '', true, false, 0, '', '', 'Null'));
      ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'play', 'Play' + #10 + 'Pause'));
      ConfigKeys.Add(TKey.Create(VK_LED, 'LED', 'LED'));
    end;
    ConfigKeys.Add(TKey.Create(VK_LED_PLUS, 'led+', 'Led+'));
    ConfigKeys.Add(TKey.Create(VK_LED_MINUS, 'led-', 'Led-'));
  end;

  //Misc keys
  ConfigKeys.Add(TKey.Create(VK_MEDIA_RANDOM_PLAY, 'ranp', 'Rand' + #10 + 'Play', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_SKIP, 'plsk', 'Play' + #10 + 'Skip', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_CALC, 'calc', 'Calc', '', '', '', false, false, '', true, false, 0, '', '', 'Calculator'));
  ConfigKeys.Add(TKey.Create(VK_KP_CALC, 'calc', 'Calc', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_DIF_PRESS_REL, '{ }', '', ' ', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROGRAM, '', 'Pro-' + #10 + 'gram', '', '', '', false, false, '', true, false, smallFontSize, '', '', 'Program'));
  ConfigKeys.Add(TKey.Create(VK_FUNCTION, 'Fn', 'Fn', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_SMARTSET, 'ss', ' ', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH, 'imgSmartSet'));
  ConfigKeys.Add(TKey.Create(VK_STOP_MACRO_PLAYBACK, 'mstp', 'Stop' + #10 + 'macro playback', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_PEDAL, 'pedl', 'Tab', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));

  if (GApplication in [APPL_ADV2]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LPEDAL, 'lp-tab', 'Tab', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_MPEDAL, 'mp-kpshf', 'Kp' + #10 + 'Shift', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
    ConfigKeys.Add(TKey.Create(VK_RPEDAL, 'rp-kpent', 'Kp' + #10 + 'Enter', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  end;

  //Layer shift/toggle keys
  ConfigKeys.Add(TKey.Create(VK_KEYPAD, '', 'Key-' + #10 + 'pad', '', '', '', false, false, '', true, false, smallFontSize, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_KEYPAD_SHIFT, 'kpshft', 'Kp' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Kp Shift'));
  ConfigKeys.Add(TKey.Create(VK_BASE_LAYER_SHIFT, 'defs', 'Base' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Base Shift'));
  ConfigKeys.Add(TKey.Create(VK_BASE_LAYER_TOGGLE, 'deft', 'Base' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'Base Toggle'));
  ConfigKeys.Add(TKey.Create(VK_KP_LAYER_SHIFT, 'keys', 'Kp' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Kp Shift'));
  ConfigKeys.Add(TKey.Create(VK_KP_LAYER_TOGGLE, 'keyt', 'Kp' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'Keypad Toggle'));
  ConfigKeys.Add(TKey.Create(VK_LFN_LAYER_SHIFT, 'lfn', 'Left Fn'+ #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Left Fn Shift'));
  ConfigKeys.Add(TKey.Create(VK_RFN_LAYER_SHIFT, 'rfn', 'Right Fn'+ #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Right Fn Shift'));
  ConfigKeys.Add(TKey.Create(VK_FN1_LAYER_SHIFT, 'fn1s', 'Fn1' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Fn1 Shift'));
  ConfigKeys.Add(TKey.Create(VK_FN1_LAYER_TOGGLE, 'fn1t', 'Fn1' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'Fn1 Toggle'));
  ConfigKeys.Add(TKey.Create(VK_FN2_LAYER_SHIFT, 'fn2s', 'Fn2' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Fn2 Shift'));
  ConfigKeys.Add(TKey.Create(VK_FN2_LAYER_TOGGLE, 'fn2t', 'Fn2' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'Fn2 Toggle'));
  ConfigKeys.Add(TKey.Create(VK_FN3_LAYER_SHIFT, 'fn3s', 'Fn3' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'Fn3 Shift'));
  ConfigKeys.Add(TKey.Create(VK_FN3_LAYER_TOGGLE, 'fn3t', 'Fn3' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'Fn3 Toggle'));

  //Profile keys
  ConfigKeys.Add(TKey.Create(VK_PROFILE_0, 'pro0', 'Profile 0', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_1, 'pro1', 'Profile 1', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_2, 'pro2', 'Profile 2', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_3, 'pro3', 'Profile 3', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_4, 'pro4', 'Profile 4', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_5, 'pro5', 'Profile 5', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_6, 'pro6', 'Profile 6', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_7, 'pro7', 'Profile 7', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_8, 'pro8', 'Profile 8', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_PROFILE_9, 'pro9', 'Profile 9', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));

  //Hotkeys
  ConfigKeys.Add(TKey.Create(VK_HK0, 'hk0', 'LOGO', '', '', '', false, false, '', true, false, 0, '', 'hotkey 0', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK1, 'hk1', 'HK1', '', '', '', false, false, '', true, false, 0, '', 'hotkey 1', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK2, 'hk2', 'HK2', '', '', '', false, false, '', true, false, 0, '', 'hotkey 2', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK3, 'hk3', 'HK3', '', '', '', false, false, '', true, false, 0, '', 'hotkey 3', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK4, 'hk4', 'HK4', '', '', '', false, false, '', true, false, 0, '', 'hotkey 4', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK5, 'hk5', 'HK5', '', '', '', false, false, '', true, false, 0, '', 'hotkey 5', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK6, 'hk6', 'HK6', '', '', '', false, false, '', true, false, 0, '', 'hotkey 6', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK7, 'hk7', 'HK7', '', '', '', false, false, '', true, false, 0, '', 'hotkey 7', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_HK8, 'hk8', 'HK8', '', '', '', false, false, '', true, false, 0, '', 'hotkey 8', SKIP_SEARCH));
  if (GApplication in [APPL_RGB, APPL_TKO]) then
    ConfigKeys.Add(TKey.Create(VK_HK9, 'hk9', 'Fn' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'hotkey 9', SKIP_SEARCH))
  else
    ConfigKeys.Add(TKey.Create(VK_HK9, 'hk9', 'Fn' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'hotkey 9', SKIP_SEARCH));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_TKO]) then
  begin
    if (CanUseUnicode) then
      ConfigKeys.Add(TKey.Create(VK_HK10, 'hk10', UnicodeToUTF8(9728), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, 'hotkey 10', SKIP_SEARCH))
    else
      ConfigKeys.Add(TKey.Create(VK_HK10, 'hk10', 'LED', '', '', '', false, false, '', true, false, 0, '', 'hotkey 10', SKIP_SEARCH));
  end
  else
    ConfigKeys.Add(TKey.Create(VK_HK10, 'hk10', 'PC' + #10 + 'Menu', '', '', '', false, false, '', true, false, 0, '', 'hotkey 10', SKIP_SEARCH));

  //TKO Edge Lighting
  ConfigKeys.Add(TKey.Create(VK_EDGE_L1, 'L1', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L2, 'L2', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L3, 'L3', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L4, 'L4', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L5, 'L5', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L6, 'L6', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L7, 'L7', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L8, 'L8', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_L9, 'L9', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B1, 'B1', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B2, 'B2', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B3, 'B3', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B4, 'B4', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B5, 'B5', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B6, 'B6', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B7, 'B7', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B8, 'B8', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B9, 'B9', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B10, 'B10', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B11, 'B11', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B12, 'B12', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B13, 'B13', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B14, 'B14', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_B15, 'B15', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R1, 'R1', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R2, 'R2', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R3, 'R3', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R4, 'R4', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R5, 'R5', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R6, 'R6', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R7, 'R7', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R8, 'R8', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  ConfigKeys.Add(TKey.Create(VK_EDGE_R9, 'R9', '', '', '', '', false, false, '', true, false, 0, '', '', SKIP_SEARCH));
  //TKO Edge Lighting

  //FOR ADVANTAGE 2 KEYBOARD / Internal keyboard app
  if (GApplication in [APPL_ADV2]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_KP_KPSHIFT, 'kpshft', 'Kp' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_KP_ENTER1, 'kpenter1', 'Kp' + #10 + 'Enter'));
    ConfigKeys.Add(TKey.Create(VK_KP_ENTER2, 'kpenter2', 'Kp' + #10 + 'Enter'));
  end;

  result := ConfigKeys;
end;

function GetHTMLColor(color: TColor): string;
begin
  Result := '#' +
    { red value }
    IntToHex( GetRValue( color ), 2 ) +
    { green value }
    IntToHex( GetGValue( color ), 2 ) +
    { blue value }
    IntToHex( GetBValue( color ), 2 );
end;

function GetColorHTML(html: string): TColor;
var
  iRed: Integer;
  iGreen: Integer;
  iBlue: Integer;
begin
  try
    iRed := StrToInt('$' + html[1] + html[2]);
    iGreen := StrToInt('$' + html[3] + html[4]);
    iBlue := StrToInt('$' + html[5] + html[6]);
    result := RGB(iRed, iGreen, iBlue);
  except
    result := clWhite;
  end;
end;

function RGBColorToString(color: Tcolor; setNoneAsBlack: boolean): string;
begin
  if (color = clNone) then
  begin
    result := '';
    if setNoneAsBlack then
      result := '[0][0][0]';
  end
  else
    result := '[' + IntToStr(GetRValue(color)) + '][' + IntToStr(GetGValue(color)) + '][' + IntToStr(GetBValue(color)) + ']'
end;

function RGBStringToColor(var sRGB: string; defaultColor: TColor = clNone): Tcolor;
var
  keyStart: integer;
  keyEnd: integer;
  RValue: integer;
  GValue: integer;
  BValue: integer;
  sValue: string;
  iValue: integer;
  j: integer;
begin
  result := defaultColor;

  //Load color values
  for j := 1 to 3 do
  begin
    keyStart := Pos(SK_START, sRGB);
    keyEnd := Pos(SK_END, sRGB);
    sValue := Copy(sRGB, keyStart + 1, keyEnd - 2);
    Delete(sRGB, 1, keyEnd); //removes value

    iValue := ConvertToInt(sValue);
    case j of
      1: RValue := iValue;
      2: GValue := iValue;
      3: BValue := iValue;
    end;
  end;

  if (RValue >= 0) and (GValue >= 0) and (BValue >= 0) then
    result := RGB(RValue, GValue, BValue)
end;

function LedSpeedToString(LedSpeed: integer): string;
var
  speed: integer;
begin
  if (LedSpeed >= LED_SPEED_MIN) and (LedSpeed <= LED_SPEED_MAX) then
    speed := LedSpeed
  else
    speed := DEFAULT_LED_SPEED;

  result := '[' + LED_SPEED_EDGE + IntToStr(speed) + ']';
end;

function LedDirectionToString(LedDirection: integer): string;
var
  direction: integer;
  dirText: string;
begin
  if (LedDirection in [LED_DIR_DOWN_INT, LED_DIR_LEFT_INT, LED_DIR_UP_INT, LED_DIR_RIGHT_INT]) then
    direction := LedDirection
  else
    direction := DEFAULT_LED_DIR_INT;

  case direction of
    LED_DIR_DOWN_INT: dirText := LED_DIR_DOWN;
    LED_DIR_LEFT_INT: dirText := LED_DIR_LEFT;
    LED_DIR_UP_INT: dirText := LED_DIR_UP;
    LED_DIR_RIGHT_INT: dirText := LED_DIR_RIGHT;
  end;

  result := '[' + LED_DIR_EDGE + dirText + ']';
end;

function ReadURLGet(url:string):string;
{$ifdef Darwin}
var
   sendAndReceived: TNSHTTPSendAndReceive;
{$endif}
begin
  try
    {$ifdef Win64}
    result := httpRequest(url);
    {$endif}
    {$ifdef Linux}
    result := httpRequest(url);
    {$endif}

    {$ifdef Darwin}
    sendAndReceived := TNSHTTPSendAndReceive.Create;
    sendAndReceived.Address:= url;
    sendAndReceived.SendAndReceive(result);
    {$endif}
  finally
    {$ifdef Darwin}
    FreeAndNil(sendAndReceived);
    {$endif}
  end;
end;

function GetDesktopDirectory: string;
{$ifdef Win64}
var
  PIDL: PItemIDList;
  InFolder: array[0..MAX_PATH] of Char;
  {$endif}
begin
  {$ifdef Win64}
  { Get the desktop location }
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
  SHGetPathFromIDList(PIDL, InFolder);
  result := AppendPathDelim(InFolder);
  {$endif}

  {$ifdef Darwin}
  result := AppendPathDelim(GetUserDir + 'Desktop')
  {$endif}

  {$ifdef Linux}
  result := AppendPathDelim(GetUserDir + 'Desktop')
  {$endif}
end;

//Get Major, Minor and Revision numbers
procedure GetVersionNumbers(versionNumber: string; var major: integer;
  var minor: integer; var revision: integer);
var
  sTemp: string;
  sVersion: string;
  j: integer;
begin
  sTemp := versionNumber;
  for j := 1 to 3 do
  begin
    if (Pos('.', sTemp) <> 0) then
    begin
      sVersion := Copy(sTemp, 1, Pos('.', sTemp) - 1);
      Delete(sTemp, 1, Pos('.', sTemp));
    end
    else
    begin
      sVersion := sTemp;
      Delete(sTemp, 1, Length(sTemp));
    end;

    case j of
      1: major := ConvertToInt(sVersion, 0);
      2: minor := ConvertToInt(sVersion, 0);
      3: revision := ConvertToInt(sVersion, 0);
    end;
  end;
end;

function IsVersionEqual(sourceMajor, sourceMinor, sourceRevision: integer;
  destMajor, destMinor, destRevision: integer): boolean;
begin
  result := (sourceMajor = destMajor) and (sourceMinor = destMinor) and (sourceRevision = destRevision);
end;

function IsVersionBiggerOrEqual(sourceMajor, sourceMinor, sourceRevision: integer; destMajor, destMinor, destRevision: integer): boolean;
begin
  if (sourceMajor > destMajor) then //Major bigger
    result := true
  else if (sourceMajor < destMajor) then //Major smaller
    result := false
  else //Major equal
  begin
    if (sourceMinor > destMinor) then //Minor bigger
      result := true
    else if (sourceMinor < destMinor) then //Minor smaller
      result := false
    else //Minor equal
    begin
      if (sourceRevision > destRevision) then //Revision bigger
        result := true
      else if (sourceRevision < destRevision) then //Revision smaller
        result := false
      else //Revision equal
        result := true;
    end;
  end;
end;

function IsVersionSmaller(sourceMajor, sourceMinor, sourceRevision: integer;
  destMajor, destMinor, destRevision: integer): boolean;
begin
  if (sourceMajor > destMajor) then //Major bigger
    result := false
  else if (sourceMajor < destMajor) then //Major smaller
    result := true
  else //Major equal
  begin
    if (sourceMinor > destMinor) then //Minor bigger
      result := false
    else if (sourceMinor < destMinor) then //Minor smaller
      result := true
    else //Minor equal
    begin
      if (sourceRevision > destRevision) then //Revision bigger
        result := false
      else if (sourceRevision < destRevision) then //Revision smaller
        result := true
      else //Revision equal
        result := false;
    end;
  end;
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

function GetDeviceInformation(aDevice: TDevice): boolean;
var
  driveList: TStringList;
  i: integer;
  dirFirmware: string;
  driveName: string;
  kbDrive: string;
  driveLetter: string;
  rootFolder: string;
  driveName1: string;
  driveName2: string;
  driveName3: string;
  firmwareFolder: string;
  firmwareFile: string;
begin
  result := false;
  kbDrive := '';
  rootFolder := '';
  firmwareFolder := VERSION_FOLDER;
  firmwareFile := VERSION_FILE;
  driveName1 := aDevice.VDriveName;
  driveName2 := '';
  driveName3 := '';
  if (aDevice.DeviceNumber = APPL_ADV2) then
  begin
    firmwareFolder := VERSION_FOLDER_ADV360;
    driveName2 := ADV2_DRIVE_2;
    driveName3 := ADV2_DRIVE_3;
  end
  else if (aDevice.DeviceNumber = APPL_PEDAL) then
  begin
    firmwareFolder := VERSION_FOLDER_PEDAL;
    driveName2 := PEDAL_DRIVE_2;
  end
  else if (aDevice.DeviceNumber = APPL_ADV360) then
  begin
    firmwareFolder := VERSION_FOLDER_ADV360;
    firmwareFile := VERSION_FILE_ADV360;
  end;

  //Reset device values
  aDevice.DriveLetter := '';
  aDevice.RootFolder := '';
  aDevice.Connected := false;

  {$ifdef Win64}
  driveList := GetAvailableDrives;
  for i := 0 to driveList.Count - 1 do
  begin
    rootFolder := IncludeTrailingBackslash(driveList[i]);
    driveLetter := UpperCase(Copy(rootFolder, 1, 1));
    dirFirmware := IncludeTrailingBackslash(rootFolder + firmwareFolder);
    driveName := UpperCase(Trim(GetVolumeLabel(rootFolder[1])));

    if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + firmwareFile)) and
      ((driveName = driveName1) or (driveName = driveName2) or (driveName = driveName3)) then
    begin
      aDevice.DriveLetter := driveLetter;
      aDevice.RootFolder := rootFolder;
      aDevice.Connected := true;
      aDevice.ReadWriteAccess := DirectoryIsWritable(dirFirmware) and FileIsWritable(dirFirmware + firmwareFile);
      result := true;
    end;
  end;
  FreeAndNil(driveList);
  {$endif}

  //MacOS
  {$ifdef Darwin}
  for i := 1 to 3 do
  begin
    case i of
     1: kbDrive := driveName1;
     2: kbDrive := driveName2;
     3: kbDrive := driveName3;
    end;
    if (kbDrive <> '') then
    begin
      driveLetter := '';
      driveName := IncludeTrailingBackslash('/VOLUMES/' + kbDrive);
      dirFirmware := IncludeTrailingBackslash(driveName + firmwareFolder);

      if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + firmwareFile)) then
      begin
        aDevice.DriveLetter := driveLetter;
        aDevice.RootFolder := IncludeTrailingBackslash(driveName);
        aDevice.Connected := true;
        aDevice.ReadWriteAccess := DirectoryIsWritable(dirFirmware) and FileIsWritable(dirFirmware + firmwareFile);
        result := true;
      end;
    end;
  end;
  {$endif}
end;

function LoadFontFromRes(FontName: string):THandle;
{$ifdef Win64}
var
  ResHandle: HRSRC;
  ResSize, NbFontAdded: Cardinal;
  ResAddr: HGLOBAL;
{$endif}
begin
{$ifdef Win64}
  ResHandle := FindResource(system.HINSTANCE, PChar(FontName), RT_RCDATA);
  if ResHandle = 0 then
    RaiseLastOSError;
  ResAddr := LoadResource(system.HINSTANCE, ResHandle);
  if ResAddr = 0 then
    RaiseLastOSError;
  ResSize := SizeOfResource(system.HINSTANCE, ResHandle);
  if ResSize = 0 then
    RaiseLastOSError;
  Result := AddFontMemResourceEx(Pointer(ResAddr), ResSize, nil, @NbFontAdded);
  if Result = 0 then
    RaiseLastOSError;
{$else}
  Result := 0;
{$endif}
end;

function SaveToRegistry(keyName: string; value: string): boolean;
var
  RegNGFS: TRegistry;
begin
  RegNGFS := TRegistry.Create;
  try
     RegNGFS.RootKey := HKEY_CURRENT_USER;
     if RegNGFS.OpenKey(REGISTRY_KINESIS, TRUE) then
     begin
       RegNGFS.WriteString(keyName, value);
     end;
     result := true;
  finally
    RegNGFS.Free;
  end;
end;

function ReadFromRegistry(keyName: string): string;
var
  RegNGFS: TRegistry;
begin
  result := '';
  RegNGFS := TRegistry.Create;
  try
     RegNGFS.RootKey := HKEY_CURRENT_USER;
     if RegNGFS.OpenKey(REGISTRY_KINESIS, TRUE) then
     begin
        result := RegNGFS.ReadString(keyName);
     end;
  finally
    RegNGFS.Free;
  end;
end;

function ShowNotification(hideNotif: boolean): boolean;
begin
  result := (not(hideNotif) and not(GHideAllNotifs)) or (GShowAllNotifs);
end;

initialization
  KINESIS_BLUE := RGB(0, 114, 206);
  KINESIS_BLUE_EDGE := RGB(30, 154, 214);
  KINESIS_ORANGE := RGB(255, 134, 58);
  KINESIS_LIGHT_GRAY_FS := RGB(47, 56, 61);
  KINESIS_DARK_GRAY_FS := RGB(38, 38, 38);
  KINESIS_GRAY_EDGE2 := RGB(150, 150, 150);
  KINESIS_DARK_GRAY_RGB := RGB(25, 25, 25);
  KINESIS_MED_GRAY_RGB := RGB(50, 50, 50);
  KINESIS_FONT_COLOR_RGB := RGB(210, 210, 210);
  KINESIS_LIGHT_GRAY_ADV360 := RGB(195, 205, 210);
  KINESIS_LIGHTER_GRAY_ADV360 := RGB(184, 184, 184);
  KINESIS_DARK_GRAY_ADV360 := RGB(170, 180, 190);
  KINESIS_GREEN_OFFICE := RGB(105, 199, 157);
  KINESIS_GRAY_BACKCOLOR := RGB(175, 175, 175);
  KINESIS_BUTTON_ADV360 := RGB(100, 110, 120);
  GApplicationTitle := 'SmartSet App';
  GDesktopMode := false;
  GDemoMode := false;
  GShowAllNotifs := false;
  GHideAllNotifs := false;
  GActiveDevice := nil;

  //Windows
  {$ifdef Win64}
  GApplicationName := 'SmartSet App (Win)';
  GApplicationPath := IncludeTrailingBackslash(ExtractFileDir(ParamStr(0)));
  GExecutablePath := GApplicationPath;
  {$endif}

  //Linux
  {$ifdef Linux}
  GApplicationName := 'SmartSet App (Linux)';
  GApplicationPath := IncludeTrailingBackslash(ExtractFileDir(ParamStr(0)));
  GExecutablePath := GApplicationPath;
  {$endif}

  //MacOS
  {$ifdef Darwin}
  GApplicationName := 'SmartSet App (Mac)';

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
  GExecutablePath := GApplicationPath;
  {$endif}

  //SetBaseDirectory;
  ResetAppPaths;
end.
