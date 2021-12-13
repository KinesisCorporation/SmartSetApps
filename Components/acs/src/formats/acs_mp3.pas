(*
SMPEG library (MPEG-1) components

This file is a part of Audio Components Suite.
Copyright (C) 2002-2005 Andrei Borovsky. All rights reserved.
See the license file for more details.
This is the ACS for Linux and Windows version of the unit.
*)
{
Status: tested
}

unit acs_mp3;

interface

uses
  Classes, SysUtils, ACS_file, ACS_classes,
  {$ifndef WIN64}smpeg,{$endif}
  mp3;

type
  {$ifndef WIN64}
  TMPEGIn = class(TAcsCustomFileIn)
  private
    _M: Pointer;
    info: SMPEG_info;
  protected
    procedure OpenFile(); override;
    procedure CloseFile(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
  end;
  {$endif}

  { TMP3In }

  TMP3In = class(TAcsCustomFileIn)
  private
    h: TPdmp3Handle;
  protected
    procedure OpenFile(); override;
    procedure CloseFile(); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
  end;


implementation

uses Math;

{ TMP3In }

procedure TMP3In.OpenFile();
var
  res, done, BufSize: Integer;
  rate, channels, enc: Integer;
  outbuf: array[0..INBUF_SIZE-1] of Byte;
begin
  inherited OpenFile();

  if FOpened then
  begin
    pdmp3_open_feed(h);
    // read first chunk
    BufSize := Length(FBuffer);
    FStream.Read(FBuffer[0], BufSize);
    // rewind back
    FStream.Position := 0;
    res := pdmp3_decode(h, FBuffer[0], BufSize, outbuf, SizeOf(outbuf), done);
    if (res = PDMP3_OK) or (res = PDMP3_NEW_FORMAT) then
    begin
      //if (res = PDMP3_NEW_FORMAT) then
      begin
        pdmp3_getformat(h, rate, channels, enc);
        FSR := rate;
        FChan := channels;
        FBPS := 16;
        FSampleSize := FChan * (FBPS div 8);

        FTotalSamples := (FStream.Size div GetFrameSize(h)) * GetSamplesPerFrame(h);
        FSize := FStream.Size;
        FValid := True;
        FOpened := True;
      end;
    end;
    // re-open
    pdmp3_open_feed(h);
  end;
end;

procedure TMP3In.CloseFile();
begin
  inherited CloseFile();
end;

constructor TMP3In.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBufferSize := INBUF_SIZE div 2;
  BufferSize := FBufferSize;
end;

destructor TMP3In.Destroy();
begin
  inherited Destroy();
end;

function TMP3In.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  res, done, BufSize: Integer;
  outbuf: array[0..INBUF_SIZE-1] of Byte;
begin
  //Result:=inherited GetData(ABuffer, ABufferSize);
  BufSize := Min(ABufferSize, BufferSize);
  //done := FStream.Read(FBuffer[0], BufSize);
  //BufSize := Min(BufSize, done);
  Result := 0;

  if BufSize = 0 then
  begin
    Result := 0;
    Exit;
  end;

  res := PDMP3_OK;
  while (Result < ABufferSize) and ((res = PDMP3_OK) or (res = PDMP3_NEW_FORMAT)) do
  begin
    //res := pdmp3_decode(h, FBuffer[0], BufSize, outbuf, SizeOf(outbuf), done);
    done := 0;
    BufSize := Min(SizeOf(outbuf), ABufferSize - Result);
    res := pdmp3_read(h, outbuf, BufSize, done);

    if (res = PDMP3_OK) or (res = PDMP3_NEW_FORMAT) then
    begin
      Result := Result + done;
      Assert(done <= SizeOf(outbuf));
      Move(outbuf, ABuffer^, done);
      Inc(ABuffer, done);
    end
    else
    if res = PDMP3_NEED_MORE then
    begin
      BufSize := Min(INBUF_SIZE, BufferSize);
      done := FStream.Read(FBuffer[0], BufSize);
      if done = 0 then
        Break;

      res := pdmp3_feed(h, FBuffer[0], done);
    end;

  end;
end;

{$ifndef WIN64}
constructor TMPEGIn.Create();
begin
  inherited Create(AOwner);
  FBufferSize:=$8000;
  FStreamDisabled:=True;
end;

destructor TMPEGIn.Destroy();
begin
  inherited Destroy;
end;

procedure TMPEGIn.OpenFile();
var
  spec: SDL_AudioSpec;
begin
  inherited OpenFile();
  if FOpened then
  begin
    (* the next call is needed just to make sure
      the SDL library is loaded *)
    {
    _M:=SMPEG_new(PChar(FFileName), info, 1);
    SMPEG_delete(_M);
    FValid:=True;
    }
    _M:=SMPEG_new(PChar(FFileName), info, 0);
    if not Assigned(_M) then Exit;
    if info.has_audio <> 1 then
    begin
      SMPEG_delete(_M);
      _M:=nil;
      FValid:=False;
      Exit;
    end;
    FTotalTime:=info.total_time / 2;
    SMPEG_wantedSpec(_M, spec);
    FSR:=spec.freq;
    FBPS:=16;
    if (spec.format = AUDIO_S8) or (spec.format = AUDIO_U8) then
      FBPS:=8;
    if (spec.format = AUDIO_S32) then
      FBPS:=32;
    if (spec.format = AUDIO_F32) then
      FBPS:=32;
    FChan:=spec.channels;
    FSampleSize:=FChan * (FBPS div 8);
    FSize:=Round(FTotalTime * FSR) * FSampleSize;
    FBufferSize:=spec.samples * FSampleSize;
    FValid:=True;
    FOpened:=True;
    SMPEG_play(_M);
  end;
end;

procedure TMPEGIn.CloseFile();
begin
  if FOpened then
  begin
    if SMPEG_status(_M) = SMPEG_PLAYING then SMPEG_stop(_M);
    SMPEG_delete(_M);
    inherited CloseFile();
  end;
end;

function TMPEGIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  Len, offs, AlignedSize: Integer;
  //tmp: Single;
begin
  if (not Active) or (not FOpened) then
    raise EACSException.Create('The Stream is not opened');

  if FAudioBuffer.UnreadSize <= 0 then
  begin
    //if FAudioBuffer.Size <> FBufferSize then FAudioBuffer.Size:=FBufferSize;
    FAudioBuffer.Reset();
    {
    if FOffset <> 0 then
    begin
      offs:=Round((FOffset / 100) * FSize);
      FPosition:=FPosition + offs;
      if FPosition < 0 then
        FPosition:=0
      else
        if FPosition > FSize then FPosition:=FSize;
      if FOffset < 0 then
      begin
        SMPEG_rewind(_M);
        SMPEG_play(_M);
        tmp:=(FPosition / FSize) * FTotalTime;
        SMPEG_skip(_M, tmp);
      end;
      tmp:=(FOffset / 100) * FTotalTime;
      SMPEG_skip(_M, tmp);
      FOffset:=0;
    end;
    }
    // it's very special voodoo!! looks like, SMPEG use XOR to set buffer content
    FillChar(FAudioBuffer.Memory^, FAudioBuffer.Size, 0);

    // align buffer size
    AlignedSize:=FAudioBuffer.Size - (FAudioBuffer.Size mod FSampleSize);
    // decode audio to PCM
    Len:=SMPEG_playAudio(_M, FAudioBuffer.Memory, AlignedSize);
    FAudioBuffer.WritePosition:=FAudioBuffer.WritePosition + Len;
    if Len = 0 then
    begin
      {
      if FLoop then
      begin
        Done();
        Init();
        SMPEG_rewind(_M);
        SMPEG_play(_M);
        FPosition:=0;
        //Len:=SMPEG_playAudio(_M, @FBuffer[BufEnd+1], ABufferSize - BufEnd);
        Len:=SMPEG_playAudio(_M, @Self.FBuffer[0], Self.BufferSize);
      end
      else
      }
      begin
        Result:=0;
        Exit;
      end;
    end;
  end;

  Result:=FAudioBuffer.UnreadSize;
  if Result > ABufferSize then Result:=ABufferSize;
  FAudioBuffer.Read(ABuffer^, Result);
  Inc(FPosition, Result);
end;
{$endif}

initialization
  FileFormats.Add('mp3', 'Mpeg Audio Layer 3', TMP3In);
  {$ifndef WIN64}
  if LoadMPEGLibrary() then
  begin
    //FileFormats.Add('mp3', 'Mpeg Audio Layer 3', TMPEGIn);
    FileFormats.Add('mp2', 'Mpeg Audio Layer 2', TMPEGIn);
    FileFormats.Add('mpeg', 'Mpeg Audio', TMPEGIn);
  end;
  {$endif}

finalization

{$ifndef WIN64}
  UnLoadMPEGLibrary();
{$endif}

end.

