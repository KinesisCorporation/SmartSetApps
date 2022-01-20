unit InfoDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  u_const, u_common_ui, ColorSpeedButtonCS;

type

  { TFormInfoDialog }

  TFormInfoDialog = class(TForm)
    btnClose: TColorSpeedButtonCS;
    btnCloseLight: TColorSpeedButtonCS;
    lblMessage: TLabel;
    lblTitle: TLabel;
    tmrClose: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure tmrCloseTimer(Sender: TObject);
  private

  public

  end;

var
  FormInfoDialog: TFormInfoDialog;
  LastInfoDialog: TFormInfoDialog;
  procedure ShowInfoDialog(title: string; message: string; formPosition: TFormPosition = fpMiddle; timer: integer = 5);
  procedure CloseInfoDialog(resultType: longint);

implementation

//uses u_form_main_rgb;

{$R *.lfm}

procedure ShowInfoDialog(title: string; message: string; formPosition: TFormPosition = fpMiddle; timer: integer = 5);
var
  left: integer;
  top: integer;
  aRect: TRect;
  formDialog: TFormInfoDialog;
begin
  NeedInput := true;
  left := -1;
  top := -1;
  try
    //Creates the dialog form
    Application.CreateForm(TFormInfoDialog, formDialog);
    LastInfoDialog := formDialog;
    formDialog.lblTitle.Caption := title;
    formDialog.lblMessage.Caption := message;
    formDialog.tmrClose.Interval := timer * 1000;
    if (formPosition <> fpMiddle) then
    begin
      aRect := Screen.PrimaryMonitor.WorkareaRect;
      if (formPosition = fpBotRight) then
      begin
        left := aRect.Width - formDialog.Width;
        top := aRect.Height - formDialog.Height;
      end;
    end;

    //Loads colors
    if (GMasterAppId = APPL_MASTER_OFFICE) and not(IsDarkTheme) then
    begin
      formDialog.Color := clWhite;
      formDialog.Font.Color := clBlack;
      formDialog.lblTitle.Font.Color := clWhite;
      formDialog.lblMessage.Font.Color := clBlack;
      formDialog.btnClose.Visible := false;
      formDialog.btnCloseLight.Visible := true;
    end;

    formDialog.Show;
    if (left <> -1) and (top <> -1) then
    begin
      formDialog.Left := left;
      formDialog.Top := top;
    end;

    formDialog.tmrClose.Enabled := true;;
  finally
    NeedInput := false;
  end;
end;

procedure CloseInfoDialog(resultType: longint);
begin
  if LastInfoDialog <> nil then
  begin
    LastInfoDialog.ModalResult := resultType;
    LastInfoDialog.Close;
  end;
  NeedInput := false;
end;

{ TFormInfoDialog }

procedure TFormInfoDialog.tmrCloseTimer(Sender: TObject);
begin
  Close;
end;

procedure TFormInfoDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  //CloseAction := caFree;
  if CloseAction = caFree then
    self := nil;
end;

procedure TFormInfoDialog.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

