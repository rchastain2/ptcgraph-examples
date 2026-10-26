unit UHelpScreen;

interface

  uses ptcgraph, uconfig;

  procedure drawHelpScreen;
  function updateHelpScreen(c: char): integer;

implementation

  procedure drawHelpScreen;
  begin
    {cleardevice;
    setcolor(white);
    settextjustify(centertext, centertext);
    outtextxy(640 div 2, 480 div 2, 'Press arrow keys to move. ' +
              'Press escape to quit.');}
    setbkcolor(cyan);
    cleardevice;
    setcolor(white);
    settextjustify(centertext, centertext);
    settextstyle(gothicfont, 0, 2);
    outtextxy(800 div 2, -10 + 600 div 2 - 60, 'You play as the yellow box');
    outtextxy(800 div 2, -10 + 600 div 2 - 30, 'Your goal is to place all white boxes on red plates');
    outtextxy(800 div 2, -10 + 600 div 2, 'Once you place a box plate becomes green');
    outtextxy(800 div 2, -10 + 600 div 2 + 30, 'When all boxes are placed level is considerd won');
    outtextxy(800 div 2, -10 + 600 div 2 + 60, 'And you move on to next level');
    setbkcolor(black);
  end;

  function updateHelpScreen(c: char): integer;
  begin
    if c = #27 then
      updateHelpScreen := HELP_SCREEN_EXIT
    else
      updateHelpScreen := 0;
  end;

end.
