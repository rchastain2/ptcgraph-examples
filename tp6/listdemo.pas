
{ Turbo List }
{ Copyright (c) 1989,90 by Borland International, Inc. }

program ListDemo;

{ From Chapter 4 the Turbo Pascal 6.0 User's Guide.
  Dynamic objects & destructors.
}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, Figures,
  ptcCrt;

const
  PathToDrivers = '\TP\BGI';  { Default location of *.BGI files }
  MemAvail = 0;

type
  ArcPtr = ^Arc;
  Arc = object(Circle)
    StartAngle, EndAngle: Integer;
    constructor Init(InitX, InitY: Integer; InitRadius: Integer;
      InitStartAngle, InitEndAngle: Integer);
    procedure Show; virtual;
    procedure Hide; virtual;
  end;

  NodePtr = ^Node;
  Node = record
    Item: PointPtr;
    Next: NodePtr;
  end;

  ListPtr = ^List;
  List = object
    Nodes: NodePtr;
    constructor Init;
    destructor Done; virtual;
    procedure Add(Item: PointPtr);
    procedure Report;
  end;

var
  GraphDriver: Integer;
  GraphMode: Integer;
  Temp: String;
  AList: List;
  PArc: ArcPtr;
  PCircle: CirclePtr;
  RootNode: NodePtr;


{--------------------------------------------------------}
{ Procedures that are not methods:                       }
{--------------------------------------------------------}

procedure OutTextLn(TheText: String);
begin
  OutText(TheText);
  MoveTo(0, GetY+12);
end;

procedure HeapStatus(StatusMessage: String);
begin
  Str(MemAvail: 6, Temp);
  OutTextLn(StatusMessage+Temp);
end;


{--------------------------------------------------------}
{ Arc's method implementations:                          }
{--------------------------------------------------------}

constructor Arc.Init(InitX, InitY: Integer; InitRadius: Integer;
  InitStartAngle, InitEndAngle: Integer);
begin
  Circle.Init(InitX, InitY, InitRadius);
  StartAngle := InitStartAngle;
  EndAngle := InitEndAngle;
end;

procedure Arc.Show;
begin
  Visible := True;
  ptcGraph.Arc(X, Y, StartAngle, EndAngle, Radius);
end;

procedure Arc.Hide;
var
  TempColor: Word;
begin
  TempColor := ptcGraph.GetColor;
  ptcGraph.SetColor(GetBkColor);
  Visible := False;
  ptcGraph.Arc(X, Y, StartAngle, EndAngle, Radius);
  SetColor(TempColor);
end;


{--------------------------------------------------------}
{ List's method implementations:                         }
{--------------------------------------------------------}

constructor List.Init;
begin
  Nodes := nil;
end;

destructor List.Done;
var
  N: NodePtr;
begin
  while Nodes <> nil do
  begin
    N := Nodes;
    Nodes := N^.Next;
    Dispose(N^.Item, Done);
    Dispose(N);
  end;
end;

procedure List.Add(Item: PointPtr);
var
  N: NodePtr;
begin
  New(N);
  N^.Item := Item;
  N^.Next := Nodes;
  Nodes := N;
end;

procedure List.Report;
var
  Current: NodePtr;
begin
  Current := Nodes;
  while Current <> nil do
  begin
    Str(Current^.Item^.GetX:3, Temp);
    OutTextLn('X = ' + Temp);
    Str(Current^.Item^.GetY:3, Temp);
    OutTextLn('Y = ' + Temp);
    Current := Current^.Next;
  end;
end;


{--------------------------------------------------------}
{ Main program:                                          }
{--------------------------------------------------------}

begin
  { Let BGI determine which board you're using: }
  //DetectGraph(GraphDriver, GraphMode);
  GraphDriver := D8Bit;
  GraphMode := M640x480;
  
  InitGraph(GraphDriver, GraphMode, PathToDrivers);
  if GraphResult <> GrOK then
  begin
    Writeln(GraphErrorMsg(GraphDriver));
    if GraphDriver = grFileNotFound then
    begin
      Writeln('in ', PathToDrivers,
        '. Modify this program''s "PathToDrivers"');
      Writeln('constant to specify the actual location of this file.');
      Writeln;
    end;
    Writeln('Press Enter...');
    Readln;
    Halt(1);
  end;

  HeapStatus('Heap space before list is allocated: ');

  { Create a list }
  AList.Init;

  { Now create and add several figures to it in one operation }
  AList.Add(New(ArcPtr, Init(151, 82, 25, 200, 330)));
  AList.Add(New(CirclePtr, Init(400, 100, 40)));
  AList.Add(New(CirclePtr, Init(305, 136, 5)));

  { Traverse the list and display X,Y of the list's figures }
  AList.Report;

  HeapStatus('Heap space after list is allocated ');

  { Deallocate the whole list with one destructor call }
  AList.Done;

  HeapStatus('Heap space after list is cleaned up: ');

  OutText('Press Enter to end program: ');
  //Readln;
  ReadKey;
  
  CloseGraph;
end.
