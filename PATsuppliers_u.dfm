object frmSuppliers: TfrmSuppliers
  Left = 0
  Top = 0
  Caption = 'Fresh Count - Verkope'
  ClientHeight = 670
  ClientWidth = 980
  Color = 15397365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmVerkope
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 92
    Align = alTop
    BevelOuter = bvNone
    Color = 2636328
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 30
      Top = 25
      Width = 600
      Height = 42
      AutoSize = False
      Caption = 'Verkope en bestellings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 832
      Top = 26
      Width = 116
      Height = 36
      Caption = 'Terug'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object lblKies: TLabel
    Left = 28
    Top = 112
    Width = 230
    Height = 20
    Caption = 'Kies ''n beskikbare gereg:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblAantal: TLabel
    Left = 572
    Top = 112
    Width = 38
    Height = 15
    Caption = 'Aantal'
  end
  object lblVerkope: TLabel
    Left = 28
    Top = 368
    Width = 170
    Height = 20
    Caption = 'Aangetekende verkope:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grdGeregte: TStringGrid
    Left = 28
    Top = 140
    Width = 924
    Height = 190
    ColCount = 4
    DefaultRowHeight = 24
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 1
    OnSelectCell = grdGeregteSelectCell
    ColWidths = (
      60
      410
      150
      270)
  end
  object edtAantal: TEdit
    Left = 620
    Top = 108
    Width = 90
    Height = 23
    TabOrder = 2
    Text = '1'
  end
  object btnVerkoop: TButton
    Left = 728
    Top = 104
    Width = 224
    Height = 32
    Caption = 'Teken verkoop aan'
    TabOrder = 3
    OnClick = btnVerkoopClick
  end
  object grdVerkope: TStringGrid
    Left = 28
    Top = 396
    Width = 924
    Height = 242
    ColCount = 5
    DefaultRowHeight = 24
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 4
    ColWidths = (
      190
      300
      100
      145
      145)
  end
  object mmVerkope: TMainMenu
    Left = 912
    Top = 104
    object mnuLeer: TMenuItem
      Caption = '&Program'
      object mnuTerug: TMenuItem
        Caption = '&Terug'
        OnClick = btnCloseClick
      end
    end
    object mnuVerkope: TMenuItem
      Caption = '&Verkope'
      object mnuTekenVerkoopAan: TMenuItem
        Caption = '&Teken gekose verkoop aan'
        OnClick = btnVerkoopClick
      end
      object mnuVerfris: TMenuItem
        Caption = 'V&erfris lyste'
        OnClick = mnuVerfrisClick
      end
    end
  end
end
