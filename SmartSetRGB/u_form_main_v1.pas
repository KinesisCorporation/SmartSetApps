unit u_form_main;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
    lcltype, Menus, ExtCtrls, Buttons, lclintf, u_const, u_key_service,
    u_key_layer, u_file_service, LabelBox, LineObj, RichMemo,
    uGifViewer, ueled, uEKnob, HSLRingPicker,
    mbColorPreview, HRingPicker, ECSwitch, HSSpeedButton, u_keys, userdialog,
    contnrs, u_form_about, LazUTF8, u_form_saveas, u_form_load,
    u_form_settings, AnimatedGif, MemBitmap, LResources, BGRABitmap, BGRABitmapTypes,
    u_form_timingdelays, u_form_intro
    {$ifdef Win64},Windows{$endif};

type

  { TMenuAction }

  TMenuAction = class
  private
    FName: string;
    FActionButton: THSSpeedButton;
    FActionLabel: TLabel;
    FMenuConfig: integer;
    FPopupMenu: boolean;
  protected
  public
    constructor Create(actionButton: THSSpeedButton; actionLabel: TLabel;
      menuConfig: integer; popupMenu: boolean);
    property Name: string read FName write FName;
    property ActionButton: THSSpeedButton read FActionButton write FActionButton;
    property ActionLabel: TLabel read FActionLabel write FActionLabel;
    property MenuConfig: integer read FMenuConfig write FMenuConfig;
    property PopupMenu: boolean read FPopupMenu write FPopupMenu;
  end;

  //TActionList = class(TObjectList)
  //private
  //  FName: string;
  //  FActionButton: THSSpeedButton;
  //  FActionLabel: TLabel;
  //protected
  //public
  //  property Name: string read FName write FName;
  //  property ActionButton: THSSpeedButton read FActionButton write FActionButton;
  //  property ActionLabel: TLabel read FActionLabel write FActionLabel;
  //end;

  { TFormMain }
  TFormMain = class(TForm)
    btnWASDZone: THSSpeedButton;
    btnGameZone: THSSpeedButton;
    btnNumberZone: THSSpeedButton;
    btnCancelMacro: THSSpeedButton;
    btnCloseMacro: THSSpeedButton;
    btnCommonShortcuts: THSSpeedButton;
    btnCopy: THSSpeedButton;
    btnDoneMacro: THSSpeedButton;
    btnAllZone: THSSpeedButton;
    btnLeftAlt: THSSpeedButton;
    btnLeftCtrl: THSSpeedButton;
    btnLeftShift: THSSpeedButton;
    btnMouseClicksMacro: THSSpeedButton;
    btnFunctionZone: THSSpeedButton;
    btnArrowZone: THSSpeedButton;
    btnPaste: THSSpeedButton;
    btnPitchBlack: THSSpeedButton;
    btnReactive: THSSpeedButton;
    btnClearMacro: THSSpeedButton;
    btnBackspaceMacro: THSSpeedButton;
    btnStarlight: THSSpeedButton;
    btnRebound: THSSpeedButton;
    btnRipple: THSSpeedButton;
    btnRGBWave: THSSpeedButton;
    btnIndividual: THSSpeedButton;
    btnBreathe: THSSpeedButton;
    btnMonochrome: THSSpeedButton;
    btnRGBSpectrum: THSSpeedButton;
    btnRightAlt: THSSpeedButton;
    btnRightCtrl: THSSpeedButton;
    btnRightShift: THSSpeedButton;
    btnSettings: THSSpeedButton;
    btnDone: THSSpeedButton;
    btnResetKey: THSSpeedButton;
    btnResetAll: THSSpeedButton;
    btnClose: THSSpeedButton;
    btnLEDControl: THSSpeedButton;
    btnHelpIcon: THSSpeedButton;
    btnCancel: THSSpeedButton;
    btnMaximize: THSSpeedButton;
    btnMacro: THSSpeedButton;
    btnMouseClicks: THSSpeedButton;
    btnAltLayouts: THSSpeedButton;
    btnDisableKey: THSSpeedButton;
    btnFunctionKeys: THSSpeedButton;
    btnNumericKeypad: THSSpeedButton;
    btnFunctionAccess: THSSpeedButton;
    btnRemap: THSSpeedButton;
    btnMinimize: THSSpeedButton;
    btnLoadLayout: THSSpeedButton;
    btnLighting: THSSpeedButton;
    btnSaveLayout: THSSpeedButton;
    btnSaveAsLayout: THSSpeedButton;
    btnSaveAsLighting: THSSpeedButton;
    btnSaveLighting: THSSpeedButton;
    btnLoadLighting: THSSpeedButton;
    btnLayout: THSSpeedButton;
    btnMedia: THSSpeedButton;
    btnTimingDelays: THSSpeedButton;
    btnWindowsCombos: THSSpeedButton;
    ColorDialog1: TColorDialog;
    imgListLoadSave: TImageList;
    imageMacro: TImage;
    imgBackMacro: TImage;
    imageKnobBig: TImage;
    imgZone: TImage;
    imgZonePanel: TImage;
    kbLeftAlt: TLabelBox;
    kbLeftCtrl: TLabelBox;
    kbLeftShift: TLabelBox;
    kbRightAlt: TLabelBox;
    kbRightCtrl: TLabelBox;
    kbRightShift: TLabelBox;
    knobMultiplay: TuEKnob;
    knobMacroSpeed: TuEKnob;
    lblZone: TLabel;
    lblVDriveOk: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblMacroEditor: TLabel;
    lblDisable: TLabel;
    lblDisplaying: TStaticText;
    lblGlobal: TLabel;
    lblMacro1: TLabel;
    lblMacro2: TLabel;
    lblMacro3: TLabel;
    lblMacroMultiplay: TStaticText;
    lblMultiplayText: TLabel;
    lblPlaybackSpeed: TStaticText;
    lblMacroSpeedText: TLabel;
    lblStarlight: TLabel;
    lblRebound: TLabel;
    lblRipple: TLabel;
    lblVDriveError: TLabel;
    lbMenuMacro: TListBox;
    ledWindowsCombo: TuELED;
    ledMultiplay: TuELED;
    ledMacroSpeed: TuELED;
    lineBorderBottomMacro: TLineObj;
    lineBorderLeftMacro: TLineObj;
    lineBorderRightMacro: TLineObj;
    lineBorderTopMacro: TLineObj;
    CheckVDriveTmr: TIdleTimer;
    memoMacro: TRichMemo;
    pnlMacro: TPanel;
    pnlMenuMacro: TPanel;
    preMixedColor1: TmbColorPreview;
    preMixedColor5: TmbColorPreview;
    custColor2: TmbColorPreview;
    custColor3: TmbColorPreview;
    custColor6: TmbColorPreview;
    custColor5: TmbColorPreview;
    custColor4: TmbColorPreview;
    custColor1: TmbColorPreview;
    preMixedColor6: TmbColorPreview;
    preMixedColor2: TmbColorPreview;
    preMixedColor7: TmbColorPreview;
    preMixedColor9: TmbColorPreview;
    preMixedColor8: TmbColorPreview;
    preMixedColor4: TmbColorPreview;
    preMixedColor10: TmbColorPreview;
    preMixedColor3: TmbColorPreview;
    eHTML: TEdit;
    eRed: TEdit;
    eGreen: TEdit;
    eBlue: TEdit;
    gbButtons: TGroupBox;
    GifIdleTimer: TIdleTimer;
    gifViewer: TGIFViewer;
    miAddCustColor: TMenuItem;
    pmColorPreview: TPopupMenu;
    rgMacro1: TRadioButton;
    rgMacro2: TRadioButton;
    rgMacro3: TRadioButton;
    ringPicker: THSLRingPicker;
    imgKeyboardBack: TImage;
    imgKeyboardLighting: TImage;
    lblPreMixedColors: TLabel;
    lblCustomColors: TLabel;
    lblRColor: TLabel;
    lblGColor: TLabel;
    lblBColor: TLabel;
    colorPreview: TmbColorPreview;
    paintBoxGif: TPaintBox;
    StaticText3: TStaticText;
    textMacroInput: TStaticText;
    WaveTimer: TIdleTimer;
    imageKnob: TImage;
    imgColor: TImage;
    imageListKB: TImageList;
    imgKeyboardLayout: TImage;
    imgBackground: TImage;
    imgDirection: TImage;
    imgSpeed: TImage;
    imgDirectionPanel: TImage;
    imgRange: TImage;
    imgSpeedPanel: TImage;
    imgLeftMenuLighting: TImage;
    imgColorPanel: TImage;
    imgLogo: TImage;
    Image5: TImage;
    imageList: TImageList;
    imgLeftMenu: TImage;
    imgLogoFSEdge: TImage;
    imgRangePanel: TImage;
    knobDirection: TuEKnob;
    knobSpeed: TuEKnob;
    knobRange: TuEKnob;
    lbRow8_1: TLabelBox;
    lbRow9_1: TLabelBox;
    lbRow9_2: TLabelBox;
    lbRow10_1: TLabelBox;
    lbRow11_1: TLabelBox;
    lbRow12_1: TLabelBox;
    lbRow13_1: TLabelBox;
    lbRow13_2: TLabelBox;
    lbRow14_1: TLabelBox;
    lbRow3_2: TLabelBox;
    lbRow1_1: TLabelBox;
    lbRow4_3: TLabelBox;
    lbRow4_4: TLabelBox;
    lbRow5_2: TLabelBox;
    lbRow6_3: TLabelBox;
    lbRow6_4: TLabelBox;
    lbRow7_2: TLabelBox;
    lbRow8_2: TLabelBox;
    lbRow9_3: TLabelBox;
    lbRow9_4: TLabelBox;
    lbRow10_2: TLabelBox;
    lbRow3_1: TLabelBox;
    lbRow11_2: TLabelBox;
    lbRow12_2: TLabelBox;
    lbRow13_3: TLabelBox;
    lbRow4_6: TLabelBox;
    lbRow5_4: TLabelBox;
    lbRow6_7: TLabelBox;
    lbRow6_8: TLabelBox;
    lbRow7_4: TLabelBox;
    lbRow1_3: TLabelBox;
    lbRow2_2: TLabelBox;
    lbRow4_1: TLabelBox;
    lbRow8_3: TLabelBox;
    lbRow8_4: TLabelBox;
    lbRow9_5: TLabelBox;
    lbRow9_6: TLabelBox;
    lbRow10_3: TLabelBox;
    lbRow11_3: TLabelBox;
    lbRow12_3: TLabelBox;
    lbRow1_4: TLabelBox;
    lbRow2_3: TLabelBox;
    lbRow4_5: TLabelBox;
    lbRow4_2: TLabelBox;
    lbRow5_3: TLabelBox;
    lbRow6_5: TLabelBox;
    lbRow6_6: TLabelBox;
    lbRow7_3: TLabelBox;
    lbRow8_5: TLabelBox;
    lbRow9_7: TLabelBox;
    lbRow9_8: TLabelBox;
    lbRow10_4: TLabelBox;
    lbRow11_4: TLabelBox;
    lbRow11_5: TLabelBox;
    lbRow5_1: TLabelBox;
    lbRow12_4: TLabelBox;
    lbRow1_5: TLabelBox;
    lbRow2_4: TLabelBox;
    lbRow4_7: TLabelBox;
    lbRow5_5: TLabelBox;
    lbRow6_9: TLabelBox;
    lbRow6_10: TLabelBox;
    lbRow7_5: TLabelBox;
    lbRow1_6: TLabelBox;
    lbRow2_5: TLabelBox;
    lbRow6_1: TLabelBox;
    lbRow3_6: TLabelBox;
    lbRow8_6: TLabelBox;
    lbRow9_9: TLabelBox;
    lbRow9_10: TLabelBox;
    lbRow10_5: TLabelBox;
    lbRow11_6: TLabelBox;
    lbRow12_5: TLabelBox;
    lbRow13_5: TLabelBox;
    lbRow8_7: TLabelBox;
    lbRow10_6: TLabelBox;
    lbRow6_2: TLabelBox;
    lbRow14_5: TLabelBox;
    lbRow11_7: TLabelBox;
    lbRow12_6: TLabelBox;
    lbRow13_6: TLabelBox;
    lbRow14_6: TLabelBox;
    lbRow1_2: TLabelBox;
    lbRow2_1: TLabelBox;
    lbRow14_2: TLabelBox;
    lbRow3_4: TLabelBox;
    lbRow7_1: TLabelBox;
    lbRow3_3: TLabelBox;
    lbRow3_5: TLabelBox;
    lbRow4_8: TLabelBox;
    lbRow5_6: TLabelBox;
    lbRow6_11: TLabelBox;
    lbRow13_4: TLabelBox;
    lbRow14_3: TLabelBox;
    lbRow14_4: TLabelBox;
    lblColor: TLabel;
    lblDirection: TLabel;
    lblSpeed: TLabel;
    lblRange: TLabel;
    lblSpeedText: TLabel;
    lblPitchBlack: TLabel;
    lblReactive: TLabel;
    lblRGBWave: TLabel;
    lblLightingModes: TLabel;
    lblLayout: TLabel;
    lblActions1: TLabel;
    lblLighting: TLabel;
    lblLedControl: TLabel;
    lblBreathe: TLabel;
    lblMonochrome: TLabel;
    lblMedia: TLabel;
    lblMacro: TLabel;
    lblMouseClicks: TLabel;
    lblAltLayouts: TLabel;
    lblDisableKey: TLabel;
    lblFunctionKeys: TLabel;
    lblRGBSpectrum: TLabel;
    lblNumericKeypad: TLabel;
    lblFunctionAccess: TLabel;
    lblRemap: TLabel;
    lblIndividual: TLabel;
    lblDirectionText: TLabel;
    lblRangeText: TLabel;
    lblTitle: TLabel;
    lblActions: TLabel;
    lblDebugMode: TLabel;
    lbMenu: TListBox;
    ledDirection: TuELED;
    ledSpeed: TuELED;
    ledRange: TuELED;
    pnlMenu: TPanel;
    lineBorderTop: TLineObj;
    lineBorderBottom: TLineObj;
    lineBorderLeft: TLineObj;
    lineBorderRight: TLineObj;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    miBtn4Mouse: TMenuItem;
    miBtn5Mouse: TMenuItem;
    miCalculator: TMenuItem;
    miColemak: TMenuItem;
    miDvorak: TMenuItem;
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
    miFnKey: TMenuItem;
    miFnShift: TMenuItem;
    miFnToggle: TMenuItem;
    miFullLeftSide: TMenuItem;
    miFullRightSide: TMenuItem;
    miFunctionKeys: TMenuItem;
    miIntlKey: TMenuItem;
    miLed: TMenuItem;
    miLeftMouse: TMenuItem;
    miMenu: TMenuItem;
    miMicMute: TMenuItem;
    miMiddleMouse: TMenuItem;
    miMouseActions: TMenuItem;
    miMultimedia: TMenuItem;
    miMute: TMenuItem;
    miNextTrack: TMenuItem;
    miNull: TMenuItem;
    miNum0: TMenuItem;
    miNum1: TMenuItem;
    miNum2: TMenuItem;
    miNum3: TMenuItem;
    miNum4: TMenuItem;
    miNum5: TMenuItem;
    miNum6: TMenuItem;
    miNum7: TMenuItem;
    miNum8: TMenuItem;
    miNum9: TMenuItem;
    miNumDec: TMenuItem;
    miNumDivide: TMenuItem;
    miNumEnter: TMenuItem;
    miNumericKeypad: TMenuItem;
    miNumLock: TMenuItem;
    miNumMinus: TMenuItem;
    miNumMultiply: TMenuItem;
    miNumPlus: TMenuItem;
    miPlayPause: TMenuItem;
    miPreviousTrack: TMenuItem;
    miRightMouse: TMenuItem;
    miRightWin: TMenuItem;
    miShutdown: TMenuItem;
    miVolumeDown: TMenuItem;
    miVolumeUp: TMenuItem;
    pmTokensKeys: TPopupMenu;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    swLayerSwitch: TECSwitch;
    LoadGifTimer: TIdleTimer;
    BreatheTimer: TIdleTimer;
    procedure BreatheTimerTimer(Sender: TObject);
    procedure btnAllZoneClick(Sender: TObject);
    procedure btnArrowZoneClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMacroClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCloseMacroClick(Sender: TObject);
    procedure btnCommonShortcutsClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnDoneMacroClick(Sender: TObject);
    procedure btnFunctionZoneClick(Sender: TObject);
    procedure btnGameZoneClick(Sender: TObject);
    procedure btnHelpIconClick(Sender: TObject);
    procedure btnLoadLayoutClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnLoadLightingClick(Sender: TObject);
    procedure btnMouseClicksMacroClick(Sender: TObject);
    procedure btnNumberZoneClick(Sender: TObject);
    procedure btnSaveAsLightingClick(Sender: TObject);
    procedure btnSaveLightingClick(Sender: TObject);
    procedure btnResetAllClick(Sender: TObject);
    procedure btnTimingDelaysClick(Sender: TObject);
    procedure btnWASDZoneClick(Sender: TObject);
    procedure btnWindowsCombosClick(Sender: TObject);
    procedure CheckVDriveTmrTimer(Sender: TObject);
    procedure colorPreMixedClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure colorPreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure custColorDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure custColorClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure custColorChange(Sender: TObject);
    procedure eHTMLChange(Sender: TObject);
    procedure eHTMLExit(Sender: TObject);
    procedure eHTMLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure gifViewerStart(Sender: TObject);
    procedure imgBackMacroClick(Sender: TObject);
    procedure imgKeyboardLightingMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KBCoTriggerClick(Sender: TObject);
    procedure knobMacroSpeedChange(Sender: TObject);
    procedure knobMacroSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure knobMultiplayChange(Sender: TObject);
    procedure knobMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbMenuMacroClick(Sender: TObject);
    procedure LoadGifTimerTimer(Sender: TObject);
    procedure rgbExit(Sender: TObject);
    procedure GifIdleTimerTimer(Sender: TObject);
    procedure gifViewerClick(Sender: TObject);
    procedure imgLeftMenuClick(Sender: TObject);
    procedure knobDirectionChange(Sender: TObject);
    procedure knobDirectionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure knobRangeChange(Sender: TObject);
    procedure knobRangeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure knobSpeedChange(Sender: TObject);
    procedure knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miAddCustColorClick(Sender: TObject);
    procedure paintBoxGifPaint(Sender: TObject);
    procedure PopupLabelClick(Sender: TObject);
    procedure PopupMenuClick(Sender: TObject);
    procedure rgbChange(Sender: TObject);
    procedure rgbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgMacroClick(Sender: TObject);
    procedure ringPickerChange(Sender: TObject);
    procedure SingleKeyLabelClick(Sender: TObject);
    procedure SingleKeyMenuClick(Sender: TObject);
    procedure btnSaveAsLayoutClick(Sender: TObject);
    procedure btnSaveLayoutClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure imgBackgroundClick(Sender: TObject);
    procedure lblLayoutClick(Sender: TObject);
    procedure lblLightingClick(Sender: TObject);
    procedure lbMenuClick(Sender: TObject);
    procedure lbMenuDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure MenuLabelClick(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgKeyboardLayoutClick(Sender: TObject);
    procedure imgMacroMenuClick(Sender: TObject);
    procedure memoMacroChange(Sender: TObject);
    procedure swLayerSwitchClick(Sender: TObject);
    procedure TopMenuClick(Sender: TObject);
    procedure TopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TopMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnRestore(Sender: TObject);
    procedure WaveTimerTimer(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnClearMacroClick(Sender: TObject);
    procedure btnResetKeyClick(Sender: TObject);
    procedure btnBackspaceMacroClick(Sender: TObject);
  private
    { private declarations }
    activeKeyBtn: TLabelBox;
    MacroMode: boolean;
    RemapMode: boolean;
    KeyModified: boolean;
    SaveStateLayout: TSaveState;
    SaveStateLighting: TSaveState;
    keyBtnList: TObjectList;
    currentLayoutFile: string;
    currentLedFile: string;
    resetLayer: boolean;
    loadingSettings: boolean;
    loadingColor: boolean;
    loadingLedSettings: boolean;
    defaultKeyFontName: string;
    defaultKeyFontSize: integer;
    freqKeyDown: boolean;
    speedKeyDown: boolean;
    infoMessageShown: boolean;
    remapCount: integer;
    macroCount: integer;
    currentMenuAction: TMenuAction;
    menuActionList: TObjectList;
    ConfigMode: integer;
    AppSettingsLoaded: boolean;
    gifImage: array of record
                      imageMacro: TAnimatedGif;
                      r: TRect;
                    end;
    gifBackground: TMemBitmap;
    kbArrayRow1: array of TLabelBox;
    kbArrayRow2: array of TLabelBox;
    kbArrayRow3: array of TLabelBox;
    kbArrayRow4: array of TLabelBox;
    kbArrayRow5: array of TLabelBox;
    kbArrayRow6: array of TLabelBox;
    kbArrayRow7: array of TLabelBox;
    kbArrayRow8: array of TLabelBox;
    kbArrayRow9: array of TLabelBox;
    kbArrayRow10: array of TLabelBox;
    kbArrayRow11: array of TLabelBox;
    kbArrayRow12: array of TLabelBox;
    kbArrayRow13: array of TLabelBox;
    kbArrayRow14: array of TLabelBox;
    currentGif: string;
    loadingMacro: boolean;
    IsPitchBlackorOff: boolean;
    breatheTransparency: integer;
    breatheDirection: integer;
    WindowsComboOn: boolean;
    appError: boolean;
    activeMacroMenu: string;
    procedure ActivateCoTrigger(keyButton: TLabelBox);
    procedure AddGifImage(filename: string; zoom: single);
    procedure AfterColorChange;
    procedure AppDeactivate(Sender: TObject);

    procedure ChangeActiveLayer(layerIdx: integer);
    function CheckConfigMode(modeToCheck: integer): boolean;
    function CheckSaveKey(canSave: boolean): boolean;
    function CheckToSaveLayout(checkForVDrive: boolean): boolean;
    function CheckToSaveLighting(checkForVDrive: boolean): boolean;
    function CheckVDrive: boolean;
    procedure ColorChange(newColor: TColor);
    procedure continueClick(Sender: TObject);
    procedure EnablePaintImages(value: boolean);
    procedure FillMenuActionLedList;
    function GetCoTriggerKey(Sender: TObject): TKey;
    function GetKeyButtonByIndex(index: integer): TLabelBox;
    function GetKeyButtonUnderMouse(x: integer; y: integer): TLabelBox;
    function GetKeyOtherLayer(keyIdx: integer): TKBKey;
    function GetLedMode: TLedMode;
    procedure GetRBGEditColor;
    procedure InitApp(scanVDrive: boolean = false);
    procedure KeyButtonClick(Sender: TObject);
    procedure KeyButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyButtonsBringToFront;
    procedure KeyButtonsSendToBack;
    procedure SaveAsLighting(isNew: boolean=false);
    procedure scanVDriveInitClick(Sender: TObject);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
    procedure SetFreestyle2Hotkeys;
    procedure SetFreestyleProHotkeys;
    procedure SetMacroMenuItems(button: THSSpeedButton);
    procedure SetSingleKeyColor(keyButton: TLabelBox; newColor: TColor);
    procedure SetZoneColor(zoneType: TZoneType);
    procedure ShowHideKeyButtons(value: boolean);
    procedure LoadGif(speed: integer; direction: integer);
    procedure LoadLayer(layer: TKBLayer);
    function LoadLedFile(ledFile: string): boolean;
    procedure LoadMacro;
    procedure menuButtonUpdate(Sender: TObject);
    procedure OpenColorDialog;
    procedure ReloadKeyButtons;
    procedure ReloadKeyButtonsColor(reset: boolean = false);
    procedure RemoveCoTrigger(key: word);
    procedure RepaintForm(fullRepaint: boolean);
    procedure ResetCoTrigger(keyButton: TLabelBox);
    procedure ResetGifAnimCanvas;
    procedure ResetMacroCoTriggers;
    procedure ResetPopupMenu;
    procedure ResetPopupMenuMacro;
    procedure ResetSingleKey;
    function SaveLayout(isNew: boolean=false; showSaveDialog: boolean=true): boolean;
    function SaveLighting(isNew: boolean=false; showSaveDialog: boolean=true): boolean;
    procedure SaveAsLayout(isNew: boolean=false);
    procedure SaveStateSettings;
    procedure SetActiveKeyButton(keyButton: TLabelBox);
    procedure SetActiveLayer(layerIdx: integer);
    procedure setColemakBothLayers(Sender: TObject);
    procedure setColemakFnLayer(Sender: TObject);
    procedure SetColemakKb(layerIdx: integer; bothLayers: boolean);
    procedure setColemakTopLayer(Sender: TObject);
    procedure SetColorRow(arrayButton: array of TLabelBox; colorIdx: integer);
    procedure SetCoTrigger(aKey: TKey);
    procedure setDvorakBothLayers(Sender: TObject);
    procedure setDvorakFnLayer(Sender: TObject);
    procedure SetDvorakKb(layerIdx: integer; bothLayers: boolean);
    procedure setDvorakTopLayer(Sender: TObject);
    procedure SetFnNumericKpLeft;
    procedure SetFnNumericKpRight;
    procedure SetKeyButtonText(keybutton: TLabelBox; btnText: string);
    procedure SetLedMode(ledMode: TLedMode);
    procedure SetMacroText(pushCursorToEnd: boolean; cursorPos: integer=-1);
    procedure SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
    procedure SetMenuItems(aMenuAction: TMenuAction);
    procedure SetSingleKey(aMenuAction: TMenuAction);
    procedure ShowHideParameters(param: integer; state: boolean);
    procedure ShowIntroduction;
    function ShowTroubleshootingDialog(init: boolean): boolean;
    procedure UpdateGifBackground;
    procedure UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox;
      unselectKey: boolean=false; fullLoad: boolean=false);
    procedure UpdateMenu;
    procedure FillMenuActionList;
    function GetMenuActionByButton(buttonName: string): TMenuAction;
    function GetMenuActionByLabel(labelName: string): TMenuAction;
    procedure ResetAllMenuAction;
    procedure SetCurrentMenuAction(aButton: THSSpeedButton; aLsbel: TLabel);
    procedure SetModifiedKey(key: word; Modifiers: string; isMacro: boolean;
      bothLayers: boolean = false; force: boolean = false);
    procedure SetConfigOS;
    procedure SetKeyboardHook;
    procedure RemoveKeyboardHook;
    procedure InitKeyButtons(container: TWinControl);
    function LoadVersionInfo: boolean;
    function LoadStateSettings: boolean;
    procedure RefreshRemapInfo;
    function LoadKeyboardLayout(layoutFile: string): boolean;
    procedure createCustomButton(var customBtns: TCustomButtons;
      btnCaption: string; btnWidth: integer; btnOnClick: TNotifyEvent;
      btnKind: TBitBtnKind = bkCustom);
    procedure UpdateStateSettings;
    procedure watchTutorialClick(Sender: TObject);
    procedure readManualClick(Sender: TObject);
    procedure openTroubleshootingTipsClick(Sender: TObject);
    procedure scanVDriveClick(Sender: TObject);
    procedure SetConfigMode(mode: integer; init: boolean = false);
    procedure SetRemapMode(value: boolean);
    procedure SetMacroMode(value: boolean);
    procedure OpenMacroScreen;
    procedure LoadKeyButtonRows;
    procedure LoadAppSettings;
    procedure SetWindowsCombo(value: boolean);
    procedure MoveComponents(topIdx: integer; pixels: integer);
  public
    { public declarations }
    activeKbKey: TKBKey;
    activeLayer: TKBLayer;
    keyService: TKeyService;
    fileService: TFileService;
    lastKeyDown: word;
    lastKeyPressed: word;
    blueColor: TColor;
    fontColor: TColor;
    backColor: TColor;
    copiedMacro: TKeyList;
    MacroModified: boolean;
    oldWindowState: TWindowState;
    function IsKeyLoaded: boolean;
    function GetCursorNextKey(cursorPos: integer): integer;
    function GetCursorPrevKey(cursorPos: integer): integer;
    procedure SetSaveState(layoutState: TSaveState; lightingState: TSaveState);
    function ValidateBeforeDone: boolean;
    function AcceptMacro: boolean;
    procedure CancelMacro;
  end;

var
  FormMain: TFormMain;
  //FormMacro: TFormMacro;
  NeedInput: boolean;
  KBHook: HHook;
  MPos:TPoint; {Position of the Form before drag}

  procedure SetKeyPress(Key: word; Modifiers: string);
  {$ifdef Win64}
  function KeyboardHookProc(Code: longint; wParam: int64; lParam: int64): int64; stdcall;  {this intercepts keyboard input}
  {$endif}
  function FormMacroActive: boolean;

const
  PARAM_COLOR = 1;
  PARAM_DIRECTION = 2;
  PARAM_SPEED = 3;
  PARAM_RANGE = 4;
  PARAM_ZONE = 5;

implementation

{$R *.lfm}

{ Key Hook }

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
  if (NeedInput) or
    (FormMain.eRed.Focused) or
    (FormMain.eGreen.Focused) or
    (FormMain.eBlue.Focused) or
    (FormMain.eHTML.Focused) then
  begin
    Result := CallNextHookEx(WH_KEYBOARD, Code, wParam, lParam);
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMain.Active) then
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
        if currentKey <> FormMain.lastKeyPressed then
          SetKeyPress(currentKey, FormMain.keyService.GetModifierText);

        //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
        Result := 1;

        //Sets last key pressed
        FormMain.lastKeyPressed := currentKey;
      end
      else
      begin
        //Adds modifier to list of active modifiers
        FormMain.keyService.AddModifier(currentKey);
      end;
    end
    else if (Transition = tsReleased) then //On key up
    begin
      //When last key pressed is released we reset it
      if currentKey = FormMain.lastKeyPressed then
        FormMain.lastKeyPressed := 0;

      //If it's a  modifier and it's the last key pressed or print screen (only works on key up)
      if ((currentKey = FormMain.lastKeyDown) and IsModifier(currentKey)) or
        (currentKey in [VK_PRINT, VK_SNAPSHOT]) then
      begin
        SetKeyPress(currentKey, FormMain.keyService.GetModifierText);

        //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
        Result := 1;
      end;

      if IsModifier(currentKey) then
      begin
        //Removes modifier from list of active modifiers
        FormMain.keyService.RemoveModifier(currentKey);
      end;
    end;
  end;
  FormMain.lastKeyDown := currentKey;
end;

function FormMacroActive: boolean;
begin
  result := (FormMain.pnlMacro.Visible);
end;

{$endif}

{Set the keyboard hook so we  can intercept keyboard input}
procedure TFormMain.SetKeyboardHook;
{$ifdef Darwin}var eventType: EventTypeSpec;{$endif}
begin
  //Windows
  {$ifdef Win64}
  KBHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, HInstance,
    GetCurrentThreadId());
  {$endif}
end;

{unhook the keyboard interception}
procedure TFormMain.RemoveKeyboardHook;
begin
  //Windows
  {$ifdef Win64}
  UnHookWindowsHookEx(KBHook);
  {$endif}
end;

//Only used for Mac version to trap key presses
procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
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
procedure TFormMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
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

procedure TFormMain.imgBackgroundClick(Sender: TObject);
begin

end;

procedure TFormMain.lblLayoutClick(Sender: TObject);
begin
  SetConfigMode(CONFIG_LAYOUT);
end;

procedure TFormMain.lblLightingClick(Sender: TObject);
begin
  SetConfigMode(CONFIG_LIGHTING);
end;

//Adds key to list of keys and writes back to edit field
procedure SetKeyPress(Key: word; Modifiers: string);
begin
  //if (FormMain.eHTML.Focused) then
  //  FormMain.eHTML.Text := 'AAA'
  //else
    FormMain.SetModifiedKey(Key, Modifiers, FormMain.MacroMode);
end;

{ TMenuAction }

constructor TMenuAction.Create(actionButton: THSSpeedButton;
  actionLabel: TLabel; menuConfig: integer; popupMenu: boolean);
begin
  FActionButton := actionButton;
  FActionLabel := actionLabel;
  FMenuConfig := menuConfig;
  FPopupMenu := popupMenu;
end;

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  if (GDebugMode) then
  begin
    lblDebugMode.Visible := true;
    ShowMessage('Main form loading');
  end;

  //Sets Height and Width of form
  SetFormBorder(bsNone);
  self.Width := 1436;
  self.Height := 850;

  //Set default variables
  AppSettingsLoaded := false;
  infoMessageShown := false;
  loadingSettings := false;
  loadingColor := false;
  loadingLedSettings := false;
  freqKeyDown := false;
  speedKeyDown := false;
  resetLayer := false;
  keyBtnList := TObjectList.Create;
  activeKeyBtn := nil;
  activeKbKey := nil;
  activeLayer := nil;
  SetConfigOS;
  keyService := TKeyService.Create;
  fileService := TFileService.Create;
  SetSaveState(ssNone, ssNone);
  NeedInput := False;
  RemapMode := false;
  loadingMacro := false;
  IsPitchBlackorOff := false;
  breatheTransparency := 0;
  breatheDirection := 0;
  WindowsComboOn := false;
  appError := false;
  activeMacroMenu := '';
  oldWindowState := wsNormal;
  ringPicker.SquarePickerHintFormat:='Adjust the brightness of your color using the color square';
  InitKeyButtons(self);
  //jm temp not used LoadKeyButtonRows;
  //jm temp SetOtherPanelClick(self);
  Application.OnRestore := @OnRestore;
  Application.OnDeactivate:=@AppDeactivate;
  pnlMacro.Visible := false;

  //App shows in Taskbar only when minimized
  Application.MainFormOnTaskBar:= true;

  {$ifdef Darwin}
  self.BorderStyle := bsSizeable;
  btnClose.Visible := false;
  btnMinimize.Visible := false;
  btnMaximize.Visible := false;
  {$endif}

  blueColor := KINESIS_BLUE_EDGE;
  fontColor := clWhite;
  backColor := KINESIS_DARK_GRAY_FS;

  knobDirection.Image := imageKnobBig.Picture.Bitmap;
  knobSpeed.Image := imageKnobBig.Picture.Bitmap;
  knobRange.Image := imageKnob.Picture.Bitmap;
  knobMultiplay.Image := imageKnob.Picture.Bitmap;
  knobMacroSpeed.Image := imageKnob.Picture.Bitmap;

  {$ifdef Darwin}
  btnHelpIcon.TransparentColor := KINESIS_DARK_GRAY_FS;
  btnMinimize.TransparentColor := KINESIS_DARK_GRAY_FS;
  btnMaximize.TransparentColor := KINESIS_DARK_GRAY_FS;
  btnClose.TransparentColor := KINESIS_DARK_GRAY_FS;
  {$endif}

  //Set fonts
  //AddFontResource('fonts/Exo2-Regular.ttf');
  //AddFontResource('fonts/Quantify Bold v2.6.ttf');
  //SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  //jm temp {$ifdef Win64}self.BorderStyle := bsNone;{$endif}

  //Set correct z-order for images
  imgKeyboardLayout.SendToBack;
  imgKeyboardLighting.SendToBack;
  gifViewer.SendToBack;
  imgKeyboardBack.SendToBack;
  imgBackground.SendToBack;

  FillMenuActionList;

  //Set keyboard Hook
  SetKeyboardHook;

  //Init app
  InitApp;
end;

procedure TFormMain.InitApp(scanVDrive: boolean);
var
  customBtns: TCustomButtons;
  canShowApp: boolean;
  aListDrives: TStringList;
  drives: string;
  i: integer;
  titleError: string;
begin
  if (GDebugMode) then
    ShowMessage('CheckVDrive-start');
  canShowApp := CheckVDrive;
  if (GDebugMode) then
    ShowMessage('CheckVDrive-end');

  if (canShowApp) then
  begin
    //Load config keys depending on app version
    keyService.LoadConfigKeys;

    if (GDebugMode) then
    begin
      aListDrives := GetAvailableDrives;
      for i := 0 to aListDrives.Count - 1 do
        drives := drives + aListDrives[i] + #10;
      ShowMessage('Drives: ' + drives);
    end;

    RefreshRemapInfo;

    swLayerSwitch.Checked := true;

    if (GDebugMode) then
      ShowMessage('LoadStateSettings-start');
    if (LoadStateSettings) then
    begin
      if (GDebugMode) then
        ShowMessage('LoadStateSettings-end');

      if (GDebugMode) then
        ShowMessage('LoadAppSettingsAndLayout-start');
      LoadAppSettings;
      LoadKeyboardLayout(currentLayoutFile);
      LoadLedFile(currentLedFile);

      SetConfigMode(CONFIG_LAYOUT, true);

      //AddGifImage('C:\Work\Kinesis FreeStyle2\SmartSet FSEdge\Images\Original\GIFS\Breathe\Breathe APNG -littlesvr- BEST ONE.png', 1);

      //BGRASpriteAnimation1.AnimatedGifToSprite('C:\Work\Kinesis FreeStyle2\SmartSet FSEdge\Images\Original\Edge RGB Wave Gif Right- Speed 9.gif');
      ////BGRASpriteAnimation1.Sprite.Assign(.Bitmap);
      //BGRASpriteAnimation1.SpriteCount := 4; // number of frames
      //BGRASpriteAnimation1.AnimSpeed := 200;  // speed of animation

      CheckVDriveTmr.Enabled := true;

      if (GDebugMode) then
        ShowMessage('LoadAppSettingsAndLayout-end');
    end
    else
      canShowApp := false;
  end;

  if not canShowApp then
  begin
    if (GDesktopMode) then
    begin
      //createCustomButton(customBtns, 'Scan for v-Drive', 175, @scanVDriveClick);
      //titleError := 'Keyboard not detected';
      ////if (scanVDrive) then
      ////  titleError := 'Scan for v-Drive';
      //
      //if (ShowDialog(titleError, 'Use the onboard shortcut “SmartSet + F8” to open the v-Drive before launching the SmartSet App',
      //  mtError, [], DEFAULT_DIAG_HEIGHT, customBtns)) = mrCancel then
      //begin
      //  appError := true;
      //  Close;
      //end;
      //
      if (not ShowTroubleshootingDialog(true)) then
      begin
        appError := true;
        Close;
      end;
    end
    else
    begin
      createCustomButton(customBtns, 'Troubleshooting Tips', 175, @openTroubleshootingTipsClick);
      ShowDialog('SmartSet App File Error', 'The SmartSet App cannot find the necessary layout and settings files on the v-drive. Replug the keyboard to regenerate these files and try launching the App again.',
        mtFSEdge, [], DEFAULT_DIAG_HEIGHT, customBtns);
      appError := true;
      Close;
    end;
  end;
  if (GDebugMode) then
    ShowMessage('App Loaded');
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  //App error don't show main form
  if (appError) then
    self.Hide;
end;

procedure TFormMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (not CheckToSaveLayout(false)) or (not CheckToSaveLighting(false)) then
  begin
    CloseAction := caNone;
  end
  else
  begin
    if (gifViewer.Playing) then
      gifViewer.Stop;
    GifIdleTimer.Enabled := false;
    WaveTimer.Enabled := false;
    BreatheTimer.Enabled := false;
    FreeAndNil(keyService);
    FreeAndNil(fileService);
    if CloseAction = caFree then
      self := nil;
    Application.Terminate;
  end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  RemoveKeyboardHook;
  //RemoveFontResource('fonts/Exo2-Regular.ttf');
  //RemoveFontResource('fonts/Quantify Bold v2.6.ttf');
  //SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

procedure TFormMain.SetConfigOS;
begin
  //Windows
  {$ifdef Win64}
  defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 10;
  //SetFont(self, 'Tahoma Bold');
  {$endif}

  //MacOS
  {$ifdef Darwin}
  self.AutoScroll := false; //No scroll bars OSX, does not work well
  self.KeyPreview := true; //traps key presses at form level
  defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 12;
  //SetFont(self, 'Helvetica');
  lblMonochrome.Left := rgMacro1.Left - lblMonochrome.Width - 5;
  lblMacro2.Left := rgMacro2.Left - lblMacro2.Width - 5;
  lblMacro3.Left := rgMacro3.Left - lblMacro3.Width - 5;
  rgMacro1.Top := 1;
  rgMacro2.Top := 1;
  rgMacro3.Top := 1;
  lblDisplaying.Left := lblMonochrome.Left - lblDisplaying.Width - 5;
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
  lblDirectionText.Top := lblDirectionText.Top - 2;
  slStatusReport.Top := slStatusReport.Top - 2;
  {$endif}
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  ShowIntroduction;
end;

procedure TFormMain.RepaintForm(fullRepaint: boolean);
var
   region: TRect;
begin
  //Do a form repaint
  try
    EnablePaintImages(false);

    if (fullRepaint) then
      Repaint  //Invalidate;
    else
    begin
      region := TRect.Create(imgKeyboardBack.Left, imgKeyboardBack.Top, imgKeyboardBack.Left + imgKeyboardBack.Width, imgKeyboardBack.Top + imgKeyboardBack.Height);
      InvalidateRect(Handle, @region, false);
    end;
  finally
    EnablePaintImages(true);
  end;
end;

procedure TFormMain.ShowIntroduction;
//var
//  customBtns: TCustomButtons;
//  hideNotif: integer;
begin
  if (not infoMessageShown) and (not fileService.AppSettings.AppIntroMsg) and (AppSettingsLoaded) then
  begin
    ShowIntro;
    //createCustomButton(customBtns, 'Continue', 135, @continueClick);
    //createCustomButton(customBtns, 'Watch Tutorial', 135, @watchTutorialClick);
    //createCustomButton(customBtns, 'Read Manual', 135, @readManualClick);
    //
    //hideNotif := ShowDialog('Introduction', 'Welcome to the SmartSet App for the Freestyle Edge RGB. The SmartSet App lets you customize the Global Keyboard Settings, the 9 Lighting Profiles, and the 9 Layouts.',
    //  mtInformation, [], 225, customBtns, 'Hide this notification?');
    //if (hideNotif >= DISABLE_NOTIF) then
    //begin
    //  fileService.SetAppIntroMsg(true);
    //  fileService.SaveAppSettings;
    //end;
  end;
  infoMessageShown := true;
end;

function TFormMain.ShowTroubleshootingDialog(init: boolean): boolean;
var
  customBtns: TCustomButtons;
  title: string;
  message: string;
begin
  result := true;
  createCustomButton(customBtns, 'Troubleshooting Tips', 175, @openTroubleshootingTipsClick);
  if init then
  begin
    createCustomButton(customBtns, 'Scan for v-Drive', 175, @scanVDriveInitClick);
    title := 'Keyboard not detected';
    message := 'Use the onboard shortcut “SmartSet + F8” to open the v-Drive before launching the SmartSet App';
  end
  else
  begin
    createCustomButton(customBtns, 'Scan for v-Drive', 175, @scanVDriveClick);
    title := 'Keyboard Connection Lost';
    message := 'To save your changes you must use the onboard shortcut “SmartSet + F8” to open the v-Drive and re-establish the connection with the SmartSet App.';
  end;

  if (ShowDialog(title, message,
    mtError, [], DEFAULT_DIAG_HEIGHT, customBtns)) = mrCancel then
    result := false;
end;

procedure TFormMain.FillMenuActionList;
begin
  menuActionList := TObjectList.Create(false);
  menuActionList.Add(TMenuAction.Create(btnRemap, lblRemap, CONFIG_LAYOUT, false));
  menuActionList.Add(TMenuAction.Create(btnMacro, lblMacro, CONFIG_LAYOUT, false));
  menuActionList.Add(TMenuAction.Create(btnMedia, lblMedia, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnMouseClicks, lblMouseClicks, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnAltLayouts, lblAltLayouts, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnDisableKey, lblDisableKey, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnFunctionKeys, lblFunctionKeys, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnNumericKeypad, lblNumericKeypad, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnFunctionAccess, lblFunctionAccess, CONFIG_LAYOUT, true));
  menuActionList.Add(TMenuAction.Create(btnLEDControl, lblLedControl, CONFIG_LAYOUT, false));

  menuActionList.Add(TMenuAction.Create(btnIndividual, lblIndividual, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnMonochrome, lblMonochrome, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnBreathe, lblBreathe, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnRGBSpectrum, lblRGBSpectrum, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnRGBWave, lblRGBWave, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnReactive, lblReactive, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnStarlight, lblStarlight, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnRebound, lblRebound, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnRipple, lblRipple, CONFIG_LIGHTING, false));
  menuActionList.Add(TMenuAction.Create(btnPitchBlack, lblPitchBlack, CONFIG_LIGHTING, false));
end;

procedure TFormMain.FillMenuActionLedList;
begin
  //menuActionLedList := TObjectList.Create(false);
  //menuActionLedList.Add(TMenuAction.Create(btnIndividual, lblIndividual));
  //menuActionLedList.Add(TMenuAction.Create(btnMonochrome, lblMonochrome));
  //menuActionLedList.Add(TMenuAction.Create(btnBreathe, lblBreathe));
  //menuActionLedList.Add(TMenuAction.Create(btnRGBSpectrum, lblRGBSpectrum));
  //menuActionLedList.Add(TMenuAction.Create(btnRGBWave, lblRGBWave));
  //menuActionLedList.Add(TMenuAction.Create(btnReactive, lblReactive));
  //menuActionLedList.Add(TMenuAction.Create(btnPitchBlack, lblPitchBlack));
end;

procedure TFormMain.InitKeyButtons(container: TWinControl);
var
  i: integer;
  keyButton: TLabelBox;
begin
  for i := 0 to container.ControlCount - 1 do
  begin
    if (container.Controls[i] is TLabelBox) then
    begin
      keyButton := (container.Controls[i] as TLabelBox);
      if (keyButton.Index >= 0) and (keyButton.Parent <> pnlMacro) then
      begin
        keyButton.BackColor := clNone;
        keyButton.BorderStyle := bsNone;
        keyButton.Caption := '';
        keyButton.Font.Name := defaultKeyFontName;
        keyButton.Font.Size := defaultKeyFontSize;
        keyButton.OnClick := @KeyButtonClick;
        keyButton.OnMouseDown := @KeyButtonMouseDown;
        //jm temp keyButton.OnMouseDown := @KeyButtonMouseDown;
        keyButton.Hint := 'Select a key to begin programming';
        keyButton.ShowHint := true;
        keyBtnList.Add(keyButton);
      end
      else if (container.Controls[i] is TPanel) then
        InitKeyButtons(container.Controls[i] as TPanel);
    end;
  end;
end;

procedure TFormMain.LoadKeyButtonRows;
begin
  SetLength(kbArrayRow1, 6);
  kbArrayRow1[0] := lbRow1_1;
  kbArrayRow1[1] := lbRow1_2;
  kbArrayRow1[2] := lbRow1_3;
  kbArrayRow1[3] := lbRow1_4;
  kbArrayRow1[4] := lbRow1_5;
  kbArrayRow1[5] := lbRow1_6;

  SetLength(kbArrayRow2, 5);
  kbArrayRow2[0] := lbRow2_1;
  kbArrayRow2[1] := lbRow2_2;
  kbArrayRow2[2] := lbRow2_3;
  kbArrayRow2[3] := lbRow2_4;
  kbArrayRow2[4] := lbRow2_5;

  SetLength(kbArrayRow3, 6);
  kbArrayRow3[0] := lbRow3_1;
  kbArrayRow3[1] := lbRow3_2;
  kbArrayRow3[2] := lbRow3_3;
  kbArrayRow3[3] := lbRow3_4;
  kbArrayRow3[4] := lbRow3_5;
  kbArrayRow3[5] := lbRow3_6;

  SetLength(kbArrayRow4, 8);
  kbArrayRow4[0] := lbRow4_1;
  kbArrayRow4[1] := lbRow4_2;
  kbArrayRow4[2] := lbRow4_3;
  kbArrayRow4[3] := lbRow4_4;
  kbArrayRow4[4] := lbRow4_5;
  kbArrayRow4[5] := lbRow4_6;
  kbArrayRow4[6] := lbRow4_7;
  kbArrayRow4[7] := lbRow4_8;

  SetLength(kbArrayRow5, 6);
  kbArrayRow5[0] := lbRow5_1;
  kbArrayRow5[1] := lbRow5_2;
  kbArrayRow5[2] := lbRow5_3;
  kbArrayRow5[3] := lbRow5_4;
  kbArrayRow5[4] := lbRow5_5;
  kbArrayRow5[5] := lbRow5_6;

  SetLength(kbArrayRow6, 11);
  kbArrayRow6[0] := lbRow6_1;
  kbArrayRow6[1] := lbRow6_2;
  kbArrayRow6[2] := lbRow6_3;
  kbArrayRow6[3] := lbRow6_4;
  kbArrayRow6[4] := lbRow6_5;
  kbArrayRow6[5] := lbRow6_6;
  kbArrayRow6[6] := lbRow6_7;
  kbArrayRow6[7] := lbRow6_8;
  kbArrayRow6[8] := lbRow6_9;
  kbArrayRow6[9] := lbRow6_10;
  kbArrayRow6[10] := lbRow6_11;

  SetLength(kbArrayRow7, 5);
  kbArrayRow7[0] := lbRow7_1;
  kbArrayRow7[1] := lbRow7_2;
  kbArrayRow7[2] := lbRow7_3;
  kbArrayRow7[3] := lbRow7_4;
  kbArrayRow7[4] := lbRow7_5;

  SetLength(kbArrayRow8, 7);
  kbArrayRow8[0] := lbRow8_1;
  kbArrayRow8[1] := lbRow8_2;
  kbArrayRow8[2] := lbRow8_3;
  kbArrayRow8[3] := lbRow8_4;
  kbArrayRow8[4] := lbRow8_5;
  kbArrayRow8[5] := lbRow8_6;
  kbArrayRow8[6] := lbRow8_7;

  SetLength(kbArrayRow9, 10);
  kbArrayRow9[0] := lbRow9_1;
  kbArrayRow9[1] := lbRow9_2;
  kbArrayRow9[2] := lbRow9_3;
  kbArrayRow9[3] := lbRow9_4;
  kbArrayRow9[4] := lbRow9_5;
  kbArrayRow9[5] := lbRow9_6;
  kbArrayRow9[6] := lbRow9_7;
  kbArrayRow9[7] := lbRow9_8;
  kbArrayRow9[8] := lbRow9_9;
  kbArrayRow9[9] := lbRow9_10;

  SetLength(kbArrayRow10, 6);
  kbArrayRow10[0] := lbRow10_1;
  kbArrayRow10[1] := lbRow10_2;
  kbArrayRow10[2] := lbRow10_3;
  kbArrayRow10[3] := lbRow10_4;
  kbArrayRow10[4] := lbRow10_5;
  kbArrayRow10[5] := lbRow10_6;

  SetLength(kbArrayRow11, 7);
  kbArrayRow11[0] := lbRow11_1;
  kbArrayRow11[1] := lbRow11_2;
  kbArrayRow11[2] := lbRow11_3;
  kbArrayRow11[3] := lbRow11_4;
  kbArrayRow11[4] := lbRow11_5;
  kbArrayRow11[5] := lbRow11_6;
  kbArrayRow11[6] := lbRow11_7;

  SetLength(kbArrayRow12, 6);
  kbArrayRow12[0] := lbRow12_1;
  kbArrayRow12[1] := lbRow12_2;
  kbArrayRow12[2] := lbRow12_3;
  kbArrayRow12[3] := lbRow12_4;
  kbArrayRow12[4] := lbRow12_5;
  kbArrayRow12[5] := lbRow12_6;

  SetLength(kbArrayRow13, 6);
  kbArrayRow13[0] := lbRow13_1;
  kbArrayRow13[1] := lbRow13_2;
  kbArrayRow13[2] := lbRow13_3;
  kbArrayRow13[3] := lbRow13_4;
  kbArrayRow13[4] := lbRow13_5;
  kbArrayRow13[5] := lbRow13_6;

  SetLength(kbArrayRow14, 6);
  kbArrayRow14[0] := lbRow14_1;
  kbArrayRow14[1] := lbRow14_2;
  kbArrayRow14[2] := lbRow14_3;
  kbArrayRow14[3] := lbRow14_4;
  kbArrayRow14[4] := lbRow14_5;
  kbArrayRow14[5] := lbRow14_6;
end;

procedure TFormMain.LoadAppSettings;
begin
  try
    loadingSettings := true;
    ColorChange(clRed);
    AppSettingsLoaded := fileService.LoadAppSettings(GAppSettingsFile) = '';
    if (AppSettingsLoaded) then
    begin
      custColor1.Color := fileService.AppSettings.CustColor1;
      custColor2.Color := fileService.AppSettings.CustColor2;
      custColor3.Color := fileService.AppSettings.CustColor3;
      custColor4.Color := fileService.AppSettings.CustColor4;
      custColor5.Color := fileService.AppSettings.CustColor5;
      custColor6.Color := fileService.AppSettings.CustColor6;
    end;
  finally
    loadingSettings := false;
  end;
end;

function TFormMain.LoadVersionInfo: boolean;
var
  errorMsg: string;
begin
  Result := False;

  errorMsg := fileService.LoadVersionInfo;

  if (errorMsg = '') then
  begin
    //firmware := fileService.FirmwareVersion;
    //idxThirdPoint := GetPosOfNthString(firmware, '.', 3) - 1;
    //if (idxThirdPoint < 0) then
    //  idxThirdPoint := Length(firmware);
    //eFirmware.Text := Copy(fileService.FirmwareVersion, 1, idxThirdPoint);
    Result := true;
  end;
end;

function TFormMain.CheckVDrive: boolean;
begin
  result := LoadVersionInfo;
  lblVDriveOk.Visible := Result;
  lblVDriveError.Visible := not Result;
end;

function TFormMain.LoadStateSettings: boolean;
var
  errorMsg: string;
//const
//  TitleStateFile = 'Load State.txt File';
begin
  Result := False;

  try
    loadingSettings := true;
    errorMsg := fileService.LoadStateSettings;

    if (errorMsg = '') then
    begin
      currentLayoutFile := GLayoutFilePath + fileService.StateSettings.StartupFile;
      currentLedFile := GLedFilePath + fileService.StateSettings.LedFile;
      Result := true;
    end;
    //else
    //  ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
  finally
    loadingSettings := false;
  end;
end;

function TFormMain.LoadKeyboardLayout(layoutFile: string): boolean;
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
    ChangeActiveLayer(TOPLAYER_IDX);
    layoutFile := ExtractFileNameWithoutExt(ExtractFileName(layoutFile));
    idxNumber := fileService.GetFileNumber(layoutFile);
    if (idxNumber > 0) and (Pos(AnsiLowerCase(FILE_LAYOUT), AnsiLowerCase(layoutFile)) > 0) then
      lblLayout.Caption := 'Layout ' + IntToStr(idxNumber)
    else
      lblLayout.Caption := layoutFile;
    keyService.ConvertFromTextFileFmtFS(fileService.LayoutContent);
    Result := true;
  end
  else
  begin
    lblLayout.Caption := 'Not found';
    ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
  end;

  SetActiveLayer(TOPLAYER_IDX);
  SetActiveKeyButton(nil);
  RefreshRemapInfo;
end;

function TFormMain.LoadLedFile(ledFile: string): boolean;
var
  errorMsg: string;
  idxNumber: integer;
const
  TitleStateFile = 'Load Led File';
begin
  Result := False;

  if ((ledFile = '') or (ExtractFileName(ledFile) = '')) and
    ((fileService.StateSettings.PitchBlackMode) or (fileService.StateSettings.OffMode))then
  begin
    IsPitchBlackorOff := true;
    if fileService.StateSettings.PitchBlackMode then
      lblLighting.Caption := 'Lighting PB'
    else if fileService.StateSettings.OffMode then
      lblLighting.Caption := 'Lighting Off';
    keyService.LedMode := lmPitchBlack;
  end
  else
  begin
    IsPitchBlackorOff := false;
    errorMsg := fileService.LoadLedFile(ledFile);

    if (errorMsg = '') then
    begin
      try
        loadingSettings := true;
        ledFile := ExtractFileNameWithoutExt(ExtractFileName(ledFile));
        idxNumber := fileService.GetFileNumber(ledFile);
        if (idxNumber > 0) and (Pos(AnsiLowerCase(FILE_LED), AnsiLowerCase(ledFile)) > 0) then
          lblLighting.Caption := 'Lighting ' + IntToStr(idxNumber)
        else
          lblLighting.Caption := ledFile;
        keyService.ConvertLedFromTextFileFmtFS(fileService.LedContent);
        Result := true;
      finally
        loadingSettings := false;
      end;
    end
    else
    begin
      lblLighting.Caption := 'Not found';
      ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
    end;
  end;

  if (ConfigMode = CONFIG_LIGHTING) then
    SetLedMode(keyService.LedMode);
end;

procedure TFormMain.SetSaveState(layoutState: TSaveState;
  lightingState: TSaveState);
begin
  SaveStateLayout := layoutState;
  SaveStateLighting := lightingState;
  //btnSaveLayout.Enabled := SaveState = ssModified;
end;

procedure TFormMain.btnSaveLayoutClick(Sender: TObject);
begin
  if CheckConfigMode(CONFIG_LAYOUT) then
  begin
    if fileService.NewFile then
      SaveAsLayout(true)
    else
      SaveLayout;
  end;
end;

procedure TFormMain.btnSettingsClick(Sender: TObject);
begin
  Application.CreateForm(TFormSettings, FormSettings);
  FormSettings.ShowModal();
end;

procedure TFormMain.btnSaveAsLayoutClick(Sender: TObject);
begin
  if CheckConfigMode(CONFIG_LAYOUT) and CheckSaveKey(true) then
    SaveAsLayout(false);
end;

function TFormMain.SaveLayout(isNew: boolean; showSaveDialog: boolean): boolean;
var
  errorMsg: string;
  layoutContent: TStringList;
  fileName: string;
  hideNotif: integer;
  idxNumber: integer;
  isCustomLayout: boolean;
  diagMessage: string;
  diagTitle: string;
  dialHeight: integer;
  continue: boolean;
begin
  result := false;
  errorMsg := '';
  continue := true;

  if (not CheckVDrive) then
    continue := ShowTroubleshootingDialog(false);

  if continue and (CheckSaveKey(true)) and ((SaveStateLayout = ssModified) or isNew) then
  begin
    layoutContent := keyService.ConvertToTextFileFmtFS;
    if fileService.SaveFile(currentLayoutFile, layoutContent, isNew, errorMsg) then
    begin
      if (not fileService.AppSettings.SaveMsg) and (showSaveDialog) then
      begin
        fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLayoutFile));
        idxNumber := fileService.GetFileNumber(fileName);
        isCustomLayout := LowerCase(Copy(fileName, 1, Length(FILE_LAYOUT))) <> FILE_LAYOUT;
        if (isCustomLayout) then
        begin
          diagMessage := 'This custom layout has been saved as ' + filename + '. To load this layout to the keyboard it must first be assigned to position 1-9 using the Save As button.';
          diagTitle := 'Backup Layout Saved';
          dialHeight := DEFAULT_DIAG_HEIGHT;
        end
        else
        begin
          diagMessage := 'Your changes have been saved to Layout ' + IntToStr(idxNumber) + '. To implement your changes, use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive (SmartSet + F8).' +
            ' To load this layout to the keyboard, press the SmartSet + ' + IntToStr(idxNumber) + '.' + #10#10 +
            'Note: Changes to the keyboard lighting and settings must be saved separately before exiting the SmartSet App.';
          diagTitle := 'Layout Saved';
          dialHeight := 250;
        end;
        hideNotif := ShowDialog(diagTitle, diagMessage,
          mtInformation, [mbOK], dialHeight, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetSaveMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
      SetSaveState(ssNone, SaveStateLighting);
      result := true;
    end
    else
      ShowDialog('Save', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
        mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
  end;
end;

procedure TFormMain.SaveAsLighting(isNew: boolean = false);
var
  fileName: string;
  isBackupFile: boolean;
  ledPosition: string;
  continue: boolean;
begin
  try
    NeedInput := True;
    continue := true;

    if (not CheckVDrive) then
      continue := ShowTroubleshootingDialog(false);

    if (continue) then
    begin
      isBackupFile := false;
      fileName := ShowSaveAs('Save As (Lighting)', currentLedFile, CONFIG_LIGHTING, isBackupFile, ledPosition);
      if (fileName <> '') then
      begin
        if (ledPosition <> '') and (IsPitchBlackorOff) then
        begin
          fileService.SetLedFileNumber(StrToInt(ledPosition));
          IsPitchBlackorOff := false;
        end;
        currentLedFile := GLedFilePath + fileName;
        SaveLighting(true, true);
        LoadLedFile(currentLedFile);
      end;
    end;
  finally
    NeedInput := False;
  end;
end;

function TFormMain.SaveLighting(isNew: boolean; showSaveDialog: boolean
  ): boolean;
var
  errorMsg: string;
  layoutContent: TStringList;
  fileName: string;
  hideNotif: integer;
  idxNumber: integer;
  isCustomLayout: boolean;
  diagMessage: string;
  diagTitle: string;
  dialHeight: integer;
  sLedMode: string;
  continue: boolean;
begin
  result := false;
  errorMsg := '';
  sLedMode := '';
  continue := true;

  if (not CheckVDrive) then
    continue := ShowTroubleshootingDialog(false);

  if continue and ((SaveStateLighting = ssModified) or isNew) then
  begin
    if (keyService.LedMode = lmPitchBlack) then
    begin
      fileService.SetPitchBlack(true);
      fileService.SaveStateSettings;
    end
    else
    begin
      layoutContent := keyService.ConvertLedToTextFileFmtFS;
      if fileService.SaveFile(currentLedFile, layoutContent, isNew, errorMsg) then
      begin
        if (not fileService.AppSettings.SaveMsgLighting) and (showSaveDialog) then
        begin
          fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLedFile));
          idxNumber := fileService.GetFileNumber(fileName);
          isCustomLayout := LowerCase(Copy(fileName, 1, Length(FILE_LED))) <> FILE_LED;
          if currentMenuAction <> nil then
            sLedMode := currentMenuAction.ActionLabel.Caption;
          if (isCustomLayout) then
          begin
            diagMessage := 'This ' + sLedMode + ' Effect has been saved as backup file ' + filename + '. To load this Lighting Profile to the keyboard it must first be assigned to position 1-9 using the Save As button.';
            diagTitle := 'Backup Lighting Saved';
            dialHeight := DEFAULT_DIAG_HEIGHT;
          end
          else
          begin
            diagMessage := sLedMode + ' Effect has been saved to Lighting Profile ' + IntToStr(idxNumber) + '.' +
              ' To implement this Lighting Profile use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive.' +
              ' To load this Lighting Profile to the keyboard, press SmartSet + the Backlight key, then press number ' + IntToStr(idxNumber) + ' and SmartSet to Exit.' + #10#10 +
              'Note: Changes to the keyboard layout and settings must be saved separately before exiting the SmartSet App.';
            diagTitle := 'Lighting Profile Saved';
            dialHeight := 300;
          end;
          hideNotif := ShowDialog(diagTitle, diagMessage,
            mtInformation, [mbOK], dialHeight, nil, 'Hide this notification?');
          if (hideNotif >= DISABLE_NOTIF) then
          begin
            fileService.SetSaveMsgLighting(true);
            fileService.SaveAppSettings;
          end;
        end;

        fileService.SetPitchBlack(false);
        fileService.SaveStateSettings;

        SetSaveState(SaveStateLayout, ssNone);
        result := true;
      end
      else
        ShowDialog('Save', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
          mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
    end;
  end;
end;

procedure TFormMain.SaveAsLayout(isNew: boolean = false);
var
  fileName: string;
  isBackupFile: boolean;
  layoutPosition: string;
  continue: boolean;
begin
  try
    NeedInput := True;
    isBackupFile := false;
    continue := true;

    if (not CheckVDrive) then
      continue := ShowTroubleshootingDialog(false);

    if (continue) then
    begin
      fileName := ShowSaveAs('Save As (Layout)', currentLayoutFile, CONFIG_LAYOUT, isBackupFile, layoutPosition);
      if (fileName <> '') then
      begin
        //ShowDialog('Save', 'To access this layout it must first be saved as one of the nine numbered layouts. Load your new layout by holding the SmartSet key and tapping the corresponding number.',
        //      mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT);
        //SaveDialog.InitialDir := GLayoutFilePath;
        //SaveDialog.FileName := 'layout.txt';
        //if SaveDialog.Execute then
        //begin
          if (isNew) then
            keyService.ResetLayout;
          currentLayoutFile := GLayoutFilePath + fileName; //SaveDialog.FileName;
          SaveLayout(true, true);
          LoadKeyboardLayout(currentLayoutFile);

          //filename := ExtractFileNameWithoutExt(ExtractFileName(fileName));
          //if (isBackupFile) then
          //  ShowDialog('Backup Layout && Settings Saved', 'This custom layout has been saved as ' + filename + '. To load this layout to the keyboard it must first be assigned to position 1-9 using the Save As button.',
          //    mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT)
          //else
          //  ShowDialog('Layout && Settings Saved', 'This custom layout has been saved to Layout ' + layoutPosition + '. To implement your changes use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive (SmartSet + F8). To load this layout to the keyboard press SmartSet + ' + layoutPosition + '.',
          //    mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT);
        //end;
      end;
    end;
  finally
      NeedInput := False;
  end;

end;

procedure TFormMain.LoadLayer(layer: TKBLayer);
begin
  try
    if (layer <> nil) then
    begin
      ReloadKeyButtons;
    end;
  finally
  end;
end;

procedure TFormMain.ReloadKeyButtons;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  SetActiveKeyButton(nil);
  for i := 0 to activeLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := activeLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    UpdateKeyButtonKey(aKbKey, keyButton, false, true);
  end;

  RepaintForm(false);
end;

procedure TFormMain.ReloadKeyButtonsColor(reset: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
  topLayer: TKBLayer;
begin
  topLayer := keyService.GetLayer(TOPLAYER_IDX);
  for i := 0 to topLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := topLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);

    keyButton.Caption := '';
    keyButton.BorderStyle := bsNone;
    if reset then
    begin
      keyButton.BackColor := clNone;
      aKbKey.KeyColor := clNone;
    end
    else
    begin
      keyButton.Opaque := keyService.LedMode <> lmBreathe;
      keyButton.Transparency := breatheTransparency;
      if (keyService.LedMode in [lmIndividual, lmBreathe]) then
        keyButton.BackColor := aKbKey.KeyColor
      else if (keyService.LedMode in [lmMonochrome]) then
        keyButton.BackColor := keyService.LedColorMono
      else if (keyService.LedMode in [lmReactive]) then
        keyButton.BackColor := keyService.LedColorReactive
      else if (keyService.LedMode in [lmStarlight]) then
        keyButton.BackColor := keyService.LedColorStarlight
      else if (keyService.LedMode in [lmRebound]) then
        keyButton.BackColor := keyService.LedColorRebound
      else if (keyService.LedMode in [lmRipple]) then
        keyButton.BackColor := keyService.LedColorRipple
      else
        keyButton.BackColor := clNone;

      //If black color, set to none
      if (keyButton.BackColor = clBlack) then
      begin
        keyButton.BackColor := clNone;
        aKbKey.KeyColor := clNone;
      end;
    end;
    //keyButton.Invalidate;
  end;

  //Do a form repaint
  RepaintForm(false);
end;


procedure TFormMain.SetSingleKeyColor(keyButton: TLabelBox; newColor: TColor);
var
  aKbKey: TKBKey;
  topLayer: TKBLayer;
begin
  if (keyButton <> nil) then
  begin
    topLayer := keyService.GetLayer(TOPLAYER_IDX);
    aKbKey := keyService.GetKbKeyByIndex(topLayer, keyButton.Index);
    if newColor = clBlack then
    begin
      aKbKey.KeyColor := clNone;
      keyButton.BackColor := clNone;
    end
    else
    begin
      aKbKey.KeyColor := newColor;
      keyButton.BackColor := newColor;
    end;
    keyButton.Invalidate;
    SetSaveState(SaveStateLayout, ssModified);
  end;
end;

procedure TFormMain.KeyButtonsBringToFront;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to activeLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := activeLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.BringToFront;
  end;
end;

procedure TFormMain.KeyButtonsSendToBack;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to activeLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := activeLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.SendToBack;
  end;
end;

procedure TFormMain.ShowHideKeyButtons(value: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to activeLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := activeLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.Visible := value;
  end;
end;

function TFormMain.CheckConfigMode(modeToCheck: integer): boolean;
begin
  result := true;
  if (modeToCheck <> ConfigMode) then
  begin
    if (modeToCheck = CONFIG_LAYOUT) then
      ShowDialog('Editor', 'Your must select the Layout editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT)
    else
      ShowDialog('Editor', 'Your must select the Lighting editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT);
    result := false;
  end;
end;

procedure TFormMain.btnLoadLayoutClick(Sender: TObject);
var
  fileName: string;
  errorMsg: string;
  layoutPosition: string;
  continue: boolean;
begin
  continue := true;

  if (not CheckVDrive) then
    continue := ShowTroubleshootingDialog(false);

  if continue and CheckConfigMode(CONFIG_LAYOUT) and CheckSaveKey(true) and CheckToSaveLayout(true) then
  begin
    fileName := ShowLoad('Load (Layout)', currentLayoutFile, layoutPosition, CONFIG_LAYOUT);
    if (fileName <> '') then
    begin
      if not fileService.CheckIfFileExists(GLayoutFilePath + fileName) then
        fileService.SaveFile(GLayoutFilePath + fileName, nil, true, errorMsg);
      currentLayoutFile := GLayoutFilePath + fileName;
      LoadKeyboardLayout(currentLayoutFile);
      SetSaveState(ssNone, SaveStateLighting);
    end;
  end;
end;

procedure TFormMain.btnLoadLightingClick(Sender: TObject);
var
  fileName: string;
  errorMsg: string;
  lightingPos: string;
  continue: boolean;
begin
  continue := true;

  if (not CheckVDrive) then
    continue := ShowTroubleshootingDialog(false);

  if continue and CheckConfigMode(CONFIG_LIGHTING) and CheckSaveKey(true) and CheckToSaveLighting(true) then
  begin
    fileName := ShowLoad('Load (Lighting)', currentLedFile, lightingPos, CONFIG_LIGHTING);
    if (fileName <> '') then
    begin
      if not fileService.CheckIfFileExists(GLedFilePath + fileName) then
        fileService.SaveFile(GLedFilePath + fileName, nil, true, errorMsg);
      currentLedFile := GLedFilePath + fileName;
      LoadLedFile(currentLedFile);
      SetSaveState(SaveStateLayout, ssNone);
    end;
  end;
end;

procedure TFormMain.btnSaveLightingClick(Sender: TObject);
begin
  if CheckConfigMode(CONFIG_LIGHTING) then
  begin
    if (IsPitchBlackorOff) then
    begin
      ShowDialog('Save', 'Pitch Black mode cannot be customized', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT);
    end
    else
      SaveLighting;
  end;
end;

procedure TFormMain.btnSaveAsLightingClick(Sender: TObject);
begin
  if CheckConfigMode(CONFIG_LIGHTING) then
    SaveAsLighting;
end;

procedure TFormMain.SaveStateSettings;
var
  errorMsg: string;
const
  TitleStateFile = 'Save State.txt File';
begin
  errorMsg := fileService.SaveStateSettings;

  if (errorMsg <> '') then
    ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
end;

function TFormMain.CheckSaveKey(canSave: boolean): boolean;
var
  msgResult: integer;
begin
  result := true;

  if IsKeyLoaded and MacroModified and MacroMode then
  begin
    if (canSave) then
    begin
      msgResult := ShowDialog('Apply changes',
        'This macro has been modified, do you want to apply these changes?', mtConfirmation,
        [mbYes, mbNo, mbCancel], DEFAULT_DIAG_HEIGHT);
    if msgResult = mrYes then
      result := AcceptMacro
     else if msgResult = mrNo then
      CancelMacro
    else
      result := false;
    end
    else
    begin
      ShowDialog('Macro', 'You must finish editing macro before proceeding', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT);
      result := false;
    end;
  end
  else if (KeyModified) then
    btnDone.Click;

  if (result) and (pnlMacro.Visible) and not(MacroMode) then
  begin
    pnlMacro.Visible := false;
  end;
end;

function TFormMain.CheckToSaveLayout(checkForVDrive: boolean): boolean;
var
  dialogResult: integer;
begin
  result := true;
  if (SaveStateLayout = ssModified) then
  begin
    if checkForVDrive and (not CheckVDrive) then
      result := ShowTroubleshootingDialog(false);

    if (result) then
    begin
      dialogResult := ShowDialog('Save Layout',
        'Do you want to save changes?',
        mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT);

      if dialogResult = mrYes then
        btnSaveLayout.Click
      else if dialogResult = mrNo then
        SetSaveState(ssNone, SaveStateLighting)
      else
        result := false;
    end;
  end;
end;

function TFormMain.CheckToSaveLighting(checkForVDrive: boolean): boolean;
var
  dialogResult: integer;
  hasGif: boolean;
begin
  result := true;
  if (SaveStateLighting = ssModified) then
  begin
    try
      hasGif := keyService.LedMode in [lmSpectrum, lmWave, lmReactive, lmStarlight, lmRebound, lmRipple];
      if (hasGif) then
        gifViewer.Pause;
      if checkForVDrive and (not CheckVDrive) then
        result := ShowTroubleshootingDialog(false);

      if (result) then
      begin
        dialogResult := ShowDialog('Save Lighting',
          'Do you want to save changes?',
          mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT);

        if dialogResult = mrYes then
          btnSaveLighting.Click
        else if dialogResult = mrNo then
          SetSaveState(SaveStateLayout, ssNone)
        else
          result := false;
      end;
    finally
      if (hasGif) then
        gifViewer.Start;
    end;
  end;
end;

procedure TFormMain.RefreshRemapInfo;
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

  //jm temp
  //if (remapCount + macroCount > 0) then
  //  lblRemapCount.Caption := IntToStr(remapCount + macroCount)
  //else
  //  lblRemapCount.Caption := '';

  //btnResetLayer.Enabled := (remapCount > 0) or (macroCount > 0);
  //btnResetLayout.Enabled := (remapCount > 0) or (macroCount > 0);
end;

procedure TFormMain.createCustomButton(var customBtns: TCustomButtons;
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

procedure TFormMain.watchTutorialClick(Sender: TObject);
begin
  OpenUrl(FSEDGEV2_TUTORIAL);
end;

procedure TFormMain.readManualClick(Sender: TObject);
//var
//  filePath: string;
begin
  OpenUrl(FSEDGEV2_HELP);
  //filePath := GApplicationPath + '\help\' + USER_MANUAL_FSEDGE;
  //{$ifdef Darwin}filePath := GApplicationPath + '/help/' + USER_MANUAL_FSEDGE;{$endif}
  //
  //if FileExists(filePath) then
  //  OpenDocument(filePath)
  //else
  //  ShowDialog('Help file', 'Help file not found!', mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
end;

procedure TFormMain.openTroubleshootingTipsClick(Sender: TObject);
begin
  OpenUrl('https://gaming.kinesis-ergo.com/fs-edge-rgb-support/');
end;

procedure TFormMain.scanVDriveClick(Sender: TObject);
begin
  if (CheckVDrive) then
  begin
    CloseDialog(mrOK);
    if (SetBaseDirectory) then
      ResetAppPaths;
  end;
end;

procedure TFormMain.scanVDriveInitClick(Sender: TObject);
begin
  CloseDialog(mrOK);
  if (SetBaseDirectory) then
    ResetAppPaths;
  InitApp(true);
end;

procedure TFormMain.SetConfigMode(mode: integer; init: boolean);
var
  i:integer;
  menuAction: TMenuAction;
  canContinue: boolean;
begin
  canContinue := false;

  if (ConfigMode = CONFIG_LAYOUT) then
    canContinue := CheckToSaveLayout(true)
  else
    canContinue := CheckToSaveLighting(true);

  if (canContinue) then
  begin
    SetCurrentMenuAction(nil, nil);
    ConfigMode := mode;
    if (ConfigMode = CONFIG_LAYOUT) then
    begin
      if (not init) then
        LoadKeyboardLayout(currentLayoutFile);
      if (gifViewer.Playing) then
        gifViewer.Stop;
      BreatheTimer.Enabled := false;
      LoadGifTimer.Enabled := false;;
      gifViewer.Visible := false;
      imgKeyboardLayout.Visible := true;
      imgKeyboardLighting.Visible := false;
      btnLayout.Down := true;
      lblLayout.Font.Color := KINESIS_BLUE_EDGE;
      lblLighting.Font.Color := clWhite;
      //btnCancel.Top := 715;
      //btnDone.Top := 715;
      //btnResetKey.Top := 715;
      //btnResetAll.Top := 715;
      imgListLoadSave.GetBitmap(0, btnLoadLayout.Glyph);
      imgListLoadSave.GetBitmap(1, btnSaveLayout.Glyph);
      imgListLoadSave.GetBitmap(2, btnSaveAsLayout.Glyph);
      imgListLoadSave.GetBitmap(3, btnLoadLighting.Glyph);
      imgListLoadSave.GetBitmap(4, btnSaveLighting.Glyph);
      imgListLoadSave.GetBitmap(5, btnSaveAsLighting.Glyph);
      KeyButtonsBringToFront;
      ShowHideKeyButtons(true);
    end
    else
    begin
      if (not init) then
        LoadLedFile(currentLedFile);
      imgKeyboardLayout.Visible := false;
      imgKeyboardLighting.Visible := true;
      btnLighting.Down := true;
      lblLighting.Font.Color := KINESIS_BLUE_EDGE;
      lblLayout.Font.Color := clWhite;
      //btnCancel.Top := 545;
      //btnDone.Top := 545;
      //btnResetKey.Top := 545;
      //btnResetAll.Top := 545;
      imgListLoadSave.GetBitmap(3, btnLoadLayout.Glyph);
      imgListLoadSave.GetBitmap(4, btnSaveLayout.Glyph);
      imgListLoadSave.GetBitmap(5, btnSaveAsLayout.Glyph);
      imgListLoadSave.GetBitmap(0, btnLoadLighting.Glyph);
      imgListLoadSave.GetBitmap(1, btnSaveLighting.Glyph);
      imgListLoadSave.GetBitmap(2, btnSaveAsLighting.Glyph);
    end;

    //imgLeftMenu.Visible := ConfigMode = CONFIG_LAYOUT;
    swLayerSwitch.Visible := ConfigMode = CONFIG_LAYOUT;
    lblActions.Visible := ConfigMode = CONFIG_LAYOUT;
    btnCancel.Visible := ConfigMode = CONFIG_LAYOUT;
    btnDone.Visible := ConfigMode = CONFIG_LAYOUT;
    btnResetKey.Visible := ConfigMode = CONFIG_LAYOUT;
    btnResetAll.Visible := true; //ConfigMode = CONFIG_LAYOUT;
    btnLoadLayout.Enabled := ConfigMode = CONFIG_LAYOUT;
    btnSaveLayout.Enabled := ConfigMode = CONFIG_LAYOUT;
    btnSaveAsLayout.Enabled := ConfigMode = CONFIG_LAYOUT;
    btnLoadLighting.Enabled := ConfigMode = CONFIG_LIGHTING;
    btnSaveLighting.Enabled := ConfigMode = CONFIG_LIGHTING;
    btnSaveAsLighting.Enabled := ConfigMode = CONFIG_LIGHTING;

    //imgLeftMenuLighting.Visible := ConfigMode = CONFIG_LIGHTING;
    imgLeftMenuLighting.Visible := false;
    lblLightingModes.Visible := ConfigMode = CONFIG_LIGHTING;

    if (ConfigMode = CONFIG_LAYOUT) then
    begin
      ShowHideParameters(PARAM_COLOR, false);
      ShowHideParameters(PARAM_DIRECTION, false);
      ShowHideParameters(PARAM_SPEED, false);
      ShowHideParameters(PARAM_RANGE, false);
      ShowHideParameters(PARAM_ZONE, false);
    end;

    for I:= 0 to menuActionList.Count - 1 do
    begin
      menuAction := (menuActionList.Items[i] as TMenuAction);
      menuAction.ActionButton.Visible := menuAction.MenuConfig = ConfigMode;
      menuAction.ActionLabel.Visible := menuAction.MenuConfig = ConfigMode;
    end;

    if (ConfigMode = CONFIG_LIGHTING) then
    begin
      SetLedMode(keyService.LedMode);
    end
    else
    begin
      ReloadKeyButtons;
    end;
  end;
end;

procedure TFormMain.ShowHideParameters(param: integer; state: boolean);
var
  image: TBGRABitmap;
begin
  case param of
    PARAM_COLOR:
    begin
      imgColorPanel.Visible := state;
      imgColor.Visible := state;
      ringPicker.Visible := state;
      colorPreview.Visible := state;
      eRed.Visible := state;
      eGreen.Visible := state;
      eBlue.Visible := state;
      lblRColor.Visible := state;
      lblGColor.Visible := state;
      lblBColor.Visible := state;
      lblColor.Visible := state;
      eHTML.Visible := state;
      lblPreMixedColors.Visible := state;
      lblCustomColors.Visible := state;
      preMixedColor1.Visible := state;
      preMixedColor2.Visible := state;
      preMixedColor3.Visible := state;
      preMixedColor4.Visible := state;
      preMixedColor5.Visible := state;
      preMixedColor6.Visible := state;
      preMixedColor7.Visible := state;
      preMixedColor8.Visible := state;
      preMixedColor9.Visible := state;
      preMixedColor10.Visible := state;
      custColor1.Visible := state;
      custColor2.Visible := state;
      custColor3.Visible := state;
      custColor4.Visible := state;
      custColor5.Visible := state;
      custColor6.Visible := state;
    end;
    PARAM_DIRECTION:
    begin
      imgDirectionPanel.Visible := state;
      imgDirection.Visible := state;
      lblDirection.Visible := state;
      lblDirectionText.Visible := state;
      knobDirection.Visible := state;
      ledDirection.Visible := state;
    end;
    PARAM_SPEED:
    begin
      imgSpeedPanel.Visible := state;
      imgSpeed.Visible := state;
      lblSpeed.Visible := state;
      lblSpeedText.Visible := state;
      knobSpeed.Visible := state;
      ledSpeed.Visible := state;
    end;
    PARAM_RANGE:
    begin
      imgRangePanel.Visible := false; //state;
      imgRange.Visible := false; //state;
      lblRange.Visible := false; //state;
      lblRangeText.Visible := false; //state;
      knobRange.Visible := false; //state;
      ledRange.Visible := false; //state;
    end;
    PARAM_ZONE:
    begin
      imgZonePanel.Visible := state;
      imgZone.Visible := state;
      lblZone.Visible := state;
      btnAllZone.Visible := state;
      btnNumberZone.Visible := state;
      btnWASDZone.Visible := state;
      btnFunctionZone.Visible := state;
      btnGameZone.Visible := state;
      btnArrowZone.Visible := state;
    end;
  end;
end;

procedure TFormMain.SetRemapMode(value: boolean);
begin
  if RemapMode and not(value) then
    SetActiveKeyButton(nil);

  RemapMode := value;

  if (RemapMode) then
  begin

  end
  else
  begin

  end;
end;

procedure TFormMain.SetMacroMode(value: boolean);
begin
  if MacroMode and not(value) then
    SetActiveKeyButton(nil);

  MacroMode := value;

  if (MacroMode) then
  begin
    if (IsKeyLoaded) then
      OpenMacroScreen;
  end
  else
  begin

  end;
end;

function TFormMain.GetLedMode: TLedMode;
begin
  result := lmNone;

  if (btnIndividual.Down) then
    result := lmIndividual
  else if (btnMonochrome.Down) then
    result := lmMonochrome
  else if (btnBreathe.Down) then
    result := lmBreathe
  else if (btnRGBSpectrum.Down) then
    result := lmSpectrum
  else if (btnRGBWave.Down) then
    result := lmWave
  else if (btnReactive.Down) then
    result := lmReactive
  else if (btnStarlight.Down) then
    result := lmStarlight
  else if (btnRebound.Down) then
    result := lmRebound
  else if (btnRipple.Down) then
    result := lmRipple
  else if (btnPitchBlack.Down) then
    result := lmPitchBlack;
end;

procedure TFormMain.SetLedMode(ledMode: TLedMode);
var
  isColorEnabled: boolean;
const
  colorEnabled = clWhite;
  colorDisabled = clSilver;
begin
  try
    loadingLedSettings := true;
    WaveTimer.Enabled := false;
    BreatheTimer.Enabled := false;
    LoadGifTimer.Enabled := false;
    keyService.LedMode := ledMode;
    gifViewer.Visible := false;
    ShowHideKeyButtons(false);

    ShowHideParameters(PARAM_COLOR, ledMode in [lmIndividual, lmMonochrome, lmBreathe, lmReactive, lmRipple, lmStarlight, lmRebound]);
    ShowHideParameters(PARAM_DIRECTION, ledMode in [lmWave]);
    ShowHideParameters(PARAM_SPEED, ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive, lmStarlight, lmRebound, lmRipple]);
    ShowHideParameters(PARAM_RANGE, false);
    ShowHideParameters(PARAM_ZONE, ledMode in [lmIndividual, lmBreathe]);
    btnResetAll.Visible := ledMode in [lmIndividual, lmBreathe];

    imgKeyboardLighting.Cursor := crDefault;
    if (ledMode = lmIndividual) then
    begin
      SetCurrentMenuAction(btnIndividual, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      //KeyButtonsBringToFront;
      ShowHideKeyButtons(true);
      imgKeyboardLighting.Cursor := crHandPoint;
    end
    else if (ledMode = lmMonochrome) then
    begin
      SetCurrentMenuAction(btnMonochrome, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      ColorChange(keyService.LedColorMono);
      ShowHideKeyButtons(true);
    end
    else if (ledMode = lmBreathe) then
    begin
      SetCurrentMenuAction(btnBreathe, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      //KeyButtonsBringToFront;
      knobSpeed.Position := keyService.LedSpeed;
      ShowHideKeyButtons(true);
      imgKeyboardLighting.Cursor := crHandPoint;
    end
    else if (ledMode in [lmSpectrum]) then
    begin
      SetCurrentMenuAction(btnRGBSpectrum, nil);
      imgKeyboardLighting.SendToBack;
      gifViewer.SendToBack;
      KeyButtonsSendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
    end
    else if (ledMode = lmWave) then
    begin
      SetCurrentMenuAction(btnRGBWave, nil);
      imgKeyboardLighting.SendToBack;
      gifViewer.SendToBack;
      KeyButtonsSendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      knobDirection.Position := keyService.LedDirection;
    end
    else if (ledMode  in [lmReactive, lmStarlight, lmRebound, lmRipple]) then
    begin
      if (ledMode = lmReactive) then
        SetCurrentMenuAction(btnReactive, nil)
      else if (ledMode = lmStarlight) then
        SetCurrentMenuAction(btnStarlight, nil)
      else if (ledMode = lmRebound) then
        SetCurrentMenuAction(btnRebound, nil)
      else if (ledMode = lmRipple) then
        SetCurrentMenuAction(btnRipple, nil);
      imgKeyboardLighting.SendToBack;
      gifViewer.SendToBack;
      KeyButtonsSendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      if (ledMode = lmReactive) then
        ColorChange(keyService.LedColorReactive)
      else if (ledMode = lmStarlight) then
        ColorChange(keyService.LedColorStarlight)
      else if (ledMode = lmRebound) then
        ColorChange(keyService.LedColorRebound)
      else if (ledMode = lmRipple) then
        ColorChange(keyService.LedColorRipple);
    end
    else if (ledMode = lmPitchBlack) then
    begin
      SetCurrentMenuAction(btnPitchBlack, nil);
    end;

    if (GDebugMode) then
    begin
      gifViewer.BringToFront;
    end;

    ////Color
    //isColorEnabled := ledMode in [lmIndividual, lmMonochrome, lmBreathe, lmReactive];
    //if (isColorEnabled) then
    //begin
    //  lblColor.Font.Color := colorEnabled;
    //  lblRColor.Font.Color := colorEnabled;
    //  lblGColor.Font.Color := colorEnabled;
    //  lblBColor.Font.Color := colorEnabled;
    //  lblPreMixedColors.Font.Color := colorEnabled;
    //  lblCustomColors.Font.Color := colorEnabled;
    //end
    //else
    //begin
    //  lblColor.Font.Color := colorDisabled;
    //  lblRColor.Font.Color := colorDisabled;
    //  lblGColor.Font.Color := colorDisabled;
    //  lblBColor.Font.Color := colorDisabled;
    //  lblPreMixedColors.Font.Color := colorDisabled;
    //  lblCustomColors.Font.Color := colorDisabled;
    //end;
    //ringPicker.Enabled := isColorEnabled;
    //colorPreview.Enabled := isColorEnabled;
    //eRed.Enabled := isColorEnabled;
    //eGreen.Enabled := isColorEnabled;
    //eBlue.Enabled := isColorEnabled;
    //eHTML.Enabled := isColorEnabled;
    //preMixedColor1.Enabled := isColorEnabled;
    //preMixedColor2.Enabled := isColorEnabled;
    //preMixedColor3.Enabled := isColorEnabled;
    //preMixedColor4.Enabled := isColorEnabled;
    //preMixedColor5.Enabled := isColorEnabled;
    //preMixedColor6.Enabled := isColorEnabled;
    //preMixedColor7.Enabled := isColorEnabled;
    //preMixedColor8.Enabled := isColorEnabled;
    //preMixedColor9.Enabled := isColorEnabled;
    //preMixedColor10.Enabled := isColorEnabled;
    //custColor1.Enabled := isColorEnabled;
    //custColor2.Enabled := isColorEnabled;
    //custColor3.Enabled := isColorEnabled;
    //custColor4.Enabled := isColorEnabled;
    //custColor5.Enabled := isColorEnabled;
    //custColor6.Enabled := isColorEnabled;
    //
    ////Direction
    //if (ledMode = lmWave) then
    //  lblDirection.Font.Color := colorEnabled
    //else
    //  lblDirection.Font.Color := colorDisabled;
    //imgDirectionPanel.Enabled := ledMode = lmWave;
    //knobDirection.Enabled := ledMode = lmWave;
    //lblDirectionText.Enabled := ledMode = lmWave;
    //knobDirection.Position := keyService.LedDirection;
    //
    ////Speed
    //if (ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive]) then
    //  lblSpeed.Font.Color := colorEnabled
    //else
    //  lblSpeed.Font.Color := colorDisabled;
    //imgSpeedPanel.Enabled := ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive];
    //knobSpeed.Enabled := ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive];
    //lblSpeedText.Enabled := ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive];
    //knobSpeed.Position := keyService.LedSpeed;
    //
    ////Range
    //if (false) then //if (ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive]) then
    //  lblRange.Font.Color := colorEnabled
    //else
    //  lblRange.Font.Color := colorDisabled;
    //imgRangePanel.Enabled := false;//ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive];
    //knobRange.Enabled := false;//ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive];
    //lblRangeText.Enabled := false;//ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive];
    //knobRange.Position := 0;//keyService.LedSpeed;

    ReloadKeyButtonsColor;

    //LoadGif(keyService.LedSpeed, keyService.LedDirection);
    if (ledMode = lmBreathe) then
      BreatheTimer.Enabled := true
    else
      LoadGifTimer.Enabled := true;
  finally
    loadingLedSettings := false;
  end;
end;

procedure TFormMain.LoadGifTimerTimer(Sender: TObject);
begin
  LoadGifTimer.Enabled := false;
  LoadGif(Round(knobSpeed.Position), Round(knobDirection.Position));
end;

procedure TFormMain.BreatheTimerTimer(Sender: TObject);
begin
  BreatheTimer.Enabled := false;
  case keyService.LedSpeed of
    1: BreatheTimer.Interval := Trunc((12 * 1000) / 26);
    2: BreatheTimer.Interval := Trunc((10 * 1000) / 26);
    3: BreatheTimer.Interval := Trunc((9 * 1000) / 26);
    4: BreatheTimer.Interval := Trunc((8 * 1000) / 26);
    5: BreatheTimer.Interval := Trunc((7 * 1000) / 26);
    6: BreatheTimer.Interval := Trunc((6 * 1000) / 26);
    7: BreatheTimer.Interval := Trunc((5 * 1000) / 26);
    8: BreatheTimer.Interval := Trunc((4 * 1000) / 26);
    9: BreatheTimer.Interval := Trunc((2 * 1000) / 26);
  end;

  if (breatheDirection = 0) then
    breatheTransparency := breatheTransparency + 20
  else
    breatheTransparency := breatheTransparency - 20;

  if (breatheTransparency >= 255) then
  begin
    breatheTransparency := 255;
    breatheDirection := 1
  end
  else if (breatheTransparency <= 0) then
  begin
    breatheTransparency := 0;
    breatheDirection := 0;
  end;

  ReloadKeyButtonsColor;

  BreatheTimer.Enabled := true;
end;

procedure TFormMain.btnAllZoneClick(Sender: TObject);
begin
  SetZoneColor(ztAll);
end;

procedure TFormMain.btnNumberZoneClick(Sender: TObject);
begin
  SetZoneColor(ztNumber);
end;

procedure TFormMain.btnWASDZoneClick(Sender: TObject);
begin
  SetZoneColor(ztWASD);
end;

procedure TFormMain.btnFunctionZoneClick(Sender: TObject);
begin
  SetZoneColor(ztFunction);
end;

procedure TFormMain.btnGameZoneClick(Sender: TObject);
begin
  SetZoneColor(ztGame);
end;

procedure TFormMain.btnArrowZoneClick(Sender: TObject);
begin
  SetZoneColor(ztArrow);
end;

procedure TFormMain.SetZoneColor(zoneType: TZoneType);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
  topLayer: TKBLayer;
  keyColor: TColor;
begin
  if (keyService.LedMode in [lmIndividual, lmBreathe]) then
  begin
    keyColor := ringPicker.SelectedColor;
    case zoneType of
      ztAll: begin
        topLayer := keyService.GetLayer(TOPLAYER_IDX);
        for i := 0 to topLayer.KBKeyList.Count - 1 do
        begin
          aKbKey := topLayer.KBKeyList[i];
          aKbKey.KeyColor := keyColor;
        end;
        ReloadKeyButtonsColor;
      end;
      ztWASD: begin
        SetSingleKeyColor(lbRow5_3, keyColor);
        SetSingleKeyColor(lbRow4_6, keyColor);
        SetSingleKeyColor(lbRow5_4, keyColor);
        SetSingleKeyColor(lbRow6_7, keyColor);
      end;
      ztNumber: begin
        SetSingleKeyColor(lbRow3_2, keyColor);
        SetSingleKeyColor(lbRow4_3, keyColor);
        SetSingleKeyColor(lbRow4_4, keyColor);
        SetSingleKeyColor(lbRow5_2, keyColor);
        SetSingleKeyColor(lbRow6_3, keyColor);
        SetSingleKeyColor(lbRow6_4, keyColor);
        SetSingleKeyColor(lbRow7_2, keyColor);
        SetSingleKeyColor(lbRow8_2, keyColor);
        SetSingleKeyColor(lbRow9_3, keyColor);
        SetSingleKeyColor(lbRow9_4, keyColor);
        SetSingleKeyColor(lbRow10_2, keyColor);
        SetSingleKeyColor(lbRow11_2, keyColor);
        SetSingleKeyColor(lbRow12_2, keyColor);
      end;
      ztFunction: begin
        SetSingleKeyColor(lbRow3_1, keyColor);
        SetSingleKeyColor(lbRow4_1, keyColor);
        SetSingleKeyColor(lbRow4_2, keyColor);
        SetSingleKeyColor(lbRow5_1, keyColor);
        SetSingleKeyColor(lbRow6_1, keyColor);
        SetSingleKeyColor(lbRow6_2, keyColor);
        SetSingleKeyColor(lbRow7_1, keyColor);
        SetSingleKeyColor(lbRow8_1, keyColor);
        SetSingleKeyColor(lbRow9_1, keyColor);
        SetSingleKeyColor(lbRow9_2, keyColor);
        SetSingleKeyColor(lbRow10_1, keyColor);
        SetSingleKeyColor(lbRow11_1, keyColor);
        SetSingleKeyColor(lbRow12_1, keyColor);
      end;
      ztGame: begin
        SetSingleKeyColor(lbRow1_1, keyColor);
        SetSingleKeyColor(lbRow1_2, keyColor);
        SetSingleKeyColor(lbRow1_3, keyColor);
        SetSingleKeyColor(lbRow1_4, keyColor);
        SetSingleKeyColor(lbRow1_5, keyColor);
        SetSingleKeyColor(lbRow1_6, keyColor);
        SetSingleKeyColor(lbRow2_1, keyColor);
        SetSingleKeyColor(lbRow2_2, keyColor);
        SetSingleKeyColor(lbRow2_3, keyColor);
        SetSingleKeyColor(lbRow2_4, keyColor);
        SetSingleKeyColor(lbRow2_5, keyColor);
      end;
      ztArrow: begin
        SetSingleKeyColor(lbRow13_5, keyColor);
        SetSingleKeyColor(lbRow12_6, keyColor);
        SetSingleKeyColor(lbRow13_6, keyColor);
        SetSingleKeyColor(lbRow14_6, keyColor);
      end;
    end;
    SetSaveState(SaveStateLayout, ssModified);
  end;
end;

procedure TFormMain.LoadGif(speed: integer; direction: integer);
var
  //imagePath: string;
  gifToLoad: string;
begin
  //imagePath := GExecutablePath + 'Images\';

  gifViewer.Left := 323;
  gifViewer.Width := 1088;
  if (keyService.LedMode = lmBreathe) then
  begin
    //gifToLoad := imagePath + 'Breathe_Spd' + IntToStr(speed) + '.gif';
    //gifToLoad := 'BREATHE-SPD' +  IntToStr(speed);
    //gifViewer.Left := 340;
    //gifViewer.Width := 1050;
  end
  else if (keyService.LedMode = lmWave) then
  begin
    //gifToLoad := imagePath + 'Wave_Spd' + IntToStr(speed) + '.gif';
  //  WaveTimer.Enabled := true;
    gifToLoad := 'WAVE';
    case direction of
      LED_DIR_DOWN_INT: gifToLoad := gifToLoad + 'DOWN-';
      LED_DIR_LEFT_INT: gifToLoad := gifToLoad + 'LEFT-';
      LED_DIR_UP_INT: gifToLoad := gifToLoad + 'UP-';
      LED_DIR_RIGHT_INT: gifToLoad := gifToLoad + 'RIGHT-';
    end;
    gifToLoad := gifToLoad + 'SPD' + IntToStr(speed);
  end
  else if (keyService.LedMode = lmSpectrum) then
  begin
    gifToLoad := 'SPECTRUM-SPD' +  IntToStr(speed);
    //gifToLoad := imagePath + 'Spectrum-Spd' + IntToStr(speed) + '.gif';
  end
  else if (keyService.LedMode = lmReactive) then
  begin
    gifToLoad := 'REACTIVE-SPD' +  IntToStr(speed);
    //gifToLoad := imagePath + 'Reactive_Spd' + IntToStr(speed) + '.gif';
  end
  else if (keyService.LedMode = lmStarlight) then
  begin
    gifToLoad := 'STARLIGHT-SPD' +  IntToStr(speed);
  end
  else if (keyService.LedMode = lmRebound) then
  begin
    gifToLoad := 'REBOUND-SPD' +  IntToStr(speed);
  end
  else if (keyService.LedMode = lmRipple) then
  begin
    gifToLoad := 'RIPPLE-SPD' +  IntToStr(speed);
  end;

  if (gifToLoad <> '') then
  begin
    try
      if (currentGif <> gifToLoad) then
      begin
        //gifViewer.LoadFromFile(gifToLoad);
        gifViewer.Pause;
        gifViewer.LoadFromResource(gifToLoad);
      end;

      gifViewer.Visible := true;
      gifViewer.Start;
      currentGif := gifToLoad;
    except
    end;
  end
  else
  begin
    if (gifViewer.Playing) then
      gifViewer.Stop;
    gifViewer.Visible := false;
  end;
end;

var
  tick: integer = 0;
procedure TFormMain.WaveTimerTimer(Sender: TObject);
begin
  WaveTimer.Enabled := false;
  inc(tick);
  SetColorRow(kbArrayRow14, tick);
  SetColorRow(kbArrayRow13, (tick + 1) Mod 12);
  SetColorRow(kbArrayRow12, (tick + 2) Mod 12);
  SetColorRow(kbArrayRow11, (tick + 3) Mod 12);
  SetColorRow(kbArrayRow10, (tick + 4) Mod 12);
  SetColorRow(kbArrayRow9, (tick + 5) Mod 12);
  SetColorRow(kbArrayRow8, (tick + 6) Mod 12);
  SetColorRow(kbArrayRow7, (tick + 7) Mod 12);
  SetColorRow(kbArrayRow6, (tick + 8) Mod 12);
  SetColorRow(kbArrayRow5, (tick + 9) Mod 12);
  SetColorRow(kbArrayRow4, (tick + 10) Mod 12);
  SetColorRow(kbArrayRow3, (tick + 11) Mod 12);
  SetColorRow(kbArrayRow2, (tick + 12) Mod 12);
  SetColorRow(kbArrayRow1, (tick + 13) Mod 12);

  if (tick = 12) then
    tick := 0;

  Refresh;
  WaveTimer.Enabled := true;
end;

procedure TFormMain.SetColorRow(arrayButton: array of TLabelBox; colorIdx: integer);
var
  i: integer;
  keyColor: TColor;
begin
  case colorIdx of
    0, 12: keyColor := RGB(0, 128, 255); //teal
    11: keyColor := RGB(0, 0, 255); //Blue
    10: keyColor := RGB(128, 0, 255); //Purple
    9: keyColor := RGB(255, 0, 255); //Fushia
    8: keyColor := RGB(255, 0, 128); //Pink
    7: keyColor := RGB(255, 0, 0); //Red
    6: keyColor := RGB(255, 128, 0); //Orange
    5: keyColor := RGB(255, 255, 0); //Yellow
    4: keyColor := RGB(128, 255, 0); //Lime
    3: keyColor := RGB(0, 255, 0); //Green
    2: keyColor := RGB(0, 255, 128); //Greenish
    1: keyColor := RGB(0, 255, 255); //Blueish
  end;

  //case rowIdx of
  //  1: arrayButton := kbArrayRow1;
  //  2: arrayButton := kbArrayRow2;
  //  3: arrayButton := kbArrayRow3;
  //  4: arrayButton := kbArrayRow4;
  //  5: arrayButton := kbArrayRow5;
  //  6: arrayButton := kbArrayRow6;
  //  7: arrayButton := kbArrayRow7;
  //end;

  if Length(arrayButton) > 0 then
  begin
    for i := 0 to Length(arrayButton) - 1 do
    begin
      arrayButton[i].BackColor := keyColor;
      //arrayButton[i].Repaint;
    end;
  end;
end;

procedure TFormMain.OpenColorDialog;
begin
  //jm todo
  //if (IndividualMode) and (IsKeyLoaded) then
  //begin
  //  if (ColorDialog1.Execute) then
  //  begin
  //    activeKbKey.KeyColor := ColorDialog1.Color;
  //    UpdateKeyButtonKey(activeKbKey, activeKeyBtn, true);
  //  end;
  //end;
end;

procedure TFormMain.continueClick(Sender: TObject);
begin
  CloseDialog(mrOk);
end;

procedure TFormMain.KeyButtonClick(Sender: TObject);
begin
  SetActiveKeyButton(sender as TLabelBox);
end;

procedure TFormMain.KeyButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFormMain.SetActiveKeyButton(keyButton: TLabelBox);
var
  aMenuAction: TMenuAction;
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

    if (keyButton = activeKeyBtn) or (keyButton = nil) or (ConfigMode = CONFIG_LIGHTING) then
      //((ConfigMode = CONFIG_LIGHTING) and (keyService.LedMode in [lmMonochrome, lmSpectrum, lmWave, lmReactive, lmStarlight, lmRebound, lmRipple, lmPitchBlack])) then
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
        ShowDialog('Select key', 'You cannot edit this key', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT);
      end;
    end;

    if not IsKeyLoaded then
    begin
      ResetPopupMenu;
      ResetPopupMenuMacro;
      ResetSingleKey;
    end;

    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);

    if (MacroMode) then
      OpenMacroScreen;

    //If popup menu is open, force click
    if (pnlMenu.Visible) and (lbMenu.ItemIndex >=0) and IsKeyLoaded then
    begin
      lbMenuClick(lbMenu);
    end
    else if (btnDisableKey.Down) or (btnLEDControl.Down) and IsKeyLoaded then
    begin
      if (btnDisableKey.Down) then
        aMenuAction := GetMenuActionByButton(btnDisableKey.Name)
      else
        aMenuAction := GetMenuActionByButton(btnLEDControl.Name);
      SetSingleKey(aMenuAction);
    end;
  end;
end;

function TFormMain.IsKeyLoaded: boolean;
begin
  result := (activeKeyBtn <> nil) and (activeKbKey <> nil);
end;

procedure TFormMain.SetKeyButtonText(keybutton: TLabelBox; btnText: string);
begin
  keyButton.Caption := btnText;
end;

function TFormMain.ValidateBeforeDone: boolean;
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
    ShowDialog(errorTitle, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT);

  result := isValid;
end;

function TFormMain.AcceptMacro: boolean;
var
  keyAssigned: string;
  extraInfo: string;
begin
  result := false;
  if ValidateBeforeDone then
  begin
    KeyModified := false;
    MacroModified := false;
    SetWindowsCombo(false);
    SetSaveState(ssModified, SaveStateLighting);
    activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0);
    if (activeKbKey.IsMacro) then
    begin
      if activeKbKey.ActiveMacro.CoTrigger1 <> nil then
        keyAssigned := activeKbKey.ActiveMacro.CoTrigger1.OtherDisplayText + ' + ' + activeKbKey.OriginalKey.OtherDisplayText
      else
        keyAssigned := activeKbKey.OriginalKey.OtherDisplayText;
    end;
    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
    SetActiveKeyButton(nil);
    RefreshRemapInfo;

    //Show message for assigned macro
    if (keyAssigned <> '') then
    begin
      if (activeLayer.LayerIndex = BOTLAYER_IDX) then
        extraInfo := ' in the embedded layer';
      ShowDialog('Macro', 'Macro assigned to ' + StringReplace(keyAssigned, #10, ' ', [rfReplaceAll]) + extraInfo, mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT);
    end;

    result := true;
    pnlMacro.Visible := false;
  end;
end;

procedure TFormMain.CancelMacro;
begin
  if (IsKeyLoaded) then
  begin
    KeyModified := false;
    MacroModified := false;
    SetWindowsCombo(false);
    keyService.RestoreMacro(activeKbKey); //Returns to previous values
    activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0) ;
    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
    SetActiveKeyButton(nil);
    RefreshRemapInfo;
    pnlMacro.Visible := false;
  end;
end;

procedure TFormMain.SetActiveLayer(layerIdx: integer);
begin
  activeLayer := keyService.GetLayer(layerIdx);
  LoadLayer(activeLayer);
end;

procedure TFormMain.UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox;
  unselectKey: boolean; fullLoad: boolean);
var
  fontSize:integer;
  fontName: string;
begin
  fontSize := 0;
  fontName := '';

  if (kbKey <> nil) and (keyButton <> nil) then
  begin
    if (ConfigMode = CONFIG_LAYOUT) then
    begin
      keyButton.BackColor := clNone;
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
    end;
    //else if (ConfigMode = CONFIG_LIGHTING) then
    //begin
    //  keyButton.Caption := ''; //kbKey.OriginalKey.DisplayText;
    //  if (keyService.LedMode in [lmIndividual, lmBreathe]) then
    //    keyButton.BackColor := kbKey.KeyColor
    //  else if (keyService.LedMode in [lmMonochrome]) then
    //    keyButton.BackColor := keyService.LedColorMono
    //  else if (keyService.LedMode in [lmReactive]) then
    //  keyButton.BackColor := keyService.LedColorReactive
    //  else
    //    keyButton.BackColor := clNone;
    //  keyButton.BorderStyle := bsNone;
    //  keyButton.BorderWidth := 1;
    //  keyButton.CornerSize := 10;
    //end;

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

    if not(fullLoad) then
      keyButton.Invalidate; //Repaint;
  end;
end;

function TFormMain.GetKeyOtherLayer(keyIdx: integer): TKBKey;
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

function TFormMain.GetKeyButtonByIndex(index: integer): TLabelBox;
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

function TFormMain.GetKeyButtonUnderMouse(x: integer; y:integer): TLabelBox;
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
      if (x >= keyButton.Left) and (x <= (keyButton.Left + keyButton.Width)) and
        (y >= keyButton.Top) and (y <= (keyButton.Top + keyButton.Height)) then
      begin
        result := keyButton;
        found := true;
      end;
    end;
    inc(i);
  end;
end;

procedure TFormMain.TopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MPos.X := X;
  MPos.Y := Y;
end;

procedure TFormMain.TopMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    self.Left := self.Left - (MPos.X-X);
    self.Top := self.Top - (MPos.Y-Y);
  end;
end;

procedure TFormMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.btnCloseMacroClick(Sender: TObject);
begin
  CancelMacro;
end;

procedure TFormMain.btnMouseClicksMacroClick(Sender: TObject);
var
  aButton: THSSpeedButton;
begin
  aButton := (sender as THSSpeedButton);
  if pnlMenuMacro.Visible and (activeMacroMenu = aButton.Name) then
    ResetPopupMenuMacro
  else
  begin
    SetMacroMenuItems(aButton);
    aButton.Down := false;
  end;
end;

procedure TFormMain.btnCommonShortcutsClick(Sender: TObject);
var
  aButton: THSSpeedButton;
begin
  aButton := (sender as THSSpeedButton);
  if pnlMenuMacro.Visible and (activeMacroMenu = aButton.Name) then
    ResetPopupMenuMacro
  else
  begin
    SetMacroMenuItems(aButton);
    aButton.Down := false;
  end;
end;

procedure TFormMain.btnDoneClick(Sender: TObject);
begin
  if IsKeyLoaded then
  begin
    if ValidateBeforeDone then
    begin
      KeyModified := false;
      MacroModified := false;
      SetSaveState(ssModified, SaveStateLighting);
      activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0);
      //SetMacroMode(false);
      SetActiveKeyButton(nil);
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMain.btnDoneMacroClick(Sender: TObject);
begin
  AcceptMacro;
end;

procedure TFormMain.btnCancelMacroClick(Sender: TObject);
begin
  CancelMacro;
end;

procedure TFormMain.btnCancelClick(Sender: TObject);
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

procedure TFormMain.btnHelpIconClick(Sender: TObject);
begin
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.SetFirmwareVersion(fileService.FirmwareVersion);
  FormAbout.ShowModal;
end;

procedure TFormMain.btnResetAllClick(Sender: TObject);
var
  sMessage: string;
begin
  if (ConfigMode = CONFIG_LAYOUT) then
  begin
    if ShowDialog('Reset layout',
          'Do you want to reset the current Layout?' + #10 + 'All remapped keys and stored macros in both layers will be lost.',
          mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT) = mrYes then
    begin
      CancelMacro;
      keyService.ResetLayout;
      LoadLayer(activeLayer);
      SetActiveKeyButton(nil);
      RefreshRemapInfo;
      SetSaveState(ssModified, SaveStateLighting);
    end;
  end
  else if (ConfigMode = CONFIG_LIGHTING) and (keyService.LedMode in [lmIndividual, lmBreathe]) then
  begin
    sMessage := 'Do you want to reset the current Lighting profile?' + #10 + 'All assigned colors will be lost.';
    if (keyService.LedMode = lmIndividual) then
      sMessage := 'Do you want to erase color assignments for each key';
    if ShowDialog('Reset Lighting', sMessage,
          mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT) = mrYes then
    begin
      ReloadKeyButtonsColor(true);
      SetSaveState(SaveStateLayout, ssModified);
    end;
  end;
end;

procedure TFormMain.btnTimingDelaysClick(Sender: TObject);
var
  timingDelay: integer;
begin
  try
    ResetPopupMenuMacro;
    NeedInput := True;
    timingDelay := ShowTimingDelays;
    if (timingDelay = 0) then
    begin
      SetModifiedKey(VK_RAND_DELAY, '', true);
    end
    else if (timingDelay >= MIN_TIMING_DELAY) and (timingDelay <= MAX_TIMING_DELAY) then
    begin
      SetModifiedKey(VK_MIN_DELAY + (timingDelay - 1), '', true);
    end;
  finally
    NeedInput := False;
  end;
end;

procedure TFormMain.btnWindowsCombosClick(Sender: TObject);
begin
  ResetPopupMenuMacro;
  SetWindowsCombo(not WindowsComboOn);
end;

procedure TFormMain.CheckVDriveTmrTimer(Sender: TObject);
begin
  CheckVDrive;
end;

procedure TFormMain.btnResetKeyClick(Sender: TObject);
var
  response: integer;
begin
  if IsKeyLoaded then
  begin
    if (not fileService.AppSettings.ResetKeyMsg) then
    begin
      response := ShowDialog('Reset current key',
        'Do you want to reset the current Key?' + #10 + 'The remapped key action and any stored macros will be lost.',
        mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT, nil, 'Hide this notification?');
      if (response >= DISABLE_NOTIF) then
      begin
        CancelMacro;
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
      SetSaveState(ssModified, SaveStateLighting);
      SetActiveKeyButton(nil);
    end;
    RefreshRemapInfo;
  end
  else
    ShowDialog('Reset key', 'You must select a key to reset', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT)
end;

procedure TFormMain.btnMinimizeClick(Sender: TObject);
begin
  try
    //self.Hide;
    //SetFormBorder(bsSingle);
    //sleep(100);
    Self.WindowState := wsMinimized;
  finally
    //self.Show;
  end;
end;


procedure TFormMain.btnMaximizeClick(Sender: TObject);
begin
  if (Self.WindowState = wsMaximized) then
  begin
    Self.WindowState := wsNormal;
    //MoveComponents(lblTitle.Top + lblTitle.Height, -10);
  end
  else
  begin
    Self.WindowState := wsMaximized;
    //MoveComponents(lblTitle.Top + lblTitle.Height, 10);
  end;
  UpdateStateSettings;
end;

procedure TFormMain.UpdateStateSettings;
begin
  //if (self.WindowState <> wsMinimized) then
  //  SetFormBorder(bsNone);

  if (Self.WindowState = wsMaximized) then
  begin
    //Disable Maximize
    Self.WindowState := wsNormal;
    //imageList.GetBitmap(1, btnMaximize.Glyph);
    //btnMaximize.Hint := 'Restore window';
  end
  else
  begin
    imageList.GetBitmap(0, btnMaximize.Glyph);
    btnMaximize.Hint := 'Maximize';
  end;

  oldWindowState := self.WindowState;
end;

procedure TFormMain.FormWindowStateChange(Sender: TObject);
begin
  UpdateStateSettings;
end;

//On application restore, remove borderstyle
procedure TFormMain.OnRestore(Sender: TObject);
begin
  //self.WindowState := wsNormal;
  //SetFormBorder(bsNone);

  //To repaint red color in macro box
  //SetMacroText(true);
end;

procedure TFormMain.SetFormBorder(formBorder: TFormBorderStyle);
begin
  {$ifdef Win64}
  self.BorderStyle := formBorder;
  RepaintForm(true);
  {$endif}
end;

procedure TFormMain.AppDeactivate(Sender: TObject);
begin
  keyService.ClearModifiers;
end;

procedure TFormMain.imgKeyboardLayoutClick(Sender: TObject);
begin
  ResetPopupMenu;
  ResetPopupMenuMacro;
  ResetSingleKey;
  if IsKeyLoaded then
  begin
    SetActiveKeyButton(nil);
  end;
end;

procedure TFormMain.imgMacroMenuClick(Sender: TObject);
begin

end;

procedure TFormMain.memoMacroChange(Sender: TObject);
begin

end;

procedure TFormMain.rgbChange(Sender: TObject);
begin
end;

procedure TFormMain.rgbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  iColor: integer;
begin
  if (key = VK_RETURN) or (key = VK_TAB) then
  begin
    if (eRed.Focused) then
      eGreen.SetFocus
    else if (eGreen.Focused) then
      eBlue.SetFocus
    else
      eHTML.SetFocus;
  end
  else if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    iColor := ConvertToInt((Sender as TEdit).Text, 0);
    if (Key = VK_UP) then
    begin
      if (iColor < 255) then
        inc(iColor)
      else
        iColor := 255;
    end
    else if (Key = VK_DOWN) then
    begin
      if (iColor > 0) then
        dec(iColor)
      else
        iColor := 0;
    end;
    (Sender as TEdit).Text := IntToStr(iColor);
  end;
end;

procedure TFormMain.rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    GetRBGEditColor;
  end;
end;

procedure TFormMain.GetRBGEditColor;
var
  iRed: integer;
  iGreen: integer;
  iBlue: integer;
begin
  iRed := ConvertToInt(eRed.Text, 0);
  iGreen := ConvertToInt(eGreen.Text, 0);
  iBlue := ConvertToInt(eBlue.Text, 0);

  if (iRed > 255) then
    iRed := 255;
  if (iGreen > 255) then
    iGreen := 255;
  if (iBlue > 255) then
    iBlue := 255;

  eRed.Text := IntToStr(iRed);
  eGreen.Text := IntToStr(iGreen);
  eBlue.Text := IntToStr(iBlue);

  ColorChange(RGB(iRed, iGreen, iBlue));
  AfterColorChange;
end;

procedure TFormMain.rgbExit(Sender: TObject);
begin
  GetRBGEditColor;
end;

procedure TFormMain.eHTMLChange(Sender: TObject);
begin
end;

procedure TFormMain.eHTMLExit(Sender: TObject);
var
  sHtml: string;
begin
  sHtml := eHTML.Text;
  if (Copy(eHTML.Text, 1, 1) = '#') then
    sHtml := Copy(eHTML.Text, 2, Length(eHTML.Text));
  if (Length(sHtml) = 6) then
  begin
    ColorChange(GetColorHTML(sHtml));
    AfterColorChange;
  end
  else
    eHTML.Text := GetHTMLColor(ringPicker.SelectedColor);
end;

procedure TFormMain.eHTMLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) or (key = VK_TAB) then
  begin
    eRed.SetFocus;
  end;
end;

procedure TFormMain.FormPaint(Sender: TObject);
begin

end;

procedure TFormMain.gifViewerStart(Sender: TObject);
begin
  if (keyService.LedMode in [lmBreathe, lmReactive, lmStarlight, lmRebound, lmRipple]) then
  begin
    ShowHideKeyButtons(true);
  end;
end;

procedure TFormMain.imgBackMacroClick(Sender: TObject);
begin
  ResetPopupMenuMacro;
end;

procedure TFormMain.imgKeyboardLightingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  keyButton: TLabelBox;
//  temp: TCursorImage;
begin
  if (keyService.LedMode in [lmIndividual, lmBreathe]) then
  begin
    keyButton := GetKeyButtonUnderMouse(X + imgKeyboardLighting.Left, Y + imgKeyboardLighting.Top);
    SetSingleKeyColor(keybutton, ringPicker.SelectedColor);
  end;
  //temp.LoadFromResourceName(temp.Handle, ');
  //showMessage('X:' + IntToStr(Mouse.CursorPos.X) + ', Y:' + IntToStr(Mouse.CursorPos.Y));
end;

procedure TFormMain.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win64}
  SendMessage(imgBackground.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardBack.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardLayout.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardLighting.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgLeftMenu.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgLeftMenuLighting.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}
  //jm todo SendMessage(memoMacro.Handle, LM_SETREDRAW, WPARAM(False), 0);
  {$endif}
end;

procedure TFormMain.GifIdleTimerTimer(Sender: TObject);
var i: integer;
begin
  GifIdleTimer.Enabled:= false;
  for i := 0 to high(gifImage) do
   with gifImage[i] do
   begin
      imageMacro.Update(paintBoxGif.Canvas,r);
   end;
  GifIdleTimer.Enabled:= true;
end;

procedure TFormMain.gifViewerClick(Sender: TObject);
begin

end;

procedure TFormMain.imgLeftMenuClick(Sender: TObject);
begin
  ResetPopupMenu;
  ResetSingleKey;
end;

procedure TFormMain.ResetPopupMenu;
begin
  pnlMenu.Visible := false;
end;

procedure TFormMain.ResetPopupMenuMacro;
begin
  pnlMenuMacro.Visible := false;
end;

procedure TFormMain.ResetSingleKey;
begin
  btnLEDControl.Down := false;
  btnDisableKey.Down := false;
  lblLedControl.Font.Color := clWhite;
  lblDisableKey.Font.Color := clWhite;
end;

procedure TFormMain.knobDirectionChange(Sender: TObject);
begin
  case Round(knobDirection.Position) of
    LED_DIR_DOWN_INT: lblDirectionText.Caption := 'D';
    LED_DIR_LEFT_INT: lblDirectionText.Caption := 'L';
    LED_DIR_UP_INT: lblDirectionText.Caption := 'U';
    LED_DIR_RIGHT_INT: lblDirectionText.Caption := 'R';
  end;

  //if (not loadingSettings) and (not loadingLedSettings) then
  //begin
  //  SetSaveState(SaveStateLayout, ssModified);
  //  knobDirection.Enabled := false;
  //  //LoadGif(Round(knobSpeed.Position), Round(knobDirection.Position));
  //  LoadGifTimer.Enabled := true;
  //  knobDirection.Enabled := true;
  //end;
end;

procedure TFormMain.knobDirectionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingLedSettings) then
  begin
    knobPos := knobDirection.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobDirection.Position := value;
    end;

    if (not loadingLedSettings) then
    begin
      keyService.LedDirection := Round(knobDirection.Position);
      SetSaveState(SaveStateLayout, ssModified);
      knobDirection.Enabled := false;
      //LoadGif(Round(knobSpeed.Position), Round(knobDirection.Position));
      LoadGifTimer.Enabled := true;
      knobDirection.Enabled := true;
    end;
  end;
end;

procedure TFormMain.knobRangeChange(Sender: TObject);
begin
  lblRangeText.Caption := IntToStr(Round(knobRange.Position));
end;

procedure TFormMain.knobRangeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    knobPos := knobRange.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobRange.Position := value;
    end;

    if (not loadingSettings) then
    begin
      //keyService.LedSpeed :=  Round(knobRange.Position);
    end;
  end;
end;

procedure TFormMain.knobSpeedChange(Sender: TObject);
begin
  lblSpeedText.Caption := IntToStr(Round(knobSpeed.Position));

  //if (not loadingSettings) and (not loadingLedSettings) then
  //begin
  //  SetSaveState(SaveStateLayout, ssModified);
  //  knobSpeed.Enabled := false;
  //  LoadGifTimer.Enabled := false;
  //  BreatheTimer.Enabled := false;
  //  //LoadGif(Round(knobSpeed.Position), Round(knobDirection.Position));
  //  if (keyService.LedMode = lmBreathe) then
  //  begin
  //    breatheDirection := 0;
  //    breatheTransparency := 0;;
  //    BreatheTimer.Enabled := true;
  //  end
  //  else
  //  begin
  //    LoadGifTimer.Enabled := true;
  //  end;
  //  knobSpeed.Enabled := true;
  //end;
end;

procedure TFormMain.knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    knobPos := knobSpeed.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobSpeed.Position := value;
    end;

    if (not loadingSettings) then
    begin
      keyService.LedSpeed := Round(knobSpeed.Position);
      SetSaveState(SaveStateLayout, ssModified);
      knobSpeed.Enabled := false;
      LoadGifTimer.Enabled := false;
      BreatheTimer.Enabled := false;
      //LoadGif(Round(knobSpeed.Position), Round(knobDirection.Position));
      if (keyService.LedMode = lmBreathe) then
      begin
        breatheDirection := 0;
        breatheTransparency := 0;
        BreatheTimer.Enabled := true;
      end
      else
      begin
        LoadGifTimer.Enabled := true;
      end;
      knobSpeed.Enabled := true;
    end;
  end;

end;

procedure TFormMain.miAddCustColorClick(Sender: TObject);
var
  custColor: TColor;
begin
  custColor := colorPreview.Color;

  if (custColor1.Color = DEFAULT_CUST_COLOR) then
    custColor1.Color := custColor
  else if (custColor2.Color = DEFAULT_CUST_COLOR) then
    custColor2.Color := custColor
  else if (custColor3.Color = DEFAULT_CUST_COLOR) then
    custColor3.Color := custColor
  else if (custColor4.Color = DEFAULT_CUST_COLOR) then
    custColor4.Color := custColor
  else if (custColor5.Color = DEFAULT_CUST_COLOR) then
    custColor5.Color := custColor
  else if (custColor6.Color = DEFAULT_CUST_COLOR) then
    custColor6.Color := custColor;
end;

procedure TFormMain.colorPreMixedClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorChange((Sender as TmbColorPreview).Color);
  AfterColorChange;
end;

procedure TFormMain.custColorClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  custColor: TColor;
begin
  custColor := (Sender as TmbColorPreview).Color;
  if (custColor <> clNone) then
  begin
    ColorChange(custColor);
    AfterColorChange;
  end;
end;

procedure TFormMain.custColorChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetCustomColor(custColor1.Color, 1);
    fileService.SetCustomColor(custColor2.Color, 2);
    fileService.SetCustomColor(custColor3.Color, 3);
    fileService.SetCustomColor(custColor4.Color, 4);
    fileService.SetCustomColor(custColor5.Color, 5);
    fileService.SetCustomColor(custColor6.Color, 6);
    fileService.SaveAppSettings;
  end;
end;

procedure TFormMain.colorPreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then   {check if left mouse button was pressed}
    colorPreview.BeginDrag(true);  {starting the drag operation}
end;

procedure TFormMain.custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Source is TmbColorPreview) then
    (Sender as TmbColorPreview).Color := (Source as TmbColorPreview).Color;
end;

procedure TFormMain.custColorDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source is TmbColorPreview) then
    Accept := true;
end;

procedure TFormMain.ringPickerChange(Sender: TObject);
begin
  if (not loadingColor) then
  begin
    ColorChange(ringPicker.SelectedColor);
    AfterColorChange;
  end;
end;

procedure TFormMain.ColorChange(newColor: TColor);
begin
  try
    loadingColor := true;
    ringPicker.SelectedColor := newColor;
    colorPreview.Color := newColor;
    eRed.Text := IntToStr(GetRValue(newColor));
    eGreen.Text := IntToStr(GetGValue(newColor));
    eBlue.Text := IntToStr(GetBValue(newColor));
    eHTML.Text := GetHTMLColor(newColor);

    if (not loadingSettings) and (not loadingLedSettings) then
    begin
      if (keyService.LedMode in [lmIndividual, lmBreathe]) and (IsKeyLoaded) then
      begin
        //activeKbKey.KeyColor := newColor;
        //UpdateKeyButtonKey(activeKbKey, activeKeyBtn, false);
      end
      else if (keyService.LedMode in [lmMonochrome]) then
      begin
        keyService.LedColorMono := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmReactive]) then
      begin
        keyService.LedColorReactive := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmStarlight]) then
      begin
        keyService.LedColorStarlight := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmRebound]) then
      begin
        keyService.LedColorRebound := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmRipple]) then
      begin
        keyService.LedColorRipple := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end;
    end;
  finally
    loadingColor := false;
  end;
end;

procedure TFormMain.AfterColorChange;
begin
  if (keyService.LedMode in [lmMonochrome, lmReactive, lmStarlight, lmRebound, lmRipple]) then
  begin
    ReloadKeyButtonsColor;
  end;
end;

procedure TFormMain.ChangeActiveLayer(layerIdx: integer);
begin
  if (not resetLayer) then
  begin
    if (CheckSaveKey(true)) then
    begin
      SetActiveLayer(layerIdx);
    end
    else
    begin
      resetLayer := true;
      swLayerSwitch.Checked := layerIdx = TOPLAYER_IDX;
    end;
  end;
  resetLayer := false;
end;

procedure TFormMain.swLayerSwitchClick(Sender: TObject);
begin
  if (swLayerSwitch.Checked) then
    ChangeActiveLayer(TOPLAYER_IDX)
  else
    ChangeActiveLayer(BOTLAYER_IDX);
end;

procedure TFormMain.TopMenuClick(Sender: TObject);
begin
  if (btnLayout.Down) then
  begin
    SetConfigMode(CONFIG_LAYOUT);
  end
  else if (btnLighting.Down) then
  begin
    SetConfigMode(CONFIG_LIGHTING);
  end;
end;

function TFormMain.GetMenuActionByButton(buttonName: string): TMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    if ((menuActionList.Items[i] as TMenuAction).ActionButton.Name = buttonName) then
    begin
      menuAction := (menuActionList.Items[i] as TMenuAction);
      Break;
    end;
  end;

  result := menuAction;
end;

function TFormMain.GetMenuActionByLabel(labelName: string): TMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    if ((menuActionList.Items[i] as TMenuAction).ActionLabel.Name = labelName) then
    begin
      menuAction := (menuActionList.Items[i] as TMenuAction);
      Break;
    end;
  end;

  result := menuAction;
end;

procedure TFormMain.ResetAllMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    menuAction := (menuActionList.Items[i] as TMenuAction);
    menuAction.ActionButton.Down := false;
    menuAction.ActionLabel.Font.Color := clWhite;
  end;
end;

procedure TFormMain.SetCurrentMenuAction(aButton: THSSpeedButton; aLsbel: TLabel);
var
  aMenuAction: TMenuAction;
begin
  if (aButton <> nil) then
    aMenuAction := GetMenuActionByButton(aButton.Name)
  else if (aLsbel <> nil) then
    aMenuAction := GetMenuActionByLabel(aLsbel.Name)
  else
    aMenuAction := nil;

  if (aMenuAction <> currentMenuAction) then
  begin
    ResetAllMenuAction;
    ResetPopupMenu;
    ResetPopupMenuMacro;
    ResetSingleKey;

    currentMenuAction := aMenuAction;
    if (currentMenuAction <> nil) then
    begin
      currentMenuAction.ActionButton.Down := true;
      currentMenuAction.ActionLabel.Font.Color := KINESIS_BLUE_EDGE;
      //SetMenuItems;
    end;

    if (ConfigMode = CONFIG_LAYOUT) then
    begin
      SetRemapMode(btnRemap.Down);
      SetMacroMode(btnMacro.Down);
    end;
    //SetIndividualMode(btnIndividual.Down);
  end;

  //btnMedia.Enabled := RemapMode;
  //lblMedia.Enabled := RemapMode;
  //btnMouseClicks.Enabled := RemapMode;
  //lblMouseClicks.Enabled := RemapMode;
  //btnAltLayouts.Enabled := RemapMode;
  //lblAltLayouts.Enabled := RemapMode;
  //btnDisableKey.Enabled := RemapMode;
  //lblDisableKey.Enabled := RemapMode;
  //btnFunctionKeys.Enabled := RemapMode;
  //lblFunctionKeys.Enabled := RemapMode;
  //btnNumericKeypad.Enabled := RemapMode;
  //lblNumericKeypad.Enabled := RemapMode;
  //btnFunctionAccess.Enabled := RemapMode;
  //lblFunctionAccess.Enabled := RemapMode;
  //btnLEDControl.Enabled := RemapMode;
  //lblLedControl.Enabled := RemapMode;
end;

procedure TFormMain.SetMenuItems(aMenuAction: TMenuAction);
var
  showTop: boolean;
  errorRemap: boolean;
  errorRemapAndKey: boolean;
begin
  ResetPopupMenu;
  ResetSingleKey;
  lbMenu.Items.Clear;
  showTop := false;
  errorRemap := false;
  errorRemapAndKey := false;

  if (aMenuAction.ActionLabel = lblMedia) then
  begin
    //if (RemapMode and IsKeyLoaded) then
    //begin
      lbMenu.Items.AddObject('Volume Up', TObject(VK_VOLUME_UP));
      lbMenu.Items.AddObject('Volume Down', TObject(VK_VOLUME_DOWN));
      lbMenu.Items.AddObject('Mute', TObject(VK_VOLUME_MUTE));
      lbMenu.Items.AddObject('Play/Pause', TObject(VK_MEDIA_PLAY_PAUSE));
      lbMenu.Items.AddObject('Previous Track', TObject(VK_MEDIA_PREV_TRACK));
      lbMenu.Items.AddObject('Next Track', TObject(VK_MEDIA_NEXT_TRACK));
    //end
    //else
    //  errorRemapAndKey := true;
  end
  else if (aMenuAction.ActionLabel = lblMouseClicks) then
  begin
    //if (RemapMode and IsKeyLoaded) then
    //begin
      lbMenu.Items.AddObject('Left Click', TObject(VK_MOUSE_LEFT));
      lbMenu.Items.AddObject('Middle Click', TObject(VK_MOUSE_MIDDLE));
      lbMenu.Items.AddObject('Right Click', TObject(VK_MOUSE_RIGHT));
      lbMenu.Items.AddObject('Button 4', TObject(VK_MOUSE_BTN4));
      lbMenu.Items.AddObject('Button 5', TObject(VK_MOUSE_BTN5));
    //end
    //else
    //  errorRemapAndKey := true;
  end
  else if (aMenuAction.ActionLabel = lblAltLayouts) then
  begin
    //if (RemapMode) then
    //begin
      lbMenu.Items.AddObject('Dvorak', TObject(VK_DVORAK));
      lbMenu.Items.AddObject('Colemak', TObject(VK_COLEMAK));
      lbMenu.Items.AddObject('Freestyle2 Hotkeys', TObject(VK_FS2_HOTKEYS));
      lbMenu.Items.AddObject('Freestyle Pro Hotkeys', TObject(VK_FSPRO_HOTKEYS));
    //end
    //else
    //  errorRemapAndKey := true;
  end
  else if (aMenuAction.ActionLabel = lblFunctionKeys) then
  begin
    //if (RemapMode and IsKeyLoaded) then
    //begin
      lbMenu.Items.AddObject('F13', TObject(VK_F13));
      lbMenu.Items.AddObject('F14', TObject(VK_F14));
      lbMenu.Items.AddObject('F15', TObject(VK_F15));
      lbMenu.Items.AddObject('F16', TObject(VK_F16));
      lbMenu.Items.AddObject('F17', TObject(VK_F17));
      lbMenu.Items.AddObject('F18', TObject(VK_F18));
      lbMenu.Items.AddObject('F19', TObject(VK_F19));
      lbMenu.Items.AddObject('F20', TObject(VK_F20));
      lbMenu.Items.AddObject('F21', TObject(VK_F21));
      lbMenu.Items.AddObject('F22', TObject(VK_F22));
      lbMenu.Items.AddObject('F23', TObject(VK_F23));
      lbMenu.Items.AddObject('F24', TObject(VK_F24));
    //end
    //else
    //  errorRemapAndKey := true;
  end
  else if (aMenuAction.ActionLabel = lblNumericKeypad) then
  begin
    //if (RemapMode) then
    //begin
      lbMenu.Items.AddObject('Full Keypad (Fn Layer)', nil);
      lbMenu.Items.AddObject('--------------------------', nil);
      lbMenu.Items.AddObject('Right Side', TObject(VK_NUMERIC_RIGHT));
      lbMenu.Items.AddObject('Left Side', TObject(VK_NUMERIC_LEFT));
      //if (IsKeyLoaded) then
      //begin
        showTop := true;
        lbMenu.Items.AddObject('', nil);
        lbMenu.Items.AddObject('Individual Actions', nil);
        lbMenu.Items.AddObject('---------------------', nil);
        lbMenu.Items.AddObject('0', TObject(VK_NUMPAD0));
        lbMenu.Items.AddObject('1', TObject(VK_NUMPAD1));
        lbMenu.Items.AddObject('2', TObject(VK_NUMPAD2));
        lbMenu.Items.AddObject('3', TObject(VK_NUMPAD3));
        lbMenu.Items.AddObject('4', TObject(VK_NUMPAD4));
        lbMenu.Items.AddObject('5', TObject(VK_NUMPAD5));
        lbMenu.Items.AddObject('6', TObject(VK_NUMPAD6));
        lbMenu.Items.AddObject('7', TObject(VK_NUMPAD7));
        lbMenu.Items.AddObject('8', TObject(VK_NUMPAD8));
        lbMenu.Items.AddObject('9', TObject(VK_NUMPAD9));
        lbMenu.Items.AddObject('Decimal', TObject(VK_DECIMAL));
        lbMenu.Items.AddObject('Plus', TObject(VK_ADD));
        lbMenu.Items.AddObject('Minus', TObject(VK_SUBTRACT));
        lbMenu.Items.AddObject('Divide', TObject(VK_DIVIDE));
        lbMenu.Items.AddObject('Multiply', TObject(VK_MULTIPLY));
        lbMenu.Items.AddObject('Enter', TObject(VK_NUMPADENTER));
        lbMenu.Items.AddObject('Num Lock', TObject(VK_NUMLOCK));
      //end;
    //end
    //else
    //  errorRemap := true;
  end
  else if (aMenuAction.ActionLabel = lblFunctionAccess) then
  begin
    //if (RemapMode and IsKeyLoaded) then
    //begin
      lbMenu.Items.AddObject('Fn Toggle', TObject(VK_FN_TOGGLE));
      lbMenu.Items.AddObject('Fn Shift', TObject(VK_FN_SHIFT));
    //end
    //else
    //  errorRemapAndKey := true;
  end;

  if (errorRemap) then
    ShowDialog('Remap', 'You must be in Remap mode', mtError, [mbOK], DEFAULT_DIAG_HEIGHT)
  else if (errorRemapAndKey) then
    ShowDialog('Remap', 'You must select a key on the keyboard', mtError, [mbOK], DEFAULT_DIAG_HEIGHT);

  if (lbMenu.Items.Count > 0) then
  begin
    pnlMenu.Height := (lbMenu.Items.Count * lbMenu.ItemHeight) + 10;
    if (showTop) then
      pnlMenu.Top := aMenuAction.ActionLabel.Top - pnlMenu.Height
    else
      pnlMenu.Top := aMenuAction.ActionLabel.Top + aMenuAction.ActionLabel.Height;
      pnlMenu.Visible := true;
    pnlMenu.Left:= aMenuAction.ActionLabel.Left;
  end;
  //if (currentMenuAction <> nil) then
  //begin
  //  if (currentMenuAction.ActionLabel = lblMedia) then
  //  begin
  //    lbMenu.Items.AddObject('Volume Up', TObject(VK_VOLUME_UP));
  //    lbMenu.Items.AddObject('Volume Down', miVolumeDown);
  //    lbMenu.Items.AddObject('Mute', miMute);
  //    lbMenu.Items.AddObject('Play/Pause', miPlayPause);
  //    lbMenu.Items.AddObject('Previous Track', miPreviousTrack);
  //    lbMenu.Items.AddObject('Next Track', miNextTrack);
  //  end
  //  else if (currentMenuAction.ActionLabel = lblMouseClicks) then
  //  begin
  //    lbMenu.Items.AddObject('Left Click', miLeftMouse);
  //    lbMenu.Items.AddObject('Middle Click', miMiddleMouse);
  //    lbMenu.Items.AddObject('Right Click', miRightMouse);
  //    lbMenu.Items.AddObject('Button 4', miBtn4Mouse);
  //    lbMenu.Items.AddObject('Button 5', miBtn5Mouse);
  //  end;
  //
  //  if (lbMenu.Items.Count > 0) then
  //  begin
  //    pnlMenu.Top := currentMenuAction.ActionLabel.Top + currentMenuAction.ActionLabel.Height;
  //    pnlMenu.Left:= currentMenuAction.ActionLabel.Left;
  //    pnlMenu.Visible := true;
  //    pnlMenu.Height := (lbMenu.Items.Count * lbMenu.ItemHeight) + 10;
  //  end;
  //end;
end;

procedure TFormMain.SetMacroMenuItems(button: THSSpeedButton);
var
  showTop: boolean;
  errorRemap: boolean;
  errorRemapAndKey: boolean;
begin
  ResetPopupMenuMacro;
  lbMenuMacro.Items.Clear;
  showTop := false;
  activeMacroMenu := button.Name;

  if (button = btnCommonShortcuts) then
  begin
    lbMenuMacro.Items.AddObject('Cut', TObject(VK_CUT));
    lbMenuMacro.Items.AddObject('Copy', TObject(VK_COPY));
    lbMenuMacro.Items.AddObject('Paste', TObject(VK_PASTE));
    lbMenuMacro.Items.AddObject('Select All', TObject(VK_SELECTALL));
    lbMenuMacro.Items.AddObject('Undo', TObject(VK_UNDO));
    lbMenuMacro.Items.AddObject('Redo', TObject(VK_REDO));
    lbMenuMacro.Items.AddObject('Desktop', TObject(VK_DESKTOP));
    lbMenuMacro.Items.AddObject('Last App', TObject(VK_LASTAPP));
    lbMenuMacro.Items.AddObject('Ctrl Alt Delete', TObject(VK_CTRLALTDEL));
  end
  else if (button = btnMouseClicksMacro) then
  begin
    lbMenuMacro.Items.AddObject('Left Click', TObject(VK_MOUSE_LEFT));
    lbMenuMacro.Items.AddObject('Middle Click', TObject(VK_MOUSE_MIDDLE));
    lbMenuMacro.Items.AddObject('Right Click', TObject(VK_MOUSE_RIGHT));
    lbMenuMacro.Items.AddObject('Button 4', TObject(VK_MOUSE_BTN4));
    lbMenuMacro.Items.AddObject('Button 5', TObject(VK_MOUSE_BTN5));
    lbMenuMacro.Items.AddObject('Double-Click', TObject(VK_MOUSE_DBL_125));
  end;

  if (lbMenuMacro.Items.Count > 0) then
  begin
    pnlMenuMacro.Height := (lbMenuMacro.Items.Count * lbMenuMacro.ItemHeight) + 10;
    pnlMenuMacro.Top := (pnlMacro.Top + button.Top) - pnlMenuMacro.Height;
    pnlMenuMacro.Left := pnlMacro.Left + button.Left;
    pnlMenuMacro.Visible := true;
  end;
end;

procedure TFormMain.lbMenuClick(Sender: TObject);
var
  //menuItem: TMenuItem;
  mnuAction: Integer;
  customBtns: TCustomButtons;
begin
  if (lbMenu.ItemIndex >= 0) and (lbMenu.Items.Objects[lbMenu.ItemIndex] <> nil) then
  begin
    mnuAction := Integer(lbMenu.Items.Objects[lbMenu.ItemIndex]);
    if (mnuAction > 0) then
    begin
      if (mnuAction = VK_DVORAK) or (mnuAction = VK_COLEMAK) then
      begin
        if (mnuAction = VK_DVORAK) then
        begin
          createCustomButton(customBtns, 'Both Layers', 100, @setDvorakBothLayers);
          createCustomButton(customBtns, 'Top Layer', 100, @setDvorakTopLayer);
          createCustomButton(customBtns, 'Fn Layer', 100, @setDvorakFnLayer);
          createCustomButton(customBtns, 'Cancel', 100, nil, bkCancel);
        end
        else if (mnuAction = VK_COLEMAK) then
        begin
          createCustomButton(customBtns, 'Both Layers', 100, @setColemakBothLayers);
          createCustomButton(customBtns, 'Top Layer', 100, @setColemakTopLayer);
          createCustomButton(customBtns, 'Fn Layer', 100, @setColemakFnLayer);
          createCustomButton(customBtns, 'Cancel', 100, nil, bkCancel);
        end;

        ShowDialog('Alternate Layout',
          'To which Layer would you like to apply this alternate layout?' + #10#10 +
          'Note: Implementing this layout may overwrite existing remaps.',
          mtWarning, [], DEFAULT_DIAG_HEIGHT, customBtns);
      end
      else if (mnuAction  = VK_NUMERIC_RIGHT) then
      begin
        SetFnNumericKpRight;
        ResetPopupMenu;
        ResetSingleKey;
      end
      else if (mnuAction = VK_NUMERIC_LEFT) then
      begin
        SetFnNumericKpLeft;
        ResetPopupMenu;
        ResetSingleKey;
      end
      else if (mnuAction = VK_FS2_HOTKEYS) then
      begin
        SetFreestyle2Hotkeys;
        ResetPopupMenu;
        ResetSingleKey;
      end
      else if (mnuAction = VK_FSPRO_HOTKEYS) then
      begin
        SetFreestyleProHotkeys;
        ResetPopupMenu;
        ResetSingleKey;
      end
      else
      begin
        if (IsKeyLoaded) then
        begin
          SetModifiedKey(mnuAction, '', false, true, true);
          ResetPopupMenu;
          ResetSingleKey;
        end;
      end;
    end;
  end;
end;

procedure TFormMain.lbMenuMacroClick(Sender: TObject);
var
  //menuItem: TMenuItem;
  mnuAction: Integer;
  customBtns: TCustomButtons;
begin
  if (MacroMode and pnlMacro.Visible) and (lbMenuMacro.ItemIndex >= 0) and
    (lbMenuMacro.Items.Objects[lbMenuMacro.ItemIndex] <> nil) then
  begin
    mnuAction := Integer(lbMenuMacro.Items.Objects[lbMenuMacro.ItemIndex]);
    if (mnuAction > 0) then
    begin
      if (mnuAction = VK_CUT) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_X, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_X, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_COPY) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_C, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_C, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_PASTE) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_V, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_V, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_PASTE) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_V, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_V, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_SELECTALL) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_A, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_A, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_UNDO) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_Z, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_Z, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_REDO) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_Y, L_CTRL_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_Y, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_DESKTOP) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_D, L_WIN_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_D, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_LASTAPP) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_TAB, L_ALT_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_TAB, L_ALT_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_CTRLALTDEL) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_DELETE, L_CTRL_MOD + ',' + L_ALT_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_DELETE, L_CTRL_MOD + ',' + L_ALT_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_MOUSE_DBL_125) then
      begin
        SetModifiedKey(VK_MOUSE_LEFT, '', true);
        SetModifiedKey(VK_MIN_DELAY + 124, '', true);
        SetModifiedKey(VK_MOUSE_LEFT, '', true);
      end
      else
      begin
        if (IsKeyLoaded) then
        begin
          SetModifiedKey(mnuAction, '', true);
        end;
      end;

      ResetPopupMenuMacro;
    end;
  end;
end;

procedure TFormMain.lbMenuDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  //with (Control as TListBox).Canvas do
  //begin
  //  if odSelected in State then
  //    Brush.Color := KINESIS_BLUE_EDGE;
  //
  //  FillRect(ARect);
  //  TextOut(ARect.Left, ARect.Top, (Control as TListBox).Items[Index]);
  //  if odFocused In State then begin
  //    Brush.Color := clWhite;//(Control as TListBox).Color;
  //    DrawFocusRect(ARect);
  //  end;
  //end;
  with (Control as TListBox).Canvas do begin
    if odSelected in State then
    begin
      Brush.Color := KINESIS_BLUE_EDGE;
      Font.Color := clWhite;
    end else
    begin
      Brush.Color := KINESIS_DARK_GRAY_FS;
      Font.Color := clWhite;
    end;
    FillRect(ARect);
    TextOut(ARect.Left + 2, ARect.Top, (Control as TListBox).Items[index]);
  end;
end;

procedure TFormMain.SetFnNumericKpLeft;
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
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT) = mrYes then
    begin
      aFnLayer := keyService.GetLayer(BOTLAYER_IDX);
      if (aFnLayer <> nil) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);

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

procedure TFormMain.SetFnNumericKpRight;
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
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT) = mrYes then
    begin
      aFnLayer := keyService.GetLayer(BOTLAYER_IDX);
      if (aFnLayer <> nil) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);

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

procedure TFormMain.SetFreestyle2Hotkeys;
var
  aMacro: TKeyList;
begin
  if CheckSaveKey(true) then
  begin
    if ShowDialog('Alternate Layout', 'Insert Freestyle2 Hotkeys?' + #10#10 + 'Note: Implementing this layout may overwrite existing macros/remaps.',
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT) = mrYes then
    begin
      aMacro := TKeyList.Create;
      KeyModified := true;
      MacroModified := true;
      SetSaveState(ssModified, SaveStateLighting);

      //HK1 - lalt + left
      aMacro.Add(keyService.GetKeyWithModifier(VK_LEFT, GetKeyModifierText(VK_LMENU)));
      keyService.SetKeyMacroIdx(activeLayer, 17, aMacro);

      //HK2 - lalt + right
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_RIGHT, GetKeyModifierText(VK_LMENU)));
      keyService.SetKeyMacroIdx(activeLayer, 18, aMacro);

      //HK3 - LCONTROL + Z
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_Z, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 34, aMacro);

      //HK4 - lalt + home
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_HOME, GetKeyModifierText(VK_LMENU)));
      keyService.SetKeyMacroIdx(activeLayer, 35, aMacro);

      //HK5 - lcontrol + x
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_X, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 51, aMacro);

      //HK6 - Del
      keyService.SetKBKeyIdx(activeLayer, 52, VK_DELETE);

      //HK7 - lcontrol + c
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_C, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 67, aMacro);

      //HK8 - lcontrol + v
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_V, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 68, aMacro);

      ReloadKeyButtons;
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMain.SetFreestyleProHotkeys;
var
  aMacro: TKeyList;
begin
  if CheckSaveKey(true) then
  begin
    if ShowDialog('Alternate Layout', 'Insert Freestyle Pro Hotkeys?' + #10#10 + 'Note: Implementing this layout may overwrite existing macros/remaps.',
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT) = mrYes then
    begin
      aMacro := TKeyList.Create;
      KeyModified := true;
      MacroModified := true;
      SetSaveState(ssModified, SaveStateLighting);

      //HK1 - lwin + d
      aMacro.Add(keyService.GetKeyWithModifier(VK_D, GetKeyModifierText(VK_LWIN)));
      keyService.SetKeyMacroIdx(activeLayer, 17, aMacro);

      //HK2 - lalt + tab
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_TAB, GetKeyModifierText(VK_LMENU)));
      keyService.SetKeyMacroIdx(activeLayer, 18, aMacro);

      //HK3 - LCONTROL + A
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_A, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 34, aMacro);

      //HK4 - lcontrol + Z
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_Z, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 35, aMacro);

      //HK5 - lcontrol + x
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_X, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 51, aMacro);

      //HK6 - Del
      keyService.SetKBKeyIdx(activeLayer, 52, VK_DELETE);

      //HK7 - lcontrol + c
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_C, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 67, aMacro);

      //HK8 - lcontrol + v
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_V, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(activeLayer, 68, aMacro);

      ReloadKeyButtons;
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMain.setDvorakBothLayers(Sender: TObject);
begin
  SetDvorakKb(0, true);
end;

procedure TFormMain.setDvorakTopLayer(Sender: TObject);
begin
  SetDvorakKb(TOPLAYER_IDX, false);
end;

procedure TFormMain.setDvorakFnLayer(Sender: TObject);
begin
  SetDvorakKb(BOTLAYER_IDX, false);
end;

procedure TFormMain.setColemakBothLayers(Sender: TObject);
begin
  SetColemakKb(0, true);
end;

procedure TFormMain.setColemakTopLayer(Sender: TObject);
begin
  SetColemakKb(TOPLAYER_IDX, false);
end;

procedure TFormMain.setColemakFnLayer(Sender: TObject);
begin
  SetColemakKb(BOTLAYER_IDX, false);
end;

procedure TFormMain.SetDvorakKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey(true) then
  begin
    CloseDialog(mrOk);

    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      aLayer := keyService.KBLayers[i];
      if (aLayer <> nil) and (bothLayers or (layerIdx = i)) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);

        keyService.SetKBKeyIdx(aLayer, 30, VK_LCL_OPEN_BRACKET);  //Replace -
        keyService.SetKBKeyIdx(aLayer, 31, VK_LCL_CLOSE_BRACKET);  //Replace =
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
    ResetPopupMenu;
    ResetSingleKey;
  end;
end;

procedure TFormMain.SetColemakKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey(true) then
  begin
    CloseDialog(mrOk);

    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      aLayer := keyService.KBLayers[i];
      if (aLayer <> nil) and (bothLayers or (layerIdx = i)) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);

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
    ResetPopupMenu;
    ResetSingleKey;
  end;
end;

function TFormMain.GetCursorNextKey(cursorPos: integer): integer;
var
  i:integer;
  keyIdx: integer;
  newKeyIdx: integer;
begin
  result := -1;
  if (IsKeyLoaded and MacroMode and (cursorPos < LengthUTF8(memoMacro.Text))) then
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

function TFormMain.GetCursorPrevKey(cursorPos: integer): integer;
var
  i:integer;
  keyIdx: integer;
  prevKeyIdx: integer;
begin
  result := -1; //cursorPos - 1;
  if (IsKeyLoaded and MacroMode and (cursorPos > 1)) then
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

procedure TFormMain.SetModifiedKey(key: word; Modifiers: string;
  isMacro: boolean; bothLayers: boolean; force: boolean);
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
    if (isMacro) and (MacroMode) then
    begin
      nbKeystrokes := keyService.CountKeystrokes(activeKbKey.ActiveMacro);
      inc(nbKeystrokes);
      nbKeystrokes := nbKeystrokes + (keyService.CountModifiers(Modifiers) * 2);
      if (nbKeystrokes > MAX_KEYSTROKES_FS) then
        ShowDialog('Maximum Length Reached', 'Macros are limited to approximately 300 characters.',
          mtError, [mbOK], DEFAULT_DIAG_HEIGHT)
      else
      begin
        //First keystroke in macro assign 1 to multiplay position
        //jm temp
        //if (nbKeystrokes = 1) then
        //begin
        //  tbMultiplay.Position := 1;
        //  slMacroMultiplay.Position := 1;
        //end;
        //jm temp
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
    else if (not MacroModified) and (RemapMode or force) then
    begin
      isDiffKey := (activeKbKey.IsModified and (activeKbKey.ModifiedKey.Key <> key)) or
        ((not activeKbKey.IsModified) and (activeKbKey.OriginalKey.Key <> key));

      //Checks if key is really modified
      if (isDiffKey) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);
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

procedure TFormMain.MenuButtonClick(Sender: TObject);
var
  aButton: THSSpeedButton;
begin
  aButton := (sender as THSSpeedButton);
  if (currentMenuAction <> nil) and (currentMenuAction.ActionButton = aButton) then
    SetCurrentMenuAction(nil, nil)
  else
  begin
    SetCurrentMenuAction(aButton, nil);
    if (ConfigMode = CONFIG_LIGHTING) then
    begin
      SetLedMode(GetLedMode);
      SetSaveState(SaveStateLayout, ssModified);
    end;
  end;

  //UpdateMenu;
end;


procedure TFormMain.MenuLabelClick(Sender: TObject);
var
  aLabel: TLabel;
begin
  aLabel := (sender as TLabel);
  if (currentMenuAction <> nil) and (currentMenuAction.ActionLabel = aLabel) then
    SetCurrentMenuAction(nil, nil)
  else
  begin
    SetCurrentMenuAction(nil, aLabel);
    if (ConfigMode = CONFIG_LIGHTING) then
    begin
      SetLedMode(GetLedMode);
      SetSaveState(SaveStateLayout, ssModified);
    end;
  end;
  //if (aButton.Down) then
  //  currentMenuAction := aButton
  //else
  //  currentMenuAction := nil;
  //
  //UpdateMenu;
  //IF (aLabel = lblMedia) THEN
end;

procedure TFormMain.SingleKeyLabelClick(Sender: TObject);
var
  aLabel: TLabel;
  aMenuAction: TMenuAction;
begin
  ResetPopupMenu;
  ResetSingleKey;
  aLabel := (sender as TLabel);
  aMenuAction := GetMenuActionByLabel(aLabel.Name);
  SetSingleKey(aMenuAction);
end;

procedure TFormMain.SingleKeyMenuClick(Sender: TObject);
var
  aButton: THSSpeedButton;
  aMenuAction: TMenuAction;
begin
  ResetPopupMenu;
  ResetSingleKey;
  aButton := (sender as THSSpeedButton);
  aMenuAction := GetMenuActionByButton(aButton.Name);
  //aButton.Down := false;
  SetSingleKey(aMenuAction);
end;

procedure TFormMain.SetSingleKey(aMenuAction: TMenuAction);
begin
  if (IsKeyLoaded) then
  begin
    if (aMenuAction.FActionButton = btnDisableKey) then
      SetModifiedKey(VK_NULL, '', false, true, true)
    else if (aMenuAction.FActionButton = btnLEDControl) then
      SetModifiedKey(VK_LED, '', false, true, true);
    ResetSingleKey;
  end
  else
  begin
    aMenuAction.ActionButton.Down := true;
    aMenuAction.ActionLabel.Font.Color := KINESIS_BLUE_EDGE;
  end;
  //else
 //   ShowDialog('Remap', 'You must select a key on the keyboard', mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
end;

procedure TFormMain.PopupMenuClick(Sender: TObject);
var
  aButton: THSSpeedButton;
  aMenuAction: TMenuAction;
begin
  aButton := (sender as THSSpeedButton);
  aMenuAction := GetMenuActionByButton(aButton.Name);
  SetMenuItems(aMenuAction);
  aButton.Down := false;
end;

procedure TFormMain.PopupLabelClick(Sender: TObject);
var
  aLabel: TLabel;
  aMenuAction: TMenuAction;
begin
  aLabel := (sender as TLabel);
  aMenuAction := GetMenuActionByLabel(aLabel.Name);
  SetMenuItems(aMenuAction);
end;

procedure TFormMain.UpdateMenu;
begin
  lblRemap.Font.Color := clWhite;
  lblMacro.Font.Color := clWhite;
  lblMedia.Font.Color := clWhite;

  //if (currentMenuButton = btnRemap) then
  //  lblRemap.Font.Color := KINESIS_BLUE_EDGE
  //else if (currentMenuButton = btnMacro) then
  //  lblMacro.Font.Color := KINESIS_BLUE_EDGE
  //else if (currentMenuButton = btnMedia) then
  //  lblMedia.Font.Color := KINESIS_BLUE_EDGE;
end;


procedure TFormMain.btnMenuClick(Sender: TObject);
begin
  menuButtonUpdate(sender);
end;

procedure TFormMain.menuButtonUpdate(Sender: TObject);
var
  aButton: THSSpeedButton;
begin
  aButton := (Sender as THSSpeedButton);
  if (aButton.Down) then
    aButton.Font.Color := KINESIS_BLUE_EDGE;
end;

procedure TFormMain.AddGifImage(filename: string; zoom: single);
var
    w,h: integer;
    i:integer;
begin
  gifBackground := TMemBitmap.Create(0,0);
  setlength(gifImage,length(gifImage)+1);
  with gifImage[high(gifImage)] do
  begin
    imageMacro := TAnimatedGif.Create(filename);
    imageMacro.EraseColor := self.Color;
    w := round(imageMacro.width *zoom);
    h := round(imageMacro.height *zoom);
    r.left := random(paintBoxGif.width- w);
    r.top := random(paintBoxGif.height- h);
    r.right := r.left + w;
    r.bottom := r.top + h;
  end;
  ResetGifAnimCanvas;
end;

procedure TFormMain.ResetGifAnimCanvas;
begin
  GifIdleTimer.Enabled:= false;
  paintBoxGifPaint(self);
end;

procedure TFormMain.UpdateGifBackground;
begin
//var xb,yb,w,h,x,y: integer;
//    p : PMemPixel;
//    i: integer;
//begin
//  w := paintBoxGif.Width;
//  h := paintBoxGif.Height;
//  if (gifBackground.Width <> w) or (gifBackground.Height <> h) then
//  begin
//    gifBackground.SetSize(w,h);
//
//    for yb := 0 to h-1 do
//    begin
//     p := gifBackground.Scanline[yb];
//     for xb := 0 to w-1 do
//     begin
//       p^:= MemPixel(255- xb*32 div w,255- xb*32 div w,255,255);
//       inc(p);
//     end;
//    end;
//
//    for i := 1 to w*h div 20000 do
//    begin
//      x := random(w+100)-50;
//      y := random(h+100)-50;
//      gifBackground.FillRect(x,y,x+random(200),y+random(200),MemPixel(random(255),random(255),random(255),32),dmDrawWithTransparency );
//      gifBackground.Rectangle(random(w),random(h),random(w+1),random(h+1),MemPixel(random(255),random(255),random(255),32),dmDrawWithTransparency);
//    end;
//
//    gifBackground.InvalidateBitmap;
//  end;
end;

procedure TFormMain.paintBoxGifPaint(Sender: TObject);
var
    i:integer;
begin
  UpdateGifBackground;
  gifBackground.Draw(paintBoxGif.Canvas,ClientRect);
  for i := 0 to high(gifImage) do
    with gifImage[i] do paintBoxGif.Canvas.StretchDraw(r,imageMacro);
  GifIdleTimer.Enabled:= true;
  paintBoxGif.SendToBack;
end;


//Macro section

procedure TFormMain.OpenMacroScreen;
var
  canOpen: boolean;
begin
  canOpen := false;
  if IsKeyLoaded then
  begin
    canOpen := MacroMode and (activeKbKey.CanAssignMacro);
    //jm temp MacroModified := false;
  end;

  if (canOpen) then
  begin
    if (not pnlMacro.Visible) then
    begin
      pnlMacro.Left := (FormMain.Width) - pnlMacro.Width - 10;
      pnlMacro.Top := FormMain.Height - pnlMacro.Height - 50;
      SetWindowsCombo(false);
      pnlMacro.Visible := true;
      pnlMacro.BringToFront;
    end;
    keyService.BackupMacro(activeKbKey);

    rgMacro1.Checked := true;
    memoMacro.Text := '';
    LoadMacro;
    SetMacroText(true);
  end
  else
    pnlMacro.Visible := false;
end;

procedure TFormMain.LoadMacro;
begin
  loadingMacro := true;
  ResetMacroCoTriggers;
  lastKeyDown := 0; //Resets last key down
  lastKeyPressed := 0; //Resets last key pressed
  keyService.ClearModifiers; //Removes all modifiers from memory

  if (IsKeyLoaded) then
  begin
    if (rgMacro1.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro1
    else if (rgMacro2.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro2
    else if (rgMacro3.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro3;

    if (activeKbKey.ActiveMacro.MacroSpeed >= MACRO_SPEED_MIN) and (activeKbKey.ActiveMacro.MacroSpeed <= MACRO_SPEED_MAX) then
    begin
      knobMacroSpeed.Position := activeKbKey.ActiveMacro.MacroSpeed
    end
    else
    begin
      knobMacroSpeed.Position := DEFAULT_MACRO_SPEED;
    end;

    if (activeKbKey.ActiveMacro.MacroRptFreq >= MACRO_FREQ_MIN) and (activeKbKey.ActiveMacro.MacroRptFreq <= MACRO_FREQ_MAX) then
    begin
      knobMultiplay.Position := activeKbKey.ActiveMacro.MacroRptFreq
    end
    else
    begin
      knobMultiplay.Position := DEFAULT_MACRO_FREQ;
    end;

    if activeKbKey.Macro1.Count > 0 then
      lblMacro1.Font.Color := blueColor
    else
    begin
      lblMacro1.Font.Color := fontColor;
      activeKbKey.Macro1.CoTrigger1 := nil;
    end;
    if activeKbKey.Macro2.Count > 0 then
      lblMacro2.Font.Color := blueColor
    else
    begin
      lblMacro2.Font.Color := fontColor;
      activeKbKey.Macro2.CoTrigger1 := nil;
    end;
    if activeKbKey.Macro3.Count > 0 then
      lblMacro3.Font.Color := blueColor
    else
    begin
      lblMacro3.Font.Color := fontColor;
      activeKbKey.Macro3.CoTrigger1 := nil;
    end;

    SetCoTrigger(activeKbKey.ActiveMacro.CoTrigger1);
  end;

  loadingMacro := false;
end;

procedure TFormMain.rgMacroClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
  begin
    SetWindowsCombo(false);
    LoadMacro;
    SetMacroText(true);
  end;
end;

procedure TFormMain.SetCoTrigger(aKey: TKey);
begin
  if (aKey <> nil) then
  begin
    if (aKey.Key = VK_LSHIFT) then
      ActivateCoTrigger(kbLeftShift);
    if (aKey.Key = VK_LCONTROL) then
      ActivateCoTrigger(kbLeftCtrl);
    if (aKey.Key = VK_LMENU) then
      ActivateCoTrigger(kbLeftAlt);
    if (aKey.Key = VK_RSHIFT) then
      ActivateCoTrigger(kbRightShift);
    if (aKey.Key = VK_RCONTROL) then
      ActivateCoTrigger(kbRightCtrl);
    if (aKey.Key = VK_RMENU) then
      ActivateCoTrigger(kbRightAlt);
  end;
end;

procedure TFormMain.ActivateCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BorderWidth := 1;
  keyButton.BorderColor := blueColor;
  keyButton.BorderStyle := bsSingle;
  keyButton.Repaint;
end;

//Resets co-trigger buttons to default values
procedure TFormMain.ResetMacroCoTriggers;
begin
  ResetCoTrigger(kbLeftShift);
  ResetCoTrigger(kbRightShift);
  ResetCoTrigger(kbLeftCtrl);
  ResetCoTrigger(kbRightCtrl);
  ResetCoTrigger(kbLeftAlt);
  ResetCoTrigger(kbRightAlt);
end;

procedure TFormMain.ResetCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BackColor := clNone;
  keyButton.BorderColor := clNone;
  keyButton.BorderStyle := bsNone;
  keyButton.Repaint;
end;

function TFormMain.GetCoTriggerKey(Sender: TObject): TKey;
begin
  if (Sender = kbLeftShift) then
    result := keyService.FindKeyConfig(VK_LSHIFT)
  else if (Sender = kbRightShift) then
    result := keyService.FindKeyConfig(VK_RSHIFT)
  else if (Sender = kbLeftCtrl) then
    result := keyService.FindKeyConfig(VK_LCONTROL)
  else if (Sender =  kbRightCtrl) then
    result := keyService.FindKeyConfig(VK_RCONTROL)
  else if (Sender = kbLeftAlt) then
    result := keyService.FindKeyConfig(VK_LMENU)
  else if (Sender = kbRightAlt) then
    result := keyService.FindKeyConfig(VK_RMENU)
  else
    result := nil;
end;

procedure TFormMain.RemoveCoTrigger(key: word);
begin
  if IsKeyLoaded then
  begin
    MacroModified := true;
    if (activeKbKey.ActiveMacro.CoTrigger1 <> nil) and (activeKbKey.ActiveMacro.CoTrigger1.Key = key) then
      activeKbKey.ActiveMacro.CoTrigger1 := nil;
  end;
end;

procedure TFormMain.btnCopyClick(Sender: TObject);
var
  hideNotif: integer;
begin
  if (IsKeyLoaded) then
  begin
    ResetPopupMenuMacro;
    if (activeKbKey.ActiveMacro <> nil) then
    begin
      copiedMacro := keyService.CopyMacro(activeKbKey.ActiveMacro);
      if (not fileService.AppSettings.CopyMacroMsg) then
      begin
        hideNotif := ShowDialog('Copy', 'Macro copied. Now select a new trigger key or load a new layout, then hit Paste.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetCopyMacroMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
    end
    else
      ShowDialog('Copy Macro', 'You must have an active maro to copy', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT);
  end;
end;

procedure TFormMain.btnPasteClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
  begin
    ResetPopupMenuMacro;
    if (activeKbKey.ActiveMacro <> nil) and (copiedMacro <> nil) then
    begin
      activeKbKey.IsMacro := true;
      activeKbKey.ActiveMacro.Assign(copiedMacro);
      SetMacroText(true);
      LoadMacro;
      MacroModified := true;
    end;
  end;
end;

procedure TFormMain.btnBackspaceMacroClick(Sender: TObject);

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
    ResetPopupMenuMacro;
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

procedure TFormMain.btnClearMacroClick(Sender: TObject);
begin
  if (IsKeyLoaded) and (activeKbKey.IsMacro) then
  begin
    ResetPopupMenuMacro;
    memoMacro.Lines.Clear;
    keyService.ClearModifiers;
    activeKbKey.ActiveMacro.Clear;
    activeKbKey.ActiveMacro.CoTrigger1 := nil;
    ResetMacroCoTriggers;
    MacroModified := true;
  end;
end;

procedure TFormMain.knobMultiplayChange(Sender: TObject);
var
  value: integer;
begin
  value := Round(knobMultiplay.Position);
  if (value = 0) then
    lblMultiplayText.Caption := 'R'
  else
    lblMultiplayText.Caption := IntToStr(value);
end;

procedure TFormMain.knobMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingMacro) then
  begin
    knobPos := knobMultiplay.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobMultiplay.Position := value;
    end;

    if (not loadingMacro) then
    begin
      activeKbKey.ActiveMacro.MacroRptFreq := Round(knobMultiplay.Position);
      MacroModified := true;
    end;
  end;
end;

procedure TFormMain.knobMacroSpeedChange(Sender: TObject);
var
  value: integer;
begin
  value := Round(knobMacroSpeed.Position);
  if (value = 0) then
    lblMacroSpeedText.Caption := 'G'
  else
    lblMacroSpeedText.Caption := IntToStr(value);
end;

procedure TFormMain.knobMacroSpeedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingMacro) then
  begin
    knobPos := knobMacroSpeed.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobMacroSpeed.Position := value;
    end;

    if (not loadingMacro) then
    begin
      activeKbKey.ActiveMacro.MacroSpeed := Round(knobMacroSpeed.Position);
      MacroModified := true;
    end;
  end;
end;

procedure TFormMain.KBCoTriggerClick(Sender: TObject);
var
  button: TLabelBox;
  aKey: TKey;
begin
  if IsKeyLoaded then
  begin
    button := Sender as TLabelBox;
    if (button.BorderStyle = bsNone) then
    begin
      ResetMacroCoTriggers;

      ActivateCoTrigger(button);

      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
      begin
        activeKbKey.ActiveMacro.CoTrigger1 := aKey.CopyKey;
        MacroModified := true;
      end;
    end
    else
    begin
      ResetCoTrigger(button);
      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
        RemoveCoTrigger(aKey.Key);
    end;
  end;
  pnlMacro.Repaint;

end;

procedure TFormMain.SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
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

procedure TFormMain.SetMacroText(pushCursorToEnd: boolean; cursorPos: integer = -1);
var
  aKeysPos: TKeysPos;
begin
  if (activeKbKey.IsMacro) then
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

procedure TFormMain.SetWindowsCombo(value: boolean);
var
  hideNotif: integer;
begin
  value := value and MacroMode;

  WindowsComboOn := value;
  ledWindowsCombo.Visible := value;
  if not value then
  begin
    keyService.RemoveModifier(VK_LWIN);
    keyService.RemoveModifier(VK_RWIN);
  end
  else
  begin
    keyService.AddModifier(VK_LWIN);
    if (not fileService.AppSettings.WindowsComboMsg) then
    begin
      hideNotif := ShowDialog('Windows Combination Active', 'Now press the key(s) you wish to combine with the Windows key in your macro. Then deselect Windows Combination from the Special Actions menu if you wish to continue programming or click Done.',
        mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, nil, 'Hide this notification?');

      if (hideNotif >= DISABLE_NOTIF) then
      begin
        fileService.SetWindowsComboMsg(true);
        fileService.SaveAppSettings;
      end;
    end;

    memoMacro.SetFocus;
  end;
end;

procedure TFormMain.MoveComponents(topIdx: integer; pixels: integer);
var
  i: integer;
  component: TControl;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[i] is TControl) then
    begin
      component := (Self.Components[i] as TControl);
      if (component.Top >= topIdx) then
        component.Top := component.Top + pixels;
    end;
  end;
end;

//End macro section

initialization
  {$I waveRes.lrs}
  {$I reactiveRes.lrs}
  {$I spectrumRes.lrs}
  {$I startlightRes.lrs}
  {$I rippleRes.lrs}
  {$I reboundRes.lrs}

end.

