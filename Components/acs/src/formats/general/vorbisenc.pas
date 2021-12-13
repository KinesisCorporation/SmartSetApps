(*
  delphi/kylix headers for oggvorbis software codec.
  translated from vorbisenc.h header
  by andrei borovsky, acs@compiler4.net
  the original c/c++ headers and libraries (c) copyright 1994-2001
  by the xiphophorus company http://www.xiph.org/
*)

{
$Log: vorbisenc.pas,v $
Revision 1.2  2005/12/29 20:46:00  z0m3ie
fixed some problems with vorbis in lazarus

Revision 1.1  2005/12/19 18:36:56  z0m3ie
*** empty log message ***

Revision 1.1  2005/09/12 22:04:53  z0m3ie
modified structure again, fileformats are now in an sperat folder.
all File In/Out classes are capsulated from TFileIn and TFileOut

Revision 1.1  2005/08/25 20:18:00  z0m3ie
Version 2.4 restructure
TCDPlayer removed (fits not in component structure)
TMP3ToWavConverter removed (fits not in component structure)

Revision 1.2  2005/08/22 20:17:01  z0m3ie
changed Headers to log
changed mail adress

}


unit vorbisenc;

{$ifdef fpc}
{$mode delphi}
{$endif}

interface

uses

  ACS_Procs,

  {$IFDEF LINUX}
  baseunix,dl,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}

  vorbiscodec;


const

{$IFDEF LINUX}
  LibvorbisencPath = 'libvorbisenc.so*'; //'/usr/lib/libvorbisenc.so';
  {$DEFINE SEARCH_LIBS}
{$ENDIF}

{$IFDEF MSWINDOWS}
  LibvorbisencPath = 'vorbisenc.dll';
{$ENDIF}


OV_ECTL_RATEMANAGE2_GET = $14;
OV_ECTL_RATEMANAGE2_SET = $15;


var
  LibvorbisencLoaded : Boolean = False;

type

  vorbis_encode_init_t = function(var vi: VORBIS_INFO;
                            channels: LongInt;
                            rate: LongInt;
                            max_bitrate: LongInt;
                            nominal_bitrate: LongInt;
                            min_bitrate: LongInt): Integer cdecl;

  vorbis_encode_setup_managed_t = function(var vi: VORBIS_INFO;
                                     channels: LongInt;
                                     rate: LongInt;
                                     max_bitrate: LongInt;
                                     nominal_bitrate: LongInt;
                                     min_bitrate: LongInt): Integer; cdecl;

  vorbis_encode_setup_vbr_t = function(var vi: VORBIS_INFO;
                                 channels: LongInt;
                                 rate: LongInt;
                                 fl: Single): Integer; cdecl;

  vorbis_encode_init_vbr_t = function(var vi: VORBIS_INFO;
                                channels: LongInt;
                                rate: LongInt;
                                base_quality: Single): Integer; cdecl;

  vorbis_encode_setup_init_t = function(var vi: VORBIS_INFO): Integer; cdecl;

  vorbis_encode_ctl_t = function(var vi: VORBIS_INFO;
                           number: Integer;
                           arg: Pointer): Integer; cdecl;

ovectl_ratemanage2_arg = record
  management_active : Integer;
  bitrate_limit_min_kbps : LongWord;
  bitrate_limit_max_kbps : LongWord;
  bitrate_limit_reservoir_bits : LongWord;
  bitrate_limit_reservoir_bias : Double;
  bitrate_average_kbps : LongWord;
  bitrate_average_damping : Double;
end;


var

  vorbis_encode_init : vorbis_encode_init_t;

  vorbis_encode_setup_managed : vorbis_encode_setup_managed_t;

  vorbis_encode_setup_vbr : vorbis_encode_setup_vbr_t;

  vorbis_encode_init_vbr : vorbis_encode_init_vbr_t;

  vorbis_encode_setup_init : vorbis_encode_setup_init_t;

  vorbis_encode_ctl : vorbis_encode_ctl_t;


implementation

{$IFDEF LINUX}

var
  Libhandle : Pointer;

{$IFDEF SEARCH_LIBS}
  Path : String;
{$ENDIF}

initialization

{$IFDEF SEARCH_LIBS}

  Libhandle := nil;
  Path := FindLibs(LibvorbisencPath);
  if Path <> '' then Libhandle := dlopen(@Path[1], RTLD_NOW or RTLD_GLOBAL);

{$ELSE}

  Libhandle := dlopen(LibvorbisencPath, RTLD_NOW or RTLD_GLOBAL);

{$ENDIF}

  if Libhandle <> nil then
  begin
    LibvorbisencLoaded := True;
    vorbis_encode_init := dlsym(Libhandle, 'vorbis_encode_init');
    vorbis_encode_setup_managed := dlsym(Libhandle, 'vorbis_encode_setup_managed');
    vorbis_encode_setup_vbr := dlsym(Libhandle, 'vorbis_encode_setup_vbr');
    vorbis_encode_init_vbr := dlsym(Libhandle, 'vorbis_encode_init_vbr');
    vorbis_encode_setup_init := dlsym(Libhandle, 'vorbis_encode_setup_init');
    vorbis_encode_ctl := dlsym(Libhandle, 'vorbis_encode_ctl');
  end;

finalization

  if libhandle <> nil then dlclose(Libhandle);

{$ENDIF}

{$IFDEF MSWINDOWS}

var
  Libhandle : HMODULE;

initialization

  Libhandle := LoadLibraryEx(LibvorbisencPath, 0, 0);
  if Libhandle <> 0 then
  begin
    LibvorbisencLoaded := True;
    vorbis_encode_init := GetProcAddress(Libhandle, 'vorbis_encode_init');
    vorbis_encode_setup_managed := GetProcAddress(Libhandle, 'vorbis_encode_setup_managed');
    vorbis_encode_setup_vbr := GetProcAddress(Libhandle, 'vorbis_encode_setup_vbr');
    vorbis_encode_init_vbr := GetProcAddress(Libhandle, 'vorbis_encode_init_vbr');
    vorbis_encode_setup_init := GetProcAddress(Libhandle, 'vorbis_encode_setup_init');
    vorbis_encode_ctl := GetProcAddress(Libhandle, 'vorbis_encode_ctl');
  end;

finalization

  if libhandle <> 0 then FreeLibrary(Libhandle);

{$ENDIF}

end.
