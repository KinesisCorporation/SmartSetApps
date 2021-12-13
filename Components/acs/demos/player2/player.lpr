program player;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }
  ,uMain
  ,uPlaylist
  ,uVis;

//{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

begin
  Application.Title:='Lazarus Player Example';
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TfPlaylist, fPlaylist);
  Application.CreateForm(TfVizu, fVizu);
  Application.Run;
end.

