-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrTxFIFO.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block instantiates the SciTxFCntl, SciTxRegFile 
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SciTrTxFIFO is
port (
      PCLK	      : in    std_logic; -- APB bus clock
      PRESETn	      : in    std_logic; -- reset (from PRESETn)
      SCIDRWr	      : in    std_logic; -- Tx FIFO write enable
      TxFRdPtrIncSync : in    std_logic; -- TX FIFO read ptr incr.
      PWDATAIn	      : in    std_logic_vector(7 downto 0); -- Int PWDATA
      TxSRLevel       : in    std_logic_vector(3 downto 0); -- TX FIFO level
      SCITrTFR	      : out   std_logic; -- Tx FIFO service request
      TxDataAvlbl     : out   std_logic; -- Tx FIFO data available
      SCITrTFF	      : out   std_logic; -- Tx FIFO not full
      SCITrTFE	      : out   std_logic; -- Tx FIFO empty
      TxFRdData	      : out   std_logic_vector(7 downto 0) -- Tx FIFO Rd data
     );
end SciTrTxFIFO;

-- -----------------------------------------------------------------------------
--  
--                            SciTxFIFO
--                            =========
--  
-- -----------------------------------------------------------------------------
--  
-- Overview
-- ========
--  
--  The SsiTxFIFO block instantiates the SciTxRegFile block and the SciTxFCntl
-- block. The SciTxRegFile block contains the Transmit FIFO register file. 
-- Data on the PWDATAIn bus is written into the location in the Receive FIFO 
-- pointed to by the current value of the WrPtr[3:0] (Write pointer) signal on 
-- the rising edge of PCLK on which the RegFileWrEn signal is sampled high. 
-- Data in the FIFO location pointed to by the RdPtr[3:0] signal is always 
-- driven on the TxFRdData[15:0] output. The SsiTxFCntl block controls the 
-- Read pointer and the Write pointer. Thus, the Transmit FIFO is implemented 
-- as a circular buffer. The SciTxFCntl block also generates FIFO status 
-- signals TFF and TFE and TFR (Transmit FIFO service request) interrupt.
-- 
--============================ ARCHITECTURE ====================================
 
architecture structural of SciTrTxFIFO is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

component SciTrTxFCntl 
port (
      PCLK	      : in    std_logic;
      PRESETn	      : in    std_logic;
      SCIDRWr	      : in    std_logic;
      TxFRdPtrIncSync : in    std_logic;
      TxSRLevel       : in    std_logic_vector(3 downto 0);
      TxDataAvlbl     : out   std_logic;
      SCITrTFR	      : out   std_logic;
      SCITrTFF	      : out   std_logic;
      WrPtr           : out   std_logic_vector(3 downto 0);
      RdPtr           : out   std_logic_vector(3 downto 0);
      RegFileWrEn     : out   std_logic;
      SCITrTFE        : out   std_logic
     );
end component;

component SciTrTxRegFile 
port (
      PCLK	      : in    std_logic;
      WrPtr	      : in    std_logic_vector(3 downto 0);
      RdPtr	      : in    std_logic_vector(3 downto 0);
      RegFileWrEn     : in    std_logic;
      TxFRdData	      : out   std_logic_vector(7 downto 0);
      PWDATAIn	      : in    std_logic_vector(7 downto 0);
      PRESETn	      : in    std_logic
     );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RegFileWrEn    : std_logic; 
signal RdPtr          : std_logic_vector(3 downto 0); 
signal WrPtr          : std_logic_vector(3 downto 0); 

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- The SciTxFCntl block contains the control logic for the Transmit FIFO.
-- -----------------------------------------------------------------------------
uSciTrTxFCntl: SciTrTxFCntl
port map (
          PCLK            => PCLK,
          PRESETn         => PRESETn,
          SCIDRWr         => SCIDRWr,
          TxFRdPtrIncSync => TxFRdPtrIncSync,
          TxDataAvlbl     => TxDataAvlbl,
          SCITrTFR        => SCITrTFR,
          SCITrTFF        => SCITrTFF,
          TxSRLevel       => TxSRLevel, 
          WrPtr           => WrPtr,
          RdPtr           => RdPtr,
          RegFileWrEn     => RegFileWrEn,
          SCITrTFE        => SCITrTFE
         );

-- -----------------------------------------------------------------------------
-- The SciTxRegFile block is a 8-bit wide 16-deep Register File for the 
-- Transmit FIFO.
-- -----------------------------------------------------------------------------
uSciTrTxRegFile: SciTrTxRegFile
port map (
          PCLK        => PCLK,
          WrPtr       => WrPtr,
          RdPtr       => RdPtr,
          RegFileWrEn => RegFileWrEn,
          TxFRdData   => TxFRdData,
          PWDATAIn    => PWDATAIn,
          PRESETn     => PRESETn
         );

end structural;

-- --============================= End =======================================--
