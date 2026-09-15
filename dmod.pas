unit dmod;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDSGebruikers = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADOBestanddele: TADOTable;
    ADOGeregBestanddeel: TADOTable;
    ADOGeregte: TADOTable;
    ADOVerkope: TADOTable;
    ADOGebruikers: TADOTable;
    DSBestanddele: TDataSource;
    DSGeregBestanddeel: TDataSource;
    DSGeregte: TDataSource;
    DSVerkope: TDataSource;
    DSGebruikers: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DSGebruikers: TDSGebruikers;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
