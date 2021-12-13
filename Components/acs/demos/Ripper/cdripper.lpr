program cdripper;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }
  ,uMain;

//{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

begin
  Application.Title:='Lazarus cd Ripper Example';
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.

