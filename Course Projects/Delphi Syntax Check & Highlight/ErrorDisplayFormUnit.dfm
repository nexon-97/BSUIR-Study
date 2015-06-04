object ErrorDisplayForm: TErrorDisplayForm
  Left = 447
  Top = 216
  Width = 736
  Height = 288
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1089#1080#1085#1090#1072#1082#1089#1080#1089#1072
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
  object CheckRichEdit: TRichEdit
    Left = 5
    Top = 8
    Width = 710
    Height = 193
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    HideScrollBars = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object CloseFormButton: TButton
    Left = 280
    Top = 208
    Width = 161
    Height = 33
    Caption = #1047#1072#1082#1088#1099#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Georgia'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CloseFormButtonClick
  end
end
