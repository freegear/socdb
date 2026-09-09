--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: vusb.vhd	VAutomation USB Interface
--
-- Revision: $Name: REV9911b $
--
-- Description: 
--	Synthesizable VHDL description implementing the USB Serial Interface 
--	Engine (SEI).
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: vusb.vhd,v $
-- Revision 1.32  2000/01/03 16:27:26  chris
-- Added host_wo_hub signal.
--
-- Revision 1.31  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.30  1999/11/09 14:17:48  mark
-- ulogicified source - no functional changes
--
-- Revision 1.29  1999/11/01 22:07:38  scott
-- Added port for bridge to flush the write buffer
--
-- Revision 1.28  1999/09/10 20:31:28  chris
-- Added extra signal from up_int to usb_sie for host repeat disable.
--
-- Revision 1.27  1999/06/23 20:19:51  chris
-- Added usb_en output to allow software to control device connect events.
--
-- Revision 1.26  1998/11/06 17:55:42  gregg
-- Added resume support for device and host controller modes
--
-- Revision 1.25  1998/10/19 15:46:56  chris
-- Added hardware dequeuing and protocol stall support.
-- /
--
-- Revision 1.24  1998/07/23 09:59:21  chris
-- Added acknowledge for token req and clr to cdb bus.
--
-- Revision 1.23  1998/06/23 18:44:23  chris
-- Added 12MHz clock enable for SOF timer.
--
-- Revision 1.22  1998/06/15 22:06:49  chris
--  Added syntax for Async or Sync reset inference.
--
-- Revision 1.21  1998/05/29 16:22:04  chris
-- Added signals for VUSB Hub.
--
-- Revision 1.20  1998/04/27 22:56:59  chris
-- Combined Rx and Tx FIFO flush signals.
--
-- Revision 1.19  1998/03/26 21:16:40  chris
-- Added Tx FIFO clearing support.
--
-- Revision 1.18  1998/03/13 21:39:42  chris
-- Added Revision name.
--
-- Revision 1.17  1998/02/18 12:18:41  gregg
-- Added dma_wrt_bdt_o and dma_rd_bdt_o
--
-- Revision 1.16  1998/02/17 21:20:25  chris
-- Added I/O's and interconnect to support embedded host mode operations.
--
-- Revision 1.15  1997/11/20 14:33:48  chris
-- Added clk_en clock enable input.
--
-- Revision 1.14  1997/10/31 21:04:03  chris
-- *** empty log message ***
--
-- Revision 1.13  1997/10/16 12:49:03  chris
-- Removed <Control-M> characters from the line ends.
--
-- Revision 1.12  1997/08/28 17:52:53  gregg
-- Added dmadatai port for synchronous bus transfers
--
-- Revision 1.11  1997/08/25 20:11:38  gregg
-- Added additional error support
--
-- Revision 1.10  1997/05/12 03:11:13  gregg
-- Added new endpoint control register formats
--
-- Revision 1.9  1997/05/10 03:22:36  gregg
-- Added EOP to the DPLL and brought more debugging signals out.
--
-- Revision 1.8  1997/05/09 16:43:51  gregg
-- Moved SE0 detect to DPLL.
--
-- Revision 1.7  1997/03/18 12:09:23  gregg
-- Added debug bus of internal signals
--
-- Revision 1.6  1997/03/08 03:22:01  gregg
-- Added changed up_int port map
--
-- Revision 1.5  1997/03/04 18:15:42  gregg
-- Fixed BDT DATA01 writeback problem on SETUP and OUT TOKENS
--
-- Revision 1.4  1997/03/03 12:52:23  gregg
-- Added Tx FIFO
--
-- Revision 1.3  1997/02/27 02:08:28  gregg
-- Added Rx FIFO
--
-- Revision 1.2  1997/02/21 14:43:09  eric
-- OUT and SETUP coded.
--
-- Revision 1.1  1997/02/06 12:36:49  chris
-- Initial revision
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vusb is
  port (-- Generic uProcessor Interface signals
        addri    : in  std_ulogic_vector(4 downto 0); -- Address Bus
        addro    : out std_ulogic_vector(15 downto 0); -- Address Bus
        dmadatai : in  std_ulogic_vector(7 downto 0); -- DMA Data Bus In
        datai    : in  std_ulogic_vector(7 downto 0); -- Data Bus In
        datao    : out std_ulogic_vector(7 downto 0); -- Data Bus Out
        doe      : out std_ulogic;  -- Data Bus Output Enable
        cei      : in  std_ulogic;  -- Chip Enable Input
        ceo      : out std_ulogic;  -- Chip Enable Output
        wei      : in  std_ulogic;  -- Write Enable Input
        weo      : out std_ulogic;  -- Write Enable Output
        rei      : in  std_ulogic;  -- Read Enable Input
        reo      : out std_ulogic;  -- Read Enable Output
        rdyi     : in  std_ulogic;  -- Ready Input
        rdyo     : out std_ulogic;  -- Ready Output
        bus_req  : out std_ulogic;  -- Bus Request 
        bus_gnt  : in  std_ulogic;  -- Bus Grant 
        bmoe     : out std_ulogic;  -- Bus Master Signals Output Enable
        bsoe     : out std_ulogic;  -- Bus Slave Signals Output Enable
        int      : out std_ulogic;  -- Interrupt
        reset    : in  std_ulogic;  -- Reset
        clk      : in  std_ulogic;  -- Clock
        clk_en   : in  std_ulogic;  -- Clock
        clk_sof  : in  std_ulogic;  -- SOF timer clock
        clken_12 : in  std_ulogic;  -- SOF timer clock
        dma_wrt_bdt_o : out std_ulogic;  -- DMA Write BDT Output
        dma_rd_bdt_o  : out std_ulogic;  -- DMA read BDT (4 bytes)
        dma_wrt_bdt_b0 : out std_ulogic;  -- _really_ writing BDT byte 0 now
        --  HUB controller interface signals
        pre_pid_det   : out std_ulogic; -- Low Speed Preamble PID detected.
        valid_sof_pid : out std_ulogic; -- Valid SOF PID detected
        sie_eop_out   : out std_ulogic;  -- SIE generated an EOP
        -- USB Interface signals
        host_mode_en : out std_ulogic;  -- enable embedded host if implemented
        host_wo_hub  : out  std_ulogic;  -- host without hub control
        low_speed_en : out std_ulogic; -- set USB communication to low speed
        suspnd   : out std_ulogic;  -- USB Suspend
        usboe    : out std_ulogic;  -- USB Output Enable 
        dpo      : out std_ulogic;  -- USB Data Plus Output
        dmo      : out std_ulogic;  -- USB Data Minus Output
        rcv      : in  std_ulogic;  -- USB Receive Data
        jstate   : in  std_ulogic;  -- synchronized jstate signal
        eop      : in  std_ulogic;  -- USB End of Packet
        se0      : in  std_ulogic;  -- USB single ended zero
        usb_en   : out std_ulogic;  -- USB pull up enable
        debug    : out std_ulogic_vector(15 downto 0)); -- Debug bus
end vusb;

architecture structure of vusb is

component fifo8xn
  PORT(clk	: IN  std_ulogic;	-- everything clocks on rising edge
       reset	: IN  std_ulogic;	-- reset active high
       load	: IN  std_ulogic;	-- write a byte
       unload	: IN  std_ulogic;	-- read a byte
       full	: OUT std_ulogic;	-- 1=FIFO is full
       full_1	: OUT std_ulogic;	-- 1=FIFO is almost full (1 byte free)
       empty	: OUT std_ulogic;	-- 1=FIFO is empty
       out_valid: OUT std_ulogic;	-- 1=DATA_OUT has valid data in it
       out_val_1: OUT std_ulogic;	-- 1=OUT_VALID 1 byte from the bottom
       data_in	: IN  std_ulogic_vector(7 DOWNTO 0); -- data bus in
       data_out	: OUT std_ulogic_vector(7 DOWNTO 0)); -- data bus in
end component;

component up_int
  port (-- Generic uProcessor Interface signals
        addri      : in  std_ulogic_vector(4 downto 0); -- Address Bus
        addro      : out std_ulogic_vector(15 downto 0); -- Address Bus
        dmadatai   : in  std_ulogic_vector(7 downto 0); -- DMA Data Bus In
        datai      : in  std_ulogic_vector(7 downto 0); -- Data Bus In
        datao      : out std_ulogic_vector(7 downto 0); -- Data Bus Out
        doe        : out std_ulogic;  -- Data Bus Output Enable
        cei        : in  std_ulogic;  -- Chip Enable Input
        ceo        : out std_ulogic;  -- Chip Enable Output
        wei        : in  std_ulogic;  -- Write Enable Input
        weo        : out std_ulogic;  -- Write Enable Output
        rei        : in  std_ulogic;  -- Read Enable Input
        reo        : out std_ulogic;  -- Read Enable Output
        rdyi       : in  std_ulogic;  -- Ready Input
        rdyo       : out std_ulogic;  -- Ready Output
        bus_req    : out std_ulogic;  -- Bus Request 
        bus_gnt    : in  std_ulogic;  -- Bus Grant 
        bmoe       : out std_ulogic;  -- Bus Master Signals Output Enable
        bsoe       : out std_ulogic;  -- Bus Slave Signals Output Enable
        int        : out std_ulogic;  -- Interrupt
        reset      : in  std_ulogic;  -- Reset
        clk        : in  std_ulogic;  -- Clock
        dma_wrt_bdt_o : out std_ulogic;  -- DMA Write BDT Output
        dma_rd_bdt_o  : out std_ulogic;  -- DMA read BDT (4 bytes)
        dma_wrt_bdt_b0 : out std_ulogic;  -- _really_ writing BDT byte 0 now
        -- Control/Data bus interface
        cdb_in     : in  std_ulogic_vector(45 downto 0); -- Control/Data bus in
        cdb_out    : out std_ulogic_vector(43 downto 0); -- Control/Data bus out
        rcv        : in  std_ulogic; -- USB data input
        se0        : in  std_ulogic; -- USB single ended zero
        host_mode_en : out std_ulogic;  -- enable embedded host if implemented
        host_wo_hub  : out std_ulogic;  -- host without hub control
        low_speed_req: out std_ulogic; -- set USB communication to low speed
        usb_en     : out std_ulogic;   -- USB pull up enable
        -- FIFO interfaces
        rx_empty   : in  std_ulogic;  -- Rx FIFO empty
        rx_valid_1 : in  std_ulogic;  -- Rx FIFO byte from the bottom
        rx_rdata   : in  std_ulogic_vector(7 downto 0);  -- Rx FIFO read data
        rx_re      : out std_ulogic;  -- Rx FIFO read enable
        rx_valid   : in  std_ulogic;  -- Rx FIFO has valid data in it 
        tx_full    : in  std_ulogic;  -- Tx FIFO full
        tx_full_1  : in  std_ulogic;  -- Tx FIFO is almost full (1 byte free)
        tx_wdata   : out std_ulogic_vector(7 downto 0);  -- Tx FIFO write data
        tx_we      : out std_ulogic;  -- Tx FIFO write enable
        tx_valid   : in  std_ulogic); -- Tx FIFO has valid data in it
end component;

component usb_sie
  port (clk      : in  std_ulogic;  -- Clock
        clk_en   : in  std_ulogic;  -- Clock enable
        clk_sof  : in  std_ulogic;  -- SOF timer clock
        clken_12 : in  std_ulogic;  -- SOF timer clock enable
        srst     : in  std_ulogic;  -- Synchronous reset
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
        sie_eop_out   : out std_ulogic;  -- SIE generated an EOP
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
        se0      : in  std_ulogic;  -- USB single ended zer0
        debug    : out std_ulogic_vector(15 downto 0)); -- Debug bus
end component;

signal cdb_in     : std_ulogic_vector(43 downto 0); -- Control/Data bus in
signal cdb_out    : std_ulogic_vector(45 downto 0); -- Control/Data bus out
signal low_speed_int : std_ulogic;-- set USB communication to low speed
signal low_speed_req : std_ulogic;-- request USB communication to low speed
signal host_mode_int : std_ulogic; -- enable embedded host if implemented
signal host_wo_hub_int : std_ulogic;  -- host without hub control
signal rx_valid_1 : std_ulogic; -- Rx FIFO byte from the bottom
signal rx_empty   : std_ulogic; -- Rx FIFO empty
signal rx_full    : std_ulogic; -- Rx FIFO full
signal rx_full_1  : std_ulogic; -- Rx FIFO is almost full (1 byte free)
signal rx_rdata   : std_ulogic_vector(7 downto 0); -- Rx FIFO read data
signal rx_re      : std_ulogic; -- Rx FIFO read enable
signal rx_valid   : std_ulogic; -- Rx FIFO has valid data in it
signal rx_wdata   : std_ulogic_vector(7 downto 0); -- Rx FIFO write data
signal rx_we      : std_ulogic; -- Rx FIFO write enable
signal tx_valid_1 : std_ulogic; -- Tx FIFO byte from the bottom
signal tx_empty   : std_ulogic; -- Tx FIFO empty
signal tx_full    : std_ulogic; -- Tx FIFO full
signal tx_full_1  : std_ulogic; -- Tx FIFO is almost full (1 byte free)
signal tx_rdata   : std_ulogic_vector(7 downto 0); -- Tx FIFO read data
signal tx_re      : std_ulogic; -- Tx FIFO read enable
signal tx_valid   : std_ulogic; -- Tx FIFO has valid data in it
signal tx_wdata   : std_ulogic_vector(7 downto 0); -- Tx FIFO write data
signal tx_we      : std_ulogic; -- Tx FIFO write enable
signal flush      : std_ulogic; -- FIFO flush enable
signal fifo_reset : std_ulogic; -- FIFO reset

begin

low_speed_en <= low_speed_int;
host_mode_en <= host_mode_int;    -- enable embedded host if implemented
host_wo_hub  <= host_wo_hub_int;  -- host without hub control

-- Implement the Generic uProcessor Interface
u1: up_int
  port map (
    addri      => addri,      -- Address Bus
    addro      => addro,      -- Address Bus
    dmadatai   => dmadatai,   -- DMA Data Bus In
    datai      => datai,      -- Data Bus In
    datao      => datao,      -- Data Bus Out
    doe        => doe,        -- Data Bus Output Enable
    cei        => cei,        -- Chip Enable Input
    ceo        => ceo,        -- Chip Enable Output
    wei        => wei,        -- Write Enable Input
    weo        => weo,        -- Write Enable Output
    rei        => rei,        -- Read Enable Input
    reo        => reo,        -- Read Enable Output
    rdyi       => rdyi,       -- Ready Input
    rdyo       => rdyo,       -- Ready Output
    bus_req    => bus_req,    -- Bus Request 
    bus_gnt    => bus_gnt,    -- Bus Grant 
    bmoe       => bmoe,       -- Bus Master Signals Output Enable
    bsoe       => bsoe,       -- Bus Slave Signals Output Enable
    int        => int,        -- Interrupt
    reset      => reset,      -- Reset
    clk        => clk,        -- Clock
    dma_wrt_bdt_o => dma_wrt_bdt_o, -- DMA Write BDT Output
    dma_rd_bdt_o  => dma_rd_bdt_o,  -- DMA read BDT (4 bytes)
    dma_wrt_bdt_b0 => dma_wrt_bdt_b0, -- DMA Write BDT Output
    cdb_in     => cdb_out,    -- Control/Data bus in
    cdb_out    => cdb_in,     -- Control/Data bus out
    rcv      => jstate,       -- USB Synchronized J-state
    se0      => se0,      -- USB single ended zero
    host_mode_en => host_mode_int,  -- enable embbeded host functions.
    host_wo_hub => host_wo_hub_int, -- allow a direcly connected low speed device
    low_speed_req => low_speed_req, -- USB low speed request
    usb_en     => usb_en,     -- USB pull up enable
    rx_empty   => rx_empty,   -- Rx FIFO empty
    rx_valid_1 => rx_valid_1, -- Rx FIFO byte from the bottom
    rx_rdata   => rx_rdata,   -- Rx FIFO read data
    rx_re      => rx_re,      -- Rx FIFO read enable
    rx_valid   => rx_valid,   -- Rx FIFO has valid data in it
    tx_full    => tx_full,    -- Tx FIFO full
    tx_full_1  => tx_full_1,  -- Tx FIFO is almost full (1 byte free)
    tx_wdata   => tx_wdata,   -- Tx FIFO write data
    tx_we      => tx_we,      -- Tx FIFO write enable
    tx_valid   => tx_valid);  -- Tx FIFO has valid data in it

u2: usb_sie
  port map (
    clk      => clk,      -- Clock
    clk_en   => clk_en,   -- Clock
    clk_sof  => clk_sof,  -- SOF timer clock
    clken_12 => clken_12, -- SOF timer clock enable
    srst     => reset,    -- Synchronous reset
    cdb_in   => cdb_in,   -- Control/Data bus in
    cdb_out  => cdb_out,  -- Control/Data bus out
    rx_full  => rx_full,  -- Rx FIFO full
    rx_wdata => rx_wdata, -- Rx FIFO write data
    rx_we    => rx_we,    -- Rx FIFO write enable
    tx_empty => tx_empty, -- Tx FIFO empty
    tx_rdata => tx_rdata, -- Tx FIFO read data
    tx_re    => tx_re,    -- Tx FIFO read enable
    tx_valid => tx_valid, -- Tx FIFO has valid data in it
    flush    => flush,    -- FIFO flush enable
    pre_pid_det   => pre_pid_det,  -- Low Speed Preamble PID detected.
    valid_sof_pid => valid_sof_pid,-- Valid SOF PID detected
    sie_eop_out   => sie_eop_out,  -- SIE generated an EOP
    host_mode_en => host_mode_int, -- enable embbeded host functions.
    host_wo_hub => host_wo_hub_int, -- allow a direcly connected low speed device
    low_speed_req => low_speed_req, -- USB low speed request
    low_speed_en => low_speed_int, -- USB Speed Control
    suspnd   => suspnd,   -- USB Suspend
    usboe    => usboe,    -- USB Output Enable 
    dpo      => dpo,      -- USB Data Plus Output
    dmo      => dmo,      -- USB Data Minus Output
    rcv      => rcv,      -- USB Receive Data
    jstate   => jstate,   -- synchronized jstate signal
    eop      => eop,      -- USB single ended zero
    se0      => se0,      -- USB single ended zero
    debug    => debug);   -- Debug bus

rxfifo: fifo8xn
  port map (
    clk       => clk,        -- everything clocks on rising edge
    reset     => fifo_reset, -- reset active high
    load      => rx_we,      -- write a byte
    unload    => rx_re,      -- read a byte
    full      => rx_full,    -- 1=FIFO is full
    full_1    => rx_full_1,  -- 1=FIFO is almost full (1 byte free)
    empty     => rx_empty,   -- 1=FIFO is empty
    out_valid => rx_valid,   -- 1=DATA_OUT has valid data in it
    out_val_1 => rx_valid_1, -- 1=OUT_VALID 1 byte from the bottom
    data_in   => rx_wdata,   -- data bus in
    data_out  => rx_rdata);  -- data bus in

txfifo: fifo8xn
  port map (
    clk       => clk,        -- everything clocks on rising edge
    reset     => fifo_reset, -- reset active high
    load      => tx_we,      -- write a byte
    unload    => tx_re,      -- read a byte
    full      => tx_full,    -- 1=FIFO is full
    full_1    => tx_full_1,  -- 1=FIFO is almost full (1 byte free)
    empty     => tx_empty,   -- 1=FIFO is empty
    out_valid => tx_valid,   -- 1=DATA_OUT has valid data in it
    out_val_1 => tx_valid_1, -- 1=OUT_VALID 1 byte from the bottom
    data_in   => dmadatai,   -- data bus in
    data_out  => tx_rdata);  -- data bus in

-- FIFO reset
-- We reset if reset is active or we must flush the contents of the fifo.
fifo_reset <= reset or flush;

end structure;
