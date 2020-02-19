//CreoSource Inc. (info@creosource.com)
//Classes representing single key strokes and list of key strokes
unit u_gif;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, contnrs, fgl;

type

  { TGifFrame }
  TGifFrame = class
  protected type
    TIntList = specialize TFPGList<integer>;
  private
    FKeys: TIntList;
  public
    constructor Create;
    destructor Destroy; override;
    property Keys: TIntList read FKeys write FKeys;
  end;

  { TGif }
  TGif = class(TObjectList)
  private
    FCurrentyFrame: integer;
  protected
    function GetItem(index: integer): TGifFrame;
    procedure SetItem(Index: integer; AObject: TGifFrame);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AObject: TGifFrame): integer; reintroduce; virtual;
    function Remove(AObject: TGifFrame): integer; reintroduce; virtual;
    property Items[index: integer]: TGifFrame read GetItem write SetItem; default;
    property CurrentyFrame: integer read FCurrentyFrame write FCurrentyFrame;
  end;

implementation

uses u_const;

{ TGif }

function TGif.GetItem(index: integer): TGifFrame;
begin
  Result := nil;
    try
      Result := inherited Items[Index] as TGifFrame
    except
    end;
end;

procedure TGif.SetItem(Index: integer; AObject: TGifFrame);
begin
  try
    inherited Items[Index] := AObject
  except
  end;
end;

constructor TGif.Create;
begin
  inherited Create;
  OwnsObjects := True;
  FCurrentyFrame := 1;
end;

destructor TGif.Destroy;
begin
  inherited Destroy;
end;

function TGif.Add(AObject: TGifFrame): integer;
begin
  Result := inherited Add(AObject);
end;

function TGif.Remove(AObject: TGifFrame): integer;
begin
  Result := inherited Remove(AObject);
end;

{ TGifFrame }

constructor TGifFrame.Create;
begin
  FKeys := TIntList.Create;
end;

destructor TGifFrame.Destroy;
begin
  if (FKeys <> nil) then
    FreeAndNil(FKeys);
  inherited Destroy;
end;


end.















