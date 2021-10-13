unit u_form_tapandhold_office;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LineObj, ColorSpeedButtonCS, u_const, UserDialog,
  lcltype, u_keys;

type

  { TFormTapAndHoldOffice }

  TFormTapAndHoldOffice = class(TForm)
    btnDone: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    eHoldAction: TEdit;
    eTapAction: TEdit;
    eTimingDelay: TEdit;
    lblTapAction: TLabel;
    lblHoldAction: TLabel;
    lblDelay: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
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
  FormTapAndHoldOffice: TFormTapAndHoldOffice;
  function ShowTapAndHoldOffice(aTapAction: TKey; aHoldAction: TKey; iTimingDelay: integer; backColor: TColor; fontColor: TColor): boolean;

implementation

uses u_form_main;

{$R *.lfm}

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
end;

function ShowTapAndHoldOffice(aTapAction: TKey; aHoldAction: TKey; iTimingDelay: integer; backColor: TColor; fontColor: TColor): boolean;
const
  DefaultDelay = 250;
begin
  result := false;
  //Close the dialog if opened
  if FormTapAndHoldOffice <> nil then
    FreeAndNil(FormTapAndHoldOffice);

  //Creates the dialog form
  Application.CreateForm(TFormTapAndHoldOffice, FormTapAndHoldOffice);

  FormTapAndHoldOffice.Color := backColor;
  FormTapAndHoldOffice.Font.Color := fontColor;
  FormTapAndHoldOffice.lblTapAction.Color := backColor;
  FormTapAndHoldOffice.lblTapAction.Font.Color := fontColor;
  FormTapAndHoldOffice.lblHoldAction.Color := backColor;
  FormTapAndHoldOffice.lblHoldAction.Font.Color := fontColor;
  FormTapAndHoldOffice.lblDelay.Color := backColor;
  FormTapAndHoldOffice.lblDelay.Font.Color := fontColor;

  //FormTapAndHoldOffice.timingDelay := iTimingDelay;
  if (iTimingDelay <= 0) then
    iTimingDelay := DefaultDelay;

  FormTapAndHoldOffice.eTimingDelay.Text := IntToStr(iTimingDelay);
  if (aTapAction <> nil) then
    FormTapAndHoldOffice.SetKeyPress(aTapAction.Key, FormTapAndHoldOffice.eTapAction)
  else
    FormTapAndHoldOffice.tapAction := 0;
  if (aHoldAction <> nil) then
    FormTapAndHoldOffice.SetKeyPress(aHoldAction.Key, FormTapAndHoldOffice.eHoldAction)
   else
    FormTapAndHoldOffice.holdAction := 0;

  //Shows dialog and returns value
  if FormTapAndHoldOffice.ShowModal = mrOK then
  begin
    result := true;
  end;
end;

{ TFormTapAndHoldOffice }

procedure TFormTapAndHoldOffice.FormCreate(Sender: TObject);
begin
  inherited;
end;

procedure TFormTapAndHoldOffice.FormShow(Sender: TObject);
begin
  eTapAction.SetFocus;
end;

procedure TFormTapAndHoldOffice.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TFormTapAndHoldOffice.Validate: boolean;
begin
  result := false;
  if (timingDelay < MIN_TIMING_DELAY) or (timingDelay > MAX_TIMING_DELAY) then
    ShowDialog('Tap and Hold Action', 'Please select a timing delay between 1ms and 999ms.', mtError, [mbOK],
      DEFAULT_DIAG_HEIGHT_ADV2, self.Color, self.Font.Color)
  else if (tapAction <= 0) then
    ShowDialog('Tap and Hold Action', 'Plese select a Tap Action', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_ADV2, self.Color, self.Font.Color)
  else if (holdAction <= 0) then
    ShowDialog('Tap and Hold Action', 'Plese select a Hold Action', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_ADV2, self.Color, self.Font.Color)
  else
    result := true;
end;

procedure TFormTapAndHoldOffice.btnDoneClick(Sender: TObject);
begin
  if (Validate) then
    ModalResult := mrOK;
end;

procedure TFormTapAndHoldOffice.eHoldActionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$ifdef Darwin}
  SetKeyPress(key, eHoldAction);
  {$endif}
  key := 0;
end;

procedure TFormTapAndHoldOffice.eTapActionKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$ifdef Darwin}
  SetKeyPress(key, eTapAction);
  {$endif}
  key := 0;
end;

procedure TFormTapAndHoldOffice.eTimingDelayChange(Sender: TObject);
begin
  timingDelay := ConvertToInt(FormTapAndHoldOffice.eTimingDelay.Text);
end;

procedure TFormTapAndHoldOffice.eTimingDelayKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    timingDelay := ConvertToInt(FormTapAndHoldOffice.eTimingDelay.Text, 0);
    if (Key = VK_UP) then
    begin
      if (timingDelay < MAX_TIMING_DELAY) then
        inc(timingDelay)
      else
        timingDelay := MAX_TIMING_DELAY;
      FormTapAndHoldOffice.eTimingDelay.Text := IntToStr(timingDelay);
    end
    else if (Key = VK_DOWN) then
    begin
      if (timingDelay > MIN_TIMING_DELAY) then
        dec(timingDelay)
      else
        timingDelay := MIN_TIMING_DELAY;
      FormTapAndHoldOffice.eTimingDelay.Text := IntToStr(timingDelay);
    end;
  end
  else if ((key < VK_0) or (key > VK_9)) and (key <> VK_BACK) then
   key := 0;
end;

procedure TFormTapAndHoldOffice.SetKeyPress(key: word; edit: TEdit);
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

