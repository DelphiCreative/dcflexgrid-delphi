program DCFlexGridDemo;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
