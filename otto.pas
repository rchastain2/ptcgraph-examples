Program Otto;
{ https://gorbem.hu/TP/Grafika.htm }
Uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
Const HSz=4;
Var MX, MY: Integer;
Type Henger= Object
               FX, FY, FD, FS: Real;
               X, Y, D, R, T: Integer;
               Mf: Integer;
               Procedure Init(IX, IY, ID: Real);
               Procedure SetFazis(&IS: Real);
               Function GetSzog: Integer;
               Function GetMFazis: Integer;
               Procedure FrameDraw;
               Procedure Show;
             End;

     Control= Object
                HT: Array[1..Hsz] Of Henger;
                F: Integer;
                Procedure Init;
                Procedure Run;
                Procedure Done;
              End;

Procedure Henger.Init(IX, IY, ID: Real);
Begin
  FX:= IX; FY:= IY; FD:= ID;
  X:= Round(FX*MX); Y:= Round(FY*MY); D:= Round(FD*MX);
  R:= Round(0.4*D);
End;

Procedure Henger.SetFazis(&IS:Real);
Begin
  FS:= &IS;
  T:= Round(R*Sin(FS*Pi/180));
  Case Round(FS) Of
       0..89: Mf:=1;
     90..269: Mf:=2;
    270..449: Mf:=3;
    450..629: Mf:=4;
    630..719: Mf:=1;
  End;
End;

Function Henger.GetSzog:Integer;
Begin
  GetSzog:= Round(FS);
End;

Function Henger.GetMFazis: Integer;
Begin
  GetMFazis:= Mf;
End;

Procedure Henger.FrameDraw;
Begin
  SetWriteMode(0);
  Setcolor(15);
  {henger}
  Moveto(X, Y+2*D);
  LineTo(X, Y);
  LineTo(Round(X+0.05*D), Round(Y-0.05*D));
  Lineto(Round(X+0.95*D), Round(Y-0.05*D));
  LineTo(X+D, Y);
  LineTo(X+D, Y+2*D);
  {gyertya}
  SetFillStyle(1,15);
  Bar(Round(X+0.47*D), Round(Y-0.1*D), Round(X+0.53*D), Y);
  Line(Round(X+0.5*D), Round(Y-0.15*D), Round(X+0.5*D), Y);
  {szelepek}
  SetLineStyle(SolidLn, 0, ThickWidth);
  Line(Round(X+0.1*D), Round(Y-0.05*D),

       Round(X+0.3*D), Round(Y-0.05*D));
  Line(Round(X+0.2*D), Round(Y-0.25*D),

       Round(X+0.2*D), Round(Y-0.05*D));
  Line(Round(X+0.7*D), Round(Y-0.05*D), 

       Round(X+0.9*D), Round(Y-0.05*D));
  Line(Round(X+0.8*D), Round(Y-0.25*D),

       Round(X+0.8*D), Round(Y-0.05*D));
  SetLineStyle(SolidLn, 0, NormWidth);
  {főtengely}
  Circle(Round(X+D*0.5), Y+3*D, R);
End;

Procedure Henger.Show;
Begin
  SetWriteMode(XorPut);
  Rectangle(Round(X+0.02*D), Round(Y+0.1*D+0.5*D+T),
            Round(X+D-0.02*D), Round(Y+0.7*D+0.5*D+T));
  Line(Round(X+D*0.5),Y+3*D,
       Round(X+D*0.5+R*Cos(FS*Pi/180)),

       Round(Y+3*D+R*Sin(FS*Pi/180)));
  Line(Round(X+D*0.5), Round(Y+D*0.7+0.5*D)+T,
       Round(X+D*0.5+R*Cos(FS*Pi/180)),

       Round(Y+3*D+R*Sin(FS*Pi/180)));
  SetWriteMode(0);
  If ((GetSzog-90) Mod 180)=0 Then
  Begin
    {aláírás, szelepek}
    SetViewPort(X, Round(Y+3.5*D), X+D, 

                Round(Y+3.6*D), ClipOn);
    ClearViewPort;
    SetViewPort(0, 0, MX, MY, ClipOff);
    Case GetMFazis of
      1:Begin
          SetViewPort(Round(X+0.1*D),Round(Y-0.25*D),
                      Round(X+0.3*D),Round(Y+0.06*D),ClipOn);
          ClearViewPort;
          SetViewPort(Round(X+0.7*D),Round(Y-0.25*D),
                      Round(X+0.9*D),Round(Y+0.06*D),ClipOn);
          ClearViewPort;
          SetViewPort(0, 0, MX, MY, ClipOff);
          SetLineStyle(SolidLn, 0, ThickWidth);
          Line(Round(X+0.1*D), Round(Y+0.05*D),
               Round(X+0.3*D), Round(Y+0.05*D));
          Line(Round(X+0.2*D), Round(Y-0.15*D),
               Round(X+0.2*D), Round(Y+0.05*D));
          line(Round(X+0.7*D), Round(Y-0.05*D),
               Round(X+0.9*D), Round(Y-0.05*D));
          line(Round(X+0.8*D), Round(Y-0.25*D),
               Round(X+0.8*D), Round(Y-0.05*D));
          SetLineStyle(SolidLn, 0, NormWidth);
          OutTextXY(Round(X+0.3*D), Round(Y+3.5*D), 'Szívás')
        End;
      2:Begin
          SetViewPort(Round(X+0.1*D), Round(Y-0.25*D),
                      Round(X+0.3*D), Round(Y+0.06*D),ClipOn);
          ClearViewPort;
          SetViewPort(0, 0, MX, MY, ClipOff);
          SetLineStyle(SolidLn, 0, ThickWidth);
          Line(Round(X+0.1*D), Round(Y-0.05*D),
               Round(X+0.3*D), Round(Y-0.05*D));
          Line(Round(X+0.2*D), Round(Y-0.25*D),
               Round(X+0.2*D), Round(Y-0.05*D));
          SetLineStyle(SolidLn, 0, NormWidth);
          OutTextXY(Round(X+0.3*D), Round(Y+3.5*D), 'Sűrítés');
        End;
      3:Begin
          OutTextXY(Round(X+0.48*D), Round(Y+0.02*D), '*');
          Sound(700); Delay(30); NoSound;
          SetViewPort(Round(X+0.46*D), Round(Y+0.01*D),
                      Round(X+0.54*D), Round(Y+0.06*D),

                      ClipOn);
          ClearViewPort;
          SetViewPort(0, 0, MX, MY, ClipOff);
          OutTextXY(Round(X+0.3*D),

                    Round(Y+3.5*D), 'Munkaütem');
        End;
      4:Begin
          SetViewPort(Round(X+0.1*D), Round(Y-0.25*D),
                      Round(X+0.3*D), Round(Y+0.06*D), ClipOn);
          ClearViewPort;
          SetViewPort(Round(X+0.7*D), Round(Y-0.25*D),
                      Round(X+0.9*D), Round(Y+0.06*D), ClipOn);
          ClearViewPort;
          SetViewPort(0, 0, MX, MY, ClipOff);
          SetLineStyle(SolidLn, 0, ThickWidth);
          Line(Round(X+0.1*D), Round(Y-0.05*D),
               Round(X+0.3*D), Round(Y-0.05*D));
          Line(Round(X+0.2*D), Round(Y-0.25*D),
               Round(X+0.2*D), Round(Y-0.05*D));
          Line(Round(X+0.7*D), Round(Y+0.05*D),
               Round(X+0.9*D), Round(Y+0.05*D));
          Line(Round(X+0.8*D), Round(Y-0.15*D),
               Round(X+0.8*D), Round(Y+0.05*D));
          SetLineStyle(SolidLn, 0, NormWidth);
          OutTextXY(Round(X+0.3*D),

                    Round(Y+3.5*D), 'Kipufogás');
        End;
    End;
  End;
End;

Procedure Control.Init;
Const Xt: Array[1..4] Of Real= (0.1,0.3,0.5,0.7);
      Ft: Array[1..4] Of Integer= (0,540,180,360);
Var Gd, Gm, I: SmallInt;
Begin
 {DetectGraph(Gd, Gm);}
  Gd := 10;
  Gm := 258;
  InitGraph(Gd, Gm, 'C:\Tp\bgi');
  MX:= GetMaxX; MY:= GetMaxY;
  For I:= 1 to HSz Do With HT[i] Do
  Begin
    Init(Xt[I],0.1,0.18); F:= Ft[I]; SetFazis(F);

    FrameDraw; Show;
  End;
End;

Procedure Control.Run;
Var Sd, I: Integer;
Begin
  Sd:= 5;
  Repeat
    For I:= 1 To HSz Do With HT[I] do
    Begin
      Show; F:=GetSzog; Inc(F, Sd); F:=F Mod 720;

      SetFazis(F); Show;
    End;
    Delay(12);
  Until keypressed;
End;

Procedure Control.Done;
Begin
  ClearDevice;
  CloseGraph;
End;

Var Ctr: Control;

Begin
  Ctr.Init;
  Ctr.Run;
  Ctr.Done;
End.
