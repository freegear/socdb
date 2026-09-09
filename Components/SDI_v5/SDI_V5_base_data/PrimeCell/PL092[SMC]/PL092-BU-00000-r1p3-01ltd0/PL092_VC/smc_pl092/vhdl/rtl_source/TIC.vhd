-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : TIC.vhd.rca
-- File Revision          : 1.23
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test Interface Controller (TIC) for the AMBA system.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------
entity TIC is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB Bus Reset Signal
        HREADYIN         : in    std_logic; -- Multiplexed HREADYIN input
                                            -- from all slaves
        HRESPTIC         : in    std_logic_vector(1 downto 0);
                                            -- AHB Bus Transfer
                                            -- Response to TIC
        HGRANTTIC        : in    std_logic; -- AHB Bus Grant
        HRDATATIC        : in    std_logic_vector(31 downto 0);
                                            -- AHB Read Data Input
                                            -- to TIC
        TBUSIN           : in    std_logic_vector(31 downto 0);
                                            -- External test vector
                                            -- input data bus
        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B
        TICBUSGNT        : in    std_logic; -- Bus grant signal by the DBI
                                            -- to the TIC

-- Outputs
        HADDRTIC         : out   std_logic_vector(31 downto 0);
                                            -- AHB Address output from TIC
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
                                            -- AHB Transfer type output
                                            -- from TIC
        HWRITETIC        : out   std_logic; -- AHB Transfer Direction output
                                            -- from TIC
        HSIZETIC         : out   std_logic_vector(2 downto 0);
                                            -- AHB Transfer Size output
                                            -- from TIC
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
                                            -- AHB Burst Type output
                                            -- from TIC
        HPROTTIC         : out   std_logic_vector(3 downto 0);
                                            -- AHB Protection control signal
        HWDATATIC        : out   std_logic_vector(31 downto 0);
                                            -- AHB Write Data output
                                            -- from TIC
        HBUSREQTIC       : out   std_logic; -- AHB Bus Request
        HLOCKTIC         : out   std_logic; -- AHB signal indicating Locked
                                            -- access to the Bus
        TBUSOUT          : out   std_logic_vector(31 downto 0);
                                            -- External test vector
                                            -- output data bus
        TESTACK          : out   std_logic; -- Test acknowledge
        TICBUSREQ        : out   std_logic; -- TIC bus request to DBI
        TICREAD          : out   std_logic  -- Drive AHB read data onto TBUSOUT
       );
end TIC;

-- -----------------------------------------------------------------------------
--
--                                     TIC
--                                     ===
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- The TIC is a state machine that provides an AMBA bus master for system test.
-- It controls the External Test Bus and AHB data buses HRDATATIC and HWDATATIC
-- during the application of Test Interface Format (TIF)test vectors.
--
-- The TIC consists of three main blocks:
--
-- Test Vector State Machine - Uses the TESTREQA and TESTREQB signals to
-- decide which type of vector is being applied on the external TESTBUS.
--
-- Address and Control Registers - Holds values for the address and control
-- signals and includes an address incrementer for burst accesses.
--
-- AMBA Bus Master Interface - Includes the AMBA bus master state machine and
-- the control of the AMBA bus signals.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of TIC is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- State encoding of the granted state machine
-- -----------------------------------------------------------------------------
constant STG_NOT_GRANT    : std_logic_vector(1 downto 0) := "00";
--

constant STG_GAIN_GRANT   : std_logic_vector(1 downto 0) := "01";
--

constant STG_GRANT        : std_logic_vector(1 downto 0) := "11";
--

constant STG_LOSE_GRANT   : std_logic_vector(1 downto 0) := "10";
--

-- -----------------------------------------------------------------------------
-- State encoding of the TIC vector state machine
-- -----------------------------------------------------------------------------
constant STV_IDLE         : std_logic_vector(2 downto 0) := "000";
--

constant STV_START        : std_logic_vector(2 downto 0) := "001";
--

constant STV_ADDRVEC      : std_logic_vector(2 downto 0) := "010";
--

constant STV_WRITEVEC     : std_logic_vector(2 downto 0) := "011";
--

constant STV_READVEC      : std_logic_vector(2 downto 0) := "100";
--

constant STV_LASTREAD     : std_logic_vector(2 downto 0) := "101";
--

constant STV_TURNAROUND   : std_logic_vector(2 downto 0) := "110";
--

-- -----------------------------------------------------------------------------
-- HTRANSTIC transfer type signal encoding
-- -----------------------------------------------------------------------------
constant TRN_IDLE         : std_logic_vector(1 downto 0) := "00";
--

constant TRN_BUSY         : std_logic_vector(1 downto 0) := "01";
--

constant TRN_NONSEQ       : std_logic_vector(1 downto 0) := "10";
--

constant TRN_SEQ          : std_logic_vector(1 downto 0) := "11";
--

-- -----------------------------------------------------------------------------
-- HSIZETIC transfer type signal encoding
-- -----------------------------------------------------------------------------
constant SZ_BYTE          : std_logic_vector(1 downto 0) := "00";
--

constant SZ_HALF          : std_logic_vector(1 downto 0) := "01";
--

constant SZ_WORD          : std_logic_vector(1 downto 0) := "10";
--

-- -----------------------------------------------------------------------------
-- HRESPTIC transfer response signal encoding
-- -----------------------------------------------------------------------------
constant RSP_OKAY         : std_logic_vector(1 downto 0) := "00";
--

constant RSP_ERROR        : std_logic_vector(1 downto 0) := "01";
--

constant RSP_RETRY        : std_logic_vector(1 downto 0) := "10";
--

constant RSP_SPLIT        : std_logic_vector(1 downto 0) := "11";
--

-- -----------------------------------------------------------------------------
-- Constant for Logic '0'
-- -----------------------------------------------------------------------------
constant LOGIC_ZERO       : std_logic := '0';

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal NextGrant        : std_logic_vector(1 downto 0);
-- Granted state machine

signal CurrentGrant     : std_logic_vector(1 downto 0);
--

signal AddrDrive        : std_logic;
-- Address bus drive enable output

signal DataDrive        : std_logic;
-- Data bus drive enable output

signal iTESTACK         : std_logic;
-- Internal TESTACK output

signal SyncTestReqA     : std_logic;
-- Synchronised TESTREQA input

signal NextVect         : std_logic_vector(2 downto 0);
-- TIC vector state

signal CurrentVect      : std_logic_vector(2 downto 0);
-- machine

signal LastVect         : std_logic_vector(2 downto 0);
--

signal IncAddr          : std_logic_vector(31 downto 0);
-- Incremented address

signal HaddrMux         : std_logic_vector(31 downto 0);
-- HADDRTIC reg input mux

signal HaddrEn          : std_logic;
-- HADDRTIC reg enable

signal iHADDRTIC        : std_logic_vector(31 downto 0);
-- Internal HADDRTIC reg

signal HaddrPrev        : std_logic_vector(9 downto 0);
-- Previous HADDRTIC value

signal Bound            : std_logic;
-- Detects an incremented address boundary

signal BoundReg         : std_logic;
-- Registered Bound

signal ControlVect      : std_logic;
-- Detects a control vector being applied

signal ControlSel       : std_logic;
-- Selected control vector

signal Incrm            : std_logic;
-- Incremental control vector setting

signal IncrmReg         : std_logic;
-- Registered Incrm

signal HprotGen         : std_logic_vector(3 downto 0);
-- Prot control vect set

signal iHPROTTIC        : std_logic_vector(3 downto 0);
-- Registered HprotGen

signal HlockGen         : std_logic;
-- Lock control vector setting

signal iHLOCK           : std_logic;
-- Registered iHLOCK

signal HSizeGen         : std_logic_vector(1 downto 0);
-- Size control vect set

signal HSizeInt         : std_logic_vector(1 downto 0);
-- Registered HSizeGen

signal iHSIZETIC        : std_logic_vector(1 downto 0);
-- Int version of output

signal SRNext           : std_logic;
-- Input to SplitRetry register

signal SplitRetry       : std_logic;
-- Indicates a split/retry cycle

signal SR1              : std_logic;
-- High during first split/retry cycle

signal SR2              : std_logic;
-- High during second split/retry cycle

signal iHTRANSTIC       : std_logic_vector(1 downto 0);
-- Int version of output

signal Vect             : std_logic_vector(2 downto 0);
-- Muxed vector state

signal iHWRITETIC       : std_logic;
-- Internal HWRITETIC output

signal HwdataEn         : std_logic;
-- HWDATATIC register enable

signal iHWDATATIC       : std_logic_vector(31 downto 0);
-- HWDATATIC register

signal iHBUSREQTIC      : std_logic;
-- Internal version of HBUSREQTIC

signal iTICREAD         : std_logic;
-- Internal version of TICREAD

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
-- Granted state machine next state logic
-- NextGrant only changes when HREADYIN is HIGH (to show the end of the current
-- transfer), and is set according to the values of HGRANT and CurrentGrant.
-- -----------------------------------------------------------------------------
p_NextGrantComb : process (HREADYIN, CurrentGrant, HGRANTTIC)
begin
  if (HREADYIN = '1') then
    case CurrentGrant is

      when STG_NOT_GRANT =>
        if HGRANTTIC = '1' then
          NextGrant <= STG_GAIN_GRANT;
        else
          NextGrant <= STG_NOT_GRANT;
        end if;

      when STG_GAIN_GRANT =>
        if HGRANTTIC = '1' then
          NextGrant <= STG_GRANT;
        else
          NextGrant <= STG_LOSE_GRANT;
        end if;

      when STG_GRANT =>
        if HGRANTTIC = '1' then
          NextGrant <= STG_GRANT;
        else
          NextGrant <= STG_LOSE_GRANT;
        end if;

      when STG_LOSE_GRANT =>
        if HGRANTTIC = '1' then
          NextGrant <= STG_GAIN_GRANT;
        else
          NextGrant <= STG_NOT_GRANT;
        end if;

      when others =>
        NextGrant <= STG_NOT_GRANT;

    end case;
  else
    NextGrant <= CurrentGrant;
  end if;
end process p_NextGrantComb;

-- -----------------------------------------------------------------------------
-- Granted state machine current state
-- Loads the value of NextGrant in on each HCLK
-- -----------------------------------------------------------------------------
p_CurrentGrantSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    CurrentGrant <= STG_NOT_GRANT;
  elsif (HCLK'event and HCLK = '1') then
    CurrentGrant <= NextGrant;
  end if;
end process p_CurrentGrantSeq;

-- -----------------------------------------------------------------------------
-- Address and data enables
-- Indicate when the master has control of the address/control and data buses.
-- -----------------------------------------------------------------------------
AddrDrive        <= '1' when (CurrentGrant = STG_GAIN_GRANT or
                              CurrentGrant = STG_GRANT)
                 else
                    '0';

DataDrive        <= '1' when (CurrentGrant = STG_GRANT or
                              CurrentGrant = STG_LOSE_GRANT)
                 else '0';

-- -----------------------------------------------------------------------------
-- TESTACK generation
-- TESTACK is always LOW unless the TIC is granted on the bus, in which case
-- the HREADYIN signal is used to generate TESTACK. During split/retry cycles
-- also it is set LOW.
-- -----------------------------------------------------------------------------
iTESTACK         <= '0' when (SplitRetry = '1')
                 else
                    HREADYIN when (DataDrive = '1' and TICBUSGNT = '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Synchronisation of TESTREQA prior to entering test
-- This allows a switch from an internal clock to an external test clock prior
-- to test. Once test is entered the system clock should be switched to TCLK,
-- hence TESTREQA will be synchronous.
-- -----------------------------------------------------------------------------
p_SyncTestreqSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    SyncTestReqA <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SyncTestReqA <= TESTREQA;
  end if;
end process p_SyncTestreqSeq;

-- -----------------------------------------------------------------------------
-- TIC vector state machine next state logic
-- This state machine tracks which type of test vector is being applied
-- according to the TESTREQA and TESTREQB signals. When in test mode TESTREQA
-- and TESTREQB are only considered valid when TESTACK is HIGH.
-- -----------------------------------------------------------------------------
p_NextVectComb : process (CurrentVect, SyncTestReqA, iTESTACK, TESTREQA,
                          TESTREQB)
begin
  case CurrentVect is

    when STV_IDLE =>
      if SyncTestReqA = '1' then
-- If any clock switching is required, thenthe signal that indicates
-- that the clock switch has occured should be used as an extra
-- condition to move to STV_START.
        NextVect <= STV_START;
-- Move to START using synchronised TESTREQA
      else
        NextVect <= STV_IDLE;
      end if;

    when STV_START =>
      if iTESTACK = '0' then
-- Remain in START until granted the bus
        NextVect <= STV_START;
      elsif (TESTREQA = '1' and TESTREQB = '1') then
-- Address
        NextVect <= STV_ADDRVEC;
      else
        NextVect <= STV_START;
      end if;

    when STV_ADDRVEC =>
      if iTESTACK = '0' then
        NextVect <= STV_ADDRVEC;
      elsif (TESTREQA = '1' and TESTREQB = '1') then
-- Address
        NextVect <= STV_ADDRVEC;
      elsif (TESTREQA = '1' and TESTREQB = '0') then
-- Write
        NextVect <= STV_WRITEVEC;
      elsif (TESTREQA = '0' and TESTREQB = '1') then
-- Read
        NextVect <= STV_READVEC;
      else
-- Exit
        NextVect <= STV_IDLE;
      end if;

    when STV_WRITEVEC =>
      if iTESTACK = '0' then
        NextVect <= STV_WRITEVEC;
      elsif (TESTREQA = '0' and TESTREQB = '1') then
-- Read
        NextVect <= STV_READVEC;
      elsif (TESTREQA = '1' and TESTREQB = '0') then
-- Write
        NextVect <= STV_WRITEVEC;
      else
-- Address/Exit
        NextVect <= STV_ADDRVEC;
      end if;

    when STV_READVEC =>
      if iTESTACK = '0' then
        NextVect <= STV_READVEC;
      elsif (TESTREQA = '0' and TESTREQB = '1') then
-- Read
        NextVect <= STV_READVEC;
      else
-- Address or Write or Exit
        NextVect <= STV_LASTREAD;
      end if;

    when STV_LASTREAD =>
      if iTESTACK = '0' then
        NextVect <= STV_LASTREAD;
      else
        NextVect <= STV_TURNAROUND;
      end if;

    when STV_TURNAROUND =>
      if iTESTACK = '0' then
        NextVect <= STV_TURNAROUND;
      elsif (TESTREQA = '0' and TESTREQB = '1') then
-- Read
        NextVect <= STV_READVEC;
      elsif (TESTREQA = '1' and TESTREQB = '0') then
-- Write
        NextVect <= STV_WRITEVEC;
      else
-- Address/Exit
        NextVect <= STV_ADDRVEC;
      end if;

    when others =>
-- Others will be never reached
        NextVect <= STV_IDLE;

  end case;
end process p_NextVectComb;

-- -----------------------------------------------------------------------------
-- TIC vector state machine current state
-- -----------------------------------------------------------------------------
p_CurrentVectSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    CurrentVect <= STV_IDLE;
  elsif (HCLK'event and HCLK = '1') then
    CurrentVect <= NextVect;
  end if;
end process p_CurrentVectSeq;

-- -----------------------------------------------------------------------------
-- TIC vector state machine last state
-- LastVect is needed to detect control vectors.
-- A vector is only consider to be applied when TESTACK is high.
-- -----------------------------------------------------------------------------
p_LastVectSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    LastVect <= STV_IDLE;
  elsif (HCLK'event and HCLK = '1') then
    if iTESTACK = '1' then
      LastVect <= CurrentVect;
    end if;
  end if;
end process p_LastVectSeq;

-- -----------------------------------------------------------------------------
-- Address incrementer
-- Increments the address according to the value of HSIZETIC.
-- The default system only uses byte, halfword and word incrementing, but can
-- easily be expanded to work with larger address increments.
-- -----------------------------------------------------------------------------
p_IncAddrComb : process (iHSIZETIC, iHADDRTIC)
begin
  case iHSIZETIC is

-- Byte increment
    when SZ_BYTE =>
      IncAddr(7 downto 0)  <= unsigned(iHADDRTIC(7 downto 0)) + 1;
      IncAddr(31 downto 8) <= iHADDRTIC(31 downto 8);

-- Halfword increment
    when SZ_HALF =>
      IncAddr(0)           <= '0';
      IncAddr(8 downto 1)  <= unsigned(iHADDRTIC(8 downto 1)) + 1;
      IncAddr(31 downto 9) <= iHADDRTIC(31 downto 9);

-- Word increment
    when others =>
      IncAddr(1 downto 0)   <= "00";
      IncAddr(9 downto 2)   <= unsigned(iHADDRTIC(9 downto 2)) + 1;
      IncAddr(31 downto 10) <= iHADDRTIC(31 downto 10);

  end case;
end process p_IncAddrComb;

-- -----------------------------------------------------------------------------
-- Address selection and output generation
-- The combinatorial output of the mux is used as the HADDRTIC register input.
-- The external address input is used during an address vector, and the address
-- incrementer is used at all other times.
-- -----------------------------------------------------------------------------
HaddrMux         <= (IncAddr(31 downto 10) &
                     HaddrPrev(9 downto 0)) when (SRNext = '1')
                 else
                    TBUSIN when (CurrentVect = STV_ADDRVEC or IncrmReg = '0')
                 else
                    IncAddr;

-- -----------------------------------------------------------------------------
-- The address register enable is used to load in a new address value from the
-- external test bus during an address vector, from the HaddrPrev registers
-- during a split or retry cycle, and from the address incrementer during a
-- sequential read or write vector.
-- -----------------------------------------------------------------------------
HaddrEn          <= '1' when (HREADYIN = '1' and ControlSel = '0' and
                              (CurrentVect = STV_ADDRVEC or SRNext = '1' or
                               (IncrmReg = '1' and (CurrentVect = STV_READVEC or
                                                    CurrentVect = STV_WRITEVEC)
                               )
                              )
                             )
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- An enabled register is used to hold the current address value to improve the
-- output timing.
-- -----------------------------------------------------------------------------
p_iHADDRSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    iHADDRTIC <= (others =>'0');
  elsif (HCLK'event and HCLK = '1') then
    if HaddrEn = '1' then
      iHADDRTIC <= HaddrMux;
    end if;
  end if;
end process p_iHADDRSeq;

-- -----------------------------------------------------------------------------
-- Holds the previous address output value for use during a split/retry cycle
-- when the address incrementer is being used, as the previous address must be
-- used to regenerate the split/retried transfer. Only the lowest 10 bits of
-- the address are held equivalent to the bits that can be changed by the
-- address incrementer. The top 12 bits will always be the same as for the
-- previous transfer, so do not need to be stored.
-- -----------------------------------------------------------------------------
p_HaddrPrevSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    HaddrPrev <= (others =>'0');
  elsif (HCLK'event and HCLK = '1') then
    if (HREADYIN = '1') then
      HaddrPrev <= iHADDRTIC(9 downto 0);
    end if;
  end if;
end process p_HaddrPrevSeq;

-- -----------------------------------------------------------------------------
-- Address overflow detection
-- This output is set high when the next incremented address will overflow,
-- i.e. the current address is just before the incrementing boundary.
-- A registered version is also used.
-- -----------------------------------------------------------------------------
p_BoundComb : process (iHSIZETIC, iHADDRTIC)
begin
  if ((iHSIZETIC = SZ_BYTE and (iHADDRTIC(7 downto 0)= "11111111")) or
      (iHSIZETIC = SZ_HALF and (iHADDRTIC(8 downto 1)= "11111111")) or
      (iHSIZETIC = SZ_WORD and (iHADDRTIC(9 downto 2)= "11111111"))) then
    Bound <='1';
  else
    Bound <='0';
  end if;
end process p_BoundComb;

-- -----------------------------------------------------------------------------
-- Clocked/ logic for registering the Bound
-- -----------------------------------------------------------------------------
p_BoundRegSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    BoundReg <= '0';
  elsif (HCLK'event and HCLK = '1') then
    if (HREADYIN = '1') then
      BoundReg <= Bound;
    end if;
  end if;
end process p_BoundRegSeq;

-- -----------------------------------------------------------------------------
-- Control vector detection
-- Used to distinguish between address vectors and control vectors.
-- A control vector is detected as the last address vector of a burst of at
-- least 2 addresses vectors, when LastVect and CurrentVect are both
-- address vectors, and the next vector is a read or a write.
-- -----------------------------------------------------------------------------
p_ControlVectComb : process (LastVect, CurrentVect, NextVect)
begin
  if (LastVect = STV_ADDRVEC and CurrentVect = STV_ADDRVEC
   and (NextVect = STV_READVEC or NextVect = STV_WRITEVEC)) then
    ControlVect <= '1';
  else
    ControlVect <= '0';
  end if;
end process p_ControlVectComb;

-- -----------------------------------------------------------------------------
-- A control vector is only selected for use when bit 0 is set HIGH.
-- -----------------------------------------------------------------------------
p_ControlSelComb : process (ControlVect, TBUSIN)
begin
  if (ControlVect = '1' and TBUSIN(0) = '1') then
    ControlSel <= '1';
  else
    ControlSel <= '0';
  end if;
end process p_ControlSelComb;

-- -----------------------------------------------------------------------------
-- Control vector values are read in from the external test bus during
-- a control vector, and the current output values are held at all other times.
-- -----------------------------------------------------------------------------
p_ControlComb : process (ControlSel, TBUSIN, IncrmReg, iHPROTTIC, iHLOCK,
                         HSizeInt, TICBUSGNT)
begin
  if (ControlSel = '1' and TICBUSGNT = '1') then
    Incrm            <= TBUSIN(7);
    HprotGen         <= TBUSIN(10 downto 9) & TBUSIN(6 downto 5);
    HlockGen         <= TBUSIN(4);
    HSizeGen         <= TBUSIN(3 downto 2);
  else
    Incrm            <= IncrmReg;
    HprotGen         <= iHPROTTIC;
    HlockGen         <= iHLOCK;
    HSizeGen         <= HSizeInt;
  end if;
end process p_ControlComb;

-- -----------------------------------------------------------------------------
-- The default values after reset are:
-- IncrmReg = address incrementing disabled
-- HPROTTIC = supervisor access, un-cacheable and un-bufferable
-- HLOCK = unlocked transfer
-- HSIZETIC = 32-bit transfer (word)
-- -----------------------------------------------------------------------------
p_ControlSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    IncrmReg  <= '0';
    iHPROTTIC <= "0011";
    iHLOCK    <= '0';
    HSizeInt  <= "10";
  elsif (HCLK'event and HCLK = '1') then
    IncrmReg  <= Incrm;
    iHPROTTIC <= HprotGen;
    iHLOCK    <= HlockGen;
    HSizeInt  <= HSizeGen;
  end if;
end process p_ControlSeq;

-- -----------------------------------------------------------------------------
-- TICREAD generation
-- TICREAD is active HIGH and controls when the external memory interface
-- drives read data from the internal HRDATATIC bus out on to the external
-- TBUSOUT. Data is driven out from the rising edge of HCLK in the read cycle
-- and remains driven past the end of the transfer until the rising edge of
-- clock after the transfer has completed. A read or burst of reads will always
-- be followed by a Turnaround vector, which prevents bus clash on the external
-- TESTBUS.
-- -----------------------------------------------------------------------------
iTICREAD         <= '0' when (DataDrive = '0')
                 else
                    '1' when (LastVect = STV_READVEC)
                 else
                    '0';

TBUSOUT          <= HRDATATIC when (iTICREAD = '1')
                 else
                    (others =>'0');

-- -----------------------------------------------------------------------------
-- Split/Retry detection
-- This section is used to control the operation of the TIC during a
-- split/retry cycle initiated by the current slave. If grant is lost before
-- the transfer has completed, thenthe value of SplitRetry is held.
-- -----------------------------------------------------------------------------
SRNext           <= '1' when ((HRESPTIC = RSP_RETRY or HRESPTIC = RSP_SPLIT) and
                              DataDrive = '1')
                 else
                    SplitRetry when AddrDrive = '0'
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Sequential process for Split/Retry
-- -----------------------------------------------------------------------------
p_SplitRetrySeq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    SplitRetry <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SplitRetry <= SRNext;
  end if;
end process p_SplitRetrySeq;

-- -----------------------------------------------------------------------------
-- SR1 is set HIGH during the HREADYIN LOW cycle of a split/retry response. The
-- registered SR2 is set HIGH during the HREADYIN HIGH cycle of a split/retry
-- response. This is used to remove the combinational path from HRESPTIC to
-- HTRANSTIC when driving out an Idle during the second cycle of a split/retry.
-- -----------------------------------------------------------------------------
SR1              <= '1' when ((HRESPTIC = RSP_RETRY or HRESPTIC = RSP_SPLIT) and
                              DataDrive = '1' and HREADYIN = '0')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Sequential process
-- -----------------------------------------------------------------------------
p_SR2Seq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    SR2 <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SR2 <= SR1;
  end if;
end process p_SR2Seq;

-- -----------------------------------------------------------------------------
-- Transfer type (HTRANSTIC) generation
-- Only indicate Sequential when an incremented address is going to be used.
-- The cases when an incremented address are used are:
-- - a read followed by a read
-- - a write followed by a write
-- - a write followed by a read

-- An Idle is inserted during the second cycle of a split/retry response.
-- A Non-Seqeuntial will always be inserted during the cycle after a
-- split/retry response has been received.
-- -----------------------------------------------------------------------------
p_iHTRANSComb : process (SR2, SplitRetry, CurrentVect, AddrDrive, DataDrive,
                         LastVect, IncrmReg, BoundReg)
begin
  if SR2 = '1' then
    iHTRANSTIC <= TRN_IDLE;
  elsif SplitRetry = '1' then
    iHTRANSTIC <= TRN_NONSEQ;
  else
    case CurrentVect is

      when STV_READVEC =>
        if (AddrDrive = '1' and DataDrive = '0') then
          iHTRANSTIC <= TRN_NONSEQ;
        elsif ((LastVect = CurrentVect) and
               IncrmReg = '1' and BoundReg = '0') then
          iHTRANSTIC <= TRN_SEQ;
        else
          iHTRANSTIC <= TRN_NONSEQ;
        end if;

      when STV_WRITEVEC =>
        if (AddrDrive = '1' and DataDrive = '0') then
          iHTRANSTIC <= TRN_NONSEQ;
        elsif ((LastVect = CurrentVect) and
               IncrmReg = '1' and BoundReg = '0') then
          iHTRANSTIC <= TRN_SEQ;
        else
          iHTRANSTIC <= TRN_NONSEQ;
        end if;

      when others =>
        iHTRANSTIC <= TRN_IDLE;

    end case;
  end if;
end process p_iHTRANSComb;

-- -----------------------------------------------------------------------------
-- iHWRITETIC generation
-- After a split/retry response, the last vector must be used to regenerate the
-- previous transfer. The current vector is used at all other times.
-- -----------------------------------------------------------------------------
Vect             <= LastVect when (SplitRetry = '1')
                 else
                    CurrentVect;

iHWRITETIC       <= '1' when (Vect = STV_WRITEVEC)
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Output data bus generation
-- HWDATATIC is driven from TBUSIN a write cycle, and keeps its current value
-- during a split/retry cycle or when the bus is waited.
-- Registered to generate correct AHB timing for a write cycle.
-- -----------------------------------------------------------------------------
HwdataEn         <= '1' when (HREADYIN = '1' and CurrentVect = STV_WRITEVEC and
                              SplitRetry = '0')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Sequential process for HWDATA bus
-- -----------------------------------------------------------------------------
p_HWDATASeq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    iHWDATATIC <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (HwdataEn = '1') then
      iHWDATATIC <= TBUSIN;
    end if;
  end if;
end process p_HWDATASeq;

-- -----------------------------------------------------------------------------
-- Bus request generation for the AHB and for the external memory bus
-- Request access to the bus once the STV_START vector state is entered and
-- keep requesting access until the STV_IDLE state is re-entered at the end of
-- the test. The TIC does not back off the bus for address vectors.
-- On the external memory side TIC has the highest priority
-- -----------------------------------------------------------------------------
iHBUSREQTIC      <= '0' when (CurrentVect = STV_IDLE)
                 else
                    '1';

-- -----------------------------------------------------------------------------
-- AMBA signals out of module
-- Drives the address, control and data outputs with the internally generated
-- versions.
-- -----------------------------------------------------------------------------
iHSIZETIC        <= HSizeInt;
-- Generate full HSIZETIC output
HADDRTIC         <= iHADDRTIC;
HTRANSTIC        <= iHTRANSTIC;
HWRITETIC        <= iHWRITETIC;
HSIZETIC         <= LOGIC_ZERO & iHSIZETIC;
HBURSTTIC        <= "001";
-- Always incrementing burst of unspecified length
HPROTTIC         <= iHPROTTIC;
HWDATATIC        <= iHWDATATIC;
HLOCKTIC         <= iHLOCK;

-- -----------------------------------------------------------------------------
-- Output drivers
-- Drives the non-AMBA outputs with internal version.
-- -----------------------------------------------------------------------------
TESTACK          <= iTESTACK;
HBUSREQTIC       <= iHBUSREQTIC;
TICBUSREQ        <= DataDrive;
TICREAD          <= iTICREAD;

end synth;

-- --================================== End ==================================--
