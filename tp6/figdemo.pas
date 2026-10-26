
{ Copyright (c) 1989,90 by Borland International }

program FigureDemo;

{ From Chapter 4 the Turbo Pascal 6.0 User's Guide.
  Extending FIGURES.PAS with type Arc.
}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  //Crt,
  ptcCrt,
  DOS, ptcGraph, Figures;

const
  PathToDrivers = '\TP\BGI';  { Default location of *.BGI files }

type
  Arc = object(Circle)
    StartAngle, EndAngle : Integer;
    constructor Init(InitX, InitY: Integer; InitRadius: Integer;
      InitStartAngle, InitEndAngle: Integer);
    procedure Show; virtual;
    procedure Hide; virtual;
  end;

var
  GraphDriver: Integer;
  GraphMode: Integer;
  ErrorCode: Integer;
  AnArc: Arc;
  ACircle: Circle;


{--------------------------------------------------------}
{ Arc's method declarations:                             }
{--------------------------------------------------------}

constructor Arc.Init(InitX,InitY: Integer; InitRadius: Integer;
  InitStartAngle, InitEndAngle: Integer);
begin
  Circle.Init(InitX, InitY, InitRadius);
  StartAngle := InitStartAngle;
  EndAngle   := InitEndAngle;
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
  { Draw the arc in the background color to hide it }
  ptcGraph.Arc(X, Y, StartAngle, EndAngle, Radius);
  SetColor(TempColor);
end;


{--------------------------------------------------------}
{ Main program:                                          }
{--------------------------------------------------------}

begin
  //GraphDriver := Detect; { Let BGI determine which board you're using }
  GraphDriver := D8bit;
  
  //DetectGraph(GraphDriver, GraphMode);
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

{ All descendents of type Point contain virtual methods and    }
{ *must* be initialized before use through a constructor call. }

  ACircle.Init(151, 82,      { Initial X,Y at 151,82 }
               50);          { Initial radius of 50 pixels }
  AnArc.Init(151, 82,        { Initial X,Y at 151,82 }
             25, 0, 90);     { Initial radius of 50 pixels }
                             { Start angle: 0; End angle: 90 }

{ Replace AnArc with ACircle to drag a circle instead of an }
{ arc. Press Enter to stop dragging and end the program.   }

  ACircle.Drag(5);       { Parameter is # of pixels to drag by }
  CloseGraph;
end.
