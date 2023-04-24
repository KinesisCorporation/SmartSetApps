unit u_form_tapandhold;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const, UserDialog, lcltype,
  u_keys, u_common_ui, u_key_service, ColorSpeedButtonCS, LineObj, menus,
  u_form_select_macro;

type

  { TFormTapAndHold }

  TFormTapAndHold = class(TBaseForm)
    btnSelMacroTap: TColorSpeedButtonCS;
    btnSelMacroHold: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    btnAccept: TColorSpeedButtonCS;
    btnCancel1: TColorSpeedButtonCS;
    btnAccept1: TColorSpeedButtonCS;
    eHoldAction: TEdit;
    eTimingDelay: TEdit;
    eTapAction: TEdit;
    imgListTiming: TImageList;
    lblInfo: TLabel;
    lblNote: TLabel;
    lblTapAction: TLabel;
    lblHoldAction: TLabel;
    lblDelay: TLabel;
    procedure btnAcceptMouseExit(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseExit(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnSelMacroHoldClick(Sender: TObject);
    procedure btnSelMacroTapClick(Sender: TObject);
    procedure eHoldActionEnter(Sender: TObject);
    procedure eHoldActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eTapActionEnter(Sender: TObject);
    procedure eTapActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eTimingDelayChange(Sender: TObject);
    procedure eTimingDelayKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    backColor: TColor;
    fontColor: TColor;
    activeColor: TColor;
    popMacrosTap: TPopupMenu;
    popMacrosHold: TPopupMenu;
    acceptEvent: TNotifyEvent;
    closeEvent: TNotifyEvent;
    lastEdit: TEdit;
    procedure AddMenuItem(var popMenu: TPopupMenu; itemName: string;
      keyCode: integer);
    procedure InitPopupMenus;
    procedure MenuDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      AState: TOwnerDrawState);
    procedure MenuItemClick(Sender: TObject);
    function Validate: boolean;
  public
    tapAction: word;
    holdAction: word;
    timingDelay: integer;
    isModal: boolean;
    keyService: TKeyService;
    procedure SetKeyPress(key: word; edit: TEdit = nil);
  end;

var
  FormTapAndHold: TFormTapAndHold;
  TapAndHoldOpened: boolean;
  function ShowTapAndHold(aKeyService: TKeyService; aTapAction: TKey; aHoldAction: TKey; iTimingDelay: integer; backColor: TColor; fontColor: TColor; activeColor: TColor; showModal: boolean = true; OnAccept: TNotifyEvent = nil; OnClose: TNotifyEvent = nil): boolean;

implementation

{$R *.lfm}

function ShowTapAndHold(aKeyService: TKeyService; aTapAction: TKey; aHoldAction: TKey; iTimingDelay: integer; backColor: TColor; fontColor: TColor; activeColor: TColor; showModal: boolean = true; OnAccept: TNotifyEvent = nil; OnClose: TNotifyEvent = nil): boolean;
var
  DefaultDelay: integer;
begin
  result := false;
  DefaultDelay := 250;

  //Close the dialog if opened
  if FormTapAndHold <> nil then
    FreeAndNil(FormTapAndHold);

  //Creates the dialog form
  Application.CreateForm(TFormTapAndHold, FormTapAndHold);

  //Set defautl delay per application
  if (GApplication in [APPL_ADV360]) then
    DefaultDelay := 150;

  //FormTapAndHold.timingDelay := iTimingDelay;
  if (iTimingDelay <= 0) then
    iTimingDelay := DefaultDelay;

  //Set Modal and events
  FormTapAndHold.isModal := showModal;
  FormTapAndHold.acceptEvent := OnAccept;
  FormTapAndHold.closeEvent := OnClose;
  FormTapAndHold.lblInfo.Visible := not showModal;

  //Loads colors
  FormTapAndHold.backColor := backColor;
  FormTapAndHold.fontColor := fontColor;
  FormTapAndHold.activeColor := activeColor;
  FormTapAndHold.Color := backColor;
  FormTapAndHold.Font.Color := fontColor;
  FormTapAndHold.lblTapAction.Font.Color := fontColor;
  FormTapAndHold.lblHoldAction.Font.Color := fontColor;
  FormTapAndHold.lblDelay.Font.Color := fontColor;
  FormTapAndHold.lblTitle.Font.Color := fontColor;
  FormTapAndHold.lblNote.Font.Color := fontColor;
  FormTapAndHold.lblInfo.Font.Color := fontColor;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormTapAndHold.btnCancel, FormTapAndHold.imgListTiming, 4);
    LoadButtonImage(FormTapAndHold.btnAccept, FormTapAndHold.imgListTiming, 6);
  end;

  FormTapAndHold.keyService := aKeyService;
  FormTapAndHold.eTimingDelay.Text := IntToStr(iTimingDelay);
  if (aTapAction <> nil) then
    FormTapAndHold.SetKeyPress(aTapAction.Key, FormTapAndHold.eTapAction)
  else
    FormTapAndHold.tapAction := 0;
  if (aHoldAction <> nil) then
    FormTapAndHold.SetKeyPress(aHoldAction.Key, FormTapAndHold.eHoldAction)
   else
    FormTapAndHold.holdAction := 0;

  if (showModal) then
  begin
    //Shows dialog and returns value
    if FormTapAndHold.ShowModal() = mrOK then
    begin
      result := true;
    end;
  end
  else
  begin
    FormTapAndHold.FormStyle:= fsStayOnTop;
    FormTapAndHold.Show();
  end;
end;

{ TFormTapAndHold }

procedure TFormTapAndHold.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Assign Tap and Hold Action';
end;

procedure TFormTapAndHold.FormShow(Sender: TObject);
begin
  inherited;
  eTapAction.SetFocus;
  eTapAction.SelStart := 0;
  //Duplicates value
  //eTapAction.SelText := eTapAction.Text;
  eTapAction.SelLength := 0;
  InitPopupMenus;
  TapAndHoldOpened := true;
  btnSelMacroTap.Visible := (GApplication = APPL_ADV360) and (fileService.VersionBiggerEqualKBD(1, 0, 69) or GDemoMode);
  btnSelMacroHold.Visible := (GApplication = APPL_ADV360) and (fileService.VersionBiggerEqualKBD(1, 0, 69) or GDemoMode);
end;

procedure TFormTapAndHold.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TapAndHoldOpened := false;
  if (Assigned(closeEvent)) then
     closeEvent(self);
  self := nil;
end;

procedure TFormTapAndHold.InitPopupMenus;
var
  macroIdx: integer;
  macro: TKeyList;
  aKey: TKey;
begin
  popMacrosTap := TPopupMenu.Create(self);
  popMacrosHold := TPopupMenu.Create(self);
  popMacrosTap.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  popMacrosHold.OnDrawItem := TMenuDrawItemEvent(@MenuDrawItem);
  for macroIdx := 0 to keyService.Macros.Count - 1 do
  begin
    macro := TKeyList(keyService.Macros[macroIdx]);
    aKey := keyService.GetKeyConfig(macro.TriggerKey);
    AddMenuItem(popMacrosTap, aKey.OtherDisplayText, aKey.Key);
    AddMenuItem(popMacrosHold, aKey.OtherDisplayText, aKey.Key);
  end;
end;

procedure TFormTapAndHold.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 4)
  else
    LoadButtonImage(sender, imgListTiming, 0);
  if (not isModal) then
    Close;
end;

procedure TFormTapAndHold.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 6)
    else
      LoadButtonImage(sender, imgListTiming, 2);
  end;
end;

procedure TFormTapAndHold.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 7)
  else
    LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormTapAndHold.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 4)
    else
      LoadButtonImage(sender, imgListTiming, 0);
  end;
end;

procedure TFormTapAndHold.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 5)
  else
    LoadButtonImage(sender, imgListTiming, 1);
end;

function TFormTapAndHold.Validate: boolean;
begin
  result := false;
  if (timingDelay < MIN_TIMING_DELAY) or (timingDelay > MAX_TIMING_DELAY) then
    ShowDialog('Tap and Hold Action', 'Please select a timing delay between 1ms and 999ms.', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
  else if (tapAction <= 0) then
    ShowDialog('Tap and Hold Action', 'Plese select a Tap Action', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
  else if (holdAction <= 0) then
    ShowDialog('Tap and Hold Action', 'Plese select a Hold Action', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
  else
    result := true;
end;

procedure TFormTapAndHold.btnAcceptClick(Sender: TObject);
begin
  if (Validate) then
  begin
    ModalResult := mrOK;
    if (not isModal) then
    begin
      if (Assigned(acceptEvent)) then
         acceptEvent(self);
    end;
  end;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormTapAndHold.btnSelMacroHoldClick(Sender: TObject);
var
  trigger: integer;
begin
  trigger := ShowSelectMacro('Assign a Macro to the Tap Action', keyService, backColor, fontColor, activeColor);
  if (trigger > 0) then
    SetKeyPress(trigger, eHoldAction);
//var
//  pt: TPoint;
//begin
  //pt := eHoldAction.ClientToScreen(Point(0,0));
  //popMacrosHold.PopUp(pt.x, pt.y + eHoldAction.Height);
end;

procedure TFormTapAndHold.btnSelMacroTapClick(Sender: TObject);
var
  trigger: integer;
begin
  trigger := ShowSelectMacro('Assign a Macro to the Tap Action', keyService, backColor, fontColor, activeColor);
  if (trigger > 0) then
    SetKeyPress(trigger, eTapAction);
//var
//  pt: TPoint;
//begin
//  pt := eTapAction.ClientToScreen(Point(0,0));
//  popMacrosTap.PopUp(pt.x, pt.y + eTapAction.Height);
end;

procedure TFormTapAndHold.eHoldActionEnter(Sender: TObject);
begin
  lastEdit := (Sender as TEdit);
end;

procedure TFormTapAndHold.AddMenuItem(var popMenu: TPopupMenu; itemName: string; keyCode: integer);
var
  menuItem: TMenuItem;
begin
  menuItem := TMenuItem.Create(popMenu);
  menuItem.Caption := itemName;
  menuItem.Tag := keyCode;
  menuItem.OnClick := @MenuItemClick;
  popMenu.Items.Add(menuItem);
end;

procedure TFormTapAndHold.MenuItemClick(Sender: TObject);
var
  mnu: TMenuItem;
  keyCode: Integer;
begin
  mnu := (sender as TMenuItem);
  keyCode := mnu.Tag;

  if (keyCode > 0) then
  begin
    if (mnu.GetParentMenu = popMacrosTap) then
    begin
      eTapAction.Text := mnu.Caption;
      tapAction := keyCode;
    end
    else
    begin
      eHoldAction.Text := mnu.Caption;
      holdAction := keyCode;
    end;
  end;
end;

procedure TFormTapAndHold.eHoldActionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$ifdef Darwin}
  SetKeyPress(key, eHoldAction);
  {$endif}
  key := 0;
end;

procedure TFormTapAndHold.eTapActionEnter(Sender: TObject);
begin
  lastEdit := (Sender as TEdit);
end;

procedure TFormTapAndHold.eTapActionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$ifdef Darwin}
  SetKeyPress(key, eTapAction);
  {$endif}
  key := 0;
end;

procedure TFormTapAndHold.eTimingDelayChange(Sender: TObject);
begin
  timingDelay := ConvertToInt(FormTapAndHold.eTimingDelay.Text);
end;

procedure TFormTapAndHold.eTimingDelayKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    timingDelay := ConvertToInt(FormTapAndHold.eTimingDelay.Text, 0);
    if (Key = VK_UP) then
    begin
      if (timingDelay < MAX_TIMING_DELAY) then
        inc(timingDelay)
      else
        timingDelay := MAX_TIMING_DELAY;
      FormTapAndHold.eTimingDelay.Text := IntToStr(timingDelay);
    end
    else if (Key = VK_DOWN) then
    begin
      if (timingDelay > MIN_TIMING_DELAY) then
        dec(timingDelay)
      else
        timingDelay := MIN_TIMING_DELAY;
      FormTapAndHold.eTimingDelay.Text := IntToStr(timingDelay);
    end;
  end;
end;

procedure TFormTapAndHold.SetKeyPress(key: word; edit: TEdit);
var
  aKey: TKey;
begin
  if (key <> 0) then
  begin
    aKey := keyService.GetKeyConfig(key);
    if (aKey <> nil) then
    begin
      if (edit = eTapAction) or ((edit = nil) and eTapAction.Focused) then
      begin
        eTapAction.Text := aKey.OtherDisplayText;
        tapAction := key;
      end
      else if (edit = eHoldAction) or ((edit = nil) and eHoldAction.Focused) then
      begin
        eHoldAction.Text := aKey.OtherDisplayText;
        holdAction := key;
      end
      else
      begin
        if (lastEdit <> nil) then
          SetKeyPress(key, lastEdit);
      end;
    end;
    FreeAndNil(aKey);
  end;
end;

procedure TFormTapAndHold.MenuDrawItem(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; AState: TOwnerDrawState);
var
  mnu: TMenuItem;
begin
  mnu := (sender as TMenuItem);
  aCanvas.font.color := fontColor;
  aCanvas.brush.color := backColor;
  acanvas.brush.style := bsSolid;
  if (odSelected in AState) then
    aCanvas.brush.color := activeColor;

  aCanvas.Font.Name := self.Font.Name;
  aCanvas.Font.Size := 13;

  if (not mnu.Enabled) then
    aCanvas.font.color := KINESIS_LIGHTER_GRAY_ADV360;

  aCanvas.fillrect( aRect );
  acanvas.textrect( aRect, arect.left+4, arect.top+2, mnu.caption );
end;

end.

