unit u_common_ui;

{$mode objfpc}{$H+}

interface

uses
  Forms, Classes, SysUtils, StdCtrls, graphics, controls, buttons, extctrls, dialogs,
  u_kinesis_device, eject_USB, u_const, u_key_service, HSSpeedButton, ColorSpeedButtonCS,
  LabelBox, U_Keys, u_key_layer, contnrs, u_file_service, u_base_key_service, BCButton;

type
{ TMenuAction }

TMenuAction = class
private
  FActionType: TMenuActionType;
  FName: string;
  FActionButton: TSpeedButton;
  FActionButton2: TColorSpeedButtonCS;
  FActionImage: TImage;
  FActionLabel: TLabel;
  FMenuConfig: integer;
  FPopupMenu: boolean;
  FStayDown: boolean;
  FMustSelectKey: boolean;
  FIsEnabled: boolean;
  FIsDown: boolean;
  FLedMode: TLedMode;
protected
  procedure SetIsDown(value: boolean);
public
  constructor Create(aType: TMenuActionType; actionButton: TSpeedButton; actionLabel: TLabel; actionImage: TImage;
    menuConfig: integer; ledMode: TLedMode; popupMenu: boolean; bStayDown: boolean; bMustSelectKey: boolean; bIsEnabled: boolean = true);
  constructor Create2(aType: TMenuActionType; actionButton: TColorSpeedButtonCS; actionLabel: TLabel; actionImage: TImage;
    menuConfig: integer; ledMode: TLedMode; popupMenu: boolean; bStayDown: boolean; bMustSelectKey: boolean; bIsEnabled: boolean = true);
  property ActionType: TMenuActionType read FActionType write FActionType;
  property Name: string read FName write FName;
  property ActionButton: TSpeedButton read FActionButton write FActionButton;
  property ActionButton2: TColorSpeedButtonCS read FActionButton2 write FActionButton2;
  property ActionImage: TImage read FActionImage write FActionImage;
  property ActionLabel: TLabel read FActionLabel write FActionLabel;
  property MenuConfig: integer read FMenuConfig write FMenuConfig;
  property PopupMenu: boolean read FPopupMenu write FPopupMenu;
  property StayDown: boolean read FStayDown write FStayDown;
  property MustSelectKey: boolean read FMustSelectKey write FMustSelectKey;
  property IsEnabled: boolean read FIsEnabled write FIsEnabled;
  property IsDown: boolean read FIsDown write SetIsDown;
  property LedMode: TLedMode read FLedMode write FLedMode;
end;

{ THoveredList }

{ THoveredObj }

THoveredObj = class
private
  FObj: TObject;
  FImgList: TImageList;
  FNormalIdx: integer;
  FHoveredIdx: integer;
protected
public
  constructor Create(obj: TObject; imgList: TImageList;
    normalIdx: integer; hoveredIdx: integer);
  property Obj: TObject read FObj write FObj;
  property ImgList: TImageList read FImgList write FImgList;
  property NormalIdx: integer read FNormalIdx write FNormalIdx;
  property HoveredIdx: integer read FHoveredIdx write FHoveredIdx;
end;

//TActionList = class(TObjectList)
//private
//  FName: string;
//  FActionButton: THSSpeedButton;
//  FActionLabel: TLabel;
//protected
//public
//  property Name: string read FName write FName;
//  property ActionButton: THSSpeedButton read FActionButton write FActionButton;
//  property ActionLabel: TLabel read FActionLabel write FActionLabel;
//end;

var
  com_ui:integer;
  NeedInput: boolean;
  keyService: TBaseKeyService;
  fileService: TFileService;
  procedure LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);
  function EjectDevice(device: TDevice): boolean;
  procedure CreateCustomButton(var customBtns: TCustomButtons;
    btnCaption: string; btnWidth: integer; btnOnClick: TNotifyEvent;
    btnKind: TBitBtnKind = bkCustom);
  function GetKeyOtherLayer(keyService: TKeyService; keyIdx: integer): TKBKey;
  function GetKeyButtonByIndex(keyBtnList: TObjectList; index: integer): TLabelBox;
  procedure ClearBitmaps(container: TWinControl);

const
  PARAM_COLOR = 1;
  PARAM_DIRECTION = 2;
  PARAM_SPEED = 3;
  PARAM_RANGE = 4;
  PARAM_ZONE = 5;
  PARAM_BASECOLOR = 6;

implementation

uses userdialog, infodialog; //todo

{ TMenuAction }

procedure TMenuAction.SetIsDown(value: boolean);
begin
  FIsDown := value;
  if (FActionButton <> nil) then
     FActionButton.Down := value;
  if (FActionButton2 <> nil) then
     FActionButton2.Down := value;
end;

constructor TMenuAction.Create(aType: TMenuActionType; actionButton: TSpeedButton;
  actionLabel: TLabel; actionImage: TImage; menuConfig: integer; ledMode: TLedMode;
  popupMenu: boolean; bStayDown: boolean; bMustSelectKey: boolean;
  bIsEnabled: boolean);
begin
  FActionType := aType;
  FActionButton := actionButton;
  FActionImage := actionImage;
  FActionLabel := actionLabel;
  FMenuConfig := menuConfig;
  FPopupMenu := popupMenu;
  FStayDown := bStayDown;
  FMustSelectKey := bMustSelectKey;
  FIsEnabled := bIsEnabled;
  FIsDown := false;
  FLedMode := ledMode;
end;

constructor TMenuAction.Create2(aType: TMenuActionType;
  actionButton: TColorSpeedButtonCS; actionLabel: TLabel; actionImage: TImage;
  menuConfig: integer; ledMode: TLedMode; popupMenu: boolean;
  bStayDown: boolean; bMustSelectKey: boolean; bIsEnabled: boolean);
begin
  FActionType := aType;
  FActionButton2 := actionButton;
  FActionImage := actionImage;
  FActionLabel := actionLabel;
  FMenuConfig := menuConfig;
  FPopupMenu := popupMenu;
  FStayDown := bStayDown;
  FMustSelectKey := bMustSelectKey;
  FIsEnabled := bIsEnabled;
  FIsDown := false;
  FLedMode := ledMode;
end;

{ THoveredObj }

constructor THoveredObj.Create(obj: TObject; imgList: TImageList;
  normalIdx: integer; hoveredIdx: integer);
begin
  FObj := obj;
  FImgList := imgList;
  FNormalIdx := normalIdx;
  FHoveredIdx := hoveredIdx;
end;


procedure LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);
begin
  if (obj is THSSpeedButton) then
  begin
    if (idx = -1) then
      (obj as THSSpeedButton).Glyph.Clear
    else
      imgList.GetBitmap(idx, (obj as THSSpeedButton).Glyph)
  end
  else if (obj is TColorSpeedButtonCS) then
  begin
    if (idx = -1) then
      (obj as TColorSpeedButtonCS).Glyph.Clear
    else
      imgList.GetBitmap(idx, (obj as TColorSpeedButtonCS).Glyph)
  end
  else if (obj is TBCButton) then
  begin
    if (idx = -1) then
      (obj as TBCButton).Glyph.Clear
    else
      imgList.GetBitmap(idx, (obj as TBCButton).Glyph)
  end
  else if (obj is TImage) then
  begin
    if (idx = -1) then
      (obj as TImage).Picture.Clear
    else
      imgList.GetBitmap(idx, (obj as TImage).Picture.Bitmap);
  end;
  (obj as TControl).Repaint;
end;

function EjectDevice(device: TDevice): boolean;
var
  drive: string;
begin
  result := false;

  {$ifdef Win32}
  if (device <> nil) then
     drive := device.DriveLetter;
  {$endif}
  {$ifdef Darwin}
  if (device <> nil) then
     drive := device.RootFolder;
  {$endif}
  {$ifdef Win32}
  try
    if (drive <> '') then
    begin
      ShowInfoDialog('Disconnecting v-Drive', 'Disconnecting ' + device.VDriveName + ' v-Drive', fpBotRight, 60);
      Application.ProcessMessages;
      //EjectUSB(device.DriveLetter);
      //FlushUSBDrive(device.DriveLetter[1]);
      if (EjectVolume(drive)) then
      begin
         result := true;
         CloseInfoDialog(mrOK);
         Application.ProcessMessages;
         ShowInfoDialog('Safe To Remove Hardware', 'The device ''' + device.VDriveName + ' (' + drive + ')'' can now be safely removed from the computer', fpBotRight);
         //ShowDialog('Safe To Remove Hardware', 'The device ''' + device.VDriveName + ' (' + device.DriveLetter + ':)'' can now be safely removed from the computer',
         //     mtConfirmation, [mbOK]);
      end
      else
      begin
        CloseInfoDialog(mrOk);
        Application.ProcessMessages;
        ShowDialog('Cannot eject v-Drive', 'Close all open files and folders on the v-Drive, and try ejecting again.',
              mtError, [mbOK]);
      end;
    end;
  finally
    //CloseInfoDialog(mrOK);
  end;
  {$else}
  result := true;
  {$endif}
end;

procedure CreateCustomButton(var customBtns: TCustomButtons;
  btnCaption: string; btnWidth: integer; btnOnClick: TNotifyEvent;
  btnKind: TBitBtnKind);
var
  customBtn: TCustomButton;
begin
  customBtn.Caption := btnCaption;
  customBtn.Width := btnwidth;
  customBtn.OnClick := btnOnClick;
  customBtn.Kind := btnKind;

  SetLength(customBtns, Length(customBtns) + 1);
  customBtns[Length(customBtns) - 1] := customBtn;
end;

function GetKeyOtherLayer(keyService: TKeyService; keyIdx: integer): TKBKey;
var
  i: integer;
begin
  result := nil;
  if (keyService.ActiveLayer <> nil) then
  begin
    for i := 0 to keyService.KBLayers.Count - 1 do
    begin
      if (keyService.KBLayers[i].LayerIndex <> keyService.ActiveLayer.LayerIndex) then
      begin
        result := keyService.GetKbKeyByIndex(keyService.KBLayers[i], keyIdx);
        break;
      end;
    end;
  end;
end;

function GetKeyButtonByIndex(keyBtnList: TObjectList; index: integer): TLabelBox;
var
  i: integer;
  keyButton: TLabelBox;
  found: boolean;
begin
  i := 0;
  result := nil;
  found := false;
  While (i < keyBtnList.Count) and (not found) do
  begin
    if (keyBtnList[i] is TLabelBox) then
    begin
      keyButton := (keyBtnList[i] as TLabelBox);
      if (keyButton.Index = index) then
      begin
        result := keyButton;
        found := true;
      end;
    end;
    inc(i);
  end;
end;

procedure ClearBitmaps(container: TWinControl);
//var
  //i: integer;
begin
  //for i := 0 to container.ControlCount - 1 do
  //begin
    //if (container.Controls[i] is TColorSpeedButtonCS) then
    //begin
    //  if (TColorSpeedButtonCS(container.Controls[i]).Glyph <> nil) then
   //   begin
        //TColorSpeedButtonCS(container.Controls[i]).Glyph.Clear;
        //TColorSpeedButtonCS(container.Controls[i]).Glyph.Free;
        //TColorSpeedButtonCS(container.Controls[i]).Glyph := nil;
   //   end;
   // end
   // else if (container.Controls[i].InheritsFrom(TWinControl)) then
   //   ClearBitmaps(container.Controls[i] as TWinControl);
  //end;
end;

end.

