(*
Volume query component

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com

Provides linear volume in volLeft and volRight in the range 0 (min) to 32767 (max).
Supports 8 and 16 bit samples, mono and stereo.
dbLeft and dbRight returns the volume in decibels.
Delay is in blocks of 50ms and is required due to unknown output buffer size.
Increase Delay to bring VU levels in line with output audio.
Suggest using a 50ms Timer to read values.

*)

unit acs_volumequery;

interface

uses
   Classes, Math, ACS_Types, ACS_Classes, ACS_Strings;

type

  TAcsVolumeQuery = class(TAcsCustomConverter)
  private
    Lock: Boolean;
    FLeft, FRight: Array of Word;
    FDelay, F50ms: Word;
    FSR, FBPS, FCh: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function volLeft(): Word;
    function volRight(): Word;
    function dbLeft(): Single;
    function dbRight(): Single;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
  published
    property Delay: Word read FDelay write FDelay;
  end;

implementation

constructor TAcsVolumeQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAcsVolumeQuery.Destroy();
begin
  inherited Destroy;
end;

procedure TAcsVolumeQuery.Init();
begin
  inherited Init();
  SetLength(FLeft,FDelay+1);
  SetLength(FRight,FDelay+1);
  FillChar(FLeft[0], SizeOf(Word)*(FDelay+1), 0);
  FillChar(FRight[0], SizeOf(Word)*(FDelay+1), 0);
  // calc 50ms worth of data
  FSR:=GetSR;
  FBPS:=GetBPS;
  FCH:=GetCh;
  //FSize:=FInput.Size;
  F50ms:=FSR * FBPS * FCh div 160;
  Lock:=False;
end;

procedure TAcsVolumeQuery.Done();
begin
  inherited Done();
  Lock:=False;
end;

function TAcsVolumeQuery.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  LVol, RVol, LMax, RMax: word;
  i, NumSamples: Integer;
  tmp: Integer;
begin
  if not Active then
    raise EACSException.Create(strStreamnotopen);
  //if FOrigBufferSize = -1 then FOrigBufferSize:=ABufferSize
  if ABufferSize > F50ms then ABufferSize:=F50ms;
  while InputLock do;
  InputLock:=True;
  Result:=FInput.GetData(ABuffer, ABufferSize);
  InputLock:=False;
  FPosition:=FInput.Position;
  if Result = 0 then Exit;
  if Lock then Exit;
  Lock:=True;
  //
  if FBPS = 8 then
  begin
    if FCh = 1 then
      NumSamples:=Result
    else
      NumSamples:=Result shr 1;
  end
  else
  begin
    if FCh = 1 then NumSamples:=Result shr 1
    else NumSamples:=Result shr 2;
  end;
  //
  LMax:=0;
  RMax:=0;
  i := 0;
  {$R-}
  for i:=0 to NumSamples-1 do
  begin
    if FBPS = 8 then
    begin
      if FCh = 1 then
      begin
        LVol:=ABS(PACSBuffer8(ABuffer)^[i]-127) * 256;
        RVol:=LVol;
      end
      else
      begin
        LVol:=ABS(PACSStereoBuffer8(ABuffer)^[i].Left-127) * 256;
        RVol:=ABS(PACSStereoBuffer8(ABuffer)^[i].Right-127) * 256;
      end;
    end
    else
    begin
      if FCh = 1 then
      begin
        LVol:=ABS(PACSBuffer16(ABuffer)[i]);
        RVol:=LVol;
      end
      else
      begin
        LVol:=ABS(PACSStereoBuffer16(ABuffer)^[i].Left);
        RVol:=ABS(PACSStereoBuffer16(ABuffer)^[i].Right);
      end;
    end;
    if LVol > LMax then LMax:=LVol;
    if RVol > RMax then RMax:=RVol;
  end;
  {$R+}
  if FDelay > 0 then
  begin
    Move(FLeft[1], FLeft[0], FDelay * Sizeof(Word));
    Move(FRight[1], FRight[0], FDelay * Sizeof(Word));
  end;
  if length(FLeft)>FDelay then
    begin
      FLeft[FDelay]:=trunc(LMax);
      FRight[FDelay]:=trunc(RMax);
    end;
  Lock:=False;
end;

function TAcsVolumeQuery.volLeft(): Word;
begin
  Result := 0;
  if Length(FLeft)=0 then exit;
  Lock:=True;
  if Active then
    Result:=FLeft[0]
  else
    Result:=0;
  Lock:=False;
end;

function TAcsVolumeQuery.volRight(): Word;
begin
  Result := 0;
  if Length(FRight)=0 then exit;
  Lock:=True;
  if Active then
    Result:=FRight[0]
  else
    Result:=0;
  Lock:=False;
end;

function TAcsVolumeQuery.dbLeft(): Single;
begin
  Result := 0;
  if Length(FLeft)=0 then exit;
  Lock:=True;
  if Active then
    Result:=10 * Log10((FLeft[0]+1)/32768)
  else
    Result:=-96;
  Lock:=False;
end;

function TAcsVolumeQuery.dbRight(): Single;
begin
  Result := 0;
  if Length(FRight)=0 then exit;
  Lock:=True;
  if Active then
    Result:=10 * Log10((FRight[0]+1)/32768)
  else
    Result:=-96;
  Lock:=False;
end;

end.
