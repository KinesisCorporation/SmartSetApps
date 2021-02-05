unit u_form_about_master;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, lclintf, ExtCtrls, u_const, UserDialog, LCLType,
  LineObj, VersionSupport, ColorSpeedButtonCS;

type

  { TFormAboutMaster }

  TFormAboutMaster = class(TForm)
    btnClose: TColorSpeedButtonCS;
    btnReadManual: TColorSpeedButtonCS;
    btnRequestSupport: TColorSpeedButtonCS;
    imgKinesis: TImage;
    lblAppTitle: TLabel;
    lblTitlet: TLabel;
    lblVersion: TLabel;
    lineBorderBottom: TLineObj;
    lineBorderLeft: TLineObj;
    lineBorderRight: TLineObj;
    lineBorderTop: TLineObj;
    pnlMain: TPanel;
    procedure bOkClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
    procedure btnRequestSupportClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgKinesisClick(Sender: TObject);
    procedure lblFirmwareClick(Sender: TObject);
    procedure pnlMainClick(Sender: TObject);
  private
    { private declarations }
    function FindFirstNumberPos(value: string): integer;
    procedure OpenHelpFile;
  public
    { public declarations }
  end;

var
  FormAboutMaster: TFormAboutMaster;

implementation

{$R *.lfm}

{ TFormAboutMaster }

procedure TFormAboutMaster.FormCreate(Sender: TObject);
begin
  SetFont(self, 'Tahoma');
  lblAppTitle.Caption := HELP_TITLE;
  lblVersion.Caption := 'App Version : ' + GetFileVersion;
  btnReadManual.Font.Color := clWhite;
end;

procedure TFormAboutMaster.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormAboutMaster.bOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAboutMaster.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAboutMaster.btnReadManualClick(Sender: TObject);
begin
  //OpenHelpFile;
  OpenUrl(MASTER_HELP);
end;

procedure TFormAboutMaster.btnRequestSupportClick(Sender: TObject);
begin
  OpenUrl(MASTER_SUPPORT);
end;

procedure TFormAboutMaster.btnWatchTutorialClick(Sender: TObject);
begin

end;

procedure TFormAboutMaster.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
  begin
    FormAboutMaster := nil;
  end;
end;

procedure TFormAboutMaster.imgKinesisClick(Sender: TObject);
begin
  OpenURL(KINESIS_GAMING_URL);
end;

procedure TFormAboutMaster.lblFirmwareClick(Sender: TObject);
begin

end;

procedure TFormAboutMaster.pnlMainClick(Sender: TObject);
begin

end;

function TFormAboutMaster.FindFirstNumberPos(value: string): integer;
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

procedure TFormAboutMaster.OpenHelpFile;
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

