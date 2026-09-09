-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SciDummyPad.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL131-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          Dummy pad between SCI and Integration Trickbox
-- --=========================================================================--


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity SciDummyPad is
   port (
      nSCICLKENpaden	  : in    std_logic; -- Off-chip clock buffer pad enable
      nSCICLKOUTENpaden	  : in    std_logic; -- On-chip clock buffer pad enable
      SCICLKOUTpadin	  : in    std_logic; -- On-chip clock out.
      nSCIDATAENpaden	  : in    std_logic; -- Off-chip data buffer pad enable
      nSCIDATAOUTENpadin  : in    std_logic; -- Off-chip data buffer pad data
      
      SCICLKOUTpadout	  : out   std_logic; -- Off-chip clock buffer output
      nSCIDATAOUTENpadout : out   std_logic  -- Off-chip data buffer output.
   );
end SciDummyPad;

-- -----------------------------------------------------------------------------
--
--                             SciDummyPad
--                             ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- -----------------------------------------------------------------------------


architecture structural of SciDummyPad is
begin

SCICLKOUTpadout     <= SCICLKOUTpadin when
                         nSCICLKENpaden = '0' and nSCICLKOUTENpaden = '0'
                       else
                         'Z';

nSCIDATAOUTENpadout <= nSCIDATAOUTENpadin when
                         nSCIDATAENpaden = '0'
                       else
                         'Z';
end structural;

