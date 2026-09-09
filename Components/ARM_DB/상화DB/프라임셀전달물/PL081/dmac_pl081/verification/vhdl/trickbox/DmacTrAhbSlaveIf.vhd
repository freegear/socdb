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
-- File Name              : DmacTrAhbSlaveIf.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Behavioural DMAC's AHB Slave Interface module. This module is
--           responsible for generating all the Write Enables for the channel.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrAhbSlaveIf is
  port (
-- Inputs
        -- AHB signals
        HCLK             : in    std_logic; -- AHB clock
        HRESETn          : in    std_logic; -- AHB Reset
        HSELDMAC         : in    std_logic; -- Slave Select for DMAC
        HSELDMACTrSlave  : in    std_logic; -- Trickbox Select from AHB3
        HWRITE           : in    std_logic; -- Write signal from AHB3
        HTRANS           : in    std_logic; -- Type of transfer on AHB Bit 1 of
                                            -- HTRANS on AHB
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HADDR            : in    std_logic_vector(20 downto 2);
                                            -- AHB slave address
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- The width of the transfer on AHB
        HREADYIN         : in    std_logic; -- Ready response on AHB
                                            -- from previous Slave
        SoftClr          : in    std_logic_vector(15 downto 0);
                                            -- Clear from all the channels for
                                            -- SoftReq
        DmacClr          : in    std_logic_vector(15 downto 0);
                                            -- Clear from all the channels
        DMACBREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC burst transfer request
        DMACLBREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC last burst transfer request
        DMACSREQ         : in    std_logic_vector(15 downto 0);
                                            -- DMAC single transfer request
        DMACLSREQ        : in    std_logic_vector(15 downto 0);
                                            -- DMAC last single transfer request
-- Outputs
        -- AHB signals
        HREADYOUT        : out   std_logic; -- Transfer response from Trickbox
                                            -- AHB slave interface when
                                            -- HSELDMACTr is asserted
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Ready response from Trickbox AHB
                                            -- slave interface when HSELDMACTr
                                            -- is asserted
        -- Write Enables for Channel Registers
        DmacSrcRegWrEn0  : out   std_logic; -- Write Enable for DMACC0SrcAddr
        DmacDstRegWrEn0  : out   std_logic; -- Write Enable for DMACC0DestAddr
        DmacLLIRegWrEn0  : out   std_logic; -- Write Enable for DMACC0LLIReg
        DmacCntlRegWrEn0 : out   std_logic; -- Write Enable for DMACC0Control
        DmacChCnfgWrEn0  : out   std_logic; -- Write Enable for DMACC0Config
        DmacSrcRegWrEn1  : out   std_logic; -- Write Enable for DMACC1SrcAddr
        DmacDstRegWrEn1  : out   std_logic; -- Write Enable for DMACC1DestAddr
        DmacLLIRegWrEn1  : out   std_logic; -- Write Enable for DMACC1LLIReg
        DmacCntlRegWrEn1 : out   std_logic; -- Write Enable for DMACC1Control
        DmacChCnfgWrEn1  : out   std_logic; -- Write Enable for DMACC1Config
        DmacSrcRegWrEn2  : out   std_logic; -- Write Enable for DMACC2SrcAddr
        DmacDstRegWrEn2  : out   std_logic; -- Write Enable for DMACC2DestAddr
        DmacLLIRegWrEn2  : out   std_logic; -- Write Enable for DMACC2LLIReg
        DmacCntlRegWrEn2 : out   std_logic; -- Write Enable for DMACC2Control
        DmacChCnfgWrEn2  : out   std_logic; -- Write Enable for DMACC2Config
        DmacSrcRegWrEn3  : out   std_logic; -- Write Enable for DMACC3SrcAddr
        DmacDstRegWrEn3  : out   std_logic; -- Write Enable for DMACC3DestAddr
        DmacLLIRegWrEn3  : out   std_logic; -- Write Enable for DMACC3LLIReg
        DmacCntlRegWrEn3 : out   std_logic; -- Write Enable for DMACC3Control
        DmacChCnfgWrEn3  : out   std_logic; -- Write Enable for DMACC3Config
        DmacSrcRegWrEn4  : out   std_logic; -- Write Enable for DMACC4SrcAddr
        DmacDstRegWrEn4  : out   std_logic; -- Write Enable for DMACC4DestAddr
        DmacLLIRegWrEn4  : out   std_logic; -- Write Enable for DMACC4LLIReg
        DmacCntlRegWrEn4 : out   std_logic; -- Write Enable for DMACC4Control
        DmacChCnfgWrEn4  : out   std_logic; -- Write Enable for DMACC4Config
        DmacSrcRegWrEn5  : out   std_logic; -- Write Enable for DMACC5SrcAddr
        DmacDstRegWrEn5  : out   std_logic; -- Write Enable for DMACC5DestAddr
        DmacLLIRegWrEn5  : out   std_logic; -- Write Enable for DMACC5LLIReg
        DmacCntlRegWrEn5 : out   std_logic; -- Write Enable for DMACC5Control
        DmacChCnfgWrEn5  : out   std_logic; -- Write Enable for DMACC5Config
        DmacSrcRegWrEn6  : out   std_logic; -- Write Enable for DMACC6SrcAddr
        DmacDstRegWrEn6  : out   std_logic; -- Write Enable for DMACC6DestAddr
        DmacLLIRegWrEn6  : out   std_logic; -- Write Enable for DMACC6LLIReg
        DmacCntlRegWrEn6 : out   std_logic; -- Write Enable for DMACC6Control
        DmacChCnfgWrEn6  : out   std_logic; -- Write Enable for DMACC6Config
        DmacSrcRegWrEn7  : out   std_logic; -- Write Enable for DMACC7SrcAddr
        DmacDstRegWrEn7  : out   std_logic; -- Write Enable for DMACC7DestAddr
        DmacLLIRegWrEn7  : out   std_logic; -- Write Enable for DMACC7LLIReg
        DmacCntlRegWrEn7 : out   std_logic; -- Write Enable for DMACC7Control
        DmacChCnfgWrEn7  : out   std_logic; -- Write Enable for DMACC7Config
        -- Request signals to the channels
        DMACBREQCh       : out   std_logic_vector(15 downto 0);
                                            -- DMAC burst transfer request
        DMACLBREQCh      : out   std_logic_vector(15 downto 0);
                                            -- DMAC last burst transfer request
        DMACSREQCh       : out   std_logic_vector(15 downto 0);
                                            -- DMAC single transfer request
        DMACLSREQCh      : out   std_logic_vector(15 downto 0);
                                            -- DMAC last single transfer request
        SOFTBREQCh       : out   std_logic_vector(15 downto 0);
                                            -- Soft burst transfer request
        SOFTLBREQCh      : out   std_logic_vector(15 downto 0);
                                            -- Soft last burst transfer request
        SOFTSREQCh       : out   std_logic_vector(15 downto 0);
                                            -- Soft single transfer request
        SOFTLSREQCh      : out   std_logic_vector(15 downto 0);
                                            -- Soft last single transfer request
        -- DMAC interrupt request signals
        ClrIntErr        : out   std_logic_vector(7 downto 0);
                                            -- Clear for DMAC error interrupt
        ClrIntTC         : out   std_logic_vector(7 downto 0);
                                            -- Clear for DMAC TC interrupt
        DMACEn           : out   std_logic; -- DMAC Controller Enable
        ReqConfig        : out   std_logic_vector(17 downto 0);
                                            -- Config Reg for Periph/Mem module
        GrantCount0      : out   std_logic_vector(31 downto 0);
                                            -- Trickbox Grant Generation Reg0
        GrantCount1      : out   std_logic_vector(31 downto 0);
                                            -- Trickbox Grant Generation Reg1
        DmacTrEn         : out   std_logic; -- DMAC Trickbox Enable
        MasterEndian1    : out   std_logic; -- Endianness bit for master 1
        MasterEndian2    : out   std_logic  -- Endianness bit for master 2
       );
end DmacTrAhbSlaveIf;

-- -----------------------------------------------------------------------------
--
--                              DmacTrAhbSlaveIf
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module is responsible for generating all the Write Enables for the
-- channel. The Synchronizers for the peripheral request lines are implemented
-- here. The interrupts and clear are generated in this module
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture behavioural of DmacTrAhbSlaveIf is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iHRESP           : std_logic_vector(1 downto 0);
-- Internal copy of HRESP

signal NextHResp        : std_logic_vector(1 downto 0);
-- D input of iHRESP flip-flop

signal iDMACEn          : std_logic;
-- Internal copy of DMACEn

signal ITEN             : std_logic;
-- Integration test enable signal

signal iClrIntErr       : std_logic_vector(7 downto 0);
-- Internal copy of ClrIntErr output

signal NextClrIntErr    : std_logic_vector(7 downto 0);
-- D input of iClrIntErr flip-flop

signal iClrIntTC        : std_logic_vector(7 downto 0);
-- Internal copy of ClrIntTC output

signal NextClrIntTC     : std_logic_vector(7 downto 0);
-- D input of iClrIntTC flip-flop

signal DmacTCClrWrEn    : std_logic;
-- Write enable for DMACIntTCClr

signal DmacErrClrWrEn   : std_logic;
-- Write enable for DMACIntErrClr

signal DmacITCRWrEn     : std_logic;
-- Write enable for DMACTCR

signal DmacSoftBWrEn    : std_logic;
-- Write enable for DMACSoftBReq

signal DmacSoftSWrEn    : std_logic;
-- Write enable for DMACSoftSReq

signal DmacSoftLBWrEn   : std_logic;
-- Write enable for DMACSoftLBReq

signal DmacSoftLSWrEn   : std_logic;
-- Write enable for DMACSoftLSReq

signal DmacCfgWrEn      : std_logic;
-- Write enable for DMACConfig

signal DmacSyncWrEn     : std_logic;
-- Write enable for DMACSync register

signal DmacSlaveState   : std_logic_vector(3 downto 0);
-- DMAC Slave SM's state Flip Flops

signal NextSlaveState   : std_logic_vector(3 downto 0);
-- D input of DmacSlaveState flip-flop

signal iHREADYOUT       : std_logic;
-- Internal copy of iHREADYOUT

signal NextHREADYOUT    : std_logic;
-- D input of iHREADYOUT flip-flop

signal AddrBuff         : std_logic_vector(20 downto 2);
-- Registered version of HADDR

signal NextAddrBuff     : std_logic_vector(20 downto 2);
-- D Input of AddrBuff

signal DMACSoftSReq     : std_logic_vector(15 downto 0);
-- Software DMASREQ Request register

signal NextSoftSReq     : std_logic_vector(15 downto 0);
-- D Input of DMACSoftSReq register

signal DMACSoftBReq     : std_logic_vector(15 downto 0);
-- Software DMABREQ Request register

signal NextSoftBReq     : std_logic_vector(15 downto 0);
-- D Input of DMACSoftBReq register

signal DMACSoftLSReq    : std_logic_vector(15 downto 0);
-- Software DMALSREQ Request register

signal NextSoftLSReq    : std_logic_vector(15 downto 0);
-- D Input of DMACSoftLSReq register

signal DMACSoftLBReq    : std_logic_vector(15 downto 0);
-- Software DMALBREQ Request register

signal NextSoftLBReq    : std_logic_vector(15 downto 0);
-- D Input of DMACSoftLBReq register

signal DMACConfig       : std_logic_vector(3 downto 0);
-- DMAC config register

signal NextDMACConfig   : std_logic_vector(3 downto 0);
-- D Input of DMACConfig register

signal DMACSync         : std_logic_vector(15 downto 0);
-- DMAC request synchronisation control register

signal NextDMACSync     : std_logic_vector(15 downto 0);
-- D Input of DMACSync register

signal DMACTCR          : std_logic_vector(1 downto 0);
-- DMAC Test control register

signal NextDMACTCR      : std_logic_vector(1 downto 0);
-- D Input of DMACTCR register

signal DMACSREQSync     : std_logic_vector(15 downto 0);
-- Double synchronised signal for DMACSREQ

signal DMACBREQSync     : std_logic_vector(15 downto 0);
-- Double synchronised signal for DMACBREQ

signal DMACLSREQSync    : std_logic_vector(15 downto 0);
-- Double synchronised signal for DMACLSREQ

signal DMACLBREQSync    : std_logic_vector(15 downto 0);
-- Double synchronised signal for DMACLBREQ

signal DMACSREQSync1    : std_logic_vector(15 downto 0);
-- First level of synchronised signal for DMACSREQ

signal DMACBREQSync1    : std_logic_vector(15 downto 0);
-- First level of synchronised signal for DMACBREQ

signal DMACLSREQSync1   : std_logic_vector(15 downto 0);
-- First level of synchronised signal for DMACLSREQ

signal DMACLBREQSync1   : std_logic_vector(15 downto 0);
-- First level of synchronised signal for DMACLBREQ

signal ReqConfigWrEn    : std_logic;
-- Write enable for trickbox ReqConfig register

signal iReqConfig       : std_logic_vector(17 downto 0);
-- Internal copy of ReqConfig

signal NextReqCfg       : std_logic_vector(17 downto 0);
-- D-Input of iReqConfig

signal iGrantCount0     : std_logic_vector(31 downto 0);
-- Internal copy of GrantCount

signal NextGntCnt0      : std_logic_vector(31 downto 0);
-- D-Input of iGrantCount0

signal iGrantCount1     : std_logic_vector(31 downto 0);
-- Internal copy of GrantCount

signal NextGntCnt1      : std_logic_vector(31 downto 0);
-- D-Input of iGrantCount1

signal GntCnt0WrEn      : std_logic;
-- Write enable for trickbox GrantCount0 register

signal GntCnt1WrEn      : std_logic;
-- Write enable for trickbox GrantCount1 register

signal DmacTrWrEn       : std_logic;
-- Write enable for Trickbox enable register

signal iDmacTrEn        : std_logic;
-- Internal copy of Trickbox enable

signal NextDmacTrEn     : std_logic;
-- D-Input of iDmacTrEn

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
-- Assigning internal signals to the outputs
-- -----------------------------------------------------------------------------
HRESP            <= iHRESP;
HREADYOUT        <= iHREADYOUT;
DMACEn           <= iDMACEn;
ReqConfig        <= iReqConfig;
GrantCount0      <= iGrantCount0;
GrantCount1      <= iGrantCount1;
DmacTrEn         <= iDmacTrEn;
ClrIntErr        <= iClrIntErr;
ClrIntTC         <= iClrIntTC;
SOFTBREQCh       <= DMACSoftBReq;
SOFTLBREQCh      <= DMACSoftLBReq;
SOFTSREQCh       <= DMACSoftSReq;
SOFTLSREQCh      <= DMACSoftLSReq;

-- -----------------------------------------------------------------------------
-- Synchronising the requests from the peripherals to the HCLK domain
-- -----------------------------------------------------------------------------
p_SyncToHClkSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    DMACSREQSync1    <= (others => '0');
    DMACBREQSync1    <= (others => '0');
    DMACLSREQSync1   <= (others => '0');
    DMACLBREQSync1   <= (others => '0');

    DMACSREQSync     <= (others => '0');
    DMACBREQSync     <= (others => '0');
    DMACLSREQSync    <= (others => '0');
    DMACLBREQSync    <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    DMACSREQSync1    <= DMACSREQ;
    DMACBREQSync1    <= DMACBREQ;
    DMACLSREQSync1   <= DMACLSREQ;
    DMACLBREQSync1   <= DMACLBREQ;

    DMACSREQSync     <= DMACSREQSync1;
    DMACBREQSync     <= DMACBREQSync1;
    DMACLSREQSync    <= DMACLSREQSync1;
    DMACLBREQSync    <= DMACLBREQSync1;
  end if;
end process p_SyncToHClkSeq;

-- -----------------------------------------------------------------------------
-- Muxing to select between Double synchronised and Single Synchronised DMA
-- Requests
-- -----------------------------------------------------------------------------
p_ReqMuxComb : process (DMACSync, DMACSREQSync1, DMACBREQSync1, DMACLSREQSync1,
                        DMACLBREQSync1, DMACSREQSync, DMACBREQSync,
                        DMACLSREQSync, DMACLBREQSync)
begin
  for i in 0 to 15 loop
    if (DMACSync(i) = '1') then
      DMACSREQCh(i)   <= DMACSREQSync1(i);
      DMACBREQCh(i)   <= DMACBREQSync1(i);
      DMACLSREQCh(i)  <= DMACLSREQSync1(i);
      DMACLBREQCh(i)  <= DMACLBREQSync1(i);
    else
      DMACSREQCh(i)   <= DMACSREQSync(i);
      DMACBREQCh(i)   <= DMACBREQSync(i);
      DMACLSREQCh(i)  <= DMACLSREQSync(i);
      DMACLBREQCh(i)  <= DMACLBREQSync(i);
    end if;
  end loop;
end process p_ReqMuxComb;

-- -----------------------------------------------------------------------------
-- Slave state machine registers the data when UUT is accessed, without putting
-- out the response. The SM gives out the response when the trickbox AhbSlave
-- is accessed.
-- -----------------------------------------------------------------------------
p_SlaveSMComb : process (HSELDMAC, HSELDMACTrSlave, HWRITE, HTRANS, HADDR,
                         HSIZE, HREADYIN, DmacSlaveState, AddrBuff, iHRESP,
                         iHREADYOUT)
begin
  NextSlaveState    <= DmacSlaveState;
  NextHRESP         <= iHRESP;
  NextAddrBuff      <= Addrbuff;
  NextHREADYOUT     <= iHREADYOUT;
  case DmacSlaveState is
    when ST_DMAC_SLAVE_IDLE | ST_DMAC_SLAVE_WRITE | ST_DMAC_SLAVE_WRITE_TR =>
      if ((HSELDMAC = '1') and (HREADYIN = '1')) then
        if (HTRANS = '1') then
          if ((HSIZE = WORD) and (HWRITE = '1')) then
            NextSlaveState <= ST_DMAC_SLAVE_WRITE;
            NextAddrBuff   <= HADDR;
          else
            NextSlaveState <= ST_DMAC_SLAVE_IDLE;
          end if;
        else
          NextSlaveState   <= ST_DMAC_SLAVE_IDLE;
        end if;
      elsif ((HSELDMACTrSlave = '1') and (HREADYIN = '1')) then
        if (HTRANS = '1') then
          if ((HSIZE = WORD) and (HWRITE = '1')) then
            NextSlaveState <= ST_DMAC_SLAVE_WRITE_TR;
            NextAddrBuff   <= HADDR;
            NextHRESP      <= OKAY_RESP;
            NextHREADYOUT  <= '1';
          else
            NextSlaveState <= ST_DMAC_SLAVE_ERROR;
            NextHRESP      <= ERROR_RESP;
            NextHREADYOUT  <= '0';
          end if;
        else
          NextSlaveState   <= ST_DMAC_SLAVE_IDLE;
          NextHRESP        <= OKAY_RESP;
          NextHREADYOUT    <= '1';
        end if;
      else
        NextSlaveState <= ST_DMAC_SLAVE_IDLE;
      end if;

    when ST_DMAC_SLAVE_ERROR =>
      NextSlaveState    <= ST_DMAC_SLAVE_IDLE;
      NextHREADYOUT     <= '1';

    when others =>
      null;
  end case;
end process p_SlaveSMComb;

-- -----------------------------------------------------------------------------
-- Clocked Process for DMAC AHB Slave Interface State Machine
-- -----------------------------------------------------------------------------
p_SlaveSMSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DmacSlaveState   <= ST_DMAC_SLAVE_IDLE;
    iHRESP           <= OKAY_RESP;
    AddrBuff         <= (others => '0');
    iHREADYOUT       <= '1';
    iDmacTrEn         <= '1';
  elsif (HCLK'event and HCLK = '1') then
    DmacSlaveState   <= NextSlaveState;
    iHRESP           <= NextHRESP;
    AddrBuff         <= NextAddrBuff;
    iHREADYOUT       <= NextHREADYOUT;
    iDmacTrEn         <= NextDmacTrEn;
  end if;
end process p_SlaveSMSeq;

-- -----------------------------------------------------------------------------
-- Generation of Write Enables for Trickbox Registers
-- -----------------------------------------------------------------------------
p_WriteTrComb : process (DmacSlaveState, AddrBuff)
begin
  ReqConfigWrEn <= '0';
  GntCnt0WrEn   <= '0';
  GntCnt1WrEn   <= '0';
  DmacTrWrEn    <= '0';
  if (DmacSlaveState = ST_DMAC_SLAVE_WRITE_TR) then
    case AddrBuff(20 downto 2) is
      when ADDR_DMACTRREQCFG =>
        ReqConfigWrEn <= '1';

      when ADDR_DMACTRGRANTCNT0 =>
        GntCnt0WrEn <= '1';

      when ADDR_DMACTRGRANTCNT1 =>
        GntCnt1WrEn <= '1';

      when ADDR_DMACTRENB =>
        DmacTrWrEn <= '1';

      when others =>
        null;
    end case;
  end if;
end process p_WriteTrComb;

-- -----------------------------------------------------------------------------
-- Combinitaonal logic for all Trickbox registers.
-- -----------------------------------------------------------------------------
NextReqCfg    <= HWDATA(17 downto 0) when (ReqConfigWrEn = '1')
              else
                 iReqConfig;

NextGntCnt0   <= HWDATA when (GntCnt0WrEn = '1')
              else
                 iGrantCount0;

NextGntCnt1   <= HWDATA when (GntCnt1WrEn = '1')
              else
                 iGrantCount1;

NextDmacTrEn  <= HWDATA(0) when (DmacTrWrEn = '1')
              else
                 iDmacTrEn;

-- -----------------------------------------------------------------------------
-- Generation of Write Enables for Channel Registers
-- -----------------------------------------------------------------------------
p_WriteEnComb : process (DmacSlaveState, AddrBuff, iDmacTrEn)
begin
  DmacTCClrWrEn      <= '0';
  DmacErrClrWrEn     <= '0';

  DmacSoftBWrEn      <= '0';
  DmacSoftLBWrEn     <= '0';
  DmacSoftLSWrEn     <= '0';
  DmacSoftSWrEn      <= '0';
  DmacCfgWrEn        <= '0';
  DmacSyncWrEn       <= '0';

  DmacSrcRegWrEn0    <= '0';
  DmacDstRegWrEn0    <= '0';
  DmacLLIRegWrEn0    <= '0';
  DmacCntlRegWrEn0   <= '0';
  DmacChCnfgWrEn0    <= '0';

  DmacSrcRegWrEn1    <= '0';
  DmacDstRegWrEn1    <= '0';
  DmacLLIRegWrEn1    <= '0';
  DmacCntlRegWrEn1   <= '0';
  DmacChCnfgWrEn1    <= '0';

  DmacSrcRegWrEn2    <= '0';
  DmacDstRegWrEn2    <= '0';
  DmacLLIRegWrEn2    <= '0';
  DmacCntlRegWrEn2   <= '0';
  DmacChCnfgWrEn2    <= '0';

  DmacSrcRegWrEn3    <= '0';
  DmacDstRegWrEn3    <= '0';
  DmacLLIRegWrEn3    <= '0';
  DmacCntlRegWrEn3   <= '0';
  DmacChCnfgWrEn3    <= '0';

  DmacSrcRegWrEn4    <= '0';
  DmacDstRegWrEn4    <= '0';
  DmacLLIRegWrEn4    <= '0';
  DmacCntlRegWrEn4   <= '0';
  DmacChCnfgWrEn4    <= '0';

  DmacSrcRegWrEn5    <= '0';
  DmacDstRegWrEn5    <= '0';
  DmacLLIRegWrEn5    <= '0';
  DmacCntlRegWrEn5   <= '0';
  DmacChCnfgWrEn5    <= '0';

  DmacSrcRegWrEn6    <= '0';
  DmacDstRegWrEn6    <= '0';
  DmacLLIRegWrEn6    <= '0';
  DmacCntlRegWrEn6   <= '0';
  DmacChCnfgWrEn6    <= '0';

  DmacSrcRegWrEn7    <= '0';
  DmacDstRegWrEn7    <= '0';
  DmacLLIRegWrEn7    <= '0';
  DmacCntlRegWrEn7   <= '0';
  DmacChCnfgWrEn7    <= '0';

  DmacITCRWrEn       <= '0';

  if ((DmacSlaveState = ST_DMAC_SLAVE_WRITE) and (iDmacTrEn = '1')) then
    case AddrBuff(11 downto 2) is
      when ADDR_DMACTCCLR =>
        DmacTCClrWrEn    <= '1';
      when ADDR_DMACERRCLR =>
        DmacErrClrWrEn   <= '1';
      when ADDR_DMACSOFTBREQ =>
        DmacSoftBWrEn    <= '1';
      when ADDR_DMACSOFTSREQ =>
        DmacSoftSWrEn    <= '1';
      when ADDR_DMACSOFTLBREQ =>
        DmacSoftLBWrEn   <= '1';
      when ADDR_DMACSOFTLSREQ =>
        DmacSoftLSWrEn   <= '1';
      when ADDR_DMACCONFIG =>
        DmacCfgWrEn      <= '1';
      when ADDR_DMACSYNC =>
        DmacSyncWrEn     <= '1';
      when ADDR_DMACC0SRCADDR =>
        DmacSrcRegWrEn0  <= '1';
      when ADDR_DMACC0DSTADDR =>
        DmacDstRegWrEn0  <= '1';
      when ADDR_DMACC0LLIReg =>
        DmacLLIRegWrEn0  <= '1';
      when ADDR_DMACC0CONTROL =>
        DmacCntlRegWrEn0 <= '1';
      when ADDR_DMACC0CONFIG =>
        DmacChCnfgWrEn0  <= '1';
      when ADDR_DMACC1SRCADDR =>
        DmacSrcRegWrEn1  <= '1';
      when ADDR_DMACC1DSTADDR =>
        DmacDstRegWrEn1  <= '1';
      when ADDR_DMACC1LLIReg =>
        DmacLLIRegWrEn1  <= '1';
      when ADDR_DMACC1CONTROL =>
        DmacCntlRegWrEn1 <= '1';
      when ADDR_DMACC1CONFIG =>
        DmacChCnfgWrEn1  <= '1';
      when ADDR_DMACC2SRCADDR =>
        DmacSrcRegWrEn2  <= '1';
      when ADDR_DMACC2DSTADDR =>
        DmacDstRegWrEn2  <= '1';
      when ADDR_DMACC2LLIReg =>
        DmacLLIRegWrEn2  <= '1';
      when ADDR_DMACC2CONTROL =>
        DmacCntlRegWrEn2 <= '1';
      when ADDR_DMACC2CONFIG =>
        DmacChCnfgWrEn2  <= '1';
      when ADDR_DMACC3SRCADDR =>
        DmacSrcRegWrEn3  <= '1';
      when ADDR_DMACC3DSTADDR =>
        DmacDstRegWrEn3  <= '1';
      when ADDR_DMACC3LLIReg =>
        DmacLLIRegWrEn3  <= '1';
      when ADDR_DMACC3CONTROL =>
        DmacCntlRegWrEn3 <= '1';
      when ADDR_DMACC3CONFIG =>
        DmacChCnfgWrEn3  <= '1';
      when ADDR_DMACC4SRCADDR =>
        DmacSrcRegWrEn4  <= '1';
      when ADDR_DMACC4DSTADDR =>
        DmacDstRegWrEn4  <= '1';
      when ADDR_DMACC4LLIReg =>
        DmacLLIRegWrEn4  <= '1';
      when ADDR_DMACC4CONTROL =>
        DmacCntlRegWrEn4 <= '1';
      when ADDR_DMACC4CONFIG =>
        DmacChCnfgWrEn4  <= '1';
      when ADDR_DMACC5SRCADDR =>
        DmacSrcRegWrEn5  <= '1';
      when ADDR_DMACC5DSTADDR =>
        DmacDstRegWrEn5  <= '1';
      when ADDR_DMACC5LLIReg =>
        DmacLLIRegWrEn5  <= '1';
      when ADDR_DMACC5CONTROL =>
        DmacCntlRegWrEn5 <= '1';
      when ADDR_DMACC5CONFIG =>
        DmacChCnfgWrEn5  <= '1';
      when ADDR_DMACC6SRCADDR =>
        DmacSrcRegWrEn6  <= '1';
      when ADDR_DMACC6DSTADDR =>
        DmacDstRegWrEn6  <= '1';
      when ADDR_DMACC6LLIReg =>
        DmacLLIRegWrEn6  <= '1';
      when ADDR_DMACC6CONTROL =>
        DmacCntlRegWrEn6 <= '1';
      when ADDR_DMACC6CONFIG =>
        DmacChCnfgWrEn6  <= '1';
      when ADDR_DMACC7SRCADDR =>
        DmacSrcRegWrEn7  <= '1';
      when ADDR_DMACC7DSTADDR =>
        DmacDstRegWrEn7  <= '1';
      when ADDR_DMACC7LLIReg =>
        DmacLLIRegWrEn7  <= '1';
      when ADDR_DMACC7CONTROL =>
        DmacCntlRegWrEn7 <= '1';
      when ADDR_DMACC7CONFIG =>
        DmacChCnfgWrEn7  <= '1';
      when ADDR_DMACTCR =>
        DmacITCRWrEn     <= '1';
      when others =>
        null;
    end case;
  end if;
end process p_WriteEnComb;

-- -----------------------------------------------------------------------------
-- Assign the DMACTCR register bits to the corresponding signals
-- -----------------------------------------------------------------------------
ITEN <= DMACTCR(0);

-- -----------------------------------------------------------------------------
-- Assign the DMACConfig register bits to the corresponding signals
-- -----------------------------------------------------------------------------
iDMACEn          <= DMACConfig(0) and (not ITEN);
MasterEndian1    <= DMACConfig(1);
MasterEndian2    <= DMACConfig(2);

-- -----------------------------------------------------------------------------
-- Combinational logic for all writeable registers.
-- -----------------------------------------------------------------------------
NextDMACConfig <= HWDATA(3 downto 0) when (DmacCfgWrEn = '1')
               else
                  DMACConfig;

NextDMACSync   <= HWDATA(15 downto 0) when (DmacSyncWrEn = '1')
               else
                  DMACSync;

NextDMACTCR    <= HWDATA(1 downto 0) when (DmacITCRWrEn = '1')
               else
                  DMACTCR;

iClrIntErr  <= HWDATA(7 downto 0) when (DmacErrClrWrEn = '1')
            else
               (others => '0');

iClrIntTC   <= HWDATA(7 downto 0) when (DmacTCClrWrEn = '1')
            else
               (others => '0');

-- -----------------------------------------------------------------------------
-- Write logic for Soft Request registers
-- -----------------------------------------------------------------------------
p_SoftReqWrComb : process (DmacClr, DMACSoftBReq, HWDATA, DmacSoftBWrEn,
                           iDMACEn, DMACSoftLBReq, DMACSoftSReq,
                           DMACSoftLSReq, DmacSoftSWrEn, DmacSoftLBWrEn,
                           DmacSoftLSWrEn, SoftClr)
begin
  NextSoftBReq     <= DMACSoftBReq;
  NextSoftLBReq    <= DMACSoftLBReq;
  NextSoftSReq     <= DMACSoftSReq;
  NextSoftLSReq    <= DMACSoftLSReq;
  for i in 0 to 15 loop
    if ((DmacClr(i) = '1') or (iDMACEn = '0') or (SoftClr(i) = '1')) then
      NextSoftBReq(i)   <= '0';
      NextSoftLBReq(i)  <= '0';
      NextSoftSReq(i)   <= '0';
      NextSoftLSReq(i)  <= '0';
    elsif (DmacSoftBWrEn = '1') then
      if (HWDATA(i) = '1') then
        NextSoftBReq(i)  <= '1';
      end if;
    elsif (DmacSoftSWrEn = '1') then
      if (HWDATA(i) = '1') then
        NextSoftSReq(i)  <= '1';
      end if;
    elsif (DmacSoftLBWrEn = '1') then
      if (HWDATA(i) = '1') then
        NextSoftLBReq(i) <= '1';
      end if;
    elsif (DmacSoftLSWrEn = '1') then
      if (HWDATA(i) = '1') then
        NextSoftLSReq(i) <= '1';
      end if;
    end if;
  end loop;

end process p_SoftReqWrComb;

-- -----------------------------------------------------------------------------
-- Sequential process for writeable registers in this module.
-- -----------------------------------------------------------------------------
p_SoftReqWrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    DMACSoftBReq      <= (others => '0');
    DMACSoftLBReq     <= (others => '0');
    DMACSoftSReq      <= (others => '0');
    DMACSoftLSReq     <= (others => '0');
    DMACConfig        <= (others => '0');
    DMACSync          <= (others => '0');
    DMACTCR           <= (others => '0');
    iReqConfig        <= (others => '0');
    iGrantCount0      <= (others => '0');
    iGrantCount1      <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    DMACSoftBReq      <= NextSoftBReq;
    DMACSoftLBReq     <= NextSoftLBReq;
    DMACSoftSReq      <= NextSoftSReq;
    DMACSoftLSReq     <= NextSoftLSReq;
    DMACConfig        <= NextDMACConfig;
    DMACSync          <= NextDMACSync;
    DMACTCR           <= NextDMACTCR;
    iReqConfig        <= NextReqCfg;
    iGrantCount0      <= NextGntCnt0;
    iGrantCount1      <= NextGntCnt1;
  end if;
end process p_SoftReqWrSeq;

end behavioural;

-- --================================== End ==================================--
