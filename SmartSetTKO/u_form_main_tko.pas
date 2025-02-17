unit u_form_main_tko;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, uGifViewer, ECSwitch, ECSlider, u_const, ColorSpeedButtonCS, LineObj,
  LabelBox, RichMemo, HSLRingPicker, mbColorPreview, ueled, uEKnob, u_form_tapandhold, contnrs,
  u_key_layer, u_key_service, u_file_service, u_common_ui, U_Keys, UserDialog,
  FileUtil, u_form_intro, u_form_troubleshoot, u_form_settings, u_gif, LCLIntf,
  u_form_export, Types, u_form_about, buttons, u_form_diagnostics, LazFileUtils,
  u_form_firmware, u_form_timingdelays, LResources, lcltype, BGRABitmap,
  BGRABitmapTypes, BGRAGradients, BGRAGradientScanner
  {$ifdef Win64},Windows{$endif};

type

  { TFormMainTKO }

  TFormMainTKO = class(TForm)
    BreatheTimer: TIdleTimer;
    btnAltLayouts: TColorSpeedButtonCS;
    btnFrozenWave: TColorSpeedButtonCS;
    btnZoneAllKeys: TColorSpeedButtonCS;
    btnZoneNavKeys: TColorSpeedButtonCS;
    btnZoneNumberRow: TColorSpeedButtonCS;
    btnZoneModifiers: TColorSpeedButtonCS;
    btnZoneHomeRow: TColorSpeedButtonCS;
    btnZoneArrowKeys: TColorSpeedButtonCS;
    btnZoneFunctionKeys: TColorSpeedButtonCS;
    btnZoneWASDKeys: TColorSpeedButtonCS;
    btnZoneHyperspace: TColorSpeedButtonCS;
    btnPulseEdge: TColorSpeedButtonCS;
    btnPulse: TColorSpeedButtonCS;
    btnEject: TColorSpeedButtonCS;
    btnSpectrumEdge: TColorSpeedButtonCS;
    btnWaveEdge: TColorSpeedButtonCS;
    btnFreestyleEdge: TColorSpeedButtonCS;
    btnBreatheEdge: TColorSpeedButtonCS;
    btnReboundEdge: TColorSpeedButtonCS;
    btnMonochromeEdge: TColorSpeedButtonCS;
    btnDisableEdge: TColorSpeedButtonCS;
    btnLoopEdge: TColorSpeedButtonCS;
    btnHyperspaceConfigs: TColorSpeedButtonCS;
    btnLoop: TColorSpeedButtonCS;
    btnRain: TColorSpeedButtonCS;
    btnDisable: TColorSpeedButtonCS;
    btnStarlight: TColorSpeedButtonCS;
    btnMultimodifiers: TColorSpeedButtonCS;
    btnMacModifiers: TColorSpeedButtonCS;
    btnRipple: TColorSpeedButtonCS;
    btnFireball: TColorSpeedButtonCS;
    btnSpecialActions: TColorSpeedButtonCS;
    btnDisableKey: TColorSpeedButtonCS;
    btnReactive: TColorSpeedButtonCS;
    btnRebound: TColorSpeedButtonCS;
    btnTapAndHold: TColorSpeedButtonCS;
    btnMacroOff: TColorSpeedButtonCS;
    btnBacklight: TColorSpeedButtonCS;
    btnWave: TColorSpeedButtonCS;
    btnFreestyle: TColorSpeedButtonCS;
    btnMonochrome: TColorSpeedButtonCS;
    btnBreathe: TColorSpeedButtonCS;
    btnSpectrum: TColorSpeedButtonCS;
    btnZoneMediaKeys: TColorSpeedButtonCS;
    imgKeyboardEdge: TImage;
    imgEdgeBack: TImage;
    imgListSave: TImageList;
    lbEdgeB1: TLabelBox;
    lbEdgeB15: TLabelBox;
    lbEdgeB2: TLabelBox;
    lbEdgeB3: TLabelBox;
    lbEdgeB4: TLabelBox;
    lbEdgeB5: TLabelBox;
    lbEdgeB6: TLabelBox;
    lbEdgeB7: TLabelBox;
    lbEdgeB8: TLabelBox;
    lbEdgeB9: TLabelBox;
    lbEdgeB10: TLabelBox;
    lbEdgeB11: TLabelBox;
    lbEdgeB12: TLabelBox;
    lbEdgeB13: TLabelBox;
    lbEdgeB14: TLabelBox;
    lbEdgeR9: TLabelBox;
    lbEdgeR8: TLabelBox;
    lbEdgeR7: TLabelBox;
    lbEdgeR6: TLabelBox;
    lbEdgeR5: TLabelBox;
    lbEdgeR4: TLabelBox;
    lbEdgeR3: TLabelBox;
    lbEdgeR2: TLabelBox;
    lbEdgeR1: TLabelBox;
    lbEdgeL3: TLabelBox;
    lbEdgeL4: TLabelBox;
    lbEdgeL5: TLabelBox;
    lbEdgeL6: TLabelBox;
    lbEdgeL1: TLabelBox;
    lbEdgeL2: TLabelBox;
    lbEdgeL7: TLabelBox;
    lbEdgeL8: TLabelBox;
    lbEdgeL9: TLabelBox;
    pnlEdgeLighting: TPanel;
    SpectrumTimer: TIdleTimer;
    btnBackspaceMacro: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    btnCancelMacro: TColorSpeedButtonCS;
    btnClearMacro: TColorSpeedButtonCS;
    btnCloseMacro: TColorSpeedButtonCS;
    btnCommonShortcuts: TColorSpeedButtonCS;
    btnCopy: TColorSpeedButtonCS;
    btnDiagnostic: TColorSpeedButtonCS;
    btnDirDown: TColorSpeedButtonCS;
    btnDirHorizontal: TColorSpeedButtonCS;
    btnDirLeft: TColorSpeedButtonCS;
    btnDirRight: TColorSpeedButtonCS;
    btnDirUp: TColorSpeedButtonCS;
    btnDirVertical: TColorSpeedButtonCS;
    btnDisableLed: TColorSpeedButtonCS;
    btnDone: TColorSpeedButtonCS;
    btnDoneMacro: TColorSpeedButtonCS;
    btnExport: TColorSpeedButtonCS;
    btnFirmware: TColorSpeedButtonCS;
    btnFnAccess: TColorSpeedButtonCS;
    btnFullKeypad: TColorSpeedButtonCS;
    btnKeypadActions: TColorSpeedButtonCS;
    btnHelp: TColorSpeedButtonCS;
    btnImport: TColorSpeedButtonCS;
    btnLeftAlt: TColorSpeedButtonCS;
    btnLeftCtrl: TColorSpeedButtonCS;
    btnLeftShift: TColorSpeedButtonCS;
    btnMouseClicks: TColorSpeedButtonCS;
    btnFunctionKeys: TColorSpeedButtonCS;
    btnMouseClicksMacro: TColorSpeedButtonCS;
    btnPaste: TColorSpeedButtonCS;
    btnResetAll: TColorSpeedButtonCS;
    btnResetKey: TColorSpeedButtonCS;
    btnMacro: TColorSpeedButtonCS;
    btnMultimedia: TColorSpeedButtonCS;
    btnRightAlt: TColorSpeedButtonCS;
    btnRightCtrl: TColorSpeedButtonCS;
    btnRightShift: TColorSpeedButtonCS;
    btnSave: TColorSpeedButtonCS;
    btnSaveAs: TColorSpeedButtonCS;
    btnSettings: TColorSpeedButtonCS;
    btnTimingDelays: TColorSpeedButtonCS;
    btnWindowsCombos: TColorSpeedButtonCS;
    CheckVDriveTmr: TIdleTimer;
    chkGlobalSpeed: TCheckBox;
    chkRepeatMultiplay: TCheckBox;
    ColorDialog1: TColorDialog;
    colorPreview: TmbColorPreview;
    colorPreviewBase: TmbColorPreview;
    custColor1: TmbColorPreview;
    custColor10: TmbColorPreview;
    custColor11: TmbColorPreview;
    custColor12: TmbColorPreview;
    custColor2: TmbColorPreview;
    custColor3: TmbColorPreview;
    custColor4: TmbColorPreview;
    custColor5: TmbColorPreview;
    custColor6: TmbColorPreview;
    custColor7: TmbColorPreview;
    custColor8: TmbColorPreview;
    custColor9: TmbColorPreview;
    eBlue: TEdit;
    eBlueBase: TEdit;
    eGreen: TEdit;
    eGreenBase: TEdit;
    eHTML: TEdit;
    eHTMLBase: TEdit;
    eRed: TEdit;
    eRedBase: TEdit;
    gifViewer: TGIFViewer;
    imageKnob: TImage;
    imageKnobBig: TImage;
    imgBackground: TImage;
    imgKeyboardBack: TImage;
    imgKeyboardLayout: TImage;
    imgKeyboardLighting: TImage;
    imgListDirection: TImageList;
    imgListMacro: TImageList;
    imgListMacroActions: TImageList;
    imgListMenu: TImageList;
    imgListMiniIcons: TImageList;
    imgListProfileDefault: TImageList;
    imgListProfileHover: TImageList;
    imgListProfileMenu: TImageList;
    imgListSettings: TImageList;
    imgListTriggers: TImageList;
    imgListZone: TImageList;
    imgProfile: TImage;
    imgSmartSet1: TImage;
    imgSmartSet2: TImage;
    knobSpeed: TuEKnob;
    Label11: TLabel;
    Label12: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblBaseColor: TLabel;
    lblBColor: TLabel;
    lblBColor1: TLabel;
    lblBottomInfo: TLabel;
    lblColor: TLabel;
    lblCoTrigger: TLabel;
    lblCustomColors: TLabel;
    lblCustomColors1: TLabel;
    lblDirection: TLabel;
    lblDisableMacro: TLabel;
    lblDisplaying2: TLabel;
    lblGColor: TLabel;
    lblGColor1: TLabel;
    lblGlobal: TLabel;
    lblGlobalSpeed: TLabel;
    lblMacro1: TLabel;
    lblMacro2: TLabel;
    lblMacro3: TLabel;
    lblMacroEditor: TLabel;
    lblMacroInfo: TLabel;
    lblMacroSpeedText: TLabel;
    lblMultiplay: TLabel;
    lblMultiplayText: TLabel;
    lblPlaybackSpeed: TLabel;
    lblPreMixedColors: TLabel;
    lblPreMixedColors1: TLabel;
    lblRColor: TLabel;
    lblRColor1: TLabel;
    lblRepeatMultiplay: TLabel;
    lblSpeed: TLabel;
    lblSpeed1: TLabel;
    lblSpeed2: TLabel;
    lblSpeedText: TLabel;
    lblZone: TLabel;
    lbMenu: TListBox;
    lbMenuMacro: TListBox;
    lbProfile: TListBox;
    lbRow1_11: TLabelBox;
    lbRow2_13: TLabelBox;
    lbRow3_13: TLabelBox;
    lbRow4_12: TLabelBox;
    lbRow5_10: TLabelBox;
    lbRow5_9: TLabelBox;
    lbRow1_12: TLabelBox;
    lbRow2_14: TLabelBox;
    lbRow1_13: TLabelBox;
    lbRow1_14: TLabelBox;
    lbRow1_1: TLabelBox;
    lbRow2_1: TLabelBox;
    lbRow3_1: TLabelBox;
    lbRow4_1: TLabelBox;
    lbRow5_1: TLabelBox;
    lbRow2_2: TLabelBox;
    lbRow3_2: TLabelBox;
    lbRow4_2: TLabelBox;
    lbRow5_2: TLabelBox;
    lbRow1_2: TLabelBox;
    lbRow2_3: TLabelBox;
    lbRow3_3: TLabelBox;
    lbRow4_3: TLabelBox;
    lbRow5_3: TLabelBox;
    lbRow1_3: TLabelBox;
    lbRow1_4: TLabelBox;
    lbRow2_4: TLabelBox;
    lbRow2_5: TLabelBox;
    lbRow3_4: TLabelBox;
    lbRow3_5: TLabelBox;
    lbRow4_4: TLabelBox;
    lbRow4_5: TLabelBox;
    lbRow5_4: TLabelBox;
    lbRow1_5: TLabelBox;
    lbRow2_6: TLabelBox;
    lbRow3_6: TLabelBox;
    lbRow4_6: TLabelBox;
    lbRow5_5: TLabelBox;
    lbRow1_6: TLabelBox;
    lbRow5_6: TLabelBox;
    lbRow2_7: TLabelBox;
    lbRow2_8: TLabelBox;
    lbRow3_7: TLabelBox;
    lbRow3_8: TLabelBox;
    lbRow4_7: TLabelBox;
    lbRow4_8: TLabelBox;
    lbRow1_7: TLabelBox;
    lbRow2_9: TLabelBox;
    lbRow3_9: TLabelBox;
    lbRow4_9: TLabelBox;
    lbRow1_8: TLabelBox;
    lbRow2_10: TLabelBox;
    lbRow3_10: TLabelBox;
    lbRow4_10: TLabelBox;
    lbRow5_7: TLabelBox;
    lbRow1_9: TLabelBox;
    lbRow1_10: TLabelBox;
    lbRow2_11: TLabelBox;
    lbRow2_12: TLabelBox;
    lbRow3_11: TLabelBox;
    lbRow3_12: TLabelBox;
    lbRow4_11: TLabelBox;
    lbRow5_8: TLabelBox;
    ledMacroSpeed: TuELED;
    ledMultiplay: TuELED;
    ledSpeed: TuELED;
    lineBorderBottomMacro: TLineObj;
    lineBorderLeftMacro: TLineObj;
    lineBorderRightMacro: TLineObj;
    lineBorderTopMacro: TLineObj;
    LoadGifTimer: TIdleTimer;
    memoMacro: TRichMemo;
    miAddCustColor: TMenuItem;
    MonochromeTimer: TIdleTimer;
    NewGifTimer: TIdleTimer;
    OpenDialog: TOpenDialog;
    pmColorPreview: TPopupMenu;
    pnlAssignMacro: TPanel;
    pnlBaseColor: TPanel;
    pnlDirection: TPanel;
    pnlEffectColor: TPanel;
    pnlLayout: TPanel;
    pnlLayoutBtn: TPanel;
    pnlKeyLightingBtn: TPanel;
    pnlLayoutTop: TPanel;
    pnlLighting: TPanel;
    pnlEdgeLightingBtn: TPanel;
    pnlMacro: TPanel;
    pnlMain: TPanel;
    pnlMenu: TPanel;
    pnlMenuMacro: TPanel;
    pnlProfile: TPanel;
    pnlProfileOptions: TPanel;
    pnlSelectProfile: TPanel;
    pnlSpeed: TPanel;
    pnlZone: TPanel;
    preMixedColor1: TmbColorPreview;
    preMixedColor10: TmbColorPreview;
    preMixedColor11: TmbColorPreview;
    preMixedColor12: TmbColorPreview;
    preMixedColor13: TmbColorPreview;
    preMixedColor14: TmbColorPreview;
    preMixedColor15: TmbColorPreview;
    preMixedColor16: TmbColorPreview;
    preMixedColor17: TmbColorPreview;
    preMixedColor18: TmbColorPreview;
    preMixedColor19: TmbColorPreview;
    preMixedColor2: TmbColorPreview;
    preMixedColor20: TmbColorPreview;
    preMixedColor3: TmbColorPreview;
    preMixedColor4: TmbColorPreview;
    preMixedColor5: TmbColorPreview;
    preMixedColor6: TmbColorPreview;
    preMixedColor7: TmbColorPreview;
    preMixedColor8: TmbColorPreview;
    preMixedColor9: TmbColorPreview;
    rgMacro1: TRadioButton;
    rgMacro2: TRadioButton;
    rgMacro3: TRadioButton;
    ringPicker: THSLRingPicker;
    ringPickerBase: THSLRingPicker;
    SaveDialog: TSaveDialog;
    sliderMacroSpeed: TECSlider;
    sliderMultiplay: TECSlider;
    swLayerSwitch: TECSwitch;
    textMacroInput: TStaticText;
    tmrAfterFormShown: TTimer;
    WaveTimer: TIdleTimer;
    procedure btnBacklightClick(Sender: TObject);
    procedure btnDisableKeyClick(Sender: TObject);
    procedure btnEjectClick(Sender: TObject);
    procedure btnLeftMenuClick(Sender: TObject);
    procedure btnMacModifiersClick(Sender: TObject);
    procedure btnMacroClick(Sender: TObject);
    procedure btnSaveAsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnTapAndHoldClick(Sender: TObject);
    procedure CheckVDriveTmrTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure imgBackgroundClick(Sender: TObject);
    procedure imgKeyboardEdgeClick(Sender: TObject);
    procedure imgKeyboardEdgeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgKeyboardLayoutClick(Sender: TObject);
    procedure imgKeyboardLightingClick(Sender: TObject);
    procedure imgProfileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoadGifTimerTimer(Sender: TObject);
    procedure BreatheTimerTimer(Sender: TObject);
    procedure NewGifTimerTimer(Sender: TObject);
    procedure imgProfileClick(Sender: TObject);
    procedure bCoTriggerClick(Sender: TObject);
    procedure btnZoneBtnClick(Sender: TObject);
    procedure imgProfileMouseEnter(Sender: TObject);
    procedure imgProfileMouseLeave(Sender: TObject);
    procedure imgProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    //procedure lblMacroInfoMouseEnter(Sender: TObject);
    //procedure lblMacroInfoMouseLeave(Sender: TObject);
    procedure memoMacroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnExportClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnCloseMacroClick(Sender: TObject);
    procedure btnMouseClicksMacroClick(Sender: TObject);
    procedure btnCommonShortcutsClick(Sender: TObject);
    procedure btnDiagnosticClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMacroClick(Sender: TObject);
    procedure btnDoneMacroClick(Sender: TObject);
    procedure btnFirmwareClick(Sender: TObject);
    procedure btnResetAllClick(Sender: TObject);
    procedure btnTimingDelaysClick(Sender: TObject);
    procedure btnWindowsCombosClick(Sender: TObject);
    procedure btnResetKeyClick(Sender: TObject);
    procedure chkGlobalSpeedClick(Sender: TObject);
    procedure chkRepeatMultiplayClick(Sender: TObject);
    procedure sliderMacroSpeedChange(Sender: TObject);
    procedure sliderMacroSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sliderMultiplayChange(Sender: TObject);
    procedure sliderMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure rgbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgbExit(Sender: TObject);
    procedure eHTMLExit(Sender: TObject);
    procedure eHTMLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure gifViewerStart(Sender: TObject);
    procedure imgKeyboardLightingMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblGlobalSpeedClick(Sender: TObject);
    procedure lblRepeatMultiplayClick(Sender: TObject);
    procedure lbMenuMacroMouseLeave(Sender: TObject);
    procedure lbMenuMouseLeave(Sender: TObject);
    procedure btnDirectionClick(Sender: TObject);
    procedure knobSpeedChange(Sender: TObject);
    procedure knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miAddCustColorClick(Sender: TObject);
    procedure custColorBaseClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure custColorChange(Sender: TObject);
    procedure custColorClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure colorPreMixedBaseClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure colorPreMixedClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure colorPreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure custColorDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ringPickerBaseChange(Sender: TObject);
    procedure ringPickerChange(Sender: TObject);
    procedure MonochromeTimerTimer(Sender: TObject);
    procedure SpectrumTimerTimer(Sender: TObject);
    procedure swLayerSwitchClick(Sender: TObject);
    procedure tmrAfterFormShownTimer(Sender: TObject);
    procedure TopMenuClick(Sender: TObject);
    procedure lbMenuMacroMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbMenuMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure lbProfileClick(Sender: TObject);
    procedure lbProfileDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure lbProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbMenuDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure rgMacroClick(Sender: TObject);
    procedure btnClearMacroClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnBackspaceMacroClick(Sender: TObject);
    procedure lbProfileMouseLeave(Sender: TObject);
    procedure WaveTimerTimer(Sender: TObject);
    procedure MenuDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure MenuItemClick(Sender: TObject);
    procedure MacroMenuItemClick(Sender: TObject);
    procedure ProfileMenuItemClick(Sender: TObject);
    procedure PopupProfileClose(Sender: TObject);
    procedure PopupProfilePopup(Sender: TObject);
  private
    closing: boolean;
    MacroMode: boolean;
    RemapMode: boolean;
    KeyModified: boolean;
    loadingMacro: boolean;
    AppSettingsLoaded: boolean;
    infoMessageShown: boolean;
    loadingSettings: boolean;
    loadingColor: boolean;
    loadingColorBase: boolean;
    loadingLedSettings: boolean;
    freqKeyDown: boolean;
    speedKeyDown: boolean;
    resetLayer: boolean;
    keyBtnList: TObjectList;
    edgeBtnList: TObjectList;
    activeKeyBtn: TLabelBox;
    activeKbKey: TKBKey;
    cusWindowState: TCusWinState;
    oldWindowState: TWindowState;
    NORMAL_HEIGHT: integer;
    NORMAL_WIDTH: integer;
    fromMasterApp: boolean;
    parentForm: TForm;
    //keyService: TKeyService;
    //fileService: TFileService;
    WindowsComboOn: boolean;
    appError: boolean;
    activeMacroMenu: string;
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
    breatheTransparency: integer;
    breatheCycle: integer;
    breatheDirection: TColor;
    pulseColor: integer;
    spectrumCycle: integer;
    spectrumColor: integer;
    waveCycle: integer;
    profileMode: TProfileMode;
    SaveState: TSaveState;
    defaultKeyFontName: string;
    defaultKeyFontSize: integer;
    gifFrameIdx: integer;
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
    kbArrayEdgeB1: array of TLabelBox;
    kbArrayEdgeB2: array of TLabelBox;
    kbArrayEdgeB3: array of TLabelBox;
    kbArrayEdgeB4: array of TLabelBox;
    kbArrayEdgeB5: array of TLabelBox;
    kbArrayEdgeB6: array of TLabelBox;
    kbArrayEdgeB7: array of TLabelBox;
    kbArrayEdgeB8: array of TLabelBox;
    kbArrayEdgeB9: array of TLabelBox;
    kbArrayEdgeB10: array of TLabelBox;
    kbArrayEdgeB11: array of TLabelBox;
    kbArrayEdgeB12: array of TLabelBox;
    kbArrayEdgeB13: array of TLabelBox;
    kbArrayEdgeB14: array of TLabelBox;
    kbArrayEdgeB15: array of TLabelBox;
    kbArrayEdgeL1: array of TLabelBox;
    kbArrayEdgeL2: array of TLabelBox;
    kbArrayEdgeL3: array of TLabelBox;
    kbArrayEdgeL4: array of TLabelBox;
    kbArrayEdgeL5: array of TLabelBox;
    kbArrayEdgeL6: array of TLabelBox;
    kbArrayEdgeL7: array of TLabelBox;
    kbArrayEdgeL8: array of TLabelBox;
    kbArrayEdgeL9: array of TLabelBox;
    kbArrayEdgeR1: array of TLabelBox;
    kbArrayEdgeR2: array of TLabelBox;
    kbArrayEdgeR3: array of TLabelBox;
    kbArrayEdgeR4: array of TLabelBox;
    kbArrayEdgeR5: array of TLabelBox;
    kbArrayEdgeR6: array of TLabelBox;
    kbArrayEdgeR7: array of TLabelBox;
    kbArrayEdgeR8: array of TLabelBox;
    kbArrayEdgeR9: array of TLabelBox;
    kbArrayRow1: array of TLabelBox;
    kbArrayRow2: array of TLabelBox;
    kbArrayRow3: array of TLabelBox;
    kbArrayRow4: array of TLabelBox;
    kbArrayRow5: array of TLabelBox;
    currentGif: string;
    popProfileMenu: TPopupMenu;
    popMouseClicks: TPopupMenu;
    popCommonShortcuts: TPopupMenu;
    showingVDriveErrorDlg: boolean;
    function GetControlUnderMouse: string;
    function AcceptMacro: boolean;
    procedure ActivateCoTrigger(keyButton: TLabelBox);
    procedure ActivateCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
    procedure AddMacroMenuItem(var popMenu: TPopupMenu; itemName: string;
      keyCode: integer);
    procedure AddProfileMenuItem(var popMenu: TPopupMenu; itemName: string; idx: integer);
    procedure AfterColorChange;
    procedure AfterColorChangeBase;
    procedure AppDeactivate(Sender: TObject);
    function CanAssignMacro: boolean;
    procedure CancelMacro;
    procedure ChangeActiveLayer(layerIdx: integer);
    function CheckConfigMode(modeToCheck: integer): boolean;
    procedure CheckFirmware;
    function CheckSaveKey(canSave: boolean = true; checkMacroOpen: boolean = true): boolean;
    function CheckToSave(checkForVDrive: boolean): boolean;
    function CheckVDrive: boolean;
    procedure CloseMacroEditor;
    procedure continueClick(Sender: TObject);
    function DoneKey: boolean;
    procedure EdgeButtonsBringToFront;
    procedure EdgeButtonsSendToBack;
    function EditingMacro(showWarning: boolean=false): boolean;
    procedure EnablePaintImages(value: boolean);
    procedure FillHoveredList;
    procedure FillMenuActionList;
    function GetCoTriggerKey(Sender: TObject): TKey;
    function GetCursorNextKey(cursorPos: integer): integer;
    function GetCursorPrevKey(cursorPos: integer): integer;
    function GetKeyButtonUnderMouse(btnList: TObjectList; x: integer; y: integer): TLabelBox;
    function GetLedMode: TLedMode;
    function GetMenuActionByType(actionType: TMenuActionType): TMenuAction;
    function GetMenuActionByButton(buttonName: string): TMenuAction;
    procedure GetRBGEditBaseColor;
    procedure GetRBGEditColor;
    procedure ImageMenuClick(Sender: TObject);
    function InitApp(scanVDrive: boolean = false): boolean;
    procedure InitKeyButtons(container: TWinControl);
    function IsKeyLoaded: boolean;
    procedure KeyButtonClick(Sender: TObject);
    procedure KeyButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure KeyButtonsBringToFront;
    procedure KeyButtonsSendToBack;
    procedure LaunchDemoMode;
    procedure LoadAppSettings;
    procedure LoadGif(speed: integer; direction: integer);
    function LoadKeyboardLayout(layoutFile: string; fileContent: TStringList
      ): boolean;
    procedure LoadKeyButtonRows;
    procedure LoadLayer(layer: TKBLayer);
    function LoadLedFile(ledFile: string; fileContent: TStringList): boolean;
    procedure LoadMacro;
    function LoadStateSettings: boolean;
    function LoadVersionInfo: boolean;
    procedure menuButtonUpdate(Sender: TObject);
    function MouseInControl(oControl: TControl): boolean;
    procedure MoveComponents(leftIdx: integer; pixels: integer);
    procedure ObjectMouseEnter(Sender: TObject);
    procedure ObjectMouseExit(Sender: TObject);
    procedure ObjectMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure openFirwareWebsite(Sender: TObject);
    procedure OpenMacroEditor;
    procedure OpenTapAndHold;
    procedure openTroubleshootingTipsClick(Sender: TObject);
    procedure PositionMenuItems;
    procedure readManualClick(Sender: TObject);
    procedure RefreshRemapInfo;
    procedure ReloadKeyButtons;
    procedure ReloadKeyButtonsColor(reset: boolean = false; repainForm: boolean = true);
    procedure RemoveCoTrigger(key: word);
    procedure RemoveKeyboardHook;
    procedure RepaintForm(fullRepaint: boolean);
    procedure ResetAllMenuAction;
    procedure ResetBreathe;
    procedure ResetSpectrum;
    procedure ResetCoTrigger(keyButton: TLabelBox);
    procedure ResetCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
    procedure ResetDirection;
    procedure ResetMacroCoTriggers;
    procedure ResetNewGif;
    procedure ResetPopupMenu;
    procedure ResetPopupMenuMacro;
    procedure ResetProfileMenu;
    procedure ResetSingleKey;
    procedure ResetWave;
    procedure ReturnToHome;
    function SaveAll(isNew: boolean=false; showSaveDialog: boolean=true): boolean;
    procedure SaveAsAll(profileNumber: string; isNew: boolean=false);
    procedure SaveStateSettings;
    procedure ScanVDrive(init: boolean);
    procedure scanVDriveClick(Sender: TObject);
    procedure scanVDriveInitClick(Sender: TObject);
    procedure SetActiveKeyButton(keyButton: TLabelBox);
    procedure SetActiveLayer(layerIdx: integer);
    procedure SetButtonColor(keyButton: TLabelBox; aKbKey: TKBKey; reset: boolean);
    procedure SetColemakKb(layerIdx: integer; bothLayers: boolean);
    procedure SetColorWave(arrayButton: array of TLabelBox; colorIdx: integer; invertColors: boolean = false; gradient: boolean = false);
    procedure SetConfigMode(mode: integer; init: boolean = false);
    procedure SetCoTrigger(aKey: TKey);
    procedure SetCurrentMenuAction(aType: TMenuActionType; aButton: TColorSpeedButtonCS);
    procedure SetDirection(direction: integer; ledMode: TLedMode);
    procedure SetDvorakKb(layerIdx: integer; bothLayers: boolean);
    procedure SetFnNumericKpLeft;
    procedure SetFnNumericKpRight;
    procedure SetFrozenWave;
    procedure SetHyperspaceActions(key: integer);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
    procedure SetFreestyle2Hotkeys;
    procedure SetFreestyleProHotkeys;
    procedure SetHovered(obj: TObject; hovered: boolean; forceNormal: boolean = false);
    procedure SetKeyboardHook;
    procedure SetKeyButtonText(keybutton: TLabelBox; btnText: string);
    procedure SetMenuEnabled;
    procedure SetLedMode(ledMode: TLedMode);
    procedure SetMacModifiersHotkeys;
    procedure SetMacroAssignTo;
    procedure SetMacroMenuItems(button: TColorSpeedButtonCS);
    procedure SetMacroMode(value: boolean);
    procedure SetMacroText(pushCursorToEnd: boolean; cursorPos: integer=-1);
    procedure SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
    procedure SetModifiedKey(key: word; Modifiers: string; isMacro: boolean;
      bothLayers: boolean = false; force: boolean = false; overwriteTapHold: boolean = false);
    procedure SetMousePosition(x, y: integer);
    procedure SetRemapMode(value: boolean);
    procedure SetSaveState(aSaveState: TSaveState);
    procedure SetSingleKeyColor(keyButton: TLabelBox; newColor: TColor);
    procedure SetWindowsCombo(value: boolean);
    procedure SetWorkmanKb(layerIdx: integer; bothLayers: boolean);
    procedure SetZoneColor(zoneType: TZoneType);
    procedure ShowHideEdgeButtons(value: boolean);
    procedure ShowHideKeyButtons(value: boolean);
    procedure ShowHideParameters(param: integer; ledMode: TLedMode;
      state: boolean);
    procedure ShowIntroDialogs;
    function ShowTroubleshootingDialog(init: boolean): boolean;
    procedure UnselectActiveKey;
    procedure UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox;
      unselectKey: boolean=false; fullLoad: boolean=false);
    procedure UpdateMenu;
    procedure UpdateStateSettings;
    procedure SetConfigOS;
    function ValidateBeforeDone: boolean;
    function ValidateBeforeSave: boolean;
    procedure watchTutorialClick(Sender: TObject);
    procedure ColorChange(newColor: TColor);
    procedure ColorChangeBase(newColor: TColor);
    procedure InitPopupMenus;
    procedure AddMenuItem(var popMenu: TPopupMenu; itemName: string; keyCode: integer);
  public
    currentLayoutFile: string;
    currentLedFile: string;
    currentProfileNumber: integer;
    lastKeyDown: word;
    lastKeyPressed: word;
    activeColor: TColor;
    fontColor: TColor;
    backColor: TColor;
    copiedMacro: TKeyList;
    MacroModified: boolean;
    procedure Maximize;
    function InitForm(mdiParent: TForm): boolean;
  end;

var
  FormMainTKO: TFormMainTKO;
  KBHook: HHook;
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
    (FormMainTKO.eRed.Focused) or
    (FormMainTKO.eRedBase.Focused) or
    (FormMainTKO.eGreen.Focused) or
    (FormMainTKO.eGreenBase.Focused) or
    (FormMainTKO.eBlue.Focused) or
    (FormMainTKO.eBlueBase.Focused) or
    (FormMainTKO.eHTML.Focused) or
    (FormMainTKO.eHTMLBase.Focused) or
    ((FormTapAndHold <> nil) and FormTapAndHold.eTimingDelay.Focused) then
  begin
    Result := CallNextHookEx(WH_KEYBOARD, Code, wParam, lParam);
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMainTKO.Active) and not(FormMainTKO.fromMasterApp and FormMainTKO.Visible) and
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
        if currentKey <> FormMainTKO.lastKeyPressed then
          SetKeyPress(currentKey, keyService.GetModifierText);

        //To prevent Windows from passing the keystrokes  to the target window, the Result value must  be a nonzero value.
        Result := 1;

        //Sets last key pressed
        FormMainTKO.lastKeyPressed := currentKey;
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
      if currentKey = FormMainTKO.lastKeyPressed then
        FormMainTKO.lastKeyPressed := 0;

      //If it's a  modifier and it's the last key pressed or print screen (only works on key up)
      if ((currentKey = FormMainTKO.lastKeyDown) and IsModifier(currentKey)) or
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
  FormMainTKO.lastKeyDown := currentKey;
end;

{$endif}

//Only used for Mac version to trap key presses
procedure TFormMainTKO.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{$ifdef Darwin}var currentKey: longint;{$endif}
begin
  {$ifdef Darwin}
  //If we need keyboard input (ex: file prompt) allow key presses
  if (NeedInput) or
    (FormMainTKO.eRed.Focused) or
    (FormMainTKO.eRedBase.Focused) or
    (FormMainTKO.eGreen.Focused) or
    (FormMainTKO.eGreenBase.Focused) or
    (FormMainTKO.eBlue.Focused) or
    (FormMainTKO.eBlueBase.Focused) or
    (FormMainTKO.eHTML.Focused) or
    (FormMainTKO.eHTMLBase.Focused) or
    ((FormTapAndHold <> nil) and FormTapAndHold.eTimingDelay.Focused) then
  begin
    exit;
  end;

  //If entering speed, do nothing
  if (not FormMainTKO.Active) and not(FormMainTKO.fromMasterApp and FormMainTKO.Visible) and
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
procedure TFormMainTKO.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
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

procedure SetKeyPress(Key: word; Modifiers: string);
begin
  if (FormTapAndHold <> nil) and (FormTapAndHold.Visible) then
    FormTapAndHold.SetKeyPress(Key)
  else
    FormMainTKO.SetModifiedKey(Key, Modifiers, FormMainTKO.EditingMacro);
end;

{ TFormMainTKO }

function TFormMainTKO.InitForm(mdiParent: TForm): boolean;
begin
  result := false;

  fromMasterApp := mdiParent <> nil;
  parentForm := mdiParent;

  NORMAL_HEIGHT := 850;
  NORMAL_WIDTH := 1550;

  self.Width := NORMAL_WIDTH;
  self.Height := NORMAL_HEIGHT;

  if (FileExists(GExecutablePath + 'backgroundlayout.png')) then
  begin
    imgKeyboardLayout.Picture.LoadFromFile(GExecutablePath + 'backgroundlayout.png');
  end;

  if (FileExists(GExecutablePath + 'backgroundlighting.png')) then
  begin
    imgKeyboardLighting.Picture.LoadFromFile(GExecutablePath + 'backgroundlighting.png');
  end;

  if (FileExists(GExecutablePath + 'backgroundedge.png')) then
  begin
    imgKeyboardEdge.Picture.LoadFromFile(GExecutablePath + 'backgroundedge.png');
  end;

  //From master app
  if (fromMasterApp) then
  begin
    FormStyle := TFormStyle.fsMDIChild;
    WindowState:= TWindowState.wsMaximized;
    NORMAL_HEIGHT := Parent.Height;
    NORMAL_WIDTH := Parent.Width;
    Maximize;
    ShowInTaskBar := stNever;
  end;

  cusWindowState := cwNormal;
  oldWindowState := wsNormal;
  SetFormBorder(bsNone);

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
  edgeBtnList := TObjectList.Create(false);
  activeKeyBtn := nil;
  activeKbKey := nil;
  SetConfigOS;
  keyService := TKeyService.Create;
  fileService := TFileService.Create;
  SetSaveState(ssNone);
  NeedInput := False;
  RemapMode := false;
  loadingMacro := false;
  ResetBreathe;
  ResetNewGif;
  ResetSpectrum;
  ResetWave;
  WindowsComboOn := false;
  appError := false;
  activeMacroMenu := '';
  oldWindowState := wsNormal;
  //ringPicker.SquarePickerHintFormat:='Adjust the brightness of your color using the color square';
  InitKeyButtons(pnlMain);
  Application.OnDeactivate := @AppDeactivate;
  CloseMacroEditor;
  currentPopupMenu := nil;
  profileMode := pmNone;
  maxMacros := MAX_MACRO_RGB;
  maxKeystrokes := MAX_KEYSTROKES_RGB;
  lblMacroEditor.Hint := 'Each layout can store ' + IntToStr(maxKeystrokes) +
      ' total macro characters and up to ' + IntToStr(maxMacros) + ' macros';

  activeColor := KINESIS_BLUE_EDGE;
  fontColor := clWhite;
  backColor := KINESIS_DARK_GRAY_RGB;

  knobSpeed.Image := imageKnobBig.Picture.Bitmap;

  //Set correct z-order for images
  imgKeyboardLayout.SendToBack;
  imgKeyboardLighting.SendToBack;
  gifViewer.SendToBack;
  imgKeyboardBack.SendToBack;
  imgEdgeBack.SendToBack;
  imgBackground.SendToBack;

  FillMenuActionList;
  FillHoveredList;
  InitPopupMenus;

  //Set keyboard Hook
  SetKeyboardHook;

  //Check for v-drive
  SetBaseDirectory(true);

  //Init app
  result := InitApp;
end;

{Set the keyboard hook so we  can intercept keyboard input}
procedure TFormMainTKO.SetKeyboardHook;
begin
  //Windows
  {$ifdef Win64}
  KBHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, HInstance,
    GetCurrentThreadId());
  {$endif}
end;

{unhook the keyboard interception}
procedure TFormMainTKO.RemoveKeyboardHook;
begin
  //Windows
  {$ifdef Win64}
  UnHookWindowsHookEx(KBHook);
  {$endif}
end;

procedure TFormMainTKO.FormShow(Sender: TObject);
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

procedure TFormMainTKO.tmrAfterFormShownTimer(Sender: TObject);
begin
  tmrAfterFormShown.Enabled := false;
  // After show code
  ShowIntroDialogs;
end;

function TFormMainTKO.InitApp(scanVDrive: boolean = false): boolean;
var
  customBtns: TCustomButtons;
  aListDrives: TStringList;
  drives: string;
  i: integer;
  titleError: string;
begin
  result := GDemoMode or CheckVDrive;

  if (result) then
  begin
    //Load config keys depending on app version
    keyService.LoadConfigKeys;

    RefreshRemapInfo;

    swLayerSwitch.Checked := true;

    keyService.LoadLayerList;

    LoadKeyButtonRows;

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
      if (LoadStateSettings) then
      begin
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

procedure TFormMainTKO.SetConfigOS;
begin
  //defaultKeyFontName := 'Arial Narrow';
  defaultKeyFontSize := 10;

  //Windows
  {$ifdef Win64}
  {$endif}

  //MacOS
  {$ifdef Darwin}
  self.AutoScroll := false; //No scroll bars OSX, does not work well
  self.KeyPreview := true; //traps key presses at form level
  rgMacro1.Left := rgMacro1.Left - 25;
  rgMacro1.Top := rgMacro1.Top - 4;
  rgMacro2.Left := rgMacro2.Left - 25;
  rgMacro2.Top := rgMacro2.Top - 4;
  rgMacro3.Left := rgMacro3.Left - 25;
  rgMacro3.Top := rgMacro3.Top - 4;
  btnWindowsCombos.Visible := false;
  imgSmartSet1.Left := imgSmartSet1.Left - 4;

  //Change Macro co-trigger images
  LoadButtonImage(btnLeftCtrl, imgListTriggers, 12);
  LoadButtonImage(btnLeftAlt, imgListTriggers, 14);
  LoadButtonImage(btnRightCtrl, imgListTriggers, 15);
  LoadButtonImage(btnRightAlt, imgListTriggers, 16);

  //Hide special actions for Mac
  //miRightWin.Visible := false;
  //miMenu.Visible := false;
  //miIntlKey.Visible := false;
  //miCalculator.Visible := false;
  {$endif}
end;

procedure TFormMainTKO.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  closing := true;
  if (not CheckToSave(false)) then
  begin
    CloseAction := caNone;
    closing := false;
  end
  else
  begin
    //if (gifViewer.Playing) then
    //  gifViewer.Stop;
    //GifIdleTimer.Enabled := false;
    WaveTimer.Enabled := false;
    BreatheTimer.Enabled := false;
    NewGifTimer.Enabled := false;
    CloseAction := caFree;
  end;
end;

procedure TFormMainTKO.CheckVDriveTmrTimer(Sender: TObject);
begin
  if (not GDemoMode) then
    CheckVDrive;
end;

procedure TFormMainTKO.FormDestroy(Sender: TObject);
begin
  RemoveKeyboardHook;
  FreeAndNil(keyBtnList);// := nil;
  FreeAndNil(edgeBtnList);// := nil;
  FreeAndNil(keyService);
  FreeAndNil(fileService);
  FreeAndNil(menuActionList);
  FreeAndNil(hoveredList);// := nil;
end;

procedure TFormMainTKO.Maximize;
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

procedure TFormMainTKO.UpdateStateSettings;
begin
  self.DisableAlign;

  {$ifdef Win64}
  //Disable paint on form
  SendMessage(self.Handle, WM_SETREDRAW, Integer(False), 0);
  {$endif}

  oldWindowState := self.WindowState;

  {$ifdef Win64}
  //Enable paint on form on repaint
  SendMessage(self.Handle, WM_SETREDRAW, Integer(True), 0);
  {$endif}

  self.EnableAlign;
  self.Repaint;
end;

procedure TFormMainTKO.SetSaveState(aSaveState: TSaveState);
begin
  SaveState := aSaveState;
end;

procedure TFormMainTKO.ResetBreathe;
begin
  breatheTransparency := 0;
  breatheCycle := 0;
  breatheDirection := 0;
  pulseColor := clNone;
end;

procedure TFormMainTKO.ResetSpectrum;
begin
  spectrumCycle := 0;
  spectrumColor := clNone;
end;

procedure TFormMainTKO.ResetWave;
begin
  waveCycle := 0;
end;

procedure TFormMainTKO.ResetNewGif;
begin
  gifFrameIdx := 0;
end;

procedure TFormMainTKO.InitKeyButtons(container: TWinControl);
var
  i: integer;
  keyButton: TLabelBox;
  isEdgeBtn: boolean;
begin
  for i := 0 to container.ControlCount - 1 do
  begin
    if (container.Controls[i] is TLabelBox) then
    begin
      keyButton := (container.Controls[i] as TLabelBox);
      isEdgeBtn := keyButton.Name.ToUpper.StartsWith('LBEDGE');
      if (keyButton.Index >= 0) and (keyButton.Parent <> pnlMacro) then
      begin
        keyButton.BackColor := clNone;
        keyButton.BorderStyle := bsNone;
        keyButton.Caption := '';
        keyButton.Font.Name := defaultKeyFontName;
        keyButton.Font.Size := defaultKeyFontSize;
        keyButton.OnClick := @KeyButtonClick;
        keyButton.OnMouseDown := @KeyButtonMouseDown;
        keyButton.Hint := 'Select a key to begin programming';
        keyButton.ShowHint := true;
        if (isEdgeBtn) then
          edgeBtnList.Add(keyButton)
        else
          keyBtnList.Add(keyButton);
      end
      else if (container.Controls[i] is TPanel) then
        InitKeyButtons(container.Controls[i] as TPanel);
    end;
  end;
end;

procedure TFormMainTKO.AppDeactivate(Sender: TObject);
begin
  if (keyService <> nil) and (not closing) then
    keyService.ClearModifiers;
end;

procedure TFormMainTKO.FillMenuActionList;
begin
  menuActionList := TObjectList.Create(true);

  menuActionList.Add(TMenuAction.Create(maMacro, btnMacro, nil, nil, CONFIG_LAYOUT, lmNone, false, false, false));
  menuActionList.Add(TMenuAction.Create(maHyperspace, btnHyperspaceConfigs, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maMultimedia, btnMultimedia, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maMouseClicks, btnMouseClicks, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maFuncKeys, btnFunctionKeys, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maFnAccess, btnFnAccess, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maFullKeypad, btnFullKeypad, nil, nil, CONFIG_LAYOUT, lmNone, true, false, false));
  menuActionList.Add(TMenuAction.Create(maKeypadActions, btnKeypadActions, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maAltLayouts, btnAltLayouts, nil, nil, CONFIG_LAYOUT, lmNone, true, false, false));
  menuActionList.Add(TMenuAction.Create(maMultimodifiers, btnMultimodifiers, nil, nil, CONFIG_LAYOUT, lmNone, true, false, false));
  menuActionList.Add(TMenuAction.Create(maTapHold, btnTapAndHold, nil, nil, CONFIG_LAYOUT, lmNone, false, false, true));
  menuActionList.Add(TMenuAction.Create(maBacklight, btnBacklight, nil, nil, CONFIG_LAYOUT, lmNone, false, false, true));
  menuActionList.Add(TMenuAction.Create(maMacModifiers, btnMacModifiers, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maSpecialActions, btnSpecialActions, nil, nil, CONFIG_LAYOUT, lmNone, true, false, true));
  menuActionList.Add(TMenuAction.Create(maDisable, btnDisableKey, nil, nil, CONFIG_LAYOUT, lmNone, false, false, true));
  //
  menuActionList.Add(TMenuAction.Create(maFreestyle, btnFreestyle, nil, nil, CONFIG_LIGHTING, lmFreestyle, false, true, false));
  menuActionList.Add(TMenuAction.Create(maMonochrome, btnMonochrome, nil, nil, CONFIG_LIGHTING, lmMonochrome, false, true, false));
  menuActionList.Add(TMenuAction.Create(maBreathe, btnBreathe, nil, nil, CONFIG_LIGHTING, lmBreathe, false, true, false));
  menuActionList.Add(TMenuAction.Create(maWave, btnWave, nil, nil, CONFIG_LIGHTING, lmWave, false, true, false));
  menuActionList.Add(TMenuAction.Create(maSpectrum, btnSpectrum, nil, nil, CONFIG_LIGHTING, lmSpectrum, false, true, false));
  menuActionList.Add(TMenuAction.Create(maReactive, btnReactive, nil, nil, CONFIG_LIGHTING, lmReactive, false, true, false));
  menuActionList.Add(TMenuAction.Create(maRipple, btnRipple, nil, nil, CONFIG_LIGHTING, lmRipple, false, true, false));
  menuActionList.Add(TMenuAction.Create(maFireball, btnFireball, nil, nil, CONFIG_LIGHTING, lmFireball, false, true, false));
  menuActionList.Add(TMenuAction.Create(maStarlight, btnStarlight, nil, nil, CONFIG_LIGHTING,lmStarlight, false, true, false));
  menuActionList.Add(TMenuAction.Create(maRebound, btnRebound, nil, nil, CONFIG_LIGHTING, lmRebound, false, true, false));
  menuActionList.Add(TMenuAction.Create(maLoop, btnLoop, nil, nil, CONFIG_LIGHTING, lmLoop, false, true, false));
  menuActionList.Add(TMenuAction.Create(maPulse, btnPulse, nil, nil, CONFIG_LIGHTING, lmPulse, false, true, false));
  menuActionList.Add(TMenuAction.Create(maRain, btnRain, nil, nil, CONFIG_LIGHTING, lmRain, false, true, false));
  menuActionList.Add(TMenuAction.Create(maDisableLed, btnDisable, nil, nil, CONFIG_LIGHTING, lmDisabled, false, true, false));
  //
  menuActionList.Add(TMenuAction.Create(maFreestyleEdge, btnFreestyleEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmFreestyle, false, true, false));
  menuActionList.Add(TMenuAction.Create(maMonochromeEdge, btnMonochromeEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmMonochrome, false, true, false));
  menuActionList.Add(TMenuAction.Create(maBreatheEdge, btnBreatheEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmBreathe, false, true, false));
  menuActionList.Add(TMenuAction.Create(maWaveEdge, btnWaveEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmWave, false, true, false));
  menuActionList.Add(TMenuAction.Create(maFrozenWaveEdge, btnFrozenWave, nil, nil, CONFIG_EDGE_LIGHTING, lmFrozenWave, false, true, false));
  menuActionList.Add(TMenuAction.Create(maSpectrumEdge, btnSpectrumEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmSpectrum, false, true, false));
  menuActionList.Add(TMenuAction.Create(maReboundEdge, btnReboundEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmRebound, false, true, false));
  menuActionList.Add(TMenuAction.Create(maLoopEdge, btnLoopEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmLoop, false, true, false));
  menuActionList.Add(TMenuAction.Create(maPulseEdge, btnPulseEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmPulse, false, true, false));
  menuActionList.Add(TMenuAction.Create(maDisableEdge, btnDisableEdge, nil, nil, CONFIG_EDGE_LIGHTING, lmDisabled, false, true, false));
end;

procedure TFormMainTKO.FillHoveredList;
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

  ////Zone buttons
  //hoveredList.Add(THoveredObj.Create(btnAllZone, imgListZone, 0, 1));
  //hoveredList.Add(THoveredObj.Create(btnGameZone, imgListZone, 2, 3));
  //hoveredList.Add(THoveredObj.Create(btnLeftModule, imgListZone, 4, 5));
  //hoveredList.Add(THoveredObj.Create(btnRightModule, imgListZone, 6, 7));
  //hoveredList.Add(THoveredObj.Create(btnNumberZone, imgListZone, 8, 9));
  //hoveredList.Add(THoveredObj.Create(btnFunctionZone, imgListZone, 10, 11));
  //hoveredList.Add(THoveredObj.Create(btnWASDZone, imgListZone, 12, 13));
  //hoveredList.Add(THoveredObj.Create(btnArrowZone, imgListZone, 14, 15));

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
      (obj as TImage).OnMouseEnter := @ObjectMouseEnter;
      (obj as TImage).OnMouseLeave := @ObjectMouseExit;
    end;
  end;
end;

procedure TFormMainTKO.InitPopupMenus;
var
  popMenu: TPopupMenu;
begin
  //Profile menu
  popProfileMenu := TPopupMenu.Create(self);
  popProfileMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  popProfileMenu.OnClose := @PopupProfileClose;
  popProfileMenu.OnPopup := @PopupProfilePopup;
  AddProfileMenuItem(popProfileMenu, 'PROFILE 1', 1);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 2', 2);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 3', 3);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 4', 4);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 5', 5);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 6', 6);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 7', 7);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 8', 8);
  AddProfileMenuItem(popProfileMenu, 'PROFILE 9', 9);

  //Layout menu
  //Hyperspace Configs
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Typing 1', VK_TYPING_1);
  AddMenuItem(popMenu, 'Typing 2', VK_TYPING_2);
  AddMenuItem(popMenu, 'Typing 3', VK_TYPING_3);
  AddMenuItem(popMenu, 'Coding 1', VK_CODING_1);
  AddMenuItem(popMenu, 'Coding 2', VK_CODING_2);
  AddMenuItem(popMenu, 'Coding 3', VK_CODING_3);
  AddMenuItem(popMenu, 'Coding 4', VK_CODING_4);
  AddMenuItem(popMenu, 'Coding 5', VK_CODING_5);
  AddMenuItem(popMenu, 'Overwatch 1', VK_OVERWATCH1);
  AddMenuItem(popMenu, 'Overwatch 2', VK_OVERWATCH2);
  AddMenuItem(popMenu, 'Fortnite', VK_FORTNITE);
  AddMenuItem(popMenu, 'CS:GO 1', VK_CSGO1);
  AddMenuItem(popMenu, 'CS:GO 2', VK_CSGO2);
  AddMenuItem(popMenu, 'Warcraft', VK_WARCRAFT);
  AddMenuItem(popMenu, 'Minecraft', VK_MINECRAFT);
  AddMenuItem(popMenu, 'Valorant', VK_VALORANT);
  AddMenuItem(popMenu, 'League of Legends', VK_LEAGUE);
  AddMenuItem(popMenu, 'Apex Legends', VK_APEX);
  AddMenuItem(popMenu, 'Destiny 2', VK_DESTINY2);
  btnHyperspaceConfigs.PopupMenu := popMenu;

  //Multimedia
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Volume Up', VK_VOLUME_UP);
  AddMenuItem(popMenu, 'Volume Down', VK_VOLUME_DOWN);
  AddMenuItem(popMenu, 'Mute', VK_VOLUME_MUTE);
  AddMenuItem(popMenu, 'Play/Pause', VK_MEDIA_PLAY_PAUSE);
  AddMenuItem(popMenu, 'Previous Track', VK_MEDIA_PREV_TRACK);
  AddMenuItem(popMenu, 'Next Track', VK_MEDIA_NEXT_TRACK);
  btnMultimedia.PopupMenu := popMenu;

  //Mouse clicks
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Left Click', VK_MOUSE_LEFT);
  AddMenuItem(popMenu, 'Middle Click', VK_MOUSE_MIDDLE);
  AddMenuItem(popMenu, 'Right Click', VK_MOUSE_RIGHT);
  AddMenuItem(popMenu, 'Button 4', VK_MOUSE_BTN4);
  AddMenuItem(popMenu, 'Button 5', VK_MOUSE_BTN5);
  btnMouseClicks.PopupMenu := popMenu;

  //Function keys
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'F13', VK_F13);
  AddMenuItem(popMenu, 'F14', VK_F14);
  AddMenuItem(popMenu, 'F15', VK_F15);
  AddMenuItem(popMenu, 'F16', VK_F16);
  AddMenuItem(popMenu, 'F17', VK_F17);
  AddMenuItem(popMenu, 'F18', VK_F18);
  AddMenuItem(popMenu, 'F19', VK_F19);
  AddMenuItem(popMenu, 'F20', VK_F20);
  AddMenuItem(popMenu, 'F21', VK_F21);
  AddMenuItem(popMenu, 'F22', VK_F22);
  AddMenuItem(popMenu, 'F23', VK_F23);
  AddMenuItem(popMenu, 'F24', VK_F24);
  btnFunctionKeys.PopupMenu := popMenu;

  //Fn Access
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Fn Toggle', VK_FN_TOGGLE);
  AddMenuItem(popMenu, 'Fn Shift', VK_FN_SHIFT);
  btnFnAccess.PopupMenu := popMenu;

  //Full Keypad
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Right Side', VK_NUMERIC_RIGHT);
  //AddMenuItem(popMenu, 'Left Side', VK_NUMERIC_LEFT);
  btnFullKeypad.PopupMenu := popMenu;

  //Keypad actions
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, '0', VK_NUMPAD0);
  AddMenuItem(popMenu, '1', VK_NUMPAD1);
  AddMenuItem(popMenu, '2', VK_NUMPAD2);
  AddMenuItem(popMenu, '3', VK_NUMPAD3);
  AddMenuItem(popMenu, '4', VK_NUMPAD4);
  AddMenuItem(popMenu, '5', VK_NUMPAD5);
  AddMenuItem(popMenu, '6', VK_NUMPAD6);
  AddMenuItem(popMenu, '7', VK_NUMPAD7);
  AddMenuItem(popMenu, '8', VK_NUMPAD8);
  AddMenuItem(popMenu, '9', VK_NUMPAD9);
  AddMenuItem(popMenu, 'Decimal', VK_DECIMAL);
  AddMenuItem(popMenu, 'Plus', VK_ADD);
  AddMenuItem(popMenu, 'Minus', VK_SUBTRACT);
  AddMenuItem(popMenu, 'Divide', VK_DIVIDE);
  AddMenuItem(popMenu, 'Multiply', VK_MULTIPLY);
  AddMenuItem(popMenu, 'Enter', VK_NUMPADENTER);
  AddMenuItem(popMenu, 'Num Lock', VK_NUMLOCK);
  btnKeypadActions.PopupMenu := popMenu;

  //Alternate layouts
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Dvorak', VK_DVORAK);
  AddMenuItem(popMenu, 'Colemak', VK_COLEMAK);
  AddMenuItem(popMenu, 'Workman', VK_WORKMAN);
  btnAltLayouts.PopupMenu := popMenu;

  //Multimodifiers
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Hyper', VK_HYPER);
  AddMenuItem(popMenu, 'Meh', VK_Meh);
  btnMultimodifiers.PopupMenu := popMenu;

  //Special actions
  popMenu := TPopupMenu.Create(self);
  popMenu.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMenuItem(popMenu, 'Right Windows', VK_RWIN);
  AddMenuItem(popMenu, 'Left Windows', VK_LWIN);
  {$ifdef Win64}
  AddMenuItem(popMenu, 'Menu', VK_KP_MENU);
  {$endif}
  {$ifdef darwin}
  AddMenuItem(popMenu, 'Menu', VK_MOUSE_RIGHT);
  {$endif}
  AddMenuItem(popMenu, 'International Key', VK_OEM_102);
  AddMenuItem(popMenu, 'Shutdown (Windows)', VK_SHUTDOWN);
  AddMenuItem(popMenu, 'Calculator (Windows)', VK_CALC);
  btnSpecialActions.PopupMenu := popMenu;

  //// MACRO menu
  //Macro mouse clicks
  popMouseClicks := TPopupMenu.Create(self);
  popMouseClicks.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMacroMenuItem(popMouseClicks, 'Left Click', VK_MOUSE_LEFT);
  AddMacroMenuItem(popMouseClicks, 'Middle Click', VK_MOUSE_MIDDLE);
  AddMacroMenuItem(popMouseClicks, 'Right Click', VK_MOUSE_RIGHT);
  AddMacroMenuItem(popMouseClicks, 'Button 4', VK_MOUSE_BTN4);
  AddMacroMenuItem(popMouseClicks, 'Button 5', VK_MOUSE_BTN5);
  AddMacroMenuItem(popMouseClicks, 'Double-Click', VK_MOUSE_DBL_125);
  //btnMouseClicksMacro.PopupMenu := popMenu;

  //Macro common shortcuts
  popCommonShortcuts := TPopupMenu.Create(self);
  popCommonShortcuts.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  AddMacroMenuItem(popCommonShortcuts, 'Cut', VK_CUT);
  AddMacroMenuItem(popCommonShortcuts, 'Copy', VK_COPY);
  AddMacroMenuItem(popCommonShortcuts, 'Paste', VK_PASTE);
  AddMacroMenuItem(popCommonShortcuts, 'Select All', VK_SELECTALL);
  AddMacroMenuItem(popCommonShortcuts, 'Undo', VK_UNDO);
  {$ifdef Win64} //Windows
  AddMacroMenuItem(popCommonShortcuts, 'Redo', VK_REDO);
  AddMacroMenuItem(popCommonShortcuts, 'Desktop', VK_DESKTOP);
  {$endif}
  AddMacroMenuItem(popCommonShortcuts, 'Last App', VK_LASTAPP);
  {$ifdef Win64} //Windows
  AddMacroMenuItem(popCommonShortcuts, 'Ctrl Alt Delete', VK_CTRLALTDEL);
  {$endif}
  //btnCommonShortcuts.PopupMenu := popMenu;
end;

procedure TFormMainTKO.AddMenuItem(var popMenu: TPopupMenu; itemName: string; keyCode: integer);
var
  menuItem: TMenuItem;
begin
  menuItem := TMenuItem.Create(popMenu);
  menuItem.Caption := itemName;
  menuItem.Tag := keyCode;
  menuItem.OnClick := @MenuItemClick;
  popMenu.Items.Add(menuItem);
end;

procedure TFormMainTKO.AddMacroMenuItem(var popMenu: TPopupMenu; itemName: string; keyCode: integer);
var
  menuItem: TMenuItem;
begin
  menuItem := TMenuItem.Create(popMenu);
  menuItem.Caption := itemName;
  menuItem.Tag := keyCode;
  menuItem.OnClick := @MacroMenuItemClick;
  popMenu.Items.Add(menuItem);
end;

procedure TFormMainTKO.AddProfileMenuItem(var popMenu: TPopupMenu;
  itemName: string; idx: integer);
var
  menuItem: TMenuItem;
begin
  menuItem := TMenuItem.Create(popMenu);
  menuItem.Caption := itemName;
  menuItem.Tag := idx;
  menuItem.OnClick := @ProfileMenuItemClick;
  popMenu.Items.Add(menuItem);
end;

procedure TFormMainTKO.MenuItemClick(Sender: TObject);
var
  mnu: TMenuItem;
  mnuAction: Integer;
  bothLayers: boolean;
  layoutName: string;
begin
  mnu := (sender as TMenuItem);
  mnuAction := mnu.Tag;

  if (mnuAction > 0) then
  begin
    if (mnuAction = VK_DVORAK) or (mnuAction = VK_COLEMAK) or (mnuAction = VK_WORKMAN) then
    begin
      if (mnuAction = VK_DVORAK) then
      begin
        layoutName := 'Dvorak';
      end
      else if (mnuAction = VK_COLEMAK) then
      begin
        layoutName := 'Colemak';
      end
      else if (mnuAction = VK_WORKMAN) then
      begin
        layoutName := 'Workman';
      end;

      if (ShowDialog('Alternate Layout',
        'Would you like to apply the ' + layoutName + ' alternate layout?' + #10#10 +
        'Note: Implementing this layout may overwrite existing remaps.',
        mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes) then
      begin
        if (mnuAction = VK_DVORAK) then
          SetDvorakKb(TOPLAYER_IDX, false)
        else if (mnuAction = VK_COLEMAK) then
          SetColemakKb(TOPLAYER_IDX, false)
        else if (mnuAction = VK_WORKMAN) then
          SetWorkmanKb(TOPLAYER_IDX, false);
      end;
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
    else if (mnuAction = VK_CODING_1) or (mnuAction = VK_CODING_2) or (mnuAction = VK_CODING_3) or (mnuAction = VK_CODING_4) or (mnuAction = VK_CODING_5) or
      (mnuAction = VK_TYPING_1) or (mnuAction = VK_TYPING_2) or (mnuAction = VK_TYPING_3) or
      (mnuAction = VK_OVERWATCH1) or (mnuAction = VK_OVERWATCH2) or (mnuAction = VK_FORTNITE) or (mnuAction = VK_CSGO1) or (mnuAction = VK_CSGO2) or
      (mnuAction = VK_WARCRAFT) or (mnuAction = VK_MINECRAFT) or (mnuAction = VK_VALORANT) or (mnuAction = VK_LEAGUE) or (mnuAction = VK_APEX) or
      (mnuAction = VK_DESTINY2) then
    begin
      SetHyperspaceActions(mnuAction);
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

procedure TFormMainTKO.MacroMenuItemClick(Sender: TObject);
var
  mnuAction: Integer;
  mnu: TMenuItem;
begin
  mnu := (sender as TMenuItem);
  mnuAction := mnu.Tag;

  if (EditingMacro) and (mnuAction > 0) then
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

    //ResetPopupMenuMacro;
  end;
end;

procedure TFormMainTKO.ProfileMenuItemClick(Sender: TObject);
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
  idxPos := (sender as TMenuItem).Tag;

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
        SetSaveState(ssNone);
      end;
    end
    else if (profileMode = pmSaveAs) then
    begin
      SaveAsAll(IntToStr(idxPos));
    end;
  end;

  ResetProfileMenu;
end;

procedure TFormMainTKO.PopupProfileClose(Sender: TObject);
begin
  //ResetProfileMenu;
end;

function TFormMainTKO.LoadVersionInfo: boolean;
var
  errorMsg: string;
begin
  Result := False;

  errorMsg := fileService.LoadVersionInfo(GActiveDevice);

  if (errorMsg = '') then
  begin
    Result := true;
  end;
end;

procedure TFormMainTKO.LoadAppSettings;
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

function TFormMainTKO.LoadStateSettings: boolean;
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

function TFormMainTKO.LoadKeyboardLayout(layoutFile: string; fileContent: TStringList): boolean;
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

function TFormMainTKO.LoadLedFile(ledFile: string; fileContent: TStringList): boolean;
var
  errorMsg: string;
  ledContent: TStringList;
  edgeContent: TStringList;
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
          edgeContent := keyService.ExtractEdgeFromTextFile(ledContent);
          keyService.ConvertLedFromTextFileFmt(ledContent);
          keyService.ConvertEdgeFromTextFileFmt(edgeContent);
          Result := true;
        finally
          loadingSettings := false;
        end;
      end
      else
      begin
        ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      end;

      if (keyService.ConfigMode = CONFIG_LIGHTING) or (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
        SetLedMode(keyService.LedMode);
    finally
      if (ledContent <> nil) and mustFree then
        FreeAndNil(ledContent);
      if (edgeContent <> nil) and mustFree then
        FreeAndNil(edgeContent);
    end;
  end;
end;

function TFormMainTKO.CheckVDrive: boolean;
begin
  result := LoadVersionInfo;
  if (result and showingVDriveErrorDlg) then
    CloseDialog(mrOK);
  SetVDriveState(Result);
end;

procedure TFormMainTKO.SetFormBorder(formBorder: TFormBorderStyle);
begin
  //{$ifdef Win64}
  self.BorderStyle := formBorder;
  RepaintForm(true);
  //{$endif}
end;

procedure TFormMainTKO.RefreshRemapInfo;
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

procedure TFormMainTKO.SetActiveLayer(layerIdx: integer);
begin
  keyService.ActiveLayer := keyService.GetLayer(layerIdx);
  LoadLayer(keyService.ActiveLayer);
end;

procedure TFormMainTKO.LoadLayer(layer: TKBLayer);
begin
  try
    if (layer <> nil) then
    begin
      if (keyService.ConfigMode = CONFIG_LAYOUT) then
        ReloadKeyButtons
      else if (keyService.ConfigMode = CONFIG_LIGHTING) or (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
        SetLedMode(keyService.LedMode);
    end;
  finally
  end;
end;

procedure TFormMainTKO.ReloadKeyButtons;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  SetActiveKeyButton(nil);
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(keyBtnList, aKbKey.Index);
    UpdateKeyButtonKey(aKbKey, keyButton, false, true);
  end;

  RepaintForm(false);
end;

procedure TFormMainTKO.RepaintForm(fullRepaint: boolean);
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
      region := TRect.Create(imgKeyboardLighting.Left, imgKeyboardLighting.Top, imgKeyboardLighting.Left + imgKeyboardLighting.Width, imgKeyboardLighting.Top + imgKeyboardLighting.Height);
      InvalidateRect(pnlMain.Handle, @region, false);
      //pnlMain.Repaint;
      //pnlMain.Invalidate;
    end;
  finally
    EnablePaintImages(true);
  end;
end;

procedure TFormMainTKO.SetActiveKeyButton(keyButton: TLabelBox);
var
   isSmartSetKey: boolean;
begin
  if CheckSaveKey(true, false) then
  begin
    MacroModified := false;
    KeyModified := false;

    if IsKeyLoaded then
    begin
      UpdateKeyButtonKey(activeKbKey, activeKeyBtn, true);
    end;

    if (keyButton = activeKeyBtn) or (keyButton = nil) or (keyService.ConfigMode <> CONFIG_LAYOUT) then
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
        isSmartSetKey := keyButton.Index = 61;
        activeKbKey := nil;
        if (isSmartSetKey) then
          ShowDialog('Select key', 'You cannot reprogram the SmartSet key.', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
        else
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
    SetMenuEnabled;

    if (EditingMacro) then
      OpenMacroEditor;
  end;
end;

function TFormMainTKO.IsKeyLoaded: boolean;
begin
  result := (activeKeyBtn <> nil) and (activeKbKey <> nil);
end;

function TFormMainTKO.CheckSaveKey(canSave: boolean; checkMacroOpen: boolean
  ): boolean;
var
  msgResult: integer;
begin
  result := true;

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
end;

function TFormMainTKO.CheckToSave(checkForVDrive: boolean): boolean;
var
  dialogResult: integer;
  mustRestartGif: boolean;
begin
  result := true;
  if (SaveState = ssModified) and not(GDemoMode) then
  begin
    if checkForVDrive and (not CheckVDrive) then
      result := ShowTroubleshootingDialog(false);

    if (result) then
    begin
      mustRestartGif := false;
      if (keyService.ConfigMode = CONFIG_LIGHTING) and gifViewer.Visible and gifViewer.Playing then
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
        SetSaveState(ssNone)
      else
        result := false;

      if (mustRestartGif) then
        gifViewer.Start;
    end;
  end;
end;

procedure TFormMainTKO.UpdateKeyButtonKey(kbKey: TKBKey; keyButton: TLabelBox;
  unselectKey: boolean; fullLoad: boolean);
var
  fontSize:integer;
  fontName: string;
begin
  fontSize := 0;
  fontName := '';

  if (kbKey <> nil) and (keyButton <> nil) then
  begin
    if (keyService.ConfigMode = CONFIG_LAYOUT) then
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

procedure TFormMainTKO.SetConfigMode(mode: integer; init: boolean);
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
  SpectrumTimer.Enabled := false;
  WaveTimer.Enabled := false;
  gifViewer.Visible := false;
  ShowHideKeyButtons(false);
  ShowHideEdgeButtons(false);
  ReloadKeyButtonsColor(true, false);
  SetMenuEnabled;
  //if (gifViewer.Playing) then
  //  gifViewer.Stop;

  //Process messages to speed up processing
  Application.ProcessMessages;

  canContinue := CheckSaveKey;

  if (canContinue) then
  begin
    SetCurrentMenuAction(maNone, nil);
    keyService.ConfigMode := mode;
    if (keyService.ConfigMode = CONFIG_LAYOUT) then
    begin
      pnlLayoutBtn.Color := KINESIS_DARK_GRAY_RGB;
      pnlKeyLightingBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlEdgeLightingBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlLighting.Visible := false;
      pnlLighting.Align := alNone;
      pnlLayout.Align := alClient;
      pnlLayout.Visible := true;
      pnlEdgeLighting.Align := alNone;
      pnlEdgeLighting.Visible := false;
      PositionMenuItems;
      imgKeyboardLayout.Visible := true;
      imgKeyboardLighting.Visible := false;
      imgKeyboardEdge.Visible := false;
      btnResetAll.Hint := 'Reset layout to default';
      KeyButtonsBringToFront;
      ShowHideKeyButtons(true);
      SetCurrentMenuAction(maNone, nil);
    end
    else if (keyService.ConfigMode = CONFIG_LIGHTING) then
    begin
      CloseMacroEditor;
      pnlLayoutBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlKeyLightingBtn.Color := KINESIS_DARK_GRAY_RGB;
      pnlEdgeLightingBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlLayout.Align := alNone;
      pnlLayout.Visible := false;
      pnlEdgeLighting.Align := alNone;
      pnlEdgeLighting.Visible := false;
      pnlLighting.Align := alClient;
      pnlLighting.Visible := true;
      PositionMenuItems;
      imgKeyboardLayout.Visible := false;
      imgKeyboardLighting.Visible := true;
      imgKeyboardEdge.Visible := false;
      btnResetAll.Hint := 'Erase color assignments for all keys';
    end
    else if (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
    begin
      CloseMacroEditor;
      pnlLayoutBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlKeyLightingBtn.Color := KINESIS_MED_GRAY_RGB;
      pnlEdgeLightingBtn.Color := KINESIS_DARK_GRAY_RGB;
      pnlLayout.Align := alNone;
      pnlLayout.Visible := false;
      pnlLighting.Align := alNone;
      pnlLighting.Visible := false;
      pnlEdgeLighting.Align := alClient;
      pnlEdgeLighting.Visible := true;
      PositionMenuItems;
      imgKeyboardBack.SendToBack;
      imgKeyboardLayout.Visible := false;
      imgKeyboardLighting.Visible := false;
      imgKeyboardEdge.Visible := true;
      btnResetAll.Hint := 'Erase color assignments for all keys';
    end;

    //imgLeftMenu.Visible := ConfigMode = CONFIG_LAYOUT;
    swLayerSwitch.Visible := true;
    btnCancel.Visible := keyService.ConfigMode = CONFIG_LAYOUT;
    btnDone.Visible := keyService.ConfigMode = CONFIG_LAYOUT;
    btnResetKey.Visible := keyService.ConfigMode = CONFIG_LAYOUT;
    btnResetAll.Visible := true;
    //lblDisable.Visible := keyService.ConfigMode = CONFIG_LIGHTING;
    //chkDisable.Visible := keyService.ConfigMode = CONFIG_LIGHTING;

    if (keyService.ConfigMode = CONFIG_LAYOUT) then
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
      //jm temp menuAction.ActionButton.Visible := menuAction.MenuConfig = keyService.ConfigMode;
      //jm temp menuAction.ActionLabel.Visible := menuAction.MenuConfig = keyService.ConfigMode;
    end;

    //Process messages to speed up processing
    pnlProfile.Repaint;
    Application.ProcessMessages;

    if (keyService.ConfigMode = CONFIG_LIGHTING) or (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
    begin
      SetLedMode(keyService.LedMode);
    end
    else if (keyService.ConfigMode = CONFIG_LAYOUT) then
    begin
      ReloadKeyButtons;
      if (gifViewer.Playing) then
        gifViewer.Stop;
    end;
  end;
end;

procedure TFormMainTKO.FormActivate(Sender: TObject);
begin
  //ShowIntroDialogs;
end;

procedure TFormMainTKO.ShowIntroDialogs;
begin
  //todo?
  //if (not closing) and (not infoMessageShown) and (ShowNotification(fileService.AppSettings.AppIntroMsg)) and (AppSettingsLoaded or GDemoMode) then
  //begin
  //  ShowIntro;
  //end;
  if (not closing) and (not infoMessageShown) and (ShowNotification(fileService.AppSettings.AppCheckFirmMsg)) and (AppSettingsLoaded) then
  begin
    CheckFirmware;
  end;
  infoMessageShown := true;
end;

function TFormMainTKO.ShowTroubleshootingDialog(init: boolean): boolean;
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
end;

procedure TFormMainTKO.PositionMenuItems;
begin
  //Position layout menu (last first)
  btnDisableKey.Top := 0;
  btnSpecialActions.Top := 0;
  btnMultimodifiers.Top := 0;
  btnBacklight.Top := 0;
  btnTapAndHold.Top := 0;
  btnMacModifiers.Top := 0;
  btnAltLayouts.Top := 0;
  btnKeypadActions.Top := 0;
  btnFullKeypad.Top := 0;
  btnFnAccess.Top := 0;
  btnFunctionKeys.Top := 0;
  btnMouseClicks.Top := 0;
  btnMultimedia.Top := 0;
  btnHyperspaceConfigs.Top := 0;
  btnMacro.Top := 0;

  //Position lighting menu (last first)
  btnDisableLed.Top := 0;
  btnRain.Top := 0;
  btnPulse.Top := 0;
  btnLoop.Top := 0;
  btnRebound.Top := 0;
  btnStarlight.Top := 0;
  btnFireball.Top := 0;
  btnRipple.Top := 0;
  btnReactive.Top := 0;
  btnSpectrum.Top := 0;
  btnWave.Top := 0;
  btnBreathe.Top := 0;
  btnMonochrome.Top := 0;
  btnFreestyle.Top := 0;

  //Position edge menu (last first)
  btnDisableEdge.Top := 0;
  btnPulseEdge.Top := 0;
  btnLoopEdge.Top := 0;
  btnReboundEdge.Top := 0;
  btnSpectrumEdge.Top := 0;
  btnFrozenWave.Top := 0;
  btnWaveEdge.Top := 0;
  btnBreatheEdge.Top := 0;
  btnMonochromeEdge.Top := 0;
  btnFreestyleEdge.Top := 0;
end;

procedure TFormMainTKO.LoadKeyButtonRows;
begin
  //Columns
  SetLength(kbArrayCol1, 6);
  kbArrayCol1[0] := lbRow1_1;
  kbArrayCol1[1] := lbRow2_1;
  kbArrayCol1[2] := lbRow3_1;
  kbArrayCol1[3] := lbRow4_1;
  kbArrayCol1[4] := lbRow5_1;
  kbArrayCol1[5] := lbRow5_2;
  //
  SetLength(kbArrayCol2, 6);
  kbArrayCol2[0] := lbRow1_2;
  kbArrayCol2[1] := lbRow2_2;
  kbArrayCol2[2] := lbRow3_2;
  kbArrayCol2[3] := lbRow4_2;
  kbArrayCol2[4] := lbRow5_2;
  kbArrayCol2[5] := lbRow5_3;
  //
  SetLength(kbArrayCol3, 4);
  kbArrayCol3[0] := lbRow1_3;
  kbArrayCol3[1] := lbRow2_3;
  kbArrayCol3[2] := lbRow3_3;
  kbArrayCol3[3] := lbRow4_3;
  //
  SetLength(kbArrayCol4, 5);
  kbArrayCol4[0] := lbRow1_4;
  kbArrayCol4[1] := lbRow2_4;
  kbArrayCol4[2] := lbRow3_4;
  kbArrayCol4[3] := lbRow4_4;
  kbArrayCol4[4] := lbRow5_4;
  //
  SetLength(kbArrayCol5, 4);
  kbArrayCol5[0] := lbRow1_5;
  kbArrayCol5[1] := lbRow2_5;
  kbArrayCol5[2] := lbRow3_5;
  kbArrayCol5[3] := lbRow4_5;
  //
  SetLength(kbArrayCol6, 5);
  kbArrayCol6[0] := lbRow1_6;
  kbArrayCol6[1] := lbRow2_6;
  kbArrayCol6[2] := lbRow3_6;
  kbArrayCol6[3] := lbRow4_6;
  kbArrayCol6[4] := lbRow5_5;
  //
  SetLength(kbArrayCol7, 4);
  kbArrayCol7[0] := lbRow1_7;
  kbArrayCol7[1] := lbRow2_7;
  kbArrayCol7[2] := lbRow3_7;
  kbArrayCol7[3] := lbRow4_7;
  //
  SetLength(kbArrayCol8, 5);
  kbArrayCol8[0] := lbRow1_8;
  kbArrayCol8[1] := lbRow2_8;
  kbArrayCol8[2] := lbRow3_8;
  kbArrayCol8[3] := lbRow4_8;
  kbArrayCol8[4] := lbRow5_6;
  //
  SetLength(kbArrayCol9, 4);
  kbArrayCol9[0] := lbRow1_9;
  kbArrayCol9[1] := lbRow2_9;
  kbArrayCol9[2] := lbRow3_9;
  kbArrayCol9[3] := lbRow4_9;
  //
  SetLength(kbArrayCol10, 5);
  kbArrayCol10[0] := lbRow1_10;
  kbArrayCol10[1] := lbRow2_10;
  kbArrayCol10[2] := lbRow3_10;
  kbArrayCol10[3] := lbRow4_10;
  kbArrayCol10[4] := lbRow5_7;
  //
  SetLength(kbArrayCol11, 5);
  kbArrayCol11[0] := lbRow1_11;
  kbArrayCol11[1] := lbRow2_11;
  kbArrayCol11[2] := lbRow3_11;
  kbArrayCol11[3] := lbRow4_11;
  kbArrayCol11[4] := lbRow5_8;
  //
  SetLength(kbArrayCol12, 3);
  kbArrayCol12[0] := lbRow1_12;
  kbArrayCol12[1] := lbRow2_12;
  kbArrayCol12[2] := lbRow3_12;
  //
  SetLength(kbArrayCol13, 3);
  kbArrayCol13[0] := lbRow1_13;
  kbArrayCol13[1] := lbRow2_13;
  kbArrayCol13[2] := lbRow5_9;
  //
  SetLength(kbArrayCol14, 5);
  kbArrayCol14[0] := lbRow1_14;
  kbArrayCol14[1] := lbRow2_14;
  kbArrayCol14[2] := lbRow3_13;
  kbArrayCol14[3] := lbRow4_12;
  kbArrayCol14[4] := lbRow5_10;

  //Row
  SetLength(kbArrayRow1, 14);
  kbArrayRow1[0] := lbRow1_1;
  kbArrayRow1[1] := lbRow1_2;
  kbArrayRow1[2] := lbRow1_3;
  kbArrayRow1[3] := lbRow1_4;
  kbArrayRow1[4] := lbRow1_5;
  kbArrayRow1[5] := lbRow1_6;
  kbArrayRow1[6] := lbRow1_7;
  kbArrayRow1[7] := lbRow1_8;
  kbArrayRow1[8] := lbRow1_9;
  kbArrayRow1[9] := lbRow1_10;
  kbArrayRow1[10] := lbRow1_11;
  kbArrayRow1[11] := lbRow1_12;
  kbArrayRow1[12] := lbRow1_13;
  kbArrayRow1[13] := lbRow1_14;
  //
  SetLength(kbArrayRow2, 14);
  kbArrayRow2[0] := lbRow2_1;
  kbArrayRow2[1] := lbRow2_2;
  kbArrayRow2[2] := lbRow2_3;
  kbArrayRow2[3] := lbRow2_4;
  kbArrayRow2[4] := lbRow2_5;
  kbArrayRow2[5] := lbRow2_6;
  kbArrayRow2[6] := lbRow2_7;
  kbArrayRow2[7] := lbRow2_8;
  kbArrayRow2[8] := lbRow2_9;
  kbArrayRow2[9] := lbRow2_10;
  kbArrayRow2[10] := lbRow2_11;
  kbArrayRow2[11] := lbRow2_12;
  kbArrayRow2[12] := lbRow2_13;
  kbArrayRow2[13] := lbRow2_14;
  //
  SetLength(kbArrayRow3, 13);
  kbArrayRow3[0] := lbRow3_1;
  kbArrayRow3[1] := lbRow3_2;
  kbArrayRow3[2] := lbRow3_3;
  kbArrayRow3[3] := lbRow3_4;
  kbArrayRow3[4] := lbRow3_5;
  kbArrayRow3[5] := lbRow3_6;
  kbArrayRow3[6] := lbRow3_7;
  kbArrayRow3[7] := lbRow3_8;
  kbArrayRow3[8] := lbRow3_9;
  kbArrayRow3[9] := lbRow3_10;
  kbArrayRow3[10] := lbRow3_11;
  kbArrayRow3[11] := lbRow3_12;
  kbArrayRow3[12] := lbRow3_13;
  //
  SetLength(kbArrayRow4, 12);
  kbArrayRow4[0] := lbRow4_1;
  kbArrayRow4[1] := lbRow4_2;
  kbArrayRow4[2] := lbRow4_3;
  kbArrayRow4[3] := lbRow4_4;
  kbArrayRow4[4] := lbRow4_5;
  kbArrayRow4[5] := lbRow4_6;
  kbArrayRow4[6] := lbRow4_7;
  kbArrayRow4[7] := lbRow4_8;
  kbArrayRow4[8] := lbRow4_9;
  kbArrayRow4[9] := lbRow4_10;
  kbArrayRow4[10] := lbRow4_11;
  kbArrayRow4[11] := lbRow4_12;
  //
  SetLength(kbArrayRow5, 10);
  kbArrayRow5[0] := lbRow5_1;
  kbArrayRow5[1] := lbRow5_2;
  kbArrayRow5[2] := lbRow5_3;
  kbArrayRow5[3] := lbRow5_4;
  kbArrayRow5[4] := lbRow5_5;
  kbArrayRow5[5] := lbRow5_6;
  kbArrayRow5[6] := lbRow5_7;
  kbArrayRow5[7] := lbRow5_8;
  kbArrayRow5[8] := lbRow5_9;
  kbArrayRow5[9] := lbRow5_10;

  //Edge
  SetLength(kbArrayEdgeB1, 1);
  kbArrayEdgeB1[0] := lbEdgeB1;

  SetLength(kbArrayEdgeB2, 1);
  kbArrayEdgeB2[0] := lbEdgeB2;

  SetLength(kbArrayEdgeB3, 1);
  kbArrayEdgeB3[0] := lbEdgeB3;

  SetLength(kbArrayEdgeB4, 1);
  kbArrayEdgeB4[0] := lbEdgeB4;

  SetLength(kbArrayEdgeB5, 1);
  kbArrayEdgeB5[0] := lbEdgeB5;

  SetLength(kbArrayEdgeB6, 1);
  kbArrayEdgeB6[0] := lbEdgeB6;

  SetLength(kbArrayEdgeB7, 1);
  kbArrayEdgeB7[0] := lbEdgeB7;

  SetLength(kbArrayEdgeB8, 1);
  kbArrayEdgeB8[0] := lbEdgeB8;

  SetLength(kbArrayEdgeB9, 1);
  kbArrayEdgeB9[0] := lbEdgeB9;

  SetLength(kbArrayEdgeB10, 1);
  kbArrayEdgeB10[0] := lbEdgeB10;

  SetLength(kbArrayEdgeB11, 1);
  kbArrayEdgeB11[0] := lbEdgeB11;

  SetLength(kbArrayEdgeB12, 1);
  kbArrayEdgeB12[0] := lbEdgeB12;

  SetLength(kbArrayEdgeB13, 1);
  kbArrayEdgeB13[0] := lbEdgeB13;

  SetLength(kbArrayEdgeB14, 1);
  kbArrayEdgeB14[0] := lbEdgeB14;

  SetLength(kbArrayEdgeB15, 1);
  kbArrayEdgeB15[0] := lbEdgeB15;

  //Edge Left
  SetLength(kbArrayEdgeL1, 1);
  kbArrayEdgeL1[0] := lbEdgeL1;

  SetLength(kbArrayEdgeL2, 1);
  kbArrayEdgeL2[0] := lbEdgeL2;

  SetLength(kbArrayEdgeL3, 1);
  kbArrayEdgeL3[0] := lbEdgeL3;

  SetLength(kbArrayEdgeL4, 1);
  kbArrayEdgeL4[0] := lbEdgeL4;

  SetLength(kbArrayEdgeL5, 1);
  kbArrayEdgeL5[0] := lbEdgeL5;

  SetLength(kbArrayEdgeL6, 1);
  kbArrayEdgeL6[0] := lbEdgeL6;

  SetLength(kbArrayEdgeL7, 1);
  kbArrayEdgeL7[0] := lbEdgeL7;

  SetLength(kbArrayEdgeL8, 1);
  kbArrayEdgeL8[0] := lbEdgeL8;

  SetLength(kbArrayEdgeL9, 1);
  kbArrayEdgeL9[0] := lbEdgeL9;

  //Edge Right
  SetLength(kbArrayEdgeR1, 1);
  kbArrayEdgeR1[0] := lbEdgeR9;

  SetLength(kbArrayEdgeR2, 1);
  kbArrayEdgeR2[0] := lbEdgeR8;

  SetLength(kbArrayEdgeR3, 1);
  kbArrayEdgeR3[0] := lbEdgeR7;

  SetLength(kbArrayEdgeR4, 1);
  kbArrayEdgeR4[0] := lbEdgeR6;

  SetLength(kbArrayEdgeR5, 1);
  kbArrayEdgeR5[0] := lbEdgeR5;

  SetLength(kbArrayEdgeR6, 1);
  kbArrayEdgeR6[0] := lbEdgeR4;

  SetLength(kbArrayEdgeR7, 1);
  kbArrayEdgeR7[0] := lbEdgeR3;

  SetLength(kbArrayEdgeR8, 1);
  kbArrayEdgeR8[0] := lbEdgeR2;

  SetLength(kbArrayEdgeR9, 1);
  kbArrayEdgeR9[0] := lbEdgeR1;
end;

procedure TFormMainTKO.btnSaveClick(Sender: TObject);
begin
  SaveAll;
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnSaveAsClick(Sender: TObject);
begin
  ////SaveAsAll(false);
  ////SetHovered(sender, false, true);
  //profileMode := pmSaveAs;
  //pnlSelectProfile.Left := btnSaveAs.Left;
  //pnlSelectProfile.Top := btnSaveAs.Top + btnSaveAs.Height;
  //pnlSelectProfile.Visible := true;
  ////SetMousePosition(pnlSelectProfile.Left + 50, pnlSelectProfile.Top + 10);
  //SetHovered(sender, true);
end;

procedure TFormMainTKO.btnSaveAsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  if (btnSaveAs.Enabled) then
  begin
    profileMode := pmSaveAs;

    pt.x := Mouse.CursorPos.x;
    pt.y := Mouse.CursorPos.y;
    popProfileMenu.PopUp(pt.x - x, pt.y + ((Sender as TColorSpeedButtonCS).Height - y));

    btnSaveAs.Down := false;
    SetHovered(sender, false);
  end;
end;

procedure TFormMainTKO.PopupProfilePopup(Sender: TObject);
begin
  //Set Down = false on button
  //btnSaveAs.Down := false;
end;

function TFormMainTKO.GetControlUnderMouse: string;
var
  ctrl: TControl;
  pt: TPoint;
begin
  result := '';
  pt := ScreenToClient(Mouse.CursorPos);
  ctrl := ControlAtPos(pt, [capfRecursive, capfAllowWinControls]);
  if Assigned(ctrl) then
    result := ctrl.Name
  else
    result := Format('%d, %d', [pt.x, pt.y]);
end;

procedure TFormMainTKO.btnSettingsClick(Sender: TObject);
begin
  ShowSettings;
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.imgBackgroundClick(Sender: TObject);
begin
  UnselectActiveKey;
end;

procedure TFormMainTKO.imgKeyboardEdgeClick(Sender: TObject);
begin
  UnselectActiveKey;
end;

procedure TFormMainTKO.imgKeyboardLayoutClick(Sender: TObject);
begin
  UnselectActiveKey;
end;

procedure TFormMainTKO.imgKeyboardLightingClick(Sender: TObject);
begin
  UnselectActiveKey;
end;

procedure TFormMainTKO.UnselectActiveKey;
begin
  ResetPopupMenu;
  ResetPopupMenuMacro;
  ResetSingleKey;
  if IsKeyLoaded then
    SetActiveKeyButton(nil);
end;

function TFormMainTKO.ValidateBeforeSave: boolean;
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

function TFormMainTKO.SaveAll(isNew: boolean; showSaveDialog: boolean): boolean;
var
  errorMsg: string;
  layoutContent: TStringList;
  ledContent: TStringList;
  edgeContent: TStringList;
  hideNotif: integer;
  diagMessage: string;
  diagTitle: string;
  dialHeight: integer;
  continue: boolean;
  profileNumber: integer;
  fileName: string;
  i: integer;
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
      edgeContent := keyService.ConvertEdgeToTextFileFmt;
      for i := 0 to edgeContent.Count - 1 do
        ledContent.Add(edgeContent[i]);
      if fileService.SaveFile(currentLedFile, ledContent, true, errorMsg) then
      begin
        fileName := ExtractFileNameWithoutExt(ExtractFileName(currentLayoutFile));
        profileNumber := fileService.GetFileNumber(currentLayoutFile);
        currentProfileNumber := profileNumber;
        SetSaveState(ssNone);
        result := true;

        if not closing then
          EjectDevice(GActiveDevice);
        if (ShowNotification(fileService.AppSettings.SaveMsg)) and (showSaveDialog) then
        begin
          if (profileNumber = fileService.StateSettings.StartupFileNumber) then
          begin
            diagMessage := 'Use the Refresh Shortcut (SmartSet + Right Shift + B) to preview your updates, or close the App and disconnect the v-Drive (SmartSet + Right Shift + V).';
            diagTitle := 'Profile ' + IntToStr(profileNumber) + ' Saved';
            dialHeight := DEFAULT_DIAG_HEIGHT_RGB;
          end
          else
          begin
            diagMessage := 'To load Profile ' + IntToStr(profileNumber) + ' to the keyboard, hold the SmartSet key + Right Shift and tap the ' + IntToStr(profileNumber) + ' key.';
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
    if (edgeContent <> nil) then
      FreeAndNil(edgeContent);
  end;
end;

procedure TFormMainTKO.SaveAsAll(profileNumber: string; isNew: boolean = false);
var
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

procedure TFormMainTKO.ReloadKeyButtonsColor(reset: boolean; repainForm: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin

  if (keyService.ConfigMode = CONFIG_LIGHTING) then
  begin
    for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
    begin
      aKbKey := keyService.ActiveLayer.KBKeyList[i];
      keyButton := GetKeyButtonByIndex(keyBtnList, aKbKey.Index);

      SetButtonColor(keyButton, aKbKey, reset);
    end;
  end
  else if (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
  begin
    for i := 0 to keyService.ActiveLayer.EdgeKeyList.Count - 1 do
    begin
      aKbKey := keyService.ActiveLayer.EdgeKeyList[i];
      keyButton := GetKeyButtonByIndex(edgeBtnList, aKbKey.Index);

      SetButtonColor(keyButton, aKbKey, reset);
    end;
  end;

  //Do a form repaint
  if (repainForm) then
     RepaintForm(false);
end;

procedure TFormMainTKO.SetButtonColor(keyButton: TLabelBox; aKbKey: TKBKey; reset: boolean);
var
  gifKey: integer;
  gifFrame: TGifFrame;
  aColor: TColor;
begin
  keyButton.Caption := '';
  keyButton.BorderStyle := bsNone;
  keyButton.GradientFill := false;
  keyButton.NextColor := clNone;
  if reset then
  begin
    keyButton.BackColor := clNone;
  end
  else
  begin
    keyButton.Opaque := (keyService.LedMode <> lmBreathe) and (keyService.LedMode <> lmPulse);
    keyButton.Transparency := breatheTransparency;
    if (keyService.LedMode in [lmFreestyle, lmBreathe, lmFrozenWave]) then
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

procedure TFormMainTKO.SetSingleKeyColor(keyButton: TLabelBox; newColor: TColor);
var
  aKbKey: TKBKey;
begin
  if (keyButton <> nil) then
  begin
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
      aKbKey := keyService.GetKbKeyByIndex(keyService.ActiveLayer, keyButton.Index)
    else
      aKbKey := keyService.GetEdgeKeyByIndex(keyService.ActiveLayer, keyButton.Index);
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
    SetSaveState(ssModified);
  end;
end;

procedure TFormMainTKO.KeyButtonsBringToFront;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(keyBtnList, aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.BringToFront;
  end;

end;

procedure TFormMainTKO.EdgeButtonsBringToFront;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.EdgeKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.EdgeKeyList[i];
    keyButton := GetKeyButtonByIndex(edgeBtnList, aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.BringToFront;
  end;
  //Bring buttons over rounded corners
  lbEdgeL2.BringToFront;
  lbEdgeL8.BringToFront;
  lbEdgeR8.BringToFront;
  lbEdgeR2.BringToFront;
end;

procedure TFormMainTKO.KeyButtonsSendToBack;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(keyBtnList, aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.SendToBack;
  end;
end;


procedure TFormMainTKO.EdgeButtonsSendToBack;
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.EdgeKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.EdgeKeyList[i];
    keyButton := GetKeyButtonByIndex(edgeBtnList, aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.SendToBack;
  end;
end;

procedure TFormMainTKO.ShowHideKeyButtons(value: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.KBKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.KBKeyList[i];
    keyButton := GetKeyButtonByIndex(keyBtnList, aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.Visible := value;
  end;
end;

procedure TFormMainTKO.ShowHideEdgeButtons(value: boolean);
var
  i: integer;
  keyButton: TLabelBox;
  aKbKey: TKBKey;
begin
  for i := 0 to keyService.ActiveLayer.EdgeKeyList.Count - 1 do
  begin
    aKbKey := keyService.ActiveLayer.EdgeKeyList[i];
    keyButton := GetKeyButtonByIndex(edgeBtnList, aKbKey.Index);
    if (keyButton <> nil) then
      keyButton.Visible := value;
  end;
end;

function TFormMainTKO.CheckConfigMode(modeToCheck: integer): boolean;
begin
  result := true;
  if (modeToCheck <> keyService.ConfigMode) then
  begin
    if (modeToCheck = CONFIG_LAYOUT) then
      ShowDialog('Editor', 'Your must select the Layout editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
    else if (modeToCheck = CONFIG_LIGHTING) then
      ShowDialog('Editor', 'Your must select the Lighting editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
    else if (modeToCheck = CONFIG_EDGE_LIGHTING) then
      ShowDialog('Editor', 'Your must select the Edge Lighting editor to continue', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

    result := false;
  end;
end;

procedure TFormMainTKO.SaveStateSettings;
var
  errorMsg: string;
const
  TitleStateFile = 'Save State.txt File';
begin
  errorMsg := fileService.SaveStateSettings(GActiveDevice);

  if (errorMsg <> '') then
    ShowDialog(TitleStateFile, errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
end;

procedure TFormMainTKO.watchTutorialClick(Sender: TObject);
begin
  OpenUrl(TKO_TUTORIAL);
end;

procedure TFormMainTKO.readManualClick(Sender: TObject);
begin
  OpenUrl(TKO_HELP);
end;

procedure TFormMainTKO.openTroubleshootingTipsClick(Sender: TObject);
begin
  OpenUrl(TKO_TROUBLESHOOT);
end;

procedure TFormMainTKO.ScanVDrive(init: boolean);
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

procedure TFormMainTKO.LaunchDemoMode;
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

procedure TFormMainTKO.scanVDriveClick(Sender: TObject);
begin
  ScanVDrive(false);
end;

procedure TFormMainTKO.scanVDriveInitClick(Sender: TObject);
begin
  ScanVDrive(false);
end;

procedure TFormMainTKO.ShowHideParameters(param: integer; ledMode: TLedMode; state: boolean);
begin
  case param of
    PARAM_COLOR:
    begin
      pnlEffectColor.Visible := state;
      pnlEffectColor.Repaint;
    end;
    PARAM_BASECOLOR:
    begin
      pnlBaseColor.Visible := state;
      pnlBaseColor.Repaint;
    end;
    PARAM_DIRECTION:
    begin
      pnlDirection.Visible := state;
      btnDirUp.Visible := not(ledMode in [lmRebound, lmFireball]) and (keyService.ConfigMode = CONFIG_LIGHTING);
      btnDirDown.Visible := not(ledMode in [lmRebound, lmFireball]) and (keyService.ConfigMode = CONFIG_LIGHTING);
      btnDirLeft.Visible := not(ledMode in [lmRebound]);
      btnDirRight.Visible := not(ledMode in [lmRebound]);
      btnDirHorizontal.Visible := (ledMode in [lmRebound]) and (keyService.ConfigMode = CONFIG_LIGHTING);
      btnDirVertical.Visible := (ledMode in [lmRebound]) and (keyService.ConfigMode = CONFIG_LIGHTING);
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
      btnZoneWASDKeys.Visible := keyService.ActiveLayer.LayerIndex = TOPLAYER_IDX;
      btnZoneModifiers.Visible := keyService.ActiveLayer.LayerIndex = TOPLAYER_IDX;
      btnZoneNumberRow.Visible := keyService.ActiveLayer.LayerIndex = TOPLAYER_IDX;
      btnZoneHomeRow.Visible := keyService.ActiveLayer.LayerIndex = TOPLAYER_IDX;
      btnZoneMediaKeys.Visible := keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX;
      btnZoneNavKeys.Visible := keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX;
      btnZoneFunctionKeys.Visible := keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX;
      btnZoneArrowKeys.Visible := keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX;
      pnlZone.Repaint;
    end;
  end;
end;

procedure TFormMainTKO.SetRemapMode(value: boolean);
begin

end;

procedure TFormMainTKO.SetMacroMode(value: boolean);
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

function TFormMainTKO.GetLedMode: TLedMode;
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
end;

procedure TFormMainTKO.SetLedMode(ledMode: TLedMode);
const
  colorEnabled = clWhite;
  colorDisabled = clSilver;
begin
  try
    keyService.ActiveGif := nil;
    loadingLedSettings := true;
    BreatheTimer.Enabled := false;
    LoadGifTimer.Enabled := false;
    NewGifTimer.Enabled := false;
    SpectrumTimer.Enabled := false;
    WaveTimer.Enabled := false;
    gifViewer.Visible := false;
    imgKeyboardBack.Visible := (keyService.ConfigMode = CONFIG_LIGHTING);
    imgEdgeBack.Visible := (keyService.ConfigMode = CONFIG_EDGE_LIGHTING);
    keyService.LedMode := ledMode;
    ShowHideKeyButtons(false);
    ShowHideEdgeButtons(false);
    ResetDirection;
    ResetBreathe;
    ResetNewGif;
    ResetSpectrum;
    ResetWave;

    ShowHideParameters(PARAM_COLOR, ledMode, ledMode in [lmFreestyle, lmMonochrome, lmBreathe, lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound, lmLoop, lmRain]);
    ShowHideParameters(PARAM_BASECOLOR, ledMode, ledMode in [lmReactive, lmRipple, lmFireball, lmStarlight, lmRebound, lmLoop, lmRain]);
    ShowHideParameters(PARAM_DIRECTION, ledMode, (ledMode in [lmWave, lmRebound, lmLoop, lmFireball]) and not((ledMode = lmRebound) and (keyService.ConfigMode = CONFIG_EDGE_LIGHTING)));
    ShowHideParameters(PARAM_SPEED, ledMode, ledMode in [lmBreathe, lmSpectrum, lmWave, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain, lmPulse]);
    ShowHideParameters(PARAM_RANGE, ledMode, false);
    ShowHideParameters(PARAM_ZONE, ledMode, (ledMode in [lmFreestyle, lmBreathe]) and (keyService.ConfigMode = CONFIG_LIGHTING));
    btnResetAll.Visible := ledMode in [lmFreestyle, lmBreathe];

    imgKeyboardLighting.Cursor := crDefault;
    imgKeyboardEdge.Cursor := crDefault;
    if (ledMode = lmFreestyle) then
    begin
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        SetCurrentMenuAction(maFreestyle, nil)
      else
        SetCurrentMenuAction(maFreestyleEdge, nil);
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
      imgKeyboardLighting.Cursor := crHandPoint;
      imgKeyboardEdge.Cursor := crHandPoint;
    end
    else if (ledMode = lmMonochrome) then
    begin
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        SetCurrentMenuAction(maMonochrome, nil)
      else
        SetCurrentMenuAction(maMonochromeEdge, nil);
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      ColorChange(keyService.LedColorMono);
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
    end
    else if (ledMode in [lmBreathe, lmPulse]) then
    begin
      if (ledMode = lmBreathe) then
      begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
          SetCurrentMenuAction(maBreathe, nil)
        else
          SetCurrentMenuAction(maBreatheEdge, nil);
      end
      else if (ledMode = lmPulse) then
      begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
          SetCurrentMenuAction(maPulse, nil)
        else
          SetCurrentMenuAction(maPulseEdge, nil);
      end;
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
      imgKeyboardLighting.Cursor := crHandPoint;
      imgKeyboardEdge.Cursor := crHandPoint;
    end
    else if (ledMode in [lmSpectrum]) then
    begin
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        SetCurrentMenuAction(maSpectrum, nil)
      else
        SetCurrentMenuAction(maSpectrumEdge, nil);
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
    end
    else if (ledMode in [lmWave]) then
    begin
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        SetCurrentMenuAction(maWave, nil)
      else
        SetCurrentMenuAction(maWaveEdge, nil);
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      SetDirection(keyService.LedDirection, keyService.LedMode);
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
    end
    else if (ledMode = lmFrozenWave) then
    begin
      //if (keyService.ConfigMode = CONFIG_LIGHTING) then
     //  SetCurrentMenuAction(maFreestyle, nil)
      //else
        SetCurrentMenuAction(maFrozenWaveEdge, nil);
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
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
      begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
          SetCurrentMenuAction(maRebound, nil)
        else
          SetCurrentMenuAction(maReboundEdge, nil)
      end
      else if (ledMode = lmLoop) then
      begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
          SetCurrentMenuAction(maLoop, nil)
        else
          SetCurrentMenuAction(maLoopEdge, nil);
      end
      else if (ledMode = lmRain) then
        SetCurrentMenuAction(maRain, nil);
      imgKeyboardLighting.SendToBack;
      imgKeyboardEdge.SendToBack;
      KeyButtonsSendToBack;
      EdgeButtonsSendToBack;
      gifViewer.SendToBack;
      imgKeyboardBack.SendToBack;
      imgEdgeBack.SendToBack;
      imgBackground.SendToBack;
      knobSpeed.Position := keyService.LedSpeed;
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        ShowHideKeyButtons(true)
      else
        ShowHideEdgeButtons(true);
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
      else if (ledMode = lmFireball) and
        ((keyService.LedDirection = LED_DIR_DOWN_INT) OR (keyService.LedDirection = LED_DIR_UP_INT)) then
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
      if (keyService.ConfigMode = CONFIG_LIGHTING) then
        SetCurrentMenuAction(maDisableLed, nil)
      else
        SetCurrentMenuAction(maDisableEdge, nil);
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
    else if (ledMode in [lmSpectrum]) then
      SpectrumTimer.Enabled := true
    else if (ledMode in [lmWave]) then
      WaveTimer.Enabled := true
    else if not(ledMode in [lmFrozenWave]) then
      LoadGifTimer.Enabled := true;
  finally
    loadingLedSettings := false;
  end;
end;

procedure TFormMainTKO.CheckFirmware;
var
  customBtns: TCustomButtons;
  hideNotif: integer;
begin
  if (fileService.VersionIsEqualKBD(1, 0, 0)) then
  begin
    //createCustomButton(customBtns, 'OK', 100, nil, bkOK);
    createCustomButton(customBtns, 'Upgrade Firmware', 175, @openFirwareWebsite);
    hideNotif := ShowDialog('Firmware', 'Attention macro users: Update your firmware now for full functionality.',
      mtWarning, [], DEFAULT_DIAG_HEIGHT_RGB, customBtns, 'Hide this notification?');

    if (hideNotif >= DISABLE_NOTIF) then
    begin
      fileService.SetAppCheckFirmMsg(true);
      fileService.SaveAppSettings;
    end;
  end;
end;

procedure TFormMainTKO.LoadGifTimerTimer(Sender: TObject);
begin
  LoadGifTimer.Enabled := false;
  LoadGif(Round(knobSpeed.Position), keyService.LedDirection);
end;

procedure TFormMainTKO.SetMenuEnabled;
begin
  btnMultimedia.Enabled := IsKeyLoaded;
  btnMouseClicks.Enabled := IsKeyLoaded;
  btnFunctionKeys.Enabled := IsKeyLoaded;
  btnFnAccess.Enabled := IsKeyLoaded;
  btnKeypadActions.Enabled := IsKeyLoaded;
  btnTapAndHold.Enabled := IsKeyLoaded;
  btnBacklight.Enabled := IsKeyLoaded;
  btnMultimodifiers.Enabled := IsKeyLoaded;
  btnSpecialActions.Enabled := IsKeyLoaded;
  btnDisableKey.Enabled := IsKeyLoaded;
end;

procedure TFormMainTKO.BreatheTimerTimer(Sender: TObject);
var
  delay: integer;
  incTransparency: integer;
begin
  delay := 35;
  incTransparency := 20;
  if (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
    delay := 45;

  BreatheTimer.Enabled := false;
  case keyService.LedSpeed of
    1: begin
      BreatheTimer.Interval := Trunc((12 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 65;
    end;
    2: begin
      BreatheTimer.Interval := Trunc((10 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 65;
    end;
    3: begin
      BreatheTimer.Interval := Trunc((9 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 65;
    end;
    4: begin
      BreatheTimer.Interval := Trunc((8 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 65;
    end;
    5: begin
      BreatheTimer.Interval := Trunc((7 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 70;
    end;
    6: begin
      BreatheTimer.Interval := Trunc((6 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 70;
    end;
    7: begin
      BreatheTimer.Interval := Trunc((5 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 80;
    end;
    8: begin
      BreatheTimer.Interval := Trunc((4 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 120;
    end;
    9: begin
      BreatheTimer.Interval := Trunc((2 * 1000) / delay);
      if (keyService.LedMode = lmPulse) then
        incTransparency := 120;
    end;
  end;

  if (breatheDirection = 0) then
    breatheTransparency := breatheTransparency + incTransparency
  else
    breatheTransparency := breatheTransparency - incTransparency;

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

procedure TFormMainTKO.WaveTimerTimer(Sender: TObject);
const
  MaxCycle = 20;
begin
  WaveTimer.Enabled := false;
  inc(waveCycle);

  if (keyService.LedDirection in [LED_DIR_LEFT_INT, LED_DIR_RIGHT_INT]) then
  begin
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
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
        1: WaveTimer.Interval := 250;
        2: WaveTimer.Interval := 220;
        3: WaveTimer.Interval := 200;
        4: WaveTimer.Interval := 180;
        5: WaveTimer.Interval := 150;
        6: WaveTimer.Interval := 110;
        7: WaveTimer.Interval := 80;
        8: WaveTimer.Interval := 50;
        9: WaveTimer.Interval := 20;
      end;
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
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
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
    end
    else
    begin
      SetColorWave(kbArrayEdgeB1, waveCycle, false, true);
      SetColorWave(kbArrayEdgeB2, (waveCycle + 1) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB3, (waveCycle + 2) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB4, (waveCycle + 3) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB5, (waveCycle + 4) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB6, (waveCycle + 5) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB7, (waveCycle + 6) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB8, (waveCycle + 7) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB9, (waveCycle + 8) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB10, (waveCycle + 9) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB11, (waveCycle + 10) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB12, (waveCycle + 11) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB13, (waveCycle + 12) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB14, (waveCycle + 13) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeB15, (waveCycle + 14) Mod MaxCycle, false, true);

      SetColorWave(kbArrayEdgeL1, waveCycle, false, true);
      SetColorWave(kbArrayEdgeL2, (waveCycle + 1) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL3, (waveCycle + 2) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL4, (waveCycle + 3) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL5, (waveCycle + 4) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL6, (waveCycle + 5) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL7, (waveCycle + 6) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL8, (waveCycle + 7) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeL9, (waveCycle + 8) Mod MaxCycle, false, true);

      SetColorWave(kbArrayEdgeR1, waveCycle, false, true);
      SetColorWave(kbArrayEdgeR2, (waveCycle + 1) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR3, (waveCycle + 2) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR4, (waveCycle + 3) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR5, (waveCycle + 4) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR6, (waveCycle + 5) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR7, (waveCycle + 6) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR8, (waveCycle + 7) Mod MaxCycle, false, true);
      SetColorWave(kbArrayEdgeR9, (waveCycle + 8) Mod MaxCycle, false, true);
    end;
  end
  else if (keyService.LedDirection = LED_DIR_RIGHT_INT) then
  begin
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
    begin
      SetColorWave(kbArrayCol14, waveCycle, true);
      SetColorWave(kbArrayCol13, (waveCycle + 1) Mod MaxCycle, true);
      SetColorWave(kbArrayCol12, (waveCycle + 2) Mod MaxCycle, true);
      SetColorWave(kbArrayCol11, (waveCycle + 3) Mod MaxCycle, true);
      SetColorWave(kbArrayCol10, (waveCycle + 4) Mod MaxCycle, true);
      SetColorWave(kbArrayCol9, (waveCycle + 5) Mod MaxCycle, true);
      SetColorWave(kbArrayCol8, (waveCycle + 6) Mod MaxCycle, true);
      SetColorWave(kbArrayCol7, (waveCycle + 7) Mod MaxCycle, true);
      SetColorWave(kbArrayCol6, (waveCycle + 8) Mod MaxCycle, true);
      SetColorWave(kbArrayCol5, (waveCycle + 9) Mod MaxCycle, true);
      SetColorWave(kbArrayCol4, (waveCycle + 10) Mod MaxCycle, true);
      SetColorWave(kbArrayCol3, (waveCycle + 11) Mod MaxCycle, true);
      SetColorWave(kbArrayCol2, (waveCycle + 12) Mod MaxCycle, true);
      SetColorWave(kbArrayCol1, (waveCycle + 13) Mod MaxCycle, true);
    end
    else
    begin
      SetColorWave(kbArrayEdgeB15, waveCycle, true, true);
      SetColorWave(kbArrayEdgeB14, (waveCycle + 1) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB13, (waveCycle + 2) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB12, (waveCycle + 3) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB11, (waveCycle + 4) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB10, (waveCycle + 5) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB9, (waveCycle + 6) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB8, (waveCycle + 7) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB7, (waveCycle + 8) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB6, (waveCycle + 9) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB5, (waveCycle + 10) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB4, (waveCycle + 11) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB3, (waveCycle + 12) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB2, (waveCycle + 13) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeB1, (waveCycle + 14) Mod MaxCycle, true, true);
      //
      SetColorWave(kbArrayEdgeL9, waveCycle, true, true);
      SetColorWave(kbArrayEdgeL8, (waveCycle + 1) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL7, (waveCycle + 2) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL6, (waveCycle + 3) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL5, (waveCycle + 4) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL4, (waveCycle + 5) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL3, (waveCycle + 6) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL2, (waveCycle + 7) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeL1, (waveCycle + 8) Mod MaxCycle, true, true);
      //
      SetColorWave(kbArrayEdgeR9, waveCycle, true, true);
      SetColorWave(kbArrayEdgeR8, (waveCycle + 1) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR7, (waveCycle + 2) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR6, (waveCycle + 3) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR5, (waveCycle + 4) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR4, (waveCycle + 5) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR3, (waveCycle + 6) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR2, (waveCycle + 7) Mod MaxCycle, true, true);
      SetColorWave(kbArrayEdgeR1, (waveCycle + 8) Mod MaxCycle, true, true);
    end;
  end
  else if (keyService.LedDirection = LED_DIR_DOWN_INT) then
  begin
    SetColorWave(kbArrayRow5, waveCycle, true);
    SetColorWave(kbArrayRow4, (waveCycle + 1) Mod MaxCycle, true);
    SetColorWave(kbArrayRow3, (waveCycle + 2) Mod MaxCycle, true);
    SetColorWave(kbArrayRow2, (waveCycle + 3) Mod MaxCycle, true);
    SetColorWave(kbArrayRow1, (waveCycle + 4) Mod MaxCycle, true);
  end
  else if (keyService.LedDirection = LED_DIR_UP_INT) then
  begin
    SetColorWave(kbArrayRow1, waveCycle);
    SetColorWave(kbArrayRow2, (waveCycle + 1) Mod MaxCycle);
    SetColorWave(kbArrayRow3, (waveCycle + 2) Mod MaxCycle);
    SetColorWave(kbArrayRow4, (waveCycle + 3) Mod MaxCycle);
    SetColorWave(kbArrayRow5, (waveCycle + 4) Mod MaxCycle);
  end;

  RepaintForm(false);

  if (waveCycle = MaxCycle) then
    waveCycle := 0;

  WaveTimer.Enabled := true;
end;

procedure TFormMainTKO.SpectrumTimerTimer(Sender: TObject);
begin
  SpectrumTimer.Enabled := false;
  if (keyService.ConfigMode = CONFIG_LIGHTING) then
  begin
    case keyService.LedSpeed of
      1: SpectrumTimer.Interval := 900;
      2: SpectrumTimer.Interval := 700;
      3: SpectrumTimer.Interval := 600;
      4: SpectrumTimer.Interval := 500;
      5: SpectrumTimer.Interval := 400;
      6: SpectrumTimer.Interval := 300;
      7: SpectrumTimer.Interval := 200;
      8: SpectrumTimer.Interval := 100;
      9: SpectrumTimer.Interval := 50;
    end;
  end
  else
  begin
    case keyService.LedSpeed of
      1: SpectrumTimer.Interval := 250;
      2: SpectrumTimer.Interval := 220;
      3: SpectrumTimer.Interval := 200;
      4: SpectrumTimer.Interval := 180;
      5: SpectrumTimer.Interval := 150;
      6: SpectrumTimer.Interval := 110;
      7: SpectrumTimer.Interval := 80;
      8: SpectrumTimer.Interval := 50;
      9: SpectrumTimer.Interval := 20;
    end;
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

procedure TFormMainTKO.NewGifTimerTimer(Sender: TObject);
const
  delay = 30;
var
  interval: integer;
begin
  NewGifTimer.Enabled := false;
  interval := 1000;

  if (keyService.LedMode = lmRain) then
    keyService.ActiveGif := keyService.RainGif
  else if (keyService.LedMode = lmReactive) then
    keyService.ActiveGif := keyService.ReactiveGif
  else if (keyService.LedMode = lmRipple) then
    keyService.ActiveGif := keyService.RippleGif
  else if (keyService.LedMode = lmFireball) then
  begin
    case keyService.LedDirection of
      LED_DIR_LEFT_INT: keyService.ActiveGif := keyService.FireballLeftGif;
      LED_DIR_RIGHT_INT: keyService.ActiveGif := keyService.FireballRightGif;
    end;
  end
  else if (keyService.LedMode = lmStarlight) then
    keyService.ActiveGif := keyService.StarlightGif
  else if (keyService.LedMode = lmLoop) then
  begin
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
    begin
      case keyService.LedDirection of
        LED_DIR_DOWN_INT: keyService.ActiveGif := keyService.LoopDownGif;
        LED_DIR_LEFT_INT: keyService.ActiveGif := keyService.LoopLeftGif;
        LED_DIR_UP_INT: keyService.ActiveGif := keyService.LoopUpGif;
        LED_DIR_RIGHT_INT: keyService.ActiveGif := keyService.LoopRightGif;
      end;
    end
    else
    begin
      case keyService.LedDirection of
        LED_DIR_RIGHT_INT: keyService.ActiveGif := keyService.EdgeLoopRightGif;
        else keyService.ActiveGif := keyService.EdgeLoopLeftGif;
      end;
    end;
  end
  else if (keyService.LedMode = lmRebound) then
  begin
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
    begin
      case keyService.LedDirection of
        LED_DIR_UP_INT: keyService.ActiveGif := keyService.ReboundVerGif;
        LED_DIR_LEFT_INT: keyService.ActiveGif := keyService.ReboundHorGif;
        else keyService.ActiveGif := keyService.ReboundHorGif
      end;
    end
    else
      keyService.ActiveGif := keyService.EdgeReboundGif;
  end
  else
    keyService.ActiveGif := nil;

  if (keyService.ActiveGif <> nil) then
  begin
    case keyService.LedSpeed of
      1: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
             interval := 250
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 1000
          else if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 450
          else if (keyService.LedMode in [lmRain]) then
             interval := 500;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 200;
        end;
      end;
      2: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
             interval := 220
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 900
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 400;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 180;
        end;
      end;
      3: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
             interval := 200
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 800
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 350;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 140;
        end;
      end;
      4: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple]) then
             interval := 170
          else if (keyService.LedMode in [lmFireball, lmReactive]) then
             interval := 180
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 700
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 300;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 120;
        end;
      end;
      5: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
             interval := 140
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 600
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 250;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 100;
        end;
      end;
      6: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
             interval := 110
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 500
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 200;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 80;
        end;
      end;
      7: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
        if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
           interval := 80
        else if (keyService.LedMode in [lmStarlight]) then
           interval := 400
        else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
           interval := 150;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 60;
        end;
      end;
      8: begin
         if (keyService.ConfigMode = CONFIG_LIGHTING) then
         begin
          if (keyService.LedMode in [lmRipple, lmFireball, lmReactive]) then
             interval := 50
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 300
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 100;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 40;
        end;
      end;
      9: begin
        if (keyService.ConfigMode = CONFIG_LIGHTING) then
        begin
          if (keyService.LedMode in [lmRipple]) then
             interval := 10
          else if (keyService.LedMode in [lmFireball, lmReactive]) then
             interval := 30
          else if (keyService.LedMode in [lmStarlight]) then
             interval := 200
          else if (keyService.LedMode in [lmRebound, lmLoop, lmRain]) then
             interval := 50;
        end
        else
        begin
          if (keyService.LedMode in [lmRebound, lmLoop]) then
             interval := 20;
        end;
      end;
    end;
    NewGifTimer.Interval := interval;

    if (gifFrameIdx = (keyService.ActiveGif.Count)) then
      gifFrameIdx := 1
    else
      inc(gifFrameIdx);

    ReloadKeyButtonsColor;

    NewGifTimer.Enabled := true;
  end;
end;

procedure TFormMainTKO.bCoTriggerClick(Sender: TObject);
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

procedure TFormMainTKO.btnZoneBtnClick(Sender: TObject);
begin
  if (sender = btnZoneAllKeys) then
    SetZoneColor(ztAll)
  else if (sender = btnZoneHyperspace) then
    SetZoneColor(ztHyperspace)
  else if (sender = btnZoneWASDKeys) then
    SetZoneColor(ztWASD)
  else if (sender = btnZoneModifiers) then
    SetZoneColor(ztModifiers)
  else if (sender = btnZoneNumberRow) then
    SetZoneColor(ztNumber)
  else if (sender = btnZoneHomeRow) then
    SetZoneColor(ztHome)
  else if (sender = btnZoneMediaKeys) then
    SetZoneColor(ztMedia)
  else if (sender = btnZoneNavKeys) then
    SetZoneColor(ztNavigation)
  else if (sender = btnZoneFunctionKeys) then
    SetZoneColor(ztFunction)
  else if (sender = btnZoneArrowKeys) then
    SetZoneColor(ztArrow);
end;

procedure TFormMainTKO.imgProfileClick(Sender: TObject);
begin
  //if (pnlSelectProfile.Visible) then
  //begin
  //  ResetProfileMenu;
  //end
  //else
  //begin
  //  profileMode := pmSelect;
  //  pnlSelectProfile.Left := imgProfile.Left;
  //  pnlSelectProfile.Width := imgProfile.Width;
  //  pnlSelectProfile.Top := imgProfile.Top + imgProfile.Height;
  //  pnlSelectProfile.Visible := true;
  //  //SetMousePosition(pnlSelectProfile.Left + 50, pnlSelectProfile.Top + 10);
  //  LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);
  //end;
end;

procedure TFormMainTKO.imgProfileMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  if (imgProfile.Enabled) then
  begin
    profileMode := pmSelect;
    LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);

    pt.x := Mouse.CursorPos.x;
    pt.y := Mouse.CursorPos.y;
    popProfileMenu.PopUp(pt.x - x, pt.y + ((Sender as TImage).Height - y));
  end;
end;

procedure TFormMainTKO.imgProfileMouseLeave(Sender: TObject);
begin
  if (pnlSelectProfile.Visible = false) then
    LoadButtonImage(sender, imgListProfileDefault, currentProfileNumber);
end;

procedure TFormMainTKO.imgProfileMouseEnter(Sender: TObject);
begin
  LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);
end;

procedure TFormMainTKO.imgProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //LoadButtonImage(sender, imgListProfileHover, currentProfileNumber);
end;

procedure TFormMainTKO.lbProfileMouseLeave(Sender: TObject);
begin
  //if (not MouseInControl(lbProfile)) then
     ResetProfileMenu;
end;

procedure TFormMainTKO.memoMacroKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key := 0;
end;

function TFormMainTKO.MouseInControl(oControl: TControl): boolean;
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

procedure TFormMainTKO.btnExportClick(Sender: TObject);
begin
  ShowExport(currentLayoutFile, currentLedFile, backColor, fontColor);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnHelpClick(Sender: TObject);
begin
  NeedInput := true;
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.SetFirmwareVersion(fileService.FirmwareVersionKBD, fileService.FirmwareVersionLED);
  FormAbout.ShowModal;
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
  NeedInput := false;
end;

procedure TFormMainTKO.btnImportClick(Sender: TObject);
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
            SetSaveState(ssModified);
            if (keyService.ConfigMode <> CONFIG_LIGHTING) then
              SetConfigMode(CONFIG_LIGHTING);
          end
          else if (keyService.IsLayoutFile(fileContent)) then
          begin
            LoadKeyboardLayout(OpenDialog.FileName, fileContent);
            SetSaveState(ssModified);
            if (keyService.ConfigMode <> CONFIG_LAYOUT) then
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

procedure TFormMainTKO.SetZoneColor(zoneType: TZoneType);
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
      ztHyperspace:
      begin
        SetSingleKeyColor(lbRow5_4, keyColor);
        SetSingleKeyColor(lbRow5_5, keyColor);
        SetSingleKeyColor(lbRow5_6, keyColor);
      end;
      ztWASD: begin
        SetSingleKeyColor(lbRow2_3, keyColor);
        SetSingleKeyColor(lbRow3_2, keyColor);
        SetSingleKeyColor(lbRow3_3, keyColor);
        SetSingleKeyColor(lbRow3_4, keyColor);
      end;
      ztNumber: begin
        SetSingleKeyColor(lbRow1_2, keyColor);
        SetSingleKeyColor(lbRow1_3, keyColor);
        SetSingleKeyColor(lbRow1_4, keyColor);
        SetSingleKeyColor(lbRow1_5, keyColor);
        SetSingleKeyColor(lbRow1_6, keyColor);
        SetSingleKeyColor(lbRow1_7, keyColor);
        SetSingleKeyColor(lbRow1_8, keyColor);
        SetSingleKeyColor(lbRow1_9, keyColor);
        SetSingleKeyColor(lbRow1_10, keyColor);
        SetSingleKeyColor(lbRow1_11, keyColor);
        SetSingleKeyColor(lbRow1_12, keyColor);
        SetSingleKeyColor(lbRow1_13, keyColor);
      end;
      ztModifiers: begin
        SetSingleKeyColor(lbRow5_1, keyColor);
        SetSingleKeyColor(lbRow5_2, keyColor);
        SetSingleKeyColor(lbRow5_3, keyColor);
        SetSingleKeyColor(lbRow5_7, keyColor);
        SetSingleKeyColor(lbRow5_10, keyColor);
      end;
      ztHome: begin
        SetSingleKeyColor(lbRow3_2, keyColor);
        SetSingleKeyColor(lbRow3_3, keyColor);
        SetSingleKeyColor(lbRow3_4, keyColor);
        SetSingleKeyColor(lbRow3_5, keyColor);
        SetSingleKeyColor(lbRow3_8, keyColor);
        SetSingleKeyColor(lbRow3_9, keyColor);
        SetSingleKeyColor(lbRow3_10, keyColor);
        SetSingleKeyColor(lbRow3_11, keyColor);
      end;
      ztMedia: begin
        if (keyService.ActiveLayer <> nil) and (keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX) then
        begin
          SetSingleKeyColor(lbRow2_3, keyColor);
          SetSingleKeyColor(lbRow2_4, keyColor);
          SetSingleKeyColor(lbRow2_5, keyColor);
          SetSingleKeyColor(lbRow3_3, keyColor);
          SetSingleKeyColor(lbRow3_4, keyColor);
          SetSingleKeyColor(lbRow3_5, keyColor);
        end;
      end;
      ztNavigation: begin
        if (keyService.ActiveLayer <> nil) and (keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX) then
        begin
          SetSingleKeyColor(lbRow2_11, keyColor);
          SetSingleKeyColor(lbRow2_12, keyColor);
          SetSingleKeyColor(lbRow3_11, keyColor);
          SetSingleKeyColor(lbRow3_12, keyColor);
        end;
      end;
      ztFunction: begin
        if (keyService.ActiveLayer <> nil) and (keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX) then
        begin
          SetSingleKeyColor(lbRow1_2, keyColor);
          SetSingleKeyColor(lbRow1_3, keyColor);
          SetSingleKeyColor(lbRow1_4, keyColor);
          SetSingleKeyColor(lbRow1_5, keyColor);
          SetSingleKeyColor(lbRow1_6, keyColor);
          SetSingleKeyColor(lbRow1_7, keyColor);
          SetSingleKeyColor(lbRow1_8, keyColor);
          SetSingleKeyColor(lbRow1_9, keyColor);
          SetSingleKeyColor(lbRow1_10, keyColor);
          SetSingleKeyColor(lbRow1_11, keyColor);
          SetSingleKeyColor(lbRow1_12, keyColor);
          SetSingleKeyColor(lbRow1_13, keyColor);
        end;
      end;
      ztArrow: begin
        if (keyService.ActiveLayer <> nil) and (keyService.ActiveLayer.LayerIndex = BOTLAYER_IDX) then
        begin
          SetSingleKeyColor(lbRow2_9, keyColor);
          SetSingleKeyColor(lbRow3_8, keyColor);
          SetSingleKeyColor(lbRow3_9, keyColor);
          SetSingleKeyColor(lbRow3_10, keyColor);
        end;
      end;
    end;
    SetSaveState(ssModified);
  end;
end;

procedure TFormMainTKO.LoadGif(speed: integer; direction: integer);
var
  gifToLoad: string;
begin
  // gifToLoad := '';
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

procedure TFormMainTKO.SetColorWave(arrayButton: array of TLabelBox; colorIdx: integer;
  invertColors: boolean; gradient: boolean = false);
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

procedure TFormMainTKO.continueClick(Sender: TObject);
begin
  CloseDialog(mrOk);
end;

procedure TFormMainTKO.KeyButtonClick(Sender: TObject);
begin
  SetActiveKeyButton(sender as TLabelBox);
end;

procedure TFormMainTKO.KeyButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

function TFormMainTKO.EditingMacro(showWarning: boolean = false): boolean;
begin
  result := pnlMacro.Visible;
  if (result and showWarning) then
    ShowDialog('Macro', 'Please close Macro Editor before proceeding', mtWarning, [mbOk]);
end;

procedure TFormMainTKO.SetKeyButtonText(keybutton: TLabelBox; btnText: string);
begin
  keyButton.Caption := btnText;
end;

function TFormMainTKO.ValidateBeforeDone: boolean;
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
end;

function TFormMainTKO.AcceptMacro: boolean;
begin
  result := true;
  KeyModified := false;
  MacroModified := false;
  SetWindowsCombo(false);
  if (IsKeyLoaded) then
  begin
    if ValidateBeforeDone then
    begin
      SetSaveState(ssModified);
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

procedure TFormMainTKO.CancelMacro;
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

function TFormMainTKO.GetKeyButtonUnderMouse(btnList: TObjectList; x: integer; y:integer): TLabelBox;
var
  i: integer;
  keyButton: TLabelBox;
  found: boolean;
begin
  i := 0;
  result := nil;
  found := false;
  While (i < btnList.Count) and (not found) do
  begin
    if (btnList[i] is TLabelBox) then
    begin
      keyButton := (btnList[i] as TLabelBox);
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

procedure TFormMainTKO.btnCloseMacroClick(Sender: TObject);
begin
  CloseMacroEditor;
end;

procedure TFormMainTKO.btnMouseClicksMacroClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt.x := Mouse.CursorPos.x;
  pt.y := Mouse.CursorPos.y;
  popMouseClicks.PopUp(pt.x, pt.y);
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnCommonShortcutsClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt.x := Mouse.CursorPos.x;
  pt.y := Mouse.CursorPos.y;
  popCommonShortcuts.PopUp(pt.x, pt.y);
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnDiagnosticClick(Sender: TObject);
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

procedure TFormMainTKO.btnDoneClick(Sender: TObject);
begin
  DoneKey;
  SetHovered(sender, false, true);
end;

function TFormMainTKO.DoneKey: boolean;
begin
  result := false;
  if IsKeyLoaded then
  begin
    if ValidateBeforeDone then
    begin
      result := true;
      KeyModified := false;
      MacroModified := false;
      SetSaveState(ssModified);
      activeKbKey.IsMacro := (activeKbKey.Macro1.Count > 0) or (activeKbKey.Macro2.Count > 0) or (activeKbKey.Macro3.Count > 0);
      //SetMacroMode(false);
      SetActiveKeyButton(nil);
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMainTKO.btnDoneMacroClick(Sender: TObject);
begin
  AcceptMacro;
end;

procedure TFormMainTKO.btnFirmwareClick(Sender: TObject);
begin
  ShowFirmware(GActiveDevice, backColor, fontColor, activeColor);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnCancelMacroClick(Sender: TObject);
begin
  CancelMacro;
end;

procedure TFormMainTKO.btnCancelClick(Sender: TObject);
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

procedure TFormMainTKO.btnResetAllClick(Sender: TObject);
var
  sMessage: string;
  i: integer;
begin
  if (keyService.ConfigMode = CONFIG_LAYOUT) then
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
      SetSaveState(ssModified);
    end;
  end
  else if (keyService.ConfigMode in [CONFIG_LIGHTING, CONFIG_EDGE_LIGHTING]) and (keyService.LedMode in [lmFreestyle, lmBreathe]) then
  begin
    sMessage := 'Do you want to reset the current Lighting profile?' + #10 + 'All assigned colors will be lost.';
    if (keyService.LedMode = lmFreestyle) then
      sMessage := 'Do you want to erase color assignments for each key';
    if ShowDialog('Reset Lighting', sMessage,
          mtConfirmation, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      keyService.SetAllKeyColor(clNone, TOPLAYER_IDX);
      keyService.SetAllKeyColor(clNone, BOTLAYER_IDX);
      keyService.SetAllKeyColorEdge(clNone, TOPLAYER_IDX);
      keyService.SetAllKeyColorEdge(clNone, BOTLAYER_IDX);
      ReloadKeyButtonsColor(true);
      SetSaveState(ssModified);
    end;
  end;
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnTimingDelaysClick(Sender: TObject);
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

procedure TFormMainTKO.btnWindowsCombosClick(Sender: TObject);
begin
  ResetPopupMenuMacro;
  if (IsKeyLoaded) then
    SetWindowsCombo(not WindowsComboOn);
end;

procedure TFormMainTKO.chkGlobalSpeedClick(Sender: TObject);
begin
  if (not loadingMacro) and IsKeyLoaded then
  begin
    activeKbKey.ActiveMacro.MacroSpeed := 0;
    MacroModified := true;
    sliderMacroSpeedChange(sender);
  end;
end;

procedure TFormMainTKO.chkRepeatMultiplayClick(Sender: TObject);
begin
  if (not loadingMacro) and IsKeyLoaded then
  begin
    activeKbKey.ActiveMacro.MacroRptFreq := 0;
    MacroModified := true;
    sliderMultiplayChange(sender);
  end;
end;

procedure TFormMainTKO.MenuDrawItem(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; AState: TOwnerDrawState);
var
  mnu: TMenuItem;
begin
  mnu := (sender as TMenuItem);
  aCanvas.brush.color := KINESIS_DARK_GRAY_RGB;
  acanvas.brush.style := bsSolid;
  if (odSelected in AState) then
    aCanvas.font.color := KINESIS_BLUE_EDGE
  else
    aCanvas.font.color := KINESIS_FONT_COLOR_RGB;
  aCanvas.Font.Name := self.Font.Name;

    aCanvas.Font.Size := 13;
  aCanvas.fillrect( aRect );
  acanvas.textrect( aRect, arect.left+4, arect.top+2, mnu.caption );
end;

procedure TFormMainTKO.btnResetKeyClick(Sender: TObject);
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
      SetSaveState(ssModified);
      SetActiveKeyButton(nil);
    end;
    RefreshRemapInfo;
  end
  else
    ShowDialog('Reset key', 'You must select a key to reset', mtWarning, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.sliderMultiplayChange(Sender: TObject);
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

procedure TFormMainTKO.sliderMultiplayMouseUp(Sender: TObject;
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

procedure TFormMainTKO.sliderMacroSpeedChange(Sender: TObject);
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

procedure TFormMainTKO.sliderMacroSpeedMouseUp(Sender: TObject; Button: TMouseButton;
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

procedure TFormMainTKO.rgbKeyDown(Sender: TObject; var Key: Word;
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

procedure TFormMainTKO.rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
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

procedure TFormMainTKO.GetRBGEditColor;
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

procedure TFormMainTKO.ImageMenuClick(Sender: TObject);
begin

end;

procedure TFormMainTKO.GetRBGEditBaseColor;
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

procedure TFormMainTKO.rgbExit(Sender: TObject);
var
  edit: TEdit;
begin
  edit := (Sender as TEdit);
  if (edit = eRed) or (edit = eGreen) or (edit = eBlue) then
    GetRBGEditColor
  else if (edit = eRedBase) or (edit = eGreenBase) or (edit = eBlueBase) then
    GetRBGEditBaseColor;
end;

procedure TFormMainTKO.eHTMLExit(Sender: TObject);
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

procedure TFormMainTKO.eHTMLKeyDown(Sender: TObject; var Key: Word;
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

procedure TFormMainTKO.FormResize(Sender: TObject);
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

procedure TFormMainTKO.gifViewerStart(Sender: TObject);
begin
  if (keyService.LedMode in [lmBreathe, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain, lmPulse, lmSpectrum, lmWave]) then
  begin
    if (keyService.ConfigMode = CONFIG_LIGHTING) then
      ShowHideKeyButtons(true)
    else if (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
      ShowHideEdgeButtons(true);
  end;
end;

procedure TFormMainTKO.imgKeyboardLightingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  keyButton: TLabelBox;
begin
  if (keyService.LedMode in [lmFreestyle, lmBreathe]) then
  begin
    keyButton := GetKeyButtonUnderMouse(keyBtnList, X + imgKeyboardLighting.Left, Y + imgKeyboardLighting.Top);
    SetSingleKeyColor(keybutton, ringPicker.SelectedColor);
  end;
end;

procedure TFormMainTKO.imgKeyboardEdgeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  keyButton: TLabelBox;
begin
  if (keyService.LedMode in [lmFreestyle, lmBreathe]) then
  begin
    keyButton := GetKeyButtonUnderMouse(edgeBtnList, X + imgKeyboardEdge.Left, Y + imgKeyboardEdge.Top);
    SetSingleKeyColor(keybutton, ringPicker.SelectedColor);
  end;
end;

procedure TFormMainTKO.btnMacroClick(Sender: TObject);
begin
  if (EditingMacro) then
    CloseMacroEditor
  else
    OpenMacroEditor;
end;

procedure TFormMainTKO.btnTapAndHoldClick(Sender: TObject);
begin
  OpenTapAndHold;
end;

procedure TFormMainTKO.btnLeftMenuClick(Sender: TObject);
var
  aButton: TColorSpeedButtonCS;
begin
  aButton := (sender as TColorSpeedButtonCS);

  SetCurrentMenuAction(maNone, aButton);
  if (keyService.ConfigMode = CONFIG_LIGHTING) or (keyService.ConfigMode = CONFIG_EDGE_LIGHTING) then
  begin
    SetLedMode(GetLedMode);
    SetSaveState(ssModified);
  end;

  if (sender = btnFrozenWave) then
  begin
    SetFrozenWave;
  end;
end;

procedure TFormMainTKO.SetFrozenWave;
begin
  SetSingleKeyColor(lbEdgeL1, RGB(255, 128, 0));
  SetSingleKeyColor(lbEdgeL2, RGB(255, 0, 0));
  SetSingleKeyColor(lbEdgeL3, RGB(255, 0, 128));
  SetSingleKeyColor(lbEdgeL4, RGB(255, 0, 255));
  SetSingleKeyColor(lbEdgeL5, RGB(128, 0, 255));
  SetSingleKeyColor(lbEdgeL6, RGB(0, 0, 255));
  SetSingleKeyColor(lbEdgeL7, RGB(0, 128, 255));
  SetSingleKeyColor(lbEdgeL8, RGB(0, 255, 255));
  SetSingleKeyColor(lbEdgeL9, RGB(0, 255, 128));

  SetSingleKeyColor(lbEdgeR9, RGB(255, 128, 0));
  SetSingleKeyColor(lbEdgeR8, RGB(255, 0, 0));
  SetSingleKeyColor(lbEdgeR7, RGB(255, 0, 128));
  SetSingleKeyColor(lbEdgeR6, RGB(255, 0, 255));
  SetSingleKeyColor(lbEdgeR5, RGB(128, 0, 255));
  SetSingleKeyColor(lbEdgeR4, RGB(0, 0, 255));
  SetSingleKeyColor(lbEdgeR3, RGB(0, 128, 255));
  SetSingleKeyColor(lbEdgeR2, RGB(0, 255, 255));
  SetSingleKeyColor(lbEdgeR1, RGB(0, 255, 128));

  SetSingleKeyColor(lbEdgeB1, RGB(0, 255, 0));
  SetSingleKeyColor(lbEdgeB2, RGB(128, 255, 0));
  SetSingleKeyColor(lbEdgeB3, RGB(255, 255, 0));
  SetSingleKeyColor(lbEdgeB4, RGB(255, 128, 0));
  SetSingleKeyColor(lbEdgeB5, RGB(255, 0, 0));
  SetSingleKeyColor(lbEdgeB6, RGB(255, 0, 128));
  SetSingleKeyColor(lbEdgeB7, RGB(255, 0, 255));
  SetSingleKeyColor(lbEdgeB8, RGB(128, 0, 255));
  SetSingleKeyColor(lbEdgeB9, RGB(0, 0, 255));
  SetSingleKeyColor(lbEdgeB10, RGB(0, 128, 255));
  SetSingleKeyColor(lbEdgeB11, RGB(0, 255, 255));
  SetSingleKeyColor(lbEdgeB12, RGB(0, 255, 128));
  SetSingleKeyColor(lbEdgeB13, RGB(0, 255, 0));
  SetSingleKeyColor(lbEdgeB14, RGB(128, 255, 0));
  SetSingleKeyColor(lbEdgeB15, RGB(255, 255, 0));
end;

procedure TFormMainTKO.btnMacModifiersClick(Sender: TObject);
begin
  SetMacModifiersHotkeys;
end;

procedure TFormMainTKO.btnDisableKeyClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
    SetModifiedKey(VK_NULL, '', false, false, true, true);
end;

procedure TFormMainTKO.btnEjectClick(Sender: TObject);
begin
  EjectDevice(GActiveDevice);
  (sender as TColorSpeedButtonCS).Down := false;
  SetHovered(sender, false, true);
end;

procedure TFormMainTKO.btnBacklightClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
    SetModifiedKey(VK_LED, '', false, false, true, true);
end;

procedure TFormMainTKO.lblGlobalSpeedClick(Sender: TObject);
begin
  chkGlobalSpeed.Checked := not chkGlobalSpeed.Checked;
end;

procedure TFormMainTKO.lblRepeatMultiplayClick(Sender: TObject);
begin
  chkRepeatMultiplay.Checked := not chkRepeatMultiplay.Checked;
end;

procedure TFormMainTKO.lbMenuMacroMouseLeave(Sender: TObject);
begin
  ResetPopupMenuMacro;
end;

procedure TFormMainTKO.lbMenuMouseLeave(Sender: TObject);
begin
  ResetPopupMenu;
end;

procedure TFormMainTKO.OpenTapAndHold;
var
  customBtns: TCustomButtons;
  keyOtherLayer: TKBKey;
  otherLayer: TKBLayer;
begin
  if (IsKeyLoaded) then
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
        SetSaveState(ssModified);
        keyService.SetTapAndHold(activeKbKey, FormTapAndHold.tapAction, FormTapAndHold.holdAction, FormTapAndHold.timingDelay);
        UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
        RefreshRemapInfo;
      end;
    end;
  end;
end;

procedure TFormMainTKO.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win64}
  SendMessage(imgBackground.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardBack.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgEdgeBack.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardLayout.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardLighting.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  SendMessage(imgKeyboardEdge.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}
  //jm todo SendMessage(memoMacro.Handle, LM_SETREDRAW, WPARAM(False), 0);
  {$endif}
end;

procedure TFormMainTKO.ResetPopupMenu;
begin
  pnlMenu.Visible := false;
  currentPopupMenu := nil;
end;

procedure TFormMainTKO.ResetPopupMenuMacro;
begin
  pnlMenuMacro.Visible := false;
end;

procedure TFormMainTKO.ResetSingleKey;
begin
  //btnLEDControl.Down := false;
  //btnDisableKey.Down := false;
  //lblLedControl.Font.Color := KINESIS_FONT_COLOR_RGB;
  //lblDisableKey.Font.Color := KINESIS_FONT_COLOR_RGB;
end;

procedure TFormMainTKO.ResetProfileMenu;
begin
  profileMode := pmNone;
  pnlSelectProfile.Visible := false;
  LoadButtonImage(imgProfile, imgListProfileDefault, currentProfileNumber);
  SetHovered(btnSaveAs, false, true);
  btnSaveAs.Down := false;
end;

procedure TFormMainTKO.ResetDirection;
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

procedure TFormMainTKO.SetDirection(direction: integer; ledMode: TLedMode);
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

procedure TFormMainTKO.btnDirectionClick(Sender: TObject);
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
    SetSaveState(ssModified);
    if (keyService.LedMode in [lmRain, lmReactive, lmRipple, lmFireball, lmLoop, lmRebound, lmStarlight]) then
    begin
      ResetNewGif;
      NewGifTimer.Enabled := true;
    end
    else
      LoadGifTimer.Enabled := true;
  end;
end;

procedure TFormMainTKO.knobSpeedChange(Sender: TObject);
begin
  lblSpeedText.Caption := IntToStr(Round(knobSpeed.Position));
end;

procedure TFormMainTKO.knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
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
      SetSaveState(ssModified);
      knobSpeed.Enabled := false;
      LoadGifTimer.Enabled := false;
      BreatheTimer.Enabled := false;
      SpectrumTimer.Enabled := false;
      WaveTimer.Enabled := false;
      NewGifTimer.Enabled := false;
      if (keyService.LedMode in [lmBreathe, lmPulse]) then
      begin
        ResetBreathe;
        BreatheTimer.Enabled := true;
      end
      else if (keyService.LedMode in [lmSpectrum]) then
      begin
        ResetSpectrum;
        SpectrumTimer.Enabled := true;
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
      else if not(keyService.LedMode in [lmFrozenWave]) then
      begin
        LoadGifTimer.Enabled := true;
      end;
      knobSpeed.Enabled := true;
    end;
  end;

end;

procedure TFormMainTKO.miAddCustColorClick(Sender: TObject);
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

procedure TFormMainTKO.colorPreMixedClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorChange((Sender as TmbColorPreview).Color);
  AfterColorChange;
end;

procedure TFormMainTKO.colorPreMixedBaseClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorChangeBase((Sender as TmbColorPreview).Color);
  AfterColorChangeBase;
end;

procedure TFormMainTKO.custColorClick(Sender: TObject; Button: TMouseButton;
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

procedure TFormMainTKO.custColorBaseClick(Sender: TObject; Button: TMouseButton;
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

procedure TFormMainTKO.custColorChange(Sender: TObject);
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

procedure TFormMainTKO.colorPreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then   {check if left mouse button was pressed}
    (Sender as TmbColorPreview).BeginDrag(true);  {starting the drag operation}
end;

procedure TFormMainTKO.custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (Source is TmbColorPreview) then
    (Sender as TmbColorPreview).Color := (Source as TmbColorPreview).Color;
end;

procedure TFormMainTKO.custColorDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source is TmbColorPreview) then
    Accept := true;
end;

procedure TFormMainTKO.ringPickerChange(Sender: TObject);
begin
  if (not loadingColor) then
  begin
    ColorChange(ringPicker.SelectedColor);
    AfterColorChange;
  end;
end;

procedure TFormMainTKO.ringPickerBaseChange(Sender: TObject);
begin
  if (not loadingColorBase) then
  begin
    ColorChangeBase(ringPickerBase.SelectedColor);
    AfterColorChangeBase;
  end;
end;

procedure TFormMainTKO.ColorChange(newColor: TColor);
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
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmReactive]) then
      begin
        keyService.LedColorReactive := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmRipple]) then
      begin
        keyService.LedColorRipple := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmFireball]) then
      begin
        keyService.LedColorFireball := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmStarlight]) then
      begin
        keyService.LedColorStarlight := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmRebound]) then
      begin
        keyService.LedColorRebound := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmLoop]) then
      begin
        keyService.LedColorLoop := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmRain]) then
      begin
        keyService.LedColorRain := newColor;
        SetSaveState(ssModified);
      end;
    end;
  finally
    loadingColor := false;
  end;
end;

procedure TFormMainTKO.ColorChangeBase(newColor: TColor);
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
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmRipple]) then
      begin
        keyService.BaseLedColorRipple := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmFireball]) then
      begin
        keyService.BaseLedColorFireball := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmStarlight]) then
      begin
        keyService.BaseLedColorStarlight := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmRebound]) then
      begin
        keyService.BaseLedColorRebound := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmLoop]) then
      begin
        keyService.BaseLedColorLoop := newColor;
        SetSaveState(ssModified);
      end
      else if (keyService.LedMode in [lmRain]) then
      begin
        keyService.BaseLedColorRain := newColor;
        SetSaveState(ssModified);
      end;
    end;
  finally
    loadingColorBase := false;
  end;
end;

procedure TFormMainTKO.AfterColorChange;
begin
  if (keyService.LedMode in [lmMonochrome, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain]) then
  begin
    MonochromeTimer.Enabled := true;
  end;
end;

procedure TFormMainTKO.AfterColorChangeBase;
begin
  if (keyService.LedMode in [lmMonochrome, lmReactive, lmStarlight, lmRebound, lmRipple, lmFireball, lmLoop, lmRain]) then
  begin
    //MonochromeTimer.Enabled := true;
  end;
end;

procedure TFormMainTKO.MonochromeTimerTimer(Sender: TObject);
begin
  ReloadKeyButtonsColor;
  MonochromeTimer.Enabled := false;
end;

procedure TFormMainTKO.ChangeActiveLayer(layerIdx: integer);
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

procedure TFormMainTKO.swLayerSwitchClick(Sender: TObject);
begin
  if (swLayerSwitch.Checked) then
    ChangeActiveLayer(TOPLAYER_IDX)
  else
    ChangeActiveLayer(BOTLAYER_IDX);
end;

procedure TFormMainTKO.TopMenuClick(Sender: TObject);
begin
  if (sender = pnlLayoutBtn) and (keyService.ConfigMode <> CONFIG_LAYOUT) then
  begin
    SetConfigMode(CONFIG_LAYOUT);
  end
  else if (sender = pnlKeyLightingBtn) and (keyService.ConfigMode <> CONFIG_LIGHTING) then
  begin
    SetConfigMode(CONFIG_LIGHTING);
  end
  else if (sender = pnlEdgeLightingBtn) and (keyService.ConfigMode <> CONFIG_EDGE_LIGHTING) then
  begin
    SetConfigMode(CONFIG_EDGE_LIGHTING);
  end;
end;

function TFormMainTKO.GetMenuActionByType(actionType: TMenuActionType): TMenuAction;
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

function TFormMainTKO.GetMenuActionByButton(buttonName: string): TMenuAction;
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

procedure TFormMainTKO.ResetAllMenuAction;
var
  i:integer;
  menuAction: TMenuAction;
begin
  menuAction := nil;

  for i:=0 to menuActionList.Count - 1 do
  begin
    menuAction := (menuActionList.Items[i] as TMenuAction);
    menuAction.IsDown := false;

    if (menuAction.ActionImage <> nil) then
      menuAction.ActionImage.Picture.Clear;
    if (menuAction.ActionLabel <> nil) and (menuAction.IsEnabled) then
      menuAction.ActionLabel.Font.Color := KINESIS_FONT_COLOR_RGB
    else if (menuAction.ActionLabel <> nil) then
      menuAction.ActionLabel.Font.Color := KINESIS_MED_GRAY_RGB;
  end;
end;

procedure TFormMainTKO.SetCurrentMenuAction(aType: TMenuActionType; aButton: TColorSpeedButtonCS);
var
  aMenuAction: TMenuAction;
  customBtns: TCustomButtons;
begin
  if (aType <> maNone) then
    aMenuAction := GetMenuActionByType(aType)
  else if (aButton <> nil) then
    aMenuAction := GetMenuActionByButton(aButton.Name)
  else
    aMenuAction := nil;

  if (aMenuAction <> currentMenuAction) then
  begin
    if (aMenuAction <> nil) and (not aMenuAction.IsEnabled) then
    begin
      createCustomButton(customBtns, 'OK', 100, nil, bkOK);
      ShowDialog(aMenuAction.ActionButton.Caption, 'To utilize ' + aMenuAction.ActionLabel.Caption + ', please download and install the latest firmware.',
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
      end;

      if (keyService.ConfigMode = CONFIG_LAYOUT) then
      begin
        SetMacroMode((currentMenuAction <> nil) and (currentMenuAction.ActionType = maMacro));
      end;
    end;
  end;
end;

procedure TFormMainTKO.SetMacroMenuItems(button: TColorSpeedButtonCS);
begin
  ResetPopupMenuMacro;

  if (IsKeyLoaded) then
  begin
    lbMenuMacro.Items.Clear;
    activeMacroMenu := button.Name;

    //if (button = btnCommonShortcuts) then
    //begin
    //  lbMenuMacro.Items.AddObject('Cut', TObject(VK_CUT));
    //  lbMenuMacro.Items.AddObject('Copy', TObject(VK_COPY));
    //  lbMenuMacro.Items.AddObject('Paste', TObject(VK_PASTE));
    //  lbMenuMacro.Items.AddObject('Select All', TObject(VK_SELECTALL));
    //  lbMenuMacro.Items.AddObject('Undo', TObject(VK_UNDO));
    //  {$ifdef Win64} //Windows
    //  lbMenuMacro.Items.AddObject('Redo', TObject(VK_REDO));
    //  lbMenuMacro.Items.AddObject('Desktop', TObject(VK_DESKTOP));
    //  {$endif}
    //  lbMenuMacro.Items.AddObject('Last App', TObject(VK_LASTAPP));
    //  {$ifdef Win64} //Windows
    //    lbMenuMacro.Items.AddObject('Ctrl Alt Delete', TObject(VK_CTRLALTDEL));
    //  {$endif}
    //end;
    //else if (button = btnMouseClicksMacro) then
    //begin
    //  lbMenuMacro.Items.AddObject('Left Click', TObject(VK_MOUSE_LEFT));
    //  lbMenuMacro.Items.AddObject('Middle Click', TObject(VK_MOUSE_MIDDLE));
    //  lbMenuMacro.Items.AddObject('Right Click', TObject(VK_MOUSE_RIGHT));
    //  lbMenuMacro.Items.AddObject('Button 4', TObject(VK_MOUSE_BTN4));
    //  lbMenuMacro.Items.AddObject('Button 5', TObject(VK_MOUSE_BTN5));
    //  lbMenuMacro.Items.AddObject('Double-Click', TObject(VK_MOUSE_DBL_125));
    //end;

    if (lbMenuMacro.Items.Count > 0) then
    begin
      pnlMenuMacro.Height := (lbMenuMacro.Items.Count * lbMenuMacro.ItemHeight) + 10;
      pnlMenuMacro.Top := (pnlMacro.Top + button.Top) - pnlMenuMacro.Height;
      pnlMenuMacro.Left := pnlMacro.Left + button.Left;
      pnlMenuMacro.Visible := true;
    end;
  end;
end;

procedure TFormMainTKO.lbMenuMacroMouseMove(Sender: TObject; Shift: TShiftState;
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

procedure TFormMainTKO.lbMenuMouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TFormMainTKO.lbProfileClick(Sender: TObject);
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
        SetSaveState(ssNone);
      end;
    end
    else if (profileMode = pmSaveAs) then
    begin
      SaveAsAll(IntToStr(idxPos));
    end;
  end;

  ResetProfileMenu;
end;

procedure TFormMainTKO.lbProfileMouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TFormMainTKO.lbProfileDrawItem(Control: TWinControl; Index: Integer;
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

procedure TFormMainTKO.lbMenuDrawItem(Control: TWinControl; Index: Integer;
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

procedure TFormMainTKO.SetFnNumericKpLeft;
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
        SetSaveState(ssModified);

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

procedure TFormMainTKO.SetFnNumericKpRight;
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
        SetSaveState(ssModified);

        keyService.SetKBKeyIdx(aFnLayer, 7, VK_NUMLOCK);  //Replace Fn F7
        keyService.SetKBKeyIdx(aFnLayer, 8, VK_DIVIDE);  //Replace Fn F8
        keyService.SetKBKeyIdx(aFnLayer, 9, VK_MULTIPLY);  //Replace Fn F9
        keyService.SetKBKeyIdx(aFnLayer, 10, VK_SUBTRACT);  //Replace Fn F10

        keyService.SetKBKeyIdx(aFnLayer, 21, VK_NUMPAD7);  //Replace Fn Calc
        keyService.SetKBKeyIdx(aFnLayer, 22, VK_NUMPAD8);  //Replace Fn Up
        keyService.SetKBKeyIdx(aFnLayer, 23, VK_NUMPAD9);  //Replace Fn Pause
        keyService.SetKBKeyIdx(aFnLayer, 38, VK_ADD);  //Replace Fn Page Up

        keyService.SetKBKeyIdx(aFnLayer, 35, VK_NUMPAD4);  //Replace Fn Left
        keyService.SetKBKeyIdx(aFnLayer, 36, VK_NUMPAD5);  //Replace Fn Down
        keyService.SetKBKeyIdx(aFnLayer, 37, VK_NUMPAD6);  //Replace Fn Right
        keyService.SetKBKeyIdx(aFnLayer, 24, VK_ADD);  //Replace Fn Page Down

        keyService.SetKBKeyIdx(aFnLayer, 48, VK_NUMPAD1);  //Replace Fn m
        keyService.SetKBKeyIdx(aFnLayer, 49, VK_NUMPAD2);  //Replace Fn comma
        keyService.SetKBKeyIdx(aFnLayer, 50, VK_NUMPAD3);  //Replace Fn .
        keyService.SetKBKeyIdx(aFnLayer, 51, VK_NUMPADENTER);  //Replace Fn /
        keyService.SetKBKeyIdx(aFnLayer, 58, VK_NUMPAD0);  //Replace Fn right space
        keyService.SetKBKeyIdx(aFnLayer, 59, VK_DECIMAL);  //Replace Fn right alt

        SetActiveLayer(BOTLAYER_IDX);
        swLayerSwitch.Checked := false;
        RefreshRemapInfo;
      end;
    end;
  end;
end;


procedure TFormMainTKO.SetHyperspaceActions(key: integer);
var
  aTopLayer: TKBLayer;
  aFnLayer: TKBLayer;
  sMessage: string;
  aMacro: TKeyList;
begin
  if CheckSaveKey then
  begin
    aTopLayer := keyService.GetLayer(TOPLAYER_IDX);
    aFnLayer := keyService.GetLayer(BOTLAYER_IDX);

    KeyModified := true;
    SetSaveState(ssModified);

    //Reset hyperspace on both layers
    keyService.ResetKey(aTopLayer, 56);
    keyService.ResetKey(aTopLayer, 57);
    keyService.ResetKey(aTopLayer, 58);
    keyService.ResetKey(aFnLayer, 56);
    keyService.ResetKey(aFnLayer, 57);
    keyService.ResetKey(aFnLayer, 58);

    if (key = VK_TYPING_1) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_BACK);  //Replace middle space
      keyService.SetKBKeyIdx(aFnLayer, 57, VK_BACK);  //Replace Fn middle space
    end
    else if (key = VK_TYPING_2) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_LSHIFT);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_RSHIFT);  //Replace right space
      keyService.SetKBKeyIdx(aFnLayer, 56, VK_LSHIFT);  //Replace Fn left space
      keyService.SetKBKeyIdx(aFnLayer, 58, VK_RSHIFT);  //Replace Fn right space
    end
    else if (key = VK_TYPING_3) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_RETURN);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_BACK);  //Replace right space
      keyService.SetKBKeyIdx(aFnLayer, 57, VK_RETURN);  //Replace Fn middle space
      keyService.SetKBKeyIdx(aFnLayer, 58, VK_BACK);  //Replace Fn right space
    end
    else if (key = VK_CODING_1) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_FN_TOGGLE);  //Replace middle space
      keyService.SetKBKeyIdx(aFnLayer, 57, VK_FN_TOGGLE);  //Replace Fn middle space
      keyService.SetKBKeyIdx(aTopLayer, 60, VK_RWIN);  //Replace FNShift
      keyService.SetKBKeyIdx(aFnLayer, 60, VK_RWIN);  //Replace Fn FNShift
    end
    else if (key = VK_CODING_2) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_FN_SHIFT);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_FN_SHIFT);  //Replace right space
      keyService.SetKBKeyIdx(aFnLayer, 56, VK_FN_SHIFT);  //Replace fn left space
      keyService.SetKBKeyIdx(aFnLayer, 58, VK_FN_SHIFT);  //Replace fn right space
      keyService.SetKBKeyIdx(aTopLayer, 60, VK_APPS);  //Replace FNShift
      keyService.SetKBKeyIdx(aFnLayer, 60, VK_APPS);  //Replace Fn FNshift
    end
    else if (key = VK_CODING_3) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_ESCAPE);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_FN_SHIFT);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 60, VK_HYPER);  //Replace FNShift
      keyService.SetKBKeyIdx(aFnLayer, 56, VK_ESCAPE);  //Replace fn left space
      keyService.SetKBKeyIdx(aFnLayer, 57, VK_FN_SHIFT);  //Replace fn middle space
      keyService.SetKBKeyIdx(aFnLayer, 60, VK_HYPER);  //Replace fn FNShift
    end
    else if (key = VK_CODING_4) then
    begin
      MacroModified := true;
      aMacro := TKeyList.Create;

      keyService.SetKBKeyIdx(aTopLayer, 56, VK_LCL_OPEN_BRACKET);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_LCL_OPEN_BRACKET);  //Replace right space

      //Fn left space, Fn right space - {s5}{x1}{-lshft}{obrk}{+lshft}
      aMacro.MacroSpeed := 5;
      aMacro.MacroRptFreq := 1;
      aMacro.Add(keyService.GetKeyWithModifier(VK_LCL_OPEN_BRACKET, GetKeyModifierText(VK_LSHIFT)));
      keyService.SetKeyMacroIdx(aFnLayer, 56, aMacro);
      keyService.SetKeyMacroIdx(aFnLayer, 58, aMacro);

      //Free Macro
      FreeAndNil(aMacro);
    end
    else if (key = VK_CODING_5) then
    begin
      MacroModified := true;
      aMacro := TKeyList.Create;

      //Fn left space, Fn right space - {s5}{x1}{-lshft}{obrk}{+lshft}
      aMacro.MacroSpeed := 5;
      aMacro.MacroRptFreq := 1;
      aMacro.Add(keyService.GetKeyWithModifier(VK_LCL_OPEN_BRACKET, GetKeyModifierText(VK_LSHIFT)));
      keyService.SetKeyMacroIdx(aTopLayer, 56, aMacro);
      keyService.SetKeyMacroIdx(aTopLayer, 58, aMacro);

      keyService.SetKBKeyIdx(aTopLayer, 60, VK_FN_TOGGLE);  //Replace FNShift
      keyService.SetKBKeyIdx(aFnLayer, 56, VK_LCL_OPEN_BRACKET);  //Replace fn left space
      keyService.SetKBKeyIdx(aFnLayer, 58, VK_LCL_OPEN_BRACKET);  //Replace fn right space
      keyService.SetKBKeyIdx(aFnLayer, 60, VK_FN_TOGGLE);  //Replace fn FNShift

      //Free Macro
      FreeAndNil(aMacro);
    end
    else if (key = VK_OVERWATCH1) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_1);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_2);  //Replace right space
    end
    else if (key = VK_OVERWATCH2) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_V);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_R);  //Replace right space
    end
    else if (key = VK_FORTNITE) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_Z);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_X);  //Replace right space
    end
    else if (key = VK_CSGO1) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_R);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_K);  //Replace right space
    end
    else if (key = VK_CSGO2) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_LCONTROL);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_F1);  //Replace right space
    end
    else if (key = VK_WARCRAFT) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_NUMLOCK);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_1);  //Replace right space
    end
    else if (key = VK_MINECRAFT) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_LCONTROL);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_E);  //Replace right space
    end
    else if (key = VK_VALORANT) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_R);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_U);  //Replace right space
    end
    else if (key = VK_LEAGUE) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 56, VK_LMENU);  //Replace left space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_H);  //Replace right space
    end
    else if (key = VK_APEX) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_E);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_Q);  //Replace right space
    end
    else if (key = VK_DESTINY2) then
    begin
      keyService.SetKBKeyIdx(aTopLayer, 57, VK_F);  //Replace middle space
      keyService.SetKBKeyIdx(aTopLayer, 58, VK_V);  //Replace right space
    end;

    SetActiveLayer(TOPLAYER_IDX);
    swLayerSwitch.Checked := true;
    RefreshRemapInfo;
  end;
end;

procedure TFormMainTKO.SetMacModifiersHotkeys;
var
  i:integer;
  aLayer: TKBLayer;
begin
  if CheckSaveKey then
  begin
    if ShowDialog('Mac Modifiers', 'Insert Mac Modifiers?' + #10#10 + 'Note: Implementing this layout may overwrite existing macros/remaps.',
      mtWarning, [mbYes, mbNo], DEFAULT_DIAG_HEIGHT_RGB) = mrYes then
    begin
      KeyModified := true;
      SetSaveState(ssModified);

      for i := 0 to keyService.KBLayers.Count - 1 do
      begin
        aLayer := keyService.KBLayers[i];

        //LWIN - ALT
        keyService.SetKBKeyIdx(aLayer, 54, VK_MENU);

        //LALT - LWIN
        keyService.SetKBKeyIdx(aLayer, 55, VK_LWIN);

        //RALT - LWIN
        keyService.SetKBKeyIdx(aLayer, 59, VK_LWIN);

        //RCTRL - ALT
        keyService.SetKBKeyIdx(aLayer, 62, VK_MENU);
      end;
      ReloadKeyButtons;
      RefreshRemapInfo;
    end;
  end;
end;

procedure TFormMainTKO.SetFreestyle2Hotkeys;
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
      SetSaveState(ssModified);

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

procedure TFormMainTKO.SetFreestyleProHotkeys;
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
      SetSaveState(ssModified);

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

procedure TFormMainTKO.SetWorkmanKb(layerIdx: integer; bothLayers: boolean);
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
        SetSaveState(ssModified);

        //Reset keys from other alternate layouts
        keyService.ResetKey(aLayer, 11);
        keyService.ResetKey(aLayer, 12);
        keyService.ResetKey(aLayer, 15);
        keyService.ResetKey(aLayer, 25);
        keyService.ResetKey(aLayer, 26);
        keyService.ResetKey(aLayer, 30);
        keyService.ResetKey(aLayer, 33);
        keyService.ResetKey(aLayer, 39);
        keyService.ResetKey(aLayer, 42);
        keyService.ResetKey(aLayer, 43);
        keyService.ResetKey(aLayer, 49);
        keyService.ResetKey(aLayer, 50);
        keyService.ResetKey(aLayer, 51);

        keyService.SetKBKeyIdx(aLayer, 16, VK_D);  //Replace w
        keyService.SetKBKeyIdx(aLayer, 17, VK_R);  //Replace e
        keyService.SetKBKeyIdx(aLayer, 18, VK_W);  //Replace r
        keyService.SetKBKeyIdx(aLayer, 19, VK_B);  //Replace t
        keyService.SetKBKeyIdx(aLayer, 20, VK_J); //Replace y
        keyService.SetKBKeyIdx(aLayer, 21, VK_F); //Replace u
        keyService.SetKBKeyIdx(aLayer, 22, VK_U); //Replace i
        keyService.SetKBKeyIdx(aLayer, 23, VK_P); //Replace o
        keyService.SetKBKeyIdx(aLayer, 24, VK_LCL_SEMI_COMMA); //Replace P
        keyService.SetKBKeyIdx(aLayer, 31, VK_H); //Replace D
        keyService.SetKBKeyIdx(aLayer, 32, VK_T); //Replace F
        keyService.SetKBKeyIdx(aLayer, 34, VK_Y); //Replace H
        keyService.SetKBKeyIdx(aLayer, 35, VK_N); //Replace J
        keyService.SetKBKeyIdx(aLayer, 36, VK_E);  //Replace K
        keyService.SetKBKeyIdx(aLayer, 37, VK_O);  //Replace L
        keyService.SetKBKeyIdx(aLayer, 38, VK_I);  //Replace COLON
        keyService.SetKBKeyIdx(aLayer, 44, VK_M);  //Replace C
        keyService.SetKBKeyIdx(aLayer, 45, VK_C);  //Replace V
        keyService.SetKBKeyIdx(aLayer, 46, VK_V);  //Replace B
        keyService.SetKBKeyIdx(aLayer, 47, VK_K);  //Replace N
        keyService.SetKBKeyIdx(aLayer, 48, VK_L);  //Replace M
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

procedure TFormMainTKO.SetDvorakKb(layerIdx: integer; bothLayers: boolean);
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
        SetSaveState(ssModified);

        //Reset keys from other alternate layouts
        keyService.ResetKey(aLayer, 48);

        keyService.SetKBKeyIdx(aLayer, 11, VK_LCL_OPEN_BRACKET);  //Replace -
        keyService.SetKBKeyIdx(aLayer, 12, VK_LCL_CLOSE_BRACKET);  //Replace =
        keyService.SetKBKeyIdx(aLayer, 15, VK_LCL_QUOTE);  //Replace q
        keyService.SetKBKeyIdx(aLayer, 16, VK_LCL_COMMA);  //Replace w
        keyService.SetKBKeyIdx(aLayer, 17, VK_LCL_POINT); //Replace e

        keyService.SetKBKeyIdx(aLayer, 18, VK_P); //Replace r
        keyService.SetKBKeyIdx(aLayer, 19, VK_Y); //Replace t
        keyService.SetKBKeyIdx(aLayer, 20, VK_F); //Replace y
        keyService.SetKBKeyIdx(aLayer, 21, VK_G); //Replace u
        keyService.SetKBKeyIdx(aLayer, 22, VK_C); //Replace i
        keyService.SetKBKeyIdx(aLayer, 23, VK_R); //Replace o
        keyService.SetKBKeyIdx(aLayer, 24, VK_L); //Replace p

        keyService.SetKBKeyIdx(aLayer, 25, VK_LCL_SLASH);  //Replace [
        keyService.SetKBKeyIdx(aLayer, 26, VK_LCL_EQUAL);  //Replace ]
        keyService.SetKBKeyIdx(aLayer, 30, VK_O);  //Replace s
        keyService.SetKBKeyIdx(aLayer, 31, VK_E);  //Replace d
        keyService.SetKBKeyIdx(aLayer, 32, VK_U);  //Replace f
        keyService.SetKBKeyIdx(aLayer, 33, VK_I);  //Replace g
        keyService.SetKBKeyIdx(aLayer, 34, VK_D);  //Replace h
        keyService.SetKBKeyIdx(aLayer, 35, VK_H);  //Replace j
        keyService.SetKBKeyIdx(aLayer, 36, VK_T);  //Replace k
        keyService.SetKBKeyIdx(aLayer, 37, VK_N);  //Replace l

        keyService.SetKBKeyIdx(aLayer, 38, VK_S);  //Replace colon
        keyService.SetKBKeyIdx(aLayer, 39, VK_LCL_MINUS);  //Replace apos
        keyService.SetKBKeyIdx(aLayer, 42, VK_LCL_SEMI_COMMA);  //Replace z
        keyService.SetKBKeyIdx(aLayer, 43, VK_Q);  //Replace x
        keyService.SetKBKeyIdx(aLayer, 44, VK_J);  //Replace c
        keyService.SetKBKeyIdx(aLayer, 45, VK_K);  //Replace v
        keyService.SetKBKeyIdx(aLayer, 46, VK_X);  //Replace b
        keyService.SetKBKeyIdx(aLayer, 47, VK_B);  //Replace n
        keyService.SetKBKeyIdx(aLayer, 49, VK_W);  //Replace comma
        keyService.SetKBKeyIdx(aLayer, 50, VK_V);  //Replace period
        keyService.SetKBKeyIdx(aLayer, 51, VK_Z);  //Replace /
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

procedure TFormMainTKO.SetColemakKb(layerIdx: integer; bothLayers: boolean);
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
        SetSaveState(ssModified);

        //Reset keys from other alternate layouts
        keyService.ResetKey(aLayer, 11);
        keyService.ResetKey(aLayer, 12);
        keyService.ResetKey(aLayer, 15);
        keyService.ResetKey(aLayer, 16);
        keyService.ResetKey(aLayer, 25);
        keyService.ResetKey(aLayer, 26);
        keyService.ResetKey(aLayer, 34);
        keyService.ResetKey(aLayer, 39);
        keyService.ResetKey(aLayer, 42);
        keyService.ResetKey(aLayer, 43);
        keyService.ResetKey(aLayer, 44);
        keyService.ResetKey(aLayer, 45);
        keyService.ResetKey(aLayer, 46);
        keyService.ResetKey(aLayer, 49);
        keyService.ResetKey(aLayer, 50);
        keyService.ResetKey(aLayer, 51);

        keyService.SetKBKeyIdx(aLayer, 17, VK_F);  //Replace e
        keyService.SetKBKeyIdx(aLayer, 18, VK_P);  //Replace r
        keyService.SetKBKeyIdx(aLayer, 19, VK_G);  //Replace t
        keyService.SetKBKeyIdx(aLayer, 20, VK_J);  //Replace y
        keyService.SetKBKeyIdx(aLayer, 21, VK_L); //Replace u
        keyService.SetKBKeyIdx(aLayer, 22, VK_U); //Replace i
        keyService.SetKBKeyIdx(aLayer, 23, VK_Y); //Replace o
        keyService.SetKBKeyIdx(aLayer, 24, VK_LCL_SEMI_COMMA); //Replace p
        keyService.SetKBKeyIdx(aLayer, 30, VK_R); //Replace s
        keyService.SetKBKeyIdx(aLayer, 31, VK_S); //Replace d
        keyService.SetKBKeyIdx(aLayer, 32, VK_T); //Replace f
        keyService.SetKBKeyIdx(aLayer, 33, VK_D); //Replace g
        keyService.SetKBKeyIdx(aLayer, 35, VK_N);  //Replace j
        keyService.SetKBKeyIdx(aLayer, 36, VK_E);  //Replace k
        keyService.SetKBKeyIdx(aLayer, 37, VK_I);  //Replace l
        keyService.SetKBKeyIdx(aLayer, 38, VK_O);  //Replace colon
        keyService.SetKBKeyIdx(aLayer, 47, VK_K);  //Replace n
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

function TFormMainTKO.GetCursorNextKey(cursorPos: integer): integer;
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

function TFormMainTKO.GetCursorPrevKey(cursorPos: integer): integer;
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

function TFormMainTKO.CanAssignMacro: boolean;
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

procedure TFormMainTKO.SetModifiedKey(key: word; Modifiers: string;
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
  if (keyService.ConfigMode = CONFIG_LAYOUT) and (IsKeyLoaded) then
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
        SetSaveState(ssModified);
        keyService.SetKBKey(activeKbKey, key, overwriteTapHold);
        if (bothLayers) then
        begin
          aKbKeyOtherLayer := GetKeyOtherLayer(keyService, activeKeyBtn.Index);
          if aKbKeyOtherLayer <> nil then
            keyService.SetKBKey(aKbKeyOtherLayer, key, overwriteTapHold);
        end;
        UpdateKeyButtonKey(activeKbKey, activeKeyBtn);
      end;
    end;
  end;
end;

procedure TFormMainTKO.UpdateMenu;
begin

end;

procedure TFormMainTKO.menuButtonUpdate(Sender: TObject);
var
  aButton: TColorSpeedButtonCS;
begin
  aButton := (Sender as TColorSpeedButtonCS);
  if (aButton.Down) then
    aButton.Font.Color := KINESIS_BLUE_EDGE;
end;

//Macro section

procedure TFormMainTKO.OpenMacroEditor;
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
    btnMacro.GroupIndex := 10;
    btnMacro.Down := true;
    SetWindowsCombo(false);
    pnlMacro.Visible := true;
    pnlMacro.Left := imgKeyboardLayout.Left + imgKeyboardLayout.Width - pnlMacro.Width;
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

procedure TFormMainTKO.CloseMacroEditor;
begin
  btnMacro.Down := false;
  //Only way to make macro button down = false
  btnMacroOff.Down := true;
  pnlMacro.Visible := false;
end;

procedure TFormMainTKO.LoadMacro;
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

procedure TFormMainTKO.rgMacroClick(Sender: TObject);
begin
  if (IsKeyLoaded) then
  begin
    SetWindowsCombo(false);
    LoadMacro;
    SetMacroText(true);
  end;
end;

procedure TFormMainTKO.SetCoTrigger(aKey: TKey);
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
end;

procedure TFormMainTKO.ActivateCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BorderWidth := 1;
  keyButton.BorderColor := activeColor;
  keyButton.BorderStyle := bsSingle;
  keyButton.Repaint;
end;

procedure TFormMainTKO.ActivateCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
begin
  coTriggerBtn.HelpKeyword := 'DOWN';
  SetHovered(coTriggerBtn, true);
  SetMacroAssignTo;
end;

procedure TFormMainTKO.SetMacroAssignTo;
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
procedure TFormMainTKO.ResetMacroCoTriggers;
begin
  ResetCoTrigger(btnLeftShift);
  ResetCoTrigger(btnRightShift);
  ResetCoTrigger(btnLeftAlt);
  ResetCoTrigger(btnRightAlt);
  ResetCoTrigger(btnLeftCtrl);
  ResetCoTrigger(btnRightCtrl);
end;

procedure TFormMainTKO.ResetCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BackColor := clNone;
  keyButton.BorderColor := clNone;
  keyButton.BorderStyle := bsNone;
  keyButton.Repaint;
end;

procedure TFormMainTKO.ResetCoTrigger(coTriggerBtn: TColorSpeedButtonCS);
begin
  coTriggerBtn.HelpKeyword := '';
  SetHovered(coTriggerBtn, false, true);
end;

function TFormMainTKO.GetCoTriggerKey(Sender: TObject): TKey;
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
end;

procedure TFormMainTKO.RemoveCoTrigger(key: word);
begin
  if IsKeyLoaded then
  begin
    MacroModified := true;
    if (activeKbKey.ActiveMacro.CoTrigger1 <> nil) and (activeKbKey.ActiveMacro.CoTrigger1.Key = key) then
      activeKbKey.ActiveMacro.CoTrigger1 := nil;

    SetMacroAssignTo;
  end;
end;

procedure TFormMainTKO.btnCopyClick(Sender: TObject);
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

procedure TFormMainTKO.btnPasteClick(Sender: TObject);
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

procedure TFormMainTKO.btnBackspaceMacroClick(Sender: TObject);

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

procedure TFormMainTKO.btnClearMacroClick(Sender: TObject);
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

procedure TFormMainTKO.SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
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

procedure TFormMainTKO.SetMacroText(pushCursorToEnd: boolean; cursorPos: integer = -1);
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

procedure TFormMainTKO.SetWindowsCombo(value: boolean);
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

procedure TFormMainTKO.MoveComponents(leftIdx: integer; pixels: integer);
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

procedure TFormMainTKO.openFirwareWebsite(Sender: TObject);
begin
  OpenUrl(TKO_FIRMWARE);
end;

procedure TFormMainTKO.SetHovered(obj: TObject; hovered: boolean;
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

procedure TFormMainTKO.SetMousePosition(x, y: integer);
var
  MousePos: TPoint;
begin
  MousePos.X := self.Left + x;
  MousePos.Y := self.Top + y;
  Mouse.CursorPos := MousePos;
end;

procedure TFormMainTKO.ObjectMouseEnter(Sender: TObject);
begin
  SetHovered(sender, true);
end;

procedure TFormMainTKO.ObjectMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  SetHovered(sender, true);
end;

procedure TFormMainTKO.ObjectMouseExit(Sender: TObject);
begin
  SetHovered(sender, false);
end;

//End macro section

procedure TFormMainTKO.ReturnToHome;
begin
  (parentForm as TFormDashboard).ResetToHome;
end;

initialization

end.

