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
-- File Name              : SsmcAhbSlvMemIf.vhd.rca
-- File Revision          : 1.34
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Provides CPU memory access to the SSMC Controller
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SsmcPackage.all;

-- -----------------------------------------------------------------------------

entity SsmcAhbSlvMemIf is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
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
        WaitWrCycVer     : in    std_logic; -- Memory device write completion
                                            -- signal
        WaitWrCycDup     : in    std_logic; -- Memory device write completion
                                            -- signal when Wait Transfer is
                                            -- pipelined
        WaitWrCycAhb     : in    std_logic; -- Memory device write completion
                                            -- signal when Synchronous Transfer
                                            -- is pipelined
        ClockRatio       : in    std_logic_vector(1 downto 0);
                                            -- Indicates ratio of Memory Clock
                                            -- with respect to HCLK
        WaitRdCyc        : in    std_logic; -- Memory device read completion
                                            -- signal
        WaitRdCycVer     : in    std_logic; -- Version of WaitRdCyc
        SmCSTSM          : in    std_logic; -- Chip Select Assertion
        DelSmCSTSM       : in    std_logic; -- Delayed version of SmCSTSM
        SmDataInFbclk    : in    std_logic_vector(31 downto 0);
                                            -- Data for Memory Banks from
                                            -- Pad interface
        HsizeEqMWidthWr  : in    std_logic; -- Indication that AHB and Memory
                                            -- are of same width
        AhbWiderWr       : in    std_logic; -- Indication that AHB Width is
                                            -- greater than Memory Width
        AhbNarrowWr      : in    std_logic; -- Indication that AHB Width is
                                            -- narrower than Memory Width
        nSmBurstWaitReg  : in    std_logic; -- Registered nSMBURSTWAIT
        MW1              : in    std_logic_vector(1 downto 0);
                                            -- 1st level registered memory
                                            -- width bits selection from one of
                                            -- the bank registers
        SMBLSPol1        : in    std_logic; -- 1st level registered memory
                                            -- Byte lane polarity bit from one
                                            -- of the bank registers
        BIWriteEn1       : in    std_logic; -- Indication that SMBAA active
                                            -- during Synchronous Burst Write
                                            -- access, 1st level buffered
        BMWrite1         : in    std_logic; -- 1st level Burst Mode Write
        SyncEnRead1      : in    std_logic; -- 1st level Sync burst Mode read
        SyncEnWrite1     : in    std_logic; -- 1st level Sync burst Mode Write
        BurstLenRead1    : in    std_logic_vector(1 downto 0);
                                            -- 1st level Burst transfer length,
                                            -- by Burst devices for Read
        BurstLenWrite1   : in    std_logic_vector(1 downto 0);
                                            -- 1st level Burst transfer length,
                                            -- by Burst devices for Write
        AddrValWriteEn1  : in    std_logic; -- 1st level SMADDRVALID enable
                                            -- during Write
        WP1              : in    std_logic; -- 1st level Write protection
        RBLE1            : in    std_logic; -- 1st level Byte lane enable
        WaitEn1          : in    std_logic; -- 1st level Wait Enable indication
        WaitPol1         : in    std_logic; -- 1st level Indication of the
                                            -- polarity of SMWAIT
        WSTWR1           : in    std_logic_vector(4 downto 0);
                                            -- 1st level Write access count
        WSTWEN1          : in    std_logic_vector(3 downto 0);
                                            -- 1st level Delay value for the
                                            -- assertion of the WEN and nSMCS
        IDCYC1           : in    std_logic_vector(3 downto 0);
                                            -- 1st level Count value for the
                                            -- turnaround cycles
        InitSt           : in    std_logic; -- Indication that Memory SM is in
                                            -- ST_NO_REQ State
        BurstWriteSt     : in    std_logic; -- Indication that Memory SM is in
                                            -- BURSTWRITE State
        TurnAroundSt     : in    std_logic; -- Indication that Memory SM is in
                                            -- TURNAROUND State
        WaitTxrOnBusSt   : in    std_logic; -- Indication that Memory SM is in
                                            -- WAITTXRONBUS State
        WaitDeAssrtSt    : in    std_logic; -- Indication that Memory SM is in
                                            -- WAITDEASSERTED State
        CancelWaitSt     : in    std_logic; -- Indication that Memory SM is in
                                            -- CANCELWAIT State
        MemoryWrSt       : in    std_logic; -- Indication that Memory TSM is in
                                            -- Write state
        MemoryRdSt       : in    std_logic; -- Indication that Memory TSM is in
                                            -- Read state
        Toggle           : in    std_logic; -- Indication of State switching
                                            -- when SM is waiting for new AHB
                                            -- Bus accesses
        SmAddrTSM        : in    std_logic_vector(1 downto 0);
                                            -- Memory Address from SsmcMemTSM
                                            -- module
        BIGENDIAN        : in    std_logic; -- Type of endianness of the system
        WaitEnReg        : in    std_logic; -- Wait Enable signal registered
                                            -- when write begins.
        BMWriteReg       : in    std_logic; -- Burst Mode Write indication
                                            -- registered when write begins
        SyncEnWriteReg   : in    std_logic; -- Synchronous Write Enable signal
                                            -- registered when write begins
        WriteBeatCnt     : in    std_logic_vector(2 downto 0);
                                            -- Counter used for carrying out
                                            -- Burst Write
        WBstIntrptd      : in    std_logic;
        TxrB4BsyAccptd   : in    std_logic;
        SlowClkM         : in    std_logic; -- Slow clock indicator to HCLK side
-- Outputs
        HREADYOUTSMC     : out   std_logic; -- Indicates completion of Memory
                                            -- accesses
        HRESPSMC         : out   std_logic_vector(1 downto 0);
                                            -- SSMCCore response output, for
                                            -- Memory accesses
        HRDATASMC        : out   std_logic_vector(31 downto 0);
                                            -- Data for AHB from Memory Banks
        UseSecBuf        : out   std_logic; -- Indication to use second level
                                            -- buffered resources during Write
        HtranRegCont     : out   std_logic_vector(1 downto 0);
                                            -- HTRANSSMC registered on every
                                            -- clock
        HtransMemBuf1    : out   std_logic_vector(1 downto 0);
                                            -- Level1 Buffer to hold HTRANSSMC
        HsizeEqMWidth    : out   std_logic; -- Indication that AHB and Memory
                                            -- are of same width
        AhbWider         : out   std_logic; -- Indication that AHB Width is
                                            -- greater than Memory Width
        AhbNarrow        : out   std_logic; -- Indication that AHB Width is
                                            -- narrower than Memory Width
        MemWrReq         : out   std_logic; -- Signal indicating that write
                                            -- transfer is initiated
        MemRdReq         : out   std_logic; -- Signal indicating that read
                                            -- transfer is initiated
        TurnAround       : out   std_logic; -- TurnAround indication for R->W
                                            -- and R->R for diff memory bank
        NewBurst         : out   std_logic; -- Indication that new burst is
                                            -- sampled
        AhbCount         : out   std_logic_vector(4 downto 0);
                                            -- Indication of number of Memory
                                            -- transfer requested by AHB
        WaitToutErr      : out   std_logic; -- Waited Access Error indication
        NextValByteLane0 : out   std_logic; -- Indication that Byte Lane0 is
                                            -- valid during write operation
        NextValByteLane1 : out   std_logic; -- Indication that Byte Lane1 is
                                            -- valid during write operation
        NextValByteLane2 : out   std_logic; -- Indication that Byte Lane2 is
                                            -- valid during write operation
        NextValByteLane3 : out   std_logic; -- Indication that Byte Lane3 is
                                            -- valid during write operation
        BUSYCYC          : out   std_logic; -- Indication that SM is in
                                            -- ST_MEM_BUSY state
        IDLECYC          : out   std_logic; -- Indication that SM is in
                                            -- ST_MEM_NOT_SEL state
        WRITECYC         : out   std_logic; -- Indication that SM is in
                                            -- ST_MEM_WRITE state
        AddrBuf1         : out   std_logic_vector(25 downto 0);
                                            -- Level1 Buffer to hold HADDRSMC
        AddrBuf          : out   std_logic_vector(25 downto 0);
                                            -- Buffered AHB Address is
                                            -- multiplexed and then driven out
        HwdataBuf        : out   std_logic_vector(31 downto 0);
                                            -- Buffered AHB Data is
                                            -- multiplexed and then driven out
        HsizeMemBuf1     : out   std_logic_vector(1 downto 0);
                                            -- Level1 buffer to hold HSIZESMC
        HsizeMemBuf      : out   std_logic_vector(1 downto 0);
                                            -- Buffered AHB HSIZESMC is
                                            -- multiplexed and then driven out
        HburstMemBuf     : out   std_logic_vector(2 downto 0);
                                            -- Buffered HBURSTSMC is
                                            -- multiplexed and then driven out
        HselMemBuf1      : out   std_logic_vector(7 downto 0);
                                            -- 1st level registered HSELSMC
        HselMemBuf       : out   std_logic_vector(7 downto 0);
                                            -- Buffered HSELSMC is
                                            -- multiplexed and then driven out
        AhbWideRdCnt     : out   std_logic_vector(2 downto 0);
                                            -- Counter which indicates number of
                                            -- Memory accesses required for one
                                            -- AHB Read transfer
        AhbWideWrCnt     : out   std_logic_vector(2 downto 0);
                                            -- Counter for number of Memory
                                            -- Write accesses required for
                                            -- 1 AHB Write transfer
        AddrNotAligned   : out   std_logic; -- Indication that starting address
                                            -- is not aligned to Memory Width
        MW               : out   std_logic_vector(1 downto 0);
                                            -- The memory width bits selection
                                            -- from one of the bank registers
        SMBLSPol         : out   std_logic; -- Byte lane polarity bit selection
                                            -- from one of the bank registers
        BMWrite          : out   std_logic; -- Burst Mode Write indication
        SyncEnWrite      : out   std_logic; -- Synchronous burst Mode Write
        BurstLenWrite    : out   std_logic_vector(1 downto 0);
                                            -- Burst transfer length, supported
                                            -- by Burst devices for Write
        AddrValidWriteEn : out   std_logic; -- SMADDRVALID enable during Write
        BIWriteEn        : out   std_logic; -- Indication that SMBAA active
                                            -- during Synchronous Burst Write
                                            -- access
        RBLE             : out   std_logic; -- Byte lane enabled device
                                            -- of SMWAIT
        WaitEn           : out   std_logic; -- Wait Enable indication
        WaitPol          : out   std_logic; -- Indication of the Wait polarity
        WSTWR            : out   std_logic_vector(4 downto 0);
                                            -- Single Write access count for the
                                            -- bank targeted currently
        WSTWEN           : out   std_logic_vector(3 downto 0);
                                            -- Delay value for the assertion
                                            -- of the WEN and nSMCS signals
        IDCYC            : out   std_logic_vector(3 downto 0)
                                            -- Count value for the turnaround
                                            -- cycles
       );
end SsmcAhbSlvMemIf;

-- -----------------------------------------------------------------------------
--
--                               SsmcAhbSlvMemIf
--                               ===============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           It consists of the AHB response generation logic, AHB Slave State
--           Machine for Memory accesses, Read and Write request generation.
--           Counters when AHB Width does not match Memory Width. Read Data Path
--           logic.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of SsmcAhbSlvMemIf is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iBUSYCYC         : std_logic;
-- Internal signal of BUSYCYC

signal DelBUSYCYC       : std_logic;
-- 1 HCLK Delayed BUSYCYC

signal iIDLECYC         : std_logic;
-- Internal signal of IDLECYC

signal DelIDLECYC       : std_logic;
-- 1 HCLK Delayed IDLECYC

signal iWRITECYC        : std_logic;
-- Internal signal of WRITECYC

signal DelWRITECYC      : std_logic;
-- 1 HCLK delayed iWRITECYC

signal READCYC          : std_logic;
-- Indication that SM is in ST_MEM_READ state

signal DelREADCYC       : std_logic;
-- 1 HCLK delayed READCYC

signal iHRESPSMC        : std_logic_vector (1 downto 0);
-- Internal signal of HRESPSSMC

signal NextHRESPSMC     : std_logic_vector (1 downto 0);
-- D-input of iHRESPSMC register

signal iHREADYOUTSMC    : std_logic;
-- Internal signal of HREADYOUTSMC

signal NextHREADYOUTSMC : std_logic;
-- D-input of iHREADYOUTSMC register

signal iAddrBuf1        : std_logic_vector (25 downto 0);
-- Internal signal of AddrBuf1

signal NextAddrBuf1     : std_logic_vector (25 downto 0);
-- D-input of iAddrBuf1 register

signal AddrBuf2         : std_logic_vector (25 downto 0);
-- Level2 Buffer to hold AddrBuf1

signal NextAddrBuf2     : std_logic_vector (25 downto 0);
-- D-input of the AddrBuf2 register

signal SmMemSlaveState  : std_logic_vector (4 downto 0);
-- State vector of Slave State Machine

signal NextSmMemSlaveSt : std_logic_vector (4 downto 0);
-- D-input of SmMemSlaveState register

signal iHtransMemBuf1   : std_logic_vector (1 downto 0);
-- Internal signal of HtransMemBuf1

signal NxtHtransMemBuf1 : std_logic_vector (1 downto 0);
-- D-input of the iHtransMemBuf1 register

signal iHburstMemBuf    : std_logic_vector (2 downto 0);
-- Internal signal of HburstMemBuf

signal NxtHburstMemBuf  : std_logic_vector (2 downto 0);
-- D-input of the iHburstMemBuf register

signal iHsizeMemBuf     : std_logic_vector (1 downto 0);
-- Internal signal of HsizeMemBuf

signal iHsizeMemBuf1    : std_logic_vector (2 downto 0);
-- Internal signal of HsizeMemBuf1

signal NextHsizeMemBuf1 : std_logic_vector (2 downto 0);
-- D-input of the iHsizeMemBuf1 register

signal HsizeMemBuf2     : std_logic_vector (1 downto 0);
-- Level2 buffer to hold HsizeMemBuf1

signal NextHsizeMemBuf2 : std_logic_vector (1 downto 0);
-- D-input of the HsizeMemBuf2 register

signal HSizeErrMem      : std_logic;
-- HSIZE Error indication during Memory transfers

signal iNewBurst        : std_logic;
-- Internal signal of NewBurst

signal iWaitToutErr     : std_logic;
-- Internal signal of WaitToutErr

signal WriteProtErr     : std_logic;
-- Write protect Error indication

signal WaitWrCycMux     : std_logic;
-- Indication to AHB SM to wait the Write transfer

signal DelWaitWrCycMux  : std_logic;
-- 1 HCLK Delayed WaitWrCycMux

signal WaitRdCycMux     : std_logic;
-- Indication to AHB SM to wait the Read transfer

signal ErrCond          : std_logic;
-- Indication of Error condition

signal HselSmcOr        : std_logic;
-- OR'ed signal of HSELSMC[7:0]

signal iHselMemBuf      : std_logic_vector(7 downto 0);
-- Internal signal of HselMemBuf

signal iHselMemBuf1     : std_logic_vector(7 downto 0);
-- 1st level registered HSELSMC

signal NextHselMemBuf1  : std_logic_vector(7 downto 0);
-- D-Input of iHselMemBuf1 register

signal DelHselMemBuf1   : std_logic_vector(7 downto 0);
-- 1 HCLK Delayed iHselMemBuf1

signal HselMemBuf2      : std_logic_vector(7 downto 0);
-- 2nd level buffer to hold HselMemBuf1

signal NextHselMemBuf2  : std_logic_vector(7 downto 0);
-- D-Input of HselMemBuf2 register

signal MemRdMask        : std_logic;
-- Mask for Read request

signal MemRdMaskReg     : std_logic;
-- Mask for Read request - Intermediate form

signal NextMemRdMaskReg : std_logic;
-- D-input of MemRdMaskReg register

signal DelMemRdMaskReg  : std_logic;
-- 1HCLK delayed version of MemRdMaskReg

signal MemRdBusy        : std_logic;
-- Mask for Read request when BUSY is inserted for last beat, for the case when
-- AHB is narrower than Memory width

signal NextMemRdBusy    : std_logic;
-- D-input of MemRdBusy register

signal MemRdMaskPulse   : std_logic;
-- Pulse which indiactes that BUSY was inserted for last beat, for the case when
-- AHB is narrower than Memory width

signal iAhbWider        : std_logic;
-- Internal signal of AhbWider

signal iAhbNarrow       : std_logic;
-- Internal signal of AhbNarrow

signal iHsizeEqMWidth   : std_logic;
-- Internal signal of HsizeEqMWidth

signal AddrNotAlignComb : std_logic;
-- Pulse wide signal indicating Address is not aligned

signal iAddrNotAligned  : std_logic;
-- Indication that starting address is not aligned to Memory Width

signal AddrNotAlignReg  : std_logic;
-- Register to hold AddrNotAlignComb till it is seen by other logic in Memory
-- clock domain

signal NextAddrNotAlign : std_logic;
-- D-Input of AddrNotAlignReg

signal iHtranRegCont    : std_logic_vector(1 downto 0);
-- Internal signal of HtranRegCont

signal NseqRdCyc        : std_logic;
-- NewBurst indication by registering HTRANSSMC when WaitRdCyc is de-asserted

signal iAhbWideRdCnt    : std_logic_vector(2 downto 0);
-- Internal signal of AhbWideRdCnt

signal NextAhbWideRdCnt : std_logic_vector(2 downto 0);
-- D-input of iAhbWideRdCnt register

signal AhbLessRdCnt     : std_logic_vector(2 downto 0);
-- Counter which indicates no of AHB Read required for 1 Memory Accesses

signal NextAhbLessRdCnt : std_logic_vector(2 downto 0);
-- D-input of AhbLessRdCnt register

signal DelAhbLessRdCnt  : std_logic_vector(2 downto 0);
-- 1 HCLK Delayed Counter

signal WriteRqBuf       : std_logic;
-- Write request buffered

signal NextWriteRqBuf   : std_logic;
-- D-input of WriteRqBuf register

signal WriteMask        : std_logic;
-- Mask for Write request

signal DelWriteMask     : std_logic;
-- 1 HCLK delayed WriteMask

signal WriteMaskComb    : std_logic;
-- Combinational Mask signal, which is active till WriteMaskBuf is set

signal WriteMaskBuf     : std_logic;
-- Buffered Mask for Write

signal NextWriteMaskBuf : std_logic;
-- D-input of WriteMaskBuf register

signal AhbLessWrCnt     : std_logic_vector(2 downto 0);
-- Counter for number of AHB Write accesses required for 1 Memory Write transfer

signal NextAhbLessWrCnt : std_logic_vector(2 downto 0);
-- D-input of AhbLessWrCnt register

signal iAhbWideWrCnt    : std_logic_vector(2 downto 0);
-- Internal signal of AhbWideWrCnt

signal NextAhbWideWrCnt : std_logic_vector(2 downto 0);
-- D-input of iAhbWideWrCnt register

signal iUseSecBuf       : std_logic;
-- Internal signal of UseSecBuf

signal NextUseSecBuf    : std_logic;
-- D-input of iUseSecBuf register

signal WaitWrFirstCyc   : std_logic;
-- Indication to de-assert WaitWrCycMux, to maintain posted write feature

signal WtWrFrstCycComb  : std_logic;
-- Same as WaitWrFirstCyc signal when clock ratio is 1:1

signal WtWrFrstReg      : std_logic;
-- Registering of WtWrFrstCycComb signal when clock ratios are different

signal NextWtWrFrstReg  : std_logic;
-- D-Input of WtWrFrstReg

signal WaitEnWrFirstCyc : std_logic;
-- Indication to load Write related counters, when WaitEn is asserted for Write

signal SMBLSPol2        : std_logic;
-- 2nd level registered signal of SMBLSPol

signal NextSMBLSPol2    : std_logic;
-- D-Input of SMBLSPol2 register

signal iMW              : std_logic_vector(1 downto 0);
-- Internal signal of MW

signal MW2              : std_logic_vector(1 downto 0);
-- 2nd level registered signal of MW

signal NextMW2          : std_logic_vector(1 downto 0);
-- D-Input of MW2 register

signal BMWrite2         : std_logic;
-- 2nd level registered signal of BMWrite

signal NextBMWrite2     : std_logic;
-- D-Input of BMWrite2 register

signal SyncEnWr2        : std_logic;
-- 2nd level registered signal of SyncEnWr

signal NextSyncEnWr2    : std_logic;
-- D-Input of SyncEnWr2 register

signal BurstLenWr2      : std_logic_vector(1 downto 0);
-- 2nd level registered signal of BurstLenWr

signal NextBurstLenWr2  : std_logic_vector(1 downto 0);
-- D-Input of BurstLenWr2 register

signal AddrValWrEn2     : std_logic;
-- 2nd level registered signal of AddrValWrEn

signal NextAddrValWrEn2 : std_logic;
-- D-Input of AddrValWrEn2 register

signal BIWriteEn2       : std_logic;
-- 2nd level registered signal of BIWriteEn

signal NextBIWriteEn2   : std_logic;
-- D-Input of BIWriteEn2 register

signal WP               : std_logic;
-- Write Protect Indication

signal WP2              : std_logic;
-- 2nd level registered signal of WP

signal NextWP2          : std_logic;
-- D-Input of WP2 register

signal RBLE2            : std_logic;
-- 2nd level registered signal of RBLE

signal NextRBLE2        : std_logic;
-- D-Input of RBLE2 register

signal WaitEn2          : std_logic;
-- 2nd level registered signal of WaitEn

signal NextWaitEn2      : std_logic;
-- D-Input of WaitEn2 register

signal iWaitEn          : std_logic;
-- Internal signal of WaitEn

signal WaitPol2         : std_logic;
-- 2nd level registered signal of WaitPol

signal NextWaitPol2     : std_logic;
-- D-Input of WaitPol2 register

signal WSTWR2           : std_logic_vector(4 downto 0);
-- 2nd level registered signal of WSTWR

signal NextWSTWR2       : std_logic_vector(4 downto 0);
-- D-Input of WSTWR2 register

signal WSTWEN2          : std_logic_vector(3 downto 0);
-- 2nd level registered signal of WSTWEN

signal NextWSTWEN2      : std_logic_vector(3 downto 0);
-- D-Input of WSTWEN2 register

signal IDCYC2           : std_logic_vector(3 downto 0);
-- 2nd level registered signal of IDCYC

signal NextIDCYC2       : std_logic_vector(3 downto 0);
-- D-Input of IDCYC2 register

signal HwdataBuf1       : std_logic_vector(31 downto 0);
-- 1st level buffered signal of HWDATASMC

signal NextHwdataBuf1   : std_logic_vector(31 downto 0);
-- D-Input of HwdataBuf1 register

signal HwdataBuf2       : std_logic_vector(31 downto 0);
-- 2nd level registered signal of HwdataBuf1

signal NextHwdataBuf2   : std_logic_vector(31 downto 0);
-- D-Input of HwdataBuf2 register

signal HwdataBufMux     : std_logic_vector(31 downto 0);
-- 

signal HwdataBufReg     : std_logic_vector(31 downto 0);
-- 

signal DelHreadyOut     : std_logic;
-- Delayed iHREADYOUTSMC

signal NewBurstComb     : std_logic;
-- Combinational signal indicating New Burst.

signal ValByteLane0     : std_logic;
-- Byte Lane0 is valid during write operation

signal iNxtValByteLane0 : std_logic;
-- D-Input of ValByteLane0 register

signal ValByteLane1     : std_logic;
-- Byte Lane1 is valid during write operation

signal iNxtValByteLane1 : std_logic;
-- D-Input of ValByteLane1 register

signal ValByteLane2     : std_logic;
-- Byte Lane2 is valid during write operation

signal iNxtValByteLane2 : std_logic;
-- D-Input of ValByteLane2 register

signal ValByteLane3     : std_logic;
-- Byte Lane3 is valid during write operation

signal iNxtValByteLane3 : std_logic;
-- D-Input of ValByteLane3 register

signal TurnAroundComb   : std_logic;
-- Turnaround indication generated combinationally

signal TurnArndReg      : std_logic;
-- TurnAround indication is registered so that it is sustained till SlowClkM is
-- high

signal NextTurnArndReg  : std_logic;
-- D-Input of TurnArndReg register

signal NewBrstReg       : std_logic;
-- New Burst indication is registered so that it is sustained till SlowClkM is
-- high

signal NextNewBrstReg   : std_logic;
-- D-Input of NewBrstReg register

signal iHRDATASMC       : std_logic_vector(31 downto 0);
-- Internal signal of HRDATASMC

signal NextHrdataSmc    : std_logic_vector(31 downto 0);
-- D-Input of iHRDATASMC register

signal iMemRdReq        : std_logic;
-- Internal signal of MemRdReq

signal AddrNotAlgnRd    : std_logic;
-- Address not aligned for read accesses

signal NextAddrAlgnRd   : std_logic;
-- D-Input of AddrNotAlgnRd register

signal DelSmBurstWait   : std_logic;
-- Delayed nSmBurstWaitReg

signal BurstPulse       : std_logic;
-- Pulse when nSmBurstWaitReg is asserted

signal DelWaitWrCycAhb  : std_logic;
-- 1 HCLK Delayed WaitWrCycAhb

signal WaitWrCycAhbAnd  : std_logic;
-- WaitWrCycAhb anded with SlowClkM

signal WaitWrCycAhbMux  : std_logic;
-- Mux to select between different sources of WaitWrCycAhb's

signal WaitAssrtd       : std_logic;
-- Indication that nSmBurstWaitReg is asserted and we have to use Pipelined data

signal NextWaitAssrtd   : std_logic;
-- D-Input of WaitAssrtd register

signal HwdataBuf3       : std_logic_vector(31 downto 0);
-- 2nd level registered signal of HwdataBuf1

signal NextHwdataBuf3   : std_logic_vector(31 downto 0);
-- D-Input of HwdataBuf3 register

signal HwdataBufInt     : std_logic_vector(31 downto 0);
-- Internal HwdataBuf before the Final Mux

signal UseSecBufVer     : std_logic;
-- Indication to use second level buffered information

signal NextUseSecBufVer : std_logic;
-- D-Input of UseSecBufVer register

signal BsyLstBt         : std_logic;
-- Indication that Busy was inserted for the last beat of AhbLessRdCnt counter

signal NextBsyLstBt     : std_logic;
-- D-Input of BsyLstBt register

signal extracond        : std_logic;
-- BNT...

signal extracond1       : std_logic;
-- BNT...

signal ValWrBrstSt      : std_logic;
-- BNT...

signal NextValWrBrstSt  : std_logic;
-- BNT...

signal UseSecBufExtd    : std_logic;
-- BNT...

-- -----------------------------------------------------------------------------
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
-- Internal Signal Assignments
-- -----------------------------------------------------------------------------
HREADYOUTSMC     <= iHREADYOUTSMC;
HRESPSMC         <= iHRESPSMC;
BUSYCYC          <= iBUSYCYC;
NewBurst         <= iNewBurst;
WaitToutErr      <= iWaitToutErr;
HtranRegCont     <= iHtranRegCont;
HburstMemBuf     <= iHburstMemBuf;
MW               <= iMW;
AhbWideWrCnt     <= iAhbWideWrCnt;
AhbWideRdCnt     <= iAhbWideRdCnt;
HselMemBuf       <= iHselMemBuf;
HsizeMemBuf      <= iHsizeMemBuf;
HsizeEqMWidth    <= iHsizeEqMWidth;
AhbWider         <= iAhbWider;
AhbNarrow        <= iAhbNarrow;
IDLECYC          <= iIDLECYC;
WRITECYC         <= iWRITECYC;
NextValByteLane0 <= iNxtValByteLane0;
NextValByteLane1 <= iNxtValByteLane1;
NextValByteLane2 <= iNxtValByteLane2;
NextValByteLane3 <= iNxtValByteLane3;
HRDATASMC        <= iHRDATASMC;
WaitEn           <= iWaitEn;
MemRdReq         <= iMemRdReq;
AddrNotAligned   <= iAddrNotAligned;
HselMemBuf1      <= iHselMemBuf1;
HtransMemBuf1    <= iHtransMemBuf1;
AddrBuf1         <= iAddrBuf1;
HsizeMemBuf1     <= iHsizeMemBuf1(1 downto 0);
UseSecBuf        <= iUseSecBuf;
-- -----------------------------------------------------------------------------
--                              Assignments
-- -----------------------------------------------------------------------------
iIDLECYC       <= SmMemSlaveState(0);
iBUSYCYC       <= SmMemSlaveState(1);
iWRITECYC      <= SmMemSlaveState(2);
READCYC        <= SmMemSlaveState(3);
HselSmcOr      <= HSELSMC(7) or HSELSMC(6) or HSELSMC(5) or HSELSMC(4) or
                  HSELSMC(3) or HSELSMC(2) or HSELSMC(1) or HSELSMC(0);

WaitWrCycAhbAnd <= '0' when ((WaitWrCycAhb = '0') and (SlowClkM = '1') and
                   -- Adding (HtranRegCont = HTRANS_SEQ) condition so that
                   -- Memory need not burst if AHB does not continue with burst
                             (iHtranRegCont = HTRANS_SEQ))
                else
                   '1';

WaitWrCycAhbMux <= '1' when ((ClockRatio = "01") or (ClockRatio = "10"))
                else
                   WaitWrCycAhbAnd;

-- -----------------------------------------------------------------------------
--    A H B    S L A V E    S E L E C T    S T A T E    M A C H I N E
-- -----------------------------------------------------------------------------
--
-- Summary: State Machine to control the AHB Slave interface for Memory
--          accesses.
--
-- Overview: This state machine will control the AHB slave interface for
--           Memory accesses.
--
-- Summary State Description:
-- ==========================
--
-- ST_MEM_NOT_SEL: Memory Not Selected State.
-- Description   : Default state when memory is not selected.
-- Entry         : HselSmcOr is sampled de-asserted or if HTRANSSMC is sampled
--                 IDLE and the end of any given bus cycle.
-- Exit          : When there is a read or write access.
-- No change     : Until the HselSmcOr and HREADYINSMC is sampled asserted.
--
-- ST_MEM_READ   : Memory Read State.
-- Description   : Read access in progress.
-- Entry         : When Memory read is initiated.
-- Exit          : When read is completed and HTRANSSMC is sampled BUSY or IDLE
--                 at the end of given bus cycle OR when Write transfer is
--                 sampled asserted at the end of given bus cycle.
-- No Change     : During read access(Until HREADYINSMC is sampled asserted).
--
-- ST_MEM_WRITE  : Memory Write State.
-- Description   : Write access in progress.
-- Entry         : When Memory write is initiated.
-- Exit          : When write is complete and HTRANSSMC is sampled BUSY or IDLE
--                 at the end of given bus cycle OR when Read transfer is
--                 sampled asserted at the end of given bus cycle.
-- No Change     : During write access(Until HREADYINSMC is sampled asserted).
--
-- ST_MEM_IDLE_RESP: BUSY Response State.
-- Description     : Busy on AHB in progress.
-- Entry           : When BUSY transfer is sampled asserted at the end of given
--                   bus cycle.
-- Exit            : When there is a read or write access, Or IDLE is driven on
--                   AHB.
-- No Change       : Until HTRANSSMC is changed to other than BUSY.
--
-- ST_MEM_ERROR  : Memory Error State.
-- Description   : Two Cycle Error response in progress.
-- Entry         : Whenever Error condition is encountered.
-- Exit          : When Two cycle Error response is completed.
-- No Change     : Until Two cycle Error response is completed.
--
-- Detailed Description:
-- =====================
-- The logic has a separate address buffer that latches in the address on the
-- HADDRSMC lines at the end of every bus cycle. This latched address is used
-- for further decoding. The data transfers from memory to the AHB bus occur
-- only in the ST_MEM_READ state.
-- The buffered address is decoded and if the access is a Write to memory a
-- combinatorial decode of ST_MEM_WRITE state bit forms the MemWrReq (Write
-- Request for Memory access) for the memory. The Writes to memory terminate
-- with minimum of two-clock cycle response. If the Memory write is taking
-- longer than two cycles to complete on the Memory side then a signal
-- WaitWrCycMux will hold the HREADYOUTSMC signal de-asserted till the write is
-- over.
-- Whenever a read access is initiated with a NSEQ transfer on the SSMC, the SM
-- always inserts a Wait state for the cycle. This Wait period is generally of
-- only one clock but can be controlled with a signal "WaitRdCycMux" depending
-- on the time it take for the source data to reach to HRDATASMC output
-- flip-flops through a multiplexer that is controlled by the endianization
-- logic. At the end of the Wait period the SM drives HREADYOUTSMC high with
-- OKAY response. Whenever a read cycle is SEQ type the SM assumes that a valid
-- data is present on HRDATASMC flip-flops and thus can ideally terminate the
-- bus cycle with one clock response provided the source of data has not
-- asserted the "WaitRdCycMux" signal. WaitRdCycMux signal is an indication to
-- the AHB Memory SM, to assert HREADYOUTSMC. When the Read access on the
-- Memory side is waited then this signal is asserted. SM asserts HREADYOUTSMC
-- when it samples WaitRdCycMux de-asserted, with an HRESP_OKAY response.
-- The SM enters the ST_MEM_ERROR state when there is an HRESP_ERROR access. The
-- HRESP_ERROR access can happen on following conditions.
-- a) During a transfer of size greater than 32-bits to external memory.
-- b) If a write transfer is attempted to a Write-Protected Memory device.
-- c) After an externally waited transfer has timed out.
-- d) When an AHB master tries to initiate a new transfer in the WaitToutErr
--    case and the SMWAIT input is still in the asserted state due to the
--    previous transfer.
-- In the above cases HRESPSMC is driven with ERROR response and two cycle
-- ERROR response is driven on HREADYOUTSMC (i.e. First cycle HREADYOUTSMC is
-- de-asserted and in second cycle it is asserted) line.
--
-- -----------------------------------------------------------------------------
p_MemSMComb : process (SmMemSlaveState, iAddrBuf1, HREADYINSMC, HselSmcOr,
                       HTRANSSMC, HADDRSMC, WaitWrCycMux, WaitRdCycMux,
                       HWRITESMC, iHREADYOUTSMC, iHRESPSMC, iWRITECYC, READCYC,
                       ErrCond, iHtransMemBuf1, iHburstMemBuf, iHsizeMemBuf1,
                       HSIZESMC, HBURSTSMC, iHselMemBuf1, HSELSMC, SlowClkM,
                       WaitWrCycAhbMux, WaitRdCycVer, SyncEnRead1,
                       iHsizeEqMWidth, iAhbNarrow)
begin
  NextSmMemSlaveSt <= SmMemSlaveState;
  NextHREADYOUTSMC <= iHREADYOUTSMC;
  NextHRESPSMC     <= iHRESPSMC;
  NxtHtransMemBuf1 <= iHtransMemBuf1;
  NxtHburstMemBuf  <= iHburstMemBuf;
  NextHsizeMemBuf1 <= iHsizeMemBuf1;
  NextAddrBuf1     <= iAddrBuf1;
  NextHselMemBuf1  <= iHselMemBuf1;
  case SmMemSlaveState is
    when ST_MEM_NOT_SEL | ST_MEM_WRITE | ST_MEM_READ =>
      if (HREADYINSMC = '1') then
        if (HselSmcOr = '1') then
          NextHRESPSMC     <= HRESP_OKAY;
          NextAddrBuf1     <= HADDRSMC;
          NxtHtransMemBuf1 <= HTRANSSMC;
          NxtHburstMemBuf  <= HBURSTSMC;
          NextHsizeMemBuf1 <= HSIZESMC;

          case HTRANSSMC is
            when HTRANS_IDLE =>
              NextSmMemSlaveSt <= ST_MEM_NOT_SEL;
              NextHREADYOUTSMC <= '1';

            when HTRANS_BUSY =>
              NextSmMemSlaveSt <= ST_MEM_IDLE_RESP;
              NextHREADYOUTSMC <= '1';

            when HTRANS_NSEQ | HTRANS_SEQ =>
              NextHselMemBuf1  <= HSELSMC;
              if (HWRITESMC = '1') then
                NextSmMemSlaveSt <= ST_MEM_WRITE;
                if (HTRANSSMC = HTRANS_NSEQ) then
                  NextHREADYOUTSMC <= '0';
                else
                  NextHREADYOUTSMC <= (not WaitWrCycMux) or
                                      (not WaitWrCycAhbMux);
                end if;
              else
                NextSmMemSlaveSt <= ST_MEM_READ;
                if (HTRANSSMC = HTRANS_NSEQ) then
                  NextHREADYOUTSMC <= '0';
                else
                  NextHREADYOUTSMC <= not WaitRdCycMux;
                end if;
              end if;

            when others =>
              null;
          end case;
        else
          NextSmMemSlaveSt <= ST_MEM_NOT_SEL;
          NextHREADYOUTSMC <= '1';
          NextHRESPSMC     <= HRESP_OKAY;
        end if;
      else
        if (iWRITECYC = '1') then
          if (ErrCond = '1') then
            NextSmMemSlaveSt <= ST_MEM_ERROR;
            NextHREADYOUTSMC <= '0';
            NextHRESPSMC     <= HRESP_ERROR;
          else
            NextHREADYOUTSMC <= (not WaitWrCycMux) or
                                (not WaitWrCycAhbMux);
          end if;
        end if;

        if (READCYC = '1') then
          if (ErrCond = '1') then
            NextSmMemSlaveSt <= ST_MEM_ERROR;
            NextHREADYOUTSMC <= '0';
            NextHRESPSMC     <= HRESP_ERROR;
          else
            NextHREADYOUTSMC <= not WaitRdCycMux;
          end if;
        end if;
      end if;

    when ST_MEM_ERROR =>
      NextHRESPSMC     <= HRESP_ERROR;
      NextHREADYOUTSMC <= '1';
      NextSmMemSlaveSt <= ST_MEM_NOT_SEL;

    when ST_MEM_IDLE_RESP =>
      NextHRESPSMC     <= HRESP_OKAY;
      NextAddrBuf1     <= HADDRSMC;
      NxtHtransMemBuf1 <= HTRANSSMC;
      NxtHburstMemBuf  <= HBURSTSMC;
      NextHsizeMemBuf1 <= HSIZESMC;
      case HTRANSSMC is
        when HTRANS_IDLE =>
          NextSmMemSlaveSt <= ST_MEM_NOT_SEL;
          NextHREADYOUTSMC <= '1';

        when HTRANS_NSEQ | HTRANS_SEQ =>
          NextHselMemBuf1  <= HSELSMC;
          if (HWRITESMC = '1') then
            NextSmMemSlaveSt <= ST_MEM_WRITE;
            NextHREADYOUTSMC <= '0';
          else
            NextSmMemSlaveSt <= ST_MEM_READ;
            NextHREADYOUTSMC <= (not WaitRdCycVer) and SlowClkM and
                                (not SyncEnRead1) and
                                (iHsizeEqMWidth or iAhbNarrow);
          end if;

        when others =>
          null;
      end case;

    when others =>
      null;
  end case;
end process p_MemSMComb;

-- -----------------------------------------------------------------------------
-- Generation of Error condition when HSIZE is greater than WORD.
-- -----------------------------------------------------------------------------
p_SizeErrComb : process (iHsizeMemBuf1)
begin
  if ((iHsizeMemBuf1(2) = '1') or (iHsizeMemBuf1(1 downto 0) = "11")) then
    HSizeErrMem <= '1';
  else
    HSizeErrMem <= '0';
  end if;
end process p_SizeErrComb;

-- -----------------------------------------------------------------------------
-- Generation of Error condition when Write protection error occurs.
-- -----------------------------------------------------------------------------
p_WpErrComb : process (iWRITECYC, WP)
begin
  WriteProtErr <= '0';
  if ((iWRITECYC = '1') and (WP = '1')) then
    WriteProtErr <= '1';
  end if;
end process p_WpErrComb;

-- -----------------------------------------------------------------------------
-- Generation of Error condition when Timeout error occurs.
-- -----------------------------------------------------------------------------
p_ToutErrComb : process (iWRITECYC, READCYC, CancelWaitSt, SlowClkM)
begin
  iWaitToutErr <= '0';
  if (((iWRITECYC = '1') or (READCYC = '1')) and
      (CancelWaitSt = '1') and (SlowClkM = '1')) then
    iWaitToutErr <= '1';
  end if;
end process p_ToutErrComb;

-- -----------------------------------------------------------------------------
-- All possible Error conditions are OR'ed
-- -----------------------------------------------------------------------------
ErrCond <= '1' when ((iWaitToutErr = '1') or (WriteProtErr = '1') or
                      (HSizeErrMem = '1'))
        else
            '0';

-- -----------------------------------------------------------------------------
-- Generation of AhbWider signal.
-- -----------------------------------------------------------------------------
iAhbWider <= '1' when (iHsizeMemBuf(1 downto 0) > iMW)
          else
             '0';

-- -----------------------------------------------------------------------------
-- Generation of AhbNarrow signal.
-- -----------------------------------------------------------------------------
iAhbNarrow <= '1' when (iHsizeMemBuf(1 downto 0) < iMW)
           else
             '0';

-- -----------------------------------------------------------------------------
-- Generation of HsizeEqMWidth signal.
-- -----------------------------------------------------------------------------
iHsizeEqMWidth <= '1' when (iHsizeMemBuf(1 downto 0) = iMW)
               else
                 '0';

-- -----------------------------------------------------------------------------
-- Generation of NseqRdCyc signal.
-- -----------------------------------------------------------------------------
NseqRdCyc <= '1' when (iHtranRegCont = HTRANS_NSEQ)
          else
             '0';

-- -----------------------------------------------------------------------------
-- To generate AhbCount:
-- This count is used by the Memory TSM while performing Read, so that required
-- no of Memory accesses are performed.
-- This count is determined based on the HBURST, HSIZE and Memory Width values.
-- -----------------------------------------------------------------------------
p_AhbCountComb : process (READCYC, iHburstMemBuf, MW1, iHsizeMemBuf1,
                          BurstLenRead1, iAddrBuf1)
variable Concat           : std_logic_vector(3 downto 0);
-- Variable to hold the concatenation result of AHB Width and Memory Width

variable Temp             : std_logic_vector(2 downto 0);
-- Temporary variable of width 3 bits

variable Temp8            : std_logic_vector(3 downto 0);
-- Temporary variable of width 4 bits

variable Temp16           : std_logic_vector(4 downto 0);
-- Temporary variable of width 5 bits

begin
  Concat   := (MW1 & iHsizeMemBuf1(1 downto 0));
  Temp     := "000";
  Temp8    := "0000";
  Temp16   := "00000";
  AhbCount <= "00001";
  if (READCYC = '1') then
    case iHburstMemBuf is
      when HBURST_SINGLE | HBURST_INCR =>
        case Concat is
          when "0000" | "0100" | "0101" | "1000" | "1001" | "1010" =>
            AhbCount <= "00001";

          when "0001" | "0110" =>
            AhbCount <= "00010";

          when "0010" =>
            AhbCount <= "00100";

          when others =>
            null;
        end case;

      when HBURST_WRAP4 =>
        case Concat is
          when "0000" =>
            Temp    := 4 - unsigned(('0' & iAddrBuf1(1 downto 0)));
            AhbCount <= ("00" & Temp);

          when "0101" =>
            Temp     := 4 - unsigned(('0' & iAddrBuf1(2 downto 1)));
            AhbCount <= ("00" & Temp);

          when "1010" =>
            Temp     := 4 - unsigned(('0' & iAddrBuf1(3 downto 2)));
            AhbCount <= ("00" & Temp);

          when "0010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR =>
                if (iAddrBuf1(3 downto 2) = "11") then
                  AhbCount <= "00100";
                else
                  AhbCount <= "01000";
                end if;

              when SIXTEEN_TXR | CONTINUOUS =>
                Temp16   := 16 - unsigned(('0' & iAddrBuf1(3 downto 0)));
                AhbCount <= Temp16;

              when others =>
                null;
            end case;

          when "0001" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(2 downto 1) = "11") then
                  AhbCount <= "00010";
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR | SIXTEEN_TXR | CONTINUOUS =>
                Temp8    := 8 - unsigned(('0' & iAddrBuf1(2 downto 0)));
                AhbCount <= ('0' & Temp8);

              when others =>
                null;
            end case;

          when "0110" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(3 downto 2) = "11") then
                  AhbCount <= "00010";
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR | SIXTEEN_TXR | CONTINUOUS =>
                Temp8    := 8 - unsigned(('0' & iAddrBuf1(3 downto 1)));
                AhbCount <= ('0' & Temp8);

              when others =>
                null;
            end case;

          when "0100" | "1000" | "1001" =>
            AhbCount <= "00001";

          when others =>
            null;
        end case;

      when HBURST_INCR4 =>
        case Concat is
          when "0000" | "0101" | "1010" =>
            AhbCount <= "00100";

          when "0010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR =>
                AhbCount <= "01000";

              when SIXTEEN_TXR | CONTINUOUS =>
                AhbCount <= "10000";

              when others =>
                null;
            end case;

          when "0001" | "0110" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR | SIXTEEN_TXR | CONTINUOUS =>
                AhbCount <= "01000";

              when others =>
                null;
            end case;

          when "0100" | "1000" | "1001" =>
            AhbCount <= "00001";

          when others =>
            null;
        end case;

      when HBURST_WRAP8 =>
        case Concat is
          when "0000" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(2) = '1') then
                  Temp8    := 8 - unsigned(('0' & iAddrBuf1(2 downto 0)));
                  AhbCount <= ('0' & Temp8);
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR | SIXTEEN_TXR | CONTINUOUS =>
                Temp8    := 8 - unsigned(('0' & iAddrBuf1(2 downto 0)));
                AhbCount <= ('0' & Temp8);

              when others =>
                null;
            end case;

          when "0101" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(3) = '1') then
                  Temp8    := 8 - unsigned(('0' & iAddrBuf1(3 downto 1)));
                  AhbCount <= ('0' & Temp8);
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR | SIXTEEN_TXR | CONTINUOUS =>
                Temp8    := 8 - unsigned(('0' & iAddrBuf1(3 downto 1)));
                AhbCount <= ('0' & Temp8);

              when others =>
                null;
            end case;

          when "1010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(4) = '1') then
                  Temp8    := 8 - unsigned(('0' & iAddrBuf1(4 downto 2)));
                  AhbCount <= ('0' & Temp8);
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR =>
                Temp8    := 8 - unsigned(('0' & iAddrBuf1(4 downto 2)));
                AhbCount <= ('0' & Temp8);

              when SIXTEEN_TXR | CONTINUOUS =>
                Temp8    := 8 - unsigned(('0' & iAddrBuf1(4 downto 2)));
                AhbCount <= ('0' & Temp8);

              when others =>
                null;
            end case;

          when "0001" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(3 downto 1) = "111") then
                  AhbCount <= "00010";
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR =>
                if (iAddrBuf1(3) = '1') then
                  Temp8   := 8 - unsigned(('0' & iAddrBuf1(3 downto 1)));
                  AhbCount <= ('0' & Temp8);
                else
                  AhbCount <= "01000";
                end if;

              when SIXTEEN_TXR | CONTINUOUS =>
                Temp16   := 16 - unsigned(('0' & iAddrBuf1(3 downto 0)));
                AhbCount <= Temp16;

              when others =>
                null;
            end case;

          when "0110" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                if (iAddrBuf1(4 downto 2) = "111") then
                  AhbCount <= "00010";
                else
                  AhbCount <= "00100";
                end if;

              when EIGHT_TXR =>
                if (iAddrBuf1(4) = '1') then
                  Temp8   := 8 - unsigned(('0' & iAddrBuf1(3 downto 1)));
                  AhbCount <= ('0' & Temp8);
                else
                  AhbCount <= "01000";
                end if;

              when SIXTEEN_TXR | CONTINUOUS =>
                Temp16   := 16 - unsigned(('0' & iAddrBuf1(4 downto 1)));
                AhbCount <= Temp16;

              when others =>
                null;
            end case;

          when "0010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR =>
                if (iAddrBuf1(4 downto 2) = "111") then
                  AhbCount <= "00100";
                else
                  AhbCount <= "01000";
                end if;

              when SIXTEEN_TXR | CONTINUOUS =>
                if (iAddrBuf1(4) = '1') then
                  Temp16   := 16 - unsigned(('0' & iAddrBuf1(3 downto 0)));
                  AhbCount <= Temp16;
                else
                  AhbCount <= "10000";
                end if;

              when others =>
                null;
            end case;

          when "0100" | "1000" | "1001" =>
            AhbCount <= "00001";

          when others =>
            null;
        end case;

      when HBURST_INCR8 =>
        case Concat is
          when "0000" | "0101" | "1010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR | SIXTEEN_TXR | CONTINUOUS =>
                AhbCount <= "01000";

              when others =>
                null;
            end case;

          when "0001" | "0110" | "0010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR =>
                AhbCount <= "01000";

              when SIXTEEN_TXR | CONTINUOUS =>
                AhbCount <= "10000";

              when others =>
                null;
            end case;

          when "0100" | "1000" | "1001" =>
            AhbCount <= "00001";

          when others =>
            null;
        end case;

      when HBURST_WRAP16 | HBURST_INCR16 =>
        case Concat is
          when "0000" | "0101" | "1010" | "0001" | "0110" | "0010" =>
            case BurstLenRead1 is
              when FOUR_TXR =>
                AhbCount <= "00100";

              when EIGHT_TXR =>
                AhbCount <= "01000";
         
              when SIXTEEN_TXR | CONTINUOUS =>
                AhbCount <= "10000";

              when others =>
                null;
            end case;

          when "0100" | "1000" | "1001" =>
            AhbCount <= "00001";

          when others =>
            null;
        end case;

      when others =>
        null;
    end case;
  end if;
end process p_AhbCountComb;

-- -----------------------------------------------------------------------------
-- TurnAround is required on following conditions:
-- a) When there is a Single Read, and IDCYC values are programmed.
-- b) When there is a R->W to any Bank, and IDCYC values are programmed.
-- c) When there is a R->R to different bank, and IDCYC values are programmed.
-- The signal TurnAround indicates as to whether there was R->R or R->W access.
-- The final decision as to whether to do the Turnaround is decided in Memory SM
-- -----------------------------------------------------------------------------
TurnAroundComb <= '1' when (((DelREADCYC = '1') and (iWRITECYC = '1')) or
                            ((DelREADCYC = '1') and (READCYC = '1') and
                             (iHselMemBuf1 /= DelHselMemBuf1)))
               else
                  '0';

-- -----------------------------------------------------------------------------
-- When there is clock frequency mismatch, the TurnAroundComb signal should be
-- sustained till (SlowClkM = '1') condition is satisfied.
-- -----------------------------------------------------------------------------
p_TurnAroundComb : process (TurnArndReg, TurnAroundComb, SlowClkM, CancelWaitSt,
                            WaitDeAssrtSt, TurnAroundSt, WaitTxrOnBusSt, Toggle,
                            iNewBurst, InitSt)
begin
  NextTurnArndReg <= TurnArndReg;
  if ((TurnAroundComb = '1') and (TurnArndReg = '0') and (InitSt = '0') and
      (((WaitTxrOnBusSt = '0') and
        (WaitDeAssrtSt = '0') and
        (TurnAroundSt = '0') and
        (CancelWaitSt = '0')) or
       ((SlowClkM = '0') and (TurnAroundSt = '0')))) then
    NextTurnArndReg <= '1';
  elsif ((SlowClkM = '1') and
         ((((Toggle = '1') or (iNewBurst = '1')) and
           ((WaitTxrOnBusSt = '1') or
            (WaitDeAssrtSt = '1'))) or
          (CancelWaitSt = '1'))) then
    NextTurnArndReg <= '0';
  end if;
end process p_TurnAroundComb;

-- -----------------------------------------------------------------------------
-- Generation of TurnAround signal.
-- -----------------------------------------------------------------------------
TurnAround <= TurnAroundComb or TurnArndReg;

-- -----------------------------------------------------------------------------
-- NewBurst signal is generated whenever there is an NSEQ on the First level
-- registered HTRANS signal. This signal is very useful in breaking of the
-- burst in middle, reloading the counter, initiating the transfers etc.
-- -----------------------------------------------------------------------------
NewBurstComb <= '1' when ((iHtransMemBuf1 = HTRANS_NSEQ) and
                          (iHREADYOUTSMC = '0') and (DelHreadyOut = '1'))
             else
                '0';

-- -----------------------------------------------------------------------------
-- When there is clock frequency mismatch, the NewBurstComb signal should be
-- sustained till (SlowClkM = '0') condition is satisfied.
-- -----------------------------------------------------------------------------
p_NewBurstComb : process (NewBrstReg, NewBurstComb, SlowClkM)
begin
  NextNewBrstReg <= NewBrstReg;
  if ((NewBurstComb = '1') and (SlowClkM = '0') and (NewBrstReg = '0')) then
    NextNewBrstReg <= '1';
  elsif (SlowClkM = '1') then
    NextNewBrstReg <= '0';
  end if;
end process p_NewBurstComb;

-- -----------------------------------------------------------------------------
-- Generation of NewBurst signal.
-- -----------------------------------------------------------------------------
iNewBurst <= NewBurstComb or NewBrstReg;

-- -----------------------------------------------------------------------------
-- MemRdReq is asserted on following conditions:
-- a) When AHB Width is greater or equal to Memory Width, then Read state decode
--    of AHB SM indicates a Read request.
-- b) When AHB Width is smaller than Memory Width, MemRdReq is asserted for the
--    first read transfer, for subsequent transfers MemRdReq is de-asserted.
-- -----------------------------------------------------------------------------
iMemRdReq <= READCYC and (not MemRdMask) and (not iHREADYOUTSMC) and
             (not (WriteMask or DelWriteMask)) and (not ErrCond);

-- -----------------------------------------------------------------------------
-- To generate MemRdMask:
-- * The mask should be set when AHB Width is Lesser than Memory Width.
-- * The mask should be set after the first access, provided address is aligned.
-- * The mask should be set till the buffer becomes empty or if the burst gets
--   broken or Error condition is sampled.
-- -----------------------------------------------------------------------------
p_MemRdMaskComb : process (iAhbNarrow, WaitRdCyc, MemRdMaskReg, iNewBurst,
                           AhbLessRdCnt, AddrNotAlgnRd, iBUSYCYC, NseqRdCyc,
                           ErrCond, SlowClkM, iHREADYOUTSMC, BsyLstBt)
begin
  NextMemRdMaskReg <= MemRdMaskReg;
  if ((iAhbNarrow = '1') and (WaitRdCyc = '0') and (MemRdMaskReg = '0') and
      (AddrNotAlgnRd = '0') and (SlowClkM = '1') and (iNewBurst = '0')) then
    NextMemRdMaskReg <= '1';
  elsif (((AhbLessRdCnt <= "001") and (iBUSYCYC = '0') and
          (iHREADYOUTSMC = '1')) or
         (NseqRdCyc = '1') or (iNewBurst = '1') or (ErrCond = '1') or
         ((iHREADYOUTSMC = '1') and (BsyLstBt = '1') and (iBUSYCYC = '0'))) then
    NextMemRdMaskReg <= '0';
  end if;
end process p_MemRdMaskComb;

-- -----------------------------------------------------------------------------
-- MemRdMaskPulse is generated when there is a BUSY transaction driven on the
-- bus for the last beat of the AhbLessRdCnt counter. In this case before the
-- logic can sample the BUSY(registered) on the bus counter would have
-- decremented, so to prevent any error corruption of data, this logic is put
-- in place.
-- -----------------------------------------------------------------------------
MemRdMaskPulse <= '1' when ((MemRdMaskReg = '0') and (DelMemRdMaskReg = '1') and
                            (iHtranRegCont = HTRANS_BUSY) and (BsyLstBt = '0'))
               else
                  '0';

-- -----------------------------------------------------------------------------
-- The pulse generated in the above logic is sustained untill BUSY is changed
-- to some other transaction.
-- -----------------------------------------------------------------------------
p_MemRdBusyComb : process (MemRdBusy, MemRdMaskPulse, iHtranRegCont)
begin
  NextMemRdBusy <= MemRdBusy;
  if ((MemRdMaskPulse = '1') and (MemRdBusy = '0')) then
    NextMemRdBusy <= '1';
  elsif (iHtranRegCont /= HTRANS_BUSY) then
    NextMemRdBusy <= '0';
  end if;
end process p_MemRdBusyComb;

MemRdMask <= '1' when ((MemRdMaskReg = '1') or (MemRdBusy = '1'))
          else
             '0';

-- -----------------------------------------------------------------------------
-- Logic to identify whether Busy was inserted for last beat.
-- -----------------------------------------------------------------------------
p_BusyLstBtComb : process (BsyLstBt, AhbLessRdCnt, DelAhbLessRdCnt, iBUSYCYC,
                           DelBUSYCYC)
begin
  NextBsyLstBt <= BsyLstBt;
  if ((AhbLessRdCnt = "001") and (DelAhbLessRdCnt = "001") and
      (iBUSYCYC = '1') and (DelBUSYCYC = '0') and (BsyLstBt = '0')) then
    NextBsyLstBt <= '1';
  elsif (AhbLessRdCnt = "000") then
    NextBsyLstBt <= '0';
  end if;
end process p_BusyLstBtComb;

-- -----------------------------------------------------------------------------
-- To generate WaitRdCycMux:
-- a) When AHB Width is equal to Memory Width. WaitRdCycMux is same as
--    WaitRdCyc until NewBurst is seen.
-- b) When AHB is wider WaitRdCycMux is same as WaitRdCyc when we have collected
--    all the data from Memory.
-- c) When AHB is narrower than Memory Width. WaitRdCycMux is same as
--    WaitRdCyc for the First data, but for subsequent access we have to give
--    the data from buffer until MemRdMask is set.
-- -----------------------------------------------------------------------------
p_WaitRdCycMux : process (iAhbWider, iAhbWideRdCnt, WaitRdCyc, MemRdMask,
                          iHsizeEqMWidth, iNewBurst, SlowClkM, BsyLstBt,
                          iHREADYOUTSMC)
begin
  WaitRdCycMux <= '1';
  if (iHsizeEqMWidth = '0') then
    if (iAhbWider = '1') then

      -- New Burst information is added to prevent HREADYOUT being driven on
      -- the bus when there is a new read burst.
      if ((iAhbWideRdCnt = "001") and (iNewBurst = '0')) then
        WaitRdCycMux <= WaitRdCyc or (not SlowClkM);
      else
        WaitRdCycMux <= '1';
      end if;
    else

      -- New Burst information is added to prevent HREADY being driven on the
      -- bus when there is a new read burst.
      if ((MemRdMask = '1') and (iNewBurst = '0')) then
        if ((BsyLstBt = '1') and (iHREADYOUTSMC = '1')) then
          WaitRdCycMux <= '1';
        else
          WaitRdCycMux <= '0';
        end if;
      else
        WaitRdCycMux <= WaitRdCyc or (not SlowClkM) or iNewBurst;
      end if;
    end if;
  else
    if (iNewBurst = '0') then
      WaitRdCycMux <= WaitRdCyc or (not SlowClkM);
    else
      WaitRdCycMux <= '1';
    end if;
  end if;
end process p_WaitRdCycMux;

-- -----------------------------------------------------------------------------
-- Loading and decrementing of AhbWideRdCnt counter:
-- Loading of this counter happens on following condition
-- a) When there is a beginning of new burst i.e. NSEQ registered, AHB Greater
--    than Memory Width, Read transfer and when the counter has expired.
-- b) Decrement this counter when WaitRdCyc is seen and SmCSTSM is asserted.
-- c) Flush the counter when Error condition is sampled.
-- -----------------------------------------------------------------------------
p_AhbWdRdCntComb : process (iAhbWideRdCnt, iNewBurst, iAhbWider, iHsizeMemBuf1,
                            MW1, READCYC, WaitRdCyc, SlowClkM, SmCSTSM, ErrCond,
                            MemoryRdSt, iBUSYCYC, SyncEnRead1)
begin
  NextAhbWideRdCnt <= iAhbWideRdCnt;
  if (((iNewBurst = '1') or (iAhbWideRdCnt = "000")) and
      (SlowClkM = '1') and (iAhbWider = '1') and
      ((READCYC = '1') or
      ((iBUSYCYC and MemoryRdSt and (not SyncEnRead1)) = '1'))) then
    case iHsizeMemBuf1 is
      when HSIZE_HWORD =>
        -- In this case the Counter has to be loaded with the value depending on
        -- MW value.
        if (MW1 = MEM_BYTE) then
          if ((WaitRdCyc = '1') or (iNewBurst = '1')) then
            NextAhbWideRdCnt <= "010";
          else
            NextAhbWideRdCnt <= "001";
          end if;
        end if;

      when HSIZE_WORD =>
        -- In this case the Counter has to be loaded with the value depending on
        -- MW value.
        case MW1 is
          when MEM_BYTE =>
            if ((WaitRdCyc = '1') or (iNewBurst = '1')) then
              NextAhbWideRdCnt <= "100";
            else
              NextAhbWideRdCnt <= "011";
            end if;

          when MEM_HWORD =>
            if ((WaitRdCyc = '1') or (iNewBurst = '1')) then
              NextAhbWideRdCnt <= "010";
            else
              NextAhbWideRdCnt <= "001";
            end if;

          when others =>
            null;
        end case;

      when others =>
        null;
    end case;

  elsif ((iAhbWideRdCnt /= "000") and (WaitRdCyc = '0') and
         (SlowClkM = '1') and (SmCSTSM = '0')) then
    NextAhbWideRdCnt <= unsigned(iAhbWideRdCnt) - 1;

  elsif ((ErrCond = '1') or
         ((READCYC = '0') and
          (((iBUSYCYC and MemoryRdSt) = '0') or
           (SyncEnRead1 = '1')))) then
    NextAhbWideRdCnt <= (others => '0');
  end if;
end process p_AhbWdRdCntComb;

-- -----------------------------------------------------------------------------
-- Loading and decrementing of AhbLessRdCnt counter:
-- a) Load this counter after seeing the first WaitRdcyc, address is aligned
--    and AHB SM is in read state.
-- b) Decrement this counter on every clock till there is no BUSY insertion or
--    break in burst.
-- -----------------------------------------------------------------------------
p_AhbLsRdCntComb : process (AhbLessRdCnt, iNewBurst, iAhbNarrow, NseqRdCyc,
                            READCYC, iHsizeMemBuf1, MW1, MemRdMask, SlowClkM,
                            AddrNotAlgnRd, WaitRdCyc, iHREADYOUTSMC, BsyLstBt,
                            iBUSYCYC)
begin
  NextAhbLessRdCnt <= AhbLessRdCnt;
  if ((iAhbNarrow = '1') and (READCYC = '1') and (SlowClkM = '1') and
      (WaitRdCyc = '0') and (MemRdMask = '0') and (AddrNotAlgnRd = '0')) then

    -- The Counter has to be loaded with the value depending on MW value.
    -- The value loaded is 1 less as already one beat from memory is routed
    -- on to AHB.
    case iHsizeMemBuf1 is
      when HSIZE_BYTE =>
        case MW1 is
          when MEM_HWORD =>
            NextAhbLessRdCnt <= "001";

          when MEM_WORD =>
            NextAhbLessRdCnt <= "011";

          when others =>
            null;
        end case;

      when HSIZE_HWORD =>
        if (MW1 = MEM_WORD) then
          NextAhbLessRdCnt <= "001";
        end if;

      when others =>
        null;
    end case;

  -- Decrement the counter if there is no new burst and there is no Busy
  -- transfers driven on the bus.
  elsif ((AhbLessRdCnt > "000") and (iNewBurst = '0') and
         (iBUSYCYC = '0') and (iHREADYOUTSMC = '1')) then
    NextAhbLessRdCnt <= unsigned(AhbLessRdCnt) - 1;

  -- When NewBurst is driven on the bus reset the counter.
  elsif ((iNewBurst = '1') or (NseqRdCyc = '1') or
         ((iHREADYOUTSMC = '1') and (BsyLstBt = '1') and (iBUSYCYC = '0'))) then
    NextAhbLessRdCnt <= (others => '0');
  end if;
end process p_AhbLsRdCntComb;

-- -----------------------------------------------------------------------------
-- Generation of WriteRqBuf:
-- This signal is generated when the AHB SM enters the Write State, this signal
-- is registered(because the first write should happen with 1 wait state, so
-- there is every possibility that before this write request is sampled by the
-- Memory SM the AHB might have made a state transition to different state) and
-- this registered signal is deasserted when WaitWrCycVer signal is sampled low
-- and the AHB SM is not in Write State).
-- -----------------------------------------------------------------------------
p_WrReqBuffComb : process (WriteRqBuf, iWRITECYC, WaitWrCycVer, SlowClkM,
                           iAhbWideWrCnt, ErrCond, WaitEnReg, WaitWrCycDup,
                           BurstWriteSt, WriteBeatCnt, iUseSecBuf, UseSecBufVer,
                           iWaitToutErr, BMWriteReg)
begin
  NextWriteRqBuf <= WriteRqBuf;
  if ((iWRITECYC = '1') and
      ((WriteRqBuf = '0') or (iUseSecBuf = '1') or (UseSecBufVer = '1')) and
      (ErrCond = '0') and (WaitEnReg = '0')) then
    NextWriteRqBuf <= '1';
  elsif ((((iWRITECYC = '0') or (WaitEnReg = '1')) and
          ((WaitWrCycVer = '0') or (WaitWrCycDup = '0')) and
          (SlowClkM = '1') and (iAhbWideWrCnt <= "001")) or
         ((BurstWriteSt = '1') and (iWRITECYC = '0') and (SlowClkM = '1') and
          (BMWriteReg = '1') and (WriteBeatCnt = "000") and
          (iUseSecBuf = '0')) or
         ((ErrCond = '1') and
          ((WaitWrCycVer = '0') or (iWaitToutErr = '1')))) then
    NextWriteRqBuf <= '0';
  end if;
end process p_WrReqBuffComb;

-- -----------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------
p_ValWrBrstStComb : process (ValWrBrstSt, iWRITECYC, WBstIntrptd,
                             iHtransMemBuf1, MemoryWrSt, BurstWriteSt,
                             TxrB4BsyAccptd, WaitWrCycVer, iHREADYOUTSMC,
                             SlowClkM)
begin
  NextValWrBrstSt <= ValWrBrstSt;
  if ((iWRITECYC = '1') and (WBstIntrptd = '1') and
      (iHtransMemBuf1  = HTRANS_NSEQ) and (ValWrBrstSt = '0') and
      (TxrB4BsyAccptd = '0') and (SlowClkM = '1') and
      ((WaitWrCycVer = '0') or (iHREADYOUTSMC = '1'))) then
    NextValWrBrstSt <= '1';
  elsif ((MemoryWrSt = '1') and (BurstWriteSt = '0')) then
    NextValWrBrstSt <= '0';
  end if;
end process p_ValWrBrstStComb;

UseSecBufExtd <= ValWrBrstSt and (not iIDLECYC) and MemoryWrSt and BurstWriteSt;

-- -----------------------------------------------------------------------------
-- Generation of MemWrReq
-- This signal is an OR'ed version of Write state and the registered Write
-- signal. After ORing it is ANDED with the WriteMask signal(which is generated
-- combinationally) to take care of the case when AHBWidth is smaller than the
-- Memory Width.
-- Condition ((WaitEnReg = '1') and (iWRITECYC = '1')) is added for freq runs.
-- -----------------------------------------------------------------------------
p_MemWrReqComb : process (WriteMask, ErrCond, MemoryWrSt, iWRITECYC, WaitEnReg,
                          NextWriteRqBuf, iUseSecBuf, UseSecBufVer)
begin
  if ((WriteMask = '0') and (ErrCond = '0')) then
    if (((MemoryWrSt = '0') and (iWRITECYC = '1')) or (iUseSecBuf = '1') or
        (NextWriteRqBuf = '1') or (UseSecBufVer = '1') or
        ((WaitEnReg = '1') and (iWRITECYC = '1'))) then
      MemWrReq <= '1';
    else
      MemWrReq <= '0';
    end if;
  else
    MemWrReq <= '0';
  end if;
end process p_MemWrReqComb;

-- -----------------------------------------------------------------------------
-- Generation of WriteMaskComb:
-- This signal should be active for 1 HCLK.
-- This signal is asserted when AHB is narrower than Memory, Address is aligned,
-- and there are no Wait enabled transfers.
-- -----------------------------------------------------------------------------
p_WrMaskComb : process (WriteMaskBuf, iAhbNarrow, WaitWrCycMux, iAddrNotAligned,
                        iWRITECYC, iWaitEn, ErrCond, extracond, AhbLessWrCnt)
begin
  WriteMaskComb <= '0';
  if ((WriteMaskBuf = '0') and (iAhbNarrow = '1') and
      ((WaitWrCycMux = '0') or
       ((extracond = '1') and (AhbLessWrCnt = "000"))) and
      (iWRITECYC = '1') and (iAddrNotAligned = '0') and (iWaitEn = '0') and
      (ErrCond = '0')) then
    WriteMaskComb <= '1';
  else
    WriteMaskComb <= '0';
  end if;
end process p_WrMaskComb;

-- -----------------------------------------------------------------------------
-- Generation of WriteMaskBuf:
-- The WriteMask should be sustained till there are sufficient data to write
-- into Memory.
-- Mask should be de-asserted after the AhbLessWrCnt has decremented to 1 in
-- normal case.
-- When NewBurst signal is sampled, Mask should be de-asserted.
-- -----------------------------------------------------------------------------
p_WrMaskBuffComb : process (WriteMaskBuf, iWRITECYC, WriteMaskComb,
                            iNewBurst, AhbLessWrCnt, WaitWrCycMux, iIDLECYC)
begin
  NextWriteMaskBuf <= WriteMaskBuf;
  if ((iWRITECYC = '1') and (WriteMaskBuf = '0') and
      (WriteMaskComb = '1')) then
    NextWriteMaskBuf <= '1';
  elsif ((iNewBurst = '1') or (iIDLECYC = '1') or
         ((AhbLessWrCnt = "001") and (WaitWrCycMux = '0'))) then
    NextWriteMaskBuf <= '0';
  end if;
end process p_WrMaskBuffComb;

-- -----------------------------------------------------------------------------
-- Generation of WriteMask:
-- a) This signal should be set only when AHB Width is < Memory Width and
--    transfer is not wait enabled.
-- b) Mask should be de-asserted after the AhbLessWrCnt has decremented
--    to 1 in normal case.
-- c) When NewBurst signal is sampled, Mask should be de-asserted.
-- d) In case of Non-aligned address, Mask should not be set.
-- -----------------------------------------------------------------------------
WriteMask <= WriteMaskBuf or WriteMaskComb;

-- -----------------------------------------------------------------------------
-- Generation of AddrNotAligned signal:
-- a) This signal should be asserted for 1HCLK.
-- b) This signal should be set when AHBWIDTH < MEMWIDTH and there was a single
--    transfer from AHB.
-- c) This signal should be set when AHBWIDTH < MEMWIDTH and first AHB Address
--    was not aligned with the HBURST information.
-- -----------------------------------------------------------------------------
p_AddrAlignComb : process (iHsizeMemBuf1, MW1, iNewBurst, iHburstMemBuf,
                           iAddrBuf1, SyncEnWrite1)
begin
  AddrNotAlignComb <= '0';
  case iHsizeMemBuf1 is
    when HSIZE_BYTE =>
      case MW1 is
        when MEM_BYTE =>
          if ((iNewBurst = '1') and (iAddrBuf1(0) = '1') and
              (SyncEnWrite1 = '1') and
              ((iHburstMemBuf = HBURST_WRAP4) or
               (iHburstMemBuf = HBURST_WRAP8) or
               (iHburstMemBuf = HBURST_WRAP16))) then
            AddrNotAlignComb <= '1';
          else
            AddrNotAlignComb <= '0';
          end if;

        when MEM_HWORD =>
          if ((iNewBurst = '1') and (iAddrBuf1(0) = '1')) then
            AddrNotAlignComb <= '1';
          else
            AddrNotAlignComb <= '0';
          end if;

        when MEM_WORD =>
          if ((iNewBurst = '1') and
              ((iAddrBuf1(0) = '1') or (iAddrBuf1(1) = '1'))) then
            AddrNotAlignComb <= '1';
          else
            AddrNotAlignComb <= '0';
          end if;

        when others =>
          null;
      end case;

    when HSIZE_HWORD =>
      if ((iNewBurst = '1') and (iAddrBuf1(1) = '1')) then
        AddrNotAlignComb <= '1';
      else
        AddrNotAlignComb <= '0';
      end if;

    when others =>
      null;
  end case;
end process p_AddrAlignComb;

-- -----------------------------------------------------------------------------
-- Registering the AddrNotAlignComb signal generated in above process, while
-- performing Write operations.
-- -----------------------------------------------------------------------------
p_AddrAlgnRgComb : process (AddrNotAlignReg, AddrNotAlignComb, iNewBurst,
                            iWRITECYC, iIDLECYC)
begin
  NextAddrNotAlign <= AddrNotAlignReg;
  if ((AddrNotAlignComb = '1') and (iWRITECYC = '1')) then
    NextAddrNotAlign <= '1';

  -- Signal set should be sustained till a New transfer is sampled, or the
  -- ongoing burst is broken from AHB.
  elsif ((iNewBurst = '1') or (iIDLECYC = '1')) then
    NextAddrNotAlign <= '0';
  end if;
end process p_AddrAlgnRgComb;

iAddrNotAligned <= AddrNotAlignComb or AddrNotAlignReg;

-- -----------------------------------------------------------------------------
-- Registering the AddrNotAlignComb signal generated in above process while
-- performing Read operations.
-- -----------------------------------------------------------------------------
p_AddrAlgnRdComb : process (AddrNotAlgnRd, AddrNotAlignComb, iIDLECYC,
                            READCYC, iNewBurst)
begin
  NextAddrAlgnRd <= AddrNotAlgnRd;
  if ((AddrNotAlignComb = '1') and (READCYC = '1')) then
    NextAddrAlgnRd <= '1';
  elsif ((iNewBurst = '1') or (iIDLECYC = '1')) then
    NextAddrAlgnRd <= '0';
  end if;
end process p_AddrAlgnRdComb;

-- -----------------------------------------------------------------------------
-- Loading and decrementing of AhbLessWrCnt counter:
-- This counter has to be loaded when WriteMaskComb is sampled high.
-- While loading, loaded with a value 1 less because the first write access is
-- of one wait state hence by the time this counter is loaded, one write
-- would have finished.
-- This counter should be decremented on every WaitWrCycMux = '0' condition
-- provided there is no BUSY transfers or break in burst.
-- -----------------------------------------------------------------------------
p_AhbLsWrCntComb : process (AhbLessWrCnt, WriteMaskComb, iHsizeMemBuf1, iMW,
                            iNewBurst, iHtransMemBuf1, WaitWrCycMux, iIDLECYC)
begin
  NextAhbLessWrCnt <= AhbLessWrCnt;
  if (WriteMaskComb = '1') then
    case iHsizeMemBuf1 is
      when HSIZE_BYTE =>

        -- In this case the Counter has to be loaded with the value depending on
        -- MW value. The value loaded is 1 less as already one write from AHB
        -- is passed on to the buffer.
        case iMW is
          when MEM_HWORD =>
            NextAhbLessWrCnt <= "001";

          when MEM_WORD =>
            NextAhbLessWrCnt <= "011";

          when others =>
            null;
        end case;

      when HSIZE_HWORD =>

        -- In this case the Counter has to be loaded with the value depending on
        -- MW value. The value loaded is 1 less as already one write from AHB
        -- is passed on to the buffer.
        if (iMW = MEM_WORD) then
          NextAhbLessWrCnt <= "001";
        end if;

      when others =>
        null;
    end case;

  elsif ((AhbLessWrCnt /= "000") and (iNewBurst = '0') and
         (iHtransMemBuf1 /= HTRANS_BUSY) and (WaitWrCycMux = '0')) then
    NextAhbLessWrCnt <= unsigned(AhbLessWrCnt) - 1;

  -- When NewBurst is driven on the bus reset the counter
  elsif ((iNewBurst = '1') or (iIDLECYC = '1')) then
    NextAhbLessWrCnt <= (others => '0');
  end if;
end process p_AhbLsWrCntComb;

-- -----------------------------------------------------------------------------
-- Logic to Write to Appropriate Byte Lanes when AHB Width < Memory Width.
-- There is every possibility that AHB might write to portion of the Memory
-- Byte Lanes.
-- -----------------------------------------------------------------------------
p_ValidLaneComb : process (iWRITECYC, BIGENDIAN, iHsizeMemBuf1, iAddrBuf1,
                           ValByteLane0, ValByteLane1, ValByteLane2,
                           ValByteLane3, WaitWrCycVer, ErrCond, SlowClkM,
                           WaitWrCycMux, WaitEnWrFirstCyc, WaitEnReg,
                           iNewBurst, MemoryWrSt, MW1, extracond, ValWrBrstSt)
begin
  iNxtValByteLane0 <= ValByteLane0;
  iNxtValByteLane1 <= ValByteLane1;
  iNxtValByteLane2 <= ValByteLane2;
  iNxtValByteLane3 <= ValByteLane3;

  if ((iWRITECYC = '1') and (iHsizeMemBuf1(1 downto 0) < MW1) and
      (ErrCond = '0') and
      ((WaitWrCycMux = '0') or (WaitEnWrFirstCyc = '0'))) then

    if (((WaitWrCycVer = '0') and (extracond = '0')) or
        ((iNewBurst = '1') and (MemoryWrSt = '1'))) then
      if (ValByteLane0 = '1') then
        iNxtValByteLane0 <= '0';
      end if;
      if (ValByteLane1 = '1') then
        iNxtValByteLane1 <= '0';
      end if;
      if (ValByteLane2 = '1') then
        iNxtValByteLane2 <= '0';
      end if;
      if (ValByteLane3 = '1') then
        iNxtValByteLane3 <= '0';
      end if;
    end if;

    if (BIGENDIAN = '0') then
      case iHsizeMemBuf1 is
        when HSIZE_BYTE =>
          case iAddrBuf1(1 downto 0) is
            when "00" =>
              iNxtValByteLane0 <= '1';

            when "01" =>
              iNxtValByteLane1 <= '1';

            when "10" =>
              iNxtValByteLane2 <= '1';

            when "11" =>
              iNxtValByteLane3 <= '1';

            when others =>
              null;
          end case;

        when HSIZE_HWORD =>
          case iAddrBuf1(1) is
            when '0' =>
              iNxtValByteLane0 <= '1';
              iNxtValByteLane1 <= '1';

            when '1' =>
              iNxtValByteLane2 <= '1';
              iNxtValByteLane3 <= '1';

            when others =>
              null;
          end case;

        when others =>
          null;
      end case;
    else
      case iHsizeMemBuf1 is
        when HSIZE_BYTE =>
          case iAddrBuf1(1 downto 0) is
            when "11" =>
              iNxtValByteLane0 <= '1';

            when "10" =>
              iNxtValByteLane1 <= '1';

            when "01" =>
              iNxtValByteLane2 <= '1';

            when "00" =>
              iNxtValByteLane3 <= '1';

            when others =>
              null;
          end case;

        when HSIZE_HWORD =>
          case iAddrBuf1(1) is
            when '1' =>
              iNxtValByteLane0 <= '1';
              iNxtValByteLane1 <= '1';

            when '0' =>
              iNxtValByteLane2 <= '1';
              iNxtValByteLane3 <= '1';

            when others =>
              null;
          end case;

        when others =>
          null;
      end case;
    end if;

    if ((WaitWrCycVer = '0') and (WaitEnReg = '1')) then
      if (ValByteLane0 = '1') then
        iNxtValByteLane0 <= '0';
      end if;
      if (ValByteLane1 = '1') then
        iNxtValByteLane1 <= '0';
      end if;
      if (ValByteLane2 = '1') then
        iNxtValByteLane2 <= '0';
      end if;
      if (ValByteLane3 = '1') then
        iNxtValByteLane3 <= '0';
      end if;
    end if;
  elsif (((WaitWrCycVer = '0') and (SlowClkM = '1') and
          (extracond = '0') and (ValWrBrstSt = '0')) or
         (ErrCond = '1')) then
    iNxtValByteLane0 <= '0';
    iNxtValByteLane1 <= '0';
    iNxtValByteLane2 <= '0';
    iNxtValByteLane3 <= '0';
  end if;
end process p_ValidLaneComb;

-- -----------------------------------------------------------------------------
-- Loading and Decrementing of AhbWideWrCnt counter:
-- This counter has to be loaded when (WaitWrCycMux = 0) and (AhbMemSM = write
-- state) and (AHBWIDTH > MW).
-- The counter has to be decremented till it expires on every WaitWrCycVer = 0
-- condition.
-- The counter has to be flushed when WaitToutErr condition happens for wait
-- enabled transfers.
-- -----------------------------------------------------------------------------
p_AhbWdWrCntComb : process (iAhbWideWrCnt, WaitWrCycMux, iAhbWider, ErrCond,
                            iHsizeMemBuf, iMW, WaitWrCycVer, DelWaitWrCycMux,
                            WaitEnWrFirstCyc, iWRITECYC, iWaitEn, SlowClkM,
                            WaitWrCycDup, AhbWiderWr)
begin
  NextAhbWideWrCnt <= iAhbWideWrCnt;
  if ((((((DelWaitWrCycMux = '0') and (iAhbWideWrCnt = "000")) or
         ((((WaitWrCycMux = '0') and (iAhbWideWrCnt = "000")) or
           ((WaitWrCycDup = '0') and (iAhbWideWrCnt <= "001"))) and
           (SlowClkM = '1'))) and (iWaitEn = '0')) or
       (WaitEnWrFirstCyc = '0')) and
      (iAhbWider = '1') and (ErrCond = '0') and (iWRITECYC = '1')) then
    case iHsizeMemBuf is
      when "01" =>
        -- In this case the Counter has to be loaded with the value depending
        -- on MW value.
        if (iMW = MEM_BYTE) then
          NextAhbWideWrCnt <= "010";
        end if;

      when "10" =>
        -- In this case the Counter has to be loaded with the value depending
        -- on MW value.
        case iMW is
          when MEM_BYTE =>
            NextAhbWideWrCnt <= "100";

          when MEM_HWORD =>
            NextAhbWideWrCnt <= "010";

          when others =>
            null;
        end case;

      when others =>
        null;
    end case;

  elsif ((ErrCond = '0') and (iAhbWideWrCnt > "000") and (SlowClkM = '1') and
         (AhbWiderWr = '1') and
         ((WaitWrCycVer = '0') or (WaitWrCycDup = '0'))) then
    NextAhbWideWrCnt <= unsigned(iAhbWideWrCnt) - 1;

  elsif (ErrCond = '1') then
    NextAhbWideWrCnt <= "000";
  end if;
end process p_AhbWdWrCntComb;


-- -----------------------------------------------------------------------------
-- Generation of UseSecBuf:
-- This signal should be set when the write was over on AHB side, but before
-- this transfer is initiated on the Memory side HREADYOUTSMC is asserted.
-- In this case there is every possibility that one more transfer which was
-- pipelined, will overwrite the previous access information.
-- To avoid this we need to buffer the previous access information, before a
-- new transfer is honoured by AHB Slave.
-- -----------------------------------------------------------------------------
p_UseSecBufComb : process (iUseSecBuf, DelWaitWrCycMux, WriteMask, SlowClkM,
                           MemoryWrSt, iWRITECYC, DelWRITECYC, iIDLECYC,
                           iNewBurst, DelBUSYCYC, SmCSTSM, AhbLessWrCnt,
                           BurstWriteSt, BMWriteReg, iHtranRegCont,
                           WriteBeatCnt, nSmBurstWaitReg, iHtransMemBuf1,
                           WaitEnReg, HsizeEqMWidthWr, DelIDLECYC,
                           SyncEnWriteReg, BurstPulse, iHREADYOUTSMC,
                           WBstIntrptd, iAhbNarrow, UseSecBufExtd)
begin
  NextUseSecBuf    <= iUseSecBuf;
  if ((iUseSecBuf = '0') and (iWRITECYC = '1') and (WriteMask = '0') and
      ((DelWaitWrCycMux = '0') or
       ((nSmBurstWaitReg = '0') and (SyncEnWriteReg = '1') and
        (HsizeEqMWidthWr = '1') and (MemoryWrSt = '1')))) then
    if (((MemoryWrSt = '0') and (WriteMask = '0')) or
        ((MemoryWrSt = '1') and (WriteMask = '0') and (SmCSTSM = '1') and
         (DelBUSYCYC = '0') and (DelIDLECYC = '0') and
         ((DelWRITECYC = '0') or
          (((iHtransMemBuf1 = HTRANS_SEQ) or (iHtransMemBuf1 = HTRANS_NSEQ)) and
           (WaitEnReg = '0')))) or
        ((nSmBurstWaitReg = '0') and (HsizeEqMWidthWr = '1') and
         (SyncEnWriteReg = '1') and (DelIDLECYC = '0') and
         (DelBUSYCYC = '0') and (iNewBurst = '0')) or
        ((BurstPulse = '1') and (iUseSecBuf = '0')) or        
        ((BurstWriteSt = '1') and (SlowClkM = '1') and (BMWriteReg = '1') and
         (iNewBurst = '0') and
         (((WriteBeatCnt = "000") and (iHtransMemBuf1(1) = '1')) or
          ((iHtransMemBuf1 = HTRANS_NSEQ) and (HsizeEqMWidthWr = '1')) or
          ((WBstIntrptd = '1') and (iHtransMemBuf1 = HTRANS_SEQ) and
           (iHREADYOUTSMC = '1') and (iWRITECYC = '1'))))) then
      NextUseSecBuf    <= '1';
    elsif (UseSecBufExtd = '0') then
      NextUseSecBuf    <= '0';
    end if;
  elsif (((AhbLessWrCnt /= "000") and (WriteMask = '1') and
          (iUseSecBuf = '0') and
          ((iIDLECYC = '1') or (iNewBurst = '1') or (AhbLessWrCnt = "001") or
           (iHtranRegCont = HTRANS_IDLE) or (iHtranRegCont = HTRANS_NSEQ))) or
         ((WriteMask = '1') and (iAhbNarrow = '1') and (BurstWriteSt = '1') and
          (SlowClkM = '1') and (iNewBurst = '0') and
          (iHtransMemBuf1 = HTRANS_NSEQ) and (iHREADYOUTSMC = '1'))) then
    NextUseSecBuf    <= '1';

  -- Removed (SlowClkM = '1') for nSMBURSTWAIT cases in freq runs
  elsif ((MemoryWrSt = '1') and (nSmBurstWaitReg = '1') and
         (SmCSTSM = '0') and (UseSecBufExtd = '0')) then
    NextUseSecBuf <= '0';
  end if;
end process p_UseSecBufComb;

-- -----------------------------------------------------------------------------
-- Second level registering of Bank Resources.
-- -----------------------------------------------------------------------------
p_SecLevRegComb : process (iUseSecBuf, NextUseSecBuf, SMBLSPol2, MW2, BMWrite2,
                           SyncEnWr2, BurstLenWr2, AddrValWrEn2, WP2, RBLE2,
                           WSTWR2, WSTWEN2, IDCYC2, MW1, BMWrite1, SyncEnWrite1,
                           BurstLenWrite1, AddrValWriteEn1, WP1, RBLE1, WSTWR1,
                           WSTWEN1, IDCYC1, AddrBuf2, iAddrBuf1, HsizeMemBuf2,
                           iHsizeMemBuf1, iNewBurst, iHtranRegCont,
                           iHREADYOUTSMC, HwdataBuf2, HwdataBuf1, HselMemBuf2,
                           iHselMemBuf1, WaitEn1, WaitEn2, WaitPol1, WaitPol2,
                           SMBLSPol1, BIWriteEn2, BIWriteEn1, WriteMask,
                           DelWriteMask)
begin
  NextSMBLSPol2    <= SMBLSPol2;
  NextMW2          <= MW2;
  NextBMWrite2     <= BMWrite2;
  NextSyncEnWr2    <= SyncEnWr2;
  NextBurstLenWr2  <= BurstLenWr2;
  NextAddrValWrEn2 <= AddrValWrEn2;
  NextBIWriteEn2   <= BIWriteEn2;
  NextWP2          <= WP2;
  NextRBLE2        <= RBLE2;
  NextWaitEn2      <= WaitEn2;
  NextWaitPol2     <= WaitPol2;
  NextWSTWR2       <= WSTWR2;
  NextWSTWEN2      <= WSTWEN2;
  NextIDCYC2       <= IDCYC2;
  NextAddrBuf2     <= AddrBuf2;
  NextHwdataBuf2   <= HwdataBuf2;
  NextHselMemBuf2  <= HselMemBuf2;
  NextHsizeMemBuf2 <= HsizeMemBuf2;
  if (((NextUseSecBuf = '1') and (iUseSecBuf = '0')) or
      (((WriteMask = '1') or ((DelWriteMask = '1') and (iUseSecBuf = '1'))) and
       (iNewBurst = '0') and (iHtranRegCont /= HTRANS_IDLE) and
       (iHREADYOUTSMC = '1'))) then
    NextSMBLSPol2    <= SMBLSPol1;
    NextMW2          <= MW1;
    NextBMWrite2     <= BMWrite1;
    NextSyncEnWr2    <= SyncEnWrite1;
    NextBurstLenWr2  <= BurstLenWrite1;
    NextAddrValWrEn2 <= AddrValWriteEn1;
    NextBIWriteEn2   <= BIWriteEn1;
    NextWP2          <= WP1;
    NextRBLE2        <= RBLE1;
    NextWaitEn2      <= WaitEn1;
    NextWaitPol2     <= WaitPol1;
    NextWSTWR2       <= WSTWR1;
    NextWSTWEN2      <= WSTWEN1;
    NextIDCYC2       <= IDCYC1;
    NextAddrBuf2     <= iAddrBuf1;
    NextHwdataBuf2   <= HwdataBuf1;
    NextHselMemBuf2  <= iHselMemBuf1;
    NextHsizeMemBuf2 <= iHsizeMemBuf1(1 downto 0);
  end if;
end process p_SecLevRegComb;

-- -----------------------------------------------------------------------------
-- Mux to select between First level and Second level registered bank resources.
-- -----------------------------------------------------------------------------
p_BankSelMux : process (iUseSecBuf, MW2, BMWrite2, SyncEnWr2, BurstLenWr2,
                        AddrValWrEn2, WP2, RBLE2, WSTWR2, WSTWEN2, IDCYC2, MW1,
                        BMWrite1, SyncEnWrite1, iAddrBuf1, BurstLenWrite1,
                        AddrValWriteEn1, WP1, RBLE1, WSTWR1, WSTWEN1, IDCYC1,
                        HwdataBuf1, iHsizeMemBuf1, AddrBuf2, HwdataBuf2,
                        HselMemBuf2, HsizeMemBuf2, iHselMemBuf1, WaitEn1,
                        WaitEn2, WaitPol1, WaitPol2, UseSecBufVer, BIWriteEn1,
                        BIWriteEn2, SMBLSPol1, SMBLSPol2)
begin
  if ((iUseSecBuf = '0') and (UseSecBufVer = '0')) then
    SMBLSPol         <= SMBLSPol1;
    iMW              <= MW1;
    BMWrite          <= BMWrite1;
    SyncEnWrite      <= SyncEnWrite1;
    BurstLenWrite    <= BurstLenWrite1;
    AddrValidWriteEn <= AddrValWriteEn1;
    BIWriteEn        <= BIWriteEn1;
    WP               <= WP1;
    RBLE             <= RBLE1;
    iWaitEn          <= WaitEn1;
    WaitPol          <= WaitPol1;
    WSTWR            <= WSTWR1;
    WSTWEN           <= WSTWEN1;
    IDCYC            <= IDCYC1;
    AddrBuf          <= iAddrBuf1;
    HwdataBufInt     <= HwdataBuf1;
    iHselMemBuf      <= iHselMemBuf1;
    iHsizeMemBuf     <= iHsizeMemBuf1(1 downto 0);

  else
    SMBLSPol         <= SMBLSPol2;
    iMW              <= MW2;
    BMWrite          <= BMWrite2;
    SyncEnWrite      <= SyncEnWr2;
    BurstLenWrite    <= BurstLenWr2;
    AddrValidWriteEn <= AddrValWrEn2;
    BIWriteEn        <= BIWriteEn2;
    WP               <= WP2;
    RBLE             <= RBLE2;
    iWaitEn          <= WaitEn2;
    WaitPol          <= WaitPol2;
    WSTWR            <= WSTWR2;
    WSTWEN           <= WSTWEN2;
    IDCYC            <= IDCYC2;
    AddrBuf          <= AddrBuf2;
    HwdataBufInt     <= HwdataBuf2;
    iHselMemBuf      <= HselMemBuf2;
    iHsizeMemBuf     <= HsizeMemBuf2;
  end if;
end process p_BankSelMux;

-- -----------------------------------------------------------------------------
-- Generation of WtWrFrstCycComb
-- -----------------------------------------------------------------------------
p_WtWrFrstCycMux : process (iWRITECYC, DelWRITECYC, iWaitEn, iBUSYCYC, ErrCond,
                            MemoryWrSt, DelWaitWrCycMux, SmCSTSM, iNewBurst,
                            WaitEnReg, iUseSecBuf, BurstWriteSt, DelWriteMask,
                            SlowClkM, nSmBurstWaitReg, iAhbWideWrCnt)
begin
  WtWrFrstCycComb <= '1';
  if ((iWRITECYC = '1') and (DelWRITECYC = '0') and (iWaitEn = '0') and
      (iUseSecBuf = '0') and (ErrCond = '0') and
      ((iBUSYCYC = '0') or (iNewBurst = '1'))) then
    if ((MemoryWrSt = '0') or (DelWaitWrCycMux = '0') or (SmCSTSM = '1')) then
      WtWrFrstCycComb <= '0';
    else
      WtWrFrstCycComb <= '1';
    end if;

  -- This condition was added for the case when Wait Enabled Write followed by
  -- Normal Write. so that Posted write feature is maintained.
  -- There can be a case where Wait enabled transfer was not waited, and there
  -- is a normal write following it. In this case also we have to assert
  -- WaitWrFirstCyc so that posted write feature is maintained.
  elsif ((iWRITECYC = '1') and (iWaitEn = '0') and (ErrCond = '0') and
         (iNewBurst = '1') and (iUseSecBuf = '0') and 
         (((DelWriteMask = '0') and (SmCSTSM = '1') and
           ((WaitEnReg = '1') or (MemoryWrSt = '0'))) or
          ((BurstWriteSt = '1') and (DelWriteMask = '0') and
           (nSmBurstWaitReg = '1') and (iAhbWideWrCnt <= "001") and
           (SlowClkM = '1')))) then
    WtWrFrstCycComb <= '0';
  else
    WtWrFrstCycComb <= '1';
  end if;
end process p_WtWrFrstCycMux;

-- -----------------------------------------------------------------------------
-- When there is clock frequency mismatch, the WaitWrFirstCyc signal should be
-- sustained till (SlowClkM = '0') condition is satisfied.
-- -----------------------------------------------------------------------------
p_WtWrFrstCycComb : process (WtWrFrstReg, WtWrFrstCycComb, SlowClkM)
begin
  NextWtWrFrstReg <= WtWrFrstReg;
  if ((WtWrFrstCycComb = '0') and (SlowClkM = '0') and (WtWrFrstReg = '1')) then
    NextWtWrFrstReg <= '0';
  elsif (SlowClkM = '1') then
    NextWtWrFrstReg <= '1';
  end if;
end process p_WtWrFrstCycComb;

-- -----------------------------------------------------------------------------
-- Generation of WaitWrFirstCyc
-- -----------------------------------------------------------------------------
WaitWrFirstCyc <= WtWrFrstCycComb and WtWrFrstReg;

-- -----------------------------------------------------------------------------
-- Generation of WaitEnWrFirstCyc
-- -----------------------------------------------------------------------------
WaitEnWrFirstCyc <= '0' when ((iWRITECYC = '1') and (iWaitEn = '1') and
                              (MemoryWrSt = '0'))
                 else
                    '1';

-- -----------------------------------------------------------------------------
-- Generation of WaitWrCycMux:
-- When the AHB Slave SM enters the Write State for the first time from Read
-- State or ST_MEM_NOT_SEL state then we have to finish the write transfers
-- by inserting 1 wait state, provided if it is not a wait - enabled transfers.
-- When the AHBWIDTH = MW then we have to route WaitWrCycVer on WaitWrCycMux.
-- When AHBWIDTH < MW then until the (AhbLessWrCnt = "000") condition is sampled
-- we have to toggle the WaitWrCycMux signal, but on (AhbLessWrCnt = "000")
-- condition we have to route WaitWrCycVer.
-- When AHBWIDTH > MW and until the condition (iAhbWideWrCnt <= "001") happens
-- we have to hold WaitWrCycMux to logical 1 value. When the above condition
-- is sampled we have to route WaitWrCycVer.
-- To handle frequency mismatches SlowClkM signal is used suitably.
-- -----------------------------------------------------------------------------
p_WaitWrCycMux : process (WaitWrFirstCyc, HsizeEqMWidthWr, AhbWiderWr,
                          AhbNarrowWr, iAhbWideWrCnt, WaitWrCycVer, SlowClkM,
                          AhbLessWrCnt, iHREADYOUTSMC, iHsizeEqMWidth, iWaitEn,
                          iAhbWider, iAhbNarrow, WaitEnReg, MemoryWrSt,
                          iHtransMemBuf1, extracond, extracond1, ValWrBrstSt)
begin
  WaitWrCycMux <= '1';
  if (WaitWrFirstCyc = '0') then
    WaitWrCycMux <= '0' or (not SlowClkM);
  else
    if (MemoryWrSt = '1') then
      if (((HsizeEqMWidthWr = '1') and (extracond = '0') and
           (extracond1 = '0') and
           ((iWaitEn = '0') or (WaitEnReg = '1'))) or
          ((AhbWiderWr = '1') and (iAhbWideWrCnt <= "001"))) then
        WaitWrCycMux <= WaitWrCycVer or (not SlowClkM) or ValWrBrstSt;
      elsif ((AhbNarrowWr = '1') and (AhbLessWrCnt = "000")) then
        WaitWrCycMux <= WaitWrCycVer or (not SlowClkM);
      elsif ((AhbNarrowWr = '1') and (iHtransMemBuf1 = HTRANS_SEQ)) then
        WaitWrCycMux <= iHREADYOUTSMC;
      end if;
    else
      if ((iHsizeEqMWidth = '1') or
          ((iAhbWider = '1') and (iAhbWideWrCnt <= "001"))) then
        WaitWrCycMux <= WaitWrCycVer or (not SlowClkM);
      elsif ((iAhbNarrow = '1') and (AhbLessWrCnt = "000")) then
        WaitWrCycMux <= WaitWrCycVer or (not SlowClkM);
      elsif ((iAhbNarrow = '1') and (iHtransMemBuf1 = HTRANS_SEQ)) then
        WaitWrCycMux <= iHREADYOUTSMC;
      end if;
    end if;
  end if;
end process p_WaitWrCycMux;

extracond <=  '1' when (((iAhbNarrow and iHREADYOUTSMC and
                          BurstWriteSt) = '1') and
                         (iHtransMemBuf1 = HTRANS_NSEQ))
          else
              '0';

extracond1 <=  '1' when (((iHREADYOUTSMC and BurstWriteSt and
                           iWRITECYC and DelWRITECYC) = '1') and
                         (ClockRatio = "00") and
                         ((WBstIntrptd = '1') or
                          (iHtransMemBuf1 = HTRANS_NSEQ)))
          else
              '0';

-- -----------------------------------------------------------------------------
-- Generation of BurstPulse:
-- This signal is generated for Synchronous Memories when nSmBurstWaitReg is
-- asserted during write. Since to support Synchronous Burst write we assert
-- HREADYOUTSMC 1 Clock early before we finish the actual write on Memory side,
-- because of this condition there is every possibility that we will miss the
-- data because of nSmBurstWaitReg assertion. To overcome this BurstPulse is
-- generated.
-- -----------------------------------------------------------------------------
p_BurstPulseComb : process (DelWaitWrCycAhb, nSmBurstWaitReg, HsizeEqMWidthWr,
                            MemoryWrSt, DelSmBurstWait, BurstWriteSt, SmCSTSM,
                            iWRITECYC)
begin
  BurstPulse <= '0';
  if ((DelWaitWrCycAhb = '0') or
      ((BurstWriteSt = '1') and (DelSmBurstWait = '1'))) then
    if ((nSmBurstWaitReg = '0') and (HsizeEqMWidthWr = '1') and
        (SmCSTSM = '0') and (MemoryWrSt = '1') and (iWRITECYC = '1')) then
      BurstPulse <= '1';
    end if;
  end if;
end process p_BurstPulseComb;

-- -----------------------------------------------------------------------------
-- Generation of WaitAssrtd:
-- This signal is useful in registering the HWDATASMC which might have got
-- missed because of nSmBurstWaitReg assertion. This logic is valid only for 1:1
-- frequency ratios.
-- -----------------------------------------------------------------------------
p_WaitAssrtdComb : process (WaitAssrtd, BurstPulse, iHREADYOUTSMC, HwdataBuf3,
                            HwdataBuf1, ClockRatio, iWRITECYC)
begin
  NextWaitAssrtd <= WaitAssrtd;
  NextHwdataBuf3 <= HwdataBuf3;
  if ((BurstPulse = '1') and (ClockRatio = "00")) then
    NextWaitAssrtd <= '1';
  elsif ((iHREADYOUTSMC = '1') and (iWRITECYC = '1')) then
    NextWaitAssrtd <= '0';
  end if;

  if (WaitAssrtd = '1') then
    NextHwdataBuf3 <= HwdataBuf1;
  end if;
end process p_WaitAssrtdComb;

-- -----------------------------------------------------------------------------
-- Routing of appropriate HwdataBuf's.
-- -----------------------------------------------------------------------------
HwdataBufMux <= HwdataBuf3 when ((WaitAssrtd = '1') and (iUseSecBuf = '0'))
             else
                HwdataBufInt;

p_DataOutSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HwdataBufReg     <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (iUseSecBuf = '0') then
      HwdataBufReg   <= HwdataBufMux;
    end if;
  end if;
end process p_DataOutSeq;

HwDataBuf <= HwdataBufMux when (iUseSecBuf = '0') else
             HwdataBufReg;

-- -----------------------------------------------------------------------------
-- Generation of UseSecBufVer:
-- This signal is used while performing Synchronous transfers. This is useful
-- when we have to continue with normal bursts after nSmBurstWaitReg is
-- de-asserted. As long as this signal is high we will be using the second
-- level buffered resources, for memory accesses.
-- -----------------------------------------------------------------------------
p_UseSecVerComb : process (UseSecBufVer, BurstPulse,
                           BMWriteReg, HsizeEqMWidthWr,
                           SmCSTSM, iWRITECYC, DelSmCSTSM, nSmBurstWaitReg,
                           WriteBeatCnt)
begin
  NextUseSecBufVer <= UseSecBufVer;
  if ((BurstPulse = '1') and (iWRITECYC = '1') and (BMWriteReg = '1') and
      (HsizeEqMWidthWr = '1')) then
    NextUseSecBufVer <= '1';
  elsif ((((WriteBeatCnt = "000") and (DelSmCSTSM = '1')) or
          ((WriteBeatCnt /= "000") and (nSmBurstWaitReg = '1'))) and
         (SmCSTSM = '0')) then
    NextUseSecBufVer <= '0';
  end if;
end process p_UseSecVerComb;

-- -----------------------------------------------------------------------------
-- Write Data Path Logic
-- In this block the Data is Endianized before driving on HwdataBuf1 line.
-- HwdataBuf1 is driven out based on AddrBuf1, iHsizeMemBuf1 and BIGENDIAN
-- signals.
-- -----------------------------------------------------------------------------
p_AhbWrDataComb : process (iHsizeMemBuf1, BIGENDIAN, iAddrBuf1, HWDATASMC,
                           HwdataBuf1, WaitWrCycMux, WaitWrCycDup, iWRITECYC,
                           SlowClkM, WaitEnWrFirstCyc, HsizeEqMWidthWr,
                           BMWriteReg, SmCSTSM, WriteBeatCnt, iHtranRegCont,
                           SyncEnWriteReg, BurstWriteSt, iAhbWideWrCnt,
                           BurstPulse, nSmBurstWaitReg, UseSecBufVer,
                           iHREADYOUTSMC)
begin
  NextHwdataBuf1 <= HwdataBuf1;
  if (((WaitWrCycMux = '0') or
       ((WaitWrCycDup = '0') and (iAhbWideWrCnt <= "001") and
        (SlowClkM = '1')) or
       ((HsizeEqMWidthWr = '1') and (BMWriteReg = '1') and
        (((SmCSTSM = '0') and (SlowClkM = '1')) or (iHREADYOUTSMC = '1')) and
        (WriteBeatCnt = "000") and (iHtranRegCont = HTRANS_SEQ) and
        (SyncEnWriteReg = '1') and (BurstWriteSt = '1') and
        (nSmBurstWaitReg = '1') and (UseSecBufVer = '0')) or
       (WaitEnWrFirstCyc = '0') or
       (BurstPulse = '1')) and
      (iWRITECYC = '1')) then
    case iHsizeMemBuf1(1 downto 0) is
      when "00" =>
        if (BIGENDIAN = '0') then
          case iAddrBuf1(1 downto 0) is
            when "00" =>
              NextHwdataBuf1(7 downto 0)   <= HWDATASMC(7 downto 0);

            when "01" =>
              NextHwdataBuf1(15 downto 8)  <= HWDATASMC(15 downto 8);

            when "10" =>
              NextHwdataBuf1(23 downto 16) <= HWDATASMC(23 downto 16);

            when "11" =>
              NextHwdataBuf1(31 downto 24) <= HWDATASMC(31 downto 24);
  
            when others =>
              null;
          end case;

        else
          case iAddrBuf1(1 downto 0) is
            when "11" =>
              NextHwdataBuf1(7 downto 0)   <= HWDATASMC(7 downto 0);

            when "10" =>
              NextHwdataBuf1(15 downto 8)  <= HWDATASMC(15 downto 8);

            when "01" =>
              NextHwdataBuf1(23 downto 16) <= HWDATASMC(23 downto 16);

            when "00" =>
              NextHwdataBuf1(31 downto 24) <= HWDATASMC(31 downto 24);

            when others =>
              null;
          end case;

        end if;

      when "01" =>
        if (BIGENDIAN = '0') then
          case iAddrBuf1(1) is
            when '0' =>
              NextHwdataBuf1(15 downto 0)  <= HWDATASMC(15 downto 0);

            when '1' =>
              NextHwdataBuf1(31 downto 16) <= HWDATASMC(31 downto 16);

            when others =>
              null;
          end case;

        else
          case iAddrBuf1(1) is
            when '1' =>
              NextHwdataBuf1(15 downto 0)  <= HWDATASMC(15 downto 0);

            when '0' =>
              NextHwdataBuf1(31 downto 16) <= HWDATASMC(31 downto 16);

            when others =>
              null;
          end case;
        end if;

      when "10" =>
        NextHwdataBuf1(31 downto 0) <= HWDATASMC(31 downto 0);

      when others =>
        null;
    end case;
  end if;
end process p_AhbWrDataComb;

-- -----------------------------------------------------------------------------
-- Read Data Path Logic
-- In this block the Data is Endianized before driving on HRDATASMC line.
-- Endianization is done based on BIGENDIAN, Memory Width and SmAddrTSM signals.
-- -----------------------------------------------------------------------------
p_ReadDataComb : process (iHRDATASMC, iMW, MemoryRdSt, BIGENDIAN, SlowClkM,
                          SmDataInFbclk, WaitRdCyc, SmAddrTSM)
begin
  NextHrdataSmc <= iHRDATASMC;
  if ((MemoryRdSt = '1') and (WaitRdCyc = '0') and (SlowClkM = '1')) then
    if (BIGENDIAN = '0') then
      case iMW is
        when "00" =>
          case SmAddrTSM is
            when "00" =>
              NextHrdataSmc(7 downto 0)   <= SmDataInFbclk(7 downto 0);

            when "01" =>
              NextHrdataSmc(15 downto 8)  <= SmDataInFbclk(7 downto 0);

            when "10" =>
              NextHrdataSmc(23 downto 16) <= SmDataInFbclk(7 downto 0);

            when "11" =>
              NextHrdataSmc(31 downto 24) <= SmDataInFbclk(7 downto 0);

            when others =>
              null;
          end case;

        when "01" =>
          case SmAddrTSM(1) is
            when '0' =>
              NextHrdataSmc(15 downto 0)  <= SmDataInFbclk(15 downto 0);

            when '1' =>
              NextHrdataSmc(31 downto 16) <= SmDataInFbclk(15 downto 0);

            when others =>
              null;
          end case;

        when "10" =>
          NextHrdataSmc(31 downto 0) <= SmDataInFbclk(31 downto 0);

        when others =>
          null;
      end case;

    -- For BIGENDIAN Transfers
    else
      case iMW is
        when "00" =>
          case SmAddrTSM is
            when "11" =>
              NextHrdataSmc(7 downto 0)   <= SmDataInFbclk(7 downto 0);

            when "10" =>
              NextHrdataSmc(15 downto 8)  <= SmDataInFbclk(7 downto 0);

            when "01" =>
              NextHrdataSmc(23 downto 16) <= SmDataInFbclk(7 downto 0);

            when "00" =>
              NextHrdataSmc(31 downto 24) <= SmDataInFbclk(7 downto 0);

            when others =>
              null;
          end case;

        when "01" =>
          case SmAddrTSM(1) is
            when '1' =>
              NextHrdataSmc(15 downto 0)  <= SmDataInFbclk(15 downto 0);

            when '0' =>
              NextHrdataSmc(31 downto 16) <= SmDataInFbclk(15 downto 0);

            when others =>
              null;
          end case;

        when "10" =>
          NextHrdataSmc(31 downto 0) <= SmDataInFbclk(31 downto 0);

        when others =>
          null;
      end case;
    end if;
  end if;
end process p_ReadDataComb;

-- -----------------------------------------------------------------------------
-- Registering all Next state signals
-- -----------------------------------------------------------------------------
p_AhbRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SmMemSlaveState <= ST_MEM_NOT_SEL;
    iHREADYOUTSMC   <= '1';
    DelHreadyOut    <= '0';
    iHRESPSMC       <= HRESP_OKAY;
    iAddrBuf1       <= (others => '0');
    AddrBuf2        <= (others => '0');
    iHtransMemBuf1  <= (others => '0');
    iHburstMemBuf   <= (others => '0');
    iHsizeMemBuf1   <= (others => '0');
    HsizeMemBuf2    <= (others => '0');
    DelWRITECYC     <= '0';
    DelREADCYC      <= '0';
    DelBUSYCYC      <= '0';
    iHtranRegCont   <= (others => '0');
    MemRdMaskReg    <= '0';
    DelMemRdMaskReg <= '0';
    MemRdBusy       <= '0';
    iAhbWideRdCnt   <= (others => '0');
    AhbLessRdCnt    <= (others => '0');
    WriteRqBuf      <= '0';
    WriteMaskBuf    <= '0';
    iAhbWideWrCnt   <= (others => '0');
    AhbLessWrCnt    <= (others => '0');
    iUseSecBuf      <= '0';
    SMBLSPol2       <= '0';
    MW2             <= (others => '0');
    BMWrite2        <= '0';
    SyncEnWr2       <= '0';
    BurstLenWr2     <= (others => '0');
    AddrValWrEn2    <= '0';
    BIWriteEn2      <= '0';
    WP2             <= '0';
    RBLE2           <= '0';
    WaitEn2         <= '0';
    WaitPol2        <= '0';
    WSTWR2          <= (others => '0');
    WSTWEN2         <= (others => '0');
    IDCYC2          <= (others => '0');
    HwdataBuf1      <= (others => '0');
    HwdataBuf2      <= (others => '0');
    iHselMemBuf1    <= (others => '0');
    HselMemBuf2     <= (others => '0');
    DelWaitWrCycMux <= '0';
    DelHselMemBuf1  <= (others => '0');
    DelWriteMask    <= '0';
    AddrNotAlignReg <= '0';
    ValByteLane0    <= '0';
    ValByteLane1    <= '0';
    ValByteLane2    <= '0';
    ValByteLane3    <= '0';
    iHRDATASMC      <= (others => '0');
    NewBrstReg      <= '0';
    TurnArndReg     <= '0';
    AddrNotAlgnRd   <= '0';
    DelSmBurstWait  <= '1';
    HwdataBuf3      <= (others => '0');
    DelWaitWrCycAhb <= '1';
    UseSecBufVer    <= '0';
    WaitAssrtd      <= '0';
    DelIDLECYC      <= '0';
    DelAhbLessRdCnt <= (others => '0');
    BsyLstBt        <= '0';
    WtWrFrstReg     <= '1';
    ValWrBrstSt     <= '0';
  elsif (HCLK'event and HCLK = '1') then
    SmMemSlaveState <= NextSmMemSlaveSt;
    iHREADYOUTSMC   <= NextHREADYOUTSMC;
    DelHreadyOut    <= iHREADYOUTSMC;
    iHRESPSMC       <= NextHRESPSMC;
    iAddrBuf1       <= NextAddrBuf1;
    AddrBuf2        <= NextAddrBuf2;
    iHtransMemBuf1  <= NxtHtransMemBuf1;
    iHburstMemBuf   <= NxtHburstMemBuf;
    iHsizeMemBuf1   <= NextHsizeMemBuf1;
    HsizeMemBuf2    <= NextHsizeMemBuf2;
    DelWRITECYC     <= iWRITECYC;
    DelREADCYC      <= READCYC;
    DelBUSYCYC      <= iBUSYCYC;
    iHtranRegCont   <= HTRANSSMC;
    MemRdMaskReg    <= NextMemRdMaskReg;
    DelMemRdMaskReg <= MemRdMaskReg;
    MemRdBusy       <= NextMemRdBusy;
    iAhbWideRdCnt   <= NextAhbWideRdCnt;
    AhbLessRdCnt    <= NextAhbLessRdCnt;
    WriteRqBuf      <= NextWriteRqBuf;
    WriteMaskBuf    <= NextWriteMaskBuf;
    iAhbWideWrCnt   <= NextAhbWideWrCnt;
    AhbLessWrCnt    <= NextAhbLessWrCnt;
    iUseSecBuf      <= NextUseSecBuf;
    SMBLSPol2       <= NextSMBLSPol2;
    MW2             <= NextMW2;
    BMWrite2        <= NextBMWrite2;
    SyncEnWr2       <= NextSyncEnWr2;
    BurstLenWr2     <= NextBurstLenWr2;
    AddrValWrEn2    <= NextAddrValWrEn2;
    BIWriteEn2      <= NextBIWriteEn2;
    WP2             <= NextWP2;
    RBLE2           <= NextRBLE2;
    WaitEn2         <= NextWaitEn2;
    WaitPol2        <= NextWaitPol2;
    WSTWR2          <= NextWSTWR2;
    WSTWEN2         <= NextWSTWEN2;
    IDCYC2          <= NextIDCYC2;
    HwdataBuf1      <= NextHwdataBuf1;
    HwdataBuf2      <= NextHwdataBuf2;
    iHselMemBuf1    <= NextHselMemBuf1;
    HselMemBuf2     <= NextHselMemBuf2;
    DelWaitWrCycMux <= WaitWrCycMux;
    DelHselMemBuf1  <= iHselMemBuf1;
    DelWriteMask    <= WriteMask;
    AddrNotAlignReg <= NextAddrNotAlign;
    ValByteLane0    <= iNxtValByteLane0;
    ValByteLane1    <= iNxtValByteLane1;
    ValByteLane2    <= iNxtValByteLane2;
    ValByteLane3    <= iNxtValByteLane3;
    iHRDATASMC      <= NextHrdataSmc;
    NewBrstReg      <= NextNewBrstReg;
    TurnArndReg     <= NextTurnArndReg;
    AddrNotAlgnRd   <= NextAddrAlgnRd;
    DelSmBurstWait  <= nSmBurstWaitReg;
    HwdataBuf3      <= NextHwdataBuf3;
    DelWaitWrCycAhb <= WaitWrCycAhbMux;
    UseSecBufVer    <= NextUseSecBufVer;
    WaitAssrtd      <= NextWaitAssrtd;
    DelIDLECYC      <= iIDLECYC;
    DelAhbLessRdCnt <= AhbLessRdCnt;
    BsyLstBt        <= NextBsyLstBt;
    WtWrFrstReg     <= NextWtWrFrstReg;
    ValWrBrstSt     <= NextValWrBrstSt;
  end if;
end process p_AhbRegSeq;

end synth;

-- --================================== End ==================================--
