(*
  the original version of this file is written by thomas la cour,
  http://www.top-house.dk/~nr161/delphi/

  This file is a part of Audio Components Suite.
  All rights reserved. See the license file for more details.

  Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
  Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
  Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

unit acs_mac;

interface

{$ifdef WINDOWS}
{$ifdef linux}{$message error 'unit not supported'}{$endif linux}

uses
  ACS_File, Classes, SysUtils, Windows, ACS_Classes, MACDll;

type

  // Note by A.B.: It seems that APE compressor supports file output only.

  TMACOut = class(TAcsCustomFileOut)
  private
    APECompress: TAPECompress;
    WaveFormatEx: TWaveFormatEx;
    EndOfStream: Boolean;
    FCompressionLevel: Integer;
    FMaxAudioBytes: Integer;
    procedure SetCompressionLevel(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Done(); override;
    function DoOutput(Abort: Boolean): Boolean; override;
    procedure Init(); override;
  published
    property CompressionLevel: LongInt read FCompressionLevel write SetCompressionLevel stored True;
    property MaxAudioBytes: Integer read FMaxAudioBytes write FMaxAudioBytes;
  end;

  (* Note by A.B.: Due to the reasons described above this component
     ignores streamed input *)

  TMACIn = class(TAcsCustomFileIn)
  private
    APEDecompress: TAPEDecompress;
    EndOfStream: Boolean;
    function GetAverageBitrate(): Integer;
    function GetCurrentBitrate(): Integer;
    function GetCurrentBlock(): Integer;
    function GetCurrentMS(): Integer;
    function GetLengthMS(): Integer;
    function GetTotalBlocks(): Integer;
  protected
    function GetTotalTime(): Real; override;
    procedure OpenFile(); override;
    procedure CloseFile(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;

    function Seek(Sample: Integer): Boolean; override;

    property AverageBitrate: Integer read GetAverageBitrate;
    property CurrentBitrate: Integer read GetCurrentBitrate;
    property CurrentBlock: Integer read GetCurrentBlock;
    property CurrentMS: Integer read GetCurrentMS;
    property LengthMS: Integer read GetLengthMS;
    property TotalBlocks: Integer read GetTotalBlocks;
  end;

{$endif WINDOWS}

implementation

{$ifdef WINDOWS}

constructor TMACOut.Create();
begin
  inherited Create(AOwner);
  FStreamDisabled:=True;
  FBufferSize:=$10000;  // default buffer size
  FCompressionLevel:=COMPRESSION_LEVEL_NORMAL;
  FMaxAudioBytes:=MAX_AUDIO_BYTES_UNKNOWN;
  if not (csDesigning in ComponentState) then
  begin
    if not MACLoaded then
      raise EAcsException.Create(MACPath + ' library could not be loaded.');
  end;
end;

destructor TMACOut.Destroy();
begin
  if Assigned(APECompress) then FreeAndNil(APECompress);
  inherited Destroy;
end;

procedure TMACOut.Init();
var
  r: Integer;
begin
  inherited Init();
  EndOfStream:=False;

  APECompress:=TAPECompress.Create();

  macFillWaveFormatEx(WaveFormatEx, FInput.SampleRate, FInput.BitsPerSample, FInput.Channels);

  r:=APECompress.Start(
    PChar(FFileName),
    @WaveFormatEx,
    FMaxAudioBytes,
    FCompressionLevel,
    nil,
    CREATE_WAV_HEADER_ON_DECOMPRESSION);

  CanOutput:=(r = 0);

  if r <> 0 then
    raise EAcsException.Create('Error starting APECompress.' + #13#10 + macErrorExplanation(r));
end;

procedure TMACOut.Done();
begin
  APECompress.Finish(nil, 0, 0);
  FreeAndNil(APECompress);
  inherited Done();
end;

function TMACOut.DoOutput(Abort: Boolean): Boolean;
var
  Len, x: Integer;
  pBuffer: PByteArray;
  nAudioBytesLeft, nBufferBytesAvailable, nNoiseBytes, nRetVal: Integer;
begin
  // No exceptions Here
  Result:=True;
  if not CanOutput then Exit;
  if Abort or EndOfStream then
  begin
    (* We don't close file here to avoide exceptions
      if output componenet's Stop method is called *)
    Result:=False;
    Exit;
  end;

  Len:=FillBufferFromInput();
  x:=0;
  if Len <> 0 then
  begin
    nAudioBytesLeft:=Len;
    while (nAudioBytesLeft > 0) do
    begin
      nBufferBytesAvailable:=0;
      pBuffer:=APECompress.LockBuffer(nBufferBytesAvailable);

      nNoiseBytes:=nBufferBytesAvailable;
      if nNoiseBytes > nAudioBytesLeft then
        nNoiseBytes:=nAudioBytesLeft;

      {//whats this ? schoult System.Move not be faster ?
      for z:=0 to nNoiseBytes - 1 do
      begin
        pBuffer[z]:=FBuffer[x];
        inc(x);
      end; }
      FBuffer.Position:=0;
      FBuffer.Read(pBuffer, nNoiseBytes);

      nRetVal:=APECompress.UnlockBuffer(nNoiseBytes, TRUE);
      if (nRetVal <> 0) then
        raise EAcsException.Create('APECompress.UnlockBuffer Error: ' + inttostr(nRetVal));

      Dec(nAudioBytesLeft, nNoiseBytes);
    end
  end
  else
    EndOfStream:=True;
end;

{ TMACIn }

constructor TMACIn.Create();
begin
  inherited Create(AOwner);
  BufferSize:=$2000;
  if not (csDesigning in ComponentState) then
  begin
    if not MACLoaded then
      raise EAcsException.Create(MACPath + ' library could not be loaded.');
  end;
end;

destructor TMACIn.Destroy();
begin
  CloseFile();
  inherited Destroy;
end;

procedure TMACIn.OpenFile();
begin
  if not FOpened then
  begin
    EndOfStream:=False;

    APEDecompress:=TAPEDecompress.Create(FileName);
    if APEDecompress.Handle <> 0 then
    begin
      FSize:=APEDecompress.InfoWavTotalBytes;
      FSR:=APEDecompress.InfoSampleRate;
      FBPS:=APEDecompress.InfoBitsPerSample;
      FChan:=APEDecompress.InfoChannels;
      FTotalTime:=APEDecompress.InfoLengthMS / 1000;
      FTotalSamples:=(FSize div (FBPS div 8)) div FChan;
      FValid:=True;
      FOpened:=True;
    end
    else
    begin
      FValid:=False;
      FOpened:=False;
    end;
  end;
end;

procedure TMACIn.CloseFile();
begin
  if FOpened then
  begin
    if Assigned(APEDecompress) then FreeAndNil(APEDecompress);
    FOpened:=False;
  end;
end;

function TMACIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  l, csize, offs: Integer;
  blocks: Integer;
begin
  if not Active then
    raise EAcsException.Create('The Stream is not opened');
  if BufStart > BufEnd then
  begin
    if FOffset <> 0 then
    begin
      offs:=Round((FOffset / 100) * FSize);
      FPosition:=FPosition + offs;
      if FPosition < 0 then FPosition:=0
      else if FPosition > FSize then FPosition:=FSize;
      APEDecompress.Seek(FPosition shr 2);
      FOffset:=0;
    end;
    BufStart:=1;
    BufEnd:=0;
    if not EndOfStream then
    begin
      while BufEnd < ABufferSize do
      begin
        //l:=ov_read(VFile, @buf[BufEnd + 1], BUF_SIZE - BufEnd, 0, 2, 1, @cursec);
        blocks:=(ABufferSize - BufEnd) div 4;
        APEDecompress.GetData(@FBuffer[BufEnd], blocks, l);
        l:=l * 4;
        if l <= 0 then
        begin
          EndOfStream:=True;
          Break;
        end;
        Inc(BufEnd, l);
        if (FEndSample <> -1) then
        begin
          csize:=(FEndSample-FStartSample)*(FBPS shr 3)*FChan;
          if (csize - FPosition) <= 0 then
          begin
            EndOfStream:=True;
            Break;
          end;
          if (csize - FPosition) < BufEnd then
          begin
            BufEnd:=csize - FPosition;
            Break;
          end;
        end;
      end;
    end;
    if EndOfStream and FLoop then
    begin
      Done();
      Init();
      EndOfStream:=False;
      while BufEnd < ABufferSize do
      begin
        //l:=ov_read(VFile, @buf[BufEnd + 1], BUF_SIZE - BufEnd, 0, 2, 1, @cursec);
        blocks:=(ABufferSize - BufEnd) div 4;
        APEDecompress.GetData(@FBuffer[BufEnd], blocks, l);
        l:=l * 4;
        if l <= 0 then
        begin
          EndOfStream:=True;
          Break;
        end;
        Inc(BufEnd, l);
      end;
    end;
  end;
  if ABufferSize < (BufEnd - BufStart + 1) then
    Result:=ABufferSize
  else
    Result:=BufEnd - BufStart + 1;
  Move(FBuffer[BufStart - 1], ABuffer^, Result);
  Inc(BufStart, Result);
  Inc(FPosition, Result);
end;

function TMACIn.GetTotalTime(): Real;
begin
  Result:=FTotalTime;
end;

function TMACIn.GetAverageBitrate(): Integer;
begin
  if Assigned(APEDecompress) then
    Result:=APEDecompress.AverageBitrate;
end;

function TMACIn.GetCurrentBitrate(): Integer;
begin
  if Assigned(APEDecompress) then
    Result:=APEDecompress.CurrentBitrate;
end;

function TMACIn.GetCurrentBlock(): Integer;
begin
  if Assigned(APEDecompress) then
    Result:=APEDecompress.CurrentBlock;
end;

function TMACIn.GetCurrentMS(): Integer;
begin
  if Assigned(APEDecompress) then
    Result:=APEDecompress.CurrentMS;
end;

function TMACIn.GetLengthMS(): Integer;
begin
  if Assigned(APEDecompress) then
    Result:=APEDecompress.LengthMS;
end;

function TMACIn.GetTotalBlocks(): Integer;
begin
  if Assigned(APEDecompress) then
    Result:=APEDecompress.TotalBlocks;
end;

procedure TMACOut.SetCompressionLevel(Value: Integer);
begin
  case Value of
    COMPRESSION_LEVEL_FAST,
      COMPRESSION_LEVEL_NORMAL,
      COMPRESSION_LEVEL_HIGH,
      COMPRESSION_LEVEL_EXTRA_HIGH: FCompressionLevel:=Value;
  else
    FCompressionLevel:=COMPRESSION_LEVEL_NORMAL;
  end;
end;

function TMACIn.Seek(Sample: Integer): Boolean;
begin
  Result:=False;
  if not FSeekable then Exit;
  if Assigned(APEDecompress) then
  begin
    APEDecompress.Seek(Sample);
    Result:=True;
  end;
end;

initialization
  if LoadMacLibrary() then
  begin
    FileFormats.Add('mac', 'Monkey Audio', TMACOut);
    FileFormats.Add('mac', 'Monkey Audio', TMACIn);
  end;

finalization
  UnloadMacLibrary();

{$endif WINDOWS}

end.

