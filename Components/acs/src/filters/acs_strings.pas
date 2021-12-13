(*
  this file is a part of audio components suite v 2.4.
  see the license file for more details.
  you can contact me at mail@z0m3ie.de
*)

unit acs_strings;

interface

resourcestring
  strCoudntloadLib              = 'Library %s could not be loaded.';
  strcoudntopendevice           = 'Could not open device "%s" for input';
  strCoudntopendeviceOut        = 'Could not open device "%s" for output';
  strBusy                       = 'The component is busy';
  strInputstartfailed           = 'Failed to start input';
  strFailedtostartOutput        = 'Failed to start output';
  strStreamnotopen              = 'The Stream is not opened';
  strBufferoverrun              = 'Buffer overrun.';
  strUnknownExtension           = 'Unknown file extension %s';
  strAllFormats                 = 'All formats';
  strInputnotAssigned           = 'Input not Assigned';
  strFilenamenotassigned        = 'Filename not Assigned';
  strSeeknotImplemented         = 'Seek: method not implemented';
  strNotinFBMode                = 'The component is not in amFB mode.';
  strIllegalFrequency           = 'Illegal frequency';
  strCutofftolow                = 'Cut-off frequencies are greater than the half of the sample rate.';
  strListIndexOOB               = 'List Index Out of Bounds %d';
  strNoInputItems               = 'No input items in the list.';
  strNoInputAssigned            = 'No input assigned to current item';
  strStreamObjectnotassigned    = 'Stream object not assigned';
  strBufferunderrun             = 'Buffer underrun';
  strDevnotplayable             = 'Cannot play on the device "%s"';
  strTrackOutofRange            = 'Track out of range';
  strNoAudioCD                  = 'Not an audio disc';
  strChannelNotRecordable       = 'Channel %d is not recordable';
  strDrivenotready              = 'The drive is not ready';
  strnoAudioTreck               = 'This is no audio track';
  strChannelNotAvailable        = 'Channel %d is not available';
  strFailedtoCreateDSdev        = 'Failed to create DirectSound device';
  strFailedtoCreateDSbuf        = 'Failed to create DirectSound buffer';
  strnoDriverselected           = 'No driver is selected, please select an driver first !';
  strnoFileOpened               = 'No file opened !';

  strMixerVolume                = 'Master output';
  strMixerTreble                = 'Treble output';
  strMixerBass                  = 'Bass output';
  strMixerSynth                 = 'Synthesizer input';
  strMixerPCM                   = 'Audio output';
  strMixerSpeaker               = 'Speaker output';
  strMixerLine                  = 'Line input';
  strMixerMic                   = 'Michrophone input';
  strMixerCD                    = 'CD input';
  strMixerIMix                  = 'Record monitor';
  strMixerAlt                   = 'Alternate output';
  strMixerRec                   = 'Record level';
  strMixerUnknown               = 'Unknown channel';

implementation

end.
