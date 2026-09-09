#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#- -----------------------------------------------------------------------------
#- 
#- Version and Release Control Information:
#- 
#- File Name              : README.txt,v
#- File Revision          : 1.1
#- 
#- Release Information    : ADK_REL1v1
#- 
#- -----------------------------------------------------------------------------
#- Purpose : 
#-           ADK top level README file 
#-
#- --=========================================================================--

Introduction
------------

This file describes the directory structure for the AMBA Design Kit
(ADK) from ARM.

The structure is organised as a series of standalone ADK components
similar to the PrimeCell Peripherals supplied by ARM.  Models are
written in both VHDL and Verilog, with scripts provided for both
simulation and synthesis.

For a complete description of the makefile structure used, plus
instructions for integrating new components into ADK, please refer to
the User Guide.

 
Technology library
------------------
Synthesis has been targetted to Avant! CB18 cell library.


Important :
-----------

Paths to utilities like 'make' , 'perl', 'awk' will have to be
explicitly set via the user's startup files (eg. .cshrc).

These need to be resolved before the world can be successfully built.


ENVIRONMENT VARIABLES
---------------------

This product's setup is controlled by a set of environment variables.

Default values are given in the "sourceMe" file contained in this
directory.  To use it type the following from the command line:

  source sourceMe

Please refer to the contents of this file for a brief description of
each variable and its usage.


Quick Start
===========

NOTE 1: The following instructions assume that the relevant tools
        (vsim, ncverilog, etc.) are already available for use in the
        UNIX shell from which the make commands are run.

NOTE 2: The following examples assume the use of the "make" command
        (tested using Solaris 2.8).  The makefiles are designed to
        also work with "gnumake", if preferred.


1. Set up environment variables:

  cd /path_to_install/ARM_ADK_BET1/design
  source sourceMe

The default setup for ADK is: VHDL source files, ModelSim simulator,
Verilog target netlist, scan insertion test methodology.  To alter
these parameters, edit the "sourceMe" file and re-issue the "source
sourceMe" command.  The "sourceMe" file also sets up which EASY system
is to be used (default: "EASY_FRBM"), as well as a number of
cell-library related parameters.

Also set up will be the $ADK environment variable, which points to the
ADK installation directory.  This will be used to abbreviate the
following instructions.


2. Run the integration test on the HDL source:

  cd $ADK/design/tbench/integration
  make rtl

This will compile the test source file located in:

  $ADK/design/tbench/frbmtests/IntegrationTest.fri

and run it on EASY_FRBM using the TBEasy_FRBM testbench.  The run
directory (for the default setup) will be:

  $ADK/design/tbench/integration/vhdl/TBEasy_FRBM_rtl

The test is self-checking, and will report error messages in the
transcript file "IntegrationTest_vhdl_transcript", available in the
run directory.


3. Synthesise all synthesisable components in EASY_FRBM:

NOTE: Before synthesis, the supplied cell-library files must be
unpacked.  See Appendix A for instructions.

  cd $ADK/design/EASY_FRBM/synopsys
  make netlist

The only non-synthesisable components within EASY_FRBM are "IntMem"
(behavioural internal memory model) and "FileReader" (the File Reader
Bus Master - in fact, the only non-synthesisable part of this is the
file-reader core itself).  All other components are synthesised using
a bottom-up methodology: i.e. each sub-component is synthesised
separately, and the resulting Synopsys database (.db) files are used
when synthesising the mainly structural top-level.  Note: this entire
process will take some time, probably several hours, depending upon
the available computing power.

A synthesis log, plus a number of report files, are generated for each
component.  The primary files (e.g. for the Watchdog) are:

  $ADK/design/Watchdog/synopsys/log/Watchdog_scaninsert_vhdl_verilog_run.log

Primary log file of the synthesis run.  This will contain a number of
"Warning:" statements due to the nature of the Synopsys tools, but any
"Error:" statements should be closely investigated

  $ADK/design/Watchdog/synopsys/report/Watchdog_scaninsert_vhdl_verilog.min
  $ADK/design/Watchdog/synopsys/report/Watchdog_scaninsert_vhdl_verilog.max

Timing reports of the design, for MIN (best-case) and MAX (worst-case)
timings.  Any paths which fail to meet the applied timing constraints
will be indicated by the text "VIOLATED" and should be investigated.


4. Run the integration test on the synthesised netlist with SDF
   back-annotation:

NOTE: Before running netlist simulations, the cell-library simulation
models must be compiled, if using the modelsim simulator.  See
Appendix A for instructions.

  cd $ADK/design/tbench/integration
  make net_max
  make net_typ
  make net_min

This will run the integration test on the synthesised netlist using
MIN (best-case) timings, TYP (typical) timings and then MAX
(worst-case) timings from the SDF file.  Note: as supplied, the
Synopsys synthesis scripts place only MIN and MAX timings into the SDF
file; running the TYP integration test will simply repeat the effects
of the MAX test, but in a different run directory.

The run directories will be (respectively):

  $ADK/design/tbench/integration/verilog/TBEasy_FRBM_scaninsert_vhdl_net_max
  $ADK/design/tbench/integration/verilog/TBEasy_FRBM_scaninsert_vhdl_net_typ
  $ADK/design/tbench/integration/verilog/TBEasy_FRBM_scaninsert_vhdl_net_min

Sub-directory "verilog" (in the "integration" directory) indicates the
HDL type of the files being simulated - verilog in this case as that
is the HDL type of the netlists.  The "vhdl" in the run directory name
indicates the HDL type of the source files used during synthesis.


============================= End of README.txt ================================
