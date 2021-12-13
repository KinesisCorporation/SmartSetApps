(*
CD-ROM input component

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com

Special thanks to Thomas Grelle <grelle@online.de> for improving this unit.

*)


unit acs_cdrom;

interface

uses
  Classes, SysUtils, ACS_Classes, ACS_Strings
  {$IFDEF MSWINDOWS}
  ,Windows, MMSystem
    {$IFDEF WIN32}
     ,akrip32
    {$ELSE}
      {$WARNING acs_cdrom only for Win32!}
    {$ENDIF}
  {$ELSE}
  ,baseunix, cd_rom
  {$ENDIF}
  ;

type
  {$IFDEF MSWINDOWS}
  {$IFDEF FPC}
  TAuxCaps = AUXCAPS;
  {$ENDIF}
  {$ENDIF}

  TAcsCDStatus = (cdsNotReady, cdsReady, cdsPlaying, cdsPaused);
  TAcsTrackType = (ttAudio, ttData);
  TAcsCDInfo = (cdiNoDisc, cdiDiscAudio, cdiDiscData, cdiDiscMixed, cdiUnknown);
  TAcsMCN = array[0..13] of Char;

  TAcsCDMSF = record
    Minute: Byte;
    Second: Byte;
    Frame: Byte;
  end;
  PACSCDMSF = ^TAcsCDMSF;

  TAcsCDTrackInfo = record
    TrackStart: TAcsCDMSF;
    TrackLength: TAcsCDMSF;
    TrackType: TAcsTrackType;
  end;

  TAcsCDPosition = record
    Track: Integer;
    MSF: TAcsCDMSF;
  end;

const

  EndOfDisc: TAcsCDPosition = (Track: 100; MSF: (Minute: 0; Second: 0; Frame: 0));
  CD_FRAMESIZE_RAW = 2352;
  BUF_SIZE = 50;  // 75 frames - 1 sec

var
  AppPath: String;
  WinPath: String;

type  

  { This is the cdreader component of acs it reads in windows with aspi
    and linux direct from device }

  TAcsCDIn = class(TAcsCustomFileIn)
  private
    FBuffer: array of byte;
    FCurrentDrive: Integer;
    FStartTrack: Integer;
    FEndTrack: Integer;
    FStartPos: TAcsCDPosition;
    FEndPos: TAcsCDPosition;
    FRipEnd: Integer;
    FCDDBId: Longint;
    {$IFDEF LINUX}
    FOpened: Integer;
    FCurPos: TAcsCDMSF;
    FEndMSF: TAcsCDMSF;
    FDrivesCount: Integer;
    _cd_fd: Integer;
    BufSize: Integer;
    {$ENDIF}
    {$IFDEF WIN32}
    FToc: TOC;
    FCDList: CDLIST;
    FCDHandle: HCDROM;
    FPlaying: Boolean;
    FRipStart: LongInt;
    FiBuffer: PTRACKBUF;
    {$ENDIF}
    FLibLoaded : Boolean;
    procedure OpenCD();
    procedure CloseCD();
    function GetStatus(): TAcsCDStatus;
    function GetNumTracks(): Integer;
    function GetTrackInfo(const vIndex: Integer): TAcsCDTrackInfo;
    procedure SetST(Track: Integer);
    procedure SetET(Track: Integer);
    procedure SetSP(Pos: TAcsCDPosition);
    procedure SetEP(Pos: TAcsCDPosition);
    function GetInfo(): TAcsCDInfo;
    function GetDrivesCount(): Integer;
    procedure SetCurrentDrive(Value: Integer);
    function GetDriveName(): string;
    function GetCDDBID(): LongInt;
  protected
    function GetSize(): Integer; override;
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
    function GetTotalTime(): Real; override;
    {$IFDEF WIN32}
    procedure InitLib;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    { Open CD tray }
    function Eject(): Boolean;
    { Close CD tray }
    function CloseTray(): Boolean;
    property DiscInfo: TAcsCDInfo read GetInfo;
    property Status: TAcsCDStatus read GetStatus;
    property Tracks[const vIndex: Integer]: TAcsCDTrackInfo read GetTrackInfo;
    property TracksCount: Integer read GetNumTracks;
    property DriveName: String read GetDriveName;
    property DrivesCount: Integer read GetDrivesCount;
    property StartPos: TAcsCDPosition read FStartPos write SetSP;
    property EndPos: TAcsCDPosition read FEndPos write SetEP;
    property CDDBId: LongInt read GetCDDBID;
  published
    property CurrentDrive: Integer read FCurrentDrive write SetCurrentDrive;
    property StartTrack: Integer read FStartTrack write SetSt;
    property EndTrack: Integer read FEndTrack write SetET;
  end;

  function MSFToStr(const MSF: TAcsCDMSF): String;
  procedure Frames2MSF(Frames: Integer; var MSF: TAcsCDMSF);
  function MSF2Frames(const MSF: TAcsCDMSF): Integer;
  
  {$IFDEF LINUX}
  var
    DrivesCount: Integer;
    DrivesPaths: array of string;
  
  procedure CountDrives;
  {$ENDIF}

implementation

{$I acs_cdrom.inc}

function MSFToStr(const MSF: TAcsCDMSF): string;
var
  sep: String;
  sec, min: Integer;
begin
  min:=MSF.Minute;
  if MSF.Frame > 37 then
  begin
    sec:=MSF.Second+1;
    if sec=60 then
    begin
      Inc(min);
      sec:=0;
    end;
  end
  else sec:=MSF.Second;
  if sec<10 then sep:=':0' else sep:=':';
  Result:=IntToStr(min)+sep+IntToStr(sec);
end;

procedure Frames2MSF(Frames: Integer; var MSF: TAcsCDMSF);
var
  Temp: Integer;
begin
  Temp:=(Frames div 75);
  MSF.Minute:=(Temp div 60);
  MSF.Second:=(Temp mod 60);
  MSF.Frame:=(Frames mod 75);
end;

function MSF2Frames(const MSF: TAcsCDMSF): Integer;
begin
  Result:=((MSF.Minute*60)+MSF.Second)*75+MSF.Frame;
end;

function TAcsCDIn.GetBPS(): Integer;
begin
  Result:=16;
end;

function TAcsCDIn.GetCh(): Integer;
begin
  Result:=2;
end;

function TAcsCDIn.GetSR(): Integer;
begin
  Result:=44100;
end;

function TAcsCDIn.GetTotalTime(): Real;
begin
  if (SampleRate=0) or (Channels=0) or (BitsPerSample=0) then Exit;
  Result:=Size / (SampleRate * Channels * (BitsPerSample div 8));
end;

function TAcsCDIn.GetCDDBID(): LongInt;

function prg_sum(n: integer): integer;
var
  buf: string;
  ib: Integer;
begin
  buf:=IntToStr(n);
  Result:=0;
  for ib:=1 to Length(buf) do
    Result:=Result+(StrToInt(Copy(Buf, ib, 1)));
end;


var
  i, N, L: Longint;
  CDM: TAcsCDMSF;
begin
  N:=0;
  L:=0;
  for i := 0 to GetNumTracks-1 do
  begin
    with Tracks[i].TrackStart do
    begin
      N:=N+prg_sum((minute*60)+second+2);
      L:=L+MSF2Frames(Tracks[i].TrackLength);
      // adjust the length of last audio track if a data track is following
      if (i > 0) and (i = (TracksCount-2)) and (Tracks[i+1].TrackType = ttData) then
        inc(L, 152*75);
    end;
  end;
  Frames2MSF(L, CDM);
  L:=CDM.Minute*60+CDM.Second;
  Result:=((N MOD $0FF) SHL 24) XOR (L SHL 8) XOR TracksCount;
  FCDDBId:=Result;
end;
  
{$IFDEF LINUX}
initialization
  CountDrives;
{$ENDIF}

{$ifdef WIN32}
initialization
  LoadCDRip();

finalization
  UnloadCDRip();
{$endif}

end.
