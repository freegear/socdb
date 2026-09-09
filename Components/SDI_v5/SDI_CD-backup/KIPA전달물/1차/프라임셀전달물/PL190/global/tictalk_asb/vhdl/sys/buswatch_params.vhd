-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : buswatch_params.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : Package defining timing requirements for AMBA and APB
--
-- --=================================================================--

package buswatch_params is

------------------------------------------------------------------------
--  AMBA signals
------------------------------------------------------------------------

  -- BA setup to BCLK falling
  constant tsu_ba_bclk     : time;
  -- BTRAN setup to BCLK falling;
  constant tsu_btran_bclk  : time;
  -- Slave response setup to BCLK rising
  constant tsu_slv_bclk    : time;
  -- BD setup to BCLK falling
  constant tsu_b_d         : time;
  
end buswatch_params ;

package body buswatch_params is

  constant tsu_ba_bclk     : time := 0 ns;
  constant tsu_btran_bclk  : time := 0 ns;
  constant tsu_slv_bclk    : time := 0 ns;
  constant tsu_b_d         : time := 0 ns;
  
end buswatch_params;

-- --============================== End ==============================--
