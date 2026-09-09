-------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: usb_sie.vhd    VAutomation USB Serial Interface Engine
--
-- Revision: $Name: REV9911b $
--
-- Description:
--  Synthesizabe VHDL description implementing the USB Serial Interface
--  Engine (SEI). 
--  
--
-- Block Diagram:
--

-- Revision History
-- $Log: usb_sie.vhd,v $
-- Revision 1.97  2000/01/03 16:22:23  chris
-- Changed host_wo_hub from a generic to a signal.
-- Changed architecture name to rtl.
--
-- Revision 1.96  1999/11/15 20:01:18  gregg
-- Fixed NAK response during a SETUP token if bus_gnt lost during
-- data phase. Also change dma_err_set for FIFO overflow and
-- underflow conditions
--
-- Revision 1.95  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.94  1999/11/09 14:17:33  mark
-- ulogicified source - no functional changes
--
-- Revision 1.93  1999/11/05 13:56:35  mark
-- fixed 'reject_rx_dat_set' assertion condition - should be '/= PID_SETUP'
--
-- Revision 1.92  1999/10/22 15:22:33  chris
-- Changed bts_err_set so that the idle state on the bus would not be
-- reported as a bit stuff error while waiting for a sync pulse in the
-- TOK_SYNC state.
--
-- Revision 1.91  1999/10/11 18:30:41  mark
-- updated EMBEDDED HOST ADD section to drive 'low_speed_en'.  Need
-- to drive this else usb dev mode dies.
--
-- Revision 1.90  1999/09/17 15:29:29  chris
-- Added term to ser2par_rg_d to prevent false syncs.
--
-- Revision 1.89  1999/09/15 19:35:12  chris
-- Removed reduntant assignments to low_speed_en and hc_ls_timing_set.
-- Cleaned up sensitivity lists and unused signals.
--
-- Revision 1.88  1999/09/15 14:39:38  chris
-- Changed hc_ls_timing_clr to cause a PRE_PID to be generated when
-- sending a RXD_HSHK transmit packet (IN token ACK, NAK or STALL) to a
-- low speed device.
--
-- Revision 1.87  1999/09/13 20:22:45  chris
-- Added host_wo_hub generic to allow host without hub to be set
-- individually for each vusb core is a simulation.
--
-- Revision 1.86  1999/09/10 21:51:12  chris
-- Added logic to support Low speed devices thru a hub.
--
-- Revision 1.85  1999/08/11 00:27:52  chris
-- Added hc (host control) reset to reset the state machines when host
-- mode is entered or exited.
--
-- Revision 1.84  1999/07/30 21:16:51  chris
-- Added support for SOF timer function for LS host.
-- Fixed bug with Frame number loading.
--
-- Revision 1.83  1999/07/09 15:34:20  chris
-- Cut the response turnaround time by one cycle to give customers
-- 	more margin when running gate level simulation.
--
-- Revision 1.82  1999/07/02 14:30:29  chris
-- Fixed crc5_err_set by removing not TOK_EOP term from the ser2par_rg_se
--       equation.
-- Extended the range of the DFN8 error indication to cover any packet
--       that token, data or handshake that ends on a non-byte boundary.
--
-- Revision 1.81  1999/06/23 20:30:30  chris
-- Fixed signal exchange problems associated with low speed host operation.
--
-- Revision 1.80  1999/04/07 19:52:00  gregg
-- Modified output signal generation to use the low_speed_dev constant
-- to generate low speed signaling.
--
-- Revision 1.79  1999/01/28 22:07:07  chris
-- Added a cycle of delay to sie_eop_out to support tighter
-- connection tear down timing in the hub.
--
-- Revision 1.78  1999/01/13 20:15:11  chris
-- Changed clear pulse on SOF counter from the asynchronous mcek_cnt_clr to the
-- synchronized sof_cnt_clr. This effected the sleep interrupt generation.
--
-- Revision 1.77  1998/12/17 14:18:10  chris
-- Recoded inputs and outputs of hc_sof_cnt with the clock
-- enable crossings in mind.
--
-- Revision 1.76  1998/12/07 21:06:08  chris
-- Fixed width of hc_sof_cnt constant compare in frame_num_d equation.
--
-- Revision 1.75  1998/11/20 15:19:20  chris
-- Changed synopsys comment placement so it would survive translation to verilog.
--
-- Revision 1.74  1998/11/19 16:19:26  chris
-- Added synchronous reset term for own_ok_suspend.
--
-- Revision 1.73  1998/11/17 21:49:20  chris
-- Fixed vasync comment on rx_srst_regs process.
--
-- Revision 1.72  1998/11/13 20:53:20  chris
-- Fixed token busy.
--
-- Revision 1.71  1998/11/06 17:55:42  gregg
-- Added resume support for device and host controller modes
--
-- Revision 1.70  1998/11/06 08:27:00  chris
-- Added logic to make ISO packet tokens ignore the txd suspend signal.
--
-- Revision 1.69  1998/11/05 14:54:18  chris
-- Removed a cycle of delay from the BDT endpoint stall indication, so
-- that it would track the BDT OWN bit.
--
-- Revision 1.68  1998/11/03 11:25:44  chris
-- Added code to suspend any transfer type when txd_suspend is true.
-- Change assertion of txd_suspend to occur when a SETUP token is completed.
-- Added code to cause BDT's not to be cached when txd_suspend is true.
--
-- Revision 1.67  1998/10/21 18:30:57  gregg
-- Added suspend timer and sleep logic
--
-- Revision 1.66  1998/10/19 15:44:47  chris
-- Added hardware dequeuing and protocol stall support.
--
-- Revision 1.65  1998/10/12 14:35:18  chris
-- False bitstuff error detect at end of packet fix.
--
-- Revision 1.64  1998/08/31 14:17:20  chris
-- Added code to suppress the token done interrupt and BDT write,
-- but flush any remaining data at the end of packet if the KEEP bit is set.
--
-- Revision 1.63  1998/08/18 20:58:17  chris
-- Changed sie_eop_out output to assert for one cycle after the SE0 to J
-- transition.
--
-- Revision 1.62  1998/07/29 21:46:31  chris
-- Removed 8 cycle time limit in TOK_SYNC state to allow sync detection
-- even if the PLL adjusts short twice in response to a slow clock with a
-- phase shift.
--
-- Revision 1.61  1998/07/23 09:57:46  chris
-- Added acknowledge for token req and clr from up_int.
--
-- Revision 1.60  1998/07/21 17:14:12  chris
-- Recoded for synchronous reset.
--
-- Revision 1.59  1998/07/15 13:57:36  gregg
-- Updated HOST ADD for Makerelease
--
-- Revision 1.58  1998/06/23 18:45:47  chris
-- Moved SOF timer and associated logic to a fixed 12MHz clock enable.
--
-- Revision 1.57  1998/06/15 22:06:49  chris
--  Added syntax for Async or Sync reset inference.
--
-- Revision 1.56  1998/05/29 17:08:15  chris
-- Syntax error.
--
-- Revision 1.55  1998/05/29 16:37:36  chris
-- Added signals for VUSB Hub.
-- Added logic to support cancelling host tokens.
--
-- Revision 1.54  1998/05/22 13:45:54  chris
-- Fixed false BTS error generation during RXD_EOP.
--
-- Revision 1.53  1998/05/20 18:14:22  chris
-- Changed logic so ISO in tokens that BTO will be sent only once.
--
-- Revision 1.52  1998/05/20 13:03:18  chris
-- Fixed process sensitivity lists.
--
-- Revision 1.51  1998/05/06 21:26:17  chris
-- Fixed host bdt reread equation after rejected rx or tx packets.
--
-- Revision 1.50  1998/04/29 13:30:28  chris
-- Fixed bitstuff error detection on the last bit of a packet.
--
-- Revision 1.48  1998/03/26 21:37:12  chris
-- Added code to support bit stuff generation on the last bit of a token packet.
-- Simplified the attach interrupt hardware.
-- Added support for longer latency memory systems (BDT caching).
--
-- Revision 1.47  1998/03/13 23:58:02  chris
-- Corrected Host token operation.
--
-- Revision 1.46  1998/02/26 20:29:49  gregg
-- Fixed erroneous bts_err_set during high performance mode operation
--
-- Revision 1.45  1998/02/24 15:13:50  chris
-- Enabled and debugged host mode operations.
--
-- Revision 1.44  1998/02/17 21:22:12  chris
-- Added code to support embedded host mode operations.
--      Currently untested.
--
-- Revision 1.43  1998/01/19 22:56:20  chris
-- Changed the meaning of the endpoint control register bit definitions.
--
-- Revision 1.42  1997/11/20 14:32:32  chris
-- Added clock enable to logic to all registers and strobed outputs.
--
-- Revision 1.41  1997/10/16 12:47:33  chris
-- Removed <Control-M> characters from the line ends.
--
-- Revision 1.40  1997/08/25 20:11:38  gregg
-- Added additional error support
--
-- Revision 1.39  1997/05/21 15:58:04  chris
-- Removed transition that rejected packets that have long EOP pulses.
--
-- Revision 1.38  1997/05/16 16:59:05  eric
-- chenged the DET_SYNC to only check for 3 zeroes and a one instead of
-- 6 zeros and a one which fails in the lab. PLL may blow the second bit.
--
-- Revision 1.37  1997/05/15 20:34:07  gregg
-- Fix last bit stuff of CRC
--
-- Revision 1.36  1997/05/15 03:28:29  gregg
-- Added better se0 detection to the TOKEN state machine
--
-- Revision 1.35  1997/05/13 21:44:09  gregg
-- Added error checking conditions
--
-- Revision 1.34  1997/05/13 10:13:20  gregg
-- Fixed transmit of small packets
--
-- Revision 1.33  1997/05/12 22:02:24  gregg
-- Added direction support to bulk and iso endpoints
--
-- Revision 1.32  1997/05/12 19:01:17  gregg
-- Fixed rxd_pstate to use ser2par_cnt_eq7
-- Added enumerated type variables for simulation debug
--
-- Revision 1.31  1997/05/12 03:11:13  gregg
-- Added new endpoint control register formats
--
-- Revision 1.30  1997/05/10 03:22:36  gregg
-- Added EOP to the DPLL and brought more debugging signals out.
--
-- Revision 1.29  1997/05/09 16:43:51  gregg
-- Moved SE0 detect to DPLL.
--
-- Revision 1.28  1997/05/08 08:33:49  gregg
-- Encoded in and rx data packet state machines
--
-- Revision 1.27  1997/05/08 00:02:30  gregg
-- Re-ordered Control/Data bus bit definitions
--
-- Revision 1.26  1997/03/18 18:31:36  chris
-- Reversed the bit order of the address comparitor input.
--
-- Revision 1.25  1997/03/18  12:10:14  gregg
-- Added token state machine present state bit to debug bus
-- Implemented additional error conditions CRC5_ERR, and CRC16_ERR
--
-- Revision 1.24  1997/03/17 22:36:55  gregg
-- Improved SYNC field detection
--
-- Revision 1.23  1997/03/17 20:34:46  eric
-- reset the ODD bits when indicated.
--
-- Revision 1.22  1997/03/08 03:26:18  gregg
-- Added dma_early_req to reduce bus request latency
--
-- Revision 1.21  1997/03/07 20:10:42  gregg
-- Added code for DMA_ERR on Tx Data Packets
--
-- Revision 1.20  1997/03/07 04:06:09  gregg
-- Added cdb signals for error status interrupts
--
-- Revision 1.19  1997/03/05 17:24:04  gregg
-- Corrected stalled conditions of SETUP, IN, and Rx Data Packets
-- for control endpoints
--
-- Revision 1.18  1997/03/05 04:20:52  gregg
-- Fixed false single ended 0 dectects
--
-- Revision 1.17  1997/03/05 03:27:06  gregg
-- Added det_se0 and ser2par_cnt to rx data packet statemachine
-- sensitivity list
--
-- Revision 1.16  1997/03/05 01:46:31  gregg
-- Fixed Rx Data Packet NAK response problem
-- Improved false EOP rejection
--
-- Revision 1.15  1997/03/04 20:06:06  gregg
-- Increased bus turnaround time by 2 clocks
-- Fixed Tx Data Packet with 0 byte count
--
-- Revision 1.14  1997/03/04 18:15:42  gregg
-- Fixed BDT DATA01 writeback problem on SETUP and RX DATA PACKETS
--
-- Revision 1.13  1997/03/04 16:26:06  gregg
-- Added in_handshake_done to sensitivity list
--
-- Revision 1.12  1997/03/04 14:17:07  gregg
-- Added CRC16 and fixed bitstuff on Tx Data Packets
--
-- Revision 1.11  1997/03/03 20:37:42  gregg
-- Fixed Tx Data Packet handshake with own=0
--
-- Revision 1.10  1997/03/03 18:56:23  gregg
-- Added Tx Data Packet
--
-- Revision 1.9  1997/03/03 12:52:23  gregg
-- Added Tx FIFO interface
--
-- Revision 1.8  1997/02/27 02:08:28  gregg
-- Added Rx FIFO interface
--
-- Revision 1.7  1997/02/24 21:46:54  gregg
-- Added ser2par_cnt_eq2 to sensitivity list
--
-- Revision 1.6  1997/02/24 20:37:53  gregg
-- Fixed bit stuff removal problem on back-to-back tokens
--
-- Revision 1.5  1997/02/24 17:27:26  gregg
-- Added handshake states
--
-- Revision 1.4  1997/02/21 22:10:42  eric
-- Fixed USB_RST_EN_D. needed to be=1 on SRST, not 0.
--
-- Revision 1.3  1997/02/21 14:42:28  gregg
-- OUT and SETUP coded.
--
-- Revision 1.2  1997/02/07 20:22:29  chris
-- Added dummy assignments for unimplemented outputs.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use ieee.std_logic_arith.all;
use work.cfg_usb.all;

entity usb_sie is
  GENERIC(
    lsdev       : integer := LOW_SPEED_DEV);     -- see cfg_usb
  port (clk      : in  std_ulogic;  -- Clock
        clk_en   : in  std_ulogic;  -- Clock enable
        clk_sof  : in  std_ulogic;  -- SOF timer clock
        clken_12 : in  std_ulogic;  -- SOF timer clock enable
        srst     : in  std_ulogic;  -- Reset
        -- Control/Data bus interface
        cdb_in   : in  std_ulogic_vector(43 downto 0); -- Control/Data bus in
        cdb_out  : out std_ulogic_vector(45 downto 0); -- Control/Data bus out
        -- FIFO interfaces
        rx_full  : in  std_ulogic;  -- Rx FIFO full
        rx_wdata : out std_ulogic_vector(7 downto 0);  -- Rx FIFO write data
        rx_we    : out std_ulogic;  -- Rx FIFO write enable
        tx_empty : in  std_ulogic;  -- Tx FIFO empty
        tx_rdata : in  std_ulogic_vector(7 downto 0);  -- Tx FIFO read data
        tx_re    : out std_ulogic;  -- Tx FIFO read enable
        tx_valid : in  std_ulogic;  -- Tx FIFO has valid data in it
        flush    : out std_ulogic;  -- FIFO flush enable
        --  HUB controller interface signals
        pre_pid_det   : out std_ulogic; -- Low Speed Preamble PID detected.
        valid_sof_pid : out std_ulogic; -- Valid SOF PID detected
        sie_eop_out        : out std_ulogic; -- DPLL generated an EOP
        -- USB Interface signals
        host_mode_en : in  std_ulogic;  -- enable embedded host if implemented
        host_wo_hub  : in  std_ulogic;  -- host without hub control
        low_speed_req: in  std_ulogic;  -- USB Speed Control from uProc
        low_speed_en : out std_ulogic;  -- USB Speed Control to DPLL
        suspnd   : out std_ulogic;  -- USB Suspend
        usboe    : out std_ulogic;  -- USB Output Enable
        dpo      : out std_ulogic;  -- USB Data Plus Output
        dmo      : out std_ulogic;  -- USB Data Minus Output
        rcv      : in  std_ulogic;  -- USB Receive Data
        jstate   : in  std_ulogic;  -- synchronized jstate signal
        eop      : in  std_ulogic;  -- USB end of packet
        se0      : in  std_ulogic;  -- USB single ended zero
        debug    : out std_ulogic_vector(15 downto 0)); -- Debug bus
end usb_sie;

architecture rtl of usb_sie is

-- The following were added to support SLOW and FULL SUSPEND of 3ms
constant SUSPEND_TERM_CNT_HS : std_ulogic_vector(15 downto 0) :=
                           "1000" & "1100" & "1010" & "0000"; -- 8ca0h = 36,000
constant SUSPEND_TERM_CNT_LS : std_ulogic_vector(15 downto 0) :=
                           "0001" & "0001" & "1001" & "0100"; -- 1194h = 4,500

constant SOF_TERM_CNT_HS : std_ulogic_vector(15 downto 0) := 
                           "0010" & "1110" & "1101" & "1111"; -- 2ee0h = 12,000
                         --"0000" & "0100" & "0110" & "0000"; -- 0460h = 1,200
constant SOF_TERM_CNT_LS : std_ulogic_vector(15 downto 0) := 
                           "0000" & "0101" & "1101" & "1100"; -- 05dch = 1,500

constant PID_OUT   : std_ulogic_vector(3 downto 0) := "0001";
constant PID_IN    : std_ulogic_vector(3 downto 0) := "1001";
constant PID_SOF   : std_ulogic_vector(3 downto 0) := "0101";
constant PID_SETUP : std_ulogic_vector(3 downto 0) := "1101";
constant PID_DATA0 : std_ulogic_vector(3 downto 0) := "0011";
constant PID_DATA1 : std_ulogic_vector(3 downto 0) := "1011";
constant PID_ACK   : std_ulogic_vector(3 downto 0) := "0010";
constant PID_NAK   : std_ulogic_vector(3 downto 0) := "1010";
constant PID_STALL : std_ulogic_vector(3 downto 0) := "1110";
constant PID_PRE   : std_ulogic_vector(3 downto 0) := "1100";

type tok_states is (ERROR_E, TOK_IDLE_E, TOK_SYNC_E, TOK_PID_E, TOK_BYTE0_E, 
                    TOK_BYTE1_E, TOK_EOP_E, TOK_PROC_E, TOK_WAIT_E);

constant TOK_IDLE  : std_ulogic_vector(2 downto 0) := "000";
constant TOK_SYNC  : std_ulogic_vector(2 downto 0) := "001";
constant TOK_PID   : std_ulogic_vector(2 downto 0) := "011";
constant TOK_BYTE0 : std_ulogic_vector(2 downto 0) := "010";
constant TOK_BYTE1 : std_ulogic_vector(2 downto 0) := "110";
constant TOK_EOP   : std_ulogic_vector(2 downto 0) := "111";
constant TOK_PROC  : std_ulogic_vector(2 downto 0) := "101";
constant TOK_WAIT  : std_ulogic_vector(2 downto 0) := "100";

type txd_states is (TXD_WAIT_E, TXD_SYNC_E, TXD_PID_E, TXD_DATA_E, TXD_CRC16L_E,
                    TXD_CRC16H_E, TXD_LBS_E, TXD_EOP_E, TXD_HSHK_E, TXD_DONE_E,
                    TXD_PRE_E, TXD_LSDLY_E,
--------------------------------------------------------------------------------
-- NOTE: Modified the TXD_WAIT state tx data packet state machine state. THis is only 
--       until the V8 can run at speed! This will delay the bus turn around time
--       of the VUSB to 2 additional clocks. This allows additional bus 
--       arbitration time. This will allow the VUSB to update the BDT before we 
--       need the DATA01 value for the TXD_PID state. When V8 runs at speed 
--       remove the references to the TXD_DELAY state.
--------------------------------------------------------------------------------
            TXD_DELAY_E);

constant TXD_WAIT    : std_ulogic_vector(3 downto 0) := "0000";
constant TXD_SYNC    : std_ulogic_vector(3 downto 0) := "0001";
constant TXD_PID     : std_ulogic_vector(3 downto 0) := "0010";
constant TXD_DATA    : std_ulogic_vector(3 downto 0) := "0011";
constant TXD_CRC16L  : std_ulogic_vector(3 downto 0) := "0100";
constant TXD_CRC16H  : std_ulogic_vector(3 downto 0) := "0101";
constant TXD_LBS     : std_ulogic_vector(3 downto 0) := "1110";
constant TXD_EOP     : std_ulogic_vector(3 downto 0) := "0110";
constant TXD_HSHK    : std_ulogic_vector(3 downto 0) := "0111";
constant TXD_DONE    : std_ulogic_vector(3 downto 0) := "1000";
constant TXD_DELAY   : std_ulogic_vector(3 downto 0) := "1001";
constant TXD_PRE     : std_ulogic_vector(3 downto 0) := "1010";
constant TXD_LSDLY   : std_ulogic_vector(3 downto 0) := "1011";

type rxd_states is (RXD_WAIT_E, RXD_SYNC_E, RXD_IDLE_E, RXD_PID_E, RXD_BYTE0_E, 
                    RXD_BYTE1_E, RXD_BYTE2_E, RXD_EOP_E, RXD_HSHK_E, RXD_DONE_E);

constant RXD_WAIT  : std_ulogic_vector(3 downto 0) := "0000";
constant RXD_IDLE  : std_ulogic_vector(3 downto 0) := "0001";
constant RXD_SYNC  : std_ulogic_vector(3 downto 0) := "0010";
constant RXD_PID   : std_ulogic_vector(3 downto 0) := "0011";
constant RXD_BYTE0 : std_ulogic_vector(3 downto 0) := "0100";
constant RXD_BYTE1 : std_ulogic_vector(3 downto 0) := "0101";
constant RXD_BYTE2 : std_ulogic_vector(3 downto 0) := "0110";
constant RXD_EOP   : std_ulogic_vector(3 downto 0) := "0111";
constant RXD_HSHK  : std_ulogic_vector(3 downto 0) := "1000";
constant RXD_DONE  : std_ulogic_vector(3 downto 0) := "1001";

-- The following line is used when translating to Verilog...
-- synopsys sync_set_reset "srst"

-- Requires the sync_set/reset attribute to insure no Xes in simulation
attribute sync_set_reset : string;  -- Required for Synopsys
attribute sync_set_reset of srst : signal is "true";  -- Required for synopsys 

signal bdt_stall_d     : std_ulogic; -- BDT stall control bit
signal bdt_valid       : std_ulogic; -- BDT registers contain a valid BDT
signal bdt_wrt_pid     : std_ulogic_vector(3 downto 0); -- PID value for BDT
signal bto_err_set     : std_ulogic; -- Bus timeout error interrupt set
signal byte_count_eq   : std_ulogic; -- DMA byte count equals saved byte count

-- SIE counter signals
signal mcek_cnt        : std_ulogic_vector(4 downto 0); -- multi purpose counter
signal mcek_cnt_clr    : std_ulogic; -- Counter clear term
signal se0_f           : std_ulogic; -- registered copy of se0 input
signal jstate_f        : std_ulogic; -- registered copy of rcv input
signal crc5_data       : std_ulogic_vector(4 downto 0); -- CRC5 data
signal crc5_data_clr   : std_ulogic; -- CRC5 data load enable
signal crc5_data_ld    : std_ulogic; -- CRC5 data load enable
signal crc5_data_se    : std_ulogic; -- CRC5 data shift enable
signal crc5_okay       : std_ulogic; -- CRC5 okay
signal crc5_err_set    : std_ulogic; -- CRC5 okay
signal crc16_data      : std_ulogic_vector(15 downto 0); -- CRC16 data
signal crc16_data_comp : std_ulogic; -- CRC16 data compute enable
signal crc16_data_se   : std_ulogic; -- CRC16 data shift enable
signal comp_crc16_data : std_ulogic_vector(15 downto 0); -- Compute CRC16 data
signal crc16_data_ld   : std_ulogic; -- CRC16 data load enable
signal crc16_err_set   : std_ulogic; -- CRC16 error detected.
signal crc16_okay      : std_ulogic; -- CRC16 okay

-- Current token register, token write data, and load enable
signal current_token    : std_ulogic_vector(3 downto 0); 
signal current_token_eq : std_ulogic;
signal current_token_d  : std_ulogic_vector(3 downto 0);
signal current_token_ld : std_ulogic;

-- Current endpoint register, endpoint write data, and load enable
signal current_endpt    : std_ulogic_vector(3 downto 0);
signal current_endpt_eq : std_ulogic;
signal current_endpt_d  : std_ulogic_vector(3 downto 0);
signal current_endpt_ld : std_ulogic;

signal data01        : std_ulogic;  -- BDT data0/1 control bit
signal det_rst       : std_ulogic;  -- Detect USB reset
signal det_eop       : std_ulogic;  -- Detect end of packet
signal det_se0       : std_ulogic;  -- Detect single ended zero
signal det_sync      : std_ulogic;  -- Detect SYNC

signal dev_dma_rd_bdt: std_ulogic; -- DMA read BDT (4 bytes) (non-host)
signal dma_rd_bdt    : std_ulogic; -- DMA read BDT (4 bytes)
signal dma_re_rd_bdt : std_ulogic; -- DMA re_rd BDT (4 bytes)

signal dma_wrt_bdt   : std_ulogic; -- DMA write BDT (4 bytes)
signal dfn8_err_tok  : std_ulogic; -- Token packet not 8-bits error interrupt set
signal dfn8_err_rxd  : std_ulogic; -- Data field not 8-bits error interrupt set
signal dts           : std_ulogic;  -- BDT dts control bit

-- DMA early req
constant enable_early_req : std_ulogic := '0';

--signal endpt_en         : std_ulogic; -- Endpoint enabled
signal endpt_in_en      : std_ulogic; -- Endpoint rx in enabled
signal endpt_in_en_d    : std_ulogic; -- Endpoint rx in enabled data
signal endpt_ctl_dis    : std_ulogic; -- Endpoint not control enpoint
signal endpt_ctl_dis_d  : std_ulogic; -- Endpoint not control enpoint
signal endpt_out_en     : std_ulogic; -- Endpoint rx out enabled
signal endpt_out_en_d   : std_ulogic; -- Endpoint rx out enabled data
signal endpt_stall      : std_ulogic; -- Endpoint stall
signal endpt_stall_clr  : std_ulogic; -- Endpoint stall clear
signal endpt_stall_set  : std_ulogic; -- Endpoint stall set
signal endpt_hshk       : std_ulogic; -- Endpoint handshake enable
signal endpt_hshk_d     : std_ulogic; -- Endpoint handshake data

-- Current frame number register, frame number write data, and load enable
signal frame_num     : std_ulogic_vector(10 downto 0);  
signal frame_num_d   : std_ulogic_vector(10 downto 0);  
signal frame_num_ld  : std_ulogic;  

-- Embedded host controller signals
signal hc_en         : std_ulogic; -- embedded host controller functions are
                                  -- implemented and turned on
signal hc_en_f, hc_en_fq : std_ulogic;    -- register for  capturing the rising
                                         -- edge of hc_en.
signal hc_attach_set : std_ulogic; -- attach / detach interrupt pulse
signal hc_det_attach : std_ulogic; -- host controller attach detect
signal hc_dma_rd_bdt_q : std_ulogic; -- DMA read BDT (4 bytes) (host)
signal hc_dma_rd_bdt : std_ulogic; -- DMA read BDT (4 bytes) (host)
signal hc_reset      : std_ulogic; -- reset on entering or exiting host mode.
signal hc_rst_req    : std_ulogic; -- USB reset request
--signal hc_sof_cnt_q  : std_ulogic_vector(15 downto 0); -- SOF Threshold 
signal sof_cnt_clr0  : std_ulogic; -- SOF counter clear in clken_dpll domain
signal sof_cnt_clra  : std_ulogic; -- two cycle wide async sof cnt clear
signal sof_cnt_clr   : std_ulogic; -- SOF cnt clr in clken_12 domain
signal hc_ls_timing  : std_ulogic; -- host is using low speed timing
signal hc_ls_timing_q: std_ulogic; -- host is using low speed timing
signal hc_ls_timing_clr : std_ulogic; -- finish host low speed timing
signal hc_ls_timing_set : std_ulogic; -- start host low speed timing
signal tok_ls_timing_set : std_ulogic; -- start host token low speed timing
signal txd_ls_timing_set : std_ulogic; -- start host txd low speed timing
signal hc_no_retry       : std_ulogic; -- host retry not allowed on this failure
signal hc_retry_disable  : std_ulogic; -- host retry disabled from uProcessor int
signal hc_rxd_pid    : std_ulogic_vector(3 downto 0); -- Rx PID value
signal hc_rxd_pid_q  : std_ulogic_vector(3 downto 0); -- Rx PID value
signal hc_sof_cnt    : std_ulogic_vector(15 downto 0); -- SOF Threshold 
signal hc_sof_tc     : std_ulogic; -- SOF terminal count
signal hc_sof_thld_set: std_ulogic; -- SOF Threshold det interrupt pulse
signal hc_sof_err_set: std_ulogic; -- Start of Frame error interrupt pulse
signal hc_sof_req    : std_ulogic; -- USB SOF transaction request
signal hc_sof_req_set: std_ulogic; -- USB SOF sync to clk_en
signal hc_sof_req_set_q: std_ulogic; -- USB SOF sync to clk_en
signal hc_sof_req_f  : std_ulogic; -- USB SOF one clk_en delayed
signal hc_sof_req_fq : std_ulogic; -- USB SOF one clk_en delayed reg output
signal hc_sof_req_q  : std_ulogic; -- USB SOF register output
signal hc_sof_thld   : std_ulogic_vector(7 downto 0); -- SOF Threshold  
signal hc_stall_set  : std_ulogic; -- stall interrupt pulse
signal hc_token_busy : std_ulogic; -- the last host token request is not complete
signal hc_token_busy_f  : std_ulogic; -- registered copy
signal hc_token_busy_fq : std_ulogic; -- flip_flop q output
signal hc_token_done : std_ulogic; -- USB token transaction completed
signal hc_token_endpt: std_ulogic_vector(3 downto 0); -- host End Point
signal hc_token_inhibit : std_ulogic; -- USB token inhibit
signal hc_token_inhibit_dq : std_ulogic; -- token inhibit async to clke_en
signal hc_token_inhibit_d : std_ulogic; -- token inhibit regster input.
signal hc_token_inhibit_f : std_ulogic; -- USB token inhibit one cycle delayed
signal hc_token_inhibit_fq : std_ulogic; -- register output
signal hc_token_inhibit_q : std_ulogic; -- register output.
signal hc_token_req  : std_ulogic; -- USB token transaction req
signal hc_token_pid  : std_ulogic_vector(3 downto 0); -- host PID
signal hc_txd_byte   : std_ulogic_vector( 7 downto 0); -- host data byte
signal hc_tx_data    : std_ulogic_vector(10 downto 0); -- host data

signal idmo          : std_ulogic; -- Internal USB Data minus output
signal idmo_d        : std_ulogic; -- Internal USB Data minus output data
signal idpo          : std_ulogic; -- Internal USB Data plus output
signal idpo_d        : std_ulogic; -- Internal USB Data plus output data
signal in_handshake_en   : std_ulogic; -- In handshake enable
signal in_handshake_done : std_ulogic; -- In handshake done
signal tx_datpkt_proc : std_ulogic; -- Tx Data Packet process
signal tx_datpkt_done : std_ulogic; -- Tx Data Packet process done
signal tx_fif_re      : std_ulogic; -- internal  copy of Tx FIFO read enable
signal txd_pid_data    : std_ulogic_vector(3 downto 0); -- Tx Data Packet pid data
signal usb_dout        : std_ulogic; -- USB data dout
signal usb_jstate_req  : std_ulogic; -- USB jstate output request
signal usb_kstate_req  : std_ulogic; -- USB kstate output request
signal usb_nrzo	       : std_ulogic; -- USB nrz encoded data out.
signal usb_se0_req     : std_ulogic; -- USB single ended zero output request

-- Tx Data Packet state machine state bits
signal txd_enum        : txd_states; -- Tx Data Packet state enumerated type

signal txd_pstate      : std_ulogic_vector(3 downto 0); -- Present state bits
signal txd_nstate      : std_ulogic_vector(3 downto 0); -- Next state bits
signal txd_token       : std_ulogic; -- the current token requires a tx data packet.
signal txd_suspend     : std_ulogic; -- This signal is set on receipt of a SETUP
                                    -- token and inhibits any IN token
                                    -- processing until it is cleared by software.
signal txd_suspend_set : std_ulogic; -- set signal receipt of a SETUP
       -- target mode transmit suspend / host mode token busy dual use signal
signal txdsuspend_tokbusy     : std_ulogic; -- register
signal txdsuspend_tokbusy_clr : std_ulogic; -- clear from usb_sie
signal txdsuspend_tokbusy_set : std_ulogic; -- set from usb_sie

signal last_bit_stuff_en : std_ulogic;  -- Last bit stuff enable
signal ninc            : std_ulogic;  -- BDT ninc control bit
signal nxt_crc16_data  : std_ulogic_vector(15 downto 0); -- Next CRC16 data
signal nxt_crc5_data   : std_ulogic_vector(4 downto 0); -- Next CRC5 data

signal odd_rst     : std_ulogic; -- reset all of these bits

-- Bit stuff logic signals
signal bts_err_set    : std_ulogic; -- bit stuff error set signal
signal bit_stuff_err  : std_ulogic; -- bit stuff error in this packet
signal one_bit_cnt    : std_ulogic_vector(2 downto 0); -- One bit count
signal one_bit_cnt_d  : std_ulogic_vector(2 downto 0); -- One bit count data
signal one_bit_cnt_ld : std_ulogic; -- One bit count load enable
signal zero_stuff      : std_ulogic; -- This bit is a stuff bit.
signal force_bit_stuff_err: std_ulogic; -- Force a bit stuff error on output
signal zero_stuff_inhibit : std_ulogic; -- Turn off bit stuffing for one byte 

signal out_data01_pid      : std_ulogic; -- Out data01 pid register
signal out_data01_pid_d    : std_ulogic; -- Out data01 pid register data
signal out_handshake_en    : std_ulogic; -- Out handshake enable
signal out_handshake_done  : std_ulogic; -- Out handshake done

signal resume_req     : std_ulogic; -- Assert resume signaling request
-- Rx Data Packet state machine state bits
signal rxd_enum       : rxd_states; -- Rx Data Packet enumerated type
--signal rxd_nstate     : rxd_states; -- Next state bits
signal rxd_pstate     : std_ulogic_vector(3 downto 0); -- Present state bits
signal rxd_nstate     : std_ulogic_vector(3 downto 0); -- Next state bits
signal rx_datpkt_proc : std_ulogic; -- Rx Data Packet process
signal rx_datpkt_done : std_ulogic; -- Rx Data Packet process done
signal rx_fif_we      : std_ulogic; -- Receive FIFO write enable
signal rx_overrun_nak : std_ulogic; -- Force a Nak responce to this Rx Packet
signal own            : std_ulogic;  -- BDT own control bit
signal own_d          : std_ulogic;  -- BDT own control bit data
signal own_ld         : std_ulogic;  -- BDT own control bit load enable
signal own_ok         : std_ulogic;  -- BDT own control bit is still valid
signal own_ok_suspend : std_ulogic;  -- Don't cache the BDT own control bit 

-- Parallel to serial register signals
signal par2ser_rg       : std_ulogic_vector(7 downto 0);
signal par2ser_rg_d     : std_ulogic_vector(7 downto 0);
signal par2ser_rg_se    : std_ulogic; -- Par2ser reg shift enable
signal par2ser_rg_ld    : std_ulogic; -- Par2ser reg load enable

signal pid_chk_ok      : std_ulogic; -- PID check
signal pid_field       : std_ulogic_vector(3 downto 0); -- PID field

signal pre_pid_det_d   : std_ulogic; -- Low Speed Preamble PID det to hub
signal pre_pid_det_f   : std_ulogic; -- Low Speed Preamble PID det to hub
signal pre_pid_det_ff  : std_ulogic; -- Low Speed Preamble PID det to hub

signal reject_rx_datpkt  : std_ulogic; -- Reject tx data packet enable
signal reject_rx_dat_set : std_ulogic; -- Reject rx data packet enable
signal reject_tx_datpkt  : std_ulogic; -- Reject tx data packet enable
signal reject_tx_dat_set : std_ulogic; -- Reject rx data packet enable

signal sie_se0_req_f     :std_ulogic;     -- SIE generated an EOP

-- Serial to parallel bit counter signals
signal ser2par_cnt     : std_ulogic_vector(2 downto 0);
signal ser2par_cnt_d   : std_ulogic_vector(2 downto 0);
signal ser2par_cnt_en  : std_ulogic; -- Serial to parallel bit count enable
signal ser2par_cnt_eq0 : std_ulogic; -- Serial to parallel bit count equals 0
signal ser2par_cnt_eq1 : std_ulogic; -- Serial to parallel bit count equals 1
signal ser2par_cnt_eq2 : std_ulogic; -- Serial to parallel bit count equals 2
signal ser2par_cnt_eq6 : std_ulogic; -- Serial to parallel bit count equals 6
signal ser2par_cnt_eq7 : std_ulogic; -- Serial to parallel bit count equals 7
signal ser2par_cnt_ld  : std_ulogic; -- Serial to parallel bit count load

-- Serial to parallel register signals
signal ser2par_rg       : std_ulogic_vector(23 downto 0);
signal ser2par_rg_d     : std_ulogic_vector(23 downto 0);
signal ser2par_rg_se    : std_ulogic; -- Ser2par reg shift enable

signal sof_pid    : std_ulogic;  -- SOF pid detect
--signal stall      : std_ulogic;  -- BDT stall control bit
signal start_txd  : std_ulogic;  -- Staring the tx data packet state machine

-- Token state machine state bits
signal tok_enum        : tok_states; -- Token state enumerated type
--signal tok_nstate      : tok_states; -- Next state bits
signal tok_pstate      : std_ulogic_vector(2 downto 0); -- Present state bits
signal tok_nstate      : std_ulogic_vector(2 downto 0); -- Next state bits

signal token_done      : std_ulogic; -- Token processing done
signal token_proc_en   : std_ulogic; -- Token processing enable
signal transmit_data   : std_ulogic_vector(7 downto 0); -- Transmit data
signal transmit_done   : std_ulogic; -- Transmit done
signal tgt_stall_set   : std_ulogic; -- A stall handshake has been sent by target


signal usb_addr        : std_ulogic_vector(6 downto 0); -- USB address
signal usb_addr_eq     : std_ulogic; -- USB address equals
signal usb_addr_eq_d   : std_ulogic; -- USB address equals data
signal usb_bs_data     : std_ulogic; -- USB bit stuff data
signal usb_crc_data    : std_ulogic; -- USB crc data
signal usb_en          : std_ulogic; -- USB enable signal
signal usb_rst_en_d    : std_ulogic; -- USB reset enable data
signal usb_rst_en      : std_ulogic; -- USB reset enable
signal usboe_d         : std_ulogic; -- USB output enable data
signal usboe_df        : std_ulogic; -- USB output enable delay flop

signal valid_sof_pid_d : std_ulogic; -- Valid SOF PID detect to hub
signal valid_sof_pid_f : std_ulogic; -- Valid SOF PID detect to hub
signal valid_sof_pid_ff: std_ulogic; -- Valid SOF PID detect to hub
signal valid_data_pid  : std_ulogic; -- Valid data PID
signal valid_data_tgl  : std_ulogic; -- Valid data toggle bit
signal valid_token_pid : std_ulogic; -- Valid token PID
signal valid_stall_pid : std_ulogic; -- Valid token PID
signal keep            : std_ulogic; -- BDT keep control bit

signal resume_req_f   : std_ulogic; -- Resume signaling request delayed 1 ff
signal resume_req_ff  : std_ulogic; -- Resume signaling request delayed 2 ffs
signal lseop_en       : std_ulogic; -- LS EOP enable
signal set_lseop_en   : std_ulogic; -- Set LS EOP enable
signal clr_lseop_en   : std_ulogic; -- Clear LS EOP enable

signal low_speed_signaling : std_ulogic; -- Enable low speed signaling

begin

-- host controller enable is used to enable the embedded host perations of the
-- core.   When IMPLEMENT_EMBEDED_HOST is '0' this signal causes the bulk of the
-- logic associated with the embedded host functions to be optimized out.

hc_en <= IMPLEMENT_EMBEDED_HOST and host_mode_en; 

-- Assign debug bus
debug <= reject_rx_datpkt & det_eop & det_se0 & det_sync & ser2par_rg(0) & 
         tok_pstate & rxd_pstate & txd_pstate;

--------------------------------------------------------------------------------
-- Dummy output signal assignments to remove unknowns from the simulations.   --
-- These assignments should be removed as the logic is implemented.           --
--------------------------------------------------------------------------------
suspnd <= '0';                                                                --

-- Buffer USB outputs
dpo <= idpo;
dmo <= idmo;

-- HUB controller interface signals
-- These signals must be 2 clocks wide to insure that they can
-- be recieved in the hub clock domain.
pre_pid_det   <= pre_pid_det_f OR pre_pid_det_ff; -- Low Speed Preamble detected.
valid_sof_pid <= valid_sof_pid_f OR valid_sof_pid_ff; -- Valid SOF PID detected

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- FIFO interfaces
--------------------------------------------------------------------------------
-- Rx FIFO write data
-- This is the receive data that must be written into the Rx FIFO.
rx_wdata <= ser2par_rg(16) & ser2par_rg(17) & ser2par_rg(18) & 
            ser2par_rg(19) & ser2par_rg(20) & ser2par_rg(21) & 
            ser2par_rg(22) & ser2par_rg(23);

-- Rx FIFO write enable
-- This signal when active high writes the receive data into the Rx FIFO.
rx_we     <= rx_fif_we;
rx_fif_we <= '1' when clk_en = '1' and own = '1' and endpt_stall = '0' and  
                  rxd_pstate = RXD_BYTE2 and ser2par_cnt_eq7 = '1'  
             else '0';

--------------------------------------------------------------------------------
--
-- Control/Data Bus In Definitions:
--
-- Assign control inputs, do all in one spot for easy modifications
--

--  cdb_in(43)  : hc_retry_disable - disable the automatic retry of host transfer
--                failures.
hc_retry_disable <= cdb_in(43);

--  cdb_in(42)  : resume_req - This signal causes the SIE to generate the resume
--                signalling on the USB bus in device or embedded host mode. When
--                operating in embedded host mode the resume signalling is 
--                terminated with a LS EOP.
resume_req       <= cdb_in(42);

--  cdb_in(41)  : hc_rst_req - This signal causes the SIE to generate the reset
--               signalling on the USB bus in embedded host mode.
hc_rst_req       <= cdb_in(41);

--  cdb_in(40)     : txdsuspend_tokbusy dual use register output
--                    txd_suspend   - Transmit data packets are suspended on
--                                    the target until the uProcessor resets
--                                    the suspend ctl.
--                    hc_token_busy - The token statemachine has not completed
--                                    the last host token transaction.
txdsuspend_tokbusy <= cdb_in(40);

-- cdb_in(39:32): hc_sof_thld - SOF threshold: count of USB byte times
--                   before the next SOF at which to discontinue Host
--                   transactions. 
hc_sof_thld       <= cdb_in(39 downto 32);

--  cdb_in(31:28)  : usb_token_pid - This is the PID used in host mode token packets.
hc_token_pid      <= cdb_in (31 downto 28);

--  cdb_in(27:24)  : usb_token_endpt - This is the Enpoint number  used in host mode
--               token packets. 
hc_token_endpt    <= cdb_in (27 downto 24);

--  cdb_in(23:17)  : addr(6:0) - This is the USB address that the usb_sie
--                       will compare with token packets.
--
usb_addr <= cdb_in(23 downto 17);

--  cdb_in(16)     : byte_count_eq - This bit informs the usb_sie that
--                       the DMA engine has reached a terminal byte count. 
--                       Data transmission should terminate when all remaining 
--                       data has been read from the Tx FIFO.
--
byte_count_eq <= cdb_in(16);

--  cdb_in(15)     : odd_rst - reset the PING/PONG odd bits.
--
odd_rst  <= cdb_in(15); -- clear BDT odd PING/PONG bits

--  cdb_in(14:8)    : ep_ctl - Endpoint control bits.
--
--                12           11         10         9         8
--          +------------+-----------+----------+----------+---------+
--          | ep_ctl_dis | ep_out_en | ep_in_en | ep_stall | ep_hshk |
--          +------------+-----------+----------+----------+---------+
--
endpt_ctl_dis_d <= cdb_in(12); --
endpt_out_en_d <= cdb_in(11); --
endpt_in_en_d  <= cdb_in(10); --
endpt_stall    <= cdb_in(9);   --
endpt_hshk_d <= cdb_in(8);    --

--  cdb_in(7:2)    : bdt(7:2) - These signals are the first byte of
--                       the BDT. They contain the following control bits:
--
--                          7       6          5       4      3     2
--                       +-----+---------+----------+------+-----+------+
--                       | own | data0/1 |   keep   | ninc | dts | stall|
--                       +-----+---------+----------+------+-----+------+
--
own_d       <= cdb_in(7); -- BDT own control bit
data01      <= cdb_in(6); -- BDT data0/1 control bit
keep        <= cdb_in(5); -- BDT keep control bit
ninc        <= cdb_in(4); -- BDT ninc (no increment) control bit
dts         <= cdb_in(3); -- BDT dts (data toggle sync) control bit
bdt_stall_d <= cdb_in(2); -- BDT stall control bit

--  cdb_in(1)      : bdt_valid - When this bit is active high it indicates
--                       that the BDT control bits are valid.
--
bdt_valid <= cdb_in(1);

--  cdb_in(0)      : usb_en - This is the USB enable signal from the control
--                       register.
--
usb_en <= cdb_in(0);

--------------------------------------------------------------------------------
--
-- Control/Data Bus Out Definitions:
--
--  cdb_out(45)    : txd_token - the current token requires a tx data packet.
cdb_out(45) <= txd_token;
--  cdb_out(44)    : stall_set - Set signal for the stalled endpoint interrupt
cdb_out(44) <= endpt_stall_clr;
--  cdb_out(43)    : stall_set - Set signal for the stalled endpoint interrupt
cdb_out(43) <= endpt_stall_set;
--  cdb_out(42:41) : clear and set signals for the dual use register
--                    txd_suspend   - Transmit data packets are suspended on
--                                    the target until the uProcessor resets
--                                    the suspend ctl.
--                    hc_token_busy - The token statemachine has not completed
--                                    the last host token transaction.

cdb_out(42) <= txdsuspend_tokbusy_clr;
cdb_out(41) <= txdsuspend_tokbusy_set;
--  cdb_out(40)    : out_data01_pid - This bit is represents the DATA PID
--                   received during a SETUP or Rx Data Packet. If 0 we are
--                   receiving a DATA0 PID, if 1 we are receving a DATA1 
--                   PID. This value is written back to memory in the BDT
--                   control byte (bit 6).
--
cdb_out(40) <= out_data01_pid;

--  cdb_out(39:36) : bdt_wrt_pid - These 4 bits represent the current
--                   token pid value. It is valid when a TOK_DNE is
--                   active.
--
cdb_out(39 downto 36) <= bdt_wrt_pid;

--  cdb_in(35:25)  : frame_num - These 11 bits represent the last frame 
--                   number that was received via a SOF packet. It is 
--                   valid after SOF_TOK has gone active.
--
cdb_out(35 downto 25) <= frame_num;  -- Current frame number

--  cdb_in(24:21)  : endpt - These four bits represent the current endpoint
--                   that the USB is using. This value will be stored by
--                   the up_int in the stat_rg when tok_dne_set=1.
--
cdb_out(24 downto 21) <= current_endpt;  -- Current end point

--  cdb_in(20)     : tx_datpkt_proc - This bit indicates that the usb_sie is
--                   processing a tx data packet.
--
cdb_out(20) <= tx_datpkt_proc;

--  cdb_in(19)     : rx_datpkt_proc - This bit indicates that the usb_sie is
--                   processing a rx data packet.
--
cdb_out(19) <= rx_datpkt_proc;

--  cdb_in(18:17)  : sie_dma_req - These two bits define the type of DMA
--                   request that the SIE is requesting. The bits are
--                   defined as:
--
--                    17 16 | Type of DMA request
--                   -------+--------------------------------------
--                     0  1 | BDT read DMA request (i.e. 4 bytes)
--                     1  0 | BDT write DMA request (i.e. 4 bytes)
--
--                   NOTE: The SIE will only activate one of the request
--                   bits at a time.
--
cdb_out(18 downto 17) <= (dma_wrt_bdt and own and not endpt_stall and clk_en) & 
                         -- DMA write BDT (4 bytes) 
                         (dma_rd_bdt and clk_en); -- DMA read BDT (4 bytes) 

--  cdb_out(16)    : dma_early_req - This signal is used to have the DMA
--                   request the bus early. No bus cycles are performed
--                   with this request signal on the bus is requested.
--                   This is useful in design when the bus_gnt latency
--                   could exceed xxx ns, (zzz sie clks).
--
cdb_out(16) <= '1' when enable_early_req = '1' and current_token = PID_IN and
                  ((tok_pstate = TOK_BYTE1) or (tok_pstate = TOK_EOP)) and 
                   token_proc_en = '1' and usb_addr_eq = '1' else '0';

--  cdb_out(15)     : bts_err_set - This signal when active will set the 
--                    BTS_ERR interrupt in the error status register
--                    (err_stat_rg).
--
cdb_out(15) <= bts_err_set;

--  cdb_out(14)    : own_err_set - This signal when active will set the 
--                   OWN_ERR interrupt in the error status register
--                   (err_stat_rg).
--
cdb_out(14) <= '0';

--  cdb_out(13)    : dma_err_set - This signal when active will set the 
--                   DMA_ERR interrupt in the error status register
--                   (err_stat_rg).
--
cdb_out(13) <= (rx_fif_we AND rx_full) or -- Set on a write to a full FIFO
               (tx_fif_re and tx_empty);  -- or reading data that is not there

--  cdb_out(12)    : bto_err_set - This signal when active will set the 
--                   BTO_ERR interrupt in the error status register
--                   (err_stat_rg).
--
cdb_out(12) <= bto_err_set;

-- Bus timeout error interrupt set
bto_err_set <= '1' when (rxd_pstate = RXD_IDLE OR rxd_pstate = RXD_SYNC) and
                         mcek_cnt = "01110"
               -- Turn around time for out/setup token or handshake
                   else '0';

--  cdb_out(11)    : dfn8_err_set - This signal when active will set the 
--                   DF8N_ERR interrupt in the error status register
--                   (err_stat_rg).
--
cdb_out(11) <= dfn8_err_tok OR dfn8_err_rxd; --  from token or rx data

--  cdb_out(10)    : crc16_err_set - This signal when active will set the 
--                   CRC16_ERR interrupt in the error status register
--                   (err_stat_rg).
--
crc16_err_set <= '1' when rxd_pstate = RXD_EOP and crc16_okay = '0' and 
                        in_handshake_en = '0' and ser2par_cnt_eq0 = '1' else 
                 '0';
cdb_out(10)   <= crc16_err_set;

--  cdb_out(9)     : crc5_err_set - This signal when active will set the 
--                   CRC5_ERR interrupt in the error status register
--                   (err_stat_rg).
--
cdb_out(9) <= crc5_err_set when hc_en = '0' else
              hc_sof_err_set;
              
crc5_err_set <= '1' when tok_pstate = TOK_EOP and crc5_okay = '0' and 
                       ser2par_cnt_eq0 = '1' AND hc_en = '0' else
                '0';

--  cdb_out(8)     : pid_err_set - This signal when active will set the 
--                   PID_ERr interrupt in the error status register
--                   (err_stat_rg).
--
cdb_out(8) <= '1' when ((tok_pstate = TOK_PID AND hc_en = '0')
                        or rxd_pstate = RXD_PID) and 
                       pid_chk_ok = '0' and ser2par_cnt_eq7 = '1' else
              '0';

--  cdb_in(7)      : stall_int_set - for target a stall handshake has been
--                   sent. For host a stall handshake has been received. This
--                   signal will cause stall bit in the interrupt status
--                   register to be set. 
--
cdb_out(7) <= hc_stall_set when hc_en = '1' else
              tgt_stall_set;

--  cdb_out(43)    : attach_set - This siganal when active will set the USB
--                   attach/detach interrupt in the interrupt status register.
cdb_out(6) <= hc_attach_set;

--  cdb_out(5)     : resume_set - This signal when active will set the 
--                   RESUME interrupt in the interrupt status register
--                   (istat_rg).
--
cdb_out(5) <= '0';   --  not currently implemented

--  cdb_out(4)     : sleep_set - This signal when active will set the 
--                   SLEEP interrupt in the interrupt status register
--                   (istat_rg).
--
cdb_out(4) <= '1' when hc_en = '0' and jstate = '1' and se0 = '0' and 
                       hc_sof_tc = '1'else '0';

--  cdb_out(3)     : tok_dne_set - This signal when active will set the 
--                   TOK_DNE interrupt in the interrupt status register
--                   (istat_rg).
--
cdb_out(3) <= token_done WHEN hc_en = '0' ELSE hc_token_done AND clk_en;

--  cdb_out(2)     : sof_tok_set - This signal when active will set the 
--                   SOF_TOK interrupt in the interrupt status register
--                   (istat_rg).
--
cdb_out(2) <= frame_num_ld or hc_sof_thld_set;

--  cdb_out(1)     : error_set - This signal when active will set the 
--                   ERROR interrupt in the interrupt status register
--                   (istat_rg).
--
cdb_out(1) <= '0';

--  cdb_out(0)     : usb_rst_set - This signal when active will set the 
--                   USB_RST interrupt in the interrupt status register
--                   (istat_rg).
--
cdb_out(0) <= det_rst;  -- Detect USB reset


--  clear and set signals for the dual use register txdsuspend_tokbusy
--                    txd_suspend   - Transmit data packets are suspended on
--                                    the target until the uProcessor resets
--                                    the suspend ctl.
--                    hc_token_busy - The token statemachine has not completed
--                                    the last host token transaction.
txdsuspend_tokbusy_set <= txd_suspend_set when hc_en = '0' 
                          ELSE '0';
txdsuspend_tokbusy_clr <= hc_token_done when hc_en = '1'
                          ELSE '0';
txd_suspend   <=  txdsuspend_tokbusy and NOT hc_en;

-- BDT own control bit load enable
-- The bdt own bit is sampled once during each transaction. It must be
-- valid by the time own_ld is active, or we will assume we do not own
-- the bdt and take the approriate action. Timing very important for in 
-- tokens not as critical for rx data packets.
own_ld <= '1' when (tx_datpkt_proc = '1' and txd_pstate = TXD_SYNC and 
                    ser2par_cnt_eq6 = '1') or 
                   (rxd_pstate = RXD_BYTE0 and ser2par_cnt_eq6 = '1') or
                   (rxd_pstate = RXD_IDLE) else -- for ISO packets that BTO
          '0';

-- If the BDT Own bit is one and the BDT_STALL bit is one then set the endpoint
-- stall register.
endpt_stall_set <= own_ld and own_d AND bdt_stall_d AND NOT txd_suspend;

-- If the last token caused us to fetch a valid owns bit and the current token
-- packet is the same as the last one the then the BDT loaded and it's owns bit
-- are still OK.  Other wise we will refetch the BDT.
own_ok <= '1' WHEN (bdt_valid = '1' AND own_d = '1' AND
                    (own_ok_suspend = '0' OR current_token /= PID_IN) AND 
                    current_token_eq = '1' AND
                    current_endpt_eq = '1')
              ELSE '0';

-- Detect USB Reset
-- This signal looks for a USB reset condition. This is signified by a SE0 
-- for at least 2.5 us. The turn around timer is used to count a SE0 condition.
-- The usb_rst_en signal allows only a single interrupt to be generated during
-- the entire USB reset.
det_rst <= 
  '1' when mcek_cnt = "11111" and usb_rst_en = '1' and
           det_se0 = '1' AND se0_f = '1' else
  '0';

-- Detect USB attach and detach
 -- attach is detected when the the host is currently unattached, and a J-state
 -- is observed for 2.5usec.  This interrupt should be disabled by the
 -- processor when it enters the attached state.
hc_det_attach <=
  '1' WHEN hc_en = '1' AND mcek_cnt = "11111" AND se0 = '0' AND se0_f = '0'
      ELSE  '0';


 --   an attach  generates an interrupt to the processor.
hc_attach_set <= hc_det_attach;
            
 -- dettach is detected when the the host is currently attached, and a se0
 -- is observed for 2.5usec that is not the result of a host reset request.
 -- This looks the same to the SIE as a USB reset.  The processor will ferret out
 -- the difference.

-- USB reset enable data
-- This signal is used to make sure that the USB reset logic will only
-- assert a single USB interrupt during a reset. Because the USB reset can 
-- be asserted for up to 10 ms we must only decode the USB reset on the first
-- 2.5 us and not any of the remaining time. This will prevent multiple 
-- interrupts during the same USB reset.
usb_rst_en_d <= 
  '1' when srst='1' OR mcek_cnt_clr = '1' else
  '0' when det_rst = '1' else
  usb_rst_en; -- No change

-- This signal decodes the end of packet condition.
-- se0 must have been active on the previous clock and this clock we
-- are in the "J" state.
det_eop <= eop;

--det_eop <= se0_f and rcv;

-- Detect single ended zero
det_se0 <= se0;

-- Detect SYNC
-- This signal looks at the last 9 bits of receive data. Looks for a
-- transition from idle followed by 01/h.
det_sync <= 
  '1' when (tok_pstate = TOK_SYNC or (tok_pstate = TOK_PROC and 
            rxd_pstate = RXD_SYNC)) and (ser2par_rg(3 downto 0) = "0001") else
  '0';

-- PID check
-- This logic performs the PID check.
pid_chk_ok <= 
  '1' when (ser2par_rg(7 downto 4) = not(ser2par_rg(3 downto 0)))
      else '0';

pre_pid_det_d   <=  '1' when (current_token_ld = '1' and
                              (pid_chk_ok = '1' and -- Low Speed Preamble PID detected.
                               pid_field = PID_PRE))
--                            or  (hc_en = '1' AND pre-pid-request-signal = '1')))
                   else '0';

valid_sof_pid_d <=  '1' when (current_token_ld = '1' and
                              ((pid_chk_ok = '1' and -- Valid SOF PID detected
                                pid_field = PID_SOF) or
                               (hc_en = '1' AND hc_sof_req = '1')))
                     else '0';

-- Valid token PID
-- A valid token PID is decoded when the following conditions have been
-- satisfied:
-- 1) pid(1:0) = "01" This indicates a Token PID
-- 2) pid(3:0) = not pid(7:4) PID check field passes
valid_token_pid <= 
  '1' when (ser2par_rg(7 downto 6) = "10") and -- Condition #1
           pid_chk_ok = '1' -- Condition #2
      else '0';

-- SOF pid
-- A valid SOF PID is decoded when the following conditions have been
-- satisfied:
-- 1) current_token = "0101" This indicates a SOF PID
sof_pid <= '1' when current_token = PID_SOF else '0';

-- Valid data PID
-- A valid data PID is decoded when the following conditions have been
-- satisfied:
-- NOTE: Should be able to but DTS code here!
-- 1) pid(2:0) = "011" This indicates a Data PID
-- 2) pid(3:0) = not pid(7:4) PID check field passes
valid_data_pid <= 
  '1' when (pid_field = PID_DATA0 or pid_field = PID_DATA1) and -- Condition #1
           pid_chk_ok = '1' -- Condition #2
      else '0';


-- Valid data toggle is true if the data toggle bit in the recieved packet
-- matches the expected data toggle bit from the BDT.
valid_data_tgl <=
  '1' when dts = '0' or    --  data toggle is ok if DTS is turned off
           (pid_field(3) = PID_DATA0(3) AND data01 = '0') or
           (pid_field(3) = PID_DATA1(3) AND data01 = '1')
      else '0';

valid_stall_pid <=  '1' when (pid_field = PID_STALL) and
                             pid_chk_ok = '1' -- Condition #2
                        else '0';

-- 3) Endpoint enabled
-- 4) CRC5 is okay
--valid_token <= '1' when (ser2par_rg(23 downto 22) = "10") and -- Condition #1
--                        (ser2par_rg(23 downto 20) = not(ser2par_rg(19 downto 16))) and
--                        -- Condition #2
--                        (endpt_en = '1') and   -- Condition #3
--                        (crc5_okay = '1') else -- Condition #4
--               '0';

-- Token processing done
-- Tell the token processing state machine that we are finished with 
-- IN and OUT data processing.
token_done <= clk_en AND own and not endpt_stall and NOT keep and
              ((tx_datpkt_done AND not reject_tx_datpkt) or
               (rx_datpkt_done AND NOT reject_rx_datpkt)); 

-- Tx Data Packet process
-- Enable the tx data packet state machine when the token process state machine
-- reaches TOK_PROC state and our current token is SETUP or OUT.
txd_token      <= '1' when ((hc_en = '0' and  current_token = PID_IN) or 
                            (hc_en = '1' and (current_token = PID_OUT or
                                              current_token = PID_SETUP))) else 
                 '0'; 

tx_datpkt_proc <= '1' when (tok_pstate = TOK_PROC) and txd_token = '1' else 
                 '0'; 
                           
-- Rx Data Packet process
-- Enable the rx data packet state machine when the token process state machine
-- reaches TOK_PROC state and our current token is SETUP or OUT.
rx_datpkt_proc <=  '1' when (tok_pstate = TOK_PROC) and 
                           ((hc_en = '1' and  current_token = PID_IN) or 
                            (hc_en = '0' and (current_token = PID_OUT or
                                              current_token = PID_SETUP))) else 
                 '0'; 


-- Tx Data Packet process done
tx_datpkt_done <= '1' when (txd_pstate = TXD_DONE) and 
                          (rxd_pstate = RXD_WAIT) else '0';

-- Rx Data Packet process done
rx_datpkt_done <= '1'  when (rxd_pstate = RXD_DONE) and 
                            (txd_pstate = TXD_WAIT) else '0';

-- Reject a host TX data packet if the it is nak'ed or you get a BTO
reject_tx_dat_set <= '1' when in_handshake_en = '1' and 
                        ((rxd_pstate = RXD_IDLE and bto_err_set = '1') or
                         (rxd_pstate = RXD_PID and ser2par_cnt_eq7 = '1' and
                          (pid_field /= PID_ACK and pid_field /= PID_STALL)))
                        else '0';

--send a stall interrupt if the recieve packet state machine gets a
-- stall handshake.
hc_stall_set <= '1' when rxd_pstate = RXD_PID and ser2par_cnt_eq7 = '1' and
                         valid_stall_pid = '1'
                    else '0';
                    
-- USB bit stuff and crc data
-- The usb_sie can both transmit and reveive data. To reduce gate count
-- we reuse the bit stuff logic and crc16 logic. The bit stuff and crc16
-- logic only looks at the usb_bs_data signal. When we are transmitting data
-- the usb_bs_data signal is the output of the parallel to serial register.
-- If we are receiving data usb_bs_data is equal to the rcv signal.
usb_bs_data <= usb_dout when txd_pstate /= TXD_WAIT or
                             (hc_en = '1' and tok_pstate /= TOK_PROC)
                        else rcv;
usb_crc_data <= par2ser_rg(0) when (txd_pstate /= TXD_WAIT) or
                    (hc_en = '1' AND rxd_pstate = RXD_WAIT) else 
                ser2par_rg(0);

--------------------------------------------------------------------------------
-- Serial to Parallel Shift logic
--------------------------------------------------------------------------------
-- Serial to parallel register shift enable
-- Always shift data except when detecting a bit stuffed '0'
-- Or when holding the SOF data until the crc and bit_stuff
-- errors have been checked.
ser2par_rg_se <= '0' WHEN (zero_stuff = '1') OR
                          (tok_pstate = TOK_EOP AND hc_en = '0')
                     ELSE '1';

-- Serial to parallel bit count enable
-- The serial to parallel count enable is active in when
-- ser2par_rg_se is active, but continues to shift during
-- the TOK_EOP state
ser2par_cnt_en <= NOT zero_stuff;

--------------------------------------------------------------------------------
-- NOTE: To conserve power might only shift portions of the shift register
--       at one time. For example in idle might only shift enough bit to detect
--       a sync, as the tok state machine process farther could enable more
--       of the shift register.
--------------------------------------------------------------------------------

-- This code implements a shift register.
-- The ser2par_rg_d is the registered into ser2par_rg.
ser2par_rg_d <= ser2par_rg(22 downto 1) & '1' & rcv when -- prepare for sync
                  tok_pstate = TOK_IDLE else             -- when in idle
                ser2par_rg(22 downto 0) & rcv when -- Shift in data
                  ser2par_rg_se = '1' else -- If shift enable true
                ser2par_rg; -- No change

-- Serial to parallel bit count load
-- The serial to parallel count load enable is active in reset and idle.
ser2par_cnt_ld <= 
  '1' when (tok_pstate = TOK_IDLE) or 
           ((tok_pstate = TOK_SYNC or rxd_pstate = RXD_SYNC) and det_sync = '1') or
           (rxd_pstate = RXD_IDLE) or 
--     (rxd_pstate = RXD_HSHK and txd_pstate = TXD_WAIT) or 
       (start_txd = '1') else '0';

-- Implements serial to parallel bit counter
-- This counter is used to count the serial bits as they are shifted
-- into the serial to parallel register. If a stuffed bit '0' is dectected
-- (i.e. ser2par_rg_se = 0) this counter will hold while the '0' is removed
-- from the serial data stream.
ser2par_cnt_d <= "000" when -- Load counter
           ser2par_cnt_ld = '1' else
                 std_ulogic_vector(unsigned(ser2par_cnt) + 1) when -- Inc
           ser2par_cnt_en = '1' else
                 ser2par_cnt; -- No change

-- Serial to parallel bit count equals 0
-- Must also include ser2par_cnt_en because it's possile that ser2par_cnt_eq0
-- could be active for two clocks if we get a bit-stuff when ser2par_cnt_eq0
-- is true. Adding the ser2par_cnt_en makes sure that this signal will only
-- be valid for one clock cycle.
ser2par_cnt_eq0 <= not ser2par_cnt(2) and not ser2par_cnt(1) and 
                   not ser2par_cnt(0) and ser2par_cnt_en;

-- Serial to parallel bit count equals 1
-- Must also include ser2par_cnt_en because it's possile that ser2par_cnt_eq1
-- could be active for two clocks if we get a bit-stuff when ser2par_cnt_eq1
-- is true. Adding the ser2par_cnt_en makes sure that this signal will only
-- be valid for one clock cycle.
ser2par_cnt_eq1 <= not ser2par_cnt(2) and not ser2par_cnt(1) and 
                   ser2par_cnt(0) and ser2par_cnt_en;

-- Serial to parallel bit count equals 2
-- Must also include ser2par_cnt_en because it's possile that ser2par_cnt_eq2
-- could be active for two clocks if we get a bit-stuff when ser2par_cnt_eq2
-- is true. Adding the ser2par_cnt_en makes sure that this signal will only
-- be valid for one clock cycle.
ser2par_cnt_eq2 <= not ser2par_cnt(2) and ser2par_cnt(1) and 
                   not ser2par_cnt(0) and ser2par_cnt_en;

-- Serial to parallel bit count equals 6
-- Must also include ser2par_cnt_en because it's possile that ser2par_cnt_eq6
-- could be active for two clocks if we get a bit-stuff when ser2par_cnt_eq6
-- is true. Adding the ser2par_cnt_en makes sure that this signal will only
-- be valid for one clock cycle.
ser2par_cnt_eq6 <= ser2par_cnt(2) and ser2par_cnt(1) and 
           not ser2par_cnt(0) and ser2par_cnt_en;

-- Serial to parallel bit count equals 7
-- Must also include ser2par_cnt_en because it's possile that ser2par_cnt_eq7
-- could be active for two clocks if we get a bit-stuff when ser2par_cnt_eq7
-- is true. Adding the ser2par_cnt_en makes sure that this signal will only
-- be valid for one clock cycle.
ser2par_cnt_eq7 <= ser2par_cnt(2) and ser2par_cnt(1) and 
           ser2par_cnt(0) and ser2par_cnt_en;

--------------------------------------------------------------------------------
-- Parallel to Serial Shift logic
--------------------------------------------------------------------------------
-- Parallel to serial register load enable
par2ser_rg_ld <= 
  '1' when (hc_en = '1' and 
            (tok_pstate = TOK_IDLE or
             hc_ls_timing_set = '1' or
             (ser2par_cnt_eq7 = '1'  and
              tok_pstate /= TOK_PROC and
              tok_pstate /= TOK_WAIT))) or
           (txd_pstate = TXD_WAIT  and tok_pstate = TOK_PROC) or 
           (ser2par_cnt_eq7 = '1' and
            ((txd_pstate = TXD_SYNC) or (txd_pstate = TXD_PID) or
             (txd_pstate = TXD_DATA) or (txd_pstate = TXD_CRC16L) or
             (txd_pstate = TXD_PRE)  or (txd_pstate = TXD_LSDLY) or
             (txd_pstate = TXD_CRC16H))) else
  '0';

-- Parallel to serial register shift enable
-- Always shift data except when detecting a bit stuffed '0'
par2ser_rg_se <= '0' when (zero_stuff = '1') or
                      (txd_pstate = TXD_DELAY)
             else -- Do not shift in this state
             '1';

-- This code implements a the parallel to serial shift register.
-- Data to be transmitted is loaded in this register then shifted out serially.
par2ser_rg_d <= transmit_data                when -- Load data
                  par2ser_rg_ld = '1' else        -- when load enable true
                "0" & par2ser_rg(7 downto 1) when -- Shift out data
                  par2ser_rg_se = '1' else        -- when shift enable true
                par2ser_rg; -- No change

-- set an interrupt if a STALL handshake has been sent.
tgt_stall_set <= endpt_stall WHEN (txd_pstate = TXD_PID) else '0';

-- Tx Data Packet pid data
txd_pid_data  <= 
  PID_SOF   when (hc_en = '1' and tok_pstate = TOK_SYNC and 
                  hc_sof_req = '1') else -- host SOF transmit packet
  PID_PRE   when  (hc_en = '1' and
                   (tok_pstate = TOK_SYNC OR txd_pstate = TXD_SYNC) and 
                   low_speed_req = '1' AND hc_ls_timing = '0') 
                  else -- host PRE_PID prefix to low speed dev
  hc_token_pid when (hc_en = '1' and tok_pstate = TOK_SYNC and 
                  hc_sof_req = '0') else -- host token packet
  PID_DATA0 when (rxd_pstate = RXD_WAIT) and 
                 endpt_stall = '0' and ((own = '1' and data01 = '0') or -- DATA0
                            endpt_hshk = '0' ) else -- ISO endpoints use DATA0
  PID_DATA1 when (rxd_pstate = RXD_WAIT) and 
               own = '1' and endpt_stall = '0' and data01 = '1' else -- DATA1
  PID_STALL when endpt_stall = '1' AND current_token /= PID_SETUP else -- STALL
  PID_NAK   when own = '0' or rx_overrun_nak = '1' else -- NAK
  PID_ACK   when own = '1' else --ACK
  "XXXX";

-- Transmit done
-- We are done transmiting when the DMA engine byte count has reached 0 and
-- the Tx FIFO is empty and contains no valid data.
transmit_done <= '1' when byte_count_eq = '1' and tx_empty = '1' and 
                          tx_valid = '0' else '0';

-- Transmit host data
hc_tx_data  <= frame_num when hc_sof_req = '1' else
               hc_token_endpt & usb_addr;
hc_txd_byte <= hc_tx_data(7 downto 0) when tok_pstate = TOK_PID else
               hc_tx_data(7 downto 3) & hc_tx_data(10 downto 8);
-- Transmit data
transmit_data <= 
  "11111111" when zero_stuff_inhibit = '1' or 
                  force_bit_stuff_err = '1' else --force_bit_stuff_error
  "10000000" when hc_ls_timing_set = '1' else  -- Sync byte for low speed
  not txd_pid_data & txd_pid_data  when txd_pstate = TXD_SYNC or 
                 (tok_pstate = TOK_SYNC and hc_en = '1') else
  hc_txd_byte when (hc_en = '1') and 
                  (tok_pstate = TOK_PID or tok_pstate = TOK_BYTE0) else
  tx_rdata  when (txd_pstate = TXD_PID) or (txd_pstate = TXD_DATA) else
  "10000000"; -- Sync byte

-- Tx FIFO read enable
tx_re     <= tx_fif_re;
tx_fif_re <= '1' when clk_en = '1' and ser2par_cnt_eq7 = '1' and 
                  ((txd_pstate = TXD_PID) or (txd_pstate = TXD_DATA))  and
                  transmit_done = '0' and own = '1' and endpt_stall = '0' and
                  out_handshake_en  = '0' 
                 else '0';
-- On FIFO underrun force a bit stuff error.
force_bit_stuff_err <= tx_fif_re and tx_empty;

-- FIFO flush enable
flush <= det_rst OR dma_rd_bdt;       -- clear the rx and tx FIFOs when loading a new
                                      -- DMA descriptor
-- USB address equals
-- Must make sure that the address within the token equals our current address.
--usb_addr_eq <= '1' when usb_addr = ser2par_rg(16 downto 10) else '0';
usb_addr_eq_d <= '1' when usb_addr = ser2par_rg(4) & ser2par_rg(5) &
                 ser2par_rg(6) & ser2par_rg(7) & ser2par_rg(8) & ser2par_rg(9) &
                 ser2par_rg(10) else '0'; 

-- Token processing enable
token_proc_en <= '1' when
  -- SETUP TOKENS (control endpoints must enable in and out and handshake)
  (endpt_out_en = '1' and endpt_in_en = '1' and endpt_hshk = '1' and
   endpt_ctl_dis= '0' and current_token = PID_SETUP) or
  -- RX DATA PACKETS
  (endpt_out_en = '1' and current_token = PID_OUT) or
  -- TX DATA PACKETS
  (endpt_in_en  = '1' and current_token = PID_IN) else 
  '0';

-- In handshake enable
in_handshake_en <= '1' when (txd_pstate = TXD_HSHK) else '0'; 

-- Out handshake enable
out_handshake_en <= '1' when (rxd_pstate = RXD_HSHK) else '0'; 

-- Load current token register
current_token_ld <= 
  '1' when (tok_pstate = TOK_PID) and ser2par_cnt_eq7 = '1' else '0'; 

-- Load current endpoint register
current_endpt_ld <= 
--  '1' when (tok_pstate = TOK_BYTE1) and ser2par_cnt_eq7 = '1' else '0'; 
  '1' when (tok_pstate = TOK_BYTE1) and ser2par_cnt_eq2 = '1' else '0'; 

-- Last bit stuff enable
last_bit_stuff_en <= '1' when usb_bs_data = '1' and one_bit_cnt = "101" and 
                         ser2par_cnt_eq7 = '1' else 
                     '0';  

--------------------------------------------------------------------------------
-- Bit stuff logic
--
-- This logic will count the number of 1's received. When this count reaches
-- 6 the next bit should be a '0'. If so this bit should be removed from the
-- receive data stream. If the next bit is not a '0' then a bit stuff error
-- has occurred.
--------------------------------------------------------------------------------

-- One bit count load enable
-- Reset this counter whenever we are in reset state or we detect a
-- received '0' bit, otherwise it will always count. If this counter
-- ever reaches 7 and we are not in ILDE then a bit stuff error has occured.
one_bit_cnt_ld <= '1' when (tok_pstate = TOK_IDLE) or (tok_pstate = TOK_EOP) or
                           (rxd_pstate = RXD_IDLE) or (rxd_pstate = RXD_EOP) or
                           (rxd_pstate = RXD_HSHK) or 
                           (zero_stuff = '1') OR   -- We just stuffed a bit
                           (usb_bs_data = '0') OR  -- the input transitioned
                           (se0 = '1')             -- the packet ended.
                      else
                  '0';

                  
zero_stuff <= '1' when one_bit_cnt = "110" and 
                       zero_stuff_inhibit = '0' else '0';

one_bit_cnt_d <= "000" when one_bit_cnt_ld = '1' else -- Load start count
                 std_ulogic_vector(unsigned(one_bit_cnt) + 1); -- Inc
                 
bts_err_set <= '1' when ((hc_en = '0' AND
                          (tok_pstate = TOK_PID or 
                           tok_pstate = TOK_BYTE0 or tok_pstate = TOK_BYTE1 or
                           tok_pstate = TOK_EOP)) or
                         rxd_pstate = RXD_SYNC or rxd_pstate = RXD_PID or 
                         rxd_pstate = RXD_BYTE0 or rxd_pstate = RXD_BYTE1 or 
                         rxd_pstate = RXD_BYTE2 or rxd_pstate = RXD_EOP) and
                        zero_stuff = '1' and (rcv = '1' or SE0 = '1') and clk_en = '1'
                   else '0';
                 
dma_rd_bdt <= dev_dma_rd_bdt or hc_dma_rd_bdt;

--------------------------------------------------------------------------------
--
--     Process: rx_srst_regs -- Receive registers
--
--  Parameters: clk     -- Clock
--
-- Description: This process implements the USB SIE receive registers
--  and synchronization flip flops with syncronous resets.
--
--------------------------------------------------------------------------------
rx_srst_regs: process (clk) --vsync_rst
--vasync_rst rx_srst_regs: process (clk,srst) 
begin
--vasync_rst if srst = '1' then
if clk'event and (clk = '1') then --vsync_rst
 if srst = '1' then --vsync_rst
    tok_pstate <= TOK_IDLE; -- Goto to reset state
    txd_pstate <= TXD_WAIT; -- Goto to wait state
    rxd_pstate <= RXD_WAIT; -- Goto to wait state
    rx_overrun_nak <= '0';  -- Clear FIFO overrun error
    mcek_cnt <= "00000";
    own <= '0';
    own_ok_suspend <= '0';
    bit_stuff_err <= '0';
    dma_re_rd_bdt <= '0';
    frame_num <= "000" & "00000000";
    lseop_en <= '0';
    sof_cnt_clr0 <= '0';
    sof_cnt_clra <= '0';
else --vsync_rst
--vasync_rst elsif clk'event and clk = '1' then 
 if clk_en = '1' then

  -- Register token state machine state bits
  if det_rst = '1' OR hc_reset = '1' then -- If reset active
    tok_pstate <= TOK_IDLE; -- Goto to reset state
  else
    tok_pstate <= tok_nstate; -- Else update pstate
  end if;
  
  -- Register tx data packet state machine state bits
  if det_rst = '1' OR hc_reset = '1' then -- If reset active
    txd_pstate <= TXD_WAIT; -- Goto to wait state
  else
    txd_pstate <= txd_nstate; -- Else update pstate
  end if;

  -- Register rx data packet state machine state bits
  if det_rst = '1' OR hc_reset = '1' then -- If reset active
    rxd_pstate <= RXD_WAIT; -- Goto to wait state
  else
    rxd_pstate <= rxd_nstate; -- Else update pstate
  end if;

  -- Register the Rx data overrun errors so that a NAK may be generated.
  if txd_pstate = TXD_EOP then 
    rx_overrun_nak <= '0';                    -- clear when a packet is sent
  elsif rx_fif_we = '1' AND rx_full = '1' and -- set on a write to a full FIFO
        endpt_hshk = '1' then                 -- if not an ISO endpoint
    rx_overrun_nak <= '1';               
  end if;

-- SIE counter
-- This counter times 3 different events
--  1) USB reset:  SE0 is asserted for 2.5 us.
--  2) USB attach: SE0 is false and rcv doesn't move for 2.5 us
--  3) USB Buss Time Out (BTO) if the bus is idle for 2.5 us when expecting rcv
--     data or acknoledge.
--  4) USB LS EOP: When in host controller mode this counter is used to 
--     generate a LS EOP to terminate resume signaling.
-- In any of these cases the counter is enabled when there are no transitions
-- and is cleared on a transition.
  if mcek_cnt_clr = '1' then
    mcek_cnt <= "00000";
  else 
    mcek_cnt <= std_ulogic_vector(unsigned(mcek_cnt) + 1);
  end if;

  -- Develope 2 cycle wide sof_clr pulse to send to the clken_12 domain
  sof_cnt_clr0 <= mcek_cnt_clr;
  sof_cnt_clra <= mcek_cnt_clr OR sof_cnt_clr0;

  -- BDT own control bit
  -- The bdt own bit is sampled once during each transaction. It must be
  -- valid by the time own_ld is active, or we will assume we do not own
  -- the bdt and take the approriate action.
  if own_ld = '1' then
    -- if txd is suspended respond to any non ISO token as if the interface is not
    -- ready. 
    IF txd_suspend = '1' AND endpt_hshk = '1' then
      own <= '0';
    else
      own <= own_d;
    end if;
  end if;

  -- Suspend the BDT caching operation when txd_suspend is asserted, and make
  -- sure that a new BDT is read before allowing it to be cached.
  if txd_suspend = '1' then
    own_ok_suspend <= '1';
  elsif dma_rd_bdt = '1' then
    own_ok_suspend <= '0';
  end if;

  -- bit stuff error in this packet
  if tok_pstate = TOK_SYNC or -- clear at start of packet
        rxd_pstate = RXD_SYNC then
    bit_stuff_err <= '0';
  elsif bts_err_set = '1' then    -- set on error detection.
    bit_stuff_err <= '1';
  end if;

  --  DMA BDT re-read request - set when there is an error in the data packet
  --  transmition to force a the DMA registers to be reloaded.
  if dma_rd_bdt = '1' then
    dma_re_rd_bdt <= '0';
  elsif reject_rx_dat_set = '1' or reject_tx_dat_set = '1' then
    dma_re_rd_bdt <= '1';
  end if;    
  
  -- Current frame number register 
  frame_num <= frame_num_d;

  --  DMA BDT re-read request - set when there is an error in the data packet
  if clr_lseop_en = '1' then
    lseop_en <= '0';
  elsif set_lseop_en = '1' then
    lseop_en <= '1';
  else
    lseop_en <= lseop_en;
  end if;
  
 end if; -- clk_en
 end if; -- srst  --vsync_rst
end if; -- clk'event and (clk = '1')
end process rx_srst_regs;    -------------------------------------------------

-- Set LS EOP enable
set_lseop_en <= not resume_req_f and resume_req_ff;

-- Clear LS EOP enable
clr_lseop_en <= '1' when hc_en = '0' or resume_req = '1' or 
                        (lseop_en = '1' and mcek_cnt = "01111") else 
                '0';

--------------------------------------------------------------------------------
--
--     Process: rx_regs -- Receive registers
--
--  Parameters: clk     -- Clock
--
-- Description: This process implements the USB SIE receive registers
--  and synchronization flip flops without syncronous resets.
--
--------------------------------------------------------------------------------
rx_regs: process (clk)
begin

--  wait until clk'event and (clk = '1');
if clk'event and (clk = '1') then
 if clk_en = '1' then

  -- Pulse generator for resume signaling
  resume_req_ff <= resume_req_f;
  resume_req_f  <= resume_req;

 -- Pulse streaching registers for Hub interface siganls
  pre_pid_det_f    <= pre_pid_det_d;   -- Low Speed Preamble detected.
  pre_pid_det_ff   <= pre_pid_det_f;
  valid_sof_pid_f  <= valid_sof_pid_d; -- Valid SOF PID detected
  valid_sof_pid_ff <= valid_sof_pid_f; 
  sie_se0_req_f    <= usb_se0_req;       -- SIE generated an EOP
  -- Falling edge detector on sie_se0_req for
  sie_eop_out   <= sie_se0_req_f and not usb_se0_req;   -- SIE generated an EOP
 
  -- Register the Rx and Tx packet reject signals
  if tok_pstate = tok_idle then
    reject_rx_datpkt <= '0';
  elsif reject_rx_dat_set = '1' then
    reject_rx_datpkt <= '1';
  end if;
  
  if tok_pstate = tok_idle then
    reject_tx_datpkt <= '0';
  elsif reject_tx_dat_set = '1' then
    reject_tx_datpkt <= '1';
  end if;

  se0_f <= se0;                          -- registered copies for transition
  jstate_f <= jstate;                    -- detection. 

 
  -- Endpoint tx data packet enabled (Input endpoint)
  endpt_ctl_dis <= endpt_ctl_dis_d;

  -- Endpoint tx data packet enabled (Input endpoint)
  endpt_in_en <= endpt_in_en_d;

  -- Endpoint rx direction
  endpt_out_en <= endpt_out_en_d;

  -- Endpoint enabled
  endpt_hshk <= endpt_hshk_d; 
  
  -- Serial to parallel shift register
  ser2par_rg <= ser2par_rg_d;

  -- Parallel to serial register 
  par2ser_rg <= par2ser_rg_d;

  -- Implements serial to parallel bit counter
  ser2par_cnt <= ser2par_cnt_d;

  -- One bit count register
  one_bit_cnt <= one_bit_cnt_d;

  -- Bit stuff disable for packet cancelation.
  if srst = '1' then --reset
    zero_stuff_inhibit <= '0';
  elsif txd_pstate = TXD_EOP then        -- clear after a bit should have
    zero_stuff_inhibit <= '0';           -- been stuffed
  elsif force_bit_stuff_err = '1' then   -- set when error is forced
    zero_stuff_inhibit <= '1';
  end if;

  -- USB reset enable
  usb_rst_en <= usb_rst_en_d; 

  -- Current token register
  current_token <= current_token_d;
  -- Current_token comparitor
  if current_token_ld = '1' then
    if current_token = current_token_d then
      current_token_eq <= '1';
    else
      current_token_eq <= '0';
    end if;
  end if;
  
  -- Current endpoint register 
  current_endpt <= current_endpt_d; 
  -- Current_token comparitor
  if current_endpt_ld = '1' then
    if current_endpt = current_endpt_d then
      current_endpt_eq <= '1';
    else
      current_endpt_eq <= '0';
    end if;
  end if;
  
  -- USB address equals 
  if current_endpt_ld = '1' then 
    usb_addr_eq <= usb_addr_eq_d;
  else
    usb_addr_eq <= usb_addr_eq;
  end if;

  -- Out data01 pid register 
  out_data01_pid <= out_data01_pid_d;

  -- Register USB output enable 
  usboe_df <= usboe_d;          -- assert the OE for one idle clock 
  usboe <= usboe_d or usboe_df; -- after EOP or reset_request.

  -- Register USB outputs
  idmo <= idmo_d;
  idpo <= idpo_d;

  -- Implements CRC5 register
  if crc5_data_ld = '1' then
    crc5_data <= nxt_crc5_data; -- Update crc data
  else
    crc5_data <= crc5_data; -- No change
  end if;
  
  -- Implements CRC16 register
  if crc16_data_ld = '1' then
    crc16_data <= nxt_crc16_data; -- Update crc data
  else
    crc16_data <= crc16_data; -- No change
  end if;

 end if; -- srst / clk_en = '1' then
end if; -- clk'event and (clk = '1') then
end process rx_regs;    -------------------------------------------------

hc_ls_timing <= low_speed_req;
hc_ls_timing_set <= '0';
hc_dma_rd_bdt <= '0';
hc_no_retry <= '0';
hc_token_inhibit <= '0';
hc_token_busy <= '0';
hc_sof_req <= '0';
hc_sof_req_f <= '0';
hc_sof_req_set <= '1';
bdt_wrt_pid <= current_token;
hc_reset <= '0';
low_speed_en <= low_speed_req;

--------------------------------------------------------------------------------
--
--  Process: sof_regs    -- SOF registers
--
--  Parameters: clk_sof  -- Clock
--
--  Description: This process implements the SOF register. This consists of a 
--              host frame timer. The host frame timer has to different modes
--              of operation depending if you are operating in host controller
--              mode or not. When operating in host controller mode (i.e. 
--              hc_en=1) the hc_sof_cnt is used to determine when to issue a
--              SOF. When operating in device mode (i.e. hc_en=0) it is used
--              to determine when to set the sleep interrupt. When it counts 3
--              ms of inactivity the sleep interrupt will be set.
--
--------------------------------------------------------------------------------
sof_regs: process (clk_sof)
begin

  if clk_sof'event and (clk_sof = '1') then
    if srst = '1'  then -- synchronous resets
      sof_cnt_clr <= '0';
      if hc_en = '0' then
        if lsdev = 1 then
          hc_sof_cnt <= SUSPEND_TERM_CNT_LS;
        else
          hc_sof_cnt <= SUSPEND_TERM_CNT_HS;
        end if;
      else
        hc_sof_cnt <= SOF_TERM_CNT_HS;
      end if;

    elsif clken_12 = '1' then
      sof_cnt_clr <= sof_cnt_clra;

      -- If not in host controller mode operate as a USB sleep counter
      if hc_en = '0' then
        if sof_cnt_clr = '1' then
          if lsdev = 1 then
            hc_sof_cnt <= SUSPEND_TERM_CNT_LS;
          else
            hc_sof_cnt <= SUSPEND_TERM_CNT_HS;
          end if;
        elsif hc_sof_cnt /= "11111111" & "11111111" then
          hc_sof_cnt <= std_ulogic_vector(unsigned(hc_sof_cnt) - 1);
        else
          hc_sof_cnt <= hc_sof_cnt;
        end if;
      else
        -- We are operating in host controller mode run as a SOF frametimer
        if det_rst = '1' or hc_reset = '1' or
           hc_sof_cnt = "11111111" & "11111111" then
          hc_sof_cnt <= SOF_TERM_CNT_HS;
        else
          hc_sof_cnt <= std_ulogic_vector(unsigned(hc_sof_cnt) - 1);
        end if;
      end if;
      
 -- generate a minimum two cycle wide terminal count to pass from the clken12 
 -- domain to the clken_dpll domain.
      if hc_sof_cnt(15 downto 1) = "00000000" & "0000000" then
        hc_sof_tc <= '1';
      elsif hc_sof_req_set = '1' OR hc_en = '0' then   -- hold until registered
        hc_sof_tc <=  '0';                         -- in the clken_dpll domain.
      end if;

    end if; -- srst / clken_12 = '1' then
  end if; -- clk_sof'event and (clk_sof = '1') then
  
end process sof_regs;

 -- generate a two cycle wide terminal count to pass from the clken12 domain to
 -- the clken_dpll domain.

hc_sof_err_set <= hc_en -- issue an error interrupt if a transfer is in progress
                        -- when the SOF packet is supposed to be sent.
                  when  (hc_sof_req = '1' AND hc_sof_req_f = '0' AND 
                        (tok_pstate /= tok_idle))
                  else '0';

         -- In host mode set the sof interrupt when the SOF threshold is reached 
hc_sof_thld_set <= '1' when (hc_en = '1' and
                             hc_token_inhibit = '1' AND 
                             hc_token_inhibit_f = '0' AND 
                             clk_en = '1')
                    else '0';

-- single ended zeros are used to signal reset and end of packet
usb_se0_req <= '1' when (txd_pstate = TXD_EOP) or  -- data end of packet
           (tok_pstate = TOK_EOP and hc_en = '1' AND zero_stuff = '0') or -- token end of packet
           (hc_rst_req = '1' and hc_en = '1') or
           (lseop_en = '1' and hc_en = '1') else
           '0';
           
-- The J-state is the idle state on usb.
usb_jstate_req <= '1' when (srst = '1') or 
                 ((resume_req_ff = '0' and  
                  ((txd_pstate = TXD_WAIT) or 
                   (txd_pstate = TXD_DELAY) or
                   (txd_pstate = TXD_HSHK) or
                   (txd_pstate = TXD_DONE))) and 
                  not (hc_en = '1' and not
                   (tok_pstate = TOK_IDLE or -- host token states that don't
                    tok_pstate = TOK_PROC or -- drive the USB
                    tok_pstate = TOK_WAIT))) or
                 (hc_en = '1' and        -- special case for driving jstate 
                  hc_ls_timing = '0' and -- between the low speed preamble
                  low_speed_req = '1' and-- and the low speed packet
                  hc_sof_req = '0' and
                  (tok_pstate = TOK_BYTE0 or
                   txd_pstate = TXD_LSDLY))
              else '0';

-- The K-state is the resume state on usb.
usb_kstate_req <= '1' when resume_req_ff = '1' else '0';

-- USB output enable data
usboe_d <= '1' when (not
                     (txd_pstate = TXD_WAIT or   -- Tx Data states that
                      txd_pstate = TXD_DELAY or  -- don't drive the USB
                      txd_pstate = TXD_HSHK or 
                      txd_pstate = TXD_DONE)) or
                    (resume_req_ff = '1') or
                    (hc_en = '1' and 
                     (hc_rst_req = '1' or lseop_en = '1' or not
                      (tok_pstate = TOK_IDLE or -- host token states that don't
                       tok_pstate = TOK_PROC or -- drive the USB
                       tok_pstate = TOK_WAIT)))
               else '0';

-- USB data minus out data

-- low_speed_signaling - This signal causes the SIE to invert the
--               signaling of the J and K bus states for low speed signalling.

idmo_d <= '0' when usb_se0_req = '1' or 
                   (low_speed_signaling = '0' and usb_jstate_req = '1') or
                   (low_speed_signaling = '1' and usb_kstate_req = '1') else
          '1' when (low_speed_signaling = '1' and usb_jstate_req = '1') or
                   (low_speed_signaling = '0' and usb_kstate_req = '1') else
          not usb_nrzo;
          
-- USB data plus out data
idpo_d <= '0' when usb_se0_req = '1' or 
                   (low_speed_signaling = '1' and usb_jstate_req = '1') or
                   (low_speed_signaling = '0' and usb_kstate_req = '1') else
          '1' when (low_speed_signaling = '0' and usb_jstate_req = '1') or
                   (low_speed_signaling = '1' and usb_kstate_req = '1') else
          usb_nrzo;

-- Low speed signaling is true if constant in cfg_usb is true or we are a
-- point to point single port root hub and low_speed_req is true.
low_speed_signaling <= '1' WHEN lsdev = 1
                  else '0' WHEN hc_en = '1' AND host_wo_hub = '0'
                  else low_speed_req;     -- this term allow devices to become
                                          -- low speed under software control
-- USB data dout
-- This is the USB serial transmit data that must be NRZI encoded.
usb_dout <= '0' when zero_stuff = '1' else 
            not crc16_data(15) when (txd_pstate = TXD_CRC16L) or 
                                    (txd_pstate = TXD_CRC16H) else 
            not crc5_data(4)   when (crc5_data_se = '1') else
            par2ser_rg(0);
            
usb_nrzo <=     idpo when usb_dout = '1' else
            not idpo;

-- Current token register write data
pid_field <= ser2par_rg(4) & ser2par_rg(5) & ser2par_rg(6) & ser2par_rg(7);
current_token_d <= hc_token_pid  when hc_en = '1' else
                   pid_field when current_token_ld = '1' and pid_chk_ok = '1' else
                   "0000"    when current_token_ld = '1' and pid_chk_ok = '0' else 
                                  current_token;

-- Current endpoint register write data
current_endpt_d <= 
  "0000"  when hc_en = '1' else
  ser2par_rg(0) & ser2par_rg(1) & ser2par_rg(2) & 
  ser2par_rg(3) when current_endpt_ld = '1' else 
  current_endpt;

--  ser2par_rg(5) & ser2par_rg(6) & ser2par_rg(7) & 
--  ser2par_rg(8) when current_endpt_ld = '1' else 
--  current_endpt;

-- Out data01 pid register
-- Store SETUP and Rx Data Packet data pid values.
out_data01_pid_d <=
  '0'           when srst = '1' else
  ser2par_rg(4) when txd_pstate = TXD_WAIT and rxd_pstate = RXD_PID and 
                     ser2par_cnt_eq7 = '1' else 
  out_data01_pid;

-- Current frame number write data
frame_num_d <=                           -- In device mode capture the frame number.
      ser2par_rg(6)  & ser2par_rg(7)  & ser2par_rg(8)  & ser2par_rg(9)  & 
      ser2par_rg(10) & ser2par_rg(11) & ser2par_rg(12) & ser2par_rg(13) & 
      ser2par_rg(14) & ser2par_rg(15) & ser2par_rg(16)
  when frame_num_ld = '1' AND hc_en = '0' else
      std_ulogic_vector(unsigned(frame_num) + 1)            -- in host mode increment the frame number.
  when hc_sof_req = '1' and hc_sof_req_f = '0' -- on rising edge of request.
  else frame_num;

--------------------------------------------------------------------------------
-- SIE counter signals
--------------------------------------------------------------------------------
-- NOTE: After plug fest might want to investigate if usb_sie can get away with
--       only one counter to check for resets, bit_stuff, and bto's!
-- Counter data
--cnt_d <= "00000" when srst = '1' or (cnt_en = '1' and cnt_en_d1 = '0') else
--         unsigned(cnt) + 1 when cnt_en = '1' else
--   cnt -- No change

-- Misc Counter clear
-- This counter times 3 different events
--  1) USB resets is SE0 is asserted for 2.5 us.
--  2) USB attach is SE0 is false and rcv doesn't move for 2.5 us
--  3) USB Buss Time Out (BTO) if the bus is idle for 2.5 us when expecting rcv
--     data or acknoledge.
--  4) USB LS EOP: When in host controller mode this counter is used to 
--     generate a LS EOP to terminate resume signaling.
-- In any of these cases the counter is enabled when there are no transitions
-- and is cleared on a transition.

mcek_cnt_clr <= (NOT lseop_en and        -- When not a resume LS EOP
                (usboe_d or usboe_df or  -- when we are transmitting the counter
                                         -- is cleared.
                (se0 xor se0_f))) or     -- a transition on SE0 can resets the
                                         -- USB RESET counter
                (NOT se0 and NOT se0_f AND
                 (jstate XOR jstate_f)); -- a transition on the USB siganls
                                         -- restarts the BTO and ATTACH counter
 
--cnt_en <= '1' when det_se0 = '1' or (rxd_pstate = RXD_IDLE) else
--          '0'; 

--------------------------------------------------------------------------------
-- CRC5 logic
--------------------------------------------------------------------------------
crc5_okay <= '1' when crc5_data = "01100" else
             '0' ;


crc5_data_ld <= ser2par_rg_se;

-- shift the crc data out in hc mode into the crc5 field
crc5_data_se <= '1' when hc_en = '1' and 
                        (tok_pstate = TOK_BYTE1) and --byte 1
                        (ser2par_cnt(2) = '1' or     -- bits 3 thru 7
                         (ser2par_cnt(1) ='1' and ser2par_cnt(0) ='1'))
                else '0';

crc5_data_clr <=  '1' when (tok_pstate = TOK_PID) else '0';
-- This logic will set nxt_crc5_data=1f\h when we detect a flag else it
-- will compute the crc value.
nxt_crc5_data <= -- Compute next crc high data byte
  "11111" when crc5_data_clr = '1' else
  crc5_data(3 downto 0) & '1' when crc5_data_se = '1' else -- shift enable
  -- Compute crc data
  crc5_data(3) &  -- bit 4
  crc5_data(2) &  -- bit 3
  (crc5_data(1) xor crc5_data(4) xor usb_crc_data) &  -- bit 2
--  (crc5_data(1) xor crc5_data(4) xor ser2par_rg(0)) &  -- bit 2
  crc5_data(0) &  -- bit 1
--  (ser2par_rg(0) xor crc5_data(4)); -- bit 0
  (usb_crc_data xor crc5_data(4)); -- bit 0

--------------------------------------------------------------------------------
-- CRC16 logic
--------------------------------------------------------------------------------
crc16_okay <= '1' when crc16_data = "1000000000001101" else '0';

-- CRC16 data load enable when srst active, during data control state Tx_OFLG, 
-- or when crc_data_comp oTx_DATA, 
-- Tx_CRCL, and Tx_CRCH.
crc16_data_ld <= 
  '1' when (srst = '1') or (txd_pstate = TXD_PID) or (rxd_pstate = RXD_PID) or
           (ser2par_rg_se = '1' and 
           (crc16_data_comp = '1' or crc16_data_se = '1')) else '0';

-- CRC16 data compute enable during data control state Tx_DATA.
crc16_data_comp <= '1' when 
  (rxd_pstate = RXD_BYTE0) or
  (rxd_pstate = RXD_BYTE1) or
  (rxd_pstate = RXD_BYTE2) or
  (txd_pstate = TXD_DATA) 
  else '0';

-- CRC16 data shift enable during tx data packet states TXD_CRC16L or TXD_CRC16H.
crc16_data_se <= '1' when 
  ((txd_pstate = TXD_CRC16L) or (txd_pstate = TXD_CRC16H)) else '0';

--  (bit_stuff_en = '0' and ((dtx_ctl_pres_state = Tx_CRCL) or 
--  (dtx_ctl_pres_state = Tx_CRCH))) else '0';

-- This logic computes the next CRC data based on CRC data shift enable, CRC
-- data compute enable else it loads FFFF\h.
nxt_crc16_data <= -- Compute next crc data
  crc16_data(14 downto 0) & '1' when crc16_data_se = '1' else -- Shift out CRC data
  comp_crc16_data               when crc16_data_comp = '1' else -- Compute CRC data
  "1111111111111111"; -- Else force to 1F\h

-- Compute crc data
-- This logic will compute the crc on transmitted data.
comp_crc16_data <= 
  (crc16_data(14) xor crc16_data(15) xor usb_crc_data) & -- bit 15
  crc16_data(13) & -- bit 14
  crc16_data(12) & -- bit 13
  crc16_data(11) & -- bit 12
  crc16_data(10) & -- bit 11
  crc16_data(9) &  -- bit 10
  crc16_data(8) &  -- bit 9
  crc16_data(7) &  -- bit 8
  crc16_data(6) &  -- bit 7
  crc16_data(5) &  -- bit 6
  crc16_data(4) &  -- bit 5
  crc16_data(3) &  -- bit 4
  crc16_data(2) &  -- bit 3
  (crc16_data(1) xor crc16_data(15) xor usb_crc_data) &  -- bit 2
  crc16_data(0) &  -- bit 1
  (usb_crc_data xor crc16_data(15)); -- bit 0

--------------------------------------------------------------------------------
--
--     Process: tok_nsl          -- Token state machine next state logic
--
-- Parameters:  tok_pstate       -- Token state machine present state bits
--              crc5_okay        -- CRC5 okay
--              det_eop          -- Detect end of packet
--              det_se0          -- Detect single ended zero
--              det_sync         -- Detect USB sync
--              rcv              -- USB Receive Data
--              reject_rx_dat_set -- Reject rx data packet enable--              
--              reject_tx_dat_set  -- Reject tx data packet enable
--              rx_datpkt_done   -- Rx Data Packet process done
--              ser2par_cnt      -- Serial to parallel bit count
--              ser2par_cnt_eq7  -- Serial to parallel bit count equals 7
--              sof_pid          -- SOF pid detect
--              token_proc_en    -- Token processing enable
--              tx_datpkt_done    -- Tx Data Packet process done
--              usb_addr_eq      -- USB address equals
--              valid_token_pid  -- Valid token PID
--
-- Description: This process implements next state logic for the token
--  processing state machine.
--
-- State Diagram: TBD
--
--------------------------------------------------------------------------------

tok_nsl: process (bdt_valid, bit_stuff_err, crc5_okay, current_token, det_eop,
                  det_se0, det_sync, dma_re_rd_bdt, hc_en, hc_ls_timing,
                  hc_sof_req, hc_token_busy, hc_token_inhibit, low_speed_req,
                  hc_no_retry, hc_retry_disable, host_wo_hub, own_d, own_ok, rcv,
                  reject_rx_datpkt, reject_tx_datpkt, rx_datpkt_done,
                  rxd_pstate, ser2par_cnt, ser2par_cnt_eq1, ser2par_cnt_eq7,
                  sof_pid, tok_pstate, token_proc_en, tx_datpkt_done,
                  txd_pstate, usb_addr_eq, valid_token_pid )

begin

  -- SIE DMA requests default output values
  tok_nstate <= TOK_IDLE;
  dev_dma_rd_bdt   <= '0'; -- device DMA read BDT (4 bytes) 
  dma_wrt_bdt  <= '0'; -- DMA write BDT (4 bytes)
  hc_token_done <= '0'; -- embedded host token transaction complete
  txd_suspend_set <= '0'; -- set the transmit suspend register.
  endpt_stall_clr <= '0';    -- clear the protocol stall on receipt
  dfn8_err_tok <= '0';    -- don't set the dfn8 error indication
  tok_ls_timing_set <= '0'; -- leave the low speed timing alone.

  -- Load current frame number register
  frame_num_ld <= '0';  

  case tok_pstate is

    -- When present state is token idle state
    when TOK_IDLE =>
      if hc_en = '1' then -- host operation
        if txd_pstate = TXD_WAIT and rxd_pstate = RXD_WAIT and
           ((hc_token_busy = '1' and hc_token_inhibit = '0' and 
             own_d = '1' and bdt_valid = '1') or 
            hc_sof_req = '1' )then
          tok_nstate <= TOK_SYNC; -- Goto token sync state
        else -- no host requsests active
          tok_nstate <= TOK_IDLE; -- Stay here
        end if; -- hc_token_busy
      else -- target / device operation
        -- If detect a change on rcv
        if rcv = '0' then
          tok_nstate <= TOK_SYNC; -- Goto token sync state
        else
          tok_nstate <= TOK_IDLE; -- Stay here
        end if;
      end if; -- hc_en

    -- When present state is token sync state
    when TOK_SYNC =>
      if hc_en = '1' then -- host operation
        if ser2par_cnt_eq7 = '1' then
          tok_nstate <= TOK_PID; -- Goto token wait state
        else
          tok_nstate <= TOK_SYNC; -- Stay here
        end if; -- ser2par_cnt_eq7
      else -- target / device operation
        -- If false eop abort token
        if det_se0 = '1'  then
          tok_nstate <= TOK_WAIT; -- Goto token wait state
        -- If detect a sync
        elsif det_sync = '1' then
          tok_nstate <= TOK_PID; -- Goto token pid state
        else
          tok_nstate <= TOK_SYNC; -- Stay here
        end if;
      end if;  -- hc_en

    -- When present state is token pid state
    when TOK_PID =>
      if hc_en = '1' then -- host operation
        if ser2par_cnt_eq7 = '1' then
          tok_nstate <= TOK_BYTE0; -- Goto token byte0 state
        else
          tok_nstate <= TOK_PID; -- Stay here
        end if; -- ser2par_cnt_eq7
      else -- target / device operation
        -- If false eop or not a valid token equal abort token
        if det_se0 = '1' or (ser2par_cnt_eq7 = '1' and valid_token_pid = '0') or
           bit_stuff_err= '1' then -- bit stuff error
          tok_nstate <= TOK_WAIT; -- Goto token wait state
          IF det_se0 = '1' AND ser2par_cnt_eq7 = '0' then
            dfn8_err_tok <= '1';         -- set the dfn8 error indication
          END IF;
        -- Make sure we have received a valid token
        elsif ser2par_cnt_eq7 = '1' and valid_token_pid = '1' then
          tok_nstate <= TOK_BYTE0; -- Goto token byte0 state
        else
          tok_nstate <= TOK_PID; -- Stay here
        end if;
      end if;  -- hc_en
    
      -- When present state is token byte0 state
    when TOK_BYTE0 =>
      if hc_en = '1' then -- host operation
        -- when operating as a host with a hub.  To support low speed devices
        -- through a hub, the TOK state machine sends a sync and a PRE_PID 
        -- at high speed.  Then is switches the speed to low speed and starts
        -- the transaction again from the TOK sync state.  The hc_sof_req term
        -- prevents SOF packets from being sent at low speed.
        if host_wo_hub = '0' AND 
           hc_ls_timing = '0' AND low_speed_req = '1' and
           ser2par_cnt_eq7 = '1' AND hc_sof_req = '0' then 
          tok_nstate <= TOK_SYNC;
          tok_ls_timing_set <= '1';
        elsif ser2par_cnt_eq7 = '1' then
          tok_nstate <= TOK_BYTE1; -- Goto token byte1 state
        else
          tok_nstate <= TOK_BYTE0; -- Stay here
        end if; -- ser2par_cnt_eq7
      else -- target / device operation
        -- If false eop or usb address not equal abort token
        if det_se0 = '1' OR  bit_stuff_err= '1' then
          tok_nstate <= TOK_WAIT; -- Goto token wait state
          IF det_se0 = '1' AND ser2par_cnt_eq7 = '0' then
            dfn8_err_tok <= '1';         -- set the dfn8 error indication
          END IF;
        elsif ser2par_cnt_eq7 = '1' then
          tok_nstate <= TOK_BYTE1; -- Goto token byte1 state
        else
          tok_nstate <= TOK_BYTE0; -- Stay here
        end if;
      end if;  -- hc_en

    -- When present state is token byte1 state
    when TOK_BYTE1 =>
      if hc_en = '1' then -- host operation
        if ser2par_cnt_eq7 = '1' then
          tok_nstate <= TOK_EOP; -- Goto token eop state
        else
          tok_nstate <= TOK_BYTE1; -- Stay here
        end if; -- ser2par_cnt_eq7
      else -- target / device operation
        if det_se0 = '1' and ser2par_cnt_eq7 = '0' then -- False eop
          tok_nstate <= TOK_WAIT; -- Goto token wait state
          IF det_se0 = '1' AND ser2par_cnt_eq7 = '0' then
            dfn8_err_tok <= '1';         -- set the dfn8 error indication
          END IF;
        elsif  bit_stuff_err= '1' then
          tok_nstate <= TOK_WAIT; -- Goto token wait state
        elsif det_se0 = '1' and ser2par_cnt_eq7 = '1' then 
          tok_nstate <= TOK_EOP; -- Goto token eop state
        else
          tok_nstate <= TOK_BYTE1; -- Stay here
        end if;
      end if;  -- hc_en

    -- When present state is token eop state
    when TOK_EOP =>
      if hc_en = '1' then -- host operation
        if ser2par_cnt_eq1 = '1' then
          if hc_sof_req = '1' then
            tok_nstate <= TOK_IDLE; -- Goto token idle state
          else            
            tok_nstate <= TOK_PROC; -- Goto token process state
          end if; --
        else
          tok_nstate <= TOK_EOP; -- Stay here
        end if; -- ser2par_cnt_eq7
      else -- target / device operation
        -- Wait for EOP
        if det_eop = '1' then
          if sof_pid = '1' and crc5_okay = '1' and 
             bit_stuff_err = '0' then
            frame_num_ld <= '1'; -- Load current frame number register
            tok_nstate <= TOK_IDLE; -- Goto token idle state
          elsif token_proc_en = '1' and usb_addr_eq = '1' and 
                crc5_okay = '1'  and bit_stuff_err = '0' then
            dev_dma_rd_bdt <= not own_ok OR -- Read BDT (4 bytes) if you don't have one
                              dma_re_rd_bdt;-- or the DMA values need to be re-read.
            if current_token = PID_SETUP then -- may need to add OUT tokens also
              endpt_stall_clr <= '1';         -- clear the protocol stall on receipt
                                              -- of a valid SETUP token.
            end if;
            tok_nstate <= TOK_PROC; -- Goto token process state
          else
            tok_nstate <= TOK_IDLE; -- Goto token idle state
          end if;
        -- We only want to wait for the EOP for a short
        -- period of time, if we do not get it return to IDLE
        elsif ser2par_cnt(2) = '1' then
          tok_nstate <= TOK_IDLE; -- Goto token idle state
        else
          tok_nstate <= TOK_EOP; -- Stay here
        end if;
      end if;  -- hc_en

    -- When present state is token process state
    when TOK_PROC =>
	 -- If the in or rx data packet state machines reject a token for any reason
	 -- the token processing state machine must return to idle
      if tx_datpkt_done = '1' or rx_datpkt_done = '1' then
        if reject_tx_datpkt = '1' or reject_rx_datpkt ='1' then
          if hc_en = '1' then        -- if operating as a host
            if hc_no_retry = '1' or hc_retry_disable = '1' then
              -- as a host don't repeat failed transaction automatically when
              -- no retry is set or the failure is not retry worthy.
              dma_wrt_bdt <= '1';        -- Write the recieved PID out to the
              hc_token_done <= '1';      -- BDT control word
            end if;
          end if;
          tok_nstate <= TOK_IDLE; -- Transmission failed
        else  -- If the packet is OK write the BDT
          dma_wrt_bdt <= '1'; -- DMA write BDT (4 bytes)
          tok_nstate <= TOK_IDLE; -- Goto token idle state
          if hc_en = '1' then
            hc_token_done <= '1';
          elsif current_token = PID_SETUP then
            txd_suspend_set <= '1';      -- hold off any new tokens until
                                         -- software catches up.
          end if;
        end if;
      else 
        tok_nstate <= TOK_PROC; -- Stay here
      end if;

    -- When present state is token wait state
    when TOK_WAIT =>
      if det_eop = '1' then
        tok_nstate <= TOK_IDLE; -- Goto token idle state
      else 
        tok_nstate <= TOK_WAIT; -- Stay here
      end if;

    -- Default next state, eliminates feedback loops
    when OTHERS =>
      tok_nstate <= TOK_IDLE;

  end case;

end process tok_nsl;

--------------------------------------------------------------------------------
--
--     Process: txd_nsl           -- Tx Data Packet state machine next state logic
--
--  Parameters: txd_pstate        -- Tx Data Packet state machine present state bits
--              tx_datpkt_proc     -- Tx Data Packet process
--              out_handshake_en  -- Out handshake enable
--              ser2par_cnt_eq2   -- Serial to parallel bit count equals 2
--              ser2par_cnt_eq7   -- Serial to parallel bit count equals 7
--              endpt_hshk        -- Endpoint hand shake enable
--              own               -- BDT own control bit
--              transmit_done     -- Transmit done
--              in_handshake_done -- In handshake done
--              last_bit_stuff_en -- Last bit stuff enable
--
-- Description: This process implements next state logic for the tx data packet
--  processing state machine.
--
-- State Diagram: TBD
--
--------------------------------------------------------------------------------

txd_nsl: process (txd_pstate, tx_datpkt_proc, out_handshake_en, ser2par_cnt,
                  ser2par_cnt_eq1, ser2par_cnt_eq7, endpt_hshk, own, hc_en,
                  hc_ls_timing, low_speed_req, endpt_stall, byte_count_eq,
                  in_handshake_done, transmit_done, last_bit_stuff_en,
                  zero_stuff_inhibit) begin

--  tx_datpkt_done <= '0'; -- Default output value
  out_handshake_done <= '0';  -- Default output value
  start_txd <= '0';  -- Default output value
  txd_ls_timing_set <= '0'; -- by default leave the low speed timing alone.

  case txd_pstate is

    -- When present state is tx data packet wait state
    when TXD_WAIT =>
      -- If detect a tx data packet process
      if tx_datpkt_proc = '1' or out_handshake_en = '1' then
        start_txd <= '1'; -- Signal sie logic that we are starting a tx data packet
--        txd_nstate <= TXD_SYNC; -- Goto tx data packet sync state
        txd_nstate <= TXD_DELAY; -- Goto tx data packet delay state
      else
        txd_nstate <= TXD_WAIT; -- Stay here
      end if;

    -- When present state is tx data packet wait state
    when TXD_DELAY =>
      -- If detect a tx data packet process
      start_txd <= '1'; -- Signal sie logic that we are starting
                        -- a tx data packet
      txd_nstate <= TXD_SYNC; -- Goto tx data packet sync state

    -- When present state is tx data packet sync state
    when TXD_SYNC =>
      -- Transmit a sync
      if ser2par_cnt_eq7 = '1' then
        -- If this is a host sending to a low speed device and the
        -- timing has not yet been switched to low speed. Go to the
        -- send a PRE pid state.
        if hc_en = '1' AND host_wo_hub = '0' AND 
             hc_ls_timing = '0' AND low_speed_req = '1' then
          txd_nstate <= TXD_PRE;
        else  
          txd_nstate <= TXD_PID; -- Goto tx data packet pid state
        end if;
      else
        txd_nstate <= TXD_SYNC;  -- Stay here
      end if;

    -- When present state is tx data packet PRE pid state
    when TXD_PRE =>
      -- Transmit a PRE PID
      if ser2par_cnt_eq7 = '1' then
        txd_nstate <= TXD_LSDLY; -- Go to Low Speed delay
      else
        txd_nstate <= TXD_PRE;   -- Stay here finish sending PRE pid
      end if;


    -- When present state is low speed delay
    when TXD_LSDLY =>
      -- Wait before switching the clock to low speed.
      if ser2par_cnt_eq7 = '1' then
        txd_nstate <= TXD_SYNC; -- Start sending Low Speed Sync
        txd_ls_timing_set <= '1';
      else
        txd_nstate <= TXD_LSDLY; -- Stay here and wait
      end if;


    -- When present state is tx data packet pid state
    when TXD_PID =>
      -- Transmit a PID
      if ser2par_cnt_eq7 = '1' then
        -- Check for STALL, or handshake condition
        if endpt_stall = '1' or out_handshake_en  = '1' then
          txd_nstate <= TXD_EOP;         -- Handshake was sent; Goto eop state
        -- Check for NAK condition
        elsif own = '0' then             -- BDT not ready
          if endpt_hshk = '0' then       -- ISO endpoint?
            txd_nstate <= TXD_CRC16L;    -- Sent a zero length ISO Pkt
          else                           -- Non-ISO endpoint
            txd_nstate <= TXD_EOP;       -- NAK was sent; goto eop state
          end if;
        else
          if transmit_done = '0' then
            txd_nstate <= TXD_DATA;      -- Goto tx data byte state
          else
            txd_nstate <= TXD_CRC16L;    -- Goto tx data packet CRC16L state
          end if;
        end if;
      else
        txd_nstate <= TXD_PID; -- Stay here
      end if;

    -- When present state is tx data packet data state
    when TXD_DATA =>
      -- Transmit a data
      if ser2par_cnt_eq7 = '1' and zero_stuff_inhibit = '1' then
        txd_nstate <= TXD_EOP;    -- After forcing a bit stuff error end packet
      elsif ser2par_cnt_eq7 = '1' and transmit_done = '1' then
        txd_nstate <= TXD_CRC16L; -- Goto tx data packet crc16l state
      else
        txd_nstate <= TXD_DATA; -- Stay here
      end if;

    -- When present state is tx data packet crc16l state
    when TXD_CRC16L =>
      -- Transmit low order byte of crc16
      if ser2par_cnt_eq7 = '1' then
        txd_nstate <= TXD_CRC16H; -- Goto tx data packet crc16h state
      else
        txd_nstate <= TXD_CRC16L; -- Stay here
      end if;

    -- When present state is tx data packet crc16h state
    when TXD_CRC16H =>
      -- Transmit high order byte of crc16
      if last_bit_stuff_en = '1' then
        txd_nstate <= TXD_LBS; -- Goto tx data packet last bit stuff state
      elsif ser2par_cnt_eq7 = '1' then
        txd_nstate <= TXD_EOP; -- Goto tx data packet eop state
      else
        txd_nstate <= TXD_CRC16H; -- Stay here
      end if;

    -- Special state to force the insertion of a bit stuff after CRC
    when TXD_LBS =>
      txd_nstate <= TXD_EOP; -- Goto tx data packet eop state

    -- When present state is tx data packet eop state
    when TXD_EOP =>
      -- Transmit a EOP
--      if ser2par_cnt_eq2 = '1' then 
      if ser2par_cnt_eq1 = '1' then 
        if own = '0' or endpt_stall = '1' or endpt_hshk= '0' or
           out_handshake_en = '1' then 
          txd_nstate <= TXD_DONE; -- Iso endpoint (hand shake disabled) goto 
        else                          -- tx data packet done state
          txd_nstate <= TXD_HSHK; -- Goto tx data packet handshake state
        end if;
      else
        txd_nstate <= TXD_EOP; -- Stay here
      end if;

    -- When present state is tx data packet handshake state
    when TXD_HSHK =>
      if in_handshake_done = '1' then
        txd_nstate <= TXD_DONE; -- Goto tx data packet done state
      else
        txd_nstate <= TXD_HSHK; -- Stay here
      end if;

    -- When present state is tx data packet done state
    when TXD_DONE =>
--      tx_datpkt_done <= '1';  -- Tx Data Packet process done
      out_handshake_done <= '1';  -- Rx Data Packet handshake done
      txd_nstate <= TXD_WAIT; -- Goto tx data packet wait state

    -- Default next state, eliminates feedback loops
    when OTHERS =>
      txd_nstate <= TXD_WAIT;

  end case;

end process txd_nsl;

--------------------------------------------------------------------------------
--
--     Process: rxd_nsl            -- Rx Data Packet state machine next state logic
--
--  Parameters: 
--              bit_stuff_err
--              bto_err_set        -- Bus timeout error interrupt set
--              crc16_err_set      -- CRC16 error detected
--              current_token      -- Current token
--              det_eop            -- Detected end of packet
--              det_se0            -- Detected Single ended Zero
--              det_sync           -- Detected USB sync
--              endpt_stall        -- Endpoint stalled
--              endpt_hshk         -- Endpoint hand shake enable
--              in_handshake_en    -- In handshake enable
--              out_handshake_done -- Out handshake done
--              own                -- BDT owned by SIE
--              rcv                -- USB Receive Data
--              rx_datpkt_proc     -- Rx Data Packet process
--              rx_overrun_nak     -- Force a Nak responce to this Rx Packet
--              rxd_pstate         -- Rx Data Packet state machine present state bits
--              ser2par_cnt_eq7    -- Serial to parallel bit count equals 7
--              valid_data_pid     -- Valid data PID
--              valid_data_tgl     -- Valid data toggle bit on this data PID
--              valid_stall_pid    -- Valid data STALL
--
-- Description: This process implements next state logic for the token
--  processing state machine.
--
-- State Diagram: TBD
--
--------------------------------------------------------------------------------

rxd_nsl: process (bit_stuff_err, bto_err_set, crc16_err_set, current_token,
                  det_eop, det_se0, det_sync, endpt_hshk, endpt_stall,
                  in_handshake_en, out_handshake_done, own, rcv, rx_datpkt_proc,
                  rx_overrun_nak, rxd_pstate, ser2par_cnt_eq7, valid_data_pid,
                  valid_data_tgl, valid_stall_pid)

begin

  in_handshake_done <= '0';  -- Default output value
  dfn8_err_rxd <= '0'; -- Default output value
  reject_rx_dat_set <= '0'; -- Default output value

  case rxd_pstate is

    -- When present state is rx data packet wait state
    when RXD_WAIT =>
      -- If detect a rx data packet process
      if rx_datpkt_proc = '1' or in_handshake_en = '1' then
        rxd_nstate <= RXD_IDLE; -- Goto rx data packet idle state
      else
        rxd_nstate <= RXD_WAIT; -- Stay here
      end if;

    -- When present state is rx data packet idle state
    when RXD_IDLE =>
      -- If detect a bus timeout error
      if bto_err_set = '1' then
        IF endpt_hshk = '1' then
          reject_rx_dat_set <= '1'; -- BTO, reject rx data packet
        END IF;                     --  ISO packets that BTO just update the BDT.
      	rxd_nstate <= RXD_DONE;   -- BTO, goto wait state
      -- If detect a change on rcv
      elsif rcv = '0' then
        rxd_nstate <= RXD_SYNC; -- Goto rx data packet sync state
      else
        rxd_nstate <= RXD_IDLE; -- Stay here
      end if;

    -- When present state is rx data packet sync state
    when RXD_SYNC =>
      -- If detect a sync
      if det_sync = '1' then
        rxd_nstate <= RXD_PID;  -- Goto rx data packet pid state
      elsif bto_err_set = '1' then
        IF endpt_hshk = '1' then
          reject_rx_dat_set <= '1'; -- BTO, reject rx data packet
        END IF;                     --  ISO packets that BTO just update the BDT.
      	rxd_nstate <= RXD_DONE;   -- BTO, goto wait state
      else
        rxd_nstate <= RXD_SYNC; -- Stay here
      end if;

    -- When present state is rx data packet pid state
    when RXD_PID =>
      -- bit stuff error  
      if bit_stuff_err= '1' then 
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state
      -- If false eop
      elsif ser2par_cnt_eq7 = '0' AND det_se0 = '1' then
        dfn8_err_rxd <= '1';    -- Data field not 8-bits error interrupt set
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state
      -- If received a byte, 
      elsif ser2par_cnt_eq7 = '1' then 
        if in_handshake_en = '1' then  -- if receiving a handshake 
          rxd_nstate <= RXD_EOP;       -- go directly to EOP
        else
          if valid_stall_pid = '1' then   -- if stall
             rxd_nstate <= RXD_EOP;       --  go directly to EOP
          elsif valid_data_pid = '1' then -- if it is a data pid
            if (valid_data_tgl = '0' and  --  if data toggle miss-match and 
                endpt_hshk = '1' and      --   it is not a isochronous endpoint
                current_token /= PID_SETUP)--   and it is not a SETUP packet
            then
              reject_rx_dat_set <= '1';   --   reject rx data packet, but
                                          --   complete the the packet and send
                                          --   an Acknowledge handshake
            end if; -- data toggle
            rxd_nstate <= RXD_BYTE0;      -- Goto rx data packet byte0 state
          else
            reject_rx_dat_set <= '1'; -- PID not valid, reject rx data packet
            rxd_nstate <= RXD_DONE;  -- Goto rx data packet wait state
          end if;
        end if;
      else
        rxd_nstate <= RXD_PID; -- Stay here
      end if;

    -- When present state is rx data packet byte0 state
    when RXD_BYTE0 =>
      -- If false eop or usb address not equal abort token 
      if bit_stuff_err= '1' then  -- bit stuff error or
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state 
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
      elsif det_se0 = '1' then
--      elsif det_eop = '1' then
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state 
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
        if ser2par_cnt_eq7 = '0' then
          dfn8_err_rxd <= '1';    -- Data field not 8-bits error interrupt set
        end if;
      elsif ser2par_cnt_eq7 = '1' then
        rxd_nstate <= RXD_BYTE1;  -- Goto rx data packet byte1 state
      else
        rxd_nstate <= RXD_BYTE0;  -- Stay here
      end if;

    -- When present state is rx data packet byte1 state
    when RXD_BYTE1 =>
      if bit_stuff_err  = '1' then -- bit stuff error or
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state 
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
      elsif det_se0 = '1' AND  ser2par_cnt_eq7 = '1' then -- Detect single ended 0
          rxd_nstate <= RXD_EOP;  -- Goto rx data packet eop state
      elsif det_se0 = '1' then
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state 
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
        dfn8_err_rxd <= '1';      -- Data field not 8-bits error interrupt set
      elsif ser2par_cnt_eq7 = '1' then 
        rxd_nstate <= RXD_BYTE2; -- Goto rx data packet byte2 state
      else
        rxd_nstate <= RXD_BYTE1; -- Stay here
      end if;

    -- When present state is rx data packet byte2 state
    when RXD_BYTE2 =>
      if bit_stuff_err= '1' then  -- bit stuff error or
        rxd_nstate <= RXD_DONE;   -- Goto rx data packet wait state 
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
      elsif det_se0 = '1' and ser2par_cnt_eq7 = '1' then -- Detect single ended 0
        rxd_nstate <= RXD_EOP;    -- Goto rx data packet eop state
      elsif det_se0 = '1' then    -- False eop
        rxd_nstate <= RXD_DONE;   -- Reject rx data packet goto rx data packet wait state
        reject_rx_dat_set <= '1'; -- not valid, reject rx data packet
        dfn8_err_rxd <= '1';      -- Data field not 8-bits error interrupt set
      else
        rxd_nstate <= RXD_BYTE2; -- Stay here
      end if;

    -- When present state is rx data packet byte2 state
    when RXD_EOP =>
      -- Wait for EOP
      -- No handshake needed if we meet any of the following conditions
      -- Processing SETUP and own=0 or
      -- Doing a handshake in response to TX DATA PACKET (in_handshake_en=1)
      -- or we are an isochronous endpoint type (endpt_hshk=0)
      IF crc16_err_set = '1' then
        rxd_nstate <= RXD_DONE;  -- Abort the rxd packet on crc16 error detect
        reject_rx_dat_set <= '1';-- reject rx data packet
      ELSIF det_eop = '1' and current_token = PID_SETUP and own = '0' then
        rxd_nstate <= RXD_DONE;  -- IF you couldn't accept a setup packet then
        reject_rx_dat_set <= '1';-- reject the rx packet and allow the USB to
                                 -- time out
      ELSIF det_eop = '1' and (in_handshake_en = '1' or
        endpt_hshk = '0') then  -- on ISO packets interrupt even if own is 0
        rxd_nstate <= RXD_DONE; -- Goto rx data packet done state, no hand
                                -- shake is sent.
      ELSIF det_eop = '1' then  -- otherwise send the appropriate handshake.
        if rx_overrun_nak = '1' then  -- if non-ISO overrun error
          reject_rx_dat_set <= '1'; -- stop the BDT write, but go ahead
          if current_token = PID_SETUP then
            rxd_nstate <= RXD_DONE; -- Goto rx data packet done state, no hand
                                    -- shake is sent.
          else
            rxd_nstate <= RXD_HSHK; -- Goto rx data packet handshake state
          end if;                   -- and send a NAK handshake.
        else
          rxd_nstate <= RXD_HSHK;   -- Goto rx data packet handshake state
        end if;
      ELSE
        rxd_nstate <= RXD_EOP; -- Stay here
    
      END IF;

    -- When present state is rx data packet handshake state
    when RXD_HSHK =>
      if out_handshake_done = '1' then
        rxd_nstate <= RXD_DONE; -- Goto rx data packet done state
      else
        rxd_nstate <= RXD_HSHK; -- Stay here
      end if;

    -- When present state is rx data packet done state
    when RXD_DONE =>
      in_handshake_done <= '1';  -- Tx Data Packet handshake done
      rxd_nstate <= RXD_WAIT; -- Goto rx data packet wait state

    -- Default next state, eliminates feedback loops
    when OTHERS =>
      rxd_nstate <= RXD_WAIT;

  end case;

end process rxd_nsl;

--------------------------------------------------------------------------------
--
--     Process: tok_monitor
--
--  Parameters: tok_pstate  -- Token state machine state bits
--
-- Description: This process monitors the token present state bit and
--  converts them in to an enumerated type. This is helpful when
--  simulating the USB sie because present states information is
--  displayed as the enumerated type instead of a signal.
--
--------------------------------------------------------------------------------

tok_monitor: process(tok_pstate)

begin

  case tok_pstate is

    -- When present state is token idle state
    when TOK_IDLE =>
      tok_enum <= TOK_IDLE_E;

    -- When present state is token sync state
    when TOK_SYNC =>
      tok_enum <= TOK_SYNC_E;

    -- When present state is token pid state
    when TOK_PID =>
      tok_enum <= TOK_PID_E;

    -- When present state is token byte0 state
    when TOK_BYTE0 =>
      tok_enum <= TOK_BYTE0_E;

    -- When present state is token byte1 state
    when TOK_BYTE1 =>
      tok_enum <= TOK_BYTE1_E;

    -- When present state is token eop state
    when TOK_EOP =>
      tok_enum <= TOK_EOP_E;

    -- When present state is token process state
    when TOK_PROC =>
      tok_enum <= TOK_PROC_E;

    -- When present state is token wait state
    when TOK_WAIT =>
      tok_enum <= TOK_WAIT_E;

    -- Default next state
    when OTHERS =>
      tok_enum <= ERROR_E;

  end case;

end process tok_monitor;

--------------------------------------------------------------------------------
--
--     Process: txd_monitor
--
--  Parameters: txd_pstate  -- Tx Data Packet state machine state bits
--
-- Description: This process monitors the tx data packet present state bit and
--  converts them in to an enumerated type. This is helpful when
--  simulating the USB sie because present states information is
--  displayed as the enumerated type instead of a signal.
--
--------------------------------------------------------------------------------

txd_monitor: process(txd_pstate)

begin

  case txd_pstate is

    when TXD_WAIT =>
      txd_enum <= TXD_WAIT_E;

    when TXD_SYNC =>
      txd_enum <= TXD_SYNC_E;

    when TXD_PID =>
      txd_enum <= TXD_PID_E;

    when TXD_DATA =>
      txd_enum <= TXD_DATA_E;

    when TXD_CRC16L =>
      txd_enum <= TXD_CRC16L_E;

    when TXD_CRC16H =>
      txd_enum <= TXD_CRC16H_E;

    when TXD_EOP =>
      txd_enum <= TXD_EOP_E;

    when TXD_HSHK =>
      txd_enum <= TXD_HSHK_E;

    when TXD_DONE =>
      txd_enum <= TXD_DONE_E;

    when TXD_DELAY =>
      txd_enum <= TXD_DELAY_E;

    when TXD_PRE =>
      txd_enum <= TXD_PRE_E;

    when TXD_LSDLY =>
      txd_enum <= TXD_LSDLY_E;

    when OTHERS =>
      txd_enum <= TXD_WAIT_E;

  end case;

end process txd_monitor;

--------------------------------------------------------------------------------
--
--     Process: rxd_monitor
--
--  Parameters: rxd_pstate  -- Rx Data Packet state machine state bits
--
-- Description: This process monitors the rx data packet present state bit and
--  converts them in to an enumerated type. This is helpful when
--  simulating the USB sie because present states information is
--  displayed as the enumerated type instead of a signal.
--
--------------------------------------------------------------------------------

rxd_monitor: process(rxd_pstate)

begin

  case rxd_pstate is

    when RXD_WAIT =>
      rxd_enum <= RXD_WAIT_E;

    when RXD_IDLE =>
      rxd_enum <= RXD_IDLE_E;

    when RXD_SYNC  =>
      rxd_enum <= RXD_SYNC_E;

    when RXD_PID =>
      rxd_enum <= RXD_PID_E;

    when RXD_BYTE0 =>
      rxd_enum <= RXD_BYTE0_E;

    when RXD_BYTE1 =>
      rxd_enum <= RXD_BYTE1_E;

    when RXD_BYTE2 =>
      rxd_enum <= RXD_BYTE2_E;

    when RXD_EOP =>
      rxd_enum <= RXD_EOP_E;

    when RXD_HSHK =>
      rxd_enum <= RXD_HSHK_E;

    when RXD_DONE =>
      rxd_enum <= RXD_DONE_E;

    when OTHERS =>
      rxd_enum <= RXD_WAIT_E;

  end case;

end process rxd_monitor;

end rtl;
