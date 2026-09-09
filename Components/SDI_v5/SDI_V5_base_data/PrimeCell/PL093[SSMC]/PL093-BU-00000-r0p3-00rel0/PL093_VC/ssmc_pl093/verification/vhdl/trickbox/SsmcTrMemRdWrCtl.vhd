-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SsmcTrMemRdWrCtl.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block Interfaces the SSMC with the memory modules
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SsmcTrPackage.all;

-- -----------------------------------------------------------------------------

entity SsmcTrMemRdWrCtl is
  generic (
           Tclk             : time := 7.5 ns  -- HCLK Period
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Address Bus to Memory
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Memory Bus Enable
        SSMTrBankCS      : in    std_logic; -- Bank select active high

        nSSMTrBankCS     : in    std_logic; -- Bank select active low

        SSMTrCS          : in    std_logic_vector(7 downto 0);
                                            -- The status of all the 8 banks
                                            -- connected with the SMC
                                            -- active high chip select
        nSSMTrCS         : in    std_logic_vector(7 downto 0);
                                            -- The status of all the 8 banks
                                            -- connected with the SMC
                                            -- active low chip select
        nSMWEN           : in    std_logic; -- Write enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Byte lane select
        nSMOEN           : in    std_logic; -- Output enable
        MemRdDataDW      : in    std_logic_vector(31 downto 0);
                                            -- SMC read data
        SMCLK            : in    std_logic; -- SSMC clock
                                            -- for synchronous memory operation
        SMADDRVALID      : in    std_logic; -- Address valid signal
        SSMCTrBurstWt    : in    std_logic_vector(8 downto 0);
                                            -- Burst access external delay
        SSMCTrMEMBASE    : in    std_logic_vector(14 downto 0);
                                            -- Memory base address
        SMTrBIDCYR       : in    std_logic_vector(3 downto 0);
                                            -- Memory Data Bus turn
                                            -- around time
        SMTrBWSTRDR      : in    std_logic_vector(4 downto 0);
                                            -- Initial Read acess time

        SMTrBWSTWRR      : in    std_logic_vector(4 downto 0);
                                            -- Write access time
        SMTrBWSTOENR     : in    std_logic_vector(3 downto 0);
                                            -- CS to output enable time
        SMTrBWSTWENR     : in    std_logic_vector(3 downto 0);
                                            -- CS to write enable time
        SMTrBWSTBRDR     : in    std_logic_vector(4 downto 0);
                                            -- Burst read time
                                            -- after initial access
        SMTrBCR          : in    std_logic_vector(21 downto 0);
                                            -- Bank control parameters
        SMMemClkRatio    : in    std_logic_vector(1 downto 0);
                                            -- Clock Ratio;
-- InOut

        SMDATA           : inout std_logic_vector(31 downto 0);
                                            -- Output data
-- Outputs

        LatchSMADDR      : out   std_logic_vector(10 downto 0);
                                            -- Latched SSMC Address
        nSMBURSTWAIT     : out   std_logic;
                                            -- External Burst wait signal
        SMFBCLK          : out   std_logic;
                                            -- Feed back clock
        SMTrIND          : out   std_logic;
                                            -- Indicate address[4:0] ="11111"
        TrnSMBLS         : out   std_logic_vector(3 downto 0)
                                            -- Byte Lane Select signal
                                            -- whose value depend on RBLE

       );
end SsmcTrMemRdWrCtl;
-- -----------------------------------------------------------------------------
--
--                               SsmcTrMemRdWrCtl
--                               ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block constitutes the main control block in the SSMC trickbox.
-- Depending on the content of the SMTrBCR register this block model the
-- memory module as SRAM, FLASH, ROM or BURST ROM. It is possible to program the
-- trickbox as a memory of data size 8-bit, 16-bit and 32-bit. This module
-- contains all memory related signals given by the SSMC. All memory related
-- timing parameters are checked in this module. Facility to display error
-- messages, if any violation happened are also provided.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of SsmcTrMemRdWrCtl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant EIGHT                : std_logic_vector(1 downto 0) := "00";
constant SIXTEEN              : std_logic_vector(1 downto 0) := "01";
constant THIRTYTWO            : std_logic_vector(1 downto 0) := "10";

constant ST_CNTRL_IDLE        : std_logic_vector(2 downto 0) := "000";
-- IDLE state.

constant ST_CNTRL_READ        : std_logic_vector(2 downto 0) := "001";
-- Read state.

constant ST_CNTRL_INTBRSTREAD : std_logic_vector(2 downto 0) := "010";
-- Burst read(initial) state.

constant ST_CNTRL_WRITE       : std_logic_vector(2 downto 0) := "011";
-- Write state.

constant ST_CNTRL_BURSTREAD   : std_logic_vector(2 downto 0) := "100";
-- Burst read state.

constant ST_CNTRL_BURSTWRITE  : std_logic_vector(2 downto 0) := "101";
-- Burst write state.

constant ST_CNTRL_SYWRITE     : std_logic_vector(2 downto 0) := "110";
-- Synchronouse Write state.

constant XonSMDATA            : std_logic := '0';
-- Controls whether 'X' or '0' is driven on SMDATA during read accesses.

constant DefData              : std_logic_vector(31 downto 0)
                              := "11011110101011011011111011101111";
-- Default data to be driven to the SMDATA

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal nWR              : std_logic;
-- Memory write enable.

signal nCS              : std_logic;
-- Memory device enable.

signal nSMBLSWR         : std_logic;
-- Memory write enable when byte lane is using as write enable

signal RdCountDown      : std_logic;
-- Count Down enable for Read process

signal WrCountDown      : std_logic;
-- Count Down enable for Write process

signal RdCount          : unsigned(4 downto 0) := "00000";
-- Read count

signal BWtMask          : std_logic := '1';
-- To mask the nSMBURSTWAIT

signal BwtAssert        : std_logic := '0';
-- To indicate assert burst wait

signal BWtAssnCount     : unsigned(5 downto 0) := "000000";
-- Burst Wait assertion count

signal BWtCount         : unsigned(5 downto 0) := "000000";
-- Burst Wait assertion counter

signal WrCount          : unsigned(4 downto 0) := "00000";
-- Write count

signal WstRead          : unsigned(4 downto 0) := "00000";
-- External Wait States counter for read

signal WstWrite         : unsigned(4 downto 0) := "00000";
-- External Wait States counter for write

signal ExtWaitCount     : unsigned(9 downto 0) := "0000000000";
-- Read count

signal WaitCount        : unsigned(23 downto 0) := "000000000000000000000000";
-- External Wait States counter

signal SsmcCntSt        : std_logic_vector(2 downto 0) := "000";
-- State register.

signal NxtSsmcCntSt     : std_logic_vector(2 downto 0) := "000";
-- D-input for State register.

signal IntIDCY          : time := 0 ns;
-- Memory idle time.

signal IntWSTRead       : time := 0 ns;
-- Access time for read.

signal IntWSTBInitRead  : time := 0 ns;
-- Initial access time for burst read.

signal IntWSTBRead      : time := 0 ns;
-- Access time for burst read.

signal IntWSTWrite      : time := 0 ns;
-- Access time for write.

signal IntWSTReadMax    : time := 0 ns;
-- Maximum allowable access time for read.

signal IntWSTBInitRdMax : time := 0 ns;
-- maximum allowable access time for burst read.

signal IntWSTBReadMax   : time := 0 ns;
-- maximum allowable access time for burst read.

signal IntWSTWriteMax   : time := 0 ns;
-- Maximum allowable access time for write.

signal IntCS2OEN        : time := 0 ns;
-- Memory Chip Select to Output enable time

signal IntCS2WEN        : time := 0 ns;
-- Memory Chip Select to Write enable time

signal ExtBankActive    : std_logic;
-- Assigned '0' when all chip selectes become idle.

signal DelExtBankActive : std_logic;
-- Delayed version of ExtBankActive.

signal AccessSTime      : time := 0 ns;
-- Latch the time when access starts

signal WrEndTime        : time := 0 ns;
-- Latch the time when write gets finish.

signal RdEndTime        : time := 0 ns;
-- Latch the time when read gets finish.

signal AddChangeTime    : time := 0 ns;
-- Latch the time when address changes.

signal iLatchSMADDR     : std_logic_vector(10 downto 0) := "00000000000";
-- Memory address latch.

signal DelnCS           : std_logic;
-- 1 ns Delayed version of nCS

signal Del1nSMOEN       : std_logic;
-- 1 ns Delayed version of nSMOEN.

signal DelnSMBLS        : std_logic_vector(3 downto 0);
-- 1 ns Delayed version of nSMBLS.

signal OldLatchSMADDR   : std_logic_vector(10 downto 0);
-- Store the old address.

signal WenAsrn          : time := 0 ns;
-- Latch the time when WEN gets asserted.

signal WenDeAsrn        : time := 0 ns;
-- Latch the time when WEN gets asserted.

signal WrSTime          : time := 0 ns;
-- Latch the time when write gets start.

signal NBRdSTime        : time := 0 ns;
-- Latch the time when non burst read gets start.

signal BRdSTime         : time := 0 ns;
-- Latch the time when burst read gets start

signal IdleStartTime    : time := 0 ns;
-- Latch the time when memory idle time start.

signal DataChangeTime   : time := 0 ns;
-- Latch the time when data changes.

signal MaxAccErMask     : std_logic := '0';
-- If set to '1' it will mask the read access maximum time violation message

signal AccErMask        : std_logic := '0';
-- If set to '1' it will mask the read access time violation message.

signal WaitEn           : std_logic;
-- SMCTrnWAIT toggle enable bit

signal BoundaryCase     : std_logic := '0';
-- Read-data return time select

signal OutofRange       : std_logic;
-- Memory access out of range indicator

signal DelOutofRange    : std_logic;
-- Memory access out of range indicator(for protocol check)

signal ToggSt           : std_logic;
-- State Toggler to trigger the state machine

signal DataWrRdy        : std_logic;
-- Data Input enable signal

signal DataRdy          : std_logic;
-- Data out enable signal

signal ShiftMemBase     : std_logic_vector(14 downto 0);
-- Shifted Memory Base address for comparision

-- -----------------------------------------------------------------------------
-- signals for SSMC
-- -----------------------------------------------------------------------------

signal DelSMCLK         : std_logic;
-- Delayed SMCLK

signal BWt              : std_logic := '0';
-- External Burst wait

signal BWtLatched2      : std_logic := '0';
-- External Burst Wait Latched second time for read accesses getting complete

signal BWtLatched       : std_logic := '0';
-- External Burst Wait Latched for read accesses

signal BWtFlag          : std_logic := '0';
-- flag use to indicate Bwt asserted once in this access

signal IntWSTBurst      : time := 0 ns;
-- External burst wait time

signal AddrEvent        : unsigned(3 downto 0) := "0000";
-- counter for address events

signal BeatNo           : std_logic_vector(3 downto 0);
-- Number of beats after which burst wait asserted

signal BeatCnt          : unsigned(3 downto 0) := "1111";
-- internal beat counter

signal WEnLatched       : std_logic := '1';
-- To indicate nWEN has asserted for one clock

signal ALatched         : std_logic := '0';
-- To indicate that address is latched

signal StartIncrAddr    : std_logic := '0';
-- To indicate the latching of SMADDR to iSyLatchSMADDR

signal NxtSyLatchSMADDR : std_logic_vector(10 downto 0) := "00000000000";
-- D flip flop input, Latched address for syncronous operation

signal SyLatchSMADDR    : std_logic_vector(10 downto 0) := "00000000000";
-- Latched address for internal synchronous increments

signal iSyLatchSMADDR   : std_logic_vector(10 downto 0) := "00000000000";
-- Internal synchronous increments

signal AddrValidWriteEn : std_logic;
-- Address valid for write

signal AddrValidReadEn  : std_logic;
-- Address valid for read

signal BurstLenWrite    : std_logic_vector(1 downto 0);
-- Burst transfer lenth for write

signal BurstLenRead     : std_logic_vector(1 downto 0);
-- Burst transfer lenth for read

signal SyncEnWrite      : std_logic;
-- Synchronous burst mode write

signal SyncEnRead       : std_logic;
-- Synchronous burst mode read

signal BMRead           : std_logic;
-- Burst mode read

signal MW               : std_logic_vector(1 downto 0);
-- Memory width

signal WP               : std_logic;
-- Write protection

signal WaitPol          : std_logic;
-- External wait signal polarity

signal RBLE             : std_logic;
-- Read byte lane enable

signal WrapRead         : std_logic;
-- Wrap read enable

signal WrapAct          : std_logic := '0';
-- Wrap read Active

signal ClkFactor        : integer range 1 to 3 := 1;
-- Multiplying factor for Clock duration

signal DataWrRd         : std_logic := '0';
-- DataWrRd indicates for Read or Write access

signal ALatchedReg      : std_logic;
-- Registered version of ALatched signal

signal NextALatchedReg  : std_logic;
-- D-Input of ALatchedReg

signal DelSMADDRVALID   : std_logic;
-- Delayed version of SMADDRVALID

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- ToInteger
-- ---------
--   This function converts the std_logic_vector input argument into integer
-- and returns the integer value.
-- -----------------------------------------------------------------------------
function ToInteger (val : std_logic_vector;
                    x   : integer := 0)
return integer is
variable return_int, x_tmp : integer;
begin
  return_int := 0;
  x_tmp := 0;
    if x /= 0 then
      x_tmp := 1;
    end if;
    for i in val'range loop
      return_int := return_int + return_int;
      case val(i) is
        when '0'    => null;
        when '1'    => return_int := return_int + 1;
        when others => return_int := return_int + x_tmp;
      end case;
    end loop;
  return return_int;
end ToInteger;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Register field rename
-- -----------------------------------------------------------------------------
AddrValidWriteEn  <= SMTrBCR(20);
BurstLenWrite     <= SMTrBCR(19 downto 18);
SyncEnWrite       <= SMTrBCR(17);
WrapRead          <= SMTrBCR(14);
AddrValidReadEn   <= SMTrBCR(12);
BurstLenRead      <= SMTrBCR(11 downto 10);
SyncEnRead        <= SMTrBCR(9);
BMRead            <= SMTrBCR(8);
MW                <= SMTrBCR(5 downto 4);
WP                <= SMTrBCR(3);
WaitEn            <= SMTrBCR(2);
WaitPol           <= SMTrBCR(1);
RBLE              <= SMTrBCR(0);

-- -----------------------------------------------------------------------------
-- Signal assignment
-- -----------------------------------------------------------------------------
BeatNo            <= SSMCTrBurstWt(7 downto 4);
IntWSTBurst       <= ToInteger(SSMCTrBurstWt(3 downto 0)) * (ClkFactor * Tclk);
BWtMask           <= SSMCTrBurstWt(8);

nSMBLSWR          <= nSMBLS(0) and nSMBLS(1) and nSMBLS(2) and nSMBLS(3);

DataWrRd          <= nSMDATAEN(0) and nSMDATAEN(1) and nSMDATAEN(2)
                     and nSMDATAEN(3);

-- -----------------------------------------------------------------------------
-- ClkFactor determination
-- -----------------------------------------------------------------------------
p_ClkFactorComb : process (SMMemClkRatio)
begin
  case SMMemClkRatio is
    when "00" =>
      ClkFactor <= 1;
    when "01" =>
      ClkFactor <= 2;
    when "10" =>
      ClkFactor <= 3;
    when others =>
      ClkFactor <= 1;
  end case;
end process p_ClkFactorComb;

-- -----------------------------------------------------------------------------
-- Write Enable selection according to the RBLE value
-- -----------------------------------------------------------------------------
p_SMBLSComb : process (RBLE, nSMBLS, nSMWEN, WEnLatched)
begin
 if (SyncEnWrite = '1') then
   if (RBLE = '0') then
     TrnSMBLS <= nSMBLS;
   else
     TrnSMBLS <= nSMBLS or (not(WEnLatched & WEnLatched
                               & WEnLatched & WEnLatched));
   end if;
 else
   if (RBLE = '0') then
     TrnSMBLS <= nSMBLS;
   else
     TrnSMBLS <= nSMBLS or (nSMWEN & nSMWEN & nSMWEN & nSMWEN);
   end if;
 end if;
end process p_SMBLSComb;

-- -----------------------------------------------------------------------------
-- Chip Select/Polarity Mux
-- -----------------------------------------------------------------------------

    nCS <= not (SSMTrBankCS and (not (nSSMTrBankCS)));

-- -----------------------------------------------------------------------------
-- Write enable select Mux
-- -----------------------------------------------------------------------------
p_nWRComb : process (RBLE, nSMBLSWR, nSMWEN)
begin
  if (RBLE = '0') then
    nWR <= nSMBLSWR;
  else
    nWR <= nSMWEN;
  end if;
end process p_nWRComb;

-- -----------------------------------------------------------------------------
-- Converting std_logic_vector to time.
-- -----------------------------------------------------------------------------
IntIDCY          <= (ToInteger(SMTrBIDCYR) + 1) * (ClkFactor * Tclk);
IntWSTRead       <= ((ToInteger(SMTrBWSTRDR) + 1) * (ClkFactor * Tclk) + 2 ns);
IntWSTWrite      <= (ToInteger(SMTrBWSTWRR) + 1) * (ClkFactor * Tclk) -
                                                    (ClkFactor * Tclk);
IntWSTBInitRead  <= ((ToInteger(SMTrBWSTRDR) + 2) * (ClkFactor * Tclk))
                       when (SyncEnRead = '1')
                     else
                       ((ToInteger(SMTrBWSTRDR) + 1) * (ClkFactor * Tclk));
IntWSTBRead      <= ((ToInteger(SMTrBWSTBRDR) + 1) * (ClkFactor * Tclk));
IntCS2OEN        <= ToInteger(SMTrBWSTOENR) * (ClkFactor * Tclk);
IntCS2WEN        <= ToInteger(SMTrBWSTWENR) * (ClkFactor * Tclk);

-- -----------------------------------------------------------------------------
-- Calculate the maximum allowable time for read and write access.
-- -----------------------------------------------------------------------------
IntWSTReadMax     <= IntWSTRead + 2*(ClkFactor * Tclk) + DelayTime;
--IntWSTReadMax     <= IntWSTRead + 1*(ClkFactor * Tclk) + DelayTime + 5 ns;
IntWSTWriteMax    <= IntWSTWrite + 2*(ClkFactor * Tclk) + DelayTime;
--IntWSTBReadMax    <= IntWSTBRead + 1*(ClkFactor * Tclk) + DelayTime;
IntWSTBReadMax    <= IntWSTBRead + 1*(ClkFactor * Tclk) + DelayTime + 10 ns;
IntWSTBInitRdMax  <= IntWSTBInitRead + 1*(ClkFactor * Tclk) + DelayTime;

-- -----------------------------------------------------------------------------
-- Generate the delayed version of signals
-- -----------------------------------------------------------------------------
DelnCS           <= nCS after 1 ns;
Del1nSMOEN       <= nSMOEN after 1 ns;
DelnSMBLS        <= nSMBLS after 1 ns;
DelExtBankActive <= ExtBankActive after 2 ns;
DelOutofRange    <= OutofRange after 1 ns;

-- -----------------------------------------------------------------------------
-- ExtBankActive becomes high when any other chip selects becomes enabled.
-- -----------------------------------------------------------------------------

ExtBankActive    <= ((SSMTrCS(7)and(not(nSSMTrCS(7))))
                      or (SSMTrCS(6)and(not(nSSMTrCS(6))))
                      or (SSMTrCS(5)and(not(nSSMTrCS(5))))
                      or (SSMTrCS(4)and(not(nSSMTrCS(4))))
                      or (SSMTrCS(3)and(not(nSSMTrCS(3))))
                      or (SSMTrCS(2)and(not(nSSMTrCS(2))))
                      or (SSMTrCS(1)and(not(nSSMTrCS(1))))
                      or (SSMTrCS(0)and(not(nSSMTrCS(0))))) and nCS;

-- -----------------------------------------------------------------------------
-- SSMC clock operations
-- -----------------------------------------------------------------------------
DelSMCLK      <= SMCLK after 2 ns;
SMFBCLK       <= DelSMCLK;

-- -----------------------------------------------------------------------------
-- Latch the time when WEN is asserted
-- -----------------------------------------------------------------------------
p_WenATimeComb : process (nSMWEN)
begin
  if (nSMWEN'event and nSMWEN = '0') then
      WenAsrn <= now;
  end if;
end process p_WenATimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when WEN is asserted
-- -----------------------------------------------------------------------------
p_WenDeATimeComb : process (nSMWEN)
begin
  if (nSMWEN'event and nSMWEN = '1') then
      WenDeAsrn <= now;
  end if;
end process p_WenDeATimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when access starts
-- -----------------------------------------------------------------------------
p_AccSTimeComb : process (nCS)
begin
  if (nCS'event and nCS = '0') then
    AccessSTime <= now - 1 ps;
  end if;
end process p_AccSTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when write gets finish
-- -----------------------------------------------------------------------------
p_WrEndTimeComb : process (nWR)
begin
  if (nWR'event and nWR = '1' and nCS = '0') then
    WrEndTime <= now;
  end if;
end process p_WrEndTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when Read gets finish
-- -----------------------------------------------------------------------------
p_RdEndTimeComb : process (nSMOEN)
begin
  if (nSMOEN'event and nSMOEN = '1' and nCS = '0') then
    RdEndTime <= now;
  end if;
end process p_RdEndTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when chip inactive
-- -----------------------------------------------------------------------------
p_IdlStrtTimeComb : process (nCS)
begin
  if (nCS'event and nCS = '1') then
    IdleStartTime <= now;
  end if;
end process p_IdlStrtTimeComb;

-- -----------------------------------------------------------------------------
-- During the write cycle address should not change. Also in this design
-- nSMOEN is never enabled when write is enabled.
-- -----------------------------------------------------------------------------
assert not ((nSMOEN = '0') and (nWR = '0') and (nCS = '0'))
  report "SSMCTM1: Read enable and write enable are asserted at the same time"
severity warning;

-- -----------------------------------------------------------------------------
-- During the read cycle chip select should not change.
-- -----------------------------------------------------------------------------
p_CsStatusCheck : process
begin
  wait on nCS;
  if (nCS = '1') then
    wait for DelayTime;

    if (nWR = '0') then
      assert not ((now - 2*(ClkFactor * Tclk)) > WrEndTime)
        report "SSMCTM3: Chip select controlled write"
      severity warning;
    end if;

    if (nSMOEN = '0') then
      assert not ((now - 2*(ClkFactor * Tclk)) > RdEndTime)
        report "SSMCTM4: Chip select changed during read was active"
      severity warning;
    end if;
  end if;
end process p_CsStatusCheck;

-- -----------------------------------------------------------------------------
-- Checks for OEN and WEN asserted simultaneously
-- -----------------------------------------------------------------------------
p_RdWrAssertComb : process (nSMOEN, nWR)
begin
  if (nCS = '0') then
    if (nSMOEN = '0') then
      if ((nWR = '0')or(nSMWEN = '0')) then
        assert false
          report "SSMCTM5: Output Enable and Write Enable are asserted together"
        severity warning;
      end if;
    end if;
  end if;
end process p_RdWrAssertComb;

-- -----------------------------------------------------------------------------
-- Idle time check between the memory banks
-- -----------------------------------------------------------------------------
p_IdleBetBank : process
begin
  wait on DelExtBankActive;
  if ((DelExtBankActive = '1') and (ExtBankActive = '1') and
      (now > IntIDCY)) then
    wait for DelayTime;
      -- A write to another bank after a read
      if (nCS = '1' and (nSMBLSWR = '0' or nSMWEN = '0') and nSMOEN = '1') then
        -- The subtracted value is decreased from 5 to 4 as the IntIDCY value
        -- taken for comparison is the highest IDCY value of all the banks
        assert not (now - (4 ns + RdEndTime) < IntIDCY)
          report "SSMCTM6: Bank to Bank idle time violation"
        severity warning;
      end if;
  end if;
end process p_IdleBetBank;

-- -----------------------------------------------------------------------------
-- Checking the address and data hold time with resepect to the rising edge
-- of write signal.
-- -----------------------------------------------------------------------------
assert not (SMADDR'event and (nCS = '0') and
            ((now - WrEndTime) < AddWrHoldTime))
  report "SSMCTM7: Address hold time violation"
severity warning;

assert not ((now > 0 ns) and SMDATA'event and (nCS = '0') and

           ((now - WrEndTime) < DataWrHoldTime))
  report "SSMCTM8: Data hold time violation"
severity warning;

assert not (WrEndTime'event and (now > 100 ns) and (nCS = '0') and
           ((WrEndTime - DataChangeTime) < DataWrSetupTime))
  report "SSMCTM9: Data setup time violation"
severity warning;

-- -----------------------------------------------------------------------------
-- nSMWEN assertion time check
-- -----------------------------------------------------------------------------
p_nSMWENCheck : process (nSMWEN)
begin
 if (nSMWEN'event and (nSMWEN = '1') and (SyncEnWrite ='1')) then
   assert ((now - WenAsrn) >= (ClkFactor * Tclk))
     report "SSMCTM10: nSMWEN is asserted for less than a clock cycle."
   severity warning;
 end if;
end process p_nSMWENCheck;

-- -----------------------------------------------------------------------------
-- State transition process
-- -----------------------------------------------------------------------------
p_RdWrSeq : process (HRESETn, DelSMCLK)
begin
  if (HRESETn = '0') then
    SsmcCntSt <= ST_CNTRL_IDLE;
    ToggSt    <= '0';
  elsif (DelSMCLK'event and DelSMCLK = '0') then
    SsmcCntSt <= NxtSsmcCntSt;
    ToggSt    <= not ToggSt;
  end if;
end process p_RdWrSeq;

-- ---------------------------------------------------------------------------
-- Next State generation process
-- ---------------------------------------------------------------------------
p_RdWrComb : process (iLatchSMADDR,iSyLatchSMADDR, nWR, nSMOEN, nCS,
                      OutofRange,SyncEnWrite,SyncEnRead,BMRead,WP,
                      SsmcCntSt, RdCount, ToggSt,ALatched, AddrValidReadEn)
begin

  case SsmcCntSt is
 -- IDLE STATE
    when ST_CNTRL_IDLE =>
      WrCountDown    <= '0';
      RdCountDown    <= '0';
      DataRdy        <= '0';
      DataWrRdy      <= '0';
      if (nCS = '0') then
       -- Write cycle started.
       if (OutofRange = '1') then
         NxtSsmcCntSt <= ST_CNTRL_IDLE;
       else
         if ((nWR = '0')and (SyncEnWrite = '0')) then
           assert not (((now - (RdEndTime - 1 ns)) < IntIDCY) and
                      (now > IntIDCY))
             report "SSMCTM11: Read to write idle time violation"
           severity warning;

           assert not ((now - AddChangeTime) < AddWrSetupTime)
             report "SSMCTM12: Address set up time violation"
           severity warning;

           if (WaitEn = '0') then
             assert not ((now - AccessSTime) < IntCS2WEN)
               report "SSMCTM13: Chip Select to Write Enable assertion time"
                               & " violation"
             severity warning;
           end if;

           -- Write is allowed only when memory is configured as SRAM.
           if (WP ='0') then
             NxtSsmcCntSt <= ST_CNTRL_WRITE;
             WrSTime      <= now - IntCS2WEN - 2 ns;

             -- If the programmed memory size is
             -- 8-bit then only one write enable is active at a time.
             -- 16-bit then either nSMBLS(0) and nSMBLS(1) or
             -- nSMBLS(2) and nSMBLS(3) are high at all time

             if ((MW = EIGHT) and (nCS = '0')) then
               assert not ((nSMBLS(3) and nSMBLS(2) and nSMBLS(1)) = '0')
                 report "SSMCTM14: Write enable violation for an 8-bit memory"
               severity warning;

             elsif ((MW = SIXTEEN) and (nCS = '0')) then
               assert not ((nSMBLS(3) and nSMBLS(2)) = '0')
                 report "SSMCTM15: Write enable violation for a 16-bit memory"
               severity warning;
             end if;
           else
             NxtSsmcCntSt <= ST_CNTRL_IDLE;
             assert false
               report "SSMCTM16: Write is not supported"
             severity warning;
           end if;

         -- Synchronouse write started.
         elsif ((nWR = '0') and (SyncEnWrite = '1')) then
           if (WP ='0') then
             NxtSsmcCntSt <= ST_CNTRL_SYWRITE;
           else
             NxtSsmcCntSt <= ST_CNTRL_IDLE;
           end if;

         -- Read cycle started.
         elsif (nSMOEN ='0') then
           assert not ((now - WrEndTime) < ((ClkFactor * Tclk) - 2 ns))
             report "SSMCTM17: Write to read idle time violation"
           severity warning;

           if (WaitEn = '0') then
             assert not ((now - (AccessSTime + 0 ns)) < IntCS2OEN)
                report "SSMCTM18: Chip Select to Output Enable assertion time" &
                                 "violation"
             severity warning;
           end if;

    --       NBRdSTime <= now - IntCS2OEN;
           NBRdSTime <= now - IntCS2OEN - 2 ns - 1 ps;
           if (BMRead = '1') then
             NxtSsmcCntSt <= ST_CNTRL_INTBRSTREAD;
             BRdSTime  <= now - IntCS2OEN - 2 ns;
           else
             NxtSsmcCntSt <= ST_CNTRL_READ;
           end if;
         else
           NxtSsmcCntSt <= ST_CNTRL_IDLE;
         end if;
       end if;
      end if;

    when ST_CNTRL_READ =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- Read cycle finished.
      if (nSMOEN ='1') then
        NxtSsmcCntSt  <= ST_CNTRL_IDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - NBRdSTime) > IntWSTReadMax)
              report "SSMCTM19: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - NBRdSTime) < IntWSTRead)
              report "SSMCTM20: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Synchronous read access. In case of synchronous read addrvalid signal
      -- will get asserted for 0ne clock cycle.
      -- Address will be latched for incrementing internally.

      -- BURST access. In case of burst access higher order address will
      -- not change.
      elsif (iLatchSMADDR'event and (nSMOEN = '0') and
           (iLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3))) then
        DataRdy <= '0';
        NBRdSTime   <= now - 1 ns;
        NxtSsmcCntSt  <= ST_CNTRL_READ;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - NBRdSTime) > IntWSTBInitRdMax)
              report "SSMCTM23: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - NBRdSTime) < IntWSTRead)
              report "SSMCTM24: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Continuous read.
      elsif (iLatchSMADDR'event) and (nSMOEN = '0') then
        DataRdy <= '0';
        NBRdSTime    <= now - 1 ns;
        NxtSsmcCntSt     <= ST_CNTRL_READ;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - NBRdSTime) > IntWSTReadMax)
              report "SSMCTM25: Maximum time limit for the non burst read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - NBRdSTime) < IntWSTRead)
              report "SSMCTM26: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        NxtSsmcCntSt     <= ST_CNTRL_READ;
      end if;

    when ST_CNTRL_INTBRSTREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- Burst read finished.
      if (nCS = '1') then
        NxtSsmcCntSt     <= ST_CNTRL_IDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SSMCTM27: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - BRdSTime) < IntWSTBInitRead)
              report "SSMCTM28: Access time violation for Burst Read"
            severity warning;
          end if;
        end if;

      -- Burst access. For burst access lower two address bits remains
      -- unchanged.
      elsif (iLatchSMADDR'event) and (nSMOEN = '0') and (SyncEnRead = '0') and
            (iLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtSsmcCntSt  <= ST_CNTRL_BURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SSMCTM29: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - BRdSTime) < IntWSTBInitRead)
              report "SSMCTM30: Access time violation for Burst Read"
            severity warning;
          end if;
        end if;

      -- Synchronouse burst read.
     elsif (iSyLatchSMADDR'event and (nSMOEN = '0') and
           (SyncEnRead = '1') and (BMRead = '1')) then

-- #      elsif (iSyLatchSMADDR'event and (nSMOEN = '0') and
-- #            (iSyLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3))and
-- #            (SyncEnRead = '1') and (BMRead = '1')) then
        NxtSsmcCntSt  <= ST_CNTRL_BURSTREAD;

      -- Continuous Burst ROM read, but not the burst access.
      elsif ((iLatchSMADDR'event) and (nSMOEN = '0') and
                                      (SyncEnRead = '0')) then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtSsmcCntSt     <= ST_CNTRL_INTBRSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SSMCTM31: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - BRdSTime) < IntWSTBInitRead)
              report "SSMCTM32: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        NxtSsmcCntSt     <= ST_CNTRL_INTBRSTREAD;
      end if;

    -- ST_BURSTREAD
    when ST_CNTRL_BURSTREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- Burst read finished.
      if (nCS = '1') then
        NxtSsmcCntSt     <= ST_CNTRL_IDLE;

        if ((WaitEn = '0') and (SyncEnRead = '0')) then
          if (MaxAccErMask = '0') then
            assert not ((now - BRdSTime) > IntWSTBReadMax)
              report "SSMCTM33: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - BRdSTime) < IntWSTBRead)
              report "SSMCTM34: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Burst access. For burst access lower two address bits remains
      -- unchanged.
      elsif (iLatchSMADDR'event and (nSMOEN = '0') and (SyncEnRead = '0') and
            (iLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3))) then
       DataRdy      <= '0';
       BRdSTime     <= now;
       NxtSsmcCntSt <= ST_CNTRL_BURSTREAD;

       if (WaitEn = '0') then
         if (MaxAccErMask = '0') then
           assert not ((now - BRdSTime) > IntWSTBReadMax)
             report "SSMCTM35: Maximum time limit for the burst read access" &
                              " has exceeded"
           severity warning;
         end if;

         if (AccErMask = '0') then
           assert not ((now - BRdSTime) < IntWSTBRead)
             report "SSMCTM36: Access time violation for Read"
           severity warning;
         end if;
       end if;

      -- Continuous Burst ROM read, but not the burst access.
      elsif ((iLatchSMADDR'event) and (nSMOEN = '0') and
             (SyncEnRead = '0')) then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtSsmcCntSt <= ST_CNTRL_INTBRSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert not ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SSMCTM37: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert not ((now - BRdSTime) < IntWSTBInitRead)
              report "SSMCTM38: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Synchronous read access.In case of synchronous read addrvalid signal
      -- will get asserted for one clock cycle.
      -- Address will be latched for incrementing internally.
      elsif (iSyLatchSMADDR'event and (nSMOEN = '0') and
            (iSyLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3))and
            (SyncEnRead = '1') and (BMRead = '1')) then
        DataRdy       <= '1';
        NxtSsmcCntSt  <= ST_CNTRL_BURSTREAD;
      else
        NxtSsmcCntSt          <= ST_CNTRL_BURSTREAD;
      end if;

    -- ST_WRITE
    when ST_CNTRL_WRITE =>
      RdCountDown <= '0';
      DataRdy <= '0';
      -- Write cycle finished. Data in the SMDATA bus, is written into
      -- the memory element pointed by the SMADDR value by using the rising
      -- edge of the write signal.
      if (nWR = '1') then
        NxtSsmcCntSt         <= ST_CNTRL_IDLE;
        if (WaitEn = '0') then
          assert not ((now - WrSTime) < IntWSTWrite)
            report "SSMCTM41: Access time violation for write"
          severity warning;

          assert not ((now - WrSTime) > IntWSTWriteMax)
            report "SSMCTM42: Maximum time limit for write access has exceeded"
          severity warning;
        end if;
      else
        NxtSsmcCntSt         <= ST_CNTRL_WRITE;
      end if;

    -- Synchronous write
    when ST_CNTRL_SYWRITE =>

    WrCountDown <= '1';
    if (WrCount = 0) then
      DataWrRdy <= '1';
    end if;

      if (nCS = '1') then
        NxtSsmcCntSt         <= ST_CNTRL_IDLE;
        -- Synchronouse Burst write started.
        -- SMADDR line latched at SMADDRVALID and the address bieng increamented
        -- internally at SMCLK.
      elsif (iSyLatchSMADDR'event and (WEnLatched = '1') and
            (iSyLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3))and
            (SyncEnWrite = '1')) then
        NxtSsmcCntSt        <= ST_CNTRL_BURSTWRITE;
      else
       -- Synchronous write being done after the SMADDRVALID signal asserted and
       -- and SMADDR will be latched.
        NxtSsmcCntSt        <= ST_CNTRL_SYWRITE;
      end if;

    -- Synchronous burst write
    when ST_CNTRL_BURSTWRITE =>
      DataWrRdy <= '1';
      if (nCS = '1') then
        NxtSsmcCntSt        <= ST_CNTRL_IDLE;
      elsif (iSyLatchSMADDR'event and (WEnLatched = '1') and
         (iSyLatchSMADDR(10 downto 3) = OldLatchSMADDR(10 downto 3))and
         (SyncEnWrite = '1')) then
        NxtSsmcCntSt        <= ST_CNTRL_BURSTWRITE;
      end if;
    -- default state.
    when others =>
      WrCountDown <= '0';
      RdCountDown <= '0';
      DataRdy     <= '0';
      DataWrRdy   <= '1';
      NxtSsmcCntSt       <= ST_CNTRL_IDLE;
  end case;
end process p_RdWrComb;

-- -----------------------------------------------------------------------------
-- Capture read data
-- -----------------------------------------------------------------------------
p_SSMCDATAComb : process (WaitEn, DataRdy, RdCountDown, MemRdDataDW)
begin
  if (WaitEn = '1' and RdCountDown = '1') then
    if (MW = EIGHT) then
      SMDATA(7 downto 0) <= MemRdDataDW(7 downto 0);
      SMDATA(31 downto 8) <= (others => 'Z');
    elsif (MW = SIXTEEN) then
      SMDATA(15 downto 0) <= MemRdDataDW(15 downto 0);
      SMDATA(31 downto 16) <= (others => 'Z');
    else
      SMDATA <= MemRdDataDW;
    end if;
  elsif (DataRdy = '1') then
    if (MW = EIGHT) then
      SMDATA(7 downto 0) <= MemRdDataDW(7 downto 0);
      SMDATA(31 downto 8) <= (others => 'Z');
    elsif (MW = SIXTEEN) then
      SMDATA(15 downto 0) <= MemRdDataDW(15 downto 0);
      SMDATA(31 downto 16) <= (others => 'Z');
    else
      SMDATA <= MemRdDataDW;
    end if;
  elsif (RdCountDown = '1') then
    if (XonSMDATA = '0') then
      if (MW = EIGHT) then
        SMDATA(7 downto 0) <= DefData(7 downto 0);
        SMDATA(31 downto 8) <= (others => 'Z');
      elsif (MW = SIXTEEN) then
        SMDATA(15 downto 0) <= DefData(15 downto 0);
        SMDATA(31 downto 16) <= (others => 'Z');
      else
        SMDATA <= DefData;
      end if;
    else
      SMDATA <= (others => 'X');
    end if;
  else
    SMDATA <= (others => 'Z');
  end if;
end process p_SSMCDATAComb;

-- -----------------------------------------------------------------------------
-- Read Wait selector
-- -----------------------------------------------------------------------------
p_WstReadComb : process (NxtSsmcCntSt, ALatched,
                         SMTrBWSTBRDR, SMTrBWSTRDR, SMTrBWSTOENR )
begin
  if (NxtSsmcCntSt = ST_CNTRL_BURSTREAD) then
    if (ALatched = '0') then
      WstRead <= unsigned(SMTrBWSTBRDR);
    else
      WstRead <= "00000";
    end if;
  else
    if (ALatched = '0') then
      WstRead <= unsigned(SMTrBWSTRDR) - unsigned('0' & SMTrBWSTOENR);
    else
      WstRead <= unsigned(SMTrBWSTRDR) - unsigned('0' & SMTrBWSTOENR) + 1;
    end if;
  end if;
end process p_WstReadComb;

-- -----------------------------------------------------------------------------
-- Read Counter
-- -----------------------------------------------------------------------------
p_RdCntrSeq : process (HRESETn, DelSMCLK)
begin
  if (HRESETn = '0') then
    RdCount <= (others => '1');
  elsif (DelSMCLK'event and DelSMCLK = '0') then
    if (RdCountDown = '1') then
      if (RdCount = 0) then
        RdCount <= WstRead;
      else
        RdCount <= RdCount - 1;
      end if;
    else
      RdCount <= WstRead;
    end if;
  end if;
end process p_RdCntrSeq;

-- -----------------------------------------------------------------------------
-- Write Wait
-- -----------------------------------------------------------------------------
p_WstWriteComb : process (NxtSsmcCntSt, SMTrBWSTWRR, SMTrBWSTWENR)
begin
  if ((NxtSsmcCntSt = ST_CNTRL_SYWRITE) and (RBLE = '0')) then
    WstWrite <= unsigned(SMTrBWSTWRR) + 1;
  elsif ((NxtSsmcCntSt = ST_CNTRL_SYWRITE) and (RBLE = '1')) then
    WstWrite <= unsigned(SMTrBWSTWRR) - unsigned('0' & SMTrBWSTWENR) + 1;
  end if;
end process p_WstWriteComb;

-- -----------------------------------------------------------------------------
-- Write Counter
-- -----------------------------------------------------------------------------
p_WrCntrSeq : process (HRESETn, DelSMCLK)
-- #p_WrCntrSeq : process (HRESETn, DelSMCLK, nCS)
begin
  if (HRESETn = '0') then
    WrCount <= (others => '1');
  elsif (DelSMCLK'event and DelSMCLK = '0') then
    if (WrCountDown = '1') then
      if (WrCount = 0) then
        WrCount <= WstWrite;
      else
        WrCount <= WrCount - 1;
      end if;
   else
-- #     elsif (nCS = '0') then
       WrCount <= WstWrite;
    end if;
  end if;
end process p_WrCntrSeq;
-- -----------------------------------------------------------------------------
-- Synchronous memory address incrementing.
-- -----------------------------------------------------------------------------
p_SyncAddrIncrSeq : process (DelSMCLK, HRESETn)
begin
 if (HRESETn = '0') then
   iSyLatchSMADDR <= (others => '0');
 elsif (DelSMCLK'event and (DelSMCLK = '1') and (nCS = '0')) then
   if ((ALatched = '1') and (StartIncrAddr = '0')) then
     iSyLatchSMADDR <= SyLatchSMADDR;
   elsif ((ALatched = '1') and (StartIncrAddr = '1')) then
     if ((NxtSsmcCntSt = ST_CNTRL_SYWRITE) and (WEnLatched = '1')) then
       if ((BWtLatched2 = '0') and (DataWrRdy = '1')) then
         iSyLatchSMADDR   <= unsigned(iSyLatchSMADDR) + 1;
       else
         iSyLatchSMADDR   <= iSyLatchSMADDR;
       end if;
     elsif ((NxtSsmcCntSt = ST_CNTRL_BURSTWRITE) and (WEnLatched = '1')) then
  -- #     if (BWt = '0') then
       if (BWtLatched = '0') then
         iSyLatchSMADDR   <= unsigned(iSyLatchSMADDR) + 1;
       else
         iSyLatchSMADDR   <= iSyLatchSMADDR;
       end if;
     elsif (NxtSsmcCntSt = ST_CNTRL_INTBRSTREAD) then
       if (BWtFlag = '0') then
         if ((RdCount = 0) and (BWt = '0')) then
           if (WrapAct = '0') then
             iSyLatchSMADDR   <= unsigned(iSyLatchSMADDR) + 1;
           else
             if (MW = SIXTEEN) then
               iSyLatchSMADDR(3 downto 0) <= "0000";
             elsif (MW = THIRTYTWO) then
               iSyLatchSMADDR(2 downto 0) <= "000";
             end if;
           end if;    
         else
           iSyLatchSMADDR   <= iSyLatchSMADDR;
         end if;
       elsif ((AddrEvent = 1) and (BWt = '1')) then
         iSyLatchSMADDR   <= iSyLatchSMADDR;
       else
         if (BWtLatched2 = '0') then
           iSyLatchSMADDR   <= unsigned(iSyLatchSMADDR) + 1;
         else
           iSyLatchSMADDR   <= iSyLatchSMADDR;
         end if;
       end if;
     elsif (NxtSsmcCntSt = ST_CNTRL_BURSTREAD) then
       if (BWtFlag = '0') then
         if ((RdCount = 0) and (BWt = '0')) then
           if (WrapAct = '0') then
             iSyLatchSMADDR   <= unsigned(iSyLatchSMADDR) + 1;
           else
             if (MW = SIXTEEN) then
               iSyLatchSMADDR(3 downto 0) <= "0000";
             elsif (MW = THIRTYTWO) then
               iSyLatchSMADDR(2 downto 0) <= "000";
             end if;
           end if;
         else
           iSyLatchSMADDR   <= iSyLatchSMADDR;
         end if;
       else
         if (BWtLatched2 = '0') then
           iSyLatchSMADDR   <= unsigned(iSyLatchSMADDR) + 1;
         else
           iSyLatchSMADDR   <= iSyLatchSMADDR;
         end if;
       end if;
     elsif (NxtSsmcCntSt = ST_CNTRL_IDLE) then
       iSyLatchSMADDR <= SyLatchSMADDR;
     end if;
   end if;
 elsif (nCS = '1') then
   iSyLatchSMADDR <= "00000111111"; 
 end if;
end process p_SyncAddrIncrSeq;

-- -----------------------------------------------------------------------------
-- SMTrIND signal logic
-- -----------------------------------------------------------------------------
p_INDComb : process (iSyLatchSMADDR)
begin
  if (iSyLatchSMADDR(4 downto 0) = "11111") then
    SMTrIND <= '0';
  else
    SMTrIND <= '1';
  end if;
end process p_INDComb;

-- -----------------------------------------------------------------------------
-- WrapRead access process
-- -----------------------------------------------------------------------------
p_WrapReadComb : process (WrapRead, MW, iSyLatchSMADDR)
begin
  case MW is
    when "01" =>
      if ((WrapRead = '1') and (iSyLatchSMADDR(3 downto 0) = "1111")) then
        WrapAct <= '1';
      else
        WrapAct <= '0';
      end if;
    when "10" =>
      if ((WrapRead = '1') and (iSyLatchSMADDR(2 downto 0) = "111")) then
        WrapAct <= '1';
      else
        WrapAct <= '0'; 
      end if;
    when others =>
        WrapAct <= '0';
  end case;
end process p_WrapReadComb;

-- -----------------------------------------------------------------------------
-- Beat counter process
-- -----------------------------------------------------------------------------
p_BeatcountComb : process (BeatNo, nCS, iSyLatchSMADDR, BWt, ALatched,
                           WrCount, RdCount, SyncEnRead, SyncEnWrite,
                           SsmcCntSt, AddrEvent, WEnLatched)
begin
  case BeatNo is
    when "0000" =>
      if (nCS'event and nCS = '0') then
        BwtAssert <= '1';
      elsif (nCS'event and nCS = '1') then
        BwtAssert <= '0';
      end if;
     when "0001" =>
       if (SsmcCntSt = ST_CNTRL_SYWRITE) then
         if ((WrCount = 1) and (WEnLatched = '1')) then
-- #         if ((WrCount = 0) and (WEnLatched = '1')) then
           BwtAssert <= '1';
         elsif (ALatched = '0') then
           BwtAssert <= '0';
         end if;
       end if;
    when others =>
    if (SsmcCntSt = ST_CNTRL_BURSTREAD) then
       if (AddrEvent = (unsigned(BeatNo))) then
         BwtAssert <= '1';
       elsif (ALatched = '0') then
         BwtAssert <= '0';
       end if;
    else
      if (WEnLatched = '1') then
        if (AddrEvent = (unsigned(BeatNo) + 0)) then
          BwtAssert <= '1';
        elsif (ALatched = '0') then
          BwtAssert <= '0';
        end if;
      else
       if ((nCS = '0') and (AddrEvent = (unsigned(BeatNo) + 1))) then
         BwtAssert <= '1';
       elsif (ALatched = '0') then
         BwtAssert <= '0';
       end if;
      end if;
    end if;
  end case;
end process p_BeatcountComb;

-- -----------------------------------------------------------------------------
-- Event counter on address line
-- -----------------------------------------------------------------------------
p_AddrEventComb : process (ALatched, iSyLatchSMADDR)
begin
  if (iSyLatchSMADDR'event and (ALatched = '1')) then
    AddrEvent <= AddrEvent + 1;
  else
    AddrEvent <= "0000";
  end if;
end process p_AddrEventComb;

-- -----------------------------------------------------------------------------
-- Asignment of wait count for nSMBURSTWAIT
-- -----------------------------------------------------------------------------
p_BWtAssnComb : process (BeatNo, NxtSsmcCntSt)
begin
  if (NxtSsmcCntSt = ST_CNTRL_INTBRSTREAD) then
    BWtAssnCount      <= unsigned("00" & SSMCTrBurstWt(3 downto 0)) +
                                  WstRead;
  elsif (NxtSsmcCntSt = ST_CNTRL_SYWRITE) then
    BWtAssnCount      <= unsigned("00" & SSMCTrBurstWt(3 downto 0)) +
                                  WstWrite;
  end if;
end process p_BWtAssnComb;

-- -----------------------------------------------------------------------------
-- Flag signal to be used to indicate nSMBurstWait assertion
-- -----------------------------------------------------------------------------
p_BWtFlagComb : process (BWt, nCS)
begin
  if (BWt'event and (BWt = '1') and (nCS = '0')) then
    BWtFlag <= '1';
  elsif (nCS'event and (nCS = '1')) then
    BWtFlag <= '0';
  end if;
end process p_BWtFlagComb;

-- -----------------------------------------------------------------------------
-- Assertion of nSMBURSTWAIT
-- -----------------------------------------------------------------------------
p_BURSTWtAssnSeq : process (DelSMCLK, HRESETn, BWtAssnCount)
--p_BURSTWtAssnSeq : process (SMCLK, HRESETn, BWtAssnCount)
begin
 if (HRESETn = '0') then
    nSMBURSTWAIT  <= '1';
    BWt           <= '0';
 elsif (DelSMCLK'event and DelSMCLK = '0') then
   if (((SyncEnWrite = '1') or (SyncEnRead = '1')) and (BWtMask = '0')) then
     if ((BwtAssert = '1') and (nCS = '0')) then
       if (BWtCount = 0) then
           nSMBURSTWAIT  <= '1';
           BWt           <= '0';
       else
           BWtCount     <= BWtCount - 1;
           nSMBURSTWAIT <= '0';
           BWt          <= '1';
       end if;
     end if;
   end if;
 elsif (BWtAssnCount'event) then
   BWtCount <= BWtAssnCount;
 end if;
end process p_BURSTWtAssnSeq;

-- -----------------------------------------------------------------------------
-- Latched version of nSMBURSTWAIT
-- -----------------------------------------------------------------------------
p_BWtLatchedSeq : process (DelSMCLK, HRESETn)
begin
 if (HRESETn = '0') then
    BWtLatched        <= '0';
 elsif (DelSMCLK'event and DelSMCLK = '1') then
   if (BWt = '1') then
     BWtLatched        <= '1';
   else
     BWtLatched        <= '0';
   end if;
 end if;
end process p_BWtLatchedSeq;

-- -----------------------------------------------------------------------------
-- Latched version of nSMBURSTWAIT on the next negetive edge of clock
-- -----------------------------------------------------------------------------
p_BWtLatched2Seq : process (DelSMCLK, HRESETn)
begin
 if (HRESETn = '0') then
    BWtLatched2        <= '0';
 elsif (DelSMCLK'event and DelSMCLK = '0') then
   if (BWtLatched = '1') then
     BWtLatched2        <= '1';
   else
     BWtLatched2        <= '0';
   end if;
 end if;
end process p_BWtLatched2Seq;

-- -----------------------------------------------------------------------------
-- Latch the time when data gets changes
-- -----------------------------------------------------------------------------
p_DatLatchTimeComb : process (SMDATA)
 begin
  if (not(SMDATA(31 downto 0) = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")) then
    DataChangeTime <= now;
  end if;
 end process p_DatLatchTimeComb;

-- -----------------------------------------------------------------------------
-- Base address shifting for comparision.
-- -----------------------------------------------------------------------------
p_SMBaseShiftComb : process (SSMCTrMEMBASE, MW)
begin
  if (MW = EIGHT) then
    ShiftMemBase <= SSMCTrMEMBASE;
  elsif (MW = SIXTEEN) then
    ShiftMemBase <= '0' & SSMCTrMEMBASE(14 downto 1);
  elsif (MW = THIRTYTWO) then
    ShiftMemBase <= "00" & SSMCTrMEMBASE(14 downto 2);
  end if;
end process p_SMBaseShiftComb;

-- -----------------------------------------------------------------------------
-- Address Mux. This process generate the latched address depend on the
-- programed size of the memory width.
-- -----------------------------------------------------------------------------
p_SMAddrLatchComb : process (SMADDR, ShiftMemBase, SMADDRVALID, DataWrRd,
                             AddrValidReadEn, SyncEnRead, AddrValidWriteEn,
                             SyncEnWrite)
begin
  AddChangeTime      <= now;
  if (SMADDR(25 downto 11) = ShiftMemBase) then
    OutofRange <= '0';
      if ((SMADDRVALID = '0') and (AddrValidReadEn = '1') and
          (SyncEnRead = '1') and (DataWrRd = '1')) then
        SyLatchSMADDR   <= SMADDR(10 downto 0);
      elsif ((SMADDRVALID = '0') and (AddrValidWriteEn = '1') and
          (SyncEnWrite = '1') and (DataWrRd = '0')) then
        SyLatchSMADDR   <= SMADDR(10 downto 0);
      else
        iLatchSMADDR      <= SMADDR(10 downto 0);
      end if;
  else
    OutofRange <= '1';
 end if;
end process p_SMAddrLatchComb;

-- -----------------------------------------------------------------------------
-- Address laching for Synchronouse memory operations
-- -----------------------------------------------------------------------------
p_SyncAddrComb : process (ALatchedReg, SMADDRVALID, DelSMADDRVALID,
                          AddrValidReadEn, SyncEnRead, DataWrRd,
                          AddrValidWriteEn, SyncEnWrite, nCS)
begin
  NextALatchedReg <= ALatchedReg;
  if ((SMADDRVALID = '0') and (DelSMADDRVALID = '1')) then
    if ((AddrValidReadEn = '1') and (SyncEnRead = '1') and
        (DataWrRd = '1')) then
      NextALatchedReg <= '1';
    elsif ((AddrValidWriteEn = '1') and (SyncEnWrite = '1') and
           (DataWrRd = '0')) then
      NextALatchedReg <= '1';
    else
      NextALatchedReg <= '0';
    end if;
  elsif (nCS = '1') then
    NextALatchedReg <= '0';
  end if;
end process p_SyncAddrComb;

ALatched <= (NextALatchedReg or ALatchedReg) and (not nCS);

-- -----------------------------------------------------------------------------
-- Start address incrementing internally after 1 clock of ALatched.
-- -----------------------------------------------------------------------------
p_StartIncrAddrSeq : process (HRESETn, DelSMCLK)
begin
  if (HRESETn = '0') then
    StartIncrAddr    <= '0';
    DelSMADDRVALID   <= '1';
    ALatchedReg      <= '0';
  elsif (DelSMCLK'event and (DelSMCLK = '1')) then
   DelSMADDRVALID <= SMADDRVALID;
   ALatchedReg    <= NextALatchedReg;
   if (ALatched = '1') then
     StartIncrAddr    <= '1';
   else
     StartIncrAddr    <= '0';
   end if;
  end if;
end process p_StartIncrAddrSeq;

-- -----------------------------------------------------------------------------
-- nWEN Latching process for sunchronous operation
-- -----------------------------------------------------------------------------
p_SyncWEnLatchComb : process (HRESETn, nSMWEN, nCS)
begin
  if (HRESETn = '0') then
    WEnLatched <= '0';
  elsif (nSMWEN'event and nSMWEN = '0') then
    WEnLatched <= '1';
  elsif (nCS = '1') then
    WEnLatched <= '0';
  end if;
end process p_SyncWEnLatchComb;

-- -----------------------------------------------------------------------------
-- Out of range access warning
-- -----------------------------------------------------------------------------
p_OutofRngComb : process (DelOutofRange, DelnCS)
begin
  if ((DelOutofRange = '1') and (DelnCS = '0') and (DelnCS = nCS)) then
    assert false
      report "SSMCTM43: Accessed location is out of range"
    severity warning;
  end if;
end process p_OutofRngComb;

-- -----------------------------------------------------------------------------
-- Old SSMCADDR
-- -----------------------------------------------------------------------------
p_OldAddrLtchSeq : process (HRESETn, DelSMCLK)
begin
  if (HRESETn = '0') then
    OldLatchSMADDR <= (others => '0');
  elsif (DelSMCLK'event and DelSMCLK = '0') then
    if (ALatched = '1') then
     OldLatchSMADDR <= iSyLatchSMADDR;
    else
     OldLatchSMADDR <= iLatchSMADDR;
    end if;
 end if;
end process p_OldAddrLtchSeq;

-- -----------------------------------------------------------------------------
-- nSMBLS check during read. During read cycle nSMBLS should be "1111" when
-- RBLE = '0' and nSMBLS should be "0000" when RBLE = '1'
-- -----------------------------------------------------------------------------
p_SMBLSChkComb : process (nSMBLS, DelnSMBLS, Del1nSMOEN, nSMOEN,
                          RBLE, nCS)
begin
  if (((Del1nSMOEN or nSMOEN) = '0') and (nCS = '0')) then
    if ((RBLE = '0') and ((nSMBLS < "1111") and (DelnSMBLS < "1111"))) then
      assert false
        report "SSMCTM44: nSMBLS violation when RBLE = '0' during read"
      severity warning;
    end if;

    if ((RBLE = '1') and ((nSMBLS > "0000") and (DelnSMBLS > "0000"))) then
      assert false
        report "SSMCTM45: nSMBLS violation when RBLE = '1' during read"
      severity warning;
    end if;
  end if;
end process p_SMBLSChkComb;

-- -----------------------------------------------------------------------------
-- Assign local copy to the output
-- -----------------------------------------------------------------------------
p_SMADDRMuxComb : process (iLatchSMADDR, iSyLatchSMADDR, ALatched)
-- # p_SMADDRMuxComb : process (iLatchSMADDR, iSyLatchSMADDR, ALatched, nCS)
begin
  if (ALatched = '1') then
    LatchSMADDR <= iSyLatchSMADDR;
-- #  elsif (nCS = '0') then
-- #    LatchSMADDR <= iLatchSMADDR;
  else
    LatchSMADDR <= iLatchSMADDR;
  end if;
end process p_SMADDRMuxComb;
-- -----------------------------------------------------------------------------

end behavioural;

-- --================================== End ==================================--
