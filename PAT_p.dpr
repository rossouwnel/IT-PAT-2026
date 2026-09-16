program PAT_p;

uses
  Vcl.Forms,
  PATlogin_u in 'PATlogin_u.pas' {frmLogin},
  PATmenu_u in 'PATmenu_u.pas' {frmMenu},
  PATdatabase_u in 'PATdatabase_u.pas' {dmDatabase: TDataModule},
  PATinventory_u in 'PATinventory_u.pas' {frmInventory},
  PATproducts_u in 'PATproducts_u.pas' {frmProducts},
  PATsuppliers_u in 'PATsuppliers_u.pas' {frmSuppliers},
  PATreports_u in 'PATreports_u.pas' {frmReports};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDatabase, dmDatabase);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
