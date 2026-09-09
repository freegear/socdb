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
-- File Name              : RPS.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Reference Peripherals:
--           Interrupt Controller, Remap and Pause Controller, and
--           Timers modules.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

library uut;
use uut.all;

entity RPS is
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;

        Pause            : out   std_logic; -- Pause mode entered
        Remap            : out   std_logic; -- Reset memory map in use

        PSELRPC          : in    std_logic; -- Remap and Pause

        PSELUUT          : in    std_logic; -- Unit Under Test

        PENABLE          : in    std_logic;
        PADDR            : in    std_logic_vector(31 downto 0);
        PWRITE           : in    std_logic;
        PWDATA           : in    std_logic_vector(31 downto 0);
        PRDATA           : out   std_logic_vector(31 downto 0);

        -- MMCI signals
        MMCIFBCLK         : in    std_logic; -- MMCI fed back clock
        MMCICMDIN         : in    std_logic; -- MMCI command input
        MMCIDATIN         : in    std_logic; -- MMCI data input
        MMCICLKOUT        : out   std_logic; -- MMCI Clock output
        MMCICMDOUT        : out   std_logic; -- MMCI Command output
        MMCIDATOUT        : out   std_logic; -- MMCI data output
        nMMCIDATEN        : out   std_logic; -- MMCI data enable
        nMMCICMDEN        : out   std_logic; -- MMCI command enable
        MMCIPWR           : out   std_logic; -- Power supply enable
        MMCIROD           : out   std_logic; -- Open-drain resistor
                                             -- enable
        MMCIVDD           : out   std_logic_vector(3 downto 0)
                                             -- Power supply o/p voltage
       );

end RPS;

-- -----------------------------------------------------------------------------

-- --======================= ARCHITECTURE ====================================--

architecture Structural of RPS is

-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Central multiplexer - peripherals to bridge
-- -----------------------------------------------------------------------------
component MuxP2B
  port (
        PSELRPC          : in    std_logic;
        PSELUUT          : in    std_logic;

        PRDATARPC        : in    std_logic_vector(31 downto 0);
        PRDATAUUT        : in    std_logic_vector(31 downto 0);

        PRDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- The reset and pause controller
-- -----------------------------------------------------------------------------
component RemPause
  port (
        PCLK             : in  std_logic;
        PRESETn          : in  std_logic;
        PENABLE          : in  std_logic;
        PSELRPC          : in  std_logic;
        PADDR            : in  std_logic_vector(5 downto 2);
        PWRITE           : in  std_logic;
        PWDATA           : in  std_logic_vector(7 downto 0);
        PRDATA           : out std_logic_vector(7 downto 0);

        nFIQ             : in  std_logic;
        nIRQ             : in  std_logic;
        Pause            : out std_logic;
        Remap            : out std_logic
       );
end component;

-- MMCI
component Mmci
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        PSEL             : in    std_logic;
        PENABLE          : in    std_logic;
        PWRITE           : in    std_logic;
        PADDR            : in    std_logic_vector(11 downto 2);
        PWDATA           : in    std_logic_vector(31 downto 0);
        SCANENABLE       : in    std_logic;
        SCANINPCLK       : in    std_logic;
        SCANINMCLK       : in    std_logic;
        SCANINnMCLK      : in    std_logic;
        SCANINMMCIFBCLK  : in    std_logic;
        MMCIDMACLR       : in    std_logic;
        MCLK             : in    std_logic;
        nMCLK            : in    std_logic;
        MMCIFBCLK        : in    std_logic;
        nMMCIRST         : in    std_logic;
        MMCICMDIN        : in    std_logic;
        MMCIDATIN        : in    std_logic;
        PRDATA           : out   std_logic_vector(31 downto 0);
        SCANOUTPCLK      : out   std_logic;
        SCANOUTMCLK      : out   std_logic;
        SCANOUTnMCLK     : out   std_logic;
        SCANOUTMMCIFBCLK : out   std_logic;
        MMCIINTR0        : out   std_logic;
        MMCIINTR1        : out   std_logic;
        MMCIDMASREQ      : out   std_logic;
        MMCIDMABREQ      : out   std_logic;
        MMCIDMALSREQ     : out   std_logic;
        MMCIDMALBREQ     : out   std_logic;
        MMCICLKOUT       : out   std_logic;
        MMCICMDOUT       : out   std_logic;
        nMMCICMDEN       : out   std_logic;
        MMCIDATOUT       : out   std_logic;
        nMMCIDATEN       : out   std_logic;
        MMCIPWR          : out   std_logic;
        MMCIROD          : out   std_logic;
        MMCIVDD          : out   std_logic_vector(3 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant defined for MCLK Period
-- -----------------------------------------------------------------------------
  constant MCLK_PERIOD    : time := 100 ns;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal PRDATAUUT        : std_logic_vector(31 downto 0);
signal PRDATARPC        : std_logic_vector(31 downto 0);
signal nFIQInt          : std_logic := '1';
signal nIRQInt          : std_logic := '1';

----------------------------------------
-- MMCI Signals
----------------------------------------  
signal SCANENABLE       : std_logic;
signal SCANINPCLK       : std_logic;
signal SCANINMCLK       : std_logic;
signal SCANINnMCLK      : std_logic;
signal SCANINMMCIFBCLK  : std_logic;
signal MMCIDMACLR       : std_logic;
signal SCANOUTPCLK      : std_logic;
signal SCANOUTMCLK      : std_logic;
signal SCANOUTnMCLK     : std_logic;
signal SCANOUTMMCIFBCLK : std_logic;
signal MMCIINTR0        : std_logic;
signal MMCIINTR1        : std_logic;
signal MMCIDMASREQ      : std_logic;
signal MMCIDMABREQ      : std_logic;
signal MMCIDMALSREQ     : std_logic;
signal MMCIDMALBREQ     : std_logic;
signal MCLK             : std_logic := '0';
signal nMCLK            : std_logic;
signal nMMCIRST         : std_logic;
signal nMMCIRST1        : std_logic;
signal nMMCIRST2        : std_logic;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

  SCANENABLE      <= '0';
  SCANINPCLK      <= '0';
  SCANINMCLK      <= '0';
  SCANINnMCLK     <= '0';
  SCANINMMCIFBCLK <= '0';
  MMCIDMACLR      <= '0';

  MCLK <= not MCLK after MCLK_PERIOD/2; 
  nMCLK           <= not MCLK;

-- -----------------------------------------------------------------------------
-- Create nMMCIRST by synchronising the negation to MCLK 
-- -----------------------------------------------------------------------------
  p_nMMCIRST1 : process(PRESETn, MCLK)
  begin
    if (PRESETn = '0') then
      nMMCIRST1 <= '0';
    elsif (MCLK'event and MCLK= '1') then
      nMMCIRST1 <= '1';
    end if;
  end process p_nMMCIRST1;
  
  p_nMMCIRST2 : process(PRESETn, MCLK)
  begin
    if (PRESETn = '0') then
      nMMCIRST2 <= '0';
    elsif (MCLK'event and MCLK= '1') then
      nMMCIRST2 <= nMMCIRST1;
    end if;
  end process p_nMMCIRST2;

  p_nMMCIRST3 : process(PRESETn, MCLK)
  begin
    if (PRESETn = '0') then
      nMMCIRST <= '0';
    elsif (MCLK'event and MCLK= '1') then
      nMMCIRST <= nMMCIRST2;
    end if;
  end process p_nMMCIRST3;

-- -----------------------------------------------------------------------------
-- Central multiplexer - peripherals to bridge - Instantiation
-- -----------------------------------------------------------------------------
uMuxP2B : MuxP2B
  port map (
            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,

            PRDATAUUT        => PRDATAUUT,
            PRDATARPC        => PRDATARPC,

            PRDATA           => PRDATA
           );

-- -----------------------------------------------------------------------------
-- The reset and pause controller Instantiation
-- -----------------------------------------------------------------------------
uRemPause : RemPause
  port map (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            PENABLE          => PENABLE,
            PSELRPC          => PSELRPC,
            PADDR            => PADDR(5 downto 2),
            PWRITE           => PWRITE,
            PWDATA           => PWDATA(7 downto 0),
            PRDATA           => PRDATARPC(7 downto 0),

            nFIQ             => nFIQInt,
            nIRQ             => nIRQInt,
            Pause            => Pause,
            Remap            => Remap
           );

-- Drive unused output read data bits LOW.
PRDATARPC(31 downto 8) <= (others => '0');

-- -----------------------------------------------------------------------------
-- AACI instance
-- -----------------------------------------------------------------------------
uut : Mmci
port map   (
            PCLK             => PCLK,
            PRESETn          => PRESETn,
            PSEL             => PSELUUT,
            PENABLE          => PENABLE,
            PWRITE           => PWRITE,
            PADDR            => PADDR(11 downto 2),
            PWDATA           => PWDATA(31 downto 0),
            SCANENABLE       => SCANENABLE,
            SCANINPCLK       => SCANINPCLK,
            SCANINMCLK       => SCANINMCLK,
            SCANINnMCLK      => SCANINnMCLK,
            SCANINMMCIFBCLK  => SCANINMMCIFBCLK,
            MMCIDMACLR       => MMCIDMACLR,
            MCLK             => MCLK,
            nMCLK            => nMCLK,
            MMCIFBCLK        => MMCIFBCLK,
            nMMCIRST         => nMMCIRST,
            MMCICMDIN        => MMCICMDIN, 
            MMCIDATIN        => MMCIDATIN,
            PRDATA           => PRDATAUUT,
            SCANOUTPCLK      => SCANOUTPCLK,
            SCANOUTMCLK      => SCANOUTMCLK,
            SCANOUTnMCLK     => SCANOUTnMCLK,
            SCANOUTMMCIFBCLK => SCANOUTMMCIFBCLK,
            MMCIINTR0        => MMCIINTR0,
            MMCIINTR1        => MMCIINTR1,
            MMCIDMASREQ      => MMCIDMASREQ,
            MMCIDMABREQ      => MMCIDMABREQ,
            MMCIDMALSREQ     => MMCIDMALSREQ,
            MMCIDMALBREQ     => MMCIDMALBREQ,
            MMCICLKOUT       => MMCICLKOUT,
            MMCICMDOUT       => MMCICMDOUT,
            nMMCICMDEN       => nMMCICMDEN,
            MMCIDATOUT       => MMCIDATOUT,
            nMMCIDATEN       => nMMCIDATEN,
            MMCIPWR          => MMCIPWR,
            MMCIROD          => MMCIROD,
            MMCIVDD          => MMCIVDD
           );

end Structural;

-- --============================== End ======================================--
