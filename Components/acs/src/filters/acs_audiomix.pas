(*
  this file is a part of audio components suite.
  see the license file for more details.
  you can contact me at mail@z0m3ie.de

$Log: acs_audiomix.pas,v $
Revision 1.6  2006/07/04 17:12:45  z0m3ie
ACS 2.4 alt wiederhergestellt (unterschiedliche Sampleformate ...)

Revision 1.1  2005/12/19 18:34:35  z0m3ie
*** empty log message ***

Revision 1.4  2005/12/04 16:54:33  z0m3ie
All classes are renamed, Style TAcs... than T... to avoid conflicts with other components (eg TMixer is TAcsMixer now)

Revision 1.3  2005/09/15 20:59:37  z0m3ie
start translate the documentation in the source for pasdoc

Revision 1.2  2005/09/13 21:54:11  z0m3ie
acs is localizeable now (ACS_Strings)

Revision 1.1  2005/09/12 22:04:52  z0m3ie
modified structure again, fileformats are now in an sperat folder.
all File In/Out classes are capsulated from TFileIn and TFileOut

Revision 1.3  2005/08/23 19:45:51  z0m3ie
changed to Version 2.31

Revision 1.2  2005/08/22 20:17:01  z0m3ie
changed Headers to log
changed mail adress
*)

{
@abstract(this unit introduces the base classes for acs)
@author(Andrei Borovsky (2003-2005))
@author(Christian Ulrich (2005))
}

//{$hints off}
unit acs_audiomix;

interface

uses
  Classes, SysUtils, ACS_Types, ACS_Classes, ACS_Strings;
  
const
  BUF_SIZE = $100000;
  
type
  TAcsAudioMixerMode = (amMix, amConcatenate, amRTMix, amCustomMix);

  { TAcsAudioMixer }
  { Component }
  TAcsAudioMixer = class(TAcsCustomInput)
  private
    FInput1: TAcsCustomInput;
    FInput2: TAcsCustomInput;
    ByteCount: Cardinal;                // add by leozhang
    FVolume1: Byte;
    FVolume2: Byte;
    EndOfInput1: Boolean;
    EndOfInput2: Boolean;
    InBuf1: array[1..BUF_SIZE] of Byte;
    InBuf2: array[1..BUF_SIZE] of Byte;
    FMode: TAcsAudioMixerMode;
    FInput2Start: Cardinal;
    FLock: Boolean;
    FFgPlaying: Boolean;
    procedure SetInput1(AInput: TAcsCustomInput);
    procedure SetInput2(AInput: TAcsCustomInput);
  protected
    function GetBPS: Integer; override;
    function GetCh: Integer; override;
    function GetSR: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    property FgPlaying: Boolean read FFgPlaying;
  published
    property Input1: TAcsCustomInput read FInput1 write SetInput1;
    property Input2: TAcsCustomInput read FInput2 write SetInput2;
    property Mode: TAcsAudioMixerMode read FMode write FMode;
    property Input2Start: Cardinal read FInput2Start write FInput2Start;
    property Volume1: Byte read FVolume1 write FVolume1;
    property Volume2: Byte read FVolume2 write FVolume2;
  end;
  
implementation  

procedure MixChannels16(Buf1, Buf2: PAcsBuffer16; Vol1, Vol2, InSize: Integer);
var      // optimized by leozhang
  i: Integer;
  V1, V2: Real;
begin
  V1:=Vol1/127;
  V2:=Vol2/127;
  for i:=0 to (Insize shr 1)-1 do
  begin
    if Buf2[i]=0 then
    begin
      Buf2[i]:=Round(Buf1[i]*V1);
    end
    else
    begin
      if Buf1[i]=0 then
        Buf2[i]:=Round(Buf2[i]*V2)
      else
        Buf2[i]:=Round(Buf1[i]*V1)+Round(Buf2[i]*V2);
    end;
  end;
end;

constructor TAcsAudioMixer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLock:=False;
  FVolume1:=127;
  FVolume2:=127;
  FInput2Start:=0;
  FInput1:=nil;
  FInput2:=nil;
end;

destructor TAcsAudioMixer.Destroy();
begin
  inherited Destroy();
end;

function TAcsAudioMixer.GetBPS(): Integer;
begin
  if Assigned(FInput1) then Result:=FInput1.BitsPerSample
  else Result:=inherited GetBPS();
end;

function TAcsAudioMixer.GetCh(): Integer;
begin
  if Assigned(FInput1) then Result:=FInput1.Channels
  else Result:=inherited GetCh();
end;

function TAcsAudioMixer.GetSR(): Integer;
begin
  if Assigned(FInput1) then Result:=FInput1.SampleRate
  else Result:=inherited GetSR();
end;

procedure TAcsAudioMixer.Init();
var
  In2StartByte: Cardinal;     // add by zhangl.
begin
  inherited Init();
  EndOfInput1:=False;
  EndOfInput2:=False;
  if not Assigned(FInput1) then Exit;
    //raise EAcsException.Create(strInputnotAssigned);
  if FMode=amRTMix then
  begin
    FInput1.Init();
    {FSize:=FInput1.Size;  }
    if Assigned(FInput2) then
    begin
      FInput2.Init();
      FFgPlaying := True;
    end
    else
      EndOfInput2 := True;
    FLock := False;
  end
  else
  begin
    if not Assigned(FInput2) then Exit;
    //raise EAcsException.Create(strInputnotAssigned);
    FInput1.Init();
    FInput2.Init();
    case FMode of
      {amMix:
        {if FInput1.Size > FInput2.Size then
          FSize:=FInput1.Size
        else
          FSize:=FInput2.Size;
      amConcatenate:
        FSize:=FInput1.Size+FInput2.Size;     //determine the size of the output stream in bytes }
      amCustomMix:
      begin
        // add by leozhang
         In2StartByte:=Round((FInput2Start*Cardinal(FInput2.SampleRate))/1000)
                       *(Cardinal(FInput2.Channels))
                       *((Cardinal(FInput2.BitsPerSample)) shr 3);
         ByteCount:=In2StartByte;
         {if Cardinal(FInput1.Size) > (In2StartByte+Cardinal(FInput2.Size)) then
           FSize:=FInput1.Size
         else
           FSize:=In2StartByte+Cardinal(FInput2.Size);  }
         FLock := False;
      end;
      // leozhang
    end;
  end;
end;

procedure TAcsAudioMixer.Done();
begin
  if Assigned(FInput1) then FInput1.Done();
  if (FMode <> amRTMix) or Assigned(FInput2) then FInput2.Done();
  inherited Done();
end;

function TAcsAudioMixer.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  l1, l2: Integer;
  InSize: Integer;
begin
  Result:=0;
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  if BufStart > BufEnd then
  begin
    if EndOfInput1 and EndOfInput2 then Exit;
    if (FMode=amRTMix) and EndOfInput1 then Exit;
    BufStart:=1;
    case Mode of
      amMix:
      begin
        l1:=0;
        l2:=0;
        FillChar(InBuf1[1], BUF_SIZE, 0);
        FillChar(InBuf2[1], BUF_SIZE, 0);
        if not EndOfInput1 then
        begin
          l1:=FInput1.GetData(@InBuf1[1], BUF_SIZE);
          InSize:=l1;
          while (InSize<>0) and (l1<BUF_SIZE) do
          begin
            InSize:=FInput1.GetData(@InBuf1[l1+1], BUF_SIZE-l1);
            Inc(l1, InSize);
          end;
          if InSize=0 then EndOfInput1:=True;
        end;
        if not EndOfInput2 then
        begin
          l2:=FInput2.GetData(@InBuf2[1], BUF_SIZE);
          InSize:=l2;
          while (InSize <> 0) and (l2 < BUF_SIZE) do
          begin
            InSize:=FInput2.GetData(@InBuf2[l2+1], BUF_SIZE-l2);
            Inc(l2, InSize);
          end;
          if InSize=0 then EndOfInput2:=True;
        end;
        if (l1 = 0) and (l2 = 0) then
        begin
          Result:=0;
          Exit;
        end;
        if l1 > l2 then BufEnd:=l1 else BufEnd:=l2;
        MixChannels16(@InBuf1[1], @InBuf2[1], FVolume1, FVolume2, BufEnd);
      end;

      amConcatenate :
      begin
        if not EndOfInput1 then
        begin
          l1:=FInput1.GetData(@InBuf2[1], BUF_SIZE);
          if l1=0 then EndOfInput1:=True else BufEnd:=l1;
        end;
        if EndOfInput1 then
        begin
          l2:=FInput2.GetData(@InBuf2[1], BUF_SIZE);
          if l2=0 then Exit else BufEnd:=l2;
        end;
      end;

      // add by leo.zhang
      amCustomMix:
      begin
        l1:=0;
        l2:=0;
        FillChar(InBuf1[1], BUF_SIZE, 0);
        FillChar(InBuf2[1], BUF_SIZE, 0);
        if not EndOfInput1 then
        begin
          l1:=FInput1.GetData(@InBuf1[1], BUF_SIZE);
          InSize:=l1;
          while (InSize <> 0) and (l1 < BUF_SIZE) do
          begin
            InSize:=FInput1.GetData(@InBuf1[l1+1], BUF_SIZE-l1);
            Inc(l1, InSize);
          end;
          if InSize = 0 then EndOfInput1:=True;
        end;
        if not (FLock or EndOfInput2) then
        begin
          FLock:=True;
          if ByteCount > BUF_SIZE then
          begin
            ByteCount:=ByteCount-BUF_SIZE;
            l2:=BUF_SIZE;
            InSize:=l2;
          end
          else
          begin
            l2:=FInput2.GetData(@InBuf2[ByteCount+1], BUF_SIZE-ByteCount);
            InSize:=l2;
            if ByteCount <> 0 then
            begin
              Inc(Cardinal(l2), ByteCount);
              InSize:=l2;
              ByteCount:=0;
            end;
            while (InSize <> 0) and (l2 < BUF_SIZE) do
            begin
              InSize:=FInput2.GetData(@InBuf2[l2+1], BUF_SIZE-l2);
              Inc(l2, InSize);
            end;
          end;
          if InSize = 0 then EndOfInput2:=True;
          FLock:=False;
        end;
        if (l1 = 0) and (l2 = 0) then Exit;
        if l1 > l2 then BufEnd:=l1 else BufEnd:=l2;
        MixChannels16(@InBuf1[1], @InBuf2[1], FVolume1, FVolume2, BufEnd);
      end;
      // leo.zhang.

      amRTMix:
      begin
        l1:=0;
        l2:=0;
        FillChar(InBuf1[1], BUF_SIZE, 0);
        FillChar(InBuf2[1], BUF_SIZE, 0);
        if not EndOfInput1 then
        begin
          l1:=FInput1.GetData(@InBuf1[1], BUF_SIZE);
          InSize:=l1;
          while (InSize <> 0) and (l1 < BUF_SIZE) do
          begin
            InSize:=FInput1.GetData(@InBuf1[l1+1], BUF_SIZE-l1);
            Inc(l1, InSize);
          end;
          if InSize = 0 then EndOfInput1:=True;
        end;
        if not (FLock or EndOfInput2) then
        begin
          FLock:=True;
          l2:=FInput2.GetData(@InBuf2[1], BUF_SIZE);
          InSize:=l2;
          while (InSize <> 0) and (l2 < BUF_SIZE) do
          begin
            InSize:=FInput2.GetData(@InBuf2[l2+1], BUF_SIZE-l2);
            Inc(l2, InSize);
          end;
          if InSize = 0 then
          begin
            EndOfInput2:=True;
            FFGPlaying:=False;
            FInput2.Done();
            FInput2:=nil;
          end;
          FLock:=False;
        end;
        if (l1 = 0) and (l2 = 0) then Exit;
        if l1 > l2 then BufEnd:=l1 else BufEnd:=l2;
        MixChannels16(@InBuf1[1], @InBuf2[1], FVolume1, FVolume2, BufEnd);
      end;
    end;  // case end.
  end;  // endif.

  if ABufferSize < (BufEnd-BufStart+1) then
    Result:=ABufferSize
  else
    Result:=BufEnd-BufStart+1;
  Move(InBuf2[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  Inc(FPosition, Result);
end;

procedure TAcsAudioMixer.SetInput1(AInput: TAcsCustomInput);
begin
  if Active then
    raise EAcsException.Create(strBusy);
  FInput1:=AInput;
end;

procedure TAcsAudioMixer.SetInput2(AInput: TAcsCustomInput);
begin
  if not Active then FInput2:=AInput
  else
  begin
    if FMode = amRTMix then
    begin
      if FFgPlaying then
      begin
        while Flock do;
        FLock:=True;
        Input2.Done();
      end;
      FInput2:=AInput;
      FInput2.Init();
      FLock:=False;
      FFgPlaying:=True;
      EndOfInput2:=False;
    end
    else
      raise EAcsException.Create(strNotinFBMode);
  end;
end;

end.
