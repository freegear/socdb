-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Arbiter.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
--
-- ---------------------------------------------------------------------
-- Purpose :
--           AHB System Arbiter.
--           The arbiter processes requests for ownership of the
--           bus and grants one bus master according to the
--           arbitration scheme.
--           The arbitration scheme of this implementation is a
--           simple priority encoded scheme where the highest
--           priority master requesting the bus is granted.
--           The priority order is as follows:
--           1) Async. Reset = ARM
--           2) Pause mode = Default
--           3) TIC
--           4) 003
--           5) 004
--           6) ARM, when no others granted and ARM not split
--           7) Default, when no others granted and ARM split
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_unsigned."-";

entity Arbiter is
  port(
    HCLK       : in  std_logic;
    HRESETn    : in  std_logic;
    HTRANS     : in  std_logic_vector(1 downto 0);
    HBURST     : in  std_logic_vector(2 downto 0);
    HREADY     : in  std_logic;
    HRESP      : in  std_logic_vector(1 downto 0);

    HBUSREQarm : in  std_logic; -- Master bus request inputs
    HBUSREQtic : in  std_logic;
    HBUSREQ003 : in  std_logic;
    HBUSREQ004 : in  std_logic;

    HLOCKarm   : in  std_logic; -- Master bus lock request inputs
    HLOCKtic   : in  std_logic;
    HLOCK003   : in  std_logic;
    HLOCK004   : in  std_logic;

    HSPLIT     : in  std_logic_vector(15 downto 0);
                                -- Slave split inputs

    Pause      : in  std_logic; -- Pause mode entered

    HGRANTarm  : out std_logic; -- Master bus grant outputs
    HGRANTtic  : out std_logic;
    HGRANT003  : out std_logic;
    HGRANT004  : out std_logic;

    HMASTER    : out std_logic_vector(3 downto 0);
                                -- Current bus master
    HMASTLOCK  : out std_logic  -- Indicates locked sequence
                                -- of transfers
    );
end Arbiter;

architecture synth of Arbiter is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- HTRANS transfer type signal encoding
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

-- HBURST transfer type signal encoding
  constant BUR_SINGLE : std_logic_vector(2 downto 0) := "000";
  constant BUR_INCR   : std_logic_vector(2 downto 0) := "001";
  constant BUR_WRAP4  : std_logic_vector(2 downto 0) := "010";
  constant BUR_INCR4  : std_logic_vector(2 downto 0) := "011";
  constant BUR_WRAP8  : std_logic_vector(2 downto 0) := "100";
  constant BUR_INCR8  : std_logic_vector(2 downto 0) := "101";
  constant BUR_WRAP16 : std_logic_vector(2 downto 0) := "110";
  constant BUR_INCR16 : std_logic_vector(2 downto 0) := "111";

-- HRESP transfer response signal encoding
  constant RSP_OKAY  : std_logic_vector(1 downto 0) := "00";
  constant RSP_ERROR : std_logic_vector(1 downto 0) := "01";
  constant RSP_RETRY : std_logic_vector(1 downto 0) := "10";
  constant RSP_SPLIT : std_logic_vector(1 downto 0) := "11";

-- HMASTER output encoding
  constant MST_DEF : std_logic_vector(3 downto 0) := "0000";
  constant MST_ARM : std_logic_vector(3 downto 0) := "0001";
  constant MST_TIC : std_logic_vector(3 downto 0) := "0010";
  constant MST_003 : std_logic_vector(3 downto 0) := "0011";
  constant MST_004 : std_logic_vector(3 downto 0) := "0100";

-- State encoding of the locked state machine
  constant ST_NORMAL    : std_logic_vector(1 downto 0) := "00";
  constant ST_LOCKED    : std_logic_vector(1 downto 0) := "01";
  constant ST_LAST_LOCK : std_logic_vector(1 downto 0) := "10";
  constant ST_SPLIT     : std_logic_vector(1 downto 0) := "11";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
  signal HmasterDec     : std_logic_vector(15 downto 0);
  -- Decoded HMASTER

  signal HmasterPrevDec : std_logic_vector(15 downto 0);
  -- Decoded HmasterPrev

  signal MaskClear      : std_logic_vector(15 downto 0);
  -- Clears bits of mask

  signal HreqMask       : std_logic_vector(15 downto 0);
  -- Request mask value

  signal HreqMaskReg    : std_logic_vector(15 downto 0);
  -- Registered mask

  signal Hmaskarm       : std_logic;
  -- Masked bus request lines

  signal Hmasktic       : std_logic;
  signal Hmask003       : std_logic;
  signal Hmask004       : std_logic;

  signal HlockComb      : std_logic;
  -- Internal multiplexed version of inputs

  signal HlockRegEn     : std_logic;
  -- HlockReg enable

  signal HlockReg       : std_logic;
  -- Registered version of HlockComb

  signal NextLock       : std_logic_vector(1 downto 0);
  -- Locked state machine

  signal CurrentLock    : std_logic_vector(1 downto 0);
  signal SplitLastNext  : std_logic;
  -- Input to SplitLast register

  signal SplitLast      : std_logic;
  -- Last transfer was a locked split

  signal GrantLock      : std_logic;
  -- Grant outputs are locked

  signal HsplitMask     : std_logic_vector(15 downto 0);
  -- Masked HSPLIT input

  signal SplitEnd       : std_logic;
  -- OR'd HsplitMask value

  signal HgrantarmNew   : std_logic;
  -- New HGRANT values from HBUSREQ inputs

  signal HgrantticNew   : std_logic;
  signal Hgrant003New   : std_logic;
  signal Hgrant004New   : std_logic;

  signal iHMASTLOCK     : std_logic;
  -- Internal version of HMASTLOCK

  signal NextBurst      : std_logic_vector(3 downto 0);
  -- Burst transfer value

  signal BurstEn        : std_logic;
  -- Enable for CurrentBurst register

  signal CurrentBurst   : std_logic_vector(3 downto 0);
  -- Burst transfer reg

  signal HgrantEn       : std_logic;
  -- Select value to drive HGRANTx output

  signal iHGRANTarm     : std_logic;
  -- Internal copies of output grant signals

  signal iHGRANTtic     : std_logic;
  signal iHGRANT003     : std_logic;
  signal iHGRANT004     : std_logic;

  signal HmasterGen     : std_logic_vector(3 downto 0);
  -- Generated master number from iHGRANTx

  signal HmasterPrevEn  : std_logic;
  -- Enable for HmasterPrev register

  signal HmasterPrev    : std_logic_vector(3 downto 0);
  -- Previous value of HMASTER

  signal iHMASTER       : std_logic_vector(3 downto 0);
  -- Internal version of HMASTER

-- ---------------------------------------------------------------------
-- Dec function to decode a master number into a 15 bit mask value
-- ---------------------------------------------------------------------
  function Dec (MasterNum: std_logic_vector(3 downto 0))
    return std_logic_vector is

-- 16 bit output variable returned by function (max 16 AHB masters in
-- system)
  variable Dec : std_logic_vector(15 downto 0);

  begin
    case MasterNum is
      when "0000" => Dec := "0000000000000001";
      when "0001" => Dec := "0000000000000010";
      when "0010" => Dec := "0000000000000100";
      when "0011" => Dec := "0000000000001000";
      when "0100" => Dec := "0000000000010000";
      when "0101" => Dec := "0000000000100000";
      when "0110" => Dec := "0000000001000000";
      when "0111" => Dec := "0000000010000000";
      when "1000" => Dec := "0000000100000000";
      when "1001" => Dec := "0000001000000000";
      when "1010" => Dec := "0000010000000000";
      when "1011" => Dec := "0000100000000000";
      when "1100" => Dec := "0001000000000000";
      when "1101" => Dec := "0010000000000000";
      when "1110" => Dec := "0100000000000000";
      when "1111" => Dec := "1000000000000000";
      when others => Dec := "0000000000000000";
    end case;
    return Dec;
  end Dec;

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- Decoded HMASTER numbers
-- ---------------------------------------------------------------------
-- The 4-bit hex bus master number is decoded into 16 single bit values.
-- The current HMASTER output is used in the HLOCK masking logic.
-- The previous HMASTER output is used in the split grant masking logic.

  HmasterDec     <= Dec(iHMASTER);
  HmasterPrevDec <= Dec(HmasterPrev);

-- ---------------------------------------------------------------------
-- Split grant masking
-- ---------------------------------------------------------------------
-- When a split transfer occurs, the currently granted master must have
-- its input request signal masked out so that it is not granted until
-- the slave responds that the split transfer can continue.
-- When a split transfer completes, the master that was performing the
-- transfer must have its HBUSREQ input unmasked to allow it to be
-- granted again.

-- Mask bits are cleared during a split transfer, using MaskClear.
-- Mask bits are set on completion of a split transfer, using HSPLIT.

  MaskClear <= HmasterPrevDec when (HRESP = RSP_SPLIT and HREADY = '0')
               else (others => '0');

  HreqMask <= (HreqMaskReg and not (MaskClear)) or HSPLIT;

-- Registers are used to hold the number of mask bits needed for all of
-- the masters in the system.
-- Unused mask register bits are optimised out during synthesis.

  p_MaskSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      HreqMaskReg <= (others => '1');
    elsif (HCLK'event and HCLK = '1') then
      HreqMaskReg <= HreqMask;
    end if;
  end process p_MaskSeq;

-- ---------------------------------------------------------------------
-- Masked bus request input generation
-- ---------------------------------------------------------------------
-- The HBUSREQx inputs must be masked according to the split transfers
-- that are taking place before the grant outputs are generated.
-- When a bit of the mask is set LOW, the master will not be granted
-- the bus until the slave ends the split, allowing the bus request
-- signal to be passed to the grant generation logic.
-- The combinational HreqMask values are used to avoid a one cycle
-- delay on the HGRANTx signals due to the delay through the
-- HreqMaskReg registers.

  Hmaskarm <= HreqMask(1) and HBUSREQarm;
  Hmasktic <= HreqMask(2) and HBUSREQtic;
  Hmask003 <= HreqMask(3) and HBUSREQ003;
  Hmask004 <= HreqMask(4) and HBUSREQ004;

-- ---------------------------------------------------------------------
-- HlockInt generation
-- ---------------------------------------------------------------------
-- The HLOCK inputs from the system masters must only be used when that
-- master is driving the address and control signals, so are gated to
-- produce an internal HlockInt signal.

  HlockComb <= '1' when ((HLOCKarm = '1' and HmasterDec(1) = '1') or
                         (HLOCKtic = '1' and HmasterDec(2) = '1') or
                         (HLOCK003 = '1' and HmasterDec(3) = '1') or
                         (HLOCK004 = '1' and HmasterDec(4) = '1'))
               else '0';

-- Register is disabled during a wait state or a locked split transfer.

  HlockRegEn <= '0' when (HREADY = '0' or CurrentLock = ST_SPLIT)
                    else '1';

  p_HlockSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      HlockReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if HlockRegEn = '1' then
        HlockReg <= HlockComb;
      end if;
    end if;
  end process p_HlockSeq;

-- ---------------------------------------------------------------------
-- Locked state machine
-- ---------------------------------------------------------------------
-- This state machine is used to control the operation of the Arbiter
-- during a locked transfer, ensuring that the grant outputs do not
-- change until the last locked transfer has successfully completed.

  p_NextLockComb : process (CurrentLock, HREADY, HlockComb, HlockReg,
                            SplitLast, HRESP, HmasterGen, HmasterPrev)
  begin
    case CurrentLock is

      when ST_NORMAL =>
        if (HREADY = '1' and HlockComb = '1' and HRESP = RSP_OKAY) then
          NextLock <= ST_LOCKED;
        else
          NextLock <= ST_NORMAL;
        end if;

      when ST_LOCKED =>
        if HREADY = '1' then
          if (HlockComb = '1' or (HlockReg = '1' and
              SplitLast = '1')) then
            NextLock <= ST_LOCKED;
          else
            NextLock <= ST_LAST_LOCK;
          end if;
        else
          if HRESP = RSP_SPLIT then
            NextLock <= ST_SPLIT;
          else
            NextLock <= ST_LOCKED;
          end if;
        end if;

      when ST_LAST_LOCK =>
        if HREADY = '1' then
          if (HlockComb = '1' or HRESP = RSP_RETRY) then
            NextLock <= ST_LOCKED;
          else
            NextLock <= ST_NORMAL;
          end if;
        else
          if HRESP = RSP_SPLIT then
            NextLock <= ST_SPLIT;
          else
            NextLock <= ST_LAST_LOCK;
          end if;
        end if;

      when ST_SPLIT =>
        if (HREADY = '1' and HmasterGen = HmasterPrev) then
          NextLock <= ST_LOCKED;
        else
          NextLock <= ST_SPLIT;
        end if;

      when others =>
        NextLock <= ST_NORMAL;

    end case;
  end process p_NextLockComb;

-- Loads the value of NextLock in on each HCLK

  p_CurrentLockSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      CurrentLock <= ST_NORMAL;
    elsif (HCLK'event and HCLK = '1') then
      CurrentLock <= NextLock;
    end if;
  end process p_CurrentLockSeq;

-- Used to detect when the last transfer was a locked split.

  SplitLastNext <= '1' when CurrentLock = ST_SPLIT else '0';

  p_SplitLastSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      SplitLast <= '0';
    elsif (HCLK'event and HCLK = '1') then
      SplitLast <= SplitLastNext;
    end if;
  end process p_SplitLastSeq;

-- Set HIGH when the next state is a locked transfer.

  GrantLock <= '1' when (NextLock = ST_LOCKED or NextLock = ST_SPLIT)
               else '0';

-- ---------------------------------------------------------------------
-- End of Split transfer detection
-- ---------------------------------------------------------------------
-- The end of the current locked split transfer must be detected before
-- the transfer may continue.
-- This is done by using the bus master number of the locked master as
-- a mask on the slave split input. The output of this is then OR'd
-- together, and the result is used to determine if the split transfer
-- can continue.

  HsplitMask <= HmasterPrevDec and HSPLIT;

  SplitEnd <= ((HsplitMask(15) or HsplitMask(14) or HsplitMask(13) or
                HsplitMask(12) or HsplitMask(11) or HsplitMask(10) or
                HsplitMask(9)  or HsplitMask(8)  or HsplitMask(7)  or
                HsplitMask(6)  or HsplitMask(5)  or HsplitMask(4)  or
                HsplitMask(3)  or HsplitMask(2)  or HsplitMask(1)  or
                HsplitMask(0)) and GrantLock);

-- ---------------------------------------------------------------------
-- Arbitration Scheme
-- ---------------------------------------------------------------------
-- This section contains the arbitration priority algorithm, and should
-- be changed if a different arbitration scheme is required.

-- The default scheme is:
--  Default master granted during locked split transfers, when no masked
--  HBUSREQ inputs are set, and during pause mode.
--  Previous grant outputs used at the end of a locked split transfer,
--  or if the last locked transfer receives a retry response.
--  Core granted by default if it is not masked by an uncompleted
--  split and no other masters are requesting the bus.
--  All others granted when masked HBUSREQ set, in order of priority.

  p_HgrantNewComb : process (GrantLock, HRESP, SplitEnd, CurrentLock,
                             HmasterPrevDec, Hmasktic, Pause, Hmask003,
                             Hmask004, Hmaskarm, HreqMask)
  begin
    if (GrantLock = '1' and HRESP = RSP_SPLIT) then
      HgrantarmNew <= '0';       -- Default selected during locked split
      HgrantticNew <= '0';
      Hgrant003New <= '0';
      Hgrant004New <= '0';
    elsif (SplitEnd = '1' or     -- Regrant previous
           (CurrentLock = ST_LAST_LOCK and HRESP = RSP_RETRY)) then
      HgrantarmNew <= HmasterPrevDec(1);
      HgrantticNew <= HmasterPrevDec(2);
      Hgrant003New <= HmasterPrevDec(3);
      Hgrant004New <= HmasterPrevDec(4);
    elsif Pause = '1' then       -- Pause mode
      HgrantarmNew <= '0';
      HgrantticNew <= '0';
      Hgrant003New <= '0';
      Hgrant004New <= '0';
    elsif Hmasktic = '1' then    -- TIC (highest priority)
      HgrantarmNew <= '0';
      HgrantticNew <= '1';
      Hgrant003New <= '0';
      Hgrant004New <= '0';
    elsif Hmask003 = '1' then    -- Bus master #003
      HgrantarmNew <= '0';
      HgrantticNew <= '0';
      Hgrant003New <= '1';
      Hgrant004New <= '0';
    elsif Hmask004 = '1' then    -- Bus master #004
      HgrantarmNew <= '0';
      HgrantticNew <= '0';
      Hgrant003New <= '0';
      Hgrant004New <= '1';
    elsif Hmaskarm = '1' then    -- ARM Core Wrapper (lowest priority)
      HgrantarmNew <= '1';
      HgrantticNew <= '0';
      Hgrant003New <= '0';
      Hgrant004New <= '0';
    elsif HreqMask(1) = '1' then -- Core granted by default if it is
                                 -- not masked
      HgrantarmNew <= '1';       --  by a split.
      HgrantticNew <= '0';
      Hgrant003New <= '0';
      Hgrant004New <= '0';
    else                         -- Default bus master
      HgrantarmNew <= '0';
      HgrantticNew <= '0';
      Hgrant003New <= '0';
      Hgrant004New <= '0';
    end if;
  end process p_HgrantNewComb;

-- ---------------------------------------------------------------------
-- Burst transfer detection and grant holding
-- ---------------------------------------------------------------------
-- During a fixed length burst transfer a master may de-assert its
-- grant request output, but the arbiter will not change the currently
-- selected master until the penultimate transfer of the burst.
-- If the burst is terminated early due to a split/retry transfer or
-- the master ending the burst, then the grant outputs will change as
-- normal.
--
-- Set to 0000 when a split/retry response is received, or if the
-- master ends the current burst transfer.
-- Set to the burst size minus one when a new burst is started.
-- Held at 0000 when no burst transfers are being performed.
-- The counter value is decremented during the burst transfer.

  NextBurst <= "0000" when (HRESP = RSP_SPLIT or HRESP = RSP_RETRY or
                            HTRANS = TRN_IDLE or
                            (HBURST = BUR_SINGLE or HBURST = BUR_INCR))
                      else
               "1111" when ((HBURST = BUR_INCR16 or
                             HBURST = BUR_WRAP16) and
                            HTRANS = TRN_NONSEQ)
                      else
               "0111" when ((HBURST = BUR_INCR8 or
                             HBURST = BUR_WRAP8) and
                            HTRANS = TRN_NONSEQ)
                      else
               "0011" when ((HBURST = BUR_INCR4 or
                             HBURST = BUR_WRAP4) and
                            HTRANS = TRN_NONSEQ)
                      else
               "0000" when CurrentBurst = "0000"
                      else
               CurrentBurst - '1';

-- Counter register is only enabled during a valid unwaited burst
-- transfer.
  BurstEn <= '1' when (HREADY = '1' and
                       (HTRANS = TRN_SEQ or HTRANS = TRN_NONSEQ))
             else '0';

  p_BurstSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      CurrentBurst <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if BurstEn = '1' then
        CurrentBurst <= NextBurst;
      end if;
    end if;
  end process p_BurstSeq;

-- ---------------------------------------------------------------------
-- HGRANT output selection control
-- ---------------------------------------------------------------------
-- The HgrantEn signal is used to select between loading the output
-- registers with the new HGRANTx values, or to hold the current value.
-- Set HIGH when not performing a locked transfer, and during the last
-- two transfers of a fixed length burst, allowing the grant outputs to
-- change during the very last transfer of a fixed length burst.
-- Also set HIGH during a locked split transfer, to select the default
-- master.
-- Set LOW at all other times, during a locked transfer and during the
-- first N-1 transfers of a fixed length burst of N transfers.

  HgrantEn <= '1' when ((NextBurst = "0001" or NextBurst = "0000") and
                        ((GrantLock = '1' and HRESP = RSP_SPLIT) or
                         GrantLock = '0' or SplitEnd = '1'))
              else '0';

-- ---------------------------------------------------------------------
-- HGRANT output registers
-- ---------------------------------------------------------------------
-- Stores the currently selected bus master HGRANTx output. The output
-- is held during a locked or fixed length burst transfer.
-- The ARM Core Wrapper is granted control of the bus during reset,
-- ensuring that it has immediate access to the bus if required.

  p_HGRANTSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      iHGRANTarm <= '1';  -- Core granted during reset
      iHGRANTtic <= '0';
      iHGRANT003 <= '0';
      iHGRANT004 <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if HgrantEn = '1' then
        iHGRANTarm <= HgrantarmNew;
        iHGRANTtic <= HgrantticNew;
        iHGRANT003 <= Hgrant003New;
        iHGRANT004 <= Hgrant004New;
      end if;
    end if;
  end process p_HGRANTSeq;

-- ---------------------------------------------------------------------
-- HMASTER output generation and registers
-- ---------------------------------------------------------------------
-- Generates the HMASTER number from the current grant output signals,
-- and then stores it in a register to generate the correct HMASTER
-- output timing, so that it is valid when the master is driving the
-- address and control lines.

  HmasterGen <= MST_ARM when iHGRANTarm = '1' else -- Master 1 = ARM
                MST_TIC when iHGRANTtic = '1' else -- Master 2 = TIC
                MST_003 when iHGRANT003 = '1' else -- Master 3 = 003
                MST_004 when iHGRANT004 = '1' else -- Master 4 = 004
                MST_DEF;                           -- Master 0 = Default

  p_iHMASTERSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      iHMASTER <= MST_DEF;
    elsif (HCLK'event and HCLK = '1') then
      if HREADY = '1' then
        iHMASTER <= HmasterGen;
      end if;
    end if;
  end process p_iHMASTERSeq;

-- The enable is used to ensure that the currently stored bus master
-- number does not change when the previous transfer is waited or was a
-- locked transfer.

  HmasterPrevEn <= '1' when (HREADY = '1' and
                             (CurrentLock = ST_NORMAL or
                              CurrentLock = ST_LAST_LOCK))
                   else '0';

-- Used to clear bits in the grant mask when a split response is
-- detected, and contains the number of the master that is currently
-- driving/reading the data buses. Also used in the locked state
-- machine to check for ended split transfers.

  p_HmasterPrevSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      HmasterPrev <= "0000";
    elsif (HCLK'event and HCLK = '1') then
      if HmasterPrevEn = '1' then
        HmasterPrev <= iHMASTER;
      end if;
    end if;
  end process p_HmasterPrevSeq;

-- ---------------------------------------------------------------------
-- HMASTLOCK output
-- ---------------------------------------------------------------------
-- The HMASTLOCK output is valid during the address phase of the locked
-- transfers, and is based on the locked state machine.

  iHMASTLOCK <= '1' when CurrentLock = ST_LOCKED else '0';

-- ---------------------------------------------------------------------
-- Output drivers
-- ---------------------------------------------------------------------
-- Drive the grant outputs with the internal versions.
  HGRANTarm <= iHGRANTarm;
  HGRANTtic <= iHGRANTtic;
  HGRANT003 <= iHGRANT003;
  HGRANT004 <= iHGRANT004;

-- Drive the output ports with the internal versions of the signals.
  HMASTER   <= iHMASTER;
  HMASTLOCK <= iHMASTLOCK;

end synth;

-- --============================== End ==============================--
