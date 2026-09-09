--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
-- HTTP://www.vautomation.com
--
-- File: xil240hq.vhd
--
-- Description:
--      This is a shell for a unprogrammed Xilinx 4000EX/XL family part in
--      a 240-pin plastic quad flatpack package.  It defines how the pins
--      of the device are conneted to the board. A null architecture is included
--      in this file.
--
-- Signals ending in _n are active low.
--


--------------------------------------------------------------------------------
-- Revision History
-- $Log: xil240hq.vhd,v $
-- Revision 1.25  1999/11/09 14:28:30  mark
-- updated xil240hq to handle ulogicified asic_v8 component
--
-- Revision 1.24  1999/09/15 21:38:08  chris
-- Improved sleep reset for gate level simulation.
--
-- Revision 1.23  1999/06/24 13:56:41  chris
-- Added genric lsdev to allow low speed devices in the same testbench
-- as full speed devices.
-- Added software controlled usb biasing to allow control of connection events.
--
-- Revision 1.22  1999/05/17 17:54:44  gregg
-- Added LOW_SPEED_DEV to usbb_high and usbb_low terms
--
-- Revision 1.21  1999/04/08 18:47:39  gregg
-- Added clk48mhz divide by 8 to implement low speed devices.
--
-- Revision 1.20  1999/04/01 19:46:31  eric
-- Corrected async reset syntax for conversion to verilog.
--
-- Revision 1.19  1999/03/31 22:02:36  eric
-- Updated with the new pwr_save module requirements.
--
-- Revision 1.18  1998/11/17 20:33:25  eric
-- Just removed driving avail.
--
-- Revision 1.17  1998/10/27 13:36:06  eric
-- Drive the CPU clock out clk_fclk1 for debugging purposes.
--
-- Revision 1.16  1998/10/23 18:30:55  john
-- Added clocks to led (8:9).
--
-- Revision 1.15  1998/10/22 20:34:50  chris
-- Changed clk_xtra to input, so it would not conflict with the FW_PHY sysclk.
--
-- Revision 1.14  1998/09/01 14:27:52  john
-- Changed direction of hub power_dp lines and connected to pwron pins.
--
-- Revision 1.13  1998/08/18 01:41:46  eric
-- Added video, Exemplar doesn't crash on inserting unused IBUFs on USB_PLUS.
--
-- Revision 1.12  1998/07/30 15:47:28  eric
-- Added the input IO cells on DPLUS/DMINUS to eliminate the
-- 50-100K ohm pullups on unconfigured IO cells.
--
-- Revision 1.11  1998/07/13 21:36:09  gregg
-- Changed case on xil_io components for vhdl2v conversion
--
-- Revision 1.10  1998/07/02 12:09:26  eric
-- WE_N is placed in the right spot now.
--
-- Revision 1.9  1998/06/19 15:02:12  chris
-- Asserted USB upstream full speed bias signal usbb_high.
--
-- Revision 1.8  1998/06/17 16:35:37  chris
-- Connected 6 downstream hub ports, and hub debug bus on high r_data.
--
-- Revision 1.7  1998/06/11 14:50:24  chris
-- Removed explicit IBUF instance on clk_usb for gc.
--
-- Revision 1.6  1998/06/09 15:40:55  chris
-- Changed clock connections to support both FPGA and ASIC (low and high speed)
-- operation.
-- Corrected Hub port connections.
--
-- Revision 1.5  1998/06/02 17:11:07  chris
-- Removed old usb clock signals.
--
-- Revision 1.4  1998/06/02 15:44:21  chris
-- Added op_ftch to avail(0).
-- Removed reset syncronizer.
-- Moved write I/O gates.
--
-- Revision 1.3  1998/05/31 03:03:42  eric
-- first attempt at a 4062.
--
-- Revision 1.2  1998/05/29 20:07:50  eric
-- Added the gates to write and started fixing clocks.
--
-- Revision 1.1  1998/04/13 15:30:25  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.cfg_usb.all;

ENTITY xil240hq IS --------------------------ENTITY---------------------
  GENERIC (lsdev : integer := LOW_SPEED_DEV);
  PORT (clk_cpu       : INOUT std_logic := 'Z'; -- not used
        clk48mhz      : INOUT std_logic := 'Z'; -- 48 MHz oscilator input
        clk_1394      : INOUT std_logic := 'Z'; -- not used
        clk_xtra      : IN    std_logic;        -- FW_PHY sysclk
        clk_fclk1     : INOUT std_logic := 'Z'; -- not used
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
        -- IrDA interface
        i_rxd         : IN    std_logic;
        i_sd          : OUT   std_logic := 'Z';
        i_txd         : OUT   std_logic := 'Z';
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
        -- 1394 PHY interface
        fw_phy        : INOUT std_logic_vector(8 downto 0) := (others =>'Z');
        -- video interface
        video         : INOUT std_logic_vector(8 downto 0) := (others =>'Z');
        -- LED indicator
        led           : OUT   std_logic_vector(9 downto 0) := (others =>'Z');
        -- Expansion connector (pinned out for MII compatiblity)
        mii           : INOUT std_logic_vector(19 downto 2) := (others =>'Z');
        -- Available pins...
        avail         : INOUT std_logic_vector(4 downto 0) := (others =>'Z');
        -- Xilinx configuration pins
        m0            : IN    std_logic;
        m1            : IN    std_logic;
        m2            : IN    std_logic;
        init_n        : IN    std_logic;
        done          : IN    std_logic;
        prog_n        : IN    std_logic;
        din           : IN    std_logic;
        dout          : OUT   std_logic := 'Z';
        cclk          : IN    std_logic;
        tck           : INOUT std_logic := 'Z';
        tms           : INOUT std_logic := 'Z';
        tdi           : INOUT std_logic := 'Z';
        tdo           : INOUT std_logic := 'Z';
        -- power pins (GND pins are done as an attribute)
        vcc19         : IN    std_logic;
        vcc30         : IN    std_logic;
        vcc40         : IN    std_logic;
        vcc61         : IN    std_logic;
        vcc80         : IN    std_logic;
        vcc90         : IN    std_logic;
        vcc101        : IN    std_logic;
        vcc121        : IN    std_logic;
        vcc140        : IN    std_logic;
        vcc150        : IN    std_logic;
        vcc161        : IN    std_logic;
        vcc180        : IN    std_logic;
        vcc201        : IN    std_logic;
        vcc212        : IN    std_logic;
        vcc222        : IN    std_logic;
        vcc240        : IN    std_logic);

-- Below are the pinout attributes for the Xilinx implementation

TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;

ATTRIBUTE pin_number: STRING;
ATTRIBUTE array_pin_number:  STRING_ARRAY;

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF xil240hq : ENTITY is "X4000@PQ240_xil";

ATTRIBUTE GND_pins:  STRING_ARRAY;
ATTRIBUTE GND_pins OF xil240hq: ENTITY IS ("P1  ","P14 ","P22 ","P29 ",
                                           "P37 ","P45 ","P59 ","P75 ",
                                           "P83 ","P91 ","P98 ","P106",
                                           "P119","P135","P143","P151","P158",
                                           "P166","P182","P196","P204",
                                           "P211","P219","P227");
-- VCC pins
ATTRIBUTE pin_number OF vcc19   : SIGNAL IS "P19";
ATTRIBUTE pin_number OF vcc30   : SIGNAL IS "P30";
ATTRIBUTE pin_number OF vcc40   : SIGNAL IS "P40";
ATTRIBUTE pin_number OF vcc61   : SIGNAL IS "P61";
ATTRIBUTE pin_number OF vcc80   : SIGNAL IS "P80";
ATTRIBUTE pin_number OF vcc90   : SIGNAL IS "P90";
ATTRIBUTE pin_number OF vcc101	: SIGNAL IS "P101";
ATTRIBUTE pin_number OF vcc121	: SIGNAL IS "P121";
ATTRIBUTE pin_number OF vcc140	: SIGNAL IS "P140";
ATTRIBUTE pin_number OF vcc150	: SIGNAL IS "P150";
ATTRIBUTE pin_number OF vcc161	: SIGNAL IS "P161";
ATTRIBUTE pin_number OF vcc180	: SIGNAL IS "P180";
ATTRIBUTE pin_number OF vcc201	: SIGNAL IS "P201";
ATTRIBUTE pin_number OF vcc212	: SIGNAL IS "P212";
ATTRIBUTE pin_number OF vcc222	: SIGNAL IS "P222";
ATTRIBUTE pin_number OF vcc240	: SIGNAL IS "P240";
-- Xilinx config pins
ATTRIBUTE pin_number OF tdi     : SIGNAL IS "P6";
ATTRIBUTE pin_number OF tck     : SIGNAL IS "P7";
ATTRIBUTE pin_number OF tms     : SIGNAL IS "P17";
ATTRIBUTE pin_number OF tdo     : SIGNAL IS "P87";
-- pin 181, the real TDO pin, requires a special xilinx primitive so don't use this pin at all.
ATTRIBUTE pin_number OF m1      : SIGNAL IS "P58";
ATTRIBUTE pin_number OF m0      : SIGNAL IS "P60";
ATTRIBUTE pin_number OF m2      : SIGNAL IS "P62";
ATTRIBUTE pin_number OF init_n  : SIGNAL IS "P89";
ATTRIBUTE pin_number OF done    : SIGNAL IS "P120";
ATTRIBUTE pin_number OF prog_n  : SIGNAL IS "P122";
ATTRIBUTE pin_number OF din     : SIGNAL IS "P177";
ATTRIBUTE pin_number OF dout    : SIGNAL IS "P178";
ATTRIBUTE pin_number OF cclk    : SIGNAL IS "P179";
ATTRIBUTE pin_number OF clk_cpu : SIGNAL IS "P63";
ATTRIBUTE pin_number OF clk48mhz  : SIGNAL IS "P2";
ATTRIBUTE pin_number OF clk_fclk1: SIGNAL IS "P15";
ATTRIBUTE pin_number OF clk_1394: SIGNAL is ("P124");
ATTRIBUTE pin_number OF clk_xtra: SIGNAL is ("P184");
ATTRIBUTE pin_number OF reset_n : SIGNAL IS  "P88 ";

ATTRIBUTE pin_number OF usbb_dplus	: SIGNAL IS "P92 ";
ATTRIBUTE pin_number OF usbb_dminus	: SIGNAL IS "P85 ";
ATTRIBUTE pin_number OF usbb_rcv	: SIGNAL IS "P82 ";
ATTRIBUTE pin_number OF usbb_vp	: SIGNAL IS "P79 ";
ATTRIBUTE pin_number OF usbb_vm	: SIGNAL IS "P77 ";
ATTRIBUTE pin_number OF usbb_oe_n	: SIGNAL IS "P74 ";
ATTRIBUTE pin_number OF usbb_speed	: SIGNAL IS "P72 ";
ATTRIBUTE pin_number OF usbb_vpo	: SIGNAL IS "P70 ";
ATTRIBUTE pin_number OF usbb_vmo	: SIGNAL IS "P56 ";
ATTRIBUTE pin_number OF usbb_low	: SIGNAL IS "P66 ";
ATTRIBUTE pin_number OF usbb_high	: SIGNAL IS "P54 ";
ATTRIBUTE pin_number OF usbb_host1	: SIGNAL IS "P4 ";
ATTRIBUTE pin_number OF usbb_host2	: SIGNAL IS "P8 ";

ATTRIBUTE pin_number OF usba1_dplus	: SIGNAL IS "P86 ";
ATTRIBUTE pin_number OF usba1_dminus	: SIGNAL IS "P84 ";
ATTRIBUTE pin_number OF usba1_rcv	: SIGNAL IS "P81 ";
ATTRIBUTE pin_number OF usba1_vp	: SIGNAL IS "P78 ";
ATTRIBUTE pin_number OF usba1_vm	: SIGNAL IS "P76 ";
ATTRIBUTE pin_number OF usba1_oe_n	: SIGNAL IS "P73 ";
ATTRIBUTE pin_number OF usba1_speed	: SIGNAL IS "P71 ";
ATTRIBUTE pin_number OF usba1_vpo	: SIGNAL IS "P69 ";
ATTRIBUTE pin_number OF usba1_vmo	: SIGNAL IS "P67 ";
ATTRIBUTE pin_number OF usba1_pwron	: SIGNAL IS "P65 ";

ATTRIBUTE pin_number OF usba2_dplus	: SIGNAL IS "P52 ";
ATTRIBUTE pin_number OF usba2_dminus	: SIGNAL IS "P50 ";
ATTRIBUTE pin_number OF usba2_rcv	: SIGNAL IS "P48 ";
ATTRIBUTE pin_number OF usba2_vp	: SIGNAL IS "P46 ";
ATTRIBUTE pin_number OF usba2_vm	: SIGNAL IS "P43 ";
ATTRIBUTE pin_number OF usba2_oe_n	: SIGNAL IS "P41 ";
ATTRIBUTE pin_number OF usba2_speed	: SIGNAL IS "P38 ";
ATTRIBUTE pin_number OF usba2_vpo	: SIGNAL IS "P35 ";
ATTRIBUTE pin_number OF usba2_vmo	: SIGNAL IS "P33 ";
ATTRIBUTE pin_number OF usba2_pwron	: SIGNAL IS "P31 ";

ATTRIBUTE pin_number OF usba3_dplus	: SIGNAL IS "P57 ";
ATTRIBUTE pin_number OF usba3_dminus	: SIGNAL IS "P55 ";
ATTRIBUTE pin_number OF usba3_rcv	: SIGNAL IS "P53 ";
ATTRIBUTE pin_number OF usba3_vp	: SIGNAL IS "P51 ";
ATTRIBUTE pin_number OF usba3_vm	: SIGNAL IS "P49 ";
ATTRIBUTE pin_number OF usba3_oe_n	: SIGNAL IS "P47 ";
ATTRIBUTE pin_number OF usba3_speed	: SIGNAL IS "P44 ";
ATTRIBUTE pin_number OF usba3_vpo	: SIGNAL IS "P42 ";
ATTRIBUTE pin_number OF usba3_vmo	: SIGNAL IS "P39 ";
ATTRIBUTE pin_number OF usba3_pwron	: SIGNAL IS "P36 ";

ATTRIBUTE array_pin_number OF a_addr : SIGNAL IS ( "P94 ","P96 ");
ATTRIBUTE pin_number OF a_wr_n  : SIGNAL IS "P107";
ATTRIBUTE pin_number OF a_rd_n  : SIGNAL IS "P109";
ATTRIBUTE pin_number OF a_cs_n  : SIGNAL IS "P111";
ATTRIBUTE array_pin_number OF a_data : SIGNAL IS
	("P113","P115","P117","P123","P126","P128","P130","P132");

ATTRIBUTE pin_number OF r_ce_n  : SIGNAL IS "P99";
ATTRIBUTE pin_number OF r_oe_n  : SIGNAL IS "P102";
ATTRIBUTE pin_number OF r_wel_n  : SIGNAL IS "P176";
ATTRIBUTE pin_number OF r_weh_n  : SIGNAL IS "P174";
ATTRIBUTE array_pin_number OF r_addr : SIGNAL IS
	("P93 ","P95 ","P97 ","P100","P103","P104","P105","P108","P110",
	 "P112","P114","P116","P118","P125","P127","P129","P131");
ATTRIBUTE array_pin_number OF r_data : SIGNAL IS
	("P133","P136","P138","P141","P144","P146","P148","P152",
	 "P154","P156","P159","P162","P164","P167","P169","P171");

ATTRIBUTE array_pin_number OF pp_data : SIGNAL IS
                ( "P12 ","P10 ","P11 ","P9  ","P5  ","P3  ","P238","P236");
ATTRIBUTE pin_number OF pp_strobe_n	: SIGNAL IS "P234";
ATTRIBUTE pin_number OF pp_init_n	: SIGNAL IS "P232";
ATTRIBUTE pin_number OF pp_autofd_n	: SIGNAL IS "P230";
ATTRIBUTE pin_number OF pp_selectin_n	: SIGNAL IS "P228";
ATTRIBUTE pin_number OF pp_ack_n	: SIGNAL IS "P225";
ATTRIBUTE pin_number OF pp_busy	: SIGNAL IS "P223";
ATTRIBUTE pin_number OF pp_error	: SIGNAL IS "P220";
ATTRIBUTE pin_number OF pp_select	: SIGNAL IS "P217";
ATTRIBUTE pin_number OF pp_fault_n	: SIGNAL IS "P215";
ATTRIBUTE pin_number OF u_rx1	: SIGNAL IS "P213";
ATTRIBUTE pin_number OF u_rx2	: SIGNAL IS "P209";
ATTRIBUTE pin_number OF u_tx1	: SIGNAL IS "P207";
ATTRIBUTE pin_number OF u_tx2	: SIGNAL IS "P205";
ATTRIBUTE pin_number OF ee_sda	: SIGNAL IS "P202";
ATTRIBUTE pin_number OF ee_clk	: SIGNAL IS "P199";
ATTRIBUTE pin_number OF ee_wp	: SIGNAL IS "P197";
ATTRIBUTE array_pin_number OF led : SIGNAL IS
	("P194","P192","P191","P190","P189","P188","P186","P183","P175","P173");

ATTRIBUTE pin_number OF i_rxd	: SIGNAL IS "P237";
ATTRIBUTE pin_number OF i_sd	: SIGNAL IS "P235";
ATTRIBUTE pin_number OF i_txd	: SIGNAL IS "P233";

ATTRIBUTE array_pin_number OF mii : SIGNAL IS
	("P231","P229","P226","P224","P221","P218","P216","P214","P210",
	 "P208","P206","P203","P200","P198","P195","P193", "P187","P185");

ATTRIBUTE pin_number OF usba4_dplus	: SIGNAL IS "P34";
ATTRIBUTE pin_number OF usba4_dminus	: SIGNAL IS "P32";
ATTRIBUTE pin_number OF usba4_pwron	: SIGNAL IS "P28";
ATTRIBUTE pin_number OF usba5_dplus	: SIGNAL IS "P26";
ATTRIBUTE pin_number OF usba5_dminus	: SIGNAL IS "P27";
ATTRIBUTE pin_number OF usba5_pwron	: SIGNAL IS "P23";
ATTRIBUTE pin_number OF usba6_dplus	: SIGNAL IS "P21";
ATTRIBUTE pin_number OF usba6_dminus	: SIGNAL IS "P20";
ATTRIBUTE pin_number OF usba6_pwron	: SIGNAL IS "P18";
ATTRIBUTE array_pin_number OF video : SIGNAL IS
	("P239","P16 ","P13 ","P25 ","P24 ", "P134","P137","P139","P142");
ATTRIBUTE array_pin_number OF fw_phy : SIGNAL IS
	("P153","P155","P157","P160","P163","P165","P168","P170","P172");
ATTRIBUTE array_pin_number OF avail : SIGNAL IS
	("P145","P147","P149","P64 ","P68 ");

end xil240hq;

architecture empty of xil240hq is -------------------Architecture -----------
-- This is an empty architecture. Create an architecture to implement your
-- application logic in this or another file.

BEGIN

END empty;

-- Block Diagram:
--
--  +----xil240hq--------------------------------------------------+
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

ARCHITECTURE struct of xil240hq is ----------------ARCHITECTURE-------------
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

COMPONENT ibuf
  port(I      : in  std_logic;
       O      : out std_logic);
END COMPONENT;
COMPONENT IPAD
  port(PAD    : in  std_logic);
END COMPONENT;
COMPONENT bufgls
  port(I      : in  std_logic;
       O      : out std_logic);
END COMPONENT;
COMPONENT obuft_ng
  port(I      : in  std_logic;
       T      : in  std_logic;
       O      : out std_logic);
END COMPONENT;
COMPONENT or2b1
  port(I0     : in  std_logic;
       I1     : in  std_logic;
       O      : out std_logic);
END COMPONENT;
COMPONENT and2
  port(I0     : in  std_logic;
       I1     : in  std_logic;
       O      : out std_logic);
END COMPONENT;
COMPONENT fmap
  port(I1,I2,I3,I4: in  std_logic;
       O      : out std_logic);
END COMPONENT;

CONSTANT Zs	: std_logic_vector(7 downto 0) := "ZZZZZZZZ";	-- tristate

SIGNAL psr 	: std_logic_vector(7 downto 0);
SIGNAL u_chan0i,u_chan1i,u_chan2i,u_chan3i,u_chan4i,u_chan5i,u_chan6i
       : std_logic_vector(2 downto 0);
SIGNAL usb_en : std_logic;             -- USB speed bias resistor enable.
SIGNAL u_chan0o,u_chan1o,u_chan2o,u_chan3o,u_chan4o,u_chan5o,u_chan6o
       : std_logic_vector(4 downto 0);
SIGNAL u_pwr1_off,u_pwr1_sense 	: std_logic;
SIGNAL u_pwr2_off,u_pwr2_sense 	: std_logic;
SIGNAL u_pwr3_off,u_pwr3_sense 	: std_logic;
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
SIGNAL debug 	: std_logic_vector(23 downto 0);
SIGNAL a_datao 	: std_logic_vector(7 downto 0);
SIGNAL ram_ce 	: std_logic;
SIGNAL a_cs 	: std_logic;
SIGNAL op_ftch 	: std_logic;
SIGNAL ext_int 	: std_logic;
SIGNAL cpu_write  	: std_logic; 	-- processor write cycle
SIGNAL usb_write  	: std_logic; 	-- usb dma write cycle
SIGNAL read 	: std_logic;
SIGNAL bus_req 	: std_logic;
SIGNAL bus_gnt 	: std_logic;
SIGNAL ee_sda_out  : std_logic; -- EEPROM I2C bus outputs
SIGNAL ee_clk_out  : std_logic; -- EEPROM I2C bus outputs
--SIGNAL clk48pre	: std_logic; -- before the global buffer
--SIGNAL clk48i	: std_logic; -- clock 48 from oscilator internal
--SIGNAL clk48 	: std_logic; -- clock 48 clock buffer output.
SIGNAL sysclk      : std_logic; -- System clock 48MHz for HS or 6MHz for LS
SIGNAL sysclk_pre  : std_logic; -- System clock before the global buffer
SIGNAL sysclk_buf  : std_logic; -- System clock after the global buffer
SIGNAL clken_12    : std_logic; -- clocks
SIGNAL sleep, sleep_f, sleep_ff, sleep_fff, sleep_ffff : std_logic;
SIGNAL stop_osc    : std_logic;
SIGNAL clk_div     : std_logic_vector(2 downto 0); -- Clock divide
SIGNAL reset_n_f   : std_logic; -- Reset delayed one 48MHz clock
SIGNAL reset_n_ff  : std_logic; -- Reset delayed two 48MHz clocks
SIGNAL reset_pulse : std_logic; -- Reset pulse

ATTRIBUTE LOC : STRING;
--ATTRIBUTE LOC OF clkbuf1 : LABEL IS "BUFGLS_ESE";   -- Place the global clock buffer
--ATTRIBUTE LOC OF clkbuf2 : LABEL IS "BUFGLS_ESE";   -- Place the global clock buffer

SIGNAL tdoout, tdo_enb, tdiout, tdi_enb, jtag_enb, jtag_enb_n,
	tckout,tmsout	: std_logic; -- JTAG signals
SIGNAL tck_in, tck_buffered	: std_logic;
--ATTRIBUTE LOC OF tck_buf2 : LABEL IS "BUFGLS_WNW";   -- place global clock buffer

SIGNAL usb_we,cpu_we : std_logic; -- WE_N intermediate signals
SIGNAL clken_12o     : std_logic; -- clock signals
SIGNAL clken_dpllo,clken_dpll : std_logic; -- clock signals
SIGNAL clk_cpu_buf, clk_sie_buf : std_logic; -- buffered clocks for write pulse generation

attribute noopt : boolean;
attribute noopt of write_gate1 : LABEL is TRUE;
attribute noopt of write_gate2 : LABEL is TRUE;
attribute noopt of write_gate3 : LABEL is TRUE;
--attribute noopt of clkpad1 : LABEL is TRUE;
attribute noopt of clkbuf1 : LABEL is TRUE;
attribute noopt of clkbuf2 : LABEL is TRUE;
attribute noopt of clkbuf3 : LABEL is TRUE;
attribute noopt of tck_buf1 : LABEL is TRUE;
attribute noopt of tck_buf2 : LABEL is TRUE;
attribute noopt of tck_buf3 : LABEL is TRUE;
attribute LOC of write_gate1 : LABEL is "CLB_R2C48";
attribute LOC of write_gate2   : LABEL is "CLB_R2C48";
attribute LOC of write_gate3   : LABEL is "CLB_R2C48";
attribute LOC of critical_fmap : LABEL is "CLB_R2C48";

BEGIN	----------------------------------------------------------------------

avail <= "ZZZZ" & op_ftch; -- usefull debug signals
ext_int <= '0';                    -- the external interrupt does not leave the
                                   -- chip in this design, so tie it inactive.
-- Bias the upstream USB port for full or low speed.
usbb_high <= '0' WHEN lsdev = 1 AND usb_en = '1' ELSE
             '1' WHEN lsdev = 0 AND usb_en = '1' ELSE
             'Z';
usbb_low  <= '1' WHEN lsdev = 1 AND usb_en = '1' ELSE
             '0' WHEN lsdev = 0 AND usb_en = '1' ELSE
             'Z';
-- manually instantiate the input buffer and global clock buffer and place
-- them in specific sites with attributes above.
--clkpad1 : ibuf port map (I=> clk48mhz, O => clk48i);	-- from external oscillator
clkbuf1 : bufgls port map (I => sysclk_pre, O=> sysclk_buf);	-- from power save unit
clkbuf2 : bufgls port map (I => clken_12o, O=> clken_12); -- 12Mhz cpu clock
clkbuf3 : bufgls port map (I => clken_dpllo, O=> clken_dpll); -- USB 12Mhz DPLL clk

tck_buf1 : ibuf port map (I => tck, O=> tck_in);
tck_buf2 : bufgls port map (I => tck_in, O=> tck_buffered);
tck_buf3 : obuft_ng port map (I => tckout, T => jtag_enb_n, O=> tck);
jtag_enb_n <= NOT jtag_enb;

------------USB downstream "A" connectors for hub or host mode.
   -- downstream ports 1 through 3 are designed to use an external
   -- USB transceiver
u_chan1i	<= usba1_vm & usba1_vp & usba1_rcv;
usba1_vmo	<= u_chan1o(4);
usba1_vpo	<= u_chan1o(3);
usba1_speed	<= u_chan1o(2);
-- suspend is hardwired low.
usba1_oe_n	<= u_chan1o(0);


u_chan2i	<= usba2_vm & usba2_vp & usba2_rcv;
usba2_vmo	<= u_chan2o(4);
usba2_vpo	<= u_chan2o(3);
usba2_speed	<= u_chan2o(2);
-- suspend is hardwired low.
usba2_oe_n	<= u_chan2o(0);


u_chan3i	<= usba3_vm & usba3_vp & usba3_rcv;
usba3_vmo	<= u_chan3o(4);
usba3_vpo	<= u_chan3o(3);
usba3_speed	<= u_chan3o(2);
-- suspend is hardwired low.
usba3_oe_n	<= u_chan3o(0);

   -- downstream ports 4 through 6 implement the tranceiver in the Xilinx I/O
   -- cells.  The differencial receiver is not available in Xilinx, so a
   -- single ended recieve of dplus is used as the RCV differential input.
u_chan4i	<= usba4_dminus & usba4_dplus & usba4_dplus;
usba4_dminus	<= u_chan4o(4) when u_chan4o(0) = '1' else 'Z';
usba4_dplus	<= u_chan4o(3) when u_chan4o(0) = '1'  else 'Z';

u_chan5i	<= usba5_dminus & usba5_dplus & usba5_dplus;
usba5_dminus	<= u_chan5o(4) when u_chan5o(0) = '1'  else 'Z';
usba5_dplus	<= u_chan5o(3) when u_chan5o(0) = '1'  else 'Z';

u_chan6i	<= usba6_dminus & usba6_dplus & usba6_dplus;
usba6_dminus	<= u_chan6o(4) when u_chan6o(0) = '1'  else 'Z';
usba6_dplus	<= u_chan6o(3) when u_chan6o(0) = '1'  else 'Z';

-- Xilinx will insert a 50-100K ohm pullup on any unconfigured IO cell.
-- We don't want this on the DPLUS/DMINUS signals or the biasing
-- will be wrong. To eliminate the pullup, we program all of these
-- pins as inputs. We use unused outputs so the synthesizer doesn't
-- remove the input buffers.
i_sd <= usbb_dplus AND usbb_dminus and usba1_dplus and usba1_dminus;
i_txd <= usba2_dplus and usba2_dminus and usba3_dplus and usba3_dminus;

------------USB upstream "B" connector for hub or function.
u_chan0i	<= usbb_vm & usbb_vp & usbb_rcv;
usbb_vmo	<= u_chan0o(4);
usbb_vpo	<= u_chan0o(3);
usbb_speed	<= u_chan0o(2);
-- suspend is hardwired low.
usbb_oe_n	<= u_chan0o(0);

a_data	<= a_datao when a_cs='1' and cpu_write='1' else Zs;	-- tri
a_cs_n	<= not a_cs;	-- out

led 	<= clken_12 & clken_dpll & psr;

pp_data(1)    <= pp_datao(0) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(2)    <= pp_datao(1) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(3)    <= pp_datao(2) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(4)    <= pp_datao(3) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(5)    <= pp_datao(4) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(6)    <= pp_datao(5) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(7)    <= pp_datao(6) when pp_data_enb='1' else 'Z';	-- bidir
pp_data(8)    <= pp_datao(7) when pp_data_enb='1' else 'Z';	-- bidir
pp_datai      <= pp_data(8) & pp_data(7) & pp_data(6) & pp_data(5) &
                 pp_data(4) & pp_data(3) & pp_data(2) & pp_data(1);
pp_strobe_n   <= '0' when pp_strobe_out_n='0' else 'Z';	-- open drain
pp_ack_n      <= pp_ctl_out(4) when pp_ctl_enb(4)='1' else 'Z';-- tri
pp_busy       <= pp_ctl_out(3) when pp_ctl_enb(3)='1' else 'Z';-- tri
pp_error      <= pp_ctl_out(2) when pp_ctl_enb(2)='1' else 'Z';-- tri
pp_select     <= pp_ctl_out(1) when pp_ctl_enb(1)='1' else 'Z';-- tri
pp_autofd_n   <= pp_ctl_out(6) when pp_ctl_enb(6)='1' else 'Z';-- tri
pp_fault_n    <= pp_ctl_out(0) when pp_ctl_enb(0)='1' else 'Z';-- tri
pp_init_n     <= pp_ctl_out(7) when pp_ctl_enb(7)='1' else 'Z';-- tri
pp_selectin_n <= pp_ctl_out(5) when pp_ctl_enb(5)='1' else 'Z';-- tri
pp_ctl_in     <= pp_init_n & pp_autofd_n & pp_selectin_n & pp_ack_n & pp_busy & pp_error & pp_select & pp_fault_n;

ee_sda	<= '0' when ee_sda_out='0' else 'Z';-- open drain
ee_clk	<= '0' when ee_clk_out='0' else 'Z';-- open drain

-- JTAG tristate enable logic
tdo <= tdoout when tdo_enb='1' else 'Z';
--tck <= tckout when jtag_enb='1' else 'Z';
tms <= tmsout when jtag_enb='1' else 'Z';
tdi <= tdiout when tdi_enb='1' else 'Z';

-- sram interface
r_addr <= addr;
datain <= r_data(7 downto 0);
r_data(7 downto 0) <= dataout when cpu_write='1' or usb_write='1' else Zs;

r_data(15 downto 8) <= debug(7 downto 0); -- use the unused upper data as a
                                          -- debug port.
--r_data(15 downto 8) <= dataout when cpu_write='1' or usb_write='1' else Zs;
r_ce_n <= NOT ram_ce when ram_ce_enb='1' else 'Z';
r_oe_n <= NOT read;

--------------------------------------------------------------------
-- The Write Enable (R_WEL_N) signal has some very critical timing.
-- The key is that we need some hold-time from the rising edge of WE_N
-- to a change in the ADDR bus. If we just let the synthesizer and P&R
-- tools do what they want, it is unlikely that we will meet this timing
-- spec. So, to insure we have some hold time, we gate the WE_N with the
-- clock AND specify the placement of these gates to be right next to the
-- WE_N IO buffer which will minimize the delay. The FAST
-- attribute is attached to the output buffer to also increase the hold-time.
write_gate1 : or2b1 port map (
	I0 => cpu_write,
	I1 => clk_cpu_buf,
	O  => cpu_we);
write_gate2 : or2b1 port map (
	I0 => usb_write,
	I1 => clk_sie_buf,
	O  => usb_we);
write_gate3 : and2 port map (
	I0 => cpu_we,
	I1 => usb_we,
	O  => r_wel_n);
critical_fmap: fmap port map (	-- The FMAP tells the Xilinx P&R tools
	I1 => cpu_write,	-- where to place this cell.
	I2 => clk_cpu_buf,	-- See the attributes above.
	I3 => usb_write,
	I4 => clk_sie_buf,
	O => r_wel_n);

r_weh_n <= '1'; -- HIGH RAM write enable not currenly used though...

-----------------------------------------------------------------
-- See the pwr_save.vhd file for more details on the requirements
-- for going to sleep. Since we don't have an oscillator IO cell
-- in an FPGA, we implement the sleep mode and emulate the stop_osc
-- mode simply by gating the clock out to a test pin.
-- Note these these are the only 3 flops that run directly on the 
-- oscillator input without a global clock buffer 
PROCESS (sysclk,reset_n)
BEGIN    
  if (reset_n='0') then   -- ASYNC reset required!!!
    sleep_ffff <= '0';
    sleep_fff <= '0';
    sleep_ff <= '0';
    sleep_f <= '0';
  elsif (sysclk'event and sysclk='1') then
    sleep_ffff <= sleep_fff;
    sleep_fff <= sleep_ff;
    sleep_ff <= sleep_f; 
    IF clken_12o = '1'  THEN
        sleep_f <= sleep;
    END IF;
  end if; 
END PROCESS;

-- This is the gate on the clock.
sysclk_pre <= sleep_ffff OR sysclk;

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
clk_fclk1 <= NOT (sysclk OR stop_osc);

v8: asic_v8	---------------------------Create the internal logic here------
  port MAP (
    clk48        => sysclk_buf,
    clken_12o    => clken_12o,
    clken_12     => clken_12,
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
    -- video chip data signals
    video        => To_StdULogicVector(video),
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
    tck          => tck_buffered,
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

bus_req <= '0'; -- not currently used... V1394?

END struct ;
