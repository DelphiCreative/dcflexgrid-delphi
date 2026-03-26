object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'DCGrid Showcase Demo'
  ClientHeight = 1055
  ClientWidth = 1178
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1178
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1176
    object lblTitle: TLabel
      Left = 16
      Top = 10
      Width = 322
      Height = 21
      Caption = 'DCGrid Showcase - SQLite + Runtime Studio'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object lblSubTitle: TLabel
      Left = 16
      Top = 32
      Width = 264
      Height = 13
      Caption = 'Projeto original de Diego Cataneo / Delphi Creative'
    end
  end
  object pnlSidebar: TPanel
    Left = 0
    Top = 56
    Width = 276
    Height = 999
    Align = alLeft
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 1
    ExplicitHeight = 991
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 276
      Height = 999
      ActivePage = tsTheme
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 991
      object tsBehavior: TTabSheet
        Caption = 'Behavior'
        object lblSearch: TLabel
          Left = 12
          Top = 12
          Width = 30
          Height = 13
          Caption = 'Busca'
        end
        object lblFilterMode: TLabel
          Left = 12
          Top = 64
          Width = 56
          Height = 13
          Caption = 'FilterMode'
        end
        object lblSearchScope: TLabel
          Left = 136
          Top = 64
          Width = 65
          Height = 13
          Caption = 'SearchScope'
        end
        object lblRowHeight: TLabel
          Left = 12
          Top = 294
          Width = 70
          Height = 13
          Caption = 'RowHeight: 0'
        end
        object lblHeaderHeight: TLabel
          Left = 12
          Top = 344
          Width = 84
          Height = 13
          Caption = 'HeaderHeight: 0'
        end
        object lblDetailRowHeight: TLabel
          Left = 12
          Top = 394
          Width = 100
          Height = 13
          Caption = 'DetailRowHeight: 0'
        end
        object lblDetailHeaderHeight: TLabel
          Left = 12
          Top = 444
          Width = 114
          Height = 13
          Caption = 'DetailHeaderHeight: 0'
        end
        object lblDetailStyle: TLabel
          Left = 12
          Top = 494
          Width = 54
          Height = 13
          Caption = 'DetailStyle'
        end
        object lblExpandMode: TLabel
          Left = 124
          Top = 494
          Width = 68
          Height = 13
          Caption = 'ExpandMode'
        end
        object edtSearch: TEdit
          Left = 12
          Top = 32
          Width = 232
          Height = 21
          TabOrder = 0
          TextHint = 'Buscar no master ou detail'
          OnChange = edtSearchChange
        end
        object cbFilterMode: TComboBox
          Left = 12
          Top = 84
          Width = 108
          Height = 21
          Style = csDropDownList
          TabOrder = 1
        end
        object cbSearchScope: TComboBox
          Left = 136
          Top = 84
          Width = 108
          Height = 21
          Style = csDropDownList
          TabOrder = 2
        end
        object chkAutoExpandSearch: TCheckBox
          Left = 12
          Top = 120
          Width = 150
          Height = 17
          Caption = 'AutoExpandOnSearch'
          TabOrder = 3
          OnClick = chkAutoExpandSearchClick
        end
        object chkExpandOnRowClick: TCheckBox
          Left = 12
          Top = 144
          Width = 150
          Height = 17
          Caption = 'ExpandOnRowClick'
          TabOrder = 4
          OnClick = GenericSettingClick
        end
        object chkAlternateColors: TCheckBox
          Left = 12
          Top = 168
          Width = 150
          Height = 17
          Caption = 'AlternateColors'
          TabOrder = 5
          OnClick = GenericSettingClick
        end
        object chkShowHeader: TCheckBox
          Left = 12
          Top = 192
          Width = 150
          Height = 17
          Caption = 'ShowHeader'
          TabOrder = 6
          OnClick = GenericSettingClick
        end
        object chkShowExpandButton: TCheckBox
          Left = 12
          Top = 216
          Width = 150
          Height = 17
          Caption = 'ShowExpandButton'
          TabOrder = 7
          OnClick = GenericSettingClick
        end
        object chkAllowSort: TCheckBox
          Left = 12
          Top = 240
          Width = 150
          Height = 17
          Caption = 'AllowColumnSort'
          TabOrder = 8
          OnClick = GenericSettingClick
        end
        object chkBusinessHighlight: TCheckBox
          Left = 12
          Top = 264
          Width = 170
          Height = 17
          Caption = 'Business highlight'
          TabOrder = 9
          OnClick = GenericSettingClick
        end
        object tbRowHeight: TTrackBar
          Left = 12
          Top = 312
          Width = 232
          Height = 28
          Max = 56
          Min = 24
          Frequency = 4
          Position = 34
          TabOrder = 10
          OnChange = TrackBarChange
        end
        object tbHeaderHeight: TTrackBar
          Left = 12
          Top = 362
          Width = 232
          Height = 28
          Max = 60
          Min = 28
          Frequency = 4
          Position = 38
          TabOrder = 11
          OnChange = TrackBarChange
        end
        object tbDetailRowHeight: TTrackBar
          Left = 12
          Top = 412
          Width = 232
          Height = 28
          Max = 40
          Min = 18
          Frequency = 2
          Position = 24
          TabOrder = 12
          OnChange = TrackBarChange
        end
        object tbDetailHeaderHeight: TTrackBar
          Left = 12
          Top = 462
          Width = 232
          Height = 28
          Max = 44
          Min = 22
          Frequency = 2
          Position = 28
          TabOrder = 13
          OnChange = TrackBarChange
        end
        object cbDetailStyle: TComboBox
          Left = 12
          Top = 512
          Width = 90
          Height = 21
          Style = csDropDownList
          TabOrder = 14
          OnChange = cbDetailStyleChange
        end
        object cbExpandMode: TComboBox
          Left = 124
          Top = 512
          Width = 90
          Height = 21
          Style = csDropDownList
          TabOrder = 15
          OnChange = cbExpandModeChange
        end
      end
      object tsTheme: TTabSheet
        Caption = 'Theme'
        object sbTheme: TScrollBox
          Left = 0
          Top = 0
          Width = 268
          Height = 971
          HorzScrollBar.Visible = False
          VertScrollBar.Tracking = True
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object lblThemeColors: TLabel
            Left = 12
            Top = 36
            Width = 166
            Height = 13
            Caption = 'Theme colors + free color dialog'
          end
          object lblHeaderColor: TLabel
            Left = 12
            Top = 60
            Width = 65
            Height = 13
            Caption = 'HeaderColor'
          end
          object lblHeaderColorHex: TLabel
            Left = 172
            Top = 82
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblRowColor: TLabel
            Left = 12
            Top = 106
            Width = 51
            Height = 13
            Caption = 'RowColor'
          end
          object lblRowColorHex: TLabel
            Left = 172
            Top = 128
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblAltRowColor: TLabel
            Left = 12
            Top = 152
            Width = 75
            Height = 13
            Caption = 'AlternateColor'
          end
          object lblAltRowColorHex: TLabel
            Left = 172
            Top = 174
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblHoverColor: TLabel
            Left = 12
            Top = 198
            Width = 58
            Height = 13
            Caption = 'HoverColor'
          end
          object lblHoverColorHex: TLabel
            Left = 172
            Top = 220
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblSelectedColor: TLabel
            Left = 12
            Top = 244
            Width = 71
            Height = 13
            Caption = 'SelectedColor'
          end
          object lblSelectedColorHex: TLabel
            Left = 172
            Top = 266
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblSelectedTextColor: TLabel
            Left = 12
            Top = 290
            Width = 90
            Height = 13
            Caption = 'SelectedTextColor'
          end
          object lblSelectedTextColorHex: TLabel
            Left = 172
            Top = 312
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblSearchHighlightColor: TLabel
            Left = 12
            Top = 336
            Width = 111
            Height = 13
            Caption = 'SearchHighlightColor'
          end
          object lblSearchHighlightColorHex: TLabel
            Left = 172
            Top = 358
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblSearchHighlightTextColor: TLabel
            Left = 12
            Top = 382
            Width = 130
            Height = 13
            Caption = 'SearchHighlightTextColor'
          end
          object lblSearchHighlightTextColorHex: TLabel
            Left = 172
            Top = 404
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailColor: TLabel
            Left = 12
            Top = 520
            Width = 58
            Height = 13
            Caption = 'DetailColor'
          end
          object lblDetailColorHex: TLabel
            Left = 172
            Top = 450
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblTextColor: TLabel
            Left = 12
            Top = 474
            Width = 47
            Height = 13
            Caption = 'TextColor'
          end
          object lblTextColorHex: TLabel
            Left = 172
            Top = 496
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblHeaderFontColor: TLabel
            Left = 12
            Top = 520
            Width = 89
            Height = 13
            Caption = 'HeaderFontColor'
          end
          object lblHeaderFontColorHex: TLabel
            Left = 172
            Top = 542
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblGridBackgroundColor: TLabel
            Left = 12
            Top = 566
            Width = 113
            Height = 13
            Caption = 'GridBackgroundColor'
          end
          object lblGridBackgroundColorHex: TLabel
            Left = 172
            Top = 588
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblBorderColor: TLabel
            Left = 12
            Top = 612
            Width = 63
            Height = 13
            Caption = 'BorderColor'
          end
          object lblBorderColorHex: TLabel
            Left = 172
            Top = 634
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailBorderColor: TLabel
            Left = 12
            Top = 658
            Width = 93
            Height = 13
            Caption = 'DetailBorderColor'
          end
          object lblDetailBorderColorHex: TLabel
            Left = 172
            Top = 680
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailTextColor: TLabel
            Left = 12
            Top = 704
            Width = 77
            Height = 13
            Caption = 'DetailTextColor'
          end
          object lblDetailTextColorHex: TLabel
            Left = 172
            Top = 726
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblExpandButtonColor: TLabel
            Left = 12
            Top = 750
            Width = 102
            Height = 13
            Caption = 'ExpandButtonColor'
          end
          object lblExpandButtonColorHex: TLabel
            Left = 172
            Top = 772
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailGridHeaderColor: TLabel
            Left = 12
            Top = 796
            Width = 117
            Height = 13
            Caption = 'DetailGridHeaderColor'
          end
          object lblDetailGridHeaderColorHex: TLabel
            Left = 172
            Top = 818
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailGridHeaderFontColor: TLabel
            Left = 12
            Top = 842
            Width = 141
            Height = 13
            Caption = 'DetailGridHeaderFontColor'
          end
          object lblDetailGridHeaderFontColorHex: TLabel
            Left = 172
            Top = 864
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailGridRowColor: TLabel
            Left = 12
            Top = 888
            Width = 103
            Height = 13
            Caption = 'DetailGridRowColor'
          end
          object lblDetailGridRowColorHex: TLabel
            Left = 172
            Top = 910
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailGridAltColor: TLabel
            Left = 12
            Top = 934
            Width = 117
            Height = 13
            Caption = 'DetailGridAltRowColor'
          end
          object lblDetailGridAltColorHex: TLabel
            Left = 172
            Top = 956
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object lblDetailGridLineColor: TLabel
            Left = 12
            Top = 980
            Width = 101
            Height = 13
            Caption = 'DetailGridLineColor'
          end
          object lblDetailGridLineColorHex: TLabel
            Left = 172
            Top = 1002
            Width = 54
            Height = 13
            Caption = '$00000000'
          end
          object cbxSearchHighlightColor: TColorBox
            Left = 12
            Top = 354
            Width = 100
            Height = 22
            TabOrder = 58
          end
          object btnSearchHighlightColor: TButton
            Left = 116
            Top = 354
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 59
            OnClick = btnThemeChooseClick
          end
          object shpSearchHighlightColor: TPanel
            Left = 146
            Top = 354
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 60
          end
          object cbxSearchHighlightTextColor: TColorBox
            Left = 12
            Top = 400
            Width = 100
            Height = 22
            TabOrder = 61
          end
          object btnSearchHighlightTextColor: TButton
            Left = 116
            Top = 400
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 62
            OnClick = btnThemeChooseClick
          end
          object shpSearchHighlightTextColor: TPanel
            Left = 146
            Top = 400
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 63
          end
          object chkDarkTheme: TCheckBox
            Left = 12
            Top = 12
            Width = 150
            Height = 17
            Caption = 'Dark theme'
            TabOrder = 0
            OnClick = GenericSettingClick
          end
          object cbxHeaderColor: TColorBox
            Left = 12
            Top = 78
            Width = 100
            Height = 22
            TabOrder = 1
          end
          object btnHeaderColor: TButton
            Left = 116
            Top = 78
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 2
            OnClick = btnThemeChooseClick
          end
          object shpHeaderColor: TPanel
            Left = 146
            Top = 78
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 3
          end
          object cbxRowColor: TColorBox
            Left = 12
            Top = 124
            Width = 100
            Height = 22
            TabOrder = 4
          end
          object btnRowColor: TButton
            Left = 116
            Top = 124
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 5
            OnClick = btnThemeChooseClick
          end
          object shpRowColor: TPanel
            Left = 146
            Top = 124
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 6
          end
          object cbxAltRowColor: TColorBox
            Left = 12
            Top = 170
            Width = 100
            Height = 22
            TabOrder = 7
          end
          object btnAltRowColor: TButton
            Left = 116
            Top = 170
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 8
            OnClick = btnThemeChooseClick
          end
          object shpAltRowColor: TPanel
            Left = 146
            Top = 170
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 9
          end
          object cbxHoverColor: TColorBox
            Left = 12
            Top = 216
            Width = 100
            Height = 22
            TabOrder = 10
          end
          object btnHoverColor: TButton
            Left = 116
            Top = 216
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 11
            OnClick = btnThemeChooseClick
          end
          object shpHoverColor: TPanel
            Left = 146
            Top = 216
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 12
          end
          object cbxSelectedColor: TColorBox
            Left = 12
            Top = 262
            Width = 100
            Height = 22
            TabOrder = 13
          end
          object btnSelectedColor: TButton
            Left = 116
            Top = 262
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 14
            OnClick = btnThemeChooseClick
          end
          object shpSelectedColor: TPanel
            Left = 146
            Top = 262
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 15
          end
          object cbxSelectedTextColor: TColorBox
            Left = 12
            Top = 308
            Width = 100
            Height = 22
            TabOrder = 16
          end
          object btnSelectedTextColor: TButton
            Left = 116
            Top = 308
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 17
            OnClick = btnThemeChooseClick
          end
          object shpSelectedTextColor: TPanel
            Left = 146
            Top = 308
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 18
          end
          object cbxDetailColor: TColorBox
            Left = 12
            Top = 446
            Width = 100
            Height = 22
            TabOrder = 19
          end
          object btnDetailColor: TButton
            Left = 116
            Top = 446
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 20
            OnClick = btnThemeChooseClick
          end
          object shpDetailColor: TPanel
            Left = 146
            Top = 446
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 21
          end
          object cbxTextColor: TColorBox
            Left = 12
            Top = 492
            Width = 100
            Height = 22
            TabOrder = 22
          end
          object btnTextColor: TButton
            Left = 116
            Top = 492
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 23
            OnClick = btnThemeChooseClick
          end
          object shpTextColor: TPanel
            Left = 146
            Top = 492
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 24
          end
          object cbxHeaderFontColor: TColorBox
            Left = 12
            Top = 538
            Width = 100
            Height = 22
            TabOrder = 25
          end
          object btnHeaderFontColor: TButton
            Left = 116
            Top = 538
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 26
            OnClick = btnThemeChooseClick
          end
          object shpHeaderFontColor: TPanel
            Left = 146
            Top = 538
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 27
          end
          object cbxGridBackgroundColor: TColorBox
            Left = 12
            Top = 584
            Width = 100
            Height = 22
            TabOrder = 28
          end
          object btnGridBackgroundColor: TButton
            Left = 116
            Top = 584
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 29
            OnClick = btnThemeChooseClick
          end
          object shpGridBackgroundColor: TPanel
            Left = 146
            Top = 584
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 30
          end
          object cbxBorderColor: TColorBox
            Left = 12
            Top = 630
            Width = 100
            Height = 22
            TabOrder = 31
          end
          object btnBorderColor: TButton
            Left = 116
            Top = 630
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 32
            OnClick = btnThemeChooseClick
          end
          object shpBorderColor: TPanel
            Left = 146
            Top = 630
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 33
          end
          object cbxDetailBorderColor: TColorBox
            Left = 12
            Top = 676
            Width = 100
            Height = 22
            TabOrder = 34
          end
          object btnDetailBorderColor: TButton
            Left = 116
            Top = 676
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 35
            OnClick = btnThemeChooseClick
          end
          object shpDetailBorderColor: TPanel
            Left = 146
            Top = 676
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 36
          end
          object cbxDetailTextColor: TColorBox
            Left = 12
            Top = 722
            Width = 100
            Height = 22
            TabOrder = 37
          end
          object btnDetailTextColor: TButton
            Left = 116
            Top = 722
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 38
            OnClick = btnThemeChooseClick
          end
          object shpDetailTextColor: TPanel
            Left = 146
            Top = 722
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 39
          end
          object cbxExpandButtonColor: TColorBox
            Left = 12
            Top = 768
            Width = 100
            Height = 22
            TabOrder = 40
          end
          object btnExpandButtonColor: TButton
            Left = 116
            Top = 768
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 41
            OnClick = btnThemeChooseClick
          end
          object shpExpandButtonColor: TPanel
            Left = 146
            Top = 768
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 42
          end
          object cbxDetailGridHeaderColor: TColorBox
            Left = 12
            Top = 814
            Width = 100
            Height = 22
            TabOrder = 43
          end
          object btnDetailGridHeaderColor: TButton
            Left = 116
            Top = 814
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 44
            OnClick = btnThemeChooseClick
          end
          object shpDetailGridHeaderColor: TPanel
            Left = 146
            Top = 814
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 45
          end
          object cbxDetailGridHeaderFontColor: TColorBox
            Left = 12
            Top = 860
            Width = 100
            Height = 22
            TabOrder = 46
          end
          object btnDetailGridHeaderFontColor: TButton
            Left = 116
            Top = 860
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 47
            OnClick = btnThemeChooseClick
          end
          object shpDetailGridHeaderFontColor: TPanel
            Left = 146
            Top = 860
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 48
          end
          object cbxDetailGridRowColor: TColorBox
            Left = 12
            Top = 906
            Width = 100
            Height = 22
            TabOrder = 49
          end
          object btnDetailGridRowColor: TButton
            Left = 116
            Top = 906
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 50
            OnClick = btnThemeChooseClick
          end
          object shpDetailGridRowColor: TPanel
            Left = 146
            Top = 906
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 51
          end
          object cbxDetailGridAltColor: TColorBox
            Left = 12
            Top = 952
            Width = 100
            Height = 22
            TabOrder = 52
          end
          object btnDetailGridAltColor: TButton
            Left = 116
            Top = 952
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 53
            OnClick = btnThemeChooseClick
          end
          object shpDetailGridAltColor: TPanel
            Left = 146
            Top = 952
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 54
          end
          object cbxDetailGridLineColor: TColorBox
            Left = 12
            Top = 998
            Width = 100
            Height = 22
            TabOrder = 55
          end
          object btnDetailGridLineColor: TButton
            Left = 116
            Top = 998
            Width = 26
            Height = 22
            Caption = '...'
            TabOrder = 56
            OnClick = btnThemeChooseClick
          end
          object shpDetailGridLineColor: TPanel
            Left = 146
            Top = 998
            Width = 22
            Height = 22
            BevelOuter = bvLowered
            TabOrder = 57
          end
        end
      end
      object tsAdvanced: TTabSheet
        Caption = 'Advanced'
        object lblDetailHeight: TLabel
          Left = 12
          Top = 68
          Width = 77
          Height = 13
          Caption = 'DetailHeight: 0'
        end
        object lblMinColumnWidth: TLabel
          Left = 12
          Top = 118
          Width = 104
          Height = 13
          Caption = 'MinColumnWidth: 0'
        end
        object lblAdvancedInfo: TLabel
          Left = 12
          Top = 246
          Width = 228
          Height = 36
          AutoSize = False
          Caption = 'Business Highlight V2.9'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblBusinessField: TLabel
          Left = 12
          Top = 310
          Width = 56
          Height = 13
          Caption = 'Field name'
        end
        object lblRuleExpr: TLabel
          Left = 12
          Top = 358
          Width = 48
          Height = 13
          Caption = 'Rule expr'
        end
        object lblRuleBackColor: TLabel
          Left = 12
          Top = 406
          Width = 53
          Height = 13
          Caption = 'Back color'
        end
        object lblRuleFontColor: TLabel
          Left = 134
          Top = 406
          Width = 53
          Height = 13
          Caption = 'Font color'
        end
        object chkDetailSelectEnabled: TCheckBox
          Left = 12
          Top = 12
          Width = 150
          Height = 17
          Caption = 'DetailSelectEnabled'
          TabOrder = 0
          OnClick = GenericSettingClick
        end
        object chkDebugLog: TCheckBox
          Left = 12
          Top = 36
          Width = 150
          Height = 17
          Caption = 'DebugLogEnabled'
          TabOrder = 1
          OnClick = GenericSettingClick
        end
        object tbDetailHeight: TTrackBar
          Left = 12
          Top = 86
          Width = 232
          Height = 28
          Max = 150
          Min = 60
          Frequency = 10
          Position = 84
          TabOrder = 2
          OnChange = TrackBarChange
        end
        object tbMinColumnWidth: TTrackBar
          Left = 12
          Top = 136
          Width = 232
          Height = 28
          Max = 120
          Min = 32
          Frequency = 8
          Position = 48
          TabOrder = 3
          OnChange = TrackBarChange
        end
        object btnApplyRecommended: TButton
          Left = 12
          Top = 178
          Width = 110
          Height = 25
          Caption = 'Recommended'
          TabOrder = 4
          OnClick = btnApplyRecommendedClick
        end
        object btnExpandSelected: TButton
          Left = 130
          Top = 178
          Width = 110
          Height = 25
          Caption = 'Expand selected'
          TabOrder = 5
          OnClick = btnExpandSelectedClick
        end
        object btnCollapseSelected: TButton
          Left = 12
          Top = 210
          Width = 110
          Height = 25
          Caption = 'Collapse selected'
          TabOrder = 6
          OnClick = btnCollapseSelectedClick
        end
        object chkBusinessEngine: TCheckBox
          Left = 12
          Top = 286
          Width = 140
          Height = 17
          Caption = 'BusinessHighlight'
          TabOrder = 7
          OnClick = chkBusinessEngineClick
        end
        object edtBusinessField: TEdit
          Left = 12
          Top = 328
          Width = 232
          Height = 21
          TabOrder = 8
          Text = 'total_value'
        end
        object edtRuleExpr: TEdit
          Left = 12
          Top = 376
          Width = 232
          Height = 21
          TabOrder = 9
          TextHint = '>700, <200, =Pago'
        end
        object cbxRuleBackColor: TColorBox
          Left = 12
          Top = 424
          Width = 110
          Height = 22
          TabOrder = 10
        end
        object cbxRuleFontColor: TColorBox
          Left = 134
          Top = 424
          Width = 110
          Height = 22
          TabOrder = 11
        end
        object btnAddRule: TButton
          Left = 12
          Top = 456
          Width = 72
          Height = 25
          Caption = 'Add rule'
          TabOrder = 12
          OnClick = btnAddRuleClick
        end
        object btnClearRules: TButton
          Left = 90
          Top = 456
          Width = 72
          Height = 25
          Caption = 'Clear'
          TabOrder = 13
          OnClick = btnClearRulesClick
        end
        object btnPresetFinance: TButton
          Left = 168
          Top = 456
          Width = 76
          Height = 25
          Caption = 'Preset'
          TabOrder = 14
          OnClick = btnPresetFinanceClick
        end
        object lstBusinessRules: TListBox
          Left = 12
          Top = 490
          Width = 232
          Height = 180
          ItemHeight = 13
          TabOrder = 15
        end
      end
    end
  end
  object pnlMain: TPanel
    Left = 276
    Top = 56
    Width = 902
    Height = 999
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 900
    ExplicitHeight = 991
    DesignSize = (
      902
      999)
    object lblStatus: TLabel
      Left = 16
      Top = 12
      Width = 32
      Height = 13
      Caption = 'Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3220039
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object btnExpandAll: TButton
      Left = 16
      Top = 34
      Width = 88
      Height = 25
      Caption = 'Expand all'
      TabOrder = 0
      OnClick = btnExpandAllClick
    end
    object btnCollapseAll: TButton
      Left = 110
      Top = 34
      Width = 88
      Height = 25
      Caption = 'Collapse all'
      TabOrder = 1
      OnClick = btnCollapseAllClick
    end
    object btnAutoSize: TButton
      Left = 204
      Top = 34
      Width = 92
      Height = 25
      Caption = 'AutoSize'
      TabOrder = 2
      OnClick = btnAutoSizeClick
    end
    object btnSaveLayout: TButton
      Left = 302
      Top = 34
      Width = 92
      Height = 25
      Caption = 'Save layout'
      TabOrder = 3
      OnClick = btnSaveLayoutClick
    end
    object btnLoadLayout: TButton
      Left = 400
      Top = 34
      Width = 92
      Height = 25
      Caption = 'Load layout'
      TabOrder = 4
      OnClick = btnLoadLayoutClick
    end
    object btnResetLayout: TButton
      Left = 498
      Top = 34
      Width = 92
      Height = 25
      Caption = 'Reset layout'
      TabOrder = 5
      OnClick = btnResetLayoutClick
    end
    object btnExportTheme: TButton
      Left = 596
      Top = 34
      Width = 108
      Height = 25
      Caption = 'Copy theme code'
      TabOrder = 6
      OnClick = btnExportThemeClick
    end
    object DCGrid1: TDCFlexGrid
      Left = 16
      Top = 72
      Width = 870
      Height = 916
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clWhite
      ParentColor = False
      Columns = <>
      DetailColumns = <>
      Theme.HeaderColor = 3357254
      Theme.HeaderFontColor = clWhite
      Theme.GridBackgroundColor = 16514301
      Theme.RowColor = clWhite
      Theme.AlternateRowColor = 16251387
      Theme.HoverRowColor = 16774118
      Theme.SelectedRowColor = 16770501
      Theme.SelectedTextColor = 2764600
      Theme.DetailColor = 15988474
      Theme.BorderColor = 14147046
      Theme.DetailBorderColor = 14739182
      Theme.TextColor = 2764600
      Theme.DetailTextColor = 3226183
      Theme.ExpandButtonColor = 6187644
      Theme.DetailGridHeaderColor = 15331061
      Theme.DetailGridHeaderFontColor = 3226183
      Theme.DetailGridRowColor = clWhite
      Theme.DetailGridAlternateRowColor = 16317180
      Theme.DetailGridLineColor = 14476010
      Theme.SearchHighlightColor = 16774557
      Theme.SearchHighlightTextColor = clBlack
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -15
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = [fsBold]
      DetailFont.Charset = DEFAULT_CHARSET
      DetailFont.Color = 3226183
      DetailFont.Height = -15
      DetailFont.Name = 'Segoe UI'
      DetailFont.Style = []
      DetailStyle = dsGrid
      OnSortColumn = DCGrid1SortColumn
      OnDetailRowClick = DCGrid1DetailRowClick
      OnDetailRowDblClick = DCGrid1DetailRowDblClick
      OnRightClickHitTest = DCGrid1RightClickHitTest
      ExplicitWidth = 868
      ExplicitHeight = 908
    end
    object memThemeCode: TMemo
      Left = 16
      Top = 1056
      Width = 870
      Height = 188
      Anchors = [akLeft, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 7
      WordWrap = False
      ExplicitTop = 1048
      ExplicitWidth = 868
    end
  end
  object FDConnection1: TFDConnection
    LoginPrompt = False
    Left = 1112
    Top = 24
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 1144
    Top = 24
  end
  object qryOrders: TFDQuery
    Connection = FDConnection1
    Left = 1112
    Top = 56
  end
  object qryItems: TFDQuery
    Connection = FDConnection1
    Left = 1144
    Top = 56
  end
  object ColorDialog1: TColorDialog
    Left = 1112
    Top = 88
  end
end
