unit u_form_dashboard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ColorSpeedButtonCS, UserDialog,
  u_form_main_adv2, u_form_main_fs, u_form_keypress,
  u_form_main_adv360,
  u_const, LResources, FileUtil,
  u_kinesis_device, LCLIntf, Buttons, u_form_loading, u_form_about_master,
  u_form_settings_master, u_form_firmware, u_common_ui, u_form_scanvdrive
  {$ifdef Win64},Windows{$endif};

type

  { TFormDashboard }

  TFormDashboard = class(TForm)
    btnGetHelpAdv360Pro: TColorSpeedButtonCS;
    btnCheckUpdatesConnected2: TColorSpeedButtonCS;
    btnCheckUpdatesConnected3: TColorSpeedButtonCS;
    btnCheckUpdatesConnected4: TColorSpeedButtonCS;
    btnCheckUpdatesConnected5: TColorSpeedButtonCS;
    btnCheckUpdatesConnected6: TColorSpeedButtonCS;
    btnOpenApp1: TColorSpeedButtonCS;
    btnOpenApp2: TColorSpeedButtonCS;
    btnOpenApp3: TColorSpeedButtonCS;
    btnOpenApp4: TColorSpeedButtonCS;
    btnOpenApp5: TColorSpeedButtonCS;
    btnOpenApp6: TColorSpeedButtonCS;
    btnAccessWebsite: TColorSpeedButtonCS;
    btnWatchTutorial2: TColorSpeedButtonCS;
    btnWatchTutorial3: TColorSpeedButtonCS;
    btnWatchTutorial4: TColorSpeedButtonCS;
    btnWatchTutorial5: TColorSpeedButtonCS;
    btnWatchTutorial6: TColorSpeedButtonCS;
    imgApp5: TImage;
    imgApp6: TImage;
    imgEject1: TImage;
    imgClose: TImage;
    imgEject2: TImage;
    imgEject3: TImage;
    imgEject4: TImage;
    imgEject5: TImage;
    imgEject6: TImage;
    imgListButtons: TImageList;
    imgMaximize: TImage;
    imgMinimize: TImage;
    imgBackgroundTop: TImage;
    imgAppLogoAdv360: TImage;
    imgAppLogoFsPro: TImage;
    lblAppName2: TLabel;
    lblAppName3: TLabel;
    lblAppName4: TLabel;
    lblAppName5: TLabel;
    lblAppName6: TLabel;
    lblConnApp2: TLabel;
    lblConnApp3: TLabel;
    lblConnApp4: TLabel;
    lblConnApp5: TLabel;
    lblConnApp6: TLabel;
    lblDemoMode: TLabel;
    lblHelp: TLabel;
    btnWatchTutorial1: TColorSpeedButtonCS;
    btnClose: TColorSpeedButtonCS;
    btnMaximize: TColorSpeedButtonCS;
    btnMinimize: TColorSpeedButtonCS;
    btnCheckUpdatesConnected1: TColorSpeedButtonCS;
    imgApp1: TImage;
    imgApp2: TImage;
    imgApp3: TImage;
    imgApp4: TImage;
    imgMain: TImage;
    imgListMenu: TImageList;
    imgLogo: TImage;
    imgSmartSetLogo: TImage;
    lblHome: TLabel;
    lblProfileApp2: TLabel;
    lblProfileApp3: TLabel;
    lblProfileApp4: TLabel;
    lblProfileApp5: TLabel;
    lblProfileApp6: TLabel;
    lblSettings: TLabel;
    Label3: TLabel;
    lblAppName1: TLabel;
    lblConnApp1: TLabel;
    lblProfileApp1: TLabel;
    lblVDriveError: TLabel;
    lblVDriveOk: TLabel;
    pnlApp1: TPanel;
    pnlApp2: TPanel;
    pnlApp3: TPanel;
    pnlApp4: TPanel;
    pnlApp5: TPanel;
    pnlApp6: TPanel;
    pnlMain: TPanel;
    pnlTop: TPanel;
    tmrCheckConnected: TTimer;
    tmrLoadForms: TTimer;
    procedure btnAccessWebsiteClick(Sender: TObject);
    procedure btnCheckUpdatesConnectedClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEjectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEjectMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnEjectMouseEnter(Sender: TObject);
    procedure btnEjectMouseLeave(Sender: TObject);
    procedure btnEjectClick(Sender: TObject);
    procedure btnGetHelpAdv360ProClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure btnOpenAppClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure ButtonMouseEnter(Sender: TObject);
    procedure ButtonMouseLeave(Sender: TObject);
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
    procedure imgMaximizeClick(Sender: TObject);
    procedure imgMinimizeClick(Sender: TObject);
    procedure lblHomeClick(Sender: TObject);
    procedure lblHelpClick(Sender: TObject);
    procedure lblSettingsClick(Sender: TObject);
    procedure tmrCheckConnectedTimer(Sender: TObject);
    procedure tmrLoadFormsTimer(Sender: TObject);
    procedure TopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TopMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
  private
    fontColor: TColor;
    backColor: TColor;
    activeColor: TColor;
    cusWindowState: TCusWinState;
    deviceList: TDeviceList;
    closing: boolean;
    returningToHome: boolean;
    procedure AddDevices;
    procedure EnablePaintImages(value: boolean);
    procedure GetAppObjects(idx: integer; var appNameLabel: TLabel;
      var appConnLabel: TLabel; var appProfileLabel: TLabel;  var appCheckUpdBtn: TColorSpeedButtonCS;
      var appEjectBtn: TImage; var appWatchTutoBtn: TColorSpeedButtonCS; var appOpenBtn: TColorSpeedButtonCS);
    procedure Init;
    procedure LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);
    procedure Maximize;
    procedure RepaintForm(fullRepaint: boolean);
    procedure RepositionAll;
    procedure RepositionItems(pnlApp: TPanel; btnCheckUpdates: TColorSpeedButtonCS;
      imgEject: TImage; btnWatchTutorial: TColorSpeedButtonCS);
    procedure SetFormBorder(formBorder: TFormBorderStyle);
    procedure SetSelectedMenu(menuLabel: TLabel);
    procedure UpdateDevices;
    procedure UpdateDevice(aDevice: TDevice);
    procedure UpdateStateSettings;
    procedure OpenDeviceForm(device: TDevice);
    procedure LoadAppForms;
    procedure CloseActiveForms;
  public
    procedure ResetToHome;
  end;

var
  FormDashboard: TFormDashboard;
  MPos:TPoint; {Position of the Form before drag}
  procedure SetVDriveState(state: boolean);

const
  MAX_DEVICES = 2;
  MM_MAX_NUMAXES = 16;
  NORMAL_HEIGHT = 830;
  NORMAL_WIDTH = 1550;
  MAX_HEIGHT = 1000;
  MAX_WIDTH = 1875;
  CONN_TEXT = 'Connected';
  NOT_DETECT_TEXT = 'Not Detected';
  NO_ACCESS_TEXT = 'Cannot Access';
  CONN_COLOR = clLime;
  NOT_DETECT_COLOR = clRed;


implementation

{$R *.lfm}

procedure SetVDriveState(state: boolean);
begin
  if not(GDemoMode) then
  begin
    FormDashboard.lblVDriveOk.Visible := state;
    FormDashboard.lblVDriveError.Visible := not state;
  end;
end;

{ TFormDashboard }

procedure TFormDashboard.FormCreate(Sender: TObject);
//var
//  vFnt : THandle;
begin
  closing := false;
  returningToHome := false;

  SetFormBorder(bsNone);
  self.Width := NORMAL_WIDTH;
  self.Height := NORMAL_HEIGHT;
  cusWindowState := cwNormal;
  deviceList := TDeviceList.Create;

  //Fonts
  SetFont(self, 'Tahoma');
  SetSelectedMenu(lblHome);

  //Load app settings
  GShowAllNotifs := ReadFromRegistry(ShowAllNotifsOffice) = '1';
  GHideAllNotifs := ReadFromRegistry(HideAllNotifsOffice) = '1';

  //App shows in Taskbar only when minimized
  Application.MainFormOnTaskBar:= true;

  AddDevices;

  Init;
end;

procedure TFormDashboard.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if (CloseAction = caFree) then
  begin
    closing := true;
    ResetToHome;
    FreeAndNil(deviceList);
  end;
end;

procedure TFormDashboard.FormDestroy(Sender: TObject);
begin
  FreeAndNil(deviceList);
end;

procedure TFormDashboard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (not returningToHome) then
  begin
    if (FormMainAdv360 <> nil) and (FormMainAdv360.Visible) then
    begin
      FormMainAdv360.FormKeyDown(sender, key, shift);
    end
    else if (FormMainFS <> nil) and (FormMainFS.Visible) then
    begin
      FormMainFS.FormKeyDown(sender, key, shift);
    end
    else if (FormMainAdv2 <> nil) and (FormMainAdv2.Visible) then
    begin
      FormMainAdv2.FormKeyDown(sender, key, shift);
    end
    else if (FormMainSE2 <> nil) and (FormMainSE2.Visible) then
    begin
      FormMainSE2.FormKeyDown(sender, key, shift);
    end;
  end;
end;

procedure TFormDashboard.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TFormDashboard.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (not returningToHome) then
  begin
    if (FormMainAdv360 <> nil) and (FormMainAdv360.Visible) then
    begin
      FormMainAdv360.FormKeyUp(sender, key, shift);
    end
    else if (FormMainFS <> nil) and (FormMainFS.Visible) then
    begin
      FormMainFS.FormKeyUp(sender, key, shift);
    end
    else if (FormMainAdv2 <> nil) and (FormMainAdv2.Visible) then
    begin
      FormMainAdv2.FormKeyUp(sender, key, shift);
    end
    else if (FormMainSE2 <> nil) and (FormMainSE2.Visible) then
    begin
      FormMainSE2.FormKeyUp(sender, key, shift);
    end;
  end;
end;

procedure TFormDashboard.FormResize(Sender: TObject);
begin
  RepositionAll;
end;

procedure TFormDashboard.FormShow(Sender: TObject);
begin
  RepositionAll;
end;

procedure TFormDashboard.RepositionAll;
begin
  RepositionItems(pnlApp1, btnCheckUpdatesConnected1, imgEject1, btnWatchTutorial1);
  RepositionItems(pnlApp2, btnCheckUpdatesConnected2, imgEject2, btnWatchTutorial2);
  RepositionItems(pnlApp3, btnCheckUpdatesConnected3, imgEject3, btnWatchTutorial3);
  RepositionItems(pnlApp4, btnCheckUpdatesConnected4, imgEject4, btnWatchTutorial4);
end;

procedure TFormDashboard.RepositionItems(pnlApp: TPanel; btnCheckUpdates: TColorSpeedButtonCS; imgEject: TImage;
  btnWatchTutorial: TColorSpeedButtonCS);
begin
  btnCheckUpdates.Left := pnlApp.Left;
  btnCheckUpdates.Top := pnlApp.Top + pnlApp.Height + 10;
  btnWatchTutorial.Left := (pnlApp.Left + pnlApp.Width) - btnWatchTutorial.Width;
  btnWatchTutorial.Top := btnCheckUpdates.Top;
  imgEject.Left := (pnlApp.Left + (pnlApp.Width div 2) - (imgEject.Width div 2));
  imgEject.Top :=  btnCheckUpdates.Top;
end;

procedure TFormDashboard.Init;
begin
  //Set colors also check if DarkTheme is enabled on OS
  activeColor := KINESIS_GREEN_OFFICE;
  if (IsDarkTheme) then
  begin
    fontColor := clWhite;
    backColor := KINESIS_DARK_GRAY_RGB;
  end
  else
  begin
    fontColor := KINESIS_DARK_GRAY_RGB;
    backColor := KINESIS_LIGHT_GRAY_ADV360;

    pnlTop.Color := backColor;
    //btnMinimize.Color := backColor;
    //btnMinimize.HotTrackColor := backColor;
    //btnMinimize.LightColor := backColor;
    //btnMinimize.ShadowColor := backColor;
    //btnMinimize.TransparentColor := backColor;
    //btnMaximize.Color := backColor;
    //btnMaximize.HotTrackColor := backColor;
    //btnMaximize.LightColor := backColor;
    //btnMaximize.ShadowColor := backColor;
    //btnMaximize.TransparentColor := backColor;
    //btnClose.Color := backColor;
    //btnClose.HotTrackColor := backColor;
    //btnClose.LightColor := backColor;
    //btnClose.ShadowColor := backColor;
    //btnClose.TransparentColor := backColor;

    imgListMenu.GetBitmap(0, imgMinimize.Picture.Bitmap); // btnMinimize.Glyph);
    imgListMenu.GetBitmap(4, imgClose.Picture.Bitmap); // btnClose.Glyph);
    imgListMenu.GetBitmap(1, imgMaximize.Picture.Bitmap); //btnMaximize.Glyph);
  end;

  UpdateDevices;
  tmrCheckConnected.Enabled := true;
  tmrLoadForms.Enabled := true;
end;

//Add list of devices
procedure TFormDashboard.AddDevices;
var
  aDevice: TDevice;
begin
  aDevice := TDevice.Create;
  aDevice.DeviceName := 'ADVANTAGE 360';
  aDevice.DeviceNumber := APPL_ADV360;
  aDevice.VDriveName := ADV360_DRIVE;
  aDevice.TutorialUrl := ADV360_TUTORIAL;
  aDevice.VersionFile := VERSION_FILE_ADV360;
  aDevice.VersionFolder := VERSION_FOLDER_ADV360;
  aDevice.SettingsFile := ADV360_SETTINGS_FILE;
  aDevice.ScanVDriveHint := 'To program the keyboard, you must first connect the v-Drive to the PC using the shortcut SmartSet + v-Drive';
  deviceList.Add(aDevice);

  aDevice := TDevice.Create;
  aDevice.DeviceName := 'ADVANTAGE360 PROFESSIONAL';
  aDevice.DeviceNumber := APPL_ADV360PRO;
  aDevice.Programmable := false;
  deviceList.Add(aDevice);

  //aDevice := TDevice.Create;
  //aDevice.DeviceName := 'FREESTYLE PRO';
  //aDevice.DeviceNumber := APPL_FSPRO;
  //aDevice.VDriveName := FSPRO_DRIVE;
  //aDevice.TutorialUrl := FSPRO_TUTORIAL;
  ////tpdp aDevice.ScanVDriveHint := 'To program the keyboard, you must first connect the v-Drive to the PC using the shortcut SmartSet + Right Shift + V';
  //deviceList.Add(aDevice);
  //
  //aDevice := TDevice.Create;
  //aDevice.DeviceName := 'SAVANT ELITE2';
  //aDevice.DeviceNumber := APPL_PEDAL;
  //aDevice.VDriveName := PEDAL_DRIVE;
  //aDevice.TutorialUrl := PEDAL_TUTORIAL;
  //aDevice.VersionFolder := VERSION_FOLDER_PEDAL;
  ////tpdp aDevice.ScanVDriveHint := 'To program the keyboard, you must first connect the v-Drive to the PC using the shortcut SmartSet + Right Shift + V';
  //deviceList.Add(aDevice);
  //
  //aDevice := TDevice.Create;
  //aDevice.DeviceName := 'ADVANTAGE 2';
  //aDevice.DeviceNumber := APPL_ADV2;
  //aDevice.VDriveName := ADV2_DRIVE;
  //aDevice.TutorialUrl := ADV2_TUTORIAL;
  //aDevice.VersionFolder := VERSION_FOLDER_ADV2;
  //aDevice.SettingsFolder := VERSION_FOLDER_ADV2;
  //aDevice.SettingsFile := ADV2_STATE_FILE;
  ////todo aDevice.ScanVDriveHint := 'To program the keyboard, you must first connect the v-Drive to the PC using the shortcut SmartSet + F8';
  //deviceList.Add(aDevice);
end;

procedure TFormDashboard.UpdateDevices;
var
  aDevice: TDevice;

  idx: integer;
begin
  if (not closing) then
  begin
    for idx := 1 to MAX_DEVICES do
    begin
      aDevice := nil;
      if (deviceList.Count >= idx) then
        aDevice := deviceList.Items[idx - 1];

      UpdateDevice(aDevice);
    end;
  end;
end;

procedure TFormDashboard.UpdateDevice(aDevice: TDevice);
var
  appNameLabel: TLabel;
  appConnLabel: TLabel;
  appProfileLabel: TLabel;
  appCheckUpdBtn: TColorSpeedButtonCS;
  appEjectBtn: TImage;
  appOpenBtn: TColorSpeedButtonCS;
  appWatchTutoBtn: TColorSpeedButtonCS;
  idx: integer;
  i: integer;
begin
  if (aDevice <> nil) then
  begin
    idx := -1;
    for i := 1 to MAX_DEVICES do
    begin
      if (deviceList.Items[i - 1] = aDevice) then
        idx := i;
    end;

    if (idx >= 1) then
    begin
      //Init objects
      appNameLabel := nil;
      appConnLabel := nil;
      appProfileLabel := nil;
      appCheckUpdBtn := nil;
      appEjectBtn := nil;
      appWatchTutoBtn := nil;
      appOpenBtn := nil;

      //Get objets by app index
      GetAppObjects(idx, appNameLabel, appConnLabel, appProfileLabel, appCheckUpdBtn, appEjectBtn, appWatchTutoBtn, appOpenBtn);

      appNameLabel.Caption := '';
      appConnLabel.Caption := '';
      appProfileLabel.Caption := '';
      appOpenBtn.Caption := 'Demo Mode';
      appEjectBtn.Visible := false;
      appOpenBtn.Visible := true;
      appCheckUpdBtn.Caption := 'Scan for v-Drive';
      appCheckUpdBtn.Hint := aDevice.ScanVDriveHint;

      if (aDevice <> nil) then
      begin
        //Gets device info
        if (aDevice.Programmable) then
          GetDeviceInformation(aDevice);

        appNameLabel.Caption := aDevice.DeviceName;
        if (not aDevice.Programmable) then
        begin
          appOpenBtn.Visible := false;
          appCheckUpdBtn.Visible := false;
          appEjectBtn.Visible := false;
          appWatchTutoBtn.Visible := false;
        end
        else if (aDevice.FutureDevice) then
        begin
          appOpenBtn.Caption := 'Learn More';
          appConnLabel.Caption := 'Coming Soon';
          appConnLabel.Font.Color := clRed;
          appCheckUpdBtn.Visible := false;
          appEjectBtn.Visible := false;
          appWatchTutoBtn.Visible := false;
        end
        else if not(aDevice.ReadWriteAccess) then
        begin
          appConnLabel.Caption := NO_ACCESS_TEXT;
          appConnLabel.Font.Color := NOT_DETECT_COLOR;
        end
        else if (aDevice.Connected) then
        begin
          appConnLabel.Caption := CONN_TEXT;
          appConnLabel.Font.Color := CONN_COLOR;
          appOpenBtn.Caption := 'Configure';
          appProfileLabel.Caption := 'Profile ' + fileService.GetStartupFileNo(aDevice);
          {$ifdef Win64}
          appEjectBtn.Visible := true;
          {$endif};
          appCheckUpdBtn.Caption := 'Check for Updates';
          appCheckUpdBtn.Hint := '';
        end
        else
        begin
          appConnLabel.Caption := NOT_DETECT_TEXT;
          appConnLabel.Font.Color := NOT_DETECT_COLOR;
        end;

      end;
    end;
  end;
end;

procedure TFormDashboard.GetAppObjects(idx: integer; var appNameLabel: TLabel;
  var appConnLabel: TLabel; var appProfileLabel: TLabel; var appCheckUpdBtn: TColorSpeedButtonCS;
  var appEjectBtn: TImage; var appWatchTutoBtn: TColorSpeedButtonCS; var appOpenBtn: TColorSpeedButtonCS);
begin
  if (idx = 1) then
  begin
    appNameLabel := lblAppName1;
    appConnLabel := lblConnApp1;
    appProfileLabel := lblProfileApp1;
    appCheckUpdBtn := btnCheckUpdatesConnected1;
    appEjectBtn := imgEject1;
    appWatchTutoBtn := btnWatchTutorial1;
    appOpenBtn := btnOpenApp1;
  end
  else if (idx = 2) then
  begin
    appNameLabel := lblAppName2;
    appConnLabel := lblConnApp2;
    appProfileLabel := lblProfileApp2;
    appCheckUpdBtn := btnCheckUpdatesConnected2;
    appEjectBtn := imgEject2;
    appWatchTutoBtn := btnWatchTutorial2;
    appOpenBtn := btnOpenApp2;
  end
  else if (idx = 3) then
  begin
    appNameLabel := lblAppName3;
    appConnLabel := lblConnApp3;
    appProfileLabel := lblProfileApp3;
    appCheckUpdBtn := btnCheckUpdatesConnected3;
    appEjectBtn := imgEject3;
    appWatchTutoBtn := btnWatchTutorial3;
    appOpenBtn := btnOpenApp3;
  end
  else if (idx = 4) then
  begin
    appNameLabel := lblAppName4;
    appConnLabel := lblConnApp4;
    appProfileLabel := lblProfileApp4;
    appCheckUpdBtn := btnCheckUpdatesConnected4;
    appEjectBtn := imgEject4;
    appWatchTutoBtn := btnWatchTutorial4;
    appOpenBtn := btnOpenApp4;
  end;
end;

procedure TFormDashboard.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDashboard.btnEjectMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LoadButtonImage(sender, imgListButtons, 1);
end;

procedure TFormDashboard.btnEjectMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  LoadButtonImage(sender, imgListButtons, 1);
end;

procedure TFormDashboard.btnEjectMouseEnter(Sender: TObject);
begin
  LoadButtonImage(sender, imgListButtons, 1);
end;

procedure TFormDashboard.btnEjectMouseLeave(Sender: TObject);
begin
  LoadButtonImage(sender, imgListButtons, 0);
end;

procedure TFormDashboard.btnEjectClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TImage;
begin
  idx := 0;
  button := (sender as TImage);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = imgEject1) then
      idx := 1
    else if (button = imgEject2) then
      idx := 2
    else if (button = imgEject3) then
      idx := 3
    else if (button = imgEject4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];
      if EjectDevice(device) then
        UpdateDevices;
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crArrow;
    LoadButtonImage(sender, imgListButtons, 0);
  end;
end;

procedure TFormDashboard.btnCheckUpdatesConnectedClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButtonCS;
begin
  idx := 0;
  button := (sender as TColorSpeedButtonCS);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnCheckUpdatesConnected1) then
      idx := 1
    else if (button = btnCheckUpdatesConnected2) then
      idx := 2
    else if (button = btnCheckUpdatesConnected3) then
      idx := 3
    else if (button = btnCheckUpdatesConnected4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];
      if (device.Connected) and (device.ReadWriteAccess) then
      begin
        ShowFirmware(device, backColor, fontColor, activeColor);
      end
      else
      begin
        UpdateDevice(device);

        while not(device.Connected) and (ShowScanVDrive(device, backColor, fontColor) = 1) do
        begin
          UpdateDevice(device);
        end;
      end;
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crArrow;
  end;
end;

procedure TFormDashboard.btnAccessWebsiteClick(Sender: TObject);
begin
  OpenUrl('https://kinesiscorporation.github.io/Adv360-Pro-GUI/');
end;


procedure TFormDashboard.btnGetHelpAdv360ProClick(Sender: TObject);
begin
  OpenUrl('https://kinesis-ergo.com/support/advantage360-pro');
end;

procedure TFormDashboard.LoadAppForms;
begin
  Application.CreateForm(TFormMainAdv360, FormMainAdv360);
  FormMainAdv360.Parent := pnlMain;

  Application.CreateForm(TFormMainFS, FormMainFS);
  FormMainFS.Parent := pnlMain;

  Application.CreateForm(TFormMainAdv2, FormMainAdv2);
  FormMainAdv2.Parent := pnlMain;

  Application.CreateForm(TFormMainSE2, FormMainSE2);
  FormMainSE2.Parent := pnlMain;
end;

procedure TFormDashboard.CloseActiveForms;
begin
  if (FormMainAdv360 <> nil) and (FormMainAdv360.Visible = true) then
  begin
    FormMainAdv360.Close;
    FormMainAdv360 := nil;
  end
  else if (FormMainFS <> nil) and (FormMainFS.Visible = true) then
  begin
    FormMainFS.Close;
    FormMainFS := nil;
  end;
  if (FormMainAdv2 <> nil) and (FormMainAdv2.Visible = true) then
  begin
    FormMainAdv2.Close;
    FormMainAdv2 := nil;
  end;
  if (FormMainSE2 <> nil) and (FormMainSE2.Visible = true) then
  begin
    FormMainSE2.Close;
    FormMainSE2 := nil;
  end;
end;

procedure TFormDashboard.btnWatchTutorialClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButtonCS;
begin
  idx := 0;
  button := (sender as TColorSpeedButtonCS);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnWatchTutorial1) then
      idx := 1
    else if (button = btnWatchTutorial2) then
      idx := 2
    else if (button = btnWatchTutorial3) then
      idx := 3
    else if (button = btnWatchTutorial4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];
      if (device.TutorialUrl <> '') then
        OpenUrl(device.TutorialUrl);
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crArrow;
  end;
end;

procedure TFormDashboard.btnOpenAppClick(Sender: TObject);
var
  idx: integer;
  device: TDevice;
  button: TColorSpeedButtonCS;
begin
  idx := 0;
  button := (sender as TColorSpeedButtonCS);

  try
    Screen.Cursor := crHourGlass;
    button.Enabled := false;

    if (button = btnOpenApp1) then
      idx := 1
    else if (button = btnOpenApp2) then
      idx := 2
    else if (button = btnOpenApp3) then
      idx := 3
    else if (button = btnOpenApp4) then
      idx := 4;

    if (idx > 0) and (deviceList.Count >= 1) then
    begin
      device := deviceList.Items[idx - 1];

      if (device.FutureDevice) then
      begin

      end
      else
        OpenDeviceForm(device);
    end;
  finally
    button.Enabled := true;
    Screen.Cursor := crArrow;
  end;
end;

procedure TFormDashboard.OpenDeviceForm(device: TDevice);
begin
  if (device <> nil) then
  begin
    GDemoMode := not(device.Connected) or not(device.ReadWriteAccess);
    GApplication := device.DeviceNumber;

    if (device.DeviceNumber = APPL_ADV360) then
    begin
      try
        SetSelectedMenu(nil);
        GActiveDevice := device;
        ShowLoading('Loading...', 'Loading Advantage 360...', backColor, fontColor);
        {$ifdef darwin}
        Application.CreateForm(TFormMainAdv360, FormMainAdv360);
        {$endif};
        FormMainAdv360.Parent := pnlMain;
        if (FormMainAdv360.InitForm(self)) then
           FormMainAdv360.Show;
        lblDemoMode.Visible := GDemoMode;
        imgAppLogoAdv360.Visible := true;
      finally
        CloseLoading;
      end;
    end
    else if (device.DeviceNumber = APPL_FSPRO) or (device.DeviceNumber = APPL_FSEDGE) then
    begin
      try
        SetSelectedMenu(nil);
        GActiveDevice := device;
        ShowLoading('Loading...', 'Loading FREESTYLE PRO...', backColor, fontColor);
        {$ifdef darwin}
        Application.CreateForm(TFormMainFS, FormMainFS);
        {$endif};
        FormMainFS.Parent := pnlMain;
        if (FormMainFS.InitForm(self)) then
           FormMainFS.Show;
        lblDemoMode.Visible := GDemoMode;
        imgAppLogoFsPro.Visible := true;
      finally
        CloseLoading;
      end;
    end
    else
    if (device.DeviceNumber = APPL_ADV2) then
    begin
      try
        SetSelectedMenu(nil);
        GActiveDevice := device;
        ShowLoading('Loading...', 'Loading ADVANTAGE 2...', backColor, fontColor);
        {$ifdef darwin}
        Application.CreateForm(TFormMainAdv2, FormMainAdv2);
        {$endif};
        FormMainAdv2.Parent := pnlMain;
        if (FormMainAdv2.InitForm(self)) then
           FormMainAdv2.Show;
        lblDemoMode.Visible := GDemoMode;
        imgAppLogoFsPro.Visible := true;
      finally
        CloseLoading;
      end;
    end
    else if (device.DeviceNumber = APPL_PEDAL) then
    begin
      try
        SetSelectedMenu(nil);
        GActiveDevice := device;
        ShowLoading('Loading...', 'Loading SAVANT ELITE 2...', backColor, fontColor);
        {$ifdef darwin}
        Application.CreateForm(TFormMainSE2, FormMainSE2);
        {$endif};
        FormMainSE2.Parent := pnlMain;
        if (FormMainSE2.InitForm(self)) then
           FormMainSE2.Show;
        lblDemoMode.Visible := GDemoMode;
        imgAppLogoFsPro.Visible := true;
      finally
        CloseLoading;
      end;
    end;
  end;
end;

procedure TFormDashboard.btnMaximizeClick(Sender: TObject);
begin
  Maximize;
end;

procedure TFormDashboard.imgMaximizeClick(Sender: TObject);
begin
  Maximize;
end;

procedure TFormDashboard.Maximize;
var
  aRect: TRect;
begin
  aRect := Screen.MonitorFromWindow(self.Handle).WorkareaRect;

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

  if (not returningToHome) then
  begin
    if (FormMainAdv360 <> nil) and (FormMainAdv360.Visible) then
       FormMainAdv360.Maximize;
    if (FormMainFS <> nil) and (FormMainFS.Visible) then
       FormMainFS.Maximize;
    if (FormMainAdv2 <> nil) and (FormMainAdv2.Visible) then
       FormMainAdv2.Maximize;
    if (FormMainSE2 <> nil) and (FormMainSE2.Visible) then
       FormMainSE2.Maximize;
  end;

  UpdateStateSettings;
end;

procedure TFormDashboard.btnMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TFormDashboard.UpdateStateSettings;
begin
  self.DisableAlign;

  {$ifdef Win64}
  //Disable paint on form
  SendMessage(self.Handle, WM_SETREDRAW, Integer(False), 0);
  {$endif}

  if (cusWindowState = cwMaximized) then
  begin
    if (IsDarkTheme) then
      imgListMenu.GetBitmap(7, imgMaximize.Picture.Bitmap) // btnMaximize.Glyph)
    else
      imgListMenu.GetBitmap(2, imgMaximize.Picture.Bitmap); //btnMaximize.Glyph);
    btnMaximize.Hint := 'Restore window';
  end
  else
  begin
    if (IsDarkTheme) then
      imgListMenu.GetBitmap(6, imgMaximize.Picture.Bitmap) //btnMaximize.Glyph)
    else
      imgListMenu.GetBitmap(1, imgMaximize.Picture.Bitmap); //btnMaximize.Glyph);
    btnMaximize.Hint := 'Maximize';
  end;

  {$ifdef Win64}
  //Enable paint on form on repaint
  SendMessage(self.Handle, WM_SETREDRAW, Integer(True), 0);
  {$endif}

  self.EnableAlign;
  self.Repaint;
end;

procedure TFormDashboard.FormWindowStateChange(Sender: TObject);
begin
  //UpdateStateSettings;
end;

procedure TFormDashboard.imgCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDashboard.imgLogoClick(Sender: TObject);
begin
  OpenURL(KINESIS_URL);
end;

procedure TFormDashboard.imgMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TFormDashboard.lblHomeClick(Sender: TObject);
begin
  ResetToHome;
end;

procedure TFormDashboard.ResetToHome;
begin
  try
    returningToHome := true;

    //Hide logos
    imgAppLogoAdv360.Visible := false;
    imgAppLogoFsPro.Visible := false;

    SetSelectedMenu(lblHome);
    lblDemoMode.Visible := false;
    lblVDriveOk.Visible := false;
    lblVDriveError.Visible := false;
    CloseActiveForms;
    if (not GDemoMode) then
      EjectDevice(GActiveDevice);
    GActiveDevice := nil;
    tmrLoadForms.Enabled := true;

    UpdateDevices;
  finally
    returningToHome := false;
  end;
end;

procedure TFormDashboard.lblHelpClick(Sender: TObject);
begin
  try
    SetSelectedMenu(lblHelp);
    ShowHelpMaster(backColor, fontColor);
  finally
    SetSelectedMenu(lblHome);
  end;
end;

procedure TFormDashboard.lblSettingsClick(Sender: TObject);
begin
  try
    SetSelectedMenu(lblSettings);
    ShowMasterSettings(backColor, fontColor);
  finally
    SetSelectedMenu(lblHome);
  end;
end;

procedure TFormDashboard.tmrCheckConnectedTimer(Sender: TObject);
begin
  tmrCheckConnected.Enabled := false;
  UpdateDevices;
  tmrCheckConnected.Enabled := true;
end;

procedure TFormDashboard.tmrLoadFormsTimer(Sender: TObject);
begin
  //Do only once, load application forms
  tmrLoadForms.Enabled := false;
  {$ifdef Win64}
  LoadAppForms;
  {$endif};
end;

procedure TFormDashboard.TopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MPos.X := X;
  MPos.Y := Y;
end;

procedure TFormDashboard.TopMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    self.Left := self.Left - (MPos.X-X);
    self.Top := self.Top - (MPos.Y-Y);
  end;
end;

procedure TFormDashboard.SetFormBorder(formBorder: TFormBorderStyle);
begin
  self.BorderStyle := formBorder;
  RepaintForm(true);
end;

procedure TFormDashboard.RepaintForm(fullRepaint: boolean);
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

procedure TFormDashboard.EnablePaintImages(value: boolean);
begin
  //Enable/Disable visual effects on controls
  {$ifdef Win64}
  SendMessage(imgMain.Canvas.Handle, WM_SETREDRAW, WPARAM(value), 0);
  {$endif}
  {$ifdef Darwin}

  {$endif}
end;

procedure TFormDashboard.ButtonMouseEnter(Sender: TObject);
begin
// (Sender as TColorSpeedButtonCS).Font.Color := activeColor;
end;

procedure TFormDashboard.ButtonMouseLeave(Sender: TObject);
begin
//     (Sender as TColorSpeedButtonCS).Font.Color := activeColor;
end;

procedure TFormDashboard.ButtonMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
//     (Sender as TColorSpeedButtonCS).Font.Color := activeColor;
end;

procedure TFormDashboard.FormActivate(Sender: TObject);
begin
  if (not returningToHome) then
  begin
    if (FormMainAdv360 <> nil) and (FormMainAdv360.Visible) then
      FormMainAdv360.SetFocus
    else if (FormMainFS <> nil) and (FormMainFS.Visible) then
      FormMainFS.SetFocus
    else if (FormMainAdv2 <> nil) and (FormMainAdv2.Visible) then
      FormMainAdv2.SetFocus
    else if (FormMainSE2 <> nil) and (FormMainSE2.Visible) then
      FormMainSE2.SetFocus;
  end;
end;

procedure TFormDashboard.SetSelectedMenu(menuLabel: TLabel);
begin
  lblHome.Font.Color := KINESIS_MED_GRAY_RGB;
  lblHome.Font.Style := [fsBold];
  lblSettings.Font.Color := KINESIS_MED_GRAY_RGB;
  lblSettings.Font.Style := [fsBold];
  lblHelp.Font.Color := KINESIS_MED_GRAY_RGB;
  lblHelp.Font.Style := [fsBold];

  if (menuLabel <> nil) then
  begin
    menuLabel.Font.Color := KINESIS_GREEN_OFFICE;
    menuLabel.Font.Style := [fsUnderline, fsBold];
  end;
end;

procedure TFormDashboard.LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);
begin
  if (obj is TColorSpeedButtonCS) then
  begin
    if (idx = -1) then
      (obj as TColorSpeedButtonCS).Glyph.Clear
    else
      imgList.GetBitmap(idx, (obj as TColorSpeedButtonCS).Glyph)
  end
  else if (obj is TImage) then
  begin
    if (idx = -1) then
      (obj as TImage).Picture.Clear
    else
      imgList.GetBitmap(idx, (obj as TImage).Picture.Bitmap);
  end;
  (obj as TControl).Repaint;
end;

initialization
  {$R FONTS.RES}

end.

