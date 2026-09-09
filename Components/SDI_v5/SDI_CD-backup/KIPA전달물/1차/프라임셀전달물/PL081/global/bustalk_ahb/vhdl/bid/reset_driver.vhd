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
-- File Name              : reset_driver.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Drives AHB Reset signal 
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library common;
use     common.defs.all;
use     common.funcs.all;

-- ---------------------------------------------------------------------
entity Resetdriver is
  generic(
          Verbosity : boolean;
          Tclkh     : time;
          Tclkl     : time;
          Tisrst    : time;
          Tihrst    : time;
          Resetdel  : time
         );
  port(
       Ressel    : in T_cycle;    -- Denotes Reset cycle
       HCLK      : in std_logic;  -- AHB Clock
       Respacket : in T_res;      -- Packet containing info. about
                                  -- driving reset
       HRESETn   : out std_logic  -- AHB Reset
       );
end Resetdriver;
-- ---------------------------------------------------------------------
--
--                             ResetDriver
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview : 
-- ==========
--  To drive HRESETn line low on the correct phase and hold it low for
--  defined time.  It gets the phase info in the first delay high phase
--  and uses it in the last delay cycle to start timing the reset length
--
--  To drive the HRESETn line driver with rdrv timing (idle,delay,reset)
--  This is a vr type cycle but onto an AHB line, so I owns its own
--  block as a compromise.  The timing of the rdrv signal is shown below
--  for one delay, high phase drive, one reset cycle
--     _   _   _   _
--  __/ \_/ \_/ \_/ \__  CLK
--  __<S>______________  RESSEL
--  __<DDDDDXRRR>______  STATE
--
--  There are two counters instanced herein, one for delay and the other
--  for numcyc
 
-- --========================= ARCHITECTURE ==========================--
 
architecture behavioural of Resetdriver is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
component Countdown
  port(
       HCLK      : in std_logic;
       Val       : in T_int;
       Last      : out T_int;
       Rscyc     : in std_logic
       );
end component;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal Valdelay  : T_int := 0;       -- Value loaded for inserting
                                     -- delay
signal Valreset  : T_int := 0;       -- Value loaded for asserting reset
signal Lastdelay : T_int := 0;       -- Denotes last cycle of delay
signal Lastreset : T_int := 0;       -- Denotes last cycle of reset
signal Rstate    : T_reset := Ridle; -- Reset State machine
signal Rscyc     : std_logic := '0'; -- Retry/Split cycle
signal iHRESETn  : std_logic := '1'; -- Internal Reset signal

-- ---------------------------------------------------------------------
-- Main body of code
-- =================
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Assigning local copy to output 
-- ---------------------------------------------------------------------
  HRESETn <= iHRESETn; 
-- ---------------------------------------------------------------------
-- This process loads the counters with the timing values.  Note that
-- the delay counter is loaded with an incremented value because
-- a delay of 0 is equivalent to a cycle of 1 etc.
-- ---------------------------------------------------------------------
p_loader : process (Ressel,Lastdelay,Rstate)
  variable iNumcyc : T_int;
begin 
  if (Ressel = Cres and Rstate = Rdel and Lastdelay = 0) then
    Valdelay <= Respacket.delay + 1;
    iNumcyc := Respacket.numcyc;
  elsif (Rstate = Rres) and (Lastdelay = 1) then
    Valreset <= iNumcyc;
  else
    Valreset <= 0;
    Valdelay <= 0;
  end if;
end process p_loader;

-- ---------------------------------------------------------------------
-- This process changes the state (example shown at top of file) with
-- info. from the timers.
-- ---------------------------------------------------------------------
p_timing : process (Ressel,Lastreset,Lastdelay,Rstate)
begin
  if (Ressel = Cres) and (Rstate = Ridle) then
    Rstate <= Rdel;
  elsif (Rstate = Rdel) and 
    (Lastdelay'event and Lastdelay = 1) then
    Rstate <= Rres;
  elsif (Rstate = Rres) and (Lastreset'event and Lastreset = 1) then
    Rstate <= Ridle;
  end if;
end process p_timing;

-- ---------------------------------------------------------------------
-- Reset State machine
-- ---------------------------------------------------------------------
p_linedriver : process (Rstate, HCLK, iHRESETn)
  variable Iphase : T_line; -- holds which phase of HCLK reset is
                            -- driven low
begin
  if Rstate'event and (Rstate = Rdel) then
    Iphase   := Respacket.phase; -- on entering delay state, store
                                 -- phase info. 
  elsif (Rstate = Rres) and ((HCLK = Iphase) or (iHRESETn = '0')) then
    iHRESETn <= '0' after Resetdel; -- if in the correct phase drive
                                    -- reset low
--  elsif (iHRESETn = '0') then
--    iHRESETn <= 'X' after (tihrst); -- else drive it high
  else
    iHRESETn <= '1' after (Tclkh + Tclkl - Tisrst);
  end if;
end process p_linedriver;

-- ---------------------------------------------------------------------
--  The following process prints out status change information of the
-- reset signal at the time it occurs
-- ---------------------------------------------------------------------
p_reportres : process (iHRESETn)
begin
    if Verbosity then
      ReportReset(iHRESETn);
    end if;
end process p_reportres;
   
ucountdowndelay : countdown
  port map(
           HCLK       => HCLK,
           Val        => Valdelay,
           Last       => Lastdelay,
           Rscyc      => Rscyc
           );

ucountdownreset : countdown
  port map(
           HCLK       => HCLK,
           Val        => Valreset,
           Last       => Lastreset,
           Rscyc      => Rscyc
           );

end behavioural;

-- --============================== End ==============================--
