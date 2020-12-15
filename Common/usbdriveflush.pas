unit USBDriveFlush;

interface

  uses Windows, SysUtils, jwawinbase, JwaWinIoctl;

function FlushUSBDrive(const Drive: string): Boolean;

implementation

type
  // Taken from JEDI JwaWinIoctl
  PSTORAGE_HOTPLUG_INFO = ^STORAGE_HOTPLUG_INFO;
  {$EXTERNALSYM PSTORAGE_HOTPLUG_INFO}
  _STORAGE_HOTPLUG_INFO = record
    Size: DWORD; // version
    MediaRemovable: BOOLEAN; // ie. zip, jaz, cdrom, mo, etc. vs hdd
    MediaHotplug: BOOLEAN;   // ie. does the device succeed a lock
                             // even though its not lockable media?
    DeviceHotplug: BOOLEAN;  // ie. 1394, USB, etc.
    WriteCacheEnableOverride: BOOLEAN; // This field should not be
                             // relied upon because it is no longer used
  end;
  {$EXTERNALSYM _STORAGE_HOTPLUG_INFO}
  STORAGE_HOTPLUG_INFO = _STORAGE_HOTPLUG_INFO;
  {$EXTERNALSYM STORAGE_HOTPLUG_INFO}
  TStorageHotplugInfo = STORAGE_HOTPLUG_INFO;
  PStorageHotplugInfo = PSTORAGE_HOTPLUG_INFO;




function FlushUSBDrive(const Drive: string): Boolean;
var
  shpi : TStorageHotplugInfo;
  retlen : LPDWORD; //unneeded, but deviceiocontrol expects it
  h : THandle;
  szVolumeAccessPath: string;
begin
  Result := False;
  szVolumeAccessPath := Format('\\.\%s:', [Drive]);
  try
    h := CreateFile(PChar(szVolumeAccessPath), 0, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
    //h := CreateFile(PChar('\\.\' + Drive),
    //                0,
    //                FILE_SHARE_READ or FILE_SHARE_WRITE,
    //                nil,
    //                OPEN_EXISTING,
    //                0,
    //                0);
    if (h <> INVALID_HANDLE_VALUE) then
    begin
      shpi.Size := SizeOf(shpi);

      if DeviceIoControl(h,
                         IOCTL_STORAGE_GET_HOTPLUG_INFO,
                         nil,
                         0,
                         @shpi,
                         SizeOf(shpi),
                         retlen,
                         nil) then
      begin
        //shpi now has the existing values, so you can check to
        //see if the device is already hot-pluggable
        //if not shpi.DeviceHotplug then
        begin
          shpi.DeviceHotplug:= True;

          //Need to use correct administrator security privilages here
          //otherwise it'll just give 'access is denied' error
          Result := DeviceIoControl(h,
                                    IOCTL_STORAGE_SET_HOTPLUG_INFO,
                                     @shpi,
                                     SizeOf(shpi),
                                     nil,
                                     0,
                                     retlen,
                                     nil);
        end;
      end;
    end;
  finally
      CloseHandle(h);
  end;


end;



  end.
