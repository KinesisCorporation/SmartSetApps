(*
Miscellaneous functions and classes

This file is a part of Audio Components Suite.
All rights reserved. See the license file for more details.

Copyright (c) 2002-2009, Andrei Borovsky, anb@symmetrica.net
Copyright (c) 2005-2006  Christian Ulrich, mail@z0m3ie.de
Copyright (c) 2014-2015  Sergey Bodrov, serbod@gmail.com
*)

unit acs_misc;

interface

uses
  Classes, SysUtils, ACS_Types, ACS_Classes, ACS_Strings
  {$IFDEF LINUX}
  ,baseunix, LibAO
  {$ENDIF};

const
  BUF_SIZE = $4000;

type
  TAcsOnBufferDone = procedure(Sender: TComponent) of object;

  TAcsAudioProcessorInitEvent = procedure(Sender: TComponent; var TotalSize: Integer) of object;
  TAcsAudioProcessorDoneEvent = procedure(Sender: TComponent) of object;

  TAcsGetParameterEvent = procedure(Sender: TComponent; var Param: Integer) of object;

  TAcsGetRealParameterEvent = procedure(Sender: TComponent; var Param: real) of object;

  TAcsGetDataEvent = procedure(Sender: TComponent; Data: Pointer; var n: Integer) of object;

  TAcsMemoryIn = class(TAcsCustomInput)
  private
    FBuffer: PAcsBuffer8;
    FDataSize: Integer;
    FOnBufferDone: TAcsOnBufferDone;
    FBPS, FSR, FChan: Integer;
    function GetBuffer: Pointer;
    procedure SetBuffer(v: Pointer);
  protected
    function GetBPS: Integer; override;
    function GetCh: Integer; override;
    function GetSR: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    property DataBuffer: Pointer read GetBuffer write SetBuffer;
    property DataSize: Integer read FDataSize write FDataSize;
  published
    //property GlobalSize: Integer read FSize write FSize;
    property InBitsPerSample: Integer read GetBPS write FBPS;
    property InChannels: Integer read GetCh write FChan;
    property InSampleRate: Integer read GetSR write FSR;
    property OnBufferDone: TAcsOnBufferDone read FOnBufferDone write FOnBufferDone;
  end;

  TAcsAudioProcessor = class(TAcsCustomConverter)
  private
    FOnInit: TAcsAudioProcessorInitEvent;
    FOnDone: TAcsAudioProcessorDoneEvent;
    FOnGetData: TAcsGetDataEvent;
    FOnGetSampleRate: TAcsGetParameterEvent;
    FOnGetBitsPerSample: TAcsGetParameterEvent;
    FOnGetChannels: TAcsGetParameterEvent;
    FOnGetTotalTime: TAcsGetRealParameterEvent;
    //FOnGetSize: TAcsGetParameterEvent;
  protected
    function GetBPS: Integer; override;
    function GetCh: Integer; override;
    function GetSR: Integer; override;
  public
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
  published
    property OnDone: TAcsAudioProcessorDoneEvent read FOnDone write FOnDone;
    property OnGetBitsPerSample: TAcsGetParameterEvent read FOnGetBitsPerSample write FOnGetBitsPerSample;
    property OnGetChannels: TAcsGetParameterEvent read FOnGetChannels write FOnGetChannels;
    property OnGetData: TAcsGetDataEvent read FOnGetData write FOnGetData;
    property OnGetSampleRate: TAcsGetParameterEvent read FOnGetSampleRate write FOnGetSampleRate;
    //property OnGetSize: TAcsGetParameterEvent read FOnGetSize write FOnGetSize;
    property OnGetTotalTime: TAcsGetrealParameterEvent read FOnGetTotalTime write FOnGetTotalTime;
    property OnInit: TAcsAudioProcessorInitEvent read FOnInit write FOnInit;
  end;

  TAcsNULLOut = class(TAcsCustomOutput)
  public
    function DoOutput(Abort: Boolean): Boolean; override;
  end;

  TAcsInputItem = class(TCollectionItem)
  protected
    FInput: TAcsCustomInput;
    function GetOwner: TPersistent; override;
  published
    property Input: TAcsCustomInput read FInput write FInput;
  end;

  TAcsInputItems = class(TOwnedCollection)
  end;

  TAcsInputChangedEvent = procedure(Sender: TComponent; var Index: Integer; var Continue: Boolean) of object;

  { TAcsInputList }

  TAcsInputList = class(TAcsCustomInput)
  private
    FCurrentInput: Integer;
    FInputItems: TAcsInputItems;
    Lock: Boolean;
    FOnInputChanged: TAcsInputChangedEvent;
    FIndicateProgress: Boolean;
    procedure SetCurrentInput(AInput: Integer);
    procedure SetInputItems(AItems: TAcsInputItems);
  protected
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure Init(); override;
    procedure Done(); override;
    property CurrentInput: Integer read FCurrentInput write SetCurrentInput;
  published
    property IndicateProgress: Boolean read FIndicateProgress write FIndicateProgress;
    property InputItems: TAcsInputItems read FInputItems write SetInputItems;
    property OnInputChanged: TAcsInputChangedEvent read FOnInputChanged write FOnInputChanged;
  end;

  {
  TAcsSplitter = class(TAcsCustomConverter)
  protected
    function GetBPS(): Integer; override;
    function GetCh(): Integer; override;
    function GetSR(): Integer; override;
    procedure SetValuesCount(AValue: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function GetData(ABuffer: Pointer; ABufferSize: Integer): Integer; override;
    procedure GetValues(var Values: array of Double);
    procedure Init(); override;
    procedure Done(); override;
  end;
  }

implementation

{$IFDEF LINUX}

var
  AOInitialized : Integer = 0;

{$ENDIF}

constructor TAcsMemoryIn.Create;
begin
  inherited Create(AOwner);
  //FSize:=-1;
end;

destructor TAcsMemoryIn.Destroy;
begin
  inherited Destroy;
end;

function TAcsMemoryIn.GetBPS: Integer;
begin
  if not (FBPS in [8, 16]) then FBPS:=16;
  Result:=FBPS;
end;

function TAcsMemoryIn.GetCh: Integer;
begin
  if not (FChan in [1..2]) then FChan:=1;
  Result:=FChan;
end;

function TAcsMemoryIn.GetSR: Integer;
begin
  if (FSR < 4000) or (FSR > 48000) then FSR:=8000;
  Result:=FSR;
end;

procedure TAcsMemoryIn.Init();
begin
  inherited Init();
  BufStart:=FDataSize;
  BufEnd:=FDataSize;
end;

procedure TAcsMemoryIn.Done();
begin
  FDataSize:=0;
  inherited Done();
end;

function TAcsMemoryIn.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
begin
  Result:=0;
  if not Active then raise EAcsException.Create(strStreamnotopen);
  if not Assigned(FBuffer) then Exit;
  if BufStart > BufEnd then
  begin
    BufStart:=1;
    if FDataSize = 0 then
    begin
      if Assigned(FOnBufferDone) then FOnBufferDone(Self) else Exit;
    end;
    BufEnd:=FDataSize;
    if FDataSize = 0 then Exit;
  end;
  if ABufferSize < (BufEnd-BufStart+1) then
    Result:=ABufferSize
  else
    Result:=BufEnd-BufStart+1;
  {$R-}
  Move(FBuffer[BufStart-1], ABuffer^, Result);
  {$R+}
  Inc(BufStart, Result);
  Inc(FPosition, Result);
  Dec(FDataSize, Result);
end;

function TAcsMemoryIn.GetBuffer: Pointer;
begin
  Result:=Pointer(FBuffer);
end;

procedure TAcsMemoryIn.SetBuffer;
begin
  FBuffer:=PAcsBuffer8(v);
end;

function TAcsAudioProcessor.GetBPS: Integer;
begin
  Result:=0;
  //if not Assigned(FInput) then raise EAcsException.Create(strInputnotAssigned);
  if Assigned(FOnGetBitsPerSample) then
    FOnGetBitsPerSample(Self, Result)
  else
    if Assigned(FInput) then Result:=FInput.BitsPerSample;
end;

function TAcsAudioProcessor.GetSR: Integer;
begin
  Result:=0;
  //if not Assigned(FInput) then raise EAcsException.Create(strInputnotAssigned);
  if Assigned(FOnGetSampleRate) then
    FOnGetSampleRate(Self, Result)
  else
    if Assigned(FInput) then Result:=FInput.SampleRate;
end;

function TAcsAudioProcessor.GetCh: Integer;
begin
  Result:=0;
  //if not Assigned(FInput) then raise EAcsException.Create(strInputnotAssigned);
  if Assigned(FOnGetChannels) then
    FOnGetChannels(Self, Result)
  else
    if Assigned(FInput) then Result:=FInput.Channels;
end;

function TAcsAudioProcessor.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
begin
  //if not Assigned(FInput) then raise EAcsException.Create(strInputnotAssigned);
  if Assigned(FOnGetData) then
  begin
    Result:=ABufferSize;
    FOnGetData(Self, ABuffer, Result);
  end
  else
    if Assigned(FInput) then Result:=FInput.GetData(ABuffer, ABufferSize);
  Inc(FPosition, Result);
//  if Result=0 then Result:=(Result shl 1);
end;

procedure TAcsAudioProcessor.Init();
var
  FSize: Integer;
begin
  inherited Init();
  //if not Assigned(FInput) then raise EAcsException.Create(strInputnotAssigned);
  FSize:=0;
  if Assigned(FOnInit) then FOnInit(Self, FSize);
end;

procedure TAcsAudioProcessor.Done();
begin
  //if not Assigned(FInput) then raise EAcsException.Create(strInputnotAssigned);
  if Assigned(OnDone) then OnDone(Self);
  inherited Done();
end;

function TAcsNULLOut.DoOutput(Abort: Boolean): Boolean;
begin
  Result:=True;
  if not Active then Exit;
  if Abort or (not CanOutput) then
  begin
    Result:=False;
    Exit;
  end;

  Result:=(FillBufferFromInput()>0);
end;

function TAcsInputItem.GetOwner : TPersistent;
begin
  Result:=Collection;
end;

constructor TAcsInputList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInputItems:=TAcsInputItems.Create(Self, TAcsInputItem);
  FPosition:=0;
  //FSize:=-1;
  FIndicateProgress:=True;
end;

destructor TAcsInputList.Destroy;
begin
  FInputItems.Free;
  inherited Destroy;
end;

procedure TAcsInputList.SetCurrentInput(AInput: Integer);
var
  Item: TAcsInputItem;
begin
  if AInput <> 0 then
  begin
    if (AInput < 0) or (AInput >= FInputItems.Count) then
      raise EAcsException.Create(Format(strListIndexOOB,[AInput]));
    if Active then
    begin
      while Lock do Sleep(1);
      Lock:=True;
      Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
      Item.Input.Done();
      Item:=TAcsInputItem(InputItems.Items[AInput]);
      Item.Input.Init();
      if FIndicateProgress then
      {FSize:=Item.Input.Size
      else FSize:=-1; }
      FPosition:=0;
      Lock:=False;
    end;
  end;
  FCurrentInput:=AInput;
end;

function TAcsInputList.GetBPS(): Integer;
var
  Item: TAcsInputItem;
begin
  Result:=0;
  if Active then
  begin
    Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
    if Assigned(Item.Input) then Result:=Item.Input.BitsPerSample;
  end
  else
  begin
    if InputItems.Count > 0 then
    begin
      Item:=TAcsInputItem(InputItems.Items[0]);
      if Assigned(Item.Input) then Result:=Item.Input.BitsPerSample;
    end;
  end;
end;

function TAcsInputList.GetCh(): Integer;
var
  Item: TAcsInputItem;
begin
  Result:=0;
  if Active then
  begin
    Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
    if Assigned(Item.Input) then Result:=Item.Input.Channels;
  end
  else
  begin
    if InputItems.Count > 0 then
    begin
      Item:=TAcsInputItem(InputItems.Items[0]);
      if Assigned(Item.Input) then Result:=Item.Input.Channels;
    end;
  end;
end;

function TAcsInputList.GetSR(): Integer;
var
  Item: TAcsInputItem;
begin
  Result:=0;
  if Active then
  begin
    Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
    if Assigned(Item.Input) then Result:=Item.Input.SampleRate;
  end else
  if InputItems.Count > 0 then
  begin
    Item:=TAcsInputItem(InputItems.Items[0]);
    if Assigned(Item.Input) then Result:=Item.Input.SampleRate;
  end;
end;

procedure TAcsInputList.Init();
var
  Item: TAcsInputItem;
begin
  if Active then
    raise EAcsException.Create(strBusy);
  if InputItems.Count = 0 then
    raise EAcsException.Create(strNoInputItems);
  Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
  if not Assigned(Item.Input) then
    raise EAcsException.Create(Format(strNoInputAssigned, [FCurrentInput]));
  FActive:=True;
  Item.Input.Init();
  FPosition:=0;
end;

procedure TAcsInputList.Done();
var
  Item: TAcsInputItem;
begin
  Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
  if Assigned(Item.Input) then Item.Input.Done();
  FCurrentInput:=0;
  Lock:=False;
  FActive:=False;
end;

function TAcsInputList.GetData(ABuffer: Pointer; ABufferSize: Integer): Integer;
var
  Item: TAcsInputItem;
  IsContinue: Boolean;
begin
  Result:=0;
  while Lock do Sleep(1);
  Lock:=True;
  Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
  if Assigned(Item.Input) then Result:=Item.Input.GetData(ABuffer, ABufferSize);
  while Result=0 do
  begin
    if FCurrentInput < InputItems.Count-1 then
    begin
      if Assigned(Item.Input) then Item.Input.Done();
      Inc(FCurrentInput);
      IsContinue:=True;
      if Assigned(FonInputChanged) then
        FonInputChanged(Self, FCurrentInput, IsContinue);
      if IsContinue then
      begin
        Item:=TAcsInputItem(InputItems.Items[FCurrentInput]);
        if not Assigned(Item.Input) then
          raise EAcsException.Create(Format(strNoInputAssigned, [FCurrentInput]));
        Item.Input.Init();
        {if FIndicateProgress then
          FSize:=Item.Input.Size
        else FSize:=-1;  }
        FPosition:=0;
        Result:=Item.Input.GetData(ABuffer, ABufferSize);
      end
      else Break;
    end
    else Break;
  end;
  if FIndicateProgress then FPosition:=Item.Input.Position;
  Lock:=False;
end;

procedure TAcsInputList.SetInputItems(AItems: TAcsInputItems);
begin
  FInputItems.Assign(AItems);
end;
end.
