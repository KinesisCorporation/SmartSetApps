unit u_form_scanvdrive;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_form_firmware, u_kinesis_device;

type

  { TFormScanVDrive }

  TFormScanVDrive = class(TBaseForm)
    btnTroubleshootingTips: TColorSpeedButtonCS;
    btnScan: TColorSpeedButtonCS;
    lblFSMessage: TLabel;
    lblAdv360Message: TLabel;
    lblTKOMessage: TLabel;
    lblRGBMessage: TLabel;
    procedure btnScanClick(Sender: TObject);
    procedure btnTroubleshootingTipsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
    scanVDrive: boolean;
  end;

var
  FormScanVDrive: TFormScanVDrive;
  function ShowScanVDrive(device: TDevice; backColor: TColor; fontColor: TColor): integer;

implementation

function ShowScanVDrive(device: TDevice; backColor: TColor; fontColor: TColor): integer;
begin
  if FormScanVDrive <> nil then
    FreeAndNil(FormScanVDrive);

  //Creates the dialog form
  Application.CreateForm(TFormScanVDrive, FormScanVDrive);

  FormScanVDrive.Color := backColor;
  FormScanVDrive.Font.Color := fontColor;
  FormScanVDrive.lblTitle.Font.Color := fontColor;
  FormScanVDrive.lblFSMessage.Font.Color := fontColor;
  FormScanVDrive.lblRGBMessage.Font.Color := fontColor;
  FormScanVDrive.lblTKOMessage.Font.Color := fontColor;
  FormScanVDrive.lblAdv360Message.Font.Color := fontColor;

  if (device.DeviceNumber = APPL_RGB) then
    FormScanVDrive.lblRGBMessage.Visible := true
  else if (device.DeviceNumber = APPL_TKO) then
    FormScanVDrive.lblTKOMessage.Visible := true
  else if (device.DeviceNumber = APPL_FSPRO) or (device.DeviceNumber = APPL_FSEDGE) then
    FormScanVDrive.lblFSMessage.Visible := true
  else if (device.DeviceNumber = APPL_ADV2) then
    FormScanVDrive.lblFSMessage.Visible := true
  else if (device.DeviceNumber = APPL_ADV360) then
    FormScanVDrive.lblAdv360Message.Visible := true;

  FormScanVDrive.ShowModal;
  if (FormScanVDrive.scanVDrive) then
    result := 1
  else
    result := 0;
end;

{$R *.lfm}

{ TFormScanVDrive }

procedure TFormScanVDrive.FormCreate(Sender: TObject);
begin
  inherited;
  scanVDrive := false;
end;

procedure TFormScanVDrive.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
  end;
end;

procedure TFormScanVDrive.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormScanVDrive.btnScanClick(Sender: TObject);
begin
  scanVDrive := true;
  self.ModalResult := mrOk;
end;

procedure TFormScanVDrive.btnTroubleshootingTipsClick(Sender: TObject);
begin
  if (GMasterAppId = APPL_MASTER_GAMING) then
    OpenUrl(MASTER_GAMING_SUPPORT)
  else
    OpenUrl(MASTER_OFFICE_SUPPORT);
end;


end.

