
(* https://github.com/ncabanes/swag-pascal/blob/master/TurboPascal-untested/graphics/7SegmentClock.pas *)

(*
  Category: SWAG Title: GRAPHICS ROUTINES
  Original name: 0084.PAS
  Description: 7 Segment clock
  Author: WIM VAN DER VEGT
  Date: 05-25-94  08:02
*)


{
Here's the source of a seven segment display useful to place at the end
of your autoexec if you also have the habit of turning your computer on
long before using it or want an expensive clock (works then best on a
66Mhz DX2 or Pentium).

Start it with SEGMENT 15 and a bright yellow clock will appear.
}

{---------------------------------------------------------}
{  Project : Seven Segment Display                        }
{  Auteur  : Ir. G.W. van der Vegt                        }
{---------------------------------------------------------}
{  Datum .tijd  Revisie                                   }
{  901025.2000  Creatie.                                  }
{---------------------------------------------------------}

PROGRAM Segment(INPUT,OUTPUT);

USES
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, DOS;

VAR
  cl : INTEGER;

{---------------------------------------------------------}
{----Routine to display ASCII as seven segment LED display}
{---------------------------------------------------------}

PROCEDURE Segments(nch,och : CHAR;xc,yc : INTEGER;scale : REAL);

{---------------------------------------------------------}
{----Types & const for graphical LED segment definition   }
{---------------------------------------------------------}

TYPE
  seg = ARRAY[1..7] OF Pointtype;

CONST
  Ver   : seg = ((x :   1; y :   0),(x :   0; y :   1),
                 (x :   0; y :   9),(x :   1; y :  10),
                 (x :   2; y :   9),(x :   2; y :   1),
                 (x :   1; y :   0)                   );

  Hor   : seg = ((x :   0; y :   1),(x :   1; y :   0),
                 (x :   9; y :   0),(x :  10; y :   1),
                 (x :   9; y :   2),(x :   1; y :   2),
                 (x :   0; y :   1)                   );

  DPdot : seg = ((x :   1; y :   1),(x :   2; y :   0),
                 (x :   2; y :   1),(x :   2; y :   2),
                 (x :   1; y :   2),(x :   0; y :   2),
                 (x :   1; y :   1)                   );

  SCDot : seg = ((x :   4; y :   4),(x :   4; y :   6),
                 (x :   6; y :   6),(x :   6; y :   4),
                 (x :   4; y :   4),(x :   4; y :   4),
                 (x :   4; y :   4)                   );

Type
  dir  = (vertical,horizontal,decimal,dot);

{---------------------------------------------------------}
{----Routine to hide/display a segment                    }
{---------------------------------------------------------}

PROCEDURE Dispsegm(dir : dir;show : BOOLEAN; m,dx,dy : REAL);

VAR
  segm : seg;
  i    : INTEGER;

BEGIN
  CASE dir OF
    vertical   : segm:=ver;
    horizontal : segm:=hor;
    decimal    : segm:=DPdot;
    dot        : segm:=SCdot;
  END;

  FOR i:=1 TO 7 DO
    BEGIN
      segm[i].x:=TRUNC((segm[i].x+dx)*m)+xc;
      segm[i].y:=TRUNC((segm[i].y+dy)*m)+yc;
    END;

  IF show
    THEN setfillstyle(solidfill,cl)
    ELSE setfillstyle(solidfill,black);

  Fillpoly(7,segm);
END;

{---------------------------------------------------------}
{----Types & Const for 7 segment display codes definitions}
{---------------------------------------------------------}

TYPE
  leds  = (a,b,c,d,e,f,g,dp,dl,dh);
  offst = RECORD
            dx,dy : REAL;
            d     : dir;
          END;
  disp  = SET OF leds;

CONST
  rel : ARRAY[leds] OF offst =
        ((dx : 1.0;dy : 0.0; d : horizontal),
         (dx : 0.0;dy : 1.0; d : vertical  ),
         (dx : 0.0;dy :11.0; d : vertical  ),
         (dx : 1.0;dy :20.0; d : horizontal),
         (dx :10.0;dy :11.0; d : vertical  ),
         (dx :10.0;dy : 1.0; d : vertical  ),
         (dx : 1.0;dy :10.0; d : horizontal),
         (dx :11.0;dy :21.0; d : decimal   ),
         (dx : 1.0;dy : 1.0; d : dot       ),
         (dx : 1.0;dy :11.0; d : dot       ));

{---------------------------------------------------------}
{----Routine to convert ASCII to 7 segments               }
{---------------------------------------------------------}

PROCEDURE Calcleds(ch : CHAR;VAR sseg : disp);

BEGIN
  CASE ch OF
    '0' : sseg:=[a,b,c,d,e,f];
    '1' : sseg:=[e,f];
    '2' : sseg:=[a,c,d,f,g];
    '3' : sseg:=[a,d,e,f,g];
    '4' : sseg:=[b,e,f,g];
    '5' : sseg:=[a,b,d,e,g];
    '6' : sseg:=[a,b,c,d,e,g];
    '7' : sseg:=[a,e,f];
    '8' : sseg:=[a,b,c,d,e,f,g];
    '9' : sseg:=[a,b,d,e,f,g];
    '-' : sseg:=[g];
    //'-' : sseg:=[d];
    '^' : sseg:=[a];
    ':' : sseg:=[dl,dh];
    //'≡' : sseg:=[a,d,g];
    '.' : sseg:=[dp];
  ELSE sseg:=[];
  END;
END;

VAR
  led     : leds;
  oseg,
  nseg,
  offseg,
  onseg   : disp;

BEGIN
  Setcolor(DarkGray);

  IF (nch=#0) AND (och=#0)
    THEN
      BEGIN
        offseg:=[a,b,c,d,e,f,g,dp,dl,dh];
        onseg :=[];
      END
    ELSE
      BEGIN
        Calcleds(och,oseg);
        Calcleds(nch,nseg);

        onseg :=nseg-oseg-oseg*nseg;    {----Leds to turn on }
        offseg:=oseg-nseg-oseg*nseg;    {----Leds to turn off}
      END;

  FOR led:=a TO dh DO
    WITH rel[led] DO
      BEGIN
        IF led IN  onseg THEN Dispsegm(d, true,scale,dx,dy);
        IF led IN offseg THEN Dispsegm(d,false,scale,dx,dy);
      END;
END;

{---------------------------------------------------------}
{----Prints error msg & halts program                     }
{---------------------------------------------------------}

PROCEDURE Error(s : STRING);

BEGIN
  CLRSCR;
  WRITELN;
  WRITELN('SYNTAX : Segment <color>');
  WRITELN;
  WRITELN('ERROR    ',s);
  WRITELN;
  HALT;
END;

{---------------------------------------------------------}
{----Main Program                                         }
{---------------------------------------------------------}

VAR
  h,m,s,ms : WORD;
  i        : INTEGER;
  c1,c2,c3 : STRING[2];
  olds,
  news     : STRING;
  grdriver,
  grmode  : smallint;

{---------------------------------------------------------}

BEGIN
  grdriver := VGA;
  grmode := VGAHi;
  
  Initgraph(grdriver,grmode,'');
  cl := Green;

  news:='        ';
  olds:='        ';

  FOR i:=1 TO LENGTH(news) DO Segments(#0,#0,80*(i-1),80,6.0);

  REPEAT

    GETTIME(h,m,s,ms);

    STR(h:2,c1);
    STR(m:2,c2);
    STR(s:2,c3);

    IF Odd(s)
      THEN news:=c1+':'+c2+':'+c3
      ELSE news:=c1+' '+c2+' '+c3;

    IF (news[1]=' ') THEN news[1]:='0';
    IF (news[4]=' ') THEN news[4]:='0';
    IF (news[7]=' ') THEN news[7]:='0';

  {----Write only the changed segments in all displays}
  
    FOR i:=1 TO LENGTH(news) DO Segments(news[i],olds[i],80*(i-1),80,6.0);

    olds:=news;

    Delay(100);

{----Not only wait for normal keypressed but also for
     shift/alt/ctrl or insert/numlock/scrollock keys pressed}

  UNTIL KEYPRESSED AND (READKEY<>#255);

  Closegraph;

END. {of segment}


