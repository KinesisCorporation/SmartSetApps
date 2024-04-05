unit u_form_search_keys;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ListFilterEdit, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, u_base_form, u_const, UserDialog, lcltype,
  u_keys, u_common_ui, u_key_service, ColorSpeedButtonCS, LineObj, menus, Grids, Types;

type

  { TFormSearchKeys }

  TFormSearchKeys = class(TBaseForm)
    btnAccept: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    imgListTiming: TImageList;
    lblSearch: TLabel;
    lbKeys: TListBox;
    filterKeys: TListFilterEdit;
    procedure btnAcceptClick(Sender: TObject);
    procedure btnAcceptMouseLeave(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseLeave(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure lbKeysDblClick(Sender: TObject);
    procedure lbKeysDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
  private
    fontColor: TColor;
    activeColor: TColor;
    procedure FillKeys;
  public
  end;

var
  FormSearchKeys: TFormSearchKeys;
  function ShowSearchKeys(title: string; aKeyService: TKeyService; backColor: TColor; fontColor: TColor; activeColor: TColor): integer;

implementation

{$R *.lfm}


function ShowSearchKeys(title: string; aKeyService: TKeyService; backColor: TColor; fontColor: TColor; activeColor: TColor): integer;
var
  i: integer;
begin
  result := -1;

  if FormSearchKeys <> nil then
    FreeAndNil(FormSearchKeys);
  Application.CreateForm(TFormSearchKeys, FormSearchKeys);

  FormSearchKeys.lblTitle.Caption := title;

  //Loads colors
  FormSearchKeys.fontColor := fontColor;
  FormSearchKeys.activeColor := activeColor;
  FormSearchKeys.Color := backColor;
  FormSearchKeys.Font.Color := fontColor;
  FormSearchKeys.lblTitle.Font.Color := fontColor;
  FormSearchKeys.lblSearch.Font.Color := fontColor;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormSearchKeys.btnCancel, FormSearchKeys.imgListTiming, 4);
    LoadButtonImage(FormSearchKeys.btnAccept, FormSearchKeys.imgListTiming, 6);
  end;

  FormSearchKeys.FillKeys;
  if (FormSearchKeys.ShowModal = mrOK) then
  begin
    if (FormSearchKeys.lbKeys.ItemIndex >= 0) then
      result := TKey(FormSearchKeys.lbKeys.Items.Objects[FormSearchKeys.lbKeys.ItemIndex]).Key;
  end;
  FormSearchKeys := nil;
end;

{ TFormSearchKeys }

procedure TFormSearchKeys.FormCreate(Sender: TObject);
begin
  inherited;
end;

procedure TFormSearchKeys.lbKeysDblClick(Sender: TObject);
begin
  btnAccept.Click;
end;

procedure TFormSearchKeys.lbKeysDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    Font.Color := fontColor;
    if odSelected in State then
    begin
      Brush.Color := activeColor;
      Font.Color := clWhite;
    end;

    FillRect(ARect);
    TextOut(ARect.Left, ARect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TFormSearchKeys.FillKeys;
var
  i:integer;
  aKey: TKey;
  dispText, keyText: string;
begin
  for i := 0 to keyService.ConfigKeys.Count - 1 do
  begin
    aKey := keyService.ConfigKeys[i];

    if (aKey.SearchText <> SKIP_SEARCH) then
    begin
      dispText := StringReplace(aKey.DisplayText , #10,  ' ' ,[rfReplaceAll, rfIgnoreCase]);

      if (aKey.SearchText <> '') then
      begin
         keyText := aKey.SearchText;
         if (dispText <> aKey.SearchText) then
           keyText := keyText + '  ' + dispText;
      end
      else
         keyText := dispText;

      if (aKey.DisplayText <> aKey.SaveValue) then
        keyText := keyText + ' (' + aKey.SaveValue + ')';

      lbKeys.Items.AddObject(keyText, aKey);
    end;
  end;

  filterKeys.FilteredListbox := nil;
  filterKeys.FilteredListbox := lbKeys;
end;

procedure TFormSearchKeys.btnAcceptClick(Sender: TObject);
begin
  if (lbKeys.ItemIndex >= 0) then
    ModalResult := mrOK
  else
    ShowDialog('Key', 'You must select a key', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormSearchKeys.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 4)
  else
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormSearchKeys.btnCancelMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 4)
    else
      LoadButtonImage(sender, imgListTiming, 0);
  end;
end;

procedure TFormSearchKeys.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 5)
  else
    LoadButtonImage(sender, imgListTiming, 1);
end;

procedure TFormSearchKeys.btnAcceptMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 6)
    else
      LoadButtonImage(sender, imgListTiming, 2);
  end;
end;

procedure TFormSearchKeys.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 7)
  else
    LoadButtonImage(sender, imgListTiming, 3);
end;

end.

