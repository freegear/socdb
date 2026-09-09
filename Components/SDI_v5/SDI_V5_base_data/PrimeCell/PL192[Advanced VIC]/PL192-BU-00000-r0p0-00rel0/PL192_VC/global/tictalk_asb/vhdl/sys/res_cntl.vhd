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
-- File Name              : res_cntl.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose : Reset State Machine
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

--#synth off
library common ;
use     common.params.all;
--#synth on

entity res_cntl is
  port(
       BCLK     : in    std_ulogic;      -- ASB system clock

       POReset   : in    std_ulogic;     -- Power on reset signal

       BnRES     : out   std_ulogic      -- ASB reset status
       );
end res_cntl;

architecture behavioural of res_cntl is

  -- state definitions
  constant POR : std_ulogic_vector(1 downto 0) := "00";-- Power on reset
  constant INI : std_ulogic_vector(1 downto 0) := "10";-- Initialisation
  constant RUN : std_ulogic_vector(1 downto 0) := "11";-- Normal system 
                                                       -- operation

  signal state       : std_ulogic_vector(1 downto 0);  -- Reset state 
                                                       -- machine
  signal rescount    : std_ulogic;   -- Used to hold controller in the 
                                     -- RES state for 2 cycles

begin
  
  statemachine : process (POReset, BCLK)
  begin
    if POReset = '1' then
--  Asynchronous Reset
      rescount <= '0' after DLPG;
      state <= POR after DLPG;
    elsif (BCLK'event and BCLK = '0') then
      case state is

        when POR =>
          rescount <= '0' after DLPG;
          state <= INI after DLPG;
--  If a clock OK signal is used at start-up, to indicate when the clock
--  is stable, then this signal should be used as a qualifier to 
--  determine when the POR state is exited, for example,
--  "if (ClockOK = '1') then state <= INI else state <= POR;"

        when INI =>
--  Remains in INI state for 2 clock cycles, this may be increased to 
--  meet particular system requirements.
          if (rescount = '0') then
            rescount <= '1' after DLPG;
            state    <= INI after DLPG;
          else
            rescount <= '0' after DLPG;
            state    <= RUN after DLPG;
          end if;

        when RUN =>
          rescount <= '0';
          state <= RUN after DLPG;

        when others =>
          rescount <= '0' after DLPG;
          state    <= POR after DLPG;
      end case;
    end if;
  end process statemachine;

  -- assign outputs
  BnRES <= state(0);

end behavioural;

-- --============================== End ==============================--
