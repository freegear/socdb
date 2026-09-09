@ECHO OFF
IF "%1"=="1" GOTO ATA1
IF "%1"=="2" GOTO ATA2
IF "%1"=="1I" GOTO ATA1I
IF "%1"=="2I" GOTO ATA2I
ECHO IDEポートを指定してください。
ECHO   MKATAW 1[リターン] .... プライマリ用(割り込み未使用版)
ECHO   MKATAW 2[リターン] .... セカンダリ用(割り込み未使用版)
ECHO   MKATAW 1I[リターン] ... プライマリ用(割り込み使用版)
ECHO   MKATAW 2I[リターン] ... セカンダリ用(割り込み使用版)
GOTO QUIT

:ATA1
REM プライマリ用(割り込み未使用版)
LCC -m -DIDE1 -o ATAW1.EXE AT_IO.C IDE_BIOS.C IDEPRINT.C ATAWx.C
GOTO DELL

:ATA2
REM セカンダリ用(割り込み未使用版)
LCC -m -DIDE2 -o ATAW2.EXE AT_IO.C IDE_BIOS.C IDEPRINT.C ATAWx.C
GOTO DELL

:ATA1I
REM プライマリ用(割り込み使用版)
LCC -m -DIDE1 -DUSE_INTERRUPT -o ATAW1i.EXE -lIRQFUNC.OBJ AT_IO.C IDE_BIOS.C IDEPRINT.C ATAWx.C
GOTO DELL

:ATA2I
REM プライマリ用(割り込み使用版)
LCC -m -DIDE2 -DUSE_INTERRUPT -o ATAW2i.EXE -lIRQFUNC.OBJ AT_IO.C IDE_BIOS.C IDEPRINT.C ATAWx.C

:DELL
del *.map

:QUIT
