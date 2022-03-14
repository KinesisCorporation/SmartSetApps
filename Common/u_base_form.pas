unit u_base_form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LineObj, BGRABitmap, BGRABitmapTypes, ColorSpeedButtonCS;

type

  { TBaseForm }

  TBaseForm = class(TForm)
    btnClose: TColorSpeedButtonCS;
    btnCloseLight: TColorSpeedButtonCS;
    lblTitle: TLabel;
    lineBorderBottom: TLineObj;
    lineBorderLeft: TLineObj;
    lineBorderLeft1: TLineObj;
    lineBorderRight: TLineObj;
    lineBorderRight1: TLineObj;
    lineBorderTop: TLineObj;
    pnlTop: TPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  BaseForm: TBaseForm;

implementation

uses u_const;

{$R *.lfm}

{ TBaseForm }

procedure TBaseForm.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TBaseForm.FormCreate(Sender: TObject);
begin
  btnClose.Top := 0;
  btnClose.Left := self.Width - btnClose.Width;
  if (GMasterAppId = APPL_MASTER_OFFICE) and not(IsDarkTheme) then
  begin
    btnClose.Visible := false;
    btnCloseLight.Visible := true;
  end;
end;

procedure TBaseForm.FormResize(Sender: TObject);
begin
  lblTitle.Width := self.Width - (btnClose.Width * 2);
  lblTitle.Left := btnClose.Width;
end;

procedure TBaseForm.FormShow(Sender: TObject);
begin
  btnCloseLight.StateNormal.Color := self.Color;
  btnCloseLight.StateActive.Color := self.Color;
  btnCloseLight.StateDisabled.Color := self.Color;
  btnCloseLight.StateHover.Color := self.Color;
  btnCloseLight.Left := btnClose.Left;
  btnCloseLight.Top := btnClose.Top;
end;


end.

