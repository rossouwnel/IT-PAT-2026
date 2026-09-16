object frmReports: TfrmReports
  Left = 0
  Top = 0
  Caption = 'Fresh Count - Verslae'
  ClientHeight = 640
  ClientWidth = 900
  Color = 15397365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmVerslae
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 900
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
      Caption = 'Verslae'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TButton
      Left = 752
      Top = 26
      Width = 116
      Height = 36
      Caption = 'Terug'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object lblTipe: TLabel
    Left = 28
    Top = 117
    Width = 73
    Height = 15
    Caption = 'Verslagtipe:'
  end
  object cbReportType: TComboBox
    Left = 112
    Top = 112
    Width = 250
    Height = 23
    Style = csDropDownList
    TabOrder = 1
    Items.Strings = (
      'Voorraad en herbestellings'
      'Verkope en wins'
      'Geregte en resepkoste')
  end
  object btnGenereer: TButton
    Left = 384
    Top = 108
    Width = 160
    Height = 32
    Caption = 'Genereer verslag'
    TabOrder = 2
    OnClick = btnGenereerClick
  end
  object btnAflaai: TButton
    Left = 560
    Top = 108
    Width = 308
    Height = 32
    Caption = 'Laai verslag af na teksdokument'
    TabOrder = 3
    OnClick = btnAflaaiClick
  end
  object memVerslag: TMemo
    Left = 28
    Top = 158
    Width = 840
    Height = 450
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
  end
  object dlgStoor: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Teksdokumente (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 824
    Top = 160
  end
  object mmVerslae: TMainMenu
    Left = 824
    Top = 208
    object mnuLeer: TMenuItem
      Caption = '&Program'
      object mnuTerug: TMenuItem
        Caption = '&Terug'
        OnClick = btnCloseClick
      end
    end
    object mnuVerslag: TMenuItem
      Caption = '&Verslag'
      object mnuGenereer: TMenuItem
        Caption = '&Genereer gekose verslag'
        OnClick = btnGenereerClick
      end
      object mnuAflaai: TMenuItem
        Caption = '&Laai af na teksdokument'
        OnClick = btnAflaaiClick
      end
    end
  end
end
