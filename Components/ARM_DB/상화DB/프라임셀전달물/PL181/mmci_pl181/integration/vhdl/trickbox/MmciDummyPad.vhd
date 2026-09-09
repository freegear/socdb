-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciDummyPad.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Describe block function here
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ----------------------------------------------------------------------------

entity MmciDummyPad is
  port (
-- Inputs
        MMCICMDOUT     : in std_logic;  --  Command line input
        MMCIDATOUT     : in std_logic;  --  Data line input
        nMMCIDATEN     : in std_logic;  --  Data enable
        nMMCICMDEN     : in std_logic;  --  Command enable

-- Inouts
        MMCICMD        : inout std_logic; --  Command line
        MMCIDAT        : inout std_logic; --  Data line

-- Outputs 
        MMCICMDIN      : out std_logic; --  Command input
        MMCIDATIN      : out std_logic  --  Data input
       );
end MmciDummyPad;

-- ----------------------------------------------------------------------------
--
--                             MmciDummyPad
--                             ============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- ----------------------------------------------------------------------------

-- --============================ ARCHITECTURE =============================--

architecture synth of MmciDummyPad is

-- ----------------------------------------------------------------------------
-- Component declarations
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Constant declarations
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Signal declarations
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Function declarations
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ----------------------------------------------------------------------------

begin

MMCICMD             <= MMCICMDOUT when (nMMCICMDEN = '0')
                     else
                        'Z';


MMCIDAT             <= MMCIDATOUT when (nMMCIDATEN = '0')
                      else
                         'Z';

MMCICMDIN           <= MMCICMD;
MMCIDATIN           <= MMCIDAT;


end synth;

-- --================================== End ==================================--
