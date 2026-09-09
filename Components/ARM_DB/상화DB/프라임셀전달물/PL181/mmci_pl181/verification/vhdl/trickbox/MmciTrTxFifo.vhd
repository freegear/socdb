-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrTxFifo.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block instantiates the MmciTrTxFCntl, MmciTrTxRegFile
--           blocks.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrTxFifo is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- Bus reset
        FifoClearSync    : in    std_logic; -- FifoClear signal
        MMCITBTXFWr      : in    std_logic; -- Tx FIFO write enable
        TxFRdSync        : in    std_logic; -- TX FIFO read ptr incr.
        PWDATAIn         : in    std_logic_vector(31 downto 0);
                                            -- Int PWDATA
-- Outputs
        TxDataAvlbl      : out   std_logic; -- Tx FIFO data available
        TNF              : out   std_logic; -- Tx FIFO not full
        TFE              : out   std_logic; -- Tx FIFO empty
        TFHE             : out   std_logic; -- Tx FIFO half empty
        TxFRdData        : out   std_logic_vector(31 downto 0)
                                            -- Tx FIFO Rddata
       );
end MmciTrTxFifo;

-- -----------------------------------------------------------------------------
--
--                                MmciTrTxFifo
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- The MmciTrTxFIFO block instantiates the MmciTrTxRegFile block, the
-- MmciTrTxFCntl block.
-- The MmciTrTxRegFile block contains the Transmit FIFO register file.
-- Data on the PWDATAIn bus is written into the location in the Receive
-- FIFO pointed to by the current value of the WrPtr[4:0](Write pointer)
-- signal on the rising edge of PCLK on which the RegFileWrEn signal
-- is sampled high. Data in the FIFO location pointed to by the
-- RdPtr[4:0] signal is always driven on the TxFRdData[31:0] output.
-- The MmciTrTxFCntl block controls the Read pointer and the Write
-- pointer. Thus, the Transmit FIFO is implemented as a circular buffer.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture structural of MmciTrTxFifo is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component MmciTrTxFCntl
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        FifoClearSync    : in    std_logic;
        MMCITBTXFWr      : in    std_logic;
        TxFRdSync        : in    std_logic;
        RegFileWrEn      : out   std_logic;
        TxDataAvlbl      : out   std_logic;
        TNF              : out   std_logic;
        TFE              : out   std_logic;
        TFHE             : out   std_logic;
        WrPtr            : out   std_logic_vector(4 downto 0);
        RdPtr            : out   std_logic_vector(4 downto 0)
       );
end component;

component MmciTrTxRegFile
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        RegFileWrEn      : in    std_logic;
        WrPtr            : in    std_logic_vector(4 downto 0);
        RdPtr            : in    std_logic_vector(4 downto 0);
        PWDATAIn         : in    std_logic_vector(31 downto 0);
        TxFRdData        : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RegFileWrEn      : std_logic;
-- Enable for valid Writes into Tx FIFO

signal RdPtr            : std_logic_vector(4 downto 0);
-- Read pointer, points to the location from where data is to be read

signal WrPtr            : std_logic_vector(4 downto 0);
-- Write pointer, points to the location where data is to be written

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- The MmciTrTxFCntl block contains the control logic for the
-- Transmit FIFO.
-- -----------------------------------------------------------------------------
uMmciTrTxFCntl : MmciTrTxFCntl
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            FifoClearSync    => FifoClearSync,
            MMCITBTXFWr      => MMCITBTXFWr,
            TxFRdSync        => TxFRdSync,
            TxDataAvlbl      => TxDataAvlbl,
            TNF              => TNF,
            WrPtr            => WrPtr,
            RdPtr            => RdPtr,
            RegFileWrEn      => RegFileWrEn,
            TFE              => TFE,
            TFHE             => TFHE
           );

-- -----------------------------------------------------------------------------
--  The MmciTrTxRegFile block is a 32-bit wide 32-deep Register File for
-- the Transmit FIFO.
-- -----------------------------------------------------------------------------
uMmciTrTxRegFile : MmciTrTxRegFile
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            RegFileWrEn      => RegFileWrEn,
            WrPtr            => WrPtr,
            RdPtr            => RdPtr,
            PWDATAIn         => PWDATAIn,
            TxFRdData        => TxFRdData
           );

end structural;

-- --================================== End ==================================--
