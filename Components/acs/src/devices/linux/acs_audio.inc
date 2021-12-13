(*
  Linux standard audio

  This file is a part of Audio Components Suite.
  Copyright (C) 2002-2005 Andrei Borovsky. All rights reserved.
  See the license file for more details.
  This is the ACS for Linux version of the unit.
*)

const
  MAX_CHANNELS = 16; // Maximum number of audio channels/devices
  O_RDONLY = 0;
  O_WRONLY = 1;
  //libname = 'libc.so.6';

var
  AudioChannels: array[0..MAX_CHANNELS-1] of String;

(* We import libc functions directly to avoid Kylix
  Libc unit limitations *)

//function __write(fd: Integer; data: Pointer; size: Integer): Integer; cdecl; external libname;
//function __read(Handle: Integer; var Buffer; Count: Integer): Integer; cdecl; external libname;
//function ioctl(fd: Integer; command: Integer): Integer; varargs; cdecl; external libname;
//function open(PathName: PChar; Flags: Integer): Integer; varargs; cdecl; external libname;
//function __close(Handle: Integer): Integer; cdecl; external libname;


function GetAudioDeviceInfo(DevID: Integer; OutputDev: Boolean): TAcsDeviceInfo;
begin
  Result.DeviceName:='/dev/dsp'+IntToStr(DevID);
  Result.DrvVersion:=0;
  Result.Formats:=[];
  Result.Stereo:=True;
end;

{ TStdAudioOut }

constructor TStdAudioOut.Create();
begin
  inherited Create(AOwner);
  FVolume:=255;
  FBufferSize:=$8000;
  _audio_fd:=-1;
end;

destructor TStdAudioOut.Destroy();
begin
  if _audio_fd > 0 then fpclose(_audio_fd);
  inherited Destroy;
end;

procedure TStdAudioOut.SetDevice();
begin
  if Active then
    raise EACSException.Create(strBusy);
  if Ch < OutputChannelsCount then
    FBaseChannel:=Ch
  else
    raise EACSException.Create(Format(strChannelnotavailable, [ch]));
end;

procedure TStdAudioOut.Init();
var
  parm: Integer;
begin
  inherited Init();
  // No exceptions here!
  case FInput.BitsPerSample of
    8:  parm := AFMT_U8;
    16: parm := AFMT_S16_LE;
  end;
  _audio_fd:=fpopen(PChar(AudioChannels[FBaseChannel]), O_WRONLY);
  fpioctl(_audio_fd, TIOCtlRequest(SNDCTL_DSP_SETFMT), @parm);
  parm:=FInput.Channels;
  fpioctl(_audio_fd, TIOCtlRequest(SNDCTL_DSP_CHANNELS), @parm);
  parm:=FInput.SampleRate;
  fpioctl(_audio_fd, TIOCtlRequest(SNDCTL_DSP_SPEED), @parm);
end;

procedure TStdAudioOut.Done();
begin
  fpclose(_audio_fd);
  _audio_fd:=-1;
  inherited Done();
end;

function TStdAudioOut.DoOutput();
var
  Len, i, VCoef: Integer;
  P8 : PACSBuffer8;
  P16 : PACSBuffer16;
begin
  // No exceptions Here
  Result := True;
  if not CanOutput then Exit;
  if Abort then
  begin
    fpclose(_audio_fd);
    Result:=False;
    Exit;
  end;
  Len:=0;
  try
    while InputLock do;
    InputLock:=True;
    //Len:=FInput.GetData(FBuffer.Memory, FBuffer.Size);
    Len:=FInput.GetData(FBuffer);
    InputLock:=False;
    if FVolume < 255 then
    begin
      VCoef:=Round(FVolume / 255);
      if FInput.BitsPerSample = 16 then
      begin
        P16:=FBuffer.Memory;
        for i:=0 to (Len div 2)-1 do P16[i]:=P16[i] * VCoef;
      end
      else
      begin
        P8:=FBuffer.Memory;
        for i:=0 to Len-1 do
        P8[i]:=P8[i] * VCoef;
      end;
    end;
    fpwrite(_audio_fd, FBuffer.Memory, FBuffer.Size);
  except
  end;
  Result:=(Len > 0);
end;

{ TStdAudioIn }

destructor TStdAudioIn.Destroy();
begin
  CloseAudio();
  inherited Destroy();
end;

procedure TStdAudioIn.OpenAudio();
begin
  if FOpened = 0 then
    _audio_fd:=fpopen(PChar(AudioChannels[FBaseChannel]), O_RDONLY);
  Inc(FOpened);
end;

procedure TStdAudioIn.CloseAudio();
begin
  if FOpened = 1 then fpclose(_audio_fd);
  if FOpened > 0 then Dec(FOpened);
end;

function TStdAudioIn.GetBPS();
var
  BPS: Integer;
begin
  OpenAudio();
  BPS:=FBPS;
  if not (BPS in [8, 16]) then BPS:=16;
  fpioctl(_audio_fd, TIOCtlRequest(SNDCTL_DSP_SETFMT), @BPS);
  FBPS:=BPS;
  Result:=BPS;
  CloseAudio();
end;

function TStdAudioIn.GetCh();
var
  Ch: Integer;
begin
  OpenAudio();
  Ch:=FChan;
  fpioctl(_audio_fd, TIOCtlRequest(SNDCTL_DSP_CHANNELS), @Ch);
  FChan:=Ch;
  Result:=Ch;
  CloseAudio();
end;

function TStdAudioIn.GetSR();
var
  SR: Integer;
begin
  OpenAudio;
  SR:=FSampleRate;
  fpioctl(_audio_fd, TIOCtlRequest(SNDCTL_DSP_SPEED), @SR);
  FSampleRate:=SR;
  Result:=SR;
  CloseAudio();
end;

procedure TStdAudioIn.Init();
begin
  inherited Init();
  BufferSize:=$8000;
  OpenAudio();
  FRecBytes:=Round(FRecTime * (GetBPS div 8) * GetCh() * GetSR());
end;

procedure TStdAudioIn.Done();
begin
  CloseAudio();
  inherited Done();
end;

procedure TStdAudioIn.SetDevice();
begin
  if Ch > (OutputChannelsCount - 1) then
    if not (csDesigning in ComponentState) then
      raise EACSException.Create(Format(strChannelnotavailable, [Ch]));
  FBaseChannel:=Ch;
end;

function TStdAudioIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  l: Integer;
begin
  if not Active then
    raise EACSException.Create(strStreamnotOpen);
  if (FRecBytes >= 0) and (FPosition >= FRecBytes) then
  begin
    Result:=0;
    Exit;
  end;
  if BufStart > BufEnd then
  begin
    BufStart:=1;
    l:=fpread(_audio_fd, FBuffer[BufStart], ABufferSize);
    if l < 1 then
    begin
      Result:=0;
      Exit;
    end
    else
      BufEnd:=l;
  end;
  if ABufferSize < (BufEnd - BufStart + 1) then
    Result:=ABufferSize
  else
    Result:=BufEnd - BufStart + 1;
  Move(FBuffer[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  Inc(FPosition, Result);
end;

procedure CountChannels();
var
  i, fd: Integer;
  fname: String;
begin
  OutputChannelsCount:=0;
  fname:='/dev/dsp0';
  fd:=fpopen(PChar(fname), O_RDONLY);
  if fd < 0 then
  begin
    //  Under ALSA there is no /dev/dsp0 device
    fname:='/dev/dsp';
    fd:=fpopen(PChar(fname), O_RDONLY);
    if fd < 0 then Exit;
  end;
  AudioChannels[OutputChannelsCount]:=fname;
  fpclose(fd);
  Inc(OutputChannelsCount);
  for i:=1 to MAX_CHANNELS-2 do
  begin
    fname:='/dev/dsp' + IntToStr(i);
    fd:=fpopen(PChar(fname), O_RDONLY);
    if fd < 0 then Break;
    fpclose(fd);
    AudioChannels[OutputChannelsCount]:=fname;
    Inc(OutputChannelsCount);
  end;
end;

