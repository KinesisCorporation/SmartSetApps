unit u_form_about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, VersionSupport, lclintf, u_const, u_const_pedal;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    bOk: TBitBtn;
    lblTitle: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblFirmware: TLabel;
    lblWebsite: TLabel;
    lblVersion: TLabel;
    lblVersion1: TLabel;
    lblVersion2: TLabel;
    procedure bOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lblWebsiteClick(Sender: TObject);
  private
    { private declarations }
    function FindFirstNumberPos(value: string): integer;
  public
    { public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.lfm}

{ TFormAbout }

procedure TFormAbout.bOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAbout.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if CloseAction = caFree then
  begin
    FormAbout := nil;
  end;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
var
  fileVersion: TStringList;
  firmwareFound: boolean;
begin
  SetFont(self, 'Helvetica');
  lblTitle.Caption := GApplicationName;
  lblVersion.Caption := 'Version : ' + GetFileVersion;

  //Loads firmware information from version.txt file
  //Line one is formatted like this: "Firmware version is 1.0.44"
  //Line two has firware date
  firmwareFound := false;
  if FileExists(GVersionFile) then
  begin
    fileVersion := TStringList.Create;
    try
      fileVersion.LoadFromFile(GVersionFile);
      if fileVersion.Count > 1 then
      begin
        lblFirmware.Caption := 'Pedal – Firmware version : ' + Copy(fileVersion.Strings[1], FindFirstNumberPos(fileVersion.Strings[1]), Length(fileVersion.Strings[1]));
        firmwareFound := true;
      end;
      //if fileVersion.Count > 1 then
      //  lblFirmware.Caption := lblFirmware.Caption + ' - ' + fileVersion.Strings[1];
    finally
      FreeAndNil(fileVersion);
    end;
  end;

  if not firmwareFound then
    lblFirmware.Caption := 'Pedal – Firmware version : not found';
end;

procedure TFormAbout.lblWebsiteClick(Sender: TObject);
begin
  if Copy(lblWebsite.Caption, 1, 4) <> 'http' then //Add HTTP for MacOS
     OpenUrl('http://' + lblWebsite.Caption)
  else
      OpenUrl(lblWebsite.Caption);
end;

function TFormAbout.FindFirstNumberPos(value: string): integer;
var
  i: integer;
  tempInt, Code: integer;
begin
  result := 0;
  for i := 0 to Length(value) do
  begin
    val(value[i], tempInt, Code);
    if Code = 0 then
    begin
      result := i;
      Code := tempInt; //to remove Hint
      break;
    end;
  end;
end;

end.

