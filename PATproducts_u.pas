unit PATproducts_u;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.Menus, Vcl.Dialogs, System.UITypes;

type
  TfrmProducts = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    btnClose: TButton;
    grdGeregte: TStringGrid;
    grpGereg: TGroupBox;
    lblGeregNaam: TLabel;
    lblVerkoopPrys: TLabel;
    edtGeregNaam: TEdit;
    edtVerkoopPrys: TEdit;
    btnVoegGeregBy: TButton;
    btnDeaktiveerGereg: TButton;
    grpResep: TGroupBox;
    lblBestanddeel: TLabel;
    lblBenodig: TLabel;
    cboBestanddeel: TComboBox;
    edtBenodig: TEdit;
    btnVoegBestanddeelBy: TButton;
    btnVerwyderBestanddeel: TButton;
    grdResep: TStringGrid;
    lblKoste: TLabel;
    lblBeskikbaar: TLabel;
    mmGeregte: TMainMenu;
    mnuLeer: TMenuItem;
    mnuTerug: TMenuItem;
    mnuGeregte: TMenuItem;
    mnuNuweGereg: TMenuItem;
    mnuDeaktiveerGereg: TMenuItem;
    mnuResep: TMenuItem;
    mnuVoegBestanddeel: TMenuItem;
    mnuVerwyderBestanddeel: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure grdGeregteSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grdResepSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnVoegGeregByClick(Sender: TObject);
    procedure btnDeaktiveerGeregClick(Sender: TObject);
    procedure btnVoegBestanddeelByClick(Sender: TObject);
    procedure btnVerwyderBestanddeelClick(Sender: TObject);
  private
    FGekoseGeregID: Integer;
    FGekoseResepID: Integer;
    FBestanddeelIDs: array[0..199] of Integer;
    procedure LaaiGeregte;
    procedure LaaiBestanddele;
    procedure LaaiResep;
  end;

var
  frmProducts: TfrmProducts;

implementation

uses
  PATdatabase_u;

{$R *.dfm}

procedure TfrmProducts.FormShow(Sender: TObject);
begin
  FGekoseGeregID := 0;
  FGekoseResepID := 0;
  LaaiBestanddele;
  LaaiGeregte;
  LaaiResep;
end;

procedure TfrmProducts.LaaiGeregte;
var
  Ry: Integer;
begin
  grdGeregte.RowCount := 2;
  grdGeregte.Cells[0, 0] := 'ID';
  grdGeregte.Cells[1, 0] := 'Gereg';
  grdGeregte.Cells[2, 0] := 'Verkoopprys';
  grdGeregte.Cells[3, 0] := 'Resepkoste';
  grdGeregte.Cells[4, 0] := 'Beskikbaarheid';
  Ry := 1;
  dmDatabase.tblGeregte.First;
  while not dmDatabase.tblGeregte.Eof do
  begin
    if dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean then
    begin
      grdGeregte.RowCount := Ry + 1;
      grdGeregte.Cells[0, Ry] := dmDatabase.tblGeregte.FieldByName('GeregID').AsString;
      grdGeregte.Cells[1, Ry] := dmDatabase.tblGeregte.FieldByName('GeregNaam').AsString;
      grdGeregte.Cells[2, Ry] := FormatFloat('R 0.00', dmDatabase.tblGeregte.FieldByName('VerkoopPrys').AsCurrency);
      grdGeregte.Cells[3, Ry] := FormatFloat('R 0.00', dmDatabase.BerekenResepKoste(dmDatabase.tblGeregte.FieldByName('GeregID').AsInteger));
      if dmDatabase.IsGeregBeskikbaar(dmDatabase.tblGeregte.FieldByName('GeregID').AsInteger, 1) then
        grdGeregte.Cells[4, Ry] := 'Beskikbaar'
      else
        grdGeregte.Cells[4, Ry] := 'Onvoldoende voorraad';
      Inc(Ry);
    end;
    dmDatabase.tblGeregte.Next;
  end;
  if Ry = 1 then grdGeregte.Rows[1].Clear;
end;

procedure TfrmProducts.LaaiBestanddele;
var
  I: Integer;
begin
  cboBestanddeel.Clear;
  I := 0;
  dmDatabase.tblBestanddele.First;
  while (not dmDatabase.tblBestanddele.Eof) and (I < 200) do
  begin
    if dmDatabase.tblBestanddele.FieldByName('Aktief').AsBoolean then
    begin
      FBestanddeelIDs[I] := dmDatabase.tblBestanddele.FieldByName('BestanddeelID').AsInteger;
      cboBestanddeel.Items.Add(dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString +
        ' (' + dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString + ')');
      Inc(I);
    end;
    dmDatabase.tblBestanddele.Next;
  end;
  if cboBestanddeel.Items.Count > 0 then cboBestanddeel.ItemIndex := 0;
end;

procedure TfrmProducts.LaaiResep;
var
  Ry, BestanddeelID: Integer;
begin
  grdResep.RowCount := 2;
  grdResep.Cells[0, 0] := 'Resep-ID';
  grdResep.Cells[1, 0] := 'Bestanddeel';
  grdResep.Cells[2, 0] := 'Hoeveelheid benodig';
  Ry := 1;
  if FGekoseGeregID <> 0 then
  begin
    dmDatabase.tblGeregBestanddele.First;
    while not dmDatabase.tblGeregBestanddele.Eof do
    begin
      if dmDatabase.tblGeregBestanddele.FieldByName('GeregID').AsInteger = FGekoseGeregID then
      begin
        BestanddeelID := dmDatabase.tblGeregBestanddele.FieldByName('BestanddeelID').AsInteger;
        grdResep.RowCount := Ry + 1;
        grdResep.Cells[0, Ry] := dmDatabase.tblGeregBestanddele.FieldByName('GeregBestanddeelID').AsString;
        grdResep.Cells[1, Ry] := dmDatabase.BestanddeelNaam(BestanddeelID);
        grdResep.Cells[2, Ry] := dmDatabase.tblGeregBestanddele.FieldByName('HoeveelheidBenodig').AsString;
        Inc(Ry);
      end;
      dmDatabase.tblGeregBestanddele.Next;
    end;
  end;
  if Ry = 1 then grdResep.Rows[1].Clear;
  lblKoste.Caption := 'Resepkoste: ' + FormatFloat('R 0.00', dmDatabase.BerekenResepKoste(FGekoseGeregID));
  if dmDatabase.IsGeregBeskikbaar(FGekoseGeregID, 1) then
    lblBeskikbaar.Caption := 'Status: Beskikbaar'
  else
    lblBeskikbaar.Caption := 'Status: Onvoldoende voorraad of geen resep';
end;

procedure TfrmProducts.btnVoegGeregByClick(Sender: TObject);
var
  Prys: Double;
begin
  if Trim(edtGeregNaam.Text) = '' then
  begin
    ShowMessage('Tik ''n geregnaam in.');
    Exit;
  end;
  if not TryStrToFloat(edtVerkoopPrys.Text, Prys) or (Prys <= 0) or (Prys > 100000) then
  begin
    ShowMessage('Die verkoopprys moet tussen 0 en 100 000 wees.');
    Exit;
  end;
  dmDatabase.InitialiseerGeregteArray;
  if dmDatabase.GeregAantal >= MAX_GEREGTE then
  begin
    ShowMessage('Daar mag hoogstens 30 aktiewe geregte wees.');
    Exit;
  end;
  dmDatabase.tblGeregte.First;
  while not dmDatabase.tblGeregte.Eof do
  begin
    if SameText(dmDatabase.tblGeregte.FieldByName('GeregNaam').AsString,
      Trim(edtGeregNaam.Text)) and dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean then
    begin
      ShowMessage('Daardie gereg bestaan reeds.');
      Exit;
    end;
    dmDatabase.tblGeregte.Next;
  end;
  dmDatabase.tblGeregte.Append;
  dmDatabase.tblGeregte.FieldByName('GeregNaam').AsString := Trim(edtGeregNaam.Text);
  dmDatabase.tblGeregte.FieldByName('VerkoopPrys').AsCurrency := Prys;
  dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean := True;
  dmDatabase.tblGeregte.Post;
  FGekoseGeregID := dmDatabase.tblGeregte.FieldByName('GeregID').AsInteger;
  edtGeregNaam.Clear;
  edtVerkoopPrys.Clear;
  dmDatabase.InitialiseerGeregteArray;
  LaaiGeregte;
  LaaiResep;
  ShowMessage('Die gereg is suksesvol ingevoer. Voeg nou die resepbestanddele by.');
end;

procedure TfrmProducts.btnDeaktiveerGeregClick(Sender: TObject);
begin
  if FGekoseGeregID = 0 then
  begin
    ShowMessage('Kies eers ''n gereg.');
    Exit;
  end;
  if MessageDlg('Wil jy hierdie gereg deaktiveer?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    if dmDatabase.tblGeregte.Locate('GeregID', FGekoseGeregID, []) then
    begin
      dmDatabase.tblGeregte.Edit;
      dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean := False;
      dmDatabase.tblGeregte.Post;
      FGekoseGeregID := 0;
      dmDatabase.InitialiseerGeregteArray;
      LaaiGeregte;
      LaaiResep;
    end;
end;

procedure TfrmProducts.btnVoegBestanddeelByClick(Sender: TObject);
var
  Hoeveelheid: Double;
  BestanddeelID: Integer;
  BestaandeID: Integer;
begin
  if FGekoseGeregID = 0 then
  begin
    ShowMessage('Kies eers ''n gereg.');
    Exit;
  end;
  if cboBestanddeel.ItemIndex < 0 then
  begin
    ShowMessage('Voeg eers bestanddele by die voorraadskerm.');
    Exit;
  end;
  if not TryStrToFloat(edtBenodig.Text, Hoeveelheid) or (Hoeveelheid <= 0) or
    (Hoeveelheid > 10000) then
  begin
    ShowMessage('Die hoeveelheid benodig moet tussen 0 en 10 000 wees.');
    Exit;
  end;
  BestanddeelID := FBestanddeelIDs[cboBestanddeel.ItemIndex];
  BestaandeID := 0;
  dmDatabase.tblGeregBestanddele.First;
  while not dmDatabase.tblGeregBestanddele.Eof do
  begin
    if (dmDatabase.tblGeregBestanddele.FieldByName('GeregID').AsInteger = FGekoseGeregID) and
      (dmDatabase.tblGeregBestanddele.FieldByName('BestanddeelID').AsInteger = BestanddeelID) then
      BestaandeID := dmDatabase.tblGeregBestanddele.FieldByName('GeregBestanddeelID').AsInteger;
    dmDatabase.tblGeregBestanddele.Next;
  end;
  if BestaandeID <> 0 then
  begin
    dmDatabase.tblGeregBestanddele.Locate('GeregBestanddeelID', BestaandeID, []);
    dmDatabase.tblGeregBestanddele.Edit;
    dmDatabase.tblGeregBestanddele.FieldByName('HoeveelheidBenodig').AsFloat := Hoeveelheid;
    dmDatabase.tblGeregBestanddele.Post;
  end
  else
  begin
    dmDatabase.tblGeregBestanddele.Append;
    dmDatabase.tblGeregBestanddele.FieldByName('GeregID').AsInteger := FGekoseGeregID;
    dmDatabase.tblGeregBestanddele.FieldByName('BestanddeelID').AsInteger := BestanddeelID;
    dmDatabase.tblGeregBestanddele.FieldByName('HoeveelheidBenodig').AsFloat := Hoeveelheid;
    dmDatabase.tblGeregBestanddele.Post;
  end;
  edtBenodig.Clear;
  LaaiResep;
  LaaiGeregte;
end;

procedure TfrmProducts.btnVerwyderBestanddeelClick(Sender: TObject);
begin
  if FGekoseResepID = 0 then
  begin
    ShowMessage('Kies eers ''n bestanddeel in die resep.');
    Exit;
  end;
  if dmDatabase.tblGeregBestanddele.Locate('GeregBestanddeelID', FGekoseResepID, []) then
    dmDatabase.tblGeregBestanddele.Delete;
  FGekoseResepID := 0;
  LaaiResep;
  LaaiGeregte;
end;

procedure TfrmProducts.grdGeregteSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow < 1) or (grdGeregte.Cells[0, ARow] = '') then Exit;
  FGekoseGeregID := StrToInt(grdGeregte.Cells[0, ARow]);
  FGekoseResepID := 0;
  LaaiResep;
end;

procedure TfrmProducts.grdResepSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow > 0) and (grdResep.Cells[0, ARow] <> '') then
    FGekoseResepID := StrToInt(grdResep.Cells[0, ARow]);
end;

procedure TfrmProducts.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
