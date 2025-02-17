unit u_form_saveas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  userdialog, u_const, ColorSpeedButtonCS;

type

  { TFormSaveAs }

  TFormSaveAs = class(TForm)
    btnSave: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    cboLayout: TComboBox;
    eCustLayout: TEdit;
    lblLayoutFile: TLabel;
    lblCustomLayout: TLabel;
    rgLayout: TRadioButton;
    rgCustom: TRadioButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
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
  FormSaveAs: TFormSaveAs;
  function ShowSaveAs(backColor: TColor; fontColor: TColor; var backupFile: boolean; var layoutFilePos: string): string;

implementation

{$R *.lfm}

function ShowSaveAs(backColor: TColor; fontColor: TColor; var backupFile: boolean; var layoutFilePos: string): string;
begin
  backupFile := false;
  layoutFilePos := '';

  //Close the dialog if opened
  if FormSaveAs <> nil then
    FreeAndNil(FormSaveAs);

  //Creates the dialog form
  Application.CreateForm(TFormSaveAs, FormSaveAs);

  FormSaveAs.Color := backColor;
  FormSaveAs.Font.Color := fontColor;
  FormSaveAs.lblLayoutFile.Color := backColor;
  FormSaveAs.lblLayoutFile.Font.Color := fontColor;
  FormSaveAs.lblCustomLayout.Color := backColor;
  FormSaveAs.lblCustomLayout.Font.Color := fontColor;

  //Shows dialog and returns value
  if FormSaveAs.ShowModal = mrOK then
  begin
    if FormSaveAs.rgLayout.Checked then
    begin
      layoutFilePos := FormSaveAs.cboLayout.Text;
      result := FILE_LAYOUT + FormSaveAs.cboLayout.Text + '.txt';
    end
    else
    begin
      backupFile := true;
      result := ExtractFileNameWithoutExt(FormSaveAs.eCustLayout.Text) + '.txt';
    end;
  end;
  FormSaveAs := nil;
end;

{ TFormSaveAs }

procedure TFormSaveAs.lblCustomLayoutClick(Sender: TObject);
begin
  rgCustom.Checked := true;
end;

procedure TFormSaveAs.FormCreate(Sender: TObject);
begin
  rgLayout.Checked := true;
end;

procedure TFormSaveAs.btnSaveClick(Sender: TObject);
begin
  if (rgLayout.Checked) and (Trim(cboLayout.Text) = '') then
  begin
    ShowDialog('Save As', 'You must select a layout position 1 to 9', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_FS);
    cboLayout.SetFocus;
  end
  else if (rgCustom.Checked) and (Trim(eCustLayout.Text) = '') then
  begin
    ShowDialog('Save As', 'You must enter a backup file name', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_FS);
    eCustLayout.SetFocus;
  end
  else
    ModalResult := mrOK;
end;

procedure TFormSaveAs.cboLayoutSelect(Sender: TObject);
begin
  //For Mac to close combo box after selection
  rgLayout.SetFocus;
end;

procedure TFormSaveAs.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormSaveAs.lblLayoutFileClick(Sender: TObject);
begin
  rgLayout.Checked := true;
end;

procedure TFormSaveAs.rgCustomChange(Sender: TObject);
begin
  cboLayout.Enabled := rgLayout.Checked;
  eCustLayout.Enabled := rgCustom.Checked;
end;

procedure TFormSaveAs.rgCustomClick(Sender: TObject);
begin
  if (rgCustom.Checked) and (self.Visible) then
  begin
    eCustLayout.SetFocus;
  end;
end;

procedure TFormSaveAs.rgLayoutChange(Sender: TObject);
begin
  cboLayout.Enabled := rgLayout.Checked;
  eCustLayout.Enabled := rgCustom.Checked;
end;

procedure TFormSaveAs.rgLayoutClick(Sender: TObject);
begin
  if (rgLayout.Checked) and (self.Visible) then
  begin
    cboLayout.SetFocus;
    cboLayout.DroppedDown := true;
  end;
end;

end.

