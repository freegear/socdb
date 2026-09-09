--------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: vusb_top.vhd
--
-- Revision: $Name: REV9911b $
--
-- Description:
-- 	This is the Top level defintion of the VUSB Serial Interface Engine (SIE)
--	for the V8 Single Board Computer.  It contains the VUSB core,
--	the DPLL, and any interface logic required by the clock scheme used.
--                                                                              
-- Signals ending in _n are active low.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: vusb_top.vhd,v $
-- Revision 1.25  2000/01/03 16:28:22  chris
-- Added host_wo_hub signal.
--
-- Revision 1.24  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.23  1999/11/09 14:18:03  mark
-- ulogicified source - no functional changes
--
-- Revision 1.22  1999/11/01 22:13:36  scott
-- Added port for bridge to flush the write buffer
--
-- Revision 1.21  1999/08/05 21:24:09  chris
-- Added code to ensure that the doe is removed when readyo is asserted.
--
-- Revision 1.20  1999/06/23 20:18:43  chris
-- Added usb_en output to allow software to control device connect events.
--
-- Revision 1.19  1999/04/07 19:52:00  gregg
-- Modified the rcv_nrzi and high_speed signal to include the low_speed_dev
-- constant.
--
-- Revision 1.18  1999/04/01 20:47:07  meyers
-- added rst_cpu signal (to reset asynch. uP interface)
--
-- Revision 1.17  1999/01/29 15:16:04  john
-- Threaded eop_48_out to from dpll to top.
--
-- Revision 1.16  1998/08/18 20:57:57  chris
-- Removed sie_eop_out output.  It has been combined with fseop_det.
--
-- Revision 1.15  1998/06/23 18:43:26  chris
-- Added 12MHz clock enable for SOF timer.
--
-- Revision 1.14  1998/06/18 09:18:09  chris
-- Connected sie_eop_out signal in non-empty architectures.
--
-- Revision 1.13  1998/06/15 22:05:28  chris
-- Added syntax for Async or Sync reset inference.
--
-- Revision 1.12  1998/06/09 15:50:53  chris
-- Added embedded host controller enable (hc_en) output.
-- Moved the CEI address decode to the ASIC_V8 level of the hierarchy.
--
-- Revision 1.11  1998/06/02 13:47:45  chris
-- Corrected clock divide frequency and removed reset synchronizer.
--
-- Revision 1.10  1998/05/29 16:20:11  chris
-- Added signals for VUSB Hub.
--
-- Revision 1.9  1998/05/27 15:49:45  chris
-- Stubbed in Hub interface I/O's to support integration.
--
-- Revision 1.8  1998/03/26 21:47:12  chris
-- Added connections to allow processor reads of syncronized rcv signal.
--
-- Revision 1.7  1998/03/13 21:40:30  chris
-- Added Revision name.
--
-- Revision 1.6  1998/02/17 21:18:47  chris
-- Added host mode USB port connection.
--
-- Revision 1.5  1998/01/15 13:54:58  eric
-- Fixed clocking in the empty architecture.
--
-- Revision 1.4  1997/12/04 22:21:00  eric
-- Fixed empty architecture for conversion to verilog.
--
-- Revision 1.3  1997/11/20 14:35:16  chris
-- Added clocks to support write pulse generation and testbench.
--
-- Revision 1.2  1997/11/07 13:36:10  chris
-- Fleshed out alternate architectures, and added clock and
-- reset I/Os.
--
-- Revision 1.1  1997/10/31 21:04:16  chris
-- Initial revision
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
-- USE ieee.std_logic_arith.ALL;	-- + and - operators
use work.cfg_usb.all;

ENTITY vusb_top IS	-----------------------------ENTITY---------------------
  GENERIC(lsdev : integer := LOW_SPEED_DEV);
  PORT( 
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
        addri   : IN  std_ulogic_vector(15 DOWNTO 0); -- Address Bus
        addro   : OUT std_ulogic_vector(15 DOWNTO 0); -- Address Bus
	readi   : IN  std_ulogic;        -- read enable in
	reado   : OUT std_ulogic;        -- read enable out
	writei  : IN  std_ulogic;        -- write enable in 
	writeo  : OUT std_ulogic;        -- write enable out
        bmoe    : OUT std_ulogic;        -- Bus Master Signals Output Enable
	readyi  : IN  std_ulogic;        -- 0=insert wait states,1=run
	readyo  : OUT std_ulogic;        -- ready out
        bsoe    : OUT std_ulogic;        -- Bus Slave Signals Output Enable
        datai   : IN  std_ulogic_vector(7 DOWNTO 0); -- Data Bus In
        datao   : OUT std_ulogic_vector(7 DOWNTO 0); -- Data Bus Out
        doe     : OUT std_ulogic;        -- Data Bus Output Enable
	cei     : IN  std_ulogic;	-- hardware page chip enable
	int     : OUT std_ulogic;        -- sie interrupts
	bus_req : OUT std_ulogic;        -- sie bus request
	bus_gnt : IN  std_ulogic;        -- sie bug grant
        --  Hub interface
        hc_eno        : OUT std_ulogic;  -- Host controller enable
        pre_pid_det   : OUT std_ulogic;  -- Low Speed Preamble PID detected.
        valid_sof_pid : OUT std_ulogic;  -- Valid SOF PID detected
        lseop_det     : OUT std_ulogic;  -- Low Speed EOP detected
        fseop_det     : OUT std_ulogic;  -- Full Speed EOP detected
        eop_48_out    : OUT std_ulogic;  -- Eop detect sig from 48Mhz domain
        -- USB transceiver interfaces
	u_chan1i: IN  std_ulogic_vector(2 DOWNTO 0); -- USB interface
	u_chan1o: OUT std_ulogic_vector(4 DOWNTO 0); -- USB interface
	u_chan0i: IN  std_ulogic_vector(2 DOWNTO 0); -- USB interface
	u_chan0o: OUT std_ulogic_vector(4 DOWNTO 0); -- USB interface
        usb_en  : OUT std_ulogic;                    -- USB pull up enable
	debug   : OUT std_ulogic_vector(15 DOWNTO 0); -- debug bus
	-- signals used by the bridge as hints
        dma_wrt_bdt_o : out std_ulogic;  -- DMA Write BDT Output
        dma_rd_bdt_o  : out std_ulogic;  -- DMA read BDT (4 bytes)
        dma_wrt_bdt_b0 : out std_ulogic  -- DMA Write BDT Output byte zero

       );
END vusb_top;

ARCHITECTURE empty OF vusb_top IS -------------------Architecture empty --------

  signal clk_cnt         : std_ulogic_vector(1 downto 0);
  signal clk12           : std_ulogic;
  
BEGIN
  clken_dpllo   <= clk12;        -- DPLL output clock
  clken_12o     <= clk12;        -- DPLL clock / 4 (12MHz)
  addro		<= "0000000000000000";
  reado		<= '0';
  writeo	<= '0';
  bmoe		<= '0';
  bsoe		<= '0';
  readyo	<= '1';
  datao		<= "00000000";
  int		<= '0';
  bus_req	<= '0';
  doe		<= '0';
  u_chan0o	<= "00001"; 
  debug		<= "0000000000000000";
  pre_pid_det   <= '0';-- Low Speed Preamble PID detected.
  valid_sof_pid <= '0';-- Valid SOF PID detected
  lseop_det     <= '0';-- Low Speed EOP detected
  fseop_det     <= '0';-- Full Speed EOP detected
  hc_eno        <= '0';-- host controller enable.
  clk12 <= clk_cnt(1);
  dma_wrt_bdt_o <= '0'; -- DMA Write BDT Output
  dma_rd_bdt_o  <= '0'; -- DMA read BDT (4 bytes)
  dma_wrt_bdt_b0<= '0'; -- DMA Write BDT Output
  
--vasync_rst   clk_dvd: PROCESS (clk48i,rst_raw_n)
  clk_dvd: PROCESS (clk48i)
    
  BEGIN -- clk_dvd
    --vasync_rst if rst_raw_n = '0' then
    if clk48i'event AND clk48i = '1' then --vsync_rst
      
      IF rst_raw_n = '0' then --vsync_rst
        clk_cnt <= "00";
      else --vsync_rst
      --vasync_rst elsif clk48i'event and clk48i = '1' then
        clk_cnt <= std_ulogic_vector(unsigned(clk_cnt) + 1);
      end if; --vsync_rst

    end if;
    
  END PROCESS clk_dvd;
  
END empty;

ARCHITECTURE sync OF vusb_top IS -------------------Architecture empty --------
COMPONENT vusb
  PORT (-- Generic uProcessor Interface signals
        addri    : IN  std_ulogic_vector(4 DOWNTO 0); -- Address Bus
        addro    : OUT std_ulogic_vector(15 DOWNTO 0); -- Address Bus
        dmadatai : IN  std_ulogic_vector(7 DOWNTO 0); -- DMA Data Bus In
        datai    : IN  std_ulogic_vector(7 DOWNTO 0); -- Data Bus In
        datao    : OUT std_ulogic_vector(7 DOWNTO 0); -- Data Bus Out
        doe      : OUT std_ulogic;  -- Data Bus Output Enable
        cei      : IN  std_ulogic;  -- Chip Enable Input
        ceo      : OUT std_ulogic;  -- Chip Enable Output
        wei      : IN  std_ulogic;  -- Write Enable Input
        weo      : OUT std_ulogic;  -- Write Enable Output
        rei      : IN  std_ulogic;  -- Read Enable Input
        reo      : OUT std_ulogic;  -- Read Enable Output
        rdyi     : IN  std_ulogic;  -- Ready Input
        rdyo     : OUT std_ulogic;  -- Ready Output
        bus_req  : OUT std_ulogic;  -- Bus Request 
        bus_gnt  : IN  std_ulogic;  -- Bus Grant 
        bmoe     : OUT std_ulogic;  -- Bus Master Signals Output Enable
        bsoe     : OUT std_ulogic;  -- Bus Slave Signals Output Enable
        int      : OUT std_ulogic;  -- Interrupt
        reset    : IN  std_ulogic;  -- Reset
        clk      : IN  std_ulogic;  -- Clock
        clk_en   : IN  std_ulogic;  -- SIE clock enable
        clk_sof  : IN  std_ulogic;  -- SOF timer clock
        clken_12 : IN  std_ulogic;  -- SOF timer clock
        dma_wrt_bdt_o : out std_ulogic;  -- DMA Write BDT Output
        dma_rd_bdt_o  : out std_ulogic;  -- DMA read BDT (4 bytes)
        dma_wrt_bdt_b0 : out std_ulogic;  -- DMA Write BDT Output byte 0
        --  HUB controller interface signals
        pre_pid_det   : OUT std_ulogic; -- Low Speed Preamble PID detected.
        valid_sof_pid : OUT std_ulogic; -- Valid SOF PID detected
        sie_eop_out   : OUT std_ulogic;  -- SIE generated an EOP
        -- USB Interface signals
        host_mode_en : OUT std_ulogic;  -- Enable embedded host if implemented
        host_wo_hub  : OUT std_ulogic;  -- host without hub control
        low_speed_en : OUT std_ulogic;  -- USB Speed Indicator
        suspnd   : OUT std_ulogic;  -- USB Suspend
        usboe    : OUT std_ulogic;  -- USB Output Enable 
        dpo      : OUT std_ulogic;  -- USB Data Plus Output
        dmo      : OUT std_ulogic;  -- USB Data Minus Output
        rcv      : IN  std_ulogic;  -- USB Receive Data
        jstate   : IN  std_ulogic;  -- synchronized jstate signal
        eop      : IN  std_ulogic;  -- USB end of packet detect
        se0      : IN  std_ulogic;  -- USB single ended zero
        usb_en   : OUT std_ulogic;  -- USB pull up enable
    debug    : OUT std_ulogic_vector(15 DOWNTO 0)); -- Debug bus
END COMPONENT;

COMPONENT dpllnrzi
  PORT (clk     : IN  std_ulogic;  -- high speed clock - 8x data rate
        datain  : IN  std_ulogic;  -- NRZI encoded serial data/clock in
       	dplus   : IN  std_ulogic;  -- USB positive data
      	dminus  : IN  std_ulogic;  -- USB negative data
        reset   : IN  std_ulogic;  -- reset the PLL. CLKOUT stops.
        low_speed_en: IN std_ulogic;-- USB speed control
        host_wo_hub : IN std_ulogic;  -- host without hub control
        clken_dpll : out std_ulogic;  -- clock enable output
        clken_12 : out std_ulogic;  -- fixed clock divided by 4 clock enable.
        dataout : OUT std_ulogic;  -- NRZ serial data out
        rcvout  : out std_ulogic;  -- synchronized jstate signal
        eop     : OUT std_ulogic;  -- End Of Packet
        se0 	: OUT std_ulogic;  -- single ended zero
        sie_eop_out   : IN std_ulogic;  -- SIE generated an EOP
        eop_48_out: OUT std_ulogic;  -- Eop detect sig from 48Mhz domain
        lseop_det : out std_ulogic;  -- Low Speed EOP detected
        fseop_det : out std_ulogic   -- Full Speed EOP detected
      );
END COMPONENT;

SIGNAL reset_to_dpll : std_ulogic;  -- Reset only to the DPLL
SIGNAL reset         : std_ulogic;  -- Synchronous to clk_sie reset
SIGNAL rst_count     : std_ulogic_vector(3 DOWNTO 0);	-- reset counter
SIGNAL clk_en12      : std_ulogic;  -- 12MHz Clock enable output

-- USB Interface signals
SIGNAL hc_en    : std_ulogic;  -- USB embedded host controller enable
SIGNAL host_mode_en  : std_ulogic;  -- embedded host controller enable
SIGNAL host_wo_hub  : std_ulogic;  -- embedded host without hub control
SIGNAL low_speed_en : std_ulogic;  -- USB Speed Indicator
SIGNAL high_speed   : std_ulogic;  -- USB Speed Indicator
SIGNAL suspnd   : std_ulogic;  -- USB Suspend
SIGNAL usboe    : std_ulogic;  -- USB Output Enable 
SIGNAL dpo      : std_ulogic;  -- USB Data Plus Output
SIGNAL dmo      : std_ulogic;  -- USB Data Minus Output
SIGNAL rcv_data : std_ulogic;  -- USB Receive Data in
SIGNAL rcv_nrzi : std_ulogic;  -- USB Receive Data NRZI
SIGNAL rcv_nrz  : std_ulogic;  -- USB Receive Data NRZ
SIGNAL jstate   : std_ulogic;  -- USB Synchronized Jstate
SIGNAL dpi      : std_ulogic;  -- USB Data Plus In
SIGNAL dmi      : std_ulogic;  -- USB Data Minus IN
SIGNAL eop      : std_ulogic;  -- USB single ended zero
SIGNAL se0      : std_ulogic;  -- USB single ended zero
SIGNAL sie_eop_out : std_ulogic;  -- SIE generated an EOP

-- Debug bus for internal signals
SIGNAL debug_int : std_ulogic_vector(15 DOWNTO 0); 

BEGIN
  hc_eno <= hc_en; 
  hc_en  <= IMPLEMENT_EMBEDED_HOST and host_mode_en;

-- Implement VUSB core
usb: vusb
  PORT MAP (
    addri    => addri(4 DOWNTO 0),-- Address Bus
    addro    => addro,    -- Address Bus
    dmadatai => datai,    -- DMA Data Bus In
    datai    => datai,    -- Data Bus In
    datao    => datao,    -- Data Bus Out
    doe      => doe,      -- Data Bus Output Enable
    cei      => cei,      -- Chip Enable Input
    ceo      => OPEN,     -- Chip Enable Output
    wei      => writei,   -- Write Enable Input
    weo      => writeo,   -- Write Enable Output
    rei      => readi,    -- Read Enable Input
    reo      => reado,    -- Read Enable Output
    rdyi     => readyi,   -- Ready Input
    rdyo     => readyo,   -- Ready Output
    bus_req  => bus_req,  -- Bus Request 
    bus_gnt  => bus_gnt,  -- Bus Grant 
    bmoe     => bmoe,     -- Bus Master Signals Output Enable
    bsoe     => bsoe,     -- Bus Slave Signals Output Enable
    int      => int,      -- Interrupt
    reset    => rst_sie,    -- Synchronous reset
    clk      => clk_sie,  -- Clock
    clk_en   => clken_sie,-- Clock enable
    clk_sof  => clk_cpu,  -- SOF timer clock
    clken_12 => clken_12, -- SOF timer clock enable
    dma_wrt_bdt_o => dma_wrt_bdt_o, -- DMA Write BDT Output
    dma_rd_bdt_o => dma_rd_bdt_o,   -- DMA read BDT (4 bytes)
    dma_wrt_bdt_b0 => dma_wrt_bdt_b0, -- DMA Write BDT Output byte 0
    --  HUB controller interface signals
    pre_pid_det   => pre_pid_det,-- Low Speed Preamble PID detected.
    valid_sof_pid => valid_sof_pid,-- Valid SOF PID detected
    sie_eop_out   => sie_eop_out,  -- SIE generated an EOP
    host_mode_en => host_mode_en, -- enable embedded host functions
    host_wo_hub => host_wo_hub,   -- allow a direcly connected low speed device
    low_speed_en => low_speed_en, -- USB Speed Indicator
    suspnd   => suspnd,   -- USB Suspend
    usboe    => usboe,    -- USB Output Enable 
    dpo      => dpo,      -- USB Data Plus Output
    dmo      => dmo,      -- USB Data Minus Output
    rcv      => rcv_nrz,  -- USB Receive Data
    jstate   => jstate,   -- synchronized jstate signal
    eop      => eop,      -- USB end of packet
    se0      => se0,      -- USB single ended zero detect
    usb_en   => usb_en,   -- USB pull up enable
    debug    => debug_int); -- Debug bus

-- Implement DPLL
pll: dpllnrzi
  PORT MAP (
    clk     => clk48i,    -- high speed clock - 8x data rate
    datain  => rcv_nrzi,  -- NRZI encoded serial data/clock in
    dplus   => dpi,   	  -- USB Data plus
    dminus  => dmi,   	  -- USB Data plus
    dataout => rcv_nrz,   -- NRZ serial data out
    rcvout  => jstate,    -- synchronized jstate signal
    eop     => eop,       -- end of packet
    low_speed_en => low_speed_en,-- USB speed control
    host_wo_hub => host_wo_hub,  -- host without hub control
    clken_dpll  => clken_dpllo,-- clock enable output
    clken_12=> clken_12o,    -- clock divided by 4 clock enable output
    reset   => reset_to_dpll,-- reset the PLL. CLKOUT stops.
    se0     => se0,          -- single ended zero
    sie_eop_out   => sie_eop_out,  -- SIE generated an EOP
    lseop_det  => lseop_det, -- Low Speed EOP detected
    eop_48_out => eop_48_out, -- EOP detect on 48 Mhz domain
    fseop_det  => fseop_det);-- Full Speed EOP detected
      
reset_to_dpll <= NOT rst_raw_n;

--------------------------------------------------------------------------------
-- Implement I/Os
--------------------------------------------------------------------------------


-- USB interface channel0 inpout buffers
rcv_data <= u_chan0i(0) when hc_en = '0' else u_chan1i(0); 
dpi      <= u_chan0i(1) when hc_en = '0' else u_chan1i(1);
dmi      <= u_chan0i(2) when hc_en = '0' else u_chan1i(2);

-- To prevent the DPLL from screwing up during tranmission mask with usboe
rcv_nrzi <= '0' WHEN usboe = '1' AND (lsdev = 1 OR low_speed_en = '1')
	    else '1' WHEN usboe = '1'
	    else rcv_data;
high_speed <= '0' WHEN lsdev = 1 ELSE NOT low_speed_en;

-- USB interface channel1 output buffers (embedded host)
u_chan1o <= dmo & dpo & high_speed & suspnd & NOT (usboe and hc_en);
-- USB interface channel0 output buffers (target)
u_chan0o <= dmo & dpo & high_speed & suspnd & NOT (usboe and not hc_en);

debug(15 DOWNTO 0) <= debug_int;

END sync;

ARCHITECTURE async OF vusb_top IS -------------------Architecture usb-----------

COMPONENT vusb
  PORT (-- Generic uProcessor Interface signals
        addri    : IN  std_ulogic_vector(4 DOWNTO 0); -- Address Bus
        addro    : OUT std_ulogic_vector(15 DOWNTO 0); -- Address Bus
        dmadatai : IN  std_ulogic_vector(7 DOWNTO 0); -- DMA Data Bus In
        datai    : IN  std_ulogic_vector(7 DOWNTO 0); -- Data Bus In
        datao    : OUT std_ulogic_vector(7 DOWNTO 0); -- Data Bus Out
        doe      : OUT std_ulogic;  -- Data Bus Output Enable
        cei      : IN  std_ulogic;  -- Chip Enable Input
        ceo      : OUT std_ulogic;  -- Chip Enable Output
        wei      : IN  std_ulogic;  -- Write Enable Input
        weo      : OUT std_ulogic;  -- Write Enable Output
        rei      : IN  std_ulogic;  -- Read Enable Input
        reo      : OUT std_ulogic;  -- Read Enable Output
        rdyi     : IN  std_ulogic;  -- Ready Input
        rdyo     : OUT std_ulogic;  -- Ready Output
        bus_req  : OUT std_ulogic;  -- Bus Request 
        bus_gnt  : IN  std_ulogic;  -- Bus Grant 
        bmoe     : OUT std_ulogic;  -- Bus Master Signals Output Enable
        bsoe     : OUT std_ulogic;  -- Bus Slave Signals Output Enable
        int      : OUT std_ulogic;  -- Interrupt
        reset    : IN  std_ulogic;  -- Reset
        clk      : IN  std_ulogic;  -- Clock
        clk_en   : IN  std_ulogic;  -- SIE clock enable
        clk_sof  : IN  std_ulogic;  -- SOF timer clock
        clken_12 : IN  std_ulogic;  -- SOF timer clock enable
        dma_wrt_bdt_o : out std_ulogic;  -- DMA Write BDT Output
        dma_rd_bdt_o  : out std_ulogic;  -- DMA read BDT (4 bytes)
        dma_wrt_bdt_b0 : out std_ulogic;  -- DMA Write BDT Output byte 0

        --  HUB controller interface signals
        pre_pid_det   : OUT std_ulogic; -- Low Speed Preamble PID detected.
        valid_sof_pid : OUT std_ulogic; -- Valid SOF PID detected
        sie_eop_out   : OUT std_ulogic;  -- SIE generated an EOP
        -- USB Interface signals
        host_mode_en : OUT std_ulogic;  -- Enable embedded host if implemented
        host_wo_hub  : OUT std_ulogic;  -- host without hub control
        low_speed_en : OUT std_ulogic;  -- USB Speed Indicator
        suspnd   : OUT std_ulogic;  -- USB Suspend
        usboe    : OUT std_ulogic;  -- USB Output Enable 
        dpo      : OUT std_ulogic;  -- USB Data Plus Output
        dmo      : OUT std_ulogic;  -- USB Data Minus Output
        rcv      : IN  std_ulogic;  -- USB Receive Data
        jstate   : IN std_ulogic;  -- synchronized jstate signal
        eop      : IN  std_ulogic;  -- USB end of packet detect
        se0      : IN  std_ulogic;  -- USB single ended zero
        usb_en   : OUT std_ulogic; -- USB pull up enable
        debug    : OUT std_ulogic_vector(15 DOWNTO 0)); -- Debug bus
END COMPONENT;

COMPONENT dpllnrzi
  PORT (clk     : IN  std_ulogic;  -- high speed clock - 8x data rate
        datain  : IN  std_ulogic;  -- NRZI encoded serial data/clock in
       	dplus   : IN  std_ulogic;  -- USB positive data
      	dminus  : IN  std_ulogic;  -- USB negative data
        low_speed_en: IN std_ulogic;-- USB speed control
        host_wo_hub : IN std_ulogic;  -- host without hub control
        reset   : IN  std_ulogic;  -- reset the PLL. CLKOUT stops.
        clken_dpll: OUT std_ulogic;  -- clock enable output
        clken_12: OUT std_ulogic;  -- fixed clock divided by 4 clock enable.
        dataout : OUT std_ulogic;  -- NRZ serial data out
        rcvout  : out std_ulogic;  -- synchronized jstate signal
        eop     : OUT std_ulogic;  -- End Of Packet
        se0 	: OUT std_ulogic; -- single ended zero
        sie_eop_out   : IN std_ulogic;  -- SIE generated an EOP
        lseop_det : OUT std_ulogic;  -- Low Speed EOP detected
        eop_48_out: OUT std_ulogic;  -- Eop detect sig from 48Mhz domain
        fseop_det : OUT std_ulogic   -- Full Speed EOP detected
      );
END COMPONENT;


SIGNAL reset_to_dpll : std_ulogic;  -- Reset only to the DPLL
SIGNAL reset         : std_ulogic;  -- Synchronous to uclk reset
SIGNAL rst_count     : std_ulogic_vector(3 DOWNTO 0);	-- reset counter
SIGNAL clk_en12      : std_ulogic;  -- 12MHz Clock enable output

-- USB Interface signals
SIGNAL hc_en    : std_ulogic;  -- USB embedded host controller enable
SIGNAL host_mode_en  : std_ulogic; -- embedded host controller enable
SIGNAL host_wo_hub  : std_ulogic;  -- embedded host without hub control
SIGNAL low_speed_en : std_ulogic;  -- USB Speed Indicator
SIGNAL high_speed   : std_ulogic;  -- USB Speed Indicator
SIGNAL suspnd   : std_ulogic;  -- USB Suspend
SIGNAL usboe    : std_ulogic;  -- USB Output Enable 
SIGNAL dpo      : std_ulogic;  -- USB Data Plus Output
SIGNAL dmo      : std_ulogic;  -- USB Data Minus Output
SIGNAL rcv_data : std_ulogic;  -- USB Receive Data in
SIGNAL rcv_nrzi : std_ulogic;  -- USB Receive Data NRZI
SIGNAL rcv_nrz  : std_ulogic;  -- USB Receive Data NRZ
SIGNAL jstate   : std_ulogic;  -- USB Synchronized Jstate
SIGNAL dpi      : std_ulogic;  -- USB Data Plus In
SIGNAL dmi      : std_ulogic;  -- USB Data Minus IN
SIGNAL eop      : std_ulogic;  -- USB single ended zero
SIGNAL se0      : std_ulogic;  -- USB single ended zero
SIGNAL sie_eop_out : std_ulogic;  -- SIE generated an EOP

-- Asynchronous interface signals
SIGNAL addri_f   : std_ulogic_vector(4 DOWNTO 0);  -- registered version of address in
SIGNAL datai_f   : std_ulogic_vector(7 DOWNTO 0);  -- registered version of data in
SIGNAL cei_f     : std_ulogic;  -- registered version of the chip enable
SIGNAL writei_f  : std_ulogic;  -- registered version of the write
SIGNAL readi_f   : std_ulogic;  -- registered version of the ready
SIGNAL ceicpu    : std_ulogic;  -- registered version of the chip enable (cpu clock) 
SIGNAL ceicputog : std_ulogic;  -- toggle version of the chip enable (cpu clock)
SIGNAL ceitog_fff: std_ulogic;  -- chip enable toggle delayed 2 r. edges of clock
SIGNAL ceitog_ff : std_ulogic;  -- chip enable toggle delayed 1 r. edge of clock
SIGNAL ceitog_f  : std_ulogic;  -- chip enable toggle delayed 1 f. edge of clock
SIGNAL rdytog_f  : std_ulogic;  -- Ready enable toggle delayed 2 r. edges of cpu clock
SIGNAL rdytog_ff : std_ulogic;  -- Ready enable toggle delayed 1 r. edge of cpu clock
SIGNAL rdytog_fff: std_ulogic;  -- Ready enable toggle delayed 1 f. edge of cpu clock
SIGNAL slde      : std_ulogic;  -- Synced load enable
SIGNAL datao_f   : std_ulogic_vector(7 DOWNTO 0); -- Data Bus Out register
SIGNAL datao_lcl : std_ulogic_vector(7 DOWNTO 0);  -- local copy of data out reg
SIGNAL bmoe_lcl  : std_ulogic;  -- local copy of bus master output enable
SIGNAL bsoe_lcl  : std_ulogic;  -- local copy of bus slave output enable
SIGNAL weo_lcl   : std_ulogic;  -- local copy of bus master write enable
SIGNAL bus_gnt_f, bus_gnt_ff :std_ulogic;  -- Bus Grant synchronization.
SIGNAL bus_req_lcl           :std_ulogic;  -- Bus Request local copy
SIGNAL bus_req_f, bus_req_ff :std_ulogic;  -- Bus Request synchronization.

-- Debug bus for internal signals
SIGNAL debug_int : std_ulogic_vector(15 DOWNTO 0); 

BEGIN
  hc_eno <= hc_en; 
  hc_en  <= IMPLEMENT_EMBEDED_HOST and host_mode_en;

-- assign the data read register to the output.
datao <= datao_lcl;

-- assign the bus master output enable to the output.
bmoe  <= bmoe_lcl;   

-- Implement VUSB core
usb: vusb
  PORT MAP (
    addri    => addri_f,  -- Address Bus
    addro    => addro,    -- Address Bus
    dmadatai => datai,    -- DMA Data Bus In
    datai    => datai_f,  -- Data Bus In
    datao    => datao_lcl,-- Data Bus Out
    doe      => OPEN,     -- Data Bus Output Enable
    cei      => cei_f,    -- Chip Enable Input
    ceo      => OPEN,     -- Chip Enable Output
    wei      => slde,     -- Write Enable Input
    weo      => weo_lcl,  -- Write Enable Output
    rei      => readi_f,  -- Read Enable Input
    reo      => reado,    -- Read Enable Output
    rdyi     => readyi,   -- Ready Input
    rdyo     => OPEN,     -- Ready Output (generated locally)
    bus_req  => bus_req_lcl, -- Bus Request 
    bus_gnt  => bus_gnt_ff,-- Bus Grant 
    bmoe     => bmoe_lcl, -- Bus Master Signals Output Enable
    bsoe     => OPEN,     -- Bus Slave Output Enable is generated locally for
                          -- the async architecture.
    int      => int,      -- Interrupt
    reset    => rst_sie,    -- Synchronous reset
    clk      => clk_sie,    -- Clock
    clk_en   => clken_sie,  -- USB DPLL clock enable 
    clk_sof  => clk_cpu,    -- SOF timer clock
    clken_12 => clken_12,   -- SOF timer clock enable
    --  HUB controller interface signals
    pre_pid_det   => pre_pid_det,-- Low Speed Preamble PID detected.
    valid_sof_pid => valid_sof_pid,-- Valid SOF PID detected
    sie_eop_out   => sie_eop_out,  -- SIE generated an EOP
    host_mode_en => host_mode_en, -- enable embedded host functions
    host_wo_hub => host_wo_hub,  -- host without hub control
    low_speed_en => low_speed_en,    -- USB Speed Indicator
    suspnd   => suspnd,   -- USB Suspend
    usboe    => usboe,    -- USB Output Enable 
    dpo      => dpo,      -- USB Data Plus Output
    dmo      => dmo,      -- USB Data Minus Output
    rcv      => rcv_nrz,  -- USB Receive Data
    jstate   => jstate,   -- synchronized jstate signal
    eop      => eop,      -- USB end of packet
    se0      => se0,      -- USB single ended zero detect
    usb_en   => usb_en,   -- USB pull up enable
    debug    => debug_int); -- Debug bus

-- Implement DPLL
pll: dpllnrzi
  PORT MAP (
    clk     => clk48i,    -- high speed clock - 8x data rate
    datain  => rcv_nrzi,  -- NRZI encoded serial data/clock in
    dplus   => dpi,   	  -- USB Data plus
    dminus  => dmi,   	  -- USB Data plus
    low_speed_en => low_speed_en,-- USB speed control
    host_wo_hub => host_wo_hub,  -- host without hub control
    reset   => reset_to_dpll, -- reset the PLL. CLKOUT stops.
    clken_dpll => clken_dpllo,-- clock enable output
    clken_12=> clken_12o,      -- clock divided by 4 clock enable output
    dataout => rcv_nrz,   -- NRZ serial data out
    rcvout  => jstate,    -- synchronized jstate signal
    eop     => eop,       -- end of packet
    se0     => se0,           -- single ended zero
    sie_eop_out   => sie_eop_out,  -- SIE generated an EOP
    lseop_det  => lseop_det,  -- Low Speed EOP detected
    eop_48_out => eop_48_out, -- EOP detect on 48 Mhz domain
    fseop_det  => fseop_det); -- Full Speed EOP detected

reset_to_dpll <= NOT rst_raw_n;

--------------------------------------------------------------------------------
--
-- Asynchronous Processor Interface Read/Write Timing:
--
-- Cpu Clock Domain:
--
--           __    __1   __2   __3   __4   __    __    __    
--  cpuclk _/  \__/  \__/  \__/  \__/  \__/  \__/  \__/  \__/
--           ___________________________________
--     cei _/                                   \___________
--           ___________________________________
--   write _/  Read = 0; Write = 1              \___________
--          ________________________________________________
--   addri X____________________________________X___________
--                 _____
--  ceicpu _______/     \___________________________________
--         _______
-- ceicput        \_________________________________________
--         _____________________________
-- rdytogf                          	\___________________
--         _______________________________
-- rdytogff                               \_________________
--          ____________________________________
-- rdytoffff                                    \___________
--                                         _____
-- readyo  _______________________________/     \___________


-- Usb Clock Domain:
--           ___     ___     ___     ___     ___     ___
--      clk /   \___/   \___/   \___/   \___/   \___/   \___
--          ____________
--  ceitogf             \___________________________________
--          ________________
-- ceitogff                 \_______________________________
--          ________________________
-- ceitogfff                        \_______________________
--                           _______
--     slde ________________/       \_______________________
--
-------------------------------------------------------------------------------
-- Implements rising edge synchronization flip flops
-------------------------------------------------------------------------------
re_ffs: PROCESS (clk_sie)
BEGIN

if clk_sie'event AND (clk_sie = '1') then
  	
  -- All signals into the VUSB must be synchronous
  addri_f <= addri(4 DOWNTO 0);

  -- Input side of the data bus bi-directional buffers
  datai_f <= datai;

  -- We continuously latch the readback data into a holding register
  -- until cei has been flopped and 
  datao_f <= datao_lcl; -- Load register with datao when no reads in progress

  -- SIE chip enable must be synchronized before sent to VUSB.
  cei_f  <= to_x01(cei);

  -- Input 4-cycle write enable for sie.
  writei_f <= writei;

  -- Input side of output enable bi-directional buffer
  readi_f <= readi;

end if; --clk_sie

END PROCESS re_ffs;

clk_sie_falling: PROCESS (clk_sie)
BEGIN
  IF clk_sie'event AND clk_sie = '0' THEN
    bus_gnt_f <= bus_gnt; -- move bus grant into a metasability
                          -- protection register.
    ceitog_f <= ceicputog;-- metastability protection for ce toggle
  END IF;
END PROCESS clk_sie_falling;

clk_sie_rising: PROCESS (clk_sie)
BEGIN
  IF clk_sie'event AND clk_sie = '1' THEN
    bus_gnt_ff <= bus_gnt_f;  -- synchronize the bus grant to the usb clock
    ceitog_fff <= ceitog_ff;  -- Load enable toggle sync to 2nd edge of clock
    ceitog_ff <= ceitog_f;    -- Load enable toggle sync to 1st edge of clock
  END IF;
END PROCESS clk_sie_rising;

pclk_falling: PROCESS (clk_cpu)
BEGIN
  IF clk_cpu'event AND clk_cpu = '0' THEN
    bus_req_f <= bus_req_lcl; -- move bus requet into a metasability
                              -- protection register.
    rdytog_f <= ceitog_fff;   -- ready toggle metastability protection
  END IF;
END PROCESS pclk_falling;

pclk_rising: PROCESS (clk_cpu)
BEGIN
  IF clk_cpu'event AND clk_cpu = '1' THEN
    bus_req <= bus_req_f;     -- synchronize the bus request to the 
                              -- processor clock
    rdytog_ff <= rdytog_f;    -- ready toggle sync 1st clock edge
    rdytog_fff <= rdytog_ff;  -- ready toggle sync 2nd clock edge
    IF rst_cpu = '1' THEN
      ceicpu <= '0';
      ceicputog <= '0';
      bsoe_lcl <= '0';
    ELSE
      ceicpu <= cei;			-- chip enable register
      IF cei = '1' AND ceicpu = '0' THEN
	ceicputog <= NOT ceicputog;  	-- chip enable edge detect toggle
					-- register to start the toggle chain
      END IF;
      -- the bus slave output enable is latched when a slave read is intiated,
      -- and is cleared at the end of the cycle on readyo
      IF  (rdytog_fff XOR rdytog_ff) = '1' THEN  -- this is readyo clearing
        bsoe_lcl <= '0';         -- the bsoe is higher priority than setting it.
      ELSIF  cei = '1' AND ceicpu = '0' THEN  -- set the bsoe on the start
        bsoe_lcl <= readi AND NOT bus_gnt;  -- of a slave read cycle
      END IF;
    END IF;
  END IF;                                                   
END PROCESS pclk_rising;

-- generate sync. load enable to VUSB registers on toggle event
slde <= (ceitog_fff XOR ceitog_ff) AND writei_f;

-- generate a ready back to the processor on toggle event
readyo <= rdytog_fff XOR rdytog_ff;

--the data output enable is true for master writes and slave reads
doe <= bsoe_lcl OR weo_lcl;
writeo <= weo_lcl;

--------------------------------------------------------------------------------
-- Implement I/Os
--------------------------------------------------------------------------------


-- USB interface channel0 input buffers
rcv_data <= u_chan0i(0) when hc_en = '0' else u_chan1i(0); 
dpi      <= u_chan0i(1) when hc_en = '0' else u_chan1i(1);
dmi      <= u_chan0i(2) when hc_en = '0' else u_chan1i(2);

-- To prevent the DPLL from screwing up during tranmission mask with usboe
rcv_nrzi <= '0' WHEN usboe = '1' AND (lsdev = 1 OR low_speed_en = '1')
	    else '1' WHEN usboe = '1'
	    else rcv_data;

high_speed <= '0' WHEN lsdev = 1 else NOT low_speed_en;

-- USB interface channel1 output buffers (embedded host)
u_chan1o <= dmo & dpo & high_speed & suspnd & NOT (usboe and hc_en);
-- USB interface channel0 output buffers (target)
u_chan0o <= dmo & dpo & high_speed & suspnd & NOT (usboe and not hc_en);

debug(15 DOWNTO 0) <= debug_int;

END async;
