-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : timing.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
--
-- Purpose :
--           Define the AHB_Slave testbench timing parameters
--
-- --=========================================================================--
-- Note:
-- ---- 
-- Timing parameters are defined as a percentage of Tclk. If the 
-- Tclk period is changed, all parameters scale automatically.
-- -----------------------------------------------------------------------------

library IEEE;
use     IEEE.std_logic_1164.all;

-- -----------------------------------------------------------------------------

package timing is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- Define the low phase of clock 
constant Tclkl        : time := 30.0 ns;

-- Define the high phase of clock 
constant Tclkh        : time := 30.0 ns;

-- Define the total clock period.
constant Tclk         : time := Tclkl + Tclkh; 

-- Define the initial delay of the first clock edge
 
-- The clock line will remain low at the start of
-- simulation. The first rising edge of clock will
-- occur Tclks after simulation start. This parameter
-- can be varied to eliminate false violations at the
-- start of simulations during netlist simulations.
 
constant Tclks       : time   := 10 ns;

-- -----------------------------------------------------------------------------
--  AHB Output signals from the slave
-- -----------------------------------------------------------------------------
constant Tovrdy       : time := (0.55 * Tclk);
-- HREADYOUT valid time after HCLK rising edge

constant Tohrdy       : time := (0.0 * Tclk); 
-- HREADYOUT hold time after HCLK rising edge

constant Tovrsp       : time := (0.4 * Tclk);
-- HRESP valid time after HCLK rising edge

constant Tohrsp       : time := (0.0 * Tclk);
-- HRESP hold time after HCLK rising edge

constant Tovsplt      : time := (0.4 * Tclk); 
-- HSPLIT valid time after HCLK rising edge

constant Tohsplt      : time := (0.0 * Tclk);
-- HSPLIT hold time after HCLK rising edge

constant Tovdr        : time := (0.4 * Tclk);
-- HRDATA valid time after HCLK rising edge
 
constant Tohdr        : time := (0.0 * Tclk);
-- HRDATA hold time after HCLK rising edge

-- -----------------------------------------------------------------------------
-- AHB Inputs signals to the slave (driven by the test bench)
-- -----------------------------------------------------------------------------
constant Tisrdy       : time := (0.3 * Tclk); 
-- HREADYIN setup time before HCLK rising edge

constant Tihrdy       : time := (0.01 * Tclk);
-- HREADYIN hold time after HCLK rising edge

constant Tisrst       : time := (0.5 * Tclk);
-- HRESETn setup time before HCLK rising edge

constant Tihrst       : time := (0.2 * Tclk);
-- HRESETn hold time after HCLK rising edge

constant Resetdel     : time := (0.01 * Tclk); 
-- HRESETn is asserted asynchronously
-- but Test bench needs a value

constant Tisa         : time := (0.3 * Tclk);
-- HADDR setup time before HCLK rising edge

constant Tiha         : time := (0.01 * Tclk);
-- HADDR hold time after HCLK rising edge

constant Tisctl       : time := (0.3 * Tclk);
-- Control signals setup time before HCLK rising edge

constant Tihctl       : time := (0.01 * Tclk);
-- Control signals hold time after HCLK rising edge

constant Tistr        : time := (0.3 * Tclk) ;
-- HTRANS setup time before HCLK rising edge
 
constant Tihtr        : time := (0.01 * Tclk);
-- HTRANS hold time after HCLK rising edge

constant Tismst       : time := (0.5 * Tclk);
-- HMASTER setup time before HCLK rising edge

constant Tihmst       : time := (0.01 * Tclk);
-- HMASTER hold time after HCLK rising edge

constant Tismlck      : time := (0.5 * Tclk);
-- HMASTLOCK setup time before HCLK rising edge

constant Tihmlck      : time := (0.01 * Tclk);
-- HMASTLOCK hold time after HCLK rising edge

constant Tiswd        : time := (0.3 * Tclk);
-- HWDATA setup time before HCLK rising edge

constant Tihwd        : time := (0.01 * Tclk);
-- HWDATA hold time after HCLK rising edge

end timing;

-- --================================== End ==================================--
