
// http://www.nachocabanes.com/videojuegos/ipj/ipj05.php

(*----------------------------*)
(*  Intro a la programac de   *)
(*  juegos, por Nacho Cabanes *)
(*                            *)
(*    IPJ05P.PAS              *)
(*                            *)
(*  Cuarto ejemplo: juego del *)
(*  ahorcado (version basica) *)
(*                            *)
(*  Comprobado con:           *)
(*  - FreePascal 2.04 - WinXP *)
(*  - FreePascal 1.10 - Dos   *)
(*----------------------------*)
(* 
uses wingraph, wincrt;
*)
  (* Cambiar por "uses graph, crt;" bajo Dos *)

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

const NUMPALABRAS = 10;
const MAXINTENTOS = 5;
  (* No deberiamos modificar el numero maximo de intentos,
     porque vamos a dibujar 5 'cosas' cuando se equivoque *)
 
var
  palabra, intento, letras: string[80];
            (* La palabra a adivinar, la que *)
            (* el jugador 2 va consiguiendo y *)
            (* las letras que se han probado *)
 
  oportunidades: integer;     (* El numero de intentos permitido *)
  oportStr: string;           (* Y para convertirlo a cadena *)
  letra: char;                (* Cada letra que prueba el jug. dos *)
  i: integer;                 (* Para mirar cada letra, con 'for' *)
  acertado: boolean;          (* Si ha acertado alguna letra *)
 
  mensaje: string[80];        (* Los letreros que mostar en pantalla *)
 
const datosPalabras: array [1..NUMPALABRAS] of string= (
    'Alicante','Barcelona','Guadalajara','Madrid',
    'Toledo','Malaga','Zaragoza','Sevilla',
    'Valencia','Valladolid');
 
 
 procedure PrimerFallo;       (* Primer fallo: *)
 begin                        (* Dibujamos la 'plataforma' *)
   setcolor(13);
   line(20, 180,  120, 180);
 end;
 
 
 procedure SegundoFallo;       (* Segundo fallo: *)
 begin                         (* Dibujamos el 'palo vertical' *)
    setcolor(13);
   line(100, 180,  100, 125);
 end;
 
 
 procedure TercerFallo;       (* Tercer fallo: *)
 begin                        (* Dibujamos el 'palo superior' *)
   setcolor(13);
   line(100, 125,   70, 125);
 end;
 
 procedure CuartoFallo;       (* Cuarto fallo: *)
 begin                        (* Dibujamos la 'cuerda' *)
   setcolor(13);
   line(70, 125,   70, 130);
 end;
 
 
 procedure QuintoFallo;       (* Quinto fallo: *)
 begin
                              (* Dibujamos la 'persona' *)
   setcolor(12);
        (* Cabeza *)
   circle(70, 138,   8);
        (* Tronco *)
   line(70, 146,   70, 160);
        (* Brazos *)
   line(50, 150,  90, 150);
        (* Piernas *)
   line(70, 160,   60, 175);
   line(70, 160,   80, 175);
 end;
 
 
 
 
var
  gd,gm: smallint;
  error : integer;
 
 
BEGIN
  gd := D8bit;
  gm := m640x480;
  (* Si falla bajo Dos, probar gm:=m320x200; *)
  initgraph(gd, gm, '');
 
                               (* Intentamos entrar a modo grafico *)
  error := graphResult;
  if error <> grOk then
    begin
    writeLn('No se pudo entrar a modo grafico');
    writeLn('Error encontrado: '+ graphErrorMsg(error) );
    halt(1);
    end;
 
 
                             (* Si todo ha ido bien: empezamos *)
  randomize;                 (* Valores iniciales *)
  palabra := datosPalabras[ round(random * NUMPALABRAS) + 1 ];
  oportunidades := MAXINTENTOS;
 
  letras := '';
 
           (* Relleno con _ y ' ' lo que ve Jug. 2 *)
  intento := palabra;
  for i:=1 to length(palabra) do
    if palabra[i] = ' ' then
      intento[i] := ' '
    else
      intento[i] := '_';
 
            (* Parte repetitiva: *)
  repeat
    clearDevice;
 
    (* Dibujo lo que corresponde del 'patibulo' *)
    if (oportunidades <= 4) then PrimerFallo;
    if (oportunidades <= 3) then SegundoFallo;
    if (oportunidades <= 2) then TercerFallo;
    if (oportunidades <= 1) then CuartoFallo;
 
                               (* Digo cuantos intentos le quedan *)
    setColor(15);
    str(oportunidades, oportStr);
    outTextXY(80, 18, 'Te quedan '+oportStr+' intentos');
 
 
                                (* Las letras intentadas *)
    outTextXY(80, 32, intento);
 
    setColor(14);
    outTextXY(20, 72, 'Letras intentadas: '+letras);
 
                                 (* Y le pido otra letra *)
    outTextXY(20, 60, 'Que letra?');
 
    letra := readkey;
 
            (* A�ado esa letra a las tecleadas*)
    letras := letras + letra;
 
    acertado := false;           (* Miro a ver si ha acertado *)
    for i := 1 to length(palabra) do
      if lowercase(letra) = lowercase(palabra[i]) then
        begin
        intento[i] := palabra[i];
        acertado := true;
        end;
 
 
    if not acertado then    (* Si fall�, le queda un intento menos *)
      oportunidades := oportunidades - 1;
 
  until  (intento = palabra)   (* Hasta que acierte *)
    or (oportunidades=0);      (* o gaste sus oportunidades *)
 
 
                               (* Le felicito o le digo cual era *)
 
 
 
  setcolor(15);
  if intento = palabra then
    outTextXY(20, 100, 'Acertaste!')
  else
    begin
    outTextXY(20, 100, 'Lo siento.  Era: '+ palabra);
    QuintoFallo;
    end;
 
 
  readkey;
  closeGraph;
 
end.
