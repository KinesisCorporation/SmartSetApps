unit u_form_about_master;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, lclintf, ExtCtrls, u_const, LCLType, u_base_form,
  VersionSupport, ColorSpeedButtonCS;

type

  { TFormAboutMaster }

  TFormAboutMaster = class(TBaseForm)
    btnReadManual: TColorSpeedButtonCS;
    btnRequestSupport: TColorSpeedButtonCS;
    imgKinesisGaming: TImage;
    imgKinesis: TImage;
    lblTitlet: TLabel;
    lblVersion: TLabel;
    pnlMain: TPanel;
    procedure bOkClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
    procedure btnRequestSupportClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
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
  procedure ShowHelpMaster(backColor: TColor; fontColor: TColor);

implementation

{$R *.lfm}

procedure ShowHelpMaster(backColor: TColor; fontColor: TColor);
begin
  //Close the dialog if opened
  if FormAboutMaster <> nil then
    FreeAndNil(FormAboutMaster);

  //Creates the dialog form
  Application.CreateForm(TFormAboutMaster, FormAboutMaster);

  //Loads colors
  FormAboutMaster.Color := backColor;
  FormAboutMaster.lblTitle.Font.Color := fontColor;
  FormAboutMaster.lblVersion.Font.Color := fontColor;

  FormAboutMaster.ShowModal;
end;

{ TFormAboutMaster }

procedure TFormAboutMaster.FormCreate(Sender: TObject);
begin
  inherited;
  SetFont(self, 'Tahoma');
  if (GMasterAppId = APPL_MASTER_GAMING) then
  begin
    lblTitle.Caption := HELP_TITLE_GAMING;
    imgKinesis.Visible := false;
    imgKinesisGaming.Visible := true;
  end
  else
  begin
    lblTitle.Caption := HELP_TITLE_OFFICE;
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

procedure TFormAboutMaster.FormShow(Sender: TObject);
begin
 inherited;
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

