unit u_form_timingdelays;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LineObj, u_base_form, u_const, UserDialog, lcltype,
  u_common_ui, ColorSpeedButtonCS;

type

  { TFormTimingDelays }

  TFormTimingDelays = class(TBaseForm)
    btnCancel: TColorSpeedButtonCS;
    btnAccept: TColorSpeedButtonCS;
    eCustomDelay: TEdit;
    imgListTiming: TImageList;
    lblRandom: TLabel;
    lblCustom: TLabel;
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
    procedure lblRandomClick(Sender: TObject);
  private
    timingDelay: integer;
  public

  end;

var
  FormTimingDelays: TFormTimingDelays;
  function ShowTimingDelays(backColor: TColor; fontColor: TColor): integer;

implementation

{$R *.lfm}

function ShowTimingDelays(backColor: TColor; fontColor: TColor): integer;
begin
  //Close the dialog if opened
  if FormTimingDelays <> nil then
    FreeAndNil(FormTimingDelays);

  //Creates the dialog form
  Application.CreateForm(TFormTimingDelays, FormTimingDelays);

  //Loads colors
  FormTimingDelays.Color := backColor;
  FormTimingDelays.Font.Color := fontColor;
  FormTimingDelays.lblRandom.Font.Color := fontColor;
  FormTimingDelays.lblCustom.Font.Color := fontColor;
  FormTimingDelays.lblTitle.Font.Color := fontColor;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormTimingDelays.btnCancel, FormTimingDelays.imgListTiming, 4);
    LoadButtonImage(FormTimingDelays.btnAccept, FormTimingDelays.imgListTiming, 6);
  end;

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

procedure TFormTimingDelays.lblRandomClick(Sender: TObject);
begin
  rbRandom.Checked:=true;
end;

procedure TFormTimingDelays.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 4)
  else
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormTimingDelays.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 6)
    else
      LoadButtonImage(sender, imgListTiming, 2);
  end;
end;

procedure TFormTimingDelays.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 7)
  else
    LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormTimingDelays.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 4)
    else
      LoadButtonImage(sender, imgListTiming, 0);
  end;
end;

procedure TFormTimingDelays.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 5)
  else
    LoadButtonImage(sender, imgListTiming, 1);
end;

procedure TFormTimingDelays.btnAcceptClick(Sender: TObject);
begin
  if (rbRandom.Checked) or ((timingDelay >= MIN_TIMING_DELAY) and (timingDelay <= MAX_TIMING_DELAY)) then
    ModalResult := mrOK
  else
    ShowDialog('Timing Delays', 'Please select a timing delay between 1ms and 999ms. To achieve a longer delay, insert multiple delays back-to-back.', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
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

