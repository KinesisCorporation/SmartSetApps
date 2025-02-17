unit UserDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, LineObj, u_const, u_base_form, LCLType,
  u_common_ui, ColorSpeedButtonCS;

type

  { TFormUserDialog }

  TFormUserDialog = class(TBaseForm)
    chkCheckBox: TCheckBox;
    ilDialog: TImageList;
    imgDialog: TImage;
    lblCheckBox: TLabel;
    lblMessage: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure lblCheckBoxClick(Sender: TObject);
  private
    { private declarations }
    aButtons: array of TColorSpeedButtonCS;
    procedure AddButton(btnCaption: String; btnType: TBitBtnKind; buttonTop: integer; btnWidth: integer = 90; onBtnClick: TNotifyEvent = nil);
  public
    { public declarations }
    procedure btnOkClick(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  end;

var
  FormUserDialog: TFormUserDialog;
  LastDialog: TFormUserDialog;
  function ShowDialog(Caption, Message: string; dlgType: TMsgDlgTypeApp; dlgButtons: TMsgDlgButtons;
    dialogHeight: integer = DEFAULT_DIAG_HEIGHT_RGB; customButtons: TCustomButtons = nil;
    checkBoxCaption: string = ''; openPosition: TPosition = poMainFormCenter; dialogWidth: integer = 0): integer;
  procedure CloseDialog(resultType: integer);

implementation
//
//uses u_form_main_rgb;

{$R *.lfm}
//
//function MainForm: TFormMainRGB;
//begin
//  result := (Application.MainForm as TFormMainRGB);
//end;

//Function to call a dialog box
function ShowDialog(Caption, Message: string; dlgType: TMsgDlgTypeApp; dlgButtons: TMsgDlgButtons;
  dialogHeight: integer = DEFAULT_DIAG_HEIGHT_RGB; customButtons: TCustomButtons = nil;
  checkBoxCaption: string = ''; openPosition: TPosition = poMainFormCenter; dialogWidth: integer = 0): integer;
var
  i: integer;
  formDialog: TFormUserDialog;
  modalResult: integer;
  originalHeight: integer;
  messageHeight: integer;
  otherElementsTop: integer;
const
  WARNING_ICON = 0;
  ERROR_ICON = 1;
  INFO_ICON = 2;
  CONFIRM_ICON = 3;
  FSEDGE_ICON = 4;
  FSPRO_ICON = 5;
begin
  NeedInput := true;
  //Close the dialog if opened
  //if FormUserDialog <> nil then
  //  FreeAndNil(FormUserDialog);

  //Creates the dialog form
  Application.CreateForm(TFormUserDialog, formDialog);
  formDialog.Position := openPosition;
  LastDialog := formDialog;
  originalHeight := formDialog.Height;

  //Loads Caption text
  formDialog.lblTitle.Caption := Caption;
  formDialog.lblMessage.Caption := Message;
  messageHeight := formDialog.lblMessage.Height + (dialogHeight - originalHeight);
  formDialog.lblMessage.Height := messageHeight;
  formDialog.Height := dialogHeight;
  otherElementsTop := messageHeight + formDialog.lblMessage.Top + 5;
  if (dialogWidth <> 0) then
    formDialog.Width := dialogWidth;

  //Loads colors
  if (GMasterAppId = APPL_MASTER_OFFICE) and not(IsDarkTheme) then
  begin
    formDialog.Color := KINESIS_LIGHT_GRAY_ADV360; //clWhite;
    formDialog.Font.Color := KINESIS_DARK_GRAY_RGB;//clBlack;

    formDialog.lblTitle.Font.Color := formDialog.Font.Color;
    formDialog.lblMessage.Color := formDialog.Color;
    formDialog.lblMessage.Font.Color := formDialog.Font.Color ;
    formDialog.lblCheckBox.Font.Color := formDialog.Font.Color ;
  end;

  {$ifdef Darwin}
  formDialog.chkCheckBox.Top := formDialog.chkCheckBox.Top - 5;
  formDialog.lblCheckBox.Left := formDialog.lblCheckBox.Left + 5;
  {$endif}

  //Loads the image for dialog type
  if dlgType in [mtConfirmation] then
    formDialog.ilDialog.GetBitmap(CONFIRM_ICON, formDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtWarning] then
    formDialog.ilDialog.GetBitmap(WARNING_ICON, formDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtError] then
    formDialog.ilDialog.GetBitmap(ERROR_ICON, formDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtInformation] then
    formDialog.ilDialog.GetBitmap(INFO_ICON, formDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtFSEdge] then
    formDialog.ilDialog.GetBitmap(FSEDGE_ICON, formDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtFSPro] then
    formDialog.ilDialog.GetBitmap(FSPRO_ICON, formDialog.imgDialog.Picture.Bitmap)
  else
    formDialog.ilDialog.GetBitmap(CONFIRM_ICON, formDialog.imgDialog.Picture.Bitmap);

  //Adds buttons according to options
  if mbYes in dlgButtons then
    formDialog.AddButton('Yes', bkYes, otherElementsTop);
  if mbNo in dlgButtons then
    formDialog.AddButton('No', bkNo, otherElementsTop);
  if mbOK in dlgButtons then
    formDialog.AddButton('OK', bkOK, otherElementsTop);
  if mbCancel in dlgButtons then
    formDialog.AddButton('Cancel', bkCancel, otherElementsTop);

  if (Length(customButtons) > 0) then
  begin
    for i := 0 to Length(customButtons) - 1 do
      formDialog.AddButton(customButtons[i].Caption, customButtons[i].Kind, otherElementsTop,
      customButtons[i].Width, customButtons[i].OnClick);
  end;

  if (checkBoxCaption <> '') then
  begin
    formDialog.lblCheckBox.Caption := checkBoxCaption;
    formDialog.lblCheckBox.Visible := true;
    formDialog.lblCheckBox.Top := otherElementsTop + (formDialog.chkCheckBox.Height - formDialog.lblCheckBox.Height);
    formDialog.chkCheckBox.Caption := '';
    formDialog.chkCheckBox.Visible := true;
    formDialog.chkCheckBox.Top := otherElementsTop;

    if (Length(customButtons) > 2) then
    begin
      formDialog.Height := formDialog.Height + 25;
      formDialog.chkCheckBox.Top := formDialog.chkCheckBox.Top + 40;
      formDialog.lblCheckBox.Top := formDialog.lblCheckBox.Top + 40;
    end;
  end
  else
  begin
    formDialog.lblCheckBox.Visible := false;
    formDialog.chkCheckBox.Visible := false;
  end;

  //Shows dialog and returns value
  modalResult := formDialog.ShowModal;
  if (checkBoxCaption <> '') then
  begin
    if (formDialog.chkCheckBox.Checked) then
      result := modalResult + DISABLE_NOTIF
    else
      result := modalResult;
  end
  else
    result := modalResult;
  NeedInput := false;
end;

procedure CloseDialog(resultType: longint);
begin
  if LastDialog <> nil then
  begin
    LastDialog.ModalResult := resultType;
    //LastDialog.Close;
    //LastDialog.Close;
  end;
  NeedInput := false;
end;

{ TFormUserDialog }

procedure TFormUserDialog.FormCreate(Sender: TObject);
begin
  inherited;
  //Windows
  {$ifdef Win64}
  SetFont(self, 'Tahoma');
  {$endif}
    //MacOS
  {$ifdef Darwin}
  SetFont(self, 'Helvetica');
  {$endif}
end;

procedure TFormUserDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i:integer;
begin
  if (key = VK_RETURN) then
  begin
    for i:= 0 to Length(aButtons) - 1 do
    begin
      if (aButtons[i].OnClick = @btnOkClick) then
        btnOkClick(self)
      else if (aButtons[i].OnClick = @btnYesClick) then
        btnYesClick(self);
    end;
  end
  else if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
    //for i:= 0 to Length(aButtons) - 1 do
    //begin
    //  if (aButtons[i].OnClick = @btnCancelClick) then
    //    btnCancelClick(self)
    //  else if (aButtons[i].OnClick = @btnNoClick) then
    //    btnNoClick(self);
    //end;
  end;
end;

procedure TFormUserDialog.FormKeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TFormUserDialog.btnCloseClick(Sender: TObject);
begin
  //inherited;
  self.ModalResult := mrCancel;
end;

procedure TFormUserDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
    self := nil;
end;

procedure TFormUserDialog.lblCheckBoxClick(Sender: TObject);
begin
  chkCheckBox.Checked := not chkCheckBox.Checked;
end;

procedure TFormUserDialog.btnOkClick(Sender: TObject);
begin
  self.ModalResult := mrOK;
end;

procedure TFormUserDialog.btnYesClick(Sender: TObject);
begin
  self.ModalResult := mrYes;
end;

procedure TFormUserDialog.btnNoClick(Sender: TObject);
begin
  self.ModalResult := mrNo;
end;

procedure TFormUserDialog.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFormUserDialog.AddButton(btnCaption: String; btnType: TBitBtnKind;
  buttonTop: integer; btnWidth: integer; onBtnClick: TNotifyEvent);
var
  i, idx:integer;
  button: TColorSpeedButtonCS;
begin
  idx := Length(aButtons) + 1;
  button := TColorSpeedButtonCS.Create(self);
  button.Parent := self;
  button.Alignment := taCenter;
  button.StateNormal.Color := $00333333;
  button.StateNormal.BorderColor := $00191919;
  button.StateNormal.FontColor := clWhite;
  button.StateHover.Color := $004B4B4B;
  button.StateHover.BorderColor := $00262626;
  button.StateHover.FontColor := clWhite;
  button.StateDisabled.Color := $00333333;
  button.StateDisabled.BorderColor := $00191919;
  button.StateDisabled.FontColor := clWhite;
  button.StateActive.Color := $004B4B4B;
  button.StateActive.BorderColor := $00333333;
  button.StateActive.FontColor := clWhite;
  button.Font.Color := clWhite;
  button.Font.Style := [fsBold];
  button.Font.Size := 10;
  button.Caption := btnCaption;

  //button.Kind := btnType;
  button.Name := 'btn' + IntToStr(idx);
  button.Height := 32;
  button.Width := btnWidth;
  button.ParentFont := false;
  //button.Font.Color := clDefault;
  button.Top := buttonTop;
  if (onBtnClick <> nil) then
    button.OnClick := onBtnClick
  else if (btnType = bkOK) then
    button.OnClick := @btnOkClick
  else if (btnType = bkYes) then
    button.OnClick := @btnYesClick
  else if (btnType = bkNo) then
    button.OnClick := @btnNoClick
  else if (btnType = bkCancel) then
    button.OnClick := @btnCancelClick;

  SetLength(aButtons, idx);
  aButtons[idx - 1] := button;

  for i := 0 to idx - 1 do
  begin
    aButtons[i].Left := self.Width - ((idx - i) * btnWidth) - (10 * (idx - i));
  end;
end;

end.

