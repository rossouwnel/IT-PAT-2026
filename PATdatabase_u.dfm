object dmDatabase: TdmDatabase
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 300
  Width = 520
  object conDatabase: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 48
    Top = 32
  end
  object tblGebruikers: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblGebruikers'
    Left = 48
    Top = 104
  end
  object tblBestanddele: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblBestanddele'
    Left = 152
    Top = 104
  end
  object tblGeregte: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblGeregte'
    Left = 272
    Top = 104
  end
  object tblGeregBestanddele: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblGeregBestanddele'
    Left = 368
    Top = 104
  end
  object tblVerkope: TADOTable
    Connection = conDatabase
    CursorType = ctStatic
    TableName = 'tblVerkope'
    Left = 48
    Top = 184
  end
end
