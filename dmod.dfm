object DSGebruikers: TDSGebruikers
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=C:\Gi' +
      't\IT PAT 2026\Database.mdb;Mode=ReadWrite;Persist Security Info=' +
      'False;Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Je' +
      't OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:D' +
      'atabase Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet O' +
      'LEDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password=' +
      '"";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Data' +
      'base=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False;Jet OLED' +
      'B:Compact Without Replica Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 296
    Top = 40
  end
  object ADOBestanddele: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    MasterSource = DSBestanddele
    TableName = 'tblBestanddele'
    Left = 232
    Top = 120
  end
  object ADOGeregBestanddeel: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    MasterSource = DSGeregBestanddeel
    TableName = 'tblGeregBestanddele'
    Left = 232
    Top = 192
  end
  object ADOGeregte: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    MasterSource = DSGeregte
    TableName = 'tblGeregte'
    Left = 232
    Top = 264
  end
  object ADOVerkope: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    MasterSource = DSVerkope
    TableName = 'tblVerkope'
    Left = 232
    Top = 336
  end
  object ADOGebruikers: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    MasterSource = DSGebruikers
    TableName = 'tblGebruikers'
    Left = 232
    Top = 408
  end
  object DSBestanddele: TDataSource
    Left = 352
    Top = 120
  end
  object DSGeregBestanddeel: TDataSource
    Left = 352
    Top = 192
  end
  object DSGeregte: TDataSource
    Left = 360
    Top = 264
  end
  object DSVerkope: TDataSource
    Left = 360
    Top = 336
  end
  object DSGebruikers: TDataSource
    Left = 360
    Top = 408
  end
end
