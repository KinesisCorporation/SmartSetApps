unit u_form_intro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_form_firmware, u_common_ui;

type

  { TFormIntro }

  TFormIntro = class(TBaseForm)
    btnWatchTutorial: THSSpeedButton;
    btnReadManual: THSSpeedButton;
    btnContinue: THSSpeedButton;
    btnFirmware: THSSpeedButton;
    chkCheckBox: TCheckBox;
    Label1: TLabel;
    lblCheckBox: TLabel;
    procedure btnContinueClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
    procedure btnFirmwareClick(Sender: TObject);
    procedure btnWatchTutorialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lblCheckBoxClick(Sender: TObject);
  private

  public
    hideNotif: boolean;
  end;

var
  FormIntro: TFormIntro;
  procedure ShowIntro;

implementation

procedure ShowIntro;
begin
  NeedInput := true;
  if FormIntro <> nil then
    FreeAndNil(FormIntro);

  //Creates the dialog form
  Application.CreateForm(TFormIntro, FormIntro);

  FormIntro.ShowModal;
  NeedInput := false;
end;

{$R *.lfm}

{ TFormIntro }

procedure TFormIntro.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Introduction';
  hideNotif := false;
end;

procedure TFormIntro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then
  begin
    btnContinue.Click;
  end
  else if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
  end;
end;

procedure TFormIntro.lblCheckBoxClick(Sender: TObject);
begin
  chkCheckBox.Checked := not chkCheckBox.Checked;
end;

procedure TFormIntro.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (chkCheckBox.Checked) then
  begin
    fileService.SetAppIntroMsg(true);
    fileService.SaveAppSettings;
  end;
  NeedInput := false;
end;

procedure TFormIntro.btnContinueClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormIntro.btnReadManualClick(Sender: TObject);
begin
  OpenUrl(RGB_HELP);
end;

procedure TFormIntro.btnFirmwareClick(Sender: TObject);
begin
  ShowFirmware(GActiveDevice);
end;

procedure TFormIntro.btnWatchTutorialClick(Sender: TObject);
begin
  OpenUrl(RGB_TUTORIAL);
end;


end.

