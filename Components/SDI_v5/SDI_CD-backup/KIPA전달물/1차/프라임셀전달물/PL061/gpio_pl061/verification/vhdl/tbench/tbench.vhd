------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : tbench.vhd.rca
--  File Revision          : 1.4
--  
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------
--
------------------------------------------------------------------------
--   Purpose : Top level of the Gpio Compliance TestBench 
--
--             This file instanciates the Gpio module, the Gpio trickbox
--             and the Read Data Mux. 
--             Free-running tests should be run on this testbench.
------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

library tbench;
use tbench.timing.all;

library uut;

library trickbox;

entity tbench is
end tbench;

-- ---------------------------------------------------------------------
--
--                               tbench
--                               ======
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--  Top level testbench.
--  This file integrates the Gpio, Gpio trickbox and
--  the APB interface modules to enable system level testing.
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture structural of tbench is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------
    
  component apbslave_tb
  generic
         (
          PRDATA_mask            : string;
          INFILE                 : string;
          Verbosity              : integer;
          HaltOnMismatch         : integer;
	  tclks                  : time;
          tclkl                  : time;
          tclkh                  : time
          );
  port(
       PRESETn     : out std_logic; 
       PCLK        : out std_logic;
       PADDR       : out std_logic_vector(31 downto 0);
       PWRITE      : out std_logic;
       PENABLE     : out std_logic;
       PSEL        : out std_logic;
       PSELT       : out std_logic;
       PWDATA      : out std_logic_vector(31 downto 0);
       PRDATA      : in  std_logic_vector(31 downto 0);
       VRG0        : inout std_logic_vector(31 downto 0);
       VRG1        : inout std_logic_vector(31 downto 0);
       VRG2        : inout std_logic_vector(31 downto 0);
       VRG3        : inout std_logic_vector(31 downto 0);
       VRG4        : inout std_logic_vector(31 downto 0);
       VRG5        : inout std_logic_vector(31 downto 0);
       VRG6        : inout std_logic_vector(31 downto 0);
       VRG7        : inout std_logic_vector(31 downto 0)
       );
  end  component;

  component Gpio
  port (
  -- Inputs
  -- APB bus signals
  PCLK     : in   std_logic;                      -- APB clock
  PRESETn  : in   std_logic;                      -- AMBA reset
  PSEL     : in   std_logic;                      -- APB periph select
  PENABLE  : in   std_logic;                      -- APB enable
  PWRITE   : in   std_logic;                      -- APB write 
  PWDATA   : in   std_logic_vector(7 downto 0);   -- APB write data
  PADDR    : in   std_logic_vector(11 downto 2);  -- APB address bus
  -- GPIO lines onto the Pads 
  GPIN     : in   std_logic_vector(7 downto 0);   -- GPIO input
  -- Alternate functionality lines 
  GPAFOUT  : in   std_logic_vector(7 downto 0);   -- Alt. Funct. output
  nGPAFEN  : in   std_logic_vector(7 downto 0);   -- Alt. F. o/p enable
  
  -- Outputs 
  -- APB bus signals
  PRDATA   : out  std_logic_vector(7 downto 0);   -- APB read data
  -- GPIO lines onto the Pads   
  nGPEN    : out  std_logic_vector(7 downto 0);   -- GPIO o/p enable
  GPOUT    : out  std_logic_vector(7 downto 0);   -- GPIO output
  -- Alternate functionality lines   
  GPAFIN   : out  std_logic_vector(7 downto 0);   -- Alt. Funct. input
  -- Interrupt output to the Interrupt controller 
  GPIOINTR : out  std_logic;                      -- Interrupt output
  GPIOMIS  : out  std_logic_vector(7 downto 0);   -- GPIO Masked Interr.
  
  -- Scan test dummy signals; not connected until scan insertion 
  SCANENABLE  : in  std_logic;                    -- Scan Test Mode Enbl
  SCANINPCLK  : in  std_logic;                    -- Scan Chain Input
  SCANOUTPCLK : out std_logic                     -- Scan Chain Output
  );
  end component;

  component GpioTrick
  port(
    -- Inputs
    -- APB bus signals
    PCLK      : in   std_logic;                    -- APB Clock
    PRESETn   : in   std_logic;                    -- AMBA reset
    PENABLE   : in   std_logic;                    -- APB enable 
    PSELT     : in   std_logic;                    -- Trickbox select 
    PWRITE    : in   std_logic;                    -- APB write
    PA        : in   std_logic_vector(7 downto 2); -- APB address bus
    PWData    : in   std_logic_vector(7 downto 0); -- APB write databus   
    -- GPIO lines onto the Pads
    nGPEN     : in   std_logic_vector(7 downto 0); -- GPIO o/p enables
    GPOUT     : in   std_logic_vector(7 downto 0); -- GPIO outputs
    -- Alternate functionality lines
    GPAFIN    : in   std_logic_vector(7 downto 0); -- Alt F. inputs
    -- Interrupt output to the Interrupt controller
    GPIOINTR  : in   std_logic;                    -- Interrupt output
    GPIOMIS   : in   std_logic_vector(7 downto 0); -- Masked Int Status
    
    -- Outputs
    -- APB bus Output signals
    PRData    : out  std_logic_vector(7 downto 0); -- APB read databus
    -- GPIO lines driven onto the Pads
    GPIN      : out  std_logic_vector(7 downto 0); -- GPIO inputs
    -- Alternate functionality lines
    nGPAFEN   : out  std_logic_vector(7 downto 0); -- Alt F. o/p enables
    GPAFOUT   : out  std_logic_vector(7 downto 0)  -- Alt F. outputs
    );
  end component;

  component  apbmux
  port (
        PCLK       : in     std_logic;
        PRESETn    : in     std_logic;
        PSEL       : in     std_logic;
        PSELT      : in     std_logic;
        PRData0    : in     std_logic_vector(31 downto 0);
        PRData1    : in     std_logic_vector(31 downto 0);
        PRData     : out    std_logic_vector(31 downto 0)
      ) ;
  end  component;
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
------------------------------------------------------------------------
-- If the XonPSEL constant is set to '0' (default), an 'X' appearing
-- on the PSEL line, the PWRITE line or the PADDR lines will be
-- converted to '0'. If this constant is set to '1', the PSEL,
-- PWRITE and the PADDR generated internally by the testbench are passed
-- on unmodified.
------------------------------------------------------------------------
  constant XonPSEL    : std_logic := '0';
  
-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------

  signal PCLK         : std_logic;
  signal PRESETn      : std_logic;

  signal PADDR        : std_logic_vector(31 downto 0);
  signal I_PADDR      : std_logic_vector(31 downto 0);
                                                              
  signal PWRITE       : std_logic;
  signal I_PWRITE     : std_logic; 
  signal PENABLE      : std_logic;
  signal PSEL         : std_logic; 
  signal I_PSEL       : std_logic; 
  signal PSELT        : std_logic; 
  signal I_PSELT      : std_logic; 
  signal PRDATA0      : std_logic_vector(31 downto 0);
  signal PRDATA1      : std_logic_vector(31 downto 0);
  signal PRDATA       : std_logic_vector(31 downto 0)
                        := "00000000000000000000000000000000";
  signal PWDATA       : std_logic_vector(31 downto 0);
----------------------
  signal nGPEN        : std_logic_vector(7 downto 0);
  signal GPOUT        : std_logic_vector(7 downto 0);
  signal GPIN         : std_logic_vector(7 downto 0);

  signal nGPAFEN      : std_logic_vector(7 downto 0);
  signal GPAFOUT      : std_logic_vector(7 downto 0);
  signal GPAFIN       : std_logic_vector(7 downto 0);

  signal GPIOINTR     : std_logic;
  signal GPIOMIS      : std_logic_vector(7 downto 0);

  signal SCANENABLE   : std_logic;
  signal SCANINPCLK   : std_logic;
  signal SCANOUTPCLK  : std_logic;
---------------------- 
  -- Read Fill vector
  signal ReadFill     : std_logic_vector(31 downto 0);

  signal GpioRdData   : std_logic_vector(7 downto 0);
  signal TrickRdData  : std_logic_vector(7 downto 0);

  signal VRG0         : std_logic_vector(31 downto 0);
  signal VRG1         : std_logic_vector(31 downto 0);
  signal VRG2         : std_logic_vector(31 downto 0);
  signal VRG3         : std_logic_vector(31 downto 0);
  signal VRG4         : std_logic_vector(31 downto 0);
  signal VRG5         : std_logic_vector(31 downto 0);
  signal VRG6         : std_logic_vector(31 downto 0);
  signal VRG7         : std_logic_vector(31 downto 0);


-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

  -- Connect all the scan inputs to '0' to prevent interference with
  -- functional mode tests.
  SCANENABLE     <= '0';
  SCANINPCLK     <= '0';

  ReadFill <= (others => '0');

  PSEL  <= '0' when (XonPSEL = '0' and I_PSEL = 'X')
        else
           I_PSEL;
 
  PSELT <= '0' when (XonPSEL = '0' and I_PSELT = 'X')
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
        PADDR(i) <= I_PADDR(i);
      end if;
    end loop;
  end process p_PADDR;

  --  All the unconnected Virtual Register inputs should be set to zero:
  VRG0 (31 downto 0) <= (others => '0');
  VRG1 (31 downto 0) <= (others => '0');
  VRG2 (31 downto 0) <= (others => '0');
  VRG3 (31 downto 0) <= (others => '0');
  VRG4 (31 downto 0) <= (others => '0');
  VRG5 (31 downto 0) <= (others => '0');
  VRG6 (31 downto 0) <= (others => '0');
  VRG7 (31 downto 0) <= (others => '0');

  u_apbslv_tb : apbslave_tb
    generic map (PRDATA_mask     => "FFFFFFFF",
                 INFILE          => "../../bustest/invec/infile.bif",
                 Verbosity       => 0,
                 HaltOnMismatch  => 0,
                 tclks           => Tclks,
                 tclkl           => Tclkl,
                 tclkh           => Tclkh
                )
  port map (
            PRESETn     => PRESETn,
            PCLK        => PCLK,
            PADDR       => I_PADDR,
            PWRITE      => I_PWRITE,
            PENABLE     => PENABLE,
            PSEL        => I_PSEL,
            PSELT       => I_PSELT,
            PRDATA      => PRDATA,
            PWDATA      => PWDATA,
            VRG0        => VRG0,
            VRG1        => VRG1,
            VRG2        => VRG2,
            VRG3        => VRG3,
            VRG4        => VRG4,
            VRG5        => VRG5,
            VRG6        => VRG6,
            VRG7        => VRG7
           );

  uut  : Gpio
  port map (
            PCLK         => PCLK,
            PRESETn      => PRESETn,
            PSEL         => PSEL,
            PENABLE      => PENABLE,
            PWRITE       => PWRITE,
            PADDR        => PADDR(11 downto 2),
            PWDATA       => PWData(7 downto 0),
            nGPEN        => nGPEN,
            GPOUT        => GPOUT,
            GPIN         => GPIN,
            nGPAFEN      => nGPAFEN,
            GPAFOUT      => GPAFOUT,
            GPAFIN       => GPAFIN,
            GPIOINTR     => GPIOINTR,
	    GPIOMIS      => GPIOMIS,
            PRDATA       => GpioRdData,
            SCANENABLE   => SCANENABLE,
            SCANINPCLK   => SCANINPCLK,
            SCANOUTPCLK  => SCANOUTPCLK    
           );
 
  u_GpioTrick : GpioTrick
  port map (
            PCLK        => PCLK,          
            PENABLE     => PENABLE,
            PSELT       => PSELT,
            PWRITE      => PWRITE,
            PA          => PADDR(7 downto 2),
            PWData      => PWData(7 downto 0),
            PRData      => TrickRdData(7 downto 0),
            nGPEN       => nGPEN,
            GPOUT       => GPOUT,
            GPIN        => GPIN,
	    PRESETn     => PRESETn,
            nGPAFEN     => nGPAFEN,
            GPAFOUT     => GPAFOUT,
            GPAFIN      => GPAFIN,
            GPIOINTR    => GPIOINTR,
	    GPIOMIS     => GPIOMIS
           );
  
  PRDATA0 <= ReadFill(31 downto 8) & GpioRdData;
  PRDATA1 <= ReadFill(31 downto 8) & TrickRdData;

  u_apbmux : apbmux
  port map (
            PCLK       => PCLK,
            PRESETn    => PRESETn,
            PSEL       => PSEL,
            PSELT      => PSELT,
            PRData0    => PRDATA0,
            PRData1    => PRDATA1,
            PRData     => PRDATA
           );
   
end structural;

-- --============================== End ==============================--
