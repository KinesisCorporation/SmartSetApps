unit u_kinesis_device;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs;

type

  { TDevice }
  TDevice = class
  private
    FDeviceName: string;
    FDeviceNumber: integer;
    FProfileNumber: string;
    FProfileName: string;
    FConnected: boolean;
    FReadWriteAccess: boolean;
    FVDriveName: string;
    FFutureDevice: boolean;
    FTutorialUrl: string;
    FDriveLetter: string;
    FRootFolder: string;
    FScanVDriveHint: string;
    FVersionFile: string;
    FVersionFolder: string;
    FSettingsFile: string;
    FSettingsFolder: string;
  public
    constructor Create;
    destructor Destroy;
    property DeviceName: string read FDeviceName write FDeviceName;
    property DeviceNumber: integer read FDeviceNumber write FDeviceNumber;
    property ProfileNumber: string read FProfileNumber write FProfileNumber;
    property ProfileName: string read FProfileName write FProfileName;
    property Connected: boolean read FConnected write FConnected;
    property ReadWriteAccess: boolean read FReadWriteAccess write FReadWriteAccess;
    property VDriveName: string read FVDriveName write FVDriveName;
    property FutureDevice: boolean read FFutureDevice write FFutureDevice;
    property TutorialUrl: string read FTutorialUrl write FTutorialUrl;
    property DriveLetter: string read FDriveLetter write FDriveLetter;
    property RootFolder: string read FRootFolder write FRootFolder;
    property ScanVDriveHint: string read FScanVDriveHint write FScanVDriveHint;
    property VersionFolder: string read FVersionFolder write FVersionFolder;
    property VersionFile: string read FVersionFile write FVersionFile;
    property SettingsFolder: string read FSettingsFolder write FSettingsFolder;
    property SettingsFile: string read FSettingsFile write FSettingsFile;
  end;

  { TKeyList }

  { TDeviceList }

  TDeviceList = class(TObjectList)
  private
    function GetItem(index: integer): TDevice;
    procedure SetItem(Index: integer; AObject: TDevice);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AObject: TDevice): integer; reintroduce; virtual;
    function Remove(AObject: TDevice): integer; reintroduce; virtual;
    property Items[index: integer]: TDevice read GetItem write SetItem; default;
  end;

implementation

{ TDeviceList }

function TDeviceList.GetItem(index: integer): TDevice;
begin
  Result := nil;
  try
    Result := inherited Items[Index] as TDevice
  except
  end;
end;

procedure TDeviceList.SetItem(Index: integer; AObject: TDevice);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TDeviceList.Create;
begin
  inherited Create;
  OwnsObjects := True;
end;

destructor TDeviceList.Destroy;
begin
  inherited Destroy;
end;

function TDeviceList.Add(AObject: TDevice): integer;
begin
  Result := inherited Add(AObject);
end;

function TDeviceList.Remove(AObject: TDevice): integer;
begin
  Result := inherited Remove(AObject);
end;

{ TDevice }

constructor TDevice.Create;
begin
  FDeviceName := '';
  FDeviceNumber := 0;
  FProfileNumber := '';
  FProfileName := '';
  FConnected := false;
  FReadWriteAccess := true;
  FVDriveName := '';
  FFutureDevice := false;
  FDriveLetter := '';
  FRootFolder := '';
  FScanVDriveHint := '';
  FVersionFile := 'version.txt';
  FSettingsFile := 'kbd_settings.txt';
  FVersionFolder := 'firmware';
  FSettingsFolder := 'settings';
end;

destructor TDevice.Destroy;
begin

end;

end.

