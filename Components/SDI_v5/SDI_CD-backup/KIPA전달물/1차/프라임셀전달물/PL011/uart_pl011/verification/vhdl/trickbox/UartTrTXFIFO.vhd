--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrTXFIFO.vhd.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block instantiates the UartTXFCntl (Transmit FIFO
--                    control)  and the UartTXRegFile (Register File) blocks.
-- ===========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity UartTrTXFIFO is
  port (
        PCLK	        : in  std_logic;  -- APB Clock
        PRESETn	        : in  std_logic;  -- AMBA Reset 
        UARTEN	        : in  std_logic;  -- UART Enable
        UARTDRWrEn	: in  std_logic;  -- TX FIFO Write enable
        TXFRdPtrInc	: in  std_logic;  -- TX FIFO Rd Ptr Inc
        FEN	        : in  std_logic;  -- FIFO Enable
        TXBUSY	        : in  std_logic;  -- Transmitter busy
        PWDATAIn	: in  std_logic_vector(7 downto 0);  -- Data bus
        TXHE            : out std_logic;  -- TX FIFO GE Half full
        TXFF        	: out std_logic;  -- Transmit FIFO Full
        TXFE	        : out std_logic;  -- Transmit FIFO Empty
        RdPtrIncDone	: out std_logic;  -- Rd Ptr Inc done
        TXShiftData	: out std_logic_vector(7 downto 0);  -- Xmit Data
        TXDataAvlbl	: out std_logic  -- TX Data Available
       );
end UartTrTXFIFO;

-- -----------------------------------------------------------------------------
-- 
--                                 UartTrTXFIFO
--                                 ==========
-- 
-- -----------------------------------------------------------------------------
-- 
-- Overview
-- ========
-- 
--   Writes to the transmit FIFO occur through the APB interface from the PCLK 
-- domain. Reads from the transmit FIFO occur from the transmit block which 
-- falls in the UARTCLK clock domain. The FIFO is 8-bit wide and 16-deep. 
--   The UartTrTXFCntl module contains the control logic for the FIFO. It 
-- contains a write pointer, a read pointer and a transmit shift register.
--  Writes from the APB can occur as close as every two PCLK periods. So as 
-- to ensure that no writes are missed, the write pointer operates on PCLK.
--  To facilitate FIFO fill level calculation, the read pointer is also operated
-- on PCLK. 
--   Write data from the APB is written into the location pointed to by the 
-- current value of the write pointer. If a write occurs to the FIFO when it is
-- already full, the write is ignored.
--   The TXDataAvlbl output signal is asserted when there is data available to 
-- be transmitted. Upon detecting this signal, the transmitter commences
-- transmission. At the end of transmission of one data byte, the transmitter 
-- asserts the RdPtrInc signal. 

--============================ ARCHITECTURE ====================================

architecture structural of UartTrTXFIFO is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------
 
component UartTrTXRegFile 
port (
   WrPtr	: in    std_logic_vector(3 downto 0);
   PWDATAIn	: in    std_logic_vector(7 downto 0);
   RegFileWrEn	: in    std_logic;
   PCLK	        : in    std_logic;
   RdPtr	: in    std_logic_vector(3 downto 0);
   TXFIFOData	: out   std_logic_vector(7 downto 0);
   PRESETn	: in    std_logic
   );
end component;


component UartTrTXFCntl 
port (
   WrPtr	  : out   std_logic_vector(3 downto 0);
   RegFileWrEn	  : out   std_logic;
   RdPtr	  : out   std_logic_vector(3 downto 0);
   PCLK	          : in    std_logic;
   PWDATAIn	  : in    std_logic_vector(7 downto 0);
   TXFF	          : out   std_logic;
   TXFE	          : out   std_logic;
   TXFLTEHalfFull : out   std_logic;        
   TXDataAvlbl	  : out   std_logic;
   PRESETn	  : in    std_logic;
   FEN	          : in    std_logic;
   TXShiftData	  : out   std_logic_vector(7 downto 0);
   UARTEN	  : in    std_logic;
   UARTDRWrEn	  : in    std_logic;
   TXFIFOData	  : in    std_logic_vector(7 downto 0);
   RdPtrIncDone	  : out   std_logic;
   TXFRdPtrInc	  : in    std_logic;
   TXBUSY	  : in    std_logic
   );
end component;

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
 
signal WrPtr            : std_logic_vector(3 downto 0);
signal RdPtr            : std_logic_vector(3 downto 0);
signal RegFileWrEn      : std_logic;
signal TXFIFOData       : std_logic_vector(7 downto 0);
 
--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------

begin

-- The UartTXRegFile is a data buffer implemented using D-types.
 uUartTXRegFile: UartTrTXRegFile
 port map (
   WrPtr         => WrPtr
   , PWDATAIn    => PWDATAIn
   , RegFileWrEn => RegFileWrEn
   , PCLK        => PCLK
   , RdPtr       => RdPtr
   , TXFIFOData  => TXFIFOData
   , PRESETn     => PRESETn
   );


-- The UartTXFCntl block controls accesses to the FIFO register file.
 uUartTXFCntl: UartTrTXFCntl
 port map (
   WrPtr            => WrPtr
   , RegFileWrEn    => RegFileWrEn
   , RdPtr          => RdPtr
   , PCLK           => PCLK
   , PWDATAIn       => PWDATAIn
   , TXFF           => TXFF
   , TXFE           => TXFE
   , TXFLTEHalfFull => TXHE 
   , TXDataAvlbl    => TXDataAvlbl
   , PRESETn        => PRESETn
   , FEN            => FEN
   , TXShiftData    => TXShiftData
   , UARTEN         => UARTEN
   , UARTDRWrEn     => UARTDRWrEn
   , TXFIFOData     => TXFIFOData
   , RdPtrIncDone   => RdPtrIncDone
   , TXFRdPtrInc    => TXFRdPtrInc
   , TXBUSY         => TXBUSY
   );
end structural;
