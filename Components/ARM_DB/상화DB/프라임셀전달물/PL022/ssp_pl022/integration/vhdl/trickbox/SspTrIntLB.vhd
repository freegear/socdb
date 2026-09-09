-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SspTrIntLB.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- ---------------------------------------------------------------------
-- Purpose :
--     Trickbox to check the integration of SSP PL022 in a larger chip.
--
-- --=================================================================--
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
 
-- --------------------------------------------------------------------
entity SspTrIntLB is
  port (
-- Inputs
        SSPTXDpadout    : in  std_logic; -- SSP Transmit Data
        SSPCLKOUTpadout : in  std_logic; -- SSP Serial ClockOut
        SSPFSSOUTpadout : in  std_logic; -- SSP Frame/SlaveSelect Out

-- Outputs
        SSPRXD          : out std_logic; -- SSP Receive Data
        SSPCLKIN        : out std_logic; -- SSP Serial ClockIn
        SSPFSSIN        : out std_logic  -- SSP Frame/SlaveSlectIn
       );
end SspTrIntLB;

-- ---------------------------------------------------------------------
--
--                             SspTrIntLB
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--    This module is a simple trickbox used for integrating the SSP on
--  a larger chip. This trickbox gives a loopback facility for few
--  input/output signals.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--
 
architecture structural of SspTrIntLB is
 
-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------
 
-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------
 
begin

  SSPRXD       <= SSPTXDpadout;
  SSPCLKIN     <= SSPCLKOUTpadout;
  SSPFSSIN     <= SSPFSSOUTpadout;

end structural;
 
-- --============================== End ==============================--
                
                
