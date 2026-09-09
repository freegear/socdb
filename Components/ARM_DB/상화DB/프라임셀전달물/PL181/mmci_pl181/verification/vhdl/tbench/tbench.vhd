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
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : Top level of the MMCI Compliance TestBench
--           This file instantiates the MMCI module, the MMCI trickbox
--           and the Read Data Mux.
--
-- --=========================================================================--

library ieee;
use ieee.std_logic_1164.all;

library tbench;
use tbench.timing.all;

library uut;

library trickbox;

entity tbench is
end tbench;

-- -----------------------------------------------------------------------------
--
--                               tbench
--                               ======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--  Top level testbench.This file integrates the MMCI, MMCI trickbox and
-- the APB interface modules to enable system level testing.
--
-- -----------------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture structural of tbench is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
  component apbslave_tb
  generic
         (
           PRDATA_mask    : string;
           INFILE         : string;
           Verbosity      : integer;
           HaltOnMismatch : integer;
           tclks          : time;
           tclkl          : time;
           tclkh          : time
         );
  port (
         PRESETn          : out   std_logic;
         PCLK             : out   std_logic;
         PADDR            : out   std_logic_vector(31 downto 0);
         PWRITE           : out   std_logic;
         PENABLE          : out   std_logic;
         PSEL             : out   std_logic;
         PSELT            : out   std_logic;
         PWDATA           : out   std_logic_vector(31 downto 0);
         PRDATA           : in    std_logic_vector(31 downto 0);
         VRG0             : inout std_logic_vector(31 downto 0);
         VRG1             : inout std_logic_vector(31 downto 0);
         VRG2             : inout std_logic_vector(31 downto 0);
         VRG3             : inout std_logic_vector(31 downto 0);
         VRG4             : inout std_logic_vector(31 downto 0);
         VRG5             : inout std_logic_vector(31 downto 0);
         VRG6             : inout std_logic_vector(31 downto 0);
         VRG7             : inout std_logic_vector(31 downto 0)
       );
  end component;

  component apbmux
  port (
         PCLK             : in    std_logic;
         PRESETn          : in    std_logic;
         PSEL             : in    std_logic;
         PSELT            : in    std_logic;
         PRData0          : in    std_logic_vector(31 downto 0);
         PRData1          : in    std_logic_vector(31 downto 0);
         PRData           : out   std_logic_vector(31 downto 0)
       );
  end component;

  component MmciTrick
  port (
         PRESETn          : in    std_logic;
         PCLK             : in    std_logic;
         PSEL             : in    std_logic;
         PSELT            : in    std_logic;
         PWRITE           : in    std_logic;
         PENABLE          : in    std_logic;
         PADDR            : in    std_logic_vector(11 downto 2);
         PWDATA           : in    std_logic_vector(31 downto 0);
         MMCICLKOUT       : in    std_logic;
         MMCIPWR          : in    std_logic;
         MMCIVDD          : in    std_logic_vector(3 downto 0);
         MMCIROD          : in    std_logic;
         MMCIINTR0        : in    std_logic;
         MMCIINTR1        : in    std_logic;
         MMCIDMASREQ      : in    std_logic;
         MMCIDMABREQ      : in    std_logic;
         MMCIDMALSREQ     : in    std_logic;
         MMCIDMALBREQ     : in    std_logic;
         MMCICMD          : inout std_logic;
         MMCIDAT          : inout std_logic;
         MCLK             : out   std_logic;
         nMMCIRST         : out   std_logic;
         MMCIDMACLR       : out   std_logic;
         PRDATA           : out   std_logic_vector(31 downto 0)
       );
  end component;

  component Mmci
  port (
         PCLK             : in  std_logic;
         PRESETn          : in  std_logic;
         PSEL             : in  std_logic;
         PENABLE          : in  std_logic;
         PWRITE           : in  std_logic;
         PADDR            : in  std_logic_vector(11 downto 2);
         PWDATA           : in  std_logic_vector(31 downto 0);
         SCANENABLE       : in  std_logic;
         SCANINPCLK       : in  std_logic;
         SCANINMCLK       : in  std_logic;
      	 SCANINnMCLK      : in  std_logic;
         SCANINMMCIFBCLK  : in  std_logic;
         MMCIDMACLR       : in  std_logic;
         MCLK             : in  std_logic;
         nMCLK            : in  std_logic;
         MMCIFBCLK        : in  std_logic;
         nMMCIRST         : in  std_logic;
         MMCICMDIN        : in  std_logic;
         MMCIDATIN        : in  std_logic;
         PRDATA           : out std_logic_vector(31 downto 0);
         SCANOUTPCLK      : out std_logic;
         SCANOUTMCLK      : out std_logic;
         SCANOUTnMCLK     : out std_logic;
         SCANOUTMMCIFBCLK : out std_logic;
         MMCIINTR0        : out std_logic;
         MMCIINTR1        : out std_logic;
         MMCIDMASREQ      : out std_logic;
         MMCIDMABREQ      : out std_logic;
         MMCIDMALSREQ     : out std_logic;
         MMCIDMALBREQ     : out std_logic;
         MMCICLKOUT       : out std_logic;
         MMCICMDOUT       : out std_logic;
         nMMCICMDEN       : out std_logic;
         MMCIDATOUT       : out std_logic;
         nMMCIDATEN       : out std_logic;
         MMCIPWR          : out std_logic;
         MMCIROD          : out std_logic;
         MMCIVDD          : out std_logic_vector(3 downto 0)
       );
  end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- If the XonPSEL constant is set to '0' (default), an 'X' appearing
-- on the PSEL line will be converted to '0'. If this constant is set
-- to '1', the PSEL generated internally by the testbench is passed on
-- unmodified.
-- -----------------------------------------------------------------------------
  constant XonPSEL                    : std_logic := '0';
  constant MMCIFBCLK_TO_MMCICLK_DELAY : time := 3 ns;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal PCLK             : std_logic;
signal PENABLE          : std_logic;
signal PRESETn          : std_logic;
signal PADDR            : std_logic_vector(31 downto 0);
signal I_PADDR          : std_logic_vector(31 downto 0);

signal PWRITE           : std_logic;
signal PSEL             : std_logic;
signal I_PSEL           : std_logic;
signal I_PWRITE         : std_logic;
signal PSELT            : std_logic;
signal I_PSELT          : std_logic;
signal PRDATA0          : std_logic_vector(31 downto 0);
signal PRDATA1          : std_logic_vector(31 downto 0);
signal PRDATA           : std_logic_vector(31 downto 0);
signal PWDATA           : std_logic_vector(31 downto 0);

signal VRG0             : std_logic_vector(31 downto 0);
signal VRG1             : std_logic_vector(31 downto 0);
signal VRG2             : std_logic_vector(31 downto 0);
signal VRG3             : std_logic_vector(31 downto 0);
signal VRG4             : std_logic_vector(31 downto 0);
signal VRG5             : std_logic_vector(31 downto 0);
signal VRG6             : std_logic_vector(31 downto 0);
signal VRG7             : std_logic_vector(31 downto 0);

signal MMCICLKOUT       : std_logic;
signal MMCIPWR          : std_logic;
signal MMCIVDD          : std_logic_vector(3 downto 0);
signal MMCIROD          : std_logic;
signal MMCIINTR0        : std_logic;
signal MMCIINTR1        : std_logic;
signal MMCIDMASREQ      : std_logic;
signal MMCIDMABREQ      : std_logic;
signal MMCIDMALSREQ     : std_logic;
signal MMCIDMALBREQ     : std_logic;
signal MMCICMD          : std_logic;
signal MMCIDAT          : std_logic;
signal MCLK             : std_logic;
signal nMMCIRST         : std_logic;
signal MMCIDMACLR       : std_logic;

signal SCANENABLE       : std_logic;
signal SCANINPCLK       : std_logic;
signal SCANINMCLK       : std_logic;
signal SCANINnMCLK      : std_logic;
signal SCANINMMCIFBCLK  : std_logic;
signal nMCLK            : std_logic;
signal MMCIFBCLK        : std_logic;
signal SCANOUTPCLK      : std_logic;
signal SCANOUTMCLK      : std_logic;
signal SCANOUTnMCLK     : std_logic;
signal SCANOUTMMCIFBCLK : std_logic;
signal MMCICMDOUT       : std_logic;
signal MMCICMDIN        : std_logic;
signal nMMCICMDEN       : std_logic;
signal MMCIDATOUT       : std_logic;
signal MMCIDATIN        : std_logic;
signal nMMCIDATEN       : std_logic;

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

  -- Connect all the scan inputs to '0' to prevent interference with
  -- functional mode tests.
  SCANENABLE     <= '0';
  SCANINPCLK     <= '0';
  SCANINMCLK     <= '0';
  SCANINnMCLK    <= '0';
  SCANINMMCIFBCLK <= '0';

  MMCIFBCLK <= MMCICLKOUT after MMCIFBCLK_TO_MMCICLK_DELAY;
  nMCLK    <= not (MCLK);

  PSEL   <= '0' when (XonPSEL = '0' and I_PSEL = 'X')
         else
            I_PSEL;

  PSELT  <= '0' when (XonPSEL = '0' and I_PSELT = 'X')
         else
            I_PSELT;
  PWRITE <= '0' when (XonPSEL = '0' and I_PWRITE = 'X')
         else
            I_PWRITE;

  p_PADDR : process (I_PADDR)
  begin
    for i in 0 to 31 loop
      if ((XonPSEL = '0') and (I_PADDR(i) = 'X')) then
          PADDR(i) <= '0';
      else
        PADDR(i)   <= I_PADDR(i);
      end if;
    end loop;
  end process p_PADDR;

  -- All the unconnected Virtual Register inputs should be set to zero:
  VRG0 (31 downto 0) <= (others => '0');
  VRG1 (31 downto 0) <= (others => '0');
  VRG2 (31 downto 0) <= (others => '0');
  VRG3 (31 downto 0) <= (others => '0');
  VRG4 (31 downto 0) <= (others => '0');
  VRG5 (31 downto 0) <= (others => '0');
  VRG6 (31 downto 0) <= (others => '0');
  VRG7 (31 downto 0) <= (others => '0');

  u_apbslv_tb : apbslave_tb
    generic map (
                 PRDATA_mask    => "FFFFFFFF",
                 INFILE         => "../../bustest/invec/infile.bif",
                 Verbosity      => 0,
                 HaltOnMismatch => 0,
                 tclks          => Tclks,
                 tclkl          => Tclkl,
                 tclkh          => Tclkh
                )
  port map (
             PRESETn          => PRESETn,
             PCLK             => PCLK,
             PADDR            => I_PADDR,
             PWRITE           => I_PWRITE,
             PENABLE          => PENABLE,
             PSEL             => I_PSEL,
             PSELT            => I_PSELT,
             PRDATA           => PRDATA,
             PWDATA           => PWDATA,
             VRG0             => VRG0,
             VRG1             => VRG1,
             VRG2             => VRG2,
             VRG3             => VRG3,
             VRG4             => VRG4,
             VRG5             => VRG5,
             VRG6             => VRG6,
             VRG7             => VRG7
           );

  u_MmciTrick : MmciTrick
  port map (
             PRESETn          => PRESETn,
             PCLK             => PCLK,
             PSEL             => PSEL,
             PSELT            => PSELT,
             PWRITE           => PWRITE,
             PENABLE          => PENABLE,
             PADDR            => PADDR(11 downto 2),
             PWDATA           => PWDATA,
             MMCICLKOUT       => MMCICLKOUT,
             MMCIPWR          => MMCIPWR,
             MMCIVDD          => MMCIVDD,
             MMCIROD          => MMCIROD,
             MMCIINTR0        => MMCIINTR0,
             MMCIINTR1        => MMCIINTR1,
             MMCIDMASREQ      => MMCIDMASREQ,
             MMCIDMABREQ      => MMCIDMABREQ,
             MMCIDMALSREQ     => MMCIDMALSREQ,
             MMCIDMALBREQ     => MMCIDMALBREQ,
             MMCICMD          => MMCICMD,
             MMCIDAT          => MMCIDAT,
             MCLK             => MCLK,
             nMMCIRST         => nMMCIRST,
             MMCIDMACLR       => MMCIDMACLR,
             PRDATA           => PRDATA1
           );


  uut : Mmci
  port map (
             PCLK             => PCLK,
             PRESETn          => PRESETn,
             PSEL             => PSEL,
             PENABLE          => PENABLE,
             PWRITE           => PWRITE,
             PADDR            => PADDR(11 downto 2),
             PWDATA           => PWDATA,
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
             PRDATA           => PRDATA0,
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

  u_apbmux : apbmux
  port map (
             PCLK             => PCLK,
             PRESETn          => PRESETn,
             PSEL             => PSEL,
             PSELT            => PSELT,
             PRData0          => PRDATA0,
             PRData1          => PRDATA1,
             PRData           => PRDATA
           );

-- -----------------------------------------------------------------------------
-- Tri-state the MMCICMD line if the nMMCICMDEN is high
-- -----------------------------------------------------------------------------
-- The MMCICMD signal feeds the trickbox. Note that the 'Z' assigment
-- is required since the trickbox protocol checks depend on this
-- in OpenDrain mode.
MMCICMD <= MMCICMDOUT when nMMCICMDEN = '0'
       else
          'Z';

-- The MMCICMDIN signal feeds the MMCI. Note that the 'H' assigment
-- is required (as against a 'Z' assignment) to prevent 'X'
-- propagation during netlist simulations.
MMCICMDIN <= MMCICMD when MMCICMD /= 'Z'
         else
          '1';
-- -----------------------------------------------------------------------------
-- Tri-state the MMCIDAT[0] line if the nMMCIDATEN is high
-- -----------------------------------------------------------------------------
-- The MMCIDAT[0] signal feeds the trickbox. Note that the 'Z' assigment
-- is required since the trickbox protocol checks depend on this.
MMCIDAT <= MMCIDATOUT when nMMCIDATEN = '0'
          else
             'Z';

-- The MMCIDATIN[0] signal feeds the MMCI. Note that the 'H' assigment
-- is required (as against a 'Z' assignment) to prevent 'X'
-- propagation during netlist simulations.
MMCIDATIN <= MMCIDAT when MMCIDAT /= 'Z'
          else
             '1';

end structural;

-- --================================== End ==================================--
