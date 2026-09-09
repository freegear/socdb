-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RPS.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL031-REL1v0
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

-- RTC
component Rtc
port (
   PCLK          : in    std_logic;    -- APB clock
   PRESETn       : in    std_logic;    -- APB reset
   PSEL	         : in    std_logic;    -- APB select
   PENABLE       : in    std_logic;    -- APB enable
   PWRITE        : in    std_logic;    -- APB write
   PADDR         : in    std_logic_vector(11 downto 2); -- APB Address 
   PWDATA        : in    std_logic_vector(31 downto 0); -- APB write data
   CLK1HZ        : in    std_logic;    -- 1 HZ clock
   nRTCRST       : in    std_logic;    -- RTC reset signal
   nPOR          : in    std_logic;    -- RTC power on reset signal
   
   PRDATA        : out   std_logic_vector(31 downto 0); -- APB  read data
   RTCINTR       : out   std_logic;    -- RTC interrupt

 -- Scan test signals, not connected until scan insertion.
   SCANENABLE    : in    std_logic;    -- Test mode enable
   SCANINPCLK    : in    std_logic;    -- PCLK Scan chain input
   SCANINCLK1HZ  : in    std_logic;    -- CLK1HZ Scan chain input
   SCANOUTPCLK   : out   std_logic;    -- PCLK Scan chain output
   SCANOUTCLK1HZ : out   std_logic     -- CLK1HZ Scan chain output
   );
end component;


-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant CLK1HZ_PERIOD    : time := 1000000000 ns;
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal PRDATAUUT        : std_logic_vector(31 downto 0);
signal PRDATARPC        : std_logic_vector(31 downto 0);
signal nFIQInt          : std_logic := '1';
signal nIRQInt          : std_logic := '1';

-- ---------------------------------------------------------------------
-- Rtc Signals 
-- ---------------------------------------------------------------------

signal CLK1HZ        : std_logic := '0';
signal nRTCRST       : std_logic;
signal nPOR          : std_logic;
signal RTCINTR       : std_logic;
signal SCANENABLE    : std_logic;
signal SCANINPCLK    : std_logic;
signal SCANINCLK1HZ  : std_logic;
signal SCANOUTPCLK   : std_logic;
signal SCANOUTCLK1HZ : std_logic;
signal nRTCRST1      : std_logic;
signal nRTCRST2      : std_logic;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Tie down non-primary inputs to the RTC to prevent X-propagation
-- during netlist simulations.
-- ---------------------------------------------------------------------
SCANENABLE   <= '0';
SCANINPCLK   <= '0';
SCANINCLK1HZ <= '0';

CLK1HZ <= not CLK1HZ after CLK1HZ_PERIOD/2;

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

-- Drive unused output read data bits LOW.
PRDATARPC(31 downto 8) <= (others => '0');

-- ---------------------------------------------------------------------
-- Create nRTCRST by synchronising the negation to CLK1HZ
-- ---------------------------------------------------------------------
  p_nRTCRST1 : process(PRESETn, CLK1HZ)
  begin
    if (PRESETn = '0') then
      nRTCRST1 <= '0';
    elsif (CLK1HZ'event and CLK1HZ = '1') then
      nRTCRST1 <= '1';
    end if;
  end process p_nRTCRST1;
  
  p_nRTCRST2 : process(PRESETn, CLK1HZ)
  begin
    if (PRESETn = '0') then
      nRTCRST2 <= '0';
    elsif (CLK1HZ'event and CLK1HZ = '1') then
      nRTCRST2 <= nRTCRST1;
    end if;
  end process p_nRTCRST2;

  p_nRTCRST3 : process(PRESETn, CLK1HZ)
  begin
    if (PRESETn = '0') then
      nRTCRST <= '0';
    elsif (CLK1HZ'event and CLK1HZ = '1') then
      nRTCRST <= nRTCRST2;
    end if;
  end process p_nRTCRST3;

-- ---------------------------------------------------------------------
-- RTC instance
-- ---------------------------------------------------------------------
uut : Rtc
  port map (
            PCLK           => PCLK,
            PRESETn        => PRESETn,
            PSEL           => PSELUUT,
            PENABLE        => PENABLE,
            PWRITE         => PWRITE,
            PADDR          => PADDR(11 downto 2),
            PWDATA         => PWDATA(31 downto 0),
            CLK1HZ         => CLK1HZ,
            nRTCRST        => PRESETn,
            nPOR           => PRESETn,
            PRDATA         => PRDATAUUT(31 downto 0),
            RTCINTR        => RTCINTR,
            SCANENABLE     => SCANENABLE,
            SCANINPCLK     => SCANINPCLK,
            SCANINCLK1HZ   => SCANINCLK1HZ ,
            SCANOUTPCLK    => SCANOUTPCLK,
            SCANOUTCLK1HZ  => SCANOUTCLK1HZ
           );

end Structural;

-- --============================== End ==============================--
