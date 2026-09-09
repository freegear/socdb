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
-- File Name              : ResCntl.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Reset state machine
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;


entity ResCntl is
  port(
    HCLK    : in  std_logic;
    POReset : in  std_logic; -- Power on reset input
    HRESETn : out std_logic
    );
end ResCntl;

architecture synth of ResCntl is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- State definitions - avoids any chance of glitches on HRESETn
-- The two INI states are used to insert a delay of three cycles
-- between the de-assertion of POReset and the de-assertion of HRESETn.
-- If additional cycles are required then extra INI states may be
-- added, ensuring that the encoding is such that HRESETn is dependant
-- on only one bit of the state machine.

  constant ST_POR     : std_logic_vector(2 downto 0) := "000";
  constant ST_INI1    : std_logic_vector(2 downto 0) := "010";
  constant ST_INI2    : std_logic_vector(2 downto 0) := "100";
  constant ST_RUN     : std_logic_vector(2 downto 0) := "001";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
  signal SyncPOR      : std_logic; -- Synchronised POReset signal
  signal NextState    : std_logic_vector(2 downto 0); -- State machine
  signal CurrentState : std_logic_vector(2 downto 0);

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- Asynchronous reset input synchronisation
-- ---------------------------------------------------------------------
-- Synchronises POReset input to system clock

  p_SynchPORSeq : process (HCLK)
  begin
    if (HCLK'event and HCLK = '1') then
      SyncPOR <= POReset;
    end if;
  end process p_SynchPORSeq;

-- ---------------------------------------------------------------------
-- Next state logic for reset controller state machine
-- ---------------------------------------------------------------------
-- If a clock OK signal is used at start-up to indicate when the clock
--  is stable, then this signal should be used as a qualifier to
--  determine when the POR state is exited, for example,
--  "if (ClockOK = '1') then state <= INI else state <= POR;"

  p_NextStateComb : process (SyncPOR, CurrentState)
  begin
    if SyncPOR = '0' then
      NextState     <= ST_POR;
    else
      case CurrentState is

        when ST_POR =>           -- POReset input set
          NextState <= ST_INI1;

        when ST_INI1 =>          -- First wait state
          NextState <= ST_INI2;

        when ST_INI2 =>          -- Second wait state
          NextState <= ST_RUN;

        when ST_RUN =>           -- HRESETn output set
          NextState <= ST_RUN;

        when others =>
          NextState <= ST_POR;

      end case;
    end if;
  end process p_NextStateComb;

-- ---------------------------------------------------------------------
-- State machine
-- ---------------------------------------------------------------------
-- No reset term as NextState is reset to ST_POR
-- Changes state on rising edge of HCLK

  p_CurrentStateSeq : process (HCLK)
  begin
    if (HCLK'event and HCLK = '1') then
      CurrentState <= NextState;
    end if;
  end process p_CurrentStateSeq;

-- ---------------------------------------------------------------------
-- Output driver
-- ---------------------------------------------------------------------
-- HRESETn is driven with bit 0 of CurrentState (only set high during
-- ST_RUN), and the inverse of the active HIGH POReset input, allowing
-- HRESETn to be set as soon as POReset is set HIGH.

-- Delay added to prevent netlist simulation errors
  HRESETn <= (CurrentState(0) and POReset) after 2 ns;

end synth;

-- --============================== End ==============================--
