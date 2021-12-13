unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WINDOWS}
    {$IFDEF DIRECTX_ENABLED}
    ACS_DXAudio,  //DirectSound Driver
    {$ENDIF}
  {$ELSE}
  acs_alsaaudio, //Alsa Driver
  ACS_AOLive,    //AO Live Driver
  {$ENDIF}
  acs_stdaudio, //Wavemapper Driver
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, EditBtn, acs_file, acs_audio, acs_allformats, acs_classes,
  TypInfo;

type

  { TFormMain }

  TFormMain = class(TForm)
    AcsAudioIn1: TAcsAudioIn;
    AcsAudioOut1: TAcsAudioOut;
    AcsFileIn1: TAcsFileIn;
    AcsFileOut1: TAcsFileOut;
    btnStart: TButton;
    btnStop: TButton;
    FileNameEditOut: TFileNameEdit;
    FileNameEditInput: TFileNameEdit;
    gbInput: TGroupBox;
    gbOutput: TGroupBox;
    gbProgress: TGroupBox;
    lbOutPosition: TLabel;
    ListBoxAudioInDrivers: TListBox;
    ListBoxAudioInDevices: TListBox;
    ListBoxAudioOutDevices: TListBox;
    ListBoxFileOutDrivers: TListBox;
    ListBoxAudioOutDrivers: TListBox;
    ListBoxFileInDrivers: TListBox;
    MemoAudioOutInfo: TMemo;
    MemoInputFileInfo: TMemo;
    MemoAudioInInfo: TMemo;
    pgcOutputTypes: TPageControl;
    pgcInputTypes: TPageControl;
    ProgressBar1: TProgressBar;
    tsInputFile: TTabSheet;
    tsOutFile: TTabSheet;
    tsOutAudioDevice: TTabSheet;
    tsInputAudioDevice: TTabSheet;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FileNameEditInputAcceptFileName(Sender: TObject; var Value: String
      );
    procedure FileNameEditOutAcceptFileName(Sender: TObject; var Value: String);
    procedure FileNameEditOutEditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxAudioInDriversSelectionChange(Sender: TObject;
      User: boolean);
    procedure ListBoxAudioOutDriversSelectionChange(Sender: TObject;
      User: boolean);
    procedure ListBoxFileOutDriversSelectionChange(Sender: TObject;
      User: boolean);
  private
    { private declarations }
    procedure OnProgressHandler(Sender: TComponent);
  public
    { public declarations }
    AcsOut: TAcsCustomOutput;
    AcsIn: TAcsCustomInput;
    procedure PrepareAudioChain();
    procedure Start();
    procedure Stop();
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

function SecondsToStr(AValue: Real): string;
begin
  Result:=Format('%.2d:%.2d:%.2d', [Round((AValue-30) / 60) mod 120, Round(AValue) mod 60, Round(AValue*100) mod 100]);
end;

procedure AcsInToStrings(AAcsIn: TAcsCustomInput; AStrings: TStrings);
begin
  if not Assigned(AAcsIn) then Exit;
  if not Assigned(AStrings) then Exit;
  AStrings.Append('Sample rate: '+IntToStr(AAcsIn.SampleRate));
  AStrings.Append('Bits per sample: '+IntToStr(AAcsIn.BitsPerSample));
  AStrings.Append('Channels: '+IntToStr(AAcsIn.Channels));
  AStrings.Append('Buffer size: '+IntToStr(AAcsIn.BufferSize));
  //AStrings.Append('Size, bytes: '+IntToStr(AAcsIn.Size));
  //AStrings.Append('Total samples: '+IntToStr(AAcsIn.TotalSamples));
  //AStrings.Append('Total time: '+SecondsToStr(AAcsIn.TotalTime));
end;

function TypeKindToStr(AValue: TTypeKind): string;
begin
  Result:='';
  case AValue of
    tkUnknown: Result:='tkUnknown';
    tkInteger: Result:='tkInteger';
    tkChar: Result:='tkChar';
    tkEnumeration: Result:='tkEnumeration';
    tkFloat: Result:='tkFloat';
    tkSet: Result:='tkSet';
    tkMethod: Result:='tkMethod';
    tkSString: Result:='tkSString';
    tkLString: Result:='tkLString';
    tkAString: Result:='tkAString';
    tkWString: Result:='tkWString';
    tkVariant: Result:='tkVariant';
    tkArray: Result:='tkArray';
    tkRecord: Result:='tkRecord';
    tkInterface: Result:='tkInterface';
    tkClass: Result:='tkClass';
    tkObject: Result:='tkObject';
    tkWChar: Result:='tkWChar';
    tkBool: Result:='tkBool';
    tkInt64: Result:='tkInt64';
    tkQWord: Result:='tkQWord';
    tkDynArray: Result:='tkDynArray';
    tkInterfaceRaw: Result:='tkInterfaceRaw';
    tkProcVar: Result:='tkProcVar';
    tkUString: Result:='tkUString';
    tkUChar: Result:='tkUChar';
    tkHelper: Result:='tkHelper';
  end;
end;

procedure AcsOutToStrings(AAcsOut: TAcsCustomOutput; AStrings: TStrings);
var
  i: Integer;
  PropList: PPropList;
  TypeData: PTypeData;
  PropName, PropTypeName, PropValue: string;
begin
  if not Assigned(AAcsOut) then Exit;
  if not Assigned(AStrings) then Exit;
  TypeData:=GetTypeData(AAcsOut.ClassInfo);
  GetMem(PropList, TypeData^.PropCount * SizeOf(Pointer));
  //GetPropList(AAcsOut, PropList);
  try
    GetPropInfos(AAcsOut.ClassInfo, PropList);
    for i:=0 to TypeData^.PropCount-1 do
    begin
      PropName:=PropList^[i]^.Name;
      PropTypeName:=TypeKindToStr(PropType(AAcsOut, PropName));
      //PropTypeName:=PropList^[i]^.PropType^.Name;
      PropValue:='';
      case PropList^[i]^.PropType^.Kind of
        tkInteger: PropValue:=IntToStr(GetInt64Prop(AAcsOut, PropName));
        tkFloat: PropValue:=FloatToStr(GetFloatProp(AAcsOut, PropName));
        tkSString..tkWString: PropValue:=GetStrProp(AAcsOut, PropName);
        tkVariant: PropValue:=GetPropValue(AAcsOut, PropName, True);
        tkEnumeration: PropValue:=GetEnumProp(AAcsOut, PropName);
      end;
      AStrings.Append(IntToStr(i)+': '+PropName+' ('+PropTypeName+') = '+PropValue);
    end;
  finally
    FreeMem(PropList);
  end;
  //for i:=0 to AAcsOut.
  //AStrings.Append('Sample rate: '+IntToStr(AAcsOut.SampleRate));
  //AStrings.Append('Bits per sample: '+IntToStr(AAcsOut.BitsPerSample));
  //AStrings.Append('Channels: '+IntToStr(AAcsOut.Channels));
  //AStrings.Append('Buffer size: '+IntToStr(AAcsOut.BufferSize));
  //AStrings.Append('Size, bytes: '+IntToStr(AAcsOut.Size));
  //AStrings.Append('Total samples: '+IntToStr(AAcsOut.TotalSamples));
  //AStrings.Append('Total time: '+SecondsToStr(AAcsOut.TotalTime));
end;

{ TFormMain }

procedure TFormMain.FileNameEditInputAcceptFileName(Sender: TObject;
  var Value: String);
begin
  AcsFileIn1.FileName:=Value;
  MemoInputFileInfo.Clear();
  if AcsFileIn1.Valid then
  begin
    AcsInToStrings(AcsFileIn1, MemoInputFileInfo.Lines);
    MemoInputFileInfo.Append('Size, bytes: '+IntToStr(AcsFileIn1.Size));
    MemoInputFileInfo.Append('Total samples: '+IntToStr(AcsFileIn1.TotalSamples));
    MemoInputFileInfo.Append('Total time: '+SecondsToStr(AcsFileIn1.TotalTime));
  end
  else
  begin
    MemoInputFileInfo.Append('Invalid file format');
  end;
end;

procedure TFormMain.FileNameEditOutAcceptFileName(Sender: TObject;
  var Value: String);
begin
  AcsFileOut1.FileName:=Value;
end;

procedure TFormMain.FileNameEditOutEditingDone(Sender: TObject);
begin
  AcsFileOut1.FileName:=FileNameEditOut.FileName;
end;

procedure TFormMain.btnStartClick(Sender: TObject);
begin
  Start();
end;

procedure TFormMain.btnStopClick(Sender: TObject);
begin
  Stop();
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // fill audio in drivers
  AcsAudioIn1.GetDriversList(ListBoxAudioInDrivers.Items);

  // fill file in drivers
  AcsFileIn1.GetDriversList(ListBoxFileInDrivers.Items);

  // fill file out drivers
  AcsFileOut1.GetDriversList(ListBoxFileOutDrivers.Items);

  // fill audio out drivers
  AcsAudioOut1.GetDriversList(ListBoxAudioOutDrivers.Items);

  btnStop.Enabled:=False;
end;

procedure TFormMain.ListBoxAudioInDriversSelectionChange(Sender: TObject;
  User: boolean);
var
  i, n: Integer;
begin
  if not User then Exit;
  for i:=0 to ListBoxAudioInDrivers.Count-1 do
  begin
    if ListBoxAudioInDrivers.Selected[i] then
    begin
      AcsAudioIn1.DriverName:=AcsAudioIn1.Drivers[i];
      // fill devices list
      ListBoxAudioInDevices.Clear();
      for n:=0 to AcsAudioIn1.DeviceCount-1 do
      begin
        ListBoxAudioInDevices.AddItem(AcsAudioIn1.DeviceInfo[n].DeviceName, nil);
        if AcsAudioIn1.Device = n then ListBoxAudioInDevices.Selected[n]:=True;
      end;
      // show info
      MemoAudioInInfo.Clear();
      AcsInToStrings(AcsAudioIn1, MemoAudioInInfo.Lines);
      Exit;
    end;
  end;
end;

procedure TFormMain.ListBoxAudioOutDriversSelectionChange(Sender: TObject;
  User: boolean);
var
  i, n: Integer;
begin
  if not User then Exit;
  for i:=0 to ListBoxAudioOutDrivers.Count-1 do
  begin
    if ListBoxAudioOutDrivers.Selected[i] then
    begin
      AcsAudioOut1.DriverName:=AcsAudioOut1.Drivers[i];
      // fill devices list
      ListBoxAudioOutDevices.Clear();
      for n:=0 to AcsAudioOut1.DeviceCount-1 do
      begin
        ListBoxAudioOutDevices.AddItem(AcsAudioOut1.DeviceInfo[n].DeviceName, nil);
        if AcsAudioOut1.Device = n then ListBoxAudioOutDevices.Selected[n]:=True;
      end;
      // show driver properties
      MemoAudioOutInfo.Lines.Clear();
      AcsOutToStrings(AcsAudioOut1.Driver, MemoAudioOutInfo.Lines);
      Exit;
    end;
  end;
end;

procedure TFormMain.ListBoxFileOutDriversSelectionChange(Sender: TObject;
  User: boolean);
var
  i: integer;
  SelectedExt: string;
begin
  if not User then Exit;
  for i:=0 to ListBoxFileOutDrivers.Count-1 do
  begin
    if ListBoxFileOutDrivers.Selected[i] then
    begin
      //ListBoxFileOutDrivers.Items.Objects[i];
    end;
  end;
  //SelectedExt:=
end;

procedure TFormMain.OnProgressHandler(Sender: TComponent);
begin
  ProgressBar1.Position:=Round(AcsFileIn1.Progress);
  lbOutPosition.Caption:=SecondsToStr(AcsOut.TimeElapsed);
end;

procedure TFormMain.PrepareAudioChain();
begin
  AcsIn:=AcsAudioIn1;
  if pgcInputTypes.ActivePage = tsInputFile then AcsIn:=AcsFileIn1;

  if pgcOutputTypes.ActivePage = tsOutAudioDevice then
  begin
    AcsOut:=AcsAudioOut1;
  end
  else if pgcOutputTypes.ActivePage = tsOutFile then
  begin
    AcsOut:=AcsFileOut1;
  end;
  AcsOut.Input:=AcsIn;
  AcsOut.OnProgress:=@OnProgressHandler;
end;

procedure TFormMain.Start();
begin
  PrepareAudioChain();
  AcsOut.Run();

  btnStart.Enabled:=not AcsOut.Active;
  btnStop.Enabled:=AcsOut.Active;
end;

procedure TFormMain.Stop();
begin
  if not Assigned(AcsOut) then Exit;
  AcsOut.Stop();
  btnStart.Enabled:=not AcsOut.Active;
  btnStop.Enabled:=AcsOut.Active;
end;

end.

