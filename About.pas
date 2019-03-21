unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAcerca = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Acerca: TAcerca;

implementation

{$R *.dfm}

uses Mesa;

procedure TAcerca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with Mesa.Campo do
    begin
      Bordes.OnMouseMove := BordesMouseMove;
      ResetTeclado;
      OcultarPuntero;
    end;
end;

procedure TAcerca.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 32 then close;
end;

end.
