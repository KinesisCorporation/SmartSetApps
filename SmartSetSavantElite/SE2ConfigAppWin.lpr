program SE2ConfigAppWin;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, richmemopackage, u_debug,
  u_form_keypress, u_form_about, VersionSupport,
  u_keyexception;

{$R *.res}

begin
  Application.Title:='SE2 SmartSet App (Mac)';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFormMainSE2, FormMainSE2);
  Application.Run;
end.

