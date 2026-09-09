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
-- File Name              : MpmcTrProChkr.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module does the protocol checks on the MPMC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity MpmcTrProChkr is
  generic (
           Tclk : time := 20 ns
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- Clock Input from AHB
        HRESETn          : in    std_logic; -- Reset from AHB
        MPMCCLKOUT       : in    std_logic_vector(3 downto 0);
                                            -- Memory clock out from MPMC
        MPMCCLK          : in    std_logic; -- Memory clock in to the MPMC
        nPOR             : in    std_logic; -- Power On Reset
        MPMCTrExpRef     : in    std_logic_vector(3 downto 0);
                                            -- Expected number of refresh
                                            -- cycles during initialisation
        MPMCTrExBkOff    : in    std_logic_vector(5 downto 0);
                                            -- Expected number of clks after
                                            -- which backoff is asserted 
        MPMCTrSRWr       : in    std_logic; -- Write Select from the top module
        ProtChkMask      : in    std_logic; -- Protocol check mask
        HREADY0ChkEn     : in    std_logic; -- HREADY0 check enable
        HREADY1ChkEn     : in    std_logic; -- HREADY1 check enable
        MPMCCKEOUT       : in    std_logic_vector(3 downto 0);
                                            -- Clock Enable Pin to memory device
        nMPMCRASOUT      : in    std_logic; -- nMPMCRASOUT output from the
                                            -- memory module
        nMPMCCASOUT      : in    std_logic; -- nMPMCCASOUT output from the
                                            -- memory module
        MPMCTrDynMEMT    : in    std_logic_vector(3 downto 0);
                                            -- Indicates the Memory Device type
        MPMCTrWrPrStat   : in    std_logic_vector(3 downto 0);
                                            -- Indicates the write protect
                                            -- status of dy memory connected
        nMPMCDYCSOUT     : in    std_logic_vector(3 downto 0);
                                            -- Synchronise memory Chip Select
                                            -- from MPMC
        nMPMCSTCSOUT     : in    std_logic_vector(3 downto 0);
                                            -- Memory Bank Select signals from
                                            -- the MPMC
        MPMCACTLOWCS     : in    std_logic_vector(3 downto 0);
                                            -- Active low Memory Bank Select
        nMPMCWEOUT       : in    std_logic; -- nMPMCWEOUT output from the
                                            -- memory module
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
                                            -- Data Bus enable signal
        nMPMCOEOUT       : in    std_logic; -- Memory read enable
        MPMCDQMOUT       : in    std_logic_vector(3 downto 0);
                                            -- Data Bus Lane Enable signal
        nMPMCRPOUT       : in    std_logic; -- Sync Flash Reset/Power down
                                            -- signal
        MPMCRPVHHOUT     : in    std_logic; -- Sync Flash Reset/Power down
                                            -- to be driven to VHH
        MPMCSREFACK      : in    std_logic; -- Self Referesh acknowledg from
                                            -- MPMC
        MPMCADDROUT      : in    std_logic_vector(27 downto 0);
                                            -- Memory Address from the MPMC for
                                            -- checking 'X'es on it
        MPMCDATAOUT      : in    std_logic_vector(31 downto 0);
                                            -- Memory Data Out from the MPMC
                                            -- for checking 'X'es on it
        MPMCTrDynRfrshWr : in    std_logic; -- MPMCTrDynRfrsh Register Write
        MPMCTrDynRfrsh   : in    std_logic_vector(10 downto 0);
                                            -- Refresh count register
        MPMCTrControl    : in    std_logic_vector(3 downto 0);
                                            -- MPMCTrControl Register
        MPMCTrDynCntl    : in    std_logic_vector(15 downto 0);
                                            -- MPMCTrDynCntl Register
        DataSR           : in    std_logic_vector(8 downto 0);
                                            -- Data Input from the top module
        MPMCEBIREQ       : in    std_logic; -- EBI request from MPMC
        HREADYOutMpmc0   : in    std_logic; -- HREADYOut from Port0
        HREADYOutMpmc1   : in    std_logic; -- HREADYOut from Port0
       	HREADY0CNT       : in    std_logic_vector(7 downto 0);
                                            -- Expected number of clks beyond
                                            -- which if the hready0 is low,
                                            -- error message will be displayed.
       	HREADY1CNT       : in    std_logic_vector(7 downto 0);
                                            -- Expected number of clks beyond
                                            -- which if the hready1 is low,
                                            -- error message will be displayed.
-- Outputs
        MPMCEBIGNT       : out   std_logic; -- EBI grant to the MPMC
        MPMCEBIBACKOFF   : out   std_logic; -- EBI backoff signal to the MPMC
        MPMCTrSR         : out   std_logic_vector(8 downto 0)
                                            -- MPMCTrSR Register
       );
end MpmcTrProChkr;

-- -----------------------------------------------------------------------------
--
--                                MpmcTrProChkr
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module checks for the diffrent command issued by the MPMC. It checks
-- the following aspects of the MPMC:
--   x The SDRAM/SyncFLASH initialisation sequence
--   x Refresh command frequency and validity of the refresh command sequence
--   x Multiple assertion of static/dynamic chip selects
--   x Memory command signals going to 'X's
--   x Checks if the clock is running when the command is issued
--   x Checks if the clock enable is pulled to active properly
--   x MPMC disabled mode operation checks
--   x MPMC low power mode operation checks
--   x Behaviour of RP/RPVHH signals
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture behavioural of MpmcTrProChkr is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant RefTolerance     : std_logic_vector(7 downto 0) := "00011111";
-- Tolerance count for refresh command

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal nReset           : std_logic;

signal ValidRefCmd      : std_logic;
-- Indicates a valid refresh command has been issued

signal NxtSREF          : std_logic;
-- D-Input to SREF

signal SREF             : std_logic;
-- SREF command Detect Ouptut

signal PresentState     : std_logic_vector(2 downto 0);
-- State vector for the initialisation check logic

signal NxtState         : std_logic_vector(2 downto 0);
-- D-input for the State vector

signal InitSeqErrSt     : std_logic;
-- Indicates the initialisation sequence error

signal NxtInitSeqErrSt  : std_logic;
-- D-input for InitSeqErrSt

signal RefCmd           : std_logic;
-- Indicates a refresh command has arrived at the command signals from MPMC

signal NxtRefCmd        : std_logic;
-- D-input for RefCmd

signal DelayRefCmd      : std_logic;
-- Delayed version of RefCmd

signal RefWidth         : std_logic_vector(2 downto 0);
-- Indicates the the status of the chip selects which are refreshed

signal NxtRefWidth      : std_logic_vector(2 downto 0);
-- D-input for RefWidth

signal RefStatus        : std_logic;
-- Indicates that the required number of refresh commands have been issued
-- during initialisation

signal NxtRefStatus     : std_logic;
-- D-input for RefStatus

signal RefCount         : std_logic_vector(3 downto 0);
-- Refresh count during initialisation

signal NxtRefCount      : std_logic_vector(3 downto 0);
-- D-input for RefCount

signal RefCycles        : std_logic_vector(15 downto 0);
-- Refresh up-counter : Counts-up till it gets a valid refresh

signal NxtRefCycles     : std_logic_vector(15 downto 0);
-- D-input for RefCycles

signal ModeRegChk       : std_logic;
-- LMR command check enable during initialisation

signal NxtModeRegChk    : std_logic;
-- D-input for ModeRegChk

signal InitChkEn        : std_logic;
-- Initialisation check enable

signal NxtInitChkEn     : std_logic;
-- D-input for InitChkEn

signal ModeRegCmd       : std_logic;
-- Indicates a LMR has arrived at the command signals from MPMC

signal NxtModeRegCmd    : std_logic;
-- D-Input to ModeRegCmd

signal ModeRegCount     : std_logic_vector(6 downto 0);
-- Number of LMRs issued

signal NxtModeRegCount  : std_logic_vector(6 downto 0);
-- D-Input to ModeRegCount

signal RefCheckEn       : std_logic;
-- Refresh check enable signal

signal NxtRefCheckEn    : std_logic;
-- D-input for RefCheckEn

signal MonitorRef       : std_logic;
-- Indicates that the protocol checker is waiting for a valid refresh command
-- within the time-out window of RefCycles

signal NxtMonitorRef    : std_logic;
-- D-input for MonitorRef

signal RefErrStat       : std_logic;
-- Indicates that either a refresh miss or refresh timing violation has
-- occurred

signal NxtRefErrStat    : std_logic;
-- D-input for RefErrStat

signal NOP              : std_logic;
-- NOP command Detect Ouptut

signal NxtNOP           : std_logic;
-- D-Input to NOP

signal ExpRefCycles     : std_logic_vector(10 downto 0);
-- Refresh cycle frequency

signal NxtExpRefCycles  : std_logic_vector(10 downto 0);
-- D-input for ExpRefCycles

signal PALL             : std_logic;
-- PALL command Detect Ouptut

signal NxtPALL          : std_logic;
-- D-Input to PALL

signal DyWrite          : std_logic;
-- Indicates dynamic write

signal NxtDyWrite       : std_logic;
-- D-input of DyWrite

signal PreCharge        : std_logic;
-- Precharge command Detect Ouptut

signal NxtPreCharge     : std_logic;
-- D-Input to PreCharge

signal ResetAssrtd      : boolean := FALSE;
-- Indicates the start of checks

signal ResetOver        : boolean := FALSE;
-- Indicates the start of checks

signal DelnMPMCDYCSOUT  : std_logic_vector(3 downto 0);
-- Delayed version of the nMPMCDYCSOUT

signal DelnMPMCSTCSOUT  : std_logic_vector(3 downto 0);
-- Delayed version of the MPMCACTLOWCS

signal iMPMCTrSR        : Std_logic_vector(8 downto 0);
-- Internal signal to MPMCTrSR

signal NxtMPMCTrSR      : std_logic_vector(8 downto 0);
-- D-input for MPMCTrSR

signal ClkDiff          : std_logic_vector(3 downto 0);
-- Signal difine the phase differences between MPMCCLK and MPMCCLKOUT

signal DelClkDiff       : std_logic_vector(3 downto 0);
-- Delayed clock diff to mask off the gate dealys glitches

signal MPMCEn           : std_logic;
-- Enable bit of MPMCTrControl Register

signal LowPower         : std_logic;
-- Low power mode bit of MPMCTrControl Register

signal ClkEn            : std_logic;
-- Synchronous memory clock enable control bit of MPMCTrDynCntl Register

signal ClkCntl          : std_logic;
-- Synchronous memory clock control bit of MPMCTrDynCntl Register

signal DisClkOut        : std_logic;
-- Disabling the MPMCCLKOUT when  DisClkOut is high

signal CkeStart         : std_logic_vector(3 downto 0);
-- Indicates the time when MPMCCKEOUT goes high after the CE bit is enabled

signal MclkStart        : std_logic;
-- Indicates the start of the MPMCCLKOUT

signal ResPwrDwn        : std_logic_vector(1 downto 0);
-- SyncFlash Reset/Power down signal bit of MPMCTrDynCntl Register

signal A10              : std_logic;
-- Addr(10) output from the memory module used to find PALL command

signal SyncFlashSel     : std_logic;
-- SYNCFLASH Select status

signal NxtSyncFlashSel  : std_logic;
-- D- input for SYNCFLASH Select status

signal RefWindow        : std_logic;
-- When it is HIGH, it is expecting a refresh command

signal RefMiss          : std_logic;
-- Refresh is missing in the refresh window

signal NxtRefMiss       : std_logic;
-- D-input for RefMiss

signal MaskedRef        : std_logic;
-- Indicates that a refresh is masked since it is a SyncFLASH

signal NxtMPMCEBIGNT    : std_logic;
-- D input of MPMCEBIGNT

signal NxtMPMCEBIBACKOFF: std_logic;
-- D input of MPMCBACKOFF

signal iMPMCEBIGNT      : std_logic;
-- Internal version of MPMCEBIGNT

signal iMPMCEBIGNT1     : std_logic;
-- Internal version of MPMCEBIGNT

signal MPMCEBIGNTQ      : std_logic;
-- Clked version of MPMCEBIGNT

signal iMPMCEBIBACKOFF  : std_logic;
-- Internal version of MPMCEBIBACKOFF

signal MPMCCKEOUTQ    : std_logic_vector(3 downto 0);
-- clocked clock enable

signal CntFlag        : std_logic;
-- Flag to indicate the end of counter

signal Cntr           : std_logic_vector(12 downto 0);
-- Counter to count the clk to generate the backoff signal

signal NxtCntr        : std_logic_vector(12 downto 0);
-- D - input of Cntr

signal iMPMCEBIBACKOFF1 : std_logic;
-- Another version of iMPMCEBIBACKOFF

signal HREADY0CNTR   : std_logic_vector(7 downto 0);
-- Internal counter for HREADY0 check

signal HREADY1CNTR   : std_logic_vector(7 downto 0);
-- Internal counter for HREADY1 check

signal NxtHREADY0CNTR   : std_logic_vector(7 downto 0);
-- D input of HREADY0CNTR

signal NxtHREADY1CNTR   : std_logic_vector(7 downto 0);
-- D input of HREADY1CNTR

signal HREADY0CNTRFlag : std_logic;
-- Flag to indicate the whether the HREADY0 is low for than specified number
-- of clocks as programmed in the HREADY0CNTR

signal HREADY1CNTRFlag : std_logic;
-- Flag to indicate the whether the HREADY1 is low for than specified number
-- of clocks as programmed in the HREADY1CNTR

signal ValidRefCmdQ   : std_logic;
-- Clocked version of ValidRefCmd

signal ValidRefCmdCo  : std_logic;
-- ORing the ValidRefCmd and ValidRefCmdQ

signal ValidRefCmdCoQ : std_logic;
-- Clock the ValidRefCmdCo

signal iMPMCTrExBkOff : std_logic_vector(12 downto 0);
-- Internal version of MPMCTrExBkOff

signal NxtPRBS        : std_logic_vector(4 downto 0);
-- D-input of PRBS

signal PRBS           : std_logic_vector(4 downto 0);
-- The random value to generate the EBI signal

signal iMPMCDLLCALIACK  : std_logic;
-- local copy of MPMCDLLCALIACK

signal RandEBIGNT       : std_logic;
-- Used to generate the EBIGNT signal

signal RandEBIBACKOFF   : std_logic;
-- Used to generate the EBIBACKOFF signal

signal TakeRegEbiSig    : std_logic;
-- Used to select the type of EBI signals

signal TakeRanEbiSig    : std_logic;
-- Used to select the type of EBI signals

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- ToInteger
-- ---------
--   This function converts the std_logic_vector input argument into integer
-- and returns the integer value.
-- -----------------------------------------------------------------------------
function ToInteger (
         val : std_logic_vector;
         x   : integer := 0
                   ) return integer is
variable return_int        : integer;
variable x_tmp             : integer;

begin
  return_int := 0;
  x_tmp := 0;
    if x /= 0 then
      x_tmp := 1;
    end if;
    for i in val'range loop
      return_int := return_int + return_int;
      case val(i) is
        when '0' =>    null;
        when '1' =>    return_int := return_int + 1;
        when others => return_int := return_int + x_tmp;
      end case;
    end loop;
  return return_int;
end ToInteger;

-- -----------------------------------------------------------------------------
--
-- Main body of Code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Generation of internal signals from register bit fields
-- -----------------------------------------------------------------------------
MPMCEn           <= MPMCTrControl(0);
LowPower         <= MPMCTrControl(2);
ClkEn            <= MPMCTrDynCntl(0) and MPMCTrControl(0) and
                    not(MPMCTrDynCntl(13));
ClkCntl          <= MPMCTrDynCntl(1) and MPMCTrControl(0);
DisClkOut        <= MPMCTrDynCntl(5);
ResPwrDwn(0)     <= MPMCTrDynCntl(14);
ResPwrDwn(1)     <= MPMCTrDynCntl(15);
A10              <= MPMCADDROUT(10);

-- -----------------------------------------------------------------------------
-- Ebi Random value generation and Ebi signals decoding
-- -----------------------------------------------------------------------------
TakeRanEbiSig    <= MPMCTrExBkOff(5) and MPMCTrExBkOff(2) and 
                    not(MPMCTrExBkOff(4));
TakeRegEbiSig    <= MPMCTrExBkOff(5) and not(MPMCTrExBkOff(2));

-- -----------------------------------------------------------------------------
-- Checks MPMCCLKOUT when DisClkOut high
-- -----------------------------------------------------------------------------
p_DisMClkComb : process (DisClkOut, MPMCCLKOUT)
begin
  if (DisClkOut = '1') then
    if (MPMCCLKOUT /= "1111") then
      assert (ProtChkMask = '1')
      report "MPMCTR54: MPMCCLKOUT is running with DMC high"
      severity Error;
    end if;
  end if;
end process p_DisMClkComb; 

-- -----------------------------------------------------------------------------
-- Allows a tolerance for the Refresh frequency
-- -----------------------------------------------------------------------------
RefWindow        <= '1' when ((ToInteger(RefCycles) >
                              ((ToInteger(ExpRefCycles)*16) -
                              ToInteger(RefTolerance))) and
                              (ToInteger(RefCycles) <
                              ((ToInteger(ExpRefCycles)*16) +
                              ToInteger(RefTolerance))))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Checks if a refresh command is missed in the refresh tolerance window
-- -----------------------------------------------------------------------------
p_WatchRefComb : process (RefWindow, ValidRefCmd, RefMiss)
begin
  if (RefWindow'event and RefWindow = '1') then
    NxtRefMiss <= '1';
  elsif (RefWindow = '1' and ValidRefCmd = '1') then
    NxtRefMiss <= '0';
  elsif (RefWindow = '0' and RefMiss = '1') then
    NxtRefMiss <= '0';
  end if;
end process p_WatchRefComb;

-- -----------------------------------------------------------------------------
-- Clock the HREADY counter
-- -----------------------------------------------------------------------------
p_HREADYChkSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    HREADY0CNTR <= "00000000";
    HREADY1CNTR <= "00000000";
  elsif (HCLK'event and HCLK = '1') then
      HREADY0CNTR <= NxtHREADY0CNTR;
      HREADY1CNTR <= NxtHREADY1CNTR;
  end if;
end process p_HREADYChkSeq;

-- -----------------------------------------------------------------------------
-- HREADY0 low counter
-- -----------------------------------------------------------------------------
p_HREADY0ChkComb : process (HREADYOutMpmc0, HREADY0CNT, HREADY0CNTR)
begin
  if ((HREADYOutMpmc0 = '1') or (HREADY0CNTR = HREADY0CNT)) then
    NxtHREADY0CNTR <= "00000000";
  else
    NxtHREADY0CNTR <= unsigned(HREADY0CNTR) + 1;
  end if;
end process p_HREADY0ChkComb;

-- -----------------------------------------------------------------------------
-- HREADY1 low counter
-- -----------------------------------------------------------------------------
p_HREADY1ChkComb : process (HREADYOutMpmc1, HREADY1CNT, HREADY1CNTR)
begin
  if ((HREADYOutMpmc1 = '1') or (HREADY1CNTR = HREADY1CNT)) then
    NxtHREADY1CNTR <= "00000000";
  else
    NxtHREADY1CNTR <= unsigned(HREADY1CNTR) + 1;
  end if;
end process p_HREADY1ChkComb;

-- -----------------------------------------------------------------------------
-- Assert HREADY0CNTRFlag when HREADY0CNTR reaches HREADY0CNT values
-- -----------------------------------------------------------------------------
HREADY0CNTRFlag <= '1' when (HREADY0CNTR = HREADY0CNT)
               else
                  '0';

-- -----------------------------------------------------------------------------
-- Assert HREADY1CNTRFlag when HREADY1CNTR reaches HREADY1CNT values
-- -----------------------------------------------------------------------------
HREADY1CNTRFlag <= '1' when (HREADY1CNTR = HREADY1CNT)
               else
                  '0';
-- -----------------------------------------------------------------------------
-- Display the error message if the HREADYOutMpmc0 is low for more than
-- specified number of clocks and HREADY0ChkEn is high
-- -----------------------------------------------------------------------------
p_HREADY0ChkDispComb : process (HREADY0CNTRFlag)
variable PrintStr         : string (1 to 255);
-- used to flash the error message during simulation
begin
  if (HREADY0CNTRFlag = '1' and HREADY0ChkEn = '1') then
    -- fprintf(PrintStr,"MPMCTR49: HREADY0 is low for more than %s clks", to_string(HREADY0CNT));
      assert (ProtChkMask = '1')
      -- report PrintStr
      report "MPMCTR49 : HREADYO is low for more than the specified number of clocks"
      severity Error;
  end if;
end process p_HREADY0ChkDispComb;

-- -----------------------------------------------------------------------------
-- Display the error message if the HREADYOutMpmc1 is low for more than
-- specified number of clocks and HREADY1ChkEn is high
-- -----------------------------------------------------------------------------
p_HREADY1ChkDispComb : process (HREADY1CNTRFlag)
variable PrintStr         : string (1 to 255);
-- used to flash the error message during simulation
begin
  if (HREADY1CNTRFlag = '1' and HREADY1ChkEn = '1') then
    -- fprintf(PrintStr,"MPMCTR50: HREADY1 is low for more than %s clks", to_string(HREADY1CNT));
      assert (ProtChkMask = '1')
      -- report PrintStr
      report "MPMCTR50 : HREADY1 is low for more than the specified number of clocks"
      severity Error;
  end if;
end process p_HREADY1ChkDispComb;
-- -----------------------------------------------------------------------------
-- Clocking in the RefMiss at HCLK
-- -----------------------------------------------------------------------------
p_RefMissSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    RefMiss <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (RefWindow = '0') then
      RefMiss <= NxtRefMiss;
    end if;
  end if;
end process p_RefMissSeq;

-- -----------------------------------------------------------------------------
-- Refresh Check Error Status
-- -----------------------------------------------------------------------------
p_RefErrStatComb : process (ExpRefCycles, ValidRefCmd,
                            MonitorRef, RefCycles, RefErrStat, MPMCTrSRWr,
                            DataSR, RefMiss, RefCheckEn)
begin
  if (MPMCTrSRWr = '1' and DataSR(8) = '0') then
    NxtRefErrStat <= '0';
  end if;
  if (ValidRefCmd = '1' and MonitorRef = '1') then
    if ((ToInteger(RefCycles) < ((ToInteger(ExpRefCycles) * 16) - 2)) or
        (ToInteger(RefCycles) > ((ToInteger(ExpRefCycles) * 16) + 2))) then
      NxtRefErrStat <= '1';
    end if;
  elsif (RefMiss = '1' and RefCheckEn = '1') then
    NxtRefErrStat <= '1';
  else
    NxtRefErrStat <= RefErrStat;
  end if;
end process p_RefErrStatComb;

-- -----------------------------------------------------------------------------
-- Clocking in Refresh check error status
-- -----------------------------------------------------------------------------
p_RefErrStatSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefErrStat <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RefErrStat <= NxtRefErrStat;
  end if;
end process p_RefErrStatSeq;

-- -----------------------------------------------------------------------------
-- Expected Refresh Cycles
-- -----------------------------------------------------------------------------
ExpRefCycles <= MPMCTrDynRfrsh;

-- -----------------------------------------------------------------------------
-- Refresh Check Enable generation logic
-- -----------------------------------------------------------------------------
NxtMonitorRef   <= '0' when (MPMCTrDynRfrshWr = '1')
                else
                   RefCheckEn when (ValidRefCmd = '1')
                else
                   MonitorRef;

-- -----------------------------------------------------------------------------
-- Clocking in Refresh Check Enable
-- -----------------------------------------------------------------------------
p_MonitorRefSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    MonitorRef <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    MonitorRef <= NxtMonitorRef;
  end if;
end process p_MonitorRefSeq;

-- -----------------------------------------------------------------------------
-- Phase Delayed Refresh Check Enable
-- -----------------------------------------------------------------------------
NxtRefCheckEn    <= DataSR(7) when (MPMCTrSRWr = '1')
                 else
                    RefCheckEn;

-- -----------------------------------------------------------------------------
-- Phase Delayed Refresh Check Enable
-- -----------------------------------------------------------------------------
p_RefCheckEnSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefCheckEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RefCheckEn <= NxtRefCheckEn;
  end if;
end process p_RefCheckEnSeq;

-- -----------------------------------------------------------------------------
-- Mode Register Command signal generation logic
-- -----------------------------------------------------------------------------
NxtModeRegCmd    <= (not(nMPMCRASOUT) and not(nMPMCCASOUT) and
                     not(nMPMCWEOUT) and not(nMPMCDYCSOUT(0) and
                     nMPMCDYCSOUT(1) and nMPMCDYCSOUT(2) and nMPMCDYCSOUT(3)));

-- -----------------------------------------------------------------------------
-- Clocking in Mode Register Command
-- -----------------------------------------------------------------------------
p_ModeRegComSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    ModeRegCmd <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    ModeRegCmd <= NxtModeRegCmd;
  end if;
end process p_ModeRegComSeq;

-- -----------------------------------------------------------------------------
-- Mode Register Command Counter generation logic
-- -----------------------------------------------------------------------------
NxtModeRegCount  <= (others => '0') when (InitChkEn = '0')
                 else
                    unsigned(ModeRegCount) + 1 when ModeRegCmd = '1'
                 else
                    ModeRegCount;

-- -----------------------------------------------------------------------------
-- Clocking in Mode Register Command Counter
-- -----------------------------------------------------------------------------
p_ModeRegCntSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    ModeRegCount <= (others => '0');
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    ModeRegCount <= NxtModeRegCount;
  end if;
end process p_ModeRegCntSeq;

-- -----------------------------------------------------------------------------
-- Mode Register Command Check signal generation logic
-- -----------------------------------------------------------------------------
p_MdeRegChkComb : process (ModeRegCount, ModeRegChk, InitChkEn)
begin
  if (InitChkEn = '0') then
    NxtModeRegChk <= '0';
  elsif ((ModeRegCount = "0000100")) then
    NxtModeRegChk <= '1';
  else
    NxtModeRegChk <= ModeRegChk;
  end if;
end process p_MdeRegChkComb;

-- -----------------------------------------------------------------------------
-- Clocking in Mode Register Command Check
-- -----------------------------------------------------------------------------
p_MdeRegChkSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    ModeRegChk <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    ModeRegChk <= NxtModeRegChk;
  end if;
end process p_MdeRegChkSeq;

-- -----------------------------------------------------------------------------
-- NOP Condition Check signal geneation logic
-- ---------------------------------------------------------------------------
NxtNOP           <= MPMCCKEOUT(0) and MPMCCKEOUT(1) and MPMCCKEOUT(2) and
                    MPMCCKEOUT(3) and not(nMPMCDYCSOUT(0)) and
                    not(nMPMCDYCSOUT(1)) and not(nMPMCDYCSOUT(2)) and
                    not(nMPMCDYCSOUT(3)) and nMPMCRASOUT and nMPMCCASOUT and
                    nMPMCWEOUT;

-- -----------------------------------------------------------------------------
-- Clocking in NOP Condition Check signal
-- -----------------------------------------------------------------------------
p_NOPSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    NOP <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    NOP <= NxtNOP;
  end if;
end process p_NOPSeq;

-- -----------------------------------------------------------------------------
-- Initialization Sequence Check StateMachine
-- -----------------------------------------------------------------------------
p_StateSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    PresentState <= "000";
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    PresentState <= NxtState;
  end if;
end process p_StateSeq;

-- -----------------------------------------------------------------------------
-- Initialization Sequence Check Status
-- -----------------------------------------------------------------------------
p_PStateComb : process (PresentState, InitSeqErrSt, ModeRegChk)
begin
  if (MPMCTrSRWr = '1' and DataSR(1) = '0') then
    NxtInitSeqErrSt <= '0';
  end if;

  if ((PresentState = "100") and ModeRegChk = '1') then
    NxtInitSeqErrSt <= '1';
  else
    NxtInitSeqErrSt <= InitSeqErrSt;
  end if;
end process p_PStateComb;

-- -----------------------------------------------------------------------------
-- Registering Initialization Sequence Check Status
-- -----------------------------------------------------------------------------
p_PStateSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    InitSeqErrSt <= '0';
  elsif (HCLK'event and HCLK = '1') then
    InitSeqErrSt <= NxtInitSeqErrSt;
   end if;
end process p_PStateSeq;

-- -----------------------------------------------------------------------------
-- SyncFlash Select status
-- -----------------------------------------------------------------------------
NxtSyncFlashSel  <= (not(nMPMCDYCSOUT(0)) and MPMCTrDynMEMT(0)) or
                    (not(nMPMCDYCSOUT(1)) and MPMCTrDynMEMT(1)) or
                    (not(nMPMCDYCSOUT(2)) and MPMCTrDynMEMT(2)) or
                    (not(nMPMCDYCSOUT(3)) and MPMCTrDynMEMT(3));

-- -----------------------------------------------------------------------------
-- Clocking in SyncFlash Select status
-- -----------------------------------------------------------------------------
p_SynFlsSelSeq : process (nReset, MPMCCLK)
begin
  if (nReset = '0') then
    SyncFlashSel <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    SyncFlashSel <= NxtSyncFlashSel;
  end if;
end process p_SynFlsSelSeq;

-- -----------------------------------------------------------------------------
--   Next State logic generation
-- -----------------------------------------------------------------------------
p_NStateComb : process (PresentState, NOP, PALL, RefStatus, NxtModeRegChk,
                        ModeRegCmd, InitChkEn, PreCharge)
begin
  NxtState <= PresentState;
  case PresentState is
    when "000" =>
      if (InitChkEn = '1') then
        NxtState <= "001";
      end if;
    when "001" =>
      if (InitChkEn = '0') then
        NxtState <= "000";
      elsif (SyncFlashSel = '1' and ModeRegCmd = '1') then
        NxtState <= "000";
      elsif (PreCharge = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR3: PreCharge Command received while NOP is expected"
        severity Error;
      elsif (PALL = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR4: PALL Command received while NOP is expected"
        severity Error;
      elsif (ModeRegCmd = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR5: MODE Command received while NOP is expected"
        severity Error;
      elsif (NOP = '1') then
        NxtState <= "010";
      end if;
    when "010" =>
      if (InitChkEn = '0') then
        NxtState <= "000";
      elsif (PALL = '1') then
        NxtState <= "011";
      elsif (ModeRegCmd = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR6: MODE Command received while PALL is expected"
        severity Error;
      end if;
    when "011" =>
      if (InitChkEn = '0') then
        NxtState <= "000";
      elsif (NOP = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR7: NOP has been issued more than once"
        severity Error;
      elsif (RefStatus = '1') then
        NxtState <= "100";
      end if;
    when "100" =>
      if (InitChkEn = '0') then
        NxtState <= "000";
      elsif (PALL = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR8: PALL has been issued more than once"
        severity Error;
      elsif (NOP = '1') then
        assert (ProtChkMask = '1')
        report " MPMCTR9: NOP has been issued more than once"
        severity Error;
      end if;
      if (NxtModeRegChk = '1') then
        NxtState <= "000";
      end if;
    when others =>
      NxtState <= "000";
  end case;
end process p_NStateComb;

-- -----------------------------------------------------------------------------
-- nReset Generation
-- -----------------------------------------------------------------------------
nReset           <= HRESETn and nPOR;

-- -----------------------------------------------------------------------------
-- InitChkEn bit generation logic
-- -----------------------------------------------------------------------------
NxtInitChkEn     <= DataSR(0) when (MPMCTrSRWr = '1')
                 else
                    '0'       when (InitSeqErrSt = '1')
                 else
                    InitChkEn;

-- -----------------------------------------------------------------------------
-- Clocking in InitChkEn bit
-- -----------------------------------------------------------------------------
p_InitChkEnSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    InitChkEn <= '0';
  elsif (HCLK'event and HCLK = '1') then
    InitChkEn <= NxtInitChkEn;
  end if;
end process p_InitChkEnSeq;

-- -----------------------------------------------------------------------------
-- Refresh Command Generation
-- -----------------------------------------------------------------------------
NxtRefCmd        <= not(nMPMCRASOUT) and not(nMPMCCASOUT) and nMPMCWEOUT and
                    MPMCCKEOUT(0) and MPMCCKEOUT(1) and MPMCCKEOUT(2) and
                    MPMCCKEOUT(3) and
                    ((nMPMCDYCSOUT(0) and nMPMCDYCSOUT(1) and
                      (nMPMCDYCSOUT(2) xor nMPMCDYCSOUT(3))) or
                     (nMPMCDYCSOUT(2) and nMPMCDYCSOUT(3) and
                      (nMPMCDYCSOUT(1) xor nMPMCDYCSOUT(0))));

-- -----------------------------------------------------------------------------
-- Clocking in Refresh Command
-- -----------------------------------------------------------------------------
p_RefCmdSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    RefCmd <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    RefCmd <= NxtRefCmd;
  end if;
end process p_RefCmdSeq;

-- -----------------------------------------------------------------------------
-- Clocking the MPMCCKEOUT
-- -----------------------------------------------------------------------------
p_CKECmdSeq : process (MPMCCLK, MPMCCKEOUT, nReset)
begin
  if (nReset = '0') then
    MPMCCKEOUTQ <= (others => '1');
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    MPMCCKEOUTQ <= MPMCCKEOUT;
  end if;
end process;

-- -----------------------------------------------------------------------------
-- Refresh Command Validity Check
-- -----------------------------------------------------------------------------
p_DelayRefCommSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    DelayRefCmd <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    DelayRefCmd <= RefCmd;
  end if;
end process p_DelayRefCommSeq;

-- -----------------------------------------------------------------------------
-- Generate refresh check mask for SyncFLASH. The Mpmc masks the refresh
-- cycles to a SyncFLASH if the chip selects are populated with SDRAMs and
-- SyncFLASHs. MaskedRef enables the refresh check mechanism to proceed even if
-- a refresh to a chip select is missed from the sequence because of being a
-- SyncFLASH.
-- -----------------------------------------------------------------------------
MaskedRef        <= '1' when (RefWidth = "001" and MPMCTrDynMEMT(1) = '1') or
                             (RefWidth = "010" and MPMCTrDynMEMT(2) = '1') or
                             (RefWidth = "011" and MPMCTrDynMEMT(3) = '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Refresh Width generation. If a SyncFLASH is connected to a chip select, it
-- skips that one and proceeds to the next.
-- -----------------------------------------------------------------------------
NxtRefWidth      <= "001" when (NxtRefCmd = '1' and nMPMCDYCSOUT(0) = '0' and
                               MPMCTrDynMEMT(0) = '0' and RefWidth = "000")
                 else
                    "010" when (NxtRefCmd = '1' and nMPMCDYCSOUT(1) = '0' and
                               ((MPMCTrDynMEMT(1) = '0' and RefWidth = "001") or
                               (MPMCTrDynMEMT(0) = '1' and RefWidth = "000")))
                 else
                    "011" when (NxtRefCmd = '1' and nMPMCDYCSOUT(2) = '0' and
                               ((MPMCTrDynMEMT(2) = '0' and RefWidth = "010") or
                               (MPMCTrDynMEMT(1) = '1' and RefWidth = "001") or
                               (MPMCTrDynMEMT(1 downto 0) = "11" and
                                RefWidth = "000")))
                 else
                    "100" when (NxtRefCmd = '1' and nMPMCDYCSOUT(3) = '0' and
                               ((MPMCTrDynMEMT(3) = '0' and RefWidth = "011") or
                               (MPMCTrDynMEMT(2) = '1' and RefWidth = "010") or
                               (MPMCTrDynMEMT(2 downto 1) = "11" and
                                RefWidth = "001") or
                               (MPMCTrDynMEMT(2 downto 0) = "111" and
                                RefWidth = "000")))
                 else
                    "000" when (RefWidth = "100") or (MPMCTrDynMEMT(3) = '1' and
                                RefWidth = "011") or
                               (MPMCTrDynMEMT(3 downto 2) = "11" and
                                RefWidth = "010") or
                               (MPMCTrDynMEMT(3 downto 1) = "111" and
                                RefWidth = "001") or
                               (MPMCTrDynMEMT(3 downto 0) = "1111")
                 else
                    RefWidth;

-- -----------------------------------------------------------------------------
-- Clocking in Refresh Width
-- -----------------------------------------------------------------------------
p_NREfWidthSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    RefWidth <= "000";
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    RefWidth <= NxtRefWidth;
  end if;
end process p_NREfWidthSeq;

-- -----------------------------------------------------------------------------
-- A valid completion of a refresh sequence. The RefWidth logic takes care of
-- the missed (SyncFLASH) refreshes.
-- -----------------------------------------------------------------------------
ValidRefCmd      <= '1' when ((RefCmd = '0') and
                              (DelayRefCmd = '1') and (RefWidth = "000"))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Refresh request validity check
-- -----------------------------------------------------------------------------
p_ValRefReqSeq : process (MPMCCLK)
begin

  if ((MPMCCLK'event and MPMCCLK = '1' and RefCmd = '0' and
      DelayRefCmd = '1' and ValidRefCmd = '0' and MaskedRef = '0') or
      ((RefMiss = '1') and (RefCheckEn = '1'))) then
    assert (ProtChkMask = '1')
    report "MPMCTR10: Not Valid Refresh Request"
    severity Warning;
  end if;
end process p_ValRefReqSeq;

-- -----------------------------------------------------------------------------
-- Refresh Command Counter : Enabled only when InitChkEn bit is On.
-- -----------------------------------------------------------------------------
NxtRefCount      <= (others => '0')          when (PresentState /= "011")
                 else
                    (unsigned(RefCount) + 1) when (ValidRefCmd = '1')
                 else
                    RefCount;

-- -----------------------------------------------------------------------------
-- Updating Refresh Command Counter
-- -----------------------------------------------------------------------------
p_RefCountSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    RefCount <= (others => '0');
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    RefCount <= NxtRefCount;
  end if;
end process p_RefCountSeq;

-- -----------------------------------------------------------------------------
-- No of Refresh Command Check
-- -----------------------------------------------------------------------------
p_NRefStateComb : process (RefCount, RefStatus, PresentState)
begin
  if (PresentState = "011") then
    if (RefCount = MPMCTrExpRef) then
      NxtRefStatus <= '1';
    else
      NxtRefStatus <= '0';
    end if;
  elsif (PresentState /= "011") then
    NxtRefStatus <= '0';
  else
    NxtRefStatus <= RefStatus;
  end if;
end process p_NRefStateComb;

-- -----------------------------------------------------------------------------
-- Clocking in RefStatus
-- -----------------------------------------------------------------------------
p_NRefStateSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    RefStatus <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    RefStatus <= NxtRefStatus;
  end if;
end process p_NRefStateSeq;

-- -----------------------------------------------------------------------------
-- Clocking the ValidRefCmd
-- -----------------------------------------------------------------------------
p_ValidRefSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    ValidRefCmdQ <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    ValidRefCmdQ <= ValidRefCmd;
  end if;
end process p_ValidRefSeq;

ValidRefCmdCo <= ValidRefCmdQ or ValidRefCmd;

-- -----------------------------------------------------------------------------
-- Clock the ValidRefCmdCo
-- -----------------------------------------------------------------------------
p_ValidRefCoSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    ValidRefCmdCoQ <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ValidRefCmdCoQ <= ValidRefCmdCo;
  end if;
end process p_ValidRefCoSeq;

-- -----------------------------------------------------------------------------
-- No of Cycles between two Refresh Command
-- -----------------------------------------------------------------------------
p_RefCycComb : process (ValidRefCmdCoQ, RefCycles)
begin
  if (ValidRefCmdCoQ = '1') then
    NxtRefCycles <= (others => '0');
  else
    NxtRefCycles <= unsigned(RefCycles) + 1;
  end if;
end process p_RefCycComb;

-- -----------------------------------------------------------------------------
-- Refresh cycles interval counter updation
-- -----------------------------------------------------------------------------
p_RefCycSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    RefCycles <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RefCycles <= NxtRefCycles;
  end if;
end process p_RefCycSeq;

-- -----------------------------------------------------------------------------
-- PALL Check
-- -----------------------------------------------------------------------------
NxtPALL          <= not(nMPMCRASOUT) and nMPMCCASOUT and not(nMPMCWEOUT) and
                    A10;

-- -----------------------------------------------------------------------------
-- Dynamic write check
-- -----------------------------------------------------------------------------
NxtDyWrite       <= nMPMCRASOUT and not(nMPMCCASOUT) and not(nMPMCWEOUT);

-- -----------------------------------------------------------------------------
-- Clocking in PALL Command
-- -----------------------------------------------------------------------------
p_PALLSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    PALL <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    PALL <= NxtPALL;
  end if;
end process p_PALLSeq;

-- -----------------------------------------------------------------------------
-- Clocking in DyWrite Command
-- -----------------------------------------------------------------------------
p_DyWriteSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    DyWrite <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    DyWrite <= NxtDyWrite;
  end if;
end process p_DyWriteSeq;

-- -----------------------------------------------------------------------------
-- PreCharge Check
-- -----------------------------------------------------------------------------
NxtPreCharge     <= not(nMPMCRASOUT) and nMPMCCASOUT and not(nMPMCWEOUT) and
                    not(A10) and MPMCCKEOUTQ(3) and MPMCCKEOUTQ(2) and
                    MPMCCKEOUTQ(1) and MPMCCKEOUTQ(0);

-- -----------------------------------------------------------------------------
-- Clocking in PreCharge Command
-- -----------------------------------------------------------------------------
p_PreChargeSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    PreCharge <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    PreCharge <= NxtPreCharge;
  end if;
end process p_PreChargeSeq;

-- -----------------------------------------------------------------------------
-- SREF Check
-- -----------------------------------------------------------------------------
NxtSREF          <= (not(nMPMCRASOUT) and not(nMPMCCASOUT) and nMPMCWEOUT) and
                    (((MPMCCKEOUT(3) and MPMCCKEOUT(2) and MPMCCKEOUT(1) and 
                    not(MPMCCKEOUT(0))) and not(nMPMCDYCSOUT(0))) or
                    ((MPMCCKEOUT(3) and MPMCCKEOUT(2) and not(MPMCCKEOUT(1)) and
                    not(MPMCCKEOUT(0))) and not(nMPMCDYCSOUT(1))) or
                    ((MPMCCKEOUT(3) and not(MPMCCKEOUT(2)) and 
                    not(MPMCCKEOUT(1)) and not(MPMCCKEOUT(0))) and 
                    not(nMPMCDYCSOUT(2))) or
                    ((not(MPMCCKEOUT(3)) and not(MPMCCKEOUT(2)) and
                    not(MPMCCKEOUT(1)) and not(MPMCCKEOUT(0))) and 
                    not(nMPMCDYCSOUT(3))));
                   
-- -----------------------------------------------------------------------------
-- Clocking in SREF command
-- -----------------------------------------------------------------------------
p_SREFSeq : process (MPMCCLK, nReset)
begin
  if (nReset = '0') then
    SREF <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    SREF <= NxtSREF;
  end if;
end process p_SREFSeq;

-- -----------------------------------------------------------------------------
-- Data Register
-- -----------------------------------------------------------------------------
NxtMPMCTrSR      <= RefErrStat & MonitorRef & MPMCCKEOUT &
                    SREF & InitSeqErrSt & InitChkEn;

-- -----------------------------------------------------------------------------
-- Clocking out Data Register
-- -----------------------------------------------------------------------------
p_MPMCTrSRSeq : process (HCLK, nReset)
begin
  if (nReset = '0') then
    MPMCTrSR <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    MPMCTrSR <= NxtMPMCTrSR;
  end if;
end process p_MPMCTrSRSeq;

-- -----------------------------------------------------------------------------
-- Generate Delayed nMPMCSTCSOUT
-- -----------------------------------------------------------------------------
DelnMPMCSTCSOUT  <= MPMCACTLOWCS after 2 ns;
DelnMPMCDYCSOUT  <= nMPMCDYCSOUT after 2 ns;

-- -----------------------------------------------------------------------------
-- Check for multiple Static Chip Select assertion
-- -----------------------------------------------------------------------------
p_MSChipSelComb : process (DelnMPMCSTCSOUT)
begin
  if (ResetOver) then
    if (DelnMPMCSTCSOUT = MPMCACTLOWCS) then
      for i in 3 downto 1 loop
        if (MPMCACTLOWCS(i) = '0') then
          for j in i-1 downto 0 loop
            if (MPMCACTLOWCS(j) = '0') then
              assert (ProtChkMask = '1')
                report "MPMCTR11: Multiple Static Memory Chip Selects" &
                       " are asserted simultaneously"
                severity warning;
              exit;
            end if;
          end loop;
          exit;
        end if;
      end loop;
    end if;
  end if;
end process p_MSChipSelComb;

-- -----------------------------------------------------------------------------
-- Check for multiple Dynamic Chip Select assertion
-- -----------------------------------------------------------------------------
p_MDChipSelComb : process (DelnMPMCDYCSOUT)
begin
  if (ResetOver) then
    if ((DelnMPMCDYCSOUT = nMPMCDYCSOUT) and (NxtPALL = '0')) then
      for i in 3 downto 1 loop
        if (nMPMCDYCSOUT(i) = '0') then
          for j in i-1 downto 0 loop
            if (nMPMCDYCSOUT(j) = '0') then
              assert ((ProtChkMask = '1') or (InitChkEn = '1'))
                report "MPMCTR12: Multiple Dynamic Memory Chip Selects" &
                       " are asserted simultaneously"
                severity warning;
              exit;
            end if;
          end loop;
          exit;
        end if;
      end loop;
    end if;
  end if;
end process p_MDChipSelComb;

-- -----------------------------------------------------------------------------
-- StartCheck signal is set once the Reset is applied
-- -----------------------------------------------------------------------------
p_ResetOverComb : process (HCLK, HRESETn, ResetAssrtd)
begin
  if ((ResetAssrtd) and HRESETn = '1') then
    ResetOver <= TRUE;
  end if;
  if (HCLK'event and HCLK = '1') then
    if (HRESETn = '0') then
      ResetAssrtd <= TRUE;
    end if;
  end if;
end process p_ResetOverComb;

-- -----------------------------------------------------------------------------
-- 'X' check on MPMC related signal.
-- -----------------------------------------------------------------------------
p_XCheckComb : process (ResetOver, MPMCDATAOUT, MPMCADDROUT, nMPMCSTCSOUT,
                        nMPMCDATAEN, nMPMCWEOUT, MPMCDQMOUT, nMPMCOEOUT,
                        nMPMCDYCSOUT, MPMCCKEOUT, MPMCCLKOUT, nMPMCRASOUT,
                        nMPMCCASOUT)
begin
  if (ResetOver) then
    if (Is_X(MPMCDATAOUT)) then
      assert false
      report "MPMCTR13: X(es) found in MPMCDATAOUT"
      severity warning;
    end if;

    if (Is_X(MPMCADDROUT)) then
      assert false
      report "MPMCTR14: MPMCTB2: X(es) found in MPMCADDROUT"
      severity warning;
    end if;

    if (Is_X(nMPMCSTCSOUT)) then
      assert false
      report "MPMCTR15: X(es) found in nMPMCSTCSOUT"
      severity warning;
    end if;

    if (Is_X(nMPMCDYCSOUT)) then
      assert false
      report "MPMCTR16: X(es) found in nMPMCDYCSOUT"
      severity warning;
    end if;

    if (Is_X(nMPMCDATAEN)) then
      assert false
      report "MPMCTR17: X(es) found in nMPMCDATAEN"
      severity warning;
    end if;

    if (Is_X(nMPMCWEOUT)) then
      assert false
      report "MPMCTR18: X found in nMPMCWEOUT"
      severity warning;
    end if;

    if (Is_X(MPMCDQMOUT)) then
      assert false
      report "MPMCTR19: X(es) found in MPMCDQMOUT"
      severity warning;
    end if;

    if (Is_X(nMPMCOEOUT)) then
      assert false
      report "MPMCTR20: X found in nMPMCOEOUT"
      severity warning;
    end if;

    if (Is_X(MPMCCLKOUT)) then
      assert false
      report "MPMCTR21: X found in MPMCCLKOUT"
      severity warning;
    end if;

    if (Is_X(MPMCCKEOUT)) then
      assert false
      report "MPMCTR22: X(es) found in MPMCCKEOUT"
      severity warning;
    end if;

    if (Is_X(nMPMCRASOUT)) then
      assert false
      report "MPMCTR23: X found in nMPMCRASOUT"
      severity warning;
    end if;

    if (Is_X(nMPMCCASOUT)) then
      assert false
      report "MPMCTR24: X found in nMPMCCASOUT"
      severity warning;
    end if;

    if (Is_X(MPMCSREFACK)) then
      assert false
      report "MPMCTR25: X found in MPMCSREFACK"
      severity warning;
    end if;

  end if;
end process p_XCheckComb;

-- -----------------------------------------------------------------------------
-- Generation of ClkDiff
-- -----------------------------------------------------------------------------
ClkDiff(0)       <= MPMCCLKOUT(0) xor MPMCCLK;
ClkDiff(1)       <= MPMCCLKOUT(1) xor MPMCCLK;
ClkDiff(2)       <= MPMCCLKOUT(2) xor MPMCCLK;
ClkDiff(3)       <= MPMCCLKOUT(3) xor MPMCCLK;

DelClkDiff       <= ClkDiff after 1 ns;

p_MClkSeq : process (nPOR, MPMCCLK)
begin
  if (nPOR = '0') then
    MclkStart <= '1';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    if (ClkCntl = '1' and nMPMCDYCSOUT /= "1111") then
      MclkStart <= '1';
      assert (DelClkDiff = "0000")
        report "MPMCTR1: MPMCCLKOUT should start running prior to the command"
        severity Error;
    elsif (ClkCntl = '0') then
      MclkStart <= '0';
    end if;
  end if;
end process p_MClkSeq;

p_CkeStrtSeq : process (nPOR, MPMCCLK)
begin
  if (nPOR = '0') then
    CkeStart <= "1111";
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    if (ClkEn = '1' and nMPMCDYCSOUT /= "1111") then
      CkeStart <= not(nMPMCDYCSOUT);
      assert ((not(nMPMCDYCSOUT) and MPMCCKEOUT) = not(nMPMCDYCSOUT))
        report "MPMCTR2: MPMCCKEOUT should be issued prior to the command"
        severity Error;
    elsif (ClkEn = '0') then
      CkeStart <= "0000";
    end if;
  end if;
end process p_CkeStrtSeq;

-- -----------------------------------------------------------------------------
-- MPMC Enable/Disable check
-- -----------------------------------------------------------------------------
p_MPMCEnChkComb : process (MPMCCLK)
begin
  if (MPMCCLK'event and MPMCCLK = '1') then
    if ((ResetOver) and (MPMCEn = '0')) then
      if (ValidRefCmd = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR26: Refresh has been issued while MPMC is in disabled mode"
        severity Error;
      end if;
  
      if (MPMCDQMOUT /= "1111") then
        assert (ProtChkMask = '1')
        report "MPMCTR27: MPMCDQMOUT signals are active during disabled mode"
        severity Error;
      end if;
  
      if (nMPMCOEOUT /= '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR28: nMPMCOEOUT is active during disabled mode"
        severity Error;
      end if;
  
      if (nMPMCDATAEN /= "1111") then
        assert (ProtChkMask = '1')
        report "MPMCTR29: nMPMCDATAEN signals are active during disabled mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (nMPMCWEOUT /= '1')) then
        assert (ProtChkMask = '1')
        report "MPMCTR30: nMPMCWEOUT is active during disabled mode"
        severity Error;
      end if;
  
      if ((DelnMPMCSTCSOUT = MPMCACTLOWCS) and (MPMCACTLOWCS /= "1111")) then
        assert (ProtChkMask = '1')
        report "MPMCTR31: nMPMCSTCSOUT signals are active during disabled mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (NxtRefCmd = '0') and
          (nMPMCDYCSOUT /= "1111")) then
        assert (ProtChkMask = '1')
        report "MPMCTR32: nMPMCDYCSOUT signals are active during disabled mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (NxtRefCmd = '0') and (nMPMCCASOUT /= '1')) then
        assert (ProtChkMask = '1')
        report "MPMCTR33: nMPMCCASOUT is active during disabled mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (NxtRefCmd = '0') and (nMPMCRASOUT /= '1')) then
        assert (ProtChkMask = '1')
        report "MPMCTR34: nMPMCRASOUT is active during disabled mode"
        severity Error;
      end if;
    end if;
  end if;
end process p_MPMCEnChkComb;

-- -----------------------------------------------------------------------------
-- MPMC Low power mode check
-- -----------------------------------------------------------------------------
p_LowPwrChkComb : process (MPMCCLK)
begin
  if (MPMCCLK'event and MPMCCLK = '1') then
    if ((ResetOver) and (LowPower = '1')) then
      if (MPMCDQMOUT /= "1111") then
        assert (ProtChkMask = '1')
        report "MPMCTR35: MPMCDQMOUT signals are active during Low power mode"
        severity Error;
      end if;
  
      if (nMPMCOEOUT /= '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR36: nMPMCOEOUT is active during Low power mode"
        severity Error;
      end if;
  
      if (nMPMCDATAEN /= "1111") then
        assert (ProtChkMask = '1')
        report "MPMCTR37: nMPMCDATAEN signals are active during Low power mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (nMPMCWEOUT /= '1')) then
        assert (ProtChkMask = '1')
        report "MPMCTR38: nMPMCWEOUT is active during Low power mode"
        severity Error;
      end if;
  
      if (MPMCACTLOWCS /= "1111") then
        assert (ProtChkMask = '1')
        report "MPMCTR39: nMPMCSTCSOUT signals are active during Low power mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (NxtRefCmd = '0') and
          (nMPMCDYCSOUT /= "1111")) then
        assert (ProtChkMask = '1')
        report "MPMCTR40: nMPMCDYCSOUT signals are active during Low power mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (NxtRefCmd = '0') and (nMPMCCASOUT /= '1')) then
        assert (ProtChkMask = '1')
        report "MPMCTR41: nMPMCCASOUT is active during Low power mode"
        severity Error;
      end if;
  
      if ((NxtPALL = '0') and (NxtRefCmd = '0') and (nMPMCRASOUT /= '1')) then
        assert (ProtChkMask = '1')
        report "MPMCTR42: nMPMCRASOUT is active during Low power mode"
        severity Error;
      end if;
    end if;
  end if;
end process p_LowPwrChkComb;

-- -----------------------------------------------------------------------------
-- MPMC Clock Enable/Disable check
-- -----------------------------------------------------------------------------
p_SyCntlchkComb : process (MPMCCKEOUT, ClkEn, CkeStart, MclkStart, ClkDiff,
                           ResetOver, DelClkDiff)
begin
  if (ResetOver) then
    if (ClkEn = '1') then
      if ((CkeStart and MPMCCKEOUT) /= CkeStart) then
        assert (ProtChkMask = '1')
        report "MPMCTR43: MPMCCKEOUT signal(s) are disable while 'CE' " &
               "bit is set"
        severity Error;
      end if;
    end if;
  
    if (MclkStart = '1') then
      if (DelClkDiff(0) /= '0') then
        assert (ProtChkMask = '1')
        report "MPMCTR44: MPMCLKOUT0 is not running continuously " &
               "while 'CS' bit is set"
        severity Error;
      end if;
  
      if (DelClkDiff(1) /= '0') then
        assert (ProtChkMask = '1')
        report "MPMCTR45: MPMCLKOUT1 is not running continuously " &
               "while 'CS' bit is set"
        severity Error;
      end if;
  
      if (DelClkDiff(2) /= '0') then
        assert (ProtChkMask = '1')
        report "MPMCTR46: MPMCLKOUT2 is not running continuously " &
               "while 'CS' bit is set"
        severity Error;
      end if;
  
      if (DelClkDiff(3) /= '0') then
        assert (ProtChkMask = '1')
        report "MPMCTR47: MPMCLKOUT3 is not running continuously " &
               "while 'CS' bit is set"
        severity Error;
      end if;
    end if;
  end if;
end process p_SyCntlchkComb;

-- -----------------------------------------------------------------------------
-- Reset/Power down pin status check
-- -----------------------------------------------------------------------------
p_ResPwrDwnSeq : process (MPMCCLK)
begin
  if (ResetOver) then
    if (ResPwrDwn /= (MPMCRPVHHOUT & nMPMCRPOUT)) then
      assert (ProtChkMask = '1')
      report "MPMCTR48: The Reset/Power down signals do not follow 'RP' bit"
      severity Error;
    end if;
  end if;
end process p_ResPwrDwnSeq;

-- -----------------------------------------------------------------------------
-- Check for the write protect in case of SDRAM
-- -----------------------------------------------------------------------------
p_DyWrPrChk : process (MPMCTrWrPrStat,DyWrite, nMPMCDYCSOUT)
begin
  for i in 0 to 3 loop
    if (MPMCTrWrPrStat(i) = '1' and (nMPMCDYCSOUT(i) = '0')) then
      if (DyWrite = '1') then
        assert (ProtChkMask = '1')
        report "MPMCTR53: Write operation initiated for the write protected chip"
        severity Error;
        exit;
      end if;   
    end if;
  end loop;
end process p_DyWrPrChk;
-- -----------------------------------------------------------------------------
-- EBIGNT generator
-- -----------------------------------------------------------------------------
p_EbiGntGenComb : process (MPMCEBIREQ, TakeRegEbiSig, TakeRanEbiSig,
                           MPMCTrExBkOff, RandEBIGNT)
begin
  if (TakeRegEbiSig = '1') then
    NxtMPMCEBIGNT <= MPMCTrExBkOff(1);
  elsif (TakeRanEbiSig = '1') then
    NxtMPMCEBIGNT <= RandEBIGNT;
  elsif (MPMCEBIREQ = '1') then
    NxtMPMCEBIGNT <= '1';
  else
    NxtMPMCEBIGNT <= '0';
  end if;
end process p_EbiGntGenComb;

-- -----------------------------------------------------------------------------
-- Increase the backoff counter value
-- -----------------------------------------------------------------------------
p_BackOffCntComb : process (MPMCEBIREQ)
begin
  if (MPMCTrExBkOff /= "111111") then
    iMPMCTrExBkOff <= "0000000" & MPMCTrExBkOff;
  else
    iMPMCTrExBkOff <= (others => '1');
  end if;
end process p_BackOffCntComb;
-- -----------------------------------------------------------------------------
-- Generating the EBIBACKOFF signal
-- -----------------------------------------------------------------------------

p_BACKOFFCNTR : process (iMPMCEBIGNT, CntFlag, Cntr, MPMCTrExBkOff)
begin 
  NxtCntr <= Cntr;
  if (iMPMCEBIGNT = '0') then
    NxtCntr <= iMPMCTrExBkOff;
  elsif (CntFlag /= '1') then
    NxtCntr <= unsigned(Cntr) - 1;
  end if;
end process p_BACKOFFCNTR;

-- -----------------------------------------------------------------------------
-- Counter which assists to raise the BackOff signal
-- -----------------------------------------------------------------------------

p_CNTRSeq : process (HCLK, HRESETn)
begin 
  if (HRESETn = '0') then
    Cntr <= "1111111111111";
  elsif (HCLK'event and HCLK = '1') then
    Cntr <= NxtCntr;
  end if;
end process p_CNTRSeq;

-- -----------------------------------------------------------------------------
-- Flag to indicate the assertion of the BackOff signal
-- -----------------------------------------------------------------------------
CntFlag <= '1' when (Cntr = "0000000000000") 
        else
           '0';
iMPMCEBIGNT1     <= iMPMCEBIGNT;
-- -----------------------------------------------------------------------------
-- Clocking the GNT signal
-- -----------------------------------------------------------------------------
p_GntSeq : process (HCLK, HRESETn, iMPMCEBIGNT1)
begin
  if (HRESETn = '0') then
    MPMCEBIGNTQ <= '0';
  elsif (HCLK'event and HCLK = '1') then
    MPMCEBIGNTQ <= iMPMCEBIGNT1;
  end if;
end process p_GntSeq;

-- -----------------------------------------------------------------------------
-- Assertion of BackOff signal
-- -----------------------------------------------------------------------------
p_BackOffGen : process (nPOR,CntFlag, iMPMCEBIGNT, MPMCEBIGNTQ,
                        iMPMCEBIBACKOFF, MPMCTrExBkOff, RandEBIBACKOFF,
                        TakeRegEbiSig, TakeRanEbiSig)
begin
  NxtMPMCEBIBACKOFF <= iMPMCEBIBACKOFF;
  if (nPOR = '0') then
    NxtMPMCEBIBACKOFF <= '0';
  elsif (TakeRegEbiSig = '1') then
    NxtMPMCEBIBACKOFF <= not(MPMCTrExBkOff(0));
  elsif (TakeRanEbiSig = '1') then
    NxtMPMCEBIBACKOFF <= RandEBIBACKOFF;
  elsif (iMPMCEBIGNT = '0') then
    NxtMPMCEBIBACKOFF <= '0';
  elsif (CntFlag = '1' and MPMCEBIGNTQ = '1') then
    NxtMPMCEBIBACKOFF <= '1';
  end if;
end process p_BackOffGen;

-- -----------------------------------------------------------------------------
-- Clking the GNT and BackOff signal
-- -----------------------------------------------------------------------------
p_EbiGntSeq : process(nPOR, MPMCCLK, NxtMPMCEBIGNT, NxtMPMCEBIBACKOFF)
begin
  if (nPOR = '0') then
    iMPMCEBIGNT     <= '1';
    iMPMCEBIBACKOFF <= '0';
  elsif (MPMCCLK'event and MPMCCLK = '1') then
    iMPMCEBIGNT     <= NxtMPMCEBIGNT;
    iMPMCEBIBACKOFF <= NxtMPMCEBIBACKOFF;
  end if;
end process p_EbiGntSeq;
  
-- -----------------------------------------------------------------------------
-- Random number generation
-- -----------------------------------------------------------------------------
p_PRBSComb : process (PRBS)
begin
  NxtPRBS(0) <= PRBS(1);
  NxtPRBS(1) <= PRBS(2);
  NxtPRBS(2) <= PRBS(3);
  NxtPRBS(3) <= PRBS(4);
  NxtPRBS(4) <= not(PRBS(4) xor PRBS(1));
end process p_PRBSComb;

-- -----------------------------------------------------------------------------
-- Sequence process for PRBS
-- -----------------------------------------------------------------------------
p_PRBSSeq : process (HCLK, nPOR)
begin
  if (nPOR = '0') then
    PRBS <= "00000";
  elsif (HCLK'event and HCLK = '1') then
    PRBS <= NxtPRBS;
  end if;
end process p_PRBSSeq;

-- -----------------------------------------------------------------------------
-- Random EBI Grant signals generation
-- -----------------------------------------------------------------------------
p_GntRandComb : process
begin
  wait on MPMCEBIREQ;
  if (MPMCEBIREQ = '1') then
    wait for Tclk * ToInteger(PRBS);
      RandEBIGNT <= MPMCEBIREQ;
  else
      RandEBIGNT <= '0';
  end if;
end process p_GntRandComb;

-- -----------------------------------------------------------------------------
-- Random EBIBACKOFF signals generation
-- -----------------------------------------------------------------------------
p_BackRandComb : process
begin
  wait on NxtMPMCEBIGNT;
  if (NxtMPMCEBIGNT = '1') then
    wait for Tclk * ToInteger(PRBS);
      RandEBIBACKOFF <= NxtMPMCEBIGNT;
  else
      RandEBIBACKOFF <= '0';
  end if;
end process p_BackRandComb;

-- -----------------------------------------------------------------------------
-- Assign Local copy
-- -----------------------------------------------------------------------------
MPMCEBIGNT       <= iMPMCEBIGNT;

MPMCEBIBACKOFF   <= iMPMCEBIBACKOFF when ((TakeRegEbiSig = '1'))
               else
                    iMPMCEBIBACKOFF and iMPMCEBIGNT;

end behavioural;

-- --================================== End ==================================--
