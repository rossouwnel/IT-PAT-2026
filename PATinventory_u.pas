unit PATinventory_u;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.Menus, Vcl.Dialogs, System.UITypes;

type
  TfrmInventory = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    btnClose: TButton;
    lblSearch: TLabel;
    edtSearch: TEdit;
    grdVoorraad: TStringGrid;
    grpBesonderhede: TGroupBox;
    lblNaam: TLabel;
    lblEenheid: TLabel;
    lblHoeveelheid: TLabel;
    lblKoste: TLabel;
    lblMinimum: TLabel;
    edtNaam: TEdit;
    edtEenheid: TEdit;
    edtHoeveelheid: TEdit;
    edtKoste: TEdit;
    edtMinimum: TEdit;
    btnVoegBy: TButton;
    btnWysig: TButton;
    btnVerwyder: TButton;
    btnMaakSkoon: TButton;
    mmVoorraad: TMainMenu;
    mnuLeer: TMenuItem;
    mnuTerug: TMenuItem;
    mnuVoorraad: TMenuItem;
    mnuVoegBy: TMenuItem;
    mnuWysig: TMenuItem;
    mnuVerwyder: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure grdVoorraadSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnVoegByClick(Sender: TObject);
    procedure btnWysigClick(Sender: TObject);
    procedure btnVerwyderClick(Sender: TObject);
    procedure btnMaakSkoonClick(Sender: TObject);
  private
    FGekoseID: Integer;
    FLaaiBesig: Boolean;
    procedure LaaiVoorraad;
    function LeesGetal(AEdit: TEdit; const AVeld: string;
      out AGetal: Double): Boolean;
  end;

var
  frmInventory: TfrmInventory;

implementation

uses
  PATdatabase_u;

{$R *.dfm}

procedure TfrmInventory.FormShow(Sender: TObject);
begin
  FGekoseID := 0;
  LaaiVoorraad;
end;

procedure TfrmInventory.LaaiVoorraad;
var
  Ry: Integer;
  Soek: string;
  Laag: Boolean;
begin
  FLaaiBesig := True;
  try
    grdVoorraad.RowCount := 2;
    grdVoorraad.Cells[0, 0] := 'ID';
    grdVoorraad.Cells[1, 0] := 'Bestanddeel';
    grdVoorraad.Cells[2, 0] := 'Eenheid';
    grdVoorraad.Cells[3, 0] := 'Voorraad';
    grdVoorraad.Cells[4, 0] := 'Eenheidskoste';
    grdVoorraad.Cells[5, 0] := 'Minimum';
    grdVoorraad.Cells[6, 0] := 'Status';
    Ry := 1;
    Soek := LowerCase(Trim(edtSearch.Text));
    dmDatabase.tblBestanddele.First;
    while not dmDatabase.tblBestanddele.Eof do
    begin
      if dmDatabase.tblBestanddele.FieldByName('Aktief').AsBoolean and
        ((Soek = '') or (Pos(Soek, LowerCase(dmDatabase.tblBestanddele.
        FieldByName('BestanddeelNaam').AsString)) > 0)) then
      begin
        grdVoorraad.RowCount := Ry + 1;
        grdVoorraad.Cells[0, Ry] := dmDatabase.tblBestanddele.FieldByName('BestanddeelID').AsString;
        grdVoorraad.Cells[1, Ry] := dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString;
        grdVoorraad.Cells[2, Ry] := dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString;
        grdVoorraad.Cells[3, Ry] := FormatFloat('0.00', dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat);
        grdVoorraad.Cells[4, Ry] := FormatFloat('R 0.00', dmDatabase.tblBestanddele.FieldByName('EenheidKoste').AsFloat);
        grdVoorraad.Cells[5, Ry] := FormatFloat('0.00', dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat);
        Laag := dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat <=
          dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat;
        if Laag then
          grdVoorraad.Cells[6, Ry] := 'HERBESTEL'
        else
          grdVoorraad.Cells[6, Ry] := 'Reg';
        Inc(Ry);
      end;
      dmDatabase.tblBestanddele.Next;
    end;
    if Ry = 1 then
    begin
      grdVoorraad.RowCount := 2;
      grdVoorraad.Rows[1].Clear;
    end;
  finally
    FLaaiBesig := False;
  end;
end;

function TfrmInventory.LeesGetal(AEdit: TEdit; const AVeld: string;
  out AGetal: Double): Boolean;
begin
  Result := TryStrToFloat(AEdit.Text, AGetal) and (AGetal >= 0) and
    (AGetal <= 100000);
  if not Result then
  begin
    ShowMessage(AVeld + ' moet ''n positiewe getal van hoogstens 100 000 wees.');
    AEdit.SetFocus;
  end;
end;

procedure TfrmInventory.btnVoegByClick(Sender: TObject);
var
  Hoeveelheid, Koste, Minimum: Double;
begin
  if Trim(edtNaam.Text) = '' then
  begin
    ShowMessage('Tik ''n bestanddeelnaam in.');
    Exit;
  end;
  if Trim(edtEenheid.Text) = '' then
  begin
    ShowMessage('Tik ''n eenheid in, byvoorbeeld kg of liter.');
    Exit;
  end;
  if not LeesGetal(edtHoeveelheid, 'Hoeveelheid', Hoeveelheid) then Exit;
  if not LeesGetal(edtKoste, 'Eenheidskoste', Koste) then Exit;
  if not LeesGetal(edtMinimum, 'Minimumvlak', Minimum) then Exit;
  dmDatabase.tblBestanddele.Append;
  dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString := Trim(edtNaam.Text);
  dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString := Trim(edtEenheid.Text);
  dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat := Hoeveelheid;
  dmDatabase.tblBestanddele.FieldByName('EenheidKoste').AsFloat := Koste;
  dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat := Minimum;
  dmDatabase.tblBestanddele.FieldByName('Aktief').AsBoolean := True;
  dmDatabase.tblBestanddele.Post;
  ShowMessage('Die bestanddeel is suksesvol bygevoeg.');
  btnMaakSkoonClick(Sender);
  LaaiVoorraad;
end;

procedure TfrmInventory.btnWysigClick(Sender: TObject);
var
  Hoeveelheid, Koste, Minimum: Double;
begin
  if FGekoseID = 0 then
  begin
    ShowMessage('Kies eers ''n bestanddeel in die lys.');
    Exit;
  end;
  if not LeesGetal(edtHoeveelheid, 'Hoeveelheid', Hoeveelheid) then Exit;
  if not LeesGetal(edtKoste, 'Eenheidskoste', Koste) then Exit;
  if not LeesGetal(edtMinimum, 'Minimumvlak', Minimum) then Exit;
  if dmDatabase.tblBestanddele.Locate('BestanddeelID', FGekoseID, []) then
  begin
    dmDatabase.tblBestanddele.Edit;
    dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString := Trim(edtNaam.Text); // trim haal spasies uit (begin/einde). trim altyd user input
    dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString := Trim(edtEenheid.Text);
    dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat := Hoeveelheid;
    dmDatabase.tblBestanddele.FieldByName('EenheidKoste').AsFloat := Koste;
    dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat := Minimum;
    dmDatabase.tblBestanddele.Post;
    ShowMessage('Die bestanddeel is opgedateer.');
  end;
  LaaiVoorraad;
end;

procedure TfrmInventory.btnVerwyderClick(Sender: TObject);
begin
  if FGekoseID = 0 then
  begin
    ShowMessage('Kies eers ''n bestanddeel in die lys.');
    Exit;
  end;
  if MessageDlg('Wil jy hierdie bestanddeel deaktiveer?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    if dmDatabase.tblBestanddele.Locate('BestanddeelID', FGekoseID, []) then
    begin
      dmDatabase.tblBestanddele.Edit;
      dmDatabase.tblBestanddele.FieldByName('Aktief').AsBoolean := False;
      dmDatabase.tblBestanddele.Post;
      btnMaakSkoonClick(Sender);
      LaaiVoorraad;
    end;
end;

procedure TfrmInventory.btnMaakSkoonClick(Sender: TObject);
begin
  FGekoseID := 0;
  edtNaam.Clear;
  edtEenheid.Clear;
  edtHoeveelheid.Clear;
  edtKoste.Clear;
  edtMinimum.Clear;
  edtNaam.SetFocus;
end;

procedure TfrmInventory.edtSearchChange(Sender: TObject);
begin
  LaaiVoorraad;
end;

procedure TfrmInventory.grdVoorraadSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if FLaaiBesig then Exit;
  if (ARow < 1) or (grdVoorraad.Cells[0, ARow] = '') then Exit;
  FGekoseID := StrToInt(grdVoorraad.Cells[0, ARow]);
  if dmDatabase.tblBestanddele.Locate('BestanddeelID', FGekoseID, []) then
  begin
    edtNaam.Text := dmDatabase.tblBestanddele.FieldByName('BestanddeelNaam').AsString;
    edtEenheid.Text := dmDatabase.tblBestanddele.FieldByName('Eenheid').AsString;
    edtHoeveelheid.Text := dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsString;
    edtKoste.Text := dmDatabase.tblBestanddele.FieldByName('EenheidKoste').AsString;
    edtMinimum.Text := dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsString;
  end;
end;

procedure TfrmInventory.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
