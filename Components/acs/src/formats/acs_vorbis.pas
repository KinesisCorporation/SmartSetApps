(*
Vorbis file in/out components

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2010, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

{
Status:
TVorbisOut - not updated

TVorbisIn - AcsBuffer, tested

}

unit acs_vorbis;

{$DEFINE USE_VORBIS_11}

interface

uses
{$IFDEF LINUX}
  baseunix,
{$ENDIF}

  ACS_File, Classes, SysUtils, ACS_Classes, ogg, vorbiscodec, VorbisFile, VorbisEnc,
  ACS_Strings, acs_tags, acs_types;

type

  TVorbisBitRate = (brAutoSelect, br24, br32, br45, br48, br56, br64, br80, br96,
                 br112, br128, br144, br160, br192, br224, br256, br320, br499);

  { TVorbisOut }
  (* The Ogg Vorbis encoder component. More information on the Ogg Vorbis format
  may be found at http://xiph.org/vorbis/.
    Requires:
      - ogg.dll
      - vorbis.dll
      - vorbisenc.dll
      - vorbisfile.dll
  *)
  TVorbisOut = class(TAcsCustomFileOut)
  private
    FSerial: Integer;
    FDesiredNominalBitrate: TVorbisBitRate;
    FDesiredMaximumBitrate: TVorbisBitRate;
    FMinimumBitrate: TVorbisBitRate;
    OggSS: ogg_stream_state;
    OggPg: ogg_page;
    OggPk: ogg_packet;
    VInfo: vorbis_info;
    VComm: vorbis_comment;
    Vdsp: vorbis_dsp_state;
    VBlock: vorbis_block;
    header, header_comm, header_code: ogg_packet;
    FCompression: Single;
    EndOfStream: Boolean;
    FComments: TStringList;
    FTags: TVorbisTags;
    procedure SetComments(AComments: TStringList);
    procedure SetTags(AValue: TVorbisTags);
    procedure SetDesiredNominalBitrate(AValue: TVorbisBitRate);
    procedure SetDesiredMaximumBitrate(AValue: TVorbisBitRate);
    procedure SetMinimumBitrate(AValue: TVorbisBitRate);
    procedure InitVorbis();
  protected
    procedure SetFileMode(AMode: TAcsFileOutputMode); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(); override;
    procedure Done(); override;
    function DoOutput(Abort: Boolean):Boolean; override;
  published
    (* Property: Compression
      Set the compression ratio for the file being
      created. The valid values vary from -0.1 (maximum compression, lowest
      quality) to 1.0 (minimum compression, highest quality). If
      <DesiredNominalBitrate> property is assigned a value other than
      brAutoSelect, Compression property is ignored. *)
    property Compression: Single read FCompression write FCompression stored True;
    (* Property: Comments
       Add tags (comments) to an Ogg Vorbis file. The
       standard comments include Artist, Album, Title, Date, Genre, and Track. *)
    property Tags: TVorbisTags read FTags write SetTags;
    property Comments: TStringList read FComments write SetComments stored True;
    (* Property: DesiredMaximumBitrate
       Set the desired maximum bitrate limit for the file
       being created. The values of this property are brXXX constants,
       indicating bitrates in kbps. Depending on the parameters of the incoming
       audio data the actual maximum bitrate may be higher than that specified
       with this property. This property has an effect only if
       <DesiredNominalBitrate> property is assigned a value other than
       brAutoSelect. *)
    property DesiredMaximumBitrate: TVorbisBitRate read FDesiredMaximumBitrate write SetDesiredMaximumBitrate;
    (* Property: DesiredNominalBitrate
       If this property is set to a value other than brAutoSelect (the default
       value), the Compression property is ignored and the size/quality of the
       output file are determined by the values of <DesiredNominalBitrate>,
       <DesiredMaximumBitrate>, and <MinimumBitrate> properties. The values of
       this property are brXXX constants, indicating bitrates in kbps.
       Depending on the parameters of the incoming audio data the output file's
       actual nominal bitrate may be different from that specified with this
       property.

       Note:
       It is recommended by Ogg Vorbis developers to use the <Compression>
       property rather than specify bitrates directly. *)
    property DesiredNominalBitrate: TVorbisBitRate read FDesiredNominalBitrate write SetDesiredNominalBitrate;
    (* Property: MinimumBitrate
      Set the minimum bitrate limit for the file being
      created. The values of this property are brXXX constants, indicating
      bitrates in kbps. This property has an effect only if
      DesiredNominalBitrate property is assigned a value other than
      brAutoSelect.*)
    property MinimumBitrate: TVorbisBitRate read FMinimumBitrate write SetMinimumBitrate;
    (* Property: Serial
       Set the serial number of the logical bitstream in
       the Vorbis file. The value of this property is of concern only if you
       create multi-streamed Vorbis files (in foAppend mode). *)
    property Serial: Integer read FSerial write FSerial;
    //property Vendor: String read FVendor write FVendor;
  end;

  (* Class: TVorbisIn
    The Ogg  Vorbis decoder component. More
      information on the Ogg Vorbis format may be found at
      http://xiph.org/vorbis/.

    Requires:
      - ogg.dll
      - vorbis.dll
      - vorbisenc.dll
      - vorbisfile.dll  *)

  { TVorbisIn }

  TVorbisIn = class(TAcsCustomFileIn)
  private
    FComments: TStringList;
    FTags : TVorbisTags;
    //FVendor: String;
    VFile: OggVorbis_File;
    cursec: Integer;
    FMaxBitrate: Integer;
    FNominalBitrate: Integer;
    FMinBitrate: Integer;
    EndOfStream: Boolean;
    function GetMaxBitrate(): Integer;
    function GetNominalBitrate(): Integer;
    function GetMinBitrate(): Integer;
    function GetComments(): TStringList;
    function GetTags(): TVorbisTags;
    function GetBitStreams(): Integer;
    function GetInstantBitRate(): Integer;
    function GetCurrentBitStream(): Integer;
    procedure SetCurrentBitStream(BS: Integer);
  protected
    procedure OpenFile; override;
    procedure CloseFile; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    function Seek(SampleNum: Integer): Boolean; override;
    (* Property: BitStreams
      Read this property to get number of logical bitstreams in the
      multi-streamed file. By default the component plays all the bitstreams
      from the first to the last just as if they were the same bitstream. The
      playback time also refers to the total time of all the bitstreams. You
      need to handle bitstream-related properties only if you want to
      navigate between several bitstreams in a multi-streamed file. *)
    property BitStreams: Integer read GetBitStreams;
    (* Property: Comments
      Read tags (comments) added to an Ogg Vorbis file.
      The standard comments include Artist, Album, Title, Date, Genre, and
      Track. *)
    property Tags: TVorbisTags read GetTags;
    property Comments: TStringList read GetComments;
    (* Property: CurrentBitStream
      Read this property to get the number of the current bitstream being
      played (0 < = CurrentBitStream < BitStreams). Assigning a value to this
      property makes the component start playback from the beginning of the
      specified logical bitstream. This property can be used only during
      actual playback process. *)
    property CurrentBitStream: Integer read GetCurrentBitStream write SetCurrentBitStream;
    (* Property: InstantBitRate
      Get current bitrate (in bits per second) of the VBR-encoded Vorbis file. *)
    property InstantBitRate: Integer read GetInstantBitRate;
    (* Property: MaxBitrate
      Get the maximum bitrate (in bits per second) of the Vorbis file. *)
    property MaxBitrate: Integer read GetMaxBitrate;
    (* Property: MinBitrate
      Get the minimum bitrate (in bits per second) of the Vorbis file. *)
    property MinBitrate: Integer read GetMinBitrate;
    (* Property: NominalBitrate
      Get the nominal bitrate (in bits per second) of the Vorbis file. *)
    property NominalBitrate: Integer read GetNominalBitrate;
    //property Vendor: String read FVendor;
  published
    property EndSample;
    property StartSample;
  end;

implementation

function cbRead(ptr: Pointer; size, nmemb: Cardinal; const datasource: Pointer): Cardinal; cdecl;
var
  VI: TVorbisIn;
  //Buffer: array of Byte;
begin
  VI:=TVorbisIn(datasource);
  //SetLength(Buffer, size*nmemb);
  //Result:=VI.FStream.Read(Buffer[0], size*nmemb);
  Result:=VI.FStream.Read(ptr^, size*nmemb);
  //Move(Buffer[0], ptr^, Result);
  //SetLength(Buffer, 0);
end;

function cbSeek(const datasource: Pointer; offset: ogg_int64_t; whence: Integer): Integer; cdecl;
var
  VI: TVorbisIn;
  Origin: TSeekOrigin;
begin
  VI:=TVorbisIn(datasource);
  if not VI.Seekable then
  begin
    Result:=-1;
    Exit;
  end;
  case whence of
    SEEK_SET: Origin:=TSeekOrigin(soFromBeginning);
    SEEK_CUR: Origin:=TSeekOrigin(soFromCurrent);
    SEEK_END: Origin:=TSeekOrigin(soFromEnd);
  end;
  Result:=VI.FStream.Seek(offset, Origin);
end;

function cbClose(const datasource: Pointer): Integer; cdecl;
var
  VI: TVorbisIn;
begin
  VI:=TVorbisIn(datasource);
  if Assigned(VI.FStream) then FreeAndNil(VI.FStream);
  Result:=0;
end;

function cbTell(const datasource: Pointer): Integer; cdecl;
var
  VI: TVorbisIn;
begin
  VI:=TVorbisIn(datasource);
  Result:=VI.FStream.Position
end;

function VorbisBitrateToInt(Bitrate: TVorbisBitrate): Integer;
begin
  case Bitrate of
    br24: Result:=24000;
    br32: Result:=32000;
    br45: Result:=45000;
    br48: Result:=48000;
    br56: Result:=46000;
    br64: Result:=64000;
    br80: Result:=80000;
    br96: Result:=96000;
    br112: Result:=112000;
    br128: Result:=128000;
    br144: Result:=144000;
    br160: Result:=160000;
    br192: Result:=192000;
    br224: Result:=224000;
    br256: Result:=256000;
    br320: Result:=320000;
    br499: Result:=499000;
    else Result:=-1;
  end;
end;

{ TVorbisOut }

constructor TVorbisOut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBufferSize:=$10000; // default buffer size
  FCompression:=0.2;
  FComments:=TStringList.Create();
  FTags:=TVorbisTags.Create();
  FDesiredNominalBitrate:=brAutoSelect;
  FDesiredMaximumBitrate:=brAutoSelect;
  FMinimumBitrate:=brAutoSelect;
  if not (csDesigning in ComponentState) then
  begin
    if not LiboggLoaded then
      raise EAcsException.Create(Format(strCoudntloadLib,[Liboggpath]));
    if not LibvorbisLoaded then
      raise EAcsException.Create(Format(strCoudntloadLib,[LibvorbisPath]));
    if not LibvorbisfileLoaded then
      raise EAcsException.Create(Format(strCoudntloadLib,[LibvorbisfilePath]));
    if not LibvorbisencLoaded then
      raise EAcsException.Create(Format(strCoudntloadLib,[LibvorbisencPath]));
  end;
end;

destructor TVorbisOut.Destroy();
begin
  FreeAndNil(FTags);
  FreeAndNil(FComments);
  inherited Destroy();
end;

procedure TVorbisOut.SetComments(AComments: TStringList);
begin
  FComments.Assign(AComments);
end;

procedure TVorbisOut.SetTags(AValue: TVorbisTags);
begin
  FTags.Assign(AValue);
end;

procedure TVorbisOut.Init();
var
  i, maxbr, minbr, nombr: Integer;
  Name, Value: String;
begin
  inherited Init();

  if FFileMode = foAppend then
    FStream.Seek(0, soFromEnd);
  EndOfStream:=False;
  InitVorbis();
 (*
  vorbis_info_init(VInfo);
  if DesiredNominalBitrate = brAutoSelect then
  begin
    {$IFNDEF USE_VORBIS_11}
    vorbis_encode_init_vbr(VInfo, FInput.Channels, FInput.SampleRate, FCompression);
    {$ENDIF}
    {$IFDEF USE_VORBIS_11}
    vorbis_encode_setup_vbr(VInfo, FInput.Channels, FInput.SampleRate, FCompression);
    vorbis_encode_setup_init(VInfo);
    {$ENDIF}
  end
  else
  begin
    nombr:=VorbisBitrateToInt(FDesiredNominalBitrate);
    maxbr:=VorbisBitrateToInt(FDesiredMaximumBitrate);
    if maxbr < nombr then maxbr:=nombr;
    minbr:=VorbisBitrateToInt(Self.FMinimumBitrate);
    if minbr < 0 then minbr:=nombr;
    vorbis_encode_init(VInfo, FInput.Channels, FInput.SampleRate, maxbr, nombr, minbr);
  end;
  vorbis_comment_init(VComm);
  for i:=0 to FComments.Count-1 do
  begin
    Name:=FComments.Names[i];
    Value:=FComments.Values[Name];
    vorbis_comment_add_tag(VComm, PChar(Name), PChar(Value));
  end;
  vorbis_analysis_init(Vdsp, VInfo);
  vorbis_block_init(Vdsp, VBlock);
  ogg_stream_init(OggSS, FSerial);
  vorbis_analysis_headerout(Vdsp, VComm, header, header_comm, header_code);
  ogg_stream_packetin(OggSS, header);
  ogg_stream_packetin(OggSS, header_comm);
  ogg_stream_packetin(OggSS, header_code);
  while ogg_stream_flush(OggSS, OggPg) <> 0 do
  begin
    FStream.Write(OggPg.header^, OggPg.header_len);
    FStream.Write(OggPg.body^, OggPg.body_len);
  end;
  *)
end;

procedure TVorbisOut.Done();
begin
  FComments.Clear();
  FTags.Clear();
  ogg_stream_clear(OggSS);
  vorbis_block_clear(VBlock);
  vorbis_dsp_clear(Vdsp);
  vorbis_comment_clear(VComm);
  vorbis_info_clear(VInfo);
  inherited Done();
end;

function TVorbisOut.DoOutput(Abort: Boolean):Boolean;
var
  i, j, SamplesRead, BytesPerSample : LongWord;
  Len: LongWord;
  out_buf: PPFloat;
  tmpBuf: array[0..16] of PFloat;
  buf8: PAcsBuffer8;
  Ptr : Pointer;
  wres : Integer;
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
  BytesPerSample := FInput.Channels * (FInput.BitsPerSample div 8);
  SamplesRead := Len div BytesPerSample;
  out_buf := vorbis_analysis_buffer(Vdsp, FBuffer.Size);
  if Len <> 0 then
  begin
    buf8:=FBuffer.Memory;
    if FInput.BitsPerSample = 16 then
    begin
      tmpBuf[0] := out_buf^;
      for j := 1 to FInput.Channels - 1 do
      begin
        Inc(out_buf);
        tmpBuf[j] := out_buf^;
      end;
      for i:=0 to SamplesRead - 1 do
        for j := 0 to Finput.Channels - 1 do
          tmpBuf[j][i] := buf8[i * FInput.Channels + j]/$8000;
    end

    else if FInput.BitsPerSample = 8 then
    begin
      tmpBuf[0] := out_buf^;
      for j := 1 to FInput.Channels - 1 do
      begin
        Inc(out_buf);
        tmpBuf[j] := out_buf^;
      end;
      for i := 0 to SamplesRead - 1 do
        for j := 0 to FInput.Channels - 1 do
          tmpBuf[j][i] := (buf8[i*FInput.Channels + j] - 128)/128;
    end

    else  // 24 bit
    begin
      tmpBuf[0] := out_buf^;
      for j := 1 to FInput.Channels - 1 do
      begin
        Inc(out_buf);
        tmpBuf[j] := out_buf^;
      end;
      for i := 0 to SamplesRead - 1 do
        for j := 0 to FInput.Channels - 1 do
          tmpBuf[j][i] := ((PSmallInt(@buf8[i*BytesPerSample + j*3 + 1])^ shl 8)
           + buf8[i*BytesPerSample + j*3])/8388608;
    end;
    vorbis_analysis_wrote(Vdsp, SamplesRead);
  end
  else // if Len <> 0
    vorbis_analysis_wrote(Vdsp, 0);

  while vorbis_analysis_blockout(Vdsp, VBlock) = 1 do
  begin
    vorbis_analysis(VBlock, nil);
    vorbis_bitrate_addblock(VBlock);
    while vorbis_bitrate_flushpacket(Vdsp, OggPk) <> 0 do
    begin
      ogg_stream_packetin(OggSS, OggPk);
      while not EndOfStream do
      begin
        if ogg_stream_pageout(OggSS, OggPg) = 0 then Break;
        wres := FStream.Write(OggPg.header^, OggPg.header_len);
        if wres <> OggPg.header_len then
          raise EAcsException.Create('Error writing ogg file');
        wres := FStream.Write(OggPg.body^, OggPg.body_len);
        if wres <> OggPg.body_len then
          raise EAcsException.Create('Error writing ogg file');
        if ogg_page_eos(OggPg) <> 0 then EndOfStream := True;
      end;
    end;
  end;
end;

{ TVorbisIn }

constructor TVorbisIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBufferSize:=$8000;
  FComments:=TStringList.Create();
  FTags:=TVorbisTags.Create();
  if not (csDesigning in ComponentState) then
  begin
    if not LiboggLoaded then
    raise EAcsException.Create(Format(strCoudntloadLib, [LiboggPath]));
    if not LibvorbisLoaded then
    raise EAcsException.Create(Format(strCoudntloadLib, [LibvorbisPath]));
    if not LibvorbisfileLoaded then
    raise EAcsException.Create(Format(strCoudntloadLib, [LibvorbisfilePath]));
    if not LibvorbisencLoaded then
    raise EAcsException.Create(Format(strCoudntloadLib, [LibvorbisencPath]));
  end;
end;

destructor TVorbisIn.Destroy();
begin
  FreeAndNil(FTags);
  FreeAndNil(FComments);
  inherited Destroy();
end;

procedure TVorbisIn.OpenFile();
var
  PVComm: PVORBIS_COMMENT;
  PVInfo: PVORBIS_INFO;
  PComment: PPAnsiChar;
  Comment: PAnsiChar;
  StrComment: AnsiString;
  Callbacks: OV_CALLBACKS;
  res, n : Integer;
  CN, CV : String;
begin
  OpenCS.Enter();
  try
    inherited OpenFile();
    if FOpened then
    begin
      FValid:=False;
      EndOfStream:=False;
      Callbacks.read_func:=cbRead;
      Callbacks.close_func:=cbClose;
      Callbacks.seek_func:=cbSeek;
      Callbacks.tell_func:=cbTell;
      res:=ov_open_callbacks(Self, VFile, nil, 0, Callbacks);
      if res <> 0 then
        raise EAcsException.Create('Failed to open an ogg file: ' + IntToStr(res));
      ov_test_open(VFile);

      FComments.Clear();
      PVComm:=ov_comment(VFile, -1);
      PComment:=PVComm.user_comments;
      Comment:=PComment^;

      while Comment <> nil do
      begin
        StrComment:=Comment;
        FComments.Add(StrComment);
        n:=Pos('=', StrComment);
        CN := Copy(StrComment, 1, n-1);
        CV := Copy(StrComment, n+1, MaxInt);
        CN := AnsiLowerCase(CN);
        if      CN = _vorbis_Artist then FTags.Artist := UTF8Decode(CV)
        else if CN = _vorbis_Album  then FTags.Album := UTF8Decode(CV)
        else if CN = _vorbis_Title  then FTags.Title := UTF8Decode(CV)
        else if CN = _vorbis_Date   then FTags.Date := UTF8Decode(CV)
        else if CN = _vorbis_Genre  then FTags.Genre := UTF8Decode(CV)
        else if CN = _vorbis_Track  then FTags.Track := UTF8Decode(CV);

        Inc(PtrUInt(PComment), SizeOf(PVComm.user_comments));
        Comment:=PComment^;
      end;
      //FVendor:=PVComm.vendor;
      PVInfo:=ov_info(VFile, -1);
      FChan:=PVInfo.channels;
      FSR:=PVInfo.rate;
      FBPS:=16;
      FMaxBitrate:=PVInfo.bitrate_upper;
      FNominalBitrate:=PVInfo.bitrate_nominal;
      FMinBitrate:=PVInfo.bitrate_lower;
      FTotalSamples:=ov_pcm_total(VFile, -1);
      FSize:=(FTotalSamples shl 1) * PVInfo.channels;
      cursec:=-1;
      FTotalTime:=ov_time_total(VFile, -1);
      //ov_pcm_seek(VFile, FOffset);
      FValid:=True;
      FOpened:=True;
    end;

  finally
    OpenCS.Leave();
  end;
end;

procedure TVorbisIn.CloseFile();
begin
  OpenCS.Enter();
  try
    if FOpened then
    begin
      //if ov_seekable(VFile) <> 0 then ov_pcm_seek(VFile, 0);
      ov_clear(VFile);
      FOpened:=False;
    end;
    inherited CloseFile();
  finally
    OpenCS.Leave();
  end;
end;

function TVorbisIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  Len, offs, BufSizeRemain: Integer;
begin
  if not Active then
    raise EAcsException.Create('The Stream is not opened');
  if FAudioBuffer.UnreadSize <= 0 then
  begin
    {
    // seek if offset defined
    if FOffset <> 0 then
    begin
      offs:=Round((FOffset/100)*FSize);
      FPosition:=FPosition + offs;
      if FPosition < 0 then FPosition:=0
      else if FPosition > FSize then FPosition:=FSize;
      //tmp:=(FPosition/FSize)*FTime;
      if ov_seekable(VFile) <> 0 then
      ov_pcm_seek(VFile, (FPosition shr 1) div FChan);
      FOffset:=0;
    end;
    }

    FAudioBuffer.Reset();
    BufSizeRemain:=FAudioBuffer.Size;
    if not EndOfStream then
    begin
      (* The ov_read function can return data in quite small chunks
        (of about 512 bytes). We keep reading data until the ABuffer is filled
        or there is no more data to read. *)
      while BufSizeRemain > 0 do
      begin
        Len:=ov_read(VFile, (FAudioBuffer.Memory+FAudioBuffer.WritePosition), BufSizeRemain, 0, 2, 1, @cursec);
        FAudioBuffer.WritePosition:=FAudioBuffer.WritePosition + Len;
        Dec(BufSizeRemain, Len);
        if Len <= 0 then
        begin
          EndOfStream:=True;
          Break;
        end;
      end;
    end;
  end;

  Result:=ABufferSize;
  if Result > FAudioBuffer.UnreadSize then
    Result:=FAudioBuffer.UnreadSize;
  FAudioBuffer.Read(ABuffer^, Result);
  Inc(FPosition, Result);
end;

function TVorbisIn.GetMaxBitrate(): Integer;
begin
  Result:=FMaxBitrate;
end;

function TVorbisIn.GetNominalBitrate(): Integer;
begin
  Result:=FNominalBitrate;
end;

function TVorbisIn.GetComments(): TStringList;
begin
  Result:=FComments;
end;

function TVorbisIn.GetTags(): TVorbisTags;
begin
  Result:=FTags;
end;

function TVorbisIn.GetMinBitrate(): Integer;
begin
  Result:=FMinBitrate;
end;

procedure TVorbisOut.SetFileMode(AMode: TAcsFileOutputMode);
begin
  FFileMode:=AMode;
end;

function TVorbisIn.GetBitStreams(): Integer;
begin
  Result:=0;
  if Active then
  begin
    if ov_seekable(VFile)<>0 then
      Result:=ov_streams(VFile);
  end;
end;

function TVorbisIn.GetInstantBitRate(): Integer;
begin
  Result:=0;
  if Active then
  begin
    Result:=ov_bitrate_instant(VFile);
  end;
end;

function TVorbisIn.GetCurrentBitStream(): Integer;
begin
  Result:=-1;
  if Active then
  begin
    if ov_seekable(VFile)<>0 then
      Result:=VFile.current_link;
  end;
end;

procedure TVorbisIn.SetCurrentBitStream(BS: Integer);
var
  Offset: POGG_INT64_T;
begin
  if Active then
  begin
    if ov_seekable(VFile)<>0 then
      if (BS >= 0) and (BS < ov_streams(VFile)) then
      begin
        Offset:=VFile.offsets;
        Inc(Offset, BS);
        FStream.Seek(Offset^, soFromBeginning);
      end;
  end;
end;

procedure TVorbisOut.SetDesiredNominalBitrate(AValue: TVorbisBitRate);
begin
  FDesiredNominalBitrate:=AValue;
  if FMinimumBitrate > FDesiredNominalBitrate then
    FMinimumBitrate:=FDesiredNominalBitrate;
  if FDesiredMaximumBitrate < FDesiredNominalBitrate then
    FDesiredMaximumBitrate:=FDesiredNominalBitrate;
  if FDesiredNominalBitrate = brAutoSelect then
    FDesiredMaximumBitrate:=brAutoSelect;
end;

procedure TVorbisOut.SetDesiredMaximumBitrate(AValue: TVorbisBitRate);
begin
  if FDesiredNominalBitrate = brAutoSelect then Exit;
  if (AValue = brAutoSelect) or (AValue >= FDesiredNominalBitrate) then
  FDesiredMaximumBitrate:=AValue;
end;

procedure TVorbisOut.SetMinimumBitrate(AValue: TVorbisBitRate);
begin
  if AValue <= FDesiredNominalBitrate then FMinimumBitrate:=AValue;
end;

procedure TVorbisOut.InitVorbis();
var
  i, maxbr, minbr, nombr : Integer;
  Name, Value : AnsiString;
begin
  vorbis_info_init(VInfo);
  if DesiredNominalBitrate = brAutoSelect then
  begin
    (* {$IFNDEF USE_VORBIS_10}
    if vorbis_encode_init_vbr(@VInfo, FInput.Channels, FInput.SampleRate, FCompression) <> 0 then
      raise EACSException.Create('Vorbis init failed');
    if vorbis_encode_setup_init(@VInfo) <> 0 then
      raise EACSException.Create('Vorbis setup failed');
    {$ENDIF} *)
    {$IFDEF USE_VORBIS_11}
    vorbis_encode_setup_vbr(VInfo, FInput.Channels, FInput.SampleRate, FCompression);
    vorbis_encode_setup_init(VInfo);
    {$ENDIF}
  end
  else
  begin
    nombr := VorbisBitrateToInt(FDesiredNominalBitrate);
    maxbr := VorbisBitrateToInt(FDesiredMaximumBitrate);
    //if maxbr < nombr then maxbr := nombr;
    minbr := VorbisBitrateToInt(Self.FMinimumBitrate);
    if minbr < 0 then minbr := nombr;
    if vorbis_encode_init(VInfo, FInput.Channels, FInput.SampleRate, maxbr, nombr, minbr) <> 0 then
      raise EAcsException.Create('Vorbis codec setup with the requested bitrate failed. Try a lower bitrate.');

  end;
  // tags
  vorbis_comment_init(VComm);
  for i := 0 to FTags.IdCount - 1 do
  begin
    Name := Utf8Encode(WideString(FTags.Ids[i]));
    Value := Utf8Encode(FTags.AsWideString[FTags.Ids[i]]);
    if Value <> '' then
      vorbis_comment_add_tag(VComm, PAnsiChar(@Name[1]), PAnsiChar(@Value[1]));
  end;

  vorbis_analysis_init(Vdsp, VInfo);
  vorbis_block_init(Vdsp, VBlock);
  ogg_stream_init(OggSS, FSerial);
  vorbis_analysis_headerout(Vdsp, VComm, header, header_comm, header_code);
  ogg_stream_packetin(OggSS, header);
  ogg_stream_packetin(OggSS, header_comm);
  ogg_stream_packetin(OggSS, header_code);
  while ogg_stream_flush(OggSS, OggPg) <> 0 do
  begin
    FStream.Write(OggPg.header^, OggPg.header_len);
    FStream.Write(OggPg.body^, OggPg.body_len);
  end;
end;

function TVorbisIn.Seek(SampleNum: Integer): Boolean;
begin
  Result:=False;
  if not FSeekable then Exit;
  if FOpened then ov_pcm_seek(VFile, SampleNum);
  Result:=True;
end;
  
initialization
  if VorbisLoadLibrary() then
  begin
    FileFormats.Add('ogg', 'Ogg Vorbis', TVorbisOut);
    FileFormats.Add('ogg', 'Ogg Vorbis', TVorbisIn);
  end;

finalization
  VorbisUnloadLibrary();

end.
