(*
DirectX audio in/out components

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

{
Status:
TDXAudioOut - AcsBuffer, fetch, test OK
TDXAudioIn - old buffer
}

unit acs_dxaudio;

interface

{$ifdef WINDOWS}
{$ifdef linux}{$message error 'unit not supported'}{$endif linux}
{$DEFINE USE_EXTENDED_SPEC_FOR_24_BPS }

uses
  ACS_Audio, SysUtils, Classes, ACS_Types, ACS_Classes, Windows,{$ifdef fpc}LazUTF8,{$endif}
  DSWrapper, ACS_Strings, DirectSound, mmsystem{$ifdef LCL},Forms{$endif};

const
  LATENCY = 25;

type

  { TDXAudioOut }
  (* Class: TDXAudioOut
    Performs audio playback using the DirectX API.
    TDXAudioOut component buffers its output in order to make it more smooth.
    This buffering introduces some delay at the beginning of the audio playback with TDXAudioOut.
    You can decrease the delay by decreasing the size of the TDXAudioOut buffer.
    The size of this buffer is set up by the DS_BUFFER_SIZE constant in the ACS_DxAudio.pas file.
    If you decrease the buffer size you may also want to decrease the
    DS_POLLING_INTERVAL value which determines how often the component requests
    data from its input. *)
  TDXAudioOut = class(TAcsAudioOutDriver)
  private
    DSW_Initialized: Boolean;
    FLatency: LongWord;
    FFramesInBuffer: LongWord;
    //FPollingInterval: LongWord;
    DSW: DSoundWrapper;
    Devices: DSW_Devices;
    Chan, SR, BPS: LongWord;
    EndOfInput, StartInput: Boolean;
    FDeviceNumber: Integer; // FBaseChannel
    //FDeviceCount: Integer;
    //_BufSize: Integer; // FBufSize
    FFillByte: Byte;
    FUnderruns, _TmpUnderruns: LongWord;
    FOnUnderrun: TNotifyEvent;
    FVolumeEx: longint; // DW - for more reliable volume control
    FSpeedFactor: Single;
  protected
    procedure SetDeviceNumber(i: Integer);
    function GetVolumeEx(): Integer;
    procedure SetVolumeEx(Value: Integer);
    procedure SetFramesInBuffer(Value: LongWord);
    // old
    procedure SetDevice(Ch: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    { Called from Thread }
    procedure Init(); override;
    function DoOutput(Abort: Boolean): Boolean; override;
    procedure Done(); override;
    procedure Pause(); override;
    procedure Resume(); override;
    (* Property: DeviceCount
         This read only property returns the number of logical output DirectSound devices. *)
    property DeviceCount: Integer read GetDeviceCount;
    (* Property: DeviceName
         This read only array property returns the name of the device
         specified by its number. Valid numbers range from 0 to
         <DeviceCount> - 1. *)
    property DeviceName[Number: Integer]: string read GetDeviceName;
    (* Property: Underruns
         This read only property returns the number of internal buffer
         underruns that have occurred during playback. *)
    property Underruns: LongWord read FUnderruns;
    (* Property: VolumeEx
         Use this property to set or get the volume of the sound being played.
         The default value is 0 which corresponds to the original volume of
         the sound. Valid values range from -10000 (silence) to 0. The Volume
         property allows you to make the played sound softer than the original
         one, but not louder. *)
    property VolumeEx: Integer read GetVolumeEx write SetVolumeEx;
  published
    (* Property: DeviceNumber
         Use this property to select the playback device by number. The
         default value is 0 which corresponds to the default audio output
         device in your system. Valid numbers range from 0 to <DeviceCount> -
         1. *)
    property DeviceNumber: Integer read FDeviceNumber write SetDeviceNumber;
    (* Property: Latency
         This property sets the audio latency (the delay between the moment the
         audio data is passed to the component and the moment it is played.
         The latency is set in milliseconds.
         This is a convenience property that overrides the <FramesInBuffer> and
         the <PollingInterval>. If the Latency is greater than zero these
         properties are ignored.
         The reasonable values for this property lie in the range
         between 50 (0.05 second) and 250 (0.25 second). *)
    property Latency: LongWord read FLatency write FLatency;
    (* Property: FramesInBuffer
         Use this property to set the length of the internal playback buffer.
         The duration of the buffer depends on this value and the sample rate.
         For example, if FramesInBuffer's value is 12000 and the sample rate is
         44100, the buffer duration is 12000/44100=0.272 sec.
         Smaller values result in lower latency and (possibly) more underruns.
         See also <PollingInterval>. *)
    property FramesInBuffer: LongWord read FFramesInBuffer write SetFramesInBuffer;
    (* Property: OnUnderrun
         OnUnderrun event is raised when the component has run out of data.
         This can happen if the component receives data at slow rate from a
         slow CD-ROM unit or a network link. You will also get OnUnderrun
         event when unpausing paused playback (this is a normal situation).
         Usually TDXAudioOut successfully recovers from underruns by itself,
         but this causes pauses in playback so if you start to receive
         OnUnderrun events, you may try to increase the speed rate of data
         passing to the component, if you can. Yo can check the <Underruns>
         property for the total number of underruns. *)
    property OnUnderrun: TNotifyEvent read FOnUnderrun write FOnUnderrun;
    property SpeedFactor: Single read FSpeedFactor write FSpeedFactor;
  end;

  { TDXAudioIn }
  (* Class: TDXAudioIn
      Performs audio recording from a sound card using the DirectX API.
      Descends from <TAcsAudioInDriver>. *)
  TDXAudioIn = class(TAcsAudioInDriver)
  private
    DSW: DSoundWrapper;
    FLatency: LongWord;
    Devices: DSW_Devices;
    FFramesInBuffer: LongWord;
    FDeviceNumber: Integer;
    FPollingInterval: Integer;
    //FDeviceCount: Integer;
    FOpened: Integer;
    FSamplesToRead: Int64;
    FRecTime: Integer;
    FOverruns: LongWord;
    FOnOverrun: TNotifyEvent;
    FEchoRecording: Boolean;
    FSampleSize: Integer;
    RecordingEchoed: Boolean;
    // old
    FBytesToRead : Integer;
    procedure SetDeviceNumber(i: Integer);
    procedure OpenAudio();
    procedure CloseAudio();
    procedure SetRecTime(aRecTime: Integer);
    procedure SetFramesInBuffer(Value: LongWord);
  protected
    procedure SetDevice(i: Integer); override;
    function GetDeviceName(ADeviceNumber: Integer): string; override;

    //function GetTotalTime : LongWord; override;
    //function GetTotalSamples: Int64; override;
    //procedure GetDataInternal(var Buffer: Pointer; var Bytes: LongWord); override;
    //procedure InitInternal; override;
    //procedure FlushInternal; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;

    //procedure Pause; override;
    //procedure Resume; override;
    (* Property: DeviceCount
         This read only property returns the number of logical DirectSound
         input devices. *)
    property DeviceCount: Integer read GetDeviceCount;
    (* Property: DeviceName[Number : Integer]
         This read only array property returns the name of the DeviceNumber
         specified by its number. Valid numbers range from 0 to
         <DeviceCount> - 1. *)
    property DeviceName[Number: Integer]: String read GetDeviceName;
    (* Property: Overruns
         This read only property returns the number of internal buffer
         overruns that have occurred during recording. *)
    property Overruns: LongWord read FOverruns;
  published
    (* Property: Latency
         This property sets the audio latency (the delay between the moment the audio data comes into the system and the moment it exits the component.
         The latency is set in milliseconds.
         This is a convenience property that overrides the <FramesInBuffer> and the <PollingInterval>. If the Latency is greater than zero these properties are ignored.
         The reasonable values for this property lie in the range between 50 (0.05 second) and 250 (0.25 second). *)
    property Latency: LongWord read FLatency write FLatency;
    (* Property: SamplesToRead
         Use this property to set the number of samples (frames) the component
         should record. If you set this property value to -1 the component
         will be endlessly recording until you stop it. *)
    property SamplesToRead: Int64 read FSamplesToRead write FSamplesToRead;
    (* Property: EchoRecording
         When this property is set to True, the component plays back audio data what is being recorded.
         Currently this option works only if you choose the primary recording driver as the input DeviceNumber.
         If you want to echo recording you should set this property to True before you start recording.
         Later you can set it to False to turn echoing off and then back to True to turn it on. *)
    property EchoRecording: Boolean read FEchoRecording write FEchoRecording;
    (* Property: FramesInBuffer
         Use this property to set the length of the internal recording buffer.
         The duration of the buffer depends on this value and the sample rate. For example
         if FramesInBuffer's value is 12000 and the sample rate is 44100, the buffer duration is
         12000/44100=0.272 sec.
         Smaller values result in lower latency and (possibly) more overruns. See also <PollingInterval>. *)
    property FramesInBuffer: LongWord read FFramesInBuffer write SetFramesInBuffer;
    (* Property: OnOverrun
         OnOverrun event is raised when this component provides data faster
         than the rest of audio-processing chain can consume. It indicates
         that some data is lost. You may also get OnOverrun event when
         unpausing paused recording (this is a normal situation). To get the
         total number of overruns read the <Overruns> property. *)
    property OnOverrun: TNotifyEvent read FOnOverrun write FOnOverrun;

  end;

{$endif WINDOWS}

implementation

{$ifdef WINDOWS}

function DSErrToString(Res: HRESULT): string;
begin
  Result:='Unknown';
  if Res = HRESULT(DSERR_ALLOCATED) then Result:='The request failed because resources, such as a priority level, were already in use by another caller.';
  if Res = HRESULT(DSERR_ALREADYINITIALIZED) then Result:='The object is already initialized.';
  if Res = HRESULT(DSERR_BADFORMAT) then Result:='The specified wave format is not supported.';
  if Res = HRESULT(DSERR_BUFFERLOST) then Result:='The buffer memory has been lost and must be restored.';
  if Res = HRESULT(DSERR_CONTROLUNAVAIL) then Result:='The buffer control (volume, pan, and so on) requested by the caller is not available.';
  if Res = HRESULT(DSERR_GENERIC) then Result:='An undetermined error occurred inside the DirectSound subsystem.';
  if Res = HRESULT(DSERR_INVALIDCALL) then Result:='This function is not valid for the current state of this object.';
  if Res = HRESULT(DSERR_INVALIDPARAM) then Result:='An invalid parameter was passed to the returning function.';
  if Res = HRESULT(DSERR_NOAGGREGATION) then Result:='The object does not support aggregation.';
  if Res = HRESULT(DSERR_NODRIVER) then Result:='No sound driver is available for use.';
  if Res = HRESULT(DSERR_NOINTERFACE) then Result:='The requested COM interface is not available.';
  if Res = HRESULT(DSERR_OTHERAPPHASPRIO) then Result:='Another application has a higher priority level, preventing this call from succeeding';
  if Res = HRESULT(DSERR_OUTOFMEMORY) then Result:='The DirectSound subsystem could not allocate sufficient memory to complete the caller''Result request.';
  if Res = HRESULT(DSERR_PRIOLEVELNEEDED) then Result:='The caller does not have the priority level required for the function to succeed.';
  if Res = HRESULT(DSERR_UNINITIALIZED) then Result:='The IDirectSound::Initialize method has not been called or has not been called successfully before other methods were called.';
  if Res = HRESULT(DSERR_UNSUPPORTED) then Result:='The function called is not supported at this time.';
end;

{ TDXAudioOut }

constructor TDXAudioOut.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  FSpeedFactor:=1;
  FFramesInBuffer:=$6000;
  FFetchDelay:=10;
  FLatency:=100;
  FVolumeEx:=0; //DW
  FPrefetchMode:=TAcsPrefetchMode.pmAuto;
  //FDeviceCount:=0;
  FBufferSize:=$40000; // default buffer size

  if not (csDesigning in ComponentState) then
  begin
    DSW_EnumerateOutputDevices(@Devices);
    //FDeviceCount:=Devices.devcount;
    ThreadPriority:=tpHighest;

    // fill device info
    SetLength(FDeviceInfoArray, Devices.devcount);
    for i:=0 to Devices.devcount-1 do
    begin
      {$ifdef FPC}
      //FDeviceInfoArray[i].DeviceName:=AnsiToUtf8(Devices.dinfo[i].name);
      FDeviceInfoArray[i].DeviceName:=WinCPToUTF8(Devices.dinfo[i].name);
      {$else}
      FDeviceInfoArray[i].DeviceName:=Devices.dinfo[i].name;
      {$endif}
    end;
  end;
end;

destructor TDXAudioOut.Destroy();
begin
  inherited Destroy();
end;

procedure TDXAudioOut.Init();
var
  Res: HResult;
  Wnd: HWND;
  FormatExt: TWaveFormatExtensible;
begin
  if (FDeviceNumber >= DeviceCount) or (FDeviceNumber < 0) then
  begin
    raise EAcsException.Create(Format(strChannelnotavailable, [FDeviceNumber]));
  end;

  inherited Init();

  Chan:=FInput.Channels;
  SR:=FInput.SampleRate;
  if FSpeedFactor <> 1 then
    SR:=Round(SR * FSpeedFactor);
  BPS:=FInput.BitsPerSample;
  FSampleSize:=Chan * (BPS div 8);

  if FLatency > 0 then
  begin
    if FLatency < 10 then FLatency:=10;
    FFramesInBuffer:=(FLatency * SR div 1000);
  end;

  DSW_Init(DSW);
  Res:=DSW_InitOutputDevice(DSW, @(Devices.dinfo[FDeviceNumber].guid));
  if Res <> 0 then
    raise EAcsException.Create(strFailedtoCreateDSdev+': '+DSErrToString(Res));
  DSW_Initialized:=True;

  Wnd:=0;
  {$ifdef LCL}
  if (Owner is TForm) then Wnd:=(Owner as TForm).Handle;
  {$endif}

  // align buffer size to sample size
  Self.SetBufferSize(FBufferSize - (FBufferSize mod FSampleSize));
  //Self.SetBufferSize(FFramesInBuffer * (BPS div 8) * Chan);

  if BPS <> 8 then
    FFillByte:=0
  else
    FFillByte:=128;

  FillChar(FormatExt, SizeOf(FormatExt), 0);

  {$ifdef USE_EXTENDED_SPEC_FOR_24_BPS }
  if (Chan < 3) and (BPS <> 24) then
  {$else}
  if Chan < 3 then
  {$endif}
  begin
    FormatExt.Format.wFormatTag:=1; //WAVE_FORMAT_PCM;
    FormatExt.Format.cbSize:=0;
  end
  else
  begin
    FormatExt.Format.wFormatTag:=WAVE_FORMAT_EXTENSIBLE;
    FormatExt.Format.cbSize:=SizeOf(FormatExt)-SizeOf(FormatExt.Format);
    FormatExt.SubFormat:=KSDATAFORMAT_SUBTYPE_PCM;
    if Chan = 2 then
       FormatExt.dwChannelMask:=$3;
    if Chan = 6 then
      FormatExt.dwChannelMask:=$3F;
    if Chan = 8 then
      FormatExt.dwChannelMask:=$FF;
  end;
  FormatExt.Format.nChannels:=Chan;
  FormatExt.Format.nSamplesPerSec:=SR;
  FormatExt.Format.wBitsPerSample:=BPS;
  FormatExt.Format.nBlockAlign:=(Chan * (BPS div 8));
  FormatExt.Format.nAvgBytesPerSec:=SR * FormatExt.Format.nBlockAlign;
  //FormatExt.wValidBitsPerSample:=BPS;
  //FormatExt.wSamplesPerBlock:=0;
  //FormatExt.wReserved:=0;
  //FormatExt.SubFormat:=1;

  Res:=DSW_InitOutputBufferEx(DSW, Wnd, FormatExt, FBuffer.Size);
  if Res <> 0 then
    raise EAcsException.Create(strFailedtoCreateDSbuf+': '+DSErrToString(Res));
  StartInput:=True;
  EndOfInput:=False;
  _TmpUnderruns:=0;
  VolumeEx:=FVolumeEx; //DW
  FBuffer.Reset();
  //DSW_StartOutput(DSW);
end;

procedure TDXAudioOut.Done();
begin
  if DSW_Initialized then
  begin
    DSW_StopOutput(DSW);
    DSW_Term(DSW);
    DSW_Initialized:=False;
  end;
  inherited Done();
end;

function TDXAudioOut.DoOutput(Abort: Boolean): Boolean;
var
  Len, offs, lb, RetryCount: Integer;
  BytesAllowed: LongWord;
  Res: HRESULT;
  PlayTime, CTime: LongWord;
  //TmpBuf: Pointer;
begin
  Result:=False;
  if not Active then Exit;
  if Abort then Exit;
  if not CanOutput then Exit;

  if StartInput then
  begin
    //FInput.FillBuffer(FBuffer, _BufSize, EndOfInput);
    Len:=Self.FillBufferFromInput(EndOfInput);
    DSW_WriteBlock(DSW, FBuffer.Memory, Len);
    VolumeEx:=FVolumeEx; //DW
    DSW_StartOutput(DSW);
    StartInput:=False;
  end;

  { TODO : Is it really needed? }
  if EndOfInput then
  begin
    CanOutput:=False;
    PlayTime:=Round(FBuffer.Size/(Chan*(BPS div 8)*SR))*1000;
    CTime:=0;
    while CTime < PlayTime do
    begin
      Sleep(100);
      //DSW_ZeroEmptySpace(@DSW);
      DSW_FillEmptySpace(DSW, FFillByte);
      Inc(CTime, 100);
    end;
    DSW_StopOutput(DSW);
    Exit;
  end;

  {
  Sleep(DS_POLLING_INTERVAL);
  DSW_QueryOutputSpace(@DSW, lb);
  lb := lb - (lb mod 1024);
  Len := 0;
  while Len < lb do
  begin
    if FInput.Active then
      begin
        try
          offs := Finput.GetData(@FBuffer^[Len], lb-Len);
        except
          DSW_StopOutput(@DSW);
          CanOutput := False;
          Result := False;
          Exit;
        end;
      end;
    if offs = 0 then Break;
    Inc(Len, offs);
  end;
  DSW_WriteBlock(@DSW, @Fbuffer^, Len);
  if offs = 0 then
  begin
    DSW_ZeroEmptySpace(@DSW);
    EndOfInput := True;
  end;
  }

  // Try to get allowed output data size
  BytesAllowed:=0;
  try
    Res:=DSW_QueryOutputSpace(DSW, BytesAllowed);
  except
    if Assigned(OnThreadException) then
      OnThreadException(Self, Exception.Create('Audio output error'));
  end;
  BytesAllowed:=BytesAllowed-(BytesAllowed mod DSW.dsw_BytesPerFrame);

  { DS buffer played in a loop, so we need circular buffer }

  if BytesAllowed >= FPrefetchSize then
  begin
    // read chunk of data into buffer
    Len:=FBuffer.GetBufWriteSize(BytesAllowed);
    Len:=FInput.GetData(FBuffer.Memory + FBuffer.WritePosition, Len);
    FBuffer.WritePosition:=FBuffer.WritePosition + Len;
    if FBuffer.WritePosition = FBuffer.Size then FBuffer.WritePosition:=0;
    EndOfInput:=(Len = 0);

    // write to output
    DSW_WriteBlock(DSW, FBuffer.Memory + FBuffer.ReadPosition, Len);
    FBuffer.ReadPosition:=FBuffer.ReadPosition + Len;
    if FBuffer.ReadPosition = FBuffer.Size then FBuffer.ReadPosition:=0;

    if EndOfInput then
      Res:=DSW_FillEmptySpace(DSW, FFillByte);

    if _TmpUnderruns <> DSW.dsw_OutputUnderflows then
    begin
      FUnderruns:=DSW.dsw_OutputUnderflows;
      _TmpUnderruns:=DSW.dsw_OutputUnderflows;
      DSW_StopOutput(DSW);
      DSW_FillEmptySpace(DSW, FFillByte);
      if Assigned(OnUnderrun) then
        OnUnderrun(Self);
        //EventHandler.PostGenericEvent(Self, FOnUnderrun);
      //Usleep(FPollingInterval, FPrefetchData);
      DSW_RestartOutput(DSW); //StartInput := True;
    end;
  end;
  Result:=True;
end;

procedure TDXAudioOut.Pause();
begin
  inherited Pause();
  if EndOfInput then Exit;
  DSW_StopOutput(DSW);
end;

procedure TDXAudioOut.Resume();
begin
  if EndOfInput then Exit;
  DSW_RestartOutput(DSW);
  inherited Resume();
end;

procedure TDXAudioOut.SetDeviceNumber(i: Integer);
begin
  SetDevice(i);
  FDeviceNumber:=i
end;

function TDXAudioOut.GetVolumeEx(): Integer;
begin
  DSW_GetVolume(DSW, Result);
  FVolumeEx:=Result; // DW
  FVolume:=Byte(Result);
end;

procedure TDXAudioOut.SetVolumeEx(Value: Integer);
begin
  FVolumeEx:=Value; // DW
  FVolume:=Byte(Value);
  DSW_SetVolume(DSW, Value);
end;

procedure TDXAudioOut.SetFramesInBuffer(Value: LongWord);
begin
  if not Active then FFramesInBuffer:=Value;
end;

procedure TDXAudioOut.SetDevice(Ch: Integer);
begin
  if (Ch < 0) or (Ch >= DeviceCount) then Exit;
  FDeviceNumber:=Ch;
  FBaseChannel:=Ch;
end;


{ TDXAudioIn }

constructor TDXAudioIn.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  FLatency:=100;
  FBPS:=8;
  FChan:=1;
  FSampleRate:=8000;
  //FSize:=-1;
  FRecTime:=-1;
  FSamplesToRead:=-1;
  FFramesInBuffer:=$6000;
  FPollingInterval:=100;
  //FDeviceCount:=0;
  if not (csDesigning in ComponentState) then
  begin
    DSW_EnumerateInputDevices(@Devices);
    //FDeviceCount:=Devices.devcount;
    // fill DeviceNumber info
    SetLength(FDeviceInfoArray, Devices.devcount);
    for i:=0 to Devices.devcount-1 do
    begin
      {$ifdef fpc}
      //FDeviceInfoArray[i].DeviceName:=AnsiToUtf8(Devices.dinfo[i].name);
      FDeviceInfoArray[i].DeviceName:=WinCPToUTF8(Devices.dinfo[i].name);
      {$else}
      FDeviceInfoArray[i].DeviceName:=Devices.dinfo[i].name;
      {$endif}
    end;
  end;
end;

destructor TDXAudioIn.Destroy();
begin
  DSW_Term(DSW);
  inherited Destroy();
end;

procedure TDXAudioIn.OpenAudio();
var
  Res: HRESULT;
begin
  if FOpened = 0 then
  begin
    if FLatency > 0 then
    begin
      if FLatency < 10 then Flatency:=10;
      FFramesInBuffer:=(FLatency * LongWord(FSampleRate) div 1000);
      FPollingInterval:=(FLatency div 2); //4)*3;
    end;

    Res:=DSW_Init(DSW);
    //if not Assigned(DSW_InitInputDevice) then raise EAcsException.Create(Format(strChannelNotAvailable,[FDeviceNumber]));
    Res:=DSW_InitInputDevice(DSW, @(Devices.dinfo[FDeviceNumber].guid));
    if Res <> 0 then
      raise EAcsException.Create(strFailedtoCreateDSdev+': '+DSErrToString(Res));

    Self.BufferSize:=Integer(FFramesInBuffer) * (FBPS div 8) * FChan;
    Res:=DSW_InitInputBuffer(DSW, FBPS, FSampleRate, FChan, BufferSize);
    if Res <> 0 then
      raise EAcsException.Create(strFailedtoCreateDSbuf+': '+DSErrToString(Res));
  end;
  Inc(FOpened);
end;

procedure TDXAudioIn.CloseAudio();
begin
  if FOpened = 1 then
  begin
    DSW_Term(DSW);
    BufferSize:=0;
  end;
  if FOpened > 0 then Dec(FOpened);
end;

procedure TDXAudioIn.Init();
begin
  inherited Init();
  if (FDeviceNumber >= DeviceCount) then
  begin
    inherited Done();
    raise EAcsException.Create(Format(strChannelnotavailable, [FDeviceNumber]));
  end;

  if FRecTime > 0 then
  begin
    FSamplesToRead:=FRecTime*FSampleRate;
    FBytesToRead:=FRecTime*FSampleRate*FChan*(FBPS div 8);
  end;
  FSampleSize:=FChan * (FBPS div 8);
  //FSize:=FSamplesToRead*FSampleSize;

  OpenAudio();
  DSW_StartInput(DSW);

  if FEchoRecording then
  begin
    if DSW_InitOutputDevice(DSW, @(Devices.dinfo[FDeviceNumber].guid)) = DS_OK then
    begin
      DSW_InitOutputBuffer(DSW, 0, FBPS, FSampleRate, FChan, BufferSize);
      DSW_StartOutput(DSW);
    end
    else
      FEchoRecording:=False;
  end;
  RecordingEchoed:=FEchoRecording;
end;

procedure TDXAudioIn.Done();
begin
  DSW_StopInput(DSW);
  if RecordingEchoed then
    DSW_StopOutput(DSW);
  CloseAudio;
  inherited Done();
end;

function TDXAudioIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  BytesAllowed: LongInt;
  BytesAllowedOut: LongWord;
  Res: HRESULT;
begin
  Result:=0;
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  //if (FSamplesToRead >=0) and (FPosition >= FSize) then
  if (FBytesToRead >=0) and (FPosition >= FBytesToRead) then
    Exit;

  if BufStart >= BufEnd then
  begin
    BufStart:=0;
    BytesAllowed:=0;
    while BytesAllowed = 0 do
    begin
      Sleep(FPollingInterval);
      Res:=DSW_QueryInputFilled(DSW, BytesAllowed);
      if Res <> DS_OK then
        raise EAcsException.Create('Input failed: DirectSound error: '+DSErrToString(Res));
    end;

    if BytesAllowed > BufferSize then
    begin
      BytesAllowed:=BufferSize; (* We have lost some data.
                         Generally this shouldn't happen. *)
     Inc(FOverruns);
     if Assigned(OnOverrun) then OnOverrun(Self);
    end;
    //BytesAllowed:=BytesAllowed-(BytesAllowed mod 1024);
    Res:=DSW_ReadBlock(DSW, @FBuffer[0], BytesAllowed);
    if Res <> DS_OK then
       raise EAcsException.Create('Input failed: DirectSound: '+DSErrToString(Res));

    if RecordingEchoed then
    begin
      BytesAllowedOut:=0;
      DSW_QueryOutputSpace(DSW, BytesAllowedOut);
      if BytesAllowed < BytesAllowedOut then BytesAllowedOut:=BytesAllowed;
      if FEchoRecording then
        DSW_WriteBlock(DSW, @FBuffer[0], BytesAllowedOut)
      else
        DSW_FillEmptySpace(DSW, 0);
    end;

    BufEnd:=BytesAllowed;
  end;

  if ABufferSize < (BufEnd - BufStart) then
    Result := ABufferSize
  else
    Result := BufEnd - BufStart;
  Move(FBuffer[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  Inc(FPosition, Result);
end;

procedure TDXAudioIn.SetRecTime(aRecTime: Integer);
begin
  FRecTime:=aRecTime;
  if FRecTime > 0 then
  begin
    FBytesToRead:=FRecTime*FSampleRate*FChan*(FBPS div 8);
    FSamplesToRead:=FRecTime*FSampleRate;
  end
  else
  begin
    FBytesToRead:=-1;
    FSamplesToRead:=-1;
  end;
end;

procedure TDXAudioIn.SetFramesInBuffer(Value: LongWord);
begin
  if not Active then FFramesInBuffer:=Value;
end;

procedure TDXAudioIn.SetDevice(i: Integer);
begin
  FDeviceNumber:=i;
end;

procedure TDXAudioIn.SetDeviceNumber(i: Integer);
begin
  FDeviceNumber:=i;
end;

function TDXAudioIn.GetDeviceName(ADeviceNumber: Integer): string;
begin
  Result:='';
  if (ADeviceNumber < DeviceCount) then Result:=PChar(@(Devices.dinfo[ADeviceNumber].Name[0]));
end;

initialization

  RegisterAudioOut('DirectSound', TDXAudioOut, LATENCY);
  RegisterAudioIn('DirectSound', TDXAudioIn, LATENCY);

finalization

{$endif WINDOWS}

end.
