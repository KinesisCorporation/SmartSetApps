(*
Base ACS classes

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

{
@abstract(this unit introduces the base classes for acs)
@author(Andrei Borovsky (2003-2005))
@author(Christian Ulrich (2005))
@author(Sergey Bodrov (2014-2015))
}

unit acs_classes;

interface

uses

acs_strings, Classes, SysUtils, syncobjs;

const

  STREAM_BUFFER_SIZE = $80000;

type

  TAcsOutputStatus = (tosUndefined, tosPlaying, tosPaused, tosIdle);
  TAcsFileOutputMode = (foRewrite = 0, foAppend);
  TAcsOutputFunc = function(Abort: Boolean): Boolean of object;

  //TThreadDoneEvent = procedure of object;

  TAcsThreadExceptionEvent = procedure(Sender: TComponent; E: Exception) of object;
  TAcsHandleThreadException = procedure(E: Exception) of object;
  TAcsOutputDoneEvent = procedure(Sender: TComponent) of object;
  TAcsOutputProgressEvent = procedure(Sender: TComponent) of object;
  
{$IFDEF LINUX}
// File access mask constants
const
  famUserRead = 64;
  famUserWrite = 128;
  famGroupRead = 8;
  famGroupWrite = 16;
  famOthersRead = 1;
  famOthersWrite = 2;
{$ENDIF}

type
  {Basic exception class for ACS}
  EAcsException = class(Exception)
  end;


  { TAcsOutThread }
  { Basic Thread class for ACS }
  TAcsOutThread = class(TThread)
  private
    FHandleException: TAcsHandleThreadException;
    procedure CallOnProgress();
    procedure CallOnDone();
  public
    Parent: TComponent;
    //Stop: Boolean;
    Delay: Integer;
    //CS: TRTLCriticalSection;
    constructor Create();
    destructor Destroy(); override;
    procedure DoPause();
    procedure DoResume();
    procedure Execute(); override;
    property HandleException: TAcsHandleThreadException read FHandleException write FHandleException;
  end;

  TAcsVerySmallThread = class(TThread)
  public
    FOnDone: TAcsOutputDoneEvent;
    Sender: TComponent;
    procedure Execute(); override;
    procedure CallOnDone();
  end;


  TAcsBufferMode = (bmBlock, bmReport);
  { TAcsPrefetchMode - prefetch mode for buffer
    pmAuto - autodetect
    pmNone - no prefetching, buffer can be fully depleted
    pmFetch3_4 - fetch data when 3/4 of buffer is depleted
    pmFetch1_2 - fetch data when 1/2 of buffer is depleted
    pmFetch1_4 - fetch data when 1/4 of buffer is depleted
    pmFetch1_8 - fetch data when 1/8 of buffer is depleted
  }
  TAcsPrefetchMode = (pmAuto, pmNone, pmFetch3_4, pmFetch1_2, pmFetch1_4, pmFetch1_8);

  // Circular buffer with TStream interface
  TAcsCircularBuffer = class(TStream)
  private
    Buff: array[0..STREAM_BUFFER_SIZE-1] of Byte;
    ReadCur: Integer;
    WriteCur: Integer;
    FBufferMode: TAcsBufferMode;
    //FBreak: Boolean;
    FBytesInBuffer: Integer;
    BlockEventName: string;
    //LockEventName: string;
    FBytesRead: Integer;
    CS: TCriticalSection;
    BlockEvent: TEvent;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Reset();
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    property BytesInBuffer: Integer read FBytesInBuffer;
    property BufferMode: TAcsBufferMode read FBufferMode write FBufferMode;
  end;

  { TAcsAudioBuffer }
  { Audio sample buffer - store raw audio data.
    It remembers positions for Read() and Write() separately }
  TAcsAudioBuffer = class(TMemoryStream)
  protected
    FLock: TMultiReadExclusiveWriteSynchronizer;
    { Read() position }
    FReadPos: Int64;
    { Write() position }
    FWritePos: Int64;
    { Size of unread data. Increased when data written and decreased when data readed }
    FUnreadSize: Int64;
    FReadExtract: Boolean;
    function GetSamplesCount(): Integer; virtual;
    procedure SetSamplesCount(AValue: Integer); virtual;
    function GetByte(Index: Integer): Byte; virtual;
    procedure SetByte(Index: Integer; AValue: Byte); virtual;
    function GetSamplePtr(Index: Integer): Pointer; virtual;
    procedure SetWritePos(AValue: Int64);
    procedure SetReadPos(AValue: Int64);
  public
    { 1-mono, 2-stereo, etc.. }
    ChannelsCount: Integer;
    { Bits per sample channel - 4, 8, 16, 20, 24, 32 }
    BitDepth: Integer;
    { Samples per second - 8000, 11025, 22050, 44100, 48000, 96000, 192000 (Hz)}
    SampleRate: Integer;
    { Time, when buffer content start play (milliseconds) }
    Timestamp: Int64;
    { channels allocatin in frame
      True - channels data interleaved - 1,2, 1,2, 1,2, ...
      False - data separated by channels - 1,1,1,..,  2,2,2,.. }
    Interleaved: Boolean;
    { Sound source position in 3D space }
    //Position3D: TPoint3D;
    { Sound source velocity, for Doppler effect }
    //Velocity: Integer;
    constructor Create();
    destructor Destroy(); override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    { Size of sound sample in bytes }
    function BytesPerSample(): Integer;
    { Reset WritePosition and ReadPosition to 0 }
    procedure Reset();
    { Get available size for writing, between WritePosition/ReadPosition  and buffer end.
      Result will be not greater, than specified ASize }
    function GetBufWriteSize(ASize: Integer): Integer;
    { Size of buffer in sound samples }
    property SamplesCount: Integer read GetSamplesCount write SetSamplesCount;
    { Access to bytes. Inline code from GetByte or SetByte for optimization. }
    property Bytes[Index: Integer]: Byte read GetByte write SetByte;
    { Access to samples. Inline code from GetSamplePtr for optimization. }
    property Samples[Index: Integer]: Pointer read GetSamplePtr;
    { If True, then readed data extracted from buffer }
    property ReadExtract: Boolean read FReadExtract write FReadExtract;
    { Position of last and next Read() operation, increased after reading }
    property ReadPosition: Int64 read FReadPos write SetReadPos;
    { Position of last and next Write() operation, increased after writing }
    property WritePosition: Int64 read FWritePos write SetWritePos;
    { Size of unread data. Increased when data written and decreased when data readed }
    property UnreadSize: Int64 read FUnreadSize;
  end;

  { TAcsCircularAudioBuffer }

  TAcsCircularAudioBuffer = class(TAcsAudioBuffer)
  protected
    function GetByte(Index: Integer): Byte; override;
    procedure SetByte(Index: Integer; AValue: Byte); override;
    function GetSamplePtr(Index: Integer): Pointer; override;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    { If Origin = soCurrent, then changed ReadPosition, otherwise changed WritePosition }
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    procedure SetSize({$ifdef CPU64}const {$endif CPU64}NewSize: PtrInt); override;
  end;


  { TAcsCustomInput }
  { TAcsInput is the base class for all input and converter components. }
  TAcsCustomInput = class(TComponent)
  protected
    FPosition: Integer;
    FActive: Boolean;
    BufStart: Integer;
    BufEnd: Integer;
    FBuffer: array of Byte;
    FBufferSize: Integer;
    FAudioBuffer: TAcsAudioBuffer;
    function GetBPS(): Integer; virtual;
    function GetCh(): Integer; virtual;
    function GetSR(): Integer; virtual;
    function GetPosition(): Integer; virtual;
    function GetPositionTime(): Real; virtual;
    procedure SetBufferSize(AValue: Integer); virtual;
    function GetBufferSize(): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    { This is an abstract method.
      In TAcsInput descendands this function reads the audio stream data into the Buffer.
      Returns the number of bytes actually read.
      Returns zero at the end of stream.
      
      Note: usually this method is called internally by the output or converter component
      to which the input component is assigned. You can call this method if you want to
      get direct access to the audio stream. In such a case the sequence of calls should
      look like this:
      
      InputComponent.Init();
      
      InputComponent.GetData(...); // in a loop
      
      InputComponent.Done();
    }
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; virtual; overload;
    function GetData(AStream: TStream): Integer; virtual; overload;
    { This function is called from output component when the buffer must be filled. }
    procedure Reset(); virtual;
    { In TAcsInput descendands it prepares input component for reading data. }
    procedure Init(); virtual;
    { In TAcsInput descendands it closes the current input, clearing up all temporary structures alocated during data transfer.
      
      Note: usually this method is called internally by the output or converter component to
      which the input component is assigned. You can call this method if you want to get direct
      access to the audio stream. }
    procedure Done(); virtual;
    { Read this property to determine the number of bits per sample in the input audio stream.
      Possible values are 8 and 16. }
    property BitsPerSample: Integer read GetBPS;
    { Read this property to get the sample rate (sampling frequency) in Hz
      for the input audio stream. }
    property SampleRate: Integer read GetSR;
    { Read Channles to determine the number of channels in the input audio stream.
      Possible values are 1 (mono) and 2 (stereo). }
    property Channels: Integer read GetCh;
    { Current playing position in bytes }
    property Position: Integer read GetPosition;
    { Current playing position in seconds }
    property PositionTime: Real read GetPositionTime;
    { This property sets the buffersize of the component }
    property BufferSize: Integer read GetBufferSize write SetBufferSize;
    property Active: Boolean read FActive;
  end;


  { TAcsCustomOutput }
  { TAcsCustomOutput is the base class for all ACS output components. }
  TAcsCustomOutput = class(TComponent)
  protected
    FActive: Boolean;  // Set to true by Run and to False by WhenDone.
    CanOutput: Boolean;
    //CurProgr: Real;
    Thread: TAcsOutThread;
    { delay in milliseconds between data fetch from input }
    FFetchDelay: Integer;
    FInput: TAcsCustomInput;
    FOnDone: TAcsOutputDoneEvent;
    FOnProgress: TAcsOutputProgressEvent;
    FOnThreadException: TAcsThreadExceptionEvent;
    InputLock: Boolean;
    // single sample size
    FSampleSize: Integer;
    FBufferSize: Integer;
    FBuffer: TAcsAudioBuffer;
    FPrefetchMode: TAcsPrefetchMode;
    { Unread buffer size for triggering fetching from input. Calculated in Init() }
    FPrefetchSize: Integer;

    { Read data from Input into Buffer, return bytes read
      AEndOfInput set to True if end of input buffer is reached }
    function FillBufferFromInput(var AEndOfInput: Boolean): Integer; virtual; overload;
    function FillBufferFromInput(): Integer; virtual; overload;
    function GetPriority(): TThreadPriority; virtual;
    procedure SetPriority(Priority: TThreadPriority); virtual;
    procedure SetInput(AInput: TAcsCustomInput); virtual;
    { Called from Thread when thread stopped }
    procedure WhenDone(); virtual;
    function GetActive(): Boolean; virtual;
    { Time elapsed }
    function GetTE(): Real; virtual;
    function GetStatus(): TAcsOutputStatus; virtual;
    function GetDelay(): Integer; virtual;
    procedure SetDelay(Value: Integer); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure HandleThreadException(E: Exception); virtual;
    function GetBufferSize(): Integer; virtual;
    procedure SetBufferSize(AValue: Integer); virtual;
  public
    LastErrorDescription: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    { Set default buffer size and calls FInput.Init() }
    procedure Init(); virtual;
    { Called from Thread }
    function DoOutput(Abort: Boolean): Boolean; virtual; abstract;
    { Calls FInput.Done() and reset buffer to zero }
    procedure Done(); virtual;

    { This is the most important method in the output components.
      After an input component has been assigned, call Run to start audio-processing chain. }
    procedure Run(); virtual;
    { Stops the running output process. }
    procedure Stop(); virtual;
    { pauses the output (the output thread is suspended). }
    procedure Pause(); virtual;
    { Resumes previously paused output. }
    procedure Resume(); virtual;

    { Set to true by Run and to False by WhenDone. }
    property Active: Boolean read GetActive;
    { Use this property to set the delay (in milliseconds) in output thread.
      This property allows the user to reduce the stress the output thread puts
      on the CPU (especially under Windows).
      Be careful with this property when using TAudioOut component.
      Assigning too large values to it can cause dropouts in audio playback. }
    property Delay: Integer read GetDelay write SetDelay;
    { Output components perform output in their own threads.
      Use this property to set the priority for the thread. }
    property ThreadPriority: TThreadPriority read GetPriority write SetPriority;
    { This property indicates the output component's current status. Possible values are:
      tosPlaying: the component is working;
      tosPaused: the component is paused (the Pause method was called);
      tosIdle: the component is idle; }
    property Status: TAcsOutputStatus read GetStatus;
    { Time from start of playing, seconds }
    property TimeElapsed: Real read GetTE;
  published
    { Data source component for this component.
      The valid input components must be descendants of TAcsInput. }
    property Input: TAcsCustomInput read FInput write SetInput;
    { This event is invoked when the output is finished.

      Note: don't try to start other output job before OnDone event from the
      previous job is triggered. An attempt to do so will cause the
      "Component is busy" exception.
      It is a good practice to desable output-starting controls in the
      method where the output component's Run method is called and to enable
      them in the output component's OnDone event handler. }
    property OnDone: TAcsOutputDoneEvent read FOnDone write FOndone;
    { This event is invoked every time the Progress property value changes.
      Be careful when referencing GUI interface components in OnProgress event's handler. }
    property OnProgress: TAcsOutputProgressEvent read FOnProgress write FOnProgress;
    { Thread procedure should never terminate.
      For this reason all the exceptions that might arise in the thread
      procedure are caught within the procedure itself.
      The thread generates OnThreadException event to inform the application
      that an exception has occurred.
      Avoid any potential exception-rising actions in this event’s handler!
      Use the handler to reset application controls (if needed) and call the
      input component’s Reset method.
      See the CD ripper demo for an example of handling thread exceptions. }
    property OnThreadException: TAcsThreadExceptionEvent read FOnThreadException write FOnThreadException;
    { This Property sets the BufferSize of the component }
    property BufferSize: Integer read GetBufferSize write SetBufferSize;
    { Fetch data from input, when output buffer partially depleted, preventing output
      buffer underrun while playing. Large values (3/4, 1/2) suitable for encoded
      file or stream input. Small values (1/4, 1/8) suitable for RAW files or
      streams. "None" value suitable when whole playable data fit into buffer. }
    property PrefetchMode: TAcsPrefetchMode read FPrefetchMode write FPrefetchMode;
  end;

  { TAcsStreamedInput introduces Stream property.
    This property allows input components that descend from TAcsStreamedInput
    to get data not only from files on disc but from any kind of stream.
    The descendats of this class are TAcsFileIn (and all its descendats except TMACIn),
    and TStreamIn component that is designed to read raw audio data from streams. }
  TAcsStreamedInput = class(TAcsCustomInput)
  protected
    FStream: TStream;
    FStreamAssigned: Boolean;
    FSeekable: Boolean;
    procedure SetStream(AStream: TStream);
  public
    { If you write network applications with ACS, you are encouraged to use custom
      streams as it is described in programmer's introduction
      (see also OggStream demo).

      Usually these custom streams will not be seekable.
      Unfortunately TStream class has no way to indicate it is not seekable
      (all standart TStream descendats are seekable).
      So this property has been added to allow you to specify if the stream is seekable or not.
      The default value of this property is True, and if the stream you're planning
      to use with this component is not seekable, you have to set Seekable to False.
      Note that if the stream is not seekable, such properties as Channels, SampleRate,
      BitsPerSample, and Valid will not return correct values until the input
      component starts performing the actual playback.  }
    property Seekable: Boolean read FSeekable write FSeekable;
    { Use this property to set the input stream for the input component.
      Remember that you have to create, destroy and position the input stream explicitly.
      In TAcsFileIn descendants the stream assigned to this property takes over
      the FileName property, i. e. if both Stream and FileName property are assigned,
      the stream and not the file will be used for the actual input.
      To unassign this property set it to nil.
      If the stream is seekable it will be reset to the beginning at the end of the playback. }
    property Stream: TStream read FStream write SetStream;
    constructor Create(AOwner: TComponent); override;
  end;

  { TAcsStreamedOutput introduces Stream property.
    This property allows output components that descend from TAcsStreamedOutput
    to store data not only to files on disc but to any kind of stream as well. }
  TAcsStreamedOutput = class(TAcsCustomOutput)
  protected
    { Use this property to set the output stream for the corresponding output component.
      Remember that you have to create, destroy and position the input stream explicitly.
      In file-handling TAcsStreamedOutput descendants the stream assigned to this property
      takes over the FileName property, i. e. if both Stream and FileName property are assigned,
      the stream and not the file will be used for the actual output.
      To unassign this property set it to nil. }
    FStream: TStream;
    procedure SetStream(AStream: TStream);
  public
    property Stream: TStream read FStream write SetStream;
  end;
  
  { This class introduces an simple handler for an file tag it can hold any streamable
    piece of data or an string }
  TAcsFileTag = class
  private
    function GetName: string; virtual;
  public
    property Name: string read GetName;
    function AsString: string; virtual;
    function Streamable: Boolean; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
  end;
  

  { TAcsFileInfo }
  { This class introduces an base class for file tag lists }
  TAcsFileInfo = class
  private
    procedure ReadFromFile(); virtual;
    procedure SetStringTag(Idx: string; const AValue: TAcsFileTag);
    function GetStringTag(Idx: string): TAcsFileTag;
  public
    procedure SaveToFile(); virtual;
    property Tags[Idx: string]: TAcsFileTag read GetStringTag write SetStringTag;
  end;
  

  { TAcsCustomFileIn - base class for all input components that read data from files
    (or from other streams in the corresponding file format).
    It introduces such properties as FileName, StartSample, EndSample, Loop,
    and Valid and Jump, Seek, SetStartTime, SetEndTime methods. }
  TAcsCustomFileIn = class(TAcsStreamedInput)
  protected
    { Set to True if internal FStream not used }
    FStreamDisabled: Boolean;
    FFileName: TFileName;
    FOffset: Real;
    FOpened: Boolean;
    FValid: Boolean;
    FBPS: Integer;
    FSR: Integer;
    FChan: Integer;
    FSampleSize: Integer;  // Sample size in bytes
    FLoop: Boolean;
    FStartSample: Integer;
    FEndSample: Integer;
    FTotalSamples: Integer;
    FTotalTime: Real;
    FSize: Integer;
    OpenCS: TCriticalSection;
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
    function GetValid(): Boolean; virtual;
    procedure SetFileName(const AValue: TFileName); virtual;
    { Create FStream if FStreamDisabled not True
      Note on FSize calculation:
      FSize is calculated in OpenFile method as the FULL file size.
      More precise calculations regarding StartSample/EndSample are done in Init. }
    procedure OpenFile(); virtual;
    procedure CloseFile(); virtual;
    function GetTotalTime(): Real; virtual;
    function GetPositionTime(): Real; override;
    function GetSize(): Integer; virtual;
    function GetProgress(): Real; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Init(); override;
    procedure Done(); override;
    procedure Reset(); override;
    { Read Size to determine the size of the input stream in bytes. }
    property Size: Integer read GetSize;
    { Set current playing sample index from beginning of file }
    function Seek(SampleNum: Integer): Boolean; virtual; abstract;
    function SetStartTime(Minutes, Seconds: Integer): Boolean;
    function SetEndTime(Minutes, Seconds: Integer): Boolean;
    { Change playing position by specified offset, in seconds }
    procedure Jump(Offs: Real); virtual;
    { Read this property to get the total time of the input stream in seconds.
      If the total time cannot be determined this property contains 0. }
    property TotalTime: Real read GetTotalTime;
    { Use this property to read the total number of samples in the file/stream assigned
      to the component. The sample in this context means the minimum playable
      portion of audio data. For mono 8-bit sound 1 sample = 1 byte,
      while for stereo 16-bit sound 1 sample = 4 bytes. }
    property TotalSamples: Integer read FTotalSamples;
    { Read this property to determine if the file is valid.
      It is a good practice to check this property before performing other
      operations on audio stream. }
    property Valid: Boolean read GetValid;
    { Read Progress to get the input progress in percents. }
    property Progress: Real read GetProgress;
  published
    { Use this property to set the number of the sample in the file that the
      playback should start from. The value of 0 (default) tells the component
      to play the file from the beginning.
      The sample in this context means the minimum playable portion of audio data.
      For mono 8-bit sound 1 sample = 1 byte, while for stereo 16-bit sound 1 sample = 4 bytes.
      You can get the total number of samples in the file by reading TotalSamples property.

      Note that in some cases (for example, with ADPCM files) sample positioning is not quite precise. }
    property StartSample: Integer read FStartSample write FStartSample;
    { Use this property to set the number of the end sample in the file that
      the playback should stop at.
      The value of -1 (default) tells the component to play the file up to the end.
      The sample in this context means the minimum playable portion of audio data.
      For mono 8-bit sound 1 sample = 1 byte,
      while for stereo 16-bit sound 1 sample = 4 bytes.
      You can get the total number of samples in the file by reading TotalSamples property.

      Note that in some cases (for example, with ADPCM files) sample positioning is not quite precise. }
    property EndSample: Integer read FEndSample write FEndSample;
    { Use this property to set the name of the file to read data from. }
    property FileName: TFileName read FFileName write SetFileName stored True;
    { The default value of Loop is False. If this property is set to True,
    the file playback will be looped, in other words the file will start playing
    again right after it is finished. Note, that if Loop is set to True, it will not
    present end conditions to the corresponding output component.
    You can stop the looped input component either by setting Loop to False,
    or by calling Stop method of the corresponding output component. }
    property Loop: Boolean read FLoop write FLoop;
  end;

  { TAcsCustomFileOut - base class for all file/stream formatted output components.
    It introduces such properties as AccessMask (for Linux), FileName, and FileMode properties. }
  TAcsCustomFileOut = class(TAcsStreamedOutput)
  protected
    { Set to True if internal FStream not used }
    FStreamDisabled: Boolean;
    FFileName: TFileName;
    FFileMode: TAcsFileOutputMode;
    FAccessMask: Integer;
    procedure SetFileMode(AMode: TAcsFileOutputMode); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    { Use this property to set the file access mask. The default value is $1B6,
    which corresponds to rw-rw-rw- access mask. }
    property AccessMask: Integer read FAccessMask write FAccessMask;
    { Check and open file stream }
    procedure Init(); override;
    { Close file stream }
    procedure Done(); override;
  published
    { There are two possible values for this property: foRewrite and foAppend.
      When foRewrite (default value) is set and the file with the specified
      name already exists (or a stream is assigned) the contents of the file
      (stream) is rewritten.

      In the foAppend mode the new data is appended to the end of the existing
      file (stream).
      Currently only TWaveOut and TVorbisOut components support foAppend mode. }
    property FileMode: TAcsFileOutputMode read FFileMode write SetFileMode;
    { Use this property to set the name of the file to save data to. }
    property FileName: TFileName read FFileName write FFileName;
  end;

  { TAcsCustomConverter }
  { TAcsCustomConverter is the base class for all ACS converter classes.
  Converters are intermediate sections in the audio processing chain.
  Being the descendants of TAcsCustomInput they can be linked to the output
  components, while their Input property allows to link them with input
  components and other converters.

  TAcsCustomConverter introduces new published property - Input - the very
  property that distinguishes a converter from an input component. }
  TAcsCustomConverter = class(TAcsCustomInput)
  protected
    InputLock: Boolean;
    FInput: TAcsCustomInput;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetInput(AInput: TAcsCustomInput); virtual;
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
  public
    procedure UnlockInput();
    { Check Input and call Input.Init(), set Active to True }
    procedure Init(); override;
    { Call Input.Done() and set Active to False }
    procedure Done(); override;
  published
    property Input: TAcsCustomInput read FInput write SetInput;
  end;


implementation

function Min(n1, n2: Int64): Int64;
begin
  Result:=n1;
  if Result > n2 then Result:=n2;
end;

{ TAcsCircularAudioBuffer }

function TAcsCircularAudioBuffer.GetByte(Index: Integer): Byte;
var
  NewIndex: Integer;
begin
  NewIndex:=FReadPos+Index;
  while NewIndex >= Size do NewIndex:=NewIndex-Size;
  Result:=inherited GetByte(NewIndex);
end;

procedure TAcsCircularAudioBuffer.SetByte(Index: Integer; AValue: Byte);
var
  NewIndex: Integer;
begin
  NewIndex:=FReadPos+Index;
  while NewIndex >= Size do NewIndex:=NewIndex-Size;
  inherited SetByte(NewIndex, AValue);
end;

function TAcsCircularAudioBuffer.GetSamplePtr(Index: Integer): Pointer;
var
  NewIndex: Integer;
begin
  NewIndex:=FReadPos+Index;
  while NewIndex >= Size do NewIndex:=NewIndex-Size;
  Result:=inherited GetSamplePtr(NewIndex);
end;

function TAcsCircularAudioBuffer.Read(var Buffer; Count: Longint): Longint;
var
  SizeToEnd, SizeFromBegin: Longint;
begin
  SizeToEnd:=(Size-FReadPos);
  if Count < SizeToEnd then
  begin
    Position:=FReadPos;
    Result:=inherited Read(Buffer, Count);
    if FReadExtract then
    begin
      Inc(FReadPos, Result);
      Dec(FUnreadSize, Result);
    end;
  end
  else
  begin
    // fill buffer direct from memory, no inherited Read() called
    Result:=Count;
    if Result > Size then Result:=Size;
    FLock.Beginread();
    // read from pos to end of buffer
    Move((Self.Memory+FReadPos)^, Buffer, SizeToEnd);
    // read from begin to remain size of buffer
    SizeFromBegin:=Result-SizeToEnd;
    Move(Self.Memory, (@Buffer+SizeToEnd)^, SizeFromBegin);
    FLock.Endread();
    if FReadExtract then
    begin
      FReadPos:=SizeFromBegin;
      Dec(FUnreadSize, Result);
    end;
  end;
end;

function TAcsCircularAudioBuffer.Write(const Buffer; Count: Longint): Longint;
var
  SizeToEnd, SizeFromBegin: Longint;
begin
  SizeToEnd:=(Size-FWritePos);
  if Count < SizeToEnd then
  begin
    Position:=FWritePos;
    Result:=inherited Write(Buffer, Count);
    Inc(FWritePos, Result);
    Inc(FUnreadSize, Result);
  end
  else
  begin
    // write from buffer direct to memory, no inherited Write() called
    Result:=Count;
    if Result > Size then Result:=Size;
    FLock.Beginwrite();
    // write from pos to end of local buffer
    Move(Buffer, (Self.Memory+FWritePos)^, SizeToEnd);
    // write from begin to remain size of local buffer
    SizeFromBegin:=Result-SizeToEnd;
    Move((@Buffer+SizeToEnd)^, Self.Memory^, SizeFromBegin);
    FLock.Endwrite();
    FWritePos:=SizeFromBegin;
    Inc(FUnreadSize, Result);
  end;
end;

function TAcsCircularAudioBuffer.Seek(const Offset: Int64; Origin: TSeekOrigin
  ): Int64;
begin
  if Origin = soCurrent then Position:=FReadPos else Position:=FWritePos;
  Result:=inherited Seek(Offset, Origin);
  if Origin = soCurrent then
    FReadPos:=FReadPos+Offset
  else
    FWritePos:=Offset;
end;

procedure TAcsCircularAudioBuffer.SetSize({$ifdef CPU64}const {$endif CPU64}NewSize: PtrInt);
begin
  inherited SetSize(NewSize);
  if NewSize < FReadPos then FReadPos:=NewSize;
  if NewSize < FWritePos then FWritePos:=NewSize;
end;

{ TAcsAudioBuffer }

constructor TAcsAudioBuffer.Create();
begin
  inherited Create;
  FLock:=TMultiReadExclusiveWriteSynchronizer.Create();
  FReadExtract:=False;
  Interleaved:=True;
  Reset();
end;

destructor TAcsAudioBuffer.Destroy();
begin
  FreeAndNil(FLock);
  inherited Destroy;
end;

function TAcsAudioBuffer.GetSamplesCount(): Integer;
begin
  Result:=(Self.Size div BytesPerSample());
end;

procedure TAcsAudioBuffer.SetSamplesCount(AValue: Integer);
begin
  if AValue >= 0 then
  begin
    if FLock.BeginWrite() then
    begin
      Self.Size:=AValue * BytesPerSample();
      FLock.EndWrite();
    end;
  end;
end;

function TAcsAudioBuffer.GetByte(Index: Integer): Byte;
begin
  if (Index >= 0) and (Index < Size) then
    Result:=PByte(Self.Memory)[Index]
  else
    Result:=0;
end;

procedure TAcsAudioBuffer.SetByte(Index: Integer; AValue: Byte);
begin
  if (Index >= 0) and (Index < Size) then
    PByte(Self.Memory)[Index]:=AValue;
end;

function TAcsAudioBuffer.GetSamplePtr(Index: Integer): Pointer;
begin
  if (Index >= 0) and (Index < Size) then
    Result:=Self.Memory + (Index * BytesPerSample())
  else
    Result:=nil;
end;

procedure TAcsAudioBuffer.SetWritePos(AValue: Int64);
var
  Delta: Int64;
begin
  Delta:=AValue-FWritePos;
  FWritePos:=AValue;
  FUnreadSize:=FUnreadSize+Delta;
end;

procedure TAcsAudioBuffer.SetReadPos(AValue: Int64);
var
  Delta: Int64;
begin
  Delta:=AValue-FReadPos;
  FReadPos:=AValue;
  FUnreadSize:=FUnreadSize-Delta;
end;

function TAcsAudioBuffer.Read(var Buffer; Count: Longint): Longint;
var
  s: AnsiString;
begin
  FLock.BeginRead();
  Position:=FReadPos;
  if Count > (Size-Position) then Count:=(Size-Position);
  Result:=inherited Read(Buffer, Count);
  Inc(FReadPos, Result);
  if ReadExtract then
  begin
    // remove readed data from buffer
    if (Size-Position) > 0 then
    begin
      // copy rest of buffer to string
      SetLength(s, Size-Position);
      Move((Self.Memory+Position)^, Pointer(s)^, Length(s));
      // copy string to FReadPos
      Move(Pointer(s)^, (Self.Memory+FReadPos)^, Length(s));
      Dec(FWritePos, Result);
    end;
  end;
  Dec(FUnreadSize, Result);
  FLock.EndRead();
end;

function TAcsAudioBuffer.Write(const Buffer; Count: Longint): Longint;
begin
  if FLock.BeginWrite() then
  begin
    Position:=FWritePos;
    Result:=inherited Write(Buffer, Count);
    Inc(FWritePos, Result);
    Inc(FUnreadSize, Result);
    FLock.EndWrite();
  end
  else Result:=0;
end;

function TAcsAudioBuffer.BytesPerSample(): Integer;
begin
  Result:=SampleRate * (BitDepth div 8) * ChannelsCount;
end;

procedure TAcsAudioBuffer.Reset();
begin
  FWritePos:=0;
  FReadPos:=0;
  FUnreadSize:=0;
end;

function TAcsAudioBuffer.GetBufWriteSize(ASize: Integer): Integer;
begin
  Result:=ASize;
  if Result > (Self.Size-Self.WritePosition) then Result:=(Self.Size-Self.WritePosition);
  if Result > (Self.Size-Self.ReadPosition) then Result:=(Self.Size-Self.ReadPosition);
  //Result:=Min(Result, Self.UnreadSize);
end;

{ TAcsVerySmallThread }

procedure TAcsVerySmallThread.CallOnDone();
begin
 if Assigned(FOnDone) then FOnDone(Sender);
end;

procedure TAcsVerySmallThread.Execute();
begin
 Synchronize(CallOnDone);
end;

{ TAcsOutThread }

constructor TAcsOutThread.Create();
begin
 inherited Create(True);
 //InitCriticalSection(CS);
end;

destructor TAcsOutThread.Destroy();
begin
  //DoneCriticalSection(CS);
  inherited Destroy();
end;

procedure TAcsOutThread.CallOnProgress();
begin
  if Assigned((Parent as TAcsCustomOutput).OnProgress) then
    (Parent as TAcsCustomOutput).OnProgress(Parent);
end;

procedure TAcsOutThread.CallOnDone();
begin
  if Assigned((Parent as TAcsCustomOutput).FOnDone) then
    (Parent as TAcsCustomOutput).FOnDone(Parent);
end;

procedure TAcsOutThread.DoPause();
begin
  Suspended:=True;
end;

procedure TAcsOutThread.DoResume();
begin
  Suspended:=False;
end;

procedure TAcsOutThread.Execute();
var
  //DoneThread: TAcsVerySmallThread;
  ParentComponent: TAcsCustomOutput;
  Res: Boolean;
begin
  ParentComponent:=(Parent as TAcsCustomOutput);
  // init
  try
    ParentComponent.Init();
  except
    on E: Exception do
    begin
      if Assigned(Self.HandleException) then Self.HandleException(E);
      Terminate();
    end;
  end;

  // main loop
  //EnterCriticalSection(CS);
  while not Terminated do
  begin
    if Delay > 0 then Sleep(Delay);
    try
      Res:=ParentComponent.DoOutput(False);
      if (not Res) then Terminate()
      else
        if Assigned(ParentComponent.OnProgress) then
          Synchronize(CallOnProgress);
    except
      on E: Exception do
      begin
        if Assigned(Self.HandleException) then Self.HandleException(E);
        Terminate();
      end;
    end;
  end;
  //LeaveCriticalSection(CS);

  // done
  try
    ParentComponent.WhenDone();
  except
    on E: Exception do
    begin
      if Assigned(Self.HandleException) then Self.HandleException(E);
      Terminate();
    end;
  end;

  Synchronize(CallOnDone);

  // This ensures that OnDone event is called outside this thread
  { // !!! for what?
  DoneThread:=TAcsVerySmallThread.Create(True);
  DoneThread.Sender:=ParentComponent;
  DoneThread.FOnDone:=ParentComponent.FOnDone;
  DoneThread.FreeOnTerminate:=True;
  DoneThread.Suspended:=False;
  }
end;

{ TAcsCustomInput }

constructor TAcsCustomInput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive:=False;
  FPosition:=0;
end;

destructor TAcsCustomInput.Destroy();
begin
  if Assigned(FAudioBuffer) then FreeAndNil(FAudioBuffer);
  inherited Destroy;
end;

function TAcsCustomInput.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
begin
  Result:=Length(FBuffer);
  if Result > ABufferSize then Result:=ABufferSize;
  Move(ABuffer, FBuffer, Result);
end;

function TAcsCustomInput.GetData(AStream: TStream): Integer;
begin
  Result:=Length(FBuffer);
  if Result > (AStream.Size - AStream.Position) then Result:=(AStream.Size - AStream.Position);
  AStream.Read(FBuffer, Result);
end;

function TAcsCustomInput.GetBPS(): Integer;
begin
  Result:=-1;
end;

function TAcsCustomInput.GetCh(): Integer;
begin
  Result:=-1;
end;

function TAcsCustomInput.GetSR(): Integer;
begin
  Result:=-1;
end;

function TAcsCustomInput.GetPosition(): Integer;
begin
  Result:=FPosition;
end;

function TAcsCustomInput.GetPositionTime(): Real;
begin
  Result:=0;
  if (SampleRate > 0) and (BitsPerSample > 0) and (Channels > 0) then
    Result:=Position / SampleRate / (BitsPerSample div 8) / Channels;
end;

procedure TAcsCustomInput.SetBufferSize(AValue: Integer);
begin
  //if Active then
  //  raise EAcsException.Create(strBusy);
  if AValue >= 0 then SetLength(FBuffer, AValue);
end;

function TAcsCustomInput.GetBufferSize: Integer;
begin
  Result:=Length(FBuffer);
end;

procedure TAcsCustomInput.Reset();
begin
  try
    Done();
  except
  end;
  FActive:=False;
end;

procedure TAcsCustomInput.Init();
begin
  if Active then
    raise EACSException.Create(strBusy);
  FActive:=True;
  FPosition:=0;
  BufStart:=1;
  BufEnd:=0;
  FAudioBuffer:=TAcsAudioBuffer.Create();
  FAudioBuffer.Size:=FBufferSize;
end;

procedure TAcsCustomInput.Done();
begin
  if Assigned(FAudioBuffer) then FreeAndNil(FAudioBuffer);
  FActive:=False;
end;

{ TAcsCustomOutput }

constructor TAcsCustomOutput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive:=False;
  FBuffer:=TAcsAudioBuffer.Create();
  FBufferSize:=$4000; // default buffer size
  Thread:=nil;
end;

destructor TAcsCustomOutput.Destroy();
begin
  if Assigned(Thread) then FreeAndNil(Thread);
  FreeAndNil(FBuffer);
  inherited Destroy;
end;

procedure TAcsCustomOutput.Init();
var
  //TmpInput: TAcsCustomInput;
  TmpPrefetchMode: TAcsPrefetchMode;
begin
  if not Assigned(FInput) then
    raise EAcsException.Create(strInputNotAssigned);
  SetBufferSize(FBufferSize); // set default buffer size
  if Assigned(FInput) then FInput.Init();

  // calculate prefetch mode
  TmpPrefetchMode:=FPrefetchMode;
  { TODO: get prefetch mode from filters chain }
  {
  if TmpPrefetchMode = pmAuto then
  begin
    // get prefetch mode from input
    TmpInput:=Self.Input;
    while Assigned(TmpInput) or (TmpPrefetchMode = pmAuto) do
    begin
      TmpPrefetchMode:=TmpInput.PrefetchMode;
      TmpInput:=TmpInput.Input;
    end;
  end;
  }
  if TmpPrefetchMode = pmAuto then TmpPrefetchMode:=pmFetch1_4;

  // calculate prefetch size
  FPrefetchSize:=0;
  case TmpPrefetchMode of
    pmFetch3_4: FPrefetchSize:=(BufferSize div 4) * 3;
    pmFetch1_2: FPrefetchSize:=(BufferSize div 2);
    pmFetch1_4: FPrefetchSize:=(BufferSize div 4);
    pmFetch1_8: FPrefetchSize:=(BufferSize div 8);
  end;
end;

procedure TAcsCustomOutput.Done();
begin
  if Assigned(FInput) then FInput.Done();
  //SetBufferSize(0);
end;

procedure TAcsCustomOutput.Run();
begin
  if Active then Exit();
  if not Assigned(FInput) then
    raise EAcsException.Create(strInputnotAssigned);
  InputLock:=False;
  FActive:=True;

  Thread:=TAcsOutThread.Create();
  Thread.Parent:=Self;
  //Thread.DoOutput:=Self.DoOutput;
  //Thread.FOnDone:=Self.WhenDone;
  Thread.HandleException:=HandleThreadException;
  Thread.Delay:=FFetchDelay;
  try
    CanOutput:=True;
    Thread.Suspended:=False;
  except
    on E: Exception do HandleThreadException(E);
  end;
end;

procedure TAcsCustomOutput.Stop();
begin
  FreeAndNil(Thread);
end;

procedure TAcsCustomOutput.Pause();
begin
  if Assigned(Thread) then Thread.DoPause();
end;

procedure TAcsCustomOutput.Resume();
begin
  if Assigned(Thread) then Thread.DoResume();
end;

procedure TAcsCustomOutput.WhenDone();
begin
  if not Active then Exit;
  CanOutput:=False;
  Done();
  FActive:=False;
end;

function TAcsCustomOutput.GetActive(): Boolean;
begin
  Result:=FActive;
end;

function TAcsCustomOutput.GetStatus(): TAcsOutputStatus;
begin
  if Active then
  begin
    if Self.Thread.Suspended then
      Result:=tosPaused
    else
      Result:=tosPlaying;
  end
  else
    Result:=tosIdle
end;

function TAcsCustomOutput.GetPriority(): TThreadPriority;
begin
  Result:=tpNormal;
  if Assigned(Thread) then Result:=Thread.Priority;
end;

procedure TAcsCustomOutput.SetPriority(Priority: TThreadPriority);
begin
  if Assigned(Thread) then Thread.Priority:=Priority;
end;

function TAcsCustomOutput.FillBufferFromInput(var AEndOfInput: Boolean
  ): Integer;
var
  n: Integer;
begin
  Result:=0;
  if not Assigned(FInput) then Exit;
  while InputLock do;
  InputLock:=True;
  while Result < FBuffer.Size do
  begin
    n:=FInput.GetData(FBuffer.Memory+Result, FBuffer.Size-Result);
    if n = 0 then
    begin
      AEndOfInput:=True;
      Break;
    end;
    Inc(Result, n);
    // if rest of buffer is less than sample
    if (FBuffer.Size-Result) < (FInput.Channels * (FInput.BitsPerSample div 8)) then Break;
  end;
  InputLock:=False;
end;

function TAcsCustomOutput.FillBufferFromInput(): Integer;
begin
  Result:=0;
  if not Assigned(FInput) then Exit;
  while InputLock do Sleep(1);
  InputLock:=True;
  //Result:=FInput.GetData(FBuffer);
  FBuffer.Reset();
  Result:=FInput.GetData(FBuffer.Memory, FBuffer.Size);
  FBuffer.WritePosition:=FBuffer.WritePosition + Result;
  //if FBuffer.WritePosition = FBuffer.Size then FBuffer.WritePosition:=0;
  InputLock:=False;
end;

procedure TAcsCustomOutput.SetInput(AInput: TAcsCustomInput);
var
  OldInput, NewInput: TAcsCustomInput;
begin
  if Active then
  begin
    NewInput:=AInput;
    NewInput.Init();
    OldInput:=FInput;
    while InputLock do Sleep(1);
    InputLock:=True;
    FInput:=NewInput;
    InputLock:=False;
    OldInput.Done();
  end
  else
    FInput:=AInput;
end;

function TAcsCustomOutput.GetTE(): Real;
begin
   if Assigned(FInput) then
     Result:=Round(FInput.Position / ((FInput.BitsPerSample shr 3) * FInput.Channels * FInput.SampleRate))
   else
     Result:=0;
end;

function TAcsCustomOutput.GetDelay(): Integer;
begin
  if Assigned(Thread) then Result:=Thread.Delay
  else Result:=FFetchDelay;
end;

procedure TAcsCustomOutput.SetDelay(Value: Integer);
begin
  if Value > 1000 then Exit;
  if Assigned(Thread) then
  begin
    Thread.Delay:=Value;
  end;
  FFetchDelay:=Value;
end;

procedure TAcsCustomOutput.Notification(AComponent: TComponent; Operation: TOperation);
begin
  // Remove the following two lines if they cause troubles in your IDE
  if (AComponent = FInput) and (Operation = opRemove) then Input:=nil;
  inherited Notification(AComponent, Operation);
end;

procedure TAcsCustomOutput.HandleThreadException(E: Exception);
var
  Conv: TAcsCustomConverter;
begin
 InputLock:=False;
 if Status <> tosIdle then
 begin
   try
    if FInput is TAcsCustomConverter then
    begin
      Conv:=(FInput as TAcsCustomConverter);
      Conv.UnlockInput;
    end;
   except
   end;
   try
     Done;
   except
   end;
 end;
 CanOutput:=False;
 FActive:=False;
 if Assigned(FOnThreadException) then FOnThreadException(Self, E);
end;

function TAcsCustomOutput.GetBufferSize(): Integer;
begin
 if Assigned(FBuffer) then
   Result:=FBuffer.Size
 else
   Result:=0;
end;

procedure TAcsCustomOutput.SetBufferSize(AValue: Integer);
begin
  if (AValue > 0) and Assigned(FBuffer) then FBuffer.Size:=AValue;
end;

{ TAcsStreamedInput }

constructor TAcsStreamedInput.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStream:=nil;
  FSeekable:=True;
end;

{ TAcsCustomFileIn }

constructor TAcsCustomFileIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OpenCS:=TCriticalSection.Create();
  FStartSample:=0;
  FEndSample:=-1;
  FValid:=False;
end;

destructor TAcsCustomFileIn.Destroy();
begin
  FreeAndNil(OpenCS);
  inherited Destroy();
end;

procedure TAcsCustomFileIn.Init();
begin
  inherited Init();
  OpenFile();
  if StartSample <> 0 then Seek(StartSample);
  if (StartSample <> 0) or (FEndSample <> -1) then
  begin
    FSize:=FEndSample-FStartSample;
    if FEndSample = -1 then FSize:=FSize+FTotalSamples+1;
    FSize:=FSize*(BitsPerSample div 8) * FChan;
  end;
end;

procedure TAcsCustomFileIn.Reset();
begin
  inherited Reset();
  CloseFile();
end;

procedure TAcsCustomFileIn.Done();
begin
  CloseFile();
  inherited Done();
end;


function TAcsCustomFileIn.GetBPS(): Integer;
begin
  if FValid then
    Result:=FBPS
  else
    Result:=inherited GetBPS();
end;

function TAcsCustomFileIn.GetCh(): Integer;
begin
  if FValid then
    Result:=FChan
  else
    Result:=inherited GetCh();
end;

function TAcsCustomFileIn.GetSR(): Integer;
begin
  if FValid then
    Result:=FSR
  else
    Result:=inherited GetSR();
end;

function TAcsCustomFileIn.GetValid(): Boolean;
var
  WasOpened: Boolean;
begin
  Result:=FValid;
  if Result then Exit;
  WasOpened:=FOpened;
  //if (not Assigned(FStream)) or (FileName = '') then
  if (FileName = '') then // some drivers don't use FStream
  begin
    FValid:=False;
    Exit;
  end;
  if FSeekable then
  begin
    OpenFile();
    Result:=FValid;
    if not WasOpened then CloseFile();
  end;
end;

procedure TAcsCustomFileIn.SetFileName(const AValue: TFileName);
begin
  FFileName:=AValue;
  FValid:=False;
end;

procedure TAcsCustomFileIn.OpenFile();
begin
  if not FStreamDisabled then
  begin
    if not Assigned(FStream) then
    begin
      if FFileName = '' then
      begin
        inherited Done();
        raise EAcsException.Create(strFilenamenotassigned);
      end;
      FStream:=TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite);
    end;
  end;
  FSize:=0;
  FOpened:=True;
end;

procedure TAcsCustomFileIn.CloseFile();
begin
  if Assigned(FStream) then FreeAndNil(FStream);
  FOpened:=False;
end;

function TAcsCustomFileIn.GetTotalTime(): Real;
begin
  Result:=FTotalTime;
end;

procedure TAcsCustomFileIn.Jump(Offs: Real);
begin
  FOffset:=Offs;
end;

function TAcsCustomFileIn.GetPositionTime(): Real;
begin
  Result:=inherited GetPositionTime();
  //if (Size = 0) or (TotalTime = 0) then Exit;
  //Result:=Position / (Size / TotalTime);
end;

function TAcsCustomFileIn.GetSize(): Integer;
begin
  Result:=FSize;
end;

function TAcsCustomFileIn.GetProgress(): Real;
begin
  Result:=0;
  if TotalTime <> 0 then Result:=PositionTime/(TotalTime/100);
end;

function TAcsCustomFileIn.SetStartTime(Minutes, Seconds: Integer): Boolean;
var
  Sample: Integer;
begin
  Result:=False;
  if (not FSeekable) or (not FValid) then Exit;

  Sample:=(Minutes * 60 + Seconds) * FSR;
  if Sample > FTotalSamples then Exit;
  FStartSample:=Sample;
  Result:=True;
end;

function TAcsCustomFileIn.SetEndTime(Minutes, Seconds: Integer): Boolean;
var
  Sample: Integer;
begin
  Result:=False;
  if (not FSeekable) or (not FValid) then Exit;

  Sample:=(Minutes * 60 + Seconds) * FSR;
  if Sample > FTotalSamples then Exit;
  FEndSample:=Sample;
  Result:=True;
end;

{ TAcsStreamedInput }

procedure TAcsStreamedInput.SetStream(AStream: TStream);
begin
  FStream:=AStream;
  FStreamAssigned:=Assigned(FStream);
end;

procedure TAcsStreamedOutput.SetStream(AStream: TStream);
begin
  FStream:=AStream;
end;

{ TAcsCustomFileOut }

constructor TAcsCustomFileOut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF LINUX}
  FAccessMask := $1B6; // rw-rw-rw-
  {$ENDIF}
end;

procedure TAcsCustomFileOut.Init();
begin
  inherited Init();
  if Assigned(FStream) then FreeAndNil(FStream);
  if FFileName = '' then
    raise EAcsException.Create(strFilenamenotassigned);
  if not FStreamDisabled then
  begin
    if (not FileExists(FFileName)) or (FFileMode = foRewrite) then
      FStream := TFileStream.Create(FFileName, fmCreate or fmShareExclusive, FAccessMask)
    else
      FStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareExclusive, FAccessMask);
  end;
end;

procedure TAcsCustomFileOut.Done();
begin
  if Assigned(FStream) then FreeAndNil(FStream);
  inherited Done();
end;

procedure TAcsCustomFileOut.SetFileMode(AMode: TAcsFileOutputMode);
begin
  FFileMode:=foRewrite;
end;

{ TAcsCustomConverter }

procedure TAcsCustomConverter.Notification(AComponent: TComponent; Operation: TOperation);
begin
  // Remove the following two lines if they cause troubles in your IDE
  if (AComponent = FInput) and (Operation = opRemove) then Input:=nil;
  inherited Notification(AComponent, Operation);
end;

procedure TAcsCustomConverter.SetInput(AInput: TAcsCustomInput);
var
  OldInput, NewInput: TAcsCustomInput;
begin
  if AInput = Self then Exit;
  if Active then
  begin
    NewInput:=AInput;
    NewInput.Init();
    OldInput:=FInput;
    while InputLock do Sleep(1);
    InputLock:=True;
    FInput:=NewInput;
    InputLock:=False;
    OldInput.Done();
  end
  else
    FInput:=AInput;
end;

function TAcsCustomConverter.GetBPS(): Integer;
begin
  if Assigned(FInput) then
    Result:=FInput.BitsPerSample
  else
    Result:=inherited GetBPS();
end;

function TAcsCustomConverter.GetCh(): Integer;
begin
  if Assigned(FInput) then
    Result:=FInput.Channels
  else
    Result:=inherited GetCh();
end;

function TAcsCustomConverter.GetSR(): Integer;
begin
  if Assigned(FInput) then
    Result:=FInput.SampleRate
  else
    Result:=inherited GetSR();
end;

procedure TAcsCustomConverter.UnlockInput();
var
  Conv: TAcsCustomConverter;
begin
  InputLock:=False;
  if Assigned(FInput) then
  if (FInput is TAcsCustomConverter) then
  begin
    Conv:=(FInput as TAcsCustomConverter);
    Conv.UnlockInput();
  end;
end;

procedure TAcsCustomConverter.Init();
begin
  if not Assigned(FInput) then
    raise EAcsException.Create(strInputnotAssigned);
  inherited Init();
  FInput.Init();
  InputLock:=False;
end;

procedure TAcsCustomConverter.Done();
begin
  if Assigned(FInput) then FInput.Done();
  inherited Done();
end;

{ TAcsCircularBuffer }

constructor TAcsCircularBuffer.Create();
begin
  inherited Create;
  BlockEventName:='Block'+IntToStr(LongWord(Self)); // this way we guarantee that the name is unique
  BlockEvent:= TEvent.Create(nil, True, False, BlockEventName);
  CS := TCriticalSection.Create();
end;

destructor TAcsCircularBuffer.Destroy();
begin
  FreeAndNil(CS);
  FreeAndNil(BlockEvent);
  inherited Destroy;
end;

procedure TAcsCircularBuffer.Reset();
begin
  CS.Enter();
  try
    ReadCur:=0;
    WriteCur:=0;
    FBytesRead:=0;
    BlockEvent.SetEvent();
  finally
    CS.Leave();
  end;
end;

function TAcsCircularBuffer.Write(const Buffer; Count: Longint): Longint;
var
  addr: Pointer;
  S1, S2: Integer;
begin
  if WriteCur >= ReadCur then
  begin
    CS.Enter();
    S1:=STREAM_BUFFER_SIZE-WriteCur;
    if (Count <= S1) then
    begin
      Move(Buffer, Buff[WriteCur], Count);
      Inc(WriteCur, Count);
      Inc(FBytesInBuffer, Count);
      Result:=Count;
    end
    else
    begin
      Move(Buffer, Buff[WriteCur], S1);
      //addr:=Pointer(Cardinal(@Buffer) + S1);
      addr:=@Buffer;
      Inc(addr, S1);
      S2:=Count-S1;
      if S2 > ReadCur then S2:=ReadCur;
      Move(addr^, Buff[0], S2);
      WriteCur:=S2;
      Inc(FBytesInBuffer, S1+S2);
      Result:=S1+S2;
    end;
  end
  else
  begin
    S2:=ReadCur-WriteCur;
    if Count < S2 then S2:=Count;
    Move(Buffer, Buff[WriteCur], S2);
    Inc(WriteCur, S2);
    Inc(FBytesInBuffer, S2);
    Result:=S2;
  end;
  if Result <> 0 then
    if FBufferMode = bmBlock then
      BlockEvent.SetEvent();
  CS.Leave();
end;

function TAcsCircularBuffer.Read(var Buffer; Count: Integer): Integer;
var
  addr: Pointer;
  S1, S2: Integer;
begin
  if (ReadCur = WriteCur) and (FBufferMode = bmBlock) then
  begin
    BlockEvent.WaitFor(INFINITE);
    BlockEvent.ResetEvent();
  end;
  CS.Enter();
  if ReadCur <= WriteCur then
  begin
    S2:=WriteCur-ReadCur;
    if Count < S2 then S2:=Count;
    Move(Buff[ReadCur], Buffer, S2);
    Inc(ReadCur, S2);
    Dec(FBytesInBuffer, S2);
    Result:=S2;
  end
  else
  begin
    S1:=STREAM_BUFFER_SIZE-ReadCur;
    if Count <= S1 then
    begin
      Move(Buff[ReadCur], Buffer, Count);
      Inc(ReadCur, Count);
      Dec(FBytesInBuffer, Count);
      Result:=Count;
    end
    else
    begin
      S2:=WriteCur;
      if Count-S1 < S2 then S2:=Count;
      Move(Buff[ReadCur], Buffer, S1);
      //addr := Pointer(Cardinal(@Buffer)+S1);
      addr:=@Buffer;
      Inc(addr, S1);
      Move(Buff[0], addr^, S2);
      ReadCur:=S2;
      Dec(FBytesInBuffer, S1+S2);
      Result:=S1+S2;
    end;
  end;
  Inc(FBytesRead, Result);
  CS.Leave();
end;

// the following property is implemented 'cause tstreams position property uses them

function TAcsCircularBuffer.Seek(Offset: Longint; Origin: Word): Integer;
begin
  if (Offset = 0) and (Origin = 0) then Result:=FBytesRead
  else Result:=0;
end;

function TAcsCircularBuffer.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  if (Offset = 0) and (Origin = soCurrent) then Result:=FBytesRead
  else Result:=0;
end;

{ TAcsFileInfo }

function TAcsFileInfo.GetStringTag(Idx: string): TAcsFileTag;
begin
 Result:=nil;
end;

procedure TAcsFileInfo.ReadFromFile();
begin
end;

procedure TAcsFileInfo.SetStringTag(Idx: string; const AValue: TAcsFileTag);
begin
end;

procedure TAcsFileInfo.SaveToFile();
begin
end;

{ TAcsFileTag }

function TAcsFileTag.GetName(): string;
begin
 Result:='';
end;

function TAcsFileTag.AsString(): string;
begin
 Result:='';
end;

function TAcsFileTag.Streamable(): Boolean;
begin
  Result:=False;
end;

procedure TAcsFileTag.SaveToStream(Stream: TStream);
begin
end;

procedure TAcsFileTag.LoadFromStream(Stream: TStream);
begin
end;

end.


