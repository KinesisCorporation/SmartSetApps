(*
Audio filters

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)


unit acs_filters;

interface

uses
  Classes, SysUtils, ACS_Types, ACS_Procs, ACS_Classes, ACS_Strings, Math;

const
  BUF_SIZE = $4000;

type

  TAcsFilterType = (ftBandPass, ftBandReject, ftHighPass, ftLowPass, ftAllPass);

  { TAcsBWFilter - implementation of a simple Butterworth filter.
  This component takes in an audio stream, performs band-pass/band-reject
  operations on it and passes the resulting stream to some other component.
  Note that TAcsBWFilter operates on 16-bit streams only. }
  TAcsBWFilter = class(TAcsCustomConverter)
  private
    a3: array[0..2] of Double;
    b2: array[0..1] of Double;
    x0, x1, y0, y1: array[0..1] of Double;
    FLowFreq, FHighFreq: Integer;
    FAmplification: Word;
    FFilterType: TAcsFilterType;
    InBuf: array[1..BUF_SIZE] of Byte;
    procedure SetHighFreq(aFreq: Integer);
    procedure SetLowFreq(aFreq: Integer);
    procedure SetAmplification(Ampl: Word);
  protected
    function GetBPS: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
  published
    { Sometimes a filter output signal is just too weak. 1-same level, 2-double, etc.. }
    property Amplification: Word read FAmplification write SetAmplification;
    { Use this property to select the Butterworth filter type. The possible values are:
      ftBandPass - Band-pass filter. HighFreq and LowFreq define the band to be passed.
      ftBandReject - Band-reject filter. HighFreq and LowFreq define the band to be rejected.
      ftHighPass - High-pass filter. HighFreq defines the cut-out frequency.
      ftLowPass - Low-pass filter. LowFreq defines the cut-out frequency. }
    property FilterType: TAcsFilterType read FFilterType write FFilterType;
    { Defines the higher filter frequency. See the FilterType property. }
    property HighFreq: Integer read FHighFreq write SetHighFreq;
    { Defines the lower filter frequency. See the FilterType property. }
    property LowFreq: Integer read FLowFreq write SetLowFreq;
  end;

  { TAcsSincFilter - variety of filters based on a sinc kernel. This component
  takes in an audio stream, performs one of the filtering operations on it and
  passes the resulting stream to the next component in the audio-processing
  chain. Note that this component operates on 16-bit streams only.

  You can modify properties while the filter is operating. In this case
  the filter's kernel will be recalculated dynamically.}
  TAcsSincFilter = class(TAcsCustomConverter)
  private
    Lock: Boolean;
    Kernel: array of Double;
    DA: TAcsArrayOfDouble;
    DAS: PAcsStereoBufferD;
    inBuf: array[1..BUF_SIZE] of Byte;
    FFilterType: TAcsFilterType;
    FKernelWidth: Integer;
    FLowFreq, FHighFreq: Integer;
    FWindowType: TAcsFilterWindowType;
    procedure SetFilterType(AFT: TAcsFilterType);
    procedure SetKernelWidth(AKW: Integer);
    procedure SetWindowType(AWT: TAcsFilterWindowType);
    procedure SetHighFreq(AFreq: Integer);
    procedure SetLowFreq(AFreq: Integer);
    procedure CalculateFilter();
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    procedure GetKernel(var K: TAcsArrayOfDouble);
  published
    { Use this property to select the filter type. The possible values are:
      ftBandPass - Band-pass filter. HighFreq and LowFreq define the band to be passed.
      ftBandReject - Band-reject filter. HighFreq and LowFreq define the band to be rejected.
      ftHighPass - High-pass filter. HighFreq defines the cut-off frequency.
      ftLowPass - Low-pass filter. LowFreq defines the cut-off frequency.
      ftAllPass - All-pass filter. HighFreq and LowFreq are ignored. }
    property FilterType: TAcsFilterType read FFilterType write SetFilterType;
    { Defines the higher filter frequency. See the FilterType property. }
    property HighFreq: Integer read FHighFreq write SetHighFreq;
    { Use this property to set the number of the kernel points for the filter.
      Note, that for many filter operations to work correctly, this value must
      be odd. If this value is set to an even number and the filter operation
      requires it to be odd, it will be changed to odd by the component. }
    property KernelWidth: Integer read FKernelWidth write SetKernelWidth;
    { Defines the lower filter frequency. See the FilterType property. }
    property LowFreq: Integer read FLowFreq write SetLowFreq;
    { Use this property to set the type of the window applied to the kernel.
      The possible values are wtBlackman, wtHamming, and wtHann. }
    property WindowType : TAcsFilterWindowType read FWindowType write SetWindowType;
  end;


  { TAcsConvolver component performs convolution in time domain.
    It takes in an audio stream and convolves it with the convolution kernel
    you provide. Note that this component operates on 16-bit streams only. }
  TAcsConvolver = class(TAcsCustomConverter)
  private
    Lock: Boolean;
    Kernel: array of Double;
    DA: TAcsArrayOfDouble;
    DAS: PAcsStereoBufferD;
    inBuf: array[1..BUF_SIZE] of Byte;
    FKernelWidth: Integer;
    FAllPass: Boolean;
    procedure SetKernelWidth(AValue: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    { Use this procedure to set the convolution kernel for the convolver.
      K is array of kernel points (the number of points is assumed to be equal
      to the value of KernelWidth property. Inverted parameter allows you to tell
      the procedure if the kernel is inverted or not. You may call this procedure
      on the fly, to change the current convolution kernel, but note, that you
      cannot change KernelWidth value on the fly. }
    procedure SetKernel(const K: TAcsArrayOfDouble; Inverted: Boolean);
    { Use this property to set the number of the kernel points for the convolution kernel.
      This property should be set before the convolver starts its playback and
      after it is set SetKernel function must be called. }
    property KrenelWidth: Integer read FKernelWidth write SetKernelWidth;
  published
    { If this property is set to True the convolution kernel is not applied to
      the data passing through the convolver. You may change the value of this
      property on the fly, turning on and off the convolution effect. }
    property AllPass: Boolean read FAllPass write FAllPass;
  end;

implementation

{ TAcsBWFilter }

constructor TAcsBWFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFilterType:=ftBandPass;
  FAmplification:=1;
end;

destructor TAcsBWFilter.Destroy();
begin
  inherited Destroy();
end;

function TAcsBWFilter.GetBPS(): Integer;
begin
  Result:=16;
end;

procedure TAcsBWFilter.SetHighFreq(AFreq: Integer);
begin
  if FFilterType = ftLowPass then
    FHighFreq:=0
  else
    FHighFreq:=AFreq;
end;

procedure TAcsBWFilter.SetLowFreq(AFreq: Integer);
begin
  if FFilterType = ftHighPass then
    FLowFreq:=0
  else
    FLowFreq:=AFreq;
end;

procedure TAcsBWFilter.SetAmplification(Ampl: Word);
begin
  if Ampl > 0 then FAmplification:=Ampl;
end;

procedure TAcsBWFilter.Init();
var
  C, D: Double;
  InputSampleRate: Integer;
begin
  inherited Init();
  InputSampleRate:=FInput.SampleRate;
  if ((FHighFreq - FlowFreq) < 0) or (((FHighFreq - FlowFreq) * 2) >= InputSampleRate) then
  begin
    Done();
    raise EAcsException.Create(strIllegalFrequency);
  end;
  x0[0]:=0.0;
  x0[1]:=0.0;
  x1[0]:=0.0;
  x1[1]:=0.0;
  y0[0]:=0.0;
  y0[1]:=0.0;
  y1[0]:=0.0;
  y1[1]:=0.0;
  case FFilterType of
    ftBandPass:
    begin
      C:=1 / Tan(Pi * (FHighFreq-FLowFreq+1) / InputSampleRate);
      D:=2 * Cos(2 * Pi * ((FHighFreq+FLowFreq) shr 1) / InputSampleRate);
      a3[0]:=1 / (1 + C);
      a3[1]:=0.0;
      a3[2]:=-a3[0];
      b2[0]:=-C * D * a3[0];
      b2[1]:=(C - 1) * a3[0];
    end;

    ftBandReject:  // This doesn't seem to work well
    begin
      C:=Tan(Pi * (FHighFreq-FLowFreq+1) / InputSampleRate);
      D:=2 * Cos(2 * Pi * ((FHighFreq+FLowFreq) shr 1) / InputSampleRate);
      a3[0]:=1 / (1 + C);
      a3[1]:=-D * a3[0];
      a3[2]:=a3[0];
      b2[0]:=a3[1];
      b2[1]:=(1 - C) * a3[0];
    end;

    ftLowPass:
    begin
      C:=1 / Tan(Pi * FLowFreq / InputSampleRate);
      a3[0]:=1 / (1 + Sqrt(2) * C + C * C);
      a3[1]:=2 * a3[0];
      a3[2]:=a3[0];
      b2[0]:=2 * (1 - C * C) * a3[0];
      b2[1]:=(1 - Sqrt(2) * C + C * C) * a3[0];
    end;

    ftHighPass:
    begin
      C:=Tan(Pi * FHighFreq / InputSampleRate);
      a3[0]:=1 / (1 + Sqrt(2) * C + C * C);
      a3[1]:=-2 * a3[0];
      a3[2]:=a3[0];
      b2[0]:=2 * (C * C - 1) * a3[0];
      b2[1]:=(1 - Sqrt(2) * C + C * C) * a3[0];
    end;
  end;
end;

function TAcsBWFilter.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  i: Integer;
  InBufMono: PAcsBuffer16;
  InBufStereo: PAcsStereoBuffer16;
  arg, res: Double;
begin
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  if BufStart > BufEnd then
  begin
    BufStart:=1;
    BufEnd:=FInput.GetData(@InBuf[1], BUF_SIZE);
    if BufEnd = 0 then
    begin
      Result:=0;
      Exit;
    end;
    if Self.Channels = 1 then
    begin
      InBufMono:=@InBuf[1];
      for i:=0 to (BufEnd shr 1) - 1 do
      begin
        arg:=InBufMono[i];
        res:=a3[0] * arg + a3[1] * x0[0] + a3[2] * x1[0] -
               b2[0] * y0[0] - b2[1] * y1[0];
        InBufMono[i]:=Round(res);
        x1[0]:=x0[0];
        x0[0]:=arg;
        y1[0]:=y0[0];
        y0[0]:=res;
        InBufMono[i]:=FAmplification * InBufMono[i];
      end;
    end else
    begin
      InBufStereo:=@InBuf[1];
      for i:=0 to (BufEnd shr 2) - 1 do
      begin
        arg:=InBufStereo[i].Left;
        res:=a3[0] * arg + a3[1] * x0[0] + a3[2] * x1[0] -
               b2[0] * y0[0] - b2[1] * y1[0];
        InBufStereo[i].Left:=Round(res);
        x1[0]:=x0[0];
        x0[0]:=arg;
        y1[0]:=y0[0];
        y0[0]:=res;
        arg:=InBufStereo[i].Right;
        res:=a3[0] * arg + a3[1] * x0[1] + a3[2] * x1[1] -
               b2[0] * y0[1] - b2[1] * y1[1];
        InBufStereo[i].Right:=Round(res);
        x1[1]:=x0[1];
        x0[1]:=arg;
        y1[1]:=y0[1];
        y0[1]:=res;
        InBufStereo[i].Right:=FAmplification * InBufStereo[i].Right;
        InBufStereo[i].Left:=FAmplification * InBufStereo[i].Left;
      end;
    end;
  end;
  if ABufferSize < (BufEnd - BufStart + 1) then
    Result:=ABufferSize
  else
    Result:=BufEnd - BufStart + 1;
  Move(InBuf[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  //FPosition:=Round(FInput.Position*(FSize/FInput.Size));
  Inc(FPosition, Result);
end;

{ TAcsSincFilter }

constructor TAcsSincFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKernelWidth:=31;
  FWindowType:=fwBlackman;
  FLowFreq:=8000;
  FHighFreq:=16000;
  DA:=nil;
  DAS:=nil;
end;

destructor TAcsSincFilter.Destroy();
begin
  Kernel:=nil;
  if DA <> nil then FreeMem(DA);
  if DAS <> nil then FreeMem(DAS);
  Inherited Destroy;
end;

procedure TAcsSincFilter.CalculateFilter();
var
  Kernel1, Kernel2: array of Double;
  CutOff: Double;
  i, j: Integer;
  InputSampleRate: Integer;
begin
  if csDesigning in ComponentState then Exit;
  if not Assigned(FInput) then Exit;
  InputSampleRate:=FInput.SampleRate;
  if (FLowFreq > InputSampleRate/2) or (FHighFreq > InputSampleRate/2) then
    raise EAcsException.Create(strCutofftolow);

  while Lock do Sleep(1);
  Lock:=True;
  case FilterType of
    ftLowPass:
    begin
      SetLength(Kernel, FKernelWidth);
      CutOff:=FLowFreq / InputSampleRate;
      CalculateSincKernel(Kernel, CutOff, FKernelWidth, FWindowType);
    end;

    ftHighPass:
    begin
      if not Odd(FKernelWidth) then Inc(FKernelWidth);
      SetLength(Kernel, FKernelWidth);
      CutOff:=FHighFreq/InputSampleRate;
      CalculateSincKernel(Kernel, CutOff, FKernelWidth, FWindowType);
      for i:=0 to FKernelWidth - 1 do
        Kernel[i]:=-Kernel[i];
      Kernel[(FKernelWidth div 2)]:=Kernel[(FKernelWidth div 2)] + 1;
    end;

    ftBandPass:
    begin
      if not Odd(FKernelWidth) then Inc(FKernelWidth);
      SetLength(Kernel1, FKernelWidth);
      CutOff:=FLowFreq/InputSampleRate;
      CalculateSincKernel(Kernel1, CutOff, FKernelWidth, FWindowType);
      for i:=0 to FKernelWidth - 1 do
        Kernel1[i]:=-Kernel1[i];
      Kernel1[(FKernelWidth div 2)]:=Kernel1[(FKernelWidth div 2)] + 1;
      SetLength(Kernel2, FKernelWidth);
      CutOff:=FHighFreq/InputSampleRate;
      CalculateSincKernel(Kernel2, CutOff, FKernelWidth, FWindowType);
      SetLength(Kernel, 2*FKernelWidth);
      FillChar(Kernel[0], Length(Kernel)*SizeOf(Double), 0);
      for i:=0 to KernelWidth - 1 do
        for j:=0 to KernelWidth - 1 do
          Kernel[i+j]:=Kernel[i+j] + Kernel1[i]*Kernel2[j];
      SetLength(Kernel, FKernelWidth);
      Kernel1:=nil;
      Kernel2:=nil;
    end;

    ftBandReject:
    begin
      if not Odd(FKernelWidth) then Inc(FKernelWidth);
      SetLength(Kernel1, FKernelWidth);
      CutOff:=FHighFreq/InputSampleRate;
      CalculateSincKernel(Kernel1, CutOff, FKernelWidth, FWindowType);
      for i:=0 to FKernelWidth - 1 do
        Kernel1[i]:=-Kernel1[i];
      Kernel1[(FKernelWidth div 2)]:=Kernel1[(FKernelWidth div 2)] + 1;
      SetLength(Kernel2, FKernelWidth);
      CutOff:=FLowFreq/InputSampleRate;
      CalculateSincKernel(Kernel2, CutOff, FKernelWidth, FWindowType);
      SetLength(Kernel, FKernelWidth);
      for i:=0 to FKernelWidth - 1 do
        Kernel[i]:=Kernel1[i] + Kernel2[i];
      Kernel1:=nil;
      Kernel2:=nil;
    end;

    ftAllPass:
    begin
      SetLength(Kernel, FKernelWidth);
      FillChar(Kernel[0], Length(Kernel)*SizeOf(Double), 0);
      Kernel[FKernelWidth div 2]:=1;
    end;
  end;
  Lock:=False;
end;

procedure TAcsSincFilter.SetFilterType(AFT: TAcsFilterType);
begin
  FFilterType:=AFT;
  if Active then CalculateFilter();
end;

procedure TAcsSincFilter.SetKernelWidth(AKW: Integer);
begin
  if AKW > 2 then
    if not Active then FKernelWidth:=AKW;
end;

procedure TAcsSincFilter.SetWindowType(AWT: TAcsFilterWindowType);
begin
  FWindowType:=AWT;
  if Active then CalculateFilter();
end;

procedure TAcsSincFilter.SetHighFreq(AFreq: Integer);
begin
  if aFreq > 0 then FHighFreq:=AFreq;
  if csDesigning in ComponentState then Exit;
  if Assigned(FInput) then
    if FHighFreq > FInput.SampleRate div 2 then
      FHighFreq:=FInput.SampleRate div 2;
  if FHighFreq < FLowFreq then
    FLowFreq:=FHighFreq;
  if Active then CalculateFilter();
end;

procedure TAcsSincFilter.SetLowFreq(AFreq: Integer);
begin
  if aFreq > 0 then
    FLowFreq:=AFreq;
  if csDesigning in ComponentState then Exit;
  if Assigned(FInput) then
    if FlowFreq > FInput.SampleRate div 2 then
      FLowFreq:=FInput.SampleRate div 2;
  if FHighFreq < FLowFreq then
    FHighFreq:=FLowFreq;
  if Active then CalculateFilter();
end;

procedure TAcsSincFilter.Init();
var
  BufSize: Integer;
begin
  inherited Init();
  Lock:=False;
  CalculateFilter();
  BufSize:=((BUF_SIZE div 2) + FKernelWidth-1) * SizeOf(Double);
  if FInput.Channels = 1 then
  begin
    GetMem(DA, BufSize);
    FillChar(DA[0], BufSize, 0);
  end else
  begin
    GetMem(DAS, BufSize * 2);
    FillChar(DAS[0], BufSize * 2, 0);
  end;
end;

procedure TAcsSincFilter.Done();
begin
  if DA <> nil then FreeMem(DA);
  if DAS <> nil then FreeMem(DAS);
  DA:=nil;
  DAS:=nil;
  inherited Done();
end;

function TAcsSincFilter.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  i, j, NumSamples: Integer;
  InBufMono: PAcsBuffer16;
  InBufStereo: PAcsStereoBuffer16;
begin
  if not Active then
    raise EAcsException.Create(strStreamnotopen);
  if BufStart > BufEnd then
  begin
    while Lock do Sleep(1);
    Lock:=True;
    BufStart:=1;
    while InputLock do Sleep(1);
    InputLock:=True;
    BufEnd:=FInput.GetData(@InBuf[1], BUF_SIZE);
    InputLock:=False;
    if BufEnd = 0 then
    begin
      Result:=0;
      Exit;
    end;
    if FInput.Channels = 1 then
    begin
      InBufMono:=@InBuf[1];
      NumSamples:=BufEnd div 2;
      for i:=0 to NumSamples-1 do
        for j:=0 to FKernelWidth-1 do
          DA[i+j]:=DA[i+j] + InbufMono[i] * Kernel[j];
      for i:=0 to NumSamples-1 do
        InBufMono[i]:=Round(DA[i]);
      BufEnd:=NumSamples * 2;
      FillChar(DA[0], NumSamples * SizeOf(Double), 0);
      Move(DA[NumSamples], DA[0], (FKernelWidth-1)*SizeOf(Double));
    end
    else
    begin
      InBufStereo:=@InBuf[1];
      NumSamples:=BufEnd div 4;
      for i:=0 to NumSamples-1 do
        for j:=0 to FKernelWidth-1 do
        begin
          DAS[i+j].Left:=DAS[i+j].Left + InbufStereo[i].Left * Kernel[j];
          DAS[i+j].Right:=DAS[i+j].Right + InbufStereo[i].Right * Kernel[j];
        end;
      for i:=0 to NumSamples-1 do
      begin
        InBufStereo[i].Left:=Round(DAS[i].Left);
        InBufStereo[i].Right:=Round(DAS[i].Right);
      end;
      BufEnd:=NumSamples * 4;
      FillChar(DAS[0], NumSamples * 2 * SizeOf(Double), 0);
      for i:=0 to FKernelWidth-2 do
      begin
        DAS[i]:=DAS[NumSamples+i];
        DAS[NumSamples+i].Left:=0;
        DAS[NumSamples+i].Right:=0;
      end;
      //Move(DAS[NumSamples], DAS[0], (FKernelWidth-1)*2*SizeOf(Double));
    end;
    Lock:=False;
  end;
  if ABufferSize < (BufEnd - BufStart + 1) then
    Result:=ABufferSize
  else
    Result:=BufEnd - BufStart + 1;
  Move(InBuf[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  Inc(FPosition, Result);
  //FPosition:=Round(FInput.Position*(FSize/FInput.Size));
end;

procedure TAcsSincFilter.GetKernel(var K: TAcsArrayOfDouble);
begin
  K := Kernel;
end;

{ TAcsConvolver }

constructor TAcsConvolver.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKernelWidth:=31;
  if csDesigning in ComponentState then Exit;
  SetLength(Kernel, FKernelWidth);
  FillChar(Kernel[1], Length(Kernel) * SizeOf(Double), 0);
  DA:=nil;
  DAS:=nil;
end;

destructor TAcsConvolver.Destroy();
begin
  Kernel:=nil;
  if DA <> nil then FreeMem(DA);
  if DAS <> nil then FreeMem(DAS);
  inherited Destroy();
end;

procedure TAcsConvolver.SetKernelWidth(AValue: Integer);
begin
  if AValue > 2 then
    if not Active then FKernelWidth:=AValue;
end;

procedure TAcsConvolver.Init();
var
  BufSize: Integer;
begin
  inherited Init();
  Lock:=False;
  BufSize:=((BUF_SIZE div 2) + FKernelWidth-1) * SizeOf(Double);
  if FInput.Channels = 1 then
  begin
    GetMem(DA, BufSize);
    FillChar(DA[0], BufSize, 0);
  end
  else
  begin
    GetMem(DAS, BufSize * 2);
    FillChar(DAS[0], BufSize * 2, 0);
  end;
end;

procedure TAcsConvolver.Done();
begin
  if DA <> nil then FreeMem(DA);
  if DAS <> nil then FreeMem(DAS);
  DA:=nil;
  DAS:=nil;
  inherited Done();
end;

function TAcsConvolver.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  i, j, NumSamples: Integer;
  InBufMono: PAcsBuffer16;
  InBufStereo: PAcsStereoBuffer16;
begin
  if not Active then  raise EAcsException.Create(strStreamNotopen);
  if BufStart > BufEnd then
  begin
    while Lock do Sleep(1);
    Lock:=True;
    BufStart:=1;
    while InputLock do Sleep(1);
    InputLock:=True;
    BufEnd:=FInput.GetData(@InBuf[1], BUF_SIZE);
    InputLock:=False;
    if BufEnd = 0 then
    begin
      Result:=0;
      Exit;
    end;

    if not FAllPass then
    begin
      if FInput.Channels = 1 then
      begin
        InBufMono:=@InBuf[1];
        NumSamples:=BufEnd div 2;
        for i:=0 to NumSamples-1 do
          for j:=0 to FKernelWidth-1 do
            DA[i+j]:=DA[i+j] + InbufMono[i] * Kernel[j];
        for i:=0 to NumSamples-1 do
          InBufMono[i]:=Round(DA[i]);
        BufEnd:=NumSamples*2;
        FillChar(DA[0], NumSamples * SizeOf(Double), 0);
        Move(DA[NumSamples], DA[0], (FKernelWidth-1) * SizeOf(Double));
      end
      else
      begin
        InBufStereo:=@InBuf[1];
        NumSamples:=BufEnd div 4;
        for i:=0 to NumSamples-1 do
          for j:=0 to FKernelWidth-1 do
          begin
            DAS[i+j].Left:=DAS[i+j].Left + InbufStereo[i].Left * Kernel[j];
            DAS[i+j].Right:=DAS[i+j].Right + InbufStereo[i].Right * Kernel[j];
          end;
        for i:=0 to NumSamples-1 do
        begin
          InBufStereo[i].Left:=Round(DAS[i].Left);
          InBufStereo[i].Right:=Round(DAS[i].Right);
        end;
        BufEnd:=NumSamples * 4;
        FillChar(DAS[0], NumSamples * 2 * SizeOf(Double), 0);
        for i:=0 to FKernelWidth-2 do
        begin
          DAS[i]:=DAS[NumSamples+i];
          DAS[NumSamples+i].Left:=0;
          DAS[NumSamples+i].Right:=0;
        end;
        //Move(DAS[NumSamples], DAS[0], (FKernelWidth-1)*2*SizeOf(Double));
      end;
    end;
    Lock:=False;
  end;
  if ABufferSize < (BufEnd - BufStart + 1) then
    Result:=ABufferSize
  else
    Result:=BufEnd - BufStart + 1;
  Move(InBuf[BufStart], ABuffer^, Result);
  Inc(BufStart, Result);
  Inc(FPosition, Result);
  //FPosition:=Round(FInput.Position*(FSize/FInput.Size));
end;

procedure TAcsConvolver.SetKernel(const K: TAcsArrayOfDouble; Inverted: Boolean);
var
  i: Integer;
begin
  while Lock do Sleep(1);
  Lock:=True;
  if not Inverted then
    for i:=0 to FKernelWidth-1 do
      Kernel[i]:=K[i]
  else
    for i:=0 to FKernelWidth-1 do
      Kernel[i]:=K[FKernelWidth-1-i];
  Lock:=False;
end;


end.
