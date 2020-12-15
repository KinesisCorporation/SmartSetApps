program SmartSetMaster;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uecontrols, u_form_dashboard, u_const, u_form_loading, InfoDialog,
  unit1;

{$R *.res}

begin
  {$if declared(UseHeapTrace)}
  GlobalSkipIfNoLeaks := true;
  if (GDevMode) then
    SetHeapTraceOutput('trace.log')
  else
    UseHeapTrace := false;
  {$endif}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormDashboard, FormDashboard);
  Application.CreateForm(TFormInfoDialog, FormInfoDialog);
  Application.Run;
end.

