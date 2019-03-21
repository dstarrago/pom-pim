program Pompim;

uses
  Forms,
  Mesa in 'Mesa.pas' {Campo},
  UOpciones in 'UOpciones.pas' {Opciones},
  Ayuda in 'Ayuda.pas' {FAyuda},
  HighScore in 'HighScore.pas' {FHighScore},
  About in 'About.pas' {Acerca};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCampo, Campo);
  Application.CreateForm(TOpciones, Opciones);
  Application.CreateForm(TFAyuda, FAyuda);
  Application.CreateForm(TFHighScore, FHighScore);
  Application.CreateForm(TAcerca, Acerca);
  Application.Run;
end.
