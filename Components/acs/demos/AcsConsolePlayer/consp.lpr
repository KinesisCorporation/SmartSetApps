program consp;

{ ACS Console audio player }
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,
  acs_file, acs_audio, // audio in/out, file in/out
  acs_allformats, // all files formats
  acs_stdaudio, laz_acs_lib; // standard audio driver

type

  { TAcsApplication }

  TAcsApplication = class(TCustomApplication)
  private
    AudioOut: TAcsAudioOut;
    FileIn: TAcsFileIn;
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

{ TAcsApplication }

procedure TAcsApplication.DoRun;
begin
  // parse parameters
  if (ParamCount < 1) or HasOption('h','help') then
  begin
    WriteLn('Usage: ', ExtractFileName(ExeName),' <audio_file_name>');
    Terminate;
    Exit;
  end;

  { add your program here }
  FileIn.FileName := Params[1];
  AudioOut.Run();
  while AudioOut.Active do
  begin
    Sleep(10);
  end;

  // stop program loop
  Terminate;
end;

constructor TAcsApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
  // create simple processing chain FileIn -> AudioOut
  FileIn := TAcsFileIn.Create(nil);
  AudioOut := TAcsAudioOut.Create(nil);
  AudioOut.Input := FileIn;
end;

destructor TAcsApplication.Destroy;
begin
  FreeAndNil(AudioOut);
  FreeAndNil(FileIn);
  inherited Destroy;
end;

var
  Application: TAcsApplication;
begin
  Application:=TAcsApplication.Create(nil);
  Application.Title:='ACS Example';
  Application.Run;
  Application.Free;
end.

