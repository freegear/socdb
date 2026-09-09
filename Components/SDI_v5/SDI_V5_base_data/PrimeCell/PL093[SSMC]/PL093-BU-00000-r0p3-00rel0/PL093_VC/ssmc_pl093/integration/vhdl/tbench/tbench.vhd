-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : tbench.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test bench to test the EASY microcontroller through
--           the TIC interface.
--
-- --=========================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library chip;
use     chip.all;

library tbench;
use     tbench.all;

entity tbench is
end tbench;
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of tbench is

-- -----------------------------------------------------------------------------
-- The Example Amba System (EASY)
-- -----------------------------------------------------------------------------
component EASY
    port (
          XCLKIN         : in    std_logic; -- External clock in
          nReset         : in    std_logic; -- Power on reset input
          XD             : inout std_logic_vector(31 downto 0);
                                            -- External data bus
          XA             : out   std_logic_vector(30 downto 0);
                                            -- External address bus
          XCSN           : out   std_logic_vector(3 downto 0);
                                            -- External chip select
          XOEN           : out   std_logic; -- External output enable
          XWEN           : out   std_logic_vector(3 downto 0);
                                            -- External write enable

          TESTREQA       : in    std_logic; -- Test bus request A
          TESTREQB       : in    std_logic; -- Test bus request B
          TESTACK        : out   std_logic; -- Test acknowledge
 
          nTRST          : in    std_logic; -- JTAG connections
          TCK            : in    std_logic;
          TDI            : in    std_logic;
          TMS            : in    std_logic;
          TDO            : out   std_logic
         );
end component;

-- -----------------------------------------------------------------------------
-- Test interface driver
-- The input filename, HaltOnMismatch and Verbosity settings should be
-- changed in the generic map section.
-- -----------------------------------------------------------------------------
component ticbox
  generic (
           FileName       : string;
           HaltOnMismatch : boolean;
           Verbosity      : boolean
          );
  port (
        nReset           : in    std_logic; -- System reset
        TESTCLK          : in    std_logic; -- Test mode clock input
        TESTACK          : in    std_logic; -- Test acknowledge
        TESTBUS          : inout std_logic_vector(31 downto 0);
                                            -- Bidirectional test port
        TESTREQA         : out   std_logic := '0';
                                            -- Test bus request A
        TESTREQB         : out   std_logic := '0'
                                            -- Test bus request B
       );
  end component;

-- -----------------------------------------------------------------------------
-- Constant and signal declarations
-- -----------------------------------------------------------------------------

constant PERIOD : time := 100 ns; -- 10.0 MHz

constant PHASETIME : time := PERIOD / 2;

--  External Signals
signal XCLKIN           : std_logic;
signal nReset           : std_logic;
signal XD               : std_logic_vector(31 downto 0);
signal XA               : std_logic_vector(30 downto 0);
signal XCSN             : std_logic_vector(3 downto 0);
signal XOEN             : std_logic;
signal XWEN             : std_logic_vector(3 downto 0);

-- TIC interface
signal TESTREQA         : std_logic;
signal TESTREQB         : std_logic;
signal TESTACK          : std_logic;
signal TESTCLK          : std_logic;

-- JTAG connections
signal nTRST            : std_logic;
signal TCK              : std_logic;
signal TDI              : std_logic;
signal TMS              : std_logic;
signal TDO              : std_logic;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- The Example Amba System (EASY) Instantiation
-- -----------------------------------------------------------------------------
u_easy : EASY
  port map (
            XCLKIN           => XCLKIN,
            nReset           => nReset,
            XD               => XD,
            XA               => XA,
            XCSN             => XCSN,
            XOEN             => XOEN,
            XWEN             => XWEN,

            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB,
            TESTACK          => TESTACK,

            nTRST            => nTRST,
            TCK              => TCK,
            TDI              => TDI,
            TMS              => TMS,
            TDO              => TDO
           );

-- -----------------------------------------------------------------------------
-- Default input filename, HaltOnMismatch and Verbosity settings, the
-- same as the initial values in the Ticbox module.
-- -----------------------------------------------------------------------------
uTicbox : Ticbox
  generic map (
               FileName       => "../../bustest/invec/infile.tif",
               HaltOnMismatch => FALSE,
               Verbosity      => FALSE
              )
  port map (
            nReset           => nReset,
            TESTCLK          => TESTCLK,
            TESTACK          => TESTACK,
            TESTBUS          => XD,
            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB
           );

TESTCLK          <= XCLKIN;

nTRST            <= not nReset; -- JTAG connections
TDI              <= '0';
TMS              <= '0';

-- -----------------------------------------------------------------------------
-- This controls the clock generation for the system.
-- -----------------------------------------------------------------------------
p_ClockGenComb : process
begin
  XCLKIN <= '0';
  wait for PHASETIME;
  XCLKIN <= '1';
  wait for PHASETIME;
end process p_ClockGenComb;

-- -----------------------------------------------------------------------------
-- This controls the JTAG test clock generation for the system.
-- A 5 MHz test clock is generated.
-- -----------------------------------------------------------------------------
p_TestClockGenComb : process
begin
  TCK <= '0';
  wait for 100 ns;
  TCK <= '1';
  wait for 100 ns;
end process p_TestClockGenComb;

-- -----------------------------------------------------------------------------
-- This controls the timing of the nReset signal.
-- The loop values should be changed for different reset timing.
-- -----------------------------------------------------------------------------
p_StimulusComb : process
begin
  nReset <= '0';
  for i in 1 to 20 loop
    wait on XCLKIN;
  end loop;
  nReset <= '1' after 1 ns; -- Hold time for ResCntl SyncPOR register

-- Wait until the TIC signals that test mode has been entered.
    wait until (XCLKIN'event and XCLKIN = '1' and TESTACK = '1');

-- End simulation when the Ticbox and TIC indicate that testing has
-- finished.
  wait until (XCLKIN'event and XCLKIN = '1' and
              TESTREQA = '0' and TESTREQB = '0' and TESTACK = '0');
  assert false report "Test sequence completed" severity failure;
end process p_StimulusComb;

end behavioural;

-- --================================== End ==================================--
