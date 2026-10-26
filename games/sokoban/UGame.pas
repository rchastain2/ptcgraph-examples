unit UGame;

interface

  uses ptcgraph, UConfig, ptccrt;
  procedure drawGame;
  procedure restart;
  function updateGame(c: char): integer;
  procedure restartGame;
  procedure initGame;
  function canContinue:boolean;
  procedure saveProgress;

implementation

  const PROGRESS_PATH = 'progress.txt';

  const WALL_CHAR = 'w';
  const BLOCK_CHAR = 'b';
  const GOAL_CHAR = 'g';
  const GOALBLOCK_CHAR = '$';
  const SPACE_CHAR = 's';
  const LEVEL_COUNT = 9;
  const BLOCK_WDITH = 50;
  const BLOCK_HEIGHT = 50;

  const WALL_TYPE = 0;
  CONST BLOCK_TYPE = 1;
  CONST GOAL_TYPE = 0;
  CONST SPACE_TYPE = 0;
  CONST PLAYER_TYPE = 2;

  var levels: array[0..LEVEL_COUNT-1] of string = ('map.txt', 'map2.txt', 'map4.txt', 'map5.txt',
                                                   'map6.txt', 'map7.txt', 'map8.txt', 'map3.txt', 'map1.txt');
      messages: array[0..LEVEL_COUNT-1] of string = ('This was just a start',
                                                     'You are making progress',
                                                     'Getting better',
                                                     'Tutorial is over',
                                                     'Middle of the way',
                                                     'Rolling on',
                                                     'Next one is harder',
                                                     'Finishing line',
                                                     'Congrats! You won!!!');
      drawstack: array[1..10000, 1..2] of integer;
      dstackcount: integer = 0;
      arr: array[1..50, 1..50] of char;
      goals: array[1..50, 1..50] of boolean;
      width, height: integer;
      wasLevelLoaded: boolean = false;
      playeri, playerj: integer;
      waslastgoal: boolean = false;
      curLvl: integer = 0;
      lastLvl: integer = 0;
      x0, y0: integer;

  function getLastLevel:integer;
  var f : text;
      k : integer;
      c : char;
  begin
    k := 0;
    assign(f, PROGRESS_PATH);
    reset(f);
    while not eof(f) do
    begin
      read(f, c);
      if c = '|' then
        inc(k)
      else
        break;
    end;
    close(f);
    getLastLevel := k;
  end;

  procedure saveLastLevel(level: integer);
  var f : text;
      i : integer;
  begin
    assign(f, PROGRESS_PATH);
    rewrite(f);
    for i := 1 to level do write(f, '|');
    close(f);
  end;


  procedure drawrectanglefromcoords(i,j: integer; color: word; btype: integer);
  var deltax, deltay: integer;
  begin
    //setbkcolor(cyan);
    setfillstyle(solidfill, color);
    deltay := 0;
    deltax := 0;
    case btype of
      BLOCK_TYPE:
        begin
          deltax := 3;
          deltay := 3;
        end;
      PLAYER_TYPE:
        begin
          deltax := 3;
          deltay := 3;
        end;
    end;
    setcolor(color);
    bar(x0 + BLOCK_WDITH*(j-1) + 1 + deltax, y0 + BLOCK_HEIGHT*(i-1) + 1 + deltay,
              x0 + BLOCK_WDITH*j - deltax, y0 + BLOCK_HEIGHT*i - deltay);
    //setbkcolor(black);
  end;

  function isPossibleMove(di, dj: integer) : boolean;
  var res: boolean = true;
  begin
    if arr[playeri+di, playerj+dj] = WALL_CHAR then
      res := res and false;
    if (arr[playeri+di, playerj+dj] = BLOCK_CHAR) then
    begin
       if (arr[playeri+di*2, playerj+dj*2] = BLOCK_CHAR) then
         res := res and false;
       if (arr[playeri+di*2, playerj+dj*2] = WALL_CHAR) then
         res := res and false;
    end;
    ispossiblemove := res;
  end;

  procedure move(di, dj: integer);
  var tmp : char;
  begin
   if ispossiblemove(di, dj) then
   begin
     if arr[playeri+di, playerj+dj] = SPACE_CHAR then
     begin
       inc(dstackcount);
       drawstack[dstackcount, 1] := playeri;
       drawstack[dstackcount, 2] := playerj;
       inc(dstackcount);
       drawstack[dstackcount, 1] := playeri + di;
       drawstack[dstackcount, 2] := playerj + dj;
       playeri := playeri + di;
       playerj := playerj + dj;
     end
     else
     if (arr[playeri + di, playerj+dj]=BLOCK_CHAR) and
        (arr[playeri + di*2, playerj+dj*2]=SPACE_CHAR) then
        begin
          inc(dstackcount);
          drawstack[dstackcount, 1] := playeri;
          drawstack[dstackcount, 2] := playerj;
          inc(dstackcount);
          drawstack[dstackcount, 1] := playeri + di;
          drawstack[dstackcount, 2] := playerj + dj;
          inc(dstackcount);
          drawstack[dstackcount, 1] := playeri + 2 * di;
          drawstack[dstackcount, 2] := playerj + 2 * dj;
          arr[playeri+di, playerj+dj] := SPACE_CHAR;
          arr[playeri+di*2, playerj+dj*2] := BLOCK_CHAR;
          playeri := playeri+di;
          playerj := playerj+dj;
        end;
   end
   else
   begin
    inc(dstackcount);
    drawstack[dstackcount, 1] := playeri;
    drawstack[dstackcount, 2] := playerj;
   end;
  end;

    procedure moveUp;
  begin
    move(-1, 0);
  end;

  procedure moveLeft;
  begin
    move(0, -1);
  end;

  procedure moveRight;
  begin
    move(0, 1);
  end;

  procedure moveDown;
  begin
    move(1, 0);
  end;

  procedure uploadMap;
  var f: text;
      c: char;
      i, j: integer;
      path: string;
  begin
    dstackcount := 0;
    path := levels[curLvl];
    assign(f, path);
    reset(f);
    read(f, height);
    read(f, width);
    x0 := (800 - width * BLOCK_WDITH) div 2;
    y0 := (600 - height * BLOCK_HEIGHT) div 2;
    read(f, playeri);
    read(f, playerj);
    readln(f);
    for i := 1 to height do
    begin
      for j := 1 to width do
      begin
        //read(f, arr[i, j]);
        goals[i, j] := false;
        arr[i, j] := SPACE_CHAR;
        read(f, c);
        if (c = GOAL_CHAR) or
           (c = GOALBLOCK_CHAR) then goals[i, j] := true;
        if c = WALL_CHAR then arr[i, j] := c;
        if (c = GOALBLOCK_CHAR) or
           (c = BLOCK_CHAR) then arr[i, j] := BLOCK_CHAR;
      end;
      readln(f);
    end;
    close(f);
  end;

  procedure drawGameFromStack;
  var i, j: integer;
      x, y: integer;
  begin
    while (dstackcount > 0) do
    begin
      x := drawstack[dstackcount, 1];
      y := drawstack[dstackcount, 2];
      case arr[x, y] of
        WALL_CHAR: drawrectanglefromcoords(x, y, brown, BLOCK_TYPE);
        BLOCK_CHAR: drawrectanglefromcoords(x, y, white, BLOCK_TYPE);
        GOAL_CHAR: drawrectanglefromcoords(x, y,red, GOAL_TYPE);
        GOALBLOCK_CHAR: drawrectanglefromcoords(x, y,green, GOAL_TYPE);
        SPACE_CHAR: drawrectanglefromcoords(x, y, black, BLOCK_TYPE);
      end;
      if goals[x, y] then drawrectanglefromcoords(x, y, red, GOAL_TYPE);
      if (goals[x, y]) and (arr[x,y]=BLOCK_CHAR) then
      begin
        drawrectanglefromcoords(x, y, green, GOAL_TYPE);
        drawrectanglefromcoords(x, y, white, BLOCK_TYPE);
      end;
      drawrectanglefromcoords(playeri, playerj, yellow, PLAYER_TYPE);
      dec(dstackcount);
    end;
  end;

  procedure drawGameFromScratch;
  var i, j: integer;
  begin
    cleardevice;
    for i := 1 to height do
      for j := 1 to width do
      begin
        if goals[i,j] then drawrectanglefromcoords(i, j, red, GOAL_TYPE);
        if (goals[i,j]) and
           (arr[i,j] = BLOCK_CHAR) then drawrectanglefromcoords(i, j, green, GOAL_TYPE);
        case arr[i, j] of
          WALL_CHAR: drawrectanglefromcoords(i, j, brown, BLOCK_TYPE);
          BLOCK_CHAR: drawrectanglefromcoords(i, j, white, BLOCK_TYPE);
          GOAL_CHAR: drawrectanglefromcoords(i, j,red, GOAL_TYPE);
          GOALBLOCK_CHAR: drawrectanglefromcoords(i, j,green, GOAL_TYPE);
        end;
      end;
    drawrectanglefromcoords(playeri, playerj, yellow, PLAYER_TYPE);
  end;

  procedure drawGame;
  var i, j: integer;
      x, y: integer;
  begin
    setbkcolor(cyan);
    if not wasLevelLoaded then
    begin
      wasLevelLoaded := true;
      uploadMap;
    end;
    if dstackcount > 0 then
      drawGameFromStack
    else
      drawGameFromScratch;
    setbkcolor(black);
  end;

  function isWon: boolean;
  var i, j: integer;
      res: boolean;
  begin
    res := true;
    for i := 1 to height do
      for j := 1 to width do
        if (arr[i, j] = BLOCK_CHAR) and (not goals[i, j]) then
        begin
          res := false;
          break;
        end;
    //if res then dstackcount := 0;
    isWon := res;
  end;


  procedure initNextLevel;
  var tmp : char;
  begin
    drawGame;
    setfillstyle(solidfill, green);
    settextjustify(centertext, centertext);
    bar(0, 150, 800, 450);
    setcolor(white);
    settextstyle(gothicfont, 0, 3);
    outtextxy(800 div 2, 600 div 2, messages[curLvl]);
    tmp := readkey;
    inc(lastLvl);
    if lastLvl > LEVEL_COUNT then dec(lastLvl);
    curLvl := (curLvl + 1) mod LEVEL_COUNT;
    uploadMap;
  end;


  function updateGame(c: char): integer;
  var res: integer;
      tmp: char;
  begin
    if not wasLevelLoaded then
    begin
      wasLevelLoaded := true;
      uploadMap;
    end;
    res := 0;
    if c = #0 then
    begin
      c := readkey;
      res := updateGame(c);
    end
    else
    begin
      case c of
        #72:
          begin
            moveUp;
            res := GAME_REDRAW;
          end;
        #75:
          begin
            moveLeft;
            res := GAME_REDRAW;
          end;
        #77:
          begin
            moveRight;
            res := GAME_REDRAW;
          end;

        #80:
          begin
            moveDown;
            res := GAME_REDRAW;
          end;
        #27:
            res := GAME_PAUSE;
      end;
    end;
    updateGame := res;
    if iswon then
      initNextLevel;
  end;

  procedure restartGame;
  begin
    curLvl := 0;
    lastLvl := 0;
    saveLastLevel(lastLvl);
    uploadMap;
  end;

  procedure initGame;
  begin
    lastLvl := getLastLevel;
    curLvl := lastLvl;
    uploadMap;
  end;

  procedure restart;
  begin
    uploadMap;
  end;

  function canContinue:boolean;
  begin
    if lastLvl > 0 then
      canContinue := true
    else
      canContinue := false;
  end;

  procedure saveProgress;
  begin
    saveLastLevel(lastLvl);
  end;

end.
