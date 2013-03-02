object AlertForm: TAlertForm
  Left = 0
  Top = 0
  AlphaBlend = True
  AlphaBlendValue = 0
  BorderStyle = bsNone
  Caption = 'AlertForm'
  ClientHeight = 57
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClick = AlertLabelClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AlertImage: TImage
    Left = 8
    Top = 16
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      055449636F6E0000010001001010000001002000680400001600000028000000
      1000000020000000010020000000000000040000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000080A8C0FF507080FF407090FF306880FF306880FF306080FF
      305870FF305870FF305870FF305870FF305060FF305060FF304860FF00000000
      000000000000000080A8C0FFD0FFFFFFA0E8FFFF80E0F0FF80D8F0FF70D0F0FF
      70D0F0FF70C8F0FF70C8F0FF70C8F0FF60C8F0FF60C0F0FF305060FF00000000
      000000000000000080A8C0FFC0E8F0FFB0F8FFFF90F0FFFF90F0FFFF90F0FFFF
      90F0FFFF90F0FFFF90F0FFFF90F0FFFF80E0FFFF60B8E0FF305060FF00000000
      000000000000000080B0C0FF80B8D0FF90E0F0FF90F8FFFF90F0FFFF80E8FFFF
      70E0FFFF80E8FFFF80E8FFFF90F0FFFF70D8F0FF4088B0FF405860FF00000000
      000000000000000090B0C0FFB0E8F0FF60B8D0FF80E8FFFF70E0F0FF50B0E0FF
      30A0D0FF3090C0FF70D0F0FF70D8F0FF4098C0FF60C0E0FF405870FF00000000
      000000000000000090B8D0FFD0FFFFFFA0E8F0FF70C8F0FF50B0E0FF80D8F0FF
      80E8FFFF80E8F0FF40A0C0FF50C0E0FF80E0F0FF70C8F0FF406070FF00000000
      000000000000000090C0D0FFD0FFFFFF90E8F0FF60B8E0FF80E0F0FFA0F8FFFF
      90F0FFFF90F0FFFF90E8FFFF50A8D0FF80E0F0FF70D0F0FF406070FF00000000
      000000000000000090C0D0FFC0F8FFFF60C0E0FF90E0F0FFA0F8FFFFA0F8FFFF
      A0F8FFFFA0F8FFFF90F0FFFF90E8FFFF50A0C0FF60C0E0FF506870FF00000000
      000000000000000090C8D0FFA0E0F0FFC0F0FFFFC0FFFFFFC0F8FFFFB0F8FFFF
      B0F8FFFFB0F8FFFFA0F8FFFF90F0FFFF90E8FFFF4098C0FF506870FF00000000
      000000000000000090C8D0FFD0F8FFFFE0FFFFFFE0FFFFFFE0FFFFFFE0FFFFFF
      E0FFFFFFE0FFFFFFD0FFFFFFD0FFFFFFB0F8FFFF90E0F0FF507080FF00000000
      000000000000000090C8D0FF90C8D0FF90C8D0FF90C8D0FF90C0D0FF90C0D0FF
      90B8D0FF90B8C0FF80B0C0FF80B0C0FF80A8C0FF80A8C0FF80A8C0FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FFFF0000FFFF0000FFFF000080030000800300008003000080030000
      80030000800300008003000080030000800300008003000080030000FFFF0000
      FFFF0000}
    OnClick = AlertLabelClick
  end
  object CloseButton: TCloseButton
    Left = 216
    Top = 8
    Width = 15
    Height = 15
    Hint = #38281#12376#12427'|'
    Flat = True
    Glyph.Data = {
      1A020000424D1A0200000000000036000000280000000B0000000B0000000100
      200000000000E401000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF007171710071717100FF00FF00FF00FF00FF00
      FF007171710071717100FF00FF00FF00FF00FF00FF0071717100FFFFFF00FFFF
      FF0071717100FF00FF0071717100FFFFFF00FFFFFF0071717100FF00FF00FF00
      FF0071717100FFFFFF00FFFFFF00FFFFFF0071717100FFFFFF00FFFFFF00FFFF
      FF0071717100FF00FF00FF00FF00FF00FF0071717100FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0071717100FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0071717100FFFFFF00FFFFFF00FFFFFF0071717100FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0071717100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0071717100FF00FF00FF00FF00FF00FF0071717100FFFFFF00FFFFFF00FFFF
      FF0071717100FFFFFF00FFFFFF00FFFFFF0071717100FF00FF00FF00FF007171
      7100FFFFFF00FFFFFF0071717100FF00FF0071717100FFFFFF00FFFFFF007171
      7100FF00FF00FF00FF00FF00FF007171710071717100FF00FF00FF00FF00FF00
      FF007171710071717100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    OnClick = CloseButtonClick
  end
  object AlertLabel: TLabel
    Left = 32
    Top = 16
    Width = 177
    Height = 25
    AutoSize = False
    WordWrap = True
    OnClick = AlertLabelClick
  end
  object AlertTimer: TTimer
    Enabled = False
    Interval = 7000
    OnTimer = AlertTimerTimer
    Left = 8
    Top = 8
  end
end
