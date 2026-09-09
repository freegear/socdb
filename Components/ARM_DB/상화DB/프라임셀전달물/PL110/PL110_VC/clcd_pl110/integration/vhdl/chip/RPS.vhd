-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RPS.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Reference Peripherals:
--           Interrupt Controller, Remap and Pause Controller, and
--           Timers modules.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library uut;
use     uut.all;

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
        PRDATA           : out   std_logic_vector(31 downto 0)
       );

end RPS;

-- ---------------------------------------------------------------------

-- --======================= ARCHITECTURE ============================--

architecture Structural of RPS is

-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Central multiplexer - peripherals to bridge
-- ---------------------------------------------------------------------
component MuxP2B
  port (
        PSELRPC          : in    std_logic;
        PSELUUT          : in    std_logic;

        PRDATARPC        : in    std_logic_vector(31 downto 0);
        PRDATAUUT        : in    std_logic_vector(31 downto 0);

        PRDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- ---------------------------------------------------------------------
-- The reset and pause controller
-- ---------------------------------------------------------------------
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

        nFIQ             : in  std_logic; -- FIQ interrupt input
        nIRQ             : in  std_logic; -- IRQ interrupt input
        Pause            : out std_logic; -- Pause mode entered
        Remap            : out std_logic  -- Reset memory map in use
       );
end component;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal PRDATAUUT        : std_logic_vector(31 downto 0);
signal PRDATARPC        : std_logic_vector(31 downto 0);
signal nFIQInt          : std_logic := '1';
signal nIRQInt          : std_logic := '1';

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Central multiplexer - peripherals to bridge - Instantiation
-- ---------------------------------------------------------------------
uMuxP2B : MuxP2B
  port map (
            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,

            PRDATAUUT        => PRDATAUUT,
            PRDATARPC        => PRDATARPC,

            PRDATA           => PRDATA
           );

-- ---------------------------------------------------------------------
-- The reset and pause controller Instantiation
-- ---------------------------------------------------------------------
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
-- -------------------------------------------------------------------
-- Drive unused output read data bits LOW.
-- -------------------------------------------------------------------
PRDATARPC(31 downto 8) <= (others => '0');

-- Instantiate UUT here. The instance name should be 'uut'
-- PERIPH uut (
PRDATAUUT(31 downto 0) <= (others => '0');

end Structural;

-- --============================== End ==============================--
