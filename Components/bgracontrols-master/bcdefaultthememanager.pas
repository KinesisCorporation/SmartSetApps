{******************************* CONTRIBUTOR(S) ******************************
- Edivando S. Santos Brasil | mailedivando@gmail.com
  (Compatibility with delphi VCL 11/2018)

***************************** END CONTRIBUTOR(S) *****************************}
unit BCDefaultThemeManager;

{$I bgracontrols.inc}

interface

uses
  Classes, SysUtils, {$IFDEF FPC}LResources, CustomDrawnDrawers,{$ENDIF}
  Forms, Controls, Graphics, Dialogs,
  {$IFNDEF FPC}BGRAGraphics, GraphType, FPImage, {$ENDIF}
  BCButton, BCButtonFocus, BCNumericKeyboard, BCThemeManager,
  BCSamples, {$IFDEF FPC}BGRACustomDrawn,{$ENDIF} BCKeyboard;

type

  { TBCDefaultThemeManager }

  TBCDefaultThemeManager = class(TBCThemeManager)
  private
    FBCStyle: TBCSampleStyle;
    FButton: TBCButton;
    FButtonFocus: TBCButtonFocus;
    FCDStyle: TCDDrawStyle;
    procedure SetFBCStyle(AValue: TBCSampleStyle);
    procedure SetFButton(AValue: TBCButton);
    procedure SetFButtonFocus(AValue: TBCButtonFocus);
    procedure SetFCDStyle(AValue: TCDDrawStyle);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure Apply(AControl: TWinControl); override;
    procedure Apply(); override;
  published
    property Button: TBCButton read FButton write SetFButton;
    property ButtonFocus: TBCButtonFocus read FButtonFocus write SetFButtonFocus;
    property BCStyle: TBCSampleStyle read FBCStyle write SetFBCStyle;
    property CDStyle: TCDDrawStyle read FCDStyle write SetFCDStyle;
  end;

{$IFDEF FPC}procedure Register;{$ENDIF}

implementation

{$IFDEF FPC}procedure Register;
begin
  RegisterComponents('BGRA Controls', [TBCDefaultThemeManager]);
end;
{$ENDIF}

{ TBCDefaultThemeManager }

procedure TBCDefaultThemeManager.SetFButton(AValue: TBCButton);
begin
  if FButton = AValue then
    Exit;
  FButton := AValue;
end;

procedure TBCDefaultThemeManager.SetFBCStyle(AValue: TBCSampleStyle);
begin
  if FBCStyle = AValue then
    Exit;
  FBCStyle := AValue;
end;

procedure TBCDefaultThemeManager.SetFButtonFocus(AValue: TBCButtonFocus);
begin
  if FButtonFocus = AValue then
    Exit;
  FButtonFocus := AValue;
end;

procedure TBCDefaultThemeManager.SetFCDStyle(AValue: TCDDrawStyle);
begin
  if FCDStyle = AValue then
    Exit;
  FCDStyle := AValue;
end;

constructor TBCDefaultThemeManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBCStyle := ssDefault;
  FCDStyle := dsDefault;
end;

destructor TBCDefaultThemeManager.Destroy;
begin
  inherited Destroy;
end;

procedure TBCDefaultThemeManager.Apply(AControl: TWinControl);
var
  i: integer;
  removeTempButton: boolean;
  removeTempButtonFocus: boolean;
  tempButton: TBCButton;
  tempButtonFocus: TBCButtonFocus;
begin
  removeTempButton := False;
  removeTempButtonFocus := False;

  if (Assigned(FButton)) and (FBCStyle = ssDefault) then
    tempButton := FButton
  else
  begin
    tempButton := TBCButton.Create(Self);
    tempButton.Name := 'BCDefaultThemeManager_tempButton';
    removeTempButton := True;
    StyleButtonsSample(tempButton, FBCStyle);
  end;

  if (Assigned(FButton)) and (FBCStyle = ssDefault) then
    tempButtonFocus := FButtonFocus
  else
  begin
    tempButtonFocus := TBCButtonFocus.Create(Self);
    tempButtonFocus.Name := 'BCDefaultThemeManager_tempButtonFocus';
    removeTempButtonFocus := True;
    StyleButtonsFocusSample(tempButtonFocus, FBCStyle);
  end;

  { Controls }
  for i := 0 to AControl.ControlCount - 1 do
  begin
    { BCButton }
    if (AControl.Controls[i] is TBCButton) then
      with TBCButton(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButton.Name <> AControl.Controls[i].Name) then
        begin
          Assign(tempButton);
        end;
    { BCButtonFocus }
    if (AControl.Controls[i] is TBCButtonFocus) then
      with TBCButtonFocus(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) then
        begin
          Assign(tempButtonFocus);
        end;
    { Custom Drawn }
    if (AControl.Controls[i] is TBCDButton) then
      with TBCDButton(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
    if (AControl.Controls[i] is TBCDEdit) then
      with TBCDEdit(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
    if (AControl.Controls[i] is TBCDStaticText) then
      with TBCDStaticText(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
    if (AControl.Controls[i] is TBCDProgressBar) then
      with TBCDProgressBar(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
    if (AControl.Controls[i] is TBCDSpinEdit) then
      with TBCDSpinEdit(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
    if (AControl.Controls[i] is TBCDCheckBox) then
      with TBCDCheckBox(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
    if (AControl.Controls[i] is TBCDRadioButton) then
      with TBCDRadioButton(AControl.Controls[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButtonFocus.Name <> AControl.Controls[i].Name) then
        begin
          DrawStyle := CDStyle;
        end;
  end;
  { Components }
  for i := 0 to AControl.ComponentCount - 1 do
  begin
    { BCNumericKeyboard }
    if (AControl.Components[i] is TBCNumericKeyboard) then
      with TBCNumericKeyboard(AControl.Components[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButton.Name <> TBCNumericKeyboard(AControl.Components[i]).ButtonStyle.Name) then
        begin
          ButtonStyle.Assign(tempButton);
          UpdateButtonStyle;
        end;
    { BCRealNumericKeyboard }
    if (AControl.Components[i] is TBCRealNumericKeyboard) then
      with TBCRealNumericKeyboard(AControl.Components[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButton.Name <> TBCRealNumericKeyboard(AControl.Components[i]).ButtonStyle.Name) then
        begin
          ButtonStyle.Assign(tempButton);
          UpdateButtonStyle;
        end;
    { BCKeyboard }
    if (AControl.Components[i] is TBCKeyboard) then
      with TBCKeyboard(AControl.Components[i]) do
        if (Assigned(ThemeManager)) and
          (TBCDefaultThemeManager(ThemeManager).Name = Self.Name) and
          (tempButton.Name <> TBCKeyboard(AControl.Components[i]).ButtonStyle.Name) then
        begin
          ButtonStyle.Assign(tempButton);
          UpdateButtonStyle;
        end;
  end;

  if removeTempButton then
    tempButton.Free;

  if removeTempButtonFocus then
    tempButtonFocus.Free;
end;

procedure TBCDefaultThemeManager.Apply;
begin
  if Self.Owner is TWinControl then
    Apply(Self.Owner as TWinControl)
  else
    raise Exception.Create('The parent is not TWinControl descendant.');
end;

end.
