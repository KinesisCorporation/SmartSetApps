object fPlaylist: TfPlaylist
  Left = 278
  Top = 276
  Width = 208
  Height = 242
  BorderStyle = bsSizeToolWin
  Caption = 'Playlist'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  DesignSize = (
    200
    215)
  PixelsPerInch = 96
  TextHeight = 13
  object lbPlaylist: TListBox
    Left = 0
    Top = 0
    Width = 200
    Height = 215
    Align = alClient
    BorderStyle = bsNone
    ItemHeight = 13
    TabOrder = 0
  end
  object btAdd: TBitBtn
    Left = 0
    Top = 193
    Width = 27
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = '+'
    TabOrder = 1
    OnClick = btAddClick
  end
  object Button1: TButton
    Left = 32
    Top = 193
    Width = 27
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = '-'
    TabOrder = 2
    OnClick = Button1Click
  end
  object OpenDialog: TOpenDialog
    FilterIndex = 0
    Options = [ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Vorhandene Datei '#246'ffnen'
  end
end
