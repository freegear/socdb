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
--  File Name           : Outport1.vhd,v
--  File Revision       : 1.7
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Structural sub-block architecture of Example Amba 
--                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
--                        Outport 1. The module contains the following AHB 
--                        device:
--                      
--                          - Interrupt controller
--                        
--                        HREADYOUT is looped back to HREADY as the interrupt
--                        controller is the only slave in this module.
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- pragma translate_off
library Interrupt;
use Interrupt.all;
-- pragma translate_on

entity Outport1 is
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

    -- Peripheral interrupt sources
    WDOGINT     : in  std_logic;
    TIMINTC     : in  std_logic;
    TIMINT2     : in  std_logic;
    TIMINT1     : in  std_logic;
    GPIOMIS     : in  std_logic_vector(7 downto 0);
    GPIOINTR    : in  std_logic;
    
    -- Processor interrupts
    nICFIQ      : out std_logic;
    nICIRQ      : out std_logic;

    -- Scan test dummy signals; not connected until scan insertion
    SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
    SCANINHCLK  : in  std_logic; -- Scan Chain Input
    SCANOUTHCLK : out std_logic  -- Scan Chain Output
    );
end Outport1;

architecture structural of Outport1 is

--------------------------------------------------------------------------------
-- Components: Module specific (AHB)
--------------------------------------------------------------------------------

-- Non-vectored Interrupt Controller
  component Interrupt
    port(
      -- Inputs
        HCLK             : in  std_logic; -- AHB Clock
        HRESETn          : in  std_logic; -- AHB Reset
        HSELIC           : in  std_logic; -- Interrupt Controller select
        HWRITE           : in  std_logic; -- AHB Write
        HREADY           : in  std_logic; -- Shared HREADY line
        HPROT            : in  std_logic; -- Protection mode
        HTRANS           : in  std_logic; -- Bit 1 of HTRANS
        HSIZE            : in  std_logic_vector(2 downto 0);
                                          -- AHB transfer size
        ICINTSOURCE      : in  std_logic_vector(31 downto 0);
                                          -- Interrupt source
        nICFIQIN         : in  std_logic; -- Fast interrupt input
        nICIRQIN         : in  std_logic; -- Normal interrupt input
        ICVECTADDRIN     : in  std_logic_vector(31 downto 0);
                                          -- Vector Address input
        SCANENABLE       : in  std_logic; -- Scan Enable
        SCANINHCLK       : in  std_logic; -- HCLK domain Scan input
        HWDATA           : in  std_logic_vector(31 downto 0);
                                          -- AHB write data bus
        HADDR            : in  std_logic_vector(11 downto 2);
                                          -- AHB address bus
      -- Outputs
        HREADYOUT        : out std_logic; -- IC ready signal
        HRESP            : out std_logic_vector(1 downto 0);
                                          -- AHB transfer response
        nICFIQ           : out std_logic; -- Fast Interrupt request
        nICIRQ           : out std_logic; -- Normal Interrupt request
        ICVECTADDROUT    : out std_logic_vector(31 downto 0);
                                          -- Vector Address output
        SCANOUTHCLK      : out std_logic; -- HLCK domain Scan output
        HRDATA           : out std_logic_vector(31 downto 0)
                                          -- AHB Read data bus
        );
  end component;


--------------------------------------------------------------------------------
-- Signal declarations: Module specific and AHB
--------------------------------------------------------------------------------

  signal IntSource     : std_logic_vector(31 downto 0);
  signal ICVECTADDROUT : std_logic_vector(31 downto 0);
  signal iHREADYOUT    : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: Scan chain
--------------------------------------------------------------------------------
  
  signal SCANINic  : std_logic;
  signal SCANOUTic : std_logic;

  
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


-- Interrupt Controller instantiated as AHB slave 15
  uInterrupt : Interrupt
    port map(
      HCLK          => HCLK,
      HRESETn       => HRESETn,

      HSELIC        => HSELmtrx,   -- Active when module selected (slot 15)
      HWRITE        => HWRITE,
      HREADY        => iHREADYOUT, -- HREADYOUT is fed-back
      HPROT         => HPROT(1),   -- Privileged access
      HTRANS        => HTRANS(1),
      HSIZE         => HSIZE,
      ICINTSOURCE   => IntSource,  -- System interrupts
      nICFIQIN      => TieOffHi1,  -- Connect daisy-chained 
      nICIRQIN      => TieOffHi1,  --  interrupt controllers here
      ICVECTADDRIN  => TieOffLo32,
      HWDATA        => HWDATA,
      HADDR         => HADDR(11 downto 2),
      HREADYOUT     => iHREADYOUT,
      HRESP         => HRESP,
      HRDATA        => HRDATA,
      nICFIQ        => nICFIQ,
      nICIRQ        => nICIRQ,
      ICVECTADDROUT => ICVECTADDROUT,  -- Not used

      -- Scan signals    
      SCANENABLE    => SCANENABLE,
      SCANINHCLK    => SCANINic,
      SCANOUTHCLK   => SCANOUTic
      );

  -- Concatenate individual interrupt lines to form one bus
  IntSource <= 
      GPIOMIS   -- 31:24 GPIO Masked interrupts
    & "0000"    -- 23:20
    & "0000"    -- 19:16
    & "0000"    -- 15:12
    & "000"     -- 11:9
    & GPIOINTR  -- 8     GPIO Combined interrupt
    & WDOGINT   -- 7     Watchdog
    & TIMINTC   -- 6     Counter combined
    & TIMINT2   -- 5     Counter 2
    & TIMINT1   -- 4     Counter 1
    & '0'       -- 3     Undefined (ARM Comms Tx)
    & '0'       -- 2     Undefined (ARM Comms Rx)
    & '0'       -- 1     Software interrupt
    & '0';      -- 0     Undefined


  -- Connect internal signal to port
  HREADYOUT <= iHREADYOUT;


end structural;

-- --================================= End ===================================--

