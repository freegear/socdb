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
-- File Name              : DmacTrCounter.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file describes a generic down counter
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity DmacTrCounter is
  generic (
           CounterWidth     : integer := 8
          );
  port (
-- Inputs
        HCLK             : in std_logic;  -- AHB Clock
        HRESETn          : in std_logic;  -- AHB Reset
        CountIn          : in std_logic_vector((CounterWidth -1) downto 0);
                                           -- Count Value
        Load             : in std_logic;  -- To load count value
        Enable           : in std_logic;  -- Counter Enable
        Reset            : in std_logic;  -- Counter Reset
-- Output
        TerminalCount    : out std_logic  -- Terminal Count output
       );
end DmacTrCounter;

-- -----------------------------------------------------------------------------
--
--                            DmacTrCounter
--                            =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--        This file contains a generic module of a down counter. The counter
--  loads count when Load signal is asserted. It starts decrementing when enable
--  is kept asserted. It generates terminal count signal when counter reaches
--  zero.
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of DmacTrCounter is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal Count             : std_logic_vector((CounterWidth - 1)downto 0)
                                                    := (others => '0');
signal StartCount        : std_logic;
-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
--  Down Counter
-- -----------------------------------------------------------------------------
p_CountSeq  : process (HCLK, HRESETn)
variable ZER0  : std_logic_vector((CounterWidth -1) downto 0) := (others =>'0');
begin
  if (HRESETn = '0') then
    TerminalCount     <= '0';
    Count             <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (Reset = '1') then
      TerminalCount         <= '0';
      StartCount            <= '0';
    else
      if (Load = '1' and CountIn > ZER0) then
        Count             <= CountIn;
        StartCount        <= '1';
      end if;
      if (Enable = '1') then
        if (StartCount = '1') then
          if (Count > ZER0)then
            Count             <= unsigned (Count) - 1;
            TerminalCount     <= '0';
          else
            TerminalCount     <= '1';
          end if;
        end if;
      else
        TerminalCount         <= '0';
        StartCount            <= '0';
      end if;
    end if;
  end if;
end process p_CountSeq;

-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

end behavioural;

-- --================================= End ===================================--
