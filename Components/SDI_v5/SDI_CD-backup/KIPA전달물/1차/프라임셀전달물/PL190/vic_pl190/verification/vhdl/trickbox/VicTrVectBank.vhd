-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicTrVectBank.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module implements the Mirrored VIC functionality.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity VicTrVectBank is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        VICTrFIQStatus   : in    std_logic_vector(31 downto 0);
                                            -- FIQ status signal from
                                            -- VicTrIntReq sub-block
        VICTrIRQStatus   : in    std_logic_vector(31 downto 0);
                                            -- IRQ status signal from
                                            -- VicTrIntReq sub-block
        VICTrIRQStatSync : in    std_logic_vector(31 downto 0);
                                            -- Double synchronised IRQStatus
        nVICTrFIQIn      : in    std_logic; -- nFIQIn Daisy chain signal
                                            -- from VicTrAhbif sub-block
        nVICTrIRQIn      : in    std_logic; -- nIRQIn Daisy chain signal
                                            -- from VicTrAhbif sub-block
        SetCSRBit        : in    std_logic; -- Control signal to set the
                                            -- active bit in the CSR
        ClearCSRBit      : in    std_logic; -- Control signal to clear
                                            -- the active bit in the CSR
        VICTrVectAddrIn  : in    std_logic_vector(31 downto 0);
                                            -- VectAddrIn Daisy chain
                                            -- signal from VicTrAhbif
                                            -- sub-block
        VICTrDefVectAddr : in    std_logic_vector(31 downto 0);
                                            -- Default vector Address
        VICTrVectAddr0   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank0
        VICTrVectAddr1   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank1
        VICTrVectAddr2   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank2
        VICTrVectAddr3   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank3
        VICTrVectAddr4   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank4
        VICTrVectAddr5   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank5
        VICTrVectAddr6   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank6
        VICTrVectAddr7   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank7
        VICTrVectAddr8   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank8
        VICTrVectAddr9   : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank9
        VICTrVectAddr10  : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank10
        VICTrVectAddr11  : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank11
        VICTrVectAddr12  : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank12
        VICTrVectAddr13  : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank13
        VICTrVectAddr14  : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank14
        VICTrVectAddr15  : in    std_logic_vector(31 downto 0);
                                            -- VectorAddr of Vector
                                            -- Bank15
        VICTrVectCntl0   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank0
        VICTrVectCntl1   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank1
        VICTrVectCntl2   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank2
        VICTrVectCntl3   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank3
        VICTrVectCntl4   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank4
        VICTrVectCntl5   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank5
        VICTrVectCntl6   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank6
        VICTrVectCntl7   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank7
        VICTrVectCntl8   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank8
        VICTrVectCntl9   : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank9
        VICTrVectCntl10  : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank10
        VICTrVectCntl11  : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank11
        VICTrVectCntl12  : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank12
        VICTrVectCntl13  : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank13
        VICTrVectCntl14  : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank14
        VICTrVectCntl15  : in    std_logic_vector(5 downto 0);
                                            -- VectorCntl of Vector
                                            -- Bank15
-- Outputs
        nFIQ             : out   std_logic; -- nFIQ output of the
                                            -- Mirrored VIC
        nIRQ             : out   std_logic; -- nIRQ output of the
                                            -- Mirrored VIC
        VICTrVectAddrOut : out   std_logic_vector(31 downto 0)
                                            -- VectAddr output of the
                                            -- Mirrored VIC
       );
end VicTrVectBank;

-- ---------------------------------------------------------------------
--
--                            VicTrVectBank
--                            =============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block generates the outputs of the Mirrored VIC model.
-- The Priority resolution logic and the VectAddrOut decoding logic
-- are implemented in this module.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE =========================--

architecture behavioural of VicTrVectBank is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal NonVectIRQ       : std_logic;
-- Non vectored IRQ before masking by priority logic

signal ActiveNonVectIRQ : std_logic;
-- Non vectored IRQ after masking by priority logic

signal NxtActNonVectIRQ : std_logic;
-- Non vectored IRQ after masking by priority logic

signal ActiveExtIRQ     : std_logic;
-- External IRQ after masking by priority logic

signal MaskExtIRQ       : std_logic;
-- Mask signal for External IRQ

signal MaskNonVectIRQ   : std_logic;
-- Mask signal for Non vectored IRQ

signal RawVectIRQ       : std_logic_vector(15 downto 0);
-- Status of Vectored IRQ after source decoding

signal ActiveVectIRQ    : std_logic_vector(15 downto 0);
-- Status register to indicate the IRQ currently being serviced

signal CurrentSerReg    : std_logic_vector(16 downto 0);
-- Register to track nested Vectored Interrupts

signal NxtCurrentSerReg : std_logic_vector(16 downto 0);
-- D-input of CurrentSerReg

signal VectIRQ          : std_logic_vector(15 downto 0);
-- Status register to indicate the currently active vectored IRQ

signal NxtVectIRQ       : std_logic_vector(15 downto 0);
-- D-input for VectIRQ

signal MaskVectIRQ      : std_logic_vector(15 downto 0);
-- Mask signal for vectored IRQ

signal ClearNonVectIRQ  : std_logic;
-- Status signal to indicate the Non Vectored IRQ currently being
-- serviced

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- SelectSource
-- ------------
--   This function decodes the Source part of the VectCntl. If the
-- interrupt source corresponding to the VectCntl Source slice is
-- active, the function returns HIGH, otherwise LOW.
-- ---------------------------------------------------------------------
function SelectSource (
         signal IntSource        : in std_logic_vector(31 downto 0);
                                   -- IRQ Status
         signal VectCntl         : in std_logic_vector(5 downto 0)
                                   -- Vector Control Register
                      ) return std_logic is
variable RawVectIRQ       : std_logic;
-- Source decoded vectored IRQ

begin
  case VectCntl(4 downto 0) is
    when "00000" =>
      RawVectIRQ := IntSource(0) and VectCntl(5);
    when "00001" =>
      RawVectIRQ := IntSource(1) and VectCntl(5);
    when "00010" =>
      RawVectIRQ := IntSource(2) and VectCntl(5);
    when "00011" =>
      RawVectIRQ := IntSource(3) and VectCntl(5);
    when "00100" =>
      RawVectIRQ := IntSource(4) and VectCntl(5);
    when "00101" =>
      RawVectIRQ := IntSource(5) and VectCntl(5);
    when "00110" =>
      RawVectIRQ := IntSource(6) and VectCntl(5);
    when "00111" =>
      RawVectIRQ := IntSource(7) and VectCntl(5);
    when "01000" =>
      RawVectIRQ := IntSource(8) and VectCntl(5);
    when "01001" =>
      RawVectIRQ := IntSource(9) and VectCntl(5);
    when "01010" =>
      RawVectIRQ := IntSource(10) and VectCntl(5);
    when "01011" =>
      RawVectIRQ := IntSource(11) and VectCntl(5);
    when "01100" =>
      RawVectIRQ := IntSource(12) and VectCntl(5);
    when "01101" =>
      RawVectIRQ := IntSource(13) and VectCntl(5);
    when "01110" =>
      RawVectIRQ := IntSource(14) and VectCntl(5);
    when "01111" =>
      RawVectIRQ := IntSource(15) and VectCntl(5);
    when "10000" =>
      RawVectIRQ := IntSource(16) and VectCntl(5);
    when "10001" =>
      RawVectIRQ := IntSource(17) and VectCntl(5);
    when "10010" =>
      RawVectIRQ := IntSource(18) and VectCntl(5);
    when "10011" =>
      RawVectIRQ := IntSource(19) and VectCntl(5);
    when "10100" =>
      RawVectIRQ := IntSource(20) and VectCntl(5);
    when "10101" =>
      RawVectIRQ := IntSource(21) and VectCntl(5);
    when "10110" =>
      RawVectIRQ := IntSource(22) and VectCntl(5);
    when "10111" =>
      RawVectIRQ := IntSource(23) and VectCntl(5);
    when "11000" =>
      RawVectIRQ := IntSource(24) and VectCntl(5);
    when "11001" =>
      RawVectIRQ := IntSource(25) and VectCntl(5);
    when "11010" =>
      RawVectIRQ := IntSource(26) and VectCntl(5);
    when "11011" =>
      RawVectIRQ := IntSource(27) and VectCntl(5);
    when "11100" =>
      RawVectIRQ := IntSource(28) and VectCntl(5);
    when "11101" =>
      RawVectIRQ := IntSource(29) and VectCntl(5);
    when "11110" =>
      RawVectIRQ := IntSource(30) and VectCntl(5);
    when "11111" =>
      RawVectIRQ := IntSource(31) and VectCntl(5);
    when others =>
      RawVectIRQ := '0';
  end case;
  return RawVectIRQ;
end SelectSource;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- nFIQ generation
-- ---------------------------------------------------------------------
p_FIQComb : process (nVICTrFIQIn, VICTrFIQStatus)
variable TempFIQ          : std_logic := '0';

begin
  TempFIQ := not (nVICTrFIQIn);
  for i in 31 downto 0 loop
    TempFIQ := TempFIQ or VICTrFIQStatus(i);
  end loop;
  nFIQ <= not (TempFIQ);
end process p_FIQComb;

-- ---------------------------------------------------------------------
-- Non vectored IRQ generation
-- ---------------------------------------------------------------------
p_IRQComb : process (VICTrIRQStatus)
variable TempIRQ          : std_logic;

begin
  TempIRQ := '0';
  for i in 0 to 31 loop
    TempIRQ := TempIRQ or VICTrIRQStatus(i);
  end loop;
  NonVectIRQ <= TempIRQ;
end process p_IRQComb;

-- ---------------------------------------------------------------------
-- Vectored IRQ Mask generation
-- ---------------------------------------------------------------------
p_MaskVectIRQComb : process (MaskVectIRQ, NxtVectIRQ, CurrentSerReg)
begin
  MaskVectIRQ(0) <= CurrentSerReg(0);
  for i in 1 to 15 loop
    if ((MaskVectIRQ(i-1) = '1') or (NxtVectIRQ(i-1) = '1') or
        (CurrentSerReg(i) = '1')) then
      MaskVectIRQ(i) <= '1';
    else
      MaskVectIRQ(i) <= '0';
    end if;
  end loop;
end process p_MaskVectIRQComb;

-- ---------------------------------------------------------------------
-- External IRQ Mask generation
-- ---------------------------------------------------------------------
p_MaskExtIRQComb : process (MaskNonVectIRQ, NxtActNonVectIRQ)
begin
  if ((MaskNonVectIRQ = '1') or (NxtActNonVectIRQ = '1')) then
    MaskExtIRQ <= '1';
  else
    MaskExtIRQ <= '0';
  end if;
end process p_MaskExtIRQComb;

-- ---------------------------------------------------------------------
-- External IRQ Masking
-- ---------------------------------------------------------------------
p_ExtIRQComb : process (MaskExtIRQ, nVICTrIRQIn)
begin
  if (MaskExtIRQ = '1' ) then
    ActiveExtIRQ <= '0';
  else
    ActiveExtIRQ <= not (nVICTrIRQIn);
  end if;
end process p_ExtIRQComb;

-- ---------------------------------------------------------------------
-- Non vectored IRQ Mask generation
-- ---------------------------------------------------------------------
p_MskNonVecIRQComb : process (MaskVectIRQ(15), NxtVectIRQ(15),
                              CurrentSerReg(16))
begin
  if ((MaskVectIRQ(15) = '1') or (NxtVectIRQ(15) = '1') or
      (CurrentSerReg(16) = '1')) then
    MaskNonVectIRQ <= '1';
  else
    MaskNonVectIRQ <= '0';
  end if;
end process p_MskNonVecIRQComb;

-- ---------------------------------------------------------------------
-- Non vectored IRQ Masking
-- ---------------------------------------------------------------------
p_NonVectIRQComb : process (MaskNonVectIRQ, NonVectIRQ)
begin
  if (MaskNonVectIRQ = '1') then
    NxtActNonVectIRQ <= '0';
  else
    NxtActNonVectIRQ <= NonVectIRQ;
  end if;
end process p_NonVectIRQComb;

-- ---------------------------------------------------------------------
-- Vector Bank RawInterrupt generation
-- ---------------------------------------------------------------------
RawVectIRQ(0)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl0);
RawVectIRQ(1)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl1);
RawVectIRQ(2)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl2);
RawVectIRQ(3)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl3);
RawVectIRQ(4)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl4);
RawVectIRQ(5)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl5);
RawVectIRQ(6)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl6);
RawVectIRQ(7)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl7);
RawVectIRQ(8)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl8);
RawVectIRQ(9)    <= SelectSource(VICTrIRQStatSync, VICTrVectCntl9);
RawVectIRQ(10)   <= SelectSource(VICTrIRQStatSync, VICTrVectCntl10);
RawVectIRQ(11)   <= SelectSource(VICTrIRQStatSync, VICTrVectCntl11);
RawVectIRQ(12)   <= SelectSource(VICTrIRQStatSync, VICTrVectCntl12);
RawVectIRQ(13)   <= SelectSource(VICTrIRQStatSync, VICTrVectCntl13);
RawVectIRQ(14)   <= SelectSource(VICTrIRQStatSync, VICTrVectCntl14);
RawVectIRQ(15)   <= SelectSource(VICTrIRQStatSync, VICTrVectCntl15);

-- ---------------------------------------------------------------------
-- Vectored IRQ Masking
-- ---------------------------------------------------------------------
p_VectIRQComb : process (MaskVectIRQ, RawVectIRQ)
begin
  for i in 0 to 15 loop
    if (MaskVectIRQ(i) = '1') then
      NxtVectIRQ(i) <= '0';
    else
      NxtVectIRQ(i) <= RawVectIRQ(i);
    end if;
  end loop;
end process p_VectIRQComb;

-- ---------------------------------------------------------------------
-- Generation of the signal which indicates the bit to be cleared
-- next in the Current Service Register
-- ---------------------------------------------------------------------
p_ActVecIRQComb : process (MaskVectIRQ, MaskNonVectIRQ)
variable TempActVectIRQ   : std_logic_vector(15 downto 0);

begin
  TempActVectIRQ(0) := MaskVectIRQ(0);
  for i in 1 to 15 loop
    TempActVectIRQ(i) := MaskVectIRQ(i-1) xor MaskVectIRQ(i);
  end loop;
  ActiveVectIRQ   <= TempActVectIRQ;
  ClearNonVectIRQ <= MaskVectIRQ(15) xor MaskNonVectIRQ;
end process p_ActVecIRQComb;

-- ---------------------------------------------------------------------
-- nIRQ generation
-- ---------------------------------------------------------------------
p_nIRQComb : process (NxtVectIRQ, ActiveExtIRQ, NxtActNonVectIRQ)
variable TempIRQ : std_logic := '0';

begin
  TempIRQ := ActiveExtIRQ or NxtActNonVectIRQ;
  for i in 0 to 15 loop
    TempIRQ := TempIRQ or NxtVectIRQ(i);
  end loop;
  nIRQ <= not (TempIRQ);
end process p_nIRQComb;

-- ---------------------------------------------------------------------
-- Combinational logic for the Current Service Register
-- ---------------------------------------------------------------------
p_CSRComb : process (SetCSRBit, ClearCSRBit, VectIRQ, ActiveNonVectIRQ,
                     ClearNonVectIRQ, CurrentSerReg, ActiveVectIRQ)
begin
  if (SetCSRBit = '1') then
    for i in 0 to 15 loop
      if (VectIRQ(i) = '1') then
        NxtCurrentSerReg(i) <= '1';
      else
        NxtCurrentSerReg(i) <= CurrentSerReg(i);
      end if;
    end loop;
    if (ActiveNonVectIRQ = '1') then
      NxtCurrentSerReg(16) <= '1';
    else
      NxtCurrentSerReg(16) <= CurrentSerReg(16);
    end if;
  elsif (ClearCSRBit = '1') then
    for i in 0 to 15 loop
      if (ActiveVectIRQ(i) = '1') then
        NxtCurrentSerReg(i) <= '0';
      else
        NxtCurrentSerReg(i) <= CurrentSerReg(i);
      end if;
    end loop;
    if (ClearNonVectIRQ = '1') then
      NxtCurrentSerReg(16) <= '0';
    else
      NxtCurrentSerReg(16) <= CurrentSerReg(16);
    end if;
  else
    NxtCurrentSerReg <= CurrentSerReg;
  end if;
end process p_CSRComb;

-- ---------------------------------------------------------------------
-- Sequential logic for the Current Service Register
-- ---------------------------------------------------------------------
p_CSRSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    CurrentSerReg    <= (others => '0');
    VectIRQ          <= (others => '0');
    ActiveNonVectIRQ <= '0';
  elsif (HCLK'event and HCLK = '1') then
    CurrentSerReg    <= NxtCurrentSerReg;
    VectIRQ          <= NxtVectIRQ;
    ActiveNonVectIRQ <= NxtActNonVectIRQ;
  end if;
end process p_CSRSeq;

-- ---------------------------------------------------------------------
-- Vector Address select
-- ---------------------------------------------------------------------
p_VICTrVectAddrSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    VICTrVectAddrOut <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (NxtVectIRQ(0) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr0;
    elsif (NxtVectIRQ(1) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr1;
    elsif (NxtVectIRQ(2) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr2;
    elsif (NxtVectIRQ(3) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr3;
    elsif (NxtVectIRQ(4) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr4;
    elsif (NxtVectIRQ(5) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr5;
    elsif (NxtVectIRQ(6) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr6;
    elsif (NxtVectIRQ(7) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr7;
    elsif (NxtVectIRQ(8) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr8;
    elsif (NxtVectIRQ(9) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr9;
    elsif (NxtVectIRQ(10) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr10;
    elsif (NxtVectIRQ(11) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr11;
    elsif (NxtVectIRQ(12) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr12;
    elsif (NxtVectIRQ(13) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr13;
    elsif (NxtVectIRQ(14) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr14;
    elsif (NxtVectIRQ(15) = '1') then
      VICTrVectAddrOut <= VICTrVectAddr15;
    elsif (NxtActNonVectIRQ = '1') then
      VICTrVectAddrOut <= VICTrDefVectAddr;
    elsif (ActiveExtIRQ = '1') then
      VICTrVectAddrOut <= VICTrVectAddrIn;
    else
      VICTrVectAddrOut <= VICTrDefVectAddr;
    end if;
  end if;
end process p_VICTrVectAddrSeq;

end behavioural;

-- --============================== End ==============================--
