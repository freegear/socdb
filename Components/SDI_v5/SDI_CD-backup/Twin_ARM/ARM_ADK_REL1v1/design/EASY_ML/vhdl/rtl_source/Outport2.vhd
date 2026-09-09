--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : Outport2.vhd,v
--  File Revision       : 1.9
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Structural sub-block architecture of Example Amba 
--                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
--                        Outport 2. 
--
--                        The module contains the following AHB device:
--                       
--                          - APBif
--
--                        The module contains the following APB devices:
--
--                          - Peripheral to bridge mux (MuxP2B)
--                          - Watchdog
--                          - Timers
--                          - GPIO PrimeCell (PL061)
--                          - Remap and Pause controller
--                          - Example APB Slave
--
--                        HREADYOUT is looped back to HREADY as the APBif
--                        is the only AHB slave in this module.
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- pragma translate_off
library ElementsAHB;
use ElementsAHB.all;
library ElementsAPB;
use ElementsAPB.all;
library Watchdog;
use Watchdog.all;
library Timers;
use Timers.all;
library GPIO_pl061;
use GPIO_pl061.all;
library RemapPause;
use RemapPause.all;
library EgAPBSlave;
use EgAPBSlave.all;
-- pragma translate_on

entity Outport2 is
  port(
    -- Common AHB signals
    HCLK        : in  std_logic;
    HRESETn     : in  std_logic;

    -- Matrix AHB connections
    HADDR       : in  std_logic_vector(31 downto 0);
    HBURST      : in  std_logic_vector(2 downto 0);
    HPROT       : in  std_logic_vector(3 downto 0);
    HREADYmtrx  : in  std_logic;
    HSELmtrx    : in  std_logic;
    HSIZE       : in  std_logic_vector(2 downto 0);
    HTRANS      : in  std_logic_vector(1 downto 0);
    HWDATA      : in  std_logic_vector(31 downto 0);
    HWRITE      : in  std_logic;

    HRDATA      : out std_logic_vector(31 downto 0);
    HREADYOUT   : out std_logic;
    HRESP       : out std_logic_vector(1 downto 0);

    -- Timer signals 
    TIMINT1     : out std_logic;
    TIMINT2     : out std_logic;
    TIMINTC     : out std_logic;

    -- Watchdog signals
    WDOGRESn    : in  std_logic;
    WDOGRES     : out std_logic;
    WDOGINT     : out std_logic;
    
    -- Processor interrupts
    nFIQ        : in  std_logic;
    nIRQ        : in  std_logic;

    -- Remap/Pause control signals
    Pause       : out std_logic;
    Remap       : out std_logic;

    -- GPIO signals
    GPIN        : in  std_logic_vector(7 downto 0);
    nGPAFEN     : in  std_logic_vector(7 downto 0);
    GPAFOUT     : in  std_logic_vector(7 downto 0);
    GPOUT       : out std_logic_vector(7 downto 0);
    nGPEN       : out std_logic_vector(7 downto 0);
    GPAFIN      : out std_logic_vector(7 downto 0);
    GPIOINTR    : out std_logic;
    GPIOMIS     : out std_logic_vector(7 downto 0);

    -- Scan test dummy signals; not connected until scan insertion 
    SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
    SCANINHCLK  : in  std_logic; -- Scan Chain Input (HCLK)
    SCANOUTHCLK : out std_logic; -- Scan Chain Output (HCLK)
    SCANINPCLK  : in  std_logic; -- Scan Chain Input (PCLK)
    SCANOUTPCLK : out std_logic  -- Scan Chain Output (PCLK)
    );
end outport2;

architecture structural of Outport2 is

--------------------------------------------------------------------------------
-- Components: Module specific (AHB)
--------------------------------------------------------------------------------

-- AHB to APB Bridge
  component APBif
    port(
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      HADDR       : in  std_logic_vector(27 downto 0);
      HTRANS      : in  std_logic_vector(1 downto 0);
      HWRITE      : in  std_logic;
      HWDATA      : in  std_logic_vector(31 downto 0);
      HSEL        : in  std_logic;
      HREADY      : in  std_logic;
      
      HRDATA      : out std_logic_vector(31 downto 0);
      HREADYOUT   : out std_logic;
      HRESP       : out std_logic_vector(1 downto 0);
      
      PRDATA      : in  std_logic_vector(31 downto 0); 
  
      PWDATA      : out std_logic_vector(31 downto 0);
      PADDR       : out std_logic_vector(23 downto 0);
      PWRITE      : out std_logic;
      PENABLE     : out std_logic;
      PSELS0      : out std_logic;
      PSELS1      : out std_logic;
      PSELS2      : out std_logic;
      PSELS3      : out std_logic;
      PSELS4      : out std_logic;
      PSELS5      : out std_logic;
      PSELS6      : out std_logic;
      PSELS7      : out std_logic;
      PSELS8      : out std_logic;
      PSELS9      : out std_logic;
      PSELS10     : out std_logic;
      PSELS11     : out std_logic;
      PSELS12     : out std_logic;
      PSELS13     : out std_logic;
      PSELS14     : out std_logic;
      PSELS15     : out std_logic;

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output    
      );
  end component;


--------------------------------------------------------------------------------
-- Components: Common APB Infrastructure
--------------------------------------------------------------------------------

-- Central multiplexer - peripherals to bridge
  component MuxP2B
    port(
      PSELS0    : in  std_logic;
      PSELS1    : in  std_logic;
      PSELS2    : in  std_logic;
      PSELS3    : in  std_logic;
      PSELS4    : in  std_logic;
      PSELS5    : in  std_logic;
      PSELS6    : in  std_logic;
      PSELS7    : in  std_logic;
      PSELS8    : in  std_logic;
      PSELS9    : in  std_logic;
      PSELS10   : in  std_logic;
      PSELS11   : in  std_logic;
      PSELS12   : in  std_logic;
      PSELS13   : in  std_logic;
      PSELS14   : in  std_logic;
      PSELS15   : in  std_logic;
  
      PRDATAS0  : in  std_logic_vector(31 downto 0);
      PRDATAS1  : in  std_logic_vector(31 downto 0);
      PRDATAS2  : in  std_logic_vector(31 downto 0);
      PRDATAS3  : in  std_logic_vector(31 downto 0);
      PRDATAS4  : in  std_logic_vector(31 downto 0);
      PRDATAS5  : in  std_logic_vector(31 downto 0);
      PRDATAS6  : in  std_logic_vector(31 downto 0);
      PRDATAS7  : in  std_logic_vector(31 downto 0);
      PRDATAS8  : in  std_logic_vector(31 downto 0);
      PRDATAS9  : in  std_logic_vector(31 downto 0);
      PRDATAS10 : in  std_logic_vector(31 downto 0);
      PRDATAS11 : in  std_logic_vector(31 downto 0);
      PRDATAS12 : in  std_logic_vector(31 downto 0);
      PRDATAS13 : in  std_logic_vector(31 downto 0);
      PRDATAS14 : in  std_logic_vector(31 downto 0);
      PRDATAS15 : in  std_logic_vector(31 downto 0);
  
      PRDATA    : out std_logic_vector(31 downto 0)
      );
  end component;


--------------------------------------------------------------------------------
-- Components: Module specific Peripherals (APB)
--------------------------------------------------------------------------------

-- Watchdog timer module
  component Watchdog
    port(
      PCLK        : in  std_logic;
      PRESETn     : in  std_logic;

      PENABLE     : in  std_logic;
      PSEL        : in  std_logic;
      PADDR       : in  std_logic_vector(11 downto 2);
      PWRITE      : in  std_logic;
      PWDATA      : in  std_logic_vector(31 downto 0);
      PRDATA      : out std_logic_vector(31 downto 0);
      
      WDOGCLK     : in  std_logic; -- Watchdog clock
      WDOGCLKEN   : in  std_logic; -- Watchdog clock enable
      WDOGRESn    : in  std_logic; -- Watchdog clock reset
      WDOGINT     : out std_logic; -- Watchdog interrupt
      WDOGRES     : out std_logic; -- Watchdog timeout reset
      
      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINPCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTPCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- Timers module
  component Timers
    port(
      PCLK        : in  std_logic;
      PRESETn     : in  std_logic;

      PENABLE     : in  std_logic;
      PSEL        : in  std_logic;
      PADDR       : in  std_logic_vector(11 downto 2); 
      PWRITE      : in  std_logic; 
      PWDATA      : in  std_logic_vector(31 downto 0);
      PRDATA      : out std_logic_vector(31 downto 0);
      
      TIMCLK      : in  std_logic; -- Timer clock
      TIMCLKEN1   : in  std_logic; -- Timer clock enable 1
      TIMCLKEN2   : in  std_logic; -- Timer clock enable 2
      TIMINT1     : out std_logic; -- Counter 1 interrupt
      TIMINT2     : out std_logic; -- Counter 2 interrupt
      TIMINTC     : out std_logic; -- Counter combined interrupt
      
      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINPCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTPCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- General Purpose Input/Output (PrimeCell PL061)
  component Gpio
    port(
      -- Inputs  
      -- APB bus signals
      PCLK        : in  std_logic;
      PRESETn     : in  std_logic;

      PSEL        : in  std_logic;
      PENABLE     : in  std_logic;
      PWRITE      : in  std_logic;
      PWDATA      : in  std_logic_vector(7 downto 0);
      PADDR       : in  std_logic_vector(11 downto 2);
      -- GPIO lines onto the Pads 
      GPIN        : in  std_logic_vector(7 downto 0);
      -- Alternate functionality lines
      nGPAFEN     : in  std_logic_vector(7 downto 0);
      GPAFOUT     : in  std_logic_vector(7 downto 0);
      
      -- Outputs
      -- APB bus signals
      PRDATA      : out std_logic_vector(7 downto 0);
      -- GPIO lines onto the Pads
      nGPEN       : out std_logic_vector(7 downto 0);
      GPOUT       : out std_logic_vector(7 downto 0);
      -- Alternate functionality lines 
      GPAFIN      : out std_logic_vector(7 downto 0);
      -- Interrupt output to the Interrupt controller
      GPIOINTR    : out std_logic;
      GPIOMIS     : out std_logic_vector(7 downto 0);
      
      -- Scan test dummy signals; not connected until scan insertion
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINPCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTPCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- Remap and Pause controller
  component RemapPause
    port(
      PCLK        : in  std_logic;
      PRESETn     : in  std_logic;

      PENABLE     : in  std_logic;
      PSELRPC     : in  std_logic;
      PADDR       : in  std_logic_vector(5 downto 2);
      PWRITE      : in  std_logic;
      PWDATA      : in  std_logic_vector(7 downto 0);
      PRDATA      : out std_logic_vector(7 downto 0);
      
      nFIQ        : in  std_logic; -- FIQ interrupt input
      nIRQ        : in  std_logic; -- IRQ interrupt input

      Pause       : out std_logic; -- Pause mode entered
      Remap       : out std_logic; -- Reset memory map in use

      -- Scan test dummy signals; not connected until scan insertion
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINPCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTPCLK : out std_logic  -- Scan Chain Output
      );
  end component;

-- Example APB Slave
  component EgAPBSlave
    port(
      PCLK        : in  std_logic;
      PRESETn     : in  std_logic;

      PENABLE     : in  std_logic;
      PSEL        : in  std_logic;
      PWRITE      : in  std_logic;
      PADDR       : in  std_logic_vector(11 downto 2);
      PRDATA      : out std_logic_vector(31 downto 0);
      PWDATA      : in  std_logic_vector(31 downto 0);
      
      -- Scan test dummy signals; not connected until scan insertion
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINPCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTPCLK : out std_logic  -- Scan Chain Output
      );
  end component;


--------------------------------------------------------------------------------
-- Signal declarations: AHB
--------------------------------------------------------------------------------

-- AHB signal
  signal iHREADYOUT : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: APB
--------------------------------------------------------------------------------

-- APB backbone
  signal PENABLE : std_logic;
  signal PADDR   : std_logic_vector(23 downto 0);
  signal PWRITE  : std_logic;
  signal PWDATA  : std_logic_vector(31 downto 0);
  signal PRDATA  : std_logic_vector(31 downto 0);

-- Slave-specific APB signals
  signal PSELS0  : std_logic;
  signal PSELS1  : std_logic;
  signal PSELS2  : std_logic;
  signal PSELS3  : std_logic;
  signal PSELS4  : std_logic;
  signal PSELS5  : std_logic;
  signal PSELS6  : std_logic;
  signal PSELS7  : std_logic;
  signal PSELS8  : std_logic;
  signal PSELS9  : std_logic;
  signal PSELS10 : std_logic;
  signal PSELS11 : std_logic;
  signal PSELS12 : std_logic;
  signal PSELS13 : std_logic;
  signal PSELS14 : std_logic;
  signal PSELS15 : std_logic;

  signal PRDATAS0  : std_logic_vector(31 downto 0);
  signal PRDATAS1  : std_logic_vector(31 downto 0);
  signal PRDATAS2  : std_logic_vector(31 downto 0);
  signal PRDATAS3  : std_logic_vector(31 downto 0);
  signal PRDATAS4  : std_logic_vector(31 downto 0);
  signal PRDATAS5  : std_logic_vector(31 downto 0);
  signal PRDATAS6  : std_logic_vector(31 downto 0);
  signal PRDATAS7  : std_logic_vector(31 downto 0);
  signal PRDATAS8  : std_logic_vector(31 downto 0);
  signal PRDATAS9  : std_logic_vector(31 downto 0);
  signal PRDATAS10 : std_logic_vector(31 downto 0);
  signal PRDATAS11 : std_logic_vector(31 downto 0);
  signal PRDATAS12 : std_logic_vector(31 downto 0);
  signal PRDATAS13 : std_logic_vector(31 downto 0);
  signal PRDATAS14 : std_logic_vector(31 downto 0);
  signal PRDATAS15 : std_logic_vector(31 downto 0);


--------------------------------------------------------------------------------
-- Signal declarations: Scan chain
--------------------------------------------------------------------------------

  signal SCANINtimers  : std_logic;
  signal SCANOUTtimers : std_logic;
  signal SCANINwdog    : std_logic;
  signal SCANOUTwdog   : std_logic;
  signal SCANINgpio    : std_logic;
  signal SCANOUTgpio   : std_logic;
  signal SCANINegapb   : std_logic;
  signal SCANOUTegapb  : std_logic;
  signal SCANINrpc     : std_logic;
  signal SCANOUTrpc    : std_logic;
  signal SCANINapbif   : std_logic;
  signal SCANOUTapbif  : std_logic;

  
--------------------------------------------------------------------------------
-- Signal declarations: Tie-offs
--------------------------------------------------------------------------------

  signal TieOffHi1  : std_logic;
  signal TieOffLo32 : std_logic_vector(31 downto 0);


--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------

begin

-- The TieOff signals must be assigned explicitly within the body of the VHDL.
-- Using initial values (in the signal declaration, above) will not work in
--  Synopsys. Signals are used rather than constants as constants can not be 
--  connected directly to sub-component instantiations
  TieOffHi1  <= '1';
  TieOffLo32 <= (others => '0');


-- AHB to APB Bridge instantiated as AHB slave 12
  uAPBif : APBif
    port map(
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      HADDR       => HADDR(27 downto 0),
      HTRANS      => HTRANS,
      HWRITE      => HWRITE,
      HWDATA      => HWDATA,
      HSEL        => HSELmtrx,    -- Active when module selected (slot 12)
      HREADY      => iHREADYOUT,  -- HREADYOUT is fed-back
      
      HRDATA      => HRDATA,      -- Channel 1 of MuxS2M
      HREADYOUT   => iHREADYOUT,
      HRESP       => HRESP,  
      
      PRDATA      => PRDATA,      -- From MuxP2B output
  
      PWDATA      => PWDATA,
      PADDR       => PADDR,
      PWRITE      => PWRITE,
      PENABLE     => PENABLE,
      PSELS0      => PSELS0,
      PSELS1      => PSELS1,
      PSELS2      => PSELS2,
      PSELS3      => PSELS3,
      PSELS4      => PSELS4,
      PSELS5      => PSELS5,
      PSELS6      => PSELS6,
      PSELS7      => PSELS7,
      PSELS8      => PSELS8,
      PSELS9      => PSELS9,
      PSELS10     => PSELS10,
      PSELS11     => PSELS11,
      PSELS12     => PSELS12,
      PSELS13     => PSELS13,
      PSELS14     => PSELS14,
      PSELS15     => PSELS15,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINapbif,
      SCANOUTHCLK => SCANOUTapbif
      );

  -- Connect internal signal to port
  HREADYOUT <= iHREADYOUT;


-- Local multiplexer - peripherals to bridge
  uMuxP2B : MuxP2B
    port map(
      PSELS0    => PSELS0,
      PSELS1    => PSELS1,
      PSELS2    => PSELS2,
      PSELS3    => PSELS3,
      PSELS4    => PSELS4,
      PSELS5    => PSELS5,
      PSELS6    => PSELS6,
      PSELS7    => PSELS7,
      PSELS8    => PSELS8,
      PSELS9    => PSELS9,
      PSELS10   => PSELS10,
      PSELS11   => PSELS11,
      PSELS12   => PSELS12,
      PSELS13   => PSELS13,
      PSELS14   => PSELS14,
      PSELS15   => PSELS15,
      
      PRDATAS0  => PRDATAS0,
      PRDATAS1  => PRDATAS1,
      PRDATAS2  => PRDATAS2,
      PRDATAS3  => PRDATAS3,
      PRDATAS4  => PRDATAS4,
      PRDATAS5  => PRDATAS5,
      PRDATAS6  => PRDATAS6,
      PRDATAS7  => PRDATAS7,
      PRDATAS8  => PRDATAS8,
      PRDATAS9  => PRDATAS9,
      PRDATAS10 => PRDATAS10,
      PRDATAS11 => PRDATAS11,
      PRDATAS12 => PRDATAS12,
      PRDATAS13 => PRDATAS13,
      PRDATAS14 => PRDATAS14,
      PRDATAS15 => PRDATAS15,
      
      PRDATA    => PRDATA
      );

  -- Tie off unused APB slave data paths
  PRDATAS0  <= TieOffLo32;
  -- PRDATAS1  <= TieOffLo32;           -- Watchdog
  -- PRDATAS2  <= TieOffLo32;           -- Timers
  PRDATAS3  <= TieOffLo32;
  -- PRDATAS4  <= TieOffLo32;           -- GPIO
  PRDATAS5  <= TieOffLo32;
  PRDATAS6  <= TieOffLo32;
  PRDATAS7  <= TieOffLo32;
  -- PRDATAS8  <= TieOffLo32;           -- Remap/Pause
  PRDATAS9  <= TieOffLo32;
  PRDATAS10 <= TieOffLo32;
  PRDATAS11 <= TieOffLo32;
  PRDATAS12 <= TieOffLo32;
  PRDATAS13 <= TieOffLo32;
  PRDATAS14 <= TieOffLo32;
  -- PRDATAS15 <= TieOffLo32;           -- Example APB Slave


-- Watchdog timer module instantiated as APB slave 1
  uWatchdog : Watchdog
    port map(
      PCLK        => HCLK,
      PRESETn     => HRESETn,

      PENABLE     => PENABLE,
      PSEL        => PSELS1,
      PADDR       => PADDR(11 downto 2),
      PWRITE      => PWRITE,
      PWDATA      => PWDATA,
      PRDATA      => PRDATAS1,
      
      WDOGCLK     => HCLK,
      WDOGCLKEN   => TieOffHi1,
      WDOGRESn    => WDOGRESn,
      WDOGINT     => WDOGINT,
      WDOGRES     => WDOGRES,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINPCLK  => SCANINwdog,
      SCANOUTPCLK => SCANOUTwdog
      );


-- Timers module instantiated as APB slave 2
  uTimers : Timers
    port map(
      PCLK        => HCLK,
      PRESETn     => HRESETn,

      PENABLE     => PENABLE,
      PSEL        => PSELS2,
      PADDR       => PADDR(11 downto 2),
      PWRITE      => PWRITE,
      PWDATA      => PWDATA,
      PRDATA      => PRDATAS2,
      
      TIMCLK      => HCLK,
      TIMCLKEN1   => TieOffHi1,
      TIMCLKEN2   => TieOffHi1,
      TIMINT1     => TIMINT1,
      TIMINT2     => TIMINT2,
      TIMINTC     => TIMINTC,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINPCLK  => SCANINtimers,
      SCANOUTPCLK => SCANOUTtimers
      );


-- General Purpose Input/Output module instantiated as APB slave 4
  uGpio: Gpio
    port map(
      PCLK        => HCLK,
      PRESETn     => HRESETn,

      PSEL        => PSELS4,
      PENABLE     => PENABLE,
      PWRITE      => PWRITE,
      PWDATA      => PWDATA(7 downto 0),
      PADDR       => PADDR(11 downto 2),

      GPIN        => GPIN,
      nGPAFEN     => nGPAFEN,
      GPAFOUT     => GPAFOUT,
      PRDATA      => PRDATAS4(7 downto 0),
      nGPEN       => nGPEN,
      GPOUT       => GPOUT,
      GPAFIN      => GPAFIN,
      GPIOINTR    => GPIOINTR,
      GPIOMIS     => GPIOMIS,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINPCLK  => SCANINgpio,
      SCANOUTPCLK => SCANOUTgpio
      );

  -- Drive unused output read-data bits LOW.
  PRDATAS4(31 downto 8) <= (others => '0');


-- Remap and Pause controller instantiated as APB slave 8
  uRemapPause : RemapPause
    port map(
      PCLK        => HCLK,
      PRESETn     => HRESETn,

      PENABLE     => PENABLE,
      PSELRPC     => PSELS8,
      PADDR       => PADDR(5 downto 2),
      PWRITE      => PWRITE,
      PWDATA      => PWDATA(7 downto 0),
      PRDATA      => PRDATAS8(7 downto 0),
      
      nFIQ        => nFIQ,
      nIRQ        => nIRQ,

      Pause       => Pause,
      Remap       => Remap,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINPCLK  => SCANINrpc,
      SCANOUTPCLK => SCANOUTrpc
      );

  -- Drive unused output read-data bits LOW.
  PRDATAS8(31 downto 8) <= (others => '0');


-- Example APB Slave instantiated as APB slave 15
  uEgAPBSlave : EgAPBSlave
    port map(
      PCLK        => HCLK,
      PRESETn     => HRESETn,

      PENABLE     => PENABLE,
      PSEL        => PSELS15,
      PWRITE      => PWRITE,
      PADDR       => PADDR(11 downto 2),
      PRDATA      => PRDATAS15,
      PWDATA      => PWDATA,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINPCLK  => SCANINegapb,
      SCANOUTPCLK => SCANOUTegapb
      );


end structural;

-- --================================= End ===================================--

