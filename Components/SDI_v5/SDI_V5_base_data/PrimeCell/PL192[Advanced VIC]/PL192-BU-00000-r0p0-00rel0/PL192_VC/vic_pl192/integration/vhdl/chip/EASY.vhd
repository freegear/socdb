-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EASY.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Structural architecture of Example Amba SYstem (EASY)
--
-- --=========================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library sys;
use     sys.all;

library uut;
use     uut.all;

library chip;
use     chip.all;

entity EASY is
  port (
        XCLKIN           : in    std_logic; -- External clock in
        nReset           : in    std_logic; -- Power on reset input
        XD               : inout std_logic_vector(31 downto 0);
                                            -- External data bus
        XA               : out   std_logic_vector(30 downto 0);
                                            -- External address bus
        XCSN             : out   std_logic_vector(3 downto 0);
                                            -- External chip select
        XOEN             : out   std_logic; -- External output enable
        XWEN             : out   std_logic_vector(3 downto 0);
                                            -- External write enable
    
        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B
        TESTACK          : out   std_logic; -- Test acknowledge

        nTRST            : in    std_logic; -- JTAG connections
        TCK              : in    std_logic;
        TDI              : in    std_logic;
        TMS              : in    std_logic;
        TDO              : out   std_logic
       );
end EASY;

architecture structural of EASY is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- The AHB to APB bridge
-- -----------------------------------------------------------------------------
component APBif
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSELAPBif        : in    std_logic;
        HREADYin         : in    std_logic;

        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYout        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        PRDATA           : in    std_logic_vector(31 downto 0);

        PWDATA           : out   std_logic_vector(31 downto 0);
        PENABLE          : out   std_logic;
        PSELIC           : out   std_logic; -- Interrupt Controller
        PSELUUT          : out   std_logic; -- APB Unit Under Test
        PSELRPC          : out   std_logic; -- Remap and Pause
        PADDR            : out   std_logic_vector(31 downto 0);
        PWRITE           : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The AHB system arbiter
-- -----------------------------------------------------------------------------
component Arbiter
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HTRANS           : in    std_logic_vector(1 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        HREADY           : in    std_logic;
        HRESP            : in    std_logic_vector(1 downto 0);
  
        HBUSREQarm       : in    std_logic; -- Master bus request inputs
        HBUSREQtic       : in    std_logic;
        HBUSREQ003       : in    std_logic;
        HBUSREQ004       : in    std_logic;

        HLOCKarm         : in    std_logic; -- Master bus lock request
                                          -- inputs
        HLOCKtic         : in    std_logic;
        HLOCK003         : in    std_logic;
        HLOCK004         : in    std_logic;

        HSPLIT           : in    std_logic_vector(15 downto 0);
                                          -- Slave split inputs

        Pause            : in    std_logic; -- Pause mode entered

        HGRANTarm        : out   std_logic; -- Master bus grant outputs
        HGRANTtic        : out   std_logic;
        HGRANT003        : out   std_logic;
        HGRANT004        : out   std_logic;

        HMASTER          : out   std_logic_vector(3 downto 0);
                                          -- Current bus master
        HMASTLOCK        : out   std_logic  -- Indicates locked sequence
                                          -- of transfers
       );
end component;

-- -----------------------------------------------------------------------------
-- The system address Decoder
-- -----------------------------------------------------------------------------
component Decoder
  port (
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);

        Remap            : in    std_logic;

        HSELIntMem       : out   std_logic; -- Internal Memory
        HSELExtMem       : out   std_logic; -- External Memory
        HSELUUT          : out   std_logic; -- AHB Slave
        HSELAPBif        : out   std_logic; -- APB Peripherals
        HSELArmTest      : out   std_logic; -- ARM Test
        HSELDefault      : out   std_logic  -- Default Slave
       );
  end component;

-- -----------------------------------------------------------------------------
-- The Default Slave
-- -----------------------------------------------------------------------------
component DefaultSlave
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSELDefault      : in    std_logic;
        HREADYin         : in    std_logic;

        HREADYout        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Central multiplexer - masters to slaves
-- Also generates the default master outputs when no other masters
-- are selected
-- -----------------------------------------------------------------------------
component MuxM2S
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HMASTER          : in    std_logic_vector(3 downto 0);
        HREADY           : in    std_logic;

        HADDRarm         : in    std_logic_vector(31 downto 0);
        HTRANSarm        : in    std_logic_vector(1 downto 0);
        HWRITEarm        : in    std_logic;
        HSIZEarm         : in    std_logic_vector(2 downto 0);
        HBURSTarm        : in    std_logic_vector(2 downto 0);
        HPROTarm         : in    std_logic_vector(3 downto 0);
        HWDATAarm        : in    std_logic_vector(31 downto 0);

        HADDRtic         : in    std_logic_vector(31 downto 0);
        HTRANStic        : in    std_logic_vector(1 downto 0);
        HWRITEtic        : in    std_logic;
        HSIZEtic         : in    std_logic_vector(2 downto 0);
        HBURSTtic        : in    std_logic_vector(2 downto 0);
        HPROTtic         : in    std_logic_vector(3 downto 0);
        HWDATAtic        : in    std_logic_vector(31 downto 0);

        HADDR003         : in    std_logic_vector(31 downto 0);
        HTRANS003        : in    std_logic_vector(1 downto 0);
        HWRITE003        : in    std_logic;
        HSIZE003         : in    std_logic_vector(2 downto 0);
        HBURST003        : in    std_logic_vector(2 downto 0);
        HPROT003         : in    std_logic_vector(3 downto 0);
        HWDATA003        : in    std_logic_vector(31 downto 0);

        HADDR004         : in    std_logic_vector(31 downto 0);
        HTRANS004        : in    std_logic_vector(1 downto 0);
        HWRITE004        : in    std_logic;
        HSIZE004         : in    std_logic_vector(2 downto 0);
        HBURST004        : in    std_logic_vector(2 downto 0);
        HPROT004         : in    std_logic_vector(3 downto 0);
        HWDATA004        : in    std_logic_vector(31 downto 0);

        HADDR            : out   std_logic_vector(31 downto 0);
        HTRANS           : out   std_logic_vector(1 downto 0);
        HWRITE           : out   std_logic;
        HSIZE            : out   std_logic_vector(2 downto 0);
        HBURST           : out   std_logic_vector(2 downto 0);
        HPROT            : out   std_logic_vector(3 downto 0);
        HWDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Central multiplexer - slaves to masters
-- -----------------------------------------------------------------------------
component MuxS2M
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELIntMem       : in    std_logic;
        HSELExtMem       : in    std_logic;
        HSELUUT          : in    std_logic;
        HSELAPBif        : in    std_logic;
        HSELArmTest      : in    std_logic;

        HRDATAIntMem     : in    std_logic_vector(31 downto 0);
        HREADYIntMem     : in    std_logic;
        HRESPIntMem      : in    std_logic_vector(1 downto 0);

        HRDATAExtMem     : in    std_logic_vector(31 downto 0);
        HREADYExtMem     : in    std_logic;
        HRESPExtMem      : in    std_logic_vector(1 downto 0);

        HRDATAUUT        : in    std_logic_vector(31 downto 0);
        HREADYUUT        : in    std_logic;
        HRESPUUT         : in    std_logic_vector(1 downto 0);

        HRDATAAPBif      : in    std_logic_vector(31 downto 0);
        HREADYAPBif      : in    std_logic;
        HRESPAPBif       : in    std_logic_vector(1 downto 0);

        HRDATAArmTest    : in    std_logic_vector(31 downto 0);
        HREADYArmTest    : in    std_logic;
        HRESPArmTest     : in    std_logic_vector(1 downto 0);

        HREADYDefault    : in    std_logic;
        HRESPDefault     : in    std_logic_vector(1 downto 0);

        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADY           : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- The bus reset controller
-- -----------------------------------------------------------------------------
component ResCntl
  port (
        HCLK             : in    std_logic;
        POReset          : in    std_logic; -- Power on reset input
        HRESETn          : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- The AMBA peripheral bus bridge, the reset controller and
-- the APB UUT.
-- -----------------------------------------------------------------------------
component RPS
  port (
        PCLK             : in    std_logic;
        PRESETn          : in    std_logic;
        Pause            : out   std_logic; -- Pause mode entered
        Remap            : out   std_logic; -- Reset memory map in use

        PSELRPC          : in    std_logic; -- Remap and Pause
        PSELUUT          : in    std_logic; -- APB UUT

        PENABLE          : in    std_logic;
        PADDR            : in    std_logic_vector(31 downto 0);
        PWRITE           : in    std_logic;
        PWDATA           : in    std_logic_vector(31 downto 0);
        PRDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- An example External Bus Interface
-- -----------------------------------------------------------------------------
component SMI
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector(31 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HWRITE           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATAin         : in    std_logic_vector(31 downto 0);
        HSELExtMem       : in    std_logic;
        HRDATAin         : in    std_logic_vector(31 downto 0);
        HREADYin         : in    std_logic;

        HRDATAout        : out   std_logic_vector(31 downto 0);
        HREADYout        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);

        Remap            : in    std_logic; -- Reset memory map in use
        TicRead          : in    std_logic; -- Drive out read data

        XD               : inout std_logic_vector(31 downto 0);
                                            -- External data bus

        XA               : out   std_logic_vector(30 downto 0);
                                            -- External address bus
        XCSN             : out   std_logic_vector(3 downto 0);
                                            -- External chip select
        XOEN             : out   std_logic; -- External output enable
        XWEN             : out   std_logic_vector(3 downto 0)
                                            -- External write enable
       );
end component;

-- -----------------------------------------------------------------------------
-- The test interface controller
-- -----------------------------------------------------------------------------
component TIC
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADY           : in    std_logic;
        HRESP            : in    std_logic_vector(1 downto 0);
        HGRANTtic        : in    std_logic;

        HADDR            : out   std_logic_vector(31 downto 0);
        HTRANS           : out   std_logic_vector(1 downto 0);
        HWRITE           : out   std_logic;
        HSIZE            : out   std_logic_vector(2 downto 0);
        HBURST           : out   std_logic_vector(2 downto 0);
        HPROT            : out   std_logic_vector(3 downto 0);
        HWDATA           : out   std_logic_vector(31 downto 0);
        HBUSREQtic       : out   std_logic;
        HLOCKtic         : out   std_logic;

        TESTBUS          : in    std_logic_vector(31 downto 0);
                                            -- External data bus

        TESTREQA         : in    std_logic; -- Test bus request A
        TESTREQB         : in    std_logic; -- Test bus request B

        TESTACK          : out   std_logic; -- Test acknowledge
        TicRead          : out   std_logic  -- Drive out read data
       );
end component;

-- -----------------------------------------------------------------------------
-- UUT (VIC)
-- -----------------------------------------------------------------------------
component Vic
  port (
        HCLK             : in    std_logic; 
        HRESETn          : in    std_logic; 
        HSELVIC          : in    std_logic; 
        HADDR            : in    std_logic_vector(11 downto 2);
        HWRITE           : in    std_logic; 
        HREADYIN         : in    std_logic; 
        HPROT            : in    std_logic_vector(3 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
        nVICSYNCEN       : in    std_logic; 
        VICIRQACK        : in    std_logic; 
        nVICFIQIN        : in    std_logic; 
        nVICIRQIN        : in    std_logic; 
        VICVECTADDRIN    : in    std_logic_vector(31 downto 0);
        VICFIQINREG      : in    std_logic; 
        VICIRQINREG      : in    std_logic; 
        SCANENABLE       : in    std_logic; 
        SCANINHCLK       : in    std_logic; 
        HREADYOUT        : out   std_logic; 
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        nVICFIQ          : out   std_logic; 
        nVICIRQ          : out   std_logic; 
        VICVECTADDROUT   : out   std_logic_vector(31 downto 0);
        VICVECTADDRV     : out   std_logic; 
        VICIRQACKOUT     : out   std_logic; 
        SCANOUTHCLK      : out   std_logic 
       );
  end component;

-- -----------------------------------------------------------------------------
-- VicTrickbox
-- -----------------------------------------------------------------------------
component VicTrick
  port (
        VICIRQ           : in    std_logic;
        VICFIQ           : in    std_logic;
        VICVECTADDROUT   : in    std_logic_vector(31 downto 0);
        VICFIQINREG      : out   std_logic;
        VICIRQINREG      : out   std_logic;
        VICINTSOURCE     : out   std_logic_vector(31 downto 0)
       );
  end component;

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- AHB Signals
-- -----------------------------------------------------------------------------
signal HCLK             : std_logic;
signal HRESETn          : std_logic;
signal HTRANS           : std_logic_vector(1 downto 0);
signal HADDR            : std_logic_vector(31 downto 0);
signal HWRITE           : std_logic;
signal HSIZE            : std_logic_vector(2 downto 0);
signal HBURST           : std_logic_vector(2 downto 0);
signal HPROT            : std_logic_vector(3 downto 0);
signal HWDATA           : std_logic_vector(31 downto 0);
signal HMASTER          : std_logic_vector(3 downto 0);
signal HMASTLOCK        : std_logic;
signal HSPLIT           : std_logic_vector(15 downto 0);

-- Multiplexed slave output signals
signal HRDATA        : std_logic_vector(31 downto 0);
signal HREADY        : std_logic;
signal HRESP         : std_logic_vector(1 downto 0);

-- Slave specific output signals
signal HSELIntMem          : std_logic;
signal HRDATAIntMem        : std_logic_vector(31 downto 0)
                           := (others => '0');
signal HREADYIntMem        : std_logic := '0';
signal HRESPIntMem         : std_logic_vector(1 downto 0) := "00";

signal HSELExtMem          : std_logic;
signal HRDATAExtMem        : std_logic_vector(31 downto 0);
signal HREADYExtMem        : std_logic;
signal HRESPExtMem         : std_logic_vector(1 downto 0);

signal HSELUUT             : std_logic;
signal HRDATAUUT           : std_logic_vector(31 downto 0)
                           := (others => '0');
signal HREADYUUT           : std_logic := '0';
signal HRESPUUT            : std_logic_vector(1 downto 0) := "00";
signal HSELAPBif           : std_logic;
signal HRDATAAPBif         : std_logic_vector(31 downto 0);
signal HREADYAPBif         : std_logic;
signal HRESPAPBif          : std_logic_vector(1 downto 0);

signal HSELArmTest         : std_logic;
signal HRDATAArmTest       : std_logic_vector(31 downto 0);
signal HREADYArmTest       : std_logic;
signal HRESPArmTest        : std_logic_vector(1 downto 0);

signal HSELDefault         : std_logic;
signal HREADYDefault       : std_logic;
signal HRESPDefault        : std_logic_vector(1 downto 0);

signal HSPLIT001           : std_logic_vector(15 downto 0);
signal HSPLIT002           : std_logic_vector(15 downto 0);
signal HSPLIT003           : std_logic_vector(15 downto 0);
signal HSPLIT004           : std_logic_vector(15 downto 0);

-- Master specific signals
signal HADDRarm         : std_logic_vector(31 downto 0)
                        := (others => '0');
signal HTRANSarm        : std_logic_vector(1 downto 0)
                        := (others => '0');
signal HWRITEarm        : std_logic := '0';
signal HSIZEarm         : std_logic_vector(2 downto 0)
                        := (others => '0');
signal HBURSTarm        : std_logic_vector(2 downto 0)
                        := (others => '0');
signal HPROTarm         : std_logic_vector(3 downto 0)
                        := (others => '0');
signal HWDATAarm        : std_logic_vector(31 downto 0)
                        := (others => '0');
signal HBUSREQarm       : std_logic := '0';
signal HLOCKarm         : std_logic := '0';
signal HGRANTarm        : std_logic;

signal HADDRtic         : std_logic_vector(31 downto 0);
signal HTRANStic        : std_logic_vector(1 downto 0);
signal HWRITEtic        : std_logic;
signal HSIZEtic         : std_logic_vector(2 downto 0);
signal HBURSTtic        : std_logic_vector(2 downto 0);
signal HPROTtic         : std_logic_vector(3 downto 0);
signal HWDATAtic        : std_logic_vector(31 downto 0);
signal HBUSREQtic       : std_logic;
signal HLOCKtic         : std_logic;
signal HGRANTtic        : std_logic;

signal HADDR003         : std_logic_vector(31 downto 0);
signal HTRANS003        : std_logic_vector(1 downto 0);
signal HWRITE003        : std_logic;
signal HSIZE003         : std_logic_vector(2 downto 0);
signal HBURST003        : std_logic_vector(2 downto 0);
signal HPROT003         : std_logic_vector(3 downto 0);
signal HWDATA003        : std_logic_vector(31 downto 0);
signal HBUSREQ003       : std_logic;
signal HLOCK003         : std_logic;
signal HGRANT003        : std_logic;

signal HADDR004         : std_logic_vector(31 downto 0);
signal HTRANS004        : std_logic_vector(1 downto 0);
signal HWRITE004        : std_logic;
signal HSIZE004         : std_logic_vector(2 downto 0);
signal HBURST004        : std_logic_vector(2 downto 0);
signal HPROT004         : std_logic_vector(3 downto 0);
signal HWDATA004        : std_logic_vector(31 downto 0);
signal HBUSREQ004       : std_logic;
signal HLOCK004         : std_logic;
signal HGRANT004        : std_logic;

--------------------------------------------------------------------------------
-- APB Signals
--------------------------------------------------------------------------------
signal PENABLE          : std_logic;
signal PSELIC           : std_logic;
signal PSELUUT          : std_logic;
signal PSELRPC          : std_logic;
signal PADDR            : std_logic_vector(31 downto 0);
signal PWRITE           : std_logic;
signal PWDATA           : std_logic_vector(31 downto 0);
signal PRDATA           : std_logic_vector(31 downto 0);

--------------------------------------------------------------------------------
-- Example System Signals
--------------------------------------------------------------------------------
signal Remap            : std_logic;
signal Pause            : std_logic;

signal TicRead          : std_logic;

signal nTDOEN           : std_logic;

--------------------------------------------------------------------------------
-- Vectored Interrupt Controller Signals
--------------------------------------------------------------------------------
signal SCANENABLE       : std_logic;
signal SCANINHCLK       : std_logic;
signal SCANOUTHCLK      : std_logic;
signal nVICFIQIn        : std_logic;
signal nVICIRQIn        : std_logic;
signal nVICFIQ          : std_logic;
signal nVICIRQ          : std_logic;
signal nVICSYNCEN       : std_logic;
signal VICIRQACK        : std_logic := '0';
signal VICFIQINREG      : std_logic;
signal VICIRQINREG      : std_logic;
signal VICVECTADDRV     : std_logic;
signal VICIRQACKOUT     : std_logic;
signal VICINTSOURCE     : std_logic_vector(31 downto 0);
signal VICVECTADDRIN    : std_logic_vector(31 downto 0);
signal VICVECTADDROUT   : std_logic_vector(31 downto 0);

-- -----------------------------------------------------------------------------
-- Beginning of main code
-- -----------------------------------------------------------------------------
begin

-- -----------------------------------------------------------------------------
-- Drive the AHB clock with the external clock input.
-- -----------------------------------------------------------------------------
HCLK             <= XCLKIN;

-- -----------------------------------------------------------------------------
-- OR connection of split input to the Arbiter.
-- -----------------------------------------------------------------------------
HSPLIT           <= HSPLIT001 or
                    HSPLIT002 or
                    HSPLIT003 or
                    HSPLIT004;

-- -----------------------------------------------------------------------------
-- Unconnected Arbiter inputs driven LOW
-- -----------------------------------------------------------------------------
HBUSREQ003       <= '0';
HBUSREQ004       <= '0';

HLOCK003         <= '0';
HLOCK004         <= '0';

HSPLIT001        <= (others => '0');
HSPLIT002        <= (others => '0');
HSPLIT003        <= (others => '0');
HSPLIT004        <= (others => '0');

SCANENABLE       <= '0';
SCANINHCLK       <= '0';
VICVECTADDRIN    <= (others => '0');
nVICFIQIn        <= '1';
nVICIRQIn        <= '1';

-- -----------------------------------------------------------------------------
-- The AHB to APB bridge Instantiation
-- -----------------------------------------------------------------------------
uAPBif : APBif
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HWDATA           => HWDATA,
            HSELAPBif        => HSELAPBif,
            HREADYin         => HREADY,
      
            HRDATA           => HRDATAAPBif,
            HREADYout        => HREADYAPBif,
            HRESP            => HRESPAPBif,

            PRDATA           => PRDATA,

            PWDATA           => PWDATA,
            PENABLE          => PENABLE,
            PSELIC           => PSELIC,
            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,
            PADDR            => PADDR,
            PWRITE           => PWRITE
           );

-- -----------------------------------------------------------------------------
-- The AHB system arbiter Instantiation
-- -----------------------------------------------------------------------------
uArbiter : Arbiter
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS,
            HBURST           => HBURST,
            HREADY           => HREADY,
            HRESP            => HRESP,

            HBUSREQarm       => HBUSREQarm,
            HBUSREQtic       => HBUSREQtic,
            HBUSREQ003       => HBUSREQ003,
            HBUSREQ004       => HBUSREQ004,

            HLOCKarm         => HLOCKarm,
            HLOCKtic         => HLOCKtic,
            HLOCK003         => HLOCK003,
            HLOCK004         => HLOCK004,

            HSPLIT           => HSPLIT,

            Pause            => Pause,

            HGRANTarm        => HGRANTarm,
            HGRANTtic        => HGRANTtic,
            HGRANT003        => HGRANT003,
            HGRANT004        => HGRANT004,

            HMASTER          => HMASTER,
            HMASTLOCK        => HMASTLOCK
           );

-- -----------------------------------------------------------------------------
-- The system address Decoder Instantiation
-- -----------------------------------------------------------------------------
uDecoder : Decoder
  port map (
            HRESETn          => HRESETn,
            HADDR            => HADDR,

            Remap            => Remap,

            HSELIntMem       => HSELIntMem,
            HSELExtMem       => HSELExtMem,
            HSELUUT          => HSELUUT,
            HSELAPBif        => HSELAPBif,
            HSELArmTest      => HSELArmTest,
            HSELDefault      => HSELDefault
           );

-- -----------------------------------------------------------------------------
-- The Default Slave Instantiation
-- -----------------------------------------------------------------------------
uDefaultSlave : DefaultSlave
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTRANS           => HTRANS,
            HSELDefault      => HSELDefault,
            HREADYin         => HREADY,

            HREADYout        => HREADYDefault,
            HRESP            => HRESPDefault
           );

-- -----------------------------------------------------------------------------
-- Central multiplexer - masters to slaves - Instantiation
-- -----------------------------------------------------------------------------
uMuxM2S : MuxM2S
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HMASTER          => HMASTER,
            HREADY           => HREADY,

            HADDRarm         => HADDRarm,
            HTRANSarm        => HTRANSarm,
            HWRITEarm        => HWRITEarm,
            HSIZEarm         => HSIZEarm,
            HBURSTarm        => HBURSTarm,
            HPROTarm         => HPROTarm,
            HWDATAarm        => HWDATAarm,

            HADDRtic         => HADDRtic,
            HTRANStic        => HTRANStic,
            HWRITEtic        => HWRITEtic,
            HSIZEtic         => HSIZEtic,
            HBURSTtic        => HBURSTtic,
            HPROTtic         => HPROTtic,
            HWDATAtic        => HWDATAtic,

            HADDR003         => HADDR003,
            HTRANS003        => HTRANS003,
            HWRITE003        => HWRITE003,
            HSIZE003         => HSIZE003,
            HBURST003        => HBURST003,
            HPROT003         => HPROT003,
            HWDATA003        => HWDATA003,

            HADDR004         => HADDR004,
            HTRANS004        => HTRANS004,
            HWRITE004        => HWRITE004,
            HSIZE004         => HSIZE004,
            HBURST004        => HBURST004,
            HPROT004         => HPROT004,
            HWDATA004        => HWDATA004,

            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HBURST           => HBURST,
            HPROT            => HPROT,
            HWDATA           => HWDATA
           );

-- -----------------------------------------------------------------------------
-- Central multiplexer - slaves to masters - Instantiation
-- -----------------------------------------------------------------------------
uMuxS2M : MuxS2M
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELIntMem       => HSELIntMem,
            HSELExtMem       => HSELExtMem,
            HSELUUT          => HSELUUT,
            HSELAPBif        => HSELAPBif,
            HSELArmTest      => HSELArmTest,

            HRDATAIntMem     => HRDATAIntMem,
            HREADYIntMem     => HREADYIntMem,
            HRESPIntMem      => HRESPIntMem,

            HRDATAExtMem     => HRDATAExtMem,
            HREADYExtMem     => HREADYExtMem,
            HRESPExtMem      => HRESPExtMem,

            HRDATAUUT        => HRDATAUUT,
            HREADYUUT        => HREADYUUT,
            HRESPUUT         => HRESPUUT,

            HRDATAAPBif      => HRDATAAPBif,
            HREADYAPBif      => HREADYAPBif,
            HRESPAPBif       => HRESPAPBif,

            HRDATAArmTest    => HRDATAArmTest,
            HREADYArmTest    => HREADYArmTest,
            HRESPArmTest     => HRESPArmTest,

            HREADYDefault    => HREADYDefault,
            HRESPDefault     => HRESPDefault,

            HRDATA           => HRDATA,
            HREADY           => HREADY,
            HRESP            => HRESP
           );

-- -----------------------------------------------------------------------------
-- The bus reset controller Instantiation
-- -----------------------------------------------------------------------------
uResCntl : ResCntl
  port map (
            HCLK             => HCLK,
            POReset          => nReset,
            HRESETn          => HRESETn
           );

-- -----------------------------------------------------------------------------
-- UUT (VIC) Instantiation
-- -----------------------------------------------------------------------------
uut : Vic
 port map (
           HCLK              => HCLK,
           HRESETn           => HRESETn,
           HSELVIC           => HSELUUT,
           HWRITE            => HWRITE,
           HREADYIN          => HREADY,
           HPROT             => HPROT,
           HTRANS            => HTRANS,
           HSIZE             => HSIZE,
           HADDR             => HADDR(11 downto 2),
           HWDATA            => HWDATA,
           SCANENABLE        => SCANENABLE,
           SCANINHCLK        => SCANINHCLK,
           nVICSYNCEN        => nVICSYNCEN,
           VICIRQACK         => VICIRQACK,
           nVICFIQIN         => nVICFIQIN,
           nVICIRQIN         => nVICIRQIN,
           VICFIQINREG       => VICFIQINREG,
           VICIRQINREG       => VICIRQINREG,
           VICINTSOURCE      => VICINTSOURCE,
           VICVECTADDRIN     => VICVECTADDRIN,
           HRDATA            => HRDATAUUT,
           HREADYOUT         => HREADYUUT,
           HRESP             => HRESPUUT,
           SCANOUTHCLK       => SCANOUTHCLK,
           nVICFIQ           => nVICFIQ,
           nVICIRQ           => nVICIRQ,
           VICVECTADDRV      => VICVECTADDRV,
           VICIRQACKOUT      => VICIRQACKOUT,
           VICVECTADDROUT    => VICVECTADDROUT
          );

-- -----------------------------------------------------------------------------
-- VicTrick Instantiation
-- -----------------------------------------------------------------------------
uVicTrick : VicTrick 
  port map (
            VICVECTADDROUT  => VICVECTADDROUT,
            VICIRQ          => nVICIRQ,
            VICFIQ          => nVICFIQ,
            VICINTSOURCE    => VICINTSOURCE,
            VICFIQINREG     => VICFIQINREG,
            VICIRQINREG     => VICIRQINREG
           );

-- -----------------------------------------------------------------------------
-- RPS Instantiation
-- -----------------------------------------------------------------------------
u_rps : RPS
  port map (
            PCLK             => HCLK,
            PRESETn          => HRESETn,
            Pause            => Pause,
            Remap            => Remap,

            PSELUUT          => PSELUUT,
            PSELRPC          => PSELRPC,

            PENABLE          => PENABLE,
            PADDR            => PADDR,
            PWRITE           => PWRITE,
            PWDATA           => PWDATA,
            PRDATA           => PRDATA
           );

-- -----------------------------------------------------------------------------
-- An example External Bus Interface Instantiation
-- -----------------------------------------------------------------------------
uSMI : SMI
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR,
            HTRANS           => HTRANS,
            HWRITE           => HWRITE,
            HSIZE            => HSIZE,
            HWDATAin         => HWDATA,
            HSELExtMem       => HSELExtMem,
            HRDATAin         => HRDATA,
            HREADYin         => HREADY,

            HRDATAout        => HRDATAExtMem,
            HREADYout        => HREADYExtMem,
            HRESP            => HRESPExtMem,

            Remap            => Remap,
            TicRead          => TicRead,

            XD               => XD,

            XA               => XA,
            XCSN             => XCSN,
            XOEN             => XOEN,
            XWEN             => XWEN
           );

-- -----------------------------------------------------------------------------
-- The Test Interface Controller Instantiation
-- -----------------------------------------------------------------------------
uTIC : TIC
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADY           => HREADY,
            HRESP            => HRESP,
            HGRANTtic        => HGRANTtic,

            HADDR            => HADDRtic,
            HTRANS           => HTRANStic,
            HWRITE           => HWRITEtic,
            HSIZE            => HSIZEtic,
            HBURST           => HBURSTtic,
            HPROT            => HPROTtic,
            HWDATA           => HWDATAtic,
            HBUSREQtic       => HBUSREQtic,
            HLOCKtic         => HLOCKtic,

            TESTBUS          => XD,
      
            TESTREQA         => TESTREQA,
            TESTREQB         => TESTREQB,
      
            TESTACK          => TESTACK,
            TicRead          => TicRead
           );

end structural;

-- --================================= End ===================================--
