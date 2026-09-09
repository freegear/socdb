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
-- File Name              : SmcEIB.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           The off-chip external data, address and control signals interface
--           is the main function of this block.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SmcPackage.all;

-- -----------------------------------------------------------------------------

entity SmcEIB is
  port (
-- Inputs
        HCLK             : in    std_logic; -- Bus Clock
        HRESETn          : in    std_logic; -- Module Reset
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write data input bus from AHB
        HSizeRegCo       : in    std_logic_vector(1 downto 0);
                                            -- Registered AHB Transfer Size
        MSize08          : in    std_logic; -- Signal indicating 8-bit
                                            -- Memory width
        MSize16          : in    std_logic; -- Signal indicating 16-bit
                                            -- Memory width
        MSize32          : in    std_logic; -- Signal indicating 32-bit
                                            -- Memory width
        BIGENDIAN        : in    std_logic; -- This input determines the
                                            -- endianness of the system
        RemapReg         : in    std_logic; -- The memory map is determined by
                                            -- this input
        RBLE             : in    std_logic; -- Byte lane enabled device
        BM               : in    std_logic; -- Burst ROM device indication
        CSPol            : in    std_logic_vector(7 downto 0);
                                            -- Chip Select polarity
        SMCsEnCo         : in    std_logic; -- Chip Select enable
        SMCDATAIN        : in    std_logic_vector(31 downto 0);
                                            -- External memory input data bus
        SmcState         : in    std_logic_vector(3 downto 0);
                                            -- The state machine's current
                                            -- state value
        CntEnd           : in    std_logic; -- Access timer counter termination
                                            -- signal
        HAddrCrnt        : in    std_logic_vector(25 downto 0);
                                            -- Registered HADDR for a new
                                            -- transfer
        HAddrWtdCo       : in    std_logic_vector(25 downto 0);
                                            -- Registered HADDR for a waited
                                            -- transfer
        BnkAddStrCo      : in    std_logic_vector(2 downto 0);
                                            -- Stored value of the current
                                            -- Bank Address
        AddrIncCo        : in    std_logic; -- Address increment signal from TSM
        MemWrReq         : in    std_logic; -- Signal indicating the write
                                            -- transfer being initiated
        MemRdReq         : in    std_logic; -- Signal indicating the read
                                            -- transfer being initiated
        WtdWrReq         : in    std_logic; -- Signal indicating that write
                                            -- transfer is pending on the AHB
        WtdRdReq         : in    std_logic; -- Signal indicating that read
                                            -- transfer is pending on the AHB
        MwPgm            : in    std_logic; -- Indicates that the Waited Read or
                                            -- Write Request is due to MW
                                            -- programming
        BufWrOver        : in    std_logic; -- Buffer storage completion signal
                                            -- during write transfers
        ExtWrEnCo        : in    std_logic; -- Signal to enable the output
                                            -- write control and data signals
                                            -- of the memory device during WR
        ExtWrDisCo       : in    std_logic; -- Disabling signal for the
                                            -- write enable and bytelane
                                            -- selects
        RdCntLdCo        : in    std_logic; -- Load Count value in Timer
                                            -- counter for normal Read
                                            -- Access
        XoutEnCo         : in    std_logic; -- Enable signal for the nSMOEN
        XoutDisCo        : in    std_logic; -- Disable signal for the nSMOEN
        XdatDisCo        : in    std_logic; -- Signal to de-assert the SMCDATAEN
                                            -- output lines
        RdXdatEnCo       : in    std_logic; -- Signal to assert the proper
                                            -- byte lanes of external data bus
                                            -- depending on memory width
                                            -- during reads
        WrXdatEnCo       : in    std_logic; -- Signal to assert all the byte
                                            -- lanes of external data bus during
                                            -- a write transfer and during
                                            -- Idle cycles
        BufByPassCo      : in    std_logic; -- This signal is used to indicate
                                            -- that the HSIZE = MSIZE and the
                                            -- RdWrBuf can be bypassed during
                                            -- transfers
        BrstAddIncCo     : in    std_logic; -- Signal for incrementing the
                                            -- SMADDR in advance during burst
                                            -- reads
        BMRdTrans        : in    std_logic; -- This signal indicates that
                                            -- current transfer status is burst
                                            -- mode reads
        HBurstRegCo      : in    std_logic_vector(2 downto 0);
                                            -- Registered HBURST signal from
                                            -- AHB interface block
        CntEZEnd         : in    std_logic; -- Timer counter expiry signal when
                                            -- count values are zero
        MW               : in    std_logic_vector(1 downto 0);
                                            -- The memory width bits selection
                                            -- from one of the bank registers
        HTransRegCo      : in    std_logic_vector(1 downto 0);
                                            -- Registered HTRANS signal from 
                                            -- AHB interface block
        FastRdOp         : in    std_logic; -- In case of Burst reads when the
                                            -- buffer has more data than
                                            -- required by current AHB transfer,
                                            -- it is possible to provide the
                                            -- subsequent data from the internal
                                            -- buffer if the next sequential
                                            -- addresses are in the same field
                                            -- in zero cycles.
                                            -- So speculative advance reads are
                                            -- not done
        WaitToutErr      : in    std_logic; -- Wait Timeout Error signal

-- Outputs
        PosSMWEN         : out   std_logic; -- Positive edge (HCLK) triggered
                                            -- Write Enable, SMWEN
        PosSMBLS         : out   std_logic_vector(3 downto 0);
                                            -- Positive edge (HCLK) triggered
                                            -- byte lane select, SMBLS
        SMCS             : out   std_logic_vector(7 downto 0);
                                            -- Chip Selects of the external
                                            -- memory devices
        SMCDATAOUT       : out   std_logic_vector(31 downto 0);
                                            -- External data output bus to the
                                            -- memory
        SMCADDR          : out   std_logic_vector(25 downto 0);
                                            -- External memory address bus
        nSMOEN           : out   std_logic; -- Output enable signal to the
                                            -- external device during reads
        nSMCDATAEN       : out   std_logic_vector(3 downto 0);
                                            -- Tristate I/O pad enables for the
                                            -- byte lanes of the external
                                            -- memory data bus
        MemWrOver        : out   std_logic; -- Write completion signal to
                                            -- indicate that all data packets
                                            -- have been flushed to the device
        MemWrOverCo      : out   std_logic; -- This signal is the combinational
                                            -- version of the MemWrOver
        MemRdOver        : out   std_logic; -- This signal indicates that the
                                            -- all data packets are read from
                                            -- the memory device at the end of
                                            -- read access time
        MemRdOverCo      : out   std_logic; -- Combinational version of the
                                            -- MemRdOver
        BMlenEnd         : out   std_logic; -- Burst length termination signal
                                            -- during burst reads
        RdWrBuf          : out   std_logic_vector(31 downto 0);
                                            -- Read data path from the EIB block
                                            -- to the HRDATA lines in the AHB
                                            -- interface block
        AhbRdEn          : out   std_logic; -- Enabling signal to route data to
                                            -- HRDATA bus on read completion
        SmcAddrReg       : out   std_logic_vector(3 downto 1)
                                            -- Registered version of SMCADDR
       );
end SmcEIB;

-- -----------------------------------------------------------------------------
--
--                                   SmcEIB
--                                   ======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         The function of this module is to provide interface with the
--         external memory devices for facilitating the read and write
--         transactions. The device control signals along with the address
--         and data paths are generated.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SmcEIB is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iSMCS            : std_logic_vector(7 downto 0);
-- Internal copy of the chip select signals SMCS

signal NextSMCS         : std_logic_vector(7 downto 0);
-- D-input of the SMCS signal

signal inSMOEN          : std_logic;
-- Internal copy of nSMOEN

signal NextnSMOEN       : std_logic;
-- D-input of nSMOEN

signal inSMCDATAEN      : std_logic_vector(3 downto 0);
-- Internal copy of nSMCDATAEN

signal NextnSMCDATAEN   : std_logic_vector(3 downto 0);
-- D-input of nSMCDATAEN

signal iSMCADDR         : std_logic_vector(25 downto 0);
-- Internal copy of the SMCADDR bus

signal NextSMCADDR      : std_logic_vector(25 downto 0);
-- D-input of SMCADDR

signal HAddrSel         : std_logic_vector(1 downto 0);
-- The lower order of registered address selected, depending on whether transfer
-- is a new transfer or a waited transfer

signal WrBufWrEnCo      : std_logic_vector(3 downto 0);
-- Combinational version of the WrBufWrEn

signal WrBufWrEn        : std_logic_vector(3 downto 0);
-- Internal copy of the WrBufWrEn

signal NextWrBufWrEn    : std_logic_vector(3 downto 0);
-- D-input of WrBufWrEn

signal RdBufWrEn        : std_logic_vector(3 downto 0);
-- The temporary Buf write enables generated for storing the read data

signal TmpBufDat        : std_logic_vector(31 downto 0);
-- Multiplexed output to the RdWrBuf which selects between the write data path
-- and read data path

signal TmpRdDat         : std_logic_vector(31 downto 0);
-- Temporary read data multiplexed output to the RdWrBuf during read transfers
-- which takes care of the endianness, HSIZE and MSize

signal iRdWrBuf         : std_logic_vector(31 downto 0);
-- The internal read-write buffer to store the intermediate data packets during
-- a read or a write transfer

signal NextRdWrBuf      : std_logic_vector(31 downto 0);
-- D-input of the RdWrBuf buffer

signal iMemWrOver       : std_logic;
-- Internal copy of MemWrOver

signal NextMemWrOver    : std_logic;
-- D-input of MemWrOver

signal iSMCDATAOUT      : std_logic_vector(31 downto 0);
-- Internal copy of SMCDATAOUT data bus

signal NextSMCDATAOUT   : std_logic_vector(31 downto 0);
-- D-input of SMCDATAOUT

signal iMemRdOver       : std_logic;
-- Internal copy of MemRdOver

signal NextMemRdOver    : std_logic;
-- D-input of MemRdOver

signal iBMlenEnd        : std_logic;
-- Internal copy of BMlenEnd

signal NextBMlenEnd     : std_logic;
-- D-input of BMlenEnd

signal iPosSMWEN        : std_logic;
-- Local copy of PosSMWEN

signal NextPosSMWEN     : std_logic;
-- D-input of PosSMWEN

signal iPosSMBLS        : std_logic_vector(3 downto 0);
-- Local copy of PosSMBLS

signal NextPosSMBLS     : std_logic_vector(3 downto 0);
-- D-input of PosSMBLS

signal BufWrOvStrE      : std_logic;
-- The buffer WR completion signal is stored till the MemWrOver is asserted

signal NextBufWrOvStrE  : std_logic;
-- D-input of BufWrOvStrE

signal BurstAddr        : std_logic_vector(9 downto 0);
-- During burst reads, the HADDR is updated in advance using the HBURST and
-- HSIZE information

signal NextBurstAddr    : std_logic_vector(9 downto 0);
-- D-input of BurstAddr

signal iAhbRdEn         : std_logic;
-- Enabling signal to route data to HRDATA bus on read completion

signal NextAhbRdEn      : std_logic;
-- D-input of AhbRdEn

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
-- Advance address generation during burst reads depending on the value of
-- HBURST. This is the advance evaluation of the next HADDRIN depending
-- on the HSIZE and HBURST values
-- -----------------------------------------------------------------------------
p_BMAddrComb : process (BurstAddr, BMRdTrans, BrstAddIncCo, HBurstRegCo,
                        HSizeRegCo, MemRdReq, HAddrCrnt, WtdRdReq, iMemWrOver,
                        MwPgm, HAddrWtdCo, HTransRegCo, FastRdOp)
begin
  NextBurstAddr    <= BurstAddr;

  if (BMRdTrans = '1' and BrstAddIncCo = '1') then
    case HBurstRegCo is
      when INCR | INCR4 | INCR8 | INCR16  =>
        case HSizeRegCo is
          when "10" =>
            NextBurstAddr(1 downto 0) <= "00";
            NextBurstAddr(9 downto 2) <= unsigned(BurstAddr(9 downto 2)) + 1;
          when "01" =>
            NextBurstAddr(0)          <= '0';
            NextBurstAddr(9 downto 1) <= unsigned(BurstAddr(9 downto 1)) + 1;
          when "00" =>
            NextBurstAddr(9 downto 0) <= unsigned(BurstAddr(9 downto 0)) + 1;
          when others =>
            null;
        end case;
      when WRAP4  =>
        case HSizeRegCo is
          when "10" =>
            NextBurstAddr(9 downto 4) <= BurstAddr(9 downto 4);
            NextBurstAddr(3 downto 2) <= unsigned(BurstAddr(3 downto 2)) + 1;
            NextBurstAddr(1 downto 0) <= "00";
          when "01" =>
            NextBurstAddr(9 downto 3) <= BurstAddr(9 downto 3);
            NextBurstAddr(2 downto 1) <= unsigned(BurstAddr(2 downto 1)) + 1;
            NextBurstAddr(0)          <= '0';
          when "00" =>
            NextBurstAddr(9 downto 2) <= BurstAddr(9 downto 2);
            NextBurstAddr(1 downto 0) <= unsigned(BurstAddr(1 downto 0)) + 1;
          when others =>
            null;
        end case;
      when WRAP8  =>
        case HSizeRegCo is
          when "10" =>
            NextBurstAddr(9 downto 5) <= BurstAddr(9 downto 5);
            NextBurstAddr(4 downto 2) <= unsigned(BurstAddr(4 downto 2)) + 1;
            NextBurstAddr(1 downto 0) <= "00";
          when "01" =>
            NextBurstAddr(9 downto 4) <= BurstAddr(9 downto 4);
            NextBurstAddr(3 downto 1) <= unsigned(BurstAddr(3 downto 1)) + 1;
            NextBurstAddr(0)          <= '0';
          when "00" =>
            NextBurstAddr(9 downto 3) <= BurstAddr(9 downto 3);
            NextBurstAddr(2 downto 0) <= unsigned(BurstAddr(2 downto 0)) + 1;
          when others =>
            null;
        end case;
      when WRAP16 =>
        case HSizeRegCo is
          when "10" =>
            NextBurstAddr(9 downto 6) <= BurstAddr(9 downto 6);
            NextBurstAddr(5 downto 2) <= unsigned(BurstAddr(5 downto 2)) + 1;
            NextBurstAddr(1 downto 0) <= "00";
          when "01" =>
            NextBurstAddr(9 downto 5) <= BurstAddr(9 downto 5);
            NextBurstAddr(4 downto 1) <= unsigned(BurstAddr(4 downto 1)) + 1;
            NextBurstAddr(0)          <= '0';
          when "00" =>
            NextBurstAddr(9 downto 4) <= BurstAddr(9 downto 4);
            NextBurstAddr(3 downto 0) <= unsigned(BurstAddr(3 downto 0)) + 1;
          when others =>
            null;
        end case;
      when others =>
        null;
    end case;
  -- Initialise to the start of the Burst Address for a new Read transaction
  -- request with NSEQ. This can be a new Read request after IDLE or on
  -- completion of previous Write or Read. It can also be a Read request which
  -- is detected at end of a Burst Read transaction. In these cases the current
  -- stored bus address must be loaded.
  elsif (MemRdReq = '1' and
         (BMRdTrans = '0' or
          (BMRdTrans = '1' and
           (HTransRegCo = T_NONSEQ or FastRdOp = '1')))) then
    NextBurstAddr    <= HAddrCrnt(9 downto 0);

  -- Initialise to the start of the Burst Address in the Waited Read Mode
  elsif (WtdRdReq = '1' and (iMemWrOver = '1' or MwPgm = '1')) then
    NextBurstAddr    <= HAddrWtdCo(9 downto 0);
  end if;
end process p_BMAddrComb;

-- -----------------------------------------------------------------------------
-- External address [SMCADDR] generation logic
-- -----------------------------------------------------------------------------
p_SmAddrGenComb : process (iSMCADDR, HAddrCrnt, HAddrWtdCo, MemWrReq, MemRdReq,
                           AddrIncCo, MSize08, MSize16, WtdWrReq, WtdRdReq,
                           iMemWrOver, MwPgm, BMRdTrans, NextBurstAddr,
                           NextMemRdOver, HTransRegCo, FastRdOp)
begin
  NextSMCADDR      <= iSMCADDR;
  HAddrSel         <= "00";

  if (AddrIncCo = '1') then
    NextSMCADDR(25 downto 10) <= iSMCADDR(25 downto 10);
    if (MSize08 = '1') then
      NextSMCADDR(9 downto 0) <= unsigned(iSMCADDR(9 downto 0)) + 1;
    elsif (MSize16 = '1') then
      NextSMCADDR(0)          <= '0';
      NextSMCADDR(9 downto 1) <= unsigned(iSMCADDR(9 downto 1)) + 1;
    end if;
  elsif (BMRdTrans = '1' and NextMemRdOver = '1') then
    NextSMCADDR(25 downto 10) <= iSMCADDR(25 downto 10);
    NextSMCADDR(9 downto 0)   <= NextBurstAddr;
  -- Initialise to the start of the Address for a new Read or Write transaction
  -- request with NSEQ. This can be a new Read or Write request after IDLE or on
  -- completion of previous Write or Read. It can also be a Read request which
  -- is detected at end of a Burst Read transaction. In these cases the current
  -- stored bus address must be loaded.
  elsif (MemWrReq = '1' or 
         (BMRdTrans = '0' and MemRdReq = '1') or
         (BMRdTrans = '1' and MemRdReq = '1' and
          (HTransRegCo = T_NONSEQ or FastRdOp = '1'))) then
    NextSMCADDR <= HAddrCrnt;
    HAddrSel    <= HAddrCrnt(1 downto 0);
  elsif ((WtdWrReq = '1' or WtdRdReq = '1') and
         (iMemWrOver = '1' or MwPgm = '1')) then
    NextSMCADDR <= HAddrWtdCo;
    HAddrSel    <= HAddrWtdCo(1 downto 0);
  end if;
end process p_SmAddrGenComb;

-- -----------------------------------------------------------------------------
-- Clocked logic for the SMCADDR address lines
-- -----------------------------------------------------------------------------
p_SmAddrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSMCADDR         <= (others => '0');
    BurstAddr        <= (others => '0');
    SmcAddrReg       <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iSMCADDR         <= NextSMCADDR;
    BurstAddr        <= NextBurstAddr;
    SmcAddrReg       <= iSMCADDR(3 downto 1);
  end if;
end process p_SmAddrGenSeq;

-- -----------------------------------------------------------------------------
-- Logic for generating the Buffer enables for storing the write data
-- making these active low for implementation reuse ease. These write enables
-- will be used while generating the SMBLS output pins
-- -----------------------------------------------------------------------------
p_WrBufWrEnComb : process (BIGENDIAN, HAddrSel, HSizeRegCo, iMemWrOver,
                           MemWrReq, WrBufWrEn, WtdWrReq, NextMemWrOver, MwPgm)
begin
  NextWrBufWrEn    <= WrBufWrEn;
  WrBufWrEnCo      <= "1111";

  if (MemWrReq = '1' or
      ((iMemWrOver = '1' or MwPgm = '1') and WtdWrReq = '1')) then
    if (HSizeRegCo = "10") then
      NextWrBufWrEn <= "0000";
      WrBufWrEnCo <= "0000";
    elsif (HSizeRegCo = "01") then
      case HAddrSel(1) is
        when '0' =>
          if (BIGENDIAN = '0') then
            NextWrBufWrEn(1 downto 0) <= "00";
            WrBufWrEnCo               <= "1100";
          else
            NextWrBufWrEn(3 downto 2) <= "00";
            WrBufWrEnCo               <= "0011";
          end if;
        when '1' =>
          if (BIGENDIAN = '0') then
            NextWrBufWrEn(3 downto 2) <= "00";
            WrBufWrEnCo               <= "0011";
          else
            NextWrBufWrEn(1 downto 0) <= "00";
            WrBufWrEnCo               <= "1100";
          end if;
        when others =>
          null;
      end case;
    elsif (HSizeRegCo = "00") then
      case HAddrSel is
        when "00" =>
          if (BIGENDIAN = '0') then
            NextWrBufWrEn(0) <= '0';
            WrBufWrEnCo      <= "1110";
          else
            NextWrBufWrEn(3) <= '0';
            WrBufWrEnCo      <= "0111";
          end if;
        when "01" =>
          if (BIGENDIAN = '0') then
            NextWrBufWrEn(1) <= '0';
            WrBufWrEnCo      <= "1101";
          else
            NextWrBufWrEn(2) <= '0';
            WrBufWrEnCo      <= "1011";
          end if;
        when "10" =>
          if (BIGENDIAN = '0') then
            NextWrBufWrEn(2) <= '0';
            WrBufWrEnCo      <= "1011";
          else
            NextWrBufWrEn(1) <= '0';
            WrBufWrEnCo      <= "1101";
          end if;
        when "11" =>
          if (BIGENDIAN = '0') then
            NextWrBufWrEn(3) <= '0';
            WrBufWrEnCo      <= "0111";
          else
            NextWrBufWrEn(0) <= '0';
            WrBufWrEnCo      <= "1110";
          end if;
        when others =>
          null;
      end case;
    end if;
  elsif (NextMemWrOver = '1') then
    NextWrBufWrEn    <= "1111";
  end if;
end process p_WrBufWrEnComb;

-- -----------------------------------------------------------------------------
-- Logic for generating the Buffer enables for storing the read data
-- -----------------------------------------------------------------------------
p_RdBufWrEnComb : process (BIGENDIAN, iSMCADDR, MSize08, MSize16, MSize32,
                           CntEnd, SmcState, CntEZEnd)
begin
  RdBufWrEn    <= (others => '0');

  if ((CntEnd = '1' or CntEZEnd = '1') and SmcState = ST_TSM_MEMRD) then
    if (MSize32 = '1') then
      RdBufWrEn(3 downto 0)   <= "1111";
    elsif (MSize16 = '1') then
      case iSMCADDR(1) is
        when '0' =>
          if (BIGENDIAN = '0') then
            RdBufWrEn(3 downto 0)   <= "0011";
          else
            RdBufWrEn(3 downto 0)   <= "1100";
          end if;
        when '1' =>
          if (BIGENDIAN = '0') then
            RdBufWrEn(3 downto 0)   <= "1100";
          else
            RdBufWrEn(3 downto 0)   <= "0011";
          end if;
        when others =>
          null;
      end case;
    elsif (MSize08 = '1') then
      case iSMCADDR(1 downto 0) is
        when "00" =>
          if (BIGENDIAN = '0') then
            RdBufWrEn(3 downto 0)   <= "0001";
          else
            RdBufWrEn(3 downto 0)   <= "1000";
          end if;
        when "01" =>
          if (BIGENDIAN = '0') then
            RdBufWrEn(3 downto 0)   <= "0010";
          else
            RdBufWrEn(3 downto 0)   <= "0100";
          end if;
        when "10" =>
          if (BIGENDIAN = '0') then
            RdBufWrEn(3 downto 0)   <= "0100";
          else
            RdBufWrEn(3 downto 0)   <= "0010";
          end if;
        when "11" =>
          if (BIGENDIAN = '0') then
            RdBufWrEn(3 downto 0)   <= "1000";
          else
            RdBufWrEn(3 downto 0)   <= "0001";
          end if;
        when others =>
          null;
      end case;
    end if;
  end if;
end process p_RdBufWrEnComb;

-- -----------------------------------------------------------------------------
-- Combinational logic for multiplexing the read data and write data into a
-- temporary data bus before storing into the RdWrBuf
-- -----------------------------------------------------------------------------
p_TmpBufStrComb : process (MemWrReq, iMemWrOver, HWDATA, TmpRdDat,
                           WtdWrReq, MwPgm)
begin

  if (MemWrReq = '1' or ((iMemWrOver = '1' or MwPgm = '1') and
                         WtdWrReq = '1')) then
    TmpBufDat        <= HWDATA;
  else
    TmpBufDat        <= TmpRdDat;
  end if;
end process p_TmpBufStrComb;

-- -----------------------------------------------------------------------------
-- Logic for storing/routing the write data or read data into the RdWr buffer
-- -----------------------------------------------------------------------------
NextRdWrBuf(7 downto 0)   <= TmpBufDat(7 downto 0)
                          when
                            (WrBufWrEnCo(0) = '0' or RdBufWrEn(0) = '1')
                          else
                            iRdWrBuf(7 downto 0);

NextRdWrBuf(15 downto 8)  <= TmpBufDat(15 downto 8)
                          when
                            (WrBufWrEnCo(1) = '0' or RdBufWrEn(1) = '1')
                          else
                            iRdWrBuf(15 downto 8);

NextRdWrBuf(23 downto 16) <= TmpBufDat(23 downto 16)
                          when
                            (WrBufWrEnCo(2) = '0' or RdBufWrEn(2) = '1')
                          else
                            iRdWrBuf(23 downto 16);

NextRdWrBuf(31 downto 24) <= TmpBufDat(31 downto 24)
                          when
                            (WrBufWrEnCo(3) = '0' or RdBufWrEn(3) = '1')
                          else
                            iRdWrBuf(31 downto 24);

-- -----------------------------------------------------------------------------
-- Clocked process for the RdWrBuf updation and write control signals
-- -----------------------------------------------------------------------------
p_RdWrBufSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iRdWrBuf         <= (others => '0');
    iMemWrOver       <= '0';
    WrBufWrEn        <= (others => '1');
  elsif (HCLK'event and HCLK = '1') then
    iRdWrBuf         <= NextRdWrBuf;
    iMemWrOver       <= NextMemWrOver;
    WrBufWrEn        <= NextWrBufWrEn;
  end if;
end process p_RdWrBufSeq;

-- -----------------------------------------------------------------------------
-- Logic to determine the completion of writing out to the Memory device
-- It depends on the MSIZE value and the number of data packets to be
-- written out to device in that many number of access. The SmcCore will be
-- in the MEM_WR state.
-- -----------------------------------------------------------------------------
p_MemWrOvrComb : process (MW, HSizeRegCo, iSMCADDR, SmcState, CntEnd, 
                          CntEZEnd, WaitToutErr)
begin
  if ((SmcState = ST_TSM_MEMWR) and (WaitToutErr = '1')) then
    NextMemWrOver    <= '1';
  else
    NextMemWrOver    <= '0';
  end if;

  if ((SmcState = ST_TSM_MEMWR and (CntEnd = '1' or CntEZEnd = '1'))
     and
      (MW = "10" or HSizeRegCo = "00" or
       (HSizeRegCo = "10" and
        ((MW = "01" and iSMCADDR(1) = '1') or
         (MW = "00" and iSMCADDR(1 downto 0) = "11")))
       or
       (HSizeRegCo = "01" and
        (MW = "01" or (MW = "00" and iSMCADDR(0) = '1')))
      )
     ) then
    NextMemWrOver    <= '1';
  end if;
end process p_MemWrOvrComb;

-- -----------------------------------------------------------------------------
-- Logic for storing the BufWrOver signal when the HSIZE > MSize during WR
-- -----------------------------------------------------------------------------
NextBufWrOvStrE  <= '1' when (BufWrOver = '1')
                 else
                   '0' when (NextMemWrOver = '1' or SmcState = ST_TSM_MEMRD or
                             SmcState = ST_TSM_IDLE)
                 else
                   BufWrOvStrE;

-- -----------------------------------------------------------------------------
-- Logic to route the external memory data SMCDATAOUT
-- During writes depending on the memory width, the corresponding byte lanes
-- are driven.
-- During reads, at the end of the read access time the relevant SMCDATAIN
-- byte lanes are routed to SMCDATAOUT for recirculation of the data.
-- -----------------------------------------------------------------------------
p_ExtDatOutComb : process (MSize08, MSize16, MSize32, SMCDATAIN, CntEnd,
                           SmcState, iSMCDATAOUT, iRdWrBuf,
                           BIGENDIAN, BufWrOver, BufWrOvStrE, BufByPassCo,
                           TmpBufDat, NextSMCADDR, MemWrReq, iMemWrOver,
                           WtdWrReq, MwPgm, CntEZEnd)
begin
  NextSMCDATAOUT   <= iSMCDATAOUT;

  if (BufByPassCo = '1' and
      (MemWrReq = '1' or ((iMemWrOver = '1' or MwPgm = '1') and
                          WtdWrReq = '1'))) then
    if (MSize32 = '1') then
      NextSMCDATAOUT <= TmpBufDat;
    elsif (MSize16 = '1') then
      case NextSMCADDR(1) is
        when '0' =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(15 downto 0) <= TmpBufDat(15 downto 0);
          else
            NextSMCDATAOUT(15 downto 0) <= TmpBufDat(31 downto 16);
          end if;
        when '1' =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(15 downto 0) <= TmpBufDat(31 downto 16);
          else
            NextSMCDATAOUT(15 downto 0) <= TmpBufDat(15 downto 0);
          end if;
        when others =>
          null;
      end case;
    elsif (MSize08 = '1') then
      case NextSMCADDR(1 downto 0) is
        when "00" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(7 downto 0);
          else
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(31 downto 24);
          end if;
        when "01" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(15 downto 8);
          else
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(23 downto 16);
          end if;
        when "10" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(23 downto 16);
          else
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(15 downto 8);
          end if;
        when "11" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(31 downto 24);
          else
            NextSMCDATAOUT(7 downto 0) <= TmpBufDat(7 downto 0);
          end if;
        when others =>
          null;
      end case;
    end if;
  elsif (BufWrOver = '1' or BufWrOvStrE = '1') then
    if (MSize32 = '1') then
      NextSMCDATAOUT <= iRdWrBuf;
    elsif (MSize16 = '1') then
      case NextSMCADDR(1) is
        when '0' =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(15 downto 0) <= iRdWrBuf(15 downto 0);
          else
            NextSMCDATAOUT(15 downto 0) <= iRdWrBuf(31 downto 16);
          end if;
        when '1' =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(15 downto 0) <= iRdWrBuf(31 downto 16);
          else
            NextSMCDATAOUT(15 downto 0) <= iRdWrBuf(15 downto 0);
          end if;
        when others =>
          null;
      end case;
    elsif (MSize08 = '1') then
      case NextSMCADDR(1 downto 0) is
        when "00" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(7 downto 0);
          else
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(31 downto 24);
          end if;
        when "01" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(15 downto 8);
          else
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(23 downto 16);
          end if;
        when "10" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(23 downto 16);
          else
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(15 downto 8);
          end if;
        when "11" =>
          if (BIGENDIAN = '0') then
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(31 downto 24);
          else
            NextSMCDATAOUT(7 downto 0) <= iRdWrBuf(7 downto 0);
          end if;
        when others =>
          null;
      end case;
    end if;
  elsif ((CntEnd = '1' or CntEZEnd = '1') and SmcState = ST_TSM_MEMRD) then
    if (MSize32 = '1') then
      NextSMCDATAOUT <= SMCDATAIN;
    elsif (MSize16 = '1') then
      NextSMCDATAOUT(15 downto 0) <= SMCDATAIN(15 downto 0);
    elsif (MSize08 = '1') then
      NextSMCDATAOUT(7 downto 0)  <= SMCDATAIN(7 downto 0);
    end if;
  end if;
end process p_ExtDatOutComb;

-- -----------------------------------------------------------------------------
-- Clocked logic for the SMCDATAOUT data lines
-- -----------------------------------------------------------------------------
p_ExtDatOutSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSMCDATAOUT      <= (others => '0');
    BufWrOvStrE      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iSMCDATAOUT      <= NextSMCDATAOUT;
    BufWrOvStrE      <= NextBufWrOvStrE;
  end if;
end process p_ExtDatOutSeq;

-- -----------------------------------------------------------------------------
-- Logic to determine the completion of reading in from the Memory device
-- It depends on the MSIZE & HSIZE value and the number of data packets
-- read in from memory device.
-- -----------------------------------------------------------------------------
p_MemRdOvrComb : process (MW, HSizeRegCo, CntEnd, iSMCADDR, SmcState, CntEZEnd,
                          HTransRegCo, BMRdTrans, iAhbRdEn, WaitToutErr)
begin
  if ((SmcState = ST_TSM_MEMRD) and (WaitToutErr = '1')) then
    NextMemRdOver    <= '1';
  else
    NextMemRdOver    <= '0';
  end if;

  if (((CntEnd = '1' or CntEZEnd = '1') and SmcState = ST_TSM_MEMRD and
       (not(iAhbRdEn = '1' and BMRdTrans = '1' and
        (HTransRegCo = T_NONSEQ or HTransRegCo = T_IDLE))))
     and
      ((HSizeRegCo = "10" and
        (MW = "10" or (MW = "01" and iSMCADDR(1) = '1') or
         (MW = "00" and iSMCADDR(1 downto 0) = "11")))
      or
       (HSizeRegCo = "01" and
        (MW = "10" or MW = "01" or (MW = "00" and iSMCADDR(0) = '1')))
      or
       (HSizeRegCo = "00")
      )
     ) then
    NextMemRdOver <= '1';
  end if;
end process p_MemRdOvrComb;

-- -----------------------------------------------------------------------------
-- At the completion of the read, enabling signal is generated for routing
-- data from internal busffer to the HRDATA bus in the Ahbif module
-- -----------------------------------------------------------------------------
NextAhbRdEn      <= '1' when (iMemRdOver = '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Clocked logic for the intermediate signals
-- -----------------------------------------------------------------------------
p_RdContSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iMemRdOver       <= '0';
    iBMlenEnd        <= '0';
    iAhbRdEn         <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iMemRdOver       <= NextMemRdOver;
    iBMlenEnd        <= NextBMlenEnd;
    iAhbRdEn         <= NextAhbRdEn;
  end if;
end process p_RdContSeq;

-- -----------------------------------------------------------------------------
-- Logic to determine the end of the Burst length and the crossover of the
-- address Quad-boundary. This logic is used for the purpose of introducing
-- the burst length restriction.
-- -----------------------------------------------------------------------------
p_BMlenComb : process (iBMlenEnd, BM, MSize08, MSize16, MSize32, NextSMCADDR,
                       RdCntLdCo, HBurstRegCo, HSizeRegCo, MW)
begin
  NextBMlenEnd     <= iBMlenEnd;

  if (BM = '1') then
    if (RdCntLdCo = '1') then
      NextBMlenEnd     <= '0';
    elsif (((MSize08 = '1' and NextSMCADDR(1 downto 0) = "11") or
            (MSize16 = '1' and NextSMCADDR(2 downto 1) = "11") or
            (MSize32 = '1' and NextSMCADDR(3 downto 2) = "11")) and
           ((HSizeRegCo > MW) or
            (HBurstRegCo /= WRAP4 and HSizeRegCo = MW) or
            (HBurstRegCo /= WRAP8 and ((HSizeRegCo = "00" and MSize16 = '1') or
                                      (HSizeRegCo = "01" and MSize32 = '1'))) or
            (HBurstRegCo /= WRAP16 and (HSizeRegCo = "00" and
                                        MSize32 = '1')))) then
      NextBMlenEnd     <= '1';
    end if;
  end if;
end process p_BMlenComb;

-- -----------------------------------------------------------------------------
-- Chip Select generation logic - combinational process select to activate
-- the CS for the appropriate memory bank
-- -----------------------------------------------------------------------------
p_CSgenComb : process (SMCsEnCo, BnkAddStrCo, CSPol, iSMCS, RemapReg)
begin
  NextSMCS       <= iSMCS;

  if (SMCsEnCo = '1') then
    case BnkAddStrCo is
      when "000" =>
        if (RemapReg = '1') then
          NextSMCS(0)  <= CSPol(0);
          NextSMCS(7)  <= not (CSPol(7));
        else
          NextSMCS(0)  <= not (CSPol(0));
          NextSMCS(7)  <= CSPol(7);
        end if;
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= not (CSPol(6));
      when "001" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= CSPol(1);
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= not (CSPol(6));
        NextSMCS(7)  <= not (CSPol(7));
      when "010" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= CSPol(2);
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= not (CSPol(6));
        NextSMCS(7)  <= not (CSPol(7));
      when "011" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= CSPol(3);
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= not (CSPol(6));
        NextSMCS(7)  <= not (CSPol(7));
      when "100" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= CSPol(4);
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= not (CSPol(6));
        NextSMCS(7)  <= not (CSPol(7));
      when "101" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= CSPol(5);
        NextSMCS(6)  <= not (CSPol(6));
        NextSMCS(7)  <= not (CSPol(7));
      when "110" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= CSPol(6);
        NextSMCS(7)  <= not (CSPol(7));
      when "111" =>
        NextSMCS(0)  <= not (CSPol(0));
        NextSMCS(1)  <= not (CSPol(1));
        NextSMCS(2)  <= not (CSPol(2));
        NextSMCS(3)  <= not (CSPol(3));
        NextSMCS(4)  <= not (CSPol(4));
        NextSMCS(5)  <= not (CSPol(5));
        NextSMCS(6)  <= not (CSPol(6));
        NextSMCS(7)  <= CSPol(7);
      when others =>
        null;
    end case;
  else
      NextSMCS(0)  <= not (CSPol(0));
      NextSMCS(1)  <= not (CSPol(1));
      NextSMCS(2)  <= not (CSPol(2));
      NextSMCS(3)  <= not (CSPol(3));
      NextSMCS(4)  <= not (CSPol(4));
      NextSMCS(5)  <= not (CSPol(5));
      NextSMCS(6)  <= not (CSPol(6));
      NextSMCS(7)  <= not (CSPol(7));
  end if;
end process p_CSgenComb;

-- -----------------------------------------------------------------------------
-- Generation of the output enable (OEN) signal for the memory devices
--  - combinational logic.
-- The SMOEN is enabled or disabled depending on the control signal from
-- the TSM module.
-- -----------------------------------------------------------------------------
p_OEgenComb : process (XoutEnCo, XoutDisCo, inSMOEN)
begin
  NextnSMOEN       <= inSMOEN;

  if (XoutEnCo = '1') then
    NextnSMOEN  <= '0';
  elsif (XoutDisCo = '1') then
    NextnSMOEN  <= '1';
  end if;
end process p_OEgenComb;

-- -----------------------------------------------------------------------------
-- Generation of the external data bus byte lane enables SMCDATAEN
--  - combinational logic.
-- The SMCDATAEN enables and disables depends on the type of the transfer in
-- progress. It is appropriately enabled so as to aid in the re-circulation
-- logic.
-- -----------------------------------------------------------------------------
p_DatEnComb : process (inSMCDATAEN, XdatDisCo, RdXdatEnCo, WrXdatEnCo,
                       MSize08, MSize16, MSize32)
begin
  NextnSMCDATAEN    <= inSMCDATAEN;

  if (XdatDisCo = '1') then
   NextnSMCDATAEN  <= "1111";
  elsif (RdXdatEnCo = '1') then
    if (MSize08 = '1') then
      NextnSMCDATAEN  <= "0001";
    elsif (MSize16 = '1') then
      NextnSMCDATAEN  <= "0011";
    elsif (MSize32 = '1') then
      NextnSMCDATAEN  <= "1111";
    end if;
  elsif (WrXdatEnCo = '1') then
    NextnSMCDATAEN  <= "0000";
  end if;
end process p_DatEnComb;

-- -----------------------------------------------------------------------------
-- Chip Select, output enables and data enables generation logic
--  - clocked process
-- chip select polarities are assumed active low by default.
-- -----------------------------------------------------------------------------
p_ContgenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSMCS        <= (others => '1');
    inSMOEN      <= '1';
    inSMCDATAEN  <= "1111";
  elsif (HCLK'event and HCLK = '1') then
    iSMCS        <= NextSMCS;
    inSMOEN      <= NextnSMOEN;
    inSMCDATAEN  <= NextnSMCDATAEN;
  end if;
end process p_ContgenSeq;

-- -----------------------------------------------------------------------------
-- Read in data from the memory device at the end of the read access time. This
-- data is then routed to the RdWrBuf
-- -----------------------------------------------------------------------------
p_MemRdComb : process (BIGENDIAN, MSize08, MSize16, MSize32, iSMCADDR,
                       CntEnd, SmcState, SMCDATAIN, CntEZEnd)
begin
  TmpRdDat         <= (others => '0');

  if ((CntEnd = '1' or CntEZEnd = '1') and SmcState = ST_TSM_MEMRD) then
    if (MSize32 = '1') then
      TmpRdDat(31 downto 0) <= SMCDATAIN(31 downto 0);
    elsif (MSize16 = '1') then
      case iSMCADDR(1) is
        when '1' =>
          if (BIGENDIAN = '0') then
            TmpRdDat(31 downto 16) <= SMCDATAIN(15 downto 0);
          else
            TmpRdDat(15 downto 0)  <= SMCDATAIN(15 downto 0);
          end if;
        when '0' =>
          if (BIGENDIAN = '0') then
            TmpRdDat(15 downto 0)  <= SMCDATAIN(15 downto 0);
          else
            TmpRdDat(31 downto 16) <= SMCDATAIN(15 downto 0);
          end if;
        when others =>
          null;
      end case;
    elsif (MSize08 = '1') then
      case iSMCADDR(1 downto 0)is
        when "11" =>
          if (BIGENDIAN = '0') then
            TmpRdDat(31 downto 24) <= SMCDATAIN(7 downto 0);
          else
            TmpRdDat(7 downto 0)   <= SMCDATAIN(7 downto 0);
          end if;
        when "10" =>
          if (BIGENDIAN = '0') then
            TmpRdDat(23 downto 16) <= SMCDATAIN(7 downto 0);
          else
            TmpRdDat(15 downto 8)  <= SMCDATAIN(7 downto 0);
          end if;
        when "01" =>
          if (BIGENDIAN = '0') then
            TmpRdDat(15 downto 8)  <= SMCDATAIN(7 downto 0);
          else
            TmpRdDat(23 downto 16) <= SMCDATAIN(7 downto 0);
          end if;
        when "00" =>
          if (BIGENDIAN = '0') then
            TmpRdDat(7 downto 0)   <= SMCDATAIN(7 downto 0);
          else
            TmpRdDat(31 downto 24) <= SMCDATAIN(7 downto 0);
          end if;
        when others =>
          null;
      end case;
    end if;
  end if;
end process p_MemRdComb;

-- -----------------------------------------------------------------------------
-- Combinational logic for memory write enable and byte lane enables
-- -----------------------------------------------------------------------------
p_ExtWrGenComb : process (ExtWrEnCo, ExtWrDisCo, MSize08, MSize16, WrBufWrEn,
                          MSize32, iPosSMWEN, iPosSMBLS, RBLE, SMCsEnCo,
                          XoutEnCo, BIGENDIAN, iSMCADDR, BufByPassCo)
begin
  NextPosSMWEN     <= iPosSMWEN;
  NextPosSMBLS     <= iPosSMBLS;

  if (ExtWrDisCo = '1') then
    NextPosSMWEN <= '1';
    if (RBLE = '0') then
      NextPosSMBLS <= "1111";
    end if;

  elsif (ExtWrEnCo = '1') then
    if (RBLE = '1') then
      NextPosSMWEN <= '0';
    else
      NextPosSMWEN <= '1';
    end if;

    if (BufByPassCo = '1') then
      if (MSize32 = '1') then
        NextPosSMBLS <= "0000";
      elsif (MSize16 = '1') then
        NextPosSMBLS <= "1100";
      elsif (MSize08 = '1') then
      NextPosSMBLS <= "1110";
    end if;
    else
      if (MSize32 = '1') then
        NextPosSMBLS <= WrBufWrEn;
      elsif (MSize16 = '1') then
        case iSMCADDR(1) is
          when '0' =>
            if (BIGENDIAN = '0') then
              NextPosSMBLS <= "11" & WrBufWrEn(1 downto 0);
            else
              NextPosSMBLS <= "11" & WrBufWrEn(3 downto 2);
            end if;
          when '1' =>
            if (BIGENDIAN = '0') then
              NextPosSMBLS <= "11" & WrBufWrEn(3 downto 2);
            else
              NextPosSMBLS <= "11" & WrBufWrEn(1 downto 0);
            end if;
          when others =>
              null;
        end case;
      elsif (MSize08 = '1') then
        NextPosSMBLS <= "1110";
      end if;
    end if;
  elsif (XoutEnCo = '1' and RBLE = '1') then
    NextPosSMBLS <= "0000";
  elsif (SMCsEnCo = '0') then
    NextPosSMBLS <= "1111";
  end if;

end process p_ExtWrGenComb;

-- -----------------------------------------------------------------------------
-- Sequential/clocked logic for the positive write enable signals
-- -----------------------------------------------------------------------------
p_PosWrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iPosSMWEN        <= '1';
    iPosSMBLS        <= (others => '1');
  elsif (HCLK'event and HCLK = '1') then
    iPosSMWEN        <= NextPosSMWEN;
    iPosSMBLS        <= NextPosSMBLS;
  end if;

end process p_PosWrGenSeq;

-- -----------------------------------------------------------------------------
-- Connecting local copies to the outputs
-- -----------------------------------------------------------------------------
SMCS             <= iSMCS;
SMCDATAOUT       <= iSMCDATAOUT;
MemRdOver        <= iMemRdOver;
MemRdOverCo      <= NextMemRdOver;
RdWrBuf          <= iRdWrBuf;
nSMOEN           <= inSMOEN;
SMCADDR          <= iSMCADDR;
nSMCDATAEN       <= inSMCDATAEN;
BMlenEnd         <= iBMlenEnd;
MemWrOver        <= iMemWrOver;
MemWrOverCo      <= NextMemWrOver;
PosSMWEN         <= iPosSMWEN;
PosSMBLS         <= iPosSMBLS;
AhbRdEn          <= iAhbRdEn;

end synth;

-- --================================== End ==================================--
