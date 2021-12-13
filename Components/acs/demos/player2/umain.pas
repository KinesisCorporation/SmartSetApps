unit uMain;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  LResources, dbugintf,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons,
  ACS_Audio, ACS_File, ACS_Classes, ACS_Allformats, ExtCtrls, StdCtrls,
  ComCtrls, uPlaylist, ACS_Indicator, uvis
  //You must include Output drivers to not get an "No drier selected" exception
  {$IFDEF WINDOWS}
  //,ACS_DXAudio  //DirectSound Driver
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
    SoundIndicator: TACSSoundIndicator;
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
    Panel1: TPanel;
    Progress: TProgressBar;
    PlayTimer: TTimer;
    lTime1: TLabel;
    lTime2: TLabel;
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
    procedure UpdateButtons();
  end;

var
  fMain: TfMain;

implementation

{ TfMain }

procedure TfMain.PlayClick(Sender: TObject);
begin
  if FPaused then
  begin
    AudioOut1.Resume();
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
      lFilename.Caption := Format('File: %s',[ExtractFileName(FileIn1.FileName)]);
    end;
    AudioOut1.BufferSize:=$100000;
    if FileIn1.Valid then AudioOut1.Run();
  end;
  FStopped := False;
  PlayTimer.Enabled := not FStopped;
  UpdateButtons();
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
  SendDebug(E.Message);
  //ShowMessage(E.Message);
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
  if FPaused then Exit;
  AudioOut1.Pause();
  FPaused := True;
  btPause.Enabled := False;
  btPlay.Enabled := True;
  PlayTimer.Enabled := False;
  UpdateButtons();
end;

procedure TfMain.StopClick(Sender: TObject);
begin
  FStopped := True;
  PlayTimer.Enabled := not FStopped;
  AudioOut1.Stop();
  UpdateButtons();
end;

procedure TfMain.OpenClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Self);
  try
    OpenDialog.Filter := FileIn1.GetFileOpenFilterString();
    if not OpenDialog.Execute() then
      Exit;
    FileIn1.FileName := OpenDialog.FileName;
  finally
    FreeAndNil(OpenDialog);
  end;

  if FileIn1.Valid then
  begin
    lFilename.Caption := Format('File: %s', [ExtractFileName(FileIn1.FileName)]);
    btPlay.Enabled := True;
    Timer1Timer(Self);
  end
  else
    ResetDisplay();
end;

procedure TfMain.Timer1Timer(Sender: TObject);
var
  tmp : Real;
begin
  if FileIn1.Size = 0 then
  begin
    lTime.Caption := '00:00:00';
    lLeft.Caption := '00:00:00';
    Exit;
  end;

  case TimeFormat of
  tfElapsed:
    begin
      // Current position
      tmp := FileIn1.PositionTime;
      lTime.Caption := Format('%.2d:%.2d:%.2d', [round((tmp-30) / 60) mod 120, round(tmp) mod 60, round(tmp*100) mod 100]);
      // Time left
      tmp := FileIn1.TotalTime - FileIn1.PositionTime;
      lLeft.Caption := Format('%.2d:%.2d:%.2d', [round((tmp-30) / 60) mod 120, round(tmp) mod 60, round(tmp*100) mod 100]);
      lTime1.Caption := 'Time elapsed';
      lTime2.Caption := 'left';
    end;
  tfRemain:
    begin
      tmp := ((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lLeft.Caption := Format('%.2d:%.2d:%.2d', [round((tmp-30) / 60) mod 120, round(tmp) mod 60, round(tmp*100) mod 100]);
      tmp := FileIn1.TotalTime-((FileIn1.Position * FileIn1.TotalTime) / FileIn1.Size);
      lTime.Caption := Format('%.2d:%.2d:%.2d', [round((tmp-30) / 60) mod 120, round(tmp) mod 60, round(tmp*100) mod 100]);
      lTime1.Caption := 'Time remain';
      lTime2.Caption := 'elapsed';
    end;
  end;
  //Progress.Position := Round((FileIn1.Position * 100) / FileIn1.Size);
  Progress.Position := Round(FileIn1.Progress);
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
begin
  lFilename.Caption := Format('File: %s', [ExtractFileName(FileIn1.FileName)]);
  lTime.Caption := '00:00:00';
  lLeft.Caption := '00:00:00';
  case TimeFormat of
  tfElapsed:
    begin
      lTime1.Caption := 'Time elapsed';
      lTime2.Caption := 'left';
    end;
  tfRemain:
    begin
      lTime1.Caption := 'Time remain';
      lTime2.Caption := 'elapsed';
    end;
  end;
//  Progress.Position := round((FileIn1.Position * 100) / FileIn1.Size);
end;

procedure TfMain.UpdateButtons;
begin
  btPlay.Enabled := FStopped or FPaused;
  btStop.Enabled := not FStopped;
  btOpen.Enabled := FStopped;
  btRew.Enabled := FStopped;
  btFfw.Enabled := FStopped;
  btPause.Enabled := (not FStopped) and (not FPaused);
end;

initialization
{$IFDEF FPC}
  {$I umain.lrs}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

end.

