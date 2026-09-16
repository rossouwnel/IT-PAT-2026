object frmMenu: TfrmMenu
  Left = 0
  Top = 0
  Caption = 'Fresh Count - Hoofkieslys'
  ClientHeight = 570
  ClientWidth = 940
  Color = 15397365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmHoof
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 17
  object pnlSidebar: TPanel
    Left = 0
    Top = 0
    Width = 230
    Height = 570
    Align = alLeft
    BevelOuter = bvNone
    Color = 2636328
    ParentBackground = False
    TabOrder = 0
    object lblBrand: TLabel
      Left = 24
      Top = 28
      Width = 180
      Height = 36
      AutoSize = False
      Caption = 'Fresh Count'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblUser: TLabel
      Left = 24
      Top = 70
      Width = 180
      Height = 38
      AutoSize = False
      Caption = 'Gebruiker'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12632256
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object btnOverview: TButton
      Left = 20
      Top = 126
      Width = 190
      Height = 38
      Caption = 'Oorsig'
      TabOrder = 0
      OnClick = btnOverviewClick
    end
    object btnInventory: TButton
      Left = 20
      Top = 174
      Width = 190
      Height = 38
      Caption = 'Bestanddele en voorraad'
      TabOrder = 1
      OnClick = btnInventoryClick
    end
    object btnProducts: TButton
      Left = 20
      Top = 222
      Width = 190
      Height = 38
      Caption = 'Geregte en resepte'
      TabOrder = 2
      OnClick = btnProductsClick
    end
    object btnSuppliers: TButton
      Left = 20
      Top = 270
      Width = 190
      Height = 38
      Caption = 'Verkope'
      TabOrder = 3
      OnClick = btnSuppliersClick
    end
    object btnReports: TButton
      Left = 20
      Top = 318
      Width = 190
      Height = 38
      Caption = 'Verslae'
      TabOrder = 4
      OnClick = btnReportsClick
    end
    object btnSignOut: TButton
      Left = 20
      Top = 504
      Width = 190
      Height = 38
      Anchors = [akLeft, akBottom]
      Caption = 'Teken uit'
      TabOrder = 5
      OnClick = btnSignOutClick
    end
  end
  object pnlContent: TPanel
    Left = 230
    Top = 0
    Width = 710
    Height = 570
    Align = alClient
    BevelOuter = bvNone
    Color = 15397365
    ParentBackground = False
    TabOrder = 1
    object lblTitle: TLabel
      Left = 42
      Top = 40
      Width = 620
      Height = 46
      AutoSize = False
      Caption = 'Restaurant-oorsig'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2636328
      Font.Height = -32
      Font.Name = 'Georgia'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDescription: TLabel
      Left = 44
      Top = 92
      Width = 620
      Height = 42
      AutoSize = False
      Caption = 'Gebruik die knoppies of die Bestuur-kieslys om voorraad, resepte, verkope en verslae te bestuur.'
      WordWrap = True
    end
    object pnlCard1: TPanel
      Left = 44
      Top = 174
      Width = 190
      Height = 132
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object lblCardValue1: TLabel
        Left = 20
        Top = 20
        Width = 150
        Height = 46
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2636328
        Font.Height = -32
        Font.Name = 'Georgia'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCardCaption1: TLabel
        Left = 20
        Top = 84
        Width = 150
        Height = 30
        AutoSize = False
        Caption = 'Aktiewe bestanddele'
      end
    end
    object pnlCard2: TPanel
      Left = 256
      Top = 174
      Width = 190
      Height = 132
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object lblCardValue2: TLabel
        Left = 20
        Top = 20
        Width = 150
        Height = 46
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4210752
        Font.Height = -32
        Font.Name = 'Georgia'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCardCaption2: TLabel
        Left = 20
        Top = 84
        Width = 150
        Height = 30
        AutoSize = False
        Caption = 'Laevoorraad-items'
      end
    end
    object pnlCard3: TPanel
      Left = 468
      Top = 174
      Width = 190
      Height = 132
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object lblCardValue3: TLabel
        Left = 20
        Top = 20
        Width = 150
        Height = 46
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2636328
        Font.Height = -32
        Font.Name = 'Georgia'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCardCaption3: TLabel
        Left = 20
        Top = 84
        Width = 150
        Height = 30
        AutoSize = False
        Caption = 'Aktiewe geregte'
      end
    end
  end
  object mmHoof: TMainMenu
    Left = 856
    Top = 16
    object mnuLeer: TMenuItem
      Caption = '&Program'
      object mnuTekenUit: TMenuItem
        Caption = '&Teken uit'
        OnClick = btnSignOutClick
      end
      object mnuSluit: TMenuItem
        Caption = '&Sluit program'
        OnClick = mnuSluitClick
      end
    end
    object mnuBestuur: TMenuItem
      Caption = '&Bestuur'
      object mnuOorsig: TMenuItem
        Caption = '&Oorsig'
        OnClick = btnOverviewClick
      end
      object mnuVoorraad: TMenuItem
        Caption = '&Bestanddele en voorraad'
        OnClick = btnInventoryClick
      end
      object mnuGeregte: TMenuItem
        Caption = '&Geregte en resepte'
        OnClick = btnProductsClick
      end
      object mnuVerkope: TMenuItem
        Caption = '&Verkope'
        OnClick = btnSuppliersClick
      end
      object mnuVerslae: TMenuItem
        Caption = 'V&erslae'
        OnClick = btnReportsClick
      end
    end
  end
end
