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
-- File Name              : configmaster.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           To describe the configuration of testbench.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;
 
-- ---------------------------------------------------------------------

package configmaster is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant DATABUSWIDTH : integer := 32;
-- indicates the width of the data bus

end configmaster;

-- --============================= END ===============================--
