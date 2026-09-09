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
-- File Name              : DmacTrAhbLite.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           DMAC AhbLite Master Interface
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrAhbLite is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB Reset
        MREADY           : in    std_logic; -- Indicates waited transfers
        MERROR           : in    std_logic; -- Indicates Error response
        ChHLOCK          : in    std_logic; -- HLOCK information
        ChWRITE          : in    std_logic; -- HWRITE information
        ReqForAhbBus     : in    std_logic; -- AHB Transfer Request from Arbiter
        ChHPROT          : in    std_logic_vector(3 downto 0);
                                            -- HPROT information
        ChHSIZE          : in    std_logic_vector(2 downto 0);
                                            -- HSIZE information
        ChAddr           : in    std_logic_vector(31 downto 0);
                                            -- HADDR information
        ChAddrIncr       : in    std_logic; -- Incrementing transfer indication
        ChDisable        : in    std_logic; -- Signal to abort the transfer
        ChPriority       : in    std_logic; -- Priority of a channel
        ChBeatCount      : in    std_logic_vector(4 downto 0);
                                            -- Number of transfers requested
-- Outputs
        MLOCK            : out   std_logic; -- Lock transfer Information
        MPROT            : out   std_logic_vector(3 downto 0);
                                            -- Protection Information on AHB
        MBURST           : out   std_logic_vector(2 downto 0);
                                            -- Burst Information
        MTRANS           : out   std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB
        MADDR            : out   std_logic_vector(31 downto 0);
                                            -- AHB Slave Address to be accessed
                                            -- for transfer
        MSIZE            : out   std_logic_vector(2 downto 0);
                                            -- Width of the AHB data transfer
        MWRITE           : out   std_logic; -- Signal to specify the read or
                                            -- write transfer to/from slave
        DataValid        : out   std_logic; -- Signal used for data transfer
        DisAckMas        : out   std_logic; -- Acknowledge for Disable action
        StopArb          : out   std_logic; -- Stop Arbitration
        ErrorMas         : out   std_logic  -- Error on AHB Slave
       );
end DmacTrAhbLite;

-- -----------------------------------------------------------------------------
--
--                                DmacTrAhbLite
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This module implements the AHB Lite Master Interface for the DMAC. This
--   module with Wrapper behaves as a full master. This module has a single
--   state machine which takes care of putting all valid transactions on the
--   bus.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of DmacTrAhbLite is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MasterState      : std_logic_vector(3 downto 0);
-- State Flip flops for Master SM

signal NextMasterState  : std_logic_vector(3 downto 0);
-- D-Input of MasterState flip flops

signal BeatCount        : std_logic_vector(4 downto 0);
-- Beat counter to track the multiple burst

signal NextBeatCount    : std_logic_vector(4 downto 0);
-- D-Input of BeatCount register

signal ReqCount         : std_logic_vector(4 downto 0);
-- Counter to track the requested beat from channel

signal NextReqCount     : std_logic_vector(4 downto 0);
-- D-Input of ReqCount register

signal AhbAddr          : std_logic_vector(31 downto 0);
-- Source/Destination/LLI Address from Channel

signal NextAhbAddr      : std_logic_vector(31 downto 0);
-- D-Input of AhbAddr register

signal iMTRANS          : std_logic_vector(1 downto 0);
-- Internal copy of MTRANS

signal NextMTRANS       : std_logic_vector(1 downto 0);
-- D-Input of iMTRANS register

signal DelMTRANS        : std_logic_vector(1 downto 0);
-- Delayed version of MTRANS

signal iMBURST          : std_logic_vector(2 downto 0);
-- Internal copy of MBURST

signal NextMBURST       : std_logic_vector(2 downto 0);
-- D-Input of iMBURST register

signal iMWRITE          : std_logic;
-- Internal copy of MWRITE register

signal NextMWRITE       : std_logic;
-- D-Input of iMWRITE register

signal iMLOCK           : std_logic;
-- Internal copy of MLOCK register

signal NextMLOCK        : std_logic;
-- D-Input of iMLOCK register

signal iMPROT           : std_logic_vector(3 downto 0);
-- Internal copy of MPROT register

signal NextMPROT        : std_logic_vector(3 downto 0);
-- D-Input of iMPROT register

signal iMSIZE           : std_logic_vector(2 downto 0);
-- Internal copy of MSIZE register

signal NextMSIZE        : std_logic_vector(2 downto 0);
-- D-Input of iMSIZE register

signal PrevPriority     : std_logic;
-- Reg To store the current priority of the transfer for use in HTRANS decision
-- for the next transfer

signal NextPrevPriority : std_logic;
-- D-Input of PrevPriority register

signal StrtBurstInfo    : std_logic_vector(7 downto 0);
-- Signal to Hold Burst and BeatCount information at the beginning of burst

signal MidBurstInfo     : std_logic_vector(7 downto 0);
-- Signal to Hold Burst and BeatCount information at the middle of burst

signal iStopArb         : std_logic;
-- Internal copy of StopArb register

signal NextStopArb      : std_logic;
-- D-Input of iStopArb register

signal WidthFactor      : std_logic_vector(2 downto 0);
-- Width of the burst in terms of Bytes

signal UseBuffVal       : std_logic;
-- Indication to use registered values

signal NextUseBuffVal   : std_logic;
-- D-Input of UseBuffVal register

signal ReqCountR        : std_logic_vector(4 downto 0);
-- Registered Reqcount when StopArb was low but MREADY is not sampled

signal NextReqCountR    : std_logic_vector(4 downto 0);
-- D-Input of NextReqCountR

signal AhbAddrR         : std_logic_vector(31 downto 0);
-- Registered AhbAddr when StopArb was low but MREADY is not sampled

signal NextAhbAddrR     : std_logic_vector(31 downto 0);
-- D-Input of AhbAddrR

signal MSIZER           : std_logic_vector(2 downto 0);
-- Registered MSIZE when StopArb was low but MREADY is not sampled

signal NextMSIZER       : std_logic_vector(2 downto 0);
-- D-Input of MSIZER

signal MPROTR           : std_logic_vector(3 downto 0);
-- Registered MPROT when StopArb was low but MREADY is not sampled

signal NextMPROTR       : std_logic_vector(3 downto 0);
-- D-Input of MPROTR

signal MLOCKR           : std_logic;
-- Registered MLOCK when StopArb was low but MREADY is not sampled

signal NextMLOCKR       : std_logic;
-- D-Input of MLOCKR

signal MWRITER          : std_logic;
-- Registered MWRITE when StopArb was low but MREADY is not sampled

signal NextMWRITER      : std_logic;
-- D-Input of MWRITER

signal ChPriorityR      : std_logic;
-- Registered ChPriority when StopArb was low but MREADY is not sampled

signal NextChPriorityR  : std_logic;
-- D-Input of ChPriorityR

signal ChDisableR       : std_logic;
-- Registered ChDisable when StopArb was low but MREADY is not sampled

signal NextChDisableR   : std_logic;
-- D-Input of ChDisableR

signal ChAddrIncrR      : std_logic;
-- Registered ChAddrIncrR when StopArb was low but MREADY is not sampled

signal NextChAddrIncrR  : std_logic;
-- D-Input of ChAddrIncrR

signal WidthFactorR     : std_logic_vector(2 downto 0);
-- Width of the burst registered when MREADY is not asserted but StopArb is low

signal StrtBurstInfoR   : std_logic_vector(7 downto 0);
-- Signal to Hold Burst and BeatCount information at the beginning of burst
-- when MREADY is not asserted but StopArb is low

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Incr32:
-- The function to increment the AHB address for incrementing burst transfers on
-- the AHB for pipe-lining.
-- The address is incremented by either 1, 2 or 4 depending on the
-- size of the transfer (i.e. MSIZE)
-- The function takes 2 arguments Current Address and the size of the transfer
-- and returns the incremented address.
-- -----------------------------------------------------------------------------
function Incr32 (
           Addr             : in std_logic_vector(31 downto 0);
           HSize            : in std_logic_vector(2 downto 0)
                  )
           return std_logic_vector is
variable Result           : std_logic_vector(31 downto 0);
-- return incremented address from function
begin
  case HSize is
    when BYTE =>
      Result := unsigned(Addr) + 1;

    when HWORD =>
      Result := unsigned(Addr) + 2;

    when WORD =>
      Result := unsigned(Addr) + 4;

    when others =>
      null;
  end case;
  return (Result);
end Incr32;

-- ----------------------------------------------------------------------------
-- The function OneKbChk is used to find out whether the address is in
-- the 1KB Range at the start of data phase and it is used to find out whether
-- the burst is about to cross the 1KB boundhary. Based on this information
-- MBURST value and Beat Counter are loaded appropriately.
--
-- This function is executed at the time of sampling the Bus request. This
-- function basically decides (depending on the actual AHB Bus output address
-- bits (9:0)) what kind of Increment burst can be performed so that the 1KB
-- boundary is not crossed in a burst sequence.
-- ----------------------------------------------------------------------------
function OneKbChk (
           Addr             : in std_logic_vector(9 downto 0);
           WidthFactor      : in std_logic_vector(2 downto 0);
           BeatCount        : in std_logic_vector(4 downto 0);
           AddrInc          : in std_logic
                  )
         return std_logic_vector is
variable HburstVal  : std_logic_vector(2 downto 0);
-- Possible Burst Value
variable Hburst     : std_logic_vector(2 downto 0);
-- Calculated Burst Value
variable BeatVal    : std_logic_vector(4 downto 0);
-- Number of Transfers
variable BeatValPos : std_logic_vector(4 downto 0);
-- Possible Transfers
variable Result     : std_logic_vector(7 downto 0);
-- Result from function
variable Temp       : std_logic_vector(4 downto 0);
-- Temporay variable
begin
  if (AddrInc = '1') then
    case WidthFactor is
      when "001" =>
        if ((Addr(9) and Addr(8) and Addr(7) and Addr(6) and Addr(5) and
             Addr(4)) = '1') then
          if (Addr(3) = '1') then
            if (Addr(2) = '1') then
              if ((Addr(1) or Addr(0)) = '1') then
                HburstVal := UINCR;
                Temp := ("000" & Addr(1 downto 0));
                BeatValPos := 4 - unsigned(Temp);
              else
                HburstVal := INCR4;
                BeatValPos := "00100";
              end if;
            elsif ((Addr(1) or Addr(0)) = '1') then
              HburstVal := INCR4;
              BeatValPos := "00100";
            else
              HburstVal := INCR8;
              BeatValPos := "01000";
            end if;
          elsif ((Addr(2) or Addr(1) or Addr(0)) = '1') then
            HburstVal := INCR8;
            BeatValPos := "01000";
          else
            HburstVal := INCR16;
            BeatValPos := "10000";
          end if;
        else
          HburstVal := INCR16;
          BeatValPos := "10000";
        end if;

      when "010" =>
        if ((Addr(9) and Addr(8) and Addr(7) and Addr(6) and
             Addr(5)) = '1') then
          if (Addr(4) = '1') then
            if (Addr(3) = '1') then
              if ((Addr(2) or Addr(1)) = '1') then
                HburstVal := UINCR;
                Temp := ("000" & Addr(2 downto 1));
                BeatValPos := 4 - unsigned(Temp);
              else
                HburstVal := INCR4;
                BeatValPos := "00100";
              end if;
            elsif ((Addr(2) or Addr(1)) = '1') then
              HburstVal := INCR4;
              BeatValPos := "00100";
            else
              HburstVal := INCR8;
              BeatValPos := "01000";
            end if;
          elsif ((Addr(3) or Addr(2) or Addr(1)) = '1') then
            HburstVal := INCR8;
            BeatValPos := "01000";
          else
            HburstVal := INCR16;
            BeatValPos := "10000";
          end if;
        else
          HburstVal := INCR16;
          BeatValPos := "10000";
        end if;

      when "100" =>
        if ((Addr(9) and Addr(8) and Addr(7) and Addr(6)) = '1') then
          if (Addr(5) = '1') then
            if (Addr(4) = '1') then
              if ((Addr(3) or Addr(2)) = '1') then
                HburstVal := UINCR;
                Temp := ("000" & Addr(3 downto 2));
                BeatValPos := 4 - unsigned(Temp);
              else
                HburstVal := INCR4;
                BeatValPos := "00100";
              end if;
            elsif ((Addr(3) or Addr(2)) = '1') then
              HburstVal := INCR4;
              BeatValPos := "00100";
            else
              HburstVal := INCR8;
              BeatValPos := "01000";
            end if;
          elsif ((Addr(4) or Addr(3) or Addr(2)) = '1') then
            HburstVal := INCR8;
            BeatValPos := "01000";
          else
            HburstVal := INCR16;
            BeatValPos := "10000";
          end if;
        else
          HburstVal := INCR16;
          BeatValPos := "10000";
        end if;

      when others =>
        null;
    end case;

    case HburstVal is
      when UINCR =>
        Hburst := UINCR;
        if (BeatCount > BeatValPos) then
          BeatVal := BeatValPos;
        else
          BeatVal := BeatCount;
        end if;

      when INCR4 =>
        if (BeatCount < "00100") then
          Hburst  := UINCR;
          if (BeatCount > BeatValPos) then
            BeatVal := BeatValPos;
          else
            BeatVal := BeatCount;
          end if;
        else
          Hburst  := INCR4;
          BeatVal := "00100";
        end if;

      when INCR8 =>
        if (BeatCount < "00100") then
          Hburst  := UINCR;
          if (BeatCount > BeatValPos) then
            BeatVal := BeatValPos;
          else
            BeatVal := BeatCount;
          end if;
        elsif (BeatCount < "01000") then
          Hburst  := INCR4;
          BeatVal := "00100";
        else
          Hburst  := INCR8;
          BeatVal := "01000";
        end if;

      when INCR16 =>
        if (BeatCount < "00100") then
          Hburst  := UINCR;
          if (BeatCount > BeatValPos) then
            BeatVal := BeatValPos;
          else
            BeatVal := BeatCount;
          end if;
        elsif (BeatCount < "01000") then
          Hburst  := INCR4;
          BeatVal := "00100";
        elsif (BeatCount < "10000") then
          Hburst  := INCR8;
          BeatVal := "01000";
        else
          Hburst  := INCR16;
          BeatVal := "10000";
        end if;

      when others =>
        null;
    end case;
  else
    Hburst  := UINCR;
    BeatVal := BeatCount;
  end if;

  Result := (BeatVal & Hburst);
  return Result;
end OneKbChk;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Connecting local copies
-- -----------------------------------------------------------------------------
MTRANS     <= iMTRANS;
MBURST     <= iMBURST;
MLOCK      <= iMLOCK;
MPROT      <= iMPROT;
MSIZE      <= iMSIZE;
MWRITE     <= iMWRITE;
StopArb    <= iStopArb;
MADDR      <= AhbAddr;
ErrorMas   <= MERROR;

-- -----------------------------------------------------------------------------
-- Main State Machine
-- This state machine has the following states.
-- ST_AHBM_INIT:
--   In this state if MREADY and ReqForAhbBus are sampled asserted, then the
--   State Machine(SM) will make a transition to the ST_AHBM_ADDRXFR state.
--   Transition to the ST_AHBM_ADDRXFR state happens with MTRANS as NSEQ.
--   While transitioning out of this state all the Channel information are
--   registered.
--
-- ST_AHBM_ADDRXFR:
--   This state is mainly for pipelining the Address so that 1 level of
--   pipeline is maintained. Most of the logic in this state and ST_AHBM_ACTIVE
--   is similar hence while coding both of these states are merged. Whenever
--   the SM enters this state it always enters by putting NSEQ on MTRANS. The
--   SM enters ST_AHBM_ACTIVE immediately next clock when MREADY is sampled
--   asserted. A crossOver of 1KByte range is also checked in this state. The
--   next access is pipelined so that either a new burst is pipelined or the
--   next transfer of same burst is pipelined.
--
-- ST_AHBM_ACTIVE:
--   In this state valid data transfer takes place. After every MREADY received.
--   The Datavalid for that particular Channel is asserted. The SM always comes
--   to the ACTIVE state after ADDRXFR state only.
--               In this state the HTRANS are changed for new burst only if
--               -- AHB 32 bit Address Output bits 9:0 indicate that the Address
--                  is about to cross 1KB boundary.
--               -- Beat Count for current burst becomes = 1 indicating that
--                  current transfer is last being pipelined for the current
--                  ongoing burst, but given that the Number of Words committed
--                  for transfer are greater than 1.
--               -- The MTRANS put for the previous cycle was IDLE, this may
--                  occur because of low priority channel transfer followed by
--                  another low priority transfer.
--
--               When in this state the Number of Words committed for previous
--               Channel Request become equal to 1 and the MTRANS are put for
--               a valid data transfer value (NSEQ or SEQ), indicating that the
--               last of committed Number of Words is being piped onto the AHB
--               bus, the SM again samples the ReqForAhbBus and it may
--               reinitiate the new committed transfer if Channel continues to
--               request for more data at this instant of sampling. If the
--               sampled ReqForAhbBus does not indicate any request for data
--               transfer the SM goes to ST_AHBM_INIT state where it waits for
--               the ReqForAhbBus to go active
--
-- -----------------------------------------------------------------------------
p_LiteSMComb : process (MasterState, BeatCount, ReqCount, AhbAddr, iMTRANS,
                        iMBURST, iMWRITE, iMLOCK, iMPROT, iMSIZE, ChAddrIncr,
                        ChDisable, PrevPriority, MREADY, iStopArb, ReqForAhbBus,
                        StrtBurstInfo, ChBeatCount, ChAddr, ChHSIZE, ChHPROT,
                        ChHLOCK, ChWRITE, ChPriority, MERROR, MidBurstInfo,
                        StrtBurstInfoR, ReqCountR, AhbAddrR, MSIZER, MPROTR,
                        MLOCKR, MWRITER, ChPriorityR, ChDisableR, UseBuffVal)
begin
  NextMasterState  <= MasterState;
  NextBeatCount    <= BeatCount;
  NextReqCount     <= ReqCount;
  NextAhbAddr      <= AhbAddr;
  NextMTRANS       <= iMTRANS;
  NextMSIZE        <= iMSIZE;
  NextMPROT        <= iMPROT;
  NextMLOCK        <= iMLOCK;
  NextMBURST       <= iMBURST;
  NextMWRITE       <= iMWRITE;
  NextPrevPriority <= PrevPriority;
  DisAckMas        <= '0';
  case MasterState is
    when ST_AHBM_INIT =>
      if (ChDisable = '0') then
        if ((MREADY = '1') and (iStopArb = '0') and (ReqForAhbBus = '1')) then
          NextBeatCount    <= StrtBurstInfo(7 downto 3);
          NextReqCount     <= ChBeatCount;
          NextAhbAddr      <= ChAddr;
          NextMSIZE        <= ChHSIZE;
          NextMPROT        <= ChHPROT;
          NextMLOCK        <= ChHLOCK;
          NextMBURST       <= StrtBurstInfo(2 downto 0);
          NextMWRITE       <= ChWRITE;
          NextPrevPriority <= ChPriority;
          NextMasterState <= ST_AHBM_ADDRXFR;
          NextMTRANS      <= NSEQ;
        else
          NextBeatCount    <= (others => '0');
          NextReqCount     <= (others => '0');
          NextAhbAddr      <= (others => '0');
          NextMTRANS       <= (others => '0');
          NextMSIZE        <= (others => '0');
          NextMPROT        <= (others => '0');
          NextMLOCK        <= '0';
          NextMBURST       <= (others => '0');
          NextMWRITE       <= '0';
          DisAckMas        <= '0';
          NextPrevPriority <= '0';
        end if;
      else
        NextBeatCount    <= (others => '0');
        NextReqCount     <= (others => '0');
        NextAhbAddr      <= (others => '0');
        NextMTRANS       <= (others => '0');
        NextMSIZE        <= (others => '0');
        NextMPROT        <= (others => '0');
        NextMLOCK        <= '0';
        NextMBURST       <= (others => '0');
        NextMWRITE       <= '0';
        DisAckMas        <= '1';
        NextPrevPriority <= '0';
      end if;

    when ST_AHBM_ADDRXFR | ST_AHBM_ACTIVE =>
      if ((Masterstate = ST_AHBM_ACTIVE) and (MERROR = '1')) then
        NextMasterState  <= ST_AHBM_INIT;
        NextBeatCount    <= (others => '0');
        NextReqCount     <= (others => '0');
        NextAhbAddr      <= (others => '0');
        NextMTRANS       <= IDLE;
        NextMSIZE        <= (others => '0');
        NextMPROT        <= (others => '0');
        NextMLOCK        <= '0';
        NextMBURST       <= (others => '0');
        NextMWRITE       <= '0';
        DisAckMas        <= '0';
        NextPrevPriority <= '0';
      elsif (MREADY = '1') then
        if ((ChDisable = '1') and ((iMBURST = UINCR) or
                                                   (BeatCount = "00001"))) then
          if (iMBURST = UINCR) then
            NextMTRANS <= IDLE;
          elsif (ReqForAhbBus = '1') then
            if ((ChPriority = '0') and (PrevPriority = '0')) then
              NextMTRANS <= IDLE;
            else
              NextMTRANS <= NSEQ;
            end if;
          else
            NextMTRANS <= IDLE;
          end if;
        elsif (ReqCount > "00001") then
          if ((iMTRANS = IDLE) or (ChAddrIncr = '0') or
                                                   (BeatCount = "00001")) then
            NextMTRANS <= NSEQ;
          else
            NextMTRANS <= SEQ;
          end if;
-- The Following 2 lines are added for lock transfers and Priority transfers
        elsif ((ReqCount = "00001") and (iMTRANS = IDLE) and
                                                    (ReqForAhbBus = '1')) then
          NextMTRANS <= NSEQ;
        elsif (ReqCount = "00001") then
          if (PrevPriority = '0') then
            NextMTRANS <= IDLE;
          elsif (ReqForAhbBus = '1') then
            NextMTRANS <= NSEQ;
          else
            NextMTRANS <= IDLE;
          end if;
        elsif ((ReqCount = "00000") and (iMTRANS = IDLE) and
                                                     (ReqForAhbBus = '1')) then
          NextMTRANS <= NSEQ;
        else
          NextMTRANS <= IDLE;
        end if;

        if ((ChDisable = '1') and ((iMBURST = UINCR) or
                                                   (BeatCount = "00001"))) then
          if (iMBURST = UINCR) then
            NextBeatCount    <= (others => '0');
            NextReqCount     <= (others => '0');
            NextAhbAddr      <= (others => '0');
            NextMSIZE        <= (others => '0');
            NextMPROT        <= (others => '0');
            NextMLOCK        <= '0';
            NextMBURST       <= (others => '0');
            NextMWRITE       <= '0';
            NextPrevPriority <= '0';
            DisAckMas        <= '1';
          elsif (ReqForAhbBus = '1') then
            if (UseBuffVal = '0') then
              NextBeatCount    <= StrtBurstInfo(7 downto 3);
              NextReqCount     <= ChBeatCount;
              NextAhbAddr      <= ChAddr;
              NextMSIZE        <= ChHSIZE;
              NextMPROT        <= ChHPROT;
              NextMLOCK        <= ChHLOCK;
              NextMBURST       <= StrtBurstInfo(2 downto 0);
              NextMWRITE       <= ChWRITE;
              NextPrevPriority <= ChPriority;
              if (ChDisable = '1') then
                DisAckMas  <= '1';
              else
                DisAckMas  <= '0';
              end if;
            else
              NextBeatCount    <= StrtBurstInfoR(7 downto 3);
              NextReqCount     <= ReqCountR;
              NextAhbAddr      <= AhbAddrR;
              NextMSIZE        <= MSIZER;
              NextMPROT        <= MPROTR;
              NextMLOCK        <= MLOCKR;
              NextMBURST       <= StrtBurstInfoR(2 downto 0);
              NextMWRITE       <= MWRITER;
              NextPrevPriority <= ChPriorityR;
              if (ChDisableR = '1') then
                DisAckMas  <= '1';
              else
                DisAckMas  <= '0';
              end if;
            end if;
          else
            NextBeatCount    <= (others => '0');
            NextReqCount     <= (others => '0');
            NextAhbAddr      <= (others => '0');
            NextMSIZE        <= (others => '0');
            NextMPROT        <= (others => '0');
            NextMLOCK        <= '0';
            NextMBURST       <= (others => '0');
            NextMWRITE       <= '0';
            NextPrevPriority <= '0';
            if (ChDisable = '1') then
              DisAckMas  <= '1';
            else
              DisAckMas  <= '0';
            end if;
          end if;
        elsif (ReqCount > "00001") then
          if ((iMTRANS = SEQ) or (iMTRANS = NSEQ)) then
            if (ChAddrIncr = '1') then
              NextAhbAddr <= Incr32(AhbAddr, iMSIZE);
            end if;
            NextReqCount <= unsigned(ReqCount) - '1';
            if (BeatCount = "00001") then
              NextBeatCount   <= MidBurstInfo(7 downto 3);
              NextMBURST      <= MidBurstInfo(2 downto 0);
            else
              NextBeatCount <= unsigned(BeatCount) - '1';
            end if;
          elsif (iMTRANS = IDLE) then
            NextBeatCount   <= MidBurstInfo(7 downto 3);
            NextMBURST      <= MidBurstInfo(2 downto 0);
          end if;
        elsif (ReqForAhbBus = '1') then
          if ((UseBuffVal = '0') and (iStopArb = '0')) then
            NextBeatCount    <= StrtBurstInfo(7 downto 3);
            NextReqCount     <= ChBeatCount;
            NextAhbAddr      <= ChAddr;
            NextMSIZE        <= ChHSIZE;
            NextMPROT        <= ChHPROT;
            NextMLOCK        <= ChHLOCK;
            NextMBURST       <= StrtBurstInfo(2 downto 0);
            NextMWRITE       <= ChWRITE;
            NextPrevPriority <= ChPriority;
            if (ChDisable = '1') then
              DisAckMas  <= '1';
            else
              DisAckMas  <= '0';
            end if;
          elsif (UseBuffVal = '1') then
            NextBeatCount    <= StrtBurstInfoR(7 downto 3);
            NextReqCount     <= ReqCountR;
            NextAhbAddr      <= AhbAddrR;
            NextMSIZE        <= MSIZER;
            NextMPROT        <= MPROTR;
            NextMLOCK        <= MLOCKR;
            NextMBURST       <= StrtBurstInfoR(2 downto 0);
            NextMWRITE       <= MWRITER;
            NextPrevPriority <= ChPriorityR;
            if (ChDisableR = '1') then
              DisAckMas  <= '1';
            else
              DisAckMas  <= '0';
            end if;
          else
            NextBeatCount    <= (others => '0');
            NextReqCount     <= (others => '0');
            NextAhbAddr      <= (others => '0');
            NextMSIZE        <= (others => '0');
            NextMPROT        <= (others => '0');
            NextMLOCK        <= '0';
            NextMBURST       <= (others => '0');
            NextMWRITE       <= '0';
            NextPrevPriority <= '0';
            if (ChDisable = '1') then
              DisAckMas  <= '1';
            else
              DisAckMas  <= '0';
            end if;
          end if;
        else
          NextBeatCount    <= (others => '0');
          NextReqCount     <= (others => '0');
          NextAhbAddr      <= (others => '0');
          NextMSIZE        <= (others => '0');
          NextMPROT        <= (others => '0');
          NextMLOCK        <= '0';
          NextMBURST       <= (others => '0');
          NextMWRITE       <= '0';
          NextPrevPriority <= '0';
          if (ChDisable = '1') then
            DisAckMas  <= '1';
          else
            DisAckMas  <= '0';
          end if;
        end if;
        case iMTRANS is
          when NSEQ | SEQ =>
            NextMasterState <= ST_AHBM_ACTIVE;
          when IDLE =>
            if (ReqForAhbBus ='1') then
              NextMasterState <= ST_AHBM_ADDRXFR;
            else
              NextMasterState <= ST_AHBM_INIT;
            end if;
          when others =>
            null;
        end case;
      end if;

    when others =>
      null;
  end case;
end process p_LiteSMComb;

-- -----------------------------------------------------------------------------
-- Width Factor generation, which uses channel HSIZE information
-- -----------------------------------------------------------------------------
WidthFactor <= "001" when ChHSIZE = BYTE
            else
               "010" when ChHSIZE = HWORD
            else
               "100";

-- -----------------------------------------------------------------------------
-- Width Factor generation, which uses Buffered HSIZE information
-- -----------------------------------------------------------------------------
WidthFactorR <= "001" when MSIZER = BYTE
            else
               "010" when MSIZER = HWORD
            else
               "100";

-- -----------------------------------------------------------------------------
-- Output of OneKbChk function is assigned here, which will be used at the
-- starting of the access.
-- -----------------------------------------------------------------------------
StrtBurstInfo <= OneKbChk(ChAddr(9 downto 0), WidthFactor, ChBeatCount,
                                                        ChAddrIncr);

-- -----------------------------------------------------------------------------
-- Output of OneKbChk function is assigned here, which will be used at the
-- starting of the access, if Mready was not sampled asserted when StopArb
-- went low.
-- -----------------------------------------------------------------------------
StrtBurstInfoR <= OneKbChk(AhbAddrR(9 downto 0), WidthFactorR,
                           ReqCountR, ChAddrIncrR);

-- -----------------------------------------------------------------------------
-- Output of OneKbChk function is assigned here, which will be used at the
-- middle of the access. when the BeatCount expires but Reqcount has some count.
-- -----------------------------------------------------------------------------
MidBurstInfo  <= OneKbChk(NextAhbAddr(9 downto 0), WidthFactor,
                          NextReqCount, ChAddrIncr);

-- -----------------------------------------------------------------------------
-- Logic to generate DataValid signal. This signal is generated combinationally.
-- -----------------------------------------------------------------------------
p_DataValidComb : process (MasterState, DelMTRANS, MREADY, iMTRANS)
begin
  if ((MasterState = ST_AHBM_ADDRXFR) or (MasterState = ST_AHBM_ACTIVE)) then
    if (DelMTRANS = IDLE) then
      if (iMTRANS = IDLE) then
        DataValid <= MREADY;
      else
        DataValid <= '0';
      end if;
    elsif (MREADY = '0') then
      DataValid <= '0';
    else
      DataValid <= '1';
    end if;
  else
    DataValid <= '0';
  end if;
end process p_DataValidComb;


-- -----------------------------------------------------------------------------
-- Logic to generate StopArb signal. This signal is registered
-- -----------------------------------------------------------------------------
p_StopArbComb : process (MREADY, MERROR, iStopArb, ChBeatCount, ChPriority,
                         MasterState, ChDisable, iMBURST, BeatCount, ReqCount,
                         ReqCountR, PrevPriority, iMTRANS, UseBuffVal,
                         ChPriorityR)
begin
  NextStopArb <= iStopArb;
  if ((MERROR = '1') and (MREADY = '0')) then
    NextStopArb <= '1';
  elsif ((MERROR = '1') and (MREADY = '1')) then
    NextStopArb <= '0';
  elsif (iStopArb = '0') then
    if (ChBeatCount /= "00000") then
      if ((ChPriority = '0') and (MasterState = ST_AHBM_INIT)) then
        NextStopArb <= '1';
      elsif ((ChBeatCount = "00001") and (MREADY = '1')) then
        NextStopArb <= '0';
      else
        NextStopArb <= '1';
      end if;
    else
      NextStopArb <= '0';
    end if;
  else
    if ((ChDisable = '1') and ((iMBURST = UINCR) or
        (BeatCount = "00010")) and (MREADY = '1')) then
      NextStopArb <= '0';
    elsif (((ReqCount = "00001") and (ReqCountR <= "00001")) and
           ((PrevPriority = '0') or ((ChPriorityR = '0') and
            (UseBuffVal = '1'))) and (MREADY = '1') and
                                    ((iMTRANS = SEQ) or (iMTRANS = NSEQ))) then
      NextStopArb <= '0';
    elsif (((ReqCount <= "00010") and (ReqCountR <= "00001")) and
           (MREADY = '1') and ((PrevPriority = '1') or ((ChPriorityR = '1') and
                                                      (UseBuffVal = '1')))) then
      NextStopArb <= '0';
    end if;
  end if;
end process p_StopArbComb;

-- -----------------------------------------------------------------------------
-- Buffer the Channel resources in case of MREADY not asserted but StopArb is
-- low
-- -----------------------------------------------------------------------------
p_BuffChannelComb : process (iStopArb, MREADY, UseBuffVal, ReqCountR, AhbAddrR,
                             MSIZER, MPROTR, MLOCKR, MWRITER, ChPriorityR,
                             ChDisableR, ChAddrIncr, ChAddrIncrR, ChBeatCount,
                             ChAddr, ChHSIZE, ChHPROT,
                             ChHLOCK, ChWRITE, ChPriority, ChDisable)
variable Concat : std_logic_vector(1 downto 0);
begin
  Concat := (iStopArb & MREADY);

  NextUseBuffVal  <= UseBuffVal;
  NextReqCountR   <= ReqCountR;
  NextAhbAddrR    <= AhbAddrR;
  NextMSIZER      <= MSIZER;
  NextMPROTR      <= MPROTR;
  NextMLOCKR      <= MLOCKR;
  NextMWRITER     <= MWRITER;
  NextChPriorityR <= ChPriorityR;
  NextChDisableR  <= ChDisableR;
  NextChAddrIncrR <= ChAddrIncrR;
  case Concat is
    when "00" =>
      if (ChBeatCount /= "00000") then
        NextUseBuffVal  <= '1';
        NextReqCountR   <= ChBeatCount;
        NextAhbAddrR    <= ChAddr;
        NextMSIZER      <= ChHSIZE;
        NextMPROTR      <= ChHPROT;
        NextMLOCKR      <= ChHLOCK;
        NextMWRITER     <= ChWRITE;
        NextChPriorityR <= ChPriority;
        NextChDisableR  <= ChDisable;
        NextChAddrIncrR <= ChAddrIncr;
      end if;
    when "01" | "11" =>
      NextUseBuffVal  <= '0';
      NextReqCountR   <= (others => '0');
      NextAhbAddrR    <= (others => '0');
      NextMSIZER      <= (others => '0');
      NextMPROTR      <= (others => '0');
      NextMLOCKR      <= '0';
      NextMWRITER     <= '0';
      NextChPriorityR <= '0';
      NextChDisableR  <= '0';
      NextChAddrIncrR <= '0';
    when others =>
      null;
  end case;
end process p_BuffChannelComb;

-- -----------------------------------------------------------------------------
-- All D-Input logic are registered here
-- -----------------------------------------------------------------------------
p_LiteSMSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    BeatCount    <= (others => '0');
    ReqCount     <= (others => '0');
    AhbAddr      <= (others => '0');
    iMTRANS      <= (others => '0');
    iMSIZE       <= (others => '0');
    iMPROT       <= (others => '0');
    iMLOCK       <= '0';
    iMBURST      <= (others => '0');
    iMWRITE      <= '0';
    PrevPriority <= '0';
    MasterState  <= ST_AHBM_INIT;
    UseBuffVal   <= '0';
    ReqCountR    <= (others => '0');
    AhbAddrR     <= (others => '0');
    MSIZER       <= (others => '0');
    MPROTR       <= (others => '0');
    MLOCKR       <= '0';
    MWRITER      <= '0';
    ChPriorityR  <= '0';
    ChDisableR   <= '0';
    iStopArb     <= '0';
    ChAddrIncrR  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    BeatCount    <= NextBeatCount;
    ReqCount     <= NextReqCount;
    AhbAddr      <= NextAhbAddr;
    iMTRANS      <= NextMTRANS;
    iMSIZE       <= NextMSIZE;
    iMPROT       <= NextMPROT;
    iMLOCK       <= NextMLOCK;
    iMBURST      <= NextMBURST;
    iMWRITE      <= NextMWRITE;
    PrevPriority <= NextPrevPriority;
    MasterState  <= NextMasterState;
    DelMTRANS    <= iMTRANS;
    UseBuffVal   <= NextUseBuffVal;
    ReqCountR    <= NextReqCountR;
    AhbAddrR     <= NextAhbAddrR;
    MSIZER       <= NextMSIZER;
    MPROTR       <= NextMPROTR;
    MLOCKR       <= NextMLOCKR;
    MWRITER      <= NextMWRITER;
    ChPriorityR  <= NextChPriorityR;
    ChDisableR   <= NextChDisableR;
    iStopArb     <= NextStopArb;
    ChAddrIncrR  <= NextChAddrIncrR;
  end if;
end process p_LiteSMSeq;

end behavioural;

-- --================================== End ==================================--
