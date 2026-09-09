-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrick.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is the top level of the Dmac Trickbox.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrick is
  port (
-- Inputs
        -- Clock and reset
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB reset
        -- AHB slave signals
        HSELDMAC         : in    std_logic; -- Slave Select for DMAC from AHB3
        HSELDMACTr       : in    std_logic; -- Trickbox Select from AHB3
        HWRITE           : in    std_logic; -- Transfer direction
        HTRANS           : in    std_logic; -- Type of transfer on AHB
                                            -- Only HTRANS(1) of the
                                            -- slave AHB should connect
        HADDR            : in    std_logic_vector(20 downto 2);
                                            -- AHB address bus
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- The width of the transfer on AHB3
        HREADYIN         : in    std_logic; -- Transfer done response on AHB3
        HREADYINM        : in    std_logic; -- Transfer done response on AHB1
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB slave write data
        HRESPMBeh        : in    std_logic_vector(1 downto 0);
                                            -- Response on AHB1
        HRDATAMBeh       : in    std_logic_vector(31 downto 0);
                                            -- Data on AHB1
        -- AHB master signals
        HBUSREQDMACM     : in    std_logic; -- Bus request signal to AHB1
        HLOCKDMACM       : in    std_logic; -- HLOCK signal as driven by AHB1
        HTRANSM          : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on AHB1
        HADDRM           : in    std_logic_vector(31 downto 0);
                                            -- AHB1 address bus
        HSIZEM           : in    std_logic_vector(2 downto 0);
                                            -- Width of transfer on AHB1
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Burst length on AHB1
        HPROTM           : in    std_logic_vector(3 downto 0);
                                            -- Protection information on AHB1
        HWRITEM          : in    std_logic; -- Transfer direction on AHB1
        HWDATAM          : in    std_logic_vector(31 downto 0);
                                            -- Write data on AHB1
        -- DMA response signals
        DMACCLR          : in    std_logic_vector(15 downto 0);
                                            -- DMA request clear
        DMACTC           : in    std_logic_vector(15 downto 0);
                                            -- DMA terminal count
        -- DMA interrupt request signals
        DMACINTERR       : in    std_logic; -- DMA error interrupt
                                            -- request
        DMACINTTC        : in    std_logic; -- DMA terminal count
                                            -- interrupt request
        DMACINTR         : in    std_logic; -- DMA combined interrupt
                                            -- request
-- Outputs
        -- AHB master signals
        HREADYOUT        : out   std_logic; -- Transfer done response for AHB3
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer response for AHB3
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data for AHB 3
        HGRANTDMACM      : out   std_logic; -- AHB bus grant for master1
        HREADYOUTM       : out   std_logic; -- Transfer done response for AHB1
        HRESPM           : out   std_logic_vector(1 downto 0);
                                            -- Transfer response for AHB1
        HRDATAM          : out   std_logic_vector(31 downto 0);
                                            -- Read Data for AHB1 Master
        -- DMA request signals
        DMACBREQ         : out   std_logic_vector(15 downto 0);
                                            -- DMA burst transfer request
        DMACLBREQ        : out   std_logic_vector(15 downto 0);
                                            -- DMA last burst transfer request
        DMACSREQ         : out   std_logic_vector(15 downto 0);
                                            -- DMA single transfer request
        DMACLSREQ        : out   std_logic_vector(15 downto 0)
                                            -- DMA last single transfer request
       );
end DmacTrick;

-- -----------------------------------------------------------------------------
--
--                              DmacTrick
--                              =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block is the top level of the Trickbox. This block instantiates the
-- following functional sub-blocks in the trickbox.
--      - DmacTrBehaviour
--      - DmacTrProChkr
--      - DmacTrPeriph
--      - DmacTrMem
--      - DmacTrGntGen
--
-- -----------------------------------------------------------------------------


-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrick is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component DmacTrMem
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector
                                            (SLAVEADDRHB downto SLAVEADDRLB);
        HSELREG          : in    std_logic;
        HWRITE           : in    std_logic;
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HREADYIN         : in    std_logic;
        HADDRM           : in    std_logic_vector
                                            (MASTERADDRHB downto MASTERADDRLB);
        HSELMEM          : in    std_logic;
        HWRITEM          : in    std_logic;
        HTRANSM          : in    std_logic_vector(1 downto 0);
        HBURSTM          : in    std_logic_vector(2 downto 0);
        HSIZEM           : in    std_logic_vector(2 downto 0);
        HWDATAM          : in    std_logic_vector(31 downto 0);
        HREADYINM        : in    std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUTM       : out   std_logic;
        HRESPM           : out   std_logic_vector( 1 downto 0);
        HRDATAM          : out   std_logic_vector(31 downto 0)
       );
end component;

component DmacTrPeriph
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDR            : in    std_logic_vector
                                           (SLAVEADDRHB downto SLAVEADDRLB);
        HSELREG          : in    std_logic;
        HWRITE           : in    std_logic;
        HTRANS           : in    std_logic_vector(1 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HREADYIN         : in    std_logic;
        HADDRM           : in    std_logic_vector
                                           (MASTERADDRHB downto MASTERADDRLB);
        HSELPERIPH       : in    std_logic;
        HWRITEM          : in    std_logic;
        HTRANSM          : in    std_logic_vector(1 downto 0);
        HBURSTM          : in    std_logic_vector(2 downto 0);
        HSIZEM           : in    std_logic_vector(2 downto 0);
        HWDATAM          : in    std_logic_vector(31 downto 0);
        HREADYINM        : in    std_logic;
        DMACTC           : in    std_logic;
        DMACCLR          : in    std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        HREADYOUTM       : out   std_logic;
        HRESPM           : out   std_logic_vector(1 downto 0);
        HRDATAM          : out   std_logic_vector(31 downto 0);
        DMACSREQ         : out   std_logic;
        DMACBREQ         : out   std_logic;
        DMACLSREQ        : out   std_logic;
        DMACLBREQ        : out   std_logic
       );
end component;

component DmacTrBehaviour
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELDMAC         : in    std_logic;
        HSELDMACTrSlave  : in    std_logic;
        HWRITE           : in    std_logic;
        HTRANS           : in    std_logic;
        HADDR            : in    std_logic_vector(20 downto 2);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HREADYIN         : in    std_logic;
        HGRANTDMACM1     : in    std_logic;
        HGRANTDMACM2     : in    std_logic;
        HREADYINM1       : in    std_logic;
        HREADYINM2       : in    std_logic;
        HRESPM1          : in    std_logic_vector(1 downto 0);
        HRESPM2          : in    std_logic_vector(1 downto 0);
        HRDATAM1         : in    std_logic_vector(31 downto 0);
        HRDATAM2         : in    std_logic_vector(31 downto 0);
        DMACBREQ         : in    std_logic_vector(15 downto 0);
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
        DMACSREQ         : in    std_logic_vector(15 downto 0);
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HBUSREQDMACM1    : out   std_logic;
        HBUSREQDMACM2    : out   std_logic;
        HLOCKDMACM1      : out   std_logic;
        HLOCKDMACM2      : out   std_logic;
        HTRANSM1         : out   std_logic_vector(1 downto 0);
        HTRANSM2         : out   std_logic_vector(1 downto 0);
        HADDRM1          : out   std_logic_vector(31 downto 0);
        HADDRM2          : out   std_logic_vector(31 downto 0);
        HSIZEM1          : out   std_logic_vector(2 downto 0);
        HSIZEM2          : out   std_logic_vector(2 downto 0);
        HBURSTM1         : out   std_logic_vector(2 downto 0);
        HBURSTM2         : out   std_logic_vector(2 downto 0);
        HPROTM1          : out   std_logic_vector(3 downto 0);
        HPROTM2          : out   std_logic_vector(3 downto 0);
        HWRITEM1         : out   std_logic;
        HWRITEM2         : out   std_logic;
        HWDATAM1         : out   std_logic_vector(31 downto 0);
        HWDATAM2         : out   std_logic_vector(31 downto 0);
        DMACCLR          : out   std_logic_vector(15 downto 0);
        DMACTC           : out   std_logic_vector(15 downto 0);
        DMACINTERR       : out   std_logic;
        DMACINTTC        : out   std_logic;
        DMACINTR         : out   std_logic;
        DmacTrEn         : out   std_logic;
        ReqConfig        : out   std_logic_vector(17 downto 0);
        GrantCount0      : out   std_logic_vector(31 downto 0);
        GrantCount1      : out   std_logic_vector(31 downto 0)
       );
end component;

component DmacTrProChkr
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HBUSREQDMACM     : in    std_logic;
        HLOCKDMACM       : in    std_logic;
        HTRANSM          : in    std_logic_vector(1 downto 0);
        HADDRM           : in    std_logic_vector(31 downto 0);
        HSIZEM           : in    std_logic_vector(2 downto 0);
        HBURSTM          : in    std_logic_vector(2 downto 0);
        HPROTM           : in    std_logic_vector(3 downto 0);
        HWRITEM          : in    std_logic;
        HWDATAM          : in    std_logic_vector(31 downto 0);
        DMACCLR          : in    std_logic_vector(15 downto 0);
        DMACTC           : in    std_logic_vector(15 downto 0);
        DMACINTERR       : in    std_logic;
        DMACINTTC        : in    std_logic;
        DMACINTR         : in    std_logic;
        HBUSREQMTr       : in    std_logic;
        HLOCKMTr         : in    std_logic;
        HTRANSMTr        : in    std_logic_vector(1 downto 0);
        HADDRMTr         : in    std_logic_vector(31 downto 0);
        HSIZEMTr         : in    std_logic_vector(2 downto 0);
        HBURSTMTr        : in    std_logic_vector(2 downto 0);
        HPROTMTr         : in    std_logic_vector(3 downto 0);
        HWRITEMTr        : in    std_logic;
        HWDATAMTr        : in    std_logic_vector(31 downto 0);
        DMACCLRTr        : in    std_logic_vector(15 downto 0);
        DMACTCTr         : in    std_logic_vector(15 downto 0);
        DMACINTERRTr     : in    std_logic;
        DMACINTTCTr      : in    std_logic;
        DMACINTRTr       : in    std_logic;
        HREADYINM        : in    std_logic;
        HGRANTDMACM      : in    std_logic;
        DmacTrEn         : in    std_logic
       );
end component;

component DmacTrGntGen
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HBUSREQDMAC      : in    std_logic;
        HREADYINM        : in    std_logic;
        HBURSTM          : in    std_logic_vector(2 downto 0);
        GrantCount       : in    std_logic_vector(31 downto 0);
        HGRANTDMACM      : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Signal declarations
-- ----------------------------------------------------------------------------
signal HSELDMACTrSlave  : std_logic;
-- Slave Select for Trickbox

signal HBUSREQM1Tr      : std_logic;
-- Bus req signal to the AHB Arb1

signal HBUSREQM2Tr      : std_logic;
-- Bus req signal to the AHB Arb2

signal HLOCKM1Tr        : std_logic;
-- Indicates locked transfer on AHB1

signal HLOCKM2Tr        : std_logic;
-- Indicates locked transfer on AHB2

signal HTRANSM1Tr       : std_logic_vector(1 downto 0);
-- Type of transfer on AHB1

signal HTRANSM2Tr       : std_logic_vector(1 downto 0);
-- Type of transfer on AHB2

signal HADDRM1Tr        : std_logic_vector(31 downto 0);
-- AHB1 address bus

signal HADDRM2Tr        : std_logic_vector(31 downto 0);
-- AHB2 address bus

signal HSIZEM1Tr        : std_logic_vector(2 downto 0);
-- Width of transfer on AHB1

signal HSIZEM2Tr        : std_logic_vector(2 downto 0);
-- Width of transfer on AHB2

signal HBURSTM1Tr       : std_logic_vector(2 downto 0);
-- Burst length on AHB1

signal HBURSTM2Tr       : std_logic_vector(2 downto 0);
-- Burst length on AHB2

signal HPROTM1Tr        : std_logic_vector(3 downto 0);
-- Protection information on AHB1

signal HPROTM2Tr        : std_logic_vector(3 downto 0);
-- Protection information on AHB2

signal HWRITEM1Tr       : std_logic;
-- Transfer direction on AHB1

signal HWRITEM2Tr       : std_logic;
-- Transfer direction on AHB2

signal HWDATAM1Tr       : std_logic_vector(31 downto 0);
-- Write data to AHB1

signal HWDATAM2Tr       : std_logic_vector(31 downto 0);
-- Write data to AHB2

signal DMACCLRTr        : std_logic_vector(15 downto 0);
-- DMAC request clear

signal DMACTCTr         : std_logic_vector(15 downto 0);
-- DMAC terminal count

signal DMACINTERRTr     : std_logic;
-- DMAC error interrupt request

signal DMACINTTCTr      : std_logic;
-- DMAC terminal count interrupt

signal DMACINTRTr       : std_logic;
-- DMAC combined interrupt request

signal iDMACSREQ        : std_logic_vector(15 downto 0);
-- Internal copy of DMACSREQ

signal iDMACBREQ        : std_logic_vector(15 downto 0);
-- Internal copy of DMACBREQ

signal iDMACLSREQ       : std_logic_vector(15 downto 0);
-- Internal copy of DMACLSREQ

signal iDMACLBREQ       : std_logic_vector(15 downto 0);
-- Internal copy of DMACLBREQ

signal HRDATAM1         : std_logic_vector(31 downto 0);
-- Internal copy of HRDATAM1

signal HRDATAM2         : std_logic_vector(31 downto 0);
-- Internal copy of HRDATAM2

signal HRESPM1          : std_logic_vector(1 downto 0);
-- Internal copy of HRESPM1

signal HRESPM2          : std_logic_vector(1 downto 0);
-- Internal copy of HRESPM2

signal HREADYOUTM1      : std_logic;
-- Internal copy of HREADYOUTM1

signal HREADYOUTM2      : std_logic;
-- Internal copy of HREADYOUTM2

signal iHREADYOUT       : std_logic;
-- Internal copy of HREADYOUT

signal iHRDATA          : std_logic_vector(31 downto 0);
-- Internal copy of HRDATA

signal iHRESP           : std_logic_vector(1 downto 0);
-- Internal copy of HRESP

signal HTRANSIn         : std_logic_vector(1 downto 0);
-- Internal copy of HTRANS

signal ReqConfig        : std_logic_vector(17 downto 0);
-- Trickbox config Reg for Perp/Mem

signal GrantCount0      : std_logic_vector(31 downto 0);
-- Trickbox Grant Generation Reg used by AHB Arbiter0

signal GrantCount1      : std_logic_vector(31 downto 0);
-- Trickbox Grant Generation Reg used by AHB Arbiter1

signal DmacTrEn         : std_logic;
-- DMAC Trickbox Enable

-- DmacTrickBehaviour output internal signal
signal HREADYOUTTrIn    : std_logic;
signal HRESPTrIn       : std_logic_vector(1 downto 0);

-- Memory Module0 signal
signal HSELREGuM0       : std_logic;
-- Register Select of Memory 0

signal HREADYOUTuM0     : std_logic;
-- HREAYOUT of Memory 0

signal HRESPuM0         : std_logic_vector(1 downto 0);
-- HRESP of Memory 0

signal HRDATAuM0        : std_logic_vector(31 downto 0);
-- HRDATA of Memory 0

signal HADDRMuM0        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Memory 0

signal HSELMEMuM0       : std_logic;
-- Memory 0 Select signal

signal HWRITEMuM0       : std_logic;
-- Memory 0 read/write

signal HTRANSMuM0       : std_logic_vector(1 downto 0);
-- HTRANSM of Memory 0

signal HSIZEMuM0        : std_logic_vector(2 downto 0);
-- HSIZEM of Memory 0

signal HBURSTMuM0       : std_logic_vector(2 downto 0);
-- HBURSTM of Memory 0

signal HWDATAMuM0       : std_logic_vector(31 downto 0);
-- Write Data of Memory 0

signal HREADYINMuM0     : std_logic;
-- HREADYINM of Memory 0

signal HREADYOUTMuM0    : std_logic;
-- HREADYOUTM of Memory 0

signal HRESPMuM0        : std_logic_vector(1 downto 0);
-- HRESPM of Memory 0

signal HRDATAMuM0       : std_logic_vector(31 downto 0);
-- Read Data of Memory 0

-- Memory Module1 signal
signal HSELREGuM1       : std_logic;
-- Register Select of Memory 1

signal HREADYOUTuM1    : std_logic;
-- HREAYOUT of Memory 1

signal HRESPuM1        : std_logic_vector(1 downto 0);
-- HRESP of Memory 1

signal HRDATAuM1       : std_logic_vector(31 downto 0);
-- HRDATA of Memory 1

signal HADDRMuM1        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Memory 1

signal HSELMEMuM1       : std_logic;
-- Memory 1 Select signal

signal HWRITEMuM1       : std_logic;
-- Memory 1 read/write

signal HTRANSMuM1       : std_logic_vector(1 downto 0);
-- HTRANSM of Memory 1

signal HSIZEMuM1        : std_logic_vector(2 downto 0);
-- HSIZEM of Memory 1

signal HBURSTMuM1       : std_logic_vector(2 downto 0);
-- HBURSTM of Memory 1

signal HWDATAMuM1       : std_logic_vector(31 downto 0);
-- Write Data of Memory 1

signal HREADYINMuM1     : std_logic;
-- HREADYINM of Memory 1

signal HREADYOUTMuM1    : std_logic;
-- HREADYOUTM of Memory 1

signal HRESPMuM1        : std_logic_vector(1 downto 0);
-- HRESPM of Memory 1

signal HRDATAMuM1       : std_logic_vector(31 downto 0);
-- Read Data of Memory 1

-- Peripheral Module1 signal
signal HSELREGuP0       : std_logic;
-- Register Select of Peripheral 0

signal HREADYOUTuP0     : std_logic;
-- HREAYOUT of Peripheral 0

signal HRESPuP0         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 0

signal HRDATAuP0        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 0

signal HADDRMuP0        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 0

signal HSELPERIPHuP0    : std_logic;
-- Peripheral 0 Select signal

signal HWRITEMuP0       : std_logic;
-- Peripheral 0 read/write

signal HTRANSMuP0       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 0

signal HSIZEMuP0        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 0

signal HBURSTMuP0       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 0

signal HWDATAMuP0       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 0

signal HREADYINMuP0     : std_logic;
-- HREADYINM of Peripheral 0

signal HREADYOUTMuP0    : std_logic;
-- HREADYOUTM of Peripheral 0

signal HRESPMuP0        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 0

signal HRDATAMuP0       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 0

-- Peripheral Module1 signal
signal HSELREGuP1       : std_logic;
-- Register Select of Peripheral 0

signal HREADYOUTuP1     : std_logic;
-- HREAYOUT of Peripheral 1

signal HRESPuP1         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 1

signal HRDATAuP1        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 1

signal HADDRMuP1        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 1

signal HSELPERIPHuP1    : std_logic;
-- Peripheral 1 Select signal

signal HWRITEMuP1       : std_logic;
-- Peripheral 1 read/write

signal HTRANSMuP1       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 1

signal HSIZEMuP1        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 1

signal HBURSTMuP1       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 1

signal HWDATAMuP1       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 1

signal HREADYINMuP1     : std_logic;
-- HREADYINM of Peripheral 1

signal HREADYOUTMuP1    : std_logic;
-- HREADYOUTM of Peripheral 1

signal HRESPMuP1        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 1

signal HRDATAMuP1       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 1

-- Peripheral Module 2 signal
signal HSELREGuP2       : std_logic;
-- Register Select of Peripheral 2

signal HREADYOUTuP2     : std_logic;
-- HREAYOUT of Peripheral 2

signal HRESPuP2         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 2

signal HRDATAuP2        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 2

signal HADDRMuP2        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 2

signal HSELPERIPHuP2    : std_logic;
-- Peripheral 2 Select signal

signal HWRITEMuP2       : std_logic;
-- Peripheral 2 read/write

signal HTRANSMuP2       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 2

signal HSIZEMuP2        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 2

signal HBURSTMuP2       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 2

signal HWDATAMuP2       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 2

signal HREADYINMuP2     : std_logic;
-- HREADYINM of Peripheral 2

signal HREADYOUTMuP2    : std_logic;
-- HREADYOUTM of Peripheral 2

signal HRESPMuP2        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 2

signal HRDATAMuP2       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 2

-- Peripheral Module 3 signal
signal HSELREGuP3       : std_logic;
-- Register Select of Peripheral 3

signal HREADYOUTuP3     : std_logic;
-- HREAYOUT of Peripheral 3

signal HRESPuP3         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 3

signal HRDATAuP3        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 3

signal HADDRMuP3        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 3

signal HSELPERIPHuP3    : std_logic;
-- Peripheral 3 Select signal

signal HWRITEMuP3       : std_logic;
-- Peripheral 3 read/write

signal HTRANSMuP3       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 3

signal HSIZEMuP3        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 3

signal HBURSTMuP3       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 3

signal HWDATAMuP3       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 3

signal HREADYINMuP3     : std_logic;
-- HREADYINM of Peripheral 3

signal HREADYOUTMuP3    : std_logic;
-- HREADYOUTM of Peripheral 3

signal HRESPMuP3        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 3

signal HRDATAMuP3       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 3

-- Peripheral Module 4 signal
signal HSELREGuP4       : std_logic;
-- Register Select of Peripheral 4

signal HREADYOUTuP4     : std_logic;
-- HREAYOUT of Peripheral 4

signal HRESPuP4         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 4

signal HRDATAuP4        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 4

signal HADDRMuP4        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 4

signal HSELPERIPHuP4    : std_logic;
-- Peripheral 4 Select signal

signal HWRITEMuP4       : std_logic;
-- Peripheral 4 read/write

signal HTRANSMuP4       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 4

signal HSIZEMuP4        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 4

signal HBURSTMuP4       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 4

signal HWDATAMuP4       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 4

signal HREADYINMuP4     : std_logic;
-- HREADYINM of Peripheral 4

signal HREADYOUTMuP4    : std_logic;
-- HREADYOUTM of Peripheral 4

signal HRESPMuP4        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 4

signal HRDATAMuP4       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 4

-- Peripheral Module 5 signal
signal HSELREGuP5       : std_logic;
-- Register Select of Peripheral 5

signal HREADYOUTuP5     : std_logic;
-- HREAYOUT of Peripheral 5

signal HRESPuP5         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 5

signal HRDATAuP5        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 5

signal HADDRMuP5        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 5

signal HSELPERIPHuP5    : std_logic;
-- Peripheral 5 Select signal

signal HWRITEMuP5       : std_logic;
-- Peripheral 5 read/write

signal HTRANSMuP5       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 5

signal HSIZEMuP5        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 5

signal HBURSTMuP5       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 5

signal HWDATAMuP5       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 5

signal HREADYINMuP5     : std_logic;
-- HREADYINM of Peripheral 5

signal HREADYOUTMuP5    : std_logic;
-- HREADYOUTM of Peripheral 5

signal HRESPMuP5        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 5

signal HRDATAMuP5       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 5

-- Peripheral Module 6 signal
signal HSELREGuP6       : std_logic;
-- Register Select of Peripheral 6

signal HREADYOUTuP6     : std_logic;
-- HREAYOUT of Peripheral 6

signal HRESPuP6         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 6

signal HRDATAuP6        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 6

signal HADDRMuP6        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 6

signal HSELPERIPHuP6    : std_logic;
-- Peripheral 6 Select signal

signal HWRITEMuP6       : std_logic;
-- Peripheral 6 read/write

signal HTRANSMuP6       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 6

signal HSIZEMuP6        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 6

signal HBURSTMuP6       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 6

signal HWDATAMuP6       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 6

signal HREADYINMuP6     : std_logic;
-- HREADYINM of Peripheral 6

signal HREADYOUTMuP6    : std_logic;
-- HREADYOUTM of Peripheral 6

signal HRESPMuP6        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 6

signal HRDATAMuP6       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 6

-- Peripheral Module 7 signal
signal HSELREGuP7       : std_logic;
-- Register Select of Peripheral 7

signal HREADYOUTuP7     : std_logic;
-- HREAYOUT of Peripheral 7

signal HRESPuP7         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 7

signal HRDATAuP7        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 7

signal HADDRMuP7        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 7

signal HSELPERIPHuP7    : std_logic;
-- Peripheral 7 Select signal

signal HWRITEMuP7       : std_logic;
-- Peripheral 7 read/write

signal HTRANSMuP7       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 7

signal HSIZEMuP7        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 7

signal HBURSTMuP7       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 7

signal HWDATAMuP7       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 7

signal HREADYINMuP7     : std_logic;
-- HREADYINM of Peripheral 7

signal HREADYOUTMuP7    : std_logic;
-- HREADYOUTM of Peripheral 7

signal HRESPMuP7        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 7

signal HRDATAMuP7       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 7

-- Peripheral Module 8 signal
signal HSELREGuP8       : std_logic;
-- Register Select of Peripheral 8

signal HREADYOUTuP8     : std_logic;
-- HREAYOUT of Peripheral 8

signal HRESPuP8         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 8

signal HRDATAuP8        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 8

signal HADDRMuP8        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 8

signal HSELPERIPHuP8    : std_logic;
-- Peripheral 8 Select signal

signal HWRITEMuP8       : std_logic;
-- Peripheral 8 read/write

signal HTRANSMuP8       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 8

signal HSIZEMuP8        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 8

signal HBURSTMuP8       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 8

signal HWDATAMuP8       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 8

signal HREADYINMuP8     : std_logic;
-- HREADYINM of Peripheral 8

signal HREADYOUTMuP8    : std_logic;
-- HREADYOUTM of Peripheral 8

signal HRESPMuP8        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 8

signal HRDATAMuP8       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 8

-- Peripheral Module 9 signal
signal HSELREGuP9       : std_logic;
-- Register Select of Peripheral 9

signal HREADYOUTuP9     : std_logic;
-- HREAYOUT of Peripheral 9

signal HRESPuP9         : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 9

signal HRDATAuP9        : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 9

signal HADDRMuP9        : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 9

signal HSELPERIPHuP9    : std_logic;
-- Peripheral 9 Select signal

signal HWRITEMuP9       : std_logic;
-- Peripheral 9 read/write

signal HTRANSMuP9       : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 9

signal HSIZEMuP9        : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 9

signal HBURSTMuP9       : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 9

signal HWDATAMuP9       : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 9

signal HREADYINMuP9     : std_logic;
-- HREADYINM of Peripheral 9

signal HREADYOUTMuP9    : std_logic;
-- HREADYOUTM of Peripheral 9

signal HRESPMuP9        : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 9

signal HRDATAMuP9       : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 9

-- Peripheral Module10 signal
signal HSELREGuP10      : std_logic;
-- Register Select of Peripheral 10

signal HREADYOUTuP10    : std_logic;
-- HREAYOUT of Peripheral 10

signal HRESPuP10        : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 10

signal HRDATAuP10       : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 10

signal HADDRMuP10       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 10

signal HSELPERIPHuP10   : std_logic;
-- Peripheral 10 Select signal

signal HWRITEMuP10      : std_logic;
-- Peripheral 10 read/write

signal HTRANSMuP10      : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 10

signal HSIZEMuP10       : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 10

signal HBURSTMuP10      : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 10

signal HWDATAMuP10      : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 10

signal HREADYINMuP10    : std_logic;
-- HREADYINM of Peripheral 10

signal HREADYOUTMuP10   : std_logic;
-- HREADYOUTM of Peripheral 10

signal HRESPMuP10       : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 10

signal HRDATAMuP10      : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 10

-- Peripheral Module 11 signal
signal HSELREGuP11      : std_logic;
-- Register Select of Peripheral 11

signal HREADYOUTuP11    : std_logic;
-- HREAYOUT of Peripheral 11

signal HRESPuP11        : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 11

signal HRDATAuP11       : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 11

signal HADDRMuP11       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 11

signal HSELPERIPHuP11   : std_logic;
-- Peripheral 11 Select signal

signal HWRITEMuP11      : std_logic;
-- Peripheral 11 read/write

signal HTRANSMuP11      : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 11

signal HSIZEMuP11       : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 11

signal HBURSTMuP11      : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 11

signal HWDATAMuP11      : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 11

signal HREADYINMuP11    : std_logic;
-- HREADYINM of Peripheral 11

signal HREADYOUTMuP11   : std_logic;
-- HREADYOUTM of Peripheral 11

signal HRESPMuP11       : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 11

signal HRDATAMuP11      : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 11

-- Peripheral Module 12 signal
signal HSELREGuP12      : std_logic;
-- Register Select of Peripheral 12

signal HREADYOUTuP12    : std_logic;
-- HREAYOUT of Peripheral 12

signal HRESPuP12        : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 12

signal HRDATAuP12       : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 12

signal HADDRMuP12       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 12

signal HSELPERIPHuP12   : std_logic;
-- Peripheral 12 Select signal

signal HWRITEMuP12      : std_logic;
-- Peripheral 12 read/write

signal HTRANSMuP12      : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 12

signal HSIZEMuP12       : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 12

signal HBURSTMuP12      : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 12

signal HWDATAMuP12      : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 12

signal HREADYINMuP12    : std_logic;
-- HREADYINM of Peripheral 12

signal HREADYOUTMuP12   : std_logic;
-- HREADYOUTM of Peripheral 12

signal HRESPMuP12       : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 12

signal HRDATAMuP12      : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 12

-- Peripheral Module 13 signal
signal HSELREGuP13      : std_logic;
-- Register Select of Peripheral 13

signal HREADYOUTuP13    : std_logic;
-- HREAYOUT of Peripheral 13

signal HRESPuP13        : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 13

signal HRDATAuP13       : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 13

signal HADDRMuP13       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 13

signal HSELPERIPHuP13   : std_logic;
-- Peripheral 13 Select signal

signal HWRITEMuP13      : std_logic;
-- Peripheral 13 read/write

signal HTRANSMuP13      : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 13

signal HSIZEMuP13       : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 13

signal HBURSTMuP13      : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 13

signal HWDATAMuP13      : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 13

signal HREADYINMuP13    : std_logic;
-- HREADYINM of Peripheral 13

signal HREADYOUTMuP13   : std_logic;
-- HREADYOUTM of Peripheral 13

signal HRESPMuP13       : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 13

signal HRDATAMuP13      : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 13

-- Peripheral Module 14 signal
signal HSELREGuP14      : std_logic;
-- Register Select of Peripheral 14

signal HREADYOUTuP14    : std_logic;
-- HREAYOUT of Peripheral 14

signal HRESPuP14        : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 14

signal HRDATAuP14       : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 14

signal HADDRMuP14       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 14

signal HSELPERIPHuP14   : std_logic;
-- Peripheral 14 Select signal

signal HWRITEMuP14      : std_logic;
-- Peripheral 14 read/write

signal HTRANSMuP14      : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 14

signal HSIZEMuP14       : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 14

signal HBURSTMuP14      : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 14

signal HWDATAMuP14      : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 14

signal HREADYINMuP14    : std_logic;
-- HREADYINM of Peripheral 14

signal HREADYOUTMuP14   : std_logic;
-- HREADYOUTM of Peripheral 14

signal HRESPMuP14       : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 14

signal HRDATAMuP14      : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 14

-- Peripheral Module 15 signal
signal HSELREGuP15      : std_logic;
-- Register Select of Peripheral 15

signal HREADYOUTuP15    : std_logic;
-- HREAYOUT of Peripheral 15

signal HRESPuP15        : std_logic_vector(1 downto 0);
-- HRESP of Peripheral 15

signal HRDATAuP15       : std_logic_vector(31 downto 0);
-- HRDATA of Peripheral 15

signal HADDRMuP15       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- HADDRM of Peripheral 15

signal HSELPERIPHuP15   : std_logic;
-- Peripheral 15 Select signal

signal HWRITEMuP15      : std_logic;
-- Peripheral 15 read/write

signal HTRANSMuP15      : std_logic_vector(1 downto 0);
-- HTRANSM of Peripheral 15

signal HSIZEMuP15       : std_logic_vector(2 downto 0);
-- HSIZEM of Peripheral 15

signal HBURSTMuP15      : std_logic_vector(2 downto 0);
-- HBURSTM of Peripheral 15

signal HWDATAMuP15      : std_logic_vector(31 downto 0);
-- Write Data of Peripheral 15

signal HREADYINMuP15    : std_logic;
-- HREADYINM of Peripheral 15

signal HREADYOUTMuP15   : std_logic;
-- HREADYOUTM of Peripheral 15

signal HRESPMuP15       : std_logic_vector(1 downto 0);
-- HRESPM of Peripheral 15

signal HRDATAMuP15      : std_logic_vector(31 downto 0);
-- Read Data of Peripheral 15

signal HGRANTDMACM1    : std_logic;
-- Internal copy of HGRANTDMACM

signal RegSyncTr        : std_logic;
-- Delayed HSELDMACTrSlave

signal RegSyncMem0      : std_logic;
-- Delayed HSELREG of Memory 0

signal RegSyncMem1      : std_logic;
-- Delayed HSELREG of Memory 1

signal RegSyncP0        : std_logic;
-- Delayed HSELREG of Peripheral 0

signal RegSyncP1        : std_logic;
-- Delayed HSELREG of Peripheral 1

signal RegSyncP2        : std_logic;
-- Delayed HSELREG of Peripheral 2

signal RegSyncP3        : std_logic;
-- Delayed HSELREG of Peripheral 3

signal RegSyncP4        : std_logic;
-- Delayed HSELREG of Peripheral 4

signal RegSyncP5        : std_logic;
-- Delayed HSELREG of Peripheral 5

signal RegSyncP6        : std_logic;
-- Delayed HSELREG of Peripheral 6

signal RegSyncP7        : std_logic;
-- Delayed HSELREG of Peripheral 7

signal RegSyncP8        : std_logic;
-- Delayed HSELREG of Peripheral 8

signal RegSyncP9        : std_logic;
-- Delayed HSELREG of Peripheral 9

signal RegSyncP10       : std_logic;
-- Delayed HSELREG of Peripheral 10

signal RegSyncP11       : std_logic;
-- Delayed HSELREG of Peripheral 11

signal RegSyncP12       : std_logic;
-- Delayed HSELREG of Peripheral 12

signal RegSyncP13       : std_logic;
-- Delayed HSELREG of Peripheral 13

signal RegSyncP14       : std_logic;
-- Delayed HSELREG of Peripheral 14

signal RegSyncP15       : std_logic;
-- Delayed HSELREG of Peripheral 15

signal SyncMem0         : std_logic;
-- Selected State of Memory 0

signal SyncMem1         : std_logic;
-- Selected State of Memory 0

signal SyncPeriph0      : std_logic;
-- Selected State of Peripheral 0

signal SyncPeriph1      : std_logic;
-- Selected State of Peripheral 1

signal SyncPeriph2      : std_logic;
-- Selected State of Peripheral 2

signal SyncPeriph3      : std_logic;
-- Selected State of Peripheral 3

signal SyncPeriph4      : std_logic;
-- Selected State of Peripheral 4

signal SyncPeriph5      : std_logic;
-- Selected State of Peripheral 5

signal SyncPeriph6      : std_logic;
-- Selected State of Peripheral 6

signal SyncPeriph7      : std_logic;
-- Selected State of Peripheral 7

signal SyncPeriph8      : std_logic;
-- Selected State of Peripheral 8

signal SyncPeriph9      : std_logic;
-- Selected State of Peripheral 9

signal SyncPeriph10     : std_logic;
-- Selected State of Peripheral 10

signal SyncPeriph11     : std_logic;
-- Selected State of Peripheral 11

signal SyncPeriph12     : std_logic;
-- Selected State of Peripheral 12

signal SyncPeriph13     : std_logic;
-- Selected State of Peripheral 13

signal SyncPeriph14     : std_logic;
-- Selected State of Peripheral 14

signal SyncPeriph15     : std_logic;
-- Selected State of Peripheral 15

signal NxtRegSyncTr     : std_logic;
-- D input of RegSyncTr

signal NxtRegSyncMem0   : std_logic;
-- D input of RegSyncMem0

signal NxtRegSyncMem1   : std_logic;
-- D input of RegSyncMem1

signal NxtRegSyncP0     : std_logic;
-- D input of RegSyncP0

signal NxtRegSyncP1     : std_logic;
-- D input of RegSyncP1

signal NxtRegSyncP2     : std_logic;
-- D input of RegSyncP2

signal NxtRegSyncP3     : std_logic;
-- D input of RegSyncP3

signal NxtRegSyncP4     : std_logic;
-- D input of RegSyncP4

signal NxtRegSyncP5     : std_logic;
-- D input of RegSyncP5

signal NxtRegSyncP6     : std_logic;
-- D input of RegSyncP6

signal NxtRegSyncP7     : std_logic;
-- D input of RegSyncP7

signal NxtRegSyncP8     : std_logic;
-- D input of RegSyncP8

signal NxtRegSyncP9     : std_logic;
-- D input of RegSyncP9

signal NxtRegSyncP10    : std_logic;
-- D input of RegSyncP10

signal NxtRegSyncP11    : std_logic;
-- D input of RegSyncP11

signal NxtRegSyncP12    : std_logic;
-- D input of RegSyncP12

signal NxtRegSyncP13    : std_logic;
-- D input of RegSyncP13

signal NxtRegSyncP14    : std_logic;
-- D input of RegSyncP14

signal NxtRegSyncP15    : std_logic;
-- D input of RegSyncP15


signal NxtSyncMem0      : std_logic;
-- D input of SyncMem0

signal NxtSyncMem1      : std_logic;
-- D input of SyncMem1

signal NxtSyncPeriph0   : std_logic;
-- D input of SyncPeriph0

signal NxtSyncPeriph1   : std_logic;
-- D input of SyncPeriph1

signal NxtSyncPeriph2   : std_logic;
-- D input of SyncPeriph2

signal NxtSyncPeriph3   : std_logic;
-- D input of SyncPeriph3

signal NxtSyncPeriph4   : std_logic;
-- D input of SyncPeriph4

signal NxtSyncPeriph5   : std_logic;
-- D input of SyncPeriph5

signal NxtSyncPeriph6   : std_logic;
-- D input of SyncPeriph6

signal NxtSyncPeriph7   : std_logic;
-- D input of SyncPeriph7

signal NxtSyncPeriph8   : std_logic;
-- D input of SyncPeriph8

signal NxtSyncPeriph9   : std_logic;
-- D input of SyncPeriph9

signal NxtSyncPeriph10  : std_logic;
-- D input of SyncPeriph10

signal NxtSyncPeriph11  : std_logic;
-- D input of SyncPeriph11

signal NxtSyncPeriph12  : std_logic;
-- D input of SyncPeriph12

signal NxtSyncPeriph13  : std_logic;
-- D input of SyncPeriph13

signal NxtSyncPeriph14  : std_logic;
-- D input of SyncPeriph14

signal NxtSyncPeriph15  : std_logic;
-- D input of SyncPeriph15

-- Removed/renamed ports at the top level are modified over here.
-- For master1 related unused signals
signal HREADYINM1       : std_logic;
signal HRESPM1Beh       : std_logic_vector(1 downto 0);
signal HRDATAM1Beh      : std_logic_vector(31 downto 0);
signal HBUSREQDMACM1    : std_logic;
signal HLOCKDMACM1      : std_logic;
signal HTRANSM1         : std_logic_vector(1 downto 0);
signal HADDRM1          : std_logic_vector(31 downto 0);
signal HSIZEM1          : std_logic_vector(2 downto 0);
signal HBURSTM1         : std_logic_vector(2 downto 0);
signal HPROTM1          : std_logic_vector(3 downto 0);
signal HWRITEM1         : std_logic;
signal HWDATAM1         : std_logic_vector(31 downto 0);

-- For master2 related unused signals
signal HREADYINM2       : std_logic;
signal HRESPM2Beh       : std_logic_vector(1 downto 0);
signal HRDATAM2Beh      : std_logic_vector(31 downto 0);
signal HBUSREQDMACM2    : std_logic;
signal HLOCKDMACM2      : std_logic;
signal HTRANSM2         : std_logic_vector(1 downto 0);
signal HADDRM2          : std_logic_vector(31 downto 0);
signal HSIZEM2          : std_logic_vector(2 downto 0);
signal HBURSTM2         : std_logic_vector(2 downto 0);
signal HPROTM2          : std_logic_vector(3 downto 0);
signal HWRITEM2         : std_logic;
signal HWDATAM2         : std_logic_vector(31 downto 0);

signal ZEROFILL         : std_logic_vector(31 downto 0) := (others => '0');
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
-- Assigning the inputs to the internal copies of the signal to keep the
-- modification simple
-- -----------------------------------------------------------------------------
HREADYINM1       <= HREADYINM;
HRESPM1Beh       <= HRESPMBeh;
HRDATAM1Beh      <= HRDATAMBeh;
HBUSREQDMACM1    <= HBUSREQDMACM;
HLOCKDMACM1      <= HLOCKDMACM;
HTRANSM1         <= HTRANSM;
HADDRM1          <= HADDRM;
HSIZEM1          <= HSIZEM;
HBURSTM1         <= HBURSTM;
HPROTM1          <= HPROTM;
HWRITEM1         <= HWRITEM;
HWDATAM1         <= HWDATAM;

-- -----------------------------------------------------------------------------
-- Assigning the internally derived outputs to the actual output ports of the
-- signal to keep the modification simple
-- -----------------------------------------------------------------------------
HGRANTDMACM      <= HGRANTDMACM1;
HREADYOUTM       <= HREADYOUTM1;
HRESPM           <= HRESPM1;
HRDATAM          <= HRDATAM1;

-- -----------------------------------------------------------------------------
-- Assigning the internal copies to output
-- -----------------------------------------------------------------------------
HTRANSIn         <= HTRANS & '0';

-- -----------------------------------------------------------------------------
-- Select signal generation
-- -----------------------------------------------------------------------------
-- Generation of DMAC Trickbox Slave Select
HSELDMACTrSlave  <= '1' when (HADDR(20 downto 16) = "00000"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Memory 0 Register Select generation
HSELREGuM0       <= '1' when (HADDR(20 downto 16) = "00001"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Memory 1 Register Select generation
HSELREGuM1       <= '1' when (HADDR(20 downto 16) = "00010"
                                                    and HSELDMACTr = '1')
                 else
                    '0';


-- Peripheral 0 Register Select generation
HSELREGuP0       <= '1' when (HADDR(20 downto 16) = "00011"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 1 Register Select generation
HSELREGuP1       <= '1' when (HADDR(20 downto 16) = "00100"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 2 Register Select generation
HSELREGuP2       <= '1' when (HADDR(20 downto 16) = "00101"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 3 Register Select generation
HSELREGuP3       <= '1' when (HADDR(20 downto 16) = "00110"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 4 Register Select generation
HSELREGuP4       <= '1' when (HADDR(20 downto 16) = "00111"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 5 Register Select generation
HSELREGuP5       <= '1' when (HADDR(20 downto 16) = "01000"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 6 Register Select generation
HSELREGuP6       <= '1' when (HADDR(20 downto 16) = "01001"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 7 Register Select generation
HSELREGuP7       <= '1' when (HADDR(20 downto 16) = "01010"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 8 Register Select generation
HSELREGuP8       <= '1' when (HADDR(20 downto 16) = "01011"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 9 Register Select generation
HSELREGuP9       <= '1' when (HADDR(20 downto 16) = "01100"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 10 Register Select generation
HSELREGuP10      <= '1' when (HADDR(20 downto 16) = "01101"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 11 Register Select generation
HSELREGuP11      <= '1' when (HADDR(20 downto 16) = "01110"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 12 Register Select generation
HSELREGuP12      <= '1' when (HADDR(20 downto 16) = "01111"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 13 Register Select generation
HSELREGuP13      <= '1' when (HADDR(20 downto 16) = "10000"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 14 Register Select generation
HSELREGuP14      <= '1' when (HADDR(20 downto 16) = "10001"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Peripheral 15 Register Select generation
HSELREGuP15      <= '1' when (HADDR(20 downto 16) = "10010"
                                                    and HSELDMACTr = '1')
                 else
                    '0';

-- Memory 0 Select signal generation
HSELMEMuM0       <= '1' when (((ReqConfig(0) = '0') and
                               (HADDRM1 >= M0LOWADDRRANGE and
                                HADDRM1 <= M0HIGHADDRRANGE)) or
                              ((ReqConfig(0) = '1') and
                               (HADDRM2 >= M0LOWADDRRANGE and
                               HADDRM2  <= M0HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Memory 1 Select signal generation
HSELMEMuM1       <= '1' when (((ReqConfig(1) = '0') and
                               (HADDRM1 >= M1LOWADDRRANGE and
                                HADDRM1 <= M1HIGHADDRRANGE)) or
                              ((ReqConfig(1) = '1') and
                               (HADDRM2 >= M1LOWADDRRANGE and
                               HADDRM2  <= M1HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 0 Select signal generation
HSELPERIPHuP0    <= '1' when (((ReqConfig(2) = '0') and
                               (HADDRM1 >= P0LOWADDRRANGE and
                                HADDRM1 <= P0HIGHADDRRANGE)) or
                              ((ReqConfig(2) = '1') and
                               (HADDRM2 >= P0LOWADDRRANGE and
                                HADDRM2 <= P0HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 1 Select signal generation
HSELPERIPHuP1    <= '1' when (((ReqConfig(3) = '0') and
                               (HADDRM1 >= P1LOWADDRRANGE and
                                HADDRM1 <= P1HIGHADDRRANGE)) or
                              ((ReqConfig(3) = '1') and
                               (HADDRM2 >= P1LOWADDRRANGE and
                                HADDRM2 <= P1HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 2 Select signal generation
HSELPERIPHuP2    <= '1' when (((ReqConfig(4) = '0') and
                               (HADDRM1 >= P2LOWADDRRANGE and
                                HADDRM1 <= P2HIGHADDRRANGE)) or
                              ((ReqConfig(4) = '1') and
                               (HADDRM2 >= P2LOWADDRRANGE and
                                HADDRM2 <= P2HIGHADDRRANGE))
                             )
                 else

                    '0';

-- Peripheral 3 Select signal generation
HSELPERIPHuP3    <= '1' when (((ReqConfig(5) = '0') and
                               (HADDRM1 >= P3LOWADDRRANGE and
                                HADDRM1 <= P3HIGHADDRRANGE)) or
                              ((ReqConfig(5) = '1') and
                               (HADDRM2 >= P3LOWADDRRANGE and
                                HADDRM2 <= P3HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 4 Select signal generation
HSELPERIPHuP4    <= '1' when (((ReqConfig(6) = '0') and
                               (HADDRM1 >= P4LOWADDRRANGE and
                                HADDRM1 <= P4HIGHADDRRANGE)) or
                              ((ReqConfig(6) = '1') and
                               (HADDRM2 >= P4LOWADDRRANGE and
                                HADDRM2 <= P4HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 5 Select signal generation
HSELPERIPHuP5    <= '1' when (((ReqConfig(7) = '0') and
                               (HADDRM1 >= P5LOWADDRRANGE and
                                HADDRM1 <= P5HIGHADDRRANGE)) or
                              ((ReqConfig(7) = '1') and
                               (HADDRM2 >= P5LOWADDRRANGE and
                                HADDRM2 <= P5HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 6 Select signal generation
HSELPERIPHuP6    <= '1' when (((ReqConfig(8) = '0') and
                               (HADDRM1 >= P6LOWADDRRANGE and
                                HADDRM1 <= P6HIGHADDRRANGE)) or
                              ((ReqConfig(8) = '1') and
                               (HADDRM2 >= P6LOWADDRRANGE and
                                HADDRM2 <= P6HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 7 Select signal generation
HSELPERIPHuP7    <= '1' when (((ReqConfig(9) = '0') and
                               (HADDRM1 >= P7LOWADDRRANGE and
                                HADDRM1 <= P7HIGHADDRRANGE)) or
                              ((ReqConfig(9) = '1') and
                               (HADDRM2 >= P7LOWADDRRANGE and
                                HADDRM2 <= P7HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 8 Select signal generation
HSELPERIPHuP8    <= '1' when (((ReqConfig(10) = '0') and
                               (HADDRM1 >= P8LOWADDRRANGE and
                                HADDRM1 <= P8HIGHADDRRANGE)) or
                              ((ReqConfig(10) = '1') and
                               (HADDRM2 >= P8LOWADDRRANGE and
                                HADDRM2 <= P8HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 9 Select signal generation
HSELPERIPHuP9    <= '1' when (((ReqConfig(11) = '0') and
                               (HADDRM1 >= P9LOWADDRRANGE and
                                HADDRM1 <= P9HIGHADDRRANGE)) or
                              ((ReqConfig(11) = '1') and
                               (HADDRM2 >= P9LOWADDRRANGE and
                                HADDRM2 <= P9HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 10 Select signal generation
HSELPERIPHuP10   <= '1' when (((ReqConfig(12) = '0') and
                               (HADDRM1 >= P10LOWADDRRANGE and
                                HADDRM1 <= P10HIGHADDRRANGE)) or
                              ((ReqConfig(12) = '1') and
                               (HADDRM2 >= P10LOWADDRRANGE and
                                HADDRM2 <= P10HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 11 Select signal generation
HSELPERIPHuP11   <= '1' when (((ReqConfig(13) = '0') and
                               (HADDRM1 >= P11LOWADDRRANGE and
                                HADDRM1 <= P11HIGHADDRRANGE)) or
                              ((ReqConfig(13) = '1') and
                               (HADDRM2 >= P11LOWADDRRANGE and
                                HADDRM2 <= P11HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 12 Select signal generation
HSELPERIPHuP12   <= '1' when (((ReqConfig(14) = '0') and
                               (HADDRM1 >= P12LOWADDRRANGE and
                                HADDRM1 <= P12HIGHADDRRANGE)) or
                              ((ReqConfig(14) = '1') and
                               (HADDRM2 >= P12LOWADDRRANGE and
                                HADDRM2 <= P12HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 13 Select signal generation
HSELPERIPHuP13   <= '1' when (((ReqConfig(15) = '0') and
                               (HADDRM1 >= P13LOWADDRRANGE and
                                HADDRM1 <= P13HIGHADDRRANGE)) or
                              ((ReqConfig(15) = '1') and
                               (HADDRM2 >= P13LOWADDRRANGE and
                                HADDRM2 <= P13HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 14 Select signal generation
HSELPERIPHuP14   <= '1' when (((ReqConfig(16) = '0') and
                               (HADDRM1 >= P14LOWADDRRANGE and
                                HADDRM1 <= P14HIGHADDRRANGE)) or
                              ((ReqConfig(16) = '1') and
                               (HADDRM2 >= P14LOWADDRRANGE and
                                HADDRM2 <= P14HIGHADDRRANGE))
                             )
                 else
                    '0';

-- Peripheral 15 Select signal generation
HSELPERIPHuP15   <= '1' when (((ReqConfig(17) = '0') and
                               (HADDRM1 >= P15LOWADDRRANGE and
                                HADDRM1 <= P15HIGHADDRRANGE)) or
                              ((ReqConfig(17) = '1') and
                               (HADDRM2 >= P15LOWADDRRANGE and
                                HADDRM2 <= P15HIGHADDRRANGE))
                             )
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrBehaviour
-- -----------------------------------------------------------------------------
uDmacTrBehaviour : DmacTrBehaviour
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELDMAC         => HSELDMAC,
            HSELDMACTrSlave  => HSELDMACTrSlave,
            HWRITE           => HWRITE,
            HTRANS           => HTRANS,
            HADDR            => HADDR(20 downto 2),
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HGRANTDMACM1     => HGRANTDMACM1,
            HGRANTDMACM2     => ZEROFILL(0),
            HREADYINM1       => HREADYINM1,
            HREADYINM2       => ZEROFILL(0),
            HRESPM1          => HRESPM1Beh,
            HRESPM2          => ZEROFILL(1 downto 0),
            HRDATAM1         => HRDATAM1Beh,
            HRDATAM2         => ZEROFILL,
            DMACBREQ         => iDMACBREQ,
            DMACLBREQ        => iDMACLBREQ,
            DMACSREQ         => iDMACSREQ,
            DMACLSREQ        => iDMACLSREQ,
            HREADYOUT        => HREADYOUTTrIn,
            HRESP            => HRESPTrIn,
            HBUSREQDMACM1    => HBUSREQM1Tr,
            HBUSREQDMACM2    => HBUSREQM2Tr,
            HLOCKDMACM1      => HLOCKM1Tr,
            HLOCKDMACM2      => HLOCKM2Tr,
            HTRANSM1         => HTRANSM1Tr,
            HTRANSM2         => HTRANSM2Tr,
            HADDRM1          => HADDRM1Tr,
            HADDRM2          => HADDRM2Tr,
            HSIZEM1          => HSIZEM1Tr,
            HSIZEM2          => HSIZEM2Tr,
            HBURSTM1         => HBURSTM1Tr,
            HBURSTM2         => HBURSTM2Tr,
            HPROTM1          => HPROTM1Tr,
            HPROTM2          => HPROTM2Tr,
            HWRITEM1         => HWRITEM1Tr,
            HWRITEM2         => HWRITEM2Tr,
            HWDATAM1         => HWDATAM1Tr,
            HWDATAM2         => HWDATAM2Tr,
            DMACCLR          => DMACCLRTr,
            DMACTC           => DMACTCTr,
            DMACINTERR       => DMACINTERRTr,
            DMACINTTC        => DMACINTTCTr,
            DMACINTR         => DMACINTRTr,
            DmacTrEn         => DmacTrEn,
            ReqConfig        => ReqConfig,
            GrantCount0      => GrantCount0,
            GrantCount1      => GrantCount1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrProChkr
-- -----------------------------------------------------------------------------
uDmacTrProChkr : DmacTrProChkr
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HBUSREQDMACM     => HBUSREQDMACM1,
            HLOCKDMACM       => HLOCKDMACM1,
            HTRANSM          => HTRANSM1,
            HADDRM           => HADDRM1,
            HSIZEM           => HSIZEM1,
            HBURSTM          => HBURSTM1,
            HPROTM           => HPROTM1,
            HWRITEM          => HWRITEM1,
            HWDATAM          => HWDATAM1,
            DMACCLR          => DMACCLR,
            DMACTC           => DMACTC,
            DMACINTERR       => DMACINTERR,
            DMACINTTC        => DMACINTTC,
            DMACINTR         => DMACINTR,
            HBUSREQMTr       => HBUSREQM1Tr,
            HLOCKMTr         => HLOCKM1Tr,
            HTRANSMTr        => HTRANSM1Tr,
            HADDRMTr         => HADDRM1Tr,
            HSIZEMTr         => HSIZEM1Tr,
            HBURSTMTr        => HBURSTM1Tr,
            HPROTMTr         => HPROTM1Tr,
            HWRITEMTr        => HWRITEM1Tr,
            HWDATAMTr        => HWDATAM1Tr,
            DMACCLRTr        => DMACCLRTr,
            DMACTCTr         => DMACTCTr,
            DMACINTERRTr     => DMACINTERRTr,
            DMACINTTCTr      => DMACINTTCTr,
            DMACINTRTr       => DMACINTRTr,
            HREADYINM        => HREADYINM1,
            HGRANTDMACM      => HGRANTDMACM1,
            DmacTrEn         => DmacTrEn
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrGntGen 0
-- -----------------------------------------------------------------------------
u0DmacTrGntGen : DmacTrGntGen
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HBUSREQDMAC      => HBUSREQDMACM1,
            HREADYINM        => HREADYINM1,
            HBURSTM          => HBURSTM1,
            GrantCount       => GrantCount0,
            HGRANTDMACM      => HGRANTDMACM1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrMem 0
-- -----------------------------------------------------------------------------
uM0DmacTrMem : DmacTrMem
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuM0,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuM0,
            HRESP            => HRESPuM0,
            HRDATA           => HRDATAuM0,
            HADDRM           => HADDRMuM0,
            HSELMEM          => HSELMEMuM0,
            HWRITEM          => HWRITEMuM0,
            HTRANSM          => HTRANSMuM0,
            HBURSTM          => HBURSTMuM0,
            HSIZEM           => HSIZEMuM0,
            HWDATAM          => HWDATAMuM0,
            HREADYINM        => HREADYINMuM0,
            HREADYOUTM       => HREADYOUTMuM0,
            HRESPM           => HRESPMuM0,
            HRDATAM          => HRDATAMuM0
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrMem 1
-- -----------------------------------------------------------------------------
uM1DmacTrMem : DmacTrMem
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuM1,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuM1,
            HRESP            => HRESPuM1,
            HRDATA           => HRDATAuM1,
            HADDRM           => HADDRMuM1,
            HSELMEM          => HSELMEMuM1,
            HWRITEM          => HWRITEMuM1,
            HTRANSM          => HTRANSMuM1,
            HBURSTM          => HBURSTMuM1,
            HSIZEM           => HSIZEMuM1,
            HWDATAM          => HWDATAMuM1,
            HREADYINM        => HREADYINMuM1,
            HREADYOUTM       => HREADYOUTMuM1,
            HRESPM           => HRESPMuM1,
            HRDATAM          => HRDATAMuM1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 0
-- -----------------------------------------------------------------------------
uP0DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP0,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP0,
            HRESP            => HRESPuP0,
            HRDATA           => HRDATAuP0,
            HADDRM           => HADDRMuP0,
            HSELPERIPH       => HSELPERIPHuP0,
            HWRITEM          => HWRITEMuP0,
            HTRANSM          => HTRANSMuP0,
            HBURSTM          => HBURSTMuP0,
            HSIZEM           => HSIZEMuP0,
            HWDATAM          => HWDATAMuP0,
            DMACTC           => DMACTC(0),
            DMACCLR          => DMACCLR(0),
            HREADYINM        => HREADYINMuP0,
            HREADYOUTM       => HREADYOUTMuP0,
            HRESPM           => HRESPMuP0,
            HRDATAM          => HRDATAMuP0,
            DMACSREQ         => iDMACSREQ(0),
            DMACBREQ         => iDMACBREQ(0),
            DMACLSREQ        => iDMACLSREQ(0),
            DMACLBREQ        => iDMACLBREQ(0)
           );
 
-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 1
-- -----------------------------------------------------------------------------
uP1DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP1,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP1,
            HRESP            => HRESPuP1,
            HRDATA           => HRDATAuP1,
            HADDRM           => HADDRMuP1,
            HSELPERIPH       => HSELPERIPHuP1,
            HWRITEM          => HWRITEMuP1,
            HTRANSM          => HTRANSMuP1,
            HBURSTM          => HBURSTMuP1,
            HSIZEM           => HSIZEMuP1,
            HWDATAM          => HWDATAMuP1,
            DMACTC           => DMACTC(1),
            DMACCLR          => DMACCLR(1),
            HREADYINM        => HREADYINMuP1,
            HREADYOUTM       => HREADYOUTMuP1,
            HRESPM           => HRESPMuP1,
            HRDATAM          => HRDATAMuP1,
            DMACSREQ         => iDMACSREQ(1),
            DMACBREQ         => iDMACBREQ(1),
            DMACLSREQ        => iDMACLSREQ(1),
            DMACLBREQ        => iDMACLBREQ(1)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 2
-- -----------------------------------------------------------------------------
uP2DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP2,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP2,
            HRESP            => HRESPuP2,
            HRDATA           => HRDATAuP2,
            HADDRM           => HADDRMuP2,
            HSELPERIPH       => HSELPERIPHuP2,
            HWRITEM          => HWRITEMuP2,
            HTRANSM          => HTRANSMuP2,
            HBURSTM          => HBURSTMuP2,
            HSIZEM           => HSIZEMuP2,
            HWDATAM          => HWDATAMuP2,
            DMACTC           => DMACTC(2),
            DMACCLR          => DMACCLR(2),
            HREADYINM        => HREADYINMuP2,
            HREADYOUTM       => HREADYOUTMuP2,
            HRESPM           => HRESPMuP2,
            HRDATAM          => HRDATAMuP2,
            DMACSREQ         => iDMACSREQ(2),
            DMACBREQ         => iDMACBREQ(2),
            DMACLSREQ        => iDMACLSREQ(2),
            DMACLBREQ        => iDMACLBREQ(2)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 3
-- -----------------------------------------------------------------------------
uP3DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP3,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP3,
            HRESP            => HRESPuP3,
            HRDATA           => HRDATAuP3,
            HADDRM           => HADDRMuP3,
            HSELPERIPH       => HSELPERIPHuP3,
            HWRITEM          => HWRITEMuP3,
            HTRANSM          => HTRANSMuP3,
            HBURSTM          => HBURSTMuP3,
            HSIZEM           => HSIZEMuP3,
            HWDATAM          => HWDATAMuP3,
            DMACTC           => DMACTC(3),
            DMACCLR          => DMACCLR(3),
            HREADYINM        => HREADYINMuP3,
            HREADYOUTM       => HREADYOUTMuP3,
            HRESPM           => HRESPMuP3,
            HRDATAM          => HRDATAMuP3,
            DMACSREQ         => iDMACSREQ(3),
            DMACBREQ         => iDMACBREQ(3),
            DMACLSREQ        => iDMACLSREQ(3),
            DMACLBREQ        => iDMACLBREQ(3)
           );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 4
-- -----------------------------------------------------------------------------
uP4DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP4,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP4,
            HRESP            => HRESPuP4,
            HRDATA           => HRDATAuP4,
            HADDRM           => HADDRMuP4,
            HSELPERIPH       => HSELPERIPHuP4,
            HWRITEM          => HWRITEMuP4,
            HTRANSM          => HTRANSMuP4,
            HBURSTM          => HBURSTMuP4,
            HSIZEM           => HSIZEMuP4,
            HWDATAM          => HWDATAMuP4,
            DMACTC           => DMACTC(4),
            DMACCLR          => DMACCLR(4),
            HREADYINM        => HREADYINMuP4,
            HREADYOUTM       => HREADYOUTMuP4,
            HRESPM           => HRESPMuP4,
            HRDATAM          => HRDATAMuP4,
            DMACSREQ         => iDMACSREQ(4),
            DMACBREQ         => iDMACBREQ(4),
            DMACLSREQ        => iDMACLSREQ(4),
            DMACLBREQ        => iDMACLBREQ(4)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 5
-- -----------------------------------------------------------------------------
uP5DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP5,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP5,
            HRESP            => HRESPuP5,
            HRDATA           => HRDATAuP5,
            HADDRM           => HADDRMuP5,
            HSELPERIPH       => HSELPERIPHuP5,
            HWRITEM          => HWRITEMuP5,
            HTRANSM          => HTRANSMuP5,
            HBURSTM          => HBURSTMuP5,
            HSIZEM           => HSIZEMuP5,
            HWDATAM          => HWDATAMuP5,
            DMACTC           => DMACTC(5),
            DMACCLR          => DMACCLR(5),
            HREADYINM        => HREADYINMuP5,
            HREADYOUTM       => HREADYOUTMuP5,
            HRESPM           => HRESPMuP5,
            HRDATAM          => HRDATAMuP5,
            DMACSREQ         => iDMACSREQ(5),
            DMACBREQ         => iDMACBREQ(5),
            DMACLSREQ        => iDMACLSREQ(5),
            DMACLBREQ        => iDMACLBREQ(5)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 6
-- -----------------------------------------------------------------------------
uP6DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP6,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP6,
            HRESP            => HRESPuP6,
            HRDATA           => HRDATAuP6,
            HADDRM           => HADDRMuP6,
            HSELPERIPH       => HSELPERIPHuP6,
            HWRITEM          => HWRITEMuP6,
            HTRANSM          => HTRANSMuP6,
            HBURSTM          => HBURSTMuP6,
            HSIZEM           => HSIZEMuP6,
            HWDATAM          => HWDATAMuP6,
            DMACTC           => DMACTC(6),
            DMACCLR          => DMACCLR(6),
            HREADYINM        => HREADYINMuP6,
            HREADYOUTM       => HREADYOUTMuP6,
            HRESPM           => HRESPMuP6,
            HRDATAM          => HRDATAMuP6,
            DMACSREQ         => iDMACSREQ(6),
            DMACBREQ         => iDMACBREQ(6),
            DMACLSREQ        => iDMACLSREQ(6),
            DMACLBREQ        => iDMACLBREQ(6)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 7
-- -----------------------------------------------------------------------------
uP7DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP7,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP7,
            HRESP            => HRESPuP7,
            HRDATA           => HRDATAuP7,
            HADDRM           => HADDRMuP7,
            HSELPERIPH       => HSELPERIPHuP7,
            HWRITEM          => HWRITEMuP7,
            HTRANSM          => HTRANSMuP7,
            HBURSTM          => HBURSTMuP7,
            HSIZEM           => HSIZEMuP7,
            HWDATAM          => HWDATAMuP7,
            DMACTC           => DMACTC(7),
            DMACCLR          => DMACCLR(7),
            HREADYINM        => HREADYINMuP7,
            HREADYOUTM       => HREADYOUTMuP7,
            HRESPM           => HRESPMuP7,
            HRDATAM          => HRDATAMuP7,
            DMACSREQ         => iDMACSREQ(7),
            DMACBREQ         => iDMACBREQ(7),
            DMACLSREQ        => iDMACLSREQ(7),
            DMACLBREQ        => iDMACLBREQ(7)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 8
-- -----------------------------------------------------------------------------
uP8DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP8,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP8,
            HRESP            => HRESPuP8,
            HRDATA           => HRDATAuP8,
            HADDRM           => HADDRMuP8,
            HSELPERIPH       => HSELPERIPHuP8,
            HWRITEM          => HWRITEMuP8,
            HTRANSM          => HTRANSMuP8,
            HBURSTM          => HBURSTMuP8,
            HSIZEM           => HSIZEMuP8,
            HWDATAM          => HWDATAMuP8,
            DMACTC           => DMACTC(8),
            DMACCLR          => DMACCLR(8),
            HREADYINM        => HREADYINMuP8,
            HREADYOUTM       => HREADYOUTMuP8,
            HRESPM           => HRESPMuP8,
            HRDATAM          => HRDATAMuP8,
            DMACSREQ         => iDMACSREQ(8),
            DMACBREQ         => iDMACBREQ(8),
            DMACLSREQ        => iDMACLSREQ(8),
            DMACLBREQ        => iDMACLBREQ(8)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 9
-- -----------------------------------------------------------------------------
uP9DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGup9,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTup9,
            HRESP            => HRESPup9,
            HRDATA           => HRDATAup9,
            HADDRM           => HADDRMup9,
            HSELPERIPH       => HSELPERIPHup9,
            HWRITEM          => HWRITEMup9,
            HTRANSM          => HTRANSMup9,
            HBURSTM          => HBURSTMup9,
            HSIZEM           => HSIZEMup9,
            HWDATAM          => HWDATAMup9,
            DMACTC           => DMACTC(9),
            DMACCLR          => DMACCLR(9),
            HREADYINM        => HREADYINMup9,
            HREADYOUTM       => HREADYOUTMup9,
            HRESPM           => HRESPMup9,
            HRDATAM          => HRDATAMup9,
            DMACSREQ         => iDMACSREQ(9),
            DMACBREQ         => iDMACBREQ(9),
            DMACLSREQ        => iDMACLSREQ(9),
            DMACLBREQ        => iDMACLBREQ(9)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 10
-- -----------------------------------------------------------------------------
uP10DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP10,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP10,
            HRESP            => HRESPuP10,
            HRDATA           => HRDATAuP10,
            HADDRM           => HADDRMuP10,
            HSELPERIPH       => HSELPERIPHuP10,
            HWRITEM          => HWRITEMuP10,
            HTRANSM          => HTRANSMuP10,
            HBURSTM          => HBURSTMuP10,
            HSIZEM           => HSIZEMuP10,
            HWDATAM          => HWDATAMuP10,
            DMACTC           => DMACTC(10),
            DMACCLR          => DMACCLR(10),
            HREADYINM        => HREADYINMuP10,
            HREADYOUTM       => HREADYOUTMuP10,
            HRESPM           => HRESPMuP10,
            HRDATAM          => HRDATAMuP10,
            DMACSREQ         => iDMACSREQ(10),
            DMACBREQ         => iDMACBREQ(10),
            DMACLSREQ        => iDMACLSREQ(10),
            DMACLBREQ        => iDMACLBREQ(10)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 11
-- -----------------------------------------------------------------------------
uP11DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP11,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP11,
            HRESP            => HRESPuP11,
            HRDATA           => HRDATAuP11,
            HADDRM           => HADDRMuP11,
            HSELPERIPH       => HSELPERIPHuP11,
            HWRITEM          => HWRITEMuP11,
            HTRANSM          => HTRANSMuP11,
            HBURSTM          => HBURSTMuP11,
            HSIZEM           => HSIZEMuP11,
            HWDATAM          => HWDATAMuP11,
            DMACTC           => DMACTC(11),
            DMACCLR          => DMACCLR(11),
            HREADYINM        => HREADYINMuP11,
            HREADYOUTM       => HREADYOUTMuP11,
            HRESPM           => HRESPMuP11,
            HRDATAM          => HRDATAMuP11,
            DMACSREQ         => iDMACSREQ(11),
            DMACBREQ         => iDMACBREQ(11),
            DMACLSREQ        => iDMACLSREQ(11),
            DMACLBREQ        => iDMACLBREQ(11)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 12
-- -----------------------------------------------------------------------------
uP12DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP12,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP12,
            HRESP            => HRESPuP12,
            HRDATA           => HRDATAuP12,
            HADDRM           => HADDRMuP12,
            HSELPERIPH       => HSELPERIPHuP12,
            HWRITEM          => HWRITEMuP12,
            HTRANSM          => HTRANSMuP12,
            HBURSTM          => HBURSTMuP12,
            HSIZEM           => HSIZEMuP12,
            HWDATAM          => HWDATAMuP12,
            DMACTC           => DMACTC(12),
            DMACCLR          => DMACCLR(12),
            HREADYINM        => HREADYINMuP12,
            HREADYOUTM       => HREADYOUTMuP12,
            HRESPM           => HRESPMuP12,
            HRDATAM          => HRDATAMuP12,
            DMACSREQ         => iDMACSREQ(12),
            DMACBREQ         => iDMACBREQ(12),
            DMACLSREQ        => iDMACLSREQ(12),
            DMACLBREQ        => iDMACLBREQ(12)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 13
-- -----------------------------------------------------------------------------
uP13DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP13,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP13,
            HRESP            => HRESPuP13,
            HRDATA           => HRDATAuP13,
            HADDRM           => HADDRMuP13,
            HSELPERIPH       => HSELPERIPHuP13,
            HWRITEM          => HWRITEMuP13,
            HTRANSM          => HTRANSMuP13,
            HBURSTM          => HBURSTMuP13,
            HSIZEM           => HSIZEMuP13,
            HWDATAM          => HWDATAMuP13,
            DMACTC           => DMACTC(13),
            DMACCLR          => DMACCLR(13),
            HREADYINM        => HREADYINMuP13,
            HREADYOUTM       => HREADYOUTMuP13,
            HRESPM           => HRESPMuP13,
            HRDATAM          => HRDATAMuP13,
            DMACSREQ         => iDMACSREQ(13),
            DMACBREQ         => iDMACBREQ(13),
            DMACLSREQ        => iDMACLSREQ(13),
            DMACLBREQ        => iDMACLBREQ(13)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 14
-- -----------------------------------------------------------------------------
uP14DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP14,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP14,
            HRESP            => HRESPuP14,
            HRDATA           => HRDATAuP14,
            HADDRM           => HADDRMuP14,
            HSELPERIPH       => HSELPERIPHuP14,
            HWRITEM          => HWRITEMuP14,
            HTRANSM          => HTRANSMuP14,
            HBURSTM          => HBURSTMuP14,
            HSIZEM           => HSIZEMuP14,
            HWDATAM          => HWDATAMuP14,
            DMACTC           => DMACTC(14),
            DMACCLR          => DMACCLR(14),
            HREADYINM        => HREADYINMuP14,
            HREADYOUTM       => HREADYOUTMuP14,
            HRESPM           => HRESPMuP14,
            HRDATAM          => HRDATAMuP14,
            DMACSREQ         => iDMACSREQ(14),
            DMACBREQ         => iDMACBREQ(14),
            DMACLSREQ        => iDMACLSREQ(14),
            DMACLBREQ        => iDMACLBREQ(14)
         );

-- -----------------------------------------------------------------------------
-- Instantiation of DmacTrPeriph 15
-- -----------------------------------------------------------------------------
uP15DmacTrPeriph : DmacTrPeriph
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDR            => HADDR(SLAVEADDRHB downto SLAVEADDRLB),
            HSELREG          => HSELREGuP15,
            HWRITE           => HWRITE,
            HTRANS           => HTRANSIn,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HREADYIN         => HREADYIN,
            HREADYOUT        => HREADYOUTuP15,
            HRESP            => HRESPuP15,
            HRDATA           => HRDATAuP15,
            HADDRM           => HADDRMuP15,
            HSELPERIPH       => HSELPERIPHuP15,
            HWRITEM          => HWRITEMuP15,
            HTRANSM          => HTRANSMuP15,
            HBURSTM          => HBURSTMuP15,
            HSIZEM           => HSIZEMuP15,
            HWDATAM          => HWDATAMuP15,
            DMACTC           => DMACTC(15),
            DMACCLR          => DMACCLR(15),
            HREADYINM        => HREADYINMuP15,
            HREADYOUTM       => HREADYOUTMuP15,
            HRESPM           => HRESPMuP15,
            HRDATAM          => HRDATAMuP15,
            DMACSREQ         => iDMACSREQ(15),
            DMACBREQ         => iDMACBREQ(15),
            DMACLSREQ        => iDMACLSREQ(15),
            DMACLBREQ        => iDMACLBREQ(15)
         );

-- -----------------------------------------------------------------------------
-- Control Information Latching Block
-- -----------------------------------------------------------------------------
p_ControlInfoComb : process (ReqConfig, HSELMEMuM0, HSELMEMuM1,HSELPERIPHuP0,
                             HSELPERIPHuP1, HSELPERIPHuP2, HSELPERIPHuP3,
                             HSELPERIPHuP4, HSELPERIPHuP5, HSELPERIPHuP6,
                             HSELPERIPHuP7, HSELPERIPHuP8, HSELPERIPHuP9,
                             HSELPERIPHuP10, HSELPERIPHuP11, HSELPERIPHuP12,
                             HSELPERIPHuP13, HSELPERIPHuP14, HSELPERIPHuP15,
                             HADDRM1, HADDRM2, HWRITEM1, HWRITEM2, HSIZEM1,
                             HSIZEM2, HBURSTM1, HBURSTM2, HTRANSM1, HTRANSM2,
                             HREADYINM1, HREADYINM2,SyncMem0, SyncMem1,
                             SyncPeriph0, SyncPeriph1, SyncPeriph2, SyncPeriph3,
                             SyncPeriph4, SyncPeriph5, SyncPeriph6, SyncPeriph7,
                             SyncPeriph8, SyncPeriph9, SyncPeriph10,
                             SyncPeriph11, SyncPeriph12, SyncPeriph13,
                             SyncPeriph14, SyncPeriph15)
begin
    NxtSyncMem0              <= SyncMem0;
    NxtSyncMem1              <= SyncMem1;
    NxtSyncPeriph0           <= SyncPeriph0;
    NxtSyncPeriph1           <= SyncPeriph1;
    NxtSyncPeriph2           <= SyncPeriph2;
    NxtSyncPeriph3           <= SyncPeriph3;
    NxtSyncPeriph4           <= SyncPeriph4;
    NxtSyncPeriph5           <= SyncPeriph5;
    NxtSyncPeriph6           <= SyncPeriph6;
    NxtSyncPeriph7           <= SyncPeriph7;
    NxtSyncPeriph8           <= SyncPeriph8;
    NxtSyncPeriph9           <= SyncPeriph9;
    NxtSyncPeriph10          <= SyncPeriph10;
    NxtSyncPeriph11          <= SyncPeriph11;
    NxtSyncPeriph12          <= SyncPeriph12;
    NxtSyncPeriph13          <= SyncPeriph13;
    NxtSyncPeriph14          <= SyncPeriph14;
    NxtSyncPeriph15          <= SyncPeriph15;

  if (HSELMEMuM0 = '1') then
    if (ReqConfig(0) = '1') then
      HADDRMuM0        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuM0       <= HWRITEM2;
      HTRANSMuM0       <= HTRANSM2;
      HSIZEMuM0        <= HSIZEM2;
      HBURSTMuM0       <= HBURSTM2;
      HREADYINMuM0     <= HREADYINM2;
    else
      HADDRMuM0        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuM0       <= HWRITEM1;
      HTRANSMuM0       <= HTRANSM1;
      HSIZEMuM0        <= HSIZEM1;
      HBURSTMuM0       <= HBURSTM1;
      HREADYINMuM0     <= HREADYINM1;
    end if;
  else
    HADDRMuM0        <= (others =>'0');
    HWRITEMuM0       <= '0';
    HTRANSMuM0       <= (others =>'0');
    HSIZEMuM0        <= (others =>'0');
    HBURSTMuM0       <= (others =>'0');
    HREADYINMuM0     <= '0';
  end if;

  if (ReqConfig(0) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELMEMuM0 = '1') then
        NxtSyncMem0      <= '1';
      else
        NxtSyncMem0      <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELMEMuM0 = '1') then
        NxtSyncMem0      <= '1';
      else
        NxtSyncMem0      <= '0';
      end if;
    end if;
  end if;

  if (HSELMEMuM1 = '1') then
    if (ReqConfig(1) = '1') then
      HADDRMuM1        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuM1       <= HWRITEM2;
      HTRANSMuM1       <= HTRANSM2;
      HSIZEMuM1        <= HSIZEM2;
      HBURSTMuM1       <= HBURSTM2;
      HREADYINMuM1     <= HREADYINM2;

    else
      HADDRMuM1        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuM1       <= HWRITEM1;
      HTRANSMuM1       <= HTRANSM1;
      HSIZEMuM1        <= HSIZEM1;
      HBURSTMuM1       <= HBURSTM1;
      HREADYINMuM1     <= HREADYINM1;
    end if;
  else
    HADDRMuM1        <= (others =>'0');
    HWRITEMuM1       <= '0';
    HTRANSMuM1       <= (others =>'0');
    HSIZEMuM1        <= (others =>'0');
    HBURSTMuM1       <= (others =>'0');
    HREADYINMuM1     <= '0';
  end if;

  if (ReqConfig(1) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELMEMuM1 = '1') then
        NxtSyncMem1      <= '1';
      else
        NxtSyncMem1      <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELMEMuM1 = '1') then
        NxtSyncMem1      <= '1';
      else
        NxtSyncMem1      <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP0 = '1') then
    if (ReqConfig(2) = '1') then
      HADDRMuP0        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP0       <= HWRITEM2;
      HTRANSMuP0       <= HTRANSM2;
      HSIZEMuP0        <= HSIZEM2;
      HBURSTMuP0       <= HBURSTM2;
      HREADYINMuP0     <= HREADYINM2;
    else
      HADDRMuP0        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP0       <= HWRITEM1;
      HTRANSMuP0       <= HTRANSM1;
      HSIZEMuP0        <= HSIZEM1;
      HBURSTMuP0       <= HBURSTM1;
      HREADYINMuP0     <= HREADYINM1;
    end if;
  else
    HADDRMuP0        <= (others =>'0');
    HWRITEMuP0       <= '0';
    HTRANSMuP0       <= (others =>'0');
    HSIZEMuP0        <= (others =>'0');
    HBURSTMuP0       <= (others =>'0');
    HREADYINMuP0     <= '0';
  end if;

  if (ReqConfig(2) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP0 = '1') then
        NxtSyncPeriph0   <= '1';
      else
        NxtSyncPeriph0   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP0 = '1') then
        NxtSyncPeriph0   <= '1';
      else
        NxtSyncPeriph0   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP1 = '1') then
    if (ReqConfig(3) = '1') then
      HADDRMuP1        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP1       <= HWRITEM2;
      HTRANSMuP1       <= HTRANSM2;
      HSIZEMuP1        <= HSIZEM2;
      HBURSTMuP1       <= HBURSTM2;
      HREADYINMuP1     <= HREADYINM2;
    else
      HADDRMuP1        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP1       <= HWRITEM1;
      HTRANSMuP1       <= HTRANSM1;
      HSIZEMuP1        <= HSIZEM1;
      HBURSTMuP1       <= HBURSTM1;
      HREADYINMuP1     <= HREADYINM1;
    end if;
  else
    HADDRMuP1        <= (others =>'0');
    HWRITEMuP1       <= '0';
    HTRANSMuP1       <= (others =>'0');
    HSIZEMuP1        <= (others =>'0');
    HBURSTMuP1       <= (others =>'0');
    HREADYINMuP1     <= '0';
  end if;

  if (ReqConfig(3) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP1 = '1') then
        NxtSyncPeriph1   <= '1';
      else
        NxtSyncPeriph1   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP1 = '1') then
        NxtSyncPeriph1   <= '1';
      else
        NxtSyncPeriph1   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP2 = '1') then
    if (ReqConfig(4) = '1') then
      HADDRMuP2        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP2       <= HWRITEM2;
      HTRANSMuP2       <= HTRANSM2;
      HSIZEMuP2        <= HSIZEM2;
      HBURSTMuP2       <= HBURSTM2;
      HREADYINMuP2     <= HREADYINM2;
    else
      HADDRMuP2        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP2       <= HWRITEM1;
      HTRANSMuP2       <= HTRANSM1;
      HSIZEMuP2        <= HSIZEM1;
      HBURSTMuP2       <= HBURSTM1;
      HREADYINMuP2     <= HREADYINM1;
    end if;
  else
    HADDRMuP2        <= (others =>'0');
    HWRITEMuP2       <= '0';
    HTRANSMuP2       <= (others =>'0');
    HSIZEMuP2        <= (others =>'0');
    HBURSTMuP2       <= (others =>'0');
    HREADYINMuP2     <= '0';
  end if;

  if (ReqConfig(4) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP2 = '1') then
        NxtSyncPeriph2   <= '1';
      else
        NxtSyncPeriph2   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP2 = '1') then
        NxtSyncPeriph2   <= '1';
      else
        NxtSyncPeriph2   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP3 = '1') then
    if (ReqConfig(5) = '1') then
      HADDRMuP3        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP3       <= HWRITEM2;
      HTRANSMuP3       <= HTRANSM2;
      HSIZEMuP3        <= HSIZEM2;
      HBURSTMuP3       <= HBURSTM2;
      HREADYINMuP3     <= HREADYINM2;

    else
      HADDRMuP3        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP3       <= HWRITEM1;
      HTRANSMuP3       <= HTRANSM1;
      HSIZEMuP3        <= HSIZEM1;
      HBURSTMuP3       <= HBURSTM1;
      HREADYINMuP3     <= HREADYINM1;
    end if;
  else
    HADDRMuP3        <= (others =>'0');
    HWRITEMuP3       <= '0';
    HTRANSMuP3       <= (others =>'0');
    HSIZEMuP3        <= (others =>'0');
    HBURSTMuP3       <= (others =>'0');
    HREADYINMuP3     <= '0';
  end if;

  if (ReqConfig(5) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP3 = '1') then
        NxtSyncPeriph3   <= '1';
      else
        NxtSyncPeriph3   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP3 = '1') then
        NxtSyncPeriph3   <= '1';
      else
        NxtSyncPeriph3   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP4 = '1') then
    if (ReqConfig(6) = '1') then
      HADDRMuP4        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP4       <= HWRITEM2;
      HTRANSMuP4       <= HTRANSM2;
      HSIZEMuP4        <= HSIZEM2;
      HBURSTMuP4       <= HBURSTM2;
      HREADYINMuP4     <= HREADYINM2;
    else
      HADDRMuP4        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP4       <= HWRITEM1;
      HTRANSMuP4       <= HTRANSM1;
      HSIZEMuP4        <= HSIZEM1;
      HBURSTMuP4       <= HBURSTM1;
      HREADYINMuP4     <= HREADYINM1;
    end if;
  else
    HADDRMuP4        <= (others =>'0');
    HWRITEMuP4       <= '0';
    HTRANSMuP4       <= (others =>'0');
    HSIZEMuP4        <= (others =>'0');
    HBURSTMuP4       <= (others =>'0');
    HREADYINMuP4     <= '0';
  end if;

 if (ReqConfig(6) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP4 = '1') then
        NxtSyncPeriph4   <= '1';
      else
        NxtSyncPeriph4   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP4 = '1') then
        NxtSyncPeriph4   <= '1';
      else
        NxtSyncPeriph4   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP5 = '1') then
    if (ReqConfig(7) = '1') then
      HADDRMuP5        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP5       <= HWRITEM2;
      HTRANSMuP5       <= HTRANSM2;
      HSIZEMuP5        <= HSIZEM2;
      HBURSTMuP5       <= HBURSTM2;
      HREADYINMuP5     <= HREADYINM2;
    else
      HADDRMuP5        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP5       <= HWRITEM1;
      HTRANSMuP5       <= HTRANSM1;
      HSIZEMuP5        <= HSIZEM1;
      HBURSTMuP5       <= HBURSTM1;
      HREADYINMuP5     <= HREADYINM1;
    end if;
  else
    HADDRMuP5        <= (others =>'0');
    HWRITEMuP5       <= '0';
    HTRANSMuP5       <= (others =>'0');
    HSIZEMuP5        <= (others =>'0');
    HBURSTMuP5       <= (others =>'0');
    HREADYINMuP5     <= '0';
  end if;

 if (ReqConfig(7) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP5 = '1') then
        NxtSyncPeriph5   <= '1';
      else
        NxtSyncPeriph5   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP5 = '1') then
        NxtSyncPeriph5   <= '1';
      else
        NxtSyncPeriph5   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP6 = '1') then
    if (ReqConfig(8) = '1') then
      HADDRMuP6        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP6       <= HWRITEM2;
      HTRANSMuP6       <= HTRANSM2;
      HSIZEMuP6        <= HSIZEM2;
      HBURSTMuP6       <= HBURSTM2;
      HREADYINMuP6     <= HREADYINM2;
    else
      HADDRMuP6        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP6       <= HWRITEM1;
      HTRANSMuP6       <= HTRANSM1;
      HSIZEMuP6        <= HSIZEM1;
      HBURSTMuP6       <= HBURSTM1;
      HREADYINMuP6     <= HREADYINM1;
    end if;
  else
    HADDRMuP6        <= (others =>'0');
    HWRITEMuP6       <= '0';
    HTRANSMuP6       <= (others =>'0');
    HSIZEMuP6        <= (others =>'0');
    HBURSTMuP6       <= (others =>'0');
    HREADYINMuP6     <= '0';
  end if;

  if (ReqConfig(8) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP6 = '1') then
        NxtSyncPeriph6   <= '1';
      else
        NxtSyncPeriph6   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP6 = '1') then
        NxtSyncPeriph6   <= '1';
      else
        NxtSyncPeriph6   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP7 = '1') then
    if (ReqConfig(9) = '1') then
      HADDRMuP7        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP7       <= HWRITEM2;
      HTRANSMuP7       <= HTRANSM2;
      HSIZEMuP7        <= HSIZEM2;
      HBURSTMuP7       <= HBURSTM2;
      HREADYINMuP7     <= HREADYINM2;
    else
      HADDRMuP7        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP7       <= HWRITEM1;
      HTRANSMuP7       <= HTRANSM1;
      HSIZEMuP7        <= HSIZEM1;
      HBURSTMuP7       <= HBURSTM1;
      HREADYINMuP7     <= HREADYINM1;
    end if;
  else
    HADDRMuP7        <= (others =>'0');
    HWRITEMuP7       <= '0';
    HTRANSMuP7       <= (others =>'0');
    HSIZEMuP7        <= (others =>'0');
    HBURSTMuP7       <= (others =>'0');
    HREADYINMuP7     <= '0';
  end if;

 if (ReqConfig(9) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP7 = '1') then
        NxtSyncPeriph7   <= '1';
      else
        NxtSyncPeriph7   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP7 = '1') then
        NxtSyncPeriph7   <= '1';
      else
        NxtSyncPeriph7   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP8 = '1') then
    if (ReqConfig(10) = '1') then
      HADDRMuP8        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP8       <= HWRITEM2;
      HTRANSMuP8       <= HTRANSM2;
      HSIZEMuP8        <= HSIZEM2;
      HBURSTMuP8       <= HBURSTM2;
      HREADYINMuP8     <= HREADYINM2;
    else
      HADDRMuP8        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP8       <= HWRITEM1;
      HTRANSMuP8       <= HTRANSM1;
      HSIZEMuP8        <= HSIZEM1;
      HBURSTMuP8       <= HBURSTM1;
      HREADYINMuP8     <= HREADYINM1;
    end if;
  else
    HADDRMuP8        <= (others =>'0');
    HWRITEMuP8       <= '0';
    HTRANSMuP8       <= (others =>'0');
    HSIZEMuP8        <= (others =>'0');
    HBURSTMuP8       <= (others =>'0');
    HREADYINMuP8     <= '0';
  end if;

 if (ReqConfig(10) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP8 = '1') then
        NxtSyncPeriph8   <= '1';
      else
        NxtSyncPeriph8   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP8 = '1') then
        NxtSyncPeriph8   <= '1';
      else
        NxtSyncPeriph8   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP9 = '1') then
    if (ReqConfig(11) = '1') then
      HADDRMuP9        <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP9       <= HWRITEM2;
      HTRANSMuP9       <= HTRANSM2;
      HSIZEMuP9        <= HSIZEM2;
      HBURSTMuP9       <= HBURSTM2;
      HREADYINMuP9     <= HREADYINM2;
    else
      HADDRMuP9        <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP9       <= HWRITEM1;
      HTRANSMuP9       <= HTRANSM1;
      HSIZEMuP9        <= HSIZEM1;
      HBURSTMuP9       <= HBURSTM1;
      HREADYINMuP9     <= HREADYINM1;
    end if;
  else
    HADDRMuP9        <= (others =>'0');
    HWRITEMuP9       <= '0';
    HTRANSMuP9       <= (others =>'0');
    HSIZEMuP9        <= (others =>'0');
    HBURSTMuP9       <= (others =>'0');
    HREADYINMuP9     <= '0';
  end if;

 if (ReqConfig(11) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP9 = '1') then
        NxtSyncPeriph9   <= '1';
      else
        NxtSyncPeriph9   <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP9 = '1') then
        NxtSyncPeriph9   <= '1';
      else
        NxtSyncPeriph9   <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP10 = '1') then
    if (ReqConfig(12) = '1') then
      HADDRMuP10       <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP10      <= HWRITEM2;
      HTRANSMuP10      <= HTRANSM2;
      HSIZEMuP10       <= HSIZEM2;
      HBURSTMuP10      <= HBURSTM2;
      HREADYINMuP10    <= HREADYINM2;
    else
      HADDRMuP10       <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP10      <= HWRITEM1;
      HTRANSMuP10      <= HTRANSM1;
      HSIZEMuP10       <= HSIZEM1;
      HBURSTMuP10      <= HBURSTM1;
      HREADYINMuP10    <= HREADYINM1;
    end if;
  else
    HADDRMuP10       <= (others =>'0');
    HWRITEMuP10      <= '0';
    HTRANSMuP10      <= (others =>'0');
    HSIZEMuP10       <= (others =>'0');
    HBURSTMuP10      <= (others =>'0');
    HREADYINMuP10    <= '0';
  end if;

 if (ReqConfig(12) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP10 = '1') then
        NxtSyncPeriph10  <= '1';
      else
        NxtSyncPeriph10  <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP10 = '1') then
        NxtSyncPeriph10  <= '1';
      else
        NxtSyncPeriph10  <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP11 = '1') then
    if (ReqConfig(13) = '1') then
      HADDRMuP11       <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP11      <= HWRITEM2;
      HTRANSMuP11      <= HTRANSM2;
      HSIZEMuP11       <= HSIZEM2;
      HBURSTMuP11      <= HBURSTM2;
      HREADYINMuP11    <= HREADYINM2;
    else
      HADDRMuP11       <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP11      <= HWRITEM1;
      HTRANSMuP11      <= HTRANSM1;
      HSIZEMuP11       <= HSIZEM1;
      HBURSTMuP11      <= HBURSTM1;
      HREADYINMuP11    <= HREADYINM1;
    end if;
  else
    HADDRMuP11       <= (others =>'0');
    HWRITEMuP11      <= '0';
    HTRANSMuP11      <= (others =>'0');
    HSIZEMuP11       <= (others =>'0');
    HBURSTMuP11      <= (others =>'0');
    HREADYINMuP11    <= '0';
  end if;

 if (ReqConfig(13) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP11 = '1') then
        NxtSyncPeriph11  <= '1';
      else
        NxtSyncPeriph11  <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP11 = '1') then
        NxtSyncPeriph11  <= '1';
      else
        NxtSyncPeriph11  <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP12 = '1') then
    if (ReqConfig(14) = '1') then
      HADDRMuP12       <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP12      <= HWRITEM2;
      HTRANSMuP12      <= HTRANSM2;
      HSIZEMuP12       <= HSIZEM2;
      HBURSTMuP12      <= HBURSTM2;
      HREADYINMuP12    <= HREADYINM2;
    else
      HADDRMuP12       <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP12      <= HWRITEM1;
      HTRANSMuP12      <= HTRANSM1;
      HSIZEMuP12       <= HSIZEM1;
      HBURSTMuP12      <= HBURSTM1;
      HREADYINMuP12    <= HREADYINM1;
    end if;
  else
    HADDRMuP12       <= (others =>'0');
    HWRITEMuP12      <= '0';
    HTRANSMuP12      <= (others =>'0');
    HSIZEMuP12       <= (others =>'0');
    HBURSTMuP12      <= (others =>'0');
    HREADYINMuP12    <= '0';
  end if;

 if (ReqConfig(14) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP12 = '1') then
        NxtSyncPeriph12  <= '1';
      else
        NxtSyncPeriph12  <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP12 = '1') then
        NxtSyncPeriph12  <= '1';
      else
        NxtSyncPeriph12  <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP13 = '1') then
    if (ReqConfig(15) = '1') then
      HADDRMuP13       <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP13      <= HWRITEM2;
      HTRANSMuP13      <= HTRANSM2;
      HSIZEMuP13       <= HSIZEM2;
      HBURSTMuP13      <= HBURSTM2;
      HREADYINMuP13    <= HREADYINM2;
    else
      HADDRMuP13       <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP13      <= HWRITEM1;
      HTRANSMuP13      <= HTRANSM1;
      HSIZEMuP13       <= HSIZEM1;
      HBURSTMuP13      <= HBURSTM1;
      HREADYINMuP13    <= HREADYINM1;
    end if;
  else
    HADDRMuP13       <= (others =>'0');
    HWRITEMuP13      <= '0';
    HTRANSMuP13      <= (others =>'0');
    HSIZEMuP13       <= (others =>'0');
    HBURSTMuP13      <= (others =>'0');
    HREADYINMuP13    <= '0';
  end if;

 if (ReqConfig(15) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP13 = '1') then
        NxtSyncPeriph13  <= '1';
      else
        NxtSyncPeriph13  <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP13 = '1') then
        NxtSyncPeriph13  <= '1';
      else
        NxtSyncPeriph13  <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP14 = '1') then
    if (ReqConfig(16) = '1') then
      HADDRMuP14       <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP14      <= HWRITEM2;
      HTRANSMuP14      <= HTRANSM2;
      HSIZEMuP14       <= HSIZEM2;
      HBURSTMuP14      <= HBURSTM2;
      HREADYINMuP14    <= HREADYINM2;
    else
      HADDRMuP14       <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP14      <= HWRITEM1;
      HTRANSMuP14      <= HTRANSM1;
      HSIZEMuP14       <= HSIZEM1;
      HBURSTMuP14      <= HBURSTM1;
      HREADYINMuP14    <= HREADYINM1;
    end if;
  else
    HADDRMuP14       <= (others =>'0');
    HWRITEMuP14      <= '0';
    HTRANSMuP14      <= (others =>'0');
    HSIZEMuP14       <= (others =>'0');
    HBURSTMuP14      <= (others =>'0');
    HREADYINMuP14    <= '0';
  end if;

 if (ReqConfig(16) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP14 = '1') then
        NxtSyncPeriph14  <= '1';
      else
        NxtSyncPeriph14  <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP14 = '1') then
        NxtSyncPeriph14  <= '1';
      else
        NxtSyncPeriph14  <= '0';
      end if;
    end if;
  end if;

  if (HSELPERIPHuP15 = '1') then
    if (ReqConfig(17) = '1') then
      HADDRMuP15       <= HADDRM2(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP15      <= HWRITEM2;
      HTRANSMuP15      <= HTRANSM2;
      HSIZEMuP15       <= HSIZEM2;
      HBURSTMuP15      <= HBURSTM2;
      HREADYINMuP15    <= HREADYINM2;
    else
      HADDRMuP15       <= HADDRM1(MASTERADDRHB downto MASTERADDRLB);
      HWRITEMuP15      <= HWRITEM1;
      HTRANSMuP15      <= HTRANSM1;
      HSIZEMuP15       <= HSIZEM1;
      HBURSTMuP15      <= HBURSTM1;
      HREADYINMuP15    <= HREADYINM1;
    end if;
  else
    HADDRMuP15       <= (others =>'0');
    HWRITEMuP15      <= '0';
    HTRANSMuP15      <= (others =>'0');
    HSIZEMuP15       <= (others =>'0');
    HBURSTMuP15      <= (others =>'0');
    HREADYINMuP15    <= '0';
  end if;

 if (ReqConfig(17) = '1') then
    if (HREADYINM2 = '1') then
      if (HSELPERIPHuP15 = '1') then
        NxtSyncPeriph15  <= '1';
      else
        NxtSyncPeriph15  <= '0';
      end if;
    end if;
  else
    if (HREADYINM1 = '1') then
      if (HSELPERIPHuP15 = '1') then
        NxtSyncPeriph15  <= '1';
      else
        NxtSyncPeriph15  <= '0';
      end if;
    end if;
  end if;

end process p_ControlInfoComb;

-- -----------------------------------------------------------------------------
-- Sync Sequential Block
-- -----------------------------------------------------------------------------
p_SyncSeq  : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SyncMem0          <= '0';
    SyncMem1          <= '0';
    SyncPeriph0       <= '0';
    SyncPeriph1       <= '0';
    SyncPeriph2       <= '0';
    SyncPeriph3       <= '0';
    SyncPeriph4       <= '0';
    SyncPeriph5       <= '0';
    SyncPeriph6       <= '0';
    SyncPeriph7       <= '0';
    SyncPeriph8       <= '0';
    SyncPeriph9       <= '0';
    SyncPeriph10      <= '0';
    SyncPeriph11      <= '0';
    SyncPeriph12      <= '0';
    SyncPeriph13      <= '0';
    SyncPeriph14      <= '0';
    SyncPeriph15      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SyncMem0          <= NxtSyncMem0;
    SyncMem1          <= NxtSyncMem1;
    SyncPeriph0       <= NxtSyncPeriph0;
    SyncPeriph1       <= NxtSyncPeriph1;
    SyncPeriph2       <= NxtSyncPeriph2;
    SyncPeriph3       <= NxtSyncPeriph3;
    SyncPeriph4       <= NxtSyncPeriph4;
    SyncPeriph5       <= NxtSyncPeriph5;
    SyncPeriph6       <= NxtSyncPeriph6;
    SyncPeriph7       <= NxtSyncPeriph7;
    SyncPeriph8       <= NxtSyncPeriph8;
    SyncPeriph9       <= NxtSyncPeriph9;
    SyncPeriph10      <= NxtSyncPeriph10;
    SyncPeriph11      <= NxtSyncPeriph11;
    SyncPeriph12      <= NxtSyncPeriph12;
    SyncPeriph13      <= NxtSyncPeriph13;
    SyncPeriph14      <= NxtSyncPeriph14;
    SyncPeriph15      <= NxtSyncPeriph15;
  end if;
end process p_SyncSeq;

-- -----------------------------------------------------------------------------
-- Read Write Data assignment Block
-- -----------------------------------------------------------------------------
p_DataComb : process (SyncMem0, HREADYOUTMuM0, HRESPMuM0, HRDATAMuM0,
                      SyncMem1, HREADYOUTMuM1, HRESPMuM1, HRDATAMuM1,
                      SyncPeriph0, HREADYOUTMuP0, HRESPMuP0, HRDATAMuP0,
                      SyncPeriph1, HREADYOUTMuP1, HRESPMuP1, HRDATAMuP1,
                      SyncPeriph2, HREADYOUTMuP2, HRESPMuP2, HRDATAMuP2,
                      SyncPeriph3, HREADYOUTMuP3, HRESPMuP3, HRDATAMuP3,
                      SyncPeriph4, HREADYOUTMuP4, HRESPMuP4, HRDATAMuP4,
                      SyncPeriph5, HREADYOUTMuP5, HRESPMuP5, HRDATAMuP5,
                      SyncPeriph6, HREADYOUTMuP6, HRESPMuP6, HRDATAMuP6,
                      SyncPeriph7, HREADYOUTMuP7, HRESPMuP7, HRDATAMuP7,
                      SyncPeriph8, HREADYOUTMuP8, HRESPMuP8, HRDATAMuP8,
                      SyncPeriph9, HREADYOUTMuP9, HRESPMuP9, HRDATAMuP9,
                      SyncPeriph10, HREADYOUTMuP10, HRESPMuP10, HRDATAMuP10,
                      SyncPeriph11, HREADYOUTMuP11, HRESPMuP11, HRDATAMuP11,
                      SyncPeriph12, HREADYOUTMuP12, HRESPMuP12, HRDATAMuP12,
                      SyncPeriph13, HREADYOUTMuP13, HRESPMuP13, HRDATAMuP13,
                      SyncPeriph14, HREADYOUTMuP14, HRESPMuP14, HRDATAMuP14,
                      SyncPeriph15, HREADYOUTMuP15, HRESPMuP15, HRDATAMuP15,
                      HWDATAM2, HWDATAM1, ReqConfig, HRESETn)
begin
  if (HRESETn = '0') then
    HREADYOUTM2       <= '1';
    HRESPM2           <= (others => '0');
    HRDATAM2          <= (others => '0');

    HREADYOUTM1       <= '1';
    HRESPM1           <= (others => '0');
    HRDATAM1          <= (others => '0');
  end if;

  if (SyncMem0 = '1') then
    if (ReqConfig(0) = '1') then
      HWDATAMuM0       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuM0;
      HRESPM2          <= HRESPMuM0;
      HRDATAM2         <= HRDATAMuM0;
    else
      HWDATAMuM0       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuM0;
      HRESPM1          <= HRESPMuM0;
      HRDATAM1         <= HRDATAMuM0;
    end if;
  else
    HWDATAMuM0       <= (others => '0');
  end if;

  if (SyncMem1 = '1') then
    if (ReqConfig(1) = '1') then
      HWDATAMuM1       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuM1;
      HRESPM2          <= HRESPMuM1;
      HRDATAM2         <= HRDATAMuM1;
    else
      HWDATAMuM1       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuM1;
      HRESPM1          <= HRESPMuM1;
      HRDATAM1         <= HRDATAMuM1;
    end if;
  else
    HWDATAMuM1       <= (others => '0');
  end if;

  if (SyncPeriph0 = '1') then
    if (ReqConfig(2) = '1') then
      HWDATAMuP0       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP0;
      HRESPM2          <= HRESPMuP0;
      HRDATAM2         <= HRDATAMuP0;
    else
      HWDATAMuP0       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP0;
      HRESPM1          <= HRESPMuP0;
      HRDATAM1         <= HRDATAMuP0;
    end if;
  else
    HWDATAMuP0       <= (others => '0');
   end if;

  if (SyncPeriph1 = '1') then
    if (ReqConfig(3) = '1') then
      HWDATAMuP1       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP1;
      HRESPM2          <= HRESPMuP1;
      HRDATAM2         <= HRDATAMuP1;
    else
      HWDATAMuP1       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP1;
      HRESPM1          <= HRESPMuP1;
      HRDATAM1         <= HRDATAMuP1;
    end if;
  else
    HWDATAMuP1       <= (others => '0');
  end if;

  if (SyncPeriph2 = '1') then
    if (ReqConfig(4) = '1') then
      HWDATAMuP2       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP2;
      HRESPM2          <= HRESPMuP2;
      HRDATAM2         <= HRDATAMuP2;
    else
      HWDATAMuP2       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP2;
      HRESPM1          <= HRESPMuP2;
      HRDATAM1         <= HRDATAMuP2;
    end if;
  else
    HWDATAMuP2       <= (others => '0');
  end if;

  if (SyncPeriph3 = '1') then
    if (ReqConfig(5) = '1') then
      HWDATAMuP3       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP3;
      HRESPM2          <= HRESPMuP3;
      HRDATAM2         <= HRDATAMuP3;
    else
      HWDATAMuP3       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP3;
      HRESPM1          <= HRESPMuP3;
      HRDATAM1         <= HRDATAMuP3;
    end if;
  else
    HWDATAMuP3       <= (others => '0');
  end if;

  if (SyncPeriph4 = '1') then
    if (ReqConfig(6) = '1') then
      HWDATAMuP4       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP4;
      HRESPM2          <= HRESPMuP4;
      HRDATAM2         <= HRDATAMuP4;
    else
      HWDATAMuP4       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP4;
      HRESPM1          <= HRESPMuP4;
      HRDATAM1         <= HRDATAMuP4;
    end if;
  else
    HWDATAMuP4       <= (others => '0');
  end if;

  if (SyncPeriph5 = '1') then
    if (ReqConfig(7) = '1') then
      HWDATAMuP5       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP5;
      HRESPM2          <= HRESPMuP5;
      HRDATAM2         <= HRDATAMuP5;
    else
      HWDATAMuP5       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP5;
      HRESPM1          <= HRESPMuP5;
      HRDATAM1         <= HRDATAMuP5;
    end if;
  else
    HWDATAMuP5       <= (others => '0');
  end if;

  if (SyncPeriph6 = '1') then
    if (ReqConfig(8) = '1') then
      HWDATAMuP6       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP6;
      HRESPM2          <= HRESPMuP6;
      HRDATAM2         <= HRDATAMuP6;
    else
      HWDATAMuP6       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP6;
      HRESPM1          <= HRESPMuP6;
      HRDATAM1         <= HRDATAMuP6;
    end if;
  else
    HWDATAMuP6       <= (others => '0');
  end if;

  if (SyncPeriph7 = '1') then
    if (ReqConfig(9) = '1') then
      HWDATAMuP7       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP7;
      HRESPM2          <= HRESPMuP7;
      HRDATAM2         <= HRDATAMuP7;
    else
      HWDATAMuP7       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP7;
      HRESPM1          <= HRESPMuP7;
      HRDATAM1         <= HRDATAMuP7;
    end if;
  else
    HWDATAMuP7       <= (others => '0');
  end if;

  if (SyncPeriph8 = '1') then
    if (ReqConfig(10) = '1') then
      HWDATAMuP8       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP8;
      HRESPM2          <= HRESPMuP8;
      HRDATAM2         <= HRDATAMuP8;
    else
      HWDATAMuP8       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP8;
      HRESPM1          <= HRESPMuP8;
      HRDATAM1         <= HRDATAMuP8;
    end if;
  else
    HWDATAMuP8       <= (others => '0');
  end if;

  if (SyncPeriph9 = '1') then
    if (ReqConfig(11) = '1') then
      HWDATAMuP9       <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP9;
      HRESPM2          <= HRESPMuP9;
      HRDATAM2         <= HRDATAMuP9;
    else
      HWDATAMuP9       <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP9;
      HRESPM1          <= HRESPMuP9;
      HRDATAM1         <= HRDATAMuP9;
    end if;
  else
    HWDATAMuP9       <= (others => '0');
  end if;

  if (SyncPeriph10 = '1') then
    if (ReqConfig(12) = '1') then
      HWDATAMuP10      <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP10;
      HRESPM2          <= HRESPMuP10;
      HRDATAM2         <= HRDATAMuP10;
    else
      HWDATAMuP10      <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP10;
      HRESPM1          <= HRESPMuP10;
      HRDATAM1         <= HRDATAMuP10;
    end if;
  else
    HWDATAMuP10      <= (others => '0');
  end if;

  if (SyncPeriph11 = '1') then
    if (ReqConfig(13) = '1') then
      HWDATAMuP11      <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP11;
      HRESPM2          <= HRESPMuP11;
      HRDATAM2         <= HRDATAMuP11;
    else
      HWDATAMuP11      <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP11;
      HRESPM1          <= HRESPMuP11;
      HRDATAM1         <= HRDATAMuP11;
    end if;
  else
    HWDATAMuP11      <= (others => '0');
  end if;

  if (SyncPeriph12 = '1') then
    if (ReqConfig(14) = '1') then
      HWDATAMuP12      <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP12;
      HRESPM2          <= HRESPMuP12;
      HRDATAM2         <= HRDATAMuP12;
    else
      HWDATAMuP12      <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP12;
      HRESPM1          <= HRESPMuP12;
      HRDATAM1         <= HRDATAMuP12;
    end if;
  else
    HWDATAMuP12      <= (others => '0');
  end if;

  if (SyncPeriph13 = '1') then
    if (ReqConfig(15) = '1') then
      HWDATAMuP13      <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP13;
      HRESPM2          <= HRESPMuP13;
      HRDATAM2         <= HRDATAMuP13;
    else
      HWDATAMuP13      <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP13;
      HRESPM1          <= HRESPMuP13;
      HRDATAM1         <= HRDATAMuP13;
    end if;
  else
    HWDATAMuP13      <= (others => '0');
  end if;

  if (SyncPeriph14 = '1') then
    if (ReqConfig(16) = '1') then
      HWDATAMuP14      <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP14;
      HRESPM2          <= HRESPMuP14;
      HRDATAM2         <= HRDATAMuP14;
    else
      HWDATAMuP14      <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP14;
      HRESPM1          <= HRESPMuP14;
      HRDATAM1         <= HRDATAMuP14;
    end if;
  else
    HWDATAMuP14      <= (others => '0');
  end if;

  if (SyncPeriph15 = '1') then
    if (ReqConfig(17) = '1') then
      HWDATAMuP15      <= HWDATAM2;
      HREADYOUTM2      <= HREADYOUTMuP15;
      HRESPM2          <= HRESPMuP15;
      HRDATAM2         <= HRDATAMuP15;
    else
      HWDATAMuP15      <= HWDATAM1;
      HREADYOUTM1      <= HREADYOUTMuP15;
      HRESPM1          <= HRESPMuP15;
      HRDATAM1         <= HRDATAMuP15;
    end if;
  else
    HWDATAMuP15      <= (others => '0');
  end if;

end process p_DataComb;

-- -----------------------------------------------------------------------------
-- RegSync Generation Block
-- -----------------------------------------------------------------------------
p_RegAssignComb  : process(HSELREGuM0, HSELREGuM1, HSELREGuP0, HSELREGuP1,
                           HSELREGuP2, HSELREGuP3, HSELREGuP4, HSELREGuP5,
                           HSELREGuP6, HSELREGuP7, HSELREGuP8, HSELREGuP9,
                           HSELREGuP10, HSELREGuP11, HSELREGuP12, HSELREGuP13,
                           HSELREGuP14, HSELREGuP15, RegSyncP0, RegSyncP1,
                           RegSyncP2, RegSyncP3, RegSyncP4, RegSyncP5,
                           RegSyncP6, RegSyncP7, RegSyncP8, RegSyncP9,
                           RegSyncP10, RegSyncP11, RegSyncP12, RegSyncP13,
                           RegSyncP14, RegSyncP15, RegSyncMem0, RegSyncMem1,
                           RegSyncTr, HSELDMACTrSlave)
begin
  NxtRegSyncTr     <= RegSyncTr;
  NxtRegSyncMem0   <= RegSyncMem0;
  NxtRegSyncMem1   <= RegSyncMem1;
  NxtRegSyncP0     <= RegSyncP0;
  NxtRegSyncP1     <= RegSyncP1;
  NxtRegSyncP2     <= RegSyncP2;
  NxtRegSyncP3     <= RegSyncP3;
  NxtRegSyncP4     <= RegSyncP4;
  NxtRegSyncP5     <= RegSyncP5;
  NxtRegSyncP6     <= RegSyncP6;
  NxtRegSyncP7     <= RegSyncP7;
  NxtRegSyncP8     <= RegSyncP8;
  NxtRegSyncP9     <= RegSyncP9;
  NxtRegSyncP10    <= RegSyncP10;
  NxtRegSyncP11    <= RegSyncP11;
  NxtRegSyncP12    <= RegSyncP12;
  NxtRegSyncP13    <= RegSyncP13;
  NxtRegSyncP14    <= RegSyncP14;
  NxtRegSyncP15    <= RegSyncP15;

  if (HSELDMACTrSlave = '1') then
    NxtRegSyncTr   <= '1';
  else
    NxtRegSyncTr   <= '0';
  end if;

  if (HSELREGuM0 = '1') then
    NxtRegSyncMem0   <= '1';
  else
    NxtRegSyncMem0   <= '0';
  end if;

  if (HSELREGuM1 = '1') then
    NxtRegSyncMem1   <= '1';
  else
    NxtRegSyncMem1   <= '0';
  end if;

  if (HSELREGuP0 = '1') then
    NxtRegSyncP0     <= '1';
  else
    NxtRegSyncP0     <= '0';
  end if;

  if (HSELREGuP1 = '1') then
    NxtRegSyncP1     <= '1';
  else
    NxtRegSyncP1     <= '0';
  end if;

  if (HSELREGuP2 = '1') then
    NxtRegSyncP2     <= '1';
  else
    NxtRegSyncP2     <= '0';
  end if;

  if (HSELREGuP3 = '1') then
    NxtRegSyncP3     <= '1';
  else
    NxtRegSyncP3     <= '0';
  end if;

  if (HSELREGuP4 = '1') then
    NxtRegSyncP4     <= '1';
  else
    NxtRegSyncP4     <= '0';
  end if;

  if (HSELREGuP5 = '1') then
    NxtRegSyncP5     <= '1';
  else
    NxtRegSyncP5     <= '0';
  end if;

  if (HSELREGuP6 = '1') then
    NxtRegSyncP6     <= '1';
  else
    NxtRegSyncP6     <= '0';
  end if;

  if (HSELREGuP7 = '1') then
    NxtRegSyncP7     <= '1';
  else
    NxtRegSyncP7     <= '0';
  end if;

  if (HSELREGuP8 = '1') then
    NxtRegSyncP8     <= '1';
  else
    NxtRegSyncP8     <= '0';
  end if;

  if (HSELREGuP9 = '1') then
    NxtRegSyncP9     <= '1';
  else
    NxtRegSyncP9     <= '0';
  end if;

  if (HSELREGuP10 = '1') then
    NxtRegSyncP10    <= '1';
  else
    NxtRegSyncP10    <= '0';
  end if;

  if (HSELREGuP11 = '1') then
    NxtRegSyncP11    <= '1';
  else
    NxtRegSyncP11    <= '0';
  end if;

  if (HSELREGuP12 = '1') then
    NxtRegSyncP12    <= '1';
  else
    NxtRegSyncP12    <= '0';
  end if;

  if (HSELREGuP13 = '1') then
    NxtRegSyncP13    <= '1';
  else
    NxtRegSyncP13    <= '0';
  end if;

  if (HSELREGuP14 = '1') then
    NxtRegSyncP14    <= '1';
  else
    NxtRegSyncP14    <= '0';
  end if;

  if (HSELREGuP15 = '1') then
    NxtRegSyncP15    <= '1';
  else
    NxtRegSyncP15    <= '0';
  end if;
end process p_RegAssignComb;

-- -----------------------------------------------------------------------------
-- RegSync Sequential Block
-- -----------------------------------------------------------------------------
p_RegSeq  : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegSyncTr         <= '0';
    RegSyncMem0       <= '0';
    RegSyncMem1       <= '0';
    RegSyncP0         <= '0';
    RegSyncP1         <= '0';
    RegSyncP2         <= '0';
    RegSyncP3         <= '0';
    RegSyncP4         <= '0';
    RegSyncP5         <= '0';
    RegSyncP6         <= '0';
    RegSyncP7         <= '0';
    RegSyncP8         <= '0';
    RegSyncP9         <= '0';
    RegSyncP10        <= '0';
    RegSyncP11        <= '0';
    RegSyncP12        <= '0';
    RegSyncP13        <= '0';
    RegSyncP14        <= '0';
    RegSyncP15        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RegSyncTr         <= NxtRegSyncTr;
    RegSyncMem0       <= NxtRegSyncMem0;
    RegSyncMem1       <= NxtRegSyncMem1;
    RegSyncP0         <= NxtRegSyncP0;
    RegSyncP1         <= NxtRegSyncP1;
    RegSyncP2         <= NxtRegSyncP2;
    RegSyncP3         <= NxtRegSyncP3;
    RegSyncP4         <= NxtRegSyncP4;
    RegSyncP5         <= NxtRegSyncP5;
    RegSyncP6         <= NxtRegSyncP6;
    RegSyncP7         <= NxtRegSyncP7;
    RegSyncP8         <= NxtRegSyncP8;
    RegSyncP9         <= NxtRegSyncP9;
    RegSyncP10        <= NxtRegSyncP10;
    RegSyncP11        <= NxtRegSyncP11;
    RegSyncP12        <= NxtRegSyncP12;
    RegSyncP13        <= NxtRegSyncP13;
    RegSyncP14        <= NxtRegSyncP14;
    RegSyncP15        <= NxtRegSyncP15;
  end if;
end process p_RegSeq;

-- -----------------------------------------------------------------------------
-- Read Write Data combo block.
-- -----------------------------------------------------------------------------
p_RegDataComb : process(RegSyncMem0, RegSyncMem1, HREADYOUTuM0, HREADYOUTuM1,
                        HRESPuM0, HRESPuM1, HRDATAuM0, HRDATAuM1,
                        RegSyncP0, HREADYOUTuP0, HRESPuP0, HRDATAuP0,
                        RegSyncP1, HREADYOUTuP1, HRESPuP1, HRDATAuP1,
                        RegSyncP2, HREADYOUTuP2, HRESPuP2, HRDATAuP2,
                        RegSyncP3, HREADYOUTuP3, HRESPuP3, HRDATAuP3,
                        RegSyncP4, HREADYOUTuP4, HRESPuP4, HRDATAuP4,
                        RegSyncP5, HREADYOUTuP5, HRESPuP5, HRDATAuP5,
                        RegSyncP6, HREADYOUTuP6, HRESPuP6, HRDATAuP6,
                        RegSyncP7, HREADYOUTuP7, HRESPuP7, HRDATAuP7,
                        RegSyncP8, HREADYOUTuP8, HRESPuP8, HRDATAuP8,
                        RegSyncP9, HREADYOUTuP9, HRESPuP9, HRDATAuP9,
                        RegSyncP10, HREADYOUTuP10, HRESPuP10, HRDATAuP10,
                        RegSyncP11, HREADYOUTuP11, HRESPuP11, HRDATAuP11,
                        RegSyncP12, HREADYOUTuP12, HRESPuP12, HRDATAuP12,
                        RegSyncP13, HREADYOUTuP13, HRESPuP13, HRDATAuP13,
                        RegSyncP14, HREADYOUTuP14, HRESPuP14, HRDATAuP14,
                        RegSyncP15, HREADYOUTuP15, HRESPuP15, HRDATAuP15,
                        HRESETn, RegSyncTr, HREADYOUTTrIn, HRESPTrIn)
begin

  if (HRESETn = '0') then
    iHREADYOUT     <= '1';
    iHRESP         <= (others => '0');
    iHRDATA        <= (others => '0');
  end if;

  if (RegSyncTr = '1') then
    iHREADYOUT     <= HREADYOUTTrIn;
    iHRESP         <= HRESPTrIn;
  end if;

  if (RegSyncMem0 = '1') then
    iHREADYOUT     <= HREADYOUTuM0;
    iHRESP         <= HRESPuM0;
    iHRDATA        <= HRDATAuM0;
  end if;

  if (RegSyncMem1 = '1') then
    iHREADYOUT     <= HREADYOUTuM1;
    iHRESP         <= HRESPuM1;
    iHRDATA        <= HRDATAuM1;
  end if;

  if (RegSyncP0 = '1') then
    iHREADYOUT     <= HREADYOUTuP0;
    iHRESP         <= HRESPuP0;
    iHRDATA        <= HRDATAuP0;
  end if;

  if (RegSyncP1 = '1') then
    iHREADYOUT     <= HREADYOUTuP1;
    iHRESP         <= HRESPuP1;
    iHRDATA        <= HRDATAuP1;
  end if;

  if (RegSyncP2 = '1') then
    iHREADYOUT     <= HREADYOUTuP2;
    iHRESP         <= HRESPuP2;
    iHRDATA        <= HRDATAuP2;
  end if;

  if (RegSyncP3 = '1') then
    iHREADYOUT     <= HREADYOUTuP3;
    iHRESP         <= HRESPuP3;
    iHRDATA        <= HRDATAuP3;
  end if;

  if (RegSyncP4 = '1') then
    iHREADYOUT     <= HREADYOUTuP4;
    iHRESP         <= HRESPuP4;
    iHRDATA        <= HRDATAuP4;
  end if;

  if (RegSyncP5 = '1') then
    iHREADYOUT     <= HREADYOUTuP5;
    iHRESP         <= HRESPuP5;
    iHRDATA        <= HRDATAuP5;
  end if;

  if (RegSyncP6 = '1') then
    iHREADYOUT     <= HREADYOUTuP6;
    iHRESP         <= HRESPuP6;
    iHRDATA        <= HRDATAuP6;
  end if;

  if (RegSyncP7 = '1') then
    iHREADYOUT     <= HREADYOUTuP7;
    iHRESP         <= HRESPuP7;
    iHRDATA        <= HRDATAuP7;
  end if;

  if (RegSyncP8 = '1') then
    iHREADYOUT     <= HREADYOUTuP8;
    iHRESP         <= HRESPuP8;
    iHRDATA        <= HRDATAuP8;
  end if;

  if (RegSyncP9 = '1') then
    iHREADYOUT     <= HREADYOUTuP9;
    iHRESP         <= HRESPuP9;
    iHRDATA        <= HRDATAuP9;
  end if;

  if (RegSyncP10 = '1') then
    iHREADYOUT     <= HREADYOUTuP10;
    iHRESP         <= HRESPuP10;
    iHRDATA        <= HRDATAuP10;
  end if;

  if (RegSyncP11 = '1') then
    iHREADYOUT     <= HREADYOUTuP11;
    iHRESP         <= HRESPuP11;
    iHRDATA        <= HRDATAuP11;
  end if;

  if (RegSyncP12 = '1') then
    iHREADYOUT     <= HREADYOUTuP12;
    iHRESP         <= HRESPuP12;
    iHRDATA        <= HRDATAuP12;
  end if;

  if (RegSyncP13 = '1') then
    iHREADYOUT     <= HREADYOUTuP13;
    iHRESP         <= HRESPuP13;
    iHRDATA        <= HRDATAuP13;
  end if;

  if (RegSyncP14 = '1') then
    iHREADYOUT     <= HREADYOUTuP14;
    iHRESP         <= HRESPuP14;
    iHRDATA        <= HRDATAuP14;
  end if;

  if (RegSyncP15 = '1') then
    iHREADYOUT     <= HREADYOUTuP15;
    iHRESP         <= HRESPuP15;
    iHRDATA        <= HRDATAuP15;
  end if;
end process p_RegDataComb;


HREADYOUT        <= iHREADYOUT;

HRESP            <= iHRESP;

HRDATA           <= iHRDATA;

DMACSREQ         <= iDMACSREQ;

DMACBREQ         <= iDMACBREQ;

DMACLSREQ        <= iDMACLSREQ;

DMACLBREQ        <= iDMACLBREQ;

end behavioural;

-- --================================== End ==================================--
