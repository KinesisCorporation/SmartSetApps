unit u_form_alt_layout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorSpeedButtonCS, u_base_form, LCLIntf, u_const, LCLType,
  u_common_ui, UserDialog;

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
    function Validate: boolean;
  public
  end;

var
  FormAltLayout: TFormAltLayout;
  function ShowAltLayoutDialog(messageText: string; var selLayers: TStringList; backColor: TColor; fontColor: TColor): boolean;

implementation

function ShowAltLayoutDialog(messageText: string; var selLayers: TStringList; backColor: TColor; fontColor: TColor): boolean;
begin
  result := false;
  if FormAltLayout <> nil then
    FreeAndNil(FormAltLayout);

  //Creates the dialog form
  Application.CreateForm(TFormAltLayout, FormAltLayout);
  FormAltLayout.lblMessage.Caption := messageText;
  //FormAltLayout.SetLayer(curLayerIdx);

  //Loads colors
  FormAltLayout.Color := backColor;
  FormAltLayout.Font.Color := fontColor;
  FormAltLayout.lblTitle.Font.Color := fontColor;
  FormAltLayout.lblMessage.Font.Color := fontColor;
  FormAltLayout.lblLayerSelect.Font.Color := fontColor;
  if (GMasterAppId = APPL_MASTER_OFFICE) then
  begin
    LoadButtonImage(FormAltLayout.btnCancel, FormAltLayout.imgList, 4);
    LoadButtonImage(FormAltLayout.btnAccept, FormAltLayout.imgList, 6);
  end;

  if FormAltLayout.ShowModal = mrOK then
  begin
    if (FormAltLayout.btnBaseLayer.Down) then
      selLayers.Add(IntToStr(LAYER_BASE_360));
    if (FormAltLayout.btnKpLayer.Down) then
      selLayers.Add(IntToStr(LAYER_KEYPAD_360));
    if (FormAltLayout.btnFn1Layer.Down) then
      selLayers.Add(IntToStr(LAYER_FN1_360));
    if (FormAltLayout.btnFn2Layer.Down) then
      selLayers.Add(IntToStr(LAYER_FN2_360));
    if (FormAltLayout.btnFn3Layer.Down) then
      selLayers.Add(IntToStr(LAYER_FN3_360));
    result := true;
    //curLayerIdx := FormAltLayout.layerIdx;
  end;
end;

{$R *.lfm}

{ TFormAltLayout }

procedure TFormAltLayout.FormCreate(Sender: TObject);
begin
  inherited;
  //layerIdx := -1;
  //selLayers := TStringList.Create;
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
  //layerIdx := curLayerIdx;
  //if (curLayerIdx = LAYER_BASE_360) then
  //  btnBaseLayer.Down := true
  //else if (curLayerIdx = LAYER_KEYPAD_360) then
  //  btnKpLayer.Down := true
  //else if (curLayerIdx = LAYER_FN1_360) then
  //  btnFn1Layer.Down := true
  //else if (curLayerIdx = LAYER_FN2_360) then
  //  btnFn2Layer.Down := true
  //else if (curLayerIdx = LAYER_FN3_360) then
  //  btnFn3Layer.Down := true;
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

function TFormAltLayout.Validate: boolean;
var
  countDown: integer;
begin
  result := false;
  countDown := 0;
  if (btnBaseLayer.Down) then
    inc(countDown);
  if (btnKpLayer.Down) then
    inc(countDown);
  if (btnFn1Layer.Down) then
    inc(countDown);
  if (btnFn2Layer.Down) then
    inc(countDown);
  if (btnFn3Layer.Down) then
    inc(countDown);

  if (countDown = 0) then
    ShowDialog('Alternate Layouts', 'You must select at least one layer', mtError, [mbOK], DEFAULT_DIAG_HEIGHT_RGB)
  else
    result := true;
end;

procedure TFormAltLayout.btnAcceptClick(Sender: TObject);
begin
  if (Validate) then
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
  //if (btnBaseLayer.Down) then
  //  layerIdx := LAYER_BASE_360
  //else if (btnKpLayer.Down) then
  //  layerIdx := LAYER_KEYPAD_360
  //else if (btnFn1Layer.Down) then
  //  layerIdx := LAYER_FN1_360
  //else if (btnFn2Layer.Down) then
  //  layerIdx := LAYER_FN2_360
  //else if (btnFn3Layer.Down) then
  //  layerIdx := LAYER_FN3_360;
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

