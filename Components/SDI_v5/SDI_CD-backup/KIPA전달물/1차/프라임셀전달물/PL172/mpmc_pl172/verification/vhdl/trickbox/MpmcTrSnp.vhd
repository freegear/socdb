-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MpmcTrSnp.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Module, transaction Snoop, to "log" commands issued by the
--           controller to the SDRAM/SyncFLASH devices
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MpmcTrSnp is
  port (
-- Inputs
        HCLK             : in    std_logic; -- Input Clock To The Snooper
        MPMCCLK          : in    std_logic; -- Operating clock of the SDRAMC
        nReset           : in    std_logic; -- Input Reset To The Snooper
        FifoIn           : in    std_logic_vector(31 downto 0);
                                            -- Input data to the Snooper
        LatencyChkEn     : in    std_logic; -- RAS/CAS latency check enable
        MPMCDATAOUT      : in    std_logic_vector(31 downto 0);
                                            -- Mpmc Data out signal
        MPMCDATAIN       : in    std_logic_vector(31 downto 0);
                                            -- Mpmc Data in signal
        nMPMCDYCSOUT     : in    std_logic_vector(3 downto 0);
                                            -- Chip Select Signal for
                                            -- Synchronous Memory devices
        nMPMCSTCSOUT     : in    std_logic_vector(3 downto 0);
                                            -- Chip Select Signal for Static
                                            -- Memory devices
        MPMCTrSNPCR      : in    std_logic_vector(3 downto 0);
                                            -- MPMCTrSNPCR register
        Fifo1Rd          : in    std_logic; -- To Read the FIFO1
        Fifo2Rd          : in    std_logic; -- To Read the FIFO2
        MPMCTrDynRC0     : in    std_logic_vector(9 downto 0);
                                            -- RAS/CAS Latency Register0
        MPMCTrDynRC1     : in    std_logic_vector(9 downto 0);
                                            -- RAS/CAS Latency Register1
        MPMCTrDynRC2     : in    std_logic_vector(9 downto 0);
                                            -- RAS/CAS Latency Register2
        MPMCTrDynRC3     : in    std_logic_vector(9 downto 0);
                                            -- RAS/CAS Latency Register3

-- Outputs
        Fifo1Out         : out   std_logic_vector(31 downto 0);
                                            -- Fifo1 Data Output
        Fifo2Out         : out   std_logic_vector(31 downto 0)
                                            -- Fifo2 Data Output
       );
end MpmcTrSnp;

-- -----------------------------------------------------------------------------
--
--                                  MpmcTrSnp
--                                  =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module "snoops" the MPMC bus and stores the command encoding and
-- the access address in a FIFO. This FIFO may be read or cleared under
-- program control.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of MpmcTrSnp is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Range and Width Definitions
-- -----------------------------------------------------------------------------
constant FIFO_DEPTH       : integer := 128;
-- Depth of the FIFOs

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------
type FIFOARRAY is array((FIFO_DEPTH - 1) downto 0)
                       of std_logic_vector(31 downto 0);
-- FIFO array type

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal DelMPMCCLK       : std_logic;
-- Delayed version of the MPMCCLK to sample the read command for CAS latency
-- check

signal Fifo1SelClk      : std_logic;
-- Selected operating clock for the FIFO1

signal Fifo2SelClk      : std_logic;
-- Selected operating clock for the FIFO2

signal SDRAMSel         : std_logic;
-- Signal which indicates whether a SDRAM is selected

signal Fifo1Clear       : std_logic;
-- Snooper fifo clear signal

signal Fifo2Clear       : std_logic;
-- Snooper fifo clear signal

signal Fifo1En          : std_logic;
-- Snooper fifo Enable signal

signal Fifo2En          : std_logic;
-- Snooper fifo Enable signal

signal iFifo1Out        : std_logic_vector(31 downto 0);
-- local copy of FIFO data output

signal iFifo2Out        : std_logic_vector(31 downto 0);
-- local copy of FIFO data output

signal NextFifo1Out     : std_logic_vector(31 downto 0);
-- D-input of iFifo1Out register

signal NextFifo2Out     : std_logic_vector(31 downto 0);
-- D-input of iFifo2Out register

signal Fifo1Data        : FIFOARRAY;
-- Array of Fifo1 datas each 32 bit wide

signal Fifo2Data        : FIFOARRAY;
-- Array of Fifo2 datas each 32 bit wide

signal ShiftFifo1Data   : FIFOARRAY;
-- FIFO1 data

signal ShiftFifo2Data   : FIFOARRAY;
-- FIFO2 data

signal NextFifo1Data    : std_logic_vector(31 downto 0);
-- Input to the ShiftFifo1Data

signal NextFifo2Data    : std_logic_vector(31 downto 0);
-- Input to the ShiftFifo2Data

signal Snoop1En         : std_logic := '0';
-- Signal which decides whether data has to be encoded in the FIFO1

signal Snoop2En         : std_logic := '0';
-- Signal which decides whether data has to be encoded in the FIFO2

signal WritePntr1       : integer := 0;
-- Gives the number of the FIFO word into which the encoded data is written

signal WritePntr2       : integer := 0;
-- Gives the number of the FIFO word into which the encoded data is written

signal NextWritePntr1   : integer := 0;
-- D - input of the WritePntr1

signal NextWritePntr2   : integer := 0;
-- D - input of the WritePntr2

signal ChipSelect       : std_logic_vector(7 downto 0);
-- signal indicates assertion of chip select for both Synchronous and Static
-- Memory module.

signal RASLat1          : std_logic;
-- RAS Latency1 Check enable

signal RASLat2          : std_logic;
-- RAS Latency2 Check enable

signal RASLat3          : std_logic;
-- RAS Latency3 Check enable

signal NxtRASLat1       : std_logic;
-- D-input for RAS Latency1 Check enable

signal NxtRASLat2       : std_logic;
-- D-input for RAS Latency2 Check enable

signal NxtRASLat3       : std_logic;
-- D-input for RAS Latency3 Check enable

signal CASLat1          : std_logic;
-- CAS Latency1 Check enable

signal CASLat2          : std_logic;
-- CAS Latency2 Check enable

signal CASLat3          : std_logic;
-- CAS Latency3 Check enable

signal NxtCASLat1       : std_logic;
-- D-input for CAS Latency1 Check enable

signal NxtCASLat2       : std_logic;
-- D-input for CAS Latency2 Check enable

signal NxtCASLat3       : std_logic;
-- D-input for CAS Latency3 Check enable

signal RDataSmpEn       : std_logic;
-- Enable signal to sample the Read data into the FIFO.

signal LatchCS          : std_logic_vector(1 downto 0) := "00";
-- Latched version of the Synchronous memory CSs for CAS Latency checks

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
-- Generation of Chipselect signal
-- -----------------------------------------------------------------------------
ChipSelect       <= nMPMCDYCSOUT(3 downto 0) & nMPMCSTCSOUT(3 downto 0);

SDRAMSel         <= not(ChipSelect(7) and ChipSelect(6) and ChipSelect(5) and
                        ChipSelect(4));

Fifo1Out         <= NextFifo1Out;
Fifo2Out         <= NextFifo2Out;

DelMPMCCLK       <= MPMCCLK after 2 ns;

-- -----------------------------------------------------------------------------
-- Generation of Internal signals from register bit fields
-- -----------------------------------------------------------------------------
Fifo1En          <= MPMCTrSNPCR(0);
Fifo1Clear       <= MPMCTrSNPCR(1);
Fifo2En          <= MPMCTrSNPCR(2);
Fifo2Clear       <= MPMCTrSNPCR(3);

-- -----------------------------------------------------------------------------
-- Select the operating clock for the FIFOs
-- -----------------------------------------------------------------------------
Fifo1SelClk      <= MPMCCLK when (Fifo1En = '1')
                 else
                    HCLK;

Fifo2SelClk      <= MPMCCLK when (Fifo2En = '1')
                 else
                    HCLK;

-- -----------------------------------------------------------------------------
-- Combinational block which checks for a Snoop Enable condition and does
-- the encoding of the FIFO1 data to a 32 bit register NextFifo1Data.
-- -----------------------------------------------------------------------------
p_EncodeComb : process (FifoIn, Fifo1En, ChipSelect, SDRAMSel)
  variable VarSnoopEn : std_logic;
begin
  NextFifo1Data  <= (others => '0');
  VarSnoopEn    := '0';
-- -----------------------------------------------------------------------------
--  Command Field - 3 bits
-- -----------------------------------------------------------------------------
  if (Fifo1En = '1') then
    if (SDRAMSel = '1' and FifoIn(30) = '0' and FifoIn(29) = '0' and
        FifoIn(28) = '1') then
      NextFifo1Data(31 downto 29)     <= "111";      -- REFRESH/LCR
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '0' and FifoIn(29) = '1' and
        FifoIn(28) = '0' and FifoIn(10) ='0') then
      NextFifo1Data(31 downto 29)     <= "110";      -- PRECHARGE/ACTIVE
      VarSnoopEn                     := '1';         -- TERMINATE
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '1' and FifoIn(29) = '0' and
        FifoIn(28) = '1') then
      NextFifo1Data(31 downto 29)     <= "101";      -- READ
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '1' and FifoIn(29) = '0' and
        FifoIn(28) ='0') then
      NextFifo1Data(31 downto 29)     <= "100";      -- WRITE
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '0' and FifoIn(29) = '1' and
        FifoIn(28) = '1') then
      NextFifo1Data(31 downto 29)     <= "011";      -- ACTIVE
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '1' and FifoIn(29) = '1' and
        FifoIn(28) = '1') then
      NextFifo1Data(31 downto 29)     <= "010";      -- NOP
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '1' and FifoIn(29) = '1' and
        FifoIn(28) = '0') then
      NextFifo1Data(31 downto 29)     <= "001";      -- BURST TERMINATE
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) = '0' and FifoIn(29) = '0' and
        FifoIn(28) ='0') then
      NextFifo1Data(31 downto 29)   <= "000";        -- LOAD MODE REGISTER
      VarSnoopEn                     := '1';
    end if;
-- -----------------------------------------------------------------------------
-- Device Field - 3 bits
-- -----------------------------------------------------------------------------
    if (VarSnoopEn = '1') then
      case ChipSelect is
        when "11111110" =>
          NextFifo1Data(28 downto 26) <= "000";
        when "11111101" =>
          NextFifo1Data(28 downto 26) <= "001";
        when "11111011" =>
          NextFifo1Data(28 downto 26) <= "010";
        when "11110111" =>
          NextFifo1Data(28 downto 26) <= "011";
        when "11101111" =>
          NextFifo1Data(28 downto 26) <= "100";
        when "11011111" =>
          NextFifo1Data(28 downto 26) <= "101";
        when "10111111" =>
          NextFifo1Data(28 downto 26) <= "110";
        when "01111111" =>
          NextFifo1Data(28 downto 26) <= "111";
        when others =>
          NextFifo1Data(28 downto 26) <= "000";
      end case;
-- -----------------------------------------------------------------------------
-- Address Field - 26 bits
-- -----------------------------------------------------------------------------
      NextFifo1Data(25 downto 0)      <= FifoIn(25 downto 0);
    end if;
    Snoop1En <= VarSnoopEn;
  end if;
end process p_EncodeComb;

-- -----------------------------------------------------------------------------
-- Combinational block which checks for a Snoop Enable condition and does
-- the encoding of the FIFO2 data to a 32 bit register NextFifo2Data.
-- -----------------------------------------------------------------------------
p_Fifo2Comb : process (FifoIn, Fifo2En, MPMCDATAOUT, MPMCDATAIN,
                       SDRAMSel, RDataSmpEn)
  variable VarSnoopEn : std_logic;
begin
  NextFifo2Data  <= (others => '0');
  VarSnoopEn    := '0';
  if (Fifo2En = '1') then
    if (RDataSmpEn = '1') then
      NextFifo2Data                   <= MPMCDATAIN;
      VarSnoopEn                     := '1';
    end if;

    if (SDRAMSel = '1' and FifoIn(30) ='1' and FifoIn(29) ='0' and
        FifoIn(28) ='0') then
      NextFifo2Data                   <= MPMCDATAOUT;
      VarSnoopEn                     := '1';
    end if;
    Snoop2En <= VarSnoopEn;
  end if;
end process p_Fifo2Comb;

-- -----------------------------------------------------------------------------
-- Whenever a Fifo Clear or Snoop Enable or Read Enable comes, the required
-- changes will be made to ShiftFifo1Data[i] respectively. The contents of the
-- ShiftFifo1Data[i] will be moved to the Fifo1Data[i] at the positive edge
-- of the HCLK in the sequential block.
-- -----------------------------------------------------------------------------
p_ShiftReg1Comb : process (Fifo1Clear, Snoop1En, Fifo1Rd,
                           NextFifo1Data, WritePntr1,
                           Fifo1Data(0), iFifo1Out)

  variable TempFifoData : std_logic_vector(31 downto 0);
begin
  for i in 0 to (FIFO_DEPTH - 1) loop
    ShiftFifo1Data(i)         <= Fifo1Data(i);
  end loop;

  if (Fifo1Clear = '1') then
    NextWritePntr1            <= 0;
    for i in 0 to (FIFO_DEPTH - 1) loop
      TempFifoData           := Fifo1Data(i);
      TempFifoData(0)        := '0';
      ShiftFifo1Data(i)       <= TempFifoData;
    end loop;
  elsif (Snoop1En = '1') then
-- -----------------------------------------------------------------------------
-- Moving the encoded data to the WritePntr location of ShiftFifoData, when
-- Snoop Enable is set, which will be refreshed to FifoData at posedge of
-- the HCLK.
-- -----------------------------------------------------------------------------
    NextWritePntr1             <= WritePntr1 + 1;
    ShiftFifo1Data(WritePntr1) <= NextFifo1Data;
  elsif (Fifo1Rd ='1') then
-- -----------------------------------------------------------------------------
-- The data in the FIFO register header is transfered to
-- NextFifoOut, when Read Enable is set.This information will later be
-- transfered to FifoOut at the positive edge of the HCLK.
-- -----------------------------------------------------------------------------
    NextFifo1Out              <= Fifo1Data(0);
    NextWritePntr1            <= WritePntr1 - 1;
    for i in 0 to (FIFO_DEPTH - 2) loop
      ShiftFifo1Data(i)       <= Fifo1Data(i + 1);
    end loop;
  else
    NextFifo1Out              <= iFifo1Out;
    NextWritePntr1            <= WritePntr1;
  end if;
end process p_ShiftReg1Comb;

-- -----------------------------------------------------------------------------
-- Whenever a Fifo Clear or Snoop Enable or Read Enable comes, the required
-- changes will be made to ShiftFifo2Data[i] respectively. The contents of the
-- ShiftFifo2Data[i] will be moved to the Fifo2Data[i] at the positive edge
-- of the HCLK in the sequential block.
-- -----------------------------------------------------------------------------
p_ShiftReg2Comb : process (Fifo2Clear, Snoop2En, Fifo2Rd,
                           NextFifo2Data, WritePntr2,
                           Fifo2Data(0), iFifo2Out)

  variable TempFifoData : std_logic_vector(31 downto 0);
begin
  for i in 0 to (FIFO_DEPTH - 1) loop
    ShiftFifo2Data(i)         <= Fifo2Data(i);
  end loop;

  if (Fifo2Clear = '1') then
    NextWritePntr2            <= 0;
    for i in 0 to (FIFO_DEPTH - 1) loop
      TempFifoData           := Fifo2Data(i);
      TempFifoData(0)        := '0';
      ShiftFifo2Data(i)       <= TempFifoData;
    end loop;
  elsif (Snoop2En = '1') then
-- -----------------------------------------------------------------------------
-- Moving the encoded data to the WritePntr location of ShiftFifoData, when
-- Snoop Enable is set, which will be refreshed to FifoData at posedge of
-- the HCLK.
-- -----------------------------------------------------------------------------
    NextWritePntr2             <= WritePntr2 + 1;
    ShiftFifo2Data(WritePntr2) <= NextFifo2Data;
-- -----------------------------------------------------------------------------
-- The data in the FIFO register header is transfered to
-- NextFifoOut, when Read Enable is set.This information will later be
-- transfered to FifoOut at the positive edge of the HCLK.
-- -----------------------------------------------------------------------------
  elsif (Fifo2Rd = '1') then
    NextFifo2Out              <= Fifo2Data(0);
    NextWritePntr2            <= WritePntr2 - 1;
    for i in 0 to (FIFO_DEPTH - 2) loop
      ShiftFifo2Data(i)       <= Fifo2Data(i + 1);
    end loop;
  else
    NextFifo2Out              <= iFifo2Out;
    NextWritePntr2            <= WritePntr2;
  end if;
end process p_ShiftReg2Comb;

-- -----------------------------------------------------------------------------
-- Sequential block in which the data is transfered to FIFO1 registers at
-- the positive edge of the HCLK.
-- -----------------------------------------------------------------------------
p_ShiftReg1Seq : process (Fifo1SelClk, nReset)
begin
  if (nReset = '0') then
    WritePntr1         <= 0;
    iFifo1Out          <= (others => '0');
    for i in 0 to (FIFO_DEPTH - 1) loop
      Fifo1Data(i)     <= (others => '0');
    end loop;
  elsif (Fifo1SelClk'event and Fifo1SelClk = '1') then
    WritePntr1         <= NextWritePntr1;
    iFifo1Out          <= NextFifo1Out;
    for i in 0 to (FIFO_DEPTH - 1) loop
      Fifo1Data(i)     <= ShiftFifo1Data(i);
    end loop;
  end if;
end process p_ShiftReg1Seq;

-- -----------------------------------------------------------------------------
-- Sequential block in which the data is transfered to FIFO2 registers at
-- the positive edge of the HCLK.
-- -----------------------------------------------------------------------------
p_ShiftReg2Seq : process (Fifo2SelClk, nReset)
begin
  if (nReset = '0') then
    WritePntr2         <= 0;
    iFifo2Out          <= (others => '0');
    for i in 0 to (FIFO_DEPTH - 1) loop
      Fifo2Data(i)     <= (others => '0');
    end loop;
  elsif (Fifo2SelClk'event and Fifo2SelClk = '1') then
    WritePntr2         <= NextWritePntr2;
    iFifo2Out          <= NextFifo2Out;
    for i in 0 to (FIFO_DEPTH - 1) loop
      Fifo2Data(i)     <= ShiftFifo2Data(i);
    end loop;
  end if;
end process p_ShiftReg2Seq;

-- -----------------------------------------------------------------------------
-- RAS latency check processes - RAS latency1 check timing signal
-- -----------------------------------------------------------------------------
p_RASLat1Comb : process (NextFifo1Data)
begin
  if (NextFifo1Data(31 downto 29) = "011") then
    NxtRASLat1 <= '1';
  else
    NxtRASLat1 <= '0';
  end if;
end process p_RASLat1Comb;

-- -----------------------------------------------------------------------------
-- RAS latency2 check timing signal
-- -----------------------------------------------------------------------------
p_RASLat2Comb : process (RASLat1)
begin
  if (RASLat1 = '1') then
    NxtRASLat2 <= '1';
  else
    NxtRASLat2 <= '0';
  end if;
end process p_RASLat2Comb;

-- -----------------------------------------------------------------------------
-- RAS latency3 check timing signal
-- -----------------------------------------------------------------------------
p_RASLat3Comb : process (RASLat2)
begin
  if (RASLat2 = '1') then
    NxtRASLat3 <= '1';
  else
    NxtRASLat3 <= '0';
  end if;
end process p_RASLat3Comb;

-- -----------------------------------------------------------------------------
-- Clocking the RAS latency check timing signals
-- -----------------------------------------------------------------------------
p_RASLatSeq : process (nReset, MPMCCLK)
begin
  if (nReset = '0') then
    RASLat1 <= '0';
    RASLat2 <= '0';
    RASLat3 <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    RASLat1 <= NxtRASLat1;
    RASLat2 <= NxtRASLat2;
    RASLat3 <= NxtRASLat3;
  end if;
end process p_RASLatSeq;

-- -----------------------------------------------------------------------------
-- RAS latency protocol check. If the latency check is enabled and the MPMC
-- does not meet the programmed latency, the process flags warning messages.
-- -----------------------------------------------------------------------------
p_RChkSeq : process (MPMCCLK)
begin
  if (MPMCCLK'event and MPMCCLK = '1') then
    if (LatencyChkEn = '1') then
      if (ChipSelect(4) = '0') then
        if (MPMCTrDynRC0(1 downto 0) = "01") then
          assert NOT (RASLat1 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency1 violation for Dynamic memory bank 0"
            severity warning;
        elsif (MPMCTrDynRC0(1 downto 0) = "10") then
          assert NOT (RASLat2 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency2 violation for Dynamic memory bank 0"
            severity warning;
        elsif (MPMCTrDynRC0(1 downto 0) = "11") then
          assert NOT (RASLat3 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency3 violation for Dynamic memory bank 0"
            severity warning;
        end if;
      elsif (ChipSelect(5) = '0') then
        if (MPMCTrDynRC1(1 downto 0) = "01") then
          assert NOT (RASLat1 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency1 violation for Dynamic memory bank 1"
            severity warning;
        elsif (MPMCTrDynRC1(1 downto 0) = "10") then
          assert NOT (RASLat2 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency2 violation for Dynamic memory bank 1"
            severity warning;
        elsif (MPMCTrDynRC1(1 downto 0) = "11") then
          assert NOT (RASLat3 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency3 violation for Dynamic memory bank 1"
            severity warning;
        end if;
      elsif (ChipSelect(6) = '0') then
        if (MPMCTrDynRC2(1 downto 0) = "01") then
          assert NOT (RASLat1 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency1 violation for Dynamic memory bank 2"
            severity warning;
        elsif (MPMCTrDynRC2(1 downto 0) = "10") then
          assert NOT (RASLat2 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency2 violation for Dynamic memory bank 2"
            severity warning;
        elsif (MPMCTrDynRC2(1 downto 0) = "11") then
          assert NOT (RASLat3 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency3 violation for Dynamic memory bank 2"
            severity warning;
        end if;
      elsif (ChipSelect(7) = '0') then
        if (MPMCTrDynRC3(1 downto 0) = "01") then
          assert NOT (RASLat1 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency1 violation for Dynamic memory bank 3"
            severity warning;
        elsif (MPMCTrDynRC3(1 downto 0) = "10") then
          assert NOT (RASLat2 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency2 violation for Dynamic memory bank 3"
            severity warning;
        elsif (MPMCTrDynRC3(1 downto 0) = "11") then
          assert NOT (RASLat3 = '1' and NextFifo1Data(31 downto 30) /= "10")
            report "RAS Latency3 violation for Dynamic memory bank 3"
            severity warning;
        end if;
      end if;
    end if;
  end if;
end process p_RChkSeq;

-- -----------------------------------------------------------------------------
-- CAS latency check processes - CAS latency1 check timing signal
-- -----------------------------------------------------------------------------
p_CASLat1Comb : process (NextFifo1Data)
begin
  if (NextFifo1Data(31 downto 29) = "101") then
    NxtCASLat1 <= '1';
    if (ChipSelect(4) = '0') then
      LatchCS <= "00";
    elsif (ChipSelect(5) = '0') then
      LatchCS <= "01";
    elsif (ChipSelect(6) = '0') then
      LatchCS <= "10";
    elsif (ChipSelect(7) = '0') then
      LatchCS <= "11";
    end if;
  else
    NxtCASLat1 <= '0';
  end if;
end process p_CASLat1Comb;

-- -----------------------------------------------------------------------------
-- CAS latency2 check timing signal
-- -----------------------------------------------------------------------------
p_CASLat2Comb : process (CASLat1)
begin
  if (CASLat1 = '1') then
    NxtCASLat2 <= '1';
  else
    NxtCASLat2 <= '0';
  end if;
end process p_CASLat2Comb;

-- -----------------------------------------------------------------------------
-- CAS latency3 check timing signal
-- -----------------------------------------------------------------------------
p_CASLat3Comb : process (CASLat2)
begin
  if (CASLat2 = '1') then
    NxtCASLat3 <= '1';
  else
    NxtCASLat3 <= '0';
  end if;
end process p_CASLat3Comb;

-- -----------------------------------------------------------------------------
-- Clocking the CAS latency check timing signals
-- -----------------------------------------------------------------------------
p_CASLatSeq : process (nReset, DelMPMCCLK)
begin
  if (nReset = '0') then
    CASLat1 <= '0';
    CASLat2 <= '0';
    CASLat3 <= '0';
  elsif (DelMPMCCLK'event and DelMPMCCLK = '1') then
    CASLat1 <= NxtCASLat1;
    CASLat2 <= NxtCASLat2;
    CASLat3 <= NxtCASLat3;
  end if;
end process p_CASLatSeq;

-- -----------------------------------------------------------------------------
-- Generating Read Data sample enable signal to snoop the read data int o the
-- FIFO. By reading the data from the FIFO validates the integrity of the
-- read data.
-- -----------------------------------------------------------------------------
p_SnpRDataComb : process (LatencyChkEn, LatchCS, MPMCTrDynRC0,
                          MPMCTrDynRC1, MPMCTrDynRC2, MPMCTrDynRC3,
                          CASLat1, CASLat2, CASLat3)
begin
  if (LatencyChkEn = '1') then
    if ((LatchCS = "00" and MPMCTrDynRC0(9 downto 8) = "01") or
        (LatchCS = "01" and MPMCTrDynRC1(9 downto 8) = "01") or
        (LatchCS = "10" and MPMCTrDynRC2(9 downto 8) = "01") or
        (LatchCS = "11" and MPMCTrDynRC3(9 downto 8) = "01")) then
      RDataSmpEn <= CASLat1;
    elsif ((LatchCS = "00" and MPMCTrDynRC0(9 downto 8) = "10") or
           (LatchCS = "01" and MPMCTrDynRC1(9 downto 8) = "10") or
           (LatchCS = "10" and MPMCTrDynRC2(9 downto 8) = "10") or
           (LatchCS = "11" and MPMCTrDynRC3(9 downto 8) = "10")) then
      RDataSmpEn <= CASLat2;
    elsif ((LatchCS = "00" and MPMCTrDynRC0(9 downto 8) = "11") or
           (LatchCS = "01" and MPMCTrDynRC1(9 downto 8) = "11") or
           (LatchCS = "10" and MPMCTrDynRC2(9 downto 8) = "11") or
           (LatchCS = "11" and MPMCTrDynRC3(9 downto 8) = "11")) then
      RDataSmpEn <= CASLat3;
    else
      RDataSmpEn <= '0';
    end if;
  else
    RDataSmpEn <= '0';
  end if;
end process p_SnpRDataComb;

end behavioural;

-- --================================== End ==================================--
