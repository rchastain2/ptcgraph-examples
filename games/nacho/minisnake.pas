
// http://www.nachocabanes.com/videojuegos/ipj/ipj08.php#pascal

program MiniSnake;

(*----------------------------*)
(*  Intro a la programac de   *)
(*  juegos, por Nacho Cabanes *)
(*                            *)
(*    IPJ08P.PAS              *)
(*                            *)
(*  Octavo ejemplo: juego de  *)
(*  'miniSerpiente'2          *)
(*                            *)
(*  Comprobado con:           *)
(*  - FreePascal 1.06 (Dos)   *)
(*  - FreePascal 2.0 -Windows *)
(*----------------------------*)
(*
uses wingraph, wincrt;
*)
  (* Cambiar por "uses wincrt, ..." bajo Windows *)
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
  (* Posiciones X e Y iniciales *)
const
  POS_X_INI = 17;
  POS_Y_INI = 11;
 
  INC_X_INI  = 1;
  INC_Y_INI  = 0;
 
  (* Pausa en milisegundos entre un 'fotograma' y otro *)
  PAUSA = 350;
 
  (* Teclas predefinidas *)
  TEC_ARRIBA = 'E';
  TEC_ABAJO  = 'X';
  TEC_IZQDA  = 'S';
  TEC_DCHA   = 'D';
 
var
  posX, posY: word;     (* Posicion actual *)
  incX, incY: integer;  (* Incremento de la posicion *)
 
  (* Terminado: Si ha chocado o comida todas las frutas *)
  terminado: boolean;
 
  (* La tecla pulsada *)
  tecla: char;
 
  (* Escala: relacion entre tamaño de mapa y de pantalla *)
const
  ESCALA = 10;
 
  (* Ancho y alto de los sprites *)
  ANCHOSPRITE = 10;
  ALTOSPRITE  = 10;
 
  (* Y el mapa que representa a la pantalla *)
  (* Como usaremos modo grafico de 320x200 puntos *)
  (* y una escala de 10, el tablero medira 32x20 *)
  MAXFILAS = 20;
  MAXCOLS = 33;//32;
 
  mapa: array[1..MAXFILAS, 1..MAXCOLS] of char = (
  'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
  'X                      X        X',
  'X    F                 X        X',
  'X               F      X   F    X',
  'X     XXXXX            X        X',
  'X     X                X        X',
  'X     X        X       X        X',
  'X     X        X       X     XXXX',
  'X              X       X        X',
  'X              X       X        X',
  'X              X       X        X',
  'X   F          X                X',
  'X              X                X',
  'X              X         F      X',
  'X      X            X           X',
  'X      X            X           X',
  'X      X       F     X          X',
  'X  F   X              X         X',
  'X      X              F         X',
  'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  );
 
 
const numFrutas:word  = 8;
 
 
  (* Nuestros sprites *)
 
type
  tipoSprite = array[1..ANCHOSPRITE,1..ALTOSPRITE] of byte;
                         (* El sprite en si: matriz de 10x10 bytes *)
 
const spriteLadrillo: tipoSprite =
   ((0,2,2,2,2,2,2,2,2,0),
    (2,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,1,2),
    (2,1,1,1,1,1,1,1,3,2),
    (2,1,1,1,1,1,1,3,3,2),
    (2,1,1,1,1,1,3,3,2,2),
    (2,2,2,2,2,2,2,2,2,0)
   );
 
 const spriteComida: tipoSprite =
   ((0,0,0,2,0,0,0,0,0,0),
 
    (0,0,2,2,0,0,2,2,0,0),
    (0,4,4,4,2,2,4,4,0,0),
    (4,4,4,4,4,2,4,4,4,0),
    (4,4,4,4,4,4,4,4,4,0),
    (4,4,4,4,4,4,4,4,4,0),
    (4,4,4,4,4,4,4,4,4,0),
    (4,4,4,4,4,4,4,4,4,0),
    (4,4,4,4,4,4,4,4,4,0),
    (0,4,4,4,4,4,4,4,0,0)
   );
 
const spriteJugador: tipoSprite =
   ((0,0,3,3,3,3,3,0,0,0),
    (0,3,1,1,1,1,1,3,0,0),
    (3,1,1,1,1,1,1,1,3,0),
    (3,1,1,1,1,1,1,1,3,0),
    (3,1,1,1,1,1,1,1,3,0),
    (3,1,1,1,1,1,1,1,3,0),
    (3,1,1,1,1,1,1,1,3,0),
    (3,1,1,1,1,1,1,1,3,0),
    (0,3,1,1,1,1,1,3,0,0),
    (0,0,3,3,3,3,3,0,0,0)
   );
 
 
(* -------------- Rutina de dibujar sprites -------------- *)
(* Simplemente dibuja un sprite definido anteriormente.    *)
(* Copia la sintaxis de "draw_sprite" de Allegro, pero es  *)
(* una rutina lenta, que solo usa Pascal puro, no seria    *)
(* adecuada en programas con muchos sprites                *)
procedure draw_sprite(imagen: tipoSprite; x, y: word);
var
  i,j: word;
begin
  for i := 1 to ANCHOSPRITE do
    for j := 1 to ALTOSPRITE do
    begin
    if imagen[j,i] <> 0 then
      putpixel(x+i-1, y+j-1, imagen[j,i]);
    end;
 
end;
 
 
 
(* -------------- Rutina de dibujar el fondo ------------- *)
 
procedure dibujaFondo;
var
  i, j: word;
begin
 
  clearDevice;
 
    for i:= 1 to MAXCOLS do
    for j := 1 to MAXFILAS do
      begin
      if mapa[j,i] = 'X' then
        draw_sprite(spriteLadrillo, (i-1)*ESCALA, (j-1)*ESCALA);
      if mapa[j,i] = 'F' then
        draw_sprite(spriteComida, (i-1)*ESCALA, (j-1)*ESCALA);
      end;
 
end;
 
 
(* ------------------------------------------------ *)
(*                                                  *)
(* -------------- Cuerpo del programa ------------- *)
var
  gd,gm: smallint;
  error : integer;
 
 
BEGIN
  gd := D8bit;
  gm := m320x200;
  initgraph(gd, gm, '');
   (* Si falla bajo Windows, probar gd:=0; gm:=0; *)
 
                               (* Intentamos entrar a modo grafico *)
  error := graphResult;
  if error <> grOk then
    begin
    writeLn('No se pudo entrar a modo grafico');
    writeLn('Error encontrado: '+ graphErrorMsg(error) );
    halt(1);
    end;
 
 
  (* ----------------------- Si todo ha ido bien: empezamos *)
 
  dibujaFondo;
 
            (* Valores iniciales *)
  posX := POS_X_INI;
  posY := POS_Y_INI;
 
  incX := INC_X_INI;
  incY := INC_Y_INI;
  (*
  UpdateGraph(UpdateOff);
  *)
            (* Parte repetitiva: *)
  repeat
    dibujaFondo;
    draw_sprite (spriteJugador, (posX-1)*ESCALA, (posY-1)*ESCALA);
 
    terminado := FALSE;
 
    (* Si paso por una fruta: la borro y falta una menos *)
    if (mapa[posY,posX] = 'F') then
      begin
      mapa[posY,posX] := ' ';
      numFrutas := numFrutas - 1;
      if (numFrutas = 0) then
      begin
        setColor(14);
        outTextXY( 100, 90, 'Ganaste!' );
        terminado := TRUE;
      end;
    end;
 
 
    (* Si choco con la pared, se acabo *)
    if (mapa[posY,posX] = 'X') then
      begin
      setColor(13);
      outTextXY( 100, 90, 'Chocaste!' );
      terminado := TRUE;
    end;
    (*
    UpdateGraph(UpdateNow);
    *)
    if terminado then break;
 
    (* Compruebo si se ha pulsado alguna tecla *)
    if keypressed then
        begin
        tecla := upcase(readkey);
 
        case tecla of
          TEC_ARRIBA:
              begin incX :=  0; incY := -1;  end;
          TEC_ABAJO:
              begin incX :=  0; incY :=  1;  end;
          TEC_IZQDA:
              begin incX := -1; incY :=  0;  end;
          TEC_DCHA:
              begin incX :=  1; incY :=  0;  end;
        end;
 
    end;
 
    posX := posX + incX;
    posY := posY + incY;
 
    (* Pequeña pausa antes de seguir *)
    delay ( PAUSA );
 
  until FALSE;  (* Repetimos indefininamente *)
                 (* (la condición de salida la comprobamos 'dentro') *)
 
  readkey;
  closegraph;
end.
