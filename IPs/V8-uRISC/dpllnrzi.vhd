--------------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: dpllnrzi.vhd	Digital PLL with NRZI decode and clock enable generator.
--
-- Revision: $Name: REV9911b $
--
-- Description:
-- This is a Digital Phase Locked loop that extracts data and clock
--	from the incoming NRZI encoded DATAIN signal. DATAIN should be
--	a sharp, noise-free signal. It should come from an input
--	buffer with plenty of hysteresis. The CLK signal input to this
--	block must be 4X the data rate of of the serial stream. The
--	Phase locked clock enable sigal (UCLK_EN) is always high for
--	one CLKs and may be low from 2 to 4 CLK

--  If DATAIN has noise on it, the DPLL will constantly run in "early"
--  mode with UCLK_EN high for 1 CLK and low for 2.  DATAOUT
--  transitions 1 CLK after UCLK_EN pulse. This allows plenty of hold
--  time for DATAOUT relative to the clock enabled edge.

-- The USB DPLUS and DMINUS differential signals are processed here
-- to insure clean and correct Single Ended Zero (SE0) and EOP detection.
-- If this code is used in a slow speed device, then the EOP detection
-- logic will need to have the DPLUS and DMINUS polarities reversed.
-- DPLUS and DMINUS must be low for 2 48Mhz clocks before a SE0 is recognized.
--
-- When a SE0 is detected, transistions on the DATAIN signal are ignored.
-- This keeps the PLL locked during the SE0 when it is probable that
-- the DATAIN line will be noisy when used with a simple Differential
-- OPAMP. This is because both inputs to the OPAMP will be close to ground.

-- Theory of Operation:

-- The PLL looks at K to J transition on the incoming data stream and adujusts
--	the CLKEN_DPLL signal so that the transitions are centered between
--	enable pulses. Because of the USB signal transition skew specification,
--	and the USB hub idle to K timing specification only K to J signal
--	transitions will be used.  The PLL is built using a 4 bit shift register
--	which is shifting at the incoming 4X oversampling clock CLK. This shift
--	register is free running and develops 4 phases of CLKEN_DPLL. Another 4
--	bit shift register is used to select which of the 4 phases we want.  The
--	phase of CLKEN_DPLL is adjusted only on the 2nd CLK when CLKEN_DPLL is
--	is low. Under normal operation CLKEN_DPLL is low for 3 cycles then high
--	for one cycle. If a transition has been detected earlier than expected,
--	then the next UCLK_EN will be low for only two CLKs. If a transition is
--	detected during the late window, then UCLK_EN low for 4 CLKs before the
--	next enable. If the transition is in the proper place or there was no
--	transition, then no adjustments are made to the phase.

--
-- Timing Diagram:
--	If a transition is detected during clocks 1 or 2, then it is early
--	and our next CLKEN_DPLL will be low for only 2 CLKs. If a transition
--	occurs during clock 7, then it is late and the next CLKEN_DPLL will
--	be low for 4 CLKs. Note that CLKEN_DPLL is alway high for 1 CLK and
--	low for 2 to 4 CLKS.
--
--          __   1__   2__   3__   4__   5__   6__   7__   8__   9__  10__  11__
-- CLK     |  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |
--                 _____                   _____                   _____
-- SHIFTER(3) ____/     \_________________/     \_________________/     \________
--                       _____                   _____                   _____
-- SHIFTER(2) __________/     \_________________/     \_________________/     \__
--                             _____                   _____                    __
-- SHIFTER(1) ________________/     \_________________/     \__________________/
--            ____                   _____                   _____
-- SHIFTER(0)     \_________________/     \_________________/     \_______________
--                 _____                         ______            _____
-- PHASE   _______/     \___________X___________/      \__________X     \_________
--                       ___________                    __________
-- EARLY_WINDOW ________/           \__________________/          \_______________
--                 _____                         ______            _____
-- LATE_WINDOW ___/     \___________X___________/      \__________X     \_________
--             ___      ________________________________          ________________
-- K_TO_J_TRANS___XXXXXX________________________________XXXXXXXXXX________________
--         ________Late____________________________________Early__________________
-- STATE   __________________3______X___________2_________________X______3________
--
-- CLKEN_DPLL output:
--      The CLKEN_DPLL clock enable output from the the DPLL is intented to be
--      used as a clock enable signal used in conjunction with the 48MHz input
--      clock to clock the registers in the VUSB design.  It can, however, be
--      used directly as a clock to the the VUSB.  The Clock enable is alligned
--      with the dataout, seo and eop signals to select a 48MHz rising edge
--      that is centered in the data.  As a result the rising edge of the clock
--      enable falls less than one 48MHz cycle before the center of any data
--      transitions.
--
-- NRZI encoding:
-- 	NRZI encoding is a popular method of encoding serial data
--	in relatively noise-free environments. The basic concept is that
--	every time a 0 is transmitted, the state of the line is reversed.

-- RESET: Note that CLKEN_DPLL is active while RESET is asserted. Typically
--	RESET is connected to the DPLL from a power-on-reset cell. Alternatively
--	the reset sent to circuitry clocked by CLKEN_DPLL must be stretched for
--	some number of CLKEN_DPLL pulses.

-- Signals ending in _n are active low.
--
--------------------------------------------------------------------------------
-- This product is licensed to:
-- ÇÑÈ«¼· of ÅÂÀÎ½Ã½ºÅÛ
-- for use at site(s):
-- tsi
--------------------------------------------------------------------------------
-- Revision History
-- $Log: dpllnrzi.vhd,v $
-- Revision 1.42  2000/01/19 19:58:09  mark
-- * removed 'verbose' signal - no longer used
--
-- Revision 1.41  2000/01/19 19:43:47  mark
-- yanked out extraneous comments
--
-- Revision 1.40  2000/01/19 19:41:42  mark
-- * commented out assert statements
--
-- Revision 1.39  2000/01/03 16:25:54  chris
-- Changed host_wo_hub from a generic to a signal.
-- Changed architecture name to rtl.
--
-- Revision 1.38  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.37  1999/11/09 14:14:22  mark
-- ulogicified source - no functional changes
--
-- Revision 1.36  1999/11/02 20:56:04  chris
-- Added ASCII schematic.
--
-- Revision 1.35  1999/11/01 13:21:13  chris
-- Added logic to sample the dpll inputs at the falling edge of clock
-- inorder to increase the DPLL's tolerance to jitter and frequency
-- variation (See the table at the end of the file).
--
-- Revision 1.34  1999/09/15  21:01:36  gregg
-- Fixed dpll_clk_en for conversion to verilog and gate level simulations
--
-- Revision 1.33  1999/09/13 20:28:07  chris
-- Added host_wo_hub generic for host without hub to allow different
-- instances of the vusb core to set the constant differently.
--
-- Revision 1.32  1999/09/10 21:52:51  chris
-- Changed low speed signalling to allow the host speed to switch on the
-- fly to support low speed devices thru a hub.
--
-- Revision 1.31  1999/06/24 12:23:38  chris
-- Added generic lsdev to support dynamic Low to Full speed switching.
-- Fixed keyword case and indentation for readability.
--
-- Revision 1.30  1999/01/28 22:32:39  chris
-- Added eop_48_out signal to perform async clear
-- function in HUB.
--
-- Revision 1.29  1998/12/03 10:47:56  chris
-- Qualified the SE0 sampling with an SE0 pulse width of at least
-- two samples.
--
-- Revision 1.28  1998/11/20 17:40:03  chris
-- Fixed reset polarity on datain filter.
--
-- Revision 1.27  1998/11/20 16:28:45  chris
-- Added one more cycle of reset delay on transition filter.
-- Added reset filter on datain to supress X's on input.
--
-- Revision 1.26  1998/11/20 15:15:49  chris
-- Reordered synopsys syn_set_reset comment so it would survive translation to verilog.
--
-- Revision 1.25  1998/11/17 21:55:48  chris
-- Recoded processes using synopsys style synchronous reset syntax.
--
-- Revision 1.24  1998/10/12 14:38:21  chris
-- Added more robust metability protection.
-- Cleaned up the EOP detection to decouple the detection from the
--   phase lock loop function.
-- Removed a layer of synchronization uncertainty from the EOP detects
--   that are provided to the Hub logic.
--
-- Revision 1.23  1998/08/31 20:06:06  chris
-- Added a 20ns delay to sie_eop_out to move that pulse farther away from the SE0 to J
-- transition on the bus.
--
-- Revision 1.22  1998/08/18 20:59:30  chris
-- Combined sie_eop_out input into fseop_det, and synchronized it to the 12MHz
-- clock domain.
--
-- Revision 1.21  1998/07/30 09:25:43  chris
-- Fixed Low Speed EOP detection.
--
-- Revision 1.20  1998/07/20 16:39:41  chris
-- Add 1 additional clock delay to reset_after_clks to support verilog.
--
-- Revision 1.19  1998/07/17 15:49:19  eric
-- Added the flops to hold SE0 active until we have output a couple of clocks after reset.
-- Get Xes fed in via dplus/dminus without these.
--
-- Revision 1.18  1998/06/23 19:43:17  chris
-- Added logic for Low Speed EOP detection.
--
-- Revision 1.17  1998/05/29 18:07:02  chris
-- Added signals for hub.
--
-- Revision 1.16  1998/04/24 00:58:37  gregg
-- Added Synopsys reset attributes
--
-- Revision 1.15  1998/03/26 21:12:55  chris
-- Stubbed out low speed support.
-- Centered rising edge of the clock enable pulse in the output siganls.
--
-- Revision 1.14  1998/03/13 22:26:19  chris
-- Added support for low speed single port root hub.
--
-- Revision 1.13  1997/11/20 14:21:05  chris
-- Added synchronized reset generation logic.
--
-- Revision 1.12  1997/10/31 21:00:19  chris
-- Rewritten to support clock enable pulses.
--
-- Revision 1.11  1997/05/21 15:55:48  eric
-- fixed the EOP pipelining of DPLUS and DMINUS...
--
-- Revision 1.10  1997/05/21 14:57:29  eric
-- Aligned se0 with the data, se0 had 1 extra pipe stage in it which caused
-- det_se0 to come out 1 bit late in some cases.
--
-- Revision 1.9  1997/05/16 03:12:23  eric
-- Inverted reset_f so the DPLL will start after config in a xilinx FPGA.
--
-- Revision 1.8  1997/05/10 03:22:12  eric
-- Added EOP.
--
-- Revision 1.7  1997/05/09 16:42:35  eric
-- Added SE0 output.
--
-- Revision 1.6  1997/04/02 20:46:41  eric
-- Incorrect data when DATAIN is asymetric causing pairs of late/early - fixed.
--
-- Revision 1.5  1997/03/21 14:03:36  eric
-- Changed to 4 bit DPLL and removed resetout.
--
-- Revision 1.4  1997/03/03 12:43:17  gregg
-- Move reset counter external to DPLL
--
-- Revision 1.2  1997/02/21 22:09:44  eric
-- RESET now runs thru the DPLL so the clockout will run while reset asserted.
--
-- Revision 1.1  1997/02/06 12:33:09  chris
-- Initial revision
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;	-- we use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;
-- USE ieee.std_logic_arith.ALL;	-- we use the IEEE standard 1164 arithmetic
USE work.cfg_usb.ALL; -- VUSB synthesis and simulation configuration constants.

ENTITY dpllnrzi IS
  GENERIC(
    lsdev       : integer := LOW_SPEED_DEV);     -- see cfg_usb
  PORT(
    clk      : IN  std_ulogic;  -- high speed clock - 4x data rate
    datain   : IN  std_ulogic;  -- NRZI encoded serial data/clock in
    dplus    : IN  std_ulogic;  -- USB positive data
    dminus   : IN  std_ulogic;  -- USB negative data
    reset    : IN  std_ulogic;  -- reset the PLL. CLKEN_DPLL stops.
    low_speed_en: IN std_ulogic;-- USB speed control
    host_wo_hub : IN std_ulogic;-- USB host without hub
    clken_dpll: OUT std_ulogic; -- clock enable output
    clken_12 : OUT std_ulogic;  -- fixed clock divided by 4 clock enable.
    dataout  : OUT std_ulogic;  -- NRZ serial data out
    eop      : OUT std_ulogic;  -- End Of Packet detected
    rcvout   : OUT std_ulogic;  -- synchronized jstate signal
    se0      : OUT std_ulogic; -- single ended zero out
    sie_eop_out  : IN  std_ulogic;  -- SIE generated an EOP
    eop_48_out   : OUT std_ulogic;  -- 48 MHz based EOP clear pulse to HUB
    lseop_det    : OUT std_ulogic;  -- Low Speed EOP detected
    fseop_det    : OUT std_ulogic;   -- Full Speed EOP detected
    out180       : OUT std_ulogic    --
  );
END dpllnrzi;

ARCHITECTURE rtl OF dpllnrzi IS ----------------Architecture rtl-----------

SIGNAL check_sync	: std_ulogic;	-- time to check if we are in sync
SIGNAL clk12_cnt: std_ulogic_vector(2 DOWNTO 0);-- clock divide by 8 counter.
SIGNAL clk_slow_en : std_ulogic; -- clock divided by 8 (single pulse)
SIGNAL clkneg_slow_en : std_ulogic; -- clock divided by 8 (single pulse)
SIGNAL clken_12l : std_ulogic; -- clock divided by 4 local copy
SIGNAL datain_f      : std_ulogic;       -- synchronization register
SIGNAL datain_ff     : std_ulogic;       -- synchronization register
SIGNAL datain_delayed   : std_ulogic;       -- synchronization register
SIGNAL datain_delayed_f : std_ulogic;       -- synchronization register
SIGNAL datain_delayed_ff: std_ulogic;       -- synchronization register
SIGNAL dataoutl         : std_ulogic;	-- local versions
SIGNAL dminus_f, dminus_ff, dminus_fff : std_ulogic; -- Data synchronizers
SIGNAL dminus_late_f, dminus_late_ff : std_ulogic; -- Data synchronizers
SIGNAL dpll_clk_en :std_ulogic;-- DPLL input clock enable
SIGNAL dpll_clkneg_en :std_ulogic;-- DPLL input clock enable
SIGNAL dplus_f, dplus_ff, dplus_fff : std_ulogic;  -- Data synchronizers
SIGNAL dplus_late_f, dplus_late_ff : std_ulogic;  -- Data synchronizers
SIGNAL early	: std_ulogic;	-- flag indicating the transition was early
SIGNAL early_window : std_ulogic;-- timing window for detecting early transitions
SIGNAL eopl : std_ulogic;	-- local version
SIGNAL eop_dpll     : std_ulogic;                -- EOP held for DPLL clock
SIGNAL eop12        : std_ulogic;                -- EOP held for 12MHz clock
SIGNAL eop12_d      : std_ulogic;                -- EOP detect flop input
SIGNAL eop_48_ff    : std_ulogic;                -- delayed eop detect registers
SIGNAL eop_48_f     : std_ulogic;                -- for eop_48_out construction
SIGNAL eop_48       : std_ulogic;

SIGNAL j_delayed_in_ff,j_delayed_in_fff,
       j_delayed_in_ffff : std_ulogic; -- Data synchronizers
SIGNAL j_state_in_ff,j_state_in_fff,
       j_state_in_ffff : std_ulogic; -- Data synchronizers
SIGNAL k_to_j_trans : std_ulogic;	-- K to J transistion on DATAIN
SIGNAL k_to_j_trans_dly : std_ulogic;	-- K to J transistion on DATAIN
SIGNAL out180_window : std_ulogic;-- timing window for detecting 180 degree
SIGNAL last_was_early: std_ulogic;       -- record direcion of last adjustment
SIGNAL late	: std_ulogic;	-- flag indicating the transition was late
SIGNAL late_window : std_ulogic;-- timing window for detecting late transitions
SIGNAL low_speed_signaling   : std_ulogic;-- USB speed signal
SIGNAL lseop_cnt   : std_ulogic_vector(2 DOWNTO 0); --  count for low speed eop
SIGNAL phase	: std_ulogic;	-- D input to the CLKEN DFF
SIGNAL phase_f, phase_ff, phase_fff : std_ulogic;   -- flopped version of phase
SIGNAL pre_data: std_ulogic;	-- data before clocked with clken_dpll
SIGNAL rcvoutl  : std_ulogic;    -- local version
SIGNAL reset_f, reset_ff: std_ulogic;	-- synchronizers
SIGNAL reset_after_clks,reset_after_clks_f,reset_after_clks_ff,
       reset_after_clks_fff,reset_after_clks_ffff : std_ulogic; -- delayed reset
SIGNAL se0_blanking : std_ulogic; -- Single Ended Zero synchronizers
SIGNAL se0_ff     : std_ulogic;   -- Single Ended Zero synchronizers
SIGNAL se0_fff, se0_ffff, se0_fffff : std_ulogic; -- Single Ended Zero synchronizers
SIGNAL se0_late_ff, se0_late_fff : std_ulogic;   -- Single Ended Zero synchronizers
SIGNAL se0l             : std_ulogic;	-- local versions
SIGNAL shifter : std_ulogic_vector(3 DOWNTO 0); -- 4 phase clock generator
SIGNAL shifter_d : std_ulogic_vector(3 DOWNTO 0); -- D inputs to SR flops.
SIGNAL sie_eop_out_f : std_ulogic; -- register for end of packet indicaition form the SIE
SIGNAL state   : std_ulogic_vector(3 DOWNTO 0); -- selects which phase we want
SIGNAL state_d : std_ulogic_vector(3 DOWNTO 0); -- D inputs to SR flops.
SIGNAL transition   : std_ulogic;	-- any transistion on DATAIN
signal very_early_transition : std_ulogic;
signal very_late_transition : std_ulogic;
signal very_late_transition_f : std_ulogic;
-- The following line is used when translating to Verilog...
-- synopsys sync_set_reset "reset_ff"

ATTRIBUTE sync_set_reset : string;
-- Requires the sync_set/reset attribute to insure no Xes in simulation
ATTRIBUTE sync_set_reset OF reset_ff : SIGNAL IS "true";  -- Required for synopsys

BEGIN	----------------------------------------------------------------------

-- use low speed signalling
low_speed_signaling <= '1' WHEN lsdev = 1 ELSE
                       low_speed_en WHEN host_wo_hub = '1' else
            -- If this is a low speed device, or it is a high speed device that
            -- is transmitting a low speed packet directly to a low speed
            -- device without an interviening hub then invert the j/k state
            -- polarity.
                       '0';
k_to_j_trans <= (NOT j_state_in_ffff AND j_state_in_fff)  -- K to J transition
		                                          -- detected on datain.
	AND NOT se0_blanking;	-- ignore transitions into and out of SE0.
se0_blanking <= (se0_ff AND se0_fff) OR (se0_fff AND se0_ffff) OR se0l;

transition <= (j_state_in_ffff XOR j_state_in_fff) -- transition
                        -- detected on datain.
	AND NOT se0l;	-- ignore transitions out of SE0.

shifter_d <= shifter(0) & shifter(3 DOWNTO 1); -- normally we just shift


state_d <= state(2 DOWNTO 0) & state(3)
          WHEN early='1' OR (k_to_j_trans and not k_to_j_trans_dly) = '1'
	ELSE state(0) & state(3 DOWNTO 1)
          WHEN late='1'OR (k_to_j_trans and k_to_j_trans_dly) = '1'
	ELSE state;

phase <= (shifter(0) AND state(0)) OR	-- select phase
         (shifter(1) AND state(1)) OR
         (shifter(2) AND state(2)) OR
         (shifter(3) AND state(3));

early_window <=  phase_fff; -- and the check_sync time
late_window  <=  phase_f;
check_sync   <=  phase_ff;

out180_window <= phase_ff;
out180 <= out180_window and k_to_j_trans;

dataout <= dataoutl; -- connect local copies to outputs
se0	<= se0l;
eop	<= eopl;
rcvout  <= rcvoutl;
clken_12 <= clken_12l;

dpll_clk_en <= reset or clk_slow_en or not low_speed_en;
dpll_clkneg_en <= reset or clkneg_slow_en or not low_speed_en;

--vasync_rst flops_rst:PROCESS (clk,reset_ff)
flops_rst:PROCESS (clk) --vsync_rst
BEGIN
--vasync_rst  if reset_ff = '1' then
IF clk'event AND clk='1' THEN      --vsync_rst
  IF reset_ff = '1' THEN           --vsync_rst
    shifter   <= "1000";
    state     <= "1000";
    early     <= '0';
    late      <= '0';
    eop_dpll  <= '0';
    pre_data  <= '0';
    dataoutl  <= '0';
    eopl      <= '0';
    se0l      <= '1';
    rcvoutl   <= '0';
    eop12     <= '0';
  ELSE --vsync_rst
--vasync_rst   elsif clk'event and clk = '1' then

    IF dpll_clk_en = '1' THEN

      shifter <= shifter_d;           --  4 phase free running clock

      IF (check_sync='1') THEN	    -- select which phase we want
	state <= state_d;             -- using the state register

      END IF;

      IF (check_sync='1') THEN
	early <= (k_to_j_trans and not k_to_j_trans_dly);
      ELSIF early_window = '1' THEN
	early <= early OR k_to_j_trans;
      END IF;

      IF (check_sync='1') THEN
	late <= '0';
      ELSIF (late_window='1') THEN
     	late <= k_to_j_trans;
      END IF;

      -- Capture the EOP event for the DPLL clock domain  3 cycles of SE0
      -- followed by a J-state.
      IF late_window = '1' THEN
	eop_dpll <= ((dplus_ff AND NOT low_speed_signaling) OR -- full speed J-state
		     (dminus_ff AND low_speed_signaling)) AND  -- low speed J-state
		    (se0_fff AND se0_ffff AND se0_fffff);      -- 3 cycles of SE0
      ELSE
	eop_dpll <= eop_dpll OR            -- hold till next late window
		    (((dplus_ff AND NOT low_speed_signaling) OR -- full speed J-state
		      (dminus_ff AND low_speed_signaling)) AND  -- low speed J-state
		     (se0_fff AND se0_ffff AND se0_fffff));     -- 3 cycles of SE0
      END IF;


      -- Capture any transitions that occure between this late window and the next.
       IF reset_after_clks_fff = '1' OR (late_window='1') THEN -- preset the pre-data bit,
 	pre_data <= '1';
       ELSIF (transition and not very_late_transition_f) ='1' THEN
 	-- if there is a transition, then the bit is a 0.
 	pre_data <= '0';
       END IF;

      IF reset_after_clks_ffff = '1' THEN
	dataoutl <= '0';
	eopl <= '0';
	se0l <= '1';	-- force se0 to ignore D+/D- until stable
	rcvoutl <= '0';
      ELSIF (late_window='1') THEN
	dataoutl <= pre_data AND NOT transition   -- a late transition or a very
                    and not very_late_transition; -- late transition means the data
                                                  -- bit is a zero
	-- An eop is detected if 3 cycles of se0 are followed by a J-state
	eopl <= eop_dpll;
	se0l <= (se0_late_ff AND se0_late_fff) OR (se0_ff AND se0_fff) OR (se0_fff AND se0_ffff);
	rcvoutl <= j_state_in_fff;
      ELSE
	dataoutl <= dataoutl;
	eopl <= eopl;
	se0l <= se0l;
	rcvoutl <= rcvoutl;
      END IF;

      IF clken_12l = '1' THEN
	eop12 <= eop12_d;
      ELSE
	eop12 <= eop12 OR eop12_d;         -- hold until seen in the 12MHz clock domain.
      END IF;
    END IF;

  END IF; -- reset  --vsync_rst
END IF; -- clk / reset
END PROCESS flops_rst;

eop12_d <= (dplus_ff AND se0_fff AND se0_ffff AND se0_fffff) OR
           sie_eop_out_f;

flops:PROCESS (clk)-- create the flip-flops that don't need reset.
BEGIN
  IF clk'event AND clk='1' THEN
    IF dpll_clk_en = '1' THEN

      phase_fff    <= phase_ff;
      phase_ff     <= phase_f;
      phase_f      <= phase;
      clken_dpll   <= phase;

      -- Pass the EOP indication into the clken_12 domain
      sie_eop_out_f <= sie_eop_out;        -- delay the eop indication from the
                                         -- SIE for one clock.
      -- Create a two clock wide pulse delayed 2 clocks from the rising edge of
      -- eop12
      eop_48_out <= (eop_48 AND NOT eop_48_f) OR
		    (eop_48_f AND NOT eop_48_ff);
      eop_48_ff  <= eop_48_f;
      eop_48_f   <= eop_48;
      eop_48     <= eop12;

      -- Synchronize the DATAIN signal to remove metastability.
      j_state_in_ffff <= j_state_in_fff; -- Fourth stage synchronizer
      j_state_in_fff <= j_state_in_ff; -- Third stage synchronizer
      datain_ff  <= datain_f;  -- Second stage synchronizer
      datain_f   <= datain     -- First stage synchronizer
                  OR reset_after_clks_ffff; -- filtered with reset

      -- Synchronize the D+ and D- to remove metastability.
      dplus_fff   <= dplus_ff;
      dplus_ff    <= dplus_f;
      dplus_f	<= to_x01(dplus);

      dminus_fff  <= dminus_ff;
      dminus_ff   <= dminus_f;
      dminus_f	<= to_x01(dminus);

      se0_fffff   <= se0_ffff;             -- Save some history on se0 so that
      se0_ffff    <= se0_fff;              -- a detect circuit can be
					   -- impelemented for either clock enable.
      reset_ff  <= NOT reset_f;	-- Inverting helps the FPGA reset after config
      reset_f   <= NOT reset;	-- since all flops init to zero.

    ELSE

      clken_dpll <= '0';

    END IF;                                -- clock enable
  END IF;                                  -- clock = '1'
END PROCESS;

  j_state_in_ff <=  datain_ff XOR low_speed_signaling;
  se0_ff        <=  NOT dplus_ff  AND NOT dminus_ff;
  se0_fff       <=  NOT dplus_fff AND NOT dminus_fff;


--vasync_rst fixed_frequency: PROCESS (clk,reset_ff)
fixed_frequency: PROCESS (clk) --vsync_rst

BEGIN -- fixed_frequency
--vasync_rst  IF reset_ff = '1' then
  IF clk'event AND clk= '1' THEN --vsync_rst
    IF reset_ff = '1' THEN       --vsync_rst
      clk12_cnt <= "000";
      clk_slow_en <= '0';
      lseop_cnt <= "000";
      fseop_det <= '0';
      lseop_det <= '0';
      clken_12l <= '0';
    ELSE--vsync_rst
--vasync_rst   ELSIF clk'event and clk = '1' then
      clk12_cnt <= std_ulogic_vector(unsigned(clk12_cnt) + 1);
      IF clk12_cnt(1 DOWNTO 0) = "11" THEN
        clken_12l <= '1';
      ELSE
        clken_12l <= '0';
      END IF;
      IF clk12_CNT = "111" THEN
	clk_slow_en <= '1';
      ELSE
	clk_slow_en <= '0';
      END IF;
      IF clk12_CNT = "011" THEN
	clkneg_slow_en <= '1';
      ELSE
	clkneg_slow_en <= '0';
      END IF;
      --  12MHz stuff
      IF clken_12l = '1' THEN
        IF se0_ff = '1' THEN
          IF lseop_cnt /= "101" THEN
            lseop_cnt <= std_ulogic_vector(unsigned(lseop_cnt) +1);
          END IF;
        ELSIF se0_fffff = '0' AND eop12 = '0' THEN
          lseop_cnt <= "000";
        END IF;
        fseop_det <= eop12;
        IF eop12 = '1' AND (lseop_cnt = "101") THEN
          lseop_det <= '1';
        ELSE
          lseop_det <= '0';
        END IF;
      END IF; -- clken_12l
    END IF;   -- reset  --vsync_rst
  END IF; -- clk / reset

END PROCESS fixed_frequency;

--vasync_rst rst_vauto:PROCESS (clk,reset_ff)-- create the reset DFFs
rst_vauto:PROCESS (clk)                  -- vsync_rst
-- create the reset DFFs
-- These flops hold the DPLL in SE0 which in turn ignores D+/D-
-- for 3 bit times which allows these lines to stablize.
-- Without this, you often get Xes in the gate level simulations.
BEGIN
--vasync_rst  IF reset_ff = '1' then
  IF clk'event AND clk='1' THEN          -- vsync_rst
    IF reset_ff='1' THEN                 -- vsync_rst
    	reset_after_clks <= '1';
    	reset_after_clks_f <= '1';
    	reset_after_clks_ff <= '1';
    	reset_after_clks_fff <= '1';
    	reset_after_clks_ffff <= '1';
    ELSE                                 -- vsync_rst
--vasync_rst  ELSIF clk'event and clk = '1' then
      IF clk12_cnt(1 DOWNTO 0) = "11" THEN
    	reset_after_clks_ffff <= reset_after_clks_fff;
    	reset_after_clks_fff <= reset_after_clks_ff;
    	reset_after_clks_ff <= reset_after_clks_f;
    	reset_after_clks_f <= reset_after_clks;
    	reset_after_clks <= reset_ff;
      END IF; -- clk12_cnt
    END IF;                              -- vsync_rst
  END IF; -- clk/reset
END PROCESS rst_vauto;



-- The logic below this point has been added to increase the jitter
-- tolerance of the phase lock loop beyond the +/-9ns paired edge jitter
-- specification in the USB 1.1 specification.  This logic requires 3 negitive
-- edge triggered flip flops to gain additional resolution on the position of
-- an incomming transition relative to the current DPLL output clock.

-- Because These negative edge flops may cause a problem for automatic
-- test insertion or other areas of your tool chain we have grouped
-- the logic together so that it maybe easily removed from your
-- design. This logic may be removed by uncommenting the following 4
-- lines, and then commenting out or deleteting the lines between
-- "JITTER HARDENNING REMOVE ON" and "JITTER HARDENNING REMOVE OFF"

-- k_to_j_trans_dly <= '0'; -- treat the 180 out of sync window as
-- very_late_transition <= '0'; -- a second early window.
-- very_late_transition_f <= '0'; -- a second early window.
-- se0_late_ff <= '0'; se0_late_fff <= '0';

-- The following ASCII schematic shows the connections to and from the negative
-- edge flip flops.
--
--                        -----                  -----
--                       |     |                |     |
--              dplus    |     |  dplus_late_f  |     | dplus_late_ff
--         +-------------|     |----------------|     |---------------
--         |             | neg |                | pos |
--         |         +--o> clk |            +---> clk |
--         |         |    -----             |    -----
--         |   clk   |                      |
--         |         +----------------------+
--         |         |
-- vp | \  |         |    -----                  -----
-- ---|+ \-+         |   |     |                |     |
--    |   \  datain  |   |     | datain_delayed |     | datain_delayed_f
--    |    >-------------|     |----------------|     |------------------
-- vm |   /          |   | neg |                | pos |
-- ---|- /-+         +--o> clk |            +---> clk |
--    | /  |         |    -----             |    -----
--         |   clk   |                      |
--         |         +----------------------+
--         |         |
--         |         |    -----                  -----
--         |         |   |     |                |     |
--         | dminus  |   |     | dminus_late_f  |     | dminus_late_ff
--         +-------------|     |----------------|     |----------------
--                   |   | neg |                | pos |
--                   +--o> clk |            +---> clk |
--                   |    -----             |    -----
--  clk              |                      |
-- ------------------+----------------------+
--                   
-- dplus, dminus and datain should come directly from the USB
-- transciver I/O cells.
--
-- This table characterizes the performance of the DPLL under ideal (unit delay
-- simulation) conditions to random jitter on paired transitions of the inputs
-- to the DPLL for the DPLL design with and without the addition of the jitter
-- hardenning logic.
-- Note: The USB specification for Jitter is +/-9ns with a frequency tollerance
-- of +/-209 ps per bit for the paired transitions that are used to adjust the
-- DPLL. No time budget has been made for the analog receiver circuits in this
-- analysis.

-- Total JITTER  Frequency Tolerance Frequency Tolerance
--               Unimproved Design   Jitter Hardenned design
--  ----------       ----------          ----------
--   +/-  0 ns       +/- 1.4 ns          +/- 1.4 ns
--   +/-  5 ns       +/- 800 ps          +/- 1.4 ns
--   +/-  9 ns       +/- 210 ps          +/- 800 ps
--   +/- 10 ns       +/-   0 ps          +/- 700 ps
--   +/- 11 ns    can not track          +/- 600 ps
--   +/- 12 ns    can not track          +/- 400 ps
--   +/- 13 ns    can not track          +/- 200 ps
--   +/- 14.75 ns can not track          +/- 100 ps
--

--JITTER HARDENNING REMOVE ON
k_to_j_trans_dly <= (NOT j_delayed_in_ffff AND j_delayed_in_fff);  -- K to J
                 -- transition present on faling edge of clock prior to transition

very_late_transition <= (j_state_in_fff XOR j_state_in_ff) and  -- transition
                        (j_delayed_in_fff XOR j_delayed_in_ff) and  -- in the
                        late_window; -- late window or the half cycle after it.

very_early_transition <= k_to_j_trans and not k_to_j_trans_dly and check_sync;
-- This signal is not used but can be displayed in simulation to watch for
-- early adjustments in the 180 degree out of phase window.

jitter_flops:PROCESS (clk)-- create the flip-flops that don't need reset.

BEGIN
IF clk'event AND clk='1' THEN
IF dpll_clk_en = '1' THEN
 -- DATAIN delayed has been sampled on the neitive edge of clock.
      j_delayed_in_ffff <= j_delayed_in_fff;   -- Fourth stage synchronizer
      j_delayed_in_fff <= j_delayed_in_ff;     -- Third stage synchronizer
      datain_delayed_ff  <= datain_delayed_f;  -- Second stage synchronizer
      datain_delayed_f   <= datain_delayed     -- First stage synchronizer
                  OR reset_after_clks_ffff;    -- filtered with reset


se0_late_fff <= se0_late_ff;  -- used to capture late SE0 events.
      dplus_late_ff  <= dplus_late_f;
      dminus_late_ff <= dminus_late_f;

very_late_transition_f <= very_late_transition;

END IF;  -- clock enable
  END IF;                                  -- clock = '1'
END PROCESS;

neg_flop:PROCESS (clk)-- create the negative edge flip-flop
BEGIN
IF clk'event AND clk='0' THEN
IF dpll_clkneg_en = '1' THEN
datain_delayed <= datain;
dplus_late_f <= to_x01(dplus);
dminus_late_f <= to_x01(dminus);
END IF;  -- clock enable
  END IF;                                  -- clock = '1'
END PROCESS;

j_delayed_in_ff <= datain_delayed_ff XOR low_speed_signaling;
se0_late_ff <= NOT dplus_late_ff AND NOT dminus_late_ff;

--JITTER HARDENNING REMOVE OFF

END rtl;
