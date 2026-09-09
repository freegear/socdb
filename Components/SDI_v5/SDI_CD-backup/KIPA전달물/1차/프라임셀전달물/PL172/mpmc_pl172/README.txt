#- --=========================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2001-2002 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#- -----------------------------------------------------------------------------
#-
#- Version and Release Control Information:
#-
#- File Name              : README.txt.rca
#- File Revision          : 1.7
#-
#- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
#-
#- -----------------------------------------------------------------------------
#- Purpose :
#-           MPMC PL172 module top level README file
#-
#- --=========================================================================--

Introduction
============

This file describes the directory structure for the MPMC peripheral.

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

  This section describes how to setup your environment to build the PL172 world.

EDA tool version
================
The versions of the tools which were used can be found in the Release Note.

Technology library
==================
The technology library targetted can be found in the Release Note.

Tool setup
==========
Before the PrimeCell can be built the EDA tools as specified in the
Release Note should be sourced. Additionally paths to utilities like
'make' , 'gcc', 'nawk' will have to be set.

Environment variables
=====================
The Mpmc world setup is controlled by a set of environment variables.
These have to be set manually at the command line or via
the user's setup file [eg: .cshrc].

  GLOBAL
  ------
  The path to the shared files are defined by the 'GLOBAL' variable.
  eg : setenv GLOBAL /h/arm/global

  PERIPH
  ------
  The peripheral name is defined by the 'PERIPH' variable.
  eg : setenv PERIPH Mpmc

  SIMULATOR
  ---------
  The simulator type is defined by the 'SIMULATOR' variable.
  It can take the following two values
     - modelsim - for ModelSim simulations
     - LDV      - for LDV simulations

  eg : setenv SIMULATOR modelsim
       setenv SIMULATOR LDV

  TEST_METH
  ---------
  The scan methodolgoy adopted during synthesis is defined by
  the 'TEST_METH' variable.
  It can take the following three values
     - noscan     - creates a netlist without scan structures.
     - scanready  - creates a netlist with scan F/Fs but without scan routing.
     - scaninsert - creates a fully routed scan netlist.

  eg : setenv TEST_METH noscan
       setenv TEST_METH scanready
       setenv TEST_METH scaninsert

  HDL_SOURCE
  ----------
  The source code type is defined by the 'HDL_SOURCE' variable.
  It can take the following two values
      - vhdl      [VHDL RTL]
      - verilog   [Verilog RTL]

  eg : setenv HDL_SOURCE vhdl
       setenv HDL_SOURCE verilog

  HDL_NETL
  --------
  The netlist type is defined by the 'HDL_NETL' variable.
  It can take the following two values
      - vhdl      [VHDL netlist]
      - verilog   [Verilog netlist]

  eg : setenv HDL_NETL vhdl
       setenv HDL_NETL verilog

  TEST_ENV
  --------
  The test environment is defined by the 'TEST_ENV' variable.
  It can take the following two values
      - BUSTALK   [For functional vector simulations]
      - TICTALK   [For integration vector simulations]

  eg : setenv TEST_ENV BUSTALK
       setenv TEST_ENV TICTALK

  LIB_VHDL
  --------
  The location of the vhdl cell library views is defined by the
  'LIB_VHDL' variable.

  eg : setenv LIB_VHDL /AVANT/cb18/v1.0/vital/cb18os120/zero

  DIRS_VERILOG
  ------------
  The location of the verilog cell library views is defined by the
  'DIRS_VERILOG' variable.
  eg : setenv DIRS_VERILOG /AVANT/cb18/v1.0/verilog/cb18os120/zero

  FILES_VERILOG
  -------------
  The location of the verilog UDP file is defined by the
  'FILES_VERILOG' variable.

  eg : setenv FILES_VERILOG
              /AVANT/cb18/v1.0/verilog/cb18os120/zero/mtb _verilog.v

  LIB_SYNOP
  ---------
  The location of the synopsys .db files is defined by the
  'LIB_SYNOP' variable.

  eg :
  setenv LIB_SYNOP /AVANT/cb18/v1.0/synopsys/cb18os120/1999.05/models

  AMBA
  ----
  This environment variable indicates the AMBA bus to which the
  peripheral interfaces - AHB, ASB or APB. Since the MPMC PL172 is an
  AHB peripheral, set this environment variable to 'AHB'. This
  environment variable is used by makefiles in the MPMC database to select
  settings for the Integration world.

  eg :
  setenv AMBA AHB

#-------------------------------------------------------------------------------


Building the code
=================

  This section describes how to selectively build the PL172 world.

Building the 'vhdl' world
=========================
From within the mpmc_pl172 directory,

setenv GLOBAL <REQUIRED_DIRECTORY>/global
setenv PERIPH Mpmc
setenv SIMULATOR modelsim
setenv TEST_METH scaninsert
setenv HDL_SOURCE vhdl
setenv HDL_NETL vhdl

set all other environment variables appropriately and ..

make all <CR>

Building the 'verilog' world
============================
From within the mpmc_pl172 directory,

setenv GLOBAL <REQUIRED_DIRECTORY>/global
setenv PERIPH Mpmc
setenv SIMULATOR modelsim
setenv TEST_METH scanready
setenv HDL_SOURCE verilog
setenv HDL_NETL verilog

set all other environment variables appropriately and ..
make all <CR>

Building the 'verification' world
=================================
Please refer to the following makefiles and README files for the various
options available.

   verification/bustest/makefile
   verification/vhdl/makefile
   verification/verilog/makefile

Building the 'integration' world
================================
Please refer to the following makefiles and README files for the various
options available.

   integration/bustest/makefile
   integration/vhdl/makefile
   integration/verilog/makefile

Denali Memory Model
===================
The .denalirc file in the "verification/denali" directory can be used to
suppress pre-reset errors flagged by denali models. This file can also be
used to enable Denali model history "Denali.his" and Denali model tracing
"Denali.trc".

To enable this please ensure that the DENALIRC environment variable is
pointing to the verification/denali directory.

#-------------------------------------------------------------------------------

Verification Test Cases
========================

  This section provides a brief description of the verification testcases.

POResetTest and HResetTest:
    PowerOnReset and Hreset value of the registers are tested.

MpmcRegisterTests:
    Different values are written and read from the registers to verify
    that the register under test is a read-only/read-write/write-only

MPMCEnableTest:
    This test verifies the functionality of MPMCEnable bit

ControllerBusyTest:
    This test verifies busy bit of MPMCStatus register.

LowPwrModeTest:
    It verifes the functionality of controller when it undergoes low power mode.

AddrToggleTest:
    Toggles all memory related addresses.

AddrMirrTest:
    Checks the Address Mirror bit of MPMCControl register.

CSPolarityTest:
    This test verifies the polarity of ChipSelect when CS bit is toggled

SdramInitRtnChk:
    This test verifies whether proper initialization sequence for sync
    memories are followed or not.

ClkCtrlTest:
    This test tests the clock controllability feature.

ClkEnableTest:
    This test tests the clock enable feature.

ROMTest:
    Verifies functionality of controller with ROM as memory.

DelayValueTests:
    Verifies delay value registers.

StWtPgTest:
    Verifies page mode access of burst ROM.

StWtPgBufEnTest:
    Verifies page mode access of burst ROM with buffers enabled.

BLSDelayValueTests:
    Verifies byte lane select.

ExdWaitDelTest:
    Verifies extended wait register functionality.

EndiannessTests:
    Verifies endianisation logic.

BigEndianPinTest:
    Verifies endianisation logic with bigendian pin.

BusyInsertionTest:
    MPMC is tested when a bus degrant occurs during a busy transfer in a burst
    transfer.

BusDegrantTest:
    MPMC is tested when a bus degrant occurs during a busy transfer in a burst
    transfer.

LowPwrSdramFunTest:
    This test verifies whether proper initialization sequence and functionality
    of LPSDRAM.

RefFreqChk:
    It verifies that the refreshes are seperated by approximately the same
    number of clocks as the value that is written into the refresh register
    of the controller.

SelfRefChk:
    Tests whether acknowledge is given for SRefreshReq. When self refresh
    is applied externally it checks acknowledge is given or not.

SelRefPriorityTest:
    This test verifies  that when REFRESH and SREFREQ are applied same
    time then REFRESH is applied first and then SREFREQ applied.

WrProtTest:
    This test verifies the Write Protect(WP) bit of MpmcDyConfig and
    MpmcStConfig register.

RdRefAlnTest:
   This test verifies that refresh has highest priority over memory access
   when they are applied simultaneously.

SyncFlashTest:
   Tests the sync flash related accesses.

HburstTest:
   Memory accesses are done with different types of BURST operation to static
   memory.

DyHburstTest1:
   Memory accesses are done with different types of BURST operation to dynamic
   memory.

DyHburstTest2:
   Memory accesses are done with different types of BURST operation to dynamic
   memory with clock ratio 1:2.

DyHburstTestTB5:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench5.

DyHburstTestTB7:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench7.

DyHburstTestTB8:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench8.

DyHburstTestTB9:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench9.

DyHburstTestTB10:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench10.

DyHburstClkRatTB7Test:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench7 with clock ratio as 1:2.

DyHburstClkRatTB8Test:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench8 with clock ratio as 1:2.

DyHburstClkRatTB9Test:
   Memory accesses are done with different types of BURST operation with tbench
   as tbench9 with clock ratio as 1:2.

BigEndHburstTest:
   Memory accesses are done with BigEndian

RandHburstTest:
   Memory accesses are done with different types of BURST operation to static
   memory randomly.

RandHburstTest1:
   Memory accesses are done with different types of BURST operation to dynamic
   memory randomly.

RandHburstTest2:
   Memory accesses are done with different types of BURST operation to dynamic
   memory randomly with clk ratio as 1:2.

TransferTest:
   Different types of HTRANS are applied at quad word boundary and verify the
   functionality.

CornerCases1:
   Tests the controller with small values of delay values for static memory
   accesses.

CornerCases2:
   Performs the memory access to 512M dynamic memory and accesses the upper
   row addresses.

CornerCases3:
   It performs different types of HTRANS operations at or near the quad word
   boundary.

Arb2StWrRd:
   Tests the arbiter when there is access to static memory from port3 and
   port2.

Arb2DyWrRd:
   Tests the arbiter when there is access to dynamic memory from port3 and
   port1.

RandomTest1:
   Random Test.

Arb4IdleBusy:
   Tests the controller with different types of HTRANS accesses from all ports.

Arb4DyWrRdClkRat:
   Tests the arbiter when there is access to dynamic memory from all ports with
   clock ratio 1:2.

Arb3DyStWrRd:
   Tests the arbiter when there is access to dynamic as well as static memory
   from from port3, port2 and port0.

Arb3StWrRd:
   Simultaneous write/read to static memory from port3, port2 and port1 to
   check arbiter.

Arb3DyWrRd:
   Simultaneous write/read to dynamic memory from port3, port2 and port1 to
   check arbiter.

Arb4DyWrRd:
   Multiple Port access to dynmic memory from all ports.

Arb4StWrRd:
   Simultaneous memory access from all ports to static memory.

MemModelHburstTest:
   Memory accesses for static denali memory models.

Arb4DyStWrRd:
   Simultaneous memory access from all ports to static and dynamic memory.

Arb2DyStWrRd:
   Simultaneous memory access from port3 and from port2 to static and dynamic
   memory.

Arb2CornerCase4:
   Simultaneous memory access from port3 and from port2 to sync flash and
   SRAM  memory.

MemModelPgROMTest:
   Memory page mode read operation from the denali memory models.

MemModelROMTest:
   Memory read operation from the denali memory models.

MemModelStPgModeTest:
   Memory write to the intel page mode flash memory with buffers disabled and 
   read from the memory both buffers disabled and enabled mode.

DyHburstCmdDelTest1:
   Memory accesses to the dynamic memory are done with different types of BURST 
   operation with command delayed approach.

SyncFlashCmdDelTest:
   Memory accesses and various command testing on the sync flash memory with
   command delayed approach

Rel1HburstTest:
   Memory accesses to the static memory are done with different types of BURST
   operation with LSBs of MPMCADDR are dropped for 16 and 32 bit memory.

IntegrationTest:
   Test which toggles all AHB and memory related signals which helps after 
   integrating the primecell in the system.

Arb2HMastLockTest:
   Tests which checks when HMASTLOCK of a port is high, other ports are not
   suppossed to do the access to the memory.
     
LatencyTest1 to LatencyTest10, MultiPortPgAccessTest to MultiPortPgAccessTest5,
MultiPortDiffComb1 to MultiPortDiffComb8:
   These tests perform accesses through different AHB ports and test whether
   the AHB priority scheme is properly followed, as far as returning data to
   HRDATA bus is concerned.

RefreshMissTest:
   This test performs a large set of static memory accesses. It is tested that
   refreshes are not missed even during the static memory accesses.

DirecDyDtFtchTest:
   This function tests the data integrity in certain cases, where the MPMC
   directly passess the dynamic-memory data to the AHB, instead of routing it
   through buffer.

MemBGntTest:
   This function tests the controller in a particular cornercase, where the
   autorefresh is applied at the point of last static access.

MultiPortWrProtTest:
   This test Checks write protect feature with multiport accesses.

#-------------------------------------------------------------------------------


Directory Structure
-------------------

The directory structure for the MPMC peripheral block is shown below.

mpmc_pl172
  |
  |---bin
  |     |
  |     |---(local simulation run scripts directory for the peripheral
block)
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
  |     |
  |     |---(Integration vector TicTalk directories)
  |


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

  Verlog sub-directory
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
        |     |---(Mpmc test vector files)
        |     |
        |     |---invec
        |           |
        |           |--- (.bif, .sim files)
        |--vhdl
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
        |   |---Mpmc_rtl
        |   |
        |   |---Mpmc_scaninsert_vhdl_net_max
        |
        --verilog
            |
            |---bid
            |
            |---buswatcher
            |
            |---common
            |
            |---reader
            |
            |---vr
            |
            |---trickbox
            |
            |---tbench
            |
            |---Mpmc_rtl
            |
            |---Mpmc_noscan_vhdl_net_min
            |
            |---Mpmc_scanready_verilog_net_typ


  Integration sub-directory
  -------------------------

  |---integration
        |
        |---bustest
        |     |
        |     |---(Mpmc integration test vector files)
        |     |
        |     |---invec
        |           |
        |           |--- (.tif, .sim)
        |---vhdl
        |     |
        |     |---chip
        |     |
        |     |---common
        |     |
        |     |---sys
        |     |
        |     |---tbench
        |     |
        |     |---Mpmc_rtl
        |     |
        |     |---Mpmc_scaninsert_vhdl_net_max
        |
        |
        |---verilog
              |
              |---chip
              |
              |---sys
              |
              |---tbench
              |
              |---Mpmc_rtl
              |
              |---Mpmc_noscan_vhdl_net_min
              |
              |---Mpmc_scanready_verilog_net_typ


============================= End of README.txt ================================
