program SmartSetFSEdge;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  richmemopackage, u_form_main, u_const;

{$R *.res}
begin
  Application.Title:='SmartSet App-Freestyle';
  GApplication := APPL_FSEDGE; //APPL_FSPRO;
  GApplicationName := 'SmartSet App';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

