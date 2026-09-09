-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SciTrick.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL131-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Trickbox to check the integration of SCI in a larger chip.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity SciTrick is
   port (
      SCICLKOUTpadout     : in    std_logic; -- SCICLKOUT to SCICLKIN
      nSCIDATAOUTENpadout : in    std_logic; -- nSCIDATAOUTEN to SCIDATAIN
      SCIDEACACK          : in    std_logic; -- SCIDEACACK to SCIDEACREQ
      SCIVCCEN            : in    std_logic; -- SCIVCCEN
      nSCICARDRST         : in    std_logic; -- nSCICARDRST
      SCIFCB              : in    std_logic; -- SCIFCB
      SCICLKIN            : out   std_logic; -- SCICLKIN
      SCIDATAIN           : out   std_logic; -- SCIDATAIN
      SCIDEACREQ          : out   std_logic; -- SCIDEACREQ
      SCIDETECT           : out   std_logic  -- SCIDETECT
   );
end SciTrick;

-- ---------------------------------------------------------------------
--
--                             SciTrick.vhd
--                             ============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--    This module is a simple trickbox used for integrating the SCI on
--    a larger chip. 
--    This trickbox has the following functionality:
--    o SCICLKOUTpadout is fed back to the SCICLKIN input.
--    o nSCIDATAOUTENpadout is fed back to the SCIDATAIN input
--    o SCIDEACACK output is fed back to the SCIDEACREQ input
--    o SCIVCCEN, nSCICARDRST and SCIFCB outputs are XOR'd and the 
--      single result fed back to the SCIDETECT input.
--    
--
-- ---------------------------------------------------------------------
 architecture structural of SciTrick is
  
begin
  SCICLKIN	 <= SCICLKOUTpadout;
  SCIDATAIN	 <= nSCIDATAOUTENpadout;
  SCIDEACREQ	 <= SCIDEACACK;
  SCIDETECT	 <= SCIVCCEN XOR nSCICARDRST XOR SCIFCB;
end structural;
