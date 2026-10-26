unit UGameState;

interface

  const MAX_STATES = 100;
  type tgamestatestack = array[1..MAX_STATES] of integer;
  procedure pushState(const i: integer);
  function getState: integer;
  procedure delState;


implementation

  var states: tgamestatestack;
      k: integer = 0;

  procedure pushState(const i: integer);
  begin
    inc(k);
    states[k] := i;
  end;

  function getState: integer;
  begin
    getState := states[k];
  end;

  procedure delState;
  begin
    if k > 0 then dec(k);
  end;

end.