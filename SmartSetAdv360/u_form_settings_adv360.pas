unit u_form_settings_adv360;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls,  ColorSpeedButtonCS,
  u_base_form, u_const, lcltype, ECSlider, ECSwitch, UserDialog, u_file_service,
  u_common_ui;

type

  { TFormSettingsAdv360 }

  TFormSettingsAdv360 = class(TBaseForm)
    btnSave: TColorSpeedButtonCS;
    chkDisableStatus: TCheckBox;
    imgList: TImageList;
    lblDisableStatus: TLabel;
    lblActiveProfile: TLabel;
    lblProgramLock: TLabel;
    lblStatusReport: TLabel;
    lblProfile: TLabel;
    lblStatus: TLabel;
    sliderActiveProfile: TECSlider;
    sliderStatusReport: TECSlider;
    swProgLock: TECSwitch;
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveMouseExit(Sender: TObject);
    procedure btnSaveMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chkDisableStatusClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lblDisableStatusClick(Sender: TObject);
    procedure sliderActiveProfileChange(Sender: TObject);
    procedure sliderActiveProfileMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sliderStatusReportChange(Sender: TObject);
    procedure sliderStatusReportMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure swProgLockChange(Sender: TObject);
  private
    loadingSettings: boolean;
    settingsChanged: boolean;
    function LoadStateSettings: boolean;
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSettingsAdv360: TFormSettingsAdv360;
  function ShowSettingsAdv360(backColor: TColor; fontColor: TColor): boolean;

implementation

{$R *.lfm}

function ShowSettingsAdv360(backColor: TColor; fontColor: TColor): boolean;
begin
  if FormSettingsAdv360 <> nil then
    FreeAndNil(FormSettingsAdv360);
  Application.CreateForm(TFormSettingsAdv360, FormSettingsAdv360);

  //Loads colors
  FormSettingsAdv360.Color := backColor;
  FormSettingsAdv360.Font.Color := fontColor;
  FormSettingsAdv360.lblTitle.Font.Color := fontColor;
  FormSettingsAdv360.lblStatus.Font.Color := fontColor;
  FormSettingsAdv360.lblProfile.Font.Color := fontColor;
  FormSettingsAdv360.lblProgramLock.Font.Color := fontColor;
  FormSettingsAdv360.lblDisableStatus.Font.Color := fontColor;

  if (IsDarkTheme) then
  begin
    FormSettingsAdv360.sliderActiveProfile.Color := backColor;
    FormSettingsAdv360.sliderStatusReport.Color := backColor;
    FormSettingsAdv360.swProgLock.Color := backColor;
  end;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormSettingsAdv360.btnSave, FormSettingsAdv360.imgList, 2);
  end;

  FormSettingsAdv360.ShowModal;
  FormSettingsAdv360 := nil;
  result := true;
end;

{ TFormSettingsAdv360 }


procedure TFormSettingsAdv360.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Global Keyboard Settings';
  LoadStateSettings;
  settingsChanged := false;
end;

function TFormSettingsAdv360.LoadStateSettings: boolean;
var
  errorMsg: string;
begin
  Result := False;
  loadingSettings := true;

  errorMsg := fileService.LoadStateSettings(GActiveDevice);

  if (errorMsg = '') then
  begin
    sliderActiveProfile.Position := fileService.StateSettings.StartupFileNumber;

    if (fileService.StateSettings.StatusPlaySpeed = 0) then
    begin
      sliderStatusReport.Position := 1;
      chkDisableStatus.Checked := true;
    end
    else
    begin
      sliderStatusReport.Position := fileService.StateSettings.StatusPlaySpeed;
      chkDisableStatus.Checked := false;
    end;
    sliderStatusReportChange(self);

    if (fileService.StateSettings.ProgramLock) then
      swProgLock.Checked := true
    else
      swProgLock.Checked := false;

    Result := true;
  end;

  loadingSettings := false;
end;

procedure TFormSettingsAdv360.sliderActiveProfileChange(Sender: TObject);
begin
  lblActiveProfile.Caption := IntToStr(Round(sliderActiveProfile.Position));
end;

procedure TFormSettingsAdv360.sliderActiveProfileMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    sliderPos := sliderActiveProfile.Position;
    if (Frac(sliderPos) >= 0) then
    begin
      value := Round(sliderPos);
      sliderActiveProfile.Position := value;
      settingsChanged := true;
    end;

    self.SetFocus;
    sliderActiveProfile.Repaint;

    if (not loadingSettings) then
    begin

    end;
  end;
end;

procedure TFormSettingsAdv360.sliderStatusReportChange(Sender: TObject);
var
  value: integer;
  aColor:TColor;
begin
  value := Round(sliderStatusReport.Position);
  if (value = 0) or (chkDisableStatus.Checked) then
  begin
    lblStatusReport.Caption := '';
    aColor := KINESIS_DARK_GRAY_ADV360;
  end
  else
  begin
    lblStatusReport.Caption := IntToStr(value);
    aColor := KINESIS_GREEN_OFFICE;
  end;
  sliderStatusReport.Knob.Color := aColor;
  sliderStatusReport.ProgressColor := aColor;
  sliderStatusReport.Scale.TickColor := aColor;
end;

procedure TFormSettingsAdv360.sliderStatusReportMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sliderPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    chkDisableStatus.Checked := false;
    sliderPos := sliderStatusReport.Position;
    if (Frac(sliderPos) > 0) then
    begin
      value := Round(sliderPos);
      sliderStatusReport.Position := value;
      settingsChanged := true;
    end;
  end;
end;

procedure TFormSettingsAdv360.swProgLockChange(Sender: TObject);
begin
  if (not loadingSettings) then
    settingsChanged := true;
end;

procedure TFormSettingsAdv360.btnSaveClick(Sender: TObject);
var
  hideNotif: integer;
begin
  if (settingsChanged) then
  begin
    if (chkDisableStatus.Checked) then
      fileService.SetStatusPlaySpeed(0)
    else
      fileService.SetStatusPlaySpeed(Round(sliderStatusReport.Position));
    fileService.SetProgramLock(swProgLock.Checked);
    fileService.SetStartupFileNumber(Round(sliderActiveProfile.Position));
    if (fileService.SaveStateSettings(GActiveDevice) = '') then
    begin
      settingsChanged := false;

      if (ShowNotification(fileService.AppSettings.SaveMsg)) then
      begin
        hideNotif := ShowDialog('Settings Saved', 'Changes will be implemented when v-Drive is closed.',
          mtInformation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB, nil, 'Hide this notification?');
        if (hideNotif >= DISABLE_NOTIF) then
        begin
          fileService.SetSaveMsg(true);
          fileService.SaveAppSettings;
        end;
      end;
      EjectDevice(GActiveDevice);
      Close;
    end;
  end;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 2)
  else
    LoadButtonImage(sender, imgList, 0);
end;

procedure TFormSettingsAdv360.btnSaveMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgList, 2)
    else
      LoadButtonImage(sender, imgList, 0);
  end;
end;

procedure TFormSettingsAdv360.btnSaveMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 3)
  else
    LoadButtonImage(sender, imgList, 1);
end;

procedure TFormSettingsAdv360.lblDisableStatusClick(Sender: TObject);
begin
  chkDisableStatus.Checked := not chkDisableStatus.Checked;
end;

procedure TFormSettingsAdv360.chkDisableStatusClick(Sender: TObject);
begin
  if (not loadingSettings) then
  begin
    settingsChanged := true;
    sliderStatusReportChange(sender);
  end;
end;

procedure TFormSettingsAdv360.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
var
  dialogResult: integer;
begin
  if settingsChanged then
  begin
    dialogResult := ShowDialog('Save Settings?',
      'Do you want to save changes?',
      mtConfirmation, [mbYes, mbNo, mbCancel], DEFAULT_DIAG_HEIGHT_RGB);

    if dialogResult = mrYes then
      btnSave.Click
    else if dialogResult = mrCancel then
      CloseAction := caNone;
  end;
end;


end.

