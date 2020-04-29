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
    FVDriveName: string;
  public
    constructor Create;
    destructor Destroy;
    property DeviceName: string read FDeviceName write FDeviceName;
    property DeviceNumber: integer read FDeviceNumber write FDeviceNumber;
    property ProfileNumber: string read FProfileNumber write FProfileNumber;
    property ProfileName: string read FProfileName write FProfileName;
    property Connected: boolean read FConnected write FConnected;
    property VDriveName: string read FVDriveName write FVDriveName;
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
  FVDriveName := '';
end;

destructor TDevice.Destroy;
begin

end;

end.

