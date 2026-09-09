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
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
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
        LatchSMADDR      : out   std_logic_vector(10 downto 0);
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

signal WaitCount        : unsigned(23 downto 0) := "000000000000000000000000";
-- External Wait States counter

signal SmcCntSt         : std_logic_vector(2 downto 0) := "000";
-- State register.

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

signal DelLatchSMADDR   : std_logic_vector(10 downto 0);
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

signal OldLatchSMADDR   : std_logic_vector(10 downto 0);
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

signal WaitEn           : std_logic;
-- SMCTrnWAIT toggle enable bit

signal BoundaryCase     : std_logic;
-- Read-data return time select

signal OutofRange       : std_logic;
-- Memory access out of range indicator

signal Del1LatchSMADDR   : std_logic_vector(10 downto 0);
-- 1 ns Delayed version of iLatchSMADDR

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

IntWSTRead        <= ((ToInteger(SMCTrWST1) + 1) * Tclk - 2 ns)
                  when (SMCTrWST1 = "000000")
                  else
                     ((ToInteger(SMCTrWST1) + 1) * Tclk - Tclk);

IntWSTWrite       <= (ToInteger(SMCTrWST2) + 1) * Tclk - Tclk;

IntWSTBInitRead   <= ((ToInteger(SMCTrWST1) + 1) * Tclk - 2 ns)
                  when (SMCTrWST1 = "000000")
                  else
                     ((ToInteger(SMCTrWST1) + 1) * Tclk - Tclk);

IntWSTBRead       <= ((ToInteger(SMCTrWST2) + 1) * Tclk - 2 ns)
                  when (SMCTrWST2 = "000000")
                  else
                     ((ToInteger(SMCTrWST2) + 1) * Tclk - Tclk);

IntCS2OEN         <= ToInteger(SMCTrCS2OEN) * Tclk;
IntCS2WEN         <= ToInteger(SMCTrCS2WEN) * Tclk;

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
  if (nSMOEN'event and nSMOEN = '1') then
    RdEndTime <= now;
  end if;
end process p_RdEndTimeComb;

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
          report "SMCTM5: Output Enable and Write Enable are asserted together"
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
      if (nCS = '1' and (nSMBLSWR = '0' or nSMWEN = '0') and nSMOEN = '1') then
        -- The subtracted value is decreased from 5 to 4 as the IntIDCY value
        -- taken for comparison is the highest IDCY value of all the banks
        assert NOT (now - (4 ns + RdEndTime) < IntIDCY)
          report "SMCTM6: Bank to Bank idle time violation"
        severity warning;
      end if;
  end if;
end process p_IdleBetBank;

-- -----------------------------------------------------------------------------
-- Checking the address and data hold time with resepect to the rising edge
-- of write signal.
-- -----------------------------------------------------------------------------
assert NOT (SMADDR'event and (nCS = '0') and
            ((now - WrEndTime) < AddWrHoldTime))
  report "SMCTM7: Address hold time violation"
severity warning;

assert NOT ((now > 0 ns) and SMDATA'event and (nCS = '0') and
           ((now - WrEndTime) < DataWrHoldTime))
  report "SMCTM8: Data hold time violation"
severity warning;

assert NOT (WrEndTime'event and (now > 100 ns) and (nCS = '0') and
           ((WrEndTime - DataChangeTime) < DataWrSetupTime))
  report "SMCTM9: Data setup time violation"
severity warning;

-- -----------------------------------------------------------------------------
-- State transition process
-- -----------------------------------------------------------------------------
p_RdWrComb : process (DelLatchSMADDR, nWR, DelnSMOEN, nSMOEN, nCS, OutofRange,
                      SmcCntSt, SMDATA)
begin
  case SmcCntSt is

    -- IDLE STATE
    when STIDLE =>
      SMDATA           <= (others => 'Z');
      if (nCS = '0') then
        -- Write cycle started.
        if (OutofRange = '1') then
          SmcCntSt <= STIDLE;
        else
          if (nWR = '0') then
            assert NOT ((now - (RdEndTime - 1 ns)) < IntIDCY)
              report "SMCTM10: Read to write idle time violation"
            severity warning;

            assert NOT ((now - AddChangeTime) < AddWrSetupTime)
              report "SMCTM11: Address set up time violation"
            severity warning;

            if (WaitEn = '0') then
              assert NOT ((now - AccessSTime) < IntCS2WEN)
                report "SMCTM12: Chip Select to Write Enable assertion time" &
                       " violation"
                severity warning;
            end if;

            -- Write is allowed only when memory is configured as SRAM.
            if (MEMTYPE = SRAM) then
              SmcCntSt <= STWRITE;
              WrSTime  <= now - IntCS2WEN - 2 ns;

               -- If the programmed memory size is
               -- 8-bit then only one write enable is active at a time.
               -- 16-bit then either nSMBLS(0) and nSMBLS(1) or
               -- nSMBLS(2) and nSMBLS(3) are high at all time

               if ((MEMSIZE = EIGHT) and (nCS = '0')) then
                 assert NOT ((nSMBLS(3) and nSMBLS(2) and nSMBLS(1)) = '0')
                   report "SMCTM13: Write enable violation for an 8-bit memory"
                 severity warning;

               elsif ((MEMSIZE = SIXTEEN) and (nCS = '0')) then
                 assert NOT ((nSMBLS(3) and nSMBLS(2)) = '0')
                   report "SMCTM14: Write enable violation for a 16-bit memory"
                 severity warning;
               end if;
            else
              SmcCntSt <= STIDLE;
              assert false
                report "SMCTM15: Write is not supported"
              severity warning;
            end if;

          -- Read cycle started.
          elsif ((DelnSMOEN = '0') and (nSMOEN = '0')) then
            -- DelnSMOEN is 2 ns delayed version of nSMOEN
            assert NOT ((now - WrEndTime) < (Tclk - 2 ns))
              report "SMCTM16: Write to read idle time violation"
              severity warning;

            if (WaitEn = '0') then
              assert NOT ((now - (AccessSTime + 0 ns)) < IntCS2OEN)
                report "SMCTM17: Chip Select to Output Enable assertion time" &
                       "violation"
                severity warning;
            end if;

            if (XonSMDATA = '0') then
              SMDATA <= "11011110101011011101111010101101";
            else
              SMDATA <= (others => 'X');
            end if;
            NBRdSTime <= now - IntCS2OEN - 2 ns;

            if (MEMTYPE = BURSTROM) then
              SmcCntSt  <= STINITBURSTREAD;
              BRdSTime  <= now - IntCS2OEN - 2 ns;
            else
              SmcCntSt   <= STREAD;
            end if;
          else
            SmcCntSt   <= STIDLE;
          end if;
        end if;
      end if;

    -- ST_READ
    when STREAD =>
      if (WaitEn = '0') then
        SMDATA <= transport MemRdDataDW after (IntWSTRead - IntCS2OEN - 5 ns);
      else
        SMDATA <= transport MemRdDataDW;
      end if;

      -- Read cycle finished.
      if (nSMOEN = '1') then
        SMDATA       <= (others => 'Z');
        SmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - NBRdSTime) > IntWSTReadMax)
              report "SMCTM18: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "SMCTM19: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- BURST access. In case of burst access higher order address will
      -- not change.
      elsif (DelLatchSMADDR'event and (iLatchSMADDR = DelLatchSMADDR) and
             (nSMOEN = '0') and (Del3nSMOEN = '0') and
             (iLatchSMADDR(10 downto 2) = OldLatchSMADDR(10 downto 2))) then
        if (XonSMDATA = '0') then
          SMDATA     <= "11011110101011011101111010101101";
        else
          SMDATA     <= (others => 'X');
        end if;
        SMDATA       <= transport MemRdDataDW after (IntWSTRead - 5 ns);
        NBRdSTime     <= now - 1 ns;
        SmcCntSt     <= STREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - NBRdSTime) > IntWSTReadMax)
              report "SMCTM20: Maximum time limit for the read access has" &
                     " exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "SMCTM21: Access time violation for the read"
            severity warning;
          end if;
        end if;

      -- Continuous read.
      elsif (DelLatchSMADDR'event and (DelLatchSMADDR = iLatchSMADDR)
              and (nSMOEN = '0') and (Del3nSMOEN = '0')) then
        if (XonSMDATA = '0') then
          SMDATA      <= "11011110101011011101111010101101";
        else
          SMDATA      <= (others => 'X');
        end if;
        SMDATA        <= transport MemRdDataDW after (IntWSTRead - 5 ns);
        NBRdSTime    <= now - 1 ns;
        SmcCntSt     <= STREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - NBRdSTime) > IntWSTReadMax)
              report "SMCTM22: Maximum time limit for the non burst read" &
                     " access has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - NBRdSTime) < IntWSTRead)
              report "SMCTM23: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        SmcCntSt     <= STREAD;
      end if;


    when STINITBURSTREAD =>
      if (WaitEn = '0') then
        SMDATA <= transport MemRdDataDW
                            after (IntWSTBInitRead - IntCS2OEN - 5 ns);
      else
        SMDATA <= transport MemRdDataDW;
      end if;

      -- Burst read finished.
      if (nCS = '1') then
        SMDATA        <= (others => 'Z');
        SmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SMCTM24: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBInitRead)
              report "SMCTM25: Access time violation for Burst Read"
            severity warning;
          end if;
        end if;

      -- Burst access. For burst access lower two address bits remains
      -- unchanged.
      elsif (DelLatchSMADDR'event and (iLatchSMADDR = DelLatchSMADDR) and
             (nSMOEN = '0') and
             (iLatchSMADDR(10 downto 2) = OldLatchSMADDR(10 downto 2))) then
        if (XonSMDATA = '0') then
          SMDATA      <= "11001110101011011101111010101100";
        else
          SMDATA      <= (others => 'X');
        end if;
        BRdSTime     <= now - 1 ns;
        SmcCntSt     <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SMCTM26: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBInitRead)
              report "SMCTM27: Access time violation for Burst Read"
            severity warning;
          end if;
        end if;

      -- Continuous Burst ROM read, but not the burst access.
      elsif (DelLatchSMADDR'event and (DelLatchSMADDR = iLatchSMADDR)
                                 and (nSMOEN = '0')) then
        if (XonSMDATA = '0') then
          SMDATA      <= "11011110101011011101111010101101";
        else
          SMDATA      <= (others => 'X');
        end if;
        BRdSTime    <= now - 1 ns;
        SmcCntSt     <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SMCTM28: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBInitRead)
              report "SMCTM29: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        SmcCntSt     <= STINITBURSTREAD;
      end if;


    -- ST_BURSTREAD
    when STBURSTREAD =>
      if (WaitEn = '0') then
        SMDATA <= transport MemRdDataDW after (IntWSTBRead - IntCS2OEN - 5 ns);
      else
        SMDATA <= transport MemRdDataDW;
      end if;

      -- Burst read finished.
      if (nCS = '1') then
        SMDATA        <= (others => 'Z');
        SmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BRdSTime) > IntWSTBReadMax)
              report "SMCTM30: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBRead)
              report "SMCTM31: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Burst access. For burst access lower two address bits remains
      -- unchanged.
      elsif (DelLatchSMADDR'event and (iLatchSMADDR = DelLatchSMADDR) and
             (nSMOEN = '0') and
             (iLatchSMADDR(10 downto 2) = OldLatchSMADDR(10 downto 2))) then
        if (XonSMDATA = '0') then
          SMDATA      <= "11011110101011011101111010101101";
        else
          SMDATA      <= (others => 'X');
        end if;
        BRdSTime     <= now - 1 ns;
        SmcCntSt     <= STBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BRdSTime) > IntWSTBReadMax)
              report "SMCTM32: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBRead)
              report "SMCTM33: Access time violation for Read"
            severity warning;
          end if;
        end if;

      -- Continuous Burst ROM read, but not the burst access.
      elsif (DelLatchSMADDR'event and (DelLatchSMADDR = iLatchSMADDR)
                                 and (nSMOEN = '0')) then
        if (XonSMDATA = '0') then
          SMDATA     <= "11011110101011011101111010101101";
        else
          SMDATA     <= (others => 'X');
        end if;
        SMDATA       <= transport MemRdDataDW after (IntWSTRead - 5 ns);
        BRdSTime    <= now - 1 ns;
        SmcCntSt     <= STINITBURSTREAD;

        if (WaitEn = '0') then
          if (MaxAccErMask = '0') then
            assert NOT ((now - BRdSTime) > IntWSTBInitRdMax)
              report "SMCTM34: Maximum time limit for the burst read access" &
                     " has exceeded"
            severity warning;
          end if;

          if (AccErMask = '0') then
            assert NOT ((now - BRdSTime) < IntWSTBInitRead)
              report "SMCTM35: Access time violation for Read"
            severity warning;
          end if;
        end if;

      else
        SmcCntSt     <= STBURSTREAD;
      end if;

    -- ST_WRITE
    when STWRITE =>
      -- Write cycle finished. Data in the SMDATA bus, is written into
      -- the memory element pointed by the SMADDR value by using the rising
      -- edge of the write signal.
      if (nWR = '1') then
        SmcCntSt     <= STIDLE;

        if (WaitEn = '0') then
          assert NOT ((now - WrSTime) < IntWSTWrite)
            report "SMCTM36: Access time violation for write"
          severity warning;

          assert NOT ((now - WrSTime) > IntWSTWriteMax)
            report "SMCTM37: Maximum time limit for write access has exceeded"
          severity warning;
        end if;

      else
        SmcCntSt     <= STWRITE;
      end if;

    -- default state.
    when others =>
      SmcCntSt       <= STIDLE;
  end case;
end process p_RdWrComb;

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
  OldLatchSMADDR      <= Del1LatchSMADDR;
  AddChangeTime      <= now;
  if (SMADDR(25 downto 11) <= SMCTrMEMB) then
    OutofRange <= '0';
    if (MEMSIZE = EIGHT) then
      iLatchSMADDR      <= SMADDR(10 downto 0);
    elsif (MEMSIZE = SIXTEEN) then
      iLatchSMADDR      <= '0' & SMADDR(10 downto 1);
    elsif (MEMSIZE = THIRTYTWO) then
      iLatchSMADDR      <= "00" & SMADDR(10 downto 2);
    end if;
  else
    OutofRange <= '1';
    if ((DelnCS = '0') and (DelnCS = nCS)) then
      assert false
        report "SMCTM38: Accessed location is out of range"
        severity warning;
    end if;
  end if;
end process p_SMAddrLatchComb;

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
