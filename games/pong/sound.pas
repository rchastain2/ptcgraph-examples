
unit Sound;

interface

type
  TSound = (
    sndWall,
    sndPaddle,
    sndFall
  );

procedure Play(const aSound: TSound);

implementation

uses
  SysUtils, Bass;
  
var
  lSamples: array[TSound] of HSAMPLE;

procedure Play(const aSound: TSound);
begin
  BASS_ChannelPlay(BASS_SampleGetChannel(lSamples[aSound], FALSE), FALSE);
end;

const
  cFileName: array[TSound] of string = (
    'sounds/sfx_coin_single4.wav',
    'sounds/sfx_coin_single5.wav',
    'sounds/sfx_coin_single6.wav'
  );
  
var
  s: TSound;
  
initialization
  BASS_Init(-1, 44100, 0, nil, nil);
  
  for s in TSound do
    if FileExists(cFileName[s]) then
      lSamples[s] := BASS_SampleLoad(FALSE, pchar(cFileName[s]), 0, 0, 1, 0);
      
finalization
  BASS_Free;
  
end.
