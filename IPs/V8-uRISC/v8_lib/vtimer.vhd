-----------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH. All rights reserved.
-- VAutomation Inc. Nashua NH 03063 (603) 882-2282 www.vautomation.com.
-- This software is provided under license and contains proprietary
-- and confidential material which is the property of VAutomation Inc.
--
-- File: vtimer.vhd
-- Revision: $Name: REV9910 $
-- Features: Synthesizable 16 bit Counter Timer peripheral.
-- Gate count: about 1600 gates
--
-- Description: 
-- 	This logic provides a 16-bit counter/timer with an 8 bit prescale,
--	two max count registers for PWM support and one external counter
--	input.
--
--	The current count value in the CTR can be read or written at anytime.
--	Care must be taked when accessing the CTR when RUN is 1. No protection
--	is provided to insure that the counter won't count in the time between
--	reading the low and the high halves of the CTR. Generally, you should
--	read the CTRH, then the CTRL, then reread the CTRH and compare with
--	the first read of the CTRH. If the values are equal, then value read
--	is correct. If the values differ, you may want to simply reread the
--	CTR until they do match, or inspect CTRL and select the first CTRH
--	if CTRL[7]=1 or the second CTRH if CTRL[7]=0.
--
--	All of the registers are set to zero when RESET is asserted.
--
--	Load PRESCALE with the desired 8 bit prescale value minus one. A
--	value of zero disables prescaling. A value of 1 prescales by 2,
--	a value of 2 prescales by 3, a value of 255 prescales by 256.
--
--	Load MAXA and optionally MAXB with the desired max count values.
--	If you want an interrupt after counting EXT_ENB being high for 100
--	clocks, load a value of 100 into the MAXA counter.
--
--	Using only MAXA will result in a square wave on the PWM output.
--	Using both MAXA and MAXB allows you to control the duty cycle of
--	PWM making it useful for Pulse-Width-Modulation.
--
--	Note that EXT_ENB is level sensitive and should be synchronized to
--	the clock before sending it to this block. To make the EXT_ENB
--	signal edge sensitive, add an extra flop external to this module and
--	gate it with the unflopped signal.
--
-- Register Description:
--  ADDR R/W	Description
--  000	 R/W	CTRL Counter Low
--  001	 R/W	CTRH Counter High
--  010	 R/W	CTL
--		[0]= RUN 1=enable counter, 0=stop
--		     automatically set to zero when MAX reached if RET=0
--		[1]= EXT 1=use EXT_ENB to enable counter, 0=internal clock
--		[2]= reserved, set to zero
--		[3]= MXB 1=enable MAXB, 0=use only MAXA
--		[4]= RET 1=Retrigger when MAX reached, 0=stop when cnt=max
--		[5]= PWM 1=counting MAXB, 0=counting to MAXA
--		[6]= ENB 1=enable interrupt pin, 0=mask interrupt
--		[7]= INT 1=interrupt (MAX reached), 0=no interrupt
--		     write a one to clear this bit, writing a zero has no effect
--  011	 R/W	prescale
--		 Divide the selected count enable by the value in this register
--		 plus one. 0=disable prescale, 1=divide by 2, 2=divide by 3,
--		 255=divide by 256.
--  100	 R/W	MAXA low
--  101	 R/W	MAXA high
--  110	 R/W	MAXB low
--  111	 R/W	MAXB high
--
-----------------------------------------------------------------------------
-- $Log: vtimer.vhd,v $
-- Revision 1.9  1999/09/13 20:59:00  eric
-- No Logic changes - just more RMM style improvements.
--
-- Revision 1.8  1999/08/24 20:42:13  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std package
--
-- Revision 1.7  1998/11/20 03:56:50  eric
-- MAXB was never being selected.
--
-- Revision 1.6  1998/11/11 23:54:26  eric
-- Added readback to the MAXx and prescale registers.
--
-- Revision 1.5  1998/08/27 19:17:23  eric
-- We were switching to MAXB and retriggering the interrupt when CTR=max.
--
-- Revision 1.4  1998/08/17 23:07:54  eric
-- Completely new an redesigned 16 bit PWM capable counter/timer.
--
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use ieee.std_logic_arith.all;

entity vtimer is-------------ENTITY--------------------------------------
  port(clk	: in  std_ulogic; -- clock input
       rst	: in  std_ulogic; -- reset

       addr	: in  std_ulogic_vector(2 downto 0);  -- address
       datain	: in  std_ulogic_vector(7 downto 0);  -- Data input
       ext_enb	: in  std_ulogic;  -- external count enable
       sel	: in  std_ulogic;  -- enable writes
       write	: in  std_ulogic; -- write register when 1

       dataout	: out std_ulogic_vector(7 downto 0);  -- Data output
       interrupt: out std_ulogic;  -- interrupt pending
       pwm	: out std_ulogic);  -- PWM bit of the CTL register
  
end vtimer;

architecture empty of vtimer is	------------ARCHITECTURE------------------
begin
  dataout <= (others=>'0');  -- Data output
  interrupt    <= '0';
  pwm    <= '0';
end empty;

architecture rtl of vtimer is	------------ARCHITECTURE------------------

  signal ctl	: std_ulogic_vector(7 downto 0);  -- control register
  signal ctr	: std_ulogic_vector(15 downto 0); -- counter
  signal maxa	: std_ulogic_vector(15 downto 0); -- max count A
  signal maxb	: std_ulogic_vector(15 downto 0); -- max count B
  signal prescale	: std_ulogic_vector(7 downto 0); -- prescale value
  signal pre_ctr	: std_ulogic_vector(7 downto 0); -- prescale counter
  signal count_enb	: std_ulogic; -- 1=counter will count
  signal max	: std_ulogic; -- 1=max count reached
  signal ret,run,ext	: std_ulogic; -- CTL bits

  attribute sync_set_reset : string;      -- required for synopsys
  attribute sync_set_reset of rst : signal is "true";   -- required for synopsys to work.
-- The following line is used when translating to Verilog...
-- synopsys sync_set_reset "rst"

begin

-- DATAOUT readback mux, you can easily make all of the registers READ/WRITE
-- by  adding the other registers to this mux. Readback generally doesn't
-- justify increase in gate count.
  with addr select
    dataout <= ctr(7 downto 0)   when "000",
               ctr(15 downto 8)  when "001",
               -- you can save a few gates by commenting out the next 5 lines 
               -- which makes the respective registers read only.
               prescale          when "011",
               maxa(7 downto 0)  when "100",
               maxa(15 downto 8) when "101",
               maxb(7 downto 0)  when "110",
               maxb(15 downto 8) when "111",
               ctl               when others;

  vauto_proc: process (clk)
  begin
    if (clk'event and clk='1') then
      if (rst='1') then			-- sync reset
        ctr <= "0000000000000000";
        ctl <= "00000000";
        prescale <= "00000000";
        pre_ctr <= "00000000";
        maxa <= "0000000000000000";
        maxb <= "0000000000000000";
      else
        -- register write logic
        if (sel='1' and write='1') then -- register write
          if    (addr="000") then
            ctr(7 downto 0) <= datain;
          elsif (addr="001") then 
            ctr(15 downto 8) <= datain;
          elsif (addr="010") then 	-- CTL 7 and 5 are special cases
            ctl(6) <= datain(6);
            ctl(4 downto 0) <= datain(4 downto 0);
            if (ctl(0)='0' and datain(0)='1') then
              ctr <= "0000000000000000"; -- clear the counter when re-enabling
            end if;
          elsif (addr="011") then 
            prescale <= datain;
          elsif (addr="100") then 
            maxa(7 downto 0) <= datain;
          elsif (addr="101") then 
            maxa(15 downto 8) <= datain;
          elsif (addr="110") then 
            maxb(7 downto 0) <= datain;
          else
            maxb(15 downto 8) <= datain;
          end if; -- addr select
        end if;	-- register write

        -- increment or reload counter
        if (max='1' and ret='1') then -- max reached, reload if retrigger set
  	  ctr <= "0000000000000000";
        elsif (count_enb='1' and -- counter enabled and NOT doing a write
               not (sel='1' and write='1' and addr(1)='0' and addr(2)='0')) then
  	  ctr <= std_ulogic_vector(unsigned(ctr) + 1);
        end if;

        -- decrement the prescale counter
        if (run='1' and (ext='0' or (ext='1' and ext_enb='1'))) then
          if (pre_ctr="00000000") then
            pre_ctr <= prescale;	-- reload when zero
          else
            pre_ctr <= std_ulogic_vector(unsigned(pre_ctr) - 1);
            -- decrement when enabled
          end if;
        elsif (run='0') then
          pre_ctr <= prescale;	-- preload when RUN is disabled
        end if;

        -- Compute the INT, RUN and PWM outputs
        if (sel='1' and write='1' and addr="010" and ctl(7)='1' and datain(7)='1') then
          ctl(7) <= '0'; -- clear the interrupt bit
--      elsif (count_enb='1' AND max='1') then
        elsif (max='1') then
          ctl(7) <= '1'; -- set interrupt when max reached
        end if;
        if (sel='1' and write='1' and addr="010") then
          ctl(0) <= datain(0); -- clear the interrupt bit
--      elsif (count_enb='1' AND max='1' AND ret='0') then
        elsif (max='1' and ret='0') then
          ctl(0) <= '0'; -- disable RUN when max reached if RET not set.
        end if;
        if (ctr=maxa and ctl(3)='1') then
          ctl(5) <= '1'; -- switch to MAXB
        elsif (ctr=maxb) then
          ctl(5) <= '0'; -- switch to MAXA
        end if;

      end if;	-- reset
    end if;	-- clk'event
  end process;

-- count_enb is high when the counter is supposed to count
  count_enb <= '1' when 	-- run the counter when
               (run='1' and 	-- enabled to RUN
                pre_ctr="00000000" and -- pre counter is done
                (ext='0' or -- internal
                 (ext='1' and ext_enb='1'))) -- external
               else '0';

-- MAX is high when we've reached the desired MAX register value
  max <= '1' when run='1' and 
         (((ctl(5)='0' or ctl(3)='0') and ctr=maxa) or 
          (ctl(5)='1' and ctr=maxb))
         else '0';

  interrupt <= ctl(7) and ctl(6);
  pwm <= ctl(5);
  ret <= ctl(4);
  ext <= ctl(1);
  run <= ctl(0);

end rtl;
