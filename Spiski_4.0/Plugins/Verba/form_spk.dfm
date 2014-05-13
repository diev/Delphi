object spk: Tspk
  Left = 793
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'spk'
  ClientHeight = 409
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 16
    Width = 273
    Height = 353
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 72
    Top = 376
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 160
    Top = 376
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
end
