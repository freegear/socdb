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
--  File Name           : Outport0.vhd,v
--  File Revision       : 1.11
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Structural sub-block architecture of Example Amba 
--                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
--                        Outport 0. The module contains the following AHB 
--                        devices:
--                       
--                          - Lite2AHB wrapper
--                          - SMI (which also contains TIC as a sub-block)
--                          - Retry Slave
--                          - Local Slave-to-Master multiplexor
--                          - Local Address Decoder
--                          - Local Default Slave
--                       
--                        The TIC within the SMI is an AHB master. The TIC is  
--                        connected directly to the ARM922T Test Interface,
--                        which is contained within Inport0 module.
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- pragma translate_off
library SMI;
use SMI.all;
library ElementsAHB;
use ElementsAHB.all;
library RetrySlave;
use RetrySlave.all;
-- pragma translate_on

entity Outport0 is
  port(
    -- Common AHB signals
    HCLK        : in  std_logic;
    HRESETn     : in  std_logic;

    -- Matrix AHB connections
    HADDR       : in  std_logic_vector(31 downto 0);
    HBURST      : in  std_logic_vector(2 downto 0);
    HMASTLOCK   : in  std_logic;
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
     
    -- Remap control signal
    Remap       : in  std_logic; 

    -- SMI external connections       
    SMDATAIN    : in  std_logic_vector(31 downto 0); -- Data from Memory
                                                     --  to SMI
    SMDATAOUT   : out std_logic_vector(31 downto 0); -- Data Bus output from
                                                     --  SMI to Memory
    nSMDATAEN   : out std_logic_vector(3 downto 0);  -- Tri-state I/O pad 
                                                     --  enable for the byte
                                                     --  lanes of external
                                                     --  memory data bus
    SMADDR      : out std_logic_vector(25 downto 0); -- External Memory 
                                                     --  address bus
    SMCS        : out std_logic_vector(7 downto 0);  -- Memory bank Chip 
                                                     --  Select output pins
    nSMBLS      : out std_logic_vector(3 downto 0);  -- Memory device Byte
                                                     --  lane enables
                                
    nSMOEN      : out std_logic; -- Memory Output Enable/not Write-Enable

    -- TIC connections (AHB)
    HADDRtst    : out std_logic_vector(31 downto 0);
    HSELtst     : out std_logic;
    HTRANStst   : out std_logic_vector(1 downto 0);
    HWRITEtst   : out std_logic;
    HWDATAtst   : out std_logic_vector(31 downto 0);

    HREADYtst   : in  std_logic;
    HRESPtst    : in  std_logic_vector(1 downto 0);
    HRDATAtst   : in  std_logic_vector(31 downto 0);

    -- TIC test signals
    TESTREQA    : in  std_logic;
    TESTREQB    : in  std_logic;
    TESTACK     : out std_logic;

    -- Scan test dummy signals; not connected until scan insertion 
    SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
    SCANINHCLK  : in  std_logic; -- Scan Chain Input
    SCANOUTHCLK : out std_logic  -- Scan Chain Output
    );
end Outport0;

architecture structural of Outport0 is

--------------------------------------------------------------------------------
-- Components: Module specific (AHB)
--------------------------------------------------------------------------------

-- Lite to AHB wrapper - required to support the Retry Slave
  component Lite2AHB
    port(
      -- Global signals
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      -- Signals from AHB
      HRDATA      : in  std_logic_vector(31 downto 0);
      HREADY      : in  std_logic;
      HRESP       : in  std_logic_vector(1 downto 0);
      HGRANT      : in  std_logic;

      -- Signals from AHB-Lite
      MADDR       : in  std_logic_vector(31 downto 0);
      MTRANS      : in  std_logic_vector(1 downto 0);
      MWRITE      : in  std_logic;
      MSIZE       : in  std_logic_vector(2 downto 0);
      MBURST      : in  std_logic_vector(2 downto 0);
      MPROT       : in  std_logic_vector(3 downto 0);
      MMASTLOCK   : in  std_logic;
      MWDATA      : in  std_logic_vector(31 downto 0);

      -- Signals to AHB
      HADDR       : out std_logic_vector(31 downto 0);
      HTRANS      : out std_logic_vector(1 downto 0);
      HWRITE      : out std_logic;
      HSIZE       : out std_logic_vector(2 downto 0);
      HBURST      : out std_logic_vector(2 downto 0);
      HPROT       : out std_logic_vector(3 downto 0);
      HWDATA      : out std_logic_vector(31 downto 0);
      HBUSREQ     : out std_logic;
      HLOCK       : out std_logic;

      -- Signals to AHB-Lite
      MRDATA      : out  std_logic_vector(31 downto 0);
      MREADY      : out  std_logic;
      MERROR      : out  std_logic;
      
      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output    
      );
  end component;

-- Static Memory Interface (similar port to the SMC PrimeCell PL092)
  component SMI
    port(
      -- Common AHB signals

      nHCLK       : in std_logic;                             -- Not used in SMI
      -- Negative AHB Bus Clock
      HCLK        : in std_logic;
      -- AHB Bus Clock
      HRESETn     : in std_logic;
      -- AHB Bus Reset Signal
      HREADYIN    : in std_logic;
      -- Multiplexed HREADY input from all
      -- slaves
      HREADYINTIC : in std_logic;                    -- !!NOT PRESENT IN PL092!!
      -- Multiplexed HREADY input from all
      -- slaves on TIC AHB bus

      -- SMI slave interface signals (AHB)

      HADDR   : in std_logic_vector(28 downto 0);
      -- AHB Address Bus input to SMC
      HBURST  : in std_logic_vector(2 downto 0);              -- Not used in SMI
      -- Information about the type of
      -- burst transfer from  AHB
      HTRANS  : in std_logic_vector(1 downto 0);
      -- AHB Bus Transfer type input to
      -- SMC
      HWRITE  : in std_logic;
      -- AHB Bus Transfer Direction input
      -- to SMC
      HSIZE   : in std_logic_vector(2 downto 0);
      -- AHB Bus Transfer size input to
      -- SMC
      HWDATA  : in std_logic_vector(31 downto 0);
      -- AHB Write Data input to SMC
      HSELSMC : in std_logic;
      -- Device Select signal of
      -- Memorybank on AHB Bus
      HSELREG : in std_logic;                                 -- Not used in SMI
      -- Device Select signal of
      -- Configuration registers on
      -- AHB Bus

      -- TIC master interface signals (AHB)

      HRESPTIC  : in std_logic_vector(1 downto 0);
      -- AHB Bus Transfer Response to TIC
      HRDATATIC : in std_logic_vector(31 downto 0);
      -- AHB Read Data Input to TIC
      HGRANTTIC : in std_logic;
      -- AHB Bus Grant to the TIC

      BIGENDIAN : in std_logic;                               -- Not used in SMI
      -- Type of endianness of the system
      REMAP     : in std_logic;
      -- Indicates the state of the
      -- Memory map

      TICBUSGNTEBI : in std_logic;                            -- Not used in SMI
      -- Bus Grant input to TIC from
      -- external EbiSdram
      SMBUSGNTEBI  : in std_logic;                            -- Not used in SMI
      -- Bus Grant input to SmcCore from
      -- external EbiSdram

      SCANENABLE  : in std_logic;                             -- Not used in SMI
      -- Test Mode input
      SCANINHCLK  : in std_logic;                             -- Not used in SMI
      -- Scan chain input with
      -- respect to HCLK
      SCANINnHCLK : in std_logic;                             -- Not used in SMI
      -- Scan chain input with
      -- respect to nHCLK

      SMWAIT       : in std_logic;                            -- Not used in SMI
      -- Async Wait signal from
      -- external memory controller
      CANCELSMWAIT : in std_logic;                            -- Not used in SMI
      -- Asynchronous external input pin
      -- to signal that the SMWAIT has
      -- timed out
      SMMWCS7      : in std_logic_vector(1 downto 0);         -- Not used in SMI
      -- Input pins used to program
      -- the memory width bit field
      -- of SMCBCR1 register
      SMDATAIN     : in std_logic_vector(31 downto 0);
      -- Data from Memory to Smc

      TESTREQA : in std_logic;
      -- Test bus request A
      TESTREQB : in std_logic;
      -- Test bus request B

      MCBUSREQ  : in std_logic;                               -- Not used in SMI
      -- Bus Request from Additional
      -- Memory Controller
      MCADDR    : in std_logic_vector(25 downto 0);           -- Not used in SMI
      -- Additional Memory Controller
      -- Address Bus
      MCDATAOUT : in std_logic_vector(31 downto 0);           -- Not used in SMI
      -- Additional controller Output
      -- Data Bus
      MCDATAEN  : in std_logic_vector(3 downto 0);            -- Not used in SMI
      -- Pad enables from Additional
      -- Memory Controller

      EXTBUSMUX : in std_logic;                               -- Not used in SMI
      -- This tied input will determine
      -- whether the internal DBI or
      -- external EbiSdram will be
      -- used for bus arbitration

      -- SMI slave interface signals (AHB)
      HRDATA    : out std_logic_vector(31 downto 0);
      -- AHB Read Data output
      -- from SMC
      HREADYOUT : out std_logic;
      -- Signal from the SMC to indicate
      -- the completion of the transfer
      HRESP     : out std_logic_vector(1 downto 0);
      -- AHB Bus Transfer Response
      -- from the SMC

      -- TIC master interface signals (AHB)
      HADDRTIC   : out std_logic_vector(31 downto 0);
      -- AHB Address output from TIC
      HTRANSTIC  : out std_logic_vector(1 downto 0);
      -- AHB Transfer type output
      -- from TIC
      HWRITETIC  : out std_logic;
      -- AHB Transfer Direction output
      -- from TIC
      HSIZETIC   : out std_logic_vector(2 downto 0);
      -- AHB Transfer Size output
      -- from TIC
      HBURSTTIC  : out std_logic_vector(2 downto 0);
      -- AHB Burst Type output from TIC
      HPROTTIC   : out std_logic_vector(3 downto 0);
      -- AHB Protection control signal
      HWDATATIC  : out std_logic_vector(31 downto 0);
      -- AHB Write Data output from TIC
      HBUSREQTIC : out std_logic;
      -- AHB Bus Request
      HLOCKTIC   : out std_logic;
      -- AHB signal indicating Locked
      -- access to the Bus

      TICBUSREQEBI : out std_logic;                           -- Not used in SMI
      -- External Data bus request signal
      -- from TIC to the EbiSdram
      SMBUSREQEBI  : out std_logic;                           -- Not used in SMI
      -- External Data bus request signal
      -- from SmcCore to the EbiSdram

      SCANOUTnHCLK : out std_logic;                           -- Not used in SMI
      -- Scan chain output with
      -- respect to nHCLK
      SCANOUTHCLK  : out std_logic;                           -- Not used in SMI
      -- Scan chain output with
      -- respect to HCLK

      SMDATAOUT : out std_logic_vector(31 downto 0);
      -- Data Bus output from SMC
      -- to Memory
      nSMDATAEN : out std_logic_vector(3 downto 0);
      -- Tri-state I/O pad enable for
      -- the byte lanes of external
      -- memory data bus
      SMADDR    : out std_logic_vector(25 downto 0);
      -- External Memory address bus
      SMCS      : out std_logic_vector(7 downto 0);
      -- Memory bank Chip Select
      -- output pins
      nSMBLS    : out std_logic_vector(3 downto 0);
      -- Memory device Byte lane
      -- enables
      nSMWEN    : out std_logic;                              -- Not used in SMI
      -- Memory Write Enable
      nSMOEN    : out std_logic;
      -- Memory Output Enable

      TICREADEBI : out std_logic;                             -- Not used in SMI
      -- Pad Enable signal from TIC when
      -- EbiSdram is used
      TBUSOUTEBI : out std_logic_vector(31 downto 0);         -- Not used in SMI
      -- Data bus output from the TIC
      -- when EbiSdram is used
      TESTACK    : out std_logic;
      -- Test acknowledge

      MCBUSGNT : out std_logic                                -- Not used in SMI
      -- Bus Grant to Additional
      -- Controller      
      );
  end component;

-- Retry slave (example code template)
  component RetrySlave
    port(
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      HADDR       : in  std_logic_vector(31 downto 0);
      HTRANS      : in  std_logic_vector(1 downto 0);
      HWRITE      : in  std_logic;
      HSIZE       : in  std_logic_vector(2 downto 0);
      HWDATA      : in  std_logic_vector(31 downto 0);
      HSELRetry   : in  std_logic;
      HREADY      : in  std_logic;   
      
      HRDATA      : out std_logic_vector(31 downto 0);
      HREADYOUT   : out std_logic;
      HRESP       : out std_logic_vector(1 downto 0);

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output
      );
  end component;


--------------------------------------------------------------------------------
-- Components: Common AHB Infrastructure
--------------------------------------------------------------------------------

-- Local Address Decoder
  component Decoder
    port(
      HADDR   : in  std_logic_vector(31 downto 20); 
      
      Remap   : in  std_logic;
      
      HSELS0B : out std_logic;
      HSELS0R : out std_logic;
      HSELS0  : out std_logic;
      HSELS1  : out std_logic;
      HSELS2  : out std_logic;
      HSELS3  : out std_logic;
      HSELS4  : out std_logic;
      HSELS5  : out std_logic;
      HSELS6  : out std_logic;
      HSELS7  : out std_logic;
      HSELS8  : out std_logic;
      HSELS9  : out std_logic;
      HSELS10 : out std_logic;
      HSELS11 : out std_logic;
      HSELS12 : out std_logic;
      HSELS13 : out std_logic;
      HSELS14 : out std_logic;
      HSELS15 : out std_logic
      );
  end component;

-- Local multiplexer - slaves to masters
  component MuxS2M
    port(
      HCLK          : in  std_logic;
      HRESETn       : in  std_logic;
      
      HSELS0        : in  std_logic;
      HSELS1        : in  std_logic;
      HSELS2        : in  std_logic;
      HSELS3        : in  std_logic;
      HSELS4        : in  std_logic;
      HSELS5        : in  std_logic;
      HSELS6        : in  std_logic;
      HSELS7        : in  std_logic;
      HSELDefault   : in  std_logic;
      
      HRDATAS0      : in  std_logic_vector(31 downto 0);
      HREADYS0      : in  std_logic;
      HRESPS0       : in  std_logic_vector(1 downto 0);
      
      HRDATAS1      : in  std_logic_vector(31 downto 0);
      HREADYS1      : in  std_logic;
      HRESPS1       : in  std_logic_vector(1 downto 0);
      
      HRDATAS2      : in  std_logic_vector(31 downto 0);
      HREADYS2      : in  std_logic;
      HRESPS2       : in  std_logic_vector(1 downto 0);
      
      HRDATAS3      : in  std_logic_vector(31 downto 0);
      HREADYS3      : in  std_logic;
      HRESPS3       : in  std_logic_vector(1 downto 0);
      
      HRDATAS4      : in  std_logic_vector(31 downto 0);
      HREADYS4      : in  std_logic;
      HRESPS4       : in  std_logic_vector(1 downto 0);
      
      HRDATAS5      : in  std_logic_vector(31 downto 0);
      HREADYS5      : in  std_logic;
      HRESPS5       : in  std_logic_vector(1 downto 0);
      
      HRDATAS6      : in  std_logic_vector(31 downto 0);
      HREADYS6      : in  std_logic;
      HRESPS6       : in  std_logic_vector(1 downto 0);
      
      HRDATAS7      : in  std_logic_vector(31 downto 0);
      HREADYS7      : in  std_logic;
      HRESPS7       : in  std_logic_vector(1 downto 0);
      
      HREADYDefault : in  std_logic;
      HRESPDefault  : in  std_logic_vector(1 downto 0);
      
      HRDATA        : out std_logic_vector(31 downto 0);
      HREADY        : out std_logic;
      HRESP         : out std_logic_vector(1 downto 0);

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE    : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK    : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK   : out std_logic  -- Scan Chain Output
      );
  end component;

-- Default Slave. This is selected when no other slaves are accessed
  component DefaultSlave
    port(
      HCLK        : in  std_logic;
      HRESETn     : in  std_logic;

      HTRANS      : in  std_logic_vector(1 downto 0);
      HSEL        : in  std_logic;
      HREADY      : in  std_logic;
      
      HREADYOUT   : out std_logic;
      HRESP       : out std_logic_vector(1 downto 0);

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE  : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK  : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK : out std_logic  -- Scan Chain Output
      );
  end component;


--------------------------------------------------------------------------------
-- Signal declarations: AHB
--------------------------------------------------------------------------------

-- Local AHB backbone
  signal iHADDR    : std_logic_vector(31 downto 0);
  signal iHTRANS   : std_logic_vector(1 downto 0);
  signal iHWRITE   : std_logic;
  signal iHSIZE    : std_logic_vector(2 downto 0);
  signal iHBURST   : std_logic_vector(2 downto 0);
  signal iHPROT    : std_logic_vector(3 downto 0);
  signal iHWDATA   : std_logic_vector(31 downto 0);
  signal iHLOCK    : std_logic;

-- Multiplexed Local slave output signals
  signal iHREADY   : std_logic;
  signal iHRESP    : std_logic_vector(1 downto 0);
  signal iHRDATA   : std_logic_vector(31 downto 0);

-- Local Slave specific output signals
  signal HSELS0B   : std_logic;
  signal HSELS0R   : std_logic;

  signal HSELS0    : std_logic;
  signal HRDATAS0  : std_logic_vector(31 downto 0);
  signal HREADYS0  : std_logic;
  signal HRESPS0   : std_logic_vector(1 downto 0);

  signal HSELS1    : std_logic;
  signal HRDATAS1  : std_logic_vector(31 downto 0);
  signal HREADYS1  : std_logic;
  signal HRESPS1   : std_logic_vector(1 downto 0);

  signal HSELS2    : std_logic;
  signal HRDATAS2  : std_logic_vector(31 downto 0);
  signal HREADYS2  : std_logic;
  signal HRESPS2   : std_logic_vector(1 downto 0);

  signal HSELS3    : std_logic;
  signal HRDATAS3  : std_logic_vector(31 downto 0);
  signal HREADYS3  : std_logic;
  signal HRESPS3   : std_logic_vector(1 downto 0);

  signal HSELS4    : std_logic;
  signal HRDATAS4  : std_logic_vector(31 downto 0);
  signal HREADYS4  : std_logic;
  signal HRESPS4   : std_logic_vector(1 downto 0);

  signal HSELS5    : std_logic;
  signal HRDATAS5  : std_logic_vector(31 downto 0);
  signal HREADYS5  : std_logic;
  signal HRESPS5   : std_logic_vector(1 downto 0);

  signal HSELS6    : std_logic;
  signal HRDATAS6  : std_logic_vector(31 downto 0);
  signal HREADYS6  : std_logic;
  signal HRESPS6   : std_logic_vector(1 downto 0);

  signal HSELS7    : std_logic;
  signal HRDATAS7  : std_logic_vector(31 downto 0);
  signal HREADYS7  : std_logic;
  signal HRESPS7   : std_logic_vector(1 downto 0);

  signal HSELS8    : std_logic;
  signal HSELS9    : std_logic;
  signal HSELS10   : std_logic;
  signal HSELS11   : std_logic;
  signal HSELS12   : std_logic;
  signal HSELS13   : std_logic;
  signal HSELS14   : std_logic;
  signal HSELS15   : std_logic;

  signal HSELDefault   : std_logic;
  signal HREADYDefault : std_logic;
  signal HRESPDefault  : std_logic_vector(1 downto 0);

-- Miscellaneous signals

  signal HSELSmi    : std_logic;

  signal iHBUSREQ   : std_logic;
  signal iHGRANT    : std_logic;

  signal HRDATASmi  : std_logic_vector(31 downto 0);
  signal HREADYSmi  : std_logic;
  signal HRESPSmi   : std_logic_vector(1 downto 0);

  signal HRDATARSlv : std_logic_vector(31 downto 0);
  signal HREADYRSlv : std_logic;
  signal HRESPRSlv  : std_logic_vector(1 downto 0);

  signal HBURSTtst  : std_logic_vector(2 downto 0);
  signal HBUSREQtst : std_logic;
  signal HGRANTtst  : std_logic;
  signal HLOCKtst   : std_logic;
  signal HPROTtst   : std_logic_vector(3 downto 0);
  signal HSIZEtst   : std_logic_vector(2 downto 0);
  signal iHADDRtst  : std_logic_vector(31 downto 0);

-- Unused SMI outputs
  signal TICBUSREQEBI : std_logic;
  signal SMBUSREQEBI  : std_logic;
  signal MCBUSGNT     : std_logic;
  signal nSMWEN       : std_logic;
  signal TICREADEBI   : std_logic;
  signal TBUSOUTEBI   : std_logic_vector(31 downto 0);


--------------------------------------------------------------------------------
-- Signal declarations: Scan chain
--------------------------------------------------------------------------------

  signal SCANINsmi     : std_logic;
  signal SCANINnsmi    : std_logic;
  signal SCANOUTsmi    : std_logic;
  signal SCANOUTnsmi   : std_logic;
  signal SCANINs2m     : std_logic;
  signal SCANOUTs2m    : std_logic;
  signal SCANINdefslv  : std_logic;
  signal SCANOUTdefslv : std_logic;
  signal SCANINretry   : std_logic;
  signal SCANOUTretry  : std_logic;
  signal SCANINwpr     : std_logic;
  signal SCANOUTwpr    : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: Tie-offs
--------------------------------------------------------------------------------

  signal TieOffHi1  : std_logic;
  signal TieOffLo1  : std_logic;
  signal TieOffLo2  : std_logic_vector(1 downto 0);
  signal TieOffLo4  : std_logic_vector(3 downto 0);
  signal TieOffLo26 : std_logic_vector(25 downto 0);
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
  TieOffLo1  <= '0';
  TieOffLo2  <= "00";
  TieOffLo4  <= (others => '0');
  TieOffLo26 <= (others => '0');
  TieOffLo32 <= (others => '0');


-- The Lite to AHB Wrapper (only master in this module)
  uLite2AHB : Lite2AHB
    port map(
      -- Global signals
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      -- Signals from AHB
      HRDATA      => iHRDATA,
      HREADY      => iHREADY,
      HRESP       => iHRESP,
      HGRANT      => iHGRANT,

      -- Signals from AHB-Lite
      MADDR       => HADDR,
      MTRANS      => HTRANS,
      MWRITE      => HWRITE,
      MSIZE       => HSIZE,
      MBURST      => HBURST,
      MPROT       => HPROT,
      MMASTLOCK   => HMASTLOCK,
      MWDATA      => HWDATA,

      -- Signals to AHB
      HADDR       => iHADDR,
      HPROT       => iHPROT,
      HWDATA      => iHWDATA,
      HBUSREQ     => iHBUSREQ,
      HLOCK       => iHLOCK,
      HTRANS      => iHTRANS,
      HWRITE      => iHWRITE,
      HSIZE       => iHSIZE,
      HBURST      => iHBURST,

      -- Signals to AHB-Lite
      MRDATA      => HRDATA,
      MREADY      => HREADYOUT,
      MERROR      => HRESP(0),

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINwpr,
      SCANOUTHCLK => SCANOUTwpr
      );

  -- This signal is not driven by the Lite2AHB Wrapper
  HRESP(1) <= '0';

  -- Always grant the Lite2AHB Wrapper
  iHGRANT  <= '1';


-- Static Memory Interface instantiated as AHB slave 3 (aliased to Slot 0
--  at boot)
  uSMI : SMI
    port map(
      -- Common AHB signals
      nHCLK        => TieOffLo1,             -- Not used
      HCLK         => HCLK,
      HRESETn      => HRESETn,

      HREADYIN     => iHREADY,
      HREADYINTIC  => HREADYtst,

      -- SMI slave interface signals (AHB)
      HADDR        => iHADDR(28 downto 0),
      HBURST       => iHBURST,               -- Not used
      HTRANS       => iHTRANS,
      HWRITE       => iHWRITE,
      HSIZE        => iHSIZE,
      HWDATA       => iHWDATA,
      HSELSMC      => HSELSmi,               -- Decoder slots 0 (boot) and 3
      HSELREG      => TieOffLo1,             -- Not used

      -- TIC master interface signals (AHB)
      HRESPTIC     => HRESPtst,
      HRDATATIC    => HRDATAtst,
      HGRANTTIC    => HGRANTtst,

      BIGENDIAN    => TieOffLo1,             -- Not used
      REMAP        => Remap,

      TICBUSGNTEBI => TieOffLo1,             -- Not used
      SMBUSGNTEBI  => TieOffLo1,             -- Not used

      SCANENABLE   => SCANENABLE,            -- Not used
      SCANINHCLK   => SCANINsmi,             -- Not used
      SCANINnHCLK  => SCANINnsmi,            -- Not used

      SMWAIT       => TieOffLo1,             -- Not used
      CANCELSMWAIT => TieOffLo1,             -- Not used
      SMMWCS7      => TieOffLo2,             -- Not used
      SMDATAIN     => SMDATAIN,              -- Data from Memory to SMI

      TESTREQA     => TESTREQA,              -- Test bus request A
      TESTREQB     => TESTREQB,              -- Test bus request B

      MCBUSREQ     => TieOffLo1,             -- Not used
      MCADDR       => TieOffLo26,            -- Not used
      MCDATAOUT    => TieOffLo32,            -- Not used
      MCDATAEN     => TieOffLo4,             -- Not used

      EXTBUSMUX    => TieOffLo1,             -- Not used

      -- SMI slave interface signals (AHB)
      HRDATA       => HRDATASmi,             -- Channel 0 of MuxS2M
      HREADYOUT    => HREADYSmi,
      HRESP        => HRESPSmi,

      -- TIC master interface signals (AHB)
      HADDRTIC     => iHADDRtst,
      HTRANSTIC    => HTRANStst,
      HWRITETIC    => HWRITEtst,
      HSIZETIC     => HSIZEtst,
      HBURSTTIC    => HBURSTtst,
      HPROTTIC     => HPROTtst,
      HWDATATIC    => HWDATAtst,
      HBUSREQTIC   => HBUSREQtst,
      HLOCKTIC     => HLOCKtst,

      TICBUSREQEBI => TICBUSREQEBI,          -- Not used
      SMBUSREQEBI  => SMBUSREQEBI,           -- Not used

      SCANOUTnHCLK => SCANOUTnsmi,           -- Not used
      SCANOUTHCLK  => SCANOUTsmi,            -- Not used

      SMDATAOUT    => SMDATAOUT,             -- Data from SMI to Memory
      nSMDATAEN    => nSMDATAEN,             -- Data tri-state pad en
      SMADDR       => SMADDR,                -- External address bus
      SMCS         => SMCS,                  -- External chip selects
      nSMBLS       => nSMBLS,                -- External byte lane write en
      nSMWEN       => nSMWEN,                -- Not used
      nSMOEN       => nSMOEN,                -- External read enable

      TICREADEBI   => TICREADEBI,            -- Not used
      TBUSOUTEBI   => TBUSOUTEBI,            -- Not used
      TESTACK      => TESTACK,               -- Test acknowledge

      MCBUSGNT     => MCBUSGNT               -- Not used
      );


-- Retry Slave (example code template) instantiated as AHB slave 13
  uRetrySlave : RetrySlave
    port map(
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      HADDR       => iHADDR,
      HTRANS      => iHTRANS,
      HWRITE      => iHWRITE,
      HSIZE       => iHSIZE,
      HWDATA      => iHWDATA,
      HSELRetry   => HSELS13,     -- Decoder slot 13
      HREADY      => iHREADY,

      HRDATA      => HRDATARSlv,  -- Channel 1 of MuxS2M
      HREADYOUT   => HREADYRSlv,
      HRESP       => HRESPRSlv,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINretry,
      SCANOUTHCLK => SCANOUTretry

      );


-- Local Address Decoder
  uDecoder : Decoder
    port map(
      HADDR   => HADDR(31 downto 20),

      Remap   => Remap,

      HSELS0B => HSELS0B,
      HSELS0R => HSELS0R,
      HSELS0  => HSELS0,
      HSELS1  => HSELS1,
      HSELS2  => HSELS2,
      HSELS3  => HSELS3,
      HSELS4  => HSELS4,
      HSELS5  => HSELS5,
      HSELS6  => HSELS6,
      HSELS7  => HSELS7,
      HSELS8  => HSELS8,
      HSELS9  => HSELS9,
      HSELS10 => HSELS10,
      HSELS11 => HSELS11,
      HSELS12 => HSELS12,
      HSELS13 => HSELS13,
      HSELS14 => HSELS14,
      HSELS15 => HSELS15
      );

  -- SMI occupies Slot 3 or Slot 0 (at boot) 
  HSELSmi <= HSELS3 or HSELS0B;

  -- Default Slave is selected by all unused HSEL lines
  HSELDefault <=
    -- HSELS0B or
    HSELS0R or                         -- IntMem alias
    HSELS0 or
    HSELS1 or
    HSELS2 or
    -- HSELS3 or                       -- SMI
    HSELS4 or
    HSELS5 or
    HSELS6 or
    HSELS7 or                          -- IntMem
    HSELS8 or
    HSELS9 or
    HSELS10 or
    HSELS11 or
    HSELS12 or                         -- APB Peripherals
    -- HSELS13 or                      -- Retry Slave
    HSELS14 or
    HSELS15 or                         -- Interrupt Controller
    (not HSELmtrx)
    ;


-- Default Slave (selected when no other slaves are accessed)
  uDefaultSlave : DefaultSlave
    port map(
      HCLK        => HCLK,
      HRESETn     => HRESETn,

      HTRANS      => iHTRANS,
      HSEL        => HSELDefault,
      HREADY      => iHREADY,
      
      HREADYOUT   => HREADYDefault,
      HRESP       => HRESPDefault,

      -- Scan signals
      SCANENABLE  => SCANENABLE,
      SCANINHCLK  => SCANINdefslv,
      SCANOUTHCLK => SCANOUTdefslv
      );


-- Local multiplexer - slaves to masters
--  This 8-input multiplexor is used in place of the 16-input version 
--  because it is faster to synthesise. However, in this application,
--  the input channel names do not always match the names of the signals
--  they are assigned to, though the multiplexor operation is unaffected.
  uMuxS2M : MuxS2M
    port map(
      HCLK          => HCLK,
      HRESETn       => HRESETn,

      HSELS0        => HSELSmi,         -- Decoder slots 0 (boot) and 3
      HSELS1        => HSELS13,         -- Decoder slot 13
      HSELS2        => TieOffLo1,
      HSELS3        => TieOffLo1,
      HSELS4        => TieOffLo1,
      HSELS5        => TieOffLo1,
      HSELS6        => TieOffLo1,
      HSELS7        => TieOffLo1,
      HSELDefault   => HSELDefault,

      HRDATAS0      => HRDATAS0,        -- SMI
      HREADYS0      => HREADYS0,
      HRESPS0       => HRESPS0,

      HRDATAS1      => HRDATAS1,        -- Retry Slave
      HREADYS1      => HREADYS1,
      HRESPS1       => HRESPS1,

      HRDATAS2      => HRDATAS2,
      HREADYS2      => HREADYS2,
      HRESPS2       => HRESPS2,

      HRDATAS3      => HRDATAS3,
      HREADYS3      => HREADYS3,
      HRESPS3       => HRESPS3,

      HRDATAS4      => HRDATAS4,
      HREADYS4      => HREADYS4,
      HRESPS4       => HRESPS4,

      HRDATAS5      => HRDATAS5,
      HREADYS5      => HREADYS5,
      HRESPS5       => HRESPS5,

      HRDATAS6      => HRDATAS6,
      HREADYS6      => HREADYS6,
      HRESPS6       => HRESPS6,

      HRDATAS7      => HRDATAS7,
      HREADYS7      => HREADYS7,
      HRESPS7       => HRESPS7,

      HREADYDefault => HREADYDefault,
      HRESPDefault  => HRESPDefault,

      HRDATA        => iHRDATA,         -- Connected to the Lite2AHB Wrapper
      HREADY        => iHREADY,
      HRESP         => iHRESP,

      -- Scan signals
      SCANENABLE    => SCANENABLE,
      SCANINHCLK    => SCANINs2m,
      SCANOUTHCLK   => SCANOUTs2m
      );


  HRDATAS0 <= HRDATASmi;                -- SMI
  HREADYS0 <= HREADYSmi;
  HRESPS0  <= HRESPSmi;

  HRDATAS1 <= HRDATARSlv;               -- Retry Slave
  HREADYS1 <= HREADYRSlv;
  HRESPS1  <= HRESPRSlv;


-- Tie-off the unused channels of MuxS2M

  -- Tie off HRDATA for unused slave ports
  -- HRDATAS0 <= TieOffLo32;            -- SMI
  -- HRDATAS1 <= TieOffLo32;            -- Retry Slave
  HRDATAS2 <= TieOffLo32;           
  HRDATAS3 <= TieOffLo32;
  HRDATAS4 <= TieOffLo32;           
  HRDATAS5 <= TieOffLo32;
  HRDATAS6 <= TieOffLo32;
  HRDATAS7 <= TieOffLo32;

  -- Tie off HREADY for unused slave ports
  -- HREADYS0 <= TieOffHi1;             -- SMI
  -- HREADYS1 <= TieOffHi1;             -- Retry Slave
  HREADYS2 <= TieOffHi1;            
  HREADYS3 <= TieOffHi1;
  HREADYS4 <= TieOffHi1;            
  HREADYS5 <= TieOffHi1;
  HREADYS6 <= TieOffHi1;
  HREADYS7 <= TieOffHi1;

  -- Tie off HRESP for unused slave ports
  -- HRESPS0 <= TieOffLo2;              -- SMI
  -- HRESPS1 <= TieOffLo2;              -- Retry Slave
  HRESPS2 <= TieOffLo2;             
  HRESPS3 <= TieOffLo2;
  HRESPS4 <= TieOffLo2;             
  HRESPS5 <= TieOffLo2;
  HRESPS6 <= TieOffLo2;
  HRESPS7 <= TieOffLo2;


-- TIC control logic

  -- Since TIC is the only master on its AHB layer, it can be granted as soon
  --  as a request is asserted. Note that HGRANTtst is not constantly asserted
  --  for power reasons
  p_HGRANTtstSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HGRANTtst <= '0';
    elsif (HCLK'event and HCLK = '1') then
      HGRANTtst <= HBUSREQtst;
    end if;
  end process p_HGRANTtstSeq;

  -- Decode TIC address to create slave select signal to ARM core. Note that
  --  TIC tests from ARM will assume a base address of either 0xC0000000 or
  --  0x50000000 - the following is therefore a generic solution
  HSELtst <= '1' when iHADDRtst(31 downto 28) /= "0000" else
             '0';

  -- Connect internal signal to port
  HADDRtst <= iHADDRtst;


end structural;

-- --================================= End ===================================--

