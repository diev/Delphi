object AboutBox: TAboutBox
  Left = 407
  Top = 283
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 545
  ClientWidth = 955
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 956
    Height = 481
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProductName: TLabel
      Left = 10
      Top = 10
      Width = 315
      Height = 16
      Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1080' '#1079#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1089#1087#1080#1089#1082#1086#1074', '#1074#1077#1088#1089#1080#1103' 4.0'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object Copyright: TLabel
      Left = 10
      Top = 39
      Width = 380
      Height = 16
      Caption = '('#1089') 2009 - 2012 ,  '#1048#1088#1082#1091#1090#1089#1082#1080#1081' '#1056#1060' '#1054#1040#1054' "'#1056#1086#1089#1089#1077#1083#1100#1093#1086#1079#1073#1072#1085#1082'"'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      Transparent = False
      WordWrap = True
      IsControl = True
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 74
      Width = 952
      Height = 224
      Caption = #1055#1083#1072#1075#1080#1085#1099' '
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 2
        Top = 18
        Width = 948
        Height = 204
        Align = alClient
        Caption = 'Label1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 310
      Width = 952
      Height = 169
      Align = alBottom
      Caption = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label2: TLabel
        Left = 2
        Top = 18
        Width = 948
        Height = 149
        Align = alClient
        Caption = 'Label2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object OKButton: TButton
    Left = 418
    Top = 494
    Width = 92
    Height = 30
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
