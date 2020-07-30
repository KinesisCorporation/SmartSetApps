unit u_common_ui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, graphics, controls, HSSpeedButton, extctrls;

var
  com_ui:integer;
  procedure LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);

implementation

procedure LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);
begin
  if (obj is THSSpeedButton) then
  begin
    if (idx = -1) then
      (obj as THSSpeedButton).Glyph.Clear
    else
      imgList.GetBitmap(idx, (obj as THSSpeedButton).Glyph)
  end
  else if (obj is TImage) then
  begin
    if (idx = -1) then
      (obj as TImage).Picture.Clear
    else
      imgList.GetBitmap(idx, (obj as TImage).Picture.Bitmap);
  end;
  (obj as TControl).Repaint;
end;

end.

