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
--  File Name              : SspTrChecker.vhd.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- -----------------------------------------------------------------------------
-- Purpose      : Checker module for checking the protocols and 
--                SCLK width.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrChecker is
port (
      PCLK         : in std_logic;     -- APB bus clock
      SSPCLK       : in std_logic;     -- SSP Reference Clock
      PRESETn      : in std_logic;     -- APB Reset
      SCLK         : in std_logic;     -- SSP serial clock output
      SFRM         : in std_logic;     -- SSP serial frame output
      SCLKOUT      : in std_logic;     -- SSP serial clock output
      SFRMOUT      : in std_logic;     -- SSP serial frame output
      SSPRXD       : in std_logic;     -- SSP serial data output
      SPO          : in std_logic;     -- Polarity for Motorola SPI
      SPH          : in std_logic;     -- Phase for Motorola SPI
      SSESync      : in std_logic;     -- SSP Trickbox Enable Bit
      TxRxBSY      : in std_logic;     -- Busy status of Master-testing block
      STxRxBSY     : in std_logic;     -- Busy status of Slave-testing block
      ChkTxBSY     : in std_logic;     -- Transmit Receive Busy  
      MS           : in std_logic;     -- Master/Slave select input
      OD           : in std_logic;     -- Ignore SSP output
      TiDASFRM     : in std_logic;     -- Disable TI protocol check
      SSPOE        : in std_logic;     -- SSP output Enable
      GENCLK1      : in std_logic;     -- Transmit Receive Busy  
      DSS          : in std_logic_vector(3 downto 0);   
                                       -- Data Size Select
      FRF          : in std_logic_vector(1 downto 0); 
                                       -- Frame Format
      SCR          : in std_logic_vector(7 downto 0):= "00000001"; 
                                       -- Serial Clock Rate
      PRESCALE     : in std_logic_vector(3 downto 0):= "0001"; 
                                       -- Clock Prescale divisor
      SSPTBCLKREG  : in std_logic_vector(15 downto 0):= "0000000000000000";
                                       -- SSPCLK1 frequency value
      SSPTBCLKREG1 : in std_logic_vector(15 downto 0):= "0000000000000000" 
                                       -- SSPCLK frequency value
     );
end SspTrChecker;

-- -----------------------------------------------------------------------------
--
--                             SspTrChecker
--                             ============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ======== 
--
-- This module checks the protocol for the TI, Motorola SPI and National  
-- MicroWire modes.The check is also done to measure the width of the SCLK
-- and any discrepancies are reported. 
--
-- -----------------------------------------------------------------------------

-- ============================== ARCHITECTURE ===============================--
 
architecture behavioral of SspTrChecker is
 
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

 constant OFFSET       : time      := 2 ns;
-- Margin for the various signals 

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal SCLKRiseEdge   : time      := 0 ns;
-- Rise Time of SCLK

signal SFRMRiseEdge   : time      := 0 ns;
-- Rise Time of SFRM

signal SetupStartTime : time      := 0 ns; 
-- Start of Setup time

signal HoldStartTime  : time      := 0 ns;
-- Start of Hold time

signal SCLKFallEdge   : time      := 0 ns;
-- Time at the falling Edge of SCLK

signal SFRMFallEdge   : time      := 0 ns;
-- Time at the falling Edge of SFRM

signal SetupEndTime   : time      := 0 ns;
-- End of Setup time

signal HoldEndTime    : time      := 0 ns;
-- End of Hold time

signal SCLKFlag1      : std_logic := '0';  
-- Flag for the high phase of SCLK

signal SCLKFlag2      : std_logic := '0';   
-- Flag for the low phase of SCLK

signal SFRMFlag       : std_logic := '0'; 
-- Flag to capture edges of SFRM

signal SFRMFlag2      : std_logic := '0'; 
-- Flag to capture edges of SFRM

signal SetupFlag      : std_logic := '0';
-- Flag used to capture the Setup time

signal HoldFlag       : std_logic := '0';
-- Flag used to capture the Hold time

signal SSPRXDFlag     : std_logic := '0';
-- Flag used to ensure that the data has arrived correctly at the falling edge 
-- of SFRM in the SPI mode

signal TxRxBSYFlag    : std_logic := '0';
-- Flag to set only when receive line is 'z' and TxRxBSY is present

signal RxBeginFlag    : std_logic := '0';
-- Flag to indicate the begin of a receive in MW mode

signal TxBeginFlag    : std_logic := '0';
-- Flag to indicate the begin of a transmit in MW mode

signal DelSTxRxBSY    : std_logic := '0';
-- Delayed STxRxBSY for TI mode
 
signal DelSFRMOUT     : std_logic := '0';
-- Delayed SFRMOUT For TI mode
 
signal DelSFRM        : std_logic := '0';
-- Delayed SFRM
 
signal ModSSPOE       : std_logic;
-- Modified SSPOE For NMW Z Test
 
signal DelSFRMOUT2    : std_logic := '0';
-- Delayed SFRMOUT for 3 SSP Clock
 
signal MSSync         : std_logic;
-- Two SSPCLK delayed version
 
signal rxcounter      : std_logic_vector(3 downto 0) := "0000";
-- Used to count 8 SCLK for MW mode to indicate that transmission is over.

signal txcounter      : std_logic_vector(3 downto 0) := "0000";
-- Used to count the SCLK depending on the DSS in MW mode in receive mode.

signal CountRxData    : std_logic_vector(3 downto 0) := "0000";
-- Used to count the number of data bits received.

signal iDSS           : std_logic_vector(3 downto 0) := "0000";
-- Internal version of DSS

signal SCLKREFVALUE   : integer   := 0;
-- Used to compute the period of SCLK

signal SYNCOFFSET     : integer   := 0;
-- Tolerance setting for timing checks to account for gate delay variation

signal SSPCLKPRD      : integer   := 0;
-- Used to compute the period of SSPCLK when the SSP is operating at a SSPCLK
-- frequency different from that of the Trickbox

signal SSPCLKPRD2     : integer   := 0;
-- used to generate the MSSync  SSPCLK

signal SFRMREFTIME    : time      := 0 ns;
-- Time for which SFRM shuld be active in TI mode
 
-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
function to_integer (val : std_logic_vector; x : integer := 0)
  return integer is
  variable returnint : integer;      -- Return variable from the function
  variable xtmp      : integer;      -- Temporary variable
begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0' =>     null;
        when '1' =>     returnint := returnint + 1;
        when others =>  returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
end to_integer;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

iDSS <= (DSS(3 downto 0));

-- -----------------------------------------------------------------------------
-- Calculation of SCLK pulse width from the registers 
-- SCLKTBCLKREG, SCR, PRESCALE according to the formula 
-- SCLKPhaseTimePeriod = SCLKTBCLKREG * PRESCALE * (SCR + 1)
-- -----------------------------------------------------------------------------
p_CalcSCLKComb: process (SSESync, PRESCALE, SCR, TxRxBSY, GENCLK1, SSPRXD)
begin
  if (SSESync = '1') then
    if (PRESCALE = "0000") then
      assert false
        report "PRESCALE value not defined"
      severity error;
    else
      SCLKREFVALUE <= (to_integer(SSPTBCLKREG) * to_integer(PRESCALE) 
                       *  to_integer((unsigned(SCR)+1)));
      if (GENCLK1 = '0') then
        SYNCOFFSET <= (to_integer(SSPTBCLKREG) * 3);
        SSPCLKPRD  <= 0;
      else
        SYNCOFFSET <= (to_integer(SSPTBCLKREG1) * 3);
        SSPCLKPRD  <= (to_integer(SSPTBCLKREG1) * 2); 
      end if;  
    end if;
  end if;
  if (TxRxBSY = '1' and SSPRXD = 'Z') then
    TxRxBSYFlag <= '1';
  elsif (TxRxBSY = '0' and SSPRXD = 'Z') then
    TxRxBSYFlag <= '0';
  end if;
end process p_CalcSCLKComb;

-- -----------------------------------------------------------------------------
-- Getting the period of SCLK pulse for later verification
-- This process captures the positive and the negative edges of SCLK
-- The process is sensitized to SCLK
-- SCLKFlag1 is used as a flag for the High Phase
-- SCLKFlag2 is used as a flag for the Low Phase
-- -----------------------------------------------------------------------------
p_GetSCLKedgesSeq: process (SCLK, SSESync, PRESETn, SSPRXD, ChkTxBSY)
begin
  if (PRESETn = '0' or SSESync = '0' or ChkTxBSY = '0') then
    SCLKFlag1 <= '0';
    SCLKFlag2 <= '0';
  elsif (SCLK'event and SCLK = '1') then
    if (SCLKFlag1 = '0') then
      SCLKRiseEdge <= now;
      SCLKFlag1 <= '1';
     end if;
    if (SCLKFlag2 = '1') then
      SCLKRiseEdge <= now;
      SCLKFlag2 <= '0';
    end if;
  elsif (SCLK'event and SCLK = '0') then
    if (SCLKFlag2 = '0') then
      SCLKFallEdge <= now;
      SCLKFlag2 <= '1';
    end if;
    if (SCLKFlag1 = '1') then
      SCLKFallEdge <= now;
      SCLKFlag1 <= '0';
    end if; 
  end if;
end process p_GetSCLKedgesSeq;

-- -----------------------------------------------------------------------------
-- Checking for validity of SCLK width.   
-- The difference in time between the rising and the falling edge of the 
-- SCLK is compared with the value calculated from the registers and an Offset
-- is provided for Gate Level Simulations.
-- -----------------------------------------------------------------------------
p_ChecklowphaseSeq: process (SCLKFlag2)
begin
  if (SCLKFlag2'event and SCLKFlag2 = '0') then
    if (SSESync = '1' and ChkTxBSY = '1') then
      if (((SCLKRiseEdge - SCLKFallEdge) > ((SCLKREFVALUE  * 1 ns) + OFFSET))
         or ((SCLKRiseEdge - SCLKFallEdge) < ((SCLKREFVALUE * 1 ns) - OFFSET)))
         then
        assert false
          report "SCLK ERROR for the low phase"  
        severity error;
      end if;
    end if;
  end if;
end process p_ChecklowphaseSeq;

p_CheckhighphaseSeq: process (SCLKFlag1)
begin
  if (SCLKFlag1'event and SCLKFlag1 = '0') then
    if (SSESync = '1' and ChkTxBSY = '1') then
      if (((SCLKFallEdge - SCLKRiseEdge) > ((SCLKREFVALUE  * 1 ns) + OFFSET))
         or ((SCLKFallEdge - SCLKRiseEdge) < ((SCLKREFVALUE * 1 ns) - OFFSET)))
         then
        assert false
          report "SCLK ERROR in the high phase"  
        severity error;
      end if;
    end if;
  end if;
end process p_CheckhighphaseSeq;

-- -----------------------------------------------------------------------------
-- This process checks for the signal SCLK at the time SFRM goes low
-- in the Motorola SPI mode. The values to be present in the SCLK line are as
-- follows 
--
--       00        -     0
--       01        -     1 
--       10        -     0
--       11        -     1
--
-- The process is sensitized to SFRM
-- -----------------------------------------------------------------------------
p_MotSCLKcheckSeq: process (SFRM)
begin
  if (SSESync = '1') then
    if (SFRM'event and SFRM = '0') then
      if (FRF = "00") then 
        if (SPH = '0' and SPO = '0') then
          if (SCLK /= '0') then 
            assert false
              report "SCLK not initially low in SPI 00 mode"
            severity error;
          end if;
        elsif (SPH = '0' and SPO = '1') then
          if (SCLK /= '1') then
            assert false
              report "SCLK not intially high in SPI 01 mode"
            severity error;
          end if;
        elsif (SPH = '1' and SPO = '0') then
          if (SCLK /= '0') then
            assert false
              report "SCLK not initially low in SPI 10 mode"
            severity error;
          end if;
        elsif (SPH = '1' and SPO = '1') then
          if (SCLK /= '1') then
            assert false
              report "SCLK not intially high in SPI 11 mode"
            severity error;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_MotSCLKcheckSeq;

-- -----------------------------------------------------------------------------
-- Getting the period of SFRM pulse for later verification
-- For TI mode
-- -----------------------------------------------------------------------------
p_GetSFRMedgesSeq: process (SFRM, SSESync)                          
begin
  if (SSESync = '0') then
    SFRMFlag <= '0';
  end if;
  if (SSESync = '1') then
    if (SFRM'event and SFRM = '1') then
      SFRMREFTIME <= SCLKREFVALUE * 2 * 1 ns;
      if (SFRMFlag = '0') then
        SFRMRiseEdge <= now;
        SFRMFlag <= '1'; 
      end if;
    elsif (SFRM'event and SFRM = '0') then
      if (SFRMFlag = '1') then
        SFRMFallEdge <= now;
        SFRMFlag <= '0';
      end if;
    end if;
  end if;
end process p_GetSFRMedgesSeq;

-- -----------------------------------------------------------------------------
-- Checking for SFRM width in TI mode
-- Check if SFRM is going high at the right place after transmission
-- -----------------------------------------------------------------------------
p_CheckSFRMComb: process (SFRMFlag)
begin
  if (SFRMFlag = '0') then
    if (SSESync = '1') then
      if (FRF = "01") then
        if (((SFRMFallEdge - SFRMRiseEdge) > SFRMREFTIME + OFFSET) or 
            ((SFRMFallEdge - SFRMRiseEdge) < SFRMREFTIME - OFFSET)) then
          assert false
            report "SFRM ERROR in TI Mode"  
          severity error;
        end if;
      end if;
    end if;
  elsif (SFRMFlag = '1') then
    if (SSESync = '1') then
      if (SFRM = '1') then
        if ((FRF = "00" and SPH = '0' and SPO = '0')
            or (FRF = "10")) then
          if ((SFRMRiseEdge - SCLKFallEdge) > ((SCLKREFVALUE * 1 ns) + OFFSET)
              or (SFRMRiseEdge - SCLKFallEdge) < ((SCLKREFVALUE * 1 ns) - OFFSET
              )) then
            assert false
              report "SFRM HASNT GONE HIGH "
            severity error;
          end if;
        elsif (FRF = "00" and SPH = '1' and SPO = '0') then
          if ((SFRMRiseEdge - SCLKFallEdge) > (SFRMREFTIME + OFFSET) or
              (SFRMRiseEdge - SCLKFallEdge) < (SFRMREFTIME - OFFSET)) then
            assert false
              report "SFRM HASNT GONE HIGH in SPI 10 mode"
            severity error;
          end if; 
        elsif (FRF = "00" and SPH = '0' and SPO = '1') then
          if ((SFRMRiseEdge - SCLKRiseEdge) > ((SCLKREFVALUE * 1 ns) + OFFSET)
              or (SFRMRiseEdge - SCLKRiseEdge) < ((SCLKREFVALUE * 1 ns) - OFFSET
              )) then
            assert false
              report "SFRM HASNT GONE HIGH in SPI 01 mode"
            severity error;
          end if;
        elsif (FRF = "00" and SPH = '1' and SPO = '1') then
          if ((SFRMRiseEdge - SCLKRiseEdge) > (SFRMREFTIME + OFFSET) or 
              (SFRMRiseEdge - SCLKRiseEdge) < (SFRMREFTIME - OFFSET)) then
            assert false
              report "SFRM HASNT GONE HIGH in SPI 11 mode"
            severity error;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_CheckSFRMComb;

-- -----------------------------------------------------------------------------
-- Check for ensuring that the Transmit line goes Z after the transmission 
-- of 8 bits. This process also checks if the data is transmitted at the edge
-- of SFRM turning low. 
-- -----------------------------------------------------------------------------
p_CheckTxSeq: process (SSPCLK, SFRM, SSESync)
begin
  if ((SFRM'event and SFRM = '1') or (SSESync'event and SSESync = '1')) then
    SSPRXDFlag <= '0';
  end if;
  if (SSPCLK'event and SSPCLK = '1') then
    if (RxBeginFlag = '0' and TxBeginFlag = '1' and FRF = "10") then
      if not ((SSPRXD = 'Z')) then
        assert false
          report"In MW mode Transmit line is not Z"
        severity error;
      end if;
    end if;
    if (SSPRXDFlag = '0') then
      if (FRF = "00" or FRF = "10") then
        if (SSESync = '1' and TxRxBSY = '1' and TxRxBSYFlag = '0') then
          if (SFRM = '0') then
            SSPRXDFlag <= '1';
            if (SSPRXD = 'Z') then
              if (FRF = "00") then 
                assert false
                  report "First Data hasnt arrived correctly in SPI at SFRM"
                severity note;
              end if;
              if (FRF = "10") then 
                assert false
                  report "First Data hasnt arrived correctly in MW at SFRM"
                severity note;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_CheckTxSeq;

-- -----------------------------------------------------------------------------
-- Protocol Checking for the National Microwire Mode
-- -----------------------------------------------------------------------------
p_CheckMWSeq: process (SCLK, SFRM)
begin
  if (FRF = "10") then
    if (SFRM'event and SFRM = '0') then
      RxBeginFlag <= '1';
    end if;
    if (SCLK'event and SCLK = '1') then
      if (RxBeginFlag = '1') then
         rxcounter <= (unsigned(rxcounter) + 1);
         if (rxcounter = "1000") then
           RxBeginFlag <= '0';
           rxcounter <= "0000";
           TxBeginFlag <= '1';
         end if;
      elsif (TxBeginFlag = '1') then
        txcounter <= (unsigned(txcounter) + 1);
        if (txcounter = iDSS) then
          TxBeginFlag <= '0';
          RxBeginFlag <= '1';
          txcounter <= "0000";
        end if;
      end if;
    end if;
  end if;
end process p_CheckMWSeq;

-- -----------------------------------------------------------------------------
-- Process  sets the Setupflag and clears the holdflag with respect to 
-- changes of SSPRXD
-- -----------------------------------------------------------------------------
p_GegeSetupSeq: process (SCLK, SCLKOUT, SSPRXD, SSESync, PRESETn)
begin
  if (PRESETn = '0') then
    SetupFlag <= '0';
    HoldFlag  <= '0';
  elsif (SSESync = '0') then
    SetupFlag <= '0';
    HoldFlag  <= '0';
  elsif (((SCLK'event and SCLK = '0') and (MS = '0')) or 
      ((SCLKOUT'event and SCLKOUT = '0') and (MS = '1'))) then
    if ((FRF = "01") or (FRF = "00" and SPH = '0' and SPO = '1') 
         or (FRF = "00" and SPH = '1' and SPO = '0')) then
      if (SetupFlag = '1') then
        SetupFlag <= '0';
        SetupEndTime <= now;
        HoldFlag <= '1';
        HoldStartTime <= now;
      end if;
    end if;
  elsif (((SCLK'event and SCLK = '1') and (MS = '0')) or 
      ((SCLKOUT'event and SCLKOUT = '1') and (MS = '1'))) then
    if ((FRF = "10") or (FRF = "00" and SPH = '0' and SPO = '0')
         or (FRF = "00" and SPH = '1' and SPO = '1')) then
      if (SetupFlag = '1') then
        SetupFlag <= '0';
        SetupEndTime <= now;
        HoldFlag <= '1';
        HoldStartTime <= now;
      end if;
    end if;
  end if;
  if ((SSPRXD'event) and (STxRxBSY = '0') and (MS = '1')) then
    SetupFlag <= '0';
  elsif (SSPRXD'event and SSPRXD /= 'Z') then
    if ((FRF = "10") and (((RxBeginFlag = '0') and (MS = '0')) or 
        ((ModSSPOE = '1') and (MS = '1')))) then
      SetupFlag <= '0'; 
    elsif (not((FRF = "01") and  (((SFRM = '1') and 
          (MS = '0')) or ((SFRMOUT = '1') and  (MS = '1'))))) then
      SetupFlag <= '1';
      SetupStartTime <= now;
    end if;
    if (HoldFlag = '1') then 
      HoldFlag <= '0';
      HoldEndTime <= now;
    end if; 
  end if;
end process p_GegeSetupSeq;   

-- -----------------------------------------------------------------------------
-- Check for the Setup Time and indicate an error if the time is less than
-- the SCLK half period.
-- -----------------------------------------------------------------------------
p_CheckSetupSeq: process (SetupFlag)
begin
  if (SetupFlag'event and SetupFlag = '0') then
    if ((SSESync = '1') and (MS = '0')) then
      if ((SetupEndTime - SetupStartTime) < ((SCLKREFVALUE * 1 ns)
           - OFFSET)) then
        assert false
          report "Setup Time violated"
        severity error;
      end if;
    elsif ((SSESync = '1') and (MS = '1') and (STxRxBSY = '1')) then
      if ((SetupEndTime - SetupStartTime) < ((SCLKREFVALUE * 1 ns)
           - (SYNCOFFSET * 1 ns + OFFSET))) then
        assert false
          report "Setup Time violated"
        severity error;
      end if;
    end if;
  end if;
end process p_CheckSetupSeq; 
  
-- -----------------------------------------------------------------------------
-- Check for the Setup Time and indicate an error if the time is less than
-- the SCLK half period.
-- -----------------------------------------------------------------------------
p_CheckHoldSeq: process (HoldFlag)
begin
  if (HoldFlag'event and HoldFlag = '0') then
    if (SSESync = '1') and (MS = '0') then
      if ((HoldEndTime - HoldStartTime) < ((SCLKREFVALUE * 1 ns) - OFFSET)) then
        assert false
          report "Hold Time violated"
        severity error;
      end if;
    elsif (SSESync = '1') and (MS = '1') then
      if ((HoldEndTime - HoldStartTime) < ((SCLKREFVALUE * 1 ns)
           - (SYNCOFFSET * 1 ns + OFFSET))) then
        assert false
          report "Hold Time violated"
        severity error;
      end if;
    end if;
  end if;
end process p_CheckHoldSeq;

-- -----------------------------------------------------------------------------
-- If the SSP is in the Master mode, with the frame format set to SPI and with 
-- SPH = 0, on a rising edge of SFRM, SCLK should be at the value programmed in
-- SPO. Also, signals used to check the duration of SFRM deactivation in this 
-- mode are initialised.
-- -----------------------------------------------------------------------------
p_CheckFrDeact : process (SFRM)
begin
  if (SFRM = '1') then
    if ((FRF = "00") and (SPH = '0') and (MS = '0') and (SSESync = '1')) then
      CountRxData  <= "0000";
      SFRMFlag2    <= '1';
      if (SCLK /= SPO) then
        assert false
          report "Error : SCLK is not Default value when SFRM High"
        severity error;
      end if;
    end if;
  end if;
end process p_CheckFrDeact;

-- -----------------------------------------------------------------------------
-- Verify that 
--   - the SSP negates SFRM between frames
--   - the duration of SFRM negation between frames is atleast one SCLK phase 
--     time
-- -----------------------------------------------------------------------------
p_CheckFrDeact1 : process (SFRM, SCLK)
begin 
  if (SFRM'event and SFRM  = '0') then
    if ((FRF = "00") and (SPH = '0') and (MS = '0') and (SSESync = '1')) then
      if (SFRMFlag2 = '1') then
        SFRMFlag2    <= '0';
        if (SFRMRiseEdge - SFRMFallEdge < (SCLKREFVALUE * 1 ns - OFFSET)) then
          assert false
            report "Error : SFRM is not  high for  half SCLK"
          severity error;
        end if;
        if (SCLK /= SPO) then
          assert false
            report "Error: SCLK Not at Default value at falling edge of SFRM"
          severity error;
        end if;
      end if;
      if (SCLK /= SPO) then
        CountRxData <= (unsigned(CountRxData) + 1);
        if (CountRxData > (unsigned(DSS) + 1)) then
          assert false
            report "Error : SFRM is not  Deactivated "
          severity error;
        end if;
      end if;
    end if;
  end if;
end process p_CheckFrDeact1;

-- -----------------------------------------------------------------------------
-- Generate a delayed version of SFRM for use in checking the tri-stating of the
-- SSPRXD line.
-- -----------------------------------------------------------------------------
GenDelSFRM : process(SFRM)
begin
  if (SFRM = '0') then
    DelSFRM <= '0' after OFFSET;
  else
    DelSFRM <= '1';
  end if;
end process GenDelSFRM;

-- -----------------------------------------------------------------------------
-- Verify that
--   - the SSPRXD input is not tri-stated during the period for which DelSFRM is
--     negated between successive frames.
-- -----------------------------------------------------------------------------
p_CheckSSPRXDComb : process(DelSFRM)
begin
  if (DelSFRM = '0') then
    if ((FRF = "00") and (SPH = '0') and (MS = '0') and (SSESync = '1') and
        (SSPRXD = 'Z')) then
       assert false
         report"Error: SSPRXD is  'Z' at SFRM fall edge"
       severity error;
    end if;
  end if;
end process p_CheckSSPRXDComb;

-- -----------------------------------------------------------------------------
-- In the TI mode, it is expected that the SSPRXD line from the SSP should 
-- remain tri-stated when a valid frame is not being transferred. The 
-- DelSTxRxBSY signal, when low indicates that the trickbox is Idle, which in
-- turn indicates that the SSPRXD line should remain tri-stated.
-- -----------------------------------------------------------------------------
p_TiHighZTest: process (DelSTxRxBSY , SSPRXD)
begin
  if ((MS = '1') and (FRF = "01")) then
    if ((DelSTxRxBSY = '0') and (SSPRXD /= 'Z') and (TiDASFRM = '0')) then
      assert false
        report"Error : SSPRXD is not  'Z' at Idle in Ti mode"
      severity error;
    end if;
  end if;
end process p_TiHighZTest;
        
-- -----------------------------------------------------------------------------
-- Generation of the DelSTxRxBSY signal. This signal when cleared indicates
-- that the SSPRXD line should be checked for tri-state. 
-- This signal is set one SCLK phase time after the end of a frame of data. This
-- is because the SSPRXD from the SSP goes tri-state one SCLK phase time after
-- the end of the frame.
-- This signal is cleared a few SSPCLKs after the start of a frame to account
-- for synchronisation delays.
-- -----------------------------------------------------------------------------
GenDelSTxRxBSY: process (STxRxBSY)
begin
  if (STxRxBSY = '1') then
    DelSTxRxBSY <= STxRxBSY after (SCLKREFVALUE * 1 ns - OFFSET);
  elsif (STxRxBSY = '0') then
    DelSTxRxBSY <= STxRxBSY after 
                   (SYNCOFFSET * 1 ns  + OFFSET + SSPCLKPRD * 1 ns );
  end if;
end process GenDelSTxRxBSY;

-- -----------------------------------------------------------------------------
-- In the Slave mode, the SSPRXD from the SSP is expected to remain tri-stated
-- when there is no data transfer in progress i.e. when SFRMIN to the SSP is
-- high (inactive). The DelSFRMOUT2 signal has a waveform similar to SFRMOUT
-- with slight corrections to account for synchronisation delays.
-- -----------------------------------------------------------------------------
p_GDSFRMOUT2seq: process (SFRMOUT)
begin
  if (SFRMOUT = '1') then
    DelSFRMOUT2 <= SFRMOUT after  (SYNCOFFSET * 1 ns + OFFSET);
  elsif (SFRMOUT = '0') then
    DelSFRMOUT2 <= SFRMOUT;
  end if;
end process p_GDSFRMOUT2seq;

-- -----------------------------------------------------------------------------
-- When the SSP slave is in the SPI mode, SSPRXD from the SSP is expected to 
-- remain tri-stated when SFRM is negated.
-- -----------------------------------------------------------------------------
p_SpiHighZTest : process (DelSFRMOUT2)
begin
  if (DelSFRMOUT2 = '1') then
    if ((MS = '1') and (FRF = "00") and (SSPRXD /= 'Z') and 
       (SSESync = '1')) then
        assert false
          report"Error : SSPRXD is not  'z' at SFRM = 1 in SPI"
        severity error;
    end if;
  end if;
end process p_SpiHighZTest;

-- -----------------------------------------------------------------------------
-- When the SSP slave is in the SPI mode, SSPRXD from the SSP is expected to 
-- remain tri-stated when there is no data transfer.
-- -----------------------------------------------------------------------------
p_SpiHighZTest1 : process (SSPRXD)
begin
  if (DelSFRMOUT2 = '1') then
    if ((MS = '1') and (FRF = "00") and (SSPRXD /= 'Z') and 
       (SSESync = '1')) then
       assert false
         report"Error : SSPRXD is not 'z' at SFRM = 1 in SPI"
       severity error;
    end if;
  end if;
end process p_SpiHighZTest1;

-- -----------------------------------------------------------------------------
-- The ModSSPOE signal is high for the duration of transmission of serial data
-- by the Trickbox. This signal is used to check the tri-stating of the SSPRXD
-- line in the NM mode.
-- -----------------------------------------------------------------------------
p_GenModSSPOEseq : process (SSPOE)
begin
  if (SSPOE = '1') then
    ModSSPOE <= '1' after ((2 ns * SCLKREFVALUE) + SYNCOFFSET * 1 ns + OFFSET);
    ModSSPOE <= '0' after ((15 ns * SCLKREFVALUE) - OFFSET);
  end if;
end process p_GenModSSPOEseq;

-- -----------------------------------------------------------------------------
-- When the SSP slave is in the NM mode, the SSPRXD from the SSP is expected
-- to remain tr-stated when SFRM is inactive and during the transmit duration
-- of the control word from the Trickbox.
-- -----------------------------------------------------------------------------
p_NMHighZTest : process (SSPRXD, ModSSPOE, DelSFRMOUT2)
begin
  if ((MS = '1') and (FRF = "10") and (SSESync = '1')) then
    if ((DelSFRMOUT2 = '1') or (ModSSPOE = '1')) then
      if (SSPRXD /= 'Z') then
        assert false
          report "Error : SSPRXD is not  'z' this point in NM"
        severity error;
      end if;
    end if;
  end if;
end process p_NMHighZTest;

-- -----------------------------------------------------------------------------
-- Verify that the SSPRXD line from the SSP slave is tristated when 
--   - the SOD bit in the SSP is set
--   - the SSP is disabled
-- In both these cases, the OD bit in the Trickbox is set to enable the check on
-- the SSPRXD line.
-- -----------------------------------------------------------------------------
p_SodTestComb : process (SSPRXD, MS, OD)
begin
  if ((MS = '1') and (OD = '1') and (SSPRXD /= 'Z'))  then
    assert false
      report "Error : SSPRXD is not 'Z' for OD = 1"
    severity error;
  end if;
end process p_SodTestComb;

-- -----------------------------------------------------------------------------
-- The DelSFRMOUT signal is asserted for a period during which the SSPRXD line
-- from the SSP slave is expected to remain stable.
-- -----------------------------------------------------------------------------
p_DelSFRMOUTComb : process (SFRMOUT, SSESync)
begin
  if ((SSESync'event and SSESync  = '0') or (SFRMOUT'event)) then
    if (SFRMOUT = '1') then
      DelSFRMOUT <= transport SSESync after
                    ((2 ns * SCLKREFVALUE) + (SYNCOFFSET * 1 ns + OFFSET));
    elsif (SFRMOUT = '0') then
      if (SCLKREFVALUE > 0) then
        DelSFRMOUT <= transport '0' after ((2 ns * SCLKREFVALUE) - OFFSET);
      end if;
    end if;
  end if;
end process p_DelSFRMOUTComb;

-- -----------------------------------------------------------------------------
-- Monitor the SSPRXD line from the SSP slave to verify that it does not
-- change when SFRM is high in the TI mode. Specifically, in the Extended
-- SFRM mode, the SSP is expected to retain the first bit of transmit data on 
-- the serial line till the first falling edge of SCLK after SFRM has gone low.
-- -----------------------------------------------------------------------------
p_ESFRMComb : process (SSPRXD)
begin
  if ((FRF = "01") and (DelSFRMOUT = '1') and (MS = '1')) then
    assert false
      report "Error : SSPRXD changed when SFRM high in TI mode"
    severity error;
   end if;
end process p_ESFRMComb;

-- -----------------------------------------------------------------------------
-- When the SSP is in the Master mode and is disabled, monitor the SCLK and 
-- SFRM outputs to verify that they are at the default values. The OD bit in
-- the trickbox is set to enable this check.
-- -----------------------------------------------------------------------------
p_MDTestComb : process (SCLK, SFRM, FRF, OD, MS)
begin
  if ((MS = '0') and (OD = '1')) then
    if ((FRF = "00") and ((SCLK /= SPO) or (SFRM /= '1'))) then
       assert false
         report "Error : SCLK/SFRM not at default value when SSP disabled"
       severity error;
    elsif ((FRF = "10") and ((SCLK /= '0') or (SFRM /= '1'))) then
      assert false
        report "Error : SCLK/SFRM not at default value when SSP disabled"
      severity error;
    elsif ((FRF = "01") and ((SCLK /= '0') or (SFRM /= '0'))) then
      assert false
        report "Error : SCLK/SFRM not at default value when SSP disabled"
      severity error;
    end if;
  end if;
end process p_MDTestComb;

-- -----------------------------------------------------------------------------
-- The SSPCLKPRD2 signal holds the value corresponding to 2 periods of the
-- SSPCLK on which the SSP operates.
-- -----------------------------------------------------------------------------
p_SSPCLKPRD2Comb : process (SSPTBCLKREG, SSPTBCLKREG1, GENCLK1)
begin
  if (GENCLK1 = '0') then
    SSPCLKPRD2  <= to_integer(SSPTBCLKREG) * 2;
  elsif (GENCLK1 = '1') then
    SSPCLKPRD2   <= to_integer(SSPTBCLKREG1) * 2;
  end if;
end process p_SSPCLKPRD2Comb;

-- -----------------------------------------------------------------------------
-- Ensure that the MS bit is seen at the same time or after it is seen by the
-- SSP.
-- -----------------------------------------------------------------------------
p_GenMSSync : process (MS)
begin
  if (MS = '1') then
    MSSync <= '1' after SSPCLKPRD2 * 1 ns;
  elsif (MS = '0') then
    MSSync <= '0';
  end if;
end process p_GenMSSync;
   
-- -----------------------------------------------------------------------------
-- Monitor the SCLKOUT and SFRMOUT signals from the SSP to verify that these
-- are not driven by the SSP when in slave mode.
-- -----------------------------------------------------------------------------
p_GenSTestComb: process (MSSync, SCLK, SFRM)
begin
  if ((MSSync = '1') and ((SCLK /= 'Z') or (SFRM /= 'Z'))) then
     assert false
       report "Error : SCLKOUT and SFRMOUT is not 'z' in slave mode"
     severity error;
   end if;
end process p_GenSTestComb;
end behavioral;

-- --================================ End ====================================--
