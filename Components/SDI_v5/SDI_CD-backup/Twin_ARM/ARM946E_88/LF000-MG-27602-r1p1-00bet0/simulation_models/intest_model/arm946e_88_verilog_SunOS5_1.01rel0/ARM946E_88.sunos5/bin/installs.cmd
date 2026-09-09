@echo off
if not "%LMC_HOME%" == "" goto continue
  echo %0:  ERROR:  Environment variable LMC_HOME not set.
  goto end
:continue
if "%PROCESSOR_ARCHITECTURE%" == "x86" goto intel
if "%PROCESSOR_ARCHITECTURE%" == "ALPHA" goto alpha
  echo %0:  ERROR:  Architecture %PROCESSOR_ARCHITECTURE% not supported.
goto end
:intel
    %LMC_HOME%\lib\pcnt.lib\installs.exe %*
  goto end
:alpha
    %LMC_HOME%\lib\alphant.lib\installs.exe %*
:end
