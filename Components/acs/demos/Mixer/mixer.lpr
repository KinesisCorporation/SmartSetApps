program mixer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }
  ,uMixer;

//{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

begin
  Application.Title:='Lazarus Mixer Example';
  Application.Initialize;
  Application.CreateForm(TfMixer, fMixer);
  Application.Run;
end.

