unit u_form_keypress;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  u_key_service, u_keys, lcltype, Menus, ExtCtrls, Buttons, RichMemo,
  ColorSpeedButton, u_const, u_file_service, u_form_about, lclintf, UserDialog
  {$ifdef Win32},Windows{$endif}
  {$ifdef Darwin}, MacOSAll{, CarbonUtils, CarbonDef, CarbonProc}{$endif};

type

  { TFormKeyPress }

  TFormKeyPress = class(TForm)
    bBackspace: TSpeedButton;
    bDone: TSpeedButton;
    bClear: TSpeedButton;
    bCancel: TSpeedButton;
    bExit: TSpeedButton;
    bHelp: TSpeedButton;
    bMoreLeft: TBitBtn;
    bJack1: TSpeedButton;
    bJack2: TSpeedButton;
    bJack3: TSpeedButton;
    bJack4: TSpeedButton;
    bLeft: TSpeedButton;
    bMiddle: TSpeedButton;
    bMoreMiddle: TBitBtn;
    bMoreRight: TBitBtn;
    bMoreJack1: TBitBtn;
    bMoreJack2: TBitBtn;
    bMoreJack3: TBitBtn;
    bMoreJack4: TBitBtn;
    bMultipleKeys: TSpeedButton;
    bOpenFile: TSpeedButton;
    bRight: TSpeedButton;
    bSave: TSpeedButton;
    bSaveAs: TSpeedButton;
    bSingleKey: TSpeedButton;
    bSpecialAction: TSpeedButton;
    Image1: TImage;
    ImageList1: TImageList;
    Label3: TLabel;
    lblFileName: TLabel;
    lblInfoConfig: TLabel;
    lblInfoConfig2: TLabel;
    lblInfoInput: TLabel;
    lblWarningKbLanuage: TLabel;
    lblJack1Modified: TLabel;
    lblJack2Modified: TLabel;
    lblJack3Modified: TLabel;
    lblJack4Modified: TLabel;
    lblLeftModified: TLabel;
    lblMiddle2: TLabel;
    lblMiddleModified: TLabel;
    lblPedal: TLabel;
    lblRight: TLabel;
    lblRight1: TLabel;
    lblRight2: TLabel;
    lblRight3: TLabel;
    lblRight4: TLabel;
    lblRight5: TLabel;
    lblRightModified: TLabel;
    memoConfig: TRichMemo;
    memoJack1: TRichMemo;
    memoJack2: TRichMemo;
    memoJack3: TRichMemo;
    memoJack4: TRichMemo;
    memoLeft: TRichMemo;
    memoMiddle: TRichMemo;
    memoRight: TRichMemo;
    MenuItem1: TMenuItem;
    miAbout: TMenuItem;
    miHelp: TMenuItem;
    pedalOpenDialog: TOpenDialog;
    pedalSaveDialog: TSaveDialog;
    pmHelp: TPopupMenu;
    pmSpecial: TPopupMenu;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    shSpecialAction: TShape;
    procedure bCancelClick(Sender: TObject);
    procedure bDoneClick(Sender: TObject);
    procedure bBackspaceClick(Sender: TObject);
    procedure bHelpClick(Sender: TObject);
    procedure bJack1Click(Sender: TObject);
    procedure bJack2Click(Sender: TObject);
    procedure bJack3Click(Sender: TObject);
    procedure bJack4Click(Sender: TObject);
    procedure bLeftClick(Sender: TObject);
    procedure bClearClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure bMiddleClick(Sender: TObject);
    procedure bMoreMiddleClick(Sender: TObject);
    procedure bMoreRightClick(Sender: TObject);
    procedure bMoreJack1Click(Sender: TObject);
    procedure bMoreJack2Click(Sender: TObject);
    procedure bMoreJack3Click(Sender: TObject);
    procedure bMoreJack4Click(Sender: TObject);
    procedure bMoreLeftClick(Sender: TObject);
    procedure bMultipleKeysClick(Sender: TObject);
    procedure bOpenFileClick(Sender: TObject);
    procedure bRightClick(Sender: TObject);
    procedure bSaveAsClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure bSingleKeyClick(Sender: TObject);
    procedure bSpecialActionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lblWarningKbLanuageClick(Sender: TObject);
    procedure memoConfigChange(Sender: TObject);
    procedure memoConfigEnter(Sender: TObject);
    procedure memoConfigExit(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure miSpecialClick(Sender: TObject);
    procedure ResizeControlMemo(Sender: TObject);
  private
    { private declarations }
    EditMode: boolean;
    SaveState: TSaveState;
    memoConfigDefaultColor: TColor;
    memoOriginalHeight: integer;
    memoOriginalColor: TColor;
    darkTheme: boolean;

    procedure AddSpecialActions;
    procedure SetEditMode(Value: boolean; pedal: TPedal);
    procedure SetEditButton(isEditMode: boolean; button: TObject);
    procedure SetSaveState(Value: TSaveState);
    function LoadPedalsFile(fileName: string): boolean;
    procedure CheckToSave;
    function Save: boolean;
    procedure SaveAs;
    function CheckEdit(checkEditing: boolean): boolean;
    procedure SetMemoTextColor(aMemo: TRichMemo; aPedalsPos: TPedalsPos);
    procedure LoadPedalText(configField: boolean);
    procedure SetKeyboardHook;
    procedure RemoveKeyboardHook;
    procedure SetConfigOS;
    procedure SetKeyMode(keyMode: TKeyMode);
    procedure ResetMemo(memoField: TRichMemo);
    procedure CheckKeyboardLayout;
  public
    { public declarations }
  end;

var
  keyService: TKeyService;
  fileService: TFileService;
  NeedInput: boolean;
  lastKeyDown: word;
  FormKeyPress: TFormKeyPress;
  KBHook: HHook;
  lastKeyPressed: word;

  {$ifdef Win32}
  function KeyboardHookProc(Code, wParam, lParam: longint): longint; stdcall;  {this intercepts keyboard input}
  {$endif}
//  {$ifdef Darwin}
//  Mac_OS_Handler_UPP : EventHandlerUPP = nil;
//  gMyHotKeyRef : EventHotKeyRef;
//  gMyHotKeyID  : EventHotKeyID;

//  function MAC_OS_Handler(ANextHandler: EventHandlerCallRef;
//    AEvent: EventRef;
//    inUserData: UnivPtr ): OSStatus; mwpascal;
//  {$endif}
  procedure SetKeyPress(Key: word; Modifiers: string);

implementation

{$R *.lfm}

{ TFormKeyPress }

//{$ifdef Darwin}
//function MAC_OS_Handler(ANextHandler: EventHandlerCallRef;
//  AEvent: EventRef;
//  inUserData: UnivPtr ): OSStatus; mwpascal;
//begin
  //ShowMessage('hot'); // No Message :(
  //Result := CallNextEventHandler(ANextHandler, AEvent);
//end;
//{$endif}

{$ifdef Win32}
//Keyboard hook to trap key presses and process them
function KeyboardHookProc(Code, wParam, lParam: longint): longint; stdcall;
var
  Transition: TTransitionState;
  extended: TExtendedState;
  //KeystrokeDataPtr: PKeystrokeData;
  currentKey: longint;
begin
  //If we need keyboard input (ex: file prompt) allow key presses
  if NeedInput then
  begin
    Result := CallNextHookEx(WH_KEYBOARD, Code, wParam, lParam);
    exit;
  end;

  //If not in edit mode, does nothing
  if not FormKeyPress.EditMode then
    exit;

  currentKey := wParam;

  //Checks if key is up or down
  Transition := TTransitionState((lParam shr 31) and 1);

  //Checks if key is normal or extended
  extended := TExtendedState((lParam shr 24) and 1);

  //Detects if numpadenter is pressed, changes key for user-defined numpad enter
  if (extended = esExtended) and (currentKey = VK_RETURN) then
    currentKey := VK_NUMPADENTER;

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

//Adds key to list of keys and writes back to edit field
procedure SetKeyPress(Key: word; Modifiers: string);
begin
  if FormKeyPress.EditMode then
  begin
    if keyService.AddKey(Key, Modifiers) then
      FormKeyPress.LoadPedalText(true);
  end;
end;

procedure TFormKeyPress.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CheckToSave;

  FreeAndNil(keyService);
  FreeAndNil(fileService);
  if CloseAction = caFree then
    self := nil;
end;

procedure TFormKeyPress.FormCreate(Sender: TObject);
begin
  //Sets Height and Width of form according to screen resolution
  self.Width := pnlLeft.Width + pnlRight.Width + 20;
  if screen.Width < self.Width then
    self.Width := screen.Width - 20;

  self.Height := 675;
  if screen.Height < self.Height then
    self.Height := screen.Height - 20;

  SetConfigOS; //Sets config according to OS version

  darkTheme := IsDarkTheme;
  if (darkTheme) then
  begin
    ImageList1.GetBitmap(0, bSpecialAction.Glyph);
    shSpecialAction.Visible := false;
    memoLeft.Color := clGray;
    memoMiddle.Color := clGray;
    memoRight.Color := clGray;
    memoJack1.Color := clGray;
    memoJack2.Color := clGray;
    memoJack3.Color := clGray;
    memoJack4.Color := clGray;
  end;

  self.Caption := GApplicationTitle;
  keyService := TKeyService.Create;
  fileService := TFileService.Create;
  AddSpecialActions;
  SetSaveState(ssNone);
  NeedInput := False;
  memoOriginalHeight := memoLeft.Height;
  memoOriginalColor := memoLeft.Color;

  SetKeyboardHook;

  //Tries to load Pedals.txt file
  LoadPedalsFile(GPedalsFile);

  //Sets default directory as the active folder
  if DirectoryExists(GPedalsFilePath) then
  begin
    pedalOpenDialog.InitialDir := GPedalsFilePath;
    pedalSaveDialog.InitialDir := GPedalsFilePath;
  end;

  CheckKeyboardLayout;
end;

procedure TFormKeyPress.FormDestroy(Sender: TObject);
begin
  RemoveKeyboardHook;
end;

//Only used for Mac version to trap key presses
procedure TFormKeyPress.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  {$ifdef Darwin}var currentKey: longint;{$endif}
begin
  {$ifdef Darwin}
  //If we need keyboard input (ex: file prompt) allow key presses
  if NeedInput then
  begin
    exit;
  end;

  //If not in edit mode, does nothing
  if not EditMode then
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
procedure TFormKeyPress.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

procedure TFormKeyPress.lblWarningKbLanuageClick(Sender: TObject);
var
  listKBLayouts: string;
  i: integer;
begin
  listKBLayouts := '';
  for i := 0 to keyService.KeyboardLayouts.Count - 1 do
  begin
    if listKBLayouts <> '' then
       listKBLayouts := listKBLayouts + #10#13;
    listKBLayouts := listKBLayouts + keyService.KeyboardLayouts[i].Name;
  end;
  ShowDialog('List of supported keyboard languages', listKBLayouts, mtInformation, [mbOK]);
end;

{Set the keyboard hook so we  can intercept keyboard input}
procedure TFormKeyPress.SetKeyboardHook;
{$ifdef Darwin}var eventType: EventTypeSpec;{$endif}
begin
  //Windows
  {$ifdef Win32}
  KBHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc, HInstance,
    GetCurrentThreadId());
  {$endif}
end;

{unhook the keyboard interception}
procedure TFormKeyPress.RemoveKeyboardHook;
begin
  //Windows
  {$ifdef Win32}
  UnHookWindowsHookEx(KBHook);
  {$endif}
end;

procedure TFormKeyPress.SetConfigOS;
begin
  //Windows
  {$ifdef Win32}
  SetFont(self, 'Segoe UI');
  memoConfig.Color := clWhite;
  memoLeft.Color := clForm;
  memoMiddle.Color := clForm;
  memoRight.Color := clForm;
  memoJack1.Color := clForm;
  memoJack2.Color := clForm;
  memoJack3.Color := clForm;
  memoJack4.Color := clForm;
  memoConfigDefaultColor := clWhite;
  {$endif}

  //MacOS
  {$ifdef Darwin}
  self.AutoScroll := false; //No scroll bars OSX, does not work well
  self.KeyPreview := true; //traps key presses at form level
  SetFont(self, 'Tahoma Bold');//'Helvetica');
  memoConfigDefaultColor := $00F6F6F6;
  memoConfig.BorderStyle := bsSingle;
  memoLeft.ScrollBars := TScrollStyle.ssNone;
  memoLeft.BorderStyle := bsSingle;
  memoMiddle.ScrollBars := TScrollStyle.ssNone;
  memoMiddle.BorderStyle := bsSingle;
  memoRight.ScrollBars := TScrollStyle.ssNone;
  memoRight.BorderStyle := bsSingle;
  memoJack1.ScrollBars := TScrollStyle.ssNone;
  memoJack1.BorderStyle := bsSingle;
  memoJack2.ScrollBars := TScrollStyle.ssNone;
  memoJack2.BorderStyle := bsSingle;
  memoJack3.ScrollBars := TScrollStyle.ssNone;
  memoJack3.BorderStyle := bsSingle;
  memoJack4.ScrollBars := TScrollStyle.ssNone;
  memoJack4.BorderStyle := bsSingle;
  lblInfoConfig2.Font.Size := 9;
  lblPedal.Font.Color := clActiveCaption;
  {$endif}
end;

procedure TFormKeyPress.memoConfigChange(Sender: TObject);
begin
  HideCaret(memoConfig.Handle);
end;

procedure TFormKeyPress.memoConfigEnter(Sender: TObject);
begin
  HideCaret(memoConfig.Handle);
end;

procedure TFormKeyPress.memoConfigExit(Sender: TObject);
begin
  HideCaret(memoConfig.Handle);
end;

procedure TFormKeyPress.miAboutClick(Sender: TObject);
begin
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.ShowModal;
end;

procedure TFormKeyPress.miHelpClick(Sender: TObject);
const
  HELP_FILE_NAME = 'SE2 Config App Help.pdf';
  HELP_FILE_NAME_NEW = 'SE2 SmartSet App Help.pdf';
begin
  if FileExists(GApplicationPath + HELP_FILE_NAME) then
    OpenDocument(GApplicationPath + HELP_FILE_NAME)
  else if FileExists(GApplicationPath + HELP_FILE_NAME_NEW) then
    OpenDocument(GApplicationPath + HELP_FILE_NAME_NEW)
  else
    ShowDialog('Help',
      'Help file not found!', mtWarning,
      [mbOk]);
end;

//Fills popum menu with special actions
procedure TFormKeyPress.AddSpecialActions;
var
  menuItem: TMenuItem;
begin
  //Clears the list
  pmSpecial.Items.Clear;

  // Header Mouse Actions
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator0_1';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'MOUSE ACTIONS';
  //menuItem.Enabled := false;
  menuItem.Default := true;
  menuItem.Name := 'mouseHeader';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator0_2';
  pmSpecial.Items.Add(menuItem);
  //

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Left Mouse Click';
  menuItem.Name := miLeftMouse;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_BOTH_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Left Mouse Double Click';
  menuItem.Name := miMouseDblClick;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Middle Mouse Click';
  menuItem.Name := miMiddleMouse;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_BOTH_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Right Mouse Click';
  menuItem.Name := miRightMouse;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_BOTH_KEY;
  pmSpecial.Items.Add(menuItem);

  // Header Editing Tools
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator1_1';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'EDITING TOOLS';
  //menuItem.Enabled := false;
  menuItem.Default := true;
  menuItem.Name := 'editingHeader';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator1_2';
  pmSpecial.Items.Add(menuItem);
  //

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Cut (Ctrl + x)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Cut';
  {$endif}
  menuItem.Name := miCut;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Copy (Ctrl + c)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Copy';
  {$endif}
  menuItem.Name := miCopy;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Paste (Ctrl + v)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Paste';
  {$endif}
  menuItem.Name := miPaste;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Select All (Ctrl + a)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Select All';
  {$endif}
  menuItem.Name := miSelectAll;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Undo (Ctrl + z)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Undo';
  {$endif}
  menuItem.Name := miUndo;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  // Header Media Controls
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator2_1';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'MEDIA CONTROLS';
  //menuItem.Enabled := false;
  menuItem.Default := true;
  menuItem.Name := 'mediaHeader';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator2_2';
  pmSpecial.Items.Add(menuItem);
  //

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Mute';
  menuItem.Name := miVolMute;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Volume Up';
  menuItem.Name := miVolPlus;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Volume Down';
  menuItem.Name := miVolMin;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Play/Pause';
  menuItem.Name := miPlay;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Previous Track';
  menuItem.Name := miPrev;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Next Track';
  menuItem.Name := miNext;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  // Header Commonly Used Shortcuts
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator3_1';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'COMMONLY USED SHORTCUTS';
  //menuItem.Enabled := false;
  menuItem.Default := true;
  menuItem.Name := 'commonHeader';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator3_2';
  pmSpecial.Items.Add(menuItem);
  //

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Web Browser Forward (Alt + right)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Web Browser Forward';
  {$endif}
  menuItem.Name := miWebFwd;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  {$ifdef Win32}  //Windows
  menuItem.Caption := 'Web Browser Back (Alt + left)';
  {$endif}
  {$ifdef Darwin}  //MacOS
  menuItem.Caption := 'Web Browser Back';
  {$endif}
  menuItem.Name := miWebBack;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  {$ifdef Win32} //Ctrl + Alt + Delete and Alt + Tab on Windows only
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Alt + Tab';
  menuItem.Name := miAltTab;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Ctrl + Alt + Delete';
  menuItem.Name := miCtrlAltDel;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Calculator';
  menuItem.Name := miCalc;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_SINGLE_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Windows Combination (Win + _)';
  menuItem.Name := miWinKey;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);
  {$endif}

  {$ifdef Darwin}  //MacOS
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Cmd + Tab';
  menuItem.Name := miCmdTab;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Snip to File';
  menuItem.Name := miSnipClip;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Snip to Clipboard';
  menuItem.Name := miSnipFile;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Force Quit';
  menuItem.Name := miForceQuit;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);
  {$endif}

  // Header Pedal Response
  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator4_1';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'PEDAL RESPONSE';
  //menuItem.Enabled := false;
  menuItem.Default := true;
  menuItem.Name := 'commonResponse';
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := TEXT_SEPARATOR;
  menuItem.Name := 'separator4_2';
  pmSpecial.Items.Add(menuItem);
  //

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Slow Output (speed1)';
  menuItem.Name := miSpeed1;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Default Output (speed3)';
  menuItem.Name := miSpeed3;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Fast Output (speed5)';
  menuItem.Name := miSpeed5;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Short Delay (125ms)';
  menuItem.Name := mi125;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Long Delay (500ms)';
  menuItem.Name := mi500;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);

  menuItem := TMenuItem.Create(pmSpecial);
  menuItem.Caption := 'Different Press && Release';
  menuItem.Name := miDifPressRel;
  menuItem.OnClick := @miSpecialClick;
  menuItem.Tag := TAG_MULTI_KEY;
  pmSpecial.Items.Add(menuItem);
end;

//When special action button is clicked
procedure TFormKeyPress.miSpecialClick(Sender: TObject);
var
  isNewKey: boolean;
  LastKey: TKey;
begin
  if Sender.InheritsFrom(TMenuItem) then
  begin
    //Switch to Single Action or Multiple Actions mode depending on which action was selected
    if TMenuItem(Sender).Tag = TAG_SINGLE_KEY then
      SetKeyMode(kmSingle)
    else if TMenuItem(Sender).Tag = TAG_MULTI_KEY then
      SetKeyMode(kmMulti);

    if TMenuItem(Sender).Name = miLeftMouse then
      SetKeyPress(VK_MOUSE_LEFT, keyService.GetModifierText)
    else if TMenuItem(Sender).Name = miMiddleMouse then
      SetKeyPress(VK_MOUSE_MIDDLE, keyService.GetModifierText)
    else if TMenuItem(Sender).Name = miRightMouse then
      SetKeyPress(VK_MOUSE_RIGHT, keyService.GetModifierText)
    else if TMenuItem(Sender).Name = miMouseDblClick then
    begin
      SetKeyPress(VK_MOUSE_LEFT, '');
      SetKeyPress(VK_125MS, '');
      SetKeyPress(VK_MOUSE_LEFT, '');
    end
    else if TMenuItem(Sender).Name = miCut then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_X, CTRL_MOD)
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_X, WIN_MOD)
      {$endif}
    end
    else if TMenuItem(Sender).Name = miCopy then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_C, CTRL_MOD)
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_C, WIN_MOD)
      {$endif}
    end
    else if TMenuItem(Sender).Name = miPaste then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_V, CTRL_MOD)
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_V, WIN_MOD)
      {$endif}
    end
    else if TMenuItem(Sender).Name = miSelectAll then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_A, CTRL_MOD)
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_A, WIN_MOD)
      {$endif}
    end
    else if TMenuItem(Sender).Name = miUndo then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_Z, CTRL_MOD)
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_Z, WIN_MOD)
      {$endif}
    end
    else if TMenuItem(Sender).Name = miWebFwd then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_RIGHT, ALT_MOD);
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_RIGHT, WIN_MOD);
      {$endif}
    end
    else if TMenuItem(Sender).Name = miWebBack then
    begin
      {$ifdef Win32} //Windows
      SetKeyPress(VK_LEFT, ALT_MOD);
      {$endif}
      {$ifdef Darwin}  //MacOS
      SetKeyPress(VK_LEFT, WIN_MOD);
      {$endif}
    end
    else if TMenuItem(Sender).Name = miAltTab then
      SetKeyPress(VK_TAB, ALT_MOD)
    else if TMenuItem(Sender).Name = miCtrlAltDel then
      SetKeyPress(VK_DELETE, CTRL_MOD + ',' + ALT_MOD)
    else if TMenuItem(Sender).Name = miWinKey then
    begin
      if keyService.IsWinKeyDown then
      begin
        keyService.RemoveModifier(VK_LWIN);
        keyService.RemoveModifier(VK_RWIN);
      end
      else
      begin
        keyService.AddModifier(VK_LWIN);
      end;
    end
    else if TMenuItem(Sender).Name = miCmdTab then
      SetKeyPress(VK_TAB, WIN_MOD)
    else if TMenuItem(Sender).Name = miSnipClip then
      SetKeyPress(VK_4, SHIFT_MOD + ',' + WIN_MOD)
    else if TMenuItem(Sender).Name = miSnipFile then
      SetKeyPress(VK_4, SHIFT_MOD + ',' + CTRL_MOD + ',' + WIN_MOD)
    else if TMenuItem(Sender).Name = miForceQuit then
      SetKeyPress(VK_ESCAPE, WIN_MOD + ',' + ALT_MOD)
    else if TMenuItem(Sender).Name = miVolMute then
      SetKeyPress(VK_VOLUME_MUTE, '')
    else if TMenuItem(Sender).Name = miVolMin then
      SetKeyPress(VK_VOLUME_DOWN, '')
    else if TMenuItem(Sender).Name = miVolPlus then
      SetKeyPress(VK_VOLUME_UP, '')
    else if TMenuItem(Sender).Name = miPlay then
      SetKeyPress(VK_MEDIA_PLAY_PAUSE, '')
    else if TMenuItem(Sender).Name = miPrev then
      SetKeyPress(VK_MEDIA_PREV_TRACK, '')
    else if TMenuItem(Sender).Name = miNext then
      SetKeyPress(VK_MEDIA_NEXT_TRACK, '')
    else if TMenuItem(Sender).Name = miCalc then
      SetKeyPress(VK_CALC, '')
    else if TMenuItem(Sender).Name = miSpeed1 then
      SetKeyPress(VK_SPEED1, '')
    else if TMenuItem(Sender).Name = miSpeed3 then
      SetKeyPress(VK_SPEED3, '')
    else if TMenuItem(Sender).Name = miSpeed5 then
      SetKeyPress(VK_SPEED5, '')
    else if TMenuItem(Sender).Name = mi125 then
      SetKeyPress(VK_125MS, '')
    else if TMenuItem(Sender).Name = mi500 then
      SetKeyPress(VK_500MS, '')
    else if TMenuItem(Sender).Name = miDifPressRel then
    begin
      isNewKey := true;
      LastKey := nil;

      //Gets lastkey
      if keyService.ActivePedal.Count > 0 then
        LastKey := keyService.ActivePedal.Items[keyService.ActivePedal.Count -1];

      //If lastkey has modifiers, ask if user wants to add different press & release to macro
      if (LastKey <> nil) then
      begin
        if (LastKey.Modifiers <> '') and not(IsModifier(LastKey.Key)) then
        begin
          if ShowDialog('Different Press & Release',
            'Add "Different Press && Release" to current macro?', mtConfirmation,
            [mbYes, mbNo]) = mrYes then
          begin
            isNewKey := false;
            LastKey.DiffPressRel := true;
            FormKeyPress.LoadPedalText(true);
          end;
        end;
      end;

      //If just a new key, add different press & release
      if isNewKey then
        SetKeyPress(VK_DIF_PRESS_REL, '');
    end;
  end;
end;

procedure TFormKeyPress.bSpecialActionClick(Sender: TObject);
var
  lPoint: TPoint;
  i: integer;
begin
  for i := 0 to pmSpecial.Items.Count - 1 do
  begin
    //Version 1.0.0.0 - always show multi and single key
    //Show only multikey options when multi key is pressed
    //Don't show separators in single key
    //pmSpecial.Items[i].Visible :=
    //  ((pmSpecial.Items[i].Tag = TAG_MULTI_KEY) and (bMultipleKeys.Down)) or
    //  ((pmSpecial.Items[i].Tag = TAG_SINGLE_KEY) and (bSingleKey.Down)) or
    //  (pmSpecial.Items[i].Tag = TAG_BOTH_KEY);

    //Shows a checkbox if Windows key is down
    if (pmSpecial.Items[i].Name = miWinKey) and (pmSpecial.Items[i].Visible) then
    begin
      pmSpecial.Items[i].Checked := keyService.IsWinKeyDown;
    end;
  end;

  //Popup menu over special button
  lPoint.x := 0;
  lPoint.y := 0;
  lPoint := bSpecialAction.ClientToScreen(lPoint);
  pmSpecial.Popup(lPoint.x, lPoint.y);
end;

procedure TFormKeyPress.bExitClick(Sender: TObject);
begin
  self.Close;
end;

procedure TFormKeyPress.bBackspaceClick(Sender: TObject);
begin
  if keyService.RemoveLastKey then
  begin
    LoadPedalText(true);
  end;
end;

procedure TFormKeyPress.bHelpClick(Sender: TObject);
var
  lPoint: TPoint;
begin
  //Popup menu over help button
  lPoint.x := 0;
  lPoint.y := 0;
  lPoint := bHelp.ClientToScreen(lPoint);
  pmHelp.Popup(lPoint.x, lPoint.y);
end;

procedure TFormKeyPress.bClearClick(Sender: TObject);
begin
  memoConfig.Lines.Clear;
  keyService.ClearModifiers;
  if keyService.ActivePedal <> nil then
    keyService.ActivePedal.Clear;
end;

procedure TFormKeyPress.LoadPedalText(configField: boolean);
var
  aPedalsPos: TPedalsPos;
begin
  aPedalsPos := nil;
  if configField then
  begin
    memoConfig.Text := keyService.GetOutputText(keyService.ActivePedal, aPedalsPos);
    //Replace empty space with special space character
    memoConfig.Text := StringReplace(memoConfig.Text, ' ', AnsiToUtf8(#$e2#$90#$a3), [rfReplaceAll]);
    SetMemoTextColor(memoConfig, aPedalsPos);
    memoConfig.SelStart := Length(memoConfig.Text);
    memoConfig.SelLength := 1; //1.0.5 to show the cursor
    {$ifdef Darwin}  //MacOS
      memoConfig.SetFocus;
    {$endif}
  end
  else
  begin
    memoLeft.Text := keyService.GetOutputText(keyService.LPKeys, aPedalsPos);
    SetMemoTextColor(memoLeft, aPedalsPos);

    memoMiddle.Text := keyService.GetOutputText(keyService.MPKeys, aPedalsPos);
    SetMemoTextColor(memoMiddle, aPedalsPos);

    memoRight.Text := keyService.GetOutputText(keyService.RPKeys, aPedalsPos);
    SetMemoTextColor(memoRight, aPedalsPos);

    memoJack1.Text := keyService.GetOutputText(keyService.J1Keys, aPedalsPos);
    SetMemoTextColor(memoJack1, aPedalsPos);

    memoJack2.Text := keyService.GetOutputText(keyService.J2Keys, aPedalsPos);
    SetMemoTextColor(memoJack2, aPedalsPos);

    memoJack3.Text := keyService.GetOutputText(keyService.J3Keys, aPedalsPos);
    SetMemoTextColor(memoJack3, aPedalsPos);

    memoJack4.Text := keyService.GetOutputText(keyService.J4Keys, aPedalsPos);
    SetMemoTextColor(memoJack4, aPedalsPos);
  end;
end;

procedure TFormKeyPress.bDoneClick(Sender: TObject);
begin
  if keyService.ActivePedalModified then
    begin
      case keyService.CurrentPedal of
        pLeft:
        begin
          lblLeftModified.Visible := True;
        end;
        pMiddle:
        begin
          lblMiddleModified.Visible := True;
        end;
        pRight:
        begin
          lblRightModified.Visible := True;
        end;
        pJack1:
        begin
          lblJack1Modified.Visible := True;
        end;
        pJack2:
        begin
          lblJack2Modified.Visible := True;
        end;
        pJack3:
        begin
          lblJack3Modified.Visible := True;
        end;
        pJack4:
        begin
          lblJack4Modified.Visible := True;
        end;
      end;
      SetSaveState(ssModifed);
    end;
    SetEditMode(False, pNone);
    LoadPedalText(false);
end;

procedure TFormKeyPress.bCancelClick(Sender: TObject);
begin
  keyService.RestoreKeyList; //Returns to previous values
  SetEditMode(False, pNone);
end;

//Checks if user wants to apply changes in edit mode
function TFormKeyPress.CheckEdit(checkEditing: boolean): boolean;
var
  msgResult: integer;
begin
  result := true;

  //If editing asks if we want to appy changes
  if (EditMode) and (checkEditing) then
  begin
    msgResult := ShowDialog('Apply changes',
      'Key modification in progress, apply changes?', mtConfirmation,
      [mbYes, mbNo, mbCancel]);
    if msgResult = mrYes then
      bDone.Click
     else if msgResult = mrNo then
      bCancel.Click
    else
      result := false;
  end;
end;

//Sets edit mode
procedure TFormKeyPress.SetEditMode(Value: boolean; pedal: TPedal);
begin
  //If trying to edit and file is not valid
  if (Value) and not (fileService.FileIsValid) then
  begin
    //Try to load original pedals.txt file, if not exit
    if not LoadPedalsFile(GPedalsFile) then
      exit;
  end;

  //If we are already modifing a key
  if not(CheckEdit(Value)) then
    exit;

  EditMode := Value;
  keyService.CurrentPedal := pedal;
  memoConfig.Text := '';

  //Creates a backup of keylist before edit to rollback if we cancel
  if EditMode then
  begin
    keyService.BackupKeyList;
    keyService.ActivePedal.Clear;
    CheckKeyboardLayout;
  end;

  bBackspace.Enabled := EditMode;
  bClear.Enabled := EditMode;
  bCancel.Enabled := EditMode;
  bDone.Enabled := EditMode;
  bSpecialAction.Enabled := EditMode;
  bSingleKey.Enabled := EditMode;
  bMultipleKeys.Enabled := EditMode;

  lastKeyDown := 0; //Resets last key down
  lastKeyPressed := 0; //Resets last key pressed
  keyService.ClearModifiers; //Removes all modifiers from memory

  if EditMode then
  begin
    memoConfig.Color := clYellow;
  end
  else
  begin
    memoConfig.Color := memoConfigDefaultColor;
    SetEditButton(False, bLeft);
    SetEditButton(False, bMiddle);
    SetEditButton(False, bRight);
    SetEditButton(False, bJack1);
    SetEditButton(False, bJack2);
    SetEditButton(False, bJack3);
    SetEditButton(False, bJack4);
  end;

  case keyService.CurrentPedal of
    pNone:
    begin
      lblPedal.Caption := '';
    end;
    pLeft:
    begin
      lblPedal.Caption := 'Left pedal';
      SetEditButton(EditMode, bLeft);
    end;
    pMiddle:
    begin
      lblPedal.Caption := 'Middle pedal';
      SetEditButton(EditMode, bMiddle);
    end;
    pRight:
    begin
      lblPedal.Caption := 'Right pedal';
      SetEditButton(EditMode, bRight);
    end;
    pJack1:
    begin
      lblPedal.Caption := 'Jack 1';
      SetEditButton(EditMode, bJack1);
    end;
    pJack2:
    begin
      lblPedal.Caption := 'Jack 2';
      SetEditButton(EditMode, bJack2);
    end;
    pJack3:
    begin
      lblPedal.Caption := 'Jack 3';
      SetEditButton(EditMode, bJack3);
    end;
    pJack4:
    begin
      lblPedal.Caption := 'Jack 4';
      SetEditButton(EditMode, bJack4);
    end;
  end;

  //Sets single key mode (1.0.5)
  SetKeyMode(kmSingle);
end;

//When button configure button si pressed make it highlighted (down)
procedure TFormKeyPress.SetEditButton(isEditMode: boolean; button: TObject);
begin
  if isEditMode then
  begin
    TSpeedButton(button).Down := true;
  end
  else
  begin
    TSpeedButton(button).Down := false;
  end;
end;

//Sets the current save state
procedure TFormKeyPress.SetSaveState(Value: TSaveState);
begin
  SaveState := Value;
  bSave.Enabled := SaveState = ssModifed;

  if SaveState = ssNone then
  begin
    SetEditMode(False, pNone);
    lblLeftModified.Visible := False;
    lblMiddleModified.Visible := False;
    lblRightModified.Visible := False;
    lblJack1Modified.Visible := False;
    lblJack2Modified.Visible := False;
    lblJack3Modified.Visible := False;
    lblJack4Modified.Visible := False;
  end;
end;

procedure TFormKeyPress.bLeftClick(Sender: TObject);
begin
  SetEditMode(True, pLeft);
end;

procedure TFormKeyPress.bMiddleClick(Sender: TObject);
begin
  SetEditMode(True, pMiddle);
end;

procedure TFormKeyPress.bMoreMiddleClick(Sender: TObject);
begin
  ResizeControlMemo(memoMiddle);
end;

procedure TFormKeyPress.bMoreRightClick(Sender: TObject);
begin
  ResizeControlMemo(memoRight);
end;

procedure TFormKeyPress.bMoreJack1Click(Sender: TObject);
begin
  ResizeControlMemo(memoJack1);
end;

procedure TFormKeyPress.bMoreJack2Click(Sender: TObject);
begin
  ResizeControlMemo(memoJack2);
end;

procedure TFormKeyPress.bMoreJack3Click(Sender: TObject);
begin
  ResizeControlMemo(memoJack3);
end;

procedure TFormKeyPress.bMoreJack4Click(Sender: TObject);
begin
  ResizeControlMemo(memoJack4);
end;

procedure TFormKeyPress.bMoreLeftClick(Sender: TObject);
begin
  ResizeControlMemo(memoLeft);
end;

procedure TFormKeyPress.bRightClick(Sender: TObject);
begin
  SetEditMode(True, pRight);
end;

procedure TFormKeyPress.bJack1Click(Sender: TObject);
begin
  SetEditMode(True, pJack1);
end;

procedure TFormKeyPress.bJack2Click(Sender: TObject);
begin
  SetEditMode(True, pJack2);
end;

procedure TFormKeyPress.bJack3Click(Sender: TObject);
begin
  SetEditMode(True, pJack3);
end;

procedure TFormKeyPress.bJack4Click(Sender: TObject);
begin
  SetEditMode(True, pJack4);
end;

procedure TFormKeyPress.bMultipleKeysClick(Sender: TObject);
begin
  SetKeyMode(kmMulti);
end;

procedure TFormKeyPress.bSingleKeyClick(Sender: TObject);
begin
  SetKeyMode(kmSingle);
end;

procedure TFormKeyPress.SetKeyMode(keyMode: TKeyMode);
begin
  if keyService.ActivePedal <> nil then
  begin
    if keyMode = kmMulti then
    begin
      if not keyService.ActivePedal.MultiKey then
        bClear.Click;
      bMultipleKeys.Down := true;
      keyService.ActivePedal.MultiKey := true;
    end
    else
    begin
      if keyService.ActivePedal.MultiKey then
        bClear.Click;
      bSingleKey.Down := true;
      keyService.ActivePedal.MultiKey := false;
    end;
  end;
end;

//Resizes memo control to show more content
procedure TFormKeyPress.ResizeControlMemo(Sender: TObject);
var
  newHeight: integer;
  memoSender: TRichMemo;
  i: integer;
const
  {$ifdef Win32}
  LINE_HEIGHT = 25;
  {$endif}
  {$ifdef Darwin}
  LINE_HEIGHT = 20;
  {$endif}
begin
   memoSender := TRichMemo(Sender);

   //Resets other memo fields
   for i := 0 to pnlRight.ControlCount - 1 do
   begin
      if pnlRight.Controls[i] is TRichMemo then
      begin
        if (pnlRight.Controls[i] <> memoSender) and
          (pnlRight.Controls[i] <> memoConfig) then
          ResetMemo(TRichMemo(pnlRight.Controls[i]));
      end;
   end;

   if (memoSender.Height = memoOriginalHeight) then
   begin
      //Resize memo Heigher = # lines * LINE_HEIGHT pixels
      newHeight := 200;//memoSender.GetTextLen * LINE_HEIGHT;
      if newHeight > memoOriginalHeight then
      begin
         memoSender.Height := newHeight;
         memoSender.BringToFront;
         memoSender.Color := RGB(255, 255, 200);
      end;
   end
   else
   begin
      ResetMemo(memoSender);
   end;

end;

procedure TFormKeyPress.ResetMemo(memoField: TRichMemo);
begin
  memoField.Height := memoOriginalHeight;
  memoField.Color := memoOriginalColor;
end;

procedure TFormKeyPress.CheckKeyboardLayout;
//var
  //isValid: boolean;
  //activeKBLayout: string;
begin
  //Windows
  {$ifdef Win32}
  //activeKBLayout := GetCurrentKeyoardLayout;
  //isValid := keyService.KeyboardLayouts.IsValidKBLayout(activeKBLayout);
  //lblWarningKbLanuage.Visible := not isValid;
  {$endif}
end;

procedure TFormKeyPress.bOpenFileClick(Sender: TObject);
begin
  CheckToSave;
  if pedalOpenDialog.Execute then
  begin
    keyService.UpdateCurrentKeyboardLayout;
    LoadPedalsFile(pedalOpenDialog.FileName);
    SetSaveState(ssNone);
  end;
end;

function TFormKeyPress.LoadPedalsFile(fileName: string): boolean;
var
  loadMessage: string;
  canLoadFile: boolean;
begin
  Result := False;
  canLoadFile := False;
  lblFileName.Caption := '';

  //Checks if file exists, if not, propose to create new file
  if not fileService.CheckIfFileExists(fileName) then
  begin
    if ShowDialog('File', 'Cannot open pedals.txt configuration file.' +
      #10 + 'Create a new file?', mtWarning, [mbYes, mbNo]) = mrYes then
    begin
      fileService.NewFile := True;
      lblFileName.Caption := '[New file]';
      Result := True;
    end;
  end
  else
    canLoadFile := True;

  if canLoadFile then
  begin
    //Tries to load file, if it works open it and load keys
    loadMessage := fileService.LoadFile(fileName, true);
    if loadMessage = '' then
    begin
      Result := True;
      lblFileName.Caption := fileService.CompleteFileName;

      keyService.LoadKeysFromFile(keyService.LPKeys, fileService.LPedal);
      keyService.LoadKeysFromFile(keyService.MPKeys, fileService.MPedal);
      keyService.LoadKeysFromFile(keyService.RPKeys, fileService.RPedal);
      keyService.LoadKeysFromFile(keyService.J1Keys, fileService.Jack1);
      keyService.LoadKeysFromFile(keyService.J2Keys, fileService.Jack2);
      keyService.LoadKeysFromFile(keyService.J3Keys, fileService.Jack3);
      keyService.LoadKeysFromFile(keyService.J4Keys, fileService.Jack4);
      LoadPedalText(false);
    end
    else
    begin
      ShowDialog('Load file', loadMessage, mtError, [mbOK]);
    end;
  end;
end;

procedure TFormKeyPress.CheckToSave;
begin
  if SaveState = ssModifed then
  begin
    if ShowDialog('Save',
      'Do you want to save changes to the pedal configuration file?',
      mtConfirmation, [mbYes, mbNo]) = mrYes then
      bSave.Click
    else
      SetSaveState(ssNone);
  end;
end;

function TFormKeyPress.Save: boolean;
var
  errorMsg: string;
begin
  result := false;
  if (fileService.FileIsValid) then
  begin
    keyService.UpdateCurrentKeyboardLayout;

    errorMsg := '';

    CheckEdit(true);

    fileService.LPedal := keyService.ConvertToTextFileFmt(keyService.LPKeys);
    fileService.MPedal := keyService.ConvertToTextFileFmt(keyService.MPKeys);
    fileService.RPedal := keyService.ConvertToTextFileFmt(keyService.RPKeys);
    fileService.Jack1 := keyService.ConvertToTextFileFmt(keyService.J1Keys);
    fileService.Jack2 := keyService.ConvertToTextFileFmt(keyService.J2Keys);
    fileService.Jack3 := keyService.ConvertToTextFileFmt(keyService.J3Keys);
    fileService.Jack4 := keyService.ConvertToTextFileFmt(keyService.J4Keys);
    if fileService.SaveFile(errorMsg) then
    begin
      ShowDialog('Save', 'SAVE DONE.' + #10 + #10 + 'NOW CHANGE YOUR SE2 TO ''PLAY MODE'' TO IMPLEMENT CHANGES.', mtConfirmation, [mbOK]);
      lblFileName.Caption := fileService.CompleteFileName;
      SetSaveState(ssNone);
      result := true;
    end
    else
      ShowDialog('Save', 'Error saving configuration file: ' + errorMsg,
        mtError, [mbOK]);
  end
  else
  begin
    ShowDialog('Save', 'File does not exist: ' + fileService.CompleteFileName,
        mtError, [mbOK]);
  end;
end;

procedure TFormKeyPress.bSaveClick(Sender: TObject);
begin
  if fileService.FileIsValid then
  begin
    if fileService.NewFile then
      SaveAs
    else
      Save;
  end
  else
    ShowDialog('Error', 'File is not valid: ' + fileService.CompleteFileName,
      mtError, [mbOK]);
end;

procedure TFormKeyPress.bSaveAsClick(Sender: TObject);
begin
  SaveAs;
end;

procedure TFormKeyPress.SaveAs;
begin
  NeedInput := True;
  if pedalSaveDialog.Execute then
  begin
    //Sets new filename
    if fileService.SetNewFileName(pedalSaveDialog.FileName) then
      Save;
  end;
  NeedInput := False;
end;

procedure TFormKeyPress.SetMemoTextColor(aMemo: TRichMemo; aPedalsPos: TPedalsPos);
var
  i: integer;
  fontColor: TColor;
begin
  //Version 1.0.6, reset to default color before setting red (MacOS bug)
  fontColor := clDefault;
  if darkTheme and (aMemo <> memoConfig) then
    fontColor := clWhite;

  aMemo.SetRangeColor(0, Length(aMemo.Text), fontColor);

  if (aPedalsPos <> nil) then
  begin
    for i := 0 to Length(aPedalsPos) - 1 do
    begin
      aMemo.SetRangeColor(aPedalsPos[i].iStart, aPedalsPos[i].iEnd - aPedalsPos[i].iStart, clRed);
    end;
  end;
end;

//initialization
//  {$ifdef Darwin}Mac_OS_Handler_UPP:=NewEventHandlerUPP (@MAC_OS_Handler); {$endif}

//finalization
//  {$ifdef Darwin}DisposeEventHandlerUPP(Mac_OS_Handler_UPP); {$endif}

end.
