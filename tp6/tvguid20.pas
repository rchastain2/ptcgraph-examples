{************************************************}
{                                                }
{   Turbo Pascal 6.0                             }
{   Demo program from the Turbo Vision Guide     }
{                                                }
{   Copyright (c) 1990 by Borland International  }
{                                                }
{************************************************}

{ Create a collection of graphical objects: Points, Circles,
  and Rectangles. Use the ForEach iterator to display each
  object in the collection.
}

program TVGUID20;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  Objects, ptcGraph;

{ ********************************** }
{ ******  Graphical Objects  ******* }
{ ********************************** }

type
  PGraphObject = ^TGraphObject;
  TGraphObject = object(TObject)
    X,Y: Integer;
    constructor Init;
    procedure Draw; virtual;
  end;

  PGraphPoint = ^TGraphPoint;
  TGraphPoint = object(TGraphObject)
    procedure Draw; virtual;
  end;

  PGraphCircle = ^TGraphCircle;
  TGraphCircle = object(TGraphObject)
    Radius: Integer;
    constructor Init;
    procedure Draw; virtual;
  end;

  PGraphRect = ^TGraphRect;
  TGraphRect = object(TGraphObject)
    Width, Height: Integer;
    constructor Init;
    procedure Draw; virtual;
  end;

{ TGraphObject }
constructor TGraphObject.Init;
begin
  X := Random(GetMaxX);
  Y := Random(GetMaxY);
end;

procedure TGraphObject.Draw;
begin
  Abstract;     { Give error: This object should never be drawn }
end;

{ TGraphPoint }
procedure TGraphPoint.Draw;
var
  DX, DY: Integer;
begin
  { Make it a fat point so you can see it }
  for DX := x - 2 to x + 2 do
    for DY := y - 2 to y + 2 do
      PutPixel(DX, DY, 1);
end;

{ TGraphCircle }
constructor TGraphCircle.Init;
begin
  TGraphObject.Init;
  Radius := 20 + Random(20);
end;

procedure TGraphCircle.Draw;
begin
  Circle(X, Y, Radius);
end;

{ TGraphRect }
constructor TGraphRect.Init;
begin
  TGraphObject.Init;
  Width := 10 + Random(20) + X;
  Height := 6 + Random(15) + Y;
end;

procedure TGraphRect.Draw;
begin
  Rectangle(X, Y, X + Width, Y + Height);
end;


{ ********************************** }
{ ************  Globals ************ }
{ ********************************** }

{ Abort the program and give a message }

procedure Abort(Msg: String);
begin
  Writeln;
  Writeln(Msg);
  Writeln('Program aborting');
  Halt(1);
end;

{ Put the system into graphics mode }

procedure StartGraphics;
var
  Driver, Mode: Integer;
begin
  Driver := Detect;
  InitGraph(Driver, Mode, '');
  if GraphResult <> GrOK then
  begin
    Writeln(GraphErrorMsg(Driver));
    Halt(1);
  end;
end;

{ Use the ForEach iterator to traverse and
  show all the collection of graphical objects.
}

procedure DrawAll(C: PCollection);

{ Nested, far procedure. Receives one
  collection element--a GraphObject, and
  calls that elements Draw method.
}

procedure CallDraw(P : PGraphObject); far;
begin
  P^.Draw;                            { Call Draw method }
end;

begin { DrawAll }
  C^.ForEach(@CallDraw);              { Draw each object }
end;

{ Instantiate and draw a collection of objects }

procedure MakeCollection(var List: PCollection);
var
  I: Integer;
  P: PGraphObject;
begin
  { Initialize collection to hold 10 elements first, then grow by 5's }
  List := New(PCollection, Init(10, 5));

  for I := 1 to 20 do
  begin
    case I mod 3 of                      { Create it }
      0: P := New(PGraphPoint, Init);
      1: P := New(PGraphCircle, Init);
      2: P := New(PGraphRect, Init);
    end;
    List^.Insert(P);                     { Add it to collection }
  end;
end;

{ ********************************** }
{ **********  Main Program ********* }
{ ********************************** }

var
  GraphicsList: PCollection;
begin
  StartGraphics;                       { Activate graphics }

  MakeCollection(GraphicsList);        { Generate and collect figures }
  DrawAll(GraphicsList);               { Use iterator to draw all }
  Readln;                              { Pause to view figures }

  { Clean up }
  Dispose(GraphicsList, Done);         { Delete collection }
  CloseGraph;                          { Shut down graphics }
end.
