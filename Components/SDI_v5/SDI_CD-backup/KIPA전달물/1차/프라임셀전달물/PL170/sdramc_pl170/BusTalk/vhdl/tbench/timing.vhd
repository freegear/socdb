-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : timing.vhd,v
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
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

constant Tclk         : time := 16 ns;
constant Tclkl        : time := tclk / 2;
constant Tclkh        : time := tclk / 2;

-- -----------------------------------------------------------------------------
--  AHB Output signals from the slave
-- -----------------------------------------------------------------------------
constant Tovrdy       : time := (1.0 * tclkh);
-- Ready valid time after HCLK

constant Tohrdy       : time := (0 * tclkh); 
-- Ready hold time after HCLK

constant Tovrsp       : time := (1.0 * tclkh);
-- Respoe vaild time after HCLK 

constant Tohrsp       : time := (0 * tclkh);
-- Respoe hold time after HCLK

constant Tovsplt      : time := (1.0 * tclkh); 
-- Split valid time after HCLK

constant Tohsplt      : time := (0 * tclkh);
-- Split hold time after HCLK

constant Tovdr        : time := (1.0 * tclkh);
-- HRDATA signal valid time before HCLK
 
constant Tohdr        : time := (0 * tclkh);
-- HRDATA signal hold time after HCLK

-- -----------------------------------------------------------------------------
--    AHB Inputs signals to the slave (driven by the test bench)
-- -----------------------------------------------------------------------------
constant Tisrdy       : time := (1.0 * tclkh); 
-- ReadyIn setup time after HCLK

constant Tihrdy       : time := (0.01 * tclkh);
-- ReadyIn hold time after HCLK

constant Tisrst       : time := (0.5 * tclkh);
-- Reset setup time before HCLK

constant Tihrst       : time := (0.01 * tclkh);
-- Reset hold time after HCLK

constant Resetdel     : time := (0.01 * tclkh); 
-- reset is asserted asynchronously
-- but Test bench  needs a value

constant Tisa         : time := (1.0 * tclkh);
-- Address setup time before HCLK

constant Tiha         : time := (0.01 * tclkh);
-- Address hold time after HCLK

constant Tisctl       : time := (1.0 * tclkh);
-- Control signal setup time before HCLK

constant Tihctl       : time := (0.01 * tclkh);
-- Control signal hold time after HCLK

constant Tistr        : time := (1.0 * tclkh) ;
-- HTRANS signal setup time before HCLK
 
constant Tihtr        : time := (0.01 * tclkh);
-- HTRANS signal hold time after HCLK

constant Tihmst       : time := (0.01 * tclkh);
-- Master Number hold time after HCLK

constant Tihmlck      : time := (0.01 * tclkh);
-- Master Locked hold time after HCLK

constant Tismst       : time := (1.0 * tclkh);
-- Master Number setup time before HCLK

constant Tismlck      : time := (1.0 * tclkh);
-- Master Locked setup time before HCLK

constant Tiswd        : time := (1.0 * tclkh);
-- Write data setup time before HCLK

constant Tihwd        : time := (0.01 * tclkh);
-- Write data hold time after HCLK

end timing;

-- ================================== End =================================== --
