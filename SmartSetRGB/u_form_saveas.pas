unit u_form_saveas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, ExtCtrls, ColorSpeedButtonCS, ueled, uEKnob, LineObj, ECSlider, u_const,
  u_base_form;

type

  { TFormSaveAs }

  TFormSaveAs = class(TBaseForm)
    btnSave: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    chkCheckBox: TCheckBox;
    eCustFile: TEdit;
    knobPosition: TuEKnob;
    Label11: TLabel;
    Label8: TLabel;
    lblPosition: TLabel;
    lblCheckBox: TLabel;
    lblDefaultPos: TLabel;
    lblCustom: TLabel;
    ledMacroSpeed3: TuELED;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure knobPositionChange(Sender: TObject);
    procedure knobPositionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblCheckBoxClick(Sender: TObject);
  private
    { private declarations }
    configMode: integer;
    loadingSettings: boolean;
    settingsChanged: boolean;
  public
    { public declarations }
  end;

var
  FormSaveAs: TFormSaveAs;
  function ShowSaveAs(title: string; currentFile: string; configMode: integer; var backupFile: boolean; var filePos: string): string;

implementation

uses u_form_main;

{$R *.lfm}

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
end;

function ShowSaveAs(title: string; currentFile: string; configMode: integer; var backupFile: boolean; var filePos: string): string;
var
  fileNumber: integer;
begin
  backupFile := false;
  filePos := '';

  //Close the dialog if opened
  if FormSaveAs <> nil then
    FreeAndNil(FormSaveAs);

  //Creates the dialog form
  Application.CreateForm(TFormSaveAs, FormSaveAs);
  FormSaveAs.lblTitle.Caption := title;
  FormSaveAs.configMode := configMode;;

  FormSaveAs.loadingSettings := true;
  fileNumber := MainForm.fileService.GetFileNumber(currentFile);
  if (fileNumber >= MIN_LAYOUT_FILE) and (fileNumber <= MAX_LAYOUT_FILE) then
     FormSaveAs.knobPosition.Position := fileNumber;
  FormSaveAs.loadingSettings := false;

  //Shows dialog and returns value
  if FormSaveAs.ShowModal = mrOK then
  begin
    if Trim(FormSaveAs.eCustFile.Text) = '' then
    begin
      filePos := IntToStr(Round(FormSaveAs.knobPosition.Position));
      result := filePos;
      if (FormSaveAs.chkCheckBox.Checked) then
      begin
        MainForm.fileService.SetStartupFileNumber(Round(FormSaveAs.knobPosition.Position));
        MainForm.fileService.SaveStateSettings;
      end;
    end
    else
    begin
      backupFile := true;
      result := ExtractFileNameWithoutExt(FormSaveAs.eCustFile.Text) + '.txt';
    end;
  end;
end;

{ TFormSaveAs }

procedure TFormSaveAs.FormCreate(Sender: TObject);
begin
  inherited;
  knobPosition.Image := MainForm.imageKnob.Picture.Bitmap;
  settingsChanged := false;
end;

procedure TFormSaveAs.FormShow(Sender: TObject);
begin
  inherited;
  lblCheckBox.Caption := 'Load Profile to Keyboard' + #10 + 'when v-Drive is closed';
  lblCustom.Caption := 'Save as Backup Profile';
end;

procedure TFormSaveAs.knobPositionChange(Sender: TObject);
begin
  lblPosition.Caption := IntToStr(Round(knobPosition.Position));
end;

procedure TFormSaveAs.knobPositionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  knobPos: Real;
  value: integer;
begin
  if (not loadingSettings) then
  begin
    knobPos := knobPosition.Position;
    if (Frac(knobPos) > 0) then
    begin
      value := Round(knobPos);
      knobPosition.Position := value;
      settingsChanged := true;
    end;
  end;
end;

procedure TFormSaveAs.lblCheckBoxClick(Sender: TObject);
begin
  chkCheckBox.Checked := not chkCheckBox.Checked;
end;

procedure TFormSaveAs.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormSaveAs.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

