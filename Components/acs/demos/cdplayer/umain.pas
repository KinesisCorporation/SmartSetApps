unit uMain; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ACS_Audio,ACS_File,ACS_Classes,ACS_Allformats, ExtCtrls, StdCtrls, ComCtrls, acs_cdrom;

type

  { TfMain }

  TfMain = class(TForm)
    AudioOut1: TACSAudioOut;
    CDIn1: TACSCDIn;
    btRew: TBitBtn;
    btFfw: TBitBtn;
    btPlay: TBitBtn;
    btStop: TBitBtn;
    btOpen: TBitBtn;
    lTrack: TLabel;
    lTime: TLabel;
    Panel1: TPanel;
    Progress: TProgressBar;
    PlayTimer: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lTracksCount: TLabel;
    Label5: TLabel;
    lLeft: TLabel;
    procedure AudioOut1Done(Sender: TComponent);
    procedure AudioOut1Progress(Sender: TComponent);
    procedure AudioOut1ThreadException(Sender: TComponent; E: Exception);
    procedure PlayClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btFfwClick(Sender: TObject);
    procedure btRewClick(Sender: TObject);
    procedure FormCreate(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fMain: TfMain;

implementation

{ TfMain }

procedure TfMain.PlayClick(Sender: TObject);
begin
  AudioOut1.Run;
  btPlay.Enabled := False;
  btStop.Enabled := True;
  btOpen.Enabled := False;
  btRew.Enabled := False;
  btFfw.Enabled := False;
end;

procedure TfMain.AudioOut1Done(Sender: TComponent);
begin
  btPlay.Enabled := True;
  btStop.Enabled := False;
  btOpen.Enabled := True;
  btRew.Enabled := True;
  btFfw.Enabled := True;
  PlayTimer.Enabled := false;
end;

procedure TfMain.AudioOut1Progress(Sender: TComponent);
begin
  PlayTimer.Enabled := True;
end;

procedure TfMain.AudioOut1ThreadException(Sender: TComponent; E: Exception);
begin
  ShowMessage(E.Message);
end;

procedure TfMain.StopClick(Sender: TObject);
begin
  AudioOut1.Stop;
end;

procedure TfMain.OpenClick(Sender: TObject);
begin
  lTracksCount.Caption := Format('%.2d',[CDIn1.Trackscount]);
end;

procedure TfMain.Timer1Timer(Sender: TObject);
var
  tmp : real;
begin
  tmp := ((CDIn1.Position * CDIn1.TotalTime) / CDIn1.Size);
  lTime.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
  tmp := CDIn1.TotalTime-((CDIn1.Position * CDIn1.TotalTime) / CDIn1.Size);
  lLeft.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
  Progress.Position := round((CDIn1.Position * 100) / CDIn1.Size);
end;

procedure TfMain.btFfwClick(Sender: TObject);
begin
  CDIn1.StartTrack := CDIn1.StartTrack+1;
  CDIn1.EndTrack := CDIn1.StartTrack+1;
  if CDIn1.StartTrack = CDIn1.TracksCount-1 then
    btFfw.Enabled := False;
  if CDIn1.StartTrack > 0 then
    btRew.Enabled := True;
  lTrack.Caption := Format('%.2d',[CDIn1.EndTrack]);
  lLeft.Caption := '';
  lTime.Caption := '00:00:00';
end;

procedure TfMain.btRewClick(Sender: TObject);
begin
  CDIn1.StartTrack := CDIn1.StartTrack-1;
  CDIn1.EndTrack := CDIn1.StartTrack+1;
  if CDIn1.StartTrack < CDIn1.TracksCount-1 then
    btFfw.Enabled := True;
  if CDIn1.StartTrack <= 0 then
    btRew.Enabled := False;
  lTrack.Caption := Format('%.2d',[CDIn1.EndTrack]);
  lLeft.Caption := '';
  lTime.Caption := '00:00:00';
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  lTracksCount.Caption := Format('%.2d',[CDIn1.Trackscount]);
end;

initialization
  {$I umain.lrs}

end.

