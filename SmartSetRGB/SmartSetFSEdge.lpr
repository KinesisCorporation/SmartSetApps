program SmartSetFSEdge;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,  // this includes the LCL widgetset
  dialogs, Forms, u_const,
  u_form_main_rgb, u_form_intro;

{$R *.res}
begin
  if GDebugMode then
    ShowMessage('App Start');
  {$if declared(UseHeapTrace)}
  GlobalSkipIfNoLeaks := true;
  if (GDevMode) then
    SetHeapTraceOutput('trace.log')
  else
    UseHeapTrace := false;
  {$endif}
  Application.Title:='SmartSet App-Freestyle';
  GApplication := APPL_RGB;
  GApplicationName := 'SmartSet App';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFormMainRGB, FormMainRGB);
  Application.Run;
end.

