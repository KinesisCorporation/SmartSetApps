unit u_base_key_service;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, u_keys, LCLType, u_const, u_key_layer, character, LCLIntf,
  Graphics, u_gif;

type
  { TBaseKeyService }
  TBaseKeyService = class
  private
    FKBLayers: TKBLayerList;
    FActiveLayer: TKBLayer;
    FActiveKbKey: TKBKey;
    FActiveGif: TGif;
    FLedMode: TLedMode;
    FLedModeFn: TLedMode;
    FLedColorMono: TColor;
    FLedColorMonoFn: TColor;
    FLedColorReactive: TColor;
    FLedColorReactiveFn: TColor;
    FBaseLedColorReactive: TColor;
    FBaseLedColorReactiveFn: TColor;
    FLedColorRipple: TColor;
    FLedColorRippleFn: TColor;
    FBaseLedColorRipple: TColor;
    FBaseLedColorRippleFn: TColor;
    FLedColorFireball: TColor;
    FLedColorFireballFn: TColor;
    FBaseLedColorFireball: TColor;
    FBaseLedColorFireballFn: TColor;
    FLedColorStarlight: TColor;
    FLedColorStarlightFn: TColor;
    FBaseLedColorStarlight: TColor;
    FBaseLedColorStarlightFn: TColor;
    FLedColorRebound: TColor;
    FLedColorReboundFn: TColor;
    FBaseLedColorRebound: TColor;
    FBaseLedColorReboundFn: TColor;
    FLedColorLoop: TColor;
    FLedColorLoopFn: TColor;
    FBaseLedColorLoop: TColor;
    FBaseLedColorLoopFn: TColor;
    FLedColorRain: TColor;
    FLedColorRainFn: TColor;
    FBaseLedColorRain: TColor;
    FBaseLedColorRainFn: TColor;
    FLedSpeed: integer;
    FLedSpeedFn: integer;
    FLedDirection: integer;
    FLedDirectionFn: integer;

    FCurrentKBLayout: string;

    //List of supported keys from programming guide
    FConfigKeys: TKeyList;
    FActiveModifiers: TKeyList;
    FBackupKey: TKBKey;
    FBackupMacro: TKBKey;

    //Gifs using programming
    FRainGif: TGif;
    FReactiveGif: TGif;
    FRippleGif: TGif;
    FFireballGif: TGif;
    FLoopDownGif: TGif;
    FLoopUpGif: TGif;
    FLoopLeftGif: TGif;
    FLoopRightGif: TGif;
    FReboundHorGif: TGif;
    FReboundVerGif: TGif;
    FStartlightGif: TGif;

    //List of supported keyboard layouts
    //FKeyboardLayouts: TKeyboardLayoutList;

    function GetBotLayerRGB: TKBLayer;
    function GetKeyLoadException(key: word; layerIdx: integer): TKey;
    function GetKeySaveException(key: word; layerIdx: integer): TKey;
    function GetTopLayerRGB: TKBLayer;
    function IsNumericKey(aKey: TKey): boolean;
    function IsAlphaKey(aKey: TKey): boolean;

    procedure FillModifiersFromValues(aKeyList: TKeyList; sModifiers: string);
    function GetKeyText(aKey: TKey; defaultValue: string = ''; checkAltGr: boolean = false): string;
    function IsAltGr(aKey: TKey): boolean;
    function GetTopLayerFSEdge: TKBLayer;
    function GetBotLayerFSEdge: TKBLayer;
    function GetTopLayerFSPro: TKBLayer;
    function GetBotLayerFSPro: TKBLayer;
    function GetQwertyTopLayerAdv2: TKBLayer;
    function GetQwertyBotLayerAdv2: TKBLayer;
    function GetDvorakTopLayerAdv2: TKBLayer;
    function GetDvorakBotLayerAdv2: TKBLayer;
    function GetOutputText(aKeyList: TKeyList; var aKeysPos: TKeysPos; keyIdxToFind: integer; var keyIdxPos: integer): string;
    function KeyPadException(value: string): boolean;
    function GetKeyPadException(value: string): integer;
    procedure InitGifs;
    function GetLedMode: TLedMode;
    procedure ResetLedOptions;
    procedure SetLedMode(aLedMode: TLedMode);
    function GetLedSpeed: integer;
    procedure SetLedSpeed(aLedSpeed: integer);
    function GetLedDirection: integer;
    procedure SetLedDirection(aDirection: integer);
    procedure SetLedColorMono(aColor: TColor);
    function GetLedColorMono: TColor;
    function GetLedColorReactive: TColor;
    procedure SetLedColorReactive(aColor: TColor);
    function GetBaseLedColorReactive: TColor;
    procedure SetBaseLedColorReactive(aColor: TColor);
    function GetLedColorRipple: TColor;
    procedure SetLedColorRipple(aColor: TColor);
    function GetBaseLedColorRipple: TColor;
    procedure SetBaseLedColorRipple(aColor: TColor);
    function GetLedColorFireball: TColor;
    procedure SetLedColorFireball(aColor: TColor);
    function GetBaseLedColorFireball: TColor;
    procedure SetBaseLedColorFireball(aColor: TColor);
    function GetLedColorStarlight: TColor;
    procedure SetLedColorStarlight(aColor: TColor);
    function GetBaseLedColorStarlight: TColor;
    procedure SetBaseLedColorStarlight(aColor: TColor);
    function GetLedColorRebound: TColor;
    procedure SetLedColorRebound(aColor: TColor);
    function GetBaseLedColorRebound: TColor;
    procedure SetBaseLedColorRebound(aColor: TColor);
    function GetLedColorLoop: TColor;
    procedure SetLedColorLoop(aColor: TColor);
    function GetBaseLedColorLoop: TColor;
    procedure SetBaseLedColorLoop(aColor: TColor);
    function GetLedColorRain: TColor;
    procedure SetLedColorRain(aColor: TColor);
    function GetBaseLedColorRain: TColor;
    procedure SetBaseLedColorRain(aColor: TColor);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function FindKeyConfig(iKey: word): TKey; overload;
    function FindKeyConfig(sKey: string): TKey; overload;
    function GetKeyConfig(iKey: word): TKey;
    procedure AddModifier(key: word);
    procedure RemoveModifier(key: word);
    procedure ClearModifiers;
    function IsWinKeyDown: boolean;
    function AddKey(kbKey: TKBKey; iKey: word; modifiers: string; insertAtPos: integer): TKey;
    function RemoveKey(kbKey: TKBKey; index: integer): boolean;
    function GetModifierText: string;
    function BackupMacro(aKbKey: TKbKey): boolean;
    function RestoreMacro(aKbKey: TKbKey): boolean;
    function BackupKbKey(aKbKey: TKbKey): boolean;
    function RestoreKbKey(aKbKey: TKbKey): boolean;
    function GetMacroText(aKeyList: TKeyList; var aKeysPos: TKeysPos): string;
    function GetKeyAtPosition(aKeyList: TKeyList; cursorPos: integer): integer;
    procedure ConvertFromTextFileFmtFS(aLayoutContent: TStringList);
    function ConvertToTextFileFmtFS: TStringList;
    procedure ConvertFromTextFileFmtRGB(aLayoutContent: TStringList);
    function ConvertLedToTextFileFmtRGB: TStringList;
    procedure ConvertLedFromTextFileFmtRGB(aLedContent: TStringList);
    function ConvertToTextFileFmtRGB: TStringList;
    procedure ConvertFromTextFileFmtAdv2(aLayoutContent: TStringList);
    function ConvertToTextFileFmtAdv2: TStringList;
    function IsLedFile(aContent: TStringList): boolean;
    function IsLayoutFile(aContent: TStringList): boolean;
    function IsShiftDown(aKey: TKey): boolean;
    //procedure LoadKeyConfig;
    procedure LoadLayerList(layerType: integer);
    //procedure LoadKeyboardLayouts;
    procedure UpdateCurrentKeyboardLayout;
    function GetReplacementKey(aKey: word; saving: boolean): string;
    procedure ResetLayout;
    procedure ResetLayer(aLayer: TKBLayer);
    function GetLayer(layerIdx: integer): TKBLayer;
    procedure SetKBKey(aKBKey: TKBKey; key: word);
    procedure SetTapAndHold(aKBKey: TKBKey; tapAction: integer;
      holdAction: integer; delay: integer);
    procedure SetKBKeyIdx(aLayer: TKBLayer; index: integer; key: word);
    procedure SetKeyMacroIdx(aLayer: TKBLayer; index: integer; aMacro: TKeyList;
      resetMacro: boolean = true);
    function GetKBKey(key: word; layerIdx: integer): TKBKey;
    function GetKbKeyByIndex(aLayer: TKBLayer; index: integer): TKBKey;
    function CopyMacro(aMacro: TKeyList): TKeyList;
    function GetSingleKeyText(aKey: TKey; var isLongKey: boolean): string;
    function ValidateMacros(aKey: TKbKey; var errorMsg: string; var errorMsgTitle: string): boolean;
    function CountModifiers(modifiers: string): integer;
    function CountKeystrokes(aKeyList: TKeyList): integer;
    procedure LoadConfigKeys;
    function GetModifierValues(aKey: TKey): string;
    procedure SetAllKeyColor(keyColor: TColor; layerIdx: integer);
    function GetKeyWithModifier(iKey: word; modifiers: string): TKey;
    function CountAllKeystrokes: integer;

    property ActiveKbKey: TKBKey read FActiveKbKey write FActiveKbKey;

    property ConfigKeys: TKeyList read FConfigKeys write FConfigKeys;
    property ActiveModifiers: TKeyList read FActiveModifiers write FActiveModifiers;
    //property BackupKey: TKBKey read FBackupKey write FBackupKey;
    //property KeyboardLayouts: TKeyboardLayoutList read FKeyboardLayouts write FKeyboardLayouts;

    property ActiveLayer: TKBLayer read FActiveLayer write FActiveLayer;
    property ActiveGif: TGif read FActiveGif write FActiveGif;
    property KBLayers: TKBLayerList read FKBLayers write FKBLayers;
    property LedMode: TLedMode read GetLedMode write SetLedMode;
    property LedColorMono: TColor read GetLedColorMono write SetLedColorMono;
    property LedColorReactive: Tcolor read GetLedColorReactive write SetLedColorReactive;
    property BaseLedColorReactive: Tcolor read GetBaseLedColorReactive write SetBaseLedColorReactive;
    property LedColorRipple: Tcolor read GetLedColorRipple write SetLedColorRipple;
    property BaseLedColorRipple: Tcolor read GetBaseLedColorRipple write SetBaseLedColorRipple;
    property LedColorFireball: Tcolor read GetLedColorFireball write SetLedColorFireball;
    property BaseLedColorFireball: Tcolor read GetBaseLedColorFireball write SetBaseLedColorFireball;
    property LedColorStarlight: Tcolor read GetLedColorStarlight write SetLedColorStarlight;
    property BaseLedColorStarlight: Tcolor read GetBaseLedColorStarlight write SetBaseLedColorStarlight;
    property LedColorRebound: Tcolor read GetLedColorRebound write SetLedColorRebound;
    property BaseLedColorRebound: Tcolor read GetBaseLedColorRebound write SetBaseLedColorRebound;
    property LedColorLoop: Tcolor read GetLedColorLoop write SetLedColorLoop;
    property BaseLedColorLoop: Tcolor read GetBaseLedColorLoop write SetBaseLedColorLoop;
    property LedColorRain: Tcolor read GetLedColorRain write SetLedColorRain;
    property BaseLedColorRain: Tcolor read GetBaseLedColorRain write SetBaseLedColorRain;
    property LedSpeed: integer read GetLedSpeed write SetLedSpeed;
    property LedDirection: integer read GetLedDirection write SetLedDirection;
    property RainGif: TGif read FRainGif write FRainGif;
    property ReactiveGif: TGif read FReactiveGif write FReactiveGif;
    property RippleGif: TGif read FRippleGif write FRippleGif;
    property FireballGif: TGif read FFireballGif write FFireballGif;
    property ReboundHorGif: TGif read FReboundHorGif write FReboundHorGif;
    property ReboundVerGif: TGif read FReboundVerGif write FReboundVerGif;
    property LoopDownGif: TGif read FLoopDownGif write FLoopDownGif;
    property LoopUpGif: TGif read FLoopUpGif write FLoopUpGif;
    property LoopLeftGif: TGif read FLoopLeftGif write FLoopLeftGif;
    property LoopRightGif: TGif read FLoopRightGif write FLoopRightGif;
    property StartlightGif: TGif read FStartlightGif write FStartlightGif;
  end;

implementation

{ TBaseKeyService }

constructor TBaseKeyService.Create;
begin
  inherited Create;
  FKBLayers := TKBLayerList.Create;
  FActiveLayer := nil;
  FActiveGif := nil;
  FActiveKbKey := nil;
  FCurrentKBLayout := '';
  FConfigKeys := nil;
  FActiveModifiers := TKeyList.Create;
  FBackupKey := TKBKey.Create;
  FBackupMacro := TKBKey.Create;
  //KeyboardLayouts := TKeyboardLayoutList.Create;

  ResetLedOptions;

  //LoadKeyConfig;
  //LoadKeyboardLayouts;
  UpdateCurrentKeyboardLayout;

  InitGifs;
end;

destructor TBaseKeyService.Destroy;
begin
  FreeAndNil(FConfigKeys);
  FreeAndNil(FActiveModifiers);
  FreeAndNil(FKBLayers);
  FreeAndNil(FBackupKey);
  FreeAndNil(FBackupMacro);
  FreeAndNil(FRainGif);
  FreeAndNil(FReactiveGif);
  FreeAndNil(FRippleGif);
  FreeAndNil(FFireballGif);
  FreeAndNil(FLoopDownGif);
  FreeAndNil(FLoopUpGif);
  FreeAndNil(FLoopRightGif);
  FreeAndNil(FLoopLeftGif);
  FreeAndNil(FReboundHorGif);
  FreeAndNil(FReboundVerGif);
  FreeAndNil(FStartlightGif);
  inherited Destroy;
end;

function TBaseKeyService.GetTopLayerFSEdge: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := TOPLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-top';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F1), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F2), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F3), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F4), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F5), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F6), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SNAPSHOT), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PAUSE), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 16));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK1), 17));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK2), 18));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 29));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 33));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK3), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK4), 35));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 41));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 48));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 49));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 50));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK5), 51));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK6), 52));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 57));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 58));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 66));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK7), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK8), 68));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 69, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 75));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 80, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 82));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK9), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK10), 84));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 85, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$ifdef Win32}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$endif}
  //{$ifdef Darwin}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCMD_MAC), 86, true, false));
  //{$endif}
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 87, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSPACE), 88));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSPACE), 89));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 90, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 91, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 92));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 93));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 94));

  result := aKBLayer;

end;

function TBaseKeyService.GetBotLayerFSEdge: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := BOTLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-keypad';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_MUTE), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_DOWN), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_UP), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_PLAY_PAUSE), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_PREV_TRACK), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_NEXT_TRACK), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SNAPSHOT), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_INSERT), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 16));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK1), 17));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK2), 18));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 29));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 33));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK3), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK4), 35));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 41));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 48));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 49));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 50));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK5), 51));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK6), 52));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 57));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 58));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 66));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK7), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK8), 68));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 69, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 75));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 80, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 82));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK9), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK10), 84));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 85, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$ifdef Win32}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$endif}
  //{$ifdef Darwin}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCMD_MAC), 86, true, false));
  //{$endif}
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 87, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSPACE), 88));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSPACE), 89));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 90, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 91, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 92));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 93));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 94));

  result := aKBLayer;
end;

function TBaseKeyService.GetTopLayerRGB: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := TOPLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-top';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK0), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 1)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F1), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F2), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F3), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F4), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F5), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F6), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SNAPSHOT), 14));
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PAUSE), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 16));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK1), 17));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK2), 18));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 29));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 33));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK3), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK4), 35));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 41));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 48));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 49));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 50));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK5), 51));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK6), 52));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 57));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 58));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 66));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK7), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK8), 68));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 69, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 75));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 80, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 82));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK9), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK10), 84));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 85, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$ifdef Win32}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$endif}
  //{$ifdef Darwin}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCMD_MAC), 86, true, false));
  //{$endif}
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 87, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSPACE), 88));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSPACE), 89));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 90, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 91, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 92));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 93));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 94));

  result := aKBLayer;

end;

function TBaseKeyService.GetBotLayerRGB: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := BOTLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-keypad';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK0), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_MUTE), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_DOWN), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_UP), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_PLAY_PAUSE), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_PREV_TRACK), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_NEXT_TRACK), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SNAPSHOT), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_INSERT), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 16));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK1), 17));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK2), 18));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 29));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 33));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK3), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK4), 35));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 41));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 48));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 49));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 50));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK5), 51));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK6), 52));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 57));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 58));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 66));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK7), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK8), 68));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 69, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 75));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 80, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 82));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK9), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK10), 84));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 85, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$ifdef Win32}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  //{$endif}
  //{$ifdef Darwin}
  //aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCMD_MAC), 86, true, false));
  //{$endif}
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 87, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSPACE), 88));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSPACE), 89));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 90, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 91, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 92));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 93));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 94));

  result := aKBLayer;
end;

function TBaseKeyService.GetTopLayerFSPro: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := TOPLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-top';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F1), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F2), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F3), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F4), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F5), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F6), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SNAPSHOT), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PAUSE), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 16));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK1), 17));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK2), 18));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 29));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 33));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK3), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK4), 35));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 41));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 48));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 49));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 50));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK5), 51));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK6), 52));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 57));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 58));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 66));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK7), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK8), 68));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 69, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 75));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 80, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 82));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK9), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK10), 84));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 85, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 87, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSPACE), 88));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSPACE), 89));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 90, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 91, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 92));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 93));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 94));

  result := aKBLayer;

end;

function TBaseKeyService.GetBotLayerFSPro: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := BOTLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-keypad';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_MUTE), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_DOWN), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_VOLUME_UP), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_PLAY_PAUSE), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_PREV_TRACK), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MEDIA_NEXT_TRACK), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SNAPSHOT), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMLOCK), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_INSERT), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 16));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK1), 17));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK2), 18));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD7), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD8), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD9), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 29));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MULTIPLY ), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 33));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK3), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK4), 35));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 41));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD4), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD5), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD6), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SUBTRACT), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 48));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 49));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 50));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK5), 51));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK6), 52));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 57));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 58));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD1), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD2), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD3), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ADD), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPADENTER), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 66));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK7), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK8), 68));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 69, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 75));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NUMPAD0), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DECIMAL), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DIVIDE), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 80, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 82));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK9), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HK10), 84));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 85, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 86, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 87, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSPACE), 88));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSPACE), 89));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 90, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 91, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 92));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 93));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 94));

  result := aKBLayer;
end;

function TBaseKeyService.GetQwertyTopLayerAdv2: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := TOPLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-top';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F1), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F2), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F3), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F4), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F5), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F6), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRINT), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PAUSE), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KEYPAD), 16, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PROGRAM), 17, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 18));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 29));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 33));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 35));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 41));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 48, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 49, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RWIN), 50, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 51, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 52));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 57));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 58, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 66));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 68));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SPACE), 69));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 75, true, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_OEM_102), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 80));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 82));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 84));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 85));

  //For Pedals
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LPEDAL), 86));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MPEDAL), 87));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RPEDAL), 88));

  result := aKBLayer;
end;

function TBaseKeyService.GetQwertyBotLayerAdv2: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := BOTLAYER_IDX;
  aKBLayer.LayerName := 'Qwerty-keypad';
  aKBLayer.LayerType := LAYER_QWERTY;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MENU), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PLAY), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PREV), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_NEXT), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_CALC), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_KPSHIFT), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MUTE), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_VOLDOWN), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_VOLUP), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KEYPAD), 16, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PROGRAM), 17, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 18));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_NUMLCK), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_EQUAL), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_DIVIDE), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MULT), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 29));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 33));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 35));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_7), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_8), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_9), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MIN), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 41));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 48, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 49, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RWIN), 50, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 51, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 52));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_4), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_5), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_6), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PLUS), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 57));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 58, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 66));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 68));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_0), 69));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_1), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_2), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_3), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_ENTER1), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 75, true, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_INSERT), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 80));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 82));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PERI), 84));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_ENTER2), 85));

  //For Pedals
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LPEDAL), 86));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MPEDAL), 87));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RPEDAL), 88));

  result := aKBLayer;
end;

function TBaseKeyService.GetDvorakTopLayerAdv2: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := TOPLAYER_IDX;
  aKBLayer.LayerName := 'Dvorak-top';
  aKBLayer.LayerType := LAYER_DVORAK;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F1), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F2), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F3), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F4), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F5), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F6), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F7), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F8), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRINT), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SCROLL), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PAUSE), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KEYPAD), 16, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PROGRAM), 17, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 18));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_7), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_8), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_9), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_0), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 29));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 33));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 35));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_G), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_C), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_R), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_L), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 41));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 48, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 49, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RWIN), 50, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 51, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 52));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_H), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_T), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_N), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_S), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 57));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 58, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 66));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 68));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_SPACE), 69));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_M), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_W), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_V), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Z), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 75, true, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_OEM_102), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 80));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 82));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_OPEN_BRAKET), 84));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_CLOSE_BRAKET), 85));

  //For Pedals
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LPEDAL), 86));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MPEDAL), 87));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RPEDAL), 88));

  result := aKBLayer;
end;

function TBaseKeyService.GetDvorakBotLayerAdv2: TKBLayer;
var
  aKBLayer: TKBLayer;
begin
  aKBLayer := TKBLayer.Create;
  aKBLayer.LayerIndex := BOTLAYER_IDX;
  aKBLayer.LayerName := 'Dvorak-keypad';
  aKBLayer.LayerType := LAYER_DVORAK;

  //Put Keys in order needed...
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_ESCAPE), 0)); //First button
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LWIN), 1));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RMENU), 2));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MENU), 3));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PLAY), 4));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PREV), 5));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_NEXT), 6));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_CALC), 7));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_KPSHIFT), 8));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F9), 9));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F10), 10));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F11), 11));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F12), 12));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MUTE), 13));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_VOLDOWN), 14));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_VOLUP), 15));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KEYPAD), 16, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PROGRAM), 17, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_EQUAL), 18));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_1), 19));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_2), 20));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_3), 21));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_4), 22));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_5), 23));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_6), 24));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_NUMLCK), 25));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_EQUAL), 26));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_DIVIDE), 27));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MULT), 28));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_MINUS), 29));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_TAB), 30));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_QUOTE), 31));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_COMMA), 32));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_POINT), 33));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_P), 34));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Y), 35));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_F), 36));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_7), 37));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_8), 38));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_9), 39));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_MIN), 40));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SLASH), 41));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_CAPITAL), 42));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_A), 43));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_O), 44));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_E), 45));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_U), 46));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_I), 47));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCONTROL), 48, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LMENU), 49, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RWIN), 50, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RCONTROL), 51, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_D), 52));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_4), 53));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_5), 54));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_6), 55));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PLUS), 56));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_BACKSLASH), 57));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LSHIFT), 58, true, false));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_SEMI_COMMA), 59));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_Q), 60));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_J), 61));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_K), 62));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_X), 63));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_BACK), 64));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DELETE), 65));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_HOME), 66));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_PRIOR), 67));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RETURN), 68));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_0), 69));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_B), 70));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_1), 71));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_2), 72));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_3), 73));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_ENTER1), 74));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RSHIFT), 75, true, false));

  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LCL_TILDE), 76));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_INSERT), 77));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LEFT), 78));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RIGHT), 79));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_END), 80));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_NEXT), 81));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_UP), 82));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_DOWN), 83));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_PERI), 84));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_KP_ENTER2), 85));

  //For Pedals
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_LPEDAL), 86));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_MPEDAL), 87));
  aKBLayer.KBKeyList.Add(TKBKey.Create(GetKeyConfig(VK_RPEDAL), 88));
  result := aKBLayer;

end;

procedure TBaseKeyService.LoadLayerList(layerType: integer);
begin
  FKBLayers.Clear;
  if (layerType = LAYER_QWERTY) then
  begin
    if (GApplication = APPL_FSPRO) then
    begin
      FKBLayers.Add(GetTopLayerFSPro);
      FKBLayers.Add(GetBotLayerFSPro);
    end
    else if (GApplication = APPL_FSEDGE) then
    begin
      FKBLayers.Add(GetTopLayerFSEdge);
      FKBLayers.Add(GetBotLayerFSEdge);
    end
    else if (GApplication = APPL_RGB) then
    begin
      FKBLayers.Add(GetTopLayerRGB);
      FKBLayers.Add(GetBotLayerRGB);
    end
    else if (GApplication = APPL_ADV2) then
    begin
      FKBLayers.Add(GetQwertyTopLayerAdv2);
      FKBLayers.Add(GetQwertyBotLayerAdv2);
    end;
  end
  else if (layerType = LAYER_DVORAK) then
  begin
    if (GApplication = APPL_ADV2) then
    begin
      FKBLayers.Add(GetDvorakTopLayerAdv2);
      FKBLayers.Add(GetDvorakBotLayerAdv2);
    end;
  end
end;

procedure TBaseKeyService.UpdateCurrentKeyboardLayout;
begin
  FCurrentKBLayout := GetCurrentKeyoardLayout;
end;

//Checks if key is numeric (ascii 48 to 57)
function TBaseKeyService.IsNumericKey(aKey: TKey): boolean;
begin
  Result := (aKey.Key >= VK_0) and (aKey.Key <= VK_9);
end;

//Checks if key is alphabetic (ascii lowercase 65 to 90 or uppercase 97 to 122)
function TBaseKeyService.IsAlphaKey(aKey: TKey): boolean;
begin
  Result := (aKey.Key >= VK_A) and (aKey.Key <= VK_Z);
end;

//Takes a list of modifiers in string and fills a list of keys with the values
procedure TBaseKeyService.FillModifiersFromValues(aKeyList: TKeyList;
  sModifiers: string);
begin
  if sModifiers <> '' then
  begin
    if Pos(SHIFT_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_SHIFT).CopyKey);
    if Pos(L_SHIFT_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_LSHIFT).CopyKey);
    if Pos(R_SHIFT_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_RSHIFT).CopyKey);
    if Pos(CTRL_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_CONTROL).CopyKey);
    if Pos(L_CTRL_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_LCONTROL).CopyKey);
    if Pos(R_CTRL_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_RCONTROL).CopyKey);
    if Pos(ALT_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_MENU).CopyKey);
    if Pos(L_ALT_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_LMENU).CopyKey);
    if Pos(R_ALT_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_RMENU).CopyKey);
    if Pos(WIN_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_LWIN).CopyKey);
    if Pos(L_WIN_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_LWIN).CopyKey);
    if Pos(R_WIN_MOD, string(sModifiers)) <> 0 then
      aKeyList.Add(FindKeyConfig(VK_RWIN).CopyKey);
  end;
end;

function TBaseKeyService.GetKeyText(aKey: TKey; defaultValue: string;
  checkAltGr: boolean): string;
begin
{$ifdef Win32}
  if (aKey.ConvertToUnicode) then
    result := KeyToUnicode(aKey.Key, (IsShiftDown(aKey)) and (aKey.ShowShiftedValue), checkAltGr)
  else if (defaultValue <> '') then
    result := defaultValue
  else
    result := aKey.Value;
{$endif}
{$ifdef Darwin}
if (IsShiftDown(aKey) and (aKey.ShowShiftedValue)) then
  result := aKey.ShiftedValue
else if (defaultValue <> '') then
  result := defaultValue
else
  result := aKey.Value;
{$endif}
end;

//Checks if AltGr pressed (Ctrl + Alt)
function TBaseKeyService.IsAltGr(aKey: TKey): boolean;
begin
  if (Pos(CTRL_MOD, aKey.Modifiers) <> 0) and
    (Pos(ALT_MOD, aKey.Modifiers) <> 0) and
    (Length(aKey.Modifiers) = 3) then
    result := true
  else
    result := false;
end;

//Internal function to get output text
function TBaseKeyService.GetOutputText(aKeyList: TKeyList;
  var aKeysPos: TKeysPos; keyIdxToFind: integer; var keyIdxPos: integer
  ): string;
var
  i: integer;
  aKey: TKey;
  keyCount: integer;
  initLength: integer;
  mustAddKeyPos: boolean;

  procedure AddKeyPos(iStart, iEnd: integer);
  begin
    SetLength(aKeysPos, Length(aKeysPos) + 1);
    aKeysPos[Length(aKeysPos) - 1].iStart := iStart;
    aKeysPos[Length(aKeysPos) - 1].iEnd := iEnd;
  end;

  function GetKeyIdxPos(keyPos: integer; text: string): boolean;
  begin
    result := false;
    if (keyIdxToFind >= 0) and (keyIdxPos = -1) and (LengthUTF8(text) >= keyIdxToFind) then
    begin
      keyIdxPos := keyPos;
      result := true;
    end;
  end;

begin
  Result := '';
  aKeysPos := nil;
  keyIdxPos := -1;

  if aKeyList <> nil then
  begin
    keyCount := aKeyList.Count - 1;
    for i := 0 to keyCount do
    begin
      aKey := aKeyList.Items[i];
      initLength := LengthUTF8(Result);

      Result := Result + GetSingleKeyText(aKey, mustAddKeyPos);
      if (mustAddKeyPos) then
        AddKeyPos(initLength, LengthUTF8(Result));

      //Checks for keyIdxPos
      if GetKeyIdxPos(i, Result) then
        break;
    end;
  end;
end;

//Finds and returns the key in list of configurable keys using virtual key
function TBaseKeyService.FindKeyConfig(iKey: word): TKey;
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
function TBaseKeyService.FindKeyConfig(sKey: string): TKey;
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

function TBaseKeyService.GetKeyConfig(iKey: word): TKey;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ConfigKeys.Count - 1 do
  begin
    if ConfigKeys[i] <> nil then
      if ConfigKeys[i].Key = iKey then
      begin
        Result := ConfigKeys[i].CopyKey;
        break;
      end;
  end;
end;

//Adds modifier to list of active modifiers
procedure TBaseKeyService.AddModifier(key: word);
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
procedure TBaseKeyService.RemoveModifier(key: word);
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

procedure TBaseKeyService.ClearModifiers;
begin
  if (ActiveModifiers <> nil) then
    ActiveModifiers.Clear;
end;

function TBaseKeyService.IsWinKeyDown: boolean;
var
  i:integer;
begin
  result := false;

  for i := 0 to ActiveModifiers.Count - 1 do
    if ActiveModifiers.Items[i].Key in [VK_LWIN, VK_RWIN] then
      result := true;
end;

function TBaseKeyService.AddKey(kbKey: TKBKey; iKey: word; modifiers: string; insertAtPos: integer): TKey;
var
  aKey: TKey;
begin
  Result := nil;
  if (kbKey <> nil) then
  begin
    aKey := GetKeyWithModifier(iKey, modifiers);
    if (aKey <> nil) then
    begin
      //Add keypress to active pedal
      if (insertAtPos >= 0) then
        kbKey.ActiveMacro.Insert(insertAtPos, aKey)
      else
        kbKey.ActiveMacro.Add(aKey);

      //Returns complet output text
      Result := aKey;
    end;
  end;
end;

function TBaseKeyService.RemoveKey(kbKey: TKBKey; index: integer): boolean;
begin
  Result := false;
  if (kbKey <> nil) and (kbKey.IsMacro) then
  begin
    if (kbKey.ActiveMacro.Count >= index) and (index >= 0) then
    begin;
      kbKey.ActiveMacro.Remove(kbKey.ActiveMacro.Items[index]);
      result := true;
    end;
  end;
end;

function TBaseKeyService.GetModifierText: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to FActiveModifiers.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ',';
    Result := Result + GetKeyModifierText(FActiveModifiers.Items[i].Key);
  end;
end;

function TBaseKeyService.BackupMacro(aKbKey: TKbKey): boolean;
begin
  result := false;
  if (aKbKey <> nil) then
  begin
    if (FBackupMacro <> nil) then
      FreeAndNil(FBackupMacro);
    FBackupMacro := TKBKey.Create;
    FBackupMacro.Assign(aKbKey, rtAll);
    result := true;
  end;
end;

function TBaseKeyService.RestoreMacro(aKbKey: TKbKey): boolean;
begin
  result := false;
  if (aKbKey <> nil) and (FBackupMacro <> nil) then
  begin
    aKbKey.Assign(FBackupMacro, rtMacro);
    result := true;
  end;
end;

function TBaseKeyService.BackupKbKey(aKbKey: TKbKey): boolean;
begin
  result := false;
  if (aKbKey <> nil) then
  begin
    if (FBackupKey <> nil) then
      FreeAndNil(FBackupKey);
    FBackupKey := TKBKey.Create;
    FBackupKey.Assign(aKbKey, rtAll);
    result := true;
  end;
end;

function TBaseKeyService.RestoreKbKey(aKbKey: TKbKey): boolean;
begin
  result := false;
  if (aKbKey <> nil) and (FBackupKey <> nil) then
  begin
    aKbKey.Assign(FBackupKey, rtKey);
    result := true;
  end;
end;

//Returns macro text
function TBaseKeyService.GetMacroText(aKeyList: TKeyList; var aKeysPos: TKeysPos
  ): string;
var
  tmpInt: integer;
begin
  result := GetOutputText(aKeyList, aKeysPos, -1, tmpInt);
end;

//Returns key at specific position
function TBaseKeyService.GetKeyAtPosition(aKeyList: TKeyList; cursorPos: integer
  ): integer;
var
  keyPos: integer;
  tmpKeysPos: TKeysPos;
begin
  keyPos := -1;
  GetOutputText(aKeyList, tmpKeysPos, cursorPos, keyPos);
  result := keyPos;
end;

//Converts text file content to layer/key values
procedure TBaseKeyService.ConvertFromTextFileFmtFS(aLayoutContent: TStringList);
var
  aKey, newKey: TKey;
  sKey: string;
  keyState: TKeyState;
  keyStart, keyEnd: integer;
  lastKey: integer;
  previousKey: TKey;
  replacementKey: string;

  i: integer;
  tapHold: integer;
  currentLine: string;
  posSep: integer;
  isSingleKey: boolean;
  isMacro: boolean;
  isTapHold: boolean;
  isKeypadLayer: boolean;
  configText: string;
  valueText: string;
  aKBKey: TKBKey;
  layerIdx: integer;
  aCoTriggers: TKeyList;
  activeMacro: TKeyList;
  tempInt: integer;
begin
  lastKey := 0;
  aCoTriggers := TKeyList.Create;

  ResetLayout;

  if (aLayoutContent.Count > 0) then
  begin
    for i := 0 to aLayoutContent.Count - 1 do
    begin
      currentLine := TrimRight(AnsiLowerCase(aLayoutContent.Strings[i]));

      //Reset values
      isKeypadLayer := false;
      aCoTriggers.Clear;
      aKBKey := nil;
      activeMacro := nil;
      ClearModifiers;

      //Detect and remove fn text first
      isKeypadLayer := Pos(KEYPAD_KEY_EDGE, currentLine) <> 0;
      if (isKeypadLayer) then
      begin
        layerIdx := BOTLAYER_IDX;
        Delete(currentLine, 1, length(KEYPAD_KEY_EDGE)); //removes fn text
      end
      else
        layerIdx := TOPLAYER_IDX;

      posSep := Pos('>', currentLine);
      isSingleKey := Copy(currentLine, 1, 1) = SK_START;
      isMacro := Copy(currentLine, 1, 1) = MK_START;
      isTapHold := isSingleKey and (Pos('[' + TAP_AND_HOLD, currentLine) > 0);

      //Check if it's a valid line
      if (posSep <> 0) and (isSingleKey or isMacro or isTapHold) then
      begin
        configText := Copy(currentLine, 1, posSep - 1);
        valueText := Copy(currentLine, posSep + 1, Length(currentLine));

        if (isTapHold) then
        begin
          //Load configured key
          keyStart := Pos(SK_START, configText);
          keyEnd := Pos(SK_END, configText);
          sKey := Copy(configText, keyStart + 1, keyEnd - 2);

          aKey := FindKeyConfig(sKey);

          //Gets key from layer
          if aKey <> nil then
            aKBKey := GetKBKey(aKey.Key, layerIdx);

          if (aKBKey <> nil) then
          begin
            aKBKey.TapAndHold := true;
            //Load values for tap and hold
            for tapHold := 1 to 3 do
            begin
              keyStart := Pos(SK_START, valueText);
              keyEnd := Pos(SK_END, valueText);
              sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
              Delete(valueText, 1, keyEnd); //removes currentkey

              //Sets modified key
              if (tapHold = 1) or (tapHold = 3) then
              begin
                aKey := FindKeyConfig(sKey);
                if aKey <> nil then
                begin
                  if (tapHold = 1) then
                    aKBKey.TapAction := aKey.CopyKey
                  else
                    aKBKey.HoldAction := aKey.CopyKey;
                end;
              end
              else
              begin
                sKey := Copy(sKey, Length(TAP_AND_HOLD) + 1, Length(sKey));
                aKBKey.TimingDelay := ConvertToInt(sKey, DEFAULT_SPEED_TAP_HOLD);
              end;
            end;
          end;
        end
        else if (isSingleKey) then
        begin
          //Load configured key
          keyStart := Pos(SK_START, configText);
          keyEnd := Pos(SK_END, configText);
          sKey := Copy(configText, keyStart + 1, keyEnd - 2);

          aKey := FindKeyConfig(sKey);

          //Gets key from layer
          if aKey <> nil then
            aKBKey := GetKBKey(aKey.Key, layerIdx);

          if (aKBKey <> nil) then
          begin
            //Load value key
            keyStart := Pos(SK_START, valueText);
            keyEnd := Pos(SK_END, valueText);
            sKey := Copy(valueText, keyStart + 1, keyEnd - 2);

            //Sets modified key
            aKey := FindKeyConfig(sKey);
            if aKey <> nil then
              SetKBKey(aKBKey, aKey.Key);
          end;
        end
        else if (isMacro) then
        begin
          //Loads key and co-triggers
          while (configText <> '') do
          begin
            aKey := nil;
            keyStart := Pos(MK_START, configText);
            keyEnd := Pos(MK_END, configText);
            sKey := Copy(configText, keyStart + 1, keyEnd - 2);
            Delete(configText, 1, keyEnd); //remove currentkey

            aKey := FindKeyConfig(sKey);
            if (aKey <> nil) then
            begin
              //If it is Key + modifier
              if (IsModifier(aKey.Key)) and (configText <> '') then
                aCoTriggers.Add(aKey.CopyKey)
              else
                aKBKey := GetKBKey(aKey.Key, layerIdx);
            end;
          end;

          //Loads active Macro (max of 3)
          if (aKBKey <> nil) then
          begin
            if (aKBKey.Macro1.Count = 0) then
              activeMacro := aKBKey.Macro1
            else if (aKBKey.Macro2.Count = 0) then
              activeMacro := aKBKey.Macro2
            else if (aKBKey.Macro3.Count = 0) then
              activeMacro := aKBKey.Macro3;
          end;

          //If kbKey and activeMacro, load values
          if (aKBKey <> nil) and (activeMacro <> nil) and (aKBKey.CanAssignMacro) then
          begin
            aKBKey.IsMacro := true;

            if (aCoTriggers.Count >= 1) then
              activeMacro.CoTrigger1 := aCoTriggers[0].CopyKey;

            activeMacro.MacroSpeed := 0;
            activeMacro.MacroRptFreq := 0;

            //Get Macro text
            while (valueText <> '') do
            begin
              aKey := nil;
              keyStart := Pos(MK_START, valueText);
              keyEnd := Pos(MK_END, valueText);
              sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
              if copy(sKey, 1, 1) = '-' then  //Checks for keyup or keydown
                keyState := ksDown
              else if copy(sKey, 1, 1) = '+' then
                keyState := ksUp
              else
                keyState := ksNone;
              if keyState <> ksNone then
                Delete(sKey, 1, 1); //removes - or +
              Delete(valueText, 1, keyEnd); //removes currentkey

              if (activeMacro.Count = 0) and
                (Length(sKey) > 1) and
                (Copy(sKey, 1, Length(MACRO_SPEED_TEXT_EDGE)) = MACRO_SPEED_TEXT_EDGE) and
                (IsNumber(sKey, Length(MACRO_SPEED_TEXT_EDGE) + 1)) then
              begin
                tempInt := ConvertToInt(Copy(sKey, Length(MACRO_SPEED_TEXT_EDGE) + 1, Length(MACRO_SPEED_TEXT_EDGE) + 2));
                if (tempInt >= MACRO_SPEED_MIN_FS) and (tempInt <= MACRO_SPEED_MAX_FS) then
                  activeMacro.MacroSpeed := tempInt
                else
                  activeMacro.MacroSpeed := DEFAULT_MACRO_SPEED_FS;
              end
              else if (activeMacro.Count = 0) and
                (Length(sKey) > 1) and
                (Copy(sKey, 1, Length(MACRO_REPEAT_EDGE)) = MACRO_REPEAT_EDGE) and
                (IsNumber(sKey, Length(MACRO_REPEAT_EDGE) + 1)) then
              begin
                tempInt := ConvertToInt(Copy(sKey, Length(MACRO_REPEAT_EDGE) + 1, Length(MACRO_REPEAT_EDGE) + 2));
                if (tempInt >= MACRO_FREQ_MIN_FS) and (tempInt <= MACRO_FREQ_MAX_FS) then
                  activeMacro.MacroRptFreq := tempInt
                else
                  activeMacro.MacroRptFreq := DEFAULT_MACRO_FREQ_FS;
              end
              else
              begin
                aKey := FindKeyConfig(sKey);

                //Checks for replacement key values (US English)
                if aKey <> nil then
                begin
                  replacementKey := GetReplacementKey(aKey.Key, false);
                  if (replacementKey <> '') then
                    aKey := FindKeyConfig(replacementKey);
                end;
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
                      activeMacro.Add(aKey.CopyKey);
                    RemoveModifier(aKey.Key);
                  end
                  else //if no keyState (+ or -) and modifier add as single key
                    activeMacro.Add(aKey.CopyKey);
                end
                else if (keyState in [ksNone, ksDown]) then //Only add key on key down or key none
                begin
                  //Get the previous key
                  if activeMacro.Count > 0 then
                    previousKey := activeMacro.Items[activeMacro.Count - 1];

                  //If there are modifiers and we find Different Press and Release, we assign it to previous key
                  if (ActiveModifiers.Count > 0) and (aKey.Key = VK_DIF_PRESS_REL) and (previousKey <> nil) then
                  begin
                    previousKey.DiffPressRel := true;
                  end
                  else //Add the key
                  begin
                    newKey := akey.CopyKey;
                    newKey.Modifiers := GetModifierText; //Gets modifier values
                    activeMacro.Add(newKey); //Adds key
                  end;
                end;
                lastKey := aKey.Key;
              end;
            end; //end while loop valueText
          end;
        end;
      end;
    end;
  end;
  ClearModifiers;
end;

function TBaseKeyService.ConvertToTextFileFmtFS: TStringList;
var
  i, j: integer;
  lIdx, kIdx, mIdx: integer;
  lineText: string;
  saveValue: string;
  layoutContent: TStringList;
  aLayer: TKBLayer;
  aKbKey: TKBKey;
  aKey: TKey;
  aMacro: TKeyList;
  layerPrefix: string;
  prevModifiers: string;
  curKeyModifiers: TKeyList;
  prevKeyModifiers: TKeyList;
begin
  layoutContent := TStringList.Create;

  for lIdx := 0 to FKBLayers.Count - 1 do
  begin
    layerPrefix := '';
    aLayer := FKBLayers[lIdx];
    if (aLayer.LayerIndex = BOTLAYER_IDX) then
      layerPrefix := KEYPAD_KEY_EDGE;

    for kIdx := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      lineText := '';
      aKbKey := aLayer.KBKeyList[kIdx];

      //If key is tap and hold
      if (aKbKey.TapAndHold) and (aKbKey.TapAction <> nil) and (aKbKey.HoldAction <> nil) then
      begin
        lineText := layerPrefix + '[' + aKbKey.OriginalKey.SaveValue + ']>[' + aKbKey.TapAction.SaveValue + ']' +
          '[' + TAP_AND_HOLD + IntToStr(aKbKey.TimingDelay) + ']' + '[' + aKbKey.HoldAction.SaveValue + ']';
        layoutContent.Add(lineText);
      end
      //If key is modified / remapped
      else if (aKbKey.IsModified) then
      begin
        lineText := layerPrefix + '[' + aKbKey.OriginalKey.SaveValue + ']>[' + aKbKey.ModifiedKey.SaveValue + ']';
        layoutContent.Add(lineText);
      end;

      //jm todo Can be modified and have macro??
      //jm todo Do we put fn for macro values??
      if (aKbKey.IsMacro) then
      begin
        curKeyModifiers := TKeyList.Create;
        prevKeyModifiers := TKeyList.Create;

        //Loop through the 3 macros
        for mIdx := 1 to 3 do
        begin
          lineText := '';

          //Select the correct macro
          if (mIdx = 1) then
            aMacro := aKbKey.Macro1
          else if (mIdx = 2) then
            aMacro := aKbKey.Macro2
          else
            aMacro := aKbKey.Macro3;

          //Skip if macro has no keys
          if (aMacro.Count <= 0) then
            continue;

          //Add layer prefix if there
          lineText := lineText + layerPrefix;

          //Add the co-triggers first
          if (aMacro.CoTrigger1 <> nil) then
            lineText := lineText + '{' + aMacro.CoTrigger1.SaveValue + '}';

          //Add the modified key
          lineText := lineText + '{' + aKbKey.OriginalKey.SaveValue + '}';

          //Add the character separating config and value keys
          lineText := lineText + '>';

          if (aMacro.MacroSpeed >= 1) and (aMacro.MacroSpeed <= MACRO_SPEED_MAX_FS) then
          begin
            lineText := lineText + '{' + MACRO_SPEED_TEXT_EDGE + IntToStr(aMacro.MacroSpeed) + '}';
          end;

          if (aMacro.MacroRptFreq >= 1) and (aMacro.MacroRptFreq <= MACRO_FREQ_MAX_FS) then
          begin
            lineText := lineText + '{' + MACRO_REPEAT_EDGE + IntToStr(aMacro.MacroRptFreq) + '}';
          end;

          for i := 0 to aMacro.Count - 1 do
          begin
            prevModifiers := '';
            curKeyModifiers.Clear;
            prevKeyModifiers.Clear;;

            aKey := aMacro[i];

            //Gets the key save value
            saveValue := aKey.SaveValue;

            //Fills list of modifiers
            if not IsModifier(aKey.Key) then
              FillModifiersFromValues(curKeyModifiers, aKey.Modifiers);

            //Loads previous key modifiers
            if (i >= 1) and not(IsModifier(aMacro[i - 1].Key)) then
            begin
              prevModifiers := aMacro[i - 1].Modifiers;
              FillModifiersFromValues(prevKeyModifiers, prevModifiers);
            end;

            //Checks any change in modifiers (add or remove any)
            if (prevModifiers <> aKey.Modifiers) then
            begin
              //Add text + when modifier is released
              for j := 0 to prevKeyModifiers.Count - 1 do
              begin
                if not curKeyModifiers.ContrainsKey(prevKeyModifiers[j]) then
                  lineText := lineText + '{+' + prevKeyModifiers.Items[j].SaveValue + '}';
              end;

              //Add text - when modifier is pressed
              for j := 0 to curKeyModifiers.Count - 1 do
              begin
                if not prevKeyModifiers.ContrainsKey(curKeyModifiers[j]) then
                  lineText := lineText + '{-' + curKeyModifiers.Items[j].SaveValue + '}';
              end;
            end;

            //If different press & release with combination, write using the old method with up and down value
            if (aKey.DiffPressRel) then
            begin
              //Writes the key - and + if WriteDownUp is enabled, else writes only the value
              if aKey.WriteDownUp then
                lineText := lineText + '{-' + saveValue + '}' + DIFF_PRESS_REL_TEXT + '{+' + saveValue + '}'
              else
                lineText := lineText + '{' + saveValue + '}';
            end
            else  //Write the key value, only need the - / + for modifiers
              lineText := lineText + '{' + saveValue + '}';

            //If last key set modifiers +
            if (i = aMacro.Count - 1) then
            begin
              for j := 0 to curKeyModifiers.Count - 1 do
                lineText := lineText + '{+' + curKeyModifiers[j].SaveValue + '}';
            end;
          end;

          //Add line to text file
          layoutContent.Add(lineText);
        end;

        FreeAndNil(curKeyModifiers);
        FreeAndNil(prevKeyModifiers);
      end;
    end;
  end;

  Result := layoutContent;
end;

//Check if valid layout file
function TBaseKeyService.IsLayoutFile(aContent: TStringList): boolean;
var
  I: integer;
  posSep: integer;
  currentLine: string;
  configText: string;
  valueText: string;
  isSingleKey: boolean;
  isMacro: boolean;
  isColorValue: boolean;
  isTapHold: boolean;
  isKeypadLayer: boolean;
begin
  result := false;
  if (aContent.Count > 0) then
  begin
    for i := 0 to aContent.Count - 1 do
    begin
      currentLine := TrimRight(AnsiLowerCase(aContent.Strings[i]));

      //Detect and remove fn text first
      isKeypadLayer := Pos(KEYPAD_KEY_EDGE, currentLine) <> 0;
      if (isKeypadLayer) then
        Delete(currentLine, 1, length(KEYPAD_KEY_EDGE)); //removes fn text

      posSep := Pos('>', currentLine);
      isSingleKey := Copy(currentLine, 1, 1) = SK_START;
      isMacro := Copy(currentLine, 1, 1) = MK_START;
      isTapHold := isSingleKey and (Pos('[' + TAP_AND_HOLD, currentLine) > 0);

      //Check if it's a valid line
      if (posSep <> 0) and (isSingleKey or isMacro or isTapHold) then
        result := true;
    end;
  end;
end;

//Converts text file content to layer/key values
procedure TBaseKeyService.ConvertFromTextFileFmtRGB(aLayoutContent: TStringList);
var
  aKey, newKey: TKey;
  sKey: string;
  keyState: TKeyState;
  keyStart, keyEnd: integer;
  lastKey: integer;
  previousKey: TKey;
  replacementKey: string;

  i: integer;
  tapHold: integer;
  currentLine: string;
  posSep: integer;
  isSingleKey: boolean;
  isMacro: boolean;
  isTapHold: boolean;
  isKeypadLayer: boolean;
  configText: string;
  valueText: string;
  aKBKey: TKBKey;
  layerIdx: integer;
  aCoTriggers: TKeyList;
  activeMacro: TKeyList;
  tempInt: integer;
begin
  lastKey := 0;
  aCoTriggers := TKeyList.Create;

  ResetLayout;

  if (aLayoutContent.Count > 0) then
  begin
    for i := 0 to aLayoutContent.Count - 1 do
    begin
      currentLine := TrimRight(AnsiLowerCase(aLayoutContent.Strings[i]));

      //Reset values
      isKeypadLayer := false;
      aCoTriggers.Clear;
      aKBKey := nil;
      activeMacro := nil;
      ClearModifiers;

      //Detect and remove fn text first
      isKeypadLayer := Pos(KEYPAD_KEY_EDGE, currentLine) <> 0;
      if (isKeypadLayer) then
      begin
        layerIdx := BOTLAYER_IDX;
        Delete(currentLine, 1, length(KEYPAD_KEY_EDGE)); //removes fn text
      end
      else
        layerIdx := TOPLAYER_IDX;

      posSep := Pos('>', currentLine);
      isSingleKey := Copy(currentLine, 1, 1) = SK_START;
      isMacro := Copy(currentLine, 1, 1) = MK_START;
      isTapHold := isSingleKey and (Pos('[' + TAP_AND_HOLD, currentLine) > 0);

      //Check if it's a valid line
      if (posSep <> 0) and (isSingleKey or isMacro or isTapHold) then
      begin
        configText := Copy(currentLine, 1, posSep - 1);
        valueText := Copy(currentLine, posSep + 1, Length(currentLine));

        if (isTapHold) then
        begin
          //Load configured key
          keyStart := Pos(SK_START, configText);
          keyEnd := Pos(SK_END, configText);
          sKey := Copy(configText, keyStart + 1, keyEnd - 2);

          aKey := FindKeyConfig(sKey);

          //Gets key from layer
          if aKey <> nil then
            aKBKey := GetKBKey(aKey.Key, layerIdx);

          if (aKBKey <> nil) then
          begin
            aKBKey.TapAndHold := true;
            //Load values for tap and hold
            for tapHold := 1 to 3 do
            begin
              keyStart := Pos(SK_START, valueText);
              keyEnd := Pos(SK_END, valueText);
              sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
              Delete(valueText, 1, keyEnd); //removes currentkey

              //Sets modified key
              if (tapHold = 1) or (tapHold = 3) then
              begin
                aKey := FindKeyConfig(sKey);
                if aKey <> nil then
                begin
                  if (tapHold = 1) then
                    aKBKey.TapAction := aKey.CopyKey
                  else
                    aKBKey.HoldAction := aKey.CopyKey;
                end;
              end
              else
              begin
                sKey := Copy(sKey, Length(TAP_AND_HOLD) + 1, Length(sKey));
                aKBKey.TimingDelay := ConvertToInt(sKey, DEFAULT_SPEED_TAP_HOLD);
              end;
            end;
          end;
        end
        else if (isSingleKey) then
        begin
          //Load configured key
          keyStart := Pos(SK_START, configText);
          keyEnd := Pos(SK_END, configText);
          sKey := Copy(configText, keyStart + 1, keyEnd - 2);

          aKey := FindKeyConfig(sKey);

          //Gets key from layer
          if aKey <> nil then
            aKBKey := GetKBKey(aKey.Key, layerIdx);

          if (aKBKey <> nil) then
          begin
            //Load value key
            keyStart := Pos(SK_START, valueText);
            keyEnd := Pos(SK_END, valueText);
            sKey := Copy(valueText, keyStart + 1, keyEnd - 2);

            //Sets modified key
            aKey := FindKeyConfig(sKey);
            if aKey <> nil then
              SetKBKey(aKBKey, aKey.Key);
          end;
        end
        else if (isMacro) then
        begin
          //Loads key and co-triggers
          while (configText <> '') do
          begin
            aKey := nil;
            keyStart := Pos(MK_START, configText);
            keyEnd := Pos(MK_END, configText);
            sKey := Copy(configText, keyStart + 1, keyEnd - 2);
            Delete(configText, 1, keyEnd); //remove currentkey

            aKey := FindKeyConfig(sKey);
            if (aKey <> nil) then
            begin
              //If it is Key + modifier
              if (IsModifier(aKey.Key)) and (configText <> '') then
                aCoTriggers.Add(aKey.CopyKey)
              else
                aKBKey := GetKBKey(aKey.Key, layerIdx);
            end;
          end;

          //Loads active Macro (max of 3)
          if (aKBKey <> nil) then
          begin
            if (aKBKey.Macro1.Count = 0) then
              activeMacro := aKBKey.Macro1
            else if (aKBKey.Macro2.Count = 0) then
              activeMacro := aKBKey.Macro2
            else if (aKBKey.Macro3.Count = 0) then
              activeMacro := aKBKey.Macro3;
          end;

          //If kbKey and activeMacro, load values
          if (aKBKey <> nil) and (activeMacro <> nil) and (aKBKey.CanAssignMacro) then
          begin
            aKBKey.IsMacro := true;

            if (aCoTriggers.Count >= 1) then
              activeMacro.CoTrigger1 := aCoTriggers[0].CopyKey;

            activeMacro.MacroSpeed := 0;
            activeMacro.MacroRptFreq := 0;

            //Get Macro text
            while (valueText <> '') do
            begin
              aKey := nil;
              keyStart := Pos(MK_START, valueText);
              keyEnd := Pos(MK_END, valueText);
              sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
              if copy(sKey, 1, 1) = '-' then  //Checks for keyup or keydown
                keyState := ksDown
              else if copy(sKey, 1, 1) = '+' then
                keyState := ksUp
              else
                keyState := ksNone;
              if keyState <> ksNone then
                Delete(sKey, 1, 1); //removes - or +
              Delete(valueText, 1, keyEnd); //removes currentkey

              if (activeMacro.Count = 0) and
                (Length(sKey) > 1) and
                (Copy(sKey, 1, Length(MACRO_SPEED_TEXT_EDGE)) = MACRO_SPEED_TEXT_EDGE) and
                (IsNumber(sKey, Length(MACRO_SPEED_TEXT_EDGE) + 1)) then
              begin
                tempInt := ConvertToInt(Copy(sKey, Length(MACRO_SPEED_TEXT_EDGE) + 1, Length(MACRO_SPEED_TEXT_EDGE) + 2));
                if (tempInt >= 0{MACRO_SPEED_MIN}) and (tempInt <= MACRO_SPEED_MAX_RGB) then
                  activeMacro.MacroSpeed := tempInt
                else
                  activeMacro.MacroSpeed := DEFAULT_MACRO_SPEED_RGB;
              end
              else if (activeMacro.Count = 0) and
                (Length(sKey) > 1) and
                (Copy(sKey, 1, Length(MACRO_REPEAT_EDGE)) = MACRO_REPEAT_EDGE) and
                (IsNumber(sKey, Length(MACRO_REPEAT_EDGE) + 1)) then
              begin
                tempInt := ConvertToInt(Copy(sKey, Length(MACRO_REPEAT_EDGE) + 1, Length(MACRO_REPEAT_EDGE) + 2));
                if (tempInt >= 0{MACRO_FREQ_MIN}) and (tempInt <= MACRO_FREQ_MAX_RGB) then
                  activeMacro.MacroRptFreq := tempInt
                else
                  activeMacro.MacroRptFreq := DEFAULT_MACRO_FREQ_RGB;
              end
              else
              begin
                aKey := FindKeyConfig(sKey);

                //Checks for replacement key values (US English)
                if aKey <> nil then
                begin
                  replacementKey := GetReplacementKey(aKey.Key, false);
                  if (replacementKey <> '') then
                    aKey := FindKeyConfig(replacementKey);
                end;
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
                      activeMacro.Add(aKey.CopyKey);
                    RemoveModifier(aKey.Key);
                  end
                  else //if no keyState (+ or -) and modifier add as single key
                    activeMacro.Add(aKey.CopyKey);
                end
                else if (keyState in [ksNone, ksDown]) then //Only add key on key down or key none
                begin
                  //Get the previous key
                  if activeMacro.Count > 0 then
                    previousKey := activeMacro.Items[activeMacro.Count - 1];

                  //If there are modifiers and we find Different Press and Release, we assign it to previous key
                  if (ActiveModifiers.Count > 0) and (aKey.Key = VK_DIF_PRESS_REL) and (previousKey <> nil) then
                  begin
                    previousKey.DiffPressRel := true;
                  end
                  else //Add the key
                  begin
                    newKey := akey.CopyKey;
                    newKey.Modifiers := GetModifierText; //Gets modifier values
                    activeMacro.Add(newKey); //Adds key
                  end;
                end;
                lastKey := aKey.Key;
              end;
            end; //end while loop valueText
          end;
        end;
      end;
    end;
  end;

  ClearModifiers;
  if (aCoTriggers <> nil) then
    FreeAndNil(aCoTriggers);
end;

function TBaseKeyService.ConvertLedToTextFileFmtRGB: TStringList;
var
  kIdx: integer;
  lineText: string;
  layoutContent: TStringList;
  aLayer: TKBLayer;
  aKbKey: TKBKey;
  perKeyColors: boolean;
  sColor: string;
  keysSaved: boolean;
  lIdx: integer;
  layerPrefix: string;
  aLedMode: TLedMode;
  keyExcept: TKey;
begin
  layoutContent := TStringList.Create;
  perKeyColors := false;
  keysSaved := false;

  for lIdx := 0 to FKBLayers.Count - 1 do
  begin
    perKeyColors := false;
    layerPrefix := '';
    aLedMode := FLedMode;
    aLayer := FKBLayers[lIdx];
    if (aLayer.LayerIndex = BOTLAYER_IDX) then
    begin
      layerPrefix := KEYPAD_KEY_EDGE;
      aLedMode := FLedModeFn;
    end;

    if (aLedMode <> lmDisabled) then
    begin
      case aLedMode of
        lmIndividual:
        begin
          perKeyColors := true;
        end;
        lmMonochrome:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FLedColorMono, true))
          else
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FLedColorMonoFn, true));
        end;
        lmBreathe:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
            layoutContent.Add(layerPrefix + LED_BREATHE + '>' + LedSpeedToString(FLedSpeed))
          else
            layoutContent.Add(layerPrefix + LED_BREATHE + '>' + LedSpeedToString(FLedSpeedFn));
          perKeyColors := true;
        end;
        lmSpectrum:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
            layoutContent.Add(layerPrefix + LED_SPECTRUM + '>' + LedSpeedToString(FLedSpeed))
          else
            layoutContent.Add(layerPrefix + LED_SPECTRUM + '>' + LedSpeedToString(FLedSpeedFn));
        end;
        lmWave:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
            layoutContent.Add(layerPrefix + LED_WAVE + '>' + LedSpeedToString(FLedSpeed) + LedDirectionToString(FLedDirection))
          else
            layoutContent.Add(layerPrefix + LED_WAVE + '>' + LedSpeedToString(FLedSpeedFn) + LedDirectionToString(FLedDirectionFn));
        end;
        lmReactive:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_REACTIVE + '>' + RGBColorToString(FLedColorReactive, true) + LedSpeedToString(FLedSpeed));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorReactive, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_REACTIVE + '>' + RGBColorToString(FLedColorReactiveFn, true) + LedSpeedToString(FLedSpeedFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorReactiveFn, true));
          end;
        end;
        lmRipple:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_RIPPLE + '>' + RGBColorToString(FLedColorRipple, true) + LedSpeedToString(FLedSpeed));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorRipple, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_RIPPLE + '>' + RGBColorToString(FLedColorRippleFn, true) + LedSpeedToString(FLedSpeedFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorRippleFn, true));
          end;
        end;
        lmFireball:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_FIREBALL + '>' + RGBColorToString(FLedColorFireball, true) + LedSpeedToString(FLedSpeed));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorFireball, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_FIREBALL + '>' + RGBColorToString(FLedColorFireballFn, true) + LedSpeedToString(FLedSpeedFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorFireballFn, true));
          end;
        end;
        lmStarlight:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_STARLIGHT + '>' + RGBColorToString(FLedColorStarlight, true) + LedSpeedToString(FLedSpeed));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorStarlight, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_STARLIGHT + '>' + RGBColorToString(FLedColorStarlightFn, true) + LedSpeedToString(FLedSpeedFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorStarlightFn, true));
          end;
        end;
        lmRebound:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_REBOUND + '>' + RGBColorToString(FLedColorRebound, true) + LedSpeedToString(FLedSpeed) + LedDirectionToString(FLedDirection));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorRebound, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_REBOUND + '>' + RGBColorToString(FLedColorReboundFn, true) + LedSpeedToString(FLedSpeedFn) + LedDirectionToString(FLedDirectionFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorReboundFn, true));
          end;
        end;
        lmLoop:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_LOOP + '>' + RGBColorToString(FLedColorLoop, true) + LedSpeedToString(FLedSpeed) + LedDirectionToString(FLedDirection));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorLoop, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_LOOP + '>' + RGBColorToString(FLedColorLoopFn, true) + LedSpeedToString(FLedSpeedFn) + LedDirectionToString(FLedDirectionFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorLoopFn, true));
          end;
        end;
        lmPulse:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
            layoutContent.Add(layerPrefix + LED_PULSE + '>' + LedSpeedToString(FLedSpeed))
          else
            layoutContent.Add(layerPrefix + LED_PULSE + '>' + LedSpeedToString(FLedSpeedFn));
        end;
        lmRain:
        begin
          if aLayer.LayerIndex = TOPLAYER_IDX then
          begin
            layoutContent.Add(layerPrefix + LED_RAIN + '>' + RGBColorToString(FLedColorRain, true) + LedSpeedToString(FLedSpeed));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorRain, true));
          end
          else
          begin
            layoutContent.Add(layerPrefix + LED_RAIN + '>' + RGBColorToString(FLedColorRainFn, true) + LedSpeedToString(FLedSpeedFn));
            layoutContent.Add(layerPrefix + LED_MONO + '>' + RGBColorToString(FBaseLedColorRainFn, true));
          end;
        end;
        //lmPitchBlack:
        //begin
        //  layoutContent.Add(layerPrefix + LED_PITCH_BLACK);
        //end;
      end;

      if (perKeyColors) then
      begin
        //Only first layer for lighting
        //aLayer := FKBLayers[0];

        for kIdx := 0 to aLayer.KBKeyList.Count - 1 do
        begin
          lineText := '';
          aKbKey := aLayer.KBKeyList[kIdx];

          if (aKbKey.KeyColor <> clNone) then
          begin
            sColor :=  RGBColorToString(aKbKey.KeyColor);
            if (sColor <> '') then
            begin
              keysSaved := true;
              keyExcept := GetKeySaveException(aKbKey.OriginalKey.Key, aLayer.LayerIndex);
              if (keyExcept <> nil) then
                lineText := '[' + keyExcept.SaveValue + ']>' + sColor
              else
                lineText := '[' + aKbKey.OriginalKey.SaveValue + ']>' + sColor;

              //Add line to text file
              layoutContent.Add(layerPrefix + lineText);
            end;
          end;
        end;
      end;

      //If no color configured, set mono color to none
      if (LedMode = lmBreathe) and (not keysSaved) then
      begin
        layoutContent.Add(LED_MONO + '>' + RGBColorToString(clNone, true));
      end;
    end;
  end;
  Result := layoutContent;
end;

function TBaseKeyService.GetKeyLoadException(key: word; layerIdx: integer): TKey;
begin
  result := nil;
  if (layerIdx = BOTLAYER_IDX) then
  begin
    case key of
      VK_F1: result := GetKeyConfig(VK_VOLUME_MUTE);
      VK_F2: result := GetKeyConfig(VK_VOLUME_DOWN);
      VK_F3: result := GetKeyConfig(VK_VOLUME_UP);
      VK_F4: result := GetKeyConfig(VK_MEDIA_PLAY_PAUSE);
      VK_F5: result := GetKeyConfig(VK_MEDIA_PREV_TRACK);
      VK_F6: result := GetKeyConfig(VK_MEDIA_NEXT_TRACK);
      VK_PAUSE: result := GetKeyConfig(VK_INSERT);
      VK_DELETE: result := GetKeyConfig(VK_SCROLL);
    end;
  end;
end;

function TBaseKeyService.GetKeySaveException(key: word; layerIdx: integer): TKey;
begin
  result := nil;
  if (layerIdx = BOTLAYER_IDX) then
  begin
    case key of
      VK_VOLUME_MUTE: result := GetKeyConfig(VK_F1);
      VK_VOLUME_DOWN: result := GetKeyConfig(VK_F2);
      VK_VOLUME_UP: result := GetKeyConfig(VK_F3);
      VK_MEDIA_PLAY_PAUSE: result := GetKeyConfig(VK_F4);
      VK_MEDIA_PREV_TRACK: result := GetKeyConfig(VK_F5);
      VK_MEDIA_NEXT_TRACK: result := GetKeyConfig(VK_F6);
      VK_INSERT: result := GetKeyConfig(VK_PAUSE);
      VK_SCROLL: result := GetKeyConfig(VK_DELETE);
    end;
  end;
end;

procedure TBaseKeyService.SetAllKeyColor(keyColor: TColor; layerIdx: integer);
var
  keyIdx: integer;
  aLayer: TKBLayer;
  aKey: TKBKey;
begin
  aLayer := GetLayer(layerIdx);

  if (aLayer <> nil) then
  begin
    for keyIdx := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      aKey := aLayer.KBKeyList[keyIdx];
      aKey.KeyColor := keyColor;
    end;
  end;
end;

function TBaseKeyService.GetKeyWithModifier(iKey: word; modifiers: string): TKey;
var
  aKey: TKey;
  newKey: TKey;
begin
  Result := nil;
  aKey := FindKeyConfig(iKey);
  if (aKey <> nil) then
  begin
    newKey := aKey.CopyKey;
    newKey.Modifiers := modifiers;

    Result := newKey;
  end;
end;

//Check if file content is from Led file
function TBaseKeyService.IsLedFile(aContent: TStringList): boolean;
var
  lineCount: integer;
  posSep: integer;
  firstLine: string;
  configText: string;
  valueText: string;
  isSingleKey: boolean;
  isColorValue: boolean;
begin
  result := false;
  if (aContent.Count > 0) then
  begin
    lineCount := aContent.Count;

    //Check first line for Led Mode
    firstLine := AnsiLowerCase(aContent.Strings[0]);

    posSep := Pos('>', firstLine);
    isSingleKey := Copy(firstLine, 1, 1) = SK_START;

    //Check if it's a valid line
    if (posSep <> 0) and (isSingleKey) then
    begin
      configText := Copy(firstLine, 1, posSep - 1);
      valueText := Copy(firstLine, posSep + 1, Length(firstLine));

      //Has more than one [ in value text
      isColorValue := Pos(SK_START, Copy(valueText, 2, Length(valueText))) <> 0;

      result := (pos(LED_MONO, firstLine) <> 0) or
        (pos(LED_BREATHE, firstLine) <> 0) or
        (pos(LED_SPECTRUM, firstLine) <> 0) or
        (pos(LED_WAVE, firstLine) <> 0) or
        (pos(LED_REACTIVE, firstLine) <> 0) or
        (pos(LED_STARLIGHT, firstLine) <> 0) or
        (pos(LED_REBOUND, firstLine) <> 0) or
        (pos(LED_RIPPLE, firstLine) <> 0) or
        (pos(LED_FIREBALL, firstLine) <> 0) or
        (pos(LED_LOOP, firstLine) <> 0) or
        (pos(LED_PULSE, firstLine) <> 0) or
        (pos(LED_PULSE, firstLine) <> 0) or
        //(pos(LED_PITCH_BLACK, firstLine) <> 0) or
        isColorValue;
    end;
  end;
end;

procedure TBaseKeyService.ResetLedOptions;
begin
  SetAllKeyColor(clNone, TOPLAYER_IDX);
  SetAllKeyColor(clNone, BOTLAYER_IDX);
  FLedMode := lmDisabled;
  FLedModeFn := lmDisabled;
  FLedColorMono := DEFAULT_LED_COLOR;
  FLedColorMonoFn := DEFAULT_LED_COLOR;
  FLedColorReactive := DEFAULT_LED_COLOR;
  FLedColorReactiveFn := DEFAULT_LED_COLOR;
  FBaseLedColorReactive := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorReactiveFn := DEFAULT_LED_COLOR_BASE;
  FLedColorRipple := DEFAULT_LED_COLOR;
  FLedColorRippleFn := DEFAULT_LED_COLOR;
  FBaseLedColorRipple := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorRippleFn := DEFAULT_LED_COLOR_BASE;
  FLedColorFireball := DEFAULT_LED_COLOR;
  FLedColorFireballFn := DEFAULT_LED_COLOR;
  FBaseLedColorFireball := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorFireballFn := DEFAULT_LED_COLOR_BASE;
  FLedColorStarlight := DEFAULT_LED_COLOR;
  FLedColorStarlightFn := DEFAULT_LED_COLOR;
  FBaseLedColorStarlight := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorStarlightFn := DEFAULT_LED_COLOR_BASE;
  FLedColorRebound := DEFAULT_LED_COLOR;
  FLedColorReboundFn := DEFAULT_LED_COLOR;
  FBaseLedColorRebound := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorReboundFn := DEFAULT_LED_COLOR_BASE;
  FLedColorLoop := DEFAULT_LED_COLOR;
  FLedColorLoopFn := DEFAULT_LED_COLOR;
  FBaseLedColorLoop := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorLoopFn := DEFAULT_LED_COLOR_BASE;
  FLedColorRain := DEFAULT_LED_COLOR;
  FLedColorRainFn := DEFAULT_LED_COLOR;
  FBaseLedColorRain := DEFAULT_LED_COLOR_BASE;
  FBaseLedColorRainFn := DEFAULT_LED_COLOR_BASE;
  FLedSpeed := DEFAULT_LED_SPEED;
  FLedSpeedFn := DEFAULT_LED_SPEED;
  FLedDirection := DEFAULT_LED_DIR_INT;
  FLedDirectionFn := DEFAULT_LED_DIR_INT;
end;

procedure TBaseKeyService.ConvertLedFromTextFileFmtRGB(aLedContent: TStringList);
var
  aKey: TKey;
  sKey: string;
  keyStart, keyEnd: integer;
  i: integer;
  currentLine: string;
  posSep: integer;
  isSingleKey: boolean;
  configText: string;
  valueText: string;
  aKBKey: TKBKey;
  lineCount: integer;
  isKeypadLayer: boolean;
  aLedMode: TLedMode;
  layerIdx: integer;
  aColor: TColor;
  aLedTopLayer: TStringList;
  aLedBotLayer: TStringList;
  keyExcept: TKey;

  function GetLedSpeedFile(var sSpeed: string): integer;
  var
    sValue: string;
    iValue: integer;
  begin
    result := DEFAULT_LED_SPEED;

    //Load led speed
    keyStart := Pos(SK_START, sSpeed);
    keyEnd := Pos(SK_END, sSpeed);
    sValue := Copy(sSpeed, keyStart + 1, keyEnd - 2);
    Delete(sSpeed, 1, keyEnd); //removes value

    if (pos(LED_SPEED_EDGE, sValue) > 0) and (Length(sValue) > 1) and
      (IsNumber(sValue, Length(LED_SPEED_EDGE) + 1)) then
    begin
       iValue := ConvertToInt(Copy(sValue, Length(LED_SPEED_EDGE) + 1));
       if (iValue >= LED_SPEED_MIN) and (iValue <= LED_SPEED_MAX) then
          result := iValue
    end;
  end;

  function GetLedDirectionFile(var sDirection: string): integer;
  var
    sValue: string;
    sDir: string;
  begin
    result := 0;

    //Load led direction
    keyStart := Pos(SK_START, sDirection);
    keyEnd := Pos(SK_END, sDirection);
    sValue := Copy(sDirection, keyStart + 1, keyEnd - 2);
    Delete(sDirection, 1, keyEnd); //removes value

    if (pos(LED_DIR_EDGE, sValue) > 0) then
    begin
      sDir := Copy(sValue, Length(LED_DIR_EDGE) + 1);
      if (sDir = LED_DIR_LEFT) then
        result := LED_DIR_LEFT_INT
      else if (sDir = LED_DIR_RIGHT) then
        result := LED_DIR_RIGHT_INT
      else if (sDir = LED_DIR_UP) then
        result := LED_DIR_UP_INT
      else
        result := LED_DIR_DOWN_INT;
    end;
  end;

begin
  ResetLedOptions;

  try
    aLedTopLayer := TStringList.Create;
    aLedBotLayer := TStringList.Create;

    //Split content in 2 string lists
    if (aLedContent.Count > 0) then
    begin
      for i:= 0 to aLedContent.Count - 1 do
      begin
        currentLine := TrimRight(AnsiLowerCase(aLedContent.Strings[i]));
        if (Pos(KEYPAD_KEY_EDGE, currentLine) <> 0) then
          aLedBotLayer.Add(currentLine)
        else
          aLedTopLayer.Add(currentLine);
      end;
    end;

    //2 passes, first for top layer then bottom layer
    for layerIdx := TOPLAYER_IDX to BOTLAYER_IDX do
    begin
      if (layerIdx = TOPLAYER_IDX) then
        aLedContent := aLedTopLayer
      else
        aLedContent := aLedBotLayer;

      lineCount := aLedContent.Count;
      if (lineCount > 0) then
      begin
        //First line is led mode
        currentLine := TrimRight(AnsiLowerCase(aLedContent.Strings[0]));

        if (layerIdx = BOTLAYER_IDX) then
          Delete(currentLine, 1, length(KEYPAD_KEY_EDGE)); //removes fn text

        //Mono only if 1 line, else it's freestyle with mono option
        if (pos(LED_MONO, currentLine) > 0) and (lineCount = 1) then
        begin
          aLedMode := lmMonochrome;
          lineCount := 1;
        end
        else if (pos(LED_BREATHE, currentLine) > 0) THEN
          aLedMode := lmBreathe
        else if (pos(LED_SPECTRUM, currentLine) > 0) THEN
        begin
          aLedMode := lmSpectrum;
          lineCount := 1;
        end
        else if (pos(LED_WAVE, currentLine) > 0) THEN
        begin
          aLedMode := lmWave;
          lineCount := 1;
        end
        else if (pos(LED_REACTIVE, currentLine) > 0) THEN
        begin
          aLedMode := lmReactive;
          lineCount := 2;
        end
        else if (pos(LED_FIREBALL, currentLine) > 0) THEN
        begin
          aLedMode := lmFireball;
          lineCount := 2;
        end
        else if (pos(LED_STARLIGHT, currentLine) > 0) THEN
        begin
          aLedMode := lmStarlight;
          lineCount := 2;
        end
        else if (pos(LED_REBOUND, currentLine) > 0) THEN
        begin
          aLedMode := lmRebound;
          lineCount := 2;
        end
        else if (pos(LED_RIPPLE, currentLine) > 0) THEN
        begin
          aLedMode := lmRipple;
          lineCount := 1;
        end
        else if (pos(LED_LOOP, currentLine) > 0) THEN
        begin
          aLedMode := lmLoop;
          lineCount := 2;
        end
        else if (pos(LED_PULSE, currentLine) > 0) THEN
        begin
          aLedMode := lmPulse;
          lineCount := 1;
        end
        else if (pos(LED_RAIN, currentLine) > 0) THEN
        begin
          aLedMode := lmRain;
          lineCount := 2;
        end
        //else if (pos(LED_PITCH_BLACK, currentLine) > 0) THEN
        //begin
        //  aLedMode := lmPitchBlack;
        //  lineCount := 1;
        //end
        else if (currentLine = '') then
          aLedMode := lmDisabled
        else
          aLedMode := lmIndividual;

        if (layerIdx = BOTLAYER_IDX) then
          FLedModeFn := aLedMode
        else
          FLedMode := aLedMode;

        for i := 0 to lineCount - 1 do
        begin
          if (aLedContent.Count > i) then
          begin
            currentLine := AnsiLowerCase(aLedContent.Strings[i]);
            if (currentLine <> '') then
            begin
              //Check if it's keypad layer
              if (layerIdx = BOTLAYER_IDX) then
                Delete(currentLine, 1, length(KEYPAD_KEY_EDGE)); //removes fn text

              //Reset values
              aKBKey := nil;

              posSep := Pos('>', currentLine);
              isSingleKey := Copy(currentLine, 1, 1) = SK_START;

              //Check if it's a valid line
              if (posSep <> 0) and (isSingleKey) then
              begin
                configText := Copy(currentLine, 1, posSep - 1);
                valueText := Copy(currentLine, posSep + 1, Length(currentLine));

                if (aLedMode = lmIndividual) or ((i > 0) and (aLedMode = lmBreathe)) then
                begin
                  //If mono tag, then set color for all keys
                  if (pos(LED_MONO, currentLine) > 0) then
                  begin
                    SetAllKeyColor(RGBStringToColor(valueText, clNone), layerIdx);
                  end
                  else
                  begin
                    //Load configured key
                    keyStart := Pos(SK_START, configText);
                    keyEnd := Pos(SK_END, configText);
                    sKey := Copy(configText, keyStart + 1, keyEnd - 2);

                    aKey := FindKeyConfig(sKey);

                    //Gets key from top layer
                    if aKey <> nil then
                    begin
                      keyExcept := GetKeyLoadException(aKey.Key, layerIdx);
                      if (keyExcept <> nil) then
                        aKBKey := GetKBKey(keyExcept.Key, layerIdx)
                      else
                        aKBKey := GetKBKey(aKey.Key, layerIdx);
                    end;
                  end;
                end;

                if (aKBKey <> nil) and (aLedMode in [lmIndividual, lmBreathe]) then
                begin
                  aKBKey.KeyColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                end
                else if (aLedMode = lmBreathe) and (i = 0) then
                begin
                  if (layerIdx = BOTLAYER_IDX) then
                    FLedSpeedFn := GetLedSpeedFile(valueText)
                  else
                    FLedSpeed := GetLedSpeedFile(valueText);
                end
                else if (aLedMode in [lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound, lmLoop, lmRain]) and (i = 1) then //Mono second line
                begin
                  if (pos(LED_MONO, currentLine) > 0) then
                  begin
                    aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR_BASE);
                    case aLedMode of
                      lmReactive:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorReactiveFn := aColor
                        else
                          FBaseLedColorReactive := aColor;
                      end;
                      lmRipple:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorRippleFn := aColor
                        else
                          FBaseLedColorRipple := aColor;
                      end;
                      lmFireball:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorFireballFn := aColor
                        else
                          FBaseLedColorFireball := aColor;
                      end;
                      lmStarlight:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorStarlightFn := aColor
                        else
                          FBaseLedColorStarlight := aColor;
                      end;
                      lmRebound:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorReboundFn := aColor
                        else
                          FBaseLedColorRebound := aColor;
                      end;
                      lmLoop:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorLoopFn := aColor
                        else
                          FBaseLedColorLoop := aColor;
                      end;
                      lmRain:
                      begin
                        if (layerIdx = BOTLAYER_IDX) then
                          FBaseLedColorRainFn := aColor
                        else
                          FBaseLedColorRain := aColor;
                      end;
                    end;
                  end;
                end
                else if (aLedMode = lmMonochrome) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                    FLedColorMonoFn := aColor
                  else
                    FLedColorMono := aColor;
                end
                else if (aLedMode in [lmSpectrum]) then
                begin
                  if (layerIdx = BOTLAYER_IDX) then
                    FLedSpeedFn := GetLedSpeedFile(valueText)
                  else
                    FLedSpeed := GetLedSpeedFile(valueText);
                end
                else if (aLedMode = lmWave) then
                begin
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                    FLedDirectionFn := GetLedDirectionFile(valueText);
                  end
                  else
                  begin
                    FLedSpeed := GetLedSpeedFile(valueText);
                    FLedDirection := GetLedDirectionFile(valueText);
                  end;
                end
                else if (aLedMode = lmReactive) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorReactiveFn := aColor;
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                  end;
                  begin
                    FLedColorReactive := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                  end;
                end
                else if (aLedMode = lmRipple) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorRippleFn := aColor;
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                  end;
                  begin
                    FLedColorRipple := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                  end;
                end
                else if (aLedMode = lmFireball) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorFireballFn := aColor;
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                  end;
                  begin
                    FLedColorFireball := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                  end;
                end
                else if (aLedMode = lmStarlight) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorStarlightFn := aColor;
                    FLedSpeedFn:= GetLedSpeedFile(valueText);
                  end
                  else
                  begin
                    FLedColorStarlight := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                  end;
                end
                else if (aLedMode = lmRebound) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorReboundFn := aColor;
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                    FLedDirectionFn := GetLedDirectionFile(valueText);
                    if not(FLedDirectionFn in [LED_DIR_LEFT_INT, LED_DIR_UP_INT]) then
                      FLedDirectionFn := DEFAULT_LED_DIR_INT;
                  end
                  else
                  begin
                    FLedColorRebound := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                    FLedDirection := GetLedDirectionFile(valueText);
                    if not(FLedDirection in [LED_DIR_LEFT_INT, LED_DIR_UP_INT]) then
                      FLedDirection := DEFAULT_LED_DIR_INT;
                  end;
                end
                else if (aLedMode = lmLoop) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorLoopFn := aColor;
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                    FLedDirectionFn := GetLedDirectionFile(valueText);
                  end
                  else
                  begin
                    FLedColorLoop := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                    FLedDirection := GetLedDirectionFile(valueText);
                  end;
                end
                else if (aLedMode = lmPulse) then
                begin
                  if (layerIdx = BOTLAYER_IDX) then
                    FLedSpeedFn := GetLedSpeedFile(valueText)
                  else
                    FLedSpeed := GetLedSpeedFile(valueText);
                end
                else if (aLedMode = lmRain) then
                begin
                  aColor := RGBStringToColor(valueText, DEFAULT_LED_COLOR);
                  if (layerIdx = BOTLAYER_IDX) then
                  begin
                    FLedColorRainFn := aColor;
                    FLedSpeedFn := GetLedSpeedFile(valueText);
                  end
                  else
                  begin
                    FLedColorRain := aColor;
                    FLedSpeed := GetLedSpeedFile(valueText);
                  end;
                end
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    if (aLedTopLayer <> nil) then
      FreeAndNil(aLedTopLayer);
    if (aLedBotLayer <> nil) then
      FreeAndNil(aLedBotLayer);
  end;
end;

//Checks if value is a keypad exception (Adv2)
function TBaseKeyService.KeyPadException(value: string): boolean;
begin
  result := (value = 'menu') or
    (value = 'play') or
    (value = 'prev') or
    (value = 'next') or
    (value = 'calc') or
    (value = 'kpshft') or
    (value = 'mute') or
    (value = 'vol-') or
    (value = 'vol+') or
    (value = 'kp0') or (value = 'kp1') or (value = 'kp2') or
    (value = 'kp3') or (value = 'kp4') or (value = 'kp5') or
    (value = 'kp6') or (value = 'kp7') or (value = 'kp8') or (value = 'kp9') or
    (value = 'numlk') or
    (value = 'kp=') or
    (value = 'kpdiv') or
    (value = 'kpmult') or
    (value = 'kpmin') or
    (value = 'kpplus') or
    (value = 'kpenter1') or (value = 'kpenter2') or
    (value = 'kp.')  or
    (value = 'kp-insert');
end;

//Checks if value is a keypad exception (Adv2)
function TBaseKeyService.GetKeyPadException(value: string): integer;
begin
  case value of
    'menu': result := VK_KP_MENU;
    'play': result := VK_KP_PLAY;
    'prev': result := VK_KP_PREV;
    'next': result := VK_KP_NEXT;
    'calc': result := VK_KP_CALC;
    'kpshft': result := VK_KP_KPSHIFT;
    'mute': result := VK_KP_MUTE;
    'vol-': result := VK_KP_VOLDOWN;
    'vol+': result := VK_KP_VOLUP;
    'numlk': result := VK_KP_NUMLCK;
    'kp=': result := VK_KP_EQUAL;
    'kpdiv': result := VK_KP_DIVIDE;
    'kpmult': result := VK_KP_MULT;
    'kp0': result := VK_KP_0;
    'kp1': result := VK_KP_1;
    'kp2': result := VK_KP_2;
    'kp3': result := VK_KP_3;
    'kp4': result := VK_KP_4;
    'kp5': result := VK_KP_5;
    'kp6': result := VK_KP_6;
    'kp7': result := VK_KP_7;
    'kp8': result := VK_KP_8;
    'kp9': result := VK_KP_9;
    'kpmin': result := VK_KP_MIN;
    'kpplus': result := VK_KP_PLUS;
    'kpenter1': result := VK_KP_ENTER1;
    'kpenter2': result := VK_KP_ENTER2;
    'kp.': result := VK_KP_PERI;
    'insert': result := VK_INSERT;
    else
      result := -1;
  end;
end;

procedure TBaseKeyService.InitGifs;
var
  gifFrame: TGifFrame;
  idx: integer;
begin
  FRainGif := TGif.Create;
  FReactiveGif := TGif.Create;
  FRippleGif := TGif.Create;
  FFireballGif := TGif.Create;
  FLoopDownGif := TGif.Create;
  FLoopUpGif := TGif.Create;
  FLoopLeftGif := TGif.Create;
  FLoopRightGif := TGif.Create;
  FReboundHorGif := TGif.Create;
  FReboundVerGif := TGif.Create;
  FStartlightGif := TGif.Create;

  //Rain Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(88);
  RainGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(83);
  RainGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(82);
  RainGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(87);
  gifFrame.Keys.Add(94);
  RainGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(90);
  RainGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(10);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(86);
  gifFrame.Keys.Add(89);
  gifFrame.Keys.Add(91);
  RainGif.Add(gifFrame);
  //End Rain Gif

  //Reactive Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  ReactiveGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(45);
  ReactiveGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(45);
  ReactiveGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(71);
  ReactiveGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(73);
  ReactiveGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(73);
  ReactiveGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(73);
  ReactiveGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(73);
  ReactiveGif.Add(gifFrame);

  //Frame 9
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(73);
  ReactiveGif.Add(gifFrame);

  //Frame 10
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 11
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 12
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 13
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 14
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 15
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 16
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 17
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 18
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  ReactiveGif.Add(gifFrame);

  //Frame 19
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(74);
  ReactiveGif.Add(gifFrame);

  //Frame 20
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(74);
  ReactiveGif.Add(gifFrame);

  //Frame 21
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(74);
  ReactiveGif.Add(gifFrame);

  //Frame 22
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  ReactiveGif.Add(gifFrame);

  //Frame 23
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(61);
  ReactiveGif.Add(gifFrame);

  //Frame 24
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(61);
  ReactiveGif.Add(gifFrame);
  //End Reactive Gif

  //Ripple Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(55);
  RippleGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  RippleGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(86);
  gifFrame.Keys.Add(87);
  RippleGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(84);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(88);
  RippleGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(77);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(83);
  RippleGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(10);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(76);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(82);
  gifFrame.Keys.Add(90);
  gifFrame.Keys.Add(91);
  gifFrame.Keys.Add(92);
  RippleGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  gifFrame.Keys.Add(93);
  gifFrame.Keys.Add(94);
  RippleGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  RippleGif.Add(gifFrame);
  //End Ripple Gif

  //Fireball Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(19);
  FireballGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(89);
  FireballGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(90);
  FireballGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(91);
  FireballGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(92);
  FireballGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(93);
  FireballGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(94);
  FireballGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(57);
  FireballGif.Add(gifFrame);

  //Frame 9
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(58);
  FireballGif.Add(gifFrame);

  //Frame 10
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(48);
  FireballGif.Add(gifFrame);

  //Frame 11
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(49);
  FireballGif.Add(gifFrame);

  //Frame 12
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(50);
  FireballGif.Add(gifFrame);
  //End Fireball Gif

  //Loop Down Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  for idx := 0 to 16 do
    gifFrame.Keys.Add(idx);
  LoopDownGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  for idx := 0 to 33 do
    gifFrame.Keys.Add(idx);
  LoopDownGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  for idx := 17 to 50 do
    gifFrame.Keys.Add(idx);
  LoopDownGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  for idx := 34 to 66 do
    gifFrame.Keys.Add(idx);
  LoopDownGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  for idx := 51 to 82 do
    gifFrame.Keys.Add(idx);
  LoopDownGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  for idx := 67 to 94 do
    gifFrame.Keys.Add(idx);
  LoopDownGif.Add(gifFrame);
  //End Loop Down Gif

  //Loop Up Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  for idx := 83 to 94 do
    gifFrame.Keys.Add(idx);
  LoopUpGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  for idx := 67 to 94 do
    gifFrame.Keys.Add(idx);
  LoopUpGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  for idx := 51 to 82 do
    gifFrame.Keys.Add(idx);
  LoopUpGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  for idx := 34 to 66 do
    gifFrame.Keys.Add(idx);
  LoopUpGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  for idx := 17 to 50 do
    gifFrame.Keys.Add(idx);
  LoopUpGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  for idx := 0 to 33 do
    gifFrame.Keys.Add(idx);
  LoopUpGif.Add(gifFrame);
  //End Loop Up Gif

  //Loop Left Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(82);
  gifFrame.Keys.Add(94);
  LoopLeftGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(82);
  gifFrame.Keys.Add(94);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(93);
  LoopLeftGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(93);
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(92);
  LoopLeftGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(92);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(91);
  LoopLeftGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(91);
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  LoopLeftGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(77);
  LoopLeftGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(10);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(77);
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(76);
  LoopLeftGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(76);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  LoopLeftGif.Add(gifFrame);

  //Frame 9
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(74);
  LoopLeftGif.Add(gifFrame);

  //Frame 10
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  LoopLeftGif.Add(gifFrame);

  //Frame 11
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(72);
  LoopLeftGif.Add(gifFrame);

  //Frame 12
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(71);
  LoopLeftGif.Add(gifFrame);

  //Frame 13
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(87);
  LoopLeftGif.Add(gifFrame);

  //Frame 14
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(86);
  gifFrame.Keys.Add(87);
  LoopLeftGif.Add(gifFrame);

  //Frame 15
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(84);
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(86);
  LoopLeftGif.Add(gifFrame);

  //Frame 16
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(83);
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(84);
  LoopLeftGif.Add(gifFrame);

  //Frame 17
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(83);
  LoopLeftGif.Add(gifFrame);
  //End Loop Left Gif

  //Loop Right Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(83);
  LoopRightGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(83);
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(84);
  LoopRightGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(84);
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(86);
  LoopRightGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(86);
  gifFrame.Keys.Add(87);
  LoopRightGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(87);
  LoopRightGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(71);
  LoopRightGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(72);
  LoopRightGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  LoopRightGif.Add(gifFrame);

  //Frame 9
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(74);
  LoopRightGif.Add(gifFrame);

  //Frame 10
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(76);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  LoopRightGif.Add(gifFrame);

  //Frame 11
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(10);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(77);
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(76);
  LoopRightGif.Add(gifFrame);

  //Frame 12
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(77);
  LoopRightGif.Add(gifFrame);

  //Frame 13
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(91);
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  LoopRightGif.Add(gifFrame);

  //Frame 14
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(92);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(91);
  LoopRightGif.Add(gifFrame);

  //Frame 15
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(93);
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(92);
  LoopRightGif.Add(gifFrame);

  //Frame 16
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(82);
  gifFrame.Keys.Add(94);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(93);
  LoopRightGif.Add(gifFrame);

  //Frame 17
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(82);
  gifFrame.Keys.Add(94);
  LoopRightGif.Add(gifFrame);
  //End Loop Right Gif

  //Rebound Horizontal Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(0);
  gifFrame.Keys.Add(17);
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(51);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(67);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(83);
  gifFrame.Keys.Add(84);
  ReboundHorGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(84);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(86);
  ReboundHorGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(86);
  gifFrame.Keys.Add(87);
  ReboundHorGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(87);
  ReboundHorGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(72);
  ReboundHorGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  ReboundHorGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(88);
  ReboundHorGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  ReboundHorGif.Add(gifFrame);

  //Frame 9
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(76);
  gifFrame.Keys.Add(89);
  ReboundHorGif.Add(gifFrame);

  //Frame 10
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(10);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(76);
  gifFrame.Keys.Add(77);
  ReboundHorGif.Add(gifFrame);

  //Frame 11
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(77);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  ReboundHorGif.Add(gifFrame);

  //Frame 12
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(90);
  gifFrame.Keys.Add(91);
  ReboundHorGif.Add(gifFrame);

  //Frame 13
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(91);
  gifFrame.Keys.Add(92);
  ReboundHorGif.Add(gifFrame);

  //Frame 14
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(92);
  gifFrame.Keys.Add(93);
  ReboundHorGif.Add(gifFrame);

  //Frame 15
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(16);
  gifFrame.Keys.Add(33);
  gifFrame.Keys.Add(50);
  gifFrame.Keys.Add(66);
  gifFrame.Keys.Add(82);
  gifFrame.Keys.Add(94);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(93);
  ReboundHorGif.Add(gifFrame);

  //Frame 16
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(49);
  gifFrame.Keys.Add(65);
  gifFrame.Keys.Add(81);
  gifFrame.Keys.Add(93);
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(92);
  ReboundHorGif.Add(gifFrame);

  //Frame 17
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(14);
  gifFrame.Keys.Add(31);
  gifFrame.Keys.Add(48);
  gifFrame.Keys.Add(64);
  gifFrame.Keys.Add(80);
  gifFrame.Keys.Add(92);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(91);
  ReboundHorGif.Add(gifFrame);

  //Frame 18
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(30);
  gifFrame.Keys.Add(47);
  gifFrame.Keys.Add(63);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(91);
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  ReboundHorGif.Add(gifFrame);

  //Frame 19
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(12);
  gifFrame.Keys.Add(29);
  gifFrame.Keys.Add(46);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(78);
  gifFrame.Keys.Add(90);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(77);
  ReboundHorGif.Add(gifFrame);

  //Frame 20
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(10);
  gifFrame.Keys.Add(11);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(61);
  gifFrame.Keys.Add(77);
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(76);
  ReboundHorGif.Add(gifFrame);

  //Frame 21
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(9);
  gifFrame.Keys.Add(27);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(44);
  gifFrame.Keys.Add(60);
  gifFrame.Keys.Add(76);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  ReboundHorGif.Add(gifFrame);

  //Frame 22
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(26);
  gifFrame.Keys.Add(42);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(59);
  gifFrame.Keys.Add(75);
  gifFrame.Keys.Add(89);
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(74);
  ReboundHorGif.Add(gifFrame);

  //Frame 23
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(7);
  gifFrame.Keys.Add(25);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(58);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  ReboundHorGif.Add(gifFrame);

  //Frame 24
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(6);
  gifFrame.Keys.Add(24);
  gifFrame.Keys.Add(40);
  gifFrame.Keys.Add(57);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(88);
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(72);
  ReboundHorGif.Add(gifFrame);

  //Frame 25
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(5);
  gifFrame.Keys.Add(23);
  gifFrame.Keys.Add(39);
  gifFrame.Keys.Add(56);
  gifFrame.Keys.Add(72);
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(71);
  ReboundHorGif.Add(gifFrame);

  //Frame 26
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(4);
  gifFrame.Keys.Add(22);
  gifFrame.Keys.Add(38);
  gifFrame.Keys.Add(55);
  gifFrame.Keys.Add(71);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(87);
  ReboundHorGif.Add(gifFrame);

  //Frame 27
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(3);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(54);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(86);
  gifFrame.Keys.Add(87);
  ReboundHorGif.Add(gifFrame);

  //Frame 28
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(18);
  gifFrame.Keys.Add(35);
  gifFrame.Keys.Add(52);
  gifFrame.Keys.Add(68);
  gifFrame.Keys.Add(84);
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(20);
  gifFrame.Keys.Add(36);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(69);
  gifFrame.Keys.Add(85);
  gifFrame.Keys.Add(86);
  ReboundHorGif.Add(gifFrame);

  //End Rebound Horizontal Gif

  //Rebound Vertical Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  for idx := 0 to 33 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  for idx := 17 to 50 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  for idx := 34 to 66 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  for idx := 51 to 82 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  for idx := 67 to 94 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  for idx := 51 to 82 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  for idx := 34 to 66 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  for idx := 17 to 50 do
    gifFrame.Keys.Add(idx);
  ReboundVerGif.Add(gifFrame);
  //End Rebound Vertical Gif

  //Starlight Gif
  //Frame 1
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 2
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  //gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37); //
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 3
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(15); //
  //gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 4
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(28);
  //gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(70); //
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 5
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1); //
  //gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 6
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13); //
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(43);
  //gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 7
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(41); //
  gifFrame.Keys.Add(43);
  //gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(73);
  StartlightGif.Add(gifFrame);

  //Frame 8
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(41);
  //gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(85); //
  StartlightGif.Add(gifFrame);

  //Frame 9
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(21); //
  gifFrame.Keys.Add(28);
  //gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 10
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62); //
  gifFrame.Keys.Add(70);
  //gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 11
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(21);
  //gifFrame.Keys.Add(28);
  gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(79); //
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 12
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(21);
  //gifFrame.Keys.Add(37);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(74); //
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 13
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(8); //
  gifFrame.Keys.Add(13);
  //gifFrame.Keys.Add(15);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 14
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(19); //
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62);
  //gifFrame.Keys.Add(70);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 15
  gifFrame := TGifFrame.Create;
  //gifFrame.Keys.Add(1);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(32); //
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 16
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2); //
  gifFrame.Keys.Add(8);
  //gifFrame.Keys.Add(13);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 17
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(32);
  //gifFrame.Keys.Add(41);
  gifFrame.Keys.Add(45); //
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 18
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53); //
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  //gifFrame.Keys.Add(85);
  StartlightGif.Add(gifFrame);

  //Frame 19
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  //gifFrame.Keys.Add(21);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34); //
  gifFrame.Keys.Add(43); //
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  StartlightGif.Add(gifFrame);

  //Frame 20
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  //gifFrame.Keys.Add(62);
  gifFrame.Keys.Add(73); //
  gifFrame.Keys.Add(74);
  gifFrame.Keys.Add(79);
  StartlightGif.Add(gifFrame);

  //Frame 21
  gifFrame := TGifFrame.Create;
  gifFrame.Keys.Add(2);
  gifFrame.Keys.Add(8);
  gifFrame.Keys.Add(19);
  gifFrame.Keys.Add(28); //
  gifFrame.Keys.Add(32);
  gifFrame.Keys.Add(34);
  gifFrame.Keys.Add(43);
  gifFrame.Keys.Add(45);
  gifFrame.Keys.Add(53);
  gifFrame.Keys.Add(73);
  gifFrame.Keys.Add(74);
  //gifFrame.Keys.Add(79);
  StartlightGif.Add(gifFrame);

  //End Starlight Gif
end;

function TBaseKeyService.GetLedMode: TLedMode;
begin
  result := FLedMode;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedModeFn;
  end;
end;

procedure TBaseKeyService.SetLedMode(aLedMode: TLedMode);
begin
  if (ActiveLayer <> nil) then
  begin
    //Pitch black set both layers to same mode
    //if (aLedMode = lmPitchBlack) then
    //begin
    //  FLedMode := aLedMode;
    //  FLedModeFn := aLedMode;
    //end
    //else
    //begin
      if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
        FLedMode := aLedMode
      else
        FLedModeFn := aLedMode;
    //end;
  end
  else
    FLedMode := aLedMode;
end;

function TBaseKeyService.GetLedSpeed: integer;
begin
  result := FLedSpeed;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedSpeedFn;
  end;
end;

procedure TBaseKeyService.SetLedSpeed(aLedSpeed: integer);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedSpeed := aLedSpeed
    else
      FLedSpeedFn := aLedSpeed;
  end
  else
    FLedSpeed := aLedSpeed;
end;

function TBaseKeyService.GetLedDirection: integer;
begin
  result := FLedDirection;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedDirectionFn;
  end;
end;

procedure TBaseKeyService.SetLedDirection(aDirection: integer);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedDirection := aDirection
    else
      FLedDirectionFn := aDirection;
  end
  else
    FLedDirection := aDirection;
end;

procedure TBaseKeyService.SetLedColorMono(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorMono := aColor
    else
      FLedColorMonoFn := aColor;
  end
  else
    FLedColorMono := aColor;
end;

function TBaseKeyService.GetLedColorMono: TColor;
begin
  result := FLedColorMono;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorMonoFn;
  end;
end;

function TBaseKeyService.GetLedColorReactive: TColor;
begin
  result := FLedColorReactive;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorReactiveFn;
  end;
end;

procedure TBaseKeyService.SetLedColorReactive(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorReactive := aColor
    else
      FLedColorReactiveFn := aColor;
  end
  else
    FLedColorReactive := aColor;
end;

function TBaseKeyService.GetBaseLedColorReactive: TColor;
begin
  result := FBaseLedColorReactive;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorReactiveFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorReactive(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorReactive := aColor
    else
      FBaseLedColorReactiveFn := aColor;
  end
  else
    FBaseLedColorReactive := aColor;
end;

function TBaseKeyService.GetLedColorRipple: TColor;
begin
  result := FLedColorRipple;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorRippleFn;
  end;
end;

procedure TBaseKeyService.SetLedColorRipple(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorRipple := aColor
    else
      FLedColorRippleFn := aColor;
  end
  else
    FLedColorRipple := aColor;
end;

function TBaseKeyService.GetBaseLedColorRipple: TColor;
begin
  result := FBaseLedColorRipple;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorRippleFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorRipple(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorRipple := aColor
    else
      FBaseLedColorRippleFn := aColor;
  end
  else
    FBaseLedColorRipple := aColor;
end;

function TBaseKeyService.GetLedColorFireball: TColor;
begin
  result := FLedColorFireball;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorFireballFn;
  end;
end;

procedure TBaseKeyService.SetLedColorFireball(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorFireball := aColor
    else
      FLedColorFireballFn := aColor;
  end
  else
    FLedColorFireball := aColor;
end;

function TBaseKeyService.GetBaseLedColorFireball: TColor;
begin
  result := FBaseLedColorFireball;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorFireballFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorFireball(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorFireball := aColor
    else
      FBaseLedColorFireballFn := aColor;
  end
  else
    FBaseLedColorFireball := aColor;
end;

function TBaseKeyService.GetLedColorStarlight: TColor;
begin
  result := FLedColorStarlight;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorStarlightFn;
  end;
end;

procedure TBaseKeyService.SetLedColorStarlight(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorStarlight := aColor
    else
      FLedColorStarlightFn := aColor;
  end
  else
    FLedColorStarlight := aColor;
end;

function TBaseKeyService.GetBaseLedColorStarlight: TColor;
begin
  result := FBaseLedColorStarlight;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorStarlightFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorStarlight(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorStarlight := aColor
    else
      FBaseLedColorStarlightFn := aColor;
  end
  else
    FBaseLedColorStarlight := aColor;
end;

function TBaseKeyService.GetLedColorRebound: TColor;
begin
  result := FLedColorRebound;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorReboundFn;
  end;
end;

procedure TBaseKeyService.SetLedColorRebound(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorRebound := aColor
    else
      FLedColorReboundFn := aColor;
  end
  else
    FLedColorRebound := aColor;
end;

function TBaseKeyService.GetBaseLedColorRebound: TColor;
begin
  result := FBaseLedColorRebound;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorReboundFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorRebound(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorRebound := aColor
    else
      FBaseLedColorReboundFn := aColor;
  end
  else
    FBaseLedColorRebound := aColor;
end;

function TBaseKeyService.GetLedColorLoop: TColor;
begin
  result := FLedColorLoop;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorLoopFn;
  end;
end;

procedure TBaseKeyService.SetLedColorLoop(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorLoop := aColor
    else
      FLedColorLoopFn := aColor;
  end
  else
    FLedColorLoop := aColor;
end;

function TBaseKeyService.GetBaseLedColorLoop: TColor;
begin
  result := FBaseLedColorLoop;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorLoopFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorLoop(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorLoop := aColor
    else
      FBaseLedColorLoopFn := aColor;
  end
  else
    FBaseLedColorLoop := aColor;
end;

function TBaseKeyService.GetLedColorRain: TColor;
begin
  result := FLedColorRain;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FLedColorRainFn;
  end;
end;

procedure TBaseKeyService.SetLedColorRain(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FLedColorRain := aColor
    else
      FLedColorRainFn := aColor;
  end
  else
    FLedColorRain := aColor;
end;

function TBaseKeyService.GetBaseLedColorRain: TColor;
begin
  result := FBaseLedColorRain;
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = BOTLAYER_IDX) then
      result := FBaseLedColorRainFn;
  end;
end;

procedure TBaseKeyService.SetBaseLedColorRain(aColor: TColor);
begin
  if (ActiveLayer <> nil) then
  begin
    if (ActiveLayer.LayerIndex = TOPLAYER_IDX) then
      FBaseLedColorRain := aColor
    else
      FBaseLedColorRainFn := aColor;
  end
  else
    FBaseLedColorRain := aColor;
end;

//Converts text file content to layer/key values
procedure TBaseKeyService.ConvertFromTextFileFmtAdv2(aLayoutContent: TStringList);
var
  aKey, newKey: TKey;
  sKey: string;
  keyState: TKeyState;
  keyStart, keyEnd: integer;
  lastKey: integer;
  previousKey: TKey;
  replacementKey: string;

  i: integer;
  currentLine: string;
  posSep: integer;
  isSingleKey: boolean;
  isMacro: boolean;
  isTapHold: boolean;
  isKeypadLayer: boolean;
  configText: string;
  valueText: string;
  aKBKey: TKBKey;
  layerIdx: integer;
  aCoTriggers: TKeyList;
  activeMacro: TKeyList;
  vkException: integer;
  tapHold: integer;
begin
  lastKey := 0;
  aCoTriggers := TKeyList.Create;

  ResetLayout;

  if (aLayoutContent.Count > 0) then
  begin
    for i := 0 to aLayoutContent.Count - 1 do
    begin
      currentLine := AnsiLowerCase(aLayoutContent.Strings[i]);

      //Reset values
      isKeypadLayer := false;
      aCoTriggers.Clear;
      aKBKey := nil;
      activeMacro := nil;
      ClearModifiers;

      posSep := Pos('>', currentLine);
      isSingleKey := Copy(currentLine, 1, 1) = SK_START;
      isMacro := Copy(currentLine, 1, 1) = MK_START;
      isTapHold := isSingleKey and (Pos('[' + TAP_AND_HOLD, currentLine) > 0);

      //Check if it's a valid line
      if (posSep <> 0) and (isSingleKey or isMacro or isTapHold) then
      begin
        configText := Copy(currentLine, 1, posSep - 1);
        valueText := Copy(currentLine, posSep + 1, Length(currentLine));

        if (isTapHold) then
        begin
          //Load configured key
          keyStart := Pos(SK_START, configText);
          keyEnd := Pos(SK_END, configText);
          sKey := Copy(configText, keyStart + 1, keyEnd - 2);
          isKeypadLayer := (Pos(KEYPAD_KEY, sKey) <> 0) or (KeyPadException(sKey));
          if (isKeypadLayer) then
          begin
            layerIdx := BOTLAYER_IDX;
            if (Pos(KEYPAD_KEY, sKey) <> 0) then
              Delete(sKey, 1, length(KEYPAD_KEY)); //removes kp- text
          end
          else
            layerIdx := TOPLAYER_IDX;
          vkException := GetKeyPadException(sKey);
          if (vkException > 0) then
            aKey := FindKeyConfig(vkException)
          else
            aKey := FindKeyConfig(sKey);

          //Gets key from layer
          if aKey <> nil then
            aKBKey := GetKBKey(aKey.Key, layerIdx);

          if (aKBKey <> nil) then
          begin
            aKBKey.TapAndHold := true;
            //Load values for tap and hold
            for tapHold := 1 to 3 do
            begin
              keyStart := Pos(SK_START, valueText);
              keyEnd := Pos(SK_END, valueText);
              sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
              Delete(valueText, 1, keyEnd); //removes currentkey

              //Sets modified key
              if (tapHold = 1) or (tapHold = 3) then
              begin
                aKey := FindKeyConfig(sKey);
                if aKey <> nil then
                begin
                  if (tapHold = 1) then
                    aKBKey.TapAction := aKey.CopyKey
                  else
                    aKBKey.HoldAction := aKey.CopyKey;
                end;
              end
              else
              begin
                sKey := Copy(sKey, Length(TAP_AND_HOLD) + 1, Length(sKey));
                aKBKey.TimingDelay := ConvertToInt(sKey, DEFAULT_SPEED_TAP_HOLD);
              end;
            end;
          end;
        end
        else if (isSingleKey) then
        begin
          //Load configured key
          keyStart := Pos(SK_START, configText);
          keyEnd := Pos(SK_END, configText);
          sKey := Copy(configText, keyStart + 1, keyEnd - 2);
          isKeypadLayer := (Pos(KEYPAD_KEY, sKey) <> 0) or (KeyPadException(sKey));
          if (isKeypadLayer) then
          begin
            layerIdx := BOTLAYER_IDX;
            if (Pos(KEYPAD_KEY, sKey) <> 0) then
              Delete(sKey, 1, length(KEYPAD_KEY)); //removes kp- text
          end
          else
            layerIdx := TOPLAYER_IDX;
          vkException := GetKeyPadException(sKey);
          if (vkException > 0) then
            aKey := FindKeyConfig(vkException)
          else
            aKey := FindKeyConfig(sKey);

          //Gets key from layer
          if aKey <> nil then
            aKBKey := GetKBKey(aKey.Key, layerIdx);

          if (aKBKey <> nil) then
          begin
            //Load value key
            isKeypadLayer := Pos(KEYPAD_KEY, valueText) <> 0;
            keyStart := Pos(SK_START, valueText);
            keyEnd := Pos(SK_END, valueText);
            sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
            if (isKeypadLayer) then
              Delete(sKey, 1, length(KEYPAD_KEY)); //removes kp- text

            //Sets modified key
            vkException := GetKeyPadException(sKey);
            if (vkException > 0) then
              aKey := FindKeyConfig(vkException)
            else
              aKey := FindKeyConfig(sKey);
            if aKey <> nil then
              SetKBKey(aKBKey, aKey.Key);
          end;
        end
        else if (isMacro) then
        begin
          //Loads key and co-triggers
          while (configText <> '') do
          begin
            aKey := nil;
            keyStart := Pos(MK_START, configText);
            keyEnd := Pos(MK_END, configText);
            sKey := Copy(configText, keyStart + 1, keyEnd - 2);
            isKeypadLayer := (Pos(KEYPAD_KEY, sKey) <> 0) or (KeyPadException(sKey));
            if (isKeypadLayer) then
            begin
              layerIdx := BOTLAYER_IDX;
              if (Pos(KEYPAD_KEY, sKey) <> 0) then
                Delete(sKey, 1, length(KEYPAD_KEY)); //removes kp- text
            end
            else
              layerIdx := TOPLAYER_IDX;
            Delete(configText, 1, keyEnd); //remove currentkey

            //Finds key in config
            vkException := GetKeyPadException(sKey);
            if (vkException > 0) then
              aKey := FindKeyConfig(vkException)
            else
              aKey := FindKeyConfig(sKey);

            if (aKey <> nil) then
            begin
              if (IsModifier(aKey.Key)) and (configText <> '') then
                aCoTriggers.Add(aKey.CopyKey)
              else
                aKBKey := GetKBKey(aKey.Key, layerIdx);
            end;
          end;

          //Loads active Macro (max of 3)
          if (aKBKey <> nil) then
          begin
            if (aKBKey.Macro1.Count = 0) then
              activeMacro := aKBKey.Macro1
            else if (aKBKey.Macro2.Count = 0) then
              activeMacro := aKBKey.Macro2
            else if (aKBKey.Macro3.Count = 0) then
              activeMacro := aKBKey.Macro3;
          end;

          //If kbKey and activeMacro, load values
          if (aKBKey <> nil) and (activeMacro <> nil) then
          begin
            aKBKey.IsMacro := true;

            if (aCoTriggers.Count >= 1) then
              activeMacro.CoTrigger1 := aCoTriggers[0].CopyKey;
            if (aCoTriggers.Count >= 2) then
              activeMacro.CoTrigger2 := aCoTriggers[1].CopyKey;
            if (aCoTriggers.Count >= 3) then
              activeMacro.CoTrigger3 := aCoTriggers[2].CopyKey;

            //Get Macro text
            while (valueText <> '') do
            begin
              aKey := nil;
              keyStart := Pos(MK_START, valueText);
              keyEnd := Pos(MK_END, valueText);
              sKey := Copy(valueText, keyStart + 1, keyEnd - 2);
              if copy(sKey, 1, 1) = '-' then  //Checks for keyup or keydown
                keyState := ksDown
              else if copy(sKey, 1, 1) = '+' then
                keyState := ksUp
              else
                keyState := ksNone;
              if keyState <> ksNone then
                Delete(sKey, 1, 1); //removes - or +
              if (Pos(KEYPAD_KEY, sKey) <> 0) then
                Delete(sKey, 1, length(KEYPAD_KEY)); //removes kp- text
              Delete(valueText, 1, keyEnd); //removes currentkey

              if (activeMacro.Count = 0) and (Copy(sKey, 1, Length(MACRO_SPEED_TEXT)) = MACRO_SPEED_TEXT) then
              begin
                activeMacro.MacroSpeed := ConvertToInt(Copy(sKey, Length(MACRO_SPEED_TEXT) + 1, Length(MACRO_SPEED_TEXT) + 2));
              end
              else
              begin
                //Finds key in config
                vkException := GetKeyPadException(sKey);
                if (vkException > 0) then
                  aKey := FindKeyConfig(vkException)
                else
                  aKey := FindKeyConfig(sKey);

                //Checks for replacement key values (US English)
                if aKey <> nil then
                begin
                  replacementKey := GetReplacementKey(aKey.Key, false);
                  if (replacementKey <> '') then
                    aKey := FindKeyConfig(replacementKey);
                end;
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
                      activeMacro.Add(aKey.CopyKey);
                    RemoveModifier(aKey.Key);
                  end
                  else //if no keyState (+ or -) and modifier add as single key
                    activeMacro.Add(aKey.CopyKey);
                end
                else if (keyState in [ksNone, ksDown]) then //Only add key on key down or key none
                begin
                  //Get the previous key
                  if activeMacro.Count > 0 then
                    previousKey := activeMacro.Items[activeMacro.Count - 1];

                  //If there are modifiers and we find Different Press and Release, we assign it to previous key
                  if (ActiveModifiers.Count > 0) and (aKey.Key = VK_DIF_PRESS_REL) and (previousKey <> nil) then
                  begin
                    previousKey.DiffPressRel := true;
                  end
                  else //Add the key
                  begin
                    newKey := akey.CopyKey;
                    newKey.Modifiers := GetModifierText; //Gets modifier values
                    activeMacro.Add(newKey); //Adds key
                  end;
                end;
                lastKey := aKey.Key;
              end;
            end; //end while loop valueText
          end;
        end;
      end;
    end;
  end;
  ClearModifiers;
end;

function TBaseKeyService.ConvertToTextFileFmtRGB: TStringList;
var
  i, j: integer;
  lIdx, kIdx, mIdx: integer;
  lineText: string;
  saveValue: string;
  layoutContent: TStringList;
  aLayer: TKBLayer;
  aKbKey: TKBKey;
  aKey: TKey;
  aMacro: TKeyList;
  layerPrefix: string;
  prevModifiers: string;
  curKeyModifiers: TKeyList;
  prevKeyModifiers: TKeyList;
begin
  layoutContent := TStringList.Create;

  for lIdx := 0 to FKBLayers.Count - 1 do
  begin
    layerPrefix := '';
    aLayer := FKBLayers[lIdx];
    if (aLayer.LayerIndex = BOTLAYER_IDX) then
      layerPrefix := KEYPAD_KEY_EDGE;

    for kIdx := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      lineText := '';
      aKbKey := aLayer.KBKeyList[kIdx];

      //If key is tap and hold
      if (aKbKey.TapAndHold) and (aKbKey.TapAction <> nil) and (aKbKey.HoldAction <> nil) then
      begin
        lineText := layerPrefix + '[' + aKbKey.OriginalKey.SaveValue + ']>[' + aKbKey.TapAction.SaveValue + ']' +
          '[' + TAP_AND_HOLD + IntToStr(aKbKey.TimingDelay) + ']' + '[' + aKbKey.HoldAction.SaveValue + ']';
        layoutContent.Add(lineText);
      end
      //If key is modified / remapped
      else if (aKbKey.IsModified) then
      begin
        lineText := layerPrefix + '[' + aKbKey.OriginalKey.SaveValue + ']>[' + aKbKey.ModifiedKey.SaveValue + ']';
        layoutContent.Add(lineText);
      end;

      if (aKbKey.IsMacro) then
      begin
        curKeyModifiers := TKeyList.Create;
        prevKeyModifiers := TKeyList.Create;

        //Loop through the 3 macros
        for mIdx := 1 to 3 do
        begin
          lineText := '';

          //Select the correct macro
          if (mIdx = 1) then
            aMacro := aKbKey.Macro1
          else if (mIdx = 2) then
            aMacro := aKbKey.Macro2
          else
            aMacro := aKbKey.Macro3;

          //Skip if macro has no keys
          if (aMacro.Count <= 0) then
            continue;

          //Add layer prefix if there
          lineText := lineText + layerPrefix;

          //Add the co-triggers first
          if (aMacro.CoTrigger1 <> nil) then
            lineText := lineText + '{' + aMacro.CoTrigger1.SaveValue + '}';

          //Add the modified key
          lineText := lineText + '{' + aKbKey.OriginalKey.SaveValue + '}';

          //Add the character separating config and value keys
          lineText := lineText + '>';

          if (aMacro.MacroSpeed >= 1) and (aMacro.MacroSpeed <= MACRO_SPEED_MAX_RGB) then
          begin
            lineText := lineText + '{' + MACRO_SPEED_TEXT_EDGE + IntToStr(aMacro.MacroSpeed) + '}';
          end;

          if (aMacro.MacroRptFreq >= 1) and (aMacro.MacroRptFreq <= MACRO_FREQ_MAX_RGB) then
          begin
            lineText := lineText + '{' + MACRO_REPEAT_EDGE + IntToStr(aMacro.MacroRptFreq) + '}';
          end;

          for i := 0 to aMacro.Count - 1 do
          begin
            prevModifiers := '';
            curKeyModifiers.Clear;
            prevKeyModifiers.Clear;;

            aKey := aMacro[i];

            //Gets the key save value
            saveValue := aKey.SaveValue;

            //Fills list of modifiers
            if not IsModifier(aKey.Key) then
              FillModifiersFromValues(curKeyModifiers, aKey.Modifiers);

            //Loads previous key modifiers
            if (i >= 1) and not(IsModifier(aMacro[i - 1].Key)) then
            begin
              prevModifiers := aMacro[i - 1].Modifiers;
              FillModifiersFromValues(prevKeyModifiers, prevModifiers);
            end;

            //Checks any change in modifiers (add or remove any)
            if (prevModifiers <> aKey.Modifiers) then
            begin
              //Add text + when modifier is released
              for j := 0 to prevKeyModifiers.Count - 1 do
              begin
                if not curKeyModifiers.ContrainsKey(prevKeyModifiers[j]) then
                  lineText := lineText + '{+' + prevKeyModifiers.Items[j].SaveValue + '}';
              end;

              //Add text - when modifier is pressed
              for j := 0 to curKeyModifiers.Count - 1 do
              begin
                if not prevKeyModifiers.ContrainsKey(curKeyModifiers[j]) then
                  lineText := lineText + '{-' + curKeyModifiers.Items[j].SaveValue + '}';
              end;
            end;

            //If different press & release with combination, write using the old method with up and down value
            if (aKey.DiffPressRel) then
            begin
              //Writes the key - and + if WriteDownUp is enabled, else writes only the value
              if aKey.WriteDownUp then
                lineText := lineText + '{-' + saveValue + '}' + DIFF_PRESS_REL_TEXT + '{+' + saveValue + '}'
              else
                lineText := lineText + '{' + saveValue + '}';
            end
            else  //Write the key value, only need the - / + for modifiers
              lineText := lineText + '{' + saveValue + '}';

            //If last key set modifiers +
            if (i = aMacro.Count - 1) then
            begin
              for j := 0 to curKeyModifiers.Count - 1 do
                lineText := lineText + '{+' + curKeyModifiers[j].SaveValue + '}';
            end;
          end;

          //Add line to text file
          layoutContent.Add(lineText);
        end;

        FreeAndNil(curKeyModifiers);
        FreeAndNil(prevKeyModifiers);
      end;
    end;
  end;

  Result := layoutContent;
end;

//Converts keys from program to format for the text file
function TBaseKeyService.ConvertToTextFileFmtAdv2: TStringList;
var
  i, j: integer;
  lIdx, kIdx, mIdx: integer;
  lineText: string;
  saveValue: string;
  layoutContent: TStringList;
  aLayer: TKBLayer;
  aKbKey: TKBKey;
  aKey: TKey;
  aMacro: TKeyList;
  layerPrefix: string;
  prevModifiers: string;
  curKeyModifiers: TKeyList;
  prevKeyModifiers: TKeyList;

  function GetLayerPrefix(saveValue: string): string;
  begin
    if not KeyPadException(saveValue) then
      result := layerPrefix
    else
      result := '';
  end;

begin
  layoutContent := TStringList.Create;

  for lIdx := 0 to FKBLayers.Count - 1 do
  begin
    layerPrefix := '';
    aLayer := FKBLayers[lIdx];
    if (aLayer.LayerIndex = BOTLAYER_IDX) then
      layerPrefix := 'kp-';

    for kIdx := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      lineText := '';
      aKbKey := aLayer.KBKeyList[kIdx];

      //If key is tap and hold
      if (aKbKey.TapAndHold) and (aKbKey.TapAction <> nil) and (aKbKey.HoldAction <> nil) then
      begin
        lineText := '[' + GetLayerPrefix(aKbKey.OriginalKey.SaveValue) + aKbKey.OriginalKey.SaveValue + ']>[' + aKbKey.TapAction.SaveValue + ']' +
          '[' + TAP_AND_HOLD + IntToStr(aKbKey.TimingDelay) + ']' + '[' + aKbKey.HoldAction.SaveValue + ']';
        layoutContent.Add(lineText);
      end
      //If key is modified / remapped
      else if (aKbKey.IsModified) then
      begin
        lineText := '[' + GetLayerPrefix(aKbKey.OriginalKey.SaveValue) + aKbKey.OriginalKey.SaveValue + ']>[' + aKbKey.ModifiedKey.SaveValue + ']';
        layoutContent.Add(lineText);
      end;

      //jm todo Can be modified and have macro??
      //jm todo Do we put kp- for macro values??
      if (aKbKey.IsMacro) then
      begin
        curKeyModifiers := TKeyList.Create;
        prevKeyModifiers := TKeyList.Create;

        //Loop through the 3 macros
        for mIdx := 1 to 3 do
        begin
          lineText := '';

          //Select the correct macro
          if (mIdx = 1) then
            aMacro := aKbKey.Macro1
          else if (mIdx = 2) then
            aMacro := aKbKey.Macro2
          else
            aMacro := aKbKey.Macro3;

          //Skip if macro has no keys
          if (aMacro.Count <= 0) then
            continue;

          //Add the co-triggers first
          if (aMacro.CoTrigger1 <> nil) then
            lineText := '{' + GetLayerPrefix(aMacro.CoTrigger1.SaveValue) + aMacro.CoTrigger1.SaveValue + '}';
          if (aMacro.CoTrigger2 <> nil) then
            lineText := lineText + '{' + GetLayerPrefix(aMacro.CoTrigger2.SaveValue) + aMacro.CoTrigger2.SaveValue + '}';
          if (aMacro.CoTrigger3 <> nil) then
            lineText := lineText + '{' + GetLayerPrefix(aMacro.CoTrigger3.SaveValue) + aMacro.CoTrigger3.SaveValue + '}';

          //Add the modified key
          lineText := lineText + '{' + GetLayerPrefix(aKbKey.OriginalKey.SaveValue) + aKbKey.OriginalKey.SaveValue + '}';

          //Add the character separating config and value keys
          lineText := lineText + '>';

          //jm todo: compare with global macro speed...
          if (aMacro.MacroSpeed >= 1) and (aMacro.MacroSpeed <= MACRO_SPEED_MAX_ADV2) then
          begin
            lineText := lineText + '{' + MACRO_SPEED_TEXT + IntToStr(aMacro.MacroSpeed) + '}';
          end;

          for i := 0 to aMacro.Count - 1 do
          begin
            prevModifiers := '';
            curKeyModifiers.Clear;
            prevKeyModifiers.Clear;;

            aKey := aMacro[i];

            //Gets the key save value
            saveValue := aKey.SaveValue;

            //Fills list of modifiers
            FillModifiersFromValues(curKeyModifiers, aKey.Modifiers);

            //Loads previous key modifiers
            if (i >= 1) then
            begin
              prevModifiers := aMacro[i - 1].Modifiers;
              FillModifiersFromValues(prevKeyModifiers, prevModifiers);
            end;

            //Checks any change in modifiers (add or remove any)
            if (prevModifiers <> aKey.Modifiers) then
            begin
              //Add text + when modifier is released
              for j := 0 to prevKeyModifiers.Count - 1 do
              begin
                if not curKeyModifiers.ContrainsKey(prevKeyModifiers[j]) then
                  lineText := lineText + '{+' + prevKeyModifiers.Items[j].SaveValue + '}';
              end;

              //Add text - when modifier is pressed
              for j := 0 to curKeyModifiers.Count - 1 do
              begin
                if not prevKeyModifiers.ContrainsKey(curKeyModifiers[j]) then
                  lineText := lineText + '{-' + curKeyModifiers.Items[j].SaveValue + '}';
              end;
            end;

            //If different press & release with combination, write using the old method with up and down value
            if (aKey.DiffPressRel) then
            begin
              //Writes the key - and + if WriteDownUp is enabled, else writes only the value
              if aKey.WriteDownUp then
                lineText := lineText + '{-' + saveValue + '}' + DIFF_PRESS_REL_TEXT + '{+' + saveValue + '}'
              else
                lineText := lineText + '{' + saveValue + '}';
            end
            else  //Write the key value, only need the - / + for modifiers
              lineText := lineText + '{' + saveValue + '}';

            //If last key set modifiers +
            if (i = aMacro.Count - 1) then
            begin
              for j := 0 to curKeyModifiers.Count - 1 do
                lineText := lineText + '{+' + curKeyModifiers[j].SaveValue + '}';
            end;
          end;

          //Add line to text file
          layoutContent.Add(lineText);
        end;

        FreeAndNil(curKeyModifiers);
        FreeAndNil(prevKeyModifiers);
      end;
    end;
  end;

  Result := layoutContent;
end;

function TBaseKeyService.IsShiftDown(aKey: TKey): boolean;
begin
  result := (aKey.Modifiers = SHIFT_MOD) or (aKey.Modifiers = L_SHIFT_MOD) or (aKey.Modifiers = R_SHIFT_MOD);
end;

//Checks for replacement key values (non US English drivers)
function TBaseKeyService.GetReplacementKey(aKey: word; saving: boolean): string;
var
  returnKey: word;
  key: TKey;
begin
  result := '';
  {$ifdef Win32}
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

procedure TBaseKeyService.ResetLayout;
var
  i: integer;
begin
  for i := 0 to KBLayers.Count - 1 do
    ResetLayer(KBLayers[i]);
end;

procedure TBaseKeyService.ResetLayer(aLayer: TKBLayer);
var
  i:integer;
  kbKey: TKBKey;
begin
  if (aLayer <> nil) then
  begin
    for i := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      kbKey := aLayer.KBKeyList[i];
      kbKey.ResetKey;
    end;
  end;
end;

function TBaseKeyService.GetLayer(layerIdx: integer): TKBLayer;
var
  i:integer;
begin
  result := nil;

  for i := 0 to FKBLayers.Count - 1 do
  begin
    if (FKBLayers[i].LayerIndex = layerIdx) then
      result := FKBLayers[i];
  end;
end;

procedure TBaseKeyService.SetKBKey(aKBKey: TKBKey; key: word);
var
  aKey: TKey;
begin
  aKey := GetKeyConfig(key);
  if (aKey <> nil) then
  begin
    if (aKBKey.OriginalKey.Key <> aKey.Key) and (aKBKey.CanEdit) then
    begin
      aKBKey.ModifiedKey := aKey;
      aKBKey.IsModified := true;
    end
    else
    begin
      aKBKey.ModifiedKey := nil;
      aKBKey.IsModified := false;
    end;
  end;
end;

procedure TBaseKeyService.SetTapAndHold(aKBKey: TKBKey; tapAction: integer; holdAction: integer;
  delay: integer);
var
  aTapAction: TKey;
  aHoldAction: TKey;
begin
  aTapAction := GetKeyConfig(tapAction);
  aHoldAction := GetKeyConfig(holdAction);
  if (aTapAction <> nil) and (aHoldAction <> nil) then
  begin
    aKBKey.TapAction := aTapAction;
    aKBKey.HoldAction := aHoldAction;
    aKBKey.TimingDelay := delay;
    aKbKey.TapAndHold := true;
  end
  else
  begin
    aKBKey.TapAction := nil;
    aKBKey.HoldAction := nil;
    aKBKey.TimingDelay := 0;
    aKbKey.TapAndHold := false;
  end;
end;

procedure TBaseKeyService.SetKBKeyIdx(aLayer: TKBLayer; index: integer;
  key: word);
var
  aKey: TKey;
  aKbKey: TKBKey;
begin
  aKey := GetKeyConfig(key);
  aKbKey := GetKbKeyByIndex(aLayer, index);
  if (aKey <> nil) and (aKbKey <> nil) and (aLayer <> nil) then
  begin
    if (aKBKey.OriginalKey.Key <> aKey.Key) and (aKBKey.CanEdit) then
    begin
      aKBKey.ModifiedKey := aKey;
      aKBKey.IsModified := true;
    end
    else
    begin
      aKBKey.ModifiedKey := nil;
      aKBKey.IsModified := false;
    end;
  end;
end;

procedure TBaseKeyService.SetKeyMacroIdx(aLayer: TKBLayer; index: integer; aMacro: TKeyList;
  resetMacro: boolean);
var
  aKbKey: TKBKey;
begin
  aKbKey := GetKbKeyByIndex(aLayer, index);
  if (aKBKey <> nil) and (aMacro <> nil) then
  begin
    if (resetMacro) then
      aKBKey.ResetMacro;
    aKBKey.Macro1.Assign(aMacro);
    aKBKey.IsMacro := true;
    aKBKey.ActiveMacro := aKBKey.Macro1;
  end;
end;

function TBaseKeyService.GetKBKey(key: word; layerIdx: integer): TKBKey;
var
  keyIdx: integer;
  aLayer: TKBLayer;
  aKey: TKBKey;
begin
  Result := nil;

  aLayer := GetLayer(layerIdx);

  if (aLayer <> nil) then
    for keyIdx := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      aKey := aLayer.KBKeyList[keyIdx];
      if (aKey.OriginalKey.Key = key) then
      begin
        result := aKey;
        break;
      end;
    end;
end;

function TBaseKeyService.GetKbKeyByIndex(aLayer: TKBLayer; index: integer
  ): TKBKey;
var
  i: integer;
  found: boolean;
  aKbKey: TKBKey;
begin
  i := 0;
  result := nil;
  found := false;
  if (aLayer <> nil) then
  begin
    While (i < aLayer.KBKeyList.Count) and (not found) do
    begin
      aKbKey := aLayer.KBKeyList[i];
      if (aKbKey.Index = index) then
      begin
        result := aKbKey;
        found := true;
      end;
      inc(i);
    end;
  end;
end;

function TBaseKeyService.CopyMacro(aMacro: TKeyList): TKeyList;
begin
  result := nil;
  if (aMacro <> nil) then
  begin
    result := TKeyList.Create;
    result.Assign(aMacro);
  end;
end;

function TBaseKeyService.GetSingleKeyText(aKey: TKey; var isLongKey: boolean
  ): string;
var
  keyText: string;
  keyTextAltGr: string;
begin
  Result := '';
  keyText := GetKeyText(aKey);
  keyTextAltGr := '';
  isLongKey := false;

  //Returns shifted value if shift + key pressed (and shifted value available)
  if (IsShiftDown(aKey)) and (aKey.ShowShiftedValue) then
  begin
    Result := keyText;
  end
  //Returns modifier value (Ctrl, Shfit, Alt, Win) + key value
  else if (aKey.Modifiers <> '') and not (IsModifier(aKey.Key)) then
  begin
    {$ifdef Win32}
    if (IsAltGr(aKey)) then
      keyTextAltGr := GetKeyText(aKey, '', true);
    {$endif}

    //Shows AltGr value if keyboard layout supports it
    if (keyTextAltGr <> '') then
    begin
      Result := keyTextAltGr;
    end
    else
    begin
      Result := '{' + GetModifierValues(aKey) + keyText + '}';
      isLongKey := true;
    end;
  end
  //If has MultiValue and multikey, returns the multivalue
  else if (aKey.MultiValue <> '') then
  begin
    Result := GetKeyText(aKey, aKey.MultiValue);
  end
  //Returns value in square braquets for single key
  else
  begin
    Result := '{' + keyText + '}';

    if not(IsAlphaKey(aKey)) and not(IsNumericKey(aKey)) then
      isLongKey := true;
  end;
end;

//Validate if Macros are ok, not same co-trigger for all macros
function TBaseKeyService.ValidateMacros(aKey: TKbKey; var errorMsg: string;
  var errorMsgTitle: string): boolean;
var
  i:integer;
  coTriggersOk: boolean;

  function CompareKey(key1: word; aKeyList: TKeyList): boolean;
  var
    i: integer;
  begin
    result := false;

    for i := 1 to 3 do
    begin
      case i of
       1 : if (aKeyList.CoTrigger1 <> nil) then result := key1 = aKeyList.CoTrigger1.Key;
       2 : if (aKeyList.CoTrigger2 <> nil) then result := key1 = aKeyList.CoTrigger2.Key;
       3 : if (aKeyList.CoTrigger3 <> nil) then result := key1 = aKeyList.CoTrigger3.Key;
      end;
    end;
  end;

  function CompareTriggers(aKeyList1: TKeyList; aKeyList2: TKeyList): boolean;
  var
    i: integer;
  begin
    result := false;

    if (aKeyList1.Count > 0) and (aKeyList2.Count > 0) then
    begin
      for i := 1 to 3 do
      begin
        case i of
         1 : if (aKeyList1.CoTrigger1 <> nil) then result := CompareKey(aKeyList1.CoTrigger1.Key, aKeyList2);
         2 : if (aKeyList1.CoTrigger2 <> nil) then result := CompareKey(aKeyList1.CoTrigger2.Key, aKeyList2);
         3 : if (aKeyList1.CoTrigger3 <> nil) then result := CompareKey(aKeyList1.CoTrigger3.Key, aKeyList2);
        end;
      end;

      if (not result) then
      begin
        result := (aKeyList1.CoTrigger1 = nil) and (aKeyList1.CoTrigger2 = nil) and (aKeyList1.CoTrigger3 = nil) and
          (aKeyList2.CoTrigger1 = nil) and (aKeyList2.CoTrigger2 = nil) and (aKeyList2.CoTrigger3 = nil);
      end;
    end;
  end;

begin
  errorMsg := '';
  errorMsgTitle := '';
  coTriggersOk := true;
  if (aKey <> nil) then
  begin
    coTriggersOk := (not CompareTriggers(aKey.Macro1, aKey.Macro2)) and
      (not CompareTriggers(aKey.Macro1, aKey.Macro3)) and
      (not CompareTriggers(aKey.Macro2, aKey.Macro3));

    if (not coTriggersOk) then
    begin
      errorMsg := 'You cannot assign two different macros to the same trigger key combination. Choose a co-trigger that is not already in use.';
      errorMsgTitle := 'Duplicate Macro Trigger';
    end;

    //maxMacroOk := (aKey.Macro1.Count <= MAX_MACRO_FS) and
    //  (aKey.Macro2.Count <= MAX_MACRO_FS) and
    //  (aKey.Macro3.Count <= MAX_MACRO_FS);
    //
    //if (not maxMacroOk) then
    //  errorMsg := 'Only ' + IntToStr(MAX_MACRO_FS) + ' macros can be saved to a layout. Delete a macro to proceed.';
  end;

  result := coTriggersOk; // and maxMacroOk;
end;

function TBaseKeyService.CountModifiers(modifiers: string): integer;
begin
  Result := 0;
  if modifiers <> '' then
  begin
    if Pos(SHIFT_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(L_SHIFT_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(R_SHIFT_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(CTRL_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(L_CTRL_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(R_CTRL_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(ALT_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(L_ALT_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(R_ALT_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(WIN_MOD, string(modifiers)) <> 0 then
      inc(result);
    if Pos(L_WIN_MOD, string(modifiers)) <> 0 then
      inc(result);
  end;
end;

function TBaseKeyService.CountKeystrokes(aKeyList: TKeyList): integer;
var
  i:integer;
  aKey: TKey;
  modifiers: integer;
begin
  result := 0;
  if (aKeyList <> nil) then
  begin
    for i := 0 to aKeyList.Count - 1 do
    begin
      aKey := aKeyList[i];
      if (aKey <> nil) then
      begin
        inc(result);
        modifiers := CountModifiers(aKey.Modifiers);
        result := result + (modifiers * 2);
      end;
    end;
  end;
end;

function TBaseKeyService.CountAllKeystrokes: integer;
var
  layerIdx, keyIdx:integer;
  keystrokes: integer;
  aKbKey: TKBKey;
begin
  keystrokes := 0;
  for layerIdx := 0 to FKBLayers.Count - 1 do
  begin
    for keyIdx := 0 to FKBLayers[layerIdx].KBKeyList.Count - 1 do
    begin
      aKbKey := FKBLayers[layerIdx].KBKeyList[keyIdx];
      if (aKbKey.IsMacro) then
      begin
        keystrokes += CountKeystrokes(aKbKey.Macro1);
        keystrokes += CountKeystrokes(aKbKey.Macro2);
        keystrokes += CountKeystrokes(aKbKey.Macro3);
      end;
    end;
  end;
  result := keystrokes;
end;

procedure TBaseKeyService.LoadConfigKeys;
begin
  FConfigKeys := GetConfigKeys;
end;

function TBaseKeyService.GetModifierValues(aKey: TKey): string;
begin
  Result := '';
  if aKey <> nil then
  begin
    if aKey.Modifiers <> '' then
    begin
        if Pos(SHIFT_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_SHIFT).Value + '+';
        if Pos(L_SHIFT_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_LSHIFT).Value + '+';
        if Pos(R_SHIFT_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_RSHIFT).Value + '+';
        if Pos(CTRL_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_CONTROL).Value + '+';
        if Pos(L_CTRL_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_LCONTROL).Value + '+';
        if Pos(R_CTRL_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_RCONTROL).Value + '+';
        if Pos(ALT_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_MENU).Value + '+';
        if Pos(L_ALT_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_LMENU).Value + '+';
        if Pos(R_ALT_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_RMENU).Value + '+';
        if Pos(WIN_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_LWIN).Value + '+';
        if Pos(L_WIN_MOD, string(aKey.Modifiers)) <> 0 then
          Result := Result + FindKeyConfig(VK_LWIN).Value + '+';
    end;
  end;
end;

end.

