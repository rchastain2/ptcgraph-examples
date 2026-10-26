{$N+}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph;

Type
  TPoint =
    Record
      X, Y: Integer;
    End;

  PArrPoint = ^arrPoint;
  arrPoint =
    Array[1 .. maxInt Div SizeOf(TPoint)] Of TPoint;

  TFigure =
    Object
      nPoints: Byte;
      arr: PArrPoint;

      p: Integer;
      a: Double;

      Constructor Init(np: Integer;
        pVal: Integer; aVal: Double);
      Destructor Done;
      Procedure Run;

    Private
      Procedure InitPoints;

      Function Recalc: Boolean;
      Procedure Draw;
    End;

Constructor TFigure.Init(np: Integer;
            pVal: Integer; aVal: Double);
  Begin
    nPoints := np;
    a := aVal; p := pVal;
    GetMem(arr, nPoints * SizeOf(TPoint));

    InitPoints
  End;

Destructor TFigure.Done;
  Begin
    FreeMem(arr, nPoints * SizeOf(TPoint));
  End;

Procedure TFigure.InitPoints;

  Const
    RadToGrad = (180 / Pi);

  Procedure GetPoint(Var P: TPoint;
            Len: Integer; phi: Integer);
    Var fPhi: Double;
    Begin
      fPhi := phi / RadToGrad;
      P.X := (GetMaXX div 2) + Trunc(Len * Sin(fPhi));
      P.Y := (GetMaxY div 2) - Trunc(Len * Cos(fPhi));
    End;

  Var
    i, Len, phi: Integer;
    x: Double;
  Begin
    phi := 360 div nPoints;
    x := Cos(phi / RadToGrad);
    Len := Trunc(p / Sqrt(2* (1 - x)));

    For i := 1 To nPoints Do
      GetPoint(arr^[i], Len, Pred(i) * phi);
  End;

Function TFigure.Recalc: Boolean;
  Var
    T: PArrPoint;
    i, next: Integer;
  Begin
    GetMem(T, nPoints * SizeOf(TPoint));
    For i := 1 To nPoints Do
      Begin
        If i = nPoints Then next := 1 Else next := Succ(i);

        T^[i].x := Trunc((arr^[i].x + a*arr^[next].x) / (1 + a));
        T^[i].y := Trunc((arr^[i].y + a*arr^[next].y) / (1 + a));
      End;
    Recalc := (T^[1].x <> arr^[1].x);

    Move(T^, arr^, nPoints * SizeOf(TPoint));
    FreeMem(T, nPoints * SizeOf(TPoint))
  End;

Procedure TFigure.Draw;

  Procedure DrawLine( p1, p2: TPoint );
    Begin
      Line( p1.X, p1.Y, p2.X, p2.Y )
    End;

  Var
    i, next: Integer;
  Begin
    For i := 1 To nPoints Do
      Begin
        next := Succ(i);
        If i = nPoints Then next := 1;
        DrawLine( arr^[i], arr^[next] );
      End;
  End;


Procedure TFigure.Run;
  Begin
    Repeat
      Draw
    Until not ReCalc;
    //ReadLn
  End;


Var
  f: TFigure;

  grDriver, grMode, ErrCode: SmallInt;
Begin
  grDriver := Detect;
  InitGraph(grDriver, grMode, '');
  ErrCode := GraphResult;
  If ErrCode <> grOk Then
    Begin
      WriteLn('Graphic Error: ', GraphErrorMsg(ErrCode));
      Halt(100)
    End;
  
  SetColor($FFFF00);
  
  { 7 вершин, длина каждой стороны = 140, коэффициент = 0.05 }
  f.Init( 7, 140, 0.05 );
  f.Run;
  f.Done;
  
  ReadKey;
  CloseGraph;
End.
