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

unit ECSwitch;    
{$mode objfpc}{$H+}

//{$DEFINE DBGSWITCH}  {don't remove, just comment}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, Graphics, ActnList, Forms, LazMethodList, LCLIntf,
  LCLProc, LCLType, LMessages, LResources, Math, Themes, Types, ECTypes;

type
  {$PACKENUM 2}
  TGlyphStyle = (egsNone, egsOneZero, egsCircles, egsPlusMinus, egsDot, egsCircle);
    
  { TECSwitchKnob }
  TECSwitchKnob = class(TECCustomKnob)
  published
    property BevelWidth;
    property Color;
    property Style;
    property TickMarkCount;
    property TickMarkDesign;
    property TickMarkSpacing;
    property TickMarkStyle;
  end;

  TCustomECSwitch = class;

  { TECSwitchActionLink }
  TECSwitchActionLink = class(TWinControlActionLink)
  protected
    FClientSwitch: TCustomECSwitch;
    procedure AssignClient(AClient: TObject); override;
    procedure SetChecked(Value: Boolean); override;
  public
    function IsCheckedLinked: Boolean; override;
  end;

  TECSwitchActionLinkClass = class of TECSwitchActionLink;

  { TCustomECSwitch }
  TCustomECSwitch = class(TECBaseControl)
  private
    FAllowGrayed: Boolean;
    FCaptionPos: TObjectPos;
    FCheckFromAction: Boolean;
    FGlyphStyle: TGlyphStyle;
    FGrooveCheckedClr: TColor;
    FGrooveIndent: SmallInt;
    FGrooveUncheckedClr: TColor;
    FKnob: TECSwitchKnob;
    FKnobHovered: Boolean;
    FKnobIndent: SmallInt;
    FOnChange: TNotifyEvent;
    FState: TCheckBoxState;
    FSwitchColor: TColor;
    FSwitchHeight: Integer;
    FSwitchWidth: Integer;
    function GetChecked: Boolean;
    procedure SetCaptionPos(AValue: TObjectPos);
    procedure SetChecked(AValue: Boolean);
    procedure SetGlyphStyle(AValue: TGlyphStyle);
    procedure SetGrooveCheckedClr(AValue: TColor);
    procedure SetGrooveIndent(AValue: SmallInt);
    procedure SetGrooveUncheckedClr(AValue: TColor);
    procedure SetKnobHovered(AValue: Boolean);
    procedure SetKnobIndent(AValue: SmallInt);
    procedure SetState(AValue: TCheckBoxState);
    procedure SetSwitchColor(AValue: TColor);
    procedure SetSwitchHeight(AValue: Integer);
    procedure SetSwitchWidth(AValue: Integer);
  protected const
    caClrGlyph: array[False..True] of TColor = ($D8D8D8, $FFFFFF);
    cDefGlyphStyle = egsOneZero;
    cDefGrooveIndent = 7;
    cDefKnobIndent = 4;
    cDefSwitchHeight = 28;
    cDefSwitchWidth = 64;
    cFocusRectIndent = 3;
    cIndent = 5;
    cLargeGlyph = 12;
    cMediumGlyph = 8;
    cSmallGlyph = 4;
  protected type
    TResourceGlyph = (rgCircle4, rgCircle8, rgCircle12, rgZero4 ,rgZero8, rgZero12);
  protected
    CaptionRect: TRect;
    GlyphOnePoint, GlyphZeroPoint, SwitchPoint: TPoint;
    GlyphSize: SmallInt;  { 0 - no glyph; 4 - small; 8 - medium; 12 - large glyph }
    InitMouseCoord: SmallInt;
    KnobCaptured: Boolean;
    KnobMouseDown: Boolean;
    KnobPosUnchecked, KnobPosChecked, KnobPosGrayed: SmallInt;
    class var ArGlyphs: array[TResourceGlyph, 0..1] of TPortableNetworkGraphic;
    class constructor InitGlyphs;
    class destructor FreeGlyphs;  
    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer; 
                                     {%H-}WithThemeSpace: Boolean); override;
    procedure Calculate;
    procedure CMBiDiModeChanged(var {%H-}Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure CMParentColorChanged(var Message: TLMessage); message CM_PARENTCOLORCHANGED;
    function DialogChar(var Message: TLMKey): Boolean; override;
    procedure DoClick;
    procedure DoEnter; override;
    procedure DoExit; override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    procedure InvalidateCustomRect({%H-}AMove: Boolean); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure OrientationChanged(AValue: TObjectOrientation); override;
    procedure Paint; override;
    procedure RecalcInvalidate;
    procedure RecalcRedraw; override;
    procedure Redraw3DColorAreas; override;        
    procedure ResizeKnob;     
    procedure SetAutoSize(Value: Boolean); override;
    procedure SetKnobBackground;
    procedure StyleChanged(AValue: TObjectStyle); override;
    procedure TextChanged; override;
    procedure WMSize(var Message: TLMSize); message LM_SIZE;
    property CheckFromAction: Boolean read FCheckFromAction write FCheckFromAction;
    property KnobHovered: Boolean read FKnobHovered write SetKnobHovered;
  public  
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate; override;
    procedure EndUpdate(Recalculate: Boolean = True); override;
    procedure Redraw; override;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property CaptionPos: TObjectPos read FCaptionPos write SetCaptionPos default eopRight;
    property Checked: Boolean read GetChecked write SetChecked default False;
    property GlyphStyle: TGlyphStyle read FGlyphStyle write SetGlyphStyle default cDefGlyphStyle;
    property GrooveCheckedClr: TColor read FGrooveCheckedClr write SetGrooveCheckedClr default clDefault;
    property GrooveUncheckedClr: TColor read FGrooveUncheckedClr write SetGrooveUncheckedClr default clDefault;
    property GrooveIndent: SmallInt read FGrooveIndent write SetGrooveIndent default cDefGrooveIndent;
    property Knob: TECSwitchKnob read FKnob write FKnob;
    property KnobIndent: SmallInt read FKnobIndent write SetKnobIndent default cDefKnobIndent;
    property State: TCheckBoxState read FState write SetState default cbUnchecked;
    property SwitchColor: TColor read FSwitchColor write SetSwitchColor default clDefault;
    property SwitchHeight: Integer read FSwitchHeight write SetSwitchHeight default cDefSwitchHeight;
    property SwitchWidth: Integer read FSwitchWidth write SetSwitchWidth default cDefSwitchWidth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;
  
  { TECSwitch }
  TECSwitch = class(TCustomECSwitch)
  published
    property Action;
    property Align;
    property AllowGrayed;
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
    property Checked;
    {property Color;}  { not needed }
    property Color3DDark;
    property Color3DLight;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property GlyphStyle;
		property GrooveCheckedClr;		
    property GrooveIndent;
    property GrooveUncheckedClr;
    property Knob;
    property KnobIndent;
    property Orientation default eooHorizontal;
    property ParentBiDiMode;
    {property ParentColor;}  { not needed }
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property State;
    property Style default eosButton;
    property SwitchColor;
    property SwitchHeight;
    property SwitchWidth;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnChangeBounds;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
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
    property OnResize;
    property OnStartDrag;
    property OnUTF8KeyPress;   
  end;

implementation

{ TECSwitchActionLink }

procedure TECSwitchActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClientSwitch := AClient as TCustomECSwitch;
end;

function TECSwitchActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and (FClientSwitch.Checked = (Action as TCustomAction).Checked);
end;

procedure TECSwitchActionLink.SetChecked(Value: Boolean);
begin
  if IsCheckedLinked then
    begin
      FClientSwitch.CheckFromAction := True;
      try
        FClientSwitch.Checked := Value;
      finally
        FClientSwitch.CheckFromAction := False;
      end;
    end;
end;

{ TCustomECSwitch }

class constructor TCustomECSwitch.InitGlyphs;
const castrGlyphNames: array[0..1, TResourceGlyph] of string =
        (('circle4', 'circle8', 'circle12', 'zero4', 'zero8', 'zero12'),
         ('circle5', 'circle9', 'circle13', 'zero5', 'zero9', 'zero13'));
var aGlyph: TResourceGlyph;
    aOdd: SmallInt;
begin
  {$I ecswitch.lrs}
  for aGlyph in TResourceGlyph do
    for aOdd := 0 to 1 do
      begin
        ArGlyphs[aGlyph, aOdd] := TPortableNetworkGraphic.Create;
        ArGlyphs[aGlyph, aOdd].LoadFromLazarusResource(castrGlyphNames[aOdd, aGlyph]);
      end;
end;

class destructor TCustomECSwitch.FreeGlyphs;
var aGlyph: TResourceGlyph;
    aOdd: SmallInt;
begin
  for aGlyph in TResourceGlyph do
    for aOdd := 0 to 1 do
      FreeAndNil(ArGlyphs[aGlyph, aOdd]);
end;

constructor TCustomECSwitch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - csMultiClicks - [csClickEvents, csNoStdEvents];  { inherited Click not used }
  FAllowGrayed := False;
  FCaptionPos := eopRight;
  FGlyphStyle := egsOneZero;
  FGrooveCheckedClr := clDefault;
  FGrooveIndent := cDefGrooveIndent;
  FGrooveUncheckedClr := clDefault; 
  FKnob := TECSwitchKnob.Create(self);
  FKnobIndent := cDefKnobIndent;
  FSwitchColor := clDefault;
  FSwitchHeight := cDefSwitchHeight;
  FSwitchWidth := cDefSwitchWidth;
  ResizeKnob;
  AutoSize := True;
  TabStop := True;
  AccessibleRole := larCheckBox;
end;

destructor TCustomECSwitch.Destroy;
begin
  FreeAndNil(FKnob);
  inherited Destroy;
end;

procedure TCustomECSwitch.BeginUpdate;
begin
  inherited BeginUpdate;
  FKnob.BeginUpdate;
end;

procedure TCustomECSwitch.CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer;
            WithThemeSpace: Boolean);
var aCaption: string;
    aTextSize: TSize;
begin
  aCaption := Caption;
  if aCaption <> '' then
    begin
      DeleteAmpersands(aCaption);
      aTextSize := Canvas.TextExtent(aCaption);
      inc(aTextSize.cx, 2*cFocusRectIndent);
      inc(aTextSize.cy, 2*cFocusRectIndent);
      if CaptionPos in [eopRight, eopLeft] then
        begin
          PreferredWidth := SwitchWidth + cIndent + aTextSize.cx;
          PreferredHeight := Math.max(SwitchHeight, aTextSize.cy);
        end else
        begin
          PreferredHeight := aTextSize.cy + cIndent + SwitchHeight;
          PreferredWidth := Math.max(SwitchWidth, aTextSize.cx);
        end;
    end else
    begin
      PreferredWidth := SwitchWidth;
      PreferredHeight := SwitchHeight;
    end;  
end;  

procedure TCustomECSwitch.Calculate;

  procedure CalcGlyphSize(ALogHeight, ALogSwithWidth: SmallInt);
  begin
    dec(ALogHeight, 2*FGrooveIndent);  { logical Switch Height -> log. Groove Height }
    if ((ALogHeight > 19) and (ALogSwithWidth > 59))
      then GlyphSize := cLargeGlyph
      else if ((ALogHeight > 13) and (ALogSwithWidth > 48))
             then GlyphSize := cMediumGlyph
             else if ((ALogHeight > 7) and (ALogSwithWidth > 40))
                    then GlyphSize := cSmallGlyph
                    else GlyphSize := 0;
  end;

var bRightToLeft: Boolean;

  procedure CalcSwitchAndCaptionPos;
  var aCaption: string;
      aHelp: Integer;
      aRealCaptionPos: TObjectPos;
      aTextSize: TSize;
  begin
    aRealCaptionPos := CaptionPos;
    if bRightToLeft then
      case aRealCaptionPos of
        eopRight: aRealCaptionPos := eopLeft;
        eopLeft: aRealCaptionPos := eopRight;
      end;
    aCaption := Caption;
    DeleteAmpersands(aCaption);
    aTextSize := Canvas.TextExtent(aCaption);
    inc(aTextSize.cx, 2*cFocusRectIndent);  { additional space for FocusRect }
    inc(aTextSize.cy, 2*cFocusRectIndent);
    if aRealCaptionPos in [eopRight, eopLeft] then
      begin
        CaptionRect.Top := (Height - aTextSize.cy) div 2;
        SwitchPoint.Y := (Height - SwitchHeight) div 2;
      end else
      begin
        aHelp := (aTextSize.cx - SwitchWidth) div 2;
        if bRightToLeft then
          begin
            CaptionRect.Left := Width - Math.max(aTextSize.cx, SwitchWidth);
            SwitchPoint.X := CaptionRect.Left;
            if aHelp < 0
              then dec(CaptionRect.Left, aHelp)
              else inc(SwitchPoint.X, aHelp);
          end else
          begin
            if aHelp < 0 then
              begin
                CaptionRect.Left := -aHelp;
                SwitchPoint.X := 0;
              end else
              begin
                CaptionRect.Left := 0;
                SwitchPoint.X := aHelp;
              end;
          end;
        aHelp := aTextSize.cy + cIndent;
      end;
    case aRealCaptionPos of
      eopTop:
        begin
          if AutoSize then
            begin
              CaptionRect.Top := 0;
              SwitchPoint.Y := Height - SwitchHeight;
            end else
            begin
              CaptionRect.Top := (Height - aHelp - SwitchHeight) div 2;
              SwitchPoint.Y := CaptionRect.Top + aHelp;
            end;
        end;
      eopRight:
        begin
          if AutoSize then
            begin
              CaptionRect.Left := Width - aTextSize.cx;
              SwitchPoint.X := 0;
            end else
              if bRightToLeft then
                begin
                  CaptionRect.Left := Width - aTextSize.cx;
                  SwitchPoint.X := CaptionRect.Left - cIndent - SwitchWidth;
                end else
                begin
                  CaptionRect.Left := SwitchWidth + cIndent;
                  SwitchPoint.X := 0;
                end;
        end;
      eopBottom:
        begin
          if AutoSize then
            begin
              CaptionRect.Top := Height - aTextSize.cy - 1;  { -1 'cause of underlined chars }
              SwitchPoint.Y := 0;
            end else
            begin
              SwitchPoint.Y := (Height - aHelp - SwitchHeight) div 2;
              CaptionRect.Top := SwitchPoint.Y + SwitchHeight + cIndent;
            end;
        end;
      eopLeft:
        begin
          if AutoSize then
            begin
              CaptionRect.Left := 0;
              SwitchPoint.X := Width - SwitchWidth;
            end else
              if bRightToLeft then
                begin
                  SwitchPoint.X := Width - SwitchWidth;
                  CaptionRect.Left := SwitchPoint.X - cIndent - aTextSize.cx;
                end else
                begin
                  CaptionRect.Left := 0;
                  SwitchPoint.X := cIndent + aTextSize.cx;
                end;
        end;
    end;  {case}
    CaptionRect.Size := aTextSize;
  end;

var aHelp, aUnchecked, aChecked: Integer;
begin
  {$IFDEF DBGSWITCH} DebugLn('TCustomECSwitch.Calculate'); {$ENDIF}
  bRightToLeft := IsRightToLeft;
  if Caption = '' then
    begin
      if not bRightToLeft
        then SwitchPoint.X := 0
        else SwitchPoint.X := Width - SwitchWidth;
      SwitchPoint.Y := (Height - SwitchHeight) div 2;
    end else
      CalcSwitchAndCaptionPos;
  aHelp := 0;
  if Orientation = eooHorizontal then
    begin
      CalcGlyphSize(SwitchHeight, SwitchWidth);
      aUnchecked := SwitchPoint.X + KnobIndent;  
      aChecked := SwitchPoint.X + SwitchWidth - KnobIndent - Knob.Width;
      Knob.Top := SwitchPoint.Y + (SwitchHeight - Knob.Height) div 2; 
      aHelp := GlyphSize + SwitchHeight and 1;
      if aHelp > 0 then
        begin
          GlyphOnePoint.X := (SwitchPoint.X + FGrooveIndent + 1 + aChecked - aHelp) div 2;
          GlyphZeroPoint.X := (SwitchPoint.X + SwitchWidth - FGrooveIndent 
                               + aUnchecked + Knob.Width - aHelp) div 2;
          GlyphOnePoint.Y := SwitchPoint.Y + (SwitchHeight - aHelp) div 2;
          GlyphZeroPoint.Y := GlyphOnePoint.Y;
        end;
      if bRightToLeft then 
        begin
          aHelp := aUnchecked;
          aUnchecked := aChecked;
          aChecked := aHelp;
          aHelp := GlyphZeroPoint.X;
          GlyphZeroPoint.X := GlyphOnePoint.X;
          GlyphOnePoint.X := aHelp;
        end; 
    end else 
    begin
      CalcGlyphSize(SwitchWidth, SwitchHeight);
      aUnchecked := SwitchPoint.Y + SwitchHeight - KnobIndent - Knob.Height;
      aChecked := SwitchPoint.Y + KnobIndent;
      Knob.Left := SwitchPoint.X + (SwitchWidth - Knob.Width) div 2;
      aHelp := GlyphSize + SwitchWidth and 1;
      if aHelp > 0 then
        begin 
          GlyphOnePoint.X := SwitchPoint.X + (SwitchWidth - aHelp) div 2;
          GlyphZeroPoint.X := GlyphOnePoint.X;
          GlyphOnePoint.Y := (SwitchPoint.Y + SwitchHeight - FGrooveIndent
                             + aChecked + Knob.Height - aHelp) div 2;
          GlyphZeroPoint.Y := (SwitchPoint.Y + FGrooveIndent + aUnchecked - aHelp) div 2;
        end;  
    end;
  KnobPosUnchecked := aUnchecked;
  KnobPosChecked := aChecked;
  KnobPosGrayed := (aUnchecked + aChecked) div 2; 
  RedrawMode := ermFreeRedraw;
end;           

procedure TCustomECSwitch.CMBiDiModeChanged(var Message: TLMessage);
begin
  RecalcInvalidate;
end;

procedure TCustomECSwitch.CMParentColorChanged(var Message: TLMessage);
begin
  {$IFDEF DBGSWITCH} DebugLn('TCustomECSwitch.CMParentColorChanged'); {$ENDIF}
  inherited CMParentColorChanged(Message);
  if assigned(FKnob) and (SwitchColor = clDefault) then SetKnobBackground;
end;  

function TCustomECSwitch.DialogChar(var Message: TLMKey): Boolean;
begin
  Result := False;
  if Message.Msg = LM_SYSCHAR then
    begin
      if IsEnabled and IsVisible then
        begin
          if IsAccel(Message.CharCode, Caption) then
            begin
              DoClick;
              SetFocus;
              Result := True;      
            end else
              Result := inherited DialogChar(Message);
        end;					
    end;
end;           

procedure TCustomECSwitch.DoClick;
begin
  if AllowGrayed then
    case FState of
      cbUnchecked: State := cbGrayed;
      cbGrayed: State := cbChecked;
      cbChecked: State := cbUnchecked;
    end else
      Checked := not Checked;
end;                

procedure TCustomECSwitch.DoEnter;
begin
  inherited DoEnter;
  Invalidate;
end;                

procedure TCustomECSwitch.DoExit;
begin
  inherited DoExit;
  Invalidate;
end;

procedure TCustomECSwitch.EndUpdate(Recalculate: Boolean = True);
begin
  FKnob.EndUpdate;
  inherited EndUpdate(Recalculate);
end;

function TCustomECSwitch.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TECSwitchActionLink;  
end;

procedure TCustomECSwitch.InvalidateCustomRect(AMove: Boolean);
begin
  Invalidate;
end;                

procedure TCustomECSwitch.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key in [VK_RETURN, VK_SPACE]) and (Shift*[ssShift, ssAlt, ssCtrl, ssMeta] = []) then DoClick;
end;                

procedure TCustomECSwitch.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);    
  if (Button = mbLeft) and KnobHovered then KnobMouseDown := True;   
  SetFocus;
end;                

procedure TCustomECSwitch.MouseLeave;
begin
  inherited MouseLeave;
  KnobHovered := False;
end;                

procedure TCustomECSwitch.MouseMove(Shift: TShiftState; X, Y: Integer);
var aLeft, aTop: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  if KnobCaptured then
    begin
      if Orientation = eooHorizontal then
        begin
          if IsRightToLeft
            then aLeft := EnsureRange(InitMouseCoord + X, KnobPosChecked, KnobPosUnchecked)
            else aLeft := EnsureRange(InitMouseCoord + X, KnobPosUnchecked, KnobPosChecked); 
          if Knob.Left <> aLeft then
            begin
              Knob.Left := aLeft;
              Invalidate;
            end;
        end else
        begin
          aTop := EnsureRange(InitMouseCoord + Y, KnobPosChecked, KnobPosUnchecked);
          if Knob.Top <> aTop then
            begin
              Knob.Top := aTop;
              Invalidate;
            end;
        end;
    end else     
    begin
      if KnobMouseDown then
        begin
          KnobCaptured := True;
          if Orientation = eooHorizontal 
            then InitMouseCoord := Knob.Left - X
            else InitMouseCoord := Knob.Top - Y;       
        end else
        begin
          aLeft := Knob.Left;
          aTop := Knob.Top;
          KnobHovered := ((aLeft <= X) and (aTop <= Y) and (X < (aLeft + Knob.Width)) and (Y < (aTop + Knob.Height))); 
        end;
    end;      
end;                

procedure TCustomECSwitch.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aHelp, aPosition: Integer; 
    aState: TCheckBoxState;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button = mbLeft then
    begin
      if KnobCaptured then 
        begin
          if Orientation = eooHorizontal then
            begin
              if AllowGrayed then 
                begin
                  aHelp := Math.min(KnobPosUnchecked, KnobPosChecked);
                  aPosition := (aHelp + 2*(KnobPosGrayed - aHelp) div 3);
                  if aPosition <= Knob.Left then
                    begin
                      aHelp := Math.max(KnobPosUnchecked, KnobPosChecked);
                      aPosition := (KnobPosGrayed + (aHelp - KnobPosGrayed) div 3);
                      if aPosition > Knob.Left
                        then aState := cbGrayed
                        else aState := cbChecked;
                    end else
                      aState := cbUnchecked;
                  if IsRightToLeft then
                    case aState of
                      cbUnchecked: aState := cbChecked;
                      cbChecked:   aState := cbUnchecked;
                    end;
                  State := aState;
                end else
                  Checked := ((KnobPosUnchecked + KnobPosChecked) < 2*Knob.Left) xor IsRightToLeft;
            end else
            begin
              if AllowGrayed then
                begin
                  aPosition := (KnobPosGrayed + (KnobPosUnchecked - KnobPosGrayed) div 3);
                  if aPosition >= Knob.Top then
                    begin
                      aPosition := (KnobPosChecked + 2*(KnobPosGrayed - KnobPosChecked) div 3);
                      if aPosition < Knob.Top
                        then State := cbGrayed
                        else State := cbChecked;
                    end else
                      State := cbUnchecked;
                end else
                  Checked := ((KnobPosUnchecked + KnobPosChecked) > 2*Knob.Top);
            end;
          { Knob remains hovered when mouse is over Switch but out of Knob; does not matter }
          if not PtInRect(ClientRect, Point(X, Y)) then FKnobHovered := False;
          Invalidate;
          KnobCaptured := False;
        end else
          if PtInRect(ClientRect, Point(X, Y)) then DoClick;
      KnobMouseDown := False;
    end;
end;                 

procedure TCustomECSwitch.OrientationChanged(AValue: TObjectOrientation);
var aHelp: Integer;
begin
  if not (csLoading in ComponentState) then 
    begin
      aHelp := SwitchHeight;
      FSwitchHeight := SwitchWidth;
      SwitchWidth := aHelp;
      if aHelp = SwitchHeight then ResizeKnob;  { when Switch is square }
      RedrawMode := ermRecalcRedraw;
    end; 
  inherited OrientationChanged(AValue);
end;                 

procedure TCustomECSwitch.Paint;
var aColor: TColor;
    aOdd: SmallInt;
    aRect: TRect;
    bEnabled: Boolean;
    x, y: Integer;
begin
  {$IFDEF DBGSWITCH} DebugLn('TCustomECSwitch.Paint'); {$ENDIF}
  inherited Paint;
  if RedrawMode = ermRecalcRedraw then Calculate;
  bEnabled := IsEnabled;
  { paint Switch body }
  x := SwitchPoint.X;
  y := SwitchPoint.Y;
  aRect:=Rect(x, y, x + SwitchWidth, y + SwitchHeight);
  aColor := GetColorResolvingDefault(SwitchColor, Parent.Brush.Color);
  case Style of
    eosButton:      Canvas.DrawButtonBackground(aRect, caItemState[bEnabled]);
    eosPanel:       Canvas.DrawPanelBackGround(aRect, BevelInner, BevelOuter, BevelSpace, BevelWidth,
                      Color3DDark, Color3DLight, aColor, bEnabled);
    eosThemedPanel: Canvas.DrawThemedPanelBkgnd(aRect);
    eosFinePanel:   Canvas.DrawFinePanelBkgnd(aRect, BevelOuter, BevelWidth, Color3DDark, Color3DLight,
                      aColor, True, bEnabled);
  end;
  { paint Groove }
  InflateRect(aRect, -GrooveIndent, -GrooveIndent);
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;
  Canvas.Frame3D(aRect, GetColorResolvingDefAndEnabled(Color3DDark, clBtnShadow, bEnabled),
                 GetColorResolvingDefAndEnabled(Color3DLight, clBtnHilight, bEnabled), 1);
  if KnobCaptured then
    begin
      aColor := GetColorResolvingDefault(GrooveCheckedClr, clActiveCaption);
      if Orientation = eooHorizontal
        then x := Knob.Left
        else x := Knob.Top;
      aColor := GetMergedColor(aColor, GetColorResolvingDefault(GrooveUncheckedClr, cl3DDkShadow),
                  (x - KnobPosUnchecked)/(KnobPosChecked - KnobPosUnchecked));
      if AllowGrayed then
        aColor := GetMergedColor(aColor, Parent.Brush.Color,
          abs((KnobPosChecked + KnobPosUnchecked - 2*x)/(KnobPosChecked - KnobPosUnchecked)));
    end else
    case State of
      cbUnchecked: aColor := GetColorResolvingDefault(GrooveUncheckedClr, cl3DDkShadow);
      cbChecked:   aColor := GetColorResolvingDefault(GrooveCheckedClr, clActiveCaption);
    end;
  if bEnabled
    then Canvas.Brush.Color := aColor
    else Canvas.Brush.Color := GetMonochromaticColor(aColor);
  if KnobCaptured or (State <> cbGrayed) then Canvas.FillRect(aRect);
  { paint Glyphs }  { impossible to draw directly from resources, class vars used instead }
  if Orientation = eooHorizontal
    then aOdd := SwitchHeight and 1
    else aOdd := SwitchWidth and 1;
  if (GlyphSize > 0) and (GlyphStyle <> egsNone) then
    with Canvas do
      begin
        if KnobCaptured or (State <> cbChecked) then
          begin
            x := GlyphZeroPoint.X;
            y := GlyphZeroPoint.Y; 
            case GlyphStyle of
              egsOneZero, egsCircles: Draw(x, y, ArGlyphs[TResourceGlyph(GlyphSize div 4 + 2), aOdd]);
              egsPlusMinus:
                case GlyphSize of
                  cSmallGlyph:
                    begin
                      Pen.Color := caClrGlyph[bEnabled];
                      Pen.EndCap := pecFlat;
                      Pen.Width := 2 - aOdd;
                      Line(x - 1 + aOdd, y + 2, x + cSmallGlyph + 1, y + 2);
                    end;
                  cMediumGlyph:
                    begin
                      Brush.Color := caClrGlyph[bEnabled];
                      FillRect(x, y + 3, x + cMediumGlyph + aOdd, y + 5 + aOdd);
                    end;
                  cLargeGlyph:
                    begin
                      Brush.Color := caClrGlyph[bEnabled];
                      FillRect(x, y + 4, x + cLargeGlyph + aOdd, y + 8 + aOdd);
                    end;
                end;
            end;
          end;
        if KnobCaptured or (State <> cbUnchecked) then
          begin
            x := GlyphOnePoint.X;
            y := GlyphOnePoint.Y; 
            case GlyphStyle of
              egsOneZero: 
                case GlyphSize of
                  cSmallGlyph:
                    begin
                      Pen.Color := clWhite;
                      Pen.EndCap := pecFlat;
                      Pen.Width := 2 - aOdd;
                      inc(x, 2);
                      Line(x, y - 1 + aOdd, x, y + cSmallGlyph + 1);
                    end;
                  cMediumGlyph:
                    begin
                      Brush.Color := caClrGlyph[bEnabled];
                      FillRect(x + 3, y, x + 5 + aOdd, y + cMediumGlyph + aOdd);
                    end;
                  cLargeGlyph:
                    begin
                      Brush.Color := caClrGlyph[bEnabled];
                      FillRect(x + 4, y, x + 8 + aOdd, y + cLargeGlyph + aOdd);
                    end;
                end;
              egsCircles, egsCircle: Draw(x, y, ArGlyphs[TResourceGlyph(GlyphSize div 4 - 1), aOdd]);
              egsPlusMinus:
                case GlyphSize of
                  cSmallGlyph:
                    begin
                      Pen.Color := caClrGlyph[bEnabled];
                      Pen.EndCap := pecFlat;
                      Pen.Width := 2 - aOdd;
                      Line(x - 1 + aOdd, y + 2, x + cSmallGlyph + 1, y + 2);
                      inc(x, 2);
                      Line(x, y - 1 + aOdd, x, y + cSmallGlyph + 1);
                    end;
                  cMediumGlyph:
                    begin
                      Brush.Color := caClrGlyph[bEnabled];
                      FillRect(x, y + 3, x + cMediumGlyph + aOdd, y + 5 + aOdd);
                      FillRect(x + 3, y, x + 5 + aOdd, y + cMediumGlyph + aOdd);
                    end;
                  cLargeGlyph:
                    begin
                      Brush.Color := caClrGlyph[bEnabled];
                      FillRect(x, y + 4, x + cLargeGlyph + aOdd, y + 8 + aOdd);
                      FillRect(x + 4, y, x + 8 + aOdd, y + cLargeGlyph + aOdd);
                    end;
                end;
              egsDot:       
                case GlyphSize of
                  cSmallGlyph: Draw(x, y, ArGlyphs[rgCircle4, aOdd]);
                  otherwise    Draw(x + 2, y + 2, ArGlyphs[TResourceGlyph(GlyphSize div 4 - 2), aOdd]);
                end;
            end;  {case}
          end;
      end;
  { paint Knob }
  if not KnobCaptured then  
    begin
      case State of
        cbUnchecked: x := KnobPosUnchecked;
        cbChecked:   x := KnobPosChecked;
        cbGrayed:    x := KnobPosGrayed;
      end;
      if Orientation = eooHorizontal then
        begin
          Knob.Left := x;
          y := Knob.Top; 
        end else
        begin
          y := x;
          Knob.Top := y;
          x := Knob.Left; 
        end;
    end else
    begin
      x := Knob.Left;
      y := Knob.Top;
    end;
  if not bEnabled then
    begin
      FKnobHovered := False;
      Canvas.Draw(x, y, Knob.KnobDisabled)
    end else
      if KnobHovered
        then Canvas.Draw(x, y, Knob.KnobHighlighted)
        else Canvas.Draw(x, y, Knob.KnobNormal);
  LCLIntf.SetBkColor(Canvas.Handle, ColorToRGB(clBtnFace));
  if Caption <> '' then
    begin  { paint Caption }
      aRect := CaptionRect;
      if Focused then LCLIntf.DrawFocusRect(Canvas.Handle, aRect);
      InflateRect(aRect, -cFocusRectIndent, -cFocusRectIndent);
      ThemeServices.DrawText(Canvas, ArBtnDetails[bEnabled, False], Caption, aRect, DT_SINGLELINE, 0);
    end else
      if Focused then  { paint FocusRect on Switch when there's no Caption }
        LCLIntf.DrawFocusRect(Canvas.Handle, Rect(x + 3, y + 3, x + Knob.Width - 3, y + Knob.Height - 3));
end;

procedure TCustomECSwitch.RecalcInvalidate;
begin
  RedrawMode := ermRecalcRedraw;
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

procedure TCustomECSwitch.RecalcRedraw;
begin    
  if UpdateCount = 0 then Invalidate;
end;

procedure TCustomECSwitch.Redraw;
begin 
  if UpdateCount = 0 then Invalidate;
end;

procedure TCustomECSwitch.Redraw3DColorAreas;
begin
  if assigned(Knob) and (Knob.Style = eosPanel) then Knob.DrawKnobs;
  if UpdateCount = 0 then Invalidate;
end;

procedure TCustomECSwitch.ResizeKnob;
begin
  {$IFDEF DBGSWITCH} DebugLn('TCustomECSwitch.ResizeKnob'); {$ENDIF}
  if Orientation = eooHorizontal 
    then FKnob.SetSize(SwitchWidth div 2, SwitchHeight - 2*KnobIndent)
    else FKnob.SetSize(SwitchWidth - 2*KnobIndent, SwitchHeight div 2);
end;

procedure TCustomECSwitch.SetAutoSize(Value: Boolean);
begin
  inherited SetAutoSize(Value);
  if Value then RedrawMode := ermRecalcRedraw;
end;

procedure TCustomECSwitch.SetKnobBackground;
var aColor: TColor;
begin
  if Style in [eosPanel, eosFinePanel]
    then aColor := GetColorResolvingDefault(SwitchColor, Parent.Brush.Color)
    else aColor := clBtnFace;
  FKnob.BackgroundColor := ColorToRGB(aColor);
end;        

procedure TCustomECSwitch.StyleChanged(AValue: TObjectStyle);
begin
  SetKnobBackground;
  inherited StyleChanged(AValue);
end;          

procedure TCustomECSwitch.TextChanged;
begin
  inherited TextChanged;
  RecalcInvalidate;
end;

procedure TCustomECSwitch.WMSize(var Message: TLMSize);
begin
  inherited WMSize(Message);
  RedrawMode := ermRecalcRedraw;
  Invalidate;  
end;

{ Setters }

function TCustomECSwitch.GetChecked: Boolean;
begin
  Result := (FState = cbChecked);
end;

procedure TCustomECSwitch.SetCaptionPos(AValue: TObjectPos);
begin
  if FCaptionPos = AValue then exit;
  FCaptionPos := AValue;
  RecalcInvalidate;
end;   

procedure TCustomECSwitch.SetChecked(AValue: Boolean);
begin
  if AValue 
    then State := cbChecked
    else State := cbUnChecked;
end;           

procedure TCustomECSwitch.SetGlyphStyle(AValue: TGlyphStyle);
begin
  if FGlyphStyle = AValue then exit;
  FGlyphStyle := AValue;
  Redraw;
end;           

procedure TCustomECSwitch.SetGrooveCheckedClr(AValue: TColor);
begin
  if FGrooveCheckedClr = AValue then exit;
  FGrooveCheckedClr := AValue;
  if Checked then Redraw;
end;           

procedure TCustomECSwitch.SetGrooveIndent(AValue: SmallInt);
begin
  if FGrooveIndent = AValue then exit;
  FGrooveIndent := AValue;
  RedrawMode := ermRecalcRedraw;
  Redraw;  
end;           

procedure TCustomECSwitch.SetGrooveUncheckedClr(AValue: TColor);
begin
  if FGrooveUncheckedClr = AValue then exit;
  FGrooveUncheckedClr := AValue;
  if not Checked then Redraw;
end;           

procedure TCustomECSwitch.SetKnobHovered(AValue: Boolean);
begin
  if FKnobHovered = AValue then exit;
  FKnobHovered := AValue;
  Redraw;
end;       

procedure TCustomECSwitch.SetKnobIndent(AValue: SmallInt);
begin
  if FKnobIndent = AValue then exit;
  FKnobIndent := AValue;
  ResizeKnob;
  RedrawMode := ermRecalcRedraw;
  Redraw;
end;       

procedure TCustomECSwitch.SetState(AValue: TCheckBoxState);
begin
  if FState = AValue then exit;
  FState := AValue;
  if [csLoading, csDestroying, csDesigning]*ComponentState = [] then
    begin
      if assigned(OnChange) then OnChange(self);
      { execute only when Action.Checked is changed }
      if not CheckFromAction then
        begin
          if assigned(OnClick) and not (assigned(Action) and
              CompareMethods(TMethod(Action.OnExecute), TMethod(OnClick)))
            then OnClick(self);
          if (Action is TCustomAction) and (TCustomAction(Action).Checked <> (AValue = cbChecked))
            then ActionLink.Execute(self);
        end;
    end; 
  Redraw;
end;   

procedure TCustomECSwitch.SetSwitchColor(AValue: TColor);
begin
  if FSwitchColor = AValue then exit;
  FSwitchColor := AValue;
  if Style in [eosPanel, eosFinePanel] then
    begin
      SetKnobBackground;
      Redraw;
    end;
end;   

procedure TCustomECSwitch.SetSwitchHeight(AValue: Integer);
begin
  if FSwitchHeight = AValue then exit;
  FSwitchHeight := AValue;
  ResizeKnob;
  RecalcInvalidate;
end;

procedure TCustomECSwitch.SetSwitchWidth(AValue: Integer);
begin
  if FSwitchWidth = AValue then exit;
  FSwitchWidth := AValue;
  ResizeKnob;
  RecalcInvalidate;
end;   

end.


