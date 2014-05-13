object Form1: TForm1
  Left = 424
  Top = 172
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1092#1072#1081#1083#1086#1074
  ClientHeight = 718
  ClientWidth = 685
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
  object TAnimate
    Left = 629
    Top = 107
    Width = 272
    Height = 60
    Active = True
    CommonAVI = aviFindFile
    StopFrame = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 699
    Width = 685
    Height = 19
    Panels = <>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 685
    Height = 699
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1088#1080#1077#1084'/'#1054#1090#1087#1088#1072#1074#1082#1072
      object Label4: TLabel
        Left = 31
        Top = 80
        Width = 39
        Height = 17
        Caption = 'Label4'
      end
      object Label22: TLabel
        Left = 10
        Top = 644
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
      object GroupBox1: TGroupBox
        Left = 4
        Top = 105
        Width = 667
        Height = 472
        Caption = #1042#1093#1086#1076#1103#1097#1080#1077' '#1092#1072#1081#1083#1099' '#1080#1079' '#1040#1056#1052' '#1050#1041#1056' '#1085#1072' '#1086#1073#1088#1072#1073#1086#1090#1082#1091' '#1074' '#1040#1041#1057
        TabOrder = 0
        object SGIN: TStringGrid
          Left = 4
          Top = 27
          Width = 656
          Height = 441
          Color = clBtnFace
          ColCount = 4
          DefaultColWidth = 50
          DefaultRowHeight = 17
          FixedCols = 0
          RowCount = 500
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ScrollBars = ssVertical
          TabOrder = 0
          OnClick = SGINClick
          OnDblClick = SGINClick
          ColWidths = (
            65
            61
            548
            6)
        end
      end
      object Button1: TButton
        Left = 35
        Top = 25
        Width = 604
        Height = 43
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1088#1077#1081#1089' '#1074' '#1040#1056#1052' '#1050#1041#1056
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button4: TButton
        Left = 564
        Top = 589
        Width = 93
        Height = 33
        Caption = 'Base64'
        TabOrder = 2
        OnClick = Button4Click
      end
      object Button3: TButton
        Left = 556
        Top = 635
        Width = 101
        Height = 22
        Caption = 'change pass'
        TabOrder = 3
        OnClick = Button3Click
      end
      object CheckBox1: TCheckBox
        Left = 449
        Top = 588
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
        TabOrder = 4
      end
    end
  end
  object TimerKBR_In: TTimer
    Interval = 30000
    OnTimer = TimerKBR_InTimer
    Left = 432
    Top = 160
  end
  object TimerShowmessage: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = TimerShowmessageTimer
    Left = 432
    Top = 216
  end
  object IdTelnet1: TIdTelnet
    MaxLineAction = maException
    ReadTimeout = 0
    Port = 23
    OnDataAvailable = IdTelnet1DataAvailable
    Terminal = 'dumb'
    Left = 464
    Top = 24
  end
  object Timer_auto: TTimer
    OnTimer = Timer_autoTimer
    Left = 432
    Top = 280
  end
  object OpenDialog1: TOpenDialog
    Left = 420
    Top = 80
  end
end
