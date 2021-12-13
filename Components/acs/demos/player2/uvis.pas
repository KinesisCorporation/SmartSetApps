unit uvis;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  LResources,FPImage,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus, ExtCtrls;

type
  TVals = array of Double;

  { TfVizu }

  TfVizu = class(TForm)
    Image: TImage;
    MainMenu1: TMainMenu;
    rFFT: TMenuItem;
    MenuItem2: TMenuItem;
    miType: TMenuItem;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    lVals: array of TVals;
    Vals: TVals;
    ValCount: integer;
  public
    { public declarations }
  end;

var
  fVizu: TfVizu;

implementation

uses uMain;

{ TfVizu }

procedure TfVizu.FormPaint(Sender: TObject);
var
  i,x,y,m : Integer;
  {$IFDEF FPC}
  newcolor : TFPColor;
  d, dValue: Double;
  {$ENDIF}
begin
  SetLength(Vals, ValCount);
  fMain.SoundIndicator.GetValues(Vals);
  Canvas.Lock;
  Canvas.Brush.Color := clBlack;
  Canvas.Pen.Color := clBlack;
  Canvas.Rectangle(0, 0, Width, Height);
  if rFFT.Checked then
  begin
    Canvas.Pen.Color := clAqua;
    Canvas.Brush.Color := clAqua;
    for i := 0 to ValCount-1 do
    begin
      Canvas.Rectangle(((Width div ValCount)*i)+1, Height-Round(Vals[i]*Height), ((Width div ValCount)*(i+1))-1, Height);
    end;
  end

  else
  begin
    {$IFDEF FPC}
    m := Height div 4;
    SetLength(lVals, m);
    for i := m-1 downto 0 do
    begin
      if Length(lVals[i]) <> ValCount then SetLength(lVals[i], ValCount);
      if i < m-1 then lVals[i+1]:=lVals[i];
    end;
    lVals[0]:=Copy(Vals, 0, ValCount);
    for y := 0 to m-1 do
    begin
      for x := 0 to ValCount-1 do
      begin
        d:=lVals[m-1-y][x];
        newcolor := TColorToFPColor(clBlack);
        newcolor.blue := round(65535*d);
        newcolor.green := round(65535*d);
        Canvas.Brush.Color := FPColorToTColor(newcolor);
        newcolor.blue := round(32000*d);
        newcolor.green := round(32000*d);
        Canvas.Pen.Color := FPColorToTColor(newcolor);
        Canvas.Rectangle(((Width div ValCount)*x),y*4,((Width div ValCount)*(x+1)),((y+1)*4));
      end;
    end;
    {$ENDIF}
  end;
  Canvas.Unlock;
end;

procedure TfVizu.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  ValCount:=fMain.SoundIndicator.ValuesCount;
end;

procedure TfVizu.Timer1Timer(Sender: TObject);
begin
  if fVizu.Visible then
    fVizu.Invalidate;
end;

initialization
{$IFDEF FPC}
  {$I uvis.lrs}
{$else}
  {$R *.dfm}
{$ENDIF}

end.

