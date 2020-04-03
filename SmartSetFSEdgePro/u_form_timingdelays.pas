unit u_form_timingdelays;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, u_const, UserDialog, lcltype;

type

  { TFormTimingDelays }

  TFormTimingDelays = class(TForm)
    btnCancel: THSSpeedButton;
    btnDone: THSSpeedButton;
    eCustomDelay: TEdit;
    lblCustomDelay: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDoneClick(Sender: TObject);
    procedure eCustomDelayChange(Sender: TObject);
    procedure eCustomDelayKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    timingDelay: integer;
  public

  end;

var
  FormTimingDelays: TFormTimingDelays;
  function ShowTimingDelays(backColor: TColor; fontColor: TColor): integer;

implementation

function ShowTimingDelays(backColor: TColor; fontColor: TColor): integer;
begin
  //Close the dialog if opened
  if FormTimingDelays <> nil then
    FreeAndNil(FormTimingDelays);

  //Creates the dialog form
  Application.CreateForm(TFormTimingDelays, FormTimingDelays);

  FormTimingDelays.Color := backColor;
  FormTimingDelays.Font.Color := fontColor;
  FormTimingDelays.lblCustomDelay.Color := backColor;
  FormTimingDelays.lblCustomDelay.Font.Color := fontColor;

  //Shows dialog and returns value
  if FormTimingDelays.ShowModal = mrOK then
  begin
    if (FormTimingDelays.timingDelay <= MAX_TIMING_DELAY) and (FormTimingDelays.timingDelay >= MIN_TIMING_DELAY) then
      result := FormTimingDelays.timingDelay
    else
      result := -1;
  end
  else
    result := -1;
end;

{$R *.lfm}

{ TFormTimingDelays }

procedure TFormTimingDelays.FormCreate(Sender: TObject);
begin
  inherited;
end;

procedure TFormTimingDelays.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormTimingDelays.btnDoneClick(Sender: TObject);
begin
  if ((timingDelay >= MIN_TIMING_DELAY) and (timingDelay <= MAX_TIMING_DELAY)) then
    ModalResult := mrOK
  else
    ShowDialog('Timing Delays', 'Please select a timing delay between 1ms and 999ms. To achieve a longer delay, insert multiple delays back-to-back.', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_FS,
      self.Color, self.Font.Color);
end;

procedure TFormTimingDelays.eCustomDelayChange(Sender: TObject);
begin
  timingDelay := ConvertToInt(FormTimingDelays.eCustomDelay.Text);
end;

procedure TFormTimingDelays.eCustomDelayKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    timingDelay := ConvertToInt(FormTimingDelays.eCustomDelay.Text, 0);
    if (Key = VK_UP) then
    begin
      if (timingDelay < MAX_TIMING_DELAY) then
        inc(timingDelay)
      else
        timingDelay := MAX_TIMING_DELAY;
      FormTimingDelays.eCustomDelay.Text := IntToStr(timingDelay);
    end
    else if (Key = VK_DOWN) then
    begin
      if (timingDelay > MIN_TIMING_DELAY) then
        dec(timingDelay)
      else
        timingDelay := MIN_TIMING_DELAY;
      FormTimingDelays.eCustomDelay.Text := IntToStr(timingDelay);
    end;
  end;
end;

end.

