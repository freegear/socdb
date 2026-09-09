-----------------------------------------------------------------------------
-- Copyright 1995-1998 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
-- File: host_ctl.vhd
--
-- Revision: $Name: REV9911b $
--
-- Description:
-- 	This is the Host controller model for the USB Test Bench.
--
-- Signals ending in _n are active low.
-- Revision History
-- $Log: host_ctl.vhd,v $
-- Revision 1.74  1999/12/22 21:42:10  chris
-- Remove redundant Ack packet from Get Device Decsriptor.
-- Added Intel application specific support.
--
-- Revision 1.73  1999/11/17 20:42:59  mark
-- * increased SOF_HOLD_OFF_TIME to 260 us to compensate for software changes
--
-- Revision 1.72  1999/11/17 19:44:42  mark
-- * updated data_toggle_test procedure
-- * broke signal 'dtoggle' into 'dtoggle_in' and 'dtoggle_out'
--     - updated throughout file the effects of using dtogge_in/out
--       and software updates to reset data toggle on device side.
--
-- Revision 1.71  1999/11/10 17:47:04  gregg
-- Fixed packet data length to not violate LS devices
--
-- Revision 1.70  1999/11/10 10:16:56  mark
-- clean up data_toggle_test procedure for Makerelease
--
-- Revision 1.69  1999/11/09 14:16:11  mark
-- updated data_toggle_test - endpt2 data toggle and host data
-- toggle are synchronized.
--
-- Revision 1.68  1999/11/05 13:52:30  mark
-- added 'handshake := nack;' before handshake LOOPS to prevent
-- accidental bypassing of these LOOPS.
-- * redesigned data_toggle_test procedure - includes clearFeature(ENDPT_HALT)
-- * added complete usb reset at end of 'handshake_precedence_test'.  This
-- is to resynchronize EVEN/ODD buffer pointers between device & host.
-- * cleaned up some indentations.
--
-- Revision 1.67  1999/11/01 17:45:05  mark
-- commented out 'data_toggle_test' procedure from checklist_enabled IF/THEN
-- section since it doesn't work yet.
--
-- Revision 1.66  1999/11/01 16:29:16  mark
-- Updated checklist_enabled IF/THEN section so that all procedures
-- but 'data_toggle_test' work for both LOW and HIGH speed device. This
-- was fulfill obligation to Microchip.
--
-- Revision 1.65  1999/09/10 22:45:19  gregg
-- Removed false BTO test and fixed max eop time to be USB 1.1 compiliant
--
-- Revision 1.64  1999/08/11 00:25:41  chris
-- Increased reset time for software.
--
-- Revision 1.63  1999/07/30 20:54:12  chris
-- Merged in changes from branch 1.54.1 (REV9902a) for hub testing.
--
-- Revision 1.62  1999/07/11 00:00:05  chris
-- Fixed typo in error checks.  Added time to initial reset.
--
-- Revision 1.61  1999/07/02 20:34:35  chris
-- Added checks for error interrupts for: BTS DFN8 CRC5 and CRC16.
--
-- Revision 1.60  1999/06/24 20:08:18  chris
-- Added lsdev generic, and fixed get_data routine.
--
-- Revision 1.59  1999/05/26 13:08:49  gregg
-- Removed dplus and dminus pulldowns
--
-- Revision 1.58  1999/05/19 15:40:18  gregg
-- Increased SOF_HOLD_OFF_TIME to 250 us
--
-- Revision 1.57  1999/05/19 12:13:20  gregg
-- Completed low speed support
--
-- Revision 1.56  1999/04/07 19:52:00  gregg
-- Make changed to support low speed peripherals
--
-- Revision 1.55  1999/03/31 23:39:17  gregg
-- Added support for low speed peripherals.
--
-- Revision 1.54.1.1  1999/06/11 21:07:08  chris
-- Added code to put port 1 in an attached state prior to the
-- assertion of the remote wake up signal from port 1.
--
-- Revision 1.54  1999/03/05 17:07:39  john
-- Fixed type error.
--
-- Revision 1.53  1999/03/05 16:46:40  john
-- Changed associative order of get_data calls.
--
-- Revision 1.52  1999/03/04 08:02:52  john
-- Added disconnect at end of bus_enumeration_hub test.
--
--
-- Revision 1.51  1998/12/08 18:45:43  john
-- Another change to hub descriptor power mask.
--
-- Revision 1.50  1998/12/07 19:57:51  chris
-- Updated Hub Port Power control mask.
--
-- Revision 1.49  1998/11/17 16:05:29  chris
-- Increased the length of the initial USB reset to cover the increase in JTAG testing time.
-- Removed the reset from the handshake presidence test.
-- Added a BTO retry count to the setup stage of get descriptor.
--
-- Revision 1.48  1998/11/12 16:56:46  john
-- Made some changes to the hub_suspend test.
--
-- Revision 1.47  1998/11/12 15:35:48  chris
-- Debugged stall and token restart tests.
-- Moved all echo test off endpoint 0.
--
-- Revision 1.46  1998/10/30 11:12:05  john
-- Added new i/o to support hub testbench. Added hub_suspend section.
-- Modified Chapter 11 and hub_enumeration tests for 9811 release.
--
-- Revision 1.45  1998/10/28 15:50:15  chris
-- Added Protocol and Endpoint Halt Stall testing.
-- Rewrote the token restart test.
--
-- Revision 1.44  1998/09/23 14:49:52  chris
-- Added additional time to USB_RESETs, In lined all variable initializations
-- in procedures to support translation to verilog.
--
-- Revision 1.43  1998/09/17 15:26:46  john
-- Added real interrupt endpoint handling for hub_enumeration.
--
-- Revision 1.42  1998/09/02 20:15:14  john
-- Changed expected values for hub descriptor.
--
-- Revision 1.41  1998/09/01 15:28:25  chris
-- Added some special tests for ISO streams (requires different software).
-- Moved 3ms delay and added signal wait_for_frame_lock_enable.
-- Extended USB reset to cover the time used in JTAG testing.
--
-- Revision 1.40  1998/07/30 14:33:37  chris
-- Fixed PRE_PID preamble prepending on low speed packet.
--
-- Revision 1.39  1998/07/30 12:47:32  chris
-- Added support for low speed packets.
--
-- Revision 1.37  1998/07/28 19:22:19  chris
-- Turned hub downstream enumeration on.
--
-- Revision 1.36  1998/07/24 18:34:37  gregg
-- Updated for release 9807
--
-- Revision 1.35  1998/07/23 22:22:26  chris
-- Converted hub times from ms to ns.
--
-- Revision 1.34  1998/07/20 22:14:04  chris
-- Recoded the behavioral PLL for conversion to verilog.
--
-- Revision 1.33  1998/07/20 15:16:33  chris
-- Changed argument order in iso_echo_test to match the calling order, because explicit
-- parameter definitions in procudure and task calls are ignored by vhdl2v.
--
-- Revision 1.32  1998/07/17 16:15:10  chris
-- Removed delay from hc_state assignments, that caused a problem in Verilog.
--
-- Revision 1.31  1998/07/17 01:29:05  chris
-- Fixed SE0 check in data_in_packet.
--
-- Revision 1.30  1998/07/16 23:59:50  gregg
-- More makerelease changes
--
-- Revision 1.29  1998/07/16 22:11:11  gregg
-- More makerelease changes
--
-- Revision 1.28  1998/07/16 17:06:21  john
-- Added delay at end of hub enumeration test.
--
-- Revision 1.27  1998/07/15 10:34:24  john
-- Added changes to hub_enumeration test.
--
-- Revision 1.26  1998/07/15 09:20:18  chris
-- Clean up for Release.
--
-- Revision 1.25  1998/07/13 15:28:31  chris
-- Improved get_data for use in get_hub_descriptor and get_string_descriptor.
-- Removed use usb_pkg dependance.
-- Moved get string descriptors to chapter 9 section.
--
-- Revision 1.24  1998/07/13 14:30:39  gregg
-- Renamed index3 & index4 to index0. Removed initial conditions
-- on want_clk & next_want_clk. Both changes were for vhdl2v conversion
--
-- Revision 1.23  1998/07/10 17:03:43  chris
-- Added new procedure headers.
--
-- Revision 1.22  1998/07/01 05:20:19  chris
-- Added wait for SOF to ISO echo test.  Initialized m_pkt to 64 bytes.
--
-- Revision 1.21  1998/06/26 14:07:43  chris
-- Fixed Get Device Descriptor and Get Config descriptor.
--
-- Revision 1.20  1998/06/25 17:27:18  chris
-- Added periodic SOF generation.
-- Changed Get Device and Get Configuration Descriptor to handle a smaller
-- max packet size.
-- ********************  get_confic_desc is not debugged!!! *********
--
-- Revision 1.19  1998/06/12 16:45:44  chris
-- Fixed NAK section of tx_pid_test.
--
-- Revision 1.18  1998/06/09 15:26:58  chris
-- Added behavioral PLL to recover target clock.
-- Changed all status phases of Setup transfers to DATA1.
--
-- Revision 1.17  1998/05/29 16:41:49  chris
-- Added clock switching circuit.
--
-- Revision 1.16  1998/05/13 19:09:43  chris
-- Corrected glitches in vusb9804c release.
-- Made changes to support translation to verilog.
--
-- Revision 1.15  1998/05/11 18:59:40  eric
-- Now converts to verilog without syntax errors...
--
-- Revision 1.14  1998/05/11  16:55:48  chris
-- Recoded the tx_pid and handshake precedence tests.
--
-- Revision 1.13  1998/05/08 14:37:53  chris
-- Masked off DMA_ERR when checking the returned target status.
--
-- Revision 1.12  1998/04/30 17:40:05  eric
-- Cannot convert parameters of parameters to verilog.
--
-- Revision 1.11  1998/04/29 14:34:06  chris
-- Set the initial reset length back to 2 ms.
--
-- Revision 1.10  1998/04/29 13:32:25  chris
-- Worked on and enabled quick check section.
--
-- Revision 1.9  1998/04/24 16:18:29  chris
-- Changed receive data clocking to default to host phase 0.
-- Fixed String lenght on get string descriptor.
-- Fixed data toggle synchronization on several of the transactions.
--
-- Revision 1.8  1998/04/22 12:55:44  eric
-- Improved verilog translation.
--
-- Revision 1.7  1998/03/27 21:03:12  chris
-- Added delay on target clock to insure hold time.
--
-- Revision 1.6  1998/03/13 23:56:36  chris
-- Updated the configuration descriptor value.
--
-- Revision 1.5  1998/02/24 15:19:26  chris
-- Jumpered around the USB connector models.
-- Added delay term to USB activity monitor.
--
-- Revision 1.4  1998/01/20 13:48:39  chris
-- Turned on chapter 9 tests and added a set interface to restore
-- the value to 0, so this test chapter 9 tests would not cause the
-- bus enumeration to fail.
--
-- Revision 1.3  1997/11/20 14:31:13  chris
-- Shortened the initial bus reset time.
--
-- Revision 1.2  1997/10/16 12:22:37  chris
-- Corrected Get Configuration Descriptor check values.
-- Corrected Bulk testing and added Iso testing in bus enumeration test.
--
-- Revision 1.1  1997/10/15 11:52:35  chris
-- Initial revision
--
-- Copied the body of the host controller code from the  USB testbnch.vhd file.
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;  -- We use the IEEE standard 1164 logic types.
USE ieee.std_logic_arith.ALL; -- We use the IEEE standard 1164 arithmetic package.
USE work.cfg_usb.ALL;

ENTITY host_ctl IS	------------------------------ENTITY--------------------
  GENERIC (lsdev : integer := LOW_SPEED_DEV);
  PORT (
    SIGNAL dplus            : INOUT std_logic;
    SIGNAL dminus           : INOUT std_logic;
    SIGNAL usb_A_J1_cpwr    : INOUT std_logic;
    SIGNAL usb_A_J1_dminus  : INOUT std_logic;
    SIGNAL usb_A_J1_dplus   : INOUT std_logic;
    SIGNAL usb_A_J1_cgnd    : INOUT std_logic;

    -- Hub downstream port control signals
    port_sel     : OUT std_logic_vector(4  DOWNTO 0);
    low_speed_dp : OUT std_logic_vector(16 DOWNTO 1);
    connect_dp   : OUT std_logic_vector(16 DOWNTO 1);
    rmt_wake_dp  : OUT std_logic_vector(16 DOWNTO 1);

    -- Hub downstream port status signals
    speed_dp     : IN  std_logic_vector(16 DOWNTO 1);
    power_dp     : IN  std_logic_vector(16 DOWNTO 1)
    );

END host_ctl;

ARCHITECTURE behav OF host_ctl IS -----------------Architecture-----------

-- signals to enable different sections of the test bench.  While these signals
-- are normally static, making them signals rather than constants allows the
-- test bench operation to be modified without recompiling.

SIGNAL sof_special_test_enabled : boolean := false;
SIGNAL chapter_9_tests_enabled  : boolean := true;
SIGNAL chapter_11_tests_enabled : boolean := false;
SIGNAL bus_enumeration_target_enabled  : boolean := true;
SIGNAL bus_enumeration_hub_enabled  : boolean := false;
SIGNAL wait_for_frame_lock_enable : boolean := false; -- wait for frame lock
                                    -- before proceding (for hub testing).
SIGNAL low_speed_thru_hub_enabled   : boolean := false;
SIGNAL quick_check_enabled      : boolean := true;
SIGNAL checklist_enabled        : boolean := false;
SIGNAL verbose                  : boolean := false; -- increase the number of
                                                    -- informational messages.
SIGNAL terse                    : boolean := false; -- cut the number of
                                                    -- informational messages.
SIGNAL hub_global_suspend       : boolean := false;


-- USB Logic states
TYPE usb_logic IS (X, J, K, Z, SE0);

-- Memory data structures.
TYPE BYTE_ARRAY IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

-- USB Host Controller (HC) states
-- The HC states are defined below. These states are useful to debug test
-- bench development for USB target devices. It displays what data is
-- currently being transmitted or received by the host controller code.
-- HC States:
-- hc_idle    - HC is in idle state, awaiting a command
-- hc_reset   - HC is in reset state, asserting reset signaling
-- hc_suspend - HC is in suspend state, no downstream traffic
-- hc_resume  - HC is in resume state, asserting resume signaling
-- tx_manu  - HC is offline while the signals are manipulated manually
-- tx_sync  - HC is transmitting a SYNC field.
-- tx_pid   - HC is transmitting a PID field.
-- tx_addr  - HC is transmitting a address field.
-- tx_endp  - HC is transmitting a endpoint field.
-- tx_crc5  - HC is transmitting the CRC5 field.
-- tx_eop   - HC is transmitting end of packet field.
-- tx_fnum  - HC is transmitting frame number field.
-- tx_data  - HC is transmitting DATA field.
-- tx_crc16 - HC is transmitting the CRC16 field.
-- rx_wait  - HC is waiting for data reception.
-- rx_sync  - HC is receiving a sync field.
-- rx_pid   - HC is receiving a PID field.
-- rx_addr  - HC is receiving a address field.
-- tx_endp  - HC is receiving a endpoint field.
-- rx_crc5  - HC is receiving the CRC5 field.
-- rx_eop   - HC is receiving a end of packet field.
-- rx_data  - HC is receiving a DATA field.
-- rx_crc16 - HC is receiving the CRC16 field.
TYPE usb_hc_states IS (hc_idle, hc_reset, hc_suspend, hc_resume,
                       tx_manu, tx_sync,
                       tx_pid, tx_addr, tx_endp, tx_crc5, tx_eop,
                       tx_fnum, tx_data, tx_crc16, rx_wait,rx_sync,
                       rx_pid, rx_addr, rx_endp, rx_crc5, rx_eop,
                       rx_data,rx_crc16);

-- Define the posible data handshakes.
TYPE hand_shake_type IS (ack_hs, nak_hs, stall_hs, data_hs, bto_hs);

TYPE checking_type IS (check, no_check,iso_check,iso_no_check);

TYPE usb_pid_type IS (out_t,in_t,sof,setup,data0,data1,ack,nak,stall,pre,x);

TYPE configuration_type IS (hub, device, composit_hub, composit_device);

TYPE clock_master_type IS (target, host_p0, host_p1);
TYPE clock_margin_type IS (fast, slow, normal);

-- Define the three types of test data patterns used when building
-- packet data from transmission on reception.
-- INC - Each data value is incremented from starting value
-- DEC - Each data value is decrementedfrom starting value
-- RND - Each data value is a psuedo-random function value
TYPE data_patterns IS (INC, DEC, RND);


-- Define USB PID constants
CONSTANT OUT_PID       : integer :=   1; -- Token out PID
CONSTANT IN_PID        : integer :=   9; -- Token in PID
CONSTANT SOF_PID       : integer :=   5; -- Token sof PID
CONSTANT SETUP_PID     : integer :=  13; -- Token setup PID
CONSTANT DATAX_PID     : integer :=  15; -- Data PID to be used with data
                                         -- toggle bit for testbench
CONSTANT DATA0_PID     : integer :=   3; -- Data0 PID
CONSTANT DATA1_PID     : integer :=  11; -- Data1 PID
CONSTANT ACK_PID       : integer :=   2; -- Handshake ack PID
CONSTANT NAK_PID       : integer :=  10; -- Handshake nak PID
CONSTANT STALL_PID     : integer :=  14; -- Handshake stall PID
CONSTANT PRE_PID       : integer :=  12; -- Special PID

CONSTANT NUMBER_OF_PORTS : integer := 6; -- Number of hub downstream ports.

--CONSTANT USB_BIT_TIME : time := 667 ns;  -- when USB_SPEED = low_speed
--CONSTANT USB_BIT_TIME : time := 83 ns;   -- when USB_SPEED = full_speed else
-- CONSTANT USB_BIT_FAST : time := USB_BIT_TIME - 1.4 ns; -- Bit times for
-- CONSTANT USB_BIT_SLOW : time := USB_BIT_TIME + 1.4 ns; -- clock margining
-- adjust the times to work within 1 ns simulator resolution
CONSTANT FS_USB_BIT_TIME : time := 80 ns;     -- when USB_SPEED = full_speed else
CONSTANT FS_USB_BIT_FAST : time := FS_USB_BIT_TIME - 1 ns; -- Bit times for
CONSTANT FS_USB_BIT_SLOW : time := FS_USB_BIT_TIME + 1 ns; -- clock margining

CONSTANT LS_USB_BIT_TIME : time := 640 ns;     -- when USB_SPEED = low_speed else
CONSTANT LS_USB_BIT_FAST : time := LS_USB_BIT_TIME - 16 ns; -- Bit times for
CONSTANT LS_USB_BIT_SLOW : time := LS_USB_BIT_TIME + 16 ns; -- clock margining

--CONSTANT BUS_TIMEOUT  : time := 16 * USB_BIT_TIME;
CONSTANT SOF_INTERVAL : time := 1000000 ns;    -- 1 ms Interval between SOF packets
CONSTANT SOF_HOLD_OFF_TIME : time := 260000 ns;-- 260 us blanking period before SOF's
CONSTANT WATCH_DOG    : time := 500000 ns;  -- 500 us If a transaction doesn't
                                            -- respond inthis time something is wrong.

-- Masks for decoding the returned status from the diagnostic driver.
CONSTANT RESET_MASK   : std_logic_vector(7 DOWNTO 0) := "00000001";
CONSTANT SUSPEND_MASK : std_logic_vector(7 DOWNTO 0) := "00000010";
CONSTANT ERROR_MASK : std_logic_vector(7 DOWNTO 0) := "00000100";

CONSTANT USB_STR_1_LEN	: integer := 32 ; -- Device Manufacturer
CONSTANT USB_STR_2_LEN	: integer := 58	; -- Product Descriptor
CONSTANT USB_STR_3_LEN	: integer := 10	; -- Serial Number
CONSTANT USB_STR_4_LEN	: integer := 8	; -- Configuration 01 descriptor
CONSTANT USB_STR_5_LEN	: integer := 8	; -- Interface 01 descriptor
CONSTANT USB_STR_6_LEN	: integer := 28	; -- P1284 Interface 02
CONSTANT USB_STR_7_LEN	: integer := 34	; -- Hub Descriptor string
CONSTANT USB_STR_n_LEN	: integer := 34	; -- Other string indexes


COMPONENT usbconna
  PORT (pin1 : INOUT std_logic;
        pin2 : INOUT std_logic;
        pin3 : INOUT std_logic;
        pin4 : INOUT std_logic;
	contact1 : INOUT std_logic;
        contact2 : INOUT std_logic;
        contact3 : INOUT std_logic;
        contact4 : INOUT std_logic
        );
END COMPONENT;

-- Signals for USB clock generation;
SIGNAL usb_clk             : std_logic; -- USB clock
SIGNAL next_usb_clk        : std_logic; -- USB clock
SIGNAL jitter_time : time := 15 ns;
SIGNAL jitter_delay_time : time := 0 ns;
SIGNAL host_p0_usb_clk : std_logic;      -- host phase 0 clock
SIGNAL host_p1_usb_clk : std_logic;      -- host phase 1 clock
SIGNAL host_jitter_usb_clk : std_logic;  -- host p0 clock with jitter
SIGNAL host_fast_usb_clk   : std_logic;  -- host clock margined fast
SIGNAL host_slow_usb_clk   : std_logic;  -- host clock margined slow
SIGNAL target_usb_clk      : std_logic;  -- clock from usb sie PLL.
SIGNAL want_rising         : std_logic;  -- event signal for clock generation
SIGNAL clk_start           : std_logic;  -- signal to trigger starting the
                                         -- target_usb_dpll.
SIGNAL clock_master        : clock_master_type := host_p0;
SIGNAL clock_master_save   : clock_master_type := host_p0;
SIGNAL clock_margin        : clock_margin_type := normal;
SIGNAL clock_jitter_time   : time := 0 ns;
SIGNAL clock_jitter_delay  : time := 0 ns;
SIGNAL want_clk            : std_logic_vector(3 DOWNTO 0);
SIGNAL next_want_clk       : std_logic_vector(3 DOWNTO 0);
SIGNAL clock_switch        : std_logic := '0';
SIGNAL clock_switch_clr    : std_logic := '0';

SIGNAL usb_bit_time        : time := 80 ns; -- signals for manipulating clock and delay
SIGNAL usb_bit_fast        : time := 78 ns; -- periods between low and full speed operation
SIGNAL usb_bit_slow        : time := 82 ns;
SIGNAL bus_timeout         : time := 1280 ns;
SIGNAL clock_low_speed     : boolean := false;

SIGNAL usb_kstate : std_logic; -- USB Bus is in K state
SIGNAL usb_state  : usb_logic; -- USB Logic states
SIGNAL usb_bto    : std_logic := '0'; -- Event Signal for triggering a bus timeout.
SIGNAL usb_watch_dog : std_logic := '0'; -- Event Signal for triggering a watch
                                         -- dog timeout.
SIGNAL usb_pid    : usb_pid_type; -- USB PIDs
SIGNAL usb_bit_value : std_logic; -- USB Logic bit stream values
SIGNAL dplus_no_connect     : std_logic; -- USB data+ signal
SIGNAL dminus_no_connect    : std_logic; -- USB data- signal
SIGNAL usb_pwr_no_connect : std_logic;
-- The hc_state signal is used to display what state the host controller
-- is currently in. This is very useful when tranmitting NRZI data because
-- this signal will diplay what the host controller is transmitting or
-- receiving.
SIGNAL hc_state  : usb_hc_states; -- USB Host Controller state
SIGNAL hc_sof_state  : usb_hc_states; -- USB Host Controller state
SIGNAL hc_idle_activity  : boolean; -- Something is happening when the
                    -- when the host controller says USB should be idle
SIGNAL sof_enable  : boolean := true;   -- enable periodic SOF generation.
SIGNAL sof_request : std_logic;   -- periodic request signal for host
                                  -- controller SOF generation.
SIGNAL sof_hold_off : std_logic;  -- periodic signal to suppress host token
                                  -- generation prior to SOF request event.
-- NOTE: For test of rx host controller proceedures only!
SIGNAL tgt_state  : usb_hc_states; -- USB Host Controller state

SIGNAL usboe_n : std_logic; -- USB ouput enable
SIGNAL usbrcv  : std_logic; -- USB receive data
SIGNAL dpi     : std_logic; -- Data plus in
SIGNAL dmi     : std_logic; -- Data minus in
SIGNAL suspnd  : std_logic; -- Suspend
SIGNAL speed   : std_logic; -- Speed
SIGNAL dpo     : std_logic; -- Data plus out
SIGNAL dmo     : std_logic; -- Data minus out
SIGNAL gnd     : std_logic; -- Ground
SIGNAL vcc3    : std_logic; -- VCC power supply (3.3V!!!)
--SIGNAL dtoggle : std_logic := '0'; -- data toggle synchronization signal
SIGNAL dtoggle_in  : std_logic := '0'; -- data toggle synch signal IN
SIGNAL dtoggle_out : std_logic := '0'; -- data toggle synch signal OUT

-- Test signals only for DPLL
SIGNAL usbclkx8 : std_logic; -- High speed clock - 8x data rate
SIGNAL reset    : std_logic; -- Reset the PLL. CLKOUT stops.
SIGNAL rcv_nrzi : std_logic; -- USB Receive Data NRZI
SIGNAL rcv_nrz  : std_logic; -- USB Receive Data NRZ
SIGNAL sclk     : std_logic; -- Clock output

SIGNAL dplus_pulldn  : std_logic;         -- Pull down signal for dplus
SIGNAL dminus_pulldn : std_logic;         -- Pull down signal for dminus
-- Test bench control signals
-- The test bench done signal can be used with your VHDL simulator to halt
-- simulations. Just setup a breakpoint so when tb_done = true simulation stops.
SIGNAL tb_done        : boolean; -- Test bench done
SIGNAL test_value, exp_value : integer;-- signals to provide additional debug
                                       -- information.
SIGNAL test_progress         : integer := 0;-- signal to provide additional
                                            -- debug information about how far
                                            -- the in test has progressed in
                                            -- the main test process.


--------------------------------------------------------------------------------
--
-- Function: rand
--
-- Parameters: seed -- Random number seed
--
-- Description: This function will generate random numbers based on the seed.
--
--------------------------------------------------------------------------------

FUNCTION rand(seed : integer) RETURN integer IS
BEGIN

  -- Not the most random of sequences... but easy.
  RETURN((557*seed + 997)/32);

END;

-- This function is not used in verilog (file IO in verilog is hard).
--------------------------------------------------------------------------------
--
-- Function: vec2asci
--
-- Parameters: v input byte in std_logic_vector
--
-- Description: This function returns an ascii character based on the input
-- byte v.
--
--------------------------------------------------------------------------------

   FUNCTION vec2asci      (v: std_logic_vector(7 DOWNTO 0))  RETURN character IS
   BEGIN
      CASE v IS
	WHEN "00001101" => RETURN (' '); -- CR
	WHEN "01000001" => RETURN ('A');
	WHEN "01000010" => RETURN ('B');
	WHEN "01000011" => RETURN ('C');
	WHEN "01000100" => RETURN ('D');
	WHEN "01000101" => RETURN ('E');
	WHEN "01000110" => RETURN ('F');
	WHEN "01000111" => RETURN ('G');
	WHEN "01001000" => RETURN ('H');
	WHEN "01001001" => RETURN ('I');
	WHEN "01001010" => RETURN ('J');
	WHEN "01001011" => RETURN ('K');
	WHEN "01001100" => RETURN ('L');
	WHEN "01001101" => RETURN ('M');
	WHEN "01001110" => RETURN ('N');
	WHEN "01001111" => RETURN ('O');
	WHEN "01010000" => RETURN ('P');
	WHEN "01010001" => RETURN ('Q');
	WHEN "01010010" => RETURN ('R');
	WHEN "01010011" => RETURN ('S');
	WHEN "01010100" => RETURN ('T');
	WHEN "01010101" => RETURN ('U');
	WHEN "01010110" => RETURN ('V');
	WHEN "01010111" => RETURN ('W');
	WHEN "01011000" => RETURN ('X');
	WHEN "01011001" => RETURN ('Y');
	WHEN "01011010" => RETURN ('Z');
	WHEN "01100001" => RETURN ('a');
	WHEN "01100010" => RETURN ('b');
	WHEN "01100011" => RETURN ('c');
	WHEN "01100100" => RETURN ('d');
	WHEN "01100101" => RETURN ('e');
	WHEN "01100110" => RETURN ('f');
	WHEN "01100111" => RETURN ('g');
	WHEN "01101000" => RETURN ('h');
	WHEN "01101001" => RETURN ('i');
	WHEN "01101010" => RETURN ('j');
	WHEN "01101011" => RETURN ('k');
	WHEN "01101100" => RETURN ('l');
	WHEN "01101101" => RETURN ('m');
	WHEN "01101110" => RETURN ('n');
	WHEN "01101111" => RETURN ('o');
	WHEN "01110000" => RETURN ('p');
	WHEN "01110001" => RETURN ('q');
	WHEN "01110010" => RETURN ('r');
	WHEN "01110011" => RETURN ('s');
	WHEN "01110100" => RETURN ('t');
	WHEN "01110101" => RETURN ('u');
	WHEN "01110110" => RETURN ('v');
	WHEN "01110111" => RETURN ('w');
	WHEN "01111000" => RETURN ('x');
	WHEN "01111001" => RETURN ('y');
	WHEN "01111010" => RETURN ('z');
	WHEN "00100000" => RETURN (' ');
	WHEN "00100001" => RETURN ('!');
	WHEN "00101000" => RETURN ('(');
	WHEN "00101001" => RETURN (')');
	WHEN "00101110" => RETURN ('.');
	WHEN "00111111" => RETURN ('?');
	WHEN "00110000" => RETURN ('0');
	WHEN "00110001" => RETURN ('1');
	WHEN "00110010" => RETURN ('2');
	WHEN "00110011" => RETURN ('3');
	WHEN "00110100" => RETURN ('4');
	WHEN "00110101" => RETURN ('5');
	WHEN "00110110" => RETURN ('6');
	WHEN "00110111" => RETURN ('7');
	WHEN "00111000" => RETURN ('8');
	WHEN "00111001" => RETURN ('9');
	WHEN "00111101" => RETURN ('=');
	WHEN "01011011" => RETURN ('[');
	WHEN "01011101" => RETURN (']');
	WHEN OTHERS => RETURN ('?');
      END CASE;
   END;


--------------------------------------------------------------------------------
--
-- Function: to_pid_type
--
-- Parameters: dplus dminus -- USB differential signal lines
--
-- Description: This function returns a displayable enumerated PID type based
-- on an interger PID input.
--
--------------------------------------------------------------------------------

  FUNCTION to_pid_type(int_pid : integer) RETURN usb_pid_type IS
    VARIABLE usb_pid: usb_pid_type;
  BEGIN
    CASE int_pid IS
      WHEN OUT_PID     => usb_pid := out_t;
      WHEN IN_PID      => usb_pid := in_t;
      WHEN SOF_PID     => usb_pid := sof;
      WHEN SETUP_PID   => usb_pid := setup;
      WHEN DATA0_PID   => usb_pid := data0;
      WHEN DATA1_PID   => usb_pid := data1;
      WHEN ACK_PID     => usb_pid := ack;
      WHEN NAK_PID     => usb_pid := nak;
      WHEN STALL_PID   => usb_pid := stall;
      WHEN PRE_PID     => usb_pid := pre;
      WHEN OTHERS      => usb_pid := x;
    END CASE;

    RETURN(usb_pid);

  END;

--------------------------------------------------------------------------------
--
-- Function: usb_state_of
--
-- Parameters: dplus dminus -- USB differential signal lines
--
-- Description: This function will return the line state as a function of the
-- USB signal line states and the lsdev constant
--
--------------------------------------------------------------------------------

  FUNCTION usb_state_of(dplus : std_logic; dminus : std_logic) RETURN usb_logic IS
    VARIABLE usb_state : usb_logic;
  BEGIN
    IF lsdev = 1 THEN
      IF    ((to_x01(dplus) = '1') AND (to_x01(dminus) = '0')) THEN
        usb_state := K;
      ELSIF ((to_x01(dplus) = '0') AND (to_x01(dminus) = '1')) THEN
        usb_state := J;
      ELSIF ((to_x01(dplus) = '0') AND (to_x01(dminus) = '0')) THEN
        usb_state := SE0;
      ELSE
        usb_state := X;
      END IF;
    ELSE
      IF    ((to_x01(dplus) = '1') AND (to_x01(dminus) = '0')) THEN
        usb_state := J;
      ELSIF ((to_x01(dplus) = '0') AND (to_x01(dminus) = '1')) THEN
        usb_state := K;
      ELSIF ((to_x01(dplus) = '0') AND (to_x01(dminus) = '0')) THEN
        usb_state := SE0;
      ELSE
        usb_state := X;
      END IF;
    END IF;

    RETURN(usb_state);

  END;


BEGIN	----------------------------------------------------------------


J1: usbconna PORT MAP (		-----------USB connectors-----------
	pin1 => usb_pwr_no_connect,-- single point net
        pin2 => dminus_no_connect,
        pin3 => dplus_no_connect,
        pin4 => gnd,
	contact1 => usb_A_J1_cpwr,
        contact2 => usb_A_J1_dminus,
        contact3 => usb_A_J1_dplus,
        contact4 => usb_A_J1_cgnd
        );

-- Drive power signals
gnd <= '0';
vcc3 <= '1';

usboe_n <= '1'; -- USB ouput enable

-- This code will drive the DPLL clock at the 96Mhz (10ns period)
--usbclkx8 <= '1' AFTER (5 ns) WHEN usbclkx8 = '0' ELSE
--            '0' AFTER (5 ns);

reset_proc : PROCESS	-- coded in this fashion for easy translation to verilog
	BEGIN
	reset <= '1';
	WAIT FOR 1000 ns;            -- The board reset is modeled in the sw2 on
	reset <= '0';                -- the v8_sbc
	WAIT;
END PROCESS;


--------------------------------------------------------------------------------
--
--     Process: main_test
--
--  Parameters: None
--
-- Description: This process performs the main test functions of the USB
--	Serial Interface Engine (SIE).
--
--------------------------------------------------------------------------------

main_test: PROCESS

VARIABLE seed      : integer; -- Random number generator seed
VARIABLE device_address      : integer := 0; -- maintain the current device
                                             -- address which is changed by set
                                             -- address setup transactions
VARIABLE device_max_pkt      : integer := 16#40#; -- maintain the current device
                                             -- enpoint 0 max packet size which
                                             -- is changed by get_device_desc
VARIABLE wval      : integer;                -- argument for set endpoint control
VARIABLE differential_skew   : time := 0 ns; -- skew between dminus and dplus
                                             -- assertion
VARIABLE eop_time            : time := 166 ns; -- length of the single ended
                                               -- zero pulse used to signal eop
                                               -- by the hc main test process
VARIABLE between_set_address_interval : time := 0 ns;  -- minimum
                                                       -- interval
                                                       -- between 2
                                                       -- set_address calls
VARIABLE force_long_token    : boolean := false; -- force an extra bit in a
                                                 -- token packet.
VARIABLE force_short_token   : boolean := false; -- force a bit to be removed
                                                 -- from a token packet.
VARIABLE force_crc5_error    : boolean := false; -- force a error in token crc
VARIABLE force_crc16_error   : boolean := false; -- force a error in data crc
VARIABLE force_truncate_sync : integer := 0;     -- force a truncated sync on

                                                 -- this many bits form the
                                                 -- start of the sync field
VARIABLE sync_delay_time : time := 1 ns;         -- delay time used
                                                 -- when force a
                                                 -- truncated sync is on
VARIABLE force_single_ended  : boolean := false; -- force a single ended signalling
VARIABLE force_bit_stuff_disable : boolean := false; -- turn off bitstuffing to
                                                     -- force errors.
VARIABLE force_pid_check_error : boolean := false; -- force a pid check field
                                                   -- error
VARIABLE force_non_zero_status : boolean := false; -- force the get device
                                -- descriptor request to generate a non-zero
                                -- length data packet on the transaction status
                                -- phase.
VARIABLE hc_pckt_data : byte_array(0 TO 1025); -- Packet data
VARIABLE hc_rxpkt_data : byte_array(0 TO 1025);-- receive Packet data
VARIABLE hc_rxpkt_length: integer;             -- receive Packet length
VARIABLE hand_shake  : hand_shake_type;        -- status return from data in
                                               -- packet procedure
VARIABLE start_time  : time := 0 ns;           -- variable for running watchdog
                                               -- timer
VARIABLE eop_end_time: time := 0 ns;           -- variable for testing bus turn
                                               -- turn around time.
                                               -- timer
VARIABLE status_rg : std_logic_vector(7 DOWNTO 0); -- local copy of the status
                                                   -- register read from the
                                                   -- diagnostic driver.
VARIABLE temp_string1 : string(1 TO 256);
VARIABLE temp_string2 : string(1 TO 256);
VARIABLE string_len  : integer := 0 ;
VARIABLE index0,index1,index2 : integer := 0;  -- loop counters

VARIABLE temp_byte   : std_logic_vector(7 DOWNTO 0); -- Chapter 11 test variables
VARIABLE feature_sel : integer;
VARIABLE read_only   : boolean;
VARIABLE test_number : integer := 0;
VARIABLE change_seen : boolean;
VARIABLE frame_test  : integer;

--------------------------------------------------------------------------------
-- Note: Normally functions and procedures would be declared in a separate
-- package file, but because Verilog uses call value parameter passing in tasks
-- procedures that manipulate signals via the call by reference mechanism in
-- VHDL do not translate.  As a result all the functions and procedures are
-- declared locally to the process so that the signals used may be manipulated
-- as globals in both VHDL an Verilog.  To locate the start of execution for
-- this process, search for the string : Start of Process execution.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- Function : crc5
--
-- Parameters: din      -- 11-bit intput data
--             force_crc5_error -- force an error in the result
--             RETURNs  -- CRC5 field for data field
--
-- Description: This function will generate the crc5 field for USB packets that
-- require it.
--
--
--------------------------------------------------------------------------------

FUNCTION crc5 (CONSTANT din : std_logic_vector(11 DOWNTO 0);
               CONSTANT length : integer;
               CONSTANT force_crc5_error : boolean
  ) RETURN std_logic_vector IS

  VARIABLE crc_next, crc_out : std_logic_vector(4 DOWNTO 0);
  VARIABLE crc5_i        : integer;

BEGIN

  crc_next := "11111";

  bits : FOR crc5_i IN 0 TO length-1 LOOP -- loop for the width of the parallel CRC

        -- The polynomial computed is:
        -- G(x)=X**5+X**2+1
	-- compute the crc_next one bit at a time LSB first
    crc_out :=
	 crc_next(3) &                                  -- bit 4
	 crc_next(2) &                                  -- bit 3
	(crc_next(1) XOR crc_next(4) XOR din(crc5_i)) &	-- bit 2
	 crc_next(0) &                                  -- bit 1
	(                crc_next(4) XOR din(crc5_i));	-- bit 0

    crc_next := crc_out;

  END LOOP bits;
  crc_out := NOT crc_out;

  IF force_crc5_error THEN
    crc_out(4) := NOT crc_out(4);
  END IF;

  RETURN(crc_out);

END crc5;

--------------------------------------------------------------------------------
--
-- Function : parallel_crc_16
--
-- Parameters: crc_in   -- running crc register input
--             din      -- input data word
--             RETURNs  -- running CRC register output
--
-- Description: This function will generate the next value of the crc16
-- register given the current register value and a incoming data byte.
--
--------------------------------------------------------------------------------

FUNCTION parallel_crc_16 (crc_in : std_logic_vector(15 DOWNTO 0);
                       din : std_logic_vector(7 DOWNTO 0)
 	              ) RETURN std_logic_vector IS

  VARIABLE crc_next, crc_out : std_logic_vector(15 DOWNTO 0);
  VARIABLE crc16_i        : integer;

BEGIN

  crc_next := crc_in;

  bits : FOR crc16_i IN 0 TO 7 LOOP -- loop for the width of the parallel CRC

        -- The polynomial computed is:
        -- G(x)=X**16+X**15+X**2+1
	-- compute the crc_next one bit at a time LSB first
    crc_out :=
	(crc_next(14) XOR crc_next(15) XOR din(crc16_i)) &	-- bit 15
	 crc_next(13) &                                 -- bit 14
	 crc_next(12) &                                 -- bit 13
	 crc_next(11) &                                 -- bit 12
	 crc_next(10) &                                 -- bit 11
	 crc_next(9)  &                                 -- bit 10
	 crc_next(8)  &                                 -- bit 9
	 crc_next(7)  &                                 -- bit 8
	 crc_next(6)  &                                 -- bit 7
	 crc_next(5)  &                                 -- bit 6
	 crc_next(4)  &                                 -- bit 5
	 crc_next(3)  &                                 -- bit 4
	 crc_next(2)  &                                 -- bit 3
	(crc_next(1)  XOR crc_next(15) XOR din(crc16_i)) &	-- bit 2
	 crc_next(0)  &                                 -- bit 1
	(                 crc_next(15) XOR din(crc16_i));	-- bit 0

    crc_next := crc_out;

  END LOOP bits;

  RETURN(crc_out);

END parallel_crc_16;

--------------------------------------------------------------------------------
--
-- Procedure: j_state
--
-- Parameters:
--             dplus    -- USB data+
--             dminus   -- USB data-
--
-- Description: This procedure will transmit a USB J state signal based on the
-- value of the constant lsdev.
--
--
--------------------------------------------------------------------------------

PROCEDURE j_state
  IS
  BEGIN
    IF lsdev = 1 THEN
      dplus  <= '0' AFTER 1 ns;	-- low speed
      dminus <= '1' AFTER 1 ns;
    ELSE
      dplus  <= '1' AFTER 1 ns; -- high speed
      dminus <= '0' AFTER 1 ns;
    END IF;
  END j_state;

--------------------------------------------------------------------------------
--
-- Procedure: k_state
--
-- Parameters:
--             dplus    -- USB data+
--             dminus   -- USB data-
--
-- Description: This procedure will transmit a USB K state signal based on the
-- value of the constant lsdev.
--
--
--------------------------------------------------------------------------------

PROCEDURE k_state
  IS
  BEGIN
    IF lsdev = 1 THEN
      dplus  <= '1' AFTER 1 ns;	-- low speed
      dminus <= '0' AFTER 1 ns;
    ELSE
      dplus  <= '0' AFTER 1 ns;	-- high speed
      dminus <= '1' AFTER 1 ns;
    END IF;
  END k_state;

--------------------------------------------------------------------------------
--
-- Procedure: nrz_out
--
-- Parameters:
--             data       -- data bit to sent
--             last_dplus -- history of last dplus value
--             dplus      -- USB data+
--             dminus     -- USB data-
--
-- Description: NRZ (NonReturn to Zero) encodes the data and outputs it on the
-- dplus and dminus lines.
--
--
--------------------------------------------------------------------------------

PROCEDURE nrz_out(
  CONSTANT data         : IN    std_logic        -- data bit to send
  ) IS
  BEGIN
    IF data = '0' THEN
      dplus   <= NOT To_X01(dplus) AFTER (1 ns + differential_skew);
      IF force_single_ended THEN
        dminus  <= NOT To_X01(dplus) AFTER (1 ns);
      ELSE
        dminus  <=     To_X01(dplus) AFTER 1 ns;
      END IF;
    END IF;
  END nrz_out;

--------------------------------------------------------------------------------
--
-- Procedure: bit_stuff
--
-- Parameters:
--             data         -- data bit to sent
--             data_histroy -- history of last 6 data values
--             dplus        -- USB data+
--             dminus       -- USB data-
--             force_bit_stuff_disable
--
-- Description: NRZ (NonReturn to Zero) encodes the data and outputs it on the
-- dplus and dminus lines.
--
--
--------------------------------------------------------------------------------

PROCEDURE  bit_stuff(
  CONSTANT data         : IN    std_logic;        -- data bit to sent
  VARIABLE data_history : INOUT std_logic_vector(5 DOWNTO 0)  -- history of
                                                              -- last 6 bits
  ) IS
  BEGIN
    nrz_out (data);
    data_history := data_history(4 DOWNTO 0) & data;-- update the history
    IF (data_history = "111111"  AND
       NOT force_bit_stuff_disable) THEN            -- do we need to stuff a zero
      WAIT UNTIL usb_clk'event AND usb_clk = '1';   -- Wait for rising edge
--      ASSERT false REPORT "adding stuff bit" SEVERITY NOTE;

      nrz_out('0');                   -- stuff a zero
      data_history := data_history(4 DOWNTO 0) & '0';-- update the history
    END IF;
  END bit_stuff;

--------------------------------------------------------------------------------
--
-- Procedure: send_eop
--
-- Parameters:
--             eop_time     -- length of eop pulse
--             hc_state     -- host controller state variable
--             dplus        -- USB data+
--             dminus       -- USB data-
--
-- Description: Constructs a EOP signalling of length eop_time on the usb bus
-- dplus and dminus lines.
--
--
--------------------------------------------------------------------------------

PROCEDURE  send_eop
    IS
  BEGIN
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_eop;                         -- Set host controller state
    dplus  <= '0' AFTER 1 ns;
    dminus <= '0' AFTER 1 ns;
    WAIT FOR eop_time;
    if lsdev = 1 then
      dminus <= '1' AFTER 1 ns;
    else
      dplus <= '1' AFTER 1 ns;
    end if;
    eop_end_time := now;
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= hc_idle;             -- Set host controller state
    dplus  <= 'Z' AFTER 1 ns;                   -- Release Data+
    dminus <= 'Z' AFTER 1 ns;                   -- Release Data-
  END send_eop;

--------------------------------------------------------------------------------
--
-- Procedure: send_sync
--
-- Parameters:
--             hc_state     -- host controller state variable
--             data_histroy -- history of last 6 data values
--             force_truncate_sync -- shorten the sync pulse
--             dplus        -- USB data+
--             dminus       -- USB data-
--
-- Description: Constructs and send a  Sync field on dplus and dminus lines.
--
--
--------------------------------------------------------------------------------

PROCEDURE  send_sync(
  VARIABLE data_history : INOUT std_logic_vector(5 DOWNTO 0) -- history of
                                                              -- last 6 bits
  ) IS

  VARIABLE temp : std_logic_vector(7 DOWNTO 0);
  VARIABLE sync_i    : integer;               -- loop index

  BEGIN
  data_history := "000000";
  temp(7 DOWNTO 0) := "10000000"; -- Set to sync
  sync_i := force_truncate_sync;             --  start the sync field late by the
                                         --  number of bits directed by
                                         --  force_truncate_sync.

  IF force_truncate_sync /= 0 THEN       -- truncated the transmition of the first
                                         -- sync bit that is sent
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    WAIT FOR (sync_delay_time);          -- send the first sync bit
                                         -- after delay
    hc_state <= tx_sync; -- Set host controller state
    bit_stuff(temp(force_truncate_sync -1), data_history);
  END IF;

  WHILE (sync_i < 8) LOOP -- Tx sync
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_sync; -- Set host controller state
    bit_stuff(temp(sync_i), data_history);
    sync_i := sync_i + 1;
  END LOOP;

  END send_sync;

--------------------------------------------------------------------------------
--
-- Procedure: bit_unstuff
--
-- Parameters: usb_clk      -- usb bit clock
--             data         -- data bit to recieved
--             data_histroy -- history of last 6 data values
--             dplus        -- USB data+
--             dminus       -- USB data-
--
-- Description: recieves one data bit and removes bit stuff bits.
--
--
--------------------------------------------------------------------------------

PROCEDURE  bit_unstuff(
  VARIABLE data         : OUT   std_logic;        -- data bit to sent
  VARIABLE data_history : INOUT std_logic_vector(5 DOWNTO 0) -- history of
                                                              -- last 6 bits
  ) IS
  VARIABLE new_state   : usb_logic;
  VARIABLE last_state  : usb_logic;
  VARIABLE new_bit     : std_logic;

  BEGIN
    last_state  := usb_state_of(dplus,dminus);        -- Save last usb state
    WAIT UNTIL usb_clk'event AND usb_clk = '1';       -- Wait for rising edge
    new_state   := usb_state_of(dplus,dminus);        -- Get new usb state
    -- get the new bit value
    IF    (last_state = J AND new_state = K) OR
          (last_state = K AND new_state = J) THEN
      new_bit := '0';
    ELSIF (last_state = J AND new_state = J) OR
          (last_state = K AND new_state = K) THEN
      new_bit := '1';
    ELSE
      new_bit := 'X';
    END IF;

    data_history := data_history(4 DOWNTO 0) & new_bit;-- update the history
    data := new_bit;                                   -- pass back the data bit
    -- check to see if the next bit should be a bit stuff.
    IF data_history = "111111" THEN
--      ASSERT false REPORT "removing stuff bit" SEVERITY NOTE;
      last_state  := usb_state_of(dplus,dminus); -- Save last usb state
      WAIT UNTIL usb_clk'event AND usb_clk = '1';-- Wait for rising edge
      new_state   := usb_state_of(dplus,dminus); -- Get new usb state
                                                 -- get the new bit value
      IF    (last_state = J AND new_state = K) OR
        (last_state = K AND new_state = J) THEN
        new_bit := '0';
      ELSIF (last_state = J AND new_state = J) OR
        (last_state = K AND new_state = K) THEN
        new_bit := '1';
      ELSE
        new_bit := 'X';
      END IF;

      ASSERT new_bit = '0'
        REPORT "Recieve bit stuff error expected 0 stuff"
        SEVERITY FAILURE;
      data_history := "111110";
    END IF;

  END bit_unstuff;

--------------------------------------------------------------------------------
--
-- Procedure: usb_reset
--
-- Parameters: duration       -- Duration of the reset signal
--
-- Globals:    usb_clk        -- USB clock
--             dplus          -- USB data+
--             dminus         -- USB data-
--             hc_state       -- USB Host Controller state
--             device_address -- Current USB target address
--
-- Description: This procedure will transmit a USB reset signal (dplus and
-- dminus Single Ended zero (SE0)) of a specified duration. The device_address
-- global variable is set to address 0.
--
--------------------------------------------------------------------------------

PROCEDURE usb_reset(
  CONSTANT duration : IN    time         -- reset pulse width
  ) IS

  BEGIN
    -- asert the reset signal and go into the reset state
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= hc_reset;
    dplus  <= '0' AFTER 1 ns;    -- set both signals to SE0
    dminus <= '0' AFTER 1 ns;
    WAIT FOR duration;           -- wait for the requested reset duration

    -- deastert the reset signal and return to the idle state
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    IF lsdev = 1 THEN
      dplus  <= '0' AFTER 1 ns; -- return the signals to
      dminus <= '1' AFTER 1 ns; -- differential signalling
    ELSE
      dplus  <= '1' AFTER 1 ns; -- return the signals to
      dminus <= '0' AFTER 1 ns; -- differential signalling
    END IF;

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= hc_idle;            -- Set host controller state
    dplus  <= 'Z' AFTER 1 ns;                   -- Release Data+
    dminus <= 'Z' AFTER 1 ns;                   -- Release Data-

    -- reset the device address variable to track the state of the SIE
    device_address := 0;

END usb_reset;

--------------------------------------------------------------------------------
--
-- Procedure: usb_resume
--
-- Parameters: duration -- Duration of the resume signal
--
-- Globals:    usb_clk  -- USB clock
--             dplus    -- USB data+
--             dminus   -- USB data-
--             hc_state -- USB Host Controller state
--
-- Description: This procedure will transmit a USB resume signal (dplus and
-- dminus K state followed by a low speed EOP) of a specified duration.
--
--------------------------------------------------------------------------------

PROCEDURE usb_resume(
  CONSTANT duration : IN    time          -- reset pulse width
  ) IS

  BEGIN
    -- asert the resume (k-state) signal and go into the hc_resume state
    hc_state <= hc_resume;
    k_state ;                          -- assert a k-state on the bus
    WAIT FOR duration;                 -- wait for the requested resume duration

    -- Tx a ***LOW SPEED*** EOP
    WAIT UNTIL usb_clk'event AND usb_clk = '1';-- Wait for rising edge
    hc_state <= tx_eop;                        -- Set host controller state
    dplus  <= '0' AFTER 1 ns;
    dminus <= '0' AFTER 1 ns;
    WAIT FOR 1300 ns;                           -- half a clock less than 2 bit
                                                -- times
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    dplus <= '1' AFTER 1 ns;
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= hc_idle;             -- Set host controller state
    dplus  <= 'Z' AFTER 1 ns;                   -- Release Data+
    dminus <= 'Z' AFTER 1 ns;                   -- Release Data-

END usb_resume;



--------------------------------------------------------------------------------
--
-- Procedure: token_packet
--
-- Parameters: pid      -- PID
--             addr     -- USB destination address
--             endpt    -- USB destination end point
--
-- Globals:    usb_clk  -- USB clock
--             dplus    -- USB data+
--             dminus   -- USB data-
--             hc_state -- USB Host Controller state
--             dtoggle  -- Data toggle synchronization signal
--
-- Description: This procedure will transmit a USB token packet. The token type
-- is specified by the pid parameter. Target address, and endpoint are from the
-- addr and endpt parameters. The data toggle variable is also initialized to
-- DATA0.
--
-- Packet Format: See USB Spec 1.0 Section 8.4.1 for more information.
--
--   8-Bits   8-Bits   7-Bits   4-Bits   5-Bits   3-Bits
-- +--------+--------+--------+--------+--------+--------+
-- |  SYNC  |   PID  |  ADDR  |  ENDP  |  CRC5  |   EOP  |
-- +--------+--------+--------+--------+--------+--------+
--
--------------------------------------------------------------------------------

PROCEDURE token_packet (
  CONSTANT pid      : IN    integer;      -- PID
  CONSTANT addr     : IN    integer;      -- USB destination address
  CONSTANT endpt    : IN    integer       -- USB destination end point
  ) IS

VARIABLE bus_idle : boolean;             -- indication that the bus is idle
VARIABLE temp : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE temp2 : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing
VARIABLE tokp_i                    : integer;  -- count variable
VARIABLE endpt_len, token_len : integer;  -- length for forcing long or short
                                          -- tokens for robustness testing.
BEGIN
  -- Wait for SOF if one is approaching
    IF sof_hold_off = '1' THEN
      WAIT UNTIL sof_hold_off = '0';
    END IF;
  -- Make sure the bus is idle by checking for 16 consecutive J states.
    tokp_i := 0;
    WHILE (tokp_i < 16) LOOP -- Tx sync
      WAIT UNTIL usb_clk'event AND usb_clk = '1';-- Wait for rising edge
      IF usb_state_of(dplus,dminus) /= J THEN
        tokp_i := 0;
      ELSE
        tokp_i := tokp_i + 1;
      END IF;
    END LOOP;

  send_sync(data_history); -- Send sync field

  IF pid = SETUP_PID THEN
--    dtoggle <=  '0'; -- initialize the data toggle syncronization
    dtoggle_out <=  '0'; -- initialize the data toggle syncronization
    dtoggle_in <= '1';
  END IF;


  temp := CONV_STD_LOGIC_VECTOR(pid,32); -- Convert integer pid to std_logic_vector
  usb_pid <= to_pid_type(pid);
  IF force_pid_check_error THEN
    temp(7 DOWNTO 4) := temp(3) & NOT temp(2 DOWNTO 0); -- Invert PID bits with
  ELSE                                                  -- error
    temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  END IF;
  FOR tokp_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(tokp_i), data_history);
  END LOOP;

  temp := CONV_STD_LOGIC_VECTOR(addr,32); -- Convert integer addr to
                                          -- std_logic_vector
  temp2(6 DOWNTO 0) := temp(6 DOWNTO 0);  -- save the bits for CRC5 calc
  FOR tokp_i IN 0 TO 6 LOOP -- Tx addr
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_addr; -- Set host controller state
    bit_stuff(temp(tokp_i), data_history);
  END LOOP;

  -- these lines add or subtract bits from the packet length to support
  -- robustness testing.
  IF force_short_token THEN
    endpt_len := 3;                      -- shorten the endpoint field
    token_len := 10;                     -- shorten the crc5 data too.
  ELSIF force_long_token THEN
    endpt_len := 5;                      -- lengthen the endpoint field
    token_len := 12;                     -- and the crc5 data too.
  ELSE
    endpt_len := 4;                      -- this is normal operation
    token_len := 11;
  END IF;

  temp := CONV_STD_LOGIC_VECTOR(endpt,32); -- Convert integer end point to
                                           -- std_logic_vector
  temp2(11 DOWNTO 7) := temp(4 DOWNTO 0);  -- save the bits for CRC5 calc

  FOR tokp_i IN 0 TO (endpt_len-1) LOOP -- Tx end point
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_endp; -- Set host controller state
    bit_stuff(temp(tokp_i), data_history);
  END LOOP;

  -- get the crc5 of the addr and endpt fields that were saved in temp2
  temp(4 DOWNTO 0) := crc5(temp2(11 DOWNTO 0), token_len, force_crc5_error); -- Set CRC5
  FOR tokp_i IN 4 DOWNTO 0 LOOP -- Tx CRC5
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_crc5; -- Set host controller state
    bit_stuff(temp(tokp_i), data_history);
  END LOOP;

  -- Tx EOP
  send_eop;

END token_packet;

--------------------------------------------------------------------------------
--
-- Procedure: sof_token_packet
--
-- Parameters: frm_num  -- Frame number
--             usb_clk  -- USB clock
--             dplus    -- USB data+
--             dminus   -- USB data-
--             hc_state -- USB Host Controller state
--
-- Description: This procedure will transmit a USB SOF packet.
--
-- Packet Format:
--
--   8-Bits   8-Bits   11-Bits   5-Bits   3-Bits
-- +--------+--------+---------+--------+--------+
-- |  SYNC  |   PID  | Frame # |  CRC5  |   EOP  |
-- +--------+--------+---------+--------+--------+
--
--------------------------------------------------------------------------------

PROCEDURE sof_token_packet (
  VARIABLE frm_num  : INOUT integer      -- Frame number
  ) IS

VARIABLE temp : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing
VARIABLE softp_i : integer;              -- local loop index
BEGIN

  send_sync(data_history); -- Send sync field

  temp(3 DOWNTO 0) := "0101"; -- Set to SOF pid
  temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  usb_pid <= to_pid_type(conv_integer(unsigned(temp(3 DOWNTO 0))));
  FOR softp_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(softp_i), data_history);
  END LOOP;

  temp := CONV_STD_LOGIC_VECTOR(frm_num,32); -- Convert integer frame number to
                                             -- std_logic_vector
  FOR softp_i IN 0 TO 10 LOOP -- Tx frame number
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_fnum; -- Set host controller state
    bit_stuff(temp(softp_i), data_history);
  END LOOP;

  temp := CONV_STD_LOGIC_VECTOR(frm_num,32);
  temp(4 DOWNTO 0) := crc5(temp(11 DOWNTO 0),11, force_crc5_error); -- Set CRC5
  FOR softp_i IN 4 DOWNTO 0 LOOP -- Tx CRC5 (MSB first)
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_crc5; -- Set host controller state
    bit_stuff(temp(softp_i), data_history);
  END LOOP;

  -- Tx EOP
  send_eop;

  frm_num := frm_num + 1;                -- increment the frame number

END sof_token_packet;

--------------------------------------------------------------------------------
--
-- Procedure: build_hc_packet
--
-- Parameters: byte_cnt      -- Byte count
--             strt_data     -- Starting data value
--             data_pat      -- Test data pattern
--             seed          -- Random number generator seed
--
-- Globals:    hc_pckt_data  -- Packet data
--
-- Description: This procedure will build a data packet in the global
-- hc_pckt_data array. This array will hold each byte of information that
-- will	be transmitted, or will be received. This data is used by the
-- data_in_packet and data_out_packet as compare or transmit data
-- respectively.
--
--------------------------------------------------------------------------------

PROCEDURE build_hc_packet (
  CONSTANT byte_cnt  : IN    integer;       -- Byte Count
  CONSTANT strt_data : IN    integer;       -- Starting data value
  CONSTANT data_pat  : IN    data_patterns; -- Test data pattern
  VARIABLE seed      : INOUT integer        -- Random number generator seed
  ) IS

VARIABLE data  : integer; -- Data variable
VARIABLE index : integer; -- Packet data index
VARIABLE temp  : std_logic_vector(31 DOWNTO 0); -- Temp data
VARIABLE local_byte_cnt : integer; -- Local byte count

BEGIN

  -- Copy constants to local variables
  local_byte_cnt  := byte_cnt; -- Copy to local byte count
  data := strt_data; -- Copy start data value to data
  index := 0; -- Init index
  -- Init frame data, set 9th bit
  --hc_pckt_data(index) := '1' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';

  WHILE (local_byte_cnt >= 0) LOOP

    temp := CONV_STD_LOGIC_VECTOR(data,32); -- Convert int to std_logic_vector
    --frame_data(index) := '0' & temp(7 downto 0);
    hc_pckt_data(index) := temp(7 DOWNTO 0);

    local_byte_cnt := local_byte_cnt - 1; -- Dec byte count
    index := index + 1; -- Inc index

    IF data_pat = INC THEN
      data := data + 1; -- Inc data value
    ELSIF data_pat = DEC THEN
      data := data - 1; -- Dec data value
    ELSE
      seed := rand(seed); -- Create random data
      data := seed; -- Copy to data
    END IF;

  END LOOP; -- End while loop

  -- Terminate frame data, set 9th bit
  --hc_pckt_data(index) := '1' & temp(7 downto 0);
  --hc_pckt_data(index) := '1' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0';

END build_hc_packet;

--------------------------------------------------------------------------------
--
-- Procedure : data_in_packet
--
-- Parameters: exp_pid       -- Expected PID
--             byte_cnt      -- Byte Count
--             offset        -- Offset into packet data
--             hand_shake    -- Handshake type NAK, STALL or DATA
--             data_check    -- Enables data checking
--
-- Globals:    usb_clk       -- USB clock
--             dplus         -- USB data+
--             dminus        -- USB data-
--             hc_state      -- USB Host Controller state
--             hc_pckt_data  -- Expected packet data
--
-- Description: This procedure will receive a complete data packet. The
-- received PID is compared with the expected PID. Each byte of the
-- data field can be compared with the expected packet data (hc_pckt_data).
-- The data comparsion is enabled when data_checking is equal to check or
-- iso_check. Data checking can also be disabled on a byte by byte basis by
-- setting hc_pckt_data to X_es. The offset in to the hc_pckt_data can be
-- passed in to the data_in_packet procedure. This allows the data_in_packet
-- to be called repeatedly by higher level routines and compute the correct
-- index in the expected receive data. Data length checking is performed by
-- comparing the byte_cnt parameter with the actual number of bytes received.
-- Receive length checking is also enabled with the data_checking parameter.
-- If called with data_check equal to iso_check it will allow 0 length ISO
-- packets to be received error free. The CRC16 is computed and checked with
-- 800B\h. If any of these comparisons fail an error message is displayed.
-- Bus turn around times are also checked to be within USB specification.
--
-- Packet Format: See USB Spec 1.0 Section 8.4.3 for more information.
--
--   8-Bits   8-Bits   0-1023 Bytes   16-Bits   3-Bits
-- +--------+--------+--------------+---------+--------+
-- |  SYNC  |   PID  |     DATA     |  CRC16  |   EOP  |
-- +--------+--------+--------------+---------+--------+
--
--------------------------------------------------------------------------------

PROCEDURE data_in_packet (
  CONSTANT exp_pid    : IN    integer;         -- Expected PID
  CONSTANT byte_cnt   : IN    integer;         -- Byte Count
  CONSTANT offset     : IN    integer;         -- Offset into packet data
  VARIABLE hand_shake : OUT   hand_shake_type; -- NAK, STALL, DATA or BTO
  CONSTANT data_checking : IN  checking_type   -- check, no_check, iso_check, iso_no_check
  )  IS

VARIABLE start_time : time;              -- bus time out start time
VARIABLE turnaround_time : time;         -- measured bus turnaround time
VARIABLE time_out        : time;         -- bus turnaround timeout
VARIABLE datip_i    : integer;                 -- Loop variable
VARIABLE index : integer;                -- Packet data index
VARIABLE local_byte_cnt : integer;       -- Local byte count
VARIABLE temp    : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE exp_temp: std_logic_vector(31 DOWNTO 0); -- Return PID
VARIABLE crc_register  : std_logic_vector(15 DOWNTO 0);-- expected CRC
VARIABLE crc_exp       : std_logic_vector(15 DOWNTO 0);-- expected CRC
VARIABLE crc_temp      : std_logic_vector(7 DOWNTO 0);-- temp vector for CRC
VARIABLE data_history: std_logic_vector (5 DOWNTO 0);
VARIABLE current_state  : usb_logic;     -- Current USB bus state

BEGIN

  clock_master_save <= clock_master;     -- save the current clock source so it
                                         -- can be restored.
  clock_master <= target;                -- listen using the targets clock.

  data_history := "000000";
  hand_shake   :=  data_hs;

  local_byte_cnt := 0; -- Init local byte count
  index := 0; -- Init index
  datip_i := 0;
  start_time := now;
  hc_state <= rx_wait; -- Set host controller state

  -- Initialize the bus timeout signal
  usb_bto <= '0';
  usb_bto <= TRANSPORT '1' AFTER bus_timeout;

  -- Detect transition out of idle
  WAIT UNTIL ((usb_kstate'event AND usb_kstate = '1') OR  -- start sync
              (usb_bto'event AND usb_bto = '1'));         -- bus timeout

  turnaround_time := now - eop_end_time;

  IF usb_bto = '0' THEN                  -- Check whether a bus timeout has
                                         -- occured. If not process the packet.


    ASSERT (turnaround_time > usb_bit_time * 2) REPORT
      "target violated minmum bus turnaround time"
      SEVERITY FAILURE;
    ASSERT (turnaround_time < usb_bit_time * 6.5) REPORT
      "target violated maximum bus turnaround time"
      SEVERITY FAILURE;

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    IF usb_state_of(dplus,dminus) = K THEN
      temp(datip_i) := '0';
      datip_i := 1; -- Break loop
    END IF;

    WHILE (datip_i < 8) LOOP                   -- Rx sync
      hc_state <= rx_sync;               -- Set host controller state
      bit_unstuff(temp(datip_i), data_history);
      datip_i :=  datip_i + 1;                       -- Inc loop count
    END LOOP;

    exp_temp(7 DOWNTO 0) := "10000000";
    test_value <= conv_integer(unsigned(temp(7 DOWNTO 0)));
    exp_value  <= conv_integer(unsigned(exp_temp(7 DOWNTO 0)));
    ASSERT (temp(7 DOWNTO 0) = "10000000")
      REPORT "SYNC field corrupt"
      SEVERITY FAILURE;

    datip_i := 0;
    WHILE (datip_i < 8) LOOP                   -- Rx pid
      hc_state <= rx_pid;                -- Set host controller state
      bit_unstuff(temp(datip_i), data_history);
      datip_i :=  datip_i + 1;                       -- Inc loop count
    END LOOP;

    test_value <= conv_integer(unsigned(NOT temp(7 DOWNTO 4)));
    exp_value  <= conv_integer(unsigned(temp(3 DOWNTO 0)));
    usb_pid <= to_pid_type(conv_integer(unsigned(temp(3 DOWNTO 0))));
    ASSERT (NOT(temp(7 DOWNTO 4)) = temp(3 DOWNTO 0))
      REPORT "Received PID check field failure."
      SEVERITY FAILURE;

    test_value <= conv_integer(unsigned(temp(3 DOWNTO 0)));
    exp_value  <= exp_pid;
    -- Check if a ack or stall was sent instead of the return data.
    exp_temp := CONV_STD_LOGIC_VECTOR(NAK_PID,32);-- Convert integer NAK
                                                  -- PID to std_logic_vector
    IF (temp(3 DOWNTO 0) = exp_temp(3 DOWNTO 0)) THEN-- if its an ack
      hand_shake :=  nak_hs;
      ASSERT NOT verbose
        REPORT "Recieved a NAK when expecting an in data packet"
        SEVERITY NOTE;
    ELSE
      exp_temp := CONV_STD_LOGIC_VECTOR(STALL_PID,32); -- Convert integer STALL
                                                       -- PID to
                                                       -- std_logic_vector
      IF (temp(3 DOWNTO 0) = exp_temp(3 DOWNTO 0)) THEN
        hand_shake :=  stall_hs;
        ASSERT (temp(3 DOWNTO 0) = exp_temp(3 DOWNTO 0))
          REPORT "Data input PID was STALL -- HC Panic."
          SEVERITY FAILURE;
                                         -- We don't know how to respond to
                                         -- this so we will halt.

      ELSE                               -- it should be a our data packet

        IF exp_pid = DATAX_PID THEN
          exp_temp(3 DOWNTO 0) := dtoggle_in & "011";   -- set the expected pid to data 0 or 1
        ELSE
          exp_temp := CONV_STD_LOGIC_VECTOR(exp_pid,32); -- Convert integer
                                                         -- expected PID to
                                                         -- std_logic_vector
        END IF;

        ASSERT (temp(3 DOWNTO 0) = exp_temp(3 DOWNTO 0))
          REPORT "Received PID does not equal expected PID"
          SEVERITY FAILURE;


        -- Get current USB bus state for first time through while Rx data byte loop
        current_state := usb_state_of(dplus,dminus);

        -- Receive data while current_state is not SE0
        WHILE (current_state /= SE0) LOOP

          datip_i := 0;
          -- Loop while datip_i < 8 and not a SE0
          WHILE ((datip_i < 8) AND (current_state /= SE0)) LOOP -- Rx data byte
            hc_state <= rx_data;         -- Set host controller state
            bit_unstuff(temp(datip_i), data_history);-- get a

            current_state := usb_state_of(dplus,dminus); -- Get current USB bus state
            datip_i :=  datip_i + 1;                 -- Inc loop count
          END LOOP;

          IF (current_state /= SE0) THEN
            hc_rxpkt_data(index+offset) := temp(7 DOWNTO 0);
            test_value <= conv_integer(unsigned(temp(7 DOWNTO 0)));
            exp_value  <= conv_integer(unsigned(hc_pckt_data(index+offset)));

            IF (index > 1) THEN
              ASSERT ((hc_rxpkt_data(local_byte_cnt+offset) =
                       hc_pckt_data(local_byte_cnt+offset)) OR
                      (hc_pckt_data(local_byte_cnt+offset) = "XXXXXXXX") OR
                      (data_checking = no_check) OR
                      (data_checking = iso_no_check))
                REPORT "Received Data does not equal expected data"
                SEVERITY FAILURE;

              local_byte_cnt := local_byte_cnt + 1; -- Inc byte count
            END IF;

            index := index + 1;                   -- Inc packet data index

          END IF;

        END LOOP;                        -- End while loop

        -- Copy last two bytes received to temp high order word
        -- so we can bit swap it to low order word
        temp(31 DOWNTO 16) := hc_rxpkt_data(index+offset-1) &
                              hc_rxpkt_data(index+offset-2);
        -- Must swap bit order because crc16 is MSB first
        datip_i := 0;
        FOR datip_i IN 0 TO 15 LOOP
          temp(datip_i) := temp(31-datip_i); -- Perform bit swap on high and low words
        END LOOP;


           crc_register := "11111111" & "11111111";        --------Compute CRC
           IF (local_byte_cnt /=0) THEN
             FOR datip_i IN offset TO offset+local_byte_cnt-1 LOOP
              crc_temp := hc_rxpkt_data(datip_i);
              crc_register := parallel_crc_16(crc_register, crc_temp);
            END LOOP;
          END IF;
          crc_exp := NOT crc_register;

          test_value <= conv_integer(unsigned(temp(15 DOWNTO 0)));
          exp_value  <= conv_integer(unsigned(crc_exp));

          ASSERT (temp(15 DOWNTO 0) = crc_exp)
            REPORT "Received CRC does not equal calculated CRC"
            SEVERITY FAILURE;

        -- Will check for a packet length violation if local_byte_cnt does not
        -- equal byte_cnt when data_checking is equal to check. When data_checking
        -- is equal to iso_check we will allow zero length packets.
        ASSERT NOT ((local_byte_cnt /= byte_cnt AND data_checking = check) OR
                    (local_byte_cnt /= byte_cnt AND local_byte_cnt /= 0 AND
                     data_checking = iso_check))
          REPORT "Unexpected EOP, packet length mismatch" SEVERITY FAILURE;

      END IF;                            -- end of STALL if then else
    END IF;                              -- end of NAK if then else

    -- If we have already received a SE0 we must use a different index value
    -- for iso we can correctly check EOP width.
    IF (usb_state_of(dplus,dminus) = SE0) THEN
      datip_i := 1;
    ELSE
      datip_i := 0;
    END IF;
    WHILE (datip_i < 3) LOOP                   -- Rx eop
      WAIT UNTIL usb_clk'event AND usb_clk = '1';-- Wait for rising edge
      hc_state <= rx_eop;                        -- Set host controller state
      ASSERT ((datip_i <= 1) AND (usb_state_of(dplus,dminus) = SE0)) OR
        ((datip_i = 2) AND (usb_state_of(dplus,dminus) = J))
        REPORT "EOP corrupt or packet lenght mismatch" SEVERITY FAILURE;
      datip_i :=  datip_i + 1;                       -- Inc loop count
    END LOOP;

  ELSE                                   -- No response was sent prior to the
                                         -- Bus Timeout interval expiring.
    hand_shake :=  bto_hs;
    ASSERT false
      REPORT "Bus time out when expecting a data packet."
      SEVERITY FAILURE;
  END IF;                                -- end of Bus timeout if-then-else

  hc_rxpkt_length := local_byte_cnt;     -- Set receive packet length

  hc_state <= hc_idle;                   -- Set host controller state

  clock_master <= clock_master_save;     -- restore the current clock source

  END data_in_packet;

--------------------------------------------------------------------------------
--
-- Procedure: data_out_packet
--
-- Parameters: pid          -- PID
--             byte_cnt     -- Byte Count
--
-- Globals:    usb_clk      -- USB clock
--             dplus        -- USB data+
--             dminus       -- USB data-
--             hc_state     -- USB Host Controller state
--             hc_pckt_data -- Transmit packet data
--
-- Description: This procedure will transmit a complete data packet. The pid
-- parameter is transmitted during the PID portion of the packet. The number
-- of bytes to be transmitted is passed in via the byte_cnt parameter. Transmit
-- data must be built in the hc_pckt_data array before this procedure is called.
-- Finally the 16-bit CRC is computed based on the hc_pckt_data and transmitted
-- during the CRC portion of data packet.
--
-- Packet Format: See USB Spec 1.0 Section 8.4.3 for more information.
--
--   8-Bits   8-Bits   0-1023 Bytes   16-Bits   3-Bits
-- +--------+--------+--------------+---------+--------+
-- |  SYNC  |   PID  |     DATA     |  CRC16  |   EOP  |
-- +--------+--------+--------------+---------+--------+
--
--------------------------------------------------------------------------------

PROCEDURE data_out_packet (
  CONSTANT pid        : IN    integer;      -- PID
  CONSTANT byte_cnt   : IN    integer       -- Byte Count
  ) IS

VARIABLE index : integer; -- Packet data index
VARIABLE temp  : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE local_byte_cnt : integer; -- Local byte count
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing
VARIABLE crc_out       : std_logic_vector(15 DOWNTO 0);-- expected CRC
VARIABLE crc_register  : std_logic_vector(15 DOWNTO 0);-- expected CRC
VARIABLE crc_temp      : std_logic_vector(7 DOWNTO 0);-- temp vector for CRC
VARIABLE datop_i       : integer;        -- local loop index

BEGIN

  local_byte_cnt := byte_cnt; -- Copy constant to local variable
  index := 0; -- Init index

  send_sync(data_history); -- Send sync field

  IF pid = DATAX_PID THEN
    temp(3 DOWNTO 0) := dtoggle_out & "011";         -- set the expected pid to data 0 or 1
  ELSE
    temp := CONV_STD_LOGIC_VECTOR(pid,32); -- Convert integer pid to
                                           -- std_logic_vector
  END IF;

  temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  usb_pid <= to_pid_type(conv_integer(unsigned(temp(3 DOWNTO 0))));

  FOR datop_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(datop_i), data_history);
  END LOOP;

  -- Transmit data while byte count greater than 0
  WHILE (local_byte_cnt > 0) LOOP
    temp(7 DOWNTO 0) := hc_pckt_data(index); -- Get byte from packet data
    local_byte_cnt := local_byte_cnt - 1; -- Dec byte counter
    index := index + 1; -- Inc index
    FOR datop_i IN 0 TO 7 LOOP -- Tx addr
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      hc_state <= tx_data; -- Set host controller state
      bit_stuff(temp(datop_i), data_history);
    END LOOP; -- End for loop
  END LOOP; -- End while loop

  crc_register := "11111111" & "11111111";	--------Compute CRC
  IF (byte_cnt /=0) THEN
    FOR datop_i IN 0 TO byte_cnt-1 LOOP
      crc_temp := hc_pckt_data(datop_i);
      crc_register := parallel_crc_16(crc_register, crc_temp);
    END LOOP;
  END IF;
  crc_out := NOT crc_register;
  IF force_crc16_error THEN
    crc_out(0) := NOT crc_out(0);
  END IF;			--------end Compute CRC

  FOR datop_i IN 15 DOWNTO 0 LOOP -- Tx CRC16 (MSB first)
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_crc16; -- Set host controller state
    bit_stuff(crc_out(datop_i), data_history);
  END LOOP;

  -- Tx EOP
  send_eop;

END data_out_packet;

--------------------------------------------------------------------------------
--
-- Procedure: handshake_in_packet
--
-- Parameters: exp_pid  -- Expected PID
--
-- Globals:    usb_clk  -- USB clock
--             dplus    -- USB data+
--             dminus   -- USB data-
--             hc_state -- USB Host Controller state
--
-- Description: This procedure will receive a USB handshake packet. This
-- procedure should be used when the behavioral host controller must receive
-- a handshake packet. The received PID is compared with the expected PID. If
-- this comparison fails an error message is displayed. Bus turn around times
-- are also checked to be within USB specification.
--
-- Packet Format: See USB Spec 1.0 Section 8.4.4 for more information.
--
--   8-Bits   8-Bits   3-Bits
-- +--------+--------+--------+
-- |  SYNC  |   PID  |   EOP  |
-- +--------+--------+--------+
--
--------------------------------------------------------------------------------
PROCEDURE handshake_in_packet (
  VARIABLE hand_shake : OUT   hand_shake_type -- ACK, NAK, STALL or BTO
  ) IS

VARIABLE start_time : time;              -- bus time out start time
VARIABLE turnaround_time : time;         -- measured bus turnaround time
VARIABLE time_out        : time;         -- bus turnaround timeout
VARIABLE hskip_i            : integer;         -- Loop variable
VARIABLE temp         : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE exp_temp     : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit
                                         -- history for bit-unstuffing

BEGIN
  data_history  := "000001"; -- initialize history for bit-unstuffing

  clock_master_save <= clock_master;     -- save the current clock source so it
                                         -- can be restored.
  clock_master <= target;                -- listen using the targets clock.


  data_history := "000000";
  hand_shake   :=  nak_hs;

  hskip_i := 0;
  start_time := now;
  hc_state <= rx_wait; -- Set host controller state

  -- Initialize the bus timeout signal
  usb_bto <= '0';
  usb_bto <= TRANSPORT '1' AFTER bus_timeout;

  -- Detect transition out of idle
  WAIT UNTIL ((usb_kstate'event AND usb_kstate = '1') OR  -- start sync
              (usb_bto'event AND usb_bto = '1'));         -- bus timeout

  turnaround_time := now - eop_end_time;

  IF usb_bto = '0' THEN                  -- Check whether a bus timeout has
                                         -- occured. If not process the packet.


    ASSERT (turnaround_time > usb_bit_time * 2) REPORT
      "target violated minmum bus turnaround time"
      SEVERITY FAILURE;
    ASSERT (turnaround_time < usb_bit_time * 6.5) REPORT
      "target violated maximum bus turnaround time"
      SEVERITY FAILURE;

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    IF usb_state_of(dplus,dminus) = K THEN
      temp(hskip_i) := '0';
      hskip_i := 1; -- Break loop
    END IF;


    WHILE (hskip_i < 8) LOOP                   -- Rx sync
      hc_state <= rx_sync;               -- Set host controller state
      bit_unstuff(temp(hskip_i), data_history);
      hskip_i :=  hskip_i + 1;                       -- Inc loop count
    END LOOP;

    exp_temp(7 DOWNTO 0) := "10000000";
    test_value <= conv_integer(unsigned(temp(7 DOWNTO 0)));
    exp_value  <= conv_integer(unsigned(exp_temp(7 DOWNTO 0)));
    ASSERT (temp(7 DOWNTO 0) = "10000000")
      REPORT "SYNC field corrupt"
      SEVERITY FAILURE;

    hskip_i := 0;
    WHILE (hskip_i < 8) LOOP                   -- Rx pid
      hc_state <= rx_pid;                -- Set host controller state
      bit_unstuff(temp(hskip_i), data_history);
      hskip_i :=  hskip_i + 1;                       -- Inc loop count
    END LOOP;

    test_value <= conv_integer(unsigned(NOT temp(7 DOWNTO 4)));
    exp_value  <= conv_integer(unsigned(temp(3 DOWNTO 0)));
    usb_pid <= to_pid_type(conv_integer(unsigned(temp(3 DOWNTO 0))));
    ASSERT (NOT(temp(7 DOWNTO 4)) = temp(3 DOWNTO 0))
      REPORT "Received PID check field failure."
      SEVERITY FAILURE;

    CASE conv_integer(unsigned(temp(3 DOWNTO 0))) IS
      WHEN ACK_PID =>
        hand_shake := ack_hs;
        dtoggle_out <= NOT dtoggle_out;

      WHEN NAK_PID =>
        hand_shake :=  nak_hs;
        ASSERT NOT verbose
          REPORT "Recieved a NAK hand-shake"
          SEVERITY NOTE;

      WHEN STALL_PID =>
        hand_shake := stall_hs;
        ASSERT false                     -- We don't know how to respond to
          REPORT "hand-shake PID was STALL-- HC Panic." &
                 "****** This is usually an ERROR ******"
          SEVERITY NOTE;                      -- flag a failure.

      WHEN OTHERS =>
        hand_shake :=  nak_hs;
        ASSERT false
          REPORT "Received PID is not a valid Hand-shake value"
          SEVERITY FAILURE;

    END CASE;

    hskip_i := 0;
    WHILE (hskip_i < 3) LOOP                   -- Rx eop
      WAIT UNTIL usb_clk'event AND usb_clk = '1';-- Wait for rising edge
      hc_state <= rx_eop;                        -- Set host controller state
      ASSERT ((hskip_i <= 1) AND (usb_state_of(dplus,dminus) = SE0)) OR
        ((hskip_i = 2) AND (usb_state_of(dplus,dminus) = J))
        REPORT "EOP corrupt or packet lenght mismatch" SEVERITY FAILURE;
      hskip_i :=  hskip_i + 1;                       -- Inc loop count
    END LOOP;

  ELSE                                   -- No response was sent prior to the
                                         -- Bus Timeout interval expiring.
    hand_shake :=  bto_hs;
    ASSERT NOT verbose
      REPORT "Bus time out when expecting a handshake packet."
      SEVERITY NOTE;
  END IF;                                -- end of Bus timeout if-then-else

  hc_state <= hc_idle;                    -- Set host controller state

  clock_master <= clock_master_save;     -- restore the current clock source


END handshake_in_packet;

--------------------------------------------------------------------------------
--
-- Procedure: handshake_out_packet
--
-- Parameters: pid      -- PID
--
-- Globals:    usb_clk  -- USB clock
--             dplus    -- USB data+
--             dminus   -- USB data-
--             hc_state -- USB Host Controller state
--
-- Description: This procedure will transmit a USB handshake packet. The pid
-- parameter is transmitted during the PID portion of the packet.
--
-- Packet Format: See USB Spec 1.0 Section 8.4.4 for more information.
--
--   8-Bits   8-Bits   3-Bits
-- +--------+--------+--------+
-- |  SYNC  |   PID  |   EOP  |
-- +--------+--------+--------+
--
--------------------------------------------------------------------------------
PROCEDURE handshake_out_packet (
  CONSTANT pid      : IN    integer       -- PID
  ) IS

VARIABLE temp : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for
                                                      -- bit stuffing
VARIABLE hskop_i : integer;              -- local loop index
BEGIN

  send_sync(data_history); -- Send sync field

  temp := CONV_STD_LOGIC_VECTOR(pid,32); -- Convert integer pid to
                                         -- std_logic_vector
  temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  usb_pid <= to_pid_type(pid);

  IF pid = ACK_PID THEN
    dtoggle_in <= NOT dtoggle_in;
  END IF;

  FOR hskop_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(hskop_i), data_history);
  END LOOP;

  -- Tx EOP
  IF pid = PRE_PID THEN
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    dplus  <= '1' AFTER 1 ns;
    dminus <= '0' AFTER 1 ns;
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= hc_idle;             -- Set host controller state
    dplus  <= 'Z' AFTER 1 ns;                   -- Release Data+
    dminus <= 'Z' AFTER 1 ns;                   -- Release Data-

  ELSE
    send_eop;
  END IF;

END handshake_out_packet;

--------------------------------------------------------------------------------
--
-- Procedure: get_data
--
-- Parameters: rtype          -- USB Chapter 9/11 bmRequestType field to send
--             breq           -- USB Chapter 9/11 bRequest field to send
--                               Values include 0 - get status
--                                              2 - get state
--                                              6 - get descriptor
--                                              8 - get configuration
--                                             10 - get interface
--             wval           -- USB Chapter 9/11 wValue field to send
--             wind           -- USB Chapter 9/11 wIndex  field to send
--             wlen           -- The length of the data packet to be returned
--             check          -- Enable or disable data checking
--             test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             device_max_pkt -- Current target max packet size
--             hc_pckt_data   -- Transmit packet data
--             hc_rxpkt_data  -- Get return data block
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure is used to do variable length get requests.  It
-- was specifically designed to handle the hub class specific requests, such as
-- get hub descriptor, get hub status and get hub port status. The rtype
-- parameter is assigned to the bmRequestType field of the USB device
-- request. The breq parameter is assigned to the bRequest field of the USB
-- device request.  This code is designed only to perform GET_STATUS, GET_STATE,
-- GET_DESCRIPTOR, GET_CONFIGURATION, or GET_INTERFACE. So legal values of breq
-- are 0, 2, 6, 8, and 10. The wval, wind, and wlen parameters are assigned to
-- the wValue, wIndex, and wLength fields of the USB device request
-- respectively.  The wlen parameter is also used to calculate the expected size
-- of the received packets. The data returned is checked if the check parameter
-- is set to check. If the check parameter is set to no_check the data will not
-- be checked. The received data is available via the hc_rxpkt_data data
-- structure. The test_num parameter is assigned to the global variable
-- test_progress, and incremented as the test proceeds. The global
-- device_address is used to determine the current address of the target being
-- addressed.  The global device max packet is used to determine if the
-- transaction must be broken into multiple IN data packets inorder to receive
-- the amount of data specified by wlen.
--
--------------------------------------------------------------------------------

PROCEDURE   get_data(
  CONSTANT rtype      : IN    integer;   -- bmRequestType field
  CONSTANT breq       : IN    integer;   -- bRequest field
  CONSTANT wval       : IN    integer;   -- wValue field
  CONSTANT wind       : IN    integer;   -- wIndex field
  CONSTANT wlen       : IN    integer;   -- wLength field
  CONSTANT check      : IN    checking_type;   -- data check enable
  CONSTANT test_num   : IN    integer    -- test progress initial value.
  ) IS

VARIABLE   retry_count : integer;        -- count of retrys due to bus time out
VARIABLE   temp_vec    : std_logic_vector(15 DOWNTO 0);-- temp variable for 16 fields
VARIABLE   temp_array  : byte_array(0 TO 7); -- tempory storage for write data
VARIABLE   gd_bytes_remaining : integer; -- get data bytes remaining in this transaction
VARIABLE   gd_expected_len    : integer; -- get data byte expected in this packet.
VARIABLE   gd_packet_offset   : integer; -- get data offset into the hc_rxpkt data.
VARIABLE   gd_i               : integer; -- loop index.
BEGIN
  test_progress <= test_num;

  -- save the first 8 bytes of the expected data in the hc_rxpkt_data array
  FOR gd_i IN 0 TO 7 LOOP
    hc_rxpkt_data := hc_pckt_data;
  END LOOP; -- gd_i

  -- assemble a get descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(rtype,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(breq,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(wval,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wind,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wlen,16);   -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT terse  REPORT "Transmit setup packet with get request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  test_progress <= test_num +1;

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- get the return data

  -- restore the first 8 bytes of the expected data from the hc_rxpkt_data array
  FOR gd_i IN 0 TO 7 LOOP
    hc_pckt_data := hc_rxpkt_data;
  END LOOP; -- gd_i

  -- now turn the bus around to recieve the descriptor

  gd_bytes_remaining := wlen;
  gd_packet_offset := 0;
  dtoggle_in <= '1';    -- initialize the data toggle bit for DATAX_PID

  hc_rxpkt_length := device_max_pkt;
  WHILE hc_rxpkt_length = device_max_pkt AND
        gd_bytes_remaining > 0 LOOP

    IF gd_bytes_remaining > device_max_pkt THEN
      gd_expected_len := device_max_pkt;
    ELSE
      gd_expected_len := gd_bytes_remaining ;
    END IF;

    ASSERT terse REPORT
      "Send an in token to receive a data packet." SEVERITY NOTE;
    hand_shake := nak_hs;
    WHILE hand_shake /= data_hs LOOP
      token_packet(IN_PID, device_address, endpt => 0);

      ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
      hand_shake := nak_hs;
      data_in_packet(DATAX_PID, gd_expected_len, gd_packet_offset, hand_shake, check);
    END LOOP; -- hand_shake /= DATA

    gd_bytes_remaining := gd_bytes_remaining - hc_rxpkt_length;
    gd_packet_offset := gd_packet_offset + hc_rxpkt_length;

    -- Acknowledge the config block

    ASSERT terse REPORT "Acking this descriptor packet"
      SEVERITY NOTE;
    handshake_out_packet (ACK_PID);

  END LOOP; -- hc_rxpkt_length /= device_max_pkt

  test_progress <= test_num +2;

  ASSERT NOT verbose REPORT "Acking the descriptor block"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- now turn the bus around to terminate the setup transfer
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);


    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs

END get_data;

--------------------------------------------------------------------------------
--
-- Procedure: get_device_desc
--
-- Parameters: test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--             device_max_pkt -- Maximum packet size for contol endpoint 0.
--
-- Description: This procedure performs a get device descriptor control
-- transfer, and sets the global variable device_max_pkt. Currently only
-- certain bytes of the device descriptor data that are not likely to be
-- changed are checked. Users can modify this data to be there expected
-- device descriptor information for data comparison. The test_num parameter
-- is assigned to the global variable test_progress, and incremented as the
-- test proceeds. The get_device_desc procedure is an excellent example of
-- how USB packet procedures can be used together to create complete USB
-- transactions. Users should analyze this code. The global device_address
-- is used to determine the current address of the target being addressed.
-- For more information on the device descriptor see Section 9.6.1 of the
-- USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE get_device_desc (
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

VARIABLE bytes_remaining : integer;      -- number of bytes left to transfer
VARIABLE descriptor_len  : integer;      -- total number of bytes in descriptor
VARIABLE expected_len    : integer;      -- number of bytes in this packet
VARIABLE gdd_i           : integer;      -- local loop index
VARIABLE packet_offset   : integer;      -- offset into packet data structures
VARIABLE retry_cnt       : integer;      -- count of retrys due to bus time out

BEGIN
 -- This routine fetches the first 8 bytes of the device descriptor to get the
 -- device endpoint 0 max packet size(device_max_pkt), then restarts the get
 -- device descriptor request using the device_max_pkt value to break the
 -- descriptor into smaller packets if required.

  -- assemble a get device descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#06#,8); -- bREquest: GetDescriptor
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#01#,8); --          device descript
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  -- ask for only the first 8 bytes.
  hc_pckt_data(6) := conv_std_logic_vector(16#08#,8); -- wLength: 0x0008
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with get device descriptor request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  retry_cnt := 3;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat until the target responds
    test_progress <= test_num;

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- xx01 Send get descriptor request


    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num + 2;           -- xx02 Check the setup data ACK

    -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT
      "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs OR retry_cnt /= 0)
      REPORT "Bus Timeout retry count exceeded."
      SEVERITY FAILURE;

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY NOTE;

    retry_cnt := retry_cnt - 1;
    WAIT FOR 200 us;
  END LOOP;                          -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- now turn the bus around to recieve the descriptor
  test_progress <= test_num + 3; -- Send in token and receive descriptor

  ASSERT false REPORT
    "Send an in token to receive the the first 8 bytes of the descriptor."
    SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    data_in_packet(DATA1_PID, 16#08#, 0, hand_shake, no_check);
  END LOOP; -- hand_shake /= DATA

  ASSERT (hc_rxpkt_length = 8) REPORT
    "Target did not return the amount of data requested in the wlen field."
    SEVERITY FAILURE;

  -- save the device_max_pkt size and the descriptor_len.
  descriptor_len := conv_integer(unsigned(hc_rxpkt_data(0)));
  device_max_pkt := conv_integer(unsigned(hc_rxpkt_data(7)));

  -- Acknowledge the config block
  test_progress <= test_num + 4;   -- xx04  Acknowledge the Config block

  ASSERT false REPORT "Acking the descriptor block"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 5; -- Send an in token an wait for 0 length data
                             -- packet return
  hand_shake := nak_hs;
  ASSERT false REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    IF force_non_zero_status THEN
      ASSERT false REPORT "send a bogus non-zero length status phase data packet"
         SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#2#);
    ELSE
      ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);
    END IF;

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs

  -- Now get the descriptor again using the device_max_pkt and descriptor
  -- length variables.

 -- assemble a get device descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#06#,8); -- bREquest: GetDescriptor
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#01#,8); --          device descript
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  -- ask for the whole thing.
  hc_pckt_data(6) := conv_std_logic_vector(descriptor_len,8); -- wLength:
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);         -- descriptor_len

  ASSERT false  REPORT "Transmit data packet with get device descriptor request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  retry_cnt := 3;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num + 6;

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 7;           -- xx01 Send get descriptor request


    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num + 8;           -- xx02 Check the setup data ACK

    -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs OR retry_cnt /= 0)
      REPORT "Bus Timeout retry count exceeded."
      SEVERITY FAILURE;

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-sending setup and data packets."
      SEVERITY NOTE;

    retry_cnt := retry_cnt - 1;
    WAIT FOR 200 us;
  END LOOP;                     -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;


  -- set the expected data in the hc_pckt_data
  hc_pckt_data(0) := conv_std_logic_vector(16#12#,8); -- bLength
  hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- bDescriptor Type
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- bcdUSB
  hc_pckt_data(3) := conv_std_logic_vector(16#01#,8);

 --  We no longer check for specific values, but the the values below represent
 --  reasonable value for these fields.

--  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- dDevice Class
--  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8); -- bDevice Sub Class
--  hc_pckt_data(6) := conv_std_logic_vector(16#00#,8); -- bDevice Protocol
--  hc_pckt_data(7) := conv_std_logic_vector(16#40#,8); -- bMaxPacketSize = 64
--  hc_pckt_data(8) := conv_std_logic_vector(16#a3#,8); -- idVendor
--  hc_pckt_data(9) := conv_std_logic_vector(16#05#,8); -- idVendor
--  hc_pckt_data(10) := conv_std_logic_vector(16#01#,8); -- idProduct
--  hc_pckt_data(11) := conv_std_logic_vector(16#01#,8); -- idProduct
--  hc_pckt_data(12) := conv_std_logic_vector(16#00#,8); -- bcdDevice
--  hc_pckt_data(13) := conv_std_logic_vector(16#00#,8); -- bcdDevice
--  hc_pckt_data(14) := conv_std_logic_vector(16#01#,8); -- iManufacturer
--  hc_pckt_data(15) := conv_std_logic_vector(16#02#,8); -- iProduct
--  hc_pckt_data(16) := conv_std_logic_vector(16#03#,8); -- iSerialNumber
--  hc_pckt_data(17) := conv_std_logic_vector(16#01#,8); -- bNumConfigurations
  FOR gdd_i IN 4 TO 17 LOOP
    hc_pckt_data(gdd_i) := "XXXXXXXX";       -- set values that we don't check to
  END LOOP;                              -- all x's

  -- now turn the bus around to recieve the descriptor
  test_progress <= test_num + 9; -- Send in token and receive descriptor

  bytes_remaining := descriptor_len;
  packet_offset := 0;

  hc_rxpkt_length := device_max_pkt;
  WHILE hc_rxpkt_length = device_max_pkt AND
        bytes_remaining >= 0 LOOP

    IF bytes_remaining > device_max_pkt THEN
      expected_len := device_max_pkt;
    ELSE
      expected_len := bytes_remaining ;
    END IF;

    ASSERT terse REPORT
      "Send an in token to receive a descriptor packet." SEVERITY NOTE;
    hand_shake := nak_hs;
    WHILE hand_shake /= data_hs LOOP
      token_packet(IN_PID, device_address, endpt => 0);
      ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
      hand_shake := nak_hs;
      data_in_packet(DATAX_PID, expected_len, packet_offset, hand_shake, check);
    END LOOP; -- hand_shake /= DATA

    bytes_remaining := bytes_remaining - hc_rxpkt_length;
    packet_offset := packet_offset + hc_rxpkt_length;

    -- Acknowledge the config block
    test_progress <= test_num + 16#a#;   -- xx04  Acknowledge the Config block

    ASSERT terse REPORT "Acking this descriptor packet"
      SEVERITY NOTE;
    handshake_out_packet (ACK_PID);

  END LOOP; -- hc_rxpkt_length /= device_max_pkt

  ASSERT terse REPORT "Acking this descriptor packet"
    SEVERITY NOTE;

  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 16#b#; -- Send an in token an wait for 0 length data
                             -- packet return
  hand_shake := nak_hs;
  ASSERT terse REPORT "Send an out token to turn the bus around."
    SEVERITY NOTE;

  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    IF force_non_zero_status THEN
      ASSERT false REPORT "send a bogus non-zero length status phase data packet"
         SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#2#);
    ELSE
      ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);
    END IF;

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs

END get_device_desc;

--------------------------------------------------------------------------------
--
-- Procedure: get_hub_desc
--
-- Parameters: test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a get hub device descriptor control
-- transfer. Users can modify this data to be there expected hub device
-- descriptor information for data comparison. The test_num parameter is
-- assigned to the global variable test_progress, and incremented as the
-- test proceeds. The global device_address is used to determine the current
-- address of the target being addressed. For more information on the device
-- descriptor see Section 9.6.1 of the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE get_hub_desc (
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

BEGIN
  -- set the expected data in the hc_pckt_data
  hc_pckt_data(0) := conv_std_logic_vector(16#09#,8); -- bLength
  hc_pckt_data(1) := conv_std_logic_vector(16#29#,8); -- bDescriptor Type
  hc_pckt_data(2) := conv_std_logic_vector(16#03#,8); -- # of Downstream Ports
  hc_pckt_data(3) := conv_std_logic_vector(16#09#,8); -- wHubCharacteristics
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(5) := conv_std_logic_vector(16#02#,8); -- bPwrOn2PwrGood
  hc_pckt_data(6) := conv_std_logic_vector(16#00#,8); -- bContrCurrent
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8); -- Device Removable
  hc_pckt_data(8) := conv_std_logic_vector(16#ff#,8); -- PortPwrCtrlMask

  get_data(rtype => 16#a0#,              -- bmRequestType
           breq => 6,                    -- bREquest : get descriptor
           wval => 16#2900#,             -- wValue   : Hub class
           wind => 0,                    -- wIndex
           wlen => 9,                    -- wLength  : length of returned packet.
           check => check,               -- checking enabled.
           test_num => test_num);

END get_hub_desc;

--------------------------------------------------------------------------------
--
-- Procedure: get_config_desc
--
-- Parameters: test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a get configuration descriptor
-- control transfer. Currently only certain bytes of the configuration
-- descriptor data are checked. Users can modify this data to be there
-- expected configuration descriptor information for data comparison. The
-- test_num parameter is assigned to the global variable test_progress,
-- and incremented as the test proceeds. The global device_address is used
-- to determine the current address of the target being addressed. For more
-- information on the configuration descriptor see Section 9.6.2 of the
-- USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE get_config_desc (
--  CONSTANT config_type   : IN    configuration_type := composit_device;
  CONSTANT test_num      : IN    integer
  ) IS
VARIABLE bytes_remaining : integer;      -- number of bytes left to transfer
VARIABLE descriptor_len  : integer;      -- total number of bytes in descriptor
VARIABLE expected_len    : integer;      -- number of bytes in this packet
VARIABLE gcd_i           : integer;      -- local loop index
VARIABLE packet_offset   : integer;      -- offset into packet data structures

BEGIN

  -- assemble a get configuration desctiptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#06#,8); -- bREquest: GetDescriptor
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#02#,8); --         config descriptor
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#ff#,8); -- wLength: 0x01ff
  hc_pckt_data(7) := conv_std_logic_vector(16#01#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with get configuration descriptor request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP   -- Repeat untill the target responds
    test_progress <= test_num;       -- Starting get descriptor send setup token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num+1;           -- Send get descriptor request


    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num+2;           -- Check the setup data ACK

                                         -- wait for the handshake packet the
                                         -- Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR NOT verbose
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY NOTE; --  This would normally be an error, but because the
                     --  address register in the SIE is being updated We are
                     --  only making a note here.
  END LOOP;          -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- set the expected data in the hc_pckt_data

--  If config_type = composit_device then
    -- Configuration Descriptor
    hc_pckt_data(0) := conv_std_logic_vector(16#09#,8);  -- bLength
    hc_pckt_data(1) := conv_std_logic_vector(16#02#,8); -- bDescriptor Type
    hc_pckt_data(2) := conv_std_logic_vector(16#9c#,8);     -- wTotal Length
    hc_pckt_data(3) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(4) := conv_std_logic_vector(16#03#,8); -- bNumInterfaces
    hc_pckt_data(5) := conv_std_logic_vector(16#01#,8); -- bConfigurationValue
    hc_pckt_data(6) := conv_std_logic_vector(16#04#,8); -- iConfiguration
    hc_pckt_data(7) := conv_std_logic_vector(16#40#,8); -- bmAttributes
    hc_pckt_data(8) := conv_std_logic_vector(16#00#,8); -- MaxPower

    -- Interface Descriptor
    -- IFC0
    hc_pckt_data(9)  := conv_std_logic_vector(16#0b#,8); -- bLength
    hc_pckt_data(10) := conv_std_logic_vector(16#04#,8); -- bDescriptorType
    hc_pckt_data(11) := conv_std_logic_vector(16#00#,8); -- bInterfaceNumber
    hc_pckt_data(12) := conv_std_logic_vector(16#00#,8); -- bAlternateSetting
    hc_pckt_data(13) := conv_std_logic_vector(16#00#,8); -- bNumEndpoints
    hc_pckt_data(14) := conv_std_logic_vector(16#01#,8); -- bInterfaceClass
    hc_pckt_data(15) := conv_std_logic_vector(16#01#,8); -- bInterfaceSubClass
    hc_pckt_data(16) := conv_std_logic_vector(16#00#,8); -- bInterfaceProtocol
    hc_pckt_data(17) := conv_std_logic_vector(16#00#,8); -- iInterface
    hc_pckt_data(18) := conv_std_logic_vector(16#01#,8); -- extra
    hc_pckt_data(19) := conv_std_logic_vector(16#00#,8); -- extra

    -- Interface AUDIO Descriptors
    hc_pckt_data(20) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(21) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(22) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(23) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(24) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(25) := conv_std_logic_vector(16#1e#,8);
    hc_pckt_data(26) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(27) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(28) := conv_std_logic_vector(16#01#,8);

    hc_pckt_data(29) := conv_std_logic_vector(16#0c#,8);
    hc_pckt_data(30) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(31) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(32) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(33) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(34) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(35) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(36) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(37) := conv_std_logic_vector(16#03#,8);
    hc_pckt_data(38) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(39) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(40) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(41) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(42) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(43) := conv_std_logic_vector(16#03#,8);
    hc_pckt_data(44) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(45) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(46) := conv_std_logic_vector(16#03#,8);
    hc_pckt_data(47) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(48) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(49) := conv_std_logic_vector(16#00#,8);
    -- IFC1 Alt 0
    hc_pckt_data(50) := conv_std_logic_vector(16#0b#,8);
    hc_pckt_data(51) := conv_std_logic_vector(16#04#,8);
    hc_pckt_data(52) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(53) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(54) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(55) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(56) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(57) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(58) := conv_std_logic_vector(16#04#,8);
    hc_pckt_data(59) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(60) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(61) := conv_std_logic_vector(16#07#,8);
    hc_pckt_data(62) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(63) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(64) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(65) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(66) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(67) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(68) := conv_std_logic_vector(16#0b#,8);
    hc_pckt_data(69) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(70) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(71) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(72) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(73) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(74) := conv_std_logic_vector(16#10#,8);
    hc_pckt_data(75) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(76) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(77) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(78) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(79) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(80) := conv_std_logic_vector(16#05#,8);
    hc_pckt_data(81) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(82) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(83) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(84) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(85) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(86) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(87) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(88) := conv_std_logic_vector(16#07#,8);
    hc_pckt_data(89) := conv_std_logic_vector(16#25#,8);
    hc_pckt_data(90) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(91) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(92) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(93) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(94) := conv_std_logic_vector(16#00#,8);

    -- IFC1 Alt 1
    hc_pckt_data(95) := conv_std_logic_vector(16#0b#,8);
    hc_pckt_data(96) := conv_std_logic_vector(16#04#,8);
    hc_pckt_data(97) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(98) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(99) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(100) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(101) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(102) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(103) := conv_std_logic_vector(16#05#,8);
    hc_pckt_data(104) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(105) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(106) := conv_std_logic_vector(16#07#,8);
    hc_pckt_data(107) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(108) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(109) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(110) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(111) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(112) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(113) := conv_std_logic_vector(16#0b#,8);
    hc_pckt_data(114) := conv_std_logic_vector(16#24#,8);
    hc_pckt_data(115) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(116) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(117) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(118) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(119) := conv_std_logic_vector(16#10#,8);
    hc_pckt_data(120) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(121) := conv_std_logic_vector(16#11#,8);
    hc_pckt_data(122) := conv_std_logic_vector(16#2b#,8);
    hc_pckt_data(123) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(124) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(125) := conv_std_logic_vector(16#05#,8);
    hc_pckt_data(126) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(127) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(128) := conv_std_logic_vector(16#30#,8);
    hc_pckt_data(129) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(130) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(131) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(132) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(133) := conv_std_logic_vector(16#07#,8);
    hc_pckt_data(134) := conv_std_logic_vector(16#25#,8);
    hc_pckt_data(135) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(136) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(137) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(138) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(139) := conv_std_logic_vector(16#00#,8);

    hc_pckt_data(140) := conv_std_logic_vector(16#09#,8);
    hc_pckt_data(141) := conv_std_logic_vector(16#04#,8);
    hc_pckt_data(142) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(143) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(144) := conv_std_logic_vector(16#01#,8);
    hc_pckt_data(145) := conv_std_logic_vector(16#ff#,8);
    hc_pckt_data(146) := conv_std_logic_vector(16#ff#,8);
    hc_pckt_data(147) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(148) := conv_std_logic_vector(16#06#,8);

    hc_pckt_data(149) := conv_std_logic_vector(16#07#,8);
    hc_pckt_data(150) := conv_std_logic_vector(16#05#,8);
    hc_pckt_data(151) := conv_std_logic_vector(16#03#,8);
    hc_pckt_data(152) := conv_std_logic_vector(16#02#,8);
    hc_pckt_data(153) := conv_std_logic_vector(16#40#,8);
    hc_pckt_data(154) := conv_std_logic_vector(16#00#,8);
    hc_pckt_data(155) := conv_std_logic_vector(16#00#,8);

--  else --elsif config_type = composit_hub then
--    FOR gcd_index IN 0 TO 156 LOOP
--      hc_pckt_data(gcd_index) := "XXXXXXXX"; -- for now don't check the data
--    END loop;
--  end IF; -- config_type


  -- now turn the bus around to recieve the descriptor
  test_progress <= test_num+3; -- Send in token and receive descriptor

  bytes_remaining := 16#ffff#;  -- If you don't know you descriptor size in advance
                            -- set this value to 0xffff and the descriptor length
                            -- will be pulled out of the packet.  This will not
                            -- work if your descriptor size is less than the
                            -- device_max_pkt size.
  packet_offset := 0;
  dtoggle_in <= '1';    -- initialize the data toggle bit for DATAX_PID

  hc_rxpkt_length := device_max_pkt;
  WHILE hc_rxpkt_length = device_max_pkt AND
        bytes_remaining >= 0 LOOP

    IF bytes_remaining > device_max_pkt THEN
      expected_len := device_max_pkt;
    ELSE
      expected_len := bytes_remaining ;
    END IF;

    ASSERT terse REPORT
      "Send an in token to receive a descriptor packet." SEVERITY NOTE;
    hand_shake := nak_hs;
    WHILE hand_shake /= data_hs LOOP
      token_packet(IN_PID, device_address, endpt => 0);
      ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
      hand_shake := nak_hs;

      -- if you know the exact length and content of your configuration
      -- descriptor, and have put the data in the hc_pkt_data array then turn
      -- on the data and length checking in the data in packet task, otherwise,
      -- leave no_check asserted and only the length of each packet will be
      -- checked for consistency with the max paket size received in the get
      -- device descriptor routine, and the configuration descriptor length in
      -- the first packet of the configuration descriptor.

--      data_in_packet(DATAX_PID, expected_len, packet_offset, hand_shake, check);
      data_in_packet(DATAX_PID, expected_len, packet_offset, hand_shake, no_check);
    END LOOP; -- hand_shake /= DATA


    IF bytes_remaining = 16#ffff# THEN       -- the first time through grap the len
      descriptor_len  := conv_integer(unsigned(hc_rxpkt_data(2))) +
                         conv_integer(unsigned(hc_rxpkt_data(3))) * 256;
      bytes_remaining := descriptor_len;
      IF descriptor_len < device_max_pkt THEN
        expected_len := descriptor_len;
      END IF;
    END IF;

    -- check that the packet was equal to the max packet length unless it is
    -- the last packet of the descriptor then it should be the number of bytes
    -- remaining in the descriptor.
    ASSERT (expected_len = hc_rxpkt_length)
      REPORT "unexpected length packet received."
      SEVERITY FAILURE;

    bytes_remaining := bytes_remaining - hc_rxpkt_length;
    packet_offset := packet_offset + hc_rxpkt_length;

    -- Acknowledge the config block
    test_progress <= test_num + 4;   -- xx04  Acknowledge the Config block

    ASSERT terse REPORT "Acking this descriptor packet"
      SEVERITY NOTE;
    handshake_out_packet (ACK_PID);

  END LOOP; -- hc_rxpkt_length /= device_max_pkt

  ASSERT (bytes_remaining = 0)
    REPORT "packet length is not consistent with the max packet size and the" &
           " descriptor total length"
    SEVERITY FAILURE;

  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num+5; -- Send a 0 length data packet and wait for ACK
  hand_shake := nak_hs;
  ASSERT false REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);

  test_progress <= test_num+6; -- Check for Errors
    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs

END get_config_desc;

--------------------------------------------------------------------------------
--
-- Procedure: get_device_status
--
-- Parameters: test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a get device status control transfer.
-- Currently only certain bytes of the device status data are checked.
-- Users can modify this data to be there expected device status information
-- for data comparison. The test_num parameter is assigned to the global
-- variable test_progress, and incremented as the test proceeds. The global
-- device_address is used to determine the current address of the target
-- being addressed. For more information on the Get Status device request
-- see Section 9.4.5 of the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE get_device_status (
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

BEGIN
  -- assemble a get status packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8); -- bREquest: get status
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); --          device descript
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#02#,8); -- wLength: 0x0002
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with get device status request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num;

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- xx01 Send get descriptor request


    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num + 2;           -- xx02 Check the setup data ACK

                                         -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY FAILURE;
  END LOOP;                              -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- set the expected data in the hc_pckt_data
  hc_pckt_data(0) := conv_std_logic_vector(16#01#,8); -- self powered w/o
                                                      -- remote wake-up
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8);

  -- now turn the bus around to recieve the descriptor
  test_progress <= test_num + 3; -- xx 03Send in token and receive descriptor

  ASSERT false REPORT "Send an in token to receive the status." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    data_in_packet(DATA1_PID, 2, 0, hand_shake, check);
  END LOOP; -- hand_shake /= DATA

  -- Acknowledge the config block
  test_progress <= test_num + 4;             -- xx04  Acknowledge the Config block

  ASSERT false REPORT "Acking the status block"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 5; -- Send an in token an wait for 0 length data
                             -- packet return
  hand_shake := nak_hs;
  ASSERT false REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    IF force_non_zero_status THEN
      ASSERT false REPORT "send a bogus non-zero length status phase data packet"
         SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#2#);
    ELSE
      ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);
    END IF;

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs


END get_device_status;


--------------------------------------------------------------------------------
--
-- Procedure: get_endpoint_status
--
-- Parameters: test_num       -- Base test number for test progress signal
--             endpt_num      -- Endpoint to determine status
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a get endpoint status control transfer.
-- Currently none of the endpoint status data is checked. Users can add there
-- expected endpoint status information for data comparison. The test_num
-- parameter is assigned to the global variable test_progress, and incremented
-- as the test proceeds. The global device_address is used to determine the
-- current address of the target being addressed. For more information on the
-- Get Status device request see Section 9.4.5 of the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE get_endpoint_status (
  CONSTANT endpt_num  : IN    integer;      -- PID
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

BEGIN
  test_progress <= test_num;             -- start get enpoint status
  -- assemble a get status packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#82#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8); -- bREquest: get status
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); --          device descript
  hc_pckt_data(4) := conv_std_logic_vector(endpt_num,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#02#,8); -- wLength: 0x0002
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with get endpoint status request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num;

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- xx01 Send get descriptor request


    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num + 2;           -- xx02 Check the setup data ACK

                                         -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY FAILURE;
  END LOOP;                              -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- now turn the bus around to recieve the descriptor
  test_progress <= test_num + 3; -- xx 03Send in token and receive descriptor

  ASSERT false REPORT "Send an in token to receive the status." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    data_in_packet(DATA1_PID, 2, 0, hand_shake, no_check);
  END LOOP; -- hand_shake /= DATA

  -- Acknowledge the config block
  test_progress <= test_num + 4;             -- xx04  Acknowledge the Config block

  ASSERT false REPORT "Acking the status block"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 5; -- Send an out token and a 0 length data
                                 -- packet
  hand_shake := nak_hs;
  ASSERT false REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    IF force_non_zero_status THEN
      ASSERT false REPORT "send a bogus non-zero length status phase data packet"
         SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#2#);
    ELSE
      ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);
    END IF;

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs


END get_endpoint_status;

--------------------------------------------------------------------------------
--
-- Procedure: get_value
--
-- Parameters: breq           -- Request type 8-configuration 10-interface
--             exp_value      -- Expected configuration value
--             wval           -- Configuration value to be set
--             wind           -- wIndex used in set interface
--             test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a get configuration or get interface
-- control transfer to a usb target. Currently none of the configuration or
-- interface status data is checked. Users can add there configuration or
-- interface status information for data comparison. The test_num parameter
-- is assigned to the global variable test_progress, and incremented as the
-- test proceeds. The global device_address is used to determine the current
-- address of the target being addressed. For more information on the Get
-- Configuration device request see Section 9.4.2 of the USB Spec Version 1.0.
-- For more information on the Get Interface device request see Section 9.4.4
-- of the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------
PROCEDURE get_value (
  CONSTANT breq       : IN    integer;   -- bRequest 9-configuration 11-interface
  CONSTANT exp_value  : IN    integer;   -- expected configuration value
  CONSTANT wind       : IN    integer;   -- wIndex interface number
  CONSTANT test_num   : IN    integer    -- base test number

  ) IS

  VARIABLE temp_vec   : std_logic_vector(15 DOWNTO 0);

BEGIN
  -- assemble a get status packet.
  IF breq = 10 THEN                      -- get interface
    hc_pckt_data(0) := conv_std_logic_vector(16#81#,8); -- bmRequestType
  ELSE                                   -- get configuration
    hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  END IF;
  hc_pckt_data(1) := conv_std_logic_vector(breq,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(0,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wind,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(1,16);      -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);


  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with get config or interface  request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num;

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- xx01 Send get descriptor request

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num + 2;           -- xx02 Check the setup data ACK

                                         -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY FAILURE;
  END LOOP;                              -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- set the expected data in the hc_pckt_data
  hc_pckt_data(0) := conv_std_logic_vector(exp_value,8);

  -- now turn the bus around to recieve the descriptor
  test_progress <= test_num + 3; -- xx 03Send in token and receive descriptor

  ASSERT false REPORT "Send an in token to receive the value."
    SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    data_in_packet(DATA1_PID, 1, 0, hand_shake, check);
  END LOOP; -- hand_shake /= DATA

  -- Acknowledge the config block
  test_progress <= test_num + 4;             -- xx04  Acknowledge the Config block

  ASSERT false REPORT "Acking the data packet"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 5; -- Send an in token an wait for 0 length data
                             -- packet return
  hand_shake := nak_hs;
  ASSERT false REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    IF force_non_zero_status THEN
      ASSERT false REPORT "send a bogus non-zero length status phase data packet"
         SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#2#);
    ELSE
      ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);

    END IF;

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs


END get_value;

--------------------------------------------------------------------------------
--
-- Procedure: set_address
--
-- Parameters: address        -- Address to set in target
--             test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a set address transfer to a USB
-- target. The test_num parameter is assigned to the global variable
-- test_progress, and incremented as the test proceeds. The global
-- device_address is used to determine the current address of the target
-- being addressed. When complete the device_address global variable
-- is then set to the address parameter. For more information on the Set
-- Address device request see Section 9.4.6 of the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE set_address (
  CONSTANT address    : IN    integer;      -- PID
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

VARIABLE   retry_count : integer;   -- count of retrys due to bus time out

BEGIN

  -- assemble a set address packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#05#,8); -- bREquest: Set address
  hc_pckt_data(2) := conv_std_logic_vector(address,8); -- wValue: address
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#00#,8); -- wLength: 0
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with set address request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num; -- Start Set Address Transaction, send a setup
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

--    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
--    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- Send a set address req data packet

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK
    test_progress <= test_num + 2;             -- Wait for Setup data Acknowledge

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;



  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 3; -- Send and in token and wait for a 0 length data
                             -- response packet
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an in token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    data_in_packet(DATA1_PID, 16#0#, 0, hand_shake, check);
    ASSERT (hand_shake = data_hs) OR NOT verbose
      REPORT "Recieved non-data packet. Check again for the in data packet."
      SEVERITY NOTE;
  END LOOP;                              -- hand_shake /= DATA

  ASSERT NOT verbose REPORT "Acking the zero length in packet"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- give software some time to set the address register.
  WAIT FOR 50000 ns;                     -- 50 us

  device_address := address;             -- set the new device address

END set_address;

--------------------------------------------------------------------------------
--
-- Procedure: set_value
--
-- Parameters: breq           -- Request type 9-configuration 11-interface
--             wval           -- Configuration value to be set
--             wind           -- wIndex used in set interface
--             test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a set configuration or set interface
-- control transfer to a USB target. The test_num parameter is assigned to
-- the global variable test_progress, and incremented as the test proceeds.
-- The global device_address is used to determine the current address of the
-- target being addressed. For more information on the Set Configuration
-- device request see Section 9.4.7 of the USB Spec Version 1.0. For more
-- information on the Set Interface device request see Section 9.4.10 of
-- the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE set_value (
  CONSTANT breq       : IN    integer;   -- bRequest 9-configuration 11-interface
  CONSTANT wval       : IN    integer;   -- value to be set
  CONSTANT wind       : IN    integer;   -- wIndex interface number
  CONSTANT test_num   : IN    integer    -- base test number
  ) IS

  VARIABLE temp_vec   : std_logic_vector(15 DOWNTO 0);

BEGIN

  -- assemble a set configuration packet.
  IF breq = 11 THEN                      -- set interface
    hc_pckt_data(0) := conv_std_logic_vector(16#01#,8); -- bmRequestType
  ELSE                                   -- set configuration
    hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- bmRequestType
  END IF;
  hc_pckt_data(1) := conv_std_logic_vector(breq,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(wval,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wind,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(0,16);      -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with set configuration request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num;          -- Starting set descriptor send setup token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- Send set descriptor request


    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

    test_progress <= test_num + 2;           -- Check the setup data ACK

                                         -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY FAILURE;
  END LOOP;                              -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;



  -- now turn the bus around to terminate the setup transfer
  test_progress <= test_num + 3; -- Send and in token and wait for a 0 length data
                                 -- response packet
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an in token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    data_in_packet(DATA1_PID, 16#0#, 0, hand_shake, check);
    ASSERT (hand_shake = data_hs) OR NOT verbose
      REPORT "Recieved non-data packet. Check again for the in data packet."
      SEVERITY NOTE;
  END LOOP;                              -- hand_shake /= DATA

  ASSERT NOT verbose REPORT "Acking the zero length in packet"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

END set_value;

--------------------------------------------------------------------------------
--
-- Procedure: set_feature
--
-- Parameters: rtype          -- 0-device, 1-interface, 2-endpoint.
--             wval           -- The feature selector to be set.
--             wind           -- The interface or endpoint number
--             test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a set feature control transfer to a
-- USB target. The rtype parameter selects the destination of the set feature.
-- This can be a device, interface, or endpoint. The wval is the feature
-- selector to be set within the recipient device, interface, or endpoint.
-- And wind selects the interface or endpoint number. The test_num parameter
-- is assigned to the global variable test_progress, and incremented as the
-- test proceeds. The global device_address is used to determine the current
-- address of the target being addressed. For more information on the Set
-- Feature device request see Section 9.4.9 of the USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE   set_feature (
  CONSTANT rtype      : IN    integer;   -- bmRequest target type
  CONSTANT wval       : IN    integer;   -- wValue field
  CONSTANT wind       : IN    integer;   -- wIndex field
  CONSTANT test_num   : IN    integer    --
  ) IS

VARIABLE   retry_count : integer;        -- count of retrys due to bus time out
VARIABLE   temp_vec    : std_logic_vector(15 DOWNTO 0);-- temp variable for 16 fields
VARIABLE   temp_array  : byte_array(0 TO 7); -- tempory storage for write data
BEGIN

  test_progress <= test_num;             -- start set feature
  -- assemble a set feature  packet.
  hc_pckt_data(0) := conv_std_logic_vector(rtype,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(3   ,8); -- bREquest:
  temp_vec := conv_std_logic_vector(       wval,16);-- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(       wind,16);-- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(          0,16);-- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT false  REPORT "Transmit setup packet with set feature request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- xx01 Send set feature
    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK

    test_progress <= test_num + 2;           -- xx02 Check the setup data ACK

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- now turn the bus around to terminate the setup transfer
                             -- response packet
  test_progress <= test_num + 3; -- xx 03Send in token to initiate the status phase
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an in token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    data_in_packet(DATA1_PID, 16#0#, 0, hand_shake, check);
    ASSERT (hand_shake = data_hs) OR NOT verbose
      REPORT "Recieved non-data packet. Check again for the in data packet."
      SEVERITY NOTE;
  END LOOP;                              -- hand_shake /= DATA

  test_progress <= test_num + 4;             -- xx04  Acknowledge the status phase
  ASSERT NOT verbose REPORT "Acking the zero length in packet"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);


END set_feature;


--------------------------------------------------------------------------------
--
-- Procedure: clear_feature
--
-- Parameters: rtype          -- 0-device, 1-interface, 2-endpoint.
--             wval           -- The feature selector to be cleared.
--             wind           -- The interface or endpoint number
--             test_num       -- Base test number for test progress signal
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit and expected packet data
--             test_progress  -- Counts test bench progression
--
-- Description: This procedure performs a clear feature control transfer to
-- a USB target. The rtype parameter selects the destination of the clear
-- feature. This can be a device, interface, or endpoint. The wval is the
-- feature selector to be cleared within the recipient device, interface,
-- or endpoint. And wind selects the interface or endpoint number. The
-- test_num parameter is assigned to the global variable test_progress,
-- and incremented as the test proceeds. The global device_address is used
-- to determine the current address of the target being addressed. For more
-- information on the Clear Feature device request see Section 9.4.1 of the
-- USB Spec Version 1.0.
--
--------------------------------------------------------------------------------

PROCEDURE   clear_feature (
  CONSTANT rtype      : IN    integer;   -- bmRequest target rtype
  CONSTANT wval       : IN    integer;   -- wValue field
  CONSTANT wind       : IN    integer;   -- wIndex field
  CONSTANT test_num   : IN    integer    --
  ) IS

VARIABLE   retry_count : integer;       -- count of retrys due to bus time out
VARIABLE   temp_vec    : std_logic_vector(15 DOWNTO 0);-- temp variable for 16 fields
VARIABLE   temp_array  : byte_array(0 TO 7); -- tempory storage for write data

BEGIN

  test_progress <= test_num;             -- begin set feature
  -- assemble a set feature  packet.
  hc_pckt_data(0) := conv_std_logic_vector(rtype,8); -- bmRequestType - set vendor
  hc_pckt_data(1) := conv_std_logic_vector(1   ,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(wval,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(       wind,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(          0,16);   -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT false  REPORT "Transmit setup packet with clear feature request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- now turn the bus around to terminate the setup transfer
                             -- response packet
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an in token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    data_in_packet(DATA1_PID, 16#0#, 0, hand_shake, check);
    ASSERT (hand_shake = data_hs) OR NOT verbose
      REPORT "Recieved non-data packet. Check again for the in data packet."
      SEVERITY NOTE;
  END LOOP;                              -- hand_shake /= DATA

  ASSERT NOT verbose REPORT "Acking the zero length in packet"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

END clear_feature;


--------------------------------------------------------------------------------
--
-- Procedure: set_diag_desc
--
-- Parameters: breq           -- The diagnostic set request type
--                               Valid values include:
--                                     0 - set status register
--                                     2 - set endpoint register
--                                     4 - set memory
--             wval           -- The value to write to the status or endpoint
--                               register.
--             wind           -- The address of the memory or endpoint register
--             wlen           -- The length of the data packet to follow. Zero
--                               for set status and set endpoint. Equal to the
--                               byte count for set memory.
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit packet data
--
-- Description: This procedure is used to perform a vendor specific set
-- descriptor USB device request. When used in conjunction with VAutomation's
-- VUSB code, Diagnostic test information can be performed during simulations.
-- This is useful to set values in the VUSB status register, endpoint control
-- registers, or in memory locations within the device being simulated. This
-- information can be set by the behavioral host controller by performing
-- a set_diag_desc. This allows the user to create powerful test procedures
-- to set diagnostic information in the target device. The set_diag_desc
-- is used extensively in the Peripheral Silicon USB Compliance Checklist in
-- the behavioral host controller. The breq parameter is assigned to the
-- bRequest field of the USB device request. The VUSB code running on the V8
-- is designed to decode only SET_STATUS, SET_EP_CTL, and SET_MEM requests.
-- So legal values of breq are 0, 2, and 4. The wval parameter is assigned to
-- the wValue field of the USB device request and contains the value to write
-- to the VUSB status or endpoint register. The wind parameter is assigned to
-- the wIndex field of the USB device request and contains the starting address
-- in memory for a SET_MEM request or the address of the endpoint register for
-- a SET_EP_CTL request. The wlen parameter is assigned to the wLength field
-- of the USB device request and contains the number of bytes to write to
-- memory for a SET_MEM request. For SET_STATUS or SET_EP_CTL requests it is
-- set to 0.
--
--------------------------------------------------------------------------------

PROCEDURE   set_diag_desc(
  CONSTANT breq       : IN    integer;   -- brequest field
  CONSTANT wval       : IN    integer;   -- wValue field
  CONSTANT wind       : IN    integer;   -- wIndex field
  CONSTANT wlen       : IN    integer    -- wLength field
  ) IS

VARIABLE   retry_count : integer;        -- count of retrys due to bus time out
VARIABLE   temp_vec    : std_logic_vector(15 DOWNTO 0);-- temp variable for 16 fields
VARIABLE   temp_array  : byte_array(0 TO 7); -- tempory storage for write data
VARIABLE   sdd_i           : integer;            -- loop index
BEGIN
  -- save data in case we need to write it.
  FOR sdd_i IN 0 TO 7 LOOP
    temp_array(sdd_i) := hc_pckt_data(sdd_i);
  END LOOP;  -- sdd_i IN 0 TO 7

  -- assemble a set descriptor  packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#40#,8); -- bmRequestType - set vendor
  hc_pckt_data(1) := conv_std_logic_vector(breq,8) AND "11111110";   -- bREquest:
  temp_vec := conv_std_logic_vector(wval,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wind,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wlen,16);   -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT NOT verbose  REPORT "Transmit setup packet with set diag descriptor request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  IF (breq = 4) THEN       -- if this request writes a memory block
    -- restore the write data
    FOR sdd_i IN 0 TO 7 LOOP
      hc_pckt_data(sdd_i) := temp_array(sdd_i);
    END LOOP;  -- sdd_i IN 0 TO 7

    hand_shake := nak_hs;
    ASSERT NOT verbose REPORT "Send an out token and the data block." SEVERITY NOTE;
    WHILE hand_shake /= data_hs LOOP
      -- send an out token
      token_packet(OUT_PID, device_address, endpt => 0);
      ASSERT NOT verbose REPORT "send the out data packet" SEVERITY NOTE;
      -- send the tx packet data with an OUT pid and a byte count of wlen
      data_out_packet(DATA1_PID, wlen);
      handshake_in_packet (hand_shake);
      ASSERT ((hand_shake = ack_hs) OR NOT verbose)
        REPORT "Non Ack response, send data packet again for the in data packet."
        SEVERITY NOTE;
    END LOOP;                            -- hand_shake /= DATA
  END IF; -- breq = 4

  -- now turn the bus around to terminate the setup transfer
                             -- response packet
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an in token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    data_in_packet(DATA1_PID, 16#0#, 0, hand_shake, check);
    ASSERT (hand_shake = data_hs) OR NOT verbose
      REPORT "Recieved non-data packet. Check again for the in data packet."
      SEVERITY NOTE;
  END LOOP;                              -- hand_shake /= DATA

  ASSERT NOT verbose REPORT "Acking the zero length in packet"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);


END set_diag_desc;

--------------------------------------------------------------------------------
--
-- Procedure: get_diag_desc
--
-- Parameters: breq           -- The diagnostic get request type
--                               Valid values include:
--                                     1 - get status register
--                                     3 - get endpoint register
--                                     5 - get memory
--             wval           -- Should be set to zero
--             wind           -- The address of the memory or endpoint register
--             wlen           -- The length of the data packet to follow. Two
--                               for get status and get endpoint. Equal to the
--                               byte count for get memory.
--
-- Globals:    usb_clk        -- USB clock
--             device_address -- Current USB target address
--             hc_pckt_data   -- Transmit packet data
--             hc_rxpkt_data  -- Gets return data block.
--
-- Description: This procedure is used to perform a vendor specific get
-- descriptor USB device request. When used in conjunction with VAutomation's
-- VUSB code, Diagnostic test information can be performed during simulations.
-- This is useful to get values from the VUSB status register, endpoint control
-- registers, or memory locations within the device being simulated. This
-- information can be request by the behavioral host controller by performing
-- a get_diag_desc. This allows the user to create powerful test procedures
-- to extract diagnostic information from the target device. The get_diag_desc
-- is used extensively in the Peripheral Silicon USB Compliance Checklist in
-- the behavioral host controller. The breq parameter is assigned to the
-- bRequest field of the USB device request. The VUSB code running on the V8
-- is designed to decode only GET_STATUS, GET_EP_CTL, and GET_MEM requests.
-- So legal values of breq are 1, 3, and 5. The wval parameter is assigned to
-- the wValue field of the USB device request and should always be set to zero.
-- The wind parameter is assigned to the wIndex field of the USB device request
-- and contains the starting address in memory for a GET_MEM request or the
-- address of the endpoint register for a GET_EP_CTL request. The wlen
-- parameter is assigned to the wLength field of the USB device request and
-- contains the number of bytes to read from memory for a GET_MEM request.
-- For GET_STATUS or GET_EP_CTL requests it is set to 2. The data returned
-- is not checked, but is available via the hc_rxpkt_data data structure.
--
--------------------------------------------------------------------------------

PROCEDURE   get_diag_desc(
  CONSTANT breq       : IN    integer;   -- brequest field
  CONSTANT wval       : IN    integer;   -- wValue field
  CONSTANT wind       : IN    integer;   -- wIndex field
  CONSTANT wlen       : IN    integer    -- wLength field
  ) IS

VARIABLE   retry_count : integer;        -- count of retrys due to bus time out
VARIABLE   temp_vec    : std_logic_vector(15 DOWNTO 0);-- temp variable for 16 fields
VARIABLE   temp_array  : byte_array(0 TO 7); -- tempory storage for write data
VARIABLE   gdd_i           : integer;            -- loop index
BEGIN
  -- save data in case we need to write it.
  FOR gdd_i IN 0 TO 7 LOOP
    temp_array(gdd_i) := hc_pckt_data(gdd_i);
  END LOOP;  -- gdd_i IN 0 TO 7

  -- assemble a get descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#C0#,8); -- bmRequestType - get vendor
  hc_pckt_data(1) := conv_std_logic_vector(breq,8) OR "00000001";   -- bREquest:
  temp_vec := conv_std_logic_vector(wval,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wind,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(wlen,16);   -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT terse  REPORT "Transmit setup packet with get diag descriptor request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- get the return data
  -- now turn the bus around to recieve the descriptor

  ASSERT NOT verbose REPORT "Send an in token to receive the descriptor." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    data_in_packet(DATA1_PID, wlen, 0, hand_shake, no_check);
  END LOOP; -- hand_shake /= DATA

  ASSERT NOT verbose REPORT "Acking the descriptor block"
    SEVERITY NOTE;
  handshake_out_packet (ACK_PID);

  -- now turn the bus around to terminate the setup transfer
  hand_shake := nak_hs;
  ASSERT NOT verbose REPORT "Send an out token to turn the bus around." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 0);

    ASSERT NOT verbose REPORT "send a zero length data packet" SEVERITY NOTE;
      data_out_packet(DATA1_PID,16#0#);


    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;   --  hand_shake /= ack_hs

END get_diag_desc;

--------------------------------------------------------------------------------
--
-- Procedure: reset_test
--
-- This procedure attempts to test the reset reception in the target by
-- starting several transactions and transfers, and then terminating them
-- mid-steam through the assertion of the USB reset signalling.
--------------------------------------------------------------------------------

PROCEDURE reset_test
   IS

VARIABLE pid      : integer;             -- PID
VARIABLE addr     : integer;             -- USB destination address
VARIABLE bus_idle : boolean;             -- indication that the bus is idle
VARIABLE temp : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE temp2 : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing
VARIABLE hand_shake : hand_shake_type;
VARIABLE local_byte_cnt, index, rst_i : integer;

BEGIN
  addr     := 0;         -- initialize USB destination address to zero
  pid     := SETUP_PID; -- initialize the token paket PID
  -----------------------------------------------------------------------------
  -- Clear all the bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- After an initial reset get bus in the middle of a token then assert the
  -- reset signalling
  -----------------------------------------------------------------------------

  -- extend duration of usb_reset to 21 usec since usb_sie input clock in low
  -- speed device mode runs at 1/8th of hispeed device mode.
  --ASSERT terse REPORT
  --  "Test 2.5us reset detection."
  --  SEVERITY NOTE;
  --usb_reset(3000 ns);                     -- hit the USB reset
  ASSERT terse REPORT
    "Test 21us reset detection."
    SEVERITY NOTE;
  usb_reset(21 us);

  --WAIT FOR 500000 ns;                     -- 500 us - wait for software to recover
  -- double delay for the low speed device case
  WAIT FOR 1 ms;

  --  see if the device saw the reset.
  get_diag_desc(breq => 1, wval => 16#ffff#, wind => 0, wlen => 2);

  ASSERT (hc_rxpkt_data(0) = "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

  ASSERT ((hc_rxpkt_data(1) AND "00000010") = "00000010") REPORT
    "Target did not detect USB reset."
    SEVERITY FAILURE;

  --mnp
  test_progress <= 16#11011#;

  -- Clear all the bits in the Diagnostic register of the target device.
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Start a token packet.
  -- Make sure the bus is idle by checking for 16 consecutive J states.
  -----------------------------------------------------------------------------

  -- extend duration of usb_reset to 21 usec since usb_sie input clock in low
  -- speed device mode runs at 1/8th of hispeed device mode.
  --ASSERT terse REPORT
  --  "Test 2.5us reset detection."
  --  SEVERITY NOTE;

  ASSERT terse REPORT
    "Test 21us reset detection in the middle of a packet."
    SEVERITY NOTE;

  -- Make sure the bus is idle by checking for 16 consecutive J states.
  rst_i := 0;
  WHILE (rst_i < 16) LOOP -- Tx sync
    WAIT UNTIL usb_clk'event AND usb_clk = '1';-- Wait for rising edge
    IF usb_state_of(dplus,dminus) /= J THEN
      rst_i := 0;
    ELSE
      rst_i := rst_i +1;
    END IF;
  END LOOP;

  send_sync(data_history); -- Send sync field

  temp := CONV_STD_LOGIC_VECTOR(pid,32); -- Convert integer pid to std_logic_vector
  temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  FOR rst_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(rst_i), data_history);
  END LOOP;

  temp := CONV_STD_LOGIC_VECTOR(addr,32); -- Convert integer addr to
                                          -- std_logic_vector
  temp2(6 DOWNTO 0) := temp(6 DOWNTO 0);
  FOR rst_i IN 0 TO 4 LOOP -- Tx addr
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_addr; -- Set host controller state
    bit_stuff(temp(rst_i), data_history);
  END LOOP;

  -- interrupt the address portion of this token with a reset signal.
  -- extend duration of usb_reset to 21 usec since usb_sie input clock in low
  -- speed device mode runs at 1/8th of hispeed device mode.
  --usb_reset(3000 ns);
  usb_reset(21 us);

  --WAIT FOR 500000 ns;               -- 500 us - wait for software to recover
  --double delay for the low speed device case
  WAIT FOR 1 ms;

  --  see if the device saw the reset.
  get_diag_desc(breq => 1, wval => 16#ffff#, wind => 0, wlen => 2);

  -- Omit this ASSERT since errors may occur due to the fact that you are
  -- doing a usb_reset in the middle of a token packet.
  --ASSERT (hc_rxpkt_data(0) = "00000000") REPORT
  --  "errors detected by target."
  --  SEVERITY FAILURE;

  ASSERT ((hc_rxpkt_data(1) AND "00000010") = "00000010") REPORT
    "Target did not detect USB reset."
    SEVERITY FAILURE;

  --mnp
  test_progress <= 16#11012#;

  -- Clear all the bits in the Diagnostic register of the target device.
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- OK now lets send a setup transaction but reset in the middle of the setup
  -- data packet.
  -----------------------------------------------------------------------------

  -- extend duration of usb_reset to 21 usec since usb_sie input clock in low
  -- speed device mode runs at 1/8th of hispeed device mode.
  --ASSERT terse REPORT
  --  "Test 2.5us reset detection in the middle of a setup transaction."
  --  SEVERITY NOTE;
  ASSERT terse REPORT
    "Test 21us reset detection in the middle of a setup transaction."
    SEVERITY NOTE;
  -- restart the setup token
  token_packet (SETUP_PID, device_address, endpt => 0);
  -- assemble a set address packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#05#,8); -- bREquest: Set address
  hc_pckt_data(2) := conv_std_logic_vector(16#55#,8); -- wValue: address = 55
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#00#,8); -- wLength: 0
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);
  -- send the tx packet data with an OUT pid and a byte count of 8
  --  data_out_packet(DATA0_PID,16#8#);
  local_byte_cnt := 6;
  index := 0; -- Init index

  send_sync(data_history); -- Send sync field

  temp := CONV_STD_LOGIC_VECTOR(pid,32); -- Convert integer pid to
                                         -- std_logic_vector
  temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  FOR rst_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(rst_i), data_history);
  END LOOP;

  -- Transmit the first 6 data bytes of this packet.
  WHILE (local_byte_cnt > 0) LOOP
    temp(7 DOWNTO 0) := hc_pckt_data(index); -- Get byte from packet data
    local_byte_cnt := local_byte_cnt - 1; -- Dec byte counter
    index := index + 1; -- Inc index
    FOR rst_i IN 0 TO 7 LOOP -- Tx addr
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      hc_state <= tx_data; -- Set host controller state
      bit_stuff(temp(rst_i), data_history);
    END LOOP; -- End for loop
  END LOOP; -- End while loop
  -- start the next byte
  temp(7 DOWNTO 0) := hc_pckt_data(index); -- Get byte from packet data
  FOR rst_i IN 0 TO 5 LOOP -- Tx addr
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_data; -- Set host controller state
    bit_stuff(temp(rst_i), data_history);
  END LOOP; -- End for loop

  -- then interrupt it mid-stream with a usb reset.
  -- extend duration of usb_reset to 21 usec since usb_sie input clock in low
  -- speed device mode runs at 1/8th of hispeed device mode.
  --usb_reset(3000 ns);
  usb_reset(21 us);

  --WAIT FOR 500000 ns;               -- 500 us - wait for software to recover
  --double delay for the low speed device case
  WAIT FOR 1 ms;

  --  see if the device saw the reset.
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -- Omit this ASSERT since errors may occur due to the fact that you are
  -- doing a usb_reset in the middle of a token packet.
  -- Asserting reset in the middle of a transaction may cause errors
  --ASSERT (hc_rxpkt_data(0) = "00000000") REPORT
  --  "errors detected by target."
  --  SEVERITY FAILURE;

  ASSERT ((hc_rxpkt_data(1) AND "00000010") = "00000010") REPORT
    "Target did not detect USB reset."
    SEVERITY FAILURE;

  -- Clear all the bits in the Diagnostic register of the target device.
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  --mnp
  test_progress <= 16#11013#;

END reset_test;

--------------------------------------------------------------------------------
--
-- Procedure: resume_test
--
-- This procedure attempts to test the suspend and resume operation of the
-- target.  The test is dependent on diagnostic hooks in the target USB driver
-- code to observe the suspend and resume operation and report them back to the
-- test bench process.
--
--------------------------------------------------------------------------------

PROCEDURE resume_test(
  CONSTANT test_num   : IN    integer
  ) IS

VARIABLE bus_idle : boolean;             -- indication that the bus is idle
VARIABLE temp : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE temp2 : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing
VARIABLE hand_shake : hand_shake_type;
VARIABLE temp_i, local_byte_cnt, index : integer;

BEGIN

  -----------------------------------------------------------------------------
  -- Clear the suspend bit in Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  test_progress <= test_num + 1;
  ASSERT terse REPORT
    "Test suspend mode."
    SEVERITY NOTE;
  -----------------------------------------------------------------------------
  -- Place the target in suspend mode by maintaining idle signalling for 3ms
  -----------------------------------------------------------------------------
  -- assert the idle (j-state) signalling.
  j_state;
  sof_enable <= false;  -- Stop SOF packets on the the bus
  WAIT FOR 3 ms;

  sof_enable <= true;  -- Resume the SOF packet traffic
  test_progress <= test_num + 2;
  -----------------------------------------------------------------------------
  -- Resume the target by any transition out of the J-state.
  -----------------------------------------------------------------------------
  -- the act of reading the status register should pull the target out of
  -- suspend mode, and return status that indicates the the target had been
  -- suspended.
  --  see if the device saw the reset.
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);
  test_progress <= test_num + 3;
  ASSERT (hc_rxpkt_data(0) = "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

  ASSERT ((hc_rxpkt_data(1) AND "00000001") = "00000001") REPORT
    "Target did not go into suspend state."
    SEVERITY FAILURE;

  -- Clear all the bits in the Diagnostic register of the target device.
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  ASSERT terse REPORT
    "Test suspend & resume mode."
    SEVERITY NOTE;

-------------------------------------------------------------------------------
-- Place the target in suspend mode by maintianing idle signalling for 3ms
-------------------------------------------------------------------------------
  -- assert the idle (j-state) signalling.
  j_state;
  sof_enable <= false;  -- Stop SOF packets on the the bus
  WAIT FOR 3 ms;

-------------------------------------------------------------------------------
-- Resume the target using the resume signaling.
-------------------------------------------------------------------------------
  usb_resume(20 ms); -- 20 ms = T_DRSMDN (USB Spec1.1 Rev 7.1.7.5)

  sof_enable <= true;  -- Resume the SOF packet traffic

-------------------------------------------------------------------------------
-- Read the target status to confirm suspend and resume
-------------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

-------------------------------------------------------------------------------
-- Check the diagnostic register return data to insure that the target had gone
-- into suspend state.
-------------------------------------------------------------------------------

  ASSERT ((hc_rxpkt_data(1) AND "00000001") = "00000001") REPORT
    "Target did not go into suspend state."
    SEVERITY FAILURE;

END resume_test;

--------------------------------------------------------------------------------
--
-- Procedure: crc_bitstuff_test
--
-- This procedure tests the CRC generation and checking and bit stuffing and
-- bit stuff removal.  This includes stuff bits within the CRC field and a bit
-- stuff bit as the last bit of the packet.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE   crc_bitstuff_test

  IS

  VARIABLE wval      : integer;
  VARIABLE wval_tmp  : std_logic_vector(15 DOWNTO 0);

BEGIN
  ASSERT false REPORT "Starting crc and bitstuff test." SEVERITY NOTE;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as a bidirectional Bulk endpoint
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- Set CRC and bit stuff checking packet.  This packet generates a bit
  -- stuff after the last bit of the packet.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#04#,8);

  hand_shake := nak_hs;
  --  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    data_out_packet(DATA0_PID,3);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  hand_shake := nak_hs;

  --  ASSERT false REPORT "Wait for the echo'ed packet and check it." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 3, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

END crc_bitstuff_test;


--------------------------------------------------------------------------------
--
-- Procedure: bulk_echo_test
--
-- This procedure sends and recieves a bulk data transaction.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------

PROCEDURE   bulk_echo_test (
     CONSTANT endpt : integer;
     CONSTANT dlength : integer;
     CONSTANT dpat : data_patterns;
     CONSTANT dstart : integer
   )  IS

VARIABLE wval      : integer;
VARIABLE wval_tmp  : std_logic_vector(15 DOWNTO 0);

BEGIN

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Configure the indicated endpoint as an echo enabled bulk out endpoint for
  -- packet lengths of length
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => endpt, wlen => 0);

  -- wait for the driver to configure the iso channel.
  WAIT FOR 200000 ns ;                   -- 200 us
  -----------------------------------------------------------------------------
  -- Send a "length" byte data packet to endpoint 0.
  -----------------------------------------------------------------------------
  build_hc_packet(dlength, dstart, dpat, seed);

  --  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => endpt);

    data_out_packet(DATA0_PID,dlength);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  --  ASSERT false REPORT "Wait for the echo'ed packet and check it." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => endpt);

    data_in_packet(DATA0_PID, dlength, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

END bulk_echo_test ;


--------------------------------------------------------------------------------
--
-- Procedure: iso_echo_test
--
-- This procedure sets up and endpoint in the target to echo isochronous data
-- packets then sends and receives one packet of a specified lenght and data
-- pattern.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------

PROCEDURE   iso_echo_test (
     CONSTANT endpt : integer;
     CONSTANT dlength : integer;
     CONSTANT dpat : data_patterns;
     CONSTANT dstart : integer;
     CONSTANT bogus_hndshk : integer; -- If this value is not "0000" a bugus
                                      -- handshake packet is sent after the in
                                      -- data is received.
     CONSTANT sof_wait : boolean
   )  IS
VARIABLE ist_done  : boolean;
VARIABLE wval      : integer;
VARIABLE wval_tmp  : std_logic_vector(15 DOWNTO 0);
VARIABLE in_endpt  : integer;
VARIABLE tmp_endpt : std_logic_vector(3 DOWNTO 0);
BEGIN

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Configure the indicated endpoint as an echo enabled iso out endpoint for
  -- packet lengths of length
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -- set the echo in endpoint number to the other endpoint in the echo pair.
  tmp_endpt := conv_std_logic_vector(endpt,4);
  tmp_endpt := tmp_endpt(3 DOWNTO 1) & tmp_endpt(0);
  in_endpt  := conv_integer(unsigned(tmp_endpt));

  -- wait for the driver to configure the iso channel.
  WAIT FOR 200000 ns ;                   -- 200 us

  -----------------------------------------------------------------------------
  -- Send a "length" byte data packet to the indicated endpoint.
  -----------------------------------------------------------------------------
  build_hc_packet(dlength, dstart, dpat, seed);
  --  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;

  IF sof_wait THEN
    WAIT UNTIL sof_request'event AND sof_request = '1';
  END IF;

  token_packet (OUT_PID, device_address, endpt);

  data_out_packet(DATA0_PID,dlength);


  -- We don't know exactly how long the diagnostic driver will take to set up
  -- the echo'ed data, so we will ask for it untill we get a non-zero length
  -- packet back.  If we asked for a zero length packet, we will only ask once.

  ist_done := false;
  usb_watch_dog <= '0';
  usb_watch_dog <= TRANSPORT '1' AFTER 1500000 ns; -- 1.5ms
  WAIT FOR 1 ns;                         -- insure that the signal has settled
                                         -- before it is tested by the while loop.

  WHILE (NOT ist_done) AND (usb_watch_dog = '0') LOOP

    IF sof_wait THEN
      WAIT UNTIL sof_request'event AND sof_request = '1';
    ELSE
      -- give the core time to recover, and software time to setup the Tx BDT
      WAIT FOR 10000 ns;                     -- 10 us
    END IF;

    ASSERT verbose REPORT "Get the echo'ed packet and check it." SEVERITY NOTE;
    token_packet (IN_PID, device_address, in_endpt);

    data_in_packet(DATA0_PID, dlength, 0, hand_shake, iso_check);

    IF bogus_hndshk /= 0 THEN         -- this is here to support iso
      handshake_out_packet(bogus_hndshk);  -- transfer robustness testing
    END IF;

    IF dlength = 0 OR hc_rxpkt_length /= 0 THEN
      ist_done := true;
    END IF;

  END LOOP;

  ASSERT (usb_watch_dog = '0') REPORT
    "ISO data packet was not echoed" SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;


END iso_echo_test ;


--------------------------------------------------------------------------------
--
-- Procedure: min_max_data_test(
--
-- This procedure sends a zero length and a max (1023 byte) length packet.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE  min_max_data_test(
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

BEGIN
  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Send a zero length data packet.
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Test a zero length data packet"
    SEVERITY NOTE;

  bulk_echo_test(endpt => 2, dlength => 0, dpat => INC, dstart => 0);

  -----------------------------------------------------------------------------
  -- Send a 1023 isochronous byte data packet only if not a low speed device.
  -----------------------------------------------------------------------------
  IF lsdev = 0 THEN
    ASSERT terse REPORT
      "Test a 1023 byte length data packet"
      SEVERITY NOTE;
    test_progress <= test_num + 5;
    iso_echo_test(endpt => 2, dlength => 1023, dpat => INC, dstart => 0,
                  bogus_hndshk => 0, sof_wait => true);
  ELSE
    ASSERT terse REPORT
      "Test a 8 byte length data packet"
      SEVERITY NOTE;
    test_progress <= test_num + 5;
    iso_echo_test(endpt => 2, dlength => 8, dpat => INC, dstart => 0,
                  bogus_hndshk => 0, sof_wait => true);
  END IF;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

END min_max_data_test;

--------------------------------------------------------------------------------
--
-- Procedure: bto_test:
--
-- This procedure tests the turn around time of the target and the tolerance of
-- the bus time out counter in the target.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE  bto_test(
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

VARIABLE wval      : integer;
VARIABLE wval_tmp  : std_logic_vector(15 DOWNTO 0);

BEGIN
  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Configure endpoint 2 as an echo enabled bulk out endpoint for
  -- packet lengths of length
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- Send a zero length data packet after delaying
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Send out data with maximum valid delay" SEVERITY NOTE;
  test_progress <= test_num + 1;
  hand_shake := nak_hs;
  --  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    -- wait as long as allowed without incurring a bto.
    WAIT FOR usb_bit_time * 13;          -- there is one clock on the end of
                                         -- the token_packet and one clock on
                                         -- the begining of the data outpacket
                                         -- so the total is 15 bit times.


    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  --  ASSERT false REPORT "Wait for the echo'ed packet and check it." SEVERITY NOTE;
  test_progress <= test_num + 2;
  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 0, 0, hand_shake, check); -- data in packet will
                                                     -- report if the minumum
                                                     -- or maximum turnaround
                                                     -- times have been exceeded

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

  test_progress <= test_num + 4;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Send a zero length data packet after a gap that exceeds the bto max time.
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Check that an out data with minumum invalid delay is rejected"
    SEVERITY NOTE;

  hand_shake := nak_hs;

  token_packet (OUT_PID, device_address, endpt => 2);

  -- wait as short as allowed while guaranteing a bto.
  WAIT FOR usb_bit_time * 16;          -- there is one clock on the end of
                                       -- the token_packet and one clock on
                                       -- the begining of the data outpacket
                                       -- so the total is 18 bit times.

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT (hand_shake = bto_hs) REPORT
    "Returned a handshake when idle time after token packet exceeded BTO time."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "00010000") = "00010000") REPORT
    "target failed to detet bus time out."
    SEVERITY FAILURE;

  test_progress <= test_num + 5;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -- this test may leave the target waiting for a repeat of the dat packet, but
  -- it should clear by the next token.
END bto_test;

--------------------------------------------------------------------------------
--
-- Procedure: data_toggle_test:
--
-- This procedure tests the data toggle sequencing of the target.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE  data_toggle_test(
  CONSTANT test_num   : IN    integer       -- PID
  ) IS

VARIABLE wval      : integer;
VARIABLE wval_tmp  : std_logic_vector(15 DOWNTO 0);

BEGIN
  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
--  set_diag_desc(breq => 0, wval => 0, wind => 0, wlen => 0);
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);
  dtoggle_in <= '1';
  dtoggle_out <= '0';

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as a bidirectional Bulk endpoint
  -----------------------------------------------------------------------------
  -- Note: need to set up endpoint 2 since you can't receive data back
  --       from endpoint 0.
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- Send a ClearFeature(ENDPOINT_HALT) to endpoint 2, this should reset the
  -- data toggle to DATA0.  See section 9.4.5 of USB 1.1 (pg 192) Here, I'm
  -- assuming we are in device "Configured" State. See 9.4.1 USB 1.1
  -----------------------------------------------------------------------------
  clear_feature(rtype => 2, wval => 0, wind => 2, test_num => 16#500#);

  -----------------------------------------------------------------------------
  -- Verifiy that Data packets with a data toggle of 0 are accepted.
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Send a bulk data packet with a data toggle of 0.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 1;

  hc_pckt_data(0) := conv_std_logic_vector(16#be#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#ef#,8);

  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    data_out_packet(DATA0_PID,2);  --endpt2 OUT dtggle = 1;

    handshake_in_packet(hand_shake);
    -- hst dtggle_out=1

  END LOOP; -- hand_shake /= ack_hs

  -----------------------------------------------------------------------------
  -- Previous Bulk Data Packet should set host & device data toggle to DATA1.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 2;
  -----------------------------------------------------------------------------
  -- read back the data previously sent to endpoint 2 and verify data & pid.
  -- the received PID should indicate a data toggle of 0.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#be#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#ef#,8);

--  dtoggle_in <= '0';   -- clear dtoggle_in to start IN transaction
  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 2, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  -----------------------------------------------------------------------------
  -- Let this in transfer time out instead of ACK'ing it, and verify that the
  -- device transmit data toggle is not toggled if the packet is not ACK'ed
  -----------------------------------------------------------------------------
  test_progress <= test_num + 3;

  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 2, 0, hand_shake, check);
    -- endpt2 IN dtgle=1;

  END LOOP; -- hand_shake /= data_hs


  handshake_out_packet(ACK_PID);
  -- host dtgle=1

  -----------------------------------------------------------------------------
  -- The deviceis now expecting a data toggle of 1.  Send a data toggle of 0
  -- again and verify that it was not accepted by the device.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 4;

  hc_pckt_data(0) := conv_std_logic_vector(16#de#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#ad#,8);

  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    data_out_packet(DATA0_PID,2);  --endpt2 OUT dtgle=1;

    handshake_in_packet(hand_shake);
    --hst dtoggle_in=0

  END LOOP; -- hand_shake /= ack_hs

  -----------------------------------------------------------------------------
  -- Run a set address setup transaction.  This ensures that the software has
  -- finished processing on all previous transfers.
  -----------------------------------------------------------------------------
  set_address(16#55#,0);

  -----------------------------------------------------------------------------
  -- Now go ask for the data that was sent with the wrong data toggle.  We
  -- expedt that because that packet was rejected that the transaction will be
  -- NAK'ed.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 5;

  -----------------------------------------------------------------------------
  -- Read back from endpoint 2 and verify that the packet was
  -- actually dropped.
  -----------------------------------------------------------------------------
  -- get the data from the first echo buffer. (from the 4th transfer above)

  hand_shake := nak_hs;

  token_packet (IN_PID, device_address, endpt => 2);

  data_in_packet(DATA1_PID, 2, 0, hand_shake, check);
    -- endpt2 IN dtgle=0; hst dtgle=1
  assert hand_shake = nak_hs
    report "Packet with wrong data toggle was not rejected" severity FAILURE;

-----------------------------------------------------------------------------
-- Read the target status to check any error conditions
-----------------------------------------------------------------------------
get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

-----------------------------------------------------------------------------
-- Check the status of the target for any error reports.
-----------------------------------------------------------------------------
status_rg := hc_rxpkt_data(0);
ASSERT ((status_rg  AND "11001111")= "00000000") REPORT
  "errors detected by target."
  SEVERITY FAILURE;



END data_toggle_test;


--------------------------------------------------------------------------------
--
-- Procedure: data_toggle_independence_test:
--
-- This procedure tests the data toggle sequence bit of different endpoints
-- within the same device are independent.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE  data_toggle_independence_test

  IS

  VARIABLE wval_tmp : std_logic_vector(15 DOWNTO 0);
  VARIABLE wval     : integer;

BEGIN
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Initialize endpoint 2 as a bulk echo endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);


  -----------------------------------------------------------------------------
  -- Send a bulk data packet followed by a second data packet with the same
  -- sequence bit but different data and verify that the second data packet was
  -- descarded.
  -----------------------------------------------------------------------------

  hc_pckt_data(0) := "10111110";         -- 0xbeef
  hc_pckt_data(0) := "11101111";

  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 0);

    data_out_packet(DATA0_PID,2);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  -- now send the data packet again with the same data toggle sequence
  -- bit, as if we did not receive the previous ack invert the data so
  -- the target behavior is observable. A non-control endpoints data
  -- toggle bit is reset to zero by sending a
  -- ClearFeature(Endpoint,Halt).

  hc_pckt_data(0) := "01000001";         -- not (0xbeef)
  hc_pckt_data(0) := "00010000";

  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 0);

    data_out_packet(DATA0_PID,2);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  -- check that the second data packet was rejected, and the data toggle
  -- sequence still agrees
  -- also check that the data toggle bit of the second endpoit remained zero
  -- even though the data toggle bit on the first endpoint should still be one.

  hc_pckt_data(0) := "11011110";         -- 0xdead
  hc_pckt_data(0) := "10101101";

  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 0);

    data_in_packet(DATA0_PID, 2, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -- on the second bulk echo packet do a simple echo test both of these
  -- endpoints should have their data toggle bits set to 0

  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    data_out_packet(DATA0_PID,2);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  -- check that the data toggle bit of the second endpoit remained zero
  -- even though the data toggle bit on the first endpoint should still be one.

  hc_pckt_data(0) := "10111110";         -- 0xbeef
  hc_pckt_data(0) := "11101111";

  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 2, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

END data_toggle_independence_test;


--------------------------------------------------------------------------------
--
-- Procedure: tx_pid_test
--
-- This procedure tests the PID generated by the VUSB
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  Allows the host to
-- configure endpoints and echo's OUT DATA transaction recieved by the VUSB SIE
-- and makes them available for subsequent IN data transactions.
--
-- --------------------------------------------------------------------------------


PROCEDURE tx_pid_test (
  CONSTANT test_num : integer
  ) IS
  VARIABLE wval            : integer; -- wValue for set diag descriptor
  VARIABLE wval_tmp        : std_logic_vector(15 DOWNTO 0); -- wValue tmp
                                                            -- variable
BEGIN

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);


  -----------------------------------------------------------------------------
  -- Run the get the configuration descriptor test it requrires an ACK, DATA0
  -- and DATA1 responces from the target to complete successfully
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Test the ACK, Data0 and Data1 PIDs."
    SEVERITY NOTE;

  get_config_desc(test_num);
  -----------------------------------------------------------------------------
  -- Setup endpoint 2 to return stall PID's
  -----------------------------------------------------------------------------

  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '1' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- send the crc_bitstuff packet to a stalled endpoint to get the stall PID
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Test the Stall PID."
    SEVERITY NOTE;

  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,3);

  handshake_in_packet(hand_shake);

  ASSERT (hand_shake = stall_hs) REPORT
    "A stalled endpoint did not return a STALL handshake"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- send the crc_bitstuff packet to a disabled endpoint to get the NAK PID
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Test the NAK PID."
    SEVERITY NOTE;
  -----------------------------------------------------------------------------
  -- Setup endpoint 2 for bulk packet echoing.
  -----------------------------------------------------------------------------

  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- Now Force owns 0 for all endpoints (except 0)
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 6, wval => 1, wind => 0, wlen => 0);

  token_packet (IN_PID, device_address, endpt => 2);

  data_in_packet(DATA0_PID, 0, 0, hand_shake, check);

  ASSERT hand_shake = nak_hs REPORT "Not ready endpoint did not NAK in token."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Restore normal owns operation for all endpoints
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 6, wval => 0, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Setup endpoint 2 to to ignore IN and OUT tokens.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '0' & '0' & '0' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  ASSERT terse REPORT "Test No Handshake returned."
    SEVERITY NOTE;

  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,3);

  handshake_in_packet(hand_shake);

  ASSERT (hand_shake = bto_hs) REPORT
    "A disabled endpoint did not Bus Time Out when sent an out token."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;


END tx_pid_test;


--------------------------------------------------------------------------------
--
-- Procedure: handshake_precedence_test
--
--
-- This procedure tests the PID generated by the VUSB
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  Allows the host to
-- configure endpoints and echo's OUT DATA transaction recieved by the VUSB SIE
-- and makes them available for subsequent IN data transactions.
--
-- --------------------------------------------------------------------------------


PROCEDURE handshake_precedence_test(
  CONSTANT test_num : integer
  ) IS
  VARIABLE wval                : integer; -- wValue
  VARIABLE wval_tmp            : std_logic_vector(15 DOWNTO 0); -- wValue tmp
BEGIN

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  ASSERT false REPORT "Clear Error status." SEVERITY NOTE;
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Setup endpoint 2 to return stall PID's
  -----------------------------------------------------------------------------
  ASSERT false REPORT "Setup endpoint 2 to return the stall PID." SEVERITY NOTE;

  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '1' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined

  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);


  -----------------------------------------------------------------------------
  -- Send a zero length data packet to endpoint 0 to set up the return echo
  -- packet.
  -----------------------------------------------------------------------------
  ASSERT  terse REPORT "Send a zero length echo packet to endpoint 0."
    SEVERITY NOTE;
  force_crc5_error := false;

  hand_shake := nak_hs;
  start_time := now;

  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 0);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

  END LOOP; -- hand_shake /= ack_hs

  test_progress <= test_num + 1;
  -----------------------------------------------------------------------------
  -- Test the IN response handshake precedence.
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Send an in token with bad crc5 to the stalled, disabled and regular
  -- endpoints.  All of the endpoints should return nothing (BTO).
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Send an in token packet to stalled endpoint 2 with crc5 error."
    SEVERITY NOTE;
  force_crc5_error := true;

  -- send in token with bad crc5 to stalled endpoint
  token_packet (IN_PID, device_address, endpt => 2);

--  data_in_packet(DATA1_PID, 0, 0, hand_shake, no_check);
  hand_shake := nak_hs;
  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT "stalled endpoint did not BTO on bad token"
    SEVERITY FAILURE;

  test_progress <= test_num + 2;
  -----------------------------------------------------------------------------
  -- Send a good in token to the stalled endpoint it should return STALL.
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Send an in token packet to stalled endpoint 2."
    SEVERITY NOTE;

  force_crc5_error := false;

  token_packet (IN_PID, device_address, endpt => 2);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT "stalled endpoint did not return stall handshake"
    SEVERITY FAILURE;

  test_progress <= test_num + 3;
  -----------------------------------------------------------------------------
  -- Send an out token with bad crc5 to the stalled, disabled and regular
  -- endpoints.  All of the endpoints should return nothing (BTO).
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- send out token with bad crc5 to stalled endpoint
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Send an out token packet to stalled endpoint 2 with crc5 error."
    SEVERITY NOTE;
  force_crc5_error := true;

  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT "stalled endpoint did not BTO on bad token"
    SEVERITY FAILURE;

  test_progress <= test_num + 4;

  -----------------------------------------------------------------------------
  -- Send a good out token to the stalled endpoint it should return STALL.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT "Send an out token packet to stalled endpoint 2."
    SEVERITY NOTE;

  force_crc5_error := false;

  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT "stalled endpoint did not stall handshake"
    SEVERITY FAILURE;

  test_progress <= test_num + 5;
  -----------------------------------------------------------------------------
  -- Setup endpoint 2 as enabled, but not ready
  -----------------------------------------------------------------------------

  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- send in token with bad crc5 to disabled endpoint
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Send an in token packet to disabled endpoint 2 with crc5 error."
    SEVERITY NOTE;

  force_crc5_error := true;

  token_packet (IN_PID, device_address, endpt => 2);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT "stalled endpoint did not BTO on bad token"
    SEVERITY FAILURE;

  test_progress <= test_num + 6;
  -----------------------------------------------------------------------------
  -- send out token with bad crc5 to not ready endpoint
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Send an out token packet to disabled endpoint 2 with crc5 error."
    SEVERITY NOTE;

  force_crc5_error := true;

  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT "not ready endpoint did not BTO on bad token"
    SEVERITY FAILURE;

  test_progress <= test_num + 7;
  -----------------------------------------------------------------------------
  -- Restore normal owns operation for all endpoints
  -----------------------------------------------------------------------------
  force_crc5_error := false;
  set_diag_desc(breq => 6, wval => 0, wind => 0, wlen => 0);


  -----------------------------------------------------------------------------
  -- send out token with bad crc5 to enabled
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Send an out token packet to enabled endpoint 2 with crc5 error."
    SEVERITY NOTE;

  force_crc5_error := true;

  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT "enabled endpoint did not BTO on bad token"
    SEVERITY FAILURE;

  test_progress <= test_num + 8;

  force_crc5_error := false;

  -----------------------------------------------------------------------------
  -- send in token with bad crc5 to enabled
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Send an in token packet to enabled endpoint 2 with crc5 error."
    SEVERITY NOTE;

  force_crc5_error := true;

  token_packet (IN_PID, device_address, endpt => 2);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT "endpoint did not BTO on bad token"
    SEVERITY FAILURE;

  test_progress <= test_num + 9;
  -----------------------------------------------------------------------------
  -- Send a good out token to the enabled endpoint it should eventually ACK.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Send an out token packet to enabled endpoint 2."
    SEVERITY NOTE;

  hand_shake := nak_hs;

  -- Initialize the watch dog timeout signal
  usb_watch_dog <= '0';
  usb_watch_dog <= TRANSPORT '1' AFTER WATCH_DOG;
  WAIT FOR 1 ns;                         -- insure that the signal has settled
                                         -- before it is tested by the while loop.

  force_crc5_error := false;


  WHILE hand_shake /= ack_hs AND usb_watch_dog = '0' LOOP
    ASSERT (hand_shake = nak_hs) REPORT "Enabled endpoint returned handshake" &
                                        "other than ACK or NAK."
      SEVERITY FAILURE;

    token_packet (OUT_PID, device_address, endpt => 2);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);


  END LOOP; -- hand_shake /= ack_hs

  ASSERT (usb_watch_dog = '0') REPORT "Target failed to ack out transaction."
    SEVERITY FAILURE;

  test_progress <= test_num + 16#0a#;
  -----------------------------------------------------------------------------
  -- Send a good in token to the enabled endpoint it should eventually return
  -- data.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Send an in token packet to enabled endpoint 2."
    SEVERITY NOTE;
  hand_shake := nak_hs;

  WHILE hand_shake /= data_hs AND usb_watch_dog = '0' LOOP
    ASSERT (hand_shake = nak_hs) REPORT "Enabled endpoint returned handshake" &
                                        "other than DATA or NAK."
      SEVERITY FAILURE;
    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 0, 0, hand_shake, check);

  END LOOP; -- hand_shake /= ack_hs

  ASSERT (usb_watch_dog = '0') REPORT "Target failed to return data packet."
    SEVERITY FAILURE;

  test_progress <= test_num + 16#0b#;
  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "11001101")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

  ASSERT ((status_rg AND "00000010")= "00000010") REPORT
    "CRC5 error not reported by target."
    SEVERITY FAILURE;

  ASSERT ((status_rg AND "00010000")= "00010000") REPORT
    "BTO error not reported by target."
    SEVERITY FAILURE;

  ASSERT ((hc_rxpkt_data(1) AND "00001000")= "00001000") REPORT
    "STALL handshake has not been detected by target."
    SEVERITY FAILURE;

  ----------------------------------------------------------------------
  -- complete reset to resynchronize software and hardware EVEN/ODD buffer
  -- pointers. If you don't do this, the next test, BST1, in checklist_enabled
  -- IF/THEN section fails.
  ----------------------------------------------------------------------
  usb_reset(21 us);
  set_address(16#7f#,test_num+16#c#);
  -- Move the device into the configured state by setting the configuration
  -- value to 1.
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => test_num+16#d#);

END handshake_precedence_test;

--------------------------------------------------------------------------------
--
-- Procedure: single_ended_test
--
-- This test will send an out token normally followed by a data packet sent
-- using single ended signalling.  If this packet is ignored a BTO will be
-- detected by the target.
--
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  Allows the host to
-- configure endpoints and echo's OUT DATA transaction recieved by the VUSB SIE
-- and makes them available for subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE single_ended_test
  IS
  VARIABLE wval_tmp        : std_logic_vector(15 DOWNTO 0); -- wValue tmp
BEGIN

  -----------------------------------------------------------------------------
  -- Clear the target error register
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Send an out token
  -----------------------------------------------------------------------------
  token_packet (OUT_PID, device_address, endpt => 3);

  -----------------------------------------------------------------------------
  -- Send a data packet single ended.
  -----------------------------------------------------------------------------
  force_single_ended := true;
  data_out_packet(DATA0_PID,0);
  force_single_ended := false;


  -----------------------------------------------------------------------------
  -- Check for a handshake (should BTO)
  -----------------------------------------------------------------------------
  handshake_in_packet(hand_shake);
  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore single ended signaling"
    SEVERITY FAILURE;

END single_ended_test;

--------------------------------------------------------------------------------
--
-- Procedure: hifreq_noise_test
--
-- This procedure injects hifreqency noise between the token and data packets
-- of an out transaction, and checks that the transaction completed
-- successfully.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for

-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE   hifreq_noise_test

  IS

  VARIABLE hfn_i    : integer;           -- loop counter
  VARIABLE tmp_vec  : std_logic_vector(31 DOWNTO 0);-- working vector for
                                                    -- random data
  VARIABLE wval     : integer; -- wValue
  VARIABLE wval_tmp : std_logic_vector(15 DOWNTO 0); -- wValue tmp
BEGIN

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Configure endpoint 2 as an echo enabled bulk out endpoint for
  -- packet lengths of length
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- Set CRC and bit stuff checking packet.  This packet generates a bit
  -- stuff after the last bit of the packet.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#04#,8);

  hand_shake := nak_hs;
--  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    hc_state <= tx_manu;
    FOR hfn_i IN 0 TO 300 LOOP               -- generate some high frequency noise
      WAIT FOR 2 ns;
      seed := rand(seed);
      tmp_vec := conv_std_logic_vector(seed,32);
      nrz_out(tmp_vec(0));
    END LOOP;                            -- for hfn_i in 0 to 300

    data_out_packet(DATA0_PID,3);

    handshake_in_packet(hand_shake);

    ASSERT hand_shake /= bto_hs REPORT
      "high frequency noise prior to packet caused BTO"
      SEVERITY FAILURE;

  END LOOP; -- hand_shake /= ack_hs

--  ASSERT false REPORT "Wait for the echo'ed packet and check it." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 3, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;


END hifreq_noise_test;


--------------------------------------------------------------------------------
--
-- Procedure: pll_test
--            test_num      -- base test number for test progress signal
--
-- This procedure repeats the crc_bitstuff test while margining the clock fast
-- and slow, and introducing clock jitter and phase distortions.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE   pll_test (
  CONSTANT test_num : integer
  )  IS

  VARIABLE wval     : integer; -- wValue
  VARIABLE wval_tmp : std_logic_vector(15 DOWNTO 0); -- wValue tmp

BEGIN
  clock_master_save <= clock_master;     -- save the current clock source so it
                                         -- can be restored.

  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Configure endpoint 2 as an echo enabled bulk out endpoint for
  -- packet lengths of length
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -----------------------------------------------------------------------------
  -- Set CRC and bit stuff checking packet.  This packet generates a bit
  -- stuff after the last bit of the packet.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#04#,8);

  -----------------------------------------------------------------------------
  -- Margin the clock fast;
  -----------------------------------------------------------------------------
  test_progress <= test_num + 1;
  clock_margin <= fast;
  ASSERT terse REPORT "Margin clock fast" SEVERITY NOTE;

  hand_shake := nak_hs;
  --  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    clock_master <= host_p0;              -- use the host clock to send
    token_packet (OUT_PID, device_address, endpt => 2);

    data_out_packet(DATA0_PID,3);

    handshake_in_packet(hand_shake);
    -- dtoggle_out = 1

    ASSERT (hand_shake /= bto_hs) REPORT
      "Target BTO's data packet when clock is margined fast."
      SEVERITY FAILURE;

  END LOOP; -- hand_shake /= ack_hs

  test_progress <= test_num + 2;
  ASSERT terse REPORT "Wait for the echo'ed packet and check it." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake /= data_hs LOOP

    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA0_PID, 3, 0, hand_shake, check);

    ASSERT (hand_shake /= bto_hs) REPORT
      "Target BTO's in token when clock is margined fast."
      SEVERITY FAILURE;

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);
  -- dtoggle_in = 1

  -----------------------------------------------------------------------------
  -- Margin the clock normal, but introduce phase distortions between each
  -- transfer.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 7;
  clock_margin <= normal;
  clock_jitter_time <= 0 ns;
  ASSERT terse REPORT "Margin clock normal phase shifts between packets"
    SEVERITY NOTE;

  hand_shake := nak_hs;
  --  ASSERT false REPORT "Send an out data token." SEVERITY NOTE;
  WHILE hand_shake /= ack_hs LOOP

    token_packet (OUT_PID, device_address, endpt => 2);

    clock_master <= host_p1;              -- use the host clock to send
--    data_out_packet(DATA0_PID,3);
    data_out_packet(DATA1_PID,3);

    handshake_in_packet(hand_shake);
    -- dtoggle_out = 1

    ASSERT (hand_shake /= bto_hs) REPORT
      "Target BTO's data transaction when clock is phase shifted between packets."
      SEVERITY FAILURE;

  END LOOP; -- hand_shake /= ack_hs

  test_progress <= test_num + 8;
  ASSERT false REPORT "Wait for the echo'ed packet and check it." SEVERITY NOTE;
  WHILE hand_shake /= data_hs LOOP

    clock_master <= host_p0;              -- use the host clock to send
    token_packet (IN_PID, device_address, endpt => 2);

    data_in_packet(DATA1_PID, 3, 0, hand_shake, check);

    ASSERT (hand_shake /= bto_hs) REPORT
      "Target BTO's in token when clock is phase shifted between packets."
      SEVERITY FAILURE;

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);
  -- dtoggle_in = 0

  -----------------------------------------------------------------------------
  -- return the clock master to the default state
  -----------------------------------------------------------------------------
  test_progress <= test_num + 9;
  clock_master <= clock_master_save;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;


END pll_test;


--------------------------------------------------------------------------------
--
-- Procedure: bit_stuff_reject_test
--
-- This procedure repeats the crc_bitstuff test inserting bit stuff errors in
-- the outgoing bitstream.  The target must detect these errors and bus time
-- out the transactions.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------

PROCEDURE bit_stuff_reject_test (
  CONSTANT test_num : integer
  ) IS

VARIABLE bsrt_i : integer;                    -- loop counter
VARIABLE index : integer; -- Packet data index
VARIABLE temp  : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE local_byte_cnt : integer; -- Local byte count
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing

BEGIN
  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  test_progress <= test_num + 1;
  WAIT FOR 80 ns;

  -----------------------------------------------------------------------------
  -- to be detectable as bit stuff error the data must contain 7 consecutive 1s
  -- 6 1s followed by a zero shows up as a DFN8 (not multiple of 8-bits) error.
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Send a token packet with 6 consecutive 1's, and confirm that it was
  -- rejected by the target.
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Testing Token with bit stuff error rejection"
    SEVERITY NOTE;
  -- Set the device address to 3F.
  set_address(16#3f#,0);

  hand_shake := nak_hs;

  force_bit_stuff_disable := true;
  --  see sec 8.3.1 USB 1.1    PID fld |Addr fld
  -- send 6 consecutive 1's => 10010110|11111100|
  token_packet (IN_PID, device_address, endpt => 0);
  force_bit_stuff_disable := false;

  handshake_in_packet(hand_shake);  -- expect a BTO not a data packet.

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore token with DFN8 (not multiple of 8-bits) error"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "00001000") = "00001000") REPORT
    "target failed to report a DFN8 error."
    SEVERITY FAILURE;

  ASSERT ((status_rg AND "11010111") = "00000000") REPORT
    "Unexpected errors reported by SIE "
    SEVERITY FAILURE;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  test_progress <= test_num + 2;
  -----------------------------------------------------------------------------
  -- Send a token packet with 7 consecutive 1's, and confirm that it was
  -- rejected by the target and check that the bit stuff and dfn8 bits were
  -- set.
  -----------------------------------------------------------------------------

  -- Set the device address to 7F.
  set_address(16#7f#,0);
  hc_pckt_data(0) := conv_std_logic_vector(16#fe#,8);

  hand_shake := nak_hs;

  force_bit_stuff_disable := true;
  -- see sec8.3.1 USB1.1    PID fld |Addr fld
  -- send 7 consecutive 1's 10000111|11111110
  token_packet (OUT_PID, device_address, endpt => 0);
  force_bit_stuff_disable := false;

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore packet with bitstuff error"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "10000000") = "10000000") REPORT
    "target failed to report bitstuff error in token."
    SEVERITY FAILURE;

  ASSERT ((status_rg AND "01010111") = "00000000") REPORT
    "Unexpected errors reported by SIE."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);


  test_progress <= test_num + 3;
  -----------------------------------------------------------------------------
  -- send a packet with bit stuff errors and check that it was rejected by the
  -- target.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Testing Data packet with bit stuff error rejection"
    SEVERITY NOTE;

  hc_pckt_data(0) := conv_std_logic_vector(16#fe#,8);

  hand_shake := nak_hs;

  token_packet (OUT_PID, device_address, endpt => 0);

  force_bit_stuff_disable := true;
  -- see sec8.3.1 USB 1.1                  PID fld  Data fld
  -- send 7 consecutive 1's in data packet 11000011|01111111
  data_out_packet(DATA0_PID,1);
  force_bit_stuff_disable := false;

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore packet with bitstuff error"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "10000000") = "10000000") REPORT
    "target failed to report bitstuff error."
    SEVERITY FAILURE;

  ASSERT ((status_rg AND "01011111") = "00000000") REPORT
    "Unexpected errors reported by SIE"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Set the data to all ones.  This packet generates a bit
  -- stuff in the data field.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#3f#,8);

  -----------------------------------------------------------------------------
  -- send a packet with bit stuff errors and check that it was rejected by the
  -- target.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 4;

  hand_shake := nak_hs;

  token_packet (OUT_PID, device_address, endpt => 0);

  force_bit_stuff_disable := true;
  -- sec8.3.1 USB 1.1
  -- send 6 consecutive 1's in data packet 11000011|00111111
  data_out_packet(DATA0_PID,1);
  force_bit_stuff_disable := false;

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore packet with bitstuff error"
    SEVERITY FAILURE;

  test_progress <= test_num + 5;
  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "00001000") = "00001000") REPORT
    "target failed to report a DFN8 error."
    SEVERITY FAILURE;

  ASSERT ((status_rg AND "01010111") = "00000000") REPORT
    "Unexpected errors reported by SIE"
    SEVERITY FAILURE;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Start sending a packet then force the idle state.  The prolonged J state
  -- will be interpretted as a partial packet with a bit stuff error.  This
  -- should be rejected by the target.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 6;

  hand_shake := nak_hs;

  token_packet (OUT_PID, device_address, endpt => 0);

  local_byte_cnt := 3; -- Copy constant to local variable
  index := 0; -- Init index
  send_sync(data_history); -- Send sync field

  temp(3 DOWNTO 0) := dtoggle_out & "011";   -- set the expected pid to data 0 or 1

  temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
  usb_pid <= to_pid_type(DATAX_PID);

  FOR bsrt_i IN 0 TO 7 LOOP -- Tx pid
    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    hc_state <= tx_pid; -- Set host controller state
    bit_stuff(temp(bsrt_i), data_history);
  END LOOP;

  -- Transmit data while byte count greater than 0
  WHILE (local_byte_cnt > 0) LOOP
    temp(7 DOWNTO 0) := hc_pckt_data(index); -- Get byte from packet data
    local_byte_cnt := local_byte_cnt - 1; -- Dec byte counter
    index := index + 1; -- Inc index
    FOR bsrt_i IN 0 TO 7 LOOP -- Tx addr
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      hc_state <= tx_data; -- Set host controller state
      bit_stuff(temp(bsrt_i), data_history);
    END LOOP; -- End for loop
  END LOOP; -- End while loop

  -- terminate the packet to the idle state.
  j_state;
  WAIT FOR 100 ns;
  dplus  <= 'Z';
  dminus <= 'Z';
  WAIT FOR 100 ns;

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did ignore a non-packet with bitstuff error"
    SEVERITY FAILURE;

  test_progress <= test_num + 7;
  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "10000000") = "10000000") REPORT
    "target failed to report bitstuff error."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- send the packet again with bit stuff error only on the last bit, and
  -- check that it was rejected by the target.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 8;

  -----------------------------------------------------------------------------
  -- Set CRC and bit stuff checking packet.  This packet generates a single bit
  -- stuff after the last bit of the packet.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#04#,8);

  hand_shake := nak_hs;

  token_packet (OUT_PID, device_address, endpt => 0);

  force_bit_stuff_disable := true;
  data_out_packet(DATA0_PID,3);
  force_bit_stuff_disable := false;

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore packet with bitstuff error on the last bit"
    SEVERITY FAILURE;

  test_progress <= test_num + 9;
  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg AND "10000000") = "10000000") REPORT
    "target failed to report bitstuff error."
    SEVERITY FAILURE;


  ASSERT ((status_rg AND "01010111") = "00000000") REPORT
    "Unexpected errors reported by SIE."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- now just run the crc_bitstuff test to verify that the target will insert a
  -- bit stuff bit on the last bit of a packet.
  -----------------------------------------------------------------------------
  crc_bitstuff_test;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);

  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "Unexpected errors reported by SIE."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

END bit_stuff_reject_test;

--------------------------------------------------------------------------------
--
-- Procedure: field_error_reject_test
--
-- This procedure tests that error in the PID or CRC5 fields cause tokens to be
-- ingnored, and that data packets are ignored if the crc16 is in error.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------

PROCEDURE field_error_reject_test

  IS

VARIABLE fert_i : integer;                    -- loop counter
VARIABLE index : integer; -- Packet data index
VARIABLE temp  : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE local_byte_cnt : integer; -- Local byte count
VARIABLE pid : integer;
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing

BEGIN

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Set CRC and bit stuff checking packet.  This packet generates a bit
  -- stuff after the last bit of the packet.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#04#,8);

  -----------------------------------------------------------------------------
  -- To test that invalid PIDs are rejected we will send a token packet with
  -- each of the invalid PID codes to the target followed by a zero length data
  -- packet.  The target should ignore both producing a BTO handshake from the
  -- handshake_in procedure.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Test rejection of unused PID values"
    SEVERITY NOTE;

  FOR fert_i IN 1 TO 6 LOOP                   -- test each of the 6 unused pids
    CASE fert_i IS
      WHEN 1 => pid := 0;
      WHEN 2 => pid := 4;
      WHEN 3 => pid := 6;
      WHEN 4 => pid := 7;
      WHEN 5 => pid := 8;
      WHEN 6 => pid := 16#f#;
    END CASE;

    hand_shake := nak_hs;

    token_packet (pid, device_address, endpt => 0);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

    ASSERT hand_shake = bto_hs REPORT
      "Target didn't ignore a token packet with an undefined PID"
      SEVERITY FAILURE;
  END LOOP;              -- for fert_i in 1 to 6

  -----------------------------------------------------------------------------
  -- Test that packets with a PID check field error are rejected by the target.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Test rejection of tokens with errors in the PID check field"
    SEVERITY NOTE;

  force_pid_check_error := true;

  token_packet (OUT_PID, device_address, endpt => 0);

  force_pid_check_error := false;

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore token packet with PID check field error"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Test that tokens with a crc5 field error are rejected by the target.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Test rejection of tokens with bad crc5"
    SEVERITY NOTE;

  force_crc5_error := true;

  token_packet (OUT_PID, device_address, endpt => 0);

  force_crc5_error := false;

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore token packet with bad crc5 field error"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Test that packets with a data crc error are rejected by the target.
  -----------------------------------------------------------------------------

  ASSERT terse REPORT
    "Test rejection of data packets with crc16 errors"
    SEVERITY NOTE;

  token_packet (OUT_PID, device_address, endpt => 0);

  force_crc16_error := true;

  data_out_packet(DATA0_PID,0);

  force_crc16_error := false;

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not ignore packet with data crc error"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Test that packets with a invalid eop field are rejected by the target.
  -----------------------------------------------------------------------------
  ASSERT terse REPORT
    "Test rejection of packets with invalid eop fields"
    SEVERITY NOTE;

  eop_time := (usb_bit_time / 2) - 2 ns;-- set the eop SE0 time below the minimum legal time.

  token_packet (OUT_PID, device_address, endpt => 0);
  eop_time := usb_bit_time * 2;            -- restore the eop SE0 time

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "Target did not reject packet with a short EOP"
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);
  status_rg := hc_rxpkt_data(0);

  -----------------------------------------------------------------------------
  -- Check the status of the target to ensure that the detected errors were
  -- reported.
  -----------------------------------------------------------------------------
  ASSERT ((status_rg  AND "00000001")= "00000001") REPORT
    "PID error not reported by target."
    SEVERITY FAILURE;

  ASSERT ((status_rg  AND "00000010")= "00000010") REPORT
    "CRC5 error not reported by target."
    SEVERITY FAILURE;

  ASSERT ((status_rg  AND "00000100")= "00000100") REPORT
    "CRC16 error not reported by target."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  ASSERT ((status_rg  AND "11000000")= "00000000") REPORT
    "Unexpected errors detected by target."
    SEVERITY FAILURE;

END field_error_reject_test;
--------------------------------------------------------------------------------
--
-- Procedure:   addr_endpt_reject_test
--
-- This procedure tests that addresses and endpoints that are not used by the
-- target device are ignored.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------

PROCEDURE addr_endpt_reject_test (
  CONSTANT test_num   : IN    integer    --  test number of debug tracking.
  ) IS

VARIABLE aert_i            : integer;         -- loop counter
VARIABLE endpt        : integer;         -- test value for end point number
VARIABLE test_address : integer;         -- test value for address field
VARIABLE wval         : integer;         -- argument for set endpoint control
VARIABLE wval_tmp     : std_logic_vector(15 DOWNTO 0);            -- register.

BEGIN
  test_progress <= test_num;

  -----------------------------------------------------------------------------
  -- To test the address comparitors in the target we will set the device
  -- address to zero then send a walking one pattern on the addresss bits and
  -- verify that we BTO on each transaction attempt.  Then the address will be
  -- set to 7F and the test will be repeated with a walking 0 pattern.
  -----------------------------------------------------------------------------
  set_address(0,test_num);               -- set address to 0

  -----------------------------------------------------------------------------
  -- walk one thru address field
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Walk a one thru the address field" SEVERITY NOTE;
  test_address := 2#0000001#;            -- set up walking one pattern
  FOR aert_i IN 1 TO 7 LOOP                   -- for each bit in the address field

    hand_shake := nak_hs;

    token_packet (OUT_PID, test_address, endpt => 3);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

    ASSERT hand_shake = bto_hs REPORT
      "Target didn't ignore a token with a non-matching address."
      SEVERITY FAILURE;

   test_address := test_address * 2;     -- shift the walking one pattern

  END LOOP;              -- for aert_i in 1 to 7

  set_address(16#7F#,test_num+4);        -- set address to 7F

  -----------------------------------------------------------------------------
  -- walk zero thru address field
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Walk a zero thru the address field" SEVERITY NOTE;
  test_address := 2#1111110#;            -- set up walking zero  pattern
  FOR aert_i IN 1 TO 7 LOOP                   -- for each bit in the address field

    hand_shake := nak_hs;

    token_packet (DATAX_PID, test_address, endpt => 3);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

    ASSERT hand_shake = bto_hs REPORT
      "Target didn't ignore a token with a non-matching address."
      SEVERITY FAILURE;

   test_address := (test_address * 2) + 1; -- shift the walking zero pattern

  END LOOP;              -- for aert_i in 1 to 7

  -----------------------------------------------------------------------------
  -- To test that endpoints that are not enabled in the device are ingnored by
  -- the target, all of the enpoints will be disabled except endpoint 0 and
  -- endpoint F, then we will use walking one and walking 0 patterns to test
  -- the endpoint numbers.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 16#a#;         -- endpoint reject walking one

  -----------------------------------------------------------------------------
  -- Disable endpoints all but enpoint 0 and the highest endpoint.
  -----------------------------------------------------------------------------

  wval_tmp := "00000000" & "000" & '0' & '0' & '0' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));

--  FOR endpt IN 1 TO 14 loop              -- for each endpoint
--  FOR endpt IN 1 TO 7 loop              -- for each endpoint
--  FOR endpt IN 1 TO 3 loop              -- for each endpoint
    set_diag_desc(breq => 2, wval => wval, wind => 1, wlen => 0);
    -- wait for the driver to configure the endpoints.
    WAIT FOR 200000 ns ;                 --  200 us
    set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0); -- inlined for easier translation to verilog. elr 5/11/98
    -- wait for the driver to configure the endpoints.
    WAIT FOR 200000 ns ;
--  end loop;                              -- on endpnt
  -----------------------------------------------------------------------------
  -- Enable the highest implemented endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '0' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 3, wlen => 0);
  -----------------------------------------------------------------------------
  -- walk one thru end point field
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Walk a one thru the endpoint field" SEVERITY NOTE;
  test_progress <= test_num + 16#c#;     -- endpoint reject walking 0
  endpt := 2#0001#;                      -- set up walking one pattern
  FOR aert_i IN 1 TO 4 LOOP                   -- for each bit in the address field

    hand_shake := nak_hs;

    token_packet (OUT_PID, device_address, endpt);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

    ASSERT hand_shake = bto_hs REPORT
      "Target didn't ignore a token with a non-matching endpoint."
      SEVERITY FAILURE;

   endpt := endpt * 2;                   -- shift the walking one pattern

  END LOOP;              -- for aert_i in 1 to 4

  -----------------------------------------------------------------------------
  -- walk zero thru end point field
  -----------------------------------------------------------------------------
  ASSERT terse REPORT "Walk a zero thru the endpoint field" SEVERITY NOTE;
  endpt := 2#1110#;                       -- set up walking zero  pattern
  FOR aert_i IN 1 TO 4 LOOP                   -- for each bit in the address field

    hand_shake := nak_hs;

    token_packet (OUT_PID, device_address, endpt);

    data_out_packet(DATA0_PID,0);

    handshake_in_packet(hand_shake);

    ASSERT hand_shake = bto_hs REPORT
      "Target didn't ignore a token with a non-matching endpoint"
      SEVERITY FAILURE;

   endpt := (endpt * 2) + 1;             -- shift the walking zero pattern

  END LOOP;              -- for aert_i in 1 to 7



END addr_endpt_reject_test;

--------------------------------------------------------------------------------
--
-- Procedure: wrong_packet_reject_test
--
-- This procedure tests that if a packet is sent to the wrong place or is sent
-- the wrong time that the target handles it correctly.
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE   wrong_packet_reject_test (
    CONSTANT test_num   : IN    integer       -- PID
  ) IS

  VARIABLE wval_tmp  : std_logic_vector(15 DOWNTO 0);

BEGIN
  -----------------------------------------------------------------------------
  -- PKT3 - Test that wrong direction packets are rejected.
  -- To test this  5 endpoints are configured one each of iso in , iso out,
  -- bulk in, bulk out and interrrupt (interrupt is implied in).  Then one
  -- transaction in the wrong dirrection is attempted to each of the endpoints.
  -- The target should allow the transaction to bus time out.
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Configure the endpoint 3 as an bidir bulk endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);
  -- dtoggle_out = 0
  -- dtoggle_in = 0


  -----------------------------------------------------------------------------
  -- Set up the endpoint echo data buffer to a known data pattern by sending an
  -- out data packet to endpoint 3
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#a1#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#a1#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#a1#,8);
  hc_pckt_data(3) := conv_std_logic_vector(16#a1#,8);

  token_packet (OUT_PID, device_address, endpt => 3);
  data_out_packet(DATA0_PID,4);
  handshake_in_packet(hand_shake);
  -- dtoggle_out = 1

  -----------------------------------------------------------------------------
  -- Set up the tx data packet to a recognizable error value.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#de#,8); -- dead beef
  hc_pckt_data(1) := conv_std_logic_vector(16#ad#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#be#,8);
  hc_pckt_data(3) := conv_std_logic_vector(16#ef#,8);

  -- attempt an out tranaction to an in / interrupt endpoint it should BTO.
  token_packet (OUT_PID, device_address, endpt => 2);
  data_out_packet(DATA0_PID,4);
  handshake_in_packet(hand_shake);
  ASSERT (hand_shake = bto_hs) REPORT
    "An in or interrupt endpoint did not ignore an out transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an out only bulk endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '0' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);


  -- attempt an in tranaction to a bulk out endpoint it should BTO.
  token_packet (IN_PID, device_address, endpt => 2);
  handshake_in_packet(hand_shake);
  ASSERT (hand_shake = bto_hs) REPORT
    "A bulk out endpoint did not ignore an in transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an out only iso endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '0' & '1' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  WAIT FOR 50000 ns; --  Give software time to deal with the request


  -- attempt an in tranaction to a iso out endpoint it should BTO.
  token_packet (IN_PID, device_address, endpt => 2);
  data_in_packet(DATA0_PID, 0, 0, hand_shake, iso_no_check);
  ASSERT (hand_shake = bto_hs) REPORT
    "An isochronous out endpoint did not ignore an in transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an in only iso endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '0' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);


  -- attempt an out tranaction to a iso in endpoint it should BTO, and the echo
  -- data buffer maintained by the diagnostic driver should be unaffected.
  token_packet (OUT_pid, device_address, endpt => 2);
  data_out_packet(DATA0_PID,4);
  handshake_in_packet(hand_shake);
  ASSERT (hand_shake = bto_hs) REPORT
    "An insochronous in endpoint did not ignore an out transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Verify that the echo data was no affected.
  -----------------------------------------------------------------------------
  hc_pckt_data(0) := conv_std_logic_vector(16#a1#,8);
  hc_pckt_data(1) := conv_std_logic_vector(16#a1#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#a1#,8);
  hc_pckt_data(3) := conv_std_logic_vector(16#a1#,8);

  hand_shake := nak_hs;

  WHILE hand_shake /= data_hs LOOP

   token_packet (IN_PID, device_address, endpt => 3);

   data_in_packet(DATA1_PID, 3, 0, hand_shake, check);

  END LOOP; -- hand_shake /= data_hs

  handshake_out_packet(ACK_PID);

  -----------------------------------------------------------------------------
  -- PKT4 - setup packets to a unidir endpoint are ignored.
  -- To test this a setup packet is sent to each of the 5 unidirectional
  -- endpoints set up in the previous section of this test, the setup
  -- transactions should also bus time out.
  -----------------------------------------------------------------------------

    -- assemble a get device descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#06#,8); -- bREquest: GetDescriptor
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#01#,8); --          device descript
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#12#,8); -- wLength: 0x0012
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  -- send device descriptor setup request to all the unidirectional endpoints
  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an in only bulk or interrupt endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '0' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);


  -- IN or INTERRUPT endpoint
  token_packet (SETUP_PID, device_address, endpt => 2);
  data_out_packet(DATA0_PID,16#8#);
  handshake_in_packet (hand_shake);
  ASSERT hand_shake = bto_hs
    REPORT "Unidirectional IN endpoint did not ignore a setup transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an out only bulk endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '0' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);
  -- Bulk out endpoint
  token_packet (SETUP_PID, device_address, endpt => 2);
  data_out_packet(DATA0_PID,16#8#);
  handshake_in_packet (hand_shake);
  ASSERT hand_shake = bto_hs
    REPORT "Unidirectional OUT endpoint did not ignore a setup transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an out only iso endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '0' & '1' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);
  -- Iso out endpoint
  token_packet (SETUP_PID, device_address, endpt => 2);
  data_out_packet(DATA0_PID,16#8#);
  handshake_in_packet (hand_shake);
  ASSERT hand_shake = bto_hs
    REPORT "Unidirectional ISO out endpoint did not ignore a setup transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as an in only iso endpoint.
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '0' & '0' & '0';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);
  -- Iso in endpoint
  token_packet (SETUP_PID, device_address, endpt => 2);
  data_out_packet(DATA0_PID,16#8#);
  handshake_in_packet (hand_shake);
  ASSERT hand_shake = bto_hs
    REPORT "Unidirectional ISO in endpoint did not ignore a setup transaction."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- PKT5 - all endpoints support 0 length packets.
  -- PKT6 - ISO channel sends 0 lenght packet if data not available
  -- We will not be testing all endpoints just all endpoint types. Using the 5
  -- endpoint set up at the beginining of this procedure and endpoint 0 as a
  -- control endpoint, this test will perform 0 length echo tests.
  -----------------------------------------------------------------------------

  -- Run a zero length echo test to each of the enpoint types
  bulk_echo_test(endpt => 2, dlength => 0, dpat => INC, dstart => 0);
  iso_echo_test (endpt => 2, dlength => 0, dpat => INC, dstart => 0,
                bogus_hndshk => 0, sof_wait => false);

  -----------------------------------------------------------------------------
  -- PKT7 - Packet whose length doesn't match are rejected.
  -- PKT8 - packet lenght measure disregards jitter in EOP.
  -- This test sends an out token that is one bit to short followed by a token
  -- packet that is one bit to long, followed by a good token packet and a
  -- data packet that shorts the last byte.
  -- I assume that the eop jitter reffered to here is EOP length jitter.
  -----------------------------------------------------------------------------
  -- send a token packet that is one bit short.
  force_short_token := true;

  token_packet (OUT_PID, device_address, endpt => 0);

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT (hand_shake = bto_hs) REPORT
    "Target did not reject a short token"
    SEVERITY FAILURE;

  force_short_token := false;

  -- send a token packet that is one bit long
  force_long_token := true;

  token_packet (OUT_PID, device_address, endpt => 0);

  data_out_packet(DATA0_PID,0);

  handshake_in_packet(hand_shake);

  ASSERT (hand_shake = bto_hs) REPORT
    "Target did not reject a short token"
    SEVERITY FAILURE;
  force_long_token := false;

  -- run the bitstuff crc test to confirm that the target was not adversely
  -- effected.
  crc_bitstuff_test;

  -- now lets run the crc_bitstuff test again while jittering the the eop
  -- length to confirm that the eop length is not used in calculating the
  -- packet lenght.

  eop_time := usb_bit_time;              --  short the eop time
  crc_bitstuff_test;

  eop_time := usb_bit_time * 6;          --  extend  the eop time
  crc_bitstuff_test;

  eop_time := usb_bit_time * 2;          -- restore the eop SE0 time

  -----------------------------------------------------------------------------
  -- PKT9 - a incorrectly constituted packet is rejected.
  -- This checklist item is basically untestable.  A complete test would have
  -- to send all posible bit steams that did not combine to form a vailid
  -- packet, and see that the target rejected them.  Most of these bit streams
  -- will show up as an invalid PID, a packet with a bad length or a CRC error,
  -- and are tested elsewhere.
  -----------------------------------------------------------------------------

END wrong_packet_reject_test;
--------------------------------------------------------------------------------
--
-- Procedure: token_restart_test
--
-- This procedure tests that transactions are terminated by a new token packet,
-- and that the token successfully starts the new transaction.
--
-- This procedure is dependent on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------


PROCEDURE   token_restart_test (
    CONSTANT test_num   : IN    integer       -- PID
  ) IS

VARIABLE retry_count : integer;

BEGIN
-------------------------------------------------------------------------------
-- This test starts a Setup transaction then restarts it in various stages of
-- completion by initiating a new setup trasaction.
-------------------------------------------------------------------------------

  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Start a set addrss request then interrupt it with another set address
  -- request.
  -----------------------------------------------------------------------------
  -- assemble a set address packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#05#,8); -- bREquest: Set address
  hc_pckt_data(2) := conv_std_logic_vector(16#7d#,8); -- wValue: address
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#00#,8); -- wLength: 0
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with set address request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
    test_progress <= test_num; -- Start Set Address Transaction, send a setup
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

--    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
--    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    test_progress <= test_num + 1;           -- Send a set address req data packet

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK
    test_progress <= test_num + 2;             -- Wait for Setup data Acknowledge

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  WAIT FOR 200000 ns;                    --  give software 200 us to recover.

  set_address(16#02#,test_num+3);        -- set address to 2

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Now start the get configuration desctiptor that will be terminated by a
  -- second setup packet requesting a get device descriptor.
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -- assemble a get configuration desctiptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#06#,8); -- bREquest: GetDescriptor
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- wValue: index = 0
  hc_pckt_data(3) := conv_std_logic_vector(16#02#,8); --         config descriptor
  hc_pckt_data(4) := conv_std_logic_vector(16#00#,8); -- wIndex: 0
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#ff#,8); -- wLength: 0x00ff
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false  REPORT "Transmit setup packet to current address, endpoint 0"
    SEVERITY NOTE;
  ASSERT false  REPORT "Transmit data packet with get configuration descriptor request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP   -- Repeat untill the target responds
    test_progress <= test_num+6;       -- Starting get descriptor send setup token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

                                         -- wait for the handshake packet the
                                         -- Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR NOT verbose
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY FAILURE;

  END LOOP;          -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  WAIT FOR 200000 ns;                       -- give software some time to recover.
  -----------------------------------------------------------------------------
  -- interrupt the get configuration descriptor by doing a get device
  -- descriptor.
  -----------------------------------------------------------------------------
  get_device_desc(test_num+7);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;

END token_restart_test;



--------------------------------------------------------------------------------
--
-- Procedure: stall_test
--
-- This procedure tests the two types of stalls implemented in USB.
--
-- The USB 1.1 spec defines the use stall in two distinct ways.  The first usage
-- of stall defined is clarified in the USB 1.1 spec by referring to it as a
-- functional stall. A functional stall is when the Halt Feature associated with
-- an Endpoint is set. Once a function's endpoint is halted the function
-- must continue returning STALL until the condition causing the halt has been
-- cleared through host intervention.
--
-- The second usage of the stall handshake is known as protocol stall. Protocol
-- stall is unique to control pipes.  Protocol stall differs from functional
-- stall in meaning and duration. A protocol STALL is returned during the Data
-- or Status stage of a control transfer, and the STALL condition terminates at
-- the beginning of the next control transfer (Setup).
--
-- This procedure is dependant on a diagnostic hook coded into the usb driver
-- software running on the USB SIE Adjunct processor.  This code echo's any OUT
-- DATA transaction recieved by the VUSB SIE and makes it available for
-- subsequent IN data transactions.
--
--------------------------------------------------------------------------------

PROCEDURE   stall_test (
    CONSTANT test_num   : IN    integer       -- PID
  ) IS

VARIABLE retry_count : integer;
VARIABLE wval_tmp    : std_logic_vector(15 DOWNTO 0);
VARIABLE temp_vec    : std_logic_vector(15 DOWNTO 0);

BEGIN
-------------------------------------------------------------------------------
-- This test starts a Setup transaction then restarts it in various stages of
-- completion by initiating a new setup trasaction.
-------------------------------------------------------------------------------

  test_progress <= test_num;
  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- Testing Function STALL (HALT).
  --   Set the STALL bit for an Bidir Bulk endpoint using the
  -- SetFeature(Endpoint,Stall) (Halt).  See that IN and OUT tokens produce
  -- a stall handshake. Verify that a setup token does not clear the stall.
  --   Reset the STALL bit using the ClearFeature(Endpoint,Stall) run the
  -- Bulk echo test.
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Configure the endpoint 2 as a bidirectional Bulk enddpoint
  -----------------------------------------------------------------------------
  wval_tmp := "00000000" & "000" & '1' & '1' & '1' & '0' & '1';
     --           |          |      |     |     |     |     |
     --           |          |      |     |     |     |     + Handshake enable
     --           |          |      |     |     |     + endpoint stall
     --           |          |      |     |     + endpoint out enable
     --           |          |      |     + endpoint in enable
     --           |          |      + Control Disable
     --           |          + Undefined
     --           + Undefined
  wval := conv_integer(unsigned(wval_tmp));
  set_diag_desc(breq => 2, wval => wval, wind => 2, wlen => 0);

  -- wait for the driver to configure the iso channel.
  WAIT FOR 200000 ns ;                   -- 200 us
--  WAIT FOR 400000 ns ;                   -- 200 us
  -- set up an outgoing packet.
  build_hc_packet(byte_cnt => 8, strt_data => 0, data_pat => inc, seed => seed);

  -----------------------------------------------------------------------------
  -- Set feature stall on enpoint 2
  -----------------------------------------------------------------------------
    ASSERT false  REPORT "Attempt a set feature stall on endpoint 2."
    SEVERITY NOTE;
  set_feature(rtype => 2, wval => 0, wind => 2, test_num => test_num+1);


  -----------------------------------------------------------------------------
  -- Send an OUT token packet, expecting a stall hand shake
  -----------------------------------------------------------------------------
  test_progress <= test_num + 8;
  token_packet (OUT_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,8);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT
    "STALL'ed endpoint did not STALL OUT token."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Send an IN token packet, expecting a stall hand shake
  -----------------------------------------------------------------------------
  test_progress <= test_num + 9;
  token_packet (IN_PID, device_address, endpt => 2);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT
    "STALL'ed endpoint did not STALL IN token."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Send a SETUP token packet (expecting a Bus time out) to make sure that a
  -- Setup packet to a Bulk endpoint will not clear the "Function Stall"
  -----------------------------------------------------------------------------
  test_progress <= test_num + 16#a#;
  token_packet (SETUP_PID, device_address, endpt => 2);

  data_out_packet(DATA0_PID,8);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = bto_hs REPORT
    "A Bulk endpoint did not reject a SETUP packet."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Verify that the thstall was not cleared by Send an IN token packet
  -- (expect a stall hand shake).
  -----------------------------------------------------------------------------
  test_progress <= test_num + 16#b#;
  token_packet (IN_PID, device_address, endpt => 2);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT
    "STALL'ed endpoint did not STALL OUT token."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Clear feature stall on endpoint 2
  -----------------------------------------------------------------------------
  -- clear the endpoint 1 stall feature
  ASSERT false  REPORT "Attempt a clear feature stall on endpoint 2."
    SEVERITY NOTE;
  clear_feature(rtype => 2, wval => 0, wind => 2, test_num => test_num+16#c#);

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "01011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;
  -- We should see the stall handshake interrupt
  status_rg := hc_rxpkt_data(1);
  ASSERT ((status_rg  AND "00001000")= "00001000") REPORT
    "Stall hand shake was not reported."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Run the Bulk echo test to confirm that the stall condition is removed.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 16#d#;
  bulk_echo_test(endpt => 2, dlength => 0, dpat => INC, dstart => 0);

  -----------------------------------------------------------------------------
  -- Testing Protocol stall. (hardware functions)
  --   Set the protocol stall by
  -- 	1) Invalid setup request
  -- 	2) Bad data field In
  -- 	3) Data field to long
  --   Check the protocol stall set by sending
  -- 	1) IN tokent
  -- 	2) Out token with data
  --   Clear the protocol stall by sending the next setup transaction.
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Attempt a Get Interface when the device is in the addressed state.
  -----------------------------------------------------------------------------
  -- Move the device into the addressed state by setting the configuration
  -- value to 0.
  test_progress <= test_num + 16#10#;

  ASSERT terse  REPORT "Move to the addressed State."
    SEVERITY NOTE;
  set_value(breq => 9, wval => 16#00#, wind => 0, test_num => 16#beef#);

  test_progress <= test_num + 16#11#;
  -- Start a get interface command but expect a STALL handshake in the data
  -- phase of the transfer.
  -- assemble a get descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#81#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#0a#,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(0,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(1,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(1,16);   -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT terse  REPORT "Transmit setup packet with get request"
    SEVERITY NOTE;
  retry_count := 0;
  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds
                               -- token
    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

   -- wait for the handshake packet the Target must ACK

    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT (hand_shake /= bto_hs) OR (retry_count < 8)
      REPORT "Bus Timeout retry limit exceeded."
      SEVERITY FAILURE;
    retry_count := retry_count + 1;

  END LOOP; -- END WHILE (hand_shake = bto_hs) LOOP

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;


  ASSERT terse REPORT
    "Send an in token expecting a STALL." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake = nak_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);

    ASSERT NOT verbose REPORT "check for stall handshake" SEVERITY NOTE;
    handshake_in_packet (hand_shake);
  END LOOP; -- hand_shake = nak_hs

  ASSERT hand_shake = stall_hs  REPORT
    "Unconfigured target did not stall the data phase of a get interface."
    SEVERITY FAILURE;


  -----------------------------------------------------------------------------
  -- Attempt to set the configuration value to a value that is not in the not
  -- in the configuration descriptor.
  -----------------------------------------------------------------------------
  -- Start the set configuration command expect a Stall handshake in the status
  -- phase of the transfer.
  test_progress <= test_num + 16#12#;

  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#09#,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(wval,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(0,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(0,16);      -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);

  ASSERT false  REPORT "Transmit data packet with set configuration request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

                                         -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY NOTE;
  END LOOP;                              -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;


  hand_shake := nak_hs;
  ASSERT terse REPORT "Target should STALL the status phase."    SEVERITY NOTE;
  WHILE hand_shake = nak_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    handshake_in_packet(hand_shake);
  END LOOP;                              -- hand_shake = STALL

  ASSERT hand_shake = stall_hs REPORT
    "Target failed to stall the status phase when config value was invalid."
    SEVERITY FAILURE;



  -- Move the device into the configured state by setting the configuration
  -- value to 1.
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => test_num+16#aa12#);

  -----------------------------------------------------------------------------
  -- Attempt a get configuration value, but ask for more data than is expected.
  -----------------------------------------------------------------------------
  test_progress <= test_num + 16#14#;
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(8,8);   -- bREquest:
  temp_vec := conv_std_logic_vector(0,16);   -- wValue
  hc_pckt_data(2) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(3) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(0,16);   -- wIndex
  hc_pckt_data(4) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(5) := temp_vec(15 DOWNTO 8);
  temp_vec := conv_std_logic_vector(1,16);   -- wLength
  hc_pckt_data(6) := temp_vec(7 DOWNTO 0);
  hc_pckt_data(7) := temp_vec(15 DOWNTO 8);


  ASSERT terse REPORT "Transmit data packet with get config or interface  request"
    SEVERITY NOTE;

  hand_shake := bto_hs;
  WHILE (hand_shake = bto_hs) LOOP      -- Repeat untill the target responds

    token_packet (SETUP_PID, device_address, endpt => 0);

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
    WAIT UNTIL usb_clk'event AND usb_clk = '1';

    -- send the tx packet data with an OUT pid and a byte count of 8
    data_out_packet(DATA0_PID,16#8#);

                                         -- wait for the handshake packet the Target must ACK
    ASSERT NOT verbose REPORT "Check the ack on the setup packet" SEVERITY NOTE;
    handshake_in_packet (hand_shake);

    ASSERT hand_shake /= bto_hs
      REPORT "Bus Timeout re-send setup and data packets."
      SEVERITY FAILURE;
  END LOOP;                              -- end of while hand_shake /= bto_hs loop

  ASSERT hand_shake = ack_hs
    REPORT "Target must ack the setup data packet."
    SEVERITY FAILURE;

  -- now turn the bus around to recieve the descriptor

  ASSERT false REPORT "Send an in token to receive the value."
    SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake = nak_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    data_in_packet(DATA1_PID, 1, 0, hand_shake, no_check);
  END LOOP; -- hand_shake /= DATA

  ASSERT hand_shake = data_hs REPORT
    "Target failed to return configuration data."
    SEVERITY FAILURE;

  handshake_out_packet(ACK_PID);

  hand_shake := nak_hs;
  WHILE hand_shake = nak_hs LOOP
    token_packet(IN_PID, device_address, endpt => 0);
    ASSERT NOT verbose REPORT "check for in data packet" SEVERITY NOTE;
    hand_shake := nak_hs;
    handshake_in_packet(hand_shake);
  END LOOP; -- hand_shake = NAK

  ASSERT hand_shake = stall_hs REPORT
    "Target failed to stall additional IN token in data phase."
    SEVERITY FAILURE;

  -----------------------------------------------------------------------------
  -- Check that the protocol STALL is not cleared by an IN or out token
  -----------------------------------------------------------------------------
  test_progress <= test_num + 16#15#;
  -- Send an IN token expect a STALL handshake back
  token_packet (IN_PID, device_address, endpt => 0);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT
    "STALL'ed endpoint did not STALL OUT token."
    SEVERITY FAILURE;


  -- Send an OUT token expect a STALL handshake back
  token_packet (OUT_PID, device_address, endpt => 0);

  data_out_packet(DATA0_PID,1);

  handshake_in_packet(hand_shake);

  ASSERT hand_shake = stall_hs REPORT
    "STALL'ed endpoint did not STALL OUT token."
    SEVERITY FAILURE;


  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);
  ASSERT ((status_rg  AND "01011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;
  -- We should see the stall handshake interrupt
  status_rg := hc_rxpkt_data(1);
  ASSERT ((status_rg  AND "00001000")= "00001000") REPORT
    "Stall hand shake was not reported."
    SEVERITY FAILURE;


END stall_test;


-------------------------------------------------------------------------------
-- Start of Process execution.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
BEGIN

  -----------------------------------------------------------------------------
  -- Trigger the target usb_clk to start running
  -----------------------------------------------------------------------------
  -- Determine if we need a low speed or high speed clock
  if lsdev = 1 then
    clock_low_speed <= true;
  else
    clock_low_speed <= false;
  end if;

  clk_start <= '0';
  WAIT FOR 1 ns;
  clk_start <= '1';

  test_progress <= 16#0001#;             -- initial reset
  seed := 12; -- Init random number generator seed
  tb_done <= false; -- Enable test bench execution
  -- Emulate host controller by pulling down on data lines
  dplus  <= 'Z'; -- Release data+
  dminus <= 'Z'; -- Release data-
-- This currently does not work!
--  dplus  <= 'L'; -- Pulldown data+
--  dminus <= 'L'; -- Pulldown data-

  -- Define the default values for the downstream port control outputs.
  low_speed_dp <= "0000000000000000";
  connect_dp   <= "0000000000000000";
  rmt_wake_dp  <= "0000000000000000";
  port_sel     <= "00001";            -- Port 1 selected

  WAIT FOR 2000 ns;                   -- wait for sys reset to deassert

  test_progress <= 16#0002#;             -- initial reset - starting reset signal

  ASSERT false  REPORT "Initiate USB bus Reset" SEVERITY NOTE;
--  usb_reset (10000000 ns);  -- This is the real length - 10 ms
  if lsdev = 1 then
    eop_time := 1334 ns;      -- This is the EOP time for LS
    usb_reset (8000000 ns);   -- This is long enough for LS software setup - 8 ms
  else
    eop_time := 166 ns;       -- This is the EOP time for HS
    usb_reset (5500000 ns);   -- This is long enough for HS software setup - 5.5 ms
  end if;
-- usb_reset (100000 ns);     -- This is used for hardware debug - 100 us
-- INTEL SPECIAL INSERT ON
--  WAIT UNTIL sof_request'event AND sof_request = '1';
--  WAIT UNTIL sof_request'event AND sof_request = '1';
--  WAIT UNTIL sof_request'event AND sof_request = '1';
--  WAIT UNTIL sof_request'event AND sof_request = '1';
--  WAIT UNTIL sof_request'event AND sof_request = '1';
-- INTEL SPECIAL INSERT OFF

  IF wait_for_frame_lock_enable THEN
    WAIT FOR 3000000 ns;  -- 3 ms Added to allow time for frame lock
  END IF; -- wait_for_frame_lock_enable

  test_progress <= 16#0003#; -- initial reset - reset signal deassertion

  WAIT FOR 1000 ns;

IF sof_special_test_enabled THEN

  ASSERT false  REPORT
        "Starting Special tests."
    SEVERITY NOTE;

--   frame_test := 16#001d#;

--   FOR i IN 1 TO 16#0020# LOOP
--     sof_token_packet(frame_test);
--   END loop;

   -- set the configuration value to 01
  ASSERT false  REPORT "Attempt a Get Device Descriptor."
    SEVERITY NOTE;
  get_device_desc(16#90001#);            -- get the device descriptor

  ASSERT false  REPORT "Attempt a set Address."
    SEVERITY NOTE;
  set_address(16#7f#,16#9010#);          -- set address to 7f

  ASSERT false  REPORT "Attempt a set configuration to 01."
    SEVERITY NOTE;
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => 16#beef#);

END IF; -- sof_special_test_enabled

IF chapter_9_tests_enabled THEN
  test_progress <= 16#9000#; -- Start of Chapter 9 tests.
  ASSERT false  REPORT
        "Starting Chapter 9 tests."
    SEVERITY NOTE;

  -----------------------------------------------------------------------------
  -- Try one setup transaction of each bRequest type from Table 9.3 of the USB
  -- specification.
  -----------------------------------------------------------------------------
  ASSERT false  REPORT "Attempt a Get Device Descriptor."
    SEVERITY NOTE;
  get_device_desc(16#90001#);            -- get the device descriptor

  ASSERT false  REPORT "Attempt a set Address."
    SEVERITY NOTE;
  set_address(16#7f#,16#9010#);          -- set address to 7f

  ASSERT false  REPORT "Attempt a get configuration."
    SEVERITY NOTE;
  get_config_desc(16#9020#);             -- get the configuration descriptor

--set_configuration_desc(16#9030#);      -- set configuration descriptor is not
                                         -- supported.

  ASSERT false  REPORT "Attempt a get device status."
    SEVERITY NOTE;
  get_device_status(16#9040#);           -- get the status

  -- set the enpoint 1 stall feature
  ASSERT false  REPORT "Attempt a set feature stall on endpoint 1."
    SEVERITY NOTE;
  set_feature(rtype => 2, wval => 0, wind => 1, test_num => 16#9050#);
  -- let's go a head and check that it worked
  ASSERT false  REPORT
    "Do a get endpoint status to check that the previous set feature worked"
    SEVERITY NOTE;
  get_endpoint_status(endpt_num => 1, test_num => 16#9058#);
  ASSERT ((hc_rxpkt_data(0) = "00000001") AND (hc_rxpkt_data(1) = "00000000"))
    REPORT "endpoint did not report stall status."
    SEVERITY FAILURE;

  -- clear the enpoint 1 stall feature
  ASSERT false  REPORT "Attempt a clear feature stall on endpoint 1."
    SEVERITY NOTE;
  clear_feature(rtype => 2, wval => 0, wind => 1, test_num => 16#9060#);
  ASSERT false  REPORT
    "Do a get endpoint status to check that the previous set feature worked"
    SEVERITY NOTE;
  get_endpoint_status(endpt_num => 1, test_num => 16#9058#);
  -- let's go a head and check that it worked
  ASSERT ((hc_rxpkt_data(0) = "00000000") AND (hc_rxpkt_data(1) = "00000000"))
    REPORT "endpoint did not report not stalled status."
    SEVERITY FAILURE;

   -- set the configuration value to 01
  ASSERT false  REPORT "Attempt a set configuration to 01."
    SEVERITY NOTE;
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => 16#9070#);

  -- get configuration
  ASSERT false  REPORT "Attempt a get configuration (expect 01)."
    SEVERITY NOTE;
  get_value(breq => 8, exp_value => 16#01#, wind => 0, test_num => 16#9080#);

  -- get interface of interface 1
  ASSERT false  REPORT "Attempt a get interface for interface 1 (expect 0)."
    SEVERITY NOTE;
  get_value(breq => 16#a#, exp_value => 0, wind => 1, test_num => 16#9090#);

  -- set_interface 1 to 1
  ASSERT false  REPORT "Attempt to set interface 1 to 1."
    SEVERITY NOTE;
  set_value(breq => 16#b#, wval => 1, wind => 1, test_num => 16#90a0#);

  -- get interface of interface 1
  ASSERT false  REPORT "Attempt a get interface for interface 1 (expect 1)."
    SEVERITY NOTE;
  get_value(breq => 16#a#, exp_value => 1, wind => 1, test_num => 16#90b0#);

  -- set_interface 1 back to 0
  ASSERT false  REPORT "Attempt to set interface 1 to 0."
    SEVERITY NOTE;
  set_value(breq => 16#b#, wval => 0, wind => 1, test_num => 16#90c0#);

  -- get interface of interface 1
  ASSERT false  REPORT "Attempt a get interface for interface 1 (expect 0)."
    SEVERITY NOTE;
  get_value(breq => 16#a#, exp_value => 0, wind => 1, test_num => 16#90d0#);

-------------------------------------------------------------------------------
-- Get Manufacture  and other strings String
-------------------------------------------------------------------------------
  test_progress <= 16#9100#; -- Starting get descriptor send setup token
  ASSERT false  REPORT "Attempt to get the String desctiptors."
    SEVERITY NOTE;

  -- assemble a get string descriptor packet.
  hc_pckt_data(0) := conv_std_logic_vector(16#80#,8); -- bmRequestType
  hc_pckt_data(1) := conv_std_logic_vector(16#06#,8); -- bREquest: GetDescriptor
  hc_pckt_data(2) := conv_std_logic_vector(16#01#,8); -- wValue: index = 1
  hc_pckt_data(3) := conv_std_logic_vector(16#03#,8); --          string descript
  hc_pckt_data(4) := conv_std_logic_vector(16#09#,8); -- wIndex: 0x0409 (english)
  hc_pckt_data(5) := conv_std_logic_vector(16#04#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#00#,8); -- wLength: 0x0100
  hc_pckt_data(7) := conv_std_logic_vector(16#01#,8);

--  FOR index0 IN 1 TO 8 LOOP              -- for each of the strings
  FOR index0 IN 1 TO 6 LOOP              -- skip hub string.

      hc_pckt_data(2) := conv_std_logic_vector(index0,8); -- wValue: index of string
      CASE index0 IS
        WHEN 1 => string_len := USB_STR_1_LEN;
        WHEN 2 => string_len := USB_STR_2_LEN;
        WHEN 3 => string_len := USB_STR_3_LEN;
        WHEN 4 => string_len := USB_STR_4_LEN;
        WHEN 5 => string_len := USB_STR_5_LEN;
        WHEN 6 => string_len := USB_STR_6_LEN;
        WHEN 7 => string_len := USB_STR_7_LEN;
        WHEN OTHERS => string_len := USB_STR_n_LEN;
      END CASE;                          -- index0

      ASSERT false  REPORT "Transmit data packet with get string descriptor request"
        SEVERITY NOTE;

      get_data(rtype => 16#80#,          -- bmRequestType
           breq => 6,                    -- bREquest : get descriptor
           wval => (16#0300# + index0),  -- wValue   : 03 string dec 01 string index
           wind => 16#0409#,             -- wIndex   : 0409 (english)
           wlen => string_len,           -- wLength  : length of returned packet.
           check => no_check,            -- checking disbled.
           test_num => (16#9100# + index0 * 16#10#));

      -- check the first two bytes of the string descriptor packet.

      test_value <= conv_integer(unsigned(hc_rxpkt_data(0)));
      exp_value  <= string_len;
      ASSERT (conv_integer(unsigned(hc_rxpkt_data(0))) = string_len)
        REPORT "Received Data does not equal expected data"
        SEVERITY FAILURE;
      WAIT FOR 2 ns;                     -- just so you can see the tests in
      test_value <= conv_integer(unsigned(hc_rxpkt_data(1)));
      exp_value  <= 3;
      ASSERT (conv_integer(unsigned(hc_rxpkt_data(1))) = 3)
        REPORT "Received Data does not equal expected data"
        SEVERITY FAILURE;
      WAIT FOR 2 ns;                     -- just so you can see the tests in
                                         -- the waveform display

      -- decode the unicode string into a ascii string
      index2 := 1;
      index1 := 2;
      WHILE index1 < string_len LOOP
        temp_string2(index2) := vec2asci(hc_rxpkt_data(index1));
        index1 := index1 + 2;
        index2 := index2 + 1;
      END LOOP;
      temp_string2(index2) := nul;        -- Add a string terminator.

      CASE index0 IS
        WHEN 1 => ASSERT (false) REPORT
                    "Received Manufacture's ID string:" & temp_string2
                    SEVERITY NOTE;
        WHEN 2 => ASSERT (false) REPORT
                    "Received Product ID string:" & temp_string2
                    SEVERITY NOTE;
        WHEN 3 => ASSERT (false) REPORT
                    "Received Serial Number string:" & temp_string2
                    SEVERITY NOTE;
        WHEN 4 => ASSERT (false) REPORT
                    "Received Configuration string:" & temp_string2
                    SEVERITY NOTE;
        WHEN 5 => ASSERT (false) REPORT
                    "Received Interface1 string:" & temp_string2
                    SEVERITY NOTE;
        WHEN 6 => ASSERT (false) REPORT
                    "Received Interface2 string:" & temp_string2
                    SEVERITY NOTE;
        WHEN 7 => ASSERT (false) REPORT
                    "Received Hub Descriptor string:" & temp_string2
                    SEVERITY NOTE;
        WHEN OTHERS => ASSERT (false) REPORT
                    "Received Index > 7 string:" & temp_string2
                    SEVERITY NOTE;
      END CASE;                          -- index0

  END LOOP;                              --  FOR index0

  ASSERT false REPORT "Get String Descriptor Completed" SEVERITY NOTE;
-------------------------------------------------------------------------------
-- End Get Manufacturer String
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Test the endpoint feature Halt Stall usage and the control endpoint Protocol
-- Stall usage.
-------------------------------------------------------------------------------
  stall_test(16#9200#);

END IF;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- CHAPTER 11 TEST
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

IF chapter_11_tests_enabled THEN
-------------------------------------------------------------------------------
-- This test excercises all of the host commands for control of the hub. The
-- intention of this test is to make sure that all of the host control commands
-- execute appropriately.  The functional use of these commands is tested in the
-- other hub releated tests.
------------------------------------------------------------------------------
  ASSERT false REPORT "CHAPTER 11 TEST STARTED" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Send a Get Descriptor Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#0100#; -- Starting get descriptor send setup token
  ASSERT false  REPORT "Get Device Descriptor from Hub."
    SEVERITY NOTE;

  get_device_desc(test_num => 16#0100#);

  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Send a Set Address Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#0200#; -- Start Set Address Transaction, send a setup
                             -- token
  ASSERT false  REPORT "Assign Address of 0x78 to hub."
    SEVERITY NOTE;
  set_address(16#78#,test_num => 16#0200#);          -- set address to 0x78

  ASSERT false REPORT "Set Address Hub Request Completed" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Assign the configuration values to the Hub.
--------------------------------------------------------------------------------
  test_progress <= 16#0500#; --Start Set Configuration Transaction, send a setup

  ASSERT false  REPORT "Assign Configuration of 0x01 to hub."
    SEVERITY NOTE;

   -- set the configuration value to a1
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => 16#0500#);


  ASSERT false REPORT "Set Configuration Device Request Completed"
               SEVERITY NOTE;
-------------------------------------------------------------------------------
-- Get the hub descriptor and compare the received data values with those
-- defined in the get_hub_desc procedure.
-------------------------------------------------------------------------------
  ASSERT false  REPORT "Get Hub Class Hub Descriptor." SEVERITY NOTE;

  get_hub_desc(test_num => 16#b000#);

  ASSERT false  REPORT "Get Hub Class Hub Descriptor Completed." SEVERITY NOTE;

-------------------------------------------------------------------------------
-- set_hub_descriptor this should return a stall handshake.
-------------------------------------------------------------------------------
 -- set_hub_descriptor(test_num => 16#B000#);

-------------------------------------------------------------------------------
-- Run the set and clear features on each hub class hub feature.
-- Use the get_hub_status to check that they worked.
-- Following is the order of the bytes received from get_hub_status command:
--  (0) Status, Lo <= {rsv, rsv, rsv, rsv,   rsv, rsv, over_curr, local_pwr}
--  (1) Status, Hi <= {rsv, rsv, rsv, rsv,   rsv, rsv, rsv, rsv}
--  (2) Change, Lo <= {rsv, rsv, rsv, rsv,   rsv, rsv, c_over_curr, c_local_pwr}
--  (3) Change, Hi <= {rsv, rsv, rsv, rsv,   rsv, rsv, rsv, rsv}
-------------------------------------------------------------------------------
   ASSERT false  REPORT "Perform set and clear hub features" SEVERITY NOTE;

  -- Get hub status and check change fields
   get_data(rtype => 16#a0#, bReq => 0, wval => 0, wind => 0, wlen => 4, check => no_check,
            test_num => 16#b010#);
   temp_byte := hc_rxpkt_data(2);
   ASSERT (temp_byte = "00000000")
   REPORT "Hub feature miscompare" SEVERITY FAILURE;

  -- Set the hub local_power and hub_over_current change bits. Note, this is a
  -- diagnostic capability. These bits will normally only be set by hardware
  -- and the host clears the bits.

   set_feature(rtype => 16#20#, wval => 0, wind => 0, test_num => 16#b020#);
   set_feature(rtype => 16#20#, wval => 1, wind => 0, test_num => 16#b030#);

  -- Get hub status and check change fields
   get_data(rtype => 16#a0#, bReq => 0, wval => 0, wind => 0,
            wlen => 4, check => no_check, test_num => 16#b040#);
   temp_byte := hc_rxpkt_data(2);
   ASSERT (temp_byte = "00000011")
   REPORT "Hub feature miscompare" SEVERITY FAILURE;

  -- Clear the hub local_power and hub_over_current change bits.
   clear_feature(rtype => 16#20#, wval => 0, wind => 0, test_num => 16#b050#);
   clear_feature(rtype => 16#20#, wval => 1, wind => 0, test_num => 16#b060#);

  -- Get hub status and check change fields
   get_data(rtype => 16#a0#, bReq => 0, wval => 0, wind => 0,
            wlen => 4, check => no_check, test_num => 16#b070#);
   temp_byte := hc_rxpkt_data(2);
   ASSERT (temp_byte = "00000000")
   REPORT "Hub feature miscompare" SEVERITY FAILURE;

-------------------------------------------------------------------------------
-- Run the set and clear features on each hub class port feature.
-- Use the get_port_status to check that they worked.
-- Following is the order of the bytes received from get_port_status command:
--  (0) Status, Lo <= {rsv, rsv, rsv, reset,  over_cur, suspend, enable, conn}
--  (1) Status, Hi <= {rsv, rsv, rsv, rsv,    rsv, rsv, low_speed, port_power}
--  (2) Change, Lo <= {rsv, rsv, rsv, reset,  over_cur, suspend, enable, conn}
--  (3) Change, Hi <= {rsv, rsv, rsv, rsv,    rsv, rsv, rsv, rsv}
-------------------------------------------------------------------------------
  ASSERT false  REPORT "Starting the port feature test" SEVERITY NOTE;

-- Perform a get_bus_state command
--  get_data(rtype => 16#a3#, breq => 2, wval =>0, wind => 1,
--           wlen => 1,  check => no_check, test_num => 16#b000#);
--   temp_byte:= hc_rxpkt_data(0);
--   ASSERT (temp_byte = "00000010")
--   REPORT "Hub port 1 bus state not full speed idle." SEVERITY FAILURE;
--

  ASSERT false  REPORT "Perform set and clear port features" SEVERITY NOTE;
-------------------------------------------------------------------------------
-- Verify the initial status for the port.
-------------------------------------------------------------------------------
 -- Setup the expected port status fields before get_data
  hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- Status, Low Byte
  hc_pckt_data(1) := conv_std_logic_vector(16#00#,8); -- Status, Hi Byte
  hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- Change, Low Byte
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

  ASSERT false  REPORT "Performing get_port_status"
  SEVERITY NOTE;
  get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
           wlen => 4, check => check, test_num =>16#b080#);

-------------------------------------------------------------------------------
-- Run the set and clear features on each hub class port change field. These
-- fields are set by a diagnostic only set_feature command and cleared by a
-- clear feature command. Normally, the change bit fields are only set by
-- hardware.
-------------------------------------------------------------------------------
  ASSERT false  REPORT "Performing set/clear of each port change bit."
  SEVERITY NOTE;
  FOR index0 IN 0 TO 4 LOOP  -- for each of the hub class port change bits
    CASE index0 IS
      WHEN  0 => feature_sel := 16; -- C_Port_connect
      WHEN  1 => feature_sel := 17; -- C_Port_enable
      WHEN  2 => feature_sel := 18; -- C_Port_suspend
      WHEN  3 => feature_sel := 19; -- C_Port_over_current
      WHEN  4 => feature_sel := 20; -- C_Port_reset
    END CASE;

 -- Set the change bit.
    test_number := 16#b100# + (index0*16#010#);
    set_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                test_num => test_number);

 -- Get port status and check change field
    test_number := 16#b200# + (index0*16#010#);
    get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
             wlen => 4, check => no_check, test_num => test_number);
    temp_byte := hc_rxpkt_data(2);
    ASSERT (temp_byte(index0) = '1')
    REPORT "Port feature miscompare" SEVERITY FAILURE;

 -- Clear the change bit.
    test_number := 16#b300# + (index0*16#010#);
    clear_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                  test_num => test_number);

 -- Get port status and check change fields
    test_number := 16#b400# + (index0*16#010#);
    get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
             wlen => 4, check => no_check, test_num => test_number);
    temp_byte := hc_rxpkt_data(2);
    ASSERT (temp_byte = "00000000")
    REPORT "Port feature miscompare" SEVERITY FAILURE;

  END LOOP;

-------------------------------------------------------------------------------
-- Test the port power set and clear feature
-------------------------------------------------------------------------------
  ASSERT false  REPORT "Perform port power set and clear feature"
                SEVERITY NOTE;

 -- Set the status field.
    set_feature(rtype => 16#23#, wval => 8, wind => 1,
                test_num => 16#b500#);

 -- Get port status and check status field
    get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
              wlen => 4, check => no_check, test_num => 16#b510#);
    temp_byte := hc_rxpkt_data(1);
    ASSERT (temp_byte = "00000001")
    REPORT "Port feature miscompare" SEVERITY FAILURE;

 -- Clear the status field.
    clear_feature(rtype => 16#23#, wval => 8, wind => 1,
                  test_num => 16#b400# );

 -- Get port status and check status field
    get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
             wlen => 4, check => no_check, test_num => 16#b520#);
    temp_byte := hc_rxpkt_data(1);
    ASSERT (temp_byte = "00000000")
    REPORT "Port feature miscompare" SEVERITY FAILURE;

-------------------------------------------------------------------------------
-- The other port features are tightly coupled with the working status of the
-- hub so they will be tested in other functional tests. For example, the
-- set_port_feature(suspend) will only be interpreted if the port state machine
-- is in the connected and enabled state.
-------------------------------------------------------------------------------

  ASSERT false  REPORT "CHAPTER 11 TEST COMPLETED"
  SEVERITY NOTE;

END IF; -- chapter_11_tests_enabled

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  BEGIN BUS ENUMERATION WITH A HUB.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IF (bus_enumeration_hub_enabled) THEN

  ASSERT false REPORT "BEGINNING HUB ENUMERATION" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Send a Get Descriptor Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#0100#; -- Starting get descriptor send setup token
  ASSERT false  REPORT "Get Device Descriptor from Hub."
    SEVERITY NOTE;

  get_device_desc(test_num => 16#0100#);

  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Send a Set Address Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#0200#; -- Start Set Address Transaction, send a setup
                             -- token
  ASSERT false  REPORT "Assign Address of 0x78 to hub."
    SEVERITY NOTE;
  set_address(16#78#,test_num => 16#0200#);          -- set address to 0x78

  ASSERT false REPORT "Set Address Hub Request Completed" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Assign the configuration values to the Hub.
--------------------------------------------------------------------------------
  test_progress <= 16#0500#; --Start Set Configuration Transaction, send a setup

  ASSERT false  REPORT "Assign Configuration of 0x01 to hub."
    SEVERITY NOTE;

   -- set the configuration value to 01
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => 16#0500#);


  ASSERT false REPORT "Set Configuration Device Request Completed"
  SEVERITY NOTE;

-------------------------------------------------------------------------------
-- Get hub descriptor
-------------------------------------------------------------------------------
  ASSERT false  REPORT "Get Hub Class Hub Descriptor." SEVERITY NOTE;

  test_progress <= 16#0600#;  -- Start enabling downsteam ports
  get_hub_desc(test_num => 16#0600#);

  ASSERT false  REPORT "Get Hub Class Hub Descriptor Completed." SEVERITY NOTE;

-------------------------------------------------------------------------------
-- Set Hub port 1 port powered feature.
-------------------------------------------------------------------------------
  test_progress <= 16#0700#;  -- Start enabling downsteam ports
  feature_sel :=  8;  -- Feature Port_Power
  set_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
              test_num => 16#0700#);

 -- Verify that the port power control signal has been asserted.
  IF (power_dp(1) = '0') THEN
    ASSERT false REPORT "Port power control error"
    SEVERITY FAILURE;
  END IF;

-------------------------------------------------------------------------------
-- Wait for interrupt notification that connection event has occured.
-- Following is the order of the bytes received from get_port_status command:
--  (0) Status, Lo <= {rsv, rsv, rsv, reset,  over_cur, suspend, enable, conn}
--  (1) Status, Hi <= {rsv, rsv, rsv, rsv,    rsv, rsv, low_speed, port_power}
--  (2) Change, Lo <= {rsv, rsv, rsv, reset,  over_cur, suspend, enable, conn}
--  (3) Change, Hi <= {rsv, rsv, rsv, rsv,    rsv, rsv, rsv, rsv}
-------------------------------------------------------------------------------
  test_progress <= 16#0710#; -- Wait for Interrupt indicating connection event
                             -- on downstream port 1.
  -- Perform a connection event on port 1
  connect_dp(1) <= '1';

  ASSERT false REPORT "Wait for interrupt notification of conn event"
  SEVERITY NOTE;

  change_seen := false;  -- Initialize Variable
  WHILE (change_seen = false) LOOP -- Loop until connection event seen
    hand_shake := ack_hs;  -- Initialize Variable
    WHILE (hand_shake /= data_hs AND hand_shake /= nak_hs) LOOP
      token_packet (IN_PID, device_address, endpt => 1);
      data_in_packet(DATA0_PID, 0, 0, hand_shake, no_check); -- Don't chk data
                                                             -- and length
    END LOOP; -- hand_shake /= data_hs

    -- Check to see if interrupt endpoint provided data. If so, Acknowledge.
    IF hand_shake = data_hs THEN
      handshake_out_packet(ACK_PID);
      -- Check port 1 change bit. If set, read port status and check.
      IF ((hc_rxpkt_data(0) AND "00000010") = "00000010") THEN
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#01#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#01#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0800#);

        -- Clear status change field
        ASSERT false  REPORT "Performing clear_port_feature(C_PORT_CONNECTION)"
        SEVERITY NOTE;
        feature_sel := 16; --  Feature C_PORT_CONNECTION
        clear_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                      test_num => 16#0850#);
        -- Check that C_PORT_CONNECTION cleared
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#01#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0810#);

          change_seen := true;
      ELSE
        ASSERT false
        REPORT "No Change Status on Port 1"
        SEVERITY FAILURE;
      END IF;
    END IF;
  END LOOP; -- change seen
  ASSERT false REPORT "Connection event detected" SEVERITY NOTE;


-------------------------------------------------------------------------------
-- Set hub feature port 1 port_reset
-------------------------------------------------------------------------------
  test_progress <= 16#0720#;  -- Start enabling downsteam ports
  -- Clear status change field
  ASSERT false  REPORT "Performing a set_port_feature(RESET)"
  SEVERITY NOTE;
  feature_sel :=  4;  -- Port_reset
  set_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                      test_num => 16#0720#);
  -- Verify that resetting port
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#11#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0800#);

-------------------------------------------------------------------------------
-- Wait for interrupt notification that reset has ended and port is enabled
-------------------------------------------------------------------------------
  test_progress <= 16#0730#; -- Wait for Interrupt indicating connection event
                              -- on downstream port 1.
  ASSERT false REPORT "Wait for interrupt notification of reset completion"
  SEVERITY NOTE;

  change_seen := false;
  WHILE (change_seen = false) LOOP -- Loop until event seen
    hand_shake := ack_hs;  -- Initialize Variable
    WHILE (hand_shake /= data_hs AND  hand_shake /= nak_hs) LOOP
      token_packet (IN_PID, device_address, endpt => 1);
      data_in_packet(DATA1_PID, 0, 0, hand_shake, no_check);
    END LOOP; -- hand_shake /= data_hs

    -- Check to see if interrupt endpoint provided data. If so, Acknowledge.
    IF hand_shake = data_hs THEN
      handshake_out_packet(ACK_PID);
      -- Check port 1 change bit. If set, read status and check.
      IF ((hc_rxpkt_data(0) AND "00000010") = "00000010") THEN
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#03#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#10#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0800#);

        -- Clear status change field
        ASSERT false  REPORT "Performing clear_port_feature(C_PORT_RESET)"
        SEVERITY NOTE;
        feature_sel := 20; --  Feature C_PORT_RESET
        clear_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                     test_num => 16#0850#);
        -- Check that C_PORT_RESET cleared
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#03#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0810#);

        change_seen := true;
        ASSERT false REPORT "Port Successfully Reset and Enabled"
        SEVERITY NOTE;

        ELSE
          ASSERT false
          REPORT "No Change Status on Port 1"
          SEVERITY FAILURE;
        END IF;
    END IF;
  END LOOP; -- change seen

 -- Verify that the port speed control signal has been asserted correctly.
  IF (speed_dp(1) = '0') THEN
    ASSERT false REPORT "Port low_speed control signal error"
    SEVERITY FAILURE;
  END IF;

  ASSERT false REPORT "Wait 3 ms to allow downstream hub to lock" SEVERITY NOTE;
  WAIT FOR 3000000 ns; -- 3 ms
  ASSERT false REPORT "3 ms timeout complete" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Do a Get Descriptor Device Request to verify that the downstream port is
-- functioning correctly.
--------------------------------------------------------------------------------
  ASSERT false  REPORT "Get Device Descriptor for Downstream Device."
  SEVERITY NOTE;
  get_device_desc(16#0800#);
  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;

-------------------------------------------------------------------------------
-- If the hub global suspend test is not enabled, then perform a disconnect.
-------------------------------------------------------------------------------
  IF (hub_global_suspend = false) THEN

    test_progress <= 16#0760#; -- Wait for Interrupt indicating disconnect event
                               -- on downstream port 1.
    -- Perform a disconnect event on port 1
    connect_dp(1) <= '0';

    ASSERT false REPORT "Wait for interrupt notification of disconnect event"
    SEVERITY NOTE;

    change_seen := false;  -- Initialize Variable
    WHILE (change_seen = false) LOOP -- Loop until connection event seen
      hand_shake := ack_hs;  -- Initialize Variable
      WHILE (hand_shake /= data_hs AND hand_shake /= nak_hs) LOOP
        token_packet (IN_PID, device_address, endpt => 1);
        data_in_packet(DATA0_PID, 0, 0, hand_shake, no_check); -- Don't chk data
                                                               -- and length
      END LOOP; -- hand_shake /= data_hs

      -- Check to see if interrupt endpoint provided data. If so, Acknowledge.
      IF hand_shake = data_hs THEN
        handshake_out_packet(ACK_PID);
        -- Check port 1 change bit. If set, read port status and check.
        IF ((hc_rxpkt_data(0) AND "00000010") = "00000010") THEN
          -- Setup the expected port status fields before get_data
          hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- Status, Low Byte
          hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
          hc_pckt_data(2) := conv_std_logic_vector(16#01#,8); -- Change, Low Byte
          hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

          ASSERT false  REPORT "Performing get_port_status"
          SEVERITY NOTE;
          get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                   wlen => 4, check => check, test_num =>16#0800#);

          -- Clear status change field
          ASSERT false  REPORT "Performing clear_port_feature(C_PORT_CONNECTION)"
          SEVERITY NOTE;
          feature_sel := 16; --  Feature C_PORT_CONNECTION
          clear_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                        test_num => 16#0850#);
          -- Check that C_PORT_CONNECTION cleared
          -- Setup the expected port status fields before get_data
          hc_pckt_data(0) := conv_std_logic_vector(16#00#,8); -- Status, Low Byte
          hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
          hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- Change, Low Byte
          hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

          ASSERT false  REPORT "Performing get_port_status"
          SEVERITY NOTE;
          get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                   wlen => 4, check => check, test_num =>16#0810#);

            change_seen := true;
        ELSE
          ASSERT false
          REPORT "No Change Status on Port 1"
          SEVERITY FAILURE;
        END IF;
      END IF;
    END LOOP; -- change seen
    ASSERT false REPORT "Disconnect event detected" SEVERITY NOTE;
  END IF; -- disconnect since hub global suspend not enabled

  ASSERT false REPORT "END BUS ENUMERATION WITH HUB" SEVERITY NOTE;

END IF;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  BEGIN GLOBAL SUSPEND TEST.
--  Note that this test must be run after the bus_enumeration_hub test
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IF (hub_global_suspend) THEN

  ASSERT false REPORT "BEGINNING GLOBAL SUSPEND TEST" SEVERITY NOTE;
-----------------------
-- Suspend the Hub.
-----------------------
  test_progress <= 16#1700#; -- Start idle on the bus

  ASSERT false REPORT "Suspend the Hub with bus idle for 6 ms" SEVERITY NOTE;
  hc_state <= hc_suspend;
  sof_enable <= false;  -- Stop generating sof's
  WAIT FOR 6000000 ns;  -- 6 ms

-------------------------------------
-- Wakeup the Hub with Global resume.
-------------------------------------
  test_progress <= 16#1710#; -- Start resume on the bus

 -- Wakeup Hub with Global Resume.
  ASSERT false REPORT "Resume signaling for 2 ms" SEVERITY NOTE;
  usb_resume(2000000 ns);   -- 2 ms

-- Re-enable sof generation.
  sof_enable <= true;

 -- Wait for frame lock if not forced.
  IF wait_for_frame_lock_enable THEN
    -- Wait 3 ms for hub to acquire frame lock
    ASSERT false
    REPORT "Wait 3 ms to allow hub to lock" SEVERITY NOTE;
    WAIT FOR 3000000 ns; -- 3 ms
  END IF;

--------------------------------------------------------------------------------
-- Do a Get Descriptor Device Request to verify hub up and running
--------------------------------------------------------------------------------
  ASSERT false  REPORT "Get Device Descriptor." SEVERITY NOTE;
  get_device_desc(16#0800#);
  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;

-----------------------
-- Suspend the Hub.
-----------------------
  test_progress <= 16#1700#; -- Start idle on the bus

  ASSERT false REPORT "Suspend the Hub with bus idle for 6 ms" SEVERITY NOTE;
  hc_state <= hc_suspend;
  sof_enable <= false;  -- Stop generating sof's
  WAIT FOR 6000000 ns;  -- 6 ms

-------------------------------------
-- Wakeup the Hub with Global reset.
-------------------------------------
  test_progress <= 16#1720#; -- Start reset on the bus
 -- Wakeup HUB with Reset signaling.
    ASSERT false REPORT "Reset signaling for 3 ms" SEVERITY NOTE;
    usb_reset(3000000 ns);   -- 3 ms

-- Re-enable sof generation.
  sof_enable <= true;

 -- Wait for frame lock if not forced.
  IF wait_for_frame_lock_enable THEN
    -- Wait 3 ms for hub to acquire frame lock
    ASSERT false
    REPORT "Wait 3 ms to allow hub to lock" SEVERITY NOTE;
    WAIT FOR 3000000 ns; -- 3 ms
  END IF;
--------------------------------------------------------------------------------
-- Do a Get Descriptor Device Request to verify hub up and running
--------------------------------------------------------------------------------
  ASSERT false  REPORT "Get Device Descriptor." SEVERITY NOTE;
  get_device_desc(16#0800#);
  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Enable down stream port 1 so that it may initate a remote wakeup later.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Send a Set Address Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#1733#; -- Start Set Address Transaction, send a setup
                             -- token
  ASSERT false  REPORT "Assign Address of 0x78 to hub."
    SEVERITY NOTE;
  set_address(16#78#,test_num => 16#0200#);          -- set address to 0x78

  ASSERT false REPORT "Set Address Hub Request Completed" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- Assign the configuration values to the Hub.
--------------------------------------------------------------------------------
  test_progress <= 16#1734#; --Start Set Configuration Transaction, send a setup

  ASSERT false  REPORT "Assign Configuration of 0x01 to hub."
    SEVERITY NOTE;

   -- set the configuration value to 01
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => 16#0500#);


  ASSERT false REPORT "Set Configuration Device Request Completed"
  SEVERITY NOTE;

-------------------------------------------------------------------------------
-- Set Hub port 1 port powered feature.
-------------------------------------------------------------------------------
  test_progress <= 16#0735#;  -- Start enabling downsteam ports
  feature_sel :=  8;  -- Feature Port_Power
  set_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
              test_num => 16#0700#);

 -- Verify that the port power control signal has been asserted.
  IF (power_dp(1) = '0') THEN
    ASSERT false REPORT "Port power control error"
    SEVERITY FAILURE;
  END IF;

-------------------------------------------------------------------------------
-- Wait for interrupt notification that connection event has occured.
-- Following is the order of the bytes received from get_port_status command:
--  (0) Status, Lo <= {rsv, rsv, rsv, reset,  over_cur, suspend, enable, conn}
--  (1) Status, Hi <= {rsv, rsv, rsv, rsv,    rsv, rsv, low_speed, port_power}
--  (2) Change, Lo <= {rsv, rsv, rsv, reset,  over_cur, suspend, enable, conn}
--  (3) Change, Hi <= {rsv, rsv, rsv, rsv,    rsv, rsv, rsv, rsv}
-------------------------------------------------------------------------------
  test_progress <= 16#0736#; -- Wait for Interrupt indicating connection event
                             -- on downstream port 1.
  -- Perform a connection event on port 1
  connect_dp(1) <= '1';

  ASSERT false REPORT "Wait for interrupt notification of conn event"
  SEVERITY NOTE;

  change_seen := false;  -- Initialize Variable
  WHILE (change_seen = false) LOOP -- Loop until connection event seen
    hand_shake := ack_hs;  -- Initialize Variable
    WHILE (hand_shake /= data_hs AND hand_shake /= nak_hs) LOOP
      token_packet (IN_PID, device_address, endpt => 1);
      data_in_packet(DATA0_PID, 0, 0, hand_shake, no_check); -- Don't chk data
                                                             -- and length
    END LOOP; -- hand_shake /= data_hs

    -- Check to see if interrupt endpoint provided data. If so, Acknowledge.
    IF hand_shake = data_hs THEN
      handshake_out_packet(ACK_PID);
      -- Check port 1 change bit. If set, read port status and check.
      IF ((hc_rxpkt_data(0) AND "00000010") = "00000010") THEN
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#01#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#01#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0800#);

        -- Clear status change field
        ASSERT false  REPORT "Performing clear_port_feature(C_PORT_CONNECTION)"
        SEVERITY NOTE;
        feature_sel := 16; --  Feature C_PORT_CONNECTION
        clear_feature(rtype => 16#23#, wval => feature_sel, wind => 1,
                      test_num => 16#0850#);
        -- Check that C_PORT_CONNECTION cleared
        -- Setup the expected port status fields before get_data
        hc_pckt_data(0) := conv_std_logic_vector(16#01#,8); -- Status, Low Byte
        hc_pckt_data(1) := conv_std_logic_vector(16#01#,8); -- Status, Hi Byte
        hc_pckt_data(2) := conv_std_logic_vector(16#00#,8); -- Change, Low Byte
        hc_pckt_data(3) := conv_std_logic_vector(16#00#,8); -- Change, Hi Byte

        ASSERT false  REPORT "Performing get_port_status"
        SEVERITY NOTE;
        get_data(rtype => 16#a3#, bReq => 0, wval => 0, wind => 1,
                 wlen => 4, check => check, test_num =>16#0810#);

          change_seen := true;
      ELSE
        ASSERT false
        REPORT "No Change Status on Port 1"
        SEVERITY FAILURE;
      END IF;
    END IF;
  END LOOP; -- change seen
  ASSERT false REPORT "Connection event detected" SEVERITY NOTE;

  test_progress <= 16#1737#; -- Start idle on the bus

  -- Set feature remote wakeup enable
  ASSERT false  REPORT "Attempt a set feature remote wakeup."
  SEVERITY NOTE;
  set_feature(rtype => 0, wval => 1, wind => 0, test_num =>16#1730# );

-----------------------
-- Suspend the Hub.
-----------------------
  ASSERT false REPORT "Suspend the Hub with bus idle for 6 ms" SEVERITY NOTE;
  test_progress <= 16#1738#; -- Start idle on the bus
  hc_state <= hc_suspend;
  sof_enable <= false;  -- Stop generating sof's
  WAIT FOR 6000000 ns;  -- 6 ms

-------------------------------------
-- Wakeup the Hub with remote wakeup.
-------------------------------------

 -- Wakeup Hub with Remote wakeup signaling.
  test_progress <= 16#1740#; -- Start resume on the bus
  ASSERT false REPORT "Initiate a remote wakeup" SEVERITY NOTE;

  rmt_wake_dp(1) <= '1';
  WAIT UNTIL (dplus = '0' AND dminus = '1'); -- Resume signaling detected.
  WAIT FOR 10 ns;                                -- just so you can see the
                                             -- upstream and downstream
                                             -- propogation.
  rmt_wake_dp(1) <= '0';

 -- Assert resume signaling downstream
  ASSERT false REPORT "Resume signaling for 2 ms" SEVERITY NOTE;
  usb_resume(2000000 ns);    -- 2.0 ms

 -- Re-enable sof generation.
  sof_enable <= true;

 -- Wait for frame lock if not forced.
  IF wait_for_frame_lock_enable THEN
    -- Wait 3 ms for hub to acquire frame lock
    ASSERT false
    REPORT "Wait 3 ms to allow hub to lock" SEVERITY NOTE;
    WAIT FOR 3000000 ns; -- 3 ms
  END IF;

--------------------------------------------------------------------------------
-- Do a Get Descriptor Device Request to verify hub up and running
--------------------------------------------------------------------------------
  ASSERT false  REPORT "Get Device Descriptor." SEVERITY NOTE;
  get_device_desc(16#0800#);
  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;
    test_progress <= 16#0760#; -- Wait for Interrupt indicating disconnect event
                               -- on downstream port 1.

  ASSERT false REPORT "DONE GLOBAL SUSPEND TEST" SEVERITY NOTE;
END IF;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Start enumeration of target device
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IF bus_enumeration_target_enabled THEN
  ASSERT false REPORT "Begining target device enumeration" SEVERITY NOTE;

  -- if we just enumerated the hub then reset the current device address to 0
  -- for the target.
  IF bus_enumeration_hub_enabled THEN
    device_address := 0; -- reset the current device address
  END IF;

--------------------------------------------------------------------------------
-- Send a Get Descriptor Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#0800#; -- Starting get descriptor send setup token
  ASSERT false  REPORT "Get Device Descriptor."
    SEVERITY NOTE;

  get_device_desc(16#0800#);

  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;
--------------------------------------------------------------------------------
-- End Get Descriptor Device Request
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Send a Set Address Device Request
--------------------------------------------------------------------------------
  test_progress <= 16#0900#; -- Start Set Address Transaction, send a setup
                             -- token
  ASSERT false  REPORT "Assign Address of 0x07 to device."
    SEVERITY NOTE;
  set_address(7,16#0900#);               -- set address to 7

  ASSERT false REPORT "Set Address Device Request Completed" SEVERITY NOTE;
--------------------------------------------------------------------------------
-- End Set Address Device Request
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Read the configuration data of each configuration
--------------------------------------------------------------------------------
  test_progress <= 16#0b00#;  -- Starting get configuration descriptor, send
                              -- setup token
  ASSERT false  REPORT "Get Configuration Descriptor."
    SEVERITY NOTE;

  get_config_desc(16#0b00#);      -- get the configuration descriptor

  ASSERT false REPORT "Get Configuration Descriptor Completed" SEVERITY NOTE;

--------------------------------------------------------------------------------
-- End Read of the configuration data of each configuration
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Assign the configuration values to the Device.
--------------------------------------------------------------------------------
  test_progress <= 16#0c00#; -- Start Set Configuration Transaction, send a setup
                             -- token
  ASSERT false  REPORT "Assign Configuration of 0x01 to device."
    SEVERITY NOTE;

   -- set the configuration value to 01
  set_value(breq => 9, wval => 16#01#, wind => 0, test_num => 16#0c00#);


  ASSERT false REPORT "Set Configuration Device Request Completed" SEVERITY NOTE;


--------------------------------------------------------------------------------
-- End of the configuration value assignments to the Device.
--------------------------------------------------------------------------------

  ASSERT false REPORT "Bus Enumeration Completed." SEVERITY NOTE;

-------------------------------------------------------------------------------
-- Send a couple of cycles worth of bulk data.
-------------------------------------------------------------------------------
  test_progress <= 16#0d00#;             -- Send SOF packets

  -- By completing the set configuration above :
  --   Endpoint 0 is configured as a control endpoint
  --   Endpoint 1 is configured as an ISO audio streaming endpoint
  --   Endpoint 2 is configured as a Bulk output endpoint

  -- Send an 8 byte data packet to the bulk and iso endpoint.
  hc_pckt_data(0) := conv_std_logic_vector(16#f1#,8); -- 1ef1
  hc_pckt_data(1) := conv_std_logic_vector(16#1e#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#01#,8); -- 0001
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(4) := conv_std_logic_vector(16#02#,8); -- 0002
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#03#,8); -- 0003
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);


  ASSERT false REPORT "Send an iso data packet." SEVERITY NOTE;
  ASSERT terse REPORT "Send an out data token." SEVERITY NOTE;

  token_packet (OUT_PID, device_address, endpt => 1);

  ASSERT terse REPORT "Send the iso data packet." SEVERITY NOTE;
  data_out_packet(DATA0_PID,8);

  ASSERT false REPORT "Send a bulk data packet." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 3);

    ASSERT terse REPORT "sending bulk data packet" SEVERITY NOTE;
    data_out_packet(DATA0_PID,8);

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;                          --  hand_shake /= ack_hs

  -- send a SOF packets
  WAIT UNTIL sof_request'event AND sof_request = '1';

  -- Send an 8 byte data packet to the bulk and iso endpoints.
  hc_pckt_data(0) := conv_std_logic_vector(16#f1#,8); -- 1ef1
  hc_pckt_data(1) := conv_std_logic_vector(16#1e#,8);
  hc_pckt_data(2) := conv_std_logic_vector(16#04#,8); -- 0004
  hc_pckt_data(3) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(4) := conv_std_logic_vector(16#05#,8); -- 0005
  hc_pckt_data(5) := conv_std_logic_vector(16#00#,8);
  hc_pckt_data(6) := conv_std_logic_vector(16#06#,8); -- 0006
  hc_pckt_data(7) := conv_std_logic_vector(16#00#,8);

  ASSERT false REPORT "Send an iso data packet." SEVERITY NOTE;
  ASSERT terse REPORT "Send an out data token." SEVERITY NOTE;

  token_packet (OUT_PID, device_address, endpt => 1);

  ASSERT terse REPORT "Send the iso data packet." SEVERITY NOTE;
  data_out_packet(DATA0_PID,8);          -- note that iso's are always to data0


  ASSERT false REPORT "Send a bulk data packet." SEVERITY NOTE;
  hand_shake := nak_hs;
  WHILE hand_shake /= ack_hs LOOP

    token_packet(OUT_PID, device_address, endpt => 3);

    ASSERT terse REPORT "sending bulk data packet" SEVERITY NOTE;
    data_out_packet(DATA1_PID,8);

    ASSERT NOT verbose REPORT "Check hand-shake." SEVERITY NOTE;
    handshake_in_packet (hand_shake);
    ASSERT (hand_shake = ack_hs) OR NOT verbose
      REPORT "Didn't get the ack repeat the out transaction" SEVERITY NOTE;
  END LOOP;                          --  hand_shake /= ack_hs
                                         --


-------------------------------------------------------------------------------
-- End the bulk and iso testing.
-------------------------------------------------------------------------------

END IF; -- bus enumeration enabled

-------------------------------------------------------------------------------
-- Send one out transaction to a low speed device thru a hub.
-------------------------------------------------------------------------------
IF (low_speed_thru_hub_enabled ) THEN
  ASSERT terse REPORT "Starting sending low speed packet through hub"
    SEVERITY NOTE;
  -- make an incrementing packet in hc pkt data
  seed := 0;
  build_hc_packet(byte_cnt => 8, strt_data => 0, data_pat => inc, seed => seed);

  --  send out the PRE PID using high speed signalling
  clock_low_speed <= false;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
  WAIT UNTIL usb_clk'event AND usb_clk = '1';
  eop_time := usb_bit_time * 2;

  handshake_out_packet(PRE_PID);

  -- set the clocks to low speed
  clock_low_speed <= true;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
  WAIT UNTIL usb_clk'event AND usb_clk = '1';
  eop_time := usb_bit_time * 2;

  -- send the low speed token packet
  token_packet(OUT_PID, device_address, endpt => 0);

  -- set the clocks to full speed
  clock_low_speed <= false;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
  WAIT UNTIL usb_clk'event AND usb_clk = '1';
  eop_time := usb_bit_time * 2;

  -- Send the PRE PID
  handshake_out_packet(PRE_PID);

  -- set the clocks to low speed
  clock_low_speed <= true;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
  WAIT UNTIL usb_clk'event AND usb_clk = '1';
  eop_time := usb_bit_time * 2;

  -- send a low speed data packet.
  data_out_packet(DATA0_PID,8);

  -- restore the clocks to full speed.
  clock_low_speed <= false;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for two clocks
  WAIT UNTIL usb_clk'event AND usb_clk = '1';
  eop_time := usb_bit_time * 2;

  ASSERT terse REPORT "low speed token and packet sent (not self checking)."
    SEVERITY NOTE;


END IF; -- low_speed_thru_hub_enabled
--------------------------------------------------------------------------------
-- Start the quick check test code.
--------------------------------------------------------------------------------
IF quick_check_enabled THEN

  ASSERT false REPORT "Starting quick USB Compiance Check."
    SEVERITY NOTE;


--**************************************************
--Skip until the else clause of this if  search for ZZZZZZ-
--**************************************************
IF false THEN                            -- used to skip a section of code
  test_progress <= 16#ffff#;             -- never executed
--**************************************************ZZZZZZ
--**************************************************ZZZZZZ
ELSE              -- false - end of skipped section ZZZZZZ
                  -- move these lines to skip over  ZZZZZZ
                  -- tests that you don't want to   ZZZZZZ
                  -- run right now.                 ZZZZZZ
--**************************************************ZZZZZZ


  test_progress <= 16#05000#;            -- Start Peripheral Quick Check

  ASSERT false REPORT "Starting Peripheral Silcon quick check."
    SEVERITY NOTE;

  ASSERT false REPORT "Perform the Bus Time Out (BTO) tests."
    SEVERITY NOTE;
  ASSERT false REPORT "Performing TRD4,TRD5,TRD6,TRD7 tests:"
    SEVERITY NOTE;
  ASSERT false REPORT "turnaround min,turnaround max,bto min,bto max"
    SEVERITY NOTE;
  bto_test(16#05000#);


  test_progress <= 16#05010#;            -- Reset Test


  ASSERT false REPORT "Try the reset test."
    SEVERITY NOTE;
  ASSERT false REPORT "Skip the reset test because it takes 3 ms."
    SEVERITY NOTE;
--  reset_test;

  test_progress <= 16#05020#;            -- Resume Test

  ASSERT false REPORT "Skip the resume test because it takes 29 ms."
    SEVERITY NOTE;
--  resume_test;

  test_progress <= 16#05030#;            -- CRC Bitstuff test with skew

  ASSERT false REPORT "Try the crc bitstuff test with skew."
    SEVERITY NOTE;
  differential_skew := 16 ns;
  crc_bitstuff_test;                     -- sends and recieves a high speed
  differential_skew := 0 ns;

  test_progress <= 16#05040#;            -- TX PID test

  ASSERT false REPORT "Try the tx_pid test."
    SEVERITY NOTE;
  tx_pid_test(16#05040#);                -- force the target to return all
                                         -- possible PID's for checking.

  test_progress <= 16#05050#;            -- Min / Max EOP time

  ASSERT false REPORT "Test the min and max EOP length bounds."
    SEVERITY NOTE;

  WAIT FOR 500000 ns;                       -- wait for software to recover

  eop_time := usb_bit_time;
  get_device_desc(16#05050#);
  -- Set eop_time to USB 1.1 max EOP times
  if lsdev = 1 then
    eop_time := 1760 ns;  -- Peripheral Silcon test LS11
  else
    eop_time := 250 ns;   -- Peripheral Silcon test FS13
  end if;
  get_device_desc(16#05058#);
  eop_time := usb_bit_time * 2;

  test_progress <= 16#05060#;            -- Iso echo test
  ASSERT false REPORT "Running a simple ISO echo test."
    SEVERITY NOTE;

  -- If HS device use data length of 64 bytes, else use 8 bytes
  IF lsdev = 0 THEN
    iso_echo_test(endpt => 2, dlength => 64, dpat => INC, dstart => 0,
                 bogus_hndshk => 0, sof_wait => false);
  ELSE
    iso_echo_test(endpt => 2, dlength => 8, dpat => INC, dstart => 0,
                 bogus_hndshk => 0, sof_wait => false);
  END IF;

  test_progress <= 16#05070#;            -- Min Max packet size test
  ASSERT false REPORT "Test the min and max packet length bounds."
    SEVERITY NOTE;
  min_max_data_test(16#05070#);

  test_progress <= 16#050a0#;            -- crc bitstuff with truncated sync
  ASSERT false REPORT "Try crc bitstuff test with Truncated Sync."
    SEVERITY NOTE;
  ASSERT false REPORT "Testing BST2  - Truncated Sync is accepted."
    SEVERITY NOTE;
  force_truncate_sync := 1;              -- skip part of the first
                                         -- sync bit
  sync_delay_time := 41 ns;
  crc_bitstuff_test;

  sync_delay_time := 1 ns;
  force_truncate_sync := 0;

  ASSERT false REPORT "Testing FLT1  - Truncated Sync is recognized as valid."
    SEVERITY NOTE;
  test_progress <= 16#050a9#;

  force_truncate_sync := 2;              -- skip the first 2 sync bits
  crc_bitstuff_test;
  force_truncate_sync := 0;

  test_progress <= 16#050b0#;            -- single ended signalling test
  ASSERT false REPORT "Try single ended signalling test."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST3  - Differencial input ignored when Single Ended."
    SEVERITY NOTE;
  single_ended_test;

  test_progress <= 16#050d0#;            -- PLL test test
  ASSERT false REPORT "Perform the PLL test."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST5  - Target adjusts to incoming frequency and phase."
    SEVERITY NOTE;
  -----------------------------------------------------------------------------
  -- To test the phase lock loop we will run at clock slow clock fast , and we
  -- will do a maximum phase invertion between interation of the crc test.
  -----------------------------------------------------------------------------
  pll_test(16#050d0#);

  test_progress <= 16#050e0#;            -- bitstuff error reject test
  ASSERT false REPORT "Perform the bitstuff error reject test."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST6  - A packet with a bitstuff error is rejected."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST7  - A non-packet with a bitstuff error is rejected."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST8  - A bitstuff error on the last bit causes rejection."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST9  - Bit stuffing is done even on the last bit of a packet."
    SEVERITY NOTE;
  bit_stuff_reject_test(16#050e0#);

  test_progress <= 16#050f0#;            -- field error reject test
  ASSERT false REPORT "Try the field error reject test."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT2  - Packets with undefined PIDs are ignored."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT3  - Packets with errors the PID are ignored."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT4  - Packets with crc5  errors are ignored."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT5  - data packets with crc errors are ignored."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT6  - Packets with short EOP SE0 pulses are ignored."
    SEVERITY NOTE;

  field_error_reject_test;

  test_progress <= 16#05100#;            -- Wrong address / endpoint reject test
  ASSERT false REPORT "Address and endpoint  reject test."
    SEVERITY NOTE;
  ASSERT false REPORT
    "Testing PKT1 - non-matching addresses are ignored"  & LF &
    "Testing PKT2 - non-matching endpoint numbers are ignored"
    SEVERITY NOTE;
  addr_endpt_reject_test(16#050f0#);

  test_progress <= 16#05130#;            -- token restart test
  ASSERT false REPORT "token restart test."
    SEVERITY note;
  ASSERT false REPORT
    "Testing TRT2 - receipt of a token starts a new transaction and " & LF &
    "               ends a pending one."
    SEVERITY note;
  token_restart_test(16#24020#);

END IF;                                  -- false (skip range)
END IF;                                  -- quick_check_enabled
--------------------------------------------------------------------------------
-- Start Checklist test code.
--------------------------------------------------------------------------------
IF checklist_enabled THEN

  test_progress <= 16#10000#;            -- Start Peripheral Silicon Check
                                         -- list.

  -----------------------------------------------------------------------------
  --
  -----------------------------------------------------------------------------
  ASSERT false REPORT "Starting Peripheral Silcon USB Compiance Checklist."
    SEVERITY NOTE;
  -----------------------------------------------------------------------------
  --
  -----------------------------------------------------------------------------

  ASSERT false REPORT "Starting Bit Steam tests." SEVERITY NOTE;
  -- Bitstream

  --    BSD1 Is >=2500 ns of NIB 0 anywhere in a bitstream recognized on
  --         the root port of a device as a USB RESET? 7.1.4.3
  test_progress <= 16#11010#;           --    BSD1

  -- This item is not completely testable.  However, we will initiate a couple
  -- of packets and then reset in the middle of them.  The coverage provided
  -- will be poor.

  ASSERT false REPORT "Testing BSD1 - Reset Test." SEVERITY NOTE;
  reset_test;


  --    BSD2 Is >=2500 ns of NIB 0 anywhere in a bitstream recognized by the
  --         host or the downstream port of a hub as a disconnect event?
  --         7.1.4.1
  test_progress <= 16#11020#;--    BSD2
  ASSERT false REPORT "        BSD2 - host only not applicable" SEVERITY NOTE;

  --    BSD3 Is >=2500 ns of NIB J recognized by the host or a downstream
  --         port of a hub as a connect event? 7.1.4.1
  test_progress <= 16#11030#;--    BSD3
  ASSERT false REPORT "        BSD3 - host only not applicable" SEVERITY NOTE;

  --    BSD4 Is >=20 ms of NIB K followed by an EOP recognized as an end of
  --         resume event by a target? 11.5.1
  test_progress <= 16#11040#;--    BSD4

  --    BSD5 Does any transition from the J state on the root port of a
  --         suspended device wakeup the device? 7.1.4.5
  test_progress <= 16#11050#;--    BSD5
  ASSERT false REPORT "Testing BSD4 and BSD5 - Resume Test" SEVERITY NOTE;
  resume_test(test_num => 16#11050#);


  --    BSD6 Is the possibility of a NIB 1 <1 bit time during bus
  --         transitions accounted for? 7.1.13
  test_progress <= 16#11060#;--    BSD6

  --    BSD7 Is the sense of signaling on a link either full-speed or
  --         low-speed but not both? 11.2.5
  test_progress <= 16#11070#;--    BSD7

  --    BSD8 Does the sense of signaling on a link correspond to speed of
  --         link? 7.1.4
  test_progress <= 16#11080#;--    BSD8

  --    BSD9 Is the bitstream on the bus nrzi encoded? 7.1.5
  test_progress <= 16#11090#;--    BSD9

  --    BSD10 Does the bitstream on the bus implement bit stuffing prior to
  --         transmission? 7.1.6
  test_progress <= 16#11100#;--    BSD10

  --    BSD11 Does the CRC bitstream on the bus implement bit stuffing?
  --         8.3.5
  test_progress <= 16#11110#;--    BSD11

  --    BSD12 Is bit stuffing implemented even if a stuffed bit is required
  --         after the last bit of the packet? 8.3.5
  test_progress <= 16#11120#;--    BSD12

  --    BSD13 Is bit stuffing done after the CRC computation on the
  --         transmitted bit stream? 8.3.5
  test_progress <= 16#11130#;--    BSD13

  --    BSD14 Is nrzi encoding done after the bit stuffing on the
  --         transmitted bit stream? 7.1.6
  test_progress <= 16#11140#;--    BSD14

  --    BSD15 Is nrzi->nrz decoding done before bit unstuffing? 7.1.6
  test_progress <= 16#11150#;--    BSD15

  --    BSD16 Is bit unstuffing done before the bitstream is parsed? 7.1.6
  test_progress <= 16#11160#;--    BSD16

  ASSERT false REPORT "Testing BSD6  - signal skew NIB 1" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD7  - high speed signalling" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD8  - signal sense match speed" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD9  - nrzi encoding" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD10 - bit stuffing" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD11 - bit stuffing in CRC" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD12 - bit stuffing on last bit of packet" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD13 - bit stuffing in crc" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD14 - nrzi encoding" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD15 - nrz decoding" SEVERITY NOTE;
  ASSERT false REPORT "Testing BSD16 - bit unstuffing 1" SEVERITY NOTE;
  --  the skew between the differencial signals is not well specified in the
  -- USB specification.  A worst case skew specification of 16 ns can be derived
  -- from the rise and fall time specification.
  differential_skew := 16 ns;
  crc_bitstuff_test;                     -- sends and recieves a high speed
                                         -- refference packet that tests crc,
                                         -- bit stuffing, nrz encoding and
                                         -- default line states.
  differential_skew := 0 ns;

  -- perform get_device_desc to set device_max_pkt to value expected by
  -- software.
  test_progress <= 16#0100#; -- Starting get descriptor send setup token
  ASSERT false  REPORT "Get Device Descriptor."
    SEVERITY NOTE;

  get_device_desc(test_num => 16#11170#);

  ASSERT false REPORT "Get Device Descriptor Completed" SEVERITY NOTE;

  --    Field
  --    A field  can be
  --    sync  		- 8 bit field with NZB  value 00000001
  --    PID     		- listed in Table 8-1 of spec
  --    address		- 7 bit field
  --    endpoint		- 4 bit field
  --    frame number	- 11 bit field
  --    token CRC	- 5 bit field
  --    data		- 0 to 1023 byte field
  --    data CRC	- 16 bit field
  --    EOP		- 3 bit field with NIB value 00J
  --    Name Test description Spec sec Status

  --    FLD1 Is the sync field as measured on the bus wires correct i.e NIB
  --         KJKJKJKK? 8.2
  -----------------------------------------------------------------------------
  -- This is checked on every receive packet
  -----------------------------------------------------------------------------
  test_progress <= 16#12010#;--    FLD1
  --    FLD2 Is the packet type in the PID one of those listed in Table 8-1
  --         8.3.1

  test_progress <= 16#12020#;--    FLD2

  --    FLD3 Is the PID check the one's complement of the packet type
  --         field 8.3.1
  -----------------------------------------------------------------------------
  -- This is checked on every receive packet
  -----------------------------------------------------------------------------
  test_progress <= 16#12030#;--    FLD3


  ASSERT false REPORT "Testing FLD1  - Sync field check" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD2  - PID valid check" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD3  - PID check field check" SEVERITY NOTE;
  tx_pid_test(16#12030#);                -- force the target to return all
                                         -- possible PID's for checking.
  --    FLD4 Is the token CRC generated with the polynomial NZB 00101 on
  --         address-endpoint/frame number fields 8.3.5.1
  test_progress <= 16#12040#;--    FLD4
  ASSERT false REPORT "        FLD4 - host only not applicable" SEVERITY NOTE;

  --    FLD5 Does the CRC computation on a token/SOF bitstream leave a
  --         residual of NZB 01100 at the EOP 8.3.5.1
  test_progress <= 16#12050#;--    FLD5
  ASSERT false REPORT "        FLD5 - host only not applicable" SEVERITY NOTE;

  --    FLD6 Is the data CRC generated with the polynomial
  --         NZB1000000000000101 on the data field 8.3.5.2
  test_progress <= 16#12060#;--    FLD6

  --    FLD7 Does the CRC computation on a data packet bitstream leave a
  --         residual of NZB 1000000000001101 at the EOP 8.3.5.2
  test_progress <= 16#12070#;--    FLD7
  ASSERT false REPORT "Testing FLD6  - CRC-16 polinomial check" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD7  - CRC-16 remainder check" SEVERITY NOTE;
  crc_bitstuff_test;

  --    FLD8 Is the 7-bit address field sent out LSB first on the bus
  --         8.3.2.1
  test_progress <= 16#12080#;--    FLD8
  ASSERT false REPORT "        FLD8 - host only not applicable" SEVERITY NOTE;

  --    FLD9 Is the 4-bit endpoint field sent out LSB first on the bus
  --         8.3.2.2
  test_progress <= 16#12090#;--    FLD9
  ASSERT false REPORT "        FLD9 - host only not applicable" SEVERITY NOTE;

  --    FLD10 Is the 11-bit frame number field sent out LSB first on the
  --         bus 8.3.3
  test_progress <= 16#12100#;--    FLD10
  ASSERT false REPORT "        FLD10 - host only not applicable" SEVERITY NOTE;

  --    FLD11 Is each data byte in the data field sent out LSB first 8.3.4
  -- to test this we will do a get device descriptor request which has a known
  -- data response.
  test_progress <= 16#12110#;--    FLD11
  --    FLD12 Is the CRC shift register contents inverted to form the CRC
  --         field 8.3.5
  -- this is tested on every in data packet.
  test_progress <= 16#12120#;--    FLD12

  --    FLD13 Is the CRC field sent out MSB first 8.3.5
  -- this is tested on every in data packet
  test_progress <= 16#12130#;--    FLD13

  --    FLD14 Is the EOP correctly consituted i.e NIB 00J 7.1.11.2
  -- this is tested on every in data packet or handshake packet.
  test_progress <= 16#12140#;--    FLD14
  --    FLD15 Does a full-speed receiver (on a non-hub device) recognize
  --         82ns to 2500 ns of NIB 0 followed by a J transition as a
  --         valid EOP 7.1.12
  ASSERT false REPORT "Testing FLD11 - Data bit ordering" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD12 - CRC-16 inverted before transmission" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD13 - CRC-16 bit ordering" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD14 - EOP check" SEVERITY NOTE;
  ASSERT false REPORT "Testing FLD15 - CRC-16 remainder check" SEVERITY NOTE;
  test_progress <= 16#12150#;   --    FLD15
  eop_time := usb_bit_time;
  get_device_desc(16#12150#);

  --
  -- Maximum length of EOP is < 415 ns (high speed)
  --    (comment excerpt from usb_sie.vhd)
  --    -- We only want to wait for the EOP for a short
  --    -- period of time, if we do not get it return to IDLE
  --  eop_time := 2000 ns;
  -- Set eop_time to USB 1.1 max EOP times
  if lsdev = 1 then
    eop_time := 1760 ns;  -- Peripheral Silcon test LS11
  else
    eop_time := 400 ns;   -- Peripheral Silcon test FS13
  end if;
  get_device_desc(16#12155#);
  eop_time := usb_bit_time * 2;

  --    FLD16 Does a low-speed receiver (on a non-hub device) recognize 670
  --         ns to 2500 ns of NIB 0 followed by a J transition as a valid
  --         EOP 7.1.12
  test_progress <= 16#12160#;--    FLD16
  ASSERT false REPORT "        FLD16 - low speed  only not applicable" SEVERITY NOTE;

  --    FLD17 Does a low speed device recognize low-speed keepalive strobes
  --         11.2.5.1
  test_progress <= 16#12170#;--    FLD17
  ASSERT false REPORT "        FLD17 - low speed  only not applicable" SEVERITY NOTE;

  --    FLD18 Does a low speed device support one control endpoint and at
  --         most two other endpoint numbers 8.3.2.2
  test_progress <= 16#12180#;--    FLD18
  ASSERT false REPORT "        FLD18 - low speed  only not applicable" SEVERITY NOTE;

  --    FLD19 Are the endpoints on a low speed device either control or
  --         interrupt type 8.3.2.2
  test_progress <= 16#12190#;--    FLD19
  ASSERT false REPORT "        FLD19 - low speed  only not applicable" SEVERITY NOTE;

  --    Packet
  --    A packet is made up of fields which are formatted as described in
  --    sec. 8.4 of spec and can be one of the following:
  --    PRE		-  sync pid
  --    SOF		-  sync pid timestamp tokenCRC eop
  --    Token		-  sync pid addr endpt tokenCRC eop
  --    data		-  sync pid data.......... data  dataCRC eop
  --    handshake	-  sync pid eop

  --    PKD1 Is the PRE packet 16 bits long 8.6.5
  test_progress <= 16#13010#;--    PKD1
  ASSERT false REPORT "        PKD1 - host only not applicable" SEVERITY NOTE;
  --    PKD2 Is the PRE packet constituted as sync followed by PID 8.6.5
  test_progress <= 16#13020#;--    PKD2
  ASSERT false REPORT "        PKD2 - host only not applicable" SEVERITY NOTE;

  --    PKD3 Is the Token packet 32 bits + EOP 8.4.1
  test_progress <= 16#13030#;--    PKD3
  ASSERT false REPORT "        PKD3 - host only not applicable" SEVERITY NOTE;

  --    PKD4 Is the token constituted as sync followed by PID followed by
  --         address followed by endpoint followed by token CRC followed
  --         by EOP 8.4.1
  test_progress <= 16#13040#;--    PKD4
  ASSERT false REPORT "        PKD4 - host only not applicable" SEVERITY NOTE;

  --    PKD5 Is the SOF packet 32 bits + EOP 8.4.2
  test_progress <= 16#13050#;--    PKD5
  ASSERT false REPORT "        PKD5 - host only not applicable" SEVERITY NOTE;

  --    PKD6 Is the SOF constituted as sync followed by PID followed by
  --         frame number followed by token CRC followed by EOP 8.4.2
  test_progress <= 16#13060#;--    PKD6
  ASSERT false REPORT "        PKD6 - host only not applicable" SEVERITY NOTE;

  --    PKD7 Is the handshake packet 16 bits + EOP 8.4.4
  -- the length of the handshake packet is checked on every handshake received.
  test_progress <= 16#13070#;--    PKD7

  --    PKD8 Is the handshake constituted as sync followed by PID followed
  --         by EOP 8.4.4
  -- the sync, PID and eop are checked on every handshake received.
  test_progress <= 16#13080#;--    PKD8

  --    PKD9 Is the data packet an integral number of bytes ( 4 to 1027) +
  --         EOP 8.4.3
  -- data packet lenght is checked on each packet recieved.
  test_progress <= 16#13090#;--    PKD9
  --    PKD10 Is the data packet constituted as sync followed by PID
  --         followed by 0 to 1023 bytes of data followed by data CRC
  --         followed by EOP 8.4.3
  -- data packet sync, data block, CRC and eop are checked on all data packets.
  -- A minuimum size (zero length) and a maximum size data packet will be sent
  -- and received inorder to verify the operations at the boundary conditions.

  test_progress <= 16#13100#;--    PKD10

  ASSERT false REPORT "Testing PKD7  - handshake length" SEVERITY NOTE;
  ASSERT false REPORT "Testing PKD8  - handshake components" SEVERITY NOTE;
  ASSERT false REPORT "Testing PKD9  - data packet length" SEVERITY NOTE;
  ASSERT false REPORT "Testing PKD10 - data packet components" SEVERITY NOTE;
  min_max_data_test(16#13100#);

  --    PKD11 Is the data payload of a low speed packet limited to 8 bytes
  --         8.6.5
  ASSERT false REPORT "        PKD11 - low speed only not applicable" SEVERITY NOTE;
  test_progress <= 16#13110#;--    PKD10

  --    Transaction
  --    Transactions are sets of packets used for unidirectional data
  --         transfer and can be one of the following: (host phase in
  --         italics; device phase in regular font)
  --    SOF
  --    setup data  ack
  --    out data  ack/nak/stall
  --    out data0
  --    in data  ack
  --    in  data0/nak/stall
  --    pre  setup  pre data ack
  --    pre  out  pre data  ack/nak/stall
  --    pre in  data  pre ack
  --    pre  in nak/stall


  -- For tests TRD1 and TRD2, low speed mode needs a minimum interval of
  -- approximately 530 us between 'set_address'es.  High speed mode needs
  -- no such interval.
  IF lsdev = 1 THEN
    between_set_address_interval := 530 us;
  ELSE
    between_set_address_interval := 0 ns;
  END IF;

  --    TRD1 Does the device implement default address of 0 on device reset
  --         8.3.2.1

  test_progress <= 16#14010#;--    TRD1 set address
  ASSERT false REPORT "Testing TRD1  - address after reset"
    SEVERITY NOTE;
  set_address(16#7f#,16#14010#);         -- set the address to 7f
  test_progress <= 16#14015#;            --    TRD1 reset
  usb_reset(21 us);                      -- send a usb reset (sets
                                         -- device_address to 0x00)
  WAIT FOR 1 ms;  -- give software time to fire up
  test_progress <= 16#1401a#;            --    TRD1 check address
  set_address(16#7f#,16#14016#);         -- set the address back to 7f using
  WAIT FOR between_set_address_interval;
                                         -- the device address of 00 to reach
                                         -- the target.
  --    TRD2 Does the device implement a bidirectional control endpoint 0
  --         for every address 8.3.2.2

  test_progress <= 16#14020#;--    TRD2 endpoint 0 for each address
  ASSERT false REPORT "Testing TRD2  - endpoint zero for each address"
    SEVERITY NOTE;

  FOR temp_address IN 0 TO 16#7f# LOOP
    set_address(temp_address, 16#14020#);
    WAIT FOR between_set_address_interval;
  END LOOP;                              -- temp_address in 0 to 7f
  set_address(0,16#14026#);              -- one more time to check 7f
  WAIT FOR between_set_address_interval;

  --    TRD3 Does the generated packet fit the phase of the transaction as
  --         listed above 8.5,8.6.5
  ASSERT false REPORT "Testing TRD3  - transaction phase"
    SEVERITY NOTE;
  test_progress <= 16#14030#;--    TRD3 Transaction Phase
  -- test the sequences that are applicable to a target.
  --
  --    setup data  ack
  test_progress <= 16#14030#;--    TRD3 setup / data /ack
  set_address(7,16#14030#);              -- setup / data /ack
  --    out data  ack/nak/stall
  test_progress <= 16#14036#;--    TRD3 out / data / ack nak stall
  crc_bitstuff_test;
  --    out data0
  --    in data  ack
  test_progress <= 16#14037#;--    TRD3 out / data  and in / data
  -- If HS device use data length of 64 bytes, else use 8 bytes
  IF lsdev = 0 THEN
    iso_echo_test(endpt => 2, dlength => 64, dpat => INC, dstart => 0,
                  bogus_hndshk => 0, sof_wait => false);
  ELSE
    iso_echo_test(endpt => 2, dlength => 8, dpat => INC, dstart => 0,
                  bogus_hndshk => 0, sof_wait => false);
  END IF;
  --    in  data0/nak/stall
  test_progress <= 16#14038#;--    TRD3 out / data / ack nak stall
  crc_bitstuff_test;


  --    TRD4 Is the turnaround time of a packet-sourcing agent greater than
  --         2 bit times 7.1.15
  test_progress <= 16#14040#;--    TRD4

  --    TRD5 Is the turnaround time of a packet-sourcing agent less than
  --         6.5 (7.5 with integrated cable) bit times 7.1.15
  test_progress <= 16#14050#;--    TRD5

  --    TRD6 Is the timeout period at an agent awaiting response greater
  --         than 16 bit times 7.1.16
  test_progress <= 16#14060#;--    TRD6

  --    TRD7 Is the timeout period at an agent awaiting response less than
  --         18 bit times 7.1.16
  test_progress <= 16#14070#;--    TRD7
  ASSERT false REPORT "Testing TRD4  - turnaround min" SEVERITY NOTE;
  ASSERT false REPORT "Testing TRD5  - turnaround max" SEVERITY NOTE;
  ASSERT false REPORT "Testing TRD6  - bto min" SEVERITY NOTE;
  ASSERT false REPORT "Testing TRD7  - bto max" SEVERITY NOTE;
  bto_test(16#14070#);

  --    TRD8 Is an unsuccessful (NAK or timeout in non-token phase)
  --         transaction retried 8.6.2-4
  test_progress <= 16#14080#;--    TRD8

  --    TRD9 Does the retried transaction use the same data PID as the
  --         original transaction 8.6.2-4
  test_progress <= 16#14090#;--    TRD9
  ASSERT false REPORT "Testing TRD8  - transaction retry" SEVERITY NOTE;
  ASSERT false REPORT "Testing TRD9  - data toggle" SEVERITY NOTE;
  data_toggle_test(16#14090#);

  --    TRD10 Do interrupt endpoints used in rate feedback mode toggle the
  --         sequence bit without regard to presence or type of
  --         handshake 8.5.3
  test_progress <= 16#14100#;--    TRD10
  ASSERT false REPORT "???? TRD10  - interrupt rate feedback data toggle" SEVERITY NOTE;
  ASSERT false REPORT "don't know how to set up rate feedback mode. *** NOT TESTED ***"
    SEVERITY NOTE;

  --    TRD11 Do handshakes conform to order of precedence detailed in
  --         tables of sec. 8.4.5 8.4.5
  test_progress <= 16#14110#;--    TRD11
  ASSERT false REPORT "Testing TRD11  - handshake precedence"
    SEVERITY NOTE;
  handshake_precedence_test(16#14110#);

  --    TRD12 Are low speed transactions limited to those needed to support
  --         interrupt and control endpoints 8.6.5
  test_progress <= 16#14120#;--    TRD12
  ASSERT false REPORT "        TRD12 - low speed only not applicable" SEVERITY NOTE;

  --    TRD13 Does an ISO endpoint synthesize frame markers to replace SOFs
  --         which may be lost due to bus error 5.10.6
  test_progress <= 16#14130#;--    TRD13
  ASSERT false REPORT
     "        TRD13 - SOF synthesis - application specific not applicable"
    SEVERITY NOTE;

  --    TRD14 Does an ISO pipe handle holes/bubbles in pipe which may arise
  --         during suspend-resume operation
  test_progress <= 16#14140#;--    TRD14
  ASSERT false REPORT
     "        TRD14 - ISO hole/bubble handling - application specific not applicable"
    SEVERITY NOTE;

  --    Transfer
  --    Transfers are data structures used by bidirectional (control
  --         endpoints).  The transfer is made up of stages which are
  --         sets of unidirectional transactions. They can be one of:
  --    setup0	out1  out0  out1  ...   out0/1	in1
  --    setup0	in1     in0    in1   ...    in0/1  	out1
  --    setup0	in1
  --    Transactions in italics constitute the data stage ; there may or
  --         may not be a data stage between the setup stage and status
  --         stage.  Suffix of 0 or 1 indicates the data PID used in the
  --         transaction

  --    TFD1 Does the setup stage use a data0 PID 8.5.2
  test_progress <= 16#15010#;--    TFD1

  --    TFD2 Does the status stage use a data1 PID 8.5.2
  test_progress <= 16#15020#;--    TFD2

  --    TFD3 Does the data stage always start with a data1 PID 8.5.2
  test_progress <= 16#15030#;--    TFD3

  --    TFD4 Are all the transactions of the data stage in the same
  --         direction 8.5.2
  test_progress <= 16#15040#;--    TFD4

  --    TFD5 Is there a change of direction when entering the status change
  --         8.5.2
  test_progress <= 16#15050#;--    TFD5

  --    TFD6 Is the data packet used in the status stage 0 bytes in length
  --         8.5.2
  -----------------------------------------------------------------------------
  -- All of these items are verified by sending and checking a get device
  -- descriptor and a set address descriptor transactons.
  -----------------------------------------------------------------------------

  test_progress <= 16#15060#;--    TFD6
  ASSERT false REPORT "Testing TFD1  - Setup stage uses DATA0 PID" SEVERITY NOTE;
  ASSERT false REPORT "Testing TFD2  - Status stage uses DATA1 PID" SEVERITY NOTE;
  ASSERT false REPORT "Testing TFD3  - Data Stage starts with DATA1 PID" SEVERITY NOTE;
  ASSERT false REPORT "Testing TFD4  - All data stage packets are in same direction" SEVERITY NOTE;
  ASSERT false REPORT "Testing TFD5  - Change of direction entering status stage" SEVERITY NOTE;
  ASSERT false REPORT "Testing TRD6  - Status stage data packet is 0 length"
    SEVERITY NOTE;
  get_device_desc(   16#15060#);
  set_address(16#1a#,16#15068#);
  WAIT FOR between_set_address_interval;

  --    Test for robustness Section:
  test_progress <= 16#20000#;--    Robustness Tests
  --    Bitstream
  --    A compliant bitstream is a set of bits from J,K,0 (nrzi) or
  --         0,1,X(nrz)
  test_progress <= 16#21000#;--    Bitstream Robustness Tests

  --    Name Test description N/A Status
  --    BST1 Is a single ended NIB 1 of >= 1 bit time ignored by the target

  test_progress <= 16#21010#;--    BST1
  ASSERT false REPORT "Testing BST1  - Single Ended 1 is ignored."
    SEVERITY NOTE;
  -----------------------------------------------------------------------------
  -- Set the USB line state to NIB 1 for 200 ns then run the crc bit stuff
  -- test.
  -----------------------------------------------------------------------------
  -- tx_manu - HC is offline while the signals are manipulated manually
  hc_state <= tx_manu;
  dplus <= '1';
  dminus <= '1';
  WAIT FOR 200 ns;
  j_state;
  crc_bitstuff_test;

  test_progress <= 16#21011#;
  -- after test return to J state
  hc_state <= hc_idle;
  j_state;

  --    BST2 Does an agent ignore a truncated (upto 50%) first bit of the
  --         sync field without impacting the rest of the bitstream
  test_progress <= 16#21020#;--    BST2
  ASSERT false REPORT "Testing BST2  - Truncated Sync is accepted."
    SEVERITY NOTE;
  force_truncate_sync := 1;              -- skip the first sync bit
  crc_bitstuff_test;
  force_truncate_sync := 0;

  --    BST3 Is the state of the differential receiver ignored during
  --         single ended signal state
  -----------------------------------------------------------------------------
  -- This is tested anytime there is a single ended signal on the usb bus.  The
  -- Philips usbp11 model inserts an X on rcv whenever the USB signals go
  -- single ended.
  -- This test will send an out token normally, followed by a data packet sent
  -- using single ended signalling.  If this packet is ignored a BTO will be
  -- detected by the target.
  -----------------------------------------------------------------------------
  test_progress <= 16#21030#;--    BST3
  ASSERT false REPORT
    "Testing BST3  - Differencial input ignored when Single Ended."
    SEVERITY NOTE;
  single_ended_test;


  --    BST5 Does the target adjust to the difference in frequency and
  --         phase between incoming clock and its internal clock
  test_progress <= 16#21050#;--    BST5
  ASSERT false REPORT
    "Testing BST5  - Target adjusts to incoming frequency and phase."
    SEVERITY NOTE;
  -----------------------------------------------------------------------------
  -- To test the phase lock loop we will run at clock slow clock fast , and we
  -- will do a maximum phase invertion between interation of the crc test.
  -----------------------------------------------------------------------------
  pll_test(16#21050#);

  --    BST6 Is a packet with a bit-stuff error rejected by the target
  test_progress <= 16#21060#;--    BST6


  --    BST7 Is a bitstream (which is not part of a packet) with bit stuff
  --         error ignored by the target
  test_progress <= 16#21070#;--    BST7

  --    BST8 Does the target reject packets with bit stuff error at the
  --         last bit of the packet
  test_progress <= 16#21080#;--    BST8

  --    BST9 Is bit stuffing implemented even if stuffed bit is after the
  --         last bit of the packet
  test_progress <= 16#21090#;--    BST9
  ASSERT false REPORT
    "Testing BST6  - A packet with a bitstuff error is rejected." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST7  - A non-packet with a bitstuff error is rejected." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST8  - A bitstuff error on the last bit causes rejection." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing BST9  - Bit stuffing is done even on the last bit of a packet." SEVERITY NOTE;
  bit_stuff_reject_test(16#21090#);

  --    BST10 Can the device handle more than one USB RESET with no
  --         intervening packets correctly
  test_progress <= 16#21100#;--    BST10
  ASSERT false REPORT
    "Testing BST10 - Are back to back resets handled correctly."
    SEVERITY NOTE;

  -----------------------------------------------------------------------------
  -- Clear all the error bits in the Diagnostic register of the target device.
  -----------------------------------------------------------------------------
  set_diag_desc(breq => 0, wval => 16#ffff#, wind => 0, wlen => 0);

  -----------------------------------------------------------------------------
  -- reset the device twice.
  -----------------------------------------------------------------------------
  usb_reset(500 us);
  test_progress <= 16#21101#;--    BST10 after first reset
  WAIT FOR 100 us;
  usb_reset(1 ms);
  test_progress <= 16#21102#;--    BST10 after second reset

  -----------------------------------------------------------------------------
  -- Read the target status to check any error conditions
  -----------------------------------------------------------------------------
  get_diag_desc(breq => 1, wval => 0, wind => 0, wlen => 2);

  -----------------------------------------------------------------------------
  -- Check the status of the target for any error reports.
  -----------------------------------------------------------------------------
  status_rg := hc_rxpkt_data(0);

  ASSERT ((hc_rxpkt_data(1) AND "00000010") = "00000010") REPORT
    "reset was not detected by the target."
    SEVERITY FAILURE;

  ASSERT ((status_rg  AND "11011111")= "00000000") REPORT
    "errors detected by target."
    SEVERITY FAILURE;


  --    Field
  --    A compliant field  can be one of:
  --    sync  		- 8 bit field with NZB  value 00000001
  --    PID     		- listed in Table 8-1 of spec
  --    address		- 7 bit field
  --    endpoint		- 4 bit field
  --    frame number	- 11 bit field
  --    token CRC	- 5 bit field
  --    data		- 0 to 1023 byte field
  --    data CRC	- 16 bit field
  --    EOP		- 3 bit field with NIB value 00J



  --    FLT1 Is the sync field recognized as valid even if up to two
  --         initial bits of it are corrupted (Actually, only the last 3
  --         bits (JKK) need to be decoded).
  test_progress <= 16#22010#;--    FLT1
  ASSERT false REPORT "Testing FLT1  - Truncated Sync is recognized as valid."
    SEVERITY NOTE;
  force_truncate_sync := 2;              -- skip the first 2 sync bits
  crc_bitstuff_test;
  force_truncate_sync := 0;

  --    FLT2 Is a packet with packet type not listed in Table 8-1 ignored
  --         by the target
  test_progress <= 16#22020#;--    FLT2

  --    FLT3 Is a packet with corrupt PID (PID check error) ignored by the
  --         target
  test_progress <= 16#22030#;--    FLT3

  --    FLT4 Is a token with bad CRC ignored by the target
  test_progress <= 16#22040#;--    FLT4

  --    FLT5 Is a CRC error on a data packet recognized by the target
  test_progress <= 16#22050#;--    FLT5

  --    FLT6 Does a full speed receiver reject (a packet with) a NIB 0 of
  --         duration less than 40 ns as part of an EOP.
  test_progress <= 16#22060#;--    FLT6
  ASSERT false REPORT
    "Testing FLT2  - Packets with undefined PIDs are ignored." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT3  - Packets with errors the PID are ignored." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT4  - Packets with crc5  errors are ignored." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT5  - data packets with crc errors are ignored." SEVERITY NOTE;
  ASSERT false REPORT
    "Testing FLT6  - Packets with short EOP SE0 pulses are ignored." SEVERITY NOTE;
  field_error_reject_test;

  --    FLT7 Does a low speed receiver reject a NIB 0 of duration less than
  --         330 ns as part of an EOP
  test_progress <= 16#22070#;--    TRD12
  ASSERT false REPORT "        FLT7 - low speed only not applicable" SEVERITY NOTE;


END IF; -- checklist_enabled

ASSERT false  REPORT "Successful completion of USB test bench." SEVERITY NOTE;
tb_done <= true;                         -- Signal that test bench is done
WAIT; -- Execute only once

END PROCESS main_test;


--------------------------------------------------------------------------------
--
--     Process: USB_CLK
--
--  Parameters: clock_margin -- (slow, normal, fast)
--              clock_jitter -- time to jitter clock by
--              clock_master -- (target, host_p0, host_p1)
--
-- Description: This process generates the clock used by the main_test process.
--
--------------------------------------------------------------------------------

-- This code performs a behavioral phase lock function with the incoming USB
--  data stream.  It is coded without using a the 'event syntax to support
--  translation to verilog.
target_dpll: PROCESS (target_usb_clk, usb_kstate, want_rising, clk_start)
  VARIABLE last_usb_kstate       : std_logic;
  VARIABLE last_target_usb_clk   : std_logic;
  VARIABLE last_want_rising      : std_logic;
  VARIABLE last_clk_start        : std_logic;
  VARIABLE blanking              : std_logic;

BEGIN -- target_dpll

  IF usb_kstate = '1' AND last_usb_kstate /= '1' THEN
    blanking := '1';
    target_usb_clk <= TRANSPORT '0' AFTER 0 ns;          -- assert falling edge
    target_usb_clk <= TRANSPORT '1' AFTER usb_bit_time/2;-- schedule a rising edge.
  ELSIF (target_usb_clk='1' AND last_target_usb_clk/='1') OR
      (clk_start = '1' AND last_clk_start /= '1') THEN
    target_usb_clk <= TRANSPORT '0' AFTER usb_bit_time/2;-- schedule a falling edge
    blanking := '0';
  ELSIF (target_usb_clk='0' AND last_target_usb_clk/='0') THEN
    IF blanking = '0' THEN
      want_rising <= TRANSPORT '1' AFTER usb_bit_time/2; -- schedule a rising edge
      want_rising <= TRANSPORT '0' AFTER (usb_bit_time/2)+1 ns;
    END IF;
  ELSIF (want_rising = '1' AND last_want_rising /= '1') THEN
    IF (blanking = '0') THEN
      target_usb_clk <= '1';             -- assert rising edge
    END IF;
  END IF;

  last_usb_kstate      := usb_kstate;
  last_target_usb_clk  := target_usb_clk;
  last_want_rising     := want_rising;
  last_clk_start       := clk_start;

END PROCESS; -- target_dpll

 -- set all of the operating periods based on the state of the clock_low_speed signal.
usb_bit_time <= LS_USB_BIT_TIME WHEN clock_low_speed  ELSE
                FS_USB_BIT_TIME;

usb_bit_fast <= LS_USB_BIT_FAST WHEN clock_low_speed  ELSE
                FS_USB_BIT_FAST;

usb_bit_slow <= LS_USB_BIT_SLOW WHEN clock_low_speed  ELSE
                FS_USB_BIT_SLOW;

bus_timeout <= usb_bit_time * 16;

-- This code will drive the USB clocks at the 12Mhz (83ns period) for full speed
-- or 1.5MHz (640ns period) for low speed.
host_p0_usb_clk <= '1' AFTER (usb_bit_time/2) WHEN host_p0_usb_clk = '0' ELSE
                   '0' AFTER (usb_bit_time/2);

host_p1_usb_clk     <= TRANSPORT host_p0_usb_clk AFTER (usb_bit_time/2);

host_jitter_usb_clk <= TRANSPORT host_p0_usb_clk AFTER clock_jitter_delay;

host_fast_usb_clk <= '1' AFTER (usb_bit_fast/2) WHEN host_fast_usb_clk = '0' ELSE
                     '0' AFTER (usb_bit_fast/2);

host_slow_usb_clk <= '1' AFTER (usb_bit_slow/2) WHEN host_slow_usb_clk = '0' ELSE
                     '0' AFTER (usb_bit_slow/2);

-- USB clock normally comes from the SBC so everyone will be synchronous
-- which allows us to extract test vectors.  To test the PLL however a clock is
-- generated locally to generate the transition timing within the USB packets.
-- when the host is receiving data from the target it uses the target clock so
-- as to emulate the operationg of a phase lock loop.

next_want_clk <= "0000"   WHEN ((clock_master = target) OR
                                (hc_state = rx_wait) OR
                                (hc_state = rx_sync) OR
                                (hc_state = rx_pid) OR
                                (hc_state = rx_addr) OR
                                (hc_state = rx_endp) OR
                                (hc_state = rx_crc5) OR
                                (hc_state = rx_eop) OR
                                (hc_state = rx_data) OR
                                (hc_state = rx_crc16)) ELSE
                 "0001"   WHEN (clock_margin = slow)   ELSE
                 "0010"   WHEN (clock_margin = fast)   ELSE
                 "0011"   WHEN (clock_master = host_p1) ELSE
                 "0100";

next_usb_clk <= target_usb_clk    WHEN (next_want_clk = "0000") ELSE
                host_slow_usb_clk WHEN (next_want_clk = "0001") ELSE
                host_fast_usb_clk WHEN (next_want_clk = "0010") ELSE
                host_p1_usb_clk   WHEN (next_want_clk = "0011") ELSE
                host_jitter_usb_clk;

usb_clk      <= '1' WHEN (clock_switch = '1')              ELSE
                target_usb_clk    WHEN (want_clk = "0000") ELSE
                host_slow_usb_clk WHEN (want_clk = "0001") ELSE
                host_fast_usb_clk WHEN (want_clk = "0010") ELSE
                host_p1_usb_clk   WHEN (want_clk = "0011") ELSE
                host_jitter_usb_clk;

clock_trans: PROCESS (usb_clk, clock_switch_clr)
BEGIN
  IF clock_switch_clr = '1' THEN
    clock_switch <= '0';
  ELSIF (usb_clk'event AND usb_clk = '1') THEN
    IF (want_clk /= next_want_clk) THEN
      clock_switch <= '1';
    ELSE
      clock_switch <= '0';
    END IF;
  END IF;
END PROCESS clock_trans;

clock_trans2: PROCESS (next_usb_clk)
BEGIN
  IF (next_usb_clk'event AND next_usb_clk = '1') THEN
    IF (clock_switch = '1') THEN
      want_clk <= next_want_clk;
      clock_switch_clr <= '1';
      clock_switch_clr <= TRANSPORT '0' AFTER 5 ns;
    END IF;
  END IF;
END PROCESS clock_trans2;

jitter_gen: PROCESS

VARIABLE seed : integer := 17493;        -- psudorandom number seed
VARIABLE tmp_vec : std_logic_vector(31 DOWNTO 0);

BEGIN

  WAIT UNTIL host_p0_usb_clk'event AND host_p0_usb_clk = '1';

  seed := rand(seed);
  tmp_vec := conv_std_logic_vector(seed,32);

  IF tmp_vec(0) = '1' THEN
    clock_jitter_delay <= clock_jitter_time;
  ELSE
    clock_jitter_delay <= 0 ns;
  END IF;

END PROCESS jitter_gen;

--------------------------------------------------------------------------------
--
--     Process: SOF_timer
--
--  Parameters: sof_sent
--              sof_req
--
-- Description: This process generates timing strobes for inserting SOF (Start
-- Of Frame) packets in the Host controller packet stream.
--
--------------------------------------------------------------------------------

sof_timer: PROCESS

BEGIN
  sof_request <= '0';
  sof_request <= '0';

  WAIT FOR SOF_INTERVAL - (SOF_HOLD_OFF_TIME + 1000 ns);

  sof_hold_off <= '1';

  WAIT FOR SOF_HOLD_OFF_TIME;

  sof_request <= '1';

  WAIT FOR 1000 ns;

  sof_request <= '0';
  sof_hold_off <= '0';

END PROCESS sof_timer;

--------------------------------------------------------------------------------
--
--     Process: SOF_timer
--
--  Parameters: sof_sent
--              sof_req
--
-- Description: This process inserts SOF (Start Of Frame) packets in the Host
--              controller packet stream.
--
--------------------------------------------------------------------------------

sof_generate: PROCESS

--------------------------------------------------------------------------------
--
-- Procedure: bit_stuff
--
-- Parameters:
--             data         -- data bit to sent
--             data_histroy -- history of last 6 data values
--             dplus        -- USB data+
--             dminus       -- USB data-
--             force_bit_stuff_disable
--
-- Description: NRZ (NonReturn to Zero) encodes the data and outputs it on the
-- dplus and dminus lines.
--
--
--------------------------------------------------------------------------------

VARIABLE frame_num : integer := 1; -- SOF frame number

PROCEDURE  sof_bit_stuff(
  CONSTANT data         : IN    std_logic;        -- data bit to sent
  VARIABLE data_history : INOUT std_logic_vector(5 DOWNTO 0)  -- history of
                                                              -- last 6 bits
  ) IS
  BEGIN
--  nrz_out (data);
    IF data = '0' THEN
      dplus   <= NOT To_X01(dplus) AFTER (1 ns);
      dminus  <=     To_X01(dplus) AFTER 1 ns;
    END IF;
    data_history := data_history(4 DOWNTO 0) & data;-- update the history
    IF (data_history = "111111"  AND data = '1') THEN
      WAIT UNTIL usb_clk'event AND usb_clk = '1';   -- Wait for rising edge
--      ASSERT false REPORT "adding stuff bit" SEVERITY NOTE;

--    nrz_out('0');                   -- stuff a zero
      dplus   <= NOT To_X01(dplus) AFTER (1 ns);
      dminus  <=     To_X01(dplus) AFTER 1 ns;
      data_history := data_history(4 DOWNTO 0) & '0';-- update the history
    END IF;
  END sof_bit_stuff;

--------------------------------------------------------------------------------
--
-- Function : sof_crc5
--
-- Parameters: din      -- 11-bit intput data
--             force_crc5_error -- force an error in the result
--             RETURNs  -- CRC5 field for data field
--
-- Description: This function will generate the crc5 field for USB packets that
-- require it.
--
--
--------------------------------------------------------------------------------

FUNCTION sof_crc5 (CONSTANT din : std_logic_vector(11 DOWNTO 0);
               CONSTANT length : integer
  ) RETURN std_logic_vector IS

  VARIABLE crc_next, crc_out : std_logic_vector(4 DOWNTO 0);
  VARIABLE scrc_index        : integer;

BEGIN

  crc_next := "11111";

  bits : FOR scrc_index IN 0 TO length-1 LOOP -- loop for the width of the parallel CRC

        -- The polynomial computed is:
        -- G(x)=X**5+X**2+1
	-- compute the crc_next one bit at a time LSB first
    crc_out :=
	 crc_next(3) &                                  -- bit 4
	 crc_next(2) &                                  -- bit 3
	(crc_next(1) XOR crc_next(4) XOR din(scrc_index)) &	-- bit 2
	 crc_next(0) &                                  -- bit 1
	(                crc_next(4) XOR din(scrc_index));	-- bit 0

    crc_next := crc_out;

  END LOOP bits;
  crc_out := NOT crc_out;

  RETURN(crc_out);

END sof_crc5;

--------------------------------------------------------------------------------
--
-- Procedure: sof_packet
--
-- Parameters: frm_num  -- Frame number
--             usb_clk  -- USB clock
--             dplus    -- USB data+
--             dminus   -- USB data-
--             hc_state -- USB Host Controller state
--
-- Description: This procedure will transmit a USB SOF packet.
--
-- Packet Format:
--
--   8-Bits   8-Bits   11-Bits   5-Bits   3-Bits
-- +--------+--------+---------+--------+--------+
-- |  SYNC  |   PID  | Frame # |  CRC5  |   EOP  |
-- +--------+--------+---------+--------+--------+
--
--------------------------------------------------------------------------------

PROCEDURE sof_packet (
  VARIABLE frm_num  : INOUT integer      -- Frame number
  ) IS

VARIABLE temp : std_logic_vector(31 DOWNTO 0); -- Temp conversion
VARIABLE data_history : std_logic_vector(5 DOWNTO 0); -- data bit history for bit
                                                      -- stuffing
VARIABLE   sof_pkt_i : integer;

BEGIN

  if lsdev = 0 then

--  send_sync(data_history); -- Send sync field
    hc_sof_state <= tx_sync; -- Set host controller state
    sof_pkt_i := 1;
    WHILE (sof_pkt_i < 8) LOOP -- Tx sync
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      dplus   <= NOT To_X01(dplus) AFTER (1 ns);
      dminus  <=     To_X01(dplus) AFTER 1 ns;
      sof_pkt_i := sof_pkt_i + 1;
    END LOOP;

    WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
    dplus   <=     To_X01(dplus) AFTER 1 ns;
    dminus  <= NOT To_X01(dplus) AFTER 1 ns;
    data_history := "000001";
    -- end of the sync byte

    temp(3 DOWNTO 0) := "0101"; -- Set to SOF pid
    temp(7 DOWNTO 4) := NOT temp(3 DOWNTO 0); -- Invert PID bits
    FOR sof_pkt_i IN 0 TO 7 LOOP -- Tx pid
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      hc_sof_state <= tx_pid; -- Set host controller state
      sof_bit_stuff(temp(sof_pkt_i), data_history);
    END LOOP;

    temp := CONV_STD_LOGIC_VECTOR(frm_num,32); -- Convert integer frame number to
                                               -- std_logic_vector
    FOR sof_pkt_i IN 0 TO 10 LOOP -- Tx frame number
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      hc_sof_state <= tx_fnum; -- Set host controller state
      sof_bit_stuff(temp(sof_pkt_i), data_history);
    END LOOP;

    temp := CONV_STD_LOGIC_VECTOR(frm_num,32);
    temp(4 DOWNTO 0) := sof_crc5(temp(11 DOWNTO 0),11); -- Set CRC5
    FOR sof_pkt_i IN 4 DOWNTO 0 LOOP -- Tx CRC5 (MSB first)
      WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
      hc_sof_state <= tx_crc5; -- Set host controller state
      sof_bit_stuff(temp(sof_pkt_i), data_history);
    END LOOP;

  end if;

  -- Tx EOP
-- send_eop;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
  hc_sof_state <= tx_eop;                     -- Set host controller state
  dplus  <= '0' AFTER 1 ns;
  dminus <= '0' AFTER 1 ns;
  if lsdev = 1 then
    WAIT FOR 1334 ns;
    dminus <= '1' AFTER 1 ns;
  else
    WAIT FOR 166 ns;
    dplus <= '1' AFTER 1 ns;
  end if;
  WAIT UNTIL usb_clk'event AND usb_clk = '1'; -- Wait for rising edge
  hc_sof_state <= hc_idle;         -- Set host controller state
  dplus  <= 'Z' AFTER 1 ns;                   -- Release Data+
  dminus <= 'Z' AFTER 1 ns;                   -- Release Data-

  frm_num := frm_num + 1;                -- increment the frame number

END sof_packet;


BEGIN
  dplus  <= 'Z';                   -- Release Data+
  dminus <= 'Z';                   -- Release Data-
  WAIT UNTIL sof_request'event AND sof_request = '1';
  IF sof_enable THEN
     IF hc_state = hc_reset THEN
       ASSERT terse REPORT "Host TX State Sending reset." SEVERITY NOTE;
     ELSIF hc_state =  hc_resume THEN
       ASSERT terse REPORT "Host TX State Sending resume." SEVERITY NOTE;
     ELSIF hc_state =  tx_manu THEN
       ASSERT terse REPORT "Host TX State Sending manual patterns." SEVERITY NOTE;
     ELSIF hc_state = hc_idle THEN
       IF lsdev = 1 then
         ASSERT terse REPORT "Send a Low-speed Keep-alive." SEVERITY NOTE;
       ELSE
         ASSERT terse REPORT "Send a SOF packet." SEVERITY NOTE;
       END IF;
       sof_packet(frame_num);
     ELSE
       ASSERT false REPORT "Babble Condition detected at SOF point."
       SEVERITY FAILURE;
     END IF;
  END IF;

END PROCESS sof_generate;

--------------------------------------------------------------------------------
--
--     Process: usb_monitor_bits
--
--  Parameters: dplus  - Data+
--              dminus - Data-
--
-- Description: This process monitors the USB data signals and converts them in
--	to a usb_logic level. Then performs the nrzi decoding to provide a bit
--      stream in std_logic. This is helpful when simulating USB transactions.
--
--------------------------------------------------------------------------------


usb_state <= usb_state_of(dplus,dminus);
usb_kstate <= '1' WHEN usb_state_of(dplus,dminus) = K ELSE '0';

usb_monitor_bits : PROCESS

  VARIABLE last_state : usb_logic := SE0;

  BEGIN
    WAIT UNTIL usb_clk'event AND usb_clk = '1';
    IF    (last_state = J AND usb_state = K) OR
          (last_state = K AND usb_state = J) THEN
      usb_bit_value <= '0';
    ELSIF (last_state = J AND usb_state = J) OR
          (last_state = K AND usb_state = K) THEN
      usb_bit_value <= '1';
    ELSE
      usb_bit_value <= 'X';
    END IF;
    last_state := usb_state;

    ASSERT NOT (hc_idle_activity AND now > 10000 ns)
      REPORT
      "Unexpected activity detected on the USB bus signals."
      SEVERITY FAILURE;

END PROCESS usb_monitor_bits;

hc_idle_activity <= true WHEN ((hc_state = hc_idle) AND (hc_sof_state = hc_idle) AND
                         (usb_state /= J))
                     ELSE false;



END behav;
