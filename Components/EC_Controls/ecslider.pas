{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)

  Copyright (C) 2013-2020 Vojtěch Čihák, Czech Republic

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

unit ECSlider;
{$mode objfpc}{$H+}  

//{$DEFINE DBGSLIDER}  {don't remove, just comment}

interface

uses
  Classes, SysUtils, Controls, Forms, Graphics, ImgList, LCLIntf, {$IFDEF DBGSLIDER} LCLProc, {$ENDIF}
  LCLType, LMessages, Math, Themes, Types, ECScale, ECTypes;

type
  {$PACKENUM 2}
  TProgressMark = (epmNone, epmTickSide, epmOpposite, epmBoth);
  TProgressStyle = (epsSimple, epsAesthetic, epsGradient, epsReversedGrad, epsOrthogonal,
                    epsOrthoTwin, epsGradLines, epsRipple);
  TProgressVisibility = (epvNone, epvProgress, epvFull);
  TSFlag = (esfCursorLock,
            esfDragAreaEntered,
            esfDragState,
            esfPrevCTRLDown,         { wheter CTRL was pressed in previous MouseMove }
            esfPrevInvRectPainted,
            esfRealReversed,
            esfWasEnabled);          { IsEnabled in previous Paint; }
  TSFlags = set of TSFlag;
  TTickMarks = (etmBottomRight, etmTopLeft, etmBoth);
  { event }
  TOnDrawProgressBMP = procedure(Sender: TObject; AProgress: TBitmap) of object;
  
  { TBaseECSlider }
  TBaseECSlider = class abstract(TECBaseControl)
  private
    FCaptionPos: TObjectPos;
    FGrooveColor: TColor;
    FGrooveStyle: TObjectStyle;
    FImageIndex: TImageIndex;  { Image }
    FImagePos: TObjectPos;
    FImages: TCustomImageList;
    FIndent: SmallInt;
    FOnDrawProgressBMP: TOnDrawProgressBMP;
    FPositionToHint: Boolean;
    FProgressColor: TColor;  { Progress }
    FProgressColor2: TColor;
    FProgressFromMiddle: Boolean;
    FProgressMark: TProgressMark;
    FProgressParameter: SmallInt;
    FProgressStyle: TProgressStyle;
    FProgressVisible: TProgressVisibility;
    FReversed: Boolean;
    FScaleFontOptions: TFontOptions;  { Scale }
    FScaleTickPos: TTickMarks;
    FScaleValuePos: TTickMarks;
    {$IFDEF DBGSLIDER} FRepaintCounter: Integer; {$ENDIF}
    function GetLogarithmicPosition: Double;
    function GetMax: Double;
    function GetMin: Double;      
    procedure SetCaptionPos(AValue: TObjectPos);
    procedure SetGrooveBevelWidth(const AValue: SmallInt);
    procedure SetGrooveColor(const AValue: TColor);
    procedure SetGrooveStyle(const AValue: TObjectStyle);
    procedure SetGrooveTransparent(const AValue: Boolean);
    procedure SetGrooveWidth(const AValue: SmallInt);
    procedure SetImageIndex(const AValue: TImageIndex);
    procedure SetImagePos(AValue: TObjectPos);
    procedure SetImages(const AValue: TCustomImageList);
    procedure SetIndent(const AValue: SmallInt);
    procedure SetLogarithmicPosition(AValue: Double);
    procedure SetProgressColor(const AValue: TColor);
    procedure SetProgressColor2(const AValue: TColor);
    procedure SetProgressFromMiddle(const AValue: Boolean);
    procedure SetProgressMark(const AValue: TProgressMark);
    procedure SetProgressMarkSize(AValue: SmallInt);
    procedure SetProgressMiddlePos(const AValue: Double);
    procedure SetProgressParameter(AValue: SmallInt);
    procedure SetProgressStyle(const AValue: TProgressStyle);
    procedure SetProgressVisible(AValue: TProgressVisibility);
    procedure SetReversed(AValue: Boolean);
    procedure SetScaleTickPos(const AValue: TTickMarks);
    procedure SetScaleValuePos(const AValue: TTickMarks);
  protected const
    cDefProgParameter = 4;
  protected
    FGrooveBevelWidth: SmallInt;
    FGrooveInnerLength: SmallInt;  { FGrooveMax-FGrooveMin }
    FGrooveMax: SmallInt;  
    FGrooveMin: SmallInt; 
    FGrooveMiddle: SmallInt;
    FGrooveTransparent: Boolean;
    FGrooveWidth: SmallInt;
    FInvRectLimit: Integer;
    FOnChange: TNotifyEvent;
    FPosition: Double;
    FProgressMiddlePos: Double;
    FProgressMarkSize: SmallInt;
    FScale: TECScale;
  protected
    Background: TBitmap;
    Flags: TSFlags;
    GrooveBMP: TBitmap;
    FGrooveRect: TRect;
    FMinL, FMaxL, FTLStart: Integer;
    FCaptionPoint: TPoint;
    FImagePoint: TPoint;
    RealCaptionPos: TObjectPos;  { RealXxxxx fields takes BiDiMode into account }
    RealImagePos: TObjectPos;
    procedure CalcGrooveMiddle; virtual; abstract;
    procedure CalcInvalidRectDyn; virtual; abstract;
    procedure CalcInvalidRectStat; virtual; abstract;
    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer; 
                                     {%H-}WithThemeSpace: Boolean); override;
    procedure Calculate;
    procedure CMBiDiModeChanged(var {%H-}Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var {%H-}Message: TLMessage); message CM_COLORCHANGED;
    procedure CMHintShow(var Message: TLMessage); message CM_HINTSHOW;
    procedure CMParentColorChanged(var Message: TLMessage); message CM_PARENTCOLORCHANGED;
    procedure CorrectGrooveHorizontalLength(var {%H-}x1, {%H-}x2: Integer); virtual;
    procedure CorrectGrooveLength(var z1, z2: Integer; AVertical: Boolean); virtual; abstract;
    procedure DrawBackground;
    procedure DrawGrooveBMP;
    procedure DrawGroove; virtual;
    procedure FontChanged(Sender: TObject); override;
    function GetGrooveOverhang({%H-}AFullGrooveWidth: Integer): Integer; virtual;
    function GetKnobOverhangScale({%H-}AGrooveWidth: Integer): Integer; virtual; 
    function GetPosFromCoord(ACoord: Integer): Double;
    function GetRelGroovePos: Integer; virtual; abstract;
    function GetRelPxPos: Double;
    procedure InvalidateCustomRect(AMove: Boolean); override;
    procedure OrientationChanged(AValue: TObjectOrientation); override;
    procedure Paint; override;
    procedure PaintSelf(AEnabled: Boolean); virtual; abstract;
    procedure RecalcRedraw; override;
    procedure Redraw3DColorAreas; override;
    procedure SetGrooveBoundsHorz(x1, x2, y1, y2: Integer); virtual; abstract;
    procedure SetGrooveBoundsVert(x1, x2, y1, y2: Integer); virtual; abstract;
    procedure SetMax(const AValue: Double); virtual;
    procedure SetMin(const AValue: Double); virtual;
    procedure SetPosition(AValue: Double); virtual; abstract;
    function SetRealBiDiVariables: Boolean;
    procedure TextChanged; override;
    procedure WMSize(var Message: TLMSize); message LM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    procedure EndUpdate(Recalculate: Boolean=True); override;
    procedure Redraw; override;
    property CaptionPos: TObjectPos read FCaptionPos write SetCaptionPos default eopTop;
    property GrooveBevelWidth: SmallInt read FGrooveBevelWidth write SetGrooveBevelWidth default 1;
    property GrooveColor: TColor read FGrooveColor write SetGrooveColor default clDefault;
    property GrooveStyle: TObjectStyle read FGrooveStyle write SetGrooveStyle default eosPanel;
    property GrooveTransparent: Boolean read FGrooveTransparent write SetGrooveTransparent default True;
    property GrooveWidth: SmallInt read FGrooveWidth write SetGrooveWidth;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property ImagePos: TObjectPos read FImagePos write SetImagePos default eopTop;
    property Images: TCustomImageList read FImages write SetImages;
    property Indent: SmallInt read FIndent write SetIndent default 5;
    property LogarithmicPosition: Double read GetLogarithmicPosition write SetLogarithmicPosition;
    property Max: Double read GetMax write SetMax stored False;
    property Min: Double read GetMin write SetMin stored False;
    property Position: Double read FPosition write SetPosition;
    property PositionToHint: Boolean read FPositionToHint write FPositionToHint default False;
    property ProgressColor: TColor read FProgressColor write SetProgressColor default clDefault;
    property ProgressColor2: TColor read FProgressColor2 write SetProgressColor2 default clDefault;
    property ProgressFromMiddle: Boolean read FProgressFromMiddle write SetProgressFromMiddle default False;
    property ProgressMark: TProgressMark read FProgressMark write SetProgressMark default epmTickSide;
    property ProgressMarkSize: SmallInt read FProgressMarkSize write SetProgressMarkSize;
    property ProgressMiddlePos: Double read FProgressMiddlePos write SetProgressMiddlePos;
    property ProgressParameter: SmallInt read FProgressParameter write SetProgressParameter default cDefProgParameter;
    property ProgressStyle: TProgressStyle read FProgressStyle write SetProgressStyle default epsSimple;
    property ProgressVisible: TProgressVisibility read FProgressVisible write SetProgressVisible default epvProgress;
    property Reversed: Boolean read FReversed write SetReversed default False;
    property Scale: TECScale read FScale write FScale;
    property ScaleFontOptions: TFontOptions read FScaleFontOptions write FScaleFontOptions;
    property ScaleTickPos: TTickMarks read FScaleTickPos write SetScaleTickPos default etmBottomRight;
    property ScaleValuePos: TTickMarks read FScaleValuePos write SetScaleValuePos default etmBottomRight;
    property Style default eosButton;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDrawProgressBMP: TOnDrawProgressBMP read FOnDrawProgressBMP write FOnDrawProgressBMP; 
  end;

  { TECSliderKnob }
  TECSliderKnob = class(TECCustomKnob)     
  published
    property BevelWidth;
    property Color;
    property Cursor;
    property Height;
    property Style;
    property TickMarkCount;
    property TickMarkDesign;
    property TickMarkSpacing;
    property TickMarkStyle;
    property Width; 
  end;         

  { TCustomECSlider }
  TCustomECSlider = class(TBaseECSlider)
  private
    FDiscreteChange: Double;
    FIncrement: Double;
    FKnob: TECSliderKnob;
    FKnobDragPos: TPoint;
    FKnobDragState: Boolean;
    FMode: TIncrementalMode;
    FPageSize: Double;
    FRelScaleLength: SmallInt;
    function GetRelScaleLength: Single;
    procedure SetDiscreteChange(const AValue: Double);
    procedure SetMode(const AValue: TIncrementalMode);
    procedure SetRelScaleLength(AValue: Single);
  protected const
    cDefGrooveWidth = 6;
    cDefProgMarkSize = 4;
    cScaleIndent = 6;
  protected
    FCursorBkgnd: TCursor;
    procedure CalcGrooveMiddle; override;
    procedure CalcInvalidRectDyn; override;
    procedure CalcInvalidRectStat; override;
    procedure ChangeCursors(AMouseHoverKnob: Boolean);
    procedure CMColorChanged(var Message: TLMessage); message CM_COLORCHANGED;
    procedure CMParentColorChanged({%H-}var Message: TLMessage); message CM_PARENTCOLORCHANGED;
    procedure CorrectGrooveHorizontalLength(var x1, x2: Integer); override;
    procedure CorrectGrooveLength(var z1, z2: Integer; AVert: Boolean); override;
    procedure DblClick; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function GetGrooveOverhang(AFullGrWidth: Integer): Integer; override;
    function GetKnobOverhangScale(AGrooveWidth: Integer): Integer; override;
    function GetRelGroovePos: Integer; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure OrientationChanged(AValue: TObjectOrientation); override;
    procedure PaintSelf(AEnabled: Boolean); override;
    procedure PlaceKnob(AInvalidate: Boolean);
    procedure Redraw3DColorAreas; override;
    procedure SetCursor(Value: TCursor); override;
    procedure SetGrooveBoundsHorz(x1, x2, y1, y2: Integer); override;
    procedure SetGrooveBoundsVert(x1, x2, y1, y2: Integer); override;
    procedure SetKnobBackground;
    procedure SetPosition(AValue: Double); override;
    procedure StyleChanged(AValue: TObjectStyle); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    procedure EndUpdate(Recalculate: Boolean=True); override;
    property DiscreteChange: Double read FDiscreteChange write SetDiscreteChange;
    property Increment: Double read FIncrement write FIncrement;
    property Knob: TECSliderKnob read FKnob write FKnob;
    property Mode: TIncrementalMode read FMode write SetMode default eimContinuous;
    property PageSize: Double read FPageSize write FPageSize;
    property RelativeScaleLength: Single read GetRelScaleLength write SetRelScaleLength;
  end;

  { TECSlider }
  TECSlider = class(TCustomECSlider)
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
    property CaptionPos;
    property Color;
    property Color3DDark;
    property Color3DLight;
    property Constraints;
    property DiscreteChange;
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
    property Increment;
    property Indent;
    property Max;
    property Min;
    property Mode;
    property Orientation default eooVertical;
    property Knob;  { stream Knob after Orientation, important for loading *.lfm }
    property PageSize;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property PositionToHint;
    property ProgressColor;
    property ProgressColor2;
    property ProgressFromMiddle;
    property ProgressMark;
    property ProgressMarkSize default cDefProgMarkSize;
    property ProgressMiddlePos;
    property ProgressParameter;
    property ProgressStyle;
    property ProgressVisible;
    property RelativeScaleLength;
    property Reversed;
    property Scale;
    property ScaleFontOptions;
    property ScaleTickPos;
    property ScaleValuePos;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop default True;
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
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
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
    property OnStartDrag;
    property OnUTF8KeyPress;
  end;

implementation

const caRealPositions: array[TObjectPos, Boolean] of TObjectPos =
        ((eopTop, eopTop), (eopRight, eopLeft), (eopBottom, eopBottom), (eopLeft, eopRight));

{ TBaseECSlider }

constructor TBaseECSlider.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csClickEvents, csDoubleClicks, csSetCaption];
  Align:=alNone;
  AutoSize:=True;
  Flags:=[esfWasEnabled];
  FScaleFontOptions:=TFontOptions.Create(self);
  with FScaleFontOptions do
    begin
      FontSize:=7;
      FontStyles:=[];
      OnRecalcRedraw:=@RecalcRedraw;
      OnRedraw:=@Redraw;
    end;
  FGrooveBevelWidth:=1;
  FGrooveColor:=clDefault;
  FGrooveStyle:=eosPanel;
  FGrooveTransparent:=True;
  FImageIndex:=-1;
  FIndent:=5;
  ParentColor:=True;
  ParentFont:=True;
  FPosition:=0; 
  GrooveBMP:=TBitmap.Create;
  GrooveBMP.Canvas.Brush.Style:=bsSolid;
  ProgressColor:=clDefault;
  ProgressColor2:=clDefault;
  FProgressMark:=epmTickSide;
  FProgressParameter:=cDefProgParameter;
  FProgressStyle:=epsSimple;
  FProgressVisible:=epvProgress;					
  FScale:=TECScale.Create(self);
  with FScale do
    begin
      OnRecalcRedraw:=@self.RecalcRedraw;
      OnRedraw:=@self.Redraw;
    end;
  Background:=TBitmap.Create;
  with Background do
    begin
      Transparent:=True;
      TransparentMode:=tmFixed;
    end;
  RedrawMode:=ermRecalcRedraw;
end;

destructor TBaseECSlider.Destroy;
begin
  FreeAndNil(Background);
  FreeAndNil(GrooveBMP);
  FreeAndNil(FScale);
  FreeAndNil(FScaleFontOptions);
  inherited Destroy;
end;

procedure TBaseECSlider.CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer;
            WithThemeSpace: Boolean);
var aCaptionSize, aGrooveWidth, aImageSize, aKnobOverhang, aSize: Integer;
    bHorizontal: Boolean;	
begin
  bHorizontal:=(Orientation=eooHorizontal);
  aGrooveWidth:=GrooveWidth+2*GrooveBevelWidth; 
  aKnobOverhang:=GetKnobOverhangScale(aGrooveWidth);
  Canvas.Font.Assign(Font);
  Canvas.Font.Size:=FScaleFontOptions.FontSize;
  Canvas.Font.Style:=FScaleFontOptions.FontStyles;
  aSize:=aGrooveWidth;
  inc(aSize, Math.max(FScale.GetPreferredSize(Canvas, bHorizontal, 
    ScaleTickPos<>etmBottomRight, ScaleValuePos<>etmBottomRight), aKnobOverhang));
  inc(aSize, Math.max(FScale.GetPreferredSize(Canvas, bHorizontal, 
    ScaleTickPos<>etmTopLeft, ScaleValuePos<>etmTopLeft), aKnobOverhang));
  if HasCaption then
    begin
      Canvas.Font.Size:=self.Font.Size;
      Canvas.Font.Style:=self.Font.Style;
      if bHorizontal
        then aCaptionSize:=Canvas.TextHeight(Caption)
        else aCaptionSize:=Canvas.TextWidth(Caption);
    end else
      aCaptionSize:=0;
  if bHorizontal then
    begin  { horizontal }
      if (ImageIndex>=0) and assigned(FImages) 
        then aImageSize:=FImages.Height
        else aImageSize:=0;
      if RealCaptionPos in [eopTop, eopBottom] then
        begin
          if RealImagePos in [eopTop, eopBottom] then   
            begin  { Caption T/B, Image L/R }
              if (aSize>0) and (aCaptionSize>0)
                then aSize:=aSize+Indent+aCaptionSize
                else aSize:=aSize+aCaptionSize;
              aSize:=Math.max(aSize, aImageSize);
            end else
            begin  { Caption & Image T/B }  
              aCaptionSize:=Math.max(aCaptionSize, aImageSize);
              if (aSize>0) and (aCaptionSize>0)
                then aSize:=aSize+Indent+aCaptionSize
                else aSize:=aSize+aCaptionSize;  
            end;
        end else
        begin
          if RealImagePos in [eopTop, eopBottom] then   
            begin  { Caption L/R, Image over/below Caption } 
              if aCaptionSize*aImageSize>0
                then aCaptionSize:=aCaptionSize+Indent+aImageSize
                else aCaptionSize:=aCaptionSize+aImageSize;
              aSize:=Math.max(aSize, aCaptionSize);
            end else  { Caption L/R, Image L/R } 
            aSize:=Math.max(Math.max(aSize, aImageSize), aCaptionSize);
        end;
    end else 
    begin  { vertical }
      if (ImageIndex>=0) and assigned(FImages) then
        begin
          if (ImagePos in [eopTop, eopBottom]) or (aCaptionSize>0)
            then aSize:=Math.max(aSize, Math.max(aCaptionSize, FImages.Width))
            else aSize:=Math.max(aSize, aCaptionSize+Indent+FImages.Width);
        end else 
          aSize:=Math.max(aSize, aCaptionSize);
    end;
  inc(aSize, 2*(Indent+GetBorderWidth)); 
  if bHorizontal then
    begin
      PreferredHeight:=aSize;
      PreferredWidth:=0;      
    end else
    begin
      PreferredHeight:=0;
      PreferredWidth:=aSize;      
    end;  
end;         

procedure TBaseECSlider.BeginUpdate;
begin
  inherited BeginUpdate;
  FScale.BeginUpdate;
end;

procedure TBaseECSlider.Calculate;
var aMax, aSize, hI, hK, wI, wK, sG, sV, tlS, brS, x1, x2, y1, y2: Integer;
    eC: TSize;
  { br - bottomright, e - extent, h - Height, tl - topleft,  s - Size, w - Width, 
    C - Caption, G - Groove, I - Image, K - Knob, U - Units, V - Values }

  function IndentCoord(AObjectCoord, AObjectSize: Integer): Integer;  inline;
  begin
    Result:=AObjectCoord;
    if AObjectSize>0 then inc(Result, AObjectSize+Indent);
  end;

begin
  {$IFDEF DBGSLIDER} DebugLn('TBaseECSlider.Calculate'); {$ENDIF}
  if assigned(FImages) and (ImageIndex>=0) and (ImageIndex<FImages.Count) then
    begin  { set size of Image }
      wI:=FImages.Width;
      hI:=FImages.Height;
    end else
    begin
      wI:=0;
      hI:=0;
    end;
  Background.Canvas.Font.Assign(Font);
  if HasCaption  { set size of Caption }
    then eC:=Background.Canvas.TextExtent(Caption)
    else eC:=Size(0, 0);
  if (FScale.ValueVisible>evvNone) and ((FScale.ValueFormat=esvfDate) or (FScale.ValueFormat=esvfTime)) then
    begin
      FScale.DTFormat:=DefaultFormatSettings;
      FScale.DTFormat.LongTimeFormat:=FScale.DateTimeFormat;
    end;
  sG:=2*GrooveBevelWidth+GrooveWidth;  { GrooveWidth (or "Height") }
  y1:=GetBorderWidth+Indent; 
  y2:=Height-y1;
  x1:=y1;
  if Orientation=eooVertical then
    begin  { vertical }
      aMax:=0;
      if wI>0 then
        case ImagePos of
          eopTop: 
            begin
              FImagePoint.X:=(Width-wI) div 2;
              FImagePoint.Y:=y1;
              y1:=y1+hI+Indent;
            end;
          eopBottom: 
            begin
              FImagePoint.X:=(Width-wI) div 2;
              y2:=y2-hI;
              FImagePoint.Y:=y2;
              y2:=y2-Indent;
            end;
          otherwise
            aMax:=wI;
            if eC.cx>0 then inc(aMax, Indent);
        end;
      if (eC.cx+wI)>0 then
        begin           
          case ImagePos of
            eopLeft: 
              begin
                FImagePoint.X:=(Width-aMax-eC.cx) div 2;
                FCaptionPoint.X:=FImagePoint.X+aMax;
              end;
            eopRight: 
              begin
                FCaptionPoint.X:=(Width-aMax-eC.cx) div 2;
                FImagePoint.X:=FCaptionPoint.X+eC.cx;
                if eC.cx>0 then inc(FImagePoint.X, Indent);
              end;
            otherwise 
              FCaptionPoint.X:=(Width-eC.cx) div 2;
              aMax:=eC.cy;
          end;
          if ImagePos in [eopRight, eopLeft] then    
            begin
              aMax:=Math.max(eC.cy, hI); 
              if FCaptionPos<>eopBottom 
                then FImagePoint.Y:=y1+(aMax-hI) div 2
                else FImagePoint.Y:=y2-aMax+(aMax-hI) div 2;
            end;
          if FCaptionPos<>eopBottom then
            begin
              FCaptionPoint.Y:=y1+(aMax-eC.cy) div 2;
              y1:=y1+aMax;
              if (eC.cy>0) or (ImagePos in [eopRight, eopLeft]) then inc(y1, Indent);
            end else
            begin
              y2:=y2-aMax;
              FCaptionPoint.Y:=y2+(aMax-eC.cy) div 2;
              if (eC.cy>0) or (ImagePos in [eopRight, eopLeft]) then dec(y2, Indent);
            end;
        end;
      sV:=0;  { width of Values }
      if FScale.ValueVisible<>evvNone then
        begin
          FScaleFontOptions.ApplyTo(Background.Canvas.Font, clBtnText);
          sV:=FScale.GetPreferredValuesWidth(Background.Canvas);
        end;
      CorrectGrooveLength(y1, y2, True);  { TECProgressBar.GetGrooveLength needs Scale.Font set }
      if FScale.TickVisible<>etvNone 
        then aSize:=FScale.TickIndent+FScale.TickLength 
        else aSize:=0;
      wK:=GetGrooveOverhang(sG);  { set Knob's overhang }
      if FScaleTickPos<>etmBottomRight  { width on the left }
        then tlS:=aSize 
        else tlS:=0;  
      if FScaleTickPos<>etmTopLeft  { width on the right }
        then brS:=aSize 
        else brS:=0;      
      if FScaleValuePos<>etmBottomRight then inc(tlS, sV);
      if FScaleValuePos<>etmTopLeft then inc(brS, sV);
      tlS:=Math.max(wK, tlS);  { decide whether width of ticks+glyphs+values ... }
      brS:=Math.max(wK, brS);  { ... on the left/right is bigger than Knob's overhang }
      x1:=(Width-(tlS+brS+sG)) div 2 +tlS;
      x2:=x1+sG;
      FGrooveRect:=Rect(x1, y1, x2, y2);
      SetGrooveBoundsVert(x1, x2, y1, y2);
    end else
    begin  { horizontal }
      x2:=Width-x1;
      if RealCaptionPos in [eopTop, eopBottom] then
        begin
          aSize:=eC.cx;
          if RealImagePos in [eopRight, eopLeft] then
            begin
              if aSize*wI>0 then inc(aSize, Indent);
              inc(aSize, wI);
            end;
          case RealImagePos of
            eopLeft: 
              begin
                FImagePoint.X:=(Width-aSize) div 2;
                FCaptionPoint.X:=IndentCoord(FImagePoint.X, wI);
              end;
            eopRight: 
              begin
                FCaptionPoint.X:=(Width-aSize) div 2;
                FImagePoint.X:=IndentCoord(FCaptionPoint.X, eC.cx);
              end;
            eopTop: 
              begin
                FCaptionPoint.X:=(Width-aSize) div 2;
                FImagePoint.X:=x1;
                if wI>0 then inc(x1, wI+Indent);
              end;
            eopBottom: 
              begin
                FCaptionPoint.X:=(Width-aSize) div 2;
                dec(x2, wI);
                FImagePoint.X:=x2;
                if wI>0 then dec(x2, Indent);
              end;
          end;
        end;
      case RealCaptionPos of
        eopTop: 
          begin
            aMax:=eC.cy;
            if RealImagePos in [eopRight, eopLeft] then
              begin
                if hI>aMax then aMax:=hI;
                FImagePoint.Y:=y1+(aMax-hI) div 2;
              end else
                FImagePoint.Y:=(Height-hI) div 2;
            FCaptionPoint.Y:=y1+(aMax-eC.cy) div 2;
            if aMax>0 then inc(y1, aMax+FIndent);
          end;
        eopBottom: 
          begin
            aMax:=eC.cy;
            case RealImagePos of
              eopRight, eopLeft:
                begin
                  if hI>aMax then aMax:=hI;
                  dec(y2, aMax);
                  FImagePoint.Y:=y2+(aMax-hI) div 2;
                end;
              eopTop, eopBottom:
                begin
                  FImagePoint.Y:=(Height-hI) div 2;
                  dec(y2, aMax);
                end;
            end;
            FCaptionPoint.Y:=y2+(aMax-eC.cy) div 2;
            if aMax>0 then dec(y2, Indent);
          end;
        eopLeft: 
          begin
            case RealImagePos of
              eopTop, eopBottom:
                begin
                  aSize:=wI; 
                  aMax:=Math.max(eC.cx, aSize);
                  FCaptionPoint.X:=x1+(aMax-eC.cx) div 2;
                  FImagePoint.X:=x1+(aMax-aSize) div 2;
                  if aMax>0 then inc(x1, aMax+Indent);
                  aSize:=hI+eC.cy;
                  if hI*eC.cy<>0 then inc(aSize, FScale.ValueIndent);
                  if RealImagePos=eopTop then
                    begin
                      FCaptionPoint.Y:=(Height+aSize) div 2 -eC.cy;
                      FImagePoint.Y:=FCaptionPoint.Y-aSize+eC.cy;
                    end else
                    begin  { eopBottom }
                      FCaptionPoint.Y:=(Height-aSize) div 2;
                      if eC.cy>0
                        then FImagePoint.Y:=FCaptionPoint.Y+FScale.ValueIndent+eC.cy
                        else FImagePoint.Y:=FCaptionPoint.Y;
                    end;
                end;
              eopRight, eopLeft:
                begin
                  if RealImagePos=eopLeft then
                    begin
                      FImagePoint.X:=x1;
                      if wI>0 then inc(x1, wI+Indent);
                    end;
                  FCaptionPoint.X:=x1;
                  if eC.cx>0 then inc(x1, eC.cx+Indent);
                  FImagePoint.Y:=(Height-hI) div 2;
                  FCaptionPoint.Y:=(Height-eC.cy) div 2;
                  if RealImagePos=eopRight then
                    begin
                      dec(x2, wI);
                      FImagePoint.X:=x2;
                      if wI>0 then dec(x2, Indent);
                    end;
                end;
            end;
          end;
        eopRight: 
          begin
            case RealImagePos of
              eopTop, eopBottom: 
                begin      
                  aMax:=Math.max(eC.cx, wI);
                  dec(x2, aMax);
                  FCaptionPoint.X:=x2+(aMax-eC.cx) div 2;
                  FImagePoint.X:=x2+(aMax-wI) div 2;
                  if aMax>0 then dec(x2, Indent);
                  aSize:=hI+eC.cy;
                  if hI*eC.cy<>0 then inc(aSize, FScale.ValueIndent);
                  if RealImagePos=eopTop then
                    begin
                      FCaptionPoint.Y:=(Height+aSize) div 2 -eC.cy;
                      FImagePoint.Y:=FCaptionPoint.Y-aSize+eC.cy;
                    end else
                    begin  { eopBottom }
                      FCaptionPoint.Y:=(Height-aSize) div 2;
                      if eC.cy>0
                        then FImagePoint.Y:=FCaptionPoint.Y+FScale.ValueIndent+eC.cy
                        else FImagePoint.Y:=FCaptionPoint.Y;
                    end;
                end;
              eopRight: 
                begin
                  dec(x2, wI);
                  FImagePoint.X:=x2;
                  if wI>0 then dec(x2, Indent);
                end;
              eopLeft: 
                begin
                  FImagePoint.X:=x1;
                  if wI>0 then inc(x1, wI+Indent);
                end;   
            end;
            if RealImagePos in [eopLeft, eopRight] then
              begin
                dec(x2, eC.cx);
                FCaptionPoint.X:=x2;
                if eC.cx>0 then dec(x2, Indent);
                FImagePoint.Y:=(Height-hI) div 2;
                FCaptionPoint.Y:=(Height-eC.cy) div 2;
              end;
          end;
      end;  {case}
      CorrectGrooveLength(x1, x2, False);
      sV:=0;
      if FScale.ValueVisible<>evvNone then
        begin
          FScaleFontOptions.ApplyTo(Background.Canvas.Font, clBtnText);
          sV:=FScale.GetPreferredValuesHeight(Background.Canvas);
        end;
      hK:=GetGrooveOverhang(sG);  { set Knob's overhang }
      if FScale.TickVisible<>etvNone 
        then aSize:=FScale.TickIndent+FScale.TickLength 
        else aSize:=0;
      if ScaleTickPos<>etmBottomRight 
        then tlS:=aSize  { width on the top }
        else tlS:=0;  
      if ScaleTickPos<>etmTopLeft
        then brS:=aSize  { width on the bottom }
        else brS:=0;      
      if ScaleValuePos<>etmBottomRight then inc(tlS, sV);
      if ScaleValuePos<>etmTopLeft then inc(brS, sV);
      tlS:=Math.max(hK, tlS);  { decide wheter width of ticks+glyphs+values ... }
      brS:=Math.max(hK, brS);  { ... on the top/bottom is bigger than Knob's overhang }
      y1:=y1+tlS+(y2-y1-tlS-brS-sG) div 2;
      y2:=y1+sG;
      CorrectGrooveHorizontalLength(x1, x2);
      FGrooveRect:=Rect(x1, y1, x2, y2);
      SetGrooveBoundsHorz(x1, x2, y1, y2);
    end;  { horizontal }
  FGrooveInnerLength:=FGrooveMax-FGrooveMin;
  CalcGrooveMiddle;
  CalcInvalidRectStat;
  FScale.CalcTickPosAndValues(FGrooveInnerLength, esfRealReversed in Flags);
end;

procedure TBaseECSlider.CMBiDiModeChanged(var Message: TLMessage);
begin    
  if SetRealBiDiVariables then RecalcRedraw;
end;

procedure TBaseECSlider.CMColorChanged(var Message: TLMessage);
begin
  Redraw;
end;

procedure TBaseECSlider.CMHintShow(var Message: TLMessage);
begin
  inherited;
  if (TCMHintShow(Message).HintInfo^.HintControl=self) and PositionToHint
    then TCMHintShow(Message).HintInfo^.HintStr:=FScale.GetStringPosition(Position);
end;

procedure TBaseECSlider.CMParentColorChanged(var Message: TLMessage);
begin
  inherited CMParentColorChanged(Message);
  Redraw;
end;

procedure TBaseECSlider.CorrectGrooveHorizontalLength(var x1, x2: Integer);
begin
end; 

procedure TBaseECSlider.DrawBackground;
var aColor: TColor;
    bEnabled: Boolean;

  procedure DrawProgressMarks;
  var aProgressMark: TProgressMark;
      i, j, x, y: Integer;
  begin
    aProgressMark:=ProgressMark;
    if aProgressMark>epmNone then
      begin
        aColor:=GetColorResolvingDefAndEnabled(FScale.TickColor, clBtnText, bEnabled);
        j:=GrooveBevelWidth+FGrooveMiddle;
        if Orientation=eooVertical then
          begin  { vertical }
            if not Reversed
              then y:=j+FGrooveRect.Top
              else y:=FGrooveRect.Bottom-j-1;
            if (aProgressMark=epmBoth) or ((ScaleTickPos<>etmBottomRight) xor (aProgressMark=epmOpposite)) then
              begin
                x:=FGrooveRect.Left-1;
                for i:=0 to ProgressMarkSize-1 do
                  for j:=-i to i do
                    Background.Canvas.Pixels[x-i, y+j]:=aColor;
              end;
            if (aProgressMark=epmBoth) or ((ScaleTickPos<>etmTopLeft) xor (aProgressMark=epmOpposite)) then
              begin
                x:=FGrooveRect.Right;
                for i:=0 to ProgressMarkSize-1 do
                  for j:=-i to i do
                    Background.Canvas.Pixels[x+i, y+j]:=aColor;
              end;
          end else
          begin  { horizontal }
             if not (esfRealReversed in Flags)
              then x:=j+FGrooveRect.Left
              else x:=FGrooveRect.Right-j-1;
            if (aProgressMark=epmBoth) or ((ScaleTickPos<>etmBottomRight) xor (aProgressMark=epmOpposite)) then
              begin
                y:=FGrooveRect.Top-1;
                for j:=0 to ProgressMarkSize-1 do
                  for i:=-j to j do
                    Background.Canvas.Pixels[x+i, y-j]:=aColor;
              end;
            if (aProgressMark=epmBoth) or ((ScaleTickPos<>etmTopLeft) xor (aProgressMark=epmOpposite)) then
              begin
                y:=FGrooveRect.Bottom;
                for j:=0 to ProgressMarkSize-1 do
                  for i:=-j to j do
                    Background.Canvas.Pixels[x+i, y+j]:=aColor;
              end;
          end;
      end;
  end;

  procedure DrawScale;
  var aExtraValues: array of Double;
  begin
    FScaleFontOptions.ApplyTo(Background.Canvas.Font, clBtnText);
    if ProgressFromMiddle and (ProgressMiddlePos<>0) then
      begin
        SetLength(aExtraValues, 2);
        aExtraValues[1]:=ProgressMiddlePos;
      end else
        SetLength(aExtraValues, 1);
    aExtraValues[0]:=0;
    if Orientation=eooVertical then
      begin
        if (ScaleTickPos<>etmTopLeft) or (ScaleValuePos<>etmTopLeft) then
          FScale.Draw(Background.Canvas, ScaleTickPos<>etmTopLeft, ScaleValuePos<>etmTopLeft, eopRight,
            Color3DDark, Color3DLight, Point(FGrooveRect.Right, FGrooveMin), aExtraValues);
        if (ScaleTickPos<>etmBottomRight) or (FScaleValuePos<>etmBottomRight) then
          FScale.Draw(Background.Canvas, ScaleTickPos<>etmBottomRight, ScaleValuePos<>etmBottomRight, eopLeft,
            Color3DDark, Color3DLight, Point(FGrooveRect.Left, FGrooveMin), aExtraValues);
      end else
      begin
        if (ScaleTickPos<>etmTopLeft) or (ScaleValuePos<>etmTopLeft) then
          FScale.Draw(Background.Canvas, ScaleTickPos<>etmTopLeft, ScaleValuePos<>etmTopLeft, eopBottom,
            Color3DDark, Color3DLight, Point(FGrooveMin, FGrooveRect.Bottom), aExtraValues);
        if (ScaleTickPos<>etmBottomRight) or (ScaleValuePos<>etmBottomRight) then
          FScale.Draw(Background.Canvas, ScaleTickPos<>etmBottomRight, ScaleValuePos<>etmBottomRight, eopTop,
            Color3DDark, Color3DLight, Point(FGrooveMin, FGrooveRect.Top), aExtraValues);
      end;
  end;

var aRect: TRect;
    i: Integer;
begin
  {$IFDEF DBGSLIDER} Debugln('TBaseECSlider.DrawBackground'); {$ENDIF}
  bEnabled:=IsEnabled;
  Background.SetSize(Width, Height);
  Background.Canvas.Brush.Style:=bsSolid;
  aColor:=ColorToRGB(GetColorResolvingDefAndEnabled(Color, Parent.Brush.Color, bEnabled));
  if (aColor and $FF)>0
    then dec(aColor)
    else inc(aColor);
  Background.TransparentColor:=aColor;
  Background.TransparentClear; 
  Background.BeginUpdate(True);
  aRect:=Rect(0, 0, Width, Height);
  with Background.Canvas do
    begin
      case Style of
        eosButton:      DrawButtonBackground(aRect, caItemState[bEnabled]);
        eosPanel:       DrawPanelBackground(aRect, BevelInner, BevelOuter, BevelSpace, BevelWidth, Color3DDark,
                          Color3DLight, GetColorResolvingDefault(self.Color, Parent.Brush.Color), bEnabled);
        eosThemedPanel: DrawThemedPanelBkgnd(ARect);
        eosFinePanel:   DrawFinePanelBkgnd(aRect, BevelOuter, BevelWidth, Color3DDark, Color3DLight,
                          GetColorResolvingDefault(self.Color, Parent.Brush.Color), False, bEnabled);
      end;
      if assigned(FImages) and (ImageIndex>=0) and (ImageIndex<FImages.Count) then
        ThemeServices.DrawIcon(Background.Canvas, ArBtnDetails[bEnabled, False], FImagePoint, FImages, ImageIndex);
      if HasCaption then
        begin
          Font.Assign(self.Font);
          aRect.TopLeft:=FCaptionPoint;
          ThemeServices.DrawText(Background.Canvas, ArBtnDetails[bEnabled, False], Caption, aRect,
            DT_NOPREFIX or DT_SINGLELINE, 0);
        end;
      if (FScale.TickVisible>etvNone) or (FScale.ValueVisible>evvNone) then DrawScale;
      case GrooveStyle of
        eosButton: ThemeServices.DrawElement(Handle, ArBtnDetails[bEnabled, False], FGrooveRect, nil);
        eosPanel:
          begin
            Pen.Width:=1;
            Pen.Style:=psSolid;
            Pen.Color:=GetColorResolvingDefAndEnabled(Color3DDark, clBtnShadow, bEnabled);
            for i:=0 to GrooveBevelWidth-1 do
              begin  { draw Top & Left edge of GrooveBMP }
                Line(FGrooveRect.Left+i, FGrooveRect.Top+i, FGrooveRect.Right-i, FGrooveRect.Top+i);
                Line(FGrooveRect.Left+i, FGrooveRect.Top+i, FGrooveRect.Left+i, FGrooveRect.Bottom-i);
              end;
            Pen.Color:=GetColorResolvingDefAndEnabled(Color3DLight, clBtnHilight, bEnabled);
            for i:=0 to GrooveBevelWidth-1 do
              begin  { draw Bottom & Right edge of GrooveBMP }
                Line(FGrooveRect.Right-i-1, FGrooveRect.Top+i, FGrooveRect.Right-i-1, FGrooveRect.Bottom-i-1);
                Line(FGrooveRect.Left+i, FGrooveRect.Bottom-i-1, FGrooveRect.Right-i, FGrooveRect.Bottom-i-1);
              end;
          end;
        eosThemedPanel:
          ThemeServices.DrawElement(Handle, ThemeServices.GetElementDetails(ttPane), FGrooveRect, nil);
        eosFinePanel:
          DrawFinePanelBkgnd(FGrooveRect, bvLowered, GrooveBevelWidth, Color3DDark,
            Color3DLight, GetColorResolvingDefault(Color, Parent.Brush.Color), False, bEnabled);
      end;
      if ProgressFromMiddle then DrawProgressMarks;  { draw ProgressMarks (small arrows) }
    end;
  Background.EndUpdate(False);
end;

procedure TBaseECSlider.DrawGrooveBMP;
var aOrientation: TGradientDirection;
    aRect: TRect;
    
  procedure DrawAestheticProgress(AFrom, ATo: TColor);
  var i, aPP, aStep: SmallInt;
  begin
    aPP:=ProgressParameter;
    aStep:=1;
    if aPP<=1 then inc(aStep);  { correction; param. ARect of GradientFill must be wider then 1 }
    with GrooveBMP.Canvas do
      if aOrientation=gdVertical
        then for i:=aRect.Left div aPP to aRect.Right div aPP do
               if odd(i)
                 then GradientFill(Rect(i*aPP, aRect.Top, (i+aStep)*aPP, aRect.Bottom), AFrom, ATo, aOrientation)
                 else GradientFill(Rect(i*aPP, aRect.Top, (i+aStep)*aPP, aRect.Bottom), ATo, AFrom, aOrientation)
        else for i:=aRect.Top div aPP to aRect.Bottom div aPP do
               if odd(i)
                 then GradientFill(Rect(aRect.Left, i*aPP, aRect.Right, (i+aStep)*aPP), AFrom, ATo, aOrientation)
                 else GradientFill(Rect(aRect.Left, i*aPP, aRect.Right, (i+aStep)*aPP), ATo, AFrom, aOrientation);
  end;

  procedure DrawOrthoTwinProgress(AFrom, ATo: TColor);
  var aHalfWidth: SmallInt;
  begin
    with GrooveBMP.Canvas do
      if aOrientation=gdVertical then
        begin
          aHalfWidth:=(aRect.Right-aRect.Left) div 2;
          GradientFill(Rect(aRect.Left, aRect.Top, aRect.Left+aHalfWidth, aRect.Bottom),
                       ATo, AFrom, gdHorizontal);
          GradientFill(Rect(aRect.Left+aHalfWidth, aRect.Top, aRect.Right, aRect.Bottom),
                       AFrom, ATo, gdHorizontal);
        end else
        begin
          aHalfWidth:=(aRect.Bottom-aRect.Top) div 2;
          GradientFill(Rect(aRect.Left, aRect.Top, aRect.Right, aRect.Top+aHalfWidth),
                       ATo, AFrom, gdVertical);
          GradientFill(Rect(aRect.Left, aRect.Top+aHalfWidth, aRect.Right, aRect.Bottom),
                       AFrom, ATo, gdVertical);
        end;
  end;

  procedure DrawRippleProgress(AFrom, ATo: TColor);
  var i, aPP: SmallInt;
  begin
    aPP:=ProgressParameter;
    with GrooveBMP.Canvas do
      if aOrientation=gdVertical then
        begin
          i:=aRect.Top;
          repeat
            GradientFill(Rect(aRect.Left, i, aRect.Right, i+aPP), ATo, AFrom, aOrientation);
            inc(i, aPP);
            GradientFill(Rect(aRect.Left, i, aRect.Right, i+aPP), AFrom, ATo, aOrientation);
            inc(i, aPP);
          until i>aRect.Bottom;
        end else
        begin
          i:=aRect.Left;
          repeat
            GradientFill(Rect(i, aRect.Top, i+aPP, aRect.Bottom), AFrom, ATo, aOrientation);
            inc(i, aPP);
            GradientFill(Rect(i, aRect.Top, i+aPP, aRect.Bottom), ATo, AFrom, aOrientation);
            inc(i, aPP);
          until i>aRect.Right;
        end;
  end;

const caColorThemeIsDark: array[Boolean] of TColor = (clHighlightText, clInactiveCaption);
var aColor1, aColor2, aColorM: TColor;
    x: SmallInt;
begin
  {$IFDEF DBGSLIDER} DebugLn('TBaseECSlider.DrawGrooveBMP'); {$ENDIF}
  x:=2*GrooveBevelWidth;
  GrooveBMP.SetSize(FGrooveRect.Right-FGrooveRect.Left-x, FGrooveRect.Bottom-FGrooveRect.Top-x);
  if assigned(FOnDrawProgressBMP) then
    begin
      FOnDrawProgressBMP(self, GrooveBMP);  
      exit;  { Exit! }
    end;
  GrooveBMP.BeginUpdate(True);
  with GrooveBMP.Canvas do
    begin
      aColor1:=GetColorResolvingDefault(ProgressColor, clHighlight);
      aColor2:=GetColorResolvingDefault(ProgressColor2, caColorThemeIsDark[IsColorDark(ColorToRGB(clBtnFace))]);
      if not IsEnabled then
        begin
          aColor1:=GetMonochromaticColor(aColor1);
          aColor2:=GetMonochromaticColor(aColor2);
        end;
      if (Orientation=eooVertical) xor (ProgressStyle in [epsAesthetic, epsOrthogonal])
        then aOrientation:=gdVertical
        else aOrientation:=gdHorizontal;
      if not ProgressFromMiddle then
        begin  { normal progress }
          aRect:=Rect(0, 0, GrooveBMP.Width, GrooveBMP.Height);
          case ProgressStyle of
            epsSimple:
              begin
                Brush.Color:=aColor1;
                FillRect(aRect);
              end;
            epsAesthetic: DrawAestheticProgress(aColor1, aColor2);
            epsOrthoTwin: DrawOrthoTwinProgress(aColor1, aColor2);
            epsGradLines: DrawAestheticProgress(aColor1, aColor2);
            epsRipple:    DrawRippleProgress(aColor1, aColor2);
            otherwise
              if not (esfRealReversed in Flags) xor (ProgressStyle=epsReversedGrad)
                then GradientFill(aRect, aColor2, aColor1, aOrientation)
                else GradientFill(aRect, aColor1, aColor2, aOrientation);
          end;
        end else
        begin  { ProgressFromMiddle }
          if not (esfRealReversed in Flags)
            then if Orientation=eooVertical
                   then aRect:=Rect(0, 0, GrooveBMP.Width, FGrooveMiddle)
                   else aRect:=Rect(0, 0, FGrooveMiddle, GrooveBMP.Height)
            else if Orientation=eooVertical
                   then aRect:=Rect(0, 0, GrooveBMP.Width, GrooveBMP.Height-FGrooveMiddle-1)
                   else aRect:=Rect(0, 0, GrooveBMP.Width-FGrooveMiddle-1, GrooveBMP.Height);
          aColorM:=GetMergedColor(aColor1, aColor2, 0.7);
          case ProgressStyle of
            epsSimple: 
              begin
                if not (esfRealReversed in Flags)
                  then Brush.Color:=aColor2
                  else Brush.Color:=aColor1;
                FillRect(aRect);
              end;  
            epsAesthetic:    DrawAestheticProgress(aColorM, aColor2);
            epsGradient,
            epsOrthogonal:   GradientFill(aRect, aColorM, aColor2, aOrientation);
            epsReversedGrad: GradientFill(aRect, aColor2, aColorM, aOrientation);
            epsOrthoTwin:    DrawOrthoTwinProgress(aColor2, aColorM);
            epsGradLines:    DrawAestheticProgress(aColor2, aColorM);
            epsRipple:
              begin
                x:=2*ProgressParameter;
                if aOrientation=gdVertical
                  then dec(aRect.Top, x-(aRect.Bottom mod x)+1)
                  else dec(aRect.Left, x-(aRect.Right mod x)+1);
                DrawRippleProgress(aColor2, aColorM);
              end;
          end;
          if Orientation=eooVertical
            then aRect:=Rect(0, aRect.Bottom, aRect.Right, GrooveBMP.Height)
            else aRect:=Rect(aRect.Right, 0, GrooveBMP.Width, aRect.Bottom);
          aColorM:=GetMergedColor(aColor2, aColor1, 0.7);
          case ProgressStyle of
            epsSimple: 
              begin
                if not (esfRealReversed in Flags)
                  then Brush.Color:=aColor1
                  else Brush.Color:=aColor2;
                FillRect(aRect);
              end;    
            epsAesthetic:    DrawAestheticProgress(aColor1, aColorM);
            epsGradient,
            epsReversedGrad,
            epsOrthogonal:   GradientFill(aRect, aColorM, aColor1, aOrientation);
            epsOrthoTwin:    DrawOrthoTwinProgress(aColor1, aColorM);
            epsGradLines:    DrawAestheticProgress(aColor1, aColorM);
            epsRipple:       DrawRippleProgress(aColor1, aColorM);
          end;
        end;
    end;
  GrooveBMP.EndUpdate(False);
end;

procedure TBaseECSlider.DrawGroove;  { must be called from within Paint or PaintSelf ! }
var aGrooveRect: TRect;
    bVert: Boolean;

  procedure FillARect(AFrom, ATo: SmallInt);
  begin
    if bVert
      then Canvas.FillRect(Rect(aGrooveRect.Left, aGrooveRect.Top+AFrom, aGrooveRect.Right, aGrooveRect.Top+ATo))
      else Canvas.FillRect(Rect(aGrooveRect.Top+AFrom, aGrooveRect.Left, aGrooveRect.Top+ATo, aGrooveRect.Right));                                    				;
  end;

var aTop, aBottom: Integer;

  procedure TrimAndCopyRects;
  var aRect, gRect: TRect;
  begin
    if RedrawMode<ermFreeRedraw
      then  { trim rects to not overlay FInvalidRect }
        if bVert then
          begin
            aRect:=Rect(aGrooveRect.Left, Math.max(aTop+aGrooveRect.Top, FInvalidRect.Top),
                        aGrooveRect.Right, Math.min(aBottom+aGrooveRect.Top, FInvalidRect.Bottom));
            gRect:=Rect(0, aRect.Top-aGrooveRect.Top, GrooveBMP.Width, aRect.Bottom-aGrooveRect.Top);
          end else
          begin
            aRect:=Rect(Math.max(aTop+aGrooveRect.Top, FInvalidRect.Left), aGrooveRect.Left,
                        Math.min(aBottom+aGrooveRect.Top, FInvalidRect.Right), aGrooveRect.Right);
            gRect:=Rect(aRect.Left-aGrooveRect.Top, 0, aRect.Right-aGrooveRect.Top, GrooveBMP.Height);
          end
      else  { copy whole part of GrooveBMP to Canvas }
        if bVert then
          begin
            aRect:=Rect(aGrooveRect.Left, aTop+aGrooveRect.Top, aGrooveRect.Right, aBottom+aGrooveRect.Top);
            gRect:=Rect(0, aTop, GrooveBMP.Width, aTop+aRect.Height);
          end else
          begin
            aRect:=Rect(aGrooveRect.Top+aTop, aGrooveRect.Left, aGrooveRect.Top+aBottom, aGrooveRect.Right);
            gRect:=Rect(aTop, 0, aTop+aRect.Width, GrooveBMP.Height);
          end;
    Canvas.CopyRect(aRect, GrooveBMP.Canvas, gRect);  { copy gRect of GrooveBMP.Canvas to aRect }
  end;

var aMiddle, aPosition: Integer;
begin
  if (not GrooveTransparent) or (ProgressVisible>epvNone) then
    with Canvas do
      begin  { GrooveBMP is calculated as vertical }
        bVert:=(Orientation=eooVertical);
        if bVert or (ProgressVisible in [epvNone, epvFull])
          then aGrooveRect:=FGrooveRect
          else aGrooveRect:=Rect(FGrooveRect.Top, FGrooveRect.Left, FGrooveRect.Bottom, FGrooveRect.Right);
        InflateRect(aGrooveRect, -GrooveBevelWidth, -GrooveBevelWidth);
        Brush.Color:=GetColorResolvingDefAndEnabled(GrooveColor, cl3DDkShadow, IsEnabled);
        Brush.Style:=bsSolid;
        case ProgressVisible of
          epvNone: FillRect(aGrooveRect);									
          epvProgress:
            begin  
              aPosition:=GetRelGroovePos;
              if not (esfRealReversed in Flags) then
                begin  { non Reversed }
                  if not ProgressFromMiddle then 
                    begin  { normal }
                      aTop:=0;
                      aBottom:=aPosition;
                      TrimAndCopyRects;
                      if not GrooveTransparent then FillARect(aPosition, aGrooveRect.Height);
                    end else
                    begin  { ProgressFromMiddle }
                      aMiddle:=FGrooveMiddle;
                      if aPosition<aMiddle then
                        begin
                          aTop:=aPosition;
                          aBottom:=aMiddle;
                        end else
                        begin
                          aTop:=aMiddle;
                          aBottom:=aPosition;
                        end;
                      TrimAndCopyRects;
                      if not GrooveTransparent then
                        begin
                          FillARect(0, aTop);
                          FillARect(aBottom, aGrooveRect.Height);
                        end;
                    end;
                end else
                begin  { Reversed }
                  if not ProgressFromMiddle then
                    begin  { normal }
                      aTop:=aGrooveRect.Height-aPosition;
                      aBottom:=aGrooveRect.Height;
                      TrimAndCopyRects;
                      if not GrooveTransparent then FillARect(0, aTop);
                    end else
                    begin  { ProgressFromMiddle + Reversed }
                      aMiddle:=aGrooveRect.Height-FGrooveMiddle-1;
                      aPosition:=aGrooveRect.Height-aPosition;
                      if aPosition<aMiddle then
                        begin
                          aTop:=aPosition;
                          aBottom:=aMiddle;
                        end else
                        begin
                          aTop:=aMiddle;
                          aBottom:=aPosition;
                        end;
                      TrimAndCopyRects;
                      if not GrooveTransparent then
                        begin
                          FillARect(0, aTop);
                          FillARect(aBottom, aGrooveRect.Height);
                        end;
                    end;
                end;
            end;
          epvFull: CopyRect(aGrooveRect, GrooveBMP.Canvas, Rect(0, 0, GrooveBMP.Width, GrooveBMP.Height));
        end;  {case}
      end;
end;

procedure TBaseECSlider.EndUpdate(Recalculate: Boolean);
begin
  FScale.EndUpdate;
  inherited EndUpdate(Recalculate);
end;     

procedure TBaseECSlider.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  RecalcRedraw;
end;

function TBaseECSlider.GetGrooveOverhang(AFullGrooveWidth: Integer): Integer;
begin
  Result:=0;
end;

function TBaseECSlider.GetKnobOverhangScale(AGrooveWidth: Integer): Integer;
begin
  Result:=0;
end;

function TBaseECSlider.GetLogarithmicPosition: Double;
begin
  Result:=LinearToLogarithmic(FPosition, Min, Max, Scale.LogarithmBase);
end;

function TBaseECSlider.GetPosFromCoord(ACoord: Integer): Double;
begin
  Result:=(Max-Min)*(ACoord-FGrooveMin)/(FGrooveInnerLength-1);
end;

function TBaseECSlider.GetRelPxPos: Double;
begin
  Result:=(FPosition-Min)*(FGrooveInnerLength-1)/(Max-Min);
end;

procedure TBaseECSlider.InvalidateCustomRect(AMove: Boolean);
begin
  {$IFDEF DBGSLIDER} DebugLn('TBaseECSlider.InvGrooveKnobRect'); {$ENDIF}
  if AMove then
    begin
      if RedrawMode<=ermFreeRedraw then RedrawMode:=ermMoveKnob;
      CalcInvalidRectDyn;
    end else
    begin
      if RedrawMode=ermFreeRedraw then RedrawMode:=ermHoverKnob;
      exclude(Flags, esfPrevInvRectPainted);
    end;
  InvalidateRect(Handle, @FInvalidRect, False);
end;

procedure TBaseECSlider.OrientationChanged(AValue: TObjectOrientation);
begin
  SetRealBiDiVariables;
  inherited OrientationChanged(AValue);
end;

procedure TBaseECSlider.Paint;
var bEnabled: Boolean;									
{$IFDEF DBGSLIDER} aStr: string; aDur: TDateTime; {$ENDIF}
begin
  inherited Paint;
  {$IFDEF DBGSLIDER}
  inc(FRepaintCounter);
  WriteStr(aStr, RedrawMode);
  DebugLn('TBaseECSlider.Paint '+intToStr(FRepaintCounter));
  aDur:=Now;
  {$ENDIF}
  bEnabled:=IsEnabled;
  PaintSelf(bEnabled);
  if bEnabled
    then include(Flags, esfWasEnabled)
    else exclude(Flags, esfWasEnabled);
  RedrawMode:=ermFreeRedraw;
  {$IFDEF DBGSLIDER}
  aDur:=Now-aDur;
  Debugln(intToStr(round(frac(aDur)*86400000))+ 'ms | Repaints: '+intToStr(FRepaintCounter));
  {$ENDIF}
end;

procedure TBaseECSlider.RecalcRedraw;
begin
  {$IFDEF DBGSLIDER} DebugLn('TBaseECSlider.RecalcRedraw'); {$ENDIF}
  RedrawMode:=ermRecalcRedraw;
  if UpdateCount = 0 then
    begin
      if AutoSize then
        begin
          InvalidatePreferredSize;
          AdjustSize;
        end;
      Invalidate;
    end;
end;

procedure TBaseECSlider.Redraw;
begin
  {$IFDEF DBGSLIDER} DebugLn('TBaseECSlider.Redraw'); {$ENDIF}
  if RedrawMode<ermRedrawBkgnd then RedrawMode:=ermRedrawBkgnd;
  if UpdateCount = 0 then Invalidate;
end;

procedure TBaseECSlider.Redraw3DColorAreas;
begin
  if (Style=eosPanel) or (GrooveBevelWidth>0)
    or ((FScale.TickVisible<>etvNone) and (FScale.TickDesign>=etd3DLowered)) 
    then Redraw;
end;       

function TBaseECSlider.SetRealBiDiVariables: Boolean;
var bBiDi: Boolean;
begin
  bBiDi:=((Orientation=eooHorizontal) and IsRightToLeft);
  RealCaptionPos:=caRealPositions[CaptionPos, bBiDi];
  RealImagePos:=caRealPositions[ImagePos, bBiDi];
  Result:=((Reversed xor bBiDi)<>(esfRealReversed in Flags));
  if Result then
    if not (esfRealReversed in Flags)
      then include(Flags, esfRealReversed)
      else exclude(Flags, esfRealReversed);
end;      

procedure TBaseECSlider.TextChanged;
begin
  inherited TextChanged;
  RecalcRedraw;
end;

procedure TBaseECSlider.WMSize(var Message: TLMSize);
begin
  inherited WMSize(Message);
  RedrawMode:=ermRecalcRedraw;
  if UpdateCount=0 then Invalidate;  
end;

{ Get/Setters }

function TBaseECSlider.GetMax: Double;
begin
  Result:=Scale.Max;
end;

function TBaseECSlider.GetMin: Double;
begin
  Result:=Scale.Min;
end;        

procedure TBaseECSlider.SetCaptionPos(AValue: TObjectPos);
begin
  if FCaptionPos=AValue then exit;
  FCaptionPos:=AValue;
  RealCaptionPos:=caRealPositions[AValue, (Orientation=eooHorizontal) and IsRightToLeft];
  if HasCaption then RecalcRedraw;
end;

procedure TBaseECSlider.SetGrooveBevelWidth(const AValue: SmallInt);
begin
  if FGrooveBevelWidth=AValue then exit;
  FGrooveBevelWidth:=AValue;
  RecalcRedraw;
end;

procedure TBaseECSlider.SetGrooveColor(const AValue: TColor);
begin
  if FGrooveColor=AValue then exit;
  FGrooveColor:=AValue;
  if not GrooveTransparent then InvalidateNonUpdated;
end;

procedure TBaseECSlider.SetGrooveStyle(const AValue: TObjectStyle);
begin
  if FGrooveStyle=AValue then exit;
  FGrooveStyle:=AValue;
  Redraw;
end;

procedure TBaseECSlider.SetGrooveTransparent(const AValue: Boolean);
begin
  if FGrooveTransparent=AValue then exit;
  FGrooveTransparent:=AValue;
  InvalidateNonUpdated;
end;

procedure TBaseECSlider.SetGrooveWidth(const AValue: SmallInt);
begin
  if FGrooveWidth=AValue then exit;
  FGrooveWidth:=AValue;
  RecalcRedraw;
end;

procedure TBaseECSlider.SetImageIndex(const AValue: TImageIndex);
begin
  if FImageIndex=AValue then exit;
  FImageIndex:=AValue;
  if assigned(FImages) then RecalcRedraw;
end;

procedure TBaseECSlider.SetImagePos(AValue: TObjectPos);
begin
  if FImagePos=AValue then exit;
  FImagePos:=AValue;
  RealImagePos:=caRealPositions[AValue, (Orientation=eooHorizontal) and IsRightToLeft];
  if assigned(Images) and (ImageIndex>=0) and (ImageIndex<Images.Count) then RecalcRedraw;
end;

procedure TBaseECSlider.SetImages(const AValue: TCustomImageList);
begin
  if FImages=AValue then exit;
  FImages:=AValue;
  RecalcRedraw;
end;

procedure TBaseECSlider.SetIndent(const AValue: SmallInt);
begin
  if FIndent=AValue then exit;
  FIndent:=AValue;
  RecalcRedraw;
end;

procedure TBaseECSlider.SetLogarithmicPosition(AValue: Double);
var aLogBase, aMin, aMax, aRange: Double;
begin
  aLogBase:=FScale.LogarithmBase;
  aMin:=Min;
  aMax:=Max;
  aRange:=aMax-aMin;
  if aMin>0
    then aMin:=logn(aLogBase, aMin)
    else aMin:=0;
  if aMax>0
    then aMax:=logn(aLogBase, aMax)
    else aMax:=0; 
  Position:=aRange*(logn(aLogBase, AValue)-aMin)/(aMax-aMin); 
end;

procedure TBaseECSlider.SetMax(const AValue: Double);
begin
  Scale.Max:=AValue;
  if Position>Max then Position:=Max;
end;

procedure TBaseECSlider.SetMin(const AValue: Double);
begin
  Scale.Min:=AValue;
  if Position<Min then Position:=Min;
end;

procedure TBaseECSlider.SetProgressColor(const AValue: TColor);
begin
  if FProgressColor=AValue then exit;
  FProgressColor:=AValue;
  DrawGrooveBMP;
  if FProgressVisible>epvNone then InvalidateNonUpdated;
end;

procedure TBaseECSlider.SetProgressColor2(const AValue: TColor);
begin
  if FProgressColor2=AValue then exit;
  FProgressColor2:=AValue;
  DrawGrooveBMP;
  if FProgressVisible>epvNone then InvalidateNonUpdated;
end;

procedure TBaseECSlider.SetProgressFromMiddle(const AValue: Boolean);
begin
  if FProgressFromMiddle=AValue then exit;
  FProgressFromMiddle:=AValue;
  if AValue then CalcGrooveMiddle;
  Redraw;
end;

procedure TBaseECSlider.SetProgressMark(const AValue: TProgressMark);
begin
  if FProgressMark=AValue then exit;
  FProgressMark:=AValue;
  if ProgressFromMiddle then Redraw;
end;

procedure TBaseECSlider.SetProgressMarkSize(AValue: SmallInt);
begin
  if FProgressMarkSize=AValue then exit;
  FProgressMarkSize:=AValue;
  Redraw;
end;
            
procedure TBaseECSlider.SetProgressMiddlePos(const AValue: Double);
begin
  if FProgressMiddlePos=AValue then exit;
  if (csLoading in ComponentState) or ((Min<AValue) and (AValue<Max)) then
    begin
      FProgressMiddlePos:=AValue;
      CalcGrooveMiddle;
      if ProgressFromMiddle then Redraw;
    end;
end;

procedure TBaseECSlider.SetProgressParameter(AValue: SmallInt);
begin
  if AValue<1 then AValue:=1;
  if FProgressParameter=AValue then exit;
  FProgressParameter:=AValue;
  if ProgressStyle in [epsAesthetic, epsGradLines, epsRipple] then
    begin
      DrawGrooveBMP;
      InvalidateNonUpdated;
    end;
end;

procedure TBaseECSlider.SetProgressStyle(const AValue: TProgressStyle);
begin
  if FProgressStyle=AValue then exit;
  FProgressStyle:=AValue;
  if AValue>=epsSimple then DrawGrooveBMP;
  InvalidateNonUpdated;
end;

procedure TBaseECSlider.SetProgressVisible(AValue: TProgressVisibility);
begin
  if FProgressVisible=AValue then exit;
  FProgressVisible:=AValue;
  InvalidateNonUpdated;
end;      

procedure TBaseECSlider.SetReversed(AValue: Boolean);
begin
  if FReversed=AValue then exit;
  FReversed:=AValue;
  if (Orientation=eooHorizontal) and IsRightToLeft then AValue:=not AValue;
  if AValue
    then include(Flags, esfRealReversed)
    else exclude(Flags, esfRealReversed);
  RecalcRedraw;
end;

procedure TBaseECSlider.SetScaleTickPos(const AValue: TTickMarks);
begin
  if FScaleTickPos=AValue then exit;
  FScaleTickPos:=AValue;
  if FScale.TickVisible>etvNone then RecalcRedraw;
end;

procedure TBaseECSlider.SetScaleValuePos(const AValue: TTickMarks);
begin
  if FScaleValuePos=AValue then exit;
  FScaleValuePos:=AValue;
  if FScale.ValueVisible>evvNone then RecalcRedraw;
end;

{ TCustomECSlider }

constructor TCustomECSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csCaptureMouse]
                            -[csNoFocus, csNoStdEvents];
  FCursorBkgnd:=crDefault;
  FDiscreteChange:=0.1;
  FGrooveWidth:=cDefGrooveWidth;
  FIncrement:=1;
  FKnob:=TECSliderKnob.Create(self);
  FOrientation:=eooVertical;
  FPageSize:=10;
  FProgressMarkSize:=cDefProgMarkSize;
  FRelScaleLength:=-100;  { any negative value is default }
  SetInitialBounds(0, 0, 80, 320);
  TabStop:=True;
  AccessibleRole:=larTrackBar;
end;

destructor TCustomECSlider.Destroy;
begin
  FreeAndNil(FKnob);
  inherited Destroy;
end;

procedure TCustomECSlider.BeginUpdate;
begin
  inherited BeginUpdate;
  FKnob.BeginUpdate;
end;

procedure TCustomECSlider.CalcGrooveMiddle;
begin
  if ProgressMiddlePos<Min 
    then FGrooveMiddle:=cScaleIndent
    else if ProgressMiddlePos>Max 
           then FGrooveMiddle:=FGrooveInnerLength+cScaleIndent-1
           else FGrooveMiddle:=trunc(((ProgressMiddlePos-Min)/(Max-Min))*(FGrooveInnerLength))+cScaleIndent;
end;

procedure TCustomECSlider.CalcInvalidRectDyn;
var aCurrPosition: Integer;
    aRect: TRect;
begin
  {$IFDEF DBGSLIDER} DebugLn('TCustomECSlider.CalcInvalidRectDyn'); {$ENDIF}
  if Orientation=eooVertical 
    then FInvalidRect.Right:=FInvRectLimit
    else FInvalidRect.Bottom:=FInvRectLimit;
  aRect:=FInvalidRect;
  if Orientation=eooVertical then
    begin
      if aRect.Top<Knob.Top then
        begin  { moves down }
          aCurrPosition:=Knob.Top+Knob.Height;
          if aRect.Bottom<aCurrPosition then FInvalidRect.Bottom:=aCurrPosition;
        end else  { moves up }
          FInvalidRect.Top:=Knob.Top;
    end else
    begin
      if aRect.Left<Knob.Left then
        begin  { moves right }
          aCurrPosition:=Knob.Left+Knob.Width;
          if aRect.Right<aCurrPosition then FInvalidRect.Right:=aCurrPosition;
        end else  { moves left }
          FInvalidRect.Left:=Knob.Left;
    end;
  if not (esfPrevInvRectPainted in Flags) then UnionRect(FInvalidRect, aRect, FInvalidRect);
  inc(FInvalidRect.Right, 1); 
  inc(FInvalidRect.Bottom, 1);
end;

procedure TCustomECSlider.CalcInvalidRectStat;
begin
  {$IFDEF DBGSLIDER} DebugLn('TCustomECSlider.CalcInvalidRectStat'); {$ENDIF}
  if Orientation=eooVertical then
    begin
      if Knob.Left<(FGrooveRect.Left+GrooveBevelWidth) then
        begin
          FInvalidRect.Left:=Knob.Left;
          FInvalidRect.Right:=Knob.Left+Knob.Width;
        end else
        begin
          FInvalidRect.Left:=FGrooveRect.Left+GrooveBevelWidth;
          FInvalidRect.Right:=FGrooveRect.Right-GrooveBevelWidth;
        end;
      FInvRectLimit:=FInvalidRect.Right;
    end else
    begin
      if Knob.Top<(FGrooveRect.Top+GrooveBevelWidth) then
        begin
          FInvalidRect.Top:=Knob.Top;
          FInvalidRect.Bottom:=Knob.Top+Knob.Height;
        end else
        begin
          FInvalidRect.Top:=FGrooveRect.Top+GrooveBevelWidth;
          FInvalidRect.Bottom:=FGrooveRect.Bottom-GrooveBevelWidth;
        end;
      FInvRectLimit:=FInvalidRect.Bottom;
    end;
end;

procedure TCustomECSlider.ChangeCursors(AMouseHoverKnob: Boolean);
begin
  include(Flags, esfCursorLock);
  if AMouseHoverKnob 
    then Cursor:=Knob.Cursor
    else Cursor:=FCursorBkgnd;
  exclude(Flags, esfCursorLock);
end;

procedure TCustomECSlider.CMColorChanged(var Message: TLMessage);
begin
  if assigned(FKnob) then SetKnobBackground;
  inherited CMColorChanged(Message);
end;

procedure TCustomECSlider.CMParentColorChanged(var Message: TLMessage);
begin
  if assigned(FKnob) then SetKnobBackground;
  inherited CMParentColorChanged(Message);
end;    

procedure TCustomECSlider.CorrectGrooveHorizontalLength(var x1, x2: Integer);
begin
  inc(x1, Indent);
  dec(x2, Indent);   
end;    

procedure TCustomECSlider.CorrectGrooveLength(var z1, z2: Integer; AVert: Boolean);
var aGrooveEdge, aKnobEdge, aLength: Integer;
begin
  if AVert 
    then aKnobEdge:=Knob.Height div 2
    else aKnobEdge:=Knob.Width div 2;
  aGrooveEdge:=cScaleIndent+GrooveBevelWidth;
  if aKnobEdge>aGrooveEdge then
    begin
      z1:=z1-aGrooveEdge+aKnobEdge;
      z2:=z2+aGrooveEdge-aKnobEdge;
    end;
  if (FRelScaleLength>=0) and not AVert and
    ((RealCaptionPos in [eopRight, eopLeft]) and HasCaption) then
    begin
      aLength:=ClientWidth-2*(GetBorderWidth+Indent-aGrooveEdge+aKnobEdge);
      aLength:=round(0.01*RelativeScaleLength*aLength);
      case RealCaptionPos of
        eopRight: z2:=z1+aLength;
        eopLeft:  z1:=z2-aLength;
      end;
    end;
end;                 

procedure TCustomECSlider.DblClick;
var aPoint: TPoint;
begin
  inherited DblClick;
  aPoint:=ScreenToClient(Mouse.CursorPos);
  MouseDown(mbMiddle, [ssMiddle], aPoint.X, aPoint.Y);
end;    

function TCustomECSlider.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var d: Double;
begin
  Result:=inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
    begin
      if not (ssModifier in Shift)
        then d:=PageSize
        else d:=Increment;
      if not (esfRealReversed in Flags)
        then Position:=FPosition+d
        else Position:=FPosition-d;
      Result:=True;
    end;
end;

function TCustomECSlider.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
var d: Double;
begin
  Result:=inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
    begin
      if not (ssModifier in Shift)
        then d:=PageSize
        else d:=Increment;
      if not (esfRealReversed in Flags)
        then Position:=FPosition-d
        else Position:=FPosition+d;
      Result:=True;
    end;
end;

procedure TCustomECSlider.EndUpdate(Recalculate: Boolean);
begin
  FKnob.EndUpdate;
  inherited EndUpdate(Recalculate);
end;

function TCustomECSlider.GetGrooveOverhang(AFullGrWidth: Integer): Integer;
var aSize: Integer;
begin
  if Orientation=eooHorizontal 
    then aSize:=Knob.Height
    else aSize:=Knob.Width;    
  if aSize>AFullGrWidth 
    then Result:=(aSize-AFullGrWidth) div 2
    else Result:=0;
end;

function TCustomECSlider.GetKnobOverhangScale(AGrooveWidth: Integer): Integer;
begin
  if Orientation=eooHorizontal 
    then Result:=(Knob.Height-AGrooveWidth) div 2  
    else Result:=(Knob.Width-AGrooveWidth) div 2;
end;

function TCustomECSlider.GetRelGroovePos: Integer;
begin
  Result:=round(GetRelPxPos)+cScaleIndent;
end;

procedure TCustomECSlider.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if [ssShift, ssAlt]*Shift=[] then
    case Key of
      VK_SPACE:
        if ProgressFromMiddle
          then Position:=ProgressMiddlePos
          else Position:=0.5*(Max-abs(Min));
      VK_PRIOR:
        if not (esfRealReversed in Flags)
          then Position:=FPosition-PageSize
          else Position:=FPosition+PageSize;
      VK_NEXT:
        if not (esfRealReversed in Flags)
          then Position:=FPosition+PageSize
          else Position:=FPosition-PageSize;
      VK_END:
        if not (esfRealReversed in Flags)
          then Position:=Max
          else Position:=Min;
      VK_HOME:
        if not (esfRealReversed in Flags)
          then Position:=Min
          else Position:=Max;
      VK_LEFT, VK_UP:
        if ssModifier in Shift then
          if not (esfRealReversed in Flags)
            then Position:=FPosition-Increment
            else Position:=FPosition+Increment;
      VK_RIGHT, VK_DOWN:
        if ssModifier in Shift then
          if not (esfRealReversed in Flags)
            then Position:=FPosition+Increment
            else Position:=FPosition-Increment;
      VK_0..VK_9:  Position:=(Key-VK_0)*PageSize;
      VK_ADD:      Position:=FPosition+Increment;
      VK_SUBTRACT: Position:=FPosition-Increment;
    end;  {case}
end;

procedure TCustomECSlider.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aMousePos, aHelp: Double;
begin
  {$IFDEF DBGSLIDER} DebugLn('MouseDown '+inttostr(X)+' '+inttostr(Y)); {$ENDIF}
  inherited MouseDown(Button, Shift, X, Y);
  if Button in [mbLeft, mbMiddle] then
    begin
      if Orientation=eooHorizontal
        then aMousePos:=GetPosFromCoord(X)
        else aMousePos:=GetPosFromCoord(Y);
      if not (esfRealReversed in Flags)
        then aMousePos:=Min+aMousePos
        else aMousePos:=Max-aMousePos;
      if Button=mbLeft
        then if Knob.MouseInClient then  { left click }
               begin  { over Knob }
                 FKnobDragState:=True;
                 FKnobDragPos.X:=X-Knob.Left-(Knob.Width div 2);
                 FKnobDragPos.Y:=Y-Knob.Top-(Knob.Height div 2);
               end else  { out of Knob }
                 if aMousePos<FPosition then
                   begin
                     aHelp:=FPosition-PageSize;
                     if aMousePos<aHelp
                       then Position:=aHelp
                       else Position:=aMousePos;
                   end else
                   begin
                     aHelp:=FPosition+PageSize;
                     if aMousePos>aHelp
                       then Position:=aHelp
                       else Position:=aMousePos;
                   end
        else Position:=aMousePos;  { middle or double click }
    end;
  SetFocus;
end;

procedure TCustomECSlider.MouseLeave;
begin                                                 
  inherited MouseLeave;
  if Knob.MouseInClient then
    begin
      ChangeCursors(True);
      InvalidateCustomRect(False);
      Knob.MouseInClient:=False;
    end;
end;

procedure TCustomECSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
var aHelp: Double;
    aPosition: Integer;
    bPrevKnobMouseInClient: Boolean;
begin
  inherited MouseMove(Shift, X, Y);
  if IsEnabled then
    begin
      bPrevKnobMouseInClient:=Knob.MouseInClient;
      Knob.MouseInClient:=((X>Knob.Left) and (X<(Knob.Left+Knob.Width))
        and ((Y>Knob.Top) and (Y<(Knob.Top+Knob.Height))));
      if (bPrevKnobMouseInClient<>Knob.MouseInClient) and not FKnobDragState then
        begin
          ChangeCursors(Knob.MouseInClient);
          InvalidateCustomRect(False);
        end;
      if FKnobDragState then
        begin
          if Orientation=eooHorizontal 
            then aPosition:=X-FKnobDragPos.X
            else aPosition:=Y-FKnobDragPos.Y;            
          aHelp:=GetPosFromCoord(aPosition);
          if not (esfRealReversed in Flags)
            then Position:=Min+aHelp
            else Position:=Max-aHelp;
        end;
    end;
end;

procedure TCustomECSlider.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {$IFDEF DBGSLIDER} DebugLn('MouseUp '+inttostr(X)+' '+inttostr(Y)); {$ENDIF}
  inherited MouseUp(Button, Shift, X, Y);
  if FKnobDragState then
    begin
      FKnobDragState:=False;
      if not Knob.MouseInClient then
        begin
          ChangeCursors(False);
          InvalidateCustomRect(False);
        end;
    end;
  if ShowHint and PositionToHint then Application.ActivateHint(Mouse.CursorPos);
end;

procedure TCustomECSlider.OrientationChanged(AValue: TObjectOrientation);
begin
  if not (csLoading in ComponentState) then
    begin
      SetBounds(Left, Top, Height, Width);
      Knob.SetSize(Knob.Height, Knob.Width);
    end;    
  inherited OrientationChanged(AValue);  
end;

procedure TCustomECSlider.PaintSelf(AEnabled: Boolean);
var aHelp: Integer;
    aRect: TRect;
begin
  if (esfWasEnabled in Flags)<>AEnabled then
    begin
      if RedrawMode<ermRedrawBkgnd then RedrawMode:=ermRedrawBkgnd;
      if not AEnabled and FKnobDragState then
        begin
          FKnobDragState:=False;
          MouseCapture:=False;
          ChangeCursors(False);    
        end;
    end;
  if RedrawMode=ermRecalcRedraw then
    begin
      Calculate;
      PlaceKnob(False);
    end;
  if RedrawMode>=ermRedrawBkgnd then
    begin
      DrawBackground;
      DrawGrooveBMP;
    end;
  if RedrawMode>=ermFreeRedraw
    then Canvas.Draw(0, 0, Background)
    else Canvas.CopyRect(FInvalidRect, Background.Canvas, FInvalidRect);
  DrawGroove;
  if not AEnabled
    then Canvas.Draw(Knob.Left, Knob.Top, Knob.KnobDisabled)
    else if Knob.MouseInClient or FKnobDragState
           then Canvas.Draw(Knob.Left, Knob.Top, Knob.KnobHighlighted)
           else Canvas.Draw(Knob.Left, Knob.Top, Knob.KnobNormal);
  if Focused then
    begin
      if Knob.Style=eosPanel 
        then aHelp:=Knob.BevelWidth+1 
        else aHelp:=3;
      aRect:=Rect(Knob.Left+aHelp, Knob.Top+aHelp, Knob.Left+Knob.Width-aHelp, Knob.Top+Knob.Height-aHelp);
      Canvas.DrawFocusRectNonThemed(aRect);
    end;
  include(Flags, esfPrevInvRectPainted);
  if Orientation=eooHorizontal then
    begin
      FInvalidRect.Left:=Knob.Left;
      FInvalidRect.Right:=Knob.Left+Knob.Width;
    end else  
    begin
      FInvalidRect.Top:=Knob.Top;
      FInvalidRect.Bottom:=Knob.Top+Knob.Height;
    end;    
end;

procedure TCustomECSlider.PlaceKnob(AInvalidate: Boolean);
var aHelp: Double;
    aKnobPos: Integer;
begin
  {$IFDEF DBGSLIDER} Debugln('TCustomECSlider.PlaceKnob'); {$ENDIF}
  aHelp:=GetRelPxPos;
  if Orientation=eooVertical then
    begin
      aKnobPos:=Knob.Top;
      if not Reversed 
        then Knob.Top:=FGrooveMin+round(-0.5*Knob.Height+aHelp)
        else Knob.Top:=FGrooveMax-round(0.5*Knob.Height+aHelp)-1;
      if (aKnobPos<>Knob.Top) and AInvalidate then InvalidateCustomRect(True);
    end else
    begin
      aKnobPos:=Knob.Left;
      if not (esfRealReversed in Flags)
        then Knob.Left:=FGrooveMin+round(-0.5*Knob.Width+aHelp)
        else Knob.Left:=FGrooveMax-round(0.5*Knob.Width+aHelp)-1;
      if (aKnobPos<>Knob.Left) and AInvalidate then InvalidateCustomRect(True);
    end;
end;

procedure TCustomECSlider.Redraw3DColorAreas;
begin
  if assigned(FKnob) and (Knob.Style=eosPanel) then
    begin
      Knob.DrawKnobs;
      if HandleAllocated then InvalidateCustomRect(False);//added, remove commented code in invrect...
    end;
  inherited Redraw3DColorAreas;
end;

procedure TCustomECSlider.SetCursor(Value: TCursor);
begin
  inherited SetCursor(Value);
  if not (esfCursorLock in Flags) then FCursorBkgnd:=Value;
end;

procedure TCustomECSlider.SetGrooveBoundsHorz(x1, x2, y1, y2: Integer);
begin
  FGrooveMin:=x1+GrooveBevelWidth+cScaleIndent;
  FGrooveMax:=x2-GrooveBevelWidth-cScaleIndent;
  Knob.Top:=(y1+y2-Knob.Height) div 2;
end;

procedure TCustomECSlider.SetGrooveBoundsVert(x1, x2, y1, y2: Integer);
begin
  FGrooveMin:=y1+GrooveBevelWidth+cScaleIndent;
  FGrooveMax:=y2-GrooveBevelWidth-cScaleIndent;
  Knob.Left:=(x1+x2-Knob.Width) div 2;
end;

procedure TCustomECSlider.SetKnobBackground;
var aColor: TColor;
begin
  if Style in [eosPanel, eosFinePanel]
    then aColor:=GetColorResolvingDefault(Color, Parent.Brush.Color)
    else aColor:=clBtnFace;
  Knob.BackgroundColor:=ColorToRGB(aColor);
end;

procedure TCustomECSlider.SetPosition(AValue: Double);
begin
  if FMode=eimDiscrete then AValue:=DiscreteChange*round(AValue/DiscreteChange);
  if ([csLoading, csDestroying]*ComponentState=[]) and (UpdateCount=0) then
    if AValue<Min
      then AValue:=Min
      else if AValue>Max then AValue:=Max;
  if FPosition=AValue then exit;
  FPosition:=AValue;
  if UpdateCount=0 then
    begin
      if HandleAllocated then PlaceKnob(True);
      if assigned(FOnChange) then FOnChange(self);
    end;
end;

procedure TCustomECSlider.StyleChanged(AValue: TObjectStyle);
begin
  SetKnobBackground;
  inherited;
end;  

{ G/Setters }

function TCustomECSlider.GetRelScaleLength: Single;
begin
  Result:=0.01*FRelScaleLength;
end;   

procedure TCustomECSlider.SetDiscreteChange(const AValue: Double);
begin
  if FDiscreteChange=AValue then exit;
  FDiscreteChange:=AValue;
  if Mode=eimDiscrete then SetPosition(FPosition);
end;   

procedure TCustomECSlider.SetMode(const AValue: TIncrementalMode);
begin
  if FMode=AValue then exit;
  FMode:=AValue;
  if AValue=eimDiscrete then SetPosition(Position);
end;

procedure TCustomECSlider.SetRelScaleLength(AValue: Single);
var aProp100: SmallInt;
begin
  {$IFDEF DBGSLIDER} DebugLn('TCustomECSlider.SetRelScaleLength '+floattostr(AValue)); {$ENDIF}
  aProp100:=round(AValue*100);
  if FRelScaleLength=aProp100 then exit;
  FRelScaleLength:=aProp100;
  if Orientation=eooHorizontal then RecalcRedraw;    
end;  

end.


