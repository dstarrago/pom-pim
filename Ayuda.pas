unit Ayuda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFAyuda = class(TForm)
    RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAyuda: TFAyuda;

implementation

{$R *.dfm}

procedure TFAyuda.FormCreate(Sender: TObject);
begin
  RichEdit1.lines.LoadFromFile('Ayuda Pom Pim.rtf');
end;

end.
