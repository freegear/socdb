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
-- File Name              : SmcTimerWaitCont.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is used for the purpose of generating the read access
--           time completion, write access time completion, access timings by
--           using external wait control. The WEN and OEN delay generation
--           logic is also implemented in this module.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SmcPackage.all;

-- -----------------------------------------------------------------------------

entity SmcTimerWaitCont is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB Bus Reset
        WST1             : in    std_logic_vector(4 downto 0);
                                            -- Wait State count for single
                                            -- memory read or start of a
                                            -- burst read cycle
        WST2             : in    std_logic_vector(4 downto 0);
                                            -- Wait State count for memory
                                            -- write or burst read cycle
        IDCY             : in    std_logic_vector(3 downto 0);
                                            -- Turn around count value
        WSTWEN           : in    std_logic_vector(3 downto 0);
                                            -- Chip select to Write enable
                                            -- assertion delay
        WSTOEN           : in    std_logic_vector(3 downto 0);
                                            -- Chip select to Output enable
                                            -- assertion delay
        RdCntLdCo        : in    std_logic; -- Load normal read access delay
        WrCntLdCo        : in    std_logic; -- Load write delay
        TrArCntLdCo      : in    std_logic; -- Load Turn around delay
        ZeroIdleCo       : in    std_logic; -- 1 cycle Turn around delay
        RdBMcntLdCo      : in    std_logic; -- Load Burst read delay
        OEnCntLdCo       : in    std_logic; -- Load Output enable delay
        WEnCntLdCo       : in    std_logic; -- Load Write enable delay
        SmWaitS2         : in    std_logic; -- Double Synchronised
                                            -- External wait
        CnclSmWaitS2     : in    std_logic; -- Double synchronised
                                            -- External wait termination
        BM               : in    std_logic; -- Burst ROM device indication
        WaitEn           : in    std_logic; -- External wait mode enable
        WaitPol          : in    std_logic; -- External wait polarity
        SmcState         : in    std_logic_vector(3 downto 0);
                                            -- The state machine's current 
                                            -- state value

-- Outputs
        CntEnd           : out   std_logic; -- End of access timer count
        DelayEnd         : out   std_logic; -- End of delay timer count
        WaitToutErr      : out   std_logic; -- External Wait timeout error
        OEnCntEZ         : out   std_logic; -- This signal is generated 
                                            -- to determine whether the 
                                            -- OEnCount delay value is
                                            -- equal to zero
        WEnCntEZ         : out   std_logic; -- This signal is generated 
                                            -- to determine whether the 
                                            -- WrEnCount delay value is
                                            -- equal to zero 
        CntEZEnd         : out   std_logic  -- Timer counter expiry signal when
                                            -- count values are zero
       );
end SmcTimerWaitCont;

-- -----------------------------------------------------------------------------
--
--                              SmcTimerWaitCont
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         This block gets the Load enable signals for various delay values from
--         the Main state machine and accordingly loads the corresponding delay
--         values into a counter and checks till it expires. For the access time
--         completion the count end [CntEnd] signal is generated. The delay
--         count expiry is indicated by the signal [DelayEnd]. It also
--         generates error status signals like external wait error and wait
--         time out error.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SmcTimerWaitCont is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- The timer state machine's state value encoding is done in the SmcPackage
-- module

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal DelayCnt         : std_logic_vector(3 downto 0);
-- 4-bit delay Counter for the WEN and OEN

signal NextDelayCnt     : std_logic_vector(3 downto 0);
-- D-input of DelayCnt

signal TimerCnt         : std_logic_vector(4 downto 0);
-- 5-bit Counter in the timer module

signal NextTimerCnt     : std_logic_vector(4 downto 0);
-- D-input of TimerCnt

signal TimerState       : std_logic_vector(1 downto 0);
-- Indicates Timer state machine's current state

signal NextTimerState   : std_logic_vector(1 downto 0);
-- D-input of TimeState

signal DelayState       : std_logic;
-- Indicates current state of the Delay state logic

signal NextDelayState   : std_logic;
-- D-input of DelayState

signal iCntEnd          : std_logic;
-- Local copy of CntEnd

signal NextCntEnd       : std_logic;
-- D-input of iCntEnd

signal iDelayEnd        : std_logic;
-- Local copy of DelayEnd

signal NextDelayEnd     : std_logic;
-- D-input of iDelayEnd

signal iWaitToutErr     : std_logic;
-- Local copy of WaitToutErr

signal iWaitToutErrQ    : std_logic;
-- D-input of WaitToutErr

signal WaitPolPrev      : std_logic;
-- Stored value of the WaitPol for which WaitToutErr occured

signal NextWaitPolPrev  : std_logic;
-- D-input of WaitPolPrev

signal iCntEZEnd        : std_logic;
-- Local copy of CntEZEnd

signal NextCntEZEnd     : std_logic;
-- D-input of iCntEZEnd

signal WST1EZ           : std_logic;
-- This signal is generated to determine whether the WST1 access count value is
-- equal to zero

signal WST2EZ           : std_logic;
-- This signal is generated to determine whether the WST2 access count value is
-- equal to zero

signal IdcyEZ           : std_logic;
-- This signal is generated to determine whether the IDCY count value is
-- equal to zero

signal OEnCount         : std_logic_vector(3 downto 0);
-- Output enable count

signal WrEnCount        : std_logic_vector(3 downto 0);
-- Write enable count

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
-- Generate signals which check if the access count or turnaround count value
-- are equal to zero.
-- -----------------------------------------------------------------------------
WST1EZ           <= '1' when (WST1 = "00000")
                 else
                    '0';

WST2EZ           <= '1' when (WST2 = "00000")
                 else
                    '0';

IdcyEZ           <= '1' when (IDCY = "0000")

                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Generation of Access end signal CntEZEnd, when the count values are zero
-- without waiting for the state machine transitions
-- -----------------------------------------------------------------------------
NextCntEZEnd     <= '1' when ((WST1EZ = '1' and RdCntLdCo = '1') or
                              (WST2EZ = '1' and
                               (WrCntLdCo = '1' or RdBMcntLdCo = '1')) or
                              (IdcyEZ = '1' and TrArCntLdCo = '1') or
                              ZeroIdleCo = '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Combinational logic for the Timing counter State machine
-- -----------------------------------------------------------------------------
p_TimerComb : process (TimerState, RdCntLdCo, WrCntLdCo, TrArCntLdCo,
                       RdBMcntLdCo, TimerCnt, SmWaitS2, SmcState,
                       CnclSmWaitS2, WaitEn, WaitPol, WaitPolPrev,
                       IDCY, WST1, WST2, iWaitToutErrQ, IdcyEZ, WST1EZ,
                       WST2EZ)

begin

  NextTimerState   <= TimerState;
  NextTimerCnt     <= TimerCnt;
  iWaitToutErr     <= iWaitToutErrQ and ((not(WaitPolPrev) and not(SmWaitS2)) 
                                         or (WaitPolPrev and SmWaitS2));
  NextCntEnd       <= '0';

  case TimerState is

-- After reset, the state machine reaches this state and TimerCnt is zero so
-- the count end signal "CntEnd" will be asserted. Once if any of the
-- turnaround, Output enable, write enable delay's load signals are
-- asserted then the corresponding count values are loaded into the counter
-- and the state machine enters into the count state ST_TW_COUNT, with the
-- deassertion of count end. If external wait (SmWaitS2) is deasserted and any
-- of the write access, read access, burst read access count load values
-- are asserted then the state machine moves into count state ST_TW_COUNT and
-- loads the corresponding count value into the counter. It also deasserts
-- the count end, external wait error and wait timeout error signals.
-- While loading the
-- counter wherever the count value has to be added with 1 as in the case of
-- turn around count, a signal wait one clock is set to take care
-- of the additonal one clock delay.
-- Check is performed to see whether the SMWAIT i/p is already asserted
-- irrespective of whether the targeted bank is SMWAIT controlled or not
-- This because the SMWAIT could be de-asserted any time and there is then
-- a chance of bus contention. No need to check for the WaitEn=1 because
-- this is generic for both non-SMWAIT controlled and SMWAIT controlled.
    when ST_TW_IDLE =>
      if (TrArCntLdCo = '1' and IdcyEZ = '0') then
        NextTimerState   <= ST_TW_COUNT;
        NextTimerCnt     <= '0' & IDCY;
      elsif ((iWaitToutErrQ = '1') and
             ((WaitPolPrev = '0' and SmWaitS2 = '0') or
              (WaitPolPrev = '1' and SmWaitS2 = '1'))) then
        NextTimerState   <= ST_TW_IDLE;
      else
        iWaitToutErr  <= '0';
        if (WrCntLdCo = '1' and WST2EZ = '0') then
          NextTimerState  <= ST_TW_COUNT;
          NextTimerCnt    <= WST2;
        elsif (RdBMcntLdCo = '1' and WST2EZ = '0') then
          NextTimerState  <= ST_TW_COUNT;
          NextTimerCnt    <= WST2;
        elsif (RdCntLdCo = '1' and WST1EZ = '0') then
          NextTimerState  <= ST_TW_COUNT;
          NextTimerCnt    <= WST1;
        end if;
      end if;

-- The common counter which is loaded by any of the load enable signals is
-- used for the following purposes :
-- 1. To count down either the read access count or write access count or the
--    turnaround cycle count. At the counter expiry, a common count completion
--    signal 'CntEnd' signal is generated. This signal corresponds to the
--    respective load enable signal.
-- 2. In the external wait control mode, the counter is loaded with the count
--    value which corresponds to the amount of time the SmcCore is expected to
--    wait for the assertion of the SMWAIT input. If the SMWAIT is asserted
--    within this stipulated time, then the state machine moves the EXT_WAIT
--    state and the SmcCore is controlled by the SMWAIT input. On the other hand
--    if the SMWAIT assertion is not detected within the counter expiry, then
--    the transfer is completed successfully with no extra wait cycles.
-- During the Burst Read mode, when the subsequent reads are started in
-- advance speculatively, then it is possible that the burst read is aborted.
-- The access counting activity which is in already in progress will be aborted
-- and depending on the next transfer {as indicated by the count load signals},
-- the counter is reloaded appropriately.
    when ST_TW_COUNT =>
      if (WaitEn = '1' and
          ((WaitPol = '0' and SmWaitS2 = '0') or
           (WaitPol = '1' and SmWaitS2 = '1')) and
           (SmcState /= ST_TSM_TURNARND) and
           (TrArCntLdCo /= '1')) then
        NextTimerState   <= ST_TW_EXTWAIT;
        NextTimerCnt     <= "00000";
      elsif (TrArCntLdCo = '1' and IdcyEZ = '0') then
        NextTimerCnt     <= '0' & IDCY;
      elsif (RdBMcntLdCo = '1' and WST2EZ = '0') then
        NextTimerCnt     <= WST2;
      elsif (RdCntLdCo = '1' and WST1EZ = '0') then
        NextTimerCnt     <= WST1;
      elsif (WrCntLdCo = '1' and WST2EZ = '0') then
        NextTimerCnt     <= WST2;
      elsif (TimerCnt = "00001") then
        if ((WaitEn = '1') and
            ((WaitPol = '0' and SmWaitS2 = '0') or
             (WaitPol = '1' and SmWaitS2 = '1')) and
             (SmcState /= ST_TSM_TURNARND) and
             (TrArCntLdCo /= '1')) then
          NextTimerState   <= ST_TW_EXTWAIT;
          NextTimerCnt     <= "00000";
        else
          NextTimerState   <= ST_TW_IDLE;
          NextCntEnd       <= '1';
          NextTimerCnt     <= "00000";
        end if;
      else
        NextTimerCnt     <= unsigned(TimerCnt) - 1;
      end if;

-- This is the state in which the SmcCore is controlled by the SMWAIT input
-- for the read or write access timings. De-assertion of the SMWAIT, signals
-- the completion of the access time.
-- It is also possible for some reason that the SMWAIT is not de-asserted by
-- external controller which means a potential hang situation. In such scenarios
-- the CANCELSMWAIT input is asserted high, which indicates that a time-out has
-- occured on the de-assertion of the SMWAIT. When a time-out condition is
-- encountered, the transfer is aborted, WaitToutErr flag is set and ERROR
-- response is returned
    when ST_TW_EXTWAIT =>
      if (TrArCntLdCo = '1') then
        NextTimerState   <= ST_TW_COUNT;
        NextTimerCnt     <= '0' & IDCY;
      elsif ((WaitPol = '0' and SmWaitS2 = '1') or
          (WaitPol = '1' and SmWaitS2 = '0')) then
        NextTimerState   <= ST_TW_IDLE;
        NextCntEnd       <= '1';
      elsif (CnclSmWaitS2 = '1') then
        NextTimerState   <= ST_TW_IDLE;
        iWaitToutErr  <= '1';
      end if;

    when others =>
      NextTimerState   <= ST_TW_IDLE;
  end case;
end process p_TimerComb;

-- -----------------------------------------------------------------------------
-- Select the enable times from the normal value and the access time values
-- depending on which one is smaller.
-- If WSTOEN is greater than WST1, OEnCount follows the WST1 value.
-- During burst mode reads, if WSTOEN is less than WST2, OenCount follows
-- the WST2 value. Else OEnCount follows WSTOEN value.
-- If WSTWEN is greater than WST2, WrEnCount follows the WST2 value.
-- Else WrEnCount follows WSTWEN value.
-- This logic prevents the transfer state machine from hanging if the user
-- erroneously programs the write enable time greater than the write access time
-- or the output enable time greater than read access time.
-- -----------------------------------------------------------------------------
WrEnCount        <= WST2(3 downto 0) when (WST2 < ('0' & WSTWEN))
                 else
                    WSTWEN;

OEnCount         <= WST1(3 downto 0) when (WST1 < ('0' & WSTOEN))
                 else
                    WST2(3 downto 0) when (BM = '1' and (WST2 < ('0' & WSTOEN)))
                 else
                    WSTOEN;

-- -----------------------------------------------------------------------------
-- Generate signals which check if the delay count value for the WEn or the
-- OEn is equal to zero.
-- -----------------------------------------------------------------------------
WEnCntEZ         <= '1' when (WrEnCount = "0000")
                 else
                    '0';

OEnCntEZ         <= '1' when (OEnCount = "0000")
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Combination logic for the WEN and OEN delay count
-- -----------------------------------------------------------------------------
p_OeWeDlyComb : process (DelayState, WEnCntLdCo, OEnCntLdCo, OEnCount, DelayCnt,
                         WrEnCount)
begin
  NextDelayState   <= DelayState;
  NextDelayCnt     <= DelayCnt;

  case DelayState is
    when '0' =>
      if (WEnCntLdCo = '1') then
        NextDelayState <= '1';
        NextDelayCnt   <= WrEnCount;
      elsif (OEnCntLdCo = '1') then
        NextDelayState <= '1';
        NextDelayCnt   <= OEnCount;
      end if;

    when '1' =>
      if (DelayCnt = "0001") then
        NextDelayState <= '0';
      else
        NextDelayCnt   <= unsigned(DelayCnt) - 1;
      end if;

    when others =>
      NextDelayState <= '0';
  end case;
end process p_OeWeDlyComb;

-- -----------------------------------------------------------------------------
-- Delay count end generation, the DelayEnd is generated a CLOCK earlier so
-- that it can be used to get correct timings in the TSM, EIB blocks
-- -----------------------------------------------------------------------------
p_DelayEndComb : process (DelayState, NextDelayCnt, WEnCntLdCo, OEnCntLdCo,
                          WrEnCount, OEnCount)
begin
  NextDelayEnd     <= '0';

  if ((DelayState = '1' and NextDelayCnt = "0001")
     or
      ((WEnCntLdCo = '1' and WrEnCount = "0001") or
       (OEnCntLdCo = '1' and OEnCount = "0001"))
     ) then
    NextDelayEnd   <= '1';
  end if;
end process p_DelayEndComb;

-- -----------------------------------------------------------------------------
-- Sequential Logic for Timercounter and Timer state machine states
-- -----------------------------------------------------------------------------
p_TimerDlySeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    TimerState         <= ST_TW_IDLE;
    DelayState         <= '0';
    TimerCnt           <= (others => '0');
    DelayCnt           <= (others => '0');
    iCntEnd            <= '0';
    iDelayEnd          <= '0';
    iWaitToutErrQ      <= '0';
    WaitPolPrev        <= '0';
    iCntEZEnd          <= '0';
  elsif (HCLK'event and HCLK = '1') then
    TimerState         <= NextTimerState;
    DelayState         <= NextDelayState;
    TimerCnt           <= NextTimerCnt;
    DelayCnt           <= NextDelayCnt;
    iCntEnd            <= NextCntEnd;
    iDelayEnd          <= NextDelayEnd;
    iWaitToutErrQ      <= iWaitToutErr;
    WaitPolPrev        <= NextWaitPolPrev;
    iCntEZEnd          <= NextCntEZEnd;
  end if;
end process p_TimerDlySeq;

-- -----------------------------------------------------------------------------
-- The WaitPol of the bank which resulted in the WaitToutErr is stored, as the
-- SMWAIT is still found to be asserted. This means that the previous transfer
-- has not yet ended. The next transfer is not started till the SMWAIT for the
-- previous transfer is de-asserted.
-- -----------------------------------------------------------------------------
NextWaitPolPrev  <= WaitPol when (TimerState = ST_TW_EXTWAIT and
                                  iWaitToutErrQ = '1')
                 else
                   WaitPolPrev;

-- -----------------------------------------------------------------------------
-- Connect Local Copies to output
-- -----------------------------------------------------------------------------

CntEnd           <= iCntEnd;
DelayEnd         <= iDelayEnd;
WaitToutErr      <= iWaitToutErrQ;
CntEZEnd         <= iCntEZEnd;

end synth;

-- --================================== End ==================================--
