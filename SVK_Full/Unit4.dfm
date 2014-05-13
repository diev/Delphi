object DecodeForm: TDecodeForm
  Left = 210
  Top = 139
  Width = 1103
  Height = 629
  BorderIcons = [biSystemMenu, biMaximize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 1095
    Height = 555
    Align = alClient
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 555
    Width = 1095
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 366
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'OK'
      ModalResult = 2
      TabOrder = 0
    end
  end
end
