unit PATlogin_u;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, System.UITypes;

type
  TfrmLogin = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pgcAccount: TPageControl;
    tabTekenIn: TTabSheet;
    tabRegistreer: TTabSheet;
    lblGebruikersnaam: TLabel;
    lblWagwoord: TLabel;
    edtGebruikersnaam: TEdit;
    edtWagwoord: TEdit;
    btnTekenIn: TButton;
    lblNuweGebruikersnaam: TLabel;
    lblNuweWagwoord: TLabel;
    lblBevestig: TLabel;
    lblRol: TLabel;
    edtNuweGebruikersnaam: TEdit;
    edtNuweWagwoord: TEdit;
    edtBevestig: TEdit;
    cboRol: TComboBox;
    btnRegistreer: TButton;
    mmAanmelding: TMainMenu;
    mnuRekening: TMenuItem;
    mnuTekenIn: TMenuItem;
    mnuRegistreer: TMenuItem;
    mnuSluit: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnTekenInClick(Sender: TObject);
    procedure btnRegistreerClick(Sender: TObject);
    procedure mnuTekenInClick(Sender: TObject);
    procedure mnuRegistreerClick(Sender: TObject);
    procedure mnuSluitClick(Sender: TObject);
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  PATmenu_u, PATdatabase_u;

{$R *.dfm}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  pgcAccount.ActivePage := tabTekenIn;
  cboRol.ItemIndex := 0;
  if dmDatabase.LastError <> '' then
    MessageDlg(dmDatabase.LastError, mtError, [mbOK], 0);
end;

procedure TfrmLogin.btnTekenInClick(Sender: TObject);
var
  MenuForm: TfrmMenu;
begin
  if (Trim(edtGebruikersnaam.Text) = '') or (edtWagwoord.Text = '') then
  begin
    ShowMessage('Vul asseblief jou gebruikersnaam en wagwoord in.');
    Exit;
  end;
  if not dmDatabase.Authenticate(edtGebruikersnaam.Text, edtWagwoord.Text) then
  begin
    if dmDatabase.LastError <> '' then
      ShowMessage(dmDatabase.LastError)
    else
      ShowMessage('Die gebruikersnaam of wagwoord is verkeerd.');
    Exit;
  end;
  MenuForm := TfrmMenu.Create(Self);
  try
    Hide;
    MenuForm.ShowModal;
  finally
    MenuForm.Free;
    edtWagwoord.Clear;
    Show;
  end;
end;

procedure TfrmLogin.btnRegistreerClick(Sender: TObject);
var
  Fout: string;
begin
  if (Length(Trim(edtNuweGebruikersnaam.Text)) < 1) or
    (Length(Trim(edtNuweGebruikersnaam.Text)) > 30) then
  begin
    ShowMessage('Die gebruikersnaam moet tussen 1 en 30 karakters wees.');
    Exit;
  end;
  if Length(edtNuweWagwoord.Text) < 4 then
  begin
    ShowMessage('Die wagwoord moet minstens 4 karakters wees.');
    Exit;
  end;
  if edtNuweWagwoord.Text <> edtBevestig.Text then
  begin
    ShowMessage('Die twee wagwoorde stem nie ooreen nie.');
    Exit;
  end;
  if dmDatabase.RegisterUser(edtNuweGebruikersnaam.Text,
    edtNuweWagwoord.Text, cboRol.Text, Fout) then
  begin
    ShowMessage('Die gebruiker is suksesvol geregistreer.');
    edtGebruikersnaam.Text := Trim(edtNuweGebruikersnaam.Text);
    edtNuweGebruikersnaam.Clear;
    edtNuweWagwoord.Clear;
    edtBevestig.Clear;
    pgcAccount.ActivePage := tabTekenIn;
    edtWagwoord.SetFocus;
  end
  else
    ShowMessage(Fout);
end;

procedure TfrmLogin.mnuTekenInClick(Sender: TObject);
begin
  pgcAccount.ActivePage := tabTekenIn;
end;

procedure TfrmLogin.mnuRegistreerClick(Sender: TObject);
begin
  pgcAccount.ActivePage := tabRegistreer;
end;

procedure TfrmLogin.mnuSluitClick(Sender: TObject);
begin
  Close;
end;

end.
