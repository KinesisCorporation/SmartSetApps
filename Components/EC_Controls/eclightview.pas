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

unit ECLightView;
{$mode objfpc}{$H+}

//{$DEFINE DBGVIEW}  {don't remove, just comment}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, Graphics, ImgList, LazFileUtils, LazUTF8, LCLIntf,
  LCLProc, LCLType, LMessages, Math, Messages, Types, ECTypes;

type
  {$PACKENUM 2}
  {$PACKSET 2}
  TECLVFlag = (elfLayoutBlocks, elfLockCursor, elfParse, elfRedraw, elfRedrawAll, elfResize, elfWasEnabled);
  TECLVFlags = set of TECLVFlag;
  TECLVElementFlag = (elefImgBMP, elefImgJPEG, elefImgPNG, elefMonoSpace, elefOpenTag,
                      elefStrechtDraw, elefVisited);
  TECLVElementFlags = set of TECLVElementFlag;

  {$PACKRECORDS 2}
  TECLVBlock = record
    Pos: TRect;
    LogicLine: LongWord;
    TextStart: Integer;
    TextLength: Word;
  end;

  TECLVElement = record
    Tag: Char;
    TextStart: Integer;
    TextLength: Integer;
    Height: SmallInt;
    Flags: TECLVElementFlags;
    Blocks: array of TECLVBlock;
    BlockCount: Integer;
    BackColor: TColor;
    FontColor: TColor;
    FontHeight: SmallInt;
    FontStyles: TFontStyles;
    Alignment: TAlignment;
    GlyphAlign: TAlignment;
    SpaceWidth: Byte;
    Value: Integer;
  end;

  { TCustomECLightView }
  TCustomECLightView = class(TBaseScrollControl)
  private
    FColorHovered: TColor;
    FColorLink: TColor;
    FColorVisited: TColor;
    FHoveredElement: Integer;
    FImages: TCustomImageList;
    FImageWidth: SmallInt;
    FIndent: SmallInt;
    FOnInterLinkClick: TIntegerEvent;
    FPathToPictures: string;
    FTextData: string;
    procedure SetColorLink(AValue: TColor);
    procedure SetColorVisited(AValue: TColor);
    procedure SetHoveredElement(AValue: Integer);
    procedure SetImages(AValue: TCustomImageList);
    procedure SetImageWidth(AValue: SmallInt);
    procedure SetIndent(AValue: SmallInt);
    procedure SetPathToPictures(AValue: string);
    procedure SetTextData(AValue: string);
  protected const
    cDefIndent = 3;
  protected
    BMP: TBitmap;
    BMPs: array of TBitmap;
    JPGs: array of TJPEGImage;
    PNGs: array of TPortableNetworkGraphic;
    Elements: array of TECLVElement;
    DefColorHov, DefColorLnk, DefColorVis: TColor;
    DefCursor: TCursor;
    DefFontHeight: SmallInt;
    DefLineHeight3: SmallInt;
    DefLineHeight: SmallInt;
    ElementsCount: Integer;
    FirstVisiEl, LastVisiEl: Integer;
    Flags: TECLVFlags;
    InitElement: TECLVElement;
    PrevClientAreaTop: Integer;
    PrevClientSize: TSize;
    PushedElement: Integer;
    WorkText: string;
    procedure CMBiDiModeChanged(var Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure CMColorChanged(var {%H-}Message: TLMessage); message CM_COLORCHANGED;
    procedure Draw;
    procedure FontChanged(Sender: TObject); override;
    procedure FreeImages;
    class function GetControlClassDefaultSize: TSize; override;
    function GetIncrementY: Integer; override;
    function GetLinkColor(AVisited, AHovered: Boolean): TColor;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure LayoutBlocks;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure ParseElements;
    procedure RedrawLink(AIndex: Integer; AHovered: Boolean);
    procedure SetCursor(Value: TCursor); override;
    procedure UpdateRequiredAreaHeight; override;
    procedure UpdateRequiredAreaWidth; override;
    procedure WMSize(var {%H-}Message: TLMSize); message LM_SIZE;
    procedure WMVScroll(var Msg: TWMScroll); message WM_VSCROLL;
    property HoveredElement: Integer read FHoveredElement write SetHoveredElement;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ColorHovered: TColor read FColorHovered write FColorHovered default clDefault;
    property ColorLink: TColor read FColorLink write SetColorLink default clDefault;
    property ColorVisited: TColor read FColorVisited write SetColorVisited default clDefault;
    property Images: TCustomImageList read FImages write SetImages;
    property ImageWidth: SmallInt read FImageWidth write SetImageWidth default 0;
    property Indent: SmallInt read FIndent write SetIndent default cDefIndent;
    property OnInterLinkClick: TIntegerEvent read FOnInterLinkClick write FOnInterLinkClick;
    property PathToPictures: string read FPathToPictures write SetPathToPictures;
    property TextData: string read FTextData write SetTextData;
  end;

  { TECLightView }
  TECLightView = class(TCustomECLightView)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderSpacing;
    property BorderStyle default bsSingle;
    property Color;
    property ColorHovered;
    property ColorLink;
    property ColorVisited;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Images;
    property ImageWidth;
    property Indent;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PathToPictures;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property TextData;
    property Visible;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnInterLinkClick;
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

const cBaseSize = 32;
      cBiDiAlign: array[TAlignment, Boolean] of TAlignment =
        ((taLeftJustify, taRightJustify), (taRightJustify, taLeftJustify), (taCenter, taCenter));
      cLinkTags = ['A', 'E', 'Y'];
      cTextTags = ['A'..'F', 'H'..'N', 'P'..'V', 'Y', 'Z'];

{ TCustomECLightView }

constructor TCustomECLightView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csOpaque, csClickEvents, csParentBackground]+csMultiClicks
                            -[csAcceptsControls, csCaptureMouse, csNoFocus, csSetCaption];
  BorderStyle:=bsSingle;
  Color:=clDefault;
  FColorHovered:=clDefault;
  FColorLink:=clDefault;
  FColorVisited:=clDefault;
  if IsColorDark(clBtnText) then
    begin
      DefColorHov:=$F00000;
      DefColorLnk:=$A00000;
      DefColorVis:=$800080;
    end else
    begin
      DefColorHov:=$FF6060;
      DefColorLnk:=$FF2020;
      DefColorVis:=$D040D0;
    end;
  DefCursor:=Cursor;
  FHoveredElement:=-1;
  FIndent:=cDefIndent;
  ParentColor:=False;
  FScrollBars:=ssAutoVertical;
  TabStop:=True;
  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, cx, cy);
  BMP:=TBitmap.Create;
  BMP.Transparent:=False;
  BMP.Canvas.AntialiasingMode:=amOff;
  Flags:=[elfLayoutBlocks, elfParse, elfResize, elfWasEnabled];
  AccessibleRole:=larListBox;
end;

destructor TCustomECLightView.Destroy;
begin
  BMP.Free;
  FreeImages;
  inherited Destroy;
end;

procedure TCustomECLightView.CMBiDiModeChanged(var Message: TLMessage);
begin
  inherited CMBiDiModeChanged(Message);
  Flags:=Flags+[elfLayoutBlocks];
end;

procedure TCustomECLightView.CMColorChanged(var Message: TLMessage);
var aColor: TColor;
    i: Integer;
begin
  if ElementsCount>0 then
    begin
      aColor:=GetColorResolvingDefault(Color, clWindow);
      Elements[0].BackColor:=aColor;
      for i:=1 to ElementsCount-1 do
        if Elements[i].Tag<>'H' then Elements[i].BackColor:=aColor;
    end;
  include(Flags, elfRedrawAll);
end;

procedure TCustomECLightView.Draw;

  procedure CalcBoundVisiEls;
  var i, j: Integer;
      bDone: Boolean;
  begin
    FirstVisiEl:=-1;
    LastVisiEl:=-2;
    bDone:=False;
    for i:=0 to ElementsCount-1 do
      begin
        for j:=0 to Elements[i].BlockCount-1 do
          if (Elements[i].Blocks[j].Pos.Top+Elements[i].Height)>ClientAreaTop then
            begin
              FirstVisiEl:=i;
              bDone:=True;
              break;
            end;
        if bDone then break;
      end;
    if FirstVisiEl>=0 then
      begin
        for i:=FirstVisiEl to ElementsCount-1 do
          for j:=0 to Elements[i].BlockCount-1 do
            if Elements[i].Blocks[j].Pos.Top>(ClientAreaTop+ClientHeight) then
              begin
                LastVisiEl:=i;
                exit;  { Exit; }
              end;
        LastVisiEl:=ElementsCount-1;
      end;
  end;

  procedure DrawMonoText(ABlock: TECLVBlock);
  var aCurP, aEndP: PChar;
      aStr: string;
      x, y, aCharSize, aMonoWidth: SmallInt;
  begin
    aMonoWidth:=BMP.Canvas.TextWidth('W');
    aCurP:=PChar(WorkText)+ABlock.TextStart-1;
    aEndP:=aCurP+ABlock.TextLength;
    x:=ABlock.Pos.Left;
    y:=ABlock.Pos.Top-ClientAreaTop;
    while aCurP<aEndP do
      begin
        aCharSize:=UTF8CodepointSize(aCurP);
        aStr:=Copy(WorkText, PtrInt(aCurP-PChar(WorkText)+1), aCharSize);
        BMP.Canvas.TextOut(x+(aMonoWidth-BMP.Canvas.TextWidth(aStr)) div 2, y, aStr);
        inc(x, aMonoWidth);
        inc(aCurP, aCharSize)
      end;
  end;

var aColor: TColor;
    aPoint: TPoint;
    aRect, aRectB: TRect;
    bEnabled, bScroll: Boolean;
    i, j, aHelp: Integer;
begin
  {$IFDEF DBGVIEW} DebugLn({$I %CURRENTROUTINE%}, ' '+intToStr(ClientAreaTop)); {$ENDIF}
  CalcBoundVisiEls;
  aHelp:=abs(PrevClientAreaTop-ClientAreaTop);
  bScroll:=((aHelp<ClientHeight) and not (elfRedrawAll in Flags));
  BMP.Canvas.Clipping:=False;
  if bScroll then
    begin  { copy part of BMP }
      aRect:=Rect(0, aHelp, BMP.Width, BMP.Height);
      aRectB:=Rect(0, 0, BMP.Width, BMP.Height-aHelp);
      if PrevClientAreaTop<ClientAreaTop then
        begin  { up to top }
          BMP.Canvas.CopyRect(aRectB, BMP.Canvas, aRect);
          BMP.Canvas.ClipRect:=Rect(0, BMP.Height-aHelp, BMP.Width, BMP.Height);
          aRectB.Top:=aRectB.Bottom+ClientAreaTop;
          aRectB.Bottom:=aRect.Bottom+ClientAreaTop;
          aRect:=Rect(0, BMP.Height-aHelp, BMP.Width, BMP.Height);
        end else
        begin  { down to bottom }
          BMP.Canvas.CopyRect(aRect, BMP.Canvas, aRectB);
          BMP.Canvas.ClipRect:=Rect(0, 0, BMP.Width, aHelp);
          aRectB.Top:=ClientAreaTop;
          aRectB.Bottom:=ClientAreaTop+aHelp;
          aRect:=Rect(0, 0, BMP.Width, aHelp);
        end;
    end else
    begin
      aRect:=Rect(0, 0, BMP.Width, BMP.Height);
      aRectB:=Rect(0, ClientAreaTop, BMP.Width, ClientAreaTop+ClientHeight);
      BMP.Canvas.ClipRect:=aRect;
   end;
  PrevClientAreaTop:=ClientAreaTop;
  bEnabled:=IsEnabled;
  BMP.Canvas.Brush.Color:=GetColorResolvingDefAndEnabled(Color, clWindow, bEnabled);
  BMP.Canvas.Brush.Style:=bsSolid;
  BMP.Canvas.FillRect(aRect);
  BMP.Canvas.Clipping:=True;
  for i:=0 to ElementsCount-1 do
    begin
      BMP.Canvas.Brush.Color:=GetColorResolvingEnabled(Elements[i].BackColor, bEnabled);
      if not bScroll and (Elements[i].BackColor=Elements[0].BackColor)
        then BMP.Canvas.Brush.Style:=bsClear;
      if (Elements[i].Tag in cLinkTags) and (elefOpenTag in Elements[i].Flags)
        then aColor:=GetLinkColor(elefVisited in Elements[i].Flags, HoveredElement=i)
        else aColor:=Elements[i].FontColor;
      BMP.Canvas.Font.Color:=GetColorResolvingEnabled(aColor, bEnabled);
      if Elements[i].Tag in cTextTags then
        begin
          BMP.Canvas.Font.Style:=Elements[i].FontStyles;
          for j:=0 to Elements[i].BlockCount-1 do
            if (Elements[i].Blocks[j].Pos.Top-aRectB.Top+Elements[i].Height)>0 then
              begin
                if Elements[i].Blocks[j].Pos.Top>aRectB.Bottom then exit;  { Exit; }
                BMP.Canvas.Font.Height:=DefFontHeight+Elements[i].FontHeight;
                BMP.Canvas.Pen.Style:=psClear;
                if not (elefMonoSpace in Elements[i].Flags)
                  then with Elements[i].Blocks[j] do
                         BMP.Canvas.TextOut(Pos.Left, Pos.Top-ClientAreaTop, Copy(WorkText, TextStart, TextLength))
                  else DrawMonoText(Elements[i].Blocks[j]);
              end;
        end else
        case Elements[i].Tag of
          'G':  { image from Images }
            if assigned(Images) then
              begin
                case Elements[i].GlyphAlign of
                  taLeftJustify:  aPoint.X:=Indent;
                  taRightJustify: aPoint.X:=ClientWidth-Indent-Math.max(Images.Width, ImageWidth);
                  taCenter:       aPoint.X:=(ClientWidth-Math.max(Images.Width, ImageWidth)) div 2;
                end;
                aPoint.Y:=Elements[i].TextStart-ClientAreaTop;
                Images.DrawForPPI(BMP.Canvas, aPoint.X, aPoint.Y, Elements[i].Value, ImageWidth,
                  Font.PixelsPerInch, 1, caGraphEffects[caItemState[bEnabled]]);
              end;
          'O':  { horizontal line }
            begin
              BMP.Canvas.Pen.Color:=BMP.Canvas.Font.Color;
              BMP.Canvas.Pen.EndCap:=pecFlat;
              BMP.Canvas.Pen.Style:=psSolid;
              BMP.Canvas.Pen.Width:=Elements[i].Value;
              j:=Elements[i].TextStart-ClientAreaTop;
              if Elements[i].TextLength>=0
                then BMP.Canvas.Line(Elements[i].TextLength, j, ClientWidth-Indent, j)
                else BMP.Canvas.Line(Indent, j, ClientWidth+Elements[i].TextLength, j);
            end;
          'W':  { image from resources }
            begin
              case Elements[i].GlyphAlign of
                taLeftJustify:  aPoint.X:=Indent;
                taRightJustify: aPoint.X:=ClientWidth-Indent-Elements[i].TextLength;
                taCenter:       aPoint.X:=(ClientWidth-Elements[i].TextLength) div 2;
              end;
              aPoint.Y:=Elements[i].TextStart-ClientAreaTop;
              if elefStrechtDraw in Elements[i].Flags then
                begin
                  aRect:=Rect(aPoint.X, aPoint.Y, aPoint.X+Elements[i].TextLength,
                              aPoint.Y+Elements[i].Height-2*DefLineHeight3);
                  BMP.Canvas.StretchDraw(aRect, PNGs[Elements[i].Value]);
                end else
                  BMP.Canvas.Draw(aPoint.X, aPoint.Y, PNGs[Elements[i].Value]);
            end;
          'X':  { image from file }
            begin
              case Elements[i].GlyphAlign of
                taLeftJustify:  aPoint.X:=Indent;
                taRightJustify: aPoint.X:=ClientWidth-Indent-Elements[i].TextLength;
                taCenter:       aPoint.X:=(ClientWidth-Elements[i].TextLength) div 2;
              end;
              aPoint.Y:=Elements[i].TextStart-ClientAreaTop;
              if not (elefStrechtDraw in Elements[i].Flags) then
                begin
                  if elefImgJPEG in Elements[i].Flags
                    then BMP.Canvas.Draw(aPoint.X, aPoint.Y, JPGs[Elements[i].Value])
                    else if elefImgPNG in Elements[i].Flags
                           then BMP.Canvas.Draw(aPoint.X, aPoint.Y, PNGs[Elements[i].Value])
                           else if elefImgBMP in Elements[i].Flags
                                  then BMP.Canvas.Draw(aPoint.X, aPoint.Y, BMPs[Elements[i].Value]);
                end else
                begin
                  aRect:=Rect(aPoint.X, aPoint.Y, aPoint.X+Elements[i].TextLength,
                              aPoint.Y+Elements[i].Height-2*DefLineHeight3);
                  if elefImgJPEG in Elements[i].Flags
                    then BMP.Canvas.StretchDraw(aRect, JPGs[Elements[i].Value])
                    else if elefImgPNG in Elements[i].Flags
                           then BMP.Canvas.StretchDraw(aRect, PNGs[Elements[i].Value])
                           else if elefImgBMP in Elements[i].Flags
                                  then BMP.Canvas.StretchDraw(aRect, BMPs[Elements[i].Value]);
                end;
            end;
        end;  {case}
    end;
end;

procedure TCustomECLightView.FontChanged(Sender: TObject);
begin
  inherited FontChanged(Sender);
  Flags:=Flags+[elfLayoutBlocks, elfParse, elfResize];
end;

procedure TCustomECLightView.FreeImages;
var i: Integer;
begin
  for i:=0 to length(BMPs)-1 do
    BMPs[i].Free;
  SetLength(BMPs, 0);
  for i:=0 to length(JPGs)-1 do
    JPGs[i].Free;
  SetLength(JPGs, 0);
  for i:=0 to length(PNGs)-1 do
    PNGs[i].Free;
  SetLength(PNGs, 0);
end;

class function TCustomECLightView.GetControlClassDefaultSize: TSize;
begin
  Result:=Size(240, 240);
end;

function TCustomECLightView.GetIncrementY: Integer;
begin
  Result:=DefLineHeight;
end;

function TCustomECLightView.GetLinkColor(AVisited, AHovered: Boolean): TColor;
begin
  if not AHovered
    then if not AVisited
           then Result:=GetColorResolvingDefault(ColorLink, DefColorLnk)
           else Result:=GetColorResolvingDefault(ColorVisited, DefColorVis)
    else Result:=GetColorResolvingDefault(ColorHovered, DefColorHov);
end;

procedure TCustomECLightView.KeyDown(var Key: Word; Shift: TShiftState);

  procedure DoKeyDown(AScrollStep: Integer; AMoveUp: Boolean);
  var aCAT, aNewCAT: Integer;
  begin
    aCAT:=ClientAreaTop;
    if AMoveUp
      then aNewCAT:=Math.max(aCAT-AScrollStep, 0)
      else aNewCAT:=Math.min(aCAT+AScrollStep, FullAreaHeight-ClientHeight);
    if aNewCAT<>aCAT then
      begin
        Flags:=Flags+[elfRedraw];
        ClientAreaTop:=aNewCAT;
      end;
    Key:=0;
  end;

begin
  inherited KeyDown(Key, Shift);
  if Shift*[ssShift, ssAlt, ssCtrl]=[] then
    case Key of
      VK_PRIOR: DoKeyDown(ClientHeight, True);
      VK_NEXT:  DoKeyDown(ClientHeight, False);
      VK_END:   DoKeyDown(FullAreaHeight, False);
      VK_HOME:  DoKeyDown(FullAreaHeight, True);
      VK_UP:    DoKeyDown(DefLineHeight, True);
      VK_DOWN:  DoKeyDown(DefLineHeight, False);
    end;
end;

procedure TCustomECLightView.LayoutBlocks;
var aCharSize, aLeft, aLeftLimit, aMaxBottom, aMaxRight, aTextWidth: Integer;
    aCurGlyphAlign: TAlignment;
    aCurP, aEndP: PChar;
    aLine: LongWord;

  procedure AlignLineLF(AElIndex, ABlkIndex: Integer; AShiftHor: SmallInt);
  var bAlignHor, bShiftHor, bLastInLineChecked: Boolean;
      i, j, aShiftVert: Integer;
  begin
    bAlignHor:=(cBiDiAlign[Elements[AElIndex].Alignment, BiDiMode<>bdLeftToRight]<>taLeftJustify);
    bShiftHor:=((aCurGlyphAlign=taRightJustify) and (aLeftLimit>Indent));
    if Elements[AElIndex].Alignment=taCenter then AShiftHor:=AShiftHor div 2;
    i:=AElIndex;
    j:=ABlkIndex;
    bLastInLineChecked:=False;
    while i>=0 do
      begin
        while j>=0 do
          begin
            if Elements[i].Blocks[j].LogicLine<>aLine then
              begin
                inc(aLine);
                exit;  { Exit! }
              end;
            if not bLastInLineChecked then
              begin
                if (PChar(WorkText)+Elements[i].Blocks[j].TextStart+Elements[i].Blocks[j].TextLength-2)^=#32 then
                  begin
                    dec(Elements[i].Blocks[j].TextLength);
                    dec(Elements[i].Blocks[j].Pos.Right, Elements[i].SpaceWidth);
                    case cBiDiAlign[Elements[AElIndex].Alignment, BiDiMode<>bdLeftToRight] of
                      taRightJustify: inc(AShiftHor, Elements[i].SpaceWidth);
                      taCenter:       inc(AShiftHor, Elements[i].SpaceWidth div 2 +1);
                    end;
                  end;
                bLastInLineChecked:=True;
              end;
            if bAlignHor then
              begin
                inc(Elements[i].Blocks[j].Pos.Right, AShiftHor);
                inc(Elements[i].Blocks[j].Pos.Left, AShiftHor);
              end;
            if bShiftHor then
              begin
                dec(Elements[i].Blocks[j].Pos.Right, aLeftLimit-Indent);
                dec(Elements[i].Blocks[j].Pos.Left, aLeftLimit-Indent);
              end;
            aShiftVert:=(aMaxBottom-Elements[i].Blocks[j].Pos.Bottom+1) div 2;
            inc(Elements[i].Blocks[j].Pos.Top, aShiftVert);
            inc(Elements[i].Blocks[j].Pos.Bottom, aShiftVert);
            dec(j);
          end;
        dec(i);
        if i>=0 then j:=Elements[i].BlockCount-1;
      end;
    inc(aLine);
  end;

  function TryAppendToCurrentLine(AMonoSpace: Boolean): Boolean;
  var aLastGood, aStartP: PChar;
      aLastWidth, aSpaceCnt: Integer;
  begin
    Result:=True;
    aStartP:=aCurP;
    aSpaceCnt:=0;
    while aCurP<aEndP do
      begin
        aCharSize:=UTF8CodepointSize(aCurP);
        if (aCharSize=1) and (aCurP^=#32) then
          begin  { search for spaces }
            if not AMonoSpace
              then aTextWidth:=BMP.Canvas.TextWidth(Copy(WorkText, aStartP-PChar(WorkText)+1, aCurP-aStartP+1))
              else aTextWidth:=UTF8Length(aStartP, aCurP-aStartP+1)*BMP.Canvas.TextWidth('W');
            if aTextWidth<=(aMaxRight-aLeft) then
              begin  { text fits }
                if aCurP=(aEndP-1) then  { the last char, and it is space }
                  begin
                    inc(aCurP);
                    exit;  { Exit! }
                  end;
                aLastGood:=aCurP;
                aLastWidth:=aTextWidth;
              end else
              begin  { text does NOT fit }
                Result:=(aSpaceCnt>0);
                if Result then
                  begin  { previous space fitted }
                    aTextWidth:=aLastWidth;
                    aCurP:=aLastGood;
                  end;
                inc(aCurP);
                exit;  { Exit! }
              end;
            inc(aSpaceCnt);
          end;
        inc(aCurP, aCharSize);
      end;
    if not AMonoSpace
      then aTextWidth:=BMP.Canvas.TextWidth(Copy(WorkText, aStartP-PChar(WorkText)+1, aEndP-aStartP))
      else aTextWidth:=UTF8Length(aStartP, aEndP-aStartP)*BMP.Canvas.TextWidth('W');
    if aTextWidth>(aMaxRight-aLeft) then
      if aSpaceCnt>0 then  { whole text does NOT fit }
        begin              { but previous space did }
          aCurP:=aLastGood;
          aTextWidth:=aLastWidth;
          inc(aCurP);
        end else
          Result:=False;
  end;

var aLineHeight: SmallInt;
    y, yLimit: Integer;

  procedure ResolveLineEnd(AElIndex, ABlkIndex: Integer);
  begin
    AlignLineLF(AElIndex, ABlkIndex, aMaxRight-aLeft);
    inc(y, aLineHeight);
    aLineHeight:=0;
    if y>=yLimit then
      begin
        aLeftLimit:=Indent;
        aCurGlyphAlign:=taLeftJustify;
      end;
    aLeft:=aLeftLimit;
  end;

var i, aBlkCnt: Integer;

  procedure SetImageLimits;
  begin
    y:=Math.max(y+aLineHeight, yLimit);
    Elements[i].TextStart:=y+DefLineHeight3;
    aCurGlyphAlign:=Elements[i].GlyphAlign;
    if aCurGlyphAlign<>taCenter then
      begin
        yLimit:=y+Elements[i].Height;
        inc(aLeftLimit, Indent+DefFontHeight div 2);
      end else
      begin
        inc(y, Elements[i].Height);
        aLeftLimit:=Indent;
      end;
    aLeft:=aLeftLimit;
    aLineHeight:=0;
  end;

var aStartBlkP: PChar;
    aStretchRatio: Single;
begin
  {$IFDEF DBGVIEW} DebugLn({$I %CURRENTROUTINE%}); {$ENDIF}
  BMP.Canvas.Font.Assign(Font);
  aMaxBottom:=0;
  aMaxRight:=ClientWidth-Indent;
  aLeft:=Indent;
  aLeftLimit:=aLeft;
  aCurGlyphAlign:=taLeftJustify;
  aLine:=0;
  aLineHeight:=0;
  y:=Indent;
  yLimit:=0;
  aTextWidth:=0;
  for i:=0 to ElementsCount-1 do
    begin
      aBlkCnt:=0;
      if Elements[i].Tag in ['C', 'L', 'N', 'R'] then
        begin  { centered text, left-aligned text, new line, right aligned text }
          ResolveLineEnd(i-1, Elements[i-1].BlockCount-1);
          if (Elements[i].Tag='N') and ((i<=high(Elements)) or (Elements[i+1].Tag='N'))
            then aLineHeight:=DefFontHeight;
        end else
          if Elements[i].Tag='V' then
            begin  { new line below image }
              AlignLineLF(i-1, Elements[i-1].BlockCount-1, aMaxRight-aLeft);
              aLeftLimit:=Indent;
              aLeft:=aLeftLimit;
              y:=Math.max(y+aLineHeight, yLimit);
              aLineHeight:=0;
            end;
      if (Elements[i].Tag in cTextTags) and (Elements[i].TextLength>0) then
        begin
          BMP.Canvas.Font.Height:=DefFontHeight+Elements[i].FontHeight;
          BMP.Canvas.Font.Style:=Elements[i].FontStyles;
          Elements[i].Height:=BMP.Canvas.TextHeight('Šj');
          Elements[i].SpaceWidth:=BMP.Canvas.TextWidth(#32);
          aLineHeight:=Math.max(aLineHeight, Elements[i].Height);
          if length(Elements[i].Blocks)<cBaseSize then SetLength(Elements[i].Blocks, cBaseSize);
          aCurP:=PChar(WorkText)+Elements[i].TextStart-1;
          aEndP:=aCurP+Elements[i].TextLength;
          Elements[i].Blocks[0].TextStart:=Elements[i].TextStart;
          while aCurP<aEndP do
            begin
              aStartBlkP:=aCurP;
              if not TryAppendToCurrentLine(elefMonoSpace in Elements[i].Flags) then
                begin  { cannot append even a single word }
                  if aLeft>aLeftLimit then
                    begin  { cannot continue on opened line }
                      ResolveLineEnd(i, aBlkCnt-1);
                      aCurP:=aStartBlkP;
                      TryAppendToCurrentLine(elefMonoSpace in Elements[i].Flags);
                      aLineHeight:=Elements[i].Height;
                    end else
                      if aLeftLimit>Indent then
                        begin  { it is on the beginning of a line by an image }
                          AlignLineLF(i, aBlkCnt-1, aMaxRight-aLeft);
                          aLeftLimit:=Indent;
                          aLeft:=aLeftLimit;
                          y:=yLimit;
                          aCurP:=aStartBlkP;
                          TryAppendToCurrentLine(elefMonoSpace in Elements[i].Flags);
                          aLineHeight:=Elements[i].Height;
                        end;
                end;
              if length(Elements[i].Blocks)<=aBlkCnt
                then SetLength(Elements[i].Blocks, cBaseSize*(aBlkCnt div cBaseSize +1));
              Elements[i].Blocks[aBlkCnt].LogicLine:=aLine;
              Elements[i].Blocks[aBlkCnt].TextStart:=aStartBlkP-PChar(WorkText)+1;
              Elements[i].Blocks[aBlkCnt].TextLength:=aCurP-aStartBlkP;
              Elements[i].Blocks[aBlkCnt].Pos:=Rect(aLeft, y, aLeft+aTextWidth, y+Elements[i].Height);
              aMaxBottom:=Math.max(aMaxBottom, Elements[i].Blocks[aBlkCnt].Pos.Bottom);
              inc(aLeft, aTextWidth);
              inc(aBlkCnt);
            end;
        end else
        case Elements[i].Tag of
          'G':  { image from Images }
            if assigned(Images) then
              begin
                AlignLineLF(i-1, Elements[i-1].BlockCount-1, aMaxRight-aLeft);
                Elements[i].Height:=Images.HeightForWidth[Math.max(Images.Width, ImageWidth)]+2*DefLineHeight3;
                aLeftLimit:=Math.max(Images.Width, ImageWidth);
                SetImageLimits;
              end;
          'O':  { horizontal line }
            begin
              ResolveLineEnd(i-1, Elements[i-1].BlockCount-1);
              if aCurGlyphAlign<>taRightJustify
                then Elements[i].TextLength:=aLeft
                else Elements[i].TextLength:=-aLeft;
              Elements[i].TextStart:=y+DefLineHeight3 +Elements[i].Value div 2;
              Elements[i].Height:=2*DefLineHeight3 +Elements[i].Value;
              inc(y, Elements[i].Height);
            end;
          'W':  { image from resources }
            begin
              AlignLineLF(i-1, Elements[i-1].BlockCount-1, aMaxRight-aLeft);
              aLeftLimit:=PNGs[Elements[i].Value].Width;
              Elements[i].TextLength:=PNGs[Elements[i].Value].Width;
              Elements[i].Height:=PNGs[Elements[i].Value].Height;
              if elefStrechtDraw in Elements[i].Flags then
                begin
                  aStretchRatio:=Math.min(1.0, (ClientWidth-2*Indent)/aLeftLimit);
                  aLeftLimit:=Math.min(aLeftLimit, ClientWidth-2*Indent);
                  Elements[i].Height:=round(Elements[i].Height*aStretchRatio);
                  Elements[i].TextLength:=aLeftLimit;
                end;
              inc(Elements[i].Height, 2*DefLineHeight3);
              SetImageLimits;
            end;
          'X':  { image from file }
            begin
              AlignLineLF(i-1, Elements[i-1].BlockCount-1, aMaxRight-aLeft);
              if elefImgJPEG in Elements[i].Flags then
                begin
                  aLeftLimit:=JPGs[Elements[i].Value].Width;
                  Elements[i].TextLength:=JPGs[Elements[i].Value].Width;
                  Elements[i].Height:=JPGs[Elements[i].Value].Height;
                end else
                  if elefImgPNG in Elements[i].Flags then
                    begin
                      aLeftLimit:=PNGs[Elements[i].Value].Width;
                      Elements[i].TextLength:=PNGs[Elements[i].Value].Width;
                      Elements[i].Height:=PNGs[Elements[i].Value].Height;
                    end else
                      if elefImgBMP in Elements[i].Flags then
                        begin
                          aLeftLimit:=BMPs[Elements[i].Value].Width;
                          Elements[i].TextLength:=BMPs[Elements[i].Value].Width;
                          Elements[i].Height:=BMPs[Elements[i].Value].Height;
                        end;
              if elefStrechtDraw in Elements[i].Flags then
                begin
                  aStretchRatio:=Math.min(1.0, (ClientWidth-2*Indent)/aLeftLimit);
                  aLeftLimit:=Math.min(aLeftLimit, ClientWidth-2*Indent);
                  Elements[i].Height:=round(Elements[i].Height*aStretchRatio);
                  Elements[i].TextLength:=aLeftLimit;
                end;
              inc(Elements[i].Height, 2*DefLineHeight3);
              SetImageLimits;
            end;
        end;  {case}
      Elements[i].BlockCount:=aBlkCnt;
    end;
  if ElementsCount>0 then AlignLineLF(ElementsCount-1, aBlkCnt-1, aMaxRight-aLeft);
  FRequiredArea.Y:=Math.max(yLimit, y+aLineHeight)+Indent;
  FScrollInfoVert.nMin:=0;
  FScrollInfoVert.nMax:=FullAreaHeight;
  FScrollInfoVert.nPage:=ClientHeight;
  UpdateScrollBars;
  UpdateRequiredAreaHeight;
end;

procedure TCustomECLightView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  PushedElement:=HoveredElement;
end;

procedure TCustomECLightView.MouseMove(Shift: TShiftState; X, Y: Integer);
var aRect: TRect;
    i, j: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  if IsEnabled then
    for i:=FirstVisiEl to LastVisiEl do
      if (Elements[i].Tag in cLinkTags) and (elefOpenTag in Elements[i].Flags) then
        for j:=0 to Elements[i].BlockCount-1 do
          begin
            aRect:=Elements[i].Blocks[j].Pos;
            dec(aRect.Top, ClientAreaTop);
            dec(aRect.Bottom, ClientAreaTop);
            if PtInRect(aRect, Point(X, Y)) then
              begin
                HoveredElement:=i;
                exit;  { Exit! }
              end;
          end;
  HoveredElement:=-1;
end;

procedure TCustomECLightView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var aIndex: Integer;
    aStr: string;
begin
  inherited MouseUp(Button, Shift, X, Y);
  aIndex:=PushedElement;
  if (aIndex>=0) and (aIndex=HoveredElement) then
    case Elements[aIndex].Tag of
      'A', 'E':  { URL, mailto }
        begin
          aStr:=Copy(WorkText, Elements[aIndex].Blocks[0].TextStart, Elements[aIndex].Blocks[0].TextLength);
          if Elements[aIndex].Tag='E' then aStr:='mailto:'+aStr;
          OpenURL(aStr);
          include(Elements[aIndex].Flags, elefVisited);
        end;
      'Y':  { interlink }
        begin
          if (elefOpenTag in Elements[aIndex].Flags) and assigned(OnInterLinkClick)
            then OnInterLinkClick(self, Elements[aIndex].Value);
          include(Elements[aIndex].Flags, elefVisited);
        end;
    end;
end;

procedure TCustomECLightView.Paint;
var aCW: Integer;
begin
  case IsEnabled of
    False: if elfWasEnabled in Flags then Flags:=Flags+[elfRedrawAll]-[elfWasEnabled];
    True:  if not (elfWasEnabled in Flags) then Flags:=Flags+[elfRedrawAll, elfWasEnabled];
  end;
  if elfParse in Flags then ParseElements;
  if elfLayoutBlocks in Flags then
    begin
      aCW:=ClientWidth;
      LayoutBlocks;
      if aCW<>ClientWidth then
        begin  { happens when vert. scrollbar is added and ClientWidth is decreased consequently }
          LayoutBlocks;
          include(Flags, elfResize);
        end;
      include(Flags, elfRedrawAll);
    end;
  if elfResize in Flags then BMP.SetSize(ClientWidth, ClientHeight);
  if Flags*[elfRedraw, elfRedrawAll]<>[] then Draw;
  Flags:=Flags-[elfLayoutBlocks, elfParse, elfRedraw, elfRedrawAll, elfResize];
  Canvas.Draw(0, 0, BMP);
  inherited Paint;
end;

procedure TCustomECLightView.ParseElements;
const cPairTags = ['B', 'D', 'H', 'I', 'M', 'P', 'S', 'T', 'U', 'Y'];
    { cNonPairTags = ['A', 'C', 'E'..'G', 'J'..'L', 'N', 'O', 'Q', 'R', 'V', 'W', 'X', 'Z']; }
      cClrParamTags = ['H', 'T'];
      cIntParamTags = ['F', 'G', 'O', 'Y'];
      cStrParamTags = ['A', 'E', 'W', 'X'];
      cZBlockNeeded = ['A', 'E', 'G', 'O', 'W', 'X'];
var aCharSize, aElCount, aOpenedPairs: Integer;
    aCurP, aEndP, aWTCurP: PChar;

  procedure GetParameter(AIndex: Integer; ATag: Char);

    function GetNextASCIIChar: Char;
    begin
      while aCurP<aEndP do
        begin
          aCharSize:=UTF8CodepointSize(aCurP);
          inc(aCurP, aCharSize);
          if aCharSize=1 then break;
        end;
      Result:=(aCurP-1)^;
    end;

    function FindNextASCIIChar(ACharacter: Char): PtrInt;
    begin
      while aCurP<aEndP do
        begin
          aCharSize:=UTF8CodepointSize(aCurP);
          inc(aCurP, aCharSize);
          if (aCharSize=1) and ((aCurP-1)^=ACharacter) then break;
        end;
      Result:=aCurP-PChar(TextData);
    end;

  var aColor: TColor;
      aFrom, aTo: PtrInt;
      aNumeric: Char;
      b: Boolean;
      i: Integer;
  begin
    if ATag in cClrParamTags then
      begin
        aFrom:=FindNextASCIIChar('$');
        b:=tryStrToInt(Copy(TextData, aFrom, 7), aColor);
        case ATag of
          'H': if b  { text background color }
                 then Elements[AIndex].BackColor:=aColor
                 else Elements[AIndex].BackColor:=Elements[0].BackColor;
          'T': if b  { font color }
                 then Elements[AIndex].FontColor:=aColor
                 else Elements[AIndex].FontColor:=Elements[0].FontColor;
        end;
        inc(aCurP, 5);
      end else
        if ATag in cIntParamTags then
          begin
            repeat
              aNumeric:=GetNextASCIIChar;
            until aNumeric in ['0'..'9', '-'];
            aFrom:=aCurP-PChar(TextData);
            repeat
              aNumeric:=GetNextASCIIChar;
            until not (aNumeric in ['0'..'9']);
            aTo:=aCurP-PChar(TextData);
            if not tryStrToInt(Copy(TextData, aFrom, aTo-aFrom), i) then i:=0;
            case ATag of
              'F':           Elements[AIndex].FontHeight:=i;
              'G', 'O', 'Y': Elements[AIndex].Value:=i;
            end;
            dec(aCurP, 2);
          end else
            if ATag in cStrParamTags then
              begin
                aFrom:=FindNextASCIIChar('"')+1;
                aTo:=FindNextASCIIChar('"');
                dec(aCurP);
                i:=aTo-aFrom;
                Move((aCurP-i)^, aWTCurP^, i);
                Elements[AIndex].TextStart:=aWTCurP-PChar(WorkText)+1;
                Elements[AIndex].TextLength:=i;
                inc(aWTCurP, i);
              end;
  end;

  function IsOpenedPairTag(ALastIndex: Integer; ATag: Char): Boolean;
  var i, aOpened: Integer;
  begin
    Result:=False;
    aOpened:=aOpenedPairs;
    for i:=ALastIndex downto 1 do
      if Elements[i].Tag in cPairTags then
        if elefOpenTag in Elements[i].Flags then
          begin
            if Elements[i].Tag=ATag then
              begin
                Result:=True;
                break;
              end else
              begin
                dec(aOpened);
                if aOpened=0 then break;
              end;
          end else
            if Elements[i].Tag=ATag
              then break  { indicates wrong format of WorkText, checking is beyond scope of this simple component }
              else inc(aOpened);
  end;

  var aTagCounter: Integer;

  function NewElement(ATag: Char): Integer;
  begin
    Result:=aElCount;
    inc(aElCount);
    if ATag<>'Z' then inc(aTagCounter);
    if length(Elements)<aElCount then SetLength(Elements, cBaseSize*(aElCount div cBaseSize +1));
    Elements[Result].BackColor:=Elements[Result-1].BackColor;
    Elements[Result].FontColor:=Elements[Result-1].FontColor;
    Elements[Result].FontHeight:=Elements[Result-1].FontHeight;
    Elements[Result].FontStyles:=Elements[Result-1].FontStyles;
    if elefMonoSpace in Elements[Result-1].Flags
      then include(Elements[Result].Flags, elefMonoSpace)
      else exclude(Elements[Result].Flags, elefMonoSpace);
    if elefStrechtDraw in Elements[Result-1].Flags
      then include(Elements[Result].Flags, elefStrechtDraw)
      else exclude(Elements[Result].Flags, elefStrechtDraw);
    Elements[Result].Alignment:=Elements[Result-1].Alignment;
    Elements[Result].GlyphAlign:=Elements[Result-1].GlyphAlign;
    Elements[Result].Tag:=ATag;
  end;

var aChar: Char;
    aIndex: Integer;
    aPath: string;
    aTagFlag: Boolean;
begin
  {$IFDEF DBGVIEW} DebugLn({$I %CURRENTROUTINE%}); {$ENDIF}
  FreeImages;
  aTagCounter:=0;
  if length(Elements)<cBaseSize then SetLength(Elements, cBaseSize);
  BMP.Canvas.Font.Assign(Font);
  BMP.Canvas.Font.Height:=0;
  DefLineHeight:=BMP.Canvas.TextHeight('Šj');
  DefLineHeight3:=DefLineHeight div 3;
  DefFontHeight:=BMP.GetDefaultFontHeight;
  BMP.Canvas.Font.Height:=DefFontHeight;
  if Font.Height<>0 then DefFontHeight:=abs(Font.Height);
  Elements[0].BackColor:=GetColorResolvingDefault(Color, clWindow);
  Elements[0].FontColor:=GetColorResolvingDefault(Font.Color, clWindowText);
  Elements[0].FontHeight:=0;
  Elements[0].FontStyles:=Font.Style;
  Elements[0].Tag:='F';
  Elements[0].TextStart:=1;
  Elements[0].Value:=0;
  aElCount:=1;  { elements 0 is fixed default }
  aOpenedPairs:=0;
  aTagFlag:=False;
  aCurP:=PChar(TextData);
  aEndP:=aCurP+length(TextData);
  SetLength(WorkText, aEndP-aCurP);
  aWTCurP:=PChar(WorkText);
  while aCurP<aEndP do
    begin
      aCharSize:=UTF8CodepointSize(aCurP);
      if aCharSize=1 then
        begin
          aChar:=UpCase(aCurP^);
          case aChar of
            #09: begin  { Tab to double-space }
                   aWTCurP^:=#32;
                   inc(aWTCurP);
                   aWTCurP^:=#32;
                   inc(aWTCurP);
                 end;
            #10: if IsOpenedPairTag(aElCount-1, 'P') then
                   begin  { LF to new line (N) if inside preformatted text (P) }
                     Elements[aElCount-1].TextLength:=Integer(aWTCurP-PChar(WorkText)-Elements[aElCount-1].TextStart+1);
                     aIndex:=NewElement('N');
                     dec(aTagCounter);
                     Elements[aIndex].TextStart:=Integer(aWTCurP-PChar(WorkText)+1);
                   end else
                     if (aCurP>PChar(TextData)) and ((aCurP-1)^<>'\') then
                       begin  { LF to space }
                         aWTCurP^:=#32;
                         inc(aWTCurP);
                       end;
            #13: ;  { ignore CR }
            otherwise
              aWTCurP^:=aCurP^;
              inc(aWTCurP);
          end;
          if aTagFlag and (aChar in ['A'..'Z']) then
            begin
              dec(aWTCurP, 2);
              Elements[aElCount-1].TextLength:=Integer(aWTCurP-PChar(WorkText)-Elements[aElCount-1].TextStart)+1;
              if aChar in cPairTags then
                begin
                  aIndex:=NewElement(aChar);
                  if (aOpenedPairs>0) and IsOpenedPairTag(aIndex-1, aChar) then
                    begin
                      dec(aOpenedPairs);
                      exclude(Elements[aIndex].Flags, elefOpenTag);
                      case aChar of
                        'B': if not (fsBold in Elements[0].FontStyles) then exclude(Elements[aIndex].FontStyles, fsBold);
                        'D': exclude(Elements[aIndex].Flags, elefStrechtDraw);
                        'H': Elements[aIndex].BackColor:=Elements[0].BackColor;
                        'I': if not (fsItalic in Elements[0].FontStyles) then exclude(Elements[aIndex].FontStyles, fsItalic);
                        'M': exclude(Elements[aIndex].Flags, elefMonoSpace);
                        'S': if not (fsStrikeOut in Elements[0].FontStyles) then exclude(Elements[aIndex].FontStyles, fsStrikeOut);
                        'T': Elements[aIndex].FontColor:=Elements[0].FontColor;
                        'U': if not (fsUnderline in Elements[0].FontStyles) then exclude(Elements[aIndex].FontStyles, fsUnderline);
                        'Y': begin  { interlink }
                               Elements[aIndex].FontColor:=Elements[aIndex-2].FontColor;
                               if not (fsUnderline in Elements[aIndex-2].FontStyles)
                                 then exclude(Elements[aIndex].FontStyles, fsUnderline);
                             end;
                      end;
                    end else
                    begin
                      inc(aOpenedPairs);
                      include(Elements[aIndex].Flags, elefOpenTag);
                      GetParameter(aIndex, aChar);
                      case aChar of
                        'B': include(Elements[aIndex].FontStyles, fsBold);
                        'D': include(Elements[aIndex].Flags, elefStrechtDraw);
                        'I': include(Elements[aIndex].FontStyles, fsItalic);
                        'M': include(Elements[aIndex].Flags, elefMonoSpace);
                        'S': include(Elements[aIndex].FontStyles, fsStrikeOut);
                        'U',
                        'Y': include(Elements[aIndex].FontStyles, fsUnderline);
                      end;
                    end;
                  if Elements[aIndex].Tag in cZBlockNeeded then aIndex:=NewElement('Z');
                  Elements[aIndex].TextStart:=aWTCurP-PChar(WorkText)+1;
                end else
                begin
                  aIndex:=NewElement(aChar);
                  include(Elements[aIndex].Flags, elefOpenTag);
                  GetParameter(aIndex, aChar);
                  if (csDesigning in ComponentState) and (aChar in ['G', 'W', 'X']) then
                    begin
                      aChar:='V';
                      Elements[aIndex].Tag:='V';
                    end;
                  case aChar of
                    'A', 'E': include(Elements[aIndex].FontStyles, fsUnderline);
                    'C': Elements[aIndex].Alignment:=taCenter;
                    'J': Elements[aIndex].GlyphAlign:=taLeftJustify;
                    'K': Elements[aIndex].GlyphAlign:=taRightJustify;
                    'L': Elements[aIndex].Alignment:=taLeftJustify;
                    'Q': Elements[aIndex].GlyphAlign:=taCenter;
                    'R': Elements[aIndex].Alignment:=taRightJustify;
                    'W':  { image from resources }
                      begin
                        Elements[aIndex].Value:=length(PNGs);
                        SetLength(PNGs, length(PNGs)+1);
                        PNGs[Elements[aIndex].Value]:=TPortableNetworkGraphic.Create;
                        aPath:=Copy(WorkText, Elements[aIndex].TextStart, Elements[aIndex].TextLength);
                        try
                          PNGs[Elements[aIndex].Value].LoadFromLazarusResource(aPath);
                        except
                          DebugLn('TCustomECLightView: Cannot load from resources: ', aPath);
                        end;
                      end;
                    'X':  { image from file }
                      begin
                        aPath:=AppendPathDelim(PathToPictures)+Copy(WorkText,
                          Elements[aIndex].TextStart, Elements[aIndex].TextLength);
                        if FileExistsUTF8(aPath) then
                          begin
                            try
                              if (CompareFileExt(aPath, 'jpg')=0) or (CompareFileExt(aPath, 'jpeg')=0) then
                                begin
                                  include(Elements[aIndex].Flags, elefImgJPEG);
                                  Elements[aIndex].Value:=length(JPGs);
                                  SetLength(JPGs, length(JPGs)+1);
                                  JPGs[Elements[aIndex].Value]:=TJPEGImage.Create;
                                  JPGs[Elements[aIndex].Value].LoadFromFile(aPath);
                                end else
                                  if CompareFileExt(aPath, 'png')=0 then
                                    begin
                                      include(Elements[aIndex].Flags, elefImgPNG);
                                      Elements[aIndex].Value:=length(PNGs);
                                      SetLength(PNGs, length(PNGs)+1);
                                      PNGs[Elements[aIndex].Value]:=TPortableNetworkGraphic.Create;
                                      PNGs[Elements[aIndex].Value].LoadFromFile(aPath);
                                    end else
                                      if comparefileext(apath, 'bmp')=0 then
                                        begin
                                          include(elements[aindex].flags, elefimgbmp);
                                          elements[aindex].value:=length(bmps);
                                          setlength(bmps, length(bmps)+1);
                                          bmps[elements[aindex].value]:=tbitmap.create;
                                          bmps[elements[aindex].value].loadfromfile(apath);
                                        end;
                            except
                              DebugLn('TCustomECLightView: Cannot open ', aPath);
                            end;
                          end else
                            DebugLn('TCustomECLightView: File not exists: ', aPath);
                      end;
                  end;  {case}
                  if aChar in cZBlockNeeded then
                    begin
                      aIndex:=NewElement('Z');
                      case aChar of
                        'A', 'E':  { URL, mailto }
                          begin
                            Elements[aIndex].FontColor:=Elements[aIndex-2].FontColor;
                            if not (fsUnderline in Elements[aIndex-2].FontStyles)
                              then exclude(Elements[aIndex].FontStyles, fsUnderline);
                          end;
                      end;
                    end;
                  Elements[aIndex].TextStart:=aWTCurP-PChar(WorkText)+1;
                end;
              inc(aCurP, aCharSize);
              aCharSize:=UTF8CodepointSize(aCurP);
              aChar:=aCurP^;
              if aChar<>'\'
                then DebugLn(['TCustomECLightView: ', Format('Tag %s|%d not closed.',
                       [Elements[aIndex].Tag, aTagCounter])])
                else aChar:='*';
            end;
          aTagFlag:=(aChar='%');
        end else
        begin
          aTagFlag:=False;
          Move(aCurP^, aWTCurP^, aCharSize);
          inc(aWTCurP, aCharSize);
        end;
      inc(aCurP, aCharSize);
    end;
  Elements[aElCount-1].TextLength:=Integer(aWTCurP-PChar(WorkText)-Elements[aElCount-1].TextStart+1);
  SetLength(WorkText, aWTCurP-PChar(WorkText));
  ElementsCount:=aElCount;
  if aOpenedPairs<>0 then
    DebugLn(['TCustomECLightView: ',
      Format('Wrong TextData format. %d tag(s) remain(s) opened.', [aOpenedPairs])]);
  {$IFDEF DBGVIEW} DebugLn(WorkText); {$ENDIF}
end;

procedure TCustomECLightView.RedrawLink(AIndex: Integer; AHovered: Boolean);
var j: Integer;
begin
  BMP.Canvas.Font.Color:=GetLinkColor(elefVisited in Elements[AIndex].Flags, AHovered);
  BMP.Canvas.Font.Height:=DefFontHeight+Elements[AIndex].FontHeight;
  BMP.Canvas.Font.Style:=Elements[AIndex].FontStyles;
  BMP.Canvas.Brush.Color:=Elements[AIndex].BackColor;
  BMP.Canvas.Clipping:=False;
  for j:=0 to Elements[AIndex].BlockCount-1 do
    with Elements[AIndex].Blocks[j] do
      BMP.Canvas.TextOut(Pos.Left, Pos.Top-ClientAreaTop, Copy(WorkText, TextStart, TextLength));
end;

procedure TCustomECLightView.SetCursor(Value: TCursor);
begin
  inherited SetCursor(Value);
  if not (elfLockCursor in Flags) then DefCursor:=Value;
end;

procedure TCustomECLightView.UpdateRequiredAreaHeight;
begin
  if (ClientAreaTop+ClientHeight)>FullAreaHeight then ClientAreaTop:=FRequiredArea.Y-ClientHeight;
  UpdateScrollInfoVert;
end;

procedure TCustomECLightView.UpdateRequiredAreaWidth;
begin
  FRequiredArea.X:=ClientWidth;
  UpdateScrollInfoHor;
end;

procedure TCustomECLightView.WMSize(var Message: TLMSize);
begin
  if (PrevClientSize.cx<>ClientWidth) or (PrevClientSize.cy<>ClientHeight)
    then Flags:=Flags+[elfLayoutBlocks, elfResize];
  PrevClientSize:=Size(ClientWidth, ClientHeight);
end;

procedure TCustomECLightView.WMVScroll(var Msg: TWMScroll);
begin
  inherited WMVScroll(Msg);
  if PrevClientAreaTop<>ClientAreaTop then include(Flags, elfRedraw);
end;

{ TCustomECLightView.G/Setters }

procedure TCustomECLightView.SetColorLink(AValue: TColor);
begin
  if FColorLink=AValue then exit;
  FColorLink:=AValue;
  include(Flags, elfRedrawAll);
  Invalidate;
end;

procedure TCustomECLightView.SetColorVisited(AValue: TColor);
begin
  if FColorVisited=AValue then exit;
  FColorVisited:=AValue;
  include(Flags, elfRedrawAll);
  Invalidate;
end;

procedure TCustomECLightView.SetHoveredElement(AValue: Integer);
begin
  if FHoveredElement=AValue then exit;
  include(Flags, elfLockCursor);
  if AValue>=0
    then Cursor:=crHandPoint
    else Cursor:=DefCursor;
  exclude(Flags, elfLockCursor);
  if FHoveredElement>=0 then RedrawLink(FHoveredElement, False);
  FHoveredElement:=AValue;
  if AValue>=0 then RedrawLink(AValue, True);
  Invalidate;
end;

procedure TCustomECLightView.SetImages(AValue: TCustomImageList);
begin
  if FImages=AValue then exit;
  FImages:=AValue;
  Flags:=Flags+[elfLayoutBlocks];
  Invalidate;
end;

procedure TCustomECLightView.SetImageWidth(AValue: SmallInt);
begin
  if FImageWidth=AValue then exit;
  FImageWidth:=AValue;
  Flags:=Flags+[elfLayoutBlocks];
  Invalidate;
end;

procedure TCustomECLightView.SetIndent(AValue: SmallInt);
begin
  if FIndent=AValue then exit;
  FIndent:=AValue;
  Flags:=Flags+[elfLayoutBlocks];
  Invalidate;
end;

procedure TCustomECLightView.SetPathToPictures(AValue: string);
begin
  if FPathToPictures=AValue then exit;
  FPathToPictures:=AValue;
  Flags:=Flags+[elfLayoutBlocks];
  Invalidate;
end;

procedure TCustomECLightView.SetTextData(AValue: string);
begin
  if FTextData=AValue then exit;
  FTextData:=AValue;
  Flags:=Flags+[elfLayoutBlocks, elfParse];
  Invalidate;
end;

end.


