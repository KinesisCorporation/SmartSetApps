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
  function ShowScanVDrive(device: TDevice): integer;

implementation

function ShowScanVDrive(device: TDevice): integer;
begin
  if FormScanVDrive <> nil then
    FreeAndNil(FormScanVDrive);

  //Creates the dialog form
  Application.CreateForm(TFormScanVDrive, FormScanVDrive);

  if (device.DeviceNumber = APPL_RGB) then
    FormScanVDrive.lblRGBMessage.Visible := true
  else if (device.DeviceNumber = APPL_TKO) then
    FormScanVDrive.lblTKOMessage.Visible := true;

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
  OpenUrl(MASTER_GAMING_SUPPORT);
end;


end.

