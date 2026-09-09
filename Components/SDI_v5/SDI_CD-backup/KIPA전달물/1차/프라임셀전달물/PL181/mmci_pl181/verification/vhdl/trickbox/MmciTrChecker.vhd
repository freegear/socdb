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
-- File Name              : MmciTrChecker.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module maintains registers which have been
--           loaded in the PCLK domain and syncd to MMCICLK
--           domain. All relevant signals, which are part of the
--           register fields, are driven from this model.This module
--           also contains protocol checkers for various violations
--           of MMCI protocols.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrChecker is
  port (
-- Inputs
        MMCICLK          : in    std_logic; -- Main MMCI clock
        nMMCIRST         : in    std_logic; -- MMCI reset
        MMCIINTR0        : in    std_logic; -- Intr 0 Request from MMCI
        MMCIINTR1        : in    std_logic; -- Intr 1 Request from MMCI
        MMCIDMASREQ      : in    std_logic; -- DMA Single Req from MMCI
        MMCIDMABREQ      : in    std_logic; -- DMA Burst Req from MMCI
        MMCIDMALSREQ     : in    std_logic; -- DMA last single Req of
                                            -- MMCI
        MMCIDMALBREQ     : in    std_logic; -- DMA last Burst Req from
                                            -- MMCI
        MMCIPWR          : in    std_logic; -- Indication of Pwr Phase
        MMCIVDD          : in    std_logic_vector(3 downto 0);
                                            -- Output voltage level
        MMCIROD          : in    std_logic; -- Open drain resistor En
        MMCIPower        : in    std_logic_vector(7 downto 0);
                                            -- 2 stage MMCIPower buffer
        MMCIClock        : in    std_logic_vector(10 downto 0);
                                            -- 2 stage MMCIClock buffer
        MMCICommand      : in    std_logic_vector(10 downto 0);
                                            -- 2 stg MMCICommand buffer
        MMCIDataLength   : in    std_logic_vector(15 downto 0);
                                            -- 2 stg MMCIDataLen buffer
        MMCIDataCntl     : in    std_logic_vector(7 downto 0);
                                            -- 2 stg MMCIDataCntl buffer
        MMCITBCntl       : in    std_logic_vector(13 downto 0);
                                            -- 2 stg MMCITBCtrl buffer
        MMCITBMCLKPeriod : in    std_logic_vector(31 downto 0);
                                            -- Gives the MCLK Period
        DataCnt          : in    std_logic_vector(15 downto 0);
                                            -- Counter based on DtTimer
        BitCnt           : in    std_logic_vector(2 downto 0);
                                            -- Counter to count
                                            -- each bit Txd/Rxd
        MMCITBReTimWr    : in    std_logic; -- WrEn for MMCITBRespTimer
        MMCITBDtTimWr    : in    std_logic; -- WrEn for MMCITBDataTimer
        MMCITBTokTimWr   : in    std_logic; -- WrEn for MMCITBTkenTimer
        MMCITBBsyTimWr   : in    std_logic; -- WrEn for MMCITBBusyTimer
        MMCITBPCDisWr    : in    std_logic; -- WrEn for MMCITBPCDisable
        MMCITBStTimWr    : in    std_logic; -- WrEn for MMCITBStTimeout
        MPUpdateSync     : in    std_logic; -- Updt sig for MMCIPower
        MCUpdateSync     : in    std_logic; -- Updt sig for MMCIClock
        MCMUpdateSync    : in    std_logic; -- Updt sig for MMCICommand
        MDLUpdateSync    : in    std_logic; -- Updt sig for MMCIDataLen
        MDCUpdateSync    : in    std_logic; -- Updt sig for MMCIDataCntl
        MTBCUpdateSync   : in    std_logic; -- Updt sig for MMCITBCntl
        TokenSent        : in    std_logic; -- Qualifies token bits
        BlkEnd           : in    std_logic; -- Indicates the end of blk
        PWDATAIn         : in    std_logic_vector(31 downto 0);
                                            -- APB Write Data Bus
        MMCICMD          : in    std_logic; -- Serial Command line
        MMCIDAT          : in    std_logic; -- Serial Data lines
-- Outputs
        MMCITBSIGSTAT    : out   std_logic_vector(5 downto 0);
                                            -- Stg1 buffer o/p of
                                            -- MMCISIGSTAT
        ResponseBits     : out   std_logic_vector(1 downto 0);
                                            -- Reflects the Resp bits
                                            -- in Cmd Reg
        CmdEnable        : out   std_logic; -- Command Path enable bit
        DataEn           : out   std_logic; -- Data Path enable bit
        DataDirection    : out   std_logic; -- Data direction
        DataMode         : out   std_logic; -- 0-Streammode,
                                            -- 1-Blockmode
        DataLength       : out   std_logic_vector(15 downto 0);
                                            -- MMCIDataLen Reg Syncd
        Blocklen         : out   std_logic_vector(3 downto 0);
                                            -- Block size from DataCntl
        MDCStg2WrEn      : out   std_logic; -- Wr enable for MDC Reg
        CmdCrcErr        : out   std_logic; -- Indicates to force error
                                            -- on command crc
        DataCrcErr       : out   std_logic; -- Indicates to force error
                                            -- on data crc
        TokenErrBit      : out   std_logic; -- Indicates to force error
                                            -- on token issued
        CmdRespCnt       : out   std_logic_vector(31 downto 0);
                                            -- Counts MMCITBRespTimer
        DataTimeCnt      : out   std_logic_vector(31 downto 0);
                                            -- Counts MMCITBDataTimer
        TokenTimeCnt     : out   std_logic_vector(15 downto 0);
                                            -- Counts MMCITBTokenTimer
        BsyTimeCnt       : out   std_logic_vector(15 downto 0);
                                            -- Counts MMCITBBusyTimer
        MMCIDMACLR       : out   std_logic; -- Signal to issue DMAClear
        FifoClear        : out   std_logic; -- Clear signal for FIFO
        SendResponse     : out   std_logic; -- Qualifies response txn
        RxCommand        : out   std_logic  -- Qualifies command rx
       );
end MmciTrChecker;

-- -----------------------------------------------------------------------------
--
--                                MmciTrChecker
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This module drives the fields of registers, that are needed in
-- other modules.This module also performs the various protocol checks
-- associated with the MMCI.
--
-- -----------------------------------------------------------------------------

-- --======================= ARCHITECTURE ============================--

architecture behavioural of MmciTrChecker is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

constant OFFSET           : time      := 3.1 ns;
-- Margin for the various signals

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal DelMPUpdate      : std_logic;
-- Delayed MPUpdateSync signal

signal DelMCUpdate      : std_logic;
-- Delayed MCUpdateSync signal

signal DelMCMUpdate     : std_logic;
-- Delayed MCMUpdateSync signal

signal DelMDLUpdate     : std_logic;
-- Delayed MDLUpdateSync signal

signal DelMDCUpdate     : std_logic;
-- Delayed MDCUpdateSync signal

signal DelMTBCUpdate    : std_logic;
-- Delayed MTBCUpdateSync signal

signal MPStg2WrEn       : std_logic;
-- Load signal for the second stage buffer of MMCIPower

signal MCStg2WrEn       : std_logic;
-- Load signal for the second stage buffer of MMCIClock

signal MCMStg2WrEn      : std_logic;
-- Load signal for the second stage buffer of MMCICommand

signal MDLStg2WrEn      : std_logic;
-- Load signal for the second stage buffer of MMCIDataLength

signal iMDCStg2WrEn     : std_logic;
-- Load signal for the second stage buffer of MMCIDataCntl

signal MTBCStg2WrEn     : std_logic;
-- Load signal for the second stage buffer of MMCITBCntl

signal MP               : std_logic_vector(7 downto 0);
-- Second stage buffer for MMCIPower Register

signal MC               : std_logic_vector(10 downto 0);
-- Second stage buffer for MMCIClock Register

signal MCM              : std_logic_vector(10 downto 0);
-- Second stage buffer for MMCICommand Register

signal MDL              : std_logic_vector(15 downto 0);
-- Second stage buffer for MMCIDataLength Register

signal MDC              : std_logic_vector(7 downto 0);
-- Second stage buffer for MMCIDataCntl Register

signal MTBC             : std_logic_vector(13 downto 0);
-- Second stage buffer for MMCITBCntl Register

signal NextMP           : std_logic_vector(7 downto 0);
-- D-input of MP

signal NextMC           : std_logic_vector(10 downto 0);
-- D-input of MC

signal NextMCM          : std_logic_vector(10 downto 0);
-- D-input of MCM

signal NextMDL          : std_logic_vector(15 downto 0);
-- D-input of MDL

signal NextMDC          : std_logic_vector(7 downto 0);
-- D-input of MDC

signal NextMTBC         : std_logic_vector(13 downto 0);
-- D-input of MTBC

signal MMCITBRespTimer  : std_logic_vector(31 downto 0);
-- Indicates the delay before the start bit of a Cmd Response

signal MMCITBDataTimer  : std_logic_vector(31 downto 0);
-- Indicates the delay before the start bit of Data

signal MMCITBTokenTimer : std_logic_vector(15 downto 0);
-- Indicates the delay before the start bit of Token

signal MMCITBBusyTimer  : std_logic_vector(15 downto 0);
-- Indicates the Busy duration

signal MMCITBStTimeout  : std_logic_vector(31 downto 0);
-- Gives the maximum delay that can exist before MMCI issues a St Bit

signal MMCITBPCDisable  : std_logic_vector(16 downto 0);
-- Controls disabling of Protocol checks

signal iCmdRespCnt      : std_logic_vector(31 downto 0);
-- local copy of the CmdRespCnt counter output

signal iDataTimeCnt     : std_logic_vector(31 downto 0);
-- local copy of the DataTimeCnt counter output

signal iTokenTimeCnt    : std_logic_vector(15 downto 0);
-- local copy of the TokenTimeCnt counter output

signal iBsyTimeCnt      : std_logic_vector(15 downto 0);
-- local copy of the BsyTimeCnt counter output

signal iDataDirection   : std_logic;
-- local copy of DataDirection output

signal iDataEn          : std_logic;
-- local copy of DataEn output

signal iDataMode        : std_logic;
-- local copy of DataMode output

signal iResponseBits    : std_logic_vector(1 downto 0);
-- local copy of ResponseBits output

signal iCmdEnable       : std_logic;
-- local copy of CmdEnable

signal DelDataEn        : std_logic;
-- Delayed version of DatEn

signal DelTokenSent     : std_logic;
-- Delayed version of TokenSent

signal Count0           : std_logic;
-- Internal signal to invoke CmdRespCnt

signal Count1           : std_logic;
-- Internal signal to invoke DataTimeCnt

signal Count2           : std_logic;
-- Internal signal to invoke TokenTimeCnt

signal DelCount2        : std_logic;
-- Delayed Count2

signal Count3           : std_logic;
-- Internal signal to invoke BsyTimeCnt

signal BusInactive      : std_logic;
-- Indicates that Bus, both Cmd & Data is Inactive for more than 8 clks

signal CmdBusInAc       : std_logic;
-- Indicates that CmdBus is Inactive for more than 8 clks

signal DataBusInAc      : std_logic;
-- Indicates that DataBus is Inactive for more than 8 clks

signal CmdlineChk       : std_logic;
-- Indicates when to start checking Cmd Bus inactiveness

signal DatalineChk      : std_logic;
-- Indicates when to start checking Data Bus inactiveness

signal CmdClkCnt        : std_logic_vector(2 downto 0);
-- Indicates when to declare Cmd Bus to be inactive

signal DataClkCnt       : std_logic_vector(2 downto 0);
-- Indicates when to declare Data Bus to be inactive

signal CountSt          : std_logic;
-- Indicates the Window in which the Nrc and Ncc should be monitored

signal MMCICLKREFVALUE  : integer   := 0;
-- Used to compute the period of MMCICLK

signal CLKDIV           : integer   := 0;
-- Used to compute the period of MMCICLK

signal MMCICLKFallEdge  : time      := 0 ns;
-- Time at the Falling edge of MMCICLK

signal MMCICLKRiseEdge  : time      := 0 ns;
-- Time at the Rising edge of MMCICLK

signal MMCICLKFlag1     : std_logic := '0';
-- Flag for the high phase of MMCICLK

signal MMCICLKFlag2     : std_logic := '0';
-- Flag for the low phase of MMCICLK

signal EndBitChk        : std_logic;
-- Signal to qualify end bit protocol check in pending mode

signal BlockBit         : std_logic := '1';
-- This bit qualifies a bit of a block

signal BlockErr         : std_logic := '0';
-- Indicates whether any error has occured in a block's start or end bit

signal CmdOver          : std_logic;
-- Indicates that Cmd Reception is over

signal NextRxCommand    : std_logic;
-- D-Input to RxCommand;

signal CmdBit           : std_logic;
-- Command Bit received

signal DelCmdBit        : std_logic;
-- Delayed version of Command Bit received

signal CmdSBit          : std_logic;
-- Qualifies start bit of Command path

signal DataBit0         : std_logic;
-- Data Bit received on line 0

signal DelDataBit0      : std_logic;
-- Delayed version of Data Bit received on line 0

signal DataSBit0        : std_logic;
-- Qualifies start bit of data on line 0

signal CmdEBit          : std_logic;
-- Qualifies end bit on commmand line

signal DataEBit0        : std_logic;
-- Qualifies end bit on data line 0

signal DelDataEbit0     : std_logic;
-- Delayed version of DataEBit0

signal iSendResponse    : std_logic;
-- Local copy of SendResponse output

signal DelCmdEnable     : std_logic;
-- Delayed value of Del1CmdEnable enable

signal Del1CmdEnable    : std_logic;
-- 1 clock delayed version of CmdEnable

signal PCEnable         : std_logic;
-- Used as an enable for all Protocol checks and defines the
-- appropriate window for all protocol checks

signal MMCITB1En        : std_logic := '0';
-- Enables the MMCITB1 protocol check

signal MMCITB3En        : std_logic := '0';
-- Enables the MMCITB3 protocol check

signal MMCITB4En        : std_logic := '0';
-- Enables the MMCITB4 protocol check

signal MMCITB5En        : std_logic := '0';
-- Enables the MMCITB5 protocol check

signal MMCITB7En        : std_logic := '0';
-- Enables the MMCITB7 protocol check

signal MMCITB8En        : std_logic := '0';
-- Enables the MMCITB8 protocol check

signal MMCITB9En        : std_logic := '0';
-- Enables the MMCITB9 protocol check

signal MMCITB10En       : std_logic := '0';
-- Enables the MMCITB10 protocol check

signal MMCITB18En       : std_logic := '0';
-- Enables the MMCITB18 protocol check

signal MMCITB19En       : std_logic := '0';
-- Enables the MMCITB19 protocol check

signal IntCmdBit        : std_logic;
-- Internal version of CmdBit with transition less than 1ns width
-- being removed

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
function to_integer (
                     val : std_logic_vector;
                       x : integer := 0
                    )
  return integer is
  variable returnint : integer;
  variable xtmp      : integer;
begin
  returnint := 0;
  xtmp := 0;
  if x /= 0 then
    xtmp := 1;
  end if;
  for i in val'range loop
    returnint := returnint + returnint;
      case val(i) is
        when '0' => null;
        when '1' => returnint := returnint + 1;
        when others => returnint := returnint + xtmp;
      end case;
  end loop;
  return returnint;
end to_integer;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- ----------------------------------------------------------------------------
-- Driving lines from the Registers
-- ----------------------------------------------------------------------------
ResponseBits   <= iResponseBits;
CmdEnable      <= iCmdEnable;
DataEn         <= iDataEn;
DataDirection  <= iDataDirection;
DataMode       <= iDataMode;
DataLength     <= MMCIDataLength;
Blocklen       <= MMCIDataCntl(7 downto 4);

iResponseBits  <= MCM(7 downto 6);
iCmdEnable     <= MCM(10);
iDataEn        <= MDC(0);
iDataDirection <= MDC(1);
iDataMode      <= MDC(2);

CmdCrcErr      <= MMCITBCntl(0);
DataCrcErr     <= MMCITBCntl(1);
TokenErrBit    <= MMCITBCntl(5);
MMCIDMACLR     <= MMCITBCntl(10);
FifoClear      <= MMCITBCntl(13) or
                  (iMDCStg2WrEn and (not(MMCIDataCntl(1))));
MDCStg2WrEn    <= iMDCStg2WrEn;

-- -------------------------------------------------------------------------
-- Driving counter outputs with local copies
-- -------------------------------------------------------------------------
CmdRespCnt   <= iCmdRespCnt;
DataTimeCnt  <= iDataTimeCnt;
TokenTimeCnt <= iTokenTimeCnt;
BsyTimeCnt   <= iBsyTimeCnt;
SendResponse <= iSendResponse;

-- -----------------------------------------------------------------------------
-- Second stage buffers for the registers.
-- -----------------------------------------------------------------------------
p_RegSeq : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    MP   <= (others => '0');
    MC   <= (others => '0');
    MCM  <= (others => '0');
    MDL  <= (others => '0');
    MDC  <= (others => '0');
    MTBC <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    MP   <= NextMP;
    MC   <= NextMC;
    MCM  <= NextMCM;
    MDL  <= NextMDL;
    MDC  <= NextMDC;
    MTBC <= NextMTBC;
  end if;
end process p_RegSeq;

-- -----------------------------------------------------------------------------
-- Generation of delayed versions of the Update trigger inputs.
-- -----------------------------------------------------------------------------
p_TriggerDel : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelMPUpdate   <= '0';
    DelMCUpdate   <= '0';
    DelMCMUpdate  <= '0';
    DelMDLUpdate  <= '0';
    DelMDCUpdate  <= '0';
    DelMTBCUpdate <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelMPUpdate   <= MPUpdateSync;
    DelMCUpdate   <= MCUpdateSync;
    DelMCMUpdate  <= MCMUpdateSync;
    DelMDLUpdate  <= MDLUpdateSync;
    DelMDCUpdate  <= MDCUpdateSync;
    DelMTBCUpdate <= MTBCUpdateSync;
  end if;
end process p_TriggerDel;

-- -----------------------------------------------------------------------------
-- Generation of load signals for second stage buffers.
-- -----------------------------------------------------------------------------
MPStg2WrEn   <= MPUpdateSync xor DelMPUpdate;
MCStg2WrEn   <= MCUpdateSync xor DelMCUpdate;
MCMStg2WrEn  <= MCMUpdateSync xor DelMCMUpdate;
MDLStg2WrEn  <= MDLUpdateSync xor DelMDLUpdate;
iMDCStg2WrEn <= MDCUpdateSync xor DelMDCUpdate;
MTBCStg2WrEn <= MTBCUpdateSync xor DelMTBCUpdate;

-- -----------------------------------------------------------------------------
-- MPStg2WrEn is used to enable the clocking of MP Input into MP buffer
-- -----------------------------------------------------------------------------
p_MPComb : process (MPStg2WrEn, MP, MMCIPower)
begin
  if (MPStg2WrEn = '1') then
    NextMP <= MMCIPower;
  else
    NextMP <= MP;
  end if;
end process p_MPComb;

-- -----------------------------------------------------------------------------
-- MCStg2WrEn is used to enable the clocking of MC Input into MC buffer
-- -----------------------------------------------------------------------------
p_MCComb : process (MCStg2WrEn, MC, MMCIClock)
begin
  if (MCStg2WrEn = '1') then
    NextMC <= MMCIClock;
  else
    NextMC <= MC;
  end if;
end process p_MCComb;

-- -----------------------------------------------------------------------------
-- MDLStg2WrEn is used to enable the clocking of MMCIDataLen Input into
-- MDL buffer
-- -----------------------------------------------------------------------------
p_MDLComb : process (MDLStg2WrEn, MMCIDataLength, MDL)
begin
  if (MDLStg2WrEn = '1') then
    NextMDL <= MMCIDataLength;
  else
    NextMDL <= MDL;
  end if;
end process p_MDLComb;

-- -----------------------------------------------------------------------------
-- MDCStg2WrEn is used to enable the clocking of MDC Input into
-- MDC buffer
-- -----------------------------------------------------------------------------
p_MDCComb : process (iMDCStg2WrEn, MMCIDataCntl, MDC)
begin
  if (iMDCStg2WrEn = '1') then
    NextMDC <= MMCIDataCntl;
  else
    NextMDC <= MDC;
  end if;
end process p_MDCComb;

-- -----------------------------------------------------------------------------
-- MCMStg2WrEn is used to enable the clocking of MCM Input into
-- MCM buffer
-- -----------------------------------------------------------------------------
p_MCMComb : process (MCMStg2WrEn, MMCICommand, MCM)
begin
  if (MCMStg2WrEn = '1') then
    NextMCM <= MMCICommand;
  else
    NextMCM <= MCM;
  end if;
end process p_MCMComb;

-- -----------------------------------------------------------------------------
-- MTBCStg2WrEn is used to enable the clocking of MMCITBCntl Input into
-- MTBC buffer
-- -----------------------------------------------------------------------------
p_MTBCComb : process (MTBCStg2WrEn, MMCITBCntl, MTBC)
begin
  if (MTBCStg2WrEn = '1') then
    NextMTBC <= MMCITBCntl;
  else
    NextMTBC <= MTBC;
  end if;
end process p_MTBCComb;

-- -----------------------------------------------------------------------------
-- Loading MMCITBSIGSTAT Registers
-- -----------------------------------------------------------------------------
MMCITBSIGSTAT <= (MMCIINTR1 & MMCIINTR0 & MMCIDMALBREQ & MMCIDMALSREQ &
                 MMCIDMABREQ & MMCIDMASREQ);

-- -----------------------------------------------------------------------------
-- Counter for MMCITBRespTimer register.This counter is loaded with
-- MMCITBRespTimer value, once the endbit of the cmd is received and when
-- the count runs to zero the transmission of response begins
-- -----------------------------------------------------------------------------
p_CmdRespCntSeq : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iCmdRespCnt <= (others => '0');
    Count0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CmdEBit = '1') then
      if (MMCITBRespTimer > "00000000000000000000000000000010") then
        iCmdRespCnt <= unsigned(MMCITBRespTimer) - 2;
      else
        iCmdRespCnt <= "00000000000000000000000000000001";
      end if;
      Count0        <= '1';
    else
      if (Count0 = '1') then
        iCmdRespCnt <= unsigned(iCmdRespCnt) - 1;
        if (iCmdRespCnt = "00000000000000000000000000000001" or
            iCmdEnable = '0') then
          Count0    <= '0';
        end if;
      end if;
    end if;
  end if;
end process p_CmdRespCntSeq;

-- -----------------------------------------------------------------------------
-- Counter to determine when the token transmission should begin.The
-- counter is loaded with MMCITBDataTimer value, once the data
-- transmission is enabled and when the counter runs to zero the
-- trickbox responds with data.
-- -----------------------------------------------------------------------------
p_DatTimCntSeq : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iDataTimeCnt <= (others => '0');
    Count1 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if ((iMDCStg2WrEn = '1' and MMCIDataCntl(1) = '1' and
         MMCIDataCntl(0) = '1') or BlkEnd = '1') then
      Count1         <= '1';
      if (MMCITBDataTimer > "00000000000000000000000000000010") then
        iDataTimeCnt <= unsigned(MMCITBDataTimer) - 2;
      else
        iDataTimeCnt <= "00000000000000000000000000000001";
      end if;
    else
      if (Count1 = '1') then
        iDataTimeCnt <= unsigned(iDataTimeCnt) - 1;
        if (iDataTimeCnt = "00000000000000000000000000000001") then
          Count1     <= '0';
        end if;
      end if;
    end if;
  end if;
end process p_DatTimCntSeq;

-- -----------------------------------------------------------------------------
-- Counter to determine when the token transmission should begin.The
-- counter is loaded with MMCITBTokenTimer value, on receiving the end
-- bit of data and when the counter runs to zero the token
-- transmission begins.
-- -----------------------------------------------------------------------------
p_TokTimCntSeq : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iTokenTimeCnt <= (others => '0');
    Count2  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (DataEBit0 = '1' and TokenSent = '1' and iDataMode = '0') then
      if (MMCITBTokenTimer > "0000000000000010") then
        iTokenTimeCnt <= unsigned(MMCITBTokenTimer) - 2;
      else
        iTokenTimeCnt <= "0000000000000010";
      end if;
      Count2          <= '1';
    else
      if (Count2 = '1') then
        iTokenTimeCnt <= unsigned(iTokenTimeCnt) - 1;
        if (iTokenTimeCnt = "0000000000000001") then
          Count2      <= '0';
        end if;
      end if;
    end if;
  end if;
end process p_TokTimCntSeq;

-- -----------------------------------------------------------------------------
-- Delayed version of Count2, used in Busy time counter
-- -----------------------------------------------------------------------------
p_DelCount2 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCount2 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelCount2 <= Count2;
  end if;
end process p_DelCount2;

-- -----------------------------------------------------------------------------
-- Counter to determine busy state duration.This counter is loaded with
-- the MMCITBBusyTimer value added with 5 clocks, once token transmission
-- begins so at the end of token transmission the counter would hold
-- MMCITBBusyTimer value and the MMCIDAT(0) will be held high, indicating
-- TrickBox busy, till the counter runs to zero.
-- -----------------------------------------------------------------------------
p_BsyTimCntSeq : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iBsyTimeCnt <= (others => '0');
    Count3  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (Count2 = '0' and DelCount2 = '1') then
      if (MMCITBBusyTimer = "0000000000000000") then
        iBsyTimeCnt <= unsigned(MMCITBBusyTimer) + 5;
      else
        iBsyTimeCnt <= unsigned(MMCITBBusyTimer) + 4;
      end if;
      Count3      <= '1';
    else
      if (Count3 = '1') then
        iBsyTimeCnt <= unsigned(iBsyTimeCnt) - 1;
        if (iBsyTimeCnt = "0000000000000001") then
          Count3    <= '0';
        end if;
      end if;
    end if;
  end if;
end process p_BsyTimCntSeq;

-- -----------------------------------------------------------------------------
-- Delayed version of DataEn
-- -----------------------------------------------------------------------------
p_DelDataEn : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDataEn <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelDataEn <= iDataEn;
  end if;
end process p_DelDataEn;

-- -----------------------------------------------------------------------------
-- Delayed version of TokenSent
-- -----------------------------------------------------------------------------
p_DelTokenSent : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelTokenSent <= '1';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelTokenSent <= TokenSent;
  end if;
end process p_DelTokenSent;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable
-- ----------------------------------------------------------------------------
p_PCEnable : process (MMCICLK)
begin
  if (MMCICLK'event and MMCICLK = '1') then
    PCEnable <= '0', '1' after OFFSET;
  end if;
end process p_PCEnable;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable for powerup protocol
-- ----------------------------------------------------------------------------
p_MMCITB1En : process (MP(1 downto 0))
begin
  if (MP'event) then
    MMCITB1En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB1En;

-- ----------------------------------------------------------------------------
-- Powerup Phase Protocol Check
-- ----------------------------------------------------------------------------
p_PowerupPC : process (MMCIPWR, MP, MMCITBPCDisable)
begin
  if (MMCITBPCDisable(0) = '0') then
    if (MP(1 downto 0) = "11") then
      if (MMCITB1En = '1') then
        if (MMCIPWR = '0') then
          assert false
            report "MMCITB1 : MMCIPWR low during Poweron phase"
          severity error;
        end if;
      end if;
      if (MP(1 downto 0) = "10" or MP(1 downto 0) = "00") then
        if (MMCITB1En = '1') then
          if (MMCICMD /= 'Z' or MMCIDAT /= 'Z' or MMCICLK /= '0') then
            assert false
              report "MMCITB2 :Outputs not disabled during Powerup phase"
            severity error;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_PowerupPC;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable for powersave protocol
-- ----------------------------------------------------------------------------
p_MMCITB3En : process (MC)
begin
  if (MC'event) then
    MMCITB3En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB3En;

-- ----------------------------------------------------------------------------
-- Power Save mode Protocol Check
-- ----------------------------------------------------------------------------
p_PwrSavePC : process (MC, MMCITBPCDisable)
begin
  if (MMCITBPCDisable(2) = '0') then
    if (MC(9) = '1') then
      if (MMCITB3En = '1') then
        if (BusInactive = '1') then
          if (MMCICLK'event) then
            assert false
              report "MMCITB3 : Clock active in PowerSave Mode"
            severity error;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_PwrSavePC;

-- ----------------------------------------------------------------------------
-- Checking whether the bus is idle
-- ----------------------------------------------------------------------------
p_BusCheck : process (CmdEBit, DataEBit0, CmdSBit, DataSBit0)
begin
  if (CmdEBit = '1') then
    CmdlineChk <= '1';
  elsif (CmdSBit = '1') then
    CmdlineChk <= '0';
  end if;
  if (DataEBit0 = '1') then
    DatalineChk <= '1';
  elsif (DataSBit0 = '1') then
    DatalineChk <= '0';
  end if;
end process p_BusCheck;

-- ----------------------------------------------------------------------------
-- Asserting that the bus has gone idle
-- ----------------------------------------------------------------------------
p_BusInactive : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    CmdClkCnt   <= (others => '0');
    DataClkCnt  <= (others => '0');
    DataBusInAc <= '0';
    CmdBusInAc  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CmdlineChk = '1' and MMCICMD = 'Z') then
      CmdClkCnt <= unsigned(CmdClkCnt) + 1;
      if (CmdClkCnt = "111") then
        CmdBusInAc <= '1';
      end if;
    else
      CmdClkCnt  <= (others => '0');
      CmdBusInAc <= '0';
    end if;

    if (DatalineChk = '1') then
      DataClkCnt <= unsigned(DataClkCnt) + 1;
      if (DataClkCnt = "111") then
        DataBusInAc <= '1';
      end if;
    else
      DataClkCnt  <= (others => '0');
      DataBusInAc <= '0';
    end if;
  end if;
end process p_BusInactive;

-- ----------------------------------------------------------------------------
-- Generating a signal which indicates bus is idle
-- ----------------------------------------------------------------------------
BusInactive <= CmdBusInAc and DataBusInAc;

-- ----------------------------------------------------------------------------
-- Delayed Command enable
-- ----------------------------------------------------------------------------
p_DelCmdEnable : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    Del1CmdEnable <= '0';
    DelCmdEnable  <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    Del1CmdEnable <= iCmdEnable;
    DelCmdEnable  <= Del1CmdEnable;
  end if;
end process p_DelCmdEnable;

-- -----------------------------------------------------------------------------
-- Generation of Protocol CheckEn for MMCITB4, MMCITB5, MMCITB6 protocols
-- -----------------------------------------------------------------------------
p_MMCITB4En : process (iCmdEnable, MDC)
begin
  if (iCmdEnable'event) then
    MMCITB4En <= '0', '1' after OFFSET;
  end if;
  if (MDC'event) then
    MMCITB5En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB4En;

-- ----------------------------------------------------------------------------
-- Checking the state of bus depending on the enable bit
-- ----------------------------------------------------------------------------
p_BusStateChk : process (MMCICMD, MMCIDAT, DelCmdEnable, MDC)

begin
  if (MMCITBPCDisable(5) = '0' and MP(6) = '0' and nMMCIRST /= '0') then
    if (DelCmdEnable = '0' and iCmdEnable = '0') then
      if (MMCITB4En = '1') then
        if (MMCICMD /= 'Z') then
          assert false
            report "MMCITB4 : Cmd line active when Cmd Enable bit is 0"
          severity error;
        end if;
      end if;
    end if;
  end if;
  if (MMCITBPCDisable(6) = '0') then
    if (MDC(0) = '0') then
      if (MMCITB5En = '1') then
        if (MMCIDAT /= 'Z') then
          assert false
            report "MMCITB5 : Data line active when Data Enable bit is 0"
          severity error;
        end if;
      end if;
    end if;
  end if;
end process p_BusStateChk;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable for MMCITB7 protocol
-- ----------------------------------------------------------------------------
p_MMCITB7En : process (CmdBit)
begin
  if (CmdBit'event) then
    MMCITB7En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB7En;

-- ----------------------------------------------------------------------------
-- Checking for a one in startbit
-- ----------------------------------------------------------------------------
p_IntCmdBit : process (CmdBit)
begin
  if (CmdBit'event) then
    IntCmdBit <= CmdBit after 1 ns;
  end if;
end process p_IntCmdBit;

-- ----------------------------------------------------------------------------
-- Checking for a one in startbit
-- ----------------------------------------------------------------------------
p_BusStartChk : process (DelCmdBit, CmdBit)
begin
  if (MMCITBPCDisable(7) = '0') then
    if (DelCmdBit = 'Z' and CmdBit'event) then
      if (MMCITB7En = '1') then
        if (IntCmdBit = '1') then
          assert false
            report "MMCITB7 : Start Bit found to contain 1"
          severity error;
        end if;
      end if;
    end if;
  end if;
end process p_BusStartChk;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable for MMCITB8 protocol
-- ----------------------------------------------------------------------------
p_MMCITB8En : process (Count0, iSendResponse)
begin
  if (iSendResponse = '1') then
    if (Count0'event and Count0 = '1') then
      MMCITB8En <= '0', '1' after OFFSET;
    end if;
  end if;
end process p_MMCITB8En;

-- ----------------------------------------------------------------------------
-- Interrupt mode Protocol Check
-- ----------------------------------------------------------------------------
p_IntrmodeChk : process (MCM, MMCICMD, Count0, iSendResponse,
                         iResponseBits)
begin
  if (MMCITBPCDisable(9) = '0') then
    if (MCM(8) = '1' and (iResponseBits /= "00" and
        iResponseBits /= "10")) then
      if (Count0 = '1' and iSendResponse = '1') then
        if (PCEnable = '1') then
          if (MMCICMD /= 'Z') then
            assert false
              report "MMCITB8 : Command line active in Intr mode"
            severity error;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_IntrmodeChk;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable for MMCITB9 protocol
-- ----------------------------------------------------------------------------
p_MMCITB9En : process (MP)
begin
  if (MP(6)'event) then
    MMCITB9En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB9En;

-- ----------------------------------------------------------------------------
-- Opendrain mode Protocol Check
-- ----------------------------------------------------------------------------
p_OpenDrainPC : process (MP, MMCICMD, MMCIDAT)
begin
  if (MMCITBPCDisable(14) = '0') then
    if (MP(6) = '1') then
      if (MMCITB9En = '1') then
        if (MMCICMD = '1') then
          assert false
            report "MMCITB9 :An '1' found on bus during Open Drain Mode"
          severity error;
        end if;
      end if;
    end if;
  end if;
end process p_OpenDrainPC;

-- ----------------------------------------------------------------------------
-- Generation of Protocol check enable for MMCITB10 protocol
-- ----------------------------------------------------------------------------
p_MMCITB10En : process (PCEnable)
begin
  if (PCEnable'event) then
    MMCITB10En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB10En;

-- ----------------------------------------------------------------------------
-- Pending mode Protocol Check
-- ----------------------------------------------------------------------------
p_PendModePC : process (MCM, MMCICMD, MMCIDAT, iDataMode, DataCnt, BitCnt,
                        CmdSBit, CmdEBit, DataEBit0)
begin
  if (MMCITBPCDisable(8) = '0') then
    if (MCM(9) = '1' and iDataMode = '1') then
      if (DataCnt = "0000000000000101" and BitCnt = "001") then
        if (MMCITB10En = '1' and PCEnable = '1') then
          if (CmdSBit /= '1') then
            assert false
              report "MMCITB10 : STOP Command Tx error in Cmd Pend Mode"
            severity error;
          end if;
        end if;
        EndBitChk <= '1';
      end if;
      if (PCEnable = '1') then
        if (CmdSBit = '1' ) then
          if (DataCnt > "0000000000000101") then
            assert false
              report "MMCITB11 : STOP Command Tx error in Cmd Pend Mode"
            severity error;
          end if;
        end if;
      end if;
      if (EndBitChk = '1') then
        if (DataEBit0 = '1') then
          EndBitChk <= '0';
          if (PCEnable = '1') then
            if (CmdEBit /= '1') then
              assert false
                report "MMCITB12: Proper EndBit missing in STOP Command"
              severity error;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_PendModePC;

-- ----------------------------------------------------------------------------
-- Checking block start bit and end bit
-- ----------------------------------------------------------------------------
p_BlockStEndPC : process (iDataEn, iDataMode, DataSBit0, DataEBit0)
variable Count    : integer   := 0;
variable Check    : std_logic := '0';
variable StartBit : std_logic := '0';
variable EndBit   : std_logic := '0';
begin
  if (MMCITBPCDisable(10) = '0') then
    if (iDataMode = '0' and iDataEn = '1' and iDataDirection = '0') then
      if (DataSBit0 = '1') then
        if (BlockBit = '0') then
          BlockBit <= '1';
          Check := '1';
        end if;
        if (StartBit = '0') then
          StartBit := '1';
          EndBit   := '0';
        else
          BlockErr <= '1';
        end if;
      elsif (DataEBit0 = '1') then
        if (BlockBit = '1') then
          BlockBit <= '0';
        end if;
        if (EndBit = '0') then
          StartBit := '0';
          EndBit   := '1';
        else
          BlockErr <= '1';
        end if;
      else
        if (BlockBit = '0' and Check = '0') then
          Count := Count + 1;
        else
          if (Count < 1 and Check = '1') then
            assert false
              report "MMCITB13 : Nwr Timing Check Failure"
            severity error;
          end if;
          Count := 0;
          Check := '0';
        end if;
        if (BlockErr = '1' and Check = '0') then
          assert false
            report "MMCITB14: Block not bounded by StartBit and EndBit"
          severity error;
          BlockErr <= '0';
        end if;
      end if;
    else
      BlockBit <= '0';
      Check    := '0';
      StartBit := '0';
      EndBit   := '0';
      BlockErr <= '0';
    end if;
  end if;
end process p_BlockStEndPC;

-- ----------------------------------------------------------------------------
-- Nrc timing check
-- ----------------------------------------------------------------------------
p_NrcPC : process (CmdSBit, CmdEBit)
begin
  if (MMCITBPCDisable(11) = '0' or MMCITBPCDisable(13) = '0') then
    if (PCEnable = '1') then
      if (CmdEBit = '1') then
        CountSt <= '1';
      elsif (CmdSBit = '1') then
        CountSt <= '0';
      end if;
    end if;
  end if;
end process p_NrcPC;

-- ----------------------------------------------------------------------------
-- Delayed version of DataEBit0
-- ----------------------------------------------------------------------------
p_DelDataEBit0 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDataEBit0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelDataEBit0 <= DataEBit0;
  end if;
end process p_DelDataEBit0;

-- ----------------------------------------------------------------------------
-- Sequential process for Nrc timing check
-- ----------------------------------------------------------------------------
p_NrcPCSeq : process (MMCICLK, nMMCIRST)
variable i : integer;
begin
  if (nMMCIRST = '0') then
    i := 0;
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CountSt = '1') then
      i := i + 1;
    elsif (CountSt'event and CountSt = '0') then
      if (i < 8) then
        assert false
          report "MMCITB15 : Nrc or Ncc Timing Failure"
        severity error;
      end if;
      i := 0;
    end if;
  end if;
end process p_NrcPCSeq;

-- -----------------------------------------------------------------------------
-- Calculation of MMCICLK phase duration from the register
-- MMCITBMCLKPeriod, with care being taken for bypass mode
-- -----------------------------------------------------------------------------
CLKDIV         <= to_integer(MMCIClock(7 downto 0));

MMCICLKREFVALUE <= ((to_integer(MMCITBMCLKPeriod)) * (CLKDIV + 1))
                                 when (MMCIClock(10) = '0')
               else
                  to_integer(MMCITBMCLKPeriod) / 2;

-- -----------------------------------------------------------------------------
-- Getting the period of MMCICLK for later verification
-- This process captures the positive and the negative edges of MMCICLK
-- The process is sensitized to MMCICLK
-- MMCICLKFlag1 is used as a flag for the High Phase
-- MMCICLKFlag2 is used as a flag for the Low Phase
-- -----------------------------------------------------------------------------
p_GetMMCICLKedges : process (MMCICLK, nMMCIRST, MMCITBPCDisable(16),
                            MC(9), BusInactive, MCM(10))
  variable Start : std_logic := '0';
begin
  if (nMMCIRST = '0' or (MMCITBPCDisable(16) = '1' or
      (MC(9) = '1' and BusInactive = '1') or MCM(10) = '0')) then
    MMCICLKFlag1 <= '0';
    MMCICLKFlag2 <= '0';
    Start       := '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (MMCICLKFlag1 = '0' and (MMCITBPCDisable(16) = '0' and
       (MC(9) = '1' and BusInactive = '0') and MCM(10) = '1')) then
      MMCICLKRiseEdge <= now;
      MMCICLKFlag1    <= '1';
      Start           := '1';
     end if;
    if (MMCICLKFlag2 = '1' and (MMCITBPCDisable(16) = '0' and
      (MC(9) = '1' and BusInactive = '0') and MCM(10) = '1')) then
      MMCICLKRiseEdge <= now;
      MMCICLKFlag2    <= '0';
      Start           := '1';
    end if;
  elsif (MMCICLK'event and MMCICLK = '0') then
    if (MMCICLKFlag2 = '0' and ((MMCITBPCDisable(16) = '0' and
        (MC(9) = '1' and BusInactive = '0') and MCM(10) = '1') and
         Start = '1')) then
      MMCICLKFallEdge <= now;
      MMCICLKFlag2    <= '1';
    end if;
    if (MMCICLKFlag1 = '1' and ((MMCITBPCDisable(16) = '0' and
        (MC(9) = '1' and BusInactive = '0') and MCM(10) = '1') and
         Start = '1')) then
      MMCICLKFallEdge <= now;
      MMCICLKFlag1    <= '0';
    end if;
  end if;
end process p_GetMMCICLKedges;

-- -----------------------------------------------------------------------------
-- Checking for validity of MMCICLK width.
-- The difference in time between the rising and the falling edge of the
-- MMCICLK is compared with the value calculated from the registers and
-- an Offset is provided for Gate Level Simulations.
-- -----------------------------------------------------------------------------
p_ChklowphaseSeq: process (MMCICLKFlag2)
begin
  if (MMCICLKFlag2'event and MMCICLKFlag2 = '0' and
      (MMCITBPCDisable(16) = '0' and
      (MC(9) = '1' and BusInactive = '0') and MCM(10) = '1')) then
    if (((MMCICLKRiseEdge - MMCICLKFallEdge) >
                              ((MMCICLKREFVALUE * 1 ns) + OFFSET)) or
        ((MMCICLKRiseEdge - MMCICLKFallEdge) <
                              ((MMCICLKREFVALUE * 1 ns) - OFFSET))) then
      assert false
        report "MMCITB16 :MMCICLK ERROR for the low phase"
      severity error;
    end if;
  end if;
end process p_ChklowphaseSeq;

p_ChkhighphaseSeq: process (MMCICLKFlag1)
begin
  if (MMCICLKFlag1'event and MMCICLKFlag1 = '0' and
      (MMCITBPCDisable(16) = '0' and
      (MC(9) = '1' and BusInactive = '0') and MCM(10) = '1')) then
    if (((MMCICLKFallEdge - MMCICLKRiseEdge) >
                                ((MMCICLKREFVALUE * 1 ns) + OFFSET)) or
        ((MMCICLKFallEdge - MMCICLKRiseEdge) <
                                ((MMCICLKREFVALUE * 1 ns) - OFFSET)))
       then
      assert false
        report "MMCITB17 :MMCICLK ERROR in the high phase"
      severity error;
    end if;
  end if;
end process p_ChkhighphaseSeq;

-- ----------------------------------------------------------------------------
-- Generation of Protocol checkEn for MMCIVDD protocol
-- ----------------------------------------------------------------------------
p_MMCITB18En : process (MMCIPower)
begin
  if (MMCIPower(5 downto 2)'event) then
    MMCITB18En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB18En;

-- ----------------------------------------------------------------------------
-- Protocol check for MMCIVDD
-- ----------------------------------------------------------------------------
p_MMCIVDDCheck : process (MMCIVDD)
begin
  if (MMCITB18En = '1') then
    if (MMCIVDD /= MMCIPower(5 downto 2)) then
      assert false
        report "MMCITB18 :MMCIVDD ERROR"
      severity error;
    end if;
  end if;
end process p_MMCIVDDCheck;

-- ----------------------------------------------------------------------------
-- Generation of Protocol checkEn for MMCIROD protocol
-- ----------------------------------------------------------------------------
p_MMCITB19En : process (MMCIPower)
begin
  if (MMCIPower(7)'event) then
    MMCITB19En <= '0', '1' after OFFSET;
  end if;
end process p_MMCITB19En;

-- ----------------------------------------------------------------------------
-- Protocol check for MMCIROD
-- ----------------------------------------------------------------------------
p_MMCIRODCheck : process (MMCIROD)
begin
  if (MMCITB19En = '1') then
    if (MMCIROD /= MMCIPower(7)) then
      assert false
        report "MMCITB18 :MMCIROD ERROR"
      severity error;
    end if;
  end if;
end process p_MMCIRODCheck;

-- ----------------------------------------------------------------------------
-- Tapping the Command and Data Buses
-- ----------------------------------------------------------------------------
CmdBit   <= MMCICMD;
DataBit0 <= MMCIDAT;

-- ----------------------------------------------------------------------------
--  Delayed version of CmdBit
-- ----------------------------------------------------------------------------
p_DelayCmdBit : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCmdBit <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (iCmdEnable = '1') then
      DelCmdBit <= CmdBit;
    end if;
  end if;
end process p_DelayCmdBit;

-- ----------------------------------------------------------------------------
--  Process detects the Command path start and end bit
-- ----------------------------------------------------------------------------
p_StartnEndBit : process (CmdBit, DelCmdBit, MP)
begin
  if (MP(6) = '0') then
    if (DelCmdBit = 'Z' and CmdBit = '0') then
      CmdSBit <= '1';
    elsif (DelCmdBit = '1' and CmdBit = 'Z' and iCmdEnable = '1') then
      CmdEBit <= '1';
    else
      CmdSBit <= '0';
      CmdEBit <= '0';
    end if;
  end if;
end process p_StartnEndBit;

-- ----------------------------------------------------------------------------
--  Delayed version of DataBit
-- ----------------------------------------------------------------------------
p_DelayDataBit : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelDataBit0 <= '0';
  elsif (MMCICLK'event and MMCICLK = '1') then
    DelDataBit0 <= DataBit0;
  end if;
end process p_DelayDataBit;

-- ----------------------------------------------------------------------------
--  Process detects the Data path start and end bit for line 0
-- ----------------------------------------------------------------------------
p_DStartnEndBit0 : process (DataBit0, DelDataBit0)
begin
  if (DelDataBit0 = 'Z' and DataBit0 = '0') then
    DataSBit0 <= '1';
  elsif (DelDataBit0 = '1' and DataBit0 = 'Z') then
    DataEBit0 <= '1';
  else
    DataSBit0 <= '0';
    DataEBit0 <= '0';
  end if;
end process p_DStartnEndBit0;

-- ----------------------------------------------------------------------------
--        Writes to Timer Registers
-- ----------------------------------------------------------------------------
p_TimerRegWr : process (PWDATAIn, MMCITBReTimWr, MMCITBDtTimWr,
                        MMCITBTokTimWr, MMCITBBsyTimWr, MMCITBPCDisWr,
                        MMCITBStTimWr, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    MMCITBRespTimer  <= (others => '0');
    MMCITBDataTimer  <= (others => '0');
    MMCITBTokenTimer <= (others => '0');
    MMCITBBusyTimer  <= (others => '0');
    MMCITBPCDisable  <= (others => '0');
    MMCITBStTimeout  <= (others => '0');
  elsif (MMCITBReTimWr = '1') then
    MMCITBRespTimer  <= PWDATAIn;
  elsif (MMCITBDtTimWr = '1') then
    MMCITBDataTimer  <= PWDATAIn;
  elsif (MMCITBTokTimWr = '1') then
    MMCITBTokenTimer <= PWDATAIn(15 downto 0);
  elsif (MMCITBBsyTimWr = '1') then
    MMCITBBusyTimer  <= PWDATAIn(15 downto 0);
  elsif (MMCITBPCDisWr = '1') then
    MMCITBPCDisable  <= PWDATAIn(16 downto 0);
  elsif (MMCITBStTimWr = '1') then
    MMCITBStTimeout  <= PWDATAIn;
  end if;
end process p_TimerRegWr;

-- ----------------------------------------------------------------------------
-- Handshakes used in command transfer.The SendResponse qualifies the
-- time during which a response can be sent and the RxComand qualifies
-- the time during which a command can be received, it also takes into
-- account the commands recd which require no response.
-- ----------------------------------------------------------------------------
p_Cmdhandshakes : process (CmdEBit, nMMCIRST, iCmdEnable)
begin
  if (nMMCIRST = '0' or iCmdEnable = '0') then
    iSendResponse <= '0';
    NextRxCommand <= '1';
    CmdOver       <= '0';
  else
    if (CmdEBit = '1' and CmdOver = '0') then
      if (iResponseBits = "00" or iResponseBits = "10" or
          (MMCICommand(8) = '0' and
           MMCITBRespTimer > "00000000000000000000000001000000")) then
        iSendResponse <= '0';
        NextRxCommand <= '1';
      else
        iSendResponse <= '1';
        NextRxCommand <= '0';
        CmdOver       <= '1';
      end if;
    elsif (CmdEBit = '1' and CmdOver = '1') then
      iSendResponse <= '0';
      NextRxCommand <= '1';
      CmdOver       <= '0';
    end if;
  end if;
end process p_Cmdhandshakes;

p_RxCommand : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    RxCommand <= '1';
  elsif (MMCICLK'event and MMCICLK = '1') then
    RxCommand <= NextRxCommand;
  end if;
end process p_RxCommand;

end behavioural;

-- --================================== End ==================================--
