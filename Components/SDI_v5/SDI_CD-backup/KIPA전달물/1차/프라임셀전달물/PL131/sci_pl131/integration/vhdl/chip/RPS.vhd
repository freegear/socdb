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
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL131-REL1v0
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

        -- SCI - Primary I/O Test Trickbox connections
       SCICLKIN          : in    std_logic;
       SCIDATAIN         : in    std_logic;
       SCIDETECT         : in    std_logic;
       SCIDEACREQ        : in    std_logic;

       nSCICLKEN         : out   std_logic;
       nSCICLKOUTEN      : out   std_logic;
       SCICLKOUT         : out   std_logic;
       nSCIDATAEN        : out   std_logic;
       nSCIDATAOUTEN     : out   std_logic;

       SCIDEACACK        : out   std_logic;
       SCIVCCEN          : out   std_logic;
       nSCICARDRST       : out   std_logic;
       SCIFCB            : out   std_logic
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
-- The SCI PL131 Smart Card Interface
-- ---------------------------------------------------------------------    
component Sci
port (
  PCLK            : in   std_logic; -- APB Bus Clock
  SCICLK          : in   std_logic; -- SCI Clock
  PRESETn         : in   std_logic; -- APB Bus Reset
  nSCIRST         : in   std_logic; -- SCI Reset
  PSEL            : in   std_logic; -- APB Peripheral Select
  PENABLE         : in   std_logic; -- APB Peripheral Enable
  PWRITE          : in   std_logic; -- APB Peripheral Write
  PADDR           : in   std_logic_vector(11 downto 2);
                                  -- APB Address Bus
  PWDATA          : in   std_logic_vector(15 downto 0);
                                  -- APB Write Data Bus
  SCIDATAIN       : in   std_logic; -- Data Input from PAD
  SCICLKIN        : in   std_logic; -- Smartcard Clock input
  SCIDETECT       : in   std_logic; -- Card detect signal to
                                    -- interface
  SCIDEACREQ      : in   std_logic; -- PMU Card Deactivation Request; 
  SCITXDMACLR     : in   std_logic; -- TX DMA Clear
  SCIRXDMACLR	  : in   std_logic; -- RX DMA Clear
  SCANENABLE	  : in   std_logic; -- Scan Test Enable
  SCANINPCLK	  : in   std_logic; -- Scan Test Input PCLK domain
  SCANINSCICLK	  : in   std_logic; -- Scan Test Input SCICLK domain
  
  nSCIDATAOUTEN	  : out  std_logic; -- Data output enable
  nSCIDATAEN	  : out  std_logic; -- Tristate control for external
                                    -- buffer
  SCICLKOUT       : out  std_logic; -- Smartcard Clock output
  nSCICLKOUTEN	  : out  std_logic; -- Tristate output buffer control
  nSCICLKEN       : out  std_logic; -- Tristate control for external
                                    -- buffer
  nSCICARDRST	  : out  std_logic; -- Card Rst output 
  SCIFCB          : out  std_logic; -- Function Code Bit
  SCIVCCEN        : out  std_logic; -- Supply voltage control
  SCIDEACACK	  : out  std_logic; -- Card deactivation Acknowledge
  PRDATA          : out  std_logic_vector(15 downto 0);
                                    -- APB Read Data Bus
  SCICARDININTR	  : out  std_logic; -- Card Inserted Interrupt
  SCICARDOUTINTR  : out  std_logic; -- Card Out Interrupt
  SCICARDUPINTR	  : out  std_logic; -- Card powered Up Interrupt
  SCICARDDNINTR	  : out  std_logic; -- Transmit Error Interrupt
  SCITXERRINTR	  : out  std_logic; -- Answer-To-Reset Start
                                    -- TimeOut
                                    -- Interrupt
  SCIATRSTOUTINTR : out  std_logic; -- Answer-To-Reset Duration
                                    -- TimeOut
                                    -- Interrupt
  SCIATRDTOUTINTR : out  std_logic; -- Block Timeout Interrupt
  SCIBLKTOUTINTR  : out  std_logic; -- Block Timeout Interrupt
  SCICHTOUTINTR	  : out  std_logic; -- Character Timeout Interrupt
  SCIRTOUTINTR	  : out  std_logic; -- Receive Timeout Interrupt
  SCIRORINTR	  : out  std_logic; -- Receive OverRun Interrupt
  SCICLKSTPINTR	  : out  std_logic; -- Clock Stopped Interrupt
  SCICLKACTINTR	  : out  std_logic; -- Clock Active Interrupt
  SCITXTIDEINTR	  : out  std_logic; -- Transmit FIFO Tide level
                                    -- Interrupt
  SCIRXTIDEINTR	  : out  std_logic; -- Receive  FIFO Tide level
                                    -- Interrupt
  SCIINTR         : out  std_logic; -- Combined interrupt 
  SCITXDMASREQ	  : out  std_logic; -- TX DMA Single Request
  SCITXDMABREQ	  : out  std_logic; -- TX DMA Burst  Request
  SCIRXDMASREQ	  : out  std_logic; -- RX DMA Single Request
  SCIRXDMABREQ	  : out  std_logic; -- RX DMA Burst  Request
  SCANOUTPCLK	  : out  std_logic; -- Scan Test Output PCLK
                                    -- domain
  SCANOUTSCICLK	  : out  std_logic  -- Scan Test Output SCICLK
                                    -- domain
  );
  end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant SCICLK_PERIOD    : time := 100 ns;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal PRDATAUUT        : std_logic_vector(31 downto 0);
signal PRDATARPC        : std_logic_vector(31 downto 0);
signal nFIQInt          : std_logic := '1';
signal nIRQInt          : std_logic := '1';

-- ---------------------------------------------------------------------
-- SCI Signals
-- ---------------------------------------------------------------------

signal SCICLK           : std_logic := '0';
signal nSCIRST          : std_logic;
signal SCITXDMACLR      : std_logic; 
signal SCIRXDMACLR	: std_logic; 
signal SCANENABLE       : std_logic; 
signal SCANINPCLK	: std_logic; 
signal SCANINSCICLK	: std_logic; 
signal SCICARDININTR	: std_logic; 
signal SCICARDOUTINTR   : std_logic; 
signal SCICARDUPINTR	: std_logic; 
signal SCICARDDNINTR	: std_logic; 
signal SCITXERRINTR	: std_logic; 
signal SCIATRSTOUTINTR  : std_logic; 
signal SCIATRDTOUTINTR  : std_logic; 
signal SCIBLKTOUTINTR   : std_logic; 
signal SCICHTOUTINTR	: std_logic; 
signal SCIRTOUTINTR	: std_logic; 
signal SCIRORINTR	: std_logic; 
signal SCICLKSTPINTR	: std_logic; 
signal SCICLKACTINTR	: std_logic; 
signal SCITXTIDEINTR	: std_logic; 
signal SCIRXTIDEINTR	: std_logic; 
signal SCIINTR          : std_logic; 
signal SCITXDMASREQ	: std_logic; 
signal SCITXDMABREQ	: std_logic; 
signal SCIRXDMASREQ	: std_logic; 
signal SCIRXDMABREQ	: std_logic; 
signal SCANOUTPCLK	: std_logic; 
signal SCANOUTSCICLK	: std_logic;  
signal nSCIRST1         : std_logic;
signal nSCIRST2         : std_logic;
  
-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Tie down non-primary inputs to the SCI to prevent X-propagation
-- during netlist simulations.
-- ---------------------------------------------------------------------
SCITXDMACLR     <= '0';
SCIRXDMACLR     <= '0';
SCANENABLE      <= '0';
SCANINPCLK      <= '0';
SCANINSCICLK    <= '0';

SCICLK <= not SCICLK after SCICLK_PERIOD/2;

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
PRDATAUUT(31 downto 16) <= (others => '0');

-- ---------------------------------------------------------------------
-- Create nSCIRST by synchronising the negation to SCICLK
-- ---------------------------------------------------------------------
  p_nSCIRST1 : process(PRESETn, SCICLK)
  begin
    if (PRESETn = '0') then
      nSCIRST1 <= '0';
    elsif (SCICLK'event and SCICLK = '1') then
      nSCIRST1 <= '1';
    end if;
  end process p_nSCIRST1;
  
  p_nSCIRST2 : process(PRESETn, SCICLK)
  begin
    if (PRESETn = '0') then
      nSCIRST2 <= '0';
    elsif (SCICLK'event and SCICLK = '1') then
      nSCIRST2 <= nSCIRST1;
    end if;
  end process p_nSCIRST2;

  p_nSCIRST3 : process(PRESETn, SCICLK)
  begin
    if (PRESETn = '0') then
      nSCIRST <= '0';
    elsif (SCICLK'event and SCICLK = '1') then
      nSCIRST <= nSCIRST2;
    end if;
  end process p_nSCIRST3;


-- ---------------------------------------------------------------------
-- SCI PL131 Smart Card Interface 
-- ---------------------------------------------------------------------

  Uut : Sci
  port map (

  PCLK            => PCLK,
  SCICLK          => SCICLK,
  PRESETn         => PRESETn,
  nSCIRST         => nSCIRST,
  PSEL            => PSELUUT,
  PENABLE         => PENABLE,
  PWRITE          => PWRITE,
  PADDR           => PADDR(11 downto 2),

  PWDATA          => PWDATA(15 downto 0),

  SCIDATAIN       => SCIDATAIN,
  SCICLKIN        => SCICLKIN,
  SCIDETECT       => SCIDETECT,

  SCIDEACREQ      => SCIDEACREQ,
  SCITXDMACLR     => SCITXDMACLR,
  SCIRXDMACLR	  => SCIRXDMACLR,
  
  SCANENABLE	  => SCANENABLE,
  SCANINPCLK	  => SCANINPCLK,
  SCANINSCICLK	  => SCANINSCICLK,

  nSCIDATAOUTEN	  => nSCIDATAOUTEN,
  nSCIDATAEN	  => nSCIDATAEN,
  SCICLKOUT       => SCICLKOUT,
  nSCICLKOUTEN	  => nSCICLKOUTEN,
  nSCICLKEN       => nSCICLKEN,
                                   
  nSCICARDRST	  => nSCICARDRST,
  SCIFCB          => SCIFCB,
  SCIVCCEN        => SCIVCCEN,
  SCIDEACACK	  => SCIDEACACK,
  PRDATA          => PRDATAUUT(15 downto 0),

  SCICARDININTR	  => SCICARDININTR,
  SCICARDOUTINTR  => SCICARDOUTINTR,
  SCICARDUPINTR	  => SCICARDUPINTR,
  SCICARDDNINTR	  => SCICARDDNINTR,
  SCITXERRINTR	  => SCITXERRINTR,
  SCIATRSTOUTINTR => SCIATRSTOUTINTR, 
  SCIATRDTOUTINTR => SCIATRDTOUTINTR,
  SCIBLKTOUTINTR  => SCIBLKTOUTINTR, 
  SCICHTOUTINTR	  => SCICHTOUTINTR,
  SCIRTOUTINTR	  => SCIRTOUTINTR,
  SCIRORINTR	  => SCIRORINTR,
  SCICLKSTPINTR	  => SCICLKSTPINTR,
  SCICLKACTINTR	  => SCICLKACTINTR,
  SCITXTIDEINTR	  => SCITXTIDEINTR,
  SCIRXTIDEINTR	  => SCIRXTIDEINTR,
  SCIINTR         => SCIINTR,
  
  SCITXDMASREQ	  => SCITXDMASREQ,
  SCITXDMABREQ	  => SCITXDMABREQ,
  SCIRXDMASREQ	  => SCIRXDMASREQ,
  SCIRXDMABREQ	  => SCIRXDMABREQ,
  SCANOUTPCLK	  => SCANOUTPCLK,
  SCANOUTSCICLK	  => SCANOUTSCICLK
    );
  
end Structural;

-- --============================== End ==============================--
