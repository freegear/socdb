-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrApbif.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block acts as an interface between the APB Bus and the
--           MMCI Trickbox.Mainly, it interprets the APB Address and
--           issues a write decode to respective register.It also
--           maintains a latched Address/write data till the device is
--           selected again for transfer.It also multiplexes the
--           various register reads onto the APB read data bus.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.MmciTrPackage.all;

-- -----------------------------------------------------------------------------

entity MmciTrApbif is
  port (
-- Inputs
        PCLK             : in    std_logic; -- APB Bus Clock
        PRESETn          : in    std_logic; -- APB Bus Reset
        PSEL             : in    std_logic; -- APB MMCI select
        PSELT            : in    std_logic; -- APB Trickbox select
        PWRITE           : in    std_logic; -- APB Peripheral Write
        PENABLE          : in    std_logic; -- APB Peripheral enable
        MMCITBSIGSTAT    : in    std_logic_vector(5 downto 0);
                                            -- Signal Status Reg
        MMCITBRxdCInd    : in    std_logic_vector(5 downto 0);
                                            -- Cmd Index recd from MMCI
        MMCITBRxdCArg    : in    std_logic_vector(31 downto 0);
                                            -- Cmd Arg recd from MMCI
        RFF              : in    std_logic; -- Rx FIFO Full
        TFF              : in    std_logic; -- Tx FIFO Full
        RFE              : in    std_logic; -- Rx FIFO Empty
        TFE              : in    std_logic; -- Tx FIFO Empty
        TFHE             : in    std_logic; -- Tx FIFO Half Empty
        RFHF             : in    std_logic; -- Rx FIFO Half Full
        PCLKOn           : in    std_logic; -- Status flag for PCLK
                                            -- enabled internally
        MCLKOn           : in    std_logic; -- Status flag for MCLK
                                            -- enabled internally
        RxFRdData        : in    std_logic_vector(32 downto 0);
                                            -- RxFIFO read data
        CmdCrcErrStat    : in    std_logic; -- Cmd Crc error status
        PADDR            : in    std_logic_vector(11 downto 2);
                                            -- APB Addr
        PWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Write databus
-- Outputs
        RxFRdPtrInc      : out   std_logic; -- RxFIFO read ptr Incr
        MMCIPowerWr      : out   std_logic; -- Wr enable for MMCIPower
        MMCIClockWr      : out   std_logic; -- Wr enable for MMCIClock
        MMCICommandWr    : out   std_logic; -- Wr enable for MMCIComand
        MMCIDataLenWr    : out   std_logic; -- WrEn for MMCIDatalen
        MMCIDataCntlWr   : out   std_logic; -- WrEn for MMCIDataCntl
        MMCITBCmdRespWr  : out   std_logic; -- WrEn for MMCITBCmdResp
        MMCITBResp0Wr    : out   std_logic; -- WrEn for MMCITBResp0
        MMCITBResp1Wr    : out   std_logic; -- WrEn for MMCITBResp1
        MMCITBResp2Wr    : out   std_logic; -- WrEn for MMCITBResp2
        MMCITBResp3Wr    : out   std_logic; -- WrEn for MMCITBResp3
        MMCITBDtTimWr    : out   std_logic; -- WrEn for MMCITBDataTimer
        MMCITBMCLKWr     : out   std_logic; -- WrEn for MMCITBMCLKPd
        MMCITBCntlWr     : out   std_logic; -- WrEn for MMCITBCntl
        MMCITBReTimWr    : out   std_logic; -- WrEn for MMCITBRespTimer
        MMCITBTokTimWr   : out   std_logic; -- WrEn for MMCITBTkTimer
        MMCITBBsyTimWr   : out   std_logic; -- WrEn for MMCITBBusyTimer
        MMCITBPCDisWr    : out   std_logic; -- WrEn for MMCITBPCDisable
        MMCITBStTimWr    : out   std_logic; -- WrEn for MMCITBStTimeout
        MMCITBCLKRSTWr   : out   std_logic; -- WrEn for MMCITBCkRstCntl
        MMCITBTXFWr      : out   std_logic; -- WrEn for MMCITBFIFOReg
        PRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Databus
        PWDATAIn         : out   std_logic_vector(31 downto 0)
                                            -- Int PWDATA
       );
end MmciTrApbif;

-- -----------------------------------------------------------------------------
--
--                                 MmciTrApbif
--                                 ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This module decodes APB accesses and generates the write strobes to
-- the appropriate registers. This module also contains the output data
-- multiplexer and the output register that form the read interface. The
-- internal databus, for the MMCITrickbox, PWDATAIn[15:0], is also
-- generated in this module, by gating the input data bus, PWDATA[15:0]
-- with PSEL and PWRITE.
--
-- -----------------------------------------------------------------------------
--                    MMCITB Register Map
-- -----------------------------------------------------------------------------
-- Offset    Read (Width)     Write (Width)       Description
-- -----------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------

-- --=============================== ARCHITECTURE ============================--

architecture behavioural of MmciTrApbif is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant ZEROFILL         : std_logic_vector(31 downto 0)
                          := "00000000000000000000000000000000";
-- Zero Fill for reads to return zeros in unused bit positions

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal GatedPA          : std_logic_vector(11 downto 2);
-- Gate PA with PSEL to save power

-- -----------------------------------------------------------------------------
-- Read Decodes for Register reads
-- -----------------------------------------------------------------------------
signal MMCITBSIGSTATRd  : std_logic;
-- MMCITBSIGSTAT Read

signal MMCITBRxdCIndRd  : std_logic;
-- MMCITBRxdCInd Read

signal MMCITBRxdCArgRd  : std_logic;
-- MMCITBRxdCArg Read

signal MMCIFIFORegRd    : std_logic;
-- MMCITBFIFOReg Read

signal MMCICrcErrStatRd : std_logic;
-- MMCITBCrcErrStat Read

signal MMCIStatusRd     : std_logic;
-- MMCITBFifoStat Read

signal MMCITBStatus     : std_logic_vector(7 downto 0);
-- MMCITB FIFO status register

signal NextPRDATA       : std_logic_vector(31 downto 0);
-- D-input of PRDATA output register

signal WrEn             : std_logic;
-- Write enable signal common to all addresses in the APB interface

signal RdEn             : std_logic;
-- Read enable signal common to all addresses in the APB interface

signal MMCITBCrcErrStat : std_logic_vector(1 downto 0);
-- Register for storing the Crc error status

signal DataCrcErrStat   : std_logic;
-- Error status of Data Crc

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
-- Write Interface
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Latch the data bus and address bus when the device is selected.
-- -----------------------------------------------------------------------------
GatedPA        <= PADDR when ((PSEL = '1') or (PSELT = '1'))
               else
                  (others => '0');

PWDATAIn       <= PWDATA when (((PSEL = '1') or (PSELT = '1')) and
                              (PWRITE = '1'))
               else
                  (others  => '0');

WrEn           <= (PENABLE and PSEL and PWRITE)
               or (PENABLE and PSELT and PWRITE);


-- -----------------------------------------------------------------------------
--  Register Write Decodes
-- -----------------------------------------------------------------------------

-- MMCIPower Reg Write
MMCIPowerWr        <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIPOWER)
                               and (PSEL = '1'))
                  else
                     '0';
-- MMCIClock Reg Write
MMCIClockWr        <= '1' when (WrEn = '1' and (GatedPA = PA_MMCICLOCK)
                               and (PSEL = '1'))
                  else
                     '0';
-- MMCICommand Reg Write
MMCICommandWr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCICMD)
                               and (PSEL = '1'))
                  else
                     '0';

-- MMCIDataLength Reg Write
MMCIDataLenWr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIDATALEN)
                               and (PSEL = '1'))
                  else
                     '0';

-- MMCIDataCntl Reg Write
MMCIDataCntlWr     <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIDATACNTL)
                               and (PSEL = '1'))
                  else
                     '0';

-- MMCITBCmdResponse Reg Write
MMCITBCmdRespWr    <= '1' when (WrEn = '1' and (GatedPA = PA_MMCICMDRESP)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBResponse0 Reg Write
MMCITBResp0Wr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIRESP0)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBResponse1 Reg Write
MMCITBResp1Wr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIRESP1)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBResponse2 Reg Write
MMCITBResp2Wr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIRESP2)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBResponse3 Reg Write
MMCITBResp3Wr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIRESP3)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBDataTimer Reg Write
MMCITBDtTimWr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIDTIMER)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBMCLKPeriod Reg Write
MMCITBMCLKWr       <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIMCLK)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBControl Reg Write
MMCITBCntlWr       <= '1' when (WrEn = '1' and (GatedPA = PA_MMCICONTROL)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBRespTimer Reg Write
MMCITBReTimWr      <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIRETIMER)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBTokenTimer Reg Write
MMCITBTokTimWr     <= '1' when (WrEn = '1' and (GatedPA = PA_MMCITOKTIMER)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBBusyTimer Reg Write
MMCITBBsyTimWr     <= '1' when (WrEn = '1' and (GatedPA = PA_MMCIBSYTIMER)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBPCDisable Reg Write
MMCITBPCDisWr      <= '1' when (WrEn = '1' and
                              (GatedPA = PA_MMCIPCDISABLE) and
                              (PSELT = '1'))
                  else
                     '0';

-- MMCITBStTimeout Reg Write
MMCITBStTimWr      <= '1' when (WrEn = '1' and
                              (GatedPA = PA_MMCISTTIMEOUT) and
                              (PSELT = '1'))
                  else
                     '0';

-- MMCITBCLKRSTCntl Reg Write
MMCITBCLKRSTWr     <= '1' when (WrEn = '1' and (GatedPA = PA_MMCICLKRST)
                               and (PSELT = '1'))
                  else
                     '0';

-- MMCITBFIFOReg Reg Write
MMCITBTXFWr        <= '1' when (WrEn = '1' and (GatedPA = PA_MMCITXFIFO)
                               and (PSELT = '1'))
                  else
                     '0';

-- -----------------------------------------------------------------------------
-- Read Interface
-- -----------------------------------------------------------------------------
RdEn <= PSELT and (not PWRITE) and (not PENABLE) and (not PSEL);

-- -----------------------------------------------------------------------------
-- Normal mode Register Read Decodes
-- -----------------------------------------------------------------------------

-- MMCITBSIGSTAT Read
MMCITBSIGSTATRd      <= '1' when ((RdEn = '1') and
                                (GatedPA = PA_MMCISIGSTAT))
                    else
                       '0';

-- MMCITBRxdCInd Read
MMCITBRxdCIndRd      <= '1' when ((RdEn = '1') and
                                (GatedPA = PA_MMCITBCMDIND))
                    else
                       '0';

-- MMCITBRxdCArg Read
MMCITBRxdCArgRd      <= '1' when ((RdEn = '1') and
                                (GatedPA = PA_MMCITBCMDARG))
                    else
                       '0';

-- MMCITBFIFOReg Read
MMCIFIFORegRd        <= '1' when ((RdEn = '1') and
                                (GatedPA = PA_MMCITBRXFIFO))
                    else
                       '0';

-- MMCITBCrcErrStat Read
MMCICrcErrStatRd     <= '1' when ((RdEn = '1') and
                                (GatedPA = PA_MMCITBCRCSTAT))
                    else
                       '0';

-- MMCITBStatus Read
MMCIStatusRd         <= '1' when ((RdEn = '1') and
                                (GatedPA = PA_MMCITBFIFOSTAT))
                    else
                       '0';
-- -----------------------------------------------------------------------------
-- Increment the Read pointer in the Receive FIFO after every read from
-- the Receive FIFO i.e. after every read from the MMCITBFIFOReg Register
-- -----------------------------------------------------------------------------
RxFRdPtrInc       <= '1' when ((PENABLE = '1') and (PSELT = '1') and
                               (PWRITE = '0') and
                               (GatedPA = PA_MMCITBRXFIFO))
                  else
                     '0';
-- -----------------------------------------------------------------------------
-- Assign individual FIFO status bits to MMCITBFifoStatus
-- -----------------------------------------------------------------------------
MMCITBStatus       <= (MCLKOn & PCLKOn & RFHF & RFF & RFE & TFHE & TFF &
                      TFE);

-- -----------------------------------------------------------------------------
-- Assign individual CRC status bits to MMCITBCrcErrStat
-- -----------------------------------------------------------------------------
MMCITBCrcErrStat   <= (DataCrcErrStat & CmdCrcErrStat);

-- -----------------------------------------------------------------------------
-- Output Mux.
-- When the peripheral is not being accessed, '0's are driven on the
-- Read Databus (PRDATA) so as not to place any restrictions on the
-- method of external bus connection.The external data buses of the
-- peripherals on the APB may then be connected to the ASB-to-APB bridge
-- using Muxed or ORed bus connection method.
-- -----------------------------------------------------------------------------
NextPRDATA <= ZEROFILL(31 downto 6) & MMCITBSIGSTAT
                                     when (MMCITBSIGSTATRd = '1')
           else
              ZEROFILL(31 downto 6) & MMCITBRxdCInd
                                     when (MMCITBRxdCIndRd = '1')
           else
              MMCITBRxdCArg
                                     when (MMCITBRxdCArgRd = '1')
           else
              RxFRdData(31 downto 0)
                                     when (MMCIFIFORegRd = '1')
           else
              ZEROFILL(31 downto 2) & MMCITBCrcErrStat
                                     when (MMCICrcErrStatRd = '1')
           else
              ZEROFILL(31 downto 8) & MMCITBStatus
                                     when (MMCIStatusRd = '1')
           else
              ZEROFILL;

-- -----------------------------------------------------------------------------
-- Data crc error status is the MSB of the data read from FIFO and is
-- loaded into MMCITBCrcErrStat Register.
-- -----------------------------------------------------------------------------
p_DataCrcErrStat : process (MMCIFIFORegRd)
begin
  if (MMCIFIFORegRd = '1') then
    DataCrcErrStat <= RxFRdData(32);
  end if;
end process p_DataCrcErrStat;

-- -----------------------------------------------------------------------------
-- Output Data register.
-- -----------------------------------------------------------------------------
p_PRDATASeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    PRDATA  <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    PRDATA  <= NextPRDATA;
  end if;
end process p_PRDATASeq;

end behavioural;

-- --================================== End ==================================--
