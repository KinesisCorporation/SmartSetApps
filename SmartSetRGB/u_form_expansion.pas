unit u_form_expansion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_form_firmware, u_common_ui;

type

  { TFormExpansion }

  TFormExpansion = class(TBaseForm)
    btnImplement: TColorSpeedButtonCS;
    btnLearnMore: TColorSpeedButtonCS;
    chkCheckBox: TCheckBox;
    chkDoNothing: TCheckBox;
    chkMirror: TCheckBox;
    chkLoadExpansion: TCheckBox;
    Label1: TLabel;
    lblCheckBox: TLabel;
    lblDoNothing: TLabel;
    lblMiror: TLabel;
    lblLoad: TLabel;
    procedure btnLearnMoreClick(Sender: TObject);
    procedure btnImplementClick(Sender: TObject);
    procedure chkDoNothingClick(Sender: TObject);
    procedure chkLoadExpansionClick(Sender: TObject);
    procedure chkMirrorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lblCheckBoxClick(Sender: TObject);
    procedure lblDoNothingClick(Sender: TObject);
    procedure lblLoadClick(Sender: TObject);
    procedure lblMirorClick(Sender: TObject);
  private
    expansionVersion: integer;
  public
    hideNotif: boolean;
  end;

var
  FormExpansion: TFormExpansion;
  procedure ShowExpansionDialog(version: integer);

implementation

procedure ShowExpansionDialog(version: integer);
begin
  NeedInput := true;
  if FormExpansion <> nil then
    FreeAndNil(FormExpansion);

  //Creates the dialog form
  Application.CreateForm(TFormExpansion, FormExpansion);
  FormExpansion.expansionVersion := version;
  FormExpansion.lblTitle.Caption := FormExpansion.lblTitle.Caption + ' ' + IntToStr(version);

  //Hide option if version 1
  if (version = 1) then
  begin
    FormExpansion.chkMirror.Top := FormExpansion.chkLoadExpansion.Top;
    FormExpansion.lblMiror.Top := FormExpansion.lblLoad.Top;
    FormExpansion.chkLoadExpansion.Visible := false;
    FormExpansion.lblLoad.Visible := false;
    FormExpansion.Height := FormExpansion.Height - 20;
  end;

  FormExpansion.ShowModal;
  NeedInput := false;
end;

{$R *.lfm}

{ TFormExpansion }

procedure TFormExpansion.FormCreate(Sender: TObject);
begin
  inherited;
  hideNotif := false;
end;

procedure TFormExpansion.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
  end;
end;

procedure TFormExpansion.lblCheckBoxClick(Sender: TObject);
begin
  chkCheckBox.Checked := not chkCheckBox.Checked;
end;

procedure TFormExpansion.lblDoNothingClick(Sender: TObject);
begin
  chkDoNothing.Checked := not chkDoNothing.Checked;
end;

procedure TFormExpansion.lblLoadClick(Sender: TObject);
begin
  chkLoadExpansion.Checked := not chkLoadExpansion.Checked;
end;

procedure TFormExpansion.lblMirorClick(Sender: TObject);
begin
  chkMirror.Checked := not chkMirror.Checked;
end;

procedure TFormExpansion.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if (chkCheckBox.Checked) then
  begin
    fileService.SetAppCheckFirmMsg(true);
    fileService.SaveAppSettings;
  end;
  NeedInput := false;
end;

procedure TFormExpansion.btnLearnMoreClick(Sender: TObject);
begin
  OpenUrl('https://gaming.kinesis-ergo.com/fs-edge-rgb-support/#trouble');
end;

procedure TFormExpansion.btnImplementClick(Sender: TObject);
begin
  if (chkMirror.Checked) then
    fileService.MirrorLightingToFnLayer
  else if (chkLoadExpansion.Checked) then
    fileService.AssignExpansion2Pack;
  Close;
end;

procedure TFormExpansion.chkDoNothingClick(Sender: TObject);
begin
  if (chkDoNothing.Checked) then
  begin
    chkMirror.Checked := false;
    chkLoadExpansion.Checked := false;
  end;
end;

procedure TFormExpansion.chkLoadExpansionClick(Sender: TObject);
begin
  if (chkLoadExpansion.Checked) then
  begin
    chkMirror.Checked := false;
    chkDoNothing.Checked := false;
  end;
end;

procedure TFormExpansion.chkMirrorClick(Sender: TObject);
begin
  if (chkMirror.Checked) then
  begin
    chkLoadExpansion.Checked := false;
    chkDoNothing.Checked := false;
  end;
end;



end.

