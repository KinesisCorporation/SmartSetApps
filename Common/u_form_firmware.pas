unit u_form_firmware;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const, UserDialog, lcltype,
  lclintf, LineObj, jsonparser, fpjson, u_kinesis_device, versionSupport,
  u_common_ui;

type

  { TFormFirmware }

  TFormFirmware = class(TBaseForm)
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    pnlKBFirware: TPanel;
    pnlLightningFirmware: TPanel;
    pnlApp: TPanel;
    tmrCheck: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure pnlAppClick(Sender: TObject);
    procedure pnlKBFirwareClick(Sender: TObject);
    procedure pnlLightningFirmwareClick(Sender: TObject);
    procedure tmrCheckTimer(Sender: TObject);
  private
    kbMustUpdate: boolean;
    ledMustUpdate: boolean;
    appMustUpdate: boolean;
    firmChecked: boolean;
    aDevice: TDevice;
    firmwareInfo: TFirmwareInfo;
    procedure CheckFirmware;
    procedure DonwloadAndUnzip(url: string);
  public

  end;

var
  FormFirmware: TFormFirmware;
  procedure ShowFirmware(device: TDevice);

implementation

{$R *.lfm}

procedure ShowFirmware(device: TDevice);
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

procedure TFormFirmware.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormFirmware.FormActivate(Sender: TObject);
begin

end;

procedure TFormFirmware.FormShow(Sender: TObject);
begin
  tmrCheck.Enabled := true;
end;

procedure TFormFirmware.pnlAppClick(Sender: TObject);
begin
  if (appMustUpdate) then
  begin
    if (aDevice.DeviceNumber = APPL_RGB) then
      OpenURL(IncludeTrailingBackslash(RGB_HELP) + '#smartset')
    else if (aDevice.DeviceNumber = APPL_TKO) then
      OpenURL(IncludeTrailingBackslash(TKO_HELP) + '#smartset');
  end;
end;

procedure TFormFirmware.pnlKBFirwareClick(Sender: TObject);
begin
  if (kbMustUpdate) then
  begin
    if (aDevice.DeviceNumber = APPL_RGB) then
      OpenURL(IncludeTrailingBackslash(RGB_HELP) + '#firmware')
    else if (aDevice.DeviceNumber = APPL_TKO) then
    begin
      //DonwloadAndUnzip('https://gaming.kinesis-ergo.com/wp-content/uploads/2020/12/TKO_Keyboard_1.0.1_UPDATE.zip');
      OpenURL(IncludeTrailingBackslash(TKO_HELP) + '#firmware');
    end;
  end;
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

procedure TFormFirmware.pnlLightningFirmwareClick(Sender: TObject);
begin
  if (ledMustUpdate) then
  begin
    if (aDevice.DeviceNumber = APPL_RGB) then
      OpenURL(IncludeTrailingBackslash(RGB_HELP) + '#firmware')
    else if (aDevice.DeviceNumber = APPL_TKO) then
      OpenURL(IncludeTrailingBackslash(TKO_HELP) + '#firmware');
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
        verInfo := ReadURLGet('https://gaming.kinesis-ergo.com/wp-json/ksv/v1/get_versions');

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
          else
          begin
            keyboardVer := jObject.Get('keyboard_ver');
            lightingVer := jObject.Get('lighting_ver');
          end;
          {$ifdef Win32}
          appVer := jObject.Get('app_ver');
          {$endif}
          {$ifdef Darwin}
          appVer := jObject.Get('mac_app_ver');
          {$endif}

          //Compare keyboard version
          if (keyboardVer <> '') then
          begin
            GetVersionNumbers(keyboardVer, majorVer, minorVer, revVer);
            if (IsVersionSmaller(firmwareInfo.MajorKBD, firmwareInfo.MinorKBD, firmwareInfo.RevisionKBD, majorVer, minorVer, revVer)) then
            begin
              kbMustUpdate := true;
              pnlKBFirware.BevelOuter := bvRaised;
              pnlKBFirware.BevelColor := clSilver;
              pnlKBFirware.Caption := 'Update Now';
              pnlKBFirware.Cursor := crHandPoint;
            end
            else
              pnlKBFirware.Caption := 'No update available';
          end
          else
            pnlKBFirware.Caption := 'Error fetching keyboard firmware';
          pnlKBFirware.Visible := true;

          //Compare lighting version
          if (lightingVer <> '') then
          begin
            GetVersionNumbers(lightingVer, majorVer, minorVer, revVer);
            if (IsVersionSmaller(firmwareInfo.MajorLED, firmwareInfo.MinorLED, firmwareInfo.RevisionLED, majorVer, minorVer, revVer)) then
            begin
              ledMustUpdate := true;
              pnlLightningFirmware.BevelOuter := bvRaised;
              pnlLightningFirmware.BevelColor := clSilver;
              pnlLightningFirmware.Caption := 'Update Now';
              pnlLightningFirmware.Cursor := crHandPoint;
            end
            else
              pnlLightningFirmware.Caption := 'No update available';
          end
          else
            pnlLightningFirmware.Caption := 'Error fetching lighting firmware';
          pnlLightningFirmware.Visible := true;

          //Compare app version
          if (appVer <> '') then
          begin
            GetVersionNumbers(appVer, majorVer, minorVer, revVer);
            if (IsVersionSmaller(appMarjoVer, appMinorVer, appRevVer, majorVer, minorVer, revVer)) then
            begin
              appMustUpdate := true;
              pnlApp.BevelOuter := bvRaised;
              pnlApp.BevelColor := clSilver;
              pnlApp.Caption := 'Update Now';
              pnlApp.Cursor := crHandPoint;
            end
            else
              pnlApp.Caption := 'No update available';
          end
          else
            pnlApp.Caption := 'Error fetching app version';
          pnlApp.Visible := true;
        end;
      except
        on E: Exception do
        begin
          pnlKBFirware.Caption := 'Check connection';
          pnlLightningFirmware.Caption := 'Check connection';
          pnlApp.Caption := 'Check connection';
          ShowDialog('Firmware', 'Error accessing internet or firmware website: ' + #10 + e.Message, mtConfirmation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
        end;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  begin
    pnlKBFirware.Caption := 'Error reading version.txt file';
    pnlLightningFirmware.Caption := 'Error reading version.txt file';
    pnlApp.Caption := 'Error reading version.txt file';
  end;
end;

end.

