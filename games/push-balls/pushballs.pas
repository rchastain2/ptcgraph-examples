
program PushBalls;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

var
  c: char;
  poz, ns: byte; { позиция (position), номер шара (ball number) }
  rez1, rez, ok: boolean; { результат (result) }
  x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3: smallint;
  
function stena(x, y: smallint; poz: byte): boolean; forward; { стена (wall) }
function shar(x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3: smallint; poz: byte; var ns: byte; var ok: boolean): boolean; forward; { шар (ball) }

function stena(x, y: smallint; poz: byte): boolean;
begin
  case poz of
    1:
      if (y > 20) and (x <> 100) and (x <> 500) then
        stena := true else
        stena := false;
    2:
      if (y < 340) and (x <> 100) and (x <> 500) then
        stena := true else
        stena := false;
    3:
      if (X > 20) and (y = 180) then
        stena := true else
        if x > 180 then
          stena := true else
          stena := false;
    4:
      if (x < 500) and (y = 180) then
        stena := true else
        if (x < 420) and (x <> 20) then
          stena := true else
          stena := false;
  end;
end;

function shar(x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3: smallint; poz: byte; var ns: byte; var ok: boolean): boolean;
var x1, y1: word;
begin
  x1 := 0;
  y1 := 0;
  shar := false;
  ok := false;
  ns := 0;
  case poz of
    2:
      if (x + 30 = xofst1) and (y + 110 = yofst1) then
      begin
        x1 := xofst1; y1 := yofst1; ns := 1; end
      else
        if (x + 30 = xofst2) and (y + 110 = yofst2) then
        begin
          x1 := xofst2; y1 := yofst2; ns := 2; end
        else
          if (x + 30 = xofst3) and (y + 110 = yofst3) then
          begin
            x1 := xofst3; y1 := yofst3; ns := 3; end;
    1:
      if (x + 30 = xofst1) and (y - 50 = yofst1) then
      begin
        x1 := xofst1; y1 := yofst1; ns := 1; end
      else
        if (x + 30 = xofst2) and (y - 50 = yofst2) then
        begin
          x1 := xofst2; y1 := yofst2; ns := 2; end
        else
          if (x + 30 = xofst3) and (y - 50 = yofst3) then
          begin
            x1 := xofst3; y1 := yofst3; ns := 3; end;
    3:
      if (x - 50 = xofst1) and (y + 30 = yofst1) then
      begin
        x1 := xofst1; y1 := yofst1; ns := 1; end
      else
        if (x - 50 = xofst2) and (y + 30 = yofst2) then
        begin
          x1 := xofst2; y1 := yofst2; ns := 2; end
        else
          if (x - 50 = xofst3) and (y + 30 = yofst3) then
          begin
            x1 := xofst3; y1 := yofst3; ns := 3; end;
    4:
      if (x + 110 = xofst1) and (y + 30 = yofst1) then
      begin
        x1 := xofst1; y1 := yofst1; ns := 1; end
      else
        if (x + 110 = xofst2) and (y + 30 = yofst2) then
        begin
          x1 := xofst2; y1 := yofst2; ns := 2; end
        else
          if (x + 110 = xofst3) and (y + 30 = yofst3) then
          begin
            x1 := xofst3; y1 := yofst3; ns := 3; end;
  end;
  if x1 > 0 then
  begin
    shar := true;
    case poz of
      1:
        if y1 > 50 then
          if ns = 2 then
            if (x1 <> xofst3) or (y1 - 80 <> yofst3) then
              ok := true else
            ok := false else
            if (x1 <> xofst2) or (y1 - 80 <> yofst2) then
              ok := true else
              ok := false;
      2:
        if y1 < 370 then
          if ns = 2 then
            if (x1 <> xofst3) or (y1 + 80 <> yofst3) then
              ok := true else
            ok := false else
            if (x1 <> xofst2) or (y1 + 80 <> yofst2) then
              ok := true else
              ok := false;
      3:
        if (x1 > 50) and (y1 = 210) then
          if ns = 2 then
            if (y1 <> yofst3) or (x1 - 80 <> xofst3) then
              ok := true else
            ok := false else
            if (y1 <> yofst2) or (x1 - 80 <> xofst2) then
              ok := true else
              ok := false
          else
            if x1 > 210 then
              if ns = 2 then
                if (y1 <> yofst3) or (x1 - 80 <> xofst3) then
                  ok := true else
                ok := false else
                if (y1 <> yofst2) or (x1 - 80 <> xofst2) then
                  ok := true else
                  ok := false;
            4:
            if (x1 < 530) and (y1 = 210) then
              if ns = 2 then
                if (y1 <> yofst3) or (x1 + 80 <> xofst3) then
                  ok := true else
                ok := false else
                if (y1 <> yofst2) or (x1 + 80 <> xofst2) then
                  ok := true else
                  ok := false
              else
                if x1 < 450 then
                  if ns = 2 then
                    if (y1 <> yofst3) or (x1 + 80 <> xofst3) then
                      ok := true else
                    ok := false else
                    if (y1 <> yofst2) or (x1 + 80 <> xofst2) then
                      ok := true else
                      ok := false;
    end;
  end;
end;

procedure init(i: byte);
begin
  SetColor(cWhite);
  Line(10, 10, 10, 410);
  Line(10, 10, 90, 10);
  Line(90, 10, 90, 170);
  Line(10, 410, 90, 410);
  Line(90, 410, 90, 250);
  Line(90, 250, 170, 250);
  Line(90, 170, 170, 170);
  Line(170, 170, 170, 10);
  Line(170, 10, 490, 10);
  Line(490, 10, 490, 170);
  Line(490, 170, 570, 170);
  Line(570, 170, 570, 250);
  Line(570, 250, 490, 250);
  Line(490, 250, 490, 410);
  Line(490, 410, 170, 410);
  Line(170, 410, 170, 250);
  SetFillStyle(1, cRed);
  SetColor(cRed);
  Circle(50, 370, 35);
  Circle(370, 370, 35);
  Circle(530, 210, 35);
  SetColor(cWhite);
  Rectangle(20, 340, 80, 400);
  Rectangle(340, 340, 400, 400);
  Rectangle(500, 180, 560, 240);
  SetFillStyle(1, cWhite);
  FloodFill(21, 341, cWhite);
  FloodFill(341, 341, cWhite);
  FloodFill(501, 181, cWhite);
  SetColor(cBlack);
  Rectangle(20, 340, 80, 400);
  Rectangle(340, 340, 400, 400);
  Rectangle(500, 180, 560, 240);
  SetFillStyle(1, cBlack);
  FloodFill(21, 341, cBlack);
  FloodFill(341, 341, cBlack);
  FloodFill(501, 181, cBlack);
  xofst1 := 50;
  yofst1 := 210;
  xofst3 := 370;
  yofst3 := 210;
  xofst2 := 370;
  yofst2 := 130;
  SetColor(cDarkGray);
  SetFillStyle(1, cDarkGray);
  Circle(xofst1, yofst1, 35);
  FloodFill(xofst1, yofst1, cDarkGray);
  Circle(xofst2, yofst2, 35);
  FloodFill(xofst2, yofst2, cDarkGray);
  Circle(xofst3, yofst3, 35);
  FloodFill(xofst3, yofst3, cDarkGray);
  poz := 2;
  SetFillStyle(1, cWhite);
  x := 20;
  y := 20;
  SetColor(cWhite);
  Rectangle(x, y, x + 60, y + 60);
  FloodFill(x + 1, y + 1, cWhite);
  Line(x + 10, y + 60, x + 10, y + 69);
  Line(x + 50, y + 60, x + 50, y + 69);
  Line(x, y + 69, x + 60, y + 69);
end;

procedure niz(var x, y: smallint; var poz: byte); { низ (down) }
begin
  SetColor(cBlack);
  SetFillStyle(1, cBlack);
  case poz of
    1:
      begin
        Line(x + 10, y - 1, x + 10, y - 9);
        Line(x + 50, y - 1, x + 50, y - 9);
        Line(x, y - 9, x + 60, y - 9);
        SetColor(cWhite);
        Line(x + 10, y + 60, x + 10, y + 69);
        Line(x + 50, y + 60, x + 50, y + 69);
        Line(x, y + 69, x + 60, y + 69);
        poz := 2;
      end;
    3:
      begin
        Line(x - 1, y + 10, x - 9, y + 10);
        Line(x - 1, y + 50, x - 9, y + 50);
        Line(x - 9, y, x - 9, y + 60);
        SetColor(cWhite);
        Line(x + 10, y + 60, x + 10, y + 69);
        Line(x + 50, y + 60, x + 50, y + 69);
        Line(x, y + 69, x + 60, y + 69);
        poz := 2;
      end;
    4:
      begin
        Line(x + 61, y + 10, x + 69, y + 10);
        Line(x + 61, y + 50, x + 69, y + 50);
        Line(x + 69, y, x + 69, y + 60);
        SetColor(cWhite);
        Line(x + 10, y + 60, x + 10, y + 69);
        Line(x + 50, y + 60, x + 50, y + 69);
        Line(x, y + 69, x + 60, y + 69);
        poz := 2;
      end;
    2:
      begin
        rez := false;
        rez1 := false;
        ns := 0;
        ok := false;
        rez := stena(x, y, poz);
        rez1 := shar(x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3, poz, ns, ok);
        if (rez = true) and (rez1 = false) then
        begin
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cBlack);
          Line(x + 10, y + 60, x + 10, y + 69);
          Line(x + 50, y + 60, x + 50, y + 69);
          Line(x, y + 69, x + 60, y + 69);
          y := y + 80;
          SetColor(cWhite);
          SetFillStyle(1, cWhite);
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cWhite);
          Line(x + 10, y + 60, x + 10, y + 69);
          Line(x + 50, y + 60, x + 50, y + 69);
          Line(x, y + 69, x + 60, y + 69);
        end else
          if (rez = true) and (rez1 = true) and (ok = true) then
            case ns of
              1:
                begin
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cBlack);
                  yofst1 := yofst1 + 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 10, y + 60, x + 10, y + 69);
                  Line(x + 50, y + 60, x + 50, y + 69);
                  Line(x, y + 69, x + 60, y + 69);
                  y := y + 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 10, y + 60, x + 10, y + 69);
                  Line(x + 50, y + 60, x + 50, y + 69);
                  Line(x, y + 69, x + 60, y + 69);
                end;
              2:
                begin
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cBlack);
                  yofst2 := yofst2 + 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 10, y + 60, x + 10, y + 69);
                  Line(x + 50, y + 60, x + 50, y + 69);
                  Line(x, y + 69, x + 60, y + 69);
                  y := y + 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 10, y + 60, x + 10, y + 69);
                  Line(x + 50, y + 60, x + 50, y + 69);
                  Line(x, y + 69, x + 60, y + 69);
                end;
              3:
                begin
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cBlack);
                  yofst3 := yofst3 + 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 10, y + 60, x + 10, y + 69);
                  Line(x + 50, y + 60, x + 50, y + 69);
                  Line(x, y + 69, x + 60, y + 69);
                  y := y + 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 10, y + 60, x + 10, y + 69);
                  Line(x + 50, y + 60, x + 50, y + 69);
                  Line(x, y + 69, x + 60, y + 69);
                end;
            end;
      end;
  end;
end;

procedure levo(var x, y: smallint; var poz: byte); { лево (left) }
begin
  SetColor(cBlack);
  SetFillStyle(1, cBlack);
  case poz of
    1:
      begin
        Line(x + 10, y - 1, x + 10, y - 9);
        Line(x + 50, y - 1, x + 50, y - 9);
        Line(x, y - 9, x + 60, y - 9);
        SetColor(cWhite);
        Line(x - 1, y + 10, x - 9, y + 10);
        Line(x - 1, y + 50, x - 9, y + 50);
        Line(x - 9, y, x - 9, y + 60);
        poz := 3;
      end;
    2:
      begin
        Line(x + 10, y + 61, x + 10, y + 69);
        Line(x + 50, y + 61, x + 50, y + 69);
        Line(x, y + 69, x + 69, y + 69);
        SetColor(cWhite);
        Line(x - 1, y + 10, x - 9, y + 10);
        Line(x - 1, y + 50, x - 9, y + 50);
        Line(x - 9, y, x - 9, y + 60);
        poz := 3;
      end;
    4:
      begin
        Line(x + 61, y + 10, x + 69, y + 10);
        Line(x + 61, y + 50, x + 69, y + 50);
        Line(x + 69, y, x + 69, y + 60);
        SetColor(cWhite);
        Line(x - 1, y + 10, x - 9, y + 10);
        Line(x - 1, y + 50, x - 9, y + 50);
        Line(x - 9, y, x - 9, y + 60);
        poz := 3;
      end;
    3:
      begin
        rez := false;
        rez1 := false;
        ns := 0;
        ok := false;
        rez := stena(x, y, poz);
        rez1 := shar(x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3, poz, ns, ok);
        if (rez = true) and (rez1 = false) then
        begin
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cBlack);
          Line(x - 1, y + 10, x - 9, y + 10);
          Line(x - 1, y + 50, x - 9, y + 50);
          Line(x - 9, y, x - 9, y + 60);
          x := x - 80;
          SetColor(cWhite);
          SetFillStyle(1, cWhite);
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cWhite);
          Line(x - 1, y + 10, x - 9, y + 10);
          Line(x - 1, y + 50, x - 9, y + 50);
          Line(x - 9, y, x - 9, y + 60);
        end else
          if (rez = true) and (rez1 = true) and (ok = true) then
            case ns of
              1:
                begin
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cBlack);
                  xofst1 := xofst1 - 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x - 1, y + 10, x - 9, y + 10);
                  Line(x - 1, y + 50, x - 9, y + 50);
                  Line(x - 9, y, x - 9, y + 60);
                  x := x - 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x - 1, y + 10, x - 9, y + 10);
                  Line(x - 1, y + 50, x - 9, y + 50);
                  Line(x - 9, y, x - 9, y + 60);
                end;
              2:
                begin
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cBlack);
                  xofst2 := xofst2 - 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x - 1, y + 10, x - 9, y + 10);
                  Line(x - 1, y + 50, x - 9, y + 50);
                  Line(x - 9, y, x - 9, y + 60);
                  x := x - 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x - 1, y + 10, x - 9, y + 10);
                  Line(x - 1, y + 50, x - 9, y + 50);
                  Line(x - 9, y, x - 9, y + 60);
                end;
              3:
                begin
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cBlack);
                  xofst3 := xofst3 - 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x - 1, y + 10, x - 9, y + 10);
                  Line(x - 1, y + 50, x - 9, y + 50);
                  Line(x - 9, y, x - 9, y + 60);
                  x := x - 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x - 1, y + 10, x - 9, y + 10);
                  Line(x - 1, y + 50, x - 9, y + 50);
                  Line(x - 9, y, x - 9, y + 60);
                end;
            end;
      end;
  end;
end;

procedure verh(var x, y: smallint; var poz: byte); { верх (up) }
begin
  SetColor(cBlack);
  SetFillStyle(1, cBlack);
  case poz of
    2:
      begin
        Line(x + 10, y + 61, x + 10, y + 69);
        Line(x + 50, y + 61, x + 50, y + 69);
        Line(x, y + 69, x + 60, y + 69);
        SetColor(cWhite);
        Line(x + 10, y + 60, x + 10, y - 9);
        Line(x + 50, y + 60, x + 50, y - 9);
        Line(x, y - 9, x + 60, y - 9);
        poz := 1;
      end;
    3:
      begin
        Line(x - 1, y + 10, x - 9, y + 10);
        Line(x - 1, y + 50, x - 9, y + 50);
        Line(x - 9, y, x - 9, y + 60);
        SetColor(cWhite);
        Line(x + 10, y + 60, x + 10, y - 9);
        Line(x + 50, y + 60, x + 50, y - 9);
        Line(x, y - 9, x + 60, y - 9);
        poz := 1;
      end;
    4:
      begin
        Line(x + 61, y + 10, x + 69, y + 10);
        Line(x + 61, y + 50, x + 69, y + 50);
        Line(x + 69, y, x + 69, y + 60);
        SetColor(cWhite);
        Line(x + 10, y + 60, x + 10, y - 9);
        Line(x + 50, y + 60, x + 50, y - 9);
        Line(x, y - 9, x + 60, y - 9);
        poz := 1;
      end;
    1:
      begin
        rez := false;
        rez1 := false;
        ns := 0;
        ok := false;
        rez := stena(x, y, poz);
        rez1 := shar(x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3, poz, ns, ok);
        if (rez = true) and (rez1 = false) then
        begin
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cBlack);
          Line(x + 10, y + 60, x + 10, y - 9);
          Line(x + 50, y + 60, x + 50, y - 9);
          Line(x, y - 9, x + 60, y - 9);
          y := y - 80;
          SetColor(cWhite);
          SetFillStyle(1, cWhite);
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cWhite);
          Line(x + 10, y + 60, x + 10, y - 9);
          Line(x + 50, y + 60, x + 50, y - 9);
          Line(x, y - 9, x + 60, y - 9);
        end else
          if (rez = true) and (rez1 = true) and (ok = true) then
            case ns of
              1:
                begin
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cBlack);
                  yofst1 := yofst1 - 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 10, y + 60, x + 10, y - 9);
                  Line(x + 50, y + 60, x + 50, y - 9);
                  Line(x, y - 9, x + 60, y - 9);
                  y := y - 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 10, y + 60, x + 10, y - 9);
                  Line(x + 50, y + 60, x + 50, y - 9);
                  Line(x, y - 9, x + 60, y - 9);
                end;
              2:
                begin
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cBlack);
                  yofst2 := yofst2 - 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 10, y + 60, x + 10, y - 9);
                  Line(x + 50, y + 60, x + 50, y - 9);
                  Line(x, y - 9, x + 60, y - 9);
                  y := y - 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 10, y + 60, x + 10, y - 9);
                  Line(x + 50, y + 60, x + 50, y - 9);
                  Line(x, y - 9, x + 60, y - 9);
                end;
              3:
                begin
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cBlack);
                  yofst3 := yofst3 - 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 10, y + 60, x + 10, y - 9);
                  Line(x + 50, y + 60, x + 50, y - 9);
                  Line(x, y - 9, x + 60, y - 9);
                  y := y - 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 10, y + 60, x + 10, y - 9);
                  Line(x + 50, y + 60, x + 50, y - 9);
                  Line(x, y - 9, x + 60, y - 9);
                end;
            end;
      end;
  end;
end;

procedure pravo(var x, y: smallint; var poz: byte); { право (right) }
begin
  SetColor(Black);
  SetFillStyle(1, Black);
  case poz of
    2:
      begin
        Line(x + 10, y + 61, x + 10, y + 69);
        Line(x + 50, y + 61, x + 50, y + 69);
        Line(x, y + 69, x + 60, y + 69);
        SetColor(cWhite);
        Line(x + 60, y + 10, x + 69, y + 10);
        Line(x + 60, y + 50, x + 69, y + 50);
        Line(x + 69, y, x + 69, y + 60);
        poz := 4;
      end;
    3:
      begin
        Line(x - 1, y + 10, x - 9, y + 10);
        Line(x - 1, y + 50, x - 9, y + 50);
        Line(x - 9, y, x - 9, y + 60);
        SetColor(cWhite);
        Line(x + 60, y + 10, x + 69, y + 10);
        Line(x + 60, y + 50, x + 69, y + 50);
        Line(x + 69, y, x + 69, y + 60);
        poz := 4;
      end;
    1:
      begin
        Line(x + 10, y - 1, x + 10, y - 9);
        Line(x + 50, y - 1, x + 50, y - 9);
        Line(x, y - 9, x + 60, y - 9);
        SetColor(cWhite);
        Line(x + 60, y + 10, x + 69, y + 10);
        Line(x + 60, y + 50, x + 69, y + 50);
        Line(x + 69, y, x + 69, y + 60);
        poz := 4;
      end;
    4:
      begin
        rez := false;
        rez1 := false;
        ns := 0;
        ok := false;
        rez := stena(x, y, poz);
        rez1 := shar(x, y, xofst1, yofst1, xofst2, yofst2, xofst3, yofst3, poz, ns, ok);
        if (rez = true) and (rez1 = false) then
        begin
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cBlack);
          Line(x + 60, y + 10, x + 69, y + 10);
          Line(x + 60, y + 50, x + 69, y + 50);
          Line(x + 69, y, x + 69, y + 60);
          x := x + 80;
          SetColor(cWhite);
          SetFillStyle(1, cWhite);
          Rectangle(x, y, x + 60, y + 60);
          FloodFill(x + 1, y + 1, cWhite);
          Line(x + 60, y + 10, x + 69, y + 10);
          Line(x + 60, y + 50, x + 69, y + 50);
          Line(x + 69, y, x + 69, y + 60);
        end else
          if (rez = true) and (rez1 = true) and (ok = true) then
            case ns of
              1:
                begin
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cBlack);
                  xofst1 := xofst1 + 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst1, yofst1, 35);
                  FloodFill(xofst1, yofst1, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  Line(x + 60, y + 10, x + 69, y + 10);
                  Line(x + 60, y + 50, x + 69, y + 50);
                  Line(x + 69, y, x + 69, y + 60);
                  x := x + 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 60, y + 10, x + 69, y + 10);
                  Line(x + 60, y + 50, x + 69, y + 50);
                  Line(x + 69, y, x + 69, y + 60);
                end;
              2:
                begin
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cBlack);
                  xofst2 := xofst2 + 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst2, yofst2, 35);
                  FloodFill(xofst2, yofst2, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 60, y + 10, x + 69, y + 10);
                  Line(x + 60, y + 50, x + 69, y + 50);
                  Line(x + 69, y, x + 69, y + 60);
                  x := x + 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 60, y + 10, x + 69, y + 10);
                  Line(x + 60, y + 50, x + 69, y + 50);
                  Line(x + 69, y, x + 69, y + 60);
                end;
              3:
                begin
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cBlack);
                  xofst3 := xofst3 + 80;
                  SetColor(cDarkGray);
                  SetFillStyle(1, cDarkGray);
                  Circle(xofst3, yofst3, 35);
                  FloodFill(xofst3, yofst3, cDarkGray);
                  SetColor(cBlack);
                  SetFillStyle(1, cBlack);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cBlack);
                  Line(x + 60, y + 10, x + 69, y + 10);
                  Line(x + 60, y + 50, x + 69, y + 50);
                  Line(x + 69, y, x + 69, y + 60);
                  x := x + 80;
                  SetColor(cWhite);
                  SetFillStyle(1, cWhite);
                  Rectangle(x, y, x + 60, y + 60);
                  FloodFill(x + 1, y + 1, cWhite);
                  Line(x + 60, y + 10, x + 69, y + 10);
                  Line(x + 60, y + 50, x + 69, y + 50);
                  Line(x + 69, y, x + 69, y + 60);
                end;
            end;
      end;
  end;
end;

procedure win(poz: smallint);
begin
  SetColor(cYellow);
  SetTextJustify(CenterText, CenterText);
  SetTextStyle(DefaultFont, HorizDir, 3);
  OutTextXY(GetMaxX div 2, 450, 'You won!');
  ReadKey;
  c := #27;
end;

var
  gd, gm: smallint;
  
begin
  poz := 2;
  gd := VESA;
  gm := m640x480x64k;
  InitGraph(gd, gm, '');
  SetBkColor(cBlack);
  ClearDevice;
  init(poz);
  repeat
    c := ReadKey;
    if c = #72 then
      verh(x, y, poz) else
      if c = #80 then
        niz(x, y, poz) else
        if c = #75 then
          levo(x, y, poz) else
          if c = #77 then
            pravo(x, y, poz) else
            if c = ' ' then
            begin
              SetColor(cBlack);
              SetFillStyle(1, cBlack);
              Rectangle(1, 1, 640, 480);
              FloodFill(2, 2, cBlack);
              init(poz);
            end;
    if (yofst1 = 370) and (xofst2 = 370) and (yofst2 = 370) and (xofst3 = 530) and (yofst3 = 210) then
      win(poz) else
      if (xofst3 = 370) and (yofst3 = 370) and (yofst1 = 370) and (xofst2 = 530) and (yofst2 = 210) then
        win(poz)
  until (c = #27) or (c = 'g');
  CloseGraph;
end.
