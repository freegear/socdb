-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : timing.vhd.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
--
-- Purpose   : To define the AHB_Slave testbench timing-parameters
--
-- --=========================================================================--
-- Note:
-- ---- 
-- Values are set in percentage of tclkh, if the value of tclk is changed
-- then other timing parameters  will be assigned to new values automatically.
-- The timing parameter values has to be modified, if the slave design needs
-- different timing parameter values.   
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

-- -----------------------------------------------------------------------------

package timing is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

constant Tclk         : time := 100.00 ns;
constant Tclks        : time := 10.00 ns;
constant Tclkl        : time := tclk / 2;
constant Tclkh        : time := tclk / 2;

-- -----------------------------------------------------------------------------
--  AHB Output signals from the slave
-- -----------------------------------------------------------------------------
constant Tovrdy       : time := (1.2 * tclkh);
-- Ready valid time after HCLK

constant Tohrdy       : time := (0.00 * tclkh); 
-- Ready hold time after HCLK

constant Tovrsp       : time := (1.2 * tclkh);
-- Respoe vaild time after HCLK 

constant Tohrsp       : time := (0.00 * tclkh);
-- Respoe hold time after HCLK

constant Tovsplt      : time := (1.9 * tclkh); 
-- Split valid time after HCLK

constant Tohsplt      : time := (0.00 * tclkh);
-- Split hold time after HCLK

constant Tovdr        : time := (1.2 * tclkh);
-- HRDATA signal valid time before HCLK
 
constant Tohdr        : time := (0.00 * tclkh);
-- HRDATA signal hold time afetr HCLK

-- -----------------------------------------------------------------------------
--    AHB Inputs signals to the slave (driven by the test bench)
-- -----------------------------------------------------------------------------
constant Tisrdy       : time := (1.2 * tclkh); 
-- ReadyIn setup time after HCLK

constant Tihrdy       : time := (0.06 * tclkh);
-- ReadyIn hold time after HCLK

constant Tisrst       : time := (0.3 * tclkh);
-- Reset setup time before HCLK

-- constant Tihrst       : time := (0.06 * tclkh);
constant Tihrst       : time := (0.1 * tclkh);
-- Reset hold time afetr HCLK

constant Resetdel     : time := (0.06 * tclkh); 
-- reset is asserted asynchronously
-- but Test bench  needs a value

constant Tisa         : time := (1.2 * tclkh);
-- Address setup time before HCLK

constant Tiha         : time := (0.06 * tclkh);
-- Address hold time afetr HCLK

constant Tisctl       : time := (1.2 * tclkh);
-- Control signal setup time before HCLK

constant Tihctl       : time := (0.01 * tclkh);
-- Control signal hold time afetr HCLK

constant Tistr        : time := (1.2 * tclkh) ;
-- HTRANS signal setup time before HCLK
 
constant Tihtr        : time := (0.06 * tclkh);
-- HTRANS signal hold time afetr HCLK

constant Tihmst       : time := (0.06 * tclkh);
-- Master Number hold time afetr HCLK

constant Tihmlck      : time := (0.06 * tclkh);
-- Master Locked hold time afetr HCLK

constant Tismst       : time := (1.2 * tclkh);
-- Master Number setup time before HCLK

constant Tismlck      : time := (0.3 * tclkh);
-- Master Locked setup time before HCLK

constant Tiswd        : time := (1.2 * tclkh);
-- Write data setup time before HCLK

constant Tihwd        : time := (0.06 * tclkh);
-- Write data hold time afetr HCLK

end timing;
-- ================================== End =================================== --
