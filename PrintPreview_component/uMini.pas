unit uMini;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFmini = class(TForm)
    Panel1: TPanel;
    procedure Panel1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure Mini;
  end;

var
  Fmini: TFmini;

implementation

uses Unit1;

{$R *.dfm}

procedure TFmini.Panel1Click(Sender: TObject);
begin
hide;
Form1.show;
end;

procedure TFmini.FormCreate(Sender: TObject);
begin
setbounds(0,0,40,20);
panel1.tag := 0;
end;

procedure TFmini.Mini;
begin
Form1.Hide;
show;
bringtofront
end;

end.
