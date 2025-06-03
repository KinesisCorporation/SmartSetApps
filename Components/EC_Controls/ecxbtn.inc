{%MainUnit eceditbtns.pas}

{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)
  This is *include* file, shared code of TECSpeedBtn and TECBitnBtn, belongs to eceditbtns.pas

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

destructor BTNCLASSNAME.Destroy;
begin
  FreeAndNil(Core);
  inherited Destroy;
end;

procedure BTNCLASSNAME.BeginUpdate;
begin
  inc(UpdateCount);
end;

procedure BTNCLASSNAME.CalculatePreferredSize(var PreferredWidth,
            PreferredHeight: Integer; WithThemeSpace: Boolean);
var aSize: TSize;
begin
  aSize := Core.CalcPreferredSize(Canvas);
  PreferredWidth := aSize.cx;
  PreferredHeight := aSize.cy;
end;

procedure BTNCLASSNAME.Click;
begin
  case Mode of
    ebmToggleBox: if not assigned(Action) then Checked := not Checked;
    ebmDelayBtn: if Delay > 0 then
                   if Checked then
                     begin
                       ECTimer.Enabled := False;
                       ECTimer.Enabled := True;
                     end else
                     Checked := True;
  end;
  inherited Click;
end;

procedure BTNCLASSNAME.CMBiDiModeChanged(var Message: TLMessage);
var aRealLayout: TObjectPos;
begin
  aRealLayout := Layout;
  if IsRightToLeft then
    case aRealLayout of
      eopRight: aRealLayout := eopLeft;
      eopLeft: aRealLayout := eopRight;
    end;
  Core.RealLayout := aRealLayout;
  Redraw;
end;

procedure BTNCLASSNAME.CMButtonPressed(var Message: TLMessage);
var aSender: BTNCLASSNAME;
begin
  if csDestroying in ComponentState then exit;
  if Message.WParam = WParam(FGroupIndex) then
    begin
      aSender := BTNCLASSNAME(Message.LParam);
      if aSender <> self then
        begin
          if aSender.Checked and FChecked then
            begin
              FChecked := False;
              Invalidate;
            end;
          FAllowAllUp := aSender.AllowAllUp;
        end;
    end;
end;

procedure BTNCLASSNAME.CMColorChanged(var Message: TLMessage);
begin
  Core.NeedRedraw := True;
end;

procedure BTNCLASSNAME.CMParentColorChanged(var Message: TLMessage);
begin
  inherited CMParentColorChanged(Message);
  if not ParentColor then Core.NeedRedraw := True;
end;

procedure BTNCLASSNAME.CreateTimer;
begin
  ECTimer := TCustomECTimer.Create(Owner);
  ECTimer.Enabled := False;
end;

function BTNCLASSNAME.DialogChar(var Message: TLMKey): Boolean;
begin
  Result := False;
  if Message.Msg = LM_SYSCHAR then
    begin
      if IsEnabled and IsVisible then
        begin
          if IsAccel(Message.CharCode, Caption) then
            begin
              Click;
              Result := True;
            end else
            Result := inherited DialogChar(Message);
        end;
    end;
end;

procedure BTNCLASSNAME.EndUpdate;
begin
  dec(UpdateCount);
  if UpdateCount = 0 then
    begin
      Core.NeedRedraw := True;
      if AutoSize then
        begin
          InvalidatePreferredSize;
          AdjustSize;
        end;
      Invalidate;
    end;
end;

procedure BTNCLASSNAME.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  Core.NeedRedraw := True;  { Invalidate not necessary here }
end;

procedure BTNCLASSNAME.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
    begin
      Core.BtnPushed := True;
      if (Mode = ebmButton) and assigned(ECTimer) then
        if (Repeating = 0) or assigned(OnRepeating) then ECTimer.Enabled := True;
    end;
  Invalidate;
end;

procedure BTNCLASSNAME.MouseLeave;
begin
  {$IFDEF DBGCTRLS} DebugLn('TBaseECxBtn.MouseLeave'); {$ENDIF}
  inherited MouseLeave;
  if Core.BtnPushed then MouseUp(mbLeft, [ssLeft], 0, 0);
  Invalidate;
end;

procedure BTNCLASSNAME.MouseEnter;
begin
  inherited MouseEnter;
  Invalidate;
end;

procedure BTNCLASSNAME.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  Core.BtnPushed := False;
  if Mode <> ebmDelayBtn then  { when Delay <> 0 SetChecked cares of Invalidate; }
    begin
      if assigned(ECTimer) then ECTimer.Enabled := False;
      if Mode = ebmButton then Invalidate;
    end;
end;

procedure BTNCLASSNAME.Redraw;
begin
  Core.NeedRedraw := True;
  if UpdateCount = 0 then Invalidate;
end;

procedure BTNCLASSNAME.Resize;
begin
  inherited Resize;
  if Core.Resize(Width, Height) and (UpdateCount = 0) then Invalidate;
end;

procedure BTNCLASSNAME.ResizeInvalidate;
begin
  Core.NeedRedraw := True;
  if UpdateCount = 0 then
    begin;
      if AutoSize then
        begin
          InvalidatePreferredSize;
          AdjustSize;
        end;
      Invalidate;
    end;
end;

procedure BTNCLASSNAME.SetAction(Value: TBasicAction);
begin
  inherited SetAction(Value);
  if assigned(Value) and (Value is TCustomAction) and TCustomAction(Value).AutoCheck then Delay := -1;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetAutoSize(Value: Boolean);
begin
  inherited SetAutoSize(Value);
  if Value then
    begin
      InvalidatePreferredSize;
      AdjustSize;
      Core.NeedRedraw := True;
      Invalidate;
    end;
end;

procedure BTNCLASSNAME.SetParent(NewParent: TWinControl);
begin
  inherited SetParent(NewParent);
  if assigned(Core) then Core.NeedRedraw := True;
end;

procedure BTNCLASSNAME.SetTimerEvent;
begin
  if Mode = ebmDelayBtn
    then ECTimer.OnTimer := @TimerOnTimerDelay
    else if Repeating = 0
           then ECTimer.OnTimer := @TimerOnTimerHold
           else ECTimer.OnTimer := @TimerOnTimerRepeating;
end;

procedure BTNCLASSNAME.TextChanged;
begin
  inherited TextChanged;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.TimerOnTimerDelay(Sender: TObject);
begin
  ECTimer.Enabled := False;
  Checked := False;
  Invalidate;
end;

procedure BTNCLASSNAME.TimerOnTimerHold(Sender: TObject);
begin
  ECTimer.Enabled := False;
  if assigned(OnHoldDown) then
    begin
      OnHoldDown(self);
      ControlState := ControlState - [csClicked];
    end;
end;

procedure BTNCLASSNAME.TimerOnTimerRepeating(Sender: TObject);
begin
  if assigned(OnRepeating) then
    begin
      OnRepeating(self);
      ControlState := ControlState - [csClicked];
    end;
end;

procedure BTNCLASSNAME.UpdateGroup;
var aMsg : TLMessage;
begin
  if (FGroupIndex <> 0) and (Parent <> nil) and not (csLoading in ComponentState) then
    begin
      aMsg.Msg := CM_ButtonPressed;
      aMsg.WParam := FGroupIndex;
      aMsg.LParam := PtrInt(self);
      aMsg.Result := 0;
      Parent.Broadcast(aMsg);
    end;
end;

{ BTNCLASSNAME.Getters & Setters }

function BTNCLASSNAME.GetBtnBitmaps(AState: TItemState): TBitmap;
begin
  Result := Core.BtnBMPs[AState];
end;

function BTNCLASSNAME.GetCheckedFontColor: TColor;
begin
  Result := Core.FCheckedFontColor;
end;

function BTNCLASSNAME.GetCheckedFontStyles: TFontStyles;
begin
  Result := Core.FCheckedFontStyles;
end;

function BTNCLASSNAME.GetDropDownGlyph: TDropDownGlyph;
begin
  Result := Core.FDropDownGlyph;
end;

function BTNCLASSNAME.GetFlat: Boolean;
begin
  Result := Core.FFlat;
end;

function BTNCLASSNAME.GetGlyphColor: TColor;
begin
  Result := Core.FGlyphColor;
end;

function BTNCLASSNAME.GetGlyphDesign: TGlyphDesign;
begin
  Result := Core.FGlyphDesign;
end;

function BTNCLASSNAME.GetGlyphDesignChecked: TGlyphDesign;
begin
  Result := Core.FGlyphDesignChecked;
end;

function BTNCLASSNAME.GetImageIndex: TImageIndex;
begin
  Result := Core.FImageIndex;
end;

function BTNCLASSNAME.GetImageIndexChecked: TImageIndex;
begin
  Result := Core.FImageIndexChecked;
end;

function BTNCLASSNAME.GetImages: TCustomImageList;
begin
  Result := Core.FImages;
end;

function BTNCLASSNAME.GetImageWidth: SmallInt;
begin
  Result := Core.FImageWidth;
end;

function BTNCLASSNAME.GetLayout: TObjectPos;
begin
  Result := Core.FLayout;
end;

function BTNCLASSNAME.GetMargin: SmallInt;
begin
  Result := Core.FMargin;
end;

function BTNCLASSNAME.GetMode: TButtonMode;
begin
  Result := Core.FMode;
end;

function BTNCLASSNAME.GetShowCaption: Boolean;
begin
  Result := Core.FShowCaption;
end;

function BTNCLASSNAME.GetSpacing: SmallInt;
begin
  Result := Core.FSpacing;
end;

function BTNCLASSNAME.GetTransparent: Boolean;
begin
  Result := Core.FTransparent;
end;

procedure BTNCLASSNAME.SetAllowAllUp(AValue: Boolean);
begin
  if FAllowAllUp = AValue then exit;
  FAllowAllUp := AValue;
  UpdateGroup;
end;

procedure BTNCLASSNAME.SetChecked(AValue: Boolean);
begin
  if (FChecked = AValue) or (not AValue and (GroupIndex <> 0) and (not AllowAllUp)) then exit;
  FChecked := AValue;
  if [csLoading, csDestroying]*ComponentState = [] then
    begin
      if GroupIndex <> 0 then UpdateGroup;
      if AValue then
        begin
          case Mode of
            ebmButton: Mode := ebmToggleBox;
            ebmDelayBtn: if not (csDesigning in ComponentState)
                           then ECTimer.Enabled := True
                           else Mode := ebmToggleBox;
          end;
        end;
      if assigned(OnChange) then OnChange(self);
      if not AValue and assigned(OnRelease) then OnRelease(self);
    end;
  if not AValue or not Core.BtnDrawnPushed then Invalidate;
end;

procedure BTNCLASSNAME.SetCheckedFontColor(AValue: TColor);
begin
  if Core.FCheckedFontColor = AValue then exit;
  Core.FCheckedFontColor := AValue;
  Redraw;
end;

procedure BTNCLASSNAME.SetCheckedFontStyles(AValue: TFontStyles);
begin
  if Core.FCheckedFontStyles = AValue then exit;
  Core.FCheckedFontStyles := AValue;
  Redraw;
end;

procedure BTNCLASSNAME.SetDelay(AValue: Integer);
begin
  if FDelay = AValue then exit;
  FDelay := AValue;
  if not (csDesigning in ComponentState) then
    begin
      if (AValue > 0) and (Mode <> ebmToggleBox) then
        begin
          if not assigned(ECTimer) then
            begin
              CreateTimer;
              SetTimerEvent;
            end;
          ECTimer.Delay := AValue;
          ECTimer.Repeating := Repeating;
        end else
        FreeAndNil(ECTimer);
    end;
end;

procedure BTNCLASSNAME.SetDropDownGlyph(AValue: TDropDownGlyph);
begin
  if Core.FDropDownGlyph = AValue then exit;
  Core.FDropDownGlyph := AValue;
  Redraw;
end;

procedure BTNCLASSNAME.SetFlat(AValue: Boolean);
begin
  if Core.FFlat = AValue then exit;
  Core.FFlat := AValue;
  Redraw;
end;

procedure BTNCLASSNAME.SetGlyphColor(AValue: TColor);
begin
  if Core.FGlyphColor = AValue then exit;
  Core.FGlyphColor := AValue;
  if not (Core.HasValidImages or Core.HasValidActImage) then Redraw;
end;

procedure BTNCLASSNAME.SetGlyphDesign(AValue: TGlyphDesign);
begin
  if Core.FGlyphDesign=AValue then exit;
  Core.FGlyphDesign:=AValue;
  if not (Core.HasValidImages or Core.HasValidActImage) then ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetGlyphDesignChecked(AValue: TGlyphDesign);
begin
  if Core.FGlyphDesignChecked = AValue then exit;
  Core.FGlyphDesignChecked := AValue;
  if not (Core.HasValidImages or Core.HasValidActImage) and
    ((Mode <> ebmButton) or (GlyphDesign = egdNone)) then Redraw;
end;

procedure BTNCLASSNAME.SetGroupIndex(AValue: Integer);
begin
  if FGroupIndex = AValue then exit;
  FGroupIndex := AValue;
  if AValue <> 0 then
    begin
      FDelay := -1;  { only checkable button makes sense in group }
      UpdateGroup;
    end;
end;

procedure BTNCLASSNAME.SetImageIndex(AValue: TImageIndex);
begin
  if Core.FImageIndex = AValue then exit;
  Core.FImageIndex := AValue;
  if assigned(Images) then ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetImageIndexChecked(AValue: TImageIndex);
begin
  if Core.FImageIndexChecked = AValue then exit;
  Core.FImageIndexChecked := AValue;
  if (Mode <> ebmButton) or (ImageIndex < 0) then Redraw;
end;

procedure BTNCLASSNAME.SetImages(AValue: TCustomImageList);
begin
  if Core.FImages = AValue then exit;
  Core.FImages := AValue;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetImageWidth(AValue: SmallInt);
begin
  if Core.FImageWidth = AValue then exit;
  if AValue < 0 then AValue := 0;
  Core.FImageWidth := AValue;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetLayout(AValue: TObjectPos);
begin
  if Core.FLayout = AValue then exit;
  Core.FLayout := AValue;
  if IsRightToLeft then
    case AValue of
      eopRight: AValue := eopLeft;
      eopLeft: AValue := eopRight;
    end;
  Core.RealLayout := AValue;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetMargin(AValue: SmallInt);
begin
  if Core.FMargin = AValue then exit;
  Core.FMargin := AValue;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetMode(AValue: TButtonMode);
begin
  if Core.FMode = AValue then exit;
  if (AValue = ebmButton) or (Core.FMode = ebmButton) and ((ImageIndex <> ImageIndexChecked)
    or (GlyphDesign <> GlyphDesignChecked)) then Core.NeedRedraw := True;
  Core.FMode := AValue;
  if AValue <> ebmToggleBox then
    begin
      FGroupIndex := 0;
      Checked := False;
      if Delay > 0 then
        begin
          if not assigned(ECTimer) then CreateTimer;
          ECTimer.Delay := Delay;
          ECTimer.Repeating := Repeating;
        end;
    end else
    FreeAndNil(ECTimer);
  if assigned(ECTimer) then SetTimerEvent;
end;

procedure BTNCLASSNAME.SetRepeating(AValue: Integer);
begin
  if FRepeating = AValue then exit;
  FRepeating := AValue;
  if assigned(ECTimer) then
    begin
      ECTimer.Repeating := AValue;
      SetTimerEvent;
    end;
end;

procedure BTNCLASSNAME.SetShowCaption(AValue: Boolean);
begin
  if Core.FShowCaption = AValue then exit;
  Core.FShowCaption := AValue;
  if Caption <> '' then ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetSpacing(AValue: SmallInt);
begin
  if Core.FSpacing = AValue then exit;
  Core.FSpacing := AValue;
  ResizeInvalidate;
end;

procedure BTNCLASSNAME.SetTransparent(AValue: Boolean);
var aState: TItemState;
begin
  if Core.FTransparent = AValue then exit;
  Core.FTransparent := AValue;
  for aState in Core.ValidStates do
    Core.BtnBMPs[aState].Transparent := AValue;
  Redraw;
end;


