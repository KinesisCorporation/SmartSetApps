(*
this file is a part of audio components suite,
copyright (c) 2005 ross levis. all rights reserved.
see the license file for more details.

TMultiMixer provides for an unlimited number of inputs (channels)
to be mixed into one audio buffer.  Only supports 44100/16/2

TMultiMixer
 - property TotalChannels: Integer; // get/set the number of channels
 - property Channel[Index: Integer]: TChannel; default
    TChannel
     - procedure Preload; // runs Input.Init to make starting faster (optional)
     - procedure Start; // Start channel
     - procedure Stop; // Stop channel
     - property Input: TAcsInput
     - property Volume: Word; // 0 = silent, 32768 = 100%

eg.
  MultiMixer.TotalChannels := 1;
  MultiMixer[0].Input := VorbisIn1;
  AudioOut1.Run;
  MultiMixer.TotalChannels := 2; // Channels can be added or removed while playing
  MultiMixer[1].Input := WAVEIn1;
  MultiMixer[1].Volume := 16384; // 50% volume
  MultiMixer[1].Start; // while at least 1 mixer is playing, others
  MultiMixer[0].Stop; //  can be started and stopped individually.

*)


{$hints off}
unit acs_multimix;

interface

uses
  Classes, SysUtils, ACS_Types, ACS_Classes, ACS_Strings;

const
  BUF_SIZE = 8820;

type
  TAcsMultiMixer = class;

  TAcsChannel = class
  private
    FOwner: TAcsMultiMixer;
    FInput: TAcsCustomInput;
    FVolume: Word;
    EndOfInput: Boolean;
    Preloaded: Boolean;
    InBuf: array[1..BUF_SIZE] of Byte;
  public
    constructor Create(AOwner: TAcsMultiMixer); virtual;
    destructor Destroy; override;
    procedure Preload();
    procedure Start();
    procedure Stop();
    property Input: TAcsCustomInput read FInput write FInput;
    property Volume: Word read FVolume write FVolume;
  end;

  TAcsMultiMixer = class(TAcsCustomInput)
  private
    FChannel: array of TAcsChannel;
    FTotalChannels: Integer;
    OutBuf: array[1..BUF_SIZE] of Byte;
    Buisy: Boolean;
    FLock: Boolean;
    function GetChannel(Index: Integer): TAcsChannel;
    procedure SetTotalChannels(Num: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    property Channel[Index: Integer]: TAcsChannel read GetChannel; default;
  published
    property TotalChannels: Integer read FTotalChannels write SetTotalChannels;
  end;

implementation

{ TAcsChannel }

constructor TAcsChannel.Create();
begin
  inherited Create;
  FOwner:=AOwner;
  FVolume:=32768;
  EndOfInput:=True;
  Preloaded:=False;
end;

destructor TAcsChannel.Destroy();
begin
  inherited Destroy;
end;

procedure TAcsChannel.Preload();
begin
  if EndOfInput and not Preloaded and Assigned(FInput) then
  begin
    FInput.Init();
    Preloaded:=True;
  end;
end;

procedure TAcsChannel.Start();
begin
  if FOwner.Buisy and EndOfInput and Assigned(FInput) then
  begin
    if not Preloaded then Preload();
    EndOfInput:=False;
  end;
end;

procedure TAcsChannel.Stop();
begin
  if not EndOfInput then
  begin
    EndOfInput:=True;
    Preloaded:=False;
    while FOwner.Flock do Sleep(1);
    FOwner.FLock:=True;
    FInput.Done();
    FOwner.Flock:=False;
  end;
end;

{ TAcsMultiMixer }

constructor TAcsMultiMixer.Create();
begin
  inherited Create(AOwner);
  FLock:=False;
end;

destructor TAcsMultiMixer.Destroy();
begin
  SetTotalChannels(0); // free channels
  inherited Destroy;
end;

procedure TAcsMultiMixer.SetTotalChannels(Num: Integer);
var
  chan: Integer;
begin
  if (Num >= 0) and (Num <> FTotalChannels) then
  begin
    while Flock do;
    FLock:=True;
    if Num < FTotalChannels then // remove channels
    begin
      for chan:=FTotalChannels-1 downto Num do
      with FChannel[chan] do
      begin
        if not EndOfInput then FInput.Done();
        Free();
      end;
      SetLength(FChannel, Num);
    end
    else begin // add channels
      SetLength(FChannel, Num);
      for chan:=FTotalChannels to Num-1 do
        FChannel[chan]:=TAcsChannel.Create(Self);
    end;
    FTotalChannels:=Num;
    FLock:=False;
  end;
end;

{ TODO : Variable sample params and resample }
function TAcsMultiMixer.GetBPS();
begin
  Result:=16;
end;

function TAcsMultiMixer.GetCh();
begin
  Result:=2;
end;

function TAcsMultiMixer.GetSR();
begin
  Result:=44100;
end;

procedure TAcsMultiMixer.Init();
var
  chan: Integer;
begin
  Buisy:=True;
  FPosition:=0;
  for chan:=0 to FTotalChannels-1 do
    FChannel[chan].Start();
  //FSize:=0;
  FLock:=False;
end;

procedure TAcsMultiMixer.Done();
var
  chan: Integer;
begin
  for chan:=0 to FTotalChannels-1 do
  with FChannel[chan] do
  begin
    if Assigned(FInput) then FInput.Done();
    EndOfInput:=True;
    Preloaded:=False;
  end;
  Buisy:=False;
end;

function TAcsMultiMixer.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  i, chan, ReadSize, BufSize: Integer;
  InBuf16, OutBuf16: PAcsBuffer16;
begin
  if not Buisy then
    raise EAcsException.Create(strStreamnotopen);
  while Flock do sleep(0);
  Flock:=True;
  BufSize:=0;
  if ABufferSize > BUF_SIZE then ABufferSize:=BUF_SIZE;
  for chan:=0 to FTotalChannels-1 do
  begin
    with FChannel[chan] do
    begin
      if not EndOfInput then
      begin
        ReadSize:=FInput.GetData(@InBuf[1], ABufferSize);
        while (ReadSize < ABufferSize) and (ReadSize <> 0) do
        begin
          Result:=FInput.GetData(@InBuf[ReadSize+1], ABufferSize-ReadSize);
          Inc(ReadSize, Result);
        end;
        FillChar(InBuf[ReadSize+1], ABufferSize-ReadSize, 0); // zero rest of ABuffer
        if ReadSize = 0 then
          EndOfInput:=True
        else
          if ReadSize > BufSize then BufSize:=ReadSize;
      end;
    end;
  end;
  if BufSize = 0 then
  begin
    Flock:=False;
    Result:=0;
    Exit;
  end;

  // mix
  FillChar(OutBuf[1], ABufferSize, 0);
  OutBuf16:=@OutBuf;
  for chan:=0 to FTotalChannels-1 do
  begin
    with FChannel[chan] do
    begin
      if not EndOfInput then
      begin
        InBuf16:=@InBuf;
        for i:=0 to (BufSize div 2)-1 do
          OutBuf16[i]:=OutBuf16[i] + (InBuf16[i] * FVolume div 32768);
      end;
    end;
  end;
  Flock:=False;

  Result:=BufSize;
  Move(OutBuf[1], ABuffer^, Result);
  Inc(FPosition, Result);
end;

function TAcsMultiMixer.GetChannel(Index: Integer): TAcsChannel;
begin
  Result:=FChannel[Index];
end;

end.
