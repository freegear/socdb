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
-- File Name              : RPS.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
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
        PRDATA           : out   std_logic_vector(31 downto 0);

        -- AC-LINK signals
        AACIBITCLK       : in    std_logic; -- AC-Link Clock
        AACISDATAIN      : in    std_logic; -- Serial DataIn from CODEC
 
        AACISDATAOUT     : out   std_logic; -- Serial data out to CODEC
        AACISYNC         : out   std_logic; -- AACIBITCLK divided 
                                             -- by 256
        AACIRESET        : out   std_logic  -- AC-Link Reset
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

-- AACI    
component Aaci
  port (
        PCLK             : in    std_logic;
        AACIBITCLK       : in    std_logic;
        nAACIBITCLK      : in    std_logic;
        PRESETn          : in    std_logic;
        nAACIBITCLKRST   : in    std_logic;
        nFAACIBITCLKRST  : in    std_logic;
        PSEL             : in    std_logic;
        PENABLE          : in    std_logic;
        PWRITE           : in    std_logic;
        AACIDMACLRRX     : in    std_logic;
        AACIDMACLRTX     : in    std_logic;
        SCANENABLE       : in    std_logic;
        SCANINPCLK       : in    std_logic;
        SCANINBITCLK     : in    std_logic;
        SCANINnBITCLK    : in    std_logic;
        AACISDATAIN      : in    std_logic;
        PADDR            : in    std_logic_vector(11 downto 2);
        PWDATA           : in    std_logic_vector(31 downto 0);
        AACIRESET        : out   std_logic;
        AACISYNC         : out   std_logic;
        AACITXINTR1      : out   std_logic;
        AACITXINTR2      : out   std_logic;
        AACITXINTR3      : out   std_logic;
        AACITXINTR4      : out   std_logic;
        AACIRXINTR1      : out   std_logic;
        AACIRXINTR2      : out   std_logic;
        AACIRXINTR3      : out   std_logic;
        AACIRXINTR4      : out   std_logic;
        AACIORINTR1      : out   std_logic;
        AACIORINTR2      : out   std_logic;
        AACIORINTR3      : out   std_logic;
        AACIORINTR4      : out   std_logic;
        AACIURINTR1      : out   std_logic;
        AACIURINTR2      : out   std_logic;
        AACIURINTR3      : out   std_logic;
        AACIURINTR4      : out   std_logic;
        AACITXCINTR1     : out   std_logic;
        AACITXCINTR2     : out   std_logic;
        AACITXCINTR3     : out   std_logic;
        AACITXCINTR4     : out   std_logic;
        AACIRXTOINTR1    : out   std_logic;
        AACIRXTOINTR2    : out   std_logic;
        AACIRXTOINTR3    : out   std_logic;
        AACIRXTOINTR4    : out   std_logic;
        AACIWINTR        : out   std_logic;
        AACIGPIOINTR     : out   std_logic;
        AACIS12RXINTR    : out   std_logic;
        AACIS12TXINTR    : out   std_logic;
        AACIS2RXINTR     : out   std_logic;
        AACIS2TXINTR     : out   std_logic;
        AACIS1RXINTR     : out   std_logic;
        AACIS1TXINTR     : out   std_logic;
        AACIRXTOFEINTR1  : out   std_logic;
        AACIRXTOFEINTR2  : out   std_logic;
        AACIRXTOFEINTR3  : out   std_logic;
        AACIRXTOFEINTR4  : out   std_logic;
        AACIINTR         : out   std_logic;
        AACIDMASREQRX    : out   std_logic;
        AACIDMALSREQRX   : out   std_logic;
        AACIDMABREQRX    : out   std_logic;
        AACIDMALBREQRX   : out   std_logic;
        AACIDMABREQTX    : out   std_logic;
        SCANOUTPCLK      : out   std_logic;
        SCANOUTBITCLK    : out   std_logic;
        SCANOUTnBITCLK   : out   std_logic;
        AACISDATAOUT     : out   std_logic;
        PRDATA           : out   std_logic_vector(31 downto 0)
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
-- AACI Signals
-- ---------------------------------------------------------------------
signal nAACIBITCLK      : std_logic;
signal nAACIBITCLKRST   : std_logic;
signal nFAACIBITCLKRST  : std_logic;
signal AACIDMACLRRX     : std_logic;
signal AACIDMACLRTX     : std_logic;
signal SCANENABLE       : std_logic;
signal SCANINPCLK       : std_logic;
signal SCANINBITCLK     : std_logic;
signal SCANINnBITCLK    : std_logic;

signal AACITXINTR1      : std_logic;
signal AACITXINTR2      : std_logic;
signal AACITXINTR3      : std_logic;
signal AACITXINTR4      : std_logic;
signal AACIRXINTR1      : std_logic;
signal AACIRXINTR2      : std_logic;
signal AACIRXINTR3      : std_logic;
signal AACIRXINTR4      : std_logic;
signal AACIORINTR1      : std_logic;
signal AACIORINTR2      : std_logic;
signal AACIORINTR3      : std_logic;
signal AACIORINTR4      : std_logic;
signal AACIURINTR1      : std_logic;
signal AACIURINTR2      : std_logic;
signal AACIURINTR3      : std_logic;
signal AACIURINTR4      : std_logic;
signal AACITXCINTR1     : std_logic;
signal AACITXCINTR2     : std_logic;
signal AACITXCINTR3     : std_logic;
signal AACITXCINTR4     : std_logic;
signal AACIRXTOINTR1    : std_logic;
signal AACIRXTOINTR2    : std_logic;
signal AACIRXTOINTR3    : std_logic;
signal AACIRXTOINTR4    : std_logic;
signal AACIWINTR        : std_logic;
signal AACIGPIOINTR     : std_logic;
signal AACIS12RXINTR    : std_logic;
signal AACIS12TXINTR    : std_logic;
signal AACIS2RXINTR     : std_logic;
signal AACIS2TXINTR     : std_logic;
signal AACIS1RXINTR     : std_logic;
signal AACIS1TXINTR     : std_logic;
signal AACIRXTOFEINTR1  : std_logic;
signal AACIRXTOFEINTR2  : std_logic;
signal AACIRXTOFEINTR3  : std_logic;
signal AACIRXTOFEINTR4  : std_logic;
signal AACIINTR         : std_logic;
signal AACIDMASREQRX    : std_logic;
signal AACIDMALSREQRX   : std_logic;
signal AACIDMABREQRX    : std_logic;
signal AACIDMALBREQRX   : std_logic;
signal AACIDMABREQTX    : std_logic;
signal SCANOUTPCLK      : std_logic;
signal SCANOUTBITCLK    : std_logic;
signal SCANOUTnBITCLK   : std_logic;
signal nAACIBITCLKRST1  : std_logic;
signal nAACIBITCLKRST2  : std_logic;
signal nFAACIBITCLKRST1 : std_logic;
signal nFAACIBITCLKRST2 : std_logic;

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Tie down non-primary inputs to the AACI to prevent X-propagation
-- during netlist simulations.
-- ---------------------------------------------------------------------
AACIDMACLRRX    <= '0';
AACIDMACLRTX    <= '0';
SCANENABLE      <= '0';
SCANINPCLK      <= '0';
SCANINBITCLK    <= '0';
SCANINnBITCLK   <= '0';

-- ---------------------------------------------------------------------
-- Invert AACIBITCLK to gnerate nAACIBITCLK
-- ---------------------------------------------------------------------
nAACIBITCLK      <= not(AACIBITCLK); 

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
-- Create nAACIBITCLKRST by synchronising the negation to AACIBITCLK
-- ---------------------------------------------------------------------
p_nAACIBITCLKRST1 : process(PRESETn, AACIBITCLK)
begin
  if (PRESETn = '0') then
    nAACIBITCLKRST1 <= '0';
  elsif (AACIBITCLK'event and AACIBITCLK= '1') then
    nAACIBITCLKRST1 <= '1' after 0.5 ns;
  end if;
end process p_nAACIBITCLKRST1;

p_nAACIBITCLKRST2 : process(PRESETn, AACIBITCLK)
begin
  if (PRESETn = '0') then
    nAACIBITCLKRST2 <= '0';
  elsif (AACIBITCLK'event and AACIBITCLK= '1') then
    nAACIBITCLKRST2 <= nAACIBITCLKRST1 after 0.5 ns;
  end if;
end process p_nAACIBITCLKRST2;

p_nAACIBITCLKRST3 : process(PRESETn, AACIBITCLK)
begin
  if (PRESETn = '0') then
    nAACIBITCLKRST <= '0';
  elsif (AACIBITCLK'event and AACIBITCLK= '1') then
    nAACIBITCLKRST <= nAACIBITCLKRST2 after 0.5 ns;
  end if;
end process p_nAACIBITCLKRST3;

-- ---------------------------------------------------------------------
-- Create nFAACIBITCLKRST by synchronising the negation to nAACIBITCLK
-- ---------------------------------------------------------------------
p_nFAACIBITCLKRST1 : process(PRESETn, nAACIBITCLK)
begin
  if (PRESETn = '0') then
    nFAACIBITCLKRST1 <= '0';
  elsif (nAACIBITCLK'event and nAACIBITCLK= '1') then
    nFAACIBITCLKRST1 <= '1' after 0.5 ns;
  end if;
end process p_nFAACIBITCLKRST1;

p_nFAACIBITCLKRST2 : process(PRESETn, nAACIBITCLK)
begin
  if (PRESETn = '0') then
    nFAACIBITCLKRST2 <= '0';
  elsif (nAACIBITCLK'event and nAACIBITCLK= '1') then
    nFAACIBITCLKRST2 <= nFAACIBITCLKRST1 after 0.5 ns;
  end if;
end process p_nFAACIBITCLKRST2;

p_nFAACIBITCLKRST3 : process(PRESETn, nAACIBITCLK)
begin
  if (PRESETn = '0') then
    nFAACIBITCLKRST <= '0';
  elsif (nAACIBITCLK'event and nAACIBITCLK= '1') then
    nFAACIBITCLKRST <= nFAACIBITCLKRST2 after 0.5 ns;
  end if;
end process p_nFAACIBITCLKRST3;

-- ---------------------------------------------------------------------
-- AACI instance
-- ---------------------------------------------------------------------
uut : Aaci
  port map (
            PCLK              => PCLK,
            AACIBITCLK        => AACIBITCLK,
            nAACIBITCLK       => nAACIBITCLK,
            PRESETn           => PRESETn,
            nAACIBITCLKRST    => nAACIBITCLKRST,
            nFAACIBITCLKRST   => nFAACIBITCLKRST,
            PSEL              => PSELUUT,
            PENABLE           => PENABLE,
            PWRITE            => PWRITE,
            AACIDMACLRRX      => AACIDMACLRRX,
            AACIDMACLRTX      => AACIDMACLRTX,
            SCANENABLE        => SCANENABLE,
            SCANINPCLK        => SCANINPCLK,
            SCANINBITCLK      => SCANINBITCLK,
            SCANINnBITCLK     => SCANINnBITCLK,
            AACISDATAIN       => AACISDATAIN,
            PADDR             => PADDR(11 downto 2),
            PWDATA            => PWDATA,
            AACIRESET         => AACIRESET,
            AACISYNC          => AACISYNC,
            AACITXINTR1       => AACITXINTR1,
            AACITXINTR2       => AACITXINTR2,
            AACITXINTR3       => AACITXINTR3,
            AACITXINTR4       => AACITXINTR4,
            AACIRXINTR1       => AACIRXINTR1,
            AACIRXINTR2       => AACIRXINTR2,
            AACIRXINTR3       => AACIRXINTR3,
            AACIRXINTR4       => AACIRXINTR4,
            AACIORINTR1       => AACIORINTR1,
            AACIORINTR2       => AACIORINTR2,
            AACIORINTR3       => AACIORINTR3,
            AACIORINTR4       => AACIORINTR4,
            AACIURINTR1       => AACIURINTR1,
            AACIURINTR2       => AACIURINTR2,
            AACIURINTR3       => AACIURINTR3,
            AACIURINTR4       => AACIURINTR4,
            AACITXCINTR1      => AACITXCINTR1,
            AACITXCINTR2      => AACITXCINTR2,
            AACITXCINTR3      => AACITXCINTR3,
            AACITXCINTR4      => AACITXCINTR4,
            AACIRXTOINTR1     => AACIRXTOINTR1,
            AACIRXTOINTR2     => AACIRXTOINTR2,
            AACIRXTOINTR3     => AACIRXTOINTR3,
            AACIRXTOINTR4     => AACIRXTOINTR4,
            AACIWINTR         => AACIWINTR,
            AACIGPIOINTR      => AACIGPIOINTR,
            AACIS12RXINTR     => AACIS12RXINTR,
            AACIS12TXINTR     => AACIS12TXINTR,
            AACIS2RXINTR      => AACIS2RXINTR,
            AACIS2TXINTR      => AACIS2TXINTR,
            AACIS1RXINTR      => AACIS1RXINTR,
            AACIS1TXINTR      => AACIS1TXINTR,
            AACIRXTOFEINTR1   => AACIRXTOFEINTR1,
            AACIRXTOFEINTR2   => AACIRXTOFEINTR2,
            AACIRXTOFEINTR3   => AACIRXTOFEINTR3,
            AACIRXTOFEINTR4   => AACIRXTOFEINTR4,
            AACIINTR          => AACIINTR,
            AACIDMASREQRX     => AACIDMASREQRX,
            AACIDMALSREQRX    => AACIDMALSREQRX,
            AACIDMABREQRX     => AACIDMABREQRX,
            AACIDMALBREQRX    => AACIDMALBREQRX,
            AACIDMABREQTX     => AACIDMABREQTX,
            SCANOUTPCLK       => SCANOUTPCLK,
            SCANOUTBITCLK     => SCANOUTBITCLK,
            SCANOUTnBITCLK    => SCANOUTnBITCLK,
            AACISDATAOUT      => AACISDATAOUT,
            PRDATA            => PRDATAUUT
           );

end Structural;

-- --============================== End ==============================--
