unit u_form_about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, VersionSupport, lclintf, HSSpeedButton, u_const, UserDialog;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    btnReadManual: THSSpeedButton;
    btnWatchTutorial: THSSpeedButton;
    Label5: TLabel;
    lblTitle: TLabel;
    lblCompany: TLabel;
    Label4: TLabel;
    lblFirmware: TLabel;
    lblWebsite: TLabel;
    lblVersion: TLabel;
    lblVersion1: TLabel;
    lblVersion2: TLabel;
    lblEmail: TLabel;
    procedure bOkClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);
    procedure lblWebsiteClick(Sender: TObject);
  private
    { private declarations }
    function FindFirstNumberPos(value: string): integer;
    procedure OpenHelpFile;
  public
    { public declarations }
    procedure SetFirmwareVersion(firmwareVersion: string);
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
  OpenHelpFile;
end;

procedure TFormAbout.btnWatchTutorialClick(Sender: TObject);
begin
  if (GApplication = APPL_FSPRO) then
    OpenUrl(FSPRO_TUTORIAL)
  else
    OpenUrl(FSEDGE_TUTORIAL);
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
  SetFont(self, 'Segoe UI');
  lblTitle.Caption := GApplicationName;
  lblVersion.Caption := 'App Version : ' + GetFileVersion;
  if (GApplication = APPL_FSEDGE) then
  begin
    self.Color := KINESIS_DARK_GRAY_FS;
    lblCompany.Caption := 'Kinesis Gaming';
    lblWebsite.Caption := 'www.KinesisGaming.com';
  end
  else if (GApplication = APPL_FSPRO) then
  begin
    Self.Color := clWhite;
    SetFontColor(self, clDefault);
    lblCompany.Caption := 'Kinesis Corporation';
    lblWebsite.Caption := 'www.Kinesis-Ergo.com';
  end;
  lblWebsite.Font.Color := clHighlight;
  lblEmail.Font.Color := clHighlight;
  btnReadManual.Font.Color := clWhite;
  btnWatchTutorial.Font.Color := clWhite;
end;

procedure TFormAbout.lblEmailClick(Sender: TObject);
begin
  OpenUrl('mailto:tech@kinesis.com');
end;

procedure TFormAbout.lblWebsiteClick(Sender: TObject);
begin
  if Copy(lblWebsite.Caption, 1, 4) <> 'http' then //Add HTTP for MacOS
    OpenUrl('http://' + lblWebsite.Caption)
  else
    OpenUrl(lblWebsite.Caption);
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

procedure TFormAbout.SetFirmwareVersion(firmwareVersion: string);
begin
  if (firmwareVersion <> '') then
    lblFirmware.Caption := 'Keyboard Firmware: v' + firmwareVersion
  else
    lblFirmware.Caption := 'Keyboard Firmware : not found';
end;

procedure TFormAbout.OpenHelpFile;
//var
//  filePath: string;
begin
  if (GApplication = APPL_FSPRO) then
    OpenUrl(FSPRO_MANUAL)
  else
    OpenUrl(FSEDGE_MANUAL);
//  filePath := GApplicationPath + '\help\' + USER_MANUAL_FSEDGE;
//  {$ifdef Darwin}filePath := GApplicationPath + '/help/' + USER_MANUAL_FSEDGE;{$endif}

//  if FileExists(filePath) then
//    OpenDocument(filePath)
//  else
//    ShowDialog('Help file', 'Help file not found!', mtError, [mbOK], DEFAULT_DIAG_HEIGHT, KINESIS_DARK_GRAY_FS, clWhite);
end;

end.

