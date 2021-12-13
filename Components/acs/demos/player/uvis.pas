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
  TVals = array[0..31] of Double;

  { TfVizu }

  TfVizu = class(TForm)
    Image: TImage;
    MainMenu1: TMainMenu;
    rFFT: TMenuItem;
    MenuItem2: TMenuItem;
    miType: TMenuItem;
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    lVals : array of TVals;
    Vals : TVals;
  end;

var
  fVizu: TfVizu;

implementation

uses uMain;

{ TfVizu }

procedure TfVizu.FormPaint(Sender: TObject);
var
  i,x,y : Integer;
  {$IFDEF FPC}
  newcolor : TFPColor;
  {$ENDIF}
begin
  Canvas.Lock;
  Canvas.Brush.Color := clBlack;
  Canvas.Pen.Color := clBlack;
  Canvas.Rectangle(0,0,Width,Height);
  if rFFT.Checked then
    begin
      fMain.SoundIndicator.GetValues(Vals);
      Setlength(lVals,0);
      Canvas.Pen.Color := clAqua;
      Canvas.Brush.Color := clAqua;
      for i := 0 to 31 do
        Canvas.Rectangle(((Width div 31)*i)+1,Height-Round(Vals[i]*Height),((Width div 31)*(i+1))-1,Height);
    end
  else
    begin
      {$IFDEF FPC}
      Setlength(lVals,Height div 4);
      for i := 0 to length(lVals)-2 do
        lVals[i] := lVals[i+1];
      fMain.SoundIndicator.GetValues(lVals[length(lVals)-1]);
      for y := 0 to (Height div 4)-1 do
        for x := 0 to 31 do
          begin
            newcolor := TColorToFPColor(clBlack);
            newcolor.blue := round(65535*lVals[y][x]);
            newcolor.green := round(65535*lVals[y][x]);
            Canvas.Brush.Color := FPColorToTColor(newcolor);
            newcolor.blue := round(32000*lVals[y][x]);
            newcolor.green := round(32000*lVals[y][x]);
            Canvas.Pen.Color := FPColorToTColor(newcolor);
            Canvas.Rectangle(((Width div 31)*x),y*4,((Width div 31)*(x+1)),((y+1)*4));
          end;
      {$ENDIF}
    end;
  Canvas.Unlock;
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

