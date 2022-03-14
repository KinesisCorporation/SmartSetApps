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
    lblStep1: TLabel;
    lblStep2: TLabel;
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
  procedure ShowDiagnostics(backColor: TColor; fontColor: TColor);

implementation

{$R *.lfm}

procedure ShowDiagnostics(backColor: TColor; fontColor: TColor);
begin
  try
    NeedInput := true;

    //Close the dialog if opened
    if FormDiagnostics <> nil then
      FreeAndNil(FormDiagnostics);

    //Creates the dialog form
    Application.CreateForm(TFormDiagnostics, FormDiagnostics);

    //Set colors
    FormDiagnostics.Color := backColor;
    FormDiagnostics.Font.Color := fontColor;
    FormDiagnostics.lblTitle.Font.Color := fontColor;
    FormDiagnostics.lblStep1.Font.Color := fontColor;
    FormDiagnostics.lblStep2.Font.Color := fontColor;

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
var
  serialNo: string;
begin
  inherited;
  lblTitle.Caption := 'Diagnostics';
  serialNo := '97BRNUSAA0000';
  if (GApplication = APPL_ADV360) then
    serialNo := 's360GB10000';
  lblStep1.Caption := StringReplace(lblStep1.Caption, 'SERXX', serialNo, [rfReplaceAll]);
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
  if (GMasterAppId = APPL_MASTER_GAMING) then
    OpenUrl(MASTER_GAMING_SUPPORT)
  else
    OpenUrl(MASTER_OFFICE_SUPPORT);
end;


end.

