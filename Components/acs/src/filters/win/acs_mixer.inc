
function mixerSetControlDetails(x1: HMIXEROBJ; x2: PMIXERCONTROLDETAILS; x3: DWORD): MMRESULT; stdcall; external 'winmm.dll' name 'mixerSetControlDetails';

function GetMixerName(DevNum: integer): String;
var
  MixerCaps: TMixerCaps;
begin
  // get mixer capatibilities
  Result:='';
  if (DevNum < 0) or (DevNum >= MixersCount) then Exit;
  if mixerGetDevCaps(DevNum, @MixerCaps, SizeOf(TMixerCaps)) <> MMSYSERR_NOERROR then Exit;
  Result:=StrPas(MixerCaps.szPName);
  {$ifdef fpc}
  Result:=WinCPToUtf8(Result);
  {$endif}
end;

function GetChannelfromMask(Mask: DWORD): TAcsMixerChannel;
begin
  case Mask of
  MIXERLINE_COMPONENTTYPE_DST_UNDEFINED  : Result := mcUnknown;
  MIXERLINE_COMPONENTTYPE_DST_DIGITAL    : Result := mcDigital;
  MIXERLINE_COMPONENTTYPE_DST_LINE       : Result := mcLine;
  MIXERLINE_COMPONENTTYPE_DST_MONITOR    : Result := mcMonitor;
  MIXERLINE_COMPONENTTYPE_DST_SPEAKERS   : Result := mcVolume;
  MIXERLINE_COMPONENTTYPE_DST_HEADPHONES : Result := mcHeadphone;
  MIXERLINE_COMPONENTTYPE_DST_TELEPHONE  : Result := mcTelephone;
  MIXERLINE_COMPONENTTYPE_DST_WAVEIN     : Result := mcPCM;
  MIXERLINE_COMPONENTTYPE_DST_VOICEIN    : Result := mcUnknown;
  MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED  : Result := mcUnknown;
  MIXERLINE_COMPONENTTYPE_SRC_DIGITAL    : Result := mcDigital;
  MIXERLINE_COMPONENTTYPE_SRC_LINE       : Result := mcLine;
  MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE : Result := mcMic;
  MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER: Result := mcSynth;
  MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC: Result := mcCD;
  MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE  : Result := mcTelephone;
  MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER  : Result := mcVolume;
  MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT    : Result := mcPCM;
  MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY  : Result := mcAltPCM;
  MIXERLINE_COMPONENTTYPE_SRC_ANALOG     : Result := mcUnknown;
  else                                     Result := mcUnknown;
  end;
end;

procedure TAcsMixer.SetDevNum(Num: Integer);
type
  TData = array [0..3] of MIXERCONTROLDETAILS_UNSIGNED;
  PData = ^TData;
var
  destination, connection: Integer;
  error: Integer;
  data: PData;
  pmxctrl: PMixerControl;
  aLineInfo, aConnLineInfo: TMixerLine;

  procedure GetLineControls(mixLineInfo: TMixerLine);
  var
    j, k, datasize: Integer;
    aLineControl: TMixerLineControls;
    aControlDetails: TMixerControlDetails;
    amixControl: PMixerControl;
    aControl: PControlEntry;
  begin
    with aLineControl do
    begin
      cbStruct  := SizeOf(TMixerLineControls);
      dwLineID  := mixLineInfo.dwLineID;
      cControls := mixLineInfo.cControls;
      cbmxctrl  := SizeOf(TMixerControl);
      GetMem(amixControl, SizeOf(TMixerControl)*mixLineInfo.cControls);
      pamxctrl  := amixControl;
    end;
    error:=mixerGetLineControls(FMixerHandle, @aLineControl, MIXER_GETLINECONTROLSF_ALL);
    if error <> MMSYSERR_NOERROR then Exit;

    pmxctrl:=amixControl;
    for j:=0 to aLineControl.cControls-1 do
    begin
      if  (pmxctrl^.dwControlType <> MIXERCONTROL_CONTROLTYPE_VOLUME)
      and (pmxctrl^.dwControlType <> MIXERCONTROL_CONTROLTYPE_MUTE) then
        Continue;

      if (pmxctrl^.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM) > 0 then
        aControlDetails.cChannels:=1
      else
        aControlDetails.cChannels:=mixLineInfo.cChannels;

      if (pmxctrl^.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE) > 0 then
      begin
        aControlDetails.cMultipleItems:=pmxctrl^.cMultipleItems;
        Getmem(data, pmxctrl^.cMultipleItems*SizeOf(MIXERCONTROLDETAILS_UNSIGNED));
        datasize:=pmxctrl^.cMultipleItems;
      end
      else
      begin
        aControlDetails.cMultipleItems:=0;
        Getmem(data, aControlDetails.cChannels*SizeOf(MIXERCONTROLDETAILS_UNSIGNED));
        datasize:=aControlDetails.cChannels;
      end;

      with aControlDetails do
      begin
        cbStruct    := SizeOf(TmixerControlDetails);
        dwControlID := pmxctrl^.dwControlID;
        cbDetails   := SizeOf(MIXERCONTROLDETAILS_UNSIGNED);
        paDetails   := data;
      end;
      error:=mixerGetControlDetails(FMixerHandle, @aControlDetails, MIXER_GETCONTROLDETAILSF_VALUE);

      if error = MMSYSERR_NOERROR then
      begin
        if (pmxctrl^.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE) then
        begin
          SetLength(FMuteControls, Length(FMuteControls)+1);
          aControl:=@FMuteControls[Length(FMuteControls)-1];
        end
        else
        begin
          SetLength(FControls, Length(FControls)+1);
          aControl:=@FControls[Length(FControls)-1];
          if (pmxctrl^.dwControlType = MIXERCONTROL_CONTROLTYPE_ONOFF) then
            aControl.CName:='AGC??';
        end;

        SetLength(FChannels, Max(Length(FControls), Length(FMuteControls)));
        with aControl^, pmxctrl^, aControlDetails do
        begin
          IsInited           := True;
          CDestination       := mixLineInfo.dwDestination;
          CName              := String(szShortname);
          CComponentTyp      := mixLineInfo.dwComponentType;
          CKanal             := cChannels;
          CID                := dwControlID;
          CConnect           := mixLineInfo.cConnections;
          CCControls         := mixLineInfo.cControls;
          CControl            := fdwControl;
          CControlTyp         := dwControlType;
          CMultItems          := cMultipleItems;
          CMax                := Bounds.lMaximum;
          CMin                := Bounds.lMinimum;
          CcSteps             := Metrics.cSteps;
          for k:=0 to datasize-1 do
            CDetails[k].dwValue:=data^[k].dwvalue;
        end;
        FChannels[Length(FChannels)-1]:=GetChannelfromMask(aControl.CComponentTyp);
      end;

      Freemem(data);
      Inc(pmxctrl);
    end;
    Freemem(amixControl);
  end; // procedure GetLineControls

begin
  if (Num < 0) or (Num >= MixersCount) then Exit;

  SetLength(FChannels, 0);
  SetLength(FControls, 0);
  SetLength(FMuteControls, 0);

  // get mixer capatibilities
  error:=mixerGetDevCaps(Num, @FMixerCaps, SizeOf(TMixerCaps));
  if error <> MMSYSERR_NOERROR then Exit;
  FMixerName:=StrPas(FMixerCaps.szPName);
  {$ifdef fpc}
  FMixerName:=WinCPToUtf8(FMixerName);
  {$endif}

  error:=mixerOpen(@FMixerHandle, Num, 0, 0, MIXER_OBJECTF_MIXER);
  if error <> MMSYSERR_NOERROR then Exit;

  for destination:=0 to FMixerCaps.cDestinations-1 do
  begin
    aLineInfo.cbStruct      := SizeOf(TMixerLine);
    aLineInfo.dwDestination := destination;
    error:=mixerGetLineInfo(FMixerHandle, @aLineInfo, MIXER_GETLINEINFOF_DESTINATION);
    if error <> MMSYSERR_NOERROR then Continue;
    //if aLineInfo.dwComponentType <> MIXERLINE_COMPONENTTYPE_DST_SPEAKERS then
    //  Continue;

    GetLineControls(aLineInfo);
    for connection:=0 to aLineInfo.cConnections-1 do
    begin
      with aConnLineInfo do
      begin
        cbStruct      := SizeOf(TMixerLine);
        dwDestination := destination;
        dwSource      := connection;
      end;
      error := mixerGetLineInfo(FMixerHandle, @aConnLineInfo, MIXER_GETLINEINFOF_SOURCE);
      GetLineControls(aConnLineInfo);
    end;
  end;
end;

function TAcsMixer.GetVolume(vChannel: Integer): TAcsMixerLevel;
type
  TData = array [0..3] of MIXERCONTROLDETAILS_UNSIGNED;
  PData = ^TData;
var
  data: PData;
  aControldetails: TMixerControlDetails;
  datasize, k: Integer;
begin
  Result.Left:=0;
  Result.Right:=0;
  Result.Main:=0;
  if vChannel >= Length(FControls) then Exit;
  if FControls[vChannel].IsInited = False then Exit;

  if (FControls[vChannel].CControl AND MIXERCONTROL_CONTROLF_UNIFORM) > 0 then
    aControlDetails.cChannels:=1
  else
    aControlDetails.cChannels:=FControls[vChannel].CKanal;
  if (FControls[vChannel].CControl AND MIXERCONTROL_CONTROLF_MULTIPLE) > 0 then
  begin
    aControlDetails.cMultipleItems:=FControls[vChannel].CMultItems;
    Getmem(data, FControls[vChannel].CMultItems*SizeOf(MIXERCONTROLDETAILS_UNSIGNED));
    datasize:=FControls[vChannel].CMultItems;
  end
  else
  begin
    aControlDetails.cMultipleItems:=0;
    Getmem(data, aControlDetails.cChannels*SizeOf(MIXERCONTROLDETAILS_UNSIGNED));
    datasize:=aControlDetails.cChannels;
  end;

  with aControlDetails do
  begin
    cbStruct       := SizeOf(TMixerControlDetails);
    dwControlID    := FControls[vChannel].CID;
    cChannels      := FControls[vChannel].CKanal;
    cMultipleItems := FControls[vChannel].CMultItems;
    cbDetails      := SizeOf(MIXERCONTROLDETAILS_Signed);
    padetails      := data;
  end;
  mixerGetControlDetails(FMixerHandle, @aControlDetails, MIXER_GETCONTROLDETAILSF_VALUE);

  with FControls[vChannel] do
  begin
    for k:=0 to datasize-1 do CDetails[k].dwValue:=data^[k].dwvalue;
  end;
  Freemem(data);

  if IsStereo(vChannel) then
  begin
    Result.Left:=Round((FControls[vChannel].CDetails[0].dwValue*255)/FControls[vChannel].Cmax);
    Result.Right:=Round((FControls[vChannel].CDetails[1].dwValue*255)/FControls[vChannel].Cmax);
  end
  else
    Result.Main:=Round((FControls[vChannel].CDetails[0].dwValue*255)/FControls[vChannel].Cmax);
end;

procedure TAcsMixer.SetVolume(vChannel: Integer; vLevel: TAcsMixerLevel);
var
  aControlDetails: TMixerControlDetails;
begin
  if vChannel >= length(FControls) then Exit;
  if IsStereo(vChannel) then
  begin
    FControls[vChannel].CDetails[0].dwValue := Round((vLevel.Left*FControls[vChannel].CMax)/255);
    FControls[vChannel].CDetails[1].dwValue := Round((vLevel.Right*FControls[vChannel].CMax)/255);
  end
  else
    FControls[vChannel].CDetails[0].dwValue := Round((vLevel.Main*FControls[vChannel].CMax)/255);

  with aControlDetails do
  begin
    cbStruct       := SizeOf(TMixerControlDetails);
    dwControlID    := FControls[vChannel].CID;
    cChannels      := FControls[vChannel].CKanal;
    cMultipleItems := 0;
    cbDetails      := SizeOf(MIXERCONTROLDETAILS_Signed);
    padetails      := @FControls[vChannel].CDetails;
  end;
  mixerSetControlDetails(FMixerHandle, @aControlDetails, MIXER_SETCONTROLDETAILSF_Value);
end;

function TAcsMixer.IsStereo(vChannel : Integer): Boolean;
begin
  Result:=False;
  if vChannel >= Length(FControls) then Exit;
  Result:= not (FControls[vChannel].CKanal=1);
end;

function TAcsMixer.GetMute(vChannel: Integer): Boolean;
type
  TData = array [0..3] of MIXERCONTROLDETAILS_UNSIGNED;
  PData = ^TData;
var
  data: PData;
  aControldetails: TMixerControlDetails;
  datasize, k: Integer;
begin
  Result:=False;
  if vChannel >= length(FMuteControls) then Exit;
  if FMuteControls[vChannel].IsInited = False then Exit;

  if (FMuteControls[vChannel].CControl AND MIXERCONTROL_CONTROLF_UNIFORM) > 0 then
    aControlDetails.cChannels:=1
  else
    aControlDetails.cChannels:=FMuteControls[vChannel].CKanal;

  if (FMuteControls[vChannel].CControl AND MIXERCONTROL_CONTROLF_MULTIPLE) > 0 then
  begin
    aControlDetails.cMultipleItems:=FMuteControls[vChannel].CMultItems;
    Getmem(data, FMuteControls[vChannel].CMultItems*SizeOf(MIXERCONTROLDETAILS_UNSIGNED));
    datasize:=FMuteControls[vChannel].CMultItems;
  end
  else
  begin
    aControlDetails.cMultipleItems:=0;
    Getmem(data, aControlDetails.cChannels*SizeOf(MIXERCONTROLDETAILS_UNSIGNED));
    datasize:=aControlDetails.cChannels;
  end;

  with aControlDetails do
  begin
    cbStruct       := SizeOf(TMixerControlDetails);
    dwControlID    := FMuteControls[vChannel].CID;
    cChannels      := FMuteControls[vChannel].CKanal;
    cMultipleItems := FMuteControls[vChannel].CMultItems;
    cbDetails      := SizeOf(MIXERCONTROLDETAILS_Signed);
    padetails      := data;
  end;

  mixerGetControlDetails(FMixerHandle, @aControlDetails, MIXER_GETCONTROLDETAILSF_VALUE );
  with FMuteControls[vChannel] do
  begin
    for k:=0 to datasize-1 do
      CDetails[k].dwValue:=data^[k].dwvalue;
  end;
  Freemem(data);

  Result:=(FMuteControls[vChannel].CDetails[0].dwValue = 1);
end;
  
procedure TAcsMixer.SetMute(vChannel: Integer; Mute: Boolean);
var
  aControlDetails: TMixerControlDetails;
begin
  if vChannel >= Length(FMuteControls) then Exit;
  if FMuteControls[vChannel].IsInited = False then Exit;

  if Mute then
    FMuteControls[vChannel].CDetails[0].dwValue:=1
  else
    FMuteControls[vChannel].CDetails[0].dwValue:=0;

  with aControlDetails do
  begin
    cbStruct       := SizeOf(TMixerControlDetails);
    dwControlID    := FMuteControls[vChannel].CID;
    cChannels      := FMuteControls[vChannel].CKanal;
    cMultipleItems := 0;
    cbDetails      := SizeOf(MIXERCONTROLDETAILS_Signed);
    padetails      := @FMuteControls[vChannel].CDetails;
  end;
  mixerSetControlDetails(FMixerHandle, @aControlDetails, MIXER_SETCONTROLDETAILSF_Value);
end;

function TAcsMixer.IsRecordable(vChannel: Integer): Boolean;
begin
  { TODO : IsRecordable }
  Result:=False;
end;

procedure TAcsMixer.SetRecSource(vChannel: Integer);
begin
  { TODO : SetRecSource }
end;

function TAcsMixer.GetRecSource: Integer;
begin
  { TODO : GetRecSource }
  Result:=-1;
end;

function TAcsMixer.GetControl(vControl: Integer): TControlEntry;
begin
  if vControl<length(FControls) then
    Result := FControls[vControl];
end;

function TAcsMixer.GetControlCount: Integer;
begin
  Result := length(FControls);
end;

destructor TAcsMixer.Destroy;
begin
  Setlength(FControls, 0);
  Setlength(FMuteControls, 0);
  Setlength(FChannels, 0);
  inherited Destroy;
end;

function CountMixers: Byte;
begin
  Result:=mixerGetNumDevs;
end;

