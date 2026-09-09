-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
-- Version and Release Control Information:
--
-- File Name              : README.txt.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           SMC PL092 module top level README file
--
-- --=========================================================================--

Introduction
------------

This file describes the directory structure for development of the AMBA SMC
peripheral.

The world is currently organised with a single AMBA peripheral block with an
AMBA bus compliance test bench that can generate BusTalk or TicTalk vectors
and a minimal EASY world to run Tic vectors.

This allows functional verification (.bif) or integration testing (.tif) using
a free running clock.

There is no CPU model in the BusTalk world, instead test vectors are applied
as AMBA bus transfers, resulting in higher simulation throughput.

RTL models are written in both VHDL and Verilog.

Technology library
------------------
Synthesis has been targetted to Avant! CB25 cell library.

Important :
-----------
- Paths to utilities like 'make' , 'gcc', 'nawk' will have to
  be explicitly set via the user's startup files (eg. .cshrc).

These need to be resolved before the world can be successfully built.

ENVIRONMENT VARIABLES
---------------------
The Smc world setup is controlled by a set of environment variables.
These have to be set manually at the command line or via the user's setup file
[eg: .cshrc].

GLOBAL
------
The path to the shared files are defined by the 'GLOBAL' variable.
eg : setenv GLOBAL /home/primecell/global

PERIPH
------
The peripheral name is defined by the 'PERIPH' variable.
eg : setenv PERIPH Smc

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
The scan methodolgoy adopted during synthesis is defined by the 'TEST_METH'
variable.
It can take the following three values
   - noscan     - creates a netlist without scan structures
   - scanready  - creates a netlist with scan F/Fs but
                  without scan routing.
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
This location of the vhdl cell library views is defined by the 'LIB_VHDL'
variable.

eg : setenv LIB_VHDL /AVANT/1999.1/cb25/v2.1/vital/cb25os163/zero

DIRS_VERILOG
------------
This location of the verilog cell library views is defined by the
'DIRS_VERILOG' variable.

eg : setenv DIRS_VERILOG /AVANT/1999.1/cb25/v2.1/verilog/cb25os163/zero

FILES_VERILOG
-------------
This location of the verilog UDP file is defined by the
'FILES_VERILOG' variable.

eg : setenv FILES_VERILOG /AVANT/1999.1/cb25/v2.1/verilog/cb25os163/zero/mtb_verilog.v

LIB_SYNOP
---------
This location of the synopsys .db files is defined by the 'LIB_SYNOP'
variable.

setenv LIB_SYNOP /AVANT/1999.1/cb25/v2.1/synopsys/cb25os163/1997.01/models

STEPS TO SELECTIVELY BUILD THE smc_pl092 WORLD
----------------------------------------------

Building the 'vhdl' world
-------------------------
From within the smc_pl092 directory,

setenv GLOBAL /home/primecell/global
setenv PERIPH Smc
setenv SIMULATOR modelsim
setenv TEST_METH scaninsert
setenv HDL_SOURCE vhdl
setenv HDL_NETL vhdl

set all other environment variables appropriately and ..

make all <CR>

Building the 'verilog' world
----------------------------
From within the smc_pl092 directory,

setenv GLOBAL /home/primecell/global
setenv PERIPH Smc
setenv SIMULATOR modelsim
setenv TEST_METH scanready
setenv HDL_SOURCE verilog
setenv HDL_NETL verilog

set all other environment variables appropriately and ..
make all <CR>

Building the 'verification' world
---------------------------------
Please refer to
   verification/bustest/makefile
   verification/vhdl/makefile
   verification/vhdl/denali.mk
   verification/verilog/makefile
   verification/verilog/denali.mk

for the various options available.

For setting up the DENALI Memory Model based simulation world with Modelsim
Verilog and LDV Verilog-XL, please refer to following README file for
details :
   verification/verilog/README_Denali

Building the 'integration' world
--------------------------------
Please refer to
   integration/bustest/makefile
   integration/vhdl/makefile
   integration/verilog/makefile

for the various options available.

Directory Structure
-------------------

The directory structure for the SMC peripheral block is shown below.

smc_pl092
  |
  +---bin
  |     |
  |     +---(local scripts directory for the peripheral block)
  |
  +---docs
  |     |
  |     +---(documentation directories for the peripheral block)
  |
  +---vhdl
  |     |
  |     +---(VHDL source directories)
  |
  +---verilog
  |     |
  |     +---(Verilog source directories)
  |
  +---synopsys
  |     |
  |     +---(Synopsys synthesis directories)
  |
  +---verification
  |     |
  |     +---(Functional Verification BusTalk directories)
  |
  +---integration
        |
        +---(Integration vector TicTalk directories)


  +---vhdl
        |
        +---rtl_source
        |     |
        |     +---(Unit Under Test, peripheral block RTL source files)
        |
        +---netlist
              |
              +---(Unit Under Test, peripheral block netlist)

  +---verilog
        |
        +---rtl_source
        |     |
        |     +---(Unit Under Test, peripheral block RTL source files)
        |
        +---netlist
              |
              +---(Unit Under Test, peripheral block netlist)


  +---synopsys
        |
        |
        +---work
        |     |
        |     +---(intermediate analysed files)
        |
        +---db
        |     |
        |     +---(synopsys .db format files from synthesis runs)
        |
        +---log
        |     |
        |     +---(synopsys runtime logs)
        |
        +---report
        |     |
        |     +---(reports from synthesis runs)
        |
        |
        +---scripts
              |
              +---(synopsys scripts unique to the peripheral block)

  +---verification
        |
        +---bustest
        |     |
        |     |
        |     |
        |     |
        |     +---(Smc test vector files)
        |           |
        |           +---invec
        |                 |
        |                 +--- (.bif, .sim files)
        +--vhdl
        |   |
        |   +---bid
        |   |
        |   |---buswatcher
        |   |
        |   +---common
        |   |
        |   +---reader
        |   |
        |   +---vr
        |   |
        |   +---trickbox
        |   |
        |   +---tbench
        |   |
        |   +---Smc_rtl
        |
        +-verilog
        |   |
        |   +---bid
        |   |
        |   +---buswatcher
        |   |
        |   +---common
        |   |
        |   +---reader
        |   |
        |   +---vr
        |   |
        |   +---trickbox
        |   |
        |   +---tbench
        |   |
        |   +---Smc_rtl
        |   |
        |   +---Smc_noscan_verilog_net_max
        |   |
        |   +---Smc_noscan_vhdl_net_min
        |   |
        |   +---Smc_scaninsert_verilog_net_typ
        |
        +-denali


  +---integration
        |
        +---bustest
        |     |
        |     +---invec
        |           |
        |           +--- (.tif, .sim)
        +---vhdl
        |     |
        |     +---chip
        |     |
        |     +---common
        |     |
        |     +---sys
        |     |
        |     +---tbench
        |     |
        |     +---Smc_rtl
        |
        |
        +---verilog
              |
              +---chip
              |
              +---common
              |
              +---sys
              |
              +---tbench
              |
              +---Smc_rtl

-- =============================================================================
-- ADDITIONAL INFORMATION
-- =============================================================================

Synthesis
=========
Synthesis has been performed using Synopsys 2001.08-SP2-2

Simulation
==========
Simulation has been performed using
Model Technology Inc V-System v5.5d,
VHDL/Verilog event-driven simulator
Cadence VERILOG-XL 3.3ISR
Denali 3.000-0044

Technology library
==================
Synthesis has been targeted to Avant! CB25 cell library.

-- --================================ End ====================================--
