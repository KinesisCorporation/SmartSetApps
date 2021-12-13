unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ACS_Audio, ComCtrls, StdCtrls, ACS_Misc,
  ACS_VolumeQuery, ExtCtrls;

type

  { TfMain }

  TfMain = class(TForm)
    AudioIn1: TACSAudioIn;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    NULLOut1: TACSNULLOut;
    ProgressBar: TProgressBar;
    Timer1: TTimer;
    VolumeQuery: TACSVolumeQuery;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fMain: TfMain;

implementation

{ TfMain }

procedure TfMain.FormShow(Sender: TObject);
begin
end;

procedure TfMain.Button1Click(Sender: TObject);
begin
  NULLOut1.Run;
  Button1.Caption:='Recording...';
end;

procedure TfMain.Timer1Timer(Sender: TObject);
begin
  ProgressBar.Position := (round((VolumeQuery.dbLeft+VolumeQuery.dbRight)/2));
  Label4.Caption:=IntToStr(round((VolumeQuery.dbLeft+VolumeQuery.dbRight)/2));
  if not NULLOut1.Active then Button1.Caption:='Start';
end;

initialization
  {$I umain.lrs}

end.

