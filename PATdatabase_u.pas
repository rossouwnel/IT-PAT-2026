unit PATdatabase_u;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Data.DB, Data.Win.ADODB;

const
  MAX_GEREGTE = 30;

type
  TdmDatabase = class(TDataModule)
    conDatabase: TADOConnection;
    tblGebruikers: TADOTable;
    tblBestanddele: TADOTable;
    tblGeregte: TADOTable;
    tblGeregBestanddele: TADOTable;
    tblVerkope: TADOTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function FindDatabase: string;
    function TryOpenProvider(const AProvider: string): Boolean;
    procedure OpenTables;
  public
    CurrentUserID: Integer;
    CurrentUsername: string;
    CurrentRole: string;
    DatabasePath: string;
    LastError: string;
    ProviderName: string;
    arrGeregte: array[1..MAX_GEREGTE] of string;
    GeregAantal: Integer;
    function Authenticate(const AUsername, APassword: string): Boolean;
    function RegisterUser(const AUsername, APassword, ARole: string;
      out AErrorMessage: string): Boolean;
    procedure InitialiseerGeregteArray;
    function BerekenResepKoste(AGeregID: Integer): Currency;
    function IsGeregBeskikbaar(AGeregID, AAantal: Integer): Boolean;
    function BestanddeelNaam(ABestanddeelID: Integer): string;
    function GeregNaam(AGeregID: Integer): string;  
  end;

var
  dmDatabase: TdmDatabase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmDatabase.DataModuleCreate(Sender: TObject);
begin
  LastError := '';
  ProviderName := '';
  CurrentUserID := 0;
  DatabasePath := 'C:\Git\IT PAT 2026\Database.mdb';
  if DatabasePath = '' then
  begin
    LastError := 'Database.mdb kon nie gevind word nie.';
    Exit;
  end;
  if not TryOpenProvider('Microsoft.Jet.OLEDB.4.0') then
      LastError := 'Geen geskikte Microsoft Access-verskaffer is gevind nie. Bou die projek as Win32.';
      Exit;
  try
    OpenTables;
    InitialiseerGeregteArray;
  except
    on E: Exception do // Easier to ask for forgive than to ask permission
      LastError := 'Die Access-databasis kon nie oopgemaak word nie: ' + E.Message;
  end;
end;

procedure TdmDatabase.DataModuleDestroy(Sender: TObject);
begin
  tblVerkope.Close;
  tblGeregBestanddele.Close;
  tblGeregte.Close;
  tblBestanddele.Close;
  tblGebruikers.Close;
  conDatabase.Close;
end;


function TdmDatabase.TryOpenProvider(const AProvider: string): Boolean;
begin
  try
    conDatabase.Close;
    conDatabase.ConnectionString := 'Provider=' + AProvider + ';Data Source=' +
      DatabasePath + ';Persist Security Info=False;';
    conDatabase.Open;
    FProviderName := AProvider;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TdmDatabase.OpenTables;
begin
  tblGebruikers.Open;
  tblBestanddele.Open;
  tblGeregte.Open;
  tblGeregBestanddele.Open;
  tblVerkope.Open;
end;

function TdmDatabase.Authenticate(const AUsername, APassword: string): Boolean;
begin
  Result := False;
  LastError := '';
  CurrentUserID := 0;
  CurrentUsername := '';
  CurrentRole := '';
  if not conDatabase.Connected then
  begin
    LastError := 'Daar is geen verbinding met die databasis nie.';
    Exit;
  end;
  tblGebruikers.First;
  while not tblGebruikers.Eof do
  begin
    if SameText(tblGebruikers.FieldByName('Gebruikersnaam').AsString,
      Trim(AUsername)) and
      (tblGebruikers.FieldByName('Wagwoord').AsString = APassword) and
      tblGebruikers.FieldByName('Aktief').AsBoolean then
    begin
      CurrentUserID := tblGebruikers.FieldByName('GebruikerID').AsInteger;
      CurrentUsername := tblGebruikers.FieldByName('Gebruikersnaam').AsString;
      CurrentRole := tblGebruikers.FieldByName('Rol').AsString;
      Result := True;
      Exit;
    end;
    tblGebruikers.Next;
  end;
end;

function TdmDatabase.RegisterUser(const AUsername, APassword, ARole: string;
  out AErrorMessage: string): Boolean;
begin
  Result := False;
  AErrorMessage := '';
  if not conDatabase.Connected then
  begin
    AErrorMessage := 'Daar is geen verbinding met die databasis nie.';
    Exit;
  end;
  tblGebruikers.First;
  while not tblGebruikers.Eof do
  begin
    if SameText(tblGebruikers.FieldByName('Gebruikersnaam').AsString,
      Trim(AUsername)) then
    begin
      AErrorMessage := 'Daardie gebruikersnaam bestaan reeds.';
      Exit;
    end;
    tblGebruikers.Next;
  end;
  try
    tblGebruikers.Append;
    tblGebruikers.FieldByName('Gebruikersnaam').AsString := Trim(AUsername);
    tblGebruikers.FieldByName('Wagwoord').AsString := APassword;
    tblGebruikers.FieldByName('Rol').AsString := ARole;
    tblGebruikers.FieldByName('Aktief').AsBoolean := True;
    tblGebruikers.Post;
    Result := True;
  except
    on E: Exception do
    begin
      if tblGebruikers.State in dsEditModes then
        tblGebruikers.Cancel;
      AErrorMessage := 'Die gebruiker kon nie gestoor word nie: ' + E.Message;
    end;
  end;
end;

procedure TdmDatabase.InitialiseerGeregteArray;
var
  I: Integer;
begin
  for I := 1 to MAX_GEREGTE do
    arrGeregte[I] := '';
  GeregAantal := 0;
  tblGeregte.First;
  while (not tblGeregte.Eof) and (GeregAantal < MAX_GEREGTE) do
  begin
    if tblGeregte.FieldByName('Aktief').AsBoolean then
    begin
      Inc(GeregAantal);
      arrGeregte[GeregAantal] := tblGeregte.FieldByName('GeregNaam').AsString;
    end;
    tblGeregte.Next;
  end;
end;

function TdmDatabase.BestanddeelNaam(ABestanddeelID: Integer): string;
begin
  Result := 'Onbekend';
  if tblBestanddele.Locate('BestanddeelID', ABestanddeelID, []) then
    Result := tblBestanddele.FieldByName('BestanddeelNaam').AsString;
end;

function TdmDatabase.GeregNaam(AGeregID: Integer): string;
begin
  Result := 'Onbekend';
  if tblGeregte.Locate('GeregID', AGeregID, []) then
    Result := tblGeregte.FieldByName('GeregNaam').AsString;
end;

function TdmDatabase.BerekenResepKoste(AGeregID: Integer): Currency;
var
  BestanddeelID: Integer;
  Hoeveelheid: Double;
begin
  Result := 0;
  tblGeregBestanddele.First;
  while not tblGeregBestanddele.Eof do
  begin
    if tblGeregBestanddele.FieldByName('GeregID').AsInteger = AGeregID then
    begin
      BestanddeelID := tblGeregBestanddele.FieldByName('BestanddeelID').AsInteger;
      Hoeveelheid := tblGeregBestanddele.FieldByName('HoeveelheidBenodig').AsFloat;
      if tblBestanddele.Locate('BestanddeelID', BestanddeelID, []) then
        Result := Result + (Hoeveelheid *
          tblBestanddele.FieldByName('EenheidKoste').AsFloat);
    end;
    tblGeregBestanddele.Next;
  end;
end;

function TdmDatabase.IsGeregBeskikbaar(AGeregID, AAantal: Integer): Boolean;
var
  BestanddeelID: Integer;
  Benodig, Voorraad: Double;
  HetBestanddele: Boolean;
begin
  Result := True;
  HetBestanddele := False;
  tblGeregBestanddele.First;
  while not tblGeregBestanddele.Eof do
  begin
    if tblGeregBestanddele.FieldByName('GeregID').AsInteger = AGeregID then
    begin
      HetBestanddele := True;
      BestanddeelID := tblGeregBestanddele.FieldByName('BestanddeelID').AsInteger;
      Benodig := tblGeregBestanddele.FieldByName('HoeveelheidBenodig').AsFloat * AAantal;
      Voorraad := 0;
      if tblBestanddele.Locate('BestanddeelID', BestanddeelID, []) then
        Voorraad := tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat;
      if Voorraad < Benodig then
        Result := False;
    end;
    tblGeregBestanddele.Next;
  end;
  Result := Result and HetBestanddele;
end;

end.
