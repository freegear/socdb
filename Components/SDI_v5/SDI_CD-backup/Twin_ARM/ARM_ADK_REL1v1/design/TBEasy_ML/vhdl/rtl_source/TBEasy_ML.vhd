----==========================================================================--
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
--  File Name           : TBEasy_ML.vhd,v
--  File Revision       : 1.10
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Test-bench for the EASY_ML system 
----==========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library EASY_ML;
use EASY_ML.all; 
library ExternalMemory;
use ExternalMemory.all;
library Tube;
use Tube.all;

entity TBEasy_ML is  -- Top level - no I/O
end TBEasy_ML;

architecture behavioural of TBEasy_ML is

--------------------------------------------------------------------------------
-- Component declarations
--------------------------------------------------------------------------------

-- The ARM922T-based Example Amba SYstem Multi-layer (EASY_ML)
  component EASY_ML
    port(
      XCLKIN      : in  std_logic;  -- External clock in
      nReset      : in  std_logic;  -- Power on reset in

      -- Data from Memory to SMC
      SMDATAIN    : in  std_logic_vector(31 downto 0);
      -- Data Bus output from SMC to Memory
      SMDATAOUT   : out std_logic_vector(31 downto 0);
      -- Tri-state I/O pad enable for the byte lanes of external
      --  memory data bus
      nSMDATAEN   : out std_logic_vector(3 downto 0);
      -- External Memory address bus
      SMADDR      : out std_logic_vector(25 downto 0);
      -- Memory bank Chip Select output pins
      SMCS        : out std_logic_vector(7 downto 0);
      -- Memory device Byte lane enables
      nSMBLS      : out std_logic_vector(3 downto 0);
      -- Memory Output Enable (complement serves as Write-Enable)
      nSMOEN      : out std_logic;

      -- TIC test command signals
      TESTREQA    : in  std_logic;  -- Test bus request A
      TESTREQB    : in  std_logic;  -- Test bus request B
      TESTACK     : out std_logic;  -- Test acknowledge

      -- JTAG connections
      nTRST       : in  std_logic;
      TCK         : in  std_logic;
      TDI         : in  std_logic;
      TMS         : in  std_logic;
      TDO         : out std_logic;
      nTDOEN      : out std_logic;

      -- ARM922T comms channel debug lines
      COMMRX      : out std_logic;
      COMMTX      : out std_logic;

      -- ARM922T Fast Cache clock
      XFCLK       : in  std_logic;

      -- GPIO lines
      GPIN        : in  std_logic_vector(7 downto 0); -- Inputs
      GPOUT       : out std_logic_vector(7 downto 0); -- Outputs
      nGPEN       : out std_logic_vector(7 downto 0); -- Output ctrl enables
      nGPAFEN     : in  std_logic_vector(7 downto 0); -- H/w ctrl enables
      GPAFOUT     : in  std_logic_vector(7 downto 0); -- H/w ctrl inputs
      GPAFIN      : out std_logic_vector(7 downto 0); -- H/w ctrl outputs

      -- Scan test dummy signals; not connected until scan insertion
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input (HCLK)
      SCANOUTHCLK : out std_logic; -- Scan Chain Output (HCLK)
      SCANINPCLK  : in  std_logic; -- Scan Chain Input (PCLK)
      SCANOUTPCLK : out std_logic  -- Scan Chain Output (PCLK)
      );
  end component;

-- Tube model for system messages
  component Tube
    port(
      XD   : in std_logic_vector(31 downto 0);
      XCSN : in std_logic_vector(3 downto 0);
      XWEN : in std_logic_vector(3 downto 0)
      );
  end component;

-- Behavioural models of RAM and ROM
  -- ROM filled with "rom?.dat" - where ? = 0,1,2,3
  -- RAM filled with "extram??.dat" - where ?? = 10,11,12,13 : 20,21,22,23
  component Memory
    port(
      XA   : in    std_logic_vector(30 downto 0); -- External address bus
      XD   : inout std_logic_vector(31 downto 0); -- External data bus
      XCSN : in    std_logic_vector(3 downto 0);  -- External chip enable
      XWEN : in    std_logic_vector(3 downto 0);  -- External write enable
      XOEN : in    std_logic                      -- External output enable
      );
  end component;

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------

-- Bus Clock

-- The following default frequency settings are specified. The required clock
--  period should be uncommented for use, or a new frequency specified. This
--  setting will depend on the operating frequency of the core used in the
--  system.

--  constant PERIOD : time := 7.5 ns; -- 133.3 MHz
  constant PERIOD : time := 7.518 ns; -- 133.0 MHz
--  constant PERIOD : time := 10 ns;  -- 100.0 MHz
--  constant PERIOD : time := 15 ns;  --  66.6 MHz
--  constant PERIOD : time := 15.152 ns; --  66.0 MHz
--  constant PERIOD : time := 20 ns;  --  50.0 MHz
--  constant PERIOD : time := 25 ns;  --  40.0 MHz
--  constant PERIOD : time := 30 ns;  --  33.3 MHz
--  constant PERIOD : time := 40 ns;  --  25.0 MHz

  constant PHASETIME : time := PERIOD / 2;


-- ARM922T Fast Cache clock, Asynchronous mode (XFCLK)

-- Warning: XFCLK must have a frequency greater than XCLKIN

-- The following default frequency settings are specified. The required clock
--  period should be uncommented for use, or a new frequency specified. This
--  setting will depend on the operating frequency of the core used in the
--  system.

  constant FPERIOD : time := 4 ns;      -- 250 MHz
--  constant FPERIOD : time := 5 ns;      -- 200 MHz
--  constant FPERIOD : time := 6.666 ns;  -- 150 MHz
--  constant FPERIOD : time := 10 ns;     -- 100.0 MHz

  constant FPHASETIME : time := FPERIOD / 2;


--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

--  External signals
  signal XCLKIN   : std_logic;  -- External clock in
  signal nReset   : std_logic;  -- Power on reset input
  
-- SMI interface signals
  signal XD       : std_logic_vector(31 downto 0);
  signal XDout    : std_logic_vector(31 downto 0);  
  signal XA       : std_logic_vector(30 downto 0);
  signal XCSN     : std_logic_vector(7 downto 0);
  signal XOEN     : std_logic;
  signal XBLS     : std_logic_vector(3 downto 0);
  signal XDATAEN  : std_logic_vector(3 downto 0);

-- TIC interface
  signal TESTREQA : std_logic;
  signal TESTREQB : std_logic;
  signal TESTACK  : std_logic;

-- JTAG connections
  signal nTRST    : std_logic;
  signal TCK      : std_logic;        
  signal TDI      : std_logic;
  signal TMS      : std_logic;
  signal TDO      : std_logic;
  signal nTDOEN   : std_logic;

-- ARM922T comms debug signals
  signal COMMTX   : std_logic;
  signal COMMRX   : std_logic;
    
-- ARM922T Fast Cache clock
  signal XFCLK    : std_logic;

-- GPIO signals
  signal GPIN     : std_logic_vector(7 downto 0);  -- Inputs         
  signal GPOUT    : std_logic_vector(7 downto 0);  -- Outputs        
  signal nGPEN    : std_logic_vector(7 downto 0);  -- Output enable  
  signal nGPAFEN  : std_logic_vector(7 downto 0);  -- H/w ctrl enable
  signal GPAFOUT  : std_logic_vector(7 downto 0);  -- H/w ctrl input 
  signal GPAFIN   : std_logic_vector(7 downto 0);  -- H/w ctrl output

-- Scan signals
  signal SCANENABLE  : std_logic;  -- Scan Test Mode Enable   
  signal SCANINHCLK  : std_logic;  -- Scan Chain Input (HCLK)
  signal SCANOUTHCLK : std_logic;  -- Scan Chain Output (HCLK)
  signal SCANINPCLK  : std_logic;  -- Scan Chain Input (PCLK)
  signal SCANOUTPCLK : std_logic;  -- Scan Chain Output (PCLK)


--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------

begin

-- The ARM922T-based Example Amba SYstem Multi-layer (EASY_ML)
  uEASY_ML : EASY_ML
    port map(
      XCLKIN      => XCLKIN,
      nReset      => nReset,

      SMDATAIN    => XD,
      SMDATAOUT   => XDout,
      nSMDATAEN   => XDATAEN,
      SMADDR      => XA(25 downto 0),
      SMCS        => XCSN,
      nSMBLS      => XBLS,
      nSMOEN      => XOEN, 

      TESTREQA    => TESTREQA,
      TESTREQB    => TESTREQB,
      TESTACK     => TESTACK,
      
      nTRST       => nTRST,
      TCK         => TCK,
      TDI         => TDI,
      TMS         => TMS,
      TDO         => TDO,
      nTDOEN      => nTDOEN,

      COMMRX      => COMMRX,
      COMMTX      => COMMTX,

      XFCLK       => XFCLK,

      GPIN        => GPIN,
      GPOUT       => GPOUT,
      nGPEN       => nGPEN,
      nGPAFEN     => nGPAFEN,
      GPAFOUT     => GPAFOUT,
      GPAFIN      => GPAFIN,

      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINHCLK,
      SCANOUTHCLK => SCANOUTHCLK,
      SCANINPCLK  => SCANINPCLK,
      SCANOUTPCLK => SCANOUTPCLK
      );

  XA(30 downto 26) <= (others => '0');
 
-- Tube is connected to the SMI
  uTube : Tube
    port map(
      XD   => XD,
      XCSN => XCSN(7 downto 4),
      XWEN => XBLS
      );

-- External RAM and ROM
  uMemory : Memory
    port map(
      XA   => XA,
      XD   => XD,
      XCSN => XCSN(7 downto 4), 
      XWEN => XBLS,
      XOEN => XOEN
      );
 

-- TIC inputs unused
  TESTREQA <= '0';
  TESTREQB <= '0';

-- JTAG inputs unused
  nTRST <= '0';
  TCK   <= '0';
  TDI   <= '0';
  TMS   <= '0';

-- Scan signals unused
  SCANENABLE <= '0';
  SCANINHCLK <= '0';
  SCANINPCLK <= '0';

-- Merge the external data bus signals 
  XD <= XDout when XDATAEN(0) = '0' else (others => 'Z');

-- GPIO alternate function lines tied inactive for integration tests
  nGPAFEN <= (others => '1');
  GPAFOUT <= (others => '0');
 

------------------------------------------------------------------------
-- The inputs to the GPIO Alt. Funct. Output are controlled via writes
-- to the GTAOUTR register
--                 ________
-- nGPEN[7:0] >---\\       \
--                || XOR    -----  
-- GPOUT[7:0] >---//_______/     |
--                               |
-- GPIN[7:0]  <------------------
--
--
-- XOR
-- --------------------------------
-- nGPEN[i]   GPOUT[i]   |  GPIN[i]
-- --------------------------------
--     0         0       |    0
--     0         1       |    1
--     1         0       |    1
--     1         1       |    0
-- --------------------------------
------------------------------------------------------------------------

-- Simple loop-back circuit for the integration tests (see above note)
  GPIN <= (nGPEN xor GPOUT);  


-- This controls the clock generation for the system
  p_ClockGenComb : process
  begin
    XCLKIN <= '0';
    wait for PHASETIME;
    XCLKIN <= '1';
    wait for PHASETIME;
  end process p_ClockGenComb;


-- This controls the generation of the ARM922T Fast Cache clock
  p_FClockGenComb : process
  begin
    XFCLK <= '0';
    wait for FPHASETIME;
    XFCLK <= '1';
    wait for FPHASETIME;
  end process p_FClockGenComb;


-- This controls the timing of the Reset signal.
-- The loop values should be changed for different reset timing
  p_RstComb : process
  begin
    nReset <= '0';
    for i in 1 to 20 loop
      wait on XCLKIN;
    end loop;
    nReset <= '1' after 1 ns; -- Hold time for ResCntl SyncPOR register
    wait;
  end process p_RstComb;


end behavioural;

-- --================================= End ===================================--
