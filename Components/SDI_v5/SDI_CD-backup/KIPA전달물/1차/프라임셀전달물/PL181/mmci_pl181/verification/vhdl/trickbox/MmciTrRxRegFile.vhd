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
-- File Name              : MmciTrRxRegFile.vhd.rca
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
entity MmciTrRxRegFile is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB Bus Reset
        RegFileWrEn      : in    std_logic; -- Write enable
        WrPtr            : in    std_logic_vector(4 downto 0);
                                            -- Write pointer
        RdPtr            : in    std_logic_vector(4 downto 0);
                                            -- Read pointer
        RxFWrData        : in    std_logic_vector(32 downto 0);
                                            -- Write data, contains
                                            -- CrcErrStat
-- Outputs
        RxFRdData        : out   std_logic_vector(32 downto 0)
                                            -- Read Data
       );
end MmciTrRxRegFile;

-- -----------------------------------------------------------------------------
--
--                               MmciTrRxRegFile
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module contains the Register file for the Receive FIFO. When the
-- Write enable signal RegFileWrEn is asserted, data on the write data
-- bus is written into the location pointed to by the current value of
-- the Write pointer, WrPtr[3:0]. On the read interface, the contents
-- of the location pointed to by the current value of the read pointer
-- RdPtr, is driven onto the read databus, RxFRdData.
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of MmciTrRxRegFile is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RxReg0           : std_logic_vector(32 downto 0);
-- Receive FIFO register0

signal NextRxReg0       : std_logic_vector(32 downto 0);
-- D-input of RxReg0

signal RxReg1           : std_logic_vector(32 downto 0);
-- Receive FIFO register1

signal NextRxReg1       : std_logic_vector(32 downto 0);
-- D-input of RxReg1

signal RxReg2           : std_logic_vector(32 downto 0);
-- Receive FIFO register2

signal NextRxReg2       : std_logic_vector(32 downto 0);
-- D-input of RxReg2

signal RxReg3           : std_logic_vector(32 downto 0);
-- Receive FIFO register3

signal NextRxReg3       : std_logic_vector(32 downto 0);
-- D-input of RxReg3

signal RxReg4           : std_logic_vector(32 downto 0);
-- Receive FIFO register4

signal NextRxReg4       : std_logic_vector(32 downto 0);
-- D-input of RxReg4

signal RxReg5           : std_logic_vector(32 downto 0);
-- Receive FIFO register5

signal NextRxReg5       : std_logic_vector(32 downto 0);
-- D-input of RxReg5

signal RxReg6           : std_logic_vector(32 downto 0);
-- Receive FIFO register6

signal NextRxReg6       : std_logic_vector(32 downto 0);
-- D-input of RxReg6

signal RxReg7           : std_logic_vector(32 downto 0);
-- Receive FIFO register7

signal NextRxReg7       : std_logic_vector(32 downto 0);
-- D-input of RxReg7

signal RxReg8           : std_logic_vector(32 downto 0);
-- Receive FIFO register8

signal NextRxReg8       : std_logic_vector(32 downto 0);
-- D-input of RxReg8

signal RxReg9           : std_logic_vector(32 downto 0);
-- Receive FIFO register9

signal NextRxReg9       : std_logic_vector(32 downto 0);
-- D-input of RxReg9

signal RxReg10          : std_logic_vector(32 downto 0);
-- Receive FIFO register10

signal NextRxReg10      : std_logic_vector(32 downto 0);
-- D-input of RxReg10

signal RxReg11          : std_logic_vector(32 downto 0);
-- Receive FIFO register11

signal NextRxReg11      : std_logic_vector(32 downto 0);
-- D-input of RxReg11

signal RxReg12          : std_logic_vector(32 downto 0);
-- Receive FIFO register12

signal NextRxReg12      : std_logic_vector(32 downto 0);
-- D-input of RxReg12

signal RxReg13          : std_logic_vector(32 downto 0);
-- Receive FIFO register13

signal NextRxReg13      : std_logic_vector(32 downto 0);
-- D-input of RxReg13

signal RxReg14          : std_logic_vector(32 downto 0);
-- Receive FIFO register14

signal NextRxReg14      : std_logic_vector(32 downto 0);
-- D-input of RxReg14

signal RxReg15          : std_logic_vector(32 downto 0);
-- Receive FIFO register15

signal NextRxReg15      : std_logic_vector(32 downto 0);
-- D-input of RxReg15

signal RxReg16          : std_logic_vector(32 downto 0);
-- Receive FIFO register16

signal NextRxReg16      : std_logic_vector(32 downto 0);
-- D-input of RxReg16

signal RxReg17          : std_logic_vector(32 downto 0);
-- Receive FIFO register17

signal NextRxReg17      : std_logic_vector(32 downto 0);
-- D-input of RxReg17

signal RxReg18          : std_logic_vector(32 downto 0);
-- Receive FIFO register18

signal NextRxReg18      : std_logic_vector(32 downto 0);
-- D-input of RxReg18

signal RxReg19          : std_logic_vector(32 downto 0);
-- Receive FIFO register19

signal NextRxReg19      : std_logic_vector(32 downto 0);
-- D-input of RxReg19

signal RxReg20          : std_logic_vector(32 downto 0);
-- Receive FIFO register20

signal NextRxReg20      : std_logic_vector(32 downto 0);
-- D-input of RxReg20

signal RxReg21          : std_logic_vector(32 downto 0);
-- Receive FIFO register21

signal NextRxReg21      : std_logic_vector(32 downto 0);
-- D-input of RxReg21

signal RxReg22          : std_logic_vector(32 downto 0);
-- Receive FIFO register22

signal NextRxReg22      : std_logic_vector(32 downto 0);
-- D-input of RxReg22

signal RxReg23          : std_logic_vector(32 downto 0);
-- Receive FIFO register23

signal NextRxReg23      : std_logic_vector(32 downto 0);
-- D-input of RxReg23

signal RxReg24          : std_logic_vector(32 downto 0);
-- Receive FIFO register24

signal NextRxReg24      : std_logic_vector(32 downto 0);
-- D-input of RxReg24

signal RxReg25          : std_logic_vector(32 downto 0);
-- Receive FIFO register25

signal NextRxReg25      : std_logic_vector(32 downto 0);
-- D-input of RxReg25

signal RxReg26          : std_logic_vector(32 downto 0);
-- Receive FIFO register26

signal NextRxReg26      : std_logic_vector(32 downto 0);
-- D-input of RxReg26

signal RxReg27          : std_logic_vector(32 downto 0);
-- Receive FIFO register27

signal NextRxReg27      : std_logic_vector(32 downto 0);
-- D-input of RxReg27

signal RxReg28          : std_logic_vector(32 downto 0);
-- Receive FIFO register28

signal NextRxReg28      : std_logic_vector(32 downto 0);
-- D-input of RxReg28

signal RxReg29          : std_logic_vector(32 downto 0);
-- Receive FIFO register29

signal NextRxReg29      : std_logic_vector(32 downto 0);
-- D-input of RxReg29

signal RxReg30          : std_logic_vector(32 downto 0);
-- Receive FIFO register30

signal NextRxReg30      : std_logic_vector(32 downto 0);
-- D-input of RxReg30

signal RxReg31          : std_logic_vector(32 downto 0);
-- Receive FIFO register31

signal NextRxReg31      : std_logic_vector(32 downto 0);
-- D-input of RxReg31

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
    RxReg16 <= (others => '0');
    RxReg17 <= (others => '0');
    RxReg18 <= (others => '0');
    RxReg19 <= (others => '0');
    RxReg20 <= (others => '0');
    RxReg21 <= (others => '0');
    RxReg22 <= (others => '0');
    RxReg23 <= (others => '0');
    RxReg24 <= (others => '0');
    RxReg25 <= (others => '0');
    RxReg26 <= (others => '0');
    RxReg27 <= (others => '0');
    RxReg28 <= (others => '0');
    RxReg29 <= (others => '0');
    RxReg30 <= (others => '0');
    RxReg31 <= (others => '0');
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
    RxReg16 <= NextRxReg16;
    RxReg17 <= NextRxReg17;
    RxReg18 <= NextRxReg18;
    RxReg19 <= NextRxReg19;
    RxReg20 <= NextRxReg20;
    RxReg21 <= NextRxReg21;
    RxReg22 <= NextRxReg22;
    RxReg23 <= NextRxReg23;
    RxReg24 <= NextRxReg24;
    RxReg25 <= NextRxReg25;
    RxReg26 <= NextRxReg26;
    RxReg27 <= NextRxReg27;
    RxReg28 <= NextRxReg28;
    RxReg29 <= NextRxReg29;
    RxReg30 <= NextRxReg30;
    RxReg31 <= NextRxReg31;
  end if;
end process p_Seq;

-- -----------------------------------------------------------------------------
-- Write logic. When the Write enable signal, RegFileWrEn, is asserted,
-- data on the write data bus PWDATAIn is written into the location
-- pointed to by the current value of the Write pointer, WrPtr[2:0].
-- -----------------------------------------------------------------------------
p_WrComb : process (RxReg0, RxReg1, RxReg2, RxReg3, RxReg4, RxReg5,
                    RxReg6, RxReg7, RxReg8, RxReg9, RxReg10, RxReg11,
                    RxReg12, RxReg13, RxReg14, RxReg15, RxReg16,
                    RxReg17, RxReg18, RxReg19, RxReg20, RxReg21,
                    RxReg22, RxReg23, RxReg24, RxReg25, RxReg26,
                    RxReg27, RxReg28, RxReg29, RxReg30, RxReg31,
                    WrPtr, RegFileWrEn, RxFWrData)
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
  NextRxReg16 <= RxReg16;
  NextRxReg17 <= RxReg17;
  NextRxReg18 <= RxReg18;
  NextRxReg19 <= RxReg19;
  NextRxReg20 <= RxReg20;
  NextRxReg21 <= RxReg21;
  NextRxReg22 <= RxReg22;
  NextRxReg23 <= RxReg23;
  NextRxReg24 <= RxReg24;
  NextRxReg25 <= RxReg25;
  NextRxReg26 <= RxReg26;
  NextRxReg27 <= RxReg27;
  NextRxReg28 <= RxReg28;
  NextRxReg29 <= RxReg29;
  NextRxReg30 <= RxReg30;
  NextRxReg31 <= RxReg31;
  if (RegFileWrEn = '1') then
    case WrPtr is
      when "00000" =>
        NextRxReg0 <= RxFWrData;
      when "00001" =>
        NextRxReg1 <= RxFWrData;
      when "00010" =>
        NextRxReg2 <= RxFWrData;
      when "00011" =>
        NextRxReg3 <= RxFWrData;
      when "00100" =>
        NextRxReg4 <= RxFWrData;
      when "00101" =>
        NextRxReg5 <= RxFWrData;
      when "00110" =>
        NextRxReg6 <= RxFWrData;
      when "00111" =>
        NextRxReg7 <= RxFWrData;
      when "01000" =>
        NextRxReg8 <= RxFWrData;
      when "01001" =>
        NextRxReg9 <= RxFWrData;
      when "01010" =>
        NextRxReg10 <= RxFWrData;
      when "01011" =>
        NextRxReg11 <= RxFWrData;
      when "01100" =>
        NextRxReg12 <= RxFWrData;
      when "01101" =>
        NextRxReg13 <= RxFWrData;
      when "01110" =>
        NextRxReg14 <= RxFWrData;
      when "01111" =>
        NextRxReg15 <= RxFWrData;
      when "10000" =>
        NextRxReg16 <= RxFWrData;
      when "10001" =>
        NextRxReg17 <= RxFWrData;
      when "10010" =>
        NextRxReg18 <= RxFWrData;
      when "10011" =>
        NextRxReg19 <= RxFWrData;
      when "10100" =>
        NextRxReg20 <= RxFWrData;
      when "10101" =>
        NextRxReg21 <= RxFWrData;
      when "10110" =>
        NextRxReg22 <= RxFWrData;
      when "10111" =>
        NextRxReg23 <= RxFWrData;
      when "11000" =>
        NextRxReg24 <= RxFWrData;
      when "11001" =>
        NextRxReg25 <= RxFWrData;
      when "11010" =>
        NextRxReg26 <= RxFWrData;
      when "11011" =>
        NextRxReg27 <= RxFWrData;
      when "11100" =>
        NextRxReg28 <= RxFWrData;
      when "11101" =>
        NextRxReg29 <= RxFWrData;
      when "11110" =>
        NextRxReg30 <= RxFWrData;
      when "11111" =>
        NextRxReg31 <= RxFWrData;
      when others =>
        null;
    end case;
  end if;
end process p_WrComb;

-- -----------------------------------------------------------------------------
-- Read Mux. The contents of the location pointed to by the current
-- value of the read pointer RdPtr, is driven onto the read databus,
-- RxFRdData.
-- -----------------------------------------------------------------------------
RxFRdData <= RxReg0 when (RdPtr = "00000")
          else
             RxReg1 when (RdPtr = "00001")
          else
             RxReg2 when (RdPtr = "00010")
          else
             RxReg3 when (RdPtr = "00011")
          else
             RxReg4 when (RdPtr = "00100")
          else
             RxReg5 when (RdPtr = "00101")
          else
             RxReg6 when (RdPtr = "00110")
          else
             RxReg7 when (RdPtr = "00111")
          else
             RxReg8 when (RdPtr = "01000")
          else
             RxReg9 when (RdPtr = "01001")
          else
             RxReg10 when (RdPtr = "01010")
          else
             RxReg11 when (RdPtr = "01011")
          else
             RxReg12 when (RdPtr = "01100")
          else
             RxReg13 when (RdPtr = "01101")
          else
             RxReg14 when (RdPtr = "01110")
          else
             RxReg15 when (RdPtr = "01111")
          else
             RxReg16 when (RdPtr = "10000")
          else
             RxReg17 when (RdPtr = "10001")
          else
             RxReg18 when (RdPtr = "10010")
          else
             RxReg19 when (RdPtr = "10011")
          else
             RxReg20 when (RdPtr = "10100")
          else
             RxReg21 when (RdPtr = "10101")
          else
             RxReg22 when (RdPtr = "10110")
          else
             RxReg23 when (RdPtr = "10111")
          else
             RxReg24 when (RdPtr = "11000")
          else
             RxReg25 when (RdPtr = "11001")
          else
             RxReg26 when (RdPtr = "11010")
          else
             RxReg27 when (RdPtr = "11011")
          else
             RxReg28 when (RdPtr = "11100")
          else
             RxReg29 when (RdPtr = "11101")
          else
             RxReg30 when (RdPtr = "11110")
          else
             RxReg31 when (RdPtr = "11111")
          else
             (others => '0');

end behavioural;

-- --================================== End ==================================--
