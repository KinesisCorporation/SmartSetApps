unit Eject_USB;

interface

uses
  Windows,
  SysUtils;

function EjectUSB(const DriveLetter: string): boolean;

implementation

type
  DEVICE_TYPE = DWORD;
  _DEVINST = DWORD;
  HDEVINFO = Pointer;
  PPNP_VETO_TYPE = ^PNP_VETO_TYPE;
  PNP_VETO_TYPE = DWORD;
  RETURN_TYPE = DWORD;
  CONFIGRET = RETURN_TYPE;

const
  PNP_VetoTypeUnknown = 0;   // Name is unspecified

type
  PSPDeviceInterfaceDetailDataA = ^TSPDeviceInterfaceDetailDataA;
  SP_DEVICE_INTERFACE_DETAIL_DATA_A = packed record
    cbSize: DWORD;
    DevicePath: array [0..ANYSIZE_ARRAY - 1] of AnsiChar;
  end;
  TSPDeviceInterfaceDetailDataA = SP_DEVICE_INTERFACE_DETAIL_DATA_A;
  TSPDeviceInterfaceDetailData = TSPDeviceInterfaceDetailDataA;
  PSPDeviceInterfaceDetailData = PSPDeviceInterfaceDetailDataA;

  PSPDeviceInterfaceData = ^TSPDeviceInterfaceData;
  SP_DEVICE_INTERFACE_DATA = packed record
    cbSize: DWORD;
    InterfaceClassGuid: TGUID;
    Flags: DWORD;
    Reserved: ULONG_PTR;
  end;
  TSPDeviceInterfaceData = SP_DEVICE_INTERFACE_DATA;

  PSPDevInfoData = ^TSPDevInfoData;
  SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD; // DEVINST handle
    Reserved: ULONG_PTR;
  end;
  TSPDevInfoData = SP_DEVINFO_DATA;

  _STORAGE_DEVICE_NUMBER = record
    DeviceType: DEVICE_TYPE;
    DeviceNumber: DWORD;
    PartitionNumber: DWORD;
  end;
  STORAGE_DEVICE_NUMBER = _STORAGE_DEVICE_NUMBER;

const
  CR_SUCCESS = $00000000;
  DIGCF_PRESENT = $00000002;
  DIGCF_DEVICEINTERFACE = $00000010;
  FILE_DEVICE_MASS_STORAGE = $0000002d;
  FILE_ANY_ACCESS = 0;
  METHOD_BUFFERED = 0;
  IOCTL_STORAGE_BASE = FILE_DEVICE_MASS_STORAGE;
  IOCTL_STORAGE_GET_DEVICE_NUMBER =
    (IOCTL_STORAGE_BASE shl 16) or (FILE_ANY_ACCESS shl 14) or
    ($0420 shl 2) or (METHOD_BUFFERED);

const
  GUID_DEVINTERFACE_DISK: TGUID = (
    D1: $53f56307; D2: $b6bf; D3: $11d0; D4: ($94, $f2, $00, $a0, $c9, $1e, $fb, $8b));
  GUID_DEVINTERFACE_CDROM: TGUID = (
    D1: $53f56308; D2: $b6bf; D3: $11d0; D4: ($94, $f2, $00, $a0, $c9, $1e, $fb, $8b));
  GUID_DEVINTERFACE_FLOPPY: TGUID = (
    D1: $53f56311; D2: $b6bf; D3: $11d0; D4: ($94, $f2, $00, $a0, $c9, $1e, $fb, $8b));

type
  TCM_Get_Parent = function(var dnDevInstParent: _DEVINST; dnDevInst: _DEVINST;
    ulFlags: ULONG): CONFIGRET; stdcall;
  TCM_Request_Device_Eject = function(dnDevInst: _DEVINST;
    pVetoType: PPNP_VETO_TYPE;     // OPTIONAL
    pszVetoName: PTSTR;            // OPTIONAL
    ulNameLength: ULONG; ulFlags: ULONG): CONFIGRET; stdcall;
  TSetupDiGetClassDevs = function(ClassGuid: PGUID; const aEnumerator: PTSTR;
    hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall;
  TSetupDiEnumDeviceInterfaces = function(DeviceInfoSet: HDEVINFO;
    DeviceInfoData: PSPDevInfoData; const InterfaceClassGuid: TGUID;
    MemberIndex: DWORD; var DeviceInterfaceData: TSPDeviceInterfaceData): BOOL; stdcall;
  TSetupDiGetDeviceInterfaceDetail = function(DeviceInfoSet: HDEVINFO;
    DeviceInterfaceData: PSPDeviceInterfaceData;
    DeviceInterfaceDetailData: PSPDeviceInterfaceDetailData;
    DeviceInterfaceDetailDataSize: DWORD; var RequiredSize: DWORD;
    Device: PSPDevInfoData): BOOL; stdcall;
  TSetupDiDestroyDeviceInfoList = function(DeviceInfoSet: HDEVINFO): BOOL; stdcall;



  function EjectUSB(const DriveLetter: string): boolean;
  const
    CfgMgrDllName = 'cfgmgr32.dll';
    SetupApiModuleName = 'SetupApi.dll';
  var
    CM_Get_Parent: TCM_Get_Parent;
    CM_Request_Device_Eject: TCM_Request_Device_Eject;
    SetupDiGetClassDevs: TSetupDiGetClassDevs;
    SetupDiEnumDeviceInterfaces: TSetupDiEnumDeviceInterfaces;
    SetupDiGetDeviceInterfaceDetail: TSetupDiGetDeviceInterfaceDetail;
    SetupDiDestroyDeviceInfoList: TSetupDiDestroyDeviceInfoList;
  var
    CfgMgrApiLib: HINST;
    SetupApiLib: HINST;

    function GetDrivesDevInstByDeviceNumber(DeviceNumber: LONG; DriveType: UINT; szDosDeviceName: PChar): _DEVINST;
    var
      StorageGUID: TGUID;
      IsFloppy: boolean;
      hDevInfo: Pointer; //HDEVINFO;
      dwIndex: DWORD;
      res: BOOL;
      pspdidd: PSPDeviceInterfaceDetailData;
      spdid: SP_DEVICE_INTERFACE_DATA;
      spdd: SP_DEVINFO_DATA;
      dwSize: DWORD;
      hDrive: THandle;
      sdn: STORAGE_DEVICE_NUMBER;
      dwBytesReturned: DWORD;
    begin
      Result := 0;

      IsFloppy := pos('\\Floppy', szDosDeviceName) > 0; // who knows a better way?
      case DriveType of
        DRIVE_REMOVABLE:
          if (IsFloppy) then
            StorageGUID := GUID_DEVINTERFACE_FLOPPY
          else
            StorageGUID := GUID_DEVINTERFACE_DISK;
        DRIVE_FIXED: StorageGUID := GUID_DEVINTERFACE_DISK;
        DRIVE_CDROM: StorageGUID := GUID_DEVINTERFACE_CDROM;
        else
          exit
      end;

      // Get device interface info set handle for all devices attached to system
      hDevInfo := SetupDiGetClassDevs(@StorageGUID, nil, 0, DIGCF_PRESENT or DIGCF_DEVICEINTERFACE);
      if (NativeUInt(hDevInfo) <> INVALID_HANDLE_VALUE) then
        try
          // Retrieve a context structure for a device interface of a device information set
          dwIndex := 0;
          //PSP_DEVICE_INTERFACE_DETAIL_DATA pspdidd = (PSP_DEVICE_INTERFACE_DETAIL_DATA)Buf;
          spdid.cbSize := SizeOf(spdid);

          while True do
          begin
            res := SetupDiEnumDeviceInterfaces(hDevInfo, nil, StorageGUID, dwIndex, spdid);
            if not res then break;

            dwSize := 0;
            SetupDiGetDeviceInterfaceDetail(hDevInfo, @spdid, nil, 0, dwSize, nil);
            // check the buffer size

            if (dwSize <> 0) then
            begin
              pspdidd := AllocMem(dwSize);
              try
                pspdidd^.cbSize := SizeOf(TSPDeviceInterfaceDetailData);
                ZeroMemory(@spdd, sizeof(spdd));
                spdd.cbSize := SizeOf(spdd);
                res := SetupDiGetDeviceInterfaceDetail(hDevInfo, @spdid, pspdidd, dwSize, dwSize, @spdd);
                if res then
                begin
                  // open the disk or cdrom or floppy
                  hDrive := CreateFile(pspdidd^.DevicePath, 0, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
                  if (hDrive <> INVALID_HANDLE_VALUE) then
                    try
                      // get its device number
                      dwBytesReturned := 0;
                      res := DeviceIoControl(hDrive, IOCTL_STORAGE_GET_DEVICE_NUMBER, nil, 0, @sdn, sizeof(sdn), dwBytesReturned, nil);
                      if res then
                      begin
                        if (DeviceNumber = sdn.DeviceNumber) then
                        begin  // match the given device number with the one of the current device
                          Result := spdd.DevInst;
                          exit;
                        end;
                      end;
                    finally
                      CloseHandle(hDrive);
                    end;
                end;
              finally
                FreeMem(pspdidd);
              end;
            end;
            Inc(dwIndex);
          end;
        finally
          SetupDiDestroyDeviceInfoList(hDevInfo);
        end;
    end;

    function ReallyEjectUSB(const DriveLetter: char): boolean;
    var
      szRootPath, szDevicePath: string;
      szVolumeAccessPath: string;
      hVolume: THandle;
      DeviceNumber: LONG;
      sdn: STORAGE_DEVICE_NUMBER;
      dwBytesReturned: DWORD;
      res: BOOL;
      resCM: cardinal;
      DriveType: UINT;
      szDosDeviceName: array [0..MAX_PATH - 1] of char;
      DevInst: _DEVINST;
      VetoType: PNP_VETO_TYPE;
      VetoName: array [0..MAX_PATH - 1] of WCHAR;
      DevInstParent: _DEVINST;
      tries: integer;
    begin
      Result := False;

      szRootPath := DriveLetter + ':\';
      szDevicePath := DriveLetter + ':';
      szVolumeAccessPath := Format('\\.\%s:', [DriveLetter]);

      DeviceNumber := -1;
      // open the storage volume
      hVolume := CreateFile(PChar(szVolumeAccessPath), 0, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
      if (hVolume <> INVALID_HANDLE_VALUE) then
        try
          //get the volume's device number
          dwBytesReturned := 0;
          res := DeviceIoControl(hVolume, IOCTL_STORAGE_GET_DEVICE_NUMBER, nil, 0, @sdn, SizeOf(sdn), dwBytesReturned, nil);
          if res then DeviceNumber := sdn.DeviceNumber;
        finally
          CloseHandle(hVolume);
        end;
      if DeviceNumber = -1 then exit;

      // get the drive type which is required to match the device numbers correctely
      DriveType := GetDriveType(PChar(szRootPath));

      // get the dos device name (like \device\floppy0) to decide if it's a floppy or not - who knows a better way?
      QueryDosDevice(PChar(szDevicePath), szDosDeviceName, MAX_PATH);

      // get the device instance handle of the storage volume by means of a SetupDi enum and matching the device number
      DevInst := GetDrivesDevInstByDeviceNumber(DeviceNumber, DriveType, szDosDeviceName);

      if (DevInst = 0) then exit;

      VetoType := PNP_VetoTypeUnknown;

      // get drives's parent, e.g. the USB bridge, the SATA port, an IDE channel with two drives!
      DevInstParent := 0;
      resCM := CM_Get_Parent(DevInstParent, DevInst, 0);

      for tries := 0 to 3 do // sometimes we need some tries...
      begin
        FillChar(VetoName[0], SizeOf(VetoName), 0);

        // CM_Query_And_Remove_SubTree doesn't work for restricted users
        //resCM = CM_Query_And_Remove_SubTree(DevInstParent, &VetoType, VetoNameW, MAX_PATH, CM_REMOVE_NO_RESTART); // CM_Query_And_Remove_SubTreeA is not implemented under W2K!
        //resCM = CM_Query_And_Remove_SubTree(DevInstParent, NULL, NULL, 0, CM_REMOVE_NO_RESTART);  // with messagebox (W2K, Vista) or balloon (XP)

        resCM := CM_Request_Device_Eject(DevInstParent, @VetoType, @VetoName[0], Length(VetoName), 0);
        resCM := CM_Request_Device_Eject(DevInstParent, nil, nil, 0, 0);
        // optional -> shows messagebox (W2K, Vista) or balloon (XP)

        Result := (resCM = CR_SUCCESS) and (VetoType = PNP_VetoTypeUnknown);
        if Result then break;

        Sleep(500); // required to give the next tries a chance!
      end;

    end;

  begin
    Result := False;
    CfgMgrApiLib := LoadLibrary(CfgMgrDllName);
    SetupApiLib := LoadLibrary(SetupApiModuleName);
    try
      if (CfgMgrApiLib <> 0) and (SetupApiLib <> 0) then
      begin
        pointer(CM_Get_Parent) := GetProcAddress(CfgMgrApiLib, 'CM_Get_Parent');
        pointer(CM_Request_Device_Eject) := GetProcAddress(SetupApiLib, 'CM_Request_Device_EjectA');
        pointer(SetupDiGetClassDevs) := GetProcAddress(SetupApiLib, 'SetupDiGetClassDevsA');
        pointer(SetupDiEnumDeviceInterfaces) := GetProcAddress(SetupApiLib, 'SetupDiEnumDeviceInterfaces');
        pointer(SetupDiGetDeviceInterfaceDetail) := GetProcAddress(SetupApiLib, 'SetupDiGetDeviceInterfaceDetailA');
        pointer(SetupDiDestroyDeviceInfoList) := GetProcAddress(SetupApiLib, 'SetupDiDestroyDeviceInfoList');
        Result := ReallyEjectUSB(DriveLetter[1]);
      end;
    finally
      if CfgMgrApiLib <> 0 then FreeLibrary(CfgMgrApiLib);
      if SetupApiLib <> 0 then FreeLibrary(SetupApiLib);
    end;
  end;


begin
  //try
  //  if EjectUSB('F') then
  //    Writeln('Success')
  //  else
  //    Writeln('Failed');
  //except
  //  on E: Exception do
  //    Writeln(E.ClassName, ': ', E.Message);
  //end;
  //Readln;
end.
