@echo off
rem *******************************************************************
rem Copyright (c) 1999-2004  Evatronix SA
rem *******************************************************************
rem Please review the terms of the license agreement before using
rem this file. If you are not an authorized user, please destroy this
rem source code file and notify Evatronix SA immediately that you
rem inadvertently received an unauthorized copy.
rem *******************************************************************

rem -------------------------------------------------------------------
rem Project name         : MAC-1G AMBA
rem Project description  : Ethernet Media Access Controller
rem
rem File name            : 16bit_tests.bat
rem File contents        : Sample batch for MTI ModelSim EE
rem Purpose              : Supports tests series for 32 bit validation
rem Design Engineer      : L.C.
rem Quality Engineer     : M.B.
rem Version              : 2.02
rem Last modification    : 2004-08-16
rem -------------------------------------------------------------------

rem -------------------------------------------------------------------
rem Simulator directory location
rem -------------------------------------------------------------------

set vsim_dir=c:\Modeltech_ae\win32aloem

rem -------------------------------------------------------------------
rem work directory location
rem -------------------------------------------------------------------

set work_dir=..\..\..\
cd %work_dir%


rem -------------------------------------------------------------------
rem Deafault directories location
rem -------------------------------------------------------------------


set scr_file=tools/mti/ee_scripts/16bit_tests.tcl
set log_file=tools/mti/ee_reports/16bit_tests.log


%vsim_dir%\vsim.exe -c -l %log_file% -do %scr_file%