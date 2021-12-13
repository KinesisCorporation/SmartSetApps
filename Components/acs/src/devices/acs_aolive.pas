(*
libao: a cross platform audio library

This file is a part of Audio Components Suite.
Copyright (C) 2002-2005 Andrei Borovsky. All rights reserved.
See the license file for more details.
This is the ACS for Linux version of the unit.
*)

unit acs_aolive;

interface

{$ifdef LINUX}
{$ifdef mswindows}{$message error 'unit not supported'}{$endif}

uses
  Classes, ACS_Classes, ACS_Audio, libao, SysUtils, ACS_Strings, ACS_Types, ACS_Procs;

const
  LATENCY = 45; //how to measure ?

type

  { TAOLiveAudioOut }

  TAOLiveAudioOut = class(TAcsAudioOutDriver)
  private
    _device: PAODevice;
    FVolume: Byte;
    FDrivers: TStringList;
    FCurrentDriver: String;
    FDefaultDriver: String;
    function IsDevicePlayable(const Dev: String): Boolean;
  protected
    procedure Init(); override;
    function DoOutput(Abort: Boolean): Boolean; override;
    procedure Done(); override;
    procedure SetDevice(Ch: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  end;

{$endif LINUX}

implementation

{$ifdef LINUX}

{$DEFINE SEARCH_LIBS}
var
  LibaoLoaded: Boolean = False;
  Libhandle: Pointer;
{$IFDEF SEARCH_LIBS}
  LibPath: string;
{$ENDIF}

procedure FreeOptionsList(var OL: PAOOption);
var
  NextOpt, tmp: PAOOption;
begin
  if OL = nil then Exit;
  NextOpt:=OL;
  repeat
    tmp:=NextOpt;
    NextOpt:=NextOpt.next;
    FreeMem(tmp);
  until NextOpt = nil;
end;

constructor TAOLiveAudioOut.Create(AOwner: TComponent);
var
  DrList: PPAOInfo;
  DrCount, i: Integer;
  Info: PAOInfo;
begin
  if not LibaoLoaded then
    raise EACSException.Create(Format(strCoudntloadlib, [LibaoPath]));
  inherited Create(AOwner);
  if AOInitialized = 0 then ao_initialize();
  Inc(AOInitialized);
  FDrivers:=TStringList.Create();
  DrList:=ao_driver_info_list(DrCount);
  for i:=0 to DrCount-1 do
  begin
    if DrList^._type = AO_TYPE_LIVE then
    begin
      FDrivers.Add(String(DrList^.short_name));
    end;
    Inc(DrList);
  end;
  Info:=ao_driver_info(ao_default_driver_id);
  FDefaultDriver:=Info.short_name;
  FVolume:=255;
end;

destructor TAOLiveAudioOut.Destroy();
begin
  FDrivers.Free();
  if AOInitialized = 1 then ao_shutdown();
  Dec(AOInitialized);
  inherited Destroy();
end;

procedure TAOLiveAudioOut.SetDevice(Ch: Integer);
begin
  if ch < FDrivers.Count-1 then
    if IsDevicePlayable(FDrivers[ch]) then
      FCurrentDriver:=FDrivers[ch];
end;

procedure TAOLiveAudioOut.Init();
var
  did: Integer;
  sf: ao_sample_format;
  opt: PAOOption;
  Info: PAOInfo;
begin
  inherited Init();
  if FCurrentDriver = '' then
  begin
    did:=ao_default_driver_id;
    Info:=ao_driver_info(did);
    FCurrentDriver:=Info.short_name;
  end
  else
    did:=ao_driver_id(@FCurrentDriver[1]);
  opt:=nil;
  sf.bits:=FInput.BitsPerSample;
  sf.rate:=FInput.SampleRate;
  sf.channels:=FInput.Channels;
  sf.byte_format:=AO_FMT_NATIVE;
  _device:=ao_open_live(did, @sf, opt);
  //FreeOptionsList(Opt);  // may be dangerously
  if _device = nil then
    raise EACSException.Create(Format(strDevnotplayable, ['+FCurrentDriver+']));
end;

procedure TAOLiveAudioOut.Done();
begin
  if _device <> nil then ao_close(_device);
  inherited Done();
end;

function TAOLiveAudioOut.DoOutput(Abort: Boolean): Boolean;
var
  Len, i: Integer;
  P8: PACSBuffer8;
  P16: PACSBuffer16;
begin
  // No exceptions Here
  Result:=True;
  if not CanOutput then Exit;
  Len:=0;
  if Abort then
  begin
    ao_close(_device);
    _device:=nil;
    Result:=False;
    Exit;
  end;
  try
    Len:=FillBufferFromInput();
    if FVolume < 255 then
    begin
      if FInput.BitsPerSample = 16 then
      begin
        P16:=FBuffer.Memory;
        for i:=0 to (Len div 2)-1 do
        P16[i]:=Round(P16[i] * (FVolume / 255));
      end else
      begin
        P8:=FBuffer.Memory;
        for i:=0 to Len-1 do
        P8[i]:=Round(P8[i] * (FVolume / 255));
      end;
    end;
    ao_play(_device, FBuffer.Memory, Len);
  except
  end;
  Result:=(Len > 0);
end;

function TAOLiveAudioOut.IsDevicePlayable(const Dev: String): Boolean;
var
  i, did: Integer;
  sf: ao_sample_format;
  opt: PAOOption;
begin
  Result:=True;
  if Dev = '' then Exit;
  if Active then
    raise EACSException.Create(strBusy);
  for i:=0 to FDrivers.Count-1 do
  if FDrivers.Strings[i] = Dev then
  begin
    did:=ao_driver_id(@Dev[1]);
    sf.bits:=16;
    sf.rate:=22050;
    sf.channels:=2;
    sf.byte_format:=AO_FMT_NATIVE;
    opt:=nil;
    _device:=ao_open_live(did, @sf, opt);
    if _device <> nil then
    begin
      ao_close(_device);
      //FreeOptionsList(Opt);
      Exit;
    end
    else Break;
  end;
  Result:=False;
end;

initialization

  if LoadAOLibrary() then
  begin
    LibaoLoaded := True;
    RegisterAudioOut('AOLive', TAOLiveAudioOut, LATENCY);
  end;

finalization

  UnloadAOLibrary();

{$endif LINUX}

end.

