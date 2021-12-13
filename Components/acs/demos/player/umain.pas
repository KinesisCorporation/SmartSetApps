unit uMain;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  LResources,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons,
  ACS_Audio, ACS_File, ACS_Classes, ACS_Allformats, ExtCtrls, StdCtrls,
  ComCtrls, uPlaylist, ACS_Indicator, uvis
  //You must include Output drivers to not get an "No drier selected" exception
  {$IFDEF WINDOWS}
    {$IFDEF DIRECTX_ENABLED}
    ,ACS_DXAudio  //DirectSound Driver
    {$ENDIF}
  {$ELSE}
  ,acs_alsaaudio //Alsa Driver
//  ,ACS_AOLive    //AO Live Driver
  {$ENDIF}
  ,acs_stdaudio //Wavemapper Driver
  ;

type
  TTimeFormat = (tfElapsed,tfRemain);

  { TfMain }

  TfMain = class(TForm)
    AudioOut1: TACSAudioOut;
    btVizu: TBitBtn;
    btPlaylist: TBitBtn;
    btPause: TBitBtn;
    btRew: TBitBtn;
    btFfw: TBitBtn;
    btPlay: TBitBtn;
    btStop: TBitBtn;
    btOpen: TBitBtn;
    FileIn1: TACSFileIn;
    lLeft: TLabel;
    lFilename: TLabel;
    lTime: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Progress: TProgressBar;
    PlayTimer: TTimer;
    lTime1: TLabel;
    lTime2: TLabel;
    SoundIndicator: TACSSoundIndicator;
    procedure AudioOut1Done(Sender: TComponent);
    procedure AudioOut1ThreadException(Sender: TComponent; E: Exception);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Pauseclick(Sender: TObject);
    procedure PlayClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btFfwClick(Sender: TObject);
    procedure btPlaylistClick(Sender: TObject);
    procedure btRewClick(Sender: TObject);
    procedure btVizuClick(Sender: TObject);
    procedure lTime1Click(Sender: TObject);
    procedure resetDisplay;
  private
    { private declarations }
    FPaused : Boolean;
    FStopped : Boolean;
    TimeFormat : TTimeFormat;
  public
    { public declarations }
  end;

var
  fMain: TfMain;

implementation

{ TfMain }

procedure TfMain.PlayClick(Sender: TObject);
begin
  if FPaused then
    begin
      AudioOut1.Resume;
      FPaused := False;
    end
  else
    begin
      if FileIn1.FileName = '' then
        begin
          if fPlaylist.lbPlaylist.Items.Count = 0 then exit;
          if fPlaylist.lbPlaylist.ItemIndex = -1 then
            fPlayList.lbPlaylist.ItemIndex := 0;
          FileIn1.FileName := fPlayList.lbPlaylist.Items[fPlayList.lbPlaylist.ItemIndex];
          lFilename.Caption := Format('File:%s',[ExtractFileName(FileIn1.FileName)]);
        end;
      AudioOut1.Run;
    end;
  FStopped := False;
  btPlay.Enabled := False;
  btStop.Enabled := True;
  btOpen.Enabled := False;
  btRew.Enabled := False;
  btFfw.Enabled := False;
  btPause.Enabled := True;
  PlayTimer.Enabled := True;
end;

procedure TfMain.AudioOut1Done(Sender: TComponent);
begin
  btPlay.Enabled := True;
  btStop.Enabled := False;
  btOpen.Enabled := True;
  btRew.Enabled := True;
  btFfw.Enabled := True;
  PlayTimer.Enabled := false;
  ResetDisplay;
  if FStopped then
    exit;
  if fPlaylist.lbPlaylist.Items.Count = 0 then exit;
  if fPlaylist.lbPlaylist.ItemIndex = -1 then
    fPlayList.lbPlaylist.ItemIndex := 0;
  FileIn1.FileName := fPlayList.lbPlaylist.Items[fPlayList.lbPlaylist.ItemIndex];
  if fPlayList.lbPlaylist.Items.Count-1 > fPlayList.lbPlaylist.ItemIndex then
    begin
      fPlayList.lbPlaylist.ItemIndex := fPlayList.lbPlaylist.ItemIndex+1;
      FileIn1.FileName := fPlayList.lbPlaylist.Items[fPlayList.lbPlaylist.ItemIndex];
      lFilename.Caption := Format('File:%s',[ExtractFileName(FileIn1.FileName)]);
      PlayClick(nil);
    end;
end;

procedure TfMain.AudioOut1ThreadException(Sender: TComponent; E: Exception);
begin
  ShowMessage(E.Message);
end;

procedure TfMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FStopped := True;
  if (AudioOut1.Status <> tosIdle) then
    AudioOut1.Stop;
  while (AudioOut1.Status <> tosIdle) and (AudioOut1.Status <> tosUndefined) do
    Application.Processmessages;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
//  AudioOut1.Driver := 'Alsa';
end;

procedure TfMain.Pauseclick(Sender: TObject);
begin
  if FPaused then
    exit;
  AudioOut1.Pause;
  FPaused := True;
  btPause.Enabled := False;
  btPlay.Enabled := True;
  PlayTimer.Enabled := False;
end;

procedure TfMain.StopClick(Sender: TObject);
begin
  FStopped := True;
  AudioOut1.Stop;
end;

procedure TfMain.OpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      FileIn1.FileName:=OpenDialog1.FileName;
      btPlay.Enabled := True;
      ResetDisplay;
    end;
end;

procedure TfMain.Timer1Timer(Sender: TObject);
var
  tmp : real;
begin
  if FileIn1.Size<=0 then exit;
  case TimeFormat of
  tfElapsed:
    begin
        tmp := ((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lTime.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
      tmp := FileIn1.TotalTime-((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lLeft.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
      lTime1.Caption := 'Time elapsed';
      lTime2.Caption := 'left';
    end;
  tfRemain:
    begin
      tmp := ((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lLeft.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
      tmp := FileIn1.TotalTime-((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lTime.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
      lTime1.Caption := 'Time remain';
      lTime2.Caption := 'elapsed';
    end;
  end;
  Progress.Position := round((FileIn1.Position * 100) / FileIn1.Size);
end;

procedure TfMain.btFfwClick(Sender: TObject);
begin
  if fPlayList.lbPlaylist.Items.Count-1 > fPlayList.lbPlaylist.ItemIndex then
    fPlayList.lbPlaylist.ItemIndex := fPlayList.lbPlaylist.ItemIndex+1;
  FileIn1.FileName := fPlayList.lbPlaylist.Items[fPlayList.lbPlaylist.ItemIndex];
  ResetDisplay;
end;

procedure TfMain.btPlaylistClick(Sender: TObject);
begin
  fPlaylist.Visible := True;
end;

procedure TfMain.btRewClick(Sender: TObject);
begin
  if fPlayList.lbPlaylist.ItemIndex >= 1 then
    fPlayList.lbPlaylist.ItemIndex := fPlayList.lbPlaylist.ItemIndex-1;
  FileIn1.FileName := fPlayList.lbPlaylist.Items[fPlayList.lbPlaylist.ItemIndex];
  ResetDisplay;
end;

procedure TfMain.btVizuClick(Sender: TObject);
begin
  fVizu.Show;
end;

procedure TfMain.lTime1Click(Sender: TObject);
begin
  case TimeFormat of
  tfElapsed:TimeFormat := tfRemain;
  tfRemain:TimeFormat := tfElapsed;
  end;
  ResetDisplay;
end;

procedure TfMain.resetDisplay;
var
  tmp : real;
begin
  lFilename.Caption := Format('File:%s',[ExtractFileName(FileIn1.FileName)]);
  case TimeFormat of
  tfElapsed:
    begin
      tmp := 0;
//      if FileIn1.Size > 0 then
//        tmp := ((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lTime.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
//      tmp := FileIn1.TotalTime-((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lLeft.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
      lTime1.Caption := 'Time elapsed';
      lTime2.Caption := 'left';
    end;
  tfRemain:
    begin
//      if FileIn1.Size > 0 then
//        tmp := ((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lLeft.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
//      tmp := FileIn1.TotalTime-((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lTime.Caption := Format('%.2d:%.2d:%.2d',[round((tmp-30) / 60) mod 120,round(tmp) mod 60,round(tmp*100) mod 100]);
      lTime1.Caption := 'Time remain';
      lTime2.Caption := 'elapsed';
    end;
  end;
//  Progress.Position := round((FileIn1.Position * 100) / FileIn1.Size);
end;

initialization
{$IFDEF FPC}
  {$I umain.lrs}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

end.

