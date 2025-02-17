unit u_form_load;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ColorSpeedButtonCS, LineObj, uEKnob, ueled, u_const, userdialog,
  u_base_form;

type

  { TFormLoad }

  TFormLoad = class(TBaseForm)
    btnCancel: TColorSpeedButtonCS;
    btnLoad: TColorSpeedButtonCS;
    cboBackup: TComboBox;
    knobPosition: TuEKnob;
    Label11: TLabel;
    Label8: TLabel;
    lblPositionText: TLabel;
    lblCustom: TLabel;
    lblPosition: TLabel;
    ledMacroSpeed3: TuELED;
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure cboBackupEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure knobPositionChange(Sender: TObject);
    procedure knobPositionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
    loadingSettings: boolean;
    settingsChanged: boolean;
    configMode: integer;
  public
    { public declarations }
  end;

var
  FormLoad: TFormLoad;
  function ShowLoad(title: string; currentFile: string; var filePos: string; configMode: integer): string;

implementation

uses u_form_main;

{$R *.lfm}

function MainForm: TFormMain;
begin
  result := (Application.MainForm as TFormMain);
end;

function ShowLoad(title: string; currentFile: string; var filePos: string; configMode: integer): string;
var
  fileNumber: integer;
begin
  //Close the dialog if opened
  if FormLoad <> nil then
    FreeAndNil(FormLoad);

  //Creates the dialog form
  Application.CreateForm(TFormLoad, FormLoad);

  FormLoad.lblTitle.Caption := title;
  FormLoad.configMode := configMode;

  FormLoad.loadingSettings := true;
  fileNumber := MainForm.fileService.GetFileNumber(currentFile);
  if ((configMode = CONFIG_LAYOUT) and (fileNumber >= MIN_LAYOUT_FILE) and (fileNumber <= MAX_LAYOUT_FILE)) or
    ((configMode = CONFIG_LIGHTING) and (fileNumber >= MIN_LED_FILE) and (fileNumber <= MAX_LED_FILE)) then
     FormLoad.knobPosition.Position := fileNumber;
  FormLoad.loadingSettings := false;

  //Shows dialog and returns value
  if FormLoad.ShowModal = mrOK then
  begin
    if Trim(FormLoad.cboBackup.Text) = '' then
    begin
      filePos := IntToStr(Round(FormLoad.knobPosition.Position));
      if (configMode = CONFIG_LAYOUT) then
        result := FILE_LAYOUT + filePos + '.txt'
      else
        result := FILE_LED + filePos + '.txt';
    end
    else
    begin
      result := ExtractFileNameWithoutExt(FormLoad.cboBackup.Text) + '.txt';
    end;
  end;
end;

{ TFormLoad }

procedure TFormLoad.FormCreate(Sender: TObject);
begin
  inherited;
  settingsChanged := false;
  knobPosition.Image := MainForm.imageKnob.Picture.Bitmap;
end;

procedure TFormLoad.FormShow(Sender: TObject);
var
  backupFiles: TStringList;
  i: integer;
  fileName: string;
begin
  inherited;
  if (configMode = CONFIG_LAYOUT) then
  begin
    lblPosition.Caption := 'Load Layout';
    lblCustom.Caption := 'Load Backup Layout';
    backupFiles := FindAllFiles(GLayoutFilePath, '*.txt', false)
  end
  else
  begin
    lblPosition.Caption := 'Load Lighting';
    lblCustom.Caption := 'Load Backup Lighting';
    backupFiles := FindAllFiles(GLedFilePath, '*.txt', false);
  end;
  for i := 0 to backupFiles.Count - 1 do
  begin
    fileName := ExtractFileNameWithoutExt(ExtractFileName(backupFiles[i]));
    if (((configMode = CONFIG_LAYOUT) and (LowerCase(Copy(fileName, 1, Length(FILE_LAYOUT))) <> LowerCase(FILE_LAYOUT))) or
      ((configMode = CONFIG_LIGHTING) and (LowerCase(Copy(fileName, 1, Length(FILE_LED))) <> LowerCase(FILE_LED)))) and
      (Copy(fileName, 1, 1) <> '.') then
      cboBackup.Items.Add(fileName);
  end;
end;

procedure TFormLoad.knobPositionChange(Sender: TObject);
begin
  lblPositionText.Caption := IntToStr(Round(knobPosition.Position));
end;

procedure TFormLoad.knobPositionMouseUp(Sender: TObject;
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

procedure TFormLoad.btnLoadClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormLoad.cboBackupEnter(Sender: TObject);
begin
  cboBackup.DroppedDown:= true;
end;

procedure TFormLoad.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

