unit u_form_settings_master;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, lclintf, ExtCtrls, u_const,
  LCLType, ColorSpeedButtonCS, VersionSupport;

type

  { TFormSettingsMaster }

  TFormSettingsMaster = class(TForm)
    btnClose: TColorSpeedButtonCS;
    chkHideAllNotifs: TCheckBox;
    chkShowNotifs: TCheckBox;
    lblHideAllNotifs: TLabel;
    lblShowNotifs: TLabel;
    lblTitle: TLabel;
    lblTitlet: TLabel;
    pnlMain: TPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure chkHideAllNotifsClick(Sender: TObject);
    procedure chkShowNotifsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lblHideAllNotifsClick(Sender: TObject);
    procedure lblShowNotifsClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSettingsMaster: TFormSettingsMaster;

const
  HideAllNotifsGaming = 'HideAllNotifs';
  ShowAllNotifsGaming = 'ShowAllNotifs';
  HideAllNotifsOffice = 'HideAllNotifsOffice';
  ShowAllNotifsOffice = 'ShowAllNotifsOffice';

implementation

{$R *.lfm}

{ TFormSettingsMaster }

procedure TFormSettingsMaster.FormCreate(Sender: TObject);
begin
  SetFont(self, 'Tahoma');

  chkHideAllNotifs.Checked := GHideAllNotifs;
  chkShowNotifs.Checked := GShowAllNotifs;
end;

procedure TFormSettingsMaster.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormSettingsMaster.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSettingsMaster.lblHideAllNotifsClick(Sender: TObject);
begin
  chkHideAllNotifs.Checked := not(chkHideAllNotifs.Checked);
end;

procedure TFormSettingsMaster.lblShowNotifsClick(Sender: TObject);
begin
  chkShowNotifs.Checked := not(chkShowNotifs.Checked);
end;


procedure TFormSettingsMaster.chkHideAllNotifsClick(Sender: TObject);
begin
  if (chkHideAllNotifs.Checked) then
  begin
    chkShowNotifs.Checked := false;
  end;
end;

procedure TFormSettingsMaster.chkShowNotifsClick(Sender: TObject);
begin
  if (chkShowNotifs.Checked) then
  begin
    chkHideAllNotifs.Checked := false;
  end;
end;


procedure TFormSettingsMaster.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  valueToSave: string;
begin
  //Save values to registry
  if (chkHideAllNotifs.Checked) then
     valueToSave := '1'
  else
     valueToSave := '0';

  if (GMasterAppId = APPL_MASTER_GAMING) then
    SaveToRegistry(HideAllNotifsGaming, valueToSave)
  else if (GMasterAppId = APPL_MASTER_OFFICE) then
    SaveToRegistry(HideAllNotifsOffice, valueToSave);
  GHideAllNotifs := chkHideAllNotifs.Checked;

  if (chkShowNotifs.Checked) then
    valueToSave := '1'
  else
    valueToSave := '0';

  if (GMasterAppId = APPL_MASTER_GAMING) then
    SaveToRegistry(ShowAllNotifsGaming, valueToSave)
  else if (GMasterAppId = APPL_MASTER_OFFICE) then
    SaveToRegistry(ShowAllNotifsOffice, valueToSave);
  GShowAllNotifs := chkShowNotifs.Checked;

  if CloseAction = caFree then
  begin
    FormSettingsMaster := nil;
  end;
end;

end.

