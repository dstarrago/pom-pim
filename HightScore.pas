unit HightScore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TForm1 = class(TForm)
    Pizarra: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Pizarra.ColWidths[0] := 20;
  Pizarra.ColWidths[1] := 60;
  Pizarra.ColWidths[2] := 400;
  Pizarra.Cells[0,0] := 'Lugar';
  Pizarra.Cells[0,1] := 'Score';
  Pizarra.Cells[0,2] := 'Jugador';
end;

end.
