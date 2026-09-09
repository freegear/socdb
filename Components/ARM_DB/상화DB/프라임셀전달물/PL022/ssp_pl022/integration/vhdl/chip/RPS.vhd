-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
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
-- Release Information    : PrimeCell(TM)-PL022-REL1v2
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

        -- SSP - Primary I/O Test Trickbox connections
        SSPRXD           : in std_logic;
        SSPCLKIN         : in std_logic;
        SSPFSSIN         : in std_logic;

        SSPTXD           : out std_logic;
        SSPCLKOUT        : out std_logic;
        SSPFSSOUT        : out std_logic;
        nSSPCTLOE        : out std_logic;
        nSSPOE           : out std_logic
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
-- The SSP PL022 Synchronous Serilal Port
-- ---------------------------------------------------------------------    
component Ssp
 port (
      PCLK          : in  std_logic;   -- APB Bus Clock
      SSPCLK        : in  std_logic;   -- Main SSP Clock
      
      PRESETn       : in  std_logic;   -- AMBA APB Bus Reset
      nSSPRST       : in  std_logic;   -- SSP Reset
      
      PSEL          : in  std_logic;   -- APB Peripheral select
      PENABLE       : in  std_logic;   -- APB Peripheral enable
      PWRITE        : in  std_logic;   -- APB Peripheral write
      
      SSPRXD        : in  std_logic;   -- SSP Receive input
      SSPCLKIN      : in  std_logic;   -- SSP Clock input
      SSPFSSIN      : in  std_logic;   -- SSP Frame input
      
      SCANENABLE    : in  std_logic;   -- Scan Enable
      SCANINPCLK    : in  std_logic;   -- Scan Input signal in PCLK domain
      SCANINSSPCLK  : in  std_logic;   -- Scan Input signal in SSPCLK domain
      
      PADDR         : in  std_logic_vector(11 downto 2);
                                       -- APB Addr
      PWDATA        : in  std_logic_vector(15 downto 0);       
                                       -- APB Write databus
      SSPTXDMACLR   : in  std_logic;   -- DMA clear signal
      SSPRXDMACLR   : in  std_logic;   -- DMA clear signal
     
      SSPINTR       : out std_logic;   -- Combined Interrupt
      SSPRXINTR     : out std_logic;   -- Receive FIFO Service Request
      SSPTXINTR     : out std_logic;   -- Transmit FIFO Service Request
      SSPRORINTR    : out std_logic;   -- Rx FIFO Overrun Interrupt
      SSPRTINTR     : out std_logic;   -- Rx Time Out Interrupt
      
      SSPFSSOUT     : out std_logic;   -- Serial Frame Output pin
      SSPCLKOUT     : out std_logic;   -- Serial Clock Output pin
      
      SCANOUTPCLK   : out std_logic;   -- SCANOUT port in PCLK domain 
      SCANOUTSSPCLK : out std_logic;   -- SCANOUT port in SSPCLK domain

      SSPTXD        : out std_logic;   -- SSP Serial Transmit output
      nSSPOE        : out std_logic;   -- Output Enable for SSPTXD
      nSSPCTLOE     : out std_logic;   -- Output Enable for SCLKOUT and SFSSOUT
      
      PRDATA        : out std_logic_vector(15 downto 0);        
                                       -- Read databus

      SSPTXDMASREQ  : out std_logic;   -- Transmit DMA Single Request
      SSPTXDMABREQ  : out std_logic;   -- Transmit DMA Burst  Request
      SSPRXDMASREQ  : out std_logic;   -- Receive  DMA Single Request
      SSPRXDMABREQ  : out std_logic    -- Receive  DMA Burst  Request
     );
  end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant SSPCLK_PERIOD    : time := 100 ns;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

signal PRDATAUUT        : std_logic_vector(31 downto 0);
signal PRDATARPC        : std_logic_vector(31 downto 0);
signal nFIQInt          : std_logic := '1';
signal nIRQInt          : std_logic := '1';

-- ---------------------------------------------------------------------
-- SSP Signals
-- ---------------------------------------------------------------------

signal SSPCLK           : std_logic := '0';
signal nSSPRST          : std_logic;
signal SSPTXDMACLR      : std_logic;
signal SSPRXDMACLR      : std_logic;
signal SSPTXINTR        : std_logic;
signal SSPRXINTR        : std_logic;
signal SSPRORINTR       : std_logic;
signal SSPRTINTR        : std_logic;
signal SSPINTR          : std_logic;
signal SSPTXDMASREQ     : std_logic;
signal SSPTXDMABREQ     : std_logic;
signal SSPRXDMASREQ     : std_logic;
signal SSPRXDMABREQ     : std_logic;
signal SCANENABLE       : std_logic;
signal SCANINPCLK       : std_logic;
signal SCANINSSPCLK     : std_logic;
signal SCANOUTPCLK      : std_logic;
signal SCANOUTSSPCLK    : std_logic;
signal nSSPRST1         : std_logic;
signal nSSPRST2         : std_logic;
  
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
SSPTXDMACLR     <= '0';
SSPRXDMACLR     <= '0';
SCANENABLE      <= '0';
SCANINPCLK      <= '0';
SCANINSSPCLK    <= '0';

SSPCLK <= not SSPCLK after SSPCLK_PERIOD/2;

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
-- Create nSSPRST by synchronising the negation to SSPCLK
-- ---------------------------------------------------------------------
  p_nSSPRST1 : process(PRESETn, SSPCLK)
  begin
    if (PRESETn = '0') then
      nSSPRST1 <= '0';
    elsif (SSPCLK'event and SSPCLK = '1') then
      nSSPRST1 <= '1';
    end if;
  end process p_nSSPRST1;
  
  p_nSSPRST2 : process(PRESETn, SSPCLK)
  begin
    if (PRESETn = '0') then
      nSSPRST2 <= '0';
    elsif (SSPCLK'event and SSPCLK = '1') then
      nSSPRST2 <= nSSPRST1;
    end if;
  end process p_nSSPRST2;

  p_nSSPRST3 : process(PRESETn, SSPCLK)
  begin
    if (PRESETn = '0') then
      nSSPRST <= '0';
    elsif (SSPCLK'event and SSPCLK = '1') then
      nSSPRST <= nSSPRST2;
    end if;
  end process p_nSSPRST3;

-- ---------------------------------------------------------------------
-- SSP PL022 Synchronous Serial Port 
-- ---------------------------------------------------------------------
  uut : Ssp
  port map (

      PCLK          => PCLK,
      SSPCLK        => SSPCLK,
      
      PRESETn       => PRESETn,
      nSSPRST       => nSSPRST,
      
      PSEL          => PSELUUT,
      PENABLE       => PENABLE,
      PWRITE        => PWRITE,
      
      SSPRXD        => SSPRXD,
      SSPCLKIN      => SSPCLKIN,
      SSPFSSIN      => SSPFSSIN,
      
      SCANENABLE    => SCANENABLE,
      SCANINPCLK    => SCANINPCLK,
      SCANINSSPCLK  => SCANINSSPCLK,
      
      PADDR         => PADDR(11 downto 2),

      PWDATA        => PWDATA(15 downto 0),       

      SSPTXDMACLR   => SSPTXDMACLR,
      SSPRXDMACLR   => SSPRXDMACLR,
     
      SSPINTR       => SSPINTR,
      SSPRXINTR     => SSPRXINTR,
      SSPTXINTR     => SSPTXINTR,
      SSPRORINTR    => SSPRORINTR,
      SSPRTINTR     => SSPRTINTR,
      
      SSPFSSOUT     => SSPFSSOUT, 
      SSPCLKOUT     => SSPCLKOUT,
      
      SCANOUTPCLK   => SCANOUTPCLK,
      SCANOUTSSPCLK => SCANOUTSSPCLK,

      SSPTXD        => SSPTXD,
      nSSPOE        => nSSPOE,
      nSSPCTLOE     => nSSPCTLOE,
      
      PRDATA        => PRDATAUUT(15 downto 0),        


      SSPTXDMASREQ  => SSPTXDMASREQ,
      SSPTXDMABREQ  => SSPTXDMABREQ,
      SSPRXDMASREQ  => SSPRXDMASREQ,
      SSPRXDMABREQ  => SSPRXDMABREQ
    );
  
end Structural;

-- --============================== End ==============================--
