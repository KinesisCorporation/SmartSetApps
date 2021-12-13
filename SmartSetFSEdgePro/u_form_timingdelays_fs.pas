unit u_form_timingdelays_fs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LineObj, ColorSpeedButtonCS, u_const, UserDialog,
  lcltype;

type

  { TFormTimingDelaysFS }

  TFormTimingDelaysFS = class(TForm)
    btnCancel: TColorSpeedButtonCS;
    btnOk: TColorSpeedButtonCS;
    eCustomDelay: TEdit;
    lblCustomDelay: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure eCustomDelayChange(Sender: TObject);
    procedure eCustomDelayKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    timingDelay: integer;
  public

  end;

var
  FormTimingDelaysFS: TFormTimingDelaysFS;
  function ShowTimingDelaysFS(backColor: TColor; fontColor: TColor): integer;

implementation

function ShowTimingDelaysFS(backColor: TColor; fontColor: TColor): integer;
begin
  //Close the dialog if opened
  if FormTimingDelaysFS <> nil then
    FreeAndNil(FormTimingDelaysFS);

  //Creates the dialog form
  Application.CreateForm(TFormTimingDelaysFS, FormTimingDelaysFS);

  FormTimingDelaysFS.Color := backColor;
  FormTimingDelaysFS.Font.Color := fontColor;
  FormTimingDelaysFS.lblCustomDelay.Color := backColor;
  FormTimingDelaysFS.lblCustomDelay.Font.Color := fontColor;

  //Shows dialog and returns value
  if FormTimingDelaysFS.ShowModal = mrOK then
  begin
    if (FormTimingDelaysFS.timingDelay <= MAX_TIMING_DELAY) and (FormTimingDelaysFS.timingDelay >= MIN_TIMING_DELAY) then
      result := FormTimingDelaysFS.timingDelay
    else
      result := -1;
  end
  else
    result := -1;
end;

{$R *.lfm}

{ TFormTimingDelaysFS }

procedure TFormTimingDelaysFS.FormCreate(Sender: TObject);
begin
  inherited;
end;

procedure TFormTimingDelaysFS.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormTimingDelaysFS.btnOkClick(Sender: TObject);
begin
  if ((timingDelay >= MIN_TIMING_DELAY) and (timingDelay <= MAX_TIMING_DELAY)) then
    ModalResult := mrOK
  else
    ShowDialog('Timing Delays', 'Please select a timing delay between 1ms and 999ms. To achieve a longer delay, insert multiple delays back-to-back.', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_FS);
end;

procedure TFormTimingDelaysFS.eCustomDelayChange(Sender: TObject);
begin
  timingDelay := ConvertToInt(FormTimingDelaysFS.eCustomDelay.Text);
end;

procedure TFormTimingDelaysFS.eCustomDelayKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    timingDelay := ConvertToInt(FormTimingDelaysFS.eCustomDelay.Text, 0);
    if (Key = VK_UP) then
    begin
      if (timingDelay < MAX_TIMING_DELAY) then
        inc(timingDelay)
      else
        timingDelay := MAX_TIMING_DELAY;
      FormTimingDelaysFS.eCustomDelay.Text := IntToStr(timingDelay);
    end
    else if (Key = VK_DOWN) then
    begin
      if (timingDelay > MIN_TIMING_DELAY) then
        dec(timingDelay)
      else
        timingDelay := MIN_TIMING_DELAY;
      FormTimingDelaysFS.eCustomDelay.Text := IntToStr(timingDelay);
    end;
  end;
end;

end.

