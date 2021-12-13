unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, acs_file, acs_audio, EditBtn,acs_classes,acs_mixer;

type

  { TfMain }

  TfMain = class(TForm)
    bOpen: TBitBtn;
    AudioIn1: TACSAudioIn;
    FileOut1: TACSFileOut;
    bRecord: TBitBtn;
    bStop: TBitBtn;
    cbRecordSource: TComboBox;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure bOpenClick(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure cbRecordSourceChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fMain: TfMain;

implementation

{ TfMain }

procedure TfMain.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to AudioIn1.DeviceCount-1 do
    cbRecordSource.Items.Add(AudioIn1.DeviceInfo[i].DeviceName);
end;

procedure TfMain.bOpenClick(Sender: TObject);
var
  desc: String;
begin
  FileFormats.BuildFilterStrings(desc, [fcSave]);
  OpenDialog1.Filter:=desc;
  if OpenDialog1.Execute then
    begin
      FileOut1.FileName:=OpenDialog1.FileName;
      if FileExists(FileOut1.FileName) then
        FileOut1.FileMode := foAppend;
    end;
end;

procedure TfMain.bRecordClick(Sender: TObject);
begin
  AudioIn1.Device:=4;
  FileOut1.Run;
end;

procedure TfMain.bStopClick(Sender: TObject);
begin
  FileOut1.Stop;
end;

procedure TfMain.cbRecordSourceChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to AudioIn1.DeviceCount-1 do
    if AudioIn1.DeviceInfo[i].DeviceName=cbRecordSource.Text then
      AudioIn1.Device:=i;
end;

initialization
  {$I umain.lrs}

end.

