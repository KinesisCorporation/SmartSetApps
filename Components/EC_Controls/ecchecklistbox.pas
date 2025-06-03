{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)

  Copyright (C) 2015-2020 Vojtěch Čihák, Czech Republic

  This library is free software; you can redistribute it and/or modify it under the terms of the
  GNU Library General Public License as published by the Free Software Foundation; either version
  2 of the License, or (at your option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you permission to link this
  library with independent modules to produce an executable, regardless of the license terms of
  these independent modules,and to copy and distribute the resulting executable under terms of
  your choice, provided that you also meet, for each linked independent module, the terms and
  conditions of the license of that module. An independent module is a module which is not derived
  from or based on this library. If you modify this library, you may extend this exception to your
  version of the library, but you are not obligated to do so. If you do not wish to do so, delete
  this exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
  the GNU Library General Public License for more details.

  You should have received a copy of the GNU Library General Public License along with this
  library; if not, write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.

**************************************************************************************************}

unit ECCheckListBox;
{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Graphics, LCLType, LMessages, Themes, Types, ECTypes;

type
  TOnItemClickEvent = procedure(Sender: TObject; AColumn, AIndex: Integer) of object;
  TOnGetImageIndex = procedure(Sender: TObject; AColumn, AIndex: Integer;            { -1 .. Themed checkbox }
                       AState: TCheckBoxState; var AImageIndex: Integer) of object;  { -2 .. no image }

  { TCustomECCheckListBox }
  TCustomECCheckListBox = class(TCustomListBox)
  private
    FAlignment: TLeftRight;
    FAllowGrayed: Boolean;
    FAutoHorCenterItems: Boolean;
    FAutosizeItemHeight: Boolean;
    FCheckColumns: SmallInt;
    FGrid: Boolean;
    FHovered: TPoint;
    FImages: TImageList;
    FImgIdxChecked: Integer;
    FImgIdxGrayed: Integer;
    FImgIdxUnchecked: Integer;
    FIndent: SmallInt;
    FOnGetImageIndex: TOnGetImageIndex;
    FOnItemClick: TOnItemClickEvent;
    FSpacing: SmallInt;
    FStates: array of array of TCheckBoxState;
    FTextAlign: TAlignment;
    function GetChecked(AColumn: Integer; AIndex: Integer): Boolean;
    function GetState(AColumn: Integer; AIndex: Integer): TCheckBoxState;
    function IsItemHeightStored: Boolean;
    procedure SetAlignment(AValue: TLeftRight);
    procedure SetAutoHorCenterItems(AValue: Boolean);
    procedure SetAutosizeItemHeight(AValue: Boolean);
    procedure SetCheckColumns(AValue: SmallInt);
    procedure SetChecked(AColumn: Integer; AIndex: Integer; AValue: Boolean);
    procedure SetGrid(AValue: Boolean);
    procedure SetHovered(AValue: TPoint);
    procedure SetImages(AValue: TImageList);
    procedure SetImgIdxChecked(AValue: Integer);
    procedure SetImgIdxGrayed(AValue: Integer);
    procedure SetImgIdxUnchecked(AValue: Integer);
    procedure SetIndent(AValue: SmallInt);
    procedure SetSpacing(AValue: SmallInt);
    procedure SetState(AColumn: Integer; AIndex: Integer; AValue: TCheckBoxState);
    procedure SetTextAlign(AValue: TAlignment);
  protected const
    cDefCheckColumns = 2;
    cDefIndent = 2;
    cDefSpacing = 28;
  protected
    FBorder: SmallInt;
    FCheckArea: Integer;
    FCheckSize: TSize;
    FFlags: Cardinal;
    FGlyphWidth: SmallInt;
    FItemClickEvent: Boolean;
    FNeedMeasure: Boolean;
    FPrefItemHeight: SmallInt;
    FRightToLeft: Boolean;
    FTextHeight: SmallInt;
    procedure AllocateStates(OldChClmns, NewChClmns, OldRows, NewRows: Integer);
    procedure CalcItemHeight;
    procedure CalcTextHeight;
    procedure CMBiDiModeChanged(var Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState); override;
    procedure FontChanged(Sender: TObject); override;
    procedure InitializeWnd; override;
    procedure ItemsChanged(Sender: TObject);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure RecalcInvalidate;
    procedure SetBorderStyle(NewStyle: TBorderStyle); override;
    procedure SetItems(Value: TStrings); override;
    procedure WMSize(var {%H-}Message: TLMSize); message LM_SIZE;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure AddItem(const Item: string; AnObject: TObject = nil); reintroduce;
    procedure AssignItems(AItems: TStrings);
    procedure CheckAll(AState: TCheckBoxState; AColumn: Integer);
    procedure Clear; override;
    procedure DeleteItem(AIndex: Integer);
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure InsertItem(AIndex: Integer; const AItem: string; AnObject: TObject = nil);
    procedure MeasureItem(Index: Integer; var TheHeight: Integer); override;
    procedure MoveItem(CurIndex, NewIndex: Integer);
    procedure Toggle(AColumn, AIndex: Integer);
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property AutoHorCenterItems: Boolean read FAutoHorCenterItems write SetAutoHorCenterItems default True;
    property AutosizeItemHeight: Boolean read FAutosizeItemHeight write SetAutosizeItemHeight default False;
    property CheckColumns: SmallInt read FCheckColumns write SetCheckColumns default cDefCheckColumns;
    property Checked[AColumn: Integer; AIndex: Integer]: Boolean read GetChecked write SetChecked;
    property Grid: Boolean read FGrid write SetGrid default False;
    property Hovered: TPoint read FHovered write SetHovered;
    property Images: TImageList read FImages write SetImages;
    property ImgIdxChecked: Integer read FImgIdxChecked write SetImgIdxChecked default -1;
    property ImgIdxGrayed: Integer read FImgIdxGrayed write SetImgIdxGrayed default -1;
    property ImgIdxUnchecked: Integer read FImgIdxUnchecked write SetImgIdxUnchecked default -1;
    property Indent: SmallInt read FIndent write SetIndent default cDefIndent;
    property Spacing: SmallInt read FSpacing write SetSpacing default cDefSpacing;
    property State[AColumn: Integer; AIndex: Integer]: TCheckBoxState read GetState write SetState;
    property TextAlign: TAlignment read FTextAlign write SetTextAlign default taLeftJustify;
    property OnGetImageIndex: TOnGetImageIndex read FOnGetImageIndex write FOnGetImageIndex;
    property OnItemClick: TOnItemClickEvent read FOnItemClick write FOnItemClick;
  end;

  { TECCheckListBox }
  TECCheckListBox = class(TCustomECCheckListBox)
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property AutoHorCenterItems;
    property AutosizeItemHeight;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property CheckColumns;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Grid;
    property Images;
    property ImgIdxChecked;
    property ImgIdxGrayed;
    property ImgIdxUnchecked;
    property Indent;
    property ItemHeight stored IsItemHeightStored;
    property Items;
    property ItemIndex;
    property MultiSelect;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property TextAlign;
    property TopIndex;
    property Visible;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDrawItem;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnItemClick;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnShowHint;
    property OnStartDrag;
    property OnUTF8KeyPress;
  end;

implementation

{ TCustomECCheckListBox }

constructor TCustomECCheckListBox.Create(TheOwner: TComponent);
var aDetails: TThemedElementDetails;
begin
  inherited Create(TheOwner);
  FAutoHorCenterItems:=True;
  FCheckColumns:=cDefCheckColumns;
  FHovered:=Point(-1, -1);
  FImgIdxChecked:=-1;
  FImgIdxGrayed:=-1;
  FImgIdxUnchecked:=-1;
  FIndent:=cDefIndent;
  FSpacing:=cDefSpacing;
  MultiSelect:=False;
  SetLength(FStates, cDefCheckColumns, 0);
  Style:=lbOwnerDrawVariable;  { because of Win32 - it doesn't like lbOwnerDrawFixed }
  FNeedMeasure:=True;
  aDetails:=ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal);
  FCheckSize:=ThemeServices.GetDetailSize(aDetails);
  AccessibleRole:=larListBox;
  TStringList(Items).OnChange:=@ItemsChanged;
end;

procedure TCustomECCheckListBox.AddItem(const Item: string; AnObject: TObject);
begin
  AllocateStates(CheckColumns, CheckColumns, Items.Count, Items.Count+1);
  inherited AddItem(Item, AnObject);
end;

procedure TCustomECCheckListBox.AllocateStates(OldChClmns, NewChClmns, OldRows, NewRows: Integer);
var i, j: Integer;
begin
  SetLength(FStates, NewChClmns, NewRows);
  for i:=OldChClmns to NewChClmns-1 do
    for j:=OldRows to NewRows-1 do
      FStates[i, j]:=cbUnchecked;
end;

procedure TCustomECCheckListBox.AssignItems(AItems: TStrings);
begin
  AllocateStates(0, CheckColumns, 0, AItems.Count);
  Items.Assign(AItems);
end;

procedure TCustomECCheckListBox.CalcItemHeight;
var aItemHeight: SmallInt;
begin
  if csLoading in ComponentState then exit;  { Exit! }
  CalcTextHeight;
  if not assigned(Images)
    then aItemHeight:=FCheckSize.cy
    else aItemHeight:=Images.Height;
  inc(aItemHeight, 5);
  if FTextHeight>aItemHeight then aItemHeight:=FTextHeight;
  FPrefItemHeight:=aItemHeight;
  ItemHeight:=aItemHeight;
end;

procedure TCustomECCheckListBox.CalcTextHeight;
var aBMP: TBitmap;
begin
  aBMP:=TBitmap.Create;
  aBMP.Canvas.Font.Assign(Font);
  FTextHeight:=aBMP.Canvas.TextHeight('ŠjÁÇ');
  FreeAndNil(aBMP);
end;

procedure TCustomECCheckListBox.CheckAll(AState: TCheckBoxState; AColumn: Integer);
var j: Integer;
begin
  for j:=0 to Items.Count-1 do
    FStates[AColumn, j]:=AState;
  Invalidate;
end;

procedure TCustomECCheckListBox.Clear;
begin
  Items.BeginUpdate;
  inherited Clear;
  SetLength(FStates, CheckColumns, 0);
  Items.EndUpdate;
end;

procedure TCustomECCheckListBox.CMBiDiModeChanged(var Message: TLMessage);
begin
  inherited CMBiDiModeChanged(Message);
  FRightToLeft:=IsRightToLeft;
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.DeleteItem(AIndex: Integer);
var i, j, aOldCount: Integer;
begin
  aOldCount:=Items.Count;
  for j:=AIndex+1 to aOldCount-1 do
    for i:=0 to CheckColumns-1 do
      FStates[i, j-1]:=FStates[i, j];
  SetLength(FStates, CheckColumns, aOldCount-1);
  Items.Delete(AIndex);
end;

procedure TCustomECCheckListBox.DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState);
                           { Enabled, State, Highlighted }
const caCheckThemes: array[Boolean, TCheckBoxState, Boolean] of TThemedButton =
        (((tbCheckBoxUncheckedDisabled, tbCheckBoxUncheckedDisabled),  { disabled, unchecked }
          (tbCheckBoxCheckedDisabled, tbCheckBoxCheckedDisabled),      { disabled, checked }
          (tbCheckBoxMixedDisabled, tbCheckBoxMixedDisabled)),         { disabled, grayed }
         ((tbCheckBoxUncheckedNormal, tbCheckBoxUncheckedHot),         { enabled, unchecked }
          (tbCheckBoxCheckedNormal, tbCheckBoxCheckedHot),             { enabled, checked }
 {normal} (tbCheckBoxMixedNormal, tbCheckBoxMixedHot))); {highlighted} { enabled, grayed }
      cPadding = 2;
var aDetails: TThemedElementDetails;
    bEnabled, bRightToLeft: Boolean;
    aFlags: Cardinal;
    aGlyphWidth: SmallInt;
    anyRect: TRect;
    aState: TCheckBoxState;
    i, aHovered, aImgIdx, aLeft: Integer;
begin  { do not call inherited ! }
  bEnabled:=IsEnabled;
  if odSelected in State then
    if not Focused then
      Canvas.Brush.Color:=GetMergedColor(Canvas.Brush.Color, GetColorResolvingDefault(Color, Brush.Color), 0.6);
  if not bEnabled then Canvas.Brush.Color:=GetMonochromaticColor(Canvas.Brush.Color);
  Canvas.FillRect(ARect);
  bRightToLeft:=(FRightToLeft xor (Alignment=taRightJustify));
  if not assigned(Images) then
    begin
      aGlyphWidth:=FCheckSize.cx;
      anyRect.Top:=(ARect.Bottom+ARect.Top-FCheckSize.cy) div 2;
      anyRect.Bottom:=anyRect.Top+FCheckSize.cy;
    end else
    begin
      aGlyphWidth:=Images.Width;
      anyRect.Top:=(ARect.Bottom+ARect.Top-Images.Height) div 2;
      anyRect.Bottom:=anyRect.Top+Images.Height;
    end;
  aLeft:=ARect.Right-(CheckColumns-1)*Spacing;
  if not AutoHorCenterItems
    then dec(aLeft, aGlyphWidth+Indent)
    else dec(aLeft, (Spacing+aGlyphWidth) div 2);
  if FNeedMeasure then
    begin
      if not FRightToLeft then
        begin
          if Alignment=taLeftJustify
            then FCheckArea:=aLeft+FBorder-(Spacing-aGlyphWidth) div 2
            else FCheckArea:=ClientRect.Right+FBorder-aLeft+(Spacing-aGlyphWidth) div 2;
        end else
        begin
          if Alignment=taLeftJustify
            then FCheckArea:=ClientRect.Right+(Width-FBorder-ClientWidth)-aLeft+(Spacing-aGlyphWidth) div 2
            else FCheckArea:=aLeft+(Width-FBorder-ClientWidth)-(Spacing-aGlyphWidth) div 2;
        end;
      aFlags:=DT_END_ELLIPSIS or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or caDTRTLFlags[FRightToLeft];
      case TextAlign of
        taLeftJustify:  if bRightToLeft then aFlags:=aFlags or DT_RIGHT;
        taRightJustify: if not bRightToLeft then aFlags:=aFlags or DT_RIGHT;
        taCenter:       aFlags:=aFlags or DT_CENTER;
      end;
      FFlags:=aFlags;
      FGlyphWidth:=aGlyphWidth;
      FNeedMeasure:=False;
    end;
  if Grid then
    begin
      Canvas.Pen.Color:=clBtnShadow;
      Canvas.Pen.Style:=psDot;
      Canvas.Line(0, ARect.Bottom-1, ARect.Right, ARect.Bottom-1);
      if not bRightToLeft then
        begin
          Canvas.MoveTo(aLeft-(Spacing-aGlyphWidth) div 2 -1, ARect.Top);
          Canvas.LineTo(Canvas.PenPos.X, ARect.Bottom);
        end;
    end;
  if Index=Hovered.Y
    then aHovered:=Hovered.X
    else aHovered:=-1;
  for i:=0 to CheckColumns-1 do
    begin
      if not (csDesigning in ComponentState)
        then aState:=FStates[i, Index]
        else aState:=cbUnchecked;
      aDetails:=ThemeServices.GetElementDetails(caCheckThemes[bEnabled, aState, aHovered=i]);
      if not bRightToLeft
        then anyRect.Left:=aLeft+i*Spacing
        else anyRect.Left:=ARect.Right-ARect.Left-aLeft-i*Spacing-aGlyphWidth;
      anyRect.Right:=anyRect.Left+aGlyphWidth;
      aImgIdx:=-1;
      if assigned(Images) then
        case aState of
          cbUnchecked: aImgIdx:=ImgIdxUnchecked;
          cbChecked:   aImgIdx:=ImgIdxChecked;
          cbGrayed:    aImgIdx:=ImgIdxGrayed;
        end;
      if assigned(OnGetImageIndex) then OnGetImageIndex(self, i, Index, aState, aImgIdx);
      if aImgIdx=-1
        then ThemeServices.DrawElement(Canvas.Handle, aDetails, anyRect)
        else if aImgIdx>=0 then ThemeServices.DrawIcon(Canvas, aDetails, anyRect.TopLeft, Images, aImgIdx);
      if Grid and (bRightToLeft or (i<(CheckColumns-1))) then
        begin
          Canvas.MoveTo(anyRect.Left+(Spacing+aGlyphWidth) div 2, ARect.Top);
          Canvas.LineTo(Canvas.PenPos.X, ARect.Bottom);
        end;
    end;
  Canvas.Brush.Style:=bsClear;
  if not (odSelected in State)
    then Canvas.Font.Color:=GetColorResolvingDefault(Font.Color, clWindowText)
    else Canvas.Font.Color:=clHighlightText;
  aLeft:=aLeft-cPadding-Spacing div 2;
  if not bRightToLeft then
    begin
      anyRect.Left:=ARect.Left+cPadding;
      anyRect.Right:=aLeft;
    end else
    begin
      anyRect.Right:=ARect.Right-cPadding;
      anyRect.Left:=ARect.Right-aLeft;
    end;
  anyRect.Top:=(ARect.Top+ARect.Bottom-FTextHeight) div 2;
  anyRect.Bottom:=anyRect.Top+FTextHeight;
  aDetails:=ThemeServices.GetElementDetails(caCheckThemes[bEnabled, cbUnchecked, False]);
  ThemeServices.DrawText(Canvas, aDetails, Items[Index], anyRect, FFlags, 0);
end;

procedure TCustomECCheckListBox.ExchangeItems(Index1, Index2: Integer);
var aState: TCheckBoxState;
    i: Integer;
begin
  Items.Exchange(Index1, Index2);
  for i:=0 to CheckColumns-1 do
    begin
      aState:=FStates[i, Index2];
      FStates[i, Index2]:=FStates[i, Index1];
      FStates[i, Index1]:=aState;
    end;
end;

procedure TCustomECCheckListBox.FontChanged(Sender: TObject);
begin
  Canvas.Font.Assign(Font);
  inherited FontChanged(Sender);
  FNeedMeasure:=True;
  if AutosizeItemHeight
    then CalcItemHeight
    else CalcTextHeight;
end;

procedure TCustomECCheckListBox.InitializeWnd;
begin
  inherited InitializeWnd;
  CalcTextHeight;
  FBorder:=(Width-ClientWidth) div 2;
  FNeedMeasure:=True;
end;

procedure TCustomECCheckListBox.InsertItem(AIndex: Integer; const AItem: string; AnObject: TObject);
var i, j: Integer;
begin
  AllocateStates(CheckColumns, CheckColumns, Items.Count, Items.Count+1);
  for i:=0 to CheckColumns-1 do
    for j:=Items.Count downto AIndex+1 do
      FStates[i, j]:=FStates[i, j-1];
  for i:=0 to CheckColumns-1 do
    FStates[i, AIndex]:=cbUnchecked;
  Items.Insert(AIndex, AItem);
  Items.Objects[AIndex]:=AnObject;
end;

procedure TCustomECCheckListBox.ItemsChanged(Sender: TObject);
var aItemsCnt, aStatesCnt: Integer;
begin
  aItemsCnt:=Items.Count;
  aStatesCnt:=length(FStates[0]);
  if aItemsCnt>aStatesCnt
    then AllocateStates(CheckColumns, CheckColumns, length(FStates[0]), Items.Count)
    else if aItemsCnt<aStatesCnt then SetLength(FStates, CheckColumns, aItemsCnt);
end;

procedure TCustomECCheckListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Shift*[ssShift, ssAlt, ssCtrl, ssMeta]=[]) and (CheckColumns>0) and (ItemIndex>=0) then
    case Key of
      VK_SPACE:   Toggle(0, ItemIndex);
      VK_1..VK_9: if (Key-VK_1)<CheckColumns then
                    begin
                      Toggle(Key-VK_1, ItemIndex);
                      Key:=0;
                    end;
    end;
end;

procedure TCustomECCheckListBox.Loaded;
begin
  inherited Loaded;
  AllocateStates(0, CheckColumns, 0, Items.Count);
  if AutosizeItemHeight then CalcItemHeight;
end;

procedure TCustomECCheckListBox.MeasureItem(Index: Integer; var TheHeight: Integer);
begin
  if AutosizeItemHeight then TheHeight:=FPrefItemHeight;
  inherited MeasureItem(Index, TheHeight);
end;

procedure TCustomECCheckListBox.MouseLeave;
begin
  inherited MouseLeave;
  Hovered:=Point(-1, -1);
end;

procedure TCustomECCheckListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var aRow, aClmnsM1, i, aLimit: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  aRow:=GetIndexAtY(Y);
  i:=-1;
  if aRow>=0 then
    begin
      aClmnsM1:=CheckColumns-1;
      if aClmnsM1>=0 then
        begin
          aLimit:=FCheckArea;
          if not (FRightToLeft xor (Alignment=taRightJustify))
            then while (X>=aLimit) and (i<aClmnsM1) do
                   begin
                     inc(aLimit, Spacing);
                     inc(i);
                   end
            else while (X<aLimit) and (i<aClmnsM1) do
                   begin
                     dec(aLimit, Spacing);
                     inc(i);
                   end;
        end;
    end;
  Hovered:=Point(i, aRow);
end;

procedure TCustomECCheckListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button=mbLeft) and (Hovered.X>=0) and (Hovered.Y>=0) then Toggle(Hovered.X, Hovered.Y);
end;

procedure TCustomECCheckListBox.RecalcInvalidate;
begin
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.MoveItem(CurIndex, NewIndex: Integer);
var arStates: array of TCheckBoxState;
    i, j: Integer;
begin
  Items.Move(CurIndex, NewIndex);
  SetLength(arStates, CheckColumns);
  for i:=0 to CheckColumns-1 do
    arStates[i]:=FStates[i, CurIndex];
  if CurIndex<NewIndex
    then  for j:=CurIndex to NewIndex-1 do
            for i:=0 to CheckColumns-1 do
              FStates[i, j]:=FStates[i, j+1]
    else  for j:=CurIndex downto NewIndex+1 do
            for i:=0 to CheckColumns-1 do
              FStates[i, j]:=FStates[i, j-1];
  for i:=0 to CheckColumns-1 do
    FStates[i, NewIndex]:=arStates[i];
end;

procedure TCustomECCheckListBox.SetBorderStyle(NewStyle: TBorderStyle);
begin
  if NewStyle=bsNone
    then FBorder:=0
    else FBorder:=(Width-ClientWidth) div 2;
  inherited SetBorderStyle(NewStyle);
end;

procedure TCustomECCheckListBox.SetItems(Value: TStrings);
begin
  AllocateStates(0, CheckColumns, 0, Value.Count);
  inherited SetItems(Value);
end;

procedure TCustomECCheckListBox.Toggle(AColumn, AIndex: Integer);
const caNewStateMap: array[TCheckBoxState, Boolean] of TCheckBoxState =
        ((cbChecked, cbGrayed), (cbUnChecked, cbUnChecked), (cbChecked, cbChecked));
begin          { cbUnchecked, cbChecked, cbGrayed; AllowGrayed }
  FItemClickEvent:=True;
  State[AColumn, AIndex]:=caNewStateMap[FStates[AColumn, AIndex], AllowGrayed];
  FItemClickEvent:=False;
end;

procedure TCustomECCheckListBox.WMSize(var Message: TLMSize);
begin
  inherited WMSize(Message);
  FNeedMeasure:=True;
end;

{ Setters }

function TCustomECCheckListBox.GetChecked(AColumn: Integer; AIndex: Integer): Boolean;
begin
  Result:=(FStates[AColumn, AIndex]=cbChecked);
end;

function TCustomECCheckListBox.GetState(AColumn: Integer; AIndex: Integer): TCheckBoxState;
begin
  Result:=FStates[AColumn, AIndex];
end;

function TCustomECCheckListBox.IsItemHeightStored: Boolean;
begin
  Result:=not AutosizeItemHeight;
end;

procedure TCustomECCheckListBox.SetAlignment(AValue: TLeftRight);
begin
  if FAlignment=AValue then exit;
  FAlignment:=AValue;
  RecalcInvalidate;
end;

procedure TCustomECCheckListBox.SetAutoHorCenterItems(AValue: Boolean);
begin
  if FAutoHorCenterItems=AValue then exit;
  FAutoHorCenterItems:=AValue;
  RecalcInvalidate;
end;

procedure TCustomECCheckListBox.SetAutosizeItemHeight(AValue: Boolean);
begin
  if FAutosizeItemHeight=AValue then exit;
  FAutosizeItemHeight:=AValue;
  if AValue then
    begin
      FNeedMeasure:=True;
      CalcItemHeight;
    end;
end;

procedure TCustomECCheckListBox.SetChecked(AColumn: Integer; AIndex: Integer; AValue: Boolean);
begin
  if not AValue
    then State[AColumn, AIndex]:=cbUnchecked
    else State[AColumn, AIndex]:=cbChecked;
end;

procedure TCustomECCheckListBox.SetCheckColumns(AValue: SmallInt);
begin
  if FCheckColumns=AValue then exit;
  AllocateStates(CheckColumns, AValue, Items.Count, Items.Count);
  FCheckColumns:=AValue;
  RecalcInvalidate;
end;

procedure TCustomECCheckListBox.SetGrid(AValue: Boolean);
begin
  if FGrid=AValue then exit;
  FGrid:=AValue;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetHovered(AValue: TPoint);
begin
  if (FHovered.X<>AValue.X) or (FHovered.Y<>AValue.Y) then
    begin
      FHovered:=AValue;
      Invalidate;
    end;
end;

procedure TCustomECCheckListBox.SetImages(AValue: TImageList);
begin
  if FImages=AValue then exit;
  FImages:=AValue;
  CalcItemHeight;
  RecalcInvalidate;
end;

procedure TCustomECCheckListBox.SetImgIdxChecked(AValue: Integer);
begin
  if FImgIdxChecked=AValue then exit;
  FImgIdxChecked:=AValue;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetImgIdxGrayed(AValue: Integer);
begin
  if FImgIdxGrayed=AValue then exit;
  FImgIdxGrayed:=AValue;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetImgIdxUnchecked(AValue: Integer);
begin
  if FImgIdxUnchecked=AValue then exit;
  FImgIdxUnchecked:=AValue;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetIndent(AValue: SmallInt);
begin
  if FIndent=AValue then exit;
  FIndent:=AValue;
  RecalcInvalidate;
end;

procedure TCustomECCheckListBox.SetSpacing(AValue: SmallInt);
begin
  if FSpacing=AValue then exit;
  FSpacing:=AValue;
  RecalcInvalidate;
end;

procedure TCustomECCheckListBox.SetState(AColumn: Integer; AIndex: Integer; AValue: TCheckBoxState);
begin
  FStates[AColumn, AIndex]:=AValue;
  if FItemClickEvent and assigned(FOnItemClick) then FOnItemClick(self, AColumn, AIndex);
  Invalidate;
end;

procedure TCustomECCheckListBox.SetTextAlign(AValue: TAlignment);
begin
  if FTextAlign=AValue then exit;
  FTextAlign:=AValue;
  RecalcInvalidate;
end;

end.


