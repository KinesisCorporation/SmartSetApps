{
CD-ROM for Windows

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
}

{ Dummy file, not supported on Win64 }

constructor TAcsCDIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLibLoaded := False;
  FStreamDisabled := True;
  AppPath := ExtractFilePath(ParamStr(0));
  if AppPath[length(AppPath)] <> '\' then AppPath := AppPath + '\';
  //FillChar(FCDList, SizeOf(FCDList), 0);
  //FCDList.max := MAXCDLIST;
end;

destructor TAcsCDIn.Destroy();
begin
  if Active then Done();
  CloseCD();
  //UnloadCDRip();
  inherited Destroy;
end;

procedure TAcsCDIn.OpenCD();
begin
end;

procedure TAcsCDIn.CloseCD();
begin
end;

function TAcsCDIn.GetInfo(): TAcsCDInfo;
begin
end;

function TAcsCDIn.GetStatus(): TAcsCDStatus;
begin
  Result := cdsNotReady;
end;

function TAcsCDIn.GetNumTracks(): Integer;
begin
end;

function TAcsCDIn.GetTrackInfo(const vIndex : Integer) : TAcsCDTrackInfo;
begin
end;

procedure TAcsCDIn.SetST(Track: Integer);
begin
end;

procedure TAcsCDIn.SetET(Track: Integer);
begin
end;

procedure TAcsCDIn.SetSP(Pos: TAcsCDPosition);
begin
end;

procedure TAcsCDIn.SetEP(Pos: TAcsCDPosition);
begin
end;

function TAcsCDIn.GetSize(): Integer;
begin
end;

procedure TAcsCDIn.Init();
begin
  raise EAcsException.Create(strDrivenotready);
end;

procedure TAcsCDIn.Done();
begin
  inherited Done();
end;

function TAcsCDIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
begin
  Result := 0;
end;

procedure TAcsCDIn.SetCurrentDrive(Value: Integer);
begin
end;

function TAcsCDIn.GetDrivesCount(): Integer;
begin
  Result := 0;
end;

function TAcsCDIn.GetDriveName(): string;
begin
  Result := 'Not supported';
end;

function CDTrayControl(const ADriveName: string; AEject: Boolean): Boolean;
var
  Res: MciError;
  OpenParm: TMCI_Open_Parms;
  Flags: DWord;
  S: string;
begin
  Result := False;
  OpenParm.dwCallback:= 0;
  OpenParm.lpstrDeviceType := 'CDAudio';
  Flags := MCI_OPEN_TYPE;

  S := ADriveName + ':';
  if GetDriveType(PChar(S)) = DRIVE_CDROM then
  begin
    Flags := MCI_OPEN_TYPE or MCI_OPEN_ELEMENT;
    OpenParm.lpstrElementName := PChar(S);
  end;

  Res := mciSendCommand(0, MCI_OPEN, Flags, PtrInt(@OpenParm));
  if Res <> 0 then
    Exit;
  try
    if AEject then
      Res := mciSendCommand(OpenParm.wDeviceID, MCI_SET, MCI_SET_DOOR_OPEN, 0)
    else
      Res := mciSendCommand(OpenParm.wDeviceID, MCI_SET, MCI_SET_DOOR_CLOSED, 0);
    Result := (Res = 0);
  finally
    mciSendCommand(OpenParm.wDeviceID, MCI_CLOSE, Flags, PtrInt(@OpenParm));
  end;
end;

function TAcsCDIn.Eject(): Boolean;
begin
  Result := CDTrayControl(DriveName, True);
end;

function TAcsCDIn.CloseTray(): Boolean;
begin
  Result := CDTrayControl(DriveName, False);
end;

