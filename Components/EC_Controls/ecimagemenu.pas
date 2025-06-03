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

unit ECImageMenu;
{$mode objfpc}{$H+}

//{$DEFINE DBGIMGMENU}  {don't remove, just comment}

interface

uses                                                                  
  Classes, SysUtils, Controls, StdCtrls, Forms, Graphics, ImgList, LCLIntf, LCLProc, LCLType,
  LMessages, Math, Themes, Types, ECTypes;

type    
  { TImageMenuItem }   
  TImageMenuItem = class(TCollectionItem)
  private
    FCaption: TCaption;
    FDescription: TCaption;
    FImageIndex: SmallInt;
    procedure SetCaption(const AValue: TCaption);
    procedure SetDescription(const AValue: TCaption);
    procedure SetImageIndex(AValue: SmallInt);
  protected const
    cDefCaption = 'MenuItem';   
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property Caption: TCaption read FCaption write SetCaption;
    property Description: TCaption read FDescription write SetDescription;
    property ImageIndex: SmallInt read FImageIndex write SetImageIndex default -1;
  end;
  
  TCustomECImageMenu = class;
  
  { TImageMenuItems }
  TImageMenuItems = class(TCollection)
  private
    function GetItems(Index: Integer): TImageMenuItem;
    procedure SetItems(Index: Integer; AValue: TImageMenuItem);
  protected
    FImageMenu: TCustomECImageMenu;
    function GetOwner: TPersistent; override;
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AImageMenu: TCustomECImageMenu);
    function Add: TImageMenuItem;
    property Items[Index: Integer]: TImageMenuItem read GetItems write SetItems; default;
  end;
  
  { TCustomECImageMenu }   
  TCustomECImageMenu = class(TCustomListBox)
  private
    FAlternate: Boolean;
    FCaptionAlign: SmallInt;                    
    FCaptionFontOptions: TFontOptions;
    FImages: TCustomImageList;
    FLayout: TObjectPos;
    FMenuItems: TImageMenuItems;
    FSpacing: SmallInt;
    procedure SetAlternate(AValue: Boolean);
    procedure SetCaptionAlign(AValue: SmallInt);
    procedure SetCaptionFontOptions(AValue: TFontOptions);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetLayout(AValue: TObjectPos);
    procedure SetMenuItems(AValue: TImageMenuItems);
    procedure SetSpacing(AValue: SmallInt);
  protected const
    cDefSpacing = 5;
  protected
    CaptionYPos, DescYPos, ImageYPos: Integer;
    NeedCalculate: Boolean;
    procedure Calculate;
    procedure CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer; 
                                     {%H-}WithThemeSpace: Boolean); override;
    function DialogChar(var Message: TLMKey): boolean; override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DrawItem(Index: Integer; ARect: TRect; {%H-}State: TOwnerDrawState); override;
    procedure InvalidateNonUpdated;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure RecalcInvalidate;
    procedure SetAutoSize(Value: Boolean); override;
    procedure SetBorderStyle(NewStyle: TBorderStyle); override;  
    procedure SetParent(NewParent: TWinControl); override;
  public
    UpdateCount: SmallInt;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate(Recalculate: Boolean = True); 
    procedure Invalidate; override;
    procedure Add(const ACaption, ADescription: TTranslateString; AImageIndex: SmallInt);
    procedure Delete(AIndex: Integer);
    procedure InitializeWnd; override;
    procedure Insert(AIndex: Integer; const ACaption, ADescription: TTranslateString;
                AImageIndex: SmallInt);
    property Alternate: Boolean read FAlternate write SetAlternate default False;
    property CaptionAlign: SmallInt read FCaptionAlign write SetCaptionAlign default 0;
    property CaptionFontOptions: TFontOptions read FCaptionFontOptions write SetCaptionFontOptions;
    property Images: TCustomImageList read FImages write SetImages;
    property Layout: TObjectPos read FLayout write SetLayout default eopTop;
    property MenuItems: TImageMenuItems read FMenuItems write SetMenuItems;
    property Spacing: SmallInt read FSpacing write SetSpacing default cDefSpacing;
  end;
    
  TECImageMenu = class(TCustomECImageMenu)
  published
    property Align;
    property Alternate;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property CaptionAlign;
    property CaptionFontOptions;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Images;
    property Layout;
    property MenuItems;  { do NOT change order MenuItems / ItemIndex }
    property ItemIndex;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnEndDrag;
    property OnExit;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnSelectionChange;
    property OnShowHint;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property ParentBidiMode;
    property ParentColor;
    property ParentShowHint;
    property ParentFont;
    property PopupMenu;
    property ScrollWidth;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property Visible;            
  end;   
  
implementation

{ TImageMenuItem }  

constructor TImageMenuItem.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FImageIndex := -1;       
end;

destructor TImageMenuItem.Destroy;
begin
  { normally, Items.Count should be already MenuItems.Count-1 ATM }
  { this solves case when item is not deleted via Collection.Delete(Index) }
  { but directly via Item.Free (exactly what Collection Editor of IDE does) }
  { therefore Notify must be called from here, so count of Items and MenuItems remains same }
  if assigned(Collection) and assigned(Collection.Owner) and
    not (csDestroying in (Collection.Owner as TCustomECImageMenu).ComponentState)
    and (Collection.Count <= (Collection.Owner as TCustomECImageMenu).Items.Count)
    then TImageMenuItems(Collection).Notify(self, cnDeleting);
  inherited Destroy;
end;

function TImageMenuItem.GetDisplayName: string;
begin
  Result := Caption;
  if Result = '' then Result := cDefCaption + intToStr(Index);
end;   

procedure TImageMenuItem.SetCaption(const AValue: TCaption);
begin
  if FCaption = AValue then exit;
  FCaption := AValue;
  Changed(True);
end;

procedure TImageMenuItem.SetDescription(const AValue: TCaption);
begin
  if FDescription = AValue then exit;
  FDescription := AValue;
  Changed(True);
end;

procedure TImageMenuItem.SetImageIndex(AValue: SmallInt);
begin
  if FImageIndex = AValue then exit;
  FImageIndex := AValue;
  Changed(False);
end;              

{ TImageMenuItems }

constructor TImageMenuItems.Create(AImageMenu: TCustomECImageMenu);
begin
  inherited Create(TImageMenuItem);
  FImageMenu := AImageMenu;
end;              

function TImageMenuItems.Add: TImageMenuItem;
begin
  Result := TImageMenuItem(inherited Add);
end;               

function TImageMenuItems.GetOwner: TPersistent;
begin
  Result := FImageMenu; 
end;

procedure TImageMenuItems.Notify(Item: TCollectionItem; Action: TCollectionNotification);
var i: Integer;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TImageMenuItems.Notify'); {$ENDIF}
  inherited Notify(Item, Action);
  case Action of 
    cnAdded:
      with Owner as TCustomECImageMenu do
        begin
          Items.Add('');
          if not (csLoading in ComponentState) then
            TImageMenuItem(Item).FCaption := TImageMenuItem.cDefCaption + intToStr(Item.ID);
        end;
    cnDeleting:
      with Owner as TCustomECImageMenu do
        begin
          i := ItemIndex;
          Items.Delete(Item.Index);
          if i < Count
            then ItemIndex := i
            else if i > 0 then ItemIndex := i - 1;
        end;
  end;
end;   

procedure TImageMenuItems.Update(Item: TCollectionItem);
begin
  {$IFDEF DBGIMGMENU} DebugLn('TImageMenuItems.Update ', boolToStr(assigned(Item), 'Item', 'All')); {$ENDIF}
  inherited Update(Item);
  FImageMenu.RecalcInvalidate;
end;

{ TImageMenuItems.Setters }

function TImageMenuItems.GetItems(Index: Integer): TImageMenuItem;
begin
  Result := TImageMenuItem(inherited Items[Index]);  
end;

procedure TImageMenuItems.SetItems(Index: Integer; AValue: TImageMenuItem);
begin
  Items[Index].Assign(AValue); 
end;

{ TCustomECImageMenu }

constructor TCustomECImageMenu.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  ClickOnSelChange := False;
  FMenuItems := TImageMenuItems.Create(self);
  FCaptionFontOptions := TFontOptions.Create(self);
  with FCaptionFontOptions do
    begin
      FontStyles := [fsBold];
      OnRecalcRedraw := @RecalcInvalidate;
      OnRedraw := @InvalidateNonUpdated;
    end;
  FSpacing := cDefSpacing;
  ExtendedSelect := False;
  MultiSelect := False;
  Style := lbOwnerDrawVariable;  { because of Win32 - it doesn't like lbOwnerDrawFixed }
  AccessibleRole := larMenuBar;
end;                                        

destructor TCustomECImageMenu.Destroy;
begin
  FreeAndNil(FCaptionFontOptions);
  FreeAndNil(FMenuItems);
  inherited Destroy;
end;  

procedure TCustomECImageMenu.Add(const ACaption, ADescription: TTranslateString; AImageIndex: SmallInt);
begin
  Insert(MenuItems.Count, ACaption, ADescription, AImageIndex);
end;

procedure TCustomECImageMenu.BeginUpdate;
begin
  inc(UpdateCount);
end;

procedure TCustomECImageMenu.Calculate;
var aCaption: string;
    i, aCaptionHeight, aDescHeight, aImagesHeight, aItemHeight, aTextHeight: Integer;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.Calculate'); {$ENDIF}
  if assigned(Images) 
    then aImagesHeight := Images.Height
    else aImagesHeight := 0;    
  aCaptionHeight := 0;
  aDescHeight := 0;
  if MenuItems.Count > 0 then
    begin
      Canvas.Font.Assign(self.Font);  { Description is written with default Font }
      for i :=0 to MenuItems.Count-1 do
        begin
          aCaption := MenuItems[i].Description;
          if aCaption <> '' then
            aDescHeight := Math.max(aDescHeight, ThemeServices.GetTextExtent(Canvas.Handle,
                             ArBtnDetails[True, False], aCaption, 0, nil).Bottom);
        end;
      Canvas.Font.Size := CaptionFontOptions.FontSize;
      Canvas.Font.Style := CaptionFontOptions.FontStyles;
      for i :=0 to MenuItems.Count-1 do
        begin
          aCaption := MenuItems[i].Caption;
          if aCaption <> '' then
            aCaptionHeight := Math.max(aCaptionHeight, ThemeServices.GetTextExtent(Canvas.Handle,
                                ArBtnDetails[True, False], aCaption, 0, nil).Bottom);
        end;
    end;
  case FLayout of
    eopTop: 
      begin
        ImageYPos := Spacing;
        if aImagesHeight > 0
          then CaptionYPos := ImageYPos + aImagesHeight + Spacing
          else CaptionYPos := ImageYPos;
        if aCaptionHeight > 0
          then DescYPos := CaptionYPos + aCaptionHeight + Spacing
          else DescYPos := CaptionYPos;
        if aDescHeight > 0
          then aItemHeight := DescYPos + aDescHeight + Spacing
          else aItemHeight := DescYPos;
      end;    
    eopBottom:
      begin
        CaptionYPos := Spacing;
        if aCaptionHeight > 0 
          then ImageYPos := CaptionYPos + aCaptionHeight + Spacing
          else ImageYPos := CaptionYPos;    
        if aImagesHeight > 0 
          then DescYPos := ImageYPos + aImagesHeight + Spacing
          else DescYPos := ImageYPos;
        if aDescHeight > 0
          then aItemHeight := DescYPos + aDescHeight + Spacing
          else aItemHeight := DescYPos;
      end; 
    otherwise  { eopRight, eopLeft }
      aItemHeight := Spacing;
      if aImagesHeight > 0 then inc(aItemHeight, aImagesHeight + Spacing);
      aTextHeight := Spacing;
      if aCaptionHeight > 0 then inc(aTextHeight, aCaptionHeight + Spacing);
      if aDescHeight > 0 then inc(aTextHeight, aDescHeight + Spacing);
      aItemHeight := Math.max(aItemHeight, aTextHeight);
      ImageYPos := (aItemHeight - aImagesHeight) div 2;
      if (aCaptionHeight > 0) xor (aDescHeight > 0) then
        begin
          CaptionYPos := (aItemHeight - aCaptionHeight) div 2;
          DescYPos := CaptionYPos;
        end else
        begin
          CaptionYPos := (aItemHeight - aCaptionHeight - aDescHeight - Spacing) div 2;
          DescYPos := CaptionYPos + aCaptionHeight + Spacing;
        end;
  end;  {case}
  inc(UpdateCount);  { this avoids calling Calculate twice }
  ItemHeight := aItemHeight;
  dec(UpdateCount);
  NeedCalculate := False;
end;  

procedure TCustomECImageMenu.CalculatePreferredSize(var PreferredWidth, PreferredHeight: Integer; 
            WithThemeSpace: Boolean);
var aCaption: string;
    i, aImageWidth, aTextWidth: Integer;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.CalculatePreferredSize'); {$ENDIF}
  PreferredHeight := 0;
  if assigned(Images)
    then aImageWidth := Images.Width
    else aImageWidth := 0;
  aTextWidth := 0;
  Canvas.Font.Assign(Font);
  for i := 0 to MenuItems.Count - 1 do
    aTextWidth := Math.max(aTextWidth, ThemeServices.GetTextExtent(Canvas.Handle,
                    ArBtnDetails[True, False], MenuItems[i].Description, DT_LEFT, nil).Right);
  Canvas.Font.Size := CaptionFontOptions.FontSize;
  Canvas.Font.Style := CaptionFontOptions.FontStyles;
  for i := 0 to MenuItems.Count - 1 do 
    begin
      aCaption := MenuItems[i].Caption;
      DeleteAmpersands(aCaption);
      aTextWidth := Math.max(aTextWidth, ThemeServices.GetTextExtent(Canvas.Handle,
                      ArBtnDetails[True, False], aCaption, DT_LEFT, nil).Right);
    end;
  i := 2*Spacing + Width - ClientWidth;
  inc(aTextWidth, abs(CaptionAlign));
  if Layout in [eopRight, eopLeft] then
    begin
      if aImageWidth*aTextWidth > 0 then inc(aImageWidth, Spacing);
      PreferredWidth := aImageWidth + aTextWidth + i;
    end else 
      PreferredWidth := Math.max(aImageWidth, aTextWidth) + i;
end;  

procedure TCustomECImageMenu.Delete(AIndex: Integer);
begin
  BeginUpdate;
  MenuItems.Delete(AIndex);
  EndUpdate(False);
end;                                        

function TCustomECImageMenu.DialogChar(var Message: TLMKey): boolean;
var i: Integer;
begin
  Result := False;
  if Message.Msg = LM_SYSCHAR then 
    if IsEnabled and IsVisible then
      begin
        for i := 0 to MenuItems.Count - 1 do
          if IsAccel(Message.CharCode, MenuItems[i].Caption) then
            begin
              Selected[i] := True;
              SetFocus;
              Result := True;
              Click;
              exit;  { Exit! }
            end;
        Result := inherited DialogChar(Message);
      end;
end;   

function TCustomECImageMenu.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
    begin
      if ItemIndex < (Items.Count - 1) then ItemIndex := ItemIndex + 1;
      Result := True;
    end;
end;

function TCustomECImageMenu.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
    begin
      if ItemIndex > 0 then ItemIndex := ItemIndex - 1;
      Result := True;
    end;
end;

procedure TCustomECImageMenu.DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState);
var aFlags: Cardinal;
    aHelpRect: TRect;
    bEnabled: Boolean;
begin  { do not call inherited ! }
  bEnabled := IsEnabled;                
  if odSelected in State then
    begin
      if not Focused then Canvas.Brush.Color :=
        GetMergedColor(Canvas.Brush.Color, GetColorResolvingDefault(Color, Brush.Color), 0.6);
    end else
    begin
      if ((Index and 1) = 1) and Alternate then Canvas.Brush.Color :=
        GetMergedColor(Canvas.Brush.Color, ColorToRGB(clForm), 0.5);
    end;
  if not bEnabled then Canvas.Brush.Color := GetMonochromaticColor(Canvas.Brush.Color);
  Canvas.FillRect(ARect);
  inc(ARect.Left, Spacing);
  dec(ARect.Right, Spacing);
  if assigned(Images) then
    begin
      case Layout of
        eopRight: 
          begin
            aHelpRect.Left := ARect.Right - Images.Width;
            dec(ARect.Right, Images.Width + Spacing);
          end;
        eopLeft: 
          begin
            aHelpRect.Left := ARect.Left;
            inc(ARect.Left, Images.Width + Spacing);
          end;
        otherwise
          aHelpRect.Left :=  Spacing + (ARect.Right - ARect.Left - Images.Width) div 2;
      end;
      aHelpRect.Top := ARect.Top + ImageYPos;
      ThemeServices.DrawIcon(Canvas, ArBtnDetails[bEnabled, False], aHelpRect.TopLeft, Images, MenuItems[Index].ImageIndex);
    end;  
  aHelpRect.Bottom := ARect.Bottom;
  if MenuItems[Index].Description <> '' then
    begin
      aHelpRect.Left := ARect.Left;
      aHelpRect.Right := ARect.Right;
      aHelpRect.Top := ARect.Top + DescYPos;
        case CaptionAlign of
          low(SmallInt)..-1:
            if Layout in [eopTop, eopBottom] then
              begin
                aFlags := DT_RIGHT;
                inc(aHelpRect.Right, CaptionAlign);
              end else
              begin
                aFlags := DT_LEFT;
                dec(aHelpRect.Left, CaptionAlign);
              end;
          0: aFlags := DT_CENTER;
          1..high(SmallInt):
            if Layout in [eopTop, eopBottom] then
              begin
                aFlags := DT_LEFT;
                inc(aHelpRect.Left, CaptionAlign);
              end else
              begin
                aFlags := DT_RIGHT;
                dec(aHelpRect.Right, CaptionAlign);
              end;
        end;
      Canvas.Font.Assign(Font);
      aFlags := aFlags or DT_END_ELLIPSIS or caDTRTLFlags[IsRightToLeft] or DT_NOPREFIX or DT_VCENTER;
      if (odSelected in State) and (Font.Color = clDefault) then Canvas.Font.Color := clHighlightText;
      ThemeServices.DrawText(Canvas, ArBtnDetails[bEnabled, False], MenuItems[Index].Description, aHelpRect, aFlags, 0);
    end;
  if MenuItems[Index].Caption <> '' then
    begin
      aHelpRect.Left := ARect.Left;
      aHelpRect.Right := ARect.Right;
      aHelpRect.Top := ARect.Top + CaptionYPos;
      case CaptionAlign of
        low(SmallInt)..-1:
          begin
            aFlags := DT_LEFT;
            dec(aHelpRect.Left, CaptionAlign);
          end;
        0: aFlags := DT_CENTER;
        1..high(SmallInt):
          begin
            aFlags := DT_RIGHT;
            dec(aHelpRect.Right, CaptionAlign);
          end;
      end;
      if CaptionFontOptions.FontColor <> clDefault
        then Canvas.Font.Color := CaptionFontOptions.FontColor
        else if odSelected in State then Canvas.Font.Color := clHighlightText;
      Canvas.Font.Size := CaptionFontOptions.FontSize;
      Canvas.Font.Style := CaptionFontOptions.FontStyles;
      aFlags := aFlags or caDTRTLFlags[IsRightToLeft] or DT_SINGLELINE;
      ThemeServices.DrawText(Canvas, ArBtnDetails[bEnabled, False], MenuItems[Index].Caption, aHelpRect, aFlags, 0);
    end;  
end;        

procedure TCustomECImageMenu.EndUpdate(Recalculate: Boolean = True);
begin
  dec(UpdateCount);
  if UpdateCount = 0 then 
    if Recalculate
      then RecalcInvalidate
      else Invalidate;
end;

procedure TCustomECImageMenu.InitializeWnd;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.InitializeWnd'); {$ENDIF}
  if (MenuItems.Count > 0) and (UpdateCount = 0) then Calculate;
  inherited InitializeWnd;
end;

procedure TCustomECImageMenu.Insert(AIndex: Integer; const ACaption, ADescription: TTranslateString;
            AImageIndex: SmallInt);
var aItem: TCollectionItem;
begin
  if (AIndex >= 0) and (AIndex <= MenuItems.Count) then
    begin
      BeginUpdate;
      aItem := MenuItems.Insert(AIndex);
      with aItem as TImageMenuItem do
        begin
          Caption := ACaption;
          Description := ADescription;
          ImageIndex := AImageIndex;
        end;
      EndUpdate(AutoSize);
    end;
end;        

procedure TCustomECImageMenu.Invalidate;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.Invalidate'); {$ENDIF}
  if NeedCalculate and (MenuItems.Count > 0) and HandleAllocated then Calculate;
  inherited Invalidate;
end;        

procedure TCustomECImageMenu.InvalidateNonUpdated;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECIM.InvalidateNonUpdate'); {$ENDIF}
  if UpdateCount = 0 then Invalidate;
end; 

procedure TCustomECImageMenu.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key in [VK_RETURN, VK_SPACE]) and (Shift*[ssShift, ssAlt, ssCtrl, ssMeta] = []) then Click;
end; 

procedure TCustomECImageMenu.RecalcInvalidate;
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.Recalc'); {$ENDIF}
  if UpdateCount = 0 then
    begin  
      if AutoSize then
        begin
          InvalidatePreferredSize;
          BeginUpdateBounds;
          AdjustSize;
          EndUpdateBounds;
        end;   
      NeedCalculate := True;
      Invalidate;
    end;
end;  

procedure TCustomECImageMenu.SetAutoSize(Value: Boolean);
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.SetAutoSize'); {$ENDIF}
  inherited SetAutoSize(Value);
  if Value then 
    begin
      InvalidatePreferredSize;
      AdjustSize;
      NeedCalculate := True;
      Invalidate;   
    end;
end;  

procedure TCustomECImageMenu.SetBorderStyle(NewStyle: TBorderStyle);
begin
  inherited SetBorderStyle(NewStyle);
  if AutoSize then RecalcInvalidate;
end;                

procedure TCustomECImageMenu.SetParent(NewParent: TWinControl);
begin
  {$IFDEF DBGIMGMENU} DebugLn('TCustomECImageMenu.SetParent'); {$ENDIF}
  inc(UpdateCount);																
  inherited SetParent(NewParent);
  if assigned(NewParent) and (MenuItems.Count > 0) then Calculate;
  dec(UpdateCount);
end;         
       
{ Setters }

procedure TCustomECImageMenu.SetAlternate(AValue: Boolean);
begin
  if FAlternate = AValue then exit;
  FAlternate := AValue;
  InvalidateNonUpdated;
end; 

procedure TCustomECImageMenu.SetCaptionAlign(AValue: SmallInt);
begin
  if FCaptionAlign = AValue then exit;
  FCaptionAlign := AValue;
  RecalcInvalidate;
end;       

procedure TCustomECImageMenu.SetCaptionFontOptions(AValue: TFontOptions);
begin
  if FCaptionFontOptions = AValue then exit;
  FCaptionFontOptions := AValue;
  RecalcInvalidate;
end;

procedure TCustomECImageMenu.SetImages(AValue: TCustomImageList);
begin
  if FImages = AValue then exit;
  FImages := AValue;
  RecalcInvalidate;
end;         

procedure TCustomECImageMenu.SetLayout(AValue: TObjectPos);
begin
  if FLayout = AValue then exit;
  FLayout := AValue;
  RecalcInvalidate;
end;   

procedure TCustomECImageMenu.SetMenuItems(AValue: TImageMenuItems);
begin
  if FMenuItems <> AValue then
    begin
      FMenuItems.Assign(AValue);
      RecalcInvalidate;
    end;
end;         

procedure TCustomECImageMenu.SetSpacing(AValue: SmallInt);
begin
  if FSpacing = AValue then exit;
  FSpacing := AValue;
  RecalcInvalidate;
end;         

end.


