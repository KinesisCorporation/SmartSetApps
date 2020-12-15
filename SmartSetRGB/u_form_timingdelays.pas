unit u_form_timingdelays;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, u_base_form, u_const, UserDialog, lcltype,
  u_common_ui;

type

  { TFormTimingDelays }

  TFormTimingDelays = class(TBaseForm)
    btnCancel: THSSpeedButton;
    btnAccept: THSSpeedButton;
    eCustomDelay: TEdit;
    imgListTiming: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    rbRandom: TRadioButton;
    procedure btnAcceptMouseExit(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseExit(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAcceptClick(Sender: TObject);
    procedure eCustomDelayChange(Sender: TObject);
    procedure eCustomDelayKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    timingDelay: integer;
  public

  end;

var
  FormTimingDelays: TFormTimingDelays;
  function ShowTimingDelays: integer;

implementation

uses u_form_main_rgb;

{$R *.lfm}

function ShowTimingDelays: integer;
begin
  //Close the dialog if opened
  if FormTimingDelays <> nil then
    FreeAndNil(FormTimingDelays);

  //Creates the dialog form
  Application.CreateForm(TFormTimingDelays, FormTimingDelays);

  //Shows dialog and returns value
  if FormTimingDelays.ShowModal = mrOK then
  begin
    if (FormTimingDelays.rbRandom.Checked) then
      result := 0
    else if (FormTimingDelays.timingDelay <= MAX_TIMING_DELAY) and (FormTimingDelays.timingDelay >= MIN_TIMING_DELAY) then
      result := FormTimingDelays.timingDelay
    else
      result := -1;
  end
  else
    result := -1;
end;

{ TFormTimingDelays }

procedure TFormTimingDelays.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Macro Timing Delays';
end;

procedure TFormTimingDelays.Label1Click(Sender: TObject);
begin
  rbRandom.Checked:=true;
end;

procedure TFormTimingDelays.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormTimingDelays.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as THSSpeedButton).Down) then
    LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormTimingDelays.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormTimingDelays.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as THSSpeedButton).Down) then
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormTimingDelays.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  LoadButtonImage(sender, imgListTiming, 1);
end;

procedure TFormTimingDelays.btnAcceptClick(Sender: TObject);
begin
  if (rbRandom.Checked) or ((timingDelay >= MIN_TIMING_DELAY) and (timingDelay <= MAX_TIMING_DELAY)) then
    ModalResult := mrOK
  else
    ShowDialog('Timing Delays', 'Please select a timing delay between 1ms and 999ms. To achieve a longer delay, insert multiple delays back-to-back.', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  LoadButtonImage(sender, imgListTiming, 2);
  NeedInput := true;
end;

procedure TFormTimingDelays.eCustomDelayChange(Sender: TObject);
begin
  timingDelay := ConvertToInt(FormTimingDelays.eCustomDelay.Text);
  rbRandom.Checked := false;
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

