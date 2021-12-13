(*
SDL SMPEG library (MPEG-1)

This file is a part of Audio Components Suite.
Copyright (C) 2002-2005 Andrei Borovsky. All rights reserved.
See the license file for more details.
This is the ACS for Linux and Windows version of the unit.
*)


//{$weakpackageunit on}

// Linux and Windows C-Compilers use different byte-allignment
{$ifdef FPC}
  //{$PACKRECORDS 4}
{$else}
  {$IFDEF Linux}
    {$align 4} // linux uses dword alignment
  {$endif}
  {$ifdef win32}
    {$ifdef ver140}
      {$align 8} // windows uses quad-word alignment
    {$endif}
  {$endif}
{$endif FPC}

unit acs_smpeg;

interface

uses

  {$ifdef LINUX}
  dynlibs,
  {$else}
  Windows,
  {$endif}
  SysUtils, ACS_Procs;
  
const

  SMPEG_ERROR = -1;
  SMPEG_STOPPED = 0;
  SMPEG_PLAYING = 1;

type

  _SMPEG = record
    //obj: PMPEG;
  end;
  TSMPEG = _SMPEG;
  PSMPEG = ^_SMPEG;

const
  { Audio Format Values }

  { 8-bit support }
  AUDIO_S8 = $8008; // signed 8-bit samples
  AUDIO_U8 = $0008; // unsigned 8-bit samples

  { 16-bit support }
  AUDIO_S16LSB = $8010; // signed 16-bit samples in little-endian byte order
  AUDIO_S16MSB = $9010; // signed 16-bit samples in big-endian byte order
  //AUDIO_S16SYS  // signed 16-bit samples in native byte order
  AUDIO_S16    = AUDIO_S16LSB;

  AUDIO_U16LSB = $0010; // unsigned 16-bit samples in little-endian byte order
  AUDIO_U16MSB = $1010; // unsigned 16-bit samples in big-endian byte order
  //AUDIO_U16SYS  // unsigned 16-bit samples in native byte order
  AUDIO_U16    = AUDIO_U16LSB;

  { 32-bit support (new to SDL 2.0) }
  AUDIO_S32LSB = $8020; // 32-bit integer samples in little-endian byte order
  AUDIO_S32MSB = $9020; // 32-bit integer samples in big-endian byte order
  //AUDIO_S32SYS  // 32-bit integer samples in native byte order
  AUDIO_S32    = AUDIO_S32LSB;

  { float support (new to SDL 2.0) }
  AUDIO_F32LSB = $8120; // 32-bit floating point samples in little-endian byte order
  AUDIO_F32MSB = $9120; // 32-bit floating point samples in big-endian byte order
  //AUDIO_F32SYS //32-bit floating point samples in native byte order
  AUDIO_F32    = AUDIO_F32LSB;

  {$ifdef ENDIAN_LITTLE}
  AUDIO_S16SYS = AUDIO_S16LSB;
  AUDIO_U16SYS = AUDIO_U16LSB;
  AUDIO_S32SYS = AUDIO_S32LSB;
  AUDIO_F32SYS = AUDIO_F32LSB;
  {$endif}

  {$ifdef ENDIAN_BIG}
  AUDIO_S16SYS = AUDIO_S16MSB;
  AUDIO_U16SYS = AUDIO_U16MSB;
  AUDIO_S32SYS = AUDIO_S32MSB;
  AUDIO_F32SYS = AUDIO_F32MSB;
  {$endif}

type
  SDL_AudioSpec = packed record
    freq: Integer;    // DSP frequency (samples per second);
    format: Word;     // audio data format:
    channels: Byte;
    silence: Byte;
    samples: Word;
    padding: Word;
    size: LongWord;
    callback: Pointer;
    userdata: Pointer;
  end;

  SMPEG_Info = packed record
    has_audio: Integer;
    has_video: Integer;
    width: Integer;
    height: Integer;
    current_frame: Integer;
    current_fps: Double;
    audio_string: array[0..79] of Char;
    audio_current_frame: Integer;
    current_offset: LongWord;
    total_size: LongWord;
    current_time: Double;
    total_time: Double;
  end;

const

  {$ifdef LINUX}
  LibSmpegPath = 'libsmpeg*.so*';
  LibSDLPath = 'libSDL-*.so*';
  {$ELSE}
  LibsmpegPath = 'smpeg.dll';
  LibSDLPath = 'SDL.dll';
  {$ENDIF}

var
  LibsmpegLoaded: Boolean = False;

type

  SMPEG_new_t = function(const filename: PChar; var info: SMPEG_Info; sdl_audio: Integer): PSMPEG; cdecl;
  SMPEG_delete_t = procedure(mpeg: Pointer); cdecl;
  SMPEG_wantedSpec_t = function(mpeg: Pointer; var spec: SDL_AudioSpec): Integer; cdecl;
  SMPEG_actualSpec_t = function(mpeg: Pointer; var spec: SDL_AudioSpec): Integer; cdecl;
  SMPEG_play_t = procedure(mpeg: Pointer); cdecl;
  SMPEG_status_t = function(mpeg: Pointer): Integer; cdecl;
  SMPEG_pause_t = procedure(mpeg: Pointer); cdecl;
  SMPEG_stop_t = procedure(mpeg: Pointer); cdecl;
  SMPEG_playAudio_t = function(mpeg: Pointer; stream: Pointer; len: Integer): Integer; cdecl;
  SMPEG_skip_t = procedure(mpeg: Pointer; Pos: Single); cdecl;
  SMPEG_rewind_t = procedure(mpeg: Pointer); cdecl;
  SMPEG_seek_t = procedure(mpeg: Pointer; bytes: Integer); cdecl;

var
  { Create a new SMPEG object from an MPEG file.
   On return, if 'info' is not NULL, it will be filled with information
   about the MPEG object.
   This function returns a new SMPEG object.  Use SMPEG_error() to find out
   whether or not there was a problem building the MPEG stream.
   The sdl_audio parameter indicates if SMPEG should initialize the SDL audio
   subsystem. If not, you will have to use the SMPEG_playaudio() function below
   to extract the decoded data. }
  SMPEG_new: SMPEG_new_t;
  { Delete an SMPEG object }
  SMPEG_delete: SMPEG_delete_t;
  { Get the best SDL audio spec for the audio stream }
  SMPEG_wantedSpec: SMPEG_wantedSpec_t;
  { Inform SMPEG of the actual SDL audio spec used for sound playback }
  SMPEG_actualSpec: SMPEG_actualSpec_t;
  { Get the current status of an SMPEG object }
  SMPEG_status: SMPEG_status_t;
  { Play an SMPEG object }
  SMPEG_play: SMPEG_play_t;
  { Pause/Resume playback of an SMPEG object }
  SMPEG_pause: SMPEG_pause_t;
  { Stop playback of an SMPEG object }
  SMPEG_stop: SMPEG_stop_t;
  { Exported callback function for audio playback.
    The function takes a buffer and the amount of data to fill, and returns
    the amount of data in bytes that was actually written.  This will be the
    amount requested unless the MPEG audio has finished. }
  SMPEG_playAudio: SMPEG_playAudio_t;
  { Skip 'seconds' seconds in the MPEG stream }
  SMPEG_skip: SMPEG_skip_t;
  { Rewind the play position of an SMPEG object to the beginning of the MPEG }
  SMPEG_rewind: SMPEG_rewind_t;
  { Seek 'bytes' bytes in the MPEG stream }
  SMPEG_seek: SMPEG_seek_t;

  function LoadMPEGLibrary(): Boolean;
  procedure UnloadMPEGLibrary;


implementation

type
  SDL_Init_t = function(Flags: LongWord): Integer; cdecl;
  SDL_Quit_t = procedure; cdecl;

const
  SDL_INIT_AUDIO = $00000010;

var
  {$ifdef LINUX}
  Libhandle: TLibHandle;
  SDLhandle: TLibHandle;
  {$else}
  Libhandle: Cardinal;
  SDLhandle: Cardinal;
  {$endif}
  SDL_Init: SDL_Init_t;
  SDL_Quit: SDL_Quit_t;


function LoadMPEGLibrary(): Boolean;
var
  Path: string;
begin
  Result:=False;

  {$ifdef USE_SDL}
  Path:=LibSDLPath;
  {$ifdef LINUX}
  Path:=FindLibs(LibSDLPath);
  {$endif LINUX}
  SDLhandle:=LoadLibrary(Path);
  if SDLhandle <> NilHandle then
  begin
    SDL_Init:=GetProcAddress(SDLhandle, 'SDL_Init');
    SDL_Quit:=GetProcAddress(SDLhandle, 'SDL_Quit');
    SDL_Init(SDL_INIT_AUDIO);
  end;
  {$endif USE_SDL}

  Path:=LibsmpegPath;
  {$ifdef LINUX}
  Path:=FindLibs(LibsmpegPath);
  {$ENDIF}
  Libhandle:=LoadLibrary(Path);
  if Libhandle = NilHandle then exit;
  if Libhandle <> NilHandle then
  begin
    LibsmpegLoaded:=True;
    SMPEG_new:=GetProcAddress(Libhandle, 'SMPEG_new');
    SMPEG_delete:=GetProcAddress(Libhandle, 'SMPEG_delete');
    SMPEG_wantedSpec:=GetProcAddress(Libhandle, 'SMPEG_wantedSpec');
    SMPEG_actualSpec:=GetProcAddress(Libhandle, 'SMPEG_actualSpec');
    SMPEG_play:=GetProcAddress(Libhandle, 'SMPEG_play');
    SMPEG_status:=GetProcAddress(Libhandle, 'SMPEG_status');
    SMPEG_stop:=GetProcAddress(Libhandle, 'SMPEG_stop');
    SMPEG_playAudio:=GetProcAddress(Libhandle, 'SMPEG_playAudio');
    SMPEG_skip:=GetProcAddress(Libhandle, 'SMPEG_skip');
    SMPEG_rewind:=GetProcAddress(Libhandle, 'SMPEG_rewind');
  end;
  Result:=LibsmpegLoaded;
end;

procedure UnloadMPEGLibrary();
begin
  if Libhandle <> NilHandle then FreeLibrary(Libhandle);
  {$ifdef USE_SDL}
  if SDLhandle <> NilHandle then
  begin
    SDL_Quit;
    FreeLibrary(SDLhandle);
  end;
  {$endif USE_SDL}
  LibsmpegLoaded:=False;
end;

end.
