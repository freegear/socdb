@ECHO OFF
IF "%1"=="4" GOTO SH4
IF "%1"=="3" GOTO SH3
ECHO CPUを指定してください。
ECHO   MKATAR 4[リターン] .... SH-4用(exeGCC/CQ版はビッグエンディアン専用)
ECHO   MKATAR 3[リターン] .... SH-3用(exeGCC/CQ版はビッグエンディアン専用)
GOTO QUIT

:SH4
REM SH4用
gcc -g -DSH4B -DUSE_INTERRUPT -o shatar.out sh4.c isabase.c cpu_int.c sh_io.c ide_bios.c ideprint.c shatar.c
GOTO DELL

:SH3
REM SH3用
gcc -g -DSH3B -DUSE_INTERRUPT -o shatar.out sh3.c isabase.c cpu_int.c sh_io.c ide_bios.c ideprint.c shatar.c

:DELL

:QUIT
