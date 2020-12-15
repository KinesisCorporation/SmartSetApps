unit u_form_master;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  HSSpeedButton, LineObj, ColorSpeedButton, u_const, LResources, FileUtil,
  u_kinesis_device, u_form_main_rgb, LCLIntf, u_form_loading, u_form_about_master,
  eject_usb, u_form_settings_master, u_form_dashboard
  {$ifdef Win32},Windows{$endif};

type

  { TFormMaster }

  TFormMaster = class(TForm)
    btnClose: THSSpeedButton;
    btnMaximize: THSSpeedButton;
    btnMinimize: THSSpeedButton;
    Button1: TButton;
    imgListMenu: TImageList;
    imgLogo: TImage;
    imgMain: TImage;
    imgSmartSetLogo: TImage;
    Label1: TLabel;
    lblHelp: TLabel;
    lblSettings: TLabel;
    lineBorderLeftTop: TLineObj;
    lineBorderRightTop: TLineObj;
    pnlMain: TPanel;
    pnlTop: TPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TopMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseEnter(Sender: TObject);
    procedure ButtonMouseLeave(Sender: TObject);
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    cusWindowState: TCusWinState;
    gamingMode: boolean;
    fontColor: TColor;
    backColor: TColor;
    blueColor: TColor;
    procedure EnablePaintImages(value: boolean);
    procedure Init;
    procedure OpenDashboard;
    procedure RepaintForm(fullRepaint: boolean);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
    procedure UpdateStateSettings;

  public

  end;

var
  FormMaster: TFormMaster;

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

{ TFormMaster }

procedure TFormMaster.FormCreate(Sender: TObject);
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

  //App shows in Taskbar only when minimized
  Application.MainFormOnTaskBar:= true;

  //Fonts
  SetFont(self, 'Tahoma');

  gamingMode := true;
  Init;
end;

procedure TFormMaster.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormMaster.btnMaximizeClick(Sender: TObject);
var
  aRect: TRect;
begin
  aRect := Screen.PrimaryMonitor.WorkareaRect;

  if (cusWindowState = cwMaximized) then
  begin
    self.Height := NORMAL_HEIGHT;
    self.Width := NORMAL_WIDTH;
    self.Left := (aRect.Width - NORMAL_WIDTH) div 2;
    self.Top := (aRect.Height - NORMAL_HEIGHT) div 2;
    cusWindowState := cwNormal;
  end
  else
  begin
    self.Left := aRect.Left;
    self.Top := aRect.Top;
    self.Width := aRect.Width;
    self.Height := aRect.Height;
    cusWindowState := cwMaximized;
  end;

  UpdateStateSettings;
end;

procedure TFormMaster.btnMinimizeClick(Sender: TObject);
begin
   Application.Minimize;
end;

procedure TFormMaster.Button1Click(Sender: TObject);
begin

    OpenDashboard;
end;

procedure TFormMaster.Init;
begin
  //Set colors also check if DarkTheme is enabled on OS
  blueColor := KINESIS_BLUE;
  if (gamingMode or IsDarkTheme) then
  begin
    fontColor := clWhite;
    backColor := KINESIS_DARK_GRAY_FS;
  end
  else
  begin
    fontColor := clBlack;
    backColor := clWhite;

    pnlTop.Color := backColor;
    btnMinimize.Color := backColor;
    btnMinimize.HotTrackColor := backColor;
    btnMinimize.LightColor := backColor;
    btnMinimize.ShadowColor := backColor;
    btnMinimize.TransparentColor := backColor;
    btnMaximize.Color := backColor;
    btnMaximize.HotTrackColor := backColor;
    btnMaximize.LightColor := backColor;
    btnMaximize.ShadowColor := backColor;
    btnMaximize.TransparentColor := backColor;
    btnClose.Color := backColor;
    btnClose.HotTrackColor := backColor;
    btnClose.LightColor := backColor;
    btnClose.ShadowColor := backColor;
    btnClose.TransparentColor := backColor;

    imgListMenu.GetBitmap(0, btnMinimize.Glyph);
    imgListMenu.GetBitmap(4, btnClose.Glyph);
    imgListMenu.GetBitmap(1, btnMaximize.Glyph);
  end;

end;

procedure TFormMaster.OpenDashboard;
begin
  Application.CreateForm(TFormDashboard, FormDashBoard);
  FormDashBoard.FormStyle := TFormStyle.fsMDIChild;
  FormDashBoard.Parent := pnlMain;
  FormDashBoard.Show;
end;

procedure TFormMaster.SetFormBorder(formBorder: TFormBorderStyle);
begin
  self.BorderStyle := formBorder;
  RepaintForm(true);
end;

procedure TFormMaster.RepaintForm(fullRepaint: boolean);
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

procedure TFormMaster.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win32}
  SendMessage(imgMain.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}

  {$endif}
end;

procedure TFormMaster.TopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MPos.X := X;
  MPos.Y := Y;
end;

procedure TFormMaster.TopMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    self.Left := self.Left - (MPos.X-X);
    self.Top := self.Top - (MPos.Y-Y);
  end;
end;

procedure TFormMaster.ButtonMouseEnter(Sender: TObject);
begin
  (Sender as TColorSpeedButton).Font.Color := blueColor;
end;

procedure TFormMaster.ButtonMouseLeave(Sender: TObject);
begin
   (Sender as TColorSpeedButton).Font.Color := fontColor;
end;

procedure TFormMaster.ButtonMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  (Sender as TColorSpeedButton).Font.Color := blueColor;
end;

procedure TFormMaster.UpdateStateSettings;
begin
  self.DisableAlign;

  {$ifdef Win32}
  //Disable paint on form
  SendMessage(self.Handle, WM_SETREDRAW, Integer(False), 0);
  {$endif}

  if (cusWindowState = cwMaximized) then
  begin
    if (IsDarkTheme or gamingMode) then
      imgListMenu.GetBitmap(7, btnMaximize.Glyph)
    else
      imgListMenu.GetBitmap(2, btnMaximize.Glyph);
    btnMaximize.Hint := 'Restore window';
  end
  else
  begin
    if (IsDarkTheme or gamingMode) then
      imgListMenu.GetBitmap(6, btnMaximize.Glyph)
    else
      imgListMenu.GetBitmap(1, btnMaximize.Glyph);
    btnMaximize.Hint := 'Maximize';
  end;

  {$ifdef Win32}
  //Enable paint on form on repaint
  SendMessage(self.Handle, WM_SETREDRAW, Integer(True), 0);
  {$endif}

  self.EnableAlign;
  self.Repaint;
end;

end.

