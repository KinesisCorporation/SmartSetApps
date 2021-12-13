(*
Standard audio

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)
{
Status:
TStdAudioOut Win: AcsBuffer, prefetching, tested OK
             Lin: not updated

TStdAudioIn Win: not updated
            Lin: not updated
}

unit acs_stdaudio;

interface

uses
  Classes, SysUtils, syncobjs, ACS_Types, ACS_Classes, ACS_Audio, ACS_Strings
{$IFDEF MSWINDOWS}
  , MMSystem
{$ELSE}
  , baseunix, Soundcard
{$ENDIF}
  ;

const
  LATENCY = 110;

type
{$IFDEF MSWINDOWS}
  {$IFDEF FPC}
  TWaveInCapsA = WAVEINCAPSA;
  TWaveInCaps = TWaveInCapsA;

  TWaveHdr = WAVEHDR;
  {$ENDIF}

  PPWaveHdr = ^PWaveHdr;
{$ENDIF}

  { TStdAudioOut }
  { Windows Wavemapper consume audio data as chain of prepared buffers - blocks.
    Each block points to sample data and to next block. When block played, it
    set flag WHDR_DONE }
  TStdAudioOut = class(TAcsAudioOutDriver)
  private
    _audio_fd: Integer;
    FTimeElapsed: Real;
{$IFDEF MSWINDOWS}
    { first block in chain }
    FirstBlock: PWaveHdr;
    { last block in chain }
    LastBlock: PWaveHdr;
    { number of blocks in use }
    FBlockCount: Integer;
    { size of single block, aligned to sample size }
    FBlockSize: Integer;
    //EOC: PPWaveHdr;
    { how many buffer blocks we use }
    FReadChunks: Integer;
    procedure WriteBlock(P: Pointer; Len: Integer);
    { remove played block from chain, return remaining blocks size }
    function ClearUsedBlocks(): Integer;
{$ENDIF}
  protected
    function GetTE(): Real; override;
    function GetDeviceCount(): Integer; override;
    procedure SetDevice(Ch: Integer); override;
    function GetDeviceName(ADeviceNumber: Integer): string; override;
    function GetDeviceInfo(ADeviceNumber: Integer): TAcsDeviceInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Init(); override;
    function DoOutput(Abort: Boolean): Boolean; override;
    procedure Done(); override;
    { increase played time by number of played bytes, used in player callback }
    procedure PlayedBytes(AValue: Integer);
  end;

  { TStdAudioIn }

  TStdAudioIn = class(TAcsAudioInDriver)
  private
    {$IFDEF MSWINDOWS}
    BlockChain: PWaveHdr;
    FBlocksCount: Integer;
    aBlock: Integer;
    EOC: PPWaveHdr;
    {$ENDIF}
    _audio_fd: Integer;
    FOpened: Integer;
    FRecBytes: Integer;
    procedure OpenAudio;
    procedure CloseAudio;
    {$IFDEF MSWINDOWS}
    procedure NewBlock;
    procedure AddBlockToChain(WH: PWaveHdr);
    {$ENDIF}
  protected
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
    function GetDeviceCount(): Integer; override;
    procedure SetDevice(Ch: Integer); override;
    function GetDeviceName(ADeviceNumber: Integer): string; override;
    function GetDeviceInfo(ADeviceNumber: Integer): TAcsDeviceInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
  end;

var
  InputChannelsCount: Integer;
  OutputChannelsCount: Integer;

function GetAudioDeviceInfo(DevID: Integer; OutputDev: Boolean): TAcsDeviceInfo;

implementation

var
  CrSecI, CrSecO: TCriticalSection;
  
{$IFDEF MSWINDOWS}
  {$I win32\acs_audio.inc}
{$ELSE}
  {$I linux\acs_audio.inc}
{$ENDIF}

function TStdAudioOut.GetTE(): Real;
begin
  //Result:=inherited GetTE;
  Result:=FTimeElapsed;
end;

function TStdAudioOut.GetDeviceName(ADeviceNumber: Integer): string;
begin
  Result:=GetDeviceInfo(ADeviceNumber).DeviceName;
end;

function TStdAudioOut.GetDeviceInfo(ADeviceNumber: Integer): TAcsDeviceInfo;
begin
  //Result:=GetAudioDeviceInfo(FBaseChannel, True);
  Result:=GetAudioDeviceInfo(ADeviceNumber, True);
end;

function TStdAudioOut.GetDeviceCount(): Integer;
begin
  Result:=OutputChannelsCount;
end;

procedure TStdAudioOut.PlayedBytes(AValue: Integer);
begin
  FTimeElapsed:=FTimeElapsed + ((AValue div FSampleSize) / FInput.SampleRate);
end;

{ TStdAudioIn }

function TStdAudioIn.GetDeviceName(ADeviceNumber: Integer): string;
begin
  Result:=GetDeviceInfo(ADeviceNumber).DeviceName;
end;

function TStdAudioIn.GetDeviceInfo(ADeviceNumber: Integer): TAcsDeviceInfo;
begin
  //Result:=GetAudioDeviceInfo(FBaseChannel, False);
  Result:=GetAudioDeviceInfo(ADeviceNumber, False);
end;

function TStdAudioIn.GetDeviceCount(): Integer;
begin
  Result:=InputChannelsCount;
end;

constructor TStdAudioIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBPS:=8;
  FChan:=1;
  FSampleRate:=8000;
  //FSize:=-1;
  FRecTime:=600;
  BufferSize:=$1000;
  {$IFDEF MSWINDOWS}
  FBlocksCount:=4;
  {$ENDIF}
end;

initialization
  {$IFDEF MSWINDOWS}
  CrSecI := TCriticalSection.Create();
  CrSecO := TCriticalSection.Create();
  {$ENDIF}
  CountChannels();
  if OutputChannelsCount > 0 then
    RegisterAudioOut('Wavemapper', TStdAudioOut, LATENCY);
  if InputChannelsCount > 0 then
    RegisterAudioIn('Wavemapper', TStdAudioIn, LATENCY);

finalization
  {$IFDEF MSWINDOWS}
  FreeAndNil(CrSecO);
  FreeAndNil(CrSecI);
  {$ENDIF}

end.
