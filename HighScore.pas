unit HighScore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, jpeg;

type
  TFHighScore = class(TForm)
    Puntuaciones: TListBox;
    Nombres: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Lugares: TListBox;
    Panel3: TPanel;
    CaptarNombre: TEdit;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CaptarNombreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FHighScore: TFHighScore;

implementation

{$R *.dfm}

uses Mesa;

procedure TFHighScore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with Campo do
    begin
      Bordes.OnMouseMove := BordesMouseMove;
      ResetTeclado;
      OcultarPuntero;
    end;
end;

procedure TFHighScore.CaptarNombreKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13
    then
      begin
        Nombres.Items.Strings[Nombres.ItemIndex] := CaptarNombre.Text;
        CaptarNombre.Visible := false;
        Nombres.Items.SaveToFile('hsnom.dat');
        Nombres.ItemIndex := -1;
      end;
end;

procedure TFHighScore.FormShow(Sender: TObject);
begin
  Nombres.Enabled := false;
  Puntuaciones.Enabled := false;
end;

procedure TFHighScore.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 32 then close;
end;

end.
