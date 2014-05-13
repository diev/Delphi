object Form1: TForm1
  Left = 424
  Top = 172
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1092#1072#1081#1083#1086#1074
  ClientHeight = 626
  ClientWidth = 694
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Label4: TLabel
    Left = 31
    Top = 80
    Width = 39
    Height = 17
    Caption = 'Label4'
  end
  object Label22: TLabel
    Left = 18
    Top = 604
    Width = 41
    Height = 16
    Caption = #1042#1077#1088#1089#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 27
    Top = 25
    Width = 604
    Height = 43
    Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1088#1077#1081#1089' '#1074' '#1040#1056#1052' '#1050#1041#1056
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button4: TButton
    Left = 600
    Top = 597
    Width = 65
    Height = 20
    Caption = 'base64'
    TabOrder = 1
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 593
    Top = 572
    Width = 64
    Height = 22
    Caption = 'journ'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object ListBox1: TListBox
    Left = 24
    Top = 112
    Width = 641
    Height = 449
    Color = clBtnFace
    ItemHeight = 17
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Left = 644
    Top = 72
  end
end
