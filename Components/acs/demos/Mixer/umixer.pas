unit uMixer; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls,GraphType, ACS_Mixer, ACS_Converters;

type

  { TfMixer }

  TfMixer = class(TForm)
    cbDevice: TComboBox;
    lDevice: TLabel;
    Label3: TLabel;
    Mixer: TACSMixer;
    Timer: TTimer;
    TopPanel: TPanel;
    procedure MuteChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ChannelChange(Sender: TObject);
    procedure BalanceChange(Sender: TObject);
    procedure cbDeviceChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Channels : array of TTrackBar;
    Balance : array of TTrackBar;
    Muting : array of TCheckBox;
  end; 

var
  fMixer: TfMixer;

implementation

{ TfMixer }

procedure TfMixer.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  cbDevice.Items.Clear;
  for i := 0 to Mixer.DevCount-1 do
    begin
      Mixer.DevNum := i;
      cbDevice.Items.Add(Mixer.MixerName);
    end;
  cbDevice.ItemIndex := 0;
end;

procedure TfMixer.MuteChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to length(Muting)-1 do
    if Sender = Muting[i] then
      begin
        Mixer.Mute[i] := TCheckBox(Sender).Checked;
      end;
end;

procedure TfMixer.FormHide(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure TfMixer.FormShow(Sender: TObject);
begin
  cbDeviceChange(nil);
end;

procedure TfMixer.TimerTimer(Sender: TObject);
var
  i : Integer;
begin
{  for i := 0 to length(Channels)-1 do
    begin
       if Mixer.IsStereo(i) then
         Channels[i].Position := 255-Mixer.Level[i].Left
       else
         Channels[i].Position := 255-Mixer.Level[i].Main;
    end;}
end;

procedure TfMixer.ChannelChange(Sender: TObject);
var
  i,tmp : Integer;
  outp : TACSMixerLevel;
begin
  for i := 0 to length(Channels)-1 do
    if Sender = Channels[i] then
      begin
        if Mixer.IsStereo(i) then
          begin
            tmp := -Balance[i].Position;
            if tmp < 0 then tmp := 0;
            tmp := round(((tmp*255)/255)+(255-Channels[i].Position));
            if tmp > 255 then
              tmp := 255;
            Outp.Left := tmp;
            tmp := Balance[i].Position;
            if tmp < 0 then tmp := 0;
            tmp := round(((tmp*255)/255)+(255-Channels[i].Position));
            if tmp > 255 then
              tmp := 255;
            Outp.Right := tmp;
          end
        else
          Outp.Main := Channels[i].Position-255;
        Mixer.Level[i] := Outp;
      end;
end;

procedure TfMixer.BalanceChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to length(Channels)-1 do
    begin
       if Mixer.IsStereo(i) then
         Channels[i].Position := 255-Mixer.Level[i].Left
       else
         Channels[i].Position := 255-Mixer.Level[i].Main;
    end;
end;

procedure TfMixer.cbDeviceChange(Sender: TObject);
var
  i : Integer;
  aComp : TControl;
  newPanel : TPanel;
  newTrackbar : TTrackbar;
  newBevel : TBevel;
  newCheckbox : TCheckbox;
  newLabel : TLabel;
begin
  setlength(Channels,0);
  setlength(Balance,0);
  setlength(Muting,0);
  while fMixer.ControlCount > 1 do
    begin
      aComp := fMixer.Controls[1];
      fMixer.RemoveControl(aComp);
      aComp.Free;
    end;
  Mixer.DevNum:=cbDevice.ItemIndex;
  for i := 0 to Mixer.ChannelCount-1 do
   begin
     newPanel := TPanel.Create(nil);
     newPanel.Parent := fMixer;
     newPanel.Align := alLeft;
     newPanel.Width := 80;
     newPanel.BevelOuter := bvNone;
     newLabel := TLabel.Create(nil);
     newLabel.Parent := newPanel;
     newLabel.Align := alTop;
     newLabel.Alignment := taCenter;
     newLabel.Caption := Mixer.ChannelName[i];
     newLabel.Height := 30;
     newBevel := TBevel.Create(nil);
     newBevel.Parent := newPanel;
     newBevel.Shape := bsLeftLine;
     newBevel.Width := 1;
     newBevel.Align := alRight;
     newTrackbar := TTrackbar.Create(nil);
     newTrackbar.Parent := NewPanel;
     newTrackbar.Align := alClient;
     newTrackBar.Orientation := trVertical;
     newTrackbar.Max := 255;
     newTrackbar.Min := 0;
     setlength(Channels,i+1);
     Channels[i] := newTrackBar;
     newTrackBar.OnChange := @ChannelChange;
     setlength(Balance,i+1);
     Balance[i] := nil;
     if Mixer.IsStereo(i) then
       begin
         newTrackbar := TTrackbar.Create(nil);
         newTrackbar.Parent := NewPanel;
         newTrackbar.Align := alTop;
         newTrackBar.Orientation := trHorizontal;
         newTrackBar.Height := 15;
         newTrackbar.Max := 100;
         newTrackbar.Min := -100;
         newTrackBar.Position := 0;
         Balance[i] := newTrackBar;
         Balance[i].Max := 40;
         Channels[i].Position := 255-Mixer.Level[i].Left;
       end
     else
       Channels[i].Position := 255-Mixer.Level[i].Main;
     newCheckBox := TCheckBox.Create(nil);
     newCheckBox.Parent := newPanel;
     newCheckBox.Caption := 'Mute';
     newCheckBox.Align := alBottom;
     newCheckBox.Checked := Mixer.Mute[i];
     newCheckBox.OnChange := @MuteChange;
     setlength(Muting,i+1);
     Muting[i] := newCheckBox;
   end;
  Timer.Enabled := True;
  Width := Mixer.ChannelCount*80;
end;

initialization
  {$I umixer.lrs}

end.

