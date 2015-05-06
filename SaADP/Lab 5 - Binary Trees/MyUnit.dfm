object MyForm: TMyForm
  Left = 229
  Top = 70
  Caption = #1044#1077#1088#1077#1074#1100#1103
  ClientHeight = 711
  ClientWidth = 1316
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object DetourLabel: TLabel
    Left = 3
    Top = 190
    Width = 100
    Height = 22
    Caption = 'DetourLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Cambria'
    Font.Style = []
    ParentFont = False
  end
  object TreeViewer: TScrollBox
    Left = 8
    Top = 8
    Width = 128
    Height = 128
    TabOrder = 0
    object TreeImage: TImage
      Left = 8
      Top = 8
      Width = 105
      Height = 105
    end
  end
  object ActionsBox: TGroupBox
    Left = 465
    Top = -67
    Width = 300
    Height = 688
    Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1085#1072#1076' '#1076#1077#1088#1077#1074#1086#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Georgia'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object VisualizationLabel: TLabel
      Left = 70
      Top = 517
      Width = 157
      Height = 18
      Caption = #1042#1080#1079#1091#1072#1083#1080#1079#1072#1094#1080#1103' '#1086#1073#1093#1086#1076#1072
      Visible = False
    end
    object DataLabel: TLabel
      Left = 50
      Top = 304
      Width = 62
      Height = 18
      Caption = #1044#1072#1085#1085#1099#1077':'
    end
    object Label2: TLabel
      Left = 45
      Top = 437
      Width = 93
      Height = 18
      Caption = #1058#1080#1082' '#1090#1072#1081#1084#1077#1088#1072
    end
    object LeftDetourBtn: TButton
      Left = 35
      Top = 30
      Width = 231
      Height = 35
      Caption = #1055#1088#1103#1084#1086#1081' '#1086#1073#1093#1086#1076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Georgia'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = LeftDetourBtnClick
    end
    object RightDetourBtn: TButton
      Left = 35
      Top = 75
      Width = 231
      Height = 35
      Caption = #1054#1073#1088#1072#1090#1085#1099#1081' '#1086#1073#1093#1086#1076
      TabOrder = 1
      OnClick = RightDetourBtnClick
    end
    object SymmetricDetourBtn: TButton
      Left = 35
      Top = 120
      Width = 231
      Height = 35
      Caption = #1057#1080#1084#1084#1077#1090#1088#1080#1095#1085#1099#1081' '#1086#1073#1093#1086#1076
      TabOrder = 2
      OnClick = SymmetricDetourBtnClick
    end
    object LoadTreeBtn: TButton
      Left = 35
      Top = 190
      Width = 231
      Height = 35
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1077#1088#1077#1074#1086' '#1080#1079' '#1092#1072#1081#1083#1072
      TabOrder = 3
      OnClick = LoadTreeBtnClick
    end
    object DeleteTreeBtn: TButton
      Left = 35
      Top = 235
      Width = 231
      Height = 35
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
      TabOrder = 4
      OnClick = DeleteTreeBtnClick
    end
    object VertexEdit: TEdit
      Left = 150
      Top = 300
      Width = 115
      Height = 26
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 6
      NumbersOnly = True
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
    object AddVertexBtn: TButton
      Left = 35
      Top = 332
      Width = 231
      Height = 35
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1077#1088#1096#1080#1085#1091
      TabOrder = 6
      OnClick = AddVertexBtnClick
    end
    object AnimProgressBar: TProgressBar
      Left = 35
      Top = 541
      Width = 231
      Height = 21
      Max = 1000
      TabOrder = 7
      Visible = False
    end
    object TimerDelayEdit: TEdit
      Left = 149
      Top = 433
      Width = 116
      Height = 27
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 5
      NumbersOnly = True
      ParentFont = False
      TabOrder = 8
      Text = '350'
    end
    object SetTimerTickBtn: TButton
      Left = 35
      Top = 466
      Width = 231
      Height = 35
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 9
      OnClick = SetTimerTickBtnClick
    end
    object StopAnimBtn: TButton
      Left = 35
      Top = 568
      Width = 231
      Height = 35
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 10
      Visible = False
      OnClick = StopAnimBtnClick
    end
    object StitchBtn: TButton
      Left = 35
      Top = 375
      Width = 231
      Height = 35
      Caption = #1055#1088#1086#1096#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
      TabOrder = 11
      OnClick = StitchBtnClick
    end
  end
  object TreeOpenFileDialog: TOpenTextFileDialog
    Left = 10
    Top = 140
  end
  object AnimationTimer: TTimer
    Interval = 350
    OnTimer = AnimationTimerTimer
    Left = 5
    Top = 215
  end
end
