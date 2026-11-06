# Which graphic modes are available?

`QueryAdapterInfo` returns the list of the modes supported by *ptcGraph*. The `gmodeinfo.pas` program of this folder displays it, with the driver number, the mode number, the resolution and the number of colors. The driver and mode numbers can be passed to `InitGraph`; many of them also have a constant, such as `VESA` and `m800x600x64k`.

Output with Free Pascal 3.2.2 on Linux:

```
№ драйвера № режима Разрешение   Цветов
----------------------------------------------------------
         1        0    320x200        4   320 x 200 CGA C0
         1        1    320x200        4   320 x 200 CGA C1
         1        2    320x200        4   320 x 200 CGA C2
         1        3    320x200        4   320 x 200 CGA C3
         1        4    640x200        2      640 x 200 CGA
         2        0    320x200        4   320 x 200 CGA C0
         2        1    320x200        4   320 x 200 CGA C1
         2        2    320x200        4   320 x 200 CGA C2
         2        3    320x200        4   320 x 200 CGA C3
         2        4    640x200        2      640 x 200 CGA
         2        5    640x480        2     640 x 480 MCGA
         7        0    720x348        2 720 x 348 HERCULES
         3        0    640x200       16      640 x 200 EGA
         3        1    640x350       16      640 x 350 EGA
         9        0    640x200       16      640 x 200 EGA
         9        1    640x350       16      640 x 350 EGA
         9        2    640x480       16      640 x 480 VGA
         6        0    320x200      256      320 x 200 VGA
         6        1    320x200      256    320 x 200 ModeX
        10      256    640x400      256     640 x 400 VESA
        10      257    640x480      256     640 x 480 VESA
        10      269    320x200    32768     320 x 200 VESA
        10      272    640x480    32768     640 x 480 VESA
        10      270    320x200    65536     320 x 200 VESA
        10      273    640x480    65536     640 x 480 VESA
        10      271    320x200 16777216     320 x 200 VESA
        10      274    640x480 16777216     640 x 480 VESA
        10      258    800x600       16     800 x 600 VESA
        10      259    800x600      256     800 x 600 VESA
        10      275    800x600    32768     800 x 600 VESA
        10      276    800x600    65536     800 x 600 VESA
        10      277    800x600 16777216     800 x 600 VESA
        10      260   1024x768       16    1024 x 768 VESA
        10      261   1024x768      256    1024 x 768 VESA
        10      278   1024x768    32768    1024 x 768 VESA
        10      279   1024x768    65536    1024 x 768 VESA
        10      280   1024x768 16777216    1024 x 768 VESA
        10      512    320x240       16     320 x 240 VESA
        10      513    320x240      256     320 x 240 VESA
        10      514    320x240    32768     320 x 240 VESA
        10      515    320x240    65536     320 x 240 VESA
        10      516    320x240 16777216     320 x 240 VESA
        10      517    720x400       16     720 x 400 VESA
        10      518    720x400      256     720 x 400 VESA
        10      519    720x400    32768     720 x 400 VESA
        10      520    720x400    65536     720 x 400 VESA
        10      521    720x400 16777216     720 x 400 VESA
        10      522    720x480       16     720 x 480 VESA
        10      523    720x480      256     720 x 480 VESA
        10      524    720x480    32768     720 x 480 VESA
        10      525    720x480    65536     720 x 480 VESA
        10      526    720x480 16777216     720 x 480 VESA
        10      527    768x480       16     768 x 480 VESA
        10      528    768x480      256     768 x 480 VESA
        10      529    768x480    32768     768 x 480 VESA
        10      530    768x480    65536     768 x 480 VESA
        10      531    768x480 16777216     768 x 480 VESA
        10      532    800x500       16     800 x 500 VESA
        10      533    800x500      256     800 x 500 VESA
        10      534    800x500    32768     800 x 500 VESA
        10      535    800x500    65536     800 x 500 VESA
        10      536    800x500 16777216     800 x 500 VESA
        10      537    864x486       16     864 x 486 VESA
        10      538    864x486      256     864 x 486 VESA
        10      539    864x486    32768     864 x 486 VESA
        10      540    864x486    65536     864 x 486 VESA
        10      541    864x486 16777216     864 x 486 VESA
        10      542    928x580       16     928 x 580 VESA
        10      543    928x580      256     928 x 580 VESA
        10      544    928x580    32768     928 x 580 VESA
        10      545    928x580    65536     928 x 580 VESA
        10      546    928x580 16777216     928 x 580 VESA
        10      547    960x600       16     960 x 600 VESA
        10      548    960x600      256     960 x 600 VESA
        10      549    960x600    32768     960 x 600 VESA
        10      550    960x600    65536     960 x 600 VESA
        10      551    960x600 16777216     960 x 600 VESA
        10      552   1024x576       16    1024 x 576 VESA
        10      553   1024x576      256    1024 x 576 VESA
        10      554   1024x576    32768    1024 x 576 VESA
        10      555   1024x576    65536    1024 x 576 VESA
        10      556   1024x576 16777216    1024 x 576 VESA
        10      557   1152x720       16    1152 x 720 VESA
        10      558   1152x720      256    1152 x 720 VESA
        10      559   1152x720    32768    1152 x 720 VESA
        10      560   1152x720    65536    1152 x 720 VESA
        10      561   1152x720 16777216    1152 x 720 VESA
        10      562   1152x864       16    1152 x 864 VESA
        10      563   1152x864      256    1152 x 864 VESA
        10      564   1152x864    32768    1152 x 864 VESA
        10      565   1152x864    65536    1152 x 864 VESA
        10      566   1152x864 16777216    1152 x 864 VESA
        10      567   1280x720       16    1280 x 720 VESA
        10      568   1280x720      256    1280 x 720 VESA
        10      569   1280x720    32768    1280 x 720 VESA
        10      570   1280x720    65536    1280 x 720 VESA
        10      571   1280x720 16777216    1280 x 720 VESA
        10      572   1280x800       16    1280 x 800 VESA
        10      573   1280x800      256    1280 x 800 VESA
        10      574   1280x800    32768    1280 x 800 VESA
        10      575   1280x800    65536    1280 x 800 VESA
        10      576   1280x800 16777216    1280 x 800 VESA
        10      577   1368x768       16    1368 x 768 VESA
        10      578   1368x768      256    1368 x 768 VESA
        10      579   1368x768    32768    1368 x 768 VESA
        10      580   1368x768    65536    1368 x 768 VESA
        10      581   1368x768 16777216    1368 x 768 VESA
        10      582   1440x900       16    1440 x 900 VESA
        10      583   1440x900      256    1440 x 900 VESA
        10      584   1440x900    32768    1440 x 900 VESA
        10      585   1440x900    65536    1440 x 900 VESA
        10      586   1440x900 16777216    1440 x 900 VESA
        10      587   1600x900       16    1600 x 900 VESA
        10      588   1600x900      256    1600 x 900 VESA
        10      589   1600x900    32768    1600 x 900 VESA
        10      590   1600x900    65536    1600 x 900 VESA
        10      591   1600x900 16777216    1600 x 900 VESA
```

The program comes from an [article](http://www.freepascal.ru/article/freepascal/20120215095658/) of freepascal.ru, which is why its headings are in Russian: driver number, mode number, resolution, colors.
