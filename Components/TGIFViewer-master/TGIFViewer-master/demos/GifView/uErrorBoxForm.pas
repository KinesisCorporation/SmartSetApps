unit uErrorBoxForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TErrorBoxForm }

  TErrorBoxForm = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  ErrorBoxForm: TErrorBoxForm;

implementation

{$R *.lfm}

{ TErrorBoxForm }

procedure TErrorBoxForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

