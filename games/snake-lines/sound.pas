
unit Sound;

interface

type
  TSound = (
    sndEat,
    sndDie,
    sndHighScore
  );

procedure Play(const aSound: TSound);

implementation

uses
  SysUtils, Bass;
  
var
  vSamples: array[TSound] of HSAMPLE;

procedure Play(const aSound: TSound);
begin
  BASS_ChannelPlay(BASS_SampleGetChannel(vSamples[aSound], FALSE), FALSE);
end;

const
  FILENAME: array[TSound] of string = (
    'resources/sfx_coin_double5.wav',
    'resources/sfx_sounds_impact11.wav',
    'resources/sfx_sounds_fanfare2.wav'
  );
  
var
  vSound: TSound;
  
initialization
  BASS_Init(-1, 44100, 0, nil, nil);
  
  for vSound in TSound do
    if FileExists(FILENAME[vSound])
    then
      vSamples[vSound] := BASS_SampleLoad(
        FALSE,
        pchar(FILENAME[vSound]),
        0,
        0,
        1,
        0
      );
      
finalization
  BASS_Free;
  
end.
