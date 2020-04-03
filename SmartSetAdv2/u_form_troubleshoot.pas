unit u_form_troubleshoot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, LCLIntf, u_const, LCLType, userdialog;

type

  { TFormTroubleshoot }

  TFormTroubleshoot = class(TForm)
    btnDemoMode: THSSpeedButton;
    btnTroubleshooting: THSSpeedButton;
    btnScanVDrive: THSSpeedButton;
    lblInitMessage: TLabel;
    lblTitle: TLabel;
    procedure btnTroubleshootingClick(Sender: TObject);
    procedure btnScanVDriveClick(Sender: TObject);
    procedure btnDemoModeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure openTroubleshootingTipsClick(Sender: TObject);
  private
  public
    scanVDrive: boolean;
    demoMode: boolean;
  end;

var
  FormTroubleshoot: TFormTroubleshoot;
  function ShowTroubleshoot(title: string; init: boolean; backColor: TColor; fontColor: TColor): integer;

implementation

uses u_form_main;

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
end;

function ShowTroubleshoot(title: string; init: boolean; backColor: TColor; fontColor: TColor): integer;
begin
  if FormTroubleshoot <> nil then
    FreeAndNil(FormTroubleshoot);

  //Creates the dialog form
  Application.CreateForm(TFormTroubleshoot, FormTroubleshoot);
  FormTroubleshoot.lblTitle.Caption := title;
  FormTroubleshoot.lblInitMessage.Visible := init;
  FormTroubleshoot.Color := backColor;
  FormTroubleshoot.Font.Color := fontColor;
  FormTroubleshoot.lblTitle.Font.Color := fontColor;
  FormTroubleshoot.lblInitMessage.Font.Color := fontColor;

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

procedure TFormTroubleshoot.openTroubleshootingTipsClick(Sender: TObject);
begin
  OpenUrl(FSPRO_TROUBLESHOOT);
  CloseDialog(mrOk);
end;

procedure TFormTroubleshoot.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormTroubleshoot.btnTroubleshootingClick(Sender: TObject);
begin
  OpenUrl(ADV2_TROUBLESHOOT);
end;

procedure TFormTroubleshoot.btnScanVDriveClick(Sender: TObject);
begin
  scanVDrive := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshoot.btnDemoModeClick(Sender: TObject);
begin
  demoMode := true;
  self.ModalResult := mrOk;
end;


end.

