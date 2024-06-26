// SPDX-License-Identifier: LGPL-3.0-only (modified to allow linking)
{
  Created by BGRA Controls Team
  Dibo, Circular, lainz (007) and contributors.
  For detailed information see readme.txt

  Site: https://sourceforge.net/p/bgra-controls/
  Wiki: http://wiki.lazarus.freepascal.org/BGRAControls
  Forum: http://forum.lazarus.freepascal.org/index.php/board,46.0.html
}

{******************************* CONTRIBUTOR(S) ******************************
- Edivando S. Santos Brasil | mailedivando@gmail.com
  (Compatibility with delphi VCL 11/2018)

***************************** END CONTRIBUTOR(S) *****************************}
unit BGRAShape;

{$I bgracontrols.inc}

interface

uses
  Classes, SysUtils, {$IFDEF FPC}LResources,{$ENDIF} Forms, Controls, Graphics, Dialogs,
  {$IFNDEF FPC}Types, BGRAGraphics, GraphType, FPImage, {$ENDIF}
  BCBaseCtrls, BGRABitmap, BGRABitmapTypes, BCTypes;

type
  TBGRAShapeType = (stRegularPolygon, stEllipse);

  { TBGRAShape }

  TBGRAShape = class(TBGRAGraphicCtrl)
  private
    { Private declarations }
    FBorderColor: TColor;
    FBorderOpacity: byte;
    FBorderStyle: TPenStyle;
    FBorderWidth: integer;
    FBorderGradient: TBCGradient;
    FUseBorderGradient: boolean;
    FFillColor:  TColor;
    FFillOpacity: byte;
    FFillGradient: TBCGradient;
    FUseFillGradient: boolean;
    FRoundRadius: integer;
    FBGRA:       TBGRABitmap;
    FSideCount:  integer;
    FRatioXY:    single;
    FUseRatioXY: boolean;
    FAngle:      single;
    FShapeType:  TBGRAShapeType;
    procedure SetAngle(const AValue: single);
    procedure SetBorderColor(const AValue: TColor);
    procedure SetBorderGradient(const AValue: TBCGradient);
    procedure SetBorderOpacity(const AValue: byte);
    procedure SetBorderStyle(const AValue: TPenStyle);
    procedure SetBorderWidth(AValue: integer);
    procedure SetFillColor(const AValue: TColor);
    procedure SetFillGradient(const AValue: TBCGradient);
    procedure SetFillOpacity(const AValue: byte);
    procedure SetRatioXY(const AValue: single);
    procedure SetRoundRadius(AValue: integer);
    procedure SetShapeType(const AValue: TBGRAShapeType);
    procedure SetSideCount(AValue: integer);
    procedure SetUseBorderGradient(const AValue: boolean);
    procedure SetUseFillGradient(const AValue: boolean);
    procedure SetUseRatioXY(const AValue: boolean);
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    { Streaming }
    {$IFDEF FPC}
    procedure SaveToFile(AFileName: string);
    procedure LoadFromFile(AFileName: string);
    {$ENDIF}
    procedure OnFindClass({%H-}Reader: TReader; const AClassName: string;
      var ComponentClass: TComponentClass);
  published
    { Published declarations }
    property AutoSize;
    property Align;
    property Anchors;
    property Angle: single Read FAngle Write SetAngle {$IFDEF FPC}default 0{$ENDIF};
    property BorderWidth: integer Read FBorderWidth Write SetBorderWidth default 1;
    property BorderOpacity: byte Read FBorderOpacity Write SetBorderOpacity default 255;
    property BorderColor: TColor Read FBorderColor Write SetBorderColor;
    property BorderGradient: TBCGradient Read FBorderGradient Write SetBorderGradient;
    property BorderStyle: TPenStyle
      Read FBorderStyle Write SetBorderStyle default psSolid;
    property FillColor: TColor Read FFillColor Write SetFillColor;
    property FillOpacity: byte Read FFillOpacity Write SetFillOpacity;
    property FillGradient: TBCGradient Read FFillGradient Write SetFillGradient;
    property SideCount: integer Read FSideCount Write SetSideCount default 4;
    property RatioXY: single Read FRatioXY Write SetRatioXY {$IFDEF FPC}default 1{$ENDIF};
    property UseRatioXY: boolean Read FUseRatioXY Write SetUseRatioXY default False;
    property UseFillGradient: boolean Read FUseFillGradient
      Write SetUseFillGradient default False;
    property UseBorderGradient: boolean Read FUseBorderGradient
      Write SetUseBorderGradient default False;
    property ShapeType: TBGRAShapeType
      Read FShapeType Write SetShapeType default stRegularPolygon;
    property BorderSpacing;
    property Caption;
    property PopupMenu;
    property RoundRadius: integer Read FRoundRadius Write SetRoundRadius default 0;
    property Visible;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
  end;

{$IFDEF FPC}procedure Register;{$ENDIF}

implementation

uses BCTools;

{$IFDEF FPC}
procedure Register;
begin
  //{$I icons\bgrashape_icon.lrs}
  RegisterComponents('BGRA Controls', [TBGRAShape]);
end;
{$ENDIF}

{ TBGRAShape }

procedure TBGRAShape.SetBorderColor(const AValue: TColor);
begin
  if FBorderColor = AValue then
    exit;
  FBorderColor := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetBorderGradient(const AValue: TBCGradient);
begin
  if FBorderGradient = AValue then
    exit;
  FBorderGradient.Assign(AValue);
  Invalidate;
end;

procedure TBGRAShape.SetAngle(const AValue: single);
begin
  if FAngle = AValue then
    exit;
  FAngle := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetBorderOpacity(const AValue: byte);
begin
  if FBorderOpacity = AValue then
    exit;
  FBorderOpacity := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetBorderStyle(const AValue: TPenStyle);
begin
  if FBorderStyle = AValue then
    exit;
  FBorderStyle := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetBorderWidth(AValue: integer);
begin
  if AValue < 0 then
    AValue := 0;
  if FBorderWidth = AValue then
    exit;
  FBorderWidth := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetFillColor(const AValue: TColor);
begin
  if FFillColor = AValue then
    exit;
  FFillColor := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetFillGradient(const AValue: TBCGradient);
begin
  if FFillGradient = AValue then
    exit;
  FFillGradient.Assign(AValue);
  Invalidate;
end;

procedure TBGRAShape.SetFillOpacity(const AValue: byte);
begin
  if FFillOpacity = AValue then
    exit;
  FFillOpacity := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetRatioXY(const AValue: single);
begin
  if FRatioXY = AValue then
    exit;
  FRatioXY := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetRoundRadius(AValue: integer);
begin
  if AValue < 0 then
    AValue := 0;
  if FRoundRadius = AValue then
    exit;
  FRoundRadius := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetShapeType(const AValue: TBGRAShapeType);
begin
  if FShapeType = AValue then
    exit;
  FShapeType := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetSideCount(AValue: integer);
begin
  if AValue < 3 then
    AValue := 3;
  if FSideCount = AValue then
    exit;
  FSideCount := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetUseBorderGradient(const AValue: boolean);
begin
  if FUseBorderGradient = AValue then
    exit;
  FUseBorderGradient := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetUseFillGradient(const AValue: boolean);
begin
  if FUseFillGradient = AValue then
    exit;
  FUseFillGradient := AValue;
  Invalidate;
end;

procedure TBGRAShape.SetUseRatioXY(const AValue: boolean);
begin
  if FUseRatioXY = AValue then
    exit;
  FUseRatioXY := AValue;
  Invalidate;
end;

procedure TBGRAShape.Paint;
var
  cx, cy, rx, ry, curRatio, a: single;
  coords: array of TPointF;
  minCoord, maxCoord: TPointF;
  i: integer;
  borderGrad, fillGrad: TBGRACustomScanner;
  scaling: Double;
begin
  if FBGRA = nil then FBGRA := TBGRABitmap.Create;
  scaling := GetCanvasScaleFactor;
  FBGRA.SetSize(round(Width*scaling), round(Height*scaling));

  FBGRA.FillTransparent;
  FBGRA.PenStyle := FBorderStyle;
  with FBGRA.Canvas2D do
  begin
    lineJoin := 'round';
    if FUseBorderGradient then
    begin
      borderGrad := CreateGradient(FBorderGradient, Classes.rect(0, 0, FBGRA.Width, FBGRA.Height));
      strokeStyle(borderGrad);
    end
    else
    begin
      borderGrad := nil;
      strokeStyle(ColorToBGRA(ColorToRGB(FBorderColor), FBorderOpacity));
    end;
    lineStyle(FBGRA.CustomPenStyle);
    lineWidth := FBorderWidth*scaling;
    if FUseFillGradient then
    begin
      fillGrad := CreateGradient(FFillGradient, Classes.rect(0, 0, FBGRA.Width, FBGRA.Height));
      fillStyle(fillGrad);
    end
    else
    begin
      fillGrad := nil;
      fillStyle(ColorToBGRA(ColorToRGB(FFillColor), FFillOpacity));
    end;
    cx := FBGRA.Width / 2;
    cy := FBGRA.Height / 2;
    rx := (FBGRA.Width - FBorderWidth*scaling) / 2;
    ry := (FBGRA.Height - FBorderWidth*scaling) / 2;
    if FUseRatioXY and (ry <> 0) and (FRatioXY <> 0) then
    begin
      curRatio := rx / ry;
      if FRatioXY > curRatio then
        ry := ry / (FRatioXY / curRatio)
      else
        rx := rx / (curRatio / FRatioXY);
    end;
    if FShapeType = stRegularPolygon then
    begin
      setlength(coords, FSideCount);
      for i := 0 to high(coords) do
      begin
        a := (i / FSideCount + FAngle / 360) * 2 * Pi;
        coords[i] := PointF(sin(a), -cos(a));
      end;
      minCoord := coords[0];
      maxCoord := coords[0];
      for i := 1 to high(coords) do
      begin
        if coords[i].x < minCoord.x then
          minCoord.x := coords[i].x;
        if coords[i].y < minCoord.y then
          minCoord.y := coords[i].y;
        if coords[i].x > maxCoord.x then
          maxCoord.x := coords[i].x;
        if coords[i].y > maxCoord.y then
          maxCoord.y := coords[i].y;
      end;
      for i := 0 to high(coords) do
      begin
        with (coords[i] - minCoord) do
          coords[i] := PointF((x / (maxCoord.x - minCoord.x) - 0.5) *
            2 * rx + cx, (y / (maxCoord.y - minCoord.y) - 0.5) * 2 * ry + cy);
      end;
      beginPath;
      for i := 0 to high(coords) do
      begin
        lineTo((coords[i] + coords[(i + 1) mod length(coords)]) * (1 / 2));
        arcTo(coords[(i + 1) mod length(coords)], coords[(i + 2) mod
          length(coords)], FRoundRadius);
      end;
      closePath;
    end
    else
    begin
      save;
      translate(cx, cy);
      scale(rx, ry);
      beginPath;
      arc(0, 0, 1, 0, 2 * Pi);
      restore;
    end;

    fill;
    if FBorderWidth <> 0 then
      stroke;

    fillStyle(BGRAWhite);
    strokeStyle(BGRABlack);

    fillGrad.Free;
    borderGrad.Free;
  end;
  FBGRA.Draw(Self.Canvas, rect(0,0,Width,Height), False);
end;

constructor TBGRAShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, CX, CY);

  FBGRA := nil;

  FBorderColor := clWindowText;
  FBorderOpacity := 255;
  FBorderWidth := 1;
  FBorderStyle := psSolid;
  FBorderGradient := TBCGradient.Create(Self);
  FBorderGradient.Point2XPercent := 100;
  FBorderGradient.StartColor := clWhite;
  FBorderGradient.EndColor := clBlack;

  FFillColor := clWindow;
  FFillOpacity := 255;
  FFillGradient := TBCGradient.Create(Self);

  FRoundRadius := 0;
  FSideCount := 4;
  FRatioXY := 1;
  FUseRatioXY := False;
end;

destructor TBGRAShape.Destroy;
begin
  FBGRA.Free;
  FFillGradient.Free;
  FBorderGradient.Free;
  inherited Destroy;
end;
{$IFDEF FPC}
procedure TBGRAShape.SaveToFile(AFileName: string);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    WriteComponentAsTextToStream(AStream, Self);
    AStream.SaveToFile(AFileName);
  finally
    AStream.Free;
  end;
end;

procedure TBGRAShape.LoadFromFile(AFileName: string);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    AStream.LoadFromFile(AFileName);
    ReadComponentFromTextStream(AStream, TComponent(Self), OnFindClass);
  finally
    AStream.Free;
  end;
end;
{$ENDIF}
procedure TBGRAShape.OnFindClass(Reader: TReader; const AClassName: string;
  var ComponentClass: TComponentClass);
begin
  if CompareText(AClassName, 'TBGRAShape') = 0 then
    ComponentClass := TBGRAShape;
end;

end.
