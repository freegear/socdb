--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--
--------------------------------------------------------------------------------
--  Version and Release Control Information:
--
--  File Name           : Lite2AHB.vhd,v
--  File Revision       : 1.3
--
--  Release Information : ADK_REL1v1
--
--------------------------------------------------------------------------------
--  Purpose             : This wrapper enables an AHB-Lite master to interface
--                        to an AHB system. The wrapper handles bus requests
--                        and slave responses, using MREADY as a means to hold
--                        the AHB-Lite master.
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned."-";

entity Lite2AHB is
  port(
    -- Global signals
    HCLK        : in  std_logic;
    HRESETn     : in  std_logic;

    -- Signals from AHB
    HRDATA      : in  std_logic_vector(31 downto 0);
    HREADY      : in  std_logic;
    HRESP       : in  std_logic_vector(1 downto 0);
    HGRANT      : in  std_logic;

    -- Signals from AHB-Lite
    MADDR       : in std_logic_vector(31 downto 0);
    MTRANS      : in std_logic_vector(1 downto 0);
    MWRITE      : in std_logic;
    MSIZE       : in std_logic_vector(2 downto 0);
    MBURST      : in std_logic_vector(2 downto 0);
    MPROT       : in std_logic_vector(3 downto 0);
    MMASTLOCK   : in std_logic;
    MWDATA      : in std_logic_vector(31 downto 0);

    -- Signals to AHB
    HADDR       : out std_logic_vector(31 downto 0);
    HTRANS      : out std_logic_vector(1 downto 0);
    HWRITE      : out std_logic;
    HSIZE       : out std_logic_vector(2 downto 0);
    HBURST      : out std_logic_vector(2 downto 0);
    HPROT       : out std_logic_vector(3 downto 0);
    HWDATA      : out std_logic_vector(31 downto 0);
    HBUSREQ     : out std_logic;
    HLOCK       : out std_logic;

    -- Signals to AHB-Lite
    MRDATA      : out  std_logic_vector(31 downto 0);
    MREADY      : out  std_logic;
    MERROR      : out  std_logic;
    
    -- Scan test dummy signals; not connected until scan insertion 
    SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
    SCANINHCLK  : in  std_logic; -- Scan Chain Input
    SCANOUTHCLK : out std_logic  -- Scan Chain Output    
  );

end Lite2AHB;

architecture synth of Lite2AHB is

------------------------------------------------------------------------
--- Constant declarations
------------------------------------------------------------------------
--- HTRANS transfer
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

-- HSIZE transfer type signal encoding
  constant SZ_BYTE : std_logic_vector(2 downto 0) := "000";
  constant SZ_HALF : std_logic_vector(2 downto 0) := "001";
  constant SZ_WORD : std_logic_vector(2 downto 0) := "010";

-- HBURST transfer type signal encoding
  constant BUR_SINGLE : std_logic_vector(2 downto 0) := "000";
  constant BUR_INCR   : std_logic_vector(2 downto 0) := "001";
  constant BUR_WRAP4  : std_logic_vector(2 downto 0) := "010";
  constant BUR_INCR4  : std_logic_vector(2 downto 0) := "011";
  constant BUR_WRAP8  : std_logic_vector(2 downto 0) := "100";
  constant BUR_INCR8  : std_logic_vector(2 downto 0) := "101";
  constant BUR_WRAP16 : std_logic_vector(2 downto 0) := "110";
  constant BUR_INCR16 : std_logic_vector(2 downto 0) := "111";

-- Wrap boundary limits
  constant NOBOUND : std_logic_vector(2 downto 0) := "000";
  constant BOUND4  : std_logic_vector(2 downto 0) := "001";
  constant BOUND8  : std_logic_vector(2 downto 0) := "010";
  constant BOUND16 : std_logic_vector(2 downto 0) := "011";
  constant BOUND32 : std_logic_vector(2 downto 0) := "100";
  constant BOUND64 : std_logic_vector(2 downto 0) := "101";

-- HRESP transfer response signal encoding
  constant RSP_OKAY  : std_logic_vector(1 downto 0) := "00";
  constant RSP_ERROR : std_logic_vector(1 downto 0) := "01";
  constant RSP_RETRY : std_logic_vector(1 downto 0) := "10";
  constant RSP_SPLIT : std_logic_vector(1 downto 0) := "11";

-- FSM States
  constant ST_NOGRANT_CLK   : std_logic_vector(3 downto 0) := "0000";
  constant ST_NOGRANT_HLD   : std_logic_vector(3 downto 0) := "0100";
  constant ST_REGRANT_CLK   : std_logic_vector(3 downto 0) := "0010";
  constant ST_REGRANT_HLD   : std_logic_vector(3 downto 0) := "0110";
  constant ST_GRANT_CLK     : std_logic_vector(3 downto 0) := "0011";
  constant ST_GRANT_SPLIT   : std_logic_vector(3 downto 0) := "1111";
  constant ST_GRANT_HLD     : std_logic_vector(3 downto 0) := "0111";
  constant ST_DEGRANT_CLK   : std_logic_vector(3 downto 0) := "0001";
  constant ST_DEGRANT_SPLIT : std_logic_vector(3 downto 0) := "1101";
  constant ST_DEGRANT_HLD   : std_logic_vector(3 downto 0) := "0101";

-- Locked FSM States
  constant ST_NO_LOCK         : std_logic_vector(2 downto 0) := "110";
  constant ST_IDLE_FIRST      : std_logic_vector(2 downto 0) := "011";
  constant ST_LOCKED_TRANSFERS: std_logic_vector(2 downto 0) := "111";
  constant ST_UNLOCKED_IDLE   : std_logic_vector(2 downto 0) := "010";
  constant ST_LOCKED_IDLE     : std_logic_vector(2 downto 0) := "101";

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
-- Grant State Machine
  signal Valid        : std_logic;
  signal NextState    : std_logic_vector(3 downto 0);
  signal State        : std_logic_vector(3 downto 0);

-- Bus control flags
  signal AddrDrive     : std_logic;  -- High when in control of address bus
  signal DataDrive     : std_logic;  -- High when in control of data bus

-- State machine decode flags
  signal HoldReg        : std_logic;  -- Transfer using holding regs
  signal SplitRetry     : std_logic;  -- High during 2nd cycle of S/R resp
  signal ReBuild        : std_logic;  -- High when burst needs re-building
  signal ReGrant        : std_logic;  -- High for first address transfer
  signal NextHoldReg    : std_logic;
  signal NextSplitRetry : std_logic;
  signal NextReBuild    : std_logic;
  signal NextReGrant    : std_logic;

-- Internal copies of output signals
  signal iHBUSREQ      : std_logic;
  signal iMREADY       : std_logic;
  signal iHADDR        : std_logic_vector(31 downto 0);
  signal iHSIZE        : std_logic_vector(2 downto 0);

-- Registered HBUSREQ signal
  signal iHREQReg      : std_logic;

-- Signals to override MBURST when reconstructing a burst
  signal IncrOverride     : std_logic;
  signal NextIncrOverride : std_logic;
  signal HburstMux        : std_logic_vector(2 downto 0);
  signal FirstTransfer    : std_logic;

-- Signals to override HTRANS when reconstructing a wrapping burst
  signal Wrapped     : std_logic;
  signal WrappedNext : std_logic;
  signal WrappedEn   : std_logic;
  signal OffsetAddr  : std_logic_vector(3 downto 0);
  signal CheckAddr   : std_logic_vector(3 downto 0);

-- Signals to override HTRANS with IDLE when MTRANS drives BUSY and the bus is
-- regranted
  signal BusyOverride     : std_logic;
  signal NextBusyOverride : std_logic;

-- Holding Register Select flag
  signal HoldSel       : std_logic;

-- Holding Registers
  signal HaddrHold     : std_logic_vector(31 downto 0);
  signal HwriteHold    : std_logic;
  signal HsizeHold     : std_logic_vector(2 downto 0);
  signal HprotHold     : std_logic_vector(3 downto 0);
  signal HlockHold     : std_logic;
  signal HburstHold    : std_logic_vector(2 downto 0);
  signal HtransHold    : std_logic_vector(1 downto 0);

-- Signals to detect when a locked transfer requires an idle cycle to be
-- inserted at the beginning and end of the transfer
  signal LockIdle       : std_logic;
  signal NextLockIdle   : std_logic;
  signal LockState      : std_logic_vector(2 downto 0);
  signal NextLockState  : std_logic_vector(2 downto 0);
  signal LockedTransfer : std_logic;

--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------
begin

--------------------------------------------------------------------------------
-- Grant FSM
--------------------------------------------------------------------------------
-- The grant state machine tracks the combined arbiter and slave response on
-- AHB interface so appropriate control signals can be generated for the
-- wrapper functions.

-- Valid transfer flag generation, when the AHB-Lite master is attempting a
-- valid transfer the flag is set.

  Valid <= '1' when MTRANS = TRN_NONSEQ or MTRANS = TRN_SEQ else

           '0';

-- State Names
--   ST_XXXX_CLK     - AHB-lite master is not stalled by MREADY
--   ST_XXXX_HLD     - AHB-lite master is stalled by MREADY and holding
--                     registers in use
--   ST_XXXX_SPLIT   - Wrapper in 2nd cycle of split or retry
--   ST_NOGRANT_XXX  - Wrapper not granted AHB interface
--   ST_REGRANT_XXX  - Wrapper in 1st address phase after grant signal
--                     asserted
--   ST_GRANT_XXX    - Wrapper granted the bus for more than one cycle
--   ST_DEGRANT_XXX  - Wrapper lost grant and in last data phase

  p_NextStateComb : process (HGRANT, HREADY, HRESP, HtransHold, LockIdle,
                             State, Valid)
  begin
    case State is

      when ST_NOGRANT_CLK =>
        if (HREADY = '0' or HGRANT = '0') then    -- Not Ready OR Not Granted
          if (Valid = '0') then                   --   Not Valid Transfer
            NextState <= ST_NOGRANT_CLK;
          else                                    --   Valid Tranfer
            NextState <= ST_NOGRANT_HLD;
          end if;
        else                                      -- Ready AND Granted
          if (Valid = '0') then                   --   Not Valid Transfer
            NextState <= ST_REGRANT_CLK;
          else                                    --   Valid Tranfer
            NextState <= ST_REGRANT_HLD;
          end if;
        end if;

      when ST_NOGRANT_HLD =>
        if (HREADY = '0' or HGRANT = '0') then    -- Not Ready OR Not Granted
          NextState <= ST_NOGRANT_HLD;
        else                                      --   Ready AND Granted
          NextState <= ST_REGRANT_HLD;
        end if;

      when ST_REGRANT_CLK =>
        if (HREADY = '0') then                    -- Not Ready
          if (Valid = '0') then                   --   Not Valid Transfer
            NextState <= ST_REGRANT_CLK;
          else                                    --   Valid Transfer
            NextState <= ST_REGRANT_HLD;
          end if;
        else                                      -- Ready
          if (HGRANT = '1') then                  --   Granted
            NextState <= ST_GRANT_CLK;
          else                                    --   Not Granted
            NextState <= ST_DEGRANT_CLK;
          end if;
        end if;

      when ST_REGRANT_HLD =>
        if (HREADY = '0') then                    -- Not Ready
          NextState <= ST_REGRANT_HLD;
        else                                      -- Ready
          if (HGRANT = '1') then                  --   Granted
            NextState <= ST_GRANT_CLK;
          else                                    --   Not Granted
            NextState <= ST_DEGRANT_CLK;
          end if;
        end if;

      when ST_GRANT_CLK =>
        if (HREADY = '0') then                    -- Not Ready
          if (HRESP = RSP_SPLIT or
              HRESP = RSP_RETRY) then             --   Split/Retry
            NextState <= ST_GRANT_SPLIT;
          else                                    --   Not Split/Retry
            NextState <= ST_GRANT_CLK;
          end if;
        else                                      -- Ready
          if (HGRANT = '1') then                  --   Granted
            NextState <= ST_GRANT_CLK;
          else                                    --   Not Granted
            NextState <= ST_DEGRANT_CLK;
          end if;
        end if;

      when ST_GRANT_SPLIT =>                      -- Slave Returns Ready
        if (HGRANT = '0') then                    --   Not granted
          NextState <= ST_DEGRANT_HLD;
        else                                      --   Granted
          NextState <= ST_GRANT_HLD;
        end if;

      when ST_GRANT_HLD =>
        if (HGRANT = '0') then                  --   Not Granted
          NextState <= ST_DEGRANT_CLK;
        else                                    --   Granted
          NextState <= ST_GRANT_CLK;
        end if;

      when ST_DEGRANT_CLK =>
        if (HREADY = '0') then                    -- Not Ready
          if (HRESP = RSP_SPLIT or
              HRESP = RSP_RETRY) then             --   Split/Retry
            NextState <= ST_DEGRANT_SPLIT;
          else                                    --   Not Split/Retry
            NextState <= ST_DEGRANT_CLK;
          end if;
        else                                      -- Ready
          if (HGRANT = '0') then                  --   Not Granted
            if (LockIdle = '1') then              -- Need to use holding reg
              if (HtransHold = TRN_NONSEQ or      -- transfer waiting in
                  Valid = '1') then               -- register or on Lite bus
                NextState <= ST_NOGRANT_HLD;
              else
                NextState <= ST_NOGRANT_CLK;
              end if;
            else
              if (Valid = '0') then               --     Not Valid Transfer
                NextState <= ST_NOGRANT_CLK;
              else                                --     Valid Transfer
                NextState <= ST_NOGRANT_HLD;
              end if;
            end if;
          else                                    --   Granted
            if (LockIdle = '1') then              -- Need to use holding reg
              if (HtransHold = TRN_NONSEQ or      -- transfer waiting in
                  Valid = '1') then               -- register or on Lite bus
                NextState <= ST_REGRANT_HLD;
              else
                NextState <= ST_REGRANT_CLK;
              end if;
            else
              if (Valid = '0') then               --     Not Valid Transfer
                NextState <= ST_REGRANT_CLK;
              else                                --     Valid Transfer
                NextState <= ST_REGRANT_HLD;
              end if;
            end if;
          end if;
        end if;

      when ST_DEGRANT_SPLIT =>                    -- Slave Returns Ready
        if (HGRANT = '0') then                    -- Not granted
          NextState <= ST_NOGRANT_HLD;
        else                                      -- Granted
          NextState <= ST_REGRANT_HLD;
        end if;

      when ST_DEGRANT_HLD =>
        if (HGRANT = '0') then                    --   Not Granted
          NextState <= ST_NOGRANT_HLD;
        else                                      --   Granted
          NextState <= ST_REGRANT_HLD;
        end if;

      when others =>                              -- illegal transition
        NextState <= ST_NOGRANT_CLK;

      end case;

  end process p_NextStateComb;

-- Loads the value of NextState in on each HCLK
  p_StateSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then                       -- Initial State
      State <= ST_NOGRANT_CLK;
    elsif (HCLK'event and HCLK = '1') then
      State <= NextState;
    end if;
  end process p_StateSeq;

--------------------------------------------------------------------------------
-- State output decodes
--------------------------------------------------------------------------------

-- States in which the holding resisters should be used

  NextHoldReg <= '1' when (NextState = ST_NOGRANT_HLD or
                           NextState = ST_REGRANT_HLD or
                           NextState = ST_GRANT_HLD   or
                           NextState = ST_GRANT_SPLIT or
                           NextState = ST_DEGRANT_HLD or
                           NextState = ST_DEGRANT_SPLIT) else

                 '0';

-- States indicating the second cycle of a SPLIT/RETRY response

  NextSplitRetry <= '1' when (NextState = ST_GRANT_SPLIT or
                              NextState = ST_DEGRANT_SPLIT) else

                    '0';

-- States in which a fixed length burst has to be re-built by wrapper

  NextReBuild <= '1' when (NextState = ST_GRANT_SPLIT or
                           NextState = ST_NOGRANT_HLD or
                           NextState = ST_REGRANT_HLD or
                           NextState = ST_DEGRANT_HLD or
                           NextState = ST_DEGRANT_CLK or
                           NextState = ST_DEGRANT_SPLIT) else

                 '0';

-- States that indicate the wrapper has just gained control of the bus
-- i.e. the first address phase

  NextReGrant <= '1' when (NextState = ST_REGRANT_HLD or
                           NextState = ST_REGRANT_CLK) else

                 '0';

-- Registers for state decodes
  p_StateDecodeRegSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      HoldReg    <= '0';
      SplitRetry <= '0';
      ReBuild    <= '0';
      ReGrant    <= '0';
    elsif (HCLK'event and HCLK = '1') then
      HoldReg    <= NextHoldReg;
      SplitRetry <= NextSplitRetry;
      ReBuild    <= NextReBuild;
      ReGrant    <= NextReGrant;
    end if;
  end process p_StateDecodeRegSeq;

--------------------------------------------------------------------------------
-- Signals indicating control of address and data buses
--------------------------------------------------------------------------------
-- Address bus control (AddrDrive) when HGRANT and HREADY sampled high

  p_AddrDriveSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      AddrDrive <= '0';                            -- Initial State
    elsif (HCLK'event and HCLK = '1') then
      if (HREADY = '1') then
        AddrDrive <= HGRANT;
      end if;
    end if;
  end process p_AddrDriveSeq;

-- Data bus control (DataDrive) when AddrDrive and HREADY sampled high
  p_DataDriveSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      DataDrive <= '0';                            -- Initial State
    elsif (HCLK'event and HCLK = '1') then
      if (HREADY = '1') then
        DataDrive <= AddrDrive;
      end if;
    end if;
  end process p_DataDriveSeq;

--------------------------------------------------------------------------------
-- Address and control holding registers
--------------------------------------------------------------------------------
-- These registers are used to hold the previous cycle's address and control
-- signals.

-- Registers are updated on every completed AHB-Lite transfer
  p_ACHoldSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      HaddrHold  <= (others => '0');
      HwriteHold <= '0';
      HsizeHold  <= (others => '0');
      HprotHold  <= (others => '0');
      HlockHold  <= '0';
      HburstHold <= (others => '0');
      HtransHold <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if (iMREADY = '1') then
        HaddrHold  <= MADDR;
        HtransHold <= MTRANS;
        HwriteHold <= MWRITE;
        HsizeHold  <= MSIZE;
        HprotHold  <= MPROT;
        HlockHold  <= MMASTLOCK;
        HburstHold <= HburstMux;
      end if;
    end if;
  end process p_ACHoldSeq;

--------------------------------------------------------------------------------
-- Locked Transfer
--------------------------------------------------------------------------------
-- Indicates when the master is attempting a locked transfer or when a locked
-- transfer is waiting in the holding registers.

  LockedTransfer <= '1' when ((MMASTLOCK = '1' and HoldSel = '0') or
                              (HlockHold = '1' and HoldSel = '1')) else
                    '0';

--------------------------------------------------------------------------------
-- Lock IDLE insert
--------------------------------------------------------------------------------
-- When granted the bus and the AHB-Lite master starts a locked transfer an
-- idle cycle must be inserted, to ensure arbiter has a chance to change
-- HGRANT before the locked transfer begins. At the end of the locked transfers
-- the arbiter inserts 2 idle transfers, one which is a locked idle due to
-- HLOCK being asserted up to the last transfer, and another unlocked to allow
-- the arbiter to change the HGRANT signal.

-- Locked Idle State Machine
  p_LockedIdleFSMComb: process(AddrDrive, LockState, LockedTransfer)
  begin
    case LockState is

      when ST_NO_LOCK =>             
        if LockedTransfer = '1' then                          -- Locked transfer
          if AddrDrive = '1' then                    -- already granted addr bus
            NextLockState <= ST_IDLE_FIRST;              -- insert idle at start
          else
            NextLockState <= ST_LOCKED_TRANSFERS;      -- start locked transfers
          end if;
        else
          NextLockState <= ST_NO_LOCK;
        end if;

      when ST_IDLE_FIRST =>
        NextLockState <= ST_LOCKED_TRANSFERS;          -- start locked transfers

      when ST_LOCKED_TRANSFERS =>
        if LockedTransfer = '0' then              -- current transfer not locked
          NextLockState <= ST_LOCKED_IDLE;        -- insert locked idle transfer
        else
          NextLockState <= ST_LOCKED_TRANSFERS;     -- continue locked transfers
        end if;

      when ST_LOCKED_IDLE =>
        NextLockState <= ST_UNLOCKED_IDLE;        -- always insert unlocked idle

      when ST_UNLOCKED_IDLE =>
        if LockedTransfer = '1' then         -- start of another locked transfer
          if AddrDrive = '1' then                    -- already granted addr bus
            NextLockState <= ST_IDLE_FIRST;              -- insert idle at start
          else
            NextLockState <= ST_LOCKED_TRANSFERS;      -- start locked transfers
          end if;
        else
          NextLockState <= ST_NO_LOCK;                -- end of locked transfers
        end if;

      when others =>                                 -- illegal state transition
        NextLockState <= ST_NO_LOCK;

    end case;
  end process p_LockedIdleFSMComb;

  -- Locked FSM Registers
  p_LockStateSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      LockState <= ST_NO_LOCK;
    elsif (HCLK'event and HCLK = '1') then   -- LockState is updated when HREADY
      if HREADY = '1' then                   -- asserted
        LockState <= NextLockState;
      end if;
    end if;
  end process p_LockStateSeq;

--------------------------------------------------------------------------------
-- Lock Idle
--------------------------------------------------------------------------------
-- Indicates when HTRANS needs to be forced to IDLE due to the LockState
-- NextLockIdle is asserted:
--   a) at the beginning of a burst/transfer if the master is already granted
--      the bus.
--   b) at the end of burst/transfer, this transfer is automatically locked
--      since HLOCK remains asserted until the last locked address phase of the
--      transfer has completed.
--   c) after the previous locked idle to give the AHB arbiter a chance to
--      re-arbitrate the AHB masters in the system.

  NextLockIdle <= '1'  when (((LockState = ST_NO_LOCK or
                               LockState = ST_UNLOCKED_IDLE) and
                              LockedTransfer = '1' and
                              AddrDrive = '1') or                         -- (a)

                             (LockState = ST_LOCKED_TRANSFERS and
                              LockedTransfer = '0') or                    -- (b)

                             LockState = ST_LOCKED_IDLE) else             -- (c)
                  '0';

-- LockIdle loaded on each AHB transfer
  p_LockIdleSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      LockIdle <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (HREADY = '1') then
        LockIdle <= NextLockIdle;
      end if;
    end if;
  end process p_LockIdleSeq;

--------------------------------------------------------------------------------
-- Re-building bursts
--------------------------------------------------------------------------------
-- When a fixed burst is interrupted due to a split, retry or loss of bus, it
-- is completed using the INCR burst of undefined length. HBURST is forced to
-- INCR when a burst has been interrupted.
-- Set Burst override when ReBuild flag set during a burst.
-- If the burst is interrupted by a split/retry on the first transfer, HBURST
-- is not overridden.

-- Indicates the first transfer in a burst
  FirstTransfer <= '1' when ((HtransHold = TRN_NONSEQ and
                              HoldSel = '1') or

                              (MTRANS = TRN_NONSEQ and
                               HoldSel = '0')) else

                   '0';

  NextIncrOverride <= '0' when ((SplitRetry = '1' and
                                 HtransHold = TRN_NONSEQ) or

                                ((MTRANS = TRN_NONSEQ or MTRANS = TRN_IDLE) and
                                 HoldSel = '0')) else

                      '1' when (ReBuild = '1' and
                                FirstTransfer = '0') else

                      IncrOverride;

  p_IncrSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      IncrOverride <= '0';
    elsif (HCLK'event and HCLK = '1') then
      IncrOverride <= NextIncrOverride;
    end if;
  end process p_IncrSeq;

--------------------------------------------------------------------------------
-- Wrapping address detection
--------------------------------------------------------------------------------
-- When reconstructing a wrapping burst, the burst type is overridden by INCR.
-- The wrapping point needs to be detected as HTRANS should be NONSEQ to
-- effectively start another burst.

  p_OffsetAddrComb : process (iHADDR, iHSIZE)
  begin
    case iHSIZE is
      when SZ_BYTE  =>
        OffsetAddr <= iHADDR(3 downto 0);
      when SZ_HALF  =>
        OffsetAddr <= iHADDR(4 downto 1);
      when SZ_WORD  =>
        OffsetAddr <= iHADDR(5 downto 2);
      when others =>
        OffsetAddr <= (others => '0');
    end case;
  end process p_OffsetAddrComb;

  p_CheckAddrComb : process (MBURST, OffsetAddr)
  begin
    case MBURST is
      when BUR_WRAP4 =>
        CheckAddr(1 downto 0) <= OffsetAddr(1 downto 0);
        CheckAddr(3 downto 2) <= "11";

      when BUR_WRAP8 =>
        CheckAddr(2 downto 0) <= OffsetAddr(2 downto 0);
        CheckAddr(3)          <= '1';

      when BUR_WRAP16 =>
        CheckAddr(3 downto 0) <= OffsetAddr(3 downto 0);

      when BUR_SINGLE | BUR_INCR | BUR_INCR4 | BUR_INCR8 | BUR_INCR16 =>
        CheckAddr(3 downto 0) <= "0000";

      when others =>
        CheckAddr(3 downto 0) <= "0000";

    end case;
  end process p_CheckAddrComb;

  WrappedNext <= '1' when CheckAddr = "1111" else
                 '0';

  -- Wrapped is updated as each valid transfer is sampled onto the bus
  WrappedEn <= '1' when (HREADY = '1' and Valid = '1') else

               '0';
  
  p_WrappedSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      Wrapped <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (WrappedEn = '1') then
        Wrapped <= WrappedNext;
      end if;
    end if;
  end process p_WrappedSeq;

--------------------------------------------------------------------------------
-- Re-gaining bus when MTRANS = BUSY
--------------------------------------------------------------------------------
-- If the grant signal has been deasserted during a burst then it is possible
--  that the wrapper will be granted the bus again when MTRANS is either SEQ
--  or BUSY. When it is BUSY Valid = "0" hence the AHB-Lite master is not
--  stalled by MREADY.
-- The wrapper cannot allow BUSY transfers on the regranted bus because it
--  needs to start a burst before a BUSY transfer can be used. Therefore the
--  BUSY transfers on MTRANS are forced to IDLE on HTRANS. When MTRANS becomes
--  SEQ HTRANS is forced to NONSEQ to start a new burst.

-- Busy override set when wrapper granted the bus and MTRANS is BUSY
-- Busy override cleared when the master the busy transfers have completed

  NextBusyOverride <= '1' when State = ST_REGRANT_CLK and MTRANS = TRN_BUSY else

                      '0' when BusyOverride = '1' and AddrDrive = '1' and
                               MTRANS /= TRN_BUSY else

                      BusyOverride;

  p_BusySeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      BusyOverride <= '0';
    elsif (HCLK'event and HCLK = '1') then
      BusyOverride <= NextBusyOverride;
    end if;
  end process p_BusySeq;

--------------------------------------------------------------------------------
-- HTRANS output modification
--------------------------------------------------------------------------------
-- HTRANS follows MTRANS except in the following conditions:
--  * driven IDLE
--     a) during the second cycle of a split/retry transfer
--     b) when idle needs inserting before a locked transfer
--     c) when not granted the bus
--     d) when granted the bus whilst the master is driving BUSY
--     e) when an address wrap occurs during a fixed length burst rebuild
--        and master attempts a BUSY transfer

--  * driven NONSEQ
--     a) when a transfer is waiting in holding register
--     b) when an address wrap occurs during a fixed length burst rebuild
--     c) over-riding the first SEQ after the bus has been regranted

  HTRANS <= TRN_IDLE   when SplitRetry = '1' or                           -- (a)
                            NextLockIdle = '1' or                         -- (b)
                            AddrDrive = '0' or                            -- (c)
                            NextBusyOverride = '1' or                     -- (d)
                            (Wrapped = '1' and IncrOverride = '1' and
                             MTRANS = TRN_BUSY and HoldSel = '0') else    -- (e)

            TRN_NONSEQ when (HoldSel = '1' or                             -- (a)

                             (Wrapped = '1' and IncrOverride = '1' and
                              MTRANS = TRN_SEQ) or                        -- (b)

                             ((BusyOverride = '1' or ReGrant = '1') and
                              MTRANS = TRN_SEQ)) else                     -- (c)
            MTRANS;

--------------------------------------------------------------------------------
-- HBURST output
--------------------------------------------------------------------------------
-- HBURST only forced to INCR when rebuilding a burst otherwise it is set to
-- the same state as HburstMux

  HBURST <= BUR_INCR when (NextIncrOverride = '1') else

            HburstMux;


--------------------------------------------------------------------------------
-- HLOCK output
--------------------------------------------------------------------------------
-- HLOCK is primarily defined by the state of MMASTLOCK or HlockHold when
-- HoldSel is asserted. Except when the Lock transfer state machine is in the
-- Locked idle state. HLOCK is forced low to ensure an unlocked idle occurs
-- allowing the AHB arbiter to de-grant the master.

  HLOCK <= '0'       when LockState = ST_LOCKED_IDLE else

           HlockHold when HoldSel = '1' else

           MMASTLOCK;

--------------------------------------------------------------------------------
-- Holding register multiplexer
--------------------------------------------------------------------------------
-- Selects between the AHB-Lite signals or the holding registers for
-- generation of the AHB outputs.

-- Indicates when the holding registers are in use, either the holding
-- states of the FSM or the Idle transfer insertion.

  HoldSel <= '1' when HoldReg = '1' or
                      (LockIdle = '1' and HtransHold = TRN_NONSEQ) else

             '0';


  p_ACMux : process (HaddrHold, HburstHold, HoldSel, HprotHold, HsizeHold,
                     HwriteHold, MADDR, MBURST, MPROT, MSIZE, MWRITE)
  begin
    if (HoldSel = '1') then
      iHADDR    <= HaddrHold;
      HWRITE    <= HwriteHold;
      iHSIZE    <= HsizeHold;
      HPROT     <= HprotHold;
      HburstMux <= HburstHold;
    else
      iHADDR    <= MADDR;
      HWRITE    <= MWRITE;
      iHSIZE    <= MSIZE;
      HPROT     <= MPROT;
      HburstMux <= MBURST;
    end if;
  end process p_ACMux;

  HADDR <= iHADDR;

  HSIZE <= iHSIZE;

--------------------------------------------------------------------------------
-- Bus request generation
--------------------------------------------------------------------------------
-- HBUSREQ is asserted when:
--  a) HBUSREQ is already asserted and the bus not yet granted
--  b) the master is attempting a transfer
--  c) using the holding register

  iHBUSREQ <= '1' when ((iHREQReg = '1' and
                         AddrDrive = '0' and DataDrive = '0') or  -- (a)
                        MTRANS /= TRN_IDLE or                     -- (b)
                        HoldSel = '1') else                       -- (c)

             '0';

  HBUSREQ <= iHBUSREQ;

  -- register previous value of HBUSREQ
  p_HreqStoreSeq : process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      iHREQReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      iHREQReg <= iHBUSREQ;
    end if;
  end process p_HreqStoreSeq;

--------------------------------------------------------------------------------
-- Wait state detection
--------------------------------------------------------------------------------
-- The MREADY input to the bus master is driven LOW when:
--  - when HREADY is LOW and the wrapper controls the data bus
--  - when a transfer is in the holding register waiting to complete

  iMREADY <= '0' when HoldSel = '1' or
                      (DataDrive = '1' and HREADY = '0') else
             '1';


  MREADY <= iMREADY;

--------------------------------------------------------------------------------
-- Error detection
--------------------------------------------------------------------------------
-- MERROR is asserted when the wrapper controls the data bus and HRESP
-- indicates an error response.

  MERROR <= '1' when DataDrive = '1' and HRESP = RSP_ERROR else
            '0';

--------------------------------------------------------------------------------
-- Data drives
--------------------------------------------------------------------------------

-- MWDATA is passed through unmodified, to HWDATA
  HWDATA <= MWDATA;

-- HRDATA is passed through unmodified, to MRDATA
  MRDATA <= HRDATA;

end synth;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
