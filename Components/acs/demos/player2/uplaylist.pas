unit uPlaylist;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
  LResources,
  {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TfPlaylist }

  TfPlaylist = class(TForm)
    btAdd: TBitBtn;
    Button1: TButton;
    lbPlaylist: TListBox;
    OpenDialog: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure btAddClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fPlaylist: TfPlaylist;

implementation

uses ACS_File;

{ TfPlaylist }

procedure TfPlaylist.btAddClick(Sender: TObject);
var
  desc: string;
begin
  desc:='';
  FileFormats.BuildFilterStrings(desc,[fcLoad]);
  OpenDialog.Filter := desc;
  if OpenDialog.Execute then
  begin
    lbPlayList.Items.AddStrings(OpenDialog.Files);
  end;
end;

procedure TfPlaylist.Button1Click(Sender: TObject);
begin
  if lbPlayList.ItemIndex > -1 then
    lbPlayList.Items.Delete(lbPlayList.ItemIndex);
end;

initialization
{$IFDEF FPC}
  {$I uplaylist.lrs}
{$else}
  {$R *.dfm}
{$ENDIF}

end.

