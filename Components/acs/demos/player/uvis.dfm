object fVizu: TfVizu
  Left = 483
  Top = 150
  Width = 202
  Height = 126
  BorderStyle = bsSizeToolWin
  Caption = 'Visualization'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 194
    Height = 80
    Align = alClient
    Transparent = True
  end
  object MainMenu1: TMainMenu
    Left = 17
    Top = 10
    object miType: TMenuItem
      Caption = 'Type'
      object rFFT: TMenuItem
        AutoCheck = True
        Caption = 'FFT'
        Checked = True
        GroupIndex = 1
        RadioItem = True
      end
      object MenuItem2: TMenuItem
        AutoCheck = True
        Caption = 'Wave'
        GroupIndex = 1
        RadioItem = True
      end
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 48
    Top = 8
  end
end
