//CreoSource Inc. (info@creosource.com)
//Constants and utility fonctions
unit u_const;

{$mode objfpc}{$H+}
{$ifdef Darwin}
  {$modeswitch objectivec1}
{$endif}


interface

uses
  {$ifdef Win32}Windows, shlobj, w32internetaccess, {$endif}
  {$ifdef Darwin}LCLIntf, ns_url_request, CocoaUtils, CocoaAll, {$endif}
  lcltype, Classes, SysUtils, FileUtil, Controls, Graphics, character, LazUTF8, U_Keys, Buttons,
  HSSpeedButton, internetaccess, LazFileUtils, u_kinesis_device;

type
  TPedal = (pNone, pLeft, pMiddle, pRight, pJack1, pJack2, pJack3, pJack4);

  TKeyState = (ksNone, ksDown, ksUp);

  TSaveState = (ssNone, ssModified);

  TModifiers = (moShift, moAlt, moCtrl, moWin);

  TMouseEvent = (meNone, meLeftClick, meMiddleClick, meRightClick);

  TKeyMode = (kmSingle, kmMulti);

  TMsgDlgTypeApp  = (mtWarning, mtError, mtInformation, mtConfirmation,
                    mtCustom, mtFSEdge, mtFSPro);

  TLedMode = (lmNone, lmIndividual, lmMonochrome, lmBreathe, lmSpectrum,
              lmWave, lmReactive, lmStarlight, lmRebound, lmRipple,
              lmLoop, lmPulse, lmRain, lmPitchBlack, lmDisabled);

  TZoneType = (ztAll, ztNumber, ztWASD, ztFunction, ztGame, ztArrow, ztLeftModule, ztRightModule);

  TProfileMode = (pmNone, pmSelect, pmSaveAs);

  TCusWinState = (cwNormal, cwMaximized);

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
    ProgramKeyLock: boolean;
    LedMode: string;
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

  TCustomButtons = array of TCustomButton;

  TKeysPos = array of TKeyPos;

{$ifdef Win32}
type
    LPDWORD = ^DWORD;
function AddFontMemResourceEx(pbFont: Pointer; cbFont: DWORD; pdv: Pointer; pcFonts: LPDWORD): LongWord; stdcall;
  external 'gdi32.dll' Name 'AddFontMemResourceEx';
function RemoveFontMemResourceEx(fh: LongWord): LongBool; stdcall;
  external 'gdi32.dll' Name 'RemoveFontMemResourceEx';
{$endif}

var
  GApplication: integer; //Id of application
  GApplicationName: string; //Name of application
  GApplicationTitle: string; //Title of application
  GApplicationPath: string; //Application start path
  GExecutablePath: string; //Executable path
  GPedalsFile: string; //Location of Pedals.txt file
  GPedalsFilePath: string; //Location of Pedals.txt file folder
  GLayoutFilePath: string; //Location of layout file folder (FS Edge)
  GLedFilePath: string; //Location of led file folder (FS Edge)
  GSettingsFilePath: string; //Location of settings files (FS Edge)
  GFirmwareFilePath: string; //Location of settings files (FS Edge)
  GVersionFile: string; //Location of the version.txt file
  GStateFile: string; //Location of state.txt file
  GAppSettingsFile: string; //Location of appsettings.txt file
  GDebugMode: boolean; //Debug Mode On or Off
  GDebugFirmware: boolean; //Debug Firmware On or Off
  GDevMode: boolean; //Dev Mode On or Off
  GDesktopMode: boolean; //Desktop Mode
  GDemoMode: boolean; //Demo Mode
  KINESIS_BLUE: TColor; //Kinesis blue color
  KINESIS_BLUE_EDGE: TColor; //Kinesis blue color for FS app
  KINESIS_ORANGE: TColor; //Kinesis orange color
  KINESIS_LIGHT_GRAY_FS: TColor; //Kinesis light gray color for FS app
  KINESIS_DARK_GRAY_FS: TColor; //Kinesis dark gray color for FS app
  KINESIS_GRAY_EDGE2: TColor; //Kinesis gray color for Edge v2 app
  KINESIS_DARK_GRAY_RGB: TColor; //Kinesis dark gray color for RGB app
  KINESIS_MED_GRAY_RGB: TColor; //Kinesis medium gray color for RGB app
  KINESIS_FONT_COLOR_RGB: TColor; //Kinesis font color for RGB app

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
function IsVersionBiggerOrEqual(sourceMajor, sourceMinor, sourceRevision: integer; destMajor, destMinor, destRevision: integer): boolean;
function IsVersionSmaller(sourceMajor, sourceMinor, sourceRevision: integer; destMajor, destMinor, destRevision: integer): boolean;
function GetPrefString(const KeyName : string) : string;
function IsDarkTheme:boolean;
function IsDeviceConnected(aDevice: TDevice): boolean;
function LoadFontFromRes(FontName: string):THandle;

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
  KEYPAD_KEY = 'kp-';
  KEYPAD_KEY_EDGE = 'fn ';
  KP_PREFIX_LENGTH = 3;

  //Various constants
  DIFF_PRESS_REL_TEXT = '{ }';
  MACRO_SPEED_TEXT = 'speed';
  MACRO_SPEED_TEXT_EDGE = 's';
  MACRO_REPEAT_EDGE = 'x';
  GLOBAL_SPEED = 'Global';
  MACRO_FREQ_MIN_ADV2 = 0;
  MACRO_FREQ_MIN_FS = 0;
  MACRO_FREQ_MIN_RGB = 1;
  MACRO_FREQ_MAX_FS = 9;
  MACRO_FREQ_MAX_RGB = 9;
  DEFAULT_MACRO_FREQ_ADV2 = 0;
  DEFAULT_MACRO_FREQ_FS = 0;
  DEFAULT_MACRO_FREQ_RGB = 1;
  MACRO_SPEED_MIN_ADV2 = 0;
  MACRO_SPEED_MIN_FS = 0;
  MACRO_SPEED_MIN_RGB = 1;
  MACRO_SPEED_MAX_ADV2 = 9;
  MACRO_SPEED_MAX_FS = 9;
  MACRO_SPEED_MAX_RGB = 9;
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

  //Config modes
  CONFIG_LAYOUT = 0;
  CONFIG_LIGHTING = 1;

  //Application IDs
  APPL_PEDAL = 0;
  APPL_ADV2 = 1;
  APPL_FSEDGE = 2;
  APPL_FSPRO = 3;
  APPL_RGB = 4;
  APPL_CROSSKP = 5;
  APPL_CROSSTKO = 6;

  //Led modes
  LED_MONO = '[mono]';
  LED_BREATHE = '[breathe]';
  LED_SPECTRUM = '[spectrum]';
  LED_WAVE = '[wave]';
  LED_REACTIVE = '[reactive]';
  LED_STARLIGHT = '[star]';
  LED_REBOUND = '[rebound]';
  LED_RIPPLE = '[ripple]';
  LED_LOOP = '[loop]';
  LED_PULSE = '[pulse]';
  LED_RAIN = '[rain]';
  LED_PITCH_BLACK = '[black]';
  LED_OFF = '0';

  //Misc constants
  USER_MANUAL_FSEDGE = 'User Manual-SmartSet App.pdf';
  USER_MANUAL_ADV2 = 'SmartSet App Help.pdf';
  KB_SETTINGS_FILE = 'kbd_settings.txt';
  APP_SETTINGS_FILE = 'app_settings.txt';
  VERSION_FILE = 'version.txt';
  MACRO_COUNT_FS = 3;
  MAX_MACRO_FS = 24;
  MAX_MACRO_RGB = 100;
  MAX_MACRO_FS_PRIOR_340 = 24;
  MAX_MACRO_FS_340_PLUS = 100;
  MAX_KEYSTROKES_FS = 7200;
  MAX_KEYSTROKES_RGB = 7200;
  MAX_KEYSTROKES_MACRO_FS = 300;
  DISABLE_NOTIF = 100;
  FILE_LAYOUT = 'layout';
  FILE_LED = 'led';
  PITCH_BLACK = 'P';
  BREATHE = 'B';
  FSEDGE_TUTORIAL = 'https://www.youtube.com/playlist?list=PLJql6LYXw-uOcHFihFhnZhJGb854SRy7Z';
  FSEDGEV2_TUTORIAL = 'https://www.youtube.com/playlist?list=PLJql6LYXw-uOjCXMkLf7Ur3Jm9Dsqf_KD';
  FSEDGEV2_HELP = 'https://gaming.kinesis-ergo.com/fs-edge-rgb-support/';
  FSEDGE_MANUAL = 'https://gaming.kinesis-ergo.com/fs-edge-support/#manuals';
  FSPRO_MANUAL = 'https://kinesis-ergo.com/support/freestyle-pro/#manuals';
  ADV2_MANUAL = 'https://kinesis-ergo.com/support/advantage2/#manuals';
  FSPRO_TUTORIAL = 'https://www.youtube.com/playlist?list=PLcsFMh_3_h0Z7Gx0T5N7TTzceorPHXJr5';
  ADV2_TUTORIAL = 'https://www.youtube.com/playlist?list=PLcsFMh_3_h0aNmELoR6kakcNf7AInoEfW';
  FSPRO_TROUBLESHOOT = 'https://kinesis-ergo.com/support/freestyle-pro/';
  FSEDGE_TROUBLESHOOT = 'https://gaming.kinesis-ergo.com/fs-edge-support/';
  RGB_TROUBLESHOOT = 'https://gaming.kinesis-ergo.com/fs-edge-rgb-support/';
  ADV2_TROUBLESHOOT = 'https://kinesis-ergo.com/support/advantage2/';
  FSPRO_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
  FSEDGE_SUPPORT = 'https://gaming.kinesis-ergo.com/contact-tech-support/';
  ADV2_SUPPORT = 'https://kinesis-ergo.com/support/contact-a-technician/';
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
  CROSSKP_DRIVE = 'CROSSFIRE KEYPAD';
  CROSSTKO_DRIVE = 'CROSSFIRE TKO';
  TAP_AND_HOLD = 't&h';
  DEFAULT_SPEED_TAP_HOLD = 250;
  MAX_TAP_HOLD = 10;
  MAX_IMPORT_SIZE = 50;
  MIN_TIMING_DELAY = 1;
  MAX_TIMING_DELAY = 999;

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
begin
  aObject.Font.Color := fontColor;
  for i := 0 to aObject.ComponentCount - 1 do
  begin
    if aObject.Components[i].InheritsFrom(TWinControl) then
       TWinControl(aObject.Components[i]).Font.Color := fontColor;
    if aObject.Components[i].InheritsFrom(TGraphicControl) and not(aObject.Components[i].InheritsFrom(THSSpeedButton)) then
       TGraphicControl(aObject.Components[i]).Font.Color := fontColor;
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
  {$ifdef Win32}
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
  {$ifdef Win32}
  //Gets English US Scan Code
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

//Checks if we can use Unicode characters
function CanUseUnicode: boolean;
begin
  result := false;
  {$ifdef Win32}
  result := (Win32MajorVersion >= 10); //Windows 10 and up
  {$endif}
end;

//Checks if we can use Unicode characters
function IsPreWin8: boolean;
begin
  result := false;
  {$ifdef Win32}
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
{$ifdef Win32}
  Drive: Char;
  DriveLetter: string;
  OldMode: Word;
{$endif}
  aListDrives: TStringList;
begin
  aListDrives := TStringList.Create;
  {$ifdef Win32}
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
{$ifdef Win32}
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeInfo:  array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
  Buf: array [0..MAX_PATH] of Char;
{$endif}
begin
  result := '';
  {$ifdef Win32}
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
  kbDrive: string;
begin
  result := false;
  kbDrive := '';
  if (GApplication = APPL_FSEDGE) then
     kbDrive := FSEDGE_DRIVE
  else if (GApplication = APPL_FSPRO) then
     kbDrive := FSPRO_DRIVE
  else if (GApplication = APPL_ADV2) then
     kbDrive := ADV2_DRIVE
  else if (GApplication = APPL_RGB) then
     kbDrive := RGB_DRIVE;
  GApplicationPath := GExecutablePath;
  if not DirectoryExists(GApplicationPath + '\firmware\') then
  begin
    GDesktopMode := true;
    {$ifdef Win32}
    driveList := GetAvailableDrives;
    for i := 0 to driveList.Count - 1 do
    begin
      if (GApplication = APPL_ADV2) then
        dirFirmware := driveList[i] + '\active\'
      else
        dirFirmware := driveList[i] + '\firmware\';
      driveName := UpperCase(Trim(GetVolumeLabel(driveList[i][1])));

      if (GApplication in [APPL_FSEDGE, APPL_FSPRO]) then
      begin
        if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + 'version.txt')) and
        ((driveName = FSEDGE_DRIVE) or (driveName = FSPRO_DRIVE)) then
        begin
          GApplicationPath := driveList[i];
          result := true;
        end;
      end
      else if (GApplication in [APPL_ADV2]) then
      begin
        if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + 'version.txt')) and
        ((driveName = ADV2_DRIVE) or (driveName = ADV2_DRIVE_2) or (driveName = ADV2_DRIVE_3)) then
        begin
          GApplicationPath := driveList[i];
          result := true;
        end;
      end
      else
      begin
        if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + 'version.txt')) and (driveName = kbDrive) then
        begin
          GApplicationPath := driveList[i];
          result := true;
        end;
      end;
    end;
    {$endif}

    //MacOS
    {$ifdef Darwin}
    if (GApplication in [APPL_FSEDGE, APPL_FSPRO]) then
    begin
      if DirectoryExists('/VOLUMES/' + FSPRO_DRIVE) then
        driveName := IncludeTrailingBackslash('/VOLUMES/' + FSPRO_DRIVE)
      else
        driveName := IncludeTrailingBackslash('/VOLUMES/' + FSEDGE_DRIVE);
    end
    else
      driveName := IncludeTrailingBackslash('/VOLUMES/' + kbDrive);

    if (GApplication in [APPL_ADV2]) then
    begin
      for i := 1 to 3 do
      begin
        case i of
         1: kbDrive := ADV2_DRIVE;
         2: kbDrive := ADV2_DRIVE_2;
         3: kbDrive := ADV2_DRIVE_3;
        end;
        driveName := IncludeTrailingBackslash('/VOLUMES/' + kbDrive);
        dirFirmware := driveName + '/active/';

        if (DirectoryExists(driveName + '/firmware/') and FileExists(dirFirmware + 'version.txt')) then
        begin
          GApplicationPath := driveName;
          result := true;
        end;
      end;
    end
    else
    begin
      dirFirmware := driveName + '/firmware/';

      if (DirectoryExists(driveName + '/firmware/') and FileExists(dirFirmware + 'version.txt')) then
      begin
        GApplicationPath := driveName;
        result := true;
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
  GPedalsFilePath := IncludeTrailingBackslash(GApplicationPath + 'active');
  GLayoutFilePath := IncludeTrailingBackslash(GApplicationPath + 'layouts');
  GLedFilePath := IncludeTrailingBackslash(GApplicationPath + 'lighting');
  GSettingsFilePath := IncludeTrailingBackslash(GApplicationPath + 'settings');
  GFirmwareFilePath := IncludeTrailingBackslash(GApplicationPath + 'firmware');
  GPedalsFile := GPedalsFilePath + 'pedals.txt';
  GVersionFile := GPedalsFilePath + 'version.txt';
  GStateFile := GPedalsFilePath + 'state.txt';
  GDebugMode := FileExists(GApplicationPath + 'debug.on');
  GDebugFirmware := FileExists(GApplicationPath + 'debug_firm.on');
  GDevMode := FileExists(GApplicationPath + 'devmode.on');
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

  smallFontSize := 8;
  {$ifdef Darwin}smallFontSize := 9;{$endif}

  ConfigKeys.Clear;
  //Control keys
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_ESCAPE, 'esc', 'Esc'))
  else
    ConfigKeys.Add(TKey.Create(VK_ESCAPE, 'escape', 'Esc'));
  ConfigKeys.Add(TKey.Create(VK_PAUSE, 'pause', 'Pause' + #10 + 'Break', '', '', '', false, false, '', true, false, smallFontSize, '', 'Pause Break'));
  ConfigKeys.Add(TKey.Create(VK_PRINT, 'prtscr', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize, '', 'Print Scrn')); //Old print key...
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_SNAPSHOT, 'prnt', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize ,'', 'Print Scrn')) //Print screen key
  else
    ConfigKeys.Add(TKey.Create(VK_SNAPSHOT, 'prtscr', 'Print' + #10 + 'Scrn', '', '', '', false, false, '', true, false, smallFontSize, '', 'Print Scrn')); //Print screen key
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_SCROLL, 'scrlk', 'Scroll' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Scroll Lock'))
  else
    ConfigKeys.Add(TKey.Create(VK_SCROLL, 'scroll', 'Scroll' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Scroll Lock'));
  ConfigKeys.Add(TKey.Create(VK_TAB, 'tab', 'Tab'));
  ConfigKeys.Add(TKey.Create(VK_CAPITAL, 'caps', 'Caps' + #10 + 'Lock', '', '', '', false, false, '', true, false, smallFontSize, '', 'Caps Lock'));
  //When multi-key and no modifiers, show empty space
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_SPACE, 'spc', 'Space', 'spc', ' '))
  else
    ConfigKeys.Add(TKey.Create(VK_SPACE, 'space', 'Space', 'space', ' '));///UTFString(#$e2#$90#$a3)));
  ConfigKeys.Add(TKey.Create(VK_LSPACE, 'lspc', 'Space', 'lspc', ' ', '', false, false, '', true, false, 0, '', 'Left Space')); //User-Defined key for FSEdge
  ConfigKeys.Add(TKey.Create(VK_RSPACE, 'rspc', 'Space', 'rspc', ' ', '', false, false, '', true, false, 0, '', 'Right Space')); //User-Defined key for FSEdge
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_INSERT, 'insert', 'Insert', 'ins'))
  else
    ConfigKeys.Add(TKey.Create(VK_INSERT, 'insert', 'Insert'));
  ConfigKeys.Add(TKey.Create(VK_HOME, 'home', 'Home'));
  ConfigKeys.Add(TKey.Create(VK_END, 'end', 'End'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_NEXT, 'pdn', 'Page' + #10 + 'Down', '', '', '', false, false, '', true, false, 0, '', 'Page Down'))
  else
    ConfigKeys.Add(TKey.Create(VK_NEXT, 'pdown', 'Page' + #10 + 'Down', '', '', '', false, false, '', true, false, 0, '', 'Page Down'));
  ConfigKeys.Add(TKey.Create(VK_PRIOR, 'pup', 'Page' + #10 + 'Up', '', '', '', false, false, '', true, false, 0, '', 'Page Up'));

  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_RIGHT, 'rght', UnicodeToUTF8(8594), '', '', '', false, false, '', true, false, 10, UNICODE_FONT))
  else
    ConfigKeys.Add(TKey.Create(VK_RIGHT, 'right', UnicodeToUTF8(8594), '', '', '', false, false, '', true, false, 16, UNICODE_FONT));

  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_LEFT, 'lft', UnicodeToUTF8(8592), '', '', '', false, false, '', true, false, 10, UNICODE_FONT))
  else
    ConfigKeys.Add(TKey.Create(VK_LEFT, 'left', UnicodeToUTF8(8592), '', '', '', false, false, '', true, false, 16, UNICODE_FONT));

  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_UP, 'up', UnicodeToUTF8(8593), '', '', '', false, false, '', true, false, 10, UNICODE_FONT))
  else
    ConfigKeys.Add(TKey.Create(VK_UP, 'up', UnicodeToUTF8(8593), '', '', '', false, false, '', true, false, 16, UNICODE_FONT));

  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_DOWN, 'dwn', UnicodeToUTF8(8595), '', '', '', false, false, '', true, false, 10, UNICODE_FONT))
  else
    ConfigKeys.Add(TKey.Create(VK_DOWN, 'down', UnicodeToUTF8(8595), '', '', '', false, false, '', true, false, 16, UNICODE_FONT));

  ConfigKeys.Add(TKey.Create(VK_SHIFT, 'Shift', 'Shift', 'shift'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LSHIFT, 'lshift', 'Left' + #10 + 'Shift', 'lshft', '', '', false, false, '', true, false, 0, '', 'Left Shift'));
    ConfigKeys.Add(TKey.Create(VK_RSHIFT, 'rshift', 'Right' + #10 + 'Shift', 'rshft', '', '', false, false, '', true, false, 0, '', 'Right Shift'));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LSHIFT, 'lshift', 'Left' + #10 + 'Shift'));
    ConfigKeys.Add(TKey.Create(VK_RSHIFT, 'rshift', 'Right' + #10 + 'Shift'));
  end;
  ConfigKeys.Add(TKey.Create(VK_CONTROL, 'Ctrl', 'Ctrl', 'ctrl'));
  //if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  //begin
  //  ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctrl', 'Ctrl'));
  //  ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctrl', 'Ctrl'));
  //end
  //else
  //begin
    ConfigKeys.Add(TKey.Create(VK_LCONTROL, 'lctrl', 'Left' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Left Ctrl'));
    ConfigKeys.Add(TKey.Create(VK_RCONTROL, 'rctrl', 'Right' + #10 + 'Ctrl', '', '', '', false, false, '', true, False, 0, '', 'Right Ctrl'));
  //end;
  ConfigKeys.Add(TKey.Create(VK_NUMLOCK, 'numlk', 'Num' + #10 + 'Lock'));
  ConfigKeys.Add(TKey.Create(VK_KP_NUMLCK, 'numlk', 'Num' + #10 + 'Lock'));
  ConfigKeys.Add(TKey.Create(VK_APPS, 'menu', 'PC' + #10 + 'Menu'));
  ConfigKeys.Add(TKey.Create(VK_KP_MENU, 'menu', 'PC' + #10 + 'Menu'));
  //Windows
  {$ifdef Win32}

  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'ent', ' Enter', '', '', '', false, false, '', true, false, 0, '', 'Enter'))
  else
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'enter', ' Enter', '', '', '', false, false, '', true, false, 0, '', 'Enter'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspc',  'Back' + #10 + 'Space', '', '', '', false, false, '', true, false, 0, '', 'Backspace'))
  else
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspace',  'Back' + #10 + 'Space', '', '', '', false, false, '', true, false, 0, '', 'Backspace'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'del', 'Delete'))
  else
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'delete', 'Delete'));
  ConfigKeys.Add(TKey.Create(VK_MENU, 'alt', 'Alt'));
  //if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  //begin
  //  ConfigKeys.Add(TKey.Create(VK_LMENU, 'lalt', 'Alt'));
  //  ConfigKeys.Add(TKey.Create(VK_RMENU, 'ralt', 'Alt'));
  //end
  //else
  //begin
    ConfigKeys.Add(TKey.Create(VK_LMENU, 'lalt', 'Left' + #10 + 'Alt', '', '', '', false, false, '', true, false, 0, '', 'Left Alt'));
    ConfigKeys.Add(TKey.Create(VK_RMENU, 'ralt', 'Right' + #10 + 'Alt', '', '', '', false, false, '', true, false, 0, '', 'Right Alt'));
  //end;
  if (GApplication = APPL_PEDAL) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'win', 'Left' + #10 + 'Win'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'win', 'Right' + #10 + 'Win'));
  end
  //else if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  //begin
  //  ConfigKeys.Add(TKey.Create(VK_LWIN, 'lwin', 'Win'));
  //  ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Win'));
  //end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LWIN, 'lwin', 'Left' + #10 + 'Win', '', '', '', false, false, '', true, false, 0, '', 'Left Win'));
    ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Right' + #10 + 'Win', '', '', '', false, false, '', true, false, 0, '', 'Right Win'));
  end;
  {$endif}

  //MacOS
  {$ifdef Darwin}
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'ent', 'Return'))
  else
    ConfigKeys.Add(TKey.Create(VK_RETURN, 'enter', 'Return'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspc',  'Delete'))
  else
    ConfigKeys.Add(TKey.Create(VK_BACK, 'bspace',  'Delete'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'del', 'Fwd ' + #10 + 'Delete', '', '', '', false, false, '', true, false, 0, '', 'Fwd Delete'))
  else
    ConfigKeys.Add(TKey.Create(VK_DELETE, 'delete', 'Fwd ' + #10 + 'Delete', '', '', '', false, false, '', true, false, 0, '', 'Fwd Delete'));
  ConfigKeys.Add(TKey.Create(VK_MENU, 'Opt', 'Opt', 'alt'));
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
  ConfigKeys.Add(TKey.Create(VK_LWIN, 'Cmd', 'Cmd', 'lwin'));
  ConfigKeys.Add(TKey.Create(VK_LCMD_MAC, 'lwin', 'Left' + #10 + 'Cmd'));
  ConfigKeys.Add(TKey.Create(VK_RWIN, 'rwin', 'Right' + #10 + 'Cmd'));
  {$endif}

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

  //Character keys
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_LCL_EQUAL, '=', '= +', '=', '=', '+', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_MINUS, '-', '- _', 'hyph', '-', '_', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_SLASH, '/', '/ ?', '/', '/', '?', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_BACKSLASH, '\', '\ |', '\', '\', '|', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_QUOTE, '''', ''' "', 'apos', '''', '"', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_TILDE, '`', '` ~', 'tilde', '`', '~', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_SEMI_COMMA, ';', '; :', 'colon', ';', ':', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_COMMA, ',', ', <', 'com', ',', '<', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_POINT, '.', '. >', 'per', '.', '>', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_OPEN_BRAKET, '[', '[ {', 'obrk', '[', '{', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_CLOSE_BRAKET, ']', '] }', 'cbrk', ']', '}', true, true));
    ConfigKeys.Add(TKey.Create(VK_OEM_102, 'intl-\', '', 'intl\', 'intl-\', 'intl-\', true, true)); //International <> key between Left Shift and Z
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_LCL_EQUAL, '=', '+' + #10 + '=', '=', '=', '+', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_MINUS, '-', '_' + #10 + '-', 'hyphen', '-', '_', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_SLASH, '/', '?' + #10 + '/', '/', '/', '?', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_BACKSLASH, '\', '|' + #10 + '\', '\', '\', '|', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_QUOTE, '''', '"' + #10 + '''', '''', '''', '"', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_TILDE, '`', '~' + #10 + '`', '`', '`', '~', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_SEMI_COMMA, ';', ':' + #10 + ';', ';', ';', ':', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_COMMA, ',', '<' + #10 + ',', ',', ',', '<', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_POINT, '.', '>' + #10 + '.', '.', '.', '>', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_OPEN_BRAKET, '[', '{' + #10 + '[', 'obrack', '[', '{', true, true));
    ConfigKeys.Add(TKey.Create(VK_LCL_CLOSE_BRAKET, ']', '}' + #10 + ']', 'cbrack', ']', '}', true, true));
    ConfigKeys.Add(TKey.Create(VK_OEM_102, 'intl-\', '', 'intl-\', 'intl-\', 'intl-\', true, true)); //International <> key between Left Shift and Z
  end;

  //Numpad keys
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_NUMPAD0, 'kp0', '0'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD1, 'kp1', '1'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD2, 'kp2', '2'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD3, 'kp3', '3'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD4, 'kp4', '4'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD5, 'kp5', '5'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD6, 'kp6', '6'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD7, 'kp7', '7'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD8, 'kp8', '8'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD9, 'kp9', '9'));
    ConfigKeys.Add(TKey.Create(VK_DIVIDE, 'kp/', '/', 'kp/'));
    ConfigKeys.Add(TKey.Create(VK_MULTIPLY, 'kp*', '*', 'kp*'));
    ConfigKeys.Add(TKey.Create(VK_SUBTRACT, 'kp-', '-', 'kp-'));
    ConfigKeys.Add(TKey.Create(VK_ADD, 'kp+', '+', 'kp+'));
    ConfigKeys.Add(TKey.Create(VK_DECIMAL, 'kp.', '.'));
    ConfigKeys.Add(TKey.Create(VK_NUMPADENTER, 'kpenter', 'Kp' + #10 + 'Enter', 'kpent'));
    //ConfigKeys.Add(TKey.Create(VK_OEM_NEC_EQUAL, 'kp=', '='));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_NUMPAD0, 'kp0', '0'));
    ConfigKeys.Add(TKey.Create(VK_KP_0, 'kp0', '0'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD1, 'kp1', '1'));
    ConfigKeys.Add(TKey.Create(VK_KP_1, 'kp1', '1'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD2, 'kp2', '2'));
    ConfigKeys.Add(TKey.Create(VK_KP_2, 'kp2', '2'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD3, 'kp3', '3'));
    ConfigKeys.Add(TKey.Create(VK_KP_3, 'kp3', '3'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD4, 'kp4', '4'));
    ConfigKeys.Add(TKey.Create(VK_KP_4, 'kp4', '4'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD5, 'kp5', '5'));
    ConfigKeys.Add(TKey.Create(VK_KP_5, 'kp5', '5'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD6, 'kp6', '6'));
    ConfigKeys.Add(TKey.Create(VK_KP_6, 'kp6', '6'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD7, 'kp7', '7'));
    ConfigKeys.Add(TKey.Create(VK_KP_7, 'kp7', '7'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD8, 'kp8', '8'));
    ConfigKeys.Add(TKey.Create(VK_KP_8, 'kp8', '8'));
    ConfigKeys.Add(TKey.Create(VK_NUMPAD9, 'kp9', '9'));
    ConfigKeys.Add(TKey.Create(VK_KP_9, 'kp9', '9'));
    ConfigKeys.Add(TKey.Create(VK_DIVIDE, 'kp/', '/', 'kpdiv'));
    ConfigKeys.Add(TKey.Create(VK_KP_DIVIDE, 'kp/', '/', 'kpdiv'));
    ConfigKeys.Add(TKey.Create(VK_MULTIPLY, 'kp*', '*', 'kpmult'));
    ConfigKeys.Add(TKey.Create(VK_KP_MULT, 'kp*', '*', 'kpmult'));
    ConfigKeys.Add(TKey.Create(VK_SUBTRACT, 'kp-', '-', 'kpmin'));
    ConfigKeys.Add(TKey.Create(VK_KP_MIN, 'kp-', '-', 'kpmin'));
    ConfigKeys.Add(TKey.Create(VK_ADD, 'kp+', '+', 'kpplus'));
    ConfigKeys.Add(TKey.Create(VK_KP_PLUS, 'kp+', '+', 'kpplus'));
    ConfigKeys.Add(TKey.Create(VK_DECIMAL, 'kp.', '.'));
    ConfigKeys.Add(TKey.Create(VK_KP_PERI, 'kp.', '.'));
    ConfigKeys.Add(TKey.Create(VK_NUMPADENTER, 'kpenter', 'Kp' + #10 + 'Enter', 'kpenter', '', '', false, false, '', true, false, 0, '', 'Kp Enter'));
    //ConfigKeys.Add(TKey.Create(VK_OEM_NEC_EQUAL, 'kp=', '='));
    ConfigKeys.Add(TKey.Create(VK_KP_EQUAL, 'kp=', '='));
  end;

  //0 to 9
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  begin
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
  end
  else
  begin
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
  end;

  //a to z
  for i := VK_A to VK_Z do
    ConfigKeys.Add(TKey.Create(i, LowerCase(Chr(i)), UpperCase(Chr(i)), LowerCase(Chr(i)), LowerCase(Chr(i)), Chr(i),
      true, true));

  //Custom for special events
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmous', 'Left' + #10 + 'Mouse'));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmous', 'Middle' + #10 + 'Mouse'));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmous', 'Right' + #10 + 'Mouse'));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_BTN4, 'mous4', 'Mouse' + #10 + 'Btn 4'));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_BTN5, 'mous5', 'Mouse' + #10 + 'Btn 5'));
  end
  else if (GApplication in [APPL_ADV2]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmouse', 'Left' + #10 + 'Mouse', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmouse', 'Middle' + #10 + 'Mouse', '', '', '', false, false, '', true, false, smallFontSize));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmouse', 'Right' + #10 + 'Mouse', '', '', '', false, false, '', true, false, smallFontSize));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_MOUSE_LEFT, 'lmouse'));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_MIDDLE, 'mmouse'));
    ConfigKeys.Add(TKey.Create(VK_MOUSE_RIGHT, 'rmouse'));
  end;
  ConfigKeys.Add(TKey.Create(VK_SPEED1, 'speed1', '', 'speed1', '', '', false, false, '', False));
  ConfigKeys.Add(TKey.Create(VK_SPEED3, 'speed3', '', 'speed3', '', '', false, false, '', False));
  ConfigKeys.Add(TKey.Create(VK_SPEED5, 'speed5', '', 'speed5', '', '', false, false, '', False));
  if not(GApplication in [APPL_RGB]) then
  begin
    ConfigKeys.Add(TKey.Create(VK_125MS, 'd125', '', 'd125', '', '', false, false, '', False));
    ConfigKeys.Add(TKey.Create(VK_500MS, 'd500', '', 'd500', '', '', false, false, '', False));
  end;
  ConfigKeys.Add(TKey.Create(VK_RAND_DELAY, 'dran', '', 'dran', '', '', false, false, '', False));

  //Timing delays 1 to 999
  for i := MIN_TIMING_DELAY to MAX_TIMING_DELAY do
    ConfigKeys.Add(TKey.Create(VK_MIN_DELAY + (i - 1), 'd' + Format('%.3d', [i]), '', 'd' + Format('%.3d', [i]), '', '', false, false, '', False));

  //Media keys
  mediaFontSize := 4;
  if (CanUseUnicode) then
  begin
    if (GApplication in [APPL_RGB]) then
    begin
      ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute', UnicodeToUTF8(128264), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-', UnicodeToUTF8(128265), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+', UnicodeToUTF8(128266), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT))
    end
    else
    begin
      ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute', UnicodeToUTF8(128360), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-', UnicodeToUTF8(128361), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
      ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+', UnicodeToUTF8(128362), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    end;
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'play', UnicodeToUTF8(9199), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PREV_TRACK, 'prev', UnicodeToUTF8(9198), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_NEXT_TRACK, 'next', UnicodeToUTF8(9197), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_KP_PLAY, 'play', UnicodeToUTF8(9199), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_KP_PREV, 'prev', UnicodeToUTF8(9198), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_KP_NEXT, 'next', UnicodeToUTF8(9197), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_KP_MUTE, 'mute', UnicodeToUTF8(128360), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLDOWN, 'vol-', UnicodeToUTF8(128361), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLUP, 'vol+', UnicodeToUTF8(128362), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT));
  end
  else
  begin
    ConfigKeys.Add(TKey.Create(VK_VOLUME_MUTE, 'mute', 'Mute'));
    ConfigKeys.Add(TKey.Create(VK_VOLUME_DOWN, 'vol-', 'Vol-'));
    ConfigKeys.Add(TKey.Create(VK_VOLUME_UP, 'vol+', 'Vol+'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PLAY_PAUSE, 'play', 'Play'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_PREV_TRACK, 'prev', 'Prev'));
    ConfigKeys.Add(TKey.Create(VK_MEDIA_NEXT_TRACK, 'next', 'Next'));
    ConfigKeys.Add(TKey.Create(VK_KP_PLAY, 'play', 'Play'));
    ConfigKeys.Add(TKey.Create(VK_KP_PREV, 'prev', 'Prev'));
    ConfigKeys.Add(TKey.Create(VK_KP_NEXT, 'next', 'Next'));
    ConfigKeys.Add(TKey.Create(VK_KP_MUTE, 'mute', 'Mute'));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLDOWN, 'vol-', 'Vol-'));
    ConfigKeys.Add(TKey.Create(VK_KP_VOLUP, 'vol+', 'Vol+'));
  end;
  ConfigKeys.Add(TKey.Create(VK_CALC, 'calc', 'Calc'));
  ConfigKeys.Add(TKey.Create(VK_KP_CALC, 'calc', 'Calc'));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_SHUTDOWN, 'shutdn', 'Shut' + #10 + 'down', 'shtdn'))
  else
    ConfigKeys.Add(TKey.Create(VK_SHUTDOWN, 'shutdn', 'Shut' + #10 + 'down'));
  ConfigKeys.Add(TKey.Create(VK_DIF_PRESS_REL, '{ }', '', ' '));
  ConfigKeys.Add(TKey.Create(VK_KEYPAD, '', 'Key-' + #10 + 'pad', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_PROGRAM, '', 'Pro-' + #10 + 'gram', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_KEYPAD_SHIFT, 'kpshft', 'Kp' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_KEYPAD_TOGGLE, 'kptoggle', 'Key-' + #10 + 'pad', '', '', '', false, false, '', true, false, smallFontSize));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
  begin

    ConfigKeys.Add(TKey.Create(VK_HK0, 'hk0', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 0'));
    ConfigKeys.Add(TKey.Create(VK_HK1, 'hk1', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 1'));
    ConfigKeys.Add(TKey.Create(VK_HK2, 'hk2', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 2'));
    ConfigKeys.Add(TKey.Create(VK_HK3, 'hk3', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 3'));
    ConfigKeys.Add(TKey.Create(VK_HK4, 'hk4', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 4'));
    ConfigKeys.Add(TKey.Create(VK_HK5, 'hk5', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 5'));
    ConfigKeys.Add(TKey.Create(VK_HK6, 'hk6', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 6'));
    ConfigKeys.Add(TKey.Create(VK_HK7, 'hk7', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 7'));
    ConfigKeys.Add(TKey.Create(VK_HK8, 'hk8', ' ', '', '', '', false, false, '', true, false, 0, '', 'hotkey 8'));
    if (GApplication in [APPL_RGB]) then
      ConfigKeys.Add(TKey.Create(VK_HK9, 'hk9', 'Fn' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize, '', 'hotkey 9'))
    else
      ConfigKeys.Add(TKey.Create(VK_HK9, 'hk9', 'Fn' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize, '', 'hotkey 9'));
    if (GApplication in [APPL_FSEDGE, APPL_RGB]) then
    begin
      if (CanUseUnicode) then
        ConfigKeys.Add(TKey.Create(VK_HK10, 'hk10', UnicodeToUTF8(9728), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT, 'hotkey 10'))
      else
        ConfigKeys.Add(TKey.Create(VK_HK10, 'hk10', 'LED', '', '', '', false, false, '', true, false, 0, '', 'hotkey 10'));
    end
    else
      ConfigKeys.Add(TKey.Create(VK_HK10, 'hk10', 'PC' + #10 + 'Menu', '', '', '', false, false, '', true, false, 0, '', 'hotkey 10'));
  end;
  ConfigKeys.Add(TKey.Create(VK_FUNCTION, 'Fn', 'Fn'));
  ConfigKeys.Add(TKey.Create(VK_NULL, 'null', ' '));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_FN_TOGGLE, 'fntog', 'Fn' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize))
  else
    ConfigKeys.Add(TKey.Create(VK_FN_TOGGLE, 'fntoggle', 'Fn' + #10 + 'Toggle', '', '', '', false, false, '', true, false, smallFontSize));
  if (GApplication in [APPL_FSEDGE, APPL_RGB, APPL_FSPRO]) then
    ConfigKeys.Add(TKey.Create(VK_FN_SHIFT, 'fnshf', 'Fn' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize))
  else
    ConfigKeys.Add(TKey.Create(VK_FN_SHIFT, 'fnshift', 'Fn' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize));
  if (CanUseUnicode) then
      ConfigKeys.Add(TKey.Create(VK_LED, 'LED', UnicodeToUTF8(9728), '', '', '', false, false, '', true, false, mediaFontSize, UNICODE_FONT))
    else
      ConfigKeys.Add(TKey.Create(VK_LED, 'LED', 'LED'));
  ConfigKeys.Add(TKey.Create(VK_MIC_MUTE, 'micmute', 'Mic' + #10 + 'Mute', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_LPEDAL, 'lp-tab', 'Tab'));
  ConfigKeys.Add(TKey.Create(VK_MPEDAL, 'mp-kpshf', 'Kp' + #10 + 'Shift'));
  ConfigKeys.Add(TKey.Create(VK_RPEDAL, 'rp-kpent', 'Kp' + #10 + 'Enter'));
  ConfigKeys.Add(TKey.Create(VK_HYPER, 'hyper', 'Hyper'));
  ConfigKeys.Add(TKey.Create(VK_MEH, 'meh', 'Meh'));

  //FOR ADVANTAGE 2 KEYBOARD
  ConfigKeys.Add(TKey.Create(VK_KP_KPSHIFT, 'kpshft', 'Kp' + #10 + 'Shift', '', '', '', false, false, '', true, false, smallFontSize));
  ConfigKeys.Add(TKey.Create(VK_KP_ENTER1, 'kpenter1', 'Kp' + #10 + 'Enter'));
  ConfigKeys.Add(TKey.Create(VK_KP_ENTER2, 'kpenter2', 'Kp' + #10 + 'Enter'));

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
    {$ifdef Win32}
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
{$ifdef Win32}
var
  PIDL: PItemIDList;
  InFolder: array[0..MAX_PATH] of Char;
  {$endif}
begin
  {$ifdef Win32}
  { Get the desktop location }
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);
  SHGetPathFromIDList(PIDL, InFolder);
  result := AppendPathDelim(InFolder);
  {$endif}

  {$ifdef Darwin}
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

function IsDeviceConnected(aDevice: TDevice): boolean;
var
  driveList: TStringList;
  i: integer;
  dirFirmware: string;
  driveName: string;
  kbDrive: string;
begin
  result := false;
  kbDrive := '';
  {$ifdef Win32}
  driveList := GetAvailableDrives;
  for i := 0 to driveList.Count - 1 do
  begin
    if (aDevice.DeviceNumber = APPL_ADV2) then
    begin
      dirFirmware := driveList[i] + '\active\';

      if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + 'version.txt')) and
        ((driveName = ADV2_DRIVE) or (driveName = ADV2_DRIVE_2) or (driveName = ADV2_DRIVE_3)) then
      begin
        aDevice.Connected := true;
        result := true;
      end;
    end
    else
    begin
      dirFirmware := driveList[i] + '\firmware\';
      driveName := UpperCase(Trim(GetVolumeLabel(driveList[i][1])));

      if (DirectoryExists(dirFirmware) and FileExists(dirFirmware + 'version.txt')) and
        (driveName = aDevice.VDriveName) then
      begin
        aDevice.Connected := true;
        result := true;
      end;
    end;
  end;
  {$endif}

  //MacOS
  {$ifdef Darwin}
  if (GApplication in [APPL_ADV2]) then
  begin
    for i := 1 to 3 do
    begin
      case i of
       1: kbDrive := ADV2_DRIVE;
       2: kbDrive := ADV2_DRIVE_2;
       3: kbDrive := ADV2_DRIVE_3;
      end;
      driveName := IncludeTrailingBackslash('/VOLUMES/' + kbDrive);
      dirFirmware := driveName + '/active/';

      if (DirectoryExists(driveName + '/firmware/') and FileExists(dirFirmware + 'version.txt')) then
      begin
        aDevice.Connected := true;
        result := true;
      end;
    end;
  end
  else
  begin
    driveName := IncludeTrailingBackslash('/VOLUMES/' + aDevice.VDriveName);
    dirFirmware := driveName + '/firmware/';

    if (DirectoryExists(driveName + '/firmware/') and FileExists(dirFirmware + 'version.txt')) then
    begin
      aDevice.Connected := true;
      result := true;
    end;
  end;

  {$endif}
end;

function LoadFontFromRes(FontName: string):THandle;
{$ifdef Win32}
var
  ResHandle: HRSRC;
  ResSize, NbFontAdded: Cardinal;
  ResAddr: HGLOBAL;
{$endif}
begin
{$ifdef Win32}
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
  GApplicationTitle := 'SmartSet App';
  GDesktopMode := false;
  GDemoMode := false;
  //Windows
  {$ifdef Win32}
  GApplicationName := 'SmartSet App (Win)';
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
