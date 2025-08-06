
(* http://pascal.net.ru/Settxtjs+PAS *)

{ Пример программы для процедуры SetTextJustify }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  Gd, Gm : smallint;

begin
  Gd := Detect;
  InitGraph(Gd, Gm, 'X:\BP');
  if GraphResult <> grOk then
    Halt(1);
  SetColor($FFFFFF);
  { Центрируем текст на экране }
  SetTextJustify(CenterText, CenterText);
  OutTextXY(GetMaxX div 2, GetMaxY div 2, 'Easily Centered');
  ReadKey;
  CloseGraph;
end.

(*
Procedure SetTextJustify(h_hori,i_vert:Word);
Paramètres
Nom 	Description
h_hori 	Ce paramètre permet d'indiquer la justification du texte horizontal:
Constante 	Valeur 	Description
LeftText 	0 	Cette constante permet d'effectuer la justification du texte vers la gauche
CenterText 	1 	Cette constante permet d'indiquer la justification du texte vers le centre
RightText 	2 	Cette constante permet d'indiquer la justification du texte vers la droite
i_vert 	Ce paramètre permet d'indiquer la justification du texte vertical:
Constante 	Valeur 	Description
BottomText 	0 	Cette constante permet d'indiquer la justification du texte vers le bas
CenterText 	1 	Cette constante permet d'indiquer la justification du texte vers le milieu
TopText 	3 	Cette constante permet d'indiquer la justification du texte vers le haut
Description

Cette procédure permet de fixer la justification de la police de caractères BGI courante d'un écran graphique.
Remarques

    La sortie de texte après une procédure SetTextJustify sera justifiée autour du pointeur actuel de la manière spécifiée.
    Si une entrée non valide est transmise à la procédure SetTextJustify, la fonction GraphResult renvoie une valeur de grError et les paramètres de justification de texte actuels seront inchangés.
    
*)
