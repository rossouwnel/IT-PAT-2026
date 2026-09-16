unit PATmenu_u;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Graphics, Vcl.Menus;

type
  TfrmMenu = class(TForm)
    pnlSidebar: TPanel;
    lblBrand: TLabel;
    lblUser: TLabel;
    btnOverview: TButton;
    btnInventory: TButton;
    btnProducts: TButton;
    btnSuppliers: TButton;
    btnReports: TButton;
    btnSignOut: TButton;
    pnlContent: TPanel;
    lblTitle: TLabel;
    lblDescription: TLabel;
    pnlCard1: TPanel;
    lblCardValue1: TLabel;
    lblCardCaption1: TLabel;
    pnlCard2: TPanel;
    lblCardValue2: TLabel;
    lblCardCaption2: TLabel;
    pnlCard3: TPanel;
    lblCardValue3: TLabel;
    lblCardCaption3: TLabel;
    mmHoof: TMainMenu;
    mnuLeer: TMenuItem;
    mnuTekenUit: TMenuItem;
    mnuSluit: TMenuItem;
    mnuBestuur: TMenuItem;
    mnuOorsig: TMenuItem;
    mnuVoorraad: TMenuItem;
    mnuGeregte: TMenuItem;
    mnuVerkope: TMenuItem;
    mnuVerslae: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnOverviewClick(Sender: TObject);
    procedure btnInventoryClick(Sender: TObject);
    procedure btnProductsClick(Sender: TObject);
    procedure btnSuppliersClick(Sender: TObject);
    procedure btnReportsClick(Sender: TObject);
    procedure btnSignOutClick(Sender: TObject);
    procedure mnuSluitClick(Sender: TObject);
  private
    procedure LaaiOorsig;
    procedure StelToegang;
  end;

var
  frmMenu: TfrmMenu;

implementation

uses
  PATdatabase_u, PATinventory_u, PATproducts_u, PATsuppliers_u, PATreports_u;

{$R *.dfm}

procedure TfrmMenu.FormShow(Sender: TObject);
begin
  lblUser.Caption := dmDatabase.CurrentUsername + ' (' +
    dmDatabase.CurrentRole + ')';
  StelToegang;
  LaaiOorsig;
end;

procedure TfrmMenu.StelToegang;
var
  MagVoorraad, MagResepte, MagVerkope, MagVerslae: Boolean;
begin
  MagVoorraad := SameText(dmDatabase.CurrentRole, 'Bestuurder') or
    SameText(dmDatabase.CurrentRole, 'Sjef');
  MagResepte := MagVoorraad;
  MagVerkope := SameText(dmDatabase.CurrentRole, 'Bestuurder') or
    SameText(dmDatabase.CurrentRole, 'Kelner');
  MagVerslae := SameText(dmDatabase.CurrentRole, 'Bestuurder') or
    SameText(dmDatabase.CurrentRole, 'Eienaar');
  btnInventory.Enabled := MagVoorraad;
  btnProducts.Enabled := MagResepte;
  btnSuppliers.Enabled := MagVerkope;
  btnReports.Enabled := MagVerslae;
  mnuVoorraad.Enabled := MagVoorraad;
  mnuGeregte.Enabled := MagResepte;
  mnuVerkope.Enabled := MagVerkope;
  mnuVerslae.Enabled := MagVerslae;
end;

procedure TfrmMenu.LaaiOorsig;
var
  Bestanddele, LaeVoorraad, Geregte: Integer;
begin
  Bestanddele := 0;
  LaeVoorraad := 0;
  dmDatabase.tblBestanddele.First;
  while not dmDatabase.tblBestanddele.Eof do
  begin
    if dmDatabase.tblBestanddele.FieldByName('Aktief').AsBoolean then
    begin
      Inc(Bestanddele);
      if dmDatabase.tblBestanddele.FieldByName('HoeveelheidVoorraad').AsFloat <=
        dmDatabase.tblBestanddele.FieldByName('MinimumDrumpel').AsFloat then
        Inc(LaeVoorraad);
    end;
    dmDatabase.tblBestanddele.Next;
  end;
  Geregte := 0;
  dmDatabase.tblGeregte.First;
  while not dmDatabase.tblGeregte.Eof do
  begin
    if dmDatabase.tblGeregte.FieldByName('Aktief').AsBoolean then
      Inc(Geregte);
    dmDatabase.tblGeregte.Next;
  end;
  lblCardValue1.Caption := IntToStr(Bestanddele);
  lblCardValue2.Caption := IntToStr(LaeVoorraad);
  lblCardValue3.Caption := IntToStr(Geregte);
end;

procedure TfrmMenu.btnOverviewClick(Sender: TObject);
begin
  LaaiOorsig;
end;

procedure TfrmMenu.btnInventoryClick(Sender: TObject);
begin
  with TfrmInventory.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  LaaiOorsig;
end;

procedure TfrmMenu.btnProductsClick(Sender: TObject);
begin
  with TfrmProducts.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  LaaiOorsig;
end;

procedure TfrmMenu.btnSuppliersClick(Sender: TObject);
begin
  with TfrmSuppliers.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  LaaiOorsig;
end;

procedure TfrmMenu.btnReportsClick(Sender: TObject);
begin
  with TfrmReports.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmMenu.btnSignOutClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmMenu.mnuSluitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
