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
-- File Name              : SsmcMemTSM.vhd.rca
-- File Revision          : 1.43
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block is responsible for issuing Read and Write Control
--           Signals to Memory devices.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SsmcPackage.all;

-- -----------------------------------------------------------------------------

entity SsmcMemTSM is
  port (
-- Inputs
        SMMEMCLK         : in    std_logic; -- Memory Clock
        HRESETn          : in    std_logic; -- AHB system level Reset
        MemRdReq         : in    std_logic; -- Signal indicating the read
                                            -- transfer being initiated
        MemWrReq         : in    std_logic; -- Signal indicating the write
                                            -- transfer has been initiated
        AddrBuf1         : in    std_logic_vector(25 downto 0);
                                            -- Level1 Buffer to hold HADDRSMC
        AddrBuf          : in    std_logic_vector(25 downto 0);
                                            -- Buffered AHB Address
        HburstMemBuf     : in    std_logic_vector(2 downto 0);
                                            -- Buffered HBURSTSMC
        HselMemBuf1      : in    std_logic_vector(7 downto 0);
                                            -- 1st level registered HSELSMC
        HselMemBuf       : in    std_logic_vector(7 downto 0);
                                            -- Buffered HSELSMC
        HtranRegCont     : in    std_logic_vector(1 downto 0);
                                            -- HTRANS registered on every clock
        HtransMemBuf1    : in    std_logic_vector (1 downto 0);
                                            -- Level1 Buffer to hold HTRANSSMC
        UseSecBuf        : in    std_logic; -- Indication to use second level
                                            -- buffered resources during Write
        HsizeEqMWidth    : in    std_logic; -- Indication that AHB and Memory
                                            -- are of same width
        AhbWider         : in    std_logic; -- Indication that AHB Width is
                                            -- greater than Memory Width
        AhbNarrow        : in    std_logic; -- Indication that AHB Width is
                                            -- Narrower than Memory Width
        AddrNotAligned   : in    std_logic; -- Indication that starting address
                                            -- is not aligned to Memory Width
        HsizeMemBuf1     : in    std_logic_vector(1 downto 0);
                                            -- Level1 buffer to hold HSIZESMC
        HsizeMemBuf      : in    std_logic_vector(1 downto 0);
                                            -- Buffered AHB HSIZESMC
        SyncWtSingle     : in    std_logic; -- Single bit Synchronous Wait
        SmBurstWtFbClk   : in    std_logic; -- nSMBURSTWAIT registered on
                                            -- SMFBCLK
        SMWaitSync       : in    std_logic; -- Double Synchronised
                                            -- External wait
        SmCancelWaitSync : in    std_logic; -- Double synchronised
                                            -- External wait termination
        MW1              : in    std_logic_vector(1 downto 0);
                                            -- 1st level registered memory
                                            -- width bits selection from one of
                                            -- the bank registers
        MW               : in    std_logic_vector(1 downto 0);
                                            -- The memory width bits selection
                                            -- from one of the bank registers
        SMBLSPol         : in    std_logic; -- Byte lane polarity bit selection
                                            -- from one of the bank registers
        RBLE             : in    std_logic; -- Byte lane enabled device
        BMRead1          : in    std_logic; -- 1st level Burst Mode read
        BMWrite          : in    std_logic; -- Burst Mode Write indication
        WrapRead         : in    std_logic; -- Enables the wrapping burst
                                            -- feature from memory
        SyncEnRead1      : in    std_logic; -- 1st level Sync burst Mode read
        SyncEnWrite      : in    std_logic; -- Synchronous burst Mode Write
        BurstLenRead1    : in    std_logic_vector(1 downto 0);
                                            -- 1st level Burst transfer length,
                                            -- by Burst devices for Read
        BurstLenWrite    : in    std_logic_vector(1 downto 0);
                                            -- Burst transfer length, supported
                                            -- by burst devices for Write
        AddrValidReadEn1 : in    std_logic; -- 1st level SMADDRVALID enable
                                            -- during Read
        AddrValidWriteEn : in    std_logic; -- SMADDRVALIDMC enable during Write
        BIWriteEn        : in    std_logic; -- Indication that SMBAAMC active
                                            -- during Synchronous Burst Write
                                            -- access.
        BIReadEn1        : in    std_logic; -- Indication that SMBAA and nSMIND
                                            -- active during Synchronous Burst
                                            -- Read access, 1st level buffered
        WaitEn           : in    std_logic; -- Enable signal for using SMWAIT
                                            -- input
        WSTRD1           : in    std_logic_vector(4 downto 0);
                                            -- 1st level Single Read access
                                            -- count
        WSTBRD1          : in    std_logic_vector(4 downto 0);
                                            -- 1st level Burst Read access count
        WSTWR            : in    std_logic_vector(4 downto 0);
                                            -- Single Write access count for the
                                            -- bank targeted currently
        WSTOEN1          : in    std_logic_vector(3 downto 0);
                                            -- 1st level Delay value for the
                                            -- assertion of OEN
        WSTWEN           : in    std_logic_vector(3 downto 0);
                                            -- Delay value for the assertion
                                            -- of the WEN and nSMCS signals
        IDCYC            : in    std_logic_vector(3 downto 0);
                                            -- Count value for the turnaround
                                            -- cycles
        TurnAround       : in    std_logic; -- TurnAround indication for R->W
        NewBurst         : in    std_logic; -- Indication that Burst Broken
        SMClockEn        : in    std_logic; -- Zero on this bit indicates that
                                            -- Clock should be active during
                                            -- Memory accesses. One on this bit
                                            -- indicates that clock is always
                                            -- running
        ClockRatio       : in    std_logic_vector(1 downto 0);
                                            -- Indicates ratio of Memory Clock
                                            -- with respect to HCLK
        SMBUSGNT         : in    std_logic; -- Bus Grant input to SSMCCore from
                                            -- DBI module
        BUSYCYC          : in    std_logic; -- Indication that SM is in
                                            -- ST_MEM_BUSY state
        IDLECYC          : in    std_logic; -- Indication that SM is in
                                            -- ST_MEM_NOT_SEL state
        WRITECYC         : in    std_logic; -- Indication that SM is in
                                            -- ST_MEM_WRITE state
        AhbWideWrCnt     : in    std_logic_vector(2 downto 0);
                                            -- Write counter when AHB > MW
        AhbWideRdCnt     : in    std_logic_vector(2 downto 0);
                                            -- Counter which indicates number of
                                            -- Memory accesses required for one
                                            -- AHB Read transfer
        AhbCount         : in    std_logic_vector(4 downto 0);
                                            -- Count which indicates the number
                                            -- of Memory transfer requested by
                                            -- AHB
        NextValByteLane0 : in    std_logic; -- Indication that Byte Lane0 is
                                            -- valid during write operation
        NextValByteLane1 : in    std_logic; -- Indication that Byte Lane1 is
                                            -- valid during write operation
        NextValByteLane2 : in    std_logic; -- Indication that Byte Lane2 is
                                            -- valid during write operation
        NextValByteLane3 : in    std_logic; -- Indication that Byte Lane3 is
                                            -- valid during write operation
-- Outputs
        MWWr             : out   std_logic_vector(1 downto 0);
                                            -- MW registered during Write
                                            -- operation
        RBLEWr           : out   std_logic; -- RBLE registered during write
                                            -- operation
        HsizeEqMWidthWr  : out   std_logic; -- Indication that AHB and Memory
                                            -- are of same width
        AhbWiderWr       : out   std_logic; -- Indication that AHB Width is
                                            -- greater than Memory Width
        AhbNarrowWr      : out   std_logic; -- Indication that AHB Width is
                                            -- Narrower than Memory Width
        HsizeMemBufWr    : out   std_logic_vector(1 downto 0);
                                            -- HsizeMemBuf registered during
                                            -- Write operation
        nSMWENMC         : out   std_logic; -- Memory Write Enable, Active LOW
        SmCSTSM          : out   std_logic; -- Chip Select Assertion
        DelSmCSTSM       : out   std_logic; -- Delayed version of SmCSTSM
        SmAddrTSM        : out   std_logic_vector(1 downto 0);
                                            -- Memory address from TSM Module
        SMADDRMC         : out   std_logic_vector(25 downto 0);
                                            -- Memory address output when
                                            -- Asynchronous memory access is
                                            -- progressing
        nSMBLSMC         : out   std_logic_vector(3 downto 0);
                                            -- Byte Lane select when
                                            -- Asynchronous memory access is
                                            -- progressing
        InitSt           : out   std_logic; -- Indication that Memory SM is in
                                            -- ST_NO_REQ State
        BurstWriteSt     : out   std_logic; -- Indication that Memory SM is in
                                            -- ST_BURST_WRITE State
        TurnAroundSt     : out   std_logic; -- Indication that Memory SM is in
                                            -- ST_TURNAROUND State
        WaitTxrOnBusSt   : out   std_logic; -- Indication that Memory SM is in
                                            -- ST_WAITTXRONBUS State
        WaitDeAssrtSt    : out   std_logic; -- Indication that Memory SM is in
                                            -- ST_WAIT_DEASSERTED State
        CancelWaitSt     : out   std_logic; -- Indication that Memory SM is in
                                            -- ST_CANCELWAIT State
        MemoryRdSt       : out   std_logic; -- Indication that Memory TSM is in
                                            -- Read State
        MemoryWrSt       : out   std_logic; -- Indication that Memory TSM is in
                                            -- Write State
        WBstIntrptd      : out   std_logic; 
        TxrB4BsyAccptd   : out   std_logic; 

        NextAsynAxs      : out   std_logic; -- Indication that Asynchronous
                                            -- memory access in progress
        NextSmOEn        : out  std_logic;
        NxtSMADDRVALIDMC : out  std_logic;
        NextSMBAAMC      : out  std_logic;
        NextSMCSMC       : out  std_logic_vector(7 downto 0);
        NextSMCSMCn      : out  std_logic_vector(7 downto 0);
        NextSMDATAENMCn  : out  std_logic_vector(3 downto 0);

        Toggle           : out   std_logic; -- Indication of State switching
                                            -- when SM is waiting for transfer
                                           -- on AHB Bus
        WaitWrCycVer     : out   std_logic; -- Memory device write completion
                                            -- signal
        WaitWrCycDup     : out   std_logic; -- Memory device write completion
                                            -- signal when Wait Transfer is
                                            -- pipelined
        WaitWrCycAhb     : out   std_logic; -- Memory device write completion
                                            -- signal when Synchronous Transfer
                                            -- is pipelined
        WaitRdCyc        : out   std_logic; -- Memory device read completion
                                            -- signal
        WaitRdCycVer     : out   std_logic; -- Version of WaitRdCyc
        SyncEnWriteReg   : out   std_logic; -- Synchronous Write Enable signal
                                            -- registered when write begins
        WaitEnReg        : out   std_logic; -- Wait Enable signal registered
                                            -- when write begins
        BMWriteReg       : out   std_logic; -- Burst Mode Write indication
                                            -- registered when write begins
        WriteBeatCnt     : out   std_logic_vector(2 downto 0);
                                            -- Counter used for carrying out
                                            -- Burst Write
        WaitStatus       : out   std_logic; -- Wait status for enabled transfers
        nSmBurstWaitReg  : out   std_logic; -- Registered SmBurstWtFbClk
        ClkStpd          : out   std_logic; -- Signal to indicate that clock
                                            -- output should be stopped
        SMBUSREQ         : out   std_logic  -- Bus Request signal to DBI
       );
end SsmcMemTSM;

-- -----------------------------------------------------------------------------
--
--                                 SsmcMemTSM
--                                 ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           The Transfer State Machine (TSM) block controls all the
--           transactions of the SsmcCore block to the external memory device.
--           The control signals for the read and write access are generated
--           depending on the type of transfer and the device characteristics.
--           External bus turnaround cycles are initiated appropriately after a
--           read transfer completion.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SsmcMemTSM is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal SmTSMState       : std_logic_vector(10 downto 0);
-- State Vector for Memory SM

signal NextSmTSMState   : std_logic_vector(10 downto 0);
-- D-Input of SmTSMState

signal iSmCSTSM         : std_logic;
-- Internal signal of SmCSTSM

signal NextSmCSTSM      : std_logic;
-- D-Input of iSmCSTSM

signal iSmOEnMC         : std_logic;
-- Internal signal of nSMOENMC

signal DelSmOEnMC       : std_logic;
-- 1 SMMEMCLK Delayed SmOEn

signal iWaitRdCyc       : std_logic;
-- Internal signal of WaitRdCyc

signal iWaitRdCycVer    : std_logic;
-- Internal signal of WaitRdCycVer

signal NextWaitRdCycVer : std_logic;
-- D-Input of iWaitRdCycVer

signal iWaitWrCycVer    : std_logic;
-- Internal signal of WaitWrCycVer

signal NextWaitWrCycVer : std_logic;
-- D-Input of iWaitWrCycVer

signal WaitWrCycVerAnd  : std_logic;
-- AND'ed version of WaitWrCycVer

signal iWaitWrCycDup    : std_logic;
-- Another version of WaitWrCycVer, which has the same timing as that of
-- WaitWrCycVer. It is de-asserted when there is a Wait Enabled transfer
-- pending. In this case WaitWrCycVer cannot be asserted.

signal NextWaitWrCycDup : std_logic;
-- D-Input of iWaitWrCycDup

signal iWaitWrCycAhb    : std_logic;
-- Another version of WaitWrCycVer, which has the same timing as that of
-- WaitWrCycVer. It is de-asserted when there is a Synchronous Write Transfer.

signal NextWaitWrCycAhb : std_logic;
-- D-Input of iWaitWrCycAhb

signal iSmAddrTSM       : std_logic_vector(25 downto 0);
-- Internal signal of SmAddrTSM

signal NextSmAddrTSM    : std_logic_vector(25 downto 0);
-- D-Input of iSmAddrTSM

signal iSMADDRMC        : std_logic_vector(25 downto 0);
-- Internal signal of SMADDRMC

signal NextSMADDRMC     : std_logic_vector(25 downto 0);
-- D-Input of iSMADDRMC

signal iSMWENMC         : std_logic;
-- Internal signal of nSMWENMC

signal NextSmWrEn       : std_logic;
-- D-Input of iSMWENMC

signal iSMADDRVALIDMC   : std_logic;
-- Internal signal of SMADDRVALIDMC

signal iSMBAAMC         : std_logic;
-- Internal signal of SMBAAMC

signal iSMBUSREQ        : std_logic;
-- Internal signal of SMBUSREQ

signal NextSMBUSREQ     : std_logic;
-- D-Input of iSMBUSREQ

signal WstLongRdCnt     : std_logic_vector(4 downto 0);
-- Counter to count wait states for Long Read

signal NextWstLongRdCnt : std_logic_vector(4 downto 0);
-- D-Input of WstLongRdCnt

signal WstBrstRdCnt     : std_logic_vector(4 downto 0);
-- Counter to count wait states for Burst Read

signal NextWstBrstRdCnt : std_logic_vector(4 downto 0);
-- D-Input of WstBrstRdCnt

signal WstWrCnt         : std_logic_vector(4 downto 0);
-- Counter to count wait states for Write

signal NextWstWrCnt     : std_logic_vector(4 downto 0);
-- D-Input of WstWrCnt

signal WstWrEnCnt       : std_logic_vector(3 downto 0);
-- Counter to count wait states for Write Enable assertion

signal NextWstWrEnCnt   : std_logic_vector(3 downto 0);
-- D-Input of WstWrEnCnt

signal WstOEnCnt        : std_logic_vector(3 downto 0);
-- Counter to count wait states for Output Enable assertion

signal NextWstOEnCnt    : std_logic_vector(3 downto 0);
-- D-Input of WstOEnCnt

signal BeatCount        : std_logic_vector(4 downto 0);
-- Counter to count number of possible Memory accesses

signal NextBeatCount    : std_logic_vector(4 downto 0);
-- D-Input of BeatCount

signal SleepModeReg     : std_logic;
-- Mode where BUSY was driven on AHB, so control signals are freezed

signal NextSleepModeReg : std_logic;
-- D-Input of SleepModeReg

signal SleepMode        : std_logic;
-- Indication that Busy is on AHB

signal IDCYRead         : std_logic_vector(3 downto 0);
-- Registered IDCYC values in Read states

signal NextIDCYRead     : std_logic_vector(3 downto 0);
-- D-Input of IDCYRead

signal IdcyCount        : std_logic_vector(3 downto 0);
-- Counter used for carrying out Turnaround

signal NextIdcyCount    : std_logic_vector(3 downto 0);
-- D-Input of IdcyCount

signal iWriteBeatCnt    : std_logic_vector(2 downto 0);
-- Internal signal of WriteBeatCnt

signal NextWriteBeatCnt : std_logic_vector(2 downto 0);
-- D-Input of iWriteBeatCnt

signal WrBtCntCpy       : std_logic_vector(2 downto 0);
-- Copy of WriteBeatCnt before making a state transition to ST_BURST_WRITE state

signal DelSMWENMC       : std_logic;
-- 1 SMMemClk Delayed iSMWENMC

signal iToggle          : std_logic;
-- Internal signal of Toggle

signal NextToggle       : std_logic;
-- D-Input of iToggle

signal HselMemBufWr     : std_logic_vector(7 downto 0);
-- HselMemBuf registered during Write operation

signal NextHselMemBufWr : std_logic_vector(7 downto 0);
-- D-Input of HselMemBufWr

signal HburstMemBufWr   : std_logic_vector(2 downto 0);
-- HburstMemBuf registered during Write operation

signal NextHburstMemBufWr : std_logic_vector(2 downto 0);
-- D-Input of HburstMemBufWr

signal iMWWr            : std_logic_vector(1 downto 0);
-- Internal signal of MW

signal NextMWWr         : std_logic_vector(1 downto 0);
-- D-Input of iMWWr

signal SMBLSPolWr       : std_logic;
-- SMBLSPol registered during write operation

signal NextSMBLSPolWr   : std_logic;
-- D-Input of SMBLSPolWr

signal iHsizeMemBufWr   : std_logic_vector(1 downto 0);
-- Internal signal of HsizeMemBufWr

signal NxtHsizeMemBufWr : std_logic_vector(1 downto 0);
-- D-Input of iHsizeMemBufWr

signal iHsizeEqMWidthWr : std_logic;
-- Internal signal of HsizeEqMWidthWr

signal NextHsizeEqMW    : std_logic;
-- D-Input of HsizeEqMWidthWr

signal iAhbWiderWr      : std_logic;
-- Internal signal of AhbWiderWr

signal NextAhbWiderWr   : std_logic;
-- D-Input of iAhbWiderWr

signal iAhbNarrowWr     : std_logic;
-- Internal signal of iAhbNarrowWr

signal NextAhbNarrowWr  : std_logic;
-- D-Input of iAhbNarrowWr

signal iRBLEWr          : std_logic;
-- Internal signal of RBLEWr

signal NextRBLEWr       : std_logic;
-- D-Input of iRBLEWr

signal IncrAddr         : std_logic_vector(25 downto 0);
-- Incremented Memory Address

signal IncrAddrWr       : std_logic_vector(25 downto 0);
-- Incremented Memory Address during Write

signal WriteProg        : std_logic;
-- Indication of Write in progress for wait enabled transfers

signal NextWriteProg    : std_logic;
-- D-Input of WriteProg

signal iWaitEnReg       : std_logic;
-- Internal signal of WaitEnReg

signal NextWaitEnReg    : std_logic;
-- D-Input of iWaitEnReg

signal iSyncEnWriteReg  : std_logic;
-- Internal signal of SyncEnWriteReg

signal NextSyncEnWr     : std_logic;
-- D-Input of iSyncEnWriteReg

signal iBMWriteReg      : std_logic;
-- Internal signal of BMWriteReg

signal NextBMWriteReg   : std_logic;
-- D-Input of iBMWriteReg

signal BIWriteEnReg      : std_logic;
-- Internal signal of BMWriteReg

signal NextBIWriteEnReg   : std_logic;
-- D-Input of iBMWriteReg

signal BurstLenWrReg    : std_logic_vector(1 downto 0);
-- Burst Length indication registered when write begins.

signal NextBurstLenWr   : std_logic_vector(1 downto 0);
-- D-Input of BurstLenWrReg

signal AddrValWrEnReg   : std_logic;
-- Address Valid indication registered when write begins.

signal NextAddrValWrReg : std_logic;
-- D-Input of AddrValWrEnReg

signal WSTWENReg        : std_logic_vector(3 downto 0);
-- Write Enable Delay value registered when write begins.

signal NextWSTWENReg    : std_logic_vector(3 downto 0);
-- D-Input of WSTWENReg

signal WSTWRReg         : std_logic_vector(4 downto 0);
-- Write Delay value registered when write begins.

signal NextWSTWRReg     : std_logic_vector(4 downto 0);
-- D-Input of WSTWENReg

signal SmBurstWaitReg   : std_logic;
-- Registered SmBurstWtFbClk

signal SyncWtOnMCLK     : std_logic;
-- Registered nSMBURSTWAIT on SMMEMCLK

signal DelSmBurstWait   : std_logic;
-- 1 SMMemClk Delayed SmBurstWaitReg

signal AhbWideRdReg     : std_logic_vector(2 downto 0);
-- Registered AhbWideRdCnt during Read transfers

signal NextAhbWideRdReg : std_logic_vector(2 downto 0);
-- D-Input of AhbWideRdReg

signal StopBurst       : std_logic;
-- Indication to stop burst Transfer

signal NextStopBurst    : std_logic;
-- D-Input of StopBurst

signal ContWithBrst     : std_logic;
-- Indication as to continue with Burst Write for Synchronous Memories

signal NextContWithBrst : std_logic;
-- D-Input of ContWithBrst

signal ReadSt           : std_logic;
-- Indication that Memory SM is in Read state

signal BurstReadSt      : std_logic;
-- Indication that Memory SM is in Burst Read state

signal WriteSt          : std_logic;
-- Indication that Memory SM is in Write state

signal WaitAssrtSt      : std_logic;
-- Indication that Memory SM is in Wait Asserted state

signal iBurstWriteSt    : std_logic;
-- Internal signal of BurstWriteSt

signal iTurnAroundSt    : std_logic;
-- Internal signal of TurnAroundSt

signal iWaitTxrOnBusSt  : std_logic;
-- Internal signal of WaitTxrOnBusSt

signal iWaitDeAssrtSt   : std_logic;
-- Internal signal of WaitDeAssrtSt

signal iCancelWaitSt    : std_logic;
-- Internal signal of CancelWaitSt

signal iClkStpd         : std_logic;
-- Internal signal of ClkStpd

signal NextClkStpd      : std_logic;
-- D-Input of iClkStpd

signal IndAssrtd        : std_logic;
-- Indication that nSMIND will be asserted

signal DelAhbWideWrCnt  : std_logic_vector(2 downto 0);
-- Delayed DelAhbWideWrCnt

signal NewBrstOccrd     : std_logic;
-- Indication that NewBurst was sampled in ST_BURST_READ state

signal NextNewBrstOccrd : std_logic;
-- D-Input of NewBrstOccrd

signal iSMCSMC          : std_logic_vector(7 downto 0);
-- Internal signal of SMCSMC

signal iSMCSMCn         : std_logic_vector(7 downto 0);
-- Internal signal of nSMCSMC

signal iSMDATAENMCn     : std_logic_vector(3 downto 0);
-- Internal signal of nSMDATAENMC

signal iSMBLSMCn        : std_logic_vector(3 downto 0);
-- Internal signal of nSMBLSMC

signal NextSMBLSMCn     : std_logic_vector(3 downto 0);
-- D-Input of iSMBLSMCn

signal iAsynAxs         : std_logic;
-- Internal signal of AsynAxs

signal Stop2WtWrCyc     : std_logic;
-- Signal to stop extra WaitWrCycVer assertion when Burst write is in progress

signal NextStop2WtWrCyc : std_logic;
-- D-Input of Stop2WtWrCyc

signal iWBstIntrptd      : std_logic;
-- Indication that synchronous write burst was interrupted

signal NextWBstIntrptd  : std_logic;
-- D-Input of WBstIntrptd

signal FirstSyncWt      : std_logic;
-- Indication that synchronous wait was asserted for first time

signal NextFirstSyncWt  : std_logic;
-- D-Input of FirstSyncWt

signal XtraTxr          : std_logic;
-- Extra write transfer accepted

signal NextXtraTxr      : std_logic;
-- D-Input of XtraTxr

signal DelWaitWrCycVer  : std_logic;
-- Delayed version of WaitWrCycVerAnd

signal iTxrB4BsyAccptd  : std_logic;
-- Extra write transfer accepted

signal NextTxrB4BsyAccptd : std_logic;
-- D-Input of iTxrB4BsyAccptd;

signal DelUseSecBuf  : std_logic;
-- Delayed version of UseSecBuf

signal iNextAsynAxs      : std_logic;
-- Next state control outputs to PadIf

signal iNextSmOEn        : std_logic;
-- Next state control outputs to PadIf

signal iNxtSMADDRVALIDMC : std_logic;
-- Next state control outputs to PadIf

signal iNextSMBAAMC      : std_logic;
-- Next state control outputs to PadIf

signal iNextSMCSMC       : std_logic_vector(7 downto 0);
-- Next state control outputs to PadIf

signal iNextSMCSMCn      : std_logic_vector(7 downto 0);
-- Next state control outputs to PadIf

signal iNextSMDATAENMCn  : std_logic_vector(3 downto 0);
-- Next state control outputs to PadIf

-- -----------------------------------------------------------------------------
-- AddrIncr:
-- This Function increments the Address based on Memory Width, AHB Width and
-- HBURST information.
-- This function is provided to increment the 26 bit Memory Address, in terms of
-- nibble counter. This function is provided so that the synthesis tool does not
-- blow up the counter logic. This function can be easily changed to suit any
-- particular tool.
-- -----------------------------------------------------------------------------
function AddrIncr (
           Addr            : std_logic_vector(25 downto 0);
           MemWidth        : std_logic_vector(1 downto 0);
           AhbWidth        : std_logic_vector(1 downto 0);
           Hburst          : std_logic_vector(2 downto 0)
                  )
         return std_logic_vector is
variable Result           : std_logic_vector(25 downto 0);
-- return from function

variable Concat           : std_logic_vector(3 downto 0);
-- Temporary variable to hold the Memory Width and AHB Width
begin
  Concat := (MemWidth & AhbWidth);
  Result := Addr;
  case Hburst is
    when HBURST_INCR | HBURST_INCR4 | HBURST_INCR8 | HBURST_INCR16 |
         HBURST_SINGLE =>
      case MemWidth is
        when MEM_BYTE =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 0) := unsigned(Addr(3 downto 0)) + 1;
          if ((Addr(3) and Addr(2) and Addr(1) and Addr(0)) = '1') then
            Result(7 downto 4) := unsigned(Addr(7 downto 4)) + 1;
            if ((Addr(7) and Addr(6) and Addr(5) and Addr(4)) = '1') then
              Result(11 downto 8) := unsigned(Addr(11 downto 8)) + 1;
              if ((Addr(11) and Addr(10) and Addr(9) and Addr(8)) = '1') then
                Result(15 downto 12) := unsigned(Addr(15 downto 12)) + 1;
                if ((Addr(15) and Addr(14) and Addr(13) and Addr(12))
                                                                    = '1') then
                  Result(19 downto 16) := unsigned(Addr(19 downto 16)) + 1;
                  if ((Addr(19) and Addr(18) and Addr(17) and Addr(16))
                                                                    = '1') then
                    Result(23 downto 20) := unsigned(Addr(23 downto 20)) + 1;
                    if ((Addr(23) and Addr(22) and Addr(21) and Addr(20))
                                                                    = '1') then
                      Result(25 downto 24) := unsigned(Addr(25 downto 24)) + 1;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;

        when MEM_HWORD =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 1) := unsigned(Addr(4 downto 1)) + 1;
          if ((Addr(4) and Addr(3) and Addr(2) and Addr(1)) = '1') then
            Result(8 downto 5) := unsigned(Addr(8 downto 5)) + 1;
            if ((Addr(8) and Addr(7) and Addr(6) and Addr(5)) = '1') then
              Result(12 downto 9) := unsigned(Addr(12 downto 9)) + 1;
              if ((Addr(12) and Addr(11) and Addr(10) and Addr(9)) = '1') then
                Result(16 downto 13) := unsigned(Addr(16 downto 13)) + 1;
                if ((Addr(16) and Addr(15) and Addr(14) and Addr(13))
                                                                    = '1') then
                  Result(20 downto 17) := unsigned(Addr(20 downto 17)) + 1;
                  if ((Addr(20) and Addr(19) and Addr(18) and Addr(17))
                                                                    = '1') then
                    Result(24 downto 21) := unsigned(Addr(24 downto 21)) + 1;
                    if ((Addr(24) and Addr(23) and Addr(22) and Addr(21))
                                                                    = '1') then
                      Result(25) := not(Addr(25));
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;

        when MEM_WORD =>
          Result(25 downto 6) := Addr(25 downto 6);
          Result(5 downto 2) := unsigned(Addr(5 downto 2)) + 1;
          if ((Addr(5) and Addr(4) and Addr(3) and Addr(2)) = '1') then
            Result(9 downto 6) := unsigned(Addr(9 downto 6)) + 1;
            if ((Addr(9) and Addr(8) and Addr(7) and Addr(6)) = '1') then
              Result(13 downto 10) := unsigned(Addr(13 downto 10)) + 1;
              if ((Addr(13) and Addr(12) and Addr(11) and Addr(10)) = '1') then
                Result(17 downto 14) := unsigned(Addr(17 downto 14)) + 1;
                if ((Addr(17) and Addr(16) and Addr(15) and Addr(14))
                                                                    = '1') then
                  Result(21 downto 18) := unsigned(Addr(21 downto 18)) + 1;
                  if ((Addr(21) and Addr(20) and Addr(19) and Addr(18))
                                                                    = '1') then
                    Result(25 downto 22) := unsigned(Addr(25 downto 22)) + 1;
                  end if;
                end if;
              end if;
            end if;
          end if;
        when others =>
          null;
      end case;

    when HBURST_WRAP4 =>
      case Concat is
        when "0000" =>
          Result(25 downto 2) := Addr(25 downto 2);
          Result(1 downto 0)  := unsigned(Addr(1 downto 0)) + 1;

        when "0001" =>
          Result(25 downto 3) := Addr(25 downto 3);
          Result(2 downto 0)  := unsigned(Addr(2 downto 0)) + 1;

        when "0010" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 0)  := unsigned(Addr(3 downto 0)) + 1;

        when "0100" =>
          Result(25 downto 2) := Addr(25 downto 2);
          Result(1)           := not(Addr(1));
          Result(0)           := '0';

        when "0101" =>
          Result(25 downto 3) := Addr(25 downto 3);
          Result(2 downto 1)  := unsigned(Addr(2 downto 1)) + 1;
          Result(0)           := '0';

        when "0110" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 1)  := unsigned(Addr(3 downto 1)) + 1;
          Result(0)           := '0';

        when "1000" =>
          Result(25 downto 2) := Addr(25 downto 2);
          Result(1 downto 0)  := "00";

        when "1001" =>
          Result(25 downto 3) := Addr(25 downto 3);
          Result(2)           := not(Addr(2));
          Result(1 downto 0)  := "00";

        when "1010" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 2)  := unsigned(Addr(3 downto 2)) + 1;
          Result(1 downto 0)  := "00";

        when others =>
          null;
      end case;

    when HBURST_WRAP8 =>
      case Concat is
        when "0000" =>
          Result(25 downto 3) := Addr(25 downto 3);
          Result(2 downto 0)  := unsigned(Addr(2 downto 0)) + 1;

        when "0001" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 0)  := unsigned(Addr(3 downto 0)) + 1;

        when "0010" =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 0)  := unsigned(Addr(4 downto 0)) + 1;

        when "0100" =>
          Result(25 downto 3) := Addr(25 downto 3);
          Result(2 downto 1)  := unsigned(Addr(2 downto 1)) + 1;
          Result(0) := '0';

        when "0101" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 1)  := unsigned(Addr(3 downto 1)) + 1;
          Result(0) := '0';

        when "0110" =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 1)  := unsigned(Addr(4 downto 1)) + 1;
          Result(0) := '0';

        when "1000" =>
          Result(25 downto 3) := Addr(25 downto 3);
          Result(2)           := not(Addr(2));
          Result(1 downto 0)  := "00";

        when "1001" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 2)  := unsigned(Addr(3 downto 2)) + 1;
          Result(1 downto 0)  := "00";

        when "1010" =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 2)  := unsigned(Addr(4 downto 2)) + 1;
          Result(1 downto 0)  := "00";

        when others =>
          null;
      end case;

    when HBURST_WRAP16 =>
      case Concat is
        when "0000" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 0)  := unsigned(Addr(3 downto 0)) + 1;

        when "0001" =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 0)  := unsigned(Addr(4 downto 0)) + 1;

        when "0010" =>
          Result(25 downto 6) := Addr(25 downto 6);
          Result(5 downto 0)  := unsigned(Addr(5 downto 0)) + 1;

        when "0100" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 1)  := unsigned(Addr(3 downto 1)) + 1;
          Result(0) := '0';

        when "0101" =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 1)  := unsigned(Addr(4 downto 1)) + 1;
          Result(0) := '0';

        when "0110" =>
          Result(25 downto 6) := Addr(25 downto 6);
          Result(5 downto 1)  := unsigned(Addr(5 downto 1)) + 1;
          Result(0) := '0';

        when "1000" =>
          Result(25 downto 4) := Addr(25 downto 4);
          Result(3 downto 2)  := unsigned(Addr(3 downto 2)) + 1;
          Result(1 downto 0)  := "00";

        when "1001" =>
          Result(25 downto 5) := Addr(25 downto 5);
          Result(4 downto 2)  := unsigned(Addr(4 downto 2)) + 1;
          Result(1 downto 0)  := "00";

        when "1010" =>
          Result(25 downto 6) := Addr(25 downto 6);
          Result(5 downto 2)  := unsigned(Addr(5 downto 2)) + 1;
          Result(1 downto 0)  := "00";

        when others =>
          null;
      end case;

    when others =>
      null;
  end case;
  return (Result);
end AddrIncr;


-- -----------------------------------------------------------------------------
-- Function to Check for memory Boundary Cross-over
-- -----------------------------------------------------------------------------
function BoundaryChk (
           Addr            : std_logic_vector(5 downto 0);
           Count           : std_logic_vector(4 downto 0);
           BurstLen        : std_logic_vector(1 downto 0);
           MemWidth        : std_logic_vector(1 downto 0);
           Hburst          : std_logic_vector(2 downto 0);
           SyncWrapRd      : std_logic;
           SyncDev         : std_logic;
           AhbWidth        : std_logic_vector(1 downto 0);
           BurstMode       : std_logic
                     )
         return std_logic_vector is
variable Result           : std_logic_vector(4 downto 0);
-- return from function

variable Temp             : std_logic_vector(4 downto 0);
-- Temporary variable used to find out whether full burst is possible

begin
  Temp     := Count;
  Result   := "00001";
  if (BurstMode = '1') then
    case BurstLen is
      when FOUR_TXR =>
        Temp     := "00100";

        case MemWidth is
          when MEM_BYTE =>
            if ((Addr(1) or Addr(0)) = '1') then
              Temp(2 downto 0) := 4 - unsigned(('0' & Addr(1 downto 0)));
            end if;

          when MEM_HWORD =>
            if ((Addr(2) or Addr(1)) = '1') then
              Temp(2 downto 0) := 4 - unsigned(('0' & Addr(2 downto 1)));
            end if;

          when MEM_WORD =>
            if ((Addr(3) or Addr(2)) = '1') then
              Temp(2 downto 0) := 4 - unsigned(('0' & Addr(3 downto 2)));
            end if;

          when others =>
            null;
        end case;
        
        if ((SyncDev = '1') and (Hburst /= HBURST_WRAP4) and
            (Hburst /= HBURST_WRAP8) and (Hburst /= HBURST_WRAP16)) then
          Temp := "00100";
        end if;

      when EIGHT_TXR =>
        Temp     := "01000";

        case MemWidth is
          when MEM_BYTE =>
            if ((Addr(2) or Addr(1) or Addr(0)) = '1') then
              Temp(3 downto 0) := 8 - unsigned(('0' & Addr(2 downto 0)));
            end if;

          when MEM_HWORD =>
            if ((Addr(3) or Addr(2) or Addr(1)) = '1') then
              Temp(3 downto 0) := 8 - unsigned(('0' & Addr(3 downto 1)));
            end if;

          when MEM_WORD =>
            if ((Addr(4) or Addr(3) or Addr(2)) = '1') then
              Temp(3 downto 0) := 8 - unsigned(('0' & Addr(4 downto 2)));
            end if;

          when others =>
            null;
        end case;

        if (SyncDev = '1') then
          if (SyncWrapRd = '0') then
            if ((Hburst /= HBURST_WRAP4) and (Hburst /= HBURST_WRAP8) and
                (Hburst /= HBURST_WRAP16)) then
              Temp := "01000";
            end if;
          else
            if ((AhbWidth = "10") and (Hburst = HBURST_WRAP8)) then
              Temp := "01000";
            end if;
          end if;
        end if;

      when SIXTEEN_TXR | CONTINUOUS =>
        Temp     := "10000";

        case MemWidth is
          when MEM_BYTE =>
            if ((Addr(3) or Addr(2) or Addr(1) or Addr(0)) = '1') then
              Temp(4 downto 0) := 16 - unsigned(('0' & Addr(3 downto 0)));
            end if;
 
          when MEM_HWORD =>
            if ((Addr(4) or Addr(3) or Addr(2) or Addr(1)) = '1') then
              Temp(4 downto 0) := 16 - unsigned(('0' & Addr(4 downto 1)));
            end if;

          when MEM_WORD =>
            if ((Addr(5) or Addr(4) or Addr(3) or Addr(2)) = '1') then
              Temp(4 downto 0) := 16 - unsigned(('0' & Addr(5 downto 2)));
            end if;

          when others =>
            null;
        end case;

        if (SyncDev = '1') then
          if (SyncWrapRd = '0') then
            if ((Hburst /= HBURST_WRAP4) and (Hburst /= HBURST_WRAP8) and
                (Hburst /= HBURST_WRAP16)) then
              Temp := "10000";
            end if;
          else
            if (((AhbWidth = "10") and (Hburst = HBURST_WRAP8)) or
                ((AhbWidth = "01") and (Hburst = HBURST_WRAP16))) then
              Temp := "10000";
            end if;
          end if;
        end if;

      when others =>
        null;
    end case;

    if (Temp > Count) then
      Result := Count;
    else
      Result := Temp;
    end if;
  end if;
  return (Result);
end BoundaryChk;

-- -----------------------------------------------------------------------------
-- Function to Check for memory Boundary during Synchronous Write Transfers
-- -----------------------------------------------------------------------------
function BoundChkWr (
           BurstLen        : std_logic_vector(1 downto 0);
           MemWidth        : std_logic_vector(1 downto 0);
           Addr            : std_logic_vector(3 downto 0);
           Hburst          : std_logic_vector(2 downto 0);
           AhbWide         : std_logic;
           AhbWideCnt      : std_logic_vector(2 downto 0)
                     )
         return std_logic_vector is
variable Result           : std_logic_vector(2 downto 0);
-- return from function

begin
  Result := "011";
  if ((Hburst = HBURST_WRAP4) or (Hburst = HBURST_WRAP8) or
      (Hburst = HBURST_WRAP16)) then
    case BurstLen is
      when FOUR_TXR =>
        Result := "011";
        case MemWidth is
          when MEM_BYTE =>
            if (AhbWide = '1') then
              Result             := AhbWideCnt;
            elsif ((Addr(1) or Addr(0)) = '1') then
              Result(1 downto 0) := 3 - unsigned(Addr(1 downto 0));
            end if;

          when MEM_HWORD =>
            if (AhbWide = '1') then
              Result             := AhbWideCnt;
            elsif ((Addr(2) or Addr(1)) = '1') then
              Result(1 downto 0) := 3 - unsigned(Addr(2 downto 1));
            end if;

          when MEM_WORD =>
            if (AhbWide = '1') then
              Result             := AhbWideCnt;
            elsif ((Addr(3) or Addr(2)) = '1') then
              Result(1 downto 0) := 3 - unsigned(Addr(3 downto 2));
            end if;

          when others =>
            null;
        end case;

      when EIGHT_TXR | CONTINUOUS =>
        Result := "111";
        case MemWidth is
          when MEM_BYTE =>
            if (AhbWide = '1') then
              Result             := AhbWideCnt;
            else
              if (Hburst = HBURST_WRAP4) then
                Result(1 downto 0) := 3 - unsigned(Addr(1 downto 0));
                Result(2)          := '0';
              else
                Result(2 downto 0) := 7 - unsigned(Addr(2 downto 0));
              end if;
            end if;

          when MEM_HWORD =>
            if (AhbWide = '1') then
              Result             := AhbWideCnt;
            else
              if (Hburst = HBURST_WRAP4) then
                Result(1 downto 0) := 3 - unsigned(Addr(2 downto 1));
                Result(2)          := '0';
              else
                Result(2 downto 0) := 7 - unsigned(Addr(3 downto 1));
              end if;
            end if;

          when others =>
            null;
        end case;

      when others =>
        null;
    end case;
  else
    Result   := "111";
    if (AhbWide = '1') then
      Result := AhbWideCnt;
    elsif (BurstLen = FOUR_TXR) then
      Result := "011";
    end if;
  end if;

  return (Result);
end BoundChkWr;

-- -----------------------------------------------------------------------------
-- Function to generate the condition for nSMIND assertion.
-- -----------------------------------------------------------------------------
function IndAssrt (
           Addr            : std_logic_vector(6 downto 0);
           BMDevice        : std_logic;
           IndEnbled       : std_logic;
           MW              : std_logic_vector(1 downto 0)
                  )
         return std_logic is
variable Result           : std_logic;
-- return from function

variable Temp             : std_logic_vector(4 downto 0);
-- Temporary variable used to hold the correct address bits

begin
  Temp := "00000";
  case MW is
    when MEM_BYTE =>
      Temp := Addr(4 downto 0);

    when MEM_HWORD =>
      Temp := Addr(5 downto 1);

    when MEM_WORD =>
      Temp := Addr(6 downto 2);

    when others =>
      null;
  end case;

  if ((Temp = "11111") and (BMDevice = '1') and (IndEnbled = '1')) then
    Result := '0';
  else
    Result := '1';
  end if;

  return (Result);
end IndAssrt;


-- -----------------------------------------------------------------------------
-- Function to appropriately shift the SmAddrTSM lines before driving on
-- SMADDRMC lanes.
-- -----------------------------------------------------------------------------
function ShiftAddr (
           Addr            : std_logic_vector(25 downto 0);
           MW              : std_logic_vector(1 downto 0)
                   )
         return std_logic_vector is
variable Result           : std_logic_vector(25 downto 0);
-- return from function

begin
  Result := Addr;
  case MW is
    when MEM_BYTE =>
      Result := Addr;

    when MEM_HWORD =>
      Result := ('0' & Addr(25 downto 1));

    when MEM_WORD =>
      Result := ("00" & Addr(25 downto 2));

    when others =>
      null;
  end case;

  return (Result);
end ShiftAddr;

-- -----------------------------------------------------------------------------
-- Function to appropriately assert nSMDATAENMC byte lanes
-- -----------------------------------------------------------------------------
function DataEnFunc (
           MW              : std_logic_vector(1 downto 0)
                    )
         return std_logic_vector is
variable Result           : std_logic_vector(3 downto 0);
-- return from function

begin
  Result := "1111";
  case MW is
    when MEM_BYTE =>
      Result := "1110";

    when MEM_HWORD =>
      Result := "1100";

    when MEM_WORD =>
      Result := "0000";

    when others =>
      null;
  end case;
  return (Result);
end DataEnFunc;

-- -----------------------------------------------------------------------------
-- Function to appropriately assert SMCS lines depending on Bank number.
-- -----------------------------------------------------------------------------
function ChipSelRouteH (
           Hsel              : std_logic_vector(7 downto 0)
                    )
         return std_logic_vector is
variable Result           : std_logic_vector(7 downto 0);
-- return from function

begin
  Result := "00000000";
  case Hsel is
    when BANK0 =>
      Result := "00000001";

    when BANK1 =>
      Result := "00000010";

    when BANK2 =>
      Result := "00000100";

    when BANK3 =>
      Result := "00001000";

    when BANK4 =>
      Result := "00010000";

    when BANK5 =>
      Result := "00100000";

    when BANK6 =>
      Result := "01000000";

    when BANK7 =>
      Result := "10000000";

    when others =>
      null;
  end case;
  return (Result);
end ChipSelRouteH;

-- -----------------------------------------------------------------------------
-- Function to appropriately assert nSMCS lines depending on Bank number.
-- -----------------------------------------------------------------------------
function ChipSelRouteL (
           Hsel              : std_logic_vector(7 downto 0)
                    )
         return std_logic_vector is
variable Result           : std_logic_vector(7 downto 0);
-- return from function

begin
  Result := "11111111";
  case Hsel is
    when BANK0 =>
      Result := "11111110";

    when BANK1 =>
      Result := "11111101";

    when BANK2 =>
      Result := "11111011";

    when BANK3 =>
      Result := "11110111";

    when BANK4 =>
      Result := "11101111";

    when BANK5 =>
      Result := "11011111";

    when BANK6 =>
      Result := "10111111";

    when BANK7 =>
      Result := "01111111";

    when others =>
      null;
  end case;
  return (Result);
end ChipSelRouteL;

-- -----------------------------------------------------------------------------
-- Function to generate the condition for nSMBLS assertion.
-- -----------------------------------------------------------------------------
function ByteLaneFunc (
           MW              : std_logic_vector(1 downto 0);
           Hsize           : std_logic_vector(1 downto 0);
           SMBLSPol        : std_logic;
           ValByteLane0    : std_logic;
           ValByteLane1    : std_logic;
           ValByteLane2    : std_logic;
           ValByteLane3    : std_logic
                      )
         return std_logic_vector is
variable Result           : std_logic_vector(3 downto 0);
-- return from function

variable Temp             : std_logic_vector(3 downto 0);
-- Temporary variable used to hold the concatenation of memory and AHB width

begin
  Temp   := (MW & Hsize);
  Result := ((not SMBLSPol) & (not SMBLSPol) & (not SMBLSPol) & (not SMBLSPol));

  case Temp is
    -- Memory size is Byte, AHB Width can be Byte, HWord, or Word
    when "0000" | "0001" | "0010" =>
      Result := ((not SMBLSPol) & (not SMBLSPol) & (not SMBLSPol) & SMBLSPol);

    -- Memory size is HWord, AHB Width is Byte
    when "0100" =>
      Result(3 downto 2) := ((not SMBLSPol) & (not SMBLSPol));
      if ((ValByteLane1 = '1') or (ValByteLane3 = '1')) then
        Result(1) := SMBLSPol;
      else
        Result(1) := not SMBLSPol;
      end if;

      if ((ValByteLane0 = '1') or (ValByteLane2 = '1')) then
        Result(0) := SMBLSPol;
      else
        Result(0) := not SMBLSPol;
      end if;

    -- Memory size is HWord, AHB Width can be HWord, or Word
    when "0101" | "0110" =>
      Result := ((not SMBLSPol) & (not SMBLSPol) & SMBLSPol & SMBLSPol);

    -- Memory size is Word, AHB Width is Byte and HWord
    when "1000" | "1001" =>
      if (ValByteLane3 = '1') then
        Result(3) := SMBLSPol;
      else
        Result(3) := not SMBLSPol;
      end if;

      if (ValByteLane2 = '1') then
        Result(2) := SMBLSPol;
      else
        Result(2) := not SMBLSPol;
      end if;

      if (ValByteLane1 = '1') then
        Result(1) := SMBLSPol;
      else
        Result(1) := not SMBLSPol;
      end if;

      if (ValByteLane0 = '1') then
        Result(0) := SMBLSPol;
      else
        Result(0) := not SMBLSPol;
      end if;

    -- Memory size is Word, AHB Width is Word
    when "1010" =>
      Result := (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);

    when others =>
      null;
  end case;
  return (Result);
end ByteLaneFunc;

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------


-- Type declarations are NOT allowed in the RTL code.
-- They can be used only for debugging purposes.

-- synopsys translate_on

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Internal Signal Assignments
-- -----------------------------------------------------------------------------
SmCSTSM         <= iSmCSTSM;
SmAddrTSM       <= iSmAddrTSM(1 downto 0);
SMADDRMC        <= iSMADDRMC;
nSMWENMC        <= iSMWENMC;
WaitRdCyc       <= iWaitRdCyc;
WaitRdCycVer    <= iWaitRdCycVer;
WaitWrCycVer    <= WaitWrCycVerAnd;
WaitWrCycDup    <= iWaitWrCycDup;
WaitWrCycAhb    <= iWaitWrCycAhb;
MWWr            <= iMWWr;
HsizeMemBufWr   <= iHsizeMemBufWr;
HsizeEqMWidthWr <= iHsizeEqMWidthWr;
AhbWiderWr      <= iAhbWiderWr;
AhbNarrowWr     <= iAhbNarrowWr;
SMBUSREQ        <= iSMBUSREQ;
SyncEnWriteReg  <= iSyncEnWriteReg;
WaitEnReg       <= iWaitEnReg;
BMWriteReg      <= iBMWriteReg;
WriteBeatCnt    <= iWriteBeatCnt;
WaitStatus      <= not SMWaitSync;
nSmBurstWaitReg <= SyncWtOnMCLK;
Toggle          <= iToggle;
BurstWriteSt    <= iBurstWriteSt;
TurnAroundSt    <= iTurnAroundSt;
WaitTxrOnBusSt  <= iWaitTxrOnBusSt;
WaitDeAssrtSt   <= iWaitDeAssrtSt;
CancelWaitSt    <= iCancelWaitSt;
ClkStpd         <= iClkStpd;
nSMBLSMC        <= iSMBLSMCn;
RBLEWr          <= iRBLEWr;
WBstIntrptd     <= iWBstIntrptd;
TxrB4BsyAccptd  <= iTxrB4BsyAccptd;
IndAssrtd       <= IndAssrt(iSmAddrTSM(6 downto 0), BMRead1, BIReadEn1, MW1);
IncrAddr        <= AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1, HburstMemBuf);
IncrAddrWr      <= AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr, HburstMemBufWr);
WrBtCntCpy      <= BoundChkWr(BurstLenWrReg, iMWWr, iSmAddrTSM(3 downto 0),
                              HburstMemBufWr, iAhbWiderWr, AhbWideWrCnt);

NextAsynAxs      <= iNextAsynAxs;
NextSmOEn        <= iNextSmOEn;       
NxtSMADDRVALIDMC <= iNxtSMADDRVALIDMC;
NextSMBAAMC      <= iNextSMBAAMC;     
NextSMCSMC       <= iNextSMCSMC;      
NextSMCSMCn      <= iNextSMCSMCn;     
NextSMDATAENMCn  <= iNextSMDATAENMCn; 

-- -----------------------------------------------------------------------------
-- Signal Assignments
-- -----------------------------------------------------------------------------
InitSt          <= SmTSMState(0);
ReadSt          <= SmTSMState(1);
BurstReadSt     <= SmTSMState(2);
WriteSt         <= SmTSMState(3);
WaitAssrtSt     <= SmTSMState(8);

iBurstWriteSt   <= SmTSMState(4);
iTurnAroundSt   <= SmTSMState(5);
iWaitTxrOnBusSt <= SmTSMState(6);
iWaitDeAssrtSt  <= SmTSMState(9);
iCancelWaitSt   <= SmTSMState(10);

-- -----------------------------------------------------------------------------
-- This block generates iWaitRdCyc.
-- This signal is sampled in the AHB SM to decide as to whether HREADYOUTSMC
-- will be asserted next clock.
-- WaitRdCycVer which is generated in the Memory SM is suitable AND'ed with
-- External Wait(Both Asynchronous and Synchronous) so that HREADYOUTSMC is
-- not mistakenly driven out.
-- -----------------------------------------------------------------------------
p_MskWtRdCycComb : process (iWaitRdCycVer, SyncEnRead1, SmBurstWaitReg, WaitEn,
                            SMWaitSync, iWaitDeAssrtSt, SleepMode)
begin
  iWaitRdCyc <= '1';
  if ((iWaitRdCycVer = '0') and (SleepMode = '0')) then
    if (SyncEnRead1 = '1') then
      iWaitRdCyc <= not SmBurstWaitReg;
    else
      if ((WaitEn = '1') and (SMWaitSync = '0') and (iWaitDeAssrtSt = '0')) then
        iWaitRdCyc <= '1';
      else
        iWaitRdCyc <= iWaitRdCycVer;
      end if;
    end if;
  end if;
end process p_MskWtRdCycComb;

-- -----------------------------------------------------------------------------
-- This block generates WaitWrCycVerAnd.
-- This signal is sampled in the AHB SM to decide as to whether HREADYOUTSMC
-- will be asserted next clock.
-- WaitWrCycVer which is generated in the Memory SM is suitable anded with
-- External Wait(Synchronous) so that HREADYOUTSMC is not mistakenly driven out.
-- -----------------------------------------------------------------------------
p_AndedDupComb : process (iBurstWriteSt, SyncWtOnMCLK, iWaitWrCycVer)
begin
  WaitWrCycVerAnd <= '1';
  if ((iBurstWriteSt = '0') or (SyncWtOnMCLK = '1')) then
    WaitWrCycVerAnd <= iWaitWrCycVer;
  end if;
end process p_AndedDupComb;

-- -----------------------------------------------------------------------------
-- When synchronous burst write is in progress, the AHB burst is pipelined.
-- Because of this pipelined nature, if memory asserts nSMBURSTWAIT while the
-- AHB burst has changed to new burst then we need to slow down the write
-- pipelining.
-- -----------------------------------------------------------------------------
p_Stop2WtWrCycComb : process (iBurstWriteSt, SyncWtOnMCLK, Stop2WtWrCyc,
                              NewBurst, iHsizeEqMWidthWr, UseSecBuf,
                              iSmCSTSM, HsizeMemBuf1, MW1)
begin
  NextStop2WtWrCyc <= Stop2WtWrCyc;
  if ((iBurstWriteSt = '1') and (iSmCSTSM = '0') and
      (NewBurst = '1') and (Stop2WtWrCyc = '0') and
      (HsizeMemBuf1 = MW1) and
      (iHsizeEqMWidthWr = '1') and (UseSecBuf = '1')) then
    NextStop2WtWrCyc <= '1';
  elsif ((UseSecBuf = '1') and (SyncWtOnMCLK = '1')) then
    NextStop2WtWrCyc <= '0';
  end if;
end process p_Stop2WtWrCycComb;


-- -----------------------------------------------------------------------------
--    M E M O R Y    I N T E R F A C E    S T A T E    M A C H I N E
-- -----------------------------------------------------------------------------
--
-- Summary: State Machine to control the Memory interface for Memory accesses.
--
-- Overview: This state machine will control and generate all Memory related
--           signals. This SM is also responsible for driving out HREADYOUTSMC.
--
-- Summary State Description:
-- ==========================
--
-- ST_NO_REQ       : No Memory Access State.
-- Description     : Default state when Memory accesses are not requested.
-- Entry           : Memory read or write request is sampled de-asserted.
-- Exit            : When Memory read or write request is sampled asserted and
--                   Memory SMBUSGNT is sampled asserted.
-- No change       : When SMBUSGNT is sampled de-asserted.
--
-- ST_READ         : Memory Long Read State.
-- Description     : Long read access in progress.
-- Entry           : When Memory read(Initial read) is requested from AHB.
-- Exit            : When Long Read is completed, or When Wait is asserted for
--                   Wait enabled transfers before the counter expires.
-- No change       : When Long Read is in progress.
--
-- ST_BURST_READ   : Memory Burst Read State.
-- Description     : Burst read access in progress.
-- Entry           : When Memory read(Burst Mode read) is requested from AHB.
-- Exit            : When Burst Read is completed.
-- No change       : When Burst Read is in progress.
--
-- ST_WRITE        : Memory Write State.
-- Description     : Initial write access in progress.
-- Entry           : When Memory write(Initial write) is requested from AHB.
-- Exit            : When Initial Write is completed and there are no further
--                   Memory Write request from AHB, or When Wait is asserted for
--                   Wait enabled transfers before the counter expires.
-- No change       : When Initial Write is in progress.
--
-- ST_BURST_WRITE  : Memory Burst Write State.
-- Description     : Burst write access in progress.
-- Entry           : When Memory write(Burst write) is requested from AHB.
-- Exit            : When Burst Write is completed and there are no further
--                   Memory Write request from AHB, or When Burst boundary is
--                   reached.
-- No change       : When Burst Write is in progress.
--
-- ST_WAIT_TXRONBUS: Wait for the Transfer on AHB State.
-- Description     : Waiting for an accesses on AHB to be completed.
-- Entry           : The SM enters enter this state on following conditions,
--                   a) After finishing single memory read access from ST_READ
--                      state.
--                   b) After finishing burst memory read access from
--                      ST_BURST_READ state.
--                   c) When boundary has reached
-- Exit            : When New Transfer on AHB is sampled.
-- No change       : When New Transfer on AHB is in progress.
--
-- ST_TURNAROUND   : Turnaround State.
-- Description     : Turnaround in progress.
-- Entry           : When TurnAround condition is satisfied in ST_WAIT_TXRONBUS
--                   or ST_WAIT_DEASSERTED or ST_CANCEL_WAIT State.
-- Exit            : When Turnaround is completed.
-- No change       : When Turnaround is in progress.
--
-- ST_WAIT_ASSERTED: Wait Asserted State.
-- Description     : Waiting for SMWAIT De-assertion.
-- Entry           : Before the expiry of Long Burst Read count or Initial Write
--                   count, if SMWAIT is asserted for Wait enabled transfer.
-- Exit            : When SMWAIT is sampled de-asserted.
-- No change       : Until SMWAIT is sampled de-asserted.
--
-- ST_WAIT_DEASSERTED : Wait De-asserted State.
-- Description        : SMWAIT is sampled de-asserted for a Wait enabled
--                      transfer and the current transfer is completed. Waiting
--                      for a new transfer on AHB.
-- Exit               : Unconditional on next active edge.
-- No change          : When New Transfer on AHB is in progress.
--
-- ST_CANCEL_WAIT  : Cancel Wait Asserted State.
-- Description     : Waiting for SMWAIT De-assertion.
-- Entry           : When SMCANCELWAIT is sampled asserted in ST_WAIT_ASSERTED
--                   state.
-- Exit            : When SMWAIT is sampled de-asserted.
-- No change       : Until SMWAIT is sampled de-asserted.
--
-- ST_MEM_DEGRANTED: SsmcCore is Degranted State.
-- Entry           : When Memory Bus is Degranted when further Memory accesses
--                   is pending.
-- Exit            : When SMBUSGNT is sampled asserted.
--
-- Detailed Description:
-- =====================
-- The SM States are described below.
-- ST_NO_REQ State:
--   The SM enters this state on Reset. The SM makes a transition from this
--   state to either ST_READ or ST_WRITE depending on the Memory Read access
--   from AHB or Memory Write Access from AHB, provided SMBUSGNT is sampled
--   asserted. While making a transition to either of two states the
--   Counters (WstBrstRd, WstLongRd, WstWrCnt, WstWrEnCnt, WstOenCnt
--   and BeatCount) are loaded. While making a transition from this state
--   SmCSTSM is asserted and SmAddrTSM are driven with the Registered value in
--   AHB Memory SM. If the WSTOEN is programmed as zero, then SmOEn is
--   asserted while making a state transition to ST_READ state along with
--   SmCSTSM. If the WSTWEN is programmed as zero, then nSMWEN is asserted
--   while making a state transition to ST_WRITE state along with SmCSTSM. In
--   this state SMBUSREQ is raised.
--
-- ST_READ State:
--   From this state the SM can make a transition to ST_WAIT_TXRONBUS or
--   ST_BURST_READ state. SM will make a transition to ST_BURST_READ state if
--   BM bit is set, and BeatCount is indicating more than 1 transfer.
--   The SM will make a transition to ST_WAIT_TXRONBUS if SmCSTSM is sampled
--   de-asserted. Transitions to these states are done after ensuring that the
--   WstLongRd counter had expired.
--   While making a state transition to ST_BURST_READ state the SmCSTSM is
--   continued to be asserted. After the first long read the BeatCount (counter
--   indicates the number of access from AHB side) and BeatCount (counter
--   indicates the number of access possible, this restriction might be for
--   memory boundary) counters are decremented when WaitRdCyc is sampled low.
--   If it is a wait enabled transfer and if the Wait is asserted before the
--   WstLongRd counter expires then state transition will happen to
--   ST_WAIT_ASSERTED state.
--
-- ST_BURST_READ State:
--   In this state following conditions can happen while burst is progressing
--   Busy Insertion from Master:
--     In this case the SmAddrTSM would have been incremented, so by the time
--     the SM sees the registered BUSY signal, the SmAddrTSM would have
--     progressed ahead of HADDRSMC, the BeatCount would have
--     decremented.
--     Hence if HREADYOUTSMC is asserted immediately for the SEQ transfer
--     following BUSY access, there will be wrong data on the HRDATASMC lines.
--     To prevent this, in the AHB Memory SM care is taken such that immediately
--     after BUSY access if a SEQ access happens then HREADYOUTSMC is
--     de-asserted. Also, the Counters are not updated when the registered BUSY
--     is seen and SMDATAIN is not clocked into the Register.
--   Break in Burst initiated by Master:
--     When the NewBurst indication is sampled asserted in this state then
--     Turnaround is done, before honouring the new burst.
--
-- ST_WRITE State:
--   The SM enters this state after asserting SmCSTSM, and drives out SmAddrTSM.
--   nSMWEN is asserted depending on the delay value programmed in the WSTWEN
--   register. When the write is happening to Asynchronous devices the nSMWEN
--   signal is de-asserted after every write. This signal is asserted again
--   based on further MemWrReq and delay value programmed in WSTWEN register.
--   The state transitions happen after the de-assertion of nSMWEN signal.
--   State transition can happen to ST_BURST_WRITE state if there is further
--   MemWrReq from AHB side and BMWrite bit and SyncEnWrite is set.
--   In this state the signal WaitWrCycVer will decide as to when the
--   HREADYOUTSMC has to be driven high for the current Write access.
--   In this state if MemRdReq is sampled asserted after the current write
--   access then the SM will make a state transition to ST_READ state.
--   In this state if there are no further Memory access requests then the
--   state transition happens to ST_NO_REQ state.
--   If it is a wait enabled transfer and if the Wait is asserted before the
--   WstWrCnt counter expires then state transition will happen to
--   ST_WAIT_ASSERTED state.
--   If there are further Memory accesses and Memory Bus is degranted then SM
--   will make a transition to ST_MEM_DEGRANTED State.
--
-- ST_BURST_WRITE State:
--   The SM enters this state if a burst write has to be performed for
--   Synchronous Burst devices. In this state the HREADYOUTSMC is driven high
--   on every clock when WaitWrCycVer is de-asserted. This is possible until
--   there SmBurstWaitReg signal is not sampled high. When SmBurstWaitReg
--   is asserted then WaitWrCycVer is asserted and HREADYOUTSMC is driven low.
--   When a NewBurst signal is encountered then state transition can happen to
--   ST_WRITE state or ST_READ state depending on whether it is a MemRdReq or
--   MemWrReq. If no Memory access is requested then state transition will
--   happen to ST_NO_REQ state.
--
-- ST_WAIT_TXRONBUS State:
--   The SM enters enter this state on following conditions,
--   a) After finishing single memory read access from ST_READ state.
--   b) After finishing burst memory read access from ST_BURST_READ state.
--   d) When boundary has reached (BeatCount expiring) then
--      remaining read access has to be performed.
--   This state was added so that after the current read access the pipelined
--   access is registered by the AHB Memory SM, is sampled in this state, and
--   based on the turnaround information SM can make a state transition to
--   either ST_READ, ST_WRITE or ST_TURNAROUND states.
--   If there are further Memory accesses and Memory Bus is degranted then SM
--   will make a transition to ST_MEM_DEGRANTED State.
--   If no Memory access is requested then state transition will happen to
--   ST_NO_REQ state.
--
-- ST_TURNAROUND State:
--   Turnaround is done on following conditions,
--   a) Read followed by Write to same Bank.
--   b) Read followed by Write to different Bank.
--   c) Read followed by Read to different Bank.
--   d) After Single Read and if IDCYC values are programmed (before
--      de-asserting SMBUSREQ, as there is no further memory accesses).
--   e) After Single Burst Read and if IDCYC values are programmed (before
--      de-asserting SMBUSREQ, as there is no further memory accesses).
--   f) When TimeOutErr has occurred for Read access and if IDCYC values are
--      programmed.
--   g) When WaitEnabled transfer has completed successfully for Read access
--      and if IDCYC values are programmed (before de-asserting SMBUSREQ, as
--      there is no further memory accesses).
--   From this State, transition will happen to ST_READ state if MemRdReq is
--   sampled asserted. State transition will happen to ST_WRITE state if
--   MemWrReq is sampled asserted, else state transition will happen to
--   ST_NO_REQ state.
--   If there are further Memory accesses and Memory Bus is degranted then SM
--   will make a transition to ST_MEM_DEGRANTED State.
--
-- ST_WAIT_ASSERTED State:
--   SM enters this state in case of wait enabled transfers and if the SMWAIT
--   is sampled asserted before WSTRD counter expires in case of Read transfer
--   and WSTWR counter in case of Write transfer. Once the SMWAIT is asserted
--   then SM will wait in this state till SMWAIT is de-asserted. When SMWAIT is
--   sampled de-asserted, SM makes a transition to ST_WAIT_DEASSERTED state. In
--   this state if SMCANCELWAIT is sampled asserted, state transition will
--   happen to ST_CANCEL_WAIT state.
--
-- ST_WAIT_DEASSERTED State:
--   From this state transition will happen to ST_TURNAROUND state if there was
--   no further read request pending, the current waited transfer was read and
--   IDCYC value was programmed for non-zero value. SM will make a state
--   transition to ST_READ state if there is pending read request. SM will make
--   a state transition to ST_WRITE state if there is pending write request.
--
-- ST_CANCEL_WAIT State:
--   From this state SM transition will happen to ST_TURNAROUND state if there
--   was TimeOutErr for Read access and IDCYC register was programmed with a
--   non-zero value, else SM will make a state transition to ST_NO_REQ state.
--
-- ST_MEM_DEGRANTED State:
--   From this state State transition will happen to either ST_READ or ST_WRITE
--   depending on MemRdReq or MemWrReq.

-- The DBI uses the SMBUSGNT line to indicate when there is a successful grant
-- of the Bus to the SSMC.
-- -----------------------------------------------------------------------------
p_MemTSMComb : process (SmTSMState, iSmCSTSM, iSmOEnMC, iSMWENMC, iWaitRdCycVer,
                        iWaitWrCycVer, iSmAddrTSM, RBLE, WstOEnCnt, BUSYCYC,
                        WstBrstRdCnt, WstWrCnt, WstWrEnCnt, iSMADDRVALIDMC,
                        BeatCount, iSMBAAMC, IDCYRead, IdcyCount,
                        iWaitWrCycDup, iWriteBeatCnt, SMBUSGNT, WrapRead,
                        MemRdReq, WSTOEN1, WaitEn, AddrValidReadEn1, MemWrReq,
                        WSTWEN, HtranRegCont, BMRead1, SyncEnRead1, SMWaitSync,
                        SleepMode, WSTBRD1, IDCYC, MW, TurnAround, IDLECYC,
                        BurstLenRead1, AhbCount, AddrBuf, SyncEnWrite, BMWrite,
                        WaitWrCycVerAnd, DelSMWENMC, AhbWideWrCnt, WstLongRdCnt,
                        SmCancelWaitSync, WSTRD1, WSTWR, iWaitRdCyc, NewBurst,
                        BurstLenWrite, iToggle, HselMemBufWr, HselMemBuf,
                        HburstMemBuf, IncrAddr, HsizeEqMWidth, HsizeMemBuf,
                        AddrValidWriteEn, WriteProg, iMWWr, iHsizeEqMWidthWr,
                        iAhbWiderWr, iAhbNarrowWr, iRBLEWr, iHsizeMemBufWr,
                        iWaitEnReg, iSMBUSREQ, AddrNotAligned, iSyncEnWriteReg,
                        iBMWriteReg, BurstLenWrReg, AddrValWrEnReg, AhbNarrow,
                        AhbWider, iWaitWrCycAhb, WSTWRReg, WSTWENReg,
                        HselMemBuf1, WRITECYC, ClockRatio, SmBurstWaitReg,
                        AhbWideRdCnt, AhbWideRdReg, StopBurst, HtransMemBuf1,
                        ContWithBrst, DelSmBurstWait, SMClockEn, iClkStpd,
                        IndAssrtd, BIWriteEn, BIWriteEnReg, DelAhbWideWrCnt,
                        SMBLSPol,
                        SMBLSPolWr, SyncWtOnMCLK, NewBrstOccrd, iSMADDRMC,
                        IncrAddrWr, MW1, AddrBuf1, HsizeMemBuf1, WrBtCntCpy,
                        UseSecBuf, iSMDATAENMCn, iSMCSMC, iSMCSMCn, iSMBLSMCn,
                        NextValByteLane0, NextValByteLane1, NextValByteLane2,
                        NextValByteLane3, BIReadEn1, iAsynAxs, HburstMemBufWr,
                        iWBstIntrptd, FirstSyncWt, XtraTxr, DelWaitWrCycVer,
                        iTxrB4BsyAccptd, DelUseSecBuf)
variable Temp : std_logic_vector(4 downto 0);
begin
  Temp := ("00" & AhbWideRdCnt);
  -- Default Assignments
  NextSmTSMState     <= SmTSMState;
  NextSmCSTSM        <= iSmCSTSM;
  iNextSmOEn          <= iSmOEnMC;
  NextSmWrEn         <= iSMWENMC;
  NextWaitRdCycVer   <= iWaitRdCycVer;
  NextWaitWrCycVer   <= iWaitWrCycVer;
  NextSMBUSREQ       <= iSMBUSREQ;
  NextWaitWrCycDup   <= iWaitWrCycDup;
  NextWaitWrCycAhb   <= iWaitWrCycAhb;
  NextSmAddrTSM      <= iSmAddrTSM;
  NextSMADDRMC       <= iSMADDRMC;
  NextWstOEnCnt      <= WstOEnCnt;
  NextWstLongRdCnt   <= WstLongRdCnt;
  NextWstBrstRdCnt   <= WstBrstRdCnt;
  NextWstWrCnt       <= WstWrCnt;
  NextWstWrEnCnt     <= WstWrEnCnt;
  iNxtSMADDRVALIDMC   <= iSMADDRVALIDMC;
  iNextSMBAAMC        <= iSMBAAMC;
  NextBeatCount      <= BeatCount;
  NextIDCYRead       <= IDCYRead;
  NextIdcyCount      <= IdcyCount;
  NextWriteBeatCnt   <= iWriteBeatCnt;
  NextToggle         <= iToggle;
  NextHselMemBufWr   <= HselMemBufWr;
  NextHburstMemBufWr <= HburstMemBufWr;
  NextMWWr           <= iMWWr;
  NextSMBLSPolWr     <= SMBLSPolWr;
  NxtHsizeMemBufWr   <= iHsizeMemBufWr;
  NextHsizeEqMW      <= iHsizeEqMWidthWr;
  NextAhbWiderWr     <= iAhbWiderWr;
  NextAhbNarrowWr    <= iAhbNarrowWr;
  NextRBLEWr         <= iRBLEWr;
  NextWaitEnReg      <= iWaitEnReg;
  NextSyncEnWr       <= iSyncEnWriteReg;
  NextBMWriteReg     <= iBMWriteReg;
  NextBIWriteEnReg   <= BIWriteEnReg;
  NextBurstLenWr     <= BurstLenWrReg;
  NextAddrValWrReg   <= AddrValWrEnReg;
  NextWSTWRReg       <= WSTWRReg;
  NextWSTWENReg      <= WSTWENReg;
  NextWriteProg      <= WriteProg;
  NextAhbWideRdReg   <= AhbWideRdReg;
  NextStopBurst      <= StopBurst;
  NextClkStpd        <= iClkStpd;
  NextNewBrstOccrd   <= NewBrstOccrd;
  iNextSMCSMC         <= iSMCSMC;
  iNextSMCSMCn        <= iSMCSMCn;
  iNextSMDATAENMCn    <= iSMDATAENMCn;
  NextSMBLSMCn       <= iSMBLSMCn;
  iNextAsynAxs        <= iAsynAxs;
  NextWBstIntrptd    <= iWBstIntrptd;
  NextFirstSyncWt    <= FirstSyncWt;
  NextXtraTxr        <= XtraTxr;
  NextTxrB4BsyAccptd <= iTxrB4BsyAccptd;

  case SmTSMState is
    when ST_NO_REQ =>
      if (SMBUSGNT = '1') then

        -- Make a state transition only when SMBUSGNT and MemWrReq is sampled
        -- high. Higher priority is given to Write.
        if (MemWrReq = '1') then
          NextHselMemBufWr   <= HselMemBuf;
          NextHburstMemBufWr <= HburstMemBuf;
          NextSMBLSPolWr     <= SMBLSPol;
          NextMWWr           <= MW;
          NxtHsizeMemBufWr   <= HsizeMemBuf;
          NextHsizeEqMW      <= HsizeEqMWidth;
          NextAhbWiderWr     <= AhbWider;
          NextAhbNarrowWr    <= AhbNarrow;
          NextRBLEWr         <= RBLE;
          NextWaitEnReg      <= WaitEn;
          NextSyncEnWr       <= SyncEnWrite;
          NextBMWriteReg     <= BMWrite;
          NextBIWriteEnReg   <= BIWriteEn;
          NextBurstLenWr     <= BurstLenWrite;
          NextAddrValWrReg   <= AddrValidWriteEn;
          NextWSTWRReg       <= WSTWR;
          NextWSTWENReg      <= WSTWEN;
          NextSmCSTSM        <= '0';
          iNextSMCSMC         <= ChipSelRouteH(HselMemBuf);
          iNextSMCSMCn        <= ChipSelRouteL(HselMemBuf);
          iNextSMDATAENMCn    <= DataEnFunc(MW);
          NextSmTSMState     <= ST_WRITE;
          NextWstWrCnt       <= WSTWR;

          -- Assertion of WaitWrCycAhb signal for Synchronous Write transfers.
          if ((WSTWR = "00000") and (SyncEnWrite = '1') and
              (AddrNotAligned = '0') and
              (BMWrite = '1') and (HsizeEqMWidth = '1')) then
            NextWaitWrCycAhb <= '0';
          else
            NextWaitWrCycAhb <= '1';
          end if;
          
          -- logic to assert nSMBLSMC
          if ((RBLE = '1') or (SyncEnWrite = '1') or
              ((WSTWEN = "0000") or (WaitEn = '1'))) then
            NextSMBLSMCn <= ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                         NextValByteLane0, NextValByteLane1,
                                         NextValByteLane2, NextValByteLane3);
          end if;

          -- Start asserting SmWrEn if it is wait enabled transfer or if the
          -- WSTWEN counter is programmed as zero.
          if ((WSTWEN = "0000") or (WaitEn = '1')) then
            NextSmWrEn     <= '0';
            NextWstWrEnCnt <= (others => '0');
          else
            -- The count is decremented and loaded so that in ST_WRITE state
            -- the implementation becomes uniform where it waits for this count
            -- to decrement to 0, when re-assertion of SMWEN is required.
            NextWstWrEnCnt <= unsigned(WSTWEN) - 1;
          end if;

          NextSmAddrTSM <= AddrBuf;
          NextSMADDRMC  <= ShiftAddr(AddrBuf, MW);

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidWriteEn = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnWrite = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

          -- Control signal used in Pad Interface to distinguish Async and
          -- Sync Access.
          iNextAsynAxs <= not SyncEnWrite;

        -- Make a state transition only when SMBUSGNT and MemRdReq is sampled
        -- high.
        elsif (MemRdReq = '1') then
          NextSmCSTSM      <= '0';
          iNextSMCSMC       <= ChipSelRouteH(HselMemBuf1);
          iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf1);
          iNextSMDATAENMCn  <= (others => '1');
          NextSmTSMState   <= ST_READ;
          NextWstBrstRdCnt <= WSTBRD1;
          NextSmAddrTSM    <= AddrBuf1;
          NextSMADDRMC     <= ShiftAddr(AddrBuf1, MW1);
          NextIDCYRead     <= IDCYC;
          NextBeatCount    <= BoundaryChk(AddrBuf1(5 downto 0), AhbCount,
                                          BurstLenRead1, MW1, HburstMemBuf,
                                          WrapRead, SyncEnRead1, HsizeMemBuf1,
                                          BMRead1);

          -- Start asserting SmOEn if it is wait enabled transfer or if the
          -- WSTOEN1 counter is programmed as zero.
          if ((WSTOEN1 = "0000") or (WaitEn = '1')) then
            iNextSmOEn     <= '0';
          else
            NextWstOEnCnt <= WSTOEN1;
          end if;

          -- logic to assert nSMBLSMC
          if ((RBLE = '1') and (MW1 /= MEM_BYTE)) then
            NextSMBLSMCn <= (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);
          else
            NextSMBLSMCn <= "1111";
          end if;

          -- Start asserting WaitRdCyc if WSTRD1 counter is programmed as zero,
          -- in case of Asynchronous memories. Otherwise load the Long Read
          -- counter. This distinction is done because Asynchronous Memory
          -- accesses has to be By-passed.
          if ((WSTRD1 = "00000") and (SyncEnRead1 = '0')) then
            NextWaitRdCycVer <= '0';
            NextWstLongRdCnt <= (others => '0');
          else
            NextWstLongRdCnt <= WSTRD1;
          end if;

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidReadEn1 = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Control signal used in Pad Interface to distinguish Async and
          -- Sync Access.
          iNextAsynAxs <= not SyncEnRead1;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnRead1 = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

        end if;
      end if;

      -- Assert SMBUSREQ the moment request is sampled high for Memory access.
      NextSMBUSREQ <= MemWrReq or MemRdReq;

    when ST_READ =>
      -- Decrement the BeatCount register only when WaitRdCyc = 0
      -- condition is satisfied.
      if (iWaitRdCyc = '0') then
        if (((HtranRegCont = HTRANS_NSEQ) or (HtranRegCont = HTRANS_IDLE)) and
            (HsizeEqMWidth = '1')) then
          NextBeatCount <= (others => '0');
        elsif (BeatCount /= "00000") then
          NextBeatCount <= unsigned(BeatCount) - 1;
        end if;
      end if;

      if (NewBurst = '1') then
        NextNewBrstOccrd <= '1';
      end if;

      -- Make the State Transition after CS is de-asserted in normal case.
      if (iSmCSTSM = '1') then
        NextSmTSMState   <= ST_WAIT_TXRONBUS;
        NextWaitRdCycVer <= '1';
        NextAhbWideRdReg <= AhbWideRdCnt;
        NextToggle       <= '1';
      end if;

      -- If Synchronous memories are attempting to do Read transfers then
      -- de-assert SMADDRVALIDMC so that it appears as pulse.
      if ((AddrValidReadEn1 = '1') and (iSMADDRVALIDMC = '0') and
          (SyncEnRead1 = '1')) then
        iNxtSMADDRVALIDMC <= '1';
      end if;

      -- If SmOEn is not asserted, and if the WstOEnCnt counter has not
      -- down-counted to 1 then continue to de-assert SmOEn. When this counter
      -- decrements to 1, flush the counter.
      if ((iSmOEnMC = '1') and (WstOEnCnt = "0001") and (iSmCSTSM = '0')) then
        iNextSmOEn     <= '0';
        NextWstOEnCnt <= (others => '0');
      elsif (iSmOEnMC = '1') then
        NextWstOEnCnt <= unsigned(WstOEnCnt) - 1;
      end if;

      -- (iSmCSTSM = '0') condition is included so that when there is a single
      -- read, we will be in this state till iSmCSTSM is de-asserted, so the SM
      -- should execute this block only when iSmCSTSM is asserted.
      -- (iSMADDRVALIDMC = '1') or (SyncEnRead1 = '0') condition ensures that,
      -- Synchronous memories it has to wait till SMADDRVALIDMC is de-asserted.
      if ((WstLongRdCnt = "00000") and (iSmCSTSM = '0') and
          ((iSMADDRVALIDMC = '1') or (SyncEnRead1 = '0'))) then

        -- Even if the Long read counter expired and if wait is asserted we
        -- should not assume that the read is over. we have to wait till the
        -- wait is de-asserted or cancelwait is asserted. Waited transfer has
        -- highest priority then normal transfer.
        if ((WaitEn = '1') and (SMWaitSync = '0')) then
          NextSmTSMState   <= ST_WAIT_ASSERTED;
          NextAhbWideRdReg <= AhbWideRdCnt;
          iNextSmOEn        <= '0';
          NextWaitRdCycVer <= '1';
          iNextSMBAAMC      <= '1';

        -- Since it is a wait enabled transfer do not do any burst transfers.
        elsif (WaitEn = '1') then
          NextSmCSTSM      <= '1';
          iNextSMCSMC       <= (others => '0');
          iNextSMCSMCn      <= (others => '1');
          iNextSMDATAENMCn  <= (others => '1');
          NextSMBLSMCn     <= (others => '1');
          iNextSMBAAMC      <= '1';
          iNextSmOEn        <= '1';
          iNxtSMADDRVALIDMC <= '1';
          NextWaitRdCycVer <= '1';

        -- Burst got broken, or it was a single transfer or degranted
        elsif (((((HtranRegCont = HTRANS_NSEQ) or
                  (HtranRegCont = HTRANS_IDLE)) and (HsizeEqMWidth = '1')) or
                (BMRead1 = '0') or (IndAssrtd = '0') or
                (BeatCount = "00001")) and (iWaitRdCyc = '0') and
               (  -- prevent TSM hanging when SmBurstWait low during 
                  -- an async read
               (SmBurstWaitReg = '1') or
               (BMRead1 = '0')        or
               (SyncEnRead1 = '0')
               )) then
          NextSmCSTSM      <= '1';
          iNextSMCSMC       <= (others => '0');
          iNextSMCSMCn      <= (others => '1');
          iNextSMDATAENMCn  <= (others => '1');
          NextSMBLSMCn     <= (others => '1');
          iNextSMBAAMC      <= '1';
          iNextSmOEn        <= '1';
          iNxtSMADDRVALIDMC <= '1';
          NextWaitRdCycVer <= '1';

        -- Burst Request, Grant is sampled asserted, continue with Burst
        -- transfers when more than one Memory accesses needs to be performed.
        elsif ((BMRead1 = '1') and (IndAssrtd = '1') and
               (BeatCount /= "00001")) then
          NextSmTSMState <= ST_BURST_READ;
          if (SyncEnRead1 = '0') then
            NextSmAddrTSM <= AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                      HburstMemBuf);
            NextSMADDRMC  <= ShiftAddr(IncrAddr, MW1);
          end if;
          -- For Asynchronous Memories De-Assert WaitRdCycVer when WstBrstRdCnt
          -- is 0. Otherwise Assert WaitRdCycVer for Asynchronous Memories.
          -- For Synchronous memories De-Assert WaitRdCycVer while making a
          -- State transition.
          if (SyncEnRead1 = '0') then
            if (WstBrstRdCnt = "00000") then
              NextWaitRdCycVer <= '0';
            else
              NextWaitRdCycVer <= '1';
            end if;
          else
            NextWaitRdCycVer <= '0';
            NextWstBrstRdCnt <= (others => '0');
          end if;
        else
          NextWaitRdCycVer <= '0';
        end if;
      else
        -- Then decrement the WstLongRdCnt value and De-Assert WaitRdCyc when
        -- Count is 1. If it is Synchronous burst read then wait for
        -- SMADDRVALIDMC to be de-asserted.
        if (((SyncEnRead1 = '0') or (iSMADDRVALIDMC = '1')) and
            (WstLongRdCnt /= "00000")) then
          NextWstLongRdCnt <= unsigned(WstLongRdCnt) - 1;
        end if;

        -- Start asserting SMBAAMC when there is a Synchronous access and BMRead
        -- is enabled. This will be de-asserted along with nSMCS.
        if ((SyncEnRead1 = '1') and (BMRead1 = '1') and
            (WstLongRdCnt(4 downto 1) = "0000") and (iSmCSTSM = '0') and
            (BeatCount(4 downto 1) /= "0000") and (BIReadEn1 = '1')) then
          iNextSMBAAMC <= '0';
        end if;

        -- De-Assert WaitRdCyc when WstLongRdCnt Count is 1 for Asynchronous
        -- Memory.
        if ((WstLongRdCnt = "00001") and (SyncEnRead1 = '0')) then
          NextWaitRdCycVer <= '0';
        else
          NextWaitRdCycVer <= '1';
        end if;

        -- If Wait Enabled Transfer is there then make a state transition to
        -- ST_WAIT_ASSERTED state.
        if ((WaitEn = '1') and (SMWaitSync = '0') and (iSmCSTSM = '0')) then
          NextSmTSMState   <= ST_WAIT_ASSERTED;
          NextAhbWideRdReg <= AhbWideRdCnt;
          iNextSmOEn        <= '0';
          NextWaitRdCycVer <= '1';
        end if;
      end if;

    when ST_BURST_READ =>
      -- Decrement BeatCount counter when there is no Busy
      -- sampled. If a Busy transfer is driven and Memory accesses is finished
      -- for this read accesses then enter into a sleep mode where all control
      -- signals are freezed till the AHB comes up with SEQ transfer for the
      -- Busy transfer driven. If NSEQ is driven from BUSY transfer then the
      -- Counters needs to be flushed. This is done in state transition logic.
      if ((SleepMode = '0') and (iWaitRdCyc = '0')) then
        if (((((HtranRegCont = HTRANS_NSEQ) or (HtranRegCont = HTRANS_IDLE)) or
              ((SyncEnRead1 = '1') and (HtranRegCont = HTRANS_BUSY))) and
             (HsizeEqMWidth = '1')) or
             (NewBurst = '1') or (HtransMemBuf1 = HTRANS_IDLE) or
             ((SleepMode = '1') and (SyncEnRead1 = '1'))) then
          NextBeatCount <= (others => '0');
        elsif (BeatCount /= "00000") then
          NextBeatCount <= unsigned(BeatCount) - 1;
        end if;
      end if;
      
      if ((NewBurst = '1') or ((SleepMode = '1') and (SyncEnRead1 = '1'))) then
        NextNewBrstOccrd <= '1';
      end if;

      -- Make the State Transition after CS is de-asserted in normal case
      if (iSmCSTSM = '1') then
        NextSmTSMState   <= ST_WAIT_TXRONBUS;
        NextWaitRdCycVer <= '1';
        NextAhbWideRdReg <= AhbWideRdCnt;
        NextToggle <= '1';
      end if;

      -- (iSmCSTSM = '0') condition is included so that when there is a single
      -- read, we will be in this state till iSmCSTSM is de-asserted, so the SM
      -- should execute this block only when iSmCSTSM is asserted.
      if (((WstBrstRdCnt = "00000") or ((NewBurst or NewBrstOccrd) = '1')) and
          (iSmCSTSM = '0')) then
        -- Burst got broken, or the transfer got completed
        if (((((((HtranRegCont = HTRANS_NSEQ) or
                 (HtranRegCont = HTRANS_IDLE)) or
                ((SyncEnRead1 = '1') and (HtranRegCont = HTRANS_BUSY))) and
               (HsizeEqMWidth = '1')) or
              (IndAssrtd = '0') or (NewBurst = '1') or
              (NewBrstOccrd = '1') or
              (HtransMemBuf1 = HTRANS_IDLE) or (IDLECYC = '1') or
              ((BeatCount = "00001") and (SleepMode = '0'))) and
             (SmBurstWaitReg = '1')) or
            ((SleepMode = '1') and (SyncEnRead1 = '1'))) then
          NextSmCSTSM      <= '1';
          iNextSMCSMC       <= (others => '0');
          iNextSMCSMCn      <= (others => '1');
          iNextSMDATAENMCn  <= (others => '1');
          NextSMBLSMCn     <= (others => '1');
          iNextSMBAAMC      <= '1';
          iNextSmOEn        <= '1';
          iNxtSMADDRVALIDMC <= '1';
          NextWaitRdCycVer <= '1';

        -- Grant is sampled asserted, continue with Burst transfers
        elsif (SleepMode = '0') then
          -- (SmBurstWaitReg = '1') condition ensures that for Synchronous
          -- memories until SmBurstWtFbClk is high it will not increment the
          -- address, for Asynchronous memory condition (SyncEnRead1 = '0') is
          -- sufficient to carry out the increment
          if ((SmBurstWaitReg = '1') or (SyncEnRead1 = '0')) then
            NextSmAddrTSM <= AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                      HburstMemBuf);
            if (SyncEnRead1 = '0') then
              NextSMADDRMC <= ShiftAddr(IncrAddr, MW1);
            end if;
          end if;

          -- Assert WaitRdCyc if WSTBRD1 = "00000" and it is an Asynchronous
          -- Memories. For Synchronous Memories it can be asserted without
          -- comparison with WSTBRD1 because, WSTBRD1 has no meaning for
          -- Synchronous Memories.
          if ((SyncEnRead1 = '0') and (WSTBRD1 /= "00000")) then
            NextWaitRdCycVer <= '1';
          else
            --NextWaitRdCycVer <= '0';
            NextWaitRdCycVer <= (NewBurst or NewBrstOccrd);
          end if;

          if (SyncEnRead1 = '0') then
            NextWstBrstRdCnt <= WSTBRD1; -- Reload the Counter
          end if;

        elsif ((BUSYCYC = '0') and (HsizeEqMWidth = '1')) then
          NextWaitRdCycVer <= '1'; 
        end if;
      else
        -- Decrement the WstBrstRdCnt value if WstBrstRdCnt /= "00000"
        -- condition and BUSY insertion conditions are taken into consideration.
        if (WstBrstRdCnt /= "00000") then
          if ((WstBrstRdCnt > "00001") or
              ((WstBrstRdCnt = "00001") and (SleepMode = '0'))) then
            NextWstBrstRdCnt <= unsigned(WstBrstRdCnt) - 1;
          end if;
        end if;

        -- De-Assert WaitRdCyc when WstBrstRdCnt Count is 1 for Asynch Memory.
        -- SleepMode = '0' condition ensures that WaitRdCycVer is not
        -- De-asserted when BUSY is progressing.
        if ((WstBrstRdCnt = "00001") and (SyncEnRead1 = '0') and
            (SleepMode = '0') and ((NewBurst or NewBrstOccrd) = '0') and
            (iSmCSTSM = '0')) then
          NextWaitRdCycVer <= '0';
        else
          NextWaitRdCycVer <= '1';
        end if;
      end if;

    when ST_WAIT_TXRONBUS =>
    -- The SM enters this state on following conditions.
    -- a) After single request is serviced from ST_READ state, so that decision
    --    can be taken as to move to TurnAround(IDYC value /=0) or Idle State.
    -- b) After Burst Request has been completed from ST_BURST_READ state, so
    --    that decision can be taken as to move to TurnAround(IDYC value /=0) or
    --    Idle State.
    -- c) When Burst was broken in the middle of the Burst, from ST_BURST_READ
    --    state, or ST_READ state so that decision can be taken as to move to
    --    TurnAround(IDYC value /=0) or Idle state.
    -- d) When Degranted happened in the middle of the Burst mode devices burst
    --    from ST_BURST_READ state, so that decision can be taken as to move to
    --    TurnAround(IDYC value /=0) or Degranted state.
    --
    -- The IDCYC values to be used that of previous completed read transfer.


      -- TurnAround is required if Previous State was Read and Current Transfer
      -- is Write(With IDCYread value programmed), or Read to a different Memory
      -- Bank(With IDCYRead value programmed) or Grant is not there and IDCY
      -- value programmed or there was a break in burst or single read and we
      -- have to do TurnAround if IDCYRead is programmed before giving up the
      -- Memory Bus.
      NextNewBrstOccrd <= '0';
      if (NewBurst = '1') then
        NextAhbWideRdReg <= (others => '0');
      end if;
      if (((TurnAround = '1') and (IDCYRead /= "0000")) or
          ((IDCYRead /= "0000") and (MemRdReq = '0'))) then
        NextSmTSMState   <= ST_TURNAROUND;
        NextIdcyCount    <= IDCYRead;
        NextWaitRdCycVer <= '1';

      -- If Grant is not there and Turnaround is not required, then move to
      -- Degranted state if any further Memory Accesses is requested.
      elsif ((SMBUSGNT = '0') and ((MemRdReq = '1') or (MemWrReq = '1'))) then
        NextSmTSMState   <= ST_MEM_DEGRANTED;
        NextSMBUSREQ     <= '0';
        NextWaitRdCycVer <= '1';

      -- If SMBUSGNT is sampled asserted and there are pending Read transfers
      -- to be performed(bcoz of break in burst) or NewBurst has been sampled
      -- then SM makes a transition to ST_READ state by loading the counters.
      elsif ((MemRdReq = '1') and (MemWrReq = '0')) then
        NextSmCSTSM      <= '0';
        iNextSMCSMC       <= ChipSelRouteH(HselMemBuf1);
        iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf1);
        iNextSMDATAENMCn  <= (others => '1');
        NextSmTSMState   <= ST_READ;
        NextWstBrstRdCnt <= WSTBRD1;
        -- It is added here because there is a possibility of this being
        -- corrupted, while running freq runs.
        NextIDCYRead     <= IDCYC;
        if ((AhbWideRdCnt /= "000") and (AhbWider = '1') and
            (NewBurst = '0') and (NewBrstOccrd = '0')) then
          NextSmAddrTSM <= AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                    HburstMemBuf);
          NextSMADDRMC  <= ShiftAddr(IncrAddr, MW1);
          NextBeatCount <= BoundaryChk(IncrAddr(5 downto 0), AhbCount,
                                       BurstLenRead1, MW1, HburstMemBuf,
                                       WrapRead, SyncEnRead1, HsizeMemBuf1,
                                       BMRead1);
        else
          NextSmAddrTSM <= AddrBuf1;
          NextSMADDRMC  <= ShiftAddr(AddrBuf1, MW1);
          NextBeatCount <= BoundaryChk(AddrBuf1(5 downto 0), AhbCount,
                                       BurstLenRead1, MW1, HburstMemBuf,
                                       WrapRead, SyncEnRead1, HsizeMemBuf1,
                                       BMRead1);
        end if;

        -- Start asserting SmOEn if it is wait enabled transfer or if the
        -- WSTOEN1 counter is programmed as zero.
        if ((WSTOEN1 = "0000") or (WaitEn = '1')) then
          iNextSmOEn     <= '0';
        else
          NextWstOEnCnt <= WSTOEN1;
        end if;

        -- logic to assert nSMBLSMC
        if ((RBLE = '1') and (MW1 /= MEM_BYTE)) then
          NextSMBLSMCn <= (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);
        else
          NextSMBLSMCn <= "1111";
        end if;

        -- Start asserting WaitRdCyc if WSTRD1 counter is programmed as zero,
        -- in case of Asynchronous memories. Otherwise load the Long Read
        -- counter. This distinction is done because Asynchronous Memory
        -- accesses has to be By-passed.
        if ((WSTRD1 = "00000") and (SyncEnRead1 = '0')) then
          NextWaitRdCycVer <= '0';
          NextWstLongRdCnt <= (others => '0');
        else
          NextWstLongRdCnt <= WSTRD1;
        end if;

        -- If Synchronous memories are attempting to do an Asynchronous
        -- transfers then assert SMADDRVALIDMC along with SmCS.
        if (AddrValidReadEn1 = '1') then
          iNxtSMADDRVALIDMC <= '0';
        else
          iNxtSMADDRVALIDMC <= '1';
        end if;

        -- Control signal used in Pad Interface to distinguish Async and
        -- Sync Access.
        iNextAsynAxs <= not SyncEnRead1;

        -- Prevent clock stopping if Synchronous memory access is required
        if ((SMClockEn = '0') and (SyncEnRead1 = '0')) then
          NextClkStpd <= '1';
        else
          NextClkStpd <= '0';
        end if;

      -- If there is no Request then move to ST_NO_REQ state.
      else
        NextSmTSMState   <= ST_NO_REQ;
        NextSMBUSREQ     <= '0';
        NextBeatCount    <= (others => '0');
        NextIDCYRead     <= (others => '0');
        NextAhbWideRdReg <= (others => '0');
        if (SMClockEn = '0') then
          NextClkStpd <= '1';
        else
          NextClkStpd <= '0';
        end if;
      end if;

    when ST_WRITE =>
      -- SmCSTSM is de-asserted on following conditions.
      -- a) When there is an Wait Enabled transfer honoured.
      -- b) When AhbWideWrCnt = 000 and no further MemWrReq, in case of Normal
      --    transfers.
      -- c) When Memory Bus is degranted.
      -- d) When a Normal transfer is followed by an Wait - Enabled transfer.
      if (((((iWaitEnReg = '1') or (WaitEn = '1') or (SMBUSGNT = '0') or
             (HselMemBuf1 /= HselMemBufWr) or
             (HsizeMemBuf1 < iMWWr) or
             ((iHsizeMemBufWr < iMWWr) and (HsizeMemBuf1 > iHsizeMemBufWr))) and
            (AhbWideWrCnt <= "001")) or
           ((AhbWideWrCnt <= "001") and (MemWrReq = '0'))) and
            ((WaitWrCycVerAnd = '0') or (iWaitWrCycDup = '0'))) then
        NextSmCSTSM      <= '1';
        iNextSMCSMC       <= (others => '0');
        iNextSMCSMCn      <= (others => '1');
        iNextSMDATAENMCn  <= (others => '1');
        NextSMBLSMCn     <= "1111";
        iNextSMBAAMC      <= '1';
        iNxtSMADDRVALIDMC <= '1';

      else
        -- Logic to drive NextAddress. We have to drive the next address
        -- when the current write is over i.e when nSMWEN goes from 0 to 1.
        -- Also for Memory Width < AHB Width increment the Address.
        if ((DelSMWENMC = '0') and (iSMWENMC = '1') and
            (iSyncEnWriteReg = '0')) then
          if (AhbWideWrCnt > "001") then
            NextSmAddrTSM <= AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                      HburstMemBufWr);
            NextSMADDRMC  <= ShiftAddr(IncrAddrWr, iMWWr); 
          else
            NextSmAddrTSM <= AddrBuf;
            NextSMADDRMC  <= ShiftAddr(AddrBuf, MW);
          end if;
        end if;
      end if;

      if ((iSyncEnWriteReg and UseSecBuf and DelUseSecBuf) = '1') then
        NextXtraTxr <= '1';
      end if;

      -- Logic for WaitWrCycVer assertion and De-Assertion:
      -- When Wait Enabled transfers are pipelined we have to stop the assertion
      -- of WaitWrCycVer so that WaitWrCycVerMux is asserted and at the same
      -- time a signal WaitWrCycDup should be generated which will ensure that
      -- internal logic is not affected. This treatment is required as pipelined
      -- Wait Enabled transfers might get completed because of this WaitWrCycVer
      -- de-assertion.
      -- WaitWrCycVer is deasserted on following conditions.
      -- When WstWrCnt = "00000" condition is satisfied. Also before
      -- de-assertion WaitWrCycVerAnd = '1' condition should be true.

      if (iSyncEnWriteReg = '0') then
        if ((WstWrCnt = "00000") and (WaitWrCycVerAnd = '1') and
            (iSmCSTSM = '0') and (iWaitWrCycDup = '1')) then
          if ((WaitEn = '1') and (iWaitEnReg = '0') and
              (AhbWideWrCnt <= "001") and (WRITECYC = '1')) then
            NextWaitWrCycDup <= '0';
            NextWaitWrCycVer <= '1';
          else
            NextWaitWrCycDup <= '1';
            NextWaitWrCycVer <= '0';
          end if;
        else
          NextWaitWrCycDup   <= '1';
          NextWaitWrCycVer   <= '1';
        end if;
      else
        NextWaitWrCycDup   <= '1';
        NextWaitWrCycVer   <= '1';
        -- There might be cases where we may not be able to support Synchronous
        -- bursts, in those cases StopBurst signal is asserted.
        if ((WstWrCnt = "00001") and (iHsizeEqMWidthWr = '1') and
            (iBMWriteReg = '1')) then
          if (((ContWithBrst = '0') and
               (HtransMemBuf1 /= HTRANS_SEQ)) or
              (WaitEn = '1')) then
            NextStopBurst <= '1';
          else
            NextStopBurst <= '0';
          end if;
        end if;

        -- For Synchronous Memories WaitWrCycAhb is asserted, so that burst
        -- write feature is possible. This signal is asserted when Synchronous
        -- burst mode is enabled and AHB Width = Memory Width.
        if ((WstWrCnt = "00001") and (WaitEn = '0') and (iBMWriteReg = '1') and
            (iHsizeEqMWidthWr = '1') and (AddrNotAligned = '0') and
            (WrBtCntCpy /= "000") and (iSmCSTSM = '0') and
            (((HtransMemBuf1 = HTRANS_SEQ) and (HtranRegCont = HTRANS_SEQ)) or
             ((HtransMemBuf1 = HTRANS_NSEQ) and (ContWithBrst = '1')))) then
          NextWaitWrCycAhb <= '0';
        else
          NextWaitWrCycAhb <= '1';
        end if;
      end if;

      -- If Synchronous memories are attempting to do Write transfers then
      -- de-assert SMADDRVALIDMC so that it appears as pulse.
      if ((AddrValWrEnReg = '1') and (iSMADDRVALIDMC = '0') and
          (iSyncEnWriteReg = '1')) then
        iNxtSMADDRVALIDMC <= '1';
      end if;

      -- Make the State Transition after CS is de-asserted in normal case
      if (iSmCSTSM = '1') then

        -- If Grant is not there then move to Degranted state if any further
        -- Memory Accesses is requested.
        if ((SMBUSGNT = '0') and ((MemRdReq = '1') or (MemWrReq = '1'))) then
          NextSmTSMState <= ST_MEM_DEGRANTED;
          NextSMBUSREQ   <= '0';

        -- If there is no Request then move to ST_NO_REQ state.
        else
          NextSmTSMState   <= ST_NO_REQ;
          NextSMBUSREQ     <= '0';
          NextBeatCount    <= (others => '0');
          NextIDCYRead     <= (others => '0');
          NextAhbWideRdReg <= (others => '0');
          NextWaitEnReg    <= '0';
          if (SMClockEn = '0') then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;
        end if;

      -- Even if the write counter expired and if wait is asserted we
      -- should not assume that the write is over. We have to wait till the
      -- wait is de-asserted or cancelwait is asserted. Waited transfer has
      -- highest priority then normal transfer.
      elsif ((iWaitEnReg = '1') and (SMWaitSync = '0') and
             (iSMWENMC = '0') and (iSyncEnWriteReg = '0')) then
        NextSmTSMState   <= ST_WAIT_ASSERTED;
        NextWaitWrCycVer <= '1';
        NextWriteProg    <= '1';

      -- Do the Burst transfer if it is enabled.
      elsif ((iSyncEnWriteReg = '1') and (WstWrCnt = "00000")) then
        NextWaitWrCycAhb <= '1';
        NextWaitWrCycVer <= '0';
        -- Added (iHtranRegCont = HTRANS_SEQ) condition to ensure that
        -- what is happening on AHB side is reflected here.
        if ((iWaitWrCycAhb = '0') and (HtranRegCont = HTRANS_SEQ)) then
          NextWriteBeatCnt <= BoundChkWr(BurstLenWrReg, iMWWr,
                                         iSmAddrTSM(3 downto 0), HburstMemBuf,
                                         iAhbWiderWr, AhbWideWrCnt);
        elsif (iAhbWiderWr = '1') then
          NextWriteBeatCnt <= AhbWideWrCnt;
        else
          NextWriteBeatCnt <= "000";
        end if;
        NextSmTSMState   <= ST_BURST_WRITE;
      end if;

      -- nSMWEN assertion and De-assertion logic.
      if ((iSMWENMC = '1') and (iSmCSTSM = '0')) then
        -- If the nSMWEN is de-asserted after current write and width mismatches
        -- is taken into considerations then register the Memory information.
        if ((AhbWideWrCnt <= "001") and (iSyncEnWriteReg = '0') and
            (DelSMWENMC = '0') and (MemWrReq = '1')) then
          NextHselMemBufWr   <= HselMemBuf;
          NextHburstMemBufWr <= HburstMemBuf;
          NextSMBLSPolWr     <= SMBLSPol;
          NextMWWr           <= MW;
          NxtHsizeMemBufWr   <= HsizeMemBuf;
          NextHsizeEqMW      <= HsizeEqMWidth;
          NextAhbWiderWr     <= AhbWider;
          NextAhbNarrowWr    <= AhbNarrow;
          NextRBLEWr         <= RBLE;
          NextWaitEnReg      <= WaitEn;
          NextSyncEnWr       <= SyncEnWrite;
          NextBMWriteReg     <= BMWrite;
          NextBIWriteEnReg   <= BIWriteEn;
          NextBurstLenWr     <= BurstLenWrite;
          NextAddrValWrReg   <= AddrValidWriteEn;
          NextWSTWRReg       <= WSTWR;
          NextWSTWENReg      <= WSTWEN;
        end if;

        -- To take care of waited transfers include (WaitEn = '1') condition
        if (((WaitEn = '1') or (MemWrReq = '0') or (SMBUSGNT = '0') or
             (HselMemBuf1 /= HselMemBufWr) or
             (HsizeMemBuf1 < iMWWr) or
             ((iHsizeMemBufWr < iMWWr) and (HsizeMemBuf1 > iHsizeMemBufWr))) and
            ((WaitWrCycVerAnd = '0') or (iWaitWrCycDup = '0')) and
            (AhbWideWrCnt <= "001")) then
          NextSmWrEn  <= '1';
          NextWstWrEnCnt <= (others => '0');
          if (iRBLEWr = '0') then
            NextSMBLSMCn <= (others => '1');
          end if;
        elsif ((WstWrEnCnt = "0000") and (MemWrReq = '1')) then
          NextSmWrEn  <= '0';
          NextSMBLSMCn <= ByteLaneFunc(iMWWr, iHsizeMemBufWr, SMBLSPolWr,
                                       NextValByteLane0, NextValByteLane1,
                                       NextValByteLane2, NextValByteLane3);
        elsif (WstWrEnCnt /= "0000") then
          NextWstWrEnCnt <= unsigned(WstWrEnCnt) - 1;
        end if;
      else
        if (WstWrCnt = "00000") then
          if (((iWaitEnReg = '0') or (SMWaitSync = '1')) and
              (iSyncEnWriteReg = '0')) then
            NextSmWrEn  <= '1';
            if ((iRBLEWr = '0') and (iSmCSTSM = '0')) then
              NextSMBLSMCn <= (others => '1');
            end if;
            if ((WSTWEN /= "0000") and (AhbWideWrCnt <= "001")) then
              NextWstWrEnCnt <= unsigned(WSTWEN) - 1;
            elsif ((WSTWENReg /= "0000") and (AhbWideWrCnt > "001")) then
              NextWstWrEnCnt <= unsigned(WSTWENReg) - 1;
            else
              NextWstWrEnCnt <= (others => '0');
            end if;
          end if;
        end if;
      end if;

      -- Logic for WstWrCnt loading and Decrementing. For Synchronous memories
      -- reloading of counters is avoided.
      if ((WstWrCnt = "00000") and (iSyncEnWriteReg = '0') and
          (iSMWENMC = '1')) then
        if (AhbWideWrCnt <= "001") then
          if (WSTWEN /= "0000") then
            NextWstWrCnt <= unsigned(WSTWR) - 1;
          else
            NextWstWrCnt <= WSTWR;
          end if;
        else
          -- Reload the Counter only in case of Async Write
          if (WSTWENReg /= "0000") then
            NextWstWrCnt <= unsigned(WSTWRReg) - 1;
          else
            NextWstWrCnt <= WSTWRReg;
          end if;
        end if;
      elsif (WstWrCnt /= "00000") then
        NextWstWrCnt <= unsigned(WstWrCnt) - 1;
      end if;

    when ST_BURST_WRITE =>
      -- SM enters this state while performing Synchronous transfers.

      -- Start asserting SMBAAMC when there is a Synchronous access and
      -- BMWrite is enabled. This will be de-asserted with nSMCS.
      if ((iSyncEnWriteReg = '1') and (iBMWriteReg = '1') and (BIWriteEnReg = '1') and
          (iSmCSTSM = '0')) then
        iNextSMBAAMC <= '0';
      end if;

      if (((SyncWtOnMCLK = '0') or
           ((SyncWtOnMCLK = '1') and (DelSmBurstWait = '0'))) and
          (iWBstIntrptd = '0') and (iSmCSTSM = '0') and
          (iHsizeEqMWidthWr = '1') and
          ((HtransMemBuf1  = HTRANS_BUSY) or (NewBurst = '1') or
           (IDLECYC  = '1'))) then
        NextWBstIntrptd <= '1';
      elsif (iSmCSTSM = '1') then
        NextWBstIntrptd <= '0';
      end if;

      if ((SyncWtOnMCLK = '1') and (DelSmBurstWait = '0') and
          (iSmCSTSM = '0')) then
        NextFirstSyncWt <= '1';
      elsif (iSmCSTSM = '1') then
        NextFirstSyncWt <= '0';
      end if;

      if ((FirstSyncWt = '1') and (SyncWtOnMCLK = '0') and
          (DelSmBurstWait = '1') and (iSmCSTSM = '0') and
          (IDLECYC = '0') and
          (HtransMemBuf1  = HTRANS_SEQ)) then
        NextTxrB4BsyAccptd <= '1';
      elsif (iSmCSTSM = '1') then
        NextTxrB4BsyAccptd <= '0';
      end if;

      -- De-assert the SmCSTSM when Write request is not sampled high, When the
      -- Burst end is reached, When SMBUSGNT is de-asserted, or when New burst
      -- was sampled asserted. If above conditions do not occur then decrement
      -- the WriteBeatCnt counter.
     if ((((((MemWrReq = '0') or
              (((((HtransMemBuf1 = HTRANS_NSEQ) or
                  (HtransMemBuf1  = HTRANS_BUSY)) and (SyncWtOnMCLK = '1') and
                  (UseSecBuf = '0')) or
                 (StopBurst = '1') or
                 (((iWBstIntrptd and SyncWtOnMCLK and FirstSyncWt) = '1') and
                   (iTxrB4BsyAccptd = '0')) or
                 (((NewBurst or iWBstIntrptd) = '1') and (UseSecBuf = '0'))) and
                 (iHsizeEqMWidthWr = '1'))) and
                 ((AhbWideWrCnt <= "001") or (iHsizeEqMWidthWr = '1'))) or
              (iBMWriteReg = '0') or (iAhbNarrowWR = '1')) and
             (WaitWrCycVerAnd = '0')) or
            ((((iAhbWiderWr = '0') and (iWriteBeatCnt = "000")) or
              ((iAhbWiderWr = '1') and (iWriteBeatCnt = "001"))) and
              (SyncWtOnMCLK = '1'))) then
        NextSmCSTSM      <= '1';
        iNextSMCSMC       <= (others => '0');
        iNextSMCSMCn      <= (others => '1');
        iNextSMDATAENMCn  <= (others => '1');
        NextSMBLSMCn     <= (others => '1');
        NextSmWrEn       <= '1';
        NextXtraTxr      <= '0';
        if ((iWBstIntrptd = '1') and (DelWaitWrCycVer = '1') and
            (WaitWrCycVerAnd = '1') and
            ((iWriteBeatCnt /= "000") or (iTxrB4BsyAccptd = '0'))) then
          NextWaitWrCycVer <= '0';
        else
          NextWaitWrCycVer <= '1';
        end if;
        NextStopBurst    <= '0';
        NextWriteBeatCnt <= (others => '0');
        iNextSMBAAMC      <= '1';
        if ((WaitEn = '1') and (WRITECYC = '1')) then
          NextWaitWrCycDup <= '0';
        else
          NextWaitWrCycDup <= '1';
        end if;

      elsif ((((iWriteBeatCnt > "001") and (ClockRatio = "00")) or
              ((iWriteBeatCnt /= "000") and (ClockRatio /= "00"))) and
             (WaitWrCycVerAnd = '0')) then
        NextWriteBeatCnt <= unsigned(iWriteBeatCnt) - 1;
        NextWaitWrCycVer <= '0';

        if ((AhbWideWrCnt /= "000") and (iBMWriteReg = '1')) then
          NextSmAddrTSM <= AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                    HburstMemBufWr);
        else
          NextSmAddrTSM <= AddrBuf;
        end if;

      else
        if (SyncWtOnMCLK = '1') then
            NextWaitWrCycVer <= '1';
            NextWaitWrCycDup <= '1';
        end if;

        if ((WaitWrCycVerAnd = '0') and (iWriteBeatCnt /= "000")) then
          NextWriteBeatCnt <= unsigned(iWriteBeatCnt) - 1;
          if ((AhbWideWrCnt /= "000") and (iBMWriteReg = '1')) then
            NextSmAddrTSM <= AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                      HburstMemBufWr);
          else
            NextSmAddrTSM <= AddrBuf;
          end if;
        end if;
      end if;

      -- Make the State Transition after CS is de-asserted.
      if (iSmCSTSM = '1') then
        NextWriteBeatCnt <= (others => '0');
        NextWaitWrCycDup <= '1';
        NextWaitWrCycVer <= '1';

        if ((MemWrReq = '1') and (SyncEnWrite = '1')) then
          NextSmCSTSM      <= '0';
          if ((AhbWideWrCnt = "000") or (DelAhbWideWrCnt <= "001") or
              (iHsizeEqMWidthWr = '1')) then
            iNextSMCSMC       <= ChipSelRouteH(HselMemBuf);
            iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf);
            iNextSMDATAENMCn  <= DataEnFunc(MW);
          else
            iNextSMCSMC       <= ChipSelRouteH(HselMemBufWr);
            iNextSMCSMCn      <= ChipSelRouteL(HselMemBufWr);
            iNextSMDATAENMCn  <= DataEnFunc(iMWWr);
          end if;
          NextSmTSMState   <= ST_WRITE;
          if ((AhbWideWrCnt = "000") or (DelAhbWideWrCnt <= "001") or
              (iHsizeEqMWidthWr = '1')) then
            NextHselMemBufWr   <= HselMemBuf;
            NextHburstMemBufWr <= HburstMemBuf;
            NextSMBLSPolWr     <= SMBLSPol;
            NextMWWr           <= MW;
            NxtHsizeMemBufWr   <= HsizeMemBuf;
            NextHsizeEqMW      <= HsizeEqMWidth;
            NextAhbWiderWr     <= AhbWider;
            NextAhbNarrowWr    <= AhbNarrow;
            NextRBLEWr         <= RBLE;
            NextWaitEnReg      <= WaitEn;
            NextSyncEnWr       <= SyncEnWrite;
            NextBMWriteReg     <= BMWrite;
            NextBIWriteEnReg   <= BIWriteEn;
            NextBurstLenWr     <= BurstLenWrite;
            NextAddrValWrReg   <= AddrValidWriteEn;
            NextWSTWRReg       <= WSTWR;
            NextWSTWENReg      <= WSTWEN;
            NextWstWrCnt       <= WSTWR;

            if ((WSTWR = "00000") and (SyncEnWrite = '1') and
                (AddrNotAligned = '0') and
                (BMWrite = '1') and (HsizeEqMWidth = '1')) then
              NextWaitWrCycAhb <= '0';
            else
              NextWaitWrCycAhb <= '1';
            end if;

            -- logic to assert nSMBLSMC
            if ((RBLE = '1') or (SyncEnWrite = '1') or
                ((WSTWEN = "0000") or (WaitEn = '1'))) then
              NextSMBLSMCn <= ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                           NextValByteLane0, NextValByteLane1,
                                           NextValByteLane2, NextValByteLane3);
            end if;

            -- Start asserting SmWrEn if it is wait enabled transfer or if the
            -- WSTWEN counter is programmed as zero.
            if ((WSTWEN = "0000") or (WaitEn = '1')) then
              NextSmWrEn     <= '0';
              NextWstWrEnCnt <= (others => '0');
            else
              -- The count is decremented and loaded so that in ST_WRITE state
              -- the implementation becomes uniform where it waits for count
              -- to decrement to 0, when re-assertion of nSMWEN is required.
              NextWstWrEnCnt <= unsigned(WSTWEN) - 1;
            end if;

            -- If Synchronous memories are attempting to do an Asynchronous
            -- transfers then assert SMADDRVALIDMC along with SmCS.
            if (AddrValidWriteEn = '1') then
              iNxtSMADDRVALIDMC <= '0';
            else
              iNxtSMADDRVALIDMC <= '1';
            end if;

            -- Prevent clock stopping if Synchronous memory access is required
            if ((SMClockEn = '0') and (SyncEnWrite = '0')) then
              NextClkStpd <= '1';
            else
              NextClkStpd <= '0';
            end if;

          else
            NextWstWrCnt <= WSTWRReg;

            if ((WSTWRReg = "00000") and (AddrNotAligned = '0') and
                (iBMWriteReg = '1') and (iHsizeEqMWidthWr = '1')) then
              NextWaitWrCycAhb <= '0';
            else
              NextWaitWrCycAhb <= '1';
            end if;

            -- logic to assert nSMBLSMC
            if ((iRBLEWr = '1') or (iSyncEnWriteReg = '1') or
                (WSTWENReg = "0000")) then
              NextSMBLSMCn <= ByteLaneFunc(iMWWr, iHsizeMemBufWr, SMBLSPolWr,
                                           NextValByteLane0, NextValByteLane1,
                                           NextValByteLane2, NextValByteLane3);
            end if;

            -- Start asserting SmWrEn if WSTWENReg counter is programmed as 0.
            if (WSTWENReg = "0000") then
              NextSmWrEn     <= '0';
              NextWstWrEnCnt <= (others => '0');
            else
              -- The count is decremented and loaded so that in ST_WRITE state
              -- the implementation becomes uniform where it waits for count
              -- to decrement to 0, when re-assertion of nSMWEN is required.
              NextWstWrEnCnt <= unsigned(WSTWENReg) - 1;
            end if;

            iNxtSMADDRVALIDMC <= '0';

          end if;

          if ((AhbWideWrCnt /= "000") and (iBMWriteReg = '0') and
              (DelAhbWideWrCnt(2 downto 1) /= "00")) then
            NextSmAddrTSM  <= AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                       HburstMemBufWr);
            NextSMADDRMC  <= ShiftAddr(IncrAddrWr, iMWWr);
          else
            NextSmAddrTSM  <= AddrBuf;
            NextSMADDRMC <= ShiftAddr(AddrBuf, MW);
          end if;

        -- If SMBUSGNT is sampled asserted and if there is a New Read Transfer
        -- sampled then we to move to ST_READ state by appropriately loading
        -- the counters.
        elsif ((MemRdReq = '1') and (SyncEnRead1 = '1') and
               (MemWrReq = '0')) then
          NextWaitEnReg    <= '0';
          NextSmCSTSM      <= '0';
          iNextSMCSMC       <= ChipSelRouteH(HselMemBuf1);
          iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf1);
          iNextSMDATAENMCn  <= (others => '1');
          NextSmTSMState   <= ST_READ;
          NextWstBrstRdCnt <= WSTBRD1;
          NextSmAddrTSM    <= AddrBuf1;
          NextSMADDRMC     <= ShiftAddr(AddrBuf1, MW1);
          NextIDCYRead     <= IDCYC;
          NextSyncEnWr     <= '0';
          NextBeatCount    <= BoundaryChk(AddrBuf1(5 downto 0), AhbCount,
                                          BurstLenRead1, MW1, HburstMemBuf,
                                          WrapRead, SyncEnRead1, HsizeMemBuf1,
                                          BMRead1);

          -- Start asserting SmOEn if it is wait enabled transfer or if the
          -- WSTOEN1 counter is programmed as zero.
          if ((WSTOEN1 = "0000") or (WaitEn = '1')) then
            iNextSmOEn     <= '0';
          else
            NextWstOEnCnt <= WSTOEN1;
          end if;

          -- logic to assert nSMBLSMC
          if ((RBLE = '1') and (MW1 /= MEM_BYTE)) then
            NextSMBLSMCn <= (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);
          else
            NextSMBLSMCn <= "1111";
          end if;

          -- Start asserting WaitRdCyc if WSTRD1 counter is programmed as zero,
          -- in case of Asynchronous memories. Otherwise load the Long Read
          -- counter. This distinction is done because Asynchronous Memory
          -- accesses has to be By-passed.
          if ((WSTRD1 = "00000") and (SyncEnRead1 = '0')) then
            NextWaitRdCycVer <= '0';
            NextWstLongRdCnt <= (others => '0');
          else
            NextWstLongRdCnt <= WSTRD1;
          end if;

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidReadEn1 = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnRead1 = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

        -- If there is no Request then move to ST_NO_REQ state.
        else
          NextWaitEnReg    <= '0';
          NextSmTSMState   <= ST_NO_REQ;
          NextSMBUSREQ     <= '0';
          NextBeatCount    <= (others => '0');
          NextIDCYRead     <= (others => '0');
          NextAhbWideRdReg <= (others => '0');
          NextSyncEnWr     <= '0';
          if (SMClockEn = '0') then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;
        end if;
      end if;

    when ST_TURNAROUND =>
    -- The SM enters this state from ST_WAIT_TXRONBUS state.
    -- When the SM entered this state there may be pending Read Transfers for
    -- Different Bank or a Pending Write Transfers, Or the Bus might be
    -- Degranted so before handing over the bus we have to do TurnAround, so
    -- that subsequent Write from other controllers does not lead to Bus
    -- Contention. In This state do Idling till the IdcyCnt expires.

      if (NewBurst = '1') then
        NextAhbWideRdReg <= (others => '0');
      end if;

      -- Decrement the count till it has reached the value = "0001".
      if (IdcyCount = "0001") then
        NextIDCYRead <= (others => '0');
        if ((SMBUSGNT = '0') and ((MemWrReq = '1') or (MemRdReq = '1'))) then
          -- Grant not there but some transfers have to be done, so make a
          -- State transition to Degrant state.
          NextSmTSMState <= ST_MEM_DEGRANTED;
          NextSMBUSREQ   <= '0';

        -- If SMBUSGNT is sampled asserted and if there is a pending Write
        -- transfers to be performed(bcoz of break in burst) or a NewBurst has
        -- been sampled then we to move to ST_WRITE state by appropriately
        -- loading the counters.
        elsif (MemWrReq = '1') then
          NextHselMemBufWr   <= HselMemBuf;
          NextHburstMemBufWr <= HburstMemBuf;
          NextSMBLSPolWr     <= SMBLSPol;
          NextMWWr           <= MW;
          NxtHsizeMemBufWr   <= HsizeMemBuf;
          NextHsizeEqMW      <= HsizeEqMWidth;
          NextAhbWiderWr     <= AhbWider;
          NextAhbNarrowWr    <= AhbNarrow;
          NextRBLEWr         <= RBLE;
          NextWaitEnReg      <= WaitEn;
          NextSyncEnWr       <= SyncEnWrite;
          NextBMWriteReg     <= BMWrite;
          NextBIWriteEnReg   <= BIWriteEn;
          NextBurstLenWr     <= BurstLenWrite;
          NextAddrValWrReg   <= AddrValidWriteEn;
          NextWSTWRReg       <= WSTWR;
          NextWSTWENReg      <= WSTWEN;
          NextSmCSTSM        <= '0';
          iNextSMCSMC         <= ChipSelRouteH(HselMemBuf);
          iNextSMCSMCn        <= ChipSelRouteL(HselMemBuf);
          iNextSMDATAENMCn    <= DataEnFunc(MW);
          NextSmTSMState     <= ST_WRITE;
          NextWstWrCnt       <= WSTWR;

          -- Assertion of WaitWrCycAhb signal for Synchronous Write transfers
          if ((WSTWR = "00000") and (SyncEnWrite = '1') and
              (AddrNotAligned = '0') and
              (BMWrite = '1') and (HsizeEqMWidth = '1')) then
            NextWaitWrCycAhb <= '0';
          else
            NextWaitWrCycAhb <= '1';
          end if;

          -- logic to assert nSMBLSMC
          if ((RBLE = '1') or (SyncEnWrite = '1') or
              ((WSTWEN = "0000") or (WaitEn = '1'))) then
            NextSMBLSMCn <= ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                         NextValByteLane0, NextValByteLane1,
                                         NextValByteLane2, NextValByteLane3);
          end if;

          -- Start asserting SmWrEn if it is wait enabled transfer or if the
          -- WSTWEN counter is programmed as zero.
          if ((WSTWEN = "0000") or (WaitEn = '1')) then
            NextSmWrEn     <= '0';
            NextWstWrEnCnt <= (others => '0');
          else
            -- The count is decremented and loaded so that in ST_WRITE state
            -- the implementation becomes uniform where it waits for this count
            -- to decrement to 0, when re-assertion of nSMWEN is required.
            NextWstWrEnCnt <= unsigned(WSTWEN) - 1;
          end if;

          NextSmAddrTSM <= AddrBuf;
          NextSMADDRMC  <= ShiftAddr(AddrBuf, MW);

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidWriteEn = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Control signal used in Pad Interface to distinguish Async and
          -- Sync Access.
          iNextAsynAxs <= not SyncEnWrite;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnWrite = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

        -- If SMBUSGNT is sampled asserted and if there are pending Read
        -- transfers to be performed(bcoz of break in burst) or a NewBurst has
        -- been sampled then we to move to ST_READ state by appropriately
        -- loading the counters.
        elsif (MemRdReq = '1') then
          NextSmCSTSM      <= '0';
          iNextSMCSMC       <= ChipSelRouteH(HselMemBuf1);
          iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf1);
          iNextSMDATAENMCn  <= (others => '1');
          NextSmTSMState   <= ST_READ;
          NextWstBrstRdCnt <= WSTBRD1;
          NextSmAddrTSM    <= AddrBuf1;
          NextSMADDRMC     <= ShiftAddr(AddrBuf1, MW1);
          NextIDCYRead     <= IDCYC;
          NextBeatCount    <= BoundaryChk(AddrBuf1(5 downto 0), AhbCount,
                                          BurstLenRead1, MW1, HburstMemBuf,
                                          WrapRead, SyncEnRead1, HsizeMemBuf1,
                                          BMRead1);

          -- Start asserting SmOEn if it is wait enabled transfer or if the
          -- WSTOEN1 counter is programmed as zero.
          if ((WSTOEN1 = "0000") or (WaitEn = '1')) then
            iNextSmOEn     <= '0';
          else
            NextWstOEnCnt <= WSTOEN1;
          end if;

          -- logic to assert nSMBLSMC
          if ((RBLE = '1') and (MW1 /= MEM_BYTE)) then
            NextSMBLSMCn <= (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);
          else
            NextSMBLSMCn <= "1111";
          end if;

          -- Start asserting WaitRdCyc if WSTRD1 counter is programmed as zero,
          -- in case of Asynchronous memories. Otherwise load the Long Read
          -- counter. This distinction is done because Asynchronous Memory
          -- accesses has to be By-passed.
          if ((WSTRD1 = "00000") and (SyncEnRead1 = '0')) then
            NextWaitRdCycVer <= '0';
            NextWstLongRdCnt <= (others => '0');
          else
            NextWstLongRdCnt <= WSTRD1;
          end if;

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidReadEn1 = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Control signal used in Pad Interface to distinguish Async and
          -- Sync Access.
          iNextAsynAxs <= not SyncEnRead1;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnRead1 = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

        -- If there is no Request then move to ST_NO_REQ state.
        else
          NextSmTSMState   <= ST_NO_REQ;
          NextSMBUSREQ     <= '0';
          NextBeatCount    <= (others => '0');
          NextIDCYRead     <= (others => '0');
          NextAhbWideRdReg <= (others => '0');
          if (SMClockEn = '0') then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;
        end if;
      else
        NextIdcyCount <= unsigned(IdcyCount) - 1;
      end if;

    when ST_MEM_DEGRANTED =>
      NextSMBUSREQ <= '1';
      if (SMBUSGNT = '1') then

        -- Priority is given for Write as there are chances of having a posted
        -- Write and we may have to service it, because AHB bus would be free
        -- to come up with Read transfers, and this posted Write gets lost.
        -- If SMBUSGNT is sampled asserted and if there are pending Write
        -- transfers to be performed(bcoz of break in burst) or a NewBurst has
        -- been sampled then we to move to ST_WRITE state by appropriately
        -- loading the counters.
        if (MemWrReq = '1') then
          NextHselMemBufWr   <= HselMemBuf;
          NextHburstMemBufWr <= HburstMemBuf;
          NextSMBLSPolWr     <= SMBLSPol;
          NextMWWr           <= MW;
          NxtHsizeMemBufWr   <= HsizeMemBuf;
          NextHsizeEqMW      <= HsizeEqMWidth;
          NextAhbWiderWr     <= AhbWider;
          NextAhbNarrowWr    <= AhbNarrow;
          NextRBLEWr         <= RBLE;
          NextWaitEnReg      <= WaitEn;
          NextSyncEnWr       <= SyncEnWrite;
          NextBMWriteReg     <= BMWrite;
          NextBIWriteEnReg   <= BIWriteEn;
          NextBurstLenWr     <= BurstLenWrite;
          NextAddrValWrReg   <= AddrValidWriteEn;
          NextWSTWRReg       <= WSTWR;
          NextWSTWENReg      <= WSTWEN;
          NextSmCSTSM        <= '0';
          iNextSMCSMC         <= ChipSelRouteH(HselMemBuf);
          iNextSMCSMCn        <= ChipSelRouteL(HselMemBuf);
          iNextSMDATAENMCn    <= DataEnFunc(MW);
          NextSmTSMState     <= ST_WRITE;
          NextWstWrCnt       <= WSTWR;

          -- Assertion of WaitWrCycAhb signal for Synchronous Write transfers
          if ((WSTWR = "00000") and (SyncEnWrite = '1') and
              (AddrNotAligned = '0') and (BMWrite = '1') and
              (HsizeEqMWidth = '1')) then
            NextWaitWrCycAhb <= '0';
          else
            NextWaitWrCycAhb <= '1';
          end if;

          -- logic to assert nSMBLSMC
          if ((RBLE = '1') or (SyncEnWrite = '1') or
              ((WSTWEN = "0000") or (WaitEn = '1'))) then
            NextSMBLSMCn <= ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                         NextValByteLane0, NextValByteLane1,
                                         NextValByteLane2, NextValByteLane3);
          end if;

          -- Start asserting SmWrEn if it is wait enabled transfer or if the
          -- WSTWEN counter is programmed as zero.
          if ((WSTWEN = "0000") or (WaitEn = '1')) then
            NextSmWrEn     <= '0';
            NextWstWrEnCnt <= (others => '0');
          else
            -- The count is decremented and loaded so that in ST_WRITE state
            -- the implementation becomes uniform where it waits for this count
            -- to decrement to 0, when re-assertion of nSMWEN is required.
            NextWstWrEnCnt <= unsigned(WSTWEN) - 1;
          end if;

          NextSmAddrTSM <= AddrBuf;
          NextSMADDRMC  <= ShiftAddr(AddrBuf, MW);

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidWriteEn = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Control signal used in Pad Interface to distinguish Async and
          -- Sync Access.
          iNextAsynAxs <= not SyncEnWrite;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnWrite = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

        -- If SMBUSGNT is sampled asserted and if there are pending Read
        -- transfers to be performed(bcoz of break in burst) or a NewBurst has
        -- been sampled then we to move to ST_READ state by appropriately
        -- loading the counters.
        else
          NextSmCSTSM      <= '0';
          iNextSMCSMC       <= ChipSelRouteH(HselMemBuf1);
          iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf1);
          iNextSMDATAENMCn  <= (others => '1');
          NextSmTSMState   <= ST_READ;
          NextWstBrstRdCnt <= WSTBRD1;
          NextIDCYRead     <= IDCYC;

          if ((AhbWideRdReg /= "000") and (AhbWideRdCnt /= "000") and
              (AhbWider = '1')) then
            NextSmAddrTSM <= AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                      HburstMemBuf);
            NextSMADDRMC  <= ShiftAddr(IncrAddr, MW1);
            NextBeatCount <= BoundaryChk(IncrAddr(5 downto 0), Temp,
                                         BurstLenRead1, MW1, HburstMemBuf,
                                         WrapRead, SyncEnRead1, HsizeMemBuf1,
                                         BMRead1);
          else
            NextSmAddrTSM <= AddrBuf1;
            NextSMADDRMC  <= ShiftAddr(AddrBuf1, MW1);
            NextBeatCount <= BoundaryChk(AddrBuf1(5 downto 0), AhbCount,
                                         BurstLenRead1, MW1, HburstMemBuf,
                                         WrapRead, SyncEnRead1, HsizeMemBuf1,
                                         BMRead1);
          end if;

          -- Start asserting SmOEn if it is wait enabled transfer or if the
          -- WSTOEN1 counter is programmed as zero.
          if ((WSTOEN1 = "0000") or (WaitEn = '1')) then
            iNextSmOEn     <= '0';
          else
            NextWstOEnCnt <= WSTOEN1;
          end if;

          -- logic to assert nSMBLSMC
          if ((RBLE = '1') and (MW1 /= MEM_BYTE)) then
            NextSMBLSMCn <= (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);
          else
            NextSMBLSMCn <= "1111";
          end if;

          -- Start asserting WaitRdCyc if WSTRD1 counter is programmed as zero,
          -- in case of Asynchronous memories. Otherwise load the Long Read
          -- counter. This distinction is done because Asynchronous Memory
          -- accesses has to be By-passed.
          if ((WSTRD1 = "00000") and (SyncEnRead1 = '0')) then
            NextWaitRdCycVer <= '0';
            NextWstLongRdCnt <= (others => '0');
          else
            NextWstLongRdCnt <= WSTRD1;
          end if;

          -- If Synchronous memories are attempting to do an Asynchronous
          -- transfers then assert SMADDRVALIDMC along with SmCS.
          if (AddrValidReadEn1 = '1') then
            iNxtSMADDRVALIDMC <= '0';
          else
            iNxtSMADDRVALIDMC <= '1';
          end if;

          -- Control signal used in Pad Interface to distinguish Async and
          -- Sync Access.
          iNextAsynAxs <= not SyncEnRead1;

          -- Prevent clock stopping if Synchronous memory access is required
          if ((SMClockEn = '0') and (SyncEnRead1 = '0')) then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;

        end if;
      end if;

    when ST_WAIT_ASSERTED =>
      if (SmCancelWaitSync = '1') then
        NextSmTSMState   <= ST_CANCEL_WAIT;
        iNextSmOEn        <= '1';
        NextWaitRdCycVer <= '1';
        NextWaitWrCycVer <= '1';
        NextSmWrEn       <= '1';
        if (iRBLEWr = '0') then
          NextSMBLSMCn     <= (others => '1');
        end if;
        if (MemWrReq = '1') then
          NextSmCSTSM     <= '0';
          iNextSMCSMC      <= ChipSelRouteH(HselMemBuf);
          iNextSMCSMCn     <= ChipSelRouteL(HselMemBuf);
          iNextSMDATAENMCn <= DataEnFunc(MW);
        else
          iNxtSMADDRVALIDMC <= '1';
          NextSmCSTSM      <= '1';
          iNextSMCSMC       <= (others => '0');
          iNextSMCSMCn      <= (others => '1');
          iNextSMDATAENMCn  <= (others => '1');
          NextSMBLSMCn     <= (others => '1');
        end if;
      elsif (SMWaitSync = '1') then
        NextToggle     <= '0';
        NextSmTSMState <= ST_WAIT_DEASSERTED;
        NextSmWrEn     <= '1';
        if ((iRBLEWr = '0') and (iSMWENMC = '0')) then
          NextSMBLSMCn     <= (others => '1');
        end if;
        if (MemRdReq = '1') then
          NextWaitRdCycVer <= '0';
        else
          NextWaitWrCycVer <= '0';
        end if;
      end if;

    when ST_WAIT_DEASSERTED =>
      if (iSmCSTSM = '1') then
        NextToggle <= not iToggle;
      end if;

      if ((iWaitRdCyc = '0') and (BeatCount /= "00000")) then
        NextBeatCount <= unsigned(BeatCount) - 1;
      end if;

      NextWaitWrCycVer <= '1';
      NextWaitRdCycVer <= '1';
      NextSmCSTSM      <= '1';
      iNextSMCSMC       <= (others => '0');
      iNextSMCSMCn      <= (others => '1');
      iNextSMDATAENMCn  <= (others => '1');
      NextSMBLSMCn     <= (others => '1');
      iNxtSMADDRVALIDMC <= '1';
      iNextSmOEn        <= '1';

      if ((iToggle = '1') or (NewBurst = '1')) then
        NextWriteProg <= '0';
        NextWaitEnReg <= '0';
        NextIDCYRead  <= (others => '0');
        if (NewBurst = '1') then
          NextAhbWideRdReg <= (others => '0');
        end if;

        if (iSmCSTSM = '1') then
          if (((TurnAround = '1') and (IDCYRead /= "0000")) or
              ((IDCYRead /= "0000") and (MemRdReq = '0'))) then
            NextSmTSMState   <= ST_TURNAROUND;
            NextIdcyCount    <= IDCYRead;
            NextWaitRdCycVer <= '1';

          -- If Grant is not there and Turnaround is not required, then move to
          -- Degranted state, if any further Memory Accesses is requested.
          elsif ((SMBUSGNT = '0') and (AhbWideWrCnt = "000") and
                 ((MemRdReq = '1') or (MemWrReq = '1'))) then
            NextSmTSMState   <= ST_MEM_DEGRANTED;
            NextSMBUSREQ     <= '0';
            NextWaitRdCycVer <= '1';

          -- If SMBUSGNT is sampled asserted and if a New Write Transfer is
          -- sampled then SM moves to ST_WRITE state by appropriately loading
          -- the counters.
          elsif ((MemWrReq = '1') and (AhbWideWrCnt /= "000")) then
            NextHselMemBufWr   <= HselMemBuf;
            NextHburstMemBufWr <= HburstMemBuf;
            NextSMBLSPolWr     <= SMBLSPol;
            NextMWWr           <= MW;
            NxtHsizeMemBufWr   <= HsizeMemBuf;
            NextHsizeEqMW      <= HsizeEqMWidth;
            NextAhbWiderWr     <= AhbWider;
            NextAhbNarrowWr    <= AhbNarrow;
            NextRBLEWr         <= RBLE;
            NextWaitEnReg      <= WaitEn;
            NextSyncEnWr       <= SyncEnWrite;
            NextBMWriteReg     <= BMWrite;
            NextBIWriteEnReg   <= BIWriteEn;
            NextBurstLenWr     <= BurstLenWrite;
            NextAddrValWrReg   <= AddrValidWriteEn;
            NextWSTWRReg       <= WSTWR;
            NextWSTWENReg      <= WSTWEN;
            NextSmCSTSM        <= '0';
            iNextSMCSMC         <= ChipSelRouteH(HselMemBuf);
            iNextSMCSMCn        <= ChipSelRouteL(HselMemBuf);
            iNextSMDATAENMCn    <= DataEnFunc(MW);
            NextSmTSMState     <= ST_WRITE;
            NextWstWrCnt       <= WSTWR;

            -- Assertion of WaitWrCycAhb signal for Synchronous Write transfers
            if ((WSTWR = "00000") and (SyncEnWrite = '1') and
                (AddrNotAligned = '0') and
                (BMWrite = '1') and (HsizeEqMWidth = '1')) then
              NextWaitWrCycAhb <= '0';
            else
              NextWaitWrCycAhb <= '1';
            end if;

            -- logic to assert nSMBLSMC
            if ((RBLE = '1') or (SyncEnWrite = '1') or
                ((WSTWEN = "0000") or (WaitEn = '1'))) then
              NextSMBLSMCn <= ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                           NextValByteLane0, NextValByteLane1,
                                           NextValByteLane2, NextValByteLane3);
            end if;

            -- Start asserting SmWrEn if it is wait enabled transfer or if the
            -- WSTWEN counter is programmed as zero.
            if ((WSTWEN = "0000") or (WaitEn = '1')) then
              NextSmWrEn  <= '0';
              NextWstWrEnCnt <= (others => '0');
            else
              -- The count is decremented and loaded so that in ST_WRITE state
              -- the implementation becomes uniform where it wait for this count
              -- to decrement to 0, when re-assertion of nSMWEN is required.
              NextWstWrEnCnt <= unsigned(WSTWEN) - 1;
            end if;

            if (AhbWideWrCnt /= "000") then
              NextSmAddrTSM <= AddrIncr(iSmAddrTSM, iMWWr, HsizeMemBuf,
                                        HburstMemBuf);
              NextSMADDRMC  <= ShiftAddr(IncrAddrWr, iMWWr);
            else
              NextSmAddrTSM <= AddrBuf;
              NextSMADDRMC  <= ShiftAddr(AddrBuf, MW);
            end if;

            -- If Synchronous memories are attempting to do an Asynchronous
            -- transfers then assert SMADDRVALIDMC along with SmCS.
            if (AddrValidWriteEn = '1') then
              iNxtSMADDRVALIDMC <= '0';
            else
              iNxtSMADDRVALIDMC <= '1';
            end if;

            -- Control signal used in Pad Interface to distinguish Async and
            -- Sync Access.
            iNextAsynAxs <= not SyncEnWrite;

            -- Prevent clock stopping if Synchronous memory access is required
            if ((SMClockEn = '0') and (SyncEnWrite = '0')) then
              NextClkStpd <= '1';
            else
              NextClkStpd <= '0';
            end if;

          -- If SMBUSGNT is sampled asserted and there are pending Read transfer
          -- to be performed(bcoz of break in burst) or NewBurst is been sampled
          -- then move to ST_READ state by appropriately loading the counters.
          elsif ((MemRdReq = '1') and (MemWrReq = '0')) then
            NextSmCSTSM      <= '0';
            iNextSMCSMC       <= ChipSelRouteH(HselMemBuf1);
            iNextSMCSMCn      <= ChipSelRouteL(HselMemBuf1);
            iNextSMDATAENMCn  <= (others => '1');
            NextSmTSMState   <= ST_READ;
            NextWstBrstRdCnt <= WSTBRD1;
            NextIDCYRead     <= IDCYC;

            if ((Temp /= "00000") and (NewBurst = '0') and
                (AhbWider = '1')) then
              NextSmAddrTSM <= AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                        HburstMemBuf);
              NextSMADDRMC  <= ShiftAddr(IncrAddr, MW1);
              NextBeatCount <= BoundaryChk(IncrAddr(5 downto 0), Temp,
                                           BurstLenRead1, MW1, HburstMemBuf,
                                           WrapRead, SyncEnRead1, HsizeMemBuf1,
                                           BMRead1);
            else
              NextSmAddrTSM <= AddrBuf1;
              NextSMADDRMC  <= ShiftAddr(AddrBuf1, MW1);
              NextBeatCount <= BoundaryChk(AddrBuf1(5 downto 0), AhbCount,
                                           BurstLenRead1, MW1, HburstMemBuf,
                                           WrapRead, SyncEnRead1, HsizeMemBuf1,
                                           BMRead1);
            end if;

            -- Start asserting SmOEn if it is wait enabled transfer or if the
            -- WSTOEN1 counter is programmed as zero.
            if ((WSTOEN1 = "0000") or (WaitEn = '1')) then
              iNextSmOEn     <= '0';
            else
              NextWstOEnCnt <= WSTOEN1;
            end if;

            -- logic to assert nSMBLSMC
            if ((RBLE = '1') and (MW1 /= MEM_BYTE)) then
              NextSMBLSMCn <= (SMBLSPol & SMBLSPol & SMBLSPol & SMBLSPol);
            else
              NextSMBLSMCn <= "1111";
            end if;

            -- Start asserting WaitRdCyc if WSTRD1 counter is programmed as ,
            -- in case of Asynchronous memories. Otherwise load the Long Read
            -- counter. This distinction is done because Asynchronous Memory
            -- accesses has to be By-passed.
            if ((WSTRD1 = "00000") and (SyncEnRead1 = '0')) then
              NextWaitRdCycVer <= '0';
              NextWstLongRdCnt <= (others => '0');
            else
              NextWstLongRdCnt <= WSTRD1;
            end if;

            -- If Synchronous memories are attempting to do an Asynchronous
            -- transfers then assert SMADDRVALIDMC along with SmCS.
            if (AddrValidReadEn1 = '1') then
              iNxtSMADDRVALIDMC <= '0';
            else
              iNxtSMADDRVALIDMC <= '1';
            end if;

            -- Control signal used in Pad Interface to distinguish Async and
            -- Sync Access.
            iNextAsynAxs <= not SyncEnRead1;

            -- Prevent clock stopping if Synchronous memory access is required
            if ((SMClockEn = '0') and (SyncEnRead1 = '0')) then
              NextClkStpd <= '1';
            else
              NextClkStpd <= '0';
            end if;

          -- If there is no Request then move to ST_NO_REQ state.
          else
            NextSmTSMState   <= ST_NO_REQ;
            NextSMBUSREQ     <= '0';
            NextBeatCount    <= (others => '0');
            NextIDCYRead     <= (others => '0');
            NextAhbWideRdReg <= (others => '0');
            NextWaitEnReg    <= '0';
            if (SMClockEn = '0') then
              NextClkStpd <= '1';
            else
              NextClkStpd <= '0';
            end if;
          end if;
        end if;
      end if;

    when ST_CANCEL_WAIT =>
      NextSmCSTSM      <= '1';
      iNextSMCSMC       <= (others => '0');
      iNextSMCSMCn      <= (others => '1');
      iNextSMDATAENMCn  <= (others => '1');
      NextSMBLSMCn     <= (others => '1');
      iNxtSMADDRVALIDMC <= '1';
      NextWriteProg    <= '0';
      if ((iSmCSTSM = '1') and (SMWaitSync = '1')) then
        NextIDCYRead     <= (others => '0');
        if (((TurnAround = '1') and (IDCYRead /= "0000")) or
            ((IDCYRead /= "0000") and (IDLECYC = '1'))) then
          NextSmTSMState   <= ST_TURNAROUND;
          NextIdcyCount    <= IDCYRead;
          NextWaitRdCycVer <= '1';

        -- Move to ST_NO_REQ state.
        else
          NextSmTSMState   <= ST_NO_REQ;
          NextSMBUSREQ     <= '0';
          NextBeatCount    <= (others => '0');
          NextIDCYRead     <= (others => '0');
          NextAhbWideRdReg <= (others => '0');
          if (SMClockEn = '0') then
            NextClkStpd <= '1';
          else
            NextClkStpd <= '0';
          end if;
        end if;
      end if;

    when others =>
      null;
  end case;
end process p_MemTSMComb;

-- -----------------------------------------------------------------------------
-- Logic to generate SleepModeReg signal.
-- This signal is set when BUSY is registered. This signal is very useful in
-- freezing the Memory signals if the BurstRead counter had expired.
-- OR comeback with the WaitRdCyc again when this signal dies down, because
-- reloading of the BurstRead counter will happen only when SleepMode signal
-- dies down.
-- -----------------------------------------------------------------------------
p_SleepModeComb : process (BUSYCYC, SleepModeReg)
begin
  NextSleepModeReg <= SleepModeReg;
  if ((BUSYCYC = '1') and (SleepModeReg = '0')) then
    NextSleepModeReg <= '1';
  elsif (BUSYCYC = '0') then
    NextSleepModeReg <= '0';
  end if;
end process p_SleepModeComb;

-- -----------------------------------------------------------------------------
-- Logic to generate SleepMode signal.
-- This is nothing but the BUSYCYC extended by 1 SMMEMCLK after it dies down.
-- -----------------------------------------------------------------------------
SleepMode <= BUSYCYC;

-- -----------------------------------------------------------------------------
-- Logic to generate ContWithBrst signal.
-- This signal is useful in continuing with Burst write transfers for
-- Synchronous Memories.
-- -----------------------------------------------------------------------------
p_ContBrstComb : process (ContWithBrst, iHsizeEqMWidthWr, WRITECYC, UseSecBuf,
                          HtranRegCont, NewBurst, HtransMemBuf1, WriteSt)
begin
  NextContWithBrst <= ContWithBrst;
  if ((iHsizeEqMWidthWr = '1') and (WRITECYC = '1') and (ContWithBrst = '0') and
      (HtranRegCont = HTRANS_SEQ) and (NewBurst = '1') and (WriteSt = '0') and
      (UseSecBuf = '0')) then
    NextContWithBrst <= '1';
  elsif (HtransMemBuf1 = HTRANS_SEQ) then
    NextContWithBrst <= '0';
  end if;
end process p_ContBrstComb;

-- -----------------------------------------------------------------------------
-- Logic to generate MemoryRdSt signal.
-- -----------------------------------------------------------------------------
MemoryRdSt <= '1' when ((ReadSt = '1') or (BurstReadSt = '1') or
                        (((WaitAssrtSt = '1') or (iWaitDeAssrtSt = '1')) and
                         (DelSmOEnMC = '0')))
           else
              '0';

-- -----------------------------------------------------------------------------
-- Logic to generate MemoryWrSt signal.
-- -----------------------------------------------------------------------------
MemoryWrSt <= '1' when ((WriteSt = '1') or (iBurstWriteSt = '1') or
                        (WriteProg = '1'))
           else
              '0';

-- -----------------------------------------------------------------------------
-- Registering all Next state signals
-- -----------------------------------------------------------------------------
p_MemRegSeq : process (SMMEMCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmTSMState       <= ST_NO_REQ;
    iSmCSTSM         <= '1';
    iSmOEnMC         <= '1';
    iWaitRdCycVer    <= '1';
    iWaitWrCycVer    <= '1';
    iWaitWrCycDup    <= '1';
    iWaitWrCycAhb    <= '1';
    iSmAddrTSM       <= (others => '0');
    iSMADDRMC        <= (others => '0');
    iSMWENMC         <= '1';
    iSMADDRVALIDMC   <= '1';
    iSMBAAMC         <= '1';
    WstLongRdCnt     <= (others => '0');
    WstBrstRdCnt     <= (others => '0');
    WstWrCnt         <= (others => '0');
    WstWrEnCnt       <= (others => '0');
    WstOEnCnt        <= (others => '0');
    BeatCount        <= (others => '0');
    SleepModeReg     <= '0';
    IDCYRead         <= (others => '0');
    IdcyCount        <= (others => '0');
    AhbWideRdReg     <= (others => '0');
    iWriteBeatCnt    <= (others => '0');
    DelSMWENMC       <= '0';
    iToggle          <= '0';
    HselMemBufWr     <= (others => '0');
    HburstMemBufWr   <= (others => '0');
    iMWWr            <= (others => '0');
    SMBLSPolWr       <= '0';
    iHsizeMemBufWr   <= (others => '0');
    iHsizeEqMWidthWr <= '0';
    iAhbWiderWr      <= '0';
    iAhbNarrowWr     <= '0';
    iRBLEWr          <= '0';
    WriteProg        <= '0';
    DelSmOEnMC       <= '0';
    iWaitEnReg       <= '0';
    iSyncEnWriteReg  <= '0';
    iBMWriteReg      <= '0';
    BIWriteEnReg     <= '0';
    BurstLenWrReg    <= (others => '0');
    AddrValWrEnReg   <= '0';
    WSTWRReg         <= (others => '0');
    WSTWENReg        <= (others => '0');
    SmBurstWaitReg   <= '1';
    DelSmBurstWait   <= '1';
    iSMBUSREQ        <= '0';
    StopBurst        <= '0';
    ContWithBrst     <= '0';
    DelSmCSTSM       <= '1';
    iClkStpd         <= '1';
    DelAhbWideWrCnt  <= (others => '0');
    SyncWtOnMCLK     <= '1';
    NewBrstOccrd     <= '0';
    iSMCSMC          <= (others => '0');
    iSMCSMCn         <= (others => '1');
    iSMDATAENMCn     <= (others => '1');
    iSMBLSMCn        <= (others => '1');
    iAsynAxs         <= '1';
    Stop2WtWrCyc     <= '0';
    iWBstIntrptd      <= '0';
    FirstSyncWt      <= '0';
    XtraTxr          <= '0';
    DelWaitWrCycVer  <= '1';
    iTxrB4BsyAccptd   <= '0';
    DelUseSecBuf     <= '0';
  elsif (SMMEMCLK'event and SMMEMCLK = '1') then
    SmTSMState       <= NextSmTSMState;
    iSmCSTSM         <= NextSmCSTSM;
    iSmOEnMC         <= iNextSmOEn;
    iWaitRdCycVer    <= NextWaitRdCycVer;
    iWaitWrCycVer    <= NextWaitWrCycVer;
    iWaitWrCycDup    <= NextWaitWrCycDup;
    iWaitWrCycAhb    <= NextWaitWrCycAhb;
    iSmAddrTSM       <= NextSmAddrTSM;
    iSMADDRMC        <= NextSMADDRMC;
    iSMWENMC         <= NextSmWrEn;
    iSMADDRVALIDMC   <= iNxtSMADDRVALIDMC;
    iSMBAAMC         <= iNextSMBAAMC;
    WstLongRdCnt     <= NextWstLongRdCnt;
    WstBrstRdCnt     <= NextWstBrstRdCnt;
    WstWrCnt         <= NextWstWrCnt;
    WstWrEnCnt       <= NextWstWrEnCnt;
    WstOEnCnt        <= NextWstOEnCnt;
    BeatCount        <= NextBeatCount;
    SleepModeReg     <= NextSleepModeReg;
    IDCYRead         <= NextIDCYRead;
    AhbWideRdReg     <= NextAhbWideRdReg;
    IdcyCount        <= NextIdcyCount;
    iWriteBeatCnt    <= NextWriteBeatCnt;
    DelSMWENMC       <= iSMWENMC;
    iToggle          <= NextToggle;
    HselMemBufWr     <= NextHselMemBufWr;
    HburstMemBufWr   <= NextHburstMemBufWr;
    iMWWr            <= NextMWWr;
    iHsizeMemBufWr   <= NxtHsizeMemBufWr;
    iHsizeEqMWidthWr <= NextHsizeEqMW;
    iAhbWiderWr      <= NextAhbWiderWr;
    iAhbNarrowWr     <= NextAhbNarrowWr;
    iRBLEWr          <= NextRBLEWr;
    SMBLSPolWr       <= NextSMBLSPolWr;
    WriteProg        <= NextWriteProg;
    DelSmOEnMC       <= iSmOEnMC;
    iWaitEnReg       <= NextWaitEnReg;
    iSyncEnWriteReg  <= NextSyncEnWr;
    iBMWriteReg      <= NextBMWriteReg;
    BIWriteEnReg     <= NextBIWriteEnReg;
    BurstLenWrReg    <= NextBurstLenWr;
    AddrValWrEnReg   <= NextAddrValWrReg;
    WSTWRReg         <= NextWSTWRReg;
    WSTWENReg        <= NextWSTWENReg;
    SmBurstWaitReg   <= SmBurstWtFbClk;
    DelSmBurstWait   <= SyncWtOnMCLK;
    iSMBUSREQ        <= NextSMBUSREQ;
    StopBurst        <= NextStopBurst;
    ContWithBrst     <= NextContWithBrst;
    DelSmCSTSM       <= iSmCSTSM;
    iClkStpd         <= NextClkStpd;
    DelAhbWideWrCnt  <= AhbWideWrCnt;
    SyncWtOnMCLK     <= SyncWtSingle;
    NewBrstOccrd     <= NextNewBrstOccrd;
    iSMCSMC          <= iNextSMCSMC;
    iSMCSMCn         <= iNextSMCSMCn;
    iSMDATAENMCn     <= iNextSMDATAENMCn;
    iSMBLSMCn        <= NextSMBLSMCn;
    iAsynAxs         <= iNextAsynAxs;
    Stop2WtWrCyc     <= NextStop2WtWrCyc;
    iWBstIntrptd      <= NextWBstIntrptd;
    FirstSyncWt      <= NextFirstSyncWt;
    XtraTxr          <= NextXtraTxr;
    DelWaitWrCycVer  <= WaitWrCycVerAnd;
    iTxrB4BsyAccptd   <= NextTxrB4BsyAccptd;
    DelUseSecBuf     <= UseSecBuf;
  end if;
end process p_MemRegSeq;

-- synopsys translate_off
-- ----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- ----------------------------------------------------------------------------

-- Protocol checkers can be used for debugging purposes.
p_IllegalProgComb : process (SmTSMState)
variable Concat : std_logic_vector(4 downto 0);
begin
  Concat := ('0' & WSTWEN);
  if (SmTSMState = ST_WRITE) then
    if (WSTWR < Concat) then
      assert false
      report "WSTWEN is programmed greater than WSTWR Register"
      severity warning;
    end if;
    if ((SyncEnWrite = '1') and (WaitEn = '1')) then
      assert false
      report "Synchronous devices is programmed for Wait Enabled Transfer"
      severity warning;
    end if;
  end if;

  Concat := ('0' & WSTOEN1);
  if (SmTSMState = ST_READ) then
    if (WSTRD1 < Concat) then
      assert false
      report "WSTOEN is programmed greater than WSTRD1 Register"
      severity warning;
    end if;
    if ((SyncEnRead1 = '1') and (WaitEn = '1')) then
      assert false
      report "Synchronous devices is programmed for Wait Enabled Transfer"
      severity warning;
    end if;
  end if;
end process p_IllegalProgComb;

-- ----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- ----------------------------------------------------------------------------
-- synopsys translate_on

end synth;

-- --================================== End ==================================--
