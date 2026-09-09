------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS 
-- RESERVED. This software is provided under license and contains 
-- proprietary and confidential material which is the property of 
-- VAutomation Inc.            HTTP://www.vautomation.com
--
-- File: v1284.vhd
-- Revision: $Name: REV9910 $
-- Gate Count: under 1000 gates
-- Description:
--      IEEE 1284 synthesizable PC Parallel Port IO module.
-- The 1284 interface is currently a simple "compatible" mode only
-- PC parallel port. Writing a byte to the pp_out register causes the
-- data to be enabled onto the 1284 bus, the STROBE_N signal is 
-- activated for the programmed interval and then the data bus is 
-- tristated. The setup,strobe width and hold times are programmable 
-- via the pp_ctr register.
--
-- Register Definition:
-- Addr Name    R/W     Description
--  0   DOUT    W       8 Bit data out register
--  0   DIN     R       8 Bit data in register
--  1   CTRS    R/W     CTRS[7:4]=Tsetup  (0=1 clk, F=16 clks)
--                      CTRS[3:0]=Tstrobe (0=1 clk, F=16 clks)
--  2   CTRH    R/W     CTRH[7:4]=Thold   (0=1 clk, F=16 clks)
--                      CTRH[2]=DRVDO drive DOUT
--                      CTRH[1]=STLOW force STROBE_N low
--                      CTRH[0]=STDIS disable STROBE_N counter
--  3   CTL     R/W     Data register for the Control signals
--  4   CTLZ    R/W     Data direction register for the Control signals
--                      0=Z, 1=enables tristate driver
--                      CTL[7]=INIT_N   - host drives
--                      CTL[6]=AUTOFD_N - host drives
--                      CTL[5]=SELECTIN_N       - host drives
--                      CTL[4]=ACK_N    - peripheral drives
--                      CTL[3]=BUSY     - bit 3 of nibble mode data
--                      CTL[2]=PERROR   - bit 2 of nibble mode data
--                      CTL[1]=SELECT   - bit 1 of nibble mode data
--                      CTL[0]=FAULT_N  - bit 0 of nibble mode data
--
-- Timing diagram:
--              Tsetup      Tstrobe     Thold
--            |<--1us--->|<--1us---->|<--1us---->|
--        _   _   _   _   _   _   _   _   _   _   _   _   _   _   _
-- SYSCLK  |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |
--       _     _________________________________________________
-- WE_N   \___/
--             __________________________________
-- DATA  -----<__________________________________>---------------
--         _______________             __________________________
-- STROBE_N               \___________////
--             ___________________________________
-- pp_run ____/                                   \______________
--         ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ______________
-- pp_count___XTs_X_n_X_0_XTp_X_n_X_0_XTh_X_n_X_0_X______________
--             ___________
-- pp_setup___/           \______________________________________
--                         ___________
-- pp_strobe______________/           \__________________________
--                                     ___________
-- pp_hold____________________________/           \______________
--
-- The timing diagram above shows the state machine operation.
-- pp_ce and WE_N and READY indicate a write to the PP_OUT register 
-- which triggers the state machine. pp_count counter is loaded with 
-- Tsetup and pp_setup is set high. Data is driven out the PP_DATA 
-- lines. When the counter counts down to 0, pp_setup is cleared and 
-- pp_strobe is set. pp_strobe=1 causes STROBE_N to go active on the 
-- cable. pp_count is loaded with Tstrobe and counts down until=0. Next,
-- pp_hold is set high and pp_strobe is cleared. STROBE_N is open 
-- collector and will take some time to go high. 
-- Sufficient time must be included in Thold
-- to allow for the rise time of STROBE_N. pp_count is loaded with Thold
-- and counts to 0 at which time all pp_hold and pp_run are cleared.
--
-- Typically you want the Tsetup,Tstrobe, and Thold values to be 
-- approximately 1us (750ns is the min spec) so a value of 0xb is good 
-- at 12Mhz. If the input clock is more than 16Mhz, it will need to be 
-- prescaled before being used to run the PP_CTRs. Alternatively, the 
-- counters can be made larger but only the upper 4 bits are 
-- programmable.
--
-- To negotiate various modes on the 1284 bus, additional control is
-- needed over the bus. To support this activity, additional bits in the
-- CTRH register are provided. 
-- Bit 0 disables the strobe counter when 1. This allows data to be
-- written to the DOUT register without having STROBE_N automatically
-- generated.
-- Bit 1 forces STROBE_N to go low when 1. 
-- Bit 2 enables the data in DOUT onto the bus when 1.
--
-- Example 1284 Byte mode negotiation and receipt of the DEVICE_ID 
-- string. Refer to the IEEE 1284 specification for more detail. 
-- The numbers in () indicate the IEEE 1284 Event # as described in the 
-- spec in Annex B.
-- 0) Initialize the V1284 core 
--      a) CTL=40, CTLZ=E0 asserts INIT_N and SELECTIN_N low which 
--              tell the printer to reset.
--      b) Wait for about 50 us.
--      c) INIT_N=1 to end the reset
--      d) Wait for about 50 us.
-- 1) STDIS=1 - Disable automatic STROBE_N generation
-- 2) DOUT=0x05 - Byte mode extensibility request value=DEVICE_ID
-- 3) DRVDO=1 - drive the DOUT bus (1284 event 0)
-- 4) SELECTIN_N=1, AUTOFD_N=0 - Ask the peripheral if it is 1284 
--	compliant (1)
-- 5) Wait for ACK_N going low, Timeout after 50us. (2)
--      If we timeout, the printer is not 1284 compliant.
-- 6) Verify that FAULT_N, PERROR and SELECT are all 1. If not, the 
--	printer is not 1284 compliant.
-- 7) STROBE_N=0 (STLOW=1), then wait 1 us. 
--	Latch the Extensibility value. (3)
-- 8) STROBE_N=1 (STLOW=0), AUTOFD_N=1. 
--	Acknowledge 1284 compliance (4)
-- 9) Wait for ACK_N=1, Timeout after 50 us. (6)
-- 10) Verify that FAULT_N=0. Printer has data to send. (5)
-- 11) DRVDO=0. tristate the data bus (14)
-- 12) Wait 1 us.
-- 13) AUTOFD_N=1, request data (7)
-- 14) Wait for ACK_N=0, Timeout after 50 us. (10)
-- 15) Read DIN which is a byte of data from the printer.
-- 16) AUTOFD_N=1. (10)
-- 17) STROBE_N=0. (16)
-- 18) Wait for ACK_N=1, timeout after 50 us. (11)
-- 19) STROBE_N=1. (17) end of this transfer
-- 20) If FAULT_N=1, then there is no more data, else, go step 12.
-- 21) STDIS=0, DRVDO=0 - disable manual control of STROBE and DOUT bus.
-- 22) SELECTIN_N=0,AUTOFD_N=1 - exit 1284 extensibility mode (22)
-- 23) Wait for ACK_N=0, timeout after 50 us (24)
-- 24) AUTOFD_N=0  - acknowledge the exit (25)
-- 25) Wait for ACK_N=1 - acknowledge (27)
-- 26) AUTOFD_N=1 - exit complete (28)
-- 1284 port is now ready for normal operation again.

--------------Revision History------------------------------------------
-- $Log: v1284.vhd,v $
-- Revision 1.9  1999/09/14 16:23:06  eric
-- more RMM cleanups.
--
-- Revision 1.8  1999/09/13 21:01:34  eric
-- no logic changes - RMM improvments.
--
-- Revision 1.7  1999/08/24 20:11:15  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std pkg
--
-- Revision 1.6  1998/11/20 00:49:07  eric
-- Corrected the ordering of the if statements on STROBE.
--
-- Revision 1.5  1998/11/19 01:08:51  eric
-- Added support for 1284 exensibility requests.
--
-- Revision 1.4  1998/04/17 20:07:40  eric
-- Added PP_RUN to busy otherwise the CPU writes several chars before 
-- the printer can assert BUSY.
--
-- Revision 1.3  1998/04/16 17:46:37  chris
-- Fixed pp_ctr2 writes.
--
-- Revision 1.2  1997/11/20 14:59:02  chris
-- Added empty architecture.
--
-- Revision 1.1  1997/10/23 01:11:11  eric
-- Initial revision
--
------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all; -- use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;

entity v1284 is -----------------------------ENTITY---------------------
  port( clk     : in  std_ulogic;    -- everything clocks on rising edge
        rst     : in  std_ulogic;        -- reset

        addr    : in  std_ulogic_vector(2 downto 0); -- address bus
        chip_sel: in  std_ulogic;        -- device Select
        datain  : in  std_ulogic_vector(7 downto 0); -- data bus
        read    : in  std_ulogic;        -- read enable
        write   : in  std_ulogic;        -- write enable

        dataout : out std_ulogic_vector(7 downto 0); -- data bus

        -- IEEE 1284 PC Parallel Port interface
        pp_ctl_in    : in  std_ulogic_vector(7 downto 0);
        pp_datain    : in  std_ulogic_vector(8 downto 1);

        pp_dataout   : out std_ulogic_vector(8 downto 1);
        pp_data_enb  : out std_ulogic;
        pp_ctl_out   : out std_ulogic_vector(7 downto 0);
        pp_ctl_enb   : out std_ulogic_vector(7 downto 0);
        pp_strobe_n  : out std_ulogic);
end v1284;

architecture empty of v1284 is 
begin 
  dataout     <= (others=>'0');
  pp_strobe_n <= '1';
  pp_dataout  <= (others=>'0');
  pp_data_enb <= '0';
  pp_ctl_out  <= (others=>'0');
  pp_ctl_enb  <= (others=>'0');

end empty;

architecture rtl of v1284 is -------------------Architecture------------

  component vpio        -- generic 8 bit programmable IO port
    port (
      clk         : in  std_ulogic;                     -- clock input
      rst         : in  std_ulogic;                     -- reset

      addr        : in  std_ulogic;                       -- address
      datain      : in  std_ulogic_vector(7 downto 0);  -- DATA bus in
      write       : in  std_ulogic;                     -- uP write 
      chip_sel    : in  std_ulogic;                     -- Chip select 
      port_in     : in  std_ulogic_vector(7 downto 0);  -- IO Port in

      dataout     : out std_ulogic_vector(7 downto 0);  -- DATA bus out
      port_out    : out std_ulogic_vector(7 downto 0);  -- IO Port out
      port_enb    : out std_ulogic_vector(7 downto 0)); -- tristate enb
  end component;

  signal addr0_n        : std_ulogic;    -- NOT addr(0)
  signal pp_out : std_ulogic_vector(7 downto 0); -- 1284 data out reg
  signal pp_count       : std_ulogic_vector(3 downto 0); -- 1284 ctl reg
  signal pp_ctl_in_busy : std_ulogic_vector(7 downto 0); 
	-- add pp_run to busy
  signal pp_ctrs        : std_ulogic_vector(7 downto 0); -- 1284 ctl reg
  signal pp_ctrh        : std_ulogic_vector(7 downto 0); -- 1284 ctl reg
  signal pp_setup,pp_strobe     : std_ulogic;    -- 1284 control
  signal pp_trigger,pp_run      : std_ulogic;    -- 1284 control
  signal ctlout : std_ulogic_vector(7 downto 0); -- control regs mux out
  signal ctl_sel        : std_ulogic;    -- control register select

attribute sync_set_reset : string;
attribute sync_set_reset of rst : signal is "true";
	--required for synopsys

begin   ----------------------------------------------------------------

  pp_data_enb <= pp_run or pp_ctrh(2);  -- drive the ports
  pp_dataout <= pp_out;

  pp_ctl_in_busy <= pp_ctl_in(7 downto 4) & 
	-- OR in PP_RUN with busy so the CPU
                    (pp_ctl_in(3) or pp_run) & 
		    -- won't write another character until the
                    pp_ctl_in(2 downto 0);      
		    -- printer has had a chance to assert busy.

  dataout <= pp_datain when addr="000" else 
             pp_ctrs when addr="001" else
             pp_ctrh when addr="010" else
             ctlout;

  pp_strobe_n  <= not pp_strobe;

  ctl_sel <= '1' when chip_sel='1' and (addr="011" or addr="100") 
	else '0';

  addr0_n <= not addr(0);

  u_vpio:vpio port map (   
  -- use the generic parallel IO block for the ctl regs
    clk         => clk,
    rst         => rst,
    addr        => addr0_n,
    datain      => datain,
    dataout     => ctlout,
    write       => write,
    chip_sel    => ctl_sel,
    port_in     => pp_ctl_in_busy, -- OR in PP_RUN with busy
    port_out    => pp_ctl_out,
    port_enb    => pp_ctl_enb);


  pp_trigger <= chip_sel and not addr(2) and not addr(1) and 
     not addr(0) and write and not pp_ctrh(0); -- trigger a write

  pp_out_proc:process(clk)
  begin
    if (clk'event and clk='1') then

      if (rst='1') then         -- create the data out register
        pp_out <= "00000000";   -- synch reset
      elsif (pp_trigger='1') then
        pp_out <= datain;
      end if;
    end if;
  end process;

  cek_proc:process(clk)
  begin
    if (clk'event and clk='1') then
      if (rst='1') then
        pp_ctrs <= "00000000";
      elsif (chip_sel='1' and 
	addr(2 downto 0)="001" and write='1') then
        pp_ctrs <= datain;
      end if;

      if (rst='1') then
        pp_ctrh <= "00000000";
      elsif (chip_sel='1' and 
	addr(2 downto 0)="010" and write='1') then
        pp_ctrh <= datain;
      end if;
    end if;
  end process;

  elr_proc:process(clk)
  begin
    if (clk'event and clk='1') then
    -- state machine, load the 4 bit counter with the 3 different
      -- value for Tsetup,Tstrobe,Thold and then count.
      if (rst='1') then               ---------pp_setup----------
        pp_setup<='0';
      elsif (pp_trigger='1') then
        pp_setup<='1';
      elsif (pp_count="0000") then
        pp_setup<='0';
      end if;
    end if;
  end process;

  gjr_proc:process(clk)
  begin
    if (clk'event and clk='1') then
      if (rst='1') then               ---------pp_strobe----------
        pp_strobe<='0';
      elsif (pp_ctrh(0)='1') then
        pp_strobe<= pp_ctrh(1);
      elsif (pp_setup='1' and pp_count="0000") then
        pp_strobe<='1';
      elsif (pp_count="0000") then
        pp_strobe<='0';
      end if;
    end if;
  end process;

  vauto_proc:process(clk)
  begin
    if (clk'event and clk='1') then
      if (rst='1') then               --------Counter control---------
        pp_count <= "0000";
      elsif (pp_trigger='1') then
        pp_count<=pp_ctrs(7 downto 4);
      elsif (pp_setup='1' and pp_count="0000") then
        pp_count<=pp_ctrs(3 downto 0);
      elsif (pp_strobe='1' and pp_count="0000") then
        pp_count<=pp_ctrh(7 downto 4);
      elsif (pp_run='1') then
        pp_count<=std_ulogic_vector(unsigned(pp_count)-1);
      end if;
    end if;
  end process;

  n8822282_proc:process(clk)
  begin
    if (clk'event and clk='1') then
      -- pp_run indicates that the 1284 interface is active.
      if (rst='1' or 
	(pp_count="0000" and pp_setup='0' and pp_strobe='0')) then
        pp_run <= '0';
      elsif (pp_trigger='1') then
        pp_run <= '1';
      end if;
    end if;
  end process;

end rtl;
