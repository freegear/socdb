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
--  File Name           : DmacTrMasWrap.vhd,v
--  File Revision       : 1.19
--  
--  Release Information : FRBM_VHDL-BET01
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

entity DmacTrMasWrap is
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
    MERROR      : out  std_logic
  );

end DmacTrMasWrap;

architecture synth of DmacTrMasWrap is

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
  constant ST_GRANT_SPLIT   : std_logic_vector(3 downto 0) := "0111";
  constant ST_GRANT_HLD     : std_logic_vector(3 downto 0) := "1111";
  constant ST_DEGRANT_CLK   : std_logic_vector(3 downto 0) := "0001";
  constant ST_DEGRANT_SPLIT : std_logic_vector(3 downto 0) := "0101";
  constant ST_DEGRANT_HLD   : std_logic_vector(3 downto 0) := "1101";
  constant ST_UNKNOWN       : std_logic_vector(3 downto 0) := "XXXX";

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
-- Grant State Machine
  signal Valid        : std_logic;
  signal NextState    : std_logic_vector(3 downto 0);
  signal State        : std_logic_vector(3 downto 0);

-- State machine decode flags
  signal HoldReg       : std_logic;  -- Transfer using holding regs
  signal AddrDrive     : std_logic;  -- High when in control of address bus
  signal DataDrive     : std_logic;  -- High when in control of data bus
  signal SplitRetry    : std_logic;  -- High during 2nd cycle of S/R resp
  signal ReBuild       : std_logic;  -- High when burst needs re-building
  signal ReGrant       : std_logic;  -- High for first address transfer
  
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
  
-- Signals to override HTRANS when reconstructing a wrapping burst
  signal Wrapped     : std_logic;
  signal WrappedNext : std_logic;
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
-- inserted at the begining of the transfer
  signal NextLockIdle  : std_logic_vector(1 downto 0);
  signal LockIdle      : std_logic_vector(1 downto 0);

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
  
  p_NextStateComb : process (State, HREADY, HRESP, HGRANT, 
                             Valid, LockIdle, HtransHold)
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
            if (LockIdle /= "00") then           -- LockIdles at end of transfer
              if HtransHold = TRN_NONSEQ then  -- registers hold new transfer
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
            if (LockIdle /= "00") then           -- LockIdles at end of transfer
              if (HtransHold = TRN_NONSEQ) then  -- registers hold new transfer
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

      when others =>
        NextState <= ST_UNKNOWN;

      end case;

  end process p_NextStateComb;

-- Loads the value of NextState in on each HCLK
  p_StateSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then                       -- Initial State
      State <= ST_NOGRANT_CLK;
    elsif (HCLK'event and HCLK = '1') then
      State <= NextState;
    end if;
  end process p_StateSeq;

--------------------------------------------------------------------------------
-- State Output Decodes
--------------------------------------------------------------------------------

-- States in which the Wrapper uses the Address/Control Holding Registers
  p_HoldRegSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      HoldReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (NextState = ST_NOGRANT_HLD or
          NextState = ST_REGRANT_HLD or
          NextState = ST_GRANT_HLD   or
          NextState = ST_GRANT_SPLIT or 
          NextState = ST_DEGRANT_HLD or
          NextState = ST_DEGRANT_SPLIT) then
        HoldReg <= '1';
      else
        HoldReg <= '0';
      end if;
    end if;
  end process p_HoldRegSeq;

-- States in which the wrapper must set HTRANS to idle during a split
--  or retry response from AHB slave
  p_SplitRetrySeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      SplitRetry <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (NextState = ST_GRANT_SPLIT or 
          NextState = ST_DEGRANT_SPLIT) then
        SplitRetry <= '1';
      else
        SplitRetry <= '0';
      end if;
    end if;
  end process p_SplitRetrySeq;

-- States in which a fixed length burst has to be re-built by wrapper
  p_ReBuildSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      ReBuild <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (NextState = ST_GRANT_SPLIT or
          NextState = ST_NOGRANT_HLD or
          NextState = ST_REGRANT_HLD or
          NextState = ST_DEGRANT_HLD or
          NextState = ST_DEGRANT_CLK or
          NextState = ST_DEGRANT_SPLIT) then
        ReBuild <= '1';
      else
        ReBuild <= '0';
      end if;
    end if;
  end process p_ReBuildSeq;

-- States that indicate the wrapper has just gained control of the bus
-- ie the first address phase
  p_ReGrantSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      ReGrant <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (NextState = ST_REGRANT_HLD or
          NextState = ST_REGRANT_CLK) then
        ReGrant <= '1';
      else
        ReGrant <= '0';
      end if;
    end if;
  end process p_ReGrantSeq;

---------------------------------------------------------------------------------
-- Signals indicating control of address and data buses
---------------------------------------------------------------------------------
-- Address bus control (AddrDrive) when HGRANT and HREADY sampled high
  
  p_AddrDriveSeq : process (HRESETn, HCLK)
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
  p_DataDriveSeq : process (HRESETn, HCLK)
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
  p_ACHoldSeq : process (HRESETn, HCLK)
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
-- Lock IDLE insert
--------------------------------------------------------------------------------
-- When granted the bus and the AHB-Lite master starts a locked transfer an
-- idle cycle must be inserted, to ensure arbiter has a chance to change
-- HGRANT before the locked transfer begins. At the end of the locked transfers
-- the arbiter inserts 2 idle transfers, one which is a locked idle due to
-- HLOCK being asserted up to the last transfer, and another to allow the
-- arbiter to change the HGRANT signal.

  NextLockIdle <= "01" when (HoldSel   = '0' and  -- not in holding state
                             AddrDrive = '1' and  -- granted address bus
                             HlockHold = '0' and  -- last transfer not locked
                             MMASTLOCK = '1')     -- locked transfer
                       else
                  
                  "10" when (HoldSel   = '0' and  -- not in holding state
                             HlockHold = '1' and  -- last transfer locked
                             MMASTLOCK = '0')     -- not a locked transfer
                       else
                             
                  "00" when LockIdle = "00"       -- not a locked transfer
                  
                       else
                             
                  LockIdle - '1';
 
  
-- LockIdle loaded on each AHB transfer
  p_LockIdleSeq: process (HCLK, HRESETn)
  begin
    if (HRESETn = '0') then
      LockIdle <= "00";
    elsif (HCLK'event and HCLK = '1') then
      if (HREADY = '1') then
        LockIdle <= NextLockIdle;
      end if;
    end if;
  end process p_LockIdleSeq;

--------------------------------------------------------------------------------
-- Holding register multiplexer
--------------------------------------------------------------------------------
-- Selects between the AHB-Lite signals or the holding registers for
-- generation of the AHB outputs.

-- Indicates when the holding registers are in use, either the holding
-- states of the FSM or the Idle transfer insertion.
  HoldSel <= '1' when HoldReg = '1' or
                      (LockIdle /= "00" and HtransHold = TRN_NONSEQ) else
             '0';
  

  p_ACMux : process (HoldSel, HaddrHold, HwriteHold, HsizeHold, HprotHold,
                     HlockHold, HburstHold, MADDR, MWRITE, MSIZE, MPROT,
                     MMASTLOCK, MBURST)
  begin
    if (HoldSel = '1') then
      iHADDR    <= HaddrHold;
      HWRITE    <= HwriteHold;
      iHSIZE    <= HsizeHold;
      HPROT     <= HprotHold;
      HLOCK     <= HlockHold;
      HburstMux <= HburstHold;
    else
      iHADDR    <= MADDR;
      HWRITE    <= MWRITE;
      iHSIZE    <= MSIZE;
      HPROT     <= MPROT;
      HLOCK     <= MMASTLOCK;
      HburstMux <= MBURST;
    end if;
  end process p_ACMux;

  HADDR <= iHADDR;
  
  HSIZE <= iHSIZE;
  
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
-- Re-building bursts 
--------------------------------------------------------------------------------
-- When a fixed burst is interrupted due to a split, retry or loss of bus, it
-- is completed using the INCR burst of undefined length. HBURST is forced to
-- INCR when a burst has been interrupted.
-- Set Burst override when ReBuild flag set during a burst.
-- If the burst is interrupted on the first transfer, HBURST is not overridden.

  NextIncrOverride <= '1' when (ReBuild = '1' and
                                (HtransHold = TRN_SEQ or
                                 HtransHold = TRN_BUSY)) else
                     
                      '0' when ((MTRANS = TRN_NONSEQ or MTRANS = TRN_IDLE) and
                                HoldSel = '0') else
                     
                      IncrOverride;

  p_IncrSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      IncrOverride <= '0';
    elsif (HCLK'event and HCLK = '1') then
      IncrOverride <= NextIncrOverride;
    end if;
  end process p_IncrSeq;


--------------------------------------------------------------------------------
-- Wrapping Address detection
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
        OffsetAddr <= (others => 'X');
    end case;
  end process p_OffsetAddrComb;

  p_CheckAddrComb : process (OffsetAddr, MBURST)
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

      when BUR_SINGLE => CheckAddr(3 downto 0) <= "0000";
      when BUR_INCR   => CheckAddr(3 downto 0) <= "0000";
      when BUR_INCR4  => CheckAddr(3 downto 0) <= "0000";
      when BUR_INCR8  => CheckAddr(3 downto 0) <= "0000";
      when BUR_INCR16 => CheckAddr(3 downto 0) <= "0000";
                        
      when others =>
        CheckAddr(3 downto 0) <= (others => 'X');

    end case;
  end process p_CheckAddrComb;

  WrappedNext <= '1' when CheckAddr = "1111" else
                 '0';

  p_WrappedSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      Wrapped <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if (HREADY = '1' and Valid = '1') then
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
                               MTRANS = TRN_SEQ else
                      
                      BusyOverride;

  p_BusySeq : process (HRESETn, HCLK)
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
--     c) when not granted the bus and MTRANS is BUSY or SEQ
--     d) when granted the bus whilst the master is driving BUSY
--     e) when an address wrap occurs during a fixed length burst rebuild
--        and master attempts a BUSY transfer
  
--  * driven NONSEQ
--     a) when a transfer is waiting in holding register
--     b) when an address wrap occurs or bus regranted during a fixed length
--        burst rebuild

  HTRANS <= TRN_IDLE   when SplitRetry = '1' or                           -- (a)
                            NextLockIdle /= "00" or                       -- (b)
                            AddrDrive = '0' or                            -- (c)
                            NextBusyOverride = '1' or                     -- (d)
                            (Wrapped = '1' and IncrOverride = '1' and
                             MTRANS = TRN_BUSY) else                      -- (e)

            TRN_NONSEQ when (HoldSel = '1' or                                -- (a)
                             ((Wrapped = '1' or ReGrant = '1') and         
                              IncrOverride = '1' and MTRANS = TRN_SEQ)) else -- (b)

            MTRANS;

--------------------------------------------------------------------------------
-- HBURST Drive
--------------------------------------------------------------------------------
-- HBURST only forced to INCR when rebuilding a burst otherwise it is set to
-- the same state as HburstMux
  
  HBURST <= BUR_INCR when NextIncrOverride = '1' else
            
            HburstMux;

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
  p_HreqStoreSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iHREQReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      iHREQReg <= iHBUSREQ;
    end if;
  end process p_HreqStoreSeq;
  
--------------------------------------------------------------------------------
-- Data Drives
--------------------------------------------------------------------------------
-- MWDATA is passed through unmodified, to HWDATA

  HWDATA <= MWDATA;
  
-- HRDATA is passed through unmodified, to MRDATA
    
  MRDATA <= HRDATA;

end synth;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
