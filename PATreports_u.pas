unit PATreports_u;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Menus;

type
  TfrmReports = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    btnClose: TButton;
    lblTipe: TLabel;
    cbReportType: TComboBox;
    btnGenereer: TButton;
    btnAflaai: TButton;
    memVerslag: TMemo;
    dlgStoor: TSaveDialog;
    mmVerslae: TMainMenu;
    mnuLeer: TMenuItem;
    mnuTerug: TMenuItem;
    mnuVerslag: TMenuItem;
    mnuGenereer: TMenuItem;
    mnuAflaai: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnGenereerClick(Sender: TObject);
    procedure btnAflaaiClick(Sender: TObject);
  private
    procedure BouVoorraadVerslag;
    procedure BouVerkopeVerslag;
    procedure BouGeregteVerslag;
    procedure SkryfVoorraadVerslag(const ALeerNaam: string);
  end;

var
  frmReports: TfrmReports;

implementation

uses
  PATdatabase_u;

{$R *.dfm}

procedure TfrmReports.FormShow(Sender: TObject);
begin
  cbReportType.ItemIndex := 0;
  btnGenereerClick(Sender);
end;

procedure TfrmReports.BouVoorraadVerslag;
var
  Laag: Boolean;
begin
  memVerslag.Clear;
  memVerslag.Lines.Add('FRESH COUNT - VOORRAADVERSLAG');
  memVerslag.Lines.Add('Datum: ' + DateToStr(Date));
  memVerslag.Lines.Add(StringOfChar('=', 70));
  memVerslag.Lines.Add('BESTANDDEEL'#9'EENHEID'#9'VOORRAAD'#9'MINIMUM'#9'STATUS');
  dmDatabase.tblBestanddele.First;
  while not dmDatabase.tblBestanddele.Eof do
  begin
    if dmDatabase.tblBestanddele.FieldByName('Aktief').AsBoolean then
    begin
      Laag := dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat <=
        dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat;
      if Laag then
        memVerslag.Lines.Add(dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString + #9 +
          dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString + #9 +
          FormatFloat('0.00', dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat) + #9 +
          FormatFloat('0.00', dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat) + #9 + 'HERBESTEL')
      else
        memVerslag.Lines.Add(dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString + #9 +
          dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString + #9 +
          FormatFloat('0.00', dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat) + #9 +
          FormatFloat('0.00', dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat) + #9 + 'Reg');
    end;
    dmDatabase.tblBestanddele.Next;
  end;
end;

procedure TfrmReports.BouVerkopeVerslag;
var
  TotaleVerkope, TotaleKoste: Currency;
begin
  memVerslag.Clear;
  memVerslag.Lines.Add('FRESH COUNT - VERKOPEVERSLAG');
  memVerslag.Lines.Add('Datum gegenereer: ' + DateTimeToStr(Now));
  memVerslag.Lines.Add(StringOfChar('=', 70));
  TotaleVerkope := 0;
  TotaleKoste := 0;
  dmDatabase.tblVerkope.First;
  while not dmDatabase.tblVerkope.Eof do
  begin
    memVerslag.Lines.Add(DateTimeToStr(dmDatabase.tblVerkope.FieldByName('DatumTyd').AsDateTime) +
      ' | ' + dmDatabase.GeregNaam(dmDatabase.tblVerkope.FieldByName('GeregID').AsInteger) +
      ' | Aantal: ' + dmDatabase.tblVerkope.FieldByName('Hoeveelheid').AsString +
      ' | Verkoop: ' + FormatFloat('R 0.00', dmDatabase.tblVerkope.FieldByName('VerkoopPrys').AsCurrency) +
      ' | Koste: ' + FormatFloat('R 0.00', dmDatabase.tblVerkope.FieldByName('Koste').AsCurrency));
    TotaleVerkope := TotaleVerkope + dmDatabase.tblVerkope.FieldByName('VerkoopPrys').AsCurrency;
    TotaleKoste := TotaleKoste + dmDatabase.tblVerkope.FieldByName('Koste').AsCurrency;
    dmDatabase.tblVerkope.Next;
  end;
  memVerslag.Lines.Add(StringOfChar('-', 70));
  memVerslag.Lines.Add('Totale verkope: ' + FormatFloat('R 0.00', TotaleVerkope));
  memVerslag.Lines.Add('Totale koste: ' + FormatFloat('R 0.00', TotaleKoste));
  memVerslag.Lines.Add('Geskatte wins: ' + FormatFloat('R 0.00', TotaleVerkope - TotaleKoste));
end;

procedure TfrmReports.BouGeregteVerslag;
var
  GeregID: Integer;
begin
  memVerslag.Clear;
  memVerslag.Lines.Add('FRESH COUNT - GEREGTE EN KOSTE');
  memVerslag.Lines.Add('Datum: ' + DateToStr(Date));
  memVerslag.Lines.Add(StringOfChar('=', 70));
  dmDatabase.tblGeregte.First;
  while not dmDatabase.tblGeregte.Eof do
  begin
    if dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean then
    begin
      GeregID := dmDatabase.tblGeregte.FieldByName('GeregID').AsInteger;
      if dmDatabase.IsGeregBeskikbaar(GeregID, 1) then
        memVerslag.Lines.Add(dmDatabase.tblGeregte.FieldByName('GeregNaam').AsString +
          ' | Resepkoste: ' + FormatFloat('R 0.00', dmDatabase.BerekenResepKoste(GeregID)) +
          ' | Verkoopprys: ' + FormatFloat('R 0.00', dmDatabase.tblGeregte.FieldByName('VerkoopPrys').AsCurrency) +
          ' | Beskikbaar')
      else
        memVerslag.Lines.Add(dmDatabase.tblGeregte.FieldByName('GeregNaam').AsString +
          ' | Resepkoste: ' + FormatFloat('R 0.00', dmDatabase.BerekenResepKoste(GeregID)) +
          ' | Verkoopprys: ' + FormatFloat('R 0.00', dmDatabase.tblGeregte.FieldByName('VerkoopPrys').AsCurrency) +
          ' | Onvoldoende voorraad');
    end;
    dmDatabase.tblGeregte.Next;
  end;
end;

procedure TfrmReports.btnGenereerClick(Sender: TObject);
begin
  case cbReportType.ItemIndex of
    0: BouVoorraadVerslag;
    1: BouVerkopeVerslag;
    2: BouGeregteVerslag;
  end;
end;

procedure TfrmReports.SkryfVoorraadVerslag(const ALeerNaam: string);
var
  VerslagLeer: TextFile;
  I: Integer;
begin
  AssignFile(VerslagLeer, ALeerNaam);
  Rewrite(VerslagLeer);
  try
    for I := 0 to memVerslag.Lines.Count - 1 do
      WriteLn(VerslagLeer, memVerslag.Lines[I]);
  finally
    CloseFile(VerslagLeer);
  end;
end;

procedure TfrmReports.btnAflaaiClick(Sender: TObject);
begin
  if memVerslag.Lines.Count = 0 then btnGenereerClick(Sender);
  dlgStoor.FileName := 'VoorraadVerslag_' + FormatDateTime('yyyymmdd', Date) + '.txt';
  if dlgStoor.Execute then
  begin
    SkryfVoorraadVerslag(dlgStoor.FileName);
    ShowMessage('Die verslag is gestoor as:' + sLineBreak + dlgStoor.FileName);
  end;
end;

procedure TfrmReports.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
