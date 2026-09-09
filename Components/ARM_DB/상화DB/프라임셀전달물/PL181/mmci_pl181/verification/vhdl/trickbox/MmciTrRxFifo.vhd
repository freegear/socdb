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
-- File Name              : MmciTrRxFifo.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block instantiates the MmciTrRxFCntl and the
--           MmciTrRxRegFile blocks
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrRxFifo is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- Bus reset
        FifoClearSync    : in    std_logic; -- Clear signal
        RxFWrSync        : in    std_logic; -- RX FIFO write enable
        RxFRdPtrInc      : in    std_logic; -- RX FIFO read ptr incr.
        RxFWrData        : in    std_logic_vector(32 downto 0);
                                            -- RX FIFO Wr data
-- Outputs
        RNE              : out   std_logic; -- RX FIFO not empty
        RFF              : out   std_logic; -- RX FIFO full
        RFHF             : out   std_logic; -- RX FIFO half full
        RxFRdData        : out   std_logic_vector(32 downto 0)
                                            -- RX FIFO read data
       );
end MmciTrRxFifo;

-- -----------------------------------------------------------------------------
--
--                                MmciTrRxFifo
--                                ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- The MmciTrRxFIFO block instantiates the MmciTrRxRegFile block and the
-- MmciTrRxFCntl block. The MmciTrRxRegFile block contains the Receive
-- FIFO register file. Data on the RxFWrData bus is written into the
-- location in the Receive FIFO pointed to by the current value of the
-- WrPtr[4:0] (Write pointer) signal on the rising edge of PCLK on which
-- the RegFileWrEn signal is sampled high. Data in the FIFO location
-- pointed to by the RdPtr[4:0] signal is always driven on the
-- RxFRdData[31:0] output.The MmciTrRxFCntl block controls the Read
-- pointer and the Write pointer.Thus, the Receive FIFO is
-- implemented as a circular buffer.The MmciTrRxFCntl block also
-- generates FIFO status signals RFF, RFHF and RNE.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of MmciTrRxFifo is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component MmciTrRxFCntl
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        FifoClearSync    : in    std_logic;
        RxFWrSync        : in    std_logic;
        RxFRdPtrInc      : in    std_logic;
        RegFileWrEn      : out   std_logic;
        RNE              : out   std_logic;
        RFF              : out   std_logic;
        RFHF             : out   std_logic;
        WrPtr            : out   std_logic_vector(4 downto 0);
        RdPtr            : out   std_logic_vector(4 downto 0)
       );
end component;

component MmciTrRxRegFile
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        RegFileWrEn      : in    std_logic;
        WrPtr            : in    std_logic_vector(4 downto 0);
        RdPtr            : in    std_logic_vector(4 downto 0);
        RxFWrData        : in    std_logic_vector(32 downto 0);
        RxFRdData        : out   std_logic_vector(32 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RegFileWrEn      : std_logic;
-- Enable for valid Writes into Rx FIFO

signal WrPtr            : std_logic_vector(4 downto 0);
-- Read pointer, points to the location from where data is to be read

signal RdPtr            : std_logic_vector(4 downto 0);
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
-- The MmciTrRxFCntl block contains the control logic for the Receive
-- FIFO.
-- -----------------------------------------------------------------------------
uMmciTrRxFCntl : MmciTrRxFCntl
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            FifoClearSync    => FifoClearSync,
            RxFWrSync        => RxFWrSync,
            RxFRdPtrInc      => RxFRdPtrInc,
            RegFileWrEn      => RegFileWrEn,
            RNE              => RNE,
            RFF              => RFF,
            RFHF             => RFHF,
            WrPtr            => WrPtr,
            RdPtr            => RdPtr
           );

-- -----------------------------------------------------------------------------
-- The MmciTrRxRegFile block is a 16-bit wide 16-deep Register File for
-- the Receive FIFO.
-- -----------------------------------------------------------------------------
uMmciTrRxRegFile : MmciTrRxRegFile
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            RegFileWrEn      => RegFileWrEn,
            WrPtr            => WrPtr,
            RdPtr            => RdPtr,
            RxFWrData        => RxFWrData,
            RxFRdData        => RxFRdData
           );

end structural;

-- --================================== End ==================================--
