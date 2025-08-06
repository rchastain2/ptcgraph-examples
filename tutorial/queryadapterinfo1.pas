
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcgraph, ptccrt;

var
  modeInfo: PModeInfo;

begin
  modeInfo := QueryAdapterInfo;
  
  while modeInfo <> nil do
  begin
    if (modeInfo^.MaxX + 1 = 640) and (modeInfo^.MaxY + 1 = 200) and (modeInfo^.MaxColor = 16) then
    begin
      WindowTitle := 'QueryAdapterInfo example';
      InitGraph(modeInfo^.DriverNumber, modeInfo^.ModeNumber, '');
      readkey;
      modeInfo := nil;
    end else
      modeInfo := modeInfo^.next;
  end;
end.

{
  640 x 200 x 16
  640 x 350 x 16
  640 x 200 x 16
  640 x 350 x 16
  640 x 480 x 16
  320 x 200 x 256
  320 x 200 x 256
  640 x 400 x 256
  640 x 480 x 256
  320 x 200 x 32768
  640 x 480 x 32768
  320 x 200 x 65536
  640 x 480 x 65536
  800 x 600 x 16
  800 x 600 x 256
  800 x 600 x 32768
  800 x 600 x 65536
  1024 x 768 x 16
  1024 x 768 x 256
  1024 x 768 x 32768
  1024 x 768 x 65536
  1280 x 720 x 16
  1280 x 720 x 256
  1280 x 720 x 32768
  1280 x 720 x 65536
  1366 x 768 x 16
  1366 x 768 x 256
  1366 x 768 x 32768
  1366 x 768 x 65536
}
