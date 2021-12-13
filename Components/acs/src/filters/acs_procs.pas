(*
  this file is a part of audio components suite v 2.3.
  copyright (c) 2002-2005 andrei borovsky. all rights reserved.
  see the license file for more details.
  you can contact me at mail@z0m3ie.de
*)

unit acs_procs;

interface

uses
  SysUtils, ACS_Types, Math;

type

  TAcsFilterWindowType = (fwHamming, fwHann, fwBlackman);
  TWindowFunction = (wf_None, wf_Hamming, wf_Blackman, wf_KaiserBessel, wf_FlatTop);

{$IFDEF LINUX}
  function FindLibs(const Pattern: String): String;
{$ENDIF}

{$ifdef CPU386}
  {.$define USE_ASM}
{$endif}

  procedure Windowing(var data: array of double; Taps: integer; WF: TWindowFunction);
  procedure FFT(var data: array of double; nn: integer; invers: boolean);


  // Fast Fourier Transformation for Complex array
  // Direction = 1 - forward FFT, Direction = -1 - inverse FFT.
  procedure ComplexFFT(var Data: TAcsArrayOfComplex; Direction: Integer);

  // The Hann function window
  procedure FillHanningWindow(out OutData: TAcsArrayOfDouble; Width: Integer);

  procedure FillHammingWindow(out OutData: TAcsArrayOfDouble; Width: Integer);

  procedure BlackmanWindow(out OutData: TAcsArrayOfDouble; Width: Integer; Symmetric: Boolean);

  procedure CalculateSincKernel(out OutData: TAcsArrayOfDouble; CutOff: Double; Width: Integer; WType: TAcsFilterWindowType);

  // not used
  procedure SmallIntArrayToDouble(InData: PSmallInt; OutData: PDouble; DataSize: Integer);

  // not used
  procedure SmallIntArrayToComplex(InData: PSmallInt; OutData: PAcsComplex; DataSize: Integer);


  // Computes Data1[i] = Data1[i] * Data2[i], i = [0..DataSize-1]
  procedure MultDoubleArrays(var Data1: TAcsArrayOfDouble; const Data2: TAcsArrayOfDouble; DataSize: Integer);

  // Magnitude = sqrt(Re^2 + Im^2)
  function Magnitude(const Re, Im: Double): Double;
  // Amplitude = Log10(Magnitude)
  function Amplitude(const Re, Im: Double): Double;

  (*
    Amplitude
                   /
                  | Lg(Abs(InData[i])) + Shift, if Lg(Abs(InData[i])) + Shift >= 0
    OutData[i] = <  0, if Lg(Abs(InData[i])) + Shift < 0
                  | 0, if Abs(InData[i]) = 0.
                   \
    i = [0..DataSize-1]
  *)
  procedure LgAmplitude(const InData: TAcsArrayOfComplex; out OutData: TAcsArrayOfDouble; DataSize, Shift: Integer);

implementation

{$IFDEF LINUX}
function FindLibs(const Pattern: String): String;

function FindInPath(sPath: string): string;
var
  SR: TSearchRec;
begin
  Result:='';
  if FindFirst(sPath+Pattern, faAnyFile, SR) = 0 then
  begin
    Result := sPath+SR.Name;
    FindClose(SR);
  end;
end;

begin
  Result:=FindInPath('/usr/lib/');
  if Result = '' then Result:=FindInPath('/usr/lib/i386-linux-gnu/');
  if Result = '' then Result:=FindInPath('/usr/lib/x86_64-linux-gnu/');
  if Result = '' then Result:=FindInPath('/usr/local/lib/');
end;
{$ENDIF}


(* This routine is converted from the original C code by P. Burke
 Direction = 1 - forward FFT, Direction = -1 - inverse FFT. *)
procedure ComplexFFT(var Data: TAcsArrayOfComplex; Direction: Integer);
var
  i, i1, j, m, l, l1, l2, Log2n: Integer;
  c1, c2, tr, ti, t1, t2, u1, u2, z: Double;
  DataSize: Integer;
begin
  DataSize := Length(Data);
  Log2n := Trunc(Log2(DataSize));
  // Do the bit reversal
  j := 1;
  for i:=0 to DataSize-1 do
  begin
    if (j < DataSize) and (i < j) then
    begin
      tr := Data[i].Re;
      ti := Data[i].Im;
      Data[i].Re := Data[j].Re;
      Data[i].Im := Data[j].Im;
      Data[j].Re := tr;
      Data[j].Im := ti;
    end;
    m := DataSize div 2;
    while (m >= 2) and (j > m) do
    begin
      Dec(j, m);
      m := (m div 2);
    end;
    Inc(j, m);
  end;
  // Compute the FFT
  c1 := -1.0;
  c2 := 0.0;
  l2 := 1;
  for l := 0 to Log2n - 1 do
  begin
    l1 := l2;
    l2 := (l2 shl 1);
    u1 := 1.0;
    u2 := 0.0;
    for j:=0 to l1 - 1 do
    begin
      i := j;
      while (i + l1) < DataSize do
      begin
        i1 := i + l1;
        t1 := u1 * Data[i1].Re - u2 * Data[i1].Im;
        t2 := u1 * Data[i1].Im + u2 * Data[i1].Re;
        Data[i1].Re := Data[i].Re - t1;
        Data[i1].Im := Data[i].Im - t2;
        Data[i].Re := Data[i].Re + t1;
        Data[i].Im := Data[i].Im + t2;
        Inc(i, l2);
      end;
      z := u1*c1 - u2*c2;
      u2 := u1*c2 + u2*c1;
      u1 := z;
    end;
    c2 := Sqrt((1.0 - c1) / 2.0);
    if Direction = 1 then
      c2 := -c2;
    c1 := Sqrt((1.0 + c1) / 2.0);
  end;

  // Scaling for forward transform
  if Direction = 1 then
  for i:=0 to DataSize-1 do
  begin
    Data[i].Re := Data[i].Re / DataSize;
    Data[i].Im := Data[i].Im / DataSize;
  end;
end;

procedure Windowing(var data: array of double; Taps: integer; WF: TWindowFunction);
var i:integer;
begin
  for i:=0 to high(data) do
   case WF of
     wf_None : ;
     wf_Hamming      : data[i]:=data[i]*(0.54-0.46*cos((i*2*PI)/Taps));
     wf_Blackman     : data[i]:=data[i]*(0.42-0.5*cos((i*2*PI)/Taps)+0.08*cos((i*4*PI)/Taps));
     wf_KaiserBessel : data[i]:=data[i]*(0.4021-0.4986*cos((i*2*PI)/Taps)+0.0981*cos((i*4*PI)/Taps)-0.0012*cos((i*6*PI)/Taps));
     wf_FlatTop      : data[i]:=data[i]*(0.2155-0.4159*cos((i*2*PI)/Taps)+0.2780*cos((i*4*PI)/Taps)-0.0836*cos((i*6*PI)/Taps)+0.0070*cos((i*8*PI)/Taps));
   end;//case
end;

procedure four(data: array of Real; isign: Integer);
var  tmpdata             : array of Real;
     alpha, beta, theta,
     temp,sw,cw          : double;
     i,j,Count           : integer;
begin
  Count:=length(data);
  setlength(tmpdata,2*Count);
  //ZeroMemory(tmpdata,sizeof(tmpdata));
  for i := 0 to Length(tmpdata) do
    tmpdata[i] := 0;
  for i:=0 to Count-1 do
  begin
    theta:=isign*2.0*PI*(i/Count);
    temp:=sin(0.5*theta);
    alpha:=2.0*sqr(temp);
    beta:=sin(theta);
    cw:=1.0;
    sw:=0.0;
    for j:=0 to Count-1 do
    begin
      tmpdata[2*i]:=tmpdata[2*i]+(cw*data[2*j]-sw*data[2*j+1]);
      tmpdata[2*i+1]:=tmpdata[2*i+1]+(cw*data[2*j+1]+sw*data[2*j]);
//      cw:=(temp=cw)-(alpha*cw+beta*sw);
      sw:=sw-(alpha*sw-beta*temp);
    end;
  end;
  if (isign=-1) then
  begin
    for i:=0 to 2*Count-1 do tmpdata[i]:=tmpdata[i]/Count;
  end;
  for i:=0 to 2*Count-1 do data[i]:=tmpdata[i];
  setlength(tmpdata,0);
end;

procedure DFT(data: array of Real; isign: integer);
var i,i1,i2,i3,i4,np3, Count  : integer;
    c1,c2,h1r,h2r,h1i,h2i : Real;
    wr,wi,wpr,wpi,wtemp,theta : Real;
begin
  Count:=length(data);
  if (Count mod 4<>0) then raise EMathError.Create('Fehler in DFT (N kein Vielfaches von 4)');
  c1:=0.5;
  theta:=PI/(Count/2);
  if (isign=1) then
  begin
    c2:=-0.5;
    four(data,1);
  end else
  begin
    c2:=0.5;
    theta:=-theta;
  end;
  wtemp:=sin(0.5*theta);
  wpr:=-2.0*wtemp*wtemp;
  wpi:=sin(theta);
  wr:=1.0+wpr;
  wi:=wpi;
  np3:=Count+3;
  for i:=2 to Count div 4 do
  begin
//    i4:=1+(i3=np3-(i2=1+(i1=i+i-1)));
    h1r:=c1*(data[i1]+data[i3]);
    h1i:=c1*(data[i2]-data[i4]);
    h2r:=-c2*(data[i2]+data[i4]);
    h2i:=c2*(data[i1]-data[i3]);
    data[i1]:=h1r+wr*h2r-wi*h2i;
    data[i2]:= h1i+wr*h2i+wi*h2r;
    data[i3]:= h1r-wr*h2r+wi*h2i;
    data[i4]:=-h1i+wr*h2i+wi*h2r;
//    wr:=(wtemp=wr)*wpr-wi*wpi+wr;
    wi:=wi*wpr+wtemp*wpi+wi;
  end;
  if (isign=1) then
  begin
//    data[1]:=(h1r=data[1])+data[2];
    data[2]:=h1r-data[2];
  end else
  begin
//  data[1]:=c1*((h1r=data[1])+data[2]);
    data[2]:=c1*(h1r-data[2]);
    four(data,-1);
  end;
end;

procedure SWAP(var a, b:double);
var temp:double;
begin
   temp:=(a);
   a:=b;
   b:=temp;
end;

procedure FFT(var data: array of double; nn: integer; invers: boolean);
(* Programs using routine FOUR1 must define type
TYPE
   gldarray = ARRAY [1..nn2] OF real;
in the calling routine, where nn2=nn+nn. *)
var ii,jj,n,mmax,m,j,istep,i: integer;
    wtemp,wr,wpr,wpi,wi,theta: double;
    tempr,tempi: real;
begin
   n := 2*nn;
   j := 1;
   for ii := 1 to nn do
   begin
      i := 2*ii-1;
      if (j > i) then
      begin
         tempr := data[j];
         tempi := data[j+1];
         data[j] := data[i];
         data[j+1] := data[i+1];
         data[i] := tempr;
         data[i+1] := tempi
      end;
      m := n div 2;
      while ((m >= 2) and (j > m)) do
      begin
         j := j-m;
         m := m div 2
      end;
      j := j+m
   end;
   mmax := 2;
   while (n > mmax) do
   begin
      istep := 2*mmax;
      if invers then
         theta := 6.28318530717959/mmax else
         theta := 6.28318530717959/-mmax;
      wpr := -2.0*sqr(sin(0.5*theta));
      wpi := sin(theta);
      wr := 1.0;
      wi := 0.0;
      for ii := 1 to (mmax div 2) do
      begin
         m := 2*ii-1;
         for jj := 0 to ((n-m) div istep) do
         begin
            i := m + jj*istep;
            j := i+mmax;
            tempr := real(wr)*data[j]-real(wi)*data[j+1];
            tempi := real(wr)*data[j+1]+real(wi)*data[j];
            data[j] := data[i]-tempr;
            data[j+1] := data[i+1]-tempi;
            data[i] := data[i]+tempr;
            data[i+1] := data[i+1]+tempi
         end;
         wtemp := wr;
         wr := wr*wpr-wi*wpi+wr;
         wi := wi*wpr+wtemp*wpi+wi
      end;
      mmax := istep
   end;
end;


procedure FillHanningWindow(out OutData: TAcsArrayOfDouble; Width: Integer);
var
  i, n: Integer;
begin
  SetLength(OutData, Width);
  if Width <= 0 then
     Exit;

  n := Width-1;
  OutData[0] := 0.5 * (1 + cos((TwoPi * Width) / n));
  for i := 1 to Width-1 do
     OutData[i] := 0.5 * (1 - cos((TwoPi * Width) / n));
end;

procedure FillHammingWindow(out OutData: TAcsArrayOfDouble; Width: Integer);
var
  i, n: Integer;
begin
  SetLength(OutData, Width);
  n := Width - 1;
  for i := 1 to Width do
    OutData[i-1] := 0.54 - 0.46 * Cos(TwoPi * i / n);
end;

procedure BlackmanWindow(out OutData: TAcsArrayOfDouble; Width: Integer; Symmetric: Boolean);
var
  i, n: Integer;
begin
  SetLength(OutData, Width);
  if Symmetric then
    n := Width - 1
  else
    n := Width;

  for i := 0 to Width-1 do
    OutData[i] := 0.42 - 0.5 * Cos(TwoPi * i / n) + 0.08 * Cos(2 * TwoPi * i / n);
end;

procedure CalculateSincKernel(out OutData: TAcsArrayOfDouble; CutOff: Double; Width: Integer; WType: TAcsFilterWindowType);
var
  i: Integer;
  Sinc: Double;
  Window: TAcsArrayOfDouble;
begin
  { TODO : http://avisynth.nl/index.php/Resampling }
  case WType of
    fwHamming: FillHammingWindow(Window, Width);
    fwHann: FillHanningWindow(Window, Width);
    fwBlackman: BlackmanWindow(Window, Width, False);
  end;

  SetLength(OutData, Width);
  Sinc := 0;
  for i := 0 to Width-1 do
  begin
    if i-(Width shr 1) <> 0 then
      OutData[i] := Sin(TwoPi * CutOff * (i-(Width shr 1))) / (i-(Width shr 1)) * Window[i]
    else
      OutData[i] := TwoPi * CutOff * Window[i];
    Sinc := Sinc + OutData[i];
  end;
  for i := 0 to Width-1 do
    OutData[i] := OutData[i] / Sinc;
end;

procedure SmallIntArrayToDouble(InData: PSmallInt; OutData: PDouble; DataSize: Integer);
begin
  {$ifdef USE_ASM}
  asm
              MOV EDX, DataSize;
              SHL EDX, 3;
              MOV ECX, OutData;
              ADD EDX, ECX;
              MOV EAX, InData;
    @test:    CMP EDX, ECX;
              JE @out;
              FILD WORD[EAX];
              ADD EAX, 2;
              FSTP QWORD[ECX];
              ADD ECX, 8;
              JMP @test;
    @out:     ;
  end;
  {$ENDIF}
end;

procedure SmallIntArrayToComplex(InData: PSmallInt; OutData: PAcsComplex; DataSize: Integer);
begin
  {$ifdef USE_ASM}
  asm
              MOV EDX, DataSize;
              SHR EDX, 4;
              MOV ECX, OutData;
              ADD EDX, ECX;
              MOV EAX, InData;
    @test:    CMP EDX, ECX;
              JE @out;
              FILD WORD[EAX];
              ADD EAX, 2;
              FSTP QWORD[EAX];
              ADD ECX, 16;
              JMP @test;
    @out:     ;
  end;
  {$ENDIF}
end;

procedure MultDoubleArrays(var Data1: TAcsArrayOfDouble; const Data2: TAcsArrayOfDouble; DataSize: Integer);
{$ifndef USE_ASM}
var
  i: integer;
{$endif}
begin
  DataSize := Length(Data2);
{$ifndef USE_ASM}
  for i:=0 to DataSize-1 do
  begin
    Data1[i] := Data1[i] * Data2[i];
  end;
{$else}
  asm
              MOV EDX, DataSize;
              SHL EDX, 3;        // DataSize * 8
              MOV ECX, Data1[0]; // ECX = @Data1
              ADD EDX, ECX;      // EDX = @Data1 + (DataSize * 8)
              MOV EAX, Data2[0]; // EAX = @Data2
    @test:    CMP EDX, ECX;
              JE @out;           // if @Data1 = EDX then Exit
              FLD QWORD[ECX];    // load double from Data1
              FLD QWORD[EAX];    // load double from Data2
              FMUL;              // multiply them
              FSTP QWORD[EAX];   // save result to Data2
              ADD ECX, 8;        // next Data1
              ADD EAX, 8;        // next Data2
              JMP @test;
    @out:     ;
  end;
{$endif}
end;

function Magnitude(const Re, Im: Double): Double;
begin
  Result := sqrt( power(abs(Re), 2) + power(abs(Im), 2) );
end;

function Amplitude(const Re, Im: Double): Double;
begin
  Result := sqrt( power(abs(Re), 2) + power(abs(Im), 2) );
  if Result > 0 then
    Result := log10(Result);
end;

procedure LgAmplitude(const InData: TAcsArrayOfComplex; out OutData: TAcsArrayOfDouble;
  DataSize, Shift: Integer);
var
  LogBase: Double;
  {$ifndef USE_ASM}
  num: Double;
  i: integer;
  {$endif}
begin
  DataSize := Length(InData);
  SetLength(OutData, DataSize);
{$ifndef USE_ASM}

  //LogBase := 1 / log2(10); // 0.3010299956639812
  for i:=0 to DataSize-1 do
  begin
    OutData[i] := 0;
    num := sqrt( power(abs(InData[i].Re), 2) + power(abs(InData[i].Im), 2) );
    if num > 0 then
    begin
      num := log10(num) + Shift;
      //num := num * log2(LogBase) + Shift;  // log10 equivalent
      //num := LogBase * log2(num) + Shift;
      if num >= 0 then
        OutData[i] := num;
    end;
  end;

{$else}

  asm
              FLD1;               // st0 := 1.0
              FLDL2T;             // st1 <- st0, st0 := log2(10)
              FDIVP ST(1), ST(0); // st0 := st1 / st0
              FSTP LogBase;       // LogBase := 1/log2(10)
              MOV EDX, DataSize;
              SHL EDX, 3;         // DataSize * 8
              MOV ECX, OutData[0]; // cx := @OutData
              ADD EDX, ECX;       // dx := @OutData + (DataSize*8)
              MOV EAX, InData[0]; // ax := @InData.re
    @test:    CMP EDX, ECX;
              JE @out;
              FLD QWORD[EAX];     // st0 := InData.re
              FABS ST(0);         // abs(st0)
              FMUL ST(0), ST(0);  // st0 := st0 * st0 (st0 ^ 2)
              ADD EAX, 8;         // ax := InData.im
              FLD QWORD[EAX];     // st1 := st0, st0 := @ax
              FABS ST(0);         // abs(st0)
              FMUL ST(0), ST(0);  // st0 := st0 * st0 (st0 ^ 2)
              FADDP ST(1), ST(0); // st0 := st0 + st1
              FSQRT;              // st0 := sqrt(st0)
              FTST;               // test st0
              PUSH EAX;           // save ax
              FSTSW AX;           // status -> ax
              SAHF;               // ah -> flags
              JE @skip;           // if 0 goto @skip
              FLD LogBase;        // st1:=st0, st0 := LogBase
              FXCH;               // st0 <-> st1 (st1=LogBase)
              FYL2X;              // st0 := st1 * log2(st0)
              FIADD Shift;        // st0 := st0 + Shift
              FTST;               // test st0
              FSTSW AX;           // status -> ax
              SAHF;               // ah -> flags
              JAE @skip;          // >=0 -> @skip
              FSTP QWORD[ECX];    // st0 -> @cx
              FLDZ;               // st0 := 0
    @skip:    POP EAX;            // load ax
              ADD EAX, 8;         // next InData
              FSTP QWORD[ECX];    // st0 -> @cx
              ADD ECX, 8;         // @cx+8
              JMP @test;          // goto @test
    @out:     ;
  end;
{$endif}
end;


end.
