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
    btnCloseLight: TColorSpeedButtonCS;
    btnReadManual: TColorSpeedButtonCS;
    btnRequestSupport: TColorSpeedButtonCS;
    imgKinesisGaming: TImage;
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
    procedure imgKinesisGamingClick(Sender: TObject);
    procedure lblFirmwareClick(Sender: TObject);
    procedure pnlMainClick(Sender: TObject);
  private
    { private declarations }
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
  if (GMasterAppId = APPL_MASTER_GAMING) then
  begin
    lblAppTitle.Caption := HELP_TITLE_GAMING;
    imgKinesis.Visible := false;
    imgKinesisGaming.Visible := true;
  end
  else
  begin
    lblAppTitle.Caption := HELP_TITLE_OFFICE;
    FormAboutMaster.Color := clWhite;
    lblAppTitle.Font.Color := clBlack;
    lblVersion.Font.Color := clBlack;
    btnClose.Visible := false;
    btnCloseLight.Visible := true;
    imgKinesis.Visible := true;
    imgKinesisGaming.Visible := false;
  end;

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
  if (GMasterAppId = APPL_MASTER_GAMING) then
    OpenUrl(MASTER_GAMING_HELP)
  else
    OpenUrl(MASTER_OFFICE_HELP);
end;

procedure TFormAboutMaster.btnRequestSupportClick(Sender: TObject);
begin
  if (GMasterAppId = APPL_MASTER_GAMING) then
    OpenUrl(MASTER_GAMING_SUPPORT)
  else
    OpenUrl(MASTER_OFFICE_SUPPORT);
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

procedure TFormAboutMaster.imgKinesisGamingClick(Sender: TObject);
begin
  OpenURL(KINESIS_GAMING_URL);
end;

procedure TFormAboutMaster.imgKinesisClick(Sender: TObject);
begin
  OpenURL(KINESIS_URL);
end;

procedure TFormAboutMaster.lblFirmwareClick(Sender: TObject);
begin

end;

procedure TFormAboutMaster.pnlMainClick(Sender: TObject);
begin

end;

end.

