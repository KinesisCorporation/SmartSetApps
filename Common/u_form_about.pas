unit u_form_about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, lclintf, ExtCtrls, HSSpeedButton, u_const,
  UserDialog, u_base_form, LCLType, versionsupport;

type

  { TFormAbout }

  TFormAbout = class(TBaseForm)
    btnReadManual: THSSpeedButton;
    btnRequestSupport: THSSpeedButton;
    btnWatchTutorial: THSSpeedButton;
    imgKinesis: TImage;
    lblTitlet: TLabel;
    lblAppTitle: TLabel;
    lblFirmware: TLabel;
    lblVersion: TLabel;
    procedure bOkClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
    procedure btnRequestSupportClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgKinesisClick(Sender: TObject);
  private
    { private declarations }
    function FindFirstNumberPos(value: string): integer;
    procedure OpenHelpFile;
  public
    { public declarations }
    procedure SetFirmwareVersion(firmwareVersionKBD, firmwareVersionLed: string);
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }

procedure TFormAbout.bOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.btnReadManualClick(Sender: TObject);
begin
  if (GApplication = APPL_RGB) then
    OpenUrl(RGB_MANUAL)
  else if (GApplication = APPL_TKO) then
    OpenUrl(TKO_MANUAL);
end;

procedure TFormAbout.btnRequestSupportClick(Sender: TObject);
begin
  OpenUrl(MASTER_SUPPORT);
end;

procedure TFormAbout.btnWatchTutorialClick(Sender: TObject);
begin
  if (GApplication = APPL_RGB) then
    OpenUrl(RGB_TUTORIAL)
  else if (GApplication = APPL_TKO) then
    OpenUrl(TKO_TUTORIAL);
end;

procedure TFormAbout.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
  begin
    FormAbout := nil;
  end;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  lblTitle.Visible := false;
  SetFont(self, 'Tahoma');
  lblAppTitle.Caption := HELP_TITLE;
  lblVersion.Caption := 'App Version : ' + GetFileVersion;
  self.Color := KINESIS_DARK_GRAY_FS;
  btnReadManual.Font.Color := clWhite;
  btnWatchTutorial.Font.Color := clWhite;
end;

procedure TFormAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormAbout.imgKinesisClick(Sender: TObject);
begin
  OpenURL(KINESIS_GAMING_URL);
end;

function TFormAbout.FindFirstNumberPos(value: string): integer;
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

procedure TFormAbout.SetFirmwareVersion(firmwareVersionKBD,
  firmwareVersionLed: string);
begin
  if (firmwareVersionKBD <> '') and (firmwareVersionLed <> '') then
  begin
    lblFirmware.Caption := 'KBD Firmware: ' + firmwareVersionKBD + #10 +
      'LED Firmware: ' + firmwareVersionLed;
  end
  else
    lblFirmware.Caption := 'Keyboard Firmware : not found';
end;

procedure TFormAbout.OpenHelpFile;
var
  filePath: string;
begin
  filePath := GApplicationPath + '\help\' + USER_MANUAL_FSEDGE;
  {$ifdef Darwin}filePath := GApplicationPath + '/help/' + USER_MANUAL_FSEDGE;{$endif}

  if FileExists(filePath) then
    OpenDocument(filePath)
  else
    ShowDialog('Help file', 'Help file not found!', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
end;

end.

