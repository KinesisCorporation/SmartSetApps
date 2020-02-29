unit u_form_troubleshoot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, LCLIntf, u_const, LCLType, userdialog;

type

  { TFormTroubleshoot }

  TFormTroubleshoot = class(TForm)
    btnDemoModeFsPro: THSSpeedButton;
    btnTroubleshootingTips: THSSpeedButton;
    btnDemoModeFsEdge: THSSpeedButton;
    btnScan: THSSpeedButton;
    imgSmartInit: TImage;
    imgSmartSave: TImage;
    lblInitMessage: TLabel;
    lblSaveMsg: TLabel;
    lblTitle: TLabel;
    procedure btnDemoModeFsEdgeClick(Sender: TObject);
    procedure btnDemoModeFsProClick(Sender: TObject);
    procedure btnScanClick(Sender: TObject);
    procedure btnTroubleshootingTipsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure openTroubleshootingTipsEdgeClick(Sender: TObject);
    procedure openTroubleshootingTipsProClick(Sender: TObject);
  private
  public
    scanVDrive: boolean;
    demoMode: boolean;
  end;

var
  FormTroubleshoot: TFormTroubleshoot;
  function ShowTroubleshoot(title: string; init: boolean): integer;

implementation

uses u_form_main;

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

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
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

procedure TFormTroubleshoot.openTroubleshootingTipsEdgeClick(Sender: TObject);
begin
  OpenUrl(FSEDGE_TROUBLESHOOT);
  CloseDialog(mrOk);
end;

procedure TFormTroubleshoot.openTroubleshootingTipsProClick(Sender: TObject);
begin
  OpenUrl(FSPRO_TROUBLESHOOT);
  CloseDialog(mrOk);
end;

procedure TFormTroubleshoot.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormTroubleshoot.btnDemoModeFsEdgeClick(Sender: TObject);
begin
  GApplication := APPL_FSEDGE;
  demoMode := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshoot.btnDemoModeFsProClick(Sender: TObject);
begin
  GApplication := APPL_FSPRO;
  demoMode := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshoot.btnScanClick(Sender: TObject);
begin
  scanVDrive := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshoot.btnTroubleshootingTipsClick(Sender: TObject);
var
  customBtns: TCustomButtons;
begin
  MainForm.createCustomButton(customBtns, 'FS Edge', 100, @openTroubleshootingTipsEdgeClick);
  MainForm.createCustomButton(customBtns, 'FS Pro', 100, @openTroubleshootingTipsProClick);
  ShowDialog('Troubleshooting Tips', 'Select troubleshooting tips for your keyboard',
    mtFSEdge, [], DEFAULT_DIAG_HEIGHT_FS, self.Color, clWhite, customBtns);
end;


end.

