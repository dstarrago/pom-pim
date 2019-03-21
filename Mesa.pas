unit Mesa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Spin, MPlayer, jpeg;

type
  TCampo = class(TForm)
    Paleta1: TShape;
    Paleta2: TShape;
    Bola: TShape;
    Bordes: TShape;
    Puntuacion1: TLabel;
    Puntuacion2: TLabel;
    Timer1: TTimer;
    Shape1: TShape;
    Shape2: TShape;
    Salida1: TSpeedButton;
    Salida2: TSpeedButton;
    Label3: TLabel;
    SonidoPaleta: TMediaPlayer;
    SonidoBandas: TMediaPlayer;
    SonidoGol: TMediaPlayer;
    SonidoASacar: TMediaPlayer;
    SonidoSaque: TMediaPlayer;
    JugadorPC: TTimer;
    OtroPC: TTimer;
    SonidoTriunfo: TMediaPlayer;
    Indicacion: TLabel;
    SonidoPortada: TMediaPlayer;
    Score1: TLabel;
    Score2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Portada: TImage;
    Jugada: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    PuntosJugados: TLabel;
    Label9: TLabel;

    // Manipulador del evento creación del programa
    // Se utiliza para inicializar las variables
    procedure FormCreate(Sender: TObject);

    // Manipulador del evento tecla presionada
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    // Manipulador del evento tecla liberada
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    // Manipulador del evento clic del reloj
    procedure Timer1Timer(Sender: TObject);  // Aquí está el funcionamiento del universo
    procedure Salida1Click(Sender: TObject);
    procedure Salida2Click(Sender: TObject);
    procedure JugadorPCTimer(Sender: TObject);
    procedure BordesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure OtroPCTimer(Sender: TObject);
    procedure SonidoTriunfoNotify(Sender: TObject);
    procedure SonidoGolNotify(Sender: TObject);
    procedure SonidoPortadaNotify(Sender: TObject);
    procedure PortadaProgress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
      const Msg: String);
    procedure FormDestroy(Sender: TObject);
    procedure PortadaClick(Sender: TObject);
  public
    // Atributos de las Paletas

    A_Presionada: boolean;  // Jugador 1 sube paleta
    Z_Presionada: boolean;  // Jugador 1 baja paleta
    Arriba_Presionada: boolean;  // Jugador 2 sube paleta
    Abajo_Presionada: boolean;   // Jugador 2 baja paleta

    // Dirección 0  no se mueve
    //           1  baja
    //          -1  sube

    DireccionPaleta: array[1..2] of integer; // Dirección de la paleta de los jugadores
    Velocidad: array[1..2] of integer; // Velocidad de la paleta de los jugadores
    Aceleracion: array[1..2] of integer; // Aceleración de la paleta de los jugadores

    // Atributos de la Bola

    BolaVelocidad_X, BolaVelocidad_Y: integer; // Velocidad de la bola
    Spin: integer;  // Velocidad de rotación de la bola

    // Atributos de los jugadores
    Puntos1, Puntos2: integer;   // Puntuacion de los jugadores
    Score: array[1..2] of integer;

    // Atributos del Partido
    QuienSaca: integer;   // 1 jugador de la izquierda y 2 el de la derecha
    Saque: boolean;       // Indica si es momento de hacer el saque
    Gol: boolean;         // Indica si hay un gol
    PuntosMax: integer;   // Representa la cantidad de puntos a jugar la mano
    Ritmo: integer;
    JuegoGanado: boolean; // Indica que algún jugador ha ganado el juego
    ValorJugada: integer; // Al hacer el gol se asigna este valor al score del goleador
    ComplejidadJugada: integer;
    HighScore: TStringList;

    // Atributos del jugador PC
    Key: array[1..2] of word;       // Tecla que tiene presionada
    ContadorSaque: integer;
    DemoraComienzoJuego: integer;

    // Otras variables
    MostrarCursor: boolean;
    Tocando: boolean;         // Indica si la música se está ejecutando

    // Calcula la componente vertical de la velocidad de la bola
    // cuando golpea con la paleta cóncava
    procedure CalculoComponenteY(Paleta: TShape);

    // Calculo del spin
    procedure CalcularSpinXChoqueBordes;
    procedure CalcularSpinXChoquePaletas(Paleta: TShape);
    procedure ChequeoTriunfo;
    procedure EstablecerVelocidadPaletas;
    procedure ActualizarPosicionPaletas;
    procedure PrepararSaque;
    procedure ActualizarCoordenadasBola;
    procedure ChequearGol;
    procedure RebotesConBandas;
    procedure ChoqueConPaletas;
    procedure ComenzarNuevoJuego;
    procedure Sacar(Paleta: TShape);
    function  IndicePaleta(Paleta: TShape): integer;
    function  Nivel: integer;
    procedure ManejarPC(Paleta: TShape);
    procedure ResetTeclado;
    procedure RescateBola;
    procedure MostrarAyuda;
    procedure MostrarOpciones;
    procedure QuitarPortada;
    procedure ChequearHighScore(Triunfador: integer);
    procedure MostrarHighScore;
    procedure OcultarPuntero;
    procedure MostrarPuntero;
    procedure PonerPausa;
    procedure QuitarPausa;
    procedure AlternarPausa;
    procedure DeterminarSalidaPropuesta;
    procedure MostrarAcercaDe;
  end;

var
  Campo: TCampo;

implementation

uses Math, UOpciones, Presentacion, Ayuda, HighScore, About;

const
  VelocidadSaque: array[1..3] of integer = (10, 15, 20);  //15
  VelocidadBola: array[1..3] of integer = (5, 10, 15);    //5
  ImpactoPaleta: array[1..3] of integer = (2, 3, 4);      //4
  ColorMesa         = $002C8054;
  RozamientoBordes  = 0.2;
  RozamientoPaletas = 0.2;
  PuntosMaxPredeterminada = 15;
  opHumano = 0;
  opPC     = 1;
  EsperaDelSaquePC = 20;   // Tiempo que espera la PC para sacar
  EsperaDelReclamo = 30; // Tiempo de espera para reclamar la bola
  ComandoArriba: array[1..2] of Word = (65, 38);
  ComandoAbajo:  array[1..2] of Word = (90, 40);
  TituloOriginal = 'Pom Pim';
  VelocidadLimite = 30;
  DemoraComienzoJuegoPredeterminado = 50;

{$R *.dfm}

procedure TCampo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 65 then
    begin
      A_Presionada := true;
      DireccionPaleta[1] := -1;
    end;
  if Key = 90 then
    begin
      Z_Presionada := true;
      DireccionPaleta[1] := 1;
    end;
  if Key = 38 then
    begin
      Arriba_Presionada := true;
      DireccionPaleta[2] := -1;
    end;
  if Key = 40 then
    begin
      Abajo_Presionada := true;
      DireccionPaleta[2] := 1;
    end;
  if (Key = 88) and Saque and (QuienSaca = 1)
    then Sacar (Paleta1);
  if (Key = 37) and Saque and (QuienSaca = 2)
    then Sacar(Paleta2);
  if Indicacion.Visible and (Key = 32)
    then QuitarPortada;
end;

procedure TCampo.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 65 then
    begin
      A_Presionada := false;
      Aceleracion[1] := 0;
      DireccionPaleta[1] := 0;
    end;
  if Key = 90 then
    begin
      Z_Presionada := false;
      Aceleracion[1] := 0;
      DireccionPaleta[1] := 0;
    end;
  if Key = 38 then
    begin
      Arriba_Presionada := false;
      Aceleracion[2] := 0;
      DireccionPaleta[2] := 0;
    end;
  if Key = 40 then
    begin
      Abajo_Presionada := false;
      Aceleracion[2] := 0;
      DireccionPaleta[2] := 0;
    end;
  if (Key = VK_F4) and not JuegoGanado
    then AlternarPausa;
  if Key = VK_F2
    then ComenzarNuevoJuego;
  if Key = VK_F1
    then MostrarAyuda;
  if Key = VK_F8
    then MostrarOpciones;
  if Key = VK_F9
    then MostrarHighScore;
  if Key = VK_F5
    then MostrarAcercaDe;
end;

procedure TCampo.Timer1Timer(Sender: TObject);
begin
  ChequeoTriunfo;
  if Gol and not JuegoGanado
    then RescateBola;
  if not JuegoGanado then
    begin
      EstablecerVelocidadPaletas;
      ActualizarPosicionPaletas;
      if Saque
        then PrepararSaque
        else
          if not Gol
            then
              begin
                ActualizarCoordenadasBola;
                ChequearGol;
                RebotesConBandas;
                if not Gol
                  then ChoqueConPaletas;
              end;
    end;
end;

procedure TCampo.FormCreate(Sender: TObject);
begin
  MostrarCursor := true;
  SonidoPortada.Notify := true;
  Bordes.Brush.Color := ColorMesa;
  PuntosMax := PuntosMaxPredeterminada;
  HighScore := TStringList.Create;
  //HighScore.Sorted := true;
  //HighScore.LoadFromFile('hspts.dat');
  ComenzarNuevoJuego;
end;

procedure TCampo.CalculoComponenteY(Paleta: TShape);
var
  DeltaY: integer;
  DeltaBola: integer;
begin
  // Sumar velocidad de la paleta a la de la bola
  BolaVelocidad_Y := BolaVelocidad_Y +
    DireccionPaleta[IndicePaleta(Paleta)] * Aceleracion[IndicePaleta(Paleta)];
  // Verificar si la bola golpea en la curvatura de la paleta...
  DeltaBola := Paleta.Top - Bola.Top + (Paleta.Height - Bola.Height) div 2;
  DeltaY := Round(abs(DeltaBola) - Paleta.Height / 6);
  if DeltaY > 0            // La bola golpeó en la curvatura de la paleta
    then BolaVelocidad_Y := BolaVelocidad_Y +
         Round(Paleta.Tag *  sign(DeltaBola) * 3 *
         BolaVelocidad_X * DeltaY / Paleta.Height);
end;

procedure TCampo.CalcularSpinXChoqueBordes;
begin
  Spin := Spin + Round(BolaVelocidad_Y * RozamientoBordes);
  if abs(Spin) >= abs(BolaVelocidad_Y)
    then Spin := sign(Spin) * abs(BolaVelocidad_Y);
  BolaVelocidad_Y := Spin - BolaVelocidad_Y;
  ValorJugada := ValorJugada + abs(BolaVelocidad_Y) + abs(Spin);
  Jugada.Caption := IntToStr(Round(ValorJugada / PuntosMax));
end;

procedure TCampo.Salida1Click(Sender: TObject);
begin
  QuienSaca := 1;
end;

procedure TCampo.Salida2Click(Sender: TObject);
begin
  QuienSaca := 2;
end;

procedure TCampo.ChequeoTriunfo;
begin
  if Puntos1 = PuntosMax  // Ganó el Amarillo
    then
      begin
        if not Tocando
          then
            begin
              SonidoGol.Notify := true;
              Tocando := true;
              ChequearHighScore(1);
            end;
        JuegoGanado := true;
        inc(Ritmo);
        if Ritmo = 4
          then Shape1.Brush.Color := clGreen;
        if Ritmo = 5
          then
            begin
              Shape1.Brush.Color := clYellow;
              Ritmo := 0;
            end;
      end;

  if Puntos2 = PuntosMax  // Ganó el Rojo
    then
      begin
        if not Tocando
          then
            begin
              SonidoGol.Notify := true;
              Tocando := true;
              ChequearHighScore(2);
            end;
        JuegoGanado := true;
        inc(Ritmo);
        if Ritmo = 4
          then Shape2.Brush.Color := clWhite;
        if Ritmo = 5
          then
            begin
              Shape2.Brush.Color := clRed;
              Ritmo := 0;
            end;
      end;
end;

procedure TCampo.EstablecerVelocidadPaletas;
begin
  Velocidad[1] := VelocidadBola[Nivel] + Aceleracion[1] * 4;
  Velocidad[2] := VelocidadBola[Nivel] + Aceleracion[2] * 4;
end;

procedure TCampo.ActualizarPosicionPaletas;
begin
  if A_Presionada
    then
      begin
        Paleta1.Top := Paleta1.Top - Velocidad[1];
        if Paleta1.Top < Bordes.Top
          then
            begin
              Paleta1.Top := Bordes.Top;
              Aceleracion[1] := 0;
              DireccionPaleta[1] := 0;
            end
          else inc(Aceleracion[1]);
      end;
  if Z_Presionada
    then
      begin
        Paleta1.Top := Paleta1.Top + Velocidad[1];
        if Paleta1.Top + Paleta1.Height > Bordes.Top + Bordes.Height
          then
            begin
              Paleta1.Top := Bordes.Top + Bordes.Height - Paleta1.Height;
              Aceleracion[1] := 0;
              DireccionPaleta[1] := 0;
            end
          else inc(Aceleracion[1]);
      end;
  if Arriba_Presionada
    then
      begin
        Paleta2.Top := Paleta2.Top - Velocidad[2];
        if Paleta2.Top < Bordes.Top
          then
            begin
              Paleta2.Top := Bordes.Top;
              Aceleracion[2] := 0;
              DireccionPaleta[2] := 0;
            end
          else inc(Aceleracion[2]);
      end;
  if Abajo_Presionada
    then
      begin
        Paleta2.Top := Paleta2.Top + Velocidad[2];
        if Paleta2.Top + Paleta2.Height > Bordes.Top + Bordes.Height
          then
            begin
              Paleta2.Top := Bordes.Top + Bordes.Height - Paleta2.Height;
              Aceleracion[2] := 0;
              DireccionPaleta[2] := 0;
            end
          else inc(Aceleracion[2]);
      end;
end;

procedure TCampo.PrepararSaque;
begin
  if QuienSaca = 1
    then
      begin
        Bola.Left := Paleta1.Left + Paleta1.Width;
        Bola.Top  := Paleta1.Top + (Paleta1.Height - Bola.Height) div 2;
      end
    else
      begin
        Bola.Left := Paleta2.Left - Bola.Width;
        Bola.Top  := Paleta2.Top + (Paleta2.Height - Bola.Height) div 2;
      end;
end;

procedure TCampo.ActualizarCoordenadasBola;
begin
  // Se actualizan las coordenadas de la bola
  Bola.Left := Bola.Left + BolaVelocidad_X;
  Bola.Top  := Bola.Top  + BolaVelocidad_Y;
end;

procedure TCampo.ChequearGol;
begin
  // ¿La bola paso la Meta derecha?     Gooooooool
  if Bola.Left + Bola.Width >= Bordes.Left + Bordes.Width
    then
      begin
        SonidoGol.Play;
        Gol := true;
        inc(Puntos1);
        Puntuacion1.Caption := IntToStr(Puntos1);
        ValorJugada := ValorJugada + abs(BolaVelocidad_X) + abs(Spin);
        Jugada.Caption := IntToStr(Round(ValorJugada / PuntosMax));
        Score[1] := Score[1] + Round(ValorJugada / PuntosMax);
        Score1.Caption := IntToStr(Score[1]);
        BolaVelocidad_X := 0;
        BolaVelocidad_Y := 0;
        Bola.Left := Bordes.Left + Bordes.Width - Bola.Width;
        QuienSaca := 1;
        Spin := 0;
        ComplejidadJugada := 1;
      end;

  // ¿La bola paso la Meta izquierda?   Gooooooool
  if Bola.Left <= Bordes.Left
    then
      begin
        SonidoGol.Play;
        BolaVelocidad_X := 0;
        BolaVelocidad_Y := 0;
        Bola.Left := Bordes.Left;
        inc(Puntos2);
        Puntuacion2.Caption := IntToStr(Puntos2);
        QuienSaca := 2;
        Gol := true;
        ValorJugada := ValorJugada + abs(BolaVelocidad_X) + abs(Spin);
        Jugada.Caption := IntToStr(Round(ValorJugada / PuntosMax));
        Score[2] := Score[2] + Round(ValorJugada / PuntosMax);
        Score2.Caption := IntToStr(Score[2]);
        Spin := 0;
        ComplejidadJugada := 1;
      end;
end;

procedure TCampo.RebotesConBandas;
begin
  // ¿La bola chocó con la banda superior?
  if Bola.Top <= Bordes.Top
    then
      begin
        SonidoBandas.Play;
        Bola.Top := Bordes.Top;
        CalcularSpinXChoqueBordes; // Cálculo de la componente Y de velocidad
      end;

  // ¿La bola chocó con la banda inferior?
  if Bola.Top + Bola.Height >= Bordes.Top + Bordes.Height
    then
      begin
        SonidoBandas.Play;
        Bola.Top := Bordes.Top + Bordes.Height - Bola.Height;
        CalcularSpinXChoqueBordes; // Cálculo de la componente Y de velocidad
      end;
end;

procedure TCampo.ChoqueConPaletas;
begin
  // ¿La bola chocó con la Paleta derecha?
  if (Bola.Left + Bola.Width >= Paleta2.Left) and
     (Bola.Top >= Paleta2.Top - Bola.Height) and
     (Bola.Top <= Paleta2.Top + Paleta2.Height)
    then
      begin
        SonidoPaleta.Play;
        Bola.Left := Paleta2.Left - Bola.Width;
        CalcularSpinXChoquePaletas(Paleta2);
        CalculoComponenteY(Paleta2);
        ValorJugada := ValorJugada + abs(BolaVelocidad_X) + abs(Spin);
        Jugada.Caption := IntToStr(Round(ValorJugada / PuntosMax));
      end;

  // ¿La bola chocó con la Paleta izquierda?
  if (Bola.Left <= Paleta1.Left + Paleta1.Width) and
     (Bola.Top >= Paleta1.Top - Bola.Height) and
     (Bola.Top <= Paleta1.Top + Paleta1.Height)
    then
      begin
        SonidoPaleta.Play;
        Bola.Left := Paleta1.Left + Paleta1.Width;
        CalcularSpinXChoquePaletas(Paleta1);
        CalculoComponenteY(Paleta1);
        ValorJugada := ValorJugada + abs(BolaVelocidad_X) + abs(Spin);
        Jugada.Caption := IntToStr(Round(ValorJugada / PuntosMax));
      end;
end;

procedure TCampo.ComenzarNuevoJuego;
begin
  Saque := true;
  Gol := False;
  DeterminarSalidaPropuesta;
  Salida1.Visible := true;
  Salida2.Visible := true;
  if assigned(UOpciones.Opciones)
    then UOpciones.Opciones.SpinButton1.Enabled := true;
  Paleta1.Top := Bordes.Top + (Bordes.Height - Paleta1.Height) div 2;
  Paleta2.Top := Paleta1.Top;
  Puntos1 := 0;
  Puntos2 := 0;
  Puntuacion1.Caption := '00';
  Puntuacion2.Caption := '00';
  Spin := 0;
  Shape1.Brush.Color := clYellow;
  Shape2.Brush.Color := clRed;
  SonidoTriunfo.Notify := false;
  SonidoTriunfo.Stop;
  SonidoTriunfo.StartPos := 0;
  SonidoGol.StartPos := 0;
  Tocando := false;
  JuegoGanado := false;
  Score[1] := 0;
  Score[2] := 0;
  Score1.Caption := '0';
  Score2.Caption := '0';
  ValorJugada := 0;
  Jugada.Caption := IntToStr(ValorJugada);
  ComplejidadJugada := 1;
  DemoraComienzoJuego := DemoraComienzoJuegoPredeterminado;
end;

procedure TCampo.Sacar(Paleta: TShape);
begin
  SonidoSaque.Play;
  BolaVelocidad_X := - Paleta.Tag * VelocidadSaque[Nivel];
  BolaVelocidad_Y := DireccionPaleta[QuienSaca] * (VelocidadSaque[Nivel] + Aceleracion[QuienSaca]);
  Saque := false;
  Salida1.Visible := false;
  Salida2.Visible := false;
  UOpciones.Opciones.SpinButton1.Enabled := false;
end;

function TCampo.IndicePaleta(Paleta: TShape): integer;
begin
  if Paleta = Paleta1
    then Result := 1
    else Result := 2;
end;

procedure TCampo.CalcularSpinXChoquePaletas(Paleta: TShape);
begin
  Spin := Spin + Round(BolaVelocidad_X * RozamientoPaletas);
  if abs(Spin) >= abs(BolaVelocidad_X)
    then Spin := sign(Spin) * abs(BolaVelocidad_X);
  BolaVelocidad_X := Spin - BolaVelocidad_X - Paleta.Tag * ImpactoPaleta[Nivel];
  if abs(BolaVelocidad_X) > VelocidadLimite
    then BolaVelocidad_X := VelocidadLimite * sign(BolaVelocidad_X);
end;

function TCampo.Nivel: integer;
begin
  Result := Opciones.Niveles.ItemIndex + 1;
end;

procedure TCampo.JugadorPCTimer(Sender: TObject);
begin
  ManejarPC(Paleta1);
end;

procedure TCampo.BordesMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  OcultarPuntero;
end;

procedure TCampo.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  MostrarPuntero;
end;

procedure TCampo.ManejarPC(Paleta: TShape);
var
  PosPaleta: integer;
  PaletaIndex: integer;
begin
  PaletaIndex := IndicePaleta(Paleta);
  // Hace el saque
  if Saque and Timer1.Enabled and (QuienSaca = PaletaIndex)
    then
      begin
        inc(ContadorSaque);
        // Escoje una direccion y empieza a mover la paleta
        if random < 0.5
          then
            begin
              Key[PaletaIndex] := ComandoArriba[PaletaIndex];
              FormKeyDown(Self, Key[PaletaIndex], []);
            end
          else
            begin
              Key[PaletaIndex] := ComandoAbajo[PaletaIndex];
              FormKeyDown(Self, Key[PaletaIndex], []);
            end;
        if ContadorSaque > EsperaDelSaquePC + DemoraComienzoJuego
          then
            begin
              Sacar(Paleta);
              ContadorSaque := 0;
              DemoraComienzoJuego := 0;
              FormKeyUp(Self, Key[PaletaIndex], []);
            end;
      end;

  PosPaleta := Paleta.Top + Paleta.Height div 2;
  if (Bola.Top >= PosPaleta - 2 * Bola.Height) and
     (Bola.Top <= PosPaleta + Bola.Height)
    then
      begin
        FormKeyUp(Self, Key[PaletaIndex], []);
        Key[PaletaIndex] := 0;
      end
    else
      if BolaVelocidad_X * Paleta.Tag > 0
        then  //  Perseguir la bola con la paleta
          begin
            if Bola.Top < PosPaleta - 2 * Bola.Height
              then
                begin
                  if Key[PaletaIndex] <> ComandoArriba[PaletaIndex]
                    then
                      begin
                        FormKeyUp(Self, Key[PaletaIndex], []);
                        Key[PaletaIndex] := ComandoArriba[PaletaIndex];
                        FormKeyDown(Self, Key[PaletaIndex], []);
                      end
                end
              else
                if Bola.Top > PosPaleta + Bola.Height
                  then
                    begin
                      if Key[PaletaIndex] <> ComandoAbajo[PaletaIndex]
                        then
                          begin
                            FormKeyUp(Self, Key[PaletaIndex], []);
                            Key[PaletaIndex] := ComandoAbajo[PaletaIndex];
                            FormKeyDown(Self, Key[PaletaIndex], []);
                          end
                    end;
          end;
end;

procedure TCampo.OtroPCTimer(Sender: TObject);
begin
  ManejarPC(Paleta2);
end;


procedure TCampo.SonidoTriunfoNotify(Sender: TObject);
begin
  if Tocando
    then
      begin
        SonidoTriunfo.Play;
        SonidoTriunfo.Notify := true;
      end;
end;

procedure TCampo.SonidoGolNotify(Sender: TObject);
begin
  if Tocando
    then
      begin
        SonidoTriunfo.Notify := true;
        SonidoTriunfo.Play;
      end;
end;

procedure TCampo.ResetTeclado;
var
  Key: word;
begin
  Key := 65;
  FormKeyUp(Self, Key, []);
  Key := 90;
  FormKeyUp(Self, Key, []);
  Key := 38;
  FormKeyUp(Self, Key, []);
  Key := 40;
  FormKeyUp(Self, Key, []);
end;

procedure TCampo.RescateBola;
begin
  inc(ContadorSaque);
  if ContadorSaque > EsperaDelReclamo
    then
      begin
        SonidoASacar.Play;
        Saque := true;
        Gol := False;
        ContadorSaque := 0;
        ValorJugada := 0;
        Jugada.Caption := IntToStr(ValorJugada);
      end;
end;

procedure TCampo.MostrarAyuda;
begin
  PonerPausa;
  OcultarPuntero;
  FAyuda.ShowModal;
  ResetTeclado;
  QuitarPausa;
  MostrarPuntero;
end;

procedure TCampo.MostrarOpciones;
begin
  PonerPausa;
  MostrarPuntero;
  Opciones.ShowModal;
  if Opciones.Jugador1.ItemIndex = opHumano
    then JugadorPC.Enabled := false
    else JugadorPC.Enabled := true;
  if Opciones.Jugador2.ItemIndex = opHumano
    then OtroPC.Enabled := false
    else OtroPC.Enabled := true;
  DeterminarSalidaPropuesta;
  ResetTeclado;
  QuitarPausa;
  OcultarPuntero;
end;

procedure TCampo.QuitarPortada;
begin
  Portada.Visible := false;
  Indicacion.Visible := false;
  Paleta1.Visible := true;
  Paleta2.Visible := true;
  Bordes.Visible := true;
  Bola.Visible := true;
  SonidoPortada.Stop;
  OcultarPuntero;
end;

procedure TCampo.SonidoPortadaNotify(Sender: TObject);
begin
  QuitarPortada;
end;

procedure TCampo.PortadaProgress(Sender: TObject; Stage: TProgressStage;
  PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
  const Msg: String);
begin
  if Stage = psEnding
    then SonidoPortada.Play;
end;

function Comparacion(List: TStringList; Index1, Index2: Integer): Integer; //stdcall;
begin
  Result := StrToInt(List.Strings[Index2]) - StrToInt(List.Strings[Index1]);
end;

procedure TCampo.ChequearHighScore(Triunfador: integer);
var
  LugarPizarra: integer;
  i: integer;
  R: TRect;
begin
  HighScore.LoadFromFile('hspts.dat');
  FHighScore.Nombres.Items.LoadFromFile('hsnom.dat');
  HighScore.Append(IntToStr(Score[Triunfador]));
  HighScore.CustomSort(Comparacion);
  LugarPizarra := HighScore.IndexOf(IntToStr(Score[Triunfador]));
  if HighScore.Count > 10
    then HighScore.Delete(10);
  FHighScore.Puntuaciones.Items.Clear;
  for i := 0 to pred(HighScore.Count) do
    FHighScore.Puntuaciones.Items.Insert(i, HighScore[i]);
  if LugarPizarra < 10
    then
      begin
        FHighScore.Nombres.Items.Insert(LugarPizarra, '');
        if FHighScore.Nombres.Items.Count > 10
          then FHighScore.Nombres.Items.Delete(10);
        FHighScore.Nombres.ItemIndex := LugarPizarra;
        R := FHighScore.Nombres.ItemRect(LugarPizarra);
        FHighScore.CaptarNombre.Width := R.Right - R.Left;
        FHighScore.CaptarNombre.Height := R.Bottom - R.Top;
        FHighScore.CaptarNombre.Left := FHighScore.Nombres.Left + R.Left;
        FHighScore.CaptarNombre.Top := FHighScore.Nombres.Top + R.Top;
        FHighScore.CaptarNombre.Text := '';
        FHighScore.CaptarNombre.Visible := true;
        HighScore.SaveToFile('hspts.dat');
        Bordes.OnMouseMove := nil;
        MostrarPuntero;
        FHighScore.Show;
        FHighScore.CaptarNombre.SetFocus;
      end;
end;

procedure TCampo.MostrarHighScore;
var
  i: integer;
begin
  PonerPausa;
  Bordes.OnMouseMove := nil;
  HighScore.LoadFromFile('hspts.dat');
  FHighScore.Puntuaciones.Items.Clear;
  for i := 0 to pred(HighScore.Count) do
    FHighScore.Puntuaciones.Items.Insert(i, HighScore[i]);
  FHighScore.Nombres.Items.LoadFromFile('hsnom.dat');
  MostrarPuntero;
  FHighScore.ShowModal;
  QuitarPausa;
end;


procedure TCampo.FormDestroy(Sender: TObject);
begin
  HighScore.Free;
end;

procedure TCampo.MostrarPuntero;
begin
  if not MostrarCursor
    then
      begin
        MostrarCursor := true;
        ShowCursor(true);
      end;
end;

procedure TCampo.OcultarPuntero;
begin
  if MostrarCursor
    then
      begin
        MostrarCursor := false;
        ShowCursor(false);
      end;
end;

procedure TCampo.PonerPausa;
begin
  Timer1.Enabled := false;
  Caption := TituloOriginal + ' -pausado';
end;

procedure TCampo.QuitarPausa;
begin
  Timer1.Enabled := true;
  Caption := TituloOriginal;
end;

procedure TCampo.AlternarPausa;
begin
  if Timer1.Enabled
    then PonerPausa
    else QuitarPausa;
end;

procedure TCampo.PortadaClick(Sender: TObject);
begin
  QuitarPortada;
end;

procedure TCampo.DeterminarSalidaPropuesta;
begin
  if OtroPC.Enabled
    then
      begin
        Salida1.Down := true;
        QuienSaca := 1;
      end
    else
      begin
        Salida2.Down := true;
        QuienSaca := 2;
      end;
end;

procedure TCampo.MostrarAcercaDe;
begin
  PonerPausa;
  MostrarPuntero;
  Acerca.ShowModal;
  ResetTeclado;
  QuitarPausa;
  OcultarPuntero;
end;

end.
