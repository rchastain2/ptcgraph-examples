unit UPauseMenu;

interface

  uses ptcgraph, UConfig, ptccrt;
  
  function updatePauseMenu(c: char): integer;
  procedure drawPauseMenu;
  procedure initpausemenu;

implementation

  const ELEM_COUNT = 4;
  const elements: array[1..ELEM_COUNT] of string =
                  ('resume', 'restart', 'main menu', 'exit');
  
  var cur: integer = 1;
      drawstack: array[1..20] of integer;
      scount: integer = 0;

  procedure drawPauseMenu;
  
  const x1 = 250;
  const x2 = 389;
  
  var y, i: integer;
  
  begin
    setbkcolor(cyan);
   cleardevice;
   setcolor(white);
   settextstyle(gothicfont, 0, 5);
   settextjustify(centertext, centertext);
   y := 100;
   for i := 0 to ELEM_COUNT - 1 do
   begin
     if i + 1 = cur then setcolor(yellow);
     {rectangle(x1, 100 + 50*i + 20*i,
               x2, 100 + 50*i + 20*i + 50);}
     outtextxy(400, 150 + 50*i+20*i+25, elements[i+1]);
     setcolor(white);
   end;
   settextstyle(defaultfont,0,1);
   setbkcolor(black);
  end;

  function handleenter: integer;
  begin
    handleenter := 0;
    case cur of 
      1: handleenter := PAUSE_MENU_EXIT;
      2: handleenter := PAUSE_MENU_RESTART;
      3: handleenter := PAUSE_MENU_TO_MAIN;
      4: handleenter := PAUSE_MENU_EXIT_CODE;
    end;
  end;

  function updatePauseMenu(c: char): integer;
  var shouldDraw: boolean = false;
      res: integer;
  begin
    res := 0;
    if c = #0 then
    begin
      c := readkey;
      res := updatePauseMenu(c);
    end
    else
    begin
      case c of
        #72:
          begin
            dec(cur);
            if cur <= 0 then 
              cur := 1
            else 
              shouldDraw := true;
          end;
        #80:
          begin
            inc(cur);
            if cur > ELEM_COUNT then 
              cur := ELEM_COUNT
            else
              shouldDraw := true;
          end;
        #27:
            res := PAUSE_MENU_EXIT;
        #13:
            res := handleenter;
      end; 
    end;
    if shouldDraw then
      drawPauseMenu;
    updatePauseMenu := res;
  end;

  procedure initpausemenu;
  begin
    cur := 1;
  end;

end.
