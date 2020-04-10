unit u_form_tapandhold;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, u_base_form, u_const, UserDialog, lcltype,
  u_keys;

type

  { TFormTapAndHold }

  TFormTapAndHold = class(TBaseForm)
    btnCancel: THSSpeedButton;
    btnAccept: THSSpeedButton;
    eHoldAction: TEdit;
    eTimingDelay: TEdit;
    eTapAction: TEdit;
    imgListTiming: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnAcceptMouseExit(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseExit(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAcceptClick(Sender: TObject);
    procedure eHoldActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eTapActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eTimingDelayChange(Sender: TObject);
    procedure eTimingDelayKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function Validate: boolean;
  public
    tapAction: word;
    holdAction: word;
    timingDelay: integer;
    procedure SetKeyPress(key: word; edit: TEdit = nil);
  end;

var
  FormTapAndHold: TFormTapAndHold;
  function ShowTapAndHold(aTapAction: TKey; aHoldAction: TKey; iTimingDelay: integer): boolean;

implementation

uses u_form_main;

{$R *.lfm}

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
end;

function ShowTapAndHold(aTapAction: TKey; aHoldAction: TKey; iTimingDelay: integer): boolean;
const
  DefaultDelay = 250;
begin
  result := false;
  //Close the dialog if opened
  if FormTapAndHold <> nil then
    FreeAndNil(FormTapAndHold);

  //Creates the dialog form
  Application.CreateForm(TFormTapAndHold, FormTapAndHold);

  //FormTapAndHold.timingDelay := iTimingDelay;
  if (iTimingDelay <= 0) then
    iTimingDelay := DefaultDelay;

  FormTapAndHold.eTimingDelay.Text := IntToStr(iTimingDelay);
  if (aTapAction <> nil) then
    FormTapAndHold.SetKeyPress(aTapAction.Key, FormTapAndHold.eTapAction)
  else
    FormTapAndHold.tapAction := 0;
  if (aHoldAction <> nil) then
    FormTapAndHold.SetKeyPress(aHoldAction.Key, FormTapAndHold.eHoldAction)
   else
    FormTapAndHold.holdAction := 0;

  //Shows dialog and returns value
  if FormTapAndHold.ShowModal = mrOK then
  begin
    result := true;
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
  eTapAction.SetFocus;
  eTapAction.SelStart := 0;
  eTapAction.SelText := eTapAction.Text;
  eTapAction.SelLength := 0;
end;

procedure TFormTapAndHold.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  MainForm.LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormTapAndHold.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as THSSpeedButton).Down) then
    MainForm.LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormTapAndHold.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  MainForm.LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormTapAndHold.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as THSSpeedButton).Down) then
    MainForm.LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormTapAndHold.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  MainForm.LoadButtonImage(sender, imgListTiming, 1);
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
    ModalResult := mrOK;
  MainForm.LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormTapAndHold.eHoldActionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$ifdef Darwin}
  SetKeyPress(key, eHoldAction);
  {$endif}
  key := 0;
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
    aKey := MainForm.keyService.GetKeyConfig(key);
    if (aKey <> nil) then
    begin
      if (edit = eTapAction) or (eTapAction.Focused) then
      begin
        eTapAction.Text := aKey.OtherDisplayText;
        tapAction := key;
      end
      else if (edit = eHoldAction) or (eHoldAction.Focused) then
      begin
        eHoldAction.Text := aKey.OtherDisplayText;
        holdAction := key;
      end;
    end;
    FreeAndNil(aKey);
  end;
end;

end.

