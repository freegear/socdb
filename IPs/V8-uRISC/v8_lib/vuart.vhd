-----------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH HTTP://WWW.VAutomation.com 
-- ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: vuart.vhd
-- Revision: $Name: REV9910 $
-- Gate Count:	about 1200 gates
-- Description:
-- 	Simple UART with an integrated BAUD rate generator. 
--	Only supports ASYNC, 8 data, 1 stop, no parity. 
--	All flip-flops clock on the rising edge of CLK.
--	The CPU interface is fully synchronous. The control signals are
--	active high and are expected to be active for only 1 CLK.
--
--	A single interrupt is output with two seperate interrupt enable bits
--	in the STATUS register. If TXENB=1 then when TXEMPTY=1 the interrupt
--	line will be active. TXEMPTY is cleared by writing to the DataTX
--	register.  if RXENB=1 then when RXFULL or RXOFLO or RXFRAM=1, then
--	the interrupt line is active.  RXFULL is cleated to zero when the
--	DataRX register is read.  RXOFLO and RXFRAM are set by hardware but
--	must be written with zero by software to clear the bit.
--
-- Register Definition:
-- addr	Name	R/W	Description
--  0   DataRx	R	RX data register
--  0   DataTx	W	TX data register
--  1   STATUS	R/W	Status register
--			STATUS[7]=TXEMPTY (read only)
--			TX holding register empty
--			1=DataTX register is empty and can be writen to.
--			0=DataTX is full, do not write data
--			STATUS[6]=TXENB
--			1=TXEMPTY=1 will interrupt, 0=masked
--			STATUS[3]=RXFULL (read only)
--			RX holding register full
--			1=DataRX has data to be read
--			0=No data available. Cleared to zero automatically
--			when DataRX is read.
--			STATUS[2]=RXENB
--			1=RXFULL or RXOFLO or RXFRAM=1 will interrupt, 0=masked
--			STATUS[1]=RXOFLO - RX Data Overflow
--			Set to 1 when a character has been received but 
--			RXFULL is still 1.
--			STATUS[0]=RXFRAM - RX Framing Error
--			Set to 1 when a stop bit was not detected.
--  2   BAUDL	W	Baud rate register [7:0]  (write only)
--  3   BAUDH	W	Baud rate register [15:8] (write only)
--			BAUD register values are computed as:
--			BAUD=(CLK freq/(BAUD*4))-1. EX: If CLK=12Mhz and
--			you want 19.2k baud, (12M/(19.2k*4))-1=009b.
--
-- Block Diagram:
--
--           +---------------+
--           | BAUD rate gen |
--         +->               |
--         | |  16 bit       >--4X BAUD
--    CLK----|>              >--1X BAUD
--         | +---------------+
--         |
--  DATAIN-+----------------------------------------+
--                                                  |
--           +------------+     +-------+      +----v-----+
--           | Status reg |     |TX BIT |      | TX_HOLD  |
--           |            |VALID|COUNTER|      +----v-----+
--           |            <-----<       |           |
--           |            |     +-------+    +------v-------+
--           |            <--+               |1| TX_SHIFT |0>----TX_DATA
--           |            |  |VALID          +--------------+
--           +----v-------+  |   
--                |          |  +-------+    +--------------+
--                |          |  |RX BIT |    | | RX_SHIFT | <----RX_DATA
--                |          |  |COUNTER|    +------v-------+
--                |          +--<       |           |
--            /|  |             +-------+      +----v-----+
--           / <--+                            | RX_HOLD  |
--  DATAOUT-<  |                               +----v-----+
--           \ <------------------------------------+
--            \|
--
-- Theory of Operation:
--
-- A programmable BAUD rate generator is provided which generates a 4X
-- oversampled bit clock and a 1X bit clock. The baud rate registers
-- are write only. A few gates can be saved by eliminating the BAUDH 
-- register if you know that the upper baud register will always be zero.
--
-- The transmit logic waits for the CPU to load a byte into the TX_HOLD
-- register. This byte is transferred into the TX_SHIFT register and the
-- TX_BIT_CTR begins running and the start bit is output on TX_DATA.
-- Once all 10 bits (start, 8 data, stop bits) have been shifted, 
-- the next byte will be immediately loaded into the TX_SHIFT register 
-- if another byte is available in the TX_HOLD register.
--
-- The recieve logic is a bit more complicated as it must synchonize to
-- the incoming data stream. RX_DATA is first synchronized twice to 
-- eliminate metastability problems. Then the RX_BIT_CTR begins running 
-- and the current "phase" of the 4X clock is sampled. 
-- This allows us to sample each bit at the 1/2 to 3/4 point in the bit. 
-- This is a good place to sample the
-- bit as it should be stable by this time. Once all 10 bits have been
-- shifted in, the start and stop bits are checked and the framing error
-- is activated if they are not correct. The data is transferred into the
-- RX_HOLD register and another byte can be received while the CPU is 
-- reading the RX_HOLD register. If the CPU has not read the byte in the
-- RX_HOLD before another byte has been shifted in, then the RX_OFLO 
-- bit is set and the data in the RX_HOLD register is overwritten.


-----------------------------------------------------------------------
-- Revision History
-- $Log: vuart.vhd,v $
-- Revision 1.11  1999/10/07 14:14:38  chris
-- Added empty architecture.
--
-- Revision 1.10  1999/09/14 16:17:37  eric
-- No logic changes - RMM improvements.
--
-- Revision 1.9  1999/08/24 18:48:14  scott
-- Modified the code to use std_ulogic(_vector) and IEEE numeric_std package
--
-- Revision 1.8  1999/07/22 14:30:31  mark
-- 'dataout' only outputs status_reg when chip_sel is asserted.
--
-- Revision 1.7  1999/01/13 02:35:39  eric
-- Corrected the RXENB bit which was incorrectly coming from bit 3 instead of 2.
--
-- Revision 1.6  1998/10/16 20:52:37  eric
-- Changed the default baud from 19.2K to 115.2K.
--
-- Revision 1.5  1998/09/30 02:39:13  eric
-- Added the IRQ line and improved style for synopsys.
--
-- Revision 1.4  1998/09/14 16:01:43  monika
-- changed default BAUD from 9c to 9b.
--
-- Revision 1.3  1997/10/30 22:03:44  eric
-- just added a few comments.
--
-- Revision 1.2  1997/09/10 23:05:34  eric
-- flopped rx_data to avoid metastability problems.
--
-- Revision 1.1  1997/09/08 17:14:03  eric
-- Initial revision
--
-----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY vuart IS
  PORT (
        clk         : IN  std_ulogic;                     -- clock input
        rst         : IN  std_ulogic;                     -- reset

        addr        : IN  std_ulogic_vector( 1 DOWNTO 0); -- address
        chip_sel    : IN  std_ulogic;                     -- Chip select 
        datain      : IN  std_ulogic_vector(7 DOWNTO 0);  -- DATA bus in
        read        : IN  std_ulogic;                     -- uP read 
        write       : IN  std_ulogic;                     -- uP write 

        dataout     : OUT std_ulogic_vector(7 DOWNTO 0);  -- DATA bus out
        irq         : OUT std_ulogic;                     -- interrupt request
	-- serial connections
        rx_data     : IN  std_ulogic;                     -- Rx data

        baud        : OUT std_ulogic;                     -- baud clock
        tx_data     : OUT std_ulogic                      -- Tx data
	);
END vuart;

ARCHITECTURE empty OF vuart IS
BEGIN
  dataout <= "00000000";
  irq     <= '0';
  baud    <= '0';
  tx_data <= '0';
END empty;

ARCHITECTURE rtl OF vuart IS
-- assign default_baud the value of the baud rate you want.
-- Compute it as (<input_clock_rate>/(desired baud rate*4))-1
-- The value 19 programmed here is approximately 115200 with a 12Mhz clock.
CONSTANT default_baud : std_ulogic_vector(15 downto 0) := "0000000000011001";
SIGNAL baud_ctr		: std_ulogic_vector(15 downto 0); -- baud rate counter
SIGNAL baud_ctr_zero	: std_ulogic; 	-- baud_ctr = 0
SIGNAL baud_reg		: std_ulogic_vector(15 downto 0); -- baud rate reg
SIGNAL bit_ctr		: std_ulogic_vector(1 downto 0); -- 4X bit rate counter
SIGNAL rxfull		: std_ulogic;	-- status reg
SIGNAL rxenb		: std_ulogic;	-- status reg
SIGNAL rx_ctr		: std_ulogic_vector(3 downto 0);	-- Rx Bit counter
SIGNAL rx_data_r1,rx_data_r2	: std_ulogic;	-- Synchronizers
SIGNAL rx_data_valid	: std_ulogic;	-- RX data in holding reg is valid
SIGNAL rx_frame_err	: std_ulogic;	-- RX framing error detected
SIGNAL rx_hold		: std_ulogic_vector(7 downto 0);	-- Rx holding reg
SIGNAL rx_idle		: std_ulogic;	-- RX is idle
SIGNAL rx_load		: std_ulogic;	-- transfer RX data to holding reg
SIGNAL rx_oflow		: std_ulogic;	-- RX data overflow occurred
SIGNAL rx_phase		: std_ulogic_vector(1 downto 0);	-- Rx phase reg
SIGNAL rx_shift		: std_ulogic;	-- RX shift enable
SIGNAL rx_shifter	: std_ulogic_vector(8 downto 0);	-- Rx shift register
SIGNAL status_reg	: std_ulogic_vector(7 downto 0);	-- status register
SIGNAL txempty		: std_ulogic;	-- status reg
SIGNAL txenb		: std_ulogic;	-- status reg
SIGNAL tx_ctr		: std_ulogic_vector(3 downto 0);	-- Tx bit counter
SIGNAL tx_ctr_zero	: std_ulogic;	-- tx_counter=0, ready for next byte
SIGNAL tx_data_valid	: std_ulogic;	-- data is in the tx holding reg
SIGNAL tx_hold		: std_ulogic_vector(7 downto 0);	-- Tx holding reg
SIGNAL tx_load		: std_ulogic;	-- transfer hold to shift reg
SIGNAL tx_shift		: std_ulogic;	-- time so shift
SIGNAL tx_shifter	: std_ulogic_vector(8 downto 0);	-- Tx shift reg
attribute sync_set_reset : string;
attribute sync_set_reset of rst : signal is "true"; -- required for synopsys
BEGIN

---------------------------BAUD GENERATOR-------------------------------
baudreg_proc:PROCESS(clk)	--------------BAUD register-------------
BEGIN
  -- you can save a few gates here by making the baud generator a fixed
  -- value instead of making it programmable.
  if (clk'event and clk='1') then
   if (rst='1') then	
    baud_reg <= default_baud;		-- load the power-up value
   elsif (chip_sel='1' AND write='1' AND addr="10")  then
    baud_reg <= baud_reg(15 downto 8) & datain;	-- load the low half
   elsif (chip_sel='1' AND write='1' AND addr="11")  then
    baud_reg <= datain & baud_reg(7 downto 0);	-- load the high half
   end if;
  end if;
END PROCESS;

baudctr_proc:PROCESS(clk)	--------------BAUD counter---------------
BEGIN
  if (clk'event and clk='1') then
   if (rst='1') then			-- 16 bit baud rate down counter
    baud_ctr <= "0000000000000000";
   elsif (baud_ctr_zero='1') then
    baud_ctr <= baud_reg;
--    baud_ctr <= "00000000" & baud_reg(7 downto 0);	
-- use this one to save a few gates if the upper 8 bits of the 
-- BAUD are always zero.
   else
    baud_ctr <= std_ulogic_vector(unsigned(baud_ctr) - 1);
   end if;
  end if;
END PROCESS;

bitctr_proc:PROCESS(clk)	--------------Bit counter---------------
BEGIN
  if (clk'event and clk='1') then
   if (rst='1') then			-- 4X bit rate counter
    bit_ctr <= "00";
   elsif (baud_ctr_zero='1') then
    bit_ctr <= std_ulogic_vector(unsigned(bit_ctr) + 1);
   end if;
  end if;
END PROCESS;

baud_ctr_zero <= '1' WHEN baud_ctr="0000000000000000" else '0';
tx_shift <= '1' WHEN baud_ctr_zero='1'  AND bit_ctr="00" ELSE '0';

----------------------------------------Transmit Logic------------------
txh_proc: PROCESS(clk)	---------tx holding register
BEGIN
  if (clk'event AND clk='1') then	-- TX hold register allows the
   if (rst='1') then			-- CPU to load a char while 
    tx_hold <= "00000000";		-- we're shifting the last one.
   elsif (addr="00" AND write='1' AND chip_sel='1') then
    tx_hold <= datain;
   end if;
  end if;
END PROCESS;

elr_proc: PROCESS(clk)	---------tx data valid
BEGIN
  if (clk'event AND clk='1') then 	
   if (rst='1') then		-- tx_data_valid=0 tells CPU when
    tx_data_valid <= '0';	-- we are ready for another char.
   elsif (addr="00" AND write='1' AND chip_sel='1') then
    tx_data_valid <= '1';
   elsif (tx_load='1') then
    tx_data_valid <= '0';
   end if;
  end if;
END PROCESS;

gjr_proc: PROCESS(clk)	---------tx counter
BEGIN
  if (clk'event AND clk='1') then 	
   if (rst='1') then		-- bit counter keeps track of 
    tx_ctr <= "0000";		-- which bit we are shifting and
   elsif (tx_load='1') then	-- if it's the start/stop bit.
    tx_ctr <= "1001";
   elsif (tx_ctr_zero='0' AND tx_shift='1') then
    tx_ctr <= std_ulogic_vector(unsigned(tx_ctr) - 1);
   end if;
  end if;
END PROCESS;

vauto_proc: PROCESS(clk)	---------tx shift reg
BEGIN
  if (clk'event AND clk='1') then 	
   if (rst='1') then				-- shift register
    tx_shifter <= "111111111";
   elsif (tx_load='1') then
    tx_shifter <= tx_hold & '0';
   elsif (tx_shift='1') then
    tx_shifter <= '1' & tx_shifter(8 downto 1) ;
   end if;
  end if;
END PROCESS;

tx_ctr_zero <= '1' WHEN tx_ctr="0000" ELSE '0';
tx_load <= '1' WHEN tx_data_valid='1' AND 
	tx_ctr_zero='1' AND tx_shift='1' ELSE '0';

tx_data <= tx_shifter(0);	-- drive the TX data out the port.

status_reg <= not tx_data_valid & txenb & "00" & 
	rx_data_valid & rxenb & rx_oflow & rx_frame_err;

rxfull <= rx_data_valid;
txempty <= NOT tx_data_valid;

--add the baud registers to the dataout mux if you want to make them R/W
--dataout <= status_reg when addr(0)='1' else
--	rx_hold;
dataout <= status_reg when (addr(0)='1' AND chip_sel='1') else
	rx_hold;

baud <= tx_shift;		-- drive the port

-----------------------------------------RX logic-----------------------
rx_proc:PROCESS(clk)	-- PLL logic
BEGIN
  if (clk'event AND clk='1') then	-- phase detection
   if (rst='1') then			-- and IDLE logic.
    rx_idle <= '1';			-- 4X oversample the data.
    rx_phase <= "00";			-- the falling edge of the start
   elsif (rx_shift='1' AND rx_ctr="0000") then	
					-- bit is used to select the 
    rx_idle <= '1';			-- proper "phase" of the 4X clock
    rx_phase <= rx_phase;		-- so we sample the bit at the
   elsif (rx_idle='1' AND rx_data_r2='0') then	
				-- 1/2 to 3/4 point of the bit.
    rx_idle <= '0';
    rx_phase <= not bit_ctr(1) & bit_ctr(0);
   end if;
  end if;
END PROCESS;

cek_proc:PROCESS(clk)	-----------------RX uart
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then			-- Shift register
    rx_shifter <= "111111111";
   elsif (rx_shift='1') then
    rx_shifter <= rx_data_r2 & rx_shifter(8 downto 1) ;
  end if;
  end if;
END PROCESS;

rcnt_proc:PROCESS(clk)	-----------------RX counter
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then			-- bit counter
    rx_ctr <= "1001";			-- tells us when we have all
   elsif (rx_idle='1') then		-- 8 data bits + start/stop bits
    rx_ctr <= "1001";
   elsif (rx_shift='1') then
    rx_ctr <= std_ulogic_vector(unsigned(rx_ctr) - 1);
   end if;
  end if;
END PROCESS;

rxhold_proc:PROCESS(clk)-----------------RX rx holding register
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then			-- holding register
    rx_hold <= "00000000";	-- received data waits here until
   elsif (rx_load='1') then		-- CPU reads it out
    rx_hold <= rx_shifter(8 downto 1);
   end if;
  end if;
END PROCESS;

rxdv_proc:PROCESS(clk)	-----------------RX data valid
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then			-- data valid for CPU to read
    rx_data_valid <= '0';		-- when rx_data_valid=1
   elsif (rx_load='1') then
    rx_data_valid <= '1';
   elsif (read='1' AND chip_sel='1' AND addr="00") then
    rx_data_valid <= '0';
   end if;
  end if;
END PROCESS;

rxf_proc:PROCESS(clk)	-----------------RX frame error logic
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then				-- error if we don't find start/stop bits where expected
    rx_frame_err <= '0';
   elsif (rx_shift='1' AND rx_ctr="0000" AND (rx_shifter(0)='1' OR rx_data_r2='0')) then
    rx_frame_err <= '1';
   elsif (write='1' AND chip_sel='1' AND addr="01") then
    rx_frame_err <= datain(0);
   end if;
  end if;
END PROCESS;

vauto2282_proc:PROCESS(clk)	-----------------RX overflow logic
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then				-- RX overflow if we get another 
    rx_oflow <= '0';				-- character before CPU has read
   elsif (rx_load='1' AND rx_data_valid='1') then	-- this one.
    rx_oflow <= '1';
   elsif (write='1' AND chip_sel='1' AND addr="01") then
    rx_oflow <= datain(1);
   end if;

   rx_data_r2 <= rx_data_r1; -- double synchronizer to eliminate metastability
   rx_data_r1 <= rx_data;
  end if;
END PROCESS;

rx_shift <= '1' when baud_ctr_zero='1' AND bit_ctr=rx_phase ELSE '0';
rx_load <= '1' WHEN (rx_shift='1' AND rx_ctr="0000" AND 
	rx_shifter(0)='0' AND rx_data_r2='1') -- one start bit and one stop bit.
	ELSE '0';


rxe_proc:PROCESS(clk)	-----------------RX interrupt enable bit
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then				-- error if we don't find start/stop bits where expected
    rxenb <= '0';
   elsif (write='1' AND chip_sel='1' AND addr="01") then
    rxenb <= datain(2);
   end if;
  end if;
END PROCESS;


txe_proc:PROCESS(clk)	-----------------TX interrupt enable bit
BEGIN
  if (clk'event AND clk='1') then
   if (rst='1') then				-- error if we don't find start/stop bits where expected
    txenb <= '0';
   elsif (write='1' AND chip_sel='1' AND addr="01") then
    txenb <= datain(6);
   end if;
  end if;
END PROCESS;

irq <= (txempty AND txenb) or (rxenb and (rxfull or rx_oflow or rx_frame_err));

END rtl;
