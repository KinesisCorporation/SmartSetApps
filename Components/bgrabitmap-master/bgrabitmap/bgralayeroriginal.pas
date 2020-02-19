unit BGRALayerOriginal;

{$mode objfpc}{$H+}
{$i bgrabitmap.inc}

interface

uses
  Classes, SysUtils, BGRABitmap, BGRABitmapTypes, BGRATransform, BGRAMemDirectory, fgl
  {$IFDEF BGRABITMAP_USE_LCL},LCLType{$ENDIF};

type
  PRectF = BGRABitmapTypes.PRectF;
  TAffineMatrix = BGRATransform.TAffineMatrix;
  TBGRALayerCustomOriginal = class;
  TBGRALayerOriginalAny = class of TBGRALayerCustomOriginal;
  TOriginalMovePointEvent = procedure(ASender: TObject; APrevCoord, ANewCoord: TPointF; AShift: TShiftState) of object;
  TOriginalStartMovePointEvent = procedure(ASender: TObject; AIndex: integer; AShift: TShiftState) of object;
  TOriginalClickPointEvent = procedure(ASender: TObject; AIndex: integer; AShift: TShiftState) of object;
  TOriginalHoverPointEvent = procedure(ASender: TObject; AIndex: integer) of object;
  TOriginalChangeEvent = procedure(ASender: TObject; ABounds: PRectF = nil) of object;
  TOriginalEditingChangeEvent = procedure(ASender: TObject) of object;
  TOriginalEditorCursor = (oecDefault, oecMove, oecMoveW, oecMoveE, oecMoveN, oecMoveS,
                           oecMoveNE, oecMoveSW, oecMoveNW, oecMoveSE, oecHandPoint);
  TSpecialKey = (skUnknown, skBackspace, skTab, skReturn, skEscape,
                 skPageUp, skPageDown, skHome, skEnd,
                 skLeft, skUp, skRight, skDown,
                 skInsert, skDelete,
                 skNum0, skNum1, skNum2, skNum3, skNum4, skNum5, skNum6, skNum7, skNum8, skNum9,
                 skF1, skF2, skF3, skF4, skF5, skF6, skF7, skF8, skF9, skF10, skF11, skF12);

{$IFDEF BGRABITMAP_USE_LCL}
const
  SpecialKeyToLCL: array[TSpecialKey] of Word =
    (VK_UNKNOWN, VK_BACK,VK_TAB,VK_RETURN,VK_ESCAPE,
     VK_PRIOR,VK_NEXT,VK_HOME,VK_END,
     VK_LEFT,VK_UP,VK_RIGHT,VK_DOWN,
     VK_INSERT,VK_DELETE,
     VK_NUMPAD0,VK_NUMPAD1,VK_NUMPAD2,VK_NUMPAD3,VK_NUMPAD4,VK_NUMPAD5,VK_NUMPAD6,VK_NUMPAD7,VK_NUMPAD8,VK_NUMPAD9,
     VK_F1,VK_F2,VK_F3,VK_F4,VK_F5,VK_F6,VK_F7,VK_F8,VK_F9,VK_F10,VK_F11,VK_F12);
{$ENDIF}

type
  TStartMoveHandlers = specialize TFPGList<TOriginalStartMovePointEvent>;
  TClickPointHandlers = specialize TFPGList<TOriginalClickPointEvent>;
  THoverPointHandlers = specialize TFPGList<TOriginalHoverPointEvent>;
  TBGRAOriginalPolylineStyle = (opsNone, opsSolid, opsDash, opsDashWithShadow);

  { TBGRAOriginalEditor }

  TBGRAOriginalEditor = class
  private
    function GetPointCoord(AIndex: integer): TPointF;
    function GetPointCount: integer;
  protected
    FMatrix,FMatrixInverse: TAffineMatrix;          //view matrix from original coord
    FGridMatrix,FGridMatrixInverse: TAffineMatrix;  //grid matrix in original coord
    FGridActive: boolean;
    FPoints: array of record
      Origin, Coord: TPointF;
      OnMove: TOriginalMovePointEvent;
      RightButton: boolean;
      SnapToPoint: integer;
    end;
    FPolylines: array of record
      Coords: array of TPointF;
      Closed: boolean;
      Style: TBGRAOriginalPolylineStyle;
      BackColor: TBGRAPixel;
    end;
    FPointSize: single;
    FPointMoving: integer;
    FPointCoordDelta: TPointF;
    FMovingRightButton: boolean;
    FPrevMousePos: TPointF;
    FStartMoveHandlers: TStartMoveHandlers;
    FCurHoverPoint: integer;
    FHoverPointHandlers: THoverPointHandlers;
    FClickPointHandlers: TClickPointHandlers;
    function RenderPoint(ADest: TBGRABitmap; ACoord: TPointF; AAlternateColor: boolean): TRect; virtual;
    function GetRenderPointBounds(ACoord: TPointF): TRect; virtual;
    function RenderArrow(ADest: TBGRABitmap; AOrigin, AEndCoord: TPointF): TRect; virtual;
    function GetRenderArrowBounds(AOrigin, AEndCoord: TPointF): TRect; virtual;
    function RenderPolygon(ADest: TBGRABitmap; ACoords: array of TPointF; AClosed: boolean; AStyle: TBGRAOriginalPolylineStyle; ABackColor: TBGRAPixel): TRect; virtual;
    function GetRenderPolygonBounds(ACoords: array of TPointF): TRect;
    procedure SetMatrix(AValue: TAffineMatrix);
    procedure SetGridMatrix(AValue: TAffineMatrix);
    procedure SetGridActive(AValue: boolean);
    function GetMoveCursor(APointIndex: integer): TOriginalEditorCursor; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure AddStartMoveHandler(AOnStartMove: TOriginalStartMovePointEvent);
    procedure AddClickPointHandler(AOnClickPoint: TOriginalClickPointEvent);
    procedure AddHoverPointHandler(AOnHoverPoint: TOriginalHoverPointEvent);
    function AddPoint(const ACoord: TPointF; AOnMove: TOriginalMovePointEvent; ARightButton: boolean = false; ASnapToPoint: integer = -1): integer;
    function AddFixedPoint(const ACoord: TPointF; ARightButton: boolean = false): integer;
    function AddArrow(const AOrigin, AEndCoord: TPointF; AOnMoveEnd: TOriginalMovePointEvent; ARightButton: boolean = false): integer;
    function AddPolyline(const ACoords: array of TPointF; AClosed: boolean; AStyle: TBGRAOriginalPolylineStyle): integer; overload;
    function AddPolyline(const ACoords: array of TPointF; AClosed: boolean; AStyle: TBGRAOriginalPolylineStyle; ABackColor: TBGRAPixel): integer; overload;
    procedure MouseMove(Shift: TShiftState; ViewX, ViewY: single; out ACursor: TOriginalEditorCursor; out AHandled: boolean); virtual;
    procedure MouseDown(RightButton: boolean; Shift: TShiftState; ViewX, ViewY: single; out ACursor: TOriginalEditorCursor; out AHandled: boolean); virtual;
    procedure MouseUp(RightButton: boolean; {%H-}Shift: TShiftState; {%H-}ViewX, {%H-}ViewY: single; out ACursor: TOriginalEditorCursor; out AHandled: boolean); virtual;
    procedure KeyDown({%H-}Shift: TShiftState; {%H-}Key: TSpecialKey; out AHandled: boolean); virtual;
    procedure KeyUp({%H-}Shift: TShiftState; {%H-}Key: TSpecialKey; out AHandled: boolean); virtual;
    procedure KeyPress({%H-}UTF8Key: string; out AHandled: boolean); virtual;
    function GetPointAt(ACoord: TPointF; ARightButton: boolean): integer;
    function Render(ADest: TBGRABitmap; const {%H-}ALayoutRect: TRect): TRect; virtual;
    function GetRenderBounds(const {%H-}ALayoutRect: TRect): TRect; virtual;
    function SnapToGrid(const ACoord: TPointF; AIsViewCoord: boolean): TPointF;
    function OriginalCoordToView(const AImageCoord: TPointF): TPointF;
    function ViewCoordToOriginal(const AViewCoord: TPointF): TPointF;
    property Matrix: TAffineMatrix read FMatrix write SetMatrix;
    property GridMatrix: TAffineMatrix read FGridMatrix write SetGridMatrix;
    property GridActive: boolean read FGridActive write SetGridActive;
    property PointSize: single read FPointSize write FPointSize;
    property PointCount: integer read GetPointCount;
    property PointCoord[AIndex: integer]: TPointF read GetPointCoord;
  end;

  TBGRACustomOriginalStorage = class;
  ArrayOfSingle = array of single;

  { TBGRALayerCustomOriginal }

  TBGRALayerCustomOriginal = class
  private
    FOnChange: TOriginalChangeEvent;
    FOnEditingChange: TOriginalEditingChangeEvent;
    procedure SetOnChange(AValue: TOriginalChangeEvent);
  protected
    FGuid: TGuid;
    function GetGuid: TGuid;
    procedure SetGuid(AValue: TGuid);
    procedure NotifyChange; overload;
    procedure NotifyChange(ABounds: TRectF); overload;
    procedure NotifyEditorChange;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix; ADraft: boolean); virtual; abstract;
    function GetRenderBounds(ADestRect: TRect; AMatrix: TAffineMatrix): TRect; virtual; abstract;
    procedure ConfigureEditor({%H-}AEditor: TBGRAOriginalEditor); virtual;
    procedure LoadFromStorage(AStorage: TBGRACustomOriginalStorage); virtual; abstract;
    procedure SaveToStorage(AStorage: TBGRACustomOriginalStorage); virtual; abstract;
    procedure LoadFromFile(AFilenameUTF8: string); virtual;
    procedure LoadFromStream(AStream: TStream); virtual;
    procedure LoadFromResource(AFilename: string);
    procedure SaveToFile(AFilenameUTF8: string); virtual;
    procedure SaveToStream(AStream: TStream); virtual;
    function CreateEditor: TBGRAOriginalEditor; virtual;
    class function StorageClassName: RawByteString; virtual; abstract;
    function Duplicate: TBGRALayerCustomOriginal; virtual;
    property Guid: TGuid read GetGuid write SetGuid;
    property OnChange: TOriginalChangeEvent read FOnChange write SetOnChange;
    property OnEditingChange: TOriginalEditingChangeEvent read FOnEditingChange write FOnEditingChange;
  end;

  { TBGRALayerImageOriginal }

  TBGRALayerImageOriginal = class(TBGRALayerCustomOriginal)
  private
    function GetImageHeight: integer;
    function GetImageWidth: integer;
  protected
    FImage: TBGRABitmap;
    FJpegStream: TMemoryStream;
    FContentVersion: integer;
    procedure ContentChanged;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Render(ADest: TBGRABitmap; AMatrix: TAffineMatrix; ADraft: boolean); override;
    function GetRenderBounds({%H-}ADestRect: TRect; AMatrix: TAffineMatrix): TRect; override;
    procedure LoadFromStorage(AStorage: TBGRACustomOriginalStorage); override;
    procedure SaveToStorage(AStorage: TBGRACustomOriginalStorage); override;
    procedure LoadFromStream(AStream: TStream); override;
    procedure LoadImageFromStream(AStream: TStream);
    procedure SaveImageToStream(AStream: TStream);
    class function StorageClassName: RawByteString; override;
    property Width: integer read GetImageWidth;
    property Height: integer read GetImageHeight;
  end;

  { TBGRACustomOriginalStorage }

  TBGRACustomOriginalStorage = class
  protected
    FFormats: TFormatSettings;
    function GetBool(AName: utf8string): boolean;
    function GetColorArray(AName: UTF8String): ArrayOfTBGRAPixel;
    function GetInteger(AName: utf8string): integer;
    function GetIntegerDef(AName: utf8string; ADefault: integer): integer;
    function GetPointF(AName: utf8string): TPointF;
    function GetRawString(AName: utf8string): RawByteString; virtual; abstract;
    function GetSingle(AName: utf8string): single;
    function GetSingleArray(AName: utf8string): ArrayOfSingle;
    function GetSingleDef(AName: utf8string; ADefault: single): single;
    function GetColor(AName: UTF8String): TBGRAPixel;
    procedure SetBool(AName: utf8string; AValue: boolean);
    procedure SetColorArray(AName: UTF8String; AValue: ArrayOfTBGRAPixel);
    procedure SetInteger(AName: utf8string; AValue: integer);
    procedure SetPointF(AName: utf8string; AValue: TPointF);
    procedure SetRawString(AName: utf8string; AValue: RawByteString); virtual; abstract;
    procedure SetSingle(AName: utf8string; AValue: single);
    procedure SetSingleArray(AName: utf8string; AValue: ArrayOfSingle);
    procedure SetColor(AName: UTF8String; AValue: TBGRAPixel);
    function GetDelimiter: char;
  public
    constructor Create;
    procedure RemoveAttribute(AName: utf8string); virtual; abstract;
    procedure RemoveObject(AName: utf8string); virtual; abstract;
    function CreateObject(AName: utf8string): TBGRACustomOriginalStorage; virtual; abstract;
    function OpenObject(AName: utf8string): TBGRACustomOriginalStorage; virtual; abstract;
    function ObjectExists(AName: utf8string): boolean; virtual; abstract;
    procedure RemoveFile(AName: utf8string); virtual; abstract;
    function ReadFile(AName: UTF8String; ADest: TStream): boolean; virtual; abstract;
    procedure WriteFile(AName: UTF8String; ASource: TStream; ACompress: boolean); virtual; abstract;
    property RawString[AName: utf8string]: RawByteString read GetRawString write SetRawString;
    property Int[AName: utf8string]: integer read GetInteger write SetInteger;
    property IntDef[AName: utf8string; ADefault: integer]: integer read GetIntegerDef;
    property Bool[AName: utf8string]: boolean read GetBool write SetBool;
    property Float[AName: utf8string]: single read GetSingle write SetSingle;
    property FloatArray[AName: utf8string]: ArrayOfSingle read GetSingleArray write SetSingleArray;
    property FloatDef[AName: utf8string; ADefault: single]: single read GetSingleDef;
    property PointF[AName: utf8string]: TPointF read GetPointF write SetPointF;
    property Color[AName: UTF8String]: TBGRAPixel read GetColor write SetColor;
    property ColorArray[AName: UTF8String]: ArrayOfTBGRAPixel read GetColorArray write SetColorArray;
  end;

  { TBGRAMemOriginalStorage }

  TBGRAMemOriginalStorage = class(TBGRACustomOriginalStorage)
  protected
    FMemDir: TMemDirectory;
    FMemDirOwned: boolean;
    function GetRawString(AName: utf8string): RawByteString; override;
    procedure SetRawString(AName: utf8string; AValue: RawByteString); override;
  public
    destructor Destroy; override;
    constructor Create;
    constructor Create(AMemDir: TMemDirectory; AMemDirOwned: boolean = false);
    procedure RemoveAttribute(AName: utf8string); override;
    procedure RemoveObject(AName: utf8string); override;
    function CreateObject(AName: utf8string): TBGRACustomOriginalStorage; override;
    function OpenObject(AName: utf8string): TBGRACustomOriginalStorage; override;
    function ObjectExists(AName: utf8string): boolean; override;
    procedure RemoveFile(AName: utf8string); override;
    function ReadFile(AName: UTF8String; ADest: TStream): boolean; override;
    procedure WriteFile(AName: UTF8String; ASource: TStream; ACompress: boolean); override;
    procedure SaveToStream(AStream: TStream);
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromResource(AFilename: string);
    procedure CopyTo(AMemDir: TMemDirectory);
  end;

procedure RegisterLayerOriginal(AClass: TBGRALayerOriginalAny);
function FindLayerOriginalClass(AStorageClassName: string): TBGRALayerOriginalAny;

implementation

uses BGRAPolygon, math, BGRAMultiFileType, BGRAUTF8, Types, BGRAGraphics;

var
  LayerOriginalClasses: array of TBGRALayerOriginalAny;

procedure RegisterLayerOriginal(AClass: TBGRALayerOriginalAny);
begin
  setlength(LayerOriginalClasses, length(LayerOriginalClasses)+1);
  LayerOriginalClasses[high(LayerOriginalClasses)] := AClass;
end;

function FindLayerOriginalClass(AStorageClassName: string): TBGRALayerOriginalAny;
var
  i: Integer;
begin
  for i := 0 to high(LayerOriginalClasses) do
    if LayerOriginalClasses[i].StorageClassName = AStorageClassName then
      exit(LayerOriginalClasses[i]);
  exit(nil);
end;

{ TBGRAOriginalEditor }

procedure TBGRAOriginalEditor.SetMatrix(AValue: TAffineMatrix);
begin
  if FMatrix=AValue then Exit;
  FMatrix:=AValue;
  FMatrixInverse := AffineMatrixInverse(FMatrix);
end;

function TBGRAOriginalEditor.GetMoveCursor(APointIndex: integer): TOriginalEditorCursor;
var
  d: TPointF;
  ratio: single;
begin
  if (APointIndex < 0) or (APointIndex >= PointCount) then result := oecDefault else
  if isEmptyPointF(FPoints[APointIndex].Origin) then
  begin
    if Assigned(FPoints[APointIndex].OnMove) then
      result := oecMove
    else
      result := oecHandPoint;
  end else
  begin
    d := AffineMatrixLinear(FMatrix)*(FPoints[APointIndex].Coord - FPoints[APointIndex].Origin);
    ratio := sin(Pi/8);
    if (d.x = 0) and (d.y = 0) then result := oecMove else
    if abs(d.x)*ratio >= abs(d.y) then
    begin
      if d.x >= 0 then result := oecMoveE else result := oecMoveW
    end else
    if abs(d.y)*ratio >= abs(d.x) then
    begin
      if d.y >= 0 then result := oecMoveS else result := oecMoveN
    end else
    if (d.x > 0) and (d.y > 0) then result := oecMoveSE else
    if (d.x < 0) and (d.y < 0) then result := oecMoveNW else
    if (d.x > 0) and (d.y < 0) then result := oecMoveNE
    else result := oecMoveSW;
  end;
end;

function TBGRAOriginalEditor.GetPointCoord(AIndex: integer): TPointF;
begin
  if (AIndex < 0) or (AIndex >= PointCount) then raise exception.Create('Index out of bounds');
  result := FPoints[AIndex].Coord;
end;

function TBGRAOriginalEditor.GetPointCount: integer;
begin
  result := length(FPoints);
end;

procedure TBGRAOriginalEditor.SetGridActive(AValue: boolean);
begin
  if FGridActive=AValue then Exit;
  FGridActive:=AValue;
end;

procedure TBGRAOriginalEditor.SetGridMatrix(AValue: TAffineMatrix);
begin
  if FGridMatrix=AValue then Exit;
  FGridMatrix:=AValue;
  FGridMatrixInverse := AffineMatrixInverse(FGridMatrix);
end;

function TBGRAOriginalEditor.RenderPoint(ADest: TBGRABitmap; ACoord: TPointF; AAlternateColor: boolean): TRect;
const alpha = 192;
var filler: TBGRAMultishapeFiller;
  c: TBGRAPixel;
begin
  result := GetRenderPointBounds(ACoord);
  if not isEmptyPointF(ACoord) then
  begin
    filler := TBGRAMultishapeFiller.Create;
    filler.AddEllipseBorder(ACoord.x,ACoord.y, FPointSize-2,FPointSize-2, 4, BGRA(0,0,0,alpha));
    if AAlternateColor then c := BGRA(255,128,128,alpha)
      else c := BGRA(255,255,255,alpha);
    filler.AddEllipseBorder(ACoord.x,ACoord.y, FPointSize-2,FPointSize-2, 1, c);
    filler.PolygonOrder:= poLastOnTop;
    filler.Draw(ADest);
    filler.Free;
  end;
end;

function TBGRAOriginalEditor.GetRenderPointBounds(ACoord: TPointF): TRect;
begin
  if isEmptyPointF(ACoord) then
    result := EmptyRect
  else
    result := rect(floor(ACoord.x - FPointSize + 0.5), floor(ACoord.y - FPointSize + 0.5), ceil(ACoord.x + FPointSize + 0.5), ceil(ACoord.y + FPointSize + 0.5));
end;

function TBGRAOriginalEditor.RenderArrow(ADest: TBGRABitmap; AOrigin,
  AEndCoord: TPointF): TRect;
const alpha = 192;
var
  pts, ptsContour: ArrayOfTPointF;
  i: Integer;
  rF: TRectF;
begin
  if isEmptyPointF(AOrigin) or isEmptyPointF(AEndCoord) then
    result := EmptyRect
  else
  begin
    ADest.Pen.Arrow.EndAsClassic;
    ADest.Pen.Arrow.EndSize := PointF(FPointSize,FPointSize);
    pts := ADest.ComputeWidePolyline([AOrigin,AEndCoord],1);
    ADest.Pen.Arrow.EndAsNone;
    ptsContour := ADest.ComputeWidePolygon(pts, 2);
    ADest.FillPolyAntialias(ptsContour, BGRA(0,0,0,alpha));
    ADest.FillPolyAntialias(pts, BGRA(255,255,255,alpha));
    rF := RectF(AOrigin,AEndCoord);
    for i := 0 to high(ptsContour) do
    if not isEmptyPointF(ptsContour[i]) then
    begin
      if ptsContour[i].x < rF.Left then rF.Left := ptsContour[i].x;
      if ptsContour[i].x > rF.Right then rF.Right := ptsContour[i].x;
      if ptsContour[i].y < rF.Top then rF.Top := ptsContour[i].y;
      if ptsContour[i].y > rF.Bottom then rF.Bottom := ptsContour[i].y;
    end;
    result := rect(floor(rF.Left+0.5),floor(rF.Top+0.5),ceil(rF.Right+0.5),ceil(rF.Bottom+0.5));
  end;
end;

function TBGRAOriginalEditor.GetRenderArrowBounds(AOrigin, AEndCoord: TPointF): TRect;
begin
  if isEmptyPointF(AOrigin) or isEmptyPointF(AEndCoord) then
    result := EmptyRect
  else
  begin
    result := Rect(floor(AOrigin.x+0.5-1.5),floor(AOrigin.y+0.5-1.5),ceil(AOrigin.x+0.5+1.5),ceil(AOrigin.y+0.5+1.5));
    UnionRect(result, result, rect(floor(AEndCoord.x+0.5-FPointSize-1.5), floor(AEndCoord.y+0.5-FPointSize-1.5),
                      ceil(AEndCoord.x+0.5+FPointSize+1.5), ceil(AEndCoord.y+0.5+FPointSize+1.5)) );
  end;
end;

function TBGRAOriginalEditor.RenderPolygon(ADest: TBGRABitmap;
  ACoords: array of TPointF; AClosed: boolean; AStyle: TBGRAOriginalPolylineStyle; ABackColor: TBGRAPixel): TRect;
var
  dashLen: integer;
  i: integer;
  ptsF: array of TPointF;
  pts1,pts2: array of TPoint;
begin
  dashLen := round(PointSize/2);
  if dashLen < 1 then dashLen := 1;

  setlength(pts1, length(ACoords));
  for i := 0 to high(ACoords) do
    pts1[i] := ACoords[i].Round;

  setlength(ptsF, length(pts1));
  for i := 0 to high(pts1) do
    ptsF[i] := PointF(pts1[i]);

  if ABackColor.alpha <> 0 then
    ADest.FillPolyAntialias(ptsF, ABackColor);

  case AStyle of
  opsDash, opsDashWithShadow:
    begin
      if AStyle = opsDashWithShadow then
      begin
        //shadow
        setlength(pts2,length(pts1));
        for i := 0 to high(pts1) do
          if not isEmptyPoint(pts1[i]) then
            pts2[i] := Point(pts1[i].x+1,pts1[i].y+1)
          else pts2[i] := EmptyPoint;
        if AClosed then
          ADest.DrawPolygonAntialias(pts2, BGRA(0,0,0,96))
        else
          ADest.DrawPolyLineAntialias(pts2, BGRA(0,0,0,96), true);
        pts2:= nil;
      end;

      //dotted line
      if AClosed then
        ADest.DrawPolygonAntialias(pts1, CSSIvory,BGRA(70,70,50),dashLen)
      else
        ADest.DrawPolyLineAntialias(pts1, CSSIvory,BGRA(70,70,50),dashLen, true);
    end;
  opsSolid:
    begin
      ADest.JoinStyle:= pjsRound;
      ADest.LineCap:= pecRound;
      //black outline
      if AClosed then
        ADest.DrawPolygonAntialias(ptsF, BGRA(0,0,0,192), 3)
      else
        ADest.DrawPolyLineAntialias(ptsF, BGRA(0,0,0,192), 3);

      if AClosed then
        ADest.DrawPolygonAntialias(pts1, CSSIvory)
      else
        ADest.DrawPolyLineAntialias(pts1, CSSIvory, true);
    end;
  end;

  result := GetRenderPolygonBounds(ACoords);
end;

function TBGRAOriginalEditor.GetRenderPolygonBounds(ACoords: array of TPointF): TRect;
var
  first: Boolean;
  rF: TRectF;
  i: Integer;
begin
  first:= true;
  rF:= EmptyRectF;
  for i := 0 to high(ACoords) do
    if not isEmptyPointF(ACoords[i]) then
    begin
      if first then
      begin
        rF := RectF(Acoords[i],ACoords[i]);
        first:= false;
      end else
      begin
        if ACoords[i].x < rF.Left then rF.Left := ACoords[i].x;
        if ACoords[i].x > rF.Right then rF.Right := ACoords[i].x;
        if ACoords[i].y < rF.Top then rF.Top := ACoords[i].y;
        if ACoords[i].y > rF.Bottom then rF.Bottom := ACoords[i].y;
      end;
    end;
  if not first then
    result := rect(floor(rF.Left-0.5),floor(rF.Top-0.5),ceil(rF.Right+1.5),ceil(rF.Bottom+1.5))
  else
    result := EmptyRect;
end;

constructor TBGRAOriginalEditor.Create;
begin
  FPointSize:= 6;
  FMatrix := AffineMatrixIdentity;
  FMatrixInverse := AffineMatrixIdentity;
  FGridMatrix := AffineMatrixIdentity;
  FGridMatrixInverse := AffineMatrixIdentity;
  FGridActive:= false;
  FPointMoving:= -1;
  FStartMoveHandlers := TStartMoveHandlers.Create;
  FCurHoverPoint:= -1;
  FHoverPointHandlers := THoverPointHandlers.Create;
  FClickPointHandlers := TClickPointHandlers.Create;
end;

destructor TBGRAOriginalEditor.Destroy;
begin
  FreeAndNil(FStartMoveHandlers);
  FreeAndNil(FHoverPointHandlers);
  FreeAndNil(FClickPointHandlers);
  inherited Destroy;
end;

procedure TBGRAOriginalEditor.Clear;
begin
  FPoints := nil;
  FPolylines := nil;
  FStartMoveHandlers.Clear;
  FHoverPointHandlers.Clear;
  FClickPointHandlers.Clear;
end;

procedure TBGRAOriginalEditor.AddStartMoveHandler(
  AOnStartMove: TOriginalStartMovePointEvent);
begin
  FStartMoveHandlers.Add(AOnStartMove);
end;

procedure TBGRAOriginalEditor.AddClickPointHandler(
  AOnClickPoint: TOriginalClickPointEvent);
begin
  FClickPointHandlers.Add(AOnClickPoint);
end;

procedure TBGRAOriginalEditor.AddHoverPointHandler(
  AOnHoverPoint: TOriginalHoverPointEvent);
begin
  FHoverPointHandlers.Add(AOnHoverPoint);
end;

function TBGRAOriginalEditor.AddPoint(const ACoord: TPointF;
  AOnMove: TOriginalMovePointEvent; ARightButton: boolean; ASnapToPoint: integer): integer;
begin
  setlength(FPoints, length(FPoints)+1);
  result := High(FPoints);
  with FPoints[result] do
  begin
    Origin := EmptyPointF;
    Coord := ACoord;
    OnMove := AOnMove;
    RightButton:= ARightButton;
    SnapToPoint:= ASnapToPoint;
  end;
end;

function TBGRAOriginalEditor.AddFixedPoint(const ACoord: TPointF;
  ARightButton: boolean): integer;
begin
  setlength(FPoints, length(FPoints)+1);
  result := High(FPoints);
  with FPoints[result] do
  begin
    Origin := EmptyPointF;
    Coord := ACoord;
    OnMove := nil;
    RightButton:= ARightButton;
    SnapToPoint:= -1;
  end;
end;

function TBGRAOriginalEditor.AddArrow(const AOrigin, AEndCoord: TPointF;
  AOnMoveEnd: TOriginalMovePointEvent; ARightButton: boolean): integer;
begin
  setlength(FPoints, length(FPoints)+1);
  result := High(FPoints);
  with FPoints[result] do
  begin
    Origin := AOrigin;
    Coord := AEndCoord;
    OnMove := AOnMoveEnd;
    RightButton:= ARightButton;
    SnapToPoint:= -1;
  end;
end;

function TBGRAOriginalEditor.AddPolyline(const ACoords: array of TPointF;
  AClosed: boolean; AStyle: TBGRAOriginalPolylineStyle): integer;
begin
  result := AddPolyline(ACoords, AClosed, AStyle, BGRAPixelTransparent);
end;

function TBGRAOriginalEditor.AddPolyline(const ACoords: array of TPointF;
  AClosed: boolean; AStyle: TBGRAOriginalPolylineStyle; ABackColor: TBGRAPixel): integer;
var
  i: Integer;
begin
  setlength(FPolylines, length(FPolylines)+1);
  result := high(FPolylines);
  setlength(FPolylines[result].Coords, length(ACoords));
  for i := 0 to high(ACoords) do
    FPolylines[result].Coords[i] := ACoords[i];
  FPolylines[result].Closed:= AClosed;
  FPolylines[result].Style := AStyle;
  FPolylines[result].BackColor := ABackColor;
end;

procedure TBGRAOriginalEditor.MouseMove(Shift: TShiftState; ViewX, ViewY: single; out
  ACursor: TOriginalEditorCursor; out AHandled: boolean);
var newMousePos, newCoord, snapCoord: TPointF;
  hoverPoint, i: Integer;
begin
  AHandled := false;
  newMousePos := ViewCoordToOriginal(PointF(ViewX,ViewY));
  if (FPointMoving <> -1) and (FPointMoving < length(FPoints)) then
  begin
    newCoord := newMousePos + FPointCoordDelta;
    if GridActive then newCoord := SnapToGrid(newCoord, false);
    if FPoints[FPointMoving].SnapToPoint <> -1 then
    begin
      snapCoord := FPoints[FPoints[FPointMoving].SnapToPoint].Coord;
      if VectLen(AffineMatrixLinear(FMatrix)*(snapCoord - newCoord)) < FPointSize then
        newCoord := snapCoord;
    end;
    if newCoord <> FPoints[FPointMoving].Coord then
    begin
      FPoints[FPointMoving].OnMove(self, FPoints[FPointMoving].Coord, newCoord, Shift);
      FPoints[FPointMoving].Coord := newCoord;
    end;
    ACursor := GetMoveCursor(FPointMoving);
    AHandled:= true;
  end else
  begin
    hoverPoint := GetPointAt(newMousePos, false);
    if hoverPoint <> -1 then
      ACursor := GetMoveCursor(hoverPoint)
    else
      ACursor:= oecDefault;
    if hoverPoint <> FCurHoverPoint then
    begin
      FCurHoverPoint:= hoverPoint;
      for i := 0 to FHoverPointHandlers.Count-1 do
        FHoverPointHandlers[i](self, FCurHoverPoint);
    end;
  end;
  FPrevMousePos:= newMousePos;
end;

procedure TBGRAOriginalEditor.MouseDown(RightButton: boolean;
  Shift: TShiftState; ViewX, ViewY: single; out ACursor: TOriginalEditorCursor; out
  AHandled: boolean);
var
  i, clickedPoint: Integer;
begin
  AHandled:= false;
  FPrevMousePos:= ViewCoordToOriginal(PointF(ViewX,ViewY));
  if FPointMoving = -1 then
  begin
    clickedPoint := GetPointAt(FPrevMousePos, RightButton);;
    if clickedPoint <> -1 then
    begin
      if Assigned(FPoints[clickedPoint].OnMove) then
      begin
        FPointMoving:= clickedPoint;
        FMovingRightButton:= RightButton;
        FPointCoordDelta := FPoints[FPointMoving].Coord - FPrevMousePos;
        for i := 0 to FStartMoveHandlers.Count-1 do
          FStartMoveHandlers[i](self, FPointMoving, Shift);
      end else
      begin
        for i := 0 to FClickPointHandlers.Count-1 do
          FClickPointHandlers[i](self, clickedPoint, Shift);
      end;
      AHandled:= true;
    end;
  end;
  if FPointMoving <> -1 then
  begin
    ACursor := GetMoveCursor(FPointMoving);
    AHandled:= true;
  end
  else
    ACursor := oecDefault;
end;

procedure TBGRAOriginalEditor.MouseUp(RightButton: boolean; Shift: TShiftState;
  ViewX, ViewY: single; out ACursor: TOriginalEditorCursor; out AHandled: boolean);
begin
  AHandled:= false;
  if (RightButton = FMovingRightButton) and (FPointMoving <> -1) then
  begin
    FPointMoving:= -1;
    AHandled:= true;
  end;
  ACursor := oecDefault;
end;

procedure TBGRAOriginalEditor.KeyDown(Shift: TShiftState; Key: TSpecialKey; out
  AHandled: boolean);
begin
  AHandled := false;
end;

procedure TBGRAOriginalEditor.KeyUp(Shift: TShiftState; Key: TSpecialKey; out
  AHandled: boolean);
begin
  AHandled := false;
end;

procedure TBGRAOriginalEditor.KeyPress(UTF8Key: string; out AHandled: boolean);
begin
  AHandled := false;
end;

function TBGRAOriginalEditor.GetPointAt(ACoord: TPointF; ARightButton: boolean): integer;
var v: TPointF;
  curDist,newDist: single;
  i: Integer;
begin
  if ARightButton then
    curDist := sqr(2.5*FPointSize)
  else
    curDist := sqr(1.5*FPointSize);
  result := -1;
  ACoord:= Matrix*ACoord;

  for i := 0 to high(FPoints) do
  if FPoints[i].RightButton = ARightButton then
  begin
    v := Matrix*FPoints[i].Coord - ACoord;
    newDist := v*v;
    if newDist <= curDist then
    begin
      curDist:= newDist;
      result := i;
    end;
  end;
  if result <> -1 then exit;

  if not ARightButton then
    curDist := sqr(2.5*FPointSize)
  else
    curDist := sqr(1.5*FPointSize);
  for i := 0 to high(FPoints) do
  if FPoints[i].RightButton <> ARightButton then
  begin
    v := Matrix*FPoints[i].Coord - ACoord;
    newDist := v*v;
    if newDist <= curDist then
    begin
      curDist:= newDist;
      result := i;
    end;
  end;
end;

function TBGRAOriginalEditor.Render(ADest: TBGRABitmap; const ALayoutRect: TRect): TRect;
var
  i,j: Integer;
  elemRect: TRect;
  ptsF: array of TPointF;
begin
  result := EmptyRect;
  for i := 0 to high(FPoints) do
  begin
    if isEmptyPointF(FPoints[i].Origin) then
      elemRect := RenderPoint(ADest, OriginalCoordToView(FPoints[i].Coord), FPoints[i].RightButton)
    else
      elemRect := RenderArrow(ADest, OriginalCoordToView(FPoints[i].Origin), OriginalCoordToView(FPoints[i].Coord));
    if not IsRectEmpty(elemRect) then
    begin
      if IsRectEmpty(result) then
        result := elemRect
      else
        UnionRect(result, result, elemRect);
    end;
  end;
  for i := 0 to high(FPolylines) do
  begin
    with FPolylines[i] do
    begin
      setlength(ptsF, length(Coords));
      for j := 0 to high(Coords) do
        if IsEmptyPointF(Coords[j]) then
          ptsF[j] := EmptyPointF
        else
          ptsF[j] := OriginalCoordToView(Coords[j]);
      elemRect := RenderPolygon(ADest, ptsF, Closed, Style, BackColor);
    end;
    if not IsRectEmpty(elemRect) then
    begin
      if IsRectEmpty(result) then
        result := elemRect
      else
        UnionRect(result, result, elemRect);
    end;
  end;
end;

function TBGRAOriginalEditor.GetRenderBounds(const ALayoutRect: TRect): TRect;
var
  i,j: Integer;
  elemRect: TRect;
  ptsF: array of TPointF;
begin
  result := EmptyRect;
  for i := 0 to high(FPoints) do
  begin
    if isEmptyPointF(FPoints[i].Origin) then
      elemRect := GetRenderPointBounds(OriginalCoordToView(FPoints[i].Coord))
    else
      elemRect := GetRenderArrowBounds(OriginalCoordToView(FPoints[i].Origin), OriginalCoordToView(FPoints[i].Coord));
    if not IsRectEmpty(elemRect) then
    begin
      if IsRectEmpty(result) then
        result := elemRect
      else
        UnionRect(result, result, elemRect);
    end;
  end;
  for i := 0 to high(FPolylines) do
  begin
    with FPolylines[i] do
    begin
      setlength(ptsF, length(Coords));
      for j := 0 to high(Coords) do
        if IsEmptyPointF(Coords[j]) then
          ptsF[j] := EmptyPointF
        else
          ptsF[j] := OriginalCoordToView(Coords[j]);
      elemRect := GetRenderPolygonBounds(ptsF);
    end;
    if not IsRectEmpty(elemRect) then
    begin
      if IsRectEmpty(result) then
        result := elemRect
      else
        UnionRect(result, result, elemRect);
    end;
  end;
end;

function TBGRAOriginalEditor.SnapToGrid(const ACoord: TPointF;
  AIsViewCoord: boolean): TPointF;
var
  gridCoord: TPointF;
begin
  if AIsViewCoord then
    gridCoord := FGridMatrixInverse*ViewCoordToOriginal(ACoord)
  else
    gridCoord := FGridMatrixInverse*ACoord;
  gridCoord.x := round(gridCoord.x);
  gridCoord.y := round(gridCoord.y);
  result := FGridMatrix*gridCoord;
  if AIsViewCoord then
    result := OriginalCoordToView(result);
end;

function TBGRAOriginalEditor.OriginalCoordToView(const AImageCoord: TPointF): TPointF;
begin
  result := FMatrix*AImageCoord;
end;

function TBGRAOriginalEditor.ViewCoordToOriginal(const AViewCoord: TPointF): TPointF;
begin
  result := FMatrixInverse*AViewCoord;
end;

{ TBGRAMemOriginalStorage }

function TBGRAMemOriginalStorage.GetRawString(AName: utf8string): RawByteString;
var
  idx: Integer;
begin
  if pos('.',AName)<>0 then exit('');
  idx := FMemDir.IndexOf(AName,'',true);
  if idx = -1 then
    result := ''
  else if FMemDir.IsDirectory[idx] then
    raise exception.Create('This name refers to an object and not an attribute')
  else
    result := FMemDir.RawString[idx];
end;

procedure TBGRAMemOriginalStorage.SetRawString(AName: utf8string;
  AValue: RawByteString);
var
  idx: Integer;
begin
  if pos('.',AName)<>0 then
    raise exception.Create('Attribute name cannot contain "."');
  idx := FMemDir.IndexOf(AName,'',true);
  if idx = -1 then
    FMemDir.Add(AName,'',AValue)
  else if FMemDir.IsDirectory[idx] then
    raise exception.Create('This name refers to an existing object and so cannot be an attribute')
  else
    FMemDir.RawString[idx] := AValue;
end;

destructor TBGRAMemOriginalStorage.Destroy;
begin
  if FMemDirOwned then FreeAndNil(FMemDir);
  inherited Destroy;
end;

constructor TBGRAMemOriginalStorage.Create;
begin
  inherited Create;
  FMemDir := TMemDirectory.Create;
  FMemDirOwned:= true;
end;

constructor TBGRAMemOriginalStorage.Create(AMemDir: TMemDirectory; AMemDirOwned: boolean = false);
begin
  inherited Create;
  FMemDir := AMemDir;
  FMemDirOwned:= AMemDirOwned;
end;

procedure TBGRAMemOriginalStorage.RemoveAttribute(AName: utf8string);
var
  idx: Integer;
begin
  if pos('.',AName)<>0 then exit;
  idx := FMemDir.IndexOf(AName,'',true);
  if idx = -1 then exit
  else if FMemDir.IsDirectory[idx] then
    raise exception.Create('This name refers to an object and not an attribute')
  else
    FMemDir.Delete(idx);
end;

procedure TBGRAMemOriginalStorage.RemoveObject(AName: utf8string);
var
  idx: Integer;
begin
  idx := FMemDir.IndexOf(EntryFilename(AName));
  if idx = -1 then exit
  else if not FMemDir.IsDirectory[idx] then
    raise exception.Create('This name refers to an attribute and not an object')
  else
    FMemDir.Delete(idx);
end;

function TBGRAMemOriginalStorage.CreateObject(AName: utf8string): TBGRACustomOriginalStorage;
var
  dirIdx: Integer;
begin
  if pos('.',AName)<>0 then
    raise exception.Create('An object cannot contain "."');
  RemoveObject(AName);
  dirIdx := FMemDir.AddDirectory(AName,'');
  result := TBGRAMemOriginalStorage.Create(FMemDir.Directory[dirIdx]);
end;

function TBGRAMemOriginalStorage.OpenObject(AName: utf8string): TBGRACustomOriginalStorage;
var
  dir: TMemDirectory;
begin
  if pos('.',AName)<>0 then
    raise exception.Create('An object cannot contain "."');
  dir := FMemDir.FindPath(AName);
  if dir = nil then
    result := nil
  else
    result := TBGRAMemOriginalStorage.Create(dir);
end;

function TBGRAMemOriginalStorage.ObjectExists(AName: utf8string): boolean;
var
  dir: TMemDirectory;
begin
  if pos('.',AName)<>0 then exit(false);
  dir := FMemDir.FindPath(AName);
  result:= Assigned(dir);
end;

procedure TBGRAMemOriginalStorage.RemoveFile(AName: utf8string);
var
  idx: Integer;
begin
  idx := FMemDir.IndexOf(EntryFilename(AName));
  if idx = -1 then exit
  else if FMemDir.IsDirectory[idx] then
    raise exception.Create('This name refers to an object and not a file')
  else
    FMemDir.Delete(idx);
end;

function TBGRAMemOriginalStorage.ReadFile(AName: UTF8String; ADest: TStream): boolean;
var
  entryId: Integer;
begin
  entryId := FMemDir.IndexOf(EntryFilename(AName));
  if entryId <> -1 then
  begin
    with FMemDir.Entry[entryId] do
      result := CopyTo(ADest) = FileSize
  end
  else
    result := false;
end;

procedure TBGRAMemOriginalStorage.WriteFile(AName: UTF8String; ASource: TStream; ACompress: boolean);
var
  idxEntry: Integer;
begin
  idxEntry := FMemDir.Add(EntryFilename(AName), ASource, true, false);
  if ACompress then FMemDir.IsEntryCompressed[idxEntry] := true;
end;

procedure TBGRAMemOriginalStorage.SaveToStream(AStream: TStream);
begin
  FMemDir.SaveToStream(AStream);
end;

procedure TBGRAMemOriginalStorage.LoadFromStream(AStream: TStream);
begin
  FMemDir.LoadFromStream(AStream);
end;

procedure TBGRAMemOriginalStorage.LoadFromResource(AFilename: string);
begin
  FMemDir.LoadFromResource(AFilename);
end;

procedure TBGRAMemOriginalStorage.CopyTo(AMemDir: TMemDirectory);
begin
  FMemDir.CopyTo(AMemDir, true);
end;

{ TBGRACustomOriginalStorage }

function TBGRACustomOriginalStorage.GetColor(AName: UTF8String): TBGRAPixel;
begin
  result := StrToBGRA(RawString[AName], BGRAPixelTransparent);
end;

procedure TBGRACustomOriginalStorage.SetColor(AName: UTF8String;
  AValue: TBGRAPixel);
begin
  RawString[AName] := LowerCase(BGRAToStr(AValue, CSSColors));
end;

function TBGRACustomOriginalStorage.GetDelimiter: char;
begin
  if FFormats.DecimalSeparator = ',' then
    result := ';' else result := ',';
end;

function TBGRACustomOriginalStorage.GetBool(AName: utf8string): boolean;
begin
  result := StrToBool(RawString[AName]);
end;

function TBGRACustomOriginalStorage.GetSingleArray(AName: utf8string): ArrayOfSingle;
var
  textVal: String;
  values: TStringList;
  i: Integer;
begin
  textVal := Trim(RawString[AName]);
  if textVal = '' then exit(nil);
  values := TStringList.Create;
  values.StrictDelimiter := true;
  values.Delimiter:= GetDelimiter;
  values.DelimitedText:= textVal;
  setlength(result, values.Count);
  for i := 0 to high(result) do
    if CompareText(values[i],'none')=0 then
      result[i] := EmptySingle
    else
      result[i] := StrToFloatDef(values[i], 0, FFormats);
  values.Free;
end;

function TBGRACustomOriginalStorage.GetColorArray(AName: UTF8String
  ): ArrayOfTBGRAPixel;
var colorNames: TStringList;
  i: Integer;
begin
  colorNames := TStringList.Create;
  colorNames.StrictDelimiter := true;
  colorNames.Delimiter:= GetDelimiter;
  colorNames.DelimitedText:= RawString[AName];
  setlength(result, colorNames.Count);
  for i := 0 to high(result) do
    result[i] := StrToBGRA(colorNames[i],BGRAPixelTransparent);
  colorNames.Free;
end;

function TBGRACustomOriginalStorage.GetIntegerDef(AName: utf8string;
  ADefault: integer): integer;
begin
  result := StrToIntDef(RawString[AName],ADefault);
end;

function TBGRACustomOriginalStorage.GetSingleDef(AName: utf8string;
  ADefault: single): single;
begin
  result := StrToFloatDef(RawString[AName], ADefault, FFormats);
end;

procedure TBGRACustomOriginalStorage.SetBool(AName: utf8string; AValue: boolean);
begin
  RawString[AName] := BoolToStr(AValue,'true','false');
end;

procedure TBGRACustomOriginalStorage.SetSingleArray(AName: utf8string;
  AValue: ArrayOfSingle);
var
  values: TStringList;
  i: Integer;
begin
  values:= TStringList.Create;
  values.StrictDelimiter:= true;
  values.Delimiter:= GetDelimiter;
  for i := 0 to high(AValue) do
    if AValue[i] = EmptySingle then
      values.Add('none')
    else
      values.Add(FloatToStr(AValue[i], FFormats));
  RawString[AName] := values.DelimitedText;
  values.Free;
end;

procedure TBGRACustomOriginalStorage.SetColorArray(AName: UTF8String;
  AValue: ArrayOfTBGRAPixel);
var colorNames: TStringList;
  i: Integer;
begin
  colorNames := TStringList.Create;
  colorNames.StrictDelimiter := true;
  colorNames.Delimiter:= GetDelimiter;
  for i := 0 to high(AValue) do
    colorNames.Add(LowerCase(BGRAToStr(AValue[i], CSSColors)));
  RawString[AName] := colorNames.DelimitedText;
  colorNames.Free;
end;

function TBGRACustomOriginalStorage.GetInteger(AName: utf8string): integer;
begin
  result := GetIntegerDef(AName,0);
end;

function TBGRACustomOriginalStorage.GetPointF(AName: utf8string): TPointF;
var
  s: String;
  posComma: integer;
begin
  s := RawString[AName];
  posComma := pos(GetDelimiter,s);
  if posComma = 0 then
    exit(EmptyPointF);

  result.x := StrToFloat(copy(s,1,posComma-1), FFormats);
  result.y := StrToFloat(copy(s,posComma+1,length(s)-posComma), FFormats);
end;

function TBGRACustomOriginalStorage.GetSingle(AName: utf8string): single;
begin
  result := GetSingleDef(AName, EmptySingle);
end;

procedure TBGRACustomOriginalStorage.SetInteger(AName: utf8string;
  AValue: integer);
begin
  RawString[AName] := IntToStr(AValue);
end;

procedure TBGRACustomOriginalStorage.SetPointF(AName: utf8string;
  AValue: TPointF);
begin
  if isEmptyPointF(AValue) then RemoveAttribute(AName)
  else RawString[AName] := FloatToStrF(AValue.x, ffGeneral,7,3, FFormats)+GetDelimiter+FloatToStrF(AValue.y, ffGeneral,7,3, FFormats);
end;

procedure TBGRACustomOriginalStorage.SetSingle(AName: utf8string; AValue: single);
begin
  if AValue = EmptySingle then RemoveAttribute(AName)
  else RawString[AName] := FloatToStrF(AValue, ffGeneral,7,3, FFormats);
end;

constructor TBGRACustomOriginalStorage.Create;
begin
  FFormats := DefaultFormatSettings;
  FFormats.DecimalSeparator := '.';
end;

{ TBGRALayerCustomOriginal }

procedure TBGRALayerCustomOriginal.SetOnChange(AValue: TOriginalChangeEvent);
begin
  if FOnChange=AValue then Exit;
  FOnChange:=AValue;
end;

function TBGRALayerCustomOriginal.GetGuid: TGuid;
begin
  result := FGuid;
end;

procedure TBGRALayerCustomOriginal.SetGuid(AValue: TGuid);
begin
  FGuid := AValue;
end;

procedure TBGRALayerCustomOriginal.NotifyChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

procedure TBGRALayerCustomOriginal.NotifyChange(ABounds: TRectF);
begin
  if Assigned(FOnChange) then
    FOnChange(self, @ABounds);
end;

procedure TBGRALayerCustomOriginal.NotifyEditorChange;
begin
  if Assigned(FOnEditingChange) then
    FOnEditingChange(self);
end;

constructor TBGRALayerCustomOriginal.Create;
begin
  FGuid := GUID_NULL;
end;

destructor TBGRALayerCustomOriginal.Destroy;
begin
  inherited Destroy;
end;

procedure TBGRALayerCustomOriginal.ConfigureEditor(AEditor: TBGRAOriginalEditor);
begin
  //nothing
end;

procedure TBGRALayerCustomOriginal.LoadFromFile(AFilenameUTF8: string);
var
  s: TFileStreamUTF8;
begin
  s := TFileStreamUTF8.Create(AFilenameUTF8, fmOpenRead, fmShareDenyWrite);
  try
    LoadFromStream(s);
  finally
    s.Free;
  end;
end;

procedure TBGRALayerCustomOriginal.LoadFromStream(AStream: TStream);
var storage: TBGRAMemOriginalStorage;
  memDir: TMemDirectory;
begin
  memDir := TMemDirectory.Create;
  storage := nil;
  try
    memDir.LoadFromStream(AStream);
    storage := TBGRAMemOriginalStorage.Create(memDir);
    if storage.RawString['class'] <> StorageClassName then
      raise exception.Create('Invalid class');
    LoadFromStorage(storage);
    FreeAndNil(storage);
  finally
    storage.Free;
    memDir.Free;
  end;
end;

procedure TBGRALayerCustomOriginal.LoadFromResource(AFilename: string);
var
  stream: TStream;
begin
  stream := BGRAResource.GetResourceStream(AFilename);
  try
    LoadFromStream(stream);
  finally
    stream.Free;
  end;
end;

procedure TBGRALayerCustomOriginal.SaveToFile(AFilenameUTF8: string);
var
  s: TFileStreamUTF8;
begin
  s := TFileStreamUTF8.Create(AFilenameUTF8, fmCreate);
  try
    SaveToStream(s);
  finally
    s.Free;
  end;
end;

procedure TBGRALayerCustomOriginal.SaveToStream(AStream: TStream);
var storage: TBGRAMemOriginalStorage;
  memDir: TMemDirectory;
begin
  memDir := TMemDirectory.Create;
  storage := nil;
  try
    storage := TBGRAMemOriginalStorage.Create(memDir);
    storage.RawString['class'] := StorageClassName;
    SaveToStorage(storage);
    FreeAndNil(storage);
    memDir.SaveToStream(AStream);
  finally
    storage.Free;
    memDir.Free;
  end;
end;

function TBGRALayerCustomOriginal.CreateEditor: TBGRAOriginalEditor;
begin
  result := TBGRAOriginalEditor.Create;
end;

function TBGRALayerCustomOriginal.Duplicate: TBGRALayerCustomOriginal;
var
  storage: TBGRAMemOriginalStorage;
  c: TBGRALayerOriginalAny;
begin
  c := FindLayerOriginalClass(StorageClassName);
  if c = nil then raise exception.Create('Original class is not registered');
  storage := TBGRAMemOriginalStorage.Create;
  try
    SaveToStorage(storage);
    result := c.Create;
    result.LoadFromStorage(storage);
  finally
    storage.Free;
  end;
end;

{ TBGRALayerImageOriginal }

function TBGRALayerImageOriginal.GetImageHeight: integer;
begin
  result := FImage.Height;
end;

function TBGRALayerImageOriginal.GetImageWidth: integer;
begin
  result := FImage.Width;
end;

procedure TBGRALayerImageOriginal.ContentChanged;
begin
  FContentVersion += 1;
  NotifyChange;
end;

constructor TBGRALayerImageOriginal.Create;
begin
  inherited Create;
  FImage := TBGRABitmap.Create;
  FContentVersion := 0;
  FJpegStream := nil;
end;

destructor TBGRALayerImageOriginal.Destroy;
begin
  FImage.Free;
  FJpegStream.Free;
  inherited Destroy;
end;

procedure TBGRALayerImageOriginal.Render(ADest: TBGRABitmap;
  AMatrix: TAffineMatrix; ADraft: boolean);
var resampleFilter: TResampleFilter;
begin
  if ADraft then resampleFilter := rfBox else resampleFilter:= rfCosine;
  if Assigned(FImage) then
    ADest.PutImageAffine(AMatrix, FImage, resampleFilter, dmSet);
end;

function TBGRALayerImageOriginal.GetRenderBounds(ADestRect: TRect;
  AMatrix: TAffineMatrix): TRect;
var
  aff: TAffineBox;
begin
  if Assigned(FImage) then
  begin
    aff := AMatrix*TAffineBox.AffineBox(PointF(0,0),PointF(FImage.Width,0),PointF(0,FImage.Height));
    result := aff.RectBounds;
  end else
    result := EmptyRect;
end;

procedure TBGRALayerImageOriginal.LoadFromStorage(
  AStorage: TBGRACustomOriginalStorage);
var imgStream: TMemoryStream;
begin
  if not Assigned(FImage) then FImage := TBGRABitmap.Create;
  imgStream := TMemoryStream.Create;
  try
    if AStorage.ReadFile('content.png', imgStream) then
    begin
      imgStream.Position:= 0;
      FImage.LoadFromStream(imgStream);
      FreeAndNil(FJpegStream);
    end else
    if AStorage.ReadFile('content.jpg', imgStream) then
    begin
      FreeAndNil(FJpegStream);
      FJpegStream := imgStream;
      imgStream:= nil;

      FJpegStream.Position:= 0;
      FImage.LoadFromStream(FJpegStream);
    end else
    begin
      FImage.SetSize(0,0);
      FreeAndNil(FJpegStream);
    end;
    FContentVersion := AStorage.Int['content-version'];
  finally
    imgStream.Free;
  end;
end;

procedure TBGRALayerImageOriginal.SaveToStorage(
  AStorage: TBGRACustomOriginalStorage);
var imgStream: TMemoryStream;
begin
  if Assigned(FImage) then
  begin
    if FContentVersion > AStorage.Int['content-version'] then
    begin
      if Assigned(FJpegStream) then
      begin
        AStorage.WriteFile('content.jpg', FJpegStream, false);
        AStorage.RemoveFile('content.png');
        AStorage.Int['content-version'] := FContentVersion;
      end else
      begin
        imgStream := TMemoryStream.Create;
        try
          FImage.SaveToStreamAsPng(imgStream);
          AStorage.RemoveFile('content.jpg');
          AStorage.WriteFile('content.png', imgStream, false);
          AStorage.Int['content-version'] := FContentVersion;
        finally
          imgStream.Free;
        end;
      end;
    end;
  end;
end;

procedure TBGRALayerImageOriginal.LoadFromStream(AStream: TStream);
begin
  if TMemDirectory.CheckHeader(AStream) then
    inherited LoadFromStream(AStream)
  else
    LoadImageFromStream(AStream);
end;

procedure TBGRALayerImageOriginal.LoadImageFromStream(AStream: TStream);
var
  newJpegStream: TMemoryStream;
begin
  if DetectFileFormat(AStream) = ifJpeg then
  begin
    newJpegStream := TMemoryStream.Create;
    try
      newJpegStream.CopyFrom(AStream, AStream.Size);
      newJpegStream.Position := 0;
      FImage.LoadFromStream(newJpegStream);
      FJpegStream.Free;
      FJpegStream := newJpegStream;
      newJpegStream := nil;
    finally
      newJpegStream.Free;
    end;
  end else
  begin
    FreeAndNil(FJpegStream);
    FImage.LoadFromStream(AStream);
  end;
  ContentChanged;
end;

procedure TBGRALayerImageOriginal.SaveImageToStream(AStream: TStream);
begin
  if Assigned(FJpegStream) then
  begin
    FJpegStream.Position := 0;
    if AStream.CopyFrom(FJpegStream, FJpegStream.Size)<>FJpegStream.Size then
      raise exception.Create('Error while saving');
  end else
    FImage.SaveToStreamAsPng(AStream);
end;

class function TBGRALayerImageOriginal.StorageClassName: RawByteString;
begin
  result := 'image';
end;

initialization

  RegisterLayerOriginal(TBGRALayerImageOriginal);

end.

