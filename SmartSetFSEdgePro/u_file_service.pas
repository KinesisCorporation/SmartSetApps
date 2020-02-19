unit u_file_service;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, u_const, u_debug;

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
    FFirmwareVersion: string;
    FFirmwareMajor: integer;
    FFirmwareMinor: integer;
    FFirmwareRevision: integer;
    FModelName: string;
    FLayoutContent: TStringList;
    function GetCompleteFileName: string;
    function CheckFileValid: boolean;
    function GetPedalText(aPedal: TPedalText; aPedalType: TPedal): string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function LoadFile(sFileName: string; fileContent: TStringList): string;
    function SaveFile(sFileName: string; fileContent: TStringList; allowNew: boolean; var error: string): boolean;
    function CheckIfFileExists(sFileName: string): boolean;
    function SetNewFileName(sFileName: string): boolean;
    function LoadStateSettings: string;
    function SaveStateSettings: string;
    function LoadVersionInfo: string;
    function LoadLayoutFile(aFileName: string): string;
    function SaveAppSettings: string;
    function LoadAppSettings(aFileName: string): string;
    procedure SetStatusPlaySpeed(value: integer);
    procedure SetMacroSpeed(value: integer);
    procedure SetVDriveStatut(value: boolean);
    procedure SetGameMode(value: boolean);
    procedure SetLedMode(value: string);
    procedure SetAppIntroMsg(value: boolean);
    procedure SetSaveAsMsg(value: boolean);
    procedure SetSaveMsg(value: boolean);
    procedure SetMultiplayMsg(value: boolean);
    procedure SetSpeedMsg(value: boolean);
    procedure SetCopyMacroMsg(value: boolean);
    procedure SetResetKeyMsg(value: boolean);
    function VersionBiggerEqual(major, minor, revision: integer): boolean;
    function GetFileNumber(sFile: string): integer;

    property FileIsValid: boolean read CheckFileValid;
    //property FileContent: TStringList read FFileContent write FFileContent;
    property FilePath: string read FFilePath write FFilePath;
    property FileName: string read FFileName write FFileName;
    property CompleteFileName: string read GetCompleteFileName;
    property NewFile: boolean read FNewFile write FNewFile;
    property StateSettings: TStateSettings read FStateSettings;
    property AppSettings: TAppSettings read FAppSettings;
    property ModelName: string read FModelName;
    property FirmwareVersion: string read FFirmwareVersion;
    property FirmwareMajor: integer read FFirmwareMajor;
    property FirmwareMinor: integer read FFirmwareMinor;
    property FirmwareRevision: integer read FFirmwareRevision;
    property LayoutContent: TStringList read FLayoutContent;
  end;

  const
    StartupFile = 'startup_file';
    MacroSpeed = 'macro_speed';
    StatusPlaySpeed = 'status_play_speed';
    VDriveStartup = 'v_drive';
    GameMode = 'game_mode';
    ProgramKeyLock = 'program_key_lock';
    LedMode = 'led_mode';

    //App settings
    AppIntroMsg = 'app_intro_msg';
    SaveAsMsg = 'saveas_msg';
    SaveMsg = 'save_msg';
    MultiplayMsg = 'multiplay_msg';
    SpeedMsg = 'speed_msg';
    CopyMacroMsg = 'copy_macro_msg';
    ResetKeyMsg = 'reset_key_msg';

implementation

{ TFileService }

constructor TFileService.Create;
begin
  inherited Create;
  FFileContent := TStringList.Create;
  FLayoutContent := TStringList.Create;
  FNewFile := false;
end;

destructor TFileService.Destroy;
begin
  FreeAndNil(FFileContent);
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
  sFilePath := GSettingsFilePath + KB_SETTINGS_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent);

    if result = '' then //no error
    begin
      for i:=0 to fileContent.Count - 1 do
      begin
        currentLine := AnsiLowerCase(fileContent.Strings[i]);

        if (Copy(currentLine, 1, length(StartupFile)) = StartupFile) then
          FStateSettings.StartupFile := Copy(currentLine, length(StartupFile) + 2, length(currentLine));

        if (Copy(currentLine, 1, length(StatusPlaySpeed)) = StatusPlaySpeed) then
          FStateSettings.StatusPlaySpeed := ConvertToInt(Copy(currentLine, length(StatusPlaySpeed) + 2, length(currentLine)));

        if (Copy(currentLine, 1, length(MacroSpeed)) = MacroSpeed) then
          FStateSettings.MacroSpeed := ConvertToInt(Copy(currentLine, length(MacroSpeed) + 2, length(currentLine)));

        if (Copy(currentLine, 1, length(VDriveStartup)) = VDriveStartup) then
          FStateSettings.VDriveStartup := Copy(currentLine, length(VDriveStartup) + 2, length(currentLine)) = 'auto';

        if (Copy(currentLine, 1, length(GameMode)) = GameMode) then
          FStateSettings.GameMode := Copy(currentLine, length(GameMode) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(ProgramKeyLock)) = ProgramKeyLock) then
          FStateSettings.ProgramKeyLock := Copy(currentLine, length(ProgramKeyLock) + 2, length(currentLine)) = 'on';

        if (Copy(currentLine, 1, length(LedMode)) = LedMode) then
          FStateSettings.LedMode := Copy(currentLine, length(LedMode) + 2, length(currentLine));
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
  sFilePath := GSettingsFilePath + KB_SETTINGS_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent);

    if result = '' then //no error
    begin
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

      //Led Mode
      valueToSave := FStateSettings.LedMode;
      idxSetting := GetIndexOfString(LedMode, fileContent);
      if (idxSetting = -1) then
        fileContent.Append(LedMode + '=' + valueToSave)
      else
        fileContent.Strings[idxSetting] := LedMode + '=' + valueToSave;

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
const
  FirmwareText = 'firmware version';
  ModelNameText = 'model name';
begin
  result := '';
  sFilePath := GFirmwareFilePath + VERSION_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent);

    if result = '' then //no error
    begin
      for i:=0 to fileContent.Count - 1 do
      begin
        currentLine := AnsiLowerCase(fileContent.Strings[i]);

        if (Copy(currentLine, 1, length(ModelNameText)) = ModelNameText) then
          FModelName := Trim(Copy(currentLine, length(ModelNameText) + 2, length(currentLine)))
        else if (Copy(currentLine, 1, length(FirmwareText)) = FirmwareText) then
        begin
          FFirmwareVersion := Trim(Copy(currentLine, length(FirmwareText) + 2, length(currentLine)));

          //Get Major, Minor and Revision numbers
          sTemp := FFirmwareVersion;
          for j := 1 to 3 do
          begin
            sVersion := Copy(sTemp, 1, Pos('.', sTemp) - 1);
            Delete(sTemp, 1, Pos('.', sTemp));

            case j of
              1: FFirmwareMajor := ConvertToInt(sVersion);
              2: FFirmwareMinor := ConvertToInt(sVersion);
              3: FFirmwareRevision := ConvertToInt(sVersion);
            end;
          end;
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
    result := LoadFile(aFileName, FLayoutContent);
//
//    if result = '' then //no error
//    begin
//      for i:=0 to fileContent.Count - 1 do
//      begin
//        currentLine := AnsiLowerCase(fileContent.Strings[i]);
//
//        if (Copy(currentLine, 1, length(FirmwareText)) = FirmwareText) then
//          FFirmwareVersion := Trim(Copy(currentLine, length(FirmwareText) + 2, length(currentLine)));
//      end;
//    end;
  end
  else
    result := aFileName + ' not found';
end;

function TFileService.SaveAppSettings: string;
var
  fileExists: boolean;
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

begin
  result := '';

  fileContent := TStringList.Create;
  sFilePath := GSettingsFilePath + APP_SETTINGS_FILE;
  if CheckIfFileExists(sFilePath) then
    result := LoadFile(sFilePath, fileContent);

  if result = '' then //no error
  begin
    SaveValueBoolean(FAppSettings.AppIntroMsg, AppIntroMsg);
    SaveValueBoolean(FAppSettings.SaveAsMsg, SaveAsMsg);
    SaveValueBoolean(FAppSettings.SaveMsg, SaveMsg);
    SaveValueBoolean(FAppSettings.MultiplayMsg, MultiplayMsg);
    SaveValueBoolean(FAppSettings.SpeedMsg, SpeedMsg);
    SaveValueBoolean(FAppSettings.CopyMacroMsg, CopyMacroMsg);
    SaveValueBoolean(FAppSettings.ResetKeyMsg, ResetKeyMsg);

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
begin
  result := '';
  sFilePath := GSettingsFilePath + APP_SETTINGS_FILE;
  fileExists := CheckIfFileExists(sFilePath);
  if (fileExists) then
  begin
    fileContent := TStringList.Create;
    result := LoadFile(sFilePath, fileContent);

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
          FAppSettings.ResetKeyMsg := Copy(currentLine, length(ResetKeyMsg) + 2, length(currentLine)) = 'on';
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

procedure TFileService.SetVDriveStatut(value: boolean);
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

function TFileService.VersionBiggerEqual(major, minor, revision: integer
  ): boolean;
begin
  result := (FFirmwareMajor >= major) and (FFirmwareMinor >= minor) and (FFirmwareRevision >= revision);
end;

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

//Receives complete file name and tries to load file
function TFileService.LoadFile(sFileName: string; fileContent: TStringList): string;
var
  filePedals: TextFile;
  currentLine: string;
begin
  Result := '';
  FFilePath := IncludeTrailingBackslash(ExtractFileDir(sFileName));
  FFileName := ExtractFileName(sFileName);

  fileContent.Clear;

  //Tries to load file content in string list
  try
    try
      AssignFile(filePedals, FFilePath + FFileName);
      Reset(filePedals);
      repeat
        Readln(filePedals, currentLine); // Reads the whole line from the file
        fileContent.Add(currentLine) ;
      until(EOF(filePedals)); // EOF(End Of File) The the program will keep reading new lines until there is none.
    except
      on E: Exception do
      begin
        Result := 'Error loading file: ' + sFileName + ', ' + E.Message;
        HandleExcept(E, False, Result);
      end;
    end;
  finally
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
