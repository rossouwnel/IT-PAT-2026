object dmDatabase: TdmDatabase
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 375
  Width = 650
  PixelsPerInch = 120
  object conDatabase: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 60
    Top = 40
  end
  object tblGebruikers: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblGebruikers'
    Left = 60
    Top = 130
  end
  object tblBestanddele: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblBestanddele'
    Left = 190
    Top = 130
  end
  object tblGeregte: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblGeregte'
    Left = 340
    Top = 130
  end
  object tblGeregBestanddele: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblGeregBestanddele'
    Left = 460
    Top = 130
  end
  object tblVerkope: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblVerkope'
    Left = 60
    Top = 230
  end
end
