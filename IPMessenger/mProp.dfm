object PropForm: TPropForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'IP'#12513#12483#12475#12531#12472#12515#12540
  ClientHeight = 169
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BarPosLabel: TLabel
    Left = 8
    Top = 8
    Width = 72
    Height = 13
    Caption = #12496#12540#12398#20301#32622'(&P):'
    FocusControl = BarPosComboBox
  end
  object Bevel: TBevel
    Left = 0
    Top = 128
    Width = 281
    Height = 9
    Shape = bsTopLine
  end
  object PortLabel: TLabel
    Left = 8
    Top = 56
    Width = 48
    Height = 13
    Caption = #12509#12540#12488'(&O):'
    FocusControl = PortSpinEdit
  end
  object UserNameLabel: TLabel
    Left = 144
    Top = 8
    Width = 49
    Height = 13
    Caption = #12518#12540#12470'(&U):'
    FocusControl = UserNameEdit
  end
  object GroupNameLabel: TLabel
    Left = 144
    Top = 56
    Width = 57
    Height = 13
    Caption = #12464#12523#12540#12503'(&G):'
    FocusControl = GroupNameEdit
  end
  object BarPosComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 129
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    Items.Strings = (
      #24038
      #19978
      #21491
      #19979)
  end
  object OKButton: TButton
    Left = 104
    Top = 136
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelButton: TButton
    Left = 192
    Top = 136
    Width = 81
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 6
  end
  object PortSpinEdit: TSpinEditEx
    Left = 8
    Top = 72
    Width = 129
    Height = 22
    MaxLength = 5
    MaxValue = 65535
    MinValue = 1024
    NumbersOnly = True
    TabOrder = 1
    Value = 1024
  end
  object UserNameEdit: TEdit
    Left = 144
    Top = 24
    Width = 129
    Height = 21
    TabOrder = 2
  end
  object GroupNameEdit: TEdit
    Left = 144
    Top = 72
    Width = 129
    Height = 21
    TabOrder = 3
  end
  object DisplayAlertCheckBox: TCheckBox
    Left = 8
    Top = 104
    Width = 265
    Height = 17
    Caption = #36890#30693#12434#34920#31034#12377#12427'(&D)'
    TabOrder = 4
  end
end
