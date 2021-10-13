unit u_form_troubleshoot_fs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LineObj, ColorSpeedButtonCS, LCLIntf, u_const,
  LCLType, userdialog;

type

  { TFormTroubleshootFS }

  TFormTroubleshootFS = class(TForm)
    btnDemoModeFsPro: TColorSpeedButtonCS;
    btnScan: TColorSpeedButtonCS;
    btnTroubleshootingTips: TColorSpeedButtonCS;
    btnDemoModeFsEdge: TColorSpeedButtonCS;
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
  FormTroubleshootFS: TFormTroubleshootFS;
  function ShowTroubleshootFS(title: string; init: boolean): integer;

implementation

uses u_form_main_fs;

function ShowTroubleshootFS(title: string; init: boolean): integer;
begin
  if FormTroubleshootFS <> nil then
    FreeAndNil(FormTroubleshootFS);

  //Creates the dialog form
  Application.CreateForm(TFormTroubleshootFS, FormTroubleshootFS);
  FormTroubleshootFS.lblTitle.Caption := title;
  FormTroubleshootFS.lblInitMessage.Visible := init;
  FormTroubleshootFS.lblSaveMsg.Visible := not init;
  FormTroubleshootFS.imgSmartInit.Visible := init;
  FormTroubleshootFS.imgSmartSave.Visible := not init;

  FormTroubleshootFS.ShowModal;
  if (FormTroubleshootFS.scanVDrive) then
    result := 1
  else if (FormTroubleshootFS.demoMode) then
  begin
    GDemoMode := true;
    result := 2;
  end
  else
    result := 0;
end;

function MainForm: TFormMainFS;
begin
  result := (Application.MainForm as TFormMainFS);
end;

{$R *.lfm}

{ TFormTroubleshootFS }

procedure TFormTroubleshootFS.FormCreate(Sender: TObject);
begin
  inherited;
  scanVDrive := false;
  demoMode := false;
end;

procedure TFormTroubleshootFS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
  end;
end;

procedure TFormTroubleshootFS.openTroubleshootingTipsEdgeClick(Sender: TObject);
begin
  OpenUrl(FSEDGE_TROUBLESHOOT);
  CloseDialog(mrOk);
end;

procedure TFormTroubleshootFS.openTroubleshootingTipsProClick(Sender: TObject);
begin
  OpenUrl(FSPRO_TROUBLESHOOT);
  CloseDialog(mrOk);
end;

procedure TFormTroubleshootFS.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormTroubleshootFS.btnDemoModeFsEdgeClick(Sender: TObject);
begin
  GApplication := APPL_FSEDGE;
  demoMode := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshootFS.btnDemoModeFsProClick(Sender: TObject);
begin
  GApplication := APPL_FSPRO;
  demoMode := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshootFS.btnScanClick(Sender: TObject);
begin
  scanVDrive := true;
  self.ModalResult := mrOk;
end;

procedure TFormTroubleshootFS.btnTroubleshootingTipsClick(Sender: TObject);
var
  customBtns: TCustomButtons;
begin
  MainForm.createCustomButton(customBtns, 'FS Edge', 100, @openTroubleshootingTipsEdgeClick);
  MainForm.createCustomButton(customBtns, 'FS Pro', 100, @openTroubleshootingTipsProClick);
  ShowDialog('Troubleshooting Tips', 'Select troubleshooting tips for your keyboard',
    mtFSEdge, [], DEFAULT_DIAG_HEIGHT_FS, customBtns);
end;


end.

