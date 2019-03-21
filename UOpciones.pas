unit UOpciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

type
  TOpciones = class(TForm)
    Niveles: TRadioGroup;
    OK: TButton;
    Jugador1: TRadioGroup;
    Jugador2: TRadioGroup;
    SpinButton1: TSpinButton;
    PuntosMaxLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Image2: TImage;
    procedure OKClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Opciones: TOpciones;

implementation

{$R *.dfm}

uses Mesa;

procedure TOpciones.OKClick(Sender: TObject);
begin
  Close;
end;

procedure TOpciones.SpinButton1DownClick(Sender: TObject);
begin
  with Campo do
    begin
      if PuntosMax > 1 then dec(PuntosMax);
      Opciones.PuntosMaxLabel.Caption := IntToStr(PuntosMax);
      PuntosJugados.Caption := Opciones.PuntosMaxLabel.Caption;
    end;
end;

procedure TOpciones.SpinButton1UpClick(Sender: TObject);
begin
  with Campo do
    begin
      inc(PuntosMax);
      Opciones.PuntosMaxLabel.Caption := IntToStr(PuntosMax);
      PuntosJugados.Caption := Opciones.PuntosMaxLabel.Caption;
    end;
end;

procedure TOpciones.FormCreate(Sender: TObject);
begin
  with Campo do
    begin
      Opciones.PuntosMaxLabel.Caption := IntToStr(PuntosMax);
      PuntosJugados.Caption := Opciones.PuntosMaxLabel.Caption;
    end;
end;

procedure TOpciones.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with Mesa.Campo do
    begin
      Bordes.OnMouseMove := BordesMouseMove;
      ResetTeclado;
      OcultarPuntero;
    end;
end;

end.
