Program gifview;

{$mode objfpc}{$H+}

Uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm, uErrorBoxForm
  { you can add units after this };

{$R *.res}


Begin
  Application.Scaled := True;
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TErrorBoxForm, ErrorBoxForm);
  Application.Run;
End.

