program Whatever;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  GraphBits,
  Buttons;

var
  Button: TButton;

begin
  GraphicsScreen;
  while Key.KeyOne <> Esc[1] do
  begin
    Button.Draw(10, 10, 'Hi there, I''m a button.', ButtonOut, Space);
    Key.GetKeys;
    Button.TestForPress;
  end;
  CloseGraph;
end.
