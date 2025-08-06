
program ondoyant;

(* Programme original :
   http://alcatiz.developpez.com/tutoriel/owl/?page=pg_gdi *)
   
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24;
  
const
  indiceMax = 100;
  vitesse = 50;
  dx1: integer = 4;
  dy1: integer = 10;
  dx2: integer = 3;
  dy2: integer = 9;
  cCouleurFond = cMidnightBlue;
  
type
  tLigne = record
    x1, y1, x2, y2: integer;
    couleur: longword;
  end;
  tTabLignes = array[0..indiceMax] of tLigne;
  
var
  tabLignes: tTabLignes;
  indiceGeneral: integer;
  effacer: boolean;

procedure NouvelleLigne(var coord, intervalle: integer; coordMax: integer; var couleur: longword);
var
  total: integer;
  signe: integer;
begin
  total := coord + intervalle;
  if (total < 0) or (total > coordMax) then
  begin
    if intervalle >= 0 then
      signe := -1
    else
      signe := 1;
    intervalle := signe * (3 + Random(12));
    couleur := Random(1 shl 24);
  end else
    coord := total;
end;

procedure DessinLigne(i: integer);
begin
  with tabLignes[i] do
  begin
    SetColor(couleur);
    Line(x1, y1, x2, y2);
  end;
end;

procedure Redessine;
var
  i: integer;
  ancienIndice: integer;
begin
  for i := 1 to 10 do
  begin
    ancienIndice := indiceGeneral;
    if indiceGeneral = indiceMax - 1 then
    begin
      indiceGeneral := 0;
      effacer := true;
    end else
      Inc(indiceGeneral);
    if effacer then
    begin
      tabLignes[indiceGeneral].couleur := cCouleurFond;
      DessinLigne(indiceGeneral);
    end;
    tabLignes[indiceGeneral] := tabLignes[ancienIndice];
    with tabLignes[indiceGeneral] do
    begin
      NouvelleLigne(x1, dx1, GetMaxX, couleur);
      NouvelleLigne(y1, dy1, GetMaxY, couleur);
      NouvelleLigne(x2, dx2, GetMaxX, couleur);
      NouvelleLigne(y2, dy2, GetMaxY, couleur);
    end;
    DessinLigne(indiceGeneral);
  end;
end;

var
  LDriver, LMode: smallint;
  LGraphResult: integer;
  
begin
  Randomize;
  
  FullScreenGraph := TRUE;
  DetectGraph(LDriver, LMode);
  InitGraph(LDriver, LMode, '');
  LGraphResult := GraphResult;
  
  if LGraphResult = grOK then
  begin
    SetBkColor(cCouleurFond);
    ClearDevice;
    repeat
      Redessine;
      Delay(vitesse);
    until KeyPressed;
    CloseGraph;
  end else
    WriteLn(GraphErrorMsg(LGraphResult));
end.
