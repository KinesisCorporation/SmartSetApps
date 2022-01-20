unit u_form_multimodifiers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const, UserDialog, lcltype,
  u_keys, u_common_ui, u_base_key_service, ColorSpeedButtonCS, LineObj,
  u_key_layer;

type

  { TFormMultimodifiers }

  TFormMultimodifiers = class(TBaseForm)
    btnCancel: TColorSpeedButtonCS;
    btnAccept: TColorSpeedButtonCS;
    btnControl: TColorSpeedButtonCS;
    btnAlt: TColorSpeedButtonCS;
    btnShift: TColorSpeedButtonCS;
    btnWindows: TColorSpeedButtonCS;
    imgListTiming: TImageList;
    lblText: TLabel;
    procedure btnAcceptMouseExit(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseExit(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnAcceptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function Validate: boolean;
  public
    keyService: TBaseKeyService;
  end;

var
  FormMultimodifiers: TFormMultimodifiers;
  function ShowMultimodifiers(aKeyService: TBaseKeyService; aKbKey: TKBKey; backColor: TColor; fontColor: TColor): boolean;

implementation

{$R *.lfm}

function ShowMultimodifiers(aKeyService: TBaseKeyService; aKbKey: TKBKey; backColor: TColor; fontColor: TColor): boolean;
var
  multimodifiers: string;
begin
  result := false;
  //Close the dialog if opened
  if FormMultimodifiers <> nil then
    FreeAndNil(FormMultimodifiers);

  //Creates the dialog form
  Application.CreateForm(TFormMultimodifiers, FormMultimodifiers);

  //Loads colors
  FormMultimodifiers.Color := backColor;
  FormMultimodifiers.Font.Color := fontColor;
  FormMultimodifiers.lblTitle.Font.Color := fontColor;
  FormMultimodifiers.lblText.Font.Color := fontColor;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormMultimodifiers.btnCancel, FormMultimodifiers.imgListTiming, 4);
    LoadButtonImage(FormMultimodifiers.btnAccept, FormMultimodifiers.imgListTiming, 6);
  end;

  FormMultimodifiers.keyService := aKeyService;
  multimodifiers := aKbKey.Multimodifiers.ToLower;

  if (multimodifiers.Contains('c')) then
    FormMultimodifiers.btnControl.Down := true;
  if (multimodifiers.Contains('a')) then
    FormMultimodifiers.btnAlt.Down := true;
  if (multimodifiers.Contains('w')) then
    FormMultimodifiers.btnWindows.Down := true;
  if (multimodifiers.Contains('s')) then
    FormMultimodifiers.btnShift.Down := true;

  //Shows dialog and returns value
  if FormMultimodifiers.ShowModal = mrOK then
  begin
    result := true;
    multimodifiers := '';
    if (FormMultimodifiers.btnControl.Down) then
      multimodifiers := 'c'
    else
      multimodifiers := 'x';

    if (FormMultimodifiers.btnAlt.Down) then
      multimodifiers := multimodifiers + 'a'
    else
      multimodifiers := multimodifiers + 'x';

    if (FormMultimodifiers.btnWindows.Down) then
      multimodifiers := multimodifiers + 'w'
    else
      multimodifiers := multimodifiers + 'x';

    if (FormMultimodifiers.btnShift.Down) then
      multimodifiers := multimodifiers + 's'
    else
      multimodifiers := multimodifiers + 'x';

    aKbKey.Multimodifiers := multimodifiers;
  end;
end;

{ TFormMultimodifiers }

procedure TFormMultimodifiers.FormCreate(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := 'Multimodifiers';
end;

procedure TFormMultimodifiers.FormShow(Sender: TObject);
begin
  inherited;
end;

procedure TFormMultimodifiers.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 4)
  else
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormMultimodifiers.btnAcceptMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
  end;
end;

procedure TFormMultimodifiers.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 7)
  else
    LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormMultimodifiers.btnCancelMouseExit(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 4)
    else
      LoadButtonImage(sender, imgListTiming, 0);
  end;
end;

procedure TFormMultimodifiers.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 5)
  else
    LoadButtonImage(sender, imgListTiming, 1);
end;

function TFormMultimodifiers.Validate: boolean;
var
  countDown: integer;
begin
  result := false;
  countDown := 0;
  if (btnControl.Down) then
    inc(countDown);
  if (btnAlt.Down) then
    inc(countDown);
  if (btnWindows.Down) then
    inc(countDown);
  if (btnShift.Down) then
    inc(countDown);

  if (countDown = 1) then
    ShowDialog('Multimodifiers', 'Your must select at least 2 modifiers to create a multimodifier', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
  else
    result := true;
end;

procedure TFormMultimodifiers.btnAcceptClick(Sender: TObject);
begin
  if (Validate) then
    ModalResult := mrOK;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
end;


end.

