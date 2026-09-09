--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
-- HTTP://www.vautomation.com
--
-- File: a10k240.vhd
--
-- Description:
--      This is a shell which implements all of the technology specific logic
-- 	for an Altera 10K family part in a 240-pin plastic quad flatpack 
--	package (specifically a 10K100).
--	The pinout is defined via attributes.
--	An empty architecture is included in this file.
--
-- Signals ending in _n are active low.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: a10k240.vhd,v $
-- Revision 1.22  1999/11/09 14:27:32  mark
-- updated a10k240 to handle a ulogicified asic_v8 component
--
-- Revision 1.21  1999/06/24 14:29:36  chris
-- Added genric lsdev to allow low speed devices in the same testbench
-- as full speed devices.
-- Added software controlled usb biasing to allow control of connection events.
--
-- Revision 1.20  1999/04/26 16:30:50  gregg
-- Updated for low speed support and fixed r_wel_n for
-- sync operation
--
-- Revision 1.19  1999/04/01 19:46:31  eric
-- Corrected async reset syntax for conversion to verilog.
--
-- Revision 1.18  1999/03/31 22:02:36  eric
-- Updated with the new pwr_save module requirements.
--
-- Revision 1.17  1998/12/04 02:52:04  eric
-- Routed the V8 clock out GCLK1_OUT and back in GCLK1 to insure
-- MaxPlus2 uses a global clock buffer (typically it won't).
-- This requires a 12Mhz oscillator on all REV C IPS boards in X1.
--
-- Revision 1.16  1998/11/17 20:33:02  eric
-- Just removed driving avail(0).
--
-- Revision 1.15  1998/11/12 15:34:44  chris
-- Removed conflicting output on gclk1_out.
--
-- Revision 1.14  1998/11/12 14:55:13  chris
--
-- Revision 1.13  1998/11/09 21:59:13  chris
-- Added conditional clocking support for VUSB devices on Rev D and later IPS boards.
--
-- Revision 1.12  1998/10/28 02:49:09  eric
-- needed ee_sda_out as a debug signal.
--
-- Revision 1.11  1998/10/28 00:30:04  eric
-- Places and routes and the WRITE flop is right next to the WE_N pin.
--
-- Revision 1.10  1998/10/23 19:38:04  chris
-- Removed tristate specification from input VID.
--
-- Revision 1.9  1998/10/23 19:13:02  eric
-- Removed clocks from Fire Wire signals to remove tristate conflicts.
--
-- Revision 1.8  1998/10/14 20:17:17  eric
-- cleanup and make sure various IOs are defined so they don't get driven to ground.
--
-- Revision 1.7  1998/09/11 15:37:27  eric
-- Rev D IPS_PCB.
--
-- Revision 1.6  1998/08/18 00:26:13  eric
-- Added the video chip interface, removed DRAM.
--
-- Revision 1.5  1998/07/02 19:22:52  eric
-- Syntax fix for easy conversion to verilog.
--
-- Revision 1.4  1998/07/02  12:10:00  eric
-- Works in the lab. added USB hub support.
--
-- Revision 1.3  1998/06/13  01:01:22  eric
-- First pass that works but still doesn't have global clock buffers
--
-- Revision 1.2  1998/04/22 18:46:30  eric
-- successfully targets Altera FPGAs with the IO in the right pins.
--
-- Revision 1.1  1998/04/13  15:30:30  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.cfg_usb.all;

ENTITY a10k240 IS        --------------------------ENTITY---------------------
  GENERIC (lsdev : integer := LOW_SPEED_DEV);
  PORT (clk48mhz      : IN    std_logic;
        gclk0         : IN    std_logic;
        gclk1         : IN    std_logic;
        gclk2         : IN    std_logic;
        gclk3         : IN    std_logic;
        gclk0_out     : OUT   std_logic := 'Z';
        gclk1_out     : OUT   std_logic := 'Z';
        gclk2_out     : OUT   std_logic := 'Z';
        reset_n       : IN    std_logic;
        -- P1284 parallel port interface
        pp_data       : INOUT std_logic_vector(1 to 8) := (others => 'Z');
        pp_strobe_n   : INOUT std_logic := 'Z';
        pp_init_n     : INOUT std_logic := 'Z';
        pp_autofd_n   : INOUT std_logic := 'Z';
        pp_selectin_n : INOUT std_logic := 'Z';
        pp_ack_n      : INOUT std_logic := 'Z';
        pp_busy       : INOUT std_logic := 'Z';
        pp_error      : INOUT std_logic := 'Z';
        pp_select     : INOUT std_logic := 'Z';
        pp_fault_n    : INOUT std_logic := 'Z';
        -- Audio Codec interface (ad1845)
        a_addr        : OUT   std_logic_vector(1 downto 0) := (others => 'Z');
        a_data        : INOUT std_logic_vector(7 downto 0) := (others => 'Z');
        a_wr_n        : OUT   std_logic := 'Z';
        a_rd_n        : OUT   std_logic := 'Z';
        a_cs_n        : OUT   std_logic := 'Z';
        -- UART interface
        u_rx1         : IN    std_logic;
        u_rx2         : IN    std_logic;
        u_tx1         : OUT   std_logic := 'Z';
        u_tx2         : OUT   std_logic := 'Z';
        -- SRAM interface
        r_addr        : OUT   std_logic_vector(16 downto 0) := (others =>'Z');
        r_data        : INOUT std_logic_vector(15 downto 0) := (others =>'Z');
        r_ce_n        : OUT   std_logic := 'Z';
        r_oe_n        : OUT   std_logic := 'Z';
        r_wel_n       : OUT   std_logic := 'Z';
        r_weh_n       : OUT   std_logic := 'Z';
        -- Serial EEPROM interface
        ee_sda        : INOUT std_logic := 'Z';
        ee_clk        : INOUT std_logic := 'Z';
        ee_wp         : INOUT std_logic := 'Z';
        -- USB B connector interface
        usbb_dplus    : INOUT std_logic := 'Z';
        usbb_dminus   : INOUT std_logic := 'Z';
        usbb_rcv      : IN    std_logic;
        usbb_vp       : IN    std_logic;
        usbb_vm       : IN    std_logic;
        usbb_oe_n     : OUT   std_logic :='Z';
        usbb_speed    : OUT   std_logic :='Z';
        usbb_vpo      : OUT   std_logic :='Z';
        usbb_vmo      : OUT   std_logic :='Z';
        usbb_low      : OUT   std_logic :='Z';
        usbb_high     : OUT   std_logic :='Z';
        usbb_host1    : OUT   std_logic :='Z';
        usbb_host2    : OUT   std_logic :='Z';
        -- USB A connector #1 interface - also used for host mode
        usba1_dplus   : INOUT std_logic := 'Z';
        usba1_dminus  : INOUT std_logic := 'Z';
        usba1_rcv     : IN    std_logic;
        usba1_vp      : IN    std_logic;
        usba1_vm      : IN    std_logic;
        usba1_oe_n    : OUT   std_logic :='Z';
        usba1_speed   : OUT   std_logic :='Z';
        usba1_vpo     : OUT   std_logic :='Z';
        usba1_vmo     : OUT   std_logic :='Z';
        usba1_pwron   : OUT   std_logic :='Z';
        -- USB A connector #2 interface
        usba2_dplus   : INOUT std_logic := 'Z';
        usba2_dminus  : INOUT std_logic := 'Z';
        usba2_rcv     : IN    std_logic;
        usba2_vp      : IN    std_logic;
        usba2_vm      : IN    std_logic;
        usba2_oe_n    : OUT   std_logic :='Z';
        usba2_speed   : OUT   std_logic :='Z';
        usba2_vpo     : OUT   std_logic :='Z';
        usba2_vmo     : OUT   std_logic :='Z';
        usba2_pwron   : OUT   std_logic :='Z';
        -- USB A connector #3 interface
        usba3_dplus   : INOUT std_logic := 'Z';
        usba3_dminus  : INOUT std_logic := 'Z';
        usba3_rcv     : IN    std_logic;
        usba3_vp      : IN    std_logic;
        usba3_vm      : IN    std_logic;
        usba3_oe_n    : OUT   std_logic :='Z';
        usba3_speed   : OUT   std_logic :='Z';
        usba3_vpo     : OUT   std_logic :='Z';
        usba3_vmo     : OUT   std_logic :='Z';
        usba3_pwron   : OUT   std_logic :='Z';
        -- USB A connector #4 interface
        usba4_dplus   : INOUT std_logic := 'Z';
        usba4_dminus  : INOUT std_logic := 'Z';
        usba4_pwron   : OUT   std_logic;
        -- USB A connector #5 interface
        usba5_dplus   : INOUT std_logic := 'Z';
        usba5_dminus  : INOUT std_logic := 'Z';
        usba5_pwron   : OUT   std_logic;
        -- USB A connector #6 interface
        usba6_dplus   : INOUT std_logic := 'Z';
        usba6_dminus  : INOUT std_logic := 'Z';
        usba6_pwron   : OUT   std_logic;
        -- LED indicator
        led           : OUT   std_logic_vector(9 downto 0) := (others =>'Z');
        -- Expansion connector (pinned out for MII compatiblity)
        mii           : OUT   std_logic_vector(19 downto 2) := (others =>'Z');
        -- video interface
        vid           : IN    std_logic_vector(8 downto 0);
        -- 1394 Firewire PHY
        fw_phy        : OUT   std_logic_vector(8 downto 0) := (others =>'Z');
        -- available signals
        avail         : OUT   std_logic_vector(1 downto 0) := (others =>'Z');
        -- JTAG interface (We don't used the dedicated Altera JTAG pins)
        tcki          : IN    std_logic; -- Altera has problems with bidirect
        tcko          : OUT   std_logic := 'Z';	-- clocks. So we route the clock
        tms           : INOUT std_logic := 'Z'; -- out one pin, and back in...
        tdi           : INOUT std_logic := 'Z';
        tdo           : INOUT std_logic := 'Z';
        -- Altera configuration pins
        msel0         : IN    std_logic;
        msel1         : IN    std_logic;
        nconfig       : IN    std_logic;
        init_done     : INOUT std_logic;
        conf_done     : INOUT std_logic;
        nstatus       : INOUT std_logic;
        data0         : IN    std_logic;
        nce           : IN    std_logic;
        dclk          : IN    std_logic;
        nceo          : INOUT std_logic;
        -- power pins (GND pins are done as an attribute
        vcc5          : IN    std_logic;
        vcc16         : IN    std_logic;
        vcc27         : IN    std_logic;
        vcc37         : IN    std_logic;
        vcc47         : IN    std_logic;
        vcc57         : IN    std_logic;
        vcc77         : IN    std_logic;
        vcc89         : IN    std_logic;
        vcc96         : IN    std_logic;
        vcc112        : IN    std_logic;
        vcc122        : IN    std_logic;
        vcc130        : IN    std_logic;
        vcc140        : IN    std_logic;
        vcc150        : IN    std_logic;
        vcc160        : IN    std_logic;
        vcc170        : IN    std_logic;
        vcc189        : IN    std_logic;
        vcc205        : IN    std_logic;
        vcc224        : IN    std_logic);

-- Below are the pinout attributes for the Xilinx implementation

TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;

ATTRIBUTE pin_number: STRING;
ATTRIBUTE array_pin_number:  STRING_ARRAY;

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF a10k240 : ENTITY is "A10K@PQ240_ALTR ";

ATTRIBUTE GND_pins:  STRING_ARRAY;
ATTRIBUTE GND_pins OF a10k240: ENTITY IS ("a10k240@10 ","a10k240@22 ","a10k240@32 ","a10k240@42 ",
                                         "a10k240@52 ","a10k240@69 ","a10k240@85 ","a10k240@93 ",
                                         "a10k240@104","a10k240@125","a10k240@135","a10k240@145",
                                         "a10k240@155","a10k240@165","a10k240@176","a10k240@197",
                                         "a10k240@216","a10k240@232");
-- VCC pins
ATTRIBUTE pin_number OF vcc5    : SIGNAL IS "a10k240@5";
ATTRIBUTE pin_number OF vcc16   : SIGNAL IS "a10k240@16";
ATTRIBUTE pin_number OF vcc27   : SIGNAL IS "a10k240@27";
ATTRIBUTE pin_number OF vcc37   : SIGNAL IS "a10k240@37";
ATTRIBUTE pin_number OF vcc47   : SIGNAL IS "a10k240@47";
ATTRIBUTE pin_number OF vcc57   : SIGNAL IS "a10k240@57";
ATTRIBUTE pin_number OF vcc77	: SIGNAL IS "a10k240@77";
ATTRIBUTE pin_number OF vcc89	: SIGNAL IS "a10k240@89";
ATTRIBUTE pin_number OF vcc96	: SIGNAL IS "a10k240@96";
ATTRIBUTE pin_number OF vcc112	: SIGNAL IS "a10k240@112";
ATTRIBUTE pin_number OF vcc122	: SIGNAL IS "a10k240@122";
ATTRIBUTE pin_number OF vcc130	: SIGNAL IS "a10k240@130";
ATTRIBUTE pin_number OF vcc140	: SIGNAL IS "a10k240@140";
ATTRIBUTE pin_number OF vcc150	: SIGNAL IS "a10k240@150";
ATTRIBUTE pin_number OF vcc160	: SIGNAL IS "a10k240@160";
ATTRIBUTE pin_number OF vcc170	: SIGNAL IS "a10k240@170";
ATTRIBUTE pin_number OF vcc189	: SIGNAL IS "a10k240@189";
ATTRIBUTE pin_number OF vcc205	: SIGNAL IS "a10k240@205";
ATTRIBUTE pin_number OF vcc224	: SIGNAL IS "a10k240@224";
-- config pins
ATTRIBUTE pin_number OF tdi     : SIGNAL IS "a10k240@230";
ATTRIBUTE pin_number OF tcko    : SIGNAL IS "a10k240@227";
ATTRIBUTE pin_number OF tcki    : SIGNAL IS "a10k240@92";-- dedicated input
ATTRIBUTE pin_number OF tms     : SIGNAL IS "a10k240@228";
ATTRIBUTE pin_number OF tdo     : SIGNAL IS "a10k240@229";
ATTRIBUTE pin_number OF msel0   : SIGNAL IS "a10k240@124";
ATTRIBUTE pin_number OF msel1   : SIGNAL IS "a10k240@123";
ATTRIBUTE pin_number OF nconfig : SIGNAL IS "a10k240@121";
ATTRIBUTE pin_number OF init_done:SIGNAL IS "a10k240@26";
ATTRIBUTE pin_number OF conf_done:SIGNAL IS "a10k240@2";
ATTRIBUTE pin_number OF nstatus : SIGNAL IS "a10k240@60";
ATTRIBUTE pin_number OF data0   : SIGNAL IS "a10k240@180";
ATTRIBUTE pin_number OF nce     : SIGNAL IS "a10k240@178";
ATTRIBUTE pin_number OF nceo    : SIGNAL IS "a10k240@3";
ATTRIBUTE pin_number OF dclk    : SIGNAL IS "a10k240@179";
-- clocks
ATTRIBUTE pin_number OF gclk1  : SIGNAL IS "a10k240@91";
ATTRIBUTE pin_number OF gclk1_out: SIGNAL is "a10k240@215";
-- gclk1 is expected to come from pin 215

--Pin 211 is expected to be the primary oscillator clock which is normally 48Mhz
ATTRIBUTE pin_number OF clk48mhz : SIGNAL IS "a10k240@211";
ATTRIBUTE pin_number OF gclk0: SIGNAL IS "a10k240@90";
ATTRIBUTE pin_number OF gclk0_out : SIGNAL IS "a10k240@83";
-- pin 90 is expected to be jumpered to pin 83 to allow us to drive a 
-- clock out of pin 83 and back in to pin 90 which is a global clock
-- buffer.

ATTRIBUTE pin_number OF gclk2: SIGNAL is "a10k240@210";
ATTRIBUTE pin_number OF gclk2_out: SIGNAL is "a10k240@195";
-- gclk2 is expected to come from pin 195

ATTRIBUTE pin_number OF gclk3: SIGNAL is "a10k240@212";

ATTRIBUTE pin_number OF reset_n : SIGNAL IS  "a10k240@181 ";
                 
ATTRIBUTE pin_number OF usbb_dplus	: SIGNAL IS "a10k240@6 ";
ATTRIBUTE pin_number OF usbb_dminus	: SIGNAL IS "a10k240@7 ";
ATTRIBUTE pin_number OF usbb_rcv	: SIGNAL IS "a10k240@8 ";
ATTRIBUTE pin_number OF usbb_vp	: SIGNAL IS "a10k240@9 ";
ATTRIBUTE pin_number OF usbb_vm	: SIGNAL IS "a10k240@12 ";
ATTRIBUTE pin_number OF usbb_oe_n	: SIGNAL IS "a10k240@13 ";
ATTRIBUTE pin_number OF usbb_speed	: SIGNAL IS "a10k240@14 ";
ATTRIBUTE pin_number OF usbb_vpo	: SIGNAL IS "a10k240@15 ";
ATTRIBUTE pin_number OF usbb_vmo	: SIGNAL IS "a10k240@17 ";
ATTRIBUTE pin_number OF usbb_low	: SIGNAL IS "a10k240@18 ";
ATTRIBUTE pin_number OF usbb_high	: SIGNAL IS "a10k240@19 ";
ATTRIBUTE pin_number OF usbb_host1	: SIGNAL IS "a10k240@20 ";
ATTRIBUTE pin_number OF usbb_host2	: SIGNAL IS "a10k240@21 ";

ATTRIBUTE pin_number OF usba1_dplus	: SIGNAL IS "a10k240@24 ";
ATTRIBUTE pin_number OF usba1_dminus	: SIGNAL IS "a10k240@25 ";
ATTRIBUTE pin_number OF usba1_rcv	: SIGNAL IS "a10k240@237";
ATTRIBUTE pin_number OF usba1_vp	: SIGNAL IS "a10k240@28 ";
ATTRIBUTE pin_number OF usba1_vm	: SIGNAL IS "a10k240@29 ";
ATTRIBUTE pin_number OF usba1_oe_n	: SIGNAL IS "a10k240@30 ";
ATTRIBUTE pin_number OF usba1_speed	: SIGNAL IS "a10k240@31 ";
ATTRIBUTE pin_number OF usba1_vpo	: SIGNAL IS "a10k240@33 ";
ATTRIBUTE pin_number OF usba1_vmo	: SIGNAL IS "a10k240@34 ";
ATTRIBUTE pin_number OF usba1_pwron	: SIGNAL IS "a10k240@35 ";

ATTRIBUTE pin_number OF usba2_dplus	: SIGNAL IS "a10k240@36 ";
ATTRIBUTE pin_number OF usba2_dminus	: SIGNAL IS "a10k240@38 ";
ATTRIBUTE pin_number OF usba2_rcv	: SIGNAL IS "a10k240@39 ";
ATTRIBUTE pin_number OF usba2_vp	: SIGNAL IS "a10k240@40 ";
ATTRIBUTE pin_number OF usba2_vm	: SIGNAL IS "a10k240@41 ";
ATTRIBUTE pin_number OF usba2_oe_n	: SIGNAL IS "a10k240@43 ";
ATTRIBUTE pin_number OF usba2_speed	: SIGNAL IS "a10k240@44 ";
ATTRIBUTE pin_number OF usba2_vpo	: SIGNAL IS "a10k240@45 ";
ATTRIBUTE pin_number OF usba2_vmo	: SIGNAL IS "a10k240@46 ";
ATTRIBUTE pin_number OF usba2_pwron	: SIGNAL IS "a10k240@48 ";
                 
ATTRIBUTE pin_number OF usba3_dplus	: SIGNAL IS "a10k240@49 ";
ATTRIBUTE pin_number OF usba3_dminus	: SIGNAL IS "a10k240@50 ";
ATTRIBUTE pin_number OF usba3_rcv	: SIGNAL IS "a10k240@51 ";
ATTRIBUTE pin_number OF usba3_vp	: SIGNAL IS "a10k240@53 ";
ATTRIBUTE pin_number OF usba3_vm	: SIGNAL IS "a10k240@54 ";
ATTRIBUTE pin_number OF usba3_oe_n	: SIGNAL IS "a10k240@55 ";
ATTRIBUTE pin_number OF usba3_speed	: SIGNAL IS "a10k240@56 ";
ATTRIBUTE pin_number OF usba3_vpo	: SIGNAL IS "a10k240@61 ";
ATTRIBUTE pin_number OF usba3_vmo	: SIGNAL IS "a10k240@62 ";
ATTRIBUTE pin_number OF usba3_pwron	: SIGNAL IS "a10k240@63 ";

ATTRIBUTE pin_number OF usba4_dplus	: SIGNAL IS "a10k240@226 ";
ATTRIBUTE pin_number OF usba4_dminus	: SIGNAL IS "a10k240@225 ";
ATTRIBUTE pin_number OF usba4_pwron	: SIGNAL IS "a10k240@223 ";

ATTRIBUTE pin_number OF usba5_dplus	: SIGNAL IS "a10k240@222 ";
ATTRIBUTE pin_number OF usba5_dminus	: SIGNAL IS "a10k240@221 ";
ATTRIBUTE pin_number OF usba5_pwron	: SIGNAL IS "a10k240@220 ";

ATTRIBUTE pin_number OF usba6_dplus	: SIGNAL IS "a10k240@219";
ATTRIBUTE pin_number OF usba6_dminus	: SIGNAL IS "a10k240@218";
ATTRIBUTE pin_number OF usba6_pwron	: SIGNAL IS "a10k240@217";

ATTRIBUTE array_pin_number OF a_addr : SIGNAL IS ( "a10k240@65 ","a10k240@66 ");
ATTRIBUTE pin_number OF a_wr_n  : SIGNAL IS "a10k240@233";
ATTRIBUTE pin_number OF a_rd_n  : SIGNAL IS "a10k240@234";
ATTRIBUTE pin_number OF a_cs_n  : SIGNAL IS "a10k240@235";
ATTRIBUTE array_pin_number OF a_data : SIGNAL IS 
	("a10k240@67","a10k240@68","a10k240@70","a10k240@71","a10k240@72","a10k240@73","a10k240@74","a10k240@75");

ATTRIBUTE pin_number OF r_ce_n  : SIGNAL IS "a10k240@80";
ATTRIBUTE pin_number OF r_oe_n  : SIGNAL IS "a10k240@81";
ATTRIBUTE pin_number OF r_wel_n : SIGNAL IS "a10k240@82";
ATTRIBUTE pin_number OF r_weh_n : SIGNAL IS "a10k240@64";
ATTRIBUTE array_pin_number OF r_addr : SIGNAL IS
	("a10k240@76 ","a10k240@78 ","a10k240@79 ","a10k240@84 ","a10k240@86 ","a10k240@87 ","a10k240@88 ","a10k240@94 ","a10k240@95 ",
	 "a10k240@97 ","a10k240@98 ","a10k240@99 ","a10k240@100","a10k240@101","a10k240@102","a10k240@103","a10k240@105");
ATTRIBUTE array_pin_number OF r_data : SIGNAL IS
	("a10k240@106","a10k240@107","a10k240@108","a10k240@109","a10k240@110","a10k240@111","a10k240@113","a10k240@114",
	 "a10k240@115","a10k240@116","a10k240@117","a10k240@118","a10k240@119","a10k240@120","a10k240@126","a10k240@127");

ATTRIBUTE array_pin_number OF pp_data : SIGNAL IS
                ( "a10k240@128","a10k240@129","a10k240@131","a10k240@132","a10k240@133","a10k240@134","a10k240@136","a10k240@137");
ATTRIBUTE pin_number OF pp_strobe_n	: SIGNAL IS "a10k240@138";
ATTRIBUTE pin_number OF pp_init_n	: SIGNAL IS "a10k240@139";
ATTRIBUTE pin_number OF pp_autofd_n	: SIGNAL IS "a10k240@141";
ATTRIBUTE pin_number OF pp_selectin_n	: SIGNAL IS "a10k240@142";
ATTRIBUTE pin_number OF pp_ack_n	: SIGNAL IS "a10k240@143";
ATTRIBUTE pin_number OF pp_busy	: SIGNAL IS "a10k240@144";
ATTRIBUTE pin_number OF pp_error	: SIGNAL IS "a10k240@146";
ATTRIBUTE pin_number OF pp_select	: SIGNAL IS "a10k240@147";
ATTRIBUTE pin_number OF pp_fault_n	: SIGNAL IS "a10k240@148";
ATTRIBUTE pin_number OF u_rx1	: SIGNAL IS "a10k240@149";
ATTRIBUTE pin_number OF u_rx2	: SIGNAL IS "a10k240@151";
ATTRIBUTE pin_number OF u_tx1	: SIGNAL IS "a10k240@152";
ATTRIBUTE pin_number OF u_tx2	: SIGNAL IS "a10k240@153";
ATTRIBUTE pin_number OF ee_sda	: SIGNAL IS "a10k240@154";
ATTRIBUTE pin_number OF ee_clk	: SIGNAL IS "a10k240@156";
ATTRIBUTE pin_number OF ee_wp	: SIGNAL IS "a10k240@157";
ATTRIBUTE array_pin_number OF led : SIGNAL IS
	("a10k240@158","a10k240@159","a10k240@161","a10k240@162","a10k240@163","a10k240@164","a10k240@166","a10k240@167","a10k240@168","a10k240@169");


ATTRIBUTE array_pin_number OF mii : SIGNAL IS
	("a10k240@174","a10k240@175","a10k240@191","a10k240@192","a10k240@193","a10k240@194","a10k240@196","a10k240@198","a10k240@199",
	 "a10k240@200","a10k240@201","a10k240@202","a10k240@203","a10k240@204","a10k240@206","a10k240@207","a10k240@208","a10k240@214");

ATTRIBUTE array_pin_number OF vid : SIGNAL IS
	("a10k240@209","a10k240@213","a10k240@231","a10k240@238","a10k240@236","a10k240@240","a10k240@239","a10k240@23 ","a10k240@11 ");

ATTRIBUTE array_pin_number OF fw_phy : SIGNAL IS
	("a10k240@172","a10k240@173","a10k240@190","a10k240@188","a10k240@186","a10k240@185","a10k240@183","a10k240@182","a10k240@184");

ATTRIBUTE array_pin_number OF avail : SIGNAL IS
	("a10k240@171","a10k240@187");

end a10k240;

ARCHITECTURE empty of a10k240 is -------------------Architecture -----------
-- This is an empty architecture. Create an architecture to implement your
-- application logic in this or another file.
BEGIN

END empty;

-- Block Diagram:
--
--  +----a10k240--------------------------------------------------+
--  |                                                              |
--  |      +---ASIC_V8----------------------------------------+    |
--  |-<|---|                                                  |    |
--  |-|>---|   +---V8_TOP---+     +-BISTROMH-+  +-BISTROML-+  |    |
--  |      |   |            |     | 256x8    |  | 256x8    |  |    |
--  |      |   | V8 CPU     |     | ROM      |  | ROM      |  |    |
--  |      |   |            |     |          |  |          |  |    |
--  |-|>---|   +------------+     +----------+  +----------+  |    |
--  |-<|---|                                                  |    |
--  |-|>---|   +---VUART----+     +-VTIMER---+  +-VJTAG----+  |    |
--  |      |   |            |     |          |  |          |  |    |
--  |      |   |            |     |          |  |          |  |    |
--  |-|>---|   +------------+     +----------+  +----------+  |    |
--  |-<|---|                                                  |    |
--  |-|>---|   +---VUSBT----+     +-other----+  +-Your-----+  |    |
--  |      |   |Optional    |     |          |  | logic    |  |    |
--  |      |   |USB Core    |     |          |  | here     |  |    |
--  |-|>---|   +------------+     +----------+  +----------+  |    |
--  |-<|---|                                                  |    |
--  |      +--------------------------------------------------+    |
--  | IO cells only at this level                                  |
--  +--------------------------------------------------------------+
--
--------------------------------------------------------------------------------

ARCHITECTURE synth of a10k240 is ----------------ARCHITECTURE-------------
COMPONENT asic_v8
  port( clk48        : in  std_ulogic; -- clock
        clken_12o    : out std_ulogic; -- unbuffered clock
        clken_12     : in  std_ulogic; -- free running 12 mhz clock
        clken_dpllo  : out std_ulogic; -- USB DPLL unbuffered clock
        clken_dpll   : in  std_ulogic; -- USB buffered clock
        clk_sieo     : out std_ulogic; -- buffered sie clock
        clk_cpuo     : out std_ulogic; -- buffered cpu clock
        sleep        : out std_ulogic; -- stop the clock
        stop_osc     : out std_ulogic; -- stop the oscillator
        rst_raw_n    : in  std_ulogic; -- unregistered reset.
        addr         : out std_ulogic_vector(16 downto 0); -- external address bus
        datain       : in  std_ulogic_vector(7 downto 0); -- external data bus in
        dataout      : out std_ulogic_vector(7 downto 0); -- external data bus out
        read         : out std_ulogic; -- read cycle
        cpu_write    : out std_ulogic; -- processor write cycle
        usb_write    : out std_ulogic; -- usb dma write cycle
        ready        : in  std_ulogic; -- 0=insert wait states,1=run
        -- Misc. off-chip interface signals
        ram_ce       : out std_ulogic; -- external sram chip enable
        ram_ce_enb   : out std_ulogic; -- SRAM CE tristate enable
        page2_ce     : out std_ulogic; -- IO register space
        ext_int      : in  std_ulogic; -- External Interrupt
        bus_req      : in  std_ulogic; -- external bus request
        bus_gnt      : out std_ulogic; -- external bus grant
        pwm          : out std_ulogic; -- Timer output
        -- audio chip control signals
        a_addr       : out std_ulogic_vector(1 downto 0); -- address bus
        a_ce         : out std_ulogic; -- chip enable
        a_datai      : in  std_ulogic_vector( 7 downto 0); -- data bus
        a_datao      : out std_ulogic_vector( 7 downto 0); -- data bus
        a_oe_n       : out std_ulogic; -- active low output enable
        a_we_n       : out std_ulogic; -- active low write enable
        -- video chip data signals
        video        : in  std_ulogic_vector(8 downto 0); -- video data
        -- Universal Serial Bus (USB) control signals
        u_chan0i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan0o     : out std_ulogic_vector(4 downto 0); -- USB interface
        usb_en       : out std_ulogic;                    -- USB pull up enable
        u_chan1i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan1o     : out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan2i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan2o     : out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan3i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan3o     : out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan4i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan4o     : out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan5i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan5o     : out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan6i     : in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan6o     : out std_ulogic_vector(4 downto 0); -- USB interface
        u_pwr1_off   : out std_ulogic; -- USB interface
        u_pwr2_off   : out std_ulogic; -- USB interface
        u_pwr3_off   : out std_ulogic; -- USB interface
        u_pwr1_sense : in  std_ulogic; -- USB interface
        u_pwr2_sense : in  std_ulogic; -- USB interface
        u_pwr3_sense : in  std_ulogic; -- USB interface
        --  USB Port Power Control Signals
        usba1_pwron  : out std_ulogic; -- Downstream port 1 Power Enable
        usba2_pwron  : out std_ulogic; -- Downstream port 2 Power Enable
        usba3_pwron  : out std_ulogic; -- Downstream port 3 Power Enable
        usba4_pwron  : out std_ulogic; -- Downstream port 4 Power Enable
        usba5_pwron  : out std_ulogic; -- Downstream port 5 Power Enable
        usba6_pwron  : out std_ulogic; -- Downstream port 6 Power Enable
        -- RS232 UART interface
        u_rx         : in  std_ulogic; -- serial data in
        u_tx         : out std_ulogic; -- serial data out
        -- IEEE 1284 PC Parallel Port interface (signal names are "compatible" names)
        pp_strobe_n  : out std_ulogic;
        pp_datai     : in  std_ulogic_vector(8 downto 1);
        pp_datao     : out std_ulogic_vector(8 downto 1);
        pp_data_enb  : out std_ulogic;
        pp_ctl_in    : in  std_ulogic_vector(7 downto 0);
        pp_ctl_out   : out std_ulogic_vector(7 downto 0);
        pp_ctl_enb   : out std_ulogic_vector(7 downto 0);
        -- eeprom control signals - I2C bus
        e_sda_in     : in  std_ulogic;
        e_sda_out    : out std_ulogic;
        e_clk_in     : in  std_ulogic;
        e_clk_out    : out std_ulogic;
        -- JTAG signals
        tck          : in  std_ulogic;
        tms          : in  std_ulogic;
        tdiin        : in  std_ulogic;
        tdiout       : out std_ulogic;
        tdi_enb      : out std_ulogic;
        tdoin        : in  std_ulogic;
        tdoout       : out std_ulogic;
        tdo_enb      : out std_ulogic; -- tristate enable
        jtag_enb     : out std_ulogic; -- JTAG control tristate enable
        tckout       : out std_ulogic; -- tck output
        tmsout       : out std_ulogic; -- tms output
        -- USB clocking signals - not used in V8 only applications
        com_clk_b    : out std_ulogic; -- USB DPLL out
        uwrt_clk     : out std_ulogic; -- clock used to generate the write pulse
        -- debug signals
        psr          : out std_ulogic_vector(7 downto 0); -- flags
        op_ftch      : out std_ulogic; -- indicates an opcode fetch
        debug        : out std_ulogic_vector(23 downto 0)); -- debugging signals
END COMPONENT;

COMPONENT global 
  port(a_in : in  std_logic;
       a_out : out std_logic);
END COMPONENT;

COMPONENT tribuf 
  port(in1 : in  std_logic;
       oe : in std_logic;
       y : out std_logic);
END COMPONENT;

CONSTANT Zs	: std_logic_vector(7 downto 0) := "ZZZZZZZZ";	-- tristate

SIGNAL psr 	: std_logic_vector(7 downto 0);
SIGNAL u_chan0i,u_chan1i,u_chan2i,u_chan3i 	: std_logic_vector(2 downto 0);
SIGNAL u_chan4i,u_chan5i,u_chan6i 	: std_logic_vector(2 downto 0);
SIGNAL u_chan0o,u_chan1o,u_chan2o,u_chan3o 	: std_logic_vector(4 downto 0);
SIGNAL u_chan4o,u_chan5o,u_chan6o 	: std_logic_vector(4 downto 0);
SIGNAL u_pwr1_off,u_pwr1_sense 	: std_logic;
SIGNAL u_pwr2_off,u_pwr2_sense 	: std_logic;
SIGNAL u_pwr3_off,u_pwr3_sense 	: std_logic;
SIGNAL usb_en : std_logic;             -- USB speed bias resistor enable.
SIGNAL pp_ctl_in 	: std_logic_vector(7 downto 0);
SIGNAL pp_ctl_out 	: std_logic_vector(7 downto 0);
SIGNAL pp_ctl_enb	: std_logic_vector(7 downto 0);
SIGNAL pp_datai 	: std_logic_vector(7 downto 0);
SIGNAL pp_datao 	: std_logic_vector(7 downto 0);
SIGNAL pp_data_enb 	: std_logic;
SIGNAL pp_strobe_out_n 	: std_logic;
SIGNAL page2_ce 	: std_logic;
SIGNAL ready            : std_logic;
SIGNAL ram_ce_enb 	: std_logic;
SIGNAL addr 	: std_logic_vector(16 downto 0);
SIGNAL datain 	: std_logic_vector(7 downto 0);
SIGNAL dataout 	: std_logic_vector(7 downto 0);
SIGNAL a_datao 	: std_logic_vector(7 downto 0);
SIGNAL debug 	: std_logic_vector(23 downto 0);
SIGNAL ram_ce 	: std_logic;
SIGNAL a_cs 	: std_logic;
SIGNAL a_tri_enb: std_logic;
SIGNAL op_ftch 	: std_logic;
SIGNAL ext_int 	: std_logic;
SIGNAL cpu_write  	: std_logic; 	-- processor write cycle
SIGNAL usb_write  	: std_logic; 	-- usb dma write cycle
SIGNAL read 	: std_logic;
SIGNAL bus_req 	: std_logic;
SIGNAL bus_gnt 	: std_logic;
SIGNAL ee_sda_out 	: std_logic; -- EEPROM I2C bus outputs
SIGNAL ee_clk_out 	: std_logic; -- EEPROM I2C bus outputs
SIGNAL bogus_altera_signal 	: std_logic; -- required to route!
SIGNAL reset_f 	: std_logic; -- flopped version of reset

--SIGNAL clk48, clk48pre	: std_logic;
SIGNAL sysclk      : std_logic; -- System clock 48MHz for HS or 6MHz for LS
SIGNAL sysclk_pre  : std_logic; -- System clock before the global buffer
SIGNAL sysclk_buf  : std_logic; -- System clock after the global buffer
SIGNAL clken_12, clken_12o	: std_logic;
SIGNAL clken_dpll, clken_dpllo	: std_logic;
SIGNAL clk_cpu_buf, clk_sie_buf : std_logic; -- buffered clocks for write pulse generation
SIGNAL sleep, sleep_f, sleep_ff, sleep_fff, stop_osc	: std_logic;
SIGNAL clk_div     : std_logic_vector(2 downto 0); -- Clock divide
SIGNAL reset_n_f   : std_logic; -- Reset delayed one 48MHz clock
SIGNAL reset_n_ff  : std_logic; -- Reset delayed two 48MHz clocks
SIGNAL reset_pulse : std_logic; -- Reset pulse
--ATTRIBUTE LOC : STRING;
--ATTRIBUTE LOC OF clkbuf1 : LABEL IS "BUFGLS_ESE";   -- Place the global clock buffer

--SIGNAL uclk, uwrt_clk : std_logic;
--ATTRIBUTE LOC : STRING;
--ATTRIBUTE LOC OF clkbuf2 : LABEL IS "BUFGLS_ESE";   -- Place the global clock buffer

SIGNAL tdoout, tdo_enb, tdiout, tdi_enb, jtag_enb,
	tckout,tmsout	: std_logic; -- JTAG signals

ATTRIBUTE noopt : boolean;	-- exemplar directives
--ATTRIBUTE noopt OF clkbuf1 : LABEL IS true;   -- don't touch the clock buffers
--ATTRIBUTE noopt OF clkbuf2 : LABEL IS true;   -- don't touch the clock buffers
--ATTRIBUTE noopt OF clkbuf3 : LABEL IS true;   -- don't touch the clock buffers
ATTRIBUTE BUFFER_SIG : string;	-- exemplar directives
ATTRIBUTE BUFFER_SIG OF sysclk   : SIGNAL IS "GLOBAL";   -- buffer the clock
ATTRIBUTE BUFFER_SIG OF clken_dpll : SIGNAL IS "GLOBAL";   -- buffer the clock
ATTRIBUTE BUFFER_SIG OF tcki       : SIGNAL IS "GLOBAL";   -- buffer the clock
ATTRIBUTE BUFFER_SIG OF gclk0 : SIGNAL IS "GLOBAL";   -- clken_12
ATTRIBUTE BUFFER_SIG OF gclk1 : SIGNAL IS "GLOBAL";   -- clk48 after the
                                                      -- pwr save
BEGIN	----------------------------------------------------------------------

-- manually instantiate the input buffer and global clock buffer and place
-- them in specific sites with attributes above.
--clkbuf1 : GLOBAL port map (a_in => sysclk_pre, a_out=> sysclk_buf);
gclk1_out <= sysclk_pre;
sysclk_buf <= gclk1;

--clkbuf2 : GLOBAL port map (a_in => clken_12o, a_out=> clken_12);
gclk0_out <= clken_12o;
clken_12 <= gclk0;

--clkbuf3 : GLOBAL port map (a_in => clken_dpllo, a_out=> clken_dpll);
clken_dpll <= clken_dpllo OR bogus_altera_signal;

a_data	<= a_datao when a_tri_enb='1' else Zs;	-- tri
a_tri_enb <= a_cs AND cpu_write and NOT bogus_altera_signal;
a_cs_n	<= not a_cs;	-- out

led 	<= (clken_12 xor bogus_altera_signal) & -- to the logic analyzer pods
	(clken_dpll xor bogus_altera_signal) & 	-- to the LA
	psr;				-- to the LEDs

pp_data(1) 	<= pp_datao(0) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(2) 	<= pp_datao(1) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(3) 	<= pp_datao(2) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(4) 	<= pp_datao(3) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(5) 	<= pp_datao(4) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(6) 	<= pp_datao(5) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(7) 	<= pp_datao(6) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(8) 	<= pp_datao(7) when pp_data_enb='1' else 'Z';	-- bidir
pp_datai <= pp_data(8) & pp_data(7) & pp_data(6) & pp_data(5) & 
	     pp_data(4) & pp_data(3) & pp_data(2) & pp_data(1);
pp_strobe_n	<= '0' when pp_strobe_out_n='0' else 'Z';	-- open drain
pp_ack_n	<= pp_ctl_out(4) when pp_ctl_enb(4)='1' else 'Z';-- tri
pp_busy 	<= pp_ctl_out(3) when pp_ctl_enb(3)='1' else 'Z';-- tri
pp_error	<= pp_ctl_out(2) when pp_ctl_enb(2)='1' else 'Z';-- tri
pp_select	<= pp_ctl_out(1) when pp_ctl_enb(1)='1' else 'Z';-- tri
pp_autofd_n	<= pp_ctl_out(6) when pp_ctl_enb(6)='1' else 'Z';-- tri
pp_fault_n	<= pp_ctl_out(0) when pp_ctl_enb(0)='1' else 'Z';-- tri
pp_init_n	<= pp_ctl_out(7) when pp_ctl_enb(7)='1' else 'Z';-- tri
pp_selectin_n	<= pp_ctl_out(5) when pp_ctl_enb(5)='1' else 'Z';-- tri
pp_ctl_in <= pp_init_n & pp_autofd_n & pp_selectin_n & pp_ack_n & pp_busy & pp_error & pp_select & pp_fault_n;

ee_sda	<= '0' when ee_sda_out='0' else 'Z';-- open drain
ee_clk	<= '0' when ee_clk_out='0' else 'Z';-- open drain

-- JTAG tristate enable logic
tcko <= tckout when jtag_enb = '1' else 'Z';
tdo <= tdoout when tdo_enb='1' else 'Z';
tms <= tmsout when jtag_enb='1' else 'Z';
tdi <= tdiout when tdi_enb='1' else 'Z';

-- sram interface
r_addr <= addr;
datain <= r_data(7 downto 0);
r_data(7 downto 0) <= dataout when (cpu_write='1' OR usb_write='1') 
	and bogus_altera_signal='0' else Zs;
r_data(15 downto 8) <= dataout when (cpu_write='1' OR usb_write='1') 
	and bogus_altera_signal='0' else Zs;
r_ce_n <= NOT ram_ce when ram_ce_enb='1' else 'Z';
r_oe_n <= NOT read;

-----------------------
-- NOTE! This gate MUST be hand placed! which is done in the a10k240.acf file.
--r_wel_n <= (NOT cpu_write OR clken_12) AND (NOT usb_write OR clken_dpll);
r_wel_n <= (NOT cpu_write OR clk_cpu_buf) AND (NOT usb_write OR clk_sie_buf);

r_weh_n <= '1'; -- not used.

-----------------------------------------------------------------
-- See the pwr_save.vhd file for more details on the requirements
-- for going to sleep. Since we don't have an oscillator IO cell
-- in an FPGA, we implement the sleep mode and emulate the stop_osc
-- mode simply by gating the clock out to a test pin.
-- Note these these are the only 3 flops that run directly on the
-- oscillator input without a global clock buffer
PROCESS (sysclk,reset_n)
BEGIN
  if (reset_n='0') then	-- ASYNC reset required!!!
    sleep_fff <= '0';
    sleep_ff <= '0';
    sleep_f <= '0';
  elsif (sysclk'event and sysclk='1') then
    sleep_fff <= sleep_ff;
    sleep_ff <= sleep_f;
    sleep_f <= sleep;
  end if;
END PROCESS;

-- This is the gate on the clock.
sysclk_pre <= sleep_fff OR sysclk;

-- System clock is 48MHz for high speed devices or 6MHz for low speed.
sysclk <= clk48mhz   when lsdev = 0 else
          clk_div(2) when lsdev = 1 else
          'X';

--------------------------------------------------------------------------------
-- This process divides the clk48mhz signal by 8 to create 6 MHz to implement 
-- a low speed device.
--------------------------------------------------------------------------------
PROCESS (clk48mhz)
BEGIN

  -- Wait for rising edge of clk_usb
  if clk48mhz'event and (clk48mhz = '1') then
    reset_n_ff <= not reset_n_f;
    reset_n_f  <= reset_n;

    if reset_pulse = '0' then -- reset clk_div
      clk_div <= "000";
    else -- inc clk_div
      clk_div <= unsigned(clk_div) + 1;
    end if;
  end if;
    
END PROCESS;

reset_pulse <= reset_n_f or reset_n_ff;

-- Normally you will want an oscillator IO cell with an enable.
-- connect the STOP_OSC to the enable (which turns off the oscillator when
-- stop_osc is 1).
-- osc_out <= NOT (sysclk OR stop_osc); -- we don't have any spare pins on the a10k240 so this line is commented out.

v8: asic_v8	---------------------------Create the internal logic here------
  port MAP (
    clk48        => sysclk_buf,
    clken_12o    => clken_12o,
    clken_12     => clken_12,	-- in FPGAs the best we can do is ~12Mhz
    clken_dpllo  => clken_dpllo,
    clken_dpll   => clken_dpll,
    clk_sieo     => clk_sie_buf, -- buffered sie clock
    clk_cpuo     => clk_cpu_buf, -- buffered cpu clock
    sleep        => sleep,
    stop_osc     => stop_osc,
    rst_raw_n    => reset_n,   -- unregistered reset.
    To_StdLogicVector(addr)         => addr,
    datain       => To_StdULogicVector(datain),
    To_StdLogicVector(dataout)      => dataout,
    read         => read,
    cpu_write    => cpu_write,
    usb_write    => usb_write,
    ready        => ready,
    ram_ce       => ram_ce,
    ram_ce_enb   => ram_ce_enb,
    page2_ce     => page2_ce,
    ext_int      => ext_int,
    bus_req      => bus_req,
    bus_gnt      => bus_gnt,
    pwm          => ee_wp,	-- BOGUS
    -- audio chip control signals
    To_StdLogicVector(a_addr)       => a_addr,
    a_ce         => a_cs,
    a_datai      => To_StdULogicVector(a_data),
    To_StdLogicVector(a_datao)      => a_datao,
    a_oe_n       => a_rd_n,
    a_we_n       => a_wr_n,
    -- Video data
    video        => To_StdULogicVector(vid),
    -- USB control signals
    u_chan0i     => To_StdULogicVector(u_chan0i),
    To_StdLogicVector(u_chan0o)     => u_chan0o,
    usb_en       => usb_en,                 -- USB pull up enable
    u_chan1i     => To_StdULogicVector(u_chan1i),
    To_StdLogicVector(u_chan1o)     => u_chan1o,
    u_chan2i     => To_StdULogicVector(u_chan2i),
    To_StdLogicVector(u_chan2o)     => u_chan2o,
    u_chan3i     => To_StdULogicVector(u_chan3i),
    To_StdLogicVector(u_chan3o)     => u_chan3o,
    u_chan4i     => To_StdULogicVector(u_chan4i),
    To_StdLogicVector(u_chan4o)     => u_chan4o,
    u_chan5i     => To_StdULogicVector(u_chan5i),
    To_StdLogicVector(u_chan5o)     => u_chan5o,
    u_chan6i     => To_StdULogicVector(u_chan6i),
    To_StdLogicVector(u_chan6o)     => u_chan6o,
    u_pwr1_off   => u_pwr1_off,
    u_pwr2_off   => u_pwr2_off,
    u_pwr3_off   => u_pwr3_off,
    u_pwr1_sense => u_pwr1_sense,
    u_pwr2_sense => u_pwr2_sense,
    u_pwr3_sense => u_pwr3_sense,
    --  USB Port Power Control Signals
    usba1_pwron  => usba1_pwron, 
    usba2_pwron  => usba2_pwron, 
    usba3_pwron  => usba3_pwron, 
    usba4_pwron  => usba4_pwron, 
    usba5_pwron  => usba5_pwron, 
    usba6_pwron  => usba6_pwron, 
    -- uart control signals
    u_rx         => u_rx1,
    u_tx         => u_tx1,
    -- IEEE 1284 PC Parallel Port interface
    pp_strobe_n  => pp_strobe_out_n,
    pp_datai     => To_StdULogicVector(pp_datai),
    To_StdLogicVector(pp_datao)     => pp_datao,
    pp_data_enb  => pp_data_enb,
    pp_ctl_in    => To_StdULogicVector(pp_ctl_in),
    To_StdLogicVector(pp_ctl_out)   => pp_ctl_out,
    To_StdLogicVector(pp_ctl_enb)   => pp_ctl_enb,
    -- EEPROM control signals - I2C bus
    e_sda_in     => ee_sda,
    e_sda_out    => ee_sda_out,
    e_clk_in     => ee_clk,
    e_clk_out    => ee_clk_out,
    -- JTAG signals
    tck          => tcki,
    tms          => tms,
    tdiin        => tdi,
    tdiout       => tdiout,
    tdi_enb      => tdi_enb,
    tdoin        => tdo,
    tdoout       => tdoout,
    tdo_enb      => tdo_enb,
    jtag_enb     => jtag_enb,
    tckout       => tckout,
    tmsout       => tmsout,
    -- debug signals
    To_StdLogicVector(psr)          => psr,
    op_ftch      => op_ftch,
    To_StdLogicVector(debug)        => debug);	--------End of asic_v8--------------

-------------------- USB connections------------
------------USB downstream "A" connectors for hub or host mode.
   -- downstream ports 1 through 3 are designed to use an external
   -- USB transceiver
u_chan1i        <= usba1_vm & usba1_vp & usba1_rcv;
usba1_vmo       <= u_chan1o(4);
usba1_vpo       <= u_chan1o(3);
usba1_speed     <= u_chan1o(2);
-- suspend is hardwired low.
usba1_oe_n      <= u_chan1o(0);


u_chan2i        <= usba2_vm & usba2_vp & usba2_rcv;
usba2_vmo       <= u_chan2o(4);
usba2_vpo       <= u_chan2o(3);
usba2_speed     <= u_chan2o(2);
-- suspend is hardwired low.
usba2_oe_n      <= u_chan2o(0);


u_chan3i        <= usba3_vm & usba3_vp & usba3_rcv;
usba3_vmo       <= u_chan3o(4);
usba3_vpo       <= u_chan3o(3);
usba3_speed     <= u_chan3o(2);
-- suspend is hardwired low.
usba3_oe_n      <= u_chan3o(0);

   -- downstream ports 4 through 6 implement the tranceiver in the Xilinx I/O
   -- cells.  The differential receiver is not available in FPGAs, so a
   -- single ended recieve of dplus is used as the RCV differencial input.
u_chan4i        <= usba4_dminus & usba4_dplus & usba4_dplus;
usba4_dminus    <= u_chan4o(4) when u_chan4o(0) = '1' else 'Z';
usba4_dplus     <= u_chan4o(3) when u_chan4o(0) = '1'  else 'Z';

u_chan5i        <= usba5_dminus & usba5_dplus & usba5_dplus;
usba5_dminus    <= u_chan5o(4) when u_chan5o(0) = '1'  else 'Z';
usba5_dplus     <= u_chan5o(3) when u_chan5o(0) = '1'  else 'Z';

u_chan6i        <= usba6_dminus & usba6_dplus & usba6_dplus;
usba6_dminus    <= u_chan6o(4) when u_chan6o(0) = '1'  else 'Z';
usba6_dplus     <= u_chan6o(3) when u_chan6o(0) = '1'  else 'Z';
 
------------USB upstream "B" connector for hub or function.
u_chan0i        <= usbb_vm & usbb_vp & usbb_rcv;
usbb_vmo        <= u_chan0o(4);
usbb_vpo        <= u_chan0o(3);
usbb_speed      <= u_chan0o(2);
-- suspend is hardwired low.
usbb_oe_n       <= u_chan0o(0);

bus_req <= '0'; -- unused
ready <= '1'; -- unused

u_tx2 <= u_rx2;

-- The usbb_high and usbb_low signals allow us to bias the dplus and dminus
-- signals. So the IPS can do both LS and FS devices.
usbb_high <= '0' WHEN lsdev = 1 AND usb_en = '1' ELSE
             '1' WHEN lsdev = 0 AND usb_en = '1' ELSE
             'Z';
usbb_low  <= '1' WHEN lsdev = 1 AND usb_en = '1' ELSE
             '0' WHEN lsdev = 0 AND usb_en = '1' ELSE
             'Z';

usbb_host1 <= '1' when bogus_altera_signal='1' else 'Z'; -- use these if you want to switch from a device to a host on the same connector.
usbb_host2 <= '1' when bogus_altera_signal='1' else 'Z';

-- The signals below are generally available for debug signals.
avail(0) <= '1' when bogus_altera_signal='1' else 'Z'; -- eventually used for UART hardware flow control
avail(1) <= '1' when bogus_altera_signal='1' else 'Z'; -- eventually used for UART hardware flow control
mii(2) <= '1' when bogus_altera_signal='1' else 'Z';
mii(3) <= '1' when bogus_altera_signal='1' else 'Z';
mii(4) <= '1' when bogus_altera_signal='1' else 'Z';
mii(5) <= '1' when bogus_altera_signal='1' else 'Z';
mii(6) <= '1' when bogus_altera_signal='1' else 'Z';
mii(7) <= '1' when bogus_altera_signal='1' else 'Z';
mii(8) <= '1' when bogus_altera_signal='1' else 'Z';
mii(9) <= '1' when bogus_altera_signal='1' else 'Z';
mii(10) <= '1' when bogus_altera_signal='1' else 'Z';
mii(11) <= '1' when bogus_altera_signal='1' else 'Z';
mii(12) <= '1' when bogus_altera_signal='1' else 'Z';
mii(13) <= '1' when bogus_altera_signal='1' else 'Z';
mii(14) <= '1' when bogus_altera_signal='1' else 'Z';
mii(15) <= '1' when bogus_altera_signal='1' else 'Z';
mii(16) <= '1' when bogus_altera_signal='1' else 'Z';
mii(17) <= '1' when bogus_altera_signal='1' else 'Z';
mii(18) <= '1' when bogus_altera_signal='1' else 'Z';
mii(19) <= '1' when bogus_altera_signal='1' else 'Z';

ext_int <= '0'; -- not currently used.

-------------------------------------------------------------------------
-- The following logic is required to get an Altera 10K100 to route in
-- Maxplus2 9.01. Exactly why it won't route we're not sure, but this
-- does fix it. The problem is that when global clock buffers are routed
-- to IO pins for debug, max2 is unable to perform this route.
-- Also, since we want to place the WRITE flop which also drives some
-- tristate enables on some IO cells, it won't route either.
-- By placing an XOR with a signal that is basically never true,
-- into the paths, max2 is able to route the signal... UGH...
bogus_altera_signal <= reset_f AND NOT reset_n; -- active only for a small time when reset_n is being asserted.

process (clken_12) begin
  if (clken_12'event AND clken_12='1') then
    reset_f <= NOT reset_n;
  end if;
end process;

-- Altera 10Ks will drive any unprogrammed IO cell to ground!
-- YIKES! We have to be very careful and insert a tristate output
-- buffer on all unused IO cells. We tristate them when not reset.
usbb_dplus <= '0' when bogus_altera_signal='1' else 'Z';
usbb_dminus <= '0' when bogus_altera_signal='1' else 'Z';
usba1_dplus <= '0' when bogus_altera_signal='1' else 'Z';
usba1_dminus <= '0' when bogus_altera_signal='1' else 'Z';
usba2_dplus <= '0' when bogus_altera_signal='1' else 'Z';
usba2_dminus <= '0' when bogus_altera_signal='1' else 'Z';
usba3_dplus <= '0' when bogus_altera_signal='1' else 'Z';
usba3_dminus <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(0) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(1) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(2) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(3) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(4) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(5) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(6) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(7) <= '0' when bogus_altera_signal='1' else 'Z';
fw_phy(8) <= '0' when bogus_altera_signal='1' else 'Z';
END synth ;
