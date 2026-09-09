-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Ssmc.vhd.rca
-- File Revision          : 1.13
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This is the top level structural block of the ARM PrimeCell
--           Synchronous Static Memory Controller Peripheral SSMC_PL093.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity Ssmc is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        SMMEMCLK         : in    std_logic; -- Memory Clock
        nSMMEMCLK        : in    std_logic; -- Inverted Memory Clock
        SMMEMCLKDELAY    : in    std_logic; -- Delayed Memory Clock
        SMFBCLK0         : in    std_logic; -- Fedback clock0 from output pad
        SMFBCLK1         : in    std_logic; -- Fedback clock1 from output pad
        SMFBCLK2         : in    std_logic; -- Fedback clock2 from output pad
        SMFBCLK3         : in    std_logic; -- Fedback clock3 from output pad
        HRESETn          : in    std_logic; -- AHB system level Reset
        HADDRSMC         : in    std_logic_vector(25 downto 0);
                                            -- The address bus input from AHB
                                            -- for Memory accesses
        HTRANSSMC        : in    std_logic_vector(1 downto 0);
                                            -- Indicates current transfer type
                                            -- for Memory accesses
        HWRITESMC        : in    std_logic; -- Indicates direction of transfer
                                            -- (R/W) for Memory accesses
        HSIZESMC         : in    std_logic_vector(2 downto 0);
                                            -- Transfer size indication for
                                            -- Memory accesses
        HBURSTSMC        : in    std_logic_vector(2 downto 0);
                                            -- The burst transfer information
                                            -- from AHB for Memory accesses
        HWDATASMC        : in    std_logic_vector(31 downto 0);
                                            -- Write data bus input from AHB
                                            -- for Memory accesses
        HSELSMC          : in    std_logic_vector(7 downto 0);
                                            -- Select signal for Memory transfer
                                            -- to SSMCCore. One select line for
                                            -- each Memory Bank
        HREADYINSMC      : in    std_logic; -- Transfer completion input signal
        HADDRREG         : in    std_logic_vector(11 downto 2);
                                            -- The address bus input from AHB
                                            -- for Register accesses
        HTRANSREG        : in    std_logic_vector(1 downto 0);
                                            -- Indicates current transfer type
                                            -- for Register accesses. Bit1 of
                                            -- HTRANS on AHB
        HWRITEREG        : in    std_logic; -- Indicates direction of transfer
                                            -- (R/W) for Register accesses
        HSIZEREG         : in    std_logic_vector(2 downto 0);
                                            -- Transfer size indication for
                                            -- Register accesses
        HWDATAREG        : in    std_logic_vector(31 downto 0);
                                            -- Write data bus input from AHB
                                            -- for Register accesses
        HSELREG          : in    std_logic; -- Select signal for Register
                                            -- transfer
        HREADYINREG      : in    std_logic; -- Transfer completion input signal
        HREADYINTIC      : in    std_logic; -- Transfer completion input signal
        HRESPTIC         : in    std_logic_vector(1 downto 0);
                                            -- AHB Bus Transfer Response for TIC
        HRDATATIC        : in    std_logic_vector(31 downto 0);
                                            -- AHB Read Data Input for TIC
        HGRANTTIC        : in    std_logic; -- AHB Bus Grant for TIC
        SMBUSGNTEBI      : in    std_logic; -- External bus granted for Memory
                                            -- Transfer
        SMBUSBACKOFFEBI  : in    std_logic; -- EBI backoff for Memory accesses.
                                            -- Indication that the current
                                            -- transfer should be completed as
                                            -- soon as possible
        SMTICBUSGNTEBI   : in    std_logic; -- External bus granted for TIC
                                            -- Transfer
        SMBIGENDIAN      : in    std_logic; -- Type of endianness of the system
        SMEXTBUSMUX      : in    std_logic; -- Static pin indicating if internal
                                            -- DBI or external EBI is used
        SCANENABLE       : in    std_logic; -- Enable for Scan Mode
        SCANINHCLK       : in    std_logic; -- Scan chain input with respect to
                                            -- HCLK
        SCANINSMMEMCLK   : in    std_logic; -- Scan chain input with respect to
                                            -- SMMEMCLK
        SCANINnSMMEMCLK  : in    std_logic; -- Scan chain input with respect to
                                            -- nSMMEMCLK
        SCANINCLKDELAY   : in    std_logic; -- Scan chain input with respect to 
                                            -- SMMEMCLKDELAY
        SCANINFBCLK0     : in    std_logic; -- Scan chain input with respect to
                                            -- SMFBCLK0
        SCANINFBCLK1     : in    std_logic; -- Scan chain input with respect to
                                            -- SMFBCLK1
        SCANINFBCLK2     : in    std_logic; -- Scan chain input with respect to
                                            -- SMFBCLK2
        SCANINFBCLK3     : in    std_logic; -- Scan chain input with respect to
                                            -- SMFBCLK3
        SMMWCS7          : in    std_logic_vector(1 downto 0);
                                            -- Static Input pins used to program
                                            -- the memory width bit field
                                            -- of Bank7 register
        SMBLS7POL        : in    std_logic; -- Static Input pin used to program
                                            -- the polarity of SMBLS bit field
                                            -- of Bank7 register
        SMMEMCLKRATIO    : in    std_logic_vector(1 downto 0);
                                            -- Defines Ratio of SMMemClk to HCLK
        SMWAIT           : in    std_logic; -- Asynchronous Wait signal from
                                            -- External Memory Controller to
                                            -- delay the transfer
        SMCANCELWAIT     : in    std_logic; -- Asynchronous external input, to
                                            -- signal that SMWAIT has timed out
        nSMBURSTWAIT     : in    std_logic_vector(7 downto 0);
                                            -- Synchronous burst Wait signal
                                            -- from External Memory to delay
                                            -- the transfer
        SMDATAIN         : in    std_logic_vector(31 downto 0);
                                            -- Data from Memory to SSMC
        SMTESTREQA       : in    std_logic; -- Test bus request A
        SMTESTREQB       : in    std_logic; -- Test bus request B, during test
                                            -- this signal is used in
                                            -- combination with SMTESTREQA
-- Outputs
        HRDATASMC        : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data output for
                                            -- Memory accesses
        HREADYOUTSMC     : out   std_logic; -- Indicates completion of Memory
                                            -- accesses
        HRESPSMC         : out   std_logic_vector(1 downto 0);
                                            -- SSMCCore response output, for
                                            -- Memory accesses
        HRDATAREG        : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data output for
                                            -- Register accesses
        HREADYOUTREG     : out   std_logic; -- Indicates completion of Register
                                            -- accesses
        HRESPREG         : out   std_logic_vector(1 downto 0);
                                            -- SSMCCore response output, for
                                            -- Register accesses
        HADDRTIC         : out   std_logic_vector(31 downto 0);
                                            -- AHB Address output from TIC
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
                                            -- AHB Transfer type output
                                            -- from TIC
        HWRITETIC        : out   std_logic; -- AHB Transfer direction output
                                            -- from TIC
        HSIZETIC         : out   std_logic_vector(2 downto 0);
                                            -- AHB Transfer Size output
                                            -- from TIC
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
                                            -- AHB Burst Type output from TIC
        HPROTTIC         : out   std_logic_vector(3 downto 0);
                                            -- AHB Protection control signal
                                            -- from TIC
        HWDATATIC        : out   std_logic_vector(31 downto 0);
                                            -- AHB Write Data output from TIC
        HBUSREQTIC       : out   std_logic; -- AHB Bus Request from TIC
        HLOCKTIC         : out   std_logic; -- AHB signal indicating Locked
                                            -- access to the Bus from TIC
        SMBUSREQEBI      : out   std_logic; -- Request EBI for Memory Transfer
        SMTICBUSREQEBI   : out   std_logic; -- Request EBI for TIC Transfer
        SCANOUTHCLK      : out   std_logic; -- Scan chain output with respect to
                                            -- HCLK
        SCANOUTFBCLK0    : out   std_logic; -- Scan chain output with respect to
                                            -- SMFBCLK0
        SCANOUTFBCLK1    : out   std_logic; -- Scan chain output with respect to
                                            -- SMFBCLK1
        SCANOUTFBCLK2    : out   std_logic; -- Scan chain output with respect to
                                            -- SMFBCLK2
        SCANOUTFBCLK3    : out   std_logic; -- Scan chain output with respect to
                                            -- SMFBCLK3
        SCANOUTSMMEMCLK  : out   std_logic; -- Scan output for SMMEMCLK domain
        SCANOUTnSMMEMCLK : out   std_logic; -- Scan output for nSMMEMCLK domain
        SCANOUTCLKDELAY  : out   std_logic; -- Scan chain output with respect to
                                            -- SMMEMCLKDELAY
        SMCLK            : out   std_logic_vector(3 downto 0);
                                            -- Clock for Synchronous memories
        SMDATAOUT        : out   std_logic_vector(31 downto 0);
                                            -- Data Bus output from SSMC
                                            -- to Memory
        SMBAA            : out   std_logic; -- External burst Address advance
                                            -- signal. Used to advance the
                                            -- address count in the external
                                            -- Memory device
        SMADDRVALID      : out   std_logic; -- External address valid output,
                                            -- used to indicate when the address
                                            -- output is stable during
                                            -- synchronous burst transfers
        SMADDR           : out   std_logic_vector(25 downto 0);
                                            -- External Memory address bus
        SMCS0            : out   std_logic; -- Chip Select for Bank0 of external
                                            -- Memory, active HIGH
        SMCS1            : out   std_logic; -- Chip Select for Bank1 of external
                                            -- Memory, active HIGH
        SMCS2            : out   std_logic; -- Chip Select for Bank2 of external
                                            -- Memory, active HIGH
        SMCS3            : out   std_logic; -- Chip Select for Bank3 of external
                                            -- Memory, active HIGH
        SMCS4            : out   std_logic; -- Chip Select for Bank4 of external
                                            -- Memory, active HIGH
        SMCS5            : out   std_logic; -- Chip Select for Bank5 of external
                                            -- Memory, active HIGH
        SMCS6            : out   std_logic; -- Chip Select for Bank6 of external
                                            -- Memory, active HIGH
        SMCS7            : out   std_logic; -- Chip Select for Bank7 of external
                                            -- Memory, active HIGH
        nSMCS0           : out   std_logic; -- Chip Select for Bank0 of external
                                            -- Memory, active LOW
        nSMCS1           : out   std_logic; -- Chip Select for Bank1 of external
                                            -- Memory, active LOW
        nSMCS2           : out   std_logic; -- Chip Select for Bank2 of external
                                            -- Memory, active LOW
        nSMCS3           : out   std_logic; -- Chip Select for Bank3 of external
                                            -- Memory, active LOW
        nSMCS4           : out   std_logic; -- Chip Select for Bank4 of external
                                            -- Memory, active LOW
        nSMCS5           : out   std_logic; -- Chip Select for Bank5 of external
                                            -- Memory, active LOW
        nSMCS6           : out   std_logic; -- Chip Select for Bank6 of external
                                            -- Memory, active LOW
        nSMCS7           : out   std_logic; -- Chip Select for Bank7 of external
                                            -- Memory, active LOW
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
                                            -- Tri-state I/O pad enable for
                                            -- the byte lanes of external
                                            -- memory data bus
        nSMWEN           : out   std_logic; -- Memory Write Enable, Active LOW
        nSMBLS           : out   std_logic_vector(3 downto 0);
                                            -- Memory device Byte lane enables
        nSMOEN           : out   std_logic; -- Memory Output Enable, Active Low
        SMTESTACK        : out   std_logic  -- Test Bus acknowledge
       );
end Ssmc;

-- -----------------------------------------------------------------------------
--
--                                    Ssmc
--                                    ====
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This is the top level structural block of Ssmc. This block
--   instantiates the following functional sub-blocks in the Ssmc.
--      - SsmcCore
--      - SsmcDBI
--      - SsmcClockOr
--      - SsmcRevAnd
--      - SsmcTIC
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of Ssmc is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component SsmcCore
  port (
        HCLK             : in    std_logic;
        SMMEMCLK         : in    std_logic;
        nSMMEMCLK        : in    std_logic;
        SMMEMCLKDELAY    : in    std_logic; 
        SMFBCLK0         : in    std_logic;
        SMFBCLK1         : in    std_logic;
        SMFBCLK2         : in    std_logic;
        SMFBCLK3         : in    std_logic;
        HRESETn          : in    std_logic;
        HADDRSMC         : in    std_logic_vector(25 downto 0);
        HTRANSSMC        : in    std_logic_vector(1 downto 0);
        HWRITESMC        : in    std_logic;
        HSIZESMC         : in    std_logic_vector(2 downto 0);
        HBURSTSMC        : in    std_logic_vector(2 downto 0);
        HWDATASMC        : in    std_logic_vector(31 downto 0);
        HSELSMC          : in    std_logic_vector(7 downto 0);
        HREADYINSMC      : in    std_logic;
        HADDRREG         : in    std_logic_vector(11 downto 2);
        HTRANSREG        : in    std_logic_vector(1 downto 0);
        HWRITEREG        : in    std_logic;
        HSIZEREG         : in    std_logic_vector(2 downto 0);
        HWDATAREG        : in    std_logic_vector(31 downto 0);
        HSELREG          : in    std_logic;
        HREADYINREG      : in    std_logic;
        SMBUSGNTEBI      : in    std_logic;
        SMBUSBACKOFFEBI  : in    std_logic;
        SMTICBUSGNTEBI   : in    std_logic;
        SMBIGENDIAN      : in    std_logic;
        SMEXTBUSMUX      : in    std_logic;
        SMBUSREQExt      : in    std_logic;
        SMTICBUSREQExt   : in    std_logic;
        SMMWCS7          : in    std_logic_vector(1 downto 0);
        SMBLS7POL        : in    std_logic;
        SMMEMCLKRATIO    : in    std_logic_vector(1 downto 0);
        SMWAIT           : in    std_logic;
        SMCANCELWAIT     : in    std_logic;
        nSMBURSTWAIT     : in    std_logic_vector(7 downto 0);
        SMDATAIN         : in    std_logic_vector(31 downto 0);
        SMBUSGNT         : in    std_logic;
        Revision         : in    std_logic_vector(3 downto 0);
        HRDATASMC        : out   std_logic_vector(31 downto 0);
        HREADYOUTSMC     : out   std_logic;
        HRESPSMC         : out   std_logic_vector(1 downto 0);
        HRDATAREG        : out   std_logic_vector(31 downto 0);
        HREADYOUTREG     : out   std_logic;
        HRESPREG         : out   std_logic_vector(1 downto 0);
        SMBUSREQ         : out   std_logic;
        SMBUSREQEBI      : out   std_logic;
        SMTICBUSREQEBI   : out   std_logic;
        SMTICBUSGNTExt   : out   std_logic;
        SMBUSGNTExt      : out   std_logic;
        SmBusBackOffExt  : out   std_logic;
        ClkStpd          : out   std_logic;
        BUSMUXEXT        : out   std_logic;
        SmDataEnCore     : out   std_logic_vector(3 downto 0);
        SmDataOutCore    : out   std_logic_vector(31 downto 0);
        SMBAA            : out   std_logic;
        SMADDRVALID      : out   std_logic;
        SMADDR           : out   std_logic_vector(25 downto 0);
        SMCS             : out   std_logic_vector(7 downto 0);
        nSMCS            : out   std_logic_vector(7 downto 0);
        nSMWEN           : out   std_logic;
        nSMBLS           : out   std_logic_vector(3 downto 0);
        nSMOEN           : out   std_logic
       );
end component;

component SsmcDBI
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMTICBUSGNTExt   : in    std_logic;
        SMBUSGNTExt      : in    std_logic;
        SmBusBackOffExt  : in    std_logic;
        BUSMUXEXT        : in    std_logic;
        SMBUSREQ         : in    std_logic;
        TICBUSREQ        : in    std_logic;
        TBUSOUT          : in    std_logic_vector(31 downto 0);
        TICREAD          : in    std_logic;
        SmDataEnCore     : in    std_logic_vector(3 downto 0);
        SmDataOutCore    : in    std_logic_vector(31 downto 0);
        SMBUSREQExt      : out   std_logic;
        SMTICBUSREQExt   : out   std_logic;
        SMDATAOUT        : out   std_logic_vector(31 downto 0);
        nSMDATAEN        : out   std_logic_vector(3 downto 0);
        TICBUSGNT        : out   std_logic;
        SMBUSGNT         : out   std_logic
       );
end component;

component SsmcClockOr
  port (
        CLKIN            : in    std_logic;
        ClkStpd          : in    std_logic;
        CLKOUT           : out   std_logic
       );
end component;

component SsmcRevAnd
  port (
        TieOff1          : in    std_logic;
        TieOff2          : in    std_logic;
        Revision         : out   std_logic
       );
end component;

component SsmcTIC
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HREADYINTIC      : in    std_logic;
        HRESPTIC         : in    std_logic_vector(1 downto 0);
        HGRANTTIC        : in    std_logic;
        HRDATATIC        : in    std_logic_vector(31 downto 0);
        TBUSIN           : in    std_logic_vector(31 downto 0);
        SMTESTREQA       : in    std_logic;
        SMTESTREQB       : in    std_logic;
        TICBUSGNT        : in    std_logic;
        HADDRTIC         : out   std_logic_vector(31 downto 0);
        HTRANSTIC        : out   std_logic_vector(1 downto 0);
        HWRITETIC        : out   std_logic;
        HSIZETIC         : out   std_logic_vector(2 downto 0);
        HBURSTTIC        : out   std_logic_vector(2 downto 0);
        HPROTTIC         : out   std_logic_vector(3 downto 0);
        HWDATATIC        : out   std_logic_vector(31 downto 0);
        HBUSREQTIC       : out   std_logic;
        HLOCKTIC         : out   std_logic;
        TBUSOUT          : out   std_logic_vector(31 downto 0);
        SMTESTACK        : out   std_logic;
        TICBUSREQ        : out   std_logic;
        TICREAD          : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

-- SsmcCore signals
signal SMTICBUSGNTExt   : std_logic;
-- External bus granted for TIC Transfer

signal SMBUSGNTExt      : std_logic;
-- External bus granted for Memory Transfer

signal SmBusBackOffExt  : std_logic;
-- BackOff indication by EBI

signal BUSMUXEXT        : std_logic;
-- Indication to either use Internal DBI or External EBI

signal ClkStpd          : std_logic;
-- Signal to indicate that clock output should be stopped

signal SMCS             : std_logic_vector(7 downto 0);
-- Chip Selects for external Memory, active HIGH

signal nSMCS            : std_logic_vector(7 downto 0);
-- Chip Selects for external Memory, active LOW

signal SMBUSREQ         : std_logic;
-- Bus Request signal to DBI

signal SmDataEnCore     : std_logic_vector(3 downto 0);
-- Data Enables when Write is progressing

signal SmDataOutCore    : std_logic_vector(31 downto 0);
-- Data Bus output from SSMC


-- SsmcDBI signals
signal SMBUSREQExt      : std_logic;
-- Request EBI for Memory Transfer

signal SMTICBUSREQExt   : std_logic;
-- Request EBI for TIC Transfer

signal TICBUSGNT        : std_logic;
-- Bus Grant to TIC from DBI

signal SMBUSGNT         : std_logic;
-- Bus Grant to SsmcCore from DBI

-- SsmcTIC signals
signal TBUSOUT          : std_logic_vector(31 downto 0);
-- External test vector output data bus

signal TICBUSREQ        : std_logic;
-- TIC bus request to DBI

signal TICREAD          : std_logic;
-- Drive AHB read data onto TBUSOUT

-- SsmcRevAnd signals
signal TieOff1          : std_logic_vector(3 downto 0);
-- Input 1 for SsmcRevAnd

signal TieOff2          : std_logic_vector(3 downto 0);
-- Input 2 for SsmcRevAnd

signal Revision         : std_logic_vector(3 downto 0);
-- Output of SsmcRevAnd


-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcCore
-- -----------------------------------------------------------------------------

uSsmcCore : SsmcCore
  port map (
            HCLK             => HCLK,
            SMMEMCLK         => SMMEMCLK,
            nSMMEMCLK        => nSMMEMCLK,
            SMMEMCLKDELAY    => SMMEMCLKDELAY,
            SMFBCLK0         => SMFBCLK0,
            SMFBCLK1         => SMFBCLK1,
            SMFBCLK2         => SMFBCLK2,
            SMFBCLK3         => SMFBCLK3,
            HRESETn          => HRESETn,
            HADDRSMC         => HADDRSMC,
            HTRANSSMC        => HTRANSSMC,
            HWRITESMC        => HWRITESMC,
            HSIZESMC         => HSIZESMC,
            HBURSTSMC        => HBURSTSMC,
            HWDATASMC        => HWDATASMC,
            HSELSMC          => HSELSMC,
            HREADYINSMC      => HREADYINSMC,
            HADDRREG         => HADDRREG,
            HTRANSREG        => HTRANSREG,
            HWRITEREG        => HWRITEREG,
            HSIZEREG         => HSIZEREG,
            HWDATAREG        => HWDATAREG,
            HSELREG          => HSELREG,
            HREADYINREG      => HREADYINREG,
            SMBUSGNTEBI      => SMBUSGNTEBI,
            SMBUSBACKOFFEBI  => SMBUSBACKOFFEBI,
            SMTICBUSGNTEBI   => SMTICBUSGNTEBI,
            SMBIGENDIAN      => SMBIGENDIAN,
            SMEXTBUSMUX      => SMEXTBUSMUX,
            SMBUSREQExt      => SMBUSREQExt,
            SMTICBUSREQExt   => SMTICBUSREQExt,
            SMMWCS7          => SMMWCS7,
            SMBLS7POL        => SMBLS7POL,
            SMMEMCLKRATIO    => SMMEMCLKRATIO,
            SMWAIT           => SMWAIT,
            SMCANCELWAIT     => SMCANCELWAIT,
            nSMBURSTWAIT     => nSMBURSTWAIT,
            SMDATAIN         => SMDATAIN,
            SMBUSGNT         => SMBUSGNT,
            Revision         => Revision,

            HRDATASMC        => HRDATASMC,
            HREADYOUTSMC     => HREADYOUTSMC,
            HRESPSMC         => HRESPSMC,
            HRDATAREG        => HRDATAREG,
            HREADYOUTREG     => HREADYOUTREG,
            HRESPREG         => HRESPREG,
            SMBUSREQ         => SMBUSREQ,
            SMBUSREQEBI      => SMBUSREQEBI,
            SMTICBUSREQEBI   => SMTICBUSREQEBI,
            SMTICBUSGNTExt   => SMTICBUSGNTExt,
            SMBUSGNTExt      => SMBUSGNTExt,
            SmBusBackOffExt  => SmBusBackOffExt,
            ClkStpd          => ClkStpd,
            BUSMUXEXT        => BUSMUXEXT,
            SmDataEnCore     => SmDataEnCore,
            SmDataOutCore    => SmDataOutCore,
            SMBAA            => SMBAA,
            SMADDRVALID      => SMADDRVALID,
            SMADDR           => SMADDR,
            SMCS             => SMCS,
            nSMCS            => nSMCS,
            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS,
            nSMOEN           => nSMOEN
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcDBI
-- -----------------------------------------------------------------------------
uSsmcDBI : SsmcDBI
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMTICBUSGNTExt   => SMTICBUSGNTExt,
            SMBUSGNTExt      => SMBUSGNTExt,
            SmBusBackOffExt  => SmBusBackOffExt,
            BUSMUXEXT        => BUSMUXEXT,
            SMBUSREQ         => SMBUSREQ,
            TICBUSREQ        => TICBUSREQ,
            TBUSOUT          => TBUSOUT,
            TICREAD          => TICREAD,
            SmDataEnCore     => SmDataEnCore,
            SmDataOutCore    => SmDataOutCore,

            SMBUSREQExt      => SMBUSREQExt,
            SMTICBUSREQExt   => SMTICBUSREQExt,
            SMDATAOUT        => SMDATAOUT,
            nSMDATAEN        => nSMDATAEN,
            TICBUSGNT        => TICBUSGNT,
            SMBUSGNT         => SMBUSGNT
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcTIC
-- -----------------------------------------------------------------------------
uSsmcTIC : SsmcTIC
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HREADYINTIC      => HREADYINTIC,
            HRESPTIC         => HRESPTIC,
            HGRANTTIC        => HGRANTTIC,
            HRDATATIC        => HRDATATIC,
            TBUSIN           => SMDATAIN,
            SMTESTREQA       => SMTESTREQA,
            SMTESTREQB       => SMTESTREQB,
            TICBUSGNT        => TICBUSGNT,

            HADDRTIC         => HADDRTIC,
            HTRANSTIC        => HTRANSTIC,
            HWRITETIC        => HWRITETIC,
            HSIZETIC         => HSIZETIC,
            HBURSTTIC        => HBURSTTIC,
            HPROTTIC         => HPROTTIC,
            HWDATATIC        => HWDATATIC,
            HBUSREQTIC       => HBUSREQTIC,
            HLOCKTIC         => HLOCKTIC,
            TBUSOUT          => TBUSOUT,
            SMTESTACK        => SMTESTACK,
            TICBUSREQ        => TICBUSREQ,
            TICREAD          => TICREAD
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcClockOr for bit 0 of SMCLK[3:0]
-- -----------------------------------------------------------------------------
u0SsmcClockOr : SsmcClockOr
  port map (
            CLKIN            => SMMEMCLK,
            ClkStpd          => ClkStpd,

            CLKOUT           => SMCLK(0)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcClockOr for bit 1 of SMCLK[3:0]
-- -----------------------------------------------------------------------------
u1SsmcClockOr : SsmcClockOr
  port map (
            CLKIN            => SMMEMCLK,
            ClkStpd          => ClkStpd,

            CLKOUT           => SMCLK(1)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcClockOr for bit 2 of SMCLK[3:0]
-- -----------------------------------------------------------------------------
u2SsmcClockOr : SsmcClockOr
  port map (
            CLKIN            => SMMEMCLK,
            ClkStpd          => ClkStpd,

            CLKOUT           => SMCLK(2)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcClockOr for bit 3 of SMCLK[3:0]
-- -----------------------------------------------------------------------------
u3SsmcClockOr : SsmcClockOr
  port map (
            CLKIN            => SMMEMCLK,
            ClkStpd          => ClkStpd,

            CLKOUT           => SMCLK(3)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcRevAnd for bit0 of Revision
-- -----------------------------------------------------------------------------
u0SsmcRevAnd : SsmcRevAnd
  port map (
            TieOff1          => TieOff1(0),
            TieOff2          => TieOff2(0),

            Revision         => Revision(0)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcRevAnd for bit1 of Revision
-- -----------------------------------------------------------------------------
u1SsmcRevAnd : SsmcRevAnd
  port map (
            TieOff1          => TieOff1(1),
            TieOff2          => TieOff2(1),

            Revision         => Revision(1)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcRevAnd for bit2 of Revision
-- -----------------------------------------------------------------------------
u2SsmcRevAnd : SsmcRevAnd
  port map (
            TieOff1          => TieOff1(2),
            TieOff2          => TieOff2(2),

            Revision         => Revision(2)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcRevAnd for bit3 of Revision
-- -----------------------------------------------------------------------------
u3SsmcRevAnd : SsmcRevAnd
  port map (
            TieOff1          => TieOff1(3),
            TieOff2          => TieOff2(3),

            Revision         => Revision(3)
           );

-- -----------------------------------------------------------------------------
-- Assign values to inputs of RevAnd
-- -----------------------------------------------------------------------------
TieOff1  <= "0001";
TieOff2  <= "0001";

-- -----------------------------------------------------------------------------
-- Route appropriate Chip select line
-- -----------------------------------------------------------------------------
SMCS0    <= SMCS(0);
SMCS1    <= SMCS(1);
SMCS2    <= SMCS(2);
SMCS3    <= SMCS(3);
SMCS4    <= SMCS(4);
SMCS5    <= SMCS(5);
SMCS6    <= SMCS(6);
SMCS7    <= SMCS(7);

nSMCS0   <= nSMCS(0);
nSMCS1   <= nSMCS(1);
nSMCS2   <= nSMCS(2);
nSMCS3   <= nSMCS(3);
nSMCS4   <= nSMCS(4);
nSMCS5   <= nSMCS(5);
nSMCS6   <= nSMCS(6);
nSMCS7   <= nSMCS(7);

end structural;

-- --================================== End ==================================--
