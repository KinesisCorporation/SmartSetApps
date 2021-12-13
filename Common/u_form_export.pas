unit u_form_export;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, u_base_form, u_const, UserDialog, lcltype, u_common_ui;

type

  { TFormExport }

  TFormExport = class(TBaseForm)
    btnCancel: TColorSpeedButtonCS;
    btnAccept: TColorSpeedButtonCS;
    chkBoth: TCheckBox;
    chkLayout: TCheckBox;
    chkLighting: TCheckBox;
    imgListTiming: TImageList;
    lblBoth: TLabel;
    lblLayout: TLabel;
    lblLighting: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure btnAcceptMouseExit(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseExit(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAcceptClick(Sender: TObject);
    procedure checkBoxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LabelClick(Sender: TObject);
  private
    changing: boolean;
    currentLayoutFile: string;
    currentLedFile: string;
  public

  end;

var
  FormExport: TFormExport;
  procedure ShowExport(curLayoutFile: string; curLedFile: string);

implementation

{$R *.lfm}

procedure ShowExport(curLayoutFile: string; curLedFile: string);
begin
  try
    NeedInput := true;

    //Close the dialog if opened
    if FormExport <> nil then
      FreeAndNil(FormExport);

    //Creates the dialog form
    Application.CreateForm(TFormExport, FormExport);
    FormExport.currentLayoutFile := curLayoutFile;
    FormExport.currentLedFile := curLedFile;

    //Shows dialog
    FormExport.ShowModal;
  finally
    NeedInput := false;
  end;
end;

{ TFormExport }

procedure TFormExport.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Export files';
  changing := false;
  chkBoth.Checked := true;
  {$ifdef Darwin}
  lblBoth.Caption := '    ' + lblBoth.Caption;
  lblLayout.Caption := '    ' + lblLayout.Caption;
  lblLighting.Caption := '    ' + lblLighting.Caption;
  {$endif}
end;

procedure TFormExport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) then
    btnAccept.Click
  else  if (key = VK_ESCAPE) then
    self.ModalResult := mrCancel;
end;

procedure TFormExport.LabelClick(Sender: TObject);
begin
  if (Sender = lblBoth) then
    chkBoth.Checked := true
  else if (Sender = lblLayout) then
    chkLayout.Checked := true
  else if (Sender = lblLighting) then
    chkLighting.Checked := true;
end;

procedure TFormExport.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormExport.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
    LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormExport.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormExport.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormExport.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  LoadButtonImage(sender, imgListTiming, 1);
end;

procedure TFormExport.btnAcceptClick(Sender: TObject);
var
  layoutContent: TStringList;
  ledContent: TStringList;
  errorMsgLayout: string;
  errorMsgLed: string;
begin
  if (SelectDirectoryDialog1.Execute) then
  begin
    layoutContent := nil;
    ledContent := nil;
    try
      if (chkBoth.Checked) or (chkLayout.Checked) then
      begin
        layoutContent := keyService.ConvertToTextFileFmt;
        if not(fileService.SaveFile(IncludeTrailingBackslash(SelectDirectoryDialog1.FileName) + ExtractFileName(currentLayoutFile), layoutContent, true, errorMsgLayout)) then
          ShowDialog('Export', 'Error exporting layout file: ' + errorMsgLayout, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      end;
      if (chkBoth.Checked) or (chkLighting.Checked) then
      begin
        ledContent := keyService.ConvertLedToTextFileFmt;
        if not(fileService.SaveFile(IncludeTrailingBackslash(SelectDirectoryDialog1.FileName) + ExtractFileName(currentLedFile), ledContent, true, errorMsgLed)) then
          ShowDialog('Export', 'Error exporting lighting file: ' + errorMsgLed, mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
      end;
      if (errorMsgLayout = '') and (errorMsgLed = '') then
      begin
        ShowDialog('Export', 'Files exported successfully!', mtConfirmation, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
        self.ModalResult := mrOK;
      end;
    finally
      if (layoutContent <> nil) then
        FreeAndNil(layoutContent);
      if (ledContent <> nil) then
        FreeAndNil(ledContent);
    end;
  end;
  LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormExport.checkBoxClick(Sender: TObject);
begin
  if (changing) then
    exit;

  changing := true;
  if (Sender = chkBoth) then
  begin
    chkLayout.Checked := false;
    chkLighting.Checked := false;
  end
  else if (Sender = chkLighting) then
  begin
    chkBoth.Checked := false;
    chkLayout.Checked := false;
  end
  else if (Sender = chkLayout) then
  begin
    chkBoth.Checked := false;
    chkLighting.Checked := false;
  end;
  changing := false;
end;

end.

