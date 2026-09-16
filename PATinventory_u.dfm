object frmInventory: TfrmInventory
  Left = 0
  Top = 0
  Caption = 'Fresh Count - Bestanddele en voorraad'
  ClientHeight = 650
  ClientWidth = 980
  Color = 15397365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmVoorraad
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 96
    Align = alTop
    BevelOuter = bvNone
    Color = 2636328
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 32
      Top = 27
      Width = 600
      Height = 42
      AutoSize = False
      Caption = 'Bestanddele en voorraad'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 832
      Top = 28
      Width = 116
      Height = 36
      Caption = 'Terug'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object lblSearch: TLabel
    Left = 28
    Top = 116
    Width = 36
    Height = 15
    Caption = 'Soek:'
  end
  object edtSearch: TEdit
    Left = 76
    Top = 111
    Width = 524
    Height = 23
    TabOrder = 1
    TextHint = 'Tik ''n bestanddeelnaam...'
    OnChange = edtSearchChange
  end
  object grdVoorraad: TStringGrid
    Left = 28
    Top = 152
    Width = 924
    Height = 266
    ColCount = 7
    DefaultRowHeight = 24
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 2
    OnSelectCell = grdVoorraadSelectCell
    ColWidths = (
      48
      210
      100
      120
      130
      110
      130)
  end
  object grpBesonderhede: TGroupBox
    Left = 28
    Top = 438
    Width = 924
    Height = 184
    Caption = ' Bestanddeelbesonderhede '
    TabOrder = 3
    object lblNaam: TLabel
      Left = 20
      Top = 29
      Width = 34
      Height = 15
      Caption = 'Naam'
    end
    object lblEenheid: TLabel
      Left = 270
      Top = 29
      Width = 44
      Height = 15
      Caption = 'Eenheid'
    end
    object lblHoeveelheid: TLabel
      Left = 440
      Top = 29
      Width = 71
      Height = 15
      Caption = 'Hoeveelheid'
    end
    object lblKoste: TLabel
      Left = 610
      Top = 29
      Width = 84
      Height = 15
      Caption = 'Eenheidskoste'
    end
    object lblMinimum: TLabel
      Left = 766
      Top = 29
      Width = 51
      Height = 15
      Caption = 'Minimum'
    end
    object edtNaam: TEdit
      Left = 20
      Top = 50
      Width = 230
      Height = 23
      MaxLength = 50
      TabOrder = 0
    end
    object edtEenheid: TEdit
      Left = 270
      Top = 50
      Width = 150
      Height = 23
      MaxLength = 10
      TabOrder = 1
    end
    object edtHoeveelheid: TEdit
      Left = 440
      Top = 50
      Width = 150
      Height = 23
      TabOrder = 2
    end
    object edtKoste: TEdit
      Left = 610
      Top = 50
      Width = 136
      Height = 23
      TabOrder = 3
    end
    object edtMinimum: TEdit
      Left = 766
      Top = 50
      Width = 136
      Height = 23
      TabOrder = 4
    end
    object btnVoegBy: TButton
      Left = 20
      Top = 105
      Width = 140
      Height = 36
      Caption = 'Voeg by'
      TabOrder = 5
      OnClick = btnVoegByClick
    end
    object btnWysig: TButton
      Left = 176
      Top = 105
      Width = 140
      Height = 36
      Caption = 'Wysig'
      TabOrder = 6
      OnClick = btnWysigClick
    end
    object btnVerwyder: TButton
      Left = 332
      Top = 105
      Width = 140
      Height = 36
      Caption = 'Deaktiveer'
      TabOrder = 7
      OnClick = btnVerwyderClick
    end
    object btnMaakSkoon: TButton
      Left = 488
      Top = 105
      Width = 140
      Height = 36
      Caption = 'Maak skoon'
      TabOrder = 8
      OnClick = btnMaakSkoonClick
    end
  end
  object mmVoorraad: TMainMenu
    Left = 912
    Top = 104
    object mnuLeer: TMenuItem
      Caption = '&Program'
      object mnuTerug: TMenuItem
        Caption = '&Terug'
        OnClick = btnCloseClick
      end
    end
    object mnuVoorraad: TMenuItem
      Caption = '&Voorraad'
      object mnuVoegBy: TMenuItem
        Caption = '&Voeg bestanddeel by'
        OnClick = btnVoegByClick
      end
      object mnuWysig: TMenuItem
        Caption = '&Wysig gekose bestanddeel'
        OnClick = btnWysigClick
      end
      object mnuVerwyder: TMenuItem
        Caption = '&Deaktiveer gekose bestanddeel'
        OnClick = btnVerwyderClick
      end
    end
  end
end
