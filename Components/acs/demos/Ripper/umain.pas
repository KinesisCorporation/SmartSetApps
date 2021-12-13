unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls, ACS_CDROM, ExtCtrls, Buttons,
  ACS_File;

type

  { TfMain }

  TfMain = class(TForm)
    bRip: TButton;
    cbDrives: TComboBox;
    cbFormat: TComboBox;
    CDIn: TACSCDIn;
    FileOut: TACSFileOut;
    Label1: TLabel;
    Label2: TLabel;
    lvTracks: TListView;
    ProgressBar: TProgressBar;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    Timer: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FileOutDone(Sender: TComponent);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbDrivesChange(Sender: TObject);
    procedure RipNextTrack;
  private
    { private declarations }
    FDirectory : string;
    FTracksCount : Integer;
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
  CDIn:= TACSCDIn.Create(nil);
  lvTracks.Column[0].Width := 60;
  lvTracks.Column[1].Width := 260;
  lvTracks.Column[2].Width := 120;
  for i := 0 to CDIn.DrivesCount-1 do
    begin
      CDIn.CurrentDrive := i;
      cbDrives.Items.Add(CDIn.DriveName);
    end;
  cbDrives.ItemIndex := 0;
end;

procedure TfMain.Button1Click(Sender: TObject);
begin
  if SelectDirectoryDialog.Execute then
    begin
      FDirectory := SelectDirectoryDialog.FileName;
      RipNextTrack;
    end;
end;

procedure TfMain.FileOutDone(Sender: TComponent);
begin
  RipNextTrack;
end;

procedure TfMain.TimerTimer(Sender: TObject);
var
  new : TListItem;
  i : Integer;
begin
  if not ((CDIn.Status = cdsReady) and (CDIn.TracksCount <> FTracksCount)) then
    exit;
  lvTracks.Items.Clear;
  for i := 0 to CDIn.Trackscount-1 do
    begin
      new := lvTracks.Items.Add;
      new.Caption := IntToStr(i);
      if CDIn.Tracks[i].TrackType = ttAudio then
        new.SubItems.Add(Format('Track %d',[i+1]))
      else
        new.SubItems.Add(Format('Datatrack %d',[i+1]));
      new.SubItems.Add(Format('%.2d:%.2d',[CDIn.Tracks[i].TrackLength.Minute,CDIn.Tracks[i].TrackLength.Second]));
    end;
  FTracksCount := CDIn.TracksCount;
end;

procedure TfMain.cbDrivesChange(Sender: TObject);
begin
  CDIn.CurrentDrive := cbDrives.ItemIndex;
end;

procedure TfMain.RipNextTrack;
var
  i : Integer;
begin
  ProgressBar.Position := 0;
  bRip.Enabled := True;
  for i := 0 to lvTracks.Items.Count-1 do
    if lvTracks.Items[i].Focused and (CDIn.Tracks[i].TrackType = ttAudio) then
      begin
        bRip.Enabled := False;
        CDIn.StartTrack := i;
        CDIn.EndTrack := i+1;
        FileOut.FileName := FDirectory+DirectorySeparator+lvTracks.Items[i].SubItems[0]+'.'+cbFormat.Text;
        FileOut.Run;
        lvTracks.Items[i].Focused := False;
        exit;
      end;
end;

initialization
  {$I umain.lrs}

end.

