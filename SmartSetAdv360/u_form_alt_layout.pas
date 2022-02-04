unit u_form_alt_layout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, LineObj, u_base_form, LCLIntf, u_const, LCLType,
  u_form_firmware, u_common_ui;

type

  { TFormAltLayout }

  TFormAltLayout = class(TBaseForm)
    btnAccept: TColorSpeedButtonCS;
    btnBaseLayer: TColorSpeedButtonCS;
    btnCancel: TColorSpeedButtonCS;
    btnFn1Layer: TColorSpeedButtonCS;
    btnFn2Layer: TColorSpeedButtonCS;
    btnFn3Layer: TColorSpeedButtonCS;
    btnKpLayer: TColorSpeedButtonCS;
    imgList: TImageList;
    lblLayerSelect: TLabel;
    lblMessage: TLabel;
    pnlLayerSelect: TPanel;
    procedure btnAcceptClick(Sender: TObject);
    procedure btnAcceptMouseLeave(Sender: TObject);
    procedure btnAcceptMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnLayerClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCancelMouseLeave(Sender: TObject);
    procedure btnCancelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure SetLayer(curLayerIdx: integer);
  public
    layerIdx: integer;
  end;

var
  FormAltLayout: TFormAltLayout;
  function ShowAltLayoutDialog(messageText: string; var curLayerIdx: integer; backColor: TColor; fontColor: TColor): boolean;

implementation

function ShowAltLayoutDialog(messageText: string; var curLayerIdx: integer; backColor: TColor; fontColor: TColor): boolean;
begin
  result := false;
  if FormAltLayout <> nil then
    FreeAndNil(FormAltLayout);

  //Creates the dialog form
  Application.CreateForm(TFormAltLayout, FormAltLayout);
  FormAltLayout.lblMessage.Caption := messageText;
  FormAltLayout.SetLayer(curLayerIdx);

  //Loads colors
  FormAltLayout.Color := backColor;
  FormAltLayout.Font.Color := fontColor;
  FormAltLayout.lblTitle.Font.Color := fontColor;
  FormAltLayout.lblMessage.Font.Color := fontColor;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormAltLayout.btnCancel, FormAltLayout.imgList, 4);
    LoadButtonImage(FormAltLayout.btnAccept, FormAltLayout.imgList, 6);
  end;

  if FormAltLayout.ShowModal = mrOK then
  begin
    result := true;
    curLayerIdx := FormAltLayout.layerIdx;
  end;
end;

{$R *.lfm}

{ TFormAltLayout }

procedure TFormAltLayout.FormCreate(Sender: TObject);
begin
  inherited;
  layerIdx := -1;
end;

procedure TFormAltLayout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_ESCAPE) then
  begin
    self.ModalResult := mrCancel;
  end;
end;

procedure TFormAltLayout.SetLayer(curLayerIdx: integer);
begin
  layerIdx := curLayerIdx;
  if (curLayerIdx = LAYER_BASE_360) then
    btnBaseLayer.Down := true
  else if (curLayerIdx = LAYER_KEYPAD_360) then
    btnKpLayer.Down := true
  else if (curLayerIdx = LAYER_FN1_360) then
    btnFn1Layer.Down := true
  else if (curLayerIdx = LAYER_FN2_360) then
    btnFn2Layer.Down := true
  else if (curLayerIdx = LAYER_FN3_360) then
    btnFn3Layer.Down := true;
end;

procedure TFormAltLayout.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormAltLayout.btnCancelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 5)
  else
    LoadButtonImage(sender, imgList, 1);
end;

procedure TFormAltLayout.btnCancelMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgList, 4)
    else
      LoadButtonImage(sender, imgList, 0);
  end;
end;

procedure TFormAltLayout.btnAcceptMouseLeave(Sender: TObject);
begin
  if (not (sender as TColorSpeedButtonCS).Down) then
  begin
    if (GMasterAppId = APPL_MASTER_OFFICE) then
      LoadButtonImage(sender, imgList, 6)
    else
      LoadButtonImage(sender, imgList, 2);
  end;
end;

procedure TFormAltLayout.btnAcceptClick(Sender: TObject);
begin
  ModalResult := mrOK;

  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 6)
  else
    LoadButtonImage(sender, imgList, 2);
end;

procedure TFormAltLayout.btnAcceptMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 7)
  else
    LoadButtonImage(sender, imgList, 3);
end;

procedure TFormAltLayout.btnLayerClick(Sender: TObject);
begin
  if (btnBaseLayer.Down) then
    layerIdx := LAYER_BASE_360
  else if (btnKpLayer.Down) then
    layerIdx := LAYER_KEYPAD_360
  else if (btnFn1Layer.Down) then
    layerIdx := LAYER_FN1_360
  else if (btnFn2Layer.Down) then
    layerIdx := LAYER_FN2_360
  else if (btnFn3Layer.Down) then
    layerIdx := LAYER_FN3_360;
end;

procedure TFormAltLayout.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
    LoadButtonImage(sender, imgList, 4)
  else
    LoadButtonImage(sender, imgList, 0);
end;

end.

