object StyleConfiguratorForm: TStyleConfiguratorForm
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1090#1080#1083#1103
  ClientHeight = 306
  ClientWidth = 921
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 137
    Height = 273
    TabOrder = 0
    object Label1: TLabel
      Left = 18
      Top = 10
      Width = 33
      Height = 18
      Caption = #1071#1079#1099#1082
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LangListBox: TListBox
      Left = 16
      Top = 30
      Width = 105
      Height = 228
      Style = lbOwnerDrawFixed
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      IntegralHeight = True
      ItemHeight = 16
      Items.Strings = (
        'Assembly'
        'C'
        'C#'
        'C++'
        'CSS'
        'Delphi'
        'HTML'
        'Java'
        'JavaScript'
        'PHP'
        'SQL'
        'XML')
      ParentFont = False
      Sorted = True
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 168
    Top = 16
    Width = 257
    Height = 273
    TabOrder = 1
    object Label2: TLabel
      Left = 18
      Top = 10
      Width = 103
      Height = 18
      Caption = #1069#1083#1077#1084#1077#1085#1090' '#1089#1090#1080#1083#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object StyleOptionListBox: TListBox
      Left = 16
      Top = 32
      Width = 225
      Height = 225
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 18
      Items.Strings = (
        #1054#1073#1099#1095#1085#1099#1081' '#1090#1077#1082#1089#1090
        #1042#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1082#1089#1090
        #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        #1057#1090#1088#1086#1082#1072
        #1063#1080#1089#1083#1086
        #1052#1085#1086#1075#1086#1089#1090#1088#1086#1095#1085#1099#1081' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
        #1047#1072#1088#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1085#1085#1086#1077' '#1089#1083#1086#1074#1086)
      ParentFont = False
      TabOrder = 0
      OnClick = StyleOptionListBoxClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 440
    Top = 16
    Width = 209
    Height = 233
    TabOrder = 2
    object Label3: TLabel
      Left = 18
      Top = 10
      Width = 118
      Height = 18
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1094#1074#1077#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 88
      Top = 56
      Width = 85
      Height = 18
      Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object FontColorPreview: TImage
      Left = 24
      Top = 48
      Width = 40
      Height = 40
      OnClick = FontColorPreviewClick
    end
    object BackColorPreview: TImage
      Left = 24
      Top = 96
      Width = 40
      Height = 40
      OnClick = BackColorPreviewClick
    end
    object Label5: TLabel
      Left = 88
      Top = 104
      Width = 75
      Height = 18
      Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object SaveStyleBtn: TButton
    Left = 592
    Top = 264
    Width = 161
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = SaveStyleBtnClick
  end
  object ApplyStyleBtn: TButton
    Left = 440
    Top = 264
    Width = 137
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ApplyStyleBtnClick
  end
  object CancelBtn: TButton
    Left = 768
    Top = 264
    Width = 137
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = CancelBtnClick
  end
  object GroupBox4: TGroupBox
    Left = 664
    Top = 16
    Width = 241
    Height = 233
    TabOrder = 6
    object Label6: TLabel
      Left = 18
      Top = 10
      Width = 92
      Height = 18
      Caption = #1057#1090#1080#1083#1100' '#1090#1077#1082#1089#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 18
      Top = 50
      Width = 50
      Height = 18
      Caption = #1064#1088#1080#1092#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 18
      Top = 82
      Width = 49
      Height = 18
      Caption = #1056#1072#1079#1084#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object FontPickerBox: TComboBox
      Left = 84
      Top = 48
      Width = 145
      Height = 26
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 18
      ItemIndex = 1
      ParentFont = False
      Sorted = True
      TabOrder = 0
      Text = 'Courier New'
      OnChange = FontPickerBoxChange
      Items.Strings = (
        'Arial'
        'Courier New'
        'Tahoma')
    end
    object fsBoldCheckBox: TCheckBox
      Left = 16
      Top = 128
      Width = 145
      Height = 17
      Caption = #1046#1080#1088#1085#1099#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = fsBoldCheckBoxClick
    end
    object fsItalicCheckBox: TCheckBox
      Left = 16
      Top = 152
      Width = 137
      Height = 17
      Caption = #1050#1091#1088#1089#1080#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = fsItalicCheckBoxClick
    end
    object fsUnderlineCheckBox: TCheckBox
      Left = 16
      Top = 176
      Width = 145
      Height = 17
      Caption = #1055#1086#1076#1095#1077#1088#1082#1085#1091#1090#1099#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = fsUnderlineCheckBoxClick
    end
    object FontSizeEdit: TEdit
      Left = 84
      Top = 80
      Width = 130
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = '8'
    end
    object FontSizeUpDown: TUpDown
      Left = 211
      Top = 80
      Width = 16
      Height = 36
      Associate = FontSizeEdit
      Min = 8
      Max = 72
      Position = 8
      TabOrder = 5
    end
  end
  object textColorPicker: TColorDialog
    Left = 464
    Top = 168
  end
end
