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
--  File Name              : SspTrTxRegFile.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : Register File for Transmit FIFO
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrTxRegFile is
  port (
        PCLK         : in  std_logic;   -- APB bus clock
        PRESETn      : in  std_logic;   -- Muxed Reset (from PRESETn)
        RegFileWrEn  : in  std_logic;   -- Write enable for Reg file 
        WrPtr        : in  std_logic_vector(3 downto 0);
                                        -- Write pointer
        RdPtr        : in  std_logic_vector(3 downto 0);
                                        -- Read pointer
        PWDATAIn     : in  std_logic_vector(15 downto 0);
                                        -- Int PWDATA
        TxFRdData    : out std_logic_vector(15 downto 0)
                                         -- Read data
       );
end SspTrTxRegFile;

-- -----------------------------------------------------------------------------
--
--                               SspTrTxRegFile
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module contains the Register file for the Transmit FIFO. When the 
-- Write enable signal RegFileWrEn is asserted, data on the write data bus 
-- PWDATAIn is written into the location pointed to by the current value of the
-- Write pointer WrPtr. On the read interface, the contents of the location
-- pointed to by the current value of the read pointer RdPtr, is driven onto
-- the read databus, TxFRdData.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of SspTrTxRegFile is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TxReg0        : std_logic_vector(15 downto 0);
-- Transmit FIFO register0 

signal NextTxReg0    : std_logic_vector(15 downto 0);
-- D-input of TxReg0

signal TxReg1        : std_logic_vector(15 downto 0);
-- Transmit FIFO register1

signal NextTxReg1    : std_logic_vector(15 downto 0);
-- D-input of TxReg1

signal TxReg2        : std_logic_vector(15 downto 0);
-- Transmit FIFO register2

signal NextTxReg2    : std_logic_vector(15 downto 0);
-- D-input of TxReg2

signal TxReg3        : std_logic_vector(15 downto 0);
-- Transmit FIFO register3

signal NextTxReg3    : std_logic_vector(15 downto 0);
-- D-input of TxReg3

signal TxReg4        : std_logic_vector(15 downto 0);
-- Transmit FIFO register4

signal NextTxReg4    : std_logic_vector(15 downto 0);
-- D-input of TxReg4

signal TxReg5        : std_logic_vector(15 downto 0);
-- Transmit FIFO register5

signal NextTxReg5    : std_logic_vector(15 downto 0);
-- D-input of TxReg5

signal TxReg6        : std_logic_vector(15 downto 0);
-- Transmit FIFO register6

signal NextTxReg6    : std_logic_vector(15 downto 0);
-- D-input of TxReg6

signal TxReg7        : std_logic_vector(15 downto 0);
-- Transmit FIFO register7

signal NextTxReg7    : std_logic_vector(15 downto 0);
-- D-input of TxReg7

signal TxReg8        : std_logic_vector(15 downto 0);
-- Transmit FIFO register8

signal NextTxReg8    : std_logic_vector(15 downto 0);
-- D-input of TxReg8

signal TxReg9        : std_logic_vector(15 downto 0);
-- Transmit FIFO register9

signal NextTxReg9    : std_logic_vector(15 downto 0);
-- D-input of TxReg9

signal TxReg10       : std_logic_vector(15 downto 0);
-- Transmit FIFO register10

signal NextTxReg10   : std_logic_vector(15 downto 0);
-- D-input of TxReg10

signal TxReg11       : std_logic_vector(15 downto 0);
-- Transmit FIFO register11

signal NextTxReg11   : std_logic_vector(15 downto 0);
-- D-input of TxReg11

signal TxReg12       : std_logic_vector(15 downto 0);
-- Transmit FIFO register12

signal NextTxReg12   : std_logic_vector(15 downto 0);
-- D-input of TxReg12

signal TxReg13       : std_logic_vector(15 downto 0);
-- Transmit FIFO register13

signal NextTxReg13   : std_logic_vector(15 downto 0);
-- D-input of TxReg13

signal TxReg14       : std_logic_vector(15 downto 0);
-- Transmit FIFO register14

signal NextTxReg14   : std_logic_vector(15 downto 0);
-- D-input of TxReg14

signal TxReg15       : std_logic_vector(15 downto 0);
-- Transmit FIFO register15

signal NextTxReg15   : std_logic_vector(15 downto 0);
-- D-input of TxReg15

-- -----------------------------------------------------------------------------
-- 
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Register array. Not asynchronously resettable so as to save gates.
-- -----------------------------------------------------------------------------
p_Seq: process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    TxReg0  <= (others => '0');
    TxReg1  <= (others => '0');
    TxReg2  <= (others => '0');
    TxReg3  <= (others => '0');
    TxReg4  <= (others => '0');
    TxReg5  <= (others => '0');
    TxReg6  <= (others => '0');
    TxReg7  <= (others => '0');
    TxReg8  <= (others => '0');
    TxReg9  <= (others => '0');
    TxReg10 <= (others => '0');
    TxReg11 <= (others => '0');
    TxReg12 <= (others => '0');
    TxReg13 <= (others => '0');
    TxReg14 <= (others => '0');
    TxReg15 <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    TxReg0  <= NextTxReg0;
    TxReg1  <= NextTxReg1;
    TxReg2  <= NextTxReg2;
    TxReg3  <= NextTxReg3;
    TxReg4  <= NextTxReg4;
    TxReg5  <= NextTxReg5;
    TxReg6  <= NextTxReg6;
    TxReg7  <= NextTxReg7;
    TxReg8  <= NextTxReg8;
    TxReg9  <= NextTxReg9;
    TxReg10 <= NextTxReg10;
    TxReg11 <= NextTxReg11;
    TxReg12 <= NextTxReg12;
    TxReg13 <= NextTxReg13;
    TxReg14 <= NextTxReg14;
    TxReg15 <= NextTxReg15;
  end if;
end process p_Seq;

-- -----------------------------------------------------------------------------
-- Write logic. When the Write enable signal, RegFileWrEn, is asserted, data on
-- the write data bus PWDATAIn is written into the location pointed to by the
-- current value of the Write pointer, WrPtr[3:0].
-- -----------------------------------------------------------------------------
p_WrComb: process (TxReg0, TxReg1, TxReg2, TxReg3, TxReg4, TxReg5, TxReg6, 
                   TxReg7, TxReg8, TxReg9, TxReg10, TxReg11, TxReg12, TxReg13, 
                   TxReg14, TxReg15, WrPtr, RegFileWrEn, PWDATAIn)
begin
  NextTxReg0  <= TxReg0;
  NextTxReg1  <= TxReg1;
  NextTxReg2  <= TxReg2;
  NextTxReg3  <= TxReg3;
  NextTxReg4  <= TxReg4;
  NextTxReg5  <= TxReg5;
  NextTxReg6  <= TxReg6;
  NextTxReg7  <= TxReg7;
  NextTxReg8  <= TxReg8;
  NextTxReg9  <= TxReg9;
  NextTxReg10 <= TxReg10;
  NextTxReg11 <= TxReg11;
  NextTxReg12 <= TxReg12;
  NextTxReg13 <= TxReg13;
  NextTxReg14 <= TxReg14;
  NextTxReg15 <= TxReg15;
  if (RegFileWrEn = '1') then
    case WrPtr is
      when "0000" =>
        NextTxReg0 <= PWDATAIn;
      when "0001" =>
        NextTxReg1 <= PWDATAIn;
      when "0010" =>
        NextTxReg2 <= PWDATAIn;
      when "0011" =>
        NextTxReg3 <= PWDATAIn;
      when "0100" =>
        NextTxReg4 <= PWDATAIn;
      when "0101" =>
        NextTxReg5 <= PWDATAIn;
      when "0110" =>
        NextTxReg6 <= PWDATAIn;
      when "0111" =>
        NextTxReg7 <= PWDATAIn;
      when "1000" =>
        NextTxReg8 <= PWDATAIn;
      when "1001" =>
        NextTxReg9 <= PWDATAIn;
      when "1010" =>
        NextTxReg10 <= PWDATAIn;
      when "1011" =>
        NextTxReg11 <= PWDATAIn;
      when "1100" =>
        NextTxReg12 <= PWDATAIn;
      when "1101" =>
        NextTxReg13 <= PWDATAIn;
      when "1110" =>
        NextTxReg14 <= PWDATAIn;
      when "1111" =>
        NextTxReg15 <= PWDATAIn;
      when others =>
        null;
    end case;
  end if;
end process p_WrComb;

-- -----------------------------------------------------------------------------
-- Read Mux. The contents of the location pointed to by the current value of
-- the read pointer RdPtr, is driven onto the read databus, TxFRdData.
-- -----------------------------------------------------------------------------
TxFRdData <= TxReg0  when (RdPtr = "0000") 
          else
             TxReg1  when (RdPtr = "0001") 
          else
             TxReg2  when (RdPtr = "0010") 
          else
             TxReg3  when (RdPtr = "0011") 
          else
             TxReg4  when (RdPtr = "0100") 
          else
             TxReg5  when (RdPtr = "0101") 
          else
             TxReg6  when (RdPtr = "0110") 
          else
             TxReg7  when (RdPtr = "0111") 
          else
             TxReg8  when (RdPtr = "1000") 
          else
             TxReg9  when (RdPtr = "1001") 
          else
             TxReg10 when (RdPtr = "1010") 
          else
             TxReg11 when (RdPtr = "1011") 
          else
             TxReg12 when (RdPtr = "1100") 
          else
             TxReg13 when (RdPtr = "1101") 
          else
             TxReg14 when (RdPtr = "1110") 
          else
             TxReg15 when (RdPtr = "1111") 
          else
             (others => '0');

end behavioural;

-- --=========================== End =========================================--

