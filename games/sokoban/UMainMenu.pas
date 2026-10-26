unit UMainMenu;

interface

  uses ptcgraph, UConfig, ptccrt, UGame;

  const elements: array[0..4] of string =
     ('Continue', 'New game', 'Help', 'About', 'Exit');
  const ELEMENTS_SIZE = 4;

  procedure drawMainMenu;
  function updateMainMenu(c: char): integer;
  procedure initMainMenu;

implementation

 var selected: integer = 1;
 var start: integer = 1;

 procedure drawMainMenu;
 const x1 = 250;
 const x2 = 389;
 var y, i: integer;
 begin
   setbkcolor(cyan);
   cleardevice;
   settextstyle(gothicfont, 0, 5);
   setcolor(white);
   settextjustify(centertext, centertext);
   y := 100;
   for i := start-1 to ELEMENTS_SIZE - 1 do
   begin
     if i + 1 = selected then setcolor(yellow);
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
 case selected of
   0: handleenter := MAIN_MENU_CONTINUE;
   1: handleenter := MAIN_MENU_PLAY;
   2: handleenter := MAIN_MENU_HELP;
   3: handleenter := MAIN_MENU_ABOUT;
   4: handleenter := MAIN_MENU_EXIT;
 end;
 end;

 function updateMainMenu(c: char): integer;
 var res: integer;
     shoulddraw: boolean = false;
 begin
   if canContinue then start := 0 else start := 1;
   res := 0;
   if c = #0 then
   begin
     c := readkey;
     updatemainmenu(c);
   end
   else
   begin
     case c of
     #72:
       begin
         dec(selected);
         if selected < start then selected := start
         else shoulddraw := true;
       end;
     #80:
       begin
         inc(selected);
         if selected > 4 then selected := 4
         else shoulddraw := true;
       end;
     #13:
         res := handleenter;
     #27:
       begin
         res := MAIN_MENU_EXIT;
       end;
     end;

   end;
   if shoulddraw then
     drawmainmenu;
   updateMainMenu := res;
 end;

 procedure initMainMenu;
 begin
   if canContinue then start := 0 else start := 1;
   selected := start;
 end;

end.
