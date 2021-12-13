unit acs_properties;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, acs_audio
{$IFNDEF FPC}
  , DesignIntf, DesignEditors
{$ELSE}
  , PropEdits
{$ENDIF}
;

type
  { TAcsStringProperty }
  { Basic methods of the property editor }
  TAcsStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual; abstract;
    { Create strings by GetValueList and call Proc for every string }
    procedure GetValues(Proc: TGetStrProc); override;
    { Component that has this property }
    function GetComponent: TPersistent; virtual;
  end;

  { TAcsAudioInDriverNamePropertyEditor }
  { Property editor for TAcsAudioIn.DriverName property }
  TAcsAudioInDriverNamePropertyEditor = class(TAcsStringProperty)
  public
    { Selected string value }
    function GetValue: string; override;
    { Set new selected string from Value }
    procedure SetValue(const Value: string); override;
    { Fill list by drivers names }
    procedure GetValueList(List: TStrings); override;
  end;

  { TAcsAudioOutDriverNamePropertyEditor }
  { Property editor for TAcsAudioIn.DriverName property }
  TAcsAudioOutDriverNamePropertyEditor = class(TAcsStringProperty)
  public
    { Selected string value }
    function GetValue: string; override;
    { Set new selected string from Value }
    procedure SetValue(const Value: string); override;
    { Fill list by drivers names }
    procedure GetValueList(List: TStrings); override;
  end;


implementation

{ TAcsAudioOutDriverNamePropertyEditor }

function TAcsAudioOutDriverNamePropertyEditor.GetValue: string;
begin
  Result:=GetStrValue;
end;

procedure TAcsAudioOutDriverNamePropertyEditor.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

procedure TAcsAudioOutDriverNamePropertyEditor.GetValueList(List: TStrings);
var
  i: Integer;
begin
  for i:=0 to Length(OutDriverInfos)-1 do
  begin
    List.Append(OutDriverInfos[i].DriverName);
  end;
end;

{ TAcsAudioInDriverNamePropertyEditor }

function TAcsAudioInDriverNamePropertyEditor.GetValue: string;
begin
  Result:=GetStrValue;
end;

procedure TAcsAudioInDriverNamePropertyEditor.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

procedure TAcsAudioInDriverNamePropertyEditor.GetValueList(List: TStrings);
var
  i: Integer;
begin
  for i:=0 to Length(InDriverInfos)-1 do
  begin
    List.Append(InDriverInfos[i].DriverName);
  end;
end;

{ TAcsStringProperty }

function TAcsStringProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TAcsStringProperty.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  Values: TStringList;
begin
  Values:=TStringList.Create;
  try
    GetValueList(Values);
    for i:=0 to Values.Count-1 do Proc(Values[i]);
  finally
    Values.Free;
  end;
end;

function TAcsStringProperty.GetComponent: TPersistent;
begin
  Result:=inherited GetComponent(0);
end;

end.

