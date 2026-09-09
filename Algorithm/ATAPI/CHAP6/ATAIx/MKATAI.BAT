@ECHO OFF
IF "%1"=="1" GOTO ATA1
IF "%1"=="2" GOTO ATA2
IF "%1"=="1I" GOTO ATA1I
IF "%1"=="2I" GOTO ATA2I
ECHO IDEポートを指定してください。
ECHO   MKATAI 1[リターン] .... プライマリ用(割り込み未使用版)
ECHO   MKATAI 2[リターン] .... セカンダリ用(割り込み未使用版)
ECHO   MKATAI 1I[リターン] ... プライマリ用(割り込み使用版)
ECHO   MKATAI 2I[リターン] ... セカンダリ用(割り込み使用版)
GOTO QUIT

:ATA1
REM プライマリ用(割り込み未使用版)
LCC -m -DIDE1 -o ATAI1.EXE AT_IO.C IDE_BIOS.C IDEPRINT.C ATAIx.C
GOTO DELL

:ATA2
REM セカンダリ用(割り込み未使用版)
LCC -m -DIDE2 -o ATAI2.EXE AT_IO.C IDE_BIOS.C IDEPRINT.C ATAIx.C
GOTO DELL

:ATA1I
REM プライマリ用(割り込み使用版)
LCC -m -DIDE1 -DUSE_INTERRUPT -o ATAI1i.EXE -lIRQFUNC.OBJ AT_IO.C IDE_BIOS.C IDEPRINT.C ATAIx.C
GOTO DELL

:ATA2I
REM プライマリ用(割り込み使用版)
LCC -m -DIDE2 -DUSE_INTERRUPT -o ATAI2i.EXE -lIRQFUNC.OBJ AT_IO.C IDE_BIOS.C IDEPRINT.C ATAIx.C

:DELL
del *.map

:QUIT
