-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : buswatchmaster.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Protocol checker for AHB Master testbench
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

library common;
use common.defsmaster.all;
use common.funcsmaster.all;
use common.funcs.all;
use common.configmaster.all;

library chip;
use chip.buswmaster_pck.all;

-- ---------------------------------------------------------------------

entity buswatchmaster is
  generic (
           HaltOnMismatch : boolean;
           Verbosity      : boolean;
           Tclk           : time;
           Tovtr          : time;
           Tohtr          : time;
           Tova           : time;
           Toha           : time;
           Tovctl         : time;
           Tohctl         : time;
           Tovwd          : time;
           Tohwd          : time;
           Tovreq         : time;
           Tohreq         : time;
           Tovlck         : time;
           Tohlck         : time
          );
  port (
-- Inputs
        HCLK             : in    std_logic; -- The main bus clock
        HRESETn          : in    std_logic; -- Active low system reset
        HTRANS           : in    T_trans;   -- Signal driven out by
                                            -- master, denoting SEQ,
                                            -- NSEQ, BUSY or IDLE
                                            -- transfer
        HADDR            : in    T_addr;    -- 32 bit address lines
                                            -- driven by the master
        HSIZE            : in    T_size;    -- signal driven by master,
                                            -- denoting the size of
                                            -- transfer ex. byte, word
        HBURST           : in    T_burst;   -- signal driven by master,
                                            -- denoting type of burst
                                            -- ex. incr, wrap4
        HBUSREQx         : in    std_logic; -- driven by master; when
                                            -- HIGH, indicates that
                                            -- master requests the bus
        HGRANTx          : in    std_logic; -- signal indicating the
                                            -- grant-status of the
                                            -- master under test
        HREADY           : in    T_line;    -- signal indicating the
                                            -- completion of current
                                            -- transfer
        HLOCKx           : in    T_line;    -- when high, this indicates
                                            -- that master requires
                                            -- locked access
        HWDATA           : in    T_data;    -- write data, driven by the
                                            -- master
        HPROT            : in    T_prot;    -- signal driven by master,
                                            -- giving additional info
                                            -- about the bus-access
                                            -- eg. supervisor mode,
                                            -- opcode mode etc
        HWRITE           : in    T_line;    -- signal driven by master,
                                            -- denoting whether it is
                                            -- write or read
        HRESP            : in    T_resp;    -- 2 bit wide response
                                            -- signal, indicating ok,
                                            -- retry, split or busy
-- Outputs
        ResetOver        : out   boolean    -- indicates initial
                                            -- assertion/deassertion
                                            -- sequence of HRESETn
       );
end buswatchmaster;

-- ---------------------------------------------------------------------
--
--                           buswatchmaster
--                           ==============
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This module implements the protocol checks for AHB master's output
-- signals and will provide warnings and error messages if it finds some
-- mismatch.
--
-- --========================= ARCHITECTURE ==========================--

architecture behavioural of buswatchmaster is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ST_CHECK         : std_logic := '1';
constant ST_NOTCHECK      : std_logic := '0';
constant ST_DEGRANTED     : std_logic := '0';
constant ST_GRANTED       : std_logic := '1';

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal CurrentStReq     : std_logic := ST_NOTCHECK;
-- current state signal for the state m/c checking
-- Request-Assertion-Protocol

signal NextStReq        : std_logic := ST_NOTCHECK;
-- next state signal for the state m/c checking
-- Request-Assertion-Protocol

signal CurrentStLok     : std_logic := ST_NOTCHECK;
-- current state signal for the state m/c checking
-- Lock-Assertion-Protocol

signal NextStLok        : std_logic := ST_NOTCHECK;
-- next state signal for the state m/c checking Lock-Assertion-Protocol

signal CurrentStGnt     : std_logic := ST_DEGRANTED;
-- current state signals for the actual-grant checking state machine

signal NextStGnt        : std_logic := ST_DEGRANTED;
-- next state signals for the actual-grant checking state machine

signal ReqGnt           : std_logic_vector(1 downto 0);
-- concatenation of HBUSREQx and HGRANTx signal

signal LokGnt           : std_logic_vector(1 downto 0);
-- concatenation of HLOCKx and HGRANTx signal

signal GntRdy           : std_logic_vector(1 downto 0);
-- concatenation of HGRANTx and HREADY signal

signal PrevAddr         : T_addr;
-- stores the value of HADDR of the previous transfer

signal PrevAddrWait     : T_addr;
-- stores the value of HADDR of the previous transfer in wait state

signal PrevTrans        : T_trans;
-- stores the value of HTRANS of the previous transfer

signal PrevTransWait    : T_trans;
-- stores the value of HTRANS of the previous transfer in wait state

signal PrevWrite        : T_line;
-- stores the value of HWRITE of the previous transfer

signal PrevWriteWait    : T_line;
-- stores the value of HWRITE of the previous transfer in wait state

signal PrevSize         : T_size;
-- stores the value of HSIZE of the previous transfer

signal PrevSizeWait     : T_size;
-- stores the value of HSIZE of the previous transfer in wait state

signal PrevBurst        : T_burst;
-- stores the value of HBURST of the previous transfer

signal PrevBurstWait    : T_burst;
-- stores the value of HBURST of the previous transfer in wait state

signal PrevProt         : T_prot;
-- stores the value of HPROT of the previous transfer

signal PrevProtWait     : T_prot;
-- stores the value of HPROT of the previous transfer in wait state

signal PrevWrtData      : T_data;
-- stores the value of HWDATA of the previous transfer

signal PrevResp         : T_resp;
-- stores the value of HRESP at previous HCLK posedge

signal PrevReadyWait    : std_logic;
-- stores the value of HREADY at previous HCLK posedge in wait state

signal ResetStrd        : boolean := FALSE;
-- indicates that reset has been asserted for at least one clock cycle

signal iResetOver       : boolean;
-- internal copy of ResetOver

signal RetSpltChk       : boolean := false;
-- flag indicating that the previous response was a retry/split or not

signal NSEQOver         : boolean := false;
-- flag indicating that after getting grant, one NSEQ transfer is over

signal TrfRetSp         : std_logic;
-- indicates if previous transfer has been RETRIED/SPLITTED

signal ClockedResetOver : boolean;
-- Clocked version of the combinational ResetOver signal

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Assigning the local copy to output
-- ---------------------------------------------------------------------
ResetOver        <= iResetOver;
ReqGnt           <= HBUSREQx & HGRANTx;
LokGnt           <= HLOCKx & HGRANTx;
GntRdy           <= HGRANTx & HREADY;

-- ---------------------------------------------------------------------
-- No checking should start unless atleast one reset has been
-- encountered. The following block sets a flag on initial
-- assertion/deassertion of reset. All the checks are performed only if
-- this flag is set.
-- ---------------------------------------------------------------------
p_ResetStore : process (HCLK, HRESETn, ResetStrd)
begin
  if ((ResetStrd) and (HRESETn = '1')) then
    iResetOver <= TRUE;
  end if;
  if (HCLK'event and HCLK = '1') then
    if (HRESETn = '0') then
      ResetStrd <= TRUE;
    end if;
  end if;
end process p_ResetStore;

-- ---------------------------------------------------------------------
-- The following block is the MAIN protocol checker block.
-- ---------------------------------------------------------------------
p_ProtChkA : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr         : string (1 to 255);
-- used to flash the error message during simulation

variable PendBurst        : boolean := false;
-- indicates whether the master is degranted during a burst or not

variable OneIdle          : boolean := false;
-- indicates if there is one idle cycle before the reference cycle

variable CurrentTrans     : integer := 1;
-- indicates the transfer-number in the present burst

variable BurstLength      : integer := 1;
-- indicates the total no. of transfers in the burst

variable Size             : integer;
-- no. of bytes indicated by the current HSIZE

begin
  if (HCLK'event and HCLK = '1') then
    -- The clocked version of ResetOver signal is being generated
    ClockedResetOver <= iResetOver;

    if (iResetOver) then
    -- moving the state machines
      CurrentStReq  <= NextStReq;
      CurrentStLok  <= NextStLok;
      CurrentStGnt  <= NextStGnt;
      PrevReadyWait <= HREADY;

-- ---------------------------------------------------------------------
-- All the signals are checked at positive edges of the clock for
-- unknowns. However the check should not start at the first clock after
-- reset de-assertion. The rest of BusWatch operation should start from
-- the very first clock after reset.
-- ---------------------------------------------------------------------
      if (ClockedResetOver) then
        CheckForX("HADDR", HADDR);
        CheckForX("HTRANS", HTRANS);
        CheckForX("HWRITE", HWRITE);
        CheckForX("HSIZE", HSIZE);
        CheckForX("HBURST", HBURST);
        CheckForX("HPROT", HPROT);
        CheckForX("HLOCKx", HLOCKx);
        CheckForX("HWDATA", HWDATA);
      end if;

-- ---------------------------------------------------------------------
-- This block checks, when master is not granted, HTRANS should only be
-- either IDLE or NSEQ
-- ---------------------------------------------------------------------
      if (CurrentStGnt = ST_DEGRANTED) then
        fprint(PrintStr, "BWERRHTNI : Master is not driving HTRANS to " &
               "NSEQ/IDLE when degranted.TIME :%s" , to_string(now));
        assert ((HTRANS = "00") or (HTRANS = "10"))
        report PrintStr
        severity error;
      end if;

-- ---------------------------------------------------------------------
-- During wait states also, the following signals need to be latched as
-- the checks on the basis of these are done during a wait state only.
-- ---------------------------------------------------------------------
      if (HREADY = '0') then
        PrevTransWait <= HTRANS;
        PrevAddrWait  <= HADDR;
        PrevBurstWait <= HBURST;
        PrevSizeWait  <= HSIZE;
        PrevWriteWait <= HWRITE;
        PrevProtWait  <= HPROT;
      end if;
-- ---------------------------------------------------------------------
-- Normal burst going on without any split or degrant in between.
-- ---------------------------------------------------------------------
      if (not(PendBurst) and (CurrentStGnt = ST_GRANTED)
          and (HREADY = '1')) then
        -- starting of a new burst
        if ((HTRANS = "10" or HTRANS = "00") and (HREADY = '1')) then
          if (HTRANS = "00") then
            OneIdle := true;
          elsif (HTRANS = "10") then
            -- previous burst has terminated completely
            if (CurrentTrans = BurstLength) then
              CurrentTrans := 1;
              BurstLength  := NoOfBeatsIn(HBURST);
              PendBurst    := false;
              Size         := NoOfBytesIn(HSIZE);
              -- At start of every burst, check for HBURST and HSIZE
              -- combination If it exceeds 1KB BOUNDARY, scream at once.
              if (to_integer('0' & HADDR(9 downto 0)) +
                  (BurstLength * Size) > 1024) then
                fprint(PrintStr, "BWERRHAB : Burst will cross 1KB BOUNDARY." &
                       "HADDR : %s  TIME : %s",
                       To_HexString(HADDR), to_string(now));
                -- a single-burst can never cross address boundary.In
                -- case of INCR burst, address-boundary violation can't
                -- be checked at beginning. Wrap bursts are incapable
                -- of crossing address boundaries.
                assert ((HBURST = "000") or (HBURST = "001") or
                        (HBURST = "010") or (HBURST = "100") or
                        (HBURST = "110"))
                report PrintStr
                severity error;
              end if;

            -- previous burst has been terminated early
            elsif (CurrentTrans < BurstLength) then
              if (PrevResp /= "01") then
                fprint(PrintStr, "BWWAREBT : Master may have cancelled the" &
                       " burst before finishing all the transfers." &
                       " HADDR : %s. TIME : %s", To_HexString(HADDR),
                       to_string(now));
                assert false
                report PrintStr
                severity warning;
              end if;
              if (TrfRetSp = '1') then
                fprint(PrintStr, "BWERRHA : HADDR not incremented properly" &
                       " according to HSIZE at HADDR : %s TIME : %s",
                       To_HexString(HADDR), to_string(now));
                assert (HADDR = PrevAddr)
                report PrintStr
                severity error;
              end if;
              CurrentTrans := 1;
              BurstLength  := NoOfBeatsIn(HBURST);
              PendBurst    := false;
              Size         := NoOfBytesIn(HSIZE);
              -- At start of every burst, check for HBURST & HSIZE
              -- combination If it exceeds 1KB BOUNDARY, scream at once.
              if (to_integer('0' & HADDR(9 downto 0)) +
                  (BurstLength * Size) > 1024) then
                fprint(PrintStr, "BWERRHAB : Burst will cross 1KB BOUNDARY." &
                       "HADDR : %s  TIME : %s",
                       To_HexString(HADDR), to_string(now));
                -- a single-burst can never cross address boundary.In
                -- case of INCR burst, address-boundary violation can't
                -- be checked at beginning. Wrap bursts are incapable of
                -- crossing address boundaries.
                assert ((HBURST = "000") or (HBURST = "001") or
                        (HBURST = "010") or (HBURST = "100") or
                        (HBURST = "110"))
                report PrintStr
                severity error;
              end if;
            end if;
          end if;
          -- if RETRY or SPLIT responses are given, master has to come
          -- up with same address and control signals
          if ((HRESP /= "10") and (HRESP /= "11")) then
            if (HTRANS /= "00") then
                PrevAddr  <= HADDR;
                PrevWrite <= HWRITE;
                PrevSize  <= HSIZE;
                PrevBurst <= HBURST;
                PrevProt  <= HPROT;
                TrfRetSp  <= '0';
            end if;
          elsif ((HRESP = "10") or (HRESP = "11")) then
            TrfRetSp <= '1';
          end if;
          PrevTrans   <= HTRANS;
          PrevWrtData <= HWDATA;
          PrevResp    <= HRESP;

        -- previous burst continues with end of current transfer
        elsif (((HTRANS = "01") or (HTRANS = "11")) and
               (CurrentStGnt = ST_GRANTED) and (HREADY = '1')) then
          -- Check that control signals apart from HTRANS are unchanged
          Compare(HaltOnMismatch, Verbosity, "HWRITE", HWRITE,
                  PrevWrite, HADDR, "Bus Watch", "BWERRHW", "");
          Compare(HaltOnMismatch, Verbosity, "HPROT", HPROT, PrevProt,
                  HADDR, "Bus Watch", "BWERRHP", "");
          Compare(HaltOnMismatch, Verbosity, "HSIZE", HSIZE, PrevSize,
                  HADDR, "Bus Watch", "BWERRHS", "");
          Compare(HaltOnMismatch, Verbosity, "HBURST", HBURST,
                  PrevBurst, HADDR, "Bus Watch", "BWERRHB", "");

-- ---------------------------------------------------------------------
-- This portion checks that a busy transfer can only follow an NSEQ,
-- SEQ or another BUSY transfer. Also, if the present transfer is SEQ,
-- then the previous transfer should not be an IDLE one.
-- ---------------------------------------------------------------------
          if (HTRANS = "01") then
            fprint(PrintStr, "BWERRHTB : Current BUSY transfer is not " &
                   "preceded by BUSY, NSEQ or SEQ transfer. HADDR : %s," &
                   " TIME : %s", To_HexString(HADDR), to_string(now));
            assert ((PrevTrans = "01") or (PrevTrans = "10") or
                    (PrevTrans = "11"))
            report PrintStr
            severity error;
          elsif (HTRANS = "11") then
            fprint(PrintStr, "BWERRHTS : Current SEQ transfer is not " &
                   "preceded by BUSY, NSEQ or SEQ transfer. HADDR : %s," &
                   " TIME : %s",
                   To_HexString(HADDR), to_string(now));
            assert((PrevTrans = "01") or (PrevTrans = "10") or
                   (PrevTrans = "11"))
            report PrintStr
            severity error;
          end if;

          -- checking if the present HADDR value is proper in accordance
          -- to previous HADDR and HBURST & HSIZE values
          if (TrfRetSp = '1') then
            fprint(PrintStr, "BWERRHA : HADDR not incremented properly" &
                   " according to HSIZE at HADDR : %s TIME : %s",
                   To_HexString(HADDR), to_string(now));
            assert (HADDR = PrevAddr)
            report PrintStr
            severity error;
          elsif (TrfRetSp = '0') then
            CheckAddress(HBURST, HSIZE, HADDR, PrevAddr);
          end if;

          -- If HTRANS indicates a busy transfer, the address should
          -- remain unchanged in the next transfer.
          if (HTRANS /= "01") then
            CurrentTrans := CurrentTrans + 1;
            -- if an INCR burst, no value is given to BurstLength. But
            -- to ensure that it tracks the CurrentTrans (for benefit of
            -- latter checks) the following conditional assignment is
            -- made.
            if (HBURST = "001") then
              BurstLength := CurrentTrans;
            end if;
            -- if RETRY or SPLIT responses are given, master has to come
            -- up with same address and control signals
            if ((HRESP /= "10") and (HRESP /= "11")) then
              PrevAddr  <= HADDR;
              PrevWrite <= HWRITE;
              PrevSize  <= HSIZE;
              PrevBurst <= HBURST;
              PrevProt  <= HPROT;
              TrfRetSp  <= '0';
            elsif ((HRESP = "10") or (HRESP = "11")) then
              TrfRetSp <= '1';
            end if;
          end if;
          PrevTrans   <= HTRANS;
          PrevWrtData <= HWDATA;
          PrevResp    <= HRESP;
        end if;

        -- checking for crossing of 1KB BOUNDARY in case of incr burst.
        -- HTRANS is checked to be SEQ, because if an address is > 1KB
        -- but HTRANS = NSEQ, then protocolwise it is correct.
        if ((HBURST = "001") and (HADDR(10 downto 0) > "1111111111") and
            (PrevAddr(10 downto 0) <= "1111111111") and
            (HTRANS = "11")) then
          fprint(PrintStr, "BWERRHAB : 1KB BOUNDARY crossed. HADDR : %s" &
                 "TIME : %s", To_HexString(HADDR), to_string(now));
          assert false
          report PrintStr
          severity error;
        end if;

-- ---------------------------------------------------------------------
-- The master had been degranted in middle of burst, but is now being
-- regranted.
-- ---------------------------------------------------------------------
      elsif (PendBurst and (CurrentStGnt = ST_GRANTED) and
             (HREADY = '1')) then
        -- if HTRANS is NSEQ
        if (HTRANS = "10") then
          -- checking if the present HADDR value is proper in accordance
          -- to previous HADDR and HBURST & HSIZE values
          if (TrfRetSp = '1') then
            fprint(PrintStr, "BWERRHA : HADDR not incremented properly" &
                   " according to HSIZE at HADDR : %s TIME : %s",
                   To_HexString(HADDR), to_string(now));
            assert (HADDR = PrevAddr)
            report PrintStr
            severity error;
          elsif (TrfRetSp = '0') then
            CheckAddress(HBURST, HSIZE, HADDR, PrevAddr);
          end if;
          -- Check HSIZE, HWRITE, HPROT are the same.
          Compare(HaltOnMismatch, Verbosity, "HWRITE", HWRITE,
                  PrevWrite, HADDR, "Bus Watch", "BWERRHW", "");
          Compare(HaltOnMismatch, Verbosity, "HPROT", HPROT, PrevProt,
                  HADDR, "Bus Watch", "BWERRHP", "");
          Compare(HaltOnMismatch, Verbosity, "HSIZE", HSIZE, PrevSize,
                  HADDR, "Bus Watch", "BWERRHS", "");
          PendBurst    := false;
          CurrentTrans := CurrentTrans + 1;
          -- if an INCR burst, no value is given to BurstLength. But to
          -- ensure that it tracks the CurrentTrans (for the benefit of
          -- latter checks) the following conditional assignment is
          -- made.
          if (HBURST = "001") then
            BurstLength := CurrentTrans;
          end if;
          -- if RETRY or SPLIT responses are given, master has to come
          -- up with same address
          if ((HRESP /= "10") and (HRESP /= "11")) then
            PrevAddr  <= HADDR;
            PrevWrite <= HWRITE;
            PrevSize  <= HSIZE;
            PrevBurst <= HBURST;
            PrevProt  <= HPROT;
            TrfRetSp  <= '0';
          elsif ((HRESP = "10") or (HRESP = "11")) then
            TrfRetSp <= '1';
          end if;
          PrevTrans   <= HTRANS;
          PrevWrtData <= HWDATA;
          PrevResp    <= HRESP;
        end if;

-- ---------------------------------------------------------------------
-- Master has been degranted in middle of a burst, and thus it is
-- checked that it is keeping its HBUSREQx high or not.
-- ---------------------------------------------------------------------
      elsif ((PendBurst) and (CurrentStGnt = ST_DEGRANTED)) then
        fprint(PrintStr, "BWERRHRQ : Master is degranted during a burst, but " &
               "it is not reasserting HBUSREQx. TIME : %s", to_string(now));
        assert (HBUSREQx = '1')
        report PrintStr
        severity error;
        if (((HRESP = "10") or (HRESP = "11")) and (HREADY = '1')) then
          TrfRetSp <= '1';
        end if;


-- ---------------------------------------------------------------------
-- If HGRANTx is removed in middle of a continuing burst, then the
-- master should keep its HBUSREQx high.
-- ---------------------------------------------------------------------
      elsif (not(PendBurst) and (CurrentStGnt = ST_DEGRANTED)) then
        if (CurrentTrans < BurstLength) then
          -- An INCR burst can never terminate early. Every termination
          -- of INCR burst is a proper one. This portion checks that the
          -- master is keeping HBUSREQx high, even after being
          -- degranted.
          if ((HBURST /= "001") and (HRESP /= "01")) then
            fprint(PrintStr, "BWERRHRQ : Master is degranted during a burst, " &
                   "but it is not reasserting HBUSREQx. TIME : %s",
                   to_string(now));
            assert (HBUSREQx = '1')
            report PrintStr
            severity error;
            PendBurst := true;

            fprint(PrintStr, "Master is being degranted in middle of" &
                   " a burst. TIME : %s", to_string(now));
            assert false
            report PrintStr
            severity note;
          end if;
          if (((HRESP = "10") or (HRESP = "11")) and
               (HREADY = '1')) then
            TrfRetSp <= '1';
          end if;
        end if;
      end if;

-- ---------------------------------------------------------------------
-- When HREADY is held low, address and control signal should not
-- change. But when HREADY is pulled low for the first time, the control
-- signals will change and hence PrevReadyWait is checked.
-- ---------------------------------------------------------------------
      if (not(PendBurst) and (CurrentStGnt = ST_GRANTED)
          and (PrevReadyWait = '0')) then
        if (HTRANS /= "00") then
          Compare(HaltOnMismatch, Verbosity, "HADDR", HADDR,
                  PrevAddrWait, HADDR, "Bus Watch", "BWERRHA", "");
        end if;
        if (PrevTransWait = "00") then
          fprint(PrintStr, "BWERRHTIN : During a waited transfer at HADDR " &
                 ": %s, IDLE transfer is changed to a transfer other than " &
                 "NSEQ. TIME : %s", To_HexString(HADDR), to_string(now));
          assert((HTRANS = "10") or (HTRANS = "00"))
          report PrintStr
          severity error;
        elsif (PrevTransWait = "01") then
          fprint(PrintStr, "BWERRHTBS : During a waited transfer at HADDR " &
                 ": %s, BUSY transfer is changed to a transfer other than" &
                 " SEQ. TIME : %s", To_HexString(HADDR), to_string(now));
          assert((HTRANS = "01") or (HTRANS = "11"))
          report PrintStr
          severity error;
        -- Master can cancel an NSEQ or SEQ transfer, only if it gets a
        -- SPLIT/RETRY/ERROR response.
        elsif (HRESP = "00") then
          Compare(HaltOnMismatch, Verbosity, "HTRANS", HTRANS,
                  PrevTransWait, HADDR, "Bus Watch", "BWERRHT", "");
        end if;
        -- Check that control signals apart from HTRANS are unchanged
        if (HTRANS /= "00") then
          Compare(HaltOnMismatch, Verbosity, "HWRITE", HWRITE,
                  PrevWriteWait, HADDR, "Bus Watch", "BWERRHW", "");
          Compare(HaltOnMismatch, Verbosity, "HPROT", HPROT,
                  PrevProtWait, HADDR, "Bus Watch", "BWERRHP", "");
          Compare(HaltOnMismatch, Verbosity, "HSIZE", HSIZE,
                  PrevSizeWait, HADDR, "Bus Watch", "BWERRHS", "");
          Compare(HaltOnMismatch, Verbosity, "HBURST", HBURST,
                  PrevBurstWait, HADDR, "Bus Watch", "BWERRHB", "");
        end if;
      end if;

-- ---------------------------------------------------------------------
-- HADDR Alignment-protocol-check
-- ---------------------------------------------------------------------
      if (Verbosity = TRUE) then
        case HSIZE is
          when "001" =>
            if (HADDR(0) /= '0') then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when "010" =>
            if (HADDR(1 downto 0) /= "00") then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when "011" =>
            if (HADDR(2 downto 0) /= "000") then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when "100" =>
            if (HADDR(3 downto 0) /= "0000") then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when "101" =>
            if (HADDR(4 downto 0) /= "00000") then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when "110" =>
            if (HADDR(5 downto 0) /= "000000") then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when "111" =>
            if (HADDR(6 downto 0) /= "0000000") then
              FlashAlignErr(HADDR, HSIZE);
            end if;
          when others =>
            null;
        end case;
      end if;

-- ---------------------------------------------------------------------
-- When SPLIT/RETRY response is issued, the master should drive the next
-- cycle as idle cycle.
-- ---------------------------------------------------------------------
      if ((HREADY = '0') and ((HRESP = "10") or (HRESP = "11"))) then
        RetSpltChk <= true;
      else
        RetSpltChk <= false;
      end if;

      if (RetSpltChk) then
        fprint(PrintStr, "BWERRHTI : Master has not driven IDLE after " &
               "receiving SPLIT/RETRY response. HADDR : %s. TIME : %s",
               To_HexString(HADDR), to_string(now));
        assert (HTRANS = "00")
        report PrintStr
        severity error;
        RetSpltChk <= false;
      end if;

-- ---------------------------------------------------------------------
-- If HSIZE indicates a data transfer wider than the width of bus, then
-- the following portion flashes error.
-- ---------------------------------------------------------------------
      case DATABUSWIDTH is
        when 32 =>
          if (HSIZE > "010") then
            fprint(PrintStr, "BWERRHSDW : The size of attempted transfer is " &
                   "greater than databuswidth. HADDR : %s. TIME : %s",
                   To_HexString(HADDR), to_string(now));
            assert false
            report PrintStr
            severity error;
          end if;
        when 64 =>
          if (HSIZE > "011") then
            fprint(PrintStr, "BWERRHSDW : The size of attempted transfer is" &
                   " greater than databuswidth. HADDR : %s. TIME : %s",
                   To_HexString(HADDR), to_string(now));
            assert false
            report PrintStr
            severity error;
          end if;
        when others =>
          null;
      end case;

-- ---------------------------------------------------------------------
-- If ERROR response is provided, then Master can cancel an incomplete
-- burst. It should not "scream" (unlike split or retry response). Thus
-- this portion is included.
-- ---------------------------------------------------------------------
      if ((HREADY = '1') and (HRESP = "01")) then
        fprint(PrintStr, "A burst is left incomplete due to cancellation by " &
               "an ERROR response. HADDR : %s. TIME : %s",
               To_HexString(HADDR), to_string(now));
-- Commented out to eliminate excessive warning messages in the 
-- simulation log file. 
-- Note that this commenting out is specific to the VIC PL190.
--        assert false
--        report PrintStr
--        severity note;
        CurrentTrans := 1;
        BurstLength  := 1;
      end if;
    end if;
  end if;
end process p_ProtChkA;

-- ---------------------------------------------------------------------
-- This block checks that once a master asserts HBUSREQx, it should be
-- kept asserted untill it gets the grant.
-- ---------------------------------------------------------------------
p_ProtChkB : process (CurrentStReq, ReqGnt, iResetOver)
variable PrintStr  : string(1 to 255);
-- used to flash the error message during simulation
begin
  if (iResetOver) then
    if (CurrentStReq = ST_CHECK) then
      -- when HBUSREQx is still high and bus is yet not granted
      if (ReqGnt = "10") then
        NextStReq <= ST_CHECK;
      -- HBUSREQx goes low before getting the grant
      elsif (ReqGnt(1) = '0') then
        fprint (PrintStr, "Time : %s BWERRHRQG : HBUSREQx deasserted before " &
                "the Master gets the grant", to_string(now));
        assert false
        report PrintStr
        severity error;
        NextStReq <= ST_NOTCHECK;
      -- HBUSREQx is high and it has got the grant, so no violation
      elsif (ReqGnt = "11") then
        NextStReq <= ST_NOTCHECK;
      end if;
    elsif (CurrentStReq = ST_NOTCHECK) then
      -- when it has yet not asserted HBUSREQx or it requested and got
      -- the grant at the same clock edge
      if (ReqGnt(1) = '0') or (ReqGnt = "11") then
        NextStReq <= ST_NOTCHECK;
      elsif (ReqGnt = "10") then
        NextStReq <= ST_CHECK;
      end if;
    end if;
  end if;
end process p_ProtChkB;

-- ---------------------------------------------------------------------
-- This block checks that once a master asserts HLOCKx, it should be
-- kept asserted until it gets the grant.
-- ---------------------------------------------------------------------
p_ProtChkC : process (CurrentStLok, LokGnt, iResetOver)
variable PrintStr  : string(1 to 255);
-- used to flash the error message during simulation
begin
  if (iResetOver) then
    if (CurrentStLok = ST_CHECK) then
      -- when HLOCKx is still high and bus is yet not granted
      if (LokGnt = "10") then
        NextStLok <= ST_CHECK;
      -- HLOCKx goes low before getting the grant
      elsif (LokGnt(1) = '0') then
        fprint (PrintStr, "Time : %s BWERRHLG : HLOCKx deasserted before " &
                "the Master gets the grant", to_string(now));
        assert false
        report PrintStr
        severity error;
        NextStLok <= ST_NOTCHECK;
      -- HLOCKx is high and it has got the grant, so no violation
      elsif (LokGnt = "11") then
        NextStLok <= ST_NOTCHECK;
      end if;
    elsif (CurrentStLok = ST_NOTCHECK) then
      -- when it has yet not asserted HLOCKx or it requested and got the
      -- grant at the same clock edge
      if (LokGnt(1) = '0') or (LokGnt = "11") then
        NextStLok <= ST_NOTCHECK;
      elsif (ReqGnt = "10") then
        NextStLok <= ST_CHECK;
      end if;
    end if;
  end if;
end process p_ProtChkC;

-- ---------------------------------------------------------------------
-- The following block checks that on being granted, the first transfer
-- indicated on HTRANS line is NSEQ or IDLE(it'll be IDLE only in case
-- of tristate system implementation).
-- ---------------------------------------------------------------------
p_ProtchkD : process (HCLK)
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable PrintStr : string (1 to 255);
-- used to flash the error message during simulation

begin
  if (HCLK'event and (HCLK = '1')) then
    if (CurrentStGnt = ST_GRANTED) then
      if (HTRANS = "10") then
        NSEQOver <= TRUE;
      elsif ((HTRANS = "01") or (HTRANS = "11")) and not(NSEQOver) then
        fprint(PrintStr, "BWERRHTG : after getting the grant, master has not " &
               "performed NSEQ. HADDR : %s. TIME : %s",
               To_HexString(HADDR), to_string(now));
        assert false
        report PrintStr
        severity error;
      end if;
    elsif (CurrentStGnt = ST_DEGRANTED) then
      NSEQOver <= FALSE;
    end if;
  end if;
end process p_ProtchkD;

-- ---------------------------------------------------------------------
-- The following block does the hold checks on the
-- master-output-signals.
-- ---------------------------------------------------------------------
p_hldchk : process (HCLK, HADDR, HTRANS, HWRITE, HSIZE, HPROT, HBURST,
                    HWDATA, HBUSREQx, HLOCKx, iResetOver)
begin
  if (iResetOver) then
    if HADDR'event then
      if ((HCLK = '1') and (HCLK'last_event < Toha)) then
        FlashHoldErr("HADDR", HADDR, "Toha");
      end if;
    end if;

    if HTRANS'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohtr)) then
        FlashHoldErr("HTRANS", HADDR, "tohtr");
      end if;
    end if;

    if HWRITE'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohctl)) then
        FlashHoldErr("HWRITE", HADDR, "tohctl");
      end if;
    end if;

    if HSIZE'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohctl)) then
        FlashHoldErr("HSIZE", HADDR, "tohctl");
      end if;
    end if;

    if HPROT'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohctl)) then
        FlashHoldErr("HPROT", HADDR, "tohctl");
      end if;
    end if;

    if HBURST'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohctl)) then
        FlashHoldErr("HBURST", HADDR, "tohctl");
      end if;
    end if;

    if HWDATA'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohwd)) then
        FlashHoldErr("HWDATA", HADDR, "tohwd");
      end if;
    end if;

    if HBUSREQx'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohreq)) then
        FlashHoldErr("HBUSREQx", HADDR, "tohreq");
      end if;
    end if;

    if HLOCKx'event then
      if ((HCLK = '1') and (HCLK'last_event < Tohlck)) then
        FlashHoldErr("HLOCKx", HADDR, "tohlck");
      end if;
    end if;
  end if;
end process p_hldchk;

-- ---------------------------------------------------------------------
-- The following block does the valid checks on the
-- master-output-signals.
-- ---------------------------------------------------------------------
p_vldchk : process (HCLK)
begin
  if (HCLK'event and (HCLK = '1') and iResetOver) then
    if (not(HTRANS'stable(Tclk-Tovtr))) then
      FlashValidErr("HTRANS", (now - Tclk), "Tovtr");
    end if;

    if (not(HADDR'stable(Tclk-Tova))) then
      FlashValidErr("HADDR", (now - Tclk), "Tova");
    end if;

    if (not(HWRITE'stable(Tclk-Tovctl))) then
      FlashValidErr("HWRITE", (now - Tclk), "Tovctl");
    end if;

    if (not(HSIZE'stable(Tclk-Tovctl))) then
      FlashValidErr("HSIZE", (now - Tclk), "Tovctl");
    end if;

    if (not(HBURST'stable(Tclk-Tovctl))) then
      FlashValidErr("HBURST", (now - Tclk), "Tovctl");
    end if;

    if (not(HPROT'stable(Tclk-Tovctl))) then
      FlashValidErr("HPROT", (now - Tclk), "Tovctl");
    end if;

    if (not(HWDATA'stable(Tclk-Tovwd))) then
      FlashValidErr("HWDATA", (now - Tclk), "Tovwd");
    end if;

    if (not(HBUSREQx'stable(Tclk-Tovreq))) then
      FlashValidErr("HBUSREQx", (now - Tclk), "Tovreq");
    end if;

    if (not(HLOCKx'stable(Tclk-Tovlck))) then
      FlashValidErr("HLOCKx", (now - Tclk), "Tovlck");
    end if;

  end if;
end process p_vldchk;

-- ---------------------------------------------------------------------
-- Grant Checking state machine.
-- ---------------------------------------------------------------------
p_GntStMachine : process (CurrentStGnt, GntRdy)
begin
  case CurrentStGnt is
    when ST_DEGRANTED =>
      if (GntRdy = "11") then
        NextStGnt <= ST_GRANTED;
      else
        NextStGnt <= CurrentStGnt;
      end if;
    when ST_GRANTED =>
      if (GntRdy = "01") then
        NextStGnt <= ST_DEGRANTED;
      else
        NextStGnt <= CurrentStGnt;
      end if;
    when others =>
      null;
  end case;
end process p_GntStMachine;

end behavioural;

-- --============================== End ==============================--
