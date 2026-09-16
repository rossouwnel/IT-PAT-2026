object frmProducts: TfrmProducts
  Left = 0
  Top = 0
  Caption = 'Fresh Count - Geregte en resepte'
  ClientHeight = 700
  ClientWidth = 1080
  Color = 15397365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmGeregte
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1080
    Height = 92
    Align = alTop
    BevelOuter = bvNone
    Color = 2636328
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 30
      Top = 25
      Width = 650
      Height = 42
      AutoSize = False
      Caption = 'Geregte en resepte'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 932
      Top = 26
      Width = 116
      Height = 36
      Caption = 'Terug'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object grdGeregte: TStringGrid
    Left = 24
    Top = 112
    Width = 1032
    Height = 220
    ColCount = 5
    DefaultRowHeight = 24
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 1
    OnSelectCell = grdGeregteSelectCell
    ColWidths = (
      55
      300
      160
      160
      300)
  end
  object grpGereg: TGroupBox
    Left = 24
    Top = 350
    Width = 430
    Height = 318
    Caption = ' Nuwe gereg '
    TabOrder = 2
    object lblGeregNaam: TLabel
      Left = 24
      Top = 34
      Width = 65
      Height = 15
      Caption = 'Geregnaam'
    end
    object lblVerkoopPrys: TLabel
      Left = 24
      Top = 94
      Width = 72
      Height = 15
      Caption = 'Verkoopprys'
    end
    object edtGeregNaam: TEdit
      Left = 24
      Top = 55
      Width = 376
      Height = 23
      MaxLength = 50
      TabOrder = 0
    end
    object edtVerkoopPrys: TEdit
      Left = 24
      Top = 115
      Width = 180
      Height = 23
      TabOrder = 1
    end
    object btnVoegGeregBy: TButton
      Left = 24
      Top = 168
      Width = 180
      Height = 36
      Caption = 'Voeg gereg by'
      TabOrder = 2
      OnClick = btnVoegGeregByClick
    end
    object btnDeaktiveerGereg: TButton
      Left = 220
      Top = 168
      Width = 180
      Height = 36
      Caption = 'Deaktiveer gekose gereg'
      TabOrder = 3
      OnClick = btnDeaktiveerGeregClick
    end
  end
  object grpResep: TGroupBox
    Left = 472
    Top = 350
    Width = 584
    Height = 318
    Caption = ' Resep vir gekose gereg '
    TabOrder = 3
    object lblBestanddeel: TLabel
      Left = 18
      Top = 28
      Width = 71
      Height = 15
      Caption = 'Bestanddeel'
    end
    object lblBenodig: TLabel
      Left = 312
      Top = 28
      Width = 116
      Height = 15
      Caption = 'Hoeveelheid benodig'
    end
    object lblKoste: TLabel
      Left = 18
      Top = 278
      Width = 230
      Height = 20
      AutoSize = False
      Caption = 'Resepkoste: R 0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBeskikbaar: TLabel
      Left = 250
      Top = 278
      Width = 312
      Height = 20
      AutoSize = False
      Caption = 'Status: Onvoldoende voorraad of geen resep'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cboBestanddeel: TComboBox
      Left = 18
      Top = 49
      Width = 276
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object edtBenodig: TEdit
      Left = 312
      Top = 49
      Width = 138
      Height = 23
      TabOrder = 1
    end
    object btnVoegBestanddeelBy: TButton
      Left = 466
      Top = 45
      Width = 98
      Height = 32
      Caption = 'Voeg/werk by'
      TabOrder = 2
      OnClick = btnVoegBestanddeelByClick
    end
    object grdResep: TStringGrid
      Left = 18
      Top = 92
      Width = 546
      Height = 132
      ColCount = 3
      DefaultRowHeight = 23
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 3
      OnSelectCell = grdResepSelectCell
      ColWidths = (
        75
        280
        170)
    end
    object btnVerwyderBestanddeel: TButton
      Left = 384
      Top = 232
      Width = 180
      Height = 32
      Caption = 'Verwyder uit resep'
      TabOrder = 4
      OnClick = btnVerwyderBestanddeelClick
    end
  end
  object mmGeregte: TMainMenu
    Left = 1016
    Top = 104
    object mnuLeer: TMenuItem
      Caption = '&Program'
      object mnuTerug: TMenuItem
        Caption = '&Terug'
        OnClick = btnCloseClick
      end
    end
    object mnuGeregte: TMenuItem
      Caption = '&Geregte'
      object mnuNuweGereg: TMenuItem
        Caption = '&Voeg nuwe gereg by'
        OnClick = btnVoegGeregByClick
      end
      object mnuDeaktiveerGereg: TMenuItem
        Caption = '&Deaktiveer gekose gereg'
        OnClick = btnDeaktiveerGeregClick
      end
    end
    object mnuResep: TMenuItem
      Caption = '&Resep'
      object mnuVoegBestanddeel: TMenuItem
        Caption = '&Voeg of werk bestanddeel by'
        OnClick = btnVoegBestanddeelByClick
      end
      object mnuVerwyderBestanddeel: TMenuItem
        Caption = '&Verwyder gekose bestanddeel'
        OnClick = btnVerwyderBestanddeelClick
      end
    end
  end
end
