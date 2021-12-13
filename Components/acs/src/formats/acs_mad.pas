(*
  this file is a part of audio components suite v 2.3.
  copyright (c) 2002-2005 andrei borovsky. all rights reserved.
  see the license file for more details.
  you can contact me at mail@z0m3ie.de
*)

{
$Log: acs_mad.pas,v $
Revision 1.1  2005/12/19 18:36:38  z0m3ie
*** empty log message ***

Revision 1.2  2005/12/04 16:54:34  z0m3ie
All classes are renamed, Style TAcs... than T... to avoid conflicts with other components (eg TMixer is TAcsMixer now)

Revision 1.1  2005/09/12 22:04:52  z0m3ie
modified structure again, fileformats are now in an sperat folder.
all File In/Out classes are capsulated from TFileIn and TFileOut

Revision 1.3  2005/08/25 20:18:00  z0m3ie
Version 2.4 restructure
TCDPlayer removed (fits not in component structure)
TMP3ToWavConverter removed (fits not in component structure)

Revision 1.2  2005/08/22 20:17:01  z0m3ie
changed Headers to log
changed mail adress

}

unit acs_mad;

interface

uses

  ACS_Types, Classes, SysUtils, Math, MAD;

type

  TRawPCMWaveHeader = record
    RIFF: array [0..3] of Char;
    FileSize: Integer;
    RIFFType: array [0..3] of Char;
    FmtChunkId: array [0..3] of Char;
    FmtChunkSize: Integer;
    FormatTag: Word;
    Channels: Word;
    SampleRate: Integer;
    BytesPerSecond: Integer;
    BlockAlign: Word;
    BitsPerSample: Word;
    DataChunkId: array [0..3] of Char;
    DataSize: Integer;
  end;

  TMADProgressEvent = procedure(Sender : TComponent) of object;
  TMADDoneEvent = procedure(Sender : TComponent; Success : Boolean) of object;

  TMADThread = class(TThread)
  private
    _Free : Boolean;
    Progr : Integer;
    Owner : TComponent;
    FDecoder :  mad_decoder;
    FInputStream : TStream;
    FOutputStream : TStream;
    HasFirstFrame : Boolean;
    FSR : Integer;
    FChan : Integer;
    FBitrate : Integer;
    FValid : Boolean;
    Data : PACSBuffer8;
    InputDone : Boolean;
    WaveHdr : TRawPCMWaveHeader;
    FSize : Integer;
    FMADProgress : TMADProgressEvent;
    FMADDone : TMADDoneEvent;
    WhenDone : procedure of object;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner : TComponent; InputStream, OutputStream : TStream);
    destructor Destroy; override;
  end;

implementation

   function InputFunc(CData : Pointer; Stream : p_mad_stream) : Integer; cdecl;
   var
     MT : TMADThread;
     Len : Integer;
   begin

     MT := TMADThread(CData);

     if MT.InputDone then
     begin
       Result := MAD_FLOW_STOP;
       Exit;
     end;
     MT.InputDone := True;
//     Len := MT.FInputStream.Read(Data^, MT.FInputStream.Size);
     Len := MT.FInputStream.Size;
     mad_stream_buffer(Stream, MT.Data, Len);
     if not MT.Terminated then Result := MAD_FLOW_CONTINUE
     else Result := MAD_FLOW_STOP;
   end;

   function OutputFunc(CData : Pointer; Header : p_mad_header; pcm : p_mad_pcm) : Integer; cdecl;
   var
     MT : TMADThread;
     i, framesize : Integer;
     outsamples : array[0..2303] of SmallInt;
     text : array[0..4] of Char;
     CProgr : Integer;
   begin
     MT := TMADThread(CData);
     if not MT.HasFirstFrame then
     begin
       MT.FSR := pcm.samplerate;
       MT.FChan := pcm.channels;
       MT.FBitrate := Header.bitrate;
       framesize := Ceil(144*MT.FBitrate/MT.FSR);
       MT.FSize := Round(MT.FInputStream.Size/framesize*1152)*MT.FChan*2;
       MT.FValid := True;
       text := 'RIFF';
       Move(text[0], MT.WaveHdr.RIFF[0], 4);
       MT.WaveHdr.FileSize := MT.FSize + 44;
       text := 'WAVE';
       Move(text[0], MT.WaveHdr.RIFFType[0], 4);
       text := 'fmt ';
       Move(text[0], MT.WaveHdr.FmtChunkId[0], 4);
       MT.WaveHdr.FmtChunkSize := 16;
       MT.WaveHdr.FormatTag := 1;
       MT.WaveHdr.Channels := MT.FChan;
       MT.WaveHdr.SampleRate := MT.FSR;
       MT.WaveHdr.BitsPerSample := 16;
       MT.WaveHdr.BlockAlign := 2*MT.FChan;
       MT.WaveHdr.BytesPerSecond := MT.FSR * MT.WaveHdr.BlockAlign;
       text := 'data';
       Move(text[0], MT.WaveHdr.DataChunkId[0], 4);
       MT.WaveHdr.DataSize := MT.FSize;
       if MT.FOutputStream is TMemoryStream then
       begin
         MT.FOutputStream.Size :=MT.FSize + 44;
         MT.FOutputStream.Seek(0, soFromBeginning);
       end;
       MT.FOutputStream.Write(MT.WaveHdr, 44);
       MT.HasFirstFrame := True;
     end;
     if pcm.channels = 2 then
     begin
       for i := 0 to pcm.length -1 do
       begin
         if pcm.samples[0][i] >= MAD_F_ONE then
         pcm.samples[0][i] := MAD_F_ONE - 1;
         if pcm.samples[0][i] < -MAD_F_ONE then
         pcm.samples[0][i] := -MAD_F_ONE;
         pcm.samples[0][i] := pcm.samples[0][i] shr (MAD_F_FRACBITS + 1 - 16);
         outsamples[i shl 1] := pcm.samples[0][i];
         if pcm.samples[1][i] >= MAD_F_ONE then
         pcm.samples[1][i] := MAD_F_ONE - 1;
         if pcm.samples[1][i] < -MAD_F_ONE then
         pcm.samples[1][i] := -MAD_F_ONE;
         pcm.samples[1][i] := pcm.samples[1][i] shr (MAD_F_FRACBITS + 1 - 16);
         outsamples[(i shl 1)+1] := pcm.samples[1][i];
       end;
       MT.FOutputStream.Write(outsamples[0], pcm.length*4);
     end else
     begin
       for i := 0 to pcm.length -1 do
       begin
         if pcm.samples[0][i] >= MAD_F_ONE then
         pcm.samples[0][i] := MAD_F_ONE - 1;
         if pcm.samples[0][i] < -MAD_F_ONE then
         pcm.samples[0][i] := -MAD_F_ONE;
         pcm.samples[0][i] := pcm.samples[0][i] shr (MAD_F_FRACBITS + 1 - 16);
         outsamples[i] := pcm.samples[0][i];
       end;
       MT.FOutputStream.Write(outsamples[0], pcm.length*2);
     end;
     if MT.FSize <> 0 then
     begin
       CProgr := Round(MT.FOutputStream.Position/MT.FSize*100);
       if MT.Progr <> CProgr then
       begin
         MT.Progr := CProgr;
         if Assigned(MT.FMADProgress) then
         MT.FMADProgress(MT.Owner);
       end;
     end;
     if not MT.Terminated then Result := MAD_FLOW_CONTINUE
     else Result := MAD_FLOW_STOP;
   end;

   function ErrorFunc(CData : Pointer; Stream : p_mad_stream; Frame : p_mad_frame) : Integer; cdecl;
   begin
     Result := MAD_FLOW_CONTINUE;
   end;

   constructor TMADThread.Create;
   begin
     inherited Create(True);
     Owner := AOwner;
     FInputStream := InputStream;
     FOutputStream := OutputStream;
     FreeOnTerminate := False;
   end;

   destructor TMADThread.Destroy;
   begin
     if not _Free then
     begin
       Terminate;
       {$IFDEF WIN32}
       while not _Free do;
       {$ENDIF}
     end;
     inherited Destroy;
   end;

   procedure TMADThread.Execute;
   begin
     try
       GetMem(Data, FInputStream.Size);
       FInputStream.Read(Data[0], FInputStream.Size);
       mad_decoder_init(@FDecoder, Self, InputFunc, nil, nil, OutputFunc, ErrorFunc, nil);
       mad_decoder_run(@FDecoder, MAD_DECODER_MODE_SYNC);
       mad_decoder_finish(@FDecoder);
       FreeMem(Data);
       WhenDone;
       if Assigned(FMADDone) then FMADDone(Owner, FValid);
       _Free := True;
     except
       FreeMem(Data);
       WhenDone;
       _Free := True;
     end;
   end;

end.
