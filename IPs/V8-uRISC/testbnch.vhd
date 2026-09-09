------------------------------------------------------------------------------
-- Copyright 1999 VAutomation Inc. Nashua NH 603-882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: testbnch.vhd
--
-- Revision: $Name: REV9911b $
--
-- Description:
-- 	This is the Test Bench for the VUSB Fire Wire Core it uses the V8 SBC,
--      a USB Host controller model, and a terminal model.
--
-- Signals ending in _n are active low.

-- Revision History
-- $Log: testbnch.vhd,v $
-- Revision 1.81  2000/01/03 16:18:58  chris
-- Changed dpllnrzi architecture name to rtl.
--
-- Revision 1.80  1999/11/10 16:15:01  mark
-- updated a_usb_lsdev_sync configuration
--
-- Revision 1.79  1999/11/10 13:08:33  gregg
-- Moved a_usb_lsdev_sync configuration for inclusion with VUSB release
--
-- Revision 1.78  1999/11/09 14:57:01  mark
-- Updated CONFIGURATIONs to exclude vusb_hub since it was
-- pulled out of the asic_v8.
--
-- Revision 1.77  1999/11/08 11:21:47  mark
-- updated 'synth' architectures with 'rtl' architecture name
--
-- Revision 1.76  1999/09/30 12:39:03  gregg
-- Tied off JTAG signals in architectures that do not use JTAG
--
-- Revision 1.75  1999/09/21 19:35:12  gregg
-- Changed polarity of pull_host_b_dplus to 1, to keep Xes out
-- of verilog
--
-- Revision 1.74  1999/09/21 13:21:43  gregg
-- Added verilog defparams for proper configuration of architectures
--
-- Revision 1.73  1999/09/20 14:49:49  gregg
-- Added bias resistors to host architectures to remove Xes from simulation
-- Created new target HS & LS architecture to add in verilog support
--
-- Revision 1.72  1999/09/17 17:15:24  gregg
-- Added biasing resistors to host and system architectures
-- Also created low speed architectures for verilog conversion
--
-- Revision 1.71  1999/09/16 13:23:25  gregg
-- Added pullup & pulldown resistors to host architecture
--
-- Revision 1.70  1999/09/14 20:24:27  chris
-- Fixed values on host_wo_hub generics.
--
-- Revision 1.69  1999/09/14 19:59:50  gregg
-- If Chris reminded me that LOW_SPEED_DEV was changed to an integer
-- I would not have had to check out this file again!
--
-- Revision 1.68  1999/09/14 18:20:00  gregg
-- Added pullup and pulldown to D+ & D-
--
-- Revision 1.67  1999/09/13 20:30:37  chris
-- Added the 0 (flase) settings for host_wo_hub generic to the system
-- testbench.
--
-- Revision 1.66  1999/09/10 22:40:32  gregg
-- Added host controller system architecture
--
-- Revision 1.65  1999/07/30 21:27:36  chris
-- Added separate generics maps for low speed host simulations.
--
-- Revision 1.64  1999/07/12 08:13:48  chris
-- Added architecture for usb_lsdev_sync with generics to support low
-- speed regression simulations.
--
-- Revision 1.63  1999/06/24 20:47:50  chris
-- Added host to low speed configurations.
-- Prepended a_ to configuration names so they jump out at you in the
--    simulator.
--
-- Revision 1.62  1999/05/26 13:14:39  gregg
-- Added pullup/down resistors on the host dplus and dminus
-- this was to add in Verilog conversion
--
-- Revision 1.61  1999/05/17 18:13:40  gregg
-- Added Altera configuration
--
-- Revision 1.60  1999/04/07 19:52:00  gregg
-- Renamed architectures to better reflect the devices to implement.
--
-- Revision 1.59  1999/04/01 20:49:12  meyers
-- removed support for asic_ios.  outdated!
--
-- Revision 1.58  1999/03/31 22:46:01  gregg
-- Added low speed peripheral support
--
-- Revision 1.57  1998/11/10 20:09:35  chris
-- Added stubs for hub specific ports on the host_ctl entity.
--
-- Revision 1.56  1998/09/01 15:26:31  chris
-- Added Behavioral JTAG master vjtagtst.vhd JTAG testor.
--
-- Revision 1.55  1998/07/16 16:24:12  gregg
-- Added MAKERELEASE commands to remove host code
--
-- Revision 1.54  1998/07/10 21:52:54  chris
-- Added empty 1284 port definition to the configurations.
--
-- Revision 1.53  1998/07/10 19:48:58  gregg
-- Remove reference to textio, cleaned up some comments
--
-- Revision 1.52  1998/07/10 18:40:20  gregg
-- Added verilog translate directives
--
-- Revision 1.51  1998/07/10 12:23:49  chris
-- Added configuration information for the empty Altera devices on the IPS.
--
-- Revision 1.50  1998/07/07 23:49:00  gregg
-- Fix Makerelease typos
--
-- Revision 1.49  1998/07/07 20:30:54  chris
-- Added Makerelease directives to remove the old SBC files.
--
-- Revision 1.48  1998/06/15 17:03:06  chris
-- Changed the port list for USB connections on the ips_pcb, and made all
-- the USB bias resistors behavioral and local to the testbnch.
--
-- Revision 1.47  1998/06/09 15:33:55  chris
-- Converted testbnch to use new ips_pcb model.
-- Retained asic_ios and v8_sbc architectures.
--
-- Revision 1.46  1998/05/08 14:52:36  chris
-- Corrected the testbench and vusb_top configuration associations.
--
-- Revision 1.45  1998/04/27 12:17:06  chris
-- Rewrote configurations to support multiple architectures in bistrom and v8_regs.
--
-- Revision 1.44  1998/03/13 21:16:12  chris
-- Added Revision Name.
--
-- Revision 1.43  1998/02/24 15:10:16  chris
-- Jumpered around the USB connector models.
--
-- Revision 1.42  1998/02/18 12:18:41  gregg
-- Added host architecture
--
-- Revision 1.41  1997/10/16  08:05:51  chris
-- Moved USB host controller code to a separate file.  The testbench is now a
-- simple structural model of a V8 SBC connected to a terminal and a USB host.
--
-- Revision 1.40  1997/09/17 04:43:37  chris
-- Extended initial USB reset to allow time for additional software.
--
-- Revision 1.39  1997/08/21  22:23:20  eric
-- Updated with the latest CONFIG_DESC data. passes bus enumeration.
--
-- Revision 1.38  1997/06/12 20:51:23  chris
-- Debugged Quicktest up to line 7022, and added comments identifying
-- problems uncovered in the USB driver and USB SIE code.
--
-- Revision 1.37  1997/05/22 12:52:20  chris
-- Added some PLL checks to the special SOF test.
--
-- Revision 1.36  1997/05/20 13:13:44  chris
-- Added bus monitor code to check for unexpected activity on the USB.
-- Changed audio test packet from iso to bulk.
--
-- Revision 1.35  1997/05/16 16:45:03  chris
-- Corrected Configuration Descriptor values for bulk audio.
--
-- Revision 1.34  1997/05/16  13:30:36  chris
-- Fixed crc5 generation in SOF packets.
--
-- Revision 1.32  1997/05/15 12:02:46  chris
-- Updated the configuration values, and added the rest of the
-- checklist tests to quick test.
--
-- Revision 1.31  1997/05/13 20:45:22  chris
-- Fixed get_descriptor bRequest value.
--
-- Revision 1.30  1997/05/13 16:05:31  chris
-- Set BTO test at the head of the USB compliance quick test.
--
-- Revision 1.29  1997/05/13 14:23:52  chris
-- Changed bmRequest value on the get endpoint status request.
--
-- Revision 1.28  1997/05/13 11:34:50  chris
-- fixed bmRequest (rtype) value on one of the set endpoint feature
-- requests.
--
-- Revision 1.27  1997/05/13 10:55:36  chris
-- Fixed set_feature and clear_feature bRequest Values.
--
-- Revision 1.26  1997/05/13 10:12:49  chris
-- Corrected initial value of force_non_zero_status to false.
--
-- Revision 1.25  1997/05/12 16:16:28  chris
-- Added chapter 9 tests.
--
-- Revision 1.24  1997/04/29 15:48:00  chris
-- Changed endpoint usage in the checklist code to avoid endpoints 1,2 and 3.
--
-- Revision 1.23  1997/04/29 12:08:53  chris
-- fixed runtime array size mismatch.
--
-- Revision 1.22  1997/04/28 10:51:44  chris
-- Fixed get configuration descripter request.
--
-- Revision 1.21  1997/04/25 21:15:10  chris
-- Updated cofiguration descriptor values, and coded (not tested)
-- most of the Periferal silicon checklist.
--
-- Revision 1.20  1997/04/23 22:12:30  chris
-- Inverted usb_clk from sbc to match inverted clock on pin com_clk_b of the
-- new SBC.
--
-- Revision 1.19  1997/03/21  21:20:37  chris
-- Moved Configuration information to a separate file.
--
-- Revision 1.18  1997/03/19  20:49:36  chris
-- Added tests for all the strings.
-- Changed ERRORS to FAILURES and added terse message mode.
--
-- Revision 1.17  1997/03/19  17:11:44  chris
-- Corrected  usb_str_1_len, and unicode decoding loop.
--
-- Revision 1.16  1997/03/18 22:13:04  chris
-- Added Get Descriptor String.
--
-- Added Some Checklist code.
--
-- Revision 1.14  1997/03/06 18:17:42  chris
-- Reversed byte order on wValue of Get Configuration packets.
--
-- Revision 1.13  1997/03/06 15:05:12  chris
-- Reversed the byte order of multibyte USB data fields.
-- Added code to track current PID and current device address.
-- Added CRC and bitstuffing test routines.
--
-- Revision 1.12  1997/03/05 16:51:36  chris
-- Added code to allow for a bus time out response to the setup transaction.
--
-- Revision 1.11  1997/03/05 14:03:51  chris
-- Added HC ACK's to Status phase of set address and set config transactions.
--
-- Revision 1.10  1997/03/04 22:43:32  chris
-- Added Code to do a get configuration and a set configuration.
--
-- Revision 1.9  1997/03/04 18:31:26  chris
-- Removed target emulation.
-- Added test observation signals to aid in debug.
-- Cleaned up messages and Data PIDs.
--
-- Revision 1.8  1997/03/03  16:56:45  chris
-- Fixed simulation difference between PC and Unix MTI by changing the order
-- in which statements are executed.
--
-- Revision 1.7  1997/03/03 16:02:41  chris
-- Corrected syntax errors introduced in rev 1.4 and 1.6.
--
-- Revision 1.6  1997/03/03 14:47:10  chris
-- removed hc_pkg USE statement.
--
-- Revision 1.5  1997/03/01 02:08:28  eric
-- changed USB_CLK to be synchronous to the Core so test vectors can be extracted.
--
-- Revision 1.4  1997/02/21 21:49:17  chris
-- Merged host controller package code into test bench to support conversion to verilog.
--
-- Revision 1.3  1997/02/21 19:35:04  chris
-- Changed Host Controller NAK to bus timeout.
--
-- Revision 1.2  1997/02/19 21:35:26  chris
-- added USB bus controller bus enumeration code.
--
-- Revision 1.1  1997/02/07  20:27:06  chris
-- Initial revision
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.
use work.cfg_usb.all;

ENTITY testbnch IS	------------------------------ENTITY--------------------
END testbnch;

ARCHITECTURE target_hs of testbnch is -----------------Architecture-----------

COMPONENT ips_pcb
  port(
    -- USB connections
    signal usbb_dplus	: inout std_logic; -- usb channel 0
    signal usbb_dminus	: inout std_logic; -- usb channel 0
    -- rs232 interface on the female dsub9 connector J2
    signal dsub9_F_J2_1	: inout std_logic; -- rs232_dcd, in
    signal dsub9_F_J2_2	: inout std_logic; -- rs232_txd, out
    signal dsub9_F_J2_3	: inout std_logic; -- rs232_rxd, in
    signal dsub9_F_J2_4	: inout std_logic; -- rs232_dsr, in
    signal dsub9_F_J2_5	: inout std_logic; -- gnd,
    signal dsub9_F_J2_6	: inout std_logic; -- rs232_dtr, out
    signal dsub9_F_J2_7	: inout std_logic; -- rs232_cts, in
    signal dsub9_F_J2_8	: inout std_logic; -- rs232_rts, out
    signal dsub9_F_J2_9	: inout std_logic;-- OPEN,
    -- JTAG debugger connector via 9 pin D male
    signal dsub9_F_J4_1	: inout std_logic; -- unused
    signal dsub9_F_J4_2	: inout std_logic; -- TCK
    signal dsub9_F_J4_3	: inout std_logic; -- TMS
    signal dsub9_F_J4_4	: inout std_logic; -- unused
    signal dsub9_F_J4_5	: inout std_logic; -- gnd,
    signal dsub9_F_J4_6	: inout std_logic; -- unused
    signal dsub9_F_J4_7	: inout std_logic; -- TDI
    signal dsub9_F_J4_8	: inout std_logic; -- TDO
    signal dsub9_F_J4_9	: inout std_logic);-- unused,
END COMPONENT;

component host_ctl
  port (
    signal dplus            : inout std_logic;
    signal dminus           : inout std_logic;
    signal usb_A_J1_cpwr    : inout std_logic;
    signal usb_A_J1_dminus  : inout std_logic;
    signal usb_A_J1_dplus   : inout std_logic;
    signal usb_A_J1_cgnd    : inout std_logic;
    -- Hub downstream port status signals
    signal speed_dp         : in  std_logic_vector(16 DOWNTO 1);
    signal power_dp         : in  std_logic_vector(16 DOWNTO 1)
    );
END component;

component vjtagtst
  PORT (
        dsub9_M_J4_1 : inout std_logic;
        dsub9_M_J4_2 : inout std_logic;    -- connects to slave TCK
        dsub9_M_J4_3 : inout std_logic;    -- connects to slave TMS
        dsub9_M_J4_4 : inout std_logic;
        dsub9_M_J4_5 : inout std_logic;
        dsub9_M_J4_6 : inout std_logic;
        dsub9_M_J4_7 : inout std_logic;    -- connects to slave TDI
        dsub9_M_J4_8 : inout std_logic;    -- connects to slave TDO
        dsub9_M_J4_9 : inout std_logic);
END component;

COMPONENT vpc_term
  GENERIC (
        input_fname : string;
        term_label  : string);
  PORT (
        dsub9_M_J2_1  : INOUT std_logic; --dcd data carrier detect RS232 signal
        dsub9_M_J2_2  : INOUT std_logic; --rxd Receive data output RS232 signal to computer
        dsub9_M_J2_3  : INOUT std_logic; --txd Transmit data input RS232 signal from computer
        dsub9_M_J2_4  : INOUT std_logic; --dtr data terminal ready RS232 signal
        dsub9_M_J2_5  : INOUT std_logic; -- gnd
        dsub9_M_J2_6  : INOUT std_logic; --dsr data set ready RS232 signal
        dsub9_M_J2_7  : INOUT std_logic; --rts request to send RS232 signal
        dsub9_M_J2_8  : INOUT std_logic; --cts clear to send RS232 signal
        dsub9_M_J2_9  : INOUT std_logic);--ri  ring indicator RS232 signal
END COMPONENT;

COMPONENT res1206
  PORT (a : IN  std_logic;  -- a input
        z : INOUT std_logic); -- z output
END COMPONENT;

SIGNAL l_line1, r_line1     : std_logic;
SIGNAL dsub9_J2_1, --dcd data carrier detect RS232 signal in to computer
       dsub9_J2_2, --rxd Receive data output RS232 signal in to computer
       dsub9_J2_3, --txd Transmit data input RS232 signal out of computer
       dsub9_J2_4, --dtr data terminal ready RS232 signal out of computer
       dsub9_J2_5, -- gnd
       dsub9_J2_6, --dsr data set ready RS232 signal in to computer
       dsub9_J2_7, --rts request to send RS232 signal out of computer
       dsub9_J2_8, --cts clear to send RS232 signal in to computer
       dsub9_J2_9  --ri  ring indicator RS232 signal in to computer
                            : std_logic;
SIGNAL dsub9_J4_1,    -- not used
       dsub9_J4_2,    -- connects to slave TCK
       dsub9_J4_3,    -- connects to slave TMS
       dsub9_J4_4,    -- not used
       dsub9_J4_5,    -- not used
       dsub9_J4_6,    -- not used
       dsub9_J4_7,    -- connects to slave TDI
       dsub9_J4_8,    -- connects to slave TDO
       dsub9_J4_9     -- not used
                            : std_logic;

SIGNAL host_a_dplus         : std_logic; -- usb_chan1 (host) I/O
SIGNAL host_a_dminus        : std_logic; --
SIGNAL pull_host_a_dplus    : std_logic; -- Speed biasing for host signals
SIGNAL pull_host_a_dminus   : std_logic; --
SIGNAL pull_host_a_dplus_w  : std_logic; -- wire version for verilog translation
SIGNAL pull_host_a_dminus_w : std_logic; --
SIGNAL usb_cpwr,
       usb_dminus,   -- usb channel 0
       usb_dplus,    -- usb channel 0
       usb_cgnd
                            : std_logic;
SIGNAL speed_dp             : std_logic_vector(16 DOWNTO 1);
SIGNAL power_dp             : std_logic_vector(16 DOWNTO 1);

BEGIN	----------------------------------------------------------------
    
speed_dp <= (OTHERS => '0');
power_dp <= (OTHERS => '0');
    
-- Assign regs to wires.
pull_host_a_dplus_w  <= pull_host_a_dplus;
pull_host_a_dminus_w <= pull_host_a_dminus; 

-- Determine resistive bias for high speed device
pull_host_a_dplus  <= '1';
pull_host_a_dminus <= '0';

-- Speed bias resistors
rp_dplus_res  : res1206 PORT MAP ( a => pull_host_a_dplus_w,  z => host_a_dplus);
rp_dminus_res : res1206 PORT MAP ( a => pull_host_a_dminus_w, z => host_a_dminus);
  
-- USB Host controller
uhost_ctl : host_ctl
  port map (
    dplus           => host_a_dplus,
    dminus          => host_a_dminus,
    usb_A_J1_cpwr   => usb_cpwr,    --
    usb_A_J1_dminus => usb_dminus,  --
    usb_A_J1_dplus  => usb_dplus,   --
    usb_A_J1_cgnd   => usb_cgnd,    --
    speed_dp        => speed_dp,
    power_dp        => power_dp);

-- V8 based single board computer
ips1: ips_pcb
  port map (
    -- USB connections
    usbb_dplus	=> host_a_dplus,
    usbb_dminus	=> host_a_dminus,

    -- rs232 interface on the female dsub9 connector J2
    dsub9_F_J2_1 => dsub9_J2_1, -- rs232_dcd, in
    dsub9_F_J2_2 => dsub9_J2_2, -- rs232_txd, out
    dsub9_F_J2_3 => dsub9_J2_3, -- rs232_rxd, in
    dsub9_F_J2_4 => dsub9_J2_4, -- rs232_dsr, in
    dsub9_F_J2_5 => dsub9_J2_5, -- gnd,
    dsub9_F_J2_6 => dsub9_J2_6, -- rs232_dtr, out
    dsub9_F_J2_7 => dsub9_J2_7, -- rs232_cts, in
    dsub9_F_J2_8 => dsub9_J2_8, -- rs232_rts, out
    dsub9_F_J2_9 => dsub9_J2_9, -- OPEN,
    -- JTAG debugger connector via 9 pin D male
    dsub9_F_J4_1 => dsub9_J4_1,--
    dsub9_F_J4_2 => dsub9_J4_2,-- TCK
    dsub9_F_J4_3 => dsub9_J4_3,-- TMS
    dsub9_F_J4_4 => dsub9_J4_4,-- unused
    dsub9_F_J4_5 => dsub9_J4_5,-- gnd,
    dsub9_F_J4_6 => dsub9_J4_6,-- unused
    dsub9_F_J4_7 => dsub9_J4_7,-- TDI
    dsub9_F_J4_8 => dsub9_J4_8,-- TDO
    dsub9_F_J4_9 => dsub9_J4_9);-- unused,

uvjtagtst : vjtagtst
  PORT map (
    dsub9_M_J4_1 => dsub9_J4_1, --
    dsub9_M_J4_2 => dsub9_J4_2, -- connects to slave TCK
    dsub9_M_J4_3 => dsub9_J4_3, -- connects to slave TMS
    dsub9_M_J4_4 => dsub9_J4_4, --
    dsub9_M_J4_5 => dsub9_J4_5, --
    dsub9_M_J4_6 => dsub9_J4_6, --
    dsub9_M_J4_7 => dsub9_J4_7, -- connects to slave TDI
    dsub9_M_J4_8 => dsub9_J4_8, -- connects to slave TDO
    dsub9_M_J4_9 => dsub9_J4_9);--

term: vpc_term                           -- Simulation Display Terminal
  generic map (
    input_fname => "ips1_trm.dat",
    term_label  => "IPS1_TERM")
  port map(
    dsub9_M_J2_1 => dsub9_J2_1, --dcd data carrier detect RS232 signal in
    dsub9_M_J2_2 => dsub9_J2_2, --rxd Receive data output RS232 signal in
    dsub9_M_J2_3 => dsub9_J2_3, --txd Transmit data input RS232 signal out
    dsub9_M_J2_4 => dsub9_J2_4, --dtr data terminal ready RS232 signal out
    dsub9_M_J2_5 => dsub9_J2_5, -- gnd
    dsub9_M_J2_6 => dsub9_J2_6, --dsr data set ready RS232 signal in
    dsub9_M_J2_7 => dsub9_J2_7, --rts request to send RS232 signal out
    dsub9_M_J2_8 => dsub9_J2_8, --cts clear to send RS232 signal in
    dsub9_M_J2_9 => dsub9_J2_9);--ri  ring indicator RS232 signal in

END target_hs;

ARCHITECTURE target_ls of testbnch is -----------------Architecture-----------

COMPONENT ips_pcb
  port(
    -- USB connections
    signal usbb_dplus	: inout std_logic; -- usb channel 0
    signal usbb_dminus	: inout std_logic; -- usb channel 0
    -- rs232 interface on the female dsub9 connector J2
    signal dsub9_F_J2_1	: inout std_logic; -- rs232_dcd, in
    signal dsub9_F_J2_2	: inout std_logic; -- rs232_txd, out
    signal dsub9_F_J2_3	: inout std_logic; -- rs232_rxd, in
    signal dsub9_F_J2_4	: inout std_logic; -- rs232_dsr, in
    signal dsub9_F_J2_5	: inout std_logic; -- gnd,
    signal dsub9_F_J2_6	: inout std_logic; -- rs232_dtr, out
    signal dsub9_F_J2_7	: inout std_logic; -- rs232_cts, in
    signal dsub9_F_J2_8	: inout std_logic; -- rs232_rts, out
    signal dsub9_F_J2_9	: inout std_logic;-- OPEN,
    -- JTAG debugger connector via 9 pin D male
    signal dsub9_F_J4_1	: inout std_logic; -- unused
    signal dsub9_F_J4_2	: inout std_logic; -- TCK
    signal dsub9_F_J4_3	: inout std_logic; -- TMS
    signal dsub9_F_J4_4	: inout std_logic; -- unused
    signal dsub9_F_J4_5	: inout std_logic; -- gnd,
    signal dsub9_F_J4_6	: inout std_logic; -- unused
    signal dsub9_F_J4_7	: inout std_logic; -- TDI
    signal dsub9_F_J4_8	: inout std_logic; -- TDO
    signal dsub9_F_J4_9	: inout std_logic);-- unused,
END COMPONENT;

component host_ctl
  port (
    signal dplus            : inout std_logic;
    signal dminus           : inout std_logic;
    signal usb_A_J1_cpwr    : inout std_logic;
    signal usb_A_J1_dminus  : inout std_logic;
    signal usb_A_J1_dplus   : inout std_logic;
    signal usb_A_J1_cgnd    : inout std_logic;
    -- Hub downstream port status signals
    signal speed_dp         : in  std_logic_vector(16 DOWNTO 1);
    signal power_dp         : in  std_logic_vector(16 DOWNTO 1)
    );
END component;

component vjtagtst
  PORT (
        dsub9_M_J4_1 : inout std_logic;
        dsub9_M_J4_2 : inout std_logic;    -- connects to slave TCK
        dsub9_M_J4_3 : inout std_logic;    -- connects to slave TMS
        dsub9_M_J4_4 : inout std_logic;
        dsub9_M_J4_5 : inout std_logic;
        dsub9_M_J4_6 : inout std_logic;
        dsub9_M_J4_7 : inout std_logic;    -- connects to slave TDI
        dsub9_M_J4_8 : inout std_logic;    -- connects to slave TDO
        dsub9_M_J4_9 : inout std_logic);
END component;

COMPONENT vpc_term
  GENERIC (
        input_fname : string;
        term_label  : string);
  PORT (
        dsub9_M_J2_1  : INOUT std_logic; --dcd data carrier detect RS232 signal
        dsub9_M_J2_2  : INOUT std_logic; --rxd Receive data output RS232 signal to computer
        dsub9_M_J2_3  : INOUT std_logic; --txd Transmit data input RS232 signal from computer
        dsub9_M_J2_4  : INOUT std_logic; --dtr data terminal ready RS232 signal
        dsub9_M_J2_5  : INOUT std_logic; -- gnd
        dsub9_M_J2_6  : INOUT std_logic; --dsr data set ready RS232 signal
        dsub9_M_J2_7  : INOUT std_logic; --rts request to send RS232 signal
        dsub9_M_J2_8  : INOUT std_logic; --cts clear to send RS232 signal
        dsub9_M_J2_9  : INOUT std_logic);--ri  ring indicator RS232 signal
END COMPONENT;

COMPONENT res1206
  PORT (a : IN  std_logic;  -- a input
        z : INOUT std_logic); -- z output
END COMPONENT;

SIGNAL l_line1, r_line1     : std_logic;
SIGNAL dsub9_J2_1, --dcd data carrier detect RS232 signal in to computer
       dsub9_J2_2, --rxd Receive data output RS232 signal in to computer
       dsub9_J2_3, --txd Transmit data input RS232 signal out of computer
       dsub9_J2_4, --dtr data terminal ready RS232 signal out of computer
       dsub9_J2_5, -- gnd
       dsub9_J2_6, --dsr data set ready RS232 signal in to computer
       dsub9_J2_7, --rts request to send RS232 signal out of computer
       dsub9_J2_8, --cts clear to send RS232 signal in to computer
       dsub9_J2_9  --ri  ring indicator RS232 signal in to computer
                            : std_logic;
SIGNAL dsub9_J4_1,    -- not used
       dsub9_J4_2,    -- connects to slave TCK
       dsub9_J4_3,    -- connects to slave TMS
       dsub9_J4_4,    -- not used
       dsub9_J4_5,    -- not used
       dsub9_J4_6,    -- not used
       dsub9_J4_7,    -- connects to slave TDI
       dsub9_J4_8,    -- connects to slave TDO
       dsub9_J4_9     -- not used
                            : std_logic;

SIGNAL host_a_dplus         : std_logic; -- usb_chan1 (host) I/O
SIGNAL host_a_dminus        : std_logic; --
SIGNAL pull_host_a_dplus    : std_logic; -- Speed biasing for host signals
SIGNAL pull_host_a_dminus   : std_logic; --
SIGNAL pull_host_a_dplus_w  : std_logic; -- wire version for verilog translation
SIGNAL pull_host_a_dminus_w : std_logic; --
SIGNAL usb_cpwr,
       usb_dminus,   -- usb channel 0
       usb_dplus,    -- usb channel 0
       usb_cgnd
                            : std_logic;
SIGNAL speed_dp             : std_logic_vector(16 DOWNTO 1);
SIGNAL power_dp             : std_logic_vector(16 DOWNTO 1);

BEGIN	----------------------------------------------------------------
    
speed_dp <= (OTHERS => '0');
power_dp <= (OTHERS => '0');
    
-- Assign regs to wires.
pull_host_a_dplus_w  <= pull_host_a_dplus;
pull_host_a_dminus_w <= pull_host_a_dminus; 

-- Determine resistive bias for low speed device
pull_host_a_dplus  <= '0';
pull_host_a_dminus <= '1';

-- Speed bias resistors
rp_dplus_res  : res1206 PORT MAP ( a => pull_host_a_dplus_w,  z => host_a_dplus);
rp_dminus_res : res1206 PORT MAP ( a => pull_host_a_dminus_w, z => host_a_dminus);

-- USB Host controller
uhost_ctl : host_ctl
  port map (
    dplus           => host_a_dplus,
    dminus          => host_a_dminus,
    usb_A_J1_cpwr   => usb_cpwr,    --
    usb_A_J1_dminus => usb_dminus,  --
    usb_A_J1_dplus  => usb_dplus,   --
    usb_A_J1_cgnd   => usb_cgnd,    --
    speed_dp        => speed_dp,
    power_dp        => power_dp);

-- V8 based single board computer
ips1: ips_pcb
  port map (
    -- USB connections
    usbb_dplus	=> host_a_dplus,
    usbb_dminus	=> host_a_dminus,

    -- rs232 interface on the female dsub9 connector J2
    dsub9_F_J2_1 => dsub9_J2_1, -- rs232_dcd, in
    dsub9_F_J2_2 => dsub9_J2_2, -- rs232_txd, out
    dsub9_F_J2_3 => dsub9_J2_3, -- rs232_rxd, in
    dsub9_F_J2_4 => dsub9_J2_4, -- rs232_dsr, in
    dsub9_F_J2_5 => dsub9_J2_5, -- gnd,
    dsub9_F_J2_6 => dsub9_J2_6, -- rs232_dtr, out
    dsub9_F_J2_7 => dsub9_J2_7, -- rs232_cts, in
    dsub9_F_J2_8 => dsub9_J2_8, -- rs232_rts, out
    dsub9_F_J2_9 => dsub9_J2_9, -- OPEN,
    -- JTAG debugger connector via 9 pin D male
    dsub9_F_J4_1 => dsub9_J4_1,--
    dsub9_F_J4_2 => dsub9_J4_2,-- TCK
    dsub9_F_J4_3 => dsub9_J4_3,-- TMS
    dsub9_F_J4_4 => dsub9_J4_4,-- unused
    dsub9_F_J4_5 => dsub9_J4_5,-- gnd,
    dsub9_F_J4_6 => dsub9_J4_6,-- unused
    dsub9_F_J4_7 => dsub9_J4_7,-- TDI
    dsub9_F_J4_8 => dsub9_J4_8,-- TDO
    dsub9_F_J4_9 => dsub9_J4_9);-- unused,

uvjtagtst : vjtagtst
  PORT map (
    dsub9_M_J4_1 => dsub9_J4_1, --
    dsub9_M_J4_2 => dsub9_J4_2, -- connects to slave TCK
    dsub9_M_J4_3 => dsub9_J4_3, -- connects to slave TMS
    dsub9_M_J4_4 => dsub9_J4_4, --
    dsub9_M_J4_5 => dsub9_J4_5, --
    dsub9_M_J4_6 => dsub9_J4_6, --
    dsub9_M_J4_7 => dsub9_J4_7, -- connects to slave TDI
    dsub9_M_J4_8 => dsub9_J4_8, -- connects to slave TDO
    dsub9_M_J4_9 => dsub9_J4_9);--

term: vpc_term                           -- Simulation Display Terminal
  generic map (
    input_fname => "ips1_trm.dat",
    term_label  => "IPS1_TERM")
  port map(
    dsub9_M_J2_1 => dsub9_J2_1, --dcd data carrier detect RS232 signal in
    dsub9_M_J2_2 => dsub9_J2_2, --rxd Receive data output RS232 signal in
    dsub9_M_J2_3 => dsub9_J2_3, --txd Transmit data input RS232 signal out
    dsub9_M_J2_4 => dsub9_J2_4, --dtr data terminal ready RS232 signal out
    dsub9_M_J2_5 => dsub9_J2_5, -- gnd
    dsub9_M_J2_6 => dsub9_J2_6, --dsr data set ready RS232 signal in
    dsub9_M_J2_7 => dsub9_J2_7, --rts request to send RS232 signal out
    dsub9_M_J2_8 => dsub9_J2_8, --cts clear to send RS232 signal in
    dsub9_M_J2_9 => dsub9_J2_9);--ri  ring indicator RS232 signal in

END target_ls;
-- The usb_dev_async configuration places the V8 and VUSB in to a single FPGA
-- (u_se). It also configures the VUSB to run at the DPLL clock rate
-- 12 Mhz (+/- 4Mhz). The V8 runs asynchronous to the VUSB at a clock rate
-- of 12

CONFIGURATION a_usb_hsdev_async of testbnch is
  FOR target_hs
    FOR all:vjtagtst
      use entity work.vjtagtst(behav);
    END FOR;
    FOR all:ips_pcb
      use entity work.ips_pcb(structural);
      FOR structural
        FOR ALL:ram128k8
          USE ENTITY work.ram128k8(behavioral)
            GENERIC MAP (infname => "ram128k8.hex");
        END FOR;
        FOR ualt1:a10k240
          use entity work.a10k240(empty);
        END FOR;
        FOR uxil1:xil240hq
          use entity work.xil240hq(struct);
          FOR struct
            FOR v8:asic_v8
              use entity work.asic_v8(rtl);
              FOR rtl
                FOR rom:bistrom
                  use entity work.bistrom(behavioral);
                END FOR;
                FOR uclk_ctl:clk_ctl
                  use entity work.clk_ctl(fpga);
                END FOR; -- uclk_ctl:clk_ctl
                FOR usb:vusb_top
                  use entity work.vusb_top(async);
                END FOR; -- usb:vusb_top
                FOR pp:v1284
                  use entity work.v1284(empty);
                  -- use entity work.v1284(synth); -- about 1000 gates?
                END FOR;
                FOR cpu:v8_top
                  use entity work.v8_top(rtl);
                  FOR rtl
                    FOR u_v8_regs:v8_regs
                      USE entity work.v8_regs(rtl);
                    END FOR; -- u_v8_regs:v8_regs
                  END FOR; -- rtl
                END FOR; -- cpu:v8_top
              END FOR; -- rtl
            END FOR; -- v8:asic_v8
          END FOR; -- struct
        END FOR; -- uxil1:xil240hq
      END FOR;
    END FOR;
  END FOR; -- target_hs
end a_usb_hsdev_async;

-- The usb_dev_sync configuration places the V8 and VUSB in to a single
-- ASIC (uxil1). It also configures the VUSB and V8 to run at a clock rate of
-- 48 Mhz. The USB logic runs on a chip enable that locks to the 12 Mbs data
-- rate of USB.

CONFIGURATION a_usb_hsdev_sync of testbnch is
  FOR target_hs
    FOR all:vjtagtst
      use entity work.vjtagtst(behav);
    END FOR;
    FOR all:ips_pcb
      use entity work.ips_pcb(structural);
      FOR structural
        FOR ALL:ram128k8
          USE ENTITY work.ram128k8(behavioral)
            GENERIC MAP (infname => "ram128k8.hex");
        END FOR;
        FOR ualt1:a10k240
          use entity work.a10k240(empty);
        END FOR;
        FOR uxil1:xil240hq
          use entity work.xil240hq(struct);
          FOR struct
            FOR v8:asic_v8
              use entity work.asic_v8(rtl);
              FOR rtl
                FOR rom:bistrom
                  use entity work.bistrom(behavioral);
                END FOR;
                FOR uclk_ctl:clk_ctl
                  use entity work.clk_ctl(asic);
                END FOR; -- uclk_ctl:clk_ctl
                FOR usb:vusb_top
                  use entity work.vusb_top(sync);
                END FOR; -- usb:vusb_top
                FOR pp:v1284
                  use entity work.v1284(empty);
                  -- use entity work.v1284(rtl); -- about 1000 gates?
                END FOR;
                FOR cpu:v8_top
                  use entity work.v8_top(rtl);
                  FOR rtl
                    FOR u_v8_regs:v8_regs
                      USE entity work.v8_regs(rtl);
                    END FOR; -- u_v8_regs:v8_regs
                  END FOR; -- rtl
                END FOR; -- cpu:v8_top
              END FOR; -- rtl
            END FOR; -- v8:asic_v8
          END FOR; -- struct
        END FOR; -- uxil1:xil240hq
      END FOR; -- structural
    END FOR; -- all:ips_pcb
  END FOR; -- target_hs
end a_usb_hsdev_sync;

CONFIGURATION a_usb_lsdev_sync of testbnch is
  FOR target_ls
    FOR all:host_ctl
      use entity work.host_ctl(behav) GENERIC MAP (lsdev => 1);
    END FOR; -- all:host_ctl
    FOR all:vjtagtst
      use entity work.vjtagtst(empty);
    END FOR;
    FOR all:ips_pcb
      use entity work.ips_pcb(structural);
      FOR structural
        FOR ALL:ram128k8
          USE ENTITY work.ram128k8(behavioral)
            GENERIC MAP (infname => "ram128k8.hex");
        END FOR;
        FOR ualt1:a10k240
          use entity work.a10k240(empty);
        END FOR;
        FOR uxil1:xil240hq
          use entity work.xil240hq(struct) GENERIC MAP (lsdev => 1);
          FOR struct
            FOR v8:asic_v8
              use entity work.asic_v8(rtl);
              FOR rtl
                FOR rom:bistrom
                  use entity work.bistrom(behavioral);
                END FOR;
                FOR uclk_ctl:clk_ctl
                  use entity work.clk_ctl(asic);
                END FOR; -- uclk_ctl:clk_ctl
                FOR usb:vusb_top
                  use entity work.vusb_top(sync) GENERIC MAP (lsdev => 1);
                  FOR sync
                    FOR pll:dpllnrzi
                      USE ENTITY work.dpllnrzi(rtl) GENERIC MAP (lsdev => 1);
                    END FOR;
                    FOR usb:vusb
                      FOR structure
                        FOR u2:usb_sie
                          USE ENTITY work.usb_sie(rtl) GENERIC MAP (lsdev => 1);
                        END FOR;
                      END FOR;
                    END FOR;
                  END FOR;
                END FOR; -- usb:vusb_top
                FOR pp:v1284
                  use entity work.v1284(empty);
                  -- use entity work.v1284(rtl); -- about 1000 gates?
                END FOR;
                FOR cpu:v8_top
                  use entity work.v8_top(rtl);
                  FOR rtl
                    FOR u_v8_regs:v8_regs
                      USE entity work.v8_regs(rtl);
                    END FOR; -- u_v8_regs:v8_regs
                  END FOR; -- rtl
                END FOR; -- cpu:v8_top
              END FOR; -- rtl
            END FOR; -- v8:asic_v8
          END FOR; -- struct
        END FOR; -- uxil1:xil240hq
      END FOR; -- structural
    END FOR; -- ips_pcb
  END FOR; -- target_ls
end a_usb_lsdev_sync;
