unit u_form_main_rgb;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    lcltype, Menus, ExtCtrls, Buttons, lclintf, u_const, u_key_service,
    u_key_layer, u_file_service, LabelBox, LineObj, RichMemo, uGifViewer, ueled,
    uEKnob, HSLRingPicker, mbColorPreview, ECSwitch, ECSlider,
    u_keys, userdialog, contnrs, u_form_about, LazUTF8,
    u_form_settings, u_form_tapandhold, ColorSpeedButtonCS,
    LResources, BGRABitmap, BGRABitmapTypes, u_form_timingdelays, u_form_intro,
    LazUtils, {smtpsend, mimepart, mimemess,} u_form_export,
    u_form_diagnostics, u_form_firmware, u_form_troubleshoot, LazFileUtils,
    u_gif, u_common_ui, u_form_expansion
    {$ifdef Win64},Windows{$endif}, Types;

type
  { TFormMainRGB }
  TFormMainRGB = class(TForm)
    btnEject: TColorSpeedButtonCS;
    imgDisableLed: TImage;
    imgFireball: TImage;
    imgRipple: TImage;
    lblDisableLed: TLabel;
    lblDisplaying2: TLabel;
    lblCoTrigger: TLabel;
    lblFireball: TLabel;
    lblRipple: TLabel;
    NewGifTimer: TIdleTimer;
    btnAllZone: TColorSpeedButtonCS;
    btnLeftModule: TColorSpeedButtonCS;
    btnRightModule: TColorSpeedButtonCS;
    btnArrowZone: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    btnDirHorizontal: TColorSpeedButtonCS;
    btnDirVertical: TColorSpeedButtonCS;
    btnDirUp: TColorSpeedButtonCS;
    btnClose: TColorSpeedButtonCS;
    btnDirLeft: TColorSpeedButtonCS;
    btnDirDown: TColorSpeedButtonCS;
    btnDirRight: TColorSpeedButtonCS;
    btnDone: TColorSpeedButtonCS;
    btnFunctionZone: TColorSpeedButtonCS;
    btnGameZone: TColorSpeedButtonCS;
    btnNumberZone: TColorSpeedButtonCS;
    btnResetAll: TColorSpeedButtonCS;
    btnResetKey: TColorSpeedButtonCS;
    btnExport: TColorSpeedButtonCS;
    btnFirmware: TColorSpeedButtonCS;
    btnMaximize: TColorSpeedButtonCS;
    btnMinimize: TColorSpeedButtonCS;
    btnImport: TColorSpeedButtonCS;
    btnDiagnostic: TColorSpeedButtonCS;
    btnHelp: TColorSpeedButtonCS;
    btnCancelMacro: TColorSpeedButtonCS;
    btnCloseMacro: TColorSpeedButtonCS;
    btnCommonShortcuts: TColorSpeedButtonCS;
    btnCopy: TColorSpeedButtonCS;
    btnDoneMacro: TColorSpeedButtonCS;
    btnLeftAlt: TColorSpeedButtonCS;
    btnLeftCtrl: TColorSpeedButtonCS;
    btnLeftShift: TColorSpeedButtonCS;
    btnMouseClicksMacro: TColorSpeedButtonCS;
    btnPaste: TColorSpeedButtonCS;
    btnClearMacro: TColorSpeedButtonCS;
    btnBackspaceMacro: TColorSpeedButtonCS;
    btnRightAlt: TColorSpeedButtonCS;
    btnRightCtrl: TColorSpeedButtonCS;
    btnRightShift: TColorSpeedButtonCS;
    btnSettings: TColorSpeedButtonCS;
    btnSave: TColorSpeedButtonCS;
    btnSaveAs: TColorSpeedButtonCS;
    btnTimingDelays: TColorSpeedButtonCS;
    btnWASDZone: TColorSpeedButtonCS;
    btnWindowsCombos: TColorSpeedButtonCS;
    chkDisable: TCheckBox;
    chkGlobalSpeed: TCheckBox;
    chkRepeatMultiplay: TCheckBox;
    ColorDialog1: TColorDialog;
    colorPreview: TmbColorPreview;
    colorPreviewBase: TmbColorPreview;
    custColor11: TmbColorPreview;
    custColor10: TmbColorPreview;
    custColor7: TmbColorPreview;
    custColor8: TmbColorPreview;
    custColor9: TmbColorPreview;
    custColor12: TmbColorPreview;
    eBlue: TEdit;
    eBlueBase: TEdit;
    eGreen: TEdit;
    eGreenBase: TEdit;
    eHTML: TEdit;
    eHTMLBase: TEdit;
    eRed: TEdit;
    eRedBase: TEdit;
    imgLogoFSEdge3: TImage;
    imgMultimodifiers: TImage;
    imgSpecialActions: TImage;
    imgTapHold: TImage;
    imgSmartSet1: TImage;
    imgSmartSet2: TImage;
    imgAltLayouts: TImage;
    imgBacklight: TImage;
    imgDisableKey: TImage;
    imgFnAccess: TImage;
    imgListMacroActions: TImageList;
    imgListMacro: TImageList;
    imgListTriggers: TImageList;
    imgPreHotkeys: TImage;
    imgListZone: TImageList;
    imgFullKeypad: TImage;
    imgMacro: TImage;
    imgMedia: TImage;
    imgMouseClicks: TImage;
    imgFuncKeys: TImage;
    imgKeypadActions: TImage;
    imgPitchBlack: TImage;
    imgRain: TImage;
    imgPulse: TImage;
    imgRebound: TImage;
    imgSpectrum: TImage;
    imgReactive: TImage;
    imgLoop: TImage;
    imgBreathe: TImage;
    imgFreestyle: TImage;
    imageKnobBig: TImage;
    imgMonochrome: TImage;
    imgListDirection: TImageList;
    imgListProfileMenu: TImageList;
    imgListSettings: TImageList;
    imgStarlight: TImage;
    imgProfile: TImage;
    imgListProfileDefault: TImageList;
    imgListProfileHover: TImageList;
    imgListMiniIcons: TImageList;
    imgLogoFSEdge: TImage;
    imgListSave: TImageList;
    imgLogo: TImage;
    imgLogoFSEdge2: TImage;
    imgWave: TImage;
    kbLeftAlt: TLabelBox;
    kbLeftCtrl: TLabelBox;
    kbLeftShift: TLabelBox;
    kbRightAlt: TLabelBox;
    kbRightCtrl: TLabelBox;
    kbRightShift: TLabelBox;
    knobMultiplay: TuEKnob;
    knobMacroSpeed: TuEKnob;
    knobSpeed: TuEKnob;
    lblBackColor: TLabel;
    lblBColor1: TLabel;
    lblBaseColor: TLabel;
    lblCustomColors1: TLabel;
    lblGColor1: TLabel;
    lblPreMixedColors1: TLabel;
    lblRColor1: TLabel;
    lblSpecialActions: TLabel;
    lblMultimodifiers: TLabel;
    lblTapHold: TLabel;
    lblMacroInfo: TLabel;
    lblDisable: TLabel;
    lblRepeatMultiplay: TLabel;
    lblPlaybackSpeed: TLabel;
    lblAltLayouts: TLabel;
    lblGlobalSpeed: TLabel;
    lblMultiplay: TLabel;
    lblPreHotkeys: TLabel;
    lblKeypadActions: TLabel;
    lblBColor: TLabel;
    lblBreathe: TLabel;
    lblDebugMode: TLabel;
    lblColor: TLabel;
    lblDisableKey: TLabel;
    lblFunctionAccess: TLabel;
    lblFunctionKeys: TLabel;
    lblGColor: TLabel;
    lblLedControl: TLabel;
    lblPulse: TLabel;
    lblRain: TLabel;
    lblMacro: TLabel;
    lblMedia: TLabel;
    lblMouseClicks: TLabel;
    lblFullKeypad: TLabel;
    lblRColor: TLabel;
    lblLoop: TLabel;
    lblRemap: TLabel;
    lblSpeed1: TLabel;
    lblSpeed2: TLabel;
    lblDemoMode: TLabel;
    lblZone: TLabel;
    lblFreestyle: TLabel;
    lblMonochrome: TLabel;
    lblPitchBlack: TLabel;
    lblReactive: TLabel;
    lblRebound: TLabel;
    lblRGBSpectrum: TLabel;
    lblRGBWave: TLabel;
    lblSpeed: TLabel;
    lblDirection: TLabel;
    lblSpeedText: TLabel;
    lblStarlight: TLabel;
    lblVDriveError: TLabel;
    lblVDriveOk: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblMacroEditor: TLabel;
    lblDisableMacro: TLabel;
    lblGlobal: TLabel;
    lblMacro1: TLabel;
    lblMacro2: TLabel;
    lblMacro3: TLabel;
    lblMacroMultiplayOld: TStaticText;
    lblMultiplayText: TLabel;
    lblPlaybackSpeedOld: TStaticText;
    lblMacroSpeedText: TLabel;
    lbMenuMacro: TListBox;
    ledSpeed: TuELED;
    ledMultiplay: TuELED;
    ledMacroSpeed: TuELED;
    lineBorderBottomMacro: TLineObj;
    lineBorderLeftMacro: TLineObj;
    lineBorderRightTop: TLineObj;
    lineBorderRightMacro: TLineObj;
    lineBorderTopMacro: TLineObj;
    CheckVDriveTmr: TIdleTimer;
    lineBorderLeftTop: TLineObj;
    lbProfile: TListBox;
    memoMacro: TRichMemo;
    pnlMain: TPanel;
    pnlAssignMacro: TPanel;
    pnlBaseColor: TPanel;
    pnlLayout: TPanel;
    pnlProfileOptions: TPanel;
    pnlSpeed: TPanel;
    pnlLighting: TPanel;
    pnlLayoutBtn: TPanel;
    pnlLayoutTop: TPanel;
    pnlLightingBtn: TPanel;
    pnlSelectProfile: TPanel;
    pnlProfile: TPanel;
    pnlDirection: TPanel;
    pnlEffectColor: TPanel;
    pnlZone: TPanel;
    pnlTop: TPanel;
    pnlMacro: TPanel;
    pnlMenuMacro: TPanel;
    preMixedColor1: TmbColorPreview;
    preMixedColor11: TmbColorPreview;
    preMixedColor12: TmbColorPreview;
    preMixedColor13: TmbColorPreview;
    preMixedColor14: TmbColorPreview;
    preMixedColor15: TmbColorPreview;
    preMixedColor16: TmbColorPreview;
    preMixedColor17: TmbColorPreview;
    preMixedColor18: TmbColorPreview;
    preMixedColor19: TmbColorPreview;
    preMixedColor20: TmbColorPreview;
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
    gbButtons: TGroupBox;
    GifIdleTimer: TIdleTimer;
    gifViewer: TGIFViewer;
    miAddCustColor: TMenuItem;
    pmColorPreview: TPopupMenu;
    rgMacro1: TRadioButton;
    rgMacro2: TRadioButton;
    rgMacro3: TRadioButton;
    imgKeyboardBack: TImage;
    imgKeyboardLighting: TImage;
    lblPreMixedColors: TLabel;
    lblCustomColors: TLabel;
    ringPicker: THSLRingPicker;
    ringPickerBase: THSLRingPicker;
    sliderMacroSpeed: TECSlider;
    sliderMultiplay: TECSlider;
    SpectrumTimer: TIdleTimer;
    swLayerSwitch: TECSwitch;
    textMacroInput: TStaticText;
    tmrAfterFormShown: TTimer;
    WaveTimer: TIdleTimer;
    imageKnob: TImage;
    imageListKB: TImageList;
    imgKeyboardLayout: TImage;
    imgBackground: TImage;
    imgListMenu: TImageList;
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
    lblBottomInfo: TLabel;
    lbMenu: TListBox;
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
    LoadGifTimer: TIdleTimer;
    BreatheTimer: TIdleTimer;
    MonochromeTimer: TIdleTimer;
    procedure bCoTriggerClick(Sender: TObject);
    procedure BreatheTimerTimer(Sender: TObject);
    procedure btnAllZoneClick(Sender: TObject);
    procedure btnArrowZoneClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMacroClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCloseMacroClick(Sender: TObject);
    procedure btnCommonShortcutsClick(Sender: TObject);
    procedure btnDiagnosticClick(Sender: TObject);
    procedure btnDirectionClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnDoneMacroClick(Sender: TObject);
    procedure btnEjectClick(Sender: TObject);
    procedure btnFirmwareClick(Sender: TObject);
    procedure btnFunctionZoneClick(Sender: TObject);
    procedure btnGameZoneClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnLeftModuleClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnMouseClicksMacroClick(Sender: TObject);
    procedure btnNumberZoneClick(Sender: TObject);
    procedure btnResetAllClick(Sender: TObject);
    procedure btnRightModuleClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnTimingDelaysClick(Sender: TObject);
    procedure btnWASDZoneClick(Sender: TObject);
    procedure btnWindowsCombosClick(Sender: TObject);
    procedure CheckVDriveTmrTimer(Sender: TObject);
    procedure chkDisableClick(Sender: TObject);
    procedure chkGlobalSpeedClick(Sender: TObject);
    procedure chkRepeatMultiplayClick(Sender: TObject);
    procedure colorPreMixedClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure colorPreMixedBaseClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure colorPreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure custColorDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure custColorClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure custColorBaseClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure custColorChange(Sender: TObject);
    procedure eHTMLBaseExit(Sender: TObject);
    procedure eHTMLChange(Sender: TObject);
    procedure eHTMLExit(Sender: TObject);
    procedure eHTMLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure gifViewerStart(Sender: TObject);
    procedure imgBackMacroClick(Sender: TObject);
    procedure imgKeyboardLightingMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImageMenuClick(Sender: TObject);
    procedure imgMacroClick(Sender: TObject);
    procedure imgProfileMouseEnter(Sender: TObject);
    procedure imgTapHoldClick(Sender: TObject);
    procedure lblDisableClick(Sender: TObject);
    procedure lblGlobalSpeedClick(Sender: TObject);
    procedure lblMacroInfoMouseEnter(Sender: TObject);
    procedure lblMacroInfoMouseLeave(Sender: TObject);
    procedure lblRepeatMultiplayClick(Sender: TObject);
    procedure lblTapHoldClick(Sender: TObject);
    procedure lbMenuMacroMouseLeave(Sender: TObject);
    procedure lbMenuMouseLeave(Sender: TObject);
    procedure lbProfileDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure lbProfileMouseLeave(Sender: TObject);
    procedure memoMacroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuActionMouseEnter(Sender: TObject);
    procedure imgProfileClick(Sender: TObject);
    procedure imgProfileMouseLeave(Sender: TObject);
    procedure imgProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure KBCoTriggerClick(Sender: TObject);
    procedure knobMacroSpeedChange(Sender: TObject);
    procedure knobMacroSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure knobMultiplayChange(Sender: TObject);
    procedure knobMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblActionMouseEnter(Sender: TObject);
    procedure lblActionMouseLeave(Sender: TObject);
    procedure lblActionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblMacroClick(Sender: TObject);
    procedure lbMenuMacroClick(Sender: TObject);
    procedure lbMenuMacroMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbMenuMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure lbProfileClick(Sender: TObject);
    procedure lbProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LoadGifTimerTimer(Sender: TObject);
    procedure MenuActionMouseLeave(Sender: TObject);
    procedure MenuActionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MonochromeTimerTimer(Sender: TObject);
    procedure NewGifTimerTimer(Sender: TObject);
    procedure pnlMacroClick(Sender: TObject);
    procedure pnlProfileOptionsClick(Sender: TObject);
    procedure rgbExit(Sender: TObject);
    procedure gifViewerClick(Sender: TObject);
    procedure imgLeftMenuClick(Sender: TObject);
    procedure knobSpeedChange(Sender: TObject);
    procedure knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miAddCustColorClick(Sender: TObject);
    procedure PopupLabelClick(Sender: TObject);
    procedure PopupMenuClick(Sender: TObject);
    procedure rgbChange(Sender: TObject);
    procedure rgbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgMacroClick(Sender: TObject);
    procedure ringPickerBaseChange(Sender: TObject);
    procedure ringPickerChange(Sender: TObject);
    procedure SingleKeyLabelClick(Sender: TObject);
    procedure SingleKeyMenuClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgKeyboardLayoutClick(Sender: TObject);
    procedure imgMacroMenuClick(Sender: TObject);
    procedure memoMacroChange(Sender: TObject);
    procedure sliderMultiplayChange(Sender: TObject);
    procedure sliderMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sliderMacroSpeedChange(Sender: TObject);
    procedure sliderMacroSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpectrumTimerTimer(Sender: TObject);
    procedure swLayerSwitchClick(Sender: TObject);
    procedure tmrAfterFormShownTimer(Sender: TObject);
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
    resetLayer: boolean;
    loadingSettings: boolean;
    loadingColor: boolean;
    loadingColorBase: boolean;
    loadingLedSettings: boolean;
    defaultKeyFontName: string;
    defaultKeyFontSize: integer;
    freqKeyDown: boolean;
    speedKeyDown: boolean;
    infoMessageShown: boolean;
    remapCount: integer;
    macroCount: integer;
    tapHoldCount: integer;
    maxMacros : integer;
    maxKeystrokes : integer;
    totalKeystrokes: integer;
    currentMenuAction: TMenuAction;
    currentPopupMenu: TMenuAction;
    menuActionList: TObjectList;
    hoveredList: TObjectList;
    ConfigMode: integer;
    AppSettingsLoaded: boolean;
    kbArrayCol1: array of TLabelBox;
    kbArrayCol2: array of TLabelBox;
    kbArrayCol3: array of TLabelBox;
    kbArrayCol4: array of TLabelBox;
    kbArrayCol5: array of TLabelBox;
    kbArrayCol6: array of TLabelBox;
    kbArrayCol7: array of TLabelBox;
    kbArrayCol8: array of TLabelBox;
    kbArrayCol9: array of TLabelBox;
    kbArrayCol10: array of TLabelBox;
    kbArrayCol11: array of TLabelBox;
    kbArrayCol12: array of TLabelBox;
    kbArrayCol13: array of TLabelBox;
    kbArrayCol14: array of TLabelBox;
    kbArrayCol15: array of TLabelBox;
    kbArrayCol16: array of TLabelBox;
    kbArrayCol17: array of TLabelBox;
    kbArrayCol18: array of TLabelBox;
    kbArrayRow1: array of TLabelBox;
    kbArrayRow2: array of TLabelBox;
    kbArrayRow3: array of TLabelBox;
    kbArrayRow4: array of TLabelBox;
    kbArrayRow5: array of TLabelBox;
    kbArrayRow6: array of TLabelBox;
    currentGif: string;
    loadingMacro: boolean;
    breatheTransparency: integer;
    breatheCycle: integer;
    breatheDirection: TColor;
    gifFrameIdx: integer;
    pulseColor: integer;
    WindowsComboOn: boolean;
    appError: boolean;
    activeMacroMenu: string;
    logoSize: integer;
    closing: boolean;
    profileMode: TProfileMode;
    cusWindowState: TCusWinState;
    NORMAL_HEIGHT: integer;
    NORMAL_WIDTH: integer;
    fromMasterApp: boolean;
    parentForm: TForm;
    showingVDriveErrorDlg: boolean;
    waveCycle: integer;
    spectrumCycle: integer;
    spectrumColor: integer;

    procedure ActivateCoTrigger(keyButton: TLabelBox);
    Procedure ActivateCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
    procedure AfterColorChange;
    procedure AfterColorChangeBase;
    procedure AppDeactivate(Sender: TObject);
    function CanAssignMacro: boolean;

    procedure ChangeActiveLayer(layerIdx: integer);
    function CheckConfigMode(modeToCheck: integer): boolean;
    procedure CloseMacroEditor;
    procedure DoSendMailAndAttachments(const ATo, ASubject: String;
      Content: TStrings; FAttachments: TStringList);
    function EditingMacro(showWarning: boolean=false): boolean;
    function CheckSaveKey(canSave: boolean = true; checkMacroOpen: boolean = true): boolean;
    function CheckToSave(checkForVDrive: boolean): boolean;
    function CheckVDrive: boolean;
    procedure ColorChange(newColor: TColor);
    procedure ColorChangeBase(newColor: TColor);
    procedure continueClick(Sender: TObject);
    function DoneKey: boolean;
    procedure EnablePaintImages(value: boolean);
    function GetCoTriggerKey(Sender: TObject): TKey;
    function GetKeyButtonByIndex(index: integer): TLabelBox;
    function GetKeyButtonUnderMouse(x: integer; y: integer): TLabelBox;
    function GetKeyOtherLayer(keyIdx: integer): TKBKey;
    function GetLedMode: TLedMode;
    procedure GetRBGEditColor;
    procedure GetRBGEditBaseColor;
    function InitApp(scanVDrive: boolean = false): boolean;
    procedure KeyButtonClick(Sender: TObject);
    procedure KeyButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KeyButtonsBringToFront;
    procedure KeyButtonsSendToBack;
    procedure LaunchDemoMode;
    function MouseInControl(oControl: TControl): boolean;
    procedure OpenTapAndHold;
    procedure ResetBreathe;
    procedure ResetDirection;
    procedure ResetNewGif;
    procedure ResetWave;
    procedure ResetSpectrum;
    procedure ReturnToHome;
    procedure ScanVDrive(init: boolean);
    procedure SendEmail;
    procedure SetColorWave(arrayButton: array of TLabelBox; colorIdx: integer;
      invertColors: boolean = false; gradient: boolean=false);
    procedure SetLayoutMenuColor;
    procedure SetMacroAssignTo;
    procedure ObjectMouseExit(Sender: TObject);
    procedure ObjectMouseEnter(Sender: TObject);
    procedure ObjectMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PositionMenuItems;
    procedure ResetHighlight;
    procedure setWorkmanBothLayers(Sender: TObject);
    procedure setWorkmanFnLayer(Sender: TObject);
    procedure setWorkmanTopLayer(Sender: TObject);
    procedure UnselectActiveKey;
    function SaveAll(isNew: boolean=false; showSaveDialog: boolean=true): boolean;
    procedure SaveAsAll(profileNumber: string; isNew: boolean = false);
    procedure scanVDriveInitClick(Sender: TObject);
    procedure SetDirection(direction: integer; ledMode: TLedMode);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
    procedure SetMacModifiersHotkeys;
    procedure SetFreestyle2Hotkeys;
    procedure SetFreestyleProHotkeys;
    procedure SetWorkmanKb(layerIdx: integer; bothLayers: boolean);
    procedure SetHovered(obj: TObject; hovered: boolean; forceNormal: boolean = false);
    procedure SetMacroMenuItems(button: TColorSpeedButtonCS);
    procedure SetSingleKeyColor(keyButton: TLabelBox; newColor: TColor);
    procedure SetZoneColor(zoneType: TZoneType);
    procedure ShowHideKeyButtons(value: boolean);
    procedure LoadGif(speed: integer; direction: integer);
    procedure LoadLayer(layer: TKBLayer);
    function LoadLedFile(ledFile: string; fileContent: TStringList): boolean;
    procedure LoadMacro;
    procedure OpenColorDialog;
    procedure ReloadKeyButtons;
    procedure ReloadKeyButtonsColor(reset: boolean = false; repainForm: boolean = true);
    procedure RemoveCoTrigger(key: word);
    procedure RepaintForm(fullRepaint: boolean);
    procedure ResetCoTrigger(keyButton: TLabelBox);
    Procedure ResetCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
    procedure ResetMacroCoTriggers;
    procedure ResetPopupMenu;
    procedure ResetPopupMenuMacro;
    procedure ResetSingleKey;
    procedure ResetProfileMenu;
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
    procedure SetSingleKey(aMenuAction: TMenuAction; wasDown: boolean);
    procedure ShowHideParameters(param: integer; ledMode:TLedMode; state: boolean);
    procedure ShowIntroDialogs;
    function ShowTroubleshootingDialog(init: boolean): boolean;
    procedure UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox;
      unselectKey: boolean=false; fullLoad: boolean=false);
    procedure UpdateMenu;
    procedure FillMenuActionList;
    procedure FillHoveredList;
    function GetMenuActionByType(actionType: TMenuActionType): TMenuAction;
    function GetMenuActionByLabel(labelName: string): TMenuAction;
    function GetMenuActionByImage(imageName: string): TMenuAction;
    procedure ResetAllMenuAction;
    procedure SetCurrentMenuAction(aType: TMenuActionType; aLabel: TLabel; aImage: TImage = nil);
    procedure SetModifiedKey(key: word; Modifiers: string; isMacro: boolean;
      bothLayers: boolean = false; force: boolean = false; overwriteTapHold: boolean = false);
    procedure SetConfigOS;
    procedure SetKeyboardHook;
    procedure RemoveKeyboardHook;
    procedure InitKeyButtons(container: TWinControl);
    function LoadVersionInfo: boolean;
    function LoadStateSettings: boolean;
    procedure RefreshRemapInfo;
    function LoadKeyboardLayout(layoutFile: string; fileContent: TStringList
      ): boolean;
    procedure UpdateStateSettings;
    function ValidateBeforeSave: boolean;
    procedure watchTutorialClick(Sender: TObject);
    procedure readManualClick(Sender: TObject);
    procedure openTroubleshootingTipsClick(Sender: TObject);
    procedure scanVDriveClick(Sender: TObject);
    procedure SetConfigMode(mode: integer; init: boolean = false);
    procedure SetRemapMode(value: boolean);
    procedure SetMacroMode(value: boolean);
    procedure OpenMacroEditor;
    procedure LoadKeyButtonRows;
    procedure LoadAppSettings;
    procedure SetWindowsCombo(value: boolean);
    procedure MoveComponents(leftIdx: integer; pixels: integer);
    procedure openFirwareWebsite(Sender: TObject);
    function RippleFireballEnable: boolean;
    procedure SetMenuEnabledFirmware;
    procedure CheckFirmware;
  public
    { public declarations }
    currentLayoutFile: string;
    currentLedFile: string;
    currentProfileNumber: integer;
    activeKbKey: TKBKey;
    lastKeyDown: word;
    lastKeyPressed: word;
    activeColor: TColor;
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
    procedure SetMousePosition(x, y: integer);
    procedure Maximize;
    function InitForm(mdiParent: TForm): boolean;
  end;

var
  FormMainRGB: TFormMainRGB;
  //FormMacro: TFormMacro;
  KBHook: HHook;
  MPos:TPoint; {Position of the Form before drag}
  //keyService: TKeyService;
  //fileService: TFileService;

  procedure SetKeyPress(Key: word; Modifiers: string);
  {$ifdef Win64}
  function KeyboardHookProc(Code: longint; wParam: int64; lParam: int64): int64; stdcall;  {this intercepts keyboard input}
  {$endif}

implementation

uses u_form_dashboard;

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
    (FormMainRGB.eRed.Focused) or
    (FormMainRGB.eRedBase.Focused) or
    (FormMainRGB.eGreen.Focused) or
    (FormMainRGB.eGreenBase.Focused) or
    (FormMainRGB.eBlue.Focused) or
    (FormMainRGB.eBlueBase.Focused) or
    (FormMainRGB.eHTML.Focused) or
    (FormMainRGB.eHTMLBase.Focused) or
    ((FormTapAndHold <> nil) and FormTapAndHold.eTimingDelay.Focused) then
  begin
    Result := CallNextHookEx(WH_KEYBOARD, Code, wParam, lParam);
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMainRGB.Active) and not(FormMainRGB.fromMasterApp and FormMainRGB.Visible) and
    not((FormTapAndHold <> nil) and FormTapAndHold.Active and
    (FormTapAndHold.eTapAction.Focused or FormTapAndHold.eHoldAction.Focused)) then
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
        if currentKey <> FormMainRGB.lastKeyPressed then
          SetKeyPress(currentKey, keyService.GetModifierText);

        //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
        Result := 1;

        //Sets last key pressed
        FormMainRGB.lastKeyPressed := currentKey;
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
      if currentKey = FormMainRGB.lastKeyPressed then
        FormMainRGB.lastKeyPressed := 0;

      //If it's a  modifier and it's the last key pressed or print screen (only works on key up)
      if ((currentKey = FormMainRGB.lastKeyDown) and IsModifier(currentKey)) or
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
  FormMainRGB.lastKeyDown := currentKey;
end;

{$endif}

{Set the keyboard hook so we  can intercept keyboard input}
procedure TFormMainRGB.SetKeyboardHook;
begin
  //Windows
  {$ifdef Win64}
  KBHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, HInstance,
    GetCurrentThreadId());
  {$endif}
end;

{unhook the keyboard interception}
procedure TFormMainRGB.RemoveKeyboardHook;
begin
  //Windows
  {$ifdef Win64}
  UnHookWindowsHookEx(KBHook);
  {$endif}
end;

//Only used for Mac version to trap key presses
procedure TFormMainRGB.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{$ifdef Darwin}var currentKey: longint;{$endif}
begin
  {$ifdef Darwin}
  //If we need keyboard input (ex: file prompt) allow key presses
  if (NeedInput) or
    (FormMainRGB.eRed.Focused) or
    (FormMainRGB.eRedBase.Focused) or
    (FormMainRGB.eGreen.Focused) or
    (FormMainRGB.eGreenBase.Focused) or
    (FormMainRGB.eBlue.Focused) or
    (FormMainRGB.eBlueBase.Focused) or
    (FormMainRGB.eHTML.Focused) or
    (FormMainRGB.eHTMLBase.Focused) or
    ((FormTapAndHold <> nil) and FormTapAndHold.eTimingDelay.Focused) then
  begin
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMainRGB.Active) and not(FormMainRGB.fromMasterApp and FormMainRGB.Visible) and
    not((FormTapAndHold <> nil) and FormTapAndHold.Active and
    (FormTapAndHold.eTapAction.Focused or FormTapAndHold.eHoldAction.Focused)) then
    exit;

  currentKey := GetCurrentKeyMac(key);

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
procedure TFormMainRGB.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
{$ifdef Darwin}var currentKey: longint;{$endif}
begin
  {$ifdef Darwin}
  currentKey := GetCurrentKeyMac(key);

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

procedure TFormMainRGB.imgKeyboardLayoutClick(Sender: TObject);
begin
  UnselectActiveKey;
end;

procedure TFormMainRGB.imgBackgroundClick(Sender: TObject);
begin
  ResetProfileMenu;
  UnselectActiveKey;
end;

procedure TFormMainRGB.UnselectActiveKey;
begin
  ResetPopupMenu;
  ResetPopupMenuMacro;
  ResetSingleKey;
  if IsKeyLoaded then
    SetActiveKeyButton(nil);
end;

procedure TFormMainRGB.lblLayoutClick(Sender: TObject);
begin
  SetConfigMode(CONFIG_LAYOUT);
end;

procedure TFormMainRGB.lblLightingClick(Sender: TObject);
begin
  SetConfigMode(CONFIG_LIGHTING);
end;

//Adds key to list of keys and writes back to edit field
procedure SetKeyPress(Key: word; Modifiers: string);
begin
  //if (FormMainRGB.eHTML.Focused) then
  //  FormMainRGB.eHTML.Text := 'AAA'
  //else
  if (FormTapAndHold <> nil) and (FormTapAndHold.Visible) then
    FormTapAndHold.SetKeyPress(Key)
  else
    FormMainRGB.SetModifiedKey(Key, Modifiers, FormMainRGB.EditingMacro, false);
end;

{ TFormMainRGB }

procedure TFormMainRGB.FormCreate(Sender: TObject);
begin

end;

function TFormMainRGB.InitForm(mdiParent: TForm): boolean;
begin
  result := false;

  fromMasterApp := mdiParent <> nil;
  parentForm := mdiParent;

  if (GDebugMode) then
  begin
    lblDebugMode.Visible := true;
    ShowMessage('Main form loading');
  end;

  NORMAL_HEIGHT := 850;
  NORMAL_WIDTH := 1550;

  //From master app
  if (fromMasterApp) then
  begin
    FormStyle := TFormStyle.fsMDIChild;
    WindowState:= TWindowState.wsMaximized;
    //FormMainRGB.Maximize;
    pnlTop.Visible := false;
    lineBorderBottom.Visible := false;
    lineBorderLeft.Visible := false;
    lineBorderRight.Visible := false;
    lineBorderTop.Visible := false;
    NORMAL_HEIGHT := Parent.Height;
    NORMAL_WIDTH := Parent.Width;
    Maximize;
    ShowInTaskBar := stNever;
  end;

  //Sets Height and Width of form
  logoSize := (imgLogoFSEdge2.Left + imgLogoFSEdge2.Width) - imgLogoFSEdge.Left;
  {$ifdef Win64}
  SetFormBorder(bsNone);
  {$endif}
  {$ifdef Darwin}
  SetFormBorder(bsNone);
  {$endif}
  {$ifdef Linux}
  //SetFormBorder(bsNone);
  {$endif}
  self.Width := NORMAL_WIDTH;
  self.Height := NORMAL_HEIGHT;
  imgBackground.Left := 0;
  imgBackground.Top := 0;
  imgBackground.Width := self.Width;
  imgBackground.Height := self.Height;
  cusWindowState := cwNormal;
  pnlMacro.Top := pnlEffectColor.Top;

  //Set default variables
  closing := false;
  showingVDriveErrorDlg := false;
  AppSettingsLoaded := false;
  infoMessageShown := false;
  loadingSettings := false;
  loadingColor := false;
  loadingColorBase := false;
  loadingLedSettings := false;
  freqKeyDown := false;
  speedKeyDown := false;
  resetLayer := false;
  keyBtnList := TObjectList.Create(false);
  activeKeyBtn := nil;
  activeKbKey := nil;
  SetConfigOS;
  keyService := TKeyService.Create;
  fileService := TFileService.Create;
  SetSaveState(ssNone, ssNone);
  NeedInput := False;
  RemapMode := false;
  loadingMacro := false;
  ResetBreathe;
  ResetNewGif;
  ResetWave;
  ResetSpectrum;
  WindowsComboOn := false;
  appError := false;
  activeMacroMenu := '';
  oldWindowState := wsNormal;
  //ringPicker.SquarePickerHintFormat:='Adjust the brightness of your color using the color square';
  InitKeyButtons(pnlMain);
  LoadKeyButtonRows;
  //jm temp SetOtherPanelClick(self);
  Application.OnRestore := @OnRestore;
  Application.OnDeactivate := @AppDeactivate;
  CloseMacroEditor;
  currentPopupMenu := nil;
  profileMode := pmNone;
  maxMacros := MAX_MACRO_RGB;
  maxKeystrokes := MAX_KEYSTROKES_RGB;
  lblMacroEditor.Hint := 'Each layout can store ' + IntToStr(maxKeystrokes) +
      ' total macro characters and up to ' + IntToStr(maxMacros) + ' macros';

  //App shows in Taskbar only when minimized
  if (not fromMasterApp) then
    Application.MainFormOnTaskBar:= true;

  {$ifdef Darwin}
  //btnClose.Visible := false;
  //btnMinimize.Visible := false;
  //btnMaximize.Visible := false;
  {$endif}

  activeColor := KINESIS_BLUE_EDGE;
  fontColor := clWhite;
  backColor := KINESIS_DARK_GRAY_FS;

  knobSpeed.Image := imageKnobBig.Picture.Bitmap;
  knobMultiplay.Image := imageKnob.Picture.Bitmap;
  knobMacroSpeed.Image := imageKnob.Picture.Bitmap;

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
  FillHoveredList;

  //Set keyboard Hook
  SetKeyboardHook;

  //Check for v-drive
  SetBaseDirectory(true);

  //Init app
  result := InitApp;
end;

function TFormMainRGB.InitApp(scanVDrive: boolean = false): boolean;
var
  customBtns: TCustomButtons;
  aListDrives: TStringList;
  drives: string;
  i: integer;
  titleError: string;
begin
  if (GDebugMode) then
    ShowMessage('CheckVDrive-start');
  lblDemoMode.Visible := GDemoMode;
  result := GDemoMode or CheckVDrive;
  if (GDebugMode) then
    ShowMessage('CheckVDrive-end');

  if (result) then
  begin
    //Load config keys depending on app version
    keyService.LoadConfigKeys;

    if (GDebugMode) then
    begin
      drives := '';
      aListDrives := GetAvailableDrives;
      for i := 0 to aListDrives.Count - 1 do
        drives := drives + aListDrives[i] + #10;
      ShowMessage('Drives: ' + drives);
      FreeAndNil(aListDrives);
    end;

    RefreshRemapInfo;

    swLayerSwitch.Checked := true;

    keyService.LoadLayerList;

    LoadKeyButtonRows;
    if (GDebugMode) then
      ShowMessage('LoadKeyButtonRows done');

    {$ifdef Darwin}
      btnEject.Visible := false;
    {$endif};

    if (GDemoMode) then
    begin
      imgProfile.Enabled := false;
      btnSave.Enabled := false;
      btnSaveAs.Enabled := false;
      btnSettings.Enabled := false;
      btnEject.Enabled := false;
      btnImport.Enabled := false;
      btnExport.Enabled := false;
      btnFirmware.Enabled := false;
      btnDiagnostic.Enabled := false;
      SetActiveLayer(TOPLAYER_IDX);
      SetActiveKeyButton(nil);
      SetConfigMode(CONFIG_LAYOUT, true);
    end
    else
    begin
      if (GDebugMode) then
        ShowMessage('LoadStateSettings-start');
      if (LoadStateSettings) then
      begin
        if (GDebugMode) then
          ShowMessage('LoadStateSettings-end');

        if (GDebugMode) then
          ShowMessage('LoadAppSettingsAndLayout-start');
        LoadAppSettings;
        LoadKeyboardLayout(currentLayoutFile, nil);
        LoadLedFile(currentLedFile, nil);

        SetConfigMode(CONFIG_LAYOUT, true);

        CheckVDriveTmr.Enabled := true;

        if (GDebugMode) then
          ShowMessage('LoadAppSettingsAndLayout-end');
      end
      else
        result := false;
    end;
  end;

  if not result then
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
        ReturnToHome;
      end
      else
        result := true;
    end
    else
    begin
      createCustomButton(customBtns, 'Troubleshooting Tips', 200, @openTroubleshootingTipsClick);
      ShowDialog('SmartSet App File Error', 'The SmartSet App cannot find the necessary layout and settings files on the v-drive. Replug the keyboard to regenerate these files and try launching the App again.',
        mtFSEdge, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
      appError := true;
      Close;
      ReturnToHome;
    end;
  end;
  if (GDebugMode) then
    ShowMessage('App Loaded');
end;

procedure TFormMainRGB.FormShow(Sender: TObject);
begin
  //App error don't show main form
  if (appError) then
    self.Hide
  else
  begin
    tmrAfterFormShown.Interval := 200;
    tmrAfterFormShown.Enabled := true;
  end;
end;

procedure TFormMainRGB.tmrAfterFormShownTimer(Sender: TObject);
begin
  tmrAfterFormShown.Enabled := false;
  // After show code
  ShowIntroDialogs;
end;

procedure TFormMainRGB.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  closing := true;
  if (not CheckToSave(false)) then
  begin
    CloseAction := caNone;
    closing := false;
  end
  else
  begin
    if (gifViewer.Playing) then
      gifViewer.Stop;
    GifIdleTimer.Enabled := false;
    WaveTimer.Enabled := false;
    BreatheTimer.Enabled := false;
    NewGifTimer.Enabled := false;
    CloseAction := caFree;
  end;
end;

procedure TFormMainRGB.FormDestroy(Sender: TObject);
begin
  RemoveKeyboardHook;
  FreeAndNil(keyBtnList);
  FreeAndNil(keyService);
  FreeAndNil(fileService);
  FreeAndNil(menuActionList);
  FreeAndNil(hoveredList);
  //RemoveFontResource('fonts/Exo2-Regular.ttf');
  //RemoveFontResource('fonts/Quantify Bold v2.6.ttf');
  //SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

 procedure TFormMainRGB.SetConfigOS;
begin
  //Windows
  {$ifdef Win64}
  defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 10;
  //SetFont(self, 'Tahoma Bold');
  {$endif}

  //
  {$ifdef Linux}
  defaultKeyFontName := 'Arial';
  defaultKeyFontSize := 10;
  {$endif}

  //MacOS
  {$ifdef Darwin}
  self.AutoScroll := false; //No scroll bars OSX, does not work well
  self.KeyPreview := true; //traps key presses at form level
  //defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 8;
  //SetFont(self, 'Helvetica');
  //lblMonochrome.Left := rgMacro1.Left - lblMonochrome.Width - 5;
  //lblMacro2.Left := rgMacro2.Left - lblMacro2.Width - 5;
  //lblMacro3.Left := rgMacro3.Left - lblMacro3.Width - 5;
  rgMacro1.Left := rgMacro1.Left - 25;
  rgMacro1.Top := rgMacro1.Top - 4;
  rgMacro2.Left := rgMacro2.Left - 25;
  rgMacro2.Top := rgMacro2.Top - 4;
  rgMacro3.Left := rgMacro3.Left - 25;
  rgMacro3.Top := rgMacro3.Top - 4;
  btnWindowsCombos.Visible := false;
  //lblDisplaying.Left := lblDisplaying.Left - 20;
  //lblDisplaying.Top := lblDisplaying.Top - 4;
  //lblDisplaying.Font.Size := 16;
  imgSmartSet1.Left := imgSmartSet1.Left - 4;

  //Change Macro co-trigger images
  LoadButtonImage(btnLeftCtrl, imgListTriggers, 12);
  LoadButtonImage(btnLeftAlt, imgListTriggers, 14);
  LoadButtonImage(btnRightCtrl, imgListTriggers, 15);
  LoadButtonImage(btnRightAlt, imgListTriggers, 16);

  //Hide special actions for Mac
  //miLastAppM.Visible := false;
  //miDesktopM.Visible := false;
  //miCtrlAltDelM.Visible := false;
  //miWebShortcutsM.Visible := false;
  //miWinCombM.Visible := false;
  miRightWin.Visible := false;
  miMenu.Visible := false;
  miIntlKey.Visible := false;
  miCalculator.Visible := false;
  //tbMacroSpeed.Visible := false;
  //tbStatusReport.Visible := false;
  //tbMultiplay.Visible := false;
  //tbSpeed.Visible := false;

  //lblGlobalMacroSpeed.Top := lblGlobalMacroSpeed.Top - 2;
  //slMacroSpeed.Top := slMacroSpeed.Top - 2;
  //lblDirectionText.Top := lblDirectionText.Top - 2;
  //slStatusReport.Top := slStatusReport.Top - 2;
  {$endif}
end;

procedure TFormMainRGB.FormActivate(Sender: TObject);
begin
  //ShowIntroDialogs;
end;

procedure TFormMainRGB.RepaintForm(fullRepaint: boolean);
var
   region: TRect;
begin
  //Do a form repaint
  try
    EnablePaintImages(false);

    if (fullRepaint) then
      self.Repaint  //Invalidate;
    else
    begin
      region := TRect.Create(imgKeyboardBack.Left, imgKeyboardBack.Top, imgKeyboardBack.Left + imgKeyboardBack.Width, imgKeyboardBack.Top + imgKeyboardBack.Height);
      InvalidateRect(pnlMain.Handle, @region, false);
      //pnlMain.Repaint;
      //pnlMain.Invalidate;
    end;
  finally
    EnablePaintImages(true);
  end;
end;

procedure TFormMainRGB.ShowIntroDialogs;
begin
  if (not closing) and (not infoMessageShown) and (ShowNotification(fileService.AppSettings.AppIntroMsg)) and (AppSettingsLoaded or GDemoMode) then
  begin
    ShowIntro('Introduction', 'Welcome to the SmartSet App for the Freestyle Edge RGB. The SmartSet App lets you customize Layout and Lighting Effects for each of the 9 Profiles and adjust the Global Keyboard Settings.', backColor, fontColor);
  end;
  if (not closing) and (not infoMessageShown) and (ShowNotification(fileService.AppSettings.AppCheckFirmMsg)) and (AppSettingsLoaded) then
  begin
    CheckFirmware;
  end;
  infoMessageShown := true;
end;

function TFormMainRGB.ShowTroubleshootingDialog(init: boolean): boolean;
var
  customBtns: TCustomButtons;
  title: string;
  message: string;
  openPosition: TPosition;
  resultTroubleshoot: integer;
begin
  result := true;

  showingVDriveErrorDlg := true;
  if init then
  begin
    title := 'Keyboard not detected';
      resultTroubleshoot := ShowTroubleshoot(title, backColor, fontColor);
    if (resultTroubleshoot = 1) then
      ScanVDrive(init)
    else if (resultTroubleshoot = 2) then
      LaunchDemoMode;
    result := resultTroubleshoot > 0;
  end
  else
  begin
    title := 'Keyboard Connection Lost';
    openPosition := poMainFormCenter;
    createCustomButton(customBtns, 'Scan for v-Drive', 200, @scanVDriveClick);
    title := 'Keyboard Connection Lost';
    message := 'To save your changes you must use the onboard shortcut “SmartSet + F8” to open the v-Drive and re-establish the connection with the SmartSet App.';
    createCustomButton(customBtns, 'Troubleshooting Tips', 200, @openTroubleshootingTipsClick);

    if (ShowDialog(title, message, mtError, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns, '', openPosition, 700) = mrCancel) then
      result := false;
  end;

  showingVDriveErrorDlg := false;
  //if init then
  //begin
  //  openPosition := poScreenCenter;
  //  createCustomButton(customBtns, 'Scan for v-Drive', 200, @scanVDriveInitClick);
  //  title := 'Keyboard not detected';
  //  message := 'Use the onboard shortcut “SmartSet + F8” to open the v-Drive before launching the SmartSet App';
  //end
  //else
  //begin
  //  openPosition := poMainFormCenter;
  //  createCustomButton(customBtns, 'Scan for v-Drive', 200, @scanVDriveClick);
  //  title := 'Keyboard Connection Lost';
  //  message := 'To save your changes you must use the onboard shortcut “SmartSet + F8” to open the v-Drive and re-establish the connection with the SmartSet App.';
  //end;
  //createCustomButton(customBtns, 'Troubleshooting Tips', 200, @openTroubleshootingTipsClick);
  //createCustomButton(customBtns, 'Launch in Demo Mode', 200, @launchDemoMode);
  //
  //if (ShowDialog(title, message, mtError, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns, '', openPosition, 700) = mrCancel) then
  //  result := false;
end;

procedure TFormMainRGB.FillMenuActionList;
begin
  menuActionList := TObjectList.Create(true);
  //menuActionList.Add(TMenuAction.Create(btnRemap, lblRemap, nil, CONFIG_LAYOUT, false));
  menuActionList.Add(TMenuAction.Create(maMacro, nil, lblMacro, imgMacro, CONFIG_LAYOUT, lmNone, false, false, false));
  menuActionList.Add(TMenuAction.Create(maMultimedia, nil, lblMedia, imgMedia, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maMouseClicks, nil, lblMouseClicks, imgMouseClicks, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maFuncKeys, nil, lblFunctionKeys, imgFuncKeys, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maFnAccess, nil, lblFunctionAccess, imgFnAccess, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maFullKeypad, nil, lblFullKeypad, imgFullKeypad, CONFIG_LAYOUT, lmNone, true, false, false));
  menuActionList.Add(TMenuAction.Create(maKeypadActions, nil, lblKeypadActions, imgKeypadActions, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maAltLayouts, nil, lblAltLayouts, imgAltLayouts, CONFIG_LAYOUT, lmNone, true, false, false));
  menuActionList.Add(TMenuAction.Create(maPreHotkeys, nil, lblPreHotkeys, imgPreHotkeys, CONFIG_LAYOUT, lmNone, true, false, false));
  menuActionList.Add(TMenuAction.Create(maTapHold, nil, lblTapHold, imgTapHold, CONFIG_LAYOUT, lmNone, false, false, true));
  menuActionList.Add(TMenuAction.Create(maBacklight, nil, lblLedControl, imgBacklight, CONFIG_LAYOUT, lmNone, false, false, true));
  menuActionList.Add(TMenuAction.Create(maMultimodifiers, nil, lblMultimodifiers, imgMultimodifiers, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maSpecialActions, nil, lblSpecialActions, imgSpecialActions, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maDisable, nil, lblDisableKey, imgDisableKey, CONFIG_LAYOUT, lmNone, false, false, true));

  menuActionList.Add(TMenuAction.Create(maFreestyle, nil,  lblFreestyle, imgFreestyle, CONFIG_LIGHTING, lmFreestyle, false, true, false));
  menuActionList.Add(TMenuAction.Create(maMonochrome, nil, lblMonochrome, imgMonochrome, CONFIG_LIGHTING, lmMonochrome, false, true, false));
  menuActionList.Add(TMenuAction.Create(maBreathe, nil, lblBreathe, imgBreathe, CONFIG_LIGHTING, lmBreathe, false, true, false));
  menuActionList.Add(TMenuAction.Create(maWave, nil, lblRGBWave, imgWave, CONFIG_LIGHTING, lmWave, false, true, false));
  menuActionList.Add(TMenuAction.Create(maSpectrum, nil, lblRGBSpectrum, imgSpectrum, CONFIG_LIGHTING, lmSpectrum, false, true, false));
  menuActionList.Add(TMenuAction.Create(maReactive, nil, lblReactive, imgReactive, CONFIG_LIGHTING, lmReactive, false, true, false));
  menuActionList.Add(TMenuAction.Create(maRipple, nil, lblRipple, imgRipple, CONFIG_LIGHTING, lmRipple, false, true, false));
  menuActionList.Add(TMenuAction.Create(maFireball, nil, lblFireball, imgFireball, CONFIG_LIGHTING, lmFireball, false, true, false));
  menuActionList.Add(TMenuAction.Create(maStarlight, nil, lblStarlight, imgStarlight, CONFIG_LIGHTING, lmStarlight, false, true, false));
  menuActionList.Add(TMenuAction.Create(maRebound, nil, lblRebound, imgRebound, CONFIG_LIGHTING, lmRebound, false, true, false));
  menuActionList.Add(TMenuAction.Create(maLoop, nil, lblLoop, imgLoop, CONFIG_LIGHTING,  lmLoop, false, true, false));
  menuActionList.Add(TMenuAction.Create(maPulse, nil, lblPulse, imgPulse, CONFIG_LIGHTING, lmPulse, false, true, false));
  menuActionList.Add(TMenuAction.Create(maRain, nil, lblRain, imgRain, CONFIG_LIGHTING, lmRain, false, true, false));
  //menuActionList.Add(TMenuAction.Create(btnPitchBlack, lblPitchBlack, imgPitchBlack, CONFIG_LIGHTING, false, true, false));
  menuActionList.Add(TMenuAction.Create(maDisableLed, nil, lblDisableLed, imgDisableLed, CONFIG_LIGHTING, lmDisabled, false, true, false));
end;

procedure TFormMainRGB.PositionMenuItems;
begin
  //Position layout menu (last first)
  imgDisableKey.Top := 0;
  imgSpecialActions.Top := 0;
  imgMultimodifiers.Top := 0;
  imgBacklight.Top := 0;
  imgTapHold.Top := 0;
  imgPreHotkeys.Top := 0;
  imgAltLayouts.Top := 0;
  imgKeypadActions.Top := 0;
  imgFullKeypad.Top := 0;
  imgFnAccess.Top := 0;
  imgFuncKeys.Top := 0;
  imgMouseClicks.Top := 0;
  imgMedia.Top := 0;
  imgMacro.Top := 0;

  //Position lighting menu (last first)
  imgDisableLed.Top := 0;
  //imgPitchBlack.Top := 0;
  imgRain.Top := 0;
  imgPulse.Top := 0;
  imgLoop.Top := 0;
  imgRebound.Top := 0;
  imgStarlight.Top := 0;
  imgFireball.Top := 0;
  imgRipple.Top := 0;
  imgReactive.Top := 0;
  imgSpectrum.Top := 0;
  imgWave.Top := 0;
  imgBreathe.Top := 0;
  imgMonochrome.Top := 0;
  imgFreestyle.Top := 0;

end;

procedure TFormMainRGB.FillHoveredList;
var
  i: integer;
  obj: TObject;
begin
  hoveredList := TObjectList.Create(true);

  //Settings top right
  hoveredList.Add(THoveredObj.Create(btnSettings, imgListSettings, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnImport, imgListSettings, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnFirmware, imgListSettings, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnExport, imgListSettings, 6, 7));
  hoveredList.Add(THoveredObj.Create(btnDiagnostic, imgListSettings, 8, 9));
  hoveredList.Add(THoveredObj.Create(btnHelp, imgListSettings, 10, 11));
  hoveredList.Add(THoveredObj.Create(btnEject, imgListSettings, 12, 13));

  //Save profile section
  hoveredList.Add(THoveredObj.Create(btnSave, imgListSave, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnSaveAs, imgListSave, 2, 3));

  //Profile section buttons
  hoveredList.Add(THoveredObj.Create(btnDone, imgListMiniIcons, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnCancel, imgListMiniIcons, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnResetKey, imgListMiniIcons, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnResetAll, imgListMiniIcons, 6, 7));

  //Zone buttons
  hoveredList.Add(THoveredObj.Create(btnAllZone, imgListZone, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnGameZone, imgListZone, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnLeftModule, imgListZone, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnRightModule, imgListZone, 6, 7));
  hoveredList.Add(THoveredObj.Create(btnNumberZone, imgListZone, 8, 9));
  hoveredList.Add(THoveredObj.Create(btnFunctionZone, imgListZone, 10, 11));
  hoveredList.Add(THoveredObj.Create(btnWASDZone, imgListZone, 12, 13));
  hoveredList.Add(THoveredObj.Create(btnArrowZone, imgListZone, 14, 15));

  //Direction buttons
  hoveredList.Add(THoveredObj.Create(btnDirUp, imgListDirection, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnDirDown, imgListDirection, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnDirLeft, imgListDirection, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnDirRight, imgListDirection, 6, 7));
  hoveredList.Add(THoveredObj.Create(btnDirHorizontal, imgListDirection, 8, 9));
  hoveredList.Add(THoveredObj.Create(btnDirVertical, imgListDirection, 10, 11));

  //Macro actions
  hoveredList.Add(THoveredObj.Create(btnBackspaceMacro, imgListMacroActions, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnMouseClicksMacro, imgListMacroActions, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnClearMacro, imgListMacroActions, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnCommonShortcuts, imgListMacroActions, 6, 7));
  hoveredList.Add(THoveredObj.Create(btnCopy, imgListMacroActions, 8, 9));
  hoveredList.Add(THoveredObj.Create(btnTimingDelays, imgListMacroActions, 10, 11));
  hoveredList.Add(THoveredObj.Create(btnPaste, imgListMacroActions, 12, 13));
  hoveredList.Add(THoveredObj.Create(btnWindowsCombos, imgListMacroActions, 14, 15));

  //Macro buttons
  hoveredList.Add(THoveredObj.Create(btnCancelMacro, imgListMacro, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnDoneMacro, imgListMacro, 2, 3));

  //Macro co-triggers
  {$ifdef Win64}
  hoveredList.Add(THoveredObj.Create(btnLeftCtrl, imgListTriggers, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnLeftAlt, imgListTriggers, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnLeftShift, imgListTriggers, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnRightCtrl, imgListTriggers, 6, 7));
  hoveredList.Add(THoveredObj.Create(btnRightAlt, imgListTriggers, 8, 9));
  hoveredList.Add(THoveredObj.Create(btnRightShift, imgListTriggers, 10, 11));
  {$endif}
  {$ifdef Linux}
  hoveredList.Add(THoveredObj.Create(btnLeftCtrl, imgListTriggers, 0, 1));
  hoveredList.Add(THoveredObj.Create(btnLeftAlt, imgListTriggers, 2, 3));
  hoveredList.Add(THoveredObj.Create(btnLeftShift, imgListTriggers, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnRightCtrl, imgListTriggers, 6, 7));
  hoveredList.Add(THoveredObj.Create(btnRightAlt, imgListTriggers, 8, 9));
  hoveredList.Add(THoveredObj.Create(btnRightShift, imgListTriggers, 10, 11));
  {$endif}
  {$ifdef Darwin}
  hoveredList.Add(THoveredObj.Create(btnLeftCtrl, imgListTriggers, 12, 13));
  hoveredList.Add(THoveredObj.Create(btnLeftAlt, imgListTriggers, 14, 15));
  hoveredList.Add(THoveredObj.Create(btnLeftShift, imgListTriggers, 4, 5));
  hoveredList.Add(THoveredObj.Create(btnRightCtrl, imgListTriggers, 16, 17));
  hoveredList.Add(THoveredObj.Create(btnRightAlt, imgListTriggers, 18, 19));
  hoveredList.Add(THoveredObj.Create(btnRightShift, imgListTriggers, 10, 11));
  {$endif}

  //Set events for each item
  for i := 0 to hoveredList.Count - 1 do
  begin
    obj := (hoveredList.Items[i] as THoveredObj).Obj;
    if (obj is TColorSpeedButtonCS) then
    begin
      (obj as TColorSpeedButtonCS).OnMouseEnter := @ObjectMouseEnter;
      (obj as TColorSpeedButtonCS).OnMouseLeave := @ObjectMouseExit;
    end
    else if (obj is TImage) then
    begin
      //(obj as TImage).OnMouseMove := @ObjectMouseMove;
      (obj as TImage).OnMouseEnter := @ObjectMouseEnter;
      (obj as TImage).OnMouseLeave := @ObjectMouseExit;
    end;
  end;
end;

procedure TFormMainRGB.InitKeyButtons(container: TWinControl);
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

procedure TFormMainRGB.LoadKeyButtonRows;
begin
  //Cols
   SetLength(kbArrayCol1, 6);
  kbArrayCol1[0] := lbRow1_1;
  kbArrayCol1[1] := lbRow1_2;
  kbArrayCol1[2] := lbRow1_3;
  kbArrayCol1[3] := lbRow1_4;
  kbArrayCol1[4] := lbRow1_5;
  kbArrayCol1[5] := lbRow1_6;
  //
  SetLength(kbArrayCol2, 5);
  kbArrayCol2[0] := lbRow2_1;
  kbArrayCol2[1] := lbRow2_2;
  kbArrayCol2[2] := lbRow2_3;
  kbArrayCol2[3] := lbRow2_4;
  kbArrayCol2[4] := lbRow2_5;
  //
  SetLength(kbArrayCol3, 6);
  kbArrayCol3[0] := lbRow3_1;
  kbArrayCol3[1] := lbRow3_2;
  kbArrayCol3[2] := lbRow3_3;
  kbArrayCol3[3] := lbRow3_4;
  kbArrayCol3[4] := lbRow3_5;
  kbArrayCol3[5] := lbRow3_6;
  //
  SetLength(kbArrayCol4, 5);
  kbArrayCol4[0] := lbRow4_1;
  kbArrayCol4[1] := lbRow4_3;
  kbArrayCol4[2] := lbRow4_5;
  kbArrayCol4[3] := lbRow4_6;
  kbArrayCol4[4] := lbRow4_8;
  //
  SetLength(kbArrayCol5, 4);
  kbArrayCol5[0] := lbRow4_2;
  kbArrayCol5[1] := lbRow4_4;
  kbArrayCol5[2] := lbRow4_7;
  kbArrayCol5[3] := lbRow5_6;
  //
  SetLength(kbArrayCol6, 5);
  kbArrayCol6[0] := lbRow5_1;
  kbArrayCol6[1] := lbRow5_2;
  kbArrayCol6[2] := lbRow5_3;
  kbArrayCol6[3] := lbRow5_4;
  kbArrayCol6[4] := lbRow5_5;
  //
  SetLength(kbArrayCol7, 5);
  kbArrayCol7[0] := lbRow6_1;
  kbArrayCol7[1] := lbRow6_3;
  kbArrayCol7[2] := lbRow6_5;
  kbArrayCol7[3] := lbRow6_7;
  kbArrayCol7[4] := lbRow6_9;
  //
  SetLength(kbArrayCol8, 6);
  kbArrayCol8[0] := lbRow6_2;
  kbArrayCol8[1] := lbRow6_4;
  kbArrayCol8[2] := lbRow6_6;
  kbArrayCol8[3] := lbRow6_8;
  kbArrayCol8[4] := lbRow6_10;
  kbArrayCol8[5] := lbRow6_11;
  //
  SetLength(kbArrayCol9, 5);
  kbArrayCol9[0] := lbRow7_1;
  kbArrayCol9[1] := lbRow7_2;
  kbArrayCol9[2] := lbRow7_3;
  kbArrayCol9[3] := lbRow7_4;
  kbArrayCol9[4] := lbRow7_5;
  //
  SetLength(kbArrayCol10, 5);
  kbArrayCol10[0] := lbRow8_1;
  kbArrayCol10[1] := lbRow8_2;
  kbArrayCol10[2] := lbRow8_3;
  kbArrayCol10[3] := lbRow8_5;
  kbArrayCol10[4] := lbRow8_6;
  //
  SetLength(kbArrayCol11, 6);
  kbArrayCol11[0] := lbRow9_1;
  kbArrayCol11[1] := lbRow9_3;
  kbArrayCol11[2] := lbRow8_4;
  kbArrayCol11[3] := lbRow9_7;
  kbArrayCol11[4] := lbRow9_9;
  kbArrayCol11[5] := lbRow8_7;
  //
  SetLength(kbArrayCol12, 5);
  kbArrayCol12[0] := lbRow9_2;
  kbArrayCol12[1] := lbRow9_4;
  kbArrayCol12[2] := lbRow9_5;
  kbArrayCol12[3] := lbRow9_8;
  kbArrayCol12[4] := lbRow9_10;
  //
  SetLength(kbArrayCol13, 6);
  kbArrayCol13[0] := lbRow10_1;
  kbArrayCol13[1] := lbRow10_2;
  kbArrayCol13[2] := lbRow9_6;
  kbArrayCol13[3] := lbRow10_4;
  kbArrayCol13[4] := lbRow10_5;
  kbArrayCol13[5] := lbRow10_6;
  //
  SetLength(kbArrayCol14, 5);
  kbArrayCol14[0] := lbRow11_1;
  kbArrayCol14[1] := lbRow11_2;
  kbArrayCol14[2] := lbRow10_3;
  kbArrayCol14[3] := lbRow11_4;
  kbArrayCol14[4] := lbRow11_6;
  //
  SetLength(kbArrayCol15, 5);
  kbArrayCol15[0] := lbRow12_1;
  kbArrayCol15[1] := lbRow12_2;
  kbArrayCol15[2] := lbRow11_3;
  kbArrayCol15[3] := lbRow11_5;
  kbArrayCol15[4] := lbRow11_7;
  //
  SetLength(kbArrayCol16, 6);
  kbArrayCol16[0] := lbRow13_1;
  kbArrayCol16[1] := lbRow13_3;
  kbArrayCol16[2] := lbRow12_3;
  kbArrayCol16[3] := lbRow12_4;
  kbArrayCol16[4] := lbRow12_5;
  kbArrayCol16[5] := lbRow12_6;
  //
  SetLength(kbArrayCol17, 4);
  kbArrayCol17[0] := lbRow13_2;
  kbArrayCol17[1] := lbRow13_4;
  kbArrayCol17[2] := lbRow13_5;
  kbArrayCol17[3] := lbRow13_6;
  //
  SetLength(kbArrayCol18, 6);
  kbArrayCol18[0] := lbRow14_1;
  kbArrayCol18[1] := lbRow14_2;
  kbArrayCol18[2] := lbRow14_3;
  kbArrayCol18[3] := lbRow14_4;
  kbArrayCol18[4] := lbRow14_5;
  kbArrayCol18[5] := lbRow14_6;

  //Rows
  SetLength(kbArrayRow1, 17);
  kbArrayRow1[0] := lbRow1_1;
  kbArrayRow1[1] := lbRow3_1;
  kbArrayRow1[2] := lbRow4_1;
  kbArrayRow1[3] := lbRow4_2;
  kbArrayRow1[4] := lbRow5_1;
  kbArrayRow1[5] := lbRow6_1;
  kbArrayRow1[6] := lbRow6_2;
  kbArrayRow1[7] := lbRow7_1;
  kbArrayRow1[8] := lbRow8_1;
  kbArrayRow1[9] := lbRow9_1;
  kbArrayRow1[10] := lbRow9_2;
  kbArrayRow1[11] := lbRow10_1;
  kbArrayRow1[12] := lbRow11_1;
  kbArrayRow1[13] := lbRow12_1;
  kbArrayRow1[14] := lbRow13_1;
  kbArrayRow1[15] := lbRow13_2;
  kbArrayRow1[16] := lbRow14_1;

  SetLength(kbArrayRow2, 17);
  kbArrayRow2[0] := lbRow1_2;
  kbArrayRow2[1] := lbRow2_1;
  kbArrayRow2[2] := lbRow3_2;
  kbArrayRow2[3] := lbRow4_3;
  kbArrayRow2[4] := lbRow4_4;
  kbArrayRow2[5] := lbRow5_2;
  kbArrayRow2[6] := lbRow6_3;
  kbArrayRow2[7] := lbRow6_4;
  kbArrayRow2[8] := lbRow7_2;
  kbArrayRow2[9] := lbRow8_2;
  kbArrayRow2[10] := lbRow9_3;
  kbArrayRow2[11] := lbRow9_4;
  kbArrayRow2[12] := lbRow10_2;
  kbArrayRow2[13] := lbRow11_2;
  kbArrayRow2[14] := lbRow12_2;
  kbArrayRow2[15] := lbRow13_3;
  kbArrayRow2[16] := lbRow14_2;


  SetLength(kbArrayRow3, 17);
  kbArrayRow3[0] := lbRow1_3;
  kbArrayRow3[1] := lbRow2_2;
  kbArrayRow3[2] := lbRow3_3;
  kbArrayRow3[3] := lbRow4_5;
  kbArrayRow3[4] := lbRow5_3;
  kbArrayRow3[5] := lbRow6_5;
  kbArrayRow3[6] := lbRow6_6;
  kbArrayRow3[7] := lbRow7_3;
  kbArrayRow3[8] := lbRow8_3;
  kbArrayRow3[9] := lbRow8_4;
  kbArrayRow3[10] := lbRow9_5;
  kbArrayRow3[11] := lbRow9_6;
  kbArrayRow3[12] := lbRow10_3;
  kbArrayRow3[13] := lbRow11_3;
  kbArrayRow3[14] := lbRow12_3;
  kbArrayRow3[15] := lbRow13_4;
  kbArrayRow3[16] := lbRow14_3;

  SetLength(kbArrayRow4, 16);
  kbArrayRow4[0] := lbRow1_4;
  kbArrayRow4[1] := lbRow2_3;
  kbArrayRow4[2] := lbRow3_4;
  kbArrayRow4[3] := lbRow4_6;
  kbArrayRow4[4] := lbRow5_4;
  kbArrayRow4[5] := lbRow6_7;
  kbArrayRow4[6] := lbRow6_8;
  kbArrayRow4[7] := lbRow7_4;
  kbArrayRow4[8] := lbRow8_5;
  kbArrayRow4[9] := lbRow9_7;
  kbArrayRow4[10] := lbRow9_8;
  kbArrayRow4[11] := lbRow10_4;
  kbArrayRow4[12] := lbRow11_4;
  kbArrayRow4[13] := lbRow11_5;
  kbArrayRow4[14] := lbRow12_4;
  kbArrayRow4[15] := lbRow14_4;

  SetLength(kbArrayRow5, 16);
  kbArrayRow5[0] := lbRow1_5;
  kbArrayRow5[1] := lbRow2_4;
  kbArrayRow5[2] := lbRow3_5;
  kbArrayRow5[3] := lbRow4_7;
  kbArrayRow5[4] := lbRow5_5;
  kbArrayRow5[5] := lbRow6_9;
  kbArrayRow5[6] := lbRow6_10;
  kbArrayRow5[7] := lbRow7_5;
  kbArrayRow5[8] := lbRow8_6;
  kbArrayRow5[9] := lbRow9_9;
  kbArrayRow5[10] := lbRow9_10;
  kbArrayRow5[11] := lbRow10_5;
  kbArrayRow5[12] := lbRow11_6;
  kbArrayRow5[13] := lbRow12_5;
  kbArrayRow5[14] := lbRow13_5;
  kbArrayRow5[15] := lbRow14_5;

  SetLength(kbArrayRow6, 12);
  kbArrayRow6[0] := lbRow1_6;
  kbArrayRow6[1] := lbRow2_5;
  kbArrayRow6[2] := lbRow3_6;
  kbArrayRow6[3] := lbRow4_8;
  kbArrayRow6[4] := lbRow5_6;
  kbArrayRow6[5] := lbRow6_11;
  kbArrayRow6[6] := lbRow8_7;
  kbArrayRow6[7] := lbRow10_6;
  kbArrayRow6[8] := lbRow11_7;
  kbArrayRow6[9] := lbRow12_6;
  kbArrayRow6[10] := lbRow13_6;
  kbArrayRow6[11] := lbRow14_6;

  //SetLength(kbArrayRow7, 5);
  //kbArrayRow7[0] := lbRow7_1;
  //kbArrayRow7[1] := lbRow7_2;
  //kbArrayRow7[2] := lbRow7_3;
  //kbArrayRow7[3] := lbRow7_4;
  //kbArrayRow7[4] := lbRow7_5;
  //
  //SetLength(kbArrayRow8, 7);
  //kbArrayRow8[0] := lbRow8_1;
  //kbArrayRow8[1] := lbRow8_2;
  //kbArrayRow8[2] := lbRow8_3;
  //kbArrayRow8[3] := lbRow8_4;
  //kbArrayRow8[4] := lbRow8_5;
  //kbArrayRow8[5] := lbRow8_6;
  //kbArrayRow8[6] := lbRow8_7;
  //
  //SetLength(kbArrayRow9, 10);
  //kbArrayRow9[0] := lbRow9_1;
  //kbArrayRow9[1] := lbRow9_2;
  //kbArrayRow9[2] := lbRow9_3;
  //kbArrayRow9[3] := lbRow9_4;
  //kbArrayRow9[4] := lbRow9_5;
  //kbArrayRow9[5] := lbRow9_6;
  //kbArrayRow9[6] := lbRow9_7;
  //kbArrayRow9[7] := lbRow9_8;
  //kbArrayRow9[8] := lbRow9_9;
  //kbArrayRow9[9] := lbRow9_10;
  //
  //SetLength(kbArrayRow10, 6);
  //kbArrayRow10[0] := lbRow10_1;
  //kbArrayRow10[1] := lbRow10_2;
  //kbArrayRow10[2] := lbRow10_3;
  //kbArrayRow10[3] := lbRow10_4;
  //kbArrayRow10[4] := lbRow10_5;
  //kbArrayRow10[5] := lbRow10_6;
  //
  //SetLength(kbArrayRow11, 7);
  //kbArrayRow11[0] := lbRow11_1;
  //kbArrayRow11[1] := lbRow11_2;
  //kbArrayRow11[2] := lbRow11_3;
  //kbArrayRow11[3] := lbRow11_4;
  //kbArrayRow11[4] := lbRow11_5;
  //kbArrayRow11[5] := lbRow11_6;
  //kbArrayRow11[6] := lbRow11_7;
  //
  //SetLength(kbArrayRow12, 6);
  //kbArrayRow12[0] := lbRow12_1;
  //kbArrayRow12[1] := lbRow12_2;
  //kbArrayRow12[2] := lbRow12_3;
  //kbArrayRow12[3] := lbRow12_4;
  //kbArrayRow12[4] := lbRow12_5;
  //kbArrayRow12[5] := lbRow12_6;
  //
  //SetLength(kbArrayRow13, 6);
  //kbArrayRow13[0] := lbRow13_1;
  //kbArrayRow13[1] := lbRow13_2;
  //kbArrayRow13[2] := lbRow13_3;
  //kbArrayRow13[3] := lbRow13_4;
  //kbArrayRow13[4] := lbRow13_5;
  //kbArrayRow13[5] := lbRow13_6;
  //
  //SetLength(kbArrayRow14, 6);
  //kbArrayRow14[0] := lbRow14_1;
  //kbArrayRow14[1] := lbRow14_2;
  //kbArrayRow14[2] := lbRow14_3;
  //kbArrayRow14[3] := lbRow14_4;
  //kbArrayRow14[4] := lbRow14_5;
  //kbArrayRow14[5] := lbRow14_6;
end;

procedure TFormMainRGB.LoadAppSettings;
begin
  try
    loadingSettings := true;
    ColorChange(clRed);
    ColorChangeBase(clRed);
    AppSettingsLoaded := fileService.LoadAppSettings(GAppSettingsFile) = '';
    if (AppSettingsLoaded) then
    begin
      custColor1.Color := fileService.AppSettings.CustColor1;
      custColor2.Color := fileService.AppSettings.CustColor2;
      custColor3.Color := fileService.AppSettings.CustColor3;
      custColor4.Color := fileService.AppSettings.CustColor4;
      custColor5.Color := fileService.AppSettings.CustColor5;
      custColor6.Color := fileService.AppSettings.CustColor6;
      custColor7.Color := fileService.AppSettings.CustColor7;
      custColor8.Color := fileService.AppSettings.CustColor8;
      custColor9.Color := fileService.AppSettings.CustColor9;
      custColor10.Color := fileService.AppSettings.CustColor10;
      custColor11.Color := fileService.AppSettings.CustColor11;
      custColor12.Color := fileService.AppSettings.CustColor12;
    end;
  finally
    loadingSettings := false;
  end;
end;

function TFormMainRGB.LoadVersionInfo: boolean;
var
  errorMsg: string;
begin
  Result := False;

  errorMsg := fileService.LoadVersionInfo(GActiveDevice);

  if (errorMsg = '') then
  begin
    SetMenuEnabledFirmware;
    //firmware := fileService.FirmwareVersion;
    //idxThirdPoint := GetPosOfNthString(firmware, '.', 3) - 1;
    //if (idxThirdPoint < 0) then
    //  idxThirdPoint := Length(firmware);
    //eFirmware.Text := Copy(fileService.FirmwareVersion, 1, idxThirdPoint);
    Result := true;
  end;
end;

function TFormMainRGB.CheckVDrive: boolean;
begin
  result := LoadVersionInfo;
  if (result and showingVDriveErrorDlg) then
    CloseDialog(mrOK);
  SetVDriveState(Result);
  //lblVDriveOk.Visible := Result and not(GDemoMode);
  //lblVDriveError.Visible := not(Result) and not(GDemoMode);
  //lblDemoMode.Visible := GDemoMode;
end;

function TFormMainRGB.LoadStateSettings: boolean;
var
  errorMsg: string;
//const
//  TitleStateFile = 'Load State.txt File';
begin
  Result := False;

  try
    loadingSettings := true;
    errorMsg := fileService.LoadStateSettings(GActiveDevice);

    if (errorMsg = '') then
    begin
      currentLayoutFile := GLayoutFilePath + fileService.StateSettings.LayoutFile;
      currentProfileNumber := fileService.StateSettings.StartupFileNumber;
      currentLedFile := GLedFilePath + fileService.StateSettings.LedFile;
      Result := true;
    end
    else if (GDemoMode) then
    begin
      currentLayoutFile := '';
      currentProfileNumber := 1;
      currentLedFile := '';
      Result := true;
    end;
    //else
    //  ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  finally
    loadingSettings := false;
  end;
end;

function TFormMainRGB.LoadKeyboardLayout(layoutFile: string; fileContent: TStringList): boolean;
var
  errorMsg: string;
  layoutContent: TStringList;
  mustFree: boolean;
const
  TitleStateFile = 'Load Layout File';
begin
  Result := False;
  mustFree := true;
  errorMsg := '';

  if (not GDemoMode) then
  begin
    try
      if (fileContent <> nil) then
      begin
        layoutContent := fileContent;
        mustFree := false;
      end
      else
      begin
        layoutContent := TStringList.Create;
        errorMsg := fileService.LoadFile(layoutFile, layoutContent, false);
      end;

      if (errorMsg = '') then
      begin
        keyService.ActiveLayer := nil;
        ChangeActiveLayer(TOPLAYER_IDX);
        layoutFile := ExtractFileNameWithoutExt(ExtractFileName(layoutFile));
        keyService.ConvertFromTextFileFmt(layoutContent);
        LoadButtonImage(imgProfile, imgListProfileDefault, currentProfileNumber);
        Result := true;
      end
      else
      begin
        LoadButtonImage(imgProfile, imgListProfileDefault, 0);
        ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      end;

      SetActiveLayer(TOPLAYER_IDX);
      SetActiveKeyButton(nil);
      RefreshRemapInfo;
    finally
      if (layoutContent <> nil) and mustFree then
        FreeAndNil(layoutContent);
    end;
  end;
end;

function TFormMainRGB.LoadLedFile(ledFile: string; fileContent: TStringList): boolean;
var
  errorMsg: string;
  ledContent: TStringList;
  mustFree: boolean;
const
  TitleStateFile = 'Load Led File';
begin
  Result := False;
  mustFree := true;
  errorMsg := '';

  if (not GDemoMode) then
  begin
    try
      if (fileContent <> nil) then
      begin
        ledContent := fileContent;
        mustFree := false;
      end
      else
      begin
        ledContent := TStringList.Create;
        errorMsg := fileService.LoadFile(ledFile, ledContent, false);
      end;

      if (errorMsg = '') then
      begin
        try
          loadingSettings := true;
          ledFile := ExtractFileNameWithoutExt(ExtractFileName(ledFile));
          keyService.ConvertLedFromTextFileFmt(ledContent);
          Result := true;
        finally
          loadingSettings := false;
        end;
      end
      else
      begin
        ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      end;

      if (ConfigMode = CONFIG_LIGHTING) then
        SetLedMode(keyService.LedMode);
    finally
      if (ledContent <> nil) and mustFree then
        FreeAndNil(ledContent);
    end;
  end;
end;

procedure TFormMainRGB.SetSaveState(layoutState: TSaveState;
  lightingState: TSaveState);
begin
  SaveStateLayout := layoutState;
  SaveStateLighting := lightingState;
  //btnSave.Enabled := SaveState = ssModified;
end;

procedure TFormMainRGB.btnSaveClick(Sender: TObject);
begin
  SaveAll;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnSaveAsClick(Sender: TObject);
begin
  //SaveAsAll(false);
  //SetHovered(sender, false, true);
  profileMode := pmSaveAs;
  pnlSelectProfile.Left := btnSaveAs.Left;
  pnlSelectProfile.Top := btnSaveAs.Top + btnSaveAs.Height;
  pnlSelectProfile.Visible := true;
  //SetMousePosition(pnlSelectProfile.Left + 50, pnlSelectProfile.Top + 10);
  SetHovered(sender, true);
end;


procedure TFormMainRGB.btnSettingsClick(Sender: TObject);
begin
  ShowSettings;
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

function TFormMainRGB.ValidateBeforeSave: boolean;
var
  errorMsg: string;
  errorTitle: string;
  isValid: boolean;
  macrosToRemove: integer;
begin
  isValid := true;

  RefreshRemapInfo;

  if (macroCount > maxMacros) then
  begin
    isValid := false;
    macrosToRemove := macroCount - maxMacros;
    errorTitle := 'Macro Capacity Reached';
    errorMsg := 'Please delete ' + IntToStr(macrosToRemove) + ' macros before proceeding. Each layout can accommodate a maximum of ' + IntToStr(maxMacros) + ' macros.';
  end
  else
  begin
    if (totalKeystrokes > maxKeystrokes) then
    begin
      isValid := false;
      errorTitle := 'Macro Limit Reached';
      errorMsg := 'You have reached the macro limit for Profile ' + IntToStr(currentProfileNumber) + '. To proceed, please delete an unused macro from this layout or create a new layout.';
    end;
  end;

  if (not isValid) then
  begin
    ShowDialog(errorTitle, errorMsg, mtError, [mbOk]);
  end;

  result := isValid;
end;

function TFormMainRGB.SaveAll(isNew: boolean; showSaveDialog: boolean): boolean;
var
  errorMsg: string;
  layoutContent: TStringList;
  ledContent: TStringList;
  hideNotif: integer;
  diagMessage: string;
  diagTitle: string;
  dialHeight: integer;
  continue: boolean;
  profileNumber: integer;
  fileName: string;
begin
  result := false;
  errorMsg := '';
  continue := true;

  if (GDemoMode) then
    continue := false;

  if continue and (not CheckVDrive) then
    continue := ShowTroubleshootingDialog(false);

  if (continue) then
  begin
    if (CheckSaveKey(true)) then
      continue := ValidateBeforeSave
    else
      continue := false;
  end;

  if (continue) then
  begin
    layoutContent := keyService.ConvertToTextFileFmt;
    if fileService.SaveFile(currentLayoutFile, layoutContent, true, errorMsg) then
    begin
      ledContent := keyService.ConvertLedToTextFileFmt;
      if fileService.SaveFile(currentLedFile, ledContent, true, errorMsg) then
      begin
        fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLayoutFile));
        profileNumber := fileService.GetFileNumber(currentLayoutFile);
        currentProfileNumber := profileNumber;
        SetSaveState(ssNone, ssNone);
        result := true;

        if not closing then
          EjectDevice(GActiveDevice);

        if (ShowNotification(fileService.AppSettings.SaveMsg)) and (showSaveDialog) then
        begin
          if (profileNumber = fileService.StateSettings.StartupFileNumber) then
          begin
            diagMessage := 'Use the Refresh Shortcut (SmartSet + Profile) to preview your Layout and Lighting updates or simply Eject the “FS EDGE RGB” drive in File Explorer and then disconnect the v-Drive (SmartSet + F8).';
            diagTitle := 'Profile ' + IntToStr(profileNumber) + ' Saved';
            dialHeight := DEFAULT_DIAG_HEIGHT_RGB;
          end
          else
          begin
            diagMessage := 'To load Profile ' + IntToStr(profileNumber) + ' to the keyboard, hold the SmartSet key and tap the ' + IntToStr(profileNumber) + ' key.';
            diagTitle := 'Profile ' + IntToStr(profileNumber) + ' Saved';
            dialHeight := DEFAULT_DIAG_HEIGHT_RGB;
          end;
          hideNotif := ShowDialog(diagTitle, diagMessage,
            mtInformation, [mbOK], dialHeight, nil, 'Hide this notification?');
          if (hideNotif >= DISABLE_NOTIF) then
          begin
            fileService.SetSaveMsg(true);
            fileService.SaveAppSettings;
          end;
        end;
      end
      else
        ShowDialog('Save Profile', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
          mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      if (ledContent <> nil) then
        FreeAndNil(ledContent);
    end
    else
      ShowDialog('Save Profile', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
        mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

    if (layoutContent <> nil) then
      FreeAndNil(layoutContent);
  end;
  //if continue and (CheckSaveKey) and ((SaveStateLayout = ssModified) or isNew) then
  //begin
  //  layoutContent := keyService.ConvertToTextFileFmtRGB;
  //  if fileService.SaveFile(currentLayoutFile, layoutContent, isNew, errorMsg) then
  //  begin
  //    if (not fileService.AppSettings.SaveMsg) and (showSaveDialog) then
  //    begin
  //      fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLayoutFile));
  //      currentProfileNumber := fileService.GetFileNumber(currentLayoutFile);
  //      isCustomLayout := LowerCase(Copy(fileName, 1, Length(FILE_LAYOUT))) <> FILE_LAYOUT;
  //      if (isCustomLayout) then
  //      begin
  //        diagMessage := 'This custom layout has been saved as ' + filename + '. To load this layout to the keyboard it must first be assigned to position 1-9 using the Save As button.';
  //        diagTitle := 'Backup Layout Saved';
  //        dialHeight := DEFAULT_DIAG_HEIGHT_RGB;
  //      end
  //      else
  //      begin
  //        diagMessage := 'Your changes have been saved to Layout ' + IntToStr(currentProfileNumber) + '. To implement your changes, use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive (SmartSet + F8).' +
  //          ' To load this layout to the keyboard, press the SmartSet + ' + IntToStr(currentProfileNumber) + '.' + #10#10 +
  //          'Note: Changes to the keyboard lighting and settings must be saved separately before exiting the SmartSet App.';
  //        diagTitle := 'Layout Saved';
  //        dialHeight := 250;
  //      end;
  //      hideNotif := ShowDialog(diagTitle, diagMessage,
  //        mtInformation, [mbOK], dialHeight, nil, 'Hide this notification?');
  //      if (hideNotif >= DISABLE_NOTIF) then
  //      begin
  //        fileService.SetSaveMsg(true);
  //        fileService.SaveAppSettings;
  //      end;
  //    end;
  //    SetSaveState(ssNone, SaveStateLighting);
  //    result := true;
  //  end
  //  else
  //    ShowDialog('Save', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
  //      mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  //
  //  if result and continue and ((SaveStateLighting = ssModified) or isNew) then
  //  begin
  //    layoutContent := keyService.ConvertLedToTextFileFmtFS;
  //    if fileService.SaveFile(currentLedFile, layoutContent, isNew, errorMsg) then
  //    begin
  //      if (not fileService.AppSettings.SaveMsgLighting) and (showSaveDialog) then
  //      begin
  //        fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLedFile));
  //        isCustomLayout := LowerCase(Copy(fileName, 1, Length(FILE_LED))) <> FILE_LED;
  //        if currentMenuAction <> nil then
  //          sLedMode := currentMenuAction.ActionLabel.Caption;
  //        if (isCustomLayout) then
  //        begin
  //          diagMessage := 'This ' + sLedMode + ' Effect has been saved as backup file ' + filename + '. To load this Lighting Profile to the keyboard it must first be assigned to position 1-9 using the Save As button.';
  //          diagTitle := 'Backup Lighting Saved';
  //          dialHeight := DEFAULT_DIAG_HEIGHT_RGB;
  //        end
  //        else
  //        begin
  //          diagMessage := sLedMode + ' Effect has been saved to Lighting Profile ' + IntToStr(currentProfileNumber) + '.' +
  //            ' To implement this Lighting Profile use the Refresh Shortcut (SmartSet + Layout) or simply close the v-Drive.' +
  //            ' To load this Lighting Profile to the keyboard, press SmartSet + the Backlight key, then press number ' + IntToStr(currentProfileNumber) + ' and SmartSet to Exit.' + #10#10 +
  //            'Note: Changes to the keyboard layout and settings must be saved separately before exiting the SmartSet App.';
  //          diagTitle := 'Lighting Profile Saved';
  //          dialHeight := 300;
  //        end;
  //        hideNotif := ShowDialog(diagTitle, diagMessage,
  //          mtInformation, [mbOK], dialHeight, nil, 'Hide this notification?');
  //        if (hideNotif >= DISABLE_NOTIF) then
  //        begin
  //          fileService.SetSaveMsgLighting(true);
  //          fileService.SaveAppSettings;
  //        end;
  //      end;
  //
  //      fileService.SaveStateSettings;
  //
  //      SetSaveState(SaveStateLayout, ssNone);
  //      result := true;
  //    end
  //    else
  //      ShowDialog('Save', 'Error saving file: ' + errorMsg + #10 + 'Confirm that the v-drive is still open.',
  //        mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  //  end;
  //end;
end;

procedure TFormMainRGB.SaveAsAll(profileNumber: string; isNew: boolean = false);
var
  //fileNumber: string;
  continue: boolean;
begin
  try
    NeedInput := True;
    continue := true;

    if (GDemoMode) then
      continue := false;

    if continue and (not CheckVDrive) then
      continue := ShowTroubleshootingDialog(false);

    if (continue) then
    begin
      if (CheckSaveKey(true)) then
        continue := ValidateBeforeSave
      else
        continue := false;
    end;

    if (continue) then
    begin
      //fileNumber := ShowSaveAs('Save As', currentLayoutFile, CONFIG_LAYOUT, isBackupFile, layoutPosition);
      if (profileNumber <> '') then
      begin
        if (isNew) then
          keyService.ResetLayout;
        currentLayoutFile := GLayoutFilePath + FILE_LAYOUT + profileNumber + '.txt';
        currentLedFile := GLedFilePath + FILE_LED + profileNumber + '.txt';
        currentProfileNumber := fileService.GetFileNumber(currentLayoutFile);

        SaveAll(true, true);
        LoadKeyboardLayout(currentLayoutFile, nil);
      end;
    end;
  finally
      NeedInput := False;
  end;

end;

procedure TFormMainRGB.LoadLayer(layer: TKBLayer);
begin
  try
    if (layer <> nil) then
    begin
      if (ConfigMode = CONFIG_LAYOUT) then
        ReloadKeyButtons
      else
        SetLedMode(keyService.LedMode);
    end;
  finally
  end;
end;

procedure TFormMainRGB.ReloadKeyButtons;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  SetActiveKeyButton(nil);
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    UpdateKeyButtonKey(aKbKey, keyButton, false, true);
  end;

  RepaintForm(false);
end;

procedure TFormMainRGB.ReloadKeyButtonsColor(reset: boolean; repainForm: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  keyButtonFrame: TLabelBox;
  aKbKey: TKBKey;
  gifKey: integer;
  gifFrame: TGifFrame;
  aColor: TColor;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);

    keyButton.Caption := '';
    keyButton.BorderStyle := bsNone;
    if reset then
    begin
      keyButton.BackColor := clNone;
      //aKbKey.KeyColor := clNone;
    end
    else
    begin
      keyButton.Opaque := (keyService.LedMode <> lmBreathe) and (keyService.LedMode <> lmPulse);
      keyButton.Transparency := breatheTransparency;
      if (keyService.LedMode in [lmFreestyle, lmBreathe]) then
      begin
          keyButton.BackColor := aKbKey.KeyColor;
      end
      else if (keyService.LedMode in [lmSpectrum]) then
        keyButton.BackColor := spectrumColor
      else if (keyService.LedMode in [lmPulse]) then
        keyButton.BackColor := pulseColor
      else if (keyService.LedMode in [lmMonochrome]) then
        keyButton.BackColor := keyService.LedColorMono
      else if (keyService.LedMode in [lmReactive]) then
      begin
        aColor := keyService.BaseLedColorReactive;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorReactive;;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
        //keyButton.BackColor := keyService.LedColorReactive
      end
      else if (keyService.LedMode in [lmRipple]) then
      begin
        aColor := keyService.BaseLedColorRipple;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorRipple;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
        //keyButton.BackColor := keyService.LedColorRipple
      end
      else if (keyService.LedMode in [lmFireball]) then
      begin
        aColor := keyService.BaseLedColorFireball;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorFireball;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
        //keyButton.BackColor := keyService.LedColorFireball
      end
      else if (keyService.LedMode in [lmStarlight]) then
      begin
        aColor := keyService.BaseLedColorStarlight;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorStarlight;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
      end
      else if (keyService.LedMode in [lmRebound]) then
      begin
        aColor := keyService.BaseLedColorRebound;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorRebound;;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
      end
      else if (keyService.LedMode in [lmLoop]) then
      begin
        aColor := keyService.BaseLedColorLoop;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorLoop;;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
      end
      else if (keyService.LedMode in [lmRain]) then
      begin
        aColor := keyService.BaseLedColorRain;
        if (keyService.ActiveGif <> nil) then
        begin
          gifFrame := keyService.ActiveGif.Items[gifFrameIdx - 1];
          if (gifFrame <> nil) then
          begin
            for gifKey := 0 to gifFrame.Keys.Count - 1 do
            begin
              if (aKbKey.Index = gifFrame.Keys.Items[gifKey]) then
                aColor := keyService.LedColorRain;;
            end;
          end;
        end;
        keyButton.BackColor := aColor;
      end
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
  if (repainForm) then
     RepaintForm(false);
end;


procedure TFormMainRGB.SetSingleKeyColor(keyButton: TLabelBox; newColor: TColor);
var
  aKbKey: TKBKey;
begin
  if (keyButton <> nil) then
  begin
    aKbKey := keyService.GetKbKeyByIndex(keyService.ActiveLayer, keyButton.Index);
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

procedure TFormMainRGB.KeyButtonsBringToFront;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.BringToFront;
  end;
end;

procedure TFormMainRGB.KeyButtonsSendToBack;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.SendToBack;
  end;
end;

procedure TFormMainRGB.ShowHideKeyButtons(value: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.Visible := value;
  end;
end;

function TFormMainRGB.CheckConfigMode(modeToCheck: integer): boolean;
begin
  result := true;
  if (modeToCheck <> ConfigMode) then
  begin
    if (modeToCheck = CONFIG_LAYOUT) then
      ShowDialog('Editor', 'Your must select the Layout editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
    else
      ShowDialog('Editor', 'Your must select the Lighting editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
    result := false;
  end;
end;

procedure TFormMainRGB.SaveStateSettings;
var
  errorMsg: string;
const
  TitleStateFile = 'Save State.txt File';
begin
  errorMsg := fileService.SaveStateSettings(GActiveDevice);

  if (errorMsg <> '') then
    ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
end;

function TFormMainRGB.CheckSaveKey(canSave: boolean; checkMacroOpen: boolean
  ): boolean;
var
  msgResult: integer;
begin
  result := true;

  //if checkMacroOpen and EditingMacro(true) then
  //  result := false
  //else
  //begin
    if IsKeyLoaded and MacroModified then
    begin
      if (canSave) then
      begin
        msgResult := ShowDialog('Apply changes',
          'This macro has been modified, do you want to apply these changes?', mtConfirmation,
          [mbYes, mbNo, mbCancel], DEFAULT_DIAG_HEIGHT_RGB);
      if msgResult = mrYes then
        result := AcceptMacro
       else if msgResult = mrNo then
        CancelMacro
      else
        result := false;
      end
      else
      begin
        ShowDialog('Macro', 'You must finish editing macro before proceeding', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
        result := false;
      end;
    end
    else if IsKeyLoaded and KeyModified then
      result := DoneKey;

    //if result and checkMacroOpen and EditingMacro then
    //begin
    //  pnlMacro.Visible := false;
    //end;
  //end;
end;

function TFormMainRGB.CheckToSave(checkForVDrive: boolean): boolean;
var
  dialogResult: integer;
  mustRestartGif: boolean;
begin
  result := true;
  if ((SaveStateLayout = ssModified) or (SaveStateLighting = ssModified)) and not(GDemoMode) then
  begin
    if checkForVDrive and (not CheckVDrive) then
      result := ShowTroubleshootingDialog(false);

    if (result) then
    begin
      mustRestartGif := false;
      if (ConfigMode = CONFIG_LIGHTING) and gifViewer.Visible and gifViewer.Playing then
      begin
        gifViewer.Stop;
        mustRestartGif := true;
      end;

      dialogResult := ShowDialog('Save',
        'Do you want to save changes to Profile ' + IntToStr(currentProfileNumber) + '?',
        mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB);

      if dialogResult = mrYes then
        result := SaveAll(false, false)
      else if dialogResult = mrNo then
        SetSaveState(ssNone, ssNone)
      else
        result := false;

      if (mustRestartGif) then
        gifViewer.Start;
    end;
  end;
end;

procedure TFormMainRGB.RefreshRemapInfo;
var
  i, j:integer;
  aLayer: TKBLayer;
  aKbKey: TKBKey;
begin
  remapCount := 0;
  macroCount := 0;
  tapHoldCount := 0;
  totalKeystrokes := 0;
  for i := 0 to keyService.KBLayers.Count - 1 do
  begin
    aLayer := keyService.KBLayers[i];
    for j := 0 to aLayer.KBKeyList.Count - 1 do
    begin
      aKbKey := aLayer.KBKeyList[j];
      if (aKbKey.TapAndHold) then
        inc(tapHoldCount)
      else if (aKbKey.IsModified) then
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

  totalKeystrokes := keyService.CountAllKeystrokes;

  lblMacroInfo.Caption := IntToStr(macroCount) + '/' + IntToStr(maxMacros) + '  (' + IntToStr(trunc((totalKeystrokes / maxKeystrokes) * 100)) + '% Full)'

  //jm temp
  //if (remapCount + macroCount > 0) then
  //  lblRemapCount.Caption := IntToStr(remapCount + macroCount)
  //else
  //  lblRemapCount.Caption := '';

  //btnResetLayer.Enabled := (remapCount > 0) or (macroCount > 0);
  //btnResetAll.Enabled := (remapCount > 0) or (macroCount > 0);
end;

procedure TFormMainRGB.watchTutorialClick(Sender: TObject);
begin
  OpenUrl(RGB_TUTORIAL);
end;

procedure TFormMainRGB.readManualClick(Sender: TObject);
//var
//  filePath: string;
begin
  OpenUrl(RGB_HELP);
  //filePath := GApplicationPath + '\help\' + USER_MANUAL_FSEDGE;
  //{$ifdef Darwin}filePath := GApplicationPath + '/help/' + USER_MANUAL_FSEDGE;{$endif}
  //
  //if FileExists(filePath) then
  //  OpenDocument(filePath)
  //else
  //  ShowDialog('Help file', 'Help file not found!', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
end;

procedure TFormMainRGB.openTroubleshootingTipsClick(Sender: TObject);
begin
  OpenUrl(RGB_TROUBLESHOOT);
end;

procedure TFormMainRGB.ScanVDrive(init: boolean);
begin
  if (init) then
  begin
    CloseDialog(mrOK);
    if (SetBaseDirectory) then
      ResetAppPaths;
    InitApp(true);
  end
  else
  begin
    if (CheckVDrive) then
    begin
      CloseDialog(mrOK);
      if (SetBaseDirectory) then
        ResetAppPaths;
    end;
  end;
end;

procedure TFormMainRGB.LaunchDemoMode;
begin
  GDemoMode := true;
  if (CheckVDrive or GDemoMode) then
  begin
    CloseDialog(mrOK);
    if (SetBaseDirectory) then
      ResetAppPaths;
    InitApp(false);
  end;
end;

procedure TFormMainRGB.scanVDriveClick(Sender: TObject);
begin
  ScanVDrive(false);
end;

procedure TFormMainRGB.scanVDriveInitClick(Sender: TObject);
begin
  ScanVDrive(false);
end;

procedure TFormMainRGB.SetConfigMode(mode: integer; init: boolean);
var
  i:integer;
  canContinue: boolean;
  menuAction: TMenuAction;
begin
  canContinue := true;

  //Stop and hide gif viewer first
  BreatheTimer.Enabled := false;
  LoadGifTimer.Enabled := false;
  NewGifTimer.Enabled := false;
  WaveTimer.Enabled := false;
  gifViewer.Visible := false;
  ShowHideKeyButtons(false);
  ReloadKeyButtonsColor(true, false);
  SetLayoutMenuColor;
  //if (gifViewer.Playing) then
  //  gifViewer.Stop;

  //Process messages to speed up processing
  Application.ProcessMessages;

  canContinue := CheckSaveKey;

  if (canContinue) then
  begin
    SetCurrentMenuAction(maNone, nil);
    ConfigMode := mode;
    if (ConfigMode = CONFIG_LAYOUT) then
    begin
      pnlLayoutBtn.Color := KINESIS_DARK_GRAY_RGB;
      pnlLightingBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlLighting.Visible := false;
      pnlLighting.Align := alNone;
      pnlLayout.Align := alClient;
      pnlLayout.Visible := true;
      //pnlProfile.Height := 715;
      pnlProfile.Repaint;
      PositionMenuItems;
      imgKeyboardLayout.Visible := true;
      imgKeyboardLighting.Visible := false;
      btnResetAll.Hint := 'Reset layout to default';
      //btnDisableLed.Visible := false;
      //btnCancel.Top := 715;
      //btnDone.Top := 715;
      //btnResetKey.Top := 715;
      //btnResetAll.Top := 715;
      //imgListSave.GetBitmap(0, btnLoadLayout.Glyph);
      //imgListSave.GetBitmap(1, btnSave.Glyph);
      //imgListSave.GetBitmap(2, btnSaveAs.Glyph);
      //imgListSave.GetBitmap(3, btnLoadLighting.Glyph);
      //imgListSave.GetBitmap(4, btnSaveLighting.Glyph);
      //imgListSave.GetBitmap(5, btnSaveAsLighting.Glyph);
      KeyButtonsBringToFront;
      ShowHideKeyButtons(true);
      SetCurrentMenuAction(maNone, nil);
    end
    else
    begin
      CloseMacroEditor;
      pnlLayoutBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlLightingBtn.Color := KINESIS_DARK_GRAY_RGB;
      pnlLayout.Align := alNone;
      pnlLayout.Visible := false;
      pnlLighting.Align := alClient;
      pnlLighting.Visible := true;
      //pnlProfile.Height := 670;
      pnlProfile.Repaint;
      PositionMenuItems;
      imgKeyboardLayout.Visible := false;
      imgKeyboardLighting.Visible := true;
      btnResetAll.Hint := 'Erase color assignments for all keys';
      //btnDisableLed.Visible := true;
      //btnCancel.Top := 545;
      //btnDone.Top := 545;
      //btnResetKey.Top := 545;
      //btnResetAll.Top := 545;
      //imgListSave.GetBitmap(3, btnLoadLayout.Glyph);
      //imgListSave.GetBitmap(4, btnSave.Glyph);
      //imgListSave.GetBitmap(5, btnSaveAs.Glyph);
      //imgListSave.GetBitmap(0, btnLoadLighting.Glyph);
      //imgListSave.GetBitmap(1, btnSaveLighting.Glyph);
      //imgListSave.GetBitmap(2, btnSaveAsLighting.Glyph);
    end;

    //imgLeftMenu.Visible := ConfigMode = CONFIG_LAYOUT;
    swLayerSwitch.Visible := (ConfigMode = CONFIG_LAYOUT) or (fileService.VersionBiggerEqualLED(1, 0, 44)) or (GDemoMode);
    btnCancel.Visible := ConfigMode = CONFIG_LAYOUT;
    btnDone.Visible := ConfigMode = CONFIG_LAYOUT;
    btnResetKey.Visible := ConfigMode = CONFIG_LAYOUT;
    btnResetAll.Visible := true; //ConfigMode = CONFIG_LAYOUT;
    //lblDisable.Visible := ConfigMode = CONFIG_LIGHTING;
    //chkDisable.Visible := ConfigMode = CONFIG_LIGHTING;

    if (ConfigMode = CONFIG_LAYOUT) then
    begin
      ShowHideParameters(PARAM_COLOR, lmNone, false);
      ShowHideParameters(PARAM_BASECOLOR, lmNone, false);
      ShowHideParameters(PARAM_DIRECTION, lmNone, false);
      ShowHideParameters(PARAM_SPEED, lmNone, false);
      ShowHideParameters(PARAM_RANGE, lmNone, false);
      ShowHideParameters(PARAM_ZONE, lmNone, false);
    end;

    for I:= 0 to menuActionList.Count - 1 do
    begin
      menuAction := (menuActionList.Items[i] as TMenuAction);
      //jm temp menuAction.ActionButton.Visible := menuAction.MenuConfig = ConfigMode;
      //jm temp menuAction.ActionLabel.Visible := menuAction.MenuConfig = ConfigMode;
    end;

    //Process messages to speed up processing
    Application.ProcessMessages;

    if (ConfigMode = CONFIG_LIGHTING) then
    begin
      SetLedMode(keyService.LedMode);
    end
    else
    begin
      ReloadKeyButtons;
      if (gifViewer.Playing) then
        gifViewer.Stop;
    end;
  end;
end;

procedure TFormMainRGB.ShowHideParameters(param: integer; ledMode: TLedMode; state: boolean);
begin
  case param of
    PARAM_COLOR:
    begin
      pnlEffectColor.Visible := state;
      pnlEffectColor.Repaint;
    end;
    PARAM_BASECOLOR:
    begin
      pnlBaseColor.Visible := state and ((fileService.VersionBiggerEqualLED(1, 0, 44)) or (GDemoMode));
      pnlBaseColor.Repaint;
    end;
    PARAM_DIRECTION:
    begin
      pnlDirection.Visible := state;
      btnDirUp.Visible := not(ledMode in [lmRebound]);
      btnDirDown.Visible := not(ledMode in [lmRebound]);
      btnDirLeft.Visible := not(ledMode in [lmRebound]);
      btnDirRight.Visible := not(ledMode in [lmRebound]);
      btnDirHorizontal.Visible := ledMode in [lmRebound];
      btnDirVertical.Visible := ledMode in [lmRebound];
      pnlDirection.Repaint;
    end;
    PARAM_SPEED:
    begin
      pnlSpeed.Visible := state;
      pnlSpeed.Repaint;
    end;
    PARAM_RANGE:
    begin
    end;
    PARAM_ZONE:
    begin
      pnlZone.Visible := state;
      pnlZone.Repaint;
    end;
  end;
end;

procedure TFormMainRGB.SetRemapMode(value: boolean);
begin
  //if RemapMode and not(value) then
  //  SetActiveKeyButton(nil);
  //
  //RemapMode := value;
  //
  //if (RemapMode) then
  //begin
  //
  //end
  //else
  //begin
  //
  //end;
end;

procedure TFormMainRGB.SetMacroMode(value: boolean);
begin
  if MacroMode and not(value) then
    SetActiveKeyButton(nil);

  MacroMode := value;

  if (MacroMode) then
  begin
    if (IsKeyLoaded) then
      OpenMacroEditor;
  end
  else
  begin

  end;
end;

function TFormMainRGB.GetLedMode: TLedMode;
var
  i: integer;
begin
  result := lmNone;
  for i := 0 to menuActionList.Count - 1 do
  begin
    if (menuActionList.Items[i] as TMenuAction).IsDown then
    begin
      result := (menuActionList.Items[i] as TMenuAction).LedMode;
    end;
  end;
  //result := lmNone;
  //
  //if (btnIndividual.Down) then
  //  result := lmFreestyle
  //else if (btnMonochrome.Down) then
  //  result := lmMonochrome
  //else if (btnBreathe.Down) then
  //  result := lmBreathe
  //else if (btnRGBSpectrum.Down) then
  //  result := lmSpectrum
  //else if (btnRGBWave.Down) then
  //  result := lmWave
  //else if (btnReactive.Down) then
  //  result := lmReactive
  //else if (btnRipple.Down) then
  //  result := lmRipple
  //else if (btnFireball.Down) then
  //  result := lmFireball
  //else if (btnStarlight.Down) then
  //  result := lmStarlight
  //else if (btnRebound.Down) then
  //  result := lmRebound
  //else if (btnLoop.Down) then
  //  result := lmLoop
  //else if (btnPulse.Down) then
  //  result := lmPulse
  //else if (btnRain.Down) then
  //  result := lmRain
  ////else if (btnPitchBlack.Down) then
  ////  result := lmPitchBlack
  //else if (btnDisableLedOld.Down) then
  //  result := lmDisabled;
end;

procedure TFormMainRGB.ResetBreathe;
begin
  breatheTransparency := 0;
  breatheCycle := 1;
  breatheDirection := 0;
  pulseColor := clNone;
end;

procedure TFormMainRGB.ResetNewGif;
begin
  gifFrameIdx := 0;
end;

procedure TFormMainRGB.ResetWave;
begin
  waveCycle := 0;
end;

procedure TFormMainRGB.ResetSpectrum;
begin
  spectrumCycle := 0;
  spectrumColor := clNone;
end;

procedure TFormMainRGB.SetLedMode(ledMode: TLedMode);
const
  colorEnabled = clWhite;
  colorDisabled = clSilver;
begin
  try
    keyService.ActiveGif := nil;
    loadingLedSettings := true;
    WaveTimer.Enabled := false;
    BreatheTimer.Enabled := false;
    LoadGifTimer.Enabled := false;
    NewGifTimer.Enabled := false;
    keyService.LedMode := ledMode;
    gifViewer.Visible := false;
    ShowHideKeyButtons(false);
    ResetDirection;
    ResetBreathe;
    ResetNewGif;
    ResetWave;
    ResetSpectrum;

    ShowHideParameters(PARAM_COLOR, ledMode, ledMode in [lmFreestyle, lmMonochrome, lmBreathe, lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound, lmLoop, lmRain]);
    ShowHideParameters(PARAM_BASECOLOR, ledMode, ledMode in [lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound, lmLoop, lmRain]);
    ShowHideParameters(PARAM_DIRECTION, ledMode, ledMode in [lmWave, lmRebound, lmLoop]);
    ShowHideParameters(PARAM_SPEED, ledMode, ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain, lmPulse]);
    ShowHideParameters(PARAM_RANGE, ledMode, false);
    ShowHideParameters(PARAM_ZONE, ledMode, ledMode in [lmFreestyle, lmBreathe]);
    btnResetAll.Visible := ledMode in [lmFreestyle, lmBreathe];

    imgKeyboardLighting.Cursor := crDefault;
    if (ledMode = lmFreestyle) then
    begin
      SetCurrentMenuAction(maFreestyle, nil);
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
      SetCurrentMenuAction(maMonochrome, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      ColorChange(keyService.LedColorMono);
      ShowHideKeyButtons(true);
    end
    else if (ledMode in [lmBreathe, lmPulse]) then
    begin
      if (ledMode = lmBreathe) then
        SetCurrentMenuAction(maBreathe, nil)
      else if (ledMode = lmPulse) then
        SetCurrentMenuAction(maPulse, nil);
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
      SetCurrentMenuAction(maSpectrum, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      ShowHideKeyButtons(true);
    end
    else if (ledMode in [lmWave]) then
    begin
      SetCurrentMenuAction(maWave, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      ShowHideKeyButtons(true);
      SetDirection(keyService.LedDirection, keyService.LedMode);
    end
    else if (ledMode  in [lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound, lmLoop, lmRain]) then
    begin
      if (ledMode = lmReactive) then
        SetCurrentMenuAction(maReactive, nil)
      else if (ledMode = lmRipple) then
        SetCurrentMenuAction(maRipple, nil)
      else if (ledMode = lmFireball) then
        SetCurrentMenuAction(maFireball, nil)
      else if (ledMode = lmStarlight) then
        SetCurrentMenuAction(maStarlight, nil)
      else if (ledMode = lmRebound) then
        SetCurrentMenuAction(maRebound, nil)
      else if (ledMode = lmLoop) then
        SetCurrentMenuAction(maLoop, nil)
      else if (ledMode = lmRain) then
        SetCurrentMenuAction(maRain, nil);
      imgKeyboardLighting.SendToBack;
      KeyButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      ShowHideKeyButtons(true);
      if (ledMode = lmReactive) then
      begin
        ColorChange(keyService.LedColorReactive);
        ColorChangeBase(keyService.BaseLedColorReactive);
      end
      else if (ledMode = lmRipple) then
      begin
        ColorChange(keyService.LedColorRipple);
        ColorChangeBase(keyService.BaseLedColorRipple);
      end
      else if (ledMode = lmFireball) then
      begin
        ColorChange(keyService.LedColorFireball);
        ColorChangeBase(keyService.BaseLedColorFireball);
      end
      else if (ledMode = lmStarlight) then
      begin
        ColorChange(keyService.LedColorStarlight);
        ColorChangeBase(keyService.BaseLedColorStarlight);
      end
      else if (ledMode = lmRebound) then
      begin
        ColorChange(keyService.LedColorRebound);
        ColorChangeBase(keyService.BaseLedColorRebound);
      end
      else if (ledMode = lmLoop) then
      begin
        ColorChange(keyService.LedColorLoop);
        ColorChangeBase(keyService.BaseLedColorLoop);
      end
      else if (ledMode = lmRain) then
      begin
        ColorChange(keyService.LedColorRain);
        ColorChangeBase(keyService.BaseLedColorRain);
      end;

      if (ledMode = lmRebound) and
        ((keyService.LedDirection = LED_DIR_DOWN_INT) OR (keyService.LedDirection = LED_DIR_RIGHT_INT)) then
        SetDirection(DEFAULT_LED_DIR_INT, keyService.LedMode)
      else
        SetDirection(keyService.LedDirection, keyService.LedMode);
    end
    //else if (ledMode = lmPitchBlack) then
    //begin
    //  SetCurrentMenuAction(btnPitchBlack, nil);
    //end
    else if (ledMode = lmDisabled) then
    begin
      //LoadButtonImage(btnDisableLed, imgListMiniIcons, 3);
      SetCurrentMenuAction(maDisableLed, nil);
    end;

    ////Reset disabled image
    //if (ledMode <> lmDisabled) then
    //  LoadButtonImage(btnDisableLed, imgListMiniIcons, 2);

    if (GDebugMode) then
    begin
      gifViewer.BringToFront;
    end;

    ReloadKeyButtonsColor;

    //LoadGif(keyService.LedSpeed, keyService.LedDirection);
    if (ledMode in [lmBreathe, lmPulse]) then
      BreatheTimer.Enabled := true
    else if (ledMode in [lmRain, lmReactive, lmRipple, lmFireball, lmLoop, lmRebound, lmStarlight]) then
      NewGifTimer.Enabled := true
    else if (ledMode in [lmWave]) then
      WaveTimer.Enabled := true
    else if (ledMode in [lmSpectrum]) then
      SpectrumTimer.Enabled := true
    else
      LoadGifTimer.Enabled := true;
  finally
    loadingLedSettings := false;
  end;
end;

function TFormMainRGB.RippleFireballEnable: boolean;
begin
  result := (fileService.VersionBiggerEqualKBD(1, 0, 121) and fileService.VersionBiggerEqualLED(1, 0, 58)) or GDemoMode;
end;

procedure TFormMainRGB.SetMenuEnabledFirmware;
var
  aMenuButton: TMenuAction;
begin
  if (not RippleFireballEnable) then
  begin
    aMenuButton := GetMenuActionByImage(imgFireball.Name);
    aMenuButton.IsEnabled := false;

    aMenuButton := GetMenuActionByImage(imgRipple.Name);
    aMenuButton.IsEnabled := false;
  end;
end;

procedure TFormMainRGB.CheckFirmware;
begin
  if (fileService.VersionIsEqualLED(1, 0, 44)) or (fileService.VersionIsEqualLED(1, 0, 58)) then
  begin
    if (not fileService.CheckIfLedFilesHasValue(KEYPAD_KEY_EDGE)) then
    begin
      if fileService.VersionIsEqualLED(1, 0, 44) then
        ShowExpansionDialog(1)
      else if fileService.VersionIsEqualLED(1, 0, 58) then
        ShowExpansionDialog(2);
      LoadLedFile(currentLedFile, nil);
    end;
  end;
end;

procedure TFormMainRGB.LoadGifTimerTimer(Sender: TObject);
begin
  LoadGifTimer.Enabled := false;
  LoadGif(Round(knobSpeed.Position), keyService.LedDirection);
end;

procedure TFormMainRGB.ResetHighlight;
var
  i: integer;
  menuAction: TMenuAction;
begin
  for i := 0 to menuActionList.Count - 1 do
  begin
    menuAction := (menuActionList.Items[i] as TMenuAction);
    if (menuAction.MenuConfig = CONFIG_LAYOUT) and
      (menuAction.IsDown = false) and
      not((menuAction.ActionImage = imgMacro) and EditingMacro) and
      (IsKeyLoaded or not(menuAction.MustSelectKey)) then
      menuAction.ActionLabel.Font.Color := KINESIS_FONT_COLOR_RGB;
  end;
end;


procedure TFormMainRGB.SetLayoutMenuColor;
var
  aColor: TColor;
begin
  if IsKeyLoaded then
  begin
    aColor := KINESIS_FONT_COLOR_RGB;
  end
  else
  begin
    aColor := KINESIS_MED_GRAY_RGB;
  end;
  lblMedia.Font.Color:= aColor;
  lblMouseClicks.Font.Color:= aColor;
  //lblAltLayouts.Font.Color:= aColor;
  lblFunctionKeys.Font.Color:= aColor;
  //lblFullKeypad.Font.Color:= aColor;
  lblFunctionAccess.Font.Color:= aColor;
  lblKeypadActions.Font.Color:= aColor;
  //lblPreHotKeys.Font.Color:= aColor;
  lblTapHold.Font.Color:= aColor;
  lblMultimodifiers.Font.Color := aColor;
  lblSpecialActions.Font.Color := aColor;
  lblDisableKey.Font.Color:= aColor;
  lblLedControl.Font.Color:= aColor;
end;

procedure TFormMainRGB.MenuActionMouseEnter(Sender: TObject);
var
  aImage: TImage;
  aMenuAction: TMenuAction;
begin
  ResetHighlight;
  aImage := (sender as TImage);
  if (aImage <> nil) then
  begin
    aMenuAction := GetMenuActionByImage(aImage.Name);
    if (IsKeyLoaded or not(aMenuAction.MustSelectKey)) and aMenuAction.IsEnabled then
      aMenuAction.ActionLabel.Font.Color := KINESIS_BLUE_EDGE;
  end;
end;

procedure TFormMainRGB.MenuActionMouseLeave(Sender: TObject);
var
  aImage: TImage;
  aMenuAction: TMenuAction;
begin
  aImage := (sender as TImage);
  if (aImage <> nil) then
  begin
    aMenuAction := GetMenuActionByImage(aImage.Name);
    if (not aMenuAction.IsDown) and (IsKeyLoaded or not(aMenuAction.MustSelectKey)) and
      not((aMenuAction.ActionImage = imgMacro) and EditingMacro) then
      aMenuAction.ActionLabel.Font.Color := KINESIS_FONT_COLOR_RGB;
  end;
end;

procedure TFormMainRGB.MenuActionMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//var
//  aImage: TImage;
//  aMenuAction: TMenuAction;
//begin
//  aImage := (sender as TImage);
//  if (aImage <> nil) then
//  begin
//    aMenuAction := GetMenuActionByImage(aImage.Name);
//    aMenuAction.ActionLabel.Font.Color := KINESIS_BLUE_EDGE;
//  end;
end;

procedure TFormMainRGB.lblActionMouseEnter(Sender: TObject);
var
  aLabel: TLabel;
  aMenuAction: TMenuAction;
begin
  ResetHighlight;
  aLabel := (sender as TLabel);
  if (aLabel <> nil) then
  begin
    aMenuAction := GetMenuActionByLabel(aLabel.Name);
    if (IsKeyLoaded or not(aMenuAction.MustSelectKey)) and aMenuAction.IsEnabled then
      aLabel.Font.Color := KINESIS_BLUE_EDGE;
  end;
end;

procedure TFormMainRGB.lblActionMouseLeave(Sender: TObject);
var
  aLabel: TLabel;
  aMenuAction: TMenuAction;
begin
  aLabel := (sender as TLabel);
  if (aLabel <> nil) then
  begin
    aMenuAction := GetMenuActionByLabel(aLabel.Name);
    if (not aMenuAction.IsDown) and (IsKeyLoaded or not(aMenuAction.MustSelectKey)) and
      not((aMenuAction.ActionImage = imgMacro) and EditingMacro) then
      aLabel.Font.Color := KINESIS_FONT_COLOR_RGB;
  end;
end;

procedure TFormMainRGB.lblActionMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//var
//  aLabel: TLabel;
//begin
//  aLabel := (sender as TLabel);
//  if (aLabel <> nil) then
//  begin
//    aLabel.Font.Color := KINESIS_BLUE_EDGE;
//  end;
end;

procedure TFormMainRGB.lblMacroInfoMouseEnter(Sender: TObject);
begin
  lblActionMouseEnter(lblMacro);
end;

procedure TFormMainRGB.lblMacroInfoMouseLeave(Sender: TObject);
begin
  lblActionMouseLeave(lblMacro);
end;

procedure TFormMainRGB.BreatheTimerTimer(Sender: TObject);
const
  delay = 26;
begin
  BreatheTimer.Enabled := false;
  case keyService.LedSpeed of
    1: BreatheTimer.Interval := Trunc((12 * 1000) / delay);
    2: BreatheTimer.Interval := Trunc((10 * 1000) / delay);
    3: BreatheTimer.Interval := Trunc((9 * 1000) / delay);
    4: BreatheTimer.Interval := Trunc((8 * 1000) / delay);
    5: BreatheTimer.Interval := Trunc((7 * 1000) / delay);
    6: BreatheTimer.Interval := Trunc((6 * 1000) / delay);
    7: BreatheTimer.Interval := Trunc((5 * 1000) / delay);
    8: BreatheTimer.Interval := Trunc((4 * 1000) / delay);
    9: BreatheTimer.Interval := Trunc((2 * 1000) / delay);
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
    inc(breatheCycle);
    if (breatheCycle > 12) then
      breatheCycle := 1;
  end;

  case breatheCycle of
    1: pulseColor := RGB(255, 0, 255);
    2: pulseColor := RGB(255, 0, 128);
    3: pulseColor := RGB(255, 0, 0);
    4: pulseColor := RGB(255, 128, 0);
    5: pulseColor := RGB(255, 255, 0);
    6: pulseColor := RGB(128, 255, 0);
    7: pulseColor := RGB(0, 255, 0);
    8: pulseColor := RGB(0, 255, 128);
    9: pulseColor := RGB(0, 255, 255);
    10: pulseColor := RGB(0, 128, 255);
    11: pulseColor := RGB(0, 0, 255);
    12: pulseColor := RGB(128, 0, 255);
  end;

  ReloadKeyButtonsColor;

  BreatheTimer.Enabled := true;
end;

procedure TFormMainRGB.NewGifTimerTimer(Sender: TObject);
const
  delay = 30;
begin
  NewGifTimer.Enabled := false;

  if (keyService.LedMode = lmRain) then
    keyService.ActiveGif := keyService.RainGif
  else if (keyService.LedMode = lmReactive) then
    keyService.ActiveGif := keyService.ReactiveGif
  else if (keyService.LedMode = lmRipple) then
    keyService.ActiveGif := keyService.RippleGif
  else if (keyService.LedMode = lmFireball) then
    keyService.ActiveGif := keyService.FireballGif
  else if (keyService.LedMode = lmStarlight) then
    keyService.ActiveGif := keyService.StarlightGif
  else if (keyService.LedMode = lmLoop) then
  begin
    case keyService.LedDirection of
      LED_DIR_DOWN_INT: keyService.ActiveGif := keyService.LoopDownGif;
      LED_DIR_LEFT_INT: keyService.ActiveGif := keyService.LoopLeftGif;
      LED_DIR_UP_INT: keyService.ActiveGif := keyService.LoopUpGif;
      LED_DIR_RIGHT_INT: keyService.ActiveGif := keyService.LoopRightGif;
    end;
  end
  else if (keyService.LedMode = lmRebound) then
  begin
    case keyService.LedDirection of
      LED_DIR_UP_INT: keyService.ActiveGif := keyService.ReboundVerGif;
      LED_DIR_LEFT_INT: keyService.ActiveGif := keyService.ReboundHorGif;
      else keyService.ActiveGif := keyService.ReboundHorGif
    end;
  end
  else
    keyService.ActiveGif := nil;

  if (keyService.ActiveGif <> nil) then
  begin
    case keyService.LedSpeed of
      1: NewGifTimer.Interval := Trunc((12 * 1000) / delay);
      2: NewGifTimer.Interval := Trunc((10 * 1000) / delay);
      3: NewGifTimer.Interval := Trunc((9 * 1000) / delay);
      4: NewGifTimer.Interval := Trunc((8 * 1000) / delay);
      5: NewGifTimer.Interval := Trunc((7 * 1000) / delay);
      6: NewGifTimer.Interval := Trunc((6 * 1000) / delay);
      7: NewGifTimer.Interval := Trunc((5 * 1000) / delay);
      8: NewGifTimer.Interval := Trunc((4 * 1000) / delay);
      9: NewGifTimer.Interval := Trunc((2 * 1000) / delay);
    end;

    if (gifFrameIdx = (keyService.ActiveGif.Count)) then
      gifFrameIdx := 1
    else
      inc(gifFrameIdx);

    ReloadKeyButtonsColor;

    NewGifTimer.Enabled := true;
  end;
end;

procedure TFormMainRGB.pnlMacroClick(Sender: TObject);
begin

end;

procedure TFormMainRGB.pnlProfileOptionsClick(Sender: TObject);
begin

end;

procedure TFormMainRGB.bCoTriggerClick(Sender: TObject);
var
  button: TColorSpeedButtonCS;
  aKey: TKey;
begin
  if IsKeyLoaded then
  begin
    button := Sender as TColorSpeedButtonCS;
    //if (button.Down) then
    if (button.HelpKeyword <> 'DOWN') then
    begin
      ResetMacroCoTriggers;

      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
      begin
        activeKbKey.ActiveMacro.CoTrigger1 := aKey.CopyKey;
        MacroModified := true;
      end;
      ActivateCoTrigger(button);
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

procedure TFormMainRGB.btnAllZoneClick(Sender: TObject);
begin
  SetZoneColor(ztAll);
end;

procedure TFormMainRGB.btnNumberZoneClick(Sender: TObject);
begin
  SetZoneColor(ztNumber);
end;

procedure TFormMainRGB.imgProfileClick(Sender: TObject);
begin
  if (pnlSelectProfile.Visible) then
  begin
    ResetProfileMenu;
  end
  else
  begin
    profileMode := pmSelect;
    pnlSelectProfile.Left := imgProfile.Left;
    pnlSelectProfile.Width := imgProfile.Width;
    pnlSelectProfile.Top := imgProfile.Top + imgProfile.Height;
    pnlSelectProfile.Visible := true;
    //SetMousePosition(pnlSelectProfile.Left + 50, pnlSelectProfile.Top + 10);
    LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);
  end;
end;

procedure TFormMainRGB.imgProfileMouseLeave(Sender: TObject);
begin
  if (pnlSelectProfile.Visible = false) then
    LoadButtonImage(sender, imgListProfileDefault, currentProfileNumber);
end;

procedure TFormMainRGB.imgProfileMouseEnter(Sender: TObject);
begin
  LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);
end;

procedure TFormMainRGB.lblDisableClick(Sender: TObject);
begin
  chkDisable.Checked := not chkDisable.Checked;
end;

procedure TFormMainRGB.imgProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);
end;

procedure TFormMainRGB.lbProfileMouseLeave(Sender: TObject);
begin
  //if (not MouseInControl(lbProfile)) then
     ResetProfileMenu;
end;

procedure TFormMainRGB.memoMacroKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key := 0;
end;

function TFormMainRGB.MouseInControl(oControl: TControl): boolean;
var
  pt: TPoint;
begin
  result := false;
  pt := ScreenToClient(Mouse.CursorPos);

  result := (pt.x >= oControl.Left) and
     (pt.x <= (oControl.Left + oControl.Width)) and
     (pt.y >= oControl.Top) and
     (pt.y <= (oControl.Top + oControl.Height));
end;

procedure TFormMainRGB.btnExportClick(Sender: TObject);
begin
  ShowExport(currentLayoutFile, currentLedFile, backColor, fontColor);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.SendEmail;
var
  message: TStringList;
  attachments: TStringList;
begin
  try
    Cursor := crHourGlass;
    message := TStringList.Create;
    attachments := TStringList.Create;
    attachments.Add(currentLayoutFile);
    attachments.Add(currentLedFile);
    message.Add('Test email from RGB App');
    message.Add(' (With Attachments)');
    DoSendMailAndAttachments('dhargreaves@kinesis.com', 'FS Edge RBG', message, attachments);
  finally
    Cursor := crDefault;
    FreeAndNil(message);
    FreeAndNil(attachments);
  end;
end;

procedure TFormMainRGB.DoSendMailAndAttachments(const ATo, ASubject: String;
  Content: TStrings; FAttachments: TStringList);
begin
//Var
//  Mime : TMimeMess;
//  P : TMimePart;
//  I : Integer;
//  sent : Boolean;
//begin
//  Mime:=TMimeMess.Create;
//  try
//    // Set some headers
//    Mime.Header.ToList.Text:=ATo;
//    Mime.Header.Subject:=ASubject;
//    Mime.Header.From := 'no-reply@kinesis.com';
//    // Create a MultiPart part
//    P := Mime.AddPartMultipart('mixed',Nil);
//    // Add as first part the mail text
//    Mime.AddPartText(Content, P);
//    // Add all attachments:
//    For I:=0 to FAttachments.Count-1 do
//      Mime.AddPartBinaryFromFile(FAttachments[I],P);
//    // Compose message
//    Mime.EncodeMessage;
//    // Send using SendToRaw
//    if not sent then
//      ShowDialog('Email', 'Could not send the message', mtWarning, [mbOk])
//    else
//      ShowDialog('Email', 'Email sent!', mtInformation, [mbOk])
//  finally
//    Mime.Free;
//  end;
end;

procedure TFormMainRGB.btnWASDZoneClick(Sender: TObject);
begin
  SetZoneColor(ztWASD);
end;

procedure TFormMainRGB.btnFunctionZoneClick(Sender: TObject);
begin
  SetZoneColor(ztFunction);
end;

procedure TFormMainRGB.btnGameZoneClick(Sender: TObject);
begin
  SetZoneColor(ztGame);
end;

procedure TFormMainRGB.btnHelpClick(Sender: TObject);
begin
  NeedInput := true;
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.SetFirmwareVersion(fileService.FirmwareVersionKBD, fileService.FirmwareVersionLED);
  FormAbout.ShowModal;
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
  NeedInput := false;
end;

procedure TFormMainRGB.btnImportClick(Sender: TObject);
var
  errorMsg: string;
  fileContent: TStringList;
  iFileSize: integer;
begin
  if (OpenDialog.Execute) then
  begin
    try
      iFileSize := FileSize(OpenDialog.FileName);
      if (iFileSize / 1024) <= MAX_IMPORT_SIZE then
      begin
        fileContent := TStringList.Create;
        errorMsg := fileService.LoadFile(OpenDialog.FileName, fileContent, false);

        if (errorMsg = '') then
        begin
          if (keyService.IsLedFile(fileContent)) then
          begin
            LoadLedFile(OpenDialog.FileName, fileContent);
            SetSaveState(SaveStateLayout, ssModified);
            if (ConfigMode <> CONFIG_LIGHTING) then
              SetConfigMode(CONFIG_LIGHTING);
          end
          else if (keyService.IsLayoutFile(fileContent)) then
          begin
            LoadKeyboardLayout(OpenDialog.FileName, fileContent);
            SetSaveState(ssModified, SaveStateLighting);
            if (ConfigMode <> CONFIG_LAYOUT) then
              SetConfigMode(CONFIG_LAYOUT);
          end
          else
            ShowDialog('Import File', 'File not recognized', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
        end
        else
        begin
          ShowDialog('Import File', errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
        end;
      end
      else
        ShowDialog('Import File', 'File size must not exceed ' + IntToStr(MAX_IMPORT_SIZE) + ' KB', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
    finally
      if (fileContent <> nil) then
        FreeAndNil(fileContent);
    end;
  end;
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnLeftModuleClick(Sender: TObject);
begin
  SetZoneColor(ztLeftModule);
end;

procedure TFormMainRGB.btnRightModuleClick(Sender: TObject);
begin
  SetZoneColor(ztRightModule);
end;

procedure TFormMainRGB.btnArrowZoneClick(Sender: TObject);
begin
  SetZoneColor(ztArrow);
end;

procedure TFormMainRGB.SetZoneColor(zoneType: TZoneType);
var
  i: integer;
  aKbKey: TKBKey;
  keyColor: TColor;
begin
  if (keyService.LedMode in [lmFreestyle, lmBreathe]) then
  begin
    keyColor := ringPicker.SelectedColor;
    case zoneType of
      ztAll: begin
        for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
        begin
          aKbKey := keyService.ActiveLayer.KBKeyList[i];
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
      ztLeftModule: begin
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
        SetSingleKeyColor(lbRow3_1, keyColor);
        SetSingleKeyColor(lbRow3_2, keyColor);
        SetSingleKeyColor(lbRow3_3, keyColor);
        SetSingleKeyColor(lbRow3_4, keyColor);
        SetSingleKeyColor(lbRow3_5, keyColor);
        SetSingleKeyColor(lbRow3_6, keyColor);
        SetSingleKeyColor(lbRow4_1, keyColor);
        SetSingleKeyColor(lbRow4_2, keyColor);
        SetSingleKeyColor(lbRow4_3, keyColor);
        SetSingleKeyColor(lbRow4_4, keyColor);
        SetSingleKeyColor(lbRow4_5, keyColor);
        SetSingleKeyColor(lbRow4_6, keyColor);
        SetSingleKeyColor(lbRow4_7, keyColor);
        SetSingleKeyColor(lbRow4_8, keyColor);
        SetSingleKeyColor(lbRow5_1, keyColor);
        SetSingleKeyColor(lbRow5_2, keyColor);
        SetSingleKeyColor(lbRow5_3, keyColor);
        SetSingleKeyColor(lbRow5_4, keyColor);
        SetSingleKeyColor(lbRow5_5, keyColor);
        SetSingleKeyColor(lbRow5_6, keyColor);
        SetSingleKeyColor(lbRow6_1, keyColor);
        SetSingleKeyColor(lbRow6_2, keyColor);
        SetSingleKeyColor(lbRow6_3, keyColor);
        SetSingleKeyColor(lbRow6_4, keyColor);
        SetSingleKeyColor(lbRow6_5, keyColor);
        SetSingleKeyColor(lbRow6_6, keyColor);
        SetSingleKeyColor(lbRow6_7, keyColor);
        SetSingleKeyColor(lbRow6_8, keyColor);
        SetSingleKeyColor(lbRow6_9, keyColor);
        SetSingleKeyColor(lbRow6_10, keyColor);
        SetSingleKeyColor(lbRow6_11, keyColor);
        SetSingleKeyColor(lbRow7_1, keyColor);
        SetSingleKeyColor(lbRow7_2, keyColor);
        SetSingleKeyColor(lbRow7_3, keyColor);
        SetSingleKeyColor(lbRow7_4, keyColor);
        SetSingleKeyColor(lbRow7_5, keyColor);
      end;
      ztRightModule: begin
        SetSingleKeyColor(lbRow8_1, keyColor);
        SetSingleKeyColor(lbRow8_2, keyColor);
        SetSingleKeyColor(lbRow8_3, keyColor);
        SetSingleKeyColor(lbRow8_4, keyColor);
        SetSingleKeyColor(lbRow8_5, keyColor);
        SetSingleKeyColor(lbRow8_6, keyColor);
        SetSingleKeyColor(lbRow8_7, keyColor);
        SetSingleKeyColor(lbRow9_1, keyColor);
        SetSingleKeyColor(lbRow9_2, keyColor);
        SetSingleKeyColor(lbRow9_3, keyColor);
        SetSingleKeyColor(lbRow9_4, keyColor);
        SetSingleKeyColor(lbRow9_5, keyColor);
        SetSingleKeyColor(lbRow9_6, keyColor);
        SetSingleKeyColor(lbRow9_7, keyColor);
        SetSingleKeyColor(lbRow9_8, keyColor);
        SetSingleKeyColor(lbRow9_9, keyColor);
        SetSingleKeyColor(lbRow9_10, keyColor);
        SetSingleKeyColor(lbRow10_1, keyColor);
        SetSingleKeyColor(lbRow10_2, keyColor);
        SetSingleKeyColor(lbRow10_3, keyColor);
        SetSingleKeyColor(lbRow10_4, keyColor);
        SetSingleKeyColor(lbRow10_5, keyColor);
        SetSingleKeyColor(lbRow10_6, keyColor);
        SetSingleKeyColor(lbRow11_1, keyColor);
        SetSingleKeyColor(lbRow11_2, keyColor);
        SetSingleKeyColor(lbRow11_3, keyColor);
        SetSingleKeyColor(lbRow11_4, keyColor);
        SetSingleKeyColor(lbRow11_5, keyColor);
        SetSingleKeyColor(lbRow11_6, keyColor);
        SetSingleKeyColor(lbRow11_7, keyColor);
        SetSingleKeyColor(lbRow12_1, keyColor);
        SetSingleKeyColor(lbRow12_2, keyColor);
        SetSingleKeyColor(lbRow12_3, keyColor);
        SetSingleKeyColor(lbRow12_4, keyColor);
        SetSingleKeyColor(lbRow12_5, keyColor);
        SetSingleKeyColor(lbRow12_6, keyColor);
        SetSingleKeyColor(lbRow13_1, keyColor);
        SetSingleKeyColor(lbRow13_2, keyColor);
        SetSingleKeyColor(lbRow13_3, keyColor);
        SetSingleKeyColor(lbRow13_4, keyColor);
        SetSingleKeyColor(lbRow13_5, keyColor);
        SetSingleKeyColor(lbRow13_6, keyColor);
        SetSingleKeyColor(lbRow14_1, keyColor);
        SetSingleKeyColor(lbRow14_2, keyColor);
        SetSingleKeyColor(lbRow14_3, keyColor);
        SetSingleKeyColor(lbRow14_4, keyColor);
        SetSingleKeyColor(lbRow14_5, keyColor);
        SetSingleKeyColor(lbRow14_6, keyColor);
      end;
    end;
    SetSaveState(SaveStateLayout, ssModified);
  end;
end;

procedure TFormMainRGB.LoadGif(speed: integer; direction: integer);
var
  gifToLoad: string;
begin
  if (keyService.LedMode = lmBreathe) then
  begin
    //gifToLoad := imagePath + 'Breathe_Spd' + IntToStr(speed) + '.gif';
    //gifToLoad := 'BREATHE-SPD' +  IntToStr(speed);
  end
  else if (keyService.LedMode = lmWave) then
  begin
    //gifToLoad := imagePath + 'Wave_Spd' + IntToStr(speed) + '.gif';
  //  WaveTimer.Enabled := true;
    //gifToLoad := 'WAVE';
    //case direction of
    //  LED_DIR_DOWN_INT: gifToLoad := gifToLoad + 'DOWN-';
    //  LED_DIR_LEFT_INT: gifToLoad := gifToLoad + 'LEFT-';
    //  LED_DIR_UP_INT: gifToLoad := gifToLoad + 'UP-';
    //  LED_DIR_RIGHT_INT: gifToLoad := gifToLoad + 'RIGHT-';
    //end;
    //gifToLoad := gifToLoad + 'SPD' + IntToStr(speed);
  end
  else if (keyService.LedMode = lmLoop) then
  begin
    //gifToLoad := 'LOOP';
    //case direction of
    //  LED_DIR_DOWN_INT: gifToLoad := gifToLoad + '-DOWN-';
    //  LED_DIR_LEFT_INT: gifToLoad := gifToLoad + '-LEFT-';
    //  LED_DIR_UP_INT: gifToLoad := gifToLoad + '-UP-';
    //  LED_DIR_RIGHT_INT: gifToLoad := gifToLoad + '-RIGHT-';
    //end;
    //gifToLoad := gifToLoad + 'SPD' + IntToStr(speed);
  end
  else if (keyService.LedMode = lmSpectrum) then
  begin
    //gifToLoad := 'SPECTRUM-SPD' +  IntToStr(speed);
    //gifToLoad := imagePath + 'Spectrum-Spd' + IntToStr(speed) + '.gif';
  end
  //else if (keyService.LedMode = lmReactive) then
  //begin
  //  gifToLoad := 'REACTIVE-SPD' +  IntToStr(speed);
  //  //gifToLoad := imagePath + 'Reactive_Spd' + IntToStr(speed) + '.gif';
  //end
  else if (keyService.LedMode = lmStarlight) then
  begin
    //gifToLoad := 'STARLIGHT-SPD' +  IntToStr(speed);
  end
  else if (keyService.LedMode = lmRebound) then
  begin
    //gifToLoad := 'REBOUND-SPD' +  IntToStr(speed);
    //gifToLoad := 'REBOUND';
    //case direction of
    //  LED_DIR_UP_INT: gifToLoad := gifToLoad + 'VER-';
    //  LED_DIR_LEFT_INT: gifToLoad := gifToLoad + 'HOR-';
    //  else gifToLoad := gifToLoad + 'HOR-';
    //end;
    //gifToLoad := gifToLoad + 'SPD' + IntToStr(speed);
  end
  else if (keyService.LedMode = lmRipple) then
  begin
    //gifToLoad := 'RIPPLE-SPD' +  IntToStr(speed);
  end;
  //else if (keyService.LedMode = lmRain) then
  //begin
  //  gifToLoad := 'RAIN-SPD' +  IntToStr(speed);
  //end;

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
procedure TFormMainRGB.WaveTimerTimer(Sender: TObject);
const
  MaxCycle = 19;
begin
  WaveTimer.Enabled := false;
  inc(waveCycle);

  if (keyService.LedDirection in [LED_DIR_LEFT_INT, LED_DIR_RIGHT_INT]) then
  begin
    case keyService.LedSpeed of
      1: WaveTimer.Interval := 1000;
      2: WaveTimer.Interval := 800;
      3: WaveTimer.Interval := 700;
      4: WaveTimer.Interval := 600;
      5: WaveTimer.Interval := 500;
      6: WaveTimer.Interval := 400;
      7: WaveTimer.Interval := 300;
      8: WaveTimer.Interval := 200;
      9: WaveTimer.Interval := 100;
    end;
  end
  else
  begin
    case keyService.LedSpeed of
      1: WaveTimer.Interval := 450;
      2: WaveTimer.Interval := 400;
      3: WaveTimer.Interval := 350;
      4: WaveTimer.Interval := 300;
      5: WaveTimer.Interval := 250;
      6: WaveTimer.Interval := 200;
      7: WaveTimer.Interval := 150;
      8: WaveTimer.Interval := 100;
      9: WaveTimer.Interval := 50;
    end;
  end;

  if (keyService.LedDirection = LED_DIR_LEFT_INT) then
  begin
    SetColorWave(kbArrayCol1, waveCycle);
    SetColorWave(kbArrayCol2, (waveCycle + 1) Mod MaxCycle);
    SetColorWave(kbArrayCol3, (waveCycle + 2) Mod MaxCycle);
    SetColorWave(kbArrayCol4, (waveCycle + 3) Mod MaxCycle);
    SetColorWave(kbArrayCol5, (waveCycle + 4) Mod MaxCycle);
    SetColorWave(kbArrayCol6, (waveCycle + 5) Mod MaxCycle);
    SetColorWave(kbArrayCol7, (waveCycle + 6) Mod MaxCycle);
    SetColorWave(kbArrayCol8, (waveCycle + 7) Mod MaxCycle);
    SetColorWave(kbArrayCol9, (waveCycle + 8) Mod MaxCycle);
    SetColorWave(kbArrayCol10, (waveCycle + 9) Mod MaxCycle);
    SetColorWave(kbArrayCol11, (waveCycle + 10) Mod MaxCycle);
    SetColorWave(kbArrayCol12, (waveCycle + 11) Mod MaxCycle);
    SetColorWave(kbArrayCol13, (waveCycle + 12) Mod MaxCycle);
    SetColorWave(kbArrayCol14, (waveCycle + 13) Mod MaxCycle);
    SetColorWave(kbArrayCol15, (waveCycle + 14) Mod MaxCycle);
    SetColorWave(kbArrayCol16, (waveCycle + 15) Mod MaxCycle);
    SetColorWave(kbArrayCol17, (waveCycle + 16) Mod MaxCycle);
    SetColorWave(kbArrayCol18, (waveCycle + 17) Mod MaxCycle);
  end
  else if (keyService.LedDirection = LED_DIR_RIGHT_INT) then
  begin
    SetColorWave(kbArrayCol18, waveCycle, true);
    SetColorWave(kbArrayCol17, (waveCycle + 1) Mod MaxCycle, true);
    SetColorWave(kbArrayCol16, (waveCycle + 2) Mod MaxCycle, true);
    SetColorWave(kbArrayCol15, (waveCycle + 3) Mod MaxCycle, true);
    SetColorWave(kbArrayCol14, (waveCycle + 4) Mod MaxCycle, true);
    SetColorWave(kbArrayCol13, (waveCycle + 5) Mod MaxCycle, true);
    SetColorWave(kbArrayCol12, (waveCycle + 6) Mod MaxCycle, true);
    SetColorWave(kbArrayCol11, (waveCycle + 7) Mod MaxCycle, true);
    SetColorWave(kbArrayCol10, (waveCycle + 8) Mod MaxCycle, true);
    SetColorWave(kbArrayCol9, (waveCycle + 9) Mod MaxCycle, true);
    SetColorWave(kbArrayCol8, (waveCycle + 10) Mod MaxCycle, true);
    SetColorWave(kbArrayCol7, (waveCycle + 11) Mod MaxCycle, true);
    SetColorWave(kbArrayCol6, (waveCycle + 12) Mod MaxCycle, true);
    SetColorWave(kbArrayCol5, (waveCycle + 13) Mod MaxCycle, true);
    SetColorWave(kbArrayCol4, (waveCycle + 14) Mod MaxCycle, true);
    SetColorWave(kbArrayCol3, (waveCycle + 15) Mod MaxCycle, true);
    SetColorWave(kbArrayCol2, (waveCycle + 16) Mod MaxCycle, true);
    SetColorWave(kbArrayCol1, (waveCycle + 17) Mod MaxCycle, true);
  end
  else if (keyService.LedDirection = LED_DIR_DOWN_INT) then
  begin
    SetColorWave(kbArrayRow6, waveCycle, true);
    SetColorWave(kbArrayRow5, (waveCycle + 1) Mod MaxCycle, true);
    SetColorWave(kbArrayRow4, (waveCycle + 2) Mod MaxCycle, true);
    SetColorWave(kbArrayRow3, (waveCycle + 3) Mod MaxCycle, true);
    SetColorWave(kbArrayRow2, (waveCycle + 4) Mod MaxCycle, true);
    SetColorWave(kbArrayRow1, (waveCycle + 5) Mod MaxCycle, true);
  end
  else if (keyService.LedDirection = LED_DIR_UP_INT) then
  begin
    SetColorWave(kbArrayRow1, waveCycle);
    SetColorWave(kbArrayRow2, (waveCycle + 1) Mod MaxCycle);
    SetColorWave(kbArrayRow3, (waveCycle + 2) Mod MaxCycle);
    SetColorWave(kbArrayRow4, (waveCycle + 3) Mod MaxCycle);
    SetColorWave(kbArrayRow5, (waveCycle + 4) Mod MaxCycle);
    SetColorWave(kbArrayRow6, (waveCycle + 5) Mod MaxCycle);
  end;

  RepaintForm(false);

  if (waveCycle = MaxCycle) then
    waveCycle := 0;

  WaveTimer.Enabled := true;
end;

procedure TFormMainRGB.SetColorRow(arrayButton: array of TLabelBox; colorIdx: integer);
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

procedure TFormMainRGB.SetColorWave(arrayButton: array of TLabelBox; colorIdx: integer;
  invertColors: boolean = false; gradient: boolean = false);
var
  i: integer;
  pass: integer;
  keyColor: TColor;
  baseColor: TColor;
begin
  for pass := 1 to 2 do
  begin
    if (invertColors) then
    begin
      if (pass = 2) then
      begin
       colorIdx := colorIdx - 1;
       if (colorIdx < 0) then
         colorIdx := 19;
      end;
      case colorIdx of
        19: keyColor := RGB(0, 255, 255); //Turquoise
        18: keyColor := RGB(0, 200, 255); //Powder blue
        17: keyColor := RGB(0, 128, 255); //Paler blue
        16: keyColor := RGB(0, 70, 255); //Pale blue
        15: keyColor := RGB(0, 0, 255); //Blue
        14: keyColor := RGB(75, 0, 255); //Bluish
        13: keyColor := RGB(128, 0, 255); //Purple-blue
        12: keyColor := RGB(200, 0, 255); //Purple
        11: keyColor := RGB(255, 0, 144); //Pink
        10: keyColor := RGB(255, 0, 128); //Red-Purple
        9: keyColor := RGB(255, 0, 0); //Red
        8: keyColor := RGB(255, 75, 0); //Orange-Red
        7: keyColor := RGB(255, 128, 0); //Orange
        6: keyColor := RGB(255, 200, 0); //Yellow-orange
        5: keyColor := RGB(255, 255, 0); //Yellow
        4: keyColor := RGB(210, 255, 0); //Yellow-green
        3: keyColor := RGB(128, 255, 0); //Pale Green
        2: keyColor := RGB(0, 255, 0); //Green
        1: keyColor := RGB(0, 255, 128); //Greenish
        0: keyColor := RGB(0, 255, 200); //Teal
      end;
    end
    else
    begin
      if (pass = 2) then
      begin
       colorIdx := colorIdx + 1;
       if (colorIdx > 19) then
         colorIdx := 0;
      end;
      case colorIdx of
        0: keyColor := RGB(0, 255, 255); //Turquoise
        1: keyColor := RGB(0, 200, 255); //Powder blue
        2: keyColor := RGB(0, 128, 255); //Paler blue
        3: keyColor := RGB(0, 70, 255); //Pale blue
        4: keyColor := RGB(0, 0, 255); //Blue
        5: keyColor := RGB(75, 0, 255); //Bluish
        6: keyColor := RGB(128, 0, 255); //Purple-blue
        7: keyColor := RGB(200, 0, 255); //Purple
        8: keyColor := RGB(255, 0, 144); //Pink
        9: keyColor := RGB(255, 0, 128); //Red-Purple
        10: keyColor := RGB(255, 0, 0); //Red
        11: keyColor := RGB(255, 75, 0); //Orange-Red
        12: keyColor := RGB(255, 128, 0); //Orange
        13: keyColor := RGB(255, 200, 0); //Yellow-orange
        14: keyColor := RGB(255, 255, 0); //Yellow
        15: keyColor := RGB(210, 255, 0); //Yellow-green
        16: keyColor := RGB(128, 255, 0); //Pale Green
        17: keyColor := RGB(0, 255, 0); //Green
        18: keyColor := RGB(0, 255, 128); //Greenish
        19: keyColor := RGB(0, 255, 200); //Teal
      end;
    end;
    if (pass = 1) then
      baseColor := keyColor;
  end;

  if Length(arrayButton) > 0 then
  begin
    for i := 0 to Length(arrayButton) - 1 do
    begin
      arrayButton[i].GradientFill := gradient;
      arrayButton[i].Opaque := true;
      arrayButton[i].BackColor := baseColor;
      if (gradient) then
        arrayButton[i].NextColor := keyColor;
      //arrayButton[i].Repaint;
    end;
  end;
end;

procedure TFormMainRGB.OpenColorDialog;
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

procedure TFormMainRGB.continueClick(Sender: TObject);
begin
  CloseDialog(mrOk);
end;

procedure TFormMainRGB.KeyButtonClick(Sender: TObject);
begin
  SetActiveKeyButton(sender as TLabelBox);
end;

procedure TFormMainRGB.KeyButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFormMainRGB.SetActiveKeyButton(keyButton: TLabelBox);
begin
  if CheckSaveKey(true, false) then
  begin
    MacroModified := false;
    KeyModified := false;

    if IsKeyLoaded then
    begin
      UpdateKeyButtonKey(activeKbKey, activeKeyBtn, true);
    end;

    if (keyButton = activeKeyBtn) or (keyButton = nil) or (ConfigMode = CONFIG_LIGHTING) then
    begin
      activeKeyBtn := nil;
      activeKbKey := nil;
    end
    else
    begin
      activeKbKey := keyService.GetKbKeyByIndex(keyService.ActiveLayer, keyButton.Index);
      if (activeKbKey <> nil) and (activeKbKey.CanEdit) then
      begin
        activeKeyBtn := keyButton;
        keyService.BackupKbKey(activeKbKey);
      end
      else if (activeKbKey <> nil) then
      begin
        activeKbKey := nil;
        ShowDialog('Select key', 'You cannot edit this key', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      end;
    end;

    if not IsKeyLoaded then
    begin
      ResetPopupMenu;
      ResetPopupMenuMacro;
      ResetSingleKey;
      textMacroInput.Visible := false;
      pnlAssignMacro.Font.Color := KINESIS_BLUE_EDGE;
      pnlAssignMacro.Caption := 'Select a key above';
    end
    else
    begin
      pnlAssignMacro.Font.Color := KINESIS_FONT_COLOR_RGB;
      pnlAssignMacro.Caption := '';
    end;
    memoMacro.Enabled := IsKeyLoaded and not(activeKbKey.TapAndHold);
    btnDone.Enabled := IsKeyLoaded;
    btnCancel.Enabled := IsKeyLoaded;
    btnResetKey.Enabled := IsKeyLoaded;

    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
    SetLayoutMenuColor;

    if (EditingMacro) then
      OpenMacroEditor;

    ////If popup menu is open, force click
    //if (pnlMenu.Visible) and (lbMenu.ItemIndex >=0) and IsKeyLoaded then
    //begin
    //  lbMenuClick(lbMenu);
    //end
    //else
    //if (btnDisableKey.Down) or (btnLEDControl.Down) and IsKeyLoaded then
    //begin
    //  if (btnDisableKey.Down) then
    //    aMenuAction := GetMenuActionByButton(btnDisableKey.Name)
    //  else
    //    aMenuAction := GetMenuActionByButton(btnLEDControl.Name);
    //  SetSingleKey(aMenuAction, false);
    //end;
  end;
end;

function TFormMainRGB.EditingMacro(showWarning: boolean = false): boolean;
begin
  result := pnlMacro.Visible;
  if (result and showWarning) then
    ShowDialog('Macro', 'Please close Macro Editor before proceeding', mtWarning, [mbOk]);
end;

function TFormMainRGB.IsKeyLoaded: boolean;
begin
  result := (activeKeyBtn <> nil) and (activeKbKey <> nil);
end;

procedure TFormMainRGB.SetKeyButtonText(keybutton: TLabelBox; btnText: string);
begin
  keyButton.Caption := btnText;
end;

function TFormMainRGB.ValidateBeforeDone: boolean;
var
  errorMsg: string;
  errorTitle: string;
  customBtns: TCustomButtons;
  isValid: boolean;
begin
  isValid := keyService.ValidateMacros(activeKbKey, errorMsg, errorTitle);

  if isValid then
  begin
    RefreshRemapInfo;

    if (MacroModified) then
    begin
      if (macroCount > maxMacros) then
      begin
        //Allow clicking done but not saving
        //isValid := false;
        createCustomButton(customBtns, 'OK', 150, nil, bkOK);
        ShowDialog('Macro Capacity Reached', 'Only ' + IntToStr(maxMacros) + ' macros can be saved to a layout.',
          mtWarning, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
      end
      else
      begin
        if (totalKeystrokes > maxKeystrokes) then
        begin
          isValid := false;
          ShowDialog('Macro Limit Reached', 'You have reached the macro limit for Profile ' + IntToStr(currentProfileNumber) + '. To proceed, please delete an unused macro from this layout or create a new layout.',
            mtError, [mbOk], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
        end;
      end;
    end;
  end
  else
  begin
    ShowDialog(errorTitle, errorMsg, mtError, [mbOk], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
  end;

  result := isValid;
  //if isValid then
  //begin
  //  RefreshRemapInfo;
  //  if macroCount > MAX_MACRO_FS then
  //  begin
  //    isValid := false;
  //    errorMsg := 'Only ' + IntToStr(MAX_MACRO_FS) + ' macros can be saved to a layout. To proceed, erase a macro or create a new layout.';
  //    errorTitle := 'Macro Capacity Reached';
  //  end;
  //end;
  //
  //if not isValid then
  //  ShowDialog(errorTitle, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  //
  //result := isValid;
end;

function TFormMainRGB.AcceptMacro: boolean;
begin
  result := true;
  KeyModified := false;
  MacroModified := false;
  SetWindowsCombo(false);
  if (IsKeyLoaded) then
  begin
    if ValidateBeforeDone then
    begin
      SetSaveState(ssModified, SaveStateLighting);
      activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0);
      UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
      SetActiveKeyButton(nil);
    end
    else
      result := false;
  end;
  RefreshRemapInfo;
  SetHovered(btnDoneMacro, false, true);
end;

procedure TFormMainRGB.CancelMacro;
begin
  KeyModified := false;
  MacroModified := false;
  SetWindowsCombo(false);
  if (IsKeyLoaded) then
  begin
    keyService.RestoreMacroKey(activeKbKey); //Returns to previous values
    activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0) ;
    UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
    SetActiveKeyButton(nil);
  end;
  RefreshRemapInfo;
  SetHovered(btnCancelMacro, false, true);
end;

procedure TFormMainRGB.SetActiveLayer(layerIdx: integer);
begin
  keyService.ActiveLayer := keyService.GetLayer(layerIdx);
  LoadLayer(keyService.ActiveLayer);
end;

procedure TFormMainRGB.UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox;
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
      keyButton.BorderWidth := 1;
      keyButton.BorderStyle := bsNone;
      keyButton.CornerSize := 10;
      keyButton.Font.Color := clWhite;

      if (kbKey.TapAndHold) then
      begin
        keyButton.Caption := kbKey.TapAction.OtherDisplayText + #10 + kbKey.HoldAction.OtherDisplayText;
        keyButton.Font.Color := activeColor;
      end
      else if (kbKey.IsModified) then
      begin
        keyButton.Caption := kbKey.ModifiedKey.DisplayText;
        fontSize := kbKey.ModifiedKey.DisplaySize;
        fontName := kbKey.ModifiedKey.FontName;
        keyButton.Font.Color := activeColor;
      end
      else
      begin
        keyButton.Caption := kbKey.OriginalKey.DisplayText;
        fontSize := kbKey.OriginalKey.DisplaySize;
        fontName := kbKey.OriginalKey.FontName;
      end;

      if (kbKey.IsMacro) then
      begin
        keyButton.BorderColor := activeColor;
        keyButton.BorderStyle := bsSingle;
        if (kbKey.MacroCount > 1) then
        begin
          keyButton.BorderWidth := 3;
          keyButton.CornerSize := 16;
        end;
      end;
//
//      if (kbKey.IsModified) and (not kbKey.IsMacro) then
//      begin
//        keyButton.Caption := kbKey.ModifiedKey.DisplayText;
//        fontSize := kbKey.ModifiedKey.DisplaySize;
//        fontName := kbKey.ModifiedKey.FontName;
//        keyButton.BorderStyle := bsNone;
//        keyButton.Font.Color := activeColor;
//        keyButton.BorderWidth := 1;
//        keyButton.CornerSize := 10;
//      end
//      else if (not kbKey.IsModified) and (kbKey.IsMacro) then
//      begin
//        keyButton.Caption := kbKey.OriginalKey.DisplayText;
//        fontSize := kbKey.OriginalKey.DisplaySize;
//        fontName := kbKey.OriginalKey.FontName;
//        keyButton.BorderColor := activeColor;
//        keyButton.BorderStyle := bsSingle;
//        keyButton.Font.Color := clWhite;
//        if (kbKey.MacroCount > 1) then
//        begin
//          keyButton.BorderWidth := 3;
//          keyButton.CornerSize := 16;
//        end
//        else
//        begin
//          keyButton.BorderWidth := 1;
//          keyButton.CornerSize := 10;
//        end;
//      end
//      else if (kbKey.IsModified) and (kbKey.IsMacro) then
//      begin
//        keyButton.Caption := kbKey.ModifiedKey.DisplayText;
//        fontSize := kbKey.ModifiedKey.DisplaySize;
//        fontName := kbKey.ModifiedKey.FontName;
//        keyButton.BorderColor := activeColor;
//        keyButton.BorderStyle := bsSingle;
//        keyButton.BorderWidth := 1;
//        keyButton.CornerSize := 10;
//        keyButton.Font.Color := activeColor;
//        if (kbKey.MacroCount > 1) then
//        begin
//          keyButton.BorderWidth := 3;
//          keyButton.CornerSize := 16;
//        end
//        else
//        begin
//          keyButton.BorderWidth := 1;
//          keyButton.CornerSize := 10;
//        end;
//      end
//      else
//      begin
//        keyButton.Caption := kbKey.OriginalKey.DisplayText;
//        fontSize := kbKey.OriginalKey.DisplaySize;
//        fontName := kbKey.OriginalKey.FontName;
//        keyButton.BorderStyle := bsNone;
//        keyButton.Font.Color := clWhite;
//        keyButton.BorderWidth := 1;
//        keyButton.CornerSize := 10;
//      end;
//    end;
    //else if (ConfigMode = CONFIG_LIGHTING) then
    //begin
    //  keyButton.Caption := ''; //kbKey.OriginalKey.DisplayText;
    //  if (keyService.LedMode in [lmFreestyle, lmBreathe]) then
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

    keyButton.Font.Bold := (keyButton.Font.Name <> UNICODE_FONT);

    if not(fullLoad) then
      keyButton.Invalidate; //Repaint;
  end;
end;

function TFormMainRGB.GetKeyOtherLayer(keyIdx: integer): TKBKey;
var
  i: integer;
begin
  result := nil;
  if (keyService.ActiveLayer <> nil) then
  begin
    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      if (keyService.KBLayers[i].LayerIndex <> keyService.ActiveLayer.LayerIndex) then
      begin
        result := keyService.GetKbKeyByIndex(keyService.KBLayers[i], keyIdx);
        break;
      end;
    end;
  end;
end;

function TFormMainRGB.GetKeyButtonByIndex(index: integer): TLabelBox;
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

function TFormMainRGB.GetKeyButtonUnderMouse(x: integer; y:integer): TLabelBox;
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

procedure TFormMainRGB.TopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MPos.X := X;
  MPos.Y := Y;
end;

procedure TFormMainRGB.TopMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (not fromMasterApp) then
  begin
    if ssLeft in Shift then
    begin
      self.Left := self.Left - (MPos.X-X);
      self.Top := self.Top - (MPos.Y-Y);
    end;
  end;
end;

procedure TFormMainRGB.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMainRGB.btnCloseMacroClick(Sender: TObject);
begin
  CloseMacroEditor;
end;

procedure TFormMainRGB.CloseMacroEditor;
begin
  imgMacro.Picture.Clear;
  pnlMacro.Visible := false;
  lblMacro.Font.Color := KINESIS_FONT_COLOR_RGB;
end;

procedure TFormMainRGB.btnMouseClicksMacroClick(Sender: TObject);
var
  aButton: TColorSpeedButtonCS;
begin
  aButton := (sender as TColorSpeedButtonCS);
  if pnlMenuMacro.Visible and (activeMacroMenu = aButton.Name) then
    ResetPopupMenuMacro
  else
  begin
    SetMacroMenuItems(aButton);
    aButton.Down := false;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnCommonShortcutsClick(Sender: TObject);
var
  aButton: TColorSpeedButtonCS;
begin
  aButton := (sender as TColorSpeedButtonCS);
  if pnlMenuMacro.Visible and (activeMacroMenu = aButton.Name) then
    ResetPopupMenuMacro
  else
  begin
    SetMacroMenuItems(aButton);
    aButton.Down := false;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnDiagnosticClick(Sender: TObject);
begin
  ShowDiagnostics(backColor, fontColor);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
//var
//  fileContent: TStringList;
//  errorMsg: string;
//begin
//  try
//    Cursor := crHourGlass;
//    fileContent := fileService.GetDiagnosticInfo;
//
//    fileService.SaveFile(GetDesktopDirectory + '\diagnostic.txt', fileContent, true, errorMsg);
//
//    SetHovered(sender, false, true);
//  finally
//    Cursor := crDefault;
//
//    if (fileContent <> nil) then
//      FreeAndNil(fileContent);
//  end;
end;

procedure TFormMainRGB.btnDoneClick(Sender: TObject);
begin
  DoneKey;
  SetHovered(sender, false, true);
end;

function TFormMainRGB.DoneKey: boolean;
begin
  result := false;
  if IsKeyLoaded then
  begin
    if ValidateBeforeDone then
    begin
      result := true;
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

procedure TFormMainRGB.btnDoneMacroClick(Sender: TObject);
begin
  AcceptMacro;
end;

procedure TFormMainRGB.btnEjectClick(Sender: TObject);
begin
  EjectDevice(GActiveDevice);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnFirmwareClick(Sender: TObject);
begin
  ShowFirmware(GActiveDevice, backColor, fontColor, activeColor);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnCancelMacroClick(Sender: TObject);
begin
  CancelMacro;
end;

procedure TFormMainRGB.btnCancelClick(Sender: TObject);
begin
  if IsKeyLoaded then
  begin
    KeyModified := false;
    MacroModified := false;
    keyService.RestoreMacroKey(activeKbKey); //Returns to previous values for Macro
    keyService.RestoreKbKey(activeKbKey); //Returns to previous values for Key
    SetActiveKeyButton(nil);
    RefreshRemapInfo;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnResetAllClick(Sender: TObject);
var
  sMessage: string;
begin
  if (ConfigMode = CONFIG_LAYOUT) then
  begin
    if ShowDialog('Reset layout',
          'Do you want to reset the current Layout?' + #10 + 'All remapped keys and stored macros in both layers will be lost.',
          mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      CancelMacro;
      keyService.ResetLayout;
      LoadLayer(keyService.ActiveLayer);
      SetActiveKeyButton(nil);
      RefreshRemapInfo;
      SetSaveState(ssModified, SaveStateLighting);
    end;
  end
  else if (ConfigMode = CONFIG_LIGHTING) and (keyService.LedMode in [lmFreestyle, lmBreathe]) then
  begin
    sMessage := 'Do you want to reset the current Lighting profile?' + #10 + 'All assigned colors will be lost.';
    if (keyService.LedMode = lmFreestyle) then
      sMessage := 'Do you want to erase color assignments for each key';
    if ShowDialog('Reset Lighting', sMessage,
          mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      ReloadKeyButtonsColor(true);
      SetSaveState(SaveStateLayout, ssModified);
    end;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnTimingDelaysClick(Sender: TObject);
var
  timingDelay: integer;
begin
  try
    ResetPopupMenuMacro;
    NeedInput := True;

    if (IsKeyLoaded) then
    begin
      timingDelay := ShowTimingDelays(backColor, fontColor);
      if (timingDelay = 0) then
      begin
        SetModifiedKey(VK_RAND_DELAY, '', true);
      end
      else if (timingDelay >= MIN_TIMING_DELAY) and (timingDelay <= MAX_TIMING_DELAY) then
      begin
        SetModifiedKey(VK_MIN_DELAY + (timingDelay - 1), '', true);
      end;
    end;
  finally
    NeedInput := False;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnWindowsCombosClick(Sender: TObject);
begin
  ResetPopupMenuMacro;
  if (IsKeyLoaded) then
    SetWindowsCombo(not WindowsComboOn);
end;

procedure TFormMainRGB.CheckVDriveTmrTimer(Sender: TObject);
begin
  if (not GDemoMode) then
    CheckVDrive;
end;

procedure TFormMainRGB.chkDisableClick(Sender: TObject);
begin
  //if (chkDisable.Checked) then
  //begin
  //  SetCurrentMenuAction(nil, nil);
  //  if (ConfigMode = CONFIG_LIGHTING) then
  //  begin
  //    SetLedMode(lmDisabled);
  //    SetSaveState(SaveStateLayout, ssModified);
  //  end;
  //end;
end;

procedure TFormMainRGB.chkGlobalSpeedClick(Sender: TObject);
begin
  if (not loadingMacro) and IsKeyLoaded then
  begin
    activeKbKey.ActiveMacro.MacroSpeed := 0;
    MacroModified := true;
    sliderMacroSpeedChange(sender);
  end;
end;

procedure TFormMainRGB.chkRepeatMultiplayClick(Sender: TObject);
begin
  if (not loadingMacro) and IsKeyLoaded then
  begin
    activeKbKey.ActiveMacro.MacroRptFreq := 0;
    MacroModified := true;
    sliderMultiplayChange(sender);
  end;
end;

procedure TFormMainRGB.btnResetKeyClick(Sender: TObject);
var
  response: integer;
begin
  if IsKeyLoaded then
  begin
    if (ShowNotification(fileService.AppSettings.ResetKeyMsg)) then
    begin
      response := ShowDialog('Reset current key',
        'Do you want to reset the current Key?' + #10 + 'The remapped key action and any stored macros will be lost.',
        mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB, nil, 'Hide this notification?');
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
    ShowDialog('Reset key', 'You must select a key to reset', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnMinimizeClick(Sender: TObject);
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

procedure TFormMainRGB.btnMaximizeClick(Sender: TObject);
begin
  Maximize;
end;

procedure TFormMainRGB.Maximize;
var
  aRect: TRect;
begin
  if (parent <> nil) then
  begin
    aRect := Parent.ClientRect;

    self.Left := aRect.Left;
    self.Top := aRect.Top;
    self.Width := aRect.Width;
    self.Height := aRect.Height;
  end
  else
  begin
    aRect := Screen.PrimaryMonitor.WorkareaRect;

    if (cusWindowState = cwMaximized) then
    begin
      self.Height := NORMAL_HEIGHT;
      self.Width := NORMAL_WIDTH;
      self.Left := (aRect.Width - NORMAL_WIDTH) div 2;
      self.Top := (aRect.Height - NORMAL_HEIGHT) div 2;
      cusWindowState := cwNormal;
    end
    else
    begin
      self.Left := aRect.Left;
      self.Top := aRect.Top;
      self.Width := aRect.Width;
      self.Height := aRect.Height;
      cusWindowState := cwMaximized;
    end;
  end;

  UpdateStateSettings;
end;

procedure TFormMainRGB.UpdateStateSettings;
begin
  self.DisableAlign;

  {$ifdef Win64}
  //Disable paint on form
  SendMessage(self.Handle, WM_SETREDRAW, Integer(False), 0);
  {$endif}

  if (cusWindowState = cwMaximized) then
  begin
    imgListMenu.GetBitmap(1, btnMaximize.Glyph);
    btnMaximize.Hint := 'Restore window';
  end
  else
  begin
    imgListMenu.GetBitmap(0, btnMaximize.Glyph);
    btnMaximize.Hint := 'Maximize';
  end;

  oldWindowState := self.WindowState;

  {$ifdef Win64}
  //Enable paint on form on repaint
  SendMessage(self.Handle, WM_SETREDRAW, Integer(True), 0);
  {$endif}

  self.EnableAlign;
  self.Repaint;
end;

procedure TFormMainRGB.FormWindowStateChange(Sender: TObject);
begin
  UpdateStateSettings;
end;

//On application restore, remove borderstyle
procedure TFormMainRGB.OnRestore(Sender: TObject);
begin
  //self.WindowState := wsNormal;
  //SetFormBorder(bsNone);

  //To repaint red color in macro box
  //SetMacroText(true);
end;

procedure TFormMainRGB.SetFormBorder(formBorder: TFormBorderStyle);
begin
  //{$ifdef Win64}
  self.BorderStyle := formBorder;
  RepaintForm(true);
  //{$endif}
end;

procedure TFormMainRGB.AppDeactivate(Sender: TObject);
begin
  if (keyService <> nil) and (not closing) then
    keyService.ClearModifiers;
end;

procedure TFormMainRGB.imgMacroMenuClick(Sender: TObject);
begin

end;

procedure TFormMainRGB.memoMacroChange(Sender: TObject);
begin

end;

procedure TFormMainRGB.sliderMultiplayChange(Sender: TObject);
var
  value: integer;
  aColor:TColor;
begin
  value := Round(sliderMultiplay.Position);
  if (value = 0) or (chkRepeatMultiplay.Checked) then
  begin
    lblMultiplay.Caption := 'R';
    aColor := KINESIS_DARK_GRAY_RGB;
  end
  else
  begin
    lblMultiplay.Caption := IntToStr(value);
    aColor := KINESIS_BLUE_EDGE;
  end;
  sliderMultiplay.Knob.Color := aColor;
  sliderMultiplay.ProgressColor := aColor;
  sliderMultiplay.Scale.TickColor := aColor;
end;

procedure TFormMainRGB.sliderMultiplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingMacro) and IsKeyLoaded then
  begin
    chkRepeatMultiplay.Checked := false;
    sliderPos := sliderMultiplay.Position;
    if (Frac(sliderPos) > 0) then
    begin
      value := Round(sliderPos);
      sliderMultiplay.Position := value;
    end;

    if (not loadingMacro) then
    begin
      activeKbKey.ActiveMacro.MacroRptFreq := Round(sliderMultiplay.Position);
      MacroModified := true;
    end;
  end;
end;

procedure TFormMainRGB.sliderMacroSpeedChange(Sender: TObject);
var
  value: integer;
  aColor: TColor;
begin
  value := Round(sliderMacroSpeed.Position);
  if (value = 0) or (chkGlobalSpeed.Checked) then
  begin
    lblPlaybackSpeed.Caption := 'G';
    aColor := KINESIS_DARK_GRAY_RGB;
  end
  else
  begin
    lblPlaybackSpeed.Caption := IntToStr(value);
    aColor := KINESIS_BLUE_EDGE;
  end;
  sliderMacroSpeed.Knob.Color := aColor;
  sliderMacroSpeed.ProgressColor := aColor;
  sliderMacroSpeed.Scale.TickColor := aColor;
end;

procedure TFormMainRGB.sliderMacroSpeedMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingMacro) and IsKeyLoaded then
  begin
    chkGlobalSpeed.Checked := false;
    sliderPos := sliderMacroSpeed.Position;
    if (Frac(sliderPos) > 0) then
    begin
      value := Round(sliderPos);
      sliderMacroSpeed.Position := value;
    end;

    if (not loadingMacro) then
    begin
      activeKbKey.ActiveMacro.MacroSpeed := Round(sliderMacroSpeed.Position);
      MacroModified := true;
    end;
  end;
end;

procedure TFormMainRGB.SpectrumTimerTimer(Sender: TObject);
begin
  SpectrumTimer.Enabled := false;

  case keyService.LedSpeed of
    1: SpectrumTimer.Interval := 1900;
    2: SpectrumTimer.Interval := 1700;
    3: SpectrumTimer.Interval := 1600;
    4: SpectrumTimer.Interval := 1500;
    5: SpectrumTimer.Interval := 1400;
    6: SpectrumTimer.Interval := 1300;
    7: SpectrumTimer.Interval := 1200;
    8: SpectrumTimer.Interval := 1100;
    9: SpectrumTimer.Interval := 150;
  end;

  inc(spectrumCycle);
  if (spectrumCycle > 20) then
    spectrumCycle := 1;

  case spectrumCycle of
    1: spectrumColor := RGB(255, 0, 128);
    2: spectrumColor := RGB(255, 0, 255);
    3: spectrumColor := RGB(200, 0, 255);
    4: spectrumColor := RGB(128, 0, 255);
    5: spectrumColor := RGB(75, 0, 255);
    6: spectrumColor := RGB(0, 0, 255);
    7: spectrumColor := RGB(0, 70, 255);
    8: spectrumColor := RGB(0, 128, 255);
    9: spectrumColor := RGB(0, 200, 255);
    10: spectrumColor := RGB(0, 255, 255);
    11: spectrumColor := RGB(0, 255, 200);
    12: spectrumColor := RGB(0, 255, 128);
    13: spectrumColor := RGB(0, 255, 0);
    14: spectrumColor := RGB(128, 255, 0);
    15: spectrumColor := RGB(210, 255, 0);
    16: spectrumColor := RGB(255, 255, 0);
    17: spectrumColor := RGB(255, 200, 0);
    18: spectrumColor := RGB(255, 128, 0);
    19: spectrumColor := RGB(255, 75, 0);
    20: spectrumColor := RGB(255, 0, 0);
  end;

  ReloadKeyButtonsColor;

  SpectrumTimer.Enabled := true;
end;

procedure TFormMainRGB.rgbChange(Sender: TObject);
begin
end;

procedure TFormMainRGB.rgbKeyDown(Sender: TObject; var Key: Word;
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
    else if (eBlue.Focused) then
      eHTML.SetFocus
    else if (eRedBase.Focused) then
      eGreenBase.SetFocus
    else if (eGreenBase.Focused) then
      eBlueBase.SetFocus
    else if (eBlueBase.Focused) then
      eHTMLBase.SetFocus;
    Key:= 0;
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

procedure TFormMainRGB.rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  edit: TEdit;
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    edit := (Sender as TEdit);
    if (edit = eRed) or (edit = eGreen) or (edit = eBlue) then
      GetRBGEditColor
    else if (edit = eRedBase) or (edit = eGreenBase) or (edit = eBlueBase) then
      GetRBGEditBaseColor;
  end;
end;

procedure TFormMainRGB.GetRBGEditColor;
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

procedure TFormMainRGB.GetRBGEditBaseColor;
var
  iRed: integer;
  iGreen: integer;
  iBlue: integer;
begin
  iRed := ConvertToInt(eRedBase.Text, 0);
  iGreen := ConvertToInt(eGreenBase.Text, 0);
  iBlue := ConvertToInt(eBlueBase.Text, 0);

  if (iRed > 255) then
    iRed := 255;
  if (iGreen > 255) then
    iGreen := 255;
  if (iBlue > 255) then
    iBlue := 255;

  eRedBase.Text := IntToStr(iRed);
  eGreenBase.Text := IntToStr(iGreen);
  eBlueBase.Text := IntToStr(iBlue);

  ColorChangeBase(RGB(iRed, iGreen, iBlue));
  AfterColorChangeBase;
end;

procedure TFormMainRGB.rgbExit(Sender: TObject);
var
  edit: TEdit;
begin
  edit := (Sender as TEdit);
  if (edit = eRed) or (edit = eGreen) or (edit = eBlue) then
    GetRBGEditColor
  else if (edit = eRedBase) or (edit = eGreenBase) or (edit = eBlueBase) then
    GetRBGEditBaseColor;
end;

procedure TFormMainRGB.eHTMLChange(Sender: TObject);
begin
end;

procedure TFormMainRGB.eHTMLExit(Sender: TObject);
var
  sHtml: string;
  edit: TEdit;
begin
  edit := (Sender as TEdit);
  sHtml := edit.Text;
  if (Copy(edit.Text, 1, 1) = '#') then
    sHtml := Copy(edit.Text, 2, Length(edit.Text));
  if (Length(sHtml) = 6) then
  begin
    if (Sender = eHTML) then
    begin
      ColorChange(GetColorHTML(sHtml));
      AfterColorChange;
    end
    else if (Sender = eHTMLBase) then
    begin
      ColorChangeBase(GetColorHTML(sHtml));
      AfterColorChangeBase;
    end;
  end
  else
    edit.Text := GetHTMLColor(ringPicker.SelectedColor);
end;

procedure TFormMainRGB.eHTMLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) or (key = VK_TAB) then
  begin
    if (sender = eHTML) then
      eRed.SetFocus
    else if (sender = eHTMLBase) then
      eRedBase.SetFocus;
    Key:= 0;
  end;
end;

procedure TFormMainRGB.FormPaint(Sender: TObject);
begin

end;

procedure TFormMainRGB.FormResize(Sender: TObject);
var
  formWidth, formHeight: integer;
begin
  formWidth := self.Width;
  formHeight := self.Height;
  imgBackground.Width := formWidth;
  imgBackground.Height := formHeight;

  //jm old logo
  //imgLogoFSEdge.Left := (pnlTop.Width - logoSize) div 2;
  //imgLogoFSEdge2.Left := imgLogoFSEdge.Left + logoSize - imgLogoFSEdge2.Width;
  //lblVDriveOk.Left := imgLogoFSEdge2.Left + imgLogoFSEdge2.Width + 10;
  //lblVDriveError.Left := lblVDriveOk.Left;
end;

procedure TFormMainRGB.gifViewerStart(Sender: TObject);
begin
  if (keyService.LedMode in [lmBreathe, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain, lmPulse]) then
  begin
    ShowHideKeyButtons(true);
  end;
end;

procedure TFormMainRGB.imgBackMacroClick(Sender: TObject);
begin
  ResetPopupMenuMacro;
end;

procedure TFormMainRGB.imgKeyboardLightingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  keyButton: TLabelBox;
//  temp: TCursorImage;
begin
  if (keyService.LedMode in [lmFreestyle, lmBreathe]) then
  begin
    keyButton := GetKeyButtonUnderMouse(X + imgKeyboardLighting.Left, Y + imgKeyboardLighting.Top);
    SetSingleKeyColor(keybutton, ringPicker.SelectedColor);
  end;
  //temp.LoadFromResourceName(temp.Handle, ');
  //showMessage('X:' + IntToStr(Mouse.CursorPos.X) + ', Y:' + IntToStr(Mouse.CursorPos.Y));
end;

procedure TFormMainRGB.ImageMenuClick(Sender: TObject);
var
  aImage: TImage;
begin
  aImage := (sender as TImage);
  //if (currentMenuAction <> nil) and (currentMenuAction.ActionImage = aImage) then
  //  SetCurrentMenuAction(nil, nil)
  //else
  //begin
    SetCurrentMenuAction(maNone, nil, aImage);
    if (ConfigMode = CONFIG_LIGHTING) then
    begin
      SetLedMode(GetLedMode);
      SetSaveState(SaveStateLayout, ssModified);
    end;
  //end;
end;

procedure TFormMainRGB.imgMacroClick(Sender: TObject);
begin
  if (EditingMacro) then
    CloseMacroEditor
  else
    OpenMacroEditor;
end;

procedure TFormMainRGB.lblGlobalSpeedClick(Sender: TObject);
begin
  chkGlobalSpeed.Checked := not chkGlobalSpeed.Checked;
end;

procedure TFormMainRGB.lblRepeatMultiplayClick(Sender: TObject);
begin
  chkRepeatMultiplay.Checked := not chkRepeatMultiplay.Checked;
end;

procedure TFormMainRGB.lblTapHoldClick(Sender: TObject);
begin
  OpenTapAndHold;
end;

procedure TFormMainRGB.lbMenuMacroMouseLeave(Sender: TObject);
begin
  ResetPopupMenuMacro;
end;

procedure TFormMainRGB.lbMenuMouseLeave(Sender: TObject);
begin
  ResetPopupMenu;
end;

procedure TFormMainRGB.imgTapHoldClick(Sender: TObject);
begin
  OpenTapAndHold;
end;

procedure TFormMainRGB.OpenTapAndHold;
var
  customBtns: TCustomButtons;
  keyOtherLayer: TKBKey;
  otherLayer: TKBLayer;
begin
  if (IsKeyLoaded) then
  begin
    if (fileService.VersionBiggerEqualKBD(1, 0, 1) or GDemoMode) then
    begin
      //Check key other layer
      if (keyService.ActiveLayer.LayerIndex = TOPLAYER_IDX) then
        otherLayer := keyService.GetLayer(BOTLAYER_IDX)
      else
        otherLayer := keyService.GetLayer(TOPLAYER_IDX);
      keyOtherLayer := keyService.GetKbKeyByIndex(otherLayer, activeKbKey.Index);

      if (keyOtherLayer <> nil) and (keyOtherLayer.TapAndHold) then
        ShowDialog('Tap and Hold', 'You cannot assign a Tap and Hold Action to the same key in both layers.', mtWarning, [mbOk], DEFAULT_DIAG_HEIGHT_RGB)
      else if (activeKbKey.TapAndHold = false) and (tapHoldCount >= MAX_TAP_HOLD) then
        ShowDialog('Tap and Hold', 'You have reached the maximum number of Tap and Hold actions for this Profile.', mtWarning, [mbOk], DEFAULT_DIAG_HEIGHT_RGB)
      else if (activeKbKey.IsMacro) then
      begin
        ShowDialog('Tap and Hold', 'You cannot assign a Tap and Hold Action to a macro trigger key.',
          mtWarning, [mbOk], DEFAULT_DIAG_HEIGHT_RGB);
      end
      else if (keyService.ActiveLayer.LayerIndex = TOPLAYER_IDX) and
        (((activeKbKey.OriginalKey.Key >= VK_A) and (activeKbKey.OriginalKey.Key <= VK_Z)) or
        ((activeKbKey.OriginalKey.Key >= VK_0) and (activeKbKey.OriginalKey.Key <= VK_9))) then
      begin
        ShowDialog('Tap and Hold', 'You cannot assign a Tap and Hold Action to these keys (A-Z, 0-9) on the Top Layer.',
          mtWarning, [mbOk], DEFAULT_DIAG_HEIGHT_RGB);
      end
      else
      begin
        if (ShowTapAndHold(keyService, activeKbKey.TapAction, activeKbKey.HoldAction, activeKbKey.TimingDelay, backColor, fontColor, activeColor)) then
        begin
          KeyModified := true;
          SetSaveState(ssModified, SaveStateLighting);
          keyService.SetTapAndHold(activeKbKey, FormTapAndHold.tapAction, FormTapAndHold.holdAction, FormTapAndHold.timingDelay);
          UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
          RefreshRemapInfo;
        end;
      end;
    end
    else
    begin
      createCustomButton(customBtns, 'OK', 100, nil, bkOK);
      //createCustomButton(customBtns, 'Upgrade Firmware', 150, @openFirwareWebsite);
      ShowDialog('Tap and Hold', 'To utilize Tap and Hold Actions, please download and install the latest firmware.',
        mtWarning, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
    end;
  end;
end;

procedure TFormMainRGB.lblMacroClick(Sender: TObject);
begin
  if (EditingMacro) then
    CloseMacroEditor
  else
    OpenMacroEditor;
end;

procedure TFormMainRGB.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win64}
  SendMessage(imgBackground.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardBack.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardLayout.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardLighting.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}
  //jm todo SendMessage(memoMacro.Handle, LM_SETREDRAW, WPARAM(False), 0);
  {$endif}
end;

procedure TFormMainRGB.gifViewerClick(Sender: TObject);
begin

end;

procedure TFormMainRGB.imgLeftMenuClick(Sender: TObject);
begin
  ResetPopupMenu;
  ResetSingleKey;
end;

procedure TFormMainRGB.ResetPopupMenu;
begin
  pnlMenu.Visible := false;
  currentPopupMenu := nil;
end;

procedure TFormMainRGB.ResetPopupMenuMacro;
begin
  pnlMenuMacro.Visible := false;
end;

procedure TFormMainRGB.ResetSingleKey;
begin
  //btnLEDControl.Down := false;
  //btnDisableKey.Down := false;
  //lblLedControl.Font.Color := KINESIS_FONT_COLOR_RGB;
  //lblDisableKey.Font.Color := KINESIS_FONT_COLOR_RGB;
end;

procedure TFormMainRGB.ResetProfileMenu;
begin
  profileMode := pmNone;
  pnlSelectProfile.Visible := false;
  LoadButtonImage(imgProfile, imgListProfileDefault, currentProfileNumber);
  SetHovered(btnSaveAs, false, true);
end;

procedure TFormMainRGB.ResetDirection;
begin
  btnDirVertical.Down := false;
  btnDirUp.Down := false;
  btnDirDown.Down := false;
  btnDirHorizontal.Down := false;
  btnDirLeft.Down := false;
  btnDirRight.Down := false;

  SetHovered(btnDirUp, false, true);
  SetHovered(btnDirVertical, false, true);
  SetHovered(btnDirLeft, false, true);
  SetHovered(btnDirHorizontal, false, true);
  SetHovered(btnDirDown, false, true);
  SetHovered(btnDirRight, false, true);
end;

procedure TFormMainRGB.SetDirection(direction: integer; ledMode: TLedMode);
begin
  btnDirVertical.Down := (direction = LED_DIR_UP_INT) and (ledMode in [lmRebound]);
  btnDirUp.Down := (direction = LED_DIR_UP_INT) and not(ledMode in [lmRebound]);
  btnDirDown.Down := (direction = LED_DIR_DOWN_INT);
  btnDirHorizontal.Down := (direction = LED_DIR_LEFT_INT) and (ledMode in [lmRebound]);
  btnDirLeft.Down := (direction = LED_DIR_LEFT_INT) and not(ledMode in [lmRebound]);
  btnDirRight.Down := (direction = LED_DIR_RIGHT_INT);

  SetHovered(btnDirUp, (direction = LED_DIR_UP_INT) and not(ledMode in [lmRebound]));
  SetHovered(btnDirVertical, (direction = LED_DIR_UP_INT) and (ledMode in [lmRebound]));
  SetHovered(btnDirLeft, (direction = LED_DIR_LEFT_INT) and not(ledMode in [lmRebound]));
  SetHovered(btnDirHorizontal, (direction = LED_DIR_LEFT_INT) and (ledMode in [lmRebound]));
  SetHovered(btnDirDown, (direction = LED_DIR_DOWN_INT));
  SetHovered(btnDirRight, (direction = LED_DIR_RIGHT_INT));

  keyService.LedDirection := direction;
end;

procedure TFormMainRGB.btnDirectionClick(Sender: TObject);
var
  value: integer;
begin
  if (not loadingLedSettings) then
  begin
    if (sender = btnDirUp) or (sender = btnDirVertical) then
      value := LED_DIR_UP_INT
    else if (sender = btnDirLeft) or (sender = btnDirHorizontal) then
      value := LED_DIR_LEFT_INT
    else if (sender = btnDirDown) then
      value := LED_DIR_DOWN_INT
    else if (sender = btnDirRight) then
      value := LED_DIR_RIGHT_INT;

    SetDirection(value, keyService.LedMode);
    SetSaveState(SaveStateLayout, ssModified);
    if (keyService.LedMode in [lmRain, lmReactive, lmRipple, lmFireball, lmLoop, lmRebound, lmStarlight]) then
    begin
      ResetNewGif;
      NewGifTimer.Enabled := true;
    end
    else
      LoadGifTimer.Enabled := true;
  end;
end;

procedure TFormMainRGB.knobSpeedChange(Sender: TObject);
begin
  lblSpeedText.Caption := IntToStr(Round(knobSpeed.Position));
end;

procedure TFormMainRGB.knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
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
      NewGifTimer.Enabled := false;
      WaveTimer.Enabled := false;
      SpectrumTimer.Enabled := false;
      if (keyService.LedMode in [lmBreathe, lmPulse]) then
      begin
        ResetBreathe;
        BreatheTimer.Enabled := true;
      end
      else if (keyService.LedMode in [lmRain, lmReactive, lmRipple, lmFireball, lmLoop, lmRebound, lmStarlight]) then
      begin
        ResetNewGif;
        NewGifTimer.Enabled := true;
      end
      else if (keyService.LedMode in [lmWave]) then
      begin
        ResetWave;
        WaveTimer.Enabled := true;
      end
      else if (keyService.LedMode in [lmSpectrum]) then
      begin
        ResetSpectrum;
        SpectrumTimer.Enabled := true;
      end
      else
      begin
        LoadGifTimer.Enabled := true;
      end;
      knobSpeed.Enabled := true;
    end;
  end;

end;

procedure TFormMainRGB.miAddCustColorClick(Sender: TObject);
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
    custColor6.Color := custColor
  else if (custColor7.Color = DEFAULT_CUST_COLOR) then
    custColor7.Color := custColor
  else if (custColor8.Color = DEFAULT_CUST_COLOR) then
    custColor8.Color := custColor
  else if (custColor9.Color = DEFAULT_CUST_COLOR) then
    custColor9.Color := custColor
  else if (custColor10.Color = DEFAULT_CUST_COLOR) then
    custColor10.Color := custColor
  else if (custColor11.Color = DEFAULT_CUST_COLOR) then
    custColor11.Color := custColor
  else if (custColor12.Color = DEFAULT_CUST_COLOR) then
    custColor12.Color := custColor;
end;

procedure TFormMainRGB.colorPreMixedClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorChange((Sender as TmbColorPreview).Color);
  AfterColorChange;
end;

procedure TFormMainRGB.colorPreMixedBaseClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorChangeBase((Sender as TmbColorPreview).Color);
  AfterColorChangeBase;
end;

procedure TFormMainRGB.custColorClick(Sender: TObject; Button: TMouseButton;
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

procedure TFormMainRGB.custColorBaseClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  custColor: TColor;
begin
  custColor := (Sender as TmbColorPreview).Color;
  if (custColor <> clNone) then
  begin
    ColorChangeBase(custColor);
    AfterColorChangeBase;
  end;
end;

procedure TFormMainRGB.custColorChange(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    fileService.SetCustomColor(custColor1.Color, 1);
    fileService.SetCustomColor(custColor2.Color, 2);
    fileService.SetCustomColor(custColor3.Color, 3);
    fileService.SetCustomColor(custColor4.Color, 4);
    fileService.SetCustomColor(custColor5.Color, 5);
    fileService.SetCustomColor(custColor6.Color, 6);
    fileService.SetCustomColor(custColor7.Color, 7);
    fileService.SetCustomColor(custColor8.Color, 8);
    fileService.SetCustomColor(custColor9.Color, 9);
    fileService.SetCustomColor(custColor10.Color, 10);
    fileService.SetCustomColor(custColor11.Color, 11);
    fileService.SetCustomColor(custColor12.Color, 12);
    fileService.SaveAppSettings;
  end;
end;

procedure TFormMainRGB.eHTMLBaseExit(Sender: TObject);
begin

end;

procedure TFormMainRGB.colorPreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then   {check if left mouse button was pressed}
    (Sender as TmbColorPreview).BeginDrag(true);  {starting the drag operation}
end;

procedure TFormMainRGB.custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Source is TmbColorPreview) then
    (Sender as TmbColorPreview).Color := (Source as TmbColorPreview).Color;
end;

procedure TFormMainRGB.custColorDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source is TmbColorPreview) then
    Accept := true;
end;

procedure TFormMainRGB.ringPickerChange(Sender: TObject);
begin
  if (not loadingColor) then
  begin
    ColorChange(ringPicker.SelectedColor);
    AfterColorChange;
  end;
end;

procedure TFormMainRGB.ringPickerBaseChange(Sender: TObject);
begin
  if (not loadingColorBase) then
  begin
    ColorChangeBase(ringPickerBase.SelectedColor);
    AfterColorChangeBase;
  end;
end;

procedure TFormMainRGB.ColorChange(newColor: TColor);
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
      if (keyService.LedMode in [lmFreestyle, lmBreathe]) and (IsKeyLoaded) then
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
      else if (keyService.LedMode in [lmRipple]) then
      begin
        keyService.LedColorRipple := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmFireball]) then
      begin
        keyService.LedColorFireball := newColor;
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
      else if (keyService.LedMode in [lmLoop]) then
      begin
        keyService.LedColorLoop := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmRain]) then
      begin
        keyService.LedColorRain := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end;
    end;
  finally
    loadingColor := false;
  end;
end;

procedure TFormMainRGB.ColorChangeBase(newColor: TColor);
begin
  try
    loadingColorBase := true;
    ringPickerBase.SelectedColor := newColor;
    colorPreviewBase.Color := newColor;
    eRedBase.Text := IntToStr(GetRValue(newColor));
    eGreenBase.Text := IntToStr(GetGValue(newColor));
    eBlueBase.Text := IntToStr(GetBValue(newColor));
    eHTMLBase.Text := GetHTMLColor(newColor);

    if (not loadingSettings) and (not loadingLedSettings) then
    begin
      if (keyService.LedMode in [lmReactive]) then
      begin
        keyService.BaseLedColorReactive := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmRipple]) then
      begin
        keyService.BaseLedColorRipple := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmFireball]) then
      begin
        keyService.BaseLedColorFireball := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmStarlight]) then
      begin
        keyService.BaseLedColorStarlight := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmRebound]) then
      begin
        keyService.BaseLedColorRebound := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmLoop]) then
      begin
        keyService.BaseLedColorLoop := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end
      else if (keyService.LedMode in [lmRain]) then
      begin
        keyService.BaseLedColorRain := newColor;
        SetSaveState(SaveStateLayout, ssModified);
      end;
    end;
  finally
    loadingColorBase := false;
  end;
end;

procedure TFormMainRGB.AfterColorChange;
begin
  if (keyService.LedMode in [lmMonochrome, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain]) then
  begin
    MonochromeTimer.Enabled := true;
  end;
end;

procedure TFormMainRGB.AfterColorChangeBase;
begin
  if (keyService.LedMode in [lmMonochrome, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain]) then
  begin
    //MonochromeTimer.Enabled := true;
  end;
end;

procedure TFormMainRGB.MonochromeTimerTimer(Sender: TObject);
begin
  ReloadKeyButtonsColor;
  MonochromeTimer.Enabled := false;
end;

procedure TFormMainRGB.ChangeActiveLayer(layerIdx: integer);
begin
  if (not resetLayer) then
  begin
    if (CheckSaveKey) then
    begin
      SetActiveLayer(layerIdx);
    end
    else
    begin
      resetLayer := true;
    end;
    swLayerSwitch.Checked := layerIdx = TOPLAYER_IDX;
  end;
  resetLayer := false;
end;

procedure TFormMainRGB.swLayerSwitchClick(Sender: TObject);
begin
  if (swLayerSwitch.Checked) then
    ChangeActiveLayer(TOPLAYER_IDX)
  else
    ChangeActiveLayer(BOTLAYER_IDX);
end;

procedure TFormMainRGB.TopMenuClick(Sender: TObject);
begin
  if (sender = pnlLayoutBtn) and (ConfigMode = CONFIG_LIGHTING) then
  begin
    SetConfigMode(CONFIG_LAYOUT);
  end
  else if (sender = pnlLightingBtn) and (ConfigMode = CONFIG_LAYOUT) then
  begin
    SetConfigMode(CONFIG_LIGHTING);
  end;
end;

function TFormMainRGB.GetMenuActionByType(actionType: TMenuActionType): TMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    if ((menuActionList.Items[i] as TMenuAction).ActionType = actionType) then
    begin
      menuAction := (menuActionList.Items[i] as TMenuAction);
      Break;
    end;
  end;

  result := menuAction;
end;

function TFormMainRGB.GetMenuActionByLabel(labelName: string): TMenuAction;
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

function TFormMainRGB.GetMenuActionByImage(imageName: string): TMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    if ((menuActionList.Items[i] as TMenuAction).ActionImage <> nil) and
      ((menuActionList.Items[i] as TMenuAction).ActionImage.Name = imageName) then
    begin
      menuAction := (menuActionList.Items[i] as TMenuAction);
      Break;
    end;
  end;

  result := menuAction;
end;

procedure TFormMainRGB.ResetAllMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    chkDisable.Checked := false;
    menuAction := (menuActionList.Items[i] as TMenuAction);
    menuAction.IsDown := false;
    if (menuAction.ActionImage <> nil) then
      menuAction.ActionImage.Picture.Clear;
    if (menuAction.IsEnabled) then
      menuAction.ActionLabel.Font.Color := KINESIS_FONT_COLOR_RGB
    else
      menuAction.ActionLabel.Font.Color := KINESIS_MED_GRAY_RGB;
  end;
end;

procedure TFormMainRGB.SetCurrentMenuAction(aType: TMenuActionType;
  aLabel: TLabel; aImage: TImage);
var
  aMenuAction: TMenuAction;
  customBtns: TCustomButtons;
begin
  if (aType <> maNone) then
    aMenuAction := GetMenuActionByType(aType)
  else if (aLabel <> nil) then
    aMenuAction := GetMenuActionByLabel(aLabel.Name)
  else if (aImage <> nil) then
    aMenuAction := GetMenuActionByImage(aImage.Name)
  else
    aMenuAction := nil;

  if (aMenuAction <> currentMenuAction) then
  begin
    if (aMenuAction <> nil) and (not aMenuAction.IsEnabled) then
    begin
      createCustomButton(customBtns, 'OK', 100, nil, bkOK);
      ShowDialog(aMenuAction.ActionLabel.Caption, 'To utilize ' + aMenuAction.ActionLabel.Caption + ', please download and install the latest firmware.',
          mtWarning, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
    end
    else
    begin
      ResetAllMenuAction;
      ResetPopupMenu;
      ResetPopupMenuMacro;
      ResetSingleKey;

      currentMenuAction := aMenuAction;
      if (currentMenuAction <> nil) and (currentMenuAction.StayDown) then
      begin
        currentMenuAction.IsDown := true;
        currentMenuAction.ActionLabel.Font.Color := KINESIS_BLUE_EDGE;
        if (currentMenuAction.ActionImage <> nil) then
          LoadButtonImage(currentMenuAction.ActionImage, imgListProfileMenu, 0);
      end;

      if (ConfigMode = CONFIG_LAYOUT) then
      begin
        SetMacroMode((currentMenuAction <> nil) and (currentMenuAction.ActionLabel = lblMacro));
        //SetRemapMode(not btnMacro.Down);
        //SetMacroMode(btnMacro.Down);
      end;
    end;
  end;
end;

procedure TFormMainRGB.SetMenuItems(aMenuAction: TMenuAction);
var
  sameMenu: boolean;
  customBtns: TCustomButtons;
  mustSelectKey: boolean;
begin
  sameMenu := aMenuAction = currentPopupMenu;
  ResetPopupMenu;
  ResetSingleKey;
  lbMenu.Items.Clear;
  mustSelectKey := false;

  if (not sameMenu) then
  begin
    if (aMenuAction.ActionLabel = lblMedia) then
    begin
      mustSelectKey := true;
      if (IsKeyLoaded) then
      begin
        lbMenu.Items.AddObject('Volume Up', TObject(VK_VOLUME_UP));
        lbMenu.Items.AddObject('Volume Down', TObject(VK_VOLUME_DOWN));
        lbMenu.Items.AddObject('Mute', TObject(VK_VOLUME_MUTE));
        lbMenu.Items.AddObject('Play/Pause', TObject(VK_MEDIA_PLAY_PAUSE));
        lbMenu.Items.AddObject('Previous Track', TObject(VK_MEDIA_PREV_TRACK));
        lbMenu.Items.AddObject('Next Track', TObject(VK_MEDIA_NEXT_TRACK));
      end;
    end
    else if (aMenuAction.ActionLabel = lblMouseClicks) then
    begin
      mustSelectKey := true;
      if (IsKeyLoaded) then
      begin
        lbMenu.Items.AddObject('Left Click', TObject(VK_MOUSE_LEFT));
        lbMenu.Items.AddObject('Middle Click', TObject(VK_MOUSE_MIDDLE));
        lbMenu.Items.AddObject('Right Click', TObject(VK_MOUSE_RIGHT));
        lbMenu.Items.AddObject('Button 4', TObject(VK_MOUSE_BTN4));
        lbMenu.Items.AddObject('Button 5', TObject(VK_MOUSE_BTN5));
      end;
    end
    else if (aMenuAction.ActionLabel = lblAltLayouts) then
    begin
      lbMenu.Items.AddObject('Dvorak', TObject(VK_DVORAK));
      lbMenu.Items.AddObject('Colemak', TObject(VK_COLEMAK));
      lbMenu.Items.AddObject('Workman', TObject(VK_WORKMAN));
    end
    else if (aMenuAction.ActionLabel = lblFunctionKeys) then
    begin
      mustSelectKey := true;
      if (IsKeyLoaded) then
      begin
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
      end;
    end
    else if (aMenuAction.ActionLabel = lblPreHotkeys) then
    begin
      lbMenu.Items.AddObject('Freestyle2 Hotkeys', TObject(VK_FS2_HOTKEYS));
      {$ifdef Win64} //Windows
        lbMenu.Items.AddObject('Freestyle Pro Hotkeys', TObject(VK_FSPRO_HOTKEYS));
      {$endif}
      {$ifdef Linux}
        lbMenu.Items.AddObject('Freestyle Pro Hotkeys', TObject(VK_FSPRO_HOTKEYS));
      {$endif}
      {$ifdef darwin}
        lbMenu.Items.AddObject('Mac Modifiers', TObject(VK_MAC_MODIFIERS));
      {$endif}
    end
    else if (aMenuAction.ActionLabel = lblFullKeypad) then
    begin
      //if (RemapMode) then
      //begin
        //lbMenu.Items.AddObject('Full Keypad (Fn Layer)', nil);
        //lbMenu.Items.AddObject('--------------------------', nil);
        lbMenu.Items.AddObject('Right Side', TObject(VK_NUMERIC_RIGHT));
        lbMenu.Items.AddObject('Left Side', TObject(VK_NUMERIC_LEFT));
        //if (IsKeyLoaded) then
        //begin
        //end;
      //end
      //else
      //  errorRemap := true;
    end
    else if (aMenuAction.ActionLabel = lblKeypadActions) then
    begin
      mustSelectKey := true;
      if (IsKeyLoaded) then
      begin
        //lbMenu.Items.AddObject('Individual Actions', nil);
        //lbMenu.Items.AddObject('---------------------', nil);
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
      end;
    end
    else if (aMenuAction.ActionLabel = lblFunctionAccess) then
    begin
      mustSelectKey := true;
      if (IsKeyLoaded) then
      begin
        lbMenu.Items.AddObject('Fn Toggle', TObject(VK_FN_TOGGLE));
        lbMenu.Items.AddObject('Fn Shift', TObject(VK_FN_SHIFT));
      end;
    end
    else if (aMenuAction.ActionLabel = lblMultimodifiers) then
    begin
      mustSelectKey := true;
      if (fileService.VersionBiggerEqualKBD(1, 0, 1) or GDemoMode) then
      begin
        if (IsKeyLoaded) then
        begin
          lbMenu.Items.AddObject('Hyper', TObject(VK_HYPER));
          lbMenu.Items.AddObject('Meh', TObject(VK_Meh));
        end;
      end
      else
      begin
        createCustomButton(customBtns, 'OK', 100, nil, bkOK);
        ShowDialog('Multimodifiers', 'To utilize Multimodifiers, please download and install the latest firmware.',
          mtWarning, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
      end;
    end
    else if (aMenuAction.ActionLabel = lblSpecialActions) then
    begin
      mustSelectKey := true;
      if (IsKeyLoaded) then
      begin
        lbMenu.Items.AddObject('Right Windows', TObject(VK_RWIN));
        lbMenu.Items.AddObject('Left Windows', TObject(VK_LWIN));
        {$ifdef Win64}
        lbMenu.Items.AddObject('Menu', TObject(VK_KP_MENU));
        {$endif}
        {$ifdef Linux}
        lbMenu.Items.AddObject('Menu', TObject(VK_KP_MENU));
        {$endif}
        {$ifdef darwin}
        lbMenu.Items.AddObject('Menu', TObject(VK_MOUSE_RIGHT));
        {$endif}
        lbMenu.Items.AddObject('International Key', TObject(VK_OEM_102));
        lbMenu.Items.AddObject('Shutdown (Windows)', TObject(VK_SHUTDOWN));
        lbMenu.Items.AddObject('Calculator (Windows)', TObject(VK_CALC));
      end;
    end;

    //if (mustSelectKey) and (not IsKeyLoaded) then
    //  ShowDialog('Action', 'You must select a key on the keyboard', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

    if (lbMenu.Items.Count > 0) then
    begin
      pnlMenu.Height := (lbMenu.Items.Count * lbMenu.ItemHeight) + 10;
      //jm temp
      //if (showTop) then
      //  pnlMenu.Top := aMenuAction.ActionLabel.Top - pnlMenu.Height
      //else
        pnlMenu.Top := pnlProfile.Top + pnlLayout.Top + aMenuAction.ActionLabel.Top + aMenuAction.ActionLabel.Height;
      pnlMenu.Visible := true;
      currentPopupMenu := aMenuAction;
      pnlMenu.Left:= pnlProfile.Left + pnlLayout.Left +aMenuAction.ActionLabel.Left;
    end;
  end;
end;

procedure TFormMainRGB.SetMacroMenuItems(button: TColorSpeedButtonCS);
begin
  ResetPopupMenuMacro;

  if (IsKeyLoaded) then
  begin
    lbMenuMacro.Items.Clear;
    activeMacroMenu := button.Name;

    if (button = btnCommonShortcuts) then
    begin
      lbMenuMacro.Items.AddObject('Cut', TObject(VK_CUT));
      lbMenuMacro.Items.AddObject('Copy', TObject(VK_COPY));
      lbMenuMacro.Items.AddObject('Paste', TObject(VK_PASTE));
      lbMenuMacro.Items.AddObject('Select All', TObject(VK_SELECTALL));
      lbMenuMacro.Items.AddObject('Undo', TObject(VK_UNDO));
      {$ifdef Win64} //Windows
      lbMenuMacro.Items.AddObject('Redo', TObject(VK_REDO));
      lbMenuMacro.Items.AddObject('Desktop', TObject(VK_DESKTOP));
      {$endif}
      lbMenuMacro.Items.AddObject('Last App', TObject(VK_LASTAPP));
      {$ifdef Win64} //Windows
        lbMenuMacro.Items.AddObject('Ctrl Alt Delete', TObject(VK_CTRLALTDEL));
      {$endif}
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
end;

procedure TFormMainRGB.lbMenuClick(Sender: TObject);
var
  //menuItem: TMenuItem;
  mnuAction: Integer;
  customBtns: TCustomButtons;
  bothLayers: boolean;
begin
  if (lbMenu.ItemIndex >= 0) and (lbMenu.Items.Objects[lbMenu.ItemIndex] <> nil) then
  begin
    {$ifdef CPU64}
    mnuAction := Integer(Pointer(lbMenu.Items.Objects[lbMenu.ItemIndex]));
    {$else}
    mnuAction := Integer(lbMenu.Items.Objects[lbMenu.ItemIndex]);
    {$endif}

    if (mnuAction > 0) then
    begin
      if (mnuAction = VK_DVORAK) or (mnuAction = VK_COLEMAK) or (mnuAction = VK_WORKMAN) then
      begin
        if (mnuAction = VK_DVORAK) then
        begin
          createCustomButton(customBtns, 'Both Layers', 110, @setDvorakBothLayers);
          createCustomButton(customBtns, 'Top Layer', 110, @setDvorakTopLayer);
          createCustomButton(customBtns, 'Fn Layer', 110, @setDvorakFnLayer);
          createCustomButton(customBtns, 'Cancel', 110, nil, bkCancel);
        end
        else if (mnuAction = VK_COLEMAK) then
        begin
          createCustomButton(customBtns, 'Both Layers', 110, @setColemakBothLayers);
          createCustomButton(customBtns, 'Top Layer', 110, @setColemakTopLayer);
          createCustomButton(customBtns, 'Fn Layer', 110, @setColemakFnLayer);
          createCustomButton(customBtns, 'Cancel', 110, nil, bkCancel);
        end
        else if (mnuAction = VK_WORKMAN) then
        begin
          createCustomButton(customBtns, 'Both Layers', 110, @setWorkmanBothLayers);
          createCustomButton(customBtns, 'Top Layer', 110, @setWorkmanTopLayer);
          createCustomButton(customBtns, 'Fn Layer', 110, @setWorkmanFnLayer);
          createCustomButton(customBtns, 'Cancel', 110, nil, bkCancel);
        end;

        ShowDialog('Alternate Layout',
          'To which Layer would you like to apply this alternate layout?' + #10#10 +
          'Note: Implementing this layout may overwrite existing remaps.',
          mtWarning, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns);
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
      else if (mnuAction = VK_MAC_MODIFIERS) then
      begin
        SetMacModifiersHotkeys;
        ResetPopupMenu;
        ResetSingleKey;
      end
      else
      begin
        if (IsKeyLoaded) then
        begin
          bothLayers := (mnuAction = VK_FN_SHIFT) or (mnuAction = VK_FN_TOGGLE);
          SetModifiedKey(mnuAction, '', false, bothLayers, true, true);
          ResetPopupMenu;
          ResetSingleKey;
        end;
      end;
    end;
  end;
end;

procedure TFormMainRGB.lbMenuMacroClick(Sender: TObject);
var
  mnuAction: Integer;
begin
  if (EditingMacro) and (lbMenuMacro.ItemIndex >= 0) and
    (lbMenuMacro.Items.Objects[lbMenuMacro.ItemIndex] <> nil) then
  begin
    {$ifdef CPU64}
    mnuAction := Integer(Pointer(lbMenuMacro.Items.Objects[lbMenuMacro.ItemIndex]));
    {$else}
    mnuAction := Integer(lbMenuMacro.Items.Objects[lbMenuMacro.ItemIndex]);
    {$endif}

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
        SetModifiedKey(VK_Y, L_SHIFT_MOD + ',' + L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_DESKTOP) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_D, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_LASTAPP) then
      begin
        {$ifdef Win64} //Windows
        SetModifiedKey(VK_TAB, L_ALT_MOD, true)
        {$endif}
        {$ifdef Darwin}  //MacOS
        SetModifiedKey(VK_TAB, L_WIN_MOD, true)
        {$endif}
      end
      else if (mnuAction = VK_CTRLALTDEL) then
      begin
        {$ifdef Win64} //Windows
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

procedure TFormMainRGB.lbMenuMacroMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  point: TPoint;
  idx: integer;
begin
  point.x := X;
  point.y := Y;

  idx := lbMenuMacro.ItemAtPos(point, true);
  lbMenuMacro.ItemIndex := idx;
end;

procedure TFormMainRGB.lbMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  point: TPoint;
  idx: integer;
begin
  point.x := X;
  point.y := Y;

  idx := lbMenu.ItemAtPos(point, true);
  lbMenu.ItemIndex := idx;
end;

procedure TFormMainRGB.lbProfileClick(Sender: TObject);
var
  layoutFile: string;
  ledFile: string;
  errorMsg: string;
  idxPos: integer;
  continue: boolean;
begin
  continue := true;
  layoutFile := '';
  ledFile := '';
  idxPos := lbProfile.ItemIndex + 1;

  if (GDemoMode) then
    continue := false;

  if continue and (not CheckVDrive) then
    continue := ShowTroubleshootingDialog(false);

  if (idxPos >= MIN_LAYOUT_FILE) and (idxPos <= MAX_LAYOUT_FILE) then
  begin
    layoutFile := FILE_LAYOUT + intToStr(idxPos) + '.txt';
    ledFile := FILE_LED + intToStr(idxPos) + '.txt';
  end;

  if continue and (layoutFile <> '') then
  begin
    if (profileMode = pmSelect) then
    begin
      if CheckSaveKey and CheckToSave(true) then
      begin
        if not fileService.CheckIfFileExists(GLayoutFilePath + layoutFile) then
          fileService.SaveFile(GLayoutFilePath + layoutFile, nil, true, errorMsg);
        if not fileService.CheckIfFileExists(GLedFilePath + ledFile) then
          fileService.SaveFile(GLedFilePath + ledFile, nil, true, errorMsg);
        currentLayoutFile := GLayoutFilePath + layoutFile;
        currentLedFile := GLedFilePath + ledFile;
        currentProfileNumber := fileService.GetFileNumber(currentLayoutFile);
        LoadKeyboardLayout(currentLayoutFile, nil);
        LoadLedFile(currentLedFile, nil);
        SetSaveState(ssNone, ssNone);
      end;
    end
    else if (profileMode = pmSaveAs) then
    begin
      SaveAsAll(IntToStr(idxPos));
    end;
  end;

  ResetProfileMenu;
end;

procedure TFormMainRGB.lbProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  point: TPoint;
  idx: integer;
begin
  point.x := X;
  point.y := Y;

  idx := lbProfile.ItemAtPos(point, true);
  lbProfile.ItemIndex := idx;

  if (profileMode = pmSaveAs) then
    SetHovered(btnSaveAs, true);
end;

procedure TFormMainRGB.lbProfileDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    Font.Color := KINESIS_FONT_COLOR_RGB;
    if odSelected in State then
    begin
      Brush.Color := KINESIS_MED_GRAY_RGB;
      Font.Color := clWhite;
    end;

    FillRect(ARect);
    TextOut(ARect.Left, ARect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TFormMainRGB.lbMenuDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
    with (Control as TListBox).Canvas do
  begin
    Font.Color := KINESIS_FONT_COLOR_RGB;
    if odSelected in State then
    begin
      Brush.Color := KINESIS_MED_GRAY_RGB;
      Font.Color := clWhite;
    end;

    FillRect(ARect);
    TextOut(ARect.Left, ARect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TFormMainRGB.SetFnNumericKpLeft;
var
  aFnLayer: TKBLayer;
  sMessage: string;
begin
  if CheckSaveKey then
  begin
    sMessage := 'Inserting this numeric keypad may overwrite existing remaps in the Fn Layer of this Layout, proceed?';
    if (GApplication = APPL_FSEDGE) then
      sMessage := sMessage  + #10#10 + 'Note: There is no numlock indicator light on the keyboard.';

    if ShowDialog('Insert Numeric Keypad', sMessage,
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
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

procedure TFormMainRGB.SetFnNumericKpRight;
var
  aFnLayer: TKBLayer;
  sMessage: string;
begin
  if CheckSaveKey then
  begin
    sMessage := 'Inserting this numeric keypad may overwrite existing remaps in the Fn Layer of this Layout, proceed?';
    if (GApplication = APPL_FSEDGE) then
      sMessage := sMessage  + #10#10 + 'Note: There is no numlock indicator light on the keyboard.';

    if ShowDialog('Insert Numeric Keypad', sMessage,
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      aFnLayer := keyService.GetLayer(BOTLAYER_IDX);
      if (aFnLayer <> nil) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);

        keyService.SetKBKeyIdx(aFnLayer, 8, VK_NUMLOCK);  //Replace Fn F7
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
        if (GApplication in [APPL_FSEDGE, APPL_RGB]) then
          keyService.SetKBKeyIdx(aFnLayer, 89, VK_NUMPADENTER);  //Replace Fn right space

        SetActiveLayer(BOTLAYER_IDX);
        swLayerSwitch.Checked := false;
        RefreshRemapInfo;
      end;
    end;
  end;
end;

procedure TFormMainRGB.SetMacModifiersHotkeys;
var
  i:integer;
  aLayer: TKBLayer;
begin
  if CheckSaveKey then
  begin
    if ShowDialog('Preconfigured Hotkeys', 'Insert Mac Modifiers?' + #10#10 + 'Note: Implementing this layout may overwrite existing macros/remaps.',
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      KeyModified := true;
      SetSaveState(ssModified, SaveStateLighting);

      for i := 0 to keyService.KBLayers.Count - 1 do
      begin
        aLayer := keyService.KBLayers[i];

        //LWIN - ALT
        keyService.SetKBKeyIdx(aLayer, 86, VK_MENU);

        //LALT - LWIN
        keyService.SetKBKeyIdx(aLayer, 87, VK_LWIN);

        //LALT - LWIN
        keyService.SetKBKeyIdx(aLayer, 90, VK_LWIN);

        //RCTRL - ALT
        keyService.SetKBKeyIdx(aLayer, 91, VK_MENU);
      end;
      ReloadKeyButtons;
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMainRGB.SetFreestyle2Hotkeys;
var
  aMacro: TKeyList;
begin
  if CheckSaveKey then
  begin
    if ShowDialog('Preconfigured Hotkeys', 'Insert Freestyle2 Hotkeys?' + #10#10 + 'Note: Implementing this layout may overwrite existing macros/remaps.',
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      aMacro := TKeyList.Create;
      KeyModified := true;
      MacroModified := true;
      SetSaveState(ssModified, SaveStateLighting);

      {$ifdef Win64} //Windows
        //HK1 - lalt + left
        aMacro.Add(keyService.GetKeyWithModifier(VK_LEFT, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 17, aMacro);

        //HK2 - lalt + right
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_RIGHT, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 18, aMacro);

        //HK3 - LCONTROL + Z
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_Z, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 34, aMacro);

        //HK4 - lalt + home
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_HOME, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 35, aMacro);

        //HK5 - lcontrol + x
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_X, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 51, aMacro);

        //HK6 - Del
        keyService.SetKBKeyIdx(keyService.ActiveLayer, 52, VK_DELETE);

        //HK7 - lcontrol + c
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_C, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 67, aMacro);

        //HK8 - lcontrol + v
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_V, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 68, aMacro);
      {$endif}
      {$ifdef Linux}
        //HK1 - lalt + left
        aMacro.Add(keyService.GetKeyWithModifier(VK_LEFT, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 17, aMacro);

        //HK2 - lalt + right
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_RIGHT, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 18, aMacro);

        //HK3 - LCONTROL + Z
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_Z, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 34, aMacro);

        //HK4 - lalt + home
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_HOME, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 35, aMacro);

        //HK5 - lcontrol + x
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_X, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 51, aMacro);

        //HK6 - Del
        keyService.SetKBKeyIdx(keyService.ActiveLayer, 52, VK_DELETE);

        //HK7 - lcontrol + c
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_C, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 67, aMacro);

        //HK8 - lcontrol + v
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_V, GetKeyModifierText(VK_LCONTROL)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 68, aMacro);
      {$endif}
      {$ifdef Darwin}  //MacOS
        //HK0 - LED
        keyService.SetKBKeyIdx(keyService.ActiveLayer, 0, VK_LED);

        //HK1 - lcmd + left
        aMacro.Add(keyService.GetKeyWithModifier(VK_LEFT, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 17, aMacro);

        //HK2 - lcmd + right
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_RIGHT, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 18, aMacro);

        //HK3 - lalt + left
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_LEFT, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 34, aMacro);

        //HK4 - lalt + right
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_RIGHT, GetKeyModifierText(VK_LMENU)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 35, aMacro);

        //HK5 - LWIN + Z
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_Z, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 51, aMacro);

        //HK6 - LWIN + X
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_X, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 52, aMacro);

        //HK7 - LWIN + A
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_A, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 67, aMacro);

        //HK8 - LWIN + C
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_C, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 68, aMacro);

        //LED - LWIN + V
        aMacro.Clear;
        aMacro.Add(keyService.GetKeyWithModifier(VK_V, GetKeyModifierText(VK_LWIN)));
        keyService.SetKeyMacroIdx(keyService.ActiveLayer, 84, aMacro);
      {$endif}

      ReloadKeyButtons;
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMainRGB.SetFreestyleProHotkeys;
var
  aMacro: TKeyList;
begin
  if CheckSaveKey then
  begin
    if ShowDialog('Preconfigured Hotkeys', 'Insert Freestyle Pro Hotkeys?' + #10#10 + 'Note: Implementing this layout may overwrite existing macros/remaps.',
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      aMacro := TKeyList.Create;
      KeyModified := true;
      MacroModified := true;
      SetSaveState(ssModified, SaveStateLighting);

      //HK1 - lwin + d
      aMacro.Add(keyService.GetKeyWithModifier(VK_D, GetKeyModifierText(VK_LWIN)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 17, aMacro);

      //HK2 - lalt + tab
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_TAB, GetKeyModifierText(VK_LMENU)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 18, aMacro);

      //HK3 - LCONTROL + A
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_A, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 34, aMacro);

      //HK4 - lcontrol + Z
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_Z, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 35, aMacro);

      //HK5 - lcontrol + x
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_X, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 51, aMacro);

      //HK6 - Del
      keyService.SetKBKeyIdx(keyService.ActiveLayer, 52, VK_DELETE);

      //HK7 - lcontrol + c
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_C, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 67, aMacro);

      //HK8 - lcontrol + v
      aMacro.Clear;
      aMacro.Add(keyService.GetKeyWithModifier(VK_V, GetKeyModifierText(VK_LCONTROL)));
      keyService.SetKeyMacroIdx(keyService.ActiveLayer, 68, aMacro);

      ReloadKeyButtons;
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMainRGB.SetWorkmanKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey then
  begin
    CloseDialog(mrOk);

    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      aLayer := keyService.KBLayers[i];
      if (aLayer <> nil) and (bothLayers or (layerIdx = i)) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);

        keyService.SetKBKeyIdx(aLayer, 38, VK_D);  //Replace w
        keyService.SetKBKeyIdx(aLayer, 39, VK_R);  //Replace e
        keyService.SetKBKeyIdx(aLayer, 40, VK_W);  //Replace r
        keyService.SetKBKeyIdx(aLayer, 41, VK_B);  //Replace t
        keyService.SetKBKeyIdx(aLayer, 42, VK_J); //Replace y
        keyService.SetKBKeyIdx(aLayer, 43, VK_F); //Replace u
        keyService.SetKBKeyIdx(aLayer, 44, VK_U); //Replace i
        keyService.SetKBKeyIdx(aLayer, 45, VK_P); //Replace o
        keyService.SetKBKeyIdx(aLayer, 46, VK_LCL_SEMI_COMMA); //Replace P
        keyService.SetKBKeyIdx(aLayer, 56, VK_H); //Replace D
        keyService.SetKBKeyIdx(aLayer, 57, VK_T); //Replace F
        keyService.SetKBKeyIdx(aLayer, 59, VK_Y); //Replace H
        keyService.SetKBKeyIdx(aLayer, 60, VK_N); //Replace J
        keyService.SetKBKeyIdx(aLayer, 61, VK_E);  //Replace K
        keyService.SetKBKeyIdx(aLayer, 62, VK_O);  //Replace O
        keyService.SetKBKeyIdx(aLayer, 63, VK_I);  //Replace COLON
        keyService.SetKBKeyIdx(aLayer, 72, VK_M);  //Replace C
        keyService.SetKBKeyIdx(aLayer, 73, VK_C);  //Replace V
        keyService.SetKBKeyIdx(aLayer, 74, VK_V);  //Replace B
        keyService.SetKBKeyIdx(aLayer, 75, VK_K);  //Replace N
        keyService.SetKBKeyIdx(aLayer, 76, VK_L);  //Replace M
      end;
    end;

    if (not bothLayers) then
    begin
      SetActiveLayer(layerIdx);
      swLayerSwitch.Checked := layerIdx = TOPLAYER_IDX;
    end
    else
      LoadLayer(keyService.ActiveLayer);
    RefreshRemapInfo;
    ResetPopupMenu;
    ResetSingleKey;
  end;
end;

procedure TFormMainRGB.setDvorakBothLayers(Sender: TObject);
begin
  SetDvorakKb(0, true);
end;

procedure TFormMainRGB.setDvorakTopLayer(Sender: TObject);
begin
  SetDvorakKb(TOPLAYER_IDX, false);
end;

procedure TFormMainRGB.setDvorakFnLayer(Sender: TObject);
begin
  SetDvorakKb(BOTLAYER_IDX, false);
end;

procedure TFormMainRGB.setColemakBothLayers(Sender: TObject);
begin
  SetColemakKb(0, true);
end;

procedure TFormMainRGB.setColemakTopLayer(Sender: TObject);
begin
  SetColemakKb(TOPLAYER_IDX, false);
end;

procedure TFormMainRGB.setColemakFnLayer(Sender: TObject);
begin
  SetColemakKb(BOTLAYER_IDX, false);
end;

procedure TFormMainRGB.setWorkmanBothLayers(Sender: TObject);
begin
  SetWorkmanKb(0, true);
end;

procedure TFormMainRGB.setWorkmanTopLayer(Sender: TObject);
begin
  SetWorkmanKb(TOPLAYER_IDX, false);
end;

procedure TFormMainRGB.setWorkmanFnLayer(Sender: TObject);
begin
  SetWorkmanKb(BOTLAYER_IDX, false);
end;

procedure TFormMainRGB.SetDvorakKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey then
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
      LoadLayer(keyService.ActiveLayer);
    RefreshRemapInfo;
    ResetPopupMenu;
    ResetSingleKey;
  end;
end;

procedure TFormMainRGB.SetColemakKb(layerIdx: integer; bothLayers: boolean);
var
  aLayer: TKBLayer;
  i: integer;
begin
  if CheckSaveKey then
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
      LoadLayer(keyService.ActiveLayer);
    RefreshRemapInfo;
    ResetPopupMenu;
    ResetSingleKey;
  end;
end;

function TFormMainRGB.GetCursorNextKey(cursorPos: integer): integer;
var
  i:integer;
  keyIdx: integer;
  newKeyIdx: integer;
begin
  result := -1;
  if (IsKeyLoaded and EditingMacro and (cursorPos < LengthUTF8(memoMacro.Text))) then
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

function TFormMainRGB.GetCursorPrevKey(cursorPos: integer): integer;
var
  i:integer;
  keyIdx: integer;
  prevKeyIdx: integer;
begin
  result := -1; //cursorPos - 1;
  if (IsKeyLoaded and EditingMacro and (cursorPos > 1)) then
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

function TFormMainRGB.CanAssignMacro: boolean;
begin
  result := IsKeyLoaded;

  if (IsKeyLoaded) and not(activeKbKey.CanAssignMacro) then
  begin
    result := false;
    ShowDialog('Macro', 'You cannot assign a macro to this key.', mtWarning, [mbOK]);
  end
  else if (IsKeyLoaded) and (activeKbKey.TapAndHold) then
  begin
    result := false;
    ShowDialog('Macro', 'You cannot assign a macro to a Tap and Hold action key.', mtWarning, [mbOK]);
  end
end;

procedure TFormMainRGB.SetModifiedKey(key: word; Modifiers: string;
  isMacro: boolean; bothLayers: boolean; force: boolean; overwriteTapHold: boolean);
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
  nbKeystrokes: integer;
begin
  if (ConfigMode = CONFIG_LAYOUT) and (IsKeyLoaded) then
  begin
    if (isMacro) and (EditingMacro) then
    begin
      if (CanAssignMacro) then
      begin
        nbKeystrokes := keyService.CountKeystrokes(activeKbKey.ActiveMacro);
        inc(nbKeystrokes);
        nbKeystrokes := nbKeystrokes + (keyService.CountModifiers(Modifiers) * 2);
        if (nbKeystrokes > MAX_KEYSTROKES_MACRO_FS) then
          ShowDialog('Maximum Length Reached', 'Macros are limited to approximately 300 characters.',
            mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
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
            textKey := StringReplace(textKey, ' ', UnicodeString(#$e2#$90#$a3), [rfReplaceAll]);
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
      end;
    end
    else if (not MacroModified) then //and (RemapMode or force) then
    begin
      isDiffKey := (activeKbKey.IsModified and (activeKbKey.ModifiedKey.Key <> key)) or
        ((not activeKbKey.IsModified) and (activeKbKey.OriginalKey.Key <> key));

      //Checks if key is really modified
      if (isDiffKey) then
      begin
        KeyModified := true;
        SetSaveState(ssModified, SaveStateLighting);
        keyService.SetKBKey(activeKbKey, key, overwriteTapHold);
        if (bothLayers) then
        begin
          aKbKeyOtherLayer := GetKeyOtherLayer(activeKeyBtn.Index);
          if aKbKeyOtherLayer <> nil then
            keyService.SetKBKey(aKbKeyOtherLayer, key, overwriteTapHold);
        end;
        UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
      end;
    end;
  end;
end;

procedure TFormMainRGB.MenuButtonClick(Sender: TObject);
//var
//  aButton: THSSpeedButton;
begin
  //aButton := (sender as THSSpeedButton);
  //menuActionList;
  //if (currentMenuAction <> nil) and (currentMenuAction.ActionButton = aButton) then
  //  SetCurrentMenuAction(nil, nil)
  //else
  //begin
  //  SetCurrentMenuAction(aButton, nil);
  //  if (ConfigMode = CONFIG_LIGHTING) then
  //  begin
  //    SetLedMode(GetLedMode);
  //    SetSaveState(SaveStateLayout, ssModified);
  //  end;
  //end;
  //
  //UpdateMenu;
end;


procedure TFormMainRGB.MenuLabelClick(Sender: TObject);
var
  aLabel: TLabel;
begin
  aLabel := (sender as TLabel);
  //if (currentMenuAction <> nil) and (currentMenuAction.ActionLabel = aLabel) then
  //  SetCurrentMenuAction(nil, nil)
  //else
  //begin
    SetCurrentMenuAction(maNone, aLabel);
    if (ConfigMode = CONFIG_LIGHTING) then
    begin
      SetLedMode(GetLedMode);
      SetSaveState(SaveStateLayout, ssModified);
    end;
  //end;
  //if (aButton.Down) then
  //  currentMenuAction := aButton
  //else
  //  currentMenuAction := nil;
  //
  //UpdateMenu;
  //IF (aLabel = lblMedia) THEN
end;

procedure TFormMainRGB.SingleKeyLabelClick(Sender: TObject);
var
  aLabel: TLabel;
  aMenuAction: TMenuAction;
  wasDown: boolean;
begin
  aLabel := (sender as TLabel);
  aMenuAction := GetMenuActionByLabel(aLabel.Name);
  if (IsKeyLoaded or not(aMenuAction.MustSelectKey)) then
  begin
    wasDown := (aMenuAction.ActionButton <> nil) and aMenuAction.ActionButton.Down;
    ResetPopupMenu;
    ResetSingleKey;
    SetSingleKey(aMenuAction, wasDown);
  end;
end;

procedure TFormMainRGB.SingleKeyMenuClick(Sender: TObject);
var
  //aButton: THSSpeedButton;
  aImage: TImage;
  aMenuAction: TMenuAction;
  wasDown: boolean;
begin
  aImage := (sender as TImage);
  aMenuAction := GetMenuActionByImage(aImage.Name);
  if (IsKeyLoaded or not(aMenuAction.MustSelectKey)) then
  begin
    wasDown := (aMenuAction.ActionButton <> nil) and aMenuAction.ActionButton.Down;
    ResetPopupMenu;
    ResetSingleKey;
    SetSingleKey(aMenuAction, wasDown);
  end;
end;

procedure TFormMainRGB.SetSingleKey(aMenuAction: TMenuAction; wasDown: boolean);
begin
  if (IsKeyLoaded) then
  begin
    if (aMenuAction.ActionType = maDisable) then
      SetModifiedKey(VK_NULL, '', false, false, true, true)
    else if (aMenuAction.ActionType = maBacklight) then
      SetModifiedKey(VK_LED, '', false, false, true, true)
    else if (aMenuAction.ActionType = maDisableLed) then
      SetModifiedKey(VK_LED, '', false, false, true, true);
    ResetSingleKey;
  end
  else
  begin
    //ShowDialog('Remap', 'You must select a key on the keyboard', mtWarning, [mbOK]);
    //if (wasDown) then
    //  ResetSingleKey
    //else
    //begin
    //  aMenuAction.ActionButton.Down := true;
    //  aMenuAction.ActionLabel.Font.Color := KINESIS_BLUE_EDGE;
    //end;
  end;
  //else
 //   ShowDialog('Remap', 'You must select a key on the keyboard', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
end;

procedure TFormMainRGB.PopupMenuClick(Sender: TObject);
var
  //aButton: THSSpeedButton;
  aImage: TImage;
  aMenuAction: TMenuAction;
begin
  //aButton := (sender as THSSpeedButton);
  //aMenuAction := GetMenuActionByButton(aButton.Name);
  aImage := (sender as TImage);
  aMenuAction := GetMenuActionByImage(aImage.Name);
  if (IsKeyLoaded or not(aMenuAction.MustSelectKey)) then
    SetMenuItems(aMenuAction);
  //aButton.Down := false;
end;

procedure TFormMainRGB.PopupLabelClick(Sender: TObject);
var
  aLabel: TLabel;
  aMenuAction: TMenuAction;
begin
  aLabel := (sender as TLabel);
  aMenuAction := GetMenuActionByLabel(aLabel.Name);
  if (IsKeyLoaded or not(aMenuAction.MustSelectKey)) then
    SetMenuItems(aMenuAction);
end;

procedure TFormMainRGB.UpdateMenu;
begin
  lblRemap.Font.Color := KINESIS_FONT_COLOR_RGB;
  lblMacro.Font.Color := KINESIS_FONT_COLOR_RGB;
  lblMedia.Font.Color := KINESIS_FONT_COLOR_RGB;

  //if (currentMenuButton = btnRemap) then
  //  lblRemap.Font.Color := KINESIS_BLUE_EDGE
  //else if (currentMenuButton = btnMacro) then
  //  lblMacro.Font.Color := KINESIS_BLUE_EDGE
  //else if (currentMenuButton = btnMedia) then
  //  lblMedia.Font.Color := KINESIS_BLUE_EDGE;
end;

//Macro section

procedure TFormMainRGB.OpenMacroEditor;
begin
  //if IsKeyLoaded then
  //begin
  if (IsKeyLoaded and activeKbKey.TapAndHold) then
  begin
    ShowDialog('Tap and Hold', 'You cannot assign a macro to a Tap and Hold action key.',
      mtWarning, [mbOk], DEFAULT_DIAG_HEIGHT_RGB);
  end;

  if (not EditingMacro) then
  begin
    LoadButtonImage(imgMacro, imgListProfileMenu, 0);
    SetWindowsCombo(false);
    pnlMacro.Visible := true;
    pnlMacro.Left := imgKeyboardLayout.Left + imgKeyboardLayout.Width - pnlMacro.Width;
    //pnlMacro.Top := pnlEffectColor.Top;//FormMainRGB.Height - pnlMacro.Height - 50;
    lblMacro.Font.Color := KINESIS_BLUE_EDGE;
    {$ifdef Win64}
    //causes bug with Cocoa osx
    pnlMacro.BringToFront;
    {$endif}
    if (IsKeyLoaded) and not(activeKbKey.TapAndHold) then
      memoMacro.SetFocus;
  end;
  keyService.BackupMacroKey(activeKbKey);

  rgMacro1.Checked := true;
  memoMacro.Text := '';
  LoadMacro;
  SetMacroText(true);
  //end
  //else
  //begin
  //  pnlMacro.Visible := false;
  //  ShowDialog('Macro', 'You must select a key on the keyboard', mtWarning, [mbOK]);
  //end;
end;

procedure TFormMainRGB.LoadMacro;
begin
  loadingMacro := true;
  ResetMacroCoTriggers;
  lastKeyDown := 0; //Resets last key down
  lastKeyPressed := 0; //Resets last key pressed
  keyService.ClearModifiers; //Removes all modifiers from memory
  if (WindowsComboOn) then
    SetWindowsCombo(true);

  if (IsKeyLoaded) then
  begin
    if (rgMacro1.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro1
    else if (rgMacro2.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro2
    else if (rgMacro3.Checked) then
      activeKbKey.ActiveMacro := activeKbKey.Macro3;

    chkGlobalSpeed.Checked := activeKbKey.ActiveMacro.MacroSpeed = 0;
    if (activeKbKey.ActiveMacro.MacroSpeed >= MACRO_SPEED_MIN_RGB) and (activeKbKey.ActiveMacro.MacroSpeed <= MACRO_SPEED_MAX_RGB) then
    begin
      sliderMacroSpeed.Position := activeKbKey.ActiveMacro.MacroSpeed;
    end
    else
    begin
      sliderMacroSpeed.Position := DEFAULT_MACRO_SPEED_RGB;
    end;
    sliderMacroSpeedChange(self);

    chkRepeatMultiplay.Checked := activeKbKey.ActiveMacro.MacroRptFreq = 0;
    if (activeKbKey.ActiveMacro.MacroRptFreq >= MACRO_FREQ_MIN_RGB) and (activeKbKey.ActiveMacro.MacroRptFreq <= MACRO_FREQ_MAX_RGB) then
    begin
      sliderMultiplay.Position := activeKbKey.ActiveMacro.MacroRptFreq
    end
    else
    begin
      sliderMultiplay.Position := DEFAULT_MACRO_FREQ_RGB;
    end;
    sliderMultiplayChange(self);

    if activeKbKey.Macro1.Count > 0 then
      lblMacro1.Font.Color := activeColor
    else
    begin
      lblMacro1.Font.Color := fontColor;
      activeKbKey.Macro1.CoTrigger1 := nil;
    end;
    if activeKbKey.Macro2.Count > 0 then
      lblMacro2.Font.Color := activeColor
    else
    begin
      lblMacro2.Font.Color := fontColor;
      activeKbKey.Macro2.CoTrigger1 := nil;
    end;
    if activeKbKey.Macro3.Count > 0 then
      lblMacro3.Font.Color := activeColor
    else
    begin
      lblMacro3.Font.Color := fontColor;
      activeKbKey.Macro3.CoTrigger1 := nil;
    end;

    SetCoTrigger(activeKbKey.ActiveMacro.CoTrigger1);
    SetMacroAssignTo;
  end;

  loadingMacro := false;
end;

procedure TFormMainRGB.rgMacroClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
  begin
    SetWindowsCombo(false);
    LoadMacro;
    SetMacroText(true);
  end;
end;

procedure TFormMainRGB.SetCoTrigger(aKey: TKey);
begin
  if (aKey <> nil) then
  begin
    if (aKey.Key = VK_LSHIFT) then
      ActivateCoTrigger(btnLeftShift);
    if (aKey.Key = VK_LCONTROL) then
      ActivateCoTrigger(btnLeftCtrl);
    if (aKey.Key = VK_LMENU) then
      ActivateCoTrigger(btnLeftAlt);
    if (aKey.Key = VK_RSHIFT) then
      ActivateCoTrigger(btnRightShift);
    if (aKey.Key = VK_RCONTROL) then
      ActivateCoTrigger(btnRightCtrl);
    if (aKey.Key = VK_RMENU) then
      ActivateCoTrigger(btnRightAlt);
  end;
  //if (aKey <> nil) then
  //begin
  //  if (aKey.Key = VK_LSHIFT) then
  //    ActivateCoTrigger(kbLeftShift);
  //  if (aKey.Key = VK_LCONTROL) then
  //    ActivateCoTrigger(kbLeftCtrl);
  //  if (aKey.Key = VK_LMENU) then
  //    ActivateCoTrigger(kbLeftAlt);
  //  if (aKey.Key = VK_RSHIFT) then
  //    ActivateCoTrigger(kbRightShift);
  //  if (aKey.Key = VK_RCONTROL) then
  //    ActivateCoTrigger(kbRightCtrl);
  //  if (aKey.Key = VK_RMENU) then
  //    ActivateCoTrigger(kbRightAlt);
  //end;
end;

procedure TFormMainRGB.ActivateCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BorderWidth := 1;
  keyButton.BorderColor := activeColor;
  keyButton.BorderStyle := bsSingle;
  keyButton.Repaint;
end;

procedure TFormMainRGB.ActivateCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
begin
  //coTriggerBtn.Down := true;
  coTriggerBtn.HelpKeyword := 'DOWN';
  //coTriggerBtn.Font.Bold := true;
  //coTriggerBtn.Font.Color := activeColor;
  SetHovered(coTriggerBtn, true);
  SetMacroAssignTo;
end;

procedure TFormMainRGB.SetMacroAssignTo;
var
  keyAssigned: string;
begin
  if (activeKbKey <> nil) then
  begin
    if activeKbKey.ActiveMacro.CoTrigger1 <> nil then
      keyAssigned := activeKbKey.ActiveMacro.CoTrigger1.OtherDisplayText + ' + ' + activeKbKey.OriginalKey.OtherDisplayText
    else
      keyAssigned := activeKbKey.OriginalKey.OtherDisplayText;
  end;
  if (keyAssigned <> '') and (keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX) then
    keyAssigned := 'Fn Layer ' + keyAssigned;

  if (keyAssigned <> '') then
    pnlAssignMacro.Caption := 'Assign to ' + keyAssigned
  else
    pnlAssignMacro.Caption := '';
end;

//Resets co-trigger buttons to default values
procedure TFormMainRGB.ResetMacroCoTriggers;
begin
  //ResetCoTrigger(kbLeftShift);
  //ResetCoTrigger(kbRightShift);
  //ResetCoTrigger(kbLeftCtrl);
  //ResetCoTrigger(kbRightCtrl);
  //ResetCoTrigger(kbLeftAlt);
  //ResetCoTrigger(kbRightAlt);
  ResetCoTrigger(btnLeftShift);
  ResetCoTrigger(btnRightShift);
  ResetCoTrigger(btnLeftAlt);
  ResetCoTrigger(btnRightAlt);
  ResetCoTrigger(btnLeftCtrl);
  ResetCoTrigger(btnRightCtrl);
end;

procedure TFormMainRGB.ResetCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BackColor := clNone;
  keyButton.BorderColor := clNone;
  keyButton.BorderStyle := bsNone;
  keyButton.Repaint;
end;

procedure TFormMainRGB.ResetCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
begin
  //coTriggerBtn.Down := false;
  coTriggerBtn.HelpKeyword := '';
  SetHovered(coTriggerBtn, false, true);
  //coTriggerBtn.Font.Bold := true;
  //if (GApplication = APPL_FSPRO) then
  //  coTriggerBtn.Font.Color := KINESIS_DARK_GRAY_FS
  //else
  //  coTriggerBtn.Font.Color := clBlack;
end;

function TFormMainRGB.GetCoTriggerKey(Sender: TObject): TKey;
begin
  if (Sender = btnLeftShift) then
    result := keyService.FindKeyConfig(VK_LSHIFT)
  else if (Sender = btnRightShift) then
    result := keyService.FindKeyConfig(VK_RSHIFT)
  else if (Sender = btnLeftCtrl) then
    result := keyService.FindKeyConfig(VK_LCONTROL)
  else if (Sender = btnRightCtrl) then
    result := keyService.FindKeyConfig(VK_RCONTROL)
  else if (Sender = btnLeftAlt) then
    result := keyService.FindKeyConfig(VK_LMENU)
  else if (Sender = btnRightAlt) then
    result := keyService.FindKeyConfig(VK_RMENU)
  else
    result := nil;
  //if (Sender = kbLeftShift) then
  //  result := keyService.FindKeyConfig(VK_LSHIFT)
  //else if (Sender = kbRightShift) then
  //  result := keyService.FindKeyConfig(VK_RSHIFT)
  //else if (Sender = kbLeftCtrl) then
  //  result := keyService.FindKeyConfig(VK_LCONTROL)
  //else if (Sender =  kbRightCtrl) then
  //  result := keyService.FindKeyConfig(VK_RCONTROL)
  //else if (Sender = kbLeftAlt) then
  //  result := keyService.FindKeyConfig(VK_LMENU)
  //else if (Sender = kbRightAlt) then
  //  result := keyService.FindKeyConfig(VK_RMENU)
  //else
  //  result := nil;
end;

procedure TFormMainRGB.RemoveCoTrigger(key: word);
begin
  if IsKeyLoaded then
  begin
    MacroModified := true;
    if (activeKbKey.ActiveMacro.CoTrigger1 <> nil) and (activeKbKey.ActiveMacro.CoTrigger1.Key = key) then
      activeKbKey.ActiveMacro.CoTrigger1 := nil;

    SetMacroAssignTo;
  end;
end;

procedure TFormMainRGB.btnCopyClick(Sender: TObject);
var
  hideNotif: integer;
begin
  if (IsKeyLoaded) then
  begin
    ResetPopupMenuMacro;
    if (activeKbKey.ActiveMacro <> nil) then
    begin
      copiedMacro := keyService.CopyMacro(activeKbKey.ActiveMacro);
      if (ShowNotification(fileService.AppSettings.CopyMacroMsg)) then
      begin
        hideNotif := ShowDialog('Copy', 'Macro copied. Now select a new trigger key or load a new layout, then hit Paste.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetCopyMacroMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
    end
    else
      ShowDialog('Copy Macro', 'You must have an active maro to copy', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnPasteClick(Sender: TObject);
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
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnBackspaceMacroClick(Sender: TObject);

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
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.btnClearMacroClick(Sender: TObject);
begin
  if (IsKeyLoaded) and (activeKbKey.IsMacro) then
  begin
    ResetPopupMenuMacro;
    memoMacro.Lines.Clear;
    keyService.ClearModifiers;
    if (WindowsComboOn) then
      SetWindowsCombo(true);
    activeKbKey.ActiveMacro.Clear;
    activeKbKey.ActiveMacro.CoTrigger1 := nil;
    ResetMacroCoTriggers;
    MacroModified := true;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainRGB.knobMultiplayChange(Sender: TObject);
var
  value: integer;
begin
  value := Round(knobMultiplay.Position);
  if (value = 0) then
    lblMultiplayText.Caption := 'R'
  else
    lblMultiplayText.Caption := IntToStr(value);
end;

procedure TFormMainRGB.knobMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingMacro) and IsKeyLoaded then
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

procedure TFormMainRGB.knobMacroSpeedChange(Sender: TObject);
var
  value: integer;
begin
  value := Round(knobMacroSpeed.Position);
  if (value = 0) then
    lblMacroSpeedText.Caption := 'G'
  else
    lblMacroSpeedText.Caption := IntToStr(value);
end;

procedure TFormMainRGB.knobMacroSpeedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingMacro) and IsKeyLoaded then
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

procedure TFormMainRGB.KBCoTriggerClick(Sender: TObject);
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

      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
      begin
        activeKbKey.ActiveMacro.CoTrigger1 := aKey.CopyKey;
        MacroModified := true;
      end;
      ActivateCoTrigger(button);
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

procedure TFormMainRGB.SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
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

procedure TFormMainRGB.SetMacroText(pushCursorToEnd: boolean; cursorPos: integer = -1);
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
    memoMacro.Text := StringReplace(memoMacro.Text, ' ', UnicodeString(#$e2#$90#$a3), [rfReplaceAll]);
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
  end
  else
    textMacroInput.Visible := IsKeyLoaded;
end;

procedure TFormMainRGB.SetWindowsCombo(value: boolean);
var
  hideNotif: integer;
begin
  value := value and EditingMacro;

  WindowsComboOn := value;
  if not value then
  begin
    keyService.RemoveModifier(VK_LWIN);
    keyService.RemoveModifier(VK_RWIN);
    btnWindowsCombos.Down := false;
    SetHovered(btnWindowsCombos, false, true);
  end
  else
  begin
    btnWindowsCombos.Down := true;
    SetHovered(btnWindowsCombos, true, true);
    keyService.AddModifier(VK_LWIN);
    if (ShowNotification(fileService.AppSettings.WindowsComboMsg)) then
    begin
      hideNotif := ShowDialog('Windows Combination Active', 'Now press the key(s) you wish to combine with the Windows key in your macro. Then deselect Windows Combination from the Special Actions menu if you wish to continue programming or click Accept.',
        mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB, nil, 'Hide this notification?');

      if (hideNotif >= DISABLE_NOTIF) then
      begin
        fileService.SetWindowsComboMsg(true);
        fileService.SaveAppSettings;
      end;
    end;

    memoMacro.SetFocus;
  end;
end;

procedure TFormMainRGB.MoveComponents(leftIdx: integer; pixels: integer);
begin
//var
//  i: integer;
//  component: TControl;
//begin
//  for i := 0 to Self.ComponentCount - 1 do
//  begin
//    if (Self.Components[i] is TControl) and
//    //((Self.Components[i] as TControl).Parent <> pnlTop) and
//    (Self.Components[i] <> btnMinimize) and
//    (Self.Components[i] <> btnMaximize) and
//    (Self.Components[i] <> btnClose) and
//    (Self.Components[i] <> lblBottomInfo) and
//    (Self.Components[i] <> imgSmartSet1) and
//    (Self.Components[i] <> imgSmartSet2)
//    then
//    begin
//      component := (Self.Components[i] as TControl);
//      if (component.Left >= leftIdx) then
//        component.Left := component.Left + pixels;
//    end;
//  end;
end;

procedure TFormMainRGB.openFirwareWebsite(Sender: TObject);
begin
  OpenUrl(RGB_FIRMWARE);
end;

procedure TFormMainRGB.SetHovered(obj: TObject; hovered: boolean;
  forceNormal: boolean);
var
  i:integer;
  hoveredObj: THoveredObj;
  stayHovered: boolean;
begin
  for i := 0 to hoveredList.Count - 1 do
  begin
    hoveredObj := (hoveredList.Items[i] as THoveredObj);
    if hoveredObj.Obj = obj then
    begin
      stayHovered := false;

      //Check if button is down if setting back to normal
      if (obj is TColorSpeedButtonCS) and not(forceNormal) then
        stayHovered := ((obj as TColorSpeedButtonCS).Down) or ((obj as TColorSpeedButtonCS).HelpKeyword = 'DOWN');

      if (hovered or stayHovered) then
        LoadButtonImage(hoveredObj.Obj, hoveredObj.ImgList, hoveredObj.HoveredIdx)
      else
        LoadButtonImage(hoveredObj.Obj, hoveredObj.ImgList, hoveredObj.NormalIdx);

      break;
    end;
  end;
end;

procedure TFormMainRGB.SetMousePosition(x, y: integer);
var
  MousePos: TPoint;
begin
  MousePos.X := Mouse.CursorPos.x; //self.Left + x;
  MousePos.Y := Mouse.CursorPos.y + 20; //self.Top + y;
  Mouse.CursorPos := MousePos;
end;

procedure TFormMainRGB.ObjectMouseEnter(Sender: TObject);
begin
  SetHovered(sender, true);
end;

procedure TFormMainRGB.ObjectMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  SetHovered(sender, true);
end;

procedure TFormMainRGB.ObjectMouseExit(Sender: TObject);
begin
  SetHovered(sender, false);
end;

//End macro section

procedure TFormMainRGB.ReturnToHome;
begin
  (parentForm as TFormDashboard).ResetToHome;
end;

initialization
  //{$I waveRes.lrs}
  //{$I reactiveRes.lrs}
  //{$I spectrumRes.lrs}
  //{$I startlightRes.lrs}
  //{$I reboundRes.lrs}
  //{$I loopRes.lrs}
  //{$I rainRes.lrs}

end.

