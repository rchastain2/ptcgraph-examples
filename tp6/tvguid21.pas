{************************************************}
{                                                }
{   Turbo Pascal 6.0                             }
{   Demo program from the Turbo Vision Guide     }
{                                                }
{   Copyright (c) 1990 by Borland International  }
{                                                }
{************************************************}

{ Create and display a collection of graphical objects:
  Points, Circles, Rectangles. Then put them on a stream
  to be read by another program (TVGUID22.PAS).
}

program TVGUID21;

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
    procedure Store(var S: TStream); virtual;
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
    procedure Store(var S: TStream); virtual;
  end;

  PGraphRect = ^TGraphRect;
  TGraphRect = object(TGraphObject)
    Width, Height: Integer;
    constructor Init;
    procedure Draw; virtual;
    procedure Store(var S: TStream); virtual;
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

procedure TGraphObject.Store(var S: TStream);
begin
  S.Write(X, SizeOf(X));
  S.Write(Y, SizeOf(Y));
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

procedure TGraphCircle.Store(var S: TStream);
begin
  TGraphObject.Store(S);
  S.Write(Radius, SizeOf(Radius));
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

procedure TGraphRect.Store(var S: TStream);
begin
  TGraphObject.Store(S);
  S.Write(Width, SizeOf(Width));
  S.Write(Height, SizeOf(Height));
end;

{ ********************************** }
{ **  Stream Registration Records ** }
{ ********************************** }

const
  RGraphPoint: TStreamRec = (
    ObjType: 150;
    VmtLink: Ofs(TypeOf(TGraphPoint)^);
    Load: nil;                             { No load method yet }
    Store: @TGraphPoint.Store);

  RGraphCircle: TStreamRec = (
    ObjType: 151;
    VmtLink: Ofs(TypeOf(TGraphCircle)^);
    Load: nil;                             { No load method yet }
    Store: @TGraphCircle.Store);

  RGraphRect: TStreamRec = (
    ObjType: 152;
    VmtLink: Ofs(TypeOf(TGraphRect)^);
    Load: nil;                             { No load method yet }
    Store: @TGraphRect.Store);


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

{ Register all object types that will be put onto the stream.
  This includes standard TVision types, like TCollection.
}

procedure StreamRegistration;
begin
  RegisterType(RCollection);
  RegisterType(RGraphPoint);
  RegisterType(RGraphCircle);
  RegisterType(RGraphRect);
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

procedure CallDraw(P: PGraphObject); far;
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

  for I := 1 to 12 do
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
  GraphicsStream: TBufStream;
begin
  StreamRegistration;                   { Register all streams }
  StartGraphics;                        { Activate graphics }

  { Make the collection and display it }
  MakeCollection(GraphicsList);         { Generate and collect figures }
  DrawAll(GraphicsList);                { Use iterator to draw all }
  Readln;                               { Pause to view figures }

  { Put the collection in a stream on disk }
  GraphicsStream.Init('GRAPHICS.STM', stCreate, 1024);
  GraphicsStream.Put(GraphicsList);     { Output collection }
  GraphicsStream.Done;                  { Shut down stream }

  { Clean up }
  Dispose(GraphicsList, Done);          { Delete collection }
  CloseGraph;                           { Shut down graphics }
end.
