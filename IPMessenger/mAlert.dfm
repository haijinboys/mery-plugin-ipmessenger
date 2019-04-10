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
    OnClick = AlertLabelClick
  end
  object CloseButton: TCloseButton
    Left = 216
    Top = 8
    Width = 16
    Height = 16
    Hint = #38281#12376#12427'|'
    OnClick = CloseButtonClick
  end
  object AlertLabel: TLabel
    AlignWithMargins = True
    Left = 32
    Top = 8
    Width = 177
    Height = 41
    Margins.Left = 32
    Margins.Top = 8
    Margins.Right = 32
    Margins.Bottom = 8
    Align = alClient
    AutoSize = False
    Layout = tlCenter
    WordWrap = True
    OnClick = AlertLabelClick
    ExplicitTop = 16
    ExplicitHeight = 25
  end
  object SmallImage: TImage
    Left = 8
    Top = 8
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
      001008060000001FF3FF61000000097048597300000EC300000EC301C76FA864
      000001214944415478DA6364A010300E0E03F6CC0BFB4FAA4697A4558C2806F0
      B2B33198F9FA12D4786AF3668617EF3E31F8E76E4235C0D8D686E1D6A9530C66
      1EEA1095FFFF33FCFFF78FE11F10FFFFF717CC3E7FF03183B29E18C3AE1D3718
      A24AB7A11AE01C12CCF0F6E14986BB975E3198B9ABE1D42C28C6CB3067FA3186
      F486DD9806FCFE741EA8F009D801C6CE4A289A41C0C44599E1EFEF9F0CF3E79C
      C56E00C87F205B40E0C5832F0C5F3F7D63E0E6E3629050E0018B815CA76725CE
      B068E1254C03408108D22C2C250856FCF6D97B78C0F18B70815DF2E9DD0FB021
      176EBFC43400148802421FA1E107094030FEFF0FC106E22F9FFE30AC5D7B19BB
      17187EDFC2AB19C407C50E562F7CFDFA83E1EB8F3F0C9FBFFE262A21A1184071
      521E500300D59DD4115425E2390000000049454E44AE426082}
    Visible = False
  end
  object MediumImage: TImage
    Left = 32
    Top = 8
    Width = 24
    Height = 24
    AutoSize = True
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
      00180806000000E0773DF80000000774494D4507DC03041311256757710D0000
      00097048597300000EC300000EC301C76FA8640000000467414D410000B18F0B
      FC61050000015E4944415478DA6364A031601CB560D402EA58B0675ED87F5A18
      3EEFBC363F8A05CEC17E446AFD07C4402DFFFF41D9FF50D87BD71F6478F9EA2B
      C3D6A7668A700B2CDD9D198EEFDC4B8425840DB7703162583A672FC3C1F73608
      0B40067FFBF2958025C419CEC5C3CE307BC2364C0B4000B725C41B0EE2CF9EB0
      03BB0520F0FDEB5786633B902D21CD7090DAD91376E2B600D5121F920D07C9CF
      9EB89BB00F2CDD1D81C1B59FC139C813AFE127F69C03D2FA104BA0F2B327EEC5
      6E01BACBBF7DFECC707CD721061B2F5B06767636B0E65F3F7F301CDE761CC5E5
      FB369C04F27518B8B8D9A016ECC7B4005FB0EC5DB71B25089D02AC11BE82AADD
      B7F10CD0124D062E2E5686D9930EA25A60E5E14C549883F07F143EAADA7D1B2F
      305838AB312C9D7B12D502484EA6CC70187BDFA62B0C771FBC470F22EA180E16
      0782D9938EA05A002A3BBE7CFB45B0142205C02D88CA6DE403524254351D023E
      0DFD0A070045666C201F2F3D4A0000000049454E44AE426082}
    Visible = False
  end
  object LargeImage: TImage
    Left = 64
    Top = 8
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
      00200806000000737A7AF4000000097048597300000EC300000EC301C76FA864
      000002E34944415478DAED965B4F134114C74FF14105A168C02A556388122E49
      915485560860152F4F468D899A181363624C887E03E367F0D5344A1443046ABD
      4B146A10353E4002B560118A172A2DBD6D6D4B55D87166D8D974ED522A50F1A1
      B3393B67E64CF6FFDBB3B333A380652E8A34401A200DC09C37E6CB488110D00B
      D780843AA60D88A73E8A8901CF93BB18A3E379A12611EAD21162DCD85796899D
      69621280AA7ADD22DE05311DB10D28C617EE66E3756875D46EC26E105B440290
      9D118132FDE6E425596698F81F199BCD0CF311F459BEC0579713DA1CB5A538E2
      C1E69700149716C2F89035298885881769D5D0F9E81DB48DD56970D48DCD1BF7
      0902CE5E181FF6278458A8B8322F0B4C37BB1203C02F3B04264373422C461CE1
      096B6AB240FBA77A39804B18404F01C8C302AEEFE01CE524108B152766BEDDCD
      32E0C2E613015E9B1A91CE500DE8E7077130C9C4C45888422C8538C2BFEAE3D6
      7E68B16BE3017ADA2E22FDFE5AE0A383E26052DB7B3D345E5AA5FE2B7152761D
      28928893FA49BB950094E3F08404E0D5DD0B48DF5007FC944D22AEDEBE96C6C9
      9C28A92C484A7C9B4645FD917E37680D85E2F3883DBD679307E86E398FF61C34
      C04CC42A11CFCD5F43E36C6296ECDE30AF784EDE6ADAC779223032300915755B
      448067F787E4015EDE39876A0EED83E9F0409C382B0CA278E7FA79C5593FE799
      8251AB07CAAB0B68263A1ED8E5012CCD6751CDE10618ECB6C88AB3E27787C0F9
      D10FE16044ECCBCAC9848D5BB3E3C467F713BCE67A31C47B2F68F42AE878382C
      0FD075EB0CCA57AE4A28CE521FC010428F3829E71267EDA0370A0E9B0F267C41
      7980CEA6D3A8425709B9EBB8C4ABDF1C02C9C4385F14DEF67C96077871E324DA
      7BF4085D8852218E84AD52F8043BB0FB4D02F0DC7802198E1F8B03584AF17901
      C2E128FC8B22003821763B3ED5787525AE54D894D856A49881BC29D98CB85800
      224A8E4A0424D567C5196CE43FFE2111C210198278AA01E84C69BE7685FF7F4E
      C56980E52ABF01589D2C368900B7660000000049454E44AE426082}
    Visible = False
  end
  object ExtraLargeImage: TImage
    Left = 104
    Top = 8
    Width = 48
    Height = 48
    AutoSize = True
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000300000
      003008060000005702F9870000002C744558744372656174696F6E2054696D65
      005468752031362046656220323031322032313A30333A3539202D30303030F4
      06A0BF0000000774494D4507DC030315260FB5B15CE400000009704859730000
      0EC300000EC301C76FA8640000000467414D410000B18F0BFC61050000042749
      44415478DAED985973DB5418865FD996E3387662374B9D3849E3362974686118
      06B828500606E8946BB6B0FE017E03C36FE0B275620786ED9E0BF6C070C105FB
      4C593A943469E325556CC78EE5783D7C47B1133952D4C48E2D77C6DFF848473A
      96F43C3ADF918F2CE02E0FC16C80AE80D9005D01B301BA0266037405CC06E80A
      980DD015301BA02BA0DEF8E1A3B798C7653FFAAB30FE613BF5ED95CE36531DC2
      98E678C62AB8158DC63FBE763E407B8B54CA75028B1FBCC9025303E81B706070
      CC7D84026C97AD0E8CA999EBDAD89EEFDDFA370151B46271F13A3E5B7DC44F7B
      3354B21A8187CF8FE3E63FEB983A7B1C3DBDB68E809733052CFF2961FAC1112C
      047FC277C9C7CE508B4425A51178FC990032892DC4573670E2BE91E6248E0AFE
      2F0913A7BD70BA44CC5F5604CE52EB1A95A4AE008FA6255A00CFA32A70AE2A90
      D857A0298916C11F5AA0218916C2F333842EFF7C38814349B4189E7F42577604
      E2301A03879668033C8F86050C25DA04CF2BA12BBF342EA02BD146782585824D
      0AEC482C738961D86B3DD106781E4722C023723D814C2A8FC039FAC576581B86
      5FBA7A1BC37E3786469D7784575228F86B7302ACC210594A21BB91C7A0AF0F89
      5856E9094D3A1DF0CE0F8FBB9188E7E01972281246F0BC1A6E46A054AC60E56F
      09168B80F1192FAC34B94A27728AD008DDC563A36E08C22EA41E3C2B57105B49
      23B996C564356D8AF93256973210ED16F84EB894F3EBC1F34578CE40E0DBF7DF
      604F3C7B52173EB759C00A4DF2FABD0EF8A63CBB137182E36DD1A50D087461FF
      CCB1BA9452C3CBE9BC32ABB489168CD2AC57FDBD7285C46E6CA258A8602CE0A2
      99A74503CF17E1B9DF8C045E2781531AF8D49A8CC88D245DD403EFB053F7A9C3
      41A54806D26A8644AC10884DB45B95FD25822A974A749C00DF841BDE1167FDB1
      B5BB4D653D2E23256D6174D205A7DB5607CFC350E09B85D7D885E7A655B90AC4
      9653D858CF61F29E41F4F689FA8FCC2A00ABD6794A940A548A65658FCD66A174
      B340ECB16AC575723E9DCC237E334B63A257191BEA379DAAC0FD548D6905C2AF
      B20B1767B6BBB4446F3FD7122853CE4E103CEFD283C0EFAE98AAB97E001BC1D7
      EA39B944E99686AB5F848F7A03D561119E3710F83A3CCB9EBC781A5B725179A9
      71BAED183BE95506663BE16BA7E03DC825788C9FEAA7B12390C0EFFB0B7C157A
      853DF4E824A2FFA530E47761909E2AFBFED2B6185E7D9E083DA136E901303133
      804F3FB96A9442B3CC37E4867FDA0B97C7613EBC6A5B8AC9C8240BF8FEC7E5FD
      05BE9C7F993D75E9DE9D8B760ABCBA6D21F4474D208ABDEFC45FCCBDC49E7EFE
      4CC7C2F3301608BEA808742AFC1D053E0FBEC0A4DB3236E5023A3948E0015A45
      3402B36FBFDB43ABE35406A8581B38773B8277C716B6DF89D37B0538349FD772
      914EFEDFB444254725AF8124094B15BE93059499D387EFBD53E964C8034557C0
      ECB8EB05FE07B76405B47374352D0000000049454E44AE426082}
    Visible = False
  end
  object AlertTimer: TTimer
    Enabled = False
    Interval = 7000
    OnTimer = AlertTimerTimer
    Left = 8
    Top = 8
  end
end
