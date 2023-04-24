unit u_form_select_macro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const, UserDialog, lcltype,
  u_keys, u_common_ui, u_key_service, ColorSpeedButtonCS, LineObj, menus, Grids;

type

  { TFormSelectMacro }

  TFormSelectMacro = class(TBaseForm)
    btnAccept: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    gridMacros: TStringGrid;
    imgListTiming: TImageList;
    procedure btnAcceptClick(Sender: TObject);
    procedure btnAcceptMouseLeave(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseLeave(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure gridMacrosSelection(Sender: TObject; aCol, aRow: Integer);
  private
    procedure FillMacros;

  public
    selectedRow: integer;
  end;

var
  FormSelectMacro: TFormSelectMacro;
  function ShowSelectMacro(title: string; aKeyService: TKeyService; backColor: TColor; fontColor: TColor; activeColor: TColor): integer;

const
  ColTrigger = 1;
  ColCoTrigger = 2;
  ColMacro = 3;

implementation

{$R *.lfm}

function ShowSelectMacro(title: string; aKeyService: TKeyService; backColor: TColor; fontColor: TColor; activeColor: TColor): integer;
var
  i: integer;
begin
  result := -1;

  if FormSelectMacro <> nil then
    FreeAndNil(FormSelectMacro);
  Application.CreateForm(TFormSelectMacro, FormSelectMacro);

  FormSelectMacro.lblTitle.Caption := title;

  //Loads colors
  FormSelectMacro.Color := backColor;
  FormSelectMacro.Font.Color := fontColor;
  FormSelectMacro.lblTitle.Font.Color := fontColor;
  FormSelectMacro.gridMacros.Color := backColor;
  FormSelectMacro.gridMacros.FixedColor := backColor;
  FormSelectMacro.gridMacros.Font.Color := fontColor;
  for i := 0 to FormSelectMacro.gridMacros.Columns.Count - 1 do
  begin
    FormSelectMacro.gridMacros.Columns[i].Color := backColor;
    FormSelectMacro.gridMacros.Columns[i].Font.Color := fontColor;
    FormSelectMacro.gridMacros.Columns[i].Title.Color := backColor;
    FormSelectMacro.gridMacros.Columns[i].Title.Font.Color := fontColor;
  end;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormSelectMacro.btnCancel, FormSelectMacro.imgListTiming, 4);
    LoadButtonImage(FormSelectMacro.btnAccept, FormSelectMacro.imgListTiming, 6);
  end;

  FormSelectMacro.FillMacros;
  if (FormSelectMacro.ShowModal = mrOK) then
  begin
    result := TKeyList(keyService.Macros[FormSelectMacro.selectedRow - 1]).TriggerKey;
  end;
  FormSelectMacro := nil;
end;

{ TFormSelectMacro }

procedure TFormSelectMacro.FormCreate(Sender: TObject);
begin
  inherited;
  selectedRow := gridMacros.Row;
end;

procedure TFormSelectMacro.FillMacros;
var
  macro: TKeyList;
  macroIdx: integer;
  aKey: TKey;
  aKeysPos: TKeysPos;
begin
  gridMacros.RowCount := keyService.Macros.Count + 1;
  for macroIdx := 0 to keyService.Macros.Count - 1 do
  begin
    macro := TKeyList(keyService.Macros[macroIdx]);
    aKey := keyService.GetKeyConfig(macro.TriggerKey);

    gridMacros.Cells[ColTrigger, macroIdx + 1] := aKey.OtherDisplayText;
    gridMacros.Cells[ColCoTrigger, macroIdx + 1] := keyService.GetCoTriggerText(macro);
    gridMacros.Cells[ColMacro, macroIdx + 1] := keyService.GetMacroText(macro, aKeysPos);
  end;
end;

procedure TFormSelectMacro.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 4)
  else
    LoadButtonImage(sender, imgListTiming, 0);
end;

procedure TFormSelectMacro.btnAcceptClick(Sender: TObject);
begin
  if (selectedRow >= 1) then
    ModalResult := mrOK
  else
    ShowDialog('Macro', 'You must select a macro', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 6)
  else
    LoadButtonImage(sender, imgListTiming, 2);
end;

procedure TFormSelectMacro.btnAcceptMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 6)
    else
      LoadButtonImage(sender, imgListTiming, 2);
  end;
end;

procedure TFormSelectMacro.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 7)
  else
    LoadButtonImage(sender, imgListTiming, 3);
end;

procedure TFormSelectMacro.btnCancelMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgListTiming, 4)
    else
      LoadButtonImage(sender, imgListTiming, 0);
  end;
end;

procedure TFormSelectMacro.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgListTiming, 5)
  else
    LoadButtonImage(sender, imgListTiming, 1);
end;

procedure TFormSelectMacro.gridMacrosSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  selectedRow := aRow;
end;

end.

