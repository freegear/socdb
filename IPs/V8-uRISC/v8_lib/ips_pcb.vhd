-------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: ips_pcb.vhd
-- Revision: D - Sept 1998
-- Description:
-- 	IntelliCore Prototype System Printed Circuit Board HDL model.
--
-- The IPS_PCB is meant to be a demonstration vehicle for VAutomations 
-- processors and USB/1394 serial protocol engines. The IPS provides a complete
-- demonstration of a complete Audio/video application for USB or 1394.
--
-- Features of the IPS include:
--
-- o One Altera EPF10K100A providing up to 100,000 gates of logic and 3K bytes
--	of RAM/ROM
--
-- o One Xilinx XC4062XL providing up to 62,000 gates of logic
--
-- o Two 8Kx8 Serial EEPROMs
--
-- o IEEE 1284 8-bit parallel port (IBM-PC compatible)
--
-- o JTAG in-circuit debugger port
--
-- o Up to 128Kx32 Static RAM, 20ns access speed
--
-- o RS232 drivers for up to 2 UART
--
-- o AD1845 Audio Codec for Audio demonstration application
--
-- o BT829 video decoder for Video demonstration application
--
-- o +5 volt power supply included or powered directly from USB
--
-- o Universal Serial Bus (USB) interface
--	Phillips PDIUSBP11 transcievers
--	Three series A USB connectors for HUB/HOST applications
--	One Series B connector for all USB applications
--
-- o IEEE 1394 FireWire inteface
-- 	TI TSB21C03 Physical interface chip (100,200 speed capable)
--	Three IEEE 1394 connectors for HUB/Function applications
--
-- o IrDA LED module
--
-- o 10/100MBS Ethernet MII PHY interface which can also be used
--	for general purpose debugging
--
-- o 5 logic analyzer pod connectors
--
-- Signals ending in _n are active low.
-------------------------------------------------------------------------------
-- This product is licensed to:
-- ÇÑÈ«¼· of ÅÂÀÎ½Ã½ºÅÛ
-- for use at site(s):
-- tsi
--------------Revision History--------------------------------------------------
-- $Log: ips_pcb.vhd,v $
-- Revision 1.13  1999/09/09 19:48:21  scott
-- Changed resistor models for the parallel printer port
-- from pullup models to series models.
--
-- Revision 1.12  1999/03/31 22:03:43  eric
-- minor changes due to PWR_SAVE changes.
--
-- Revision 1.11  1998/11/23 18:26:34  chris
-- Changed pullups on TMS and TCK to open1206's to stop driver conflict X's in verilog simulation.
--
-- Revision 1.10  1998/10/28 18:18:13  john
-- Added hub testbench outputs.
--
-- Revision 1.9  1998/09/16 00:10:29  eric
-- The REAL REV D. Added the switches for the upper banks of RAM.
--
-- Revision 1.8  1998/09/15 14:27:17  eric
-- Modified a few resistor values - no wiring changes.
--
-- Revision 1.7  1998/09/11 13:24:01  eric
-- Revision D release.
--
-- Revision 1.6  1998/06/16 17:06:58  chris
-- Added usb transceiver output enables to the port list.
--
-- Revision 1.5  1998/06/15 17:01:03  chris
-- Bypassed the USB connectors for simulation.  This change should have
-- no effect on the netlist produced by this model other than changing net
-- names.
--
-- Revision 1.4  1998/06/09 16:28:48  chris
-- Changed USB oscilator to 50MHz.
-- Added USB signal bypass around connectors for target and host operation.
-- *******************  Warning this breaks the netlist!!! ****************
--
-- Revision 1.3  1998/04/22 18:49:22  eric
-- PCB release level.
--
-- Revision 1.2  1998/04/10  19:24:02  eric
-- Corrected several component types.
--
-- Revision 1.1  1998/04/09 21:24:22  eric
-- Initial revision
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;	-- we use the IEEE standard 1164 logic types.
USE std.textio.all;	-- Need some I/O routines.

ENTITY ips_pcb IS	------------------------------ENTITY--------------------
  port (
    -- IEEE 1394 "FireWire" connections
        -- Note when connecting two 1394 connectors connect as follows:
        --  pin1 <-> pin1 , pin2 -> pin2 , pin3 -> pin5 , pin4 -> pin6
    signal fw_J14_1  : inout std_logic; -- vp
    signal fw_J14_2  : inout std_logic; -- vg
    signal fw_J14_3  : inout std_logic; -- tpb_n
    signal fw_J14_4  : inout std_logic; -- tpb
    signal fw_J14_5  : inout std_logic; -- tpa_n
    signal fw_J14_6  : inout std_logic; -- tpa
    signal fw_J15_1  : inout std_logic; -- vp
    signal fw_J15_2  : inout std_logic; -- vg
    signal fw_J15_3  : inout std_logic; -- tpb_n
    signal fw_J15_4  : inout std_logic; -- tpb
    signal fw_J15_5  : inout std_logic; -- tpa_n
    signal fw_J15_6  : inout std_logic; -- tpa
    signal fw_J16_1  : inout std_logic; -- vp
    signal fw_J16_2  : inout std_logic; -- vg
    signal fw_J16_3  : inout std_logic; -- tpb_n
    signal fw_J16_4  : inout std_logic; -- tpb
    signal fw_J16_5  : inout std_logic; -- tpa_n
    signal fw_J16_6  : inout std_logic; -- tpa

    -- USB connections
    signal usbb_dplus	: inout std_logic; -- usb channel 0
    signal usbb_dminus	: inout std_logic; -- usb channel 0
    signal usba1_dplus	: inout std_logic; -- usb channel 1
    signal usba1_dminus	: inout std_logic; -- usb channel 1
    signal usba1_oe_n	: inout std_logic; -- usb channel 1 output enable
    signal usba2_dplus	: inout std_logic; -- usb channel 2
    signal usba2_dminus	: inout std_logic; -- usb channel 2
    signal usba2_oe_n	: inout std_logic; -- usb channel 2 output enable
    signal usba3_dplus	: inout std_logic; -- usb channel 3
    signal usba3_dminus	: inout std_logic; -- usb channel 3
    signal usba3_oe_n	: inout std_logic; -- usb channel 3 output enable
    signal usba4_dplus	: inout std_logic; -- usb channel 4
    signal usba4_dminus	: inout std_logic; -- usb channel 4
    signal usba5_dplus	: inout std_logic; -- usb channel 5
    signal usba5_dminus	: inout std_logic; -- usb channel 5
    signal usba6_dplus	: inout std_logic; -- usb channel 6
    signal usba6_dminus	: inout std_logic; -- usb channel 6
    -- JTAG debugger connector via 9 pin D male
    signal dsub9_F_J4_1	: inout std_logic; -- unused
    signal dsub9_F_J4_2	: inout std_logic; -- TCK
    signal dsub9_F_J4_3	: inout std_logic; -- TMS
    signal dsub9_F_J4_4	: inout std_logic; -- unused
    signal dsub9_F_J4_5	: inout std_logic; -- gnd,
    signal dsub9_F_J4_6	: inout std_logic; -- unused
    signal dsub9_F_J4_7	: inout std_logic; -- TDI
    signal dsub9_F_J4_8	: inout std_logic; -- TDO
    signal dsub9_F_J4_9	: inout std_logic;-- unused,
    -- Audio Connectors
    signal l_head_out	: inout std_logic; -- headphone outputs
    signal r_head_out	: inout std_logic;
    -- IEEE 1284 PC Parallel Port interface (signal names are "compatible" names)
    signal dsub25_F_J3_1  : inout  std_logic;-- pp_strobe_n,
    signal dsub25_F_J3_2  : inout  std_logic;-- pp_data(1),
    signal dsub25_F_J3_3  : inout  std_logic;-- pp_data(2), -- we look like a PC
    signal dsub25_F_J3_4  : inout  std_logic;-- pp_data(3), -- straight connect to
    signal dsub25_F_J3_5  : inout  std_logic;-- pp_data(4),
    signal dsub25_F_J3_6  : inout  std_logic;-- pp_data(5),
    signal dsub25_F_J3_7  : inout  std_logic;-- pp_data(6),
    signal dsub25_F_J3_8  : inout  std_logic;-- pp_data(7),
    signal dsub25_F_J3_9  : inout  std_logic;-- pp_data(8),
    signal dsub25_F_J3_10 : inout  std_logic;-- north_c(20),    -- pp_ack_n,
    signal dsub25_F_J3_11 : inout  std_logic;-- north_c(21),    -- pp_busy,
    signal dsub25_F_J3_12 : inout  std_logic;-- north_c(22),    -- pp_perror,
    signal dsub25_F_J3_13 : inout  std_logic;-- north_c(23),    -- pp_select,
    signal dsub25_F_J3_14 : inout  std_logic;-- north_c(24),    -- pp_autofd_n,
    signal dsub25_F_J3_15 : inout  std_logic;-- north_c(25),    -- pp_fault_n,
    signal dsub25_F_J3_16 : inout  std_logic;-- north_c(26),    -- pp_init_n,
    signal dsub25_F_J3_17 : inout  std_logic;-- north_c(27),    -- pp_selectin_n,
    signal dsub25_F_J3_18 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_19 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_20 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_21 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_22 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_23 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_24 : inout  std_logic;-- gnd,
    signal dsub25_F_J3_25 : inout  std_logic;-- gnd,
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
    -- mii connector for ethernet or expansion port
    signal mii_F_J17_1	: inout std_logic; -- +5V
    signal mii_F_J17_2	: inout std_logic; -- MDIO
    signal mii_F_J17_3	: inout std_logic; -- MDC
    signal mii_F_J17_4	: inout std_logic; -- RXD(3)
    signal mii_F_J17_5  : inout std_logic; -- RXD(2)
    signal mii_F_J17_6	: inout std_logic; -- RXD(1)
    signal mii_F_J17_7	: inout std_logic; -- RXD(0)
    signal mii_F_J17_8	: inout std_logic; -- RX_DV
    signal mii_F_J17_9	: inout std_logic; -- RX_CLK
    signal mii_F_J17_10	: inout std_logic;-- RX_ERR
    signal mii_F_J17_11	: inout std_logic;-- TX_ERR
    signal mii_F_J17_12	: inout std_logic;-- TX_CLK
    signal mii_F_J17_13	: inout std_logic;-- TX_EN
    signal mii_F_J17_14	: inout std_logic;-- TXD(0)
    signal mii_F_J17_15	: inout std_logic;-- TXD(1)
    signal mii_F_J17_16	: inout std_logic;-- TXD(2)
    signal mii_F_J17_17	: inout std_logic;-- TXD(3)
    signal mii_F_J17_18	: inout std_logic;-- COL
    signal mii_F_J17_19	: inout std_logic;-- CRS
    signal mii_F_J17_20	: inout std_logic;-- +5V
    signal mii_F_J17_21	: inout std_logic;-- +5V
    signal mii_F_J17_22	: inout std_logic;-- contact 22-39 are all GND
    signal mii_F_J17_23	: inout std_logic;--
    signal mii_F_J17_24	: inout std_logic;--
    signal mii_F_J17_25	: inout std_logic;--
    signal mii_F_J17_26	: inout std_logic;--
    signal mii_F_J17_27	: inout std_logic;--
    signal mii_F_J17_28	: inout std_logic;--
    signal mii_F_J17_29	: inout std_logic;--
    signal mii_F_J17_30	: inout std_logic;--
    signal mii_F_J17_31	: inout std_logic;--
    signal mii_F_J17_32	: inout std_logic;--
    signal mii_F_J17_33	: inout std_logic;--
    signal mii_F_J17_34	: inout std_logic;--
    signal mii_F_J17_35	: inout std_logic;--
    signal mii_F_J17_36	: inout std_logic;--
    signal mii_F_J17_37	: inout std_logic;--
    signal mii_F_J17_38	: inout std_logic;--
    signal mii_F_J17_39	: inout std_logic;--
    signal mii_F_J17_40 : inout std_logic;--

    signal speed_dp : out std_logic_vector(16 downto 1);
    signal power_dp : out std_logic_vector(16 downto 1)
    );

-- The following attributes are needed only for PCB generation.
TYPE string_array IS ARRAY (natural range <>, natural range <>) OF CHARACTER;
attribute pin_number : string;
attribute array_pin_number : string_array;
-- 1394 connectors share the power pin
Attribute pin_number of fw_J14_1 : signal is " ";
attribute pin_number of fw_J14_2 : signal is " ";
attribute pin_number of fw_J14_3 : signal is " ";
attribute pin_number of fw_J14_4 : signal is " ";
attribute pin_number of fw_J14_5 : signal is " ";
attribute pin_number of fw_J14_6 : signal is " ";
attribute pin_number of fw_J15_1 : signal is " ";
attribute pin_number of fw_J15_2 : signal is " ";
attribute pin_number of fw_J15_3 : signal is " ";
attribute pin_number of fw_J15_4 : signal is " ";
attribute pin_number of fw_J15_5 : signal is " ";
attribute pin_number of fw_J15_6 : signal is " ";
attribute pin_number of fw_J16_1 : signal is " ";
attribute pin_number of fw_J16_2 : signal is " ";
attribute pin_number of fw_J16_3 : signal is " ";
attribute pin_number of fw_J16_4 : signal is " ";
attribute pin_number of fw_J16_5 : signal is " ";
attribute pin_number of fw_J16_6 : signal is " ";
-- The usb signals bypass
attribute pin_number of usbb_dplus   : signal is " ";
attribute pin_number of usbb_dminus  : signal is " ";
attribute pin_number of usba1_dplus  : signal is " ";
attribute pin_number of usba1_dminus : signal is " ";
attribute pin_number of usba1_oe_n : signal is " ";
attribute pin_number of usba2_dplus  : signal is " ";
attribute pin_number of usba2_dminus : signal is " ";
attribute pin_number of usba2_oe_n : signal is " ";
attribute pin_number of usba3_dplus  : signal is " ";
attribute pin_number of usba3_dminus : signal is " ";
attribute pin_number of usba3_oe_n : signal is " ";
attribute pin_number of usba4_dplus  : signal is " ";
attribute pin_number of usba4_dminus : signal is " ";
attribute pin_number of usba5_dplus  : signal is " ";
attribute pin_number of usba5_dminus : signal is " ";
attribute pin_number of usba6_dplus  : signal is " ";
attribute pin_number of usba6_dminus : signal is " ";
-- The Audio Jacks are all phone jacks
attribute pin_number of l_head_out : signal is " ";
attribute pin_number of r_head_out : signal is " ";
-- The RS232 connector is a 9 pin D
attribute pin_number of dsub9_F_J2_1 : signal is " ";
attribute pin_number of dsub9_F_J2_2 : signal is " ";
attribute pin_number of dsub9_F_J2_3 : signal is " ";
attribute pin_number of dsub9_F_J2_4 : signal is " ";
attribute pin_number of dsub9_F_J2_5 : signal is " ";
attribute pin_number of dsub9_F_J2_6 : signal is " ";
attribute pin_number of dsub9_F_J2_7 : signal is " ";
attribute pin_number of dsub9_F_J2_8 : signal is " ";
attribute pin_number of dsub9_F_J2_9 : signal is " ";
-- The Parallel Port is the standard 25 pin D (1284-A)
attribute pin_number of dsub25_F_J3_1  : signal is " ";
attribute pin_number of dsub25_F_J3_2  : signal is " ";
attribute pin_number of dsub25_F_J3_3  : signal is " ";
attribute pin_number of dsub25_F_J3_4  : signal is " ";
attribute pin_number of dsub25_F_J3_5  : signal is " ";
attribute pin_number of dsub25_F_J3_6  : signal is " ";
attribute pin_number of dsub25_F_J3_7  : signal is " ";
attribute pin_number of dsub25_F_J3_8  : signal is " ";
attribute pin_number of dsub25_F_J3_9  : signal is " ";
attribute pin_number of dsub25_F_J3_10 : signal is " ";
attribute pin_number of dsub25_F_J3_11 : signal is " ";
attribute pin_number of dsub25_F_J3_12 : signal is " ";
attribute pin_number of dsub25_F_J3_13 : signal is " ";
attribute pin_number of dsub25_F_J3_14 : signal is " ";
attribute pin_number of dsub25_F_J3_15 : signal is " ";
attribute pin_number of dsub25_F_J3_16 : signal is " ";
attribute pin_number of dsub25_F_J3_17 : signal is " ";
attribute pin_number of dsub25_F_J3_18 : signal is " ";
attribute pin_number of dsub25_F_J3_19 : signal is " ";
attribute pin_number of dsub25_F_J3_20 : signal is " ";
attribute pin_number of dsub25_F_J3_21 : signal is " ";
attribute pin_number of dsub25_F_J3_22 : signal is " ";
attribute pin_number of dsub25_F_J3_23 : signal is " ";
attribute pin_number of dsub25_F_J3_24 : signal is " ";
attribute pin_number of dsub25_F_J3_25 : signal is " ";
-- The JTAG connector is a 9 pin D
attribute pin_number of dsub9_F_J4_1 : signal is " ";
attribute pin_number of dsub9_F_J4_2 : signal is " ";
attribute pin_number of dsub9_F_J4_3 : signal is " ";
attribute pin_number of dsub9_F_J4_4 : signal is " ";
attribute pin_number of dsub9_F_J4_5 : signal is " ";
attribute pin_number of dsub9_F_J4_6 : signal is " ";
attribute pin_number of dsub9_F_J4_7 : signal is " ";
attribute pin_number of dsub9_F_J4_8 : signal is " ";
attribute pin_number of dsub9_F_J4_9 : signal is " ";
-- MII Connector
attribute pin_number of mii_F_J17_1  : signal is " ";
attribute pin_number of mii_F_J17_2  : signal is " ";
attribute pin_number of mii_F_J17_3  : signal is " ";
attribute pin_number of mii_F_J17_4  : signal is " ";
attribute pin_number of mii_F_J17_5  : signal is " ";
attribute pin_number of mii_F_J17_6  : signal is " ";
attribute pin_number of mii_F_J17_7  : signal is " ";
attribute pin_number of mii_F_J17_8  : signal is " ";
attribute pin_number of mii_F_J17_9  : signal is " ";
attribute pin_number of mii_F_J17_10 : signal is " ";
attribute pin_number of mii_F_J17_11 : signal is " ";
attribute pin_number of mii_F_J17_12 : signal is " ";
attribute pin_number of mii_F_J17_13 : signal is " ";
attribute pin_number of mii_F_J17_14 : signal is " ";
attribute pin_number of mii_F_J17_15 : signal is " ";
attribute pin_number of mii_F_J17_16 : signal is " ";
attribute pin_number of mii_F_J17_17 : signal is " ";
attribute pin_number of mii_F_J17_18 : signal is " ";
attribute pin_number of mii_F_J17_19 : signal is " ";
attribute pin_number of mii_F_J17_20 : signal is " ";
attribute pin_number of mii_F_J17_21 : signal is " ";
attribute pin_number of mii_F_J17_22 : signal is " ";
attribute pin_number of mii_F_J17_23 : signal is " ";
attribute pin_number of mii_F_J17_24 : signal is " ";
attribute pin_number of mii_F_J17_25 : signal is " ";
attribute pin_number of mii_F_J17_26 : signal is " ";
attribute pin_number of mii_F_J17_27 : signal is " ";
attribute pin_number of mii_F_J17_28 : signal is " ";
attribute pin_number of mii_F_J17_29 : signal is " ";
attribute pin_number of mii_F_J17_30 : signal is " ";
attribute pin_number of mii_F_J17_31 : signal is " ";
attribute pin_number of mii_F_J17_32 : signal is " ";
attribute pin_number of mii_F_J17_33 : signal is " ";
attribute pin_number of mii_F_J17_34 : signal is " ";
attribute pin_number of mii_F_J17_35 : signal is " ";
attribute pin_number of mii_F_J17_36 : signal is " ";
attribute pin_number of mii_F_J17_37 : signal is " ";
attribute pin_number of mii_F_J17_38 : signal is " ";
attribute pin_number of mii_F_J17_39 : signal is " ";
attribute pin_number of mii_F_J17_40 : signal is " ";
END ips_pcb;

ARCHITECTURE structural of ips_pcb is -----------------Architecture-----------

COMPONENT xil240hq ------------- Xilinx FPGA
      PORT (clk_cpu    	: INOUT std_logic := 'Z';
            clk48mhz 	: INOUT std_logic := 'Z';
            clk_1394 	: INOUT std_logic := 'Z';
            clk_xtra 	: INOUT std_logic := 'Z';
            clk_fclk1 	: INOUT std_logic := 'Z';
            reset_n 	: IN std_logic;
	    -- P1284 parallel port interface
            pp_data  	: INOUT std_logic_vector(1 to 8) := (others => 'Z');
            pp_strobe_n : INOUT std_logic := 'Z';
            pp_init_n	: INOUT std_logic := 'Z';
            pp_autofd_n	: INOUT std_logic := 'Z';
            pp_selectin_n: INOUT std_logic := 'Z';
            pp_ack_n	: INOUT std_logic := 'Z';
            pp_busy	: INOUT std_logic := 'Z';
            pp_error	: INOUT std_logic := 'Z';
            pp_select	: INOUT std_logic := 'Z';
            pp_fault_n	: INOUT std_logic := 'Z';
	    -- Audio Codec interface (ad1845)
            a_addr   	: OUT std_logic_vector(1 downto 0) := (others => 'Z');
            a_data  	: INOUT std_logic_vector(7 downto 0) := (others => 'Z');
            a_wr_n	: OUT std_logic := 'Z';
            a_rd_n	: OUT std_logic := 'Z';
            a_cs_n	: OUT std_logic := 'Z';
	    -- UART interface
	    u_rx1	: IN std_logic;
	    u_rx2	: IN std_logic;
            u_tx1   	: OUT std_logic := 'Z';
            u_tx2   	: OUT std_logic := 'Z';
	    -- SRAM interface
            r_addr 	: OUT std_logic_vector(16 downto 0) := (others =>'Z');
            r_data 	: INOUT std_logic_vector(15 downto 0) := (others =>'Z');
            r_ce_n 	: OUT std_logic := 'Z';
            r_oe_n 	: OUT std_logic := 'Z';
            r_wel_n 	: OUT std_logic := 'Z';
            r_weh_n 	: OUT std_logic := 'Z';
	    -- Serial EEPROM interface
            ee_sda 	: INOUT std_logic := 'Z';
            ee_clk 	: INOUT std_logic := 'Z';
            ee_wp 	: INOUT std_logic := 'Z';
	    -- IrDA interface
            i_rxd	: IN  std_logic;
            i_sd	: OUT std_logic := 'Z';
            i_txd	: OUT std_logic := 'Z';
	    -- USB B connector interface
            usbb_dplus 	: INOUT std_logic := 'Z';
            usbb_dminus	: INOUT std_logic := 'Z';
            usbb_rcv	: IN std_logic;
            usbb_vp	: IN std_logic;
            usbb_vm	: IN std_logic;
            usbb_oe_n	: OUT std_logic :='Z';
            usbb_speed	: OUT std_logic :='Z';
            usbb_vpo	: OUT std_logic :='Z';
            usbb_vmo	: OUT std_logic :='Z';
            usbb_low	: OUT std_logic :='Z';
            usbb_high	: OUT std_logic :='Z';
            usbb_host1	: OUT std_logic :='Z';
            usbb_host2	: OUT std_logic :='Z';
	    -- USB A connector #1 interface - also used for host mode
            usba1_dplus	: INOUT std_logic := 'Z';
            usba1_dminus: INOUT std_logic := 'Z';
            usba1_rcv	: IN std_logic;
            usba1_vp	: IN std_logic;
            usba1_vm	: IN std_logic;
            usba1_oe_n	: OUT std_logic :='Z';
            usba1_speed	: OUT std_logic :='Z';
            usba1_vpo	: OUT std_logic :='Z';
            usba1_vmo	: OUT std_logic :='Z';
            usba1_pwron	: OUT std_logic :='Z';
	    -- USB A connector #2 interface - also used for host mode
            usba2_dplus	: INOUT std_logic := 'Z';
            usba2_dminus: INOUT std_logic := 'Z';
            usba2_rcv	: IN std_logic;
            usba2_vp	: IN std_logic;
            usba2_vm	: IN std_logic;
            usba2_oe_n	: OUT std_logic :='Z';
            usba2_speed	: OUT std_logic :='Z';
            usba2_vpo	: OUT std_logic :='Z';
            usba2_vmo	: OUT std_logic :='Z';
            usba2_pwron	: OUT std_logic :='Z';
	    -- USB A connector #3 interface - also used for host mode
            usba3_dplus	: INOUT std_logic := 'Z';
            usba3_dminus: INOUT std_logic := 'Z';
            usba3_rcv	: IN std_logic;
            usba3_vp	: IN std_logic;
            usba3_vm	: IN std_logic;
            usba3_oe_n	: OUT std_logic :='Z';
            usba3_speed	: OUT std_logic :='Z';
            usba3_vpo	: OUT std_logic :='Z';
            usba3_vmo	: OUT std_logic :='Z';
            usba3_pwron	: OUT std_logic :='Z';
	    -- USB A connector #4 interface
            usba4_dplus	: INOUT std_logic := 'Z';
            usba4_dminus: INOUT std_logic := 'Z';
            usba4_pwron	: OUT std_logic;
	    -- USB A connector #5 interface
            usba5_dplus	: INOUT std_logic := 'Z';
            usba5_dminus: INOUT std_logic := 'Z';
            usba5_pwron	: OUT std_logic;
	    -- USB A connector #6 interface
            usba6_dplus	: INOUT std_logic := 'Z';
            usba6_dminus: INOUT std_logic := 'Z';
            usba6_pwron	: OUT std_logic;
	    -- 1394 PHY interface
            fw_phy 	: INOUT std_logic_vector(8 downto 0) := (others =>'Z');
	    -- video interface
            video 	: INOUT std_logic_vector(8 downto 0) := (others =>'Z');
	    -- LED indicator
            led 	: OUT std_logic_vector(9 downto 0) := (others =>'Z');
	    -- Expansion connector (pinned out for MII compatiblity)
            mii 	: INOUT std_logic_vector(19 downto 2) := (others =>'Z');
	    -- Available pins...
            avail 	: INOUT std_logic_vector(4 downto 0) := (others =>'Z');
	    -- Xilinx configuration pins
            m0          : IN    std_logic;
            m1          : IN    std_logic;
            m2          : IN    std_logic;
            init_n      : IN    std_logic;
            done        : IN    std_logic;
            prog_n      : IN    std_logic;
            din         : IN    std_logic;
            dout        : OUT   std_logic := 'Z';
            cclk        : IN    std_logic;
            tck         : INOUT std_logic := 'Z';
            tms         : INOUT std_logic := 'Z';
            tdi         : INOUT std_logic := 'Z';
            tdo         : INOUT std_logic := 'Z';
	    -- power pins (GND pins are done as an attribute
	    vcc19	: IN std_logic;
	    vcc30	: IN std_logic;
	    vcc40	: IN std_logic;
	    vcc61	: IN std_logic;
	    vcc80	: IN std_logic;
	    vcc90	: IN std_logic;
	    vcc101	: IN std_logic;
	    vcc121	: IN std_logic;
	    vcc140	: IN std_logic;
	    vcc150	: IN std_logic;
	    vcc161	: IN std_logic;
	    vcc180	: IN std_logic;
	    vcc201	: IN std_logic;
	    vcc212	: IN std_logic;
	    vcc222	: IN std_logic;
	    vcc240	: IN std_logic
            );
END COMPONENT;

COMPONENT a10k240
      PORT (clk48mhz   	: IN std_logic;
            gclk0 	: IN std_logic;
            gclk1 	: IN std_logic;
            gclk2 	: IN std_logic;
            gclk3 	: IN std_logic;
            gclk0_out 	: OUT std_logic := 'Z';
            gclk1_out 	: OUT std_logic := 'Z';
            gclk2_out 	: OUT std_logic := 'Z';
            reset_n 	: IN std_logic;
	    -- P1284 parallel port interface
            pp_data  	: INOUT std_logic_vector(1 to 8) := (others => 'Z');
            pp_strobe_n : INOUT std_logic := 'Z';
            pp_init_n	: INOUT std_logic := 'Z';
            pp_autofd_n	: INOUT std_logic := 'Z';
            pp_selectin_n: INOUT std_logic := 'Z';
            pp_ack_n	: INOUT std_logic := 'Z';
            pp_busy	: INOUT std_logic := 'Z';
            pp_error	: INOUT std_logic := 'Z';
            pp_select	: INOUT std_logic := 'Z';
            pp_fault_n	: INOUT std_logic := 'Z';
	    -- Audio Codec interface (ad1845)
            a_addr   	: OUT std_logic_vector(1 downto 0) := (others => 'Z');
            a_data  	: INOUT std_logic_vector(7 downto 0) := (others => 'Z');
            a_wr_n	: OUT std_logic := 'Z';
            a_rd_n	: OUT std_logic := 'Z';
            a_cs_n	: OUT std_logic := 'Z';
	    -- UART interface
	    u_rx1	: IN std_logic;
	    u_rx2	: IN std_logic;
            u_tx1   	: OUT std_logic := 'Z';
            u_tx2   	: OUT std_logic := 'Z';
	    -- SRAM interface
            r_addr 	: OUT std_logic_vector(16 downto 0) := (others =>'Z');
            r_data 	: INOUT std_logic_vector(15 downto 0) := (others =>'Z');
            r_ce_n 	: OUT std_logic := 'Z';
            r_oe_n 	: OUT std_logic := 'Z';
            r_wel_n 	: OUT std_logic := 'Z';
            r_weh_n 	: OUT std_logic := 'Z';
	    -- Serial EEPROM interface
            ee_sda 	: INOUT std_logic := 'Z';
            ee_clk 	: INOUT std_logic := 'Z';
            ee_wp 	: INOUT std_logic := 'Z';
	    -- USB B connector interface
            usbb_dplus 	: INOUT std_logic := 'Z';
            usbb_dminus	: INOUT std_logic := 'Z';
            usbb_rcv	: IN std_logic;
            usbb_vp	: IN std_logic;
            usbb_vm	: IN std_logic;
            usbb_oe_n	: OUT std_logic :='Z';
            usbb_speed	: OUT std_logic :='Z';
            usbb_vpo	: OUT std_logic :='Z';
            usbb_vmo	: OUT std_logic :='Z';
            usbb_low	: OUT std_logic :='Z';
            usbb_high	: OUT std_logic :='Z';
            usbb_host1	: OUT std_logic :='Z';
            usbb_host2	: OUT std_logic :='Z';
	    -- USB A connector #1 interface - also used for host mode
            usba1_dplus	: INOUT std_logic := 'Z';
            usba1_dminus: INOUT std_logic := 'Z';
            usba1_rcv	: IN std_logic;
            usba1_vp	: IN std_logic;
            usba1_vm	: IN std_logic;
            usba1_oe_n	: OUT std_logic :='Z';
            usba1_speed	: OUT std_logic :='Z';
            usba1_vpo	: OUT std_logic :='Z';
            usba1_vmo	: OUT std_logic :='Z';
            usba1_pwron	: OUT std_logic :='Z';
	    -- USB A connector #2 interface
            usba2_dplus	: INOUT std_logic := 'Z';
            usba2_dminus: INOUT std_logic := 'Z';
            usba2_rcv	: IN std_logic;
            usba2_vp	: IN std_logic;
            usba2_vm	: IN std_logic;
            usba2_oe_n	: OUT std_logic :='Z';
            usba2_speed	: OUT std_logic :='Z';
            usba2_vpo	: OUT std_logic :='Z';
            usba2_vmo	: OUT std_logic :='Z';
            usba2_pwron	: OUT std_logic :='Z';
	    -- USB A connector #3 interface
            usba3_dplus	: INOUT std_logic := 'Z';
            usba3_dminus: INOUT std_logic := 'Z';
            usba3_rcv	: IN std_logic;
            usba3_vp	: IN std_logic;
            usba3_vm	: IN std_logic;
            usba3_oe_n	: OUT std_logic :='Z';
            usba3_speed	: OUT std_logic :='Z';
            usba3_vpo	: OUT std_logic :='Z';
            usba3_vmo	: OUT std_logic :='Z';
            usba3_pwron	: OUT std_logic :='Z';
	    -- USB A connector #4 interface
            usba4_dplus	: INOUT std_logic := 'Z';
            usba4_dminus: INOUT std_logic := 'Z';
            usba4_pwron	: OUT std_logic;
	    -- USB A connector #5 interface
            usba5_dplus	: INOUT std_logic := 'Z';
            usba5_dminus: INOUT std_logic := 'Z';
            usba5_pwron	: OUT std_logic;
	    -- USB A connector #6 interface
            usba6_dplus	: INOUT std_logic := 'Z';
            usba6_dminus: INOUT std_logic := 'Z';
            usba6_pwron	: OUT std_logic;
	    -- LED indicator
            led 	: OUT std_logic_vector(9 downto 0) := (others =>'Z');
	    -- Expansion connector (pinned out for MII compatiblity)
            mii 	: INOUT std_logic_vector(19 downto 2) := (others =>'Z');
	    -- video interface
            vid 	: INOUT std_logic_vector(8 downto 0) := (others =>'Z');
	    -- Firewire interface
            fw_phy 	: INOUT std_logic_vector(8 downto 0) := (others =>'Z');
	    -- available pins
            avail 	: INOUT std_logic_vector(1 downto 0) := (others =>'Z');
	    -- Xilinx configuration pins
            msel0       : IN    std_logic;
            msel1       : IN    std_logic;
            nconfig     : IN    std_logic;
            init_done   : INOUT std_logic;
            conf_done   : INOUT std_logic;
            nstatus     : INOUT std_logic;
            data0       : IN    std_logic;
            nce         : IN    std_logic;
            dclk        : IN    std_logic;
            nceo        : INOUT std_logic;
            tcki        : IN  std_logic;
            tcko        : OUT std_logic := 'Z';
            tms         : INOUT std_logic := 'Z';
            tdi         : INOUT std_logic := 'Z';
            tdo         : INOUT std_logic := 'Z';
	    -- power pins (GND pins are done as an attribute
	    vcc5	: IN std_logic;
	    vcc16	: IN std_logic;
	    vcc27	: IN std_logic;
	    vcc37	: IN std_logic;
	    vcc47	: IN std_logic;
	    vcc57	: IN std_logic;
	    vcc77	: IN std_logic;
	    vcc89	: IN std_logic;
	    vcc96	: IN std_logic;
	    vcc112	: IN std_logic;
	    vcc122	: IN std_logic;
	    vcc130	: IN std_logic;
	    vcc140	: IN std_logic;
	    vcc150	: IN std_logic;
	    vcc160	: IN std_logic;
	    vcc170	: IN std_logic;
	    vcc189	: IN std_logic;
	    vcc205	: IN std_logic;
	    vcc224	: IN std_logic
            );
END COMPONENT;

COMPONENT ram128k8
  --GENERIC(infname: STRING(1 TO 12) := "ram128k8.hex");
  PORT (SIGNAL addr: IN    std_logic_vector(16 DOWNTO 0); -- Address
	SIGNAL ce_n: IN    std_logic;  -- Chip enable1
	SIGNAL ce  : IN    std_logic;  -- Chip enable2
	SIGNAL data: INOUT std_logic_vector(7 DOWNTO 0); -- Data I/O port
	SIGNAL oe_n: IN    std_logic;  -- Output enable
	SIGNAL we_n: IN    std_logic); -- Write enable
END COMPONENT;

COMPONENT seeprom
  --GENERIC(infname: STRING(1 TO 12) := "seeprom1.hex");
  PORT (SIGNAL addr0: IN    std_logic; -- Address
        SIGNAL addr1: IN    std_logic; -- Address
        SIGNAL addr2: IN    std_logic; -- Address
        SIGNAL sda : INOUT std_logic;  -- Serial Data
        SIGNAL clk : IN    std_logic;  -- clock
        SIGNAL wp  : IN    std_logic); -- Write pulse (NC on some)
END COMPONENT;
COMPONENT bt829
  PORT ( -- digital video stream interface
	vd	: OUT std_logic_vector(15 downto 0) := (others => 'Z'); -- video data
	qclk	: out std_logic := 'Z'; -- video data on rising edge
	active	: out std_logic := 'Z';
	ccvalid	: out std_logic := 'Z';
	cbflag	: out std_logic := 'Z';
	dvalid	: out std_logic := 'Z';
	field	: out std_logic := 'Z';
	hreset_n: out std_logic := 'Z';
	oe_n	: in std_logic;
	vactive	: out std_logic := 'Z';
	vreset_n: out std_logic := 'Z';
	-- clocks and misc interface
	clkx1	: out std_logic := 'Z';
	clkx2	: out std_logic := 'Z';
	numxtal	: in std_logic;
	pwrdn	: in std_logic;
	xt0i	: inout std_logic := 'Z';
	xt0o	: inout std_logic := 'Z';
	xt1i	: inout std_logic := 'Z';
	xt1o	: inout std_logic := 'Z';
	-- I2C bus interface
	i2ccs	: in std_logic;
	scl	: in std_logic;
	sda	: inout std_logic := 'Z';
	rst_n	: in std_logic;
	-- JTAG interface
	tck	: in std_logic;
	tdi	: in std_logic;
	tdo	: out std_logic := 'Z';
	tms	: in std_logic;
	trst_n	: in std_logic;
	-- analog interface
	agccap	: inout std_logic := 'Z';
	cabias	: inout std_logic := 'Z';
	ccbias	: inout std_logic := 'Z';
	cin	: in std_logic;
	clevel	: in std_logic;
	cref_p	: in std_logic;
	cref_m	: in std_logic;
	mux_0	: in std_logic;
	mux_1	: in std_logic;
	mux_2	: in std_logic;
	muxout	: out std_logic := 'Z';
	syncdet	: in std_logic;
	yabias	: inout std_logic := 'Z';
	ycbias	: inout std_logic := 'Z';
	yin	: in std_logic;
	yref_p	: in std_logic;
	yref_m	: in std_logic;
	refout	: out std_logic := 'Z');
END COMPONENT;
COMPONENT ad1846	-- acutally we use the ad1845 which is pin compatible.
  PORT (
	addr   : in  std_logic_vector(1 downto 0);
	data   : inout std_logic_vector(7 downto 0);
	wr_n   : in std_logic;
	rd_n   : in std_logic;
	cs_n   : in std_logic;
	pdrq   : out std_logic;
	pdak_n : in std_logic;
	cdrq   : out std_logic;
	cdak_n : in std_logic;
	dben_n : out std_logic;
	dbdir  : out std_logic;
	pwrdn_n: in std_logic;
	reset_n: in std_logic;
	int    : out std_logic;
	xctl0  : out std_logic;
	xctl1  : out std_logic;
	-- Below are the analog pins
	l_line : in std_logic;
	r_line : in std_logic;
	l_mic  : in std_logic;
	r_mic  : in std_logic;
	l_aux1 : in std_logic;
	r_aux1 : in std_logic;
	l_aux2 : in std_logic;
	r_aux2 : in std_logic;
	l_out  : out std_logic;
	r_out  : out std_logic;
	xtal1i : in std_logic;
	xtal1o : out std_logic;
	xtal2i : in std_logic;
	xtal2o : out std_logic;
	vref   : out std_logic;
	vref_f : in std_logic;
	l_filt : in std_logic;
	r_filt : in std_logic);
END COMPONENT;

COMPONENT ssm2135
  port (
	ina_n   : in  std_logic;
	ina	: in  std_logic;
	outa	: out std_logic;
	inb_n   : in  std_logic;
	inb	: in  std_logic;
	outb	: out std_logic;
	gnds	: in  std_logic;
	pwr	: in  std_logic);
END COMPONENT;

COMPONENT ti21lv03
  port (cps        : in    std_logic;    -- cable power status
	xi         : in    std_logic;    -- crystal input
	xo         : out   std_logic;    -- crystal output
	filter     : inout std_logic;    -- PLL filter I/O pin to external filter
	reset_n    : in    std_logic;    -- Reset (active low)
        pd         : in    std_logic;    -- Power Down input
        cna        : out   std_logic;    -- Cable not Active output
	iso_n      : in    std_logic;    -- PHY-Link isolation enable (active low)
	lps        : in    std_logic;    -- link power status
	lreq       : in    std_logic;    -- link request input
	sysclk     : out   std_logic;    -- serial clock to link
	ctl0       : inout std_logic;    -- link interface control 0
	ctl1       : inout std_logic;    -- link interface control 1
	d0         : inout std_logic;    -- link interface data 0
	d1         : inout std_logic;    -- link interface data 1
	d2         : inout std_logic;    -- link interface data 2
	d3         : inout std_logic;    -- link interface data 3
	c_lokon    : inout std_logic;    -- configuration manager contender input or link on output
	pc0        : in    std_logic;    -- power class programming input 0
	pc1        : in    std_logic;    -- power class programming input 1
	pc2        : in    std_logic;    -- power class programming input 2
	tpbias1    : out   std_logic;    -- bias voltage output
	tpbias2    : out   std_logic;    -- bias voltage output
	tpbias3    : out   std_logic;    -- bias voltage output
	r1         : in    std_logic;    -- external bias resistor pin
	r0         : out   std_logic;    -- external bias resistor pin
                                         -- 1394 port 3 connections
	tpb3_n     : inout std_logic;    -- Port 3 B-
	tpb3       : inout std_logic;    -- Port 3 B+
	tpa3_n     : inout std_logic;    -- Port 3 A-
	tpa3	   : inout std_logic;    -- Port 3 A+
                                         -- 1394 port 2 connections
	tpb2_n     : inout std_logic;    -- Port 2 B-
	tpb2       : inout std_logic;    -- Port 2 B+
	tpa2_n     : inout std_logic;    -- Port 2 A-
	tpa2	   : inout std_logic;    -- Port 2 A+
                                         -- 1394 port 1 connections
	tpb1_n     : inout std_logic;    -- Port 1 B-
	tpb1       : inout std_logic;    -- Port 1 B+
	tpa1_n     : inout std_logic;    -- Port 1 A-
	tpa1	   : inout std_logic;    -- Port 1 A+
	avdd24     : in  std_logic;      -- power, usually power is from the
	avdd25     : in  std_logic;      -- power cable so we provide the pins
	avdd51     : in  std_logic;      -- power here for easy connection.
	avdd55     : in  std_logic;      -- power here for easy connection.
	dvdd4      : in  std_logic;      -- digital power
	dvdd5      : in  std_logic;      -- digital power
	dvdd6      : in  std_logic;      -- digital power
	dvdd19     : in  std_logic;      -- digital power
	dvdd20     : in  std_logic;      -- digital power
	pllvdd     : in  std_logic;      -- PLL power
	testm1     : in  std_logic;      -- connect to Vdd
	testm2     : in  std_logic       -- connect to Vdd
      );
END COMPONENT;

COMPONENT usbp11
  port (oe_n   : in std_logic;  -- Ouput enable
        rcv    : out std_logic;  -- Receive data
        vp     : out std_logic;  -- V plus
        vm     : out std_logic;  -- V minus
        suspnd : in std_logic;  -- Suspend
        speed  : in std_logic;  -- Speed
        dminus : inout std_logic;  -- D minus
        dplus  : inout std_logic;  -- D plus
        vpo    : in std_logic;  -- V plus out
        vmo    : in std_logic; -- V minus out
        gnds   : in std_logic; -- ground
        pwr    : in std_logic); -- 3.3 V
END COMPONENT;

COMPONENT max241e
  port (
	r1in   : in  std_logic;
	r2in   : in  std_logic;
	r3in   : in  std_logic;
	r4in   : in  std_logic;
	r5in   : in  std_logic;
	r1out  : out std_logic;
	r2out  : out std_logic;
	r3out  : out std_logic;
	r4out  : out std_logic;
	r5out  : out std_logic;
	t1in   : in  std_logic;
	t2in   : in  std_logic;
	t3in   : in  std_logic;
	t4in   : in  std_logic;
	t1out  : out std_logic;
	t2out  : out std_logic;
	t3out  : out std_logic;
	t4out  : out std_logic;
	shdn   : in  std_logic;
	en_n   : in  std_logic;
	-- analog pins
	c1p    : in  std_logic;
	c1m    : in  std_logic;
	c2p    : in  std_logic;
	c2m    : in  std_logic;
	vp     : in  std_logic;
	vm     : in  std_logic);
END COMPONENT;

COMPONENT ram4mx4
  PORT (SIGNAL addr:  IN    std_logic_vector(10 DOWNTO 0); -- Address
        SIGNAL data:  INOUT std_logic_vector(3 DOWNTO 0); -- Data I/O port
        SIGNAL ras_n: IN    std_logic;
        SIGNAL cas_n: IN    std_logic;
        SIGNAL oe_n:  IN    std_logic;
        SIGNAL we_n:  IN    std_logic);
END COMPONENT;

COMPONENT osc
  PORT (SIGNAL osc_out: out  std_logic;
	SIGNAL enb: in  std_logic;      -- NC on most oscillators
	SIGNAL pwr: in  std_logic;
	SIGNAL gnds: in  std_logic);
END COMPONENT;
COMPONENT osc50
  PORT (SIGNAL osc_out: out  std_logic;
	SIGNAL enb: in  std_logic;      -- NC on most oscillators
	SIGNAL pwr: in  std_logic;
	SIGNAL gnds: in  std_logic);
END COMPONENT;
COMPONENT xc17128
  PORT (SIGNAL data	: INOUT  std_logic;	-- to the First FPGAs DIN pin
	SIGNAL clk	: IN  std_logic;	-- CCLK
	SIGNAL reset_oe	: IN  std_logic;	-- PROG_N (reset is active low)
	SIGNAL ce_n	: IN  std_logic;	-- DONE_N
	SIGNAL ceo_n	: OUT std_logic;	-- To the next xc17128 CE_N
	SIGNAL vpp	: IN  std_logic;	-- MUST be connected to VCC!!!
	SIGNAL pwr	: IN  std_logic;
	SIGNAL gnds	: IN  std_logic);
END COMPONENT;
COMPONENT xchecker
  port (power : in std_logic;
        ground: in std_logic;
	-- then a space
        cclk	: inout std_logic:='Z';
        done	: inout std_logic:='Z'; -- labeled D/P	-- be sure to pullup!
        din	: inout std_logic:='Z';
        prog_n	: inout std_logic:='Z';	-- be sure to pullup!
        init_n	: inout std_logic:='Z';	-- be sure to pullup!
        rst	: inout std_logic:='Z';
	-- second row...
        rt	: inout std_logic:='Z';
        rd	: inout std_logic:='Z';
        trig	: inout std_logic:='Z';
	-- then a space
        tdi	: inout std_logic:='Z';
        tck	: inout std_logic:='Z';
        tms	: inout std_logic:='Z';
        clki	: inout std_logic:='Z';
        clko	: inout std_logic:='Z');
END COMPONENT;
COMPONENT hdr10
  port (pin1	: inout std_logic := 'Z'; -- DCL -- Altera BitBlaster signals
        pin2	: inout std_logic := 'Z'; -- GND
        pin3	: inout std_logic := 'Z'; -- CONF_DONE
        pin4	: inout std_logic := 'Z'; -- VCC (use +5v even on 3.3v parts)
        pin5	: inout std_logic := 'Z'; -- nCONFIG
        pin6	: inout std_logic := 'Z'; -- NC
        pin7	: inout std_logic := 'Z'; -- nSTATUS
        pin8	: inout std_logic := 'Z'; -- NC
        pin9	: inout std_logic := 'Z'; -- DATA0
        pin10	: inout std_logic := 'Z'); -- GND
END COMPONENT;
COMPONENT hdr40
  port (pin1	: inout std_logic;	-- NC
        pin2	: inout std_logic; -- all even pins are ground
        pin3	: inout std_logic; -- CLK
        pin4	: inout std_logic;
        pin5	: inout std_logic; -- NC - Keying pin
        pin6	: inout std_logic; -- PRIMARY GROUND!!!
        pin7	: inout std_logic; -- Channel 15
        pin8	: inout std_logic;
        pin9	: inout std_logic; -- 14
        pin10	: inout std_logic;
        pin11	: inout std_logic; -- 13
        pin12	: inout std_logic;
        pin13	: inout std_logic; -- 12 
        pin14	: inout std_logic;
        pin15	: inout std_logic; -- 11
        pin16	: inout std_logic;
        pin17	: inout std_logic; -- 10
        pin18	: inout std_logic;
        pin19	: inout std_logic; -- 9
        pin20	: inout std_logic;
        pin21	: inout std_logic; -- 8
        pin22	: inout std_logic;
        pin23	: inout std_logic; -- 7
        pin24	: inout std_logic;
        pin25	: inout std_logic; -- 6
        pin26	: inout std_logic;
        pin27	: inout std_logic; -- 5
        pin28	: inout std_logic;
        pin29	: inout std_logic; -- 4
        pin30	: inout std_logic;
        pin31	: inout std_logic; -- 3
        pin32	: inout std_logic;
        pin33	: inout std_logic; -- 2 
        pin34	: inout std_logic;
        pin35	: inout std_logic; -- 1
        pin36	: inout std_logic;
        pin37	: inout std_logic; -- Channel 0 (always LSB of a bus here)
        pin38	: inout std_logic;
        pin39	: inout std_logic; -- NC 
        pin40	: inout std_logic);
END COMPONENT;
COMPONENT hp1810
  port (pin1	: inout std_logic;	-- is connected to pin 18
        pin2	: inout std_logic;
        pin3	: inout std_logic;
        pin4	: inout std_logic;
        pin5	: inout std_logic;
        pin6	: inout std_logic;
        pin7	: inout std_logic;
        pin8	: inout std_logic; -- is connected to pin 11
        pin9	: inout std_logic; -- is connected to pin 10
        pin10	: inout std_logic;
        pin11	: inout std_logic;
        pin12	: inout std_logic;
        pin13	: inout std_logic;
        pin14	: inout std_logic;
        pin15	: inout std_logic;
        pin16	: inout std_logic;
        pin17	: inout std_logic;
        pin18	: inout std_logic);
END COMPONENT;
COMPONENT swdip8
  port (a1 : in  std_logic;  -- a1 input
        a2 : in  std_logic;  -- a2 input
        a3 : in  std_logic;  -- a3 input
        a4 : in  std_logic;  -- a4 input
        a5 : in  std_logic;  -- a5 input
        a6 : in  std_logic;  -- a6 input
        a7 : in  std_logic;  -- a7 input
        a8 : in  std_logic;  -- a8 input
        b1 : in  std_logic;  -- b1 input
        b2 : in  std_logic;  -- b2 input
        b3 : in  std_logic;  -- b3 input
        b4 : in  std_logic;  -- b4 input
        b5 : in  std_logic;  -- b5 input
        b6 : in  std_logic;  -- b6 input
        b7 : in  std_logic;  -- b7 input
        b8 : in  std_logic); -- b8 input
END COMPONENT;
COMPONENT pwr_5v
  port (pin1 : out std_logic;
        pin2 : out std_logic;
        pin3 : out std_logic);
END COMPONENT;
COMPONENT usbadual
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
        pin5 : inout std_logic;
        pin6 : inout std_logic;
        pin7 : inout std_logic;
        pin8 : inout std_logic;
	contact1 : inout std_logic;
        contact2 : inout std_logic;
        contact3 : inout std_logic;
        contact4 : inout std_logic;
	contact5 : inout std_logic;
        contact6 : inout std_logic;
        contact7 : inout std_logic;
        contact8 : inout std_logic
        );
END COMPONENT;
COMPONENT usbconnb
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
	contact1 : inout std_logic;
        contact2 : inout std_logic;
        contact3 : inout std_logic;
        contact4 : inout std_logic
        );
END COMPONENT;
COMPONENT fw_conn
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
        pin5 : inout std_logic;
        pin6 : inout std_logic;
	contact1 : inout std_logic;
        contact2 : inout std_logic;
        contact3 : inout std_logic;
        contact4 : inout std_logic;
        contact5 : inout std_logic;
        contact6 : inout std_logic
        );
END COMPONENT;
COMPONENT mic
  port (pin1 : inout std_logic:='Z';
	pin2 : inout std_logic:='Z');
END COMPONENT;
COMPONENT phone
  port (ring   : inout std_logic;	-- right
        tip    : inout std_logic;	-- left
        shield : inout std_logic);
END COMPONENT;
COMPONENT rca
  port ( tip   : inout std_logic;
        shield : inout std_logic);
END COMPONENT;
COMPONENT dsub9
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
        pin5 : inout std_logic;
        pin6 : inout std_logic;
        pin7 : inout std_logic;
        pin8 : inout std_logic;
        pin9 : inout std_logic;
        contact1 : inout std_logic;
        contact2 : inout std_logic;
        contact3 : inout std_logic;
        contact4 : inout std_logic;
        contact5 : inout std_logic;
        contact6 : inout std_logic;
        contact7 : inout std_logic;
        contact8 : inout std_logic;
        contact9 : inout std_logic);

END COMPONENT;
COMPONENT dsub25
  port (pin1 : inout std_logic;
        pin2 : inout std_logic;
        pin3 : inout std_logic;
        pin4 : inout std_logic;
        pin5 : inout std_logic;
        pin6 : inout std_logic;
        pin7 : inout std_logic;
        pin8 : inout std_logic;
        pin9 : inout std_logic;
        pin10 : inout std_logic;
        pin11 : inout std_logic;
        pin12 : inout std_logic;
        pin13 : inout std_logic;
        pin14 : inout std_logic;
        pin15 : inout std_logic;
        pin16 : inout std_logic;
        pin17 : inout std_logic;
        pin18 : inout std_logic;
        pin19 : inout std_logic;
        pin20 : inout std_logic;
        pin21 : inout std_logic;
        pin22 : inout std_logic;
        pin23 : inout std_logic;
        pin24 : inout std_logic;
        pin25 : inout std_logic;
        contact1 : inout std_logic:='Z';
        contact2 : inout std_logic:='Z';
        contact3 : inout std_logic:='Z';
        contact4 : inout std_logic:='Z';
        contact5 : inout std_logic:='Z';
        contact6 : inout std_logic:='Z';
        contact7 : inout std_logic:='Z';
        contact8 : inout std_logic:='Z';
        contact9 : inout std_logic:='Z';
        contact10 : inout std_logic:='Z';
        contact11 : inout std_logic:='Z';
        contact12 : inout std_logic:='Z';
        contact13 : inout std_logic:='Z';
        contact14 : inout std_logic:='Z';
        contact15 : inout std_logic:='Z';
        contact16 : inout std_logic:='Z';
        contact17 : inout std_logic:='Z';
        contact18 : inout std_logic:='Z';
        contact19 : inout std_logic:='Z';
        contact20 : inout std_logic:='Z';
        contact21 : inout std_logic:='Z';
        contact22 : inout std_logic:='Z';
        contact23 : inout std_logic:='Z';
        contact24 : inout std_logic:='Z';
        contact25 : inout std_logic:='Z');
END COMPONENT;
COMPONENT mii
  port (pin1 : inout std_logic:='Z';	-- +5V
        pin2 : inout std_logic:='Z';	-- MDIO
        pin3 : inout std_logic:='Z';	-- MDC
        pin4 : inout std_logic:='Z';	-- RXD(3)
        pin5 : inout std_logic:='Z';	-- RXD(2)
        pin6 : inout std_logic:='Z';	-- RXD(1)
        pin7 : inout std_logic:='Z';	-- RXD(0)
        pin8 : inout std_logic:='Z';	-- RX_DV
        pin9 : inout std_logic:='Z';	-- RX_CLK
        pin10 : inout std_logic:='Z';	-- RX_ERR
        pin11 : inout std_logic:='Z';	-- TX_ERR
        pin12 : inout std_logic:='Z';	-- TX_CLK
        pin13 : inout std_logic:='Z';	-- TX_EN
        pin14 : inout std_logic:='Z';	-- TXD(0)
        pin15 : inout std_logic:='Z';	-- TXD(1)
        pin16 : inout std_logic:='Z';	-- TXD(2)
        pin17 : inout std_logic:='Z';	-- TXD(3)
        pin18 : inout std_logic:='Z';	-- COL
        pin19 : inout std_logic:='Z';	-- CRS
        pin20 : inout std_logic:='Z';	-- +5V
        pin21 : inout std_logic:='Z';	-- +5V
        pin22 : inout std_logic:='Z';	-- pin 22-39 are all GND
        pin23 : inout std_logic:='Z';
        pin24 : inout std_logic:='Z';
        pin25 : inout std_logic:='Z';
        pin26 : inout std_logic:='Z';
        pin27 : inout std_logic:='Z';
        pin28 : inout std_logic:='Z';
        pin29 : inout std_logic:='Z';
        pin30 : inout std_logic:='Z';
        pin31 : inout std_logic:='Z';
        pin32 : inout std_logic:='Z';
        pin33 : inout std_logic:='Z';
        pin34 : inout std_logic:='Z';
        pin35 : inout std_logic:='Z';
        pin36 : inout std_logic:='Z';
        pin37 : inout std_logic:='Z';
        pin38 : inout std_logic:='Z';
        pin39 : inout std_logic:='Z';
        pin40 : inout std_logic:='Z';	-- +5V
        contact1 : inout std_logic:='Z';        -- +5V
        contact2 : inout std_logic:='Z';	-- MDIO
        contact3 : inout std_logic:='Z';	-- MDC
        contact4 : inout std_logic:='Z';	-- RXD(3)
        contact5 : inout std_logic:='Z';	-- RXD(2)
        contact6 : inout std_logic:='Z';	-- RXD(1)
        contact7 : inout std_logic:='Z';	-- RXD(0)
        contact8 : inout std_logic:='Z';	-- RX_DV
        contact9 : inout std_logic:='Z';	-- RX_CLK
        contact10 : inout std_logic:='Z';	-- RX_ERR
        contact11 : inout std_logic:='Z';	-- TX_ERR
        contact12 : inout std_logic:='Z';	-- TX_CLK
        contact13 : inout std_logic:='Z';	-- TX_EN
        contact14 : inout std_logic:='Z';	-- TXD(0)
        contact15 : inout std_logic:='Z';	-- TXD(1)
        contact16 : inout std_logic:='Z';	-- TXD(2)
        contact17 : inout std_logic:='Z';	-- TXD(3)
        contact18 : inout std_logic:='Z';	-- COL
        contact19 : inout std_logic:='Z';	-- CRS
        contact20 : inout std_logic:='Z';	-- +5V
        contact21 : inout std_logic:='Z';	-- +5V
        contact22 : inout std_logic:='Z';	-- contact 22-39 are all GND
        contact23 : inout std_logic:='Z';
        contact24 : inout std_logic:='Z';
        contact25 : inout std_logic:='Z';
        contact26 : inout std_logic:='Z';
        contact27 : inout std_logic:='Z';
        contact28 : inout std_logic:='Z';
        contact29 : inout std_logic:='Z';
        contact30 : inout std_logic:='Z';
        contact31 : inout std_logic:='Z';
        contact32 : inout std_logic:='Z';
        contact33 : inout std_logic:='Z';
        contact34 : inout std_logic:='Z';
        contact35 : inout std_logic:='Z';
        contact36 : inout std_logic:='Z';
        contact37 : inout std_logic:='Z';
        contact38 : inout std_logic:='Z';
        contact39 : inout std_logic:='Z';
        contact40 : inout std_logic:='Z');	-- +5V
END COMPONENT;
COMPONENT tfds3000
  port (ired_c : inout std_logic;  -- IRED cathode
        rxd    : out std_logic;  -- Receive data
        pwr    : in  std_logic;  -- Vcc range (3 to 5.5 V)
        gnds   : in  std_logic;  -- Ground
        sd     : in  std_logic;  -- Shut down
        txd    : in  std_logic;  -- Transmit data
        ired_a : in  std_logic); -- IRED anode
END COMPONENT;
COMPONENT xtal
  port (a : in  std_logic;  -- a input
        z : out std_logic); -- z output
end component;
COMPONENT res1206
  port (a : in  std_logic;  -- a input
        z : inout std_logic); -- z output
end component;
COMPONENT open1206
  port (a : in  std_logic;  -- a input
        z : inout std_logic); -- z output
end component;
COMPONENT sres1206
  port (a : inout std_logic;  -- a
        b : inout std_logic); -- b
end component;
COMPONENT cap_tant
  port (plus  : inout std_logic;  -- If it's a polarized, cap, then this is the +
        minus : inout std_logic);
end component;
COMPONENT cap_2pin
  port (plus  : inout std_logic;  -- If it's a polarized, cap, then this is the +
        minus : inout std_logic);
end component;
COMPONENT cap1206
  port (plus  : inout std_logic;  -- If it's a polarized, cap, then this is the +
        minus : inout std_logic);
end component;
COMPONENT led10
  port (a1   : inout std_logic;
        a2   : inout std_logic;
        a3   : inout std_logic;
        a4   : inout std_logic;
        a5   : inout std_logic;
        a6   : inout std_logic;
        a7   : inout std_logic;
        a8   : inout std_logic;
        a9   : inout std_logic;
        a10  : inout std_logic;
        c1   : inout std_logic;
        c2   : inout std_logic;
        c3   : inout std_logic;
        c4   : inout std_logic;
        c5   : inout std_logic;
        c6   : inout std_logic;
        c7   : inout std_logic;
        c8   : inout std_logic;
        c9   : inout std_logic;
        c10  : inout std_logic);
end component;
COMPONENT diode
  port (anode   : in  std_logic;
        cathode : in std_logic);
end component;
COMPONENT induct
  port (pin1 : inout std_logic;
        pin2 : inout std_logic);
end component;
COMPONENT fuse
  port (pin1 : inout std_logic;
        pin2 : inout std_logic);
end component;
COMPONENT fet
  port (g : in std_logic;
        d : inout std_logic;
        s : inout std_logic);
end component;
COMPONENT spst
  PORT (SIGNAL sw_out: out std_logic;   -- output
	SIGNAL sw_in : IN  std_logic);  -- input
end component;
COMPONENT spdt
  PORT (SIGNAL sw_left: out std_logic;	-- output
        SIGNAL sw_right: out std_logic;	-- output
	SIGNAL sw_in : IN  std_logic);  -- input
end component;
COMPONENT ldo_reg
  PORT (SIGNAL lbf	: out std_logic;  -- low battery flag
        SIGNAL sc	: IN std_logic;  -- Shutdown Control (tie to gnd)
        SIGNAL vin   	: IN std_logic;  -- Vin = 5-30V
        SIGNAL nc	: out std_logic;  -- No-Connect
        SIGNAL vout   	: OUT std_logic; -- Vout = 3.3V @ 300ma
        SIGNAL dc   	: out std_logic;  -- Do Not Connect
        SIGNAL gnd   	: IN std_logic;  -- ground
        SIGNAL spg  	: IN std_logic); -- Shaping (10pF to vout required)
end COMPONENT;
COMPONENT plcc20th
  port (pin1	: inout std_logic := 'Z'; -- TDO - Altera EPC1 pinout
        pin2	: inout std_logic := 'Z'; -- DATA
        pin3	: inout std_logic := 'Z'; -- TCK
        pin4	: inout std_logic := 'Z'; -- DCLK
        pin5	: inout std_logic := 'Z'; -- VCC5
        pin6	: inout std_logic := 'Z'; -- NC
        pin7	: inout std_logic := 'Z'; -- NC
        pin8	: inout std_logic := 'Z'; -- OE
        pin9	: inout std_logic := 'Z'; -- nCS
        pin10	: inout std_logic := 'Z'; -- GND
        pin11	: inout std_logic := 'Z'; -- TDI
        pin12	: inout std_logic := 'Z'; -- nCASC
        pin13	: inout std_logic := 'Z'; -- nINIT/CONF
        pin14	: inout std_logic := 'Z'; -- VPP5
        pin15	: inout std_logic := 'Z'; -- NC
        pin16	: inout std_logic := 'Z'; -- NC
        pin17	: inout std_logic := 'Z'; -- NC
        pin18	: inout std_logic := 'Z'; -- VPP
        pin19	: inout std_logic := 'Z'; -- TMS
        pin20	: inout std_logic := 'Z'); -- VCC
END COMPONENT;
COMPONENT zeroohm
  port (pin1 : in std_logic;
        pin2 : out std_logic);
END COMPONENT;
COMPONENT hdr20
  port (pin1	: inout std_logic := 'Z'; -- +5V
        pin2	: inout std_logic := 'Z'; -- CLK2
        pin3	: inout std_logic := 'Z'; -- CLK1
        pin4	: inout std_logic := 'Z'; -- D15
        pin5	: inout std_logic := 'Z'; -- D14
        pin6	: inout std_logic := 'Z'; -- D13
        pin7	: inout std_logic := 'Z'; -- D12
        pin8	: inout std_logic := 'Z'; -- D11
        pin9	: inout std_logic := 'Z'; -- D10
        pin10	: inout std_logic := 'Z';
        pin11	: inout std_logic := 'Z'; -- D8
        pin12	: inout std_logic := 'Z';
        pin13	: inout std_logic := 'Z'; -- D6
        pin14	: inout std_logic := 'Z';
        pin15	: inout std_logic := 'Z'; -- D4
        pin16	: inout std_logic := 'Z';
        pin17	: inout std_logic := 'Z'; -- D2
        pin18	: inout std_logic := 'Z'; -- D1
        pin19	: inout std_logic := 'Z'; -- D0
        pin20	: inout std_logic := 'Z'); -- GND
END COMPONENT;

SIGNAL vcc,gnd	: std_logic;	-- power planes
SIGNAL al_mode,al_init_done, al_conf_done, al_nstatus, al_data0, al_dclk, al_nconfig,al_conf_done_led : std_logic; -- altera config pins
SIGNAL xc_mode,xc_init_n, xc_done, xc_prog_n, xc_din, xc_cclk : std_logic; -- xilinx config pins
SIGNAL al_ua2 : std_logic; -- Altera config pins
SIGNAL xc_ux2,xc_ux3, xc_ux4, xc_ux5, xc_ux6 : std_logic; -- xilinx config pins
SIGNAL xc_done_led : std_logic; -- xilinx config pins
SIGNAL a_vref,a_vref_f,a_x1_1,a_x1_2 : std_logic; -- ad1848 pins
SIGNAL l_mic, a_l_mic,a_l_mic_ac,a_l_mic_acres : std_logic; -- ad1848 pins
SIGNAL a_l_mic_amp,a_vref_buf : std_logic; -- ad1848 pins
SIGNAL a_l_out,a_r_out,a_l_out_div,a_r_out_div : std_logic; -- ad1848 pins
SIGNAL a_l_filt,a_r_filt : std_logic; -- ad1848 pins
SIGNAL usba1_pwron, usba2_pwron, usba3_pwron,usba4_pwron, usba5_pwron, usba6_pwron : std_logic; -- USB power FETs
SIGNAL fat_etch_usb1_pwr, fat_etch_usb2_pwr,fat_etch_usb3_pwr,fat_etch_usb4_pwr,fat_etch_usb5_pwr,fat_etch_usb6_pwr : std_logic;
SIGNAL fat_etch_usb1_sw, fat_etch_usb2_sw,fat_etch_usb3_sw,fat_etch_usb4_sw,fat_etch_usb5_sw,fat_etch_usb6_sw : std_logic;
SIGNAL fat_etch_fw_cpwr, fw_cpwr_res : std_logic;
SIGNAL fw_cna : std_logic;
SIGNAL fat_etch_usbb_fuse, fat_etch_usbb_pwr : std_logic;
SIGNAL fw_filter, fw_filter_res	: std_logic;	-- FireWire ctl
SIGNAL fw_vt_bias1, fw_vt_bias2, fw_vt_bias3	: std_logic;	-- FireWire ctl
SIGNAL fw_vt1, fw_vt2, fw_vt3, fw_pullup, fw_pulldown	: std_logic;	-- FireWire ctl
SIGNAL fw_lockon_res,fw_r1,fw_r0	: std_logic;	-- FireWire ctl
SIGNAL fw_x1,fw_x2	: std_logic;	-- FireWire TI chip Crystal
SIGNAL i_txd, i_sd, i_rxd	: std_logic;	-- IrDA ctl
SIGNAL i_red_a, i_pwr	: std_logic;	-- IrDA ctl
SIGNAL max_c1p,max_c1m,max_c2p,max_c2m,max_vp,max_vm	: std_logic;	-- RS232 analog signals
SIGNAL rs232_rxd, rs232_rxd2, rs232_txd, rs232_txd2: std_logic; -- rs232 signals
SIGNAL rs232_rts, rs232_cts, rs232_dsr, rs232_dtr: std_logic; -- rs232 signals
SIGNAL u_rx1, u_rx2, u_tx1, u_tx2: std_logic; -- UART signals
SIGNAL pp_data_pre : std_logic_vector(8 downto 1); -- P1284 parallel port
SIGNAL pp_strobe_pre_n : std_logic; -- P1284 parallel port
SIGNAL a_addr : std_logic_vector(1 downto 0); -- Audio CODEC signals
SIGNAL a_data : std_logic_vector(7 downto 0); -- Audio CODEC signals
SIGNAL a_cs_n, a_rd_n, a_wr_n : std_logic; -- Audio CODEC signals
SIGNAL mii_bus	: std_logic_vector(19 downto 2);	-- MII connector
SIGNAL led	: std_logic_vector(9 downto 0);	-- led bar
SIGNAL fat_etch_xil_3v	: std_logic;	-- 3.3 Volts to the Xilinx FPGA
SIGNAL fat_etch_alt_3v	: std_logic;	-- 3.3 Volts to the ALtera FPGA
SIGNAL fat_etch_usb_3v	: std_logic;	-- 3.3 Volts to the USB transceivers
SIGNAL fat_etch_fw_3v	: std_logic;	-- 3.3 Volts for firewire
SIGNAL gclk0,clk_fw	: std_logic;	-- global clocks
SIGNAL pull_up,pulldn,pulldn1,pulldn2,pulldn3	: std_logic;	-- logic 1,0
SIGNAL reset_n	: std_logic;	-- active low reset
SIGNAL single_point_net	: std_logic_vector(0 to 9); -- name says it all...
SIGNAL ee_clk, ee_sda, ee_wp	: std_logic;	-- I2C EEPROM
SIGNAL eeprom_a2	: std_logic;	-- I2C EEPROM
SIGNAL r_data	: std_logic_vector(15 downto 0);	-- SRAM
SIGNAL r_addr	: std_logic_vector(16 downto 0);	-- SRAM
SIGNAL r_ce_n, r_oe_n, r_wel_n, r_weh_n	: std_logic; -- SRAM
signal usb_B_J9_cpwr     : std_logic;
signal usb_B_J9_dminus   : std_logic;  -- usb channel 0
signal usb_B_J9_dplus    : std_logic;  -- usb channel 0
signal usb_B_J9_cgnd     : std_logic;
signal usb_A_J10_cpwr    : std_logic;
signal usb_A_J10_dminus  : std_logic; -- usb channel 1
signal usb_A_J10_dplus   : std_logic; -- usb channel 1
signal usb_A_J10_cgnd    : std_logic;
signal usb_A_J11_cpwr    : std_logic;
signal usb_A_J11_dminus  : std_logic; -- usb channel 2
signal usb_A_J11_dplus   : std_logic; -- usb channel 2
signal usb_A_J11_cgnd    : std_logic;
signal usb_A_J12_cpwr    : std_logic;
signal usb_A_J12_dminus  : std_logic; -- usb channel 3
signal usb_A_J12_dplus   : std_logic; -- usb channel 3
signal usb_A_J12_cgnd    : std_logic;
signal usb_A_J10_cpwr4   : std_logic;
signal usb_A_J10_dminus4 : std_logic; -- usb channel 4
signal usb_A_J10_dplus4  : std_logic; -- usb channel 4
signal usb_A_J10_cgnd4   : std_logic;
signal usb_A_J11_cpwr5   : std_logic;
signal usb_A_J11_dminus5 : std_logic; -- usb channel 5
signal usb_A_J11_dplus5  : std_logic; -- usb channel 5
signal usb_A_J11_cgnd5   : std_logic;
signal usb_A_J12_cpwr6   : std_logic;
signal usb_A_J12_dminus6 : std_logic; -- usb channel 6
signal usb_A_J12_dplus6  : std_logic; -- usb channel 6
signal usb_A_J12_cgnd6   : std_logic;
SIGNAL usbb_dplus_con,usbb_dminus_con,usba1_dplus_con,usba1_dminus_con,usba2_dplus_con,usba2_dminus_con,usba3_dplus_con,usba3_dminus_con: std_logic;	-- USB ctl
SIGNAL usba4_dplus_con,usba4_dminus_con,usba5_dplus_con,usba5_dminus_con,usba6_dplus_con,usba6_dminus_con: std_logic;	-- USB ctl
SIGNAL usbb_host1,usbb_host2,usbb_low,usbb_high: std_logic;-- USB ctl
SIGNAL usbb_oe_n,usbb_rcv,usbb_vp,usbb_vm,usbb_speed,usbb_vpo,usbb_vmo: std_logic;-- USB ctl
SIGNAL usba1_rcv,usba1_vp,usba1_vm,usba1_speed,usba1_vpo,usba1_vmo: std_logic;-- USB ctl
SIGNAL usba2_rcv,usba2_vp,usba2_vm,usba2_speed,usba2_vpo,usba2_vmo: std_logic;-- USB ctl
SIGNAL usba3_rcv,usba3_vp,usba3_vm,usba3_speed,usba3_vpo,usba3_vmo: std_logic;-- USB ctl
signal epc2_tck,epc2_tdi,epc2_tdo,epc2_tms  : std_logic; -- JTAG 
signal tck,tdi,tdo,tms  : std_logic; -- JTAG 
signal tck_conn,tdi_conn,tdo_conn,tms_conn  : std_logic; -- JTAG 
signal xil_ldo_spg  : std_logic; -- Xilinx 3.3v regulator signal
signal alt_ldo_spg  : std_logic; -- altera 3.3v regulator signal
signal fw_ldo_spg  : std_logic; -- FW  regulator signal
signal usb_ldo_spg  : std_logic; -- USB regulator signal
signal ram16_ce,ram32_ce  : std_logic; -- USB regulator signal
signal clk_cpu	: std_logic; -- Async processor clock, usually 12mhz
signal clk_usb	: std_logic; -- 48MHz oscilator for USB DPLL
signal clk_fclk1	: std_logic; -- local clock 
signal clk_vid	: std_logic; -- video clock
signal avail	: std_logic_vector(4 downto 0); -- available pins on the FPGAs
signal fw_phy	: std_logic_vector(8 downto 0); -- V1394 PHY interface
signal vid	: std_logic_vector(15 downto 0); -- video interface
signal vid_qclk	: std_logic; -- video interface
signal video	: std_logic_vector(8 downto 0); -- video interface
signal vid_pulldn,vid_pullup, vid_agccap, vid_clevel	: std_logic; -- video interface
signal vid_ref,video_in, video_in_ac, video_out	: std_logic; -- video interface
signal vid_syncdet,vid_yin,vid_ccvalid	: std_logic; -- video interface
signal fw_tpa1          : std_logic; -- 1394 channel 1 -- TI chip
signal fw_tpa1_n	: std_logic; -- 1394 channel 1
signal fw_tpb1          : std_logic; -- 1394 channel 1
signal fw_tpb1_n	: std_logic; -- 1394 channel 1
signal fw_tpa2          : std_logic; -- 1394 channel 2 -- TI chip
signal fw_tpa2_n	: std_logic; -- 1394 channel 2
signal fw_tpb2          : std_logic; -- 1394 channel 2
signal fw_tpb2_n	: std_logic; -- 1394 channel 2
signal fw_tpa3          : std_logic; -- 1394 channel 3 -- TI chip
signal fw_tpa3_n	: std_logic; -- 1394 channel 3
signal fw_tpb3          : std_logic; -- 1394 channel 3
signal fw_tpb3_n	: std_logic; -- 1394 channel 3

-- IEEE 1284 PC Parallel Port interface (signal names are "compatible" names)
signal pp_strobe_n	: std_logic;
signal pp_data  	: std_logic_vector(8 downto 1);
signal pp_ack_n         : std_logic;
signal pp_busy          : std_logic;
signal pp_error 	: std_logic;
signal pp_select	: std_logic;
signal pp_autofd_n	: std_logic;
signal pp_fault_n	: std_logic;
signal pp_init_n	: std_logic;
signal pp_selectin_n    : std_logic;

BEGIN	----------------------------------------------------------------

-- Perform signal assignments for hub testbench outputs.
  power_dp <= "0000000000000" & usba3_pwron & usba2_pwron & usba1_pwron;
  speed_dp <= "0000000000000" & usba3_speed & usba2_speed & usba1_speed;
  
UXIL1: xil240hq
	PORT MAP (
	clk_cpu    	 => clk_cpu    	,
	clk48mhz 	 => clk_usb 	,
	clk_1394 	 => gclk0 	,
	clk_xtra 	 => clk_fw 	,
	clk_fclk1 	 => clk_fclk1 	,
	reset_n 	 => reset_n 	,
    -- P1284 parallel port interface
	pp_data  	 => pp_data  	,
	pp_strobe_n  => pp_strobe_n ,
	pp_init_n	 => pp_init_n	,
	pp_autofd_n	 => pp_autofd_n	,
	pp_selectin_n => pp_selectin_n,
	pp_ack_n	 => pp_ack_n	,
	pp_busy	 => pp_busy	,
	pp_error	 => pp_error	,
	pp_select	 => pp_select	,
	pp_fault_n	 => pp_fault_n	,
    -- Audio Codec interface (ad1845)
	a_addr   	 => a_addr   	,
	a_data  	 => a_data  	,
	a_wr_n	 => a_wr_n	,
	a_rd_n	 => a_rd_n	,
	a_cs_n	 => a_cs_n	,
    -- UART interface
	u_rx1	 => u_rx1	,
	u_rx2	 => u_rx2	,
	u_tx1   	 => u_tx1   	,
	u_tx2   	 => u_tx2   	,
    -- SRAM interface
	r_addr 	 => r_addr 	,
	r_data 	 => r_data 	,
	r_ce_n 	 => r_ce_n 	,
	r_oe_n 	 => r_oe_n 	,
	r_wel_n 	 => r_wel_n 	,
	r_weh_n 	 => r_weh_n 	,
    -- Serial EEPROM interface
	ee_sda 	 => ee_sda 	,
	ee_clk 	 => ee_clk 	,
	ee_wp 	 => ee_wp 	,
    -- IrDA interface
	i_rxd	 => i_rxd	,
	i_sd	 => i_sd	,
	i_txd	 => i_txd	,
    -- USB B connector interface
	usbb_dplus 	 => usbb_dplus 	,
	usbb_dminus	 => usbb_dminus	,
	usbb_rcv	 => usbb_rcv	,
	usbb_vp	 => usbb_vp	,
	usbb_vm	 => usbb_vm	,
	usbb_oe_n	 => usbb_oe_n	,
	usbb_speed	 => usbb_speed	,
	usbb_vpo	 => usbb_vpo	,
	usbb_vmo	 => usbb_vmo	,
	usbb_low	 => usbb_low	,
	usbb_high	 => usbb_high	,
	usbb_host1	 => usbb_host1	,
	usbb_host2	 => usbb_host2	,
    -- USB A connector #1 interface - also used for host mode
	usba1_dplus	 => usba1_dplus	,
	usba1_dminus => usba1_dminus,
	usba1_rcv	 => usba1_rcv	,
	usba1_vp	 => usba1_vp	,
	usba1_vm	 => usba1_vm	,
	usba1_oe_n	 => usba1_oe_n	,
	usba1_speed	 => usba1_speed	,
	usba1_vpo	 => usba1_vpo	,
	usba1_vmo	 => usba1_vmo	,
	usba1_pwron	 => usba1_pwron	,
    -- USB A connector #2 interface
	usba2_dplus	 => usba2_dplus	,
	usba2_dminus => usba2_dminus,
	usba2_rcv	 => usba2_rcv	,
	usba2_vp	 => usba2_vp	,
	usba2_vm	 => usba2_vm	,
	usba2_oe_n	 => usba2_oe_n	,
	usba2_speed	 => usba2_speed	,
	usba2_vpo	 => usba2_vpo	,
	usba2_vmo	 => usba2_vmo	,
	usba2_pwron	 => usba2_pwron	,
    -- USB A connector #3 interface
	usba3_dplus	 => usba3_dplus	,
	usba3_dminus => usba3_dminus,
	usba3_rcv	 => usba3_rcv	,
	usba3_vp	 => usba3_vp	,
	usba3_vm	 => usba3_vm	,
	usba3_oe_n	 => usba3_oe_n	,
	usba3_speed	 => usba3_speed	,
	usba3_vpo	 => usba3_vpo	,
	usba3_vmo	 => usba3_vmo	,
	usba3_pwron	 => usba3_pwron	,
    -- USB A connector #4 interface
	usba4_dplus	=> usba4_dplus,
	usba4_dminus 	=> usba4_dminus,
	usba4_pwron	=> usba4_pwron	,
    -- USB A connector #5 interface
	usba5_dplus	=> usba5_dplus,
	usba5_dminus 	=> usba5_dminus,
	usba5_pwron	=> usba5_pwron	,
    -- USB A connector #6 interface
	usba6_dplus	=> usba6_dplus,
	usba6_dminus 	=> usba6_dminus,
	usba6_pwron	=> usba6_pwron	,
    -- 1394 Firewire PHY interface
	fw_phy 	 => fw_phy 	,
    -- LED indicator
	led 	 => led 	,
    -- Expansion connector (pinned out for MII compatiblity)
	mii 	 => mii_bus 	,
    -- Video connector
	video 	 => video 	,
    -- Available pins...
	avail 	 => avail	,
    -- Xilinx configuration pins
	m0           => xc_mode,	-- serial download (slave)
	m1           => xc_mode,	-- or serial master from PROMs
	m2           => xc_mode,
	init_n       => xc_init_n      ,
	done         => xc_done        ,
	prog_n       => xc_prog_n      ,
	din          => xc_din         ,
	dout         => OPEN        ,	-- no cascading of devices
	cclk         => xc_cclk        ,
	tck          => tck         ,
	tms          => tms         ,
	tdi          => tdi         ,
	tdo          => tdo         ,
    -- power pins (GND pins are done as an attribute)
	vcc19	 => fat_etch_xil_3v	,
	vcc30	 => fat_etch_xil_3v	,
	vcc40	 => fat_etch_xil_3v	,
	vcc61	 => fat_etch_xil_3v	,
	vcc80	 => fat_etch_xil_3v	,
	vcc90	 => fat_etch_xil_3v	,
	vcc101	 => fat_etch_xil_3v	,
	vcc121	 => fat_etch_xil_3v	,
	vcc140	 => fat_etch_xil_3v	,
	vcc150	 => fat_etch_xil_3v	,
	vcc161	 => fat_etch_xil_3v	,
	vcc180	 => fat_etch_xil_3v	,
	vcc201	 => fat_etch_xil_3v	,
	vcc212	 => fat_etch_xil_3v	,
	vcc222	 => fat_etch_xil_3v	,
	vcc240	 => fat_etch_xil_3v);

UXIL11: xc17128 PORT MAP (	-- xilinx config proms
	data	=> xc_din,	-----------!!! 3.3V PARTS !!!------------
	clk	=> xc_cclk,
	reset_oe=> xc_prog_n,
	ce_n	=> xc_done,
	ceo_n	=> xc_ux2,
	vpp	=> fat_etch_xil_3v, pwr	=> fat_etch_xil_3v, gnds	=> gnd);
UXIL12: xc17128 PORT MAP (
	data	=> xc_din,
	clk	=> xc_cclk,
	reset_oe=> xc_prog_n,
	ce_n	=> xc_ux2,
	ceo_n	=> xc_ux3,
	vpp	=> fat_etch_xil_3v, pwr	=> fat_etch_xil_3v, gnds	=> gnd);
UXIL13: xc17128 PORT MAP (
	data	=> xc_din,
	clk	=> xc_cclk,
	reset_oe=> xc_prog_n,
	ce_n	=> xc_ux3,
	ceo_n	=> xc_ux4,
	vpp	=> fat_etch_xil_3v, pwr	=> fat_etch_xil_3v, gnds	=> gnd);
UXIL14: xc17128 PORT MAP (
	data	=> xc_din,
	clk	=> xc_cclk,
	reset_oe=> xc_prog_n,
	ce_n	=> xc_ux4,
	ceo_n	=> xc_ux5,
	vpp	=> fat_etch_xil_3v, pwr	=> fat_etch_xil_3v, gnds	=> gnd);
UXIL15: xc17128 PORT MAP (
	data	=> xc_din,
	clk	=> xc_cclk,
	reset_oe=> xc_prog_n,
	ce_n	=> xc_ux5,
	ceo_n	=> xc_ux6,
	vpp	=> fat_etch_xil_3v, pwr	=> fat_etch_xil_3v, gnds	=> gnd);
UXIL16: xc17128 PORT MAP (
	data	=> xc_din,
	clk	=> xc_cclk,
	reset_oe=> xc_prog_n,
	ce_n	=> xc_ux6,
	ceo_n	=> OPEN,
	vpp	=> fat_etch_xil_3v, pwr	=> fat_etch_xil_3v, gnds	=> gnd);

UALT1: a10k240
	PORT MAP (
	clk48mhz    	 => clk_usb    	,
	gclk0 	 => gclk0 	,
	gclk1 	 => clk_cpu 	,
	gclk2 	 => clk_fw 	,
	gclk3 	 => clk_fclk1 	,
	gclk0_out 	 => gclk0 	,
	gclk1_out 	 => clk_cpu 	,
	gclk2_out 	 => clk_fw 	,
	reset_n 	 => reset_n 	,
    -- P1284 parallel port interface
	pp_data  	 => pp_data,
	pp_strobe_n  => pp_strobe_n ,
	pp_init_n	 => pp_init_n	,
	pp_autofd_n	 => pp_autofd_n	,
	pp_selectin_n => pp_selectin_n,
	pp_ack_n	 => pp_ack_n	,
	pp_busy	 => pp_busy	,
	pp_error	 => pp_error	,
	pp_select	 => pp_select	,
	pp_fault_n	 => pp_fault_n	,
    -- Audio Codec interface (ad1845)
	a_addr   	 => a_addr   	,
	a_data  	 => a_data  	,
	a_wr_n	 => a_wr_n	,
	a_rd_n	 => a_rd_n	,
	a_cs_n	 => a_cs_n	,
    -- UART interface
	u_rx1	 => u_rx1	,
	u_rx2	 => u_rx2	,
	u_tx1   	 => u_tx1   	,
	u_tx2   	 => u_tx2   	,
    -- SRAM interface
	r_addr 	 => r_addr 	,
	r_data 	 => r_data 	,
	r_ce_n 	 => r_ce_n 	,
	r_oe_n 	 => r_oe_n 	,
	r_wel_n 	 => r_wel_n 	,
	r_weh_n 	 => r_weh_n 	,
    -- Serial EEPROM interface
	ee_sda 	 => ee_sda 	,
	ee_clk 	 => ee_clk 	,
	ee_wp 	 => ee_wp 	,
    -- USB B connector interface
	usbb_dplus 	 => usbb_dplus 	,
	usbb_dminus	 => usbb_dminus	,
	usbb_rcv	 => usbb_rcv	,
	usbb_vp	 => usbb_vp	,
	usbb_vm	 => usbb_vm	,
	usbb_oe_n	 => usbb_oe_n	,
	usbb_speed	 => usbb_speed	,
	usbb_vpo	 => usbb_vpo	,
	usbb_vmo	 => usbb_vmo	,
	usbb_low	 => usbb_low	,
	usbb_high	 => usbb_high	,
	usbb_host1	 => usbb_host1	,
	usbb_host2	 => usbb_host2	,
    -- USB A connector #1 interface - also used for host mode
	usba1_dplus	 => usba1_dplus	,
	usba1_dminus => usba1_dminus,
	usba1_rcv	 => usba1_rcv	,
	usba1_vp	 => usba1_vp	,
	usba1_vm	 => usba1_vm	,
	usba1_oe_n	 => usba1_oe_n	,
	usba1_speed	 => usba1_speed	,
	usba1_vpo	 => usba1_vpo	,
	usba1_vmo	 => usba1_vmo	,
	usba1_pwron	 => usba1_pwron	,
    -- USB A connector #2 interface
	usba2_dplus	 => usba2_dplus	,
	usba2_dminus => usba2_dminus,
	usba2_rcv	 => usba2_rcv	,
	usba2_vp	 => usba2_vp	,
	usba2_vm	 => usba2_vm	,
	usba2_oe_n	 => usba2_oe_n	,
	usba2_speed	 => usba2_speed	,
	usba2_vpo	 => usba2_vpo	,
	usba2_vmo	 => usba2_vmo	,
	usba2_pwron	 => usba2_pwron	,
    -- USB A connector #3 interface
	usba3_dplus	 => usba3_dplus	,
	usba3_dminus => usba3_dminus,
	usba3_rcv	 => usba3_rcv	,
	usba3_vp	 => usba3_vp	,
	usba3_vm	 => usba3_vm	,
	usba3_oe_n	 => usba3_oe_n	,
	usba3_speed	 => usba3_speed	,
	usba3_vpo	 => usba3_vpo	,
	usba3_vmo	 => usba3_vmo	,
	usba3_pwron	 => usba3_pwron	,
    -- USB A connector #4 interface
	usba4_dplus	=> usba4_dplus	,
	usba4_dminus 	=> usba4_dminus,
	usba4_pwron	=> usba4_pwron	,
    -- USB A connector #5 interface
	usba5_dplus	=> usba5_dplus	,
	usba5_dminus 	=> usba5_dminus,
	usba5_pwron	=> usba5_pwron	,
    -- USB A connector #6 interface
	usba6_dplus	=> usba6_dplus	,
	usba6_dminus 	=> usba6_dminus,
	usba6_pwron	=> usba6_pwron	,
    -- LED indicator
	led 	 => led 	,
    -- Expansion connector (pinned out for MII compatiblity)
	mii 	 => mii_bus 	,
    -- Firewire
	fw_phy 	 => fw_phy 	,
    -- available pins
	avail 	 => avail(1 downto 0) 	,
    -- altera configuration pins
	msel0        => al_mode,
	msel1        => al_mode,	-- or serial master from PROMs
	nconfig      => al_nconfig,
	init_done    => al_init_done,
	conf_done    => al_conf_done,
	nstatus      => al_nstatus,
	data0        => al_data0,
	nce          => gnd ,
	dclk         => al_dclk ,
	nceo         => open ,
	tcki         => tck    ,
	tcko         => tck    ,
	tms          => tms    ,
	tdi          => tdi    ,
	tdo          => tdo    ,
    -- power pins (GND pins are done as an attribute)
	vcc5 	 => fat_etch_alt_3v	,
	vcc16	 => fat_etch_alt_3v	,
	vcc27	 => fat_etch_alt_3v	,
	vcc37	 => fat_etch_alt_3v	,
	vcc47	 => fat_etch_alt_3v	,
	vcc57	 => fat_etch_alt_3v	,
	vcc77	 => fat_etch_alt_3v	,
	vcc89	 => fat_etch_alt_3v	,
	vcc96	 => fat_etch_alt_3v	,
	vcc112	 => fat_etch_alt_3v	,
	vcc122	 => fat_etch_alt_3v	,
	vcc130	 => fat_etch_alt_3v	,
	vcc140	 => fat_etch_alt_3v	,
	vcc150	 => fat_etch_alt_3v	,
	vcc160	 => fat_etch_alt_3v	,
	vcc170	 => fat_etch_alt_3v	,
	vcc189	 => fat_etch_alt_3v	,
	vcc205	 => fat_etch_alt_3v	,
	vcc224	 => fat_etch_alt_3v);

UALT11: xc17128 PORT MAP (	-- Altera config proms
	data	=> al_data0,	-- The EPC1 has the same pinout as the xilinx
	clk	=> al_dclk,	-- XC17128 so we reuse the Entity here...
	reset_oe=> al_nstatus,
	ce_n	=> al_conf_done,
	ceo_n	=> al_ua2,
	vpp	=> vcc, pwr	=> vcc, gnds	=> gnd);
UALT12: xc17128 PORT MAP (	-- 2 EPC1s are required for a 10K100
	data	=> al_data0,
	clk	=> al_dclk,
	reset_oe=> al_nstatus,
	ce_n	=> al_ua2,
	ceo_n	=> open,
	vpp	=> vcc, pwr	=> vcc, gnds	=> gnd);
UALT13: plcc20th		-- 1 EPC2 is required for a 10K100
  port map (pin1	=> epc2_tdo, -- TDO
        pin2	=> al_data0,	-- DATA
        pin3	=> epc2_tck,	-- TCK
        pin4	=> al_dclk, 	-- DCLK
        pin5	=> gnd,		-- VCC5
        pin6	=> open,	-- NC
        pin7	=> open,	-- NC
        pin8	=> al_nstatus,	-- OE
        pin9	=> al_conf_done, -- nCS
        pin10	=> gnd,
        pin11	=> epc2_tdi, -- TDI
        pin12	=> open, -- nCASC
        pin13	=> al_nconfig, -- nINIT/CONF
        pin14	=> gnd, -- VPP5
        pin15	=> open,
        pin16	=> open,
        pin17	=> open,
        pin18	=> vcc, -- VPP
        pin19	=> epc2_tms, -- TMS
        pin20	=> vcc); -- VCC
JALT13: hdr10 port map (
  	pin1	=> epc2_tck,
        pin2	=> gnd,
        pin3	=> epc2_tdo,
        pin4	=> vcc,
        pin5	=> epc2_tms,
        pin6	=> open,
        pin7	=> open,
        pin8	=> open,
        pin9	=> epc2_tdi,
        pin10	=> gnd);
RALT13: res1206 port map ( a => vcc, z => epc2_tck);	-- 1K pullup
RALT14: res1206 port map ( a => vcc, z => epc2_tdo);	-- 1K pullup
RALT15: res1206 port map ( a => vcc, z => epc2_tms);	-- 1K pullup
RALT16: res1206 port map ( a => vcc, z => epc2_tdi);	-- 1K pullup


-------------------------------------------------------------------------------
-- IEEE 1284 (PC parallel port) pullup and series resistors
-- The discretes below were derived from table C4 on page 95 of the
-- IEEE 1284-1994 standard
--                                         +--R92-4.7K-->VCC
--                                         |
--                  <----------------------+---------->pp_selectin_n
--
--                                         +--R91-4.7K-->VCC
--                                         |,
--                  <----------------------+---------->pp_autofd_n
--
--                                         +--R90-4.7K-->VCC
--                                         |
--                  <----------------------+---------->pp_init_n
--
--                                         +--R89-4.7K-->VCC
--                                         |
--     pp_strobe_pre_n<----------R80-33ohm--+---------->pp_strobe_n
--
--     pp_data_pre(1:8)<------R81-R88-33ohm------------->pp_data
--
RP01 : sres1206 port map ( a => pp_data_pre(1), b => pp_data(1));-- 33 ohm
RP02 : sres1206 port map ( a => pp_data_pre(2), b => pp_data(2));-- 33 ohm
RP03 : sres1206 port map ( a => pp_data_pre(3), b => pp_data(3));-- 33 ohm
RP04 : sres1206 port map ( a => pp_data_pre(4), b => pp_data(4));-- 33 ohm
RP05 : sres1206 port map ( a => pp_data_pre(5), b => pp_data(5));-- 33 ohm
RP06 : sres1206 port map ( a => pp_data_pre(6), b => pp_data(6));-- 33 ohm
RP07 : sres1206 port map ( a => pp_data_pre(7), b => pp_data(7));-- 33 ohm
RP08 : sres1206 port map ( a => pp_data_pre(8), b => pp_data(8));-- 33 ohm
RP09 : sres1206 port map ( a => pp_strobe_pre_n, b => pp_strobe_n);-- 33 ohm
RP10 : res1206 port map ( a => vcc, z => pp_strobe_n);	-- 4.7K ohm
RP11 : res1206 port map ( a => vcc, z => pp_init_n);	-- 4.7K ohm
RP12 : res1206 port map ( a => vcc, z => pp_autofd_n);	-- 4.7K ohm
RP13 : res1206 port map ( a => vcc, z => pp_selectin_n);	-- 4.7K ohm

J3: dsub25 port map ( 		----- The IEEE 1284-A Parallel Port connector--
	pin1 => pp_strobe_pre_n, -- we want a female connector
        pin2 => pp_data_pre(1),
        pin3 => pp_data_pre(2), -- we look like a PC
        pin4 => pp_data_pre(3), -- straight connect to peripherals (printers...)
        pin5 => pp_data_pre(4),
        pin6 => pp_data_pre(5),
        pin7 => pp_data_pre(6),
        pin8 => pp_data_pre(7),
        pin9 => pp_data_pre(8),
        pin10=> pp_ack_n,	-- pp_ack_n,
        pin11=> pp_busy,	-- pp_busy,
        pin12=> pp_error,	-- pp_perror,
        pin13=> pp_select,	-- pp_select,
        pin14=> pp_autofd_n,	-- pp_autofd_n,
        pin15=> pp_fault_n,	-- pp_fault_n,
        pin16=> pp_init_n,	-- pp_init_n,
        pin17=> pp_selectin_n,	-- pp_selectin_n,
        pin18=> gnd,
        pin19=> gnd,
        pin20=> gnd,
        pin21=> gnd,
        pin22=> gnd,
        pin23=> gnd,
        pin24=> gnd,
        pin25=> gnd,
        contact1  => dsub25_F_J3_1,
        contact2  => dsub25_F_J3_2,
        contact3  => dsub25_F_J3_3,
        contact4  => dsub25_F_J3_4,
        contact5  => dsub25_F_J3_5,
        contact6  => dsub25_F_J3_6,
        contact7  => dsub25_F_J3_7,
        contact8  => dsub25_F_J3_8,
        contact9  => dsub25_F_J3_9,
        contact10 => dsub25_F_J3_10,
        contact11 => dsub25_F_J3_11,
        contact12 => dsub25_F_J3_12,
        contact13 => dsub25_F_J3_13,
        contact14 => dsub25_F_J3_14,
        contact15 => dsub25_F_J3_15,
        contact16 => dsub25_F_J3_16,
        contact17 => dsub25_F_J3_17,
        contact18 => dsub25_F_J3_18,
        contact19 => dsub25_F_J3_19,
        contact20 => dsub25_F_J3_20,
        contact21 => dsub25_F_J3_21,
        contact22 => dsub25_F_J3_22,
        contact23 => dsub25_F_J3_23,
        contact24 => dsub25_F_J3_24,
        contact25 => dsub25_F_J3_25);

-------------------------------------------------------------------------------

UA1:	ad1846	-------------Create the Audio chip here (Analog Devices 1845)--
  PORT MAP(
	addr   => a_addr(1 downto 0),
	data   => a_data(7 downto 0),
	wr_n   => a_wr_n,
	rd_n   => a_rd_n,
	cs_n   => a_cs_n,
	pdrq   => open,
	pdak_n => pull_up,
	cdrq   => open,
	cdak_n => pull_up,
	dben_n => OPEN,
	dbdir  => OPEN,
	pwrdn_n=> pull_up,
	reset_n=> reset_n,
	int    => OPEN,
	xctl0  => OPEN,
	xctl1  => OPEN,
	-- Below are the analog pins
	l_line => single_point_net(0),
	r_line => single_point_net(1),
	l_mic  => a_l_mic,
	r_mic  => single_point_net(6),
	l_aux1 => single_point_net(7),
	r_aux1 => single_point_net(8),
	l_aux2 => single_point_net(9),
	r_aux2 => single_point_net(2),
	l_out  => a_l_out,
	r_out  => a_r_out,
	xtal1i => a_x1_1,
	xtal1o => a_x1_2,
	xtal2i => gnd,
	xtal2o => OPEN,
	vref   => a_vref,
	vref_f => a_vref_f,
	l_filt => a_l_filt,
	r_filt => a_r_filt);
-- filter caps for the analog lines
CA01 : cap_2pin port map ( minus => gnd, plus => a_r_filt);	-- 1uf
CA02 : cap_2pin port map ( minus => gnd, plus => a_l_filt);	-- 1uf
CA03 : cap_tant port map ( minus => gnd, plus => a_vref);	-- 22uf
CA04 : cap1206 port map ( minus => gnd, plus => a_vref_f);	-- .01uf
CA05 : cap_tant port map ( minus => gnd, plus => a_vref_f);	-- 22uf
-- crystals
CA06 : cap1206 port map ( minus => gnd, plus => a_x1_2);	-- 33pf
CA07 : cap1206 port map ( minus => gnd, plus => a_x1_1);	-- 33pf
XA06 : xtal port map ( a => a_x1_1, z => a_x1_2);	-- 24.576Mhz
-- headphone out drive circuit
--                 a_l_out_div
-- a_l_out>---/\/\/----+----/\/\/-----+
--            RA30     |    RA31      |
--            20K      |  |\ 18K      |
--                     +-->-\         |
--                        |  >--------+----->l_head_out
--            a_vref>----->+/UA2
--                        |/ SSM2135 op amp
-- Same for right line out
RA30 : res1206 port map ( a => a_l_out, z => a_l_out_div);	-- 20k
RA31 : res1206 port map ( a => a_l_out_div, z => l_head_out);	-- 18k
RA32 : res1206 port map ( a => a_r_out, z => a_r_out_div);	-- 20k
RA33 : res1206 port map ( a => a_r_out_div, z => r_head_out);	-- 18k
UA2: ssm2135 port map (	-- Power AMP for driving headphones
	ina_n   => a_l_out_div,
	ina	=> a_vref,
	outa	=> l_head_out,
	inb_n   => a_r_out_div,
	inb	=> a_vref,
	outb	=> r_head_out,
	gnds	=> gnd,
	pwr	=> vcc);

-- phantom powered microphone input circuit
--
--       GND                 +--/\/\/---+
--         |                 |  RA42    |
--         ^ Microphone      |  47K     |
--        (@)                +----||----+
--         V                 |  CA42    |
--         |    mic_ac       |  22pf    |
--         +--||-----/\/\/---+mic_acres |
--         |  CA40   RA41    |          |mic_amp
--         |  1uf    4.7K    | 2|\      |
--         |                 +-->-\ 1   |
--         +--/\/\/-+          3|  >----+--||---->a_l_mic to ad1848
--            RA40  | a_vref---->+/ UA3    RCA43
--            1.5K  |           |/ SS2135  1uf
--                 +5V 
--
RA40 : res1206 port map ( a => vcc, z => l_mic);-- 15K
CA40 : cap_2pin port map ( minus => l_mic, plus => a_l_mic_ac); --1uf ac coupled
RA41 : res1206 port map ( a => a_l_mic_ac, z => a_l_mic_acres);-- 4.7k
CA42 : cap1206 port map ( minus => a_l_mic_acres, plus => a_l_mic_amp); --220pf
RA42 : res1206 port map (     a => a_l_mic_acres,    z => a_l_mic_amp);-- 47k
CA43 : cap_2pin port map ( minus => a_l_mic_amp, plus => a_l_mic); --1uf
M1: mic port map (
        pin1 => l_mic,
        pin2 => gnd);
UA3: ssm2135 port map (	-- AMP and filter the incoming mic
	ina_n   => a_l_mic_acres,
	ina	=> a_vref,
	outa	=> a_l_mic_amp,
	inb_n   => a_vref_buf,	-- buffer Vref
	inb	=> a_vref,
	outb	=> a_vref_buf,
	gnds	=> gnd,
	pwr	=> vcc);

video <= vid_qclk & vid(15 downto 8);	-- the bt829 outputs 8 bits of video data on the MSB
UVID1: bt829	-----------Create the Video Decoder here-----------------------
  PORT MAP ( -- digital video stream interface
	vd	=> vid,
	qclk	=> vid_qclk,
	active	=> open,
	ccvalid	=> vid_ccvalid,
	cbflag	=> open,
	dvalid	=> open,
	field	=> open,
	hreset_n=> open,
	oe_n	=> vid_pulldn,
	vactive	=> open,
	vreset_n=> open,
	-- clocks and misc interfacE
	clkx1	=> open,
	clkx2	=> open,
	numxtal	=> vid_pulldn,
	pwrdn	=> vid_pulldn,
	xt0i	=> clk_vid,
	xt0o	=> open,
	xt1i	=> open,
	xt1o	=> open,
	-- I2C bus interface
	i2ccs	=> vid_pulldn,
	scl	=> ee_clk,
	sda	=> ee_sda,
	rst_n	=> reset_n,
	-- JTAG interface
	tck	=> vid_pulldn,
	tdi	=> vid_pullup,
	tdo	=> open,
	tms	=> vid_pullup,
	trst_n	=> vid_pulldn,
	-- analog interface
	agccap	=> vid_agccap,
	cabias	=> open,
	ccbias	=> open,
	cin	=> gnd,
	clevel	=> vid_clevel,
	cref_p	=> vid_ref,
	cref_m	=> gnd,
	mux_0	=> video_in_ac,
	mux_1	=> gnd,
	mux_2	=> gnd,
	muxout	=> video_out,
	syncdet	=> vid_syncdet,
	yabias	=> open,
	ycbias	=> open,
	yin	=> vid_yin,
	yref_p	=> vid_ref,
	yref_m	=> gnd,
	refout	=> vid_ref);

J18  : rca port map ( tip => video_in, shield => gnd);	-- connector
CV01 : cap_2pin port map ( minus => video_in, plus => video_in_ac);	-- 1uF, AC couple
RV02 : res1206 port map ( a => gnd, z => video_in);	-- 75 Ohm terminator

CV02 : cap_2pin port map ( minus => gnd, plus => vid_agccap);	-- 1uF
CV05 : cap_2pin port map ( minus => vid_yin, plus => video_out);	-- 1uF
CV07 : cap_2pin port map ( minus => vid_yin, plus => vid_syncdet);	-- 1uF
RV07 : res1206 port map ( a => gnd, z => vid_syncdet);	-- 390K ohm

CV03 : cap_2pin port map ( minus => gnd, plus => vid_ref);	-- 1uF
CV04 : cap_2pin port map ( minus => gnd, plus => vid_clevel);	-- 1uF
RV03 : res1206 port map ( a => vcc, z => vid_ref);	-- 1.5K
RV04 : res1206 port map ( a => vid_ref, z => vid_clevel);	-- 20K	-- voltage divider
RV05 : res1206 port map ( a => vid_clevel, z => gnd);		-- 20K	-- voltage divider

RV06 : res1206 port map ( a => vid_ccvalid, z => vcc);		-- 20K

US2:	max241e	-------------Create the RS232 driver here---------------------
  PORT MAP(
	r1in   => rs232_rxd,
	r2in   => rs232_rxd2,
	r3in   => rs232_cts,
	r4in   => rs232_dsr,
	r5in   => gnd,		-- unused
	r1out  => u_rx1,
	r2out  => u_rx2,
	r3out  => avail(0),
	r4out  => avail(1),
	r5out  => OPEN,
	t1in   => u_tx1,
	t2in   => u_tx2,
	t3in   => avail(2),
	t4in   => avail(3),
	t1out  => rs232_txd,
	t2out  => rs232_txd2,
	t3out  => rs232_rts,
	t4out  => rs232_dtr,
	shdn   => pulldn,
	en_n   => pulldn,
	-- analog pins
	c1p    => max_c1p,
	c1m    => max_c1m,
	c2p    => max_c2p,
	c2m    => max_c2m,
	vp     => max_vp,	-- +12v available for other uses if needed
	vm     => max_vm);	-- -12v available for other uses if needed
CS1 : cap_2pin port map ( minus => vcc, plus => max_vp);	-- 1uf
CS2 : cap_2pin port map ( minus => max_vm, plus => gnd);	-- 1uf
CS3 : cap_2pin port map ( minus => max_c1m, plus => max_c1p);	-- 1uf
CS4 : cap_2pin port map ( minus => max_c2m, plus => max_c2p);	-- 1uf

UR3:	ram128k8	-------------Create the 128Kx8 RAM here-------
  --GENERIC MAP("ram128k8.hex")
  PORT MAP(				-- Only this RAM is enabled for
	addr=> r_addr(16 downto 0),	-- the V8 or other 8 bit processors
	ce_n=> r_ce_n,
	ce  => pull_up,
	data=> r_data(7 downto 0),
	oe_n=> r_oe_n,
	we_n=> r_wel_n);

UR4:	ram128k8	-------------Create the 128Kx8 RAM here-------
  --GENERIC MAP("ram128k8.hex")
  PORT MAP(				-- This RAM is for 16 bit 
	addr=> r_addr(16 downto 0),	-- processors
	ce_n=> r_ce_n,
	ce  => ram16_ce,
	data=> r_data(15 downto 8),
	oe_n=> r_oe_n,
	we_n=> r_weh_n);

UR5:	ram128k8	-------------Create the 128Kx8 RAM here-------
  --GENERIC MAP("ram128k8.hex")
  PORT MAP(				-- These 2 RAMs are only for 32 bit uPs
	addr=> r_addr(16 downto 0),
	ce_n=> r_ce_n,
	ce  => ram32_ce,
	data=> mii_bus(9 downto 2),
	oe_n=> r_oe_n,
	we_n=> mii_bus(10));

UR6:	ram128k8	-------------Create the 128Kx8 RAM here-------
  --GENERIC MAP("ram128k8.hex")
  PORT MAP(
	addr=> r_addr(16 downto 0),
	ce_n=> r_ce_n,
	ce  => ram32_ce,
	data=> mii_bus(18 downto 11),
	oe_n=> r_oe_n,
	we_n=> mii_bus(19));

UR7:	seeprom	-------------Create the Serial EEPROM here-------
  --GENERIC MAP ("seeprom1.hex")
  PORT MAP(
	addr0=> gnd,
	addr1=> gnd,
	addr2=> eeprom_a2,
	sda => ee_sda,
	clk => ee_clk,
	wp  => ee_wp);

UR8:	seeprom	-------------Create the Serial EEPROM here-------
  --GENERIC MAP ("seeprom1.hex")
  PORT MAP(
	addr0=> pull_up,
	addr1=> gnd,
	addr2=> eeprom_a2,
	sda => ee_sda,
	clk => ee_clk,
	wp  => ee_wp);

RR5: res1206 port map ( a => vcc, z => ee_sda);	-- 1.5K pullup
RR6: res1206 port map ( a => vcc, z => ee_clk);	-- 1.5K pullup
RR7: res1206 port map ( a => gnd, z => eeprom_a2);	-- 1.5K pulldown

UI1: tfds3000	-------------IrDA LED---------------------------------
  port map (ired_c => OPEN,
        rxd    => i_rxd,
        pwr    => i_pwr,
        gnds   => gnd,
        sd     => i_sd,
        txd    => i_txd,
        ired_a => i_red_a);
RI01 : res1206 port map ( a => gnd, z => i_txd);	-- pulldown - 5.1K
RI02 : res1206 port map ( a => vcc, z => i_red_a);-- load resistor - 10 ohms
RI03 : res1206 port map ( a => vcc, z => i_pwr); -- 10 ohms
CI01 : cap_tant port map ( minus => gnd, plus => i_pwr);	-- 22uF
CI02 : cap1206  port map ( minus => gnd, plus => i_pwr);	-- .01uF
--
--             + - - - - - - - - - - - - - - - - - - - - -+
--             |       +----+  TFDS3000 IrDA Transceiver  |
--                     |    |
--             |     --+--  |              Driver         |
--               RX   \ /   | +------+     |\
--             | Photo V    | |AMP/  |     | \        RXD |
--               diode-+--  +-|Compar>----->  >------PIN2----I_RXD
--             |       |      |  ator|     | /            |
--                     +------|      |     |/       IRED_A
--             |              +--^---+            +--PIN8-+-+  _
--                               |                |         |  |
--             |                 |              --+--     | |  RI02
--                               |               \ / TX     |  |10ohms
--             |       SD        |                V  LED  | +--+
-- --I_SD--------PIN6------------+         |\   --+--
--             |       TXD (active high)   | \    |IRED_C |
-- -+I_TXD-------PIN7---------------------->  >---+--PIN1-
--  |          |                           | /            |
-- RI01 5.1K     +-PIN3=VCC  +-PIN4=GND    |/
--  |          +-| -  -  -  -| -  -  -  -  -  -  -  -  - -+
--  =   VCC-RI03-+---CI01----+ CI01=22uf, CI02=.01uf decoupling caps
--         10ohms+---CI02----+ RI03 isolates the power supply.
--                           =

UU1: usbp11	-----------Create the USB series B interface here-----------
  port map (	-- this is the upstream port so we look like a function
	dminus => usbb_dminus,
        dplus  => usbb_dplus,
        rcv    => usbb_rcv,
        vp     => usbb_vp,
        vm     => usbb_vm,
        oe_n   => usbb_oe_n,
        suspnd => gnd,
        speed  => usbb_speed,
        vpo    => usbb_vpo,
        vmo    => usbb_vmo,
        gnds   => gnd,
	pwr    => fat_etch_usb_3v);
RU10 : open1206 port map ( a => usbb_dplus_con, z => usbb_dplus); -- series 24 ohm
RU11 : open1206 port map ( a =>usbb_dminus_con, z => usbb_dminus);-- series 24 ohm
RU12 : res1206 port map ( a=> usbb_high, z=>usbb_dplus);-- pullup 1.5K high speed
RU13 : res1206 port map ( a=> usbb_low, z=>usbb_dminus);-- pullup 1.5K low speed
RU14 : open1206 port map ( a=> usbb_host1, z=>usbb_dminus);--pulldn 15K host mode
RU15 : open1206 port map ( a=> usbb_host2, z=>usbb_dplus );--pulldn 15K host mode

UU2: usbp11	--------Create the USB series A interface here Port 1-----------
  -- this port can also be used in host mode
  port map (	-- this is downstream port so we look like a HUB
	dminus => usba1_dminus,
        dplus  => usba1_dplus,
        rcv    => usba1_rcv,
        vp     => usba1_vp,
        vm     => usba1_vm,
        oe_n   => usba1_oe_n,
        suspnd => gnd,
        speed  => usba1_speed,
        vpo    => usba1_vpo,
        vmo    => usba1_vmo,
        gnds   => gnd,
	pwr    => fat_etch_usb_3v);
RU20 : open1206 port map ( a => usba1_dplus_con, z => usba1_dplus);-- series 24 ohm
RU21 : open1206 port map ( a =>usba1_dminus_con, z =>usba1_dminus);-- series 24 ohm
RU22 : open1206 port map ( a => gnd, z => usba1_dplus);	-- pulldown - 15K
RU23 : open1206 port map ( a => gnd, z => usba1_dminus);	-- pulldown - 15K
RU24 : open1206 port map ( a => usba4_dplus_con, z => usba4_dplus);-- series 24 ohm
RU25 : open1206 port map ( a =>usba4_dminus_con, z =>usba4_dminus);-- series 24 ohm
RU26 : open1206 port map ( a => gnd, z => usba4_dplus);	-- pulldown - 15K
RU27 : open1206 port map ( a => gnd, z => usba4_dminus);	-- pulldown - 15K

UU3: usbp11	--------Create the USB series A interface here Port 2-----------
  port map (	-- this is downstream port so we look like a HUB
	dminus => usba2_dminus,
        dplus  => usba2_dplus,
        rcv    => usba2_rcv,
        vp     => usba2_vp,
        vm     => usba2_vm,
        oe_n   => usba2_oe_n,
        suspnd => gnd,
        speed  => usba2_speed,
        vpo    => usba2_vpo,
        vmo    => usba2_vmo,
        gnds   => gnd,
	pwr    => fat_etch_usb_3v);
RU30 : open1206 port map ( a => usba2_dplus_con, z => usba2_dplus);-- series 24 ohm
RU31 : open1206 port map ( a =>usba2_dminus_con, z =>usba2_dminus);-- series 24 ohm
RU32 : open1206 port map ( a => gnd, z => usba2_dplus);	-- pulldown - 15K
RU33 : open1206 port map ( a => gnd, z => usba2_dminus);	-- pulldown - 15K
RU34 : open1206 port map ( a => usba5_dplus_con, z => usba5_dplus);-- series 24 ohm
RU35 : open1206 port map ( a =>usba5_dminus_con, z =>usba5_dminus);-- series 24 ohm
RU36 : open1206 port map ( a => gnd, z => usba5_dplus);	-- pulldown - 15K
RU37 : open1206 port map ( a => gnd, z => usba5_dminus);	-- pulldown - 15K

UU4: usbp11	--------Create the USB series A interface here Port 3-----------
  port map (	-- this is downstream port so we look like a HUB
	dminus => usba3_dminus,
        dplus  => usba3_dplus,
        rcv    => usba3_rcv,
        vp     => usba3_vp,
        vm     => usba3_vm,
        oe_n   => usba3_oe_n,
        suspnd => gnd,
        speed  => usba3_speed,
        vpo    => usba3_vpo,
        vmo    => usba3_vmo,
        gnds   => gnd,
	pwr    => fat_etch_usb_3v);
RU40 : open1206 port map ( a => usba3_dplus_con, z => usba3_dplus);-- series 24 ohm
RU41 : open1206 port map ( a =>usba3_dminus_con, z =>usba3_dminus);-- series 24 ohm
RU42 : open1206 port map ( a => gnd, z => usba3_dplus);	-- pulldown - 15K
RU43 : open1206 port map ( a => gnd, z => usba3_dminus);	-- pulldown - 15K
RU44 : open1206 port map ( a => usba6_dplus_con, z => usba6_dplus);-- series 24 ohm
RU45 : open1206 port map ( a =>usba6_dminus_con, z =>usba6_dminus);-- series 24 ohm
RU46 : open1206 port map ( a => gnd, z => usba6_dplus);	-- pulldown - 15K
RU47 : open1206 port map ( a => gnd, z => usba6_dminus);	-- pulldown - 15K

-- usb power switches and fuses
TU1: fet port map ( s=>vcc, g=>usba1_pwron, d=> fat_etch_usb1_sw);
FU1: fuse port map ( pin1 => fat_etch_usb1_sw, pin2 => fat_etch_usb1_pwr);
TU2: fet port map ( s=>vcc, g=>usba2_pwron, d=> fat_etch_usb2_sw);
FU2: fuse port map ( pin1 => fat_etch_usb2_sw, pin2 => fat_etch_usb2_pwr);
TU3: fet port map ( s=>vcc, g=>usba3_pwron, d=> fat_etch_usb3_sw);
FU3: fuse port map ( pin1 => fat_etch_usb3_sw, pin2 => fat_etch_usb3_pwr);
TU4: fet port map ( s=>vcc, g=>usba4_pwron, d=> fat_etch_usb4_sw);
FU4: fuse port map ( pin1 => fat_etch_usb4_sw, pin2 => fat_etch_usb4_pwr);
TU5: fet port map ( s=>vcc, g=>usba5_pwron, d=> fat_etch_usb5_sw);
FU5: fuse port map ( pin1 => fat_etch_usb5_sw, pin2 => fat_etch_usb5_pwr);
TU6: fet port map ( s=>vcc, g=>usba6_pwron, d=> fat_etch_usb6_sw);
FU6: fuse port map ( pin1 => fat_etch_usb6_sw, pin2 => fat_etch_usb6_pwr);

UFW: ti21lv03 ------------1394 FireWire PHY chip---------------
  port map (cps        => fw_cpwr_res,
	xi         => fw_x1,
	xo         => fw_x2,
	filter     => fw_filter,
	reset_n    => reset_n,
        pd         => fw_pulldown,
        cna        => fw_cna,
	iso_n      => fw_pullup,
	lps        => fw_phy(0),
	lreq       => fw_phy(1),
	sysclk     => clk_fw,
	ctl0       => fw_phy(2),
	ctl1       => fw_phy(3),
	d0         => fw_phy(4),
	d1         => fw_phy(5),
	d2         => fw_phy(6),
	d3         => fw_phy(7),
	c_lokon    => fw_lockon_res,
	pc0        => fw_pulldown,
	pc1        => fw_pulldown,
	pc2        => fw_pulldown,
	tpbias1    => fw_vt_bias1,
	tpbias2    => fw_vt_bias2,
	tpbias3    => fw_vt_bias3,
	r1         => fw_r1,
	r0         => fw_r0,
                                         -- 1394 port 3 connections
        tpb3_n     => fw_tpb3_n,
        tpb3       => fw_tpb3,
        tpa3_n     => fw_tpa3_n,
        tpa3       => fw_tpa3,
        tpb2_n     => fw_tpb2_n,
        tpb2       => fw_tpb2,
        tpa2_n     => fw_tpa2_n,
        tpa2       => fw_tpa2,
        tpb1_n     => fw_tpb1_n,
        tpb1       => fw_tpb1,
        tpa1_n     => fw_tpa1_n,
        tpa1       => fw_tpa1,
	avdd24     => fat_etch_fw_3v,
	avdd25     => fat_etch_fw_3v,
	avdd51     => fat_etch_fw_3v,
	avdd55     => fat_etch_fw_3v,
	dvdd4      => fat_etch_fw_3v,
	dvdd5      => fat_etch_fw_3v,
	dvdd6      => fat_etch_fw_3v,
	dvdd19     => fat_etch_fw_3v,
	dvdd20     => fat_etch_fw_3v,
	pllvdd     => fat_etch_fw_3v,
	testm1     => fat_etch_fw_3v,
	testm2     => fat_etch_fw_3v);
XFW : xtal port map ( a => fw_x1, z => fw_x2);	-- 24.576Mhz
RFW01: res1206 port map (a=>fw_r0, 	z => fw_r1);	-- 6.36K +-0.5%
RFW02: res1206 port map (a=>fat_etch_fw_3v, z => fw_pullup);-- 15K pullup
RFW03: res1206 port map (a=>gnd, z => fw_pulldown);-- 1.5K pulldown
RFW04: res1206 port map (a=>fat_etch_fw_cpwr, z => fw_cpwr_res);-- 390K pullup from cable power
-- cable terminators
RFW10: res1206 port map (a=>fw_vt1,	z=>fw_tpb1	);--56 Ohms
RFW11: res1206 port map (a=>fw_vt1,	z=>fw_tpb1_n	);--56 Ohms
RFW12: res1206 port map (a=>gnd  ,	z=>fw_vt1	);--5.1k Ohms
CFW10: cap_2pin port map (minus=>gnd,	plus=>fw_vt1	);--1uf
RFW20: res1206 port map (a=>fw_vt2,	z=>fw_tpb2	);--56 Ohms
RFW21: res1206 port map (a=>fw_vt2,	z=>fw_tpb2_n	);--56 Ohms
RFW22: res1206 port map (a=>gnd  ,	z=>fw_vt2	);--5.1k Ohms
CFW20: cap_2pin port map (minus=>gnd,	plus=>fw_vt2	);--1uf
RFW30: res1206 port map (a=>fw_vt3,	z=>fw_tpb3	);--56 Ohms
RFW31: res1206 port map (a=>fw_vt3,	z=>fw_tpb3_n	);--56 Ohms
RFW32: res1206 port map (a=>gnd  ,	z=>fw_vt3	);--5.1k Ohms
CFW30: cap_2pin port map (minus=>gnd,	plus=>fw_vt3	);--1uf
RFW40: res1206 port map (a=>fw_vt_bias1,	z=>fw_tpa1	);--56 Ohms
RFW41: res1206 port map (a=>fw_vt_bias1,	z=>fw_tpa1_n	);--56 Ohms
RFW42: res1206 port map (a=>fw_vt_bias2,	z=>fw_tpa2	);--56 Ohms
RFW43: res1206 port map (a=>fw_vt_bias2,	z=>fw_tpa2_n	);--56 Ohms
RFW44: res1206 port map (a=>fw_vt_bias3,	z=>fw_tpa3	);--56 Ohms
RFW45: res1206 port map (a=>fw_vt_bias3,	z=>fw_tpa3_n	);--56 Ohms
CFW41: cap_2pin port map (minus=>gnd,	plus=>fw_vt_bias1);--1uf
CFW42: cap_2pin port map (minus=>gnd,	plus=>fw_vt_bias2);--1uf
CFW43: cap_2pin port map (minus=>gnd,	plus=>fw_vt_bias3);--1uf
RFW69: res1206 port map (a=>fw_phy(8),	z=>fw_lockon_res);--15K Ohms
CFW98: cap1206 port map (minus=>gnd,	plus=>fw_filter	);--33pf (or .1 for TI)
CFW99: cap1206 port map (minus=>gnd,	plus=>fw_filter_res	);--220uf (only for phillips)
RFW99: res1206 port map (a=>fw_filter_res,	z=>fw_filter	);--6.3k Ohms (only for phillips)

-- This oscillator is not nornally used.
--X1: osc	--------------- create the CPU oscillator here--------
--  PORT MAP (osc_out=> clk_cpu,
--	pwr=> vcc,
--	gnds=> gnd,
--	enb=> vcc);

X2: osc50	--------------- create the 48Mhz USB oscillator here--------
  PORT MAP (osc_out=> clk_usb,
	pwr=> vcc,
	gnds=> gnd,
	enb=> vcc);

X3: osc	--------------- create the video oscillator here--------
  PORT MAP (osc_out=> clk_vid,
	pwr=> vcc,
	gnds=> gnd,
	enb=> vcc);

SW2: spst		-- push button reset switch
  port map (
    sw_out => reset_n,
    sw_in  => gnd);
R01: res1206 port map ( a => vcc, z => reset_n);	-- pullup - 330 ohms
C01: cap_2pin port map ( minus => gnd, plus => reset_n);	-- 1uf

L1: led10	-------------------- diagnostic LED bar
  port map (a1   => xc_done_led,	-- Xilinx not configured when on
        a2   => al_conf_done_led,	-- Altera not configured when on
        a3   => led(7),	-- PSR 7
        a4   => led(6),
        a5   => led(5),
        a6   => led(4),
        a7   => led(3),
        a8   => led(2),
        a9   => led(1),
        a10  => led(0),	-- PSR 0
        c1   => xc_done,
        c2   => al_conf_done,
        c3   => pulldn1,	-- We use the same current limiting
        c4   => pulldn1,	-- resisitor just to be cheap.
        c5   => pulldn1,	-- The intensity will vary a bit,
        c6   => pulldn2,	-- but who really cares...
        c7   => pulldn2,
        c8   => pulldn2,
        c9   => pulldn3,
        c10  => pulldn3);

UALT10: ldo_reg	-- Altera FPGA 3.3V regulator
  PORT MAP (
	lbf	=> open,
        sc	=> gnd,
        vin   	=> vcc,
        nc	=> open,
        vout   	=> fat_etch_alt_3v,
        dc   	=> open,
        gnd   	=> gnd,
        spg  	=> alt_ldo_spg);
CALT10: cap1206 port map ( minus => gnd, plus => vcc);-- .01uf
CALT11: cap_tant port map ( minus => gnd, plus => fat_etch_alt_3v);-- 22uf
CALT12: cap1206 port map (minus=>fat_etch_alt_3v,plus=>alt_ldo_spg);--33pf
CALT13: cap1206 port map ( minus => gnd, plus => fat_etch_alt_3v);-- .01uf
CALT14: cap1206 port map ( minus => gnd, plus => fat_etch_alt_3v);-- .01uf
CALT15: cap1206 port map ( minus => gnd, plus => fat_etch_alt_3v);-- .01uf
CALT16: cap1206 port map ( minus => gnd, plus => fat_etch_alt_3v);-- .01uf
JA10: zeroohm	-- zero ohm jumpers for current measurements
  port MAP (pin1 => fat_etch_alt_3v,
        pin2 => fat_etch_alt_3v);

UXIL10: ldo_reg	-- Xilinx FPGA 3.3V regulator
  PORT MAP (
	lbf	=> open,
        sc	=> gnd,
        vin   	=> vcc,
        nc	=> open,
        vout   	=> fat_etch_xil_3v,
        dc   	=> open,
        gnd   	=> gnd,
        spg  	=> xil_ldo_spg);
RXIL1: res1206 port map ( a => gnd, z => xc_mode);	-- 1.5k pulldown
CXIL10: cap1206 port map ( minus => gnd, plus => vcc);-- .01uf
CXIL11: cap_tant port map ( minus => gnd, plus => fat_etch_xil_3v);-- 22uf
CXIL12: cap1206 port map (minus=>fat_etch_xil_3v,plus=>xil_ldo_spg);--33pf
CXIL13: cap1206 port map ( minus => gnd, plus => fat_etch_xil_3v);-- .01uf
CXIL14: cap1206 port map ( minus => gnd, plus => fat_etch_xil_3v);-- .01uf
CXIL15: cap1206 port map ( minus => gnd, plus => fat_etch_xil_3v);-- .01uf
CXIL16: cap1206 port map ( minus => gnd, plus => fat_etch_xil_3v);-- .01uf
CXIL17: cap1206 port map ( minus => gnd, plus => fat_etch_xil_3v);-- .01uf
CXIL18: cap1206 port map ( minus => gnd, plus => fat_etch_xil_3v);-- .01uf
JX10: zeroohm	-- zero ohm jumpers for current measurements
  port MAP (pin1 => fat_etch_xil_3v,
        pin2 => fat_etch_xil_3v);

UUSB10: ldo_reg	-- USB 3.3V regulator
  PORT MAP (
	lbf	=> open,
        sc	=> gnd,
        vin   	=> vcc,
        nc	=> open,
        vout   	=> fat_etch_usb_3v,
        dc   	=> open,
        gnd   	=> gnd,
        spg  	=> usb_ldo_spg);
CUSB11: cap_tant port map ( minus => gnd, plus => fat_etch_usb_3v);-- 22uf
CUSB12: cap1206 port map (minus=>fat_etch_usb_3v,plus=>usb_ldo_spg);--33pf
CUSB13: cap1206 port map ( minus => gnd, plus => vcc);-- .01uf
CUSB14: cap1206 port map ( minus => gnd, plus => fat_etch_usb_3v);-- .01uf
CUSB15: cap1206 port map ( minus => gnd, plus => fat_etch_usb_3v);-- .01uf
CUSB16: cap1206 port map ( minus => gnd, plus => fat_etch_usb_3v);-- .01uf

UFW10: ldo_reg	-- Firewire 3.3V regulator
  PORT MAP (
	lbf	=> open,
        sc	=> gnd,
        vin   	=> vcc,
        nc	=> open,
        vout   	=> fat_etch_fw_3v,
        dc   	=> open,
        gnd   	=> gnd,
        spg  	=> fw_ldo_spg);
CFW11: cap_tant port map ( minus => gnd, plus => fat_etch_fw_3v);-- 22uf
CFW12: cap1206 port map (minus=>fat_etch_fw_3v,plus=>fw_ldo_spg);--33pf
CFW13: cap1206 port map ( minus => gnd, plus => vcc);-- .01uf
CFW14: cap1206 port map ( minus => gnd, plus => fat_etch_fw_3v);-- .01uf
CFW15: cap1206 port map ( minus => gnd, plus => fat_etch_fw_3v);-- .01uf
CFW16: cap1206 port map ( minus => gnd, plus => fat_etch_fw_3v);-- .01uf

SW1: swdip8 port map (	-- DIP switches for setting options
  	a1 => xc_mode,	-- Xilinx mode - closed=slave, open=master(proms)
        a2 => ram16_ce,	-- enable RAM bit [15:8]
        a3 => ram32_ce,	-- enable RAM bits [31:16]
        a4 => eeprom_a2, -- closed=disables EEPROM, open=enabled
        a5 => pp_autofd_n,
        a6 => pp_init_n,
        a7 => pp_strobe_n,
        a8 => vcc,	-- closed=USB cable powered device, open=self-powered
        b1 => fat_etch_xil_3v,
        b2 => vcc,
        b3 => vcc,
        b4 => vcc,
        b5 => gnd,
        b6 => gnd,
        b7 => gnd,
        b8 => fat_etch_usbb_pwr);


-----------other random discretes-----------------------------------

R12: res1206 port map ( a => vcc, z => pull_up);	-- 5.1k pullup
R13: res1206 port map ( a => gnd, z => pulldn);	-- 5.1k pulldown
R15: res1206 port map ( a => gnd, z => pulldn1);	-- 330 ohm
R16: res1206 port map ( a => gnd, z => pulldn2);	-- 330 ohm
R17: res1206 port map ( a => gnd, z => pulldn3);	-- 330 ohm
R18: res1206 port map ( a => gnd, z => ram16_ce);	-- 1.5k ohm
R19: res1206 port map ( a => gnd, z => ram32_ce);	-- 1.5k ohm

-- decoupling caps
C70 : cap_tant port map ( minus => gnd, plus => vcc);	-- 22uf
C71 : cap_tant port map ( minus => gnd, plus => vcc);	-- 22uf
C72 : cap_tant port map ( minus => gnd, plus => vcc);	-- 22uf
C85: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C86: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C87: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C88: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C89: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C90: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C91: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C92: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C93: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C94: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C95: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C96: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C97: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C98: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf
C99: cap1206 port map (minus=>gnd,	plus=>vcc	);--.01uf

-----------------Connectors-------------------------------------
J1: pwr_5v port map (
        pin1 => vcc,
        pin2 => gnd,
        pin3 => gnd);

J2: dsub9 port map (            -------- The RS232 connector is a 9 pin D---
        pin1 => OPEN, -- Frame Ground - not used
        pin2 => rs232_txd, -- we look like a peripheral (modem)
        pin3 => rs232_rxd, -- for a straight connect to a PC
        pin4 => rs232_dsr,
        pin5 => gnd,
        pin6 => rs232_dtr,
        pin7 => rs232_cts,
        pin8 => rs232_rts,
        pin9 => OPEN,		-- normally the RING indicator
        contact1 => dsub9_F_J2_1, --
        contact2 => dsub9_F_J2_2, --
        contact3 => dsub9_F_J2_3, --
        contact4 => dsub9_F_J2_4, --
        contact5 => dsub9_F_J2_5, --
        contact6 => dsub9_F_J2_6, --
        contact7 => dsub9_F_J2_7, --
        contact8 => dsub9_F_J2_8, --
        contact9 => dsub9_F_J2_9);

J5: dsub9 port map (            -------- The RS232 connector is a 9 pin D---
        pin1 => OPEN, -- no hardware modem controls
        pin2 => rs232_txd2, -- we look like a peripheral (modem)
        pin3 => rs232_rxd2, -- for a straight connect to a PC
        pin4 => OPEN,
        pin5 => gnd,
        pin6 => OPEN,
        pin7 => OPEN,
        pin8 => OPEN,
        pin9 => OPEN,
        contact1 => OPEN, --
        contact2 => OPEN, --
        contact3 => OPEN, --
        contact4 => OPEN, --
        contact5 => OPEN, --
        contact6 => OPEN, --
        contact7 => OPEN, --
        contact8 => OPEN, --
        contact9 => OPEN);

RJ61: res1206 port map ( a => vcc, z => xc_done_led);	-- 1.5k ohm
RJ62: res1206 port map ( a => vcc, z => xc_prog_n);	-- 1.5k ohm
RJ63: res1206 port map ( a => vcc, z => xc_init_n);	-- 1.5k ohm
J6: xchecker port map (
	power => vcc,
        ground=> gnd,
        cclk	=> xc_cclk,
        done	=> xc_done,
        din	=> xc_din,
        prog_n	=> xc_prog_n,
        init_n	=> xc_init_n,
        rst	=> OPEN,
	-- second row...
        rt	=> OPEN,
        rd	=> OPEN,
        trig	=> tdo,
        tdi	=> tdi,
        tck	=> tck,
        tms	=> tms,
        clki	=> OPEN,
        clko	=> OPEN);

-- these resistors should be 1.0K.
RJ71: res1206 port map ( a => vcc, z => al_conf_done_led);	-- 1.5k ohm
RJ72: res1206 port map ( a => vcc, z => al_nstatus);	-- 1.5k ohm
RJ73 : res1206 port map ( a => vcc, z => al_init_done);-- 1.5k ohm
RJ74 : res1206 port map ( a => vcc, z => al_dclk);-- 1.5k ohm
RJ75 : res1206 port map ( a => vcc, z => al_conf_done);-- 1.5k ohm
RJ76 : res1206 port map ( a => gnd, z => al_mode);-- 1.5k ohm
RJ77 : res1206 port map ( a => vcc, z => al_nconfig);-- 1.5k ohm
J7: hdr10 port map (
  	pin1	=> al_dclk,
        pin2	=> gnd,
        pin3	=> al_conf_done,
        pin4	=> vcc,
        pin5	=> al_nconfig,
        pin6	=> open,
        pin7	=> al_nstatus,
        pin8	=> open,
        pin9	=> al_data0,
        pin10	=> gnd);

----------------------------------------------------------------
-- The JTAG conector has 56 ohm series resistors on all 4 signals which
-- should be approximately the line impedance. If nothing else, it will
-- slow the edge rate to allow reasonable length cables (1-3 feet).
-- TMS and TCK are pulled up lightly to insure no transitions
-- occur on these lines.
RJ41: open1206 port map ( a => vcc, z => tck);	-- 390k ohm simulate as opens
RJ42: open1206 port map ( a => vcc, z => tms);	-- 390k ohm simulate as opens
RJ43: sres1206 port map ( a => tck, b => tck_conn);	-- 56 ohm
RJ44: sres1206 port map ( a => tms, b => tms_conn);	-- 56 ohm
RJ45: sres1206 port map ( a => tdo, b => tdo_conn);	-- 56 ohm
RJ46: sres1206 port map ( a => tdi, b => tdi_conn);	-- 56 ohm
J4: dsub9 port map ( 		-------- The JTAG connector is a 9 pin D---
	pin1 => gnd,
        pin2 => tck_conn,	-- TCK
        pin3 => tms_conn,	-- TMS
        pin4 => gnd,
        pin5 => gnd,
        pin6 => gnd,
        pin7 => tdi_conn,	-- TDI
        pin8 => tdo_conn,	-- TDO
        pin9 => gnd,
        contact1 => dsub9_F_J4_1, --
        contact2 => dsub9_F_J4_2, --
        contact3 => dsub9_F_J4_3, --
        contact4 => dsub9_F_J4_4, --
        contact5 => dsub9_F_J4_5, --
        contact6 => dsub9_F_J4_6, --
        contact7 => dsub9_F_J4_7, --
        contact8 => dsub9_F_J4_8, --
        contact9 => dsub9_F_J4_9);

J8: phone port map (		------------- AUDIO connector---------
        tip    => l_head_out,
	ring   => r_head_out,
        shield => a_vref_buf);	-- NOTE! we center on vref so we don't
				-- have to AC couple with HUGE caps...


JU9: zeroohm	-- zero ohm jumpers for current measurements
  port MAP (pin1 => fat_etch_usbb_fuse,
        pin2 => fat_etch_usbb_fuse);
FU9: fuse port map ( pin1 => fat_etch_usbb_fuse, pin2 => fat_etch_usbb_pwr);
J9: usbconnb port map (		-----------USB connectors-----------
	pin1 => fat_etch_usbb_fuse,
        pin2 => usbb_dminus_con,
        pin3 => usbb_dplus_con,
        pin4 => gnd,
	contact1 => usb_B_J9_cpwr,
        contact2 => usb_B_J9_dminus,
        contact3 => usb_B_J9_dplus,
        contact4 => usb_B_J9_cgnd
        );

J10: usbadual port map (
	pin1 => fat_etch_usb1_pwr,
        pin2 => usba1_dminus_con,
        pin3 => usba1_dplus_con,
        pin4 => gnd,
	pin5 => fat_etch_usb4_pwr,
        pin6 => usba4_dminus_con,
        pin7 => usba4_dplus_con,
        pin8 => gnd,
	contact1 => usb_A_J10_cpwr,
        contact2 => usb_A_J10_dminus,
        contact3 => usb_A_J10_dplus,
        contact4 => usb_A_J10_cgnd,
	contact5 => usb_A_J10_cpwr4,
        contact6 => usb_A_J10_dminus4,
        contact7 => usb_A_J10_dplus4,
        contact8 => usb_A_J10_cgnd4
        );
J11: usbadual port map (
	pin1 => fat_etch_usb2_pwr,
        pin2 => usba2_dminus_con,
        pin3 => usba2_dplus_con,
        pin4 => gnd,
	pin5 => fat_etch_usb5_pwr,
        pin6 => usba5_dminus_con,
        pin7 => usba5_dplus_con,
        pin8 => gnd,
	contact1 => usb_A_J11_cpwr,
        contact2 => usb_A_J11_dminus,
        contact3 => usb_A_J11_dplus,
        contact4 => usb_A_J11_cgnd,
	contact5 => usb_A_J11_cpwr5,
        contact6 => usb_A_J11_dminus5,
        contact7 => usb_A_J11_dplus5,
        contact8 => usb_A_J11_cgnd5
        );
J12: usbadual port map (
	pin1 => fat_etch_usb3_pwr,
        pin2 => usba3_dminus_con,
        pin3 => usba3_dplus_con,
        pin4 => gnd,
	pin5 => fat_etch_usb6_pwr,
        pin6 => usba6_dminus_con,
        pin7 => usba6_dplus_con,
        pin8 => gnd,
	contact1 => usb_A_J12_cpwr,
        contact2 => usb_A_J12_dminus,
        contact3 => usb_A_J12_dplus,
        contact4 => usb_A_J12_cgnd,
	contact5 => usb_A_J12_cpwr6,
        contact6 => usb_A_J12_dminus6,
        contact7 => usb_A_J12_dplus6,
        contact8 => usb_A_J12_cgnd6
        );

-----------IEEE 1394 connectors-----------
J14: fw_conn port map (           --
  	pin1 => fat_etch_fw_cpwr,-- vp
        pin2 => gnd,             -- vg
        pin3 => fw_tpb1_n,       -- tpb_n
        pin4 => fw_tpb1,         -- tpb
        pin5 => fw_tpa1_n,       -- tpa_n
        pin6 => fw_tpa1,         -- tpa
        contact1 => fw_J14_1,
        contact2 => fw_J14_2,
        contact3 => fw_J14_3,
        contact4 => fw_J14_4,
        contact5 => fw_J14_5,
        contact6 => fw_J14_6
        );
J15: fw_conn port map (           --
  	pin1 => fat_etch_fw_cpwr,-- vp
        pin2 => gnd,             -- vg
        pin3 => fw_tpb2_n,       -- tpb_n
        pin4 => fw_tpb2,         -- tpb
        pin5 => fw_tpa2_n,       -- tpa_n
        pin6 => fw_tpa2,         -- tpa
        contact1 => fw_J15_1,
        contact2 => fw_J15_2,
        contact3 => fw_J15_3,
        contact4 => fw_J15_4,
        contact5 => fw_J15_5,
        contact6 => fw_J15_6
        );
J16: fw_conn port map (           --
  	pin1 => fat_etch_fw_cpwr,-- vp
        pin2 => gnd,             -- vg
        pin3 => fw_tpb3_n,       -- tpb_n
        pin4 => fw_tpb3,         -- tpb
        pin5 => fw_tpa3_n,       -- tpa_n
        pin6 => fw_tpa3,         -- tpa
        contact1 => fw_J16_1,
        contact2 => fw_J16_2,
        contact3 => fw_J16_3,
        contact4 => fw_J16_4,
        contact5 => fw_J16_5,
        contact6 => fw_J16_6
        );

J17: mii port map (	-- 100mbs Ethernet controller
	pin1 =>  vcc,
	pin2 =>  mii_bus(2),
	pin3 =>  mii_bus(3),
	pin4 =>  mii_bus(4),
	pin5 =>  mii_bus(5),
	pin6 =>  mii_bus(6),
	pin7 =>  mii_bus(7),
	pin8 =>  mii_bus(8),
	pin9 =>  mii_bus(9),
	pin10 => mii_bus(10),
	pin11 => mii_bus(11),
	pin12 => mii_bus(12),
	pin13 => mii_bus(13),
	pin14 => mii_bus(14),
	pin15 => mii_bus(15),
	pin16 => mii_bus(16),
	pin17 => mii_bus(17),
	pin18 => mii_bus(18),
	pin19 => mii_bus(19),
	pin20 => vcc,
	pin21 => vcc,
	pin22 => gnd,
	pin23 => gnd,
	pin24 => gnd,
	pin25 => gnd,
	pin26 => gnd,
	pin27 => gnd,
	pin28 => gnd,
	pin29 => gnd,
	pin30 => gnd,
	pin31 => gnd,
	pin32 => gnd,
	pin33 => gnd,
	pin34 => gnd,
	pin35 => gnd,
	pin36 => gnd,
	pin37 => gnd,
	pin38 => gnd,
	pin39 => gnd,
	pin40 => vcc,
        contact1     => mii_F_J17_1, -- +5V
        contact2     => mii_F_J17_2, -- MDIO
        contact3     => mii_F_J17_3, -- MDC
        contact4     => mii_F_J17_4, -- RXD(3)
        contact5     => mii_F_J17_5, -- RXD(2)
        contact6     => mii_F_J17_6, -- RXD(1)
        contact7     => mii_F_J17_7, -- RXD(0)
        contact8     => mii_F_J17_8, -- RX_DV
        contact9     => mii_F_J17_9, -- RX_CLK
        contact10    => mii_F_J17_10,-- RX_ERR
        contact11    => mii_F_J17_11,-- TX_ERR
        contact12    => mii_F_J17_12,-- TX_CLK
        contact13    => mii_F_J17_13,-- TX_EN
        contact14    => mii_F_J17_14,-- TXD(0)
        contact15    => mii_F_J17_15,-- TXD(1)
        contact16    => mii_F_J17_16,-- TXD(2)
        contact17    => mii_F_J17_17,-- TXD(3)
        contact18    => mii_F_J17_18,-- COL
        contact19    => mii_F_J17_19,-- CRS
        contact20    => mii_F_J17_20,-- +5V
        contact21    => mii_F_J17_21,-- +5V
        contact22    => mii_F_J17_22,-- contact 22-39 are all GND
        contact23    => mii_F_J17_23,--
        contact24    => mii_F_J17_24,--
        contact25    => mii_F_J17_25,--
        contact26    => mii_F_J17_26,--
        contact27    => mii_F_J17_27,--
        contact28    => mii_F_J17_28,--
        contact29    => mii_F_J17_29,--
        contact30    => mii_F_J17_30,--
        contact31    => mii_F_J17_31,--
        contact32    => mii_F_J17_32,--
        contact33    => mii_F_J17_33,--
        contact34    => mii_F_J17_34,--
        contact35    => mii_F_J17_35,--
        contact36    => mii_F_J17_36,--
        contact37    => mii_F_J17_37,--
        contact38    => mii_F_J17_38,--
        contact39    => mii_F_J17_39,--
        contact40    => mii_F_J17_40);-- +5V

--------------------------------- Logic analyzer connectors
POD1: hdr20 port map(	-- SRAM address bus
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> clk_cpu,
        pin4	=> r_addr(15),
        pin5	=> r_addr(14),
        pin6	=> r_addr(13),
        pin7	=> r_addr(12),
        pin8	=> r_addr(11),
        pin9	=> r_addr(10),
        pin10	=> r_addr(9),
        pin11	=> r_addr(8),
        pin12	=> r_addr(7),
        pin13	=> r_addr(6),
        pin14	=> r_addr(5),
        pin15	=> r_addr(4),
        pin16	=> r_addr(3),
        pin17	=> r_addr(2),
        pin18	=> r_addr(1),
        pin19	=> r_addr(0),
        pin20	=> gnd);

POD2: hdr20 port map(	-- SRAM data bus
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> clk_fclk1,
        pin4	=> r_data(15),
        pin5	=> r_data(14),
        pin6	=> r_data(13),
        pin7	=> r_data(12),
        pin8	=> r_data(11),
        pin9	=> r_data(10),
        pin10	=> r_data(9),
        pin11	=> r_data(8),
        pin12	=> r_data(7),
        pin13	=> r_data(6),
        pin14	=> r_data(5),
        pin15	=> r_data(4),
        pin16	=> r_data(3),
        pin17	=> r_data(2),
        pin18	=> r_data(1),
        pin19	=> r_data(0),
        pin20	=> gnd);

POD3: hdr20 port map(	-- SRAM control signal
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> gclk0,
        pin4	=> led(7),
        pin5	=> led(6),
        pin6	=> led(5),
        pin7	=> led(4),
        pin8	=> led(3),
        pin9	=> led(2),
        pin10	=> led(1),
        pin11	=> led(0),
        pin12	=> avail(0),
        pin13	=> r_addr(16),
        pin14	=> mii_bus(19),
        pin15	=> mii_bus(18),
        pin16	=> r_ce_n,
        pin17	=> r_oe_n,
        pin18	=> r_weh_n,
        pin19	=> r_wel_n,
        pin20	=> gnd);

POD4a: hdr20 port map(	-- MII connector/upper 16 bits of RAM
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> led(8),
        pin4	=> mii_bus(17),
        pin5	=> mii_bus(16),
        pin6	=> mii_bus(15),
        pin7	=> mii_bus(14),
        pin8	=> mii_bus(13),
        pin9	=> mii_bus(12),
        pin10	=> mii_bus(11),
        pin11	=> mii_bus(10),
        pin12	=> mii_bus(9),
        pin13	=> mii_bus(8),
        pin14	=> mii_bus(7),
        pin15	=> mii_bus(6),
        pin16	=> mii_bus(5),
        pin17	=> mii_bus(4),
        pin18	=> mii_bus(3),
        pin19	=> mii_bus(2),
        pin20	=> gnd);

POD4b: hdr20 port map(	-- Audio/ parallel port signals
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> led(8),
        pin4	=> pp_data(8),
        pin5	=> pp_data(7),
        pin6	=> pp_data(6),
        pin7	=> pp_data(5),
        pin8	=> pp_data(4),
        pin9	=> pp_data(3),
        pin10	=> pp_data(2),
        pin11	=> pp_data(1),
        pin12	=> vid_qclk,
        pin13	=> avail(2),
        pin14	=> avail(1),
        pin15	=> a_addr(1),
        pin16	=> a_addr(0),
        pin17	=> a_wr_n,
        pin18	=> a_rd_n,
        pin19	=> a_cs_n,
        pin20	=> gnd);

POD5a: hdr20 port map(	-- USB signals
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> led(9),
        pin4	=> ee_clk,
        pin5	=> ee_sda,
        pin6	=> led(9),
        pin7	=> led(8),
        pin8	=> usba2_oe_n,
        pin9	=> usba1_oe_n,
        pin10	=> usbb_oe_n,
        pin11	=> usbb_vm,
        pin12	=> usbb_vp,
        pin13	=> usbb_rcv,
        pin14	=> usba2_dminus_con,
        pin15	=> usba2_dplus_con,
        pin16	=> usba1_dminus_con,
        pin17	=> usba1_dplus_con,
        pin18	=> usbb_dminus_con,
        pin19	=> usbb_dplus_con,
        pin20	=> gnd);

POD5b: hdr20 port map(	-- FireWire debugging
        pin1	=> vcc,
        pin2	=> OPEN,
        pin3	=> clk_fw,
        pin4	=> i_rxd,
        pin5	=> i_sd,
        pin6	=> i_txd,
        pin7	=> ee_wp,
        pin8	=> fw_cna,
        pin9	=> fw_vt_bias1,
        pin10	=> fw_lockon_res,
        pin11	=> fw_phy(8),
        pin12	=> fw_phy(7),
        pin13	=> fw_phy(6),
        pin14	=> fw_phy(5),
        pin15	=> fw_phy(4),
        pin16	=> fw_phy(3),
        pin17	=> fw_phy(2),
        pin18	=> fw_phy(1),
        pin19	=> fw_phy(0),
        pin20	=> gnd);

END structural;
