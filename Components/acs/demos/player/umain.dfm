object fMain: TfMain
  Left = 271
  Top = 150
  BorderStyle = bsToolWindow
  Caption = 'Audioplayer'
  ClientHeight = 99
  ClientWidth = 204
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 4
    Top = 0
    Width = 192
    Height = 64
    BevelOuter = bvLowered
    FullRepaint = False
    TabOrder = 0
    object lTime: TLabel
      Left = 1
      Top = 24
      Width = 108
      Height = 29
      AutoSize = False
      Caption = '00:00:00'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lFilename: TLabel
      Left = 1
      Top = 1
      Width = 190
      Height = 13
      Align = alTop
      Caption = 'File:'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object lTime1: TLabel
      Left = 1
      Top = 21
      Width = 57
      Height = 13
      Caption = 'Time remain'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lTime2: TLabel
      Left = 116
      Top = 21
      Width = 14
      Height = 13
      Caption = 'left'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object lLeft: TLabel
      Left = 116
      Top = 32
      Width = 42
      Height = 13
      Caption = '00:00:00'
      Color = clNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Progress: TProgressBar
      Left = 1
      Top = 55
      Width = 190
      Height = 8
      Align = alBottom
      Min = 0
      Max = 1000
      Smooth = True
      TabOrder = 0
    end
  end
  object btOpen: TBitBtn
    Left = 4
    Top = 67
    Width = 28
    Height = 26
    TabOrder = 1
    OnClick = OpenClick
    Layout = blGlyphTop
  end
  object btRew: TBitBtn
    Left = 32
    Top = 67
    Width = 28
    Height = 26
    TabOrder = 2
    OnClick = btRewClick
  end
  object btFfw: TBitBtn
    Left = 60
    Top = 67
    Width = 28
    Height = 26
    TabOrder = 3
    OnClick = btFfwClick
    Layout = blGlyphRight
  end
  object btPlay: TBitBtn
    Left = 88
    Top = 67
    Width = 28
    Height = 30
    TabOrder = 4
    OnClick = PlayClick
  end
  object btStop: TBitBtn
    Left = 144
    Top = 67
    Width = 28
    Height = 30
    TabOrder = 5
    OnClick = StopClick
  end
  object btPause: TBitBtn
    Left = 116
    Top = 67
    Width = 28
    Height = 30
    TabOrder = 6
    OnClick = Pauseclick
  end
  object btPlaylist: TBitBtn
    Left = 174
    Top = 67
    Width = 22
    Height = 17
    TabOrder = 7
    OnClick = btPlaylistClick
  end
  object btVizu: TBitBtn
    Left = 174
    Top = 84
    Width = 22
    Height = 13
    Caption = 'Vis'
    TabOrder = 8
    OnClick = btVizuClick
  end
  object FileIn1: TACSFileIn
    EndSample = -1
    Loop = False
    StartSample = 0
    Left = 72
  end
  object PlayTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 72
    Top = 32
  end
  object AudioOut1: TACSAudioOut
    Driver = 'Wavemapper'
    Device = 0
    Volume = 0
    Input = SoundIndicator
    Delay = 6
    SuspendWhenIdle = True
    OnDone = AudioOut1Done
    OnThreadException = AudioOut1ThreadException
    Left = 40
    Top = 32
  end
  object SoundIndicator: TACSSoundIndicator
    Input = FileIn1
    Left = 40
  end
end
