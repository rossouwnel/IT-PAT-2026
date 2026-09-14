unit PATlogin_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Winapi.Dwmapi, System.UITypes,
  Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TfrmLogin = class(TForm)
    pnl_login1: TPanel;
    lbl_login1: TLabel;
    lbl_login2: TLabel;
    pnl_login2: TPanel;
    pnl_inner: TPanel;
    edt_login1: TEdit;
    pnl_outer1: TPanel;
    btn_login1: TButton;
    pnl_outer2: TPanel;
    imgLogo: TImage;
    lbl_login3: TLabel;
    pnl_Register1: TPanel;
    lbl_register1: TLabel;
    pnl_register2: TPanel;
    pnl_inner2: TPanel;
    lbl_register2: TLabel;
    lbl_register3: TLabel;
    edt_login2: TEdit;
    btn_login2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lbl_login3Click(Sender: TObject);
    procedure lbl_register3Click(Sender: TObject);
    procedure btn_login1Click(Sender: TObject);
    procedure btn_login2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    edtRegisterUsername: TEdit;
    edtRegisterPassword: TEdit;
    edtRegisterConfirm: TEdit;
    btnRegister: TButton;
    procedure btnRegisterClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.btn_login1Click(Sender: TObject);
begin
  if Trim(edt_login1.Text) = '' then
  begin
    MessageDlg('Enter your username to continue.', mtInformation, [mbOK], 0);
    edt_login1.SetFocus;
    Exit;
  end;

  if not edt_login2.Visible then
  begin
    pnl_login2.Height := 190;
    pnl_inner.Height := 188;
    edt_login2.Visible := True;
    pnl_outer2.Visible := True;
    btn_login1.SetBounds(13, 108, 302, 33);
    btn_login1.Caption := 'SIGN IN';
    btn_login2.SetBounds(13, 148, 302, 25);
    btn_login2.Visible := True;
    edt_login2.SetFocus;
    Exit;
  end;

  if edt_login2.Text = '' then
  begin
    MessageDlg('Enter your password to continue.', mtInformation, [mbOK], 0);
    edt_login2.SetFocus;
    Exit;
  end;

  MessageDlg('Welcome to Fresh Count, ' + Trim(edt_login1.Text) + '!',
    mtInformation, [mbOK], 0);
end;

procedure TfrmLogin.btn_login2Click(Sender: TObject);
begin
  edt_login2.Visible := False;
  pnl_outer2.Visible := False;
  pnl_login2.Height := 140;
  pnl_inner.Height := 138;
  btn_login1.SetBounds(13, 80, 302, 33);
  btn_login1.Caption := 'CONTINUE';
  btn_login2.Visible := False;
  edt_login1.SetFocus;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  Caption := 'Fresh Count';
  Position := poScreenCenter;
  Constraints.MinWidth := 418;
  Constraints.MinHeight := 633;
  OnResize := FormResize;
  { lbl_Login1 }
  // aesthetic
  pnl_login1.ParentBackground := False;
  pnl_login1.Color := RGB(245, 241, 234);

  lbl_login1.Font.Name := 'Georgia';
  lbl_login1.Font.Size := 28;
  lbl_login1.Font.Style := [fsBold];
  lbl_login1.Font.Color := RGB(40, 44, 40);

  // text
  lbl_login1.Caption := 'Welcome to' + #13#10 + 'Fresh Count!';
  lbl_login1.Alignment := taCenter;

  // dynamic layout
  lbl_login1.AutoSize := True;
  lbl_login1.Left := (pnl_login1.Width - lbl_login1.Width) div 2;
  lbl_login1.Top := 40;

  { lbl_Login2 }
  // slogan
  lbl_login2.Caption := 'Inventory picked fresh daily.';
  lbl_login2.Transparent := True;
  lbl_login2.Font.Name := 'Arial';
  lbl_login2.Font.Size := 11;
  lbl_login2.Font.Color := RGB(115, 120, 115);

  // stem alignment
  lbl_login2.AutoSize := False;
  lbl_login2.Alignment := taCenter;
  lbl_login2.Width := lbl_login1.Width;
  lbl_login2.Left := lbl_login1.Left;

  // vertikale spas
  lbl_login2.Top := 165;

  { pnl_login2 }
  pnl_login2.ParentBackground := False;
  pnl_login2.Color := RGB(200, 200, 200);
  pnl_login2.Width := 330;
  pnl_login2.Height := 140;
  pnl_login2.Left := (pnl_login1.Width - pnl_login2.Width) div 2;
  pnl_login2.Top := lbl_login2.Top + lbl_login2.Height + 35;
  pnl_login2.BevelOuter := bvNone;
  pnl_login2.BevelInner := bvNone;
  pnl_login2.ParentDoubleBuffered := False;
  pnl_login2.DoubleBuffered := True;

  // inner panel
  pnl_inner.Parent := pnl_login2;
  pnl_inner.ParentBackground := False;
  pnl_inner.Color := RGB(252, 250, 248);
  pnl_inner.Width := 328;
  pnl_inner.Height := 138;
  pnl_inner.Left := 1;
  pnl_inner.Top := 1;
  pnl_inner.BevelOuter := bvNone;
  pnl_inner.BevelInner := bvNone;

  { pnl_Outer1 }
  pnl_outer1.Parent := pnl_inner;
  pnl_outer1.ParentBackground := False;
  pnl_outer1.Color := RGB(200, 200, 200);
  pnl_outer1.Width := 302;
  pnl_outer1.Height := 35;
  pnl_outer1.Left := 13;
  pnl_outer1.Top := 25;
  pnl_outer1.BevelOuter := bvNone;
  pnl_outer1.BevelInner := bvNone;

  { edt_Login1 }
  edt_login1.Parent := pnl_outer1;
  edt_login1.Color := RGB(255, 255, 255);
  edt_login1.Width := 300;
  edt_login1.Height := 33;
  edt_login1.Left := 1;
  edt_login1.Top := 1;
  edt_login1.BorderStyle := bsNone;
  edt_login1.Font.Name := 'Segoe UI';
  edt_login1.Font.Size := 13;

  // The Gray Placeholder Text
  edt_login1.BringToFront;
  edt_login1.Text := '';
  edt_login1.TextHint := ' Enter your username...';

  { btn_Login1 }
  btn_login1.Parent := pnl_inner;
  btn_login1.Width := 302;
  btn_login1.Height := 33;
  btn_login1.Left := 13;
  btn_login1.Top := 80;
  btn_login1.Caption := 'SIGN IN';
  btn_login1.Font.Name := 'Segoe UI';
  btn_login1.Font.Size := 10;
  btn_login1.Font.Style := [fsBold];
  btn_login1.Font.Color := clWhite;

  {logo}
  imgLogo.Parent := pnl_login1;
  imgLogo.Stretch := True;
  imgLogo.Proportional := True;

  imgLogo.Width := 190;
  imgLogo.Height := 190;

  imgLogo.Left := (pnl_login1.Width - imgLogo.Width) div 2;
  imgLogo.Top := 438;

  {login link}
  lbl_login3.Caption := 'Click here to register.';
  lbl_login3.Transparent := True;
  lbl_login3.Font.Name := 'Arial';
  lbl_login3.Font.Size := 11;
  lbl_login3.Font.Color := RGB(115, 120, 115);

  // stem alignment
  lbl_login3.AutoSize := False;
  lbl_login3.Alignment := taCenter;
  lbl_login3.Width := lbl_login1.Width;
  lbl_login3.Left := lbl_login1.Left;

  // vertikale spas
  lbl_login3.Top := 410;

  //Panel Register 1
  pnl_Register1.visible := false;

  pnl_Register1.ParentBackground := False;
  pnl_Register1.Color := RGB(245, 241, 234);

  //Lbl Register 1
  lbl_register1.Font.Name := 'Georgia';
  lbl_register1.Font.Size := 28;
  lbl_register1.Font.Style := [fsBold];
  lbl_register1.Font.Color := RGB(40, 44, 40);

  // text
  lbl_register1.Caption := 'Register at' + #13#10 + 'Fresh Count!';
  lbl_register1.Alignment := taCenter;

  // dynamic layout
  lbl_register1.AutoSize := True;
  lbl_register1.Left := (pnl_login1.Width - lbl_register1.Width) div 2;
  lbl_register1.Top := 40;

  // panel register 2
  pnl_register2.ParentBackground := False;
  pnl_register2.Color := RGB(200, 200, 200);
  pnl_register2.Width := 330;
  pnl_register2.Height := 280;
  pnl_register2.Left := (pnl_login1.Width - pnl_login2.Width) div 2;
  pnl_register2.Top := lbl_login2.Top + lbl_login2.Height + 35;
  pnl_register2.BevelOuter := bvNone;
  pnl_register2.BevelInner := bvNone;
  pnl_register2.ParentDoubleBuffered := False;
  pnl_register2.DoubleBuffered := True;

  //panel inner 2
  pnl_inner2.Parent := pnl_register2;
  pnl_inner2.ParentBackground := False;
  pnl_inner2.Color := RGB(252, 250, 248);
  pnl_inner2.Width := 328;
  pnl_inner2.Height := 278;
  pnl_inner2.Left := 1;
  pnl_inner2.Top := 1;
  pnl_inner2.BevelOuter := bvNone;
  pnl_inner2.BevelInner := bvNone;

  edtRegisterUsername := TEdit.Create(Self);
  edtRegisterUsername.Parent := pnl_inner2;
  edtRegisterUsername.SetBounds(14, 20, 300, 35);
  edtRegisterUsername.Font.Name := 'Segoe UI';
  edtRegisterUsername.Font.Size := 12;
  edtRegisterUsername.TextHint := ' Choose a username...';

  edtRegisterPassword := TEdit.Create(Self);
  edtRegisterPassword.Parent := pnl_inner2;
  edtRegisterPassword.SetBounds(14, 72, 300, 35);
  edtRegisterPassword.Font.Name := 'Segoe UI';
  edtRegisterPassword.Font.Size := 12;
  edtRegisterPassword.TextHint := ' Choose a password...';
  edtRegisterPassword.PasswordChar := '*';

  edtRegisterConfirm := TEdit.Create(Self);
  edtRegisterConfirm.Parent := pnl_inner2;
  edtRegisterConfirm.SetBounds(14, 124, 300, 35);
  edtRegisterConfirm.Font.Name := 'Segoe UI';
  edtRegisterConfirm.Font.Size := 12;
  edtRegisterConfirm.TextHint := ' Confirm your password...';
  edtRegisterConfirm.PasswordChar := '*';

  btnRegister := TButton.Create(Self);
  btnRegister.Parent := pnl_inner2;
  btnRegister.SetBounds(14, 184, 300, 38);
  btnRegister.Caption := 'CREATE ACCOUNT';
  btnRegister.Font.Name := 'Segoe UI';
  btnRegister.Font.Size := 10;
  btnRegister.Font.Style := [fsBold];
  btnRegister.OnClick := btnRegisterClick;

  { lbl_Register2 }
  // slogan
  lbl_register2.Caption := 'Inventory picked fresh daily.';
  lbl_register2.Transparent := True;
  lbl_register2.Font.Name := 'Arial';
  lbl_register2.Font.Size := 11;
  lbl_register2.Font.Color := RGB(115, 120, 115);

  // stem alignment
  lbl_register2.AutoSize := False;
  lbl_register2.Alignment := taCenter;
  lbl_register2.Width := lbl_login1.Width;
  lbl_register2.Left := lbl_login1.Left;

  // vertikale spas
  lbl_register2.Top := 165;

  {Back to login}
  lbl_register3.Caption := 'Click here to sign in.';
  lbl_register3.Transparent := True;
  lbl_register3.Font.Name := 'Arial';
  lbl_register3.Font.Size := 11;
  lbl_register3.Font.Color := RGB(115, 120, 115);

  // stem alignment
  lbl_register3.AutoSize := False;
  lbl_register3.Alignment := taCenter;
  lbl_register3.Width := lbl_login1.Width;
  lbl_register3.Left := lbl_login1.Left;

  // vertikale spas
  lbl_register3.Top := 525;

  { password field }
  edt_login2.Visible := false;

  pnl_outer2.Parent := pnl_inner;
  pnl_outer2.ParentBackground := False;
  pnl_outer2.Color := RGB(200, 200, 200);
  pnl_outer2.Width := 302;
  pnl_outer2.Height := 35;
  pnl_outer2.Left := 13;
  pnl_outer2.Top := 64;
  pnl_outer2.BevelOuter := bvNone;
  pnl_outer2.BevelInner := bvNone;
  pnl_outer2.Caption := '';
  pnl_outer2.Visible := False;

  edt_login2.Parent := pnl_outer2;
  edt_login2.Color := RGB(255, 255, 255);
  edt_login2.Width := 300;
  edt_login2.Height := 33;
  edt_login2.Left := 1;
  edt_login2.Top := 1;
  edt_login2.BorderStyle := bsNone;
  edt_login2.Font.Name := 'Segoe UI';
  edt_login2.Font.Size := 13;

  // The Gray Placeholder Text
  edt_login2.BringToFront;
  edt_login2.Text := '';
  edt_login2.TextHint := ' Enter your Password...';

  // btn login 2
  btn_login2.visible := false;
  btn_login2.caption := 'BACK';

 // btn_login2.Parent := pnl_login1;
  btn_login2.Parent := pnl_inner;
  btn_login2.SetBounds(13, 148, 302, 25);

  btn_login1.Caption := 'CONTINUE';
  lbl_login3.Cursor := crHandPoint;
  lbl_register3.Cursor := crHandPoint;
  FormResize(Self);
end;

procedure TfrmLogin.btnRegisterClick(Sender: TObject);
begin
  if Trim(edtRegisterUsername.Text) = '' then
  begin
    MessageDlg('Choose a username.', mtInformation, [mbOK], 0);
    edtRegisterUsername.SetFocus;
    Exit;
  end;

  if edtRegisterPassword.Text = '' then
  begin
    MessageDlg('Choose a password.', mtInformation, [mbOK], 0);
    edtRegisterPassword.SetFocus;
    Exit;
  end;

  if edtRegisterPassword.Text <> edtRegisterConfirm.Text then
  begin
    MessageDlg('The passwords do not match.', mtWarning, [mbOK], 0);
    edtRegisterConfirm.SetFocus;
    Exit;
  end;

  edt_login1.Text := Trim(edtRegisterUsername.Text);
  edt_login2.Text := '';
  pnl_Register1.Visible := False;
  pnl_login1.BringToFront;
  MessageDlg('Account created. Sign in to continue.', mtInformation,
    [mbOK], 0);
end;

procedure TfrmLogin.FormResize(Sender: TObject);
begin
  lbl_login1.Left := (pnl_login1.ClientWidth - lbl_login1.Width) div 2;
  lbl_login2.Left := (pnl_login1.ClientWidth - lbl_login2.Width) div 2;
  pnl_login2.Left := (pnl_login1.ClientWidth - pnl_login2.Width) div 2;
  lbl_login3.Left := (pnl_login1.ClientWidth - lbl_login3.Width) div 2;
  imgLogo.Left := (pnl_login1.ClientWidth - imgLogo.Width) div 2;
  pnl_Register1.SetBounds(0, 0, pnl_login1.ClientWidth,
    pnl_login1.ClientHeight);
  lbl_register1.Left := (pnl_Register1.ClientWidth - lbl_register1.Width) div 2;
  lbl_register2.Left := (pnl_Register1.ClientWidth - lbl_register2.Width) div 2;
  pnl_register2.Left := (pnl_Register1.ClientWidth - pnl_register2.Width) div 2;
  lbl_register3.Left := (pnl_Register1.ClientWidth - lbl_register3.Width) div 2;
end;

procedure TfrmLogin.lbl_login3Click(Sender: TObject);
begin
  pnl_Register1.Align := alClient;
  pnl_Register1.Visible := True;
  pnl_Register1.BringToFront;
  btn_login2.Visible := False;
  edtRegisterUsername.SetFocus;
end;

procedure TfrmLogin.lbl_register3Click(Sender: TObject);
begin
  pnl_Register1.Visible := False;
  pnl_login1.BringToFront;
end;



end.
