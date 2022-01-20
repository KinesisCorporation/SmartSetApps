unit u_form_about_office;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, VersionSupport, lclintf, u_const, UserDialog, u_base_form,
  ColorSpeedButtonCS;

type

  { TFormAboutOffice }

  TFormAboutOffice = class(TBaseForm)
    btnReadManual: TColorSpeedButtonCS;
    btnRequestSupport: TColorSpeedButtonCS;
    btnWatchTutorial: TColorSpeedButtonCS;
    lblCompany: TLabel;
    lblFirmware: TLabel;
    lblWebsite: TLabel;
    lblVersion: TLabel;
    procedure bOkClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
    procedure btnRequestSupportClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure lblWebsiteClick(Sender: TObject);
  private
    { private declarations }
    function FindFirstNumberPos(value: string): integer;
    procedure OpenHelpFile;
    procedure SetFirmwareVersion(firmwareVersion: string; firmwareAlt: string);
  public
    { public declarations }
  end;

var
  FormAboutOffice: TFormAboutOffice;
  procedure ShowHelpOffice(backColor: TColor; fontColor: TColor; firmwareVersion: string; firmwareAlt: string = '');

implementation

{$R *.lfm}

procedure ShowHelpOffice(backColor: TColor; fontColor: TColor; firmwareVersion: string; firmwareAlt: string = '');
begin
  //Close the dialog if opened
  if FormAboutOffice <> nil then
    FreeAndNil(FormAboutOffice);

  //Creates the dialog form
  Application.CreateForm(TFormAboutOffice, FormAboutOffice);

  FormAboutOffice.SetFirmwareVersion(firmwareVersion, firmwareAlt);

  //Loads colors
  FormAboutOffice.Color := backColor;
  FormAboutOffice.lblTitle.Font.Color := fontColor;
  FormAboutOffice.lblVersion.Font.Color := fontColor;
  FormAboutOffice.lblFirmware.Font.Color := fontColor;
  FormAboutOffice.lblCompany.Font.Color := fontColor;

  FormAboutOffice.ShowModal;
end;

{ TFormAboutOffice }

procedure TFormAboutOffice.FormCreate(Sender: TObject);
begin
  inherited;
  SetFont(self, 'Segoe UI');
  lblTitle.Caption := HELP_TITLE_OFFICE;
  lblVersion.Caption := 'App Version : ' + GetFileVersion;
  if (GApplication = APPL_FSEDGE) then
  begin
    lblCompany.Caption := 'Kinesis Gaming';
    lblWebsite.Caption := 'www.KinesisGaming.com';
  end
  else
  begin
    lblCompany.Caption := 'Kinesis Corporation';
    lblWebsite.Caption := 'www.Kinesis-Ergo.com';
  end;
end;
 
procedure TFormAboutOffice.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
  begin
    FormAboutOffice := nil;
  end;
end;

procedure TFormAboutOffice.bOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAboutOffice.btnReadManualClick(Sender: TObject);
begin
  OpenHelpFile;
end;

procedure TFormAboutOffice.btnRequestSupportClick(Sender: TObject);
begin
  if (GApplication = APPL_ADV2) then
    OpenUrl(ADV2_SUPPORT)
  else if (GApplication = APPL_FSPRO) then
    OpenUrl(FSPRO_SUPPORT)
  else if (GApplication = APPL_FSEDGE) then
    OpenUrl(FSEDGE_SUPPORT)
  else if (GApplication = APPL_ADV360) then
    OpenUrl(ADV360_SUPPORT)
  else if (GApplication = APPL_PEDAL) then
    OpenUrl(PEDAL_SUPPORT);
end;

procedure TFormAboutOffice.btnWatchTutorialClick(Sender: TObject);
begin
  if (GApplication = APPL_ADV2) then
    OpenUrl(ADV2_TUTORIAL)
  else if (GApplication = APPL_FSPRO) then
    OpenUrl(FSPRO_TUTORIAL)
  else if (GApplication = APPL_FSEDGE) then
    OpenUrl(FSEDGE_TUTORIAL)
  else if (GApplication = APPL_ADV360) then
    OpenUrl(ADV360_TUTORIAL)
  else if (GApplication = APPL_PEDAL) then
    OpenUrl(PEDAL_TUTORIAL);
end;

procedure TFormAboutOffice.lblEmailClick(Sender: TObject);
begin
  OpenUrl('mailto:tech@kinesis.com');
end;

procedure TFormAboutOffice.lblWebsiteClick(Sender: TObject);
begin
  if Copy(lblWebsite.Caption, 1, 4) <> 'http' then //Add HTTP for MacOS
    OpenUrl('http://' + lblWebsite.Caption)
  else
    OpenUrl(lblWebsite.Caption);
end;

function TFormAboutOffice.FindFirstNumberPos(value: string): integer;
var
  i: integer;
  tempInt, Code: integer;
begin
  result := 0;
  for i := 0 to Length(value) do
  begin
    val(value[i], tempInt, Code);
    if Code = 0 then
    begin
      result := i;
      Code := tempInt; //to remove Hint
      break;
    end;
  end;
end;

procedure TFormAboutOffice.SetFirmwareVersion(firmwareVersion: string; firmwareAlt: string);
begin
  if (firmwareVersion <> '') then
  begin
  if (GApplication = APPL_ADV360) then
  begin
    lblFirmware.Caption := 'Keyboard Firmware (left): ' + firmwareVersion + #10 +
      'Keyboard Firmware (right): ' + firmwareAlt;
  end
  else
  begin
    lblFirmware.Caption := 'Keyboard Firmware: v' + firmwareVersion
  end;
  end
  else
    lblFirmware.Caption := 'Keyboard Firmware : not found';
end;

procedure TFormAboutOffice.OpenHelpFile;
begin
  if (GApplication = APPL_ADV2) then
    OpenUrl(ADV2_MANUAL)
  else if (GApplication = APPL_FSPRO) then
    OpenUrl(FSPRO_MANUAL)
  else if (GApplication = APPL_FSEDGE) then
    OpenUrl(FSEDGE_MANUAL)
  else if (GApplication = APPL_ADV360) then
    OpenUrl(ADV360_MANUAL)
  else if (GApplication = APPL_PEDAL) then
    OpenUrl(PEDAL_MANUAL);
end;

end.

