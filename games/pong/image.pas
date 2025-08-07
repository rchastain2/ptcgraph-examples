
unit Image;

(* Image class for ptcGraph unit *)

interface

uses
  SysUtils, ptcGraph;
  
type
  TImage = class
    strict private
      FPointer: pointer;
      FSize: word;
      FWidth, FHeight: word;
    public
      constructor Create(const AWidth, AHeight: word);
      destructor Destroy; override;
      procedure Save(const AName: TFileName);
      procedure Load(const AName: TFileName);
      procedure Get(const X, Y: smallint);
      procedure Put(const X, Y: smallint; const APutMode: word = CopyPut);
  end;

implementation
  
constructor TImage.Create(const AWidth, AHeight: word);
begin
  FSize := ImageSize(0, 0, Pred(AWidth), Pred(AHeight));
  FWidth := AWidth;
  FHeight := AHeight;
  GetMem(FPointer, FSize); 
end;

destructor TImage.Destroy;
begin
  FreeMem(FPointer, FSize);
  inherited;
end;

procedure TImage.Save(const AName: TFileName);
var
  LFile: file;
begin
  Assign(LFile, AName);
  Rewrite(LFile, FSize);
  BlockWrite(LFile, FPointer^, 1);
  Close(LFile);
end;

procedure TImage.Load(const AName: TFileName);
var
  LFile: file;
begin
  Assign(LFile, AName);
  Reset(LFile, 1);
  BlockRead(LFile, FPointer^, FSize);
  Close(LFile); 
end;

procedure TImage.Get(const X, Y: smallint);
begin
  GetImage(X, Y, Pred(X + FWidth), Pred(Y + FHeight), FPointer^);
end;

procedure TImage.Put(const X, Y: smallint; const APutMode: word);
begin
  PutImage(X, Y, FPointer^, APutMode);
end;

end.
