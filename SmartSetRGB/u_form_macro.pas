unit u_form_macro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, RichMemo, LabelBox, uEKnob, ueled, HSSpeedButton,
  u_base_form, u_keys, u_const, u_key_layer, lcltype,
  UserDialog
  {$ifdef Win64},Windows{$endif};

type

  { TFormMacro }

  TFormMacro = class(TBaseForm)
    btnCancel: THSSpeedButton;
    btnLeftShift: THSSpeedButton;
    btnLeftCtrl: THSSpeedButton;
    btnLeftAlt: THSSpeedButton;
    btnRightShift: THSSpeedButton;
    btnRightCtrl: THSSpeedButton;
    btnRightAlt: THSSpeedButton;
    btnWindowsCombos: THSSpeedButton;
    btnTimingDelays: THSSpeedButton;
    btnPaste: THSSpeedButton;
    btnDone: THSSpeedButton;
    btnCommonShortcuts: THSSpeedButton;
    btnResetAll: THSSpeedButton;
    btnCopy: THSSpeedButton;
    btnResetKey: THSSpeedButton;
    btnMouseClicks: THSSpeedButton;
    image: TImage;
    knobSpeed: TuEKnob;
    knobMultiplay: TuEKnob;
    kbLeftShift: TLabelBox;
    kbRightShift: TLabelBox;
    kbLeftCtrl: TLabelBox;
    kbRightCtrl: TLabelBox;
    kbLeftAlt: TLabelBox;
    kbRightAlt: TLabelBox;
    lblGlobal: TLabel;
    lblDisable: TLabel;
    lblActions1: TLabel;
    lblSpeedText: TLabel;
    lblMultiplayText: TLabel;
    lblDisplaying: TStaticText;
    lblMacro1: TLabel;
    lblMacro2: TLabel;
    lblMacro3: TLabel;
    lblMacroMultiplay: TStaticText;
    lblPlaybackSpeed: TStaticText;
    ledSpeed: TuELED;
    ledMultiplay: TuELED;
    memoMacro: TRichMemo;
    rgMacro1: TRadioButton;
    rgMacro2: TRadioButton;
    rgMacro3: TRadioButton;
    StaticText3: TStaticText;
    textMacroInput: TStaticText;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCommonShortcutsClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure btnMouseClicksClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnResetAllClick(Sender: TObject);
    procedure btnCoTriggerClick(Sender: TObject);
    procedure btnResetKeyClick(Sender: TObject);
    procedure btnTimingDelaysClick(Sender: TObject);
    procedure btnWindowsCombosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure knobMultiplayChange(Sender: TObject);
    procedure knobMultiplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure knobSpeedChange(Sender: TObject);
    procedure knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure KeyButtonClick(Sender: TObject);
  private
    closing: boolean;
    loadingMacro: boolean;
    settingsChanged: boolean;
    procedure ActivateCoTrigger(coTriggerBtn: THSSpeedButton);
    procedure ActivateCoTrigger(keyButton: TLabelBox);
    function GetCoTriggerKey(Sender: TObject): TKey;
    { private declarations }
    procedure InitMacro;
    procedure LoadMacro;
    procedure RemoveCoTrigger(key: word);
    procedure ResetCoTrigger(coTriggerBtn: THSSpeedButton);
    procedure ResetCoTrigger(keyButton: TLabelBox);
    procedure ResetMacroCoTriggers;
    procedure SetCoTrigger(aKey: TKey);
    procedure SetMacroText(pushCursorToEnd: boolean; cursorPos: integer=-1);
    procedure SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
  public
    { public declarations }
  end;

var
  FormMacro: TFormMacro;

implementation

uses u_form_main;

{$R *.lfm}

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
end;

{ TFormMacro }

procedure TFormMacro.FormCreate(Sender: TObject);
begin
  knobMultiplay.Image := MainForm.imageKnob.Picture.Bitmap;
  knobSpeed.Image := MainForm.imageKnob.Picture.Bitmap;
  settingsChanged := false;
  lblTitle.Visible := false;
  loadingMacro := false;
  closing := false;
  FormStyle := fsStayOnTop;
  InitMacro;
end;

procedure TFormMacro.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  closing := true;
end;

procedure TFormMacro.FormDeactivate(Sender: TObject);
begin
  //ShowMessage('Deactivating');
  //if (not closing) then
  //  self.Show;
end;

procedure TFormMacro.btnCancelClick(Sender: TObject);
begin
  MainForm.CancelMacro;
  Close;
end;

procedure TFormMacro.btnCloseClick(Sender: TObject);
begin
  MainForm.CancelMacro;
  inherited;
end;

procedure TFormMacro.btnDoneClick(Sender: TObject);
begin
  if (MainForm.AcceptMacro) then
    Close;
end;

procedure TFormMacro.btnCommonShortcutsClick(Sender: TObject);
begin

end;

procedure TFormMacro.btnMouseClicksClick(Sender: TObject);
begin

end;

procedure TFormMacro.btnTimingDelaysClick(Sender: TObject);
begin

end;

procedure TFormMacro.btnWindowsCombosClick(Sender: TObject);
begin

end;

procedure TFormMacro.btnCopyClick(Sender: TObject);
var
  hideNotif: integer;
begin
  if (MainForm.IsKeyLoaded) then
  begin
    if (MainForm.activeKbKey.ActiveMacro <> nil) then
    begin
      MainForm.copiedMacro := MainForm.keyService.CopyMacro(MainForm.activeKbKey.ActiveMacro);
      if (not MainForm.fileService.AppSettings.CopyMacroMsg) then
      begin
        hideNotif := ShowDialog('Copy', 'Macro copied. Now select a new trigger key or load a new layout, then hit Paste.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          MainForm.fileService.SetCopyMacroMsg(true);
          MainForm.fileService.SaveAppSettings;
        end;
      end;
    end
    else
      ShowDialog('Copy Macro', 'You must have an active maro to copy', mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT);
  end;
end;

procedure TFormMacro.btnPasteClick(Sender: TObject);
begin
  if (MainForm.IsKeyLoaded) then
  begin
    if (MainForm.activeKbKey.ActiveMacro <> nil) and (MainForm.copiedMacro <> nil) then
    begin
      MainForm.activeKbKey.IsMacro := true;
      MainForm.activeKbKey.ActiveMacro.Assign(MainForm.copiedMacro);
      SetMacroText(true);
      LoadMacro;
      MainForm.MacroModified := true;
    end;
  end;
end;

procedure TFormMacro.btnResetAllClick(Sender: TObject);
begin
  if (MainForm.IsKeyLoaded) and (MainForm.activeKbKey.IsMacro) then
  begin
    memoMacro.Lines.Clear;
    MainForm.keyService.ClearModifiers;
    MainForm.activeKbKey.ActiveMacro.Clear;
    MainForm.MacroModified := true;
  end;
end;

procedure TFormMacro.btnResetKeyClick(Sender: TObject);
var
  cursorPos:integer;
  keyIdx: integer;
  aKey: TKey;
  keyText: string;
  isLongText: boolean;
  prevKey: integer;
begin
  if (MainForm.IsKeyLoaded) and (MainForm.activeKbKey.IsMacro) then
  begin
    cursorPos := memoMacro.SelStart;
    if (cursorPos > 0) then
    begin
      keyIdx := MainForm.keyService.GetKeyAtPosition(MainForm.activeKbKey.ActiveMacro, cursorPos);
      if (keyIdx >= 0) then
      begin
        aKey := MainForm.activeKbKey.ActiveMacro[keyIdx];
        keyText := MainForm.keyService.GetSingleKeyText(aKey, isLongText);
        prevKey := MainForm.GetCursorPrevKey(cursorPos);
        if MainForm.keyService.RemoveKey(MainForm.activeKbKey, keyIdx) then
        begin
          MainForm.MacroModified := true;

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

procedure TFormMacro.knobMultiplayChange(Sender: TObject);
begin
  lblMultiplayText.Caption := IntToStr(Round(knobMultiplay.Position));
end;

procedure TFormMacro.knobMultiplayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
      settingsChanged := true;
    end;

    if (not loadingMacro) then
    begin
      MainForm.activeKbKey.ActiveMacro.MacroRptFreq := value;
      MainForm.MacroModified := true;
    end;
  end;
end;

procedure TFormMacro.knobSpeedChange(Sender: TObject);
begin
  lblSpeedText.Caption := IntToStr(Round(knobSpeed.Position));
end;

procedure TFormMacro.knobSpeedMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingMacro) then
  begin
    knobPos := knobSpeed.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobSpeed.Position := value;
      settingsChanged := true;
    end;

    if (not loadingMacro) then
    begin
      MainForm.activeKbKey.ActiveMacro.MacroSpeed := value;
      MainForm.MacroModified := true;
    end;
  end;

end;

procedure TFormMacro.KeyButtonClick(Sender: TObject);
var
  button: TLabelBox;
  aKey: TKey;
begin
  if MainForm.IsKeyLoaded then
  begin
    button := Sender as TLabelBox;
    if (button.BorderStyle = bsNone) then
    begin
      ResetMacroCoTriggers;

      ActivateCoTrigger(button);

      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
      begin
        MainForm.activeKbKey.ActiveMacro.CoTrigger1 := aKey.CopyKey;
        MainForm.MacroModified := true;
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
  Repaint;
end;

procedure TFormMacro.InitMacro;
begin
  rgMacro1.Checked := true;
  loadingMacro := true;
  memoMacro.Text := '';
  //jm temp tbSpeed.Position := DEFAULT_MACRO_SPEED;
  knobSpeed.Position := DEFAULT_MACRO_SPEED;
  //jm temp tbMultiplay.Position := DEFAULT_MACRO_FREQ;
  knobMultiplay.Position := DEFAULT_MACRO_FREQ;
  loadingMacro := false;

  LoadMacro;
  SetMacroText(true);

  //jm temp
  //EnableMacroBox(MacroMode);
  //btnCancelMacro.Enabled := MacroMode;
  //btnDoneMacro.Enabled := MacroMode;
  //btnBackspace.Enabled := MacroMode;
  //btnClear.Enabled := MacroMode;
  //btnSpecialActionsMacro.Enabled := MacroMode;
  //btnCopy.Enabled := MacroMode;
  //btnPaste.Enabled := MacroMode;
  //bLShiftMacroOld.Enabled := MacroMode;
  //bLCtrlMacroOld.Enabled := MacroMode;
  //bLAltMacroOld.Enabled := MacroMode;
  //bRAltMacroOld.Enabled := MacroMode;
  //bRCtrlMacroOld.Enabled := MacroMode;
  //bRShiftMacroOld.Enabled := MacroMode;
  //ResetMacroCoTriggers;
  //textMacroInput.Visible := IsKeyLoaded and (activeKbKey.ActiveMacro.Count = 0) and (activeKbKey.CanAssignMacro);
  //
  //if (MacroMode) and (IsKeyLoaded) and (activeKbKey.IsMacro) then
  //begin
  //  //activeKbKey.IsMacro := true;
  //  LoadMacro;
  //  SetMacroText(true);
  //end
  //else
  //begin
  //  lblMacro1.Font.Color := fontColor;
  //  lblMacro2.Font.Color := fontColor;
  //  lblMacro3.Font.Color := fontColor;
  //  loadingMacro := true;
  //  memoMacro.Text := '';
  //  tbSpeed.Position := DEFAULT_MACRO_SPEED;
  //  slPlaybackSpeed.Position := DEFAULT_MACRO_SPEED;
  //  tbMultiplay.Position := DEFAULT_MACRO_FREQ;
  //  slMacroMultiplay.Position := DEFAULT_MACRO_FREQ;
  //  loadingMacro := false;
  //end;
end;

//Load macro from key
procedure TFormMacro.LoadMacro;
begin
  loadingMacro := true;
  ResetMacroCoTriggers;
  MainForm.lastKeyDown := 0; //Resets last key down
  MainForm.lastKeyPressed := 0; //Resets last key pressed
  MainForm.keyService.ClearModifiers; //Removes all modifiers from memory

  if (MainForm.IsKeyLoaded) then
  begin
    if (rgMacro1.Checked) then
      MainForm.activeKbKey.ActiveMacro := MainForm.activeKbKey.Macro1
    else if (rgMacro2.Checked) then
      MainForm.activeKbKey.ActiveMacro := MainForm.activeKbKey.Macro2
    else if (rgMacro3.Checked) then
      MainForm.activeKbKey.ActiveMacro := MainForm.activeKbKey.Macro3;

    if (MainForm.activeKbKey.ActiveMacro.MacroSpeed >= MACRO_SPEED_MIN) and (MainForm.activeKbKey.ActiveMacro.MacroSpeed <= MACRO_SPEED_MAX) then
    begin
      knobSpeed.Position := MainForm.activeKbKey.ActiveMacro.MacroSpeed
    end
    else
    begin
      knobSpeed.Position := DEFAULT_MACRO_SPEED;
    end;

    if (MainForm.activeKbKey.ActiveMacro.MacroRptFreq >= MACRO_FREQ_MIN) and (MainForm.activeKbKey.ActiveMacro.MacroRptFreq <= MACRO_FREQ_MAX) then
    begin
      knobMultiplay.Position := MainForm.activeKbKey.ActiveMacro.MacroRptFreq
    end
    else
    begin
      knobMultiplay.Position := DEFAULT_MACRO_FREQ;
    end;

    if MainForm.activeKbKey.Macro1.Count > 0 then
      lblMacro1.Font.Color := MainForm.blueColor
    else
      lblMacro1.Font.Color := MainForm.fontColor;
    if MainForm.activeKbKey.Macro2.Count > 0 then
      lblMacro2.Font.Color := MainForm.blueColor
    else
      lblMacro2.Font.Color := MainForm.fontColor;
    if MainForm.activeKbKey.Macro3.Count > 0 then
      lblMacro3.Font.Color := MainForm.blueColor
    else
      lblMacro3.Font.Color := MainForm.fontColor;

    SetCoTrigger(MainForm.activeKbKey.ActiveMacro.CoTrigger1);
  end;
  loadingMacro := false;
end;

procedure TFormMacro.SetCoTrigger(aKey: TKey);
begin
  if (aKey <> nil) then
  begin
    //if (aKey.Key = VK_LSHIFT) then
    //  ActivateCoTrigger(btnLeftShift);
    //if (aKey.Key = VK_LCONTROL) then
    //  ActivateCoTrigger(btnLeftCtrl);
    //if (aKey.Key = VK_LMENU) then
    //  ActivateCoTrigger(btnLeftAlt);
    //if (aKey.Key = VK_RSHIFT) then
    //  ActivateCoTrigger(btnRightShift);
    //if (aKey.Key = VK_RCONTROL) then
    //  ActivateCoTrigger(btnRightCtrl);
    //if (aKey.Key = VK_RMENU) then
    //  ActivateCoTrigger(btnRightAlt);

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

//Resets co-trigger buttons to default values
procedure TFormMacro.ResetMacroCoTriggers;
begin
  //ResetCoTrigger(btnLeftShift);
  //ResetCoTrigger(btnRightShift);
  //ResetCoTrigger(btnLeftCtrl);
  //ResetCoTrigger(btnRightCtrl);
  //ResetCoTrigger(btnLeftAlt);
  //ResetCoTrigger(btnRightAlt);

  ResetCoTrigger(kbLeftShift);
  ResetCoTrigger(kbRightShift);
  ResetCoTrigger(kbLeftCtrl);
  ResetCoTrigger(kbRightCtrl);
  ResetCoTrigger(kbLeftAlt);
  ResetCoTrigger(kbRightAlt);
end;

procedure TFormMacro.ActivateCoTrigger(coTriggerBtn: THSSpeedButton);
begin
  coTriggerBtn.Down := true;
  //coTriggerBtn.Font.Bold := true;
  //coTriggerBtn.Font.Color := MainForm.blueColor;
end;

procedure TFormMacro.ActivateCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BorderWidth := 1;
  keyButton.BorderColor := MainForm.blueColor;
  keyButton.BorderStyle := bsSingle;
end;

procedure TFormMacro.ResetCoTrigger(coTriggerBtn: THSSpeedButton);
begin
  coTriggerBtn.Down := false;
  //coTriggerBtn.Font.Bold := true;
  //if (GApplication = APPL_FSPRO) then
  //  coTriggerBtn.Font.Color := KINESIS_DARK_GRAY_FS
  //else
  //  coTriggerBtn.Font.Color := clBlack;
end;

procedure TFormMacro.ResetCoTrigger(keyButton: TLabelBox);
begin
  keyButton.BackColor := clNone;
  keyButton.BorderColor := clNone;
  keyButton.BorderStyle := bsNone;
end;

function TFormMacro.GetCoTriggerKey(Sender: TObject): TKey;
begin
  //if (Sender = btnLeftShift) then
  //  result := MainForm.keyService.FindKeyConfig(VK_LSHIFT)
  //else if (Sender = btnRightShift) then
  //  result := MainForm.keyService.FindKeyConfig(VK_RSHIFT)
  //else if (Sender = btnLeftCtrl) then
  //  result := MainForm.keyService.FindKeyConfig(VK_LCONTROL)
  //else if (Sender =  btnRightCtrl) then
  //  result := MainForm.keyService.FindKeyConfig(VK_RCONTROL)
  //else if (Sender = btnLeftAlt) then
  //  result := MainForm.keyService.FindKeyConfig(VK_LMENU)
  //else if (Sender = btnRightAlt) then
  //  result := MainForm.keyService.FindKeyConfig(VK_RMENU)
  //else
  //  result := nil;

  if (Sender = kbLeftShift) then
    result := MainForm.keyService.FindKeyConfig(VK_LSHIFT)
  else if (Sender = kbRightShift) then
    result := MainForm.keyService.FindKeyConfig(VK_RSHIFT)
  else if (Sender = kbLeftCtrl) then
    result := MainForm.keyService.FindKeyConfig(VK_LCONTROL)
  else if (Sender =  kbRightCtrl) then
    result := MainForm.keyService.FindKeyConfig(VK_RCONTROL)
  else if (Sender = kbLeftAlt) then
    result := MainForm.keyService.FindKeyConfig(VK_LMENU)
  else if (Sender = kbRightAlt) then
    result := MainForm.keyService.FindKeyConfig(VK_RMENU)
  else
    result := nil;
end;

procedure TFormMacro.btnCoTriggerClick(Sender: TObject);
var
  button: THSSpeedButton;
  aKey: TKey;
begin
  if MainForm.IsKeyLoaded then
  begin
    button := Sender as THSSpeedButton;
    if (button.Down) then
    begin
      ResetMacroCoTriggers;

      ActivateCoTrigger(button);

      aKey := GetCoTriggerKey(Sender);
      if (aKey <> nil) then
      begin
        MainForm.activeKbKey.ActiveMacro.CoTrigger1 := aKey.CopyKey;
        MainForm.MacroModified := true;
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
end;

procedure TFormMacro.RemoveCoTrigger(key: word);
begin
  if MainForm.IsKeyLoaded then
  begin
    MainForm.MacroModified := true;
    if (MainForm.activeKbKey.ActiveMacro.CoTrigger1 <> nil) and (MainForm.activeKbKey.ActiveMacro.CoTrigger1.Key = key) then
      MainForm.activeKbKey.ActiveMacro.CoTrigger1 := nil;
  end;
end;

procedure TFormMacro.SetMemoTextColor(aMemo: TRichMemo; aKeysPos: TKeysPos);
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

procedure TFormMacro.SetMacroText(pushCursorToEnd: boolean; cursorPos: integer = -1);
var
  aKeysPos: TKeysPos;
begin
  if (MainForm.activeKbKey.IsMacro) then
  begin
    //Disable visual effects on Macro before assigning text
    {$ifdef Win64}
    SendMessage(memoMacro.Handle, WM_SETREDRAW, WPARAM(False), 0);
    {$endif}
    {$ifdef Darwin}
    //jm todo SendMessage(memoMacro.Handle, LM_SETREDRAW, WPARAM(False), 0);
    {$endif}

    memoMacro.Text := MainForm.keyService.GetMacroText(MainForm.activeKbKey.ActiveMacro, aKeysPos);

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
      cursorPos := MainForm.GetCursorNextKey(cursorPos);
      memoMacro.SelStart := cursorPos;
    end;

    textMacroInput.Visible := MainForm.activeKbKey.ActiveMacro.Count = 0;
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

end.

