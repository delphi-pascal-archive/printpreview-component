program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  uMini in 'uMini.pas' {Fmini},
  Main in 'Main.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFmini, Fmini);
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
