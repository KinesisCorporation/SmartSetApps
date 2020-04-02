unit u_file_service;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, u_const, u_debug, graphics, VersionSupport;

type
  //FileService contains all logic for file management

  { TFileService }

  TFileService = class
  private
    FFileContent: TStringList;
    FFilePath: string;
    FFileName: string;
    FNewFile: boolean;
    FStateSettings: TStateSettings;
    FAppSettings: TAppSettings;
    FFirmwareVersionKBD: string;
    FFirmwareMajorKBD: integer;
    FFirmwareMinorKBD: integer;
    FFirmwareRevisionKBD: integer;
    FFirmwareVersionLED: string;
    FFirmwareMajorLED: integer;
    FFirmwareMinorLED: integer;
    FFirmwareRevisionLED: integer;
    FAppVersion: string;
    FAppVersionMajor: integer;
    FAppVersionMinor: integer;
    FAppVersionRevision: integer;
    FModelName: string;
    FLayoutContent: TStringList;
    FLedContent: TStringList;
    FAllowEditSettings: boolean;
    function GetCompleteFileName: string;
    function CheckFileValid: boolean;
    function GetPedalText(aPedal: TPedalText; aPedalType: TPedal): string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function LoadFile(sFileName: string; fileContent: TStringList; criticalFile: boolean): string;
    function SaveFile(sFileName: string; fileContent: TStringList; allowNew: boolean; var error: string): boolean;
    function CheckIfFileExists(sFileName: string): boolean;
    function SetNewFileName(sFileName: string): boolean;
    function LoadStateSettings: string;
    function SaveStateSettings: string;
    function LoadVersionInfo: string;
    function LoadLayoutFile(aFileName: string): string;
    function FirmwareExists: boolean;
    function SaveAppSettings: string;
    function LoadAppSettings(aFileName: string): string;
    procedure SetStatusPlaySpeed(value: integer);
    procedure SetMacroSpeed(value: integer);
    procedure SetVDriveStatus(value: boolean);
    procedure SetGameMode(value: boolean);
    procedure SetLedMode(value: string); //diff
    procedure SetAppIntroMsg(value: boolean);
    procedure SetSaveAsMsg(value: boolean);
    procedure SetSaveMsg(value: boolean);
    procedure SetMultiplayMsg(value: boolean);
    procedure SetSpeedMsg(value: boolean);
    procedure SetCopyMacroMsg(value: boolean);
    procedure SetResetKeyMsg(value: boolean);
    procedure SetKeyClicks(value: boolean);
    procedure SetKeyTones(value: boolean);
    procedure SetStatupFile(value: string);
    //function VersionBiggerEqual(major, minor, revision: integer): boolean;
    function GetFileNumber(sFile: string): integer;
    procedure SetSaveMsgLighting(value: boolean);
    procedure SetSaveSettingsMsg(value: boolean);
    procedure SetStartupFileNumber(number: integer);
    procedure SetCustomColor(value: TColor; index: integer);
    procedure SetWindowsComboMsg(value: boolean);
    procedure SetPitchBlack(value: boolean);
    function VersionBiggerEqualKBD(major, minor, revision: integer): boolean;
    function VersionBiggerEqualLED(major, minor, revision: integer): boolean;
    function VersionSmallerThanApp(major, minor, revision: integer): boolean;
    function VersionSmallerThanKBD(major, minor, revision: integer): boolean;
    function VersionSmallerThanLED(major, minor, revision: integer): boolean;
    function GetDiagnosticInfo: TStringList;

    property FileIsValid: boolean read CheckFileValid;
    property FilePath: string read FFilePath write FFilePath;
    property FileName: string read FFileName write FFileName;
    property CompleteFileName: string read GetCompleteFileName;
    property NewFile: boolean read FNewFile write FNewFile;
    property StateSettings: TStateSettings read FStateSettings;
    property AppSettings: TAppSettings read FAppSettings;
    property ModelName: string read FModelName;
    property LayoutContent: TStringList read FLayoutContent;
    property FirmwareVersionKBD: string read FFirmwareVersionKBD;
    property FirmwareVersionLED: string read FFirmwareVersionLED;
    property AllowEditSettings: boolean read FAllowEditSettings;
  end;

  const
    StartupFile = 'startup_file';
    MacroSpeed = 'macro_speed';
    StatusPlaySpeed = 'status_play_speed';
    VDriveStartup = 'v_drive';
    GameMode = 'game_mode';
    ProgramKeyLock = 'program_key_lock';
    LedMode = 'led_mode';
    ThumbMode = 'thumb_mode';
    KeyClickTone = 'key_click_tone';
    ToggleTone = 'toggle_tone';
    MacroDisable = 'macro_disable';
    PowerUser = 'power_user';
    VDriveStartupAdv2 = 'v_drive_open_on_startup';

    //App settings
    AppIntroMsg = 'app_intro_msg';
    SaveAsMsg = 'saveas_msg';
    SaveMsg = 'save_msg';
    MultiplayMsg = 'multiplay_msg';
    SpeedMsg = 'speed_msg';
    CopyMacroMsg = 'copy_macro_msg';
    ResetKeyMsg = 'reset_key_msg';

    //RGB Settings
    SaveMsgLighting = 'savelighting_msg';
    SaveSettingsMsg = 'savesettings_msg';
    WindowsComboMsg = 'windowscombo_msg';
    CustColor1 = 'cust_color_1';
    CustColor2 = 'cust_color_2';
    CustColor3 = 'cust_color_3';
    CustColor4 = 'cust_color_4';
    CustColor5 = 'cust_color_5';
    CustColor6 = 'cust_color_6';
    CustColor7 = 'cust_color_7';
    CustColor8 = 'cust_color_8';
    CustColor9 = 'cust_color_9';
    CustColor10 = 'cust_color_10';
    CustColor11 = 'cust_color_11';
    CustColor12 = 'cust_color_12';

implementation

{ TFileService }

constructor TFileService.Create;
var
  sTemp: string;
begin
  inherited Create;
  FFileContent := TStringList.Create;
  FLayoutContent := TStringList.Create;
  FLedContent := TStringList.Create;
  FNewFile := false;
  FAppVersion := GetFileVersion;
  GetVersionNumbers(FAppVersion, FAppVersionMajor, FAppVersionMinor, FAppVersionRevision);
  FAllowEditSettings := true;
  if (GApplication = APPL_ADV2) then
    FAllowEditSettings := false;
end;

destructor TFileService.Destroy;
begin
  FreeAndNil(FFileContent);
  FreeAndNil(FLayoutContent);
  FreeAndNil(FLedContent);
  inherited Destroy;
end;

//Returns complet file name and path
function TFileService.GetCompleteFileName: string;
begin
  result := FFilePath + FFileName;
end;

//Checks if file is valid
//true if it exists or is a new file
function TFileService.CheckFileValid: boolean;
begin
  result := (((FFileName <> '') and (FFilePath <> '')) and
    (FileExists(FFilePath + FFileName)))
    or (FNewFile);
end;

//Checkes if file exists
function TFileService.CheckIfFileExists(sFileName: string): boolean;
begin
  result := false;
  if (sFileName <> '') and (FileExists(sFileName)) then
    //causes file handle error? (FileGetAttrUTF8(sFileName) > 0) then
    result := true;
end;

//Tries to set new filename
function TFileService.SetNewFileName(sFileName: string): boolean;
begin
  result := false;

  if sFileName <> '' then
  begin
    if DirectoryExists(ExtractFileDir(sFileName)) then
    begin
      FFilePath := IncludeTrailingBackslash(ExtractFileDir(sFileName));
      FFileName := ExtractFileName(sFileName);

      if not FileExists(sFileName) then
        FNewFile := true;

      result := true;
    end;
 end;
end;

function TFileService.LoadStateSettings: string;
var
  fileExists: boolean;
  fileContent: TStringList;
  i: integer;
  currentLine: string;
  sFilePath: string;
begin
  result := '';
  if (GApplication = APPL_ADV2) then
    sFilePath := GStateFile
  else
    sFilePath := GSettingsFilePath + KB_SETTINGS_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent, true);

    //Disable Pitch black and Off mode (led_mode)
    FStateSettings.PitchBlackMode := false;
    FStateSettings.OffMode := false;

    if result = '' then //no error
    begin
      for i:=0 to fileContent.Count - 1 do
      begin
        currentLine := AnsiLowerCase(fileContent.Strings[i]);

        if (Copy(currentLine, 1, length(StartupFile)) = StartupFile) then
        begin
          FStateSettings.StartupFile := Copy(currentLine, length(StartupFile) + 2, length(currentLine));
          FStateSettings.StartupFileNumber := GetFileNumber(FStateSettings.StartupFile);
          FStateSettings.LayoutFile := FILE_LAYOUT + IntToStr(FStateSettings.StartupFileNumber) + '.txt';
          FStateSettings.LedFile := FILE_LED + IntToStr(FStateSettings.StartupFileNumber) + '.txt';
        end;

        if (Copy(currentLine, 1, length(ThumbMode)) = ThumbMode) then
          FStateSettings.ThumbMode := Copy(currentLine, length(ThumbMode) + 2, length(currentLine));

        if (Copy(currentLine, 1, length(KeyClickTone)) = KeyClickTone) then
          FStateSettings.KeyClickTone := Copy(currentLine, length(KeyClickTone) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(ToggleTone)) = ToggleTone) then
          FStateSettings.ToggleTone := Copy(currentLine, length(ToggleTone) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(MacroDisable)) = MacroDisable) then
          FStateSettings.MacroDisable := Copy(currentLine, length(MacroDisable) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(StatusPlaySpeed)) = StatusPlaySpeed) then
          FStateSettings.StatusPlaySpeed := ConvertToInt(Copy(currentLine, length(StatusPlaySpeed) + 2, length(currentLine)));

        if (Copy(currentLine, 1, length(MacroSpeed)) = MacroSpeed) then
          FStateSettings.MacroSpeed := ConvertToInt(Copy(currentLine, length(MacroSpeed) + 2, length(currentLine)));

        if (Copy(currentLine, 1, length(VDriveStartup)) = VDriveStartup) then
          FStateSettings.VDriveStartup := Copy(currentLine, length(VDriveStartup) + 2, length(currentLine)) = 'auto';

        if (Copy(currentLine, 1, length(VDriveStartupAdv2)) = VDriveStartupAdv2) then
          FStateSettings.VDriveStartup := Copy(currentLine, length(VDriveStartupAdv2) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(GameMode)) = GameMode) then
          FStateSettings.GameMode := Copy(currentLine, length(GameMode) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(ProgramKeyLock)) = ProgramKeyLock) then
          FStateSettings.ProgramKeyLock := Copy(currentLine, length(ProgramKeyLock) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(LedMode)) = LedMode) then
          FStateSettings.LedMode := Copy(currentLine, length(LedMode) + 2, length(currentLine));

        if (Copy(currentLine, 1, length(PowerUser)) = PowerUser) then
          FStateSettings.PowerUser := Copy(currentLine, length(PowerUser) + 2, length(currentLine)) = 'true';
      end;
    end;
  end
  else
    result := 'State.txt configuration file not found';
end;

function TFileService.SaveStateSettings: string;
var
  fileExists: boolean;
  fileContent: TStringList;
  idxSetting: integer;
  valueToSave: string;
  sFilePath: string;
begin
  result := '';
  if (GApplication = APPL_ADV2) then
    sFilePath := GStateFile
  else
    sFilePath := GSettingsFilePath + KB_SETTINGS_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent, true);

    if result = '' then //no error
    begin
      if (GApplication = APPL_RGB) then
      begin
        //Save layout file
        valueToSave := FILE_LAYOUT + IntToStr(FStateSettings.StartupFileNumber) + '.txt';
        idxSetting := GetIndexOfString(StartupFile, fileContent);
        if (idxSetting = -1) then
          fileContent.Insert(0, StartupFile + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := StartupFile + '=' + valueToSave;

        //Save led file
        valueToSave := FILE_LED + IntToStr(FStateSettings.StartupFileNumber) + '.txt';
        idxSetting := GetIndexOfString(LedMode, fileContent);
        if (idxSetting = -1) then
          fileContent.Insert(0, LedMode + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := LedMode + '=' + valueToSave;
      end
      else if (GApplication = APPL_RGB) then
      begin
        //Save Startup file
        valueToSave := AnsiLowerCase(FStateSettings.StartupFile);
        idxSetting := GetIndexOfString(StartupFile, fileContent);
        if (idxSetting = -1) then
          fileContent.Insert(0, StartupFile + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := StartupFile + '=' + valueToSave;
      end;

      //Save Status Play speed
      valueToSave := IntToStr(FStateSettings.StatusPlaySpeed);
      idxSetting := GetIndexOfString(StatusPlaySpeed, fileContent);
      if (idxSetting = -1) then
        fileContent.Insert(0, StatusPlaySpeed + '=' + valueToSave)
      else
        fileContent.Strings[idxSetting] := StatusPlaySpeed + '=' + valueToSave;

      //Save Macro speed
      valueToSave := IntToStr(FStateSettings.MacroSpeed);
      idxSetting := GetIndexOfString(MacroSpeed, fileContent);
      if (idxSetting = -1) then
        fileContent.Insert(0, MacroSpeed + '=' + valueToSave)
      else
        fileContent.Strings[idxSetting] := MacroSpeed + '=' + valueToSave;

      if (GApplication = APPL_ADV2) then
      begin
        //Save V-Drive startup
        if (FStateSettings.VDriveStartup) then
          valueToSave := 'ON'
        else
          valueToSave := 'off';
        idxSetting := GetIndexOfString(VDriveStartupAdv2, fileContent);
        if (idxSetting = -1) then
          fileContent.Append(VDriveStartupAdv2 + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := VDriveStartupAdv2 + '=' + valueToSave;

        //KeyClickTone
        if (FStateSettings.KeyClickTone) then
          valueToSave := 'ON'
        else
          valueToSave := 'OFF';
        idxSetting := GetIndexOfString(KeyClickTone, fileContent);
        if (idxSetting = -1) then
          fileContent.Append(KeyClickTone + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := KeyClickTone + '=' + valueToSave;

        //ToggleTone
        if (FStateSettings.ToggleTone) then
          valueToSave := 'ON'
        else
          valueToSave := 'OFF';
        idxSetting := GetIndexOfString(ToggleTone, fileContent);
        if (idxSetting = -1) then
          fileContent.Append(ToggleTone + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := ToggleTone + '=' + valueToSave;
      end
      else
      begin
        //Save V-Drive startup
        if (FStateSettings.VDriveStartup) then
          valueToSave := 'auto'
        else
          valueToSave := 'manual';
        idxSetting := GetIndexOfString(VDriveStartup, fileContent);
        if (idxSetting = -1) then
          fileContent.Append(VDriveStartup + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := VDriveStartup + '=' + valueToSave;
      end;

      if (GApplication in [APPL_FSEDGE, APPL_FSPRO, APPL_RGB]) then
      begin
        //Save Game Mode
        if (FStateSettings.GameMode) then
          valueToSave := 'ON'
        else
          valueToSave := 'OFF';
        idxSetting := GetIndexOfString(GameMode, fileContent);
        if (idxSetting = -1) then
          fileContent.Append(GameMode + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := GameMode + '=' + valueToSave;
      end;

      if (GApplication in [APPL_FSEDGE, APPL_FSPRO]) then
      begin
        //Led Mode
        valueToSave := FStateSettings.LedMode;
        idxSetting := GetIndexOfString(LedMode, fileContent);
        if (idxSetting = -1) then
          fileContent.Append(LedMode + '=' + valueToSave)
        else
          fileContent.Strings[idxSetting] := LedMode + '=' + valueToSave;
      end;

      SaveFile(sFilePath, fileContent, false, result);
    end;
  end
  else
    result := 'State.txt configuration file not found';
end;

function TFileService.LoadVersionInfo: string;
var
  fileExists: boolean;
  fileContent: TStringList;
  i, j: integer;
  currentLine: string;
  sFilePath: string;
  sTemp: string;
  sVersion: string;
  FirmwareTextKBD: string;
  FirmwareTextLED: string;
const
  ModelNameText = 'model name';
begin
  result := '';
  if (GApplication = APPL_RGB) then
  begin
    FirmwareTextKBD := 'kbd firmware';
    FirmwareTextLED := 'led firmware';
  end
  else
  begin
    FirmwareTextKBD := 'firmware version';
    FirmwareTextLED := '';
  end;
  if (GApplication = APPL_ADV2) then
    sFilePath := GVersionFile
  else
    sFilePath := GFirmwareFilePath + VERSION_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent, true);

    if result = '' then //no error
    begin
      for i:=0 to fileContent.Count - 1 do
      begin
        currentLine := AnsiLowerCase(fileContent.Strings[i]);

        if (GApplication = APPL_ADV2) then
        begin
          //4MB version can edit settings
          if Pos(AnsiLowerCase(ADV2_4MB), currentLine) <> 0 then
            FAllowEditSettings := true;
        end;

        if (Copy(currentLine, 1, length(ModelNameText)) = ModelNameText) then
          FModelName := Trim(Copy(currentLine, length(ModelNameText) + 2, length(currentLine)))
        else if (Copy(currentLine, 1, length(FirmwareTextKBD)) = FirmwareTextKBD) then
        begin
          FFirmwareVersionKBD := Trim(Copy(currentLine, length(FirmwareTextKBD) + 2, length(currentLine)));
          GetVersionNumbers(FFirmwareVersionKBD, FFirmwareMajorKBD, FFirmwareMinorKBD, FFirmwareRevisionKBD);
        end
        else if (Copy(currentLine, 1, length(FirmwareTextLED)) = FirmwareTextLED) then
        begin
          FFirmwareVersionLED := Trim(Copy(currentLine, length(FirmwareTextLED) + 2, length(currentLine)));
          GetVersionNumbers(FFirmwareVersionLED, FFirmwareMajorLED, FFirmwareMinorLED, FFirmwareRevisionLED);
        end;
      end;
    end;
  end
  else
    result := 'Version.txt file not found';
end;

function TFileService.LoadLayoutFile(aFileName: string): string;
var
  fileExists: boolean;
begin
  result := '';
  fileExists := CheckIfFileExists(aFileName);
  if (fileExists) then
  begin
    result := LoadFile(aFileName, FLayoutContent, false);
  end
  else
    result := aFileName + ' not found';
end;

function TFileService.FirmwareExists: boolean;
begin
  if (GApplication = APPL_ADV2) then
    result := CheckIfFileExists(GVersionFile)
  else
    result := CheckIfFileExists(GFirmwareFilePath + VERSION_FILE);
end;

function TFileService.SaveAppSettings: string;
var
  fileContent: TStringList;
  idxSetting: integer;
  valueToSave: string;
  sFilePath: string;

  procedure SaveValueBoolean(value: boolean; nameOfParam: string);
  begin
    if (value) then
      valueToSave := 'on'
    else
      valueToSave := 'off';
    idxSetting := GetIndexOfString(nameOfParam, fileContent);
    if (idxSetting = -1) then
      fileContent.Append(nameOfParam + '=' + valueToSave)
    else
      fileContent.Strings[idxSetting] := nameOfParam + '=' + valueToSave;
  end;

  procedure SaveValueRGB(value: TColor; nameOfParam: string);
  begin
    valueToSave := RGBColorToString(value);
    if (valueToSave <> '') then
    begin
      idxSetting := GetIndexOfString(nameOfParam, fileContent);
      if (idxSetting = -1) then
        fileContent.Append(nameOfParam + '=' + valueToSave)
      else
        fileContent.Strings[idxSetting] := nameOfParam + '=' + valueToSave;
    end;
  end;

begin
  result := '';

  fileContent := TStringList.Create;
  sFilePath := GSettingsFilePath + APP_SETTINGS_FILE;
  if CheckIfFileExists(sFilePath) then
    result := LoadFile(sFilePath, fileContent, true);

  if result = '' then //no error
  begin
    SaveValueBoolean(FAppSettings.AppIntroMsg, AppIntroMsg);
    SaveValueBoolean(FAppSettings.SaveAsMsg, SaveAsMsg);
    SaveValueBoolean(FAppSettings.SaveMsg, SaveMsg);
    SaveValueBoolean(FAppSettings.MultiplayMsg, MultiplayMsg);
    SaveValueBoolean(FAppSettings.SpeedMsg, SpeedMsg);
    SaveValueBoolean(FAppSettings.CopyMacroMsg, CopyMacroMsg);
    SaveValueBoolean(FAppSettings.ResetKeyMsg, ResetKeyMsg);

    if (GApplication = APPL_RGB) then
    begin
      SaveValueBoolean(FAppSettings.SaveMsgLighting, SaveMsgLighting);
      SaveValueBoolean(FAppSettings.SaveSettingsMsg, SaveSettingsMsg);
      SaveValueBoolean(FAppSettings.WindowsComboMsg, WindowsComboMsg);
      SaveValueRGB(FAppSettings.CustColor1, CustColor1);
      SaveValueRGB(FAppSettings.CustColor2, CustColor2);
      SaveValueRGB(FAppSettings.CustColor3, CustColor3);
      SaveValueRGB(FAppSettings.CustColor4, CustColor4);
      SaveValueRGB(FAppSettings.CustColor5, CustColor5);
      SaveValueRGB(FAppSettings.CustColor6, CustColor6);
      SaveValueRGB(FAppSettings.CustColor7, CustColor7);
      SaveValueRGB(FAppSettings.CustColor8, CustColor8);
      SaveValueRGB(FAppSettings.CustColor9, CustColor9);
      SaveValueRGB(FAppSettings.CustColor10, CustColor10);
      SaveValueRGB(FAppSettings.CustColor11, CustColor11);
      SaveValueRGB(FAppSettings.CustColor12, CustColor12);
    end;

    SaveFile(sFilePath, fileContent, true, result);
  end;
end;

function TFileService.LoadAppSettings(aFileName: string): string;
var
  fileExists: boolean;
  fileContent: TStringList;
  i: integer;
  currentLine: string;
  sFilePath: string;
  textValue: string;
begin
  result := '';
  sFilePath := GSettingsFilePath + APP_SETTINGS_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent, true);

    if result = '' then //no error
    begin
      for i:=0 to fileContent.Count - 1 do
      begin
        currentLine := AnsiLowerCase(fileContent.Strings[i]);

        if (Copy(currentLine, 1, length(AppIntroMsg)) = AppIntroMsg) then
          FAppSettings.AppIntroMsg := Copy(currentLine, length(AppIntroMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(SaveAsMsg)) = SaveAsMsg) then
          FAppSettings.SaveAsMsg := Copy(currentLine, length(SaveAsMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(SaveMsg)) = SaveMsg) then
          FAppSettings.SaveMsg := Copy(currentLine, length(SaveMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(MultiplayMsg)) = MultiplayMsg) then
          FAppSettings.MultiplayMsg := Copy(currentLine, length(MultiplayMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(SpeedMsg)) = SpeedMsg) then
          FAppSettings.SpeedMsg := Copy(currentLine, length(SpeedMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(CopyMacroMsg)) = CopyMacroMsg) then
          FAppSettings.CopyMacroMsg := Copy(currentLine, length(CopyMacroMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(ResetKeyMsg)) = ResetKeyMsg) then
          FAppSettings.ResetKeyMsg := Copy(currentLine, length(ResetKeyMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(WindowsComboMsg)) = WindowsComboMsg) then
          FAppSettings.WindowsComboMsg := Copy(currentLine, length(WindowsComboMsg) + 2, length(currentLine)) = 'on'
        else if (Copy(currentLine, 1, length(CustColor1)) = CustColor1) then
        begin
          textValue := Copy(currentLine, length(CustColor1) + 2, length(currentLine));
          FAppSettings.CustColor1 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR)
        end
        else if (Copy(currentLine, 1, length(CustColor2)) = CustColor2) then
        begin
          textValue := Copy(currentLine, length(CustColor2) + 2, length(currentLine));
          FAppSettings.CustColor2 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR)
        end
        else if (Copy(currentLine, 1, length(CustColor3)) = CustColor3) then
        begin
          textValue := Copy(currentLine, length(CustColor3) + 2, length(currentLine));
          FAppSettings.CustColor3 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR)
        end
        else if (Copy(currentLine, 1, length(CustColor4)) = CustColor4) then
        begin
          textValue := Copy(currentLine, length(CustColor4) + 2, length(currentLine));
          FAppSettings.CustColor4 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR)
        end
        else if (Copy(currentLine, 1, length(CustColor5)) = CustColor5) then
        begin
          textValue := Copy(currentLine, length(CustColor4) + 2, length(currentLine));
          FAppSettings.CustColor5 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR)
        end
        else if (Copy(currentLine, 1, length(CustColor6)) = CustColor6) then
        begin
          textValue := Copy(currentLine, length(CustColor6) + 2, length(currentLine));
          FAppSettings.CustColor6 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end
        else if (Copy(currentLine, 1, length(CustColor7)) = CustColor7) then
        begin
          textValue := Copy(currentLine, length(CustColor7) + 2, length(currentLine));
          FAppSettings.CustColor7 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end
        else if (Copy(currentLine, 1, length(CustColor8)) = CustColor8) then
        begin
          textValue := Copy(currentLine, length(CustColor8) + 2, length(currentLine));
          FAppSettings.CustColor8 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end
        else if (Copy(currentLine, 1, length(CustColor9)) = CustColor9) then
        begin
          textValue := Copy(currentLine, length(CustColor9) + 2, length(currentLine));
          FAppSettings.CustColor9 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end
        else if (Copy(currentLine, 1, length(CustColor10)) = CustColor10) then
        begin
          textValue := Copy(currentLine, length(CustColor10) + 2, length(currentLine));
          FAppSettings.CustColor10 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end
        else if (Copy(currentLine, 1, length(CustColor11)) = CustColor11) then
        begin
          textValue := Copy(currentLine, length(CustColor11) + 2, length(currentLine));
          FAppSettings.CustColor11 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end
        else if (Copy(currentLine, 1, length(CustColor12)) = CustColor12) then
        begin
          textValue := Copy(currentLine, length(CustColor12) + 2, length(currentLine));
          FAppSettings.CustColor12 := RGBStringToColor(textValue, DEFAULT_CUST_COLOR);
        end;
      end;
    end;
  end;
end;

procedure TFileService.SetStatusPlaySpeed(value: integer);
begin
  FStateSettings.StatusPlaySpeed := value;
end;

procedure TFileService.SetMacroSpeed(value: integer);
begin
  FStateSettings.MacroSpeed := value;
end;

procedure TFileService.SetVDriveStatus(value: boolean);
begin
  FStateSettings.VDriveStartup := value;
end;

procedure TFileService.SetGameMode(value: boolean);
begin
  FStateSettings.GameMode := value;
end;

procedure TFileService.SetLedMode(value: string);
begin
  FStateSettings.LedMode := value;
end;

procedure TFileService.SetAppIntroMsg(value: boolean);
begin
  FAppSettings.AppIntroMsg := value;
end;

procedure TFileService.SetSaveAsMsg(value: boolean);
begin
  FAppSettings.SaveAsMsg := value;
end;

procedure TFileService.SetSaveMsg(value: boolean);
begin
  FAppSettings.SaveMsg := value;
end;

procedure TFileService.SetMultiplayMsg(value: boolean);
begin
  FAppSettings.MultiplayMsg := value;
end;

procedure TFileService.SetSpeedMsg(value: boolean);
begin
  FAppSettings.SpeedMsg := value;
end;

procedure TFileService.SetCopyMacroMsg(value: boolean);
begin
  FAppSettings.CopyMacroMsg := value;
end;

procedure TFileService.SetResetKeyMsg(value: boolean);
begin
  FAppSettings.ResetKeyMsg := value;
end;

procedure TFileService.SetKeyClicks(value: boolean);
begin
  FStateSettings.KeyClickTone := value;
end;

procedure TFileService.SetKeyTones(value: boolean);
begin
  FStateSettings.ToggleTone := value;
end;

procedure TFileService.SetStatupFile(value: string);
begin
  FStateSettings.StartupFile := value;
end;

procedure TFileService.SetSaveMsgLighting(value: boolean);
begin
  FAppSettings.SaveMsgLighting := value;
end;

procedure TFileService.SetSaveSettingsMsg(value: boolean);
begin
  FAppSettings.SaveSettingsMsg := value;
end;

procedure TFileService.SetStartupFileNumber(number: integer);
begin
  FStateSettings.StartupFileNumber := number;
end;

procedure TFileService.SetCustomColor(value: TColor; index: integer);
begin
  case index of
    1: FAppSettings.CustColor1 := value;
    2: FAppSettings.CustColor2 := value;
    3: FAppSettings.CustColor3 := value;
    4: FAppSettings.CustColor4 := value;
    5: FAppSettings.CustColor5 := value;
    6: FAppSettings.CustColor6 := value;
    7: FAppSettings.CustColor7 := value;
    8: FAppSettings.CustColor8 := value;
    9: FAppSettings.CustColor9 := value;
    10: FAppSettings.CustColor10 := value;
    11: FAppSettings.CustColor11 := value;
    12: FAppSettings.CustColor12 := value;
  end;
end;

procedure TFileService.SetWindowsComboMsg(value: boolean);
begin
  FAppSettings.WindowsComboMsg := value;
end;

procedure TFileService.SetPitchBlack(value: boolean);
begin
  FStateSettings.PitchBlackMode := value;
end;

//function TFileService.VersionBiggerEqual(major, minor, revision: integer
//  ): boolean;
//begin
//  result := (FFirmwareMajor >= major) and (FFirmwareMinor >= minor) and (FFirmwareRevision >= revision);
//end;

function TFileService.GetFileNumber(sFile: string): integer;
var
  idxNumber: integer;
begin
  result := 0;
  sFile := ExtractFileNameWithoutExt(ExtractFileName(sFile));
  idxNumber := GetIndexOfNumber(sFile);
  if (idxNumber >= 1) then
    result := StrToInt(Copy(sFile, idxNumber, Length(sFile)));
end;

function TFileService.VersionBiggerEqualKBD(major, minor, revision: integer
  ): boolean;
begin
  result := IsVersionBiggerOrEqual(FFirmwareMajorKBD, FFirmwareMinorKBD, FFirmwareRevisionKBD, major, minor, revision); //(FFirmwareMajorKBD >= major) and (FFirmwareMinorKBD >= minor) and (FFirmwareRevisionKBD >= revision);
end;

function TFileService.VersionBiggerEqualLED(major, minor, revision: integer
  ): boolean;
begin
  result := IsVersionBiggerOrEqual(FFirmwareMajorLED, FFirmwareMinorLED, FFirmwareRevisionLED, major, minor, revision); //(FFirmwareMajorLED >= major) and (FFirmwareMinorLED >= minor) and (FFirmwareRevisionLED >= revision);
end;

function TFileService.VersionSmallerThanKBD(major, minor, revision: integer
  ): boolean;
begin
  result := IsVersionSmaller(FFirmwareMajorKBD, FFirmwareMinorKBD, FFirmwareRevisionKBD, major, minor, revision);
end;

function TFileService.VersionSmallerThanLED(major, minor, revision: integer
  ): boolean;
begin
  result := IsVersionSmaller(FFirmwareMajorLED, FFirmwareMinorLED, FFirmwareRevisionLED, major, minor, revision);
end;

function TFileService.VersionSmallerThanApp(major, minor, revision: integer
  ): boolean;
begin
  result := IsVersionSmaller(FAppVersionMajor, FAppVersionMinor, FAppVersionRevision, major, minor, revision);
end;

function TFileService.GetDiagnosticInfo: TStringList;
var
  aFileContent: TStringList;
  aAllContent: TStringList;
  i: integer;
  errorMsg: string;
  sFileName: string;
begin
  try
    aFileContent := TStringList.Create;
    aAllContent := TStringList.Create;

    aAllContent.Add('Diagnostic file, ' + FormatDateTime('yyyy-mm-dd hh:nn',Now));
    aAllContent.Add('');

    //Firmware
    aAllContent.Add(VERSION_FILE);
    aAllContent.Add('--------------');
    errorMsg := LoadFile(GFirmwareFilePath + VERSION_FILE, aFileContent, false);
    if (errorMsg = '') then
      aAllContent.AddStrings(aFileContent)
    else
      aAllContent.Add(errorMsg);
    aAllContent.Add('');

    //Keyboard settings
    aAllContent.Add(KB_SETTINGS_FILE);
    aAllContent.Add('--------------');
    errorMsg := LoadFile(GSettingsFilePath + KB_SETTINGS_FILE, aFileContent, false);
    if (errorMsg = '') then
      aAllContent.AddStrings(aFileContent)
    else
      aAllContent.Add(errorMsg);
    aAllContent.Add('');

    //App settings
    aAllContent.Add(APP_SETTINGS_FILE);
    aAllContent.Add('--------------');
    errorMsg := LoadFile(GSettingsFilePath + APP_SETTINGS_FILE, aFileContent, false);
    if (errorMsg = '') then
      aAllContent.AddStrings(aFileContent)
    else
      aAllContent.Add(errorMsg);
    aAllContent.Add('');

    //Layout files
    for i := 1 to 9 do
    begin
      sFileName := FILE_LAYOUT + IntToStr(i) + '.txt';
      aAllContent.Add(sFileName);
      aAllContent.Add('--------------');
      errorMsg := LoadFile(GLayoutFilePath + sFileName, aFileContent, false);
      if (errorMsg = '') then
        aAllContent.AddStrings(aFileContent)
      else
        aAllContent.Add(errorMsg);
      aAllContent.Add('');
    end;

    //Led files
    for i := 1 to 9 do
    begin
      sFileName := FILE_LED + IntToStr(i) + '.txt';
      aAllContent.Add(sFileName);
      aAllContent.Add('--------------');
      errorMsg := LoadFile(GLedFilePath + sFileName, aFileContent, false);
      if (errorMsg = '') then
        aAllContent.AddStrings(aFileContent)
      else
        aAllContent.Add(errorMsg);
      aAllContent.Add('');
    end;

    result := aAllContent;
  finally
    if (aFileContent <> nil) then
      FreeAndNil(aFileContent);
  end;
end;

//Receives complete file name and tries to load file
function TFileService.LoadFile(sFileName: string; fileContent: TStringList; criticalFile: boolean): string;
var
  filePedals: TextFile;
  currentLine: string;
  fileOpen: boolean;
begin
  Result := '';
  fileOpen := false;
  FFilePath := IncludeTrailingBackslash(ExtractFileDir(sFileName));
  FFileName := ExtractFileName(sFileName);

  fileContent.Clear;

  //Tries to load file content in string list
  try
    try
      AssignFile(filePedals, FFilePath + FFileName);
      Reset(filePedals);
      fileOpen := true;
      repeat
        Readln(filePedals, currentLine); // Reads the whole line from the file
        fileContent.Add(currentLine) ;
      until(EOF(filePedals)); // EOF(End Of File) The the program will keep reading new lines until there is none.
    except
      on E: Exception do
      begin
        if (criticalFile) then
          Result := 'A file error has occurred. Please disconnect and re-connect the v-Drive and try launching the SmartSet App again.'
        else
          Result := 'Error loading file: ' + sFileName + ', ' + E.Message;
        HandleExcept(E, False, Result);
      end;
    end;
  finally
    if (fileOpen) then
      CloseFile(filePedals);
  end;
end;

//Gets pedal text to save to file
function TFileService.GetPedalText(aPedal: TPedalText; aPedalType: TPedal): string;
begin
  result := '';

  if aPedalType <> pNone then
  begin
    if aPedal.MultiKey then
      result := '{'
    else
      result := '[';

    case aPedalType of
      pLeft: result := result + LEFT_PEDAL_TEXT;
      pMiddle: result := result + MIDDLE_PEDAL_TEXT;
      pRight: result := result + RIGHT_PEDAL_TEXT;
      pJack1: result := result + JACK1_PEDAL_TEXT;
      pJack2: result := result + JACK2_PEDAL_TEXT;
      pJack3: result := result + JACK3_PEDAL_TEXT;
      pJack4: result := result + JACK4_PEDAL_TEXT;
    end;

    if aPedal.MultiKey then
      result := result + '}>'
    else
      result := result + ']>';

    result := result + aPedal.PedalText;
  end;
end;

//Save pedal content to text file
function TFileService.SaveFile(sFileName: string; fileContent: TStringList; allowNew: boolean; var error: string): boolean;
var
  i:integer;
  filePedals: TextFile;
  fileExists: boolean;
begin
  error := '';
  result := false;

  fileExists := CheckIfFileExists(sFileName);
  if (fileExists or allowNew) then
  begin
    //Tries to save string list to file
    try
      try
        //DeleteFile(sFileName);
        AssignFile(filePedals, sFileName);
        Rewrite(filePedals);  // creating the file
        if (fileContent <> nil) then
          for i := 0 to fileContent.Count - 1 do
            Writeln(filePedals, fileContent.Strings[i]);
        result := true;
        FNewFile := false; //removes new file flag
      except
        on E: Exception do
        begin
          error := 'Error saving file: ' + sFileName+ ', ' + E.Message;
          HandleExcept(E, False, error);
        end;
      end;
    finally
      CloseFile(filePedals);
    end;
  end
  else
    error := sFileName + ' not found';
end;

end.
