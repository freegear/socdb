----------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH (603) 882-2282
-- ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: clk_ctl.vhd
--
-- Revision: $Name: REV9910 $
--
-- Description:
--      This is module is buffers, and distubutes the clock and reset
--      signals used by the v8 and its peripherals, the USB SIE andd the
--      USB Hub. It contains two architectures. One for FPGAs, and one
--      for ASICs.
--
--      The ASIC architecture runs the entire design off a single 48MHz
--      clock, and uses clock enables to throttle the piplines and
--      statemachines to the USB bit rate.
--
--      The FPGA architecture distibutes multiple lower freqency (12MHz)
--      clocks.
--
-- Signals ending in _n are active low.
--

----------------------------------------------------------------------
-- Revision History
-- $Log: clk_ctl.vhd,v $
-- Revision 1.4  1999/08/25 17:46:32  scott
-- More patches to adjust for IEEE numeric_std package
--
-- Revision 1.3  1999/08/25 17:41:46  scott
-- Modified the code to use std_ulogic(_vector) and
-- IEEE numeric_std package
--
-- Revision 1.2  1998/06/03 02:31:44  chris
-- Fixed clocking syntax.
--
-- Revision 1.1  1998/05/29 18:06:28  chris
-- Initial revision
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- USE ieee.std_logic_arith.ALL;        -- + and - operators

entity clk_ctl is --------------------ENTITY---------------------
  port(
    clk48i      : in  std_ulogic;    -- DPLL 48 MHz osilator
    clken_12i   : in  std_ulogic;    -- 12MHz (48/4) clock enable
    clken_dplli : in  std_ulogic;    -- DPLL output clock enable
    rst_raw_n   : in  std_ulogic;    -- unregistered reset input
    clk_cpuo    : out std_ulogic;    -- uProcessor clock
    rst_cpuo    : out std_ulogic;    -- uProcessor reset
    clk_sieo    : out std_ulogic;    -- USB SIE clock
    clken_sieo  : out std_ulogic;    -- USB SIE clock enable
    rst_sieo    : out std_ulogic;    -- USB SIE synchronous reset
    clk_hubo    : out std_ulogic;    -- USB_HUB clock
    clken_hubo  : out std_ulogic;    -- USB SIE clock enable
    rst_hubo    : out std_ulogic     -- USB HUB synchronous reset
    );
end clk_ctl;

architecture asic of clk_ctl is ---------Architecture ASIC --------
  signal rst_count  : std_ulogic_vector(3 downto 0);
  signal sreset_sie : std_ulogic;
  signal sreset12   : std_ulogic;
  signal rst_sie_f  : std_ulogic;
  signal rst_12_f   : std_ulogic;
  signal stretch48n : std_ulogic;
begin
  clk_cpuo   <= clk48i;                       -- uProcessor clock
  rst_cpuo   <= sreset12 or not rst_raw_n;    -- uProcessor reset
  clk_sieo   <= clk48i;                       -- USB SIE clock
  clken_sieo <= clken_dplli;                  -- USB SIE clock enable
  rst_sieo   <= sreset_sie or not rst_raw_n;  -- USB SIE sync reset
  clk_hubo   <= clk48i;                       -- USB_HUB clock
  clken_hubo <= clken_12i;                    -- USB SIE clock enable
  rst_hubo   <= sreset12 or not rst_raw_n;    -- USB HUB sync reset

  sreset12   <= rst_12_f or not stretch48n;
  sreset_sie <= rst_sie_f or not stretch48n;

  sync_reset: process (clk48i)

    -- Description: This process implements reset logic for the vusb.
    -- When reset is asserted to the DPLL the dpll_clken and clk12en
    -- will stop. To properly reset the VUSB we must have PLL clock
    -- running. This logic will keep reset asserted for 16 additional
    -- PLL clocks allowing the VUSB to properly reset.

  begin -- sync_reset
    if clk48i'event and clk48i = '1' then

      -- stretch reset raw until the clock enable starts running.
      if rst_raw_n = '0' then
        stretch48n <= '0';              -- active low reset
      elsif clken_12i = '1' then        -- works better in
        stretch48n <= '1';              -- technologies that powerup
      end if;                           -- in the zero state

      if clken_12i = '1' or stretch48n = '0' then
        if stretch48n= '0' then
          rst_count <= "0000";
        elsif (rst_count /= "1111") then
          rst_count <= std_ulogic_vector(unsigned(rst_count)+1);
        else
          rst_count <= rst_count;
        end if;

        if rst_count /= "1111" or stretch48n = '0' then
          rst_12_f <= '1';
        else
          rst_12_f <= '0';
        end if;
      end if;

      if clken_dplli = '1' or stretch48n = '0' then
        rst_sie_f <= rst_12_f or not stretch48n;
      end if;

    end if;    -- clk48i

  end process sync_reset;

end asic;

architecture fpga of clk_ctl is ---------Architecture FPGA --------
  signal rst_count  : std_ulogic_vector(3 downto 0);
  signal rst_sie_f  : std_ulogic;
  signal sreset_sie : std_ulogic;
  signal rst_sie    : std_ulogic;
  signal rst_sie_ff : std_ulogic;
  signal sreset12   : std_ulogic;
  signal rst_12_f   : std_ulogic;
  signal stretch48n : std_ulogic;

begin
  clk_cpuo   <= clken_12i;                    -- uProcessor clock
  rst_cpuo   <= sreset12 or not rst_raw_n;    -- uProcessor reset
  clk_sieo   <= clken_dplli;                  -- USB SIE clock
  clken_sieo <= '1';                          -- USB SIE clock enable
  rst_sieo   <= sreset_sie or not rst_raw_n;  -- USB SIE sync reset
  clk_hubo   <= clken_12i;                    -- USB_HUB clock
  clken_hubo <= '1';                          -- USB SIE clock enable
  rst_hubo   <= sreset12 or not rst_raw_n;    -- USB HUB sync reset

  sreset12   <= rst_12_f or not stretch48n;
  sreset_sie <= rst_sie_ff or rst_12_f or not stretch48n;

  sync_reset: process (clk48i)

  -- Description: This process implements reset logic for the vusb.
  -- When reset is asserted to the DPLL the dpll_clken and clk12en will
  -- stop. To properly reset the VUSB we must have PLL clock running.
  -- This logic will keep reset asserted for 16 additional PLL clocks
  -- allowing the VUSB to properly reset.
  begin -- sync_reset

    if clk48i'event and clk48i = '1' then
      -- stretch reset raw until the clock enable starts running.
      if rst_raw_n = '0' then
        stretch48n <= '0';                  -- active low reset
      elsif clken_12i = '1' then            -- works better in
        stretch48n <= '1';                  -- technologies that powerup
      end if;                               -- in the zero state
    end if;    -- clk48i
  end process sync_reset;

  sync_reset_12: process (clken_12i)

  begin -- sync_reset
    if clken_12i'event and clken_12i = '1' then
      if stretch48n = '0' then
        rst_count <= "0000";
      elsif (rst_count /= "1111") then
        rst_count <= std_ulogic_vector(unsigned(rst_count)+1);
      else
        rst_count <= rst_count;
      end if;

      if rst_count /= "1111" or stretch48n = '0' then
        rst_12_f <= '1';
      else
        rst_12_f <= '0';
      end if;

    end if; -- clken_12i

  end process sync_reset_12;

  sync_reset_sie: process (clken_dplli)

  begin -- sync_reset
    if clken_dplli'event and clken_dplli = '1' then
      rst_sie_f  <= rst_12_f;
      rst_sie_ff <= rst_sie_f;
    end if; -- clken_dplli

  end process sync_reset_sie;

end fpga;
