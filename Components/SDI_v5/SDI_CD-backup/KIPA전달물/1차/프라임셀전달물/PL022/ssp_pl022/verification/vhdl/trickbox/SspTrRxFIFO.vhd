-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrRxFIFO.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
--  Purpose          : This block instantiates the SspTrRxFCntl and the
--                     SspTrRxRegFile blocks
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrRxFIFO is
  port (
        PCLK        : in    std_logic;  -- APB bus clock
        PRESETn     : in    std_logic;  -- Muxed reset (from BPRESETn)
        RxFWrSync   : in    std_logic;  -- RX FIFO write enable
        SRxFWrSync  : in    std_logic;  -- RX FIFO write enable for Slave unit
        RxFRdPtrInc : in    std_logic;  -- RX FIFO read pointer incr.
        RXW         : in    std_logic_vector(1 downto 0);
                                        -- Rx Watermark lvl.
        RxFWrData   : in    std_logic_vector(15 downto 0);
                                        -- RX FIFO Wr data
        RXWFLG      : out   std_logic;  -- RX FIFO Waterlevel flag 
        RNE         : out   std_logic;  -- RX FIFO not empty
        RFF         : out   std_logic;  -- RX FIFO full
        RxFRdData   : out   std_logic_vector(15 downto 0)
                                        -- RX FIFO read data
       );
end SspTrRxFIFO;

-- -----------------------------------------------------------------------------
--
--                            SspTrRxFIFO
--                            ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  The SspTrRxFIFO block instantiates the SspTrRxRegFile block and the
--  SspTrRxFCntl block. The SspTrRxRegFile block contains the Receive FIFO
--  register file. Data on the RxFWrData bus is written into the location
--  in the Receive FIFO pointed to by the current value of the WrPtr[3:0]
--  (Write pointer) signal on the rising edge of PCLK on which the RegFileWrEn
--  signal is sampled high. Data in the FIFO location pointed to by the
--  RdPtr[3:0] signal is always driven on the RxFRdData[15:0] output.
--  The SspTrRxFCntl block controls the Read pointer and the Write pointer.Thus,
--  the Receive FIFO is implemented as a circular buffer.The SspTrRxFCntl block
--  also generates FIFO status signals RFF and RNE.
-- -----------------------------------------------------------------------------

-- ============================== ARCHITECTURE ===============================--

architecture structural of SspTrRxFIFO is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component SspTrRxFCntl 
port (
      PCLK        : in    std_logic;
      PRESETn     : in    std_logic;
      RxFWrSync   : in    std_logic;
      SRxFWrSync  : in    std_logic;
      RxFRdPtrInc : in    std_logic;
      RXW         : in    std_logic_vector(1 downto 0);
      WrPtr       : out   std_logic_vector(3 downto 0);
      RdPtr       : out   std_logic_vector(3 downto 0);
      RegFileWrEn : out   std_logic;
      RNE         : out   std_logic;
      RXWFLG      : out   std_logic;
      RFF         : out   std_logic
     );
end component;

component SspTrRxRegFile 
port (
      PCLK        : in    std_logic;
      RxFWrData   : in    std_logic_vector(15 downto 0);
      RegFileWrEn : in    std_logic;
      PRESETn     : in    std_logic;
      WrPtr       : in    std_logic_vector(3 downto 0);
      RdPtr       : in    std_logic_vector(3 downto 0);
      RxFRdData   : out   std_logic_vector(15 downto 0)
     );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RegFileWrEn      : std_logic;
signal WrPtr            : std_logic_vector(3 downto 0);
signal RdPtr            : std_logic_vector(3 downto 0);

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- The SspTrRxFCntl block contains the control logic for the Receive FIFO.
-- -----------------------------------------------------------------------------
uSspTrRxFCntl: SspTrRxFCntl
port map (
          PCLK        => PCLK,
          PRESETn     => PRESETn,
          RxFWrSync   => RxFWrSync,
          SRxFWrSync  => SRxFWrSync,
          RxFRdPtrInc => RxFRdPtrInc,
          WrPtr       => WrPtr,
          RdPtr       => RdPtr,
          RegFileWrEn => RegFileWrEn,
          RNE         => RNE,
          RXWFLG      => RXWFLG, 
          RFF         => RFF,
          RXW         => RXW
         );

-- -----------------------------------------------------------------------------
-- The SspTrRxRegFile block is a 16-bit wide 16-deep Register File for the 
-- Receive FIFO.
-- -----------------------------------------------------------------------------
 uSspTrRxRegFile: SspTrRxRegFile
 port map (
           PCLK        => PCLK,
           RxFWrData   => RxFWrData,
           RegFileWrEn => RegFileWrEn,
           WrPtr       => WrPtr,
           RdPtr       => RdPtr,
           RxFRdData   => RxFRdData,
           PRESETn     => PRESETn
          );

end structural;

-- --============================ End ========================================--
