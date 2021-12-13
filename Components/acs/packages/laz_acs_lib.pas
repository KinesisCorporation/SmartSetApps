{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit laz_acs_lib;

{$warn 5023 off : no warning about unused units}
interface

uses
  acs_audio, acs_audiomix, acs_cdrom, acs_classes, acs_converters, acs_file, 
  acs_filters, acs_indicator, acs_misc, acs_mixer, acs_multimix, acs_procs, 
  acs_streams, acs_strings, acs_types, acs_flac, acs_lame, acs_mac, 
  acs_vorbis, acs_wave, acs_allformats, acs_stdaudio, acs_alsaaudio, 
  acs_aolive, acs_volumequery, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('laz_acs_lib', @Register);
end.
