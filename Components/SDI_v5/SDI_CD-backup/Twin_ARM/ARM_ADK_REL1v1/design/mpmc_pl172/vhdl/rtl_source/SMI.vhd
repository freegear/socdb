--  --========================================================================--
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
--  File Name           : SMI.vhd,v
--  File Revision       : 1.2
--
--  Release Information : ADK_REL1v1
--
--  ----------------------------------------------------------------------------
--  Purpose             : This is the top level structural block of the Static
--                        Static Memory Interface.
--                        The port map is identical to the PrimeCell SMC PL092
--                        to allow easy use of this memory controller.
--  --========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

entity SMI is
  port(
    -- Common AHB signals
    nHCLK        : in  std_logic; -- Not used in SMI
                                  -- Negative AHB Bus Clock
    HCLK         : in  std_logic;
                                  -- AHB Bus Clock
    HRESETn      : in  std_logic;
                                  -- AHB Bus Reset Signal
    HREADYIN     : in  std_logic;
                                  -- Multiplexed HREADY input from all
                                  -- slaves
    HREADYINTIC  : in  std_logic; -- !!NOT PRESENT IN PL092!!
                                  -- Multiplexed HREADY input from all
                                  -- slaves on TIC AHB bus

    -- Smi AHB slave interface signals
    HADDR        : in  std_logic_vector(28 downto 0);
                                  -- AHB Address Bus input to SMC
    HBURST       : in  std_logic_vector(2 downto 0); -- Not used in SMI
                                  -- Information about the type of
                                  -- burst transfer from  AHB
    HTRANS       : in  std_logic_vector(1 downto 0);
                                  -- AHB Bus Transfer type input to
                                  -- SMC
    HWRITE       : in  std_logic;
                                  -- AHB Bus Transfer Direction input
                                  -- to SMC
    HSIZE        : in  std_logic_vector(2 downto 0);
                                  -- AHB Bus Transfer size input to
                                  -- SMC
    HWDATA       : in  std_logic_vector(31 downto 0);
                                  -- AHB Write Data input to SMC
    HSELSMC      : in  std_logic;
                                  -- Device Select signal of
                                  -- Memorybank on AHB Bus
    HSELREG      : in  std_logic; -- Not used in SMI
                                  -- Device Select signal of
                                  -- Configuration registers on
                                  -- AHB Bus

    -- TIC AHB master interface signals
    HRESPTIC     : in  std_logic_vector(1 downto 0);
                                  -- AHB Bus Transfer Response to TIC
    HRDATATIC    : in  std_logic_vector(31 downto 0);
                                  -- AHB Read Data Input to TIC
    HGRANTTIC    : in  std_logic;
                                  -- AHB Bus Grant to the TIC

    BIGENDIAN    : in  std_logic; -- Not used in SMI
                                  -- Type of endianness of the system
    REMAP        : in  std_logic;
                                  -- Indicates the state of the
                                  -- Memory map

    TICBUSGNTEBI : in  std_logic; -- Not used in SMI
                                  -- Bus Grant input to TIC from
                                  -- external EbiSdram
    SMBUSGNTEBI  : in  std_logic; -- Not used in SMI
                                  -- Bus Grant input to SmcCore from
                                  -- external EbiSdram

    SCANENABLE   : in  std_logic; -- Not used in SMI
                                  -- Test Mode input
    SCANINHCLK   : in  std_logic; -- Not used in SMI
                                  -- Scan chain input with
                                  -- respect to HCLK
    SCANINnHCLK  : in  std_logic; -- Not used in SMI
                                  -- Scan chain input with
                                  -- respect to nHCLK

    SMWAIT       : in  std_logic; -- Not used in SMI
                                  -- Async Wait signal from
                                  -- external memory controller
    CANCELSMWAIT : in  std_logic; -- Not used in SMI
                                  -- Asynchronous external input pin
                                  -- to signal that the SMWAIT has
                                  -- timed out
    SMMWCS7      : in  std_logic_vector(1 downto 0);  -- Not used in SMI
                                  -- Input pins used to program
                                  -- the memory width bit field
                                  -- of SMCBCR1 register
    SMDATAIN     : in  std_logic_vector(31 downto 0);
                                  -- Data from Memory to Smc

    TESTREQA     : in  std_logic;
                                  -- Test bus request A
    TESTREQB     : in  std_logic;
                                  -- Test bus request B

    MCBUSREQ     : in  std_logic; -- Not used in SMI
                                  -- Bus Request from Additional
                                  -- Memory Controller
    MCADDR       : in  std_logic_vector(25 downto 0); -- Not used in SMI
                                  -- Additional Memory Controller
                                  -- Address Bus
    MCDATAOUT    : in  std_logic_vector(31 downto 0); -- Not used in SMI
                                  -- Additional controller Output
                                  -- Data Bus
    MCDATAEN     : in  std_logic_vector(3 downto 0);  -- Not used in SMI
                                  -- Pad enables from Additional
                                  -- Memory Controller

    EXTBUSMUX    : in  std_logic; -- Not used in SMI
                                  -- This tied input will determine
                                  -- whether the internal DBI or
                                  -- external EbiSdram will be
                                  -- used for bus arbitration

    -- Smi AHB slave interface signals
    HRDATA       : out std_logic_vector(31 downto 0);
                                  -- AHB Read Data output
                                  -- from SMC
    HREADYOUT    : out std_logic;
                                  -- Signal from the SMC to indicate
                                  -- the completion of the transfer
    HRESP        : out std_logic_vector(1 downto 0);
                                  -- AHB Bus Transfer Response
                                  -- from the SMC

    -- TIC AHB master interface signals
    HADDRTIC     : out std_logic_vector(31 downto 0);
                                  -- AHB Address output from TIC
    HTRANSTIC    : out std_logic_vector(1 downto 0);
                                  -- AHB Transfer type output
                                  -- from TIC
    HWRITETIC    : out std_logic;
                                  -- AHB Transfer Direction output
                                  -- from TIC
    HSIZETIC     : out std_logic_vector(2 downto 0);
                                  -- AHB Transfer Size output
                                  -- from TIC
    HBURSTTIC    : out std_logic_vector(2 downto 0);
                                  -- AHB Burst Type output from TIC
    HPROTTIC     : out std_logic_vector(3 downto 0);
                                  -- AHB Protection control signal
    HWDATATIC    : out std_logic_vector(31 downto 0);
                                  -- AHB Write Data output from TIC
    HBUSREQTIC   : out std_logic;
                                  -- AHB Bus Request
    HLOCKTIC     : out std_logic;
                                  -- AHB signal indicating Locked
                                  -- access to the Bus

    TICBUSREQEBI : out std_logic; -- Not used in SMI
                                  -- External Data bus request signal
                                  -- from TIC to the EbiSdram
    SMBUSREQEBI  : out std_logic; -- Not used in SMI
                                  -- External Data bus request signal
                                  -- from SmcCore to the EbiSdram

    SCANOUTnHCLK : out std_logic; -- Not used in SMI
                                  -- Scan chain output with
                                  -- respect to nHCLK
    SCANOUTHCLK  : out std_logic; -- Not used in SMI
                                  -- Scan chain output with
                                  -- respect to HCLK

    SMDATAOUT    : out std_logic_vector(31 downto 0);
                                  -- Data Bus output from SMC
                                  -- to Memory
    nSMDATAEN    : out std_logic_vector(3 downto 0);
                                  -- Tri-state I/O pad enable for
                                  -- the byte lanes of external
                                  -- memory data bus
    SMADDR       : out std_logic_vector(25 downto 0);
                                  -- External Memory address bus
    SMCS         : out std_logic_vector(7 downto 0);
                                  -- Memory bank Chip Select
                                  -- output pins
    nSMBLS       : out std_logic_vector(3 downto 0);
                                  -- Memory device Byte lane
                                  -- enables
    nSMWEN       : out std_logic; -- Not used in SMI
                                  -- Memory Write Enable
    nSMOEN       : out std_logic;
                                  -- Memory Output Enable

    TICREADEBI   : out std_logic; -- Not used in SMI
                                  -- Pad Enable signal from TIC when
                                  -- EbiSdram is used
    TBUSOUTEBI   : out std_logic_vector(31 downto 0); -- Not used in SMI
                                  -- Data bus output from the TIC
                                  -- when EbiSdram is used
    TESTACK      : out std_logic;
                                  -- Test acknowledge

    MCBUSGNT     : out std_logic  -- Not used in SMI
                                  -- Bus Grant to Additional
                                  -- Controller
    );
end SMI;

architecture structural of SMI is

-- The data bus interface
  component SmiDBI
    port(
      nSMCDATAEN : in  std_logic_vector(3 downto 0);
      TICREAD    : in  std_logic;
      SMCDATAOUT : in  std_logic_vector(31 downto 0);
      HRDATATIC  : in  std_logic_vector(31 downto 0);

      nSMDATAEN  : out std_logic_vector(3 downto 0);
      SMDATAOUT  : out std_logic_vector(31 downto 0)
      );
  end component;

-- An example external bus interface
  component SmiCore
    port(
      HCLK      : in  std_logic;
      HRESETn   : in  std_logic;
      HADDR     : in  std_logic_vector(28 downto 0);
      HTRANS    : in  std_logic_vector(1 downto 0);
      HWRITE    : in  std_logic;
      HSIZE     : in  std_logic_vector(2 downto 0);
      HWDATA    : in  std_logic_vector(31 downto 0);
      HSELSMC   : in  std_logic;
      HREADYIN  : in  std_logic;
  
      HRDATA    : out std_logic_vector(31 downto 0);
      HREADYOUT : out std_logic;
      HRESP     : out std_logic_vector(1 downto 0);
  
      REMAP     : in  std_logic; -- Reset memory map in use
   
      SMDATAIN  : in  std_logic_vector(31 downto 0); -- Data from Memory to Smi
      SMDATAOUT : out std_logic_vector(31 downto 0); -- Data from Smi to Memory
      nSMDATAEN : out std_logic_vector(3 downto 0);  -- Data tri-state pad en
      SMADDR    : out std_logic_vector(25 downto 0); -- External address bus
      SMCS      : out std_logic_vector(7 downto 0);  -- External chip selects
      nSMBLS    : out std_logic_vector(3 downto 0);  -- External byte lane en
      nSMOEN    : out std_logic  -- External read enable
      );
  end component;

-- The test interface controller
  component TIC
    port(
      HCLK       : in  std_logic;
      HRESETn    : in  std_logic;
      HREADY     : in  std_logic;
      HRESP      : in  std_logic_vector(1 downto 0);
      HGRANTTIC  : in  std_logic;

      HADDR      : out std_logic_vector(31 downto 0);
      HTRANS     : out std_logic_vector(1 downto 0);
      HWRITE     : out std_logic;
      HSIZE      : out std_logic_vector(2 downto 0);
      HBURST     : out std_logic_vector(2 downto 0);
      HPROT      : out std_logic_vector(3 downto 0);
      HWDATA     : out std_logic_vector(31 downto 0);
      HBUSREQTIC : out std_logic;
      HLOCKTIC   : out std_logic;

      TESTBUS    : in  std_logic_vector(31 downto 0); -- External data bus
      TESTREQA   : in  std_logic; -- Test bus request A
      TESTREQB   : in  std_logic; -- Test bus request B

      TESTACK    : out std_logic; -- Test acknowledge
      TicRead    : out std_logic  -- Drive out read data
      );
  end component;

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

  signal nSMCDATAEN : std_logic_vector(3 downto 0);
  signal TICREAD    : std_logic;
  signal SMCDATAOUT : std_logic_vector(31 downto 0);

--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------
  begin

  uSmiDBI : SmiDBI
    port map(
      nSMCDATAEN => nSMCDATAEN,
      TICREAD    => TICREAD,
      SMCDATAOUT => SMCDATAOUT,
      HRDATATIC  => HRDATATIC,

      nSMDATAEN  => nSMDATAEN,
      SMDATAOUT  => SMDATAOUT
      );

  uSmiCore : SmiCore
    port map(
      HCLK      => HCLK,
      HRESETn   => HRESETn,
      HADDR     => HADDR,
      HTRANS    => HTRANS,
      HWRITE    => HWRITE,
      HSIZE     => HSIZE,
      HWDATA    => HWDATA,
      HSELSMC   => HSELSMC,
      HREADYIN  => HREADYIN,

      HRDATA    => HRDATA,
      HREADYOUT => HREADYOUT,
      HRESP     => HRESP,

      REMAP     => REMAP,

      SMDATAIN  => SMDATAIN,
      SMDATAOUT => SMCDATAOUT,
      nSMDATAEN => nSMCDATAEN,
      SMADDR    => SMADDR,
      SMCS      => SMCS,
      nSMBLS    => nSMBLS,
      nSMOEN    => nSMOEN
      );

  uTIC : TIC
    port map(
      HCLK       => HCLK,
      HRESETn    => HRESETn,
      HREADY     => HREADYINTIC,
      HRESP      => HRESPTIC,
      HGRANTTIC  => HGRANTTIC,

      HADDR      => HADDRTIC,
      HTRANS     => HTRANSTIC,
      HWRITE     => HWRITETIC,
      HSIZE      => HSIZETIC,
      HBURST     => HBURSTTIC,
      HPROT      => HPROTTIC,
      HWDATA     => HWDATATIC,
      HBUSREQTIC => HBUSREQTIC,
      HLOCKTIC   => HLOCKTIC,

      TESTBUS    => SMDATAIN,
      TESTREQA   => TESTREQA,
      TESTREQB   => TESTREQB,

      TESTACK    => TESTACK,
      TicRead    => TICREAD
      );

end structural;

-- --================================= End ===================================--
