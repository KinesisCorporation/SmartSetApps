(*
Windows DirectShow file in

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

unit acs_dsfiles;

interface

{$ifdef WINDOWS}
{$ifdef linux}{$message error 'unit not supported'}{$endif linux}

{$DEFINE DYNAMIC_LINK_ALL}

uses
  ACS_File, ACS_Classes, DirectShow9, Classes, ActiveX, Windows, MMSystem;

type
  { TDSIn }

  TDSIn = class(TAcsCustomFileIn)
  private
    {$ifdef _fpc}
    FxFormat: _WAVEFORMATEX;
    {$else}
    FxFormat: TWaveFormatEx;
    {$endif}
    FxAMMultiMediaStream: IAMMultiMediaStream;
    FxGraphBuilder: IGraphBuilder;
    FxMediaSeeking: IMediaSeeking;
    FxMediaControl: IMediaControl;
    FxAudioMediaStream: IAudioMediaStream;
    FxMediaStream: IMediaStream;
    FxAudioStreamSample: IAudioStreamSample;
    FxAudioData: IAudioData;
    FxBuffer: Pointer;
    FxBufferSize: DWord;
    FDuration: STREAM_TIME;
    FxPosition: STREAM_TIME;
    FxSelStart: STREAM_TIME;
    FxSelLength: STREAM_TIME;
    FxLastReadingStartTime: STREAM_TIME;
    FxLastReadingEndTime: STREAM_TIME;
    FSeekScale: Integer;
    function Read(Buffer: Pointer; xSize: DWord): DWord;
    procedure SetPosition(Value: STREAM_TIME);
  protected
    procedure OpenFile(); override;
    procedure CloseFile(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    function Seek(SampleNum: Integer): Boolean; override;
  end;

function ErrorCheck(FuncName: string; Value: HRESULT): HRESULT; { Check the result of a COM operation }

{$endif WINDOWS}

implementation

{$ifdef WINDOWS}

constructor TDSIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStreamDisabled:=True;
  FBufferSize:=$8000;
end;

destructor TDSIn.Destroy();
begin
  inherited Destroy;
end;

procedure TDSIn.OpenFile();
var
  //AMovie: IGraphBuilder;
  v: WideString;
  hr: HRESULT;
begin
  if not FOpened then
  begin
    FValid:=False;
    v:=FFileName;
    hr:=CoInitialize(nil);
    if (hr <> S_OK) and (hr <> S_FALSE) then ErrorCheck('CoInitialize()', hr );

    //ErrorCheck('', CoCreateInstance( CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, AMovie) );
    ErrorCheck('CoCreateInstance(CLSID_AMMultiMediaStream)', CoCreateInstance( CLSID_AMMultiMediaStream, nil, CLSCTX_INPROC_SERVER, IID_IAMMultiMediaStream, FxAMMultiMediaStream ) );
    ErrorCheck('FxAMMultiMediaStream.Initialize()', FxAMMultiMediaStream.Initialize(STREAMTYPE_READ, AMMSF_NOGRAPHTHREAD, nil) );
    ErrorCheck('FxAMMultiMediaStream.AddMediaStream()', FxAMMultiMediaStream.AddMediaStream(nil, @MSPID_PrimaryAudio, 0, FxMediaStream) );
    ErrorCheck('FxAMMultiMediaStream.GetMediaStream()', FxAMMultiMediaStream.GetMediaStream(MSPID_PrimaryAudio, FxMediaStream) );
    ErrorCheck('FxAMMultiMediaStream.OpenFile()', FxAMMultiMediaStream.OpenFile(PWideChar(v), 0) );

    ErrorCheck('FxAMMultiMediaStream.GetFilterGraph()', FxAMMultiMediaStream.GetFilterGraph(FxGraphBuilder) );
    ErrorCheck('FxGraphBuilder.QueryInterface(IID_IMediaControl)', FxGraphBuilder.QueryInterface(IID_IMediaControl, FxMediaControl) );
    ErrorCheck('FxGraphBuilder.QueryInterface(IID_IMediaSeeking)', FxGraphBuilder.QueryInterface(IID_IMediaSeeking, FxMediaSeeking) );

    ErrorCheck('FxMediaStream.QueryInterface(IID_IAudioMediaStream)', FxMediaStream.QueryInterface(IID_IAudioMediaStream, FxAudioMediaStream) );
    ErrorCheck('FxAudioMediaStream.GetFormat()', FxAudioMediaStream.GetFormat(FxFormat) );
    ErrorCheck('CoCreateInstance(CLSID_AMAudioData)', CoCreateInstance(CLSID_AMAudioData, nil, CLSCTX_INPROC_SERVER, IID_IAudioData, FxAudioData) );
    ErrorCheck('FxAudioData.SetFormat()', FxAudioData.SetFormat(FxFormat) );
    ErrorCheck('FxAudioMediaStream.CreateSample()', FxAudioMediaStream.CreateSample(FxAudioData, 0, FxAudioStreamSample) );
    ErrorCheck('FxAMMultiMediaStream.GetDuration()', FxAMMultiMediaStream.GetDuration(FDuration) );
    ErrorCheck('FxAMMultiMediaStream.SetState()', FxAMMultiMediaStream.SetState( STREAMSTATE_RUN ) );
    FxSelLength:=0;

    FSR   := FxFormat.nSamplesPerSec;
    FBPS  := FxFormat.wBitsPerSample;
    FChan := FxFormat.nChannels;
    // FDuration in 100-nanosecond units
    FTotalTime    := FDuration / 10000000;
    FSize         := (FDuration div 10000000) * FSR * FChan * (FBPS div 8);
    FTotalSamples := Trunc(FTotalTime * FSR);
    FSeekable     := True;
    FSeekScale    := 0;
    if FDuration <> 0 then
      FSeekScale := FDuration div FSize;
    FOpened:=True;
    FValid:=True;
  end;
  if not FOpened then CloseFile();
end;

procedure TDSIn.CloseFile();
begin
  if FOpened then
  begin
    if Assigned(FxAMMultiMediaStream) then
      ErrorCheck('FxAMMultiMediaStream.SetState()', FxAMMultiMediaStream.SetState( STREAMSTATE_STOP ) );
    FxAudioStreamSample  := nil;
    FxAudioData          := nil;
    FxAudioMediaStream   := nil;
    FxMediaStream        := nil;
    FxMediaSeeking       := nil;
    FxMediaControl       := nil;
    FxGraphBuilder       := nil;
    FxAMMultiMediaStream := nil;
    CoUninitialize();
    FOpened:=False;
  end;
end;

function TDSIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
begin
  Result:=0;
  if not Active then
    raise EAcsException.Create('The Stream is not opened');

  if FAudioBuffer.UnreadSize = 0 then
  begin
    // set file position with offset
    if FOffset <> 0 then
    begin
      FPosition:=FPosition+Round((FOffset/100)*FSize);
      if FPosition < 0 then
        FPosition:=0
      else
      begin
        if FPosition > FSize then
          FPosition:=FSize;
      end;
      SetPosition(Int64(FPosition)*FSeekScale);
      FOffset:=0;
    end;

    // read chunk of samples into local audio ABuffer, direct into memory
    FAudioBuffer.Reset();
    Result:=Read(FAudioBuffer.Memory, FAudioBuffer.Size);
    // set WritePosition to readed size
    FAudioBuffer.WritePosition:=Result;
    if Result = 0 then
    begin
      // nothing to read, end of file?
      if FLoop then
      begin
        SetPosition(0); // just rewind
        FPosition:=0;
        FAudioBuffer.Reset();
        Result:=Read(FAudioBuffer.Memory, FAudioBuffer.Size);
        FAudioBuffer.WritePosition:=Result;
      end
      else Exit;
    end;
  end;
  Result:=FAudioBuffer.UnreadSize;

  // copy local AudioBuffer into given ABuffer
  if ABufferSize < Result then Result:=ABufferSize;
  FAudioBuffer.Read(ABuffer^, Result);
  Inc(FPosition, Result);

end;

function TDSIn.Seek(SampleNum: Integer): Boolean;
begin
  Result:=True;
  FPosition:=SampleNum;
end;

function TDSIn.Read(Buffer: Pointer; xSize: DWord): DWord;
var
  hr: DWord;
  Tmp: STREAM_TIME;
begin
  Result:=0;
  if (xSize <= 0) then
    raise EAcsException.Create('Invalid buffer size.');

  if (FxSelLength <> 0) and (FxPosition >= FxSelStart+FxSelLength) then Exit;

  if (Buffer <> FxBuffer) or (xSize <> FxBufferSize) then
  begin
    FxBuffer:=Buffer;
    FxBufferSize:=xSize;
    ErrorCheck('FxAudioData.SetBuffer()', FxAudioData.SetBuffer(FxBufferSize, FxBuffer, 0) );
  end;
  hr:=FxAudioStreamSample.Update(0, 0, nil, 0);
  if (hr = MS_S_ENDOFSTREAM) or (hr = MS_E_NOSTREAM) then Exit;
  ErrorCheck('FxAudioStreamSample.Update()', hr);
  ErrorCheck('FxAudioData.GetInfo()', FxAudioData.GetInfo(FxBufferSize, FxBuffer, Result) );
  ErrorCheck('FxAudioStreamSample.GetSampleTimes()', FxAudioStreamSample.GetSampleTimes(FxLastReadingStartTime, FxLastReadingEndTime, Tmp) );
  if FxLastReadingStartTime > FxLastReadingEndTime then
    FxLastReadingStartTime:=FxLastReadingEndTime;
  if (FxSelLength <> 0) and (FxLastReadingEndTime > FxLastReadingStartTime)
  and (FxSelStart+FxSelLength < FxLastReadingEndTime) then
  begin
    Result:=DWord(Trunc(((Result*(FxSelStart+FxSelLength-FxLastReadingStartTime))
      /(FxLastReadingEndTime-FxLastReadingStartTime))))
      AND (not(FxFormat.nBlockAlign-1));
    FxLastReadingEndTime:=FxSelStart+FxSelLength;
  end;
  FxPosition:=FxLastReadingEndTime;
end;

procedure TDSIn.SetPosition(Value: STREAM_TIME);
var
  pfs: TFilterState;
begin
  if (Value <> FxPosition) then
  begin
    if (Value < FxSelStart) then
      Value:=FxSelStart
    else
      if (Value > FDuration) then
        Value:=FDuration
      else
      begin
        if (FxSelLength <> 0) and (Value > FxSelStart+FxSelLength) then
          Value:=FxSelStart+FxSelLength;
      end;
    ErrorCheck('FxMediaControl.StopWhenReady()', FxMediaControl.StopWhenReady );
    ErrorCheck('FxMediaSeeking.SetPositions()', FxMediaSeeking.SetPositions(Value, AM_SEEKING_AbsolutePositioning, Value, AM_SEEKING_NoPositioning) );
    ErrorCheck('FxMediaControl.Run()', FxMediaControl.Run );
    ErrorCheck('FxMediaControl.GetState()', FxMediaControl.GetState(INFINITE, pfs) );
    FxPosition:=Value;
  end;
end;

function ErrorCheck(FuncName: string; Value: HRESULT): HRESULT; { Check the result of a COM operation }
var
  s: String;
  s2: array [0..300] of Char;
begin
  Result := Value;
  if (Value <> S_OK) then
  begin
    case DWord(Value) of
      DWord(REGDB_E_CLASSNOTREG): s:='A specified class is not registered in the registration database.';
      DWord(CLASS_E_NOAGGREGATION): s:='This class cannot be created as part of an aggregate.';
      DWord(E_ABORT): s:='The update aborted.';
      DWOrd(E_INVALIDARG): s:='One of the parameters is invalid.';
      DWOrd(E_OUTOFMEMORY): s:='Out of memory.';
      DWOrd(E_UNEXPECTED): s:='Unexpected error.';
      DWord(E_POINTER): s:='This method tried to access an invalid pointer.';
      DWord(E_NOINTERFACE): s:='No interface.';
      MS_S_PENDING: s:='The asynchronous update is pending.';
      MS_S_NOUPDATE: s:='Sample was not updated after forced completion.';
      MS_S_ENDOFSTREAM: s:='Reached the end of the stream; the sample wasn''t updated.';
      MS_E_SAMPLEALLOC: s:='An IMediaStream object could not be removed from an IMultiMediaStream object because it still contains at least one allocated sample.';
      MS_E_PURPOSEID: s:='The specified purpose ID can''t be used for the call.';
      MS_E_NOSTREAM: s:='No stream can be found with the specified attributes.';
      MS_E_NOSEEKING: s:='One or more media streams don''t support seeking.';
      MS_E_INCOMPATIBLE: s:='The stream formats are not compatible.';
      MS_E_BUSY: s:='This sample already has a pending update.';
      MS_E_NOTINIT: s:='The object can''t accept the call because its initialize function or equivalent has not been called.';
      MS_E_SOURCEALREADYDEFINED: s:='Source already defined.';
      MS_E_INVALIDSTREAMTYPE: s:='The stream type is not valid for this operation.';
      MS_E_NOTRUNNING: s:='The IMultiMediaStream object is not in running state.';
      DWord(RPC_E_CHANGED_MODE): s:='A previous call to CoInitializeEx specified the concurrency model for this thread as multithread apartment (MTA).';
      else
      begin
        if AMGetErrorText(Value, s2, High(s2)) = 0 then
          s:='Unrecognized error value.'
        else
        begin
          s:=string(s2);
          {$ifdef fpc}
          s:=AnsiToUtf8(s);
          {$endif}
        end;
      end;
    end;
    raise EAcsException.Create(FuncName+': '+s);
  end;
end ;

initialization
  { TODO : Enumerate available file formats }
  FileFormats.Add('mp3',  'DirectShow Mpeg Audio Layer III', TDSIn);
  FileFormats.Add('mp2',  'DirectShow Mpeg Audio Layer II', TDSIn);
  FileFormats.Add('mpeg', 'DirectShow Mpeg Audio', TDSIn);
  FileFormats.Add('wma',  'DirectShow Windows Media Audio', TDSIn);
  {$endif WINDOWS}
end.

