--------------------------------------------------------------------------------
-- Copyright 1997-1999 VAutomation Inc. Nashua NH USA ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: asic_v8.vhd
-- Revision: $Name: REV9911b $
-- RCS Details:
-- $Header: /home/vauto/vusb/RCS/asic_v8.vhd,v 1.7 1999/11/23 22:47:43 gregg Exp $
-- Description:
-- 	This is the top level module for the IPS V8 MicroController.
--	This example shows how a complete single-chip microcontroller is
--	assembled from the various peripherals provided with the V8.
--	Interfaces to off-chip devices are also provided.
--
-- Address Map:
--   The V8s 16 bit address space has been expanded using a page register
--   to 23 bits (8 megabytes). The address map below is for the 16 bit
--   address space of the V8 CPU.
--   0000-01ff = BIST/BOOT ROM. CPU begins execution at 0x0000 upon reset
--   0200-02ff = Hardware Registers
--	0200-0200 = Page register
--	0202-0202 = Control register
--		CTL_REG[7] = UNUSED
--		CTL_REG[6] = UNUSED
--		CTL_REG[5] = Unused
--		CTL_REG[4] = UNUSED
--		CTL_REG[3] = Interrupt Enable. 0=disable all interrupts,1=enable
--		CTL_REG[2:0] = PSR control select
--			000 = PSR[7:4] under software control only
-- 			001 = Enable I2C bus
-- 			xxx = Other combinations are not defined.
--	0210-0213 = Audio chip
--      0220-0223 = 1284 parallel port interface
--      0230-0233 = Power Save Unit
--	0240-0242 = VUART serial communications controller
--	0250-0251 = RESERVED FOR JTAG MASTER
--	0260-0263 = VTIMER 16 bit counter timer
--	0270-0273 = VIDEO data
--	0280-02bf = VUSB - optional
--	02c0-02ff = VUSB_HUB - optional
--   0300-03ff = STACK
--   0400-040f = Interrupt vectors
--   0410-7fff = RAM
--   8000-ffff = Off-chip RAM window selected by the PAGE register
--	A15 enables the extended addressing PAGE register. The upper 32K bytes
--	of the V8s address space provides a "window" into the 8 Megabyte
--	address range. T
--
-- Block Diagram:
--
--         +-------------+                     +-----------------+
--         | V8_TOP      |                     |VUART            >--U_TX
--         |             >-ADDR-#----+--------->                 <--U_RX
--         |8-bit RISC  <>-DATA-#-----+--------<>                |
--         |CPU with     |      |    ||        +-----------------+
--         |16x8 register|      |    ||
--         |file         |      |    ||        +-----------------+
--         |             |      |    ||        |V1284            |
--         +-------------+      |    +--------->                 <-1284 Parallel
--                              |    |+--------<>                | Port
--         +-------------+      |    ||        +-----------------+
--         |V8_DEICE     |      |    ||
--  IEEE   |             <>-----+    ||        +-----------------+
--  1149.1->JTAG debugger|           ||        |VTIMER           |
--  4 wires|             |           +--------->                 >-PWM
--         +-------------+           |+--------<>                |
--                                   ||        +-----------------+
--                                   ||
--                                   ||        +-----------------+
--                                   ||        |PWR_SAVE         |
--                                   +--------->                 |
--                                   |+--------<>                |
--                                   ||        +-----------------+
--                                   ||
--                                   ||        +-----------------+
--                                   ||        |BISTROM          |
--                                   +--------->                 |
--                                   |+--------<                 |
--                                   ||        +-----------------+
--                                   ||
--                                   ||        +-----------------+
--                                   ||        |VUSB - optional  |
--                                   +--------->                 <-USB ROOT
--                                   |+--------<>                |
--                                   ||        +-----------------+
--                                   ||
--                                   ||        +-----------------+
--                                   ||        |VUSB_HUB         |
--                                   +--------->   optional      <-USB ports
--                                   |+--------<>                |
--                                   ||        +-----------------+
--                                   ||
--                                   +------------>External memory interface
--                                   |+----------->
--                                   VV
--                         Other logic at this level includes:
--                         Page Register, Control Register,
--                         I2C interface via the upper 4 PSR bits,
--                         Address decode and Wait state generator.
--    
--
-- Signals ending in _n are active low.

--------------Revision History--------------------------------------------------
-- $Log: asic_v8.vhd,v $
-- Revision 1.7  1999/11/23 22:47:43  gregg
-- Fixed u_chan1 connections for host mode
--
-- Revision 1.6  1999/11/10 20:12:20  mark
-- deleted the commented out VUSB_HUB code
--
-- Revision 1.5  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.4  1999/11/09 14:21:40  mark
-- ulogicified source - was a mixture in previous revision
-- * stripped out vusb_hub from asic_v8
--
-- Revision 1.3  1999/09/30 20:51:19  scott
-- Made a version that is has both std_ulogic & std_ulogic
-- and passes MTI and Exemplar.
--
-- Revision 1.2  1999/09/30 18:04:33  scott
-- First version to compile with mixed std_ulogic and
-- std_ulogic types.
--
-- Revision 1.1  1999/09/30 18:01:38  scott
-- Initial revision
--
-- Revision 1.1  1999/09/30 14:34:26  scott
-- Initial revision
--
-- Revision 1.44.1.1  1999/09/27 16:12:56  gregg
-- Moved zero initialization to code for verilog conversion
--
--------------------------------------------------------------------------------
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.
use ieee.numeric_std.all;
-- USE ieee.std_logic_arith.all;	-- + and - operators

ENTITY asic_v8 IS	-----------------------------ENTITY---------------------
  port( clk48       : IN  std_ulogic;    -- 48 MHz oscillator buffered (primary clock)
        clken_12o   : OUT std_ulogic;    -- DPLL clock / 4 (12MHz) unbuffered
        clken_12    : IN  std_ulogic;  	-- 12MHz (48/4) clock enable buffered
        clken_dpllo : OUT std_ulogic;    -- DPLL output clock unbufffered
        clken_dpll  : IN  std_ulogic;  	-- DPLL output clock enable buffered
        clk_sieo    : OUT std_ulogic;    -- SIE clock for write pulse generation.
        clk_cpuo    : OUT std_ulogic;    -- CPU clock for write pulse generation.
        sleep       : OUT std_ulogic;    -- Stop the clock
        stop_osc    : OUT std_ulogic;    -- Stop the oscillator
        rst_raw_n:in std_ulogic;   	-- unregistered reset.
       	addr	: out std_ulogic_vector(16 downto 0); -- external address bus
       	datain	: in  std_ulogic_vector(7 downto 0); -- external data bus in
       	dataout	: out std_ulogic_vector(7 downto 0); -- external data bus out
       	read	: out std_ulogic; 	-- read cycle
       	cpu_write  	: out std_ulogic; 	-- processor write cycle
       	usb_write  	: out std_ulogic; 	-- usb dma write cycle
       	ready  	: in  std_ulogic; 	-- 0=insert wait states,1=run
	-- Misc. off-chip interface signals
       	ram_ce	: out std_ulogic; 	-- external sram chip enable
       	ram_ce_enb: out std_ulogic; 	-- SRAM CE tristate enable
	page2_ce: out std_ulogic;        -- IO register space
	ext_int	: in std_ulogic;		-- External Interrupt
	bus_req : in  std_ulogic;        -- external bus request
	bus_gnt : out std_ulogic;        -- external bus grant
	pwm : out std_ulogic;    -- timer Pulse Width Modulated output
	-- audio chip control signals
       	a_addr	: out std_ulogic_vector(1 downto 0); 	-- address bus
       	a_ce	: out std_ulogic; 	-- chip enable
        a_datai	: in	std_ulogic_vector( 7 downto 0); -- data bus
        a_datao	: out	std_ulogic_vector( 7 downto 0); -- data bus
        a_oe_n	: out	std_ulogic;	-- active low output enable
	a_we_n	: out	std_ulogic;	-- active low write enable
	-- video chip control signals
       	video	: in std_ulogic_vector(8 downto 0); 	-- video data
	-- Universal Serial Bus (USB) control signals
	u_chan0i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan0o: out std_ulogic_vector(4 downto 0); -- USB interface
        usb_en  : out std_ulogic;                    -- USB pull up enable
        u_chan1i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan1o: out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan2i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan2o: out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan3i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan3o: out std_ulogic_vector(4 downto 0); -- USB interface
	u_chan4i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan4o: out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan5i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan5o: out std_ulogic_vector(4 downto 0); -- USB interface
        u_chan6i: in  std_ulogic_vector(2 downto 0); -- USB interface
        u_chan6o: out std_ulogic_vector(4 downto 0); -- USB interface
        u_pwr1_off: out std_ulogic; -- USB interface
        u_pwr2_off: out std_ulogic; -- USB interface
        u_pwr3_off: out std_ulogic; -- USB interface
        u_pwr1_sense: in std_ulogic; -- USB interface
        u_pwr2_sense: in std_ulogic; -- USB interface
        u_pwr3_sense: in std_ulogic; -- USB interface
        -- USB Port Power Control Signals
        usba1_pwron : OUT std_ulogic; -- Downstream port 1 Power Enable
        usba2_pwron : OUT std_ulogic; -- Downstream port 2 Power Enable
        usba3_pwron : OUT std_ulogic; -- Downstream port 3 Power Enable
        usba4_pwron : OUT std_ulogic; -- Downstream port 4 Power Enable
        usba5_pwron : OUT std_ulogic; -- Downstream port 5 Power Enable
        usba6_pwron : OUT std_ulogic; -- Downstream port 6 Power Enable
	-- RS232 UART interface
       	u_rx	: in std_ulogic;		-- serial data in
       	u_tx	: out std_ulogic;	-- serial data out
	-- IEEE 1284 PC Parallel Port interface
	pp_strobe_n  : out  std_ulogic;
	pp_datai     : in   std_ulogic_vector(8 downto 1);
	pp_datao     : out  std_ulogic_vector(8 downto 1);
	pp_data_enb  : out  std_ulogic;
	pp_ctl_in    : in   std_ulogic_vector(7 downto 0);
	pp_ctl_out   : out  std_ulogic_vector(7 downto 0);
	pp_ctl_enb   : out  std_ulogic_vector(7 downto 0);
	-- eeprom control signals - I2C bus
       	e_sda_in	: in  std_ulogic;
       	e_sda_out	: out std_ulogic;
       	e_clk_in	: in  std_ulogic;
       	e_clk_out	: out std_ulogic;
	-- JTAG signals
       	tck	: in  std_ulogic;
       	tms	: in  std_ulogic;
       	tdiin	: in  std_ulogic;
       	tdiout	: out std_ulogic;
       	tdi_enb	: out std_ulogic;
       	tdoin	: in  std_ulogic;
       	tdoout	: out std_ulogic;
       	tdo_enb	: out std_ulogic;	-- tristate enable
       	jtag_enb: out std_ulogic;	-- JTAG control tristate enable
       	tckout	: out std_ulogic;	-- tck output
       	tmsout	: out std_ulogic;	-- tms output
	-- USB clocking signals - not used in V8 only applications
	com_clk_b: out std_ulogic; 	-- USB DPLL out
        uwrt_clk: out std_ulogic;        -- clock used to generate the write pulse
	-- debug signals
       	psr	: out std_ulogic_vector(7 downto 0); -- flags
       	op_ftch	: out std_ulogic; 	-- indicates an opcode fetch
       	debug	: out std_ulogic_vector(23 downto 0));-- debugging signals

END asic_v8;

ARCHITECTURE rtl of asic_v8 is ----------------Architecture rtl-----------

COMPONENT clk_ctl 	-----------------------------ENTITY---------------------
  PORT(
        clk48i      : IN  std_ulogic;    -- DPLL 48 MHz osilator
        clken_12i   : IN  std_ulogic;  	-- 12MHz (48/4) clock enable
        clken_dplli : IN  std_ulogic;  	-- DPLL output clock enable
        rst_raw_n   : IN  std_ulogic;    -- unregistered reset input
        clk_cpuo    : OUT std_ulogic;    -- uProcessor clock
        rst_cpuo    : OUT std_ulogic;    -- uProcessor reset
        clk_sieo    : OUT std_ulogic;    -- USB SIE clock
	clken_sieo  : OUT std_ulogic;    -- USB SIE clock enable
        rst_sieo    : OUT std_ulogic;    -- USB SIE synchronous reset
        clk_hubo    : OUT std_ulogic;    -- USB_HUB clock
	clken_hubo  : OUT std_ulogic;    -- USB SIE clock enable
        rst_hubo    : OUT std_ulogic     -- USB HUB synchronous reset
       );
END COMPONENT;

COMPONENT v8_top
  port(clk	: in  std_ulogic;	-- everything clocks on rising edge
       rst	: in  std_ulogic;	-- reset active high
       datain	: in  std_ulogic_vector(7 downto 0); -- data bus in
       int	: in  std_ulogic_vector(7 downto 0);-- interrupt requests (level sensitive)
       set_p	: in  std_ulogic_vector(7 downto 4);-- set PSR flag bits
       clr_p	: in  std_ulogic_vector(7 downto 4);-- clr PSR flag bits
       ready  	: in  std_ulogic; 	-- 0=insert wait states,1=run
       dataout	: out std_ulogic_vector(7 downto 0); -- data bus out
       addr	: out std_ulogic_vector(15 downto 0); -- address bus out
       op_ftch 	: out std_ulogic; 	-- indicates an opcode fetch
       read  	: out std_ulogic; 	-- read cycle
       write  	: out std_ulogic; 	-- write cycle
       -- debugging signals
       psr	: out std_ulogic_vector(7 downto 0); -- PSR flags
       pc	: out std_ulogic_vector(15 downto 0); -- Program counter
       write_nxt : out std_ulogic;
       opcde	: out std_ulogic_vector(7 downto 0); -- current opcode
       cycle    : out std_ulogic_vector(8 downto 1)); -- current state vector
END COMPONENT;

COMPONENT bistrom
  PORT (addr   :  IN  std_ulogic_vector(8 downto 0); -- Address
        rom_enb:  IN  std_ulogic; -- tristate enable
        rom_out:  OUT std_ulogic_vector(7 downto 0)); -- data
END COMPONENT;

COMPONENT vuart
  PORT (
        clk         : IN  std_ulogic;                     -- clock input
        rst         : IN  std_ulogic;                     -- reset
        addr        : IN  std_ulogic_vector( 1 DOWNTO 0); -- address
        datain      : IN  std_ulogic_vector(7 DOWNTO 0);  -- DATA bus in
        dataout     : OUT std_ulogic_vector(7 DOWNTO 0);  -- DATA bus out
        read        : IN  std_ulogic;                     -- uP read
        write       : IN  std_ulogic;                     -- uP write
        chip_sel    : IN  std_ulogic;                     -- Chip select
        irq         : OUT std_ulogic;                     -- interrupt
        -- serial connections
        baud        : OUT std_ulogic;                     -- baud clock
        rx_data     : IN  std_ulogic;                     -- Rx data
        tx_data     : OUT std_ulogic                      -- Tx data
        );
END COMPONENT;

COMPONENT vtimer
  PORT (clk	: IN  std_ulogic; -- clock input
        rst	: IN  std_ulogic; -- reset
        addr	: IN  std_ulogic_vector(2 downto 0);  -- address
        datain	: IN  std_ulogic_vector(7 DOWNTO 0);  -- Data input
        dataout	: OUT std_ulogic_vector(7 DOWNTO 0);  -- Data output
        ext_enb	: IN  std_ulogic;  -- external count enable
        interrupt: OUT std_ulogic;  -- interrupt pending
        pwm	: OUT std_ulogic;  -- PWM bit of the CTL register
        sel	: IN  std_ulogic;  -- enable writes
        write	: IN  std_ulogic); -- write register when 1
END COMPONENT;


COMPONENT v8_deice
  port(clk	: in  std_ulogic;	-- Processor clock and much of the JTAG logic clock
       reset_x	: in  std_ulogic;	-- reset active high
       reset_8	: out  std_ulogic;	-- reset active high
       addr_8   : in std_ulogic_vector(15 downto 0); -- address bus out
       addr_x   : out std_ulogic_vector(15 downto 0); -- address bus out
       clr_p_x	: in  std_ulogic_vector(7 downto 4);-- clear PSR flag bits
       clr_p_8	: out  std_ulogic_vector(7 downto 4);-- clear PSR flag bits
       datain_x	: in  std_ulogic_vector(7 downto 0); -- data bus in
       datain_8	: out  std_ulogic_vector(7 downto 0); -- data bus in
       dataout_8	: in std_ulogic_vector(7 downto 0); -- data bus out
       dataout_x	: out std_ulogic_vector(7 downto 0); -- data bus out
       int_x	    : in  std_ulogic_vector(7 downto 0);-- interrupt requests (level sensitive)
       int_8	    : out  std_ulogic_vector(7 downto 0);-- interrupt requests (level sensitive)
       op_ftch_8 	: in std_ulogic; 	-- indicates an opcode fetch
       op_ftch_x 	: out std_ulogic; 	-- indicates an opcode fetch
       read_8  	: in std_ulogic; 	-- 1=read cycle in progress
       read_x  	: out std_ulogic; 	-- 1=read cycle in progress
       ready_x  	: in  std_ulogic; 	-- 0=insert wait states,1=run
       ready_8  	: out  std_ulogic; 	-- 0=insert wait states,1=run
       set_p_x	: in  std_ulogic_vector(7 downto 4);-- set PSR flag bits
       set_p_8	: out  std_ulogic_vector(7 downto 4);-- set PSR flag bits
       write_d_8  	: in std_ulogic; 	-- 1=write cycle next clock
       write_8  	: in std_ulogic; 	-- 1=write cycle in progress
       write_x  	: out std_ulogic; 	-- 1=write cycle in progress
       spare1_i         : in std_ulogic;         -- extra external signals
       spare1_o         : out std_ulogic;        -- extra external signals
       spare2_i         : in std_ulogic;         -- extra external signals
       spare2_o         : out std_ulogic;        -- extra external signals
       spare3_i         : in std_ulogic;         -- extra external signals
       spare3_o         : out std_ulogic;        -- extra external signals
       -- JTAG signals
       TRST_N : in std_ulogic; -- JTAG async reset
       TCK    : in std_ulogic; -- JTAG clock, must be > 1/2 FREQ of CLK
       TMS	  : in std_ulogic; -- JTAG mode
       TDI	  : in std_ulogic; -- JTAG datain
       TDO	  : out std_ulogic; -- JTAG dataout
       TDO_ENB: out std_ulogic);-- JTAG dataout tristate enable
END COMPONENT;

COMPONENT v1284
  port(	clk	: in  std_ulogic;	-- everything clocks on rising edge
       	rst	: in  std_ulogic;	-- reset
       	addr	: in  std_ulogic_vector(2 downto 0); -- address bus
       	datain	: in  std_ulogic_vector(7 downto 0); -- data bus
       	dataout	: out std_ulogic_vector(7 downto 0); -- data bus
       	write	: in  std_ulogic; 	-- write enable
       	read  	: in  std_ulogic; 	-- read enable
       	chip_sel: in  std_ulogic; 	-- device Select
	-- IEEE 1284 PC Parallel Port interface
	pp_strobe_n  : out std_ulogic;
	pp_datain    : in  std_ulogic_vector(8 downto 1);
	pp_dataout   : out std_ulogic_vector(8 downto 1);
	pp_data_enb  : out std_ulogic;
	pp_ctl_in    : in  std_ulogic_vector(7 downto 0);
	pp_ctl_out   : out std_ulogic_vector(7 downto 0);
	pp_ctl_enb   : out std_ulogic_vector(7 downto 0));
END COMPONENT;

COMPONENT pwr_save
  PORT (
        clk         : IN  std_ulogic;                     -- uP clock
        reset       : IN  std_ulogic;                     -- reset
        addr        : IN  std_ulogic_vector( 1 DOWNTO 0); -- address
        chip_sel    : IN  std_ulogic;                     -- Chip select
        datain      : IN  std_ulogic_vector(7 DOWNTO 0);  -- DATA bus in
        dataout     : OUT std_ulogic_vector(7 DOWNTO 0);  -- DATA bus out
        write       : IN  std_ulogic;                     -- uP write
        quiet       : IN  std_ulogic_vector(7 downto 0);  -- Change on these restarts clock
        rest        : OUT std_ulogic;                     -- stop the uP
        sleep       : OUT std_ulogic;                     -- stop the clock
        glo_tri     : OUT std_ulogic;                     -- Global Tristate enable
        stop_osc    : OUT std_ulogic);                    -- stop the oscillator
END COMPONENT;

COMPONENT vusb_top
  port(
        clk48i      : IN  std_ulogic;     -- DPLL input clock
        rst_raw_n   : IN  std_ulogic;     -- unregistered reset input
        clken_dpllo : OUT std_ulogic;     -- DPLL output clock
        clken_12o   : OUT std_ulogic;     -- DPLL clock / 4 (12MHz)
        clk_sie     : IN  std_ulogic;     -- SIE primary clock input
        clken_sie   : IN  std_ulogic;     -- SIE clock enable
	rst_sie     : IN  std_ulogic;     -- sync sie reset active high
        clk_cpu     : IN  std_ulogic;     -- uProcessor clock input
        rst_cpu     : IN  std_ulogic;     -- uProcessor reset input
        clken_12    : IN  std_ulogic;     -- SOF timer clock enable
        addri   : in  std_ulogic_vector(15 downto 0); -- Address Bus
        addro   : out std_ulogic_vector(15 downto 0); -- Address Bus
	readi   : in  std_ulogic;        -- read enable in
	reado   : out std_ulogic;        -- read enable out
	writei  : in  std_ulogic;        -- write enable in
	writeo  : out std_ulogic;        -- write enable out
        bmoe    : out std_ulogic;        -- Bus Master Signals Output Enable
	readyi  : in  std_ulogic;        -- 0=insert wait states,1=run
	readyo  : out std_ulogic;        -- ready out
        bsoe    : out std_ulogic;        -- Bus Slave Signals Output Enable
        datai   : in  std_ulogic_vector(7 downto 0); -- Data Bus In
        datao   : out std_ulogic_vector(7 downto 0); -- Data Bus Out
        doe     : out std_ulogic;        -- Data Bus Output Enable
	cei     : in  std_ulogic;	-- VUSB page chip enable
	int     : out std_ulogic;        -- sie interrupts
	bus_req : out std_ulogic;        -- sie bus request
	bus_gnt : in  std_ulogic;        -- sie bug grant
        --  Hub interface
        hc_eno        : OUT std_ulogic;  -- Host controller enable for empty arch
        pre_pid_det   : OUT std_ulogic;  -- Low Speed Preamble PID detected.
        valid_sof_pid : OUT std_ulogic;  -- Valid SOF PID detected
        lseop_det     : OUT std_ulogic;  -- Low Speed EOP detected
        fseop_det     : OUT std_ulogic;  -- Full Speed EOP detected
        eop_48_out    : OUT std_ulogic;  -- Eop detect sig from 48Mhz domain
        -- USB transceiver interfaces
	u_chan1i: in  std_ulogic_vector(2 downto 0); -- USB host interface
	u_chan1o: out std_ulogic_vector(4 downto 0); -- USB host interface
	u_chan0i: in  std_ulogic_vector(2 downto 0); -- USB interface
	u_chan0o: out std_ulogic_vector(4 downto 0); -- USB interface
        usb_en  : out std_ulogic;                    -- USB pull up enable
	debug   : out std_ulogic_vector(15 downto 0) -- debug bus
       );
end COMPONENT;

SIGNAL clk_cpu    : std_ulogic;    -- uProcessor clock
SIGNAL rst_cpu    : std_ulogic;    -- uProcessor reset
SIGNAL clk_sie    : std_ulogic;    -- USB SIE clock enable
SIGNAL clken_sie  : std_ulogic;    -- USB SIE clock enable
SIGNAL rst_sie    : std_ulogic;    -- USB SIE synchronous reset
SIGNAL clken_hub  : std_ulogic;    -- USB SIE clock enable

SIGNAL a_cel	: std_ulogic; -- local version
SIGNAL addr_cpu	: std_ulogic_vector(15 downto 0);	-- addr from the cpu
SIGNAL addr_outl: std_ulogic_vector(15 downto 0);	-- local addr out
SIGNAL addr_page	: std_ulogic_vector(7 downto 0);	-- page register
SIGNAL addr_full	: std_ulogic_vector(22 downto 0);-- full 8 Meg addr
SIGNAL atomic_access	: std_ulogic; -- a bus access that should not be suspended.
SIGNAL bus_req_f	: std_ulogic; -- flopped version
SIGNAL bus_gntl	: std_ulogic; -- local version
SIGNAL bus_gnt_d	: std_ulogic; -- grant register input
SIGNAL usb_bus_gnt_d	: std_ulogic; -- usb grant register input
SIGNAL ctl_reg	: std_ulogic_vector(7 downto 0);	-- control register
SIGNAL data_cpu	: std_ulogic_vector(7 downto 0);	-- From the V8
SIGNAL data_inl	: std_ulogic_vector(7 downto 0);	-- local data in
SIGNAL data_rom	: std_ulogic_vector(7 downto 0);	-- ROM data
SIGNAL hardware_ce	: std_ulogic; -- Hardware IO registers
SIGNAL interrupt: std_ulogic;	-- int ORed together
SIGNAL int	: std_ulogic_vector(7 downto 0);	-- interrupts
SIGNAL set_p	: std_ulogic_vector(7 downto 4);	-- flag bits
SIGNAL clr_p	: std_ulogic_vector(7 downto 4);	-- flag bits
SIGNAL pc	: std_ulogic_vector(15 downto 0);	-- program counter
SIGNAL pp_ce	: std_ulogic;	-- 1284 chip enable
SIGNAL pp_dataout	: std_ulogic_vector(7 downto 0);	-- 1284 data out
SIGNAL page2data	: std_ulogic_vector(7 downto 0);	-- data from 0x02XX
SIGNAL page2_cel	: std_ulogic;	-- local version
SIGNAL page2_int	: std_ulogic;	-- internal peripheral chip enable
SIGNAL page_ctl_data	: std_ulogic_vector(7 downto 0);	-- page and ctl reg readback data
SIGNAL psrl	: std_ulogic_vector(7 downto 0);	-- local version
SIGNAL read_cpu	: std_ulogic;	-- cpu output version
SIGNAL readl	: std_ulogic;	-- local version
SIGNAL ready_cpu: std_ulogic;	-- local ready to cpu
SIGNAL readyl	: std_ulogic;	-- local version
SIGNAL rst_cpu_n	: std_ulogic;	-- active low version
SIGNAL rom_ce	: std_ulogic; -- ROM chip enable
SIGNAL write_cpu	: std_ulogic;	-- active high write from cpu
SIGNAL writel	: std_ulogic;	-- active high write signal
SIGNAL wait_state,wait_state1,wait_state2,wait_state3	: std_ulogic;	-- wait states
SIGNAL timer_data	: std_ulogic_vector(7 downto 0); -- Timer readback data
SIGNAL timer_ctr_ld,timer_reg_ld,timer_snap_ld	: std_ulogic; -- Timer control
SIGNAL timer_int	: std_ulogic; -- Timer control
SIGNAL timer_sel	: std_ulogic; -- Timer address decode

SIGNAL opcde	: std_ulogic_vector(7 downto 0); -- debugging only...
SIGNAL cycle	: std_ulogic_vector(8 downto 1); -- debugging only...

SIGNAL uart_data : std_ulogic_vector(7 downto 0);
SIGNAL uart_cs : std_ulogic;
SIGNAL uart_irq : std_ulogic;

SIGNAL usb_addro	: std_ulogic_vector(15 downto 0); -- USB address bus out
SIGNAL usb_datao	: std_ulogic_vector(7 downto 0); -- USB data bus out
SIGNAL usb_int 		: std_ulogic;	-- USB interrupt
SIGNAL usb_reado	: std_ulogic;	-- USB read out
SIGNAL usb_writeo	: std_ulogic;	-- USB write out
SIGNAL usb_bmoe		: std_ulogic;	-- USB bus tristate enable
SIGNAL usb_bsoe		: std_ulogic;	-- USB bus tristate enable
SIGNAL usb_doe		: std_ulogic;	-- USB data bus tristate enable
SIGNAL usb_bus_req	: std_ulogic;	-- USB bus request
SIGNAL usb_bus_gnt	: std_ulogic;	-- USB bus grant
SIGNAL usb_readyo	: std_ulogic;	-- USB ready out
SIGNAL usb_chip_sel	: std_ulogic;	-- USB chip Select
SIGNAL hc_en            : std_ulogic;    -- USB host controller enable

-- internal usb interfaces for connecting hub to SIE.
SIGNAL u_chan_host_i    : std_ulogic_vector(2 downto 0);
SIGNAL u_chan_host_o    : std_ulogic_vector(4 downto 0);
SIGNAL zero             : std_ulogic_vector(15 downto 0);

SIGNAL pwr_dataout : std_ulogic_vector(7 downto 0); -- power save unit
SIGNAL quiet : std_ulogic_vector(7 downto 0); -- power save unit
SIGNAL rest : std_ulogic; -- power save unit
SIGNAL prebuf_usb_clk : std_ulogic; -- power save unit
SIGNAL global_tristate : std_ulogic; -- power save unit
SIGNAL pwr_chip_sel : std_ulogic; -- power save unit
SIGNAL video_sel : std_ulogic; -- select the video data

SIGNAL tms_slave	: std_ulogic; -- JTAG TMS signal to the V8_DEICE core

-- The following signals are the connections between the V8 CPU and it's
-- surrounding JTAG debugging module.
SIGNAL reset_8	: std_ulogic;	--
SIGNAL addr_8	: std_ulogic_vector(15 downto 0);	--
SIGNAL clr_p_8	: std_ulogic_vector(3 downto 0);	--
SIGNAL datain_8	: std_ulogic_vector(7 downto 0);	--
SIGNAL dataout_8	: std_ulogic_vector(7 downto 0);	--
SIGNAL int_8	: std_ulogic_vector(7 downto 0);	--
SIGNAL op_ftch_8	: std_ulogic;	--
SIGNAL read_8	: std_ulogic;	--
SIGNAL ready_8	: std_ulogic;	--
SIGNAL set_p_8	: std_ulogic_vector(3 downto 0);	--
SIGNAL write_8,write_d_8	: std_ulogic;	--
SIGNAL trst_n	: std_ulogic;	--

SIGNAL eop_48_out : std_ulogic;

-- See the memory map at the top of the file.
CONSTANT ROM_BASE_ADDR : std_ulogic_vector(15 downto 9) := "0000000";-- ROM base address
CONSTANT HW_BASE_ADDR  : std_ulogic_vector(15 downto 8) := "00000010";-- Hardware registers base address
-- The following constants are the addresses within the hardware page
CONSTANT PAGE_REG_ADDR  : std_ulogic_vector(7 downto 0):= "00000000";-- page register address
CONSTANT CTL_REG_ADDR   : std_ulogic_vector(7 downto 0):= "00000010";-- CTL register address
CONSTANT AUDIO_BASE_ADDR: std_ulogic_vector(7 downto 2):= "000100";-- Audio chip 10-13
CONSTANT PP_BASE_ADDR   : std_ulogic_vector(7 downto 3):= "00100"; -- 1284 port 20-27
CONSTANT PWR_SAV_ADDR   : std_ulogic_vector(7 downto 2):= "001100";-- Power Save 30-33
CONSTANT UART_BASE_ADDR : std_ulogic_vector(7 downto 2):= "010000";-- UART chip 40-43
CONSTANT JTAG_BASE_ADDR : std_ulogic_vector(7 downto 2):= "010100";-- JTAG 50-53
CONSTANT TIME_BASE_ADDR : std_ulogic_vector(7 downto 3):= "01100";-- timer 60-67
CONSTANT USB_BASE_ADDR  : std_ulogic_vector(7 downto 5):= "100"; -- SIE at 80-9f
CONSTANT V1394_BASE_ADDR: std_ulogic_vector(7 downto 6):= "11"; -- Fire Wire at C0-FF
BEGIN	----------------------------------------------------------------------

-- Assign zero here for conversion
zero <= (others => '0');

clk_cpuo <= clk_cpu;-- send CPU and SIE buffered clocks up to the top level
clk_sieo <= clk_sie;-- to support write pulse generation.

rst_cpu_n <= NOT rst_cpu;	-- needed for JTAG

-- We mux in various control signals into the PSR depending on the CONTROL reg.
set_p <= to_x01(e_sda_in) & '0' & to_x01(e_clk_in) & '0' WHEN
	(ctl_reg(2 downto 0)="001") ELSE -- I2C
	"0000"; -- software use only
clr_p <= NOT to_x01(e_sda_in) & '0' & NOT to_x01(e_clk_in) & '0'
	WHEN (ctl_reg(2 downto 0)="001") ELSE -- I2C
	"0000"; -- software use only

-----------------EEPROM control Logic---------------
e_sda_out <= '1' when (ctl_reg(2 downto 0)/="001") -- tristate when I2C is disabled
	OR psrl(6)='1' 	-- or we want the bit to be a 1
	ELSE '0';	-- else drive it low.

e_clk_out  <= '1' when (ctl_reg(2 downto 0)/="001") -- tristate when I2C is disabled
	OR psrl(4)='1' 	-- or we want the bit to be a 1
	ELSE '0';	-- else drive it low.

---------------Address space decoding logic-------------------------
-- The BIST/BOOT ROM is located at the zero page.
rom_ce <= '1' WHEN (addr_outl(15 downto 9) = ROM_BASE_ADDR)
	ELSE '0';

-- SRAM is enabled throughout the entire low half of the 8 meg space
-- except for the hardware and ROM pages.
ram_ce <= '1' WHEN (addr_outl(15)='0' AND hardware_ce='0' AND rom_ce='0')
	OR (addr_outl(15)='1' AND addr_full(22)='0')
	ELSE '0';
ram_ce_enb <= not bus_gntl;

-- the hardware IO registers are located in the 02 page of memory
hardware_ce <= '1' WHEN (addr_outl(15 downto 8) = HW_BASE_ADDR AND bus_gntl='0')
	ELSE '0';

-- The Audio chip is in the second 8 bytes of the hardware page
a_cel <= '1' WHEN (hardware_ce='1' AND addr_outl(7 downto 2)=AUDIO_BASE_ADDR)
	ELSE '0';
a_ce <= a_cel;

a_addr <= addr_outl(1 downto 0);	-- flop or buffer this?
a_datao <= data_cpu;	-- flop or buffer this?

--------------------------------------------------------------------
ready_cpu <= readyl AND
            NOT (bus_gntl OR bus_gnt_d) AND   -- stop the V8 when someone else is using the bus
            NOT (usb_bus_gnt OR usb_bus_gnt_d);  -- stop the V8 when the VUSB owns the bus

readyl <= rst_cpu or 	-- force ready=1 during reset to insure that all flops are inited.
	 ((NOT wait_state) AND	-- strech out cycles to the hardware registers
          -- external ready for FireWire only
--	 (NOT (NOT ready AND hardware_ce AND addr_outl(7) AND addr_outl(6))) AND
	 (NOT rest));	-- stop when power save says to

uclk_ctl : clk_ctl
  PORT map(
        clk48i                => clk48,     -- DPLL 48 MHz osilator
        clken_12i             => clken_12,  -- 12MHz (48/4) clock enable
        clken_dplli           => clken_dpll,-- DPLL output clock enable
        rst_raw_n             => rst_raw_n, -- unregistered reset input
        clk_cpuo              => clk_cpu,   -- uProcessor clock
        rst_cpuo              => rst_cpu,   -- uProcessor reset
        clk_sieo              => clk_sie,   -- USB SIE clock
	clken_sieo            => clken_sie, -- USB SIE clock enable
        rst_sieo              => rst_sie,   -- USB SIE synchronous reset
        clk_hubo              => OPEN,      -- USB_HUB clock
        clken_hubo            => clken_hub, -- USB SIE clock enable        
        rst_hubo              => OPEN);

cpu: v8_top		-- Create the V8 CPU here
  port map (
       clk	=> clk_cpu,  -- buffered uProc clock to clock all registers
       rst	=> reset_8,
       addr	=> addr_8,
       clr_p	=> clr_p_8,
       datain	=> datain_8,
       dataout	=> dataout_8,
       int	=> int_8,
       op_ftch 	=> op_ftch_8,
       read 	=> read_8,
       ready  	=> ready_8,
       set_p	=> set_p_8,
       write  	=> write_8,
       psr	=> psrl,
       pc	=> pc,
       write_nxt => write_d_8,
       opcde	=> opcde,
       cycle	=> cycle);

-----------------------------------JTAG Debugger/In-Circuit Emulator------
-- The V8_DEICE wraps completely around the V8 except for the extra debugging IOs.
deice: v8_deice
  port map (clk	=> clk_cpu,
       reset_x	=> rst_cpu,
       reset_8	=> reset_8,
       addr_8   => addr_8,
       addr_x => addr_cpu,
       clr_p_x	=> clr_p,
       clr_p_8	=> clr_p_8,
       datain_x	=> data_inl,
       datain_8	=> datain_8,
       dataout_8	=> dataout_8,
       dataout_x	=> data_cpu,
       int_x	    => int,
       int_8	    => int_8,
       op_ftch_8 	=> op_ftch_8,
       op_ftch_x 	=> op_ftch,
       read_8  	=> read_8,
       read_x  	=> read_cpu,
       ready_x  	=> ready_cpu,
       ready_8  	=> ready_8,
       set_p_x	=> set_p,
       set_p_8	=> set_p_8,
       write_d_8  	=> write_d_8,
       write_8  	=> write_8,
       write_x  	=> write_cpu,
       spare1_i		=> bus_req,	-- allow more observation points
       spare2_i		=> usb_bus_req,
       spare3_i		=> bus_gntl,
       spare1_o		=> open,
       spare2_o		=> open,
       spare3_o		=> open,
       -- JTAG signals
       TRST_N => rst_cpu_n,
       TCK    => tck,
       TMS	  => tms_slave,
       TDI	  => tdiin,
       TDO	  => tdoout,
       TDO_ENB=> tdo_enb);
tms_slave <= tms OR 
	'0'; -- not used
read <= readl;	-- drive the port
psr <= psrl;	-- drive the local version out the port

-- the bus contol signals come from the procssor unless VUSB owns the bus.
addr_outl <= addr_cpu  when (usb_bmoe='0') else usb_addro;
dataout   <= data_cpu  when (usb_doe='0')  else usb_datao;
writel    <= write_cpu when (usb_bmoe='0') else usb_writeo;
readl     <= read_cpu  when (usb_bmoe='0') else usb_reado;
cpu_write <= write_cpu  when (usb_bus_gnt='0') else '0';
usb_write <= usb_writeo when (usb_bmoe='1') else '0';

addr_full <= addr_page & addr_outl(14 downto 0); -- add in the page register
-- addr(15) from the CPU is used to select when the page register is to be used.
-- Thus, the upper 32K is a window into the larger address space defined by the
-- page register.
addr <= addr_full(16 downto 0) when (addr_outl(15)='1') ELSE
	"00" & addr_full(14 downto 0);

page_reg:PROCESS	-- create the 8 bit page register here
BEGIN
  WAIT UNTIL clk_cpu'event AND clk_cpu='1';
  IF (rst_cpu='1') THEN addr_page <= "00000001";
  ELSIF (addr_outl(7 downto 0)=PAGE_REG_ADDR AND hardware_ce='1' AND
	writel='1') THEN addr_page <= data_cpu;
  ELSE addr_page <= addr_page;
  END IF;
END PROCESS;

control_reg:PROCESS	-- create the 8 bit Control register here
BEGIN
  WAIT UNTIL clk_cpu'event AND clk_cpu='1';
  IF (rst_cpu='1') THEN ctl_reg <= "11000000";
  ELSIF (addr_outl(7 downto 0)=CTL_REG_ADDR AND hardware_ce='1' AND
	writel='1') THEN ctl_reg <= data_cpu;
  ELSE ctl_reg <= ctl_reg;
  END IF;
  -- bus the interrupts together here.
  -- Bit 3 of the Control Register also gates off all interrupts.
  if (ctl_reg(3)='0') then
    int <= "00000000";
  else
    int <= '0' & '0' &
        uart_irq & ext_int & timer_int & '0'           & usb_int & '0';            
  end if;
END PROCESS;

page2_cel <= '1' when (addr_outl(15 downto 8)="00000010") else '0';
page2_ce <= page2_cel;
page2_int <= '1' when page2_cel='1' -- and
--                 (addr_outl(7)='0' or addr_outl(6 downto 5)="00") 
                 else '0';

data_inl <=  data_cpu when (writel='1')-- CPU write
        ELSE data_rom when (rom_ce='1')-- ROM data
	ELSE page2data when (page2_int='1') -- on-chip peripherals and IO devices
        ELSE datain;

page_ctl_data <= addr_page when addr_outl(0)='0' else ctl_reg;

with addr_outl(7 downto 4) select page2data <=
	page_ctl_data 	when "0000" ,	--0200
	a_datai 	when "0001" ,	--0210
	pp_dataout 	when "0010" ,	--0220
	pwr_dataout 	when "0011" ,	--0230
	uart_data 	when "0100" ,	--0240
	timer_data 	when "0110" ,	--0260
	video(7 downto 0) 	when "0111" ,	--0270
	usb_datao 	when "1000" ,	--0280
	usb_datao 	when "1001" ,	--0290
        usb_datao       WHEN others;    -- everything else

video_sel <= '1' when page2_cel='1' AND (addr_outl(7 downto 2)="011100") else '0';

-------------------------------------------------Create the 512x8 ROM------
rom : bistrom port map (
	addr => addr_outl(8 downto 0),
	rom_enb => rom_ce,
        rom_out => data_rom);

---------------- Bus arbitation unit ---------------------------------
-- This is a pretty simplistic arbitation. We just synchronize the grant,
-- assert ready to stop the V8 and tristate the control lines.
-- This assumes that the SIE is asynchronous.

-- we don't want to grant in the middle of a 4 cycle hardware access
-- or we'll confuse various peripherals. Nor do we want to release the bus
-- right after a write as the tristate will be faster than the WE going
-- high and we might leave WE_N floating low.
arb:PROCESS BEGIN
  wait until clk_cpu'event AND clk_cpu='1';
  if (rst_cpu='1') then
    bus_gntl    <= '0';
    usb_bus_gnt <= '0';
  else
    usb_bus_gnt <= usb_bus_gnt_d; -- default operation
    bus_gntl    <= bus_gnt_d;
  end if;
END PROCESS;
atomic_access <= hardware_ce OR writel; -- memory reads or code fetches may be
                                        -- interrupted.  Writes and hardware
                                        -- reads may not studder.
usb_bus_gnt_d <= (usb_bus_req AND               -- set if usb bus request and not
                NOT bus_gntl AND NOT atomic_access) OR  -- already reserved or in
                                                       -- an atomic access
                (usb_bus_req AND usb_bus_gnt);         -- hold till released

bus_gnt_d <= (bus_req AND NOT usb_bus_req AND -- set if bus request and not
            NOT usb_bus_gnt AND NOT atomic_access) OR  -- already reserved or in
                                                       -- an atomic access
                (bus_req AND bus_gntl);                -- hold till released

bus_gnt <= bus_gntl;	-- drive the local version out the port

------------- wait state generator---------------------------
-- cycles to the hardware registers are extended to 4 clocks to
-- easily meet the timing of slow periperals.
-- the VUART is a fast peripheral so we don't add wait states for it.
wait_state <= hardware_ce AND (
        (NOT wait_state3 AND
	 (NOT addr_outl(7) AND NOT addr_outl(6) AND NOT addr_outl(5) AND addr_outl(4))) -- audio chip
     OR (NOT usb_readyo AND
              addr_outl(7) AND NOT addr_outl(6) AND NOT addr_outl(5))  -- VUSB
        );
--     OR (NOT ready AND
--              addr_outl(7) AND     addr_outl(6))); -- V1394

waitsm:PROCESS
BEGIN
  wait until clk_cpu'event AND clk_cpu='1';
  if (wait_state='1') then
    wait_state3 <= wait_state2;
    wait_state2 <= wait_state1;
    wait_state1 <= '1';
  else
    wait_state3 <= '0';
    wait_state2 <= '0';
    wait_state1 <= '0';
  end if;

  -- we have a similar problem with the audio chip
  if (hardware_ce='1' AND addr_outl(7 downto 2)=AUDIO_BASE_ADDR AND readyl='0' AND writel='0') THEN
  	a_oe_n <= '0';
  else
  	a_oe_n <= '1';
  end if;
  if (hardware_ce='1' AND addr_outl(7 downto 2)=AUDIO_BASE_ADDR AND wait_state2='0' AND writel='1') THEN
  	a_we_n <= '0';
  else
  	a_we_n <= '1';
  end if;
END PROCESS;

 -- The following logic is stubbed out - JTAG Master normally goes here --
 tmsout <= '0'; 
 tckout <= '0'; 
 jtag_enb <= rst_cpu and rest; -- always 0 but the synthesizer doen't know
-- that so it will leave a tristate buffer in that is always tristate
-- this prevents the altera from driving the signal low and xilinx from
-- pulluing the signal up.
 tdi_enb <= '0';
 tdiout <= '0';
---------------------------------------------------------------------
-- IEEE 1284 Parallel Port interface
pp:v1284
  port map (	clk	=> clk_cpu,
       	rst	=> rst_cpu,
       	addr	=> addr_outl(2 downto 0),
       	datain	=> data_cpu,
       	dataout	=> pp_dataout,
       	write	=> writel,
       	read  	=> readl,
       	chip_sel=> pp_ce,
	-- IEEE 1284 PC Parallel Port interface
	pp_strobe_n  => pp_strobe_n,
	pp_datain    => pp_datai,
	pp_dataout   => pp_datao,
	pp_data_enb  => pp_data_enb,
	pp_ctl_in    => pp_ctl_in,
	pp_ctl_out   => pp_ctl_out,
	pp_ctl_enb   => pp_ctl_enb);
pp_ce <= '1' when (page2_cel='1' AND addr_outl(7 downto 3)=PP_BASE_ADDR)
	else '0';

uart:vuart	------------------Create the UART here-------------
  PORT MAP (
        clk         => clk_cpu,
        rst       => rst_cpu,
        addr        => addr_full(1 downto 0),
        datain      => data_cpu,
        dataout     => uart_data,
        read        => readl,
        write       => writel,
        chip_sel    => uart_cs,
        irq         => uart_irq,
        -- serial connections
        baud        => open,
        rx_data     => u_rx,
        tx_data     => u_tx
        );
uart_cs <= '1' WHEN (hardware_ce='1' AND addr_full(7 downto 2)=UART_BASE_ADDR) else '0';

timer: vtimer	----------------Create the 16 bit counter/timer here--------
  PORT MAP (clk	=> clk_cpu,
        rst	=> rst_cpu,
        addr	=> addr_full(2 downto 0),
        datain	=> data_cpu,
        dataout	=> timer_data,
        ext_enb	=> video(8),
        interrupt=> timer_int,
        pwm	=> pwm,
        sel	=> timer_sel,
        write	=> writel);
timer_sel <= '1' WHEN (addr_outl(7 downto 3)=TIME_BASE_ADDR and hardware_ce='1')
	else '0';

pwr: pwr_save 	----------------Create the Power-Save Unit here------------
  PORT MAP(
        clk         => clk_cpu,
        reset       => rst_cpu,
        addr        => addr_cpu(1 downto 0),
        chip_sel    => pwr_chip_sel,
        datain      => data_cpu,
        dataout     => pwr_dataout,
        write       => write_cpu,
        quiet       => quiet,
        rest        => rest,
        sleep       => sleep,
        glo_tri     => global_tristate,
        stop_osc    => stop_osc); -- currently not used.
pwr_chip_sel <= '1' WHEN (hardware_ce='1' AND addr_cpu(7 downto 2)=PWR_SAV_ADDR) else '0';

interrupt <= int(7) OR int(6) OR int(5) OR int(4) OR
             int(3) OR int(2) OR int(1) OR int(0);

-- A change in state of any of the enabled QUIET signals will "wake" up
-- the processor and possibly even the clock.
quiet <= bus_req & 	-- external bus request
	tms & 		-- JTAG activity
	ext_int & 	-- external interrupt
	u_rx & 	-- UART activity
	interrupt & 	-- any interrupt
	u_chan0i(1) & 	-- USB DPLUS
	u_chan0i(2) & 	-- USB DMINUS
        '0';

-- VUSB START
--------------------------Create the USB peripherals---------------
-- Note that V8 only customers will receive an empty architecture for the
-- VUSB and VUSB_HUB cores. These cores are optional and require additional
-- license fees. Typically you will want to simply remove these cores.

usb: vusb_top
  port map(
        clk48i      => clk48,      -- DPLL input clock
        rst_raw_n   => rst_raw_n,  -- unregistered reset input
        clken_dpllo => clken_dpllo,-- DPLL output clock unbuffered
        clken_12o   => clken_12o,  -- DPLL clock / 4 (12MHz) unbuffered
        clk_sie     => clk_sie,    -- SIE primary clock input
        clken_sie   => clken_sie,  -- SIE clock enable
	rst_sie     => rst_sie,    -- sync sie reset active high
        clk_cpu     => clk_cpu,    -- uProcessor clock input
        rst_cpu     => rst_cpu,    -- uProcessor reset input
        clken_12    => clken_hub,  -- SOF timer clock enable
        addri   => addr_outl,
        addro   => usb_addro,
	readi   => readl,
	reado   => usb_reado,
	writei  => writel,
	writeo  => usb_writeo,
        bmoe    => usb_bmoe,
	readyi  => readyl,
	readyo  => usb_readyo,
        bsoe    => usb_bsoe,
        datai   => data_inl,
        datao   => usb_datao,
        doe     => usb_doe,
	cei     => usb_chip_sel,
	int     => usb_int,
	bus_req => usb_bus_req,
	bus_gnt => usb_bus_gnt,
        --  Hub interface
        hc_eno        => hc_en,-- Host controller enable for empty arch
        pre_pid_det   => OPEN,
        valid_sof_pid => OPEN,
        lseop_det     => OPEN,    -- Low Speed EOP detected
        fseop_det     => OPEN,    -- Full Speed EOP detected        
        eop_48_out    => eop_48_out,  
	u_chan1i=> u_chan1i,     -- USB host interface
	u_chan1o=> u_chan1o,
        u_chan0i => u_chan0i,
        u_chan0o => u_chan0o,
        usb_en  => usb_en,              -- USB pull up enable
	debug   => open
       );

usb_chip_sel <= '1' WHEN (hardware_ce='1' AND addr_cpu(7 downto 5)=USB_BASE_ADDR) else '0';

debug(23) <= usb_bus_gnt;
debug(22) <= usb_bus_req;
-- VUSB END

END rtl;
