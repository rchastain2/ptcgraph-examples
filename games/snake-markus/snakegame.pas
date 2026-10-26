
program SnakeGame;
{ 
  Simple snake game by Markus Mangold
  http://www.pascalgamedevelopment.com/showthread.php?32638-Another-simple-snake-game-(no-OOP)
}
uses
{$IFDEF unix}
  cthreads,
{$ENDIF}
  sysutils, ptccrt, ptcgraph;

type
  TBody = record
    x, y: array of integer;
    xoffset, yoffset, xcount, ycount, width, height, length: integer;
    direction: ansistring;
  end;

  TApple = record
    x, y, xoffset, yoffset, xcount, ycount, width, height: integer;
  end;

  TScore = record
    score: integer;
    name, date: ansistring;
  end;

const
  filename = 'snakehigh.dat';
  
var
  tick_interval: integer = 1000 div 60;
  next_time: cardinal = 0;
  score: integer = 0;
  snake: TBody;
  bait: TApple;
  speed: single = 50.0;
  lasttime: integer = 0;
  nowtime: integer = 0;
  seconds: integer = 10;
  endgame: boolean = false;
  name: ansistring;
  hiscore: array[1..10] of TScore;

function GetKey: longint;
var
  key: longint;
begin
  key := Ord(ReadKey);
  if key = 0 then
    key := Ord(ReadKey) shl 8;
  result := key;
end;

function grinput(xold, y, lengthy: integer): ansistring;
var
  key, x, ins: integer;
  ch: char;
  answer: ansistring;
  mysize: word;
  getsize: TextSettingsType;
begin
  GetTextSettings(getsize);
  mysize := getsize.charsize * 8;
  answer := '';
  ins := length(answer) + 1;
  x := xold;
  repeat
    setfillstyle(solidfill, getcolor());
    if ins > length(answer) then
      bar(x, y, x + mysize - 1, y + mysize)
    else
      bar(x, y + mysize - 1, x + mysize - 1, y + mysize);
    key := GetKey;
    ch := chr(key);
    setfillstyle(solidfill, getbkcolor());
    bar(x, y, x + mysize - 1, y + mysize);
    if key = 3 then
    begin
      closegraph;
      halt(0);
    end;
    if (key <> 8) and (key <> 13) and (key <> 18432) and (key <> 19712) and (key <> 19200) and (key <> 20480) and (key <> 15104) and (key <> 15360) and (key <> 15616) and (key <> 15872) and (key <> 16128) and (key <> 16384) and (key <> 16640) and (key <> 21248) and (key <> 20992) and (key <> 18176) and (key <> 18688) and (key <> 21248) and (key <> 20224) and (key <> 20736) and (key <> 16896) and (key <> 17152) and (key <> 17408)
    and (length(answer) < lengthy) then
    begin
      insert(ch, answer, ins);
      x := x + mysize;
      ins := ins + 1;
    end;
    if key = 15104 then
    begin
      insert(chr(142), answer, ins);
      x := x + mysize;
      ins := ins + 1;
    end;
    if key = 15360 then
    begin
      insert(chr(153), answer, ins);
      ins := ins + 1;
      x := x + mysize;
    end;
    if key = 15616 then
    begin
      insert(chr(154), answer, ins);
      ins := ins + 1;
      x := x + mysize;
    end;
    if key = 15872 then
    begin
      insert(chr(225), answer, ins);
      ins := ins + 1;
      x := x + mysize;
    end;
    if key = 16128 then
    begin
      insert(chr(132), answer, ins);
      x := x + mysize;
      ins := ins + 1;
    end;
    if key = 16384 then
    begin
      insert(chr(148), answer, ins);
      ins := ins + 1;
      x := x + mysize;
    end;
    if key = 16640 then
    begin
      insert(chr(129), answer, ins);
      ins := ins + 1;
      x := x + mysize;
    end;
    if key = 19200 then
    begin
      if (x >= xold) and (ins > 1) then
      begin
        ins := ins - 1;
        x := x - mysize;
        if ins <= 1 then
        begin
          ins := 1;
        end;
      end;
    end;
    if key = 19712 then
    begin
      if (x >= xold) and (ins <= length(answer)) then
      begin
        ins := ins + 1;
        x := x + mysize;
      end;
    end;
    if key = 8 then
    begin
      if x >= xold then
      begin
        x := x - mysize;
        ins := ins - 1;
        delete(answer, ins, 1);
      end;
      if ins <= 1 then
      begin
        ins := 1;
      end;
    end;
    if key = 21248 then
    begin
      if x >= xold then
      begin
        delete(answer, ins, 1);
      end;
      if ins <= 1 then
      begin
        ins := 1;
      end;
    end;
    if key = 18176 then
    begin
      x := xold;
      ins := 1;
    end;
    if key = 20224 then
    begin
      x := (length(answer)) * mysize + xold;
      ins := (length(answer) + 1);
    end;
    if x <= xold then
    begin
      x := xold;
    end;
    setfillstyle(solidfill, getbkcolor());
    bar(x, y, xold * mysize, y + mysize);
    moveto(xold, y);
    OutText(answer);
  until (key = 13) or (key = 27);
  result := answer;
end;

procedure InitHighScores;
var
  i: integer;
begin
  for i := 1 to 10 do
  begin
    hiscore[i].score := 0;
    hiscore[i].name := 'No Name';
    hiscore[i].date := FormatDateTime('yyyy-mm-dd', Now);
  end;
end;

procedure SortHighScores;
var
  getauscht: boolean;
  i, temp: integer;
  tempdate, tempstr: ansistring;
begin
  repeat
    getauscht := false;
    for i := 1 to 9 do
      if hiscore[i].score < hiscore[i + 1].score then
      begin
        temp := hiscore[i].score;
        tempstr := hiscore[i].name;
        tempdate := hiscore[i].date;
        hiscore[i].score := hiscore[i + 1].score;
        hiscore[i].name := hiscore[i + 1].name;
        hiscore[i].date := hiscore[i + 1].date;
        hiscore[i + 1].score := temp;
        hiscore[i + 1].name := tempstr;
        hiscore[i + 1].date := tempdate;
        getauscht := true;
      end;
  until not getauscht;
end;

procedure LoadHighscores;
var
  userfile: text;
  i: integer;
begin
  InitHighScores;
  if not fileexists(filename) then
  begin
    assign(userfile, filename);
    rewrite(userfile);
    for i := 1 to 10 do
    begin
      writeln(userfile, hiscore[i].score);
      writeln(userfile, hiscore[i].name);
      writeln(userfile, hiscore[i].date);
    end;
    close(userfile);
  end;
  if fileexists(filename) then
  begin
    assign(userfile, filename);
    reset(userfile);
    for i := 1 to 10 do
    begin
      readln(userfile, hiscore[i].score);
      readln(userfile, hiscore[i].name);
      readln(userfile, hiscore[i].date);
    end;
    close(userfile);
  end;
end;

procedure SaveHighScores;
var
  userfile: text;
  i: integer;
begin
  if fileexists(filename) then
  begin
    assign(userfile, filename);
    rewrite(userfile);
    for i := 1 to 10 do
    begin
      writeln(userfile, hiscore[i].score);
      writeln(userfile, hiscore[i].name);
      writeln(userfile, hiscore[i].date);
    end;
    close(userfile);
  end;
end;

procedure DisplayHighScores;
var
  i: integer;
begin
  SetTextStyle(DefaultFont, HorizDir, 3);
  OutTextXY(200, 50, 'HIGHSCORES');
  for i := 1 to 10 do
  begin
    OutTextXY(40, 120 + i * 30, hiscore[i].name);
    OutTextXY(320, 120 + i * 30, IntToStr(hiscore[i].score));
    OutTextXY(550, 120 + i * 30, hiscore[i].date);
  end;
  OutTextXY(20, 600, 'Press any key to go on!');
end;

function hrgb(red, green, blue: byte): word;
begin
  result := (((red shr 3) shl 11) + ((green shr 2) shl 5) + (blue shr 3));
end;

procedure SetFrameTimer(frames: integer);
begin
  if frames = 0 then
    frames := 1;
  tick_interval := 1000 div frames;
end;

function TimeLeft: UInt32;
var
  now: UInt32;
begin
  now := gettickcount64;
  if next_time <= now then
  begin
    next_time := now + tick_interval;
    result := 0;
    exit;
  end;
  result := next_time - now;
end;

const
  CRSLEFT = 19200;
  CRSRIGHT = 19712;
  CRSUP = 18432;
  CRSDOWN = 20480;
  
var
  gd, gm: smallint;
  page: integer;
  ch, i: integer;
  
begin
  randomize;
  gd := d16bit;
  gm := m1024x768;
  initgraph(gd, gm, '');

  snake.xoffset := 111;
  snake.yoffset := 111;
  snake.xcount := 10;
  snake.ycount := 10;
  snake.width := 8;
  snake.height := 8;
  snake.direction := 'right';
  snake.length := 1;
  setlength(snake.x, snake.length + 1);
  setlength(snake.y, snake.length + 1);
  snake.x[1] := 5;
  snake.y[1] := 5;

  bait.x := 30;
  bait.y := 30;
  bait.xoffset := 111;
  bait.yoffset := 111;
  bait.xcount := 10;
  bait.ycount := 10;
  bait.width := 8;
  bait.height := 8;

  setbkcolor(hrgb(0, 0, 150));
  cleardevice;
  ch := 0;
  page := 0;
  LoadHighscores;
  setcolor(65535);
  DisplayHighScores;
  ReadKey;
  cleardevice;
  SetTextStyle(DefaultFont, HorizDir, 8);
  setcolor(hrgb(250, 0, 0));
  OutTextXY(10, 10, 'SNAKE');
  setcolor(hrgb(250, 250, 0));
  OutTextXY(15, 15, 'SNAKE');

  SetTextStyle(DefaultFont, HorizDir, 2);
  SetFrameTimer(60);
  setcolor(65535);
  OutTextXY(0, 160, 'Please enter your name: ');
  name := grinput(380, 160, 20);

  LoadHighscores;
  SortHighScores;
  lasttime := gettickcount64();

  repeat

    nowtime := gettickcount64();
    if nowtime >= lasttime + 1000 then
    begin
      lasttime := nowtime;
      seconds := seconds - 1;
      if seconds <= 0 then
      begin
        bait.x := random(72);
        bait.y := random(52);
        seconds := 10;
        score := score - 3;
      end;
    end;

    setactivepage(page);
    cleardevice;

    if keypressed then
    begin
      ch := GetKey();
      case ch of
        CRSLEFT:
          snake.direction := 'left';
        CRSRIGHT:
          snake.direction := 'right';
        CRSUP:
          snake.direction := 'up';
        CRSDOWN:
          snake.direction := 'down';
        27:
          endgame := true;
        112:
          ReadKey();
        3:
          begin
            closegraph;
            halt;
          end;

      end;
    end;

    if (snake.x[1] = bait.x) and (snake.y[1] = bait.y) then
    begin
      score := score + 1;
      bait.x := random(72);
      bait.y := random(52);
      snake.length := snake.length + 1;
      setlength(snake.x, snake.length + 1);
      setlength(snake.y, snake.length + 1);
      speed := speed - 0.2;
      nowtime := gettickcount64();
      seconds := 10;
    end;

    if snake.direction = 'right' then
    begin
      for i := snake.length downto 2 do
      begin
        snake.x[i] := snake.x[i - 1];
        snake.y[i] := snake.y[i - 1];
      end;
      snake.x[1] := snake.x[1] + 1;
      sleep(round(speed));
    end;

    if snake.direction = 'down' then
    begin
      for i := snake.length downto 2 do
      begin
        snake.x[i] := snake.x[i - 1];
        snake.y[i] := snake.y[i - 1];
      end;
      snake.y[1] := snake.y[1] + 1;
      sleep(round(speed));
    end;

    if snake.direction = 'left' then
    begin
      for i := snake.length downto 2 do
      begin
        snake.x[i] := snake.x[i - 1];
        snake.y[i] := snake.y[i - 1];
      end;
      snake.x[1] := snake.x[1] - 1;
      sleep(round(speed));
    end;

    if snake.direction = 'up' then
    begin
      for i := snake.length downto 2 do
      begin
        snake.x[i] := snake.x[i - 1];
        snake.y[i] := snake.y[i - 1];
      end;
      snake.y[1] := snake.y[1] - 1;
      sleep(round(speed));
    end;

    for i := 2 to snake.length do
      if (snake.x[1] = snake.x[i]) and (snake.y[1] = snake.y[i]) then
        endgame := true;

    if (snake.x[1] < 0) or (snake.x[1] > 72) or (snake.y[1] < 0) or (snake.y[1] > 52) or (score < 0) then
      endgame := true;

    setcolor(hrgb(255, 0, 0));
    setfillstyle(solidfill, getcolor());
    fillellipse((bait.xoffset + bait.x * bait.xcount) + bait.width div 2,
      (bait.yoffset + bait.y * bait.ycount) + bait.width div 2,
      bait.width div 2, bait.width div 2);

    setcolor(hrgb(255, 255, 0));
    setfillstyle(solidfill, getcolor());
    for i := 1 to snake.length do
    begin
      bar(snake.xoffset + snake.x[i] * snake.xcount, snake.yoffset + snake.y[i]
        * snake.ycount, (snake.xoffset + snake.x[i] * snake.xcount) +
        snake.width, (snake.yoffset + snake.y[i] * snake.ycount) +
        snake.height);
    end;

    setcolor(65535);
    setfillstyle(solidfill, getcolor());
    bar(100, 100, 850, 110);
    bar(100, 100, 110, 650);
    bar(100, 641, 850, 650);
    bar(841, 100, 850, 650);
    OutTextXY(100, 80, name);
    OutTextXY(700, 80, 'Score: ' + IntToStr(score));
    OutTextXY(500, 80, 'Time: ' + IntToStr(seconds));

    setvisualpage(page);
    inc(page);
    if page > 1 then
    begin
      page := 0;
    end;
    sleep(TimeLeft());
  until endgame = true;

  setcolor(65535);
  OutTextXY(GetMaxX() div 2 - 100, GetMaxY() div 2 - 8, 'GAME OVER!');
  OutTextXY(GetMaxX() div 2 - 200, GetMaxY() div 2 + 8,
    'Press any key to exit.');
  if ReadKey = #0 then
    Readkey;

  if score > hiscore[10].score then
  begin
    hiscore[10].score := score;
    hiscore[10].name := name;
    hiscore[10].date := FormatDateTime('yyyy-mm-dd', now);
    SortHighScores;
    SaveHighScores;
  end;
  cleardevice;
  DisplayHighScores;
  if ReadKey = #0 then
    Readkey;

  closegraph;
end.

