unit UManager;

interface

  uses ptcgraph, UGameState, UConfig,
       UMainMenu, UHelpScreen, UAboutScreen,
       UGame, UPauseMenu, ptccrt;

  procedure draw;
  function update(c:char):integer;
  procedure init;

implementation

  var curpage: integer = 0;

  procedure draw;
  var state: integer;
  begin
    //setactivepage((curpage + 1) mod 2);
    //cleardevice;
    state := getstate;
    case state of
      GAME_STATE:
        begin
          drawgame;
        end;
      MAIN_MENU_STATE:
        begin
          drawmainmenu;
        end;
      HELP_STATE:
        begin
          drawhelpscreen;
        end;
      ABOUT_STATE:
        drawaboutscreen;
      PAUSE_STATE:
        drawpausemenu;
    end;
  //delay(1000);
    //setvisualpage((curpage + 1) mod 2);
    //curpage := (curpage + 1) mod 2
  end;

  function update(c: char):integer;
  var state, res: integer;
  begin
    res := 0;
    state := getstate;
    case state of
      GAME_STATE:
        begin
          res := updateGame(c);
        end;
      MAIN_MENU_STATE:
        begin
          res := updateMainMenu(c);
        end;
      HELP_STATE:
        begin
          res := updateHelpScreen(c);
        end;
      ABOUT_STATE:
        res := updateaboutscreen(c);
      PAUSE_STATE:
        res := updatePauseMenu(c);
    end;
    update := res;
  end;

  procedure shutDown;
  begin
    closegraph;
    exit;
  end;

  procedure init;
  var c: char;
      res: integer;
  begin
    initgame;
    initmainmenu;
    pushstate(MAIN_MENU_STATE);
    draw;
    repeat
      c := readkey;
      res := update(c);
      case res of
        EXIT_CODE:
          begin
            shutdown;
            break;
          end;
        MAIN_MENU_EXIT:
          begin
            shutdown;
            saveprogress;
            break;
          end;
        MAIN_MENU_HELP:
          begin
            pushState(HELP_STATE);
            draw;
          end;
        MAIN_MENU_ABOUT:
          begin
            pushState(ABOUT_STATE);
            draw;
          end;
        MAIN_MENU_PLAY:
          begin
            restartGame;
            pushState(GAME_STATE);
            draw;
          end;
        MAIN_MENU_CONTINUE:
          begin
            initgame;
            pushstate(GAME_STATE);
            draw;
          end;
        HELP_SCREEN_EXIT:
          begin
            delstate;
            draw;
          end;
        ABOUT_SCREEN_EXIT:
          begin
            delstate;
            draw;
          end;
        GAME_REDRAW:
          draw;
        PAUSE_MENU_EXIT:
          begin
            delstate;
            draw;
          end;
        GAME_PAUSE:
          begin
            initpausemenu;
            pushstate(PAUSE_STATE);
            draw;
          end;
        PAUSE_MENU_RESTART:
          begin
            delstate;
            restart;
            draw;
          end;
        PAUSE_MENU_TO_MAIN:
          begin
            delstate;
            delstate;
            saveprogress;
            initmainmenu;
            draw;
          end;
        PAUSE_MENU_EXIT_CODE:
          begin
            saveprogress;
            shutdown;
            break;
          end;
      end;
    until false;
  end;



end.
