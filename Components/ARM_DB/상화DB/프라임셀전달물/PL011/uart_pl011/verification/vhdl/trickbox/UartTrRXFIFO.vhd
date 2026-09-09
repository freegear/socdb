--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : UartTrRXFIFO.vhd.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--  ----------------------------------------------------------------------------
--  Purpose          : This block instantiates the UartRXFCntl (Receive FIFO
--                    control)  and the UartRXRegFile (Register File) blocks.
--============================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  ----------------------------------------------------------------------------

entity UartTrRXFIFO is
  port (
        PCLK           : in  std_logic;	-- APB Clock
        PRESETn        : in  std_logic;	-- AMBA Reset 
        RXFWr	       : in  std_logic;	-- RX FIFO Write Enable
        RXFRdPtrInc    : in  std_logic;	-- RX FIFO Read Pointer Incr
        RXFIFOData     : in  std_logic_vector(10 downto 0); -- RX FIFO Write data
        UTCR           : in  std_logic_vector(1 downto 0);  -- Trickbox Control Reg
        IrdaRXFWr      : in  std_logic;  -- Irda RX FIFO Write Enable
        IrdaRXFIFOData : in  std_logic_vector(10 downto 0); --Irda RX Write data
        FEN	       : in  std_logic;	-- FIFO Enable
        RXFWrDone      : out std_logic;	-- RX FIFO Write Done
        RXFE	       : out std_logic;	-- Receive FIFO Empty
        RXFF	       : out std_logic;	-- Receive FIFO Full
        RXHF           : out std_logic; -- RX FIFO more than half-full
        RXFRdData      : out std_logic_vector(10 downto 0)  -- RX FIFO Read Data
       );
end UartTrRXFIFO;

-- -----------------------------------------------------------------------------
--                                 UartTrRXFIFO
--                                 ==========
--
--------------------------------------------------------------------------------
--
-- Overview
-- ========
-- 
--   The receive FIFO is a 11-bit wide 16-deep FIFO. It instantiates two 
-- submodules - UartRXFCntl (which performs the FIFO control function and the
-- UartRXRegFile (which is the register file). The receive FIFO is implemented
-- as a circular buffer with read and write pointers. The pointers operate on
-- PCLK to facilitate APB accesses and calculation of FIFO fill level.
-- 
--=============================== ARCHITECTURE ===============================-
architecture structural of UartTrRXFIFO  is
 
-------------------------------------------------------------------------------

-- Component declarations
-------------------------------------------------------------------------------
component UartTrRXFCntl 
port (
   PCLK	        : in    std_logic;
   PRESETn	: in    std_logic;
   WrPtr	: out   std_logic_vector(3 downto 0);
   RegFileWrEn	: out   std_logic;
   RdPtr	: out   std_logic_vector(3 downto 0);
   UTCR         : in std_logic_vector(1 downto 0);
   RXFE	        : out   std_logic;
   RXFWrDone	: out   std_logic;
   RXFF	        : out   std_logic;
   RXHF         : out   std_logic;
   FEN	        : in    std_logic;
   RXFRdPtrInc	: in    std_logic;
   IrdaRXFWr    : in    std_logic;
   RXFWr	: in    std_logic
   );
end component;


component UartTrRXRegFile 
port (
   WrPtr	  : in  std_logic_vector(3 downto 0);
   RXFIFOData	  : in  std_logic_vector(10 downto 0);
   IrdaRXFIFOData : in  std_logic_vector(10 downto 0);
   UTCR           : in  std_logic_vector(1 downto 0);
   RegFileWrEn	  : in  std_logic;
   PCLK	          : in  std_logic;
   RdPtr	  : in  std_logic_vector(3 downto 0);
   RXFRdData	  : out std_logic_vector(10 downto 0);
   PRESETn	  : in  std_logic
   );
end component;

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
  signal RegFileWrEn      : std_logic;
  -- Data Register write Enable

  signal WrPtr    : std_logic_vector(3 downto 0);
  -- Pointing to write location of FIFO
 
  signal RdPtr    : std_logic_vector(3 downto 0);
  -- Pointing to read location of FIFO
--------------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
--------------------------------------------------------------------------------
 
begin

-- The UartRXFCntl block controls accesses to the FIFO register file.
 uUartRXFCntl: UartTrRXFCntl
 port map (
   PCLK    => PCLK
   , PRESETn => PRESETn
   , WrPtr => WrPtr
   , UTCR => UTCR
   , RegFileWrEn => RegFileWrEn
   , RdPtr => RdPtr
   , RXFE => RXFE
   , RXFWrDone => RXFWrDone
   , RXFF => RXFF
   , RXHF => RXHF
   , FEN => FEN
   , RXFRdPtrInc => RXFRdPtrInc
   , IrdaRXFWR => IrdaRXFWr
   , RXFWr => RXFWr
   );


-- The UartRXRegFile is a data buffer implemented using D-types.
 uUartRXRegFile: UartTrRXRegFile
 port map (
   WrPtr => WrPtr
   , RXFIFOData => RXFIFOData
   , IrdaRXFIFOData => IrdaRXFIFOData
   , RegFileWrEn => RegFileWrEn
   , PCLK => PCLK
   , UTCR => UTCR
   , RdPtr => RdPtr
   , RXFRdData => RXFRdData
   , PRESETn => PRESETn
   );
end structural;


-- ============================== End  =========================================

