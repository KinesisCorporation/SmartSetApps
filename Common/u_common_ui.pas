unit u_common_ui;

{$mode objfpc}{$H+}

interface

uses
  Forms, Classes, SysUtils, StdCtrls, graphics, controls, buttons, extctrls, dialogs,
  u_kinesis_device, eject_USB, u_const, ColorSpeedButtonCS,
  LabelBox, U_Keys, u_key_layer, contnrs, u_file_service, u_key_service, BCButton;

type
{ TMenuAction }

TMenuAction = class
private
  FActionType: TMenuActionType;
  FName: string;
  FActionButton: TColorSpeedButtonCS;
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
  constructor Create(aType: TMenuActionType; actionButton: TColorSpeedButtonCS; actionLabel: TLabel; actionImage: TImage;
    menuConfig: integer; ledMode: TLedMode; popupMenu: boolean; bStayDown: boolean; bMustSelectKey: boolean; bIsEnabled: boolean = true);
  property ActionType: TMenuActionType read FActionType write FActionType;
  property Name: string read FName write FName;
  property ActionButton: TColorSpeedButtonCS read FActionButton write FActionButton;
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
  keyService: TKeyService;
  fileService: TFileService;
  keyDownList: TList;
  keyUpList: TList;
  speakList: TList;
  procedure LoadButtonImage(obj: TObject; imgList: TImageList; idx: integer);
  function EjectDevice(device: TDevice): boolean;
  procedure CreateCustomButton(var customBtns: TCustomButtons;
    btnCaption: string; btnWidth: integer; btnOnClick: TNotifyEvent;
    btnKind: TBitBtnKind = bkCustom);
  function GetKeyOtherLayer(keyService: TKeyService; keyIdx: integer): TKBKey;
  function GetKeyByLayerIdx(keyService: TKeyService; layerIdx, keyIdx: integer): TKBKey;
  function GetKeyButtonByIndex(keyBtnList: TObjectList; index: integer): TLabelBox;
  function GetKeyShiftActiveLayer: integer;
  procedure ClearBitmaps(container: TWinControl);
  procedure AddKeyDown(key: integer);
  procedure AddKeyUp(key: integer);
  procedure AddSpeakKey(key: integer);
  procedure RemoveSpeakKey(key: integer);
  procedure RemoveKeyDown(key: integer);
  procedure ClearAllKeyDowKeyUp;
  function GetImageByName(container: TWinControl; imageName: string): TImage;
  procedure SetColorButtonColor(btn: TColorSpeedButtonCS; backColor: TColor; fontColor: TColor; borderColor: TColor);

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
end;

constructor TMenuAction.Create(aType: TMenuActionType; actionButton: TColorSpeedButtonCS;
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
  if (obj is TColorSpeedButtonCS) then
  begin
    if (idx = -1) then
      (obj as TColorSpeedButtonCS).Glyph.Clear
    else
      imgList.GetBitmap(idx, (obj as TColorSpeedButtonCS).Glyph)
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

  {$ifdef Win64}
  if (device <> nil) then
     drive := device.DriveLetter;
  {$endif}
  {$ifdef Darwin}
  if (device <> nil) then
     drive := device.RootFolder;
  {$endif}
  {$ifdef Win64}
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

function GetKeyByLayerIdx(keyService: TKeyService; layerIdx, keyIdx: integer): TKBKey;
var
  i: integer;
begin
  result := nil;
  for i := 0 to keyService.KBLayers.Count - 1 do
  begin
    if (keyService.KBLayers[i].LayerIndex = layerIdx) then
    begin
      result := keyService.GetKbKeyByIndex(keyService.KBLayers[i], keyIdx);
      break;
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

function GetKeyShiftActiveLayer: integer;
begin
  if (keyService.ActiveLayer.LayerIndex = LAYER_BASE_360) then
     result := VK_BASE_LAYER_SHIFT
  else if (keyService.ActiveLayer.LayerIndex = LAYER_KEYPAD_360) then
    result := VK_KP_LAYER_SHIFT
  else if (keyService.ActiveLayer.LayerIndex = LAYER_FN1_360) then
    result := VK_FN1_LAYER_SHIFT
  else if (keyService.ActiveLayer.LayerIndex = LAYER_FN2_360) then
    result := VK_FN2_LAYER_SHIFT
  else if (keyService.ActiveLayer.LayerIndex = LAYER_FN3_360) then
    result := VK_FN3_LAYER_SHIFT;
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

procedure AddKeyDown(key: integer);
begin
  if keyDownList.IndexOf(pointer(key)) = -1 then
  begin
    keyDownList.Add(pointer(key));
  end;
end;

procedure AddKeyUp(key: integer);
begin
  if keyUpList.IndexOf(pointer(key)) = -1 then
  begin
    keyUpList.Add(pointer(key));
  end;
end;

procedure AddSpeakKey(key: integer);
begin
  speakList.Add(pointer(key));
end;

procedure RemoveSpeakKey(key: integer);
var
  idx: integer;
  item: pointer;
begin
  idx := speakList.IndexOf(pointer(key));
  if idx <> -1 then
  begin
    item := speakList.Items[idx];
    speakList.Remove(item);
  end;
end;

procedure RemoveKeyDown(key: integer);
begin
  if keyDownList.IndexOf(pointer(key)) >= 0 then
  begin
    keyDownList.Remove(pointer(key));
  end;
end;

procedure ClearAllKeyDowKeyUp;
begin
  keyDownList.Clear;
  keyUpList.Clear;
  speakList.Clear;
end;

function GetImageByName(container: TWinControl; imageName: string): TImage;
var
  i: integer;
  image: TImage;
  controlName: string;
begin
  result := nil;
  for i := 0 to container.ControlCount - 1 do
  begin
    controlName := container.Controls[i].Name;
    if (container.Controls[i] is TImage) then
    begin
      image := (container.Controls[i] as TImage);
      if (UpperCase(image.Name) = UpperCase(imageName)) then
      begin
        result := image;
        break;
      end
      else if (container.Controls[i] is TPanel) then
        GetImageByName(container.Controls[i] as TPanel, imageName);
    end;
  end;
end;

procedure SetColorButtonColor(btn: TColorSpeedButtonCS; backColor: TColor;
  fontColor: TColor; borderColor: TColor);
begin
  btn.StateActive.Color := backColor;
  btn.StateActive.FontColor := fontColor;
  btn.StateActive.BorderColor := borderColor;
  if (borderColor <> clNone) then
    btn.StateActive.BorderWidth := 1;

  btn.StateDisabled.Color := backColor;
  btn.StateDisabled.FontColor := fontColor;
  btn.StateDisabled.BorderColor := borderColor;
  if (borderColor <> clNone) then
    btn.StateDisabled.BorderWidth := 1;

  btn.StateHover.Color := backColor;
  btn.StateHover.FontColor := fontColor;
  btn.StateHover.BorderColor := borderColor;
  if (borderColor <> clNone) then
    btn.StateHover.BorderWidth := 1;

  btn.StateNormal.Color := backColor;
  btn.StateNormal.FontColor := fontColor;
  btn.StateNormal.BorderColor := borderColor;
  if (borderColor <> clNone) then
    btn.StateNormal.BorderWidth := 1;
end;

end.

