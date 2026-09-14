program PAT_p;

uses
  Vcl.Forms,
  PATlogin_u in 'PATlogin_u.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
