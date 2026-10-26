program Animation;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24; { подключение к программе библиотек Crt и Graph }
const { вертикальные и горизонтальные координаты положения рук }
  Vert: array[1..3] of Integer = (190, 157, 120);
  Horizont: array[1..3] of Integer = (200, 190, 200);
var
  i, j: Integer;
  GrDriver, GrMode, GrError: SmallInt;
begin
  GrDriver := Detect; InitGraph(GrDriver, GrMode, '');
  GrError := GraphResult; if GrError <> GrOk then Halt;

  SetColor(cLightGray); { установка светлосерого цвета для рамки}
  Rectangle(20, 20, 480, 400); { рисование рамки                       }
  SetColor(cLightCyan); {установка яркоголубого цвета для текста}
  OutTextXY(200, 40, 'П Р И В Е Т !');

  SetColor(cLightGray); Circle(250, 130, 20); { голова      }
  SetColor(cYellow); Arc(250, 130, 0, 180, 26); { волосы      }
  Arc(250, 130, 0, 180, 24); Arc(250, 130, 0, 180, 22);
  Line(250, 105, 244, 115); Line(250, 105, 250, 116); { чубчик      }
  Line(250, 105, 256, 115);
  SetColor(cLightCyan); Circle(241, 125, 4); { левый глаз  }
  Circle(259, 125, 4); { правый глаз }
  SetColor(cLightRed);
  SetFillStyle(SolidFill, cLightRed);
  FillEllipse(250, 140, 6, 3); { рот         }
  Setcolor(cGreen);
  Line(250, 152, 250, 220); { туловище    }
  Line(250, 220, 210, 290); { левая нога  }
  Line(250, 220, 290, 290); { правая нога }

  repeat { цикл прерывается нажатием любой клавиши    }
    for i := 1 to 3 do { последовательный вывод трех положений рук: }
    begin { вниз, на уровне плеч, вверх                }
      SetColor(cLightCyan);// Sound(200 * i);
      Line(250, 157, Horizont[i], Vert[i]); { левая рука  }
      Line(250, 157, 500 - Horizont[i], Vert[i]); { правая рука }
      Delay(300); { задержка    }

      SetColor(cBlack); { смена цвета на черный для повторного }
         { pисования рук в том же положении ("стирания" их с экрана) }
      Line(250, 157, Horizont[i], Vert[i]); { левая рука  }
      Line(250, 157, 500 - Horizont[i], Vert[i]); { правая рука }
    end
  until Keypressed;

  SetColor(cLightCyan);
  Line(250, 157, Horizont[3], Vert[3]); { левая рука поднята }
  Line(250, 157, 500 - Horizont[3], Vert[3]); { правая рука поднята}
  
  (*
  for i := 1 to 10 do { звуковая трель   }
  begin
    Sound(1000);
    Delay(50);
    Sound(1500);
    Delay(50)
  end;
  *)
  
  ReadKey;
  
  //NoSound; { выключение звука }
  CloseGraph;
end.
