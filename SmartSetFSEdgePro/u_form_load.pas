unit u_form_load;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  u_const, userdialog, ColorSpeedButtonCS;

type

  { TFormLoad }

  TFormLoad = class(TForm)
    btnCancel: TColorSpeedButtonCS;
    btnLoad: TColorSpeedButtonCS;
    cboLayout: TComboBox;
    cboBackup: TComboBox;
    lblCustomLayout: TLabel;
    lblLayoutFile: TLabel;
    rgCustom: TRadioButton;
    rgLayout: TRadioButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure cboBackupSelect(Sender: TObject);
    procedure cboLayoutSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblCustomLayoutClick(Sender: TObject);
    procedure lblLayoutFileClick(Sender: TObject);
    procedure rgCustomChange(Sender: TObject);
    procedure rgCustomClick(Sender: TObject);
    procedure rgLayoutChange(Sender: TObject);
    procedure rgLayoutClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormLoad: TFormLoad;
  function ShowLoad(backColor: TColor; fontColor: TColor): string;

implementation

{$R *.lfm}

function ShowLoad(backColor: TColor; fontColor: TColor): string;
begin
  //Close the dialog if opened
  if FormLoad <> nil then
    FreeAndNil(FormLoad);

  //Creates the dialog form
  Application.CreateForm(TFormLoad, FormLoad);

  FormLoad.Color := backColor;
  FormLoad.Font.Color := fontColor;
  FormLoad.lblLayoutFile.Color := backColor;
  FormLoad.lblLayoutFile.Font.Color := fontColor;
  FormLoad.lblCustomLayout.Color := backColor;
  FormLoad.lblCustomLayout.Font.Color := fontColor;

  //Shows dialog and returns value
  if FormLoad.ShowModal = mrOK then
  begin
    if FormLoad.rgLayout.Checked then
    begin
      result := FILE_LAYOUT + FormLoad.cboLayout.Text + '.txt';
    end
    else
    begin
      result := ExtractFileNameWithoutExt(FormLoad.cboBackup.Text) + '.txt';
    end;
  end;
end;

{ TFormLoad }

procedure TFormLoad.lblCustomLayoutClick(Sender: TObject);
begin
  rgCustom.Checked := true;
end;

procedure TFormLoad.lblLayoutFileClick(Sender: TObject);
begin
  rgLayout.Checked := true;
end;

procedure TFormLoad.rgCustomChange(Sender: TObject);
begin
  cboLayout.Enabled := rgLayout.Checked;
  cboBackup.Enabled := rgCustom.Checked;
end;

procedure TFormLoad.rgCustomClick(Sender: TObject);
begin
  if (rgCustom.Checked) and (self.Visible) then
  begin
    cboBackup.SetFocus;
    cboBackup.DroppedDown := true;
  end;
end;

procedure TFormLoad.rgLayoutChange(Sender: TObject);
begin
  cboLayout.Enabled := rgLayout.Checked;
  cboBackup.Enabled := rgCustom.Checked;
end;

procedure TFormLoad.rgLayoutClick(Sender: TObject);
begin
  if (rgLayout.Checked) and (self.Visible) then
  begin
    cboLayout.SetFocus;
    cboLayout.DroppedDown := true;
  end;
end;

procedure TFormLoad.FormCreate(Sender: TObject);
var
  backupFiles: TStringList;
  i: integer;
  fileName: string;
begin
  rgLayout.Checked := true;
  backupFiles := FindAllFiles(GLayoutFilePath, '*.txt', false);
  for i := 0 to backupFiles.Count - 1 do
  begin
    fileName := ExtractFileNameWithoutExt(ExtractFileName(backupFiles[i]));
    if (LowerCase(Copy(fileName, 1, Length(FILE_LAYOUT))) <> LowerCase(FILE_LAYOUT)) and (Copy(fileName, 1, 1) <> '.') then
      cboBackup.Items.Add(fileName);
  end;
end;

procedure TFormLoad.btnLoadClick(Sender: TObject);
begin
  if (rgLayout.Checked) and (Trim(cboLayout.Text) = '') then
  begin
    ShowDialog('Load', 'You must select a layout position 1 to 9', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_FS);
    cboLayout.SetFocus;
  end
  else if (rgCustom.Checked) and (Trim(cboBackup.Text) = '') then
  begin
    ShowDialog('Load', 'You must select a backup layout', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_FS) ;
    cboBackup.SetFocus;
  end
  else
    ModalResult := mrOK;
end;

procedure TFormLoad.cboBackupSelect(Sender: TObject);
begin
  //For Mac to close combo box after selection
  rgCustom.SetFocus;
end;

procedure TFormLoad.cboLayoutSelect(Sender: TObject);
begin
  //For Mac to close combo box after selection
  rgLayout.SetFocus;
end;

procedure TFormLoad.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

