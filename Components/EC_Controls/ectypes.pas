{****************-**********************************************************************************
 This file is part of the Eye Candy Controls (EC-C)
 
  Copyright (C) 2013-2020 Vojtěch Čihák, Czech Republic

  Credit: class TBaseScrollControl is based on TScrollingControl by Theo.
    https://github.com/theo222/lazarus-thumbviewer/blob/master/scrollingcontrol.pas

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

unit ECTypes;
{$mode objfpc}{$H+}  

//{$DEFINE DBGLINE}  {don't remove, just comment}

interface

uses
  Classes, SysUtils, Controls, Graphics, GraphType, GraphUtil, LCLIntf, {$IFDEF DBGLINE} LCLProc, {$ENDIF}
  LCLType, LMessages, Math, Messages, StdCtrls, StrUtils, Themes, Types;

type
  {$PACKENUM 2}
  {$PACKSET 2}
  TBasicPos = (ebpTopLeft, ebpBottomRight);
  TColorLayout = (eclSystemBGR,
                  eclRGBColor, eclBGRColor, eclARGBColor, eclABGRColor, eclRGBAColor, eclBGRAColor,
                  eclCMYColor, eclYMCColor, eclACMYColor, eclAYMCColor, eclCMYAColor, eclYMCAColor,
                  eclHSBColor, eclBSHColor, eclAHSBColor, eclABSHColor, eclHSBAColor, eclBSHAColor);
  TEditingDoneFlag = (edfAllowDoExitInCell, edfEnterWasInKeyDown, edfForceEditingDone);
  TEditingDoneFlags = set of TEditingDoneFlag;
  TGlyphDesign = (egdNone, egdEmpty, egdArrowDec, egdArrowInc,
                  egdArrowUp, egdArrowRight, egdArrowDown, egdArrowLeft,
                  egdArrowUR, egdArrowDR, egdArrowDL, egdArrowUL,
                  egdArrowsUU, egdArrowsRR, egdArrowsDD, egdArrowsLL,
                  egdArrowsUD, egdArrowsMiddle, egdArrowsLR, egdArrowsHMiddle,
                  egdArrowsMax, egdArrowMax, egdArrowMin, egdArrowsMin,
                  egdArrowsHMax, egdArrowHMax, egdArrowHMin, egdArrowsHMin,
                  egdArrowsUDHor, egdArrowsURDL_S, egdArrowsURDL_M, egdArrowURDL_L,
                  egdArrowURDL_XL, egdArrowsUL_DR, egdArrowsUR_DL,
                  egdArrsB_Min, egdArrB_Min, egdArrsB_DD, egdArrB_Down, 
                  egdArrsB_Middle, egdArrsB_UD, egdArrB_Up, egdArrsB_UU,
                  egdArrB_Max, egdArrsB_Max,
                  egdArrsB_HMin, egdArrB_HMin, egdArrsB_LL, egdArrB_Left,
                  egdArrsB_HMiddle, egdArrsB_LR, egdArrB_Right, egdArrsB_RR,
                  egdArrB_HMax, egdArrsB_HMax,
                  egdArrC_Min, egdArrC_DD, egdArrC_Down, egdArrC_Middle,
                  egdArrC_UD, egdArrC_LR, egdArrC_Up, egdArrC_UU,
                  egdArrC_Max, egdArrC_URDL,
                  egdPlayRec, egdPlayPause, egdPlayUpDown, egdPlayStop, egdPlayEject, egdPlayEjectD,
                  egdMathBigMinus, egdMathMinus, egdMathEqual, egdMathPlusMinus, 
                  egdMathPlus, egdMathBigPlus, 
                  egdCombo, egdList, egdFramedList, egdFrame,
                  egdRadioOffTh, egdRadioOnTh, egdCheckOffTh, egdCheckOnTh,
                  egdGrid, egdGuidelines,
                  egdSizeArrUp, egdSizeArrRight, egdSizeArrDown, egdSizeArrLeft,
                  egdRectBeveled, egdRectFramed,  { coloured with 3D/clBtnText frame }
                  egdWinRectClr, egdWinRoundClr,  { for color dialogs }
                  egdWindowRect, egdWindowRound, egdMenu);  { Total: egdNone + egdEmpty + 91 glyphs }
  TIncrementalMode = (eimContinuous, eimDiscrete);
  TItemState = (eisDisabled, eisHighlighted, eisEnabled, eisChecked, eisPushed, eisPushedHilighted, eisPushedDisabled);
  TItemStates = set of TItemState;
  TObjectOrientation = (eooHorizontal, eooVertical);
  TObjectPos = (eopTop, eopRight, eopBottom, eopLeft);
  TObjectStyle = (eosButton, eosPanel, eosThemedPanel, eosFinePanel);
  TRedrawMode = (ermHoverKnob, ermMoveKnob, ermFreeRedraw, ermRedrawBkgnd, ermRecalcRedraw);
  TTickDesign = (etdSimple, etdThick, etd3DLowered, etd3DRaised);
  TTickStyle = (etsSolid, etsDotted);
  TValuesVisibility = (evvNone, evvBounds, evvValues, evvAll);
  { events }
  TIntegerEvent = procedure(Sender: TObject; AIndex: Integer) of object;
  TIntegerMethod = procedure(AIndex: Integer) of object;
  TMouseMethod = procedure(Button: TMouseButton; Shift: TShiftState) of object;
  TObjectMethod = procedure of object;
  TOnPrepareValue = procedure(Sender: TObject; var AValue: Double) of object;
  TOnVisibleChanged = procedure (Sender: TObject; AVisible: Boolean) of object;
  
  { TCanvasHelper }
  TCanvasHelper = class helper for TCanvas
  public
    procedure DrawButtonBackground(ARect: TRect; AItemState: TItemState);
    procedure DrawFinePanelBkgnd(ARect: TRect; ABevelCut: TBevelCut; ABevelWidth: SmallInt;
                AColor3DDark, AColor3DLight, AColor: TColor; AFillBkgnd: Boolean; AEnabled: Boolean = True);
    procedure DrawFocusRectNonThemed(const ARect: TRect);
    procedure DrawGlyph(ARect: TRect; AGlyphColor: TColor; AGlyphDesign: TGlyphDesign;
                AState: TItemState = eisEnabled);
    procedure DrawPanelBackground(ARect: TRect; ABevelInner, ABevelOuter: TBevelCut;
                ABevelWidth: Integer; AColor: TColor; AEnabled: Boolean = True);
    procedure DrawPanelBackground(ARect: TRect; ABevelInner, ABevelOuter: TBevelCut;
                ABevelSpace, ABevelWidth: Integer; AColor3DDark, AColor3DLight, AColor: TColor; AEnabled: Boolean = True);
    procedure DrawThemedPanelBkgnd(ARect: TRect);
    function GetDefaultFontSize: SmallInt;
    function GlyphExtent(AGlyphDesign: TGlyphDesign): TSize;
    procedure SetFontParams(AOrientation: Integer; ASize: Integer; AStyle: TFontStyles); deprecated;
  end;
  
  { TBitmapHelper }
  TBitmapHelper = class helper for TBitmap
  public
    function GetDefaultFontHeight: SmallInt;
    procedure SetProperties(AWidth, AHeight: Integer; ATransparent: Boolean = True);
    procedure TransparentClear;
  end;

  { TFontOptions }
  TFontOptions = class(TPersistent)
  private
    FFontColor: TColor;
    FFontSize: SmallInt;
    FFontStyles: TFontStyles;  
    procedure SetFontColor(const AValue: TColor);
    procedure SetFontSize(const AValue: SmallInt);
    procedure SetFontStyles(const AValue: TFontStyles);
  protected
    procedure RecalcRedraw;
    procedure Redraw;
  public
    OnRecalcRedraw: TObjectMethod;
    OnRedraw: TObjectMethod;
    constructor Create(AParent: TControl);
    procedure ApplyTo(AFont: TFont; ADefColor: TColor);
    function IsIdentical(AFont: TFont): Boolean;
  published
    property FontColor: TColor read FFontColor write SetFontColor default clDefault;
    property FontSize: SmallInt read FFontSize write SetFontSize default 0;
    property FontStyles: TFontStyles read FFontStyles write SetFontStyles default [];
  end;

  { TECBaseControl }
  TECBaseControl = class abstract(TCustomControl)
  private
    procedure SetBevelInner(const AValue: TBevelCut);
    procedure SetBevelOuter(const AValue: TBevelCut);
    procedure SetBevelSpace(const AValue: SmallInt);
    procedure SetBevelWidth(const AValue: SmallInt); 
    procedure SetColor3DDark(const AValue: TColor);
    procedure SetColor3DLight(const AValue: TColor); 
    procedure SetOrientation(const AValue: TObjectOrientation);
    procedure SetStyle(AValue: TObjectStyle);
  protected
    FBevelInner: TBevelCut;
    FBevelOuter: TBevelCut;
    FBevelSpace: SmallInt;
    FBevelWidth: SmallInt; 
    FColor3DDark: TColor;
    FColor3DLight: TColor;
    FInvalidRect: TRect;
    FOrientation: TObjectOrientation;
    FStyle: TObjectStyle;
    RedrawMode: TRedrawMode;
    function GetBorderWidth: Integer;  { Border = BevelInner + BevelOuter + BevelSpace }
    function HasCaption: Boolean; virtual;
    procedure InvalidateCustomRect(AMove: Boolean); virtual; abstract;
    procedure OrientationChanged({%H-}AValue: TObjectOrientation); virtual;
    procedure RecalcRedraw; virtual; abstract;
    procedure Redraw3DColorAreas; virtual; abstract; 
    procedure SetAutoSize(Value: Boolean); override;
    procedure StyleChanged({%H-}AValue: TObjectStyle); virtual;
    procedure WMPaint(var Message: TLMPaint); message LM_PAINT;  { resolves vanishing }
  public
    UpdateCount: SmallInt;
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate(Recalculate: Boolean = True); virtual;
    procedure InvalidateNonUpdated;  { Invalidates non-updated component (UpdateCount = 0) }
    procedure Redraw; virtual; abstract;
    property BevelInner: TBevelCut read FBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TBevelCut read FBevelOuter write SetBevelOuter default bvRaised;
    property BevelSpace: SmallInt read FBevelSpace write SetBevelSpace default 0;
    property BevelWidth: SmallInt read FBevelWidth write SetBevelWidth default 1;   
    property Color3DDark: TColor read FColor3DDark write SetColor3DDark default clDefault;
    property Color3DLight: TColor read FColor3DLight write SetColor3DLight default clDefault;  
    property Orientation: TObjectOrientation read FOrientation write SetOrientation;
    property Style: TObjectStyle read FStyle write SetStyle;
  end;

  { TECCustomKnob }
  TECCustomKnob = class(TPersistent)
  private
    FBackgroundColor: TColor;
    FBevelWidth: SmallInt;
    FColor: TColor;
    FCursor: TCursor;
    FHeight: SmallInt;
    FStyle: TObjectStyle;
    FTickMarkCount: SmallInt;
    FTickMarkDesign: TTickDesign;
    FTickMarkSpacing: SmallInt;
    FTickMarkStyle: TTickStyle;
    FWidth: SmallInt;
    procedure SetBackgroundColor(const AValue: TColor);
    procedure SetBevelWidth(const AValue: SmallInt);
    procedure SetColor(const AValue: TColor);
    procedure SetHeight(const AValue: SmallInt);
    procedure SetStyle(const AValue: TObjectStyle);
    procedure SetTickMarkCount(const AValue: SmallInt);
    procedure SetTickMarkDesign(const AValue: TTickDesign);
    procedure SetTickMarkSpacing(const AValue: SmallInt);
    procedure SetTickMarkStyle(const AValue: TTickStyle);
    procedure SetWidth(const AValue: SmallInt);
  protected const
    cDefBevelWidth = 2;
    cDefKnobHeight = 32;
    cDefKnobWidth = 20;
    cDefTickDesign = etd3DLowered;
    cDefTickMarkCount = 5;
    cDefTickMarkSpacing = 2;
  protected
    Parent: TECBaseControl;
    procedure DrawKnobs;
  public
    UpdateCount: SmallInt;
    KnobDisabled: TBitmap;
    KnobNormal: TBitmap;
    KnobHighlighted: TBitmap;
    Left: Integer;
    MouseInClient: Boolean;
    Top: Integer;
    constructor Create(AParent: TECBaseControl);
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure RecalcRedraw;
    procedure SetSize(AWidth, AHeight: Integer);
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
  public
    property BevelWidth: SmallInt read FBevelWidth write SetBevelWidth default cDefBevelWidth;
    property Color: TColor read FColor write SetColor default clDefault;
    property Cursor: TCursor read FCursor write FCursor default crHandPoint;
    property Height: SmallInt read FHeight write SetHeight default cDefKnobHeight;
    property Style: TObjectStyle read FStyle write SetStyle default eosButton;
    property TickMarkCount: SmallInt read FTickMarkCount write SetTickMarkCount default cDefTickMarkCount;
    property TickMarkDesign: TTickDesign read FTickMarkDesign write SetTickMarkDesign default cDefTickDesign;
    property TickMarkSpacing: SmallInt read FTickMarkSpacing write SetTickMarkSpacing default cDefTickMarkSpacing;
    property TickMarkStyle: TTickStyle read FTickMarkStyle write SetTickMarkStyle default etsSolid;
    property Width: SmallInt read FWidth write SetWidth default cDefKnobWidth;
  end;

  { TBaseScrollControl }                   
  TBaseScrollControl = class abstract(TCustomControl)
  private
    FAreaHeight: Integer;
    FAreaWidth: Integer;    
    function GetFullAreaHeight: Integer;
    function GetFullAreaWidth: Integer;  
    procedure SetAreaHeight(AValue: Integer);
    procedure SetAreaWidth(AValue: Integer);  
    procedure SetClientAreaLeft(AValue: Integer);
    procedure SetClientAreaTop(AValue: Integer);  
    procedure SetScrollBars(AValue: TScrollStyle);
  protected
    FClientAreaLeft: Integer;
    FClientAreaTop: Integer;
    FRequiredArea: TPoint;  { area where all devices can fit }
    FScrollBars: TScrollStyle;
    FScrollInfoHor, FScrollInfoVert: TScrollInfo;
    procedure CreateHandle; override;
    procedure DoUpdated; virtual;
    function GetIncrementX: Integer; virtual;
    function GetIncrementY: Integer; virtual;
    function GetPageSizeX: Integer; virtual;
    function GetPageSizeY: Integer; virtual;
    procedure UpdateRequiredAreaHeight; virtual; abstract; 
    procedure UpdateRequiredAreaWidth; virtual; abstract;  
    procedure UpdateScrollBars;
    procedure UpdateScrollInfoHor;
    procedure UpdateScrollInfoVert;  
    procedure WMHScroll(var Msg: TWMScroll); message WM_HSCROLL;
    procedure WMSize(var Message: TLMSize); message LM_SIZE;
    procedure WMVScroll(var Msg: TWMScroll); message WM_VSCROLL;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssAutoBoth;
  public
    UpdateCount: SmallInt;
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure InvalidateNonUpdated;
    property AreaHeight: Integer read FAreaHeight write SetAreaHeight default -1;
    property AreaWidth: Integer read FAreaWidth write SetAreaWidth default -1;  
    property ClientAreaLeft: Integer read FClientAreaLeft write SetClientAreaLeft stored False;
    property ClientAreaTop: Integer read FClientAreaTop write SetClientAreaTop stored False;
    property FullAreaHeight: Integer read GetFullAreaHeight;
    property FullAreaWidth: Integer read GetFullAreaWidth;
  end;

function AHSBToColor(A, H, S, B: Byte): TColor;

function ARGBToColor(A, R, G, B: Byte): TColor;

procedure ColorToHSBA(AColor: TColor; out H, S, B, A: Byte);

procedure ColorToRGBA(AColor: TColor; out R, G, B, A: Byte);

function ColorToStrLayouted(AColor: TColor; AColorLayout: TColorLayout; APrefix: string = ''): string;

function FloatToSIPrefix(AValue: Double; ARound: SmallInt): string;

function GetColorIntensity(AColor: TColor): Integer; inline;

function GetColorResolvingDefault(ASourceColor, ADefColor: TColor): TColor; inline;

function GetColorResolvingEnabled(ASourceColor: TColor; AEnabled: Boolean): TColor; inline;

function GetColorResolvingDefAndEnabled(ASourceColor, ADefColor: TColor; AEnabled: Boolean): TColor; inline;

function GetDecomposedMax(AColor: TColor): Integer; inline;

function GetDecomposedMin(AColor: TColor): Integer; inline;

function GetDesaturatedValue(AColor: TColor): Integer; inline;

function GetExtraDesaturatedValue(AColor: TColor): Integer; inline;

function GetMergedColor(AColor, BColor: TColor; AProportion: Single): TColor;

function GetMergedMonoColor(AColor, BColor: TColor; AProportion: Single): TColor;

function GetMonochromaticColor(AColor: TColor): TColor;

function GetSaturatedColor(AColor: TColor; AValue: Single): TColor;

procedure IncludeRectangle(var AResultRect: TRect; const AppendRect: TRect);

function InRangeCO(const AValue, AMin, AMax: Integer): Boolean; inline;  { closed, opened }

function IsColorDark(AColor: TColor): Boolean;

function IsInRange(AValue, ALimit, BLimit: Integer): Boolean;

function IsRectIntersect(ARect, BRect: TRect): Boolean;

function LinearToLogarithmic(AValue, AMin, AMax, ALogarithmBase: Double): Double;

function ModifyBrightness(AColor: TColor; ABrighness: Single): TColor;

function NormalizedRect(AX, AY, BX, BY: Integer): TRect;

procedure NormalizeRectangle(var ARect: TRect);

function PointToRect(const APoint: TPoint; ASize: Integer): TRect;

function RectToPoint(const ARect: TRect): TPoint;

function TrimColorString(const AString: string): string;

function TryStrToColorLayouted(AString: string; ALayout: TColorLayout; out AColor: TColor): Boolean;

const caDTRTLFlags: array[Boolean] of Cardinal = (DT_LEFT, DT_RTLREADING);
      caThemedContent: array[TItemState] of TThemedButton =
        (tbPushButtonDisabled, tbPushButtonHot, tbPushButtonNormal, tbPushButtonNormal,
         tbPushButtonPressed, tbPushButtonHot, tbPushButtonDisabled);
      caThemedItems: array[TItemState] of TThemedButton =
        (tbPushButtonDisabled, tbPushButtonHot, tbPushButtonNormal, tbPushButtonPressed,
         tbPushButtonPressed, tbPushButtonPressed, tbPushButtonPressed);
      caItemState: array[Boolean] of TItemState = (eisDisabled, eisEnabled);
      caDisabledStates = [eisDisabled, eisPushedDisabled];
      caEnabledStates = [eisHighlighted, eisEnabled, eisPushed, eisChecked, eisPushedHilighted];
      caGraphEffects: array[TItemState] of TGraphicsDrawEffect = (gdeDisabled,
        gdeHighlighted, gdeNormal, gdeNormal, gdeShadowed, gdeHighlighted, gdeDisabled);

var ArBtnDetails: array[Boolean, Boolean] of TThemedElementDetails;  { Enabled, Selected }
    FocusRectPattern: TPenPattern;
      
implementation

function AHSBToColor(A, H, S, B: Byte): TColor;
var red, green, blue: Byte;
begin
  HLStoRGB(H, B, S, red, green, blue);
  Result := ARGBToColor(A, red, green, blue);
end;

function ARGBToColor(A, R, G, B: Byte): TColor; inline;
begin
  Result := (A shl 24) or (B shl 16) or (G shl 8) or R;
end;

procedure ColorToHSBA(AColor: TColor; out H, S, B, A: Byte);
var red, green, blue: Byte;
begin
  ColorToRGBA(AColor, red, green, blue, A);
  RGBtoHLS(red, green, blue, H, B, S);
end;

procedure ColorToRGBA(AColor: TColor; out R, G, B, A: Byte);
begin
  R := AColor and $000000FF;
  G := (AColor shr 8) and $000000FF;
  B := (AColor shr 16) and $000000FF;
  A := (AColor shr 24) and $000000FF;
end;

function ColorToStrLayouted(AColor: TColor; AColorLayout: TColorLayout; APrefix: string = ''): string;
var RCH, GMS, BYB, A: Byte;  { Red/Cyan/Hue, Green/Magenta/Saturation, Blue/Yellow/Brightness, Alpha }
begin
  if AColorLayout = eclSystemBGR then
    if ColorToIdent(AColor, Result)
      then exit  { Exit! }
      else AColorLayout := eclBGRColor;
  case AColorLayout of
    eclRGBColor..eclYMCAColor: ColorToRGBA(AColor, RCH, GMS, BYB, A);
    eclHSBColor..eclBSHAColor: ColorToHSBA(AColor, RCH, GMS, BYB, A);
  end;
  case AColorLayout of
    eclRGBColor:  Result := intToHex((RCH shl 16) + (GMS shl 8) + BYB, 6);
    eclBGRColor:  Result := intToHex((BYB shl 16) + (GMS shl 8) + RCH, 6);
    eclARGBColor: Result := intToHex((A shl 24) + (RCH shl 16) + (GMS shl 8) + BYB, 8);
    eclABGRColor: Result := intToHex((A shl 24) + (BYB shl 16) + (GMS shl 8) + RCH, 8);
    eclRGBAColor: Result := intToHex((RCH shl 24) + (GMS shl 16) + (BYB shl 8) + A, 8);
    eclBGRAColor: Result := intToHex((BYB shl 24) + (GMS shl 16) + (RCH shl 8) + A, 8);
    eclCMYColor:  Result := intToHex(((255 - RCH) shl 16) + ((255 - GMS) shl 8) + 255 - BYB, 6);
    eclYMCColor:  Result := intToHex(((255 - BYB) shl 16) + ((255 - GMS) shl 8) + 255 - RCH, 6);
    eclACMYColor: Result := intToHex((A shl 24) + ((255 - RCH) shl 16) + ((255 - GMS) shl 8) + 255 - BYB, 8);
    eclAYMCColor: Result := intToHex((A shl 24) + ((255 - BYB) shl 16) + ((255 - GMS) shl 8) + 255 - RCH, 8);
    eclCMYAColor: Result := intToHex(((255 - RCH) shl 24) + ((255 - GMS) shl 16) + ((255 - BYB) shl 8) + A, 8);
    eclYMCAColor: Result := intToHex(((255 - BYB) shl 24) + ((255 - GMS) shl 16) + ((255 - RCH) shl 8) + A, 8);
    eclHSBColor:  Result := intToHex((RCH shl 16) + (GMS shl 8) + BYB, 6);
    eclBSHColor:  Result := intToHex((BYB shl 16) + (GMS shl 8) + RCH, 6);
    eclAHSBColor: Result := intToHex((A shl 24) + (RCH shl 16) + (GMS shl 8) + BYB, 8);
    eclABSHColor: Result := intToHex((A shl 24) + (BYB shl 16) + (GMS shl 8) + RCH, 8);
    eclHSBAColor: Result := intToHex((RCH shl 24) + (GMS shl 16) + (BYB shl 8) + A, 8);
    eclBSHAColor: Result := intToHex((BYB shl 24) + (GMS shl 16) + (RCH shl 8) + A, 8);
  end;
  Result := APrefix + Result;
end;     

function FloatToSIPrefix(AValue: Double; ARound: SmallInt): string;
const cPrefixes: array[-8..8] of string =
        ('y', 'z', 'a', 'f', 'p', 'n', 'μ', 'm', '', 'k', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y');
var aOrder: SmallInt;
begin
  if not IsZero(AValue) then
    begin
      aOrder := trunc(log10(abs(AValue)));
      aOrder := Math.min(aOrder, 24);   { Yotta }
      aOrder := Math.max(aOrder, -24);  { yocto }
      aOrder := aOrder div 3;
      if abs(AValue) < 1 then dec(aOrder);
      Result := floatToStrF(AValue/power(10, 3*aOrder), ffFixed, 3, ARound);
      if ARound <= 0
        then Result := Result + cPrefixes[aOrder]
        else if aOrder <> 0
               then Result := StringReplace(Result, DefaultFormatSettings.DecimalSeparator, cPrefixes[aOrder], []);
    end else
      Result := floatToStrF(0, ffFixed, 3, ARound);
end;

function GetColorIntensity(AColor: TColor): Integer;
begin  { simplified 2*R + 6*G + B }
  AColor := ColorToRGB(AColor);
  Result := 114*(2*(AColor and $FF) + 6*((AColor shr 8) and $FF) + (AColor shr 16) and $FF) shr 10;
end;

function GetColorResolvingDefault(ASourceColor, ADefColor: TColor): TColor;
begin
  Result := ASourceColor;
  if Result = clDefault then Result := ADefColor;
end; 

function GetColorResolvingEnabled(ASourceColor: TColor; AEnabled: Boolean): TColor;
begin
  Result := ASourceColor;
  if not AEnabled then Result := GetMonochromaticColor(Result);
end;

function GetColorResolvingDefAndEnabled(ASourceColor, ADefColor: TColor; AEnabled: Boolean): TColor;
begin
  Result := ASourceColor;
  if Result = clDefault then Result := ADefColor;  
  if not AEnabled then Result := GetMonochromaticColor(Result);
end;

function GetDecomposedMax(AColor: TColor): Integer;
var r, g, b: Byte;
begin
  GetRGBValues(ColorToRGB(AColor), r, g, b);
  Result := Math.max(Math.max(r, g), b);
end;

function GetDecomposedMin(AColor: TColor): Integer;
var r, g, b: Byte;
begin
  GetRGBValues(ColorToRGB(AColor), r, g, b);
  Result := Math.min(Math.min(r, g), b);
end;

function GetDesaturatedValue(AColor: TColor): Integer;
var r, g, b: Byte;
begin
  GetRGBValues(ColorToRGB(AColor), r, g, b);
  if r < g
    then if g < b
           then Result := (r + b) div 2  { r < g < b }
           else if r < b
                  then Result := (r + g) div 2   { r < b < g }
                  else Result := (g + b) div 2   { b < r < g }
    else if g > b
           then Result := (r + b) div 2  { r > g > b }
           else if r > b
                  then Result := (r + g) div 2   { r > b > g }
                  else Result := (g + b) div 2;  { b > r > g }
end;

function GetExtraDesaturatedValue(AColor: TColor): Integer;
var r, g, b: Byte;
begin
  GetRGBValues(ColorToRGB(AColor), r, g, b);
  if r < g
    then if r < b
           then Result := (5*g + 2*b) div 7   { r < (g,b) }
           else Result := (3*r + 5*g) div 8   { b < r < g }
    else if g > b
           then Result := (3*r + 5*g) div 8   { r > g > b }
           else Result := (3*r + 2*b) div 5;  { (b,r) > g }
end;

function GetMergedColor(AColor, BColor: TColor; AProportion: Single): TColor;
var aR, bR, aG, bG, aB, bB: Integer;
begin
  GetRGBIntValues(ColorToRGB(AColor), aR, aG, aB);
  GetRGBIntValues(ColorToRGB(BColor), bR, bG, bB);
  aR := bR + trunc((aR - bR)*AProportion);
  aG := bG + trunc((aG - bG)*AProportion);
  aB := bB + trunc((aB - bB)*AProportion);
  Result := RGBToColor(aR, aG, aB);
end;

function GetMergedMonoColor(AColor, BColor: TColor; AProportion: Single): TColor;
var i, j: Integer;
begin
  i := GetColorIntensity(AColor);
  j := GetColorIntensity(BColor);
  i := j + trunc((i - j)*AProportion);
  Result := (i shl 16) or (i shl 8) or i;
end;

function GetMonochromaticColor(AColor: TColor): TColor;
var i: Integer;
begin
  i := GetExtraDesaturatedValue(AColor);
  Result := (i shl 16) or (i shl 8) or i;
end;

function GetSaturatedColor(AColor: TColor; AValue: Single): TColor;  { (monochrome) 0..1 (no change) }
var r, g, b: Integer;
    aComplement: Single;
begin
  GetRGBIntValues(ColorToRGB(AColor), r, g, b);
  aComplement := 0.33333*(1 - AValue)*(r + g + b);
  r := trunc(AValue*r + aComplement);
  g := trunc(AValue*g + aComplement);
  b := trunc(AValue*b + aComplement);
  Result := RGBToColor(r, g, b);
end;

procedure IncludeRectangle(var AResultRect: TRect; const AppendRect: TRect);
begin
  AResultRect.Left := Math.min(AResultRect.Left, AppendRect.Left);
  AResultRect.Top := Math.min(AResultRect.Top, AppendRect.Top);
  AResultRect.Right := Math.max(AResultRect.Right, AppendRect.Right);
  AResultRect.Bottom := Math.max(AResultRect.Bottom, AppendRect.Bottom);
end;

function InRangeCO(const AValue, AMin, AMax: Integer): Boolean;
begin
  Result := ((AValue >= AMin) and (AValue < AMax));
end;

function IsColorDark(AColor: TColor): Boolean;
begin
  Result := (GetColorIntensity(AColor) < 160);
end;

function IsInRange(AValue, ALimit, BLimit: Integer): Boolean;
begin
  Result := ((ALimit <= AValue) and (AValue <= BLimit)) or
            ((BLimit <= AValue) and (AValue <= ALimit));
end;

function IsRectIntersect(ARect, BRect: TRect): Boolean;
begin
  Result := not ((ARect.Right < BRect.Left) or (BRect.Right < ARect.Left)
              or (ARect.Bottom < BRect.Top) or (BRect.Bottom < ARect.Top));
end;
           
function LinearToLogarithmic(AValue, AMin, AMax, ALogarithmBase: Double): Double;
var aProportion: Double;
begin
  aProportion := (AValue - AMin)/(AMax - AMin);
  if AMin > 0
    then AMin := logn(ALogarithmBase, AMin)
    else AMin := 0;
  if AMax > 0
    then AMax := logn(ALogarithmBase, AMax)
    else AMax := 0;
  Result := power(ALogarithmBase, AMin + (AMax - AMin)*aProportion);  
end;

function ModifyBrightness(AColor: TColor; ABrighness: Single): TColor;
var r, g, b: Integer;
begin
  GetRGBIntValues(ColorToRGB(AColor), r, g, b);
  b := round(b*ABrighness);
  if b > 255 then b := 255;
  g := round(g*ABrighness);
  if g > 255 then g := 255;
  r:=round(r*ABrighness);
  if r > 255 then r := 255;
  Result:=RGBToColor(r, g, b);
end;

function NormalizedRect(AX, AY, BX, BY: Integer): TRect;
begin
  if AX<=BX then
    begin
      Result.Left:=AX;
      Result.Right:=BX;
    end else
    begin
      Result.Left:=BX;
      Result.Right:=AX;
    end;
  if AY<=BY then
    begin
      Result.Top:=AY;
      Result.Bottom:=BY;
    end else
    begin
      Result.Top:=BY;
      Result.Bottom:=AY;
    end;
end;

procedure NormalizeRectangle(var ARect: TRect);
var k: Integer;
begin
  if ARect.Left > ARect.Right then
    begin
      k := ARect.Left;
      ARect.Left := ARect.Right;
      ARect.Right := k;
    end;
  if ARect.Top > ARect.Bottom then
    begin
      k := ARect.Top;
      ARect.Top := ARect.Bottom;
      ARect.Bottom := k;
    end;
end;

function PointToRect(const APoint: TPoint; ASize: Integer): TRect;
begin
  Result.Left := APoint.X - ASize div 2;
  Result.Top := APoint.Y - ASize div 2;
  Result.Right := Result.Left + ASize;
  Result.Bottom := Result.Top + ASize;
end;

function RectToPoint(const ARect: TRect): TPoint;
begin
  Result.X := (ARect.Left + ARect.Right) div 2;
  Result.Y := (ARect.Top + ARect.Bottom) div 2;
end;

function TrimColorString(const AString: string): string;
var aChar: Char;
    i: SmallInt;
begin
  Result := '';
  for i := 1 to length(AString) do
    begin
      {$IFDEF DBGLINE} DebugLn('Character '+ AString[i]); {$ENDIF}
      aChar := aString[i];
      if (aChar in ['0'..'9', 'A'..'F', 'a'..'f']) then Result := Result + aChar;
    end;
  {$IFDEF DBGLINE} DebugLn('Result: '+ Result); {$ENDIF}
end;     

function TryStrToColorLayouted(AString: string; ALayout: TColorLayout; out AColor: TColor): Boolean;
var i, aLength: SmallInt;
    a, r, g, b, rc, gc, bc: Byte;
begin
  if ALayout > eclSystemBGR then
    begin      
      if ALayout in [eclRGBColor, eclBGRColor, eclCMYColor, eclYMCColor, eclHSBColor, eclBSHColor]
        then aLength := 6
        else aLength := 8;
      AString := TrimColorString(AString);
      {$IFDEF DBGLINE} DebugLn('AColorString ' + AString); {$ENDIF}
      AString:= RightStr(AString, aLength);
      i := length(AString);
      if i < aLength then
        for i := 0 to aLength - 1 - i do
          AString := '0' + AString;             
      {$IFDEF DBGLINE}  DebugLn('AColorString ' + AString); {$ENDIF}
      try
        b := Hex2Dec(RightStr(AString, 2));
        if aLength = 6 then
          begin
            g := Hex2Dec(MidStr(AString, 3, 2));
            r := Hex2Dec(LeftStr(AString, 2));
            a := 0;
          end else
          begin
            g := Hex2Dec(MidStr(AString, 5, 2));
            r := Hex2Dec(MidStr(AString, 3, 2));
            a := Hex2Dec(LeftStr(AString, 2));
          end;
        case ALayout of
          eclRGBColor, eclARGBColor: AColor := ARGBToColor(a, r, g, b);
          eclBGRColor, eclABGRColor: AColor := ARGBToColor(a, b, g, r);
          eclRGBAColor: AColor := ARGBToColor(b, a, r, g);
          eclBGRAColor: AColor := ARGBToColor(b, g, r, a);
          eclCMYColor, eclACMYColor: AColor := ARGBToColor(a, 255 - r, 255 - g, 255 - b);
          eclYMCColor, eclAYMCColor: AColor := ARGBToColor(a, 255 - b, 255 - g, 255 - r);
          eclCMYAColor: AColor := ARGBToColor(b, 255 - a, 255 - r, 255 - g);
          eclYMCAColor: AColor := ARGBToColor(b, 255 - g, 255 - r, 255 - a);
          eclHSBColor, eclAHSBColor:
            begin
              HLStoRGB(r, b, g, rc, gc, bc);
              AColor := ARGBToColor(a, rc, gc, bc);
            end;
          eclBSHColor, eclABSHColor:
            begin
              HLStoRGB(b, r, g, rc, gc, bc);
              AColor := ARGBToColor(a, rc, gc, bc);
            end;
          eclHSBAColor:
            begin
              HLStoRGB(a, g, r, rc, gc, bc);
              AColor := ARGBToColor(b, rc, gc, bc);
            end;
          eclBSHAColor:
            begin
              HLStoRGB(g, a, r, rc, gc, bc);
              AColor := ARGBToColor(b, rc, gc, bc);
            end;
        end;
        Result := True;
      except
      end;
    end else
    begin
      try
        Result := IdentToColor(trim(AString), AColor);
        if not Result then
          begin
            AString := TrimColorString(AString);
            i := length(AString);
            Result := (i in [6, 8]);
            if Result then AColor := TColor(Hex2Dec(AString));
          end;
      except
      end;
    end;
end;

{ TCanvasHelper }

procedure TCanvasHelper.DrawButtonBackground(ARect: TRect; AItemState: TItemState);
begin                
  with ThemeServices do
    DrawElement(Handle, GetElementDetails(caThemedItems[AItemState]), ARect, nil);
end;

procedure TCanvasHelper.DrawFinePanelBkgnd(ARect: TRect; ABevelCut: TBevelCut; ABevelWidth: SmallInt;
            AColor3DDark, AColor3DLight, AColor: TColor; AFillBkgnd: Boolean; AEnabled: Boolean);
var aProportion: Single;
    aSwapColor: TColor;
    i: Integer;
begin
  AColor3DDark := GetColorResolvingDefAndEnabled(AColor3DDark, clBtnShadow, AEnabled);
  AColor3DLight := GetColorResolvingDefAndEnabled(AColor3DLight, clBtnHilight, AEnabled);
  if not AEnabled then AColor := GetMonochromaticColor(AColor);
  if ABevelCut = bvLowered then
    begin
      aSwapColor := AColor3DDark;
      AColor3DDark := AColor3DLight;
      AColor3DLight := aSwapColor;
    end;
  Pen.Width := 1;
  for i := 0 to ABevelWidth - 1 do
    begin
      if not (ABevelCut = bvLowered)
        then aProportion := i/ABevelWidth
        else aProportion := 1 - (i + 1)/ABevelWidth;
      Pen.Color := GetMergedColor(AColor, AColor3DLight, aProportion);
      Line(ARect.Left + i, ARect.Top + i, ARect.Left + i, ARect.Bottom - i);
      Line(ARect.Left + i, ARect.Top + i, ARect.Right - i, ARect.Top + i);
      Pen.Color := GetMergedColor(AColor, AColor3DDark, aProportion);
      Line(ARect.Left + i, ARect.Bottom - i - 1, ARect.Right - i, ARect.Bottom - i - 1);
      Line(ARect.Right - i - 1, ARect.Top + i, ARect.Right - i - 1, ARect.Bottom - i);
    end;
  if AFillBkgnd then
    begin
      Brush.Color := AColor;
      InflateRect(ARect, -ABevelWidth, -ABevelWidth);
      FillRect(ARect);
    end;
end;

procedure TCanvasHelper.DrawFocusRectNonThemed(const ARect: TRect);
var i, j, r, b: SmallInt;
begin
  Brush.Style := bsClear;
  Pen.Color := clBtnText;
  Pen.Style := psPattern;
  Pen.Width := 1;
  LCLIntf.SetBkColor(Handle, ColorToRGB(clBtnFace));
  r := ARect.Right - 1;
  b := ARect.Bottom - 1;
  Pen.SetPattern(FocusRectPattern);
  i := (r - ARect.Left) and 1;
  j := (b - ARect.Top) and 1;
  Line(ARect.Left, ARect.Top, r, ARect.Top);
  Line(r, ARect.Top + i, r, b);
  Line(r - ((i + j) and 1), b, ARect.Left, b);
  Line(ARect.Left, b - j, ARect.Left, ARect.Top + j);
end;

{$I ecdrawglyph.inc}

procedure TCanvasHelper.DrawPanelBackground(ARect: TRect; ABevelInner, ABevelOuter: TBevelCut;
            ABevelWidth: Integer; AColor: TColor; AEnabled: Boolean);
begin             
  DrawPanelBackground(ARect, ABevelInner, ABevelOuter, 0, ABevelWidth, clDefault, clDefault, AColor, AEnabled);
end;

procedure TCanvasHelper.DrawPanelBackground(ARect: TRect; ABevelInner, ABevelOuter: TBevelCut;
            ABevelSpace, ABevelWidth: Integer; AColor3DDark, AColor3DLight, AColor: TColor; AEnabled: Boolean);
begin
  { both Canvas.Frame3D methods deflate Rectangle }
  { bvSpace draw the frame using Canvas.Brush.Color }
  AColor3DDark := GetColorResolvingDefAndEnabled(AColor3DDark, clBtnShadow, AEnabled);
  AColor3DLight := GetColorResolvingDefAndEnabled(AColor3DLight, clBtnHiLight, AEnabled);
  if not AEnabled then AColor := GetMonochromaticColor(AColor);
  Brush.Color := AColor;
  case ABevelOuter of
    bvLowered: Frame3D(ARect, AColor3DDark, AColor3DLight, ABevelWidth);
    bvRaised:  Frame3D(ARect, AColor3DLight, AColor3DDark, ABevelWidth);
    bvSpace:   Frame3D(ARect, ABevelWidth, bvSpace);
  end;
  Frame3D(ARect, ABevelSpace, bvSpace);
  case ABevelInner of
    bvLowered: Frame3D(ARect, AColor3DDark, AColor3DLight, ABevelWidth);
    bvRaised:  Frame3D(ARect, AColor3DLight, AColor3DDark, ABevelWidth);
    bvSpace:   Frame3D(ARect, ABevelWidth, bvSpace);
  end;
  FillRect(ARect);
end;

procedure TCanvasHelper.DrawThemedPanelBkgnd(ARect: TRect);
begin
  with ThemeServices do
    DrawElement(Handle, GetElementDetails(ttPane), ARect, nil);
end;

function TCanvasHelper.GetDefaultFontSize: SmallInt;
var i, aFontSize, aZeroSize: SmallInt;
begin
  aFontSize := Font.Size;
  Font.Size := 0;
  aZeroSize := TextHeight('Ťj');
  Result := round(3*(aZeroSize - 2)/4);
  for i:=5 to 39 do
    begin
      Font.Size := i;
      if TextHeight('Ťj') >= aZeroSize then
        begin
          Result := i;
          break;
        end;
    end;
  Font.Size := aFontSize;
end;

function TCanvasHelper.GlyphExtent(AGlyphDesign: TGlyphDesign): TSize;
const cLargeGlyph = 16;
      cSmallGlyph = 8;
begin
  case AGlyphDesign of
    egdNone: Result := Size(0, 0);
    egdEmpty..egdArrowsUDHor: Result := Size(cSmallGlyph, cSmallGlyph);
    egdArrowsURDL_S: Result := Size(10, 10); 
    egdArrowsURDL_M: Result := Size(10, 10);
    egdArrowURDL_L:  Result := Size(11, 11);
    egdArrowURDL_XL: Result := Size(12, 12);  
    egdArrowsUL_DR..egdArrC_Max: Result := Size(cSmallGlyph, cSmallGlyph);
    egdArrC_URDL: Result := Size(cLargeGlyph, cLargeGlyph);  
    egdPlayRec..egdFrame: Result := Size(cSmallGlyph, cSmallGlyph);
   { egdRadioOffTh .. egdCheckOnTh: ; }
    otherwise Result := Size(cLargeGlyph, cLargeGlyph);  
  end;
end;

procedure TCanvasHelper.SetFontParams(AOrientation: Integer; ASize: Integer; AStyle: TFontStyles);
begin
  with Font do
    begin
      Orientation := AOrientation;
      Size := ASize;
      Style := AStyle;
    end;
end;

{ TBitmapHelper }

function TBitmapHelper.GetDefaultFontHeight: SmallInt;
var i, aZeroHeight: SmallInt;
begin
  Canvas.Font.Height := 0;
  aZeroHeight := Canvas.TextHeight('Ťj');
  Result := aZeroHeight - 2;
  for i:=5 to 39 do
    begin
      Canvas.Font.Height := i;
      if Canvas.TextHeight('Ťj') >= aZeroHeight then
        begin
          Result := i;
          break;
        end;
    end;
end;

procedure TBitmapHelper.SetProperties(AWidth, AHeight: Integer; ATransparent: Boolean = True);
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Mode := pmCopy;
  Canvas.Pen.Style := psSolid;
  Transparent := ATransparent;
  TransparentMode := tmFixed;
  SetSize(AWidth, AHeight);
end;

procedure TBitmapHelper.TransparentClear;
var aTransparentColor: TColor;
begin
  aTransparentColor := TransparentColor;
  TransparentColor := clSilver;      
  Canvas.Brush.Color := aTransparentColor;
  Canvas.FillRect(0, 0, Width, Height);
  TransparentColor := aTransparentColor;
end;

{ TFontOptions }

constructor TFontOptions.Create(AParent: TControl);
begin
  FFontColor := clDefault;
  if assigned(AParent) then
    with AParent do
      begin
        FFontStyles := Font.Style;
        FFontSize := Font.Size;
      end;
end;

procedure TFontOptions.ApplyTo(AFont: TFont; ADefColor: TColor);
begin
  AFont.BeginUpdate;
  if FontColor <> clDefault
    then AFont.Color := FontColor
    else if AFont.Color = clDefault then AFont.Color := ADefColor;
  AFont.Size := FontSize;
  AFont.Style := FontStyles;
  AFont.EndUpdate;
end;

function TFontOptions.IsIdentical(AFont: TFont): Boolean;
begin
  Result := ((AFont.Color = FontColor) and (AFont.Size = FontSize) and (AFont.Style = FontStyles));
end;

procedure TFontOptions.RecalcRedraw;
begin
  if assigned(OnRecalcRedraw) then OnRecalcRedraw;
end;

procedure TFontOptions.Redraw;
begin
  if assigned(OnRedraw) then OnRedraw;
end;

procedure TFontOptions.SetFontColor(const AValue: TColor);
begin
  if FFontColor = AValue then exit;
  FFontColor := AValue;
  Redraw;
end;

procedure TFontOptions.SetFontSize(const AValue: SmallInt);
begin
  if FFontSize = AValue then exit;
  FFontSize := AValue;
  RecalcRedraw;
end;

procedure TFontOptions.SetFontStyles(const AValue: TFontStyles);
begin
  if FFontStyles = AValue then exit;
  FFontStyles := AValue;
  RecalcRedraw;
end;

{ TECBaseControl }

constructor TECBaseControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csParentBackground, csReplicatable] - [csOpaque];
  FBevelInner := bvNone;
  FBevelOuter := bvRaised;
  FBevelWidth := 1;           
  Color := clDefault;   
  FColor3DDark := clDefault;
  FColor3DLight := clDefault;
end;   

procedure TECBaseControl.BeginUpdate;
begin
  inc(UpdateCount);
end; 

procedure TECBaseControl.EndUpdate(Recalculate: Boolean = True);
begin
  dec(UpdateCount);
  if UpdateCount <= 0 then
    begin
      UpdateCount := 0;
      if Recalculate
        then RecalcRedraw
        else Redraw;
    end;
end;   

function TECBaseControl.GetBorderWidth: Integer;
var i: Integer;
begin
  i := 0;
  if BevelOuter <> bvNone then inc(i);
  if BevelInner <> bvNone then inc(i);
  Result := BevelSpace + i*BevelWidth;
end;   

function TECBaseControl.HasCaption: Boolean;
begin
  Result := (Caption <> ''); 
end;       

procedure TECBaseControl.InvalidateNonUpdated;
begin
  if UpdateCount = 0 then Invalidate;
end;    
   
procedure TECBaseControl.OrientationChanged(AValue: TObjectOrientation);
begin
  RecalcRedraw;
end;   

procedure TECBaseControl.SetAutoSize(Value: Boolean);
begin
  inherited SetAutoSize(Value);
  if Value then
    begin
      InvalidatePreferredSize;
      AdjustSize;
    end; 
end;   

procedure TECBaseControl.StyleChanged(AValue: TObjectStyle);
begin
  Redraw;
end;     

procedure TECBaseControl.WMPaint(var Message: TLMPaint);
begin
  if (RedrawMode < ermFreeRedraw) and 
    ((Message.PaintStruct^.rcPaint.Left < FInvalidRect.Left) 
    or (Message.PaintStruct^.rcPaint.Top < FInvalidRect.Top)
    or (Message.PaintStruct^.rcPaint.Right > FInvalidRect.Right) 
    or (Message.PaintStruct^.rcPaint.Bottom > FInvalidRect.Bottom))
    then RedrawMode := ermFreeRedraw;  
  inherited WMPaint(Message);
end;     

{ TECBaseControl.Setters }

procedure TECBaseControl.SetBevelInner(const AValue: TBevelCut);
begin
  if FBevelInner = AValue then exit;
  FBevelInner := AValue;
  RecalcRedraw;
end;

procedure TECBaseControl.SetBevelOuter(const AValue: TBevelCut);
begin
  if FBevelOuter = AValue then exit;
  FBevelOuter := AValue;
  RecalcRedraw;
end;

procedure TECBaseControl.SetBevelSpace(const AValue: SmallInt);
begin
  if FBevelSpace = AValue then exit;
  FBevelSpace := AValue;
  RecalcRedraw;
end;

procedure TECBaseControl.SetBevelWidth(const AValue: SmallInt);
begin
  if FBevelWidth = AValue then exit;
  FBevelWidth := AValue;
  RecalcRedraw;
end;             

procedure TECBaseControl.SetColor3DDark(const AValue: TColor);
begin
  if FColor3DDark = AValue then exit;
  FColor3DDark := AValue;
  Redraw3DColorAreas;
end;

procedure TECBaseControl.SetColor3DLight(const AValue: TColor);
begin
  if FColor3DLight = AValue then exit;
  FColor3DLight := AValue;
  Redraw3DColorAreas; 
end;

procedure TECBaseControl.SetOrientation(const AValue: TObjectOrientation);
begin
  if FOrientation = AValue then exit;
  FOrientation := AValue;
  OrientationChanged(AValue);
end;       

procedure TECBaseControl.SetStyle(AValue: TObjectStyle);
begin
  if FStyle = AValue then exit;
  FStyle := AValue;
  StyleChanged(AValue);
end;       

{ TECCustomKnob }

constructor TECCustomKnob.Create(AParent: TECBaseControl);
begin
  inherited Create;
  Parent := AParent;  { don't change order ! }
  FBevelWidth := cDefBevelWidth;
  FColor := clDefault;
  FCursor := crHandPoint;
  FHeight := cDefKnobHeight;
  FTickMarkCount := cDefTickMarkCount;
  FTickMarkDesign := cDefTickDesign;
  FTickMarkSpacing := cDefTickMarkSpacing;
  FWidth := cDefKnobWidth;
  KnobDisabled := TBitmap.Create;
  KnobDisabled.SetProperties(FWidth, FHeight);
  if not KnobDisabled.Canvas.HandleAllocated then
    KnobDisabled.Canvas.GetUpdatedHandle([csHandleValid]); 
  KnobNormal := TBitmap.Create;
  KnobNormal.SetProperties(FWidth, FHeight);
  if not KnobNormal.Canvas.HandleAllocated then
    KnobNormal.Canvas.GetUpdatedHandle([csHandleValid]);     
  KnobHighlighted := TBitmap.Create;
  KnobHighlighted.SetProperties(FWidth, FHeight);
  if not KnobHighlighted.Canvas.HandleAllocated then
    KnobHighlighted.Canvas.GetUpdatedHandle([csHandleValid]);     
end;

destructor TECCustomKnob.Destroy;
begin
  FreeAndNil(KnobDisabled);
  FreeAndNil(KnobNormal);
  FreeAndNil(KnobHighlighted);
  inherited Destroy;
end;

procedure TECCustomKnob.BeginUpdate;
begin
  inc(UpdateCount);
end;     

procedure TECCustomKnob.DrawKnobs;
var aRect: TRect;

  procedure DrawPanelBevel(AKnob: TBitmap; AEnabled: Boolean);
  var aColor3DDark, aColor3DLight: TColor;
  begin
    aColor3DDark := Parent.FColor3DDark;
    aColor3DLight := Parent.FColor3DLight;
    aColor3DDark := GetColorResolvingDefAndEnabled(aColor3DDark, clBtnShadow, AEnabled);
    aColor3DLight := GetColorResolvingDefAndEnabled(aColor3DLight, clBtnHilight, AEnabled);
    AKnob.Canvas.Frame3D(aRect, aColor3DLight, aColor3DDark, BevelWidth);
  end;

var aHeight, aWidth, h, i, j, k: SmallInt;
    bLight, bVert: Boolean;

  procedure DrawTicks(AKnob: TBitmap; AEnabled: Boolean = True);
  var aColor: TColor;

    procedure DrawTick(AKnob: TBitmap);
          { light-scheme, enabled, normal line=0/lowered=1/raised=2 }
    const aBrightness: array[Boolean, Boolean, 0..2] of Single =
            (((2, 0.8, 1.2), (3, 0.67, 1.4)), ((0.67, 0.8, 1.2), (0.5, 0.67, 1.4)));
            { dark disabled,  dark enabled,     light disabled,   light enabled }

      procedure DrawLine(x1, y1, x2: SmallInt; ABrightness: Single);
      var l: SmallInt;
      begin
        case TickMarkStyle of
          etsSolid:
            begin
              AKnob.Canvas.Pen.Color := ModifyBrightness(aColor, ABrightness);
              if bVert
                then AKnob.Canvas.Line(x1, y1, x2, y1)
                else AKnob.Canvas.Line(y1, x1, y1, x2);
            end;
          etsDotted:
            for l := x1 to x2 - 1 do
              if ((l - x1) mod 3) = 0 then
                if bVert
                  then AKnob.Canvas.Pixels[l, y1] := ModifyBrightness(aColor, ABrightness)
                  else AKnob.Canvas.Pixels[y1, l] := ModifyBrightness(aColor, ABrightness);
        end;
      end;

    begin
      with AKnob.Canvas do
        case FTickMarkDesign of
          etdSimple: DrawLine(i, h, j, aBrightness[bLight, AEnabled, 0]);
          etdThick:
            if TickMarkStyle = etsSolid then
              begin
                DrawLine(i, h - 1, j, aBrightness[bLight, AEnabled, 0]);
                DrawLine(i, h, j, aBrightness[bLight, AEnabled, 0]);
              end else
              begin
                DrawLine(i, h, j, aBrightness[bLight, AEnabled, 1]);
                DrawLine(i + 1, h, j + 1, aBrightness[bLight, AEnabled, 1]);
                DrawLine(i, h + 1, j, aBrightness[bLight, AEnabled, 1]);
                DrawLine(i + 1, h + 1, j + 1, aBrightness[bLight, AEnabled, 2]);
              end;
          etd3DLowered:
            if TickMarkStyle = etsSolid then
              begin
                DrawLine(i, h - 1, j, aBrightness[bLight, AEnabled, 1]);
                DrawLine(i, h, j, aBrightness[bLight, AEnabled, 2]);
              end else
              begin
                DrawLine(i, h - 1, j, aBrightness[bLight, AEnabled, 1]);
                DrawLine(i + 1, h, j + 1, aBrightness[bLight, AEnabled, 2]);
              end;
          etd3DRaised:
            if TickMarkStyle = etsSolid then
              begin
                DrawLine(i, h, j, aBrightness[bLight, AEnabled, 1]);
                DrawLine(i, h - 1, j, aBrightness[bLight, AEnabled, 2]);
              end else
              begin
                 DrawLine(i, h, j, aBrightness[bLight, AEnabled, 1]);
                 DrawLine(i - 1, h - 1, j - 1, aBrightness[bLight, AEnabled, 2]);
              end;
        end;
    end;

  var l: SmallInt;
  begin
    aColor := AKnob.Canvas.Pixels[aWidth div 2, aHeight div 2];
    AKnob.Canvas.Pen.Style := psSolid;
    if (TickMarkCount mod 2) = 1 then
      begin
        h := aHeight div 2;
        DrawTick(AKnob);
        for l := 1 to (FTickMarkCount div 2) do
          begin
            h := (aHeight div 2) + 3*l;
            if h < (aHeight-3) then DrawTick(AKnob);
            h := (aHeight div 2) - 3*l;
            if h >= 3 then DrawTick(AKnob);
          end;
      end else
        for l := 1 to (TickMarkCount div 2) do
          begin
            h := (aHeight div 2) - 2 + 3*l;
            if h < (aHeight-3) then DrawTick(AKnob);
            h := (aHeight div 2) + 1 - 3*l;
            if h >= 3 then DrawTick(AKnob);
          end;
  end;

begin
  {$IFDEF DBGLINE} DebugLn('DrawKnobs'); {$ENDIF}
  if (UpdateCount = 0) and assigned(Parent) and assigned(Parent.Parent) then
    begin
      KnobDisabled.BeginUpdate(True);
      KnobHighlighted.BeginUpdate(True);
      KnobNormal.BeginUpdate(True);
      aRect := Rect(0, 0, Width, Height);
      case FStyle of
        eosButton:
          begin
            KnobDisabled.TransparentClear;
            KnobDisabled.Canvas.DrawButtonBackground(aRect, eisDisabled);
            KnobNormal.TransparentClear;      
            KnobNormal.Canvas.DrawButtonBackground(aRect, eisEnabled);
            KnobHighlighted.TransparentClear;
            KnobHighlighted.Canvas.DrawButtonBackground(aRect, eisHighlighted);
          end;    
        eosPanel, eosThemedPanel:
          begin
            DrawPanelBevel(KnobDisabled, False);
            aRect := Rect(0, 0, Width, Height);
            DrawPanelBevel(KnobNormal, True);
            aRect := Rect(0, 0, Width, Height);
            DrawPanelBevel(KnobHighlighted, True);
            i := BevelWidth;
            aRect := Rect(i, i, Width - i, Height - i);
            KnobNormal.Canvas.Brush.Color := GetColorResolvingDefault(Color, BackgroundColor);
            KnobNormal.Canvas.FillRect(aRect);
            KnobDisabled.Canvas.Brush.Color := GetMonochromaticColor(ColorToRGB(KnobNormal.Canvas.Brush.Color));
            KnobDisabled.Canvas.FillRect(aRect);
            KnobHighlighted.Canvas.Brush.Color := ModifyBrightness(ColorToRGB(KnobNormal.Canvas.Brush.Color), 1.07);
            KnobHighlighted.Canvas.FillRect(aRect);
          end;
        eosFinePanel:
          begin
            KnobNormal.Canvas.DrawFinePanelBkgnd(aRect, bvRaised, BevelWidth, Parent.FColor3DDark,
              Parent.FColor3DLight, GetColorResolvingDefault(Color, BackgroundColor), True);
            KnobDisabled.Canvas.DrawFinePanelBkgnd(aRect, bvRaised, BevelWidth, Parent.FColor3DDark,
              Parent.FColor3DLight, ModifyBrightness(ColorToRGB(KnobNormal.Canvas.Brush.Color), 0.94), True, False);
            KnobHighlighted.Canvas.DrawFinePanelBkgnd(aRect, bvRaised, BevelWidth, Parent.FColor3DDark,
              Parent.FColor3DLight, ModifyBrightness(ColorToRGB(KnobNormal.Canvas.Brush.Color), 1.07), True);
          end;
      end;
      bVert := (Parent.FOrientation = eooVertical);
      if bVert then  { Parent is vertical }
        begin
          aHeight := FHeight;
          aWidth := FWidth;
        end else
        begin
          aWidth := FHeight;
          aHeight := FWidth;
        end;
      if (TickMarkCount > 0) and (aWidth >= 10) and (aHeight > 6) then
        begin
          bLight := IsColorDark(ColorToRGB(clBtnText));  { detect light or dark scheme }
          i := BevelWidth + TickMarkSpacing;
          j := aWidth - i;
          if TickMarkStyle = etsDotted then
            begin
              k := (aWidth - 2*i) mod 3;
              if k < 2 then inc(i);
              if k = 0 then inc(j);
              if TickMarkDesign = etd3DRaised then inc(i);
            end;
          DrawTicks(KnobDisabled, False);
          DrawTicks(KnobNormal);
          DrawTicks(KnobHighlighted);
        end;
      KnobDisabled.EndUpdate(False);
      KnobHighlighted.EndUpdate(False);
      KnobNormal.EndUpdate(False);
    end;
end;

procedure TECCustomKnob.EndUpdate;
begin
  dec(UpdateCount);
  if UpdateCount = 0 then DrawKnobs;
end;

procedure TECCustomKnob.RecalcRedraw;
begin
  if assigned(Parent) then Parent.RecalcRedraw;
end;

procedure TECCustomKnob.SetSize(AWidth, AHeight: Integer);
begin
  if Height <> AHeight then 
    begin
      FWidth := AWidth;
      Height := AHeight;
    end else
      Width := AWidth;
  if AWidth = AHeight then DrawKnobs;
end;

{ TECCustomKnob.Setters }

procedure TECCustomKnob.SetBackgroundColor(const AValue: TColor);
var aTransColor: TColor;
begin
  if FBackgroundColor = AValue then exit;
  FBackgroundColor := AValue;
  aTransColor := ColorToRGB(AValue) and $FAFCFE + $020301;
  KnobDisabled.TransparentColor := aTransColor;
  KnobHighlighted.TransparentColor := aTransColor;
  KnobNormal.TransparentColor := aTransColor;
  DrawKnobs;
end;             
        
procedure TECCustomKnob.SetBevelWidth(const AValue: SmallInt);
begin
  if FBevelWidth = AValue then exit;
  FBevelWidth := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;

procedure TECCustomKnob.SetColor(const AValue: TColor);
begin
  if FColor = AValue then exit;
  FColor := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;

procedure TECCustomKnob.SetHeight(const AValue: SmallInt);
var aWidth: SmallInt;
begin
  if (AValue < 1) or (FHeight = AValue) then exit;
  FHeight := AValue;
  aWidth := FWidth;
  KnobDisabled.SetSize(aWidth, AValue);
  KnobNormal.SetSize(aWidth, AValue);
  KnobHighlighted.SetSize(aWidth, AValue);
  DrawKnobs;
  RecalcRedraw;
end;

procedure TECCustomKnob.SetStyle(const AValue: TObjectStyle);
begin
  if FStyle = AValue then exit;
  FStyle := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;  

procedure TECCustomKnob.SetTickMarkCount(const AValue: SmallInt);
begin
  if FTickMarkCount = AValue then exit;
  FTickMarkCount := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;

procedure TECCustomKnob.SetTickMarkDesign(const AValue: TTickDesign);
begin
  if FTickMarkDesign = AValue then exit;
  FTickMarkDesign := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;

procedure TECCustomKnob.SetTickMarkSpacing(const AValue: SmallInt);
begin
  if FTickMarkSpacing = AValue then exit;
  FTickMarkSpacing := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;

procedure TECCustomKnob.SetTickMarkStyle(const AValue: TTickStyle);
begin
  if FTickMarkStyle = AValue then exit;
  FTickMarkStyle := AValue;
  DrawKnobs;
  if assigned(Parent) and Parent.HandleAllocated then Parent.InvalidateCustomRect(False);
end;

procedure TECCustomKnob.SetWidth(const AValue: SmallInt);
var aHeight: SmallInt;
begin
  if (AValue < 1) or (FWidth = AValue) then exit;
  FWidth := AValue;
  aHeight := FHeight;
  KnobDisabled.SetSize(AValue, aHeight);
  KnobNormal.SetSize(AValue, aHeight);
  KnobHighlighted.SetSize(AValue, aHeight);  
  DrawKnobs;
  RecalcRedraw;
end; 

{ TBaseScrollControl }

constructor TBaseScrollControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAreaHeight := -1;
  FAreaWidth := -1;
  FScrollBars := ssAutoBoth;
end;   

procedure TBaseScrollControl.BeginUpdate;
begin
  inc(UpdateCount);
end; 

procedure TBaseScrollControl.CreateHandle;
begin
  inherited CreateHandle;
  FClientAreaLeft := ClientRect.Left;
  FClientAreaTop := ClientRect.Top;
  FScrollInfoHor.fMask := SIF_RANGE or SIF_PAGE or SIF_POS or SIF_DISABLENOSCROLL;
  FScrollInfoHor.nMax := 0;
  FScrollInfoHor.nMin := 0;
  FScrollInfoHor.nPos := 0;
  FScrollInfoVert := FScrollInfoHor;
  FScrollInfoHor.nPage := ClientWidth;
  FScrollInfoVert.nPage := ClientHeight;
  UpdateScrollBars;
end;

procedure TBaseScrollControl.DoUpdated;
begin
  Invalidate;
end;

procedure TBaseScrollControl.EndUpdate;
begin
  dec(UpdateCount);
  if UpdateCount = 0 then DoUpdated;
end;
        
procedure TBaseScrollControl.InvalidateNonUpdated;
begin
  if UpdateCount = 0 then DoUpdated;
end;

procedure TBaseScrollControl.UpdateScrollBars;
begin
  case ScrollBars of
    ssNone:
      begin
        ShowScrollBar(Handle, SB_HORZ, False);
        ShowScrollBar(Handle, SB_VERT, False);
      end;
    ssHorizontal:
      begin
        ShowScrollBar(Handle, SB_HORZ, True);
        ShowScrollBar(Handle, SB_VERT, False);
      end;
    ssVertical:
      begin
        ShowScrollBar(Handle, SB_HORZ, False);
        ShowScrollBar(Handle, SB_VERT, True);
      end;
    ssBoth:
      begin
        ShowScrollBar(Handle, SB_HORZ, True);
        ShowScrollBar(Handle, SB_VERT, True);
      end;
    ssAutoHorizontal:
      begin
        ShowScrollBar(Handle, SB_HORZ, FRequiredArea.X > ClientWidth);
        ShowScrollBar(Handle, SB_VERT, False);
      end;
    ssAutoVertical:
      begin
        ShowScrollBar(Handle, SB_HORZ, False);
        ShowScrollBar(Handle, SB_VERT, FRequiredArea.Y > ClientHeight);
      end;
    ssAutoBoth:
      begin
        ShowScrollBar(Handle, SB_HORZ, FRequiredArea.X > ClientWidth);
        ShowScrollBar(Handle, SB_VERT, FRequiredArea.Y > ClientHeight);
      end;
  end;  {case}
  UpdateScrollInfoHor;
  UpdateScrollInfoVert;
end;  

procedure TBaseScrollControl.UpdateScrollInfoHor;
begin
  FScrollInfoHor.nPos := ClientAreaLeft;
  FScrollInfoHor.nMax := FullAreaWidth;
  if HandleAllocated then SetScrollInfo(Handle, SB_Horz, FScrollInfoHor, False);
end;

procedure TBaseScrollControl.UpdateScrollInfoVert;
begin
  FScrollInfoVert.nPos := ClientAreaTop;
  FScrollInfoVert.nMax := FullAreaHeight;
  if HandleAllocated then SetScrollInfo(Handle, SB_Vert, FScrollInfoVert, False);
end;             

procedure TBaseScrollControl.WMHScroll(var Msg: TWMScroll);
begin
  {$IFDEF DBGLINE} DebugLn('TBaseECScheme.WMHScroll'); {$ENDIF}
  case Msg.ScrollCode of  { modify ClientAreaLeft and its setter will adjust H-scrollbar }
    SB_LINELEFT:      ClientAreaLeft := ClientAreaLeft - GetIncrementX;
    SB_LINERIGHT:     ClientAreaLeft := ClientAreaLeft + GetIncrementX;
    SB_PAGELEFT:      ClientAreaLeft := ClientAreaLeft - GetPageSizeX;
    SB_PAGERIGHT:     ClientAreaLeft := ClientAreaLeft + GetPageSizeX;
    SB_THUMBPOSITION,
    SB_THUMBTRACK:    ClientAreaLeft := Msg.Pos;
    SB_LEFT:          ClientAreaLeft := 0;
    SB_RIGHT:         ClientAreaLeft := FullAreaWidth;
    SB_ENDSCROLL:     ClientAreaLeft := Msg.Pos;  { when repaints during tracking is disabled by children }
  end;
end;

procedure TBaseScrollControl.WMSize(var Message: TLMSize);
var aCW, aCH: Integer;
begin
  {$IFDEF DBGLINE} DebugLn('WMSize W: ', inttostr(Width), ', H: ', inttostr(Height)); {$ENDIF}
  inherited WMSize(Message);
  aCW := ClientWidth;
  aCH := ClientHeight;
  {$IFDEF DBGLINE} DebugLn('WMSize CW: ', inttostr(ClientWidth), ', CH: ', inttostr(ClientHeight)); {$ENDIF}
  FScrollInfoHor.nPage := aCW;
  FScrollInfoVert.nPage := aCH;
  if (AreaWidth > -1) and (AreaWidth < aCW) then AreaWidth := aCW;
  if (AreaHeight > -1) and (AreaHeight < aCH) then AreaHeight := aCH;
  ClientAreaLeft := Math.min(ClientAreaLeft, FRequiredArea.X - aCW);
  ClientAreaTop := Math.min(ClientAreaTop, FRequiredArea.Y - aCH);
  UpdateScrollBars;
  Invalidate;
end;

procedure TBaseScrollControl.WMVScroll(var Msg: TWMScroll);
begin
  {$IFDEF DBGLINE} DebugLn('TBaseECScheme.WMVScroll'); {$ENDIF}
  case Msg.ScrollCode of  { modify ClientAreaTop and its setter will adjust V-scrollbar }
    SB_LINEUP:        ClientAreaTop := ClientAreaTop - GetIncrementY;
    SB_LINEDOWN:      ClientAreaTop := ClientAreaTop + GetIncrementY;
    SB_PAGEUP:        ClientAreaTop := ClientAreaTop - GetPageSizeY;
    SB_PAGEDOWN:      ClientAreaTop := ClientAreaTop + GetPageSizeY;
    SB_THUMBPOSITION,
    SB_THUMBTRACK:    ClientAreaTop := Msg.Pos;
    SB_TOP:           ClientAreaTop := 0;
    SB_BOTTOM:        ClientAreaTop := FullAreaHeight;
    SB_ENDSCROLL:     ClientAreaTop := Msg.Pos;  { when repaints during tracking is disabled by chidren }
  end;    
end;   

{ TBaseScrollControl.Setters }

function TBaseScrollControl.GetFullAreaHeight: Integer;
begin
  Result := Math.max(ClientHeight, FRequiredArea.Y);
end;

function TBaseScrollControl.GetFullAreaWidth: Integer;
begin
  Result := Math.max(ClientWidth, FRequiredArea.X);
end;

function TBaseScrollControl.GetIncrementX: Integer;
begin
  Result := 1;
end;

function TBaseScrollControl.GetIncrementY: Integer;
begin
  Result := 1;
end;

function TBaseScrollControl.GetPageSizeX: Integer;
begin
  Result := ClientWidth;
end;

function TBaseScrollControl.GetPageSizeY: Integer;
begin
  Result := ClientHeight;
end;
         
procedure TBaseScrollControl.SetAreaHeight(AValue: Integer);
begin
  if AValue >= 0 then AValue := Math.max(AValue, ClientHeight);
  if (FAreaHeight = AValue) or ((AValue < 0) and (FAreaHeight < 0)) then exit;
  FAreaHeight := AValue;
  UpdateRequiredAreaHeight;
  UpdateScrollBars;
  Invalidate;
end;

procedure TBaseScrollControl.SetAreaWidth(AValue: Integer);
begin
  if AValue >= 0 then AValue := Math.max(AValue, ClientWidth);
  if (FAreaWidth = AValue) or ((AValue < 0) and (FAreaWidth < 0)) then exit;
  FAreaWidth := AValue;
  UpdateRequiredAreaWidth;
  UpdateScrollBars;
  Invalidate;
end;

procedure TBaseScrollControl.SetClientAreaLeft(AValue: Integer);
begin
  AValue := Math.EnsureRange(AValue, 0, FullAreaWidth - ClientWidth);
  if FClientAreaLeft = AValue then exit;
  FClientAreaLeft := AValue;
  UpdateScrollBars;
  InvalidateNonUpdated;  
end;
 
procedure TBaseScrollControl.SetClientAreaTop(AValue: Integer);
begin
  AValue := Math.EnsureRange(AValue, 0, FullAreaHeight-ClientHeight);
  if FClientAreaTop = AValue then exit;
  FClientAreaTop := AValue;
  UpdateScrollBars;
  InvalidateNonUpdated;
end;  

procedure TBaseScrollControl.SetScrollBars(AValue: TScrollStyle);
begin
  if FScrollBars = AValue then exit;
  FScrollBars := AValue;
  UpdateScrollBars;
end;

initialization

  ArBtnDetails[False, False] := ThemeServices.GetElementDetails(tbPushButtonDisabled);
  ArBtnDetails[False, True] := ArBtnDetails[False, False];
  ArBtnDetails[True, False] := ThemeServices.GetElementDetails(tbPushButtonNormal);
  ArBtnDetails[True, True] := ThemeServices.GetElementDetails(tbPushButtonPressed);
  SetLength(FocusRectPattern, 2);
  FocusRectPattern[0] := 1;
  FocusRectPattern[1] := 1;

end.


