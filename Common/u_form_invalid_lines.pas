unit u_form_invalid_lines;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, u_base_form, u_const, UserDialog, lcltype, u_keys, u_common_ui,
  u_key_service, ColorSpeedButtonCS, LineObj, RichMemo, u_text_line;

type

  { TFormInvalidLines }

  TFormInvalidLines = class(TBaseForm)
    btnAccept: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    imgList: TImageList;
    lblInfo: TLabel;
    pnlItems: TPanel;
    scrollItems: TScrollBox;
    procedure btnAcceptClick(Sender: TObject);
    procedure btnAcceptMouseLeave(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseLeave(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlItemsClick(Sender: TObject);
    procedure chkBoxClick(Sender: TObject);
  private
    backColor: TColor;
    fontColor: TColor;
    activeColor: TColor;
    isLoading: boolean;
    procedure CheckItem(component: TComponent; id: integer);
    procedure FillList;
    procedure SetMemoTextColor(aMemo: TRichMemo; textLine: TTextLine);
    procedure SetStateLine(id: integer; checked: boolean);
  public
  end;

var
  FormInvalidLines: TFormInvalidLines;
  function ShowSelectInvalidLines(title: string; aKeyService: TKeyService; backColor: TColor; fontColor: TColor; activeColor: TColor): integer;


implementation

{$R *.lfm}

function ShowSelectInvalidLines(title: string; aKeyService: TKeyService; backColor: TColor; fontColor: TColor; activeColor: TColor): integer;
var
  i: integer;
begin
  result := -1;

  if FormInvalidLines <> nil then
    FreeAndNil(FormInvalidLines);
  Application.CreateForm(TFormInvalidLines, FormInvalidLines);

  FormInvalidLines.lblTitle.Caption := title;
  FormInvalidLines.backColor := backColor;
  FormInvalidLines.fontColor := fontColor;
  FormInvalidLines.activeColor := activeColor;

  //Loads colors
  FormInvalidLines.Color := backColor;
  FormInvalidLines.Font.Color := fontColor;
  FormInvalidLines.lblTitle.Font.Color := fontColor;
  FormInvalidLines.lblInfo.Font.Color := fontColor;
  //FormInvalidLines.checkList.Color := backColor;
  //FormInvalidLines.checkList.Font.Color := fontColor;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormInvalidLines.btnCancel, FormInvalidLines.imgList, 4);
    LoadButtonImage(FormInvalidLines.btnAccept, FormInvalidLines.imgList, 6);
  end;

  FormInvalidLines.FillList;

  if (FormInvalidLines.ShowModal = mrOK) then
  begin
    //result := TKeyList(keyService.Macros[FormInvalidLines.selectedRow - 1]).TriggerKey;
  end;
  FormInvalidLines := nil;
end;

{ TFormInvalidLines }

procedure TFormInvalidLines.FormCreate(Sender: TObject);
begin
  inherited;
end;

procedure TFormInvalidLines.FormShow(Sender: TObject);
var
  i, MaxWidth: Integer;
begin
  inherited;
  MaxWidth := -1;
  //for i := 0 to checkList.Items.Count - 1 do
  //  MaxWidth := Max(MaxWidth, checkList.Canvas.TextWidth(checkList.Items[i]));
  //// consider non-client area
  //if MaxWidth <> -1 then
  //  checkList.ScrollWidth := MaxWidth + checkList.Width - checkList.ClientWidth;
end;

procedure TFormInvalidLines.pnlItemsClick(Sender: TObject);
begin
  CheckItem(scrollItems, (Sender as TPanel).Tag);
end;

procedure TFormInvalidLines.chkBoxClick(Sender: TObject);
var
  chkBox: TCheckBox;
begin
  if (not isLoading) then
  begin
    chkBox := (Sender as TCheckBox);
    SetStateLine(chkBox.Tag, chkBox.Checked);
  end;
end;

procedure TFormInvalidLines.CheckItem(component: TComponent; id: integer);
var
  i:integer;
begin
  for i:= 0 to component.ComponentCount - 1 do
  begin
    if (component.Components[i] is TPanel) then
    begin
      CheckItem(component.Components[i], id);
    end;

    if (component.Components[i] is TCheckBox) then
    begin
      if ((component.Components[i] as TCheckBox).Tag = id) then
      begin
        (component.Components[i] as TCheckBox).Checked := not((component.Components[i] as TCheckBox).Checked);
      end;
    end;

  end;
end;

procedure TFormInvalidLines.SetStateLine(id: integer; checked: boolean);
var
  i:integer;
begin
  for i:= 0 to keyService.TextLines.Count - 1 do
  begin
    if (keyService.TextLines[i].Id = id) then
      keyService.TextLines[i].Keep := checked;
  end;
end;

procedure TFormInvalidLines.FillList;
var
  i:integer;
  chkBox: TCheckBox;
  memoMacro: TRichMemo;
  pnl: TPanel;
  idx: integer;
  line: TLineObj;
  textLine: TTextLine;
const
  itemHeight: integer = 50;
  checkWidth: integer = 40;
begin
  isLoading := true;
  try
    //checkList.Clear;
    idx := 0;
    for i := 0 to keyService.TextLines.Count - 1 do
    begin
      textLine := keyService.TextLines[i];
      if (textLine.IsValid or textLine.Removed) then
         continue;

      pnl := TPanel.Create(scrollItems);
      pnl.Parent := scrollItems;
      pnl.Height := itemHeight;
      //pnl.Align := alTop;
      pnl.Width := scrollItems.Width - scrollItems.VertScrollBar.Size;
      pnl.Top := ((itemHeight - 3) * idx);
      pnl.BorderStyle := bsSingle;
      pnl.BevelInner := bvLowered;
      pnl.BevelOuter := bvRaised;
      pnl.Tag := textLine.Id;
      pnl.OnClick := @pnlItemsClick;

      chkBox := TCheckBox.Create(pnl);
      chkBox.Parent := pnl;
      chkBox.Width := 20;
      chkBox.Left := (checkWidth - chkBox.Width) div 2;
      chkBox.Top := (pnl.Height - chkBox.Height) div 2; //(i * ((itemHeight div 2) + 2));
      chkBox.Tag := textLine.Id;
      chkBox.Checked := textLine.Keep;
      chkBox.OnClick := @chkBoxClick;

      line := TLineObj.Create(pnl);
      line.Parent := pnl;
      line.Left := checkWidth;
      line.Top := 0;
      line.Height := itemHeight;
      line.LineStyle:= psSolid;
      line.Direction:= drUpDown;
      line.LineWidth := 1;
      line.Width := 1;
      line.Color := clWhite;

      memoMacro := TRichMemo.Create(pnl);
      memoMacro.Parent := pnl;
      memoMacro.Height:= itemHeight - 12;
      memoMacro.Left := checkWidth + 5;
      memoMacro.Width := pnl.Width - memoMacro.Left - 10;//scrollItems.Width - memoMacro.Left - scrollItems.VertScrollBar.Size - 5;
      memoMacro.Top := 5;//(i * (itemHeight + 2));
      memoMacro.Font.Size := 10;
      //memoMacro.Text := textLine.LineText;
      SetMemoTextColor(memoMacro, textLine);
      memoMacro.ReadOnly := true;
      memoMacro.Color := backColor;
      memoMacro.Font.Color := fontColor;
      memoMacro.BorderStyle := bsNone;
      memoMacro.ScrollBars := TScrollStyle.ssAutoHorizontal;
      memoMacro.TabStop := false;
      memoMacro.WordWrap := false;
      memoMacro.Tag := textLine.Id;
  //
  //    memoMacro.Text := keyService.GetMacroText(activeMacro, aKeysPos);
  //
  //    //Replace empty space with special space character
  //    memoMacro.Text := StringReplace(memoMacro.Text, ' ', UnicodeString(#$e2#$90#$a3), [rfReplaceAll]);
  //    SetMemoTextColor(memoMacro, aKeysPos);

      //FormInvalidLines.checkList.Items.AddObject(keyService.InvalidLines[i].LineText, TObject(keyService.InvalidLines[i].LayerIdx));
      inc(idx);
    end;
  finally
    isLoading := false;
  end;

end;

procedure TFormInvalidLines.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 4)
  else
    LoadButtonImage(sender, imgList, 0);
end;

procedure TFormInvalidLines.btnAcceptClick(Sender: TObject);
begin
  //if (selectedRow >= 1) then
  //  ModalResult := mrOK
  //else
  //  ShowDialog('Macro', 'You must select a macro', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB);
  ModalResult := mrOK;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 6)
  else
    LoadButtonImage(sender, imgList, 2);
end;

procedure TFormInvalidLines.btnAcceptMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgList, 6)
    else
      LoadButtonImage(sender, imgList, 2);
  end;
end;

procedure TFormInvalidLines.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 7)
  else
    LoadButtonImage(sender, imgList, 3);
end;

procedure TFormInvalidLines.btnCancelMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgList, 4)
    else
      LoadButtonImage(sender, imgList, 0);
  end;
end;

procedure TFormInvalidLines.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 5)
  else
    LoadButtonImage(sender, imgList, 1);
end;

procedure TFormInvalidLines.SetMemoTextColor(aMemo: TRichMemo; textLine: TTextLine);
var
  i: integer;
  keyCount: integer;
  initLength: integer;
  mustAddKeyPos: boolean;
  lineText: string;
  lineSegment: TLineSegment;
  aKeysPos: TKeysPos;

  procedure AddKeyPos(iStart, iEnd: integer);
  begin
    SetLength(aKeysPos, Length(aKeysPos) + 1);
    aKeysPos[Length(aKeysPos) - 1].iStart := iStart;
    aKeysPos[Length(aKeysPos) - 1].iEnd := iEnd;
  end;
begin
  lineText := '';

  for i := 0 to textLine.Count - 1 do
  begin
    initLength := Length(lineText);
    lineSegment := textLine.Items[i];

    lineText := lineText + lineSegment.Text;
    if (not lineSegment.IsValid) then
       AddKeyPos(initLength, Length(lineText))
  end;

  aMemo.Text := lineText;

  //Reset to default color before setting red (MacOS bug)
  aMemo.SetRangeColor(0, Length(aMemo.Text), clDefault);

  if (aKeysPos <> nil) then
  begin
    for i := 0 to Length(aKeysPos) - 1 do
      aMemo.SetRangeColor(aKeysPos[i].iStart, aKeysPos[i].iEnd - aKeysPos[i].iStart, clRed);
  end;
end;


end.

