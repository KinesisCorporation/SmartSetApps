unit u_form_troubleshoot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_form_firmware;

type

  { TFormTroubleshoot }

  TFormTroubleshoot = class(TBaseForm)
    btnTroubleshootingTips: THSSpeedButton;
    btnDemoMode: THSSpeedButton;
    btnScan: THSSpeedButton;
    imgSmartInit: TImage;
    imgSmartSave: TImage;
    lblInitMessage: TLabel;
    lblSaveMsg: TLabel;
    procedure btnDemoModeClick(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure btnTroubleshootingTipsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
    scanVDrive: boolean;
    demoMode: boolean;
  end;

var
  FormTroubleshoot: TFormTroubleshoot;
  function ShowTroubleshoot(title: string; init: boolean): integer;

implementation

uses u_form_main_rgb;

function ShowTroubleshoot(title: string; init: boolean): integer;
begin
  if FormTroubleshoot <> nil then
    FreeAndNil(FormTroubleshoot);

  //Creates the dialog form
  Application.CreateForm(TFormTroubleshoot, FormTroubleshoot);
  FormTroubleshoot.lblTitle.Caption := title;
  FormTroubleshoot.lblInitMessage.Visible := init;
  FormTroubleshoot.lblSaveMsg.Visible := not init;
  FormTroubleshoot.imgSmartInit.Visible := init;
  FormTroubleshoot.imgSmartSave.Visible := not init;

  FormTroubleshoot.ShowModal;
  if (FormTroubleshoot.scanVDrive) then
    result := 1
  else if (FormTroubleshoot.demoMode) then
  begin
    GDemoMode := true;
    result := 2;
  end
  else
    result := 0;
end;

function MainForm: TFormMainRGB;
begin
  result := (Application.MainForm as TFormMainRGB);
end;

{$R *.lfm}

{ TFormTroubleshoot }

procedure TFormTroubleshoot.FormCreate(Sender: TObject);
begin
  inherited;
  scanVDrive := false;
  demoMode := false;
end;

procedure TFormTroubleshoot.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
  end;
end;

procedure TFormTroubleshoot.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormTroubleshoot.btnDemoModeClick(Sender: TObject);
begin
  demoMode := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshoot.btnScanClick(Sender: TObject);
begin
  scanVDrive := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshoot.btnTroubleshootingTipsClick(Sender: TObject);
begin
  OpenUrl(RGB_TROUBLESHOOT);
end;


end.

