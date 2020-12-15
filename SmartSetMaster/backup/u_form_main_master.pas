unit u_form_main_master;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  HSSpeedButton, LineObj, ColorSpeedButton, u_const, LResources, FileUtil,
  u_kinesis_device, u_form_main_rgb, LCLIntf, u_form_loading, u_form_about_master,
  eject_usb, u_form_settings_master
  {$ifdef Win32},Windows{$endif};

type

  { TFormMainMaster }

  TFormMainMaster = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    procedure EnablePaintImages(value: boolean);
    procedure RepaintForm(fullRepaint: boolean);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
  public
    cusWindowState: TCusWinState;
  end;

var
  FormMainMaster: TFormMainMaster;

const
  MAX_DEVICES = 4;
  MM_MAX_NUMAXES = 16;
  NORMAL_HEIGHT = 850;
  NORMAL_WIDTH = 1550;
  MAX_HEIGHT = 1000;
  MAX_WIDTH = 1875;
  CONN_TEXT = 'Connected';
  NOT_DETECT_TEXT = 'Not Detected';
  CONN_COLOR = clLime;
  NOT_DETECT_COLOR = clRed;

implementation

{$R *.lfm}

{ TFormMainMaster }

procedure TFormMainMaster.FormCreate(Sender: TObject);
var
  vFnt : THandle;
begin
  SetFormBorder(bsNone);
  self.Width := NORMAL_WIDTH;
  self.Height := NORMAL_HEIGHT;
  cusWindowState := cwNormal;

  //Load front from ressource
  vFnt := LoadFontFromRes('Quantify');
  //SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  //Application.ProcessMessages;

  //Fonts
  SetFont(self, 'Tahoma');
end;

procedure TFormMainMaster.SetFormBorder(formBorder: TFormBorderStyle);
begin
  BorderStyle := formBorder;
  RepaintForm(true);
end;

procedure TFormMainMaster.RepaintForm(fullRepaint: boolean);
var
   region: TRect;
begin
  //Do a form repaint
  try
    EnablePaintImages(false);

    if (fullRepaint) then
      Repaint  //Invalidate;
    else
    begin
      region := TRect.Create(self.Left, self.Top, self.Left + self.Width, self.Top + self.Height);
      InvalidateRect(Handle, @region, false);
    end;
  finally
    EnablePaintImages(true);
  end;
end;

procedure TFormMainMaster.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win32}
  //SendMessage(imgMain.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}

  {$endif}
end;

end.

