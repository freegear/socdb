-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
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
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test bench to test the EASY microcontroller through
--           the TIC interface.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

library chip;
use chip.all;

library trickbox;
use trickbox.all;

library tbench;
use tbench.all;

entity tbench is
end tbench;
-- -----------------------------------------------------------------------------

-- --======================== ARCHITECTURE ===================================--

architecture behavioural of tbench is

-- -----------------------------------------------------------------------------
-- The Example Amba System (EASY)
-- -----------------------------------------------------------------------------
component EASY
    port (
          XCLKIN         : in    std_logic;
          nReset         : in    std_logic;
          XD             : inout std_logic_vector(31 downto 0);
          XA             : out   std_logic_vector(30 downto 0);
          XCSN           : out   std_logic_vector(3 downto 0);
          XOEN           : out   std_logic;
          XWEN           : out   std_logic_vector(3 downto 0);
          TESTREQA       : in    std_logic;
          TESTREQB       : in    std_logic;
          TESTACK        : out   std_logic;
          nTRST          : in    std_logic;
          TCK            : in    std_logic;
          TDI            : in    std_logic;
          TMS            : in    std_logic;
          TDO            : out   std_logic;
          MMCIFBCLK      : in    std_logic;
          MMCICMDIN      : in    std_logic;
          MMCIDATIN      : in    std_logic;
          MMCICLKOUT     : out   std_logic;
          MMCICMDOUT     : out   std_logic;
          MMCIDATOUT     : out   std_logic;
          nMMCIDATEN     : out   std_logic;
          nMMCICMDEN     : out   std_logic;
          MMCIPWR        : out   std_logic;
          MMCIROD        : out   std_logic;
          MMCIVDD        : out   std_logic_vector(3 downto 0)
         );
end component;

-- -----------------------------------------------------------------------------
-- Test interface driver
-- The input filename, HaltOnMismatch and Verbosity settings should be
-- changed in the generic map section.
-- -----------------------------------------------------------------------------
component Ticbox
  generic (
           FileName         : string;
           HaltOnMismatch   : boolean;
           Verbosity        : boolean
          );
  port (
        nReset              : in    std_logic;
        TESTCLK             : in    std_logic;
        TESTACK             : in    std_logic;
        TESTBUS             : inout std_logic_vector(31 downto 0);
        TESTREQA            : out   std_logic := '0';
        TESTREQB            : out   std_logic := '0'
       );
  end component;

-- -----------------------------------------------------------------------------
-- MMCI Integration Trickbox
-- -----------------------------------------------------------------------------
component MmciTrickInteg
 port (
-- Inputs
        MMCICLKOUT          : in    std_logic;
        MMCIPWR             : in    std_logic;
        MMCIROD             : in    std_logic;
        MMCIVDD             : in    std_logic_vector(3 downto 0);
-- Outputs
        MMCIORMUX           : out   std_logic;
        MMCIFBCLK           : out   std_logic
       );
end component;

component MmciDummyPad
port (
-- Inputs
        MMCICMDOUT          : in std_logic;
        MMCIDATOUT          : in std_logic;
        nMMCIDATEN          : in std_logic;
        nMMCICMDEN          : in std_logic;
-- Outputs
        MMCICMD             : inout std_logic;
        MMCIDAT             : inout std_logic;
-- Outputs
        MMCICMDIN           : out std_logic;
        MMCIDATIN           : out std_logic
       );

end component;
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

constant PERIOD : time := 100 ns;
-- 10.0 MHz

constant PHASETIME : time := PERIOD / 2;
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

--  External Signals
signal XCLKIN               : std_logic;
signal nReset               : std_logic;
signal XD                   : std_logic_vector(31 downto 0);
signal XA                   : std_logic_vector(30 downto 0);
signal XCSN                 : std_logic_vector(3 downto 0);
signal XOEN                 : std_logic;
signal XWEN                 : std_logic_vector(3 downto 0);

-- TIC interface
signal TESTREQA             : std_logic;
signal TESTREQB             : std_logic;
signal TESTACK              : std_logic;
signal TESTCLK              : std_logic;

-- JTAG connections
signal nTRST                : std_logic;
signal TCK                  : std_logic;
signal TDI                  : std_logic;
signal TMS                  : std_logic;
signal TDO                  : std_logic;

-- MMCI related connections

signal MMCIFBCLK            : std_logic;
-- MMCI fed back clock

signal MMCICMDIN            : std_logic;
-- MMCI command input

signal MMCIDATIN            : std_logic;
-- MMCI data input

signal MMCICLKOUT           : std_logic;
-- MMCI Clock output

signal MMCICMDOUT           : std_logic;
-- MMCI Command output

signal MMCIDATOUT           : std_logic;
-- MMCI data output

signal MMCICMD              : std_logic := 'Z';
-- MMCI command

signal MMCIDAT              : std_logic := 'Z';
-- MMCI data

signal MMCIPWR              : std_logic;
-- Power supply enable

signal MMCIROD              : std_logic;
-- Open-drain resistor enable

signal MMCIVDD              : std_logic_vector(3 downto 0);
-- Power supply o/p voltage

signal nMMCIDATEN           : std_logic := '1';
--  Data enable

signal nMMCICMDEN           : std_logic := '1';
--  Command enable

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
            TDO              => TDO,
            MMCIFBCLK        => MMCIFBCLK,
            MMCICMDIN        => MMCICMDIN,
            MMCIDATIN        => MMCIDATIN,
            MMCICLKOUT       => MMCICLKOUT,
            MMCICMDOUT       => MMCICMDOUT,
            MMCIDATOUT       => MMCIDATOUT,
            nMMCIDATEN       => nMMCIDATEN,
            nMMCICMDEN       => nMMCICMDEN,
            MMCIPWR          => MMCIPWR,
            MMCIROD          => MMCIROD,
            MMCIVDD          => MMCIVDD
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
-- -----------------------------------------------------------------------------
-- MMCI Integration Trickbox
-- -----------------------------------------------------------------------------
u_MmciTrickInteg : MmciTrickInteg
  port map (
            MMCICLKOUT       => MMCICLKOUT,
            MMCIPWR          => MMCIPWR,
            MMCIROD          => MMCIROD,
            MMCIVDD          => MMCIVDD,
            MMCIORMUX        => MMCIDAT,
            MMCIFBCLK        => MMCIFBCLK
           );
-- -----------------------------------------------------------------------------
-- Mmci dummy pad
-- -----------------------------------------------------------------------------
uMmciDummyPad : MmciDummyPad
  port map (
            MMCICMDOUT       => MMCICMDOUT,
            MMCIDATOUT       => MMCIDATOUT,
            nMMCIDATEN       => nMMCIDATEN,
            nMMCICMDEN       => nMMCICMDEN,
            MMCICMD          => MMCIDAT,
            MMCIDAT          => MMCIDAT,
            MMCICMDIN        => MMCICMDIN,
            MMCIDATIN        => MMCIDATIN
           );

TESTCLK          <= XCLKIN;
-- JTAG connection
nTRST            <= not nReset;
TDI              <= '0';
TMS              <= '0';
MMCIDAT          <= 'H';
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
  -- Hold time for ResCntl SyncPOR register
  nReset <= '1' after 1 ns;

-- Wait until the TIC signals that test mode has been entered.
    wait until (XCLKIN'event and XCLKIN = '1' and TESTACK = '1');

-- End simulation when the Ticbox and TIC indicate that testing has
-- finished.
  wait until (XCLKIN'event and XCLKIN = '1' and
              TESTREQA = '0' and TESTREQB = '0' and TESTACK = '0');
  assert false report "Test sequence completed" severity failure;
end process p_StimulusComb;


end behavioural;

-- --============================== End ======================================--
