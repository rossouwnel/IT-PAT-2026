object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'Fresh Count - Aanmelding'
  ClientHeight = 560
  ClientWidth = 720
  Color = 15397365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmAanmelding
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 17
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 132
    Align = alTop
    BevelOuter = bvNone
    Color = 2636328
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 36
      Top = 28
      Width = 620
      Height = 46
      AutoSize = False
      Caption = 'Fresh Count'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -35
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitle: TLabel
      Left = 38
      Top = 82
      Width = 600
      Height = 24
      AutoSize = False
      Caption = 'Restaurantvoorraad, resepte en verkope op een plek.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12632256
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object pgcAccount: TPageControl
    Left = 88
    Top = 164
    Width = 544
    Height = 356
    ActivePage = tabTekenIn
    TabOrder = 1
    object tabTekenIn: TTabSheet
      Caption = 'Teken in'
      object lblGebruikersnaam: TLabel
        Left = 56
        Top = 45
        Width = 120
        Height = 17
        Caption = 'Gebruikersnaam'
      end
      object lblWagwoord: TLabel
        Left = 56
        Top = 117
        Width = 77
        Height = 17
        Caption = 'Wagwoord'
      end
      object edtGebruikersnaam: TEdit
        Left = 56
        Top = 68
        Width = 416
        Height = 25
        MaxLength = 30
        TabOrder = 0
      end
      object edtWagwoord: TEdit
        Left = 56
        Top = 140
        Width = 416
        Height = 25
        PasswordChar = '*'
        TabOrder = 1
      end
      object btnTekenIn: TButton
        Left = 56
        Top = 205
        Width = 416
        Height = 42
        Caption = 'TEKEN IN'
        Default = True
        TabOrder = 2
        OnClick = btnTekenInClick
      end
    end
    object tabRegistreer: TTabSheet
      Caption = 'Registreer'
      ImageIndex = 1
      object lblNuweGebruikersnaam: TLabel
        Left = 32
        Top = 22
        Width = 120
        Height = 17
        Caption = 'Gebruikersnaam'
      end
      object lblNuweWagwoord: TLabel
        Left = 32
        Top = 78
        Width = 77
        Height = 17
        Caption = 'Wagwoord'
      end
      object lblBevestig: TLabel
        Left = 280
        Top = 78
        Width = 119
        Height = 17
        Caption = 'Bevestig wagwoord'
      end
      object lblRol: TLabel
        Left = 280
        Top = 22
        Width = 21
        Height = 17
        Caption = 'Rol'
      end
      object edtNuweGebruikersnaam: TEdit
        Left = 32
        Top = 45
        Width = 216
        Height = 25
        MaxLength = 30
        TabOrder = 0
      end
      object cboRol: TComboBox
        Left = 280
        Top = 45
        Width = 216
        Height = 25
        Style = csDropDownList
        TabOrder = 1
        Items.Strings = (
          'Bestuurder'
          'Sjef'
          'Kelner'
          'Eienaar')
      end
      object edtNuweWagwoord: TEdit
        Left = 32
        Top = 101
        Width = 216
        Height = 25
        PasswordChar = '*'
        TabOrder = 2
      end
      object edtBevestig: TEdit
        Left = 280
        Top = 101
        Width = 216
        Height = 25
        PasswordChar = '*'
        TabOrder = 3
      end
      object btnRegistreer: TButton
        Left = 32
        Top = 178
        Width = 464
        Height = 42
        Caption = 'SKEP REKENING'
        TabOrder = 4
        OnClick = btnRegistreerClick
      end
    end
  end
  object mmAanmelding: TMainMenu
    Left = 648
    Top = 152
    object mnuRekening: TMenuItem
      Caption = '&Rekening'
      object mnuTekenIn: TMenuItem
        Caption = '&Teken in'
        OnClick = mnuTekenInClick
      end
      object mnuRegistreer: TMenuItem
        Caption = '&Registreer'
        OnClick = mnuRegistreerClick
      end
      object mnuSluit: TMenuItem
        Caption = '&Sluit'
        OnClick = mnuSluitClick
      end
    end
  end
end
