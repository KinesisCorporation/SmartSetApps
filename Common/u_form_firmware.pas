unit u_form_firmware;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const, UserDialog, lcltype, lclintf, LineObj,
  ColorSpeedButtonCS, jsonparser, fpjson, u_kinesis_device, versionSupport,
  u_common_ui;

type

  { TFormFirmware }

  TFormFirmware = class(TBaseForm)
    firmwareBtn1: TColorSpeedButtonCS;
    firmwareBtn2: TColorSpeedButtonCS;
    firmwareBtn3: TColorSpeedButtonCS;
    lblKeyboard: TLabel;
    lblLightning: TLabel;
    lblApp: TLabel;
    tmrCheck: TTimer;
    procedure firmwareBtn1Click(Sender: TObject);
    procedure firmwareBtn2Click(Sender: TObject);
    procedure firmwareBtn3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure tmrCheckTimer(Sender: TObject);
  private
    kbMustUpdate: boolean;
    ledMustUpdate: boolean;
    appMustUpdate: boolean;
    firmChecked: boolean;
    aDevice: TDevice;
    firmwareInfo: TFirmwareInfo;
    activeColor: TColor;
    procedure CheckFirmware;
    procedure DonwloadAndUnzip(url: string);
    procedure SetButtonColor;
  public

  end;

var
  FormFirmware: TFormFirmware;
  procedure ShowFirmware(device: TDevice; backColor: TColor; fontColor: TColor; activeColor: TColor);

implementation

{$R *.lfm}

procedure ShowFirmware(device: TDevice; backColor: TColor; fontColor: TColor; activeColor: TColor);
begin
  if (device <> nil) and (device.Connected) then
  begin
    try
      NeedInput := true;

      //Close the dialog if opened
      if FormFirmware <> nil then
        FreeAndNil(FormFirmware);

      //Creates the dialog form
      Application.CreateForm(TFormFirmware, FormFirmware);
      FormFirmware.aDevice := device;
      FormFirmware.activeColor := activeColor;

      //Set colors
      FormFirmware.Color := backColor;
      FormFirmware.Font.Color := fontColor;
      FormFirmware.lblTitle.Font.Color := fontColor;
      FormFirmware.lblKeyboard.Font.Color := fontColor;
      FormFirmware.lblLightning.Font.Color := fontColor;
      FormFirmware.lblApp.Font.Color := fontColor;
      FormFirmware.SetButtonColor;

      if (device.DeviceNumber = APPL_ADV360) then
      begin
        FormFirmware.lblLightning.Visible := false;
        FormFirmware.firmwareBtn2.Visible := false;
        FormFirmware.lblApp.Top := FormFirmware.lblLightning.Top;
        FormFirmware.firmwareBtn3.Top := FormFirmware.firmwareBtn2.Top;
        FormFirmware.Height := FormFirmware.Height - FormFirmware.firmwareBtn3.Height;
      end;

      //Shows dialog
      FormFirmware.ShowModal;
    finally
      NeedInput := false;
    end;
  end;
end;

{ TFormFirmware }

procedure TFormFirmware.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Check for Updates';
  firmChecked := false;
end;

procedure TFormFirmware.SetButtonColor;
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) and not(IsDarkTheme) then
  begin
    SetColorButtonColor(firmwareBtn1, KINESIS_BUTTON_ADV360, clWhite, clNone);
    SetColorButtonColor(firmwareBtn2, KINESIS_BUTTON_ADV360, clWhite, clNone);
    SetColorButtonColor(firmwareBtn3, KINESIS_BUTTON_ADV360, clWhite, clNone);
  end;
end;

procedure TFormFirmware.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormFirmware.FormActivate(Sender: TObject);
begin

end;

procedure TFormFirmware.firmwareBtn1Click(Sender: TObject);
begin
    if (kbMustUpdate) then
  begin
    if (aDevice.DeviceNumber = APPL_RGB) then
      OpenURL(IncludeTrailingBackslash(RGB_HELP) + '#firmware')
    else if (aDevice.DeviceNumber = APPL_TKO) then
    begin
      //DonwloadAndUnzip('https://gaming.kinesis-ergo.com/wp-content/uploads/2020/12/TKO_Keyboard_1.0.1_UPDATE.zip');
      OpenURL(IncludeTrailingBackslash(TKO_HELP) + '#firmware');
    end
    else if (aDevice.DeviceNumber = APPL_ADV360) then
    begin
      OpenURL(ADV360_FIRMWARE);
    end;
  end;
end;

procedure TFormFirmware.firmwareBtn2Click(Sender: TObject);
begin
  if (ledMustUpdate) then
  begin
    if (aDevice.DeviceNumber = APPL_RGB) then
      OpenURL(IncludeTrailingBackslash(RGB_HELP) + '#firmware')
    else if (aDevice.DeviceNumber = APPL_TKO) then
      OpenURL(IncludeTrailingBackslash(TKO_HELP) + '#firmware')
    else if (aDevice.DeviceNumber = APPL_ADV360) then
      OpenURL(ADV360_FIRMWARE);
  end;
end;

procedure TFormFirmware.firmwareBtn3Click(Sender: TObject);
begin
  if (appMustUpdate) then
  begin
    if (aDevice.DeviceNumber = APPL_RGB) then
      OpenURL(IncludeTrailingBackslash(RGB_HELP) + '#smartset-app')
    else if (aDevice.DeviceNumber = APPL_TKO) then
      OpenURL(IncludeTrailingBackslash(TKO_HELP) + '#smartset-app')
    else if (aDevice.DeviceNumber = APPL_ADV360) then
      OpenURL(IncludeTrailingBackslash(ADV360_HELP) + '#smartset-app');
  end;
end;

procedure TFormFirmware.FormShow(Sender: TObject);
begin
  inherited;
  tmrCheck.Enabled := true;
end;

procedure TFormFirmware.DonwloadAndUnzip(url: string);
var
  fileName: string;
  outputPath: string;
  unzippedFile: string;
begin
  outputPath := IncludeTrailingBackslash(IncludeTrailingBackslash(aDevice.RootFolder) + 'firmware');
  if (fileService.DownloadFile(url, outputPath)) then
  begin
    fileName := ExtractFileName(url);
    unzippedFile := fileService.UnzipFile(outputPath + fileName, outputPath);
    if (unzippedFile <> '') then
    begin
      if (FileExists(outputPath + 'update.upd')) then
         DeleteFile(outputPath + 'update.upd');

      if (RenameFile(outputPath + unzippedFile, outputPath + 'update.upd')) then
         ShowMessage('Ready to update!');
    end;
  end;
end;

procedure TFormFirmware.tmrCheckTimer(Sender: TObject);
begin
  tmrCheck.Enabled:= false;
  CheckFirmware;
end;

procedure TFormFirmware.CheckFirmware;
var
  verInfo: string;
  jData : TJSONData;
  jObject : TJSONObject;
  keyboardVer, lightingVer, appVer: String;
  majorVer, minorVer, revVer: integer;
  AppVersion: string;
  appMarjoVer, appMinorVer, appRevVer: integer;
begin
  firmwareInfo := fileService.GetFirmwareVersionInfo(aDevice);
  if (firmwareInfo.VersionKBD <> '') then
  begin
    AppVersion := GetFileVersion;
    GetVersionNumbers(AppVersion, appMarjoVer, appMinorVer, appRevVer);
    try
      try
        firmChecked := true;
        kbMustUpdate := false;
        ledMustUpdate := false;
        appMustUpdate := false;
        majorVer := 0;
        minorVer := 0;
        revVer := 0;

        Screen.Cursor := crHourGlass;

        //Get file info, should return as: {"keyboard_ver":"1.0.0","lighting_ver":"1.0.0","app_ver":"2.0.20", "mac_app_ver":"2.1.3"}
        if (GMasterAppId = APPL_MASTER_GAMING) then
          verInfo := ReadURLGet('https://gaming.kinesis-ergo.com/wp-json/ksv/v1/get_versions')
        else
          verInfo := ReadURLGet('https://kinesis-ergo.com/wp-json/ksv/v1/get_versions');

        //Debug firmware show version info
        if (GDebugFirmware) then
          ShowDialog('Json Result', verInfo, mtInformation, [mbOk], DEFAULT_DIAG_HEIGHT_RGB, nil, '', poMainFormCenter, 900);

        if (verInfo <> '') then
        begin
          jData := GetJSON(verInfo);

          // cast as TJSONObject to make access easier
          jObject := TJSONObject(jData);

          // Get values
          if (aDevice.DeviceNumber = APPL_TKO) then
          begin
            keyboardVer := jObject.Get('tko_keyboard_version');
            lightingVer := jObject.Get('tko_lighting_version');
          end
          else if (aDevice.DeviceNumber = APPL_RGB) then
          begin
            keyboardVer := jObject.Get('keyboard_ver');
            lightingVer := jObject.Get('lighting_ver');
          end
          else if (aDevice.DeviceNumber = APPL_ADV360) then
          begin
            keyboardVer := jObject.Get('kb360_version');
            lightingVer := jObject.Get('kb360_version');
          end;
          {$ifdef Win64}
          if (GMasterAppId = APPL_MASTER_GAMING) then
            appVer := jObject.Get('app_ver')
          else
            appVer := jObject.Get('pc_app_version');
          {$endif}
          {$ifdef Darwin}
          if (GMasterAppId = APPL_MASTER_GAMING) then
            appVer := jObject.Get('mac_app_ver')
          else
            appVer := jObject.Get('mac_app_version');
          {$endif}

          //Compare keyboard version
          if (keyboardVer <> '') then
          begin
            GetVersionNumbers(keyboardVer, majorVer, minorVer, revVer);
            if (IsVersionSmaller(firmwareInfo.MajorKBD, firmwareInfo.MinorKBD, firmwareInfo.RevisionKBD, majorVer, minorVer, revVer)) then
            begin
              kbMustUpdate := true;
              firmwareBtn1.StateNormal.FontColor := activeColor;
              firmwareBtn1.StateActive.FontColor := activeColor;
              firmwareBtn1.StateHover.FontColor := activeColor;
              firmwareBtn1.StateDisabled.FontColor := activeColor;
              firmwareBtn1.Caption := 'Update Now';
              firmwareBtn1.Cursor := crHandPoint;
            end
            else
              firmwareBtn1.Caption := 'No update available';
          end
          else
            firmwareBtn1.Caption := 'Error fetching keyboard firmware';
          firmwareBtn1.Visible := true;

          //Compare lighting version
          if (lightingVer <> '') then
          begin
            GetVersionNumbers(lightingVer, majorVer, minorVer, revVer);
            if (IsVersionSmaller(firmwareInfo.MajorLED, firmwareInfo.MinorLED, firmwareInfo.RevisionLED, majorVer, minorVer, revVer)) then
            begin
              ledMustUpdate := true;
              firmwareBtn2.StateNormal.FontColor := activeColor;
              firmwareBtn2.StateActive.FontColor := activeColor;
              firmwareBtn2.StateHover.FontColor := activeColor;
              firmwareBtn2.StateDisabled.FontColor := activeColor;
              firmwareBtn2.Caption := 'Update Now';
              firmwareBtn2.Cursor := crHandPoint;
            end
            else
              firmwareBtn2.Caption := 'No update available';
          end
          else
            firmwareBtn2.Caption := 'Error fetching lighting firmware';
          firmwareBtn2.Visible := true;

          //Compare app version
          if (appVer <> '') then
          begin
            GetVersionNumbers(appVer, majorVer, minorVer, revVer);
            if (IsVersionSmaller(appMarjoVer, appMinorVer, appRevVer, majorVer, minorVer, revVer)) then
            begin
              appMustUpdate := true;
              firmwareBtn3.StateNormal.FontColor := activeColor;
              firmwareBtn3.StateActive.FontColor := activeColor;
              firmwareBtn3.StateHover.FontColor := activeColor;
              firmwareBtn3.StateDisabled.FontColor := activeColor;
              firmwareBtn3.Caption := 'Update Now';
              firmwareBtn3.Cursor := crHandPoint;
            end
            else
              firmwareBtn3.Caption := 'No update available';
          end
          else
            firmwareBtn3.Caption := 'Error fetching app version';
          firmwareBtn3.Visible := true;
        end;
      except
        on E: Exception do
        begin
          firmwareBtn1.Caption := 'Check connection';
          firmwareBtn2.Caption := 'Check connection';
          firmwareBtn3.Caption := 'Check connection';
          ShowDialog('Firmware', 'Error accessing internet or firmware website: ' + #10 + e.Message, mtConfirmation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  begin
    firmwareBtn1.Caption := 'Error reading firmware file';
    firmwareBtn2.Caption := 'Error reading firmware file';
    firmwareBtn3.Caption := 'Error reading firmware file';
  end;
end;

end.

