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
--  File Name              : SciTrRxFIFO.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block instantiates the SciRxFCntl and the
--            SciRxRegFile blocks
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SciTrRxFIFO is
port (
      PCLK	   : in    std_logic; -- APB bus clock
      PRESETn	   : in    std_logic; -- reset (from PRESETn)
      RxFWrSync	   : in    std_logic; -- RX FIFO write enable
      RxFRdPtrInc  : in    std_logic; -- RX FIFO read pointer incr.
      RxSRLevel    : in    std_logic_vector(3 downto 0); -- RX FIFO level
      RxFWrData	   : in    std_logic_vector(8 downto 0); -- RX FIFO write data
      SCITrRFR	   : out   std_logic; -- RX FIFO service request
      SCITrRFE	   : out   std_logic; -- RX FIFO not empty
      SCITrRFF	   : out   std_logic; -- RX FIFO full
      RxFRdData	   : out   std_logic_vector(8 downto 0) -- RX FIFO read data
     );
end SciTrRxFIFO;

-- -----------------------------------------------------------------------------
-- 
--                            SciTrRxFIFO
--                            ===========
-- 
-- -----------------------------------------------------------------------------
-- 
-- Overview
-- ========
-- 
--  The SciRxFIFO block instantiates the SciRxRegFile block and the SciRxFCntl
-- block. The SciRxRegFile block contains the Receive FIFO register file. Data
-- on the RxFWrData bus is written into the location in the Receive FIFO pointed
-- to by the current value of the WrPtr[3:0] (Write pointer) signal on the
-- rising edge of PCLK on which the RegFileWrEn signal is sampled high. Data in
-- the FIFO location pointed to by the RdPtr[3:0] signal is always driven on the
-- RxFRdData[15:0] output. 
--  The SciRxFCntl block controls the Read pointer and the Write pointer. Thus,
-- the Receive FIFO is implemented as a circular buffer. The SciRxFCntl block
-- also generates FIFO status signals RFF,RNE and RFR 
--
-- ============================== ARCHITECTURE ===============================--
 
architecture structural of SciTrRxFIFO is
 
-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

component SciTrRxFCntl 
port (
      PCLK         : in    std_logic;
      PRESETn      : in    std_logic;
      RxFWrSync    : in    std_logic;
      RxFRdPtrInc  : in    std_logic;
      RxSRLevel    : in    std_logic_vector(3 downto 0);     
      WrPtr        : out   std_logic_vector(3 downto 0);
      RdPtr        : out   std_logic_vector(3 downto 0);
      RegFileWrEn  : out   std_logic;
      SCITrRFR     : out   std_logic;
      SCITrRFF     : out   std_logic;
      SCITrRFE     : out   std_logic
     );
end component;

component SciTrRxRegFile 
port (
      PCLK         : in   std_logic;
      RxFWrData	   : in   std_logic_vector(8 downto 0);
      RegFileWrEn  : in   std_logic;
      WrPtr        : in   std_logic_vector(3 downto 0);
      RdPtr        : in   std_logic_vector(3 downto 0);
      RxFRdData    : out  std_logic_vector(8 downto 0);
      PRESETn      : in   std_logic
     );
end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal RegFileWrEn : std_logic;
signal WrPtr       : std_logic_vector(3 downto 0);
signal RdPtr       : std_logic_vector(3 downto 0);
 
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ----------------------------------------------------------------------------- 
begin

-- -----------------------------------------------------------------------------
-- The SciRxFCntl block contains the control logic for the Receive FIFO.
-- -----------------------------------------------------------------------------

uSciTrRxFCntl: SciTrRxFCntl
port map (
          PCLK        => PCLK,
          PRESETn     => PRESETn,
          RxFWrSync   => RxFWrSync,
          RxFRdPtrInc => RxFRdPtrInc,
          WrPtr       => WrPtr,
          RdPtr       => RdPtr,
          RxSRLevel   => RxSRLevel,
          RegFileWrEn => RegFileWrEn,
          SCITrRFE    => SCITrRFE,
          SCITrRFR    => SCITrRFR,
          SCITrRFF    => SCITrRFF
         );

-- -----------------------------------------------------------------------------
-- The SciRxRegFile block is a 9-bit wide 16-deep Register File for the Receive
-- FIFO.
-- -----------------------------------------------------------------------------

uSciTrRxRegFile: SciTrRxRegFile
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

-- --============================= End ======================================-





