(*
  this file is a part of audio components suite v 2.3.
  copyright (c) 2002-2005 andrei borovsky. all rights reserved.
  see the license file for more details.
  you can contact me at mail@z0m3ie.de
*)
{
Status: tested
}
{$define FFTREAL_}
unit acs_indicator;

interface

uses
  SysUtils, Classes, ACS_Types, ACS_Classes, ACS_Procs, ACS_Strings
{$ifdef FFTREAL}
  ,FFTReal
{$endif}   ;

type

  { TAcsSoundIndicator }

  TAcsSoundIndicator = class(TAcsCustomConverter)
  private
    FLocked: boolean;
    FHanningWindow: TAcsArrayOfDouble;
    FValuesCount: integer;
    procedure CalculateSpectrum(var ASamplesArr: TAcsArrayOfDouble; SamplesCount: integer;
      var AValues: array of double);
  protected
    procedure SetValuesCount(AValue: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: integer): integer; override;
    { Get spectrum values (0..1) }
    procedure GetValues(var Values: array of double);
    procedure Init(); override;
    procedure Done(); override;
  published
    { Spectrum slices count }
    property ValuesCount: integer read FValuesCount write SetValuesCount;
  end;

implementation

constructor TAcsSoundIndicator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocked := False;
  FValuesCount := 32;
  FBufferSize := $1000;
  SetLength(FHanningWindow, 0);
end;

destructor TAcsSoundIndicator.Destroy;
begin
  inherited Destroy;
end;

{$ifdef FFTREAL}
procedure TAcsSoundIndicator.CalculateSpectrum(PSampleWindow: Pointer;
  SamplesCount: integer; var AValues: array of double);
var
  pSample: PAcsDoubleArray;
  pFFTResult: pflt_array;
  i, ii, n, FreqCount: integer;
  k, sum: double;
  fftr: TFFTReal;
begin
  if Length(AValues) <> ValuesCount then
  begin
    Exit;
  end;

  pSample := PSampleWindow;
  pFFTResult := GetMem(SamplesCount * SizeOf(flt_t));

  fftr := TFFTReal.Create(SamplesCount);

  fftr.do_fft(pFFTResult, pflt_array(pSample));
  // pFFTResult[0..length(x)/2] = real values
  // pFFTResult[length(x)/2+1..length(x)-1] = imaginary values of coefficents 1..length(x)/2-1.

  FreeAndNil(fftr);

  // Using only real values, first half of result
  FreqCount := SamplesCount div 2;
  // FreqCount to ValueCount ratio
  k := FreqCount / ValuesCount;

  // use first half of result, second half is symmetric
  //SetLength(AValues, SamplesCount);
  {$R-}
  for i := 0 to ValuesCount - 1 do
  begin
    n := Trunc(i * k);
    AValues[i] := pFFTResult[n];
  end;
  {$R+}
  Freemem(pFFTResult);
end;

{$else}
(*
procedure TAcsSoundIndicator.CalculateSpectrum(var ASamplesArr: TAcsArrayOfDouble;
  SamplesCount: integer; var AValues: array of double);
var
  FFTResultArr: TAcsArrayOfDouble;
  ComplexArr: TAcsArrayOfComplex;
  i, ii, n, iSamplesCount, iValuesCount: integer;
  sum, c: double;
begin
  if Length(AValues) <> ValuesCount then
  begin
    Exit;
  end;

  { TODO : Save window between calls }
  // Hann window elements count must be equal to sample elements count
  if Length(FHanningWindow) <> SamplesCount then
    FillHanningWindow(FHanningWindow, SamplesCount);

  // apply Hann window to samples
  MultDoubleArrays(ASamplesArr, FHanningWindow, SamplesCount);

  // create ComplexArr
  SetLength(ComplexArr, SamplesCount);

  // fill FFT samples
  for i := 0 to SamplesCount - 1 do
  begin
    ComplexArr[i].Re := ASamplesArr[i];
    ComplexArr[i].Im := 0;
  end;

  // apply FFT
  ComplexFFT(ComplexArr, 1);

  // compute amplitude
  //LgAmplitude(ComplexArr, FFTResultArr, SamplesCount, 0);

  SetLength(FFTResultArr, SamplesCount);
  // compute magnitude
  for i := 0 to SamplesCount - 1 do
  begin
    FFTResultArr[i] := Magnitude(ComplexArr[i]);
  end;

  // use first half of result, second half is symmetric
  //SetLength(AValues, SamplesCount);

  iSamplesCount := Length(FFTResultArr);
  iValuesCount := Length(AValues);
  if (iSamplesCount > 0) and (iValuesCount > 0) then
  begin
    c := (iSamplesCount / 2) / iValuesCount; // coefficient ValuesCount -> SamplesCount/2
    n := Trunc(c);
    if n = 0 then
      n := 1;
    for i := 0 to ValuesCount - 1 do
    begin
      sum := 0;
      for ii := 0 to n - 1 do
      begin
        sum := sum + FFTResultArr[i * n + ii];
      end;
      AValues[i] := sum / n;
    end;
  end;
end;
*)

procedure TAcsSoundIndicator.CalculateSpectrum(var ASamplesArr: TAcsArrayOfDouble;
  SamplesCount: integer; var AValues: array of double);
var
  FFTArr: TAcsArrayOfDouble;
  FFTResultArr: TAcsArrayOfDouble;
  i, ii, n, iSamplesCount, iValuesCount: integer;
  sum, c, MaxValue, MinValue: double;
begin
  iValuesCount := Length(AValues);
  if iValuesCount <> ValuesCount then
  begin
    Exit;
  end;

  { TODO : Save window between calls }
  // Hann window elements count must be equal to sample elements count
  if Length(FHanningWindow) <> SamplesCount then
    Windowing(FHanningWindow, SamplesCount-1, wf_Hamming);

  // apply Hann window to samples
  MultDoubleArrays(ASamplesArr, FHanningWindow, SamplesCount);

  // create FFTArr
  SetLength(FFTArr, SamplesCount * 2);

  // fill FFT samples
  for i := 0 to SamplesCount - 1 do
  begin
    FFTArr[i]   := ASamplesArr[i];
    FFTArr[i+1] := 0;
  end;

  // apply FFT
  FFT(FFTArr, SamplesCount div 2, True);

  // compute amplitude
  //LgAmplitude(ComplexArr, FFTResultArr, SamplesCount, 0);

  SetLength(FFTResultArr, SamplesCount);

  // normalize
  {MaxValue := 0;
  MinValue := 99999999; }
  for i := 0 to SamplesCount - 1 do
  begin
    //Magnitude(ComplexArr[i]);
    //FFTResultArr[i] := Amplitude(FFTArr[i], FFTArr[i+1]) / 10;
    FFTResultArr[i] := (ln(Magnitude(FFTArr[i], FFTArr[i+1])) - 7.5) * 0.1;
    {if MaxValue < FFTResultArr[i] then
      MaxValue := FFTResultArr[i];
    if MinValue > FFTResultArr[i] then
      MinValue := FFTResultArr[i]; }
    if FFTResultArr[i] < 0 then
      FFTResultArr[i] := 0;
    if FFTResultArr[i] > 1 then
      FFTResultArr[i] := 1;
  end;

  iSamplesCount := Length(FFTResultArr) div 2;
  SetLength(FFTResultArr, iSamplesCount);

  // use first half of result, second half is symmetric
  if (iSamplesCount > 0) and (iValuesCount > 0) then
  begin
    c := (iSamplesCount-1) / iValuesCount; // coefficient ValuesCount -> SamplesCount/2
    n := Trunc(c);
    if n = 0 then
      n := 1;
    for i := 0 to iValuesCount - 1 do
    begin
      sum := 0;
      if i < iSamplesCount then
      begin
        for ii := 0 to n - 1 do
        begin
          sum := sum + FFTResultArr[i * n + ii];
        end;
      end;
      AValues[i] := sum / n;
    end;
  end;

end;

{$endif}

procedure TAcsSoundIndicator.SetValuesCount(AValue: integer);
begin
  FValuesCount := AValue;
end;

procedure TAcsSoundIndicator.Init();
begin
  inherited Init();
  //FillChar(FValues[0], SizeOf(Double)*32, 0);
  FLocked := False;
end;

procedure TAcsSoundIndicator.Done();
begin
  inherited Done();
  //FillChar(FValues[0], SizeOf(Double)*32, 0);
  FLocked := False;
end;

function TAcsSoundIndicator.GetData(ABuffer: Pointer; ABufferSize: integer): integer;
var
  n: integer;
begin
  if not Active then
  begin
    raise EAcsException.Create(strStreamnotopen);
  end;

  // copy input ABuffer to param ABuffer
  while InputLock do
  begin
    Sleep(1);
  end;
  InputLock := True;
  Result := FInput.GetData(ABuffer, ABufferSize);
  FPosition := FInput.Position;
  InputLock := False;

  // copy param ABuffer to local ABuffer
  while FLocked do
  begin
    Sleep(1);
  end;
  FLocked := True;
  {
  if Length(FBuffer)<>Result then SetLength(FBuffer, Result);
  if Result > 0 then Move(ABuffer^, FBuffer[0], Result);
  }
  n := Result;
  if n > FAudioBuffer.Size then
  begin
    n := FAudioBuffer.Size;
  end;
  FAudioBuffer.Reset();
  FAudioBuffer.Write(ABuffer^, n);
  FLocked := False;
end;

procedure TAcsSoundIndicator.GetValues(var Values: array of double);
var
  i, NumSamples: integer;
  SamplesArr: TAcsArrayOfDouble;
  P: Pointer;
begin
  if Length(Values) <> ValuesCount then
  begin
    Exit;
  end;
  //SetLength(Values, ValuesCount);
  //if BufferSize=0 then
  //FillChar(Values[0], SizeOf(double) * Length(Values), 0);
  if not Assigned(FAudioBuffer) or (FAudioBuffer.WritePosition = 0) then
  begin
    Exit;
  end;

  if (FInput.Channels = 0) or (FInput.BitsPerSample = 0) then
  begin
    Exit;
  end;
  NumSamples := FAudioBuffer.WritePosition div (FInput.Channels *
    (FInput.BitsPerSample div 8));

  while FLocked do
  begin
    Sleep(1);
  end;
  FLocked := True;

  SetLength(SamplesArr, NumSamples);
  // convert raw sample to mono sample array with values -32768..32768
  {$R-}
  P := FAudioBuffer.Memory;
  if FInput.BitsPerSample = 8 then
  begin
    if FInput.Channels = 1 then
    begin
      for i := 0 to NumSamples - 1 do
      begin
        SamplesArr[i] := PAcsBuffer8(P)[i] * 256;
      end;
    end
    else
    begin
      for i := 0 to NumSamples - 1 do
      begin
        SamplesArr[i] := (PAcsStereoBuffer8(P)[i].Left + PAcsStereoBuffer8(P)[i].Right) / 2 * 256;
      end;
    end;
  end
  else
  begin
    if FInput.Channels = 1 then
    begin
      for i := 0 to NumSamples - 1 do
      begin
        SamplesArr[i] := PAcsBuffer16(P)[i] + 32767;
      end;
    end
    else
    begin
      for i := 0 to NumSamples - 1 do
      begin
        SamplesArr[i] := (PAcsStereoBuffer16(P)[i].Left + PAcsStereoBuffer16(P)[i].Right) / 2 + 32767;
      end;
    end;
  end;
  {$R+}

  CalculateSpectrum(SamplesArr, NumSamples, Values);
  {
  for i := 0 to ValuesCount - 1 do
  begin
    Values[i] := Values[i] * 0.4;
  end; //ValCount;   }
  FLocked := False;
end;

end.
