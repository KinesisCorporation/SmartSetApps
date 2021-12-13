(*
WAVE components

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2010, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)
{
Status:
TWaveOut - not tested
todo: update header on file finalization

TWaveIn: AcsBuffer
  PCM       - Win: OK, Lin: not tested
  MS ADPCM  - Win: OK, Lin: not tested
  IMA ADPCM - Win: OK, Lin: not tested
  ACM       - not tested
  ExtPCM    - not tested
  IEEEFloat - not tested
}

unit acs_wave;

interface

uses

  // This is required to enable TWaveIn read MS ACM (MP3-encoded) files.
  {$IFDEF MSWINDOWS}
  MSAcm, waveconverter, mmsystem,
  {$ENDIF}

  {$ifdef LINUX}
  Math, MAD,
  {$endif}
  ACS_File, Classes, SysUtils, ACS_Types, ACS_Classes, ACS_Strings{, dbugintf};

type
  TFourCC = array [0..3] of AnsiChar;

  {$ifdef LINUX}
  TWaveFormatEx = packed record
    wFormatTag: word;
    nChannels: word;
    nSamplesPerSec: DWORD;
    nAvgBytesPerSec: DWORD;
    nBlockAlign: word;
    wBitsPerSample: word;
    cbSize: word;
  end;
  {$endif}

  TWaveFormatExtensible = packed record
    Format: TWaveFormatEx;
    wValidBitsPerSample: word;
    dwChannelMask: longword;
    SubFormat: TGUID;
  end;
  PWaveFormatExtensible = ^TWaveFormatExtensible;

  (* Enum: TWavType
      The format of the WAV.

    - wtUnsupported - a WAV format that isn't supported
    - wtPCM - a WAV which is raw PCM (the normal format, use this if you're unsure)
    - wtIMA_ADPCM - a WAV which is DVI IMA ADPCM
    - wtMS_ADPCM - a WAV which is MS ADPCM
    - wtACM - an MP3 packed inside a WAV
    - wtIEEEFloat - floating point encoding (32 or 64 bits)
    - wtExtPCM - raw PCM encoding with WaveFormatExtensible header.
    - wtExtIEEEFloat - floating point encoding with WaveFormatExtensible header.
  *)
  TWavType = (wtUnsupported, wtPCM, wtIMA_ADPCM, wtMS_ADPCM, wtACM,
    wtIEEEFloat, wtExtPCM, wtExtIEEEFloat);

  (* Record: TWaveHeader
      Represents a RIFF file header.
  *)
  TWaveHeader = packed record
    // RIFF file header     // offs: value
    RIFF: TFourCC;          // 0000: 'RIFF'
    FileSize: Int32;        // 0004: FileSize - 8
    RIFFType: TFourCC;      // 0008: 'WAVE'
    // Format chunk
    FmtChunkId: TFourCC;    // 0012: 'fmt' - marks the beginning of the format chunk
    FmtChunkSize: Int32;    // 0016: 16 - the size of the format chunk
    FormatTag: word;        // 0020: One of WAVE_FORMAT_XXX constants
    Channels: word;         // 0022: 1=mono, 2=stereo
    SampleRate: Int32;      // 0024: sample rate
    BytesPerSecond: Int32;  // 0028: bytes per second
    BlockAlign: word;       // 0032: block alignment in bytes
    BitsPerSample: word;    // 0034: 8, 16 or 32 Bits/sample
    // Data Chunk
    DataChunkId: TFourCC;   // 0036: 'data' - marks the beginning of the data chunk
    DataSize: Int32;        // 0040: Data size in bytes
  end;

  (*
  Record: TWaveHeaderExt
    Represents a WaveFormatExtensible header.
  *)
  TWaveHeaderExt = packed record
    // RIFF file header     // offs: value
    RIFF: TFourCC;          // 0000: 'RIFF'
    FileSize: Int32;        // 0004: FileSize - 8
    RIFFType: TFourCC;      // 0008: 'WAVE'
    // Format chunk
    FmtChunkId: TFourCC;    // 0012: 'fmt' - marks the beginning of the format chunk
    FmtChunkSize: Int32;    // 0016: the size of the format chunk
    Format: TWaveFormatExtensible;
    // Data Chunk
    DataChunkId: TFourCC;   // 'data' - marks the beginning of the data chunk
    DataSize: Int32;        // Data size in bytes
  end;


(* Record: TIMA_ADPCMHeader
    RIFF file header for DVIADPCM (version NNFCAIWFLDL).
  *)
  TIMA_ADPCMHeader = packed record
    // RIFF file header     // offs: value
    RIFF: TFourCC;          // 0000: 'RIFF'
    FileSize: Int32;        // 0004: FileSize - 8
    RIFFType: TFourCC;      // 0008: 'WAVE'
    // Format chunk
    FmtChunkId: TFourCC;    // 0012: 'fmt' - marks the beginning of the format chunk
    FmtChunkSize: Int32;    // 0016: the size of the format chunk = 20
    FormatTag: word;        // 0020: WAVE_FORMAT_DVI_ADPCM
    Channels: word;         // 0022: 1=mono, 2=stereo
    SampleRate: Int32;      // 0024: sample rate
    BytesPerSecond: Int32;  // 0028: bytes per second
    BlockAlign: word;       // 0032: block alignment in bytes
    BitsPerSample: word;    // 0034: 8, 16 or 32 Bits/sample
    cbSize: word;           // 0036: The size in bytes of the extra information
    SamplesPerBlock: word;  // 0038: number of samples per channel per Block
    // Fact Chunk
    FactChunkId: TFourCC;   // 0040: 'fact' begin Fact Chunk
    FactChunkSize: Int32;   // 0044: size of chunk = 4
    DataLength: Int32;      // 0048: samples count
    // Data Chunk
    DataChunkId: TFourCC;   // 0052: 'data' begin Data Chunk
    DataSize: Int32;        // 0056: Data chunk size in bytes
  end;

  TIMA_ADPCMBlockHeader = packed record
    Samp0: Int16;           // initial predictor (in little-endian format)
    StepTableIndex: Int8;   // initial index
    Reserved: Int8;         // unknown, usually 0 and is probably reserved
  end;

  TIMA_ADPCM_INFO = packed record
    BlockLength: word;
    SamplesPerBlock: word;
    DataSize: Int32;
  end;

  TIMA_ADPCM_STATE_STEREO = packed record
    valprev: array[0..1] of Int16;      // Previous output value
    index: array[0..1] of byte;         // Index into stepsize table
  end;

  TIMA_ADPCM_ENCODE_STATE_STEREO = packed record
    PredSamp_l: Int16;
    Index_l: byte;
    PredSamp_r: Int16;
    Index_r: byte;
  end;

  TMS_ADPCM_COEF_SET = packed record
    Coef1, Coef2: Int16;
  end;

  // MS ADPCM
  TMS_ADPCM_INFO = packed record
    BlockLength: word;
    SamplesPerBlock: word;
    DataSize: Int32;
    NumCoeff: word;
    CoefSets: array[0..31] of TMS_ADPCM_COEF_SET; // Is that enough?
  end;

  TMSADPCMBlockHeaderMono = packed record
    predictor: byte;
    Delta: Int16;
    Samp1: Int16;
    Samp2: Int16;
  end;

  TMSADPCMBlockHeaderStereo = packed record
    predictor: array[0..1] of byte;
    Delta: array[0..1] of Int16;
    Samp1: array[0..1] of Int16;
    Samp2: array[0..1] of Int16;
  end;

const
  // Hack: Wave is the only format where i must use an const buffer
  // all dynamic buffers crash on Move in GetData no matter why
  BUFFER_SIZE = $8000;

type

  { TWaveOut }

  TWaveOut = class(TAcsCustomFileOut)
  private
    EndOfInput: boolean;
    //Buffer: array [0..BUF_SIZE-1] of Byte;
    FWavType: TWavType;
    FEncodeState: TIMA_ADPCM_ENCODE_STATE_STEREO;
    FPrevSR: longword;
    FPrevCh: word;
    FPrevBPS: word;
    FPrevLen: integer;
    FLenOffs: integer;
    FPrevDataSize: integer;
    FDataSizeOffs: integer;
    FPrevWavType: TWavType;
    HeaderSize: integer;
    FBlockAlign: word;
    FNonMsHeaders: boolean;
    // total input size in bytes (not initiated!!!)
    FInputSize: cardinal;
    procedure SetWavType(WT: TWavType);
    procedure ReadRIFFHeader();
    procedure FinalizeStream();
    procedure FillHeaderPCM(var Header: TWaveHeader);
    procedure FillHeaderExtPCM(var Header: TWaveHeaderExt);
    procedure FillHeaderIMA_ADPCM(var Header: TIMA_ADPCMHeader);
    procedure SetBlockSize(BS: word);
    procedure EncodeDVIADPCMMono(InData: PAcsBuffer16; OutData: PAcsBuffer8);
    procedure EncodeDVIADPCMStereo(InData: PAcsBuffer16; OutData: PAcsBuffer8);
  protected
    procedure SetFileMode(AMode: TAcsFileOutputMode); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(); override;
    procedure Done(); override;
    function DoOutput(Abort: boolean): boolean; override;
  published
    (* Property: WavType
      Use this <TWavType> property to specify output .wav file encoding. When
      you append data to an existing file (with data in either raw PCM or MS
      DVI IMA ADPCM encoding) this property will be automatically set to the
      file encoding. Only wtPCM, wtExtPCM, and wtIMA_ADPCM formats are supported for encoding.
      Do not set wtExtPCM directly. This format is chosen automatically if you encode audio with more than 24 bits per sample or more than 2 channels and <CreateNonMsHeaders> is set to False. *)
    property WavType: TWavType read FWavType write SetWavType;
    (*Property: BlockSize
      Use this property to set the size of the DVI IMA ADPCM block in bytes
      (when using DVI IMA ADPCM encoding). The size of the block must be a
      multiple of four. Since all the blocks in the file must be the same
      size, the size of the block will be set automatically when appending
      data to the existing MS DVI IMA ADPCM encoded file.*)
    property BlockSize: word read FBlockAlign write SetBlockSize;
    (* Property: CreateNonMsHeaders
      Use this property to specify the headers format for output files with more than 16 bits per sample and more than 2 channels.
      Microsoft uses its own headers format for these files and this format is the only one supported by Windows Media Player 9 (although later versions of the player support both types of headers).
      WinAmp and many other programs can also play both formats, but some programs such as Sound Forge and Reaper only understand conventional headers.
      The default value for this property is True which makes the component produce files non-readable by WM Player 9, but readable by most other programs (including later versions of Windows Media Player) out there .
      Set it to False if you want to generate files with MS-specific headers. *)
    property CreateNonMsHeaders: boolean read FNonMsHeaders write FNonMsHeaders;
    property FileMode;
  end;

  { TWaveIn }
  { TWaveIn component reads audio data from wave files (these files usually have
    .wav extension). Currently supported encodings enclude: raw PCM, Microsoft
    DVI IMA ADPCM (4:1), Microsoft ADPCM, and ACM (see the WavType property).
    Note: under Linux ACM (MP3) files are played with MAD library (libmad).

    In order to work with the resulting audio stream you have to assign WaveIn
    component to Input property of some converter or output component. }
  TWaveIn = class(TAcsCustomFileIn)
  private
    _WavType: TWavType;
    IMA_ADPCM_INFO: TIMA_ADPCM_INFO;
    IMA_ADPCM_STATE: TIMA_ADPCM_STATE_STEREO;
    MS_ADPCM_INFO: TMS_ADPCM_INFO;
    MS_ADPCM_STATE: TMSADPCMBlockHeaderStereo;
    HeaderSize: word;
    _MS: TMemoryStream;
    OldStream: TStream;
    OldStreamAssigned: boolean;
    //TmpBuffer: Pointer;
    TmpBuffer: array of byte;
    ShortIEEEFloat: boolean;
    {$IFDEF LINUX}
    // MS ACM stuff
    HasFirstFrame: boolean;
    InputDone: boolean;
    Data: Pointer;
    DataLen: integer;
    {$ENDIF}
    function ReadDecodeIMAADPCMBlock(AOutBuf: Pointer; AOutBufSize: integer): integer;
    function ReadDecodeMSADPCMBlock(AOutBuf: Pointer; AOutBufSize: integer): integer;
    function GetWavType(): TWavType;
    procedure ReadRIFFHeader();
  protected
    procedure OpenFile(); override;
    procedure CloseFile(); override;
  public
    (* Property: WavType
      This <TWavType> property indicates the current .wav file encoding. *)
    property WavType: TWavType read GetWavType;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: integer): integer; override;
    function Seek(SampleNum: integer): boolean; override;
  published
    property EndSample;
    property StartSample;
  end;

implementation

const
  WaveHeaderOffs = 44;
  DataSizeOffs = 40;
  WAVE_FORMAT_PCM = 1;
  WAVE_FORMAT_ADPCM = 2;
  WAVE_FORMAT_IEEE_FLOAT = 3;
  WAVE_FORMAT_ALAW = 6;
  WAVE_FORMAT_MULAW = 7;
  WAVE_FORMAT_DVI_IMA_ADPCM = 17;
  WAVE_FORMAT_IMA_ADPCM = $11;
  WAVE_FORMAT_MP3 = 85;
  WAVE_FORMAT_EXTENSIBLE = $FFFE;
  KSDATAFORMAT_SUBTYPE_PCM: TGuid = '{00000001-0000-0010-8000-00aa00389b71}';
  KSDATAFORMAT_SUBTYPE_IEEE_FLOAT: TGuid = '{00000003-0000-0010-8000-00aa00389b71}';

  // DVI IMA ADPCM stuff
  StepTab: array[0..88] of Int16 = (
    7, 8, 9, 10, 11, 12, 13, 14,
    16, 17, 19, 21, 23, 25, 28, 31,
    34, 37, 41, 45, 50, 55, 60, 66,
    73, 80, 88, 97, 107, 118, 130, 143,
    157, 173, 190, 209, 230, 253, 279, 307,
    337, 371, 408, 449, 494, 544, 598, 658,
    724, 796, 876, 963, 1060, 1166, 1282, 1411,
    1552, 1707, 1878, 2066, 2272, 2499, 2749, 3024,
    3327, 3660, 4026, 4428, 4871, 5358, 5894, 6484,
    7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,
    15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794,
    32767);

  IndexTab: array[0..15] of Int16 =
    (-1, -1, -1, -1, 2, 4, 6, 8, -1,
    -1, -1, -1, 2, 4, 6, 8);

  // MS ADPCM Stuff

  adaptive: array[0..15] of Int16 =
    (
    230, 230, 230, 230, 307, 409, 512, 614,
    768, 614, 512, 409, 307, 230, 230, 230
    );

  LookingForRIFF = 0;
  LookingForWave = 1;
  LookingForFMT  = 2;
  LookingForFACT = 3;
  LookingForDATA = 4;


function Compare4(S1, S2: PChar): boolean;
var
  i, Diff: byte;
begin
  Result := False;
  for i := 0 to 3 do
  begin
    Diff := Abs(byte(S1[i]) - byte(S2[i]));
    if not (Diff in [0, 32, 224]) then
      Exit;
  end;
  Result := True;
end;

procedure ConvertIEEEFloatTo32(InOutBuf: PAcsBuffer32; InSize: integer);
var
  i: integer;
begin
  {$R-}
  for i := 0 to (InSize div 8) - 1 do
  begin
    if PDouble(@InOutBuf[i * 2])^ >= 1 then
      InOutBuf[i] := High(Int32)
    else
    if PDouble(@InOutBuf[i * 2])^ <= -1 then
      InOutBuf[i] := Low(Int32)
    else
    if PDouble(@InOutBuf[i * 2])^ = 0 then
      InOutBuf[i] := 0
    else
      InOutBuf[i] := Round(PDouble(@InOutBuf[i * 2])^ * High(Int32));
  end;
  {$R+}
end;

procedure ConvertShortIEEEFloatTo32(InOutBuf: PAcsBuffer32; InSize: integer);
var
  i: integer;
begin
  {$R-}
  for i := 0 to (InSize div 4) - 1 do
  begin
    if PSingle(@InOutBuf[i])^ >= 1 then
      InOutBuf[i] := High(Int32)
    else
    if PSingle(@InOutBuf[i])^ <= -1 then
      InOutBuf[i] := Low(Int32)
    else
    if PSingle(@InOutBuf[i])^ = 0 then
      InOutBuf[i] := 0
    else
      InOutBuf[i] := Round(PSingle(@InOutBuf[i])^ * High(Int32));
  end;
  {$R+}
end;

{$IFDEF LINUX}

function InputFunc(CData: Pointer; Stream: p_mad_stream): integer; cdecl;
var
  WI: TWaveIn;
begin
  WI := TWaveIn(CData);
  if WI.InputDone then
  begin
    Result := MAD_FLOW_STOP;
    Exit;
  end;
  WI.InputDone := True;
  mad_stream_buffer(Stream, WI.Data, WI.DataLen);
  Result := MAD_FLOW_CONTINUE;
end;

function OutputFunc(CData: Pointer; Header: p_mad_header;
  pcm: p_mad_pcm): integer; cdecl;
var
  WI: TWaveIn;
  WH: TWaveHeader;
  i, framesize: integer;
  outsamples: array[0..2303] of smallint;
  Text: array[0..4] of char;
begin
  WI := TWaveIn(CData);
  if not WI.HasFirstFrame then
  begin
    WI.FSR := pcm^.samplerate;
    WI.FChan := pcm^.channels;
    WI.FBPS := 16;
    framesize := Ceil(144 * Header^.bitrate / Header^.samplerate);
    WI.FSize := Round(WI.DataLen / framesize * 1152) * WI.FChan * 2;
    WI.FValid := True;
    Text := 'RIFF';
    Move(Text[0], WH.RIFF[0], 4);
    WH.FileSize := WI.FSize + 44;
    Text := 'WAVE';
    Move(Text[0], WH.RIFFType[0], 4);
    Text := 'fmt ';
    Move(Text[0], WH.FmtChunkId[0], 4);
    WH.FmtChunkSize := 16;
    WH.FormatTag := 1;
    WH.Channels := WI.FChan;
    WH.SampleRate := WI.FSR;
    WH.BitsPerSample := 16;
    WH.BlockAlign := 2 * WI.FChan;
    WH.BytesPerSecond := WI.FSR * WH.BlockAlign;
    Text := 'data';
    Move(Text[0], WH.DataChunkId[0], 4);
    WH.DataSize := WI.FSize;
    WI.FStream.Size := WI.FSize + 44;
    WI.FStream.Seek(0, soFromBeginning);
    WI.FStream.Write(WH, 44);
    WI.HasFirstFrame := True;
  end;
  if pcm^.channels = 2 then
  begin
    for i := 0 to pcm^.length - 1 do
    begin
      if pcm^.samples[0][i] >= MAD_F_ONE then
        pcm^.samples[0][i] := MAD_F_ONE - 1;
      if pcm^.samples[0][i] < -MAD_F_ONE then
        pcm^.samples[0][i] := -MAD_F_ONE;
      pcm^.samples[0][i] := pcm^.samples[0][i] shr (MAD_F_FRACBITS + 1 - 16);
      outsamples[i shl 1] := pcm^.samples[0][i];
      if pcm^.samples[1][i] >= MAD_F_ONE then
        pcm^.samples[1][i] := MAD_F_ONE - 1;
      if pcm^.samples[1][i] < -MAD_F_ONE then
        pcm^.samples[1][i] := -MAD_F_ONE;
      pcm^.samples[1][i] := pcm^.samples[1][i] shr (MAD_F_FRACBITS + 1 - 16);
      outsamples[(i shl 1) + 1] := pcm^.samples[1][i];
    end;
    WI.FStream.Write(outsamples[0], pcm^.length * 4);
  end
  else
  begin
    for i := 0 to pcm^.length - 1 do
    begin
      if pcm^.samples[0][i] >= MAD_F_ONE then
        pcm^.samples[0][i] := MAD_F_ONE - 1;
      if pcm^.samples[0][i] < -MAD_F_ONE then
        pcm^.samples[0][i] := -MAD_F_ONE;
      pcm^.samples[0][i] := pcm^.samples[0][i] shr (MAD_F_FRACBITS + 1 - 16);
      outsamples[i] := pcm^.samples[0][i];
    end;
    WI.FStream.Write(outsamples[0], pcm^.length * 2);
  end;
  Result := MAD_FLOW_CONTINUE;
end;

function ErrorFunc(CData: Pointer; Stream: p_mad_stream;
  Frame: p_mad_frame): integer; cdecl;
begin
  Result := MAD_FLOW_CONTINUE;
end;

{$ENDIF}

{ TWaveOut }

constructor TWaveOut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBufferSize := $4000; // default buffer size
  FWavType := wtPCM;
  FBlockAlign := 512;
  FNonMsHeaders := True;
  FInputSize := 0;
end;

destructor TWaveOut.Destroy();
begin
  inherited Destroy;
end;

procedure TWaveOut.SetWavType(WT: TWavType);
begin
  if Active then
    Exit;
  if (WT = wtPCM) or (WT = wtIMA_ADPCM) then
    FWavType := WT;
end;

procedure TWaveOut.SetFileMode(AMode: TAcsFileOutputMode);
begin
  FFileMode := aMode;
end;

procedure TWaveOut.Init();
var
  Header: TWaveHeader;
  HeaderExt: TWaveHeaderExt;
  IMA_ADPCMHeader: TIMA_ADPCMHeader;
begin
  inherited Init();
  EndOfInput := False;

  if (FInput.Channels > 2) or (FInput.BitsPerSample > 16) then
    if not FNonMsHeaders then
      FWavType := wtExtPCM;
  if (FFileMode = foAppend) and (FStream.Size <> 0) then
  begin
    ReadRIFFHeader();
    if not (FPrevWavType in [wtPCM, wtIMA_ADPCM]) then
    begin
      Done();
      raise EAcsException.Create('Cannot append data to this .wav file.');
    end;
    FWavType := FPrevWavType;
  end;

  case FWavType of
    wtPCM:
    begin
      if (FFileMode = foAppend) and (FStream.Size <> 0) then
      begin
        if (FPrevSR <> FInput.SampleRate) or (FPrevBPS <>
          FInput.BitsPerSample) or (FPrevCh <> FInput.Channels) then
        begin
          Done();
          raise EAcsException.Create('Cannot append data in different audio format.');
        end;
        FStream.Seek(0, soFromEnd);
      end
      else
      begin
        FillHeaderPCM(Header);
        if FStream.Write(Header, WaveHeaderOffs) <> WaveHeaderOffs then
          raise EAcsException.Create('Error writing wave file');
      end;
    end;

    wtExtPCM:
    begin
      FillHeaderExtPCM(HeaderExt);
      if FStream.Write(HeaderExt, SizeOf(HeaderExt)) <> SizeOf(HeaderExt) then
        raise EAcsException.Create('Error writing wave file');
    end;

    wtIMA_ADPCM:
    begin
      if FInput.BitsPerSample <> 16 then
      begin
        Done();
        raise EAcsException.Create('Cannot encode 8 bit sound into ADPCM.');
      end;
      //FBlockAlign:=512;
      if (FFileMode = foAppend) and (FStream.Size <> 0) then
      begin
        if (FPrevSR <> FInput.SampleRate) or (FPrevCh <> FInput.Channels) then
        begin
          Done();
          raise EAcsException.Create('Cannot append data in different audio format.');
        end;
        FStream.Seek(0, soFromEnd);
      end
      else
      begin
        FillHeaderIMA_ADPCM(IMA_ADPCMHeader);
        if FStream.Write(IMA_ADPCMHeader, SizeOf(IMA_ADPCMHeader)) <>
          SizeOf(IMA_ADPCMHeader) then
          raise EAcsException.Create('Error writing wave file');
        FEncodeState.Index_l := 0;
        FEncodeState.Index_r := 0;
      end;
    end;
  end;
end;

procedure TWaveOut.Done();
begin
  FinalizeStream();
  inherited Done();
end;

function TWaveOut.DoOutput(Abort: boolean): boolean;
var
  l, m: integer;
  Len: longword;
  DVIInBuf: PAcsBuffer16;
  DVIOutBuf: PAcsBuffer8;
  P: PAcsBuffer8;
  //Ptr: Pointer;
  BlockDataSize: integer;
begin
  // No exceptions Here
  Result := True;
  if not CanOutput then
    Exit;
  Len := 0;
  if Abort then
  begin
    (* We don't close file here to avoid exceptions
      if output component's Stop method is called *)
    Result := False;
    Exit;
  end;
  if EndOfInput then
  begin
    Result := False;
    Exit;
  end;
  case FWavType of
    wtPCM, wtExtPCM:
    begin
      try
        Len := FInput.GetData(FBuffer.Memory, FBuffer.Size);
        Inc(FInputSize, Len);
        if FStream.Write(FBuffer.Memory^, Len) <> integer(Len) then
          raise EAcsException.Create('Error writing wave file');
      except
      end;
      Result := (Len > 0);
    end;

    wtIMA_ADPCM:
    begin
      BlockDataSize := (FBlockAlign - 4 * FInput.Channels) * 4 + 2 * FInput.Channels;
      GetMem(DVIInBuf, BlockDataSize);
      GetMem(DVIOutBuf, FBlockAlign);
      P := PAcsBuffer8(DVIInBuf);
      try
        if FInput.Channels = 2 then
        begin
          l := 0;
          FillChar(DVIInBuf[0], BlockDataSize, 0);
          while l <> BlockDataSize do
          begin
            m := FInput.GetData(@P[l], BlockDataSize - l);
            Inc(FInputSize, m);
            if m = 0 then
            begin
              EndOfInput := True;
              Break;
            end;
            Inc(l, m);
          end;
          Len := FBlockAlign;
          FEncodeState.PredSamp_l := DVIInBuf[0];
          m := 1;
          FEncodeState.PredSamp_r := DVIInBuf[m];
          m := 2;
          EncodeDVIADPCMStereo(@DVIInBuf[m], @DVIOutBuf[0]);
          if FStream.Write(DVIOutBuf[0], FBlockAlign) <> FBlockAlign then
            raise EAcsException.Create('Error writing wave file');
        end
        else
        begin
          l := 0;
          FillChar(DVIInBuf[0], BlockDataSize, 0);
          while l <> BlockDataSize do
          begin
            m := FInput.GetData(@P[l], BlockDataSize - l);
            Inc(FInputSize, m);
            if m = 0 then
            begin
              EndOfInput := True;
              Break;
            end;
            Inc(l, m);
          end;
          Len := FBlockAlign;
          FEncodeState.PredSamp_l := DVIInBuf[0];
          m := 1;
          EncodeDVIADPCMMono(@DVIInBuf[m], @DVIOutBuf[0]);
          if FStream.Write(DVIOutBuf[0], FBlockAlign) <> FBlockAlign then
            raise EAcsException.Create('Error writing wave file');
        end;
      except
      end;
      FreeMem(DVIInBuf);
      FreeMem(DVIOutBuf);
      if Len > 0 then
        Result := True
      else
        Result := False;
    end;
  end;
end;

procedure TWaveOut.SetBlockSize(BS: word);
begin
  if (not Active) and (BS <> 0) and ((BS mod 4) = 0) then
    FBlockAlign := BS;
end;

procedure TWaveOut.FillHeaderPCM(var Header: TWaveHeader);
begin
  Header.RIFF := 'RIFF';
  Header.RIFFType := 'WAVE';
  Header.FmtChunkId := 'fmt ';
  Header.FmtChunkSize := 16;
  Header.FormatTag := WAVE_FORMAT_PCM;
  Header.Channels := FInput.Channels;
  Header.SampleRate := FInput.SampleRate;
  Header.BitsPerSample := FInput.BitsPerSample;
  Header.BlockAlign := (Header.BitsPerSample * Header.Channels) shr 3;
  Header.BytesPerSecond := Header.SampleRate * Header.BlockAlign;
  Header.DataChunkId := 'data';
  Header.DataSize := 0;
end;

procedure TWaveOut.FillHeaderExtPCM(var Header: TWaveHeaderExt);
begin
  Header.RIFF := 'RIFF';
  Header.FileSize := FInputSize + SizeOf(Header) - 8;
  Header.RIFFType := 'WAVE';
  Header.FmtChunkId := 'fmt ';
  Header.FmtChunkSize := SizeOf(Header.Format);
  Header.Format.Format.wFormatTag := WAVE_FORMAT_EXTENSIBLE;
  Header.Format.Format.nChannels := FInput.Channels;
  Header.Format.Format.nSamplesPerSec := FInput.SampleRate;
  Header.Format.Format.wBitsPerSample := FInput.BitsPerSample;
  Header.Format.Format.nBlockAlign :=
    (Header.Format.Format.wBitsPerSample * Header.Format.Format.nChannels) shr 3;
  Header.Format.Format.nAvgBytesPerSec := Header.Format.Format.nSamplesPerSec *
    Header.Format.Format.nBlockAlign;
  Header.Format.wValidBitsPerSample := Header.Format.Format.wBitsPerSample;
  if Header.Format.Format.nChannels = 1 then
    Header.Format.dwChannelMask := 1
  else
  if Header.Format.Format.nChannels = 2 then
    Header.Format.dwChannelMask := 3
  else
  if Header.Format.Format.nChannels = 6 then
    Header.Format.dwChannelMask := $3F
  else
  if Header.Format.Format.nChannels = 8 then
    Header.Format.dwChannelMask := $FF;
  Header.Format.SubFormat := KSDATAFORMAT_SUBTYPE_PCM;
  Header.Format.Format.cbSize := 22;
  Header.DataChunkId := 'data';
  Header.DataSize := FInputSize;
end;

procedure TWaveOut.FillHeaderIMA_ADPCM(var Header: TIMA_ADPCMHeader);
var
  //text: array[0..4] of Char;
  SamplesCount: LongInt;
begin
  Header.RIFF := 'RIFF';
  Header.RIFFType := 'WAVE';
  Header.FmtChunkId := 'fmt ';
  Header.FmtChunkSize := 20;
  Header.FormatTag := WAVE_FORMAT_DVI_IMA_ADPCM;
  Header.Channels := FInput.Channels;
  Header.SampleRate := FInput.SampleRate;
  Header.BitsPerSample := 4;
  Header.BlockAlign := FBlockAlign;
  Header.SamplesPerBlock := (Header.BlockAlign - 4 * FInput.Channels) *
    (2 div FInput.Channels) + 1;
  Header.cbSize := 2;
  Header.BytesPerSecond := (FInput.SampleRate div Header.SamplesPerBlock) *
    Header.BlockAlign;
  SamplesCount := (FInputSize div (FInput.BitsPerSample shr 3)) div FInput.Channels;
  Header.DataSize := Round(SamplesCount / Header.SamplesPerBlock) * Header.BlockAlign;
  Header.FileSize := Header.DataSize + SizeOf(TIMA_ADPCMHeader);
  Header.DataChunkId := 'data';
  Header.FactChunkId := 'fact';
  Header.FactChunkSize := 4;
  Header.DataLength := SamplesCount;
end;

procedure TWaveOut.EncodeDVIADPCMMono(InData: PAcsBuffer16; OutData: PAcsBuffer8);
var
  i, j, Diff, PredSamp, Index: Integer;
  Code: Byte;
  Header: TIMA_ADPCMBlockHeader;
begin
  FillChar(OutData[0], FBlockAlign, 0);
  Header.Samp0 := FEncodeState.PredSamp_l;
  Header.StepTableIndex := FEncodeState.Index_l;
  Move(Header, OutData[0], SizeOf(Header));
  PredSamp := FEncodeState.PredSamp_l;
  Index := FEncodeState.Index_l;
  for i := 0 to (FBlockAlign - 4) * 2 - 1 do
  begin
    Diff := InData[i] - PredSamp;
    if Diff < 0 then
    begin
      Code := 8;
      Diff := -Diff;
    end
    else
      Code := 0;
    if Diff >= StepTab[Index] then
    begin
      Code := Code or 4;
      Diff := Diff - StepTab[Index];
    end;
    if Diff >= (StepTab[Index] shr 1) then
    begin
      Code := Code or 2;
      Diff := Diff - (StepTab[Index] shr 1);
    end;
    if Diff >= (StepTab[Index] shr 2) then
      Code := Code or 1;
    j := (i shr 1) + 4;
    if (i and 1) = 0 then
      OutData[j] := Code
    else
      OutData[j] := OutData[j] or (Code shl 4);
    Diff := (StepTab[Index] shr 3);
    if (Code and 4) <> 0 then
      Diff := Diff + StepTab[Index];
    if (Code and 2) <> 0 then
      Diff := Diff + (StepTab[Index] shr 1);
    if (Code and 1) <> 0 then
      Diff := Diff + (StepTab[Index] shr 2);
    if (Code and 8) <> 0 then
      Diff := -Diff;
    PredSamp := PredSamp + Diff;
    if PredSamp > 32767 then
      PredSamp := 32767;
    if PredSamp < -32767 then
      PredSamp := -32767;
    Index := Index + IndexTab[Code];
    if Index > 88 then
      Index := 88;
    if Index < 0 then
      Index := 0;
  end;
  FEncodeState.Index_l := Index;
  //  State.PredSamp_l:=PredSamp;
end;

procedure TWaveOut.EncodeDVIADPCMStereo(InData: PAcsBuffer16; OutData: PAcsBuffer8);
var
  i, j, Diff, bPos, PredSamp, Index: Integer;
  Code: byte;
  Header: TIMA_ADPCMBlockHeader;
begin
  FillChar(OutData[0], FBlockAlign, 0);
  Header.Samp0 := FEncodeState.PredSamp_l;
  Header.StepTableIndex := FEncodeState.Index_l;
  Move(Header, OutData[0], SizeOf(Header));
  Header.Samp0 := FEncodeState.PredSamp_r;
  Header.StepTableIndex := FEncodeState.Index_r;
  i := 4;
  Move(Header, OutData[i], SizeOf(Header));
  PredSamp := FEncodeState.PredSamp_l;
  Index := FEncodeState.Index_l;
  for i := 0 to FBlockAlign - 9 do
  begin
    Diff := InData[i shl 1] - PredSamp;
    if Diff < 0 then
    begin
      Code := 8;
      Diff := -Diff;
    end
    else
      Code := 0;
    if Diff >= StepTab[Index] then
    begin
      Code := Code or 4;
      Diff := Diff - StepTab[Index];
    end;
    if Diff >= (StepTab[Index] shr 1) then
    begin
      Code := Code or 2;
      Diff := Diff - (StepTab[Index] shr 1);
    end;
    if Diff >= (StepTab[Index] shr 2) then
      Code := Code or 1;
    j := i shr 1;
    bPos := (j div 4) * 8 + (j mod 4) + 8;
    if (i and 1) = 0 then
      OutData[bPos] := Code
    else
      OutData[bPos] := OutData[bPos] or (Code shl 4);
    Diff := (StepTab[Index] shr 3);
    if (Code and 4) <> 0 then
      Diff := Diff + StepTab[Index];
    if (Code and 2) <> 0 then
      Diff := Diff + (StepTab[Index] shr 1);
    if (Code and 1) <> 0 then
      Diff := Diff + (StepTab[Index] shr 2);
    if (Code and 8) <> 0 then
      Diff := -Diff;
    PredSamp := PredSamp + Diff;
    if PredSamp > 32767 then
      PredSamp := 32767;
    if PredSamp < -32767 then
      PredSamp := -32767;
    Index := Index + IndexTab[Code];
    if Index > 88 then
      Index := 88;
    if Index < 0 then
      Index := 0;
  end;
  FEncodeState.Index_l := Index;
  FEncodeState.PredSamp_l := PredSamp;
  PredSamp := FEncodeState.PredSamp_r;
  Index := FEncodeState.Index_r;
  for i := 0 to FBlockAlign - 9 do
  begin
    Diff := InData[(i shl 1) + 1] - PredSamp;
    if Diff < 0 then
    begin
      Code := 8;
      Diff := -Diff;
    end
    else
      Code := 0;
    if Diff >= StepTab[Index] then
    begin
      Code := Code or 4;
      Diff := Diff - StepTab[Index];
    end;
    if Diff >= (StepTab[Index] shr 1) then
    begin
      Code := Code or 2;
      Diff := Diff - (StepTab[Index] shr 1);
    end;
    if Diff >= (StepTab[Index] shr 2) then
      Code := Code or 1;
    j := i shr 1;
    bPos := (j div 4) * 8 + (j mod 4) + 12;
    if i and 1 = 0 then
      OutData[bPos] := Code
    else
      OutData[bPos] := OutData[bPos] or (Code shl 4);
    Diff := (StepTab[Index] shr 3);
    if (Code and 4) <> 0 then
      Diff := Diff + StepTab[Index];
    if (Code and 2) <> 0 then
      Diff := Diff + (StepTab[Index] shr 1);
    if (Code and 1) <> 0 then
      Diff := Diff + (StepTab[Index] shr 2);
    if (Code and 8) <> 0 then
      Diff := -Diff;
    PredSamp := PredSamp + Diff;
    if PredSamp > 32767 then
      PredSamp := 32767;
    if PredSamp < -32767 then
      PredSamp := -32767;
    Index := Index + IndexTab[Code];
    if Index > 88 then
      Index := 88;
    if Index < 0 then
      Index := 0;
  end;
  FEncodeState.Index_r := Index;
  FEncodeState.PredSamp_r := PredSamp;
end;

procedure TWaveOut.ReadRIFFHeader();
var
  i: integer;
  WordVal: word;
  Buff: array[0..$fff] of AnsiChar;
  State: Byte;
  ChunkSize: LongInt;
begin
  FPrevWavType := wtUnsupported;
  State := LookingForRIFF;
  i := 4;
  FStream.Read(Buff[0], 4);
  while i < $2000 do
  begin
    case State of
      LookingForRIFF:
      begin
        if not Compare4(@Buff[i - 4], 'RIFF') then
        begin
          FStream.Read(Buff[i], 1);
          Inc(i);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          State := LookingForWAVE;
        end;
      end;
      LookingForWAVE:
      begin
        if not Compare4(@Buff[i - 4], 'WAVE') then
        begin
          FStream.Read(Buff[i], 1);
          Inc(i);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          State := LookingForFMT;
        end;
      end;
      LookingForFMT:
      begin
        if not Compare4(@Buff[i - 4], 'fmt ') then
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          Move(Buff[i - ChunkSize], WordVal, 2);
          case WordVal of
            WAVE_FORMAT_PCM: FPrevWavType := wtPCM;
            WAVE_FORMAT_IMA_ADPCM: FPrevWavType := wtIMA_ADPCM;
            else
              Exit;
          end;
          Move(Buff[i + 2 - ChunkSize], FPrevCh, 2);
          Move(Buff[i + 4 - ChunkSize], FPrevSR, 4);
          Move(Buff[i + 12 - ChunkSize], FBlockAlign, 2);
          Move(Buff[i + 14 - ChunkSize], FPrevBPS, 2);
          if FPrevWavType = wtIMA_ADPCM then
            State := LookingForFACT
          else
            State := LookingForDATA;
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end;
      end;
      LookingForFACT:
      begin
        if Buff[i - 4] = #0 then
        begin
          FStream.Read(Buff[i], 1);
          Inc(i);
        end;
        if not Compare4(@Buff[i - 4], 'fact') then
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FLenOffs := i;
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          Move(Buff[i - ChunkSize], FPrevLen, 4);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          State := LookingForDATA;
        end;
      end;
      LookingForDATA:
      begin
        if not Compare4(@Buff[i - 4], 'data') then
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          FDataSizeOffs := i - 4;
          Move(Buff[i - 4], FPrevDataSize, 4);
          HeaderSize := i;
          Exit;
        end;
      end;
    end;
    if FStream.Position >= FStream.Size then
      Break;
  end;
  FPrevWavType := wtUnsupported;
end;

procedure TWaveOut.FinalizeStream();
var
  Size: Integer;
  Hdr: TIMA_ADPCMHeader;
  BlockSize: Integer;
  P: Pointer;
begin
  if not Assigned(FStream) then
    Exit;
  if ((FInputSize = 0) or (FFileMode = foAppend)) then
  begin
    case FWavType of
      wtPCM:
      begin
        if FFileMode = foAppend then
        begin
          FStream.Seek(FDataSizeOffs, soFromBeginning);
          Size := FStream.Size - HeaderSize;
          FStream.Write(Size, 4);
        end
        else
        begin
          Size := FStream.Size - 44;
          FStream.Seek(DataSizeOffs, soFromBeginning);
          FStream.Write(Size, 4);
        end;
      end;

      wtExtPCM:
      begin
        Size := FStream.Size - SizeOf(TWaveHeaderExt);
        FStream.Seek(SizeOf(TWaveHeaderExt) - 4, soFromBeginning);
        FStream.Write(Size, 4);
      end;

      wtIMA_ADPCM:
      begin
        if FFileMode = foAppend then
        begin
          FStream.Seek(FDataSizeOffs, soFromBeginning);
          Size := FStream.Size - HeaderSize;
          FStream.Write(Size, 4);
          FStream.Seek(FLenOffs, soFromBeginning);
          Size := (Size div FBlockAlign) * ((FBlockAlign - FPrevCh * 4) * (2 div FPrevCh) + 1);
          FStream.Write(Size, 4);
        end
        else
        begin
          Size := FStream.Size - SizeOf(TIMA_ADPCMHeader);
          FStream.Seek(0, soFromBeginning);
          FStream.Read(Hdr, SizeOf(Hdr));
          Hdr.DataSize := Size;
          Hdr.DataLength := (Hdr.DataSize div Hdr.BlockAlign) * Hdr.SamplesPerBlock;
          FStream.Seek(0, soFromBeginning);
          if FStream.Write(Hdr, SizeOf(Hdr)) <> SizeOf(Hdr) then
            raise EAcsException.Create('Error writing wave file');
        end;
      end;
    end;
    Size := FStream.Size - 8;
    FStream.Seek(4, soFromBeginning);
    FStream.Write(Size, 4);
  end
  else  // if ((FInput.Size = 0) or (FFileMode = foAppend) or (FStopped = True)) then
  begin
    // fill rest of file with zeros
    BlockSize := 0;
    if FWavType = wtPCM then
    begin
      BlockSize := FInputSize + 44 - FStream.Position;
    end;
    if FWavType = wtExtPCM then
    begin
      BlockSize := FInputSize + SizeOf(TWaveHeaderExt) - FStream.Position;
    end;
    if BlockSize > 0 then
    begin
      GetMem(P, BlockSize);
      FillChar(P^, BlockSize, 0);
      if FStream.Write(P^, BlockSize) <> BlockSize then
        raise EAcsException.Create('Error writing wave file');
      FreeMem(P);
    end;
  end;
end;

{ TWaveIn }

constructor TWaveIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBufferSize := $8000;
  _WavType := wtUnsupported;
end;

destructor TWaveIn.Destroy();
begin
  inherited Destroy();
end;

procedure TWaveIn.OpenFile();
var
{$IFDEF MSWINDOWS}
  WaveConverter: TWaveConverter;
  ValidItems: longword;
  Res: MMResult;
{$ENDIF}
{$IFDEF LINUX}
  _decoder: mad_decoder;
{$ENDIF}
begin
  OpenCS.Enter();
  try
    inherited OpenFile();
    if FOpened then
    begin
      FValid := False;
      ShortIEEEFloat := False;
      _WavType := wtUnsupported;
      ReadRIFFHeader();
      FValid := True;
      case Self._WavType of
        wtUnsupported:
        begin
          FValid := False;
        end;

        wtIMA_ADPCM:
        begin
          if FBPS <> 4 then
            FValid := False;
          FBPS := 16;
          FSize := longword(IMA_ADPCM_INFO.DataSize) * 2 * FChan;
          //if not Assigned(TmpBuffer) then GetMem(TmpBuffer, IMA_ADPCM_INFO.BlockLength);
          SetLength(TmpBuffer, IMA_ADPCM_INFO.BlockLength);
        end;

        wtMS_ADPCM:
        begin
          FValid := True;
          FBPS := 16;
          FSize := MS_ADPCM_INFO.DataSize * 2 * FChan;
          //if not Assigned(TmpBuffer) then GetMem(TmpBuffer, MS_ADPCM_INFO.BlockLength);
          SetLength(TmpBuffer, MS_ADPCM_INFO.BlockLength);
        end;

        wtIEEEFloat, wtExtIEEEFloat:
        begin
          if FBPS = 32 then
            ShortIEEEFloat := True
          else
            FSize := FSize div 2;
          FBPS := 32;
          FValid := True;
        end;

        wtACM:
        begin

  {$IFDEF MSWINDOWS}

          (* Checking if the file is ACM encoded and if it is, decoding it.
             Thanks to Jan Henrik Ejme, <jan.h.ejme@xhlp.com> for the
             provided converter units. *)
          WaveConverter := TWaveConverter.Create();
          try
            FStream.Position := 0;
            WaveConverter.LoadStream(FStream);
            with WaveConverter.NewFormat.Format do
            begin
              wFormatTag := WAVE_FORMAT_PCM;
              ValidItems := ACM_FORMATSUGGESTF_WFORMATTAG;
              Res := acmFormatSuggest(nil,
                WaveConverter.CurrentFormat.format,
                WaveConverter.NewFormat.Format,
                SizeOf(TACMWaveFormat),
                ValidItems);
            end;
            if (Res = 0) and (WaveConverter.Convert() = 0) then
            begin
              _MS := TMemoryStream.Create();
              OldStream := FStream;
              OldStreamAssigned := FStreamAssigned;
              FStream := _MS;
              _MS.Position := 0;
              WaveConverter.SaveWavToStream(_MS);
              FSize := _MS.Size;
              _MS.Seek(0, soFromBeginning);
              ReadRIFFHeader();
              //WaveConverter.CurrentFormat.Format.wFormatTag;
              _wavType := wtACM;
              FValid := True;
            end;
          finally
            FreeAndNil(WaveConverter);
          end;
  {$ENDIF}
  {$IFDEF LINUX}
          if not MADLibLoaded then
            raise EACSException.Create(
              'Cannot play ACM file. The madlib library could not be loaded.');
          DataLen := FStream.Size;
          GetMem(Data, DataLen);
          FStream.Read(Data^, DataLen);
          _MS := TMemoryStream.Create;
          OldStream := FStream;
          OldStreamAssigned := FStreamAssigned;
          FStream := _MS;
          HasFirstFrame := False;
          InputDone := False;
          mad_decoder_init(@_decoder, Self, InputFunc, nil, nil,
            OutputFunc, ErrorFunc, nil);
          mad_decoder_run(@_decoder, MAD_DECODER_MODE_SYNC);
          mad_decoder_finish(@_decoder);
          FreeMem(Data);
          FStream.Seek(0, soFromBeginning);
          ReadRIFFHeader;
          _wavType := wtACM;
  {$ENDIF}
        end;
      end;
    end;
    FSampleSize := FChan * (FBPS div 8);
    FTotalTime := FSize / (FSR * FSampleSize);
  finally
    OpenCS.Leave();
  end;
end;

procedure TWaveIn.CloseFile();
begin
  OpenCS.Enter();
  try
    if FOpened then
    begin
      if _WavType = wtACM then
      begin
        if Assigned(_MS) then
        begin
          if Assigned(OldStream) then
          begin
            FStream := OldStream;
            OldStream := nil;
          end;
          FreeAndNil(_MS);
        end;
      end
      else if (_WavType in [wtMS_ADPCM, wtIMA_ADPCM]) then
      begin
        //if Assigned(TmpBuffer) then FreeMem(TmpBuffer);
        //TmpBuffer:=nil;
        SetLength(TmpBuffer, 0);
      end;
    end;
    inherited CloseFile();
  finally
    OpenCS.Leave();
  end;
end;

function TWaveIn.GetData(ABuffer: Pointer; ABufferSize: integer): integer;
var
  Len, AlignedSize: integer;
begin
  if (not Active) or (not FOpened) then
    raise EAcsException.Create('The Stream is not opened');

  AlignedSize := FAudioBuffer.Size - (FAudioBuffer.Size mod FSampleSize);
  if FAudioBuffer.UnreadSize <= 0 then
  begin
    FAudioBuffer.Reset();
    case _WavType of
      wtIMA_ADPCM:
      begin
        Len := ReadDecodeIMAADPCMBlock(FAudioBuffer.Memory, FAudioBuffer.Size);
        FAudioBuffer.WritePosition := FAudioBuffer.WritePosition + Len;
      end;

      wtMS_ADPCM:
      begin
        Len := ReadDecodeMSADPCMBlock(FAudioBuffer.Memory, FAudioBuffer.Size);
        FAudioBuffer.WritePosition := FAudioBuffer.WritePosition + Len;
      end;

      wtPCM, wtExtPCM:
      begin
        Len := AlignedSize;
        if Len > (FStream.Size - FStream.Position) then
          Len := (FStream.Size - FStream.Position);
        if Len > (FAudioBuffer.Size - FAudioBuffer.WritePosition) then
          Len := (FAudioBuffer.Size - FAudioBuffer.WritePosition);
        if Len > 0 then
          Len := FAudioBuffer.CopyFrom(FStream, Len);
      end;

      wtExtIEEEFloat, wtIEEEFloat:
      begin
        Len := FAudioBuffer.CopyFrom(FStream, AlignedSize);
        if ShortIEEEFloat then
        begin
          ConvertShortIEEEFloatTo32(FAudioBuffer.Memory, Len);
          FAudioBuffer.WritePosition := FAudioBuffer.WritePosition + Len;
        end
        else
        begin
          ConvertIEEEFloatTo32(FAudioBuffer.Memory, Len);
          FAudioBuffer.WritePosition := FAudioBuffer.WritePosition + (Len div 2);
        end;
      end;

      wtACM:
      begin
        Len := AlignedSize;
        if Len > (FStream.Size - FStream.Position) then
          Len := (FStream.Size - FStream.Position);
        if Len > (FAudioBuffer.Size - FAudioBuffer.WritePosition) then
          Len := (FAudioBuffer.Size - FAudioBuffer.WritePosition);
        if Len > 0 then
          Len := FAudioBuffer.CopyFrom(FStream, AlignedSize);
      end;
    end;
  end;

  Result := ABufferSize;
  if Result > FAudioBuffer.UnreadSize then
    Result := FAudioBuffer.UnreadSize;
  //SendDebug('Wave.Pos='+IntToStr(FPosition)+'  Result='+IntToStr(Result));
  FAudioBuffer.Read(ABuffer^, Result);
  Inc(FPosition, Result);
end;

function TWaveIn.Seek(SampleNum: integer): boolean;
var
  OffsSize: int64;
begin
  Result := False;
  if not Active then
    Exit;
  if not Assigned(Stream) then
    Exit;
  FAudioBuffer.Reset();
  case _WavType of
    wtPCM:
    begin
      OffsSize := SampleNum * (Self.FBPS div 8) * FChan;
      Stream.Seek(OffsSize + HeaderSize, soFromBeginning);
      Result := True;
    end;

    wtIMA_ADPCM:
    begin
      OffsSize := (SampleNum div IMA_ADPCM_INFO.SamplesPerBlock) *
        IMA_ADPCM_INFO.BlockLength;
      Stream.Seek(OffsSize + HeaderSize, soFromBeginning);
      Result := True;
    end;

    wtMS_ADPCM:
    begin
      OffsSize := (SampleNum div MS_ADPCM_INFO.SamplesPerBlock) * MS_ADPCM_INFO.BlockLength;
      Stream.Seek(OffsSize + HeaderSize, soFromBeginning);
      Result := True;
    end;

  end;
end;

function TWaveIn.GetWavType(): TWavType;
begin
  OpenFile();
  Result := _WavType;
  CloseFile();
end;

function TWaveIn.ReadDecodeIMAADPCMBlock(AOutBuf: Pointer;
  AOutBufSize: integer): integer;
var
  BlockHeaderSize, Len: integer;
  BH: TIMA_ADPCMBlockHeader;
  i, OutPos, InPos, ch: integer;
  Diff, SampleValue, Step, StepIndex: integer;
  Nibble: byte;
  //InData: PAcsBuffer8;
  OutData: PAcsBuffer16;
begin
  Result := 0;
  if AOutBufSize < (IMA_ADPCM_INFO.SamplesPerBlock * FSampleSize) then
    Exit;
  // === Read ===
  if Seekable and (FStream.Position >= (FStream.Size - IMA_ADPCM_INFO.BlockLength)) then
    Exit;
  if FStream.Read(TmpBuffer[0], IMA_ADPCM_INFO.BlockLength) <
    IMA_ADPCM_INFO.BlockLength then
    Exit;
  BlockHeaderSize := 0;
  for ch := 0 to FChan - 1 do
  begin
    Move(TmpBuffer[BlockHeaderSize], BH, SizeOf(BH));
    IMA_ADPCM_STATE.valprev[ch] := BH.Samp0;
    IMA_ADPCM_STATE.index[ch] := BH.StepTableIndex;
    BlockHeaderSize := BlockHeaderSize + SizeOf(BH);
  end;

  // === Decode ===
  //InData:=TmpBuffer + BlockHeaderSize;
  OutData := AOutBuf;
  OutPos := 0;
  // get first sample from header
  for ch := 0 to FChan - 1 do
  begin
    {$R-}
    OutData[OutPos] := IMA_ADPCM_STATE.valprev[ch];
    {$R+}
    Inc(OutPos);
  end;
  // decode samples
  { The remaining bytes in the chunk are the IMA nibbles.
  Each byte is decoded bottom nibble first, then top nibble as follows:
  byte0 byte1 byte2 byte3 ...
  n1n0  n3n2  n5n4  n7n6  ...

  In stereo, the first 4 bytes, or 8 nibbles, belong to the left channel and the
  next 4 bytes belong to the right channel. This interleaving continues until
  the end of the chunk  }

  // nibbles (half-bytes) count
  //Len:=(IMA_ADPCM_INFO.BlockLength - BlockHeaderSize) * (2 div FChan);
  Len := (IMA_ADPCM_INFO.SamplesPerBlock - 1) * (2 div FChan);
  for ch := 0 to FChan - 1 do
  begin
    InPos := BlockHeaderSize + (ch * 4);
    OutPos := FChan + ch;
    SampleValue := IMA_ADPCM_STATE.valprev[ch];
    StepIndex := IMA_ADPCM_STATE.index[ch];
    for i := 0 to (Len - 1) do
    begin
      if (i and 1) > 0 then
      begin
        Nibble := TmpBuffer[InPos] shr 4;    // high half-byte
        Inc(InPos);
        // for stereo, skip every 4 bytes
        if (FChan = 2) and ((InPos mod 4) = 0) then
          Inc(InPos, 4);
      end
      else
        Nibble := TmpBuffer[InPos] and 15;  // low half-byte

      Step := StepTab[StepIndex];
      Diff := (Step shr 3);
      if (Nibble and 1) <> 0 then
        Diff := Diff + (Step shr 2);
      if (Nibble and 2) <> 0 then
        Diff := Diff + (Step shr 1);
      if (Nibble and 4) <> 0 then
        Diff := Diff + Step;
      if (Nibble and 8) <> 0 then
        Diff := -Diff;
      SampleValue := SampleValue + Diff;
      if SampleValue > 32767 then
        SampleValue := 32767;
      if SampleValue < -32767 then
        SampleValue := -32767;
      StepIndex := StepIndex + IndexTab[Nibble];
      if StepIndex > 88 then
        StepIndex := 88;
      if StepIndex < 0 then
        StepIndex := 0;

      {$R-}
      OutData[OutPos] := SampleValue;
      {$R+}
      Inc(OutPos, 2);
      //IMA_ADPCM_STATE.index[ch]:=StepIndex;
      //IMA_ADPCM_STATE.valprev[ch]:=SampleValue;
    end;
  end;
  Result := IMA_ADPCM_INFO.SamplesPerBlock * FSampleSize;
end;

function TWaveIn.ReadDecodeMSADPCMBlock(AOutBuf: Pointer;
  AOutBufSize: integer): integer;
var
  BlockHeaderSize, Len: integer;
  BHM: TMSADPCMBlockHeaderMono;
  BHS: TMSADPCMBlockHeaderStereo;
  pos, i, PredSamp, Nibble, ch, chIndex: integer;
  //InData: PAcsBuffer8;
  OutData: PAcsBuffer16;
begin
  Result := 0;
  //InData:=@TmpBuffer[0];
  if AOutBufSize < (MS_ADPCM_INFO.SamplesPerBlock * FSampleSize) then
    Exit;
  // === Read ===
  if Seekable and (FStream.Position >= (FStream.Size - MS_ADPCM_INFO.BlockLength)) then
    Exit;
  if FStream.Read(TmpBuffer[0], MS_ADPCM_INFO.BlockLength) <
    MS_ADPCM_INFO.BlockLength then
    Exit;
  if FChan = 1 then
  begin
    BlockHeaderSize := SizeOf(BHM);
    Move(TmpBuffer[0], BHM, BlockHeaderSize);
    MS_ADPCM_STATE.predictor[0] := BHM.predictor;
    MS_ADPCM_STATE.Delta[0] := BHM.Delta;
    MS_ADPCM_STATE.Samp1[0] := BHM.Samp1;
    MS_ADPCM_STATE.Samp2[0] := BHM.Samp2;
  end
  else
  begin
    BlockHeaderSize := SizeOf(BHS);
    //Move(TmpBuffer^, BHS, BlockHeaderSize);
    Move(TmpBuffer[0], MS_ADPCM_STATE, BlockHeaderSize);
    //MS_ADPCM_STATE:=BHS;
  end;

  // === Decode ===
  OutData := AOutBuf;
  pos := 0;
  for ch := 0 to FChan - 1 do
  begin
    {$R-}
    OutData[pos] := MS_ADPCM_STATE.Samp2[ch];
    {$R+}
    Inc(pos);
  end;
  for ch := 0 to FChan - 1 do
  begin
    {$R-}
    OutData[pos] := MS_ADPCM_STATE.Samp1[ch];
    {$R+}
    Inc(pos);
  end;

  Len := MS_ADPCM_INFO.SamplesPerBlock - 2;
  for i := 0 to Len - 1 do
  begin
    for chIndex := 0 to 1 do
    begin
      ch := chIndex;
      if FChan = 1 then
        ch := 0;

      PredSamp := (MS_ADPCM_STATE.Samp1[ch] *
        MS_ADPCM_INFO.CoefSets[MS_ADPCM_STATE.predictor[ch]].Coef1 +
        MS_ADPCM_STATE.Samp2[ch] *
        MS_ADPCM_INFO.CoefSets[MS_ADPCM_STATE.predictor[ch]].Coef2) div 256;
      if chIndex = 0 then
        Nibble := TmpBuffer[BlockHeaderSize + i] shr 4    // high half-byte
      else if chIndex = 1 then
        Nibble := TmpBuffer[BlockHeaderSize + i] and 15;  // low half-byte
      if (Nibble and 8) <> 0 then
        PredSamp := PredSamp + MS_ADPCM_STATE.Delta[ch] * (Nibble - 16)
      else
        PredSamp := PredSamp + MS_ADPCM_STATE.Delta[ch] * (Nibble);
      if PredSamp > 32767 then
        PredSamp := 32767;
      if PredSamp < -32768 then
        PredSamp := -32768;
      {$R-}
      OutData[pos] := PredSamp;
      {$R+}
      Inc(pos);
      MS_ADPCM_STATE.Delta[ch] := (MS_ADPCM_STATE.Delta[ch] * adaptive[Nibble]) div 256;
      if MS_ADPCM_STATE.Delta[ch] < 16 then
        MS_ADPCM_STATE.Delta[ch] := 16;
      MS_ADPCM_STATE.Samp2[ch] := MS_ADPCM_STATE.Samp1[ch];
      MS_ADPCM_STATE.Samp1[ch] := PredSamp;
    end;
  end;
  Result := pos * FChan;
  {$R+}
end;


procedure TWaveIn.ReadRIFFHeader();
const
  __BufSize = $FFFF;
var
  i: integer;
  WordVal: word;
  IntVal: integer;
  Buff: array[0..__BufSize] of AnsiChar;
  State: integer;
  ChunkSize: integer;
  SubType: TGuid;
begin
  FSize := 0;
  FBPS := 0;
  FChan := 0;
  FSR := 0;
  _WavType := wtUnsupported;
  State := LookingForRIFF;
  i := 4;
  FStream.Read(Buff[0], 4);
  while i < __BufSize do
  begin
    case State of
      LookingForRIFF:
      begin
        if not Compare4(@Buff[i - 4], 'RIFF') then
        begin
          FStream.Read(Buff[i], 1);
          Inc(i);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          State := LookingForWAVE;
        end;
      end;

      LookingForWAVE:
      begin
        if not Compare4(@Buff[i - 4], 'WAVE') then
        begin
          FStream.Read(Buff[i], 1);
          Inc(i);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          State := LookingForFMT;
        end;
      end;

      LookingForFMT:
      begin
        if not Compare4(@Buff[i - 4], 'fmt ') then
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end
        else
        begin
          Stream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          Move(Buff[i - ChunkSize], WordVal, 2);
          case WordVal of
            WAVE_FORMAT_PCM: _WavType := wtPCM;
            WAVE_FORMAT_IMA_ADPCM: _WavType := wtIMA_ADPCM;
            WAVE_FORMAT_ADPCM: _WavType := wtMS_ADPCM;
            WAVE_FORMAT_MP3: _WavType := wtACM;
            WAVE_FORMAT_IEEE_FLOAT: _WavType := wtIEEEFloat;
            WAVE_FORMAT_EXTENSIBLE: _WavType := wtExtPCM;
            else
              Exit;
          end;
          Move(Buff[i + 2 - ChunkSize], WordVal, 2);
          FChan := WordVal;
          Move(Buff[i + 4 - ChunkSize], IntVal, 4);
          FSR := IntVal;
          Move(Buff[i + 12 - ChunkSize], WordVal, 2);
          if _WavType = wtIMA_ADPCM then
            IMA_ADPCM_INFO.BlockLength := WordVal
          else
            MS_ADPCM_INFO.BlockLength := WordVal;
          Move(Buff[i + 14 - ChunkSize], WordVal, 2);
          FBPS := WordVal;
          if _WavType = wtExtPCM then
          begin
            Move(Buff[i - 16], SubType, 16);
            if IsEqualGUID(SubType, KSDATAFORMAT_SUBTYPE_IEEE_FLOAT) then
            begin
              _WavType := wtExtIEEEFLOAT;
            end
            else
            if not IsEqualGUID(SubType, KSDATAFORMAT_SUBTYPE_PCM) then
              _WavType := wtUnsupported;
          end;
          if _WavType in [wtIMA_ADPCM, wtMS_ADPCM, wtACM] then
          begin
            Move(Buff[i + 18 - ChunkSize], WordVal, 2);
            if _WavType = wtIMA_ADPCM then
              IMA_ADPCM_INFO.SamplesPerBlock := WordVal
            else
              MS_ADPCM_INFO.SamplesPerBlock := WordVal;
            if _WavType = wtMS_ADPCM then
            begin
              Move(Buff[i + 20 - ChunkSize], WordVal, 2);
              MS_ADPCM_INFO.NumCoeff := WordVal;
              Move(Buff[i + 22 - ChunkSize], MS_ADPCM_INFO.CoefSets[0],
                MS_ADPCM_INFO.NumCoeff * SizeOf(TMS_ADPCM_COEF_SET));
            end;
            State := LookingForFACT;
          end
          else
            State := LookingForDATA;
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end;
      end;

      LookingForFACT:
      begin
        if not Compare4(@Buff[i - 4], 'fact') then
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          Move(Buff[i - ChunkSize], IntVal, 4);
          if _WavType = wtIMA_ADPCM then
            IMA_ADPCM_INFO.DataSize := IntVal
          else
            MS_ADPCM_INFO.DataSize := IntVal;
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          State := LookingForDATA;
        end;
      end;

      LookingForDATA:
      begin
        if Buff[i - 4] = #0 then
        begin
          FStream.Read(Buff[i], 1);
          Inc(i);
        end;
        if not Compare4(@Buff[i - 4], 'data') then
        begin
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
          Move(Buff[i - 4], ChunkSize, 4);
          FStream.Read(Buff[i], ChunkSize);
          Inc(i, ChunkSize);
          FStream.Read(Buff[i], 4);
          Inc(i, 4);
        end
        else
        begin
          FStream.Read(Buff[i], 4);
          if _WavType in [wtPCM, wtExtPCM, wtIEEEFloat, wtExtIEEEFloat] then
            Move(Buff[i], FSize, 4);
          Inc(i, 4);
          HeaderSize := i;
          Exit;
        end;
      end;
    end;
    if Seekable then
      if FStream.Position >= FStream.Size then
        Break;
  end;
  _WavType := wtUnsupported;
end;


initialization

  FileFormats.Add('wav', 'Waveform Audio', TWaveOut);
  FileFormats.Add('wav', 'Waveform Audio', TWaveIn);

end.
