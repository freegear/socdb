-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
--  File Name              : SsmcTrPackage.vhd.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
--------------------------------------------------------------------------------
-- Purpose :
--           All constants needs to be change in the tricbox design are
--           declared here
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

package SsmcTrPackage is

--------------------------------------------------------------------------------
--
--                               SsmcTrPackage
--                               ============= 
--
--------------------------------------------------------------------------------

constant MemDeep          : Integer := 2048;
-- Determines the size of memory array

constant AddWrHoldTime    : time := 0 ns;
-- Address hold time with respect to the rising edge(finishing end) of write

constant AddWrSetupTime   : time := 0 ns;
-- Address setup time with respect to the falling edge of(starting edge) write

constant DataWrHoldTime   : time := 0 ns;
-- Data hold time with respect to the rising edge(finishing end)  of write

constant DataWrSetupTime  : time := 0 ns;
-- Data hold time with respect to the rising edge(finishing end)  of write

constant DelayTime        : time := 3 ns;
-- Error window in time calculations

end SsmcTrPackage;

-- --================================= End ===================================-
