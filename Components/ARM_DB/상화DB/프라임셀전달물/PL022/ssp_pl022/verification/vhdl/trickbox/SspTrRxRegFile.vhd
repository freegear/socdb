-- --========================================================================--R
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
--  File Name              : SspTrRxRegFile.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : Receive FIFO Register File
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrRxRegFile is
  port (
        PCLK        :  in    std_logic;  -- APB bus clock
        PRESETn     :  in    std_logic;  -- Muxed Reset (from PRESETn)
        RegFileWrEn :  in    std_logic;  -- Write enable
        WrPtr       :  in    std_logic_vector(3 downto 0);
                                         -- Write pointer
        RdPtr       :  in    std_logic_vector(3 downto 0);
                                         -- Read pointer
        RxFWrData   :  in    std_logic_vector(15 downto 0);
                                         -- Write data
        RxFRdData   :  out   std_logic_vector(15 downto 0)
                                         -- Read Data
       );
end SspTrRxRegFile;

-- -----------------------------------------------------------------------------
--
--                               SspTrRxRegFile
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module contains the Register file for the Receive FIFO. When the 
-- Write enable signal RegFileWrEn is asserted, data on the write data bus 
-- PWDATAIn is written into the location pointed to by the current value of the
-- Write pointer, WrPtr[3:0]. On the read interface, the contents of the 
-- location pointed to by the current value of the read pointer RdPtr, is 
-- driven onto the read databus, TxFRdData.
-- 
-- -----------------------------------------------------------------------------

-- ============================= ARCHITECTURE ================================--

architecture behavioural of SspTrRxRegFile  is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RxReg0        : std_logic_vector(15 downto 0);
-- Receive FIFO register0 

signal NextRxReg0    : std_logic_vector(15 downto 0);
-- D-input of RxReg0

signal RxReg1        : std_logic_vector(15 downto 0);
-- Receive FIFO register1 

signal NextRxReg1    : std_logic_vector(15 downto 0);
-- D-input of RxReg1

signal RxReg2        : std_logic_vector(15 downto 0);
-- Receive FIFO register2 

signal NextRxReg2    : std_logic_vector(15 downto 0);
-- D-input of RxReg2

signal RxReg3        : std_logic_vector(15 downto 0);
-- Receive FIFO register3 

signal NextRxReg3    : std_logic_vector(15 downto 0);
-- D-input of RxReg3

signal RxReg4        : std_logic_vector(15 downto 0);
-- Receive FIFO register4 

signal NextRxReg4    : std_logic_vector(15 downto 0);
-- D-input of RxReg4

signal RxReg5        : std_logic_vector(15 downto 0);
-- Receive FIFO register5 

signal NextRxReg5    : std_logic_vector(15 downto 0);
-- D-input of RxReg5

signal RxReg6        : std_logic_vector(15 downto 0);
-- Receive FIFO register6 

signal NextRxReg6    : std_logic_vector(15 downto 0);
-- D-input of RxReg6

signal RxReg7        : std_logic_vector(15 downto 0);
-- Receive FIFO register7 

signal NextRxReg7    : std_logic_vector(15 downto 0);
-- D-input of RxReg7

signal RxReg8        : std_logic_vector(15 downto 0);
-- Receive FIFO register8 

signal NextRxReg8    : std_logic_vector(15 downto 0);
-- D-input of RxReg8

signal RxReg9        : std_logic_vector(15 downto 0);
-- Receive FIFO register9 

signal NextRxReg9    : std_logic_vector(15 downto 0);
-- D-input of RxReg9

signal RxReg10       : std_logic_vector(15 downto 0);
-- Receive FIFO register10 

signal NextRxReg10   : std_logic_vector(15 downto 0);
-- D-input of RxReg10

signal RxReg11       : std_logic_vector(15 downto 0);
-- Receive FIFO register11 

signal NextRxReg11   : std_logic_vector(15 downto 0);
-- D-input of RxReg11

signal RxReg12       : std_logic_vector(15 downto 0);
-- Receive FIFO register12 

signal NextRxReg12   : std_logic_vector(15 downto 0);
-- D-input of RxReg12

signal RxReg13       : std_logic_vector(15 downto 0);
-- Receive FIFO register13 

signal NextRxReg13   : std_logic_vector(15 downto 0);
-- D-input of RxReg13

signal RxReg14       : std_logic_vector(15 downto 0);
-- Receive FIFO register14 

signal NextRxReg14   : std_logic_vector(15 downto 0);
-- D-input of RxReg14

signal RxReg15       : std_logic_vector(15 downto 0);
-- Receive FIFO register15 

signal NextRxReg15   : std_logic_vector(15 downto 0);
-- D-input of RxReg15

-- -----------------------------------------------------------------------------
-- 
-- Main body of Code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Register array. 
-- -----------------------------------------------------------------------------
p_Seq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    RxReg0  <= (others => '0');
    RxReg1  <= (others => '0');
    RxReg2  <= (others => '0');
    RxReg3  <= (others => '0');
    RxReg4  <= (others => '0');
    RxReg5  <= (others => '0');
    RxReg6  <= (others => '0');
    RxReg7  <= (others => '0');
    RxReg8  <= (others => '0');
    RxReg9  <= (others => '0');
    RxReg10 <= (others => '0');
    RxReg11 <= (others => '0');
    RxReg12 <= (others => '0');
    RxReg13 <= (others => '0');
    RxReg14 <= (others => '0');
    RxReg15 <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    RxReg0  <= NextRxReg0;
    RxReg1  <= NextRxReg1;
    RxReg2  <= NextRxReg2;
    RxReg3  <= NextRxReg3;
    RxReg4  <= NextRxReg4;
    RxReg5  <= NextRxReg5;
    RxReg6  <= NextRxReg6;
    RxReg7  <= NextRxReg7; 
    RxReg8  <= NextRxReg8;
    RxReg9  <= NextRxReg9;
    RxReg10 <= NextRxReg10;
    RxReg11 <= NextRxReg11;
    RxReg12 <= NextRxReg12;
    RxReg13 <= NextRxReg13;
    RxReg14 <= NextRxReg14;
    RxReg15 <= NextRxReg15; 
  end if;
end process p_Seq;

-- -----------------------------------------------------------------------------
-- Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
-- the write data bus PWDATAIn is written into the location pointed to by the 
-- current value of the Write pointer, WrPtr[2:0].
-- -----------------------------------------------------------------------------
p_WrComb: process (RxReg0, RxReg1, RxReg2, RxReg3, RxReg4, RxReg5, RxReg6, 
                   RxReg7, RxReg8, RxReg9, RxReg10, RxReg11, RxReg12, RxReg13,
                   RxReg14, RxReg15, WrPtr, RegFileWrEn, RxFWrData)
begin
  NextRxReg0  <= RxReg0;
  NextRxReg1  <= RxReg1;
  NextRxReg2  <= RxReg2;
  NextRxReg3  <= RxReg3;
  NextRxReg4  <= RxReg4;
  NextRxReg5  <= RxReg5;
  NextRxReg6  <= RxReg6;
  NextRxReg7  <= RxReg7;
  NextRxReg8  <= RxReg8;
  NextRxReg9  <= RxReg9;
  NextRxReg10 <= RxReg10;
  NextRxReg11 <= RxReg11;
  NextRxReg12 <= RxReg12;
  NextRxReg13 <= RxReg13;
  NextRxReg14 <= RxReg14;
  NextRxReg15 <= RxReg15;
  if (RegFileWrEn = '1') then
    case WrPtr is
      when "0000" =>
        NextRxReg0 <= RxFWrData;
      when "0001" =>
        NextRxReg1 <= RxFWrData;
      when "0010" =>
        NextRxReg2 <= RxFWrData;
      when "0011" =>
        NextRxReg3 <= RxFWrData;
      when "0100" =>
        NextRxReg4 <= RxFWrData;
      when "0101" =>
        NextRxReg5 <= RxFWrData;
      when "0110" =>
        NextRxReg6 <= RxFWrData;
      when "0111" =>
        NextRxReg7 <= RxFWrData;
      when "1000" =>
        NextRxReg8 <= RxFWrData;
      when "1001" =>
        NextRxReg9 <= RxFWrData;
      when "1010" =>
        NextRxReg10 <= RxFWrData;
      when "1011" =>
        NextRxReg11 <= RxFWrData;
      when "1100" =>
        NextRxReg12 <= RxFWrData;
      when "1101" =>
        NextRxReg13 <= RxFWrData;
      when "1110" =>
        NextRxReg14 <= RxFWrData;
      when "1111" =>
        NextRxReg15 <= RxFWrData;
      when others =>
        null;
    end case;
  end if;
end process p_WrComb;

-- -----------------------------------------------------------------------------
-- Read Mux. The contents of the location pointed to by the current value of 
-- the read pointer RdPtr, is driven onto the read databus, RxFRdData.
-- -----------------------------------------------------------------------------
RxFRdData <= RxReg0  when (RdPtr = "0000") 
          else
             RxReg1  when (RdPtr = "0001") 
          else
             RxReg2  when (RdPtr = "0010") 
          else
             RxReg3  when (RdPtr = "0011") 
          else
             RxReg4  when (RdPtr = "0100") 
          else
             RxReg5  when (RdPtr = "0101") 
          else
             RxReg6  when (RdPtr = "0110") 
          else
             RxReg7  when (RdPtr = "0111") 
          else
             RxReg8  when (RdPtr = "1000") 
          else
             RxReg9  when (RdPtr = "1001") 
          else
             RxReg10 when (RdPtr = "1010") 
          else
             RxReg11 when (RdPtr = "1011") 
          else
             RxReg12 when (RdPtr = "1100") 
          else
             RxReg13 when (RdPtr = "1101") 
          else
             RxReg14 when (RdPtr = "1110") 
          else
             RxReg15 when (RdPtr = "1111") 
          else
             (others => '0');

end behavioural;

-- --============================ End ========================================--
