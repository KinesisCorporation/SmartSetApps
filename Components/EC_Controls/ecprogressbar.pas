{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)

  Copyright (C) 2013-2020 Vojtěch Čihák, Czech Republic

  Credit: alignment of composite components (class TECSpinPosSpacing)
    is based on idea of Flávio Etrusco published on mailing list.
    http://lists.lazarus.freepascal.org/pipermail/lazarus/2013-March/079971.html

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

unit ECProgressBar;
{$mode objfpc}{$H+}

//{$DEFINE DBGPROGBAR}  {don't remove, just comment}

interface

uses
  Classes, SysUtils, Controls, CustomTimer, Forms, Graphics, LCLIntf, LCLProc, LMessages, Math, Types,
  ECScale, ECSlider, ECSpinCtrls, ECTypes;

type  
  {$PACKENUM 2}
  TProgressKind = (epkProgress, epkMarquee12, epkMarquee17, epkMarquee25, epkMarquee33, epkMarquee50);
  TProgressTextStyle = (eptNone, eptSolid, eptInverted);
  
  { TCustomECProgressBar }
  TCustomECProgressBar = class(TBaseECSlider)
  private
    FCaptionInline: Boolean;
    FKind: TProgressKind;
    FProgressDigits: Word;
    FProgressFontOptions: TFontOptions;
    FProgressTextAlign: SmallInt;
    FProgressTextStyle: TProgressTextStyle;
    FUnits: string;
    procedure SetCaptionInline(AValue: Boolean);
    procedure SetKind(AValue: TProgressKind);
    procedure SetProgressDigits(AValue: Word); virtual;
    procedure SetProgressTextAlign(AValue: SmallInt);
    procedure SetProgressTextStyle(AValue: TProgressTextStyle);
    procedure SetUnits(const AValue: string);
  protected const
    cMarqueeFrames = 50;  { 50*50ms = 2.5 seconds there and 2.5 secs back }
    cDefGrooveWidth = 16;
    cDefProgMarkSize = 3;
    cDefProgressText = eptInverted;
  protected
    MarqueeInc: Boolean;
    MarqueePos: Integer;
    Timer: TCustomTimer;
    procedure CalcGrooveMiddle; override;
    procedure CalcInvalidRectDyn; override;
    procedure CalcInvalidRectStat; override;
    procedure CalcProgressInvRect; virtual;
    procedure CorrectGrooveLength(var z1, z2: Integer; AVertical: Boolean); override;
    procedure DoMarquee(Sender: TObject);
    procedure DrawGroove; override;
    function GetRelGroovePos: Integer; override;
    function HasCaption: Boolean; override;
    procedure OrientationChanged(AValue: TObjectOrientation); override;
    procedure PaintSelf(AEnabled: Boolean); override;
    procedure SetGrooveBoundsHorz(x1, x2, {%H-}y1, {%H-}y2: Integer); override;
    procedure SetGrooveBoundsVert({%H-}x1, {%H-}x2, y1, y2: Integer); override;
    procedure SetPosition(AValue: Double); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CaptionInline: Boolean read FCaptionInline write SetCaptionInline default False;
    property Kind: TProgressKind read FKind write SetKind default epkProgress;
    property ProgressDigits: Word read FProgressDigits write SetProgressDigits default 0;
    property ProgressFontOptions: TFontOptions read FProgressFontOptions write FProgressFontOptions;
    property ProgressTextAlign: SmallInt read FProgressTextAlign write SetProgressTextAlign default 0;
    property ProgressTextStyle: TProgressTextStyle read FProgressTextStyle write SetProgressTextStyle default cDefProgressText;
    property Units: string read FUnits write SetUnits;
  end;

  { TECProgressBar }
  TECProgressBar = class(TCustomECProgressBar)
  published
    property Align;
    property Anchors;
    property AutoSize default True;
    property BevelInner;
    property BevelOuter;
    property BevelSpace;
    property BevelWidth;
    property BorderSpacing;
    property Caption;
    property CaptionInline;
    property CaptionPos;
    property Color;
    property Color3DLight;
    property Color3DDark;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property GrooveBevelWidth;
    property GrooveColor;
    property GrooveStyle;
    property GrooveTransparent;
    property GrooveWidth default cDefGrooveWidth;
    property ImageIndex;
    property ImagePos;
    property Images;
    property Indent;
    property Kind;
    property Max;
    property Min;
    property Orientation default eooHorizontal;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property PositionToHint;
    property ProgressColor;
    property ProgressColor2;
    property ProgressDigits;
    property ProgressFontOptions;
    property ProgressFromMiddle;
    property ProgressMark;
    property ProgressMarkSize default cDefProgMarkSize;
    property ProgressMiddlePos;
    property ProgressParameter;
    property ProgressStyle;
    property ProgressTextAlign;
    property ProgressTextStyle;
    property Reversed;
    property Scale;
    property ScaleFontOptions;
    property ScaleTickPos;
    property ScaleValuePos;
    property ShowHint;
    property Style;
    property Units;
    property Visible;
    property Width;
    property OnChange;
    property OnChangeBounds;
    property OnDrawProgressBMP;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;  

  { TCustomECPositionBar }
  TCustomECPositionBar = class(TCustomECProgressBar)
  private
    FMouseDragPx: Integer;
    FMouseDragPxFine: Integer;
    FProgressSign: Boolean;
    procedure SetProgressSign(AValue: Boolean);
  protected const
    cDefIndent = 2;
    cDefMouseDragPxFine = 10;
    cDefMouseDragPx = 1;     
  protected
    FCursorBkgnd: TCursor;
    InitCoord: Integer;
    InitDelta: Double;     
    procedure CalcInvalidRectDyn; override;
    procedure CalcProgressInvRect; override;
    procedure ChangeCursors(AMouseHoverDragArea: Boolean);
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DrawGroove; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SetCursor(Value: TCursor); override;
  public
    constructor Create(AOwner: TComponent); override;
    property MouseDragPixels: Integer read FMouseDragPx write FMouseDragPx default cDefMouseDragPx;
    property MouseDragPixelsFine: Integer read FMouseDragPxFine write FMouseDragPxFine default cDefMouseDragPxFine;
    property ProgressSign: Boolean read FProgressSign write SetProgressSign default False;
  end; 

  { TECPositionBar }
  TECPositionBar = class(TCustomECPositionBar)
  published
    property Align;
    property Anchors;
    property AutoSize default True;
    property BevelInner;
    property BevelOuter;
    property BevelSpace;
    property BevelWidth;
    property BiDiMode;
    property BorderSpacing;
    property Caption;
    property CaptionInline;
    property CaptionPos;
    property Color;
    property Color3DLight;
    property Color3DDark;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property GrooveBevelWidth;
    property GrooveColor;
    property GrooveStyle;
    property GrooveTransparent;
    property GrooveWidth default cDefGrooveWidth;
    property ImageIndex;
    property ImagePos;
    property Images;
    property Indent default cDefIndent;
    property Max;
    property Min;
    property MouseDragPixels;
    property MouseDragPixelsFine;
    property Orientation default eooHorizontal;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property PositionToHint;
    property ProgressColor;
    property ProgressColor2;
    property ProgressDigits;
    property ProgressFontOptions;
    property ProgressFromMiddle;
    property ProgressMark;
    property ProgressMarkSize default cDefProgMarkSize;
    property ProgressMiddlePos;
    property ProgressParameter;
    property ProgressSign;
    property ProgressStyle;
    property ProgressTextAlign;
    property ProgressTextStyle;
    property ProgressVisible;
    property Reversed;
    property Scale;
    property ScaleFontOptions;
    property ScaleTickPos;
    property ScaleValuePos;
    property ShowHint;
    property Style;
    property Units;
    property Visible;
    property Width;
    property OnChange;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawProgressBMP;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;           
  end;

  { TECSpinBtnsPos }
  TECSpinBtnsPos = class(TCustomSpinBtns)
  protected
    CustomResize: TObjectMethod;
    procedure RecalcRedraw; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AnchorSideLeft stored False;
    property AnchorSideTop stored False;
    property AnchorSideRight stored False;
    property AnchorSideBottom stored False;
    property BtnBigDec;
    property BtnBigInc;
    property BtnDec;
    property BtnDrag;
    property BtnInc;
    property BtnMax;
    property BtnMenu;
    property BtnMiddle;
    property BtnMin;
    property DiscreteChange;
    property DragControl;
    property DragOrientation;
    property Font;
    property GlyphStyle;
    property Height stored False;
    property Images;
    property Increment;
    property Left stored False;
    property MenuBtnLeftMouseUp;
    property MenuControl;
    property Middle;
    property Mode;
    property MouseFromMiddle;
    property MouseIncrementX;
    property MouseIncrementY;
    property MouseStepPixelsX;
    property MouseStepPixelsY;
    property PageSize;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Reversed;
    property ShowHint;
    property Spacing;
    property Style;
    property TimerDelay;
    property TimerRepeating;
    property Top stored False;
    property Width stored False;
    property OnClick;
    property OnContextPopup;
    property OnDrawGlyph;
    property OnMenuClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
  end;

  { TECSpinPosSpacing }
  TECSpinPosSpacing = class(TControlBorderSpacing)
  public
    function GetSpace(Kind: TAnchorKind): Integer; override;
    procedure GetSpaceAround(var SpaceAround: TRect); override;
  end;

  { TECSpinPosition }
  TECSpinPosition = class(TCustomECPositionBar)
  private
    FIndentBtns: SmallInt;
    FOnVisibleChanged: TOnVisibleChanged;
    FSpinBtns: TECSpinBtnsPos;
    function GetController: TECSpinController;
    function GetWidthInclBtn: Integer;
    procedure SetController(AValue: TECSpinController);
    procedure SetIndentBtns(AValue: SmallInt);
    procedure SetWidthInclBtn(AValue: Integer);
  protected const
    cDefIndentBtns = 0;
  protected
    procedure ChangePosition;
    procedure CMBiDiModeChanged(var Message: TLMessage); message CM_BIDIMODECHANGED;
    function CreateControlBorderSpacing: TControlBorderSpacing; override;
    procedure DoOnChangeBounds; override;
    procedure InitializeWnd; override;
    procedure RecalcRedraw; override;
    procedure SetEnabled(Value: Boolean); override;
    procedure SetMax(const AValue: Double); override;
    procedure SetMin(const AValue: Double); override;
    procedure SetParent(NewParent: TWinControl); override;
    procedure SetPosition(AValue: Double); override;
    procedure SetSpinBtnsPosition;
    procedure VisibleChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property AutoSize default True;
    property BevelInner;
    property BevelOuter;
    property BevelSpace;
    property BevelWidth;
    property BiDiMode;
    property BorderSpacing;
    property Buttons: TECSpinBtnsPos read FSpinBtns;
    property Caption;
    property CaptionInline;
    property CaptionPos;
    property Color;
    property Color3DLight;
    property Color3DDark;
    property Constraints;
    property Controller: TECSpinController read GetController write SetController;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property GrooveBevelWidth;
    property GrooveColor;
    property GrooveStyle;
    property GrooveTransparent;
    property GrooveWidth default cDefGrooveWidth;
    property ImageIndex;
    property ImagePos;
    property Images;
    property Indent default cDefIndent;
    property IndentBtns: SmallInt read FIndentBtns write SetIndentBtns default cDefIndentBtns;
    property Max;
    property Min;
    property MouseDragPixels;
    property MouseDragPixelsFine;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property PositionToHint;
    property ProgressColor;
    property ProgressColor2;
    property ProgressDigits;
    property ProgressFontOptions;
    property ProgressFromMiddle;
    property ProgressMark;
    property ProgressMarkSize default cDefProgMarkSize;
    property ProgressMiddlePos;
    property ProgressParameter;
    property ProgressSign;
    property ProgressStyle;
    property ProgressTextAlign;
    property ProgressTextStyle;
    property ProgressVisible;
    property Reversed;
    property Scale;
    property ScaleFontOptions;
    property ScaleTickPos;
    property ScaleValuePos;
    property ShowHint;
    property Style;
    property Units;
    property Visible;
    property Width;
    property WidthInclBtn: Integer read GetWidthInclBtn write SetWidthInclBtn stored False;
    property OnChange;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawProgressBMP;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
    property OnVisibleChanged: TOnVisibleChanged read FOnVisibleChanged write FOnVisibleChanged;
  end;

implementation

{ TCustomECProgressBar }

constructor TCustomECProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csNoFocus];
  FGrooveWidth:=cDefGrooveWidth;
  FOrientation:=eooHorizontal;
  FProgressFontOptions:=TFontOptions.Create(self);
  with FProgressFontOptions do
    begin
      FontStyles:=[fsBold];
      OnRecalcRedraw:=@RecalcRedraw;
      OnRedraw:=@Redraw;
    end;
  FProgressMarkSize:=cDefProgMarkSize;
  FProgressTextStyle:=cDefProgressText;
  SetInitialBounds(0, 0, 240, 80);
  AccessibleRole:=larProgressIndicator;
end;

destructor TCustomECProgressBar.Destroy;
begin
  FreeAndNil(FProgressFontOptions);
  inherited Destroy;
end;

procedure TCustomECProgressBar.CalcGrooveMiddle;
begin
  if ProgressMiddlePos<Min 
    then FGrooveMiddle:=0
    else if ProgressMiddlePos>Max 
           then FGrooveMiddle:=FGrooveInnerLength-1
           else FGrooveMiddle:=trunc(((ProgressMiddlePos-Min)/(Max-Min))*FGrooveInnerLength);
end;

procedure TCustomECProgressBar.CalcInvalidRectDyn;
var aCurrentPosition: Integer;
    aRect: TRect;
begin
  {$IFDEF DBGPROGBAR} DebugLn('TCustomECProgressBar.CalcInvalidRectDyn'); {$ENDIF}
  if Orientation=eooHorizontal
    then FInvalidRect.Bottom:=FInvRectLimit       
    else FInvalidRect.Right:=FInvRectLimit;
  aRect:=FInvalidRect;
  aCurrentPosition:=round(((Position-Min)/(Max-Min))*FGrooveInnerLength);
  if not (esfRealReversed in Flags)
    then aCurrentPosition:=FGrooveMin+aCurrentPosition
    else aCurrentPosition:=FGrooveMax-aCurrentPosition-1;
  if Orientation=eooHorizontal then
    begin
      if aRect.Left<aCurrentPosition then
        begin  { moves Right }
          if aRect.Right<aCurrentPosition then FInvalidRect.Right:=aCurrentPosition
        end else  { moves Left }
          FInvalidRect.Left:=aCurrentPosition;
    end else     
    begin
      if aRect.Top<aCurrentPosition then
        begin  { moves Down }
          if aRect.Bottom<aCurrentPosition then FInvalidRect.Bottom:=aCurrentPosition;
        end else  { moves Up }
          FInvalidRect.Top:=aCurrentPosition;
    end;    
  if not (esfPrevInvRectPainted in Flags) then UnionRect(FInvalidRect, aRect, FInvalidRect);
  inc(FInvalidRect.Right);
  inc(FInvalidRect.Bottom);
end;

procedure TCustomECProgressBar.CalcInvalidRectStat;
begin
  {$IFDEF DBGPROGBAR} DebugLn('CalcInvalidRectStat'); {$ENDIF}
  if FOrientation=eooHorizontal then
    begin
      FInvalidRect.Top:=FGrooveRect.Top+FGrooveBevelWidth;
      FInvalidRect.Bottom:=FGrooveRect.Bottom-FGrooveBevelWidth;
      FInvRectLimit:=FInvalidRect.Bottom;
    end else    
    begin
      FInvalidRect.Left:=FGrooveRect.Left+FGrooveBevelWidth;
      FInvalidRect.Right:=FGrooveRect.Right-FGrooveBevelWidth;
      FInvRectLimit:=FInvalidRect.Right;
    end;    
end; 

procedure TCustomECProgressBar.CalcProgressInvRect;
    
  function CalcProgressInvRectLimit: Integer;
  begin
    if not (esfRealReversed in Flags)
      then Result:=FGrooveMin+round(GetRelPxPos)
      else Result:=FGrooveMax-round(GetRelPxPos)-1;
  end;    
    
begin
  if Orientation=eooHorizontal then 
    begin
      if (ProgressTextStyle=eptNone) and (ProgressVisible=epvProgress) then
        begin
          FInvalidRect.Left:=CalcProgressInvRectLimit;
          FInvalidRect.Right:=FInvalidRect.Left;
        end else 
        begin
          FInvalidRect.Left:=FGrooveMin;
          FInvalidRect.Right:=FGrooveMax;
        end;
    end else
    begin
      if (ProgressTextStyle=eptNone) and (ProgressVisible=epvProgress) then  
        begin
          FInvalidRect.Top:=CalcProgressInvRectLimit;
          FInvalidRect.Bottom:=FInvalidRect.Top;
        end else  
        begin
          FInvalidRect.Top:=FGrooveMin;
          FInvalidRect.Bottom:=FGrooveMax;
        end;
    end;                        
end;    

procedure TCustomECProgressBar.CorrectGrooveLength(var z1, z2: Integer; AVertical: Boolean);
var aHalfSize: SmallInt;
begin  
  if Scale.ValueVisible<>evvNone then
    begin
      if AVertical 
        then aHalfSize:=Background.Canvas.TextHeight('0,9') div 2
        else aHalfSize:=(Math.max(Background.Canvas.TextWidth(Scale.GetStringMin),
                                  Background.Canvas.TextWidth(Scale.GetStringMax))-1) div 2;
      dec(aHalfSize, GrooveBevelWidth);  
      inc(z1, aHalfSize);
      dec(z2, aHalfSize);  
    end;
end;         

procedure TCustomECProgressBar.DoMarquee(Sender: TObject);
begin
  if MarqueeInc
    then inc(MarqueePos)
    else dec(MarqueePos);
  if (MarqueePos=0) or (MarqueePos=cMarqueeFrames) then MarqueeInc:=not MarqueeInc;
  if RedrawMode<=ermFreeRedraw then
    begin
      RedrawMode:=ermMoveKnob;
      FInvalidRect:=FGrooveRect;
      if not (csLoading in ComponentState) then InvalidateRect(Handle, @FInvalidRect, False);
    end;
end;

procedure TCustomECProgressBar.DrawGroove;  { must be called from within Paint or PaintSelf! }
const cMarqueeLength: array[TProgressKind] of SmallInt = (0, 12, 17, 25, 33, 50);  { % }
var aColor: TColor;
    aMiddlePos, aMin, aMax, aProgress, aStart, aStop, aTextX, aTextY: Integer;
    aRect, aProgressRect: TRect;
    aSize: TSize;
    aStr: string;
    bHorizontal: Boolean;
begin
  if Kind=epkProgress then
    begin
      inherited DrawGroove;
      if ProgressTextStyle>eptNone then
        with Canvas do
          begin
            Font.Size:=ProgressFontOptions.FontSize;
            Font.Style:=ProgressFontOptions.FontStyles;
            bHorizontal:=(Orientation=eooHorizontal);
            if bHorizontal
              then Font.Orientation:=0
              else Font.Orientation:=900;
            Brush.Style:=bsClear;
            aStr:=Units;
            DeleteAmpersands(aStr);
            if aStr<>'' then aStr:=' '+aStr;
            aStr:=Scale.GetStringPosition(Position, ProgressDigits)+aStr;
            if CaptionInline and (Caption<>'') then aStr:=Caption+' '+aStr;
            aSize:=TextExtent(aStr);
            aProgressRect:=FGrooveRect;
            InflateRect(aProgressRect, -GrooveBevelWidth, -GrooveBevelWidth);
            aRect:=aProgressRect;
            if bHorizontal then
              begin
                if ProgressTextAlign=0
                  then aRect.Left:=(aRect.Right+aRect.Left-aSize.cx) div 2  { align to h-center }
                  else if ProgressTextAlign>0
                         then aRect.Left:=aRect.Right-ProgressTextAlign-aSize.cx  { align to right }
                         else dec(aRect.Left, ProgressTextAlign);  { align to left }
                aRect.Top:=(aRect.Bottom+aRect.Top-aSize.cy) div 2;
                aRect.Right:=aRect.Left+aSize.cx;
                aRect.Bottom:=aRect.Top+aSize.cy;
                aTextX:=aRect.Left;
                aTextY:=aRect.Top;
              end else
              begin
                aRect.Left:=(aRect.Right+aRect.Left-aSize.cy) div 2;
                if ProgressTextAlign=0
                  then aRect.Top:=(aRect.Bottom+aRect.Top-aSize.cx) div 2  { align to v-center }
                  else if ProgressTextAlign>0
                         then inc(aRect.Top, ProgressTextAlign)  { align to top }
                         else aRect.Top:=aRect.Bottom+ProgressTextAlign-aSize.cx;  { align to bottom }
                aRect.Right:=aRect.Left+aSize.cy;
                aRect.Bottom:=aRect.Top+aSize.cx+2;
                aTextX:=aRect.Left;
                aTextY:=aRect.Bottom-1;  { necessary for Font.Ori = 900 }
              end;
            IntersectRect(aRect, aRect, aProgressRect);
            case ProgressTextStyle of
              eptSolid:
                begin
                  aColor:=ProgressFontOptions.FontColor;
                  if aColor=clDefault then
                    begin
                      aColor:=GetColorResolvingDefault(GrooveColor, clBtnText);
                      if not GrooveTransparent and IsColorDark(ColorToRGB(clBtnText))
                        then aColor:=InvertColor(ColorToRGB(aColor));
                    end;
                  if not IsEnabled then aColor:=GetMonochromaticColor(aColor);
                  Font.Color:=aColor;
                  TextOut(aTextX, aTextY, aStr);
                end;
              eptInverted:
                case ProgressVisible of
                  epvNone:
                    begin
                      aColor:=GetColorResolvingDefault(ProgressColor, clHighlight);
                      if not IsEnabled then aColor:=GetMonochromaticColor(aColor);
                      Font.Color:=aColor;
                      TextOut(aTextX, aTextY, aStr);
                    end;
                  epvProgress:
                    begin
                      Clipping:=True;
                      if GrooveTransparent
                        then aColor:=clBtnFace
                        else aColor:=GetColorResolvingDefault(GrooveColor, cl3DDkShadow);
                      if not IsEnabled then aColor:=GetMonochromaticColor(aColor);
                      if not (esfRealReversed in Flags) then
                        begin
                          aProgress:=FGrooveMin;
                          aMiddlePos:=aProgress+FGrooveMiddle;
                          inc(aProgress, GetRelGroovePos);
                        end else
                        begin
                          aProgress:=FGrooveMax-GetRelGroovePos;
                          aMiddlePos:=FGrooveMax-FGrooveMiddle;
                        end;
                      if not ProgressFromMiddle then
                        begin  { normal progress }
                          if bHorizontal
                            then aStart:=aRect.Left
                            else aStart:=aRect.Top;
                          if aStart<aProgress then
                            begin
                              if not (esfRealReversed in Flags)
                                then Font.Color:=aColor
                                else Font.Color:=GetColorResolvingDefAndEnabled(ProgressColor, clHighlight, IsEnabled);
                              if bHorizontal
                                then ClipRect:=Rect(aRect.Left, aRect.Top, aProgress, aRect.Bottom)
                                else ClipRect:=Rect(aRect.Left, aRect.Top, aRect.Right, aProgress);
                              TextOut(aTextX, aTextY, aStr);
                            end;
                          if bHorizontal
                            then aStart:=aRect.Right
                            else aStart:=aRect.Bottom;
                          if aProgress<aStart then
                            begin
                              if not (esfRealReversed in Flags)
                                then Font.Color:=GetColorResolvingDefAndEnabled(ProgressColor, clHighlight, IsEnabled)
                                else Font.Color:=aColor;
                              if bHorizontal
                                then ClipRect:=Rect(aProgress, aRect.Top, aRect.Right, aRect.Bottom)
                                else ClipRect:=Rect(aRect.Left, aProgress, aRect.Right, aRect.Bottom);
                              TextOut(aTextX, aTextY, aStr);
                            end;
                        end else
                        begin  { ProgressFromMiddle }
                          if bHorizontal then
                            begin
                              aStart:=aRect.Left;
                              aStop:=aRect.Right;
                            end else
                            begin
                              aStart:=aRect.Top;
                              aStop:=aRect.Bottom;
                            end;
                          aMin:=Math.min(aProgress, aMiddlePos);
                          if aStart<aMin then
                            begin
                              Font.Color:=GetColorResolvingDefAndEnabled(ProgressColor, clHighlight, IsEnabled);
                              if bHorizontal
                                then ClipRect:=Rect(aRect.Left, aRect.Top, aMin, aRect.Bottom)
                                else ClipRect:=Rect(aRect.Left, aRect.Top, aRect.Right, aMin);
                              TextOut(aTextX, aTextY, aStr);
                            end;
                          aMax:=Math.max(aProgress, aMiddlePos);
                          if (aStart<aMax) and (aStop>aMin) and (aProgress<>aMiddlePos) then
                            begin
                              Font.Color:=aColor;
                              if bHorizontal
                                then ClipRect:=Rect(Math.max(aStart, aMin), aRect.Top, Math.min(aStop, aMax), aRect.Bottom)
                                else ClipRect:=Rect(aRect.Left, Math.max(aStart, aMin), aRect.Right, Math.min(aStop, aMax));
                              TextOut(aTextX, aTextY, aStr);
                            end;
                          if aStop>aMax then
                            begin
                              Font.Color:=GetColorResolvingDefAndEnabled(ProgressColor, clHighlight, IsEnabled);
                              if bHorizontal
                                then ClipRect:=Rect(aMax, aRect.Top, aRect.Right, aRect.Bottom)
                                else ClipRect:=Rect(aRect.Left, aMax, aRect.Right, aRect.Bottom);
                              TextOut(aTextX, aTextY, aStr);
                            end;
                        end;
                      Clipping:=False;
                    end;
                  epvFull:
                    begin
                      if GrooveTransparent
                        then aColor:=clBtnFace
                        else aColor:=GetColorResolvingDefault(GrooveColor, cl3DDkShadow);
                      if not IsEnabled then aColor:=GetMonochromaticColor(aColor);
                      Font.Color:=aColor;
                      TextOut(aTextX, aTextY, aStr);
                    end;
                end;  {case}
            end;  {case}
          end;
    end else
    begin  { marquee }
      aProgress:=round(0.01*cMarqueeLength[Kind]*FGrooveInnerLength);
      aStart:=round(MarqueePos*(FGrooveInnerLength-aProgress)/cMarqueeFrames);
      if not GrooveTransparent then
        begin
          Canvas.Brush.Style:=bsSolid;
          aColor:=GetColorResolvingDefault(GrooveColor, cl3DDkShadow);
          if IsEnabled
            then Canvas.Brush.Color:=aColor
            else Canvas.Brush.Color:=GetMonochromaticColor(aColor);
        end;
      aProgressRect:=FGrooveRect;
      InflateRect(aProgressRect, -GrooveBevelWidth, -GrooveBevelWidth);
      if Orientation=eooHorizontal then
        begin
          aRect.Top:=aProgressRect.Top;
          aRect.Bottom:=aProgressRect.Bottom;
          aRect.Left:=aProgressRect.Left+aStart;
          aRect.Right:=aRect.Left+aProgress;
          Canvas.CopyRect(aRect, GrooveBMP.Canvas, Rect(aStart, 0, aStart+aProgress, GrooveBMP.Height));
          if not GrooveTransparent then
            begin
              Canvas.FillRect(Rect(aProgressRect.Left, aRect.Top, aRect.Left, aRect.Bottom));
              Canvas.FillRect(Rect(aRect.Right, aRect.Top, aProgressRect.Right, aRect.Bottom));
            end;
        end else
        begin
          aRect.Left:=aProgressRect.Left;
          aRect.Right:=aProgressRect.Right;
          aRect.Top:=aProgressRect.Top+aStart;
          aRect.Bottom:=aRect.Top+aProgress;
          Canvas.CopyRect(aRect, GrooveBMP.Canvas, Rect(0, aStart, GrooveBMP.Width, aStart+aProgress));
          if not GrooveTransparent then
            begin
              Canvas.FillRect(Rect(aRect.Left, aProgressRect.Top, aRect.Right, aRect.Top));
              Canvas.FillRect(Rect(aRect.Left, aRect.Bottom, aRect.Right, aProgressRect.Bottom));
            end;
        end;
    end;
end;

function TCustomECProgressBar.GetRelGroovePos: Integer;
begin
  Result:=round(((Position-Min)/(Max-Min))*FGrooveInnerLength);
end;

function TCustomECProgressBar.HasCaption: Boolean;
begin
  Result:=(Caption<>'') and not CaptionInline;
end;  

procedure TCustomECProgressBar.OrientationChanged(AValue: TObjectOrientation);
begin
  if not (csLoading in ComponentState) then SetBounds(Left, Top, Height, Width);
  inherited OrientationChanged(AValue);
end;

procedure TCustomECProgressBar.PaintSelf(AEnabled: Boolean);
begin
  if (esfWasEnabled in Flags)<>AEnabled then
    if RedrawMode<ermRedrawBkgnd then RedrawMode:=ermRedrawBkgnd;
  if RedrawMode=ermRecalcRedraw then Calculate;
  if RedrawMode>=ermRedrawBkgnd then
    begin
      DrawBackground;
      DrawGrooveBMP;
    end;
  if RedrawMode>=ermFreeRedraw then
    begin
      Canvas.Draw(0, 0, Background);
      DrawGroove;
    end;
  if RedrawMode=ermMoveKnob then
    begin
      Canvas.CopyRect(FInvalidRect, Background.Canvas, FInvalidRect);
      DrawGroove;
    end;
  include(Flags, esfPrevInvRectPainted);
  CalcProgressInvRect;
end;

procedure TCustomECProgressBar.SetGrooveBoundsHorz(x1, x2, y1, y2: Integer);
begin
  FGrooveMin:=x1+GrooveBevelWidth;
  FGrooveMax:=x2-GrooveBevelWidth;
end;

procedure TCustomECProgressBar.SetGrooveBoundsVert(x1, x2, y1, y2: Integer);
begin
  FGrooveMin:=y1+GrooveBevelWidth;
  FGrooveMax:=y2-GrooveBevelWidth;
end;

procedure TCustomECProgressBar.SetPosition(AValue: Double);
begin
  if ([csLoading, csDestroying]*ComponentState=[]) and (UpdateCount=0) then
    if AValue<Min 
      then AValue:=Min
      else if AValue>Max then AValue:=Max;
  if FPosition=AValue then exit;
  FPosition:=AValue;
  if PositionToHint then Hint:=Scale.GetStringPosition(Position, ProgressDigits);
  if UpdateCount=0 then
    begin
      if HandleAllocated then InvalidateCustomRect(True);
      if assigned(FOnChange) then FOnChange(self);
    end;
end;

{ TCustomECProgressBar.Setters }

procedure TCustomECProgressBar.SetCaptionInline(AValue: Boolean);
begin
  if FCaptionInline=AValue then exit;
  FCaptionInline:=AValue;
  RecalcRedraw;
end;

procedure TCustomECProgressBar.SetKind(AValue: TProgressKind);
begin
  if FKind=AValue then exit;
  FKind:=AValue;
  if AValue>epkProgress then
    begin
      if not assigned(Timer) then
        begin
          Timer:=TCustomTimer.Create(self);
          Timer.Interval:=50;
          Timer.OnTimer:=@DoMarquee;
          Timer.Enabled:=not (csDesigning in ComponentState);
        end;
      MarqueeInc:=True;
      MarqueePos:=0;
    end else
      FreeAndNil(Timer);
  Redraw;
end;

procedure TCustomECProgressBar.SetProgressDigits(AValue: Word);
begin
  if FProgressDigits=AValue then exit;
  FProgressDigits:=AValue;
  if ProgressTextStyle>eptNone then InvalidateNonUpdated;
end;       

procedure TCustomECProgressBar.SetProgressTextAlign(AValue: SmallInt);
begin
  if FProgressTextAlign=AValue then exit;
  FProgressTextAlign:=AValue;
  if ProgressTextStyle<>eptNone then InvalidateNonUpdated;
end;           

procedure TCustomECProgressBar.SetProgressTextStyle(AValue: TProgressTextStyle);
begin
  if FProgressTextStyle=AValue then exit;
  FProgressTextStyle:=AValue;
  InvalidateNonUpdated;
end;

procedure TCustomECProgressBar.SetUnits(const AValue: string);
begin
  if FUnits=AValue then exit;
  FUnits:=AValue;
  InvalidateNonUpdated;
end;      

{ TCustomECPositionBar }

constructor TCustomECPositionBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCursorBkgnd:=Cursor;
  FMouseDragPxFine:=cDefMouseDragPxFine;
  FMouseDragPx:=cDefMouseDragPx;
  Indent:=cDefIndent;
  AccessibleRole:=larTrackBar;
end;

procedure TCustomECPositionBar.CalcInvalidRectDyn;
var aCurrentPosition: Integer;
    aRect: TRect;
begin
  {$IFDEF DBGPROGBAR} DebugLn('TCustomECPositionBar.CalcInvalidRectDyn'); {$ENDIF}
  if Orientation=eooHorizontal
    then FInvalidRect.Bottom:=FInvRectLimit       
    else FInvalidRect.Right:=FInvRectLimit;
  aRect:=FInvalidRect;
  aCurrentPosition:=round(((Position-Scale.Min)/(Scale.Max-Scale.Min))*FGrooveInnerLength);
  if not (esfRealReversed in Flags)
    then aCurrentPosition:=FGrooveMin+aCurrentPosition
    else aCurrentPosition:=FGrooveMax-aCurrentPosition-1;
  if (ProgressTextStyle=eptNone) and (ProgressSign or (ProgressVisible=epvProgress)) then
    if Orientation=eooHorizontal then
      begin  { horizontal }
        {$IFDEF DBGPROGBAR} DebugLn('aR.L ', intToStr(aRect.Left), ' aR.R ', intToStr(aRect.Right),
          ' aCP ', intToStr(aCurrentPosition), ' aR.C ', intToStr((aRect.Left+aRect.Right) div 2)); {$ENDIF}
        if ((aRect.Left+aRect.Right) div 2)<aCurrentPosition then
          begin  { moves right }
            {$IFDEF DBGPROGBAR} DebugLn('MoveRight'); {$ENDIF}
            FInvalidRect.Right:=aCurrentPosition+ProgressMarkSize;
          end else  { moves left }
          begin
            {$IFDEF DBGPROGBAR} DebugLn('MoveLeft'); {$ENDIF}
            FInvalidRect.Left:=aCurrentPosition-ProgressMarkSize;
          end;
      end else  { vertical }
        if ((aRect.Top+aRect.Bottom) div 2)<aCurrentPosition
          then FInvalidRect.Bottom:=aCurrentPosition+ProgressMarkSize  { moves down }
          else FInvalidRect.Top:=aCurrentPosition-ProgressMarkSize;    { moves up }
  if not (esfPrevInvRectPainted in Flags) then UnionRect(FInvalidRect, aRect, FInvalidRect);
  inc(FInvalidRect.Right); 
  inc(FInvalidRect.Bottom);
end;                   
              
procedure TCustomECPositionBar.CalcProgressInvRect;
var aMin, aMax: Integer;
    
  procedure CalcProgressInvRectLimit;
  var  i: SmallInt;
  begin
    if not (esfRealReversed in Flags) then
        begin
          aMin:=FGrooveMin+round(GetRelPxPos);
          aMax:=aMin;
        end else 
        begin
          aMin:=FGrooveMax-round(GetRelPxPos)-1;
          aMax:=aMin;
        end;
    if ProgressSign then
      begin
        i:=ProgressMarkSize;
        dec(aMin, i);
        inc(i);
        inc(aMax, i);
      end;
  end;    
    
begin
  if Orientation=eooHorizontal then 
    begin
      if (ProgressTextStyle=eptNone) and (ProgressSign or (ProgressVisible=epvProgress)) then
        begin
          CalcProgressInvRectLimit;
          FInvalidRect.Left:=aMin;
          FInvalidRect.Right:=aMax;
        end else 
        begin
          FInvalidRect.Left:=FGrooveMin;
          FInvalidRect.Right:=FGrooveMax;
        end;
    end else
    begin
      if (ProgressTextStyle=eptNone) and (ProgressSign or (ProgressVisible=epvProgress)) then  
        begin
          CalcProgressInvRectLimit;
          FInvalidRect.Top:=aMin;
          FInvalidRect.Bottom:=aMax;
        end else  
        begin
          FInvalidRect.Top:=FGrooveMin;
          FInvalidRect.Bottom:=FGrooveMax;
        end;
    end;          
end;   

procedure TCustomECPositionBar.ChangeCursors(AMouseHoverDragArea: Boolean);
begin           
  include(Flags, esfCursorLock);
  if AMouseHoverDragArea 
    then if Orientation=eooHorizontal 
           then Cursor:=crSizeWE
           else Cursor:=crSizeNS
    else Cursor:=FCursorBkgnd;
  exclude(Flags, esfCursorLock);
end;  

function TCustomECPositionBar.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var d: Double;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
    begin
      d:=MouseDragPixels;
      if ssModifier in Shift then d:=d/MouseDragPixelsFine;
      if not (esfRealReversed in Flags)
        then Position:=Position+d
        else Position:=Position-d;
      Result:=True;
    end;
end;

function TCustomECPositionBar.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
var d: Double;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
    begin
      d:=MouseDragPixels;
      if ssModifier in Shift then d:=d/MouseDragPixelsFine;
      if not (esfRealReversed in Flags)
        then Position:=Position-d
        else Position:=Position+d;
      Result:=True;
    end;
end;

procedure TCustomECPositionBar.DrawGroove;
var aColor, aInvColor: TColor;
    aPos, i, j: Integer;
    aRect: TRect;
begin
  inherited DrawGroove;
  if ProgressSign and (ProgressMarkSize>=1) then
    with Canvas do
      begin              
        aColor:=GetColorResolvingDefAndEnabled(ProgressFontOptions.FontColor, clBtnText, IsEnabled);
        aColor:=ColorToRGB(aColor);
        aInvColor:=GetMergedColor(aColor, InvertColor(aColor), 0.25);
        Pen.Color:=aColor;
        Pen.Style:=psSolid;
        Pen.Width:=1;
        aPos:=GetRelGroovePos;
        aRect:=FGrooveRect;
        i:=GrooveBevelWidth;
        InflateRect(aRect, -i, -i);
        ClipRect:=aRect;
        Clipping:=True;
        if Orientation=eooHorizontal then
          begin  { horizontal }
            if not (esfRealReversed in Flags)
              then inc(aPos, aRect.Left)
              else aPos:=aRect.Right-aPos;
            for i:=1 to ProgressMarkSize-1 do
              begin
                j:=aRect.Top+i+1;
                Line(aPos-i, j, aPos+i+1, j);
                Pixels[aPos-i-1, j]:=aInvColor;
                Pixels[aPos+i+1, j]:=aInvColor;
                j:=aRect.Bottom-i-2;
                Line(aPos-i, j, aPos+i+1, j);
                Pixels[aPos-i-1, j]:=aInvColor;
                Pixels[aPos+i+1, j]:=aInvColor; 
              end;
            Pen.Color:=aInvColor;
            i:=ProgressMarkSize;
            j:=aRect.Top+1;
            Pixels[aPos, j]:=aColor;
            Pixels[aPos-1, j]:=aInvColor;
            Pixels[aPos+1, j]:=aInvColor;
            inc(j, i);
            Line(aPos-i+1, j, aPos+i, j);
            j:=aRect.Bottom-2;
            Pixels[aPos, j]:=aColor;
            Pixels[aPos-1, j]:=aInvColor;
            Pixels[aPos+1, j]:=aInvColor;    
            dec(j, i);
            Line(aPos-i+1, j, aPos+i, j); 
          end else
          begin  { vertical }
            if not Reversed
              then inc(aPos, aRect.Top)
              else aPos:=aRect.Bottom-aPos;
            for i:=1 to ProgressMarkSize-1 do
              begin
                j:=aRect.Left+i+1;
                Line(j, aPos-i, j, aPos+i+1);
                Pixels[j, aPos-i-1]:=aInvColor;
                Pixels[j, aPos+i+1]:=aInvColor;
                j:=aRect.Right-i-2;
                Line(j, aPos-i, j, aPos+i+1);
                Pixels[j, aPos-i-1]:=aInvColor;
                Pixels[j, aPos+i+1]:=aInvColor;
              end;
            Pen.Color:=aInvColor;
            j:=ProgressMarkSize; 
            i:=aRect.Left+1;
            Pixels[i, aPos]:=aColor;
            Pixels[i, aPos-1]:=aInvColor;
            Pixels[i, aPos+1]:=aInvColor;
            inc(i, j);
            Line(i, aPos-j+1, i, aPos+j);
            i:=aRect.Right-2;
            Pixels[i, aPos]:=aColor;
            Pixels[i, aPos-1]:=aInvColor;
            Pixels[i, aPos+1]:=aInvColor;
            dec(i, j);
            Line(i, aPos-j+1, i, aPos+j);
          end;
        Clipping:=False;
      end;
end;     

procedure TCustomECPositionBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aMousePos: Double;
begin
  inherited MouseDown(Button, Shift, X, Y);
  case Button of 
    mbLeft:
      begin
        if Orientation=eooHorizontal
          then aMousePos:=GetPosFromCoord(X)
          else aMousePos:=GetPosFromCoord(Y);
        if not (esfRealReversed in Flags)
          then aMousePos:=Min+aMousePos
          else aMousePos:=Max-aMousePos;
        if (esfDragAreaEntered in Flags) then
          begin  { left click on drag area}
            if Orientation=eooHorizontal then 
              begin
                InitCoord:=X;
                InitDelta:=GetPosFromCoord(X)-Position
              end else 
              begin
                InitCoord:=Y;
                InitDelta:=GetPosFromCoord(Y)-Position;
              end;
            include(Flags, esfDragState);
          end else  { middle or double click }
            Position:=aMousePos;
      end;
    mbMiddle: 
      if not ProgressFromMiddle
        then Position:=0.5*(Max+Min)
        else Position:=ProgressMiddlePos;
  end;
end;

procedure TCustomECPositionBar.MouseMove(Shift: TShiftState; X, Y: Integer);
const cTolerance = 5;
var aInit, aPosition: Integer;
    bCTRLDown, bPrevDragAreaEntered: Boolean;
begin
  inherited MouseMove(Shift, X, Y);
  if IsEnabled then
    begin  
      aPosition:=GetRelGroovePos+GrooveBevelWidth;
      if not (esfDragState in Flags) then
        begin
          bPrevDragAreaEntered:=(esfDragAreaEntered in Flags);
          if Orientation=eooHorizontal then
            begin  { horizontal }
              if not (esfRealReversed in Flags)
                then aPosition:=aPosition+FGrooveRect.Left
                else aPosition:=FGrooveRect.Right-aPosition;
              if ((Y>=FGrooveRect.Top) and (Y<=FGrooveRect.Bottom)
                and (X>=(aPosition-cTolerance)) and (X<=(aPosition+cTolerance)))
                then include(Flags, esfDragAreaEntered)
                else exclude(Flags, esfDragAreaEntered);
            end else
            begin  { vertical }
              if not Reversed
                then aPosition:=aPosition+FGrooveRect.Top
                else aPosition:=FGrooveRect.Bottom-aPosition;
              if ((X>=FGrooveRect.Left) and (X<=FGrooveRect.Right)
                and (Y>=(aPosition-cTolerance)) and (Y<=(aPosition+cTolerance)))
                then include(Flags, esfDragAreaEntered)
                else exclude(Flags, esfDragAreaEntered);
            end;
          if (esfDragAreaEntered in Flags)<>bPrevDragAreaEntered
            then ChangeCursors(esfDragAreaEntered in Flags);
        end else
        begin
          bCTRLDown:=(ssModifier in Shift);
          if bCTRLDown<>(esfPrevCTRLDown in Flags) then
            if Orientation=eooHorizontal then
              begin
                InitCoord:=X;
                InitDelta:=GetPosFromCoord(X)-Position
              end else
              begin
                InitCoord:=Y;
                InitDelta:=GetPosFromCoord(Y)-Position;
              end;
          aInit:=InitCoord;
          if Orientation=eooHorizontal 
            then aPosition:=X-aInit
            else aPosition:=Y-aInit;
          if not bCTRLDown 
            then aPosition:=aPosition div MouseDragPixels
            else aPosition:=aPosition div MouseDragPixelsFine;
          if not (esfRealReversed in Flags)
            then Position:=GetPosFromCoord(aInit+aPosition)-InitDelta
            else Position:=GetPosFromCoord(aInit-aPosition)-InitDelta;
          if bCTRLDown
            then include(Flags, esfPrevCTRLDown)
            else exclude(Flags, esfPrevCTRLDown);
        end;   
    end;
end;

procedure TCustomECPositionBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if esfDragState in Flags then
    begin
      exclude(Flags, esfDragState);
      if not (esfDragAreaEntered in Flags) then ChangeCursors(False);
    end;        
  if ShowHint and PositionToHint then Application.ActivateHint(Mouse.CursorPos);
end;                 

procedure TCustomECPositionBar.SetCursor(Value: TCursor);
begin
  inherited SetCursor(Value);
  if not (esfCursorLock in Flags) then FCursorBkgnd:=Value;
end;     

{ Setters }

procedure TCustomECPositionBar.SetProgressSign(AValue: Boolean);
begin
  if FProgressSign=AValue then exit;
  FProgressSign:=AValue;
  InvalidateNonUpdated;
end;

{ TECSpinBtnsPos }

constructor TECSpinBtnsPos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csNoDesignSelectable];
  SetSubComponent(True);
end;

procedure TECSpinBtnsPos.RecalcRedraw;
begin
  inherited RecalcRedraw;
  if UpdateCount=0 then
    begin
      CalcInternalGeometry;
      AdjustWidth;
      (Owner as TECSpinPosition).SetSpinBtnsPosition;
      RedrawMode:=ermRedrawBkgnd;
      Invalidate;
    end;
end;

procedure TECSpinBtnsPos.Resize;
begin
  inherited Resize;
  if assigned(CustomResize) then CustomResize;
end;

{ TECSpinPosSpacing }

function TECSpinPosSpacing.GetSpace(Kind: TAnchorKind): Integer;
begin
  Result:=inherited GetSpace(Kind);
  case Kind of
    akLeft:  if Control.IsRightToLeft then
               inc(Result, TECSpinPosition(Control).FSpinBtns.Width+TECSpinPosition(Control).IndentBtns);
    akRight: if not Control.IsRightToLeft then
               inc(Result, TECSpinPosition(Control).FSpinBtns.Width+TECSpinPosition(Control).IndentBtns);
  end;
end;

procedure TECSpinPosSpacing.GetSpaceAround(var SpaceAround: TRect);
var aIndentButtonWidth: Integer;
begin
  inherited GetSpaceAround(SpaceAround);
  with TECSpinPosition(Control) do
    aIndentButtonWidth:=FSpinBtns.Width+IndentBtns;
  if not Control.IsRightToLeft
    then inc(SpaceAround.Right, aIndentButtonWidth)
    else inc(SpaceAround.Left, aIndentButtonWidth);
end;

{ TECSpinPosition }

constructor TECSpinPosition.Create(AOwner: TComponent);
begin
  FSpinBtns:=TECSpinBtnsPos.Create(self);
  inherited Create(AOwner);
  ControlStyle:=ControlStyle-[csSetCaption];
  FIndentBtns:=cDefIndentBtns;
  FScale.TickVisible:=etvNone;
  FScale.ValueVisible:=evvNone;
  with FSpinBtns do
    begin
      CustomChange:=@ChangePosition;
      Name:='ECSpinPosButtons';
      AnchorParallel(akTop, 0, self);
      AnchorParallel(akBottom, 0, self);
      Middle:=0.5*(Scale.Min+Scale.Max);
      CustomResize:=@SetSpinBtnsPosition;
    end;
end;

destructor TECSpinPosition.Destroy;
begin
  FreeAndNil(FSpinBtns);
  inherited Destroy;
end;

procedure TECSpinPosition.ChangePosition;
begin
  Position:=FSpinBtns.Value;
end;

procedure TECSpinPosition.CMBiDiModeChanged(var Message: TLMessage);
begin
  inherited CMBiDiModeChanged(Message);
  FSpinBtns.BiDiMode:=BiDiMode;
  SetSpinBtnsPosition;
end;

function TECSpinPosition.CreateControlBorderSpacing: TControlBorderSpacing;
begin
  Result:=TECSpinPosSpacing.Create(self);
end;

procedure TECSpinPosition.DoOnChangeBounds;
begin
  inherited DoOnChangeBounds;
  SetSpinBtnsPosition;
end;

procedure TECSpinPosition.InitializeWnd;
begin
  inherited InitializeWnd;
  SetSpinBtnsPosition;
end;

procedure TECSpinPosition.RecalcRedraw;
begin
  FSpinBtns.Max:=Scale.Max;
  FSpinBtns.Min:=Scale.Min;
  inherited RecalcRedraw;
end;

procedure TECSpinPosition.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(Value);
  FSpinBtns.Enabled:=Value;
end;

procedure TECSpinPosition.SetMax(const AValue: Double);
begin
  inherited SetMax(AValue);
  FSpinBtns.Max:=Scale.Max;
end;

procedure TECSpinPosition.SetMin(const AValue: Double);
begin
  inherited SetMin(AValue);
  FSpinBtns.Min:=Scale.Min;
end;

procedure TECSpinPosition.SetParent(NewParent: TWinControl);
begin
  if assigned(FSpinBtns) then FSpinBtns.Anchors:=[];
  inherited SetParent(NewParent);
  if assigned(FSpinBtns) then
    begin
      FSpinBtns.Parent:=Parent;
      FSpinBtns.Anchors:=[akTop, akBottom];
    end;
end;

procedure TECSpinPosition.SetPosition(AValue: Double);
begin
  inherited SetPosition(AValue);
  FSpinBtns.CustomChange:=nil;
  FSpinBtns.Value:=AValue;
  FSpinBtns.CustomChange:=@ChangePosition;
end;

procedure TECSpinPosition.SetSpinBtnsPosition;
begin
  if not IsRightToLeft
    then FSpinBtns.Left:=Left+Width+IndentBtns
    else FSpinBtns.Left:=Left-IndentBtns-FSpinBtns.Width;
end;

procedure TECSpinPosition.VisibleChanged;
begin
  inherited VisibleChanged;
  FSpinBtns.Visible:=Visible;
  if assigned(OnVisibleChanged) then OnVisibleChanged(self, Visible);
end;

{ TECSpinPosition.Getters & Setters }

function TECSpinPosition.GetController: TECSpinController;
begin
  Result:=Buttons.FController;
end;

function TECSpinPosition.GetWidthInclBtn: Integer;
begin
  Result:=Width+IndentBtns+FSpinBtns.Width;
end;

procedure TECSpinPosition.SetController(AValue: TECSpinController);
begin
  {$IFDEF DBGPROGBAR} DebugLn('TECSpinPosition.SetController'); {$ENDIF}
  if Buttons.FController=AValue then exit;
  if assigned(Buttons.FController) then Buttons.FController.UnRegisterClient(self);
  Buttons.FController:=AValue;
  if assigned(AValue) then AValue.RegisterClient(self);
end;

procedure TECSpinPosition.SetIndentBtns(AValue: SmallInt);
begin
  if FIndentBtns=AValue then exit;
  FIndentBtns:=AValue;
  SetSpinBtnsPosition;
end;

procedure TECSpinPosition.SetWidthInclBtn(AValue: Integer);
begin
  Width:=AValue-IndentBtns-FSpinBtns.Width;
end;

end.


