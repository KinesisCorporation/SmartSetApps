unit u_form_firmware;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, u_base_form, u_const, UserDialog, lcltype,
  lclintf, LineObj, jsonparser, fpjson;

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
    procedure CheckFirmware;

  public

  end;

var
  FormFirmware: TFormFirmware;
  procedure ShowFirmware;

implementation

uses u_form_main_rgb;

{$R *.lfm}

procedure ShowFirmware;
begin
  try
    NeedInput := true;

    //Close the dialog if opened
    if FormFirmware <> nil then
      FreeAndNil(FormFirmware);

    //Creates the dialog form
    Application.CreateForm(TFormFirmware, FormFirmware);

    //Shows dialog
    FormFirmware.ShowModal;
  finally
    NeedInput := false;
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
    OpenURL('https://gaming.kinesis-ergo.com/fs-edge-rgb-support/#smartset');
end;

procedure TFormFirmware.pnlKBFirwareClick(Sender: TObject);
begin
  if (kbMustUpdate) then
    OpenURL('https://gaming.kinesis-ergo.com/fs-edge-rgb-support/#firmware');
end;

procedure TFormFirmware.pnlLightningFirmwareClick(Sender: TObject);
begin
  if (ledMustUpdate) then
    OpenURL('https://gaming.kinesis-ergo.com/fs-edge-rgb-support/#firmware');
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
begin
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
        keyboardVer := jObject.Get('keyboard_ver');
        lightingVer := jObject.Get('lighting_ver');
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
          if (fileService.VersionSmallerThanKBD(majorVer, minorVer, revVer)) then
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
          if (fileService.VersionSmallerThanLED(majorVer, minorVer, revVer)) then
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
          if (fileService.VersionSmallerThanApp(majorVer, minorVer, revVer)) then
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
end;

//procedure TFormFirmware.btnCreateDiagnosticFileClick(Sender: TObject);
//var
//  fileContent: TStringList;
//  errorMsg: string;
//begin
//  if (Trim(eSerial.Text) <> '') then
//  begin
//    try
//      Cursor := crHourGlass;
//      fileContent := MainForm.fileService.GetDiagnosticInfo;
//
//      diagnosticFileCreated := (MainForm.fileService.SaveFile(GetDesktopDirectory + '\' + Trim(eSerial.Text) + '.txt', fileContent, true, errorMsg));
//
//      if (diagnosticFileCreated) then
//        ShowDialog('Diagnostics', 'Diagnostics file saved to Desktop!', mtConfirmation, [mbOK], DEFAULT_DIAG_HEIGHT)
//      else
//        ShowDialog('Diagnostics', 'Error creating diagnostics file: ' + errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT);
//
//    finally
//      Cursor := crDefault;
//
//      if (fileContent <> nil) then
//        FreeAndNil(fileContent);
//    end;
//  end;
//end;

//procedure TFormFirmware.btnContactTechSupportClick(Sender: TObject);
//begin
//  OpenUrl('https://gaming.kinesis-ergo.com/contact-tech-support/');
//end;


end.

