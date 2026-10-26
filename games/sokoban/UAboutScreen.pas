unit UAboutScreen;

interface

  uses ptcgraph, uconfig;

  procedure drawAboutScreen;
  function updateAboutScreen(c: char): integer;

implementation

  procedure drawAboutScreen;
  begin
    setbkcolor(cyan);
    cleardevice;
    setcolor(white);
    settextjustify(centertext, centertext);
    settextstyle(gothicfont, 0, 2);
    outtextxy(800 div 2, 600 div 2 - 30, 'This game is created by Yevhen Yevsyuhov');
    outtextxy(800 div 2, 600 div 2 , 'Student of IASA, NTTUU "KPI"');
    outtextxy(800 div 2, 600 div 2 + 60, 'Press Esc to return to main menu');
    setbkcolor(black);
  end;

  function updateAboutScreen(c: char): integer;
  begin
    if c = #27 then
      updateAboutScreen := ABOUT_SCREEN_EXIT
    else
      updateAboutScreen := 0;
  end;

end.
