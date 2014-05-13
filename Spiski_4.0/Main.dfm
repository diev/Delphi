object MainForm: TMainForm
  Left = 368
  Top = 254
  Width = 1150
  Height = 727
  Caption = 
    #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1086#1073#1088#1072#1073#1086#1090#1082#1072' '#1089#1087#1080#1089#1082#1086#1074'          '#1048#1088#1082#1091#1090#1089#1082#1080#1081' '#1056#1060' '#1054#1040#1054' "'#1056#1086#1089#1089 +
    #1077#1083#1100#1093#1086#1079#1073#1072#1085#1082'"'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 638
    Width = 1132
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1132
    Height = 249
    Align = alTop
    TabOrder = 0
    object Label9: TLabel
      Left = 12
      Top = 15
      Width = 142
      Height = 16
      Caption = #1054#1087#1077#1088#1072#1094#1080#1086#1085#1085#1099#1081' '#1076#1077#1085#1100':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 64
      Top = 39
      Width = 90
      Height = 16
      Caption = #1057#1095#1077#1090' '#1076#1077#1073#1077#1090#1072':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 63
      Top = 75
      Width = 86
      Height = 16
      Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 404
      Top = 108
      Width = 5
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 423
      Top = 108
      Width = 421
      Height = 16
      Caption = '*'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' -  '#1074' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1080' '#1085#1077' '#1076#1086#1083#1078#1085#1086' '#1073#1099#1090#1100' '#1076#1074#1086#1081#1085#1099#1093' '#1082#1072#1074#1099#1095#1077#1082' "'
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 142
      Width = 1130
      Height = 106
      Align = alBottom
      Caption = #1057#1087#1080#1089#1082#1086#1074#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 345
        Top = 0
        Width = 72
        Height = 16
        Caption = #1047#1072#1095#1080#1089#1083#1077#1085#1086
      end
      object Label3: TLabel
        Left = 532
        Top = 0
        Width = 93
        Height = 16
        Caption = #1053#1077' '#1079#1072#1095#1080#1089#1083#1077#1085#1086
      end
      object lv2: TListView
        Left = 2
        Top = 18
        Width = 1126
        Height = 86
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Width = 62
          end
          item
            Caption = #1050#1086#1083'-'#1074#1086
            Width = 111
          end
          item
            Caption = #1057#1091#1084#1084#1072
            Width = 123
          end
          item
            Caption = #1050#1086#1083#1080#1095'.'
            Width = 86
          end
          item
            Caption = #1057#1091#1084#1084#1072
            Width = 123
          end
          item
            Caption = #1050#1086#1083#1080#1095'.'
            Width = 86
          end
          item
            Caption = #1057#1091#1084#1084#1072
            Width = 123
          end>
        FlatScrollBars = True
        GridLines = True
        HideSelection = False
        HotTrackStyles = [htHandPoint, htUnderlineHot]
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lv2Click
      end
    end
    object Edit2: TEdit
      Left = 174
      Top = 69
      Width = 811
      Height = 24
      TabOrder = 1
    end
    object dtp1: TDateTimePicker
      Left = 174
      Top = 10
      Width = 123
      Height = 24
      Date = 0.621232118050102100
      Time = 0.621232118050102100
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnKeyPress = dtp1KeyPress
    end
    object Edit1: TMaskEdit
      Left = 174
      Top = 39
      Width = 196
      Height = 24
      EditMask = '!99999999999999999999;1; '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      TabOrder = 3
      Text = '30102810566000000001'
    end
  end
  object lv1: TListView
    Left = 0
    Top = 249
    Width = 1132
    Height = 389
    Align = alClient
    Checkboxes = True
    Color = 16119027
    Columns = <
      item
        Caption = #8470
        Width = 86
      end
      item
        Caption = #1054#1090#1076#1077#1083#1077#1085#1080#1077' '#1073#1072#1085#1082#1072
        Width = 62
      end
      item
        Caption = #1060#1080#1083#1080#1072#1083' '#1086#1090#1076#1077#1083#1077#1085#1080#1103
        Width = 62
      end
      item
        Caption = #8470' '#1082#1072#1088#1090#1086#1095#1082#1080
        Width = 12
      end
      item
        Caption = #1060#1048#1054
        Width = 246
      end
      item
        Width = 12
      end
      item
        Width = 12
      end
      item
        Caption = #1057#1095#1077#1090
        Width = 209
      end
      item
        Caption = #1057#1091#1084#1084#1072
        Width = 98
      end
      item
        Caption = #1044#1086#1087#1083#1072#1090#1072' '#1084#1101#1088#1072
        Width = 12
      end
      item
        Caption = #1054#1090#1076#1077#1083#1100#1085#1099#1077' '#1074#1080#1076#1099
        Width = 12
      end
      item
        Caption = #1059#1042#1054#1042
        Width = 12
      end
      item
        Caption = #1044#1077#1090#1103#1084' '#1076#1086' 3'#1093
        Width = 12
      end
      item
        Caption = #1047#1072' '#1090#1077#1083#1077#1092#1086#1085
        Width = 12
      end
      item
        Caption = #1048#1058#1054#1043
        Width = 98
      end
      item
        Caption = #1042#1072#1083#1102#1090#1072
        Width = 62
      end
      item
        Caption = #1044#1072#1090#1072
        Width = 62
      end
      item
        Caption = 'ID'
        Width = 62
      end
      item
        Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
        Width = 62
      end
      item
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        Width = 98
      end>
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    FlatScrollBars = True
    GridLines = True
    HideSelection = False
    HotTrackStyles = [htHandPoint, htUnderlineHot]
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnCustomDrawSubItem = lv1CustomDrawSubItem
  end
  object MainMenu1: TMainMenu
    Left = 752
    Top = 168
    object N1: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
    end
    object N14: TMenuItem
      Caption = #1055#1083#1072#1075#1080#1085#1099
    end
    object N3: TMenuItem
      Caption = #1057#1077#1088#1074#1080#1089
      object N4: TMenuItem
        Caption = #1047#1072#1095#1080#1089#1083#1080#1090#1100
        Enabled = False
        OnClick = N4Click
      end
    end
    object N7: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object N8: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N8Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 720
    Top = 169
    object N9: TMenuItem
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1089#1091#1084#1084#1091
      OnClick = N9Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 785
    Top = 168
  end
end
