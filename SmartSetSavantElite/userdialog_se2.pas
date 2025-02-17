unit UserDialog_SE2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, u_const_pedal;

type

  { TFormUserDialogSE2 }

  TFormUserDialogSE2 = class(TForm)
    ilDialog: TImageList;
    imgDialog: TImage;
    lblMessage: TLabel;
    pnlImage: TPanel;
    pnlBottom: TPanel;
    pnlClient: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    aButtons: array of TBitBtn;
    procedure AddButton(btnCaption: String; btnType: TBitBtnKind);
  public
    { public declarations }
  end;

var
  FormUserDialogSE2: TFormUserDialogSE2;
  function ShowDialog(Caption, Message: string; dlgType: TMsgDlgType; dlgButtons: TMsgDlgButtons): integer;

implementation

{$R *.lfm}

//Function to call a dialog box
function ShowDialog(Caption, Message: string; dlgType: TMsgDlgType; dlgButtons: TMsgDlgButtons): integer;
const
  WARNING_ICON = 0;
  ERROR_ICON = 1;
  INFO_ICON = 2;
  CONFIRM_ICON = 3;
begin
  //Close the dialog if opened
  if FormUserDialogSE2 <> nil then
    FreeAndNil(FormUserDialogSE2);

  //Creates the dialog form
  Application.CreateForm(TFormUserDialogSE2, FormUserDialogSE2);

  //Loads Caption text
  FormUserDialogSE2.Caption := Caption;
  FormUserDialogSE2.lblMessage.Caption := Message;

  if (IsDarkTheme) then
  begin;
    FormUserDialogSE2.Font.Color := clWhite;
    FormUserDialogSE2.lblMessage.Font.Color := clWhite;
    FormUserDialogSE2.Color := KINESIS_DARK_GRAY_FS;
  end;

  //Loads the image for dialog type
  if dlgType in [mtConfirmation] then
    FormUserDialogSE2.ilDialog.GetBitmap(CONFIRM_ICON, FormUserDialogSE2.imgDialog.Picture.Bitmap)
  else if dlgType in [mtWarning] then
    FormUserDialogSE2.ilDialog.GetBitmap(WARNING_ICON, FormUserDialogSE2.imgDialog.Picture.Bitmap)
  else if dlgType in [mtError] then
    FormUserDialogSE2.ilDialog.GetBitmap(ERROR_ICON, FormUserDialogSE2.imgDialog.Picture.Bitmap)
  else if dlgType in [mtInformation] then
    FormUserDialogSE2.ilDialog.GetBitmap(INFO_ICON, FormUserDialogSE2.imgDialog.Picture.Bitmap)
  else
    FormUserDialogSE2.ilDialog.GetBitmap(CONFIRM_ICON, FormUserDialogSE2.imgDialog.Picture.Bitmap);

  //Adds buttons according to options
  if mbYes in dlgButtons then
    FormUserDialogSE2.AddButton('Yes', bkYes);
  if mbNo in dlgButtons then
    FormUserDialogSE2.AddButton('No', bkNo);
  if mbOK in dlgButtons then
    FormUserDialogSE2.AddButton('OK', bkOK);
  if mbCancel in dlgButtons then
    FormUserDialogSE2.AddButton('Cancel', bkCancel);

  //Shows dialog and returns value
  result := FormUserDialogSE2.ShowModal;
end;

{ TFormUserDialogSE2 }

procedure TFormUserDialogSE2.FormCreate(Sender: TObject);
begin
    //Windows
  {$ifdef Win64}
  SetFont(self, 'Segoe UI');
  {$endif}
    //MacOS
  {$ifdef Darwin}
  SetFont(self, 'Helvetica');
  {$endif}
end;

procedure TFormUserDialogSE2.AddButton(btnCaption: String; btnType: TBitBtnKind);
var
  i, idx:integer;
  button: TBitBtn;
const
  btnWidth = 90;
begin
  idx := Length(aButtons) + 1;
  button := TBitBtn.Create(pnlBottom);
  button.Parent := pnlBottom;
  button.Caption := btnCaption;
  button.Kind := btnType;
  button.Name := 'btn' + IntToStr(idx);
  button.Width := btnWidth;
  button.ParentFont := false;
  button.Font.Color := clDefault;

  SetLength(aButtons, idx);
  aButtons[idx - 1] := button;

  for i := 0 to idx - 1 do
  begin
    aButtons[i].Left := pnlBottom.Width - ((idx - i) * btnWidth) - (10 * (idx - i));

  end;
end;

end.

