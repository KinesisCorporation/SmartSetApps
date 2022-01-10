unit LabelBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, lcltype, LCLIntf, BGRABitmap, BGRABitmapTypes;

type

  TLabelShape = (lsRectangle, lsQuad);

  { TLabelBox }

  TLabelBox = class(TLabel)
  private
    { Private declarations }
    FBorderColor: TColor;
    FBackColor: TColor;
    FNextColor: TColor;
    FIndex: integer;
    FCornerSize: integer;
    FBorderStyle: TBorderStyle;
    FBorderWidth: integer;
    FOpaque: boolean;
    FTransparency: integer;
    FLabelShape: TLabelShape;
    FGradientFill: boolean;
    FBitmap: TBitmap;
    FShapeX1: integer;
    FShapeY1: integer;
    FShapeX2: integer;
    FShapeY2: integer;
    FShapeX3: integer;
    FShapeY3: integer;
    FShapeX4: integer;
    FShapeY4: integer;
    FNumberOfDots: integer;
    procedure DrawOpacityBrush(ACanvas: TCanvas; X, Y: Integer; AColor: TColor;
      ASize: Integer; Opacity: Byte);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
  published
    { Published declarations }
    property BorderStyle: TBorderStyle read FBorderStyle write FBorderStyle default bsNone;
    property BorderColor: TColor read FBorderColor write FBorderColor;
    property BackColor: TColor read FBackColor write FBackColor default clNone;
    property NextColor: TColor read FNextColor write FNextColor default clNone;
    property Index: integer read FIndex write FIndex default -1;
    property CornerSize: integer read FCornerSize write FCornerSize default 0;
    property BorderWidth: integer read FBorderWidth write FBorderWidth default 1;
    property Opaque: boolean read FOpaque write FOpaque default true;
    property Transparency: integer read FTransparency write FTransparency default 0;
    property GradientFill: boolean read FGradientFill write FGradientFill default false;
    property LabelShape: TLabelShape read FLabelShape write FLabelShape default lsRectangle;
    property ShapeX1: integer read FShapeX1 write FShapeX1 default 0;
    property ShapeY1: integer read FShapeY1 write FShapeY1 default 0;
    property ShapeX2: integer read FShapeX2 write FShapeX2 default 0;
    property ShapeY2: integer read FShapeY2 write FShapeY2 default 0;
    property ShapeX3: integer read FShapeX3 write FShapeX3 default 0;
    property ShapeY3: integer read FShapeY3 write FShapeY3 default 0;
    property ShapeX4: integer read FShapeX4 write FShapeX4 default 0;
    property ShapeY4: integer read FShapeY4 write FShapeY4 default 0;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    property NumberOfDots: integer read FNumberOfDots write FNumberOfDots default 0;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CS',[TLabelBox]);
end;

{ TLabelBox }

constructor TLabelBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := nil;
end;

procedure TLabelBox.Paint;
var
  ww, hh: Integer;
    var image: TBGRABitmap;
    imgBackColor: TBGRAPixel;
    imgNextColor: TBGRAPixel;
    pt1, pt2, pt3, pt4 : TPointF;

    procedure DrawDots;
    var
      dots: integer;
    const
      dotSize = 5;
      space = 2;
    begin
      if (FNumberOfDots > 0) then
      begin
        for dots := 0 to FNumberOfDots - 1 do
        begin
          Canvas.Brush.Color:= Font.Color;
          Canvas.Ellipse((dots * dotSize), 0, (dots + 1) * dotSize, dotSize);
        end;
      end;
    end;
begin
  inherited Paint;

  if (FBitmap <> nil) then
  begin
    image := TBGRABitmap.Create(Width,Height,BGRAPixelTransparent);

    hh := 0;
    ww := 0;
    if (FBitmap.Height < Height) then
      hh := (Height - FBitmap.Height) div 2;
    if (FBitmap.Width < Width) then
      ww := (Width - FBitmap.Width) div 2;

    //BackColor
    if (FBackColor <> clNone) then
    begin
      imgBackColor := ColorToBGRA(ColorToRGB(FBackColor));
      image.FillRoundRectAntialias(0,0,FBitmap.Width,FBitmap.Height,FCornerSize,FCornerSize, imgBackColor);
      image.Draw(Canvas,ww,hh, false);
    end;

     //Bitmap
    image.Assign(FBitmap);
    image.Draw(Canvas,ww,hh, false);
    image.Free;
  end
  else if (FBackColor <> clNone) then
  begin
    image := TBGRABitmap.Create(Width,Height,BGRAPixelTransparent);
    pt1.x := FShapeX1;
    pt1.y := FShapeY1;
    pt2.x := FShapeX2;
    pt2.y := FShapeY2;
    pt3.x := FShapeX3;
    pt3.y := FShapeY3;
    pt4.x := FShapeX4;
    pt4.y := FShapeY4;

    if (FOpaque) then
    begin
      imgBackColor := ColorToBGRA(ColorToRGB(FBackColor));
      if (GradientFill) then
        imgNextColor := ColorToBGRA(ColorToRGB(FNextColor));

      if (FLabelShape = lsRectangle) then
      begin
        if (GradientFill) then
          image.GradientFill(0,0,image.Width,image.Height,
                     imgBackColor,imgNextColor,
                     gtLinear,PointF(0,0),PointF(image.Width,image.Height),
                     dmLinearBlend)
        else
          image.FillRoundRectAntialias(0,0,Width,Height,FCornerSize,FCornerSize, imgBackColor);
      end
      else
      begin
        if (GradientFill) then
          image.FillQuadLinearColorAntialias(pt1, pt2, pt3, pt4, imgBackColor, imgBackColor, imgNextColor, imgNextColor)
        else
          image.FillQuadLinearColorAntialias(pt1, pt2, pt3, pt4, imgBackColor, imgBackColor, imgBackColor, imgBackColor);
      end;

      image.Draw(Canvas,0,0, false);
      image.Free;
    end
    else
    begin
      imgBackColor := ColorToBGRA(ColorToRGB(FBackColor), FTransparency);
      if (FLabelShape = lsRectangle) then
      begin
        image.FillRoundRectAntialias(0,0,Width,Height,FCornerSize,FCornerSize, imgBackColor, [rrTopLeftBevel,rrTopRightBevel,rrBottomRightBevel,rrBottomLeftBevel]);
      end
      else
      begin
        image.FillQuadLinearColorAntialias(pt1, pt2, pt3, pt4, imgBackColor, imgBackColor, imgBackColor, imgBackColor);
      end;

      image.Draw(Canvas,0,0, false);
      image.Free;
    end;

    //image := TBGRABitmap.Create(ClientWidth,ClientHeight,
    //                            ColorToBGRA(ColorToRGB(FBackColor), 80));
    ////c := ColorToBGRA(ColorToBGRA(ColorToRGB(FBackColor), 80));
    //
    ////image.JoinStyle := pjsBevel;
    ////image.RectangleAntialias(0, 0, Width, Height, c, 0);
    //
    //image.Draw(Canvas,0,0,false);
    //image.free;
  end;

  if (BorderStyle = bsSingle) then
  begin
    image := TBGRABitmap.Create(Width,Height,BGRAPixelTransparent);
    image.RoundRectAntialias(0,0,Width - FBorderWidth,Height - FBorderWidth,FCornerSize,FCornerSize,FBorderColor, FBorderWidth);
    image.Draw(Canvas,0,0, false);
    image.Free;
    //Canvas.Pen.Color := FBorderColor;
    //Canvas.Pen.Width := FBorderWidth;
    //Canvas.RoundRect (0, 0, ClientWidth, ClientHeight, FCornerSize, FCornerSize);
  end;

  DrawDots;

  //if (BorderStyle = bsSingle) then
  //begin
  //  if (FBackColor <> clNone) then
  //    Canvas.Brush.Color := FBackColor;
  //  Canvas.Pen.Color := FBorderColor;
  //  Canvas.Pen.Width := FBorderWidth;
  //  Canvas.RoundRect (0, 0, ClientWidth, ClientHeight, FCornerSize, FCornerSize);
  //end
  //else if (FBackColor <> clNone) then
  //begin
  //  Canvas.Brush.Color := FBackColor;
  //  Canvas.Pen.Color := FBackColor;
  //  Canvas.Pen.Width := 1;
  //  Canvas.RoundRect (0, 0, ClientWidth, ClientHeight, FCornerSize, FCornerSize);
  //  //DrawOpacityBrush(Canvas, 0, 0, FBackColor, Width, 50);
  //  //ww := 0;
  //  //hh := 0;
  //  //Canvas.GetTextSize(self.Caption, ww, hh);
  //  //Canvas.TextOut((Width-ww) div 2, (Height-hh) div 2, self.Caption);
  //end;
end;

procedure TLabelBox.DrawOpacityBrush(ACanvas: TCanvas; X, Y: Integer; AColor: TColor; ASize: Integer; Opacity: Byte);
var
  Bmp: TBitmap;
  I, J: Integer;
  Pixels: PRGBQuad;
  ColorRgb: Integer;
  ColorR, ColorG, ColorB: Byte;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf32Bit; // needed for an alpha channel
    Bmp.SetSize(ASize, ASize);

    with Bmp.Canvas do
    begin
      Brush.Color := clFuchsia; // background color to mask out
      ColorRgb := ColorToRGB(Brush.Color);
      FillRect(Rect(0, 0, ASize, ASize));
      Pen.Color := AColor;
      Pen.Style := psSolid;
      Pen.Width := ASize;
      MoveTo(ASize div 2, ASize div 2);
      LineTo(ASize div 2, ASize div 2);
    end;

    ColorR := GetRValue(ColorRgb);
    ColorG := GetGValue(ColorRgb);
    ColorB := GetBValue(ColorRgb);

    for I := 0 to Bmp.Height-1 do
    begin
      Pixels := PRGBQuad(Bmp.ScanLine[I]);
      for J := 0 to Bmp.Width-1 do
      begin
        with Pixels^ do
        begin
          if (rgbRed = ColorR) and (rgbGreen = ColorG) and (rgbBlue = ColorB) then
            rgbReserved := 0
          else
            rgbReserved := Opacity;
          // must pre-multiply the pixel with its alpha channel before drawing
          rgbRed := (rgbRed * rgbReserved) div $FF;
          rgbGreen := (rgbGreen * rgbReserved) div $FF;
          rgbBlue := (rgbBlue * rgbReserved) div $FF;
        end;
        Inc(Pixels);
      end;
    end;

    ACanvas.Draw(X, Y, Bmp);
  finally
    Bmp.Free;
  end;
end;


end.
