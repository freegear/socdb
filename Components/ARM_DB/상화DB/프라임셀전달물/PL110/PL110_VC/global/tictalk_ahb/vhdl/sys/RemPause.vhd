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
-- File Name              : RemPause.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v6
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Remap and Pause controller module for APB.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

entity RemPause is
  port(
    PCLK    : in  std_logic;
    PRESETn : in  std_logic;
    PENABLE : in  std_logic;
    PSELRPC : in  std_logic;
    PADDR   : in  std_logic_vector(5 downto 2);
    PWRITE  : in  std_logic;
    PWDATA  : in  std_logic_vector(7 downto 0);
    PRDATA  : out std_logic_vector(7 downto 0);

    nFIQ    : in  std_logic; -- FIQ interrupt input
    nIRQ    : in  std_logic; -- IRQ interrupt input
    Pause   : out std_logic; -- Pause mode entered
    Remap   : out std_logic  -- Reset memory map in use
    );
end RemPause;

architecture synth of RemPause is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- Identification is the value read from the Identification register
-- address.
-- Unused bits should be set LOW.

  constant IDENTIFICATION    : std_logic_vector(7 downto 0)
                                                       := "0000"&"0000";

  constant PAUSEA            : std_logic_vector(5 downto 0) := "000000";
  constant IDENTIFICATIONA   : std_logic_vector(5 downto 0) := "010000";
  constant CLEARRESETMAPA    : std_logic_vector(5 downto 0) := "100000";
  constant RESETSTATUSA      : std_logic_vector(5 downto 0) := "110000";
  constant RESETSTATUSSETA   : std_logic_vector(5 downto 0) := "110000";
  constant RESETSTATUSCLEARA : std_logic_vector(5 downto 0) := "110100";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
-- If the above addresses are altered then the sections of code that
-- assign Addr and ResetStatus may also have to be changed.

  signal Addr            : std_logic_vector(5 downto 0);
                                      -- Altered copy of PADDR
  signal ResetStatusEn   : std_logic; -- Reset Status write enable
  signal ResetStatusNext : std_logic_vector(7 downto 0);
                                      -- ResetStatus register input
  signal ResetStatus     : std_logic_vector(7 downto 0);
                                      -- Reset Status register
  signal PauseEn         : std_logic; -- Pause write enable
  signal PauseRes        : std_logic; -- Reset term for Pause register
  signal RemapEn         : std_logic; -- Remap write enable
  signal PrdataNext      : std_logic_vector(7 downto 0);
                                      -- Internal PRDATA
  signal PrdataNextEn    : std_logic; -- PrdataNext enable
  signal iPRDATA         : std_logic_vector(7 downto 0);
                                      -- Registered PrdataNext

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- General signals
-- ---------------------------------------------------------------------
-- Addr is used as alternative to PADDR - unused address bits are set
-- LOW to simplify synthesised address checking logic.
-- May have to be changed if address map of interrupt controller
-- internal registers is changed.

  Addr <= PADDR(5 downto 4) & '0' & PADDR(2) & "00";

-- ---------------------------------------------------------------------
-- ResetStatus register
-- ---------------------------------------------------------------------
-- Mux and registers are enabled when the set or clear addresses are
-- written to.

  ResetStatusEn <= '1' when (PSELRPC = '1' and PWRITE = '1' and
                             PENABLE = '0' and
                             (Addr = RESETSTATUSSETA or
                             Addr = RESETSTATUSCLEARA))
                       else '0';

-- Bit zero of the ResetStatus register is set HIGH on reset, LOW when
-- cleared. It cannot be set HIGH by software.
-- All other bits of the ResetStatus register may be set and cleared
-- through the two address locations.

  p_ResetStatusComb : process (ResetStatusEn, Addr, ResetStatus, PWDATA)
  begin
    if ResetStatusEn = '1' then
      case Addr is

        when RESETSTATUSSETA =>
          ResetStatusNext(0)          <= ResetStatus(0);
          ResetStatusNext(7 downto 1) <= PWDATA(7 downto 1) or
                                         ResetStatus(7 downto 1);

        when others => -- If enabled and not set, must be clear address
          ResetStatusNext <= ((not PWDATA) and ResetStatus);

      end case;
    else
      ResetStatusNext <= (others => '0');
    end if;
  end process p_ResetStatusComb;

-- On reset, bit 0 is set HIGH, indicating power on reset condition.

  p_ResetStatusSeq : process (PRESETn, PCLK)
  begin
    if (PRESETn = '0') then
      ResetStatus <= "0000"&"0001";
    elsif (PCLK'event and PCLK = '1') then
      if (ResetStatusEn = '1') then
        ResetStatus <= ResetStatusNext;
      end if;
    end if;
  end process p_ResetStatusSeq;

-- ---------------------------------------------------------------------
-- Pause output register
-- ---------------------------------------------------------------------
-- The Pause output causes the system to enter a "wait for interrupt"
-- state. Set LOW on reset or interrupt, set HIGH on write.

-- Asynchronous nIRQ and nFIQ inputs are needed so that system can
-- function asynchronously when in low power mode.

  PauseEn <= '1' when (PSELRPC = '1' and PWRITE = '1' and PENABLE = '0'
                       and Addr = PAUSEA)
              else '0';

  PauseRes <= PRESETn and nIRQ and nFIQ; -- Combined to give single
                                         -- reset term

  p_PauseSeq : process (PauseRes, PCLK)
  begin
    if (PauseRes = '0') then
       Pause <= '0';
    elsif (PCLK'event and PCLK = '1') then
       if (PauseEn = '1') then
         Pause <= '1';
      end if;
    end if;
  end process p_PauseSeq;

-- ---------------------------------------------------------------------
-- Remap output register
-- ---------------------------------------------------------------------
-- The Remap output selects the memory map to be used by the system.
-- Set LOW on reset (reset memory map), HIGH on write (normal memory
-- map).
-- Once set HIGH, can only be set LOW with reset.

  RemapEn <= '1' when (PSELRPC = '1' and PWRITE = '1' and PENABLE = '0'
                       and Addr = CLEARRESETMAPA)
             else '0';


  p_RemapSeq : process (PRESETn, PCLK)
  begin
    if (PRESETn = '0') then
      Remap <= '0';
    elsif (PCLK'event and PCLK = '1') then
      if (RemapEn = '1') then
        Remap <= '1';
      end if;
    end if;
  end process p_RemapSeq;

-- ---------------------------------------------------------------------
-- Output data generation
-- ---------------------------------------------------------------------
-- Address decoding for register reads.

  PrdataNextEn <= PSELRPC and (not PWRITE) and (not PENABLE);

  p_PrdataNextComb : process (PrdataNextEn, Addr, ResetStatus, iPRDATA)
  begin
    PrdataNext <= (others => '0');
    if PrdataNextEn = '1' then
      case Addr is
        when IDENTIFICATIONA =>
          PrdataNext <= IDENTIFICATION;
        when RESETSTATUSA =>
          PrdataNext <= ResetStatus;
        when others =>
          PrdataNext <= (others => '0');
      end case;
    else
      PrdataNext <= iPRDATA;
    end if;
  end process p_PrdataNextComb;

-- Register used to reduce output delay during reads.

  p_iPRDATASeq : process (PRESETn, PCLK)
  begin
    if PRESETn = '0' then
      iPRDATA <= (others => '0');
    elsif (PCLK'event and PCLK = '1') then
      iPRDATA <= PrdataNext;
    end if;
  end process p_iPRDATASeq;

-- Drive output with internal version.

  PRDATA <= iPRDATA;


end synth;

-- --============================== End ==============================--
