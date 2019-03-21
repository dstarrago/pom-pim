unit Presentacion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TPortada = class(TForm)
    Label1: TLabel;
    Shape1: TShape;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label2: TLabel;
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Portada: TPortada;

implementation

{$R *.dfm}

  uses Mesa;

procedure TPortada.FormClick(Sender: TObject);
begin
  close;
end;

end.
