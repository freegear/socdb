-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrTxFIFO.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block instantiates the SspTrTxFCntl, SspTrTxRegFile 
--                     and the SspTrTxLJustify blocks.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrTxFIFO is
  port (
        PCLK             : in   std_logic;  -- APB bus clock
        PRESETn          : in   std_logic;  -- Muxed reset (from PRESETn)
        SSPTBTDRWr       : in   std_logic;  -- Tx FIFO write enable
        TxFRdPtrIncSync  : in   std_logic;  -- TX FIFO read ptr incr.
        STxFRdPtrIncSync : in   std_logic;  -- TX FIFO read ptr incr.
        MS               : in   std_logic;  -- Master/Slave Select
        TxRxBSYSync      : in   std_logic;  -- Tx/Rx controller busy
        FRF              : in   std_logic_vector(1 downto 0);
                                            -- Frame format
        DSS              : in   std_logic_vector(3 downto 0);
                                            -- Data size
        PWDATAIn         : in   std_logic_vector(15 downto 0);
                                            -- Int PWDATA
        TxDataAvlbl      : out  std_logic;  -- Tx FIFO data available
        TNF              : out  std_logic;  -- Tx FIFO not full
        TFE              : out  std_logic;  -- Tx FIFO empty
        BSY              : out  std_logic;  -- SSP Busy
        TxFRdDataIn      : out  std_logic_vector(15 downto 0)
                                            -- Tx FIFO Rddata
       );
end SspTrTxFIFO;

-- --============================ ARCHITECTURE ===============================--

architecture structural of SspTrTxFIFO is

-- -----------------------------------------------------------------------------
--  
--                            SspTrTxFIFO
--                            ===========
--  
-- -----------------------------------------------------------------------------
--  
-- Overview
-- ========
--  
--  The SspTrTxFIFO block instantiates the SspTrTxRegFile block, the 
-- SspTrTxFCntl block and the SspTxLJustify block.
--  The SspTrTxRegFile block contains the Transmit FIFO register file. Data
-- on the PWDATAIn bus is written into the location in the Receive FIFO pointed
-- to by the current value of the WrPtr[3:0] (Write pointer) signal on the 
-- rising edge of PCLK on which the RegFileWrEn signal is sampled high. Data in
-- the FIFO location pointed to by the RdPtr[3:0] signal is always driven on the
-- TxFRdData[15:0] output. 
--  The SspTrTxFCntl block controls the Read pointer and the Write pointer.
-- Thus, the Transmit FIFO is implemented as a circular buffer.
--   The SspTrTxLJustify block performs left-justification of transmit data to 
-- the Transmit control state machine.
-- -----------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------
component SspTrTxFCntl 
port (
      PCLK              : in   std_logic;
      PRESETn           : in   std_logic;
      SSPTBTDRWr        : in   std_logic;
      TxFRdPtrIncSync   : in   std_logic;
      STxFRdPtrIncSync  : in   std_logic;
      TxRxBSYSync       : in   std_logic;
      TxDataAvlbl       : out  std_logic;
      TNF               : out  std_logic;
      WrPtr             : out  std_logic_vector(3 downto 0);
      RdPtr             : out  std_logic_vector(3 downto 0);
      RegFileWrEn       : out  std_logic;
      TFE               : out  std_logic;
      BSY               : out  std_logic
     );
end component;

component SspTrTxRegFile 
port (
      PCLK              : in   std_logic;
      WrPtr             : in   std_logic_vector(3 downto 0);
      RdPtr             : in   std_logic_vector(3 downto 0);
      RegFileWrEn       : in   std_logic;
      PWDATAIn          : in   std_logic_vector(15 downto 0);
      PRESETn           : in   std_logic;
      TxFRdData         : out  std_logic_vector(15 downto 0)
     );
end component;

component SspTrTxLJustify 
port (
      PCLK              : in    std_logic;
      PRESETn           : in    std_logic;
      FRF               : in    std_logic_vector(1 downto 0);
      DSS               : in    std_logic_vector(3 downto 0);
      MS                : in    std_logic;
      TxFRdData         : in    std_logic_vector(15 downto 0);
      TxFRdDataIn       : out   std_logic_vector(15 downto 0)
     );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RegFileWrEn      : std_logic;
signal RdPtr            : std_logic_vector(3 downto 0);
signal WrPtr            : std_logic_vector(3 downto 0);
signal TxFRdData        : std_logic_vector(15 downto 0);

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- The SspTrTxFCntl block contains the control logic for the Transmit FIFO.
-- -----------------------------------------------------------------------------
uSspTrTxFCntl: SspTrTxFCntl
port map (
          PCLK             => PCLK,
          PRESETn          => PRESETn,
          SSPTBTDRWr       => SSPTBTDRWr,
          TxFRdPtrIncSync  => TxFRdPtrIncSync,
          STxFRdPtrIncSync => STxFRdPtrIncSync,
          TxDataAvlbl      => TxDataAvlbl,
          TNF              => TNF,
          WrPtr            => WrPtr,
          RdPtr            => RdPtr,
          RegFileWrEn      => RegFileWrEn,
          TFE              => TFE,
          TxRxBSYSync      => TxRxBSYSync,
          BSY              => BSY
         );

-- -----------------------------------------------------------------------------
--  The SspTrTxRegFile block is a 16-bit wide 16-deep Register File for the 
-- Transmit FIFO.
-- -----------------------------------------------------------------------------
uSspTrTxRegFile: SspTrTxRegFile
port map (
          PCLK        => PCLK,
          WrPtr       => WrPtr,
          RdPtr       => RdPtr,
          RegFileWrEn => RegFileWrEn,
          TxFRdData   => TxFRdData,
          PWDATAIn    => PWDATAIn,
          PRESETn     => PRESETn
         );

-- -----------------------------------------------------------------------------
-- The SspTrTxLJustify block left-justifies transmit data from the Transmit
-- FIFO.
-- -----------------------------------------------------------------------------
uSspTrTxLJustify: SspTrTxLJustify
port map (
          PCLK        => PCLK,
          PRESETn     => PRESETn,
          FRF         => FRF,
          DSS         => DSS,
          MS          => MS,
          TxFRdData   => TxFRdData,
          TxFRdDataIn => TxFRdDataIn
         );

end structural;

-- --============================= End =======================================--
