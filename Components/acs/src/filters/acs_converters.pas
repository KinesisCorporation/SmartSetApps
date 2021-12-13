(*
  this file is a part of audio components suite.
  see the license file for more details.
  you can contact me at mail@z0m3ie.de

$Log: acs_converters.pas,v $
Revision 1.6  2006/08/31 20:10:54  z0m3ie
*** empty log message ***

Revision 1.5  2006/07/04 18:38:32  z0m3ie
*** empty log message ***

Revision 1.4  2006/07/04 17:12:45  z0m3ie
ACS 2.4 alt wiederhergestellt (unterschiedliche Sampleformate ...)

Revision 1.2  2006/01/01 18:46:40  z0m3ie
*** empty log message ***

Revision 1.1  2005/12/19 18:34:35  z0m3ie
*** empty log message ***

Revision 1.4  2005/12/04 16:54:33  z0m3ie
All classes are renamed, Style TAcs... than T... to avoid conflicts with other components (eg TMixer is TAcsMixer now)

Revision 1.3  2005/09/15 20:59:38  z0m3ie
start translate the documentation in the source for pasdoc

Revision 1.2  2005/09/13 21:54:11  z0m3ie
acs is localizeable now (ACS_Strings)

Revision 1.1  2005/09/12 22:04:52  z0m3ie
modified structure again, fileformats are now in an sperat folder.
all File In/Out classes are capsulated from TFileIn and TFileOut

Revision 1.4  2005/09/01 19:55:48  z0m3ie
again Delphi corrections

Revision 1.3  2005/08/31 20:30:39  z0m3ie
Mixer Channelname work now
minior corrections for Converters

Revision 1.2  2005/08/22 20:17:01  z0m3ie
changed Headers to log
changed mail adress
*)

{
@abstract(this unit introduces the base classes for acs)
@author(Andrei Borovsky (2003-2005))
@author(Christian Ulrich (2005))
}

unit acs_converters;

interface

uses
  Classes, SysUtils, ACS_Types, ACS_Procs, ACS_Classes, ACS_Strings;

const
  BUF_SIZE = $8000;

  KERNEL_WIDTH = 64;

  SD_BUF_SIZE = 2048;

type

  TAcsMSConverterMode = (msmMonoToBoth, msmMonoToLeft, msmMonoToRight);

  TDA = array[0..63] of Double;
  PDA = ^TDA;


  TAcsRateConverter = class(TAcsCustomConverter)
  private
    FOutSampleRate: Integer;
    WantedSize: Integer;
    EndOfInput: Boolean;
    remainder: Integer;
    InBufM, OutBufM: PAcsBuffer16;
    InBufS, OutBufS: PAcsStereoBuffer16;
    DAM: array of Double;
    DAS: array of TAcsStereoSampleD;
    FKernel: TAcsArrayOfDouble;
    FKernelWidth: Integer;
    FFilterWindow: TAcsFilterWindowType;
    Tail: Pointer;
    LBS: TAcsStereoSample16;
    function ConvertFreqs16Mono(InSize: Integer): Integer;
    function ConvertFreqs16Stereo(InSize: Integer): Integer;
    procedure SetOutSampleRate(aSR: Integer);
    procedure SetKernelWidth(aKW: Integer);
  protected
    function GetBPS: Integer; override;
    function GetSR: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
  published
    property FilterWindow: TAcsFilterWindowType read FFilterWindow write FFilterWindow;
    property KernelWidth: Integer read FKernelWidth write SetKernelWidth;
    property OutSampleRate: Integer read FOutSampleRate write SetOutSampleRate;
  end;

  TAcsMSConverter = class(TAcsCustomConverter)
  private
    WantedSize: Integer;
    EndOfInput: Boolean;
    InOutBuf: array[1..BUF_SIZE] of Byte;
    FMode: TAcsMSConverterMode;
  protected
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
  published
    property Mode: TAcsMSConverterMode read FMode write FMode;
  end;

  TAcsSampleConverter = class(TAcsCustomConverter)
  private
    WantedSize: Integer;
    EndOfInput: Boolean;
    InOutBuf: array[1..BUF_SIZE] of Byte;
  protected
    function GetBPS(): Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
  end;

  TAcsStereoBalance = class(TAcsCustomConverter)
  private
    FBalance: Single;
    procedure SetBalance(AValue: Single);
  protected
    function GetCh: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
  published
    property Balance: Single read FBalance write SetBalance;
  end;

implementation

function TAcsRateConverter.ConvertFreqs16Mono(InSize: Integer): Integer;
type
  TAcsDoubleArray = array [0..0] of Double;
  PAcsDoubleArray = ^TAcsDoubleArray;
var
  i, step, j, k, s, m: Integer;
  D: Double;
  TailMono: PAcsBuffer16;
  TailMonoD: PAcsDoubleArray;
begin
  TailMono:=Tail;
  s:=InSize shr 1;
  if FInput.SampleRate > FOutSampleRate then
  begin
    step:=FInput.SampleRate - FOutSampleRate;
    j:=0;
    if remainder < 0 then remainder:=FOutSampleRate;
    for i:=0 to s - 1 do
    begin
      if remainder > FOutSampleRate then Dec(remainder, FOutSampleRate)
      else begin
        D:=0;
        for k:=0 to FKernelWidth - 1 do
        if i-k >= 0 then
        D:=D + InBufM[i-k] * FKernel[FKernelWidth - 1 - k]
        else
        D:=D + TailMono[FKernelWidth-1+i-k] * FKernel[FKernelWidth - 1 - k];
        OutBufM[j]:=Round(D);
        Inc(j);
        Inc(remainder, step);
      end;
    end;
    for i:=0 to FKernelWidth-2 do TailMono[i]:=InBufM[i+s-FKernelWidth+1]
  end else
  begin
    TailMonoD:=Tail;
    FillChar(DAM[0], Length(DAM)*8, 0);
    for i:=0 to FKernelWidth-2 do
    begin
      DAM[i]:=TailMonoD[i];
      TailMonoD[i]:=0;
    end;
    Step:=Finput.SampleRate;
    j:=0;
    if remainder < 0 then remainder:=0;
    while remainder < FOutSampleRate do
    begin
      m:=Round(((FOutSampleRate - remainder)*LBS.Left +  remainder*InBufM[0])/FOutSampleRate);
      for k:=0 to FKernelWidth-1 do
      DAM[j+k]:=DAM[j+k] + m * FKernel[k];
      Inc(j);
      Inc(remainder, step);
    end;
    Dec(remainder, FOutSampleRate);
    for i:=0 to s - 2 do
    begin
      while remainder < FOutSampleRate do
      begin
        m:=Round(((FOutSampleRate - remainder)*InBufM[i] +  remainder*InBufM[i+1])/FOutSampleRate);
        for k:=0 to FKernelWidth-1 do
        DAM[j+k]:=DAM[j+k] + m * FKernel[k];
        Inc(j);
        Inc(remainder, step);
      end;
      Dec(remainder, FOutSampleRate);
    end;
    LBS.Left:=InBufM[s-1];
    for i:=0 to j-1 do
    OutBufM[i]:=Round(DAM[i]);
    for i:=0 to FKernelWidth-2 do TailMonoD[i]:=DAM[i+j];
  end;
  Result:=j shl 1;
end;

function TAcsRateConverter.ConvertFreqs16Stereo(InSize: Integer): Integer;
var
  i, step, j, k, s, m1, m2: Integer;
  D1, D2: Double;
  TailStereo: PAcsStereoBuffer16;
  TailStereoD: PAcsStereoBufferD;
begin
  TailStereo:=Tail;
  s:=InSize shr 2;
  if FInput.SampleRate > FOutSampleRate then
  begin
    step:=FInput.SampleRate - FOutSampleRate;
    j:=0;
    if remainder < 0 then remainder:=FOutSampleRate;
    for i:=0 to s - 1 do
    begin
      try
      if remainder > FOutSampleRate then Dec(remainder, FOutSampleRate)
      else begin
        D1:=0;
        D2:=0;
        for k:=0 to FKernelWidth - 1 do
        if i-k >= 0 then
        begin
          D1:=D1 + InBufS[i-k].Left * FKernel[FKernelWidth - 1 - k];
          D2:=D2 + InBufS[i-k].Right * FKernel[FKernelWidth - 1 - k];
        end else
        begin
          D1:=D1 + TailStereo[FKernelWidth-1+i-k].Left * FKernel[FKernelWidth - 1 - k];
          D2:=D2 + TailStereo[FKernelWidth-1+i-k].Right * FKernel[FKernelWidth - 1 - k];
        end;
        OutBufS[j].Left:=Round(D1);
        OutBufS[j].Right:=Round(D2);
        Inc(j);
        Inc(remainder, step);
      end;
      except
      end;
    end;
    for i:=0 to FKernelWidth-2 do TailStereo[i]:=InBufS[i+s-FKernelWidth+1]
    //Move(InBufS[s-FKernelWidth+1], TailStereo[0], FKernelWidth-1);
  end else
  begin
    TailStereoD:=Tail;
    FillChar(DAS[0], Length(DAS)*16, 0);
    for i:=0 to FKernelWidth-2 do
    begin
      DAS[i]:=TailStereoD[i];
      TailStereoD[i].Left:=0;
      TailStereoD[i].Right:=0;
    end;
    Step:=Finput.SampleRate;
    j:=0;
    if remainder < 0 then remainder:=0;
    while remainder < FOutSampleRate do
    begin
      m1:=Round(((FOutSampleRate - remainder)*LBS.Left +  remainder*InBufS[0].Left)/FOutSampleRate);
      m2:=Round(((FOutSampleRate - remainder)*LBS.Right +  remainder*InBufS[0].Right)/FOutSampleRate);
      for k:=0 to FKernelWidth-1 do
      begin
        DAS[j+k].Left:=DAS[j+k].Left + m1 * FKernel[k]; //InBufS[i].Left*Kernel[k];
        DAS[j+k].Right:=DAS[j+k].Right + m2 * FKernel[k]; //InBufS[i].Right*Kernel[k];
      end;
      Inc(j);
      Inc(remainder, step);
    end;
    Dec(remainder, FOutSampleRate);
    for i:=0 to s - 2 do
    begin
      while remainder < FOutSampleRate do
      begin
        m1:=Round(((FOutSampleRate - remainder)*InBufS[i].Left +  remainder*InBufS[i+1].Left)/FOutSampleRate);
        m2:=Round(((FOutSampleRate - remainder)*InBufS[i].Right +  remainder*InBufS[i+1].Right)/FOutSampleRate);
        for k:=0 to FKernelWidth-1 do
        begin
         DAS[j+k].Left:=DAS[j+k].Left + m1 * FKernel[k]; //InBufS[i].Left*Kernel[k];
         DAS[j+k].Right:=DAS[j+k].Right + m2 * FKernel[k]; //InBufS[i].Right*Kernel[k];
        end;
        Inc(j);
        Inc(remainder, step);
      end;
      Dec(remainder, FOutSampleRate);
    end;
    LBS:=InBufS[s-1];
    for i:=0 to j-1 do
    begin
      OutBufS[i].Left:=Round(DAS[i].Left);
      OutBufS[i].Right:=Round(DAS[i].Right);
    end;
    for i:=0 to FKernelWidth-2 do TailStereoD[i]:=DAS[i+j];
  end;
  Result:=j shl 2;
end;

procedure Convert16To8(InOutBuf: PAcsBuffer8; InSize: Integer);
var
  i: Integer;
  P: PAcsBuffer16;
begin
  P:=@InOutBuf[0];
  for i:=0 to (Insize shr 1) -1 do
  InOutBuf[i]:=Hi(SmallInt((P[i])+$8000));
end;

procedure Convert8To16(InOutBuf: PAcsBuffer8; InSize: Integer);
var
  i: Integer;
  P: PAcsBuffer16;
begin
  P:=@InOutBuf[0];
  for i:=Insize - 1 downto 0 do P[i]:=(InOutBuf[i] shl 8) - $8000;
end;

procedure ConvertStereoToMono16(InOutBuf: PAcsBuffer16; InSize: Integer);
var
  i: Integer;
begin
  for i:=0 to (Insize shr 2) - 1 do
  begin
    InOutBuf[i]:=(InOutBuf[i shl 1] + InOutBuf[(i shl 1)+1]) div 2;
  end;
end;


procedure ConvertMonoToStereo16(InOutBuf: PAcsBuffer16; InSize: Integer; Mode: TAcsMSConverterMode);
var
  i: Integer;
begin
  case Mode of
    msmMonoToBoth:
    for i:=(Insize shr 1) - 1 downto 0 do
    begin
      InOutBuf[i shl 1]:=InOutBuf[i];
      InOutBuf[(i shl 1)+1]:=InOutBuf[i];
    end;
    msmMonoToLeft:
    for i:=(Insize shr 1) - 1 downto 0 do
    begin
      InOutBuf[i shl 1]:=0;
      InOutBuf[(i shl 1)+1]:=InOutBuf[i];
    end;
    msmMonoToRight:
    for i:=(Insize shr 1) - 1 downto 0 do
    begin
      InOutBuf[i shl 1]:=InOutBuf[i];
      InOutBuf[(i shl 1)+1]:=0;
    end;
  end;
end;

function GCD(a, b: Integer): Integer;
var
  p, q, r: Integer;
begin
  p:=a;
  q:=b;
  r:=p mod q;
  while r <> 0 do
  begin
    p:=q;
    q:=r;
    r:=p mod q;
  end;
  Result:=q;
end;

constructor TAcsRateConverter.Create;
begin
  inherited Create(AOwner);
  FOutSampleRate:=22050;
  FKernelWidth:=30;
  FFilterWindow:=fwBlackman;
end;

destructor TAcsRateConverter.Destroy;
begin
  FKernel:=nil;
  DAS:=nil;
  DAM:=nil;
  inherited Destroy;
end;

function TAcsRateConverter.GetBPS: Integer;
begin
  Result:=16;
end;

function TAcsRateConverter.GetSR: Integer;
begin
  Result:=FOutSampleRate;
end;

procedure TAcsRateConverter.Init();
var
  Ratio: Single;
  TailSize: Integer;
begin
  inherited Init();
  EndOfInput:=False;
  Ratio:=FOutSampleRate/Finput.SampleRate;
  if Ratio > 1. then
  WantedSize:=(Trunc(BUF_SIZE/Ratio) shr 2) * 4
  else WantedSize:=BUF_SIZE;
  if Finput.Channels = 1  then
  begin
    GetMem(InBufM, WantedSize);
    GetMem(OutBufM, BUF_SIZE);
    if Ratio < 1. then
    TailSize:=(KernelWidth-1)*2
    else
    begin
      SetLength(DAM, (BUF_SIZE div 2)+KernelWidth);
      TailSize:=(KernelWidth-1)*8;
    end;
    FillChar(DAM[0], Length(DAM)*Sizeof(DAM[0]), 0);
  end else
  begin
    GetMem(InBufS, WantedSize);
    GetMem(OutBufS, BUF_SIZE);
    if Ratio < 1. then
    TailSize:=(KernelWidth-1)*4
    else
    begin
      SetLength(DAS, (BUF_SIZE div 4)+KernelWidth);
      TailSize:=(KernelWidth-1)*16;
    end;
  end;
  GetMem(Tail, TailSize);
  FillChar(Tail^, TailSize, 0);
  {FSize:=Round(FInput.Size*Ratio);  }
  remainder:=-1;
  if Ratio > 1. then Ratio:=1/Ratio;
  Ratio:=Ratio*0.4;
  CalculateSincKernel(FKernel, Ratio, FKernelWidth, FFilterWindow);
end;

procedure TAcsRateConverter.Done();
begin
  FreeMem(Tail);
  if Finput.Channels = 1  then
  begin
    FreeMem(InBufM);
    FreeMem(OutBufM);
  end else
  begin
    FreeMem(InBufS);
    FreeMem(OutBufS);
  end;
  inherited Done();
end;

function TAcsRateConverter.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  l: Integer;
  InSize: Integer;
  P: PAcsBuffer8;
begin
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  if BufStart > BufEnd then
  begin
    if EndOfInput then
    begin
      Result:=0;
      Exit;
    end;
    BufStart:=1;
    if FInput.Channels = 1 then P:=Pointer(InBufM)
    else P:=Pointer(InBufS);
    while InputLock do;
    InputLock:=True;
    l:=Finput.GetData(@P[0], WantedSize);
    InputLock:=False;
    if l = 0 then
    begin
      Result:=0;
      Exit;
    end;
    InSize:=l;
    while (l<>0) and (InSize < WantedSize) do
    begin
      while InputLock do;
      InputLock:=True;
      l:=Finput.GetData(@P[InSize], WantedSize - InSize);
      InputLock:=False;
      Inc(InSize, l);
    end;
    if l = 0 then
    begin
      EndOfInput:=True;
      if InSize < FKernelWidth*2 then
      begin // stop ABuffer corruption?
        Result:=0;
        Exit;
      end;
    end;
    if Self.Channels = 1 then
    begin
      BufEnd:=ConvertFreqs16Mono(InSize);
    end else
    begin
      BufEnd:=ConvertFreqs16Stereo(InSize);
    end;
  end;
  if ABufferSize < (BufEnd - BufStart + 1)
  then Result:=ABufferSize
  else Result:=BufEnd - BufStart + 1;
  if FInput.Channels = 1 then P:=Pointer(OutBufM)
  else P:=Pointer(OutBufS);
  Move(P[BufStart-1], ABuffer^, Result);
  Inc(BufStart, Result);
  //FPosition:=Round(FInput.Position*(FSize/FInput.Size));
  Inc(FPosition, Result);
end;

constructor TAcsMSConverter.Create;
begin
  inherited Create(AOwner);
end;

destructor TAcsMSConverter.Destroy;
begin
  inherited Destroy;
end;

function TAcsMSConverter.GetBPS: Integer;
begin
  Result:=16;
end;

function TAcsMSConverter.GetCh: Integer;
begin
  if not Assigned(FInput) then
  raise EAcsException.Create(strInputnotAssigned);
  if FInput.Channels = 1 then Result:=2
  else Result:=1;
end;

procedure TAcsMSConverter.Init();
begin
  inherited Init();
  EndOfInput:=False;
  if FInput.Channels = 2 then
    WantedSize:=BUF_SIZE
  else
    WantedSize:=BUF_SIZE shr 1;
  {if FInput.Channels = 2 then
  FSize:=FInput.Size shr 1
  else FSize:=FInput.Size shl 1;  }
end;

function TAcsMSConverter.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  l: Integer;
  InSize: Integer;
begin
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  if BufStart > BufEnd then
  begin
    if EndOfInput then
    begin
      Result:=0;
      Exit;
    end;
    BufStart:=1;
    while InputLock do;
    InputLock:=True;
    l:=Finput.GetData(@InOutBuf[1], WantedSize);
    InputLock:=False;
    if l = 0 then
    begin
      Result:=0;
      Exit;
    end;
    InSize:=l;
    while (l<>0) and (InSize < WantedSize) do
    begin
      while InputLock do;
      InputLock:=True;
      l:=Finput.GetData(@InOutBuf[InSize+1], WantedSize - InSize);
      InputLock:=False;
      Inc(InSize, l);
    end;
    if l = 0 then EndOfInput:=True;
    if FInput.Channels = 2 then
    begin
      ConvertStereoToMono16(@InOutBuf[1], InSize);
      BufEnd:=InSize shr 1;
    end else
    begin
      ConvertMonoToStereo16(@InOutBuf[1], InSize, FMode);
      BufEnd:=InSize shl 1;
    end;
  end;
  if ABufferSize < (BufEnd - BufStart + 1)
  then Result:=ABufferSize
  else Result:=BufEnd - BufStart + 1;
  Move(InOutBuf[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
//    FPosition:=Round(FInput.Position*(FSize/FInput.Size));
  Inc(FPosition, Result);
end;

constructor TAcsSampleConverter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAcsSampleConverter.Destroy();
begin
  inherited Destroy;
end;

function TAcsSampleConverter.GetBPS(): Integer;
begin
  if not Assigned(FInput) then
    raise EAcsException.Create(strInputnotAssigned);
  if FInput.BitsPerSample = 16 then Result:=8
  else Result:=16;
end;

procedure TAcsSampleConverter.Init();
begin
  inherited Init();
  EndOfInput:=False;
  if FInput.BitsPerSample = 16 then
    WantedSize:=BUF_SIZE
  else
    WantedSize:=BUF_SIZE shr 1;
  {if FInput.BitsPerSample = 16 then
  FSize:=FInput.Size shr 1
  else FSize:=FInput.Size shl 1;  }
end;

function TAcsSampleConverter.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  l: Integer;
  InSize: Integer;
begin
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  if BufStart > BufEnd then
  begin
    if EndOfInput then
    begin
      Result:=0;
      Exit;
    end;
    BufStart:=1;
    while InputLock do;
    InputLock:=True;
    l:=FInput.GetData(@InOutBuf[1], WantedSize);
    InputLock:=False;
    if l = 0 then
    begin
      Result:=0;
      Exit;
    end;
    InSize:=l;
    while (l<>0) and (InSize < WantedSize) do
    begin
      while InputLock do;
      InputLock:=True;
      l:=Finput.GetData(@InOutBuf[InSize+1], WantedSize - InSize);
      InputLock:=False;
      Inc(InSize, l);
    end;
    if l = 0 then EndOfInput:=True;
    if FInput.BitsPerSample = 16 then
    begin
      Convert16To8(@InOutBuf[1], InSize);
      BufEnd:=InSize div 2;
    end else
    begin
      Convert8To16(@InOutBuf[1], InSize);
      BufEnd:=InSize div 2;
    end;
  end;
  if ABufferSize < (BufEnd - BufStart + 1) then
    Result:=ABufferSize
  else
    Result:=BufEnd - BufStart + 1;
  Move(InOutBuf[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  //FPosition:=Round(FInput.Position*(FSize/FInput.Size));
  Inc(FPosition, Result);
end;

procedure TAcsRateConverter.SetOutSampleRate(aSR: Integer);
begin
  if (aSR > 0) {and (not Active)} then FOutSampleRate:=aSR;
end;

procedure TAcsRateConverter.SetKernelWidth;
begin
  if (aKW > 1) and (not Active) then FKernelWidth:=aKW;
end;

constructor TAcsStereoBalance.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBalance:=0.5;
end;

destructor TAcsStereoBalance.Destroy();
begin
  inherited Destroy();
end;

procedure TAcsStereoBalance.SetBalance(AValue: Single);
begin
  if (AValue >= 0) and (AValue <=1) then FBalance:=AValue;
end;

function TAcsStereoBalance.GetCh(): Integer;
begin
  if not Assigned(FInput) then
  raise EAcsException.Create(strInputnotAssigned);
  Result:=2;
end;

procedure TAcsStereoBalance.Init();
begin
  inherited Init();
  {if FInput.Channels = 2 then
    FSize:=FInput.Size
  else
    FSize:=FInput.Size*2;  }
end;

function TAcsStereoBalance.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  WantedSize, i: Integer;
  P16: PAcsBuffer16;
  P8: PAcsBuffer8;
  Diff: Double;
begin
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  while InputLock do;
  InputLock:=True;
  if FInput.Channels = 2 then WantedSize:=ABufferSize
  else WantedSize:=ABufferSize shr 1;
  Result:=Finput.GetData(ABuffer, WantedSize);
  InputLock:=False;
  if Result = 0 then Exit;
  if FInput.Channels = 1 then
  begin
    if FInput.BitsPerSample = 8 then
    begin
      P8:=ABuffer;
      for i:=Result*2-1 downto 1 do P8[i]:=P8[i shr 1];
    end else
    begin
      P16:=ABuffer;
      for i:=Result-1 downto 1 do
      P16[i]:=P16[i shr 1];
    end;
    Result:=Result*2;
  end;
  if FInput.BitsPerSample = 8 then
  begin
    P8:=ABuffer;
    if FBalance > 0.5 then
    begin
      Diff:=1-Balance;
      for i:=0 to (Result shr 1) -1 do
      P8[i*2]:=Round(P8[i*2]*Diff);
    end else
    begin
      for i:=0 to (Result shr 1) -1 do
      P8[i*2+1]:=Round(P8[i*2+1]*FBalance);
    end;
  end else
  begin
    P16:=ABuffer;
    if FBalance > 0.5 then
    begin
      Diff:=1-Balance;
      for i:=0 to (Result shr 2) -1 do
      P16[i*2]:=Round(P16[i*2]*Diff);
    end else
    begin
      for i:=0 to (Result shr 2) -1 do
      P16[i*2+1]:=Round(P16[i*2+1]*FBalance);
    end;
  end;
  FPosition:=FInput.Position;
end;

end.
