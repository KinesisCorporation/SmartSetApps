unit u_form_troubleshoot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_form_firmware;

type

  { TFormTroubleshoot }

  TFormTroubleshoot = class(TBaseForm)
    btnTroubleshootingTips: TColorSpeedButtonCS;
    btnDemoMode: TColorSpeedButtonCS;
    btnScan: TColorSpeedButtonCS;
    imgSmartInit: TImage;
    imgSmartInitLight: TImage;
    lblInitGamingMessage: TLabel;
    lblInitAdv2Fs: TLabel;
    lblAdv360Message: TLabel;
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
  function ShowTroubleshoot(title: string; backColor: TColor; fontColor: TColor): integer;

implementation

function ShowTroubleshoot(title: string; backColor: TColor; fontColor: TColor): integer;
begin
  if FormTroubleshoot <> nil then
    FreeAndNil(FormTroubleshoot);

  //Creates the dialog form
  Application.CreateForm(TFormTroubleshoot, FormTroubleshoot);
  FormTroubleshoot.lblTitle.Caption := title;

  //Loads colors
  FormTroubleshoot.Color := backColor;
  FormTroubleshoot.lblTitle.Font.Color := fontColor;
  FormTroubleshoot.lblInitGamingMessage.Font.Color := fontColor;
  FormTroubleshoot.lblInitAdv2Fs.Font.Color := fontColor;
  FormTroubleshoot.lblAdv360Message.Font.Color := fontColor;
  if (GApplication in [APPL_ADV2, APPL_FSPRO, APPL_FSEDGE, APPL_PEDAL]) then
  begin
    FormTroubleshoot.lblInitAdv2Fs.Visible := true;
  end
  else if (GApplication in [APPL_RGB, APPL_TKO]) then
  begin
    FormTroubleshoot.lblInitGamingMessage.Visible := true;
    FormTroubleshoot.imgSmartInit.Visible := true;
  end
  else if (GApplication in [APPL_ADV360]) then
  begin
    FormTroubleshoot.lblAdv360Message.Visible := true;
    FormTroubleshoot.imgSmartInitLight.Visible := true;
  end;

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
  if (GApplication in [APPL_RGB]) then
    OpenUrl(RGB_TROUBLESHOOT)
  else if (GApplication in [APPL_TKO]) then
    OpenUrl(TKO_TROUBLESHOOT)
  else if (GApplication in [APPL_FSEDGE]) then
    OpenUrl(FSEDGE_TROUBLESHOOT)
  else if (GApplication in [APPL_FSPRO]) then
    OpenUrl(FSPRO_TROUBLESHOOT)
  else if (GApplication in [APPL_ADV2]) then
    OpenUrl(ADV2_TROUBLESHOOT)
  else if (GApplication in [APPL_ADV360]) then
    OpenUrl(ADV360_TROUBLESHOOT)
  else if (GApplication in [APPL_PEDAL]) then
    OpenUrl(PEDAL_TROUBLESHOOT);
end;


end.

