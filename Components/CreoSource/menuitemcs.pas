unit MenuItemCS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Menus,
  LCLType;

type
  TMenuItemCS = class(TMenuItem)
  private
    procedure OnDrawItem(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; AState: TOwnerDrawState);
  protected

  public

  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CS',[TMenuItemCS]);
end;

procedure TMenuItemCS.OnDrawItem(Sender: TObject; ACanvas: TCanvas;
    ARect: TRect; AState: TOwnerDrawState);
var
  mnu: TMenuItem;
begin
  mnu := (sender as TMenuItem);
  aCanvas.brush.color := KINESIS_DARK_GRAY_RGB;
  acanvas.brush.style := bsSolid;
  if (odSelected in AState) then
    aCanvas.font.color := KINESIS_BLUE_EDGE
  else
    aCanvas.font.color := KINESIS_FONT_COLOR_RGB;
  aCanvas.Font.Name := self.Font.Name;
  aCanvas.Font.Size := 12;
  aCanvas.fillrect( aRect );
  acanvas.textrect( aRect, arect.left+4, arect.top+2, mnu.caption );
end;

end.
