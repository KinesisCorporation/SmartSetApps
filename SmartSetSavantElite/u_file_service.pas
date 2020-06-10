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
    FLPedal: TPedalText;
    FMPedal: TPedalText;
    FRPedal: TPedalText;
    FJack1: TPedalText;
    FJack2: TPedalText;
    FJack3: TPedalText;
    FJack4: TPedalText;
    function GetCompleteFileName: string;
    function CheckFileValid: boolean;
    function GetPedalText(aPedal: TPedalText; aPedalType: TPedal): string;
    procedure ClearPedals;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function LoadFile(sFileName: string; criticalFile: boolean): string;
    function SaveFile(var error: string): boolean;
    function LoadPedals: boolean;
    function CheckIfFileExists(sFileName: string): boolean;
    function SetNewFileName(sFileName: string): boolean;

    property FileIsValid: boolean read CheckFileValid;
    //property FileContent: TStringList read FFileContent write FFileContent;
    property FilePath: string read FFilePath write FFilePath;
    property FileName: string read FFileName write FFileName;
    property CompleteFileName: string read GetCompleteFileName;
    property NewFile: boolean read FNewFile write FNewFile;
    property LPedal: TPedalText read FLPedal write FLPedal;
    property MPedal: TPedalText read FMPedal write FMPedal;
    property RPedal: TPedalText read FRPedal write FRPedal;
    property Jack1: TPedalText read FJack1 write FJack1;
    property Jack2: TPedalText read FJack2 write FJack2;
    property Jack3: TPedalText read FJack3 write FJack3;
    property Jack4: TPedalText read FJack4 write FJack4;
  end;

implementation

{ TFileService }

constructor TFileService.Create;
begin
  inherited Create;
  FFileContent := TStringList.Create;
  FNewFile := false;
  FLPedal.MultiKey := false;
  FMPedal.MultiKey := false;
  FRPedal.MultiKey := false;
  FJack1.MultiKey := false;
  FJack2.MultiKey := false;
  FJack3.MultiKey := false;
  FJack4.MultiKey := false;
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

//Receives complete file name and tries to load file
function TFileService.LoadFile(sFileName: string; criticalFile: boolean): string;
var
  filePedals: TextFile;
  currentLine: string;
begin
  Result := '';
  FFilePath := IncludeTrailingBackslash(ExtractFileDir(sFileName));
  FFileName := ExtractFileName(sFileName);
  FFileContent.Clear;

  //Tries to load file content in string list
  try
    try
      AssignFile(filePedals, FFilePath + FFileName);
      Reset(filePedals);
      repeat
        Readln(filePedals, currentLine); // Reads the whole line from the file
        FFileContent.Add(currentLine) ;
      until(EOF(filePedals)); // EOF(End Of File) The the program will keep reading new lines until there is none.
      LoadPedals;
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

//Clear pedal values
procedure TFileService.ClearPedals;
begin
  FLPedal.PedalText := '';
  FLPedal.MultiKey := false;
  FMPedal.PedalText := '';
  FMPedal.MultiKey := false;
  FRPedal.PedalText := '';
  FRPedal.MultiKey := false;
  FJack1.PedalText := '';
  FJack1.MultiKey := false;
  FJack2.PedalText := '';
  FJack2.MultiKey := false;
  FJack3.PedalText := '';
  FJack3.MultiKey := false;
  FJack4.PedalText := '';
  FJack4.MultiKey := false;
end;

//Loads pedals from text file
function TFileService.LoadPedals: boolean;
var
  i:integer;
  currentLine: string;
  iLenPed, iLenJack: integer;
begin
  result := false;
  ClearPedals;

  if FFileContent.Text <> '' then
  begin
    iLenPed := Length(LEFT_PEDAL_TEXT_SINGLE);
    iLenJack := Length(JACK1_PEDAL_TEXT_SINGLE);
    result := true;
    for i:=0 to FFileContent.Count - 1 do
    begin
      currentLine := AnsiLowerCase(FFileContent.Strings[i]);

      if (Copy(currentLine, 1, iLenPed) = LEFT_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenPed) = LEFT_PEDAL_TEXT_MULTI) then
      begin
        FLPedal.PedalText := Copy(currentLine, iLenPed + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenPed) = LEFT_PEDAL_TEXT_MULTI then
          FLPedal.MultiKey := true;
      end
      else if (Copy(currentLine, 1, iLenPed) = MIDDLE_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenPed) = MIDDLE_PEDAL_TEXT_MULTI) then
      begin
        FMPedal.PedalText := Copy(currentLine, iLenPed + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenPed) = MIDDLE_PEDAL_TEXT_MULTI then
            FMPedal.MultiKey := true;
      end
      else if (Copy(currentLine, 1, iLenPed) = RIGHT_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenPed) = RIGHT_PEDAL_TEXT_MULTI) then
      begin
        FRPedal.PedalText := Copy(currentLine, iLenPed + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenPed) = RIGHT_PEDAL_TEXT_MULTI then
            FRPedal.MultiKey := true;
      end
      else if (Copy(currentLine, 1, iLenJack) = JACK1_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK1_PEDAL_TEXT_MULTI) then
      begin
        FJack1.PedalText := Copy(currentLine, iLenJack + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenJack) = JACK1_PEDAL_TEXT_MULTI then
            FJack1.MultiKey := true;
      end
      else if (Copy(currentLine, 1, iLenJack) = JACK2_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK2_PEDAL_TEXT_MULTI) then
      begin
        FJack2.PedalText := Copy(currentLine, iLenJack + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenJack) = JACK2_PEDAL_TEXT_MULTI then
            FJack2.MultiKey := true;
      end
      else if (Copy(currentLine, 1, iLenJack) = JACK3_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK3_PEDAL_TEXT_MULTI) then
      begin
        FJack3.PedalText := Copy(currentLine, iLenJack + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenJack) = JACK3_PEDAL_TEXT_MULTI then
            FJack3.MultiKey := true;
      end
      else if (Copy(currentLine, 1, iLenJack) = JACK4_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK4_PEDAL_TEXT_MULTI) then
      begin
        FJack4.PedalText := Copy(currentLine, iLenJack + 2, Length(currentLine));
        if Copy(currentLine, 1, iLenJack) = JACK4_PEDAL_TEXT_MULTI then
            FJack4.MultiKey := true;
      end;
    end;
  end;
end;

//Save pedal content to text file
function TFileService.SaveFile(var error: string): boolean;
var
  i:integer;
  currentLine: string;
  iLenPed, iLenJack: integer;
  canSave: boolean;
  filePedals: TextFile;
begin
  error := '';
  result := false;

  if FFileContent.Text = '' then
  begin
    FFileContent.Add(GetPedalText(LPedal, pLeft));
    FFileContent.Add(GetPedalText(MPedal, pMiddle));
    FFileContent.Add(GetPedalText(RPedal, pRight));
    FFileContent.Add(GetPedalText(Jack1, pJack1));
    FFileContent.Add(GetPedalText(Jack2, pJack2));
    FFileContent.Add(GetPedalText(Jack3, pJack3));
    FFileContent.Add(GetPedalText(Jack4, pJack4));
    canSave := true;
  end
  else if FFileContent.Text <> '' then
  begin
    iLenPed := Length(LEFT_PEDAL_TEXT_SINGLE);
    iLenJack := Length(JACK1_PEDAL_TEXT_SINGLE);

    for i:=0 to FFileContent.Count - 1 do
    begin
      currentLine := AnsiLowerCase(FFileContent.Strings[i]);

      if (Copy(currentLine, 1, iLenPed) = LEFT_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenPed) = LEFT_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(LPedal, pLeft)
      else if (Copy(currentLine, 1, iLenPed) = MIDDLE_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenPed) = MIDDLE_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(MPedal, pMiddle)
      else if (Copy(currentLine, 1, iLenPed) = RIGHT_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenPed) = RIGHT_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(RPedal, pRight)
      else if (Copy(currentLine, 1, iLenJack) = JACK1_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK1_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(Jack1, pJack1)
      else if (Copy(currentLine, 1, iLenJack) = JACK2_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK2_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(Jack2, pJack2)
      else if (Copy(currentLine, 1, iLenJack) = JACK3_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK3_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(Jack3, pJack3)
      else if (Copy(currentLine, 1, iLenJack) = JACK4_PEDAL_TEXT_SINGLE) or
        (Copy(currentLine, 1, iLenJack) = JACK4_PEDAL_TEXT_MULTI) then
        FFileContent.Strings[i] := GetPedalText(Jack4, pJack4);
    end;
    canSave := true;
  end;

  if canSave then
  begin
    //Tries to save string list to file
    try
      try
        DeleteFile(FFilePath + FFileName);
        AssignFile(filePedals, FFilePath + FFileName);
        //Erase(filePedals); //Erases file
        Rewrite(filePedals);  // creating the file
        for i := 0 to FFileContent.Count - 1 do
          Writeln(filePedals, FFileContent.Strings[i]);
        result := true;
        FNewFile := false; //removes new file flag
      except
        on E: Exception do
        begin
          error := 'Error saving file: ' + FFilePath + FFileName + ', ' + E.Message;
          HandleExcept(E, False, error);
        end;
      end;
    finally
      CloseFile(filePedals);
    end;
  end;
end;

end.
