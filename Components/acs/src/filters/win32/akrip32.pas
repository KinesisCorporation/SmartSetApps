unit akrip32;
{*
 * akrip32.h - copyright (c) 1999 jay a. key
 *
 * api for akrip32.dll (v0.93)
 *
 * modified for acs (dynamic loading ...) y christian ulrich (mail@z0m3ie.de)
 * translated for borland delphi by holger dors (holger@dors.de)
 *
 * history of delphi version:
 *
 * 09. january 2000:  first released version
 * 05. February 2000: Updated for new function "CDDBGetServerList"
 *                   in V.093 of akrip32.dll
 *
 **********************************************************************
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 *}

interface

uses windows;

const

  TRACK_AUDIO = $00;
  TRACK_DATA = $01;

  MAXIDLEN = 64;
  MAXCDLIST = 8;

  {*
   * TRACKBUF
   *
   * This structure should not be allocated directly.  If a buffer containing
   * 27 * 2353 bytes is desired, a buffer should be allocated containing
   * the desired amount + 24 bytes.  The allocated memory can then be
   * typecast to a LPTRACKBUF.  It is the program's responsibility to guard
   * against reading/writing past the end of allocated memory.
   *
   * The following must always apply:
   *   (len + startOffset) <= (numFrames * 2352) <= maxLen
   *}

type
  PTRACKBUF = ^TRACKBUF;
  TRACKBUF = record
    startFrame: DWord; {* 00: starting frame number          *}
    numFrames: DWord; {* 04: number of frames read          *}
    maxLen: DWord; {* 08: length of buffer itself        *}
    len: DWord; {* 0C: length of data actually in buf *}
    status: DWord; {* 10: status of last read operation  *}
    startOffset: Integer; {* 14: offset of valid data in buf    *}
    buf: array[0..1024 * 1024 - 1] of Byte; {* 18: the data itself                *}
  end;

  TRACKBUFDUMMY = record
    startFrame: DWord; {* 00: starting frame number          *}
    numFrames: DWord; {* 04: number of frames read          *}
    maxLen: DWord; {* 08: length of buffer itself        *}
    len: DWord; {* 0C: length of data actually in buf *}
    status: DWord; {* 10: status of last read operation  *}
    startOffset: Integer; {* 14: offset of valid data in buf    *}
  end;

const
  TRACKBUFEXTRA = SizeOf(TRACKBUFDUMMY);

type
  PCDINFO = ^CDINFO;
  CDINFO = record
    vendor: array[0..8] of Char;
    prodId: array[0..16] of Char;
    rev: array[0..4] of Char;
    vendSpec: array[0..20] of Char;
  end;

  PCDREC = ^CDREC;
  CDREC = record
    ha: Byte;
    tgt: Byte;
    lun: Byte;
    pad: Byte;
    id: array[0..MAXIDLEN] of Char;
    info: CDINFO;
  end;

  PCDLIST = ^CDLIST;
  CDLIST = record
    max: Byte;
    num: Byte;
    cd: array[0..MAXCDLIST - 1] of CDREC;
  end;

    {*
     * TOCTRACK and TOC must be byte-aligned.  If you're not using Mingw32,
     * CygWin, or some other compiler that understands the PACKED keyword,
     * you need to ensure that these structures are byte aligned.  Usually,
     * this is done using a
     *  #pragma pack(1)
     * See your compiler's documentation for details
     *}

  TOCTRACK = packed record
    rsvd: Byte;
    ADR: Byte;
    trackNumber: Byte;
    rsvd2: Byte;
    addr: array[0..3] of Byte;
  end;

  PTOC = ^TOC;
  TOC = packed record
    tocLen: Word;
    firstTrack: Byte;
    lastTrack: Byte;
    tracks: array[0..99] of TOCTRACK;
  end;

  PTRACK = ^TRACK;
  TRACK = packed record
    trackNo: Integer;
    startLBA: DWord;
    trackLen: DWord;
    _type: Byte;
    pad: array[0..3] of Byte;
    name: ShortString;//array[0..255] of Char;
  end;

  PREADMSF = ^READMSF;
  READMSF = record
    sm: Byte;
    ss: Byte;
    sf: Byte;
    em: Byte;
    es: Byte;
    ef: Byte;
  end;

const
  {*
   * Error codes set by functions in ASPILIB.C
   *}

  ALERR_NOERROR = 0;
  ALERR_NOWNASPI = 1;
  ALERR_NOGETASPI32SUPP = 2;
  ALERR_NOSENDASPICMD = 3;
  ALERR_ASPI = 4;
  ALERR_NOCDSELECTED = 5;
  ALERR_BUFTOOSMALL = 6;
  ALERR_INVHANDLE = 7;
  ALERR_NOMOREHAND = 8;
  ALERR_BUFPTR = 9;
  ALERR_NOTACD = 10;
  ALERR_LOCK = 11;
  ALERR_DUPHAND = 12;
  ALERR_INVPTR = 13;
  ALERR_INVPARM = 14;
  ALERR_JITTER = 15;

  {*
   * constants used for queryCDParms()
   *}

  CDP_READCDR = $0001; // can read CD-R
  CDP_READCDE = $0002; // can read CD-E
  CDP_METHOD2 = $0003; // can read CD-R wriiten via method 2
  CDP_WRITECDR = $0004; // can write CD-R
  CDP_WRITECDE = $0005; // can write CD-E
  CDP_AUDIOPLAY = $0006; // can play audio
  CDP_COMPOSITE = $0007; // composite audio/video stream
  CDP_DIGITAL1 = $0008; // digital output (IEC958) on port 1
  CDP_DIGITAL2 = $0009; // digital output (IEC958) on port 2
  CDP_M2FORM1 = $000A; // reads Mode 2 Form 1 (XA) format
  CDP_M2FORM2 = $000B; // reads Mode 2 Form 2 format
  CDP_MULTISES = $000C; // reads multi-session or Photo-CD
  CDP_CDDA = $000D; // supports cd-da
  CDP_STREAMACC = $000E; // supports "stream is accurate"
  CDP_RW = $000F; // can return R-W info
  CDP_RWCORR = $0010; // returns R-W de-interleaved and err.
  // corrected
  CDP_C2SUPP = $0011; // C2 error pointers
  CDP_ISRC = $0012; // can return the ISRC info
  CDP_UPC = $0013; // can return the Media Catalog Number
  CDP_CANLOCK = $0014; // prevent/allow cmd. can lock the media
  CDP_LOCKED = $0015; // current lock state (TRUE = LOCKED)
  CDP_PREVJUMP = $0016; // prevent/allow jumper state
  CDP_CANEJECT = $0017; // drive can eject disk
  CDP_MECHTYPE = $0018; // type of disk loading supported
  CDP_SEPVOL = $0019; // independent audio level for channels
  CDP_SEPMUTE = $001A; // independent mute for channels
  CDP_SDP = $001B; // supports disk present (SDP)
  CDP_SSS = $001C; // Software Slot Selection
  CDP_MAXSPEED = $001D; // maximum supported speed of drive
  CDP_NUMVOL = $001E; // number of volume levels
  CDP_BUFSIZE = $001F; // size of output buffer
  CDP_CURRSPEED = $0020; // current speed of drive
  CDP_SPM = $0021; // "S" units per "M" (MSF format)
  CDP_FPS = $0022; // "F" units per "S" (MSF format)
  CDP_INACTMULT = $0023; // inactivity multiplier ( x 125 ms)
  CDP_MSF = $0024; // use MSF format for READ TOC cmd
  CDP_OVERLAP = $0025; // number of overlap frames for jitter
  CDP_JITTER = $0026; // number of frames to check for jitter
  CDP_READMODE = $0027; // mode to attempt jitter corr.

  {*
   * defines for GETCDHAND  readType
   *
   *}
  CDR_ANY = $00; // unknown
  CDR_ATAPI1 = $01; // ATAPI per spec
  CDR_ATAPI2 = $02; // alternate ATAPI
  CDR_READ6 = $03; // using SCSI READ(6)
  CDR_READ10 = $04; // using SCSI READ(10)
  CDR_READ_D8 = $05; // using command 0xD8 (Plextor?)
  CDR_READ_D4 = $06; // using command 0xD4 (NEC?)
  CDR_READ_D4_1 = $07; // 0xD4 with a mode select
  CDR_READ10_2 = $08; // different mode select w/ READ(10)

  {*
   * defines for the read mode (CDP_READMODE)
   *}
  CDRM_NOJITTER = $00; // never jitter correct
  CDRM_JITTER = $01; // always jitter correct
  CDRM_JITTERONERR = $02; // jitter correct only after a read error

type
  HCDROM = THandle;

  PGETCDHAND = ^GETCDHAND;
  GETCDHAND = packed record
    size: Byte; {* set to sizeof(GETCDHAND)            *}
    ver: Byte; {* set to AKRIPVER                     *}
    ha: Byte; {* host adapter                        *}
    tgt: Byte; {* target id                           *}
    lun: Byte; {* LUN                                 *}
    readType: Byte; {* read function to use                *}
    jitterCorr: Bool; {* use built-in jitter correction?     *}
    numJitter: Byte; {* number of frames to try to match    *}
    numOverlap: Byte; {* number of frames to overlap         *}
  end;

const
  akriplib = 'akrip32.dll';
  
var
  LibHandle: Integer;
  CDRipLoaded: Boolean;

type
  GetNumAdapters_t = function : Integer; cdecl;
  GetCDList_t = function (var cd: CDLIST): Integer; cdecl;
  GetAspiLibError_t = function : Integer; cdecl;
  GetAspiLibAspiError_t = function : Byte; cdecl;

  GetCDId_t = function (hCD: HCDROM; buf: PChar; maxBuf: Integer): DWord; cdecl;
  GetDriveInfo_t = function (ha, tgt, lun: byte; var cdrec: CDREC): DWord; cdecl;
  ReadTOC_t = function (hCD: HCDROM; var MyToc: TOC): DWord; cdecl;
  ReadCDAudioLBA_t = function (hCD: HCDROM; TrackBuf: PTRACKBUF): DWord; cdecl;
  QueryCDParms_t = function (hCD: HCDROM; which: Integer; var Num: DWord): Bool; cdecl;
  ModifyCDParms_t = function (hCD: HCDROM; which: Integer; val: DWord): Bool; cdecl;
  GetCDHandle_t = function (var cd: GETCDHAND): HCDROM; cdecl;
  CloseCDHandle_t = function (hCD: HCDROM): Bool; cdecl;
  ReadCDAudioLBAEx_t = function (hCD: HCDROM; TrackBuf, Overlap: PTRACKBUF): DWord; cdecl;

var
  GetNumAdapters: GetNumAdapters_t;
  GetCDList: GetCDList_t;
  GetAspiLibError: GetAspiLibError_t;
  GetAspiLibAspiError: GetAspiLibAspiError_t;

  GetCDId: GetCDId_t;
  GetDriveInfo: GetDriveInfo_t;
  ReadTOC: ReadTOC_t;
  ReadCDAudioLBA: ReadCDAudioLBA_t;
  QueryCDParms: QueryCDParms_t;
  ModifyCDParms: ModifyCDParms_t;
  GetCDHandle: GetCDHandle_t;
  CloseCDHandle: CloseCDHandle_t;
  ReadCDAudioLBAEx: ReadCDAudioLBAEx_t;

function LoadCDRip(): Boolean;
procedure UnloadCDRip();

implementation

function LoadCDRip(): Boolean;
begin
  Libhandle := LoadLibraryEx(akriplib, 0, 0);
  if Libhandle <> 0 then
  begin
    CDRipLoaded := True;
    GetNumAdapters := GetProcAddress(Libhandle, 'GetNumAdapters');
    GetCDList := GetProcAddress(Libhandle, 'GetCDList');
    GetAspiLibError := GetProcAddress(Libhandle, 'GetAspiLibError');
    GetAspiLibAspiError := GetProcAddress(Libhandle, 'GetAspiLibAspiError');
    GetCDId := GetProcAddress(Libhandle, 'GetCDId');
    GetDriveInfo := GetProcAddress(Libhandle, 'GetCDDriveInfo');
    ReadTOC := GetProcAddress(Libhandle, 'ReadTOC');
    ReadCDAudioLBA := GetProcAddress(Libhandle, 'ReadCDAudioLBA');
    QueryCDParms := GetProcAddress(Libhandle, 'QueryCDParams');
    ModifyCDParms := GetProcAddress(Libhandle, 'ModifyCDParms');
    GetCDHandle := GetProcAddress(Libhandle, 'GetCDHandle');
    CloseCDHandle := GetProcAddress(Libhandle, 'CloseCDHandle');
    ReadCDAudioLBAEx := GetProcAddress(Libhandle, 'ReadCDAudioLBAEx');
  end;
  Result := (Libhandle <> 0);
end;

procedure UnloadCDRip();
begin
  if Libhandle <> 0 then
  begin
    FreeLibrary(Libhandle);
    CDRipLoaded := False;
  end;
end;

end.

