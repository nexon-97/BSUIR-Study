object XmlCodeForm: TXmlCodeForm
  Left = 269
  Top = 157
  Width = 1088
  Height = 556
  Caption = 'DOM-'#1084#1086#1076#1077#1083#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 176
    Height = 18
    Caption = 'DOM '#1084#1086#1076#1077#1083#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Georgia'
    Font.Style = []
    ParentFont = False
  end
  object DisplayXmlMemo: TMemo
    Left = 8
    Top = 24
    Width = 185
    Height = 89
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
    WordWrap = False
  end
  object ShowCheckStatusBtn: TButton
    Left = 5
    Top = 480
    Width = 250
    Height = 33
    Caption = #1055#1088#1086#1089#1084#1086#1088#1077#1090#1100' '#1089#1090#1072#1090#1091#1089' '#1087#1088#1086#1074#1077#1088#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Georgia'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object XMLDocument: TXMLDocument
    Left = 8
    Top = 120
    DOMVendorDesc = 'MSXML'
  end
end
