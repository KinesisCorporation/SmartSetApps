unit u_form_color;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const,lcltype, u_common_ui,
  ColorSpeedButtonCS, HSLRingPicker, LCLIntf,
  mbColorPreview;

type

  { TFormColorSelect }

  TFormColorSelect = class(TBaseForm)
    btnCancel: TColorSpeedButtonCS;
    btnAccept: TColorSpeedButtonCS;
    colorPreview: TmbColorPreview;
    custColor1: TmbColorPreview;
    custColor2: TmbColorPreview;
    custColor3: TmbColorPreview;
    custColor4: TmbColorPreview;
    custColor5: TmbColorPreview;
    custColor6: TmbColorPreview;
    eBlue: TEdit;
    eGreen: TEdit;
    eHTML: TEdit;
    eRed: TEdit;
    imgListTiming: TImageList;
    lblBColor: TLabel;
    lblCustomColors: TLabel;
    lblGColor: TLabel;
    lblPreMixedColors: TLabel;
    lblRColor: TLabel;
    preMixedColor1: TmbColorPreview;
    preMixedColor10: TmbColorPreview;
    preMixedColor2: TmbColorPreview;
    preMixedColor3: TmbColorPreview;
    preMixedColor4: TmbColorPreview;
    preMixedColor5: TmbColorPreview;
    preMixedColor6: TmbColorPreview;
    preMixedColor7: TmbColorPreview;
    preMixedColor8: TmbColorPreview;
    preMixedColor9: TmbColorPreview;
    ringPicker: THSLRingPicker;
    procedure btnAcceptMouseExit(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseExit(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAcceptClick(Sender: TObject);
    procedure colorPreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure custColorChange(Sender: TObject);
    procedure custColorClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ringPickerChange(Sender: TObject);
    procedure rgbKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgbExit(Sender: TObject);
    procedure colorPreMixedClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure eHTMLExit(Sender: TObject);
    procedure eHTMLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure custColorDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    loadingColor: boolean;
    procedure GetRBGEditColor;
    function Validate: boolean;
    procedure ColorChange(newColor: TColor);
  public
    selectedColor: TColor;
  end;

var
  FormColorSelect: TFormColorSelect;
  function ShowColorSelect(curColor: TColor; backColor: TColor; fontColor: TColor): boolean;

implementation

{$R *.lfm}

function ShowColorSelect(curColor: TColor; backColor: TColor; fontColor: TColor): boolean;
begin
  NeedInput := true;

  result := false;
  //Close the dialog if opened
  if FormColorSelect <> nil then
    FreeAndNil(FormColorSelect);

  //Creates the dialog form
  Application.CreateForm(TFormColorSelect, FormColorSelect);

  FormColorSelect.ColorChange(curColor);

  //Loads colors
  FormColorSelect.Color := backColor;
  FormColorSelect.ringPicker.Color := backColor;
  FormColorSelect.Font.Color := fontColor;
  FormColorSelect.lblTitle.Font.Color := fontColor;
  FormColorSelect.lblRColor.Font.Color := fontColor;
  FormColorSelect.lblGColor.Font.Color := fontColor;
  FormColorSelect.lblBColor.Font.Color := fontColor;
  FormColorSelect.lblPreMixedColors.Font.Color := fontColor;
  FormColorSelect.lblCustomColors.Font.Color := fontColor;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormColorSelect.btnCancel, FormColorSelect.imgListTiming, 4);
    LoadButtonImage(FormColorSelect.btnAccept, FormColorSelect.imgListTiming, 6);
  end;

  //Shows dialog and returns value
  if FormColorSelect.ShowModal = mrOK then
  begin
    result := true;
  end;

  NeedInput := false;
end;

{ TFormColorSelect }

procedure TFormColorSelect.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Select a color';
  loadingColor := true;
  custColor1.Color := fileService.AppSettings.CustColor1;
  custColor2.Color := fileService.AppSettings.CustColor2;
  custColor3.Color := fileService.AppSettings.CustColor3;
  custColor4.Color := fileService.AppSettings.CustColor4;
  custColor5.Color := fileService.AppSettings.CustColor5;
  custColor6.Color := fileService.AppSettings.CustColor6;
  loadingColor := false;
end;

procedure TFormColorSelect.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFormColorSelect.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TFormColorSelect.ringPickerChange(Sender: TObject);
begin
  if (not loadingColor) then
  begin
    if (ringPicker.SelectedColor <> clBlack) then
      ColorChange(ringPicker.SelectedColor);
  end;
end;

procedure TFormColorSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 4)
  else
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormColorSelect.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
  end;
end;

procedure TFormColorSelect.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 7)
  else
    LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormColorSelect.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 4)
    else
      LoadButtonImage(sender, imgListTiming, 0);
  end;
end;

procedure TFormColorSelect.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 5)
  else
    LoadButtonImage(sender, imgListTiming, 1);
end;

function TFormColorSelect.Validate: boolean;
var
  countDown: integer;
begin
  //result := false;
  //countDown := 0;
  //if (btnControl.Down) then
  //  inc(countDown);
  //if (btnAlt.Down) then
  //  inc(countDown);
  //if (btnWindows.Down) then
  //  inc(countDown);
  //if (btnShift.Down) then
  //  inc(countDown);
  //
  //if (countDown = 1) then
  //  ShowDialog('Multimodifiers', 'Your must select at least 2 modifiers to create a multimodifier', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
  //else
    result := true;
end;

procedure TFormColorSelect.ColorChange(newColor: TColor);
begin
  try
    loadingColor := true;

    selectedColor := newColor;
    ringPicker.SelectedColor := selectedColor;
    colorPreview.Color := selectedColor;
    eRed.Text := IntToStr(GetRValue(selectedColor));
    eGreen.Text := IntToStr(GetGValue(selectedColor));
    eBlue.Text := IntToStr(GetBValue(selectedColor));
    eHTML.Text := GetHTMLColor(selectedColor);
  finally
    loadingColor := false;
  end;
end;

procedure TFormColorSelect.custColorChange(Sender: TObject);
begin
  if (not loadingColor) then
  begin
    fileService.SetCustomColor(custColor1.Color, 1);
    fileService.SetCustomColor(custColor2.Color, 2);
    fileService.SetCustomColor(custColor3.Color, 3);
    fileService.SetCustomColor(custColor4.Color, 4);
    fileService.SetCustomColor(custColor5.Color, 5);
    fileService.SetCustomColor(custColor6.Color, 6);
    fileService.SaveAppSettings;
  end;
end;

procedure TFormColorSelect.btnAcceptClick(Sender: TObject);
begin
  if (Validate) then
    ModalResult := mrOK;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormColorSelect.colorPreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then   {check if left mouse button was pressed}
    (Sender as TmbColorPreview).BeginDrag(true);  {starting the drag operation}
end;

procedure TFormColorSelect.custColorDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if (Source is TmbColorPreview) then
    Accept := true;
end;

procedure TFormColorSelect.custColorDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  iTag: integer;
begin
  if (Source is TmbColorPreview) then
  begin
    (Sender as TmbColorPreview).Color := (Source as TmbColorPreview).Color;
  end;
end;

procedure TFormColorSelect.custColorClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  custColor: TColor;
begin
  custColor := (Sender as TmbColorPreview).Color;
  if (custColor <> clNone) then
  begin
    ColorChange(custColor);
  end;
end;

procedure TFormColorSelect.GetRBGEditColor;
var
  iRed: integer;
  iGreen: integer;
  iBlue: integer;
begin
  iRed := ConvertToInt(eRed.Text, 0);
  iGreen := ConvertToInt(eGreen.Text, 0);
  iBlue := ConvertToInt(eBlue.Text, 0);

  if (iRed > 255) then
    iRed := 255;
  if (iGreen > 255) then
    iGreen := 255;
  if (iBlue > 255) then
    iBlue := 255;

  eRed.Text := IntToStr(iRed);
  eGreen.Text := IntToStr(iGreen);
  eBlue.Text := IntToStr(iBlue);

  ColorChange(RGB(iRed, iGreen, iBlue));
end;

procedure TFormColorSelect.rgbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  iColor: integer;
begin
  if (key = VK_RETURN) or (key = VK_TAB) then
  begin
    if (eRed.Focused) then
      eGreen.SetFocus
    else if (eGreen.Focused) then
      eBlue.SetFocus
    else if (eBlue.Focused) then
      eHTML.SetFocus;
    Key:= 0;
  end
  else if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    iColor := ConvertToInt((Sender as TEdit).Text, 0);
    if (Key = VK_UP) then
    begin
      if (iColor < 255) then
        inc(iColor)
      else
        iColor := 255;
    end
    else if (Key = VK_DOWN) then
    begin
      if (iColor > 0) then
        dec(iColor)
      else
        iColor := 0;
    end;
    (Sender as TEdit).Text := IntToStr(iColor);
  end;
end;

procedure TFormColorSelect.rgbKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var
  edit: TEdit;
begin
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    edit := (Sender as TEdit);
    if (edit = eRed) or (edit = eGreen) or (edit = eBlue) then
      GetRBGEditColor;
  end;
end;

procedure TFormColorSelect.rgbExit(Sender: TObject);
var
  edit: TEdit;
begin
  edit := (Sender as TEdit);
  if (edit = eRed) or (edit = eGreen) or (edit = eBlue) then
    GetRBGEditColor;
end;

procedure TFormColorSelect.eHTMLExit(Sender: TObject);
var
  sHtml: string;
  edit: TEdit;
begin
  edit := (Sender as TEdit);
  sHtml := edit.Text;
  if (Copy(edit.Text, 1, 1) = '#') then
    sHtml := Copy(edit.Text, 2, Length(edit.Text));
  if (Length(sHtml) = 6) then
  begin
    ColorChange(GetColorHTML(sHtml));
  end
  else
    edit.Text := GetHTMLColor(ringPicker.SelectedColor);
end;

procedure TFormColorSelect.eHTMLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) or (key = VK_TAB) then
  begin
    eRed.SetFocus;
    Key:= 0;
  end;
end;

procedure TFormColorSelect.colorPreMixedClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorChange((Sender as TmbColorPreview).Color);
end;

end.

