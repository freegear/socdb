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
-- File Name              : AaciTrProtChk.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This module checks the AACISYNC and the AACIRESET protocols
--           and also the data width from AACISDATAOUT line.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.AaciTrPackage.all;

-- ---------------------------------------------------------------------

entity AaciTrProtChk is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB bus clock
        PRESETn          : in    std_logic; -- APB Reset
        BITCLKIn         : in    std_logic; -- Serial Reference Clock
        AACITrEnBSync    : in    std_logic; -- AACITrEn sync'ed to
                                            -- BITCLK
        BtClkESync       : in    std_logic; -- BITCLKE sync'ed to BITCLK
        AACITrEn         : in    std_logic; -- Trickbox Enable signal
        AACISDATAIN      : in    std_logic; -- Trickbox serial data i/p
                                            -- AACISDATAOUT of the AACI
        SlotState        : in    std_logic_vector(3 downto 0);
                                            -- Slot data number
        AACITrBtClkPrd   : in    std_logic_vector(15 downto 0);
                                            -- BITCLK period value
        AACISYNC         : in    std_logic; -- AACISYNC port
        AACIRESET        : in    std_logic; -- AACIRESET port

        FORCEDRESET      : in    std_logic; -- Forced Reset bit AACI
                                            -- AACIRESET register
        FORCEDSYNC       : in    std_logic; -- Forced Sync bit AACISYNC
                                            -- register
        WidChkEnSync     : in    std_logic  -- Data width check
       );
end AaciTrProtChk;

-- ---------------------------------------------------------------------
--
--                            AaciTrProtChk
--                            =============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--  This module performs protocol checks on the AACIRESET and AACISYNC
-- outputs of the AACI. It checks whether the SYNC output is following
-- the FORCEDSYNC bit in the AACISYNC register.
--  Similarly the AACIRESET port is checked whether it follows the
-- FORCEDRESET bit in AACIRESET register.
--  The AACISDATAOUT data width is also checked in this block. For this,
-- the data pattern written to the AACI transmit FIFO is 1010...
-- pattern through APB. And the AACITrWidChkEn bit in the control
-- register of the trickbox has to be written with the value of 1(high).
-- In normal mode this bit has to be reset to zero. The data width will
-- be checked for half the BITCLK period with some allowable tolerance.
--   The AACISYNC setup period with respect to the falling edge of the
-- BITCLK is also checked in the normal mode with allowable tolerence.
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioral of AaciTrProtChk is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
-- Timing parmeters
signal DataRiseEdge     : time := 0 ns;
-- Rise Time of Data on AACISDATAOUT

signal DataFallEdge     : time := 0 ns;
-- Time of falling Edge of the data

signal SDataInCngeFlag  : std_logic := '0';
-- Time of change in SdataIn

signal SYNCChangeFlag   : std_logic := '0';
-- Time of change in AACISYNC

signal SYNCChangeTime   : time := 0 ns;
-- Time at which an actual transition occurred on the AACISYNC port

signal SDataInChngeTime : time := 0 ns;
-- Time at which an actual transition occurred on the AACISDATAIN port

signal BitClkRisingTime : time := 0 ns;
-- BITCLK rising edge time

signal SYNCActLTime     : time := 0 ns;
-- Time at which an actual high to low transition occurred on the
-- AACISYNC port

signal SYNCActHTime     : time := 0 ns;
-- Time at which an actual low to high transition occurred on the
-- AACISYNC port

signal SyncHighTime     : time := 0 ns;
-- Time at which a low to high transition on AACISYNC is detected on the
-- BITCLK-sync'ed version of AACISYNC

signal SyncLowTime      : time := 0 ns;
-- Time at which a high to low transition on AACISYNC is detected on the
-- BITCLK-sync'ed version of AACISYNC

signal SyncHighFlag     : std_logic := '0';
-- Flag for the high phase of AACISYNC

signal SyncLowFlag      : std_logic := '0';
-- Flag for the low phase of AACISYNC

signal DATAFlag1        : std_logic := '0';
-- Flag for the high phase of DATA

signal DATAFlag2        : std_logic := '0';
-- Flag for the low phase of DATA

signal SyncCapt         : std_logic;
-- AACISYNC port status captured in

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------
function to_integer (
         val : std_logic_vector; x : integer := 0
                    ) return integer is
variable returnint : integer;     -- Return variable from the function
variable xtmp      : integer;     -- Temporary variable
begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0'    => null;
        when '1'    => returnint := returnint + 1;
        when others => returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
end to_integer;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Connect local copies to output signals
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- This is the state machine to check the AACIRESET protocol of the AACI
-- This check is done on every rising edge of the PCLK
-- This process checks the AACIRESET protocol for FORCEDRESET bit
-- ---------------------------------------------------------------------
p_FRESETChkProt: process (PRESETn, AACITrEn, PCLK)
begin
  if (PRESETn = '1' and AACITrEn = '1') then
    if (PCLK'event and PCLK = '1') then
      if (AACIRESET /= FORCEDRESET) then
        assert false
          report "AACITB5 : AACIRESET port is NOT following the "
                    & "FORCEDRESET bit value defined"
          severity error;
      end if;
    end if;
  end if;
end process p_FRESETChkProt;

-- ---------------------------------------------------------------------
-- This is the state machine to check the AACISYNC protocol of the AACI
-- when BITCLK is disabled. This process checks the AACISYNC protocol
-- for FORCED SYNC This check is done on every rising edge of the PCLK.
-- ---------------------------------------------------------------------
p_FSYNCChkProt: process (PRESETn, PCLK)
begin
  if (PRESETn = '1') then
    if (PCLK'event and PCLK = '1') then
      if (AACISYNC /= FORCEDSYNC and (FORCEDSYNC = '1')) then
        assert false
          report "AACITB6 : AACISYNC port is NOT following the "
                  & " FORCEDSYNC bit value defined"
          severity error;
      end if;
    end if;
  end if;
end process p_FSYNCChkProt;

-- ---------------------------------------------------------------------
-- Getting the period of Data Width pulse for verification of the width
-- This process captures the positive and the negative edges of Data
-- pattern. This process is only enabled when the data width is to be
-- checked and the AaciTrWidChkEn bit in the control register in the
-- trickbox is enabled.
-- The process is sensitized to AACISDATAIN which is AACISDATAOUT coming
-- out from the AACI.
-- DATAFlag1 is used as a flag for the High Phase of the data pattern.
-- DATAFlag2 is used as a flag for the Low Phase of the data pattern.
-- ---------------------------------------------------------------------
p_GetDEdgesSeq: process (AACISDATAIN, AACITrEnBSync, WidChkEnSync,
                              PRESETn)
begin
  if (PRESETn = '0' or AACITrEnBSync = '0' or SlotState = ST_SYNC or
       SlotState = ST_SLOT2) then
    DATAFlag1 <= '0';
    DATAFlag2 <= '0';
  elsif (WidChkEnSync = '1') then
    if (AACISDATAIN'event and AACISDATAIN = '1') then
      if (DATAFlag1 = '0') then
        DataRiseEdge <= now;
        DATAFlag1    <= '1';
       end if;
      if (DATAFlag2 = '1') then
        DataRiseEdge <= now;
        DATAFlag2    <= '0';
      end if;
    elsif (AACISDATAIN'event and AACISDATAIN = '0') then
      if (DATAFlag2 = '0') then
        DataFallEdge <= now;
        DATAFlag2    <= '1';
      end if;
      if (DATAFlag1 = '1') then
        DataFallEdge <= now;
        DATAFlag1    <= '0';
      end if;
    end if;
  end if;
end process p_GetDEdgesSeq;

-- ---------------------------------------------------------------------
-- Checking for validity of Data width.
-- The difference in time between the rising and the falling edge of the
-- Data is compared with the value calculated from the BITCLK and an
-- Offset is provided for Gate Level Simulations.
-- ---------------------------------------------------------------------
p_ChkLPhaseSeq: process (DATAFlag2)
begin
  if (DATAFlag2'event and DATAFlag2 = '0') then
    if (AACITrEnBSync = '1' and SlotState /= ST_SYNC and 
        SlotState /= ST_SLOT2) then
      if (((DataRiseEdge - DataFallEdge) >
           ((to_integer(AACITrBtClkPrd) * 1 ns) + OFFSET))
         or ((DataRiseEdge - DataFallEdge) <
              ((to_integer(AACITrBtClkPrd) * 1 ns) - OFFSET))) then
        assert false
          report "AACTB7 : Data width Error for low phase"
          severity error;
      end if;
    end if;
  end if;
end process p_ChkLPhaseSeq;

p_ChkHPhaseSeq: process (DATAFlag1)
begin
  if (DATAFlag1'event and DATAFlag1 = '0') then
    if (AACITrEnBSync = '1' and SlotState /= ST_SYNC and
        SlotState /= ST_SLOT2) then
      if (((DataFallEdge - DataRiseEdge) >
           ((to_integer(AACITrBtClkPrd) * 1 ns) + OFFSET))
         or ((DataFallEdge - DataRiseEdge) <
              ((to_integer(AACITrBtClkPrd) * 1 ns) - OFFSET))) then
        assert false
          report "AACTB8 : Data width Error in the high phase"
        severity error;
      end if;
    end if;
  end if;
end process p_ChkHPhaseSeq;

-- ---------------------------------------------------------------------
-- The protocol Check to check the set up violation for AACISYNC with
-- respect to falling edge of the BITCLK
-- The next five process are for this protocol check
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Capturing the transitions on the AACISYNC in BITCLK domain on the
-- falling edged of the BITCLK.
-- ---------------------------------------------------------------------
p_SYNCSetUPProt : process (BITCLKIn, PRESETn)
begin
  if (PRESETn = '0') then
      SyncCapt <= '0';
  elsif (BITCLKIn'event and BITCLKIn = '0') then
    if (AACISYNC = '1') then
      SyncCapt <= '1';
    else
      SyncCapt <= '0';
    end if;
  end if;
end process p_SYNCSetUPProt;

-- ---------------------------------------------------------------------
-- Capturing the instants of AACISYNC transition in BITCLK domain
-- ---------------------------------------------------------------------
p_SyncCaptTimeProt : process (PRESETn, SyncCapt)
begin
  if (PRESETn = '0') then
    SyncHighFlag <= '0';
    SyncLowFlag  <= '0';
  elsif (SyncCapt'event and SyncCapt = '0') then
    SyncLowFlag  <= not SyncLowFlag;
    SyncLowTime  <= now;
  elsif (SyncCapt'event and SyncCapt = '1') then
    SyncHighFlag  <= not SyncHighFlag;
    SyncHighTime  <= now;
  end if;
end process p_SyncCaptTimeProt;

-- ---------------------------------------------------------------------
-- Capturing the actual transition instants on the AACISYNC port
-- ---------------------------------------------------------------------
p_ActSyncTimeProt : process (AACISYNC)
begin
  if (AACISYNC'event and AACISYNC = '0') then
    SYNCActLTime <= now;
  elsif (AACISYNC'event and AACISYNC = '1') then
    SYNCActHTime <= now;
  end if;
end process p_ActSyncTimeProt;

-- ---------------------------------------------------------------------
-- Checking the set up periods for the AACISYNC for low to high
-- transition
-- ---------------------------------------------------------------------
p_ChkHghSetupProt : process (SyncHighFlag)
begin
  if (PRESETn = '1' and AACITrEn = '1' and BtClkESync = '1') then
    if (SyncHighFlag'event) then
      if (SyncHighTime - SYNCActHTime <
          ((to_integer(AACITrBtClkPrd)/2 * 1 ns) - MAXSYNCDELAY)) then
        assert false
          report "AACTB9 : Set up violation for AACISYNC low to high"
                  & " transition with respect to falling edge of BITCLK"
        severity error;
      end if;
    end if;
  end if;
end process p_ChkHghSetupProt;

-- ---------------------------------------------------------------------
-- Checking the set up periods for the AACISYNC for high to low
-- transition
-- ---------------------------------------------------------------------
p_ChkLowSetupProt : process (SyncLowFlag)
begin
  if (PRESETn = '1' and AACITrEn = '1' and BtClkESync = '1') then
    if (SyncLowFlag'event) then
      if (SyncLowTime - SYNCActLTime <
          ((to_integer(AACITrBtClkPrd)/2 * 1 ns) - MAXSYNCDELAY)) then
        assert false
          report "AACTB10 : Set up violation for AACISYNC high to low "
                  & " transition with respect to falling edge of BITCLK"
        severity error;
      end if;
    end if;
  end if;
end process p_ChkLowSetupProt;

-- ---------------------------------------------------------------------
-- Sensing the transition instants on the AACISYNC port
-- ---------------------------------------------------------------------
p_SyncCngeProt : process (AACISYNC)
begin
  SYNCChangeTime <= now;
  SYNCChangeFlag <= not SYNCChangeFlag;
end process p_SyncCngeProt;

-- ---------------------------------------------------------------------
-- Capturing the instants of AACISYNC transition in BITCLK domain
-- ---------------------------------------------------------------------
p_RsngBClkProt : process (BITCLKIn)
begin
  if (BITCLKIn'event and BITCLKIn = '1') then
    BitClkRisingTime <= now;
  end if;
end process p_RsngBClkProt;

-- ---------------------------------------------------------------------
-- Sensing the transition instants on the AACISDATAIN port
-- ---------------------------------------------------------------------
p_SdataInProt : process (AACISDATAIN)
begin
  SDataInCngeFlag  <= not SDataInCngeFlag;
  SDataInChngeTime <= now;
end process p_SdataInProt;

-- ---------------------------------------------------------------------
-- Checking if the AACISDATAIN is delaying more than the allowed
-- ---------------------------------------------------------------------
p_SDtaTransProt : process (SDataInCngeFlag)
begin
  if ((PRESETn = '1') and (AACITrEn = '1') and (BtClkESync = '1') and
      (WidChkEnSync = '1')and (SlotState /= ST_SYNC)) then
    if (SDataInCngeFlag'event) then
      if (SDataInChngeTime - BitClkRisingTime > MAXSDATADELAY) then
        assert false
          report "AACTB11 : AACISDATAOUT port is delayed more than "
                  & "allowed with respect to rising edge of BITCLK"
        severity error;
      end if;
    end if;
  end if;
end process p_SDtaTransProt;

-- ---------------------------------------------------------------------
-- Checking if the AACISYNC is delaying more than the allowed
-- ---------------------------------------------------------------------
p_SyncTransProt : process (SYNCChangeFlag)
begin
  if ((PRESETn = '1') and (AACITrEn = '1') and (BtClkESync = '1') and
       (FORCEDSYNC /= '1')) then
    if (SYNCChangeFlag'event) then
      if (SYNCChangeTime - BitClkRisingTime > MAXSYNCDELAY) then
        assert false
          report "AACTB12 : AACISYNC port is delayed more than allowed "
                  & " with respect to rising edge of BITCLK"
        severity error;
      end if;
    end if;
  end if;
end process p_SyncTransProt;

end behavioral;

-- --============================ End ================================--
