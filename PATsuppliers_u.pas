unit PATsuppliers_u;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.Menus, Vcl.Dialogs;

type
  TfrmSuppliers = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    btnClose: TButton;
    lblKies: TLabel;
    grdGeregte: TStringGrid;
    lblAantal: TLabel;
    edtAantal: TEdit;
    btnVerkoop: TButton;
    lblVerkope: TLabel;
    grdVerkope: TStringGrid;
    mmVerkope: TMainMenu;
    mnuLeer: TMenuItem;
    mnuTerug: TMenuItem;
    mnuVerkope: TMenuItem;
    mnuTekenVerkoopAan: TMenuItem;
    mnuVerfris: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnVerkoopClick(Sender: TObject);
    procedure grdGeregteSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mnuVerfrisClick(Sender: TObject);
  private
    FGekoseGeregID: Integer;
    procedure LaaiGeregte;
    procedure LaaiVerkope;
  end;

var
  frmSuppliers: TfrmSuppliers;

implementation

uses
  PATdatabase_u;

{$R *.dfm}

procedure TfrmSuppliers.FormShow(Sender: TObject);
begin
  FGekoseGeregID := 0;
  edtAantal.Text := '1';
  LaaiGeregte;
  LaaiVerkope;
end;

procedure TfrmSuppliers.LaaiGeregte;
var
  Ry, GeregID: Integer;
begin
  grdGeregte.RowCount := 2;
  grdGeregte.Cells[0, 0] := 'ID';
  grdGeregte.Cells[1, 0] := 'Gereg';
  grdGeregte.Cells[2, 0] := 'Prys';
  grdGeregte.Cells[3, 0] := 'Status';
  Ry := 1;
  dmDatabase.tblGeregte.First;
  while not dmDatabase.tblGeregte.Eof do
  begin
    if dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean then
    begin
      GeregID := dmDatabase.tblGeregte.FieldByName('GeregID').AsInteger;
      grdGeregte.RowCount := Ry + 1;
      grdGeregte.Cells[0, Ry] := IntToStr(GeregID);
      grdGeregte.Cells[1, Ry] := dmDatabase.tblGeregte.FieldByName('GeregNaam').AsString;
      grdGeregte.Cells[2, Ry] := FormatFloat('R 0.00', dmDatabase.tblGeregte.FieldByName('VerkoopPrys').AsCurrency);
      if dmDatabase.IsGeregBeskikbaar(GeregID, 1) then
        grdGeregte.Cells[3, Ry] := 'Beskikbaar'
      else
        grdGeregte.Cells[3, Ry] := 'Onvoldoende voorraad';
      Inc(Ry);
    end;
    dmDatabase.tblGeregte.Next;
  end;
  if Ry = 1 then grdGeregte.Rows[1].Clear;
end;

procedure TfrmSuppliers.LaaiVerkope;
var
  Ry: Integer;
begin
  grdVerkope.RowCount := 2;
  grdVerkope.Cells[0, 0] := 'Datum en tyd';
  grdVerkope.Cells[1, 0] := 'Gereg';
  grdVerkope.Cells[2, 0] := 'Aantal';
  grdVerkope.Cells[3, 0] := 'Verkoop';
  grdVerkope.Cells[4, 0] := 'Koste';
  Ry := 1;
  dmDatabase.tblVerkope.First;
  while not dmDatabase.tblVerkope.Eof do
  begin
    grdVerkope.RowCount := Ry + 1;
    grdVerkope.Cells[0, Ry] := DateTimeToStr(dmDatabase.tblVerkope.FieldByName('DatumTyd').AsDateTime);
    grdVerkope.Cells[1, Ry] := dmDatabase.GeregNaam(dmDatabase.tblVerkope.FieldByName('GeregID').AsInteger);
    grdVerkope.Cells[2, Ry] := dmDatabase.tblVerkope.FieldByName('Hoeveelheid').AsString;
    grdVerkope.Cells[3, Ry] := FormatFloat('R 0.00', dmDatabase.tblVerkope.FieldByName('VerkoopPrys').AsCurrency);
    grdVerkope.Cells[4, Ry] := FormatFloat('R 0.00', dmDatabase.tblVerkope.FieldByName('Koste').AsCurrency);
    Inc(Ry);
    dmDatabase.tblVerkope.Next;
  end;
  if Ry = 1 then grdVerkope.Rows[1].Clear;
end;

procedure TfrmSuppliers.btnVerkoopClick(Sender: TObject);
var
  Aantal, BestanddeelID: Integer;
  Benodig, NuweVoorraad: Double;
  VerkoopPrys, Koste: Currency;
begin
  if FGekoseGeregID = 0 then
  begin
    ShowMessage('Kies eers ''n gereg.');
    Exit;
  end;
  if not TryStrToInt(edtAantal.Text, Aantal) or (Aantal < 1) or (Aantal > 100) then
  begin
    ShowMessage('Aantal moet ''n heelgetal tussen 1 en 100 wees.');
    Exit;
  end;
  if not dmDatabase.IsGeregBeskikbaar(FGekoseGeregID, Aantal) then
  begin
    ShowMessage('Daar is nie genoeg voorraad om hierdie bestelling te maak nie.');
    Exit;
  end;
  Koste := dmDatabase.BerekenResepKoste(FGekoseGeregID) * Aantal;
  VerkoopPrys := 0;
  if dmDatabase.tblGeregte.Locate('GeregID', FGekoseGeregID, []) then
    VerkoopPrys := dmDatabase.tblGeregte.FieldByName('VerkoopPrys').AsCurrency * Aantal;

  dmDatabase.tblGeregBestanddele.First;
  while not dmDatabase.tblGeregBestanddele.Eof do
  begin
    if dmDatabase.tblGeregBestanddele.FieldByName('GeregID').AsInteger = FGekoseGeregID then
    begin
      BestanddeelID := dmDatabase.tblGeregBestanddele.FieldByName('BestanddeelID').AsInteger;
      Benodig := dmDatabase.tblGeregBestanddele.FieldByName('HoeveelheidBenodig').AsFloat * Aantal;
      if dmDatabase.tblBestanddele.Locate('BestanddeelID', BestanddeelID, []) then
      begin
        NuweVoorraad := dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat - Benodig;
        dmDatabase.tblBestanddele.Edit;
        dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat := NuweVoorraad;
        dmDatabase.tblBestanddele.Post;
      end;
    end;
    dmDatabase.tblGeregBestanddele.Next;
  end;

  dmDatabase.tblVerkope.Append;
  dmDatabase.tblVerkope.FieldByName('GeregID').AsInteger := FGekoseGeregID;
  dmDatabase.tblVerkope.FieldByName('GebruikerID').AsInteger := dmDatabase.CurrentUserID;
  dmDatabase.tblVerkope.FieldByName('DatumTyd').AsDateTime := Now;
  dmDatabase.tblVerkope.FieldByName('Hoeveelheid').AsInteger := Aantal;
  dmDatabase.tblVerkope.FieldByName('VerkoopPrys').AsCurrency := VerkoopPrys;
  dmDatabase.tblVerkope.FieldByName('Koste').AsCurrency := Koste;
  dmDatabase.tblVerkope.Post;
  ShowMessage('Die verkoop is aangeteken en die voorraad is aangepas.');
  LaaiGeregte;
  LaaiVerkope;
end;

procedure TfrmSuppliers.grdGeregteSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow > 0) and (grdGeregte.Cells[0, ARow] <> '') then
    FGekoseGeregID := StrToInt(grdGeregte.Cells[0, ARow]);
end;

procedure TfrmSuppliers.mnuVerfrisClick(Sender: TObject);
begin
  LaaiGeregte;
  LaaiVerkope;
end;

procedure TfrmSuppliers.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
