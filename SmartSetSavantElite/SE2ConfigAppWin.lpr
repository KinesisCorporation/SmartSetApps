program SE2ConfigAppWin;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, richmemopackage, u_keys, u_key_service, u_const, u_debug,
  u_form_keypress, u_file_service, u_form_about, VersionSupport, UserDialog,
  u_keyexception;

{$R *.res}

begin
  Application.Title:='SE2 SmartSet App (Mac)';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFormKeyPress, FormKeyPress);
  Application.Run;
end.

