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
-- File Name              : SmcTrMemRdWrCtl.vhd.rca
-- File Revision          : 1.14
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block Interfaces the SMC with the memory modules
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SmcTrPackage.all;

-- -----------------------------------------------------------------------------

entity SmcTrMemRdWrCtl is
  generic (
           Tclk             : time := 10.52 ns  -- HCLK Period
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        nHCLK            : in    std_logic; -- AHB Bus Clock (Inverted)
        HSIZE            : in    std_logic_vector(2 downto 0);
        HRESETn          : in    std_logic; -- Bus Reset
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- Address Bus to Memory
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- Memory Bus Enable
        SMCTrCS          : in    std_logic; -- Bank select
        SMCTrAllCS       : in    std_logic_vector(7 downto 0);
                                            -- The status of all the 8 banks
                                            -- connected with the SMC
        nSMWEN           : in    std_logic; -- Write enable
        nSMBLS           : in    std_logic_vector(3 downto 0);
                                            -- Byte lane select
        nSMOEN           : in    std_logic; -- Output enable
        MemRdDataDW      : in    std_logic_vector(31 downto 0);
                                            -- SMC read data
        SMCTrIDCY        : in    std_logic_vector(4 downto 0);
                                            -- Memory Data Bus turn
                                            -- around time
        SMCTrWST1        : in    std_logic_vector(5 downto 0);
                                            -- Read access/Initial access time
        SMCTrWST2        : in    std_logic_vector(5 downto 0);
                                            -- Write access/Burst read access
                                            -- time
        SMCTrMEMT        : in    std_logic_vector(10 downto 0);
                                            -- Memory type
        SMCTrMEMB        : in    std_logic_vector(14 downto 0);
                                            -- Memory Base Address
        SMCTrCS2OEN      : in    std_logic_vector(4 downto 0);
                                            -- CS-nSMOEN assertion delay
        SMCTrCS2WEN      : in    std_logic_vector(4 downto 0);
                                            -- CS-nSMWEN assertion delay
        SMCTrCSPOL       : in    std_logic_vector(7 downto 0);
                                            -- Chip Select polarity

-- Inouts
        SMDATA           : inout std_logic_vector(31 downto 0);
                                            -- Memory Data Bus

-- Outputs
        LatchSMADDR      : out   std_logic_vector(12 downto 0);
                                            -- Latched SMC Address
        SMCActLowCS      : out   std_logic  -- Used for suitably routing the
                                            -- SMWAIT signal
       );
end SmcTrMemRdWrCtl;

-- -----------------------------------------------------------------------------
--
--                               SmcTrMemRdWrCtl
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block constitutes the main control block in the SMC trickbox.
-- Depending on the content of the SMCTrMEMT register this block model the
-- memory module as SRAM, ROM or BURST ROM. It is possible to program the
-- trickbox as a memory of data size 8-bit, 16-bit and 32-bit. This module
-- contains all memory related signals given by the SMC. All memory related
-- timing parameters are checked in this module. Facility to display error
-- messages, if any violation happened are also provided.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of SmcTrMemRdWrCtl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant EIGHT            : std_logic_vector(1 downto 0) := "00";
constant SIXTEEN          : std_logic_vector(1 downto 0) := "01";
constant THIRTYTWO        : std_logic_vector(1 downto 0) := "10";

constant SRAM             : std_logic_vector(1 downto 0) := "00";
constant ROM              : std_logic_vector(1 downto 0) := "01";
constant BURSTROM         : std_logic_vector(1 downto 0) := "10";

constant STIDLE           : std_logic_vector(2 downto 0) := "000";
-- IDLE state.

constant STREAD           : std_logic_vector(2 downto 0) := "001";
-- READ state.

constant STINITBURSTREAD  : std_logic_vector(2 downto 0) := "010";
-- Burst read state.

constant STBURSTREAD      : std_logic_vector(2 downto 0) := "011";
-- Burst read state.

constant STWRITE          : std_logic_vector(2 downto 0) := "100";
-- Write state.

constant XonSMDATA        : std_logic := '0';
-- Controls whether 'X' or '0' is driven on SMDATA during read accesses.

constant DefData          : std_logic_vector(31 downto 0)
                            := "11011110101011011011111011101111";
-- Default data to be driven to the SMDATA

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal nWR              : std_logic;
-- Memory write enable.

signal nCS              : std_logic;
-- Memory device enable.

signal XCS              : std_logic_vector(7 downto 0);
-- External Bank Select signal after multiplexion with the CSPolarity

signal nSMBLSWR         : std_logic;
-- Memory write enable when byte lane is using as write enable

signal Wait4WtdAssn     : std_logic;
-- Control signal to time the SMWAIT de-assertion

signal Wait4WtAssn      : std_logic;
-- Control signal to time the SMWAIT assertion

signal RdCountDown      : std_logic;
-- Count Down enable for Read process

signal RdCount          : unsigned(5 downto 0) := "000000";
-- Read count

signal WaitCount        : unsigned(23 downto 0) := "000000000000000000000000";
-- External Wait States counter

signal SmcCntSt         : std_logic_vector(2 downto 0) := "000";
-- State register.

signal NxtSmcCntSt     : std_logic_vector(2 downto 0) := "000";
-- D-input for State register.

signal IntIDCY          : time := 1 ms;
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

signal ExtCsAssernTime     : time := 0 ns;
-- time when csel gets asserted.

signal CsDeAssernTime     : time := 0 ns;
-- Latch the time when csel gets deasserted.

signal OenChgTime       : time := 0 ns;
-- Latch the time when OEn is deasserted.

signal AddChangeTime    : time := 0 ns;
-- Latch the time when address changes.

signal BAddChangeTime    : time := 0 ns;
-- Address change time delayed.

signal LastAddChgTime   : time := 0 ns;
-- Latch the time when address changes.

signal iLatchSMADDR     : std_logic_vector(12 downto 0) := "0000000000000";
-- Memory address latch.

signal DelLatchSMADDR   : std_logic_vector(12 downto 0);
-- 2 ns Delayed version of iLatchSMADDR

signal DelnCS           : std_logic;
-- 1 ns Delayed version of nCS

signal DelnSMOEN        : std_logic;
-- 2 ns Delayed version of nSMOEN.

signal Del3nSMOEN       : std_logic;
-- 3 ns Delayed version of nSMOEN.

signal Del1nSMOEN       : std_logic;
-- 1 ns Delayed version of nSMOEN.

signal DelnSMBLS        : std_logic_vector(3 downto 0);
-- 1 ns Delayed version of nSMBLS.

signal OldLatchSMADDR   : std_logic_vector(12 downto 0);
-- Store the old address.

signal WrSTime          : time := 0 ns;
-- Latch the time when write gets start.

signal NBRdSTime        : time := 0 ns;
-- Latch the time when non burst read gets start.

signal BRdSTime         : time := 0 ns;
-- Latch the time when burst read gets start.

signal IdleStartTime    : time := 0 ns;
-- Latch the time when memory idle time start.

signal DataChangeTime   : time := 0 ns;
-- Latch the time when data changes.

signal MEMSIZE          : std_logic_vector(1 downto 0);
-- Width of the Memory model

signal MEMTYPE          : std_logic_vector(1 downto 0);
-- Type of the Memory model (SRAM, ROM, BROM)

signal MaxAccErMask     : std_logic;
-- If set to '1' it will mask the read access maximum time violation message

signal AccErMask        : std_logic;
-- If set to '1' it will mask the read access time violation message.

signal RBLE             : std_logic;
-- Read byte lane enable

signal CSPolarity       : std_logic;
-- Chip Select polarity

signal DataRdy          : std_logic;
-- Data out enable signal

signal WaitEn           : std_logic;
-- SMCTrnWAIT toggle enable bit

signal BoundaryCase     : std_logic;
-- Read-data return time select

signal OutofRange       : std_logic;
-- Memory access out of range indicator

signal ToggSt           : std_logic;
-- State Toggler to trigger the state machine

signal Del1LatchSMADDR   : std_logic_vector(12 downto 0);
-- 1 ns Delayed version of iLatchSMADDR

signal WrOrRdEvent: std_logic;

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
        when '0' =>    null;
        when '1' =>    return_int := return_int + 1;
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
-- SMCTrMEMT Register field rename
-- -----------------------------------------------------------------------------
MEMSIZE          <= SMCTrMEMT(1 downto 0);
MEMTYPE          <= SMCTrMEMT(3 downto 2);
MaxAccErMask     <= SMCTrMEMT(4);
AccErMask        <= SMCTrMEMT(5);
RBLE             <= SMCTrMEMT(6);
CSPolarity       <= SMCTrMEMT(7);
WaitEn           <= SMCTrMEMT(8);
BoundaryCase     <= SMCTrMEMT(10);
nSMBLSWR         <= nSMBLS(0) and nSMBLS(1) and nSMBLS(2) and nSMBLS(3);

-- -----------------------------------------------------------------------------
-- External Bank Select/Polarity Mux
-- -----------------------------------------------------------------------------
p_XCSComb : process (SMCTrCSPOL, SMCTrAllCS)
begin
  for i in 7 downto 0 loop
    if (SMCTrCSPOL(i) = '0') then
      XCS(i) <= not (SMCTrAllCS(i));
    else
      XCS(i) <= SMCTrAllCS(i);
    end if;
  end loop;
end process p_XCSComb;

-- -----------------------------------------------------------------------------
-- Chip Select/Polarity Mux
-- -----------------------------------------------------------------------------
p_nCSComb : process (CSPolarity, SMCTrCS)
begin
  if (CSPolarity = '0') then
    nCS <= SMCTrCS;
  else
    nCS <= not (SMCTrCS);
  end if;
end process p_nCSComb;

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
IntIDCY           <= (ToInteger(SMCTrIDCY) + 1) * Tclk;

IntWSTRead        <= ((ToInteger(SMCTrWST1) + 1) * Tclk - 2 ns);

IntWSTWrite       <= ToInteger(SMCTrWST2) * Tclk + Tclk/2;

IntWSTBInitRead   <= ((ToInteger(SMCTrWST1) + 1) * Tclk - 2 ns);

IntWSTBRead       <= ((ToInteger(SMCTrWST2) + 1) * Tclk - 2 ns);

IntCS2OEN         <= (ToInteger(SMCTrWST1) * Tclk) when
                        (SMCTrWST1(4 downto 0) < SMCTrCS2OEN)
                  else (ToInteger(SMCTrWST2) * Tclk) when
                        ((MEMTYPE(1) = '1') and
                         (SMCTrWST2(4 downto 0) < SMCTrCS2OEN))
                  else (ToInteger(SMCTrCS2OEN) * Tclk);

IntCS2WEN         <= ((ToInteger(SMCTrCS2WEN) * Tclk) + Tclk/2)
                  when (SMCTrWST2(4 downto 0) > SMCTrCS2WEN)
                  else ((ToInteger(SMCTrWST2) * Tclk) + Tclk/2);

-- -----------------------------------------------------------------------------
-- Calculate the maximum allowable time for read and write access.
-- -----------------------------------------------------------------------------
IntWSTReadMax     <= IntWSTRead  + 1*Tclk + DelayTime;
IntWSTWriteMax    <= IntWSTWrite + 2*Tclk + DelayTime;
IntWSTBReadMax    <= IntWSTBRead + 1*Tclk + DelayTime;
IntWSTBInitRdMax  <= IntWSTBInitRead + 1*Tclk + DelayTime;

-- -----------------------------------------------------------------------------
-- Generate the delayed version of signals
-- -----------------------------------------------------------------------------
DelLatchSMADDR   <= iLatchSMADDR after 2 ns;
Del1LatchSMADDR  <= iLatchSMADDR after 1 ns;
DelnCS           <= nCS after 1 ns;
Del3nSMOEN       <= nSMOEN after 3 ns;
DelnSMOEN        <= nSMOEN after 2 ns;
Del1nSMOEN       <= nSMOEN after 1 ns;
DelnSMBLS        <= nSMBLS after 1 ns;
DelExtBankActive <= ExtBankActive after 2 ns;

-- -----------------------------------------------------------------------------
-- ExtBankActive becomes high when any other chip selects becomes enabled.
-- -----------------------------------------------------------------------------
ExtBankActive     <= (XCS(7) or XCS(6) or XCS(5) or XCS(4) or
                      XCS(3) or XCS(2) or XCS(1) or XCS(0)) and nCS;

-- -----------------------------------------------------------------------------
-- Latch the time when access starts
-- -----------------------------------------------------------------------------
p_AccSTimeComb : process (nCS)
begin
  if (nCS'event and nCS = '0') then
    AccessSTime <= now;
  end if;
end process p_AccSTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when write gets finish
-- -----------------------------------------------------------------------------
p_WrEndTimeComb : process (nWR)
begin
  if (nWR'event and nWR = '1') then
    WrEndTime <= now;
  end if;
end process p_WrEndTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when Read gets finish
-- -----------------------------------------------------------------------------
p_RdEndTimeComb : process (nSMOEN)
begin
  if (nSMOEN'event and nSMOEN = '1' and DelnCS = '0') then
    RdEndTime <= now;
  end if;
end process p_RdEndTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when OEN is deasserted
-- -----------------------------------------------------------------------------
p_OenChgComb : process (nSMOEN)
begin
  if (nSMOEN'event and nSMOEN = '1' and DelnCS = '0') then
    OenChgTime <= now;
  end if;
end process p_OenChgComb;

-- -----------------------------------------------------------------------------
-- Latch the time when Chipselct gets deasserted after Read gets finish
-- -----------------------------------------------------------------------------
p_CsDeassert: process 
begin
  wait on nSMOEN;
  if (DelnCS = '0') then
    wait on DelnCS;
    CsDeAssernTime <= now;
  end if;
end process p_CsDeassert;

-- -----------------------------------------------------------------------------
-- Latch the time when chip inactive
-- -----------------------------------------------------------------------------
p_IdlStrtTimeComb : process (DelnCS)
begin
  if (DelnCS'event and DelnCS = '1') then
    IdleStartTime <= now - 2 ns;
  end if;
end process p_IdlStrtTimeComb;

-- -----------------------------------------------------------------------------
-- During the write cycle address should not change. Also in this design
-- nSMOEN is never enabled when write is enabled.
-- -----------------------------------------------------------------------------
assert NOT ((nSMOEN = '0') and (nWR = '0') and (nCS = '0'))
  report "SMCTM1: Read enable and write enable are asserted at the same time"
severity warning;

assert NOT (SMADDR'event and nWR = '0' and (nCS = '0'))
  report "SMCTM2: Address changed when write enable was active"
severity warning;

-- -----------------------------------------------------------------------------
-- During the read cycle chip select should not change. This particular design
-- is not supporting the chip select controlled write.
-- -----------------------------------------------------------------------------
p_CsStatusCheck : process
begin
  wait on nCS;
  if (nCS = '1') then
    wait for DelayTime;

    if (nWR = '0') then
      assert NOT ((now - 2*Tclk) > WrEndTime)
        report "SMCTM3: Chip select controlled write"
        severity warning;
    end if;

    if (nSMOEN = '0') then
      assert NOT ((now - 2*Tclk) > RdEndTime)
        report "SMCTM4: Chip select changed during read was active"
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
      if (nWR = '0') then
        assert false
          report "SMCTM41: Output Enable and Write Enable are asserted together"
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
  wait on ExtBankActive ;
  if ((DelExtBankActive = '0') and (ExtBankActive = '1')) then
    wait for DelayTime;
    assert NOT ((now - CsDeAssernTime) < IntIDCY)
      report "SMCTM5: Bank to Bank idle time violation"
      severity warning;
  end if;
end process p_IdleBetBank;

-- -----------------------------------------------------------------------------
-- Checking the address and data hold time with resepect to the rising edge
-- of write signal.
-- -----------------------------------------------------------------------------
assert NOT (SMADDR'event and (nCS = '0') and
            ((now - WrEndTime) < AddWrHoldTime))
  report "SMCTM6: Address hold time violation"
severity warning;

assert NOT ((now > 0 ns) and SMDATA'event and (nCS = '0') and
           ((now - WrEndTime) < DataWrHoldTime))
  report "SMCTM7: Data hold time violation"
severity warning;

assert NOT (WrEndTime'event and (now > 100 ns) and (nCS = '0') and
           ((WrEndTime - DataChangeTime) < DataWrSetupTime))
  report "SMCTM8: Data setup time violation"
severity warning;
-- -----------------------------------------------------------------------------
-- State transition process
-- -----------------------------------------------------------------------------
p_RdWrSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    SmcCntSt <= STIDLE;
    ToggSt    <= '0';
  elsif (HCLK'event and HCLK = '0') then
    SmcCntSt <= NxtSmcCntSt;
    ToggSt    <= not ToggSt;
  end if;
end process p_RdWrSeq;

-- -----------------------------------------------------------------------------
-- Next State generation process
-- -----------------------------------------------------------------------------
p_RdWrComb : process (iLatchSMADDR, nWR, nSMOEN, nCS, OutofRange,
                      SmcCntSt, RdCount, ToggSt)
begin
  case SmcCntSt is

    -- IDLE STATE
    when STIDLE =>
      RdCountDown <= '0';
      DataRdy     <= '0';
      if (nCS = '0') then
        -- Write cycle started.
        if (OutofRange = '1') then
          NxtSmcCntSt <= STIDLE;
        else
          if (nWR = '0') then
            assert NOT ((now - (RdEndTime - 1 ns)) < IntIDCY)
              report "SmcTM9: Read to write idle time violation"
            severity warning;

            assert NOT ((now - AddChangeTime) < AddWrSetupTime)
              report "SmcTM10: Address set up time violation"
            severity warning;

            if (WaitEn = '0') then
              assert NOT ((now - AccessSTime) < IntCS2WEN)
                report "SmcTM11: Chip Select to Write Enable assertion time" &
                       " violation"
                severity warning;
            end if;

            -- Write is allowed only when memory is configured as SRAM.
            if (MEMTYPE(0) = '0') then
              NxtSmcCntSt <= STWRITE;
              WrSTime  <= now - IntCS2WEN - 2 ns;

               -- If the programmed memory size is
               -- 8-bit then only one write enable is active at a time.
               -- 16-bit then either nSMBLS(0) and nSMBLS(1) or
               -- nSMBLS(2) and nSMBLS(3) are high at all time

               if ((MEMSIZE = EIGHT) and (nCS = '0')) then
                 assert NOT ((nSMBLS(3) and nSMBLS(2) and
                              nSMBLS(1)) = '0')
                   report "SmcTM12: Write enable violation for an 8-bit memory"
                 severity warning;

               elsif ((MEMSIZE = SIXTEEN) and (nCS = '0')) then
                 assert NOT ((nSMBLS(3) and nSMBLS(2)) = '0')
                   report "SmcTM13: Write enable violation for a 16-bit memory"
                 severity warning;
               end if;
            else
              NxtSmcCntSt <= STIDLE;
              assert false
                report "SmcTM14: Write is not supported"
              severity warning;
            end if;

          -- Read cycle started.
          elsif (nSMOEN = '0') then
            assert NOT ((now - WrEndTime) < (Tclk - 2 ns))
              report "SmcTM15: Write to read idle time violation"
              severity warning;
            if (WaitEn = '0') then
              assert NOT ((now - (AccessSTime)) < IntCS2OEN)
                report "SmcTM16: Chip Select to Output Enable assertion time" &
                       " violation"
                severity warning;
            end if;

            NBRdSTime <= now - IntCS2OEN - 2 ns;

            if (MEMTYPE(1) = '1') then
              NxtSmcCntSt <= STINITBURSTREAD;
              BRdSTime    <= now - IntCS2OEN - 2 ns;
            else
              NxtSmcCntSt <= STREAD;
            end if;
          else
            NxtSmcCntSt <= STIDLE;
          end if;
        end if;
      end if;

    -- ST_READ
    when STREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- Read cycle finished.
      if (nSMOEN = '1') then
        NxtSmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - LastAddChgTime) > IntWSTReadMax)
              report "SmcTM17: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "SmcTM18: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- BURST access. In case of BURST access higher order address will
      -- not change.
      elsif (iLatchSMADDR'event) and (nSMOEN = '0') and
            (iLatchSMADDR(10 downto 2) = OldLatchSMADDR(10 downto 2)) then
        DataRdy <= '0';
        NBRdSTime    <= now - 1 ns;
        NxtSmcCntSt  <= STREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - LastAddChgTime) > IntWSTReadMax)
              report "SmcTM19: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BAddChangeTime) < IntWSTRead)
              report "SmcTM20: Access time violation for the read"
            severity warning;
          end if;
        end if;

      -- Continuous read.
      elsif (iLatchSMADDR'event) and (nSMOEN = '0') then
        DataRdy <= '0';
        NBRdSTime    <= now - 1 ns;
        NxtSmcCntSt     <= STREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - LastAddChgTime) > IntWSTReadMax)
              report "SmcTM21: Maximum time limit for the non burst mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - LastAddChgTime) < IntWSTRead)
              report "SmcTM22: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        NxtSmcCntSt     <= STREAD;
      end if;

    -- Initial Burst read
    when STINITBURSTREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- Burst read finished.
      if (nCS = '1') then
        NxtSmcCntSt     <= STIDLE;

      elsif (nSMOEN'event and nSMOEN = '1') then
        DataRdy <= '0';
        NxtSmcCntSt  <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT (((now - LastAddChgTime) > IntWSTBInitRdMax) and
                         (RdEndTime < LastAddChgTime))
              report "SmcTM25: Maximum time limit for the Burst mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AccessSTime) < IntWSTBInitRead)
              report "SmcTM26: Access time violation for Burst mode Read"
            severity warning;
          end if;
        end if;

      -- Burst mode access. For Burst access lower two address bits remains
      -- unchanged.
      elsif (iLatchSMADDR /= OldLatchSMADDR) and (nSMOEN = '0') and
            (iLatchSMADDR(12 downto 2) = OldLatchSMADDR(12 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtSmcCntSt  <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((LastAddChgTime> RdEndTime) and
                        (now - LastAddChgTime) > IntWSTBInitRdMax)
              report "SmcTM27: Maximum time limit for the BURST read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AccessSTime) < IntWSTBInitRead)
              report "SmcTM28: Access time violation for BURST Read"
            severity warning;
          end if;
        end if;

      -- BURST read access with nSMOEN deasserted between transfers
      elsif (iLatchSMADDR /= OldLatchSMADDR) and (nSMOEN = '1') and
            (iLatchSMADDR(12 downto 2) = OldLatchSMADDR(12 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtSmcCntSt  <= STBURSTREAD;

      -- Continuous page mode ROM read, but not the burst access.
      elsif (iLatchSMADDR /= OldLatchSMADDR) and (nSMOEN = '0') then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtSmcCntSt     <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT (((now - LastAddChgTime) > IntWSTBInitRdMax) and
                        ((now - OenChgTime) > IntWSTBInitRdMax))
              report "SmcTM29: Maximum time limit for the Burst mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - LastAddChgTime) < IntWSTBInitRead)
              report "SmcTM30: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        NxtSmcCntSt     <= STINITBURSTREAD;
      end if;

    -- ST_BURSTREAD
    when STBURSTREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- page mode read finished.
      if (nCS = '1') or ((nSMOEN = '1') and (HSIZE < MEMSIZE))  then
        NxtSmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BAddChangeTime) > IntWSTBReadMax)
              report "SmcTM31: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BAddChangeTime) < IntWSTBRead)
              report "SmcTM32: Access time violation for Read"
            severity warning;
          end if;
        end if;


      -- Burst mode access. For Burst mode access lower two address bits remains
      -- unchanged.
      elsif (iLatchSMADDR /= OldLatchSMADDR) and (nSMOEN = '0') and
            (iLatchSMADDR(10 downto 2) = OldLatchSMADDR(10 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtSmcCntSt     <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT (((now - BAddChangeTime) > IntWSTBReadMax) and
                        (RdEndTime < BAddChangeTime))
              report "SmcTM33: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AccessSTime) < IntWSTBRead)
              report "SmcTM34: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Continuous page mode ROM read, but not the page access.
      elsif (iLatchSMADDR /= OldLatchSMADDR) and (nSMOEN = '0') then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtSmcCntSt <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BAddChangeTime) > IntWSTBReadMax)
              report "SmcTM35: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBRead)
              report "SmcTM36: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        NxtSmcCntSt     <= STBURSTREAD;
      end if;

    -- ST_WRITE
    when STWRITE =>
      RdCountDown <= '0';
      DataRdy <= '0';
      -- Write cycle finished. Data in the SmcDATA bus, is written into
      -- the memory element pointed by the SmcADDR value by using the rising
      -- edge of the write signal.
      if ((nWR = '1') or (nCS = '1')) then
        NxtSmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          assert NOT ((now - WrSTime) < IntWSTWrite)
            report "SmcTM37: Access time violation for write"
          severity warning;

          assert NOT ((now - WrSTime) > IntWSTWriteMax)
            report "SmcTM42: Maximum time limit for write access has exceeded"
          severity warning;
        end if;

      else
        NxtSmcCntSt     <= STWRITE;
      end if;

    -- default state.
    when others =>
      RdCountDown <= '0';
      DataRdy <= '0';
      NxtSmcCntSt       <= STIDLE;
  end case;
end process p_RdWrComb;

-- -----------------------------------------------------------------------------
-- Capture read data
-- -----------------------------------------------------------------------------
p_SMDATAComb : process (WaitEn, DataRdy, RdCountDown, MemRdDataDW)
begin
  if (WaitEn = '1' and RdCountDown = '1') then
    if (MEMSIZE = EIGHT) then
      SMDATA(7 downto 0) <= MemRdDataDW(7 downto 0);
      SMDATA(31 downto 8) <= (others => 'Z');
    elsif (MEMSIZE = SIXTEEN) then
      SMDATA(15 downto 0) <= MemRdDataDW(15 downto 0);
      SMDATA(31 downto 16) <= (others => 'Z');
    else
      SMDATA <= MemRdDataDW;
    end if;
  elsif (DataRdy = '1') then
    if (MEMSIZE = EIGHT) then
      SMDATA(7 downto 0) <= MemRdDataDW(7 downto 0);
      SMDATA(31 downto 8) <= (others => 'Z');
    elsif (MEMSIZE = SIXTEEN) then
      SMDATA(15 downto 0) <= MemRdDataDW(15 downto 0);
      SMDATA(31 downto 16) <= (others => 'Z');
    else
      SMDATA <= MemRdDataDW;
    end if;
  elsif (RdCountDown = '1') then
    if (XonSMDATA = '0') then
      if (MEMSIZE = EIGHT) then
        SMDATA(7 downto 0) <= DefData(7 downto 0);
        SMDATA(31 downto 8) <= (others => 'Z');
      elsif (MEMSIZE = SIXTEEN) then
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
end process p_SMDATAComb;

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
-- Address Mux. This process generate the latched address depend on the
-- programed size of the memory width.
-- -----------------------------------------------------------------------------
p_SMAddrLatchComb : process (SMADDR, MEMSIZE, SMCTrMEMB)
begin
  AddChangeTime      <=  now ;
  if (SMADDR(25 downto 11) <= SMCTrMEMB) then
    OutofRange <= '0';
      iLatchSMADDR      <= SMADDR(12 downto 0);
  else
    OutofRange <= '1';
    if ((DelnCS = '0') and (DelnCS = nCS)) then
      assert false
        report "SMCTM38: Accessed location is out of range"
        severity warning;
    end if;
  end if;
  BAddChangeTime    <=  now after 2 ns;
end process p_SMAddrLatchComb;
-- -----------------------------------------------------------------------------
-- Old SMADDR
-- -----------------------------------------------------------------------------
p_OldAddrLtchComb : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    OldLatchSMADDR <= (others => '0');
  elsif (HCLK'event and HCLK = '0') then
    OldLatchSMADDR <= iLatchSMADDR;
  end if;
end process p_OldAddrLtchComb;
-- -----------------------------------------------------------------------------
-- Store the time when the address changed
-- -----------------------------------------------------------------------------
p_OldAddrTimeComb : process (OldLatchSMADDR,nCS)
begin
  if ((nCS'event and nCS = '0') or (OldLatchSMADDR'event)) then
    LastAddChgTime <= now;
  end if;
end process p_OldAddrTimeComb;

-- -----------------------------------------------------------------------------
-- nSMBLS check during read. During read cycle nSMBLS should be "1111" when
-- RBLE = '0' and nSMBLS should be "0000" when RBLE = '1'
-- -----------------------------------------------------------------------------
p_SMBLSChkComb : process (nSMBLS, DelnSMBLS, Del1nSMOEN, nSMOEN, RBLE, nCS)
begin
  if (((Del1nSMOEN or nSMOEN) = '0') and (nCS = '0')) then
    if ((RBLE = '0') and ((nSMBLS < "1111") and (DelnSMBLS < "1111"))) then
      assert false
        report "SMCTM39: nSMBLS violation when RBLE = '0' during read"
      severity warning;
    end if;

    if ((RBLE = '1') and ((nSMBLS > "0000") and (DelnSMBLS > "0000"))) then
      assert false
        report "SMCTM40: nSMBLS violation when RBLE = '1' during read"
      severity warning;
    end if;
  end if;
end process p_SMBLSChkComb;

-- -----------------------------------------------------------------------------
-- Assign local copy to the output
-- -----------------------------------------------------------------------------
LatchSMADDR        <= iLatchSMADDR;
SMCActLowCS        <= nCS;

end behavioural;

-- --================================== End ==================================--
