unit u_form_loading;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormLoading }

  TFormLoading = class(TForm)
    lblMessage: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private

  public

  end;

var
  FormLoading: TFormLoading;
  procedure ShowLoading(title: string; message: string; backColor: TColor; fontColor: TColor);
  procedure CloseLoading;

implementation

{$R *.lfm}

procedure ShowLoading(title: string; message: string; backColor: TColor; fontColor: TColor);
begin
  if FormLoading <> nil then
    FreeAndNil(FormLoading);

  //Creates the dialog form
  Application.CreateForm(TFormLoading, FormLoading);
  FormLoading.Caption := title;
  FormLoading.lblMessage.Caption := message;

  FormLoading.Color := backColor;
  FormLoading.Font.Color := fontColor;
  FormLoading.lblMessage.Font.Color := fontColor;

  FormLoading.Show;
  FormLoading.Refresh;
end;

procedure CloseLoading;
begin
  if (FormLoading <> nil) then
  begin
    FormLoading.Close;
    FreeAndNil(FormLoading);
  end;
end;

{ TFormLoading }

procedure TFormLoading.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction := caFree;
end;

end.

