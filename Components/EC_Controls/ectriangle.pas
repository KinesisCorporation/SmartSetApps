{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)

  Copyright (C) 2018-2020 Vojtěch Čihák, Czech Republic

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

unit ECTriangle;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, FPImage, Graphics, IntfGraphics, LCLType, LMessages, Math,
  Themes, Types, ECTypes;

type
  {$PACKENUM 2}
  TBevelStyle = (ebsNone, ebsLoweredBox, ebsRaisedBox, ebsLoweredFrame, ebsRaisedFrame, ebsThemed);
  TCaptionVisibility = (ecvNone, ecvTopCaptionOnly, ecvCaptions, ecvValues, ecvBoth);
  TColorFill = (ecfNone, ecfSimple, ecfThreeColors, ecfThreeColorsEx, ecfGradient);
  TMarkPos = (empCenter, empTop, empSide, empBottom,
              empTopH, empBottomH, empSideH,                                       { etroMarksHalf - around }
              empCenterHTop, empCenterHSide, empCenterHBottom,                     { etroMarksHalf - inner }
              empTopTH, empTopTL, empBottomTH, empBottomTL, empSideTL, empSideTH,  { etroMarksThirds - around }
              empCenterTTop, empCenterTSide, empCenterTBottom,                     { etroMarksThirds - inner }
              empTopQH, empTopQL, empBottomQH, empBottomQL, empSideQL, empSideQH,  { etroMarksQuarters - around }
              empCenterQTop, empCenterQSide, empCenterQBottom,
              empCenterQTopL, empCenterQSideL, empCenterQBottomL);                 { etroMarksThirds - inner }
  TPointerStyle = (epsCircle, epsCross, epsRectangle, epsViewFinder);
  TTriangleValueFormat = (etvfDecimal, etvfPercentual, etvfPerMille);
  TTriangleFlag = (etrfDragging,
                   etrfHovered,
                   etrfLockCursor,
                   etrfMarkHovered,
                   etrfNeedRecalc,
                   etrfNeedRedraw,
                   etrfPointerCoordsCached,
                   etrfPointerHovered,
                   etrfWasEnabled);
  TTriangleFlags = set of TTriangleFlag;
  TTriangleOption = (etroKeepSumAvgOne,  { sum of average is 1 (centroid of triangle) }
                     etroMarksApexes,
                     etroMarksHalfs,
                     etroMarksThirds,
                     etroMarksQuarters,
                     etroReadonly,
                     etroReversed,
                     etroSnapToMarks);
  TTriangleOptions = set of TTriangleOption;
  TValuePosition = (evpTop, evpBottom, evpSide);

  { TCustomECTriangle }
  TCustomECTriangle = class(TGraphicControl)
  private
    FBevelStyle: TBevelStyle;
    FCaptionBottom: TCaption;
    FCaptionSide: TCaption;
    FCaptionVisibility: TCaptionVisibility;
    FColorBottom: TColor;
    FColorSide: TColor;
    FColorTop: TColor;
    FColorFill: TColorFill;
    FIndent: SmallInt;
    FMarkSize: SmallInt;
    FMaxBottom: Single;
    FMaxSide: Single;
    FMaxTop: Single;
    FOnChange: TNotifyEvent;
    FOptions: TTriangleOptions;
    FPointerStyle: TPointerStyle;
    FRounding: Byte;
    FValueRelBottom: Single;
    FValueFormat: TTriangleValueFormat;
    FValueRelTop: Single;
    function GetValueAbsBottom: Single;
    function GetValueAbsSide: Single;
    function GetValueAbsTop: Single;
    function GetValueRelSide: Single;
    procedure SetBevelStyle(AValue: TBevelStyle);
    procedure SetCaptionBottom(AValue: TCaption);
    procedure SetCaptionSide(AValue: TCaption);
    procedure SetCaptionVisibility(AValue: TCaptionVisibility);
    procedure SetColorBottom(AValue: TColor);
    procedure SetColorSide(AValue: TColor);
    procedure SetColorTop(AValue: TColor);
    procedure SetColorFill(AValue: TColorFill);
    procedure SetIndent(AValue: SmallInt);
    procedure SetMarkSize(AValue: SmallInt);
    procedure SetMaxBottom(AValue: Single);
    procedure SetMaxSide(AValue: Single);
    procedure SetMaxTop(AValue: Single);
    procedure SetOptions(AValue: TTriangleOptions);
    procedure SetPointerStyle(AValue: TPointerStyle);
    procedure SetRounding(AValue: Byte);
    procedure SetValueFormat(AValue: TTriangleValueFormat);
  protected const
    cDefBevelStyle = ebsNone;
    cDefCaptionVisi = ecvCaptions;
    cDefColorBottom = clBtnShadow;
    cDefColorFill = ecfGradient;
    cDefColorSide = clHighlightText;
    cDefColorTop = clHighlight;
    cDefIndent = 2;
    cDefMarkSize = 7;
    cDefOption = [etroMarksApexes, etroMarksHalfs];
    cDefPointerStyle = epsRectangle;
    cDefRounding = 2;
  protected
    DefCursor: TCursor;
    Flags: TTriangleFlags;
    MarkRects: array[TMarkPos] of TRect;
    PointerPt: TPoint;
    PrevHeight, PrevWidth: Integer;
    PtTopBMP, PtSideBMP, PtBottomBMP: TPoint;
    RealIndent: SmallInt;
    TriBMP: TBitmap;
    procedure BeginUpdate;
    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer;
                                     {%H-}WithThemeSpace: Boolean); override;
    procedure Calculate;
    procedure ChangeCursor(AHovered: Boolean);
    procedure CMBiDiModeChanged(var {%H-}Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var {%H-}Message: TLMessage); message CM_COLORCHANGED;
    function DoMarksMouseCheck(X, Y, ASnapRound: Integer): Boolean;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoSetValues(ATop, ABottom: Single; ACalcPointerPos: Boolean): Boolean;
    procedure DrawTriangleBMP;
    procedure EndUpdate;
    class function GetControlClassDefaultSize: TSize; override;
    procedure InvalidateNonUpdated;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure PlacePointer;
    procedure Recalc;
    procedure RecalcRedraw;
    procedure Redraw;
    procedure Resize; override;
    procedure SetAutoSize(Value: Boolean); override;
    procedure SetCursor(Value: TCursor); override;
    procedure TextChanged; override;
  public
    UpdateCount: SmallInt;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetValues(X, Y: Integer); overload;
    procedure SetValues(ATop, ABottom: Single); overload;
    property BevelStyle: TBevelStyle read FBevelStyle write SetBevelStyle default cDefBevelStyle;
    property CaptionBottom: TCaption read FCaptionBottom write SetCaptionBottom;
    property CaptionSide: TCaption read FCaptionSide write SetCaptionSide;
    property CaptionVisibility: TCaptionVisibility read FCaptionVisibility write SetCaptionVisibility default cDefCaptionVisi;
    property ColorBottom: TColor read FColorBottom write SetColorBottom default clDefault;
    property ColorFill: TColorFill read FColorFill write SetColorFill default cDefColorFill;
    property ColorSide: TColor read FColorSide write SetColorSide default clDefault;
    property ColorTop: TColor read FColorTop write SetColorTop default clDefault;
    property Indent: SmallInt read FIndent write SetIndent default cDefIndent;
    property MarkSize: SmallInt read FMarkSize write SetMarkSize default cDefMarkSize;
    property MaxBottom: Single read FMaxBottom write SetMaxBottom;
    property MaxSide: Single read FMaxSide write SetMaxSide;
    property MaxTop: Single read FMaxTop write SetMaxTop;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Options: TTriangleOptions read FOptions write SetOptions default cDefOption;
    property PointerStyle: TPointerStyle read FPointerStyle write SetPointerStyle default cDefPointerStyle;
    property Rounding: Byte read FRounding write SetRounding default cDefRounding;
    property ValueAbsBottom: Single read GetValueAbsBottom;
    property ValueAbsSide: Single read GetValueAbsSide;
    property ValueAbsTop: Single read GetValueAbsTop;
    property ValueFormat: TTriangleValueFormat read FValueFormat write SetValueFormat default etvfDecimal;
    property ValueRelBottom: Single read FValueRelBottom;
    property ValueRelSide: Single read GetValueRelSide;
    property ValueRelTop: Single read FValueRelTop;
  end;

  { TECTriangle }
  TECTriangle = class(TCustomECTriangle)
  published
    property Align;
    property Anchors;
    property AutoSize default True;
    property BiDiMode;
    property BorderSpacing;
    property Caption;
    property CaptionBottom;
    property CaptionSide;
    property CaptionVisibility;
    property Color;
    property ColorBottom;
    property ColorFill;
    property ColorSide;
    property ColorTop;
    property Constraints;
    property Enabled;
    property Font;
    property Indent;
    property MarkSize;
    property MaxBottom;
    property MaxSide;
    property MaxTop;
    property Options;
    property PopupMenu;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PointerStyle;
    property Rounding;
    property ShowHint;
    property ValueAbsBottom;
    property ValueAbsSide;
    property ValueAbsTop;
    property ValueFormat;
    property ValueRelBottom;
    property ValueRelSide;
    property ValueRelTop;
    property Visible;
    property OnChange;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
  end;

implementation

const caValues: array[TMarkPos, evpTop..evpBottom] of Single =
        ((1/3, 1/3), (1, 0), (0, 0), (0, 1), (0.5, 0), (0, 0.5), (0.5, 0.5), (0.5, 0.25),
         (0.25, 0.25), (0.25, 0.5), (2/3, 0),(1/3, 0), (0, 1/3), (0, 2/3),
         (1/3, 2/3), (2/3, 1/3), (2/3, 1/6), (1/6, 1/6),
         (1/6, 2/3), (0.75, 0), (0.25, 0), (0, 0.25), (0, 0.75), (0.25, 0.75), (0.75, 0.25),
         (0.75, 0.125), (0.125, 0.125), (0.125, 0.75), (0.375, 0.25), (0.375, 0.375), (0.25, 0.375));

{ TCustomECTringle }

constructor TCustomECTriangle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaptionVisibility:=cDefCaptionVisi;
  FColorBottom:=clDefault;
  FColorSide:=clDefault;
  FColorTop:=clDefault;
  FColorFill:=cDefColorFill;
  FIndent:=cDefIndent;
  FMarkSize:=cDefMarkSize;
  FMaxBottom:=1;
  FMaxSide:=1;
  FMaxTop:=1;
  FOptions:=cDefOption;
  FPointerStyle:=cDefPointerStyle;
  FRounding:=cDefRounding;
  FValueRelTop:=1.0;
  TriBMP:=TBitmap.Create;
  with TriBMP do
    begin
      Canvas.Pen.Cosmetic:=False;
      Canvas.Pen.EndCap:=pecFlat;
      Canvas.Pen.JoinStyle:=pjsBevel;
      Canvas.Pen.Style:=psSolid;
      Canvas.Pen.Width:=2;
    end;
  RealIndent:=cDefIndent;
  DefCursor:=Cursor;
  AutoSize:=True;
  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, cx, cy);
end;

destructor TCustomECTriangle.Destroy;
begin
  FreeAndNil(TriBMP);
  inherited Destroy;
end;

procedure TCustomECTriangle.BeginUpdate;
begin
  inc(UpdateCount);
end;

procedure TCustomECTriangle.CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer;
            WithThemeSpace: Boolean);
const c2cotanPi3 = 1.15470054;  { 2*cotan(Pi/3) }
begin
  PreferredWidth:=0;
  PreferredHeight:=round(c2cotanPi3*(Width-2*RealIndent))+2*RealIndent;
end;

procedure TCustomECTriangle.Calculate;
var aMarkSize, aRealIndent: SmallInt;
    aPt: TPoint;
    aWidthBMP, aHeightBMP: Integer;
    bReversed: Boolean;
begin
  aMarkSize:=MarkSize;
  aRealIndent:=Indent+1+(aMarkSize div 2);
  case BevelStyle of
    ebsLoweredBox, ebsRaisedBox:     inc(aRealIndent, 1);
    ebsLoweredFrame, ebsRaisedFrame: inc(aRealIndent, 2);
    ebsThemed: inc(aRealIndent, 3);
  end;
  RealIndent:=aRealIndent;
  aWidthBMP:=Width-2*aRealIndent;
  aHeightBMP:=Height-2*aRealIndent;
  TriBMP.SetSize(aWidthBMP, aHeightBMP);
  bReversed:=(etroReversed in Options) xor IsRightToLeft;
  PtTopBMP.Y:=0;
  PtSideBMP.Y:=aHeightBMP div 2;
  PtBottomBMP.Y:=aHeightBMP-1;
  aPt.X:=Width-aRealIndent-1;
  aPt.Y:=Height div 2;
  if not bReversed then
    begin
      MarkRects[empTop]:=PointToRect(Point(aRealIndent, aRealIndent), aMarkSize);
      MarkRects[empSide]:=PointToRect(aPt, aMarkSize);
      MarkRects[empBottom]:=PointToRect(Point(aRealIndent, Height-aRealIndent-1), aMarkSize);
      PtTopBMP.X:=1;
      PtSideBMP.X:=aWidthBMP-1;
      PtBottomBMP.X:=1;
      aPt.X:=aWidthBMP div 3 +aRealIndent;
    end else
    begin
      MarkRects[empTop]:=PointToRect(Point(aPt.X, aRealIndent), aMarkSize);
      MarkRects[empSide]:=PointToRect(Point(aRealIndent, aPt.Y), aMarkSize);
      MarkRects[empBottom]:=PointToRect(Point(aPt.X, Height-aRealIndent-1), aMarkSize);
      PtTopBMP.X:=aWidthBMP-1;
      PtSideBMP.X:=0;
      PtBottomBMP.X:=aWidthBMP-1;
      aPt.X:=2*aWidthBMP div 3 +aRealIndent;
    end;
  MarkRects[empCenter]:=PointToRect(aPt, aMarkSize);
  if ([etroMarksHalfs, etroMarksQuarters]*Options)<>[] then
    begin
      if not bReversed
        then aPt.X:=aRealIndent
        else aPt.X:=Width-aRealIndent-1;
      aPt.Y:=Height div 2;
      MarkRects[empSideH]:=PointToRect(aPt, aMarkSize);
      aPt.X:=Width div 2;
      aPt.Y:=aHeightBMP div 4 +aRealIndent;
      MarkRects[empTopH]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empBottomH]:=PointToRect(aPt, aMarkSize);
      aPt.X:=aWidthBMP div 2 +aRealIndent;
      aPt.Y:=Height div 2;
      MarkRects[empCenterHSide]:=PointToRect(aPt, aMarkSize);
      aPt.X:=aWidthBMP div 4 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=3*aHeightBMP div 8 +aRealIndent;
      MarkRects[empCenterHTop]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empCenterHBottom]:=PointToRect(aPt, aMarkSize);
    end;
  if etroMarksThirds in Options then
    begin
      if not bReversed
        then aPt.X:=aRealIndent
        else aPt.X:=Width-aRealIndent-1;
      aPt.Y:=aHeightBMP div 3 +aRealIndent;
      MarkRects[empSideTH]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empSideTL]:=PointToRect(aPt, aMarkSize);
      if not bReversed
        then aPt.X:=2*aWidthBMP div 3 +aRealIndent
        else aPt.X:=aWidthBMP div 3 +aRealIndent;
      aPt.Y:=aHeightBMP div 3 +aRealIndent;
      MarkRects[empTopTL]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empBottomTH]:=PointToRect(aPt, aMarkSize);
      aPt.X:=Width-aPt.X;
      aPt.Y:=aHeightBMP div 6 +aRealIndent;
      MarkRects[empTopTH]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empBottomTL]:=PointToRect(aPt, aMarkSize);
      aPt.X:=2*aWidthBMP div 3 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=Height div 2;
      MarkRects[empCenterTSide]:=PointToRect(aPt, aMarkSize);
      aPt.X:=aWidthBMP div 6 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=aHeightBMP div 4 +aRealIndent;
      MarkRects[empCenterTTop]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empCenterTBottom]:=PointToRect(aPt, aMarkSize);
    end;
  if etroMarksQuarters in Options then
    begin
      if not bReversed
        then aPt.X:=aRealIndent
        else aPt.X:=Width-aRealIndent-1;
      aPt.Y:=aHeightBMP div 4 +aRealIndent;
      MarkRects[empSideQH]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empSideQL]:=PointToRect(aPt, aMarkSize);
      if not bReversed
        then aPt.X:=3*aWidthBMP div 4 +aRealIndent
        else aPt.X:=aWidthBMP div 4 +aRealIndent;
      aPt.Y:=3*aHeightBMP div 8 +aRealIndent;
      MarkRects[empTopQL]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empBottomQH]:=PointToRect(aPt, aMarkSize);
      aPt.X:=Width-aPt.X;
      aPt.Y:=aHeightBMP div 8 +aRealIndent;
      MarkRects[empTopQH]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empBottomQL]:=PointToRect(aPt, aMarkSize);
      aPt.X:=3*aWidthBMP div 4 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=Height div 2;
      MarkRects[empCenterQSide]:=PointToRect(aPt, aMarkSize);
      aPt.X:=aWidthBMP div 8 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=3*aHeightBMP div 16 +aRealIndent;
      MarkRects[empCenterQTop]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empCenterQBottom]:=PointToRect(aPt, aMarkSize);
      aPt.X:=aWidthBMP div 4 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=Height div 2;
      MarkRects[empCenterQSideL]:=PointToRect(aPt, aMarkSize);
      aPt.X:=3*aWidthBMP div 8 +aRealIndent;
      if bReversed then aPt.X:=Width-aPt.X;
      aPt.Y:=7*aHeightBMP div 16 +aRealIndent;
      MarkRects[empCenterQTopL]:=PointToRect(aPt, aMarkSize);
      aPt.Y:=Height-aPt.Y;
      MarkRects[empCenterQBottomL]:=PointToRect(aPt, aMarkSize);
    end;
  exclude(Flags, etrfNeedRecalc);
end;

procedure TCustomECTriangle.ChangeCursor(AHovered: Boolean);
begin
  include(Flags, etrfLockCursor);
  if AHovered
    then Cursor:=crHandPoint
    else Cursor:=DefCursor;
  exclude(Flags, etrfLockCursor);
end;

procedure TCustomECTriangle.CMBiDiModeChanged(var Message: TLMessage);
begin
  RecalcRedraw;
end;

procedure TCustomECTriangle.CMColorChanged(var Message: TLMessage);
begin
  Redraw;
end;

function TCustomECTriangle.DoMarksMouseCheck(X, Y, ASnapRound: Integer): Boolean;

  function MarkInPoint(AMarkPos: TMarkPos): Boolean;
  var aRect: TRect;
  begin
    aRect:=MarkRects[AMarkPos];
    Result:=((X>=(aRect.Left-ASnapRound)) and (Y>=(aRect.Top-ASnapRound)) and
             (X<(aRect.Right+ASnapRound)) and (Y<(aRect.Bottom+ASnapRound)));
    if Result then
      begin
        PointerPt:=RectToPoint(aRect);
        include(Flags, etrfPointerCoordsCached);
        DoSetValues(caValues[AMarkPos, evpTop], caValues[AMarkPos, evpBottom], False);
      end;
  end;

var aMarkPos: TMarkPos;
begin
  Result:=False;
  if (([etroMarksApexes, etroMarksHalfs,  etroMarksThirds, etroMarksQuarters]*Options)<>[])
    then Result:=MarkInPoint(empCenter);
  if not Result and (etroMarksApexes in Options) then
    for aMarkPos:=empTop to empBottom do
      begin
        Result:=MarkInPoint(aMarkPos);
        if Result then break;
      end;
  if not Result and (([etroMarksHalfs, etroMarksQuarters]*Options)<>[]) then
    for aMarkPos:=empTopH to empCenterHBottom do
      begin
        Result:=MarkInPoint(aMarkPos);
        if Result then break;
      end;
  if not Result and (etroMarksThirds in Options) then
    for aMarkPos:=empTopTH to empCenterTBottom do
      begin
        Result:=MarkInPoint(aMarkPos);
        if Result then break;
      end;
  if not Result and (etroMarksQuarters in Options) then
    for aMarkPos:=empTopQH to empCenterQBottomL do
      begin
        Result:=MarkInPoint(aMarkPos);
        if Result then break;
      end;
end;

function TCustomECTriangle.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
    begin
      SetValues(PointerPt.X, PointerPt.Y+1);
      Result:=True;
    end;
end;

function TCustomECTriangle.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
    begin
      SetValues(PointerPt.X, PointerPt.Y-1);
      Result:=True;
    end;
end;

function TCustomECTriangle.DoSetValues(ATop, ABottom: Single; ACalcPointerPos: Boolean): Boolean;
begin
  Result:=(FValueRelTop<>ATop) or (FValueRelBottom<>ABottom);
  if Result then
    begin
      FValueRelTop:=ATop;
      FValueRelBottom:=ABottom;
      if ACalcPointerPos then exclude(Flags, etrfPointerCoordsCached);
      if assigned(OnChange) then OnChange(self);
      InvalidateNonUpdated;
    end;
end;

procedure TCustomECTriangle.DrawTriangleBMP;
var i, j, aHeight, aHeight_2, aTop: Integer;
    aFPColor: TFPColor;
    aRatio: Single;
    aTopColor, aBottomColor, aSideColor, aColorA, aColorB: TColor;
    aTriLII: TLazIntfImage;
begin
  aTriLII:=TriBMP.CreateIntfImage;
  aHeight:=aTriLII.Height;
  aHeight_2:=aHeight div 2;
  aColorA:=GetColorResolvingDefault(Color, Parent.Brush.Color);
  aFPColor:=TColorToFPColor(ColorToRGB(aColorA));
  for j:=0 to aHeight-1 do
    for i:=0 to aTriLII.Width-1 do
      aTriLII.Colors[i, j]:=aFPColor;
  aTopColor:=GetColorResolvingDefault(ColorTop, cDefColorTop);
  aSideColor:=GetColorResolvingDefault(ColorSide, cDefColorSide);
  aBottomColor:=GetColorResolvingDefault(ColorBottom, cDefColorBottom);
  if not IsEnabled then
    begin
      aTopColor:=GetMonochromaticColor(aTopColor);
      aSideColor:=GetMonochromaticColor(aSideColor);
      aBottomColor:=GetMonochromaticColor(aBottomColor);
    end;
  with TriBMP.Canvas do
    begin
      case ColorFill of
        ecfSimple:
          begin
            aFPColor:=TColorToFPColor(ColorToRGB(aTopColor));
            if not ((etroReversed in Options) xor IsRightToLeft)
              then
                for i:=2 to aTriLII.Width-1 do
                  begin
                    aRatio:=i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2)+1;
                    for j:=aTop to aHeight-aTop-2 do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end
              else
                for i:=0 to aTriLII.Width-3 do
                  begin
                    aRatio:=1-i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2);
                    for j:=aTop to aHeight-aTop-1 do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
          end;
        ecfThreeColors, ecfThreeColorsEx:
          begin
            aFPColor:=TColorToFPColor(ColorToRGB(aSideColor));
            if not ((etroReversed in Options) xor IsRightToLeft) then
              begin
                if ColorFill=ecfThreeColorsEx then
                  for i:=0 to aTriLII.Width div 2 do
                    begin
                      aRatio:=i/aTriLII.Width;
                      aColorA:=ColorToRGB(aTopColor);
                      aColorB:=ColorToRGB(aBottomColor);
                      aTop:=trunc(aRatio*aHeight_2);
                      for j:=aTop to aHeight-aTop-1 do
                        if (i>(aTriLII.Width div 3)) and
                          ((j/aHeight+1.5*aRatio)>1) and ((j/aHeight-1.5*aRatio)<0)
                          then aTriLII.Colors[i, j]:=aFPColor
                          else if j<=aHeight_2
                                 then aTriLII.Colors[i, j]:=TColorToFPColor(aColorA)
                                 else aTriLII.Colors[i, j]:=TColorToFPColor(aColorB);
                    end;
                for i:=aTriLII.Width div 2 to aTriLII.Width-1 do
                  begin
                    aRatio:=i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2)+1;
                    for j:=aTop to aHeight-aTop-2 do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
                aFPColor:=TColorToFPColor(ColorToRGB(aTopColor));
                for i:=2 to (aTriLII.Width div 2)+1 do
                  begin
                    aRatio:=i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2)+1;
                    for j:=aTop to aHeight_2-aTop do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
                aFPColor:=TColorToFPColor(ColorToRGB(aBottomColor));
                for i:=2 to (aTriLII.Width div 2)+1 do
                  begin
                    aRatio:=i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2);
                    for j:=aTop+aHeight_2 to aHeight-aTop-1 do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
              end else
              begin
                if ColorFill=ecfThreeColorsEx then
                  for i:=aTriLII.Width div 2 to aTriLII.Width-3 do
                    begin
                      aRatio:=i/aTriLII.Width;
                      aColorA:=ColorToRGB(aTopColor);
                      aColorB:=ColorToRGB(aBottomColor);
                      aTop:=trunc(aRatio*aHeight_2);
                      for j:=aTop to aHeight-aTop-1 do
                        if (i<(2*aTriLII.Width div 3)) and
                          ((1.5*aRatio-j/aHeight)<0.5) and ((1.5*aRatio+j/aHeight)<1.5)
                          then aTriLII.Colors[i, j]:=aFPColor
                          else if j<=aHeight_2
                                 then aTriLII.Colors[i, j]:=TColorToFPColor(aColorA)
                                 else aTriLII.Colors[i, j]:=TColorToFPColor(aColorB);
                    end;
                for i:=0 to (aTriLII.Width div 2)-1 do
                  begin
                    aRatio:=1-i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2)+1;
                    for j:=aTop to aHeight-aTop-2 do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
                aFPColor:=TColorToFPColor(ColorToRGB(aTopColor));
                for i:=aTriLII.Width div 2 to aTriLII.Width-3 do
                  begin
                    aRatio:=1-i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2)+1;
                    for j:=aTop to aHeight_2-aTop do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
                aFPColor:=TColorToFPColor(ColorToRGB(aBottomColor));
                for i:=aTriLII.Width div 2 to aTriLII.Width-3 do
                  begin
                    aRatio:=1-i/aTriLII.Width;
                    aTop:=trunc(aRatio*aHeight_2);
                    for j:=aTop+aHeight_2 to aHeight-aTop-1 do
                      aTriLII.Colors[i, j]:=aFPColor;
                  end;
              end;
          end;
        ecfGradient:
          begin
            if not ((etroReversed in Options) xor IsRightToLeft)
              then
                for i:=2 to aTriLII.Width-1 do
                  begin
                    aRatio:=i/aTriLII.Width;
                    aColorA:=GetMergedColor(aSideColor, aTopColor, aRatio);
                    aColorB:=GetMergedColor(aSideColor, aBottomColor, aRatio);
                    aTop:=trunc(aRatio*aHeight_2)+1;
                    for j:=aTop to aHeight-aTop-1 do
                      aTriLII.Colors[i, j]:=TColorToFPColor(GetMergedColor(aColorB, aColorA, j/aHeight));
                  end
              else
                for i:=0 to aTriLII.Width-3 do
                  begin
                    aRatio:=1-i/aTriLII.Width;
                    aColorA:=GetMergedColor(aSideColor, aTopColor, aRatio);
                    aColorB:=GetMergedColor(aSideColor, aBottomColor, aRatio);
                    aTop:=trunc(aRatio*aHeight_2);
                    for j:=aTop to aHeight-aTop-1 do
                      aTriLII.Colors[i, j]:=TColorToFPColor(GetMergedColor(aColorB, aColorA, j/aHeight));
                  end;
          end;
      end;  {case}
      TriBMP.LoadFromIntfImage(aTriLII);
      aTriLII.Free;
      case ColorFill of
        ecfNone:   aColorA:=aTopColor;
        ecfSimple: aColorA:=aBottomColor;
        otherwise  aColorA:=clBtnShadow;
      end;
      if not IsEnabled then aColorA:=GetMonochromaticColor(aColorA);
      Pen.Color:=aColorA;
      AntialiasingMode:=amOn;
      Brush.Style:=bsClear;
      Polyline([PtTopBMP, PtSideBMP, PtBottomBMP, PtTopBMP]);
    end;
  exclude(Flags, etrfNeedRedraw);
end;

procedure TCustomECTriangle.EndUpdate;
begin
  dec(UpdateCount);
  RecalcRedraw;
end;

class function TCustomECTriangle.GetControlClassDefaultSize: TSize;
begin
  Result.cx:=200;
  Result.cy:=230;
end;

procedure TCustomECTriangle.InvalidateNonUpdated;
begin
  if UpdateCount=0 then Invalidate;
end;

procedure TCustomECTriangle.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if etroReadonly in Options then exit;  { Exit; }
  if Button=mbLeft then
    if etrfHovered in Flags
      then include(Flags, etrfDragging)
      else if not DoMarksMouseCheck(X, Y, 2) then SetValues(X, Y);
end;

procedure TCustomECTriangle.MouseMove(Shift: TShiftState; X, Y: Integer);
var aMarkSizeRadius: Integer;
    bMarkHovered: Boolean;
begin
  inherited MouseMove(Shift, X, Y);
  if not (etroReadonly in Options) then
    begin
      if not (etrfDragging in Flags) then
        begin
          aMarkSizeRadius:=MarkSize+2;
          if (X>(PointerPt.X-aMarkSizeRadius)) and (X<(aMarkSizeRadius+PointerPt.X)) and
            (Y>(PointerPt.Y-aMarkSizeRadius)) and (Y<(aMarkSizeRadius+PointerPt.Y)) then
            begin
              include(Flags, etrfHovered);
              ChangeCursor(True);
            end else
            begin
              exclude(Flags, etrfHovered);
              ChangeCursor(False);
            end;
        end else
        begin
          bMarkHovered:=((etroSnapToMarks in Options) and DoMarksMouseCheck(X, Y, 3));
          if not bMarkHovered then SetValues(X, Y);
        end;
    end;
end;

procedure TCustomECTriangle.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button=mbLeft) and (etrfDragging in Flags) then
    begin
      exclude(Flags, etrfDragging);
      ChangeCursor(False);
    end;
end;

procedure TCustomECTriangle.Paint;

  function GetFormatedValue(AValue: Single): string;
  begin
    case ValueFormat of
      etvfDecimal:    Result:=floatToStrF(AValue, ffFixed, 1, Rounding);
      etvfPercentual: Result:=floatToStrF(100*AValue, ffFixed, 3, Rounding)+'%';
      etvfPerMille:   Result:=floatToStrF(1000*AValue, ffFixed, 4, Rounding)+'‰';
    end;
  end;

const cBaseDTFlags = DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX;
var aFlags: Cardinal;
    aMarkPos: TMarkPos;
    aMaxSum: Single;
    aRect: TRect;
    aText: string;
    aTextHeight: SmallInt;
    bEnabled, bR2L: Boolean;
begin
  bEnabled:=IsEnabled;
  bR2L:=IsRightToLeft;
  if etrfNeedRecalc in Flags then Calculate;
  if (etrfNeedRedraw in Flags) or (bEnabled<>(etrfWasEnabled in Flags)) then DrawTriangleBMP;
  if Color<>clDefault then
    begin
      Canvas.Brush.Color:=Color;
      Canvas.FillRect(ClientRect);
    end;
  with Canvas do
    begin
      aRect:=ClientRect;
      case BevelStyle of
        ebsLoweredBox, ebsLoweredFrame: Frame3D(aRect, 1, bvLowered);
        ebsRaisedBox, ebsRaisedFrame:   Frame3D(aRect, 1, bvRaised);
        ebsThemed: DrawThemedPanelBkgnd(ClientRect);
      end;
      case BevelStyle of
        ebsLoweredFrame: Frame3D(aRect, 1, bvRaised);
        ebsRaisedFrame:  Frame3D(aRect, 1, bvLowered);
      end;
      Draw(RealIndent, RealIndent, TriBMP);
      if bEnabled
        then Pen.Color:=clBtnText
        else Pen.Color:=GetMonochromaticColor(ColorToRGB(clBtnText));
      Pen.Style:=psSolid;
      Pen.Width:=1;
      if ([etroMarksApexes, etroMarksHalfs, etroMarksThirds, etroMarksQuarters]*Options)<>[]
        then Frame(MarkRects[empCenter]);
      if etroMarksApexes in Options then
        for aMarkPos:=empTop to empBottom do
          Frame(MarkRects[aMarkPos]);
      if ([etroMarksHalfs, etroMarksQuarters]*Options)<>[] then
        for aMarkPos:=empTopH to empCenterHBottom do
          Frame(MarkRects[aMarkPos]);
      if etroMarksThirds in Options then
        for aMarkPos:=empTopTH to empCenterTBottom do
          Frame(MarkRects[aMarkPos]);
      if etroMarksQuarters in Options then
        for aMarkPos:=empTopQH to empCenterQBottomL do
          Frame(MarkRects[aMarkPos]);
    end;
  if CaptionVisibility<>ecvNone then
    begin
      aFlags:=cBaseDTFlags or caDTRTLFlags[bEnabled] or DT_CENTER;
      aText:='';
      if CaptionVisibility in [ecvTopCaptionOnly, ecvCaptions, ecvBoth] then aText:=Caption;
      if CaptionVisibility in [ecvValues, ecvBoth] then
        begin
          if not (etroKeepSumAvgOne in Options)
            then aMaxSum:=1
            else aMaxSum:=(MaxTop+MaxSide+MaxBottom)/3;
          if aText<>'' then aText:=aText+' ';
          aText:=aText+GetFormatedValue(ValueRelTop*MaxTop/aMaxSum);
        end;
      aTextHeight:=Canvas.TextHeight(aText);
      aRect:=Rect(RealIndent, RealIndent, Width-3*RealIndent, RealIndent+aTextHeight);
      ThemeServices.DrawText(Canvas, ArBtnDetails[bEnabled, False], aText, aRect, aFlags, 0);
      if CaptionVisibility<>ecvTopCaptionOnly then
        begin
          aText:='';
          if CaptionVisibility in [ecvCaptions, ecvBoth] then aText:=CaptionBottom;
          if CaptionVisibility in [ecvValues, ecvBoth] then
            begin
              if aText<>'' then aText:=aText+' ';
              aText:=aText+GetFormatedValue(ValueRelBottom*MaxBottom/aMaxSum);
            end;
          aRect:=Rect(RealIndent, Height-RealIndent-aTextHeight, Width-3*RealIndent, Height-RealIndent);
          ThemeServices.DrawText(Canvas, ArBtnDetails [bEnabled, False], aText, aRect, aFlags, 0);
          aFlags:=cBaseDTFlags or caDTRTLFlags[bEnabled];
          if not (bR2L xor (etroReversed in Options)) then aFlags:=aFlags or DT_RIGHT;
          aText:='';
          if CaptionVisibility in [ecvCaptions, ecvBoth] then aText:=CaptionSide;
          if CaptionVisibility in [ecvValues, ecvBoth] then
            begin
              if aText<>'' then aText:=aText+' ';
              aText:=aText+GetFormatedValue(ValueRelSide*MaxSide/aMaxSum);
            end;
          aRect:=Rect(RealIndent, Height div 5, Width-RealIndent, Height div 5 +aTextHeight);
          ThemeServices.DrawText(Canvas, ArBtnDetails[bEnabled, False], aText, aRect, aFlags, 0);
        end;
    end;
  if bEnabled
    then Canvas.Brush.Color:=clWindow
    else Canvas.Brush.Color:=GetMonochromaticColor(ColorToRGB(clWindow));
  if not (etrfPointerCoordsCached in Flags) then PlacePointer;
  aRect:=PointToRect(PointerPt, MarkSize+2);
  case PointerStyle of
    epsCircle: Canvas.Ellipse(aRect);
    epsCross, epsViewFinder:
      begin
        Canvas.Line(PointerPt.X-MarkSize, PointerPt.Y, PointerPt.X+MarkSize+1, PointerPt.Y);
        Canvas.Line(PointerPt.X, PointerPt.Y-MarkSize, PointerPt.X, PointerPt.Y+MarkSize+1);
        if PointerStyle=epsViewFinder then Canvas.Frame(aRect);
      end;
    epsRectangle: Canvas.Rectangle(aRect);
  end;
  if bEnabled
    then include(Flags, etrfWasEnabled)
    else exclude(Flags, etrfWasEnabled);
  inherited Paint;
end;

procedure TCustomECTriangle.PlacePointer;
var aDenom, aRelXPos: Single;
begin
  PointerPt.X:=RealIndent+round((TriBMP.Width-1)*ValueRelSide);
  aRelXPos:=(PointerPt.X-RealIndent)/(TriBMP.Width-1);
  if not ((etroReversed in Options) xor IsRightToLeft)
    then aRelXPos:=1-aRelXPos
    else PointerPt.X:=Width-PointerPt.X;
  aDenom:=ValueRelTop+ValueRelBottom;
  if not Math.SameValue(aDenom, 0, 0.00001)
    then PointerPt.Y:=RealIndent+round(0.5*PtBottomBMP.Y*(1-((ValueRelTop-ValueRelBottom)/aDenom)*aRelXPos))
    else PointerPt.Y:=RealIndent+round(PtSideBMP.Y);
  include(Flags, etrfPointerCoordsCached);
end;

procedure TCustomECTriangle.Recalc;
begin
  include(Flags, etrfNeedRecalc);
  if UpdateCount=0 then Invalidate;
end;

procedure TCustomECTriangle.RecalcRedraw;
begin
  Flags:=Flags+[etrfNeedRecalc, etrfNeedRedraw]-[etrfPointerCoordsCached];
  if UpdateCount=0 then Invalidate;
end;

procedure TCustomECTriangle.Redraw;
begin
  include(Flags, etrfNeedRedraw);
  if UpdateCount=0 then Invalidate;
end;

procedure TCustomECTriangle.Resize;
begin
  inherited Resize;
  if AutoSize then InvalidatePreferredSize;
  if (Width<>PrevWidth) or (Height<>PrevHeight) then
    begin
      RecalcRedraw;
      PrevWidth:=Width;
      PrevHeight:=Height;
    end;
end;

procedure TCustomECTriangle.SetAutoSize(Value: Boolean);
begin
  inherited SetAutoSize(Value);
  if Value then
    begin
      InvalidatePreferredSize;
      RecalcRedraw;
    end;
end;

procedure TCustomECTriangle.SetCursor(Value: TCursor);
begin
  inherited SetCursor(Value);
  if not (etrfLockCursor in Flags) then DefCursor:=Value;
end;

procedure TCustomECTriangle.SetValues(X, Y: Integer);
var aMaxY, aTopY, aWidth: Integer;
    aRealIndent: SmallInt;
    aTop, aSide, aHelpY: Single;
    bReversed: Boolean;
begin
  bReversed:=((etroReversed in Options) xor IsRightToLeft);
  aRealIndent:=RealIndent;
  dec(X, aRealIndent);
  dec(Y, aRealIndent);
  aWidth:=TriBMP.Width-1;
  X:=Math.EnsureRange(X, 0, aWidth);
  aHelpY:=X*PtSideBMP.Y/aWidth;
  if bReversed then aHelpY:=PtSideBMP.Y-aHelpY;
  aTopY:=round(aHelpY);
  aMaxY:=round(PtBottomBMP.Y-aHelpY);
  Y:=Math.EnsureRange(Y, aTopY, aMaxY);
  PointerPt:=Point(X+aRealIndent, Y+aRealIndent);
  include(Flags, etrfPointerCoordsCached);
  aSide:=X/aWidth;
  if bReversed then aSide:=1-aSide;
  dec(Y, aTopY);
  dec(aMaxY, aTopY);
  if aMaxY>0
    then aTop:=(1-aSide)*(1-Y/aMaxY)
    else aTop:=0;
  DoSetValues(aTop, 1-aSide-aTop, False);
end;

procedure TCustomECTriangle.SetValues(ATop, ABottom: Single);
begin
  DoSetValues(ATop, ABottom, True);
end;

procedure TCustomECTriangle.TextChanged;
begin
  inherited TextChanged;
  if CaptionVisibility in [ecvTopCaptionOnly, ecvCaptions, ecvBoth] then InvalidateNonUpdated;
end;

{ TCustomECTriangle.G/Setters }

function TCustomECTriangle.GetValueAbsBottom: Single;
begin
  Result:=FValueRelBottom*FMaxBottom;
end;

function TCustomECTriangle.GetValueAbsSide: Single;
begin
  Result:=GetValueRelSide*FMaxSide;
end;

function TCustomECTriangle.GetValueAbsTop: Single;
begin
  Result:=FValueRelTop*FMaxTop;
end;

function TCustomECTriangle.GetValueRelSide: Single;
begin
  Result:=1-FValueRelBottom-FValueRelTop;
end;

procedure TCustomECTriangle.SetBevelStyle(AValue: TBevelStyle);
begin
  if FBevelStyle=AValue then exit;
  FBevelStyle:=AValue;
  RecalcRedraw;
end;

procedure TCustomECTriangle.SetCaptionBottom(AValue: TCaption);
begin
  if FCaptionBottom=AValue then exit;
  FCaptionBottom:=AValue;
  if CaptionVisibility in [ecvCaptions, ecvBoth] then InvalidateNonUpdated;
end;

procedure TCustomECTriangle.SetCaptionSide(AValue: TCaption);
begin
  if FCaptionSide=AValue then exit;
  FCaptionSide:=AValue;
  if CaptionVisibility in [ecvCaptions, ecvBoth] then InvalidateNonUpdated;
end;

procedure TCustomECTriangle.SetCaptionVisibility(AValue: TCaptionVisibility);
begin
  if FCaptionVisibility=AValue then exit;
  FCaptionVisibility:=AValue;
  InvalidateNonUpdated;
end;

procedure TCustomECTriangle.SetColorBottom(AValue: TColor);
begin
  if FColorBottom=AValue then exit;
  FColorBottom:=AValue;
  Redraw;
end;

procedure TCustomECTriangle.SetColorSide(AValue: TColor);
begin
  if FColorSide=AValue then exit;
  FColorSide:=AValue;
  Redraw;
end;

procedure TCustomECTriangle.SetColorTop(AValue: TColor);
begin
  if FColorTop=AValue then exit;
  FColorTop:=AValue;
  Redraw;
end;

procedure TCustomECTriangle.SetColorFill(AValue: TColorFill);
begin
  if FColorFill=AValue then exit;
  FColorFill:=AValue;
  Redraw;
end;

procedure TCustomECTriangle.SetIndent(AValue: SmallInt);
begin
  if FIndent=AValue then exit;
  FIndent:=AValue;
  RecalcRedraw;
end;

procedure TCustomECTriangle.SetMarkSize(AValue: SmallInt);
begin
  if FMarkSize=AValue then exit;
  FMarkSize:=AValue;
  RecalcRedraw;
end;

procedure TCustomECTriangle.SetMaxBottom(AValue: Single);
begin
  if FMaxBottom=AValue then exit;
  FMaxBottom:=AValue;
  InvalidateNonUpdated
end;

procedure TCustomECTriangle.SetMaxSide(AValue: Single);
begin
  if FMaxSide=AValue then exit;
  FMaxSide:=AValue;
  InvalidateNonUpdated
end;

procedure TCustomECTriangle.SetMaxTop(AValue: Single);
begin
  if FMaxTop=AValue then exit;
  FMaxTop:=AValue;
  InvalidateNonUpdated
end;

procedure TCustomECTriangle.SetOptions(AValue: TTriangleOptions);
var bRecalcRedraw: Boolean;
begin
  if FOptions=AValue then exit;
  bRecalcRedraw:=(etroReversed in (FOptions><AValue));
  FOptions:=AValue;
  if not bRecalcRedraw
    then Recalc         { Marks don't need Redraw }
    else RecalcRedraw;
end;

procedure TCustomECTriangle.SetPointerStyle(AValue: TPointerStyle);
begin
  if FPointerStyle=AValue then exit;
  FPointerStyle:=AValue;
  InvalidateNonUpdated;
end;

procedure TCustomECTriangle.SetRounding(AValue: Byte);
begin
  if FRounding=AValue then exit;
  FRounding:=AValue;
  if CaptionVisibility in [ecvValues, ecvBoth] then InvalidateNonUpdated;
end;

procedure TCustomECTriangle.SetValueFormat(AValue: TTriangleValueFormat);
begin
  if FValueFormat=AValue then exit;
  FValueFormat:=AValue;
  if CaptionVisibility in [ecvValues, ecvBoth] then InvalidateNonUpdated;
end;

end.


