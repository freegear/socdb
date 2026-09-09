-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : timingmaster.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Define the Master BusWatcher timing parameters 
--
-- --=================================================================--

-- Note:
-- ---- 
-- Timing parameters are defined as a percentage of Tclk. If the 
-- Tclk period is changed, all parameters scale automatically.
-- ---------------------------------------------------------------------

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;

library chip;
use     chip.timing.all; 

-- ---------------------------------------------------------------------

package timingmaster is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

constant Tisrst : time := (0.1 * Tclk);
-- reset setup time before HCLK

constant Tihrst : time := (0.05 * Tclk);
-- reset hold time after HCLK

constant Tisgnt : time := (0.1 * Tclk);
-- grant setup time before HCLK

constant Tihgnt : time := (0.05 * Tclk);
-- grant hold time after HCLK

constant Tisrdy : time := (0.1 * Tclk);
-- ready setup time before HCLK

constant Tihrdy : time := (0.05 * Tclk);
-- ready hold time after HCLK

constant Tisrsp : time := (0.1 * Tclk);
-- response setup time before HCLK

constant Tihrsp : time := (0.05 * Tclk);
-- response hold time after HCLK

constant Tisrd  : time := (0.1 * Tclk);
-- ready setup time before HCLK

constant Tihrd  : time := (0.05 * Tclk);
-- ready hold time after HCLK

constant Tovtr  : time := (0.95 * Tclk);
-- transfer type valid time after HCLK

constant Tohtr  : time := (0 * Tclk);
-- transfer-type hold time after HCLK

constant Tova   : time := (0.95 * Tclk);
-- address valid time after HCLK

constant Toha   : time := (0 * Tclk);
-- address hold time after HCLK

constant Tovctl : time := (0.95 * Tclk);
-- control valid time after HCLK

constant Tohctl : time := (0 * Tclk);
-- control hold time after HCLK

constant Tovwd  : time := (0.95 * Tclk);
-- write-data valid time after HCLK

constant Tohwd  : time := (0 * Tclk);
-- write-data hold time after HCLK

constant Tovreq : time := (0.95 * Tclk);
-- request valid time after HCLK

constant Tohreq : time := (0 * Tclk);
-- request hold time after HCLK

constant Tovlck : time := (0.95 * Tclk);
-- lock valid time after HCLK

constant Tohlck : time := (0 * Tclk);
-- lock hold time after HCLK

end timingmaster;

-- --============================== End ==============================--
