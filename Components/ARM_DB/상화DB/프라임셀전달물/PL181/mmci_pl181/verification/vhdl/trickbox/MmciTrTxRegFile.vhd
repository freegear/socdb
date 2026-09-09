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
-- File Name              : MmciTrTxRegFile.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Receive FIFO Register File
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
entity MmciTrTxRegFile is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB Bus Reset
        RegFileWrEn      : in    std_logic; -- Write enable
        WrPtr            : in    std_logic_vector(4 downto 0);
                                            -- Write pointer
        RdPtr            : in    std_logic_vector(4 downto 0);
                                            -- Read pointer
        PWDATAIn         : in    std_logic_vector(31 downto 0);
                                            -- Write data
-- Outputs
        TxFRdData        : out   std_logic_vector(31 downto 0)
                                            -- Read Data
       );
end MmciTrTxRegFile;

-- -----------------------------------------------------------------------------
--
--                               MmciTrTxRegFile
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module contains the Register file for the Transmit FIFO.When the
-- Write enable signal RegFileWrEn is asserted, data on the wr data bus
-- is written into the location pointed to by the current value of the
-- Write pointer, WrPtr[3:0]. On the read interface, the contents of the
-- location pointed to by the current value of the read ptr RdPtr, is
-- driven onto the read databus, TxFRdData.
--
-- -----------------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture behavioural of MmciTrTxRegFile is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TxReg0           : std_logic_vector(31 downto 0);
-- Receive FIFO register0

signal NextTxReg0       : std_logic_vector(31 downto 0);
-- D-input of TxReg0

signal TxReg1           : std_logic_vector(31 downto 0);
-- Receive FIFO register1

signal NextTxReg1       : std_logic_vector(31 downto 0);
-- D-input of TxReg1

signal TxReg2           : std_logic_vector(31 downto 0);
-- Receive FIFO register2

signal NextTxReg2       : std_logic_vector(31 downto 0);
-- D-input of TxReg2

signal TxReg3           : std_logic_vector(31 downto 0);
-- Receive FIFO register3

signal NextTxReg3       : std_logic_vector(31 downto 0);
-- D-input of TxReg3

signal TxReg4           : std_logic_vector(31 downto 0);
-- Receive FIFO register4

signal NextTxReg4       : std_logic_vector(31 downto 0);
-- D-input of TxReg4

signal TxReg5           : std_logic_vector(31 downto 0);
-- Receive FIFO register5

signal NextTxReg5       : std_logic_vector(31 downto 0);
-- D-input of TxReg5

signal TxReg6           : std_logic_vector(31 downto 0);
-- Receive FIFO register6

signal NextTxReg6       : std_logic_vector(31 downto 0);
-- D-input of TxReg6

signal TxReg7           : std_logic_vector(31 downto 0);
-- Receive FIFO register7

signal NextTxReg7       : std_logic_vector(31 downto 0);
-- D-input of TxReg7

signal TxReg8           : std_logic_vector(31 downto 0);
-- Receive FIFO register8

signal NextTxReg8       : std_logic_vector(31 downto 0);
-- D-input of TxReg8

signal TxReg9           : std_logic_vector(31 downto 0);
-- Receive FIFO register9

signal NextTxReg9       : std_logic_vector(31 downto 0);
-- D-input of TxReg9

signal TxReg10          : std_logic_vector(31 downto 0);
-- Receive FIFO register10

signal NextTxReg10      : std_logic_vector(31 downto 0);
-- D-input of TxReg10

signal TxReg11          : std_logic_vector(31 downto 0);
-- Receive FIFO register11

signal NextTxReg11      : std_logic_vector(31 downto 0);
-- D-input of TxReg11

signal TxReg12          : std_logic_vector(31 downto 0);
-- Receive FIFO register12

signal NextTxReg12      : std_logic_vector(31 downto 0);
-- D-input of TxReg12

signal TxReg13          : std_logic_vector(31 downto 0);
-- Receive FIFO register13

signal NextTxReg13      : std_logic_vector(31 downto 0);
-- D-input of TxReg13

signal TxReg14          : std_logic_vector(31 downto 0);
-- Receive FIFO register14

signal NextTxReg14      : std_logic_vector(31 downto 0);
-- D-input of TxReg14

signal TxReg15          : std_logic_vector(31 downto 0);
-- Receive FIFO register15

signal NextTxReg15      : std_logic_vector(31 downto 0);
-- D-input of TxReg15

signal TxReg16          : std_logic_vector(31 downto 0);
-- Receive FIFO register16

signal NextTxReg16      : std_logic_vector(31 downto 0);
-- D-input of TxReg16

signal TxReg17          : std_logic_vector(31 downto 0);
-- Receive FIFO register17

signal NextTxReg17      : std_logic_vector(31 downto 0);
-- D-input of TxReg17

signal TxReg18          : std_logic_vector(31 downto 0);
-- Receive FIFO register18

signal NextTxReg18      : std_logic_vector(31 downto 0);
-- D-input of TxReg18

signal TxReg19          : std_logic_vector(31 downto 0);
-- Receive FIFO register19

signal NextTxReg19      : std_logic_vector(31 downto 0);
-- D-input of TxReg19

signal TxReg20          : std_logic_vector(31 downto 0);
-- Receive FIFO register20

signal NextTxReg20      : std_logic_vector(31 downto 0);
-- D-input of TxReg20

signal TxReg21          : std_logic_vector(31 downto 0);
-- Receive FIFO register21

signal NextTxReg21      : std_logic_vector(31 downto 0);
-- D-input of TxReg21

signal TxReg22          : std_logic_vector(31 downto 0);
-- Receive FIFO register22

signal NextTxReg22      : std_logic_vector(31 downto 0);
-- D-input of TxReg22

signal TxReg23          : std_logic_vector(31 downto 0);
-- Receive FIFO register23

signal NextTxReg23      : std_logic_vector(31 downto 0);
-- D-input of TxReg23

signal TxReg24          : std_logic_vector(31 downto 0);
-- Receive FIFO register24

signal NextTxReg24      : std_logic_vector(31 downto 0);
-- D-input of TxReg24

signal TxReg25          : std_logic_vector(31 downto 0);
-- Receive FIFO register25

signal NextTxReg25      : std_logic_vector(31 downto 0);
-- D-input of TxReg25

signal TxReg26          : std_logic_vector(31 downto 0);
-- Receive FIFO register26

signal NextTxReg26      : std_logic_vector(31 downto 0);
-- D-input of TxReg26

signal TxReg27          : std_logic_vector(31 downto 0);
-- Receive FIFO register27

signal NextTxReg27      : std_logic_vector(31 downto 0);
-- D-input of TxReg27

signal TxReg28          : std_logic_vector(31 downto 0);
-- Receive FIFO register28

signal NextTxReg28      : std_logic_vector(31 downto 0);
-- D-input of TxReg28

signal TxReg29          : std_logic_vector(31 downto 0);
-- Receive FIFO register29

signal NextTxReg29      : std_logic_vector(31 downto 0);
-- D-input of TxReg29

signal TxReg30          : std_logic_vector(31 downto 0);
-- Receive FIFO register30

signal NextTxReg30      : std_logic_vector(31 downto 0);
-- D-input of TxReg30

signal TxReg31          : std_logic_vector(31 downto 0);
-- Receive FIFO register31

signal NextTxReg31      : std_logic_vector(31 downto 0);
-- D-input of TxReg31

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
-- Register array.
-- -----------------------------------------------------------------------------
p_Seq : process (PCLK, PRESETn)
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
    TxReg16 <= (others => '0');
    TxReg17 <= (others => '0');
    TxReg18 <= (others => '0');
    TxReg19 <= (others => '0');
    TxReg20 <= (others => '0');
    TxReg21 <= (others => '0');
    TxReg22 <= (others => '0');
    TxReg23 <= (others => '0');
    TxReg24 <= (others => '0');
    TxReg25 <= (others => '0');
    TxReg26 <= (others => '0');
    TxReg27 <= (others => '0');
    TxReg28 <= (others => '0');
    TxReg29 <= (others => '0');
    TxReg30 <= (others => '0');
    TxReg31 <= (others => '0');
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
    TxReg16 <= NextTxReg16;
    TxReg17 <= NextTxReg17;
    TxReg18 <= NextTxReg18;
    TxReg19 <= NextTxReg19;
    TxReg20 <= NextTxReg20;
    TxReg21 <= NextTxReg21;
    TxReg22 <= NextTxReg22;
    TxReg23 <= NextTxReg23;
    TxReg24 <= NextTxReg24;
    TxReg25 <= NextTxReg25;
    TxReg26 <= NextTxReg26;
    TxReg27 <= NextTxReg27;
    TxReg28 <= NextTxReg28;
    TxReg29 <= NextTxReg29;
    TxReg30 <= NextTxReg30;
    TxReg31 <= NextTxReg31;
  end if;
end process p_Seq;

-- -----------------------------------------------------------------------------
-- Write logic. When the Write enable signal, RegFileWrEn, is asserted,
-- data on the write data bus PWDATAIn is written into the location
-- pointed to by the current value of the Write pointer, WrPtr[2:0].
-- -----------------------------------------------------------------------------
p_WrComb : process (TxReg0, TxReg1, TxReg2, TxReg3, TxReg4, TxReg5,
                    TxReg6, TxReg7, TxReg8, TxReg9, TxReg10, TxReg11,
                    TxReg12, TxReg13, TxReg14, TxReg15, TxReg16,
                    TxReg17, TxReg18, TxReg19, TxReg20, TxReg21,
                    TxReg22, TxReg23, TxReg24, TxReg25, TxReg26,
                    TxReg27, TxReg28, TxReg29, TxReg30, TxReg31,
                    WrPtr, RegFileWrEn, PWDATAIn)
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
  NextTxReg16 <= TxReg16;
  NextTxReg17 <= TxReg17;
  NextTxReg18 <= TxReg18;
  NextTxReg19 <= TxReg19;
  NextTxReg20 <= TxReg20;
  NextTxReg21 <= TxReg21;
  NextTxReg22 <= TxReg22;
  NextTxReg23 <= TxReg23;
  NextTxReg24 <= TxReg24;
  NextTxReg25 <= TxReg25;
  NextTxReg26 <= TxReg26;
  NextTxReg27 <= TxReg27;
  NextTxReg28 <= TxReg28;
  NextTxReg29 <= TxReg29;
  NextTxReg30 <= TxReg30;
  NextTxReg31 <= TxReg31;
  if (RegFileWrEn = '1') then
    case WrPtr is
      when "00000" =>
        NextTxReg0 <= PWDATAIn;
      when "00001" =>
        NextTxReg1 <= PWDATAIn;
      when "00010" =>
        NextTxReg2 <= PWDATAIn;
      when "00011" =>
        NextTxReg3 <= PWDATAIn;
      when "00100" =>
        NextTxReg4 <= PWDATAIn;
      when "00101" =>
        NextTxReg5 <= PWDATAIn;
      when "00110" =>
        NextTxReg6 <= PWDATAIn;
      when "00111" =>
        NextTxReg7 <= PWDATAIn;
      when "01000" =>
        NextTxReg8 <= PWDATAIn;
      when "01001" =>
        NextTxReg9 <= PWDATAIn;
      when "01010" =>
        NextTxReg10 <= PWDATAIn;
      when "01011" =>
        NextTxReg11 <= PWDATAIn;
      when "01100" =>
        NextTxReg12 <= PWDATAIn;
      when "01101" =>
        NextTxReg13 <= PWDATAIn;
      when "01110" =>
        NextTxReg14 <= PWDATAIn;
      when "01111" =>
        NextTxReg15 <= PWDATAIn;
      when "10000" =>
        NextTxReg16 <= PWDATAIn;
      when "10001" =>
        NextTxReg17 <= PWDATAIn;
      when "10010" =>
        NextTxReg18 <= PWDATAIn;
      when "10011" =>
        NextTxReg19 <= PWDATAIn;
      when "10100" =>
        NextTxReg20 <= PWDATAIn;
      when "10101" =>
        NextTxReg21 <= PWDATAIn;
      when "10110" =>
        NextTxReg22 <= PWDATAIn;
      when "10111" =>
        NextTxReg23 <= PWDATAIn;
      when "11000" =>
        NextTxReg24 <= PWDATAIn;
      when "11001" =>
        NextTxReg25 <= PWDATAIn;
      when "11010" =>
        NextTxReg26 <= PWDATAIn;
      when "11011" =>
        NextTxReg27 <= PWDATAIn;
      when "11100" =>
        NextTxReg28 <= PWDATAIn;
      when "11101" =>
        NextTxReg29 <= PWDATAIn;
      when "11110" =>
        NextTxReg30 <= PWDATAIn;
      when "11111" =>
        NextTxReg31 <= PWDATAIn;
      when others =>
        null;
    end case;
  end if;
end process p_WrComb;

-- -----------------------------------------------------------------------------
-- Read Mux.The contents of the location pointed to by the current value
-- of the read ptr RdPtr, is driven onto the read databus, TxFRdData.
-- -----------------------------------------------------------------------------
TxFRdData <= TxReg0  when (RdPtr = "00000")
          else
             TxReg1  when (RdPtr = "00001")
          else
             TxReg2  when (RdPtr = "00010")
          else
             TxReg3  when (RdPtr = "00011")
          else
             TxReg4  when (RdPtr = "00100")
          else
             TxReg5  when (RdPtr = "00101")
          else
             TxReg6  when (RdPtr = "00110")
          else
             TxReg7  when (RdPtr = "00111")
          else
             TxReg8  when (RdPtr = "01000")
          else
             TxReg9  when (RdPtr = "01001")
          else
             TxReg10 when (RdPtr = "01010")
          else
             TxReg11 when (RdPtr = "01011")
          else
             TxReg12 when (RdPtr = "01100")
          else
             TxReg13 when (RdPtr = "01101")
          else
             TxReg14 when (RdPtr = "01110")
          else
             TxReg15 when (RdPtr = "01111")
          else
             TxReg16 when (RdPtr = "10000")
          else
             TxReg17 when (RdPtr = "10001")
          else
             TxReg18 when (RdPtr = "10010")
          else
             TxReg19 when (RdPtr = "10011")
          else
             TxReg20 when (RdPtr = "10100")
          else
             TxReg21 when (RdPtr = "10101")
          else
             TxReg22 when (RdPtr = "10110")
          else
             TxReg23 when (RdPtr = "10111")
          else
             TxReg24 when (RdPtr = "11000")
          else
             TxReg25 when (RdPtr = "11001")
          else
             TxReg26 when (RdPtr = "11010")
          else
             TxReg27 when (RdPtr = "11011")
          else
             TxReg28 when (RdPtr = "11100")
          else
             TxReg29 when (RdPtr = "11101")
          else
             TxReg30 when (RdPtr = "11110")
          else
             TxReg31 when (RdPtr = "11111")
          else
             (others => '0');

end behavioural;

-- --================================== End ==================================--
