unit u_form_diagnostics;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, u_base_form, u_const, UserDialog, lcltype,
  lclintf, u_common_ui;

type

  { TFormDiagnostics }

  TFormDiagnostics = class(TBaseForm)
    eSerial: TEdit;
    btnCreateDiagnosticFile: TColorSpeedButtonCS;
    btnContactTechSupport: TColorSpeedButtonCS;
    Label1: TLabel;
    Label3: TLabel;
    procedure btnContactTechSupportClick(Sender: TObject);
    procedure btnCreateDiagnosticFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    diagnosticFileCreated: boolean;
  public

  end;

var
  FormDiagnostics: TFormDiagnostics;
  procedure ShowDiagnostics;

implementation

{$R *.lfm}

procedure ShowDiagnostics;
begin
  try
    NeedInput := true;

    //Close the dialog if opened
    if FormDiagnostics <> nil then
      FreeAndNil(FormDiagnostics);

    //Creates the dialog form
    Application.CreateForm(TFormDiagnostics, FormDiagnostics);

    //Shows dialog
    FormDiagnostics.ShowModal;
  finally
    NeedInput := false;
  end;
end;

{ TFormDiagnostics }

procedure TFormDiagnostics.btnCreateDiagnosticFileClick(Sender: TObject);
var
  fileContent: TStringList;
  errorMsg: string;
begin
  if (Trim(eSerial.Text) <> '') then
  begin
    try
      Cursor := crHourGlass;
      fileContent := fileService.GetDiagnosticInfo(GActiveDevice);

      diagnosticFileCreated := (fileService.SaveFile(GetDesktopDirectory + Trim(eSerial.Text) + '.txt', fileContent, true, errorMsg));

      if (diagnosticFileCreated) then
        ShowDialog('Diagnostics', 'Diagnostics file saved to Desktop!', mtConfirmation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
      else
        ShowDialog('Diagnostics', 'Error creating diagnostics file: ' + errorMsg, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

    finally
      Cursor := crDefault;

      if (fileContent <> nil) then
        FreeAndNil(fileContent);
    end;
  end;
end;

procedure TFormDiagnostics.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Diagnostics';
  diagnosticFileCreated := false;
end;

procedure TFormDiagnostics.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormDiagnostics.btnContactTechSupportClick(Sender: TObject);
begin
  OpenUrl('https://gaming.kinesis-ergo.com/contact-tech-support/');
end;


end.

