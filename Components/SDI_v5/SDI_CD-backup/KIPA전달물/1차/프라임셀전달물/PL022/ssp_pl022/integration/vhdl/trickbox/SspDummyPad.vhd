-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SspDummyPad.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Dummy pad between SSP and Integration Trickbox
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ----------------------------------------------------------------------------

entity SspDummyPad is
  port (
-- Inputs
        SSPTXDpadin     : in std_logic;  --  Transmit Data input
        nSSPOEpaden     : in std_logic;  --  Tranmit Data enable input
        SSPCLKOUTpadin  : in std_logic;  --  Serial Clock input
        nSSPCTLOEpaden  : in std_logic;  --  Clock enable input
        SSPFSSOUTpadin  : in std_logic;  --  Frame/SlaveSelect input
        

-- Outputs 
        SSPTXDpadout    : out std_logic; --  Transmit Data output
        SSPCLKOUTpadout : out std_logic; --  Serial Clock output
        SSPFSSOUTpadout : out std_logic  --  Frame/SlaveSelect output
       );
end SspDummyPad;

-- ----------------------------------------------------------------------------
--
--                             SspDummyPad
--                             ============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
--   SSPTXDpadin is fed by SSPTXD, buffered to become SSPTXDPadout.
--   nSSPOEpaden is fed by nSSPOE and is the enable control for SSPTXDpadout.
--   SSPCLKOUTpadin is fed by SSPCLKOUT, buffered to become SSPCLKOUTpadout.
--   nSSPCTLOEpaden is fed by nSSPCTLOE and is the enable control for 
--   SSPTXDpadout.
--   SSPFSOUTpadin is fed by SSPFSSOUT, buffered to become SSPFSSOUTpadout.
-- ----------------------------------------------------------------------------

-- --============================ ARCHITECTURE =============================--

architecture synth of SspDummyPad is

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

SSPTXDpadout       <= SSPTXDpadin when (nSSPOEpaden = '0')
                     else
                        'Z';


SSPCLKOUTpadout    <= SSPCLKOUTpadin when (nSSPCTLOEpaden = '0')
                      else
                         'Z';

SSPFSSOUTpadout    <= SSPFSSOUTpadin;


end synth;

-- --================================== End ==================================--
