unit u_form_intro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_common_ui;

type

  { TFormIntro }

  TFormIntro = class(TBaseForm)
    btnWatchTutorial: TColorSpeedButtonCS;
    btnReadManual: TColorSpeedButtonCS;
    btnContinue: TColorSpeedButtonCS;
    chkCheckBox: TCheckBox;
    lblMessage: TLabel;
    lblCheckBox: TLabel;
    procedure btnContinueClick(Sender: TObject);
    procedure btnReadManualClick(Sender: TObject);
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
  procedure ShowIntro(title: string; text: string; backColor: TColor; fontColor: TColor);

implementation

procedure ShowIntro(title: string; text: string; backColor: TColor; fontColor: TColor);
begin
  NeedInput := true;
  if FormIntro <> nil then
    FreeAndNil(FormIntro);

  //Creates the dialog form
  Application.CreateForm(TFormIntro, FormIntro);
  FormIntro.lblTitle.Caption := title;
  FormIntro.lblMessage.Caption := text;

  FormIntro.Color := backColor;
  FormIntro.Font.Color := fontColor;
  FormIntro.lblTitle.Font.Color := fontColor;
  FormIntro.lblMessage.Font.Color := fontColor;
  FormIntro.lblCheckBox.Font.Color := fontColor;

  FormIntro.ShowModal;
  NeedInput := false;
end;

{$R *.lfm}

{ TFormIntro }

procedure TFormIntro.FormCreate(Sender: TObject);
begin
  inherited;
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
  case GApplication of
    APPL_RGB: OpenUrl(RGB_MANUAL);
    APPL_TKO: OpenUrl(TKO_MANUAL);
    APPL_ADV360: OpenUrl(ADV360_MANUAL);
    APPL_FSEDGE: OpenUrl(FSEDGE_MANUAL);
    APPL_FSPRO: OpenUrl(FSPRO_MANUAL);
  end;
end;

procedure TFormIntro.btnWatchTutorialClick(Sender: TObject);
begin
  case GApplication of
    APPL_RGB: OpenUrl(RGB_TUTORIAL);
    APPL_TKO: OpenUrl(TKO_TUTORIAL);
    APPL_ADV360: OpenUrl(ADV360_TUTORIAL);
    APPL_FSEDGE: OpenUrl(FSEDGE_TUTORIAL);
    APPL_FSPRO: OpenUrl(FSPRO_TUTORIAL);
  end;
end;


end.

