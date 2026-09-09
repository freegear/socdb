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
-- File Name              : MpmcTrMemRdWrCtl.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block controls the read-write operations of the TrickMem
--           memory model. This also performs the memory protocol checks.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.MpmcTrPackage.all;

-- -----------------------------------------------------------------------------

entity MpmcTrMemRdWrCtl is
  generic (
            Tclk             : time := 10.52 ns  -- HCLK Period
           
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset
        MPMCADDR         : in    std_logic_vector(27 downto 0);
                                            -- Address Bus to Memory
        nMPMCDATAEN      : in    std_logic_vector(3 downto 0);
                                            -- Memory Bus Enable
        MPMCTrCS         : in    std_logic; -- Bank select
        MPMCTrAllCS      : in    std_logic_vector(7 downto 0);
                                            -- The status of all the 8 banks
                                            -- connected with the MPMC
        nMPMCWEN         : in    std_logic; -- Write enable
        nMPMCBLS         : in    std_logic_vector(3 downto 0);
                                            -- Byte lane select
        nMPMCOEN         : in    std_logic; -- Output enable
        MemRdDataDW      : in    std_logic_vector(31 downto 0);
                                            -- MPMC read data
        MPMCTrIDCY       : in    std_logic_vector(4 downto 0);
                                            -- Memory Data Bus turn
                                            -- around time
        MPMCTrWaitRd     : in    std_logic_vector(5 downto 0);
                                            -- Read access/Initial access time
        MPMCTrWaitWr     : in    std_logic_vector(5 downto 0);
                                            -- Write access/Page mode read
                                            -- access time
        MPMCTrWaitPg     : in    std_logic_vector(5 downto 0);
                                            -- Page access time
        MPMCTrMEMT       : in    std_logic_vector(10 downto 0);
                                            -- Memory type
        MPMCTrMEMB       : in    std_logic_vector(16 downto 0);
                                            -- Memory Base Address
        MPMCTrCS2OEN     : in    std_logic_vector(4 downto 0);
                                            -- CS-nMPMCOEN assertion delay
        MPMCTrCS2WEN     : in    std_logic_vector(4 downto 0);
                                            -- CS-nMPMCWEN assertion delay
        MPMCTrExtWait    : in    std_logic_vector(9 downto 0);
                                            -- Extended Wait count Register
        MPMCTrCSPOL      : in    std_logic_vector(7 downto 0);
                                            -- Chip Select polarity

-- Inouts
        MPMCDATA         : inout std_logic_vector(31 downto 0);
                                            -- Memory Data Bus

-- Outputs
        LatchMCADDR      : out   std_logic_vector(10 downto 0);
                                            -- Latched MPMC Address
        MPMCActLowCS     : out   std_logic  -- Used for suitably routing the
                                            -- MPMCWAIT signal
       );
end MpmcTrMemRdWrCtl;

-- -----------------------------------------------------------------------------
--
--                              MpmcTrMemRdWrCtl
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block constitutes the main control block in the MPMC trickmem.
-- Depending on the content of the MPMCTrMEMT register this block model the
-- memory module as SRAM, ROM or page mode ROM. It is possible to program the
-- trickmem as a memory of data size 8-bit, 16-bit and 32-bit. This module
-- contains all static memory related signals given by the MPMC. All memory
-- related timing parameters are checked in this module. Facility to display
-- error messages, if any violation happened are also provided.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of MpmcTrMemRdWrCtl is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant EIGHT            : std_logic_vector(1 downto 0) := "00";
constant SIXTEEN          : std_logic_vector(1 downto 0) := "01";
constant THIRTYTWO        : std_logic_vector(1 downto 0) := "10";

constant STIDLE           : std_logic_vector(2 downto 0) := "000";
-- IDLE state.

constant STREAD           : std_logic_vector(2 downto 0) := "001";
-- READ state.

constant STINITBURSTREAD  : std_logic_vector(2 downto 0) := "010";
-- Page mode (initial/slow) read state.

constant STBURSTREAD      : std_logic_vector(2 downto 0) := "011";
-- Page mode (fast/page) read state.

constant STWRITE          : std_logic_vector(2 downto 0) := "100";
-- Write state.

constant XonMCDATA        : std_logic := '0';
-- Controls whether 'X' or '0' is driven on MPMCDATA during read accesses.

constant DefData          : std_logic_vector(31 downto 0)
                            := "11011110101011011011111011101111";
-- Default data to be driven to the MPMCDATA

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal nWR              : std_logic;
-- Memory write enable.

signal nCS              : std_logic;
-- Memory device enable.

signal XCS              : std_logic_vector(7 downto 0);
-- External Bank Select signal after multiplexion with the CSPolarity

signal nMCBLSWR         : std_logic;
-- Memory write enable when byte lane is using as write enable

signal Wait4WtdAssn     : std_logic;
-- Control signal to time the MPMCWAIT de-assertion

signal Wait4WtAssn      : std_logic;
-- Control signal to time the MPMCWAIT assertion

signal RdCountDown      : std_logic;
-- Count Down enable for Read process

signal RdCount          : unsigned(5 downto 0) := "000000";
-- Read count

signal WrCount          : unsigned(5 downto 0) := "000000";
-- Write count

signal WstRead          : unsigned(5 downto 0) := "000000";
-- External Wait States counter

signal ExtWaitCount     : unsigned(15 downto 0) := "0000000000000000";
-- Read count

signal WaitCount        : unsigned(23 downto 0) := "000000000000000000000000";
-- External Wait States counter

signal MpmcCntSt        : std_logic_vector(2 downto 0) := "000";
-- State register.

signal NxtMpmcCntSt     : std_logic_vector(2 downto 0) := "000";
-- D-input for State register.

signal IntIDCY          : time := 0 ns;
-- Memory idle time.

signal IntWSTRead       : time := 0 ns;
-- Access time for read.

signal IntWSTBInitRead  : time := 0 ns;
-- Initial access time for page mode read.

signal IntWSTBRead      : time := 0 ns;
-- Access time for page mode read.

signal IntWSTWrite      : time := 0 ns;
-- Access time for write.

signal IntWSTReadMax    : time := 0 ns;
-- Maximum allowable access time for read.

signal IntWSTBInitRdMax : time := 0 ns;
-- Maximum allowable access time for (initial/slow) page mode read.

signal IntWSTBReadMax   : time := 0 ns;
-- Maximum allowable access time for (page/fast) read.

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

signal LastAddChgTime   : time := 0 ns;
-- Latch the time when address changes.

signal iLatchMCADDR     : std_logic_vector(10 downto 0) := "00000000000";
-- Memory address latch.

signal DelnCS           : std_logic;
-- 1 ns Delayed version of nCS

signal nCSQ           : std_logic;
-- 60(clk) ns Delayed version of nCS

signal Del1nMCOEN       : std_logic;
-- 1 ns Delayed version of nMPMCOEN.

signal DelnMCBLS        : std_logic_vector(3 downto 0);
-- 1 ns Delayed version of nMPMCBLS.

signal OldLatchMCADDR   : std_logic_vector(10 downto 0);
-- Store the old address.

signal WrSTime          : time := 0 ns;
-- Latch the time when write gets start.

signal NBRdSTime        : time := 0 ns;
-- Latch the time when non page mode read gets started.

signal BRdSTime         : time := 0 ns;
-- Latch the time when page mode read gets started.

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
-- MPMCTrnWAIT toggle enable bit

signal OutofRange       : std_logic;
-- Memory access out of range indicator

signal ToggSt           : std_logic;
-- State Toggler to trigger the state machine

signal MpmcExtWt        : unsigned(15 downto 0):="0000000000000000";
-- Counter value to store the extended wait value

signal valsixteen        : unsigned(5 downto 0):="010000";
-- Counter value to store the extended wait value
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
-- MPMCTrMEMT Register field rename
-- -----------------------------------------------------------------------------
MEMSIZE          <= MPMCTrMEMT(1 downto 0);
MEMTYPE          <= MPMCTrMEMT(3 downto 2);
MaxAccErMask     <= MPMCTrMEMT(4);
AccErMask        <= MPMCTrMEMT(5);
RBLE             <= MPMCTrMEMT(6);
CSPolarity       <= MPMCTrMEMT(7);
WaitEn           <= MPMCTrMEMT(8);
nMCBLSWR         <= nMPMCBLS(0) and nMPMCBLS(1) and nMPMCBLS(2) and nMPMCBLS(3);

-- -----------------------------------------------------------------------------
-- External Bank Select/Polarity Mux
-- -----------------------------------------------------------------------------
p_XCSComb : process (MPMCTrCSPOL, MPMCTrAllCS)
begin
  for i in 7 downto 0 loop
    if (MPMCTrCSPOL(i) = '0') then
      XCS(i) <= not (MPMCTrAllCS(i));
    else
      XCS(i) <= MPMCTrAllCS(i);
    end if;
  end loop;
end process p_XCSComb;

-- -----------------------------------------------------------------------------
-- Chip Select/Polarity Mux
-- -----------------------------------------------------------------------------
p_nCSComb : process (CSPolarity, MPMCTrCS)
begin
  if (CSPolarity = '0') then
    nCS <= MPMCTrCS;
  else
    nCS <= not (MPMCTrCS);
  end if;
end process p_nCSComb;

-- -----------------------------------------------------------------------------
-- Write enable select Mux
-- -----------------------------------------------------------------------------
p_nWRComb : process (RBLE, nMCBLSWR, nMPMCWEN)
begin
  if (RBLE = '0') then
    nWR <= nMCBLSWR;
  else
    nWR <= nMPMCWEN;
  end if;
end process p_nWRComb;

-- -----------------------------------------------------------------------------
-- Converting std_logic_vector to time.
-- -----------------------------------------------------------------------------
IntIDCY          <= (ToInteger(MPMCTrIDCY) + 1) * Tclk;

IntWSTRead       <= ((ToInteger(MPMCTrWaitRd) + 1) * Tclk - 2 ns);
                 --when (MPMCTrWaitRd = "000000")
                 --else
                     --((ToInteger(MPMCTrWaitRd) + 1) * Tclk - Tclk);

IntWSTWrite      <= (ToInteger(MPMCTrWaitWr) + 1) * Tclk - Tclk;

IntWSTBInitRead  <= ((ToInteger(MPMCTrWaitRd) + 1) * Tclk - 2 ns);
                 --when (MPMCTrWaitRd = "000000")
                  --else
                     --((ToInteger(MPMCTrWaitRd) + 1) * Tclk - Tclk);

IntWSTBRead      <= ((ToInteger(MPMCTrWaitPg) + 1) * Tclk - 2 ns);
                 --when (MPMCTrWaitWr = "000000")
                 --else
                     --((ToInteger(MPMCTrWaitWr) + 1) * Tclk - Tclk);

IntCS2OEN        <= ToInteger(MPMCTrCS2OEN) * Tclk;
IntCS2WEN        <= ToInteger(MPMCTrCS2WEN) * Tclk;

-- -----------------------------------------------------------------------------
-- Calculate the maximum allowable time for read and write access.
-- -----------------------------------------------------------------------------
IntWSTReadMax    <= IntWSTRead  + 3*Tclk + DelayTime;
IntWSTWriteMax   <= IntWSTWrite + 2*Tclk + DelayTime;
IntWSTBReadMax   <= IntWSTBRead + 1*Tclk + DelayTime;
IntWSTBInitRdMax <= IntWSTBInitRead + 1*Tclk + DelayTime;

-- -----------------------------------------------------------------------------
-- Generate the delayed version of signals
-- -----------------------------------------------------------------------------
DelnCS           <= nCS after 1 ns;
nCSQ             <= nCS after 60 ns;
Del1nMCOEN       <= nMPMCOEN after 1 ns;
DelnMCBLS        <= nMPMCBLS after 1 ns;
DelExtBankActive <= ExtBankActive after 2 ns;

-- -----------------------------------------------------------------------------
-- ExtBankActive becomes high when any other chip selects becomes enabled.
-- -----------------------------------------------------------------------------
ExtBankActive    <= (XCS(7) or XCS(6) or XCS(5) or XCS(4) or
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
  if (nWR'event and nWR = '1' and DelnCS = '0') then
    WrEndTime <= now;
  end if;
end process p_WrEndTimeComb;

-- -----------------------------------------------------------------------------
-- Latch the time when Read gets finish
-- -----------------------------------------------------------------------------
p_RdEndTimeComb : process (nMPMCOEN)
begin
  if (nMPMCOEN'event and nMPMCOEN = '1' and DelnCS = '0') then
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

p_CSDeAssrtnComb : process (IdleStartTime)
begin
  if ((IdleStartTime > 0 ns) and ((IdleStartTime - WrEndTime) < Tclk)) then
    assert false
      report "MPMCTM1: Write enable to CS de-assertion delay violation"
      severity Error;
  end if;
end process p_CSDeAssrtnComb;

-- -----------------------------------------------------------------------------
-- During the write cycle address should not change. Also in this design
-- nMPMCOEN is never enabled when write is enabled.
-- -----------------------------------------------------------------------------
assert NOT ((nMPMCOEN = '0') and (nWR = '0') and (nCS = '0'))
  report "MPMCTM2: Read enable and write enable are asserted at the same time"
severity warning;

assert NOT (MPMCADDR'event and nWR = '0' and (nCS = '0'))
  report "MPMCTM3: Address changed when write enable was active"
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
        report "MPMCTM4: Chip select controlled write"
        severity warning;
    end if;

    if (nMPMCOEN = '0') then
      assert NOT ((now - 2*Tclk) > RdEndTime)
        report "MPMCTM5: Chip select changed during read was active"
        severity warning;
    end if;
  end if;
end process p_CsStatusCheck;

-- -----------------------------------------------------------------------------
-- Checks for OEN and WEN asserted simultaneously
-- -----------------------------------------------------------------------------
p_RdWrAssertComb : process (nMPMCOEN, nWR)
begin
  if (nCS = '0') then
    if (nMPMCOEN = '0') then
      if (nWR = '0') then
        assert false
          report "MPMCTM6: Output Enable and Write Enable are asserted together"
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
  if ((DelExtBankActive = '1') and (ExtBankActive = '1')) then
    wait for DelayTime;
      -- A write to another bank after a read
      if (nCS = '1' and (nMCBLSWR = '0' or nMPMCWEN = '0') and
          nMPMCOEN = '1') then
        -- The subtracted value is decreased from 5 to 4 as the IntIDCY value
        -- taken for comparison is the highest IDCY value of all the banks
        assert NOT (now - (4 ns + RdEndTime) < IntIDCY)
          report "MPMCTM7: Bank to Bank idle time violation"
        severity warning;
      end if;
  end if;
end process p_IdleBetBank;

-- -----------------------------------------------------------------------------
-- Checking the address and data hold time with resepect to the rising edge
-- of write signal.
-- -----------------------------------------------------------------------------
assert NOT (MPMCADDR'event and (nCS = '0') and
            ((now - WrEndTime) < AddWrHoldTime))
  report "MPMCTM8: Address hold time violation"
severity warning;

assert NOT ((now > 0 ns) and MPMCDATA'event and (nCS = '0') and
           ((now - WrEndTime) < DataWrHoldTime))
  report "MPMCTM9: Data hold time violation"
severity warning;

assert NOT (WrEndTime'event and (now > 100 ns) and (nCS = '0') and
           ((WrEndTime - DataChangeTime) < DataWrSetupTime))
  report "MPMCTM10: Data setup time violation"
severity warning;

-- -----------------------------------------------------------------------------
-- State transition process
-- -----------------------------------------------------------------------------
p_RdWrSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    MpmcCntSt <= STIDLE;
    ToggSt    <= '0';
  elsif (HCLK'event and HCLK = '0') then
    MpmcCntSt <= NxtMpmcCntSt;
    ToggSt    <= not ToggSt;
  end if;
end process p_RdWrSeq;

-- -----------------------------------------------------------------------------
-- Next State generation process
-- -----------------------------------------------------------------------------
p_RdWrComb : process (iLatchMCADDR, nWR, nMPMCOEN, nCS, OutofRange,
                      MpmcCntSt, RdCount, ToggSt)
begin
  case MpmcCntSt is

    -- IDLE STATE
    when STIDLE =>
      RdCountDown <= '0';
      DataRdy     <= '0';
      if (nCS = '0') then
        -- Write cycle started.
        if (OutofRange = '1') then
          NxtMpmcCntSt <= STIDLE;
        else
          if (nWR = '0') then
            assert NOT ((now - (RdEndTime - 1 ns)) < IntIDCY)
              report "MPMCTM11: Read to write idle time violation"
            severity warning;

            assert NOT ((now - AddChangeTime) < AddWrSetupTime)
              report "MPMCTM12: Address set up time violation"
            severity warning;

            if (WaitEn = '0') then
              assert NOT ((now - AccessSTime) < IntCS2WEN)
                report "MPMCTM13: Chip Select to Write Enable assertion time" &
                       " violation"
                severity warning;
            end if;

            -- Write is allowed only when memory is configured as SRAM.
            if (MEMTYPE(0) = '0') then
              NxtMpmcCntSt <= STWRITE;
              WrSTime  <= now - IntCS2WEN - 2 ns;

               -- If the programmed memory size is
               -- 8-bit then only one write enable is active at a time.
               -- 16-bit then either nMPMCBLS(0) and nMPMCBLS(1) or
               -- nMPMCBLS(2) and nMPMCBLS(3) are high at all time

               if ((MEMSIZE = EIGHT) and (nCS = '0')) then
                 assert NOT ((nMPMCBLS(3) and nMPMCBLS(2) and
                              nMPMCBLS(1)) = '0')
                   report "MPMCTM14: Write enable violation for an 8-bit memory"
                 severity warning;

               elsif ((MEMSIZE = SIXTEEN) and (nCS = '0')) then
                 assert NOT ((nMPMCBLS(3) and nMPMCBLS(2)) = '0')
                   report "MPMCTM15: Write enable violation for a 16-bit memory"
                 severity warning;
               end if;
            else
              NxtMpmcCntSt <= STIDLE;
              assert false
                report "MPMCTM16: Write is not supported"
              severity warning;
            end if;

          -- Read cycle started.
          elsif (nMPMCOEN = '0') then
            assert NOT ((now - WrEndTime) < (Tclk - 2 ns))
              report "MPMCTM17: Write to read idle time violation"
              severity warning;

            if (WaitEn = '0') then
              assert NOT ((now - (AccessSTime + 0 ns)) < IntCS2OEN)
                report "MPMCTM18: Chip Select to Output Enable assertion time" &
                       " violation"
                severity warning;
            end if;

            NBRdSTime <= now - IntCS2OEN - 2 ns;

            if (MEMTYPE(1) = '1') then
              NxtMpmcCntSt <= STINITBURSTREAD;
              BRdSTime    <= now - IntCS2OEN - 2 ns;
            else
              NxtMpmcCntSt <= STREAD;
            end if;
          else
            NxtMpmcCntSt <= STIDLE;
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
      if (nMPMCOEN = '1') then
        NxtMpmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - NBRdSTime) > IntWSTReadMax)
              report "MPMCTM19: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "MPMCTM20: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Page mode access. In case of page access higher order address will
      -- not change.
      elsif (iLatchMCADDR'event) and (nMPMCOEN = '0') and
            (iLatchMCADDR(10 downto 2) = OldLatchMCADDR(10 downto 2)) then
        DataRdy <= '0';
        NBRdSTime    <= now - 1 ns;
        NxtMpmcCntSt  <= STREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - AddChangeTime) > IntWSTReadMax)
              report "MPMCTM21: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "MPMCTM22: Access time violation for the read"
            severity warning;
          end if;
        end if;

      -- Continuous read.
      elsif (iLatchMCADDR'event) and (nMPMCOEN = '0') then
        DataRdy <= '0';
        NBRdSTime    <= now - 1 ns;
        NxtMpmcCntSt     <= STREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - NBRdSTime) > IntWSTReadMax)
              report "MPMCTM23: Maximum time limit for the non page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "MPMCTM24: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        NxtMpmcCntSt     <= STREAD;
      end if;


    when STINITBURSTREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- Page mode read finished.
      if (nCS = '1') then
        NxtMpmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - LastAddChgTime) > IntWSTBInitRdMax)
              report "MPMCTM25: Maximum time limit for the Page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBInitRead)
              report "MPMCTM26: Access time violation for Page mode Read"
            severity warning;
          end if;
        end if;

      elsif (nMPMCOEN'event and nMPMCOEN = '1') then
        DataRdy <= '0';
        NxtMpmcCntSt  <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT (((now - AddChangeTime) > IntWSTBInitRdMax) and
                         (RdEndTime < AddChangeTime))
              report "MPMCTM27: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AddChangeTime) < IntWSTBInitRead)
              report "MPMCTM28: Access time violation for Page mode Read"
            severity warning;
          end if;
        end if;

      -- Page mode access. For page access lower two address bits remains
      -- unchanged.
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '0') and
            (iLatchMCADDR(10 downto 2) = OldLatchMCADDR(10 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtMpmcCntSt  <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((AddChangeTime > RdEndTime) and
                        (now - AddChangeTime) > IntWSTBInitRdMax)
              report "MPMCTM29: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AccessSTime) < IntWSTBInitRead)
              report "MPMCTM30: Access time violation for page mode Read"
            severity warning;
          end if;
        end if;

      -- page mode read access with nMPMCOEN deasserted between transfers
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '1') and
            (iLatchMCADDR(10 downto 2) = OldLatchMCADDR(10 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtMpmcCntSt  <= STBURSTREAD;

      -- Continuous page mode ROM read, but not the burst access.
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '0') then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtMpmcCntSt     <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - AddChangeTime) > IntWSTBInitRdMax)
              report "MPMCTM31: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AddChangeTime) < IntWSTBInitRead)
              report "MPMCTM32: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Continuous page mode ROM read, but not the page mode access
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '1') then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtMpmcCntSt     <= STINITBURSTREAD;

      else
        NxtMpmcCntSt     <= STINITBURSTREAD;
      end if;


    -- ST_BURSTREAD
    when STBURSTREAD =>
      RdCountDown <= '1';
      if (RdCount = 0) then
        DataRdy <= '1';
      end if;

      -- page mode read finished.
      if (nCS = '1') then
        NxtMpmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - AddChangeTime) > IntWSTBReadMax)
              report "MPMCTM33: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBRead)
              report "MPMCTM34: Access time violation for Read"
            severity warning;
          end if;
        end if;

      elsif (nMPMCOEN'event and nMPMCOEN = '1') then
        DataRdy <= '0';
        NxtMpmcCntSt  <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - AddChangeTime) > IntWSTBReadMax)
              report "MPMCTM35: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AddChangeTime) < IntWSTBRead)
              report "MPMCTM36: Access time violation for page mode Read"
            severity warning;
          end if;
        end if;

      -- Page mode access. For page mode access lower two address bits remains
      -- unchanged.
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '0') and
            (iLatchMCADDR(10 downto 2) = OldLatchMCADDR(10 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtMpmcCntSt     <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT (((now - AddChangeTime) > IntWSTBReadMax) and
                        (RdEndTime < AddChangeTime))
              report "MPMCTM37: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - AccessSTime) < IntWSTBRead)
              report "MPMCTM38: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Page mode read access with nMPMCOEN deasserted between transfers
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '1') and
            (iLatchMCADDR(10 downto 2) = OldLatchMCADDR(10 downto 2)) then
        DataRdy <= '0';
        BRdSTime     <= now - 1 ns;
        NxtMpmcCntSt  <= STBURSTREAD;

      -- Continuous page mode ROM read, but not the page access.
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '0') then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtMpmcCntSt <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - AddChangeTime) > IntWSTBInitRdMax)
              report "MPMCTM39: Maximum time limit for the page mode read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBRead)
              report "MPMCTM40: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Continuous page mode ROM read, but not the page access
      elsif (iLatchMCADDR /= OldLatchMCADDR) and (nMPMCOEN = '1') then
        DataRdy <= '0';
        BRdSTime    <= now - 1 ns;
        NxtMpmcCntSt     <= STINITBURSTREAD;

      else
        NxtMpmcCntSt     <= STBURSTREAD;
      end if;

    -- ST_WRITE
    when STWRITE =>
      RdCountDown <= '0';
      DataRdy <= '0';
      -- Write cycle finished. Data in the MPMCDATA bus, is written into
      -- the memory element pointed by the MPMCADDR value by using the rising
      -- edge of the write signal.
      if (nWR = '1') then
        NxtMpmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          assert NOT ((now - WrSTime) < IntWSTWrite)
            report "MPMCTM41: Access time violation for write"
          severity warning;

          assert NOT ((now - WrSTime) > IntWSTWriteMax)
            report "MPMCTM42: Maximum time limit for write access has exceeded"
          severity warning;
        end if;

      else
        NxtMpmcCntSt     <= STWRITE;
      end if;

    -- default state.
    when others =>
      RdCountDown <= '0';
      DataRdy <= '0';
      NxtMpmcCntSt       <= STIDLE;
  end case;
end process p_RdWrComb;

-- -----------------------------------------------------------------------------
-- Capture read data
-- -----------------------------------------------------------------------------
p_MPMCDATAComb : process (WaitEn, DataRdy, RdCountDown, MemRdDataDW)
begin
  if (WaitEn = '1' and RdCountDown = '1') then
    if (MEMSIZE = EIGHT) then
      MPMCDATA(7 downto 0) <= MemRdDataDW(7 downto 0);
      MPMCDATA(31 downto 8) <= (others => 'Z');
    elsif (MEMSIZE = SIXTEEN) then
      MPMCDATA(15 downto 0) <= MemRdDataDW(15 downto 0);
      MPMCDATA(31 downto 16) <= (others => 'Z');
    else
      MPMCDATA <= MemRdDataDW;
    end if;
  elsif (DataRdy = '1') then
    if (MEMSIZE = EIGHT) then
      MPMCDATA(7 downto 0) <= MemRdDataDW(7 downto 0);
      MPMCDATA(31 downto 8) <= (others => 'Z');
    elsif (MEMSIZE = SIXTEEN) then
      MPMCDATA(15 downto 0) <= MemRdDataDW(15 downto 0);
      MPMCDATA(31 downto 16) <= (others => 'Z');
    else
      MPMCDATA <= MemRdDataDW;
    end if;
  elsif (RdCountDown = '1') then
    if (XonMCDATA = '0') then
      if (MEMSIZE = EIGHT) then
        MPMCDATA(7 downto 0) <= DefData(7 downto 0);
        MPMCDATA(31 downto 8) <= (others => 'Z');
      elsif (MEMSIZE = SIXTEEN) then
        MPMCDATA(15 downto 0) <= DefData(15 downto 0);
        MPMCDATA(31 downto 16) <= (others => 'Z');
      else
        MPMCDATA <= DefData;
      end if;
    else
      MPMCDATA <= (others => 'X');
    end if;
  else
    MPMCDATA <= (others => 'Z');
  end if;
end process p_MPMCDATAComb;

-- -----------------------------------------------------------------------------
-- Read Wait selector
-- -----------------------------------------------------------------------------
p_WstReadComb : process (NxtMpmcCntSt)
begin
  if (NxtMpmcCntSt = STBURSTREAD) then
    WstRead <= unsigned(MPMCTrWaitPg);
  else
    WstRead <= unsigned(MPMCTrWaitRd) - unsigned('0' & MPMCTrCS2OEN);
  end if;
end process p_WstReadComb;

-- -----------------------------------------------------------------------------
-- Read Counter
-- -----------------------------------------------------------------------------
p_RdCntrSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    RdCount <= (others => '1');
  elsif (HCLK'event and HCLK = '0') then
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
-- Calculation of extended wait counter value
-- -----------------------------------------------------------------------------
p_ExtWaitCalc : process (HCLK,iLatchMCADDR,OldLatchMCADDR,WaitEn, nCSQ)
begin
  if (WaitEn = '1') then
    if (iLatchMCADDR /= OldLatchMCADDR or nCSQ = '1') then 
      MpmcExtWt <= "0000000000000000";
    elsif(HCLK'event and HCLK = '1') then
     MpmcExtWt <= (unsigned(MpmcExtWt)) + 1;
    end if;
  end if;
end process p_ExtWaitCalc;

-- -----------------------------------------------------------------------------
-- Maximum value of extended counter
-- -----------------------------------------------------------------------------
p_MaxExtWt: process (MPMCTrExtWait, HRESETn)
begin 
  if (MPMCTrExtWait = "0000000000" or HRESETn = '0') then
    ExtWaitCount <= (others => '0');
  else
    ExtWaitCount <= (unsigned(MPMCTrExtWait) * valsixteen) + 2;
  end if;
end process p_MaxExtWt;

-- -----------------------------------------------------------------------------
-- Extended Wait time check
-- -----------------------------------------------------------------------------
p_ExtWaitSeq : process (HCLK, WaitEn, RdCountDown, MpmcCntSt, ExtWaitCount,
                        MpmcExtWt)
begin
  if (HCLK'event and HCLK = '1') then
    if (WaitEn = '1') then
      if ((RdCountDown = '1') or (MpmcCntSt = STWRITE)) then
        if (ExtWaitCount = MpmcExtWt) then
          assert false
            report "MPMCTM43 : Extended Wait Access timed out"
            severity warning;
        end if;
      end if;
    end if;
  end if;
end process p_ExtWaitSeq;

-- -----------------------------------------------------------------------------
-- Latch the time when data gets changes
-- -----------------------------------------------------------------------------
p_DatLatchTimeComb : process (MPMCDATA)
begin
  if (not(MPMCDATA(31 downto 0) = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")) then
    DataChangeTime <= now;
  end if;
end process p_DatLatchTimeComb;

-- -----------------------------------------------------------------------------
-- Address Mux. This process generate the latched address depend on the
-- programed size of the memory width.
-- -----------------------------------------------------------------------------
-- Shrilola
p_MPMCAddrLthComb : process (MPMCADDR,MEMSIZE, MPMCTrMEMB)
begin
  AddChangeTime      <= now;
  if (MPMCADDR(27 downto 11) = MPMCTrMEMB) then
    OutofRange <= '0';
    if (MEMSIZE = EIGHT) then
      iLatchMCADDR <= MPMCADDR(10 downto 0);
    elsif (MEMSIZE = SIXTEEN) then
      iLatchMCADDR <= MPMCADDR(10 downto 0);
    elsif (MEMSIZE = THIRTYTWO) then
      iLatchMCADDR <= MPMCADDR(10 downto 0);
    end if;
  else
    OutofRange <= '1';
  end if;
end process p_MPMCAddrLthComb;

-- -----------------------------------------------------------------------------
-- Out of range access warning
-- -----------------------------------------------------------------------------
p_OutofRngComb : process(OutofRange, DelnCS)
begin
  if ((OutofRange = '1') and (DelnCS = '0') and (DelnCS = nCS)) then
    assert false
      report "MPMCTM44: Accessed location is out of range"
      severity warning;
  end if;
end process p_OutofRngComb;

-- -----------------------------------------------------------------------------
-- Old MPMCADDR
-- -----------------------------------------------------------------------------
p_OldAddrLtchComb : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    OldLatchMCADDR <= (others => '0');
  elsif (HCLK'event and HCLK = '0') then
    OldLatchMCADDR <= iLatchMCADDR;
  end if;
end process p_OldAddrLtchComb;
-- -----------------------------------------------------------------------------
-- Store the time when the address changed
-- -----------------------------------------------------------------------------
p_OldAddrTimeComb : process (OldLatchMCADDR)
begin 
       LastAddChgTime <= now;
end process p_OldAddrTimeComb;

-- -----------------------------------------------------------------------------
-- nMPMCBLS check during read. During read cycle nMPMCBLS should be "1111" when
-- RBLE = '0' and nMPMCBLS should be "0000" when RBLE = '1'
-- -----------------------------------------------------------------------------
p_MPMCBLSChkComb : process (nMPMCBLS, DelnMCBLS, Del1nMCOEN, nMPMCOEN,
                            RBLE, nCS)
begin
  if (((Del1nMCOEN or nMPMCOEN) = '0') and (nCS = '0')) then
    if ((RBLE = '0') and ((nMPMCBLS < "1111") and (DelnMCBLS < "1111"))) then
      assert false
        report "MPMCTM45: nMPMCBLS violation when StBLS = '0' during read"
      severity warning;
    end if;

    if ((RBLE = '1') and ((nMPMCBLS > "0000") and (DelnMCBLS > "0000"))) then
      assert false
        report "MPMCTM46: nMPMCBLS violation when StBLS = '1' during read"
      severity warning;
    end if;
  end if;
end process p_MPMCBLSChkComb;

-- -----------------------------------------------------------------------------
-- Assign local copy to the output
-- -----------------------------------------------------------------------------
LatchMCADDR      <= iLatchMCADDR;
MPMCActLowCS     <= nCS;

end behavioural;

-- --================================== End ==================================--
