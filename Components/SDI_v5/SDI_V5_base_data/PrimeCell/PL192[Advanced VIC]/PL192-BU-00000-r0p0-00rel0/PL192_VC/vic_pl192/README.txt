#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-------------------------------------------------------------------------------
#- 
#- Version and Release Control Information:
#- 
#- File Name              : README.txt.rca
#- File Revision          : 1.12
#- 
#- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
#- 
#-------------------------------------------------------------------------------
#- Purpose : 
#-           VIC PL192 module top level README file 
#-
#- --=========================================================================--
 

Introduction
============

This file describes the directory structure
for the AMBA VIC peripheral.

The world is currently organised with a single AMBA peripheral
block with an AMBA bus compliance test bench that can generate
BusTalk or TicTalk vectors and a minimal EASY world to run
Tic vectors.

This allows functional verification (.bif) or integration testing
(.tif) using a free running clock.

There is no CPU model in the BusTalk world, instead test vectors
are applied as AMBA bus transfers, resulting in higher simulation
throughput.

RTL models are written in both VHDL and Verilog.

#-------------------------------------------------------------------------------

Setup
=====
  This section describes how to setup your environment to build the PL192 world.

EDA tool version
================
The versions of the tools which were used can be found in the Release Note.

Technology library
==================
The technology library targeted can be found in the Release Note.

Tool setup
==========
Before the PrimeCell can be built the EDA tools as specified in the
Release Note should be sourced. Additionally paths to utilities like
'make', 'gcc', 'nawk' will have to be set.

ENVIRONMENT VARIABLES
=====================

The Vic world setup is controlled by a set of environment variables.
These have to be set manually at the command line or via 
the user's setup file [e.g.: .cshrc]. 

  GLOBAL
  ------
  The path to the shared files is defined by the 'GLOBAL' variable.
  e.g.: setenv GLOBAL /h/arm/global

  PERIPH
  ------
  The peripheral name is defined by the 'PERIPH' variable.
  e.g. : setenv PERIPH Vic
  
  SIMULATOR
  ---------
  The simulator type is defined by the 'SIMULATOR' variable.
  It can take the following two values 
     - modelsim - for ModelSim simulations 
     - LDV      - for LDV simulations
  
  e.g.: setenv SIMULATOR modelsim
        setenv SIMULATOR LDV
  
  TEST_METH
  ---------
  The scan methodology adopted during synthesis is defined by
  the 'TEST_METH' variable.
  It can take the following three values
     - noscan     - creates a netlist without scan structures 
     - scaninsert - creates a fully routed scan netlist.
     - scanready  - creates a netlist without a fully routed scan but with
                    scan F/Fs.

  e.g.: setenv TEST_METH noscan
        setenv TEST_METH scaninsert
        setenv TEST_METH scanready
  
  HDL_SOURCE
  ----------
  The source code type is defined by the 'HDL_SOURCE' variable.
  It can take the following two values
      - vhdl      [VHDL RTL]
      - verilog   [Verilog RTL]
  
  e.g.: setenv HDL_SOURCE vhdl
        setenv HDL_SOURCE verilog
  
  HDL_NETL
  --------
  The netlist type is defined by the 'HDL_NETL' variable.
  It can take the following two values
      - vhdl      [VHDL netlist]
      - verilog   [Verilog netlist]
  
  e.g.: setenv HDL_NETL vhdl
        setenv HDL_NETL verilog

  TEST_ENV
  --------
  The test environment is defined by the 'TEST_ENV' variable.
  It can take the following two values
      - BUSTALK   [For functional vector simulations]
      - TICTALK   [For integration vector simulations]
  
  e.g. : setenv TEST_ENV BUSTALK
         setenv TEST_ENV TICTALK
  
  LIB_VHDL
  --------
  This location of the vhdl cell library views is defined by the 
  'LIB_VHDL' variable.
  
  e.g. : setenv LIB_VHDL /AVANT/cb18/v1.0/vital/cb18os120/zero
  
  DIRS_VERILOG
  ------------
  This location of the verilog cell library views is defined by the 
  'DIRS_VERILOG' variable.
  e.g. : setenv DIRS_VERILOG /h/arm/global/AVANT/cb18/v1.0/verilog/cb18os120/zero 
  
  FILES_VERILOG
  -------------
  This location of the verilog UDP file is defined by the 
  'FILES_VERILOG' variable.
  
  e.g. : setenv FILES_VERILOG 
         /h/arm/global/AVANT/cb18/v1.0/verilog/cb18os120/zero/mtb_verilog.v 
  
  LIB_SYNOP
  ---------
  This location of the synopsys .db files is defined by the 
  'LIB_SYNOP' variable.
  setenv LIB_SYNOP 
   /h/arm/global/AVANT/cb18/v1.0/synopsys/cb18os120/1999.05/models 
 
  AMBA
  ----
  This environment variable indicates the AMBA bus to which the
  peripheral interfaces - AHB, ASB or APB. Since the VIC PL192 is an
  AHB peripheral, set this environment variable to 'AHB'. This
  environment variable is used by makefiles in the VIC database to select
  settings for the Integration world.
  
  e.g. :
  setenv AMBA AHB

#-------------------------------------------------------------------------------

Building the code
=================

  This section describes how to selectively build the PL192 world.
  The user should refer to the User Guide (PL192_USGD_0000_A.pdf)
  before attempting to run any code. 
   

Building the 'vhdl' world 
=========================
From within the vic_pl192 directory,

setenv GLOBAL /h/arm/global
setenv PERIPH Vic
setenv SIMULATOR modelsim
setenv HDL_SOURCE vhdl
setenv HDL_NETL vhdl
setenv TEST_METH scaninsert
setenv AMBA AHB

set all other environment variables appropriately and source 
the ADS and simulator tools then:

cd verification/bustest
make RegisterTests        -- any test name can go in place of RegisterTests
                          -- note issues in the User Guide with regards to 
                          -- the Vic1, Vic2, Vic3 and all options. 

cd ../..
make rtl

This will compile the RTL code and run the bustest specified on the 
simulator specified. 


Building the 'verilog' world 
============================
From within the vic_pl192 directory,

setenv GLOBAL /h/arm/global
setenv PERIPH Vic
setenv SIMULATOR modelsim
setenv TEST_METH scanready
setenv HDL_SOURCE verilog
setenv HDL_NETL verilog
setenv AMBA AHB

set all other environment variables appropriately and source 
the ADS and simulator tools then:

cd verification/bustest
make RegisterTests        -- any test name can go in place of RegisterTests
                          -- note issues in the User Guide with regards to 
                          -- the Vic1, Vic2, Vic3 and all options. 


cd ../..
make rtl

This will compile the RTL code and run the bustest specified on the 
simulator specified. 

Building the 'verification' world 
=================================
Please refer to the following makefiles and README files for the various options
available.

   verification/bustest/makefile 
   verification/vhdl/makefile 
   verification/verilog/makefile 

Building the 'integration' world 
=================================
Please refer to the following makefiles and README files for the various options
available.

   integration/bustest/makefile 
   integration/vhdl/makefile 
   integration/verilog/makefile 

#-------------------------------------------------------------------------------

Brief Descriptions on Test Cases
================================

This section provides a brief description of the verification testcases.

================================================================================
=== General Test Cases
================================================================================
ResetTests.c        -- Test Case to check for Reset Values
RegisterTests.c     -- In this test register read/write functionality is
                    -- verified
ErrorRespTests.c    -- In this test Error responses from vic is verified.
ProtectionTests.c   -- In this test the protected mode functionality of the
                    -- VIC is verified
ProtModeIntTests.c  -- In this test the protection mode of the VIC address
                    -- register is verified.
TransferTests.c     -- In this test, busy, idle & burst transfers are
                    -- verified
================================================================================
=== Non VIC Port Tests
================================================================================
The test cases described below are used to test the non vic port functionality
of VIC. In non vic port tests, a read of the VIC vector address register is
performed. These tests are performed applying one, two, four, eight, sixteen
and thirty-two interrupts(hardware & software) with or without Daisy Chain
interrupts. The stack 16 test case tests the functionality of the nested
interrupts.

===========
Test cases
===========
AllIntTest.c
EightAllIntTests.c
TwoFourIntTests.c
UserOneIntTests0.c
UserOneIntTests1.c
UserOneIntTests2.c
UserOneIntTests3.c
UserOneIntTests4.c
UserOneIntTests5.c
UserOneIntTests6.c
UserOneIntTests7.c
Stack16Test.c
PriConsistency.c
RandomTest.c

================================================================================
=== VIC Port Tests
================================================================================
In vic port test case, the vic port functionality is tested (i.e. handshake
mechanism). VICIRQACK signal is generated from the test bench.
These tests are performed applying one, two, four, eight, sixteen
and thirty-two interrupts(hardware & software) with or without Daisy Chain
interrupts. The VIC enabled stack 16 test case, tests the functionality of
the nested interrupts.
The VicEnDaisyPriTest tests the daisy interrupt programmed for highest priority.
The VicSyncEnTest test and ClockOffTest test, tests the asynchronous
functionality of vic.

===========
Test cases
===========
VicEnAllIntTest.c
VicEnEightAllIntTests.c
VicEnTwoFourIntTests.c
VicEnUserOneIntTests0.c
VicEnUserOneIntTests1.c
VicEnUserOneIntTests2.c
VicEnUserOneIntTests3.c
VicEnUserOneIntTests4.c
VicEnUserOneIntTests5.c
VicEnUserOneIntTests6.c
VicEnUserOneIntTests7.c
VicEnStack16Test.c
VicEnDaisyPriTest.c
VicSyncEnTest.c
ClockOffTest.c
RandomTest.c

Note that in bustest, if the option Vic1 is used then, below said tests are
compiled,

ResetTests.c
RegisterTests.c
ErrorRespTests.c
ProtectionTests.c
ProtModeIntTests.c
TransferTests.c

If the option Vic2 is used for the make option then following test cases are
compiled,

AllIntTest.c
EightAllIntTests.c
TwoFourIntTests.c
UserOneIntTests0.c
UserOneIntTests1.c
UserOneIntTests2.c
UserOneIntTests3.c
UserOneIntTests4.c
UserOneIntTests5.c
UserOneIntTests6.c
UserOneIntTests7.c
Stack16Test.c
RandomTest.c
PriConsistency.c
ClockOffTest.c

If the option Vic3 is used for the make option then following test cases are
compiled,

VicEnAllIntTest.c
VicEnEightAllIntTests.c
VicEnTwoFourIntTests.c
VicEnUserOneIntTests0.c
VicEnUserOneIntTests1.c
VicEnUserOneIntTests2.c
VicEnUserOneIntTests3.c
VicEnUserOneIntTests4.c
VicEnUserOneIntTests5.c
VicEnUserOneIntTests6.c
VicEnUserOneIntTests7.c
VicEnStack16Test.c
VicEnDaisyPriTest.c
VicSyncEnTest.c

#-------------------------------------------------------------------------------

Directory Structure
-------------------

The directory structure for the VIC peripheral block is shown below.

vic_pl192
  |
  |---docs
  |     |
  |     |---(documentation directories for the peripheral block)
  |     
  |---vhdl
  |     |
  |     |---(VHDL source directories)
  |     
  |---verilog
  |     |
  |     |---(Verilog source directories)
  |     
  |---synopsys
  |     |
  |     |---(Synopsys synthesis directories)
  |     
  |---verification
  |     |
  |     |---(Functional Verification BusTalk directories)
  |     
  |---integration
        |
        |---(Integration vector TicTalk directories)
        

  VHDL sub-directory
  ------------------

  |---vhdl
        |
        |---rtl_source
        |     |
        |     |---(Unit Under Test, peripheral block RTL source files)
        |     
        |---netlist
              |
              |---(Unit Under Test, peripheral block netlist)


  Verilog sub-directory
  --------------------        
             
  |---verilog
        |
        |---rtl_source
        |     |
        |     |---(Unit Under Test, peripheral block RTL source files)
        |     
        |---netlist
              |
              |---(Unit Under Test, peripheral block netlist)
             

  Synopsys sub-directory
  ----------------------

  |---synopsys
        |
        |      
        |---work
        |     |
        |     |---(intermediate analysed files)
        |     
        |---db
        |     |
        |     |---(synopsys .db format files from synthesis runs)
        |     
        |---log
        |     |
        |     |---(synopsys runtime logs)
        |      
        |---report
        |     |
        |     |---(reports from synthesis runs)
        |      
        |      
        |---scripts
              |
              |---(synopsys scripts unique to the peripheral block)


  Verification sub-directory
  --------------------------

  |---verification
        |
        |---bustest
        |     |       
        |     |
        |     |
        |     |
        |     |---(Vic test vector files)
        |     |             
        |     |---invec     
        |           |
        |           |--- (.bif, .sim files)
        |--vhdl
        |   |
        |   |---uut
        |   |
        |   |---bid
        |   |
        |   |---buswatcher
        |   |
        |   |---common
        |   |
        |   |---reader
        |   |
        |   |---vr
        |   |
        |   |---trickbox
        |   |
        |   |---tbench
        |   |
        |   |---Vic_rtl
        |   | 
        |   |---Vic_scaninsert_vhdl_net_max
        |     
        --verilog
            |
            |---uut
            |
            |---bid
            |
            |---buswatcher
            |
            |---reader
            |
            |---vr
            |
            |---trickbox
            |
            |---tbench
            |
            |---Vic_rtl
            |
            |---Vic_noscan_vhdl_net_min
            |
            |---Vic_scanready_verilog_net_typ


  Integration sub-directory
  -------------------------

  |---integration
        |
        |---bustest
        |     |       
        |     |---(Vic integration test vector files)
        |     |       
        |     |---invec
        |           |
        |           |--- (.tif, .sim)
        |---vhdl
        |     |
        |     |---uut
        |     |
        |     |---ticbox
        |     |
        |     |---trickbox
        |     |
        |     |---chip
        |     |
        |     |---common
        |     |
        |     |---sys
        |     |
        |     |---tbench
        |     |
        |     |---Vic_rtl
        |     |
        |     |---Vic_scaninsert_vhdl_net_max 
        |
        |---verilog
              |
              |---uut
              |
              |---ticbox
              |
              |---trickbox
              |
              |---chip
              |
              |---sys
              |
              |---tbench
              |
              |---Vic_rtl
              |
              |---Vic_noscan_vhdl_net_min
              |
              |---Vic_scanready_verilog_net_typ

================================================================================
INFORMATION FOR EXTERNAL USE BY SYSTEM INTEGRATOR/USER
================================================================================
 
Synthesis
=========
Synthesis has been performed using Synopsys 2001.08.
 
===============================================================================
NOTE :
======
1. If daisy chaining the VICs, VIC0 blocking mode configuration (without the
   VICIRQACKOUT connection) is highly recommended.

2. If the daisy chained VICs have to be used in a Daisy Chain blocking mode
   (with the VICIRQACKOUT connected) then DC-Ultra optimization will be
   require for synthesis. This is particularly the case when in 166Mhz
   operation and using a flow 0.18um process.
===============================================================================

Simulation
==========
Simulation has been performed using
Model Technology Inc V-System v5.4a,
VHDL/Verilog event-driven simulator
 
Technology library
==================
Synthesis has been targeted to Avant! CB18 cell library.

================================================================================

NOTE : For a verilog verification running the option "all", the simulator may have
       problems with allocating memory, due to the large size of the stimulus
       reader file. This problem has been observed on both LDV and Modelsim.
       The make options Vic2, Vic3 may create the same problem as
       mentioned above for Modelsim (verilog).

       The Error message displayed for each simulator is as follows:

       Modelsim
       ========
       # Note: Significant memory allocation has occurred in this simulation
       #  - Setting the LockedMemory variable in your .ini file may help
       # performance
       # ****** Memory allocation failure. *****
       # Please check your system for available memory and swap space

       LDV
       ===
       Data structure takes 927447416 bytes of memory
       Error!    No more memory available (allocating 16376
       bytes)                                            [Verilog-NOMEM]
       "../../bustest/invec/bif.sim", 558605:

       TESTS
       =====
       1. VHDL
          ====
          All tests can run in VHDL.

       2. VERILOG
          =======
          Using ModelSim -> All tests can run except "Vic2", "Vic3" & "all".
          Using LDV      -> All tests can run except "all" options.

============================= End of README.txt ================================
