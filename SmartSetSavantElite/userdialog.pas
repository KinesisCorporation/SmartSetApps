unit UserDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, u_const;

type

  { TFormUserDialog }

  TFormUserDialog = class(TForm)
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
  FormUserDialog: TFormUserDialog;
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
  if FormUserDialog <> nil then
    FreeAndNil(FormUserDialog);

  //Creates the dialog form
  Application.CreateForm(TFormUserDialog, FormUserDialog);

  //Loads Caption text
  FormUserDialog.Caption := Caption;
  FormUserDialog.lblMessage.Caption := Message;

  if (IsDarkTheme) then
  begin;
    FormUserDialog.Font.Color := clWhite;
    FormUserDialog.lblMessage.Font.Color := clWhite;
    FormUserDialog.Color := KINESIS_DARK_GRAY_FS;
  end;

  //Loads the image for dialog type
  if dlgType in [mtConfirmation] then
    FormUserDialog.ilDialog.GetBitmap(CONFIRM_ICON, FormUserDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtWarning] then
    FormUserDialog.ilDialog.GetBitmap(WARNING_ICON, FormUserDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtError] then
    FormUserDialog.ilDialog.GetBitmap(ERROR_ICON, FormUserDialog.imgDialog.Picture.Bitmap)
  else if dlgType in [mtInformation] then
    FormUserDialog.ilDialog.GetBitmap(INFO_ICON, FormUserDialog.imgDialog.Picture.Bitmap)
  else
    FormUserDialog.ilDialog.GetBitmap(CONFIRM_ICON, FormUserDialog.imgDialog.Picture.Bitmap);

  //Adds buttons according to options
  if mbYes in dlgButtons then
    FormUserDialog.AddButton('Yes', bkYes);
  if mbNo in dlgButtons then
    FormUserDialog.AddButton('No', bkNo);
  if mbOK in dlgButtons then
    FormUserDialog.AddButton('OK', bkOK);
  if mbCancel in dlgButtons then
    FormUserDialog.AddButton('Cancel', bkCancel);

  //Shows dialog and returns value
  result := FormUserDialog.ShowModal;
end;

{ TFormUserDialog }

procedure TFormUserDialog.FormCreate(Sender: TObject);
begin
    //Windows
  {$ifdef Win32}
  SetFont(self, 'Segoe UI');
  {$endif}
    //MacOS
  {$ifdef Darwin}
  SetFont(self, 'Helvetica');
  {$endif}
end;

procedure TFormUserDialog.AddButton(btnCaption: String; btnType: TBitBtnKind);
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

