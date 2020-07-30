unit u_base_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, HSSpeedButton, LineObj, BGRABitmap, BGRABitmapTypes;

type

  { TBaseForm }

  TBaseForm = class(TForm)
    btnClose: THSSpeedButton;
    lblTitle: TLabel;
    lineBorderBottom: TLineObj;
    lineBorderLeft: TLineObj;
    lineBorderRight: TLineObj;
    lineBorderTop: TLineObj;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  BaseForm: TBaseForm;

implementation

{$R *.lfm}

{ TBaseForm }

procedure TBaseForm.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TBaseForm.FormCreate(Sender: TObject);
begin

end;

procedure TBaseForm.FormResize(Sender: TObject);
begin
  lblTitle.Width := self.Width - (btnClose.Width * 2);
  lblTitle.Left := btnClose.Width;
end;


end.

