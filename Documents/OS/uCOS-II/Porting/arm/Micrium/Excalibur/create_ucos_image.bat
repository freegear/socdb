@echo off

set CURRDIR=.

set UCOSROOT=%CURRDIR%\..\uCOS-II
set UCOSSRC=%UCOSROOT%\Source
set UCOSPORT=%UCOSROOT%\Ports\ARM\Generic\rvct221
set UCOSEXC=%CURRDIR%

set ODIR=objs

set ARMHOME=C:\Progra~1\ARM
set RVCTVER=2.2\503
set RVCTHOME=%ARMHOME%\RVCT
set RVCTDATA=%RVCTHOME%\Data\%RVCTVER%
set RVCT22BIN=%RVCTHOME%\Programs\%RVCTVER%\win_32-pentium
set RVCT22INC=%RVCTDATA%\include\windows
set RVCT22LIB=%RVCTDATA%\lib

set PATH=%RVCT22BIN%;%PATH%

set ARMCC=armcc
set ARMASM=armasm
set ARMLINK=armlink

set IFLAGS=-I%UCOSSRC% -I%UCOSPORT% -I%UCOSEXC%
set CMNFLAGS=--cpu ARM922T --apcs /noswstackcheck/interwork --bi --fpu softvfp
set CPPFLAGS=%IFLAGS% %CMNFLAGS% -O0 -g
set ASMFLAGS=%CMNFLAGS% -g --keep
set LINKFLAGS= --entry Reset_Handler --info totals,sizes --xref --symbols --map --list %ODIR%\ucos.lst  --remove --scatter ucos.lcf

set OBJLIST=%ODIR%\exc_init.o %ODIR%\ucos_ii.o %ODIR%\os_cpu_c.o %ODIR%\os_cpu_a.o %ODIR%\os_dbg.o %ODIR%\bsp.o %ODIR%\app.o %ODIR%\ucos_arm_swi.o

set UCOS_AXF=%ODIR%\ucos.axf

echo ==============CHECKING COMPILER ENVIRONMENT=====================================
echo --------------------------------------------------------------------------------
echo ARM ENVIRONMENT VARIABLES ARE:
echo --------------------------------------------------------------------------------
echo ARMCONF=%ARMCONF%
echo ARMDLL=%ARMDLL%
echo RVCT22INC=%RVCT22INC%
echo RVCT22LIB=%RVCT22LIB%
echo PATH=%PATH%
echo --------------------------------------------------------------------------------
echo CHECKING ARM TOOLS VERSION (should be RVCT 2.2 [build 559])
echo --------------------------------------------------------------------------------
%ARMASM%   --vsn
%ARMCC%    --vsn
%ARMLINK%  --vsn
echo =============END OF CHECKING COMPILER ENVIRONMENT===============================

echo =============CREATING EXCALIBUR BOOTIMAGE HEXFILE===============================

@echo on

mkdir %ODIR%

%ARMASM% %ASMFLAGS% -o %ODIR%\exc_init.o        %UCOSEXC%\exc_init.s
%ARMCC%  %CPPFLAGS% -o %ODIR%\bsp.o          -c %UCOSEXC%\bsp.c
%ARMCC%  %CPPFLAGS% -o %ODIR%\app.o          -c %UCOSEXC%\app.c
%ARMCC%  %CPPFLAGS% -o %ODIR%\ucos_arm_swi.o -c %UCOSEXC%\ucos_arm_swi.c
%ARMASM% %ASMFLAGS% -o %ODIR%\os_cpu_a.o        %UCOSPORT%\os_cpu_a.s
%ARMCC%  %CPPFLAGS% -o %ODIR%\os_cpu_c.o     -c %UCOSPORT%\os_cpu_c.c
%ARMCC%  %CPPFLAGS% -o %ODIR%\os_dbg.o       -c %UCOSPORT%\os_dbg.c
%ARMCC%  %CPPFLAGS% -o %ODIR%\ucos_ii.o      -c %UCOSSRC%\ucos_ii.c

%ARMLINK% -o %UCOS_AXF% %OBJLIST% %LINKFLAGS%

pause
