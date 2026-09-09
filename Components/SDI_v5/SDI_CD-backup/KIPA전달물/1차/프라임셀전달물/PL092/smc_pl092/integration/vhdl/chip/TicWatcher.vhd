-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : TicWatcher.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Protocol checker for the TIC
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity TicWatcher is
  port (
-- Inputs
        -- Test bus signals
        TCLK             : in    std_logic; -- Test mode clock
        RESETn           : in    std_logic; -- Bus Reset
        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B
        TESTACK          : in    std_logic; -- Test Acknowledge
        TESTBUS          : in    std_logic_vector(31 downto 0);
                                            -- Test data bus
        -- AHB Master signals
        HADDRTIC         : in    std_logic_vector(31 downto 0);
                                            -- AHB System address bus
        HWRITETIC        : in    std_logic; -- Data transfer direction signal
        HTRANSTIC        : in    std_logic_vector(1 downto 0);
                                            -- AHB Transfer type
        HSIZETIC         : in    std_logic_vector(2 downto 0);
                                            -- AHB Data transfer type
        HBURSTTIC        : in    std_logic_vector(2 downto 0);
                                            -- AHB Burst type
        HPROTTIC         : in    std_logic_vector(3 downto 0);
                                            -- Protection control signal
        HWDATATIC        : in    std_logic_vector(31 downto 0)
                                            -- AHB Write data bus
       );
end TicWatcher;

-- -----------------------------------------------------------------------------
--
--                                 TicWatcher
--                                 ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   TicWatcher module watches the TIC Bus and flags warning messages for
-- protocol violations on the Bus.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of TicWatcher is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- TIC States
-- -----------------------------------------------------------------------------
constant ST_IDLE          : std_logic_vector(2 downto 0) := "000";
-- TIC remains IDLE (Normal mode operation of the System

constant ST_ENTER         : std_logic_vector(2 downto 0) := "001";
-- Entering TEST mode

constant ST_START         : std_logic_vector(2 downto 0) := "010";
-- Start of TEST by the TIC

constant ST_ADDR          : std_logic_vector(2 downto 0) := "011";
-- Address or Control state

constant ST_READ          : std_logic_vector(2 downto 0) := "100";
-- Read state

constant ST_LASTREAD      : std_logic_vector(2 downto 0) := "101";
-- Read state

constant ST_WRITE         : std_logic_vector(2 downto 0) := "110";
-- Write state

constant ST_TAROUND       : std_logic_vector(2 downto 0) := "111";
-- Turnaround state

-- -----------------------------------------------------------------------------
-- Vector Types
-- -----------------------------------------------------------------------------
constant ADDRVEC          : std_logic_vector(1 downto 0) := "11";
-- Address Vector

constant READVEC          : std_logic_vector(1 downto 0) := "01";
-- Read Vector

constant WRITEVEC         : std_logic_vector(1 downto 0) := "10";
-- Write Vector

constant EXITVEC          : std_logic_vector(1 downto 0) := "00";
-- Exit Test mode

constant DEFAULT_CNTLREG  : std_logic_vector(10 downto 1) := "0000110100";
-- Default value in the Control Register
--   HSIZE = WORD ("10")
--   HPROT = Privileged data access, uncacheable and unbufferable ("0011")
--   Address Increment = Disabled
--   HLOCK = '0'

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal CurrState        : std_logic_vector(2 downto 0);
-- Current state

signal PrevState        : std_logic_vector(2 downto 0);
-- Previous state

signal NxtState         : std_logic_vector(2 downto 0);
-- D- inputs to the state (CurrState) flip-flops

signal SyncTESTREQA     : std_logic;
-- Synchronised Test bus Request A

signal iTESTREQ         : std_logic_vector(1 downto 0);
-- Test Request Type

signal iHADDR           : std_logic_vector(31 downto 0);
-- Internal HADDR

signal NxtHADDR         : std_logic_vector(31 downto 0);
-- D- input for the iHADDR

signal iHWDATA          : std_logic_vector(31 downto 0);
-- Internal HWDATA

signal NxtHWDATA        : std_logic_vector(31 downto 0);
-- D- input for the iHWDATA

signal iHTRANS          : std_logic_vector(1 downto 0);
-- Internal HTRANS

signal iHBURST          : std_logic_vector(2 downto 0);
-- Internal HBURST

signal iHPROT           : std_logic_vector(3 downto 0);
-- Internal HPROT

signal iHSIZE           : std_logic_vector(2 downto 0);
-- Internal HSIZE

signal iHLOCK           : std_logic;
-- Internal HWRITE

signal iHWRITE          : std_logic;
-- Internal HWRITE

signal ControlReg       : std_logic_vector(10 downto 1);
-- TIC Control Register

signal NxtControlReg    : std_logic_vector(10 downto 1);
-- D- input for the ControlReg

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

iTESTREQ         <= TESTREQA & TESTREQB;

-- -----------------------------------------------------------------------------
-- Synchronise TESTREQA signal
-- -----------------------------------------------------------------------------
p_SyncTREQASeq : process (TCLK, RESETn)
begin
  if (RESETn = '0') then
    SyncTESTREQA <= '0';
  elsif (TCLK'event and TCLK = '1') then
    SyncTESTREQA <= TESTREQA;
  end if;
end process p_SyncTREQASeq;

-- -----------------------------------------------------------------------------
-- Sequential logic to update the state vector of the TIC
-- -----------------------------------------------------------------------------
p_UpdateStSeq : process (TCLK, RESETn)
begin
  if (RESETn = '0') then
    PrevState <= ST_IDLE;
    CurrState <= ST_IDLE;
  elsif (TCLK'event and TCLK = '1') then
    if (TESTACK = '1') then
      PrevState <= CurrState;
    end if;
    CurrState <= NxtState;
  end if;
end process p_UpdateStSeq;

-- -----------------------------------------------------------------------------
-- Combinatorial logic to update the state vector of the TIC
-- -----------------------------------------------------------------------------
p_StMachineComb : process (CurrState, SyncTESTREQA, TESTACK, iTESTREQ)
begin
  case CurrState is
    when ST_IDLE =>
      if (SyncTESTREQA = '1') then
        NxtState <= ST_ENTER;
      else
        NxtState <= ST_IDLE;
      end if;

    when ST_ENTER =>
      if (TESTACK = '1') then
        NxtState <= ST_START;
      elsif (SyncTESTREQA = '0') then
        NxtState <= ST_IDLE;
      else
        NxtState <= ST_ENTER;
      end if;

    when ST_START =>
      if (TESTACK = '0') then
        NxtState <= ST_START;
      elsif (iTESTREQ = ADDRVEC) then
        NxtState <= ST_ADDR;
      else
        NxtState <= ST_START;
      end if;

    when ST_ADDR =>
      if (TESTACK = '0') then
        NxtState <= ST_ADDR;
      elsif (iTESTREQ = READVEC) then
        NxtState <= ST_READ;
      elsif (iTESTREQ = WRITEVEC) then
        NxtState <= ST_WRITE;
      elsif (iTESTREQ = EXITVEC) then
        NxtState <= ST_IDLE;
      else
        NxtState <= ST_ADDR;
      end if;

    when ST_READ =>
      if (TESTACK = '0') then
        NxtState <= ST_READ;
      elsif (iTESTREQ = READVEC) then
        NxtState <= ST_READ;
      else
        NxtState <= ST_LASTREAD;
      end if;

    when ST_LASTREAD =>
      if (TESTACK = '0') then
        NxtState <= ST_LASTREAD;
      else
        NxtState <= ST_TAROUND;
      end if;

    when ST_WRITE =>
      if (TESTACK = '0') then
        NxtState <= ST_WRITE;
      elsif ((iTESTREQ = ADDRVEC) or (iTESTREQ = EXITVEC)) then
        NxtState <= ST_ADDR;
      elsif (iTESTREQ = READVEC) then
        NxtState <= ST_READ;
      else
        NxtState <= ST_WRITE;
      end if;

    when ST_TAROUND =>
      if (TESTACK = '0') then
        NxtState <= ST_TAROUND;
      elsif (iTESTREQ = READVEC) then
        NxtState <= ST_READ;
      elsif (iTESTREQ = WRITEVEC) then
        NxtState <= ST_WRITE;
      else
        NxtState <= ST_ADDR;
      end if;
    when others =>
      NxtState <= ST_IDLE;
  end case;
end process p_StMachineComb;

-- -----------------------------------------------------------------------------
-- Control Register updation logic
-- -----------------------------------------------------------------------------
NxtControlReg    <= TESTBUS(10 downto 1) when (PrevState = ST_ADDR and
                      CurrState = ST_ADDR and NxtState /= ST_ADDR and
                      TESTBUS(0) = '1')
                 else
                    ControlReg;

-- -----------------------------------------------------------------------------
-- Sequential process to update Control Register
-- -----------------------------------------------------------------------------
p_ControlSeq : process (TCLK, RESETn)
begin
  if (RESETn = '0') then
    ControlReg <= DEFAULT_CNTLREG;
  elsif (TCLK'event and TCLK = '1') then
    ControlReg <= NxtControlReg;
  end if;
end process p_ControlSeq;

-- -----------------------------------------------------------------------------
-- Internal AHB signal generation
-- -----------------------------------------------------------------------------
NxtHADDR         <= TESTBUS when (CurrState = ST_ADDR)
                 else
                    iHADDR;

NxtHWDATA        <= TESTBUS when (CurrState = ST_WRITE and TESTACK = '1')
                 else
                    iHWDATA;

iHWRITE          <= '1' when (CurrState = ST_WRITE)
                 else
                    '0';

iHTRANS          <= "10" when (CurrState = ST_WRITE or CurrState = ST_READ)
                 else
                    "00";

iHLOCK           <= ControlReg(4);
iHBURST          <= "001";
iHSIZE           <= '0' & ControlReg(3 downto 2);
iHPROT           <= ControlReg(10 downto 9) & ControlReg(6 downto 5);

-- -----------------------------------------------------------------------------
-- Internal AHB signal generation (HADDR and HWDATA)
-- -----------------------------------------------------------------------------
p_AHBSigSeq : process (TCLK, RESETn)
begin
  if (RESETn = '0') then
    iHADDR  <= (others => '0');
    iHWDATA <= (others => '0');
  elsif (TCLK'event and TCLK = '1') then
    iHADDR  <= NxtHADDR;
    iHWDATA <= NxtHWDATA;
  end if;
end process p_AHBSigSeq;

-- -----------------------------------------------------------------------------
-- Protocol Checkings
-- -----------------------------------------------------------------------------
p_SignalChkComb : process (TCLK)
begin
  if (TCLK'event and TCLK = '1') then
    if (PrevState = ST_ADDR) then
      assert (HADDRTIC = iHADDR)
        report "TICWATCH1 : Error in HADDR signal from the TIC"
        severity warning;

      assert (HWRITETIC = iHWRITE)
        report "TICWATCH2 : Error in HWRITE signal from the TIC"
        severity warning;

      assert (HSIZETIC = iHSIZE)
        report "TICWATCH3 : Error in HSIZE signal from the TIC"
        severity warning;

      assert (HBURSTTIC = iHBURST)
        report "TICWATCH4 : Error in HBURST signal from the TIC"
        severity warning;

      assert (HPROTTIC = iHPROT)
        report "TICWATCH5 : Error in HPROT signal from the TIC"
        severity warning;

      assert (HTRANSTIC = iHTRANS)
        report "TICWATCH6 : Error in HTRANS signal from the TIC"
        severity warning;
    elsif (PrevState = ST_WRITE) then
      assert (HWDATATIC = iHWDATA)
        report "TICWATCH7 : Error in HWDATA signal from the TIC"
        severity warning;
    end if;
  end if;
end process p_SignalChkComb;

end behavioural;

-- --================================== End ==================================--
