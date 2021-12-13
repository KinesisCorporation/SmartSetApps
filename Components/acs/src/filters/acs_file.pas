(*
Base file in/out classes

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

{
@abstract(this unit introduces basic fileformat support for acs)
@author(Christian Ulrich (2005))
}

unit acs_file;

interface

uses
  Classes, acs_classes, SysUtils, ACS_Strings;

type
  TAcsFileInClass = class of TAcsCustomFileIn;
  TAcsFileOutClass = class of TAcsCustomFileOut;

  TAcsFileCapTyp = (fcLoad, fcSave);
  TAcsFileCapTyps = set of TAcsFileCapTyp;


  TAcsFormatClass = class of TComponent;

  { TAcsFileFormat }
  TAcsFileFormat = class
  public
    FileClass       : TAcsFormatClass;
    Extension       : String;
    Description     : String;
  end;

  { TAcsFileFormatsList

    To this List all Filefomats must be added,
    use initialization section of your format units to add your format to acs
    so the user must only add your unit to the uses clausle to have support for
    your fileformat.
  }
  TAcsFileFormatsList = class (TList)
  public
    destructor Destroy; override;
    procedure Add(const Ext, Desc: String; AClass: TAcsFormatClass);
    function FindExt(Ext: string; Typs: TAcsFileCapTyps): TAcsFormatClass;
    function FindFromFileName(const FileName: String; Typs: TAcsFileCapTyps): TAcsFormatClass;
    procedure Remove(AClass: TAcsFormatClass);
    procedure BuildFilterStrings(var Descriptions: String; Typs: TAcsFileCapTyps);
    function GetItem(Index: Integer): TAcsFileFormat;
  end;


  { TAcsFileOut }
  { Wrapper for all fileformats }
  TAcsFileOut = class(TAcsCustomFileOut)
  private
    FBufferSize: Integer;
    FFileName: string;
    FInput: TAcsCustomInput;
    FOutput: TAcsCustomFileOut;
    //FDialog: TSaveDialog;
  protected
    //FBaseChannel: Integer;
    function GetDelay(): Integer; override;
    procedure SetDelay(Value: Integer); override;
    function GetPriority(): TThreadPriority; override;
    procedure SetPriority(Priority: TThreadPriority); override;
    function GetStatus(): TAcsOutputStatus; override;
    function GetTE(): Real; override;
    function GetActive(): Boolean; override;

    procedure OutputDone(Sender: TComponent);
    procedure OutputProgress(Sender: TComponent);
    procedure ThreadException(Sender: TComponent; E: Exception);

    procedure SetInput(AInput: TAcsCustomInput); override;
    procedure SetFileMode(aMode: TAcsFileOutputMode); override;
    procedure SetFileName(const AValue: string);

    function GetDriversCount(): Integer;
    function GetDriverName(idx: Integer): string;
    procedure SetDriver(ADriver: string); virtual;
    procedure SetDefaultDriver();
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure Init(); override;
    procedure Done(); override;
    function DoOutput(Abort: Boolean): Boolean; override;
    procedure Open();
    procedure Pause(); override;
    procedure Resume(); override;
    procedure Run(); override;
    procedure Stop(); override;

    { This can be used to enumerate the Drivers
      use 0..DriversCount-1 as index, it returns the DriverName }
    property Drivers[idx: Integer]: string read GetDriverName;
    { Returns the total count of avalible drivers }
    property DriversCount: Integer read GetDriversCount;
    { Fill AValue by available drivers names }
    function GetDriversList(AValue: TStrings): Boolean;
  published
    property FileName: string read FFileName write SetFileName;
    property Input: TAcsCustomInput read FInput write SetInput;
    property BufferSize: Integer read FBufferSize write FBufferSize;
    property OnDone;
    property OnProgress;
    property OnThreadException;
  end;

  { TAcsFileIn }
  { Wrapper for all fileformats }
  TAcsFileIn = class(TAcsCustomFileIn)
  private
    FInput: TAcsCustomFileIn;
    //FDialog: TOpenDialog;
    //FTotalSamples: Integer;
  protected
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
    function GetTotalTime(): Real; override;
    function GetValid(): Boolean; override;
    procedure SetFileName(const AValue: TFileName); override;
    function GetSize(): Integer; override;
    function GetPosition(): Integer; override;
    function GetPositionTime(): Real; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open();
    procedure Done(); override;
    procedure Init(); override;
    procedure Reset(); override;
    function Seek(SampleNum: Integer): Boolean; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    function SetStartTime(Minutes, Seconds: Integer): Boolean;
    function SetEndTime(Minutes, Seconds: Integer): Boolean;
    procedure Jump(Offs: Real); override;
    { Fill AValue by available drivers names }
    function GetDriversList(AValue: TStrings): Boolean;
    function GetFileOpenFilterString(): string;
    property Input: TAcsCustomFileIn read FInput;
  published
    property FileName;
  end;


var
  FileFormats: TAcsFileFormatsList;

implementation


{ TAcsFileIn }

function TAcsFileIn.GetBPS(): Integer;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.BitsPerSample;
end;

function TAcsFileIn.GetCh(): Integer;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.Channels;
end;

function TAcsFileIn.GetSR(): Integer;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.SampleRate;
end;

function TAcsFileIn.GetValid(): Boolean;
begin
  Result:=False;
  if Assigned(FInput) then Result:=FInput.Valid;
end;

function TAcsFileIn.GetTotalTime(): Real;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.TotalTime
end;

procedure TAcsFileIn.Reset();
begin
  if Assigned(FInput) then FInput.Reset;
end;

procedure TAcsFileIn.SetFileName(const AValue: TFileName);
var
  AcsFormatClass: TAcsFormatClass;
begin
  FFileName:=AValue;
  if Assigned(FInput) then FreeAndNil(FInput);
  if AValue='' then Exit;
  AcsFormatClass:=FileFormats.FindFromFileName(AValue, [fcLoad]);
  if Assigned(AcsFormatClass) then
  begin
    FInput:=TAcsFileInClass(AcsFormatClass).Create(nil);
    if Assigned(FInput) then FInput.FileName:=FFilename;
  end;
end;

function TAcsFileIn.GetSize(): Integer;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.Size;
end;

function TAcsFileIn.GetPosition(): Integer;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.Position;
end;

function TAcsFileIn.GetPositionTime(): Real;
begin
  Result:=inherited GetPositionTime();
  if Assigned(FInput) then Result:=FInput.PositionTime;
end;

constructor TAcsFileIn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInput:=nil;
  FFileName:='';
  FOpened:=False;
  FValid:=False;
end;

destructor TAcsFileIn.Destroy();
begin
  if Assigned(FInput) then FreeAndNil(FInput);
  inherited Destroy;
end;

procedure TAcsFileIn.Open();
var
  desc: string;
begin
  desc:='';
  FileFormats.BuildFilterStrings(desc, [fcLoad]);
  {
  FDialog:=TOpenDialog.Create(nil);
  FDialog.Filter:=desc;
  if FDialog.Execute then
  begin
    SetFileName(FDialog.FileName);
  end;
  FDialog.Free;
  }
end;

procedure TAcsFileIn.Done();
begin
  if Assigned(FInput) then FInput.Done();
end;

procedure TAcsFileIn.Init();
begin
  if Assigned(FInput) then FInput.Init();
end;

function TAcsFileIn.Seek(SampleNum: Integer): Boolean;
begin
  Result:=False;
  if Assigned(FInput) then Result:=FInput.Seek(SampleNum);
end;

function TAcsFileIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
begin
  Result:=0;
  if Assigned(FInput) then Result:=FInput.GetData(ABuffer, ABufferSize);
    //raise EAcsException.Create(strNoFileOpened);
end;

function TAcsFileIn.SetStartTime(Minutes, Seconds: Integer): Boolean;
begin
  Result:=False;
  if Assigned(FInput) then Result:=FInput.SetStartTime(Minutes, Seconds);
    //raise EAcsException.Create(strNoFileOpened);
end;

function TAcsFileIn.SetEndTime(Minutes, Seconds: Integer): Boolean;
begin
  Result:=False;
  if Assigned(FInput) then Result:=FInput.SetEndTime(Minutes, Seconds);
    //raise EAcsException.Create(strNoFileOpened);
end;

procedure TAcsFileIn.Jump(Offs: Real);
begin
  if Assigned(FInput) then FInput.Jump(Offs);
    //raise EAcsException.Create(strNoFileOpened);
end;

function TAcsFileIn.GetDriversList(AValue: TStrings): Boolean;
var
  i: integer;
  Item: TAcsFileFormat;
begin
  Result:=False;
  if not Assigned(AValue) then Exit;
  AValue.Clear();
  for i:=0 to FileFormats.Count-1 do
  begin
    Item:=FileFormats.GetItem(i);
    if Item.FileClass.InheritsFrom(TAcsCustomFileIn) then
      AValue.AddObject(Item.Description+' ('+Item.Extension+')', Item);
  end;
  Result:=True;
end;

function TAcsFileIn.GetFileOpenFilterString(): string;
begin
  FileFormats.BuildFilterStrings(Result, [fcLoad]);
end;

{ TAcsFileOut }

procedure TAcsFileOut.SetFileName(const AValue: string);
var
  AcsFormatClass: TAcsFormatClass;
begin
  if FFileName=AValue then Exit;
  AcsFormatClass:=FileFormats.FindFromFileName(AValue, [fcSave]);
  if Assigned(AcsFormatClass) then
  begin
    FFileName:=AValue;
    SetDefaultDriver();
  end;
end;

function TAcsFileOut.GetDriversCount(): Integer;
var
  i: integer;
  Item: TAcsFileFormat;
begin
  Result:=0;
  for i:=0 to FileFormats.Count-1 do
  begin
    Item:=FileFormats.GetItem(i);
    if Item.FileClass.InheritsFrom(TAcsCustomFileOut) then Inc(Result);
  end;
end;

function TAcsFileOut.GetDriverName(idx: Integer): string;
var
  i, n: integer;
  Item: TAcsFileFormat;
begin
  Result:='';
  n:=0;
  for i:=0 to FileFormats.Count-1 do
  begin
    Item:=FileFormats.GetItem(i);
    if not Item.FileClass.InheritsFrom(TAcsCustomFileOut) then Continue;
    if idx = n then
    begin
      Result:=Item.Description;
      Exit;
    end;
    Inc(n);
  end;
end;

procedure TAcsFileOut.SetDriver(ADriver: string);
var
  i: integer;
  Item: TAcsFileFormat;
begin
  for i:=0 to FileFormats.Count-1 do
  begin
    Item:=FileFormats.GetItem(i);
    if Item.FileClass.InheritsFrom(TAcsCustomFileOut) then
    begin
      if Item.Description = ADriver then
      begin
        if Assigned(FOutput) then FreeAndNil(FOutput);
        FOutput:=TAcsFileOutClass(Item.FileClass).Create(nil);
        if Assigned(FOutput) then
        begin
          FOutput.FileName:=FFileName;
          FOutput.FileMode:=FFileMode; //GAK:20060731
          FOutput.Input:=FInput;
          FOutput.OnDone:=OutputDone;
          FOutput.OnProgress:=OutputProgress;
          FOutput.OnThreadException:=ThreadException;
        end;
        Exit;
      end;
    end;
  end;
end;

procedure TAcsFileOut.SetDefaultDriver();
var
  AcsFormatClass: TAcsFormatClass;
begin
  if Assigned(FOutput) then FreeAndNil(FOutput);
  AcsFormatClass:=FileFormats.FindFromFileName(FFileName, [fcSave]);
  if Assigned(AcsFormatClass) then
  begin
    FOutput:=TAcsFileOutClass(AcsFormatClass).Create(nil);
    if Assigned(FOutput) then
    begin
      FOutput.FileName:=FFileName;
      FOutput.FileMode:=FFileMode; //GAK:20060731
      FOutput.Input:=FInput;
      FOutput.OnDone:=OutputDone;
      FOutput.OnProgress:=OutputProgress;
      FOutput.OnThreadException:=ThreadException;
    end;
  end;
end;

constructor TAcsFileOut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInput:=nil;
  FOutput:=nil;
end;

procedure TAcsFileOut.Init();
begin
  if Assigned(FOutput) then FOutput.Init();
end;

procedure TAcsFileOut.Done();
begin
  if Assigned(FOutput) then FOutput.Done();
end;

function TAcsFileOut.DoOutput(Abort: Boolean): Boolean;
begin
  Result:=False;
  if not Assigned(FOutput) then Result:=FOutput.DoOutput(Abort);
end;

function TAcsFileOut.GetDelay(): Integer;
begin
  Result:=0;
  if not Assigned(FOutput) then Result:=FOutput.Delay;
end;

function TAcsFileOut.GetPriority(): TThreadPriority;
begin
  Result:=TThreadPriority.tpNormal;
  if not Assigned(FOutput) then Result:=FOutput.ThreadPriority;
end;

function TAcsFileOut.GetStatus(): TAcsOutputStatus;
begin
  Result:=TAcsOutputStatus.tosUndefined;
  if Assigned(FOutput) then Result:=FOutput.Status;
end;

function TAcsFileOut.GetTE(): Real;
begin
  Result:=0;
  if Assigned(FOutput) then Result:=FOutput.TimeElapsed;
end;

function TAcsFileOut.GetActive(): Boolean;
begin
  if Assigned(FOutput) then
    Result:=FOutput.Active
  else
    Result:=False;
end;

procedure TAcsFileOut.SetDelay(Value: Integer);
begin
  if Assigned(FOutput) then FOutput.Delay:=Value;
end;

procedure TAcsFileOut.SetPriority(Priority: TThreadPriority);
begin
  if Assigned(FOutput) then FOutput.ThreadPriority:=Priority;
end;

procedure TAcsFileOut.ThreadException(Sender: TComponent; E: Exception);
begin
  if Assigned(OnThreadException) then OnThreadException(Sender, E);
end;

procedure TAcsFileOut.OutputDone(Sender: TComponent);
begin
  if Assigned(OnDone) then OnDone(Sender);
end;

procedure TAcsFileOut.OutputProgress(Sender: TComponent);
begin
  if Assigned(OnProgress) then OnProgress(Sender);
end;

procedure TAcsFileOut.SetInput(AInput: TAcsCustomInput);
begin
  FInput:=AInput;
  if Assigned(FOutput) then FOutput.Input:=FInput;
end;

procedure TAcsFileOut.SetFileMode(aMode: TAcsFileOutputMode);
begin
  // GAK:20060731 changed whole of this method, as it was stopping component loading/creating
  if AMode <> FFileMode then
  begin
    FFileMode:=AMode;
    if Assigned(FOutput) then FOutput.FileMode:=AMode;
  end;
end;

procedure TAcsFileOut.Open();
var
  desc: string;
begin
  desc:='';
  FileFormats.BuildFilterStrings(desc, [fcSave]);
  {
  FDialog:=TSaveDialog.Create(nil);
  FDialog.Filter:=desc;
  if FDialog.Execute then
  begin
    SetFileName(FDialog.FileName);
  end;
  FreeAndNil(FDialog);
  }
end;

procedure TAcsFileOut.Pause();
begin
  if Assigned(FOutput) then FOutput.Pause();
end;

procedure TAcsFileOut.Resume();
begin
  if Assigned(FOutput) then FOutput.Resume();
end;

procedure TAcsFileOut.Run();
begin
  if Assigned(FOutput) then FOutput.Run();
end;

procedure TAcsFileOut.Stop();
begin
  if Assigned(FOutput) then FOutput.Stop();
end;

function TAcsFileOut.GetDriversList(AValue: TStrings): Boolean;
var
  i: integer;
  Item: TAcsFileFormat;
begin
  Result:=False;
  if not Assigned(AValue) then Exit;
  AValue.Clear();
  for i:=0 to FileFormats.Count-1 do
  begin
    Item:=FileFormats.GetItem(i);
    if Item.FileClass.InheritsFrom(TAcsCustomFileOut) then
      AValue.AddObject(Item.Description+' ('+Item.Extension+')', Item);
  end;
  Result:=True;
end;

destructor TAcsFileOut.Destroy;
begin
  if Assigned(FOutput) then FreeAndNil(FOutput);
  inherited Destroy;
end;

{ TAcsFileFormatsList }

destructor TAcsFileFormatsList.Destroy;
var
  i: integer;
begin
  for i:=0 to Count-1 do TAcsFileFormat(Items[i]).Free;
  inherited Destroy;
end;

procedure TAcsFileFormatsList.Add(const Ext, Desc: String; AClass: TAcsFormatClass);
var
  newRec: TAcsFileFormat;
begin
  newRec:=TAcsFileFormat.Create;
  with newRec do
  begin
    Extension:=LowerCase(Ext);
    FileClass:=AClass;
    Description:=Desc;
  end;
  inherited Add(newRec);
end;

function TAcsFileFormatsList.FindExt(Ext: string; Typs: TAcsFileCapTyps): TAcsFormatClass;
var
  i: Integer;
begin
  Ext:=LowerCase(Ext);
  for i:=Count-1 downto 0 do
  begin
    with TAcsFileFormat(Items[i]) do
    begin
      if ((fcLoad in Typs) and (TAcsFileFormat(Items[i]).FileClass.InheritsFrom(TAcsCustomFileIn)))
      or ((fcSave in Typs) and (TAcsFileFormat(Items[i]).FileClass.InheritsFrom(TAcsCustomFileOut))) then
      begin
        if Extension=Ext then
        begin
          Result:=TAcsFileFormat(Items[i]).FileClass;
          Exit;
        end;
      end;
    end;
  end;
  Result:=nil;
end;

function TAcsFileFormatsList.FindFromFileName(const FileName: String;
  Typs: TAcsFileCapTyps): TAcsFormatClass;
var
  Ext: String;
begin
  Ext:=ExtractFileExt(Filename);
  System.Delete(Ext, 1, 1);
  Result:=FindExt(Ext, Typs);
  //if not Assigned(Result) then
  //  raise EAcsException.CreateFmt(strUnknownExtension, [Ext]);
end;

procedure TAcsFileFormatsList.Remove(AClass: TAcsFormatClass);
var
  i: Integer;
begin
  for i:=Count-1 downto 0 do
  begin
    if TAcsFileFormat(Items[i]).FileClass.InheritsFrom(AClass) then
    begin
      TAcsFileFormat(Items[i]).Free;
      Delete(i);
    end;
  end;
end;

procedure TAcsFileFormatsList.BuildFilterStrings(var Descriptions: String;
  Typs: TAcsFileCapTyps);
var
  k, i: Integer;
  FileFormat: TAcsFileFormat;
  sFilters: string;
begin
  Descriptions:='';
  sFilters := '';
  k:=0;
  for i:=0 to Count-1 do
  begin
    FileFormat:=TAcsFileFormat(Items[i]);
    if ((fcLoad in Typs) and (FileFormat.FileClass.InheritsFrom(TAcsCustomFileIn)))
    or ((fcSave in Typs) and (FileFormat.FileClass.InheritsFrom(TAcsCustomFileOut))) then
    begin
      with FileFormat do
      begin
        if k<>0 then
        begin
          Descriptions:=Descriptions+'|';
          sFilters:=sFilters+';';
        end;
        Descriptions:=Descriptions+Description+' (*.'+Extension+')|'+'*.'+Extension;
        sFilters:=sFilters+'*.'+Extension;
        Inc(k);
      end;
    end;
  end;
  Descriptions:=strAllFormats+'|'+sFilters+'|'+Descriptions;
end;

function TAcsFileFormatsList.GetItem(Index: Integer): TAcsFileFormat;
begin
  Result:=nil;
  if (Index >= 0) and (Index < Count) then Result:=TAcsFileFormat(Self.Items[Index]);
end;

initialization

  FileFormats:=TAcsFileFormatsList.Create;

finalization

  FileFormats.Free;

end.

