unit u_form_mainOld;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lcltype, Menus, ExtCtrls, Buttons, lclintf, ComCtrls, u_const, u_key_service,
  u_key_layer, u_file_service, LabelBox, LineObj, uEKnob, ueled, ECSwitch,
  ECSlider, HSSpeedButton, RichMemo, u_keys, userdialog, contnrs, u_form_about,
  LazUTF8, u_form_saveas, u_form_load
  {$ifdef Win64},Windows{$endif}
  {$ifdef Darwin}, MacOSAll, CarbonDef, CarbonProc{$endif};

type

  { TFormMainOld }

  TFormMainOld = class(TForm)
    bLCtrlMacro: THSSpeedButton;
    bLAltMacro: THSSpeedButton;
    bRAltMacro: THSSpeedButton;
    bRCtrlMacro: THSSpeedButton;
    bRShiftMacro: THSSpeedButton;
    btnHelpIcon: THSSpeedButton;
    btnSpecialActionsRemap: THSSpeedButton;
    btnResetKey: THSSpeedButton;
    btnResetLayer: THSSpeedButton;
    btnResetLayout: THSSpeedButton;
    btnMaximize: THSSpeedButton;
    btnMinimize: THSSpeedButton;
    btnDoneKey: THSSpeedButton;
    btnCancelKey: THSSpeedButton;
    btnBackspace: THSSpeedButton;
    btnClose: THSSpeedButton;
    btnClear: THSSpeedButton;
    btnCopy: THSSpeedButton;
    btnPaste: THSSpeedButton;
    btnDoneMacro: THSSpeedButton;
    btnCancelMacro: THSSpeedButton;
    btnSpecialActionsMacro: THSSpeedButton;
    btnSave: THSSpeedButton;
    btnSaveAs: THSSpeedButton;
    btnNew: THSSpeedButton;
    slMacroSpeed: TECSlider;
    imageKnob: TImage;
    imageList: TImageList;
    imgKinesisFSPro: TImage;
    imgLighting: TImage;
    btnLoad: THSSpeedButton;
    bLShiftMacro: THSSpeedButton;
    imgBackdrop: TImage;
    imgLogoEdge: TImage;
    imgKinesisFsEdge: TImage;
    imgLogoPro: TImage;
    LabelBox10: TLabelBox;
    LabelBox11: TLabelBox;
    LabelBox12: TLabelBox;
    LabelBox13: TLabelBox;
    LabelBox14: TLabelBox;
    LabelBox15: TLabelBox;
    LabelBox16: TLabelBox;
    LabelBox17: TLabelBox;
    LabelBox18: TLabelBox;
    LabelBox19: TLabelBox;
    LabelBox2: TLabelBox;
    LabelBox20: TLabelBox;
    LabelBox21: TLabelBox;
    LabelBox22: TLabelBox;
    LabelBox23: TLabelBox;
    LabelBox24: TLabelBox;
    LabelBox25: TLabelBox;
    LabelBox26: TLabelBox;
    LabelBox27: TLabelBox;
    LabelBox28: TLabelBox;
    LabelBox29: TLabelBox;
    LabelBox3: TLabelBox;
    LabelBox30: TLabelBox;
    LabelBox31: TLabelBox;
    LabelBox32: TLabelBox;
    LabelBox33: TLabelBox;
    LabelBox34: TLabelBox;
    LabelBox35: TLabelBox;
    LabelBox36: TLabelBox;
    LabelBox37: TLabelBox;
    LabelBox38: TLabelBox;
    LabelBox39: TLabelBox;
    LabelBox4: TLabelBox;
    LabelBox40: TLabelBox;
    LabelBox41: TLabelBox;
    LabelBox42: TLabelBox;
    LabelBox43: TLabelBox;
    LabelBox44: TLabelBox;
    LabelBox45: TLabelBox;
    LabelBox46: TLabelBox;
    LabelBox47: TLabelBox;
    LabelBox48: TLabelBox;
    LabelBox49: TLabelBox;
    LabelBox5: TLabelBox;
    LabelBox50: TLabelBox;
    LabelBox51: TLabelBox;
    LabelBox52: TLabelBox;
    LabelBox53: TLabelBox;
    LabelBox54: TLabelBox;
    LabelBox55: TLabelBox;
    LabelBox56: TLabelBox;
    LabelBox57: TLabelBox;
    LabelBox58: TLabelBox;
    LabelBox59: TLabelBox;
    LabelBox6: TLabelBox;
    LabelBox60: TLabelBox;
    LabelBox61: TLabelBox;
    LabelBox62: TLabelBox;
    LabelBox63: TLabelBox;
    LabelBox64: TLabelBox;
    LabelBox65: TLabelBox;
    LabelBox66: TLabelBox;
    LabelBox67: TLabelBox;
    LabelBox68: TLabelBox;
    LabelBox69: TLabelBox;
    LabelBox7: TLabelBox;
    LabelBox70: TLabelBox;
    LabelBox71: TLabelBox;
    LabelBox72: TLabelBox;
    LabelBox73: TLabelBox;
    LabelBox74: TLabelBox;
    LabelBox75: TLabelBox;
    LabelBox76: TLabelBox;
    LabelBox77: TLabelBox;
    LabelBox78: TLabelBox;
    LabelBox79: TLabelBox;
    LabelBox8: TLabelBox;
    LabelBox80: TLabelBox;
    LabelBox81: TLabelBox;
    LabelBox82: TLabelBox;
    LabelBox83: TLabelBox;
    LabelBox84: TLabelBox;
    LabelBox85: TLabelBox;
    LabelBox86: TLabelBox;
    LabelBox88: TLabelBox;
    LabelBox89: TLabelBox;
    LabelBox9: TLabelBox;
    LabelBox90: TLabelBox;
    LabelBox91: TLabelBox;
    LabelBox92: TLabelBox;
    LabelBox93: TLabelBox;
    LabelBox94: TLabelBox;
    LabelBox95: TLabelBox;
    LabelBox96: TLabelBox;
    LabelBox97: TLabelBox;
    lblCreateMacro: TStaticText;
    lblGlobal0: TStaticText;
    lblPSGlobal: TStaticText;
    lblGlobal17: TStaticText;
    lblGlobal18: TStaticText;
    lblPS2: TStaticText;
    lblMMGlobal: TStaticText;
    lblPS6: TStaticText;
    lblPS8: TStaticText;
    lblMM2: TStaticText;
    lblMM6: TStaticText;
    lblMM8: TStaticText;
    lblKnobMax: TStaticText;
    lblPitchBlack: TStaticText;
    lblKnobOff: TStaticText;
    lblBreathe: TStaticText;
    lblGlobal5: TStaticText;
    lblPS4: TStaticText;
    lblMM4: TStaticText;
    lblGlobal9: TStaticText;
    lblLayoutFile: TLabel;
    lblReset: TLabel;
    lblSettings: TLabel;
    lblGlobalMacroSpeed: TLabel;
    lblStatusReport: TLabel;
    lblGameMode: TLabel;
    lblMacro1: TLabel;
    lblMacro2: TLabel;
    lblMacro3: TLabel;
    lblLighting: TLabel;
    lblMenu2: TLabel;
    lblStatus0: TStaticText;
    lblStatus1: TStaticText;
    lblStatus2: TStaticText;
    lblStatus3: TStaticText;
    lblStatus4: TStaticText;
    lblProgramming: TLabel;
    lblFile: TLabel;
    lbl3: TLabel;
    lblRemapKey: TLabel;
    lblLayer: TLabel;
    lblTitle: TLabel;
    ledKnob: TuELED;
    ledPBBorder: TuELED;
    ledBreatheBorder: TuELED;
    MenuItem1: TMenuItem;
    miBtn5MouseM: TMenuItem;
    miBtn4MouseM: TMenuItem;
    miMiddleMouseM: TMenuItem;
    miRightMouseM: TMenuItem;
    miLeftMouseM: TMenuItem;
    miLeftDblClick: TMenuItem;
    miSlowDblClickM: TMenuItem;
    miFastDblClickM: TMenuItem;
    miMouseActionsM: TMenuItem;
    miBtn5Mouse: TMenuItem;
    miBtn4Mouse: TMenuItem;
    miMiddleMouse: TMenuItem;
    miRightMouse: TMenuItem;
    miLeftMouse: TMenuItem;
    miMouseActions: TMenuItem;
    miShutdown: TMenuItem;
    miColemak: TMenuItem;
    miDvorak: TMenuItem;
    MenuItem9: TMenuItem;
    miBackM: TMenuItem;
    miNewTabM: TMenuItem;
    miSwitchTabsM: TMenuItem;
    miForwardM: TMenuItem;
    miHomeM: TMenuItem;
    miF24M: TMenuItem;
    miF23M: TMenuItem;
    miF22M: TMenuItem;
    miF21M: TMenuItem;
    miF20M: TMenuItem;
    miF19M: TMenuItem;
    miF18M: TMenuItem;
    miF17M: TMenuItem;
    miF16M: TMenuItem;
    miF15M: TMenuItem;
    miF14M: TMenuItem;
    miF13M: TMenuItem;
    miNumLock: TMenuItem;
    miNumEnter: TMenuItem;
    miNumMultiply: TMenuItem;
    miNumDivide: TMenuItem;
    miNumMinus: TMenuItem;
    miNumPlus: TMenuItem;
    miNumDec: TMenuItem;
    miNum9: TMenuItem;
    miNum8: TMenuItem;
    miNum7: TMenuItem;
    miNum6: TMenuItem;
    miNum5: TMenuItem;
    miNum4: TMenuItem;
    miNum3: TMenuItem;
    miNum2: TMenuItem;
    MenuItem2: TMenuItem;
    miWebShortcutsM: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    miNum1: TMenuItem;
    miNum0: TMenuItem;
    miFullLeftSide: TMenuItem;
    miFullRightSide: TMenuItem;
    miIntlKey: TMenuItem;
    miNumericKeypad: TMenuItem;
    miFnKey: TMenuItem;
    miMultimedia: TMenuItem;
    miFunctionKeys: TMenuItem;
    miMicMute: TMenuItem;
    miRightWin: TMenuItem;
    miLed: TMenuItem;
    miCalculator: TMenuItem;
    miCopyM: TMenuItem;
    miF13: TMenuItem;
    miF14: TMenuItem;
    miF15: TMenuItem;
    miF16: TMenuItem;
    miF17: TMenuItem;
    miF18: TMenuItem;
    miF19: TMenuItem;
    miF20: TMenuItem;
    miF21: TMenuItem;
    miF22: TMenuItem;
    miF23: TMenuItem;
    miF24: TMenuItem;
    miPasteM: TMenuItem;
    miFnToggle: TMenuItem;
    miFnShift: TMenuItem;
    miLongDelayM: TMenuItem;
    miMenu: TMenuItem;
    miCutM: TMenuItem;
    miMute: TMenuItem;
    miLastAppM: TMenuItem;
    miNextTrack: TMenuItem;
    miRedoM: TMenuItem;
    miNull: TMenuItem;
    miPlayPause: TMenuItem;
    miUndoM: TMenuItem;
    miPreviousTrack: TMenuItem;
    miDesktopM: TMenuItem;
    miShortDelayM: TMenuItem;
    miSelectAllM: TMenuItem;
    miVolumeDown: TMenuItem;
    miCtrlAltDelM: TMenuItem;
    miVolumeUp: TMenuItem;
    miWinCombM: TMenuItem;
    OpenDialog: TOpenDialog;
    pmTokensKeys: TPopupMenu;
    pmTokensMacros: TPopupMenu;
    SaveDialog: TSaveDialog;
    shpMenu: TShape;
    memoMacro: TRichMemo;
    pnlMacro: TPanel;
    rgMacro1: TRadioButton;
    rgMacro2: TRadioButton;
    rgMacro3: TRadioButton;
    shpLine: TLineObj;
    pnlMain: TPanel;
    pnlBotOptions: TPanel;
    pnlKeysLeft: TPanel;
    pnlBody: TPanel;
    pnlBot: TPanel;
    pnlKb: TPanel;
    pnlKeys: TPanel;
    pnlLayers: TPanel;
    pnlMenu: TPanel;
    pnlTitle: TPanel;
    pnlTopBody: TPanel;
    shpKeys: TShape;
    shpLighting: TShape;
    shpSettings: TShape;
    slPlaybackSpeed: TECSlider;
    slMacroMultiplay: TECSlider;
    slStatusReport: TECSlider;
    lblPlaybackSpeed: TStaticText;
    lblMacroMultiplay: TStaticText;
    StaticText3: TStaticText;
    lblDisplaying: TStaticText;
    swGameMode: TECSwitch;
    tbMacroSpeed: TTrackBar;
    tbMultiplay: TTrackBar;
    tbSpeed: TTrackBar;
    tbStatusReport: TTrackBar;
    textMacroInput: TStaticText;
    swLayerSwitch: TECSwitch;
    knobBright: TuEKnob;
    ledPB: TuELED;
    ledBreathe: TuELED;
    procedure bBrightnessClick(Sender: TObject);
    procedure bCoTriggerClick(Sender: TObject);
    procedure btnHelpIconClick(Sender: TObject);
    procedure btnResetKeyClick(Sender: TObject);
    procedure btnResetLayerClick(Sender: TObject);
    procedure btnResetLayoutClick(Sender: TObject);
    procedure btnSpecialActionsRemapClick(Sender: TObject);
    procedure btnActivateMacroClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnSpecialActionsMacroClick(Sender: TObject);
    procedure btnBackspaceClick(Sender: TObject);
    procedure btnCancelKeyClick(Sender: TObject);
    procedure btnCancelMacroClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDoneKeyClick(Sender: TObject);
    procedure btnDoneMacroClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure eMacroFreqChange(Sender: TObject);
    procedure eMacroFreqEnter(Sender: TObject);
    procedure eMacroFreqKeyPress(Sender: TObject; var Key: char);
    procedure eMacroFreqMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure eSpeedChange(Sender: TObject);
    procedure eSpeedEnter(Sender: TObject);
    procedure eSpeedKeyPress(Sender: TObject; var Key: char);
    procedure eSpeedMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure imgBackdropClick(Sender: TObject);
    procedure KeyButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure knobBrightClick(Sender: TObject);
    procedure knobBrightMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ledBreatheClick(Sender: TObject);
    procedure memoMacroMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmTokensKeysPopup(Sender: TObject);
    procedure pmTokensMacrosPopup(Sender: TObject);
    procedure pnlTitleClick(Sender: TObject);
    procedure pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlTitleMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure rgMacroClick(Sender: TObject);
    procedure slMacroMultiplayChange(Sender: TObject);
    procedure slMacroSpeedChange(Sender: TObject);
    procedure slPlaybackSpeedChange(Sender: TObject);
    procedure slStatusReportChange(Sender: TObject);
    procedure tbMultiplayChange(Sender: TObject);
    procedure tbSpeedChange(Sender: TObject);
    procedure textMacroInputClick(Sender: TObject);
    procedure swGameModeChange(Sender: TObject);
    procedure swLayerSwitchClick(Sender: TObject);
    procedure tbMacroSpeedChange(Sender: TObject);
    procedure tbStatusReportChange(Sender: TObject);
    procedure miTokenMacroClick(Sender: TObject);
    procedure miTokenKeyClick(Sender: TObject);
    procedure ledPBClick(Sender: TObject);
    procedure watchTutorialClick(Sender: TObject);
    procedure readManualClick(Sender: TObject);
    procedure openTroubleshootingTipsClick(Sender: TObject);
    procedure createCustomButton(var customBtns: TCustomButtons; btnCaption: string; btnWidth: integer; btnOnClick: TNotifyEvent; btnKind: TBitBtnKind = bkCustom);
    procedure setDvorakBothLayers(Sender: TObject);
    procedure setDvorakTopLayer(Sender: TObject);
    procedure setDvorakFnLayer(Sender: TObject);
    procedure setColemakBothLayers(Sender: TObject);
    procedure setColemakTopLayer(Sender: TObject);
    procedure setColemakFnLayer(Sender: TObject);
    procedure continueClick(Sender: TObject);
  private
    { private declarations }
    activeKeyBtn: TLabelBox;
    activeKbKey: TKBKey;
    activeLayer: TKBLayer;
    MacroMode: boolean;
    MacroModified: boolean;
    KeyModified: boolean;
    SaveState: TSaveState;
    keyBtnList: TObjectList;
    currentLayoutFile: string;
    resetLayer: boolean;
    loadingSettings: boolean;
    defaultKeyFontName: string;
    defaultKeyFontSize: integer;
    freqKeyDown: boolean;
    speedKeyDown: boolean;
    copiedMacro: TKeyList;
    infoMessageShown: boolean;
    loadingMacro: boolean;
    blueColor: TColor;
    fontColor: TColor;
    backColor: TColor;
    settingLedMode: boolean;
    remapCount: integer;
    macroCount: integer;

    procedure SetConfigOS;
    procedure SetKeyboardHook;
    procedure RemoveKeyboardHook;
    procedure KeyButtonClick(Sender: TObject);
    procedure InitKeyButtons(container: TWinControl);
    procedure SetActiveKeyButton(keyButton: TLabelBox);
    procedure SetKeyButtonText(keybutton: TLabelBox; btnText: string);
    procedure SetSaveState(Value: TSaveState);
    procedure SetEditMode(value: boolean);
    function LoadStateSettings: boolean;
    function LoadVersionInfo: boolean;
    function LoadKeyboardLayout(layoutFile: string): boolean;
    function CheckToSave: boolean;
    function Save(isNew: boolean = false; showSaveDialog: boolean = true): boolean;
    procedure SaveAs(isNew: boolean = false);
    procedure LoadLayer(layer: TKBLayer);
    procedure UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox; unselectKey: boolean = false);
    function GetKeyButtonByIndex(index: integer): TLabelBox;
    procedure SetModifiedKey(key: word; Modifiers: string; isMacro: boolean; bothLayers: boolean = false);
    procedure SetActiveLayer(layerIdx: integer);
    procedure SetOtherPanelClick(container: TWinControl);
    procedure OtherPanelClick(Sender: TObject);
    procedure RefreshRemapInfo;
    procedure SetMacroMode(value: boolean; reset: boolean = true);
    procedure SetMacroText(pushCursorToEnd: boolean; cursorPos: integer = -1);
    //procedure AddKeyToMacro(key: word; Modifiers: string);
    procedure LoadMacro;
    procedure SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
    procedure ResetMacroCoTriggers;
    Procedure ResetCoTrigger(coTriggerBtn: THSSpeedButton);
    Procedure ActivateCoTrigger(coTriggerBtn: THSSpeedButton);
    procedure SetCoTrigger(aKey: TKey);
    function IsKeyLoaded: boolean;
    function GetCoTriggerKey(Sender: TObject): TKey;
    procedure RemoveCoTrigger(key: word);
    function CheckSaveKey(canSave: boolean): boolean;
    procedure SaveStateSettings;
    function GetKeyOtherLayer(keyIdx: integer): TKBKey;
    procedure OnRestore(Sender: TObject);
    function GetCursorNextKey(cursorPos: integer): integer;
    function GetCursorPrevKey(cursorPos: integer): integer;
    procedure SetFnNumericKpLeft;
    procedure SetFnNumericKpRight;
    procedure SetDvorakKb(layerIdx: integer; bothLayers: boolean);
    procedure SetColemakKb(layerIdx: integer; bothLayers: boolean);
    procedure SetLedMode(ledMode: string);
    function ValidateBeforeDone: boolean;
    procedure AppDeactivate(Sender: TObject);
    procedure EnableMacroBox(value: boolean);
  public
    { public declarations }
  end;


var
  FormMainOld: TFormMainOld;
  keyService: TKeyService;
  fileService: TFileService;
  NeedInput: boolean;
  lastKeyDown: word;
  KBHook: HHook;
  lastKeyPressed: word;
  MPos:TPoint; {Position of the Form before drag}

  procedure SetKeyPress(Key: word; Modifiers: string);
  {$ifdef Win64}
  function KeyboardHookProc(Code: longint; wParam: int64; lParam: int64): int64; stdcall;  {this intercepts keyboard input}
  {$endif}

implementation

{$R *.lfm}

{ TFormMainOld }

{$ifdef Win64}
//Keyboard hook to trap key presses and process them
function KeyboardHookProc(Code: longint; wParam: int64; lParam: int64): int64; stdcall;
var
  Transition: TTransitionState;
  extended: TExtendedState;
  //KeystrokeDataPtr: PKeystrokeData;
  currentKey: longint;
  scanCode: longint;
begin
  //If we need keyboard input (ex: file prompt) allow key presses
  if NeedInput then
  begin
    Result := CallNextHookEx(WH_KEYBOARD, Code, wParam, lParam);
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMainOld.Active) then
    exit;

  currentKey := wParam;

  //Checks if key is up or down
  Transition := TTransitionState((lParam shr 31) and 1);

  //Checks if key is normal or extended
  extended := TExtendedState((lParam shr 24) and 1);

  //Gets ScanCode
  scancode := (lParam and $00ff0000) >> 16;

  //Detects if numpadenter is pressed, changes key for user-defined numpad enter
  if (extended = esExtended) and (currentKey = VK_RETURN) then
    currentKey := VK_NUMPADENTER;

  //Distinguish between left and right Ctrl
  if (currentKey = VK_CONTROL) then
  begin
    if (extended = esExtended) then
      currentKey := VK_RCONTROL
    else
      currentKey := VK_LCONTROL;
  end;

  //Distinguish between left and right Alt
  if (currentKey = VK_MENU) then
  begin
    if (extended = esExtended) then
      currentKey := VK_RMENU
    else
      currentKey := VK_LMENU;
  end;

  //Distinguish between left and right Shift
  if (currentKey = VK_SHIFT) then
  begin
    currentKey := MapVirtualKey(scancode, MAPVK_VSC_TO_VK_EX);
  end;

  if (Code = HC_ACTION) then
  begin
    if (Transition = tsPressed) then //On key down
    begin
      //If not a modifier
      if not (IsModifier(currentKey)) then
      begin
        //If key is different then last pressed key (hasn't been released yet)
        if currentKey <> lastKeyPressed then
          SetKeyPress(currentKey, keyService.GetModifierText);

        //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
        Result := 1;

        //Sets last key pressed
        lastKeyPressed := currentKey;
      end
      else
      begin
        //Adds modifier to list of active modifiers
        keyService.AddModifier(currentKey);
      end;
    end
    else if (Transition = tsReleased) then //On key up
    begin
      //When last key pressed is released we reset it
      if currentKey = lastKeyPressed then
        lastKeyPressed := 0;

      //If it's a  modifier and it's the last key pressed or print screen (only works on key up)
      if ((currentKey = lastKeyDown) and IsModifier(currentKey)) or
        (currentKey in [VK_PRINT, VK_SNAPSHOT]) then
      begin
        SetKeyPress(currentKey, keyService.GetModifierText);

        //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
        Result := 1;
      end;

      if IsModifier(currentKey) then
      begin
        //Removes modifier from list of active modifiers
        keyService.RemoveModifier(currentKey);
      end;
    end;
  end;
  lastKeyDown := currentKey;
end;
{$endif}

//Only used for Mac version to trap key presses
procedure TFormMainOld.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{$ifdef Darwin}var currentKey: longint;{$endif}
begin
  {$ifdef Darwin}
  //If we need keyboard input (ex: file prompt) allow key presses
  if NeedInput then
  begin
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMainOld.Active) then
    exit;

  currentKey := key;

  //If not a modifier
  if not (IsModifier(currentKey)) then
  begin
    //If key is different then last pressed key (hasn't been released yet)
    if currentKey <> lastKeyPressed then
      SetKeyPress(currentKey, keyService.GetModifierText);

    //Sets last key pressed
    lastKeyPressed := currentKey;

    //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
    Key := 0;
  end
  else
  begin
    //Adds modifier to list of active modifiers
    keyService.AddModifier(currentKey);
  end;

  lastKeyDown := currentKey;
  {$endif}
end;

//Only used for Mac OS to trap key presses
procedure TFormMainOld.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
{$ifdef Darwin}var currentKey: longint;{$endif}
begin
  {$ifdef Darwin}
  currentKey := key;

  //When last key pressed is released we reset it
  if currentKey = lastKeyPressed then
     lastKeyPressed := 0;

  if ((currentKey = lastKeyDown) and IsModifier(currentKey)) then //or
    //(currentKey in [VK_PRINT, VK_SNAPSHOT]) then
  begin
    SetKeyPress(currentKey, keyService.GetModifierText);

    //To prevent application from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
    Key := 0;
  end;

  if IsModifier(currentKey) then
  begin
    //Removes modifier from list of active modifiers
    keyService.RemoveModifier(currentKey);
  end;
  {$endif}
end;

//Adds key to list of keys and writes back to edit field
procedure SetKeyPress(Key: word; Modifiers: string);
begin
  //jm remove? if FormMainOld.EditMode then
  begin
    FormMainOld.SetModifiedKey(Key, Modifiers, FormMainOld.memoMacro.Focused);
  end;
end;

procedure TFormMainOld.FormCreate(Sender: TObject);
var
  customBtns: TCustomButtons;
  canShowApp: boolean;
begin
  //Sets Height and Width of form according to screen resolution
  self.Width := 1100;
  if screen.Width < self.Width then
    self.Width := screen.Width - 20;

  self.Height := 720;
  if screen.Height < self.Height then
    self.Height := screen.Height - 20;

  lblLayoutFile.Caption := '';
  infoMessageShown := false;
  loadingSettings := false;
  loadingMacro := false;
  freqKeyDown := false;
  speedKeyDown := false;
  resetLayer := false;
  settingLedMode := false;
  keyBtnList := TObjectList.Create;
  activeKeyBtn := nil;
  activeKbKey := nil;
  activeLayer := nil;
  SetConfigOS;
  keyService := TKeyService.Create;
  fileService := TFileService.Create;
  SetSaveState(ssNone);
  SetEditMode(false);
  NeedInput := False;
  InitKeyButtons(pnlKb);
  SetOtherPanelClick(self);
  Application.OnRestore := @OnRestore;
  Application.OnDeactivate:=@AppDeactivate;

  SetKeyboardHook;
  SetMacroMode(false);

  canShowApp := LoadVersionInfo;
  if (canShowApp) then
  begin
    //Load config keys depending on app version
    keyService.LoadConfigKeys;

    {$ifdef Win64}self.BorderStyle := bsNone;{$endif}
    {$ifdef Darwin}
    self.BorderStyle := bsSizeable;
    btnClose.Visible := false;
    btnMinimize.Visible := false;
    btnMaximize.Visible := false;
    {$endif}

    //Set UI elements according to keyboard version
    if (GApplication = APPL_FSPRO) then
    begin
      blueColor := KINESIS_BLUE;
      fontColor := clDefault;
      backColor := clWhite;
      SetFontColor(self, fontColor);
      self.Color := backColor;
      pnlMain.Color := backColor;
      pnlKeys.Color := backColor;
      pnlMenu.Color := backColor;
      shpKeys.Brush.Color := backColor;
      shpMenu.Brush.Color := backColor;
      shpSettings.Brush.Color := backColor;
      lblTitle.Font.Color := blueColor;
      lblFile.Font.Color := blueColor;
      lblSettings.Font.Color := blueColor;
      lblProgramming.Font.Color := blueColor;
      shpKeys.Color := blueColor;
      shpLine.Color := blueColor;
      shpMenu.Color := blueColor;
      shpSettings.Color := blueColor;
      imgLogoEdge.Visible := false;
      imgLogoPro.Visible := true;
      imgKinesisFSPro.Visible := true;
      imgKinesisFSEdge.Visible := false;
      {$ifdef Darwin}
      btnHelpIcon.Color := clWhite;
      btnHelpIcon.HotTrackColor := clWhite;
      btnHelpIcon.ShadowColor := clWhite;
      memoMacro.Color := clBtnFace;
      {$endif}

      //Menu buttons
      btnHelpIcon.TransparentColor := clNone;
      btnMinimize.TransparentColor := clNone;
      btnMaximize.TransparentColor := clNone;
      btnClose.TransparentColor := clNone;
      imageList.GetBitmap(3, btnHelpIcon.Glyph);
      imageList.GetBitmap(2, btnMinimize.Glyph);
      imageList.GetBitmap(4, btnMaximize.Glyph);
      imageList.GetBitmap(6, btnClose.Glyph);

      //Hide Lighting section
      shpLighting.Visible := false;
      lblLighting.Visible := false;
      imgLighting.Visible := false;
      knobBright.Visible := false;
      lblKnobOff.Visible := false;
      lblKnobMax.Visible := false;
      ledKnob.Visible := false;
      ledPB.Visible := false;
      ledBreathe.Visible := false;
      ledPBBorder.Visible := false;
      ledBreatheBorder.Visible := false;
      lblPitchBlack.Visible := false;
      lblBreathe.Visible := false;

      //Hide game mode
      shpSettings.Height := 140;
      lblGameMode.Visible := false;
      swGameMode.Visible := false;

      miLed.Visible := false;

      //Layer switch
      swLayerSwitch.Font.Color := clWhite;
      //swLayerSwitch.GrooveCheckedClr := blueColor;
      //swLayerSwitch.GrooveUncheckedClr := blueColor;
    end
    else //FS EDGE
    begin
      blueColor := KINESIS_BLUE_EDGE;
      fontColor := clWhite;
      backColor := KINESIS_DARK_GRAY_FS;
      lblTitle.Font.Color := blueColor;
      shpKeys.Color := blueColor;
      shpLine.Color := blueColor;
      shpMenu.Color := blueColor;
      shpSettings.Color := blueColor;
      lblFile.Font.Color := blueColor;
      imgLogoEdge.Visible := true;
      imgLogoPro.Visible := false;
      imgKinesisFSPro.Visible := false;
      imgKinesisFSEdge.Visible := true;

      {$ifdef Darwin}
      btnHelpIcon.TransparentColor := KINESIS_DARK_GRAY_FS;
      btnMinimize.TransparentColor := KINESIS_DARK_GRAY_FS;
      btnMaximize.TransparentColor := KINESIS_DARK_GRAY_FS;
      btnClose.TransparentColor := KINESIS_DARK_GRAY_FS;
      {$endif}
    end;

    knobBright.Image := imageKnob.Picture.Bitmap;
    //Tries to load Pedals.txt file
    //LoadLayoutFile(GPedalsFile);

    RefreshRemapInfo;

    //Sets default directory as the active folder
    //if DirectoryExists(GPedalsFilePath) then
    //begin
    //  pedalOpenDialog.InitialDir := GPedalsFilePath;
    //  pedalSaveDialog.InitialDir := GPedalsFilePath;
    //end;

    //SetActiveLayer(TOPLAYER_IDX);
    swLayerSwitch.Checked := true;

    if (LoadStateSettings) then
    begin
      fileService.LoadAppSettings(GAppSettingsFile);
      LoadKeyboardLayout(currentLayoutFile);
    end
    else
      canShowApp := false;
  end;

  if not canShowApp then
  begin
    createCustomButton(customBtns, 'Troubleshooting Tips', 175, @openTroubleshootingTipsClick);
    ShowDialog('SmartSet App File Error', 'The SmartSet App cannot find the necessary layout and settings files on the v-drive. Replug the keyboard to regenerate these files and try launching the App again.',
      mtFSEdge, [], DEFAULT_DIAG_HEIGHT, KINESIS_DARK_GRAY_FS, clWhite, customBtns);
    Application.Terminate;
  end;
end;

procedure TFormMainOld.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if not CheckToSave then
    CloseAction := caNone
  else
  begin
    FreeAndNil(keyService);
    FreeAndNil(fileService);
    if CloseAction = caFree then
      self := nil;
  end;
end;

procedure TFormMainOld.FormDestroy(Sender: TObject);
begin
  RemoveKeyboardHook;
end;

procedure TFormMainOld.FormPaint(Sender: TObject);
var
  Rect     : TRect;
begin
  if (GApplication = APPL_FSPRO) then
  begin
    // get the form rectangle
    Rect.Left   := 0;
    Rect.Top    := 0;
    Rect.Bottom := ClientHeight;
    Rect.Right  := ClientWidth;
    // draw the whole area
    with Canvas do
      begin
        // form color
        Brush.Color := clBlack;
        // set border color
        Pen.Color := clBlack;
        Rectangle(0, 0, ClientWidth, ClientHeight);
      end;
  end;
end;

procedure TFormMainOld.FormActivate(Sender: TObject);
var
  customBtns: TCustomButtons;
  hideNotif: integer;
begin
  if (not infoMessageShown) and (not fileService.AppSettings.AppIntroMsg) then
  begin
    createCustomButton(customBtns, 'Continue', 120, @continueClick);
    createCustomButton(customBtns, 'Watch Tutorial', 120, @watchTutorialClick);
    createCustomButton(customBtns, 'Read Manual', 120, @readManualClick);

    hideNotif := ShowDialog('Introduction', 'To program, first select a key by clicking on the keyboard image' + #10 +
      '- Remap: Tap the desired key action on the keyboard or use the Special Actions button' + #10 +
      '- Macro: Click the macro box and then type your macro on the keyboard',
      mtInformation, [], 200, backColor, fontColor, customBtns, 'Hide this notification?');
    if (hideNotif >= DISABLE_NOTIF) then
    begin
      fileService.SetAppIntroMsg(true);
      fileService.SaveAppSettings;
    end;
  end;
  infoMessageShown := true;
end;

procedure TFormMainOld.pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MPos.X := X;
  MPos.Y := Y;
end;

procedure TFormMainOld.pnlTitleMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    self.Left := self.Left - (MPos.X-X);
    self.Top := self.Top - (MPos.Y-Y);
  end;
end;

procedure TFormMainOld.SetConfigOS;
const
  SliderSeparator = 25;
begin
  //Windows
  {$ifdef Win64}
  defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 8;
  SetFont(self, 'Tahoma Bold');
  slMacroSpeed.Visible := false;
  slStatusReport.Visible := false;
  slMacroMultiplay.Visible := false;
  slPlaybackSpeed.Visible := false;
  {$endif}

  //MacOS
  {$ifdef Darwin}
  self.AutoScroll := false; //No scroll bars OSX, does not work well
  self.KeyPreview := true; //traps key presses at form level
  defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 12;
  SetFont(self, 'Helvetica');
  lblMacro1.Left := rgMacro1.Left - lblMacro1.Width - 5;
  lblMacro2.Left := rgMacro2.Left - lblMacro2.Width - 5;
  lblMacro3.Left := rgMacro3.Left - lblMacro3.Width - 5;
  rgMacro1.Top := 1;
  rgMacro2.Top := 1;
  rgMacro3.Top := 1;
  lblDisplaying.Left := lblMacro1.Left - lblDisplaying.Width - 5;
  lblLayer.Top := lblLayer.Top + 2;
  btnHelpIcon.Left := btnClose.Left;
  btnBackspace.Caption := 'Delete';
  bLCtrlMacro.Caption := 'Left Control';
  bRCtrlMacro.Caption := 'Right Control';
  bLAltMacro.Caption := 'Left Option';
  bRAltMacro.Caption := 'Right Option';

  //Hide special actions for Mac
  miLastAppM.Visible := false;
  miDesktopM.Visible := false;
  miCtrlAltDelM.Visible := false;
  miWebShortcutsM.Visible := false;
  miWinCombM.Visible := false;
  miRightWin.Visible := false;
  miMenu.Visible := false;
  miIntlKey.Visible := false;
  miCalculator.Visible := false;
  tbMacroSpeed.Visible := false;
  tbStatusReport.Visible := false;
  tbMultiplay.Visible := false;
  tbSpeed.Visible := false;

  //Slider settings
  lblPS2.Left := lblPSGlobal.Left + SliderSeparator;
  lblPS4.Left := lblPS2.Left + SliderSeparator;
  lblPS6.Left := lblPS4.Left + SliderSeparator + 2;
  lblPS8.Left := lblPS6.Left + SliderSeparator;
  lblMM2.Left := lblMMGlobal.Left + SliderSeparator;
  lblMM4.Left := lblMM2.Left + SliderSeparator;
  lblMM6.Left := lblMM4.Left + SliderSeparator + 2;
  lblMM8.Left := lblMM6.Left + SliderSeparator;
  lblMacroMultiplay.Top := lblMacroMultiplay.Top - 2;
  slMacroMultiplay.Top := slMacroMultiplay.Top - 2;
  lblPlaybackSpeed.Top := lblPlaybackSpeed.Top - 2;
  slPlaybackSpeed.Top := slPlaybackSpeed.Top - 2;

  lblGlobalMacroSpeed.Top := lblGlobalMacroSpeed.Top - 2;
  slMacroSpeed.Top := slMacroSpeed.Top - 2;
  lblStatusReport.Top := lblStatusReport.Top - 2;
  slStatusReport.Top := slStatusReport.Top - 2;

  //btnClose.Left := 10;
  //btnMinimize.Left := btnClose.Left + btnClose.Width;
  //btnMaximize.Left := btnMinimize.Left + btnMinimize.Width;
  //btnHelpIcon.Left := btnMaximize.Left + btnMaximize.Width;
  {$endif}
end;

{Set the keyboard hook so we  can intercept keyboard input}
procedure TFormMainOld.SetKeyboardHook;
{$ifdef Darwin}var eventType: EventTypeSpec;{$endif}
begin
  //Windows
  {$ifdef Win64}
  KBHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, HInstance,
    GetCurrentThreadId());
  {$endif}
end;

{unhook the keyboard interception}
procedure TFormMainOld.RemoveKeyboardHook;
begin
  //Windows
  {$ifdef Win64}
  UnHookWindowsHookEx(KBHook);
  {$endif}
end;

procedure TFormMainOld.SetOtherPanelClick(container: TWinControl);
//var
  //i: integer;
begin
  //for i := 0 to container.ControlCount - 1 do
  //begin
  //  if (container.Controls[i] is TPanel) and not(container.Controls[i] is TPanelBtn) then
  //  begin
  //    (container.Controls[i] as TPanel).OnClick := @OtherPanelClick;
  //    SetOtherPanelClick(container.Controls[i] as TPanel);
  //  end;
  //end;
  pnlKb.OnClick := @OtherPanelClick;
end;

procedure TFormMainOld.btnResetKeyClick(Sender: TObject);
var
  response: integer;
begin
  if IsKeyLoaded then
  begin
    if (not fileService.AppSettings.ResetKeyMsg) then
    begin
      response := ShowDialog('Reset current key',
        'Do you want to reset the current Key?' + #10 + 'The remapped key action and any stored macros will be lost.',
        mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, backColor, fontColor, nil, 'Hide this notification?');
      if (response >= DISABLE_NOTIF) then
      begin
        fileService.SetResetKeyMsg(true);
        fileService.SaveAppSettings;
      end;
    end
    else
      response := mrYes;

    if (response = mrYes) or (response = mrYes + DISABLE_NOTIF) then
    begin
      activeKbKey.ResetKey;
      UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
      SetSaveState(ssModifed);
    end;
  end;

  RefreshRemapInfo;
end;

procedure TFormMainOld.btnResetLayerClick(Sender: TObject);
begin
  if ShowDialog('Reset layer',
      'Do you want to reset the current Layer?' + #10 + 'All remapped keys and stored macros will be lost.',
      mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, backColor, fontColor) = mrYes then
  begin
    keyService.ResetLayer(activeLayer);
    LoadLayer(activeLayer);
    SetActiveKeyButton(nil);
    RefreshRemapInfo;
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.btnResetLayoutClick(Sender: TObject);
begin
  if ShowDialog('Reset layout',
        'Do you want to reset the current Layout?' + #10 + 'All remapped keys and stored macros in both layers will be lost.',
        mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, backColor, fontColor) = mrYes then
  begin
    keyService.ResetLayout;
    LoadLayer(activeLayer);
    SetActiveKeyButton(nil);
    RefreshRemapInfo;
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.btnSpecialActionsRemapClick(Sender: TObject);
var
  lPoint: TPoint;
begin
  //if IsKeyLoaded then
  //begin
    //Popup menu over special button
    lPoint.x := 0;
    lPoint.y := 0;
    lPoint := btnSpecialActionsRemap.ClientToScreen(lPoint);
    pmTokensKeys.Popup(lPoint.x, lPoint.y);
  //end;
end;

procedure TFormMainOld.btnActivateMacroClick(Sender: TObject);
begin
  //if IsKeyLoaded then
  //begin
  //  SetMacroMode(true);
  //  UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
  //  RefreshRemapInfo;
  //end;
end;

procedure TFormMainOld.btnCloseClick(Sender: TObject);
begin
  if CheckSaveKey(true) then
    Close;
end;

procedure TFormMainOld.btnCopyClick(Sender: TObject);
var
  hideNotif: integer;
begin
  if (IsKeyLoaded) then
  begin
    if (activeKbKey.ActiveMacro <> nil) then
    begin
      copiedMacro := keyService.CopyMacro(activeKbKey.ActiveMacro);
      if (not fileService.AppSettings.CopyMacroMsg) then
      begin
        hideNotif := ShowDialog('Copy', 'Macro copied. Now select a new trigger key or load a new layout, then hit Paste.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetCopyMacroMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
    end
    else
      ShowDialog('Copy Macro', 'You must have an active maro to copy', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT,
        backColor, fontColor);
  end;
end;

procedure TFormMainOld.btnMaximizeClick(Sender: TObject);
begin
  if (Self.WindowState = wsMaximized) then
  begin
    Self.WindowState := wsNormal;
    if (GApplication = APPL_FSPRO) then
      imageList.GetBitmap(4, btnMaximize.Glyph)
    else
      imageList.GetBitmap(0, btnMaximize.Glyph);
    btnMaximize.Hint := 'Maximize';
  end
  else
  begin
    Self.WindowState := wsMaximized;
    if (GApplication = APPL_FSPRO) then
      imageList.GetBitmap(5, btnMaximize.Glyph)
    else
      imageList.GetBitmap(1, btnMaximize.Glyph);
    btnMaximize.Hint := 'Restore window';
  end;
end;

//When minimize make border sizeable so we can restore it
procedure TFormMainOld.btnMinimizeClick(Sender: TObject);
begin
  if (GApplication = APPL_FSEDGE) then
  begin
    {$ifdef Win64}self.BorderStyle := bsSizeable;{$endif}
  end;
  Self.WindowState := wsMinimized;
end;

procedure TFormMainOld.btnSpecialActionsMacroClick(Sender: TObject);
var
  lPoint: TPoint;
begin
  if IsKeyLoaded then
  begin
    //Popup menu over special button
    lPoint.x := 0;
    lPoint.y := 0;
    lPoint := btnSpecialActionsMacro.ClientToScreen(lPoint);
    pmTokensMacros.Popup(lPoint.x, lPoint.y);
  end;
end;

procedure TFormMainOld.btnBackspaceClick(Sender: TObject);
var
  cursorPos:integer;
  keyIdx: integer;
  aKey: TKey;
  keyText: string;
  isLongText: boolean;
  prevKey: integer;
begin
  if (IsKeyLoaded) and (activeKbKey.IsMacro) then
  begin
    cursorPos := memoMacro.SelStart;
    if (cursorPos > 0) then
    begin
      keyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, cursorPos);
      if (keyIdx >= 0) then
      begin
        aKey := activeKbKey.ActiveMacro[keyIdx];
        keyText := keyService.GetSingleKeyText(aKey, isLongText);
        prevKey := GetCursorPrevKey(cursorPos);
        if keyService.RemoveKey(activeKbKey, keyIdx) then
        begin
          MacroModified := true;
          SetEditMode(true);

          //Erase key from memo
          if (prevKey = -1) then
            memoMacro.SelStart := 0
          else
            memoMacro.SelStart := prevKey;
          memoMacro.SelLength := Length(keyText);
          memoMacro.SelText := '';

          if (prevKey = -1) then
            memoMacro.SelStart := 0
          else
            memoMacro.SelStart := prevKey;
        end;
      end;
    end;
  end;
end;

procedure TFormMainOld.btnCancelKeyClick(Sender: TObject);
begin
  if IsKeyLoaded then
  begin
    KeyModified := false;
    MacroModified := false;
    keyService.RestoreMacro(activeKbKey); //Returns to previous values for Macro
    keyService.RestoreKbKey(activeKbKey); //Returns to previous values for Key
    SetActiveKeyButton(nil);
    RefreshRemapInfo;
  end;
end;

procedure TFormMainOld.btnCancelMacroClick(Sender: TObject);
begin
  KeyModified := false;
  MacroModified := false;
  keyService.RestoreMacro(activeKbKey); //Returns to previous values
  activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0) ;
  SetMacroMode(true);
  UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
  SetActiveKeyButton(nil);
  pnlKb.SetFocus;
  RefreshRemapInfo;
end;

procedure TFormMainOld.btnClearClick(Sender: TObject);
begin
  if (IsKeyLoaded) and (activeKbKey.IsMacro) then
  begin
    memoMacro.Lines.Clear;
    keyService.ClearModifiers;
    activeKbKey.ActiveMacro.Clear;
    MacroModified := true;
    SetEditMode(true);
  end;
end;

procedure TFormMainOld.btnDoneKeyClick(Sender: TObject);
begin
  if IsKeyLoaded then
  begin
    if ValidateBeforeDone then
    begin
      KeyModified := false;
      MacroModified := false;
      SetSaveState(ssModifed);
      activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0);
      //SetMacroMode(false);
      SetActiveKeyButton(nil);
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMainOld.btnDoneMacroClick(Sender: TObject);
var
  keyAssigned: string;
  extraInfo: string;
begin
  if ValidateBeforeDone then
  begin
    KeyModified := false;
    MacroModified := false;
    SetSaveState(ssModifed);
    activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0);
    if (activeKbKey.IsMacro) then
    begin
      if activeKbKey.ActiveMacro.CoTrigger1 <> nil then
        keyAssigned := activeKbKey.ActiveMacro.CoTrigger1.OtherDisplayText + ' + ' + activeKbKey.OriginalKey.OtherDisplayText
      else
        keyAssigned := activeKbKey.OriginalKey.OtherDisplayText;
    end;
    SetMacroMode(true);
    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
    pnlKb.SetFocus;
    SetActiveKeyButton(nil);
    RefreshRemapInfo;

    //Show message for assigned macro
    if (keyAssigned <> '') then
    begin
      if (activeLayer.LayerIndex = BOTLAYER_IDX) then
        extraInfo := ' in the embedded layer';
      ShowDialog('Macro', 'Macro assigned to ' + StringReplace(keyAssigned, #10, ' ', [rfReplaceAll]) + extraInfo, mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT,
          backColor, fontColor);
    end;
  end;
end;

procedure TFormMainOld.btnLoadClick(Sender: TObject);
var
  fileName: string;
  errorMsg: string;
begin
  if CheckSaveKey(true) then
  begin
    CheckToSave;
    fileName := ShowLoad(backColor, fontColor);
    if (fileName <> '') then
    begin
      if not fileService.CheckIfFileExists(GLayoutFilePath + fileName) then
        fileService.SaveFile(GLayoutFilePath + fileName, nil, true, errorMsg);
      currentLayoutFile := GLayoutFilePath + fileName;
      LoadKeyboardLayout(currentLayoutFile);
      SetSaveState(ssNone);
    end;
  end;
end;

procedure TFormMainOld.btnPasteClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
  begin
    if (activeKbKey.ActiveMacro <> nil) and (copiedMacro <> nil) then
    begin
      SetMacroMode(true, false);
      activeKbKey.IsMacro := true;
      activeKbKey.ActiveMacro.Assign(copiedMacro);
      SetMacroText(true);
      LoadMacro;
      MacroModified := true;
    end;
  end;
end;

procedure TFormMainOld.btnSaveAsClick(Sender: TObject);
begin
  if CheckSaveKey(true) then
    SaveAs;
end;

procedure TFormMainOld.btnSaveClick(Sender: TObject);
begin
  if fileService.NewFile then
    SaveAs
  else
    Save;
end;

procedure TFormMainOld.eMacroFreqChange(Sender: TObject);
//var
//  freq: integer;
begin
  //if (freqKeyDown) then
  //begin
  //  freq := ConvertToInt(eMacroFreq.Text);
  //  if (freq = -1) or (freq < MACRO_FREQ_MIN) or (freq > MACRO_FREQ_MAX) then
  //  begin
  //    if (eMacroFreq.Text <> '') then
  //      ShowDialog('Macro Multiplay', 'Input a multiplay number (1-20) to program this macro to playback a specific number of times. If this box is left blank, the macro will repeat as long as the trigger keys are held down.' + #10 + 'Note: Short macros which are set to playback at high speeds may require a multiplay value of 1 to prevent them from being triggered multiple times by a single key press.',
  //        mtWarning, [mbOK], 225, backColor, fontColor);
  //    eMacroFreq.Text := '';
  //    if IsKeyLoaded then
  //    begin
  //      activeKbKey.ActiveMacro.MacroRptFreq := DEFAULT_MACRO_FREQ;
  //      MacroModified := true;
  //      SetEditMode(true);
  //    end;
  //    pnlKb.SetFocus;
  //  end
  //  else
  //  begin
  //    //eMacroFreq.Text := Key;
  //    if IsKeyLoaded then
  //    begin
  //      activeKbKey.ActiveMacro.MacroRptFreq := freq;
  //      MacroModified := true;
  //      SetEditMode(true);
  //    end;
  //
  //    //Deselect after 2 digits
  //    if (Length(eMacroFreq.Text) = 2) then
  //      pnlKb.SetFocus;
  //  end;
  //end;
  //freqKeyDown := false;
end;

procedure TFormMainOld.eMacroFreqEnter(Sender: TObject);
begin
  //eMacroFreq.SelectAll;
end;

procedure TFormMainOld.eMacroFreqKeyPress(Sender: TObject; var Key: char);
begin
  //freqKeyDown := true;
end;

procedure TFormMainOld.eMacroFreqMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //eMacroFreq.SelectAll;
end;

procedure TFormMainOld.eSpeedEnter(Sender: TObject);
begin
  //eSpeed.SelectAll;
end;

procedure TFormMainOld.eSpeedMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //eSpeed.SelectAll;
end;

procedure TFormMainOld.eSpeedChange(Sender: TObject);
//var
//  speed: integer;
begin
  //if (speedKeyDown) then
  //begin
  //  speed := ConvertToInt(eSpeed.Text);
  //  if (speed = -1) or (speed < SPEED_MIN) or (speed > SPEED_MAX) then
  //  begin
  //    if (eSpeed.Text <> '') then
  //      ShowDialog('Individual Macro Playback Speed', 'Input a custom playback speed for this specific macro (' + IntToStr(SPEED_MIN) + '-' + IntToStr(SPEED_MAX) + '). ' +
  //        'If this box is left blank, the macro will automatically playback at the Global speed which can be set with the slider at right.',
  //        mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
  //    eSpeed.Text := '';
  //    if IsKeyLoaded then
  //    begin
  //      activeKbKey.ActiveMacro.MacroSpeed := -1;
  //      MacroModified := true;
  //      SetEditMode(true);
  //    end;
  //    pnlKb.SetFocus;
  //  end
  //  else
  //  begin
  //    if IsKeyLoaded then
  //    begin
  //      activeKbKey.ActiveMacro.MacroSpeed := speed;
  //      MacroModified := true;
  //      SetEditMode(true);
  //      pnlKb.SetFocus;
  //    end;
  //  end;
  //end;
  //speedKeyDown := false;
end;

procedure TFormMainOld.eSpeedKeyPress(Sender: TObject; var Key: char);
begin
  //speedKeyDown := true;
end;

procedure TFormMainOld.OtherPanelClick(Sender: TObject);
begin
  if IsKeyLoaded then
  begin
    SetActiveKeyButton(nil);
  end;
end;

procedure TFormMainOld.imgBackdropClick(Sender: TObject);
begin
  if IsKeyLoaded then
  begin
    SetActiveKeyButton(nil);
  end;
end;

procedure TFormMainOld.KeyButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  lPoint: TPoint;
begin
  if (Button = TMouseButton.mbRight) then
  begin
    SetActiveKeyButton(sender as TLabelBox);
    if (IsKeyLoaded) then
    begin
      lPoint.x := (Sender as TLabelBox).Width;
      lPoint.y := (Sender as TLabelBox).Height;
      lPoint := (Sender as TLabelBox).ClientToScreen(lPoint);
      pmTokensKeys.Popup(lPoint.x, lPoint.y);
    end;
  end;
end;

procedure TFormMainOld.pmTokensKeysPopup(Sender: TObject);
var
  //i:integer;
  keyLoaded: boolean;

  procedure CheckToDisable(items: TMenuItem);
  var
    i:integer;
  begin
    for i := 0 to items.Count - 1 do
    begin
      if (not items[i].Default) then
        items[i].Enabled := (keyLoaded or (items[i].Tag = 1));

      if (items[i].Count > 0) then
        CheckToDisable(items[i]);
    end;
  end;

begin
  keyLoaded := IsKeyLoaded;
  CheckToDisable(pmTokensKeys.Items);
  //for i := 0 to pmTokensKeys.Items.Count - 1 do
  //begin
  //  if (not pmTokensKeys.Items[i].Default) then
  //    pmTokensKeys.Items[i].Enabled := (keyLoaded or (pmTokensKeys.Items[i].Tag = 1));
  //end;
end;

procedure TFormMainOld.RefreshRemapInfo;
var
  i, j:integer;
  aLayer: TKBLayer;
  aKbKey: TKBKey;
begin
  remapCount := 0;
  macroCount := 0;
  for i := 0 to keyService.KBLayers.Count - 1 do
  begin
    aLayer := keyService.KBLayers[i];
    for j := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      aKbKey := aLayer.KBKeyList[j];
      if (aKbKey.IsModified) then
        inc(remapCount);

      if (aKbKey.IsMacro) then
      begin
        if (aKbKey.Macro1.Count > 0) then
          inc(macroCount);
        if (aKbKey.Macro2.Count > 0) then
          inc(macroCount);
        if (aKbKey.Macro3.Count > 0) then
          inc(macroCount);
      end;
    end;
  end;

  if (remapCount > 0) then
    lblRemapKey.Caption := 'Remap (' + IntToStr(remapCount) + ')'
  else
    lblRemapKey.Caption := 'Remap';

  if (macroCount > 0) then
    lblCreateMacro.Caption := 'Macro (' + IntToStr(macroCount) + ')'
  else
    lblCreateMacro.Caption := 'Macro';

  btnResetLayer.Enabled := (remapCount > 0) or (macroCount > 0);
  btnResetLayout.Enabled := (remapCount > 0) or (macroCount > 0);
end;

procedure TFormMainOld.rgMacroClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
  begin
    LoadMacro;
    SetMacroText(true);
  end;
end;

procedure TFormMainOld.slMacroMultiplayChange(Sender: TObject);
begin
  if (IsKeyLoaded) and (not loadingMacro) then
  begin
    activeKbKey.ActiveMacro.MacroRptFreq := Trunc(slMacroMultiplay.Position);
    MacroModified := true;
    SetEditMode(true);
  end;
end;

procedure TFormMainOld.tbMultiplayChange(Sender: TObject);
begin
  if (IsKeyLoaded) and (not loadingMacro) then
  begin
    activeKbKey.ActiveMacro.MacroRptFreq := tbMultiplay.Position;
    MacroModified := true;
    SetEditMode(true);
  end;
end;

procedure TFormMainOld.tbSpeedChange(Sender: TObject);
begin
  if (IsKeyLoaded) and (not loadingMacro) then
  begin
    activeKbKey.ActiveMacro.MacroSpeed := tbSpeed.Position;
    MacroModified := true;
    SetEditMode(true);
  end;
end;

procedure TFormMainOld.slPlaybackSpeedChange(Sender: TObject);
begin
  if (IsKeyLoaded) and (not loadingMacro) then
  begin
    activeKbKey.ActiveMacro.MacroSpeed := Trunc(slPlaybackSpeed.Position);
    MacroModified := true;
    SetEditMode(true);
  end;
end;

procedure TFormMainOld.textMacroInputClick(Sender: TObject);
begin
  memoMacro.SetFocus;
end;

//procedure TFormMainOld.swAutoVDriveChange(Sender: TObject);
//begin
//  if (not loadingSettings) then
//  begin
//    fileService.SetVDriveStatut(swAutoVDrive.Checked);
//    SetSaveState(ssModifed);
//    if (swAutoVDrive.Checked) then
//      ShowDialog('V-Drive', 'The V-Drive will now open automatically each time you plug in the keyboard' + #10 + 'Note: Multimedia keys are disabled while v-drive is open.', mtInformation, [mbOK],
//        DEFAULT_DIAG_HEIGHT, backColor, fontColor);
//  end;
//end;

procedure TFormMainOld.swGameModeChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetGameMode(swGameMode.Checked);
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.swLayerSwitchClick(Sender: TObject);
begin
  if (not resetLayer) then
  begin
    if (CheckSaveKey(true)) then
    begin
      if (swLayerSwitch.Checked) then
        SetActiveLayer(TOPLAYER_IDX)
      else
        SetActiveLayer(BOTLAYER_IDX);
    end
    else
    begin
      resetLayer := true;
      swLayerSwitch.Checked := not swLayerSwitch.Checked;
    end;
  end;
  resetLayer := false;
end;

procedure TFormMainOld.tbMacroSpeedChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetMacroSpeed(tbMacroSpeed.Position);
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.slMacroSpeedChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetMacroSpeed(Trunc(slMacroSpeed.Position));
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.slStatusReportChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetStatusPlaySpeed(Trunc(slStatusReport.Position));
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.tbStatusReportChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetStatusPlaySpeed(tbStatusReport.Position);
    SetSaveState(ssModifed);
  end;
end;

procedure TFormMainOld.pmTokensMacrosPopup(Sender: TObject);
begin
  miWinCombM.Checked := keyService.IsWinKeyDown;
end;

procedure TFormMainOld.pnlTitleClick(Sender: TObject);
begin

end;

procedure TFormMainOld.miTokenMacroClick(Sender: TObject);
var
  menuItem: TMenuItem;
begin
  menuItem := sender as TMenuItem;

  if menuItem = miCutM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_X, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_X, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miCopyM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_C, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_C, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miPasteM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_V, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_V, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miSelectAllM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_A, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_A, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miUndoM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_Z, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_Z, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miRedoM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_Y, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_Y, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miDesktopM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_D, L_WIN_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_D, L_WIN_MOD, true)
    {$endif}
  end
  else if menuItem = miLastAppM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_TAB, L_ALT_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_TAB, L_ALT_MOD, true)
    {$endif}
  end
  else if menuItem = miCtrlAltDelM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_DELETE, L_CTRL_MOD + ',' + L_ALT_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_DELETE, L_CTRL_MOD + ',' + L_ALT_MOD, true)
    {$endif}
  end
  else if menuItem = miWinCombM then
  begin
    if keyService.IsWinKeyDown then
    begin
      keyService.RemoveModifier(VK_LWIN);
      keyService.RemoveModifier(VK_RWIN);
    end
    else
    begin
      keyService.AddModifier(VK_LWIN);
      ShowDialog('Windows Combination Active', 'Now press the key(s) you wish to combine with the Windows key in your macro. Then deselect Windows Combination from the Special Actions menu if you wish to continue programming or click Done.',
        mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
      memoMacro.SetFocus;
    end;
  end
  else if menuItem = miShortDelayM then
    SetModifiedKey(VK_125MS, '', true)
  else if menuItem = miLongDelayM then
    SetModifiedKey(VK_500MS, '', true)
  else if menuItem = miF13M then
    SetModifiedKey(VK_F13, '', true)
  else if menuItem = miF14M then
    SetModifiedKey(VK_F14, '', true)
  else if menuItem = miF15M then
    SetModifiedKey(VK_F15, '', true)
  else if menuItem = miF16M then
    SetModifiedKey(VK_F16, '', true)
  else if menuItem = miF17M then
    SetModifiedKey(VK_F17, '', true)
  else if menuItem = miF18M then
    SetModifiedKey(VK_F18, '', true)
  else if menuItem = miF19M then
    SetModifiedKey(VK_F19, '', true)
  else if menuItem = miF20M then
    SetModifiedKey(VK_F20, '', true)
  else if menuItem = miF21M then
    SetModifiedKey(VK_F21, '', true)
  else if menuItem = miF22M then
    SetModifiedKey(VK_F22, '', true)
  else if menuItem = miF23M then
    SetModifiedKey(VK_F23, '', true)
  else if menuItem = miF24M then
    SetModifiedKey(VK_F24, '', true)
  else if menuItem = miHomeM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_HOME, L_ALT_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_HOME, L_ALT_MOD, true)
    {$endif}
  end
  else if menuItem = miForwardM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_RIGHT, L_ALT_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_RIGHT, L_ALT_MOD, true)
    {$endif}
  end
  else if menuItem = miBackM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_lEFT, L_ALT_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_lEFT, L_ALT_MOD, true)
    {$endif}
  end
  else if menuItem = miNewTabM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_T, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_T, L_CTRL_MOD, true)
    {$endif}
  end
  else if menuItem = miSwitchTabsM then
  begin
    {$ifdef Win64} //Windows
    SetModifiedKey(VK_TAB, L_CTRL_MOD, true)
    {$endif}
    {$ifdef Darwin}  //MacOS
    SetModifiedKey(VK_TAB, L_CTRL_MOD, true)
    {$endif}
  end
  else if (menuItem = miLeftMouseM) then
    SetModifiedKey(VK_MOUSE_LEFT, '', true)
  else if (menuItem = miRightMouseM) then
    SetModifiedKey(VK_MOUSE_RIGHT, '', true)
  else if (menuItem = miMiddleMouseM) then
    SetModifiedKey(VK_MOUSE_MIDDLE, '', true)
  else if (menuItem = miBtn4MouseM) then
    SetModifiedKey(VK_MOUSE_BTN4, '', true)
  else if (menuItem = miBtn5MouseM) then
    SetModifiedKey(VK_MOUSE_BTN5, '', true)
  else if menuItem = miFastDblClickM then
  begin
    SetModifiedKey(VK_MOUSE_LEFT, '', true);
    SetModifiedKey(VK_125MS, '', true);
    SetModifiedKey(VK_MOUSE_LEFT, '', true);
  end
  else if menuItem = miSlowDblClickM then
  begin
    SetModifiedKey(VK_MOUSE_LEFT, '', true);
    SetModifiedKey(VK_500MS, '', true);
    SetModifiedKey(VK_MOUSE_LEFT, '', true);
  end;
end;

procedure TFormMainOld.miTokenKeyClick(Sender: TObject);
var
  menuItem: TMenuItem;
  customBtns: TCustomButtons;
begin
  menuItem := sender as TMenuItem;

  if menuItem = miFnToggle then
    SetModifiedKey(VK_FN_TOGGLE, '', false, true)
  else if menuItem = miFnShift then
    SetModifiedKey(VK_FN_SHIFT, '', false, true)
  else if menuItem = miLed then
    SetModifiedKey(VK_LED, '', false)
  else if menuItem = miRightWin then
    SetModifiedKey(VK_RWIN, '', false)
  else if menuItem = miVolumeUp then
    SetModifiedKey(VK_VOLUME_UP, '', false)
  else if menuItem = miVolumeDown then
    SetModifiedKey(VK_VOLUME_DOWN, '', false)
  else if menuItem = miMute then
    SetModifiedKey(VK_VOLUME_MUTE, '', false)
  else if menuItem = miPlayPause then
    SetModifiedKey(VK_MEDIA_PLAY_PAUSE, '', false)
  else if menuItem = miPreviousTrack then
    SetModifiedKey(VK_MEDIA_PREV_TRACK, '', false)
  else if menuItem = miNextTrack then
    SetModifiedKey(VK_MEDIA_NEXT_TRACK, '', false)
  else if menuItem = miMicMute then
    SetModifiedKey(VK_MIC_MUTE, '', false)
  else if menuItem = miCalculator then
    SetModifiedKey(VK_CALC, '', false)
  else if menuItem = miShutdown then
    SetModifiedKey(VK_SHUTDOWN, '', false)
  else if menuItem = miIntlKey then
    SetModifiedKey(VK_OEM_102, '', false)
  else if menuItem = miMenu then
    SetModifiedKey(VK_APPS, '', false)
  else if menuItem = miNull then
    SetModifiedKey(VK_NULL, '', false)
  else if menuItem = miF13 then
    SetModifiedKey(VK_F13, '', false)
  else if menuItem = miF14 then
    SetModifiedKey(VK_F14, '', false)
  else if menuItem = miF15 then
    SetModifiedKey(VK_F15, '', false)
  else if menuItem = miF16 then
    SetModifiedKey(VK_F16, '', false)
  else if menuItem = miF17 then
    SetModifiedKey(VK_F17, '', false)
  else if menuItem = miF18 then
    SetModifiedKey(VK_F18, '', false)
  else if menuItem = miF19 then
    SetModifiedKey(VK_F19, '', false)
  else if menuItem = miF20 then
    SetModifiedKey(VK_F20, '', false)
  else if menuItem = miF21 then
    SetModifiedKey(VK_F21, '', false)
  else if menuItem = miF22 then
    SetModifiedKey(VK_F22, '', false)
  else if menuItem = miF23 then
    SetModifiedKey(VK_F23, '', false)
  else if menuItem = miF24 then
    SetModifiedKey(VK_F24, '', false)
  else if (menuItem = miFullLeftSide) then
    SetFnNumericKpLeft
  else if (menuItem = miFullRightSide) then
    SetFnNumericKpRight
  else if (menuItem = miNum0) then
    SetModifiedKey(VK_NUMPAD0, '', false)
  else if (menuItem = miNum1) then
    SetModifiedKey(VK_NUMPAD1, '', false)
  else if (menuItem = miNum2) then
    SetModifiedKey(VK_NUMPAD2, '', false)
  else if (menuItem = miNum3) then
    SetModifiedKey(VK_NUMPAD3, '', false)
  else if (menuItem = miNum4) then
    SetModifiedKey(VK_NUMPAD4, '', false)
  else if (menuItem = miNum5) then
    SetModifiedKey(VK_NUMPAD5, '', false)
  else if (menuItem = miNum6) then
    SetModifiedKey(VK_NUMPAD6, '', false)
  else if (menuItem = miNum7) then
    SetModifiedKey(VK_NUMPAD7, '', false)
  else if (menuItem = miNum8) then
    SetModifiedKey(VK_NUMPAD8, '', false)
  else if (menuItem = miNum9) then
    SetModifiedKey(VK_NUMPAD9, '', false)
  else if (menuItem = miNumDec) then
    SetModifiedKey(VK_DECIMAL, '', false)
  else if (menuItem = miNumPlus) then
    SetModifiedKey(VK_ADD, '', false)
  else if (menuItem = miNumMinus) then
    SetModifiedKey(VK_SUBTRACT, '', false)
  else if (menuItem = miNumDivide) then
    SetModifiedKey(VK_DIVIDE, '', false)
  else if (menuItem = miNumMultiply) then
    SetModifiedKey(VK_MULTIPLY, '', false)
  else if (menuItem = miNumEnter) then
    SetModifiedKey(VK_NUMPADENTER, '', false)
  else if (menuItem = miNumLock) then
    SetModifiedKey(VK_NUMLOCK, '', false)
  else if (menuItem = miDvorak) or (menuItem = miColemak) then
  begin
    if (menuItem = miDvorak) then
    begin
      createCustomButton(customBtns, 'Both Layers', 100, @setDvorakBothLayers);
      createCustomButton(customBtns, 'Top Layer', 100, @setDvorakTopLayer);
      createCustomButton(customBtns, 'Fn Layer', 100, @setDvorakFnLayer);
      createCustomButton(customBtns, 'Cancel', 100, nil, bkCancel);
    end
    else if (menuItem = miColemak) then
    begin
      createCustomButton(customBtns, 'Both Layers', 100, @setColemakBothLayers);
      createCustomButton(customBtns, 'Top Layer', 100, @setColemakTopLayer);
      createCustomButton(customBtns, 'Fn Layer', 100, @setColemakFnLayer);
      createCustomButton(customBtns, 'Cancel', 100, nil, bkCancel);
    end;

    ShowDialog('Alternate Layout',
      'To which Layer would you like to apply this alternate layout?' + #10#10 +
      'Note: Implementing this layout may overwrite existing remaps.',
      mtWarning, [], DEFAULT_DIAG_HEIGHT, backColor, fontColor, customBtns);
  end
  else if (menuItem = miLeftMouse) then
    SetModifiedKey(VK_MOUSE_LEFT, '', false)
  else if (menuItem = miRightMouse) then
    SetModifiedKey(VK_MOUSE_RIGHT, '', false)
  else if (menuItem = miMiddleMouse) then
    SetModifiedKey(VK_MOUSE_MIDDLE, '', false)
  else if (menuItem = miBtn4Mouse) then
    SetModifiedKey(VK_MOUSE_BTN4, '', false)
  else if (menuItem = miBtn5Mouse) then
    SetModifiedKey(VK_MOUSE_BTN5, '', false);

  btnDoneKey.Click;
end;

procedure TFormMainOld.knobBrightClick(Sender: TObject);
//var
//  knobPos: Real;
begin
  //if (not settingLedMode) then
  //begin
  //  knobPos := knobBright.Position;
  //  if (Frac(knobPos) > 0) then
  //  begin
  //    knobBright.Position := Round(knobPos);
  //  end;
  //  SetLedMode(IntToStr(Trunc(knobBright.Position)));
  //end;
end;

procedure TFormMainOld.knobBrightMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
begin
  if (not settingLedMode) then
  begin
    knobPos := knobBright.Position;
    if (Frac(knobPos) > 0) then
    begin
      knobBright.Position := Round(knobPos);
    end;
    SetLedMode(IntToStr(Trunc(knobBright.Position)));
  end;
end;

procedure TFormMainOld.ledBreatheClick(Sender: TObject);
begin
  if (not settingLedMode) then
    SetLedMode(BREATHE);
end;

procedure TFormMainOld.memoMacroMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //Prevent selecting text in macro with the mouse
  if memoMacro.SelLength > 0 then
     memoMacro.SelLength := 0;
end;

procedure TFormMainOld.ledPBClick(Sender: TObject);
begin
  if (not settingLedMode) then
    SetLedMode(PITCH_BLACK);
end;

procedure TFormMainOld.SetFnNumericKpLeft;
var
  aFnLayer: TKBLayer;
  sMessage: string;
begin
  if CheckSaveKey(true) then
  begin
    sMessage := 'Inserting this numeric keypad may overwrite existing remaps in the Fn Layer of this Layout, proceed?';
    if (GApplication = APPL_FSEDGE) then
      sMessage := sMessage  + #10#10 + 'Note: There is no numlock indicator light on the keyboard.';

    if ShowDialog('Insert Numeric Keypad', sMessage,
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, backColor, fontColor) = mrYes then
    begin
      aFnLayer := keyService.GetLayer(BOTLAYER_IDX);
      if (aFnLayer <> nil) then
      begin
        KeyModified := true;
        SetEditMode(true);
        SetSaveState(ssModifed);

        keyService.SetKBKeyIdx(aFnLayer, 21, VK_NUMPAD7);  //Replace Fn 2
        keyService.SetKBKeyIdx(aFnLayer, 22, VK_NUMPAD8);  //Replace Fn 3
        keyService.SetKBKeyIdx(aFnLayer, 23, VK_NUMPAD9);  //Replace Fn 4
        keyService.SetKBKeyIdx(aFnLayer, 24, VK_NUMPAD0);  //Replace Fn 5
        keyService.SetKBKeyIdx(aFnLayer, 25, VK_MULTIPLY); //Replace Fn 6

        keyService.SetKBKeyIdx(aFnLayer, 7, VK_NUMLOCK);  //Replace Fn F7
        keyService.SetKBKeyIdx(aFnLayer, 38, VK_NUMPAD4);  //Replace Fn w
        keyService.SetKBKeyIdx(aFnLayer, 39, VK_NUMPAD5);  //Replace Fn e
        keyService.SetKBKeyIdx(aFnLayer, 40, VK_NUMPAD6);  //Replace Fn r
        keyService.SetKBKeyIdx(aFnLayer, 41, VK_SUBTRACT);  //Replace Fn t

        keyService.SetKBKeyIdx(aFnLayer, 55, VK_NUMPAD1);  //Replace Fn s
        keyService.SetKBKeyIdx(aFnLayer, 56, VK_NUMPAD2);  //Replace Fn d
        keyService.SetKBKeyIdx(aFnLayer, 57, VK_NUMPAD3);  //Replace Fn f
        keyService.SetKBKeyIdx(aFnLayer, 58, VK_ADD);  //Replace Fn g

        keyService.SetKBKeyIdx(aFnLayer, 71, VK_NUMPAD0);  //Replace Fn x
        keyService.SetKBKeyIdx(aFnLayer, 72, VK_LCL_COMMA);  //Replace Fn c
        keyService.SetKBKeyIdx(aFnLayer, 73, VK_DECIMAL);  //Replace Fn v
        keyService.SetKBKeyIdx(aFnLayer, 74, VK_DIVIDE);  //Replace Fn b
        keyService.SetKBKeyIdx(aFnLayer, 88, VK_NUMPADENTER);  //Replace Fn lspc

        SetActiveLayer(BOTLAYER_IDX);
        swLayerSwitch.Checked := false;
        RefreshRemapInfo;
      end;
    end;
  end;
end;

procedure TFormMainOld.SetFnNumericKpRight;
var
  aFnLayer: TKBLayer;
  sMessage: string;
begin
  if CheckSaveKey(true) then
  begin
    sMessage := 'Inserting this numeric keypad may overwrite existing remaps in the Fn Layer of this Layout, proceed?';
    if (GApplication = APPL_FSEDGE) then
      sMessage := sMessage  + #10#10 + 'Note: There is no numlock indicator light on the keyboard.';

    if ShowDialog('Insert Numeric Keypad', sMessage,
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, backColor, fontColor) = mrYes then
    begin
      aFnLayer := keyService.GetLayer(BOTLAYER_IDX);
      if (aFnLayer <> nil) then
      begin
        KeyModified := true;
        SetEditMode(true);
        SetSaveState(ssModifed);

        keyService.SetKBKeyIdx(aFnLayer, 26, VK_NUMPAD7);  //Replace Fn 7
        keyService.SetKBKeyIdx(aFnLayer, 27, VK_NUMPAD8);  //Replace Fn 8
        keyService.SetKBKeyIdx(aFnLayer, 28, VK_NUMPAD9);  //Replace Fn 9
        keyService.SetKBKeyIdx(aFnLayer, 29, VK_NUMPAD0);  //Replace Fn 0
        keyService.SetKBKeyIdx(aFnLayer, 30, VK_MULTIPLY); //Replace Fn -

        if (GApplication = APPL_FSEDGE) then
          keyService.SetKBKeyIdx(aFnLayer, 12, VK_NUMLOCK);  //Replace Fn F12
        keyService.SetKBKeyIdx(aFnLayer, 43, VK_NUMPAD4);  //Replace Fn u
        keyService.SetKBKeyIdx(aFnLayer, 44, VK_NUMPAD5);  //Replace Fn i
        keyService.SetKBKeyIdx(aFnLayer, 45, VK_NUMPAD6);  //Replace Fn o
        keyService.SetKBKeyIdx(aFnLayer, 46, VK_SUBTRACT);  //Replace Fn p

        keyService.SetKBKeyIdx(aFnLayer, 60, VK_NUMPAD1);  //Replace Fn j
        keyService.SetKBKeyIdx(aFnLayer, 61, VK_NUMPAD2);  //Replace Fn k
        keyService.SetKBKeyIdx(aFnLayer, 62, VK_NUMPAD3);  //Replace Fn l
        keyService.SetKBKeyIdx(aFnLayer, 63, VK_ADD);  //Replace Fn ;
        if (GApplication = APPL_FSPRO) then
          keyService.SetKBKeyIdx(aFnLayer, 65, VK_NUMPADENTER);  //Replace Fn Enter

        keyService.SetKBKeyIdx(aFnLayer, 76, VK_NUMPAD0);  //Replace Fn m
        keyService.SetKBKeyIdx(aFnLayer, 78, VK_DECIMAL);  //Replace Fn .
        keyService.SetKBKeyIdx(aFnLayer, 79, VK_DIVIDE);  //Replace Fn .
        if (GApplication = APPL_FSEDGE) then
          keyService.SetKBKeyIdx(aFnLayer, 89, VK_NUMPADENTER);  //Replace Fn right space

        SetActiveLayer(BOTLAYER_IDX);
        swLayerSwitch.Checked := false;
        RefreshRemapInfo;
      end;
    end;
  end;
end;

procedure TFormMainOld.SetDvorakKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey(true) then
  begin
    CloseDialog;

    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      aLayer := keyService.KBLayers[i];
      if (aLayer <> nil) and (bothLayers or (layerIdx = i)) then
      begin
        KeyModified := true;
        SetEditMode(true);
        SetSaveState(ssModifed);

        keyService.SetKBKeyIdx(aLayer, 30, VK_LCL_OPEN_BRAKET);  //Replace -
        keyService.SetKBKeyIdx(aLayer, 31, VK_LCL_CLOSE_BRAKET);  //Replace =
        keyService.SetKBKeyIdx(aLayer, 37, VK_LCL_QUOTE);  //Replace q
        keyService.SetKBKeyIdx(aLayer, 38, VK_LCL_COMMA);  //Replace w
        keyService.SetKBKeyIdx(aLayer, 39, VK_LCL_POINT); //Replace e

        keyService.SetKBKeyIdx(aLayer, 40, VK_P); //Replace r
        keyService.SetKBKeyIdx(aLayer, 41, VK_Y); //Replace t
        keyService.SetKBKeyIdx(aLayer, 42, VK_F); //Replace y
        keyService.SetKBKeyIdx(aLayer, 43, VK_G); //Replace u
        keyService.SetKBKeyIdx(aLayer, 44, VK_C); //Replace i
        keyService.SetKBKeyIdx(aLayer, 45, VK_R); //Replace o
        keyService.SetKBKeyIdx(aLayer, 46, VK_L); //Replace p

        keyService.SetKBKeyIdx(aLayer, 47, VK_LCL_SLASH);  //Replace [
        keyService.SetKBKeyIdx(aLayer, 48, VK_LCL_EQUAL);  //Replace ]
        keyService.SetKBKeyIdx(aLayer, 55, VK_O);  //Replace s
        keyService.SetKBKeyIdx(aLayer, 56, VK_E);  //Replace d
        keyService.SetKBKeyIdx(aLayer, 57, VK_U);  //Replace f
        keyService.SetKBKeyIdx(aLayer, 58, VK_I);  //Replace g
        keyService.SetKBKeyIdx(aLayer, 59, VK_D);  //Replace h
        keyService.SetKBKeyIdx(aLayer, 60, VK_H);  //Replace j
        keyService.SetKBKeyIdx(aLayer, 61, VK_T);  //Replace k
        keyService.SetKBKeyIdx(aLayer, 62, VK_N);  //Replace l

        keyService.SetKBKeyIdx(aLayer, 63, VK_S);  //Replace colon
        keyService.SetKBKeyIdx(aLayer, 64, VK_LCL_MINUS);  //Replace apos
        keyService.SetKBKeyIdx(aLayer, 70, VK_LCL_SEMI_COMMA);  //Replace z
        keyService.SetKBKeyIdx(aLayer, 71, VK_Q);  //Replace x
        keyService.SetKBKeyIdx(aLayer, 72, VK_J);  //Replace c
        keyService.SetKBKeyIdx(aLayer, 73, VK_K);  //Replace v
        keyService.SetKBKeyIdx(aLayer, 74, VK_X);  //Replace b
        keyService.SetKBKeyIdx(aLayer, 75, VK_B);  //Replace n
        keyService.SetKBKeyIdx(aLayer, 77, VK_W);  //Replace comma
        keyService.SetKBKeyIdx(aLayer, 78, VK_V);  //Replace period
        keyService.SetKBKeyIdx(aLayer, 79, VK_Z);  //Replace /
      end;
    end;

    if (not bothLayers) then
    begin
      SetActiveLayer(layerIdx);
      swLayerSwitch.Checked := layerIdx = TOPLAYER_IDX;
    end
    else
      LoadLayer(activeLayer);
    RefreshRemapInfo;
  end;
end;

procedure TFormMainOld.SetColemakKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey(true) then
  begin
    CloseDialog;

    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      aLayer := keyService.KBLayers[i];
      if (aLayer <> nil) and (bothLayers or (layerIdx = i)) then
      begin
        KeyModified := true;
        SetEditMode(true);
        SetSaveState(ssModifed);

        keyService.SetKBKeyIdx(aLayer, 39, VK_F);  //Replace e
        keyService.SetKBKeyIdx(aLayer, 40, VK_P);  //Replace r
        keyService.SetKBKeyIdx(aLayer, 41, VK_G);  //Replace t
        keyService.SetKBKeyIdx(aLayer, 42, VK_J);  //Replace y
        keyService.SetKBKeyIdx(aLayer, 43, VK_L); //Replace u
        keyService.SetKBKeyIdx(aLayer, 44, VK_U); //Replace i
        keyService.SetKBKeyIdx(aLayer, 45, VK_Y); //Replace o
        keyService.SetKBKeyIdx(aLayer, 46, VK_LCL_SEMI_COMMA); //Replace p
        keyService.SetKBKeyIdx(aLayer, 55, VK_R); //Replace s
        keyService.SetKBKeyIdx(aLayer, 56, VK_S); //Replace d
        keyService.SetKBKeyIdx(aLayer, 57, VK_T); //Replace f
        keyService.SetKBKeyIdx(aLayer, 58, VK_D); //Replace g
        keyService.SetKBKeyIdx(aLayer, 60, VK_N);  //Replace j
        keyService.SetKBKeyIdx(aLayer, 61, VK_E);  //Replace k
        keyService.SetKBKeyIdx(aLayer, 62, VK_I);  //Replace l
        keyService.SetKBKeyIdx(aLayer, 63, VK_O);  //Replace colon
        keyService.SetKBKeyIdx(aLayer, 75, VK_K);  //Replace n
      end;
    end;

    if (not bothLayers) then
    begin
      SetActiveLayer(layerIdx);
      swLayerSwitch.Checked := layerIdx = TOPLAYER_IDX;
    end
    else
      LoadLayer(activeLayer);
    RefreshRemapInfo;
  end;
end;

procedure TFormMainOld.watchTutorialClick(Sender: TObject);
begin
  if (GApplication = APPL_FSPRO) then
    OpenUrl(FSPRO_TUTORIAL)
  else
    OpenUrl(FSEDGE_TUTORIAL);
end;

procedure TFormMainOld.readManualClick(Sender: TObject);
var
  filePath: string;
begin
  filePath := GApplicationPath + '\help\' + USER_MANUAL_FSEDGE;
  {$ifdef Darwin}filePath := GApplicationPath + '/help/' + USER_MANUAL_FSEDGE;{$endif}

  if FileExists(filePath) then
    OpenDocument(filePath)
  else
    ShowDialog('Help file', 'Help file not found!', mtError, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
end;

procedure TFormMainOld.openTroubleshootingTipsClick(Sender: TObject);
begin
  OpenUrl('https://gaming.kinesis-ergo.com/support/fs-edge-support/');
end;

procedure TFormMainOld.createCustomButton(var customBtns: TCustomButtons;
  btnCaption: string; btnWidth: integer; btnOnClick: TNotifyEvent;
  btnKind: TBitBtnKind = bkCustom);
var
  customBtn: TCustomButton;
begin
  customBtn.Caption := btnCaption;
  customBtn.Width := btnwidth;
  customBtn.OnClick := btnOnClick;
  customBtn.Kind := btnKind;

  SetLength(customBtns, Length(customBtns) + 1);
  customBtns[Length(customBtns) - 1] := customBtn;
end;

procedure TFormMainOld.setDvorakBothLayers(Sender: TObject);
begin
  SetDvorakKb(0, true);
end;

procedure TFormMainOld.setDvorakTopLayer(Sender: TObject);
begin
  SetDvorakKb(TOPLAYER_IDX, false);
end;

procedure TFormMainOld.setDvorakFnLayer(Sender: TObject);
begin
  SetDvorakKb(BOTLAYER_IDX, false);
end;

procedure TFormMainOld.setColemakBothLayers(Sender: TObject);
begin
  SetColemakKb(0, true);
end;

procedure TFormMainOld.setColemakTopLayer(Sender: TObject);
begin
  SetColemakKb(TOPLAYER_IDX, false);
end;

procedure TFormMainOld.setColemakFnLayer(Sender: TObject);
begin
  SetColemakKb(BOTLAYER_IDX, false);
end;

procedure TFormMainOld.continueClick(Sender: TObject);
begin
  CloseDialog;
end;

procedure TFormMainOld.bCoTriggerClick(Sender: TObject);
var
  button: THSSpeedButton;
  aKey: TKey;
begin
  if IsKeyLoaded then
  begin
    button := Sender as THSSpeedButton;
    if (button.Down) then
    begin
      ResetMacroCoTriggers;

      ActivateCoTrigger(button);
      //if (activeKbKey.ActiveMacro.CoTrigger1 = nil) then
      //begin
        aKey := GetCoTriggerKey(Sender);
        if (aKey <> nil) then
        begin
          activeKbKey.ActiveMacro.CoTrigger1 := aKey.CopyKey;
          MacroModified := true;
          SetEditMode(true);
        end;
      //end
      //else
      //begin
      //  ShowDialog('Co-Triggers', 'You cannot add more than 1 co-triggers', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
      //  ResetCoTrigger(button);
      //end;
    end
    else
    begin
      ResetCoTrigger(button);
      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
        RemoveCoTrigger(aKey.Key);
    end;
  end;
end;

procedure TFormMainOld.btnHelpIconClick(Sender: TObject);
begin
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.SetFirmwareVersion(fileService.FirmwareVersion);
  FormAbout.ShowModal;
end;

function TFormMainOld.GetCoTriggerKey(Sender: TObject): TKey;
begin
  if (Sender = bLShiftMacro) then
    result := keyService.FindKeyConfig(VK_LSHIFT)
  else if (Sender = bRShiftMacro) then
    result := keyService.FindKeyConfig(VK_RSHIFT)
  else if (Sender = bLCtrlMacro) then
    result := keyService.FindKeyConfig(VK_LCONTROL)
  else if (Sender = bRCtrlMacro) then
    result := keyService.FindKeyConfig(VK_RCONTROL)
  else if (Sender = bLAltMacro) then
    result := keyService.FindKeyConfig(VK_LMENU)
  else if (Sender = bRAltMacro) then
    result := keyService.FindKeyConfig(VK_RMENU)
  else
    result := nil;
end;

procedure TFormMainOld.RemoveCoTrigger(key: word);
begin
  if IsKeyLoaded then
  begin
    MacroModified := true;
    SetEditMode(true);
    if (activeKbKey.ActiveMacro.CoTrigger1 <> nil) and (activeKbKey.ActiveMacro.CoTrigger1.Key = key) then
      activeKbKey.ActiveMacro.CoTrigger1 := nil;
  end;
end;

procedure TFormMainOld.bBrightnessClick(Sender: TObject);
begin
//var
//  button: THSSpeedButton;
//begin
//  button := (sender as THSSpeedButton);
//  ResetBrighBtn(btnBright1);
//  ResetBrighBtn(btnBright2);
//  ResetBrighBtn(btnBright3);
//  ResetBrighBtn(btnBright4);
//  ResetBrighBtn(btnBright5);
//  ResetBrighBtn(btnBright6);
//  ResetBrighBtn(btnBright7);
//  ResetBrighBtn(btnBright8);
//  ResetBrighBtn(btnBright9);
//  ResetBrighBtn(btnBrightOff);
//  ResetBrighBtn(btnBreathe);
//  ResetBrighBtn(btnPitchBlack);
//  if (button.Down) then
//    ActivateBrighBtn(button);
//
//  if (not loadingSettings) then
//  begin
//    SetSaveState(ssModifed);
//
//    if (btnBright1.Down) then
//      fileService.SetLedMode('1')
//    else if (btnBright2.Down) then
//      fileService.SetLedMode('2')
//    else if (btnBright3.Down) then
//      fileService.SetLedMode('3')
//    else if (btnBright4.Down) then
//      fileService.SetLedMode('4')
//    else if (btnBright5.Down) then
//      fileService.SetLedMode('5')
//    else if (btnBright6.Down) then
//      fileService.SetLedMode('6')
//    else if (btnBright7.Down) then
//      fileService.SetLedMode('7')
//    else if (btnBright8.Down) then
//      fileService.SetLedMode('8')
//    else if (btnBright9.Down) then
//      fileService.SetLedMode('9')
//    else if (btnBrightOff.Down) then
//      fileService.SetLedMode('0')
//    else if (btnBreathe.Down) then
//      fileService.SetLedMode('B')
//    else if (btnPitchBlack.Down) then
//      fileService.SetLedMode('P');
//  end;
end;

procedure TFormMainOld.SetLedMode(ledMode: string);
var
  iLedMode: integer;
begin
  settingLedMode := true;

  ledMode := AnsiUpperCase(ledMode);
  iLedMode := ConvertToInt(ledMode);

  //Reset values
  knobBright.Position := 0;
  ledKnob.Color := KINESIS_DARK_GRAY_FS;
  ledKnob.Bright := false;
  ledKnob.Reflection := false;
  ledBreathe.Color := clBlack;
  ledBreatheBorder.Color := clWhite;
  ledPB.Color := clBlack;
  ledPBBorder.Color := clWhite;

  //Set values
  if (iLedMode >= 1) and (iLedMode <= 9) then
  begin
    knobBright.Position := iLedMode;
    ledKnob.Color := blueColor;
    ledKnob.Bright := true;
    ledKnob.Reflection := true;
  end
  else if (ledMode = PITCH_BLACK) then
  begin
    ledPB.Color := blueColor;
    ledPBBorder.Color := blueColor;
  end
  else if (ledMode = BREATHE) then
  begin
    ledBreathe.Color := blueColor;
    ledBreatheBorder.Color := blueColor;
  end;

  if (not loadingSettings) then
  begin
    fileService.SetLedMode(ledMode);
    SetSaveState(ssModifed);
  end;

  settingLedMode := false;
end;

function TFormMainOld.ValidateBeforeDone: boolean;
var
  errorMsg: string;
  errorTitle: string;
  isValid: boolean;
begin
  isValid := keyService.ValidateMacros(activeKbKey, errorMsg, errorTitle);

  if isValid then
  begin
    RefreshRemapInfo;
    if macroCount > MAX_MACRO_FS then
    begin
      isValid := false;
      errorMsg := 'Only ' + IntToStr(MAX_MACRO_FS) + ' macros can be saved to a layout. To proceed, erase a macro or create a new layout.';
      errorTitle := 'Macro Capacity Reached';
    end;
  end;

  if not isValid then
    ShowDialog(errorTitle, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT,
          backColor, fontColor);

  result := isValid;
end;

procedure TFormMainOld.AppDeactivate(Sender: TObject);
begin
  keyService.ClearModifiers;
end;

procedure TFormMainOld.EnableMacroBox(value: boolean);
begin
  memoMacro.Enabled := value;
  rgMacro1.Enabled := value;
  rgMacro2.Enabled := value;
  rgMacro3.Enabled := value;
  bLShiftMacro.Enabled := value;
  bRShiftMacro.Enabled := value;
  bLCtrlMacro.Enabled := value;
  bRCtrlMacro.Enabled := value;
  bLAltMacro.Enabled := value;
  bRAltMacro.Enabled := value;
  tbSpeed.Enabled := value;
  slPlaybackSpeed.Enabled := value;
  tbMultiplay.Enabled := value;
  slMacroMultiplay.Enabled := value;
end;

function TFormMainOld.GetKeyOtherLayer(keyIdx: integer): TKBKey;
var
  i: integer;
begin
  result := nil;
  if (activeLayer <> nil) then
  begin
    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      if (keyService.KBLayers[i].LayerIndex <> activeLayer.LayerIndex) then
      begin
        result := keyService.GetKbKeyByIndex(keyService.KBLayers[i], keyIdx);
        break;
      end;
    end;
  end;
end;

//On application restore, remove borderstyle
procedure TFormMainOld.OnRestore(Sender: TObject);
begin
  if (GApplication = APPL_FSEDGE) then
  begin
    self.WindowState := wsNormal;
    {$ifdef Win64}self.BorderStyle := bsNone;{$endif}
  end;

  //To repaint red color in macro box
  SetMacroText(true);
end;

procedure TFormMainOld.SetMacroMode(value: boolean; reset: boolean = true);
begin
  MacroMode := false;

  if IsKeyLoaded then
  begin
    MacroMode := value and (activeKbKey.CanAssignMacro);
    MacroModified := false;
  end;

  if (MacroMode) then
    keyService.BackupMacro(activeKbKey);

  if reset then
    rgMacro1.Checked := true;

  //pnlMacro.Enabled := MacroMode;
  EnableMacroBox(MacroMode);
  btnCancelMacro.Enabled := MacroMode;
  btnDoneMacro.Enabled := MacroMode;
  btnBackspace.Enabled := MacroMode;
  btnClear.Enabled := MacroMode;
  btnSpecialActionsMacro.Enabled := MacroMode;
  btnCopy.Enabled := MacroMode;
  btnPaste.Enabled := MacroMode;
  bLShiftMacro.Enabled := MacroMode;
  bLCtrlMacro.Enabled := MacroMode;
  bLAltMacro.Enabled := MacroMode;
  bRAltMacro.Enabled := MacroMode;
  bRCtrlMacro.Enabled := MacroMode;
  bRShiftMacro.Enabled := MacroMode;
  ResetMacroCoTriggers;
  textMacroInput.Visible := IsKeyLoaded and (activeKbKey.ActiveMacro.Count = 0) and (activeKbKey.CanAssignMacro);

  if (MacroMode) and (IsKeyLoaded) and (activeKbKey.IsMacro) then
  begin
    //activeKbKey.IsMacro := true;
    LoadMacro;
    SetMacroText(true);
  end
  else
  begin
    lblMacro1.Font.Color := fontColor;
    lblMacro2.Font.Color := fontColor;
    lblMacro3.Font.Color := fontColor;
    loadingMacro := true;
    memoMacro.Text := '';
    tbSpeed.Position := DEFAULT_MACRO_SPEED;
    slPlaybackSpeed.Position := DEFAULT_MACRO_SPEED;
    tbMultiplay.Position := DEFAULT_MACRO_FREQ;
    slMacroMultiplay.Position := DEFAULT_MACRO_FREQ;
    loadingMacro := false;
  end;
end;

procedure TFormMainOld.KeyButtonClick(Sender: TObject);
begin
  SetActiveKeyButton(sender as TLabelBox);
end;

function TFormMainOld.CheckSaveKey(canSave: boolean): boolean;
var
  msgResult: integer;
begin
  result := true;

  if IsKeyLoaded and (MacroModified) then
  begin
    if (canSave) then
    begin
      msgResult := ShowDialog('Apply changes',
        'This macro has been modified, do you want to apply these changes?', mtConfirmation,
        [mbYes, mbNo, mbCancel], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
    if msgResult = mrYes then
      btnDoneMacro.Click
     else if msgResult = mrNo then
      btnCancelMacro.Click
    else
      result := false;
    end
    else
    begin
      ShowDialog('Macro', 'You must finish editing macro before proceeding', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
      result := false;
    end;
  end
  else if (KeyModified) then
    btnDoneKey.Click;

  //if IsKeyLoaded and MacroMode and MacroModified then
  //begin
  //  if (canSave) then
  //  begin
  //    msgResult := ShowDialog('Apply changes',
  //      'Macro editing in progress, apply changes?', mtConfirmation,
  //    [mbYes, mbNo, mbCancel], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
  //  if msgResult = mrYes then
  //    btnDoneMacro.Click
  //   else if msgResult = mrNo then
  //    btnCancelMacro.Click
  //  else
  //    result := false;
  //  end
  //  else
  //  begin
  //    ShowDialog('Macro', 'You must finish editing macro before proceeding', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
  //    result := false;
  //  end;
  //end;
end;

procedure TFormMainOld.SetActiveKeyButton(keyButton: TLabelBox);
begin
  if CheckSaveKey(true) then
  begin
    MacroModified := false;
    KeyModified := false;

    if IsKeyLoaded then
    begin
      //jm to check activeKeyBtn.Down := false;
      UpdateKeyButtonKey(activeKbKey, activeKeyBtn, true);
    end;

    if (keyButton = activeKeyBtn) or (keyButton = nil) then
    begin
      activeKeyBtn := nil;
      activeKbKey := nil;
    end
    else
    begin
      activeKbKey := keyService.GetKbKeyByIndex(activeLayer, keyButton.Index);
      if (activeKbKey <> nil) and (activeKbKey.CanEdit) then
      begin
        activeKeyBtn := keyButton;
        keyService.BackupKbKey(activeKbKey);
      end
      else if (activeKbKey <> nil) then
      begin
        activeKbKey := nil;
        ShowDialog('Select key', 'You cannot edit this key', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
      end;
    end;

    btnDoneKey.Enabled := IsKeyLoaded;
    btnCancelKey.Enabled := IsKeyLoaded;
    //jm btnSpecialActionsRemap.Enabled := IsKeyLoaded;
    btnResetKey.Enabled := IsKeyLoaded;

    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);

    SetMacroMode(IsKeyLoaded);
  end;
end;

procedure TFormMainOld.SetKeyButtonText(keybutton: TLabelBox; btnText: string);
begin
  keyButton.Caption := btnText;
end;

procedure TFormMainOld.SetSaveState(Value: TSaveState);
begin
  SaveState := Value;
  btnSave.Enabled := SaveState = ssModifed;
end;

//jm to remove
procedure TFormMainOld.SetEditMode(value: boolean);
begin
  //KeyModified := value;
  //btnCancelKey.Enabled := value;
  //btnDoneKey.Enabled := value;
  //btnCancelMacro.Enabled := value;
  //btnDoneMacro.Enabled := value;
end;

function TFormMainOld.LoadStateSettings: boolean;
var
  errorMsg: string;
  ledMode: string;
//const
//  TitleStateFile = 'Load State.txt File';
begin
  Result := False;
  loadingSettings := true;

  errorMsg := fileService.LoadStateSettings;

  if (errorMsg = '') then
  begin
    currentLayoutFile := GLayoutFilePath + fileService.StateSettings.StartupFile;
    tbStatusReport.Position := fileService.StateSettings.StatusPlaySpeed;
    slStatusReport.Position := fileService.StateSettings.StatusPlaySpeed;
    tbMacroSpeed.Position := fileService.StateSettings.MacroSpeed;
    slMacroSpeed.Position := fileService.StateSettings.MacroSpeed;
    swGameMode.Checked := fileService.StateSettings.GameMode;

    ledMode := AnsiUpperCase(fileService.StateSettings.LedMode);
    SetLedMode(ledMode);
    Result := true;
  end;
  //else
  //  ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);

  loadingSettings := false;
end;

procedure TFormMainOld.SaveStateSettings;
var
  errorMsg: string;
const
  TitleStateFile = 'Save State.txt File';
begin
  errorMsg := fileService.SaveStateSettings;

  if (errorMsg <> '') then
    ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
end;

function TFormMainOld.LoadVersionInfo: boolean;
var
  errorMsg: string;
begin
  Result := False;

  errorMsg := fileService.LoadVersionInfo;

  if (errorMsg = '') then
  begin
    if UpperCase(fileService.ModelName) = MODEL_NAME_FSPRO then
    begin
      GApplication := APPL_FSPRO;
    end
    else
    begin
      GApplication := APPL_FSEDGE;
    end;
    //firmware := fileService.FirmwareVersion;
    //idxThirdPoint := GetPosOfNthString(firmware, '.', 3) - 1;
    //if (idxThirdPoint < 0) then
    //  idxThirdPoint := Length(firmware);
    //eFirmware.Text := Copy(fileService.FirmwareVersion, 1, idxThirdPoint);
    Result := true;
  end;
end;

function TFormMainOld.LoadKeyboardLayout(layoutFile: string): boolean;
var
  errorMsg: string;
  idxNumber: integer;
const
  TitleStateFile = 'Load Layout File';
begin
  Result := False;

  errorMsg := fileService.LoadLayoutFile(layoutFile);

  keyService.LoadLayerList(LAYER_QWERTY);

  if (errorMsg = '') then
  begin
    activeLayer := nil;
    swLayerSwitch.Checked := true;
    layoutFile := ExtractFileNameWithoutExt(ExtractFileName(layoutFile));
    idxNumber := GetIndexOfNumber(layoutFile);
    if (idxNumber >= 1) then
      layoutFile := Copy(layoutFile, 1, idxNumber - 1) + ' ' + Copy(layoutFile, idxNumber, Length(layoutFile));
    lblLayoutFile.Caption := UpperCase(Copy(layoutFile, 1, 1)) + Copy(layoutFile, 2, Length(layoutFile));
    keyService.ConvertFromTextFileFmtFS(fileService.LayoutContent);
    SetActiveLayer(TOPLAYER_IDX);
    SetActiveKeyButton(nil);
    RefreshRemapInfo;
    Result := true;
  end
  else
    ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
end;

function TFormMainOld.CheckToSave: boolean;
var
  dialogResult: integer;
begin
  result := true;
  if SaveState = ssModifed then
  begin
    dialogResult := ShowDialog('Save',
      'Do you want to save changes?',
      mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, backColor, fontColor);

    if dialogResult = mrYes then
      btnSave.Click
    else if dialogResult = mrNo then
      SetSaveState(ssNone)
    else
      result := false;
  end;
end;

function TFormMainOld.Save(isNew: boolean = false; showSaveDialog: boolean = true): boolean;
var
  errorMsg: string;
  layoutContent: TStringList;
  fileName: string;
  hideNotif: integer;
  idxNumber: integer;
  layoutNumber: string;
  isCustomLayout: boolean;
  diagMessage: string;
  diagTitle: string;
begin
  result := false;
  errorMsg := '';

  if (CheckSaveKey(true)) then
  begin
    layoutContent := keyService.ConvertToTextFileFmtFS;
    if fileService.SaveFile(currentLayoutFile, layoutContent, isNew, errorMsg) then
    begin
      if (not fileService.AppSettings.SaveMsg) and (showSaveDialog) then
      begin
        fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLayoutFile));
        idxNumber := GetIndexOfNumber(fileName);
        if (idxNumber >= 1) then
          layoutNumber := Copy(fileName, idxNumber, Length(fileName));
        isCustomLayout := LowerCase(Copy(fileName, 1, Length(FS_FILENAME))) <> FS_FILENAME;
        if (isCustomLayout) then
        begin
          diagMessage := 'This custom layout has been saved as ' + filename + '. To load this layout to the keyboard it must first be assigned to position 1-9 using the Save As button.';
          diagTitle := 'Backup Layout & Settings Saved';
        end
        else
        begin
          diagMessage := 'Your changes have been saved to Layout ' + layoutNumber + '. To implement your changes use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive (SmartSet + F8).';
          diagTitle := 'Layout & Settings Saved';
        end;
        hideNotif := ShowDialog(diagTitle, diagMessage,
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetSaveMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
      SetSaveState(ssNone);
      result := true;
    end
    else
      ShowDialog('Save', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
        mtError, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);

    SaveStateSettings;
  end;
end;

procedure TFormMainOld.SaveAs(isNew: boolean = false);
var
  fileName: string;
  isBackupFile: boolean;
  layoutPosition: string;
begin
  NeedInput := True;
  fileName := ShowSaveAs(backColor, fontColor, isBackupFile, layoutPosition);
  if (fileName <> '') then
  begin
    //ShowDialog('Save', 'To access this layout it must first be saved as one of the nine numbered layouts. Load your new layout by holding the SmartSet key and tapping the corresponding number.',
    //      mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
    //SaveDialog.InitialDir := GLayoutFilePath;
    //SaveDialog.FileName := 'layout.txt';
    //if SaveDialog.Execute then
    //begin
      if (isNew) then
        keyService.ResetLayout;
      currentLayoutFile := GLayoutFilePath + fileName; //SaveDialog.FileName;
      Save(true, false);
      LoadKeyboardLayout(currentLayoutFile);

      filename := ExtractFileNameWithoutExt(ExtractFileName(fileName));
      if (isBackupFile) then
        ShowDialog('Backup Layout & Settings Saved', 'This custom layout has been saved as ' + filename + '. To load this layout to the keyboard it must first be assigned to position 1-9 using the Save As button.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor)
      else
        ShowDialog('Layout & Settings Saved', 'This custom layout has been saved to Layout ' + layoutPosition + '. To implement your changes use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive (SmartSet + F8). To load this layout to the keyboard press SmartSet + ' + layoutPosition + '.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor);
    //end;
  end;
  NeedInput := False;
end;

procedure TFormMainOld.LoadLayer(layer: TKBLayer);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  if (layer <> nil) then
  begin
    SetActiveKeyButton(nil);
    for i := 0 to layer.KBKeyList.Count - 1 do
    begin
      aKbKey := layer.KBKeyList[i];
      keyButton := GetKeyButtonByIndex(aKbKey.Index);
      UpdateKeyButtonKey(aKbKey, keyButton);
    end;
  end;
end;

function TFormMainOld.GetKeyButtonByIndex(index: integer): TLabelBox;
var
  i: integer;
  keyButton: TLabelBox;
  found: boolean;
begin
  i := 0;
  result := nil;
  found := false;
  While (i < keyBtnList.Count) and (not found) do
  begin
    if (keyBtnList[i] is TLabelBox) then
    begin
      keyButton := (keyBtnList[i] as TLabelBox);
      if (keyButton.Index = index) then
      begin
        result := keyButton;
        found := true;
      end;
    end;
    inc(i);
  end;
end;

function TFormMainOld.GetCursorNextKey(cursorPos: integer): integer;
var
  i:integer;
  keyIdx: integer;
  newKeyIdx: integer;
begin
  result := -1;
  if (IsKeyLoaded and (cursorPos < LengthUTF8(memoMacro.Text))) then
  begin
    keyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, cursorPos);
    for i := cursorPos + 1 to LengthUTF8(memoMacro.Text) do
    begin
      newKeyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, i);
      if (keyIdx <> newKeyIdx) then
      begin
        result := i - 1;
        break;
      end;
    end;
  end;
end;

function TFormMainOld.GetCursorPrevKey(cursorPos: integer): integer;
var
  i:integer;
  keyIdx: integer;
  prevKeyIdx: integer;
begin
  result := -1; //cursorPos - 1;
  if (IsKeyLoaded and (cursorPos > 1)) then
  begin
    keyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, cursorPos);
    for i := cursorPos - 1 downto 0 do
    begin
      prevKeyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, i);
      if (keyIdx <> prevKeyIdx) then
      begin
        result := i;
        break;
      end;
    end;
  end;
end;

procedure TFormMainOld.SetModifiedKey(key: word; Modifiers: string; isMacro: boolean; bothLayers: boolean = false);
var
  aKbKeyOtherLayer: TKBKey;
  cursorPos: integer;
  cursorNext: integer;
  keyIdx: integer;
  isDiffKey: boolean;
  lastPos: boolean;
  keyAdded: TKey;
  textKey: string;
  isLongKey: boolean;
  macroText: string;
  aKeysPos: TKeysPos;
  nbKeystrokes: integer;
begin
  if IsKeyLoaded then
  begin
    if (isMacro) then
    begin
      nbKeystrokes := keyService.CountKeystrokes(activeKbKey.ActiveMacro);
      inc(nbKeystrokes);
      nbKeystrokes := nbKeystrokes + (keyService.CountModifiers(Modifiers) * 2);
      if (nbKeystrokes > MAX_KEYSTROKES_FS) then
        ShowDialog('Maximum Length Reached', 'Macros are limited to approximately 300 characters.',
          mtError, [mbOK], DEFAULT_DIAG_HEIGHT, backColor, fontColor)
      else
      begin
        //First keystroke in macro assign 1 to multiplay position
        if (nbKeystrokes = 1) then
        begin
          tbMultiplay.Position := 1;
          slMacroMultiplay.Position := 1;
        end;
        activeKbKey.IsMacro := true;
        cursorPos := memoMacro.SelStart;
        cursorNext := GetCursorNextKey(cursorPos);
        lastPos := (cursorPos >= LengthUTF8(memoMacro.Text));
        if (cursorNext <> -1) and (cursorPos <> 0) then
          keyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, cursorNext + 1)
        else
          keyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, cursorPos + 1);
        keyAdded := keyService.AddKey(activeKbKey, key, Modifiers, keyIdx);
        if (keyAdded <> nil) then
        begin
          textKey := keyService.GetSingleKeyText(keyAdded, isLongKey);
          textKey := StringReplace(textKey, ' ', AnsiToUtf8(#$e2#$90#$a3), [rfReplaceAll]);
          MacroModified := true;

          //Insert key in memo
          if (cursorPos <> 0) then
          begin
            if (lastPos) then
              cursorPos := LengthUTF8(memoMacro.Text)
            else
            begin
              cursorPos := cursorNext;

              //Must insert at end
              if (cursorPos = -1) then
              begin
                cursorPos := LengthUTF8(memoMacro.Text);
                lastPos := true;
              end;
            end;
          end;
          memoMacro.SelStart := cursorPos;
          memoMacro.SelText := textKey;
          memoMacro.SelLength := 0;

          //Set cursor at end if inserted at the end
          if (lastPos) then
            memoMacro.SelStart := LengthUTF8(memoMacro.Text)
          else //Set cursor + length text otherwise
            memoMacro.SelStart := memoMacro.SelStart + LengthUTF8(textKey);

          //Color key text if is long key
          if (isLongKey) then
            memoMacro.SetRangeColor(cursorPos, LengthUTF8(textKey), clRed)
          else
            memoMacro.SetRangeColor(cursorPos, LengthUTF8(textKey), clDefault);

          textMacroInput.Visible := activeKbKey.ActiveMacro.Count = 0;
        end;
      end;
    end
    else if (not MacroModified) then
    begin
      isDiffKey := (activeKbKey.IsModified and (activeKbKey.ModifiedKey.Key <> key)) or
        ((not activeKbKey.IsModified) and (activeKbKey.OriginalKey.Key <> key));

      //Checks if key is really modified
      if (isDiffKey) then
      begin
        KeyModified := true;
        SetEditMode(true);
        SetSaveState(ssModifed);
        keyService.SetKBKey(activeKbKey, key);
        if (bothLayers) then
        begin
          aKbKeyOtherLayer := GetKeyOtherLayer(activeKeyBtn.Index);
          if aKbKeyOtherLayer <> nil then
            keyService.SetKBKey(aKbKeyOtherLayer, key);
        end;
        UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
      end;
    end;
  end;
end;

procedure TFormMainOld.SetMacroText(pushCursorToEnd: boolean; cursorPos: integer = -1);
var
  aKeysPos: TKeysPos;
begin
  if (IsKeyLoaded) and (activeKbKey.IsMacro) then
  begin
    //Disable visual effects on Macro before assigning text
    {$ifdef Win64}
    SendMessage(memoMacro.Handle, WM_SETREDRAW, WPARAM(False), 0);
    {$endif}
    {$ifdef Darwin}
    //jm todo SendMessage(memoMacro.Handle, LM_SETREDRAW, WPARAM(False), 0);
    {$endif}

    memoMacro.Text := keyService.GetMacroText(activeKbKey.ActiveMacro, aKeysPos);

    //Replace empty space with special space character
    memoMacro.Text := StringReplace(memoMacro.Text, ' ', AnsiToUtf8(#$e2#$90#$a3), [rfReplaceAll]);
    SetMemoTextColor(memoMacro, aKeysPos);

    //To show the cursor at the end
    if pushCursorToEnd then
    begin
      memoMacro.SelStart := Length(memoMacro.Text);
    end
    else if (cursorPos <> -1) then
    begin
      cursorPos := GetCursorNextKey(cursorPos);
      memoMacro.SelStart := cursorPos;
    end;

    textMacroInput.Visible := activeKbKey.ActiveMacro.Count = 0;
    //{$ifdef Darwin}  //MacOS
    //memoConfig.SetFocus;
    //{$endif}

    //Enable visual effects on Macro after assigning text
    {$ifdef Win64}
    SendMessage(memoMacro.Handle, WM_SETREDRAW, WPARAM(True), 0);
    {$endif}
    {$ifdef Darwin}
    //jm todo SendMessage(memoMacro.Handle, LM_SETREDRAW, WPARAM(True), 0);
    {$endif}

    memoMacro.Repaint;
  end;
end;

//procedure TFormMainOld.AddKeyToMacro(key: word; Modifiers: string);
//var
//  aKeysPos: TKeysPos;
//  tmpKeyPos: integer;
//  cursorPos: integer;
//  keyText: string;
//  isLongKey: boolean;
//    keyIdx: integer;
//  isDiffKey: boolean;
//  lastPos: boolean;
//  keyAdded: TKey;
//begin
//  if (IsKeyLoaded) and (activeKbKey.IsMacro) then
//  begin
//    cursorPos := memoMacro.SelStart;
//    lastPos := (cursorPos >= LengthUTF8(memoMacro.Text));
//    keyIdx := keyService.GetKeyAtPosition(activeKbKey.ActiveMacro, cursorPos);
//    keyAdded := keyService.AddKey(activeKbKey, key, Modifiers, keyIdx);
//    if (keyAdded <> nil) then
//    begin
//      MacroModified := true;
//      keyText := keyService.GetSingleKeyText(keyAdded, isLongKey);
//
//      keyText := StringReplace(keyText, ' ', AnsiToUtf8(#$e2#$90#$a3), [rfReplaceAll]);
//      memoMacro.Lines.Insert(cursorPos, keyText);
//
//      if (lastPos) then
//        memoMacro.SelStart := Length(memoMacro.Text)
//      else if (cursorPos <> -1) then
//      begin
//        cursorPos := GetCursorNextKey(cursorPos);
//        memoMacro.SelStart := cursorPos;
//      end;
//      //SetMacroText(lastPos, cursorPos + 1);
//    end;
//
//    textMacroInput.Visible := activeKbKey.ActiveMacro.Count = 0;
//    {$ifdef Darwin}  //MacOS
//    memoConfig.SetFocus;
//    {$endif}
//  end;
//end;

//Load macro from key
procedure TFormMainOld.LoadMacro;
begin
  loadingMacro := true;
  ResetMacroCoTriggers;
  lastKeyDown := 0; //Resets last key down
  lastKeyPressed := 0; //Resets last key pressed
  keyService.ClearModifiers; //Removes all modifiers from memory

  if (IsKeyLoaded) then //and (activeKbKey.IsMacro) then
  begin
    if (rgMacro1.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro1
    else if (rgMacro2.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro2
    else if (rgMacro3.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro3;

    if (activeKbKey.ActiveMacro.MacroSpeed >= MACRO_SPEED_MIN) and (activeKbKey.ActiveMacro.MacroSpeed <= MACRO_SPEED_MAX) then
    begin
      tbSpeed.Position := activeKbKey.ActiveMacro.MacroSpeed;
      slPlaybackSpeed.Position := activeKbKey.ActiveMacro.MacroSpeed
    end
    else
    begin
      tbSpeed.Position := DEFAULT_MACRO_SPEED;
      slPlaybackSpeed.Position := DEFAULT_MACRO_SPEED;
    end;

    if (activeKbKey.ActiveMacro.MacroRptFreq >= MACRO_FREQ_MIN) and (activeKbKey.ActiveMacro.MacroRptFreq <= MACRO_FREQ_MAX) then
    begin
      tbMultiplay.Position := activeKbKey.ActiveMacro.MacroRptFreq;
      slMacroMultiplay.Position := activeKbKey.ActiveMacro.MacroRptFreq
    end
    else
    begin
      tbMultiplay.Position := DEFAULT_MACRO_FREQ;
      slMacroMultiplay.Position := DEFAULT_MACRO_FREQ;
    end;

    if activeKbKey.Macro1.Count > 0 then
      lblMacro1.Font.Color := blueColor
    else
      lblMacro1.Font.Color := fontColor;
    if activeKbKey.Macro2.Count > 0 then
      lblMacro2.Font.Color := blueColor
    else
      lblMacro2.Font.Color := fontColor;
    if activeKbKey.Macro3.Count > 0 then
      lblMacro3.Font.Color := blueColor
    else
      lblMacro3.Font.Color := fontColor;

    SetCoTrigger(activeKbKey.ActiveMacro.CoTrigger1);
  end;
  loadingMacro := false;
end;

procedure TFormMainOld.SetCoTrigger(aKey: TKey);
begin
  if (aKey <> nil) then
  begin
    if (aKey.Key = VK_LSHIFT) then
      ActivateCoTrigger(bLShiftMacro);
    if (aKey.Key = VK_LCONTROL) then
      ActivateCoTrigger(bLCtrlMacro);
    if (aKey.Key = VK_LMENU) then
      ActivateCoTrigger(bLAltMacro);
    if (aKey.Key = VK_RSHIFT) then
      ActivateCoTrigger(bRShiftMacro);
    if (aKey.Key = VK_RCONTROL) then
      ActivateCoTrigger(bRCtrlMacro);
    if (aKey.Key = VK_RMENU) then
      ActivateCoTrigger(bRAltMacro);
  end;
end;

function TFormMainOld.IsKeyLoaded: boolean;
begin
  result := (activeKeyBtn <> nil) and (activeKbKey <> nil);
end;

//Resets co-trigger buttons to default values
procedure TFormMainOld.ResetMacroCoTriggers;
begin
  ResetCoTrigger(bLShiftMacro);
  ResetCoTrigger(bLCtrlMacro);
  ResetCoTrigger(bLAltMacro);
  ResetCoTrigger(bRShiftMacro);
  ResetCoTrigger(bRCtrlMacro);
  ResetCoTrigger(bRAltMacro);
end;

procedure TFormMainOld.ActivateCoTrigger(coTriggerBtn: THSSpeedButton);
begin
  coTriggerBtn.Down := true;
  coTriggerBtn.Font.Bold := true;
  coTriggerBtn.Font.Color := blueColor;
end;

procedure TFormMainOld.ResetCoTrigger(coTriggerBtn: THSSpeedButton);
begin
  coTriggerBtn.Down := false;
  coTriggerBtn.Font.Bold := true;
  if (GApplication = APPL_FSPRO) then
    coTriggerBtn.Font.Color := KINESIS_DARK_GRAY_FS
  else
    coTriggerBtn.Font.Color := clBlack;
end;

procedure TFormMainOld.SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
var
  i: integer;
begin
  //Reset to default color before setting red (MacOS bug)
  aMemo.SetRangeColor(0, Length(aMemo.Text), clDefault);

  if (aKeysPos <> nil) then
  begin
    for i := 0 to Length(aKeysPos) - 1 do
      aMemo.SetRangeColor(aKeysPos[i].iStart, aKeysPos[i].iEnd - aKeysPos[i].iStart, clRed);
  end;
end;

procedure TFormMainOld.SetActiveLayer(layerIdx: integer);
begin
  activeLayer := keyService.GetLayer(layerIdx);
  LoadLayer(activeLayer);
end;

procedure TFormMainOld.UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox; unselectKey: boolean = false);
var
  fontSize:integer;
  fontName: string;
begin
  fontSize := 0;
  fontName := '';

  if (kbKey <> nil) and (keyButton <> nil) then
  begin
    if (kbKey.IsModified) and (not kbKey.IsMacro) then
    begin
      keyButton.Caption := kbKey.ModifiedKey.DisplayText;
      fontSize := kbKey.ModifiedKey.DisplaySize;
      fontName := kbKey.ModifiedKey.FontName;
      keyButton.BorderStyle := bsNone;
      keyButton.Font.Color := blueColor;
      keyButton.BorderWidth := 1;
      keyButton.CornerSize := 10;
    end
    else if (not kbKey.IsModified) and (kbKey.IsMacro) then
    begin
      keyButton.Caption := kbKey.OriginalKey.DisplayText;
      fontSize := kbKey.OriginalKey.DisplaySize;
      fontName := kbKey.OriginalKey.FontName;
      keyButton.BorderColor := blueColor;
      keyButton.BorderStyle := bsSingle;
      keyButton.Font.Color := clWhite;
      if (kbKey.MacroCount > 1) then
      begin
        keyButton.BorderWidth := 3;
        keyButton.CornerSize := 16;
      end
      else
      begin
        keyButton.BorderWidth := 1;
        keyButton.CornerSize := 10;
      end;
    end
    else if (kbKey.IsModified) and (kbKey.IsMacro) then
    begin
      keyButton.Caption := kbKey.ModifiedKey.DisplayText;
      fontSize := kbKey.ModifiedKey.DisplaySize;
      fontName := kbKey.ModifiedKey.FontName;
      keyButton.BorderColor := blueColor;
      keyButton.BorderStyle := bsSingle;
      keyButton.BorderWidth := 1;
      keyButton.CornerSize := 10;
      keyButton.Font.Color := blueColor;
      if (kbKey.MacroCount > 1) then
      begin
        keyButton.BorderWidth := 3;
        keyButton.CornerSize := 16;
      end
      else
      begin
        keyButton.BorderWidth := 1;
        keyButton.CornerSize := 10;
      end;
    end
    else
    begin
      keyButton.Caption := kbKey.OriginalKey.DisplayText;
      fontSize := kbKey.OriginalKey.DisplaySize;
      fontName := kbKey.OriginalKey.FontName;
      keyButton.BorderStyle := bsNone;
      keyButton.Font.Color := clWhite;
      keyButton.BorderWidth := 1;
      keyButton.CornerSize := 10;
    end;

    if (keyButton = activeKeyBtn) and not(unselectKey) then
    begin
        keyButton.BorderColor := clWhite;
        keyButton.BorderStyle := bsSingle;
    end;

    if (fontSize > 0) then
      keyButton.Font.Size := fontSize
    else
      keyButton.Font.Size := defaultKeyFontSize;

    if (fontName <> '') then
      keyButton.Font.Name := fontName
    else
      keyButton.Font.Name := defaultKeyFontName;

    if (keyButton.Font.Name = UNICODE_FONT) then
      keyButton.Font.Bold := false;

    keyButton.Repaint;
  end;
end;

procedure TFormMainOld.InitKeyButtons(container: TWinControl);
var
  i: integer;
  keyButton: TLabelBox;
begin
  for i := 0 to container.ControlCount - 1 do
  begin
    if (container.Controls[i] is TLabelBox) then
    begin
      keyButton := (container.Controls[i] as TLabelBox);
      if (keyButton.Index >= 0) then
      begin
        keyButton.BorderStyle := bsNone;
        keyButton.Caption := '';
        keyButton.Font.Name := defaultKeyFontName;
        keyButton.Font.Size := defaultKeyFontSize;
        keyButton.OnClick := @KeyButtonClick;
        keyButton.OnMouseDown := @KeyButtonMouseDown;
        keyButton.Hint := 'Select a key to begin programming';
        keyButton.ShowHint := true;
        keyBtnList.Add(keyButton);
      end;
    end
    else if (container.Controls[i] is TPanel) then
      InitKeyButtons(container.Controls[i] as TPanel);
  end;
end;

end.

