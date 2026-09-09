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
-- File Name              : SsmcCore.vhd.rca
-- File Revision          : 1.28
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This is the top level structural block of SsmcCore
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SsmcCore is
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
        SMBUSREQExt      : in    std_logic; -- Request EBI for Memory Transfer.
                                            -- This is routed from DBI module.
        SMTICBUSREQExt   : in    std_logic; -- Request EBI for TIC Transfer.
                                            -- This is routed from DBI module.
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
        SMBUSGNT         : in    std_logic; -- Bus Grant to SsmcCore from DBI
        Revision         : in    std_logic_vector(3 downto 0);
                                            -- TieOff1 and TieOff2 ANDed
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
        SMBUSREQ         : out   std_logic; -- Bus Request signal to DBI
        SMBUSREQEBI      : out   std_logic; -- Request EBI for Memory Transfer
        SMTICBUSREQEBI   : out   std_logic; -- Request EBI for TIC Transfer
        SMTICBUSGNTExt   : out   std_logic; -- External bus granted for TIC
                                            -- Transfer
        SMBUSGNTExt      : out   std_logic; -- External bus granted for Memory
                                            -- Transfer
        SmBusBackOffExt  : out   std_logic; -- BackOff Indication from EBI
        ClkStpd          : out   std_logic; -- Signal to indicate that clock
                                            -- output should be stopped
        BUSMUXEXT        : out   std_logic; -- Indication to either use Internal
                                            -- DBI or External EBI
        SmDataEnCore     : out   std_logic_vector(3 downto 0);
                                            -- Data Enables when Write is
                                            -- progressing
        SmDataOutCore    : out   std_logic_vector(31 downto 0);
                                            -- Data Bus output from SSMC
        SMBAA            : out   std_logic; -- External burst Address advance
                                            -- signal. Used to advance the
                                            -- address count in the external
                                            -- Memory device.
        SMADDRVALID      : out   std_logic; -- External address valid output,
                                            -- used to indicate when the address
                                            -- output is stable during
                                            -- synchronous burst transfers
        SMADDR           : out   std_logic_vector(25 downto 0);
                                            -- External Memory address bus
        SMCS             : out   std_logic_vector(7 downto 0);
                                            -- Chip Selects for external
                                            -- Memory, active HIGH
        nSMCS            : out   std_logic_vector(7 downto 0);
                                            -- Chip Selects for external
                                            -- Memory, active LOW
        nSMWEN           : out   std_logic; -- Memory Write Enable, Active LOW
        nSMBLS           : out   std_logic_vector(3 downto 0);
                                            -- Memory device Byte lane enables
        nSMOEN           : out   std_logic  -- Memory Output Enable, Active Low

       );
end SsmcCore;

-- -----------------------------------------------------------------------------
--
--                                  SsmcCore
--                                  ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This is the top level structural block of SsmcCore. This block
--   instantiates the following functional sub-blocks in the SsmcCore.
--      - SsmcAhbSlvMemIf
--      - SsmcAhbSlvRegIf
--      - SsmcPadIf
--      - SsmcSynchroniser
--      - SsmcMemTSM
--      - SsmcDerivedClk
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of SsmcCore is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component SsmcAhbSlvMemIf
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDRSMC         : in    std_logic_vector(25 downto 0);
        HTRANSSMC        : in    std_logic_vector(1 downto 0);
        HWRITESMC        : in    std_logic;
        HSIZESMC         : in    std_logic_vector(2 downto 0);
        HBURSTSMC        : in    std_logic_vector(2 downto 0);
        HWDATASMC        : in    std_logic_vector(31 downto 0);
        HSELSMC          : in    std_logic_vector(7 downto 0);
        HREADYINSMC      : in    std_logic;
        WaitWrCycVer     : in    std_logic;
        WaitWrCycDup     : in    std_logic;
        WaitWrCycAhb     : in    std_logic;
        WaitRdCycVer     : in    std_logic;
        WaitRdCyc        : in    std_logic;
        ClockRatio       : in    std_logic_vector(1 downto 0);
        SmCSTSM          : in    std_logic;
        DelSmCSTSM       : in    std_logic;
        SmDataInFbclk    : in    std_logic_vector(31 downto 0);
        HsizeEqMWidthWr  : in    std_logic;
        AhbWiderWr       : in    std_logic;
        AhbNarrowWr      : in    std_logic;
        nSmBurstWaitReg  : in    std_logic;
        MW1              : in    std_logic_vector(1 downto 0);
        SMBLSPol1        : in    std_logic;
        BIWriteEn1       : in    std_logic;
        BMWrite1         : in    std_logic;
        SyncEnRead1      : in    std_logic;
        SyncEnWrite1     : in    std_logic;
        BurstLenRead1    : in    std_logic_vector(1 downto 0);
        BurstLenWrite1   : in    std_logic_vector(1 downto 0);
        AddrValWriteEn1  : in    std_logic;
        WP1              : in    std_logic;
        RBLE1            : in    std_logic;
        WaitEn1          : in    std_logic;
        WaitPol1         : in    std_logic;
        WSTWR1           : in    std_logic_vector(4 downto 0);
        WSTWEN1          : in    std_logic_vector(3 downto 0);
        IDCYC1           : in    std_logic_vector(3 downto 0);
        InitSt           : in    std_logic;
        BurstWriteSt     : in    std_logic;
        TurnAroundSt     : in    std_logic;
        WaitTxrOnBusSt   : in    std_logic;
        WaitDeAssrtSt    : in    std_logic;
        CancelWaitSt     : in    std_logic;
        MemoryWrSt       : in    std_logic;
        MemoryRdSt       : in    std_logic;
        Toggle           : in    std_logic;
        SmAddrTSM        : in    std_logic_vector(1 downto 0);
        BIGENDIAN        : in    std_logic;
        WaitEnReg        : in    std_logic;
        BMWriteReg       : in    std_logic;
        SyncEnWriteReg   : in    std_logic;
        WriteBeatCnt     : in    std_logic_vector(2 downto 0);
        WBstIntrptd      : in    std_logic;
        TxrB4BsyAccptd   : in    std_logic;
        SlowClkM         : in    std_logic;
        HREADYOUTSMC     : out   std_logic;
        HRESPSMC         : out   std_logic_vector(1 downto 0);
        HRDATASMC        : out   std_logic_vector(31 downto 0);
        UseSecBuf        : out   std_logic;
        HtranRegCont     : out   std_logic_vector(1 downto 0);
        HtransMemBuf1    : out   std_logic_vector(1 downto 0);
        HsizeEqMWidth    : out   std_logic;
        AhbWider         : out   std_logic;
        AhbNarrow        : out   std_logic;
        MemWrReq         : out   std_logic;
        MemRdReq         : out   std_logic;
        TurnAround       : out   std_logic;
        NewBurst         : out   std_logic;
        AhbCount         : out   std_logic_vector(4 downto 0);
        WaitToutErr      : out   std_logic;
        NextValByteLane0 : out   std_logic;
        NextValByteLane1 : out   std_logic;
        NextValByteLane2 : out   std_logic;
        NextValByteLane3 : out   std_logic;
        BUSYCYC          : out   std_logic;
        IDLECYC          : out   std_logic;
        WRITECYC         : out   std_logic;
        AddrBuf1         : out   std_logic_vector(25 downto 0);
        AddrBuf          : out   std_logic_vector(25 downto 0);
        HwdataBuf        : out   std_logic_vector(31 downto 0);
        HsizeMemBuf1     : out   std_logic_vector(1 downto 0);
        HsizeMemBuf      : out   std_logic_vector(1 downto 0);
        HburstMemBuf     : out   std_logic_vector(2 downto 0);
        HselMemBuf1      : out   std_logic_vector(7 downto 0);
        HselMemBuf       : out   std_logic_vector(7 downto 0);
        AhbWideRdCnt     : out   std_logic_vector(2 downto 0);
        AhbWideWrCnt     : out   std_logic_vector(2 downto 0);
        AddrNotAligned   : out   std_logic;
        MW               : out   std_logic_vector(1 downto 0);
        SMBLSPol         : out   std_logic;
        BMWrite          : out   std_logic;
        SyncEnWrite      : out   std_logic;
        BurstLenWrite    : out   std_logic_vector(1 downto 0);
        AddrValidWriteEn : out   std_logic;
        BIWriteEn        : out   std_logic;
        RBLE             : out   std_logic;
        WaitEn           : out   std_logic;
        WaitPol          : out   std_logic;
        WSTWR            : out   std_logic_vector(4 downto 0);
        WSTWEN           : out   std_logic_vector(3 downto 0);
        IDCYC            : out   std_logic_vector(3 downto 0)
       );
end component;

component SsmcAhbSlvRegIf
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HADDRREG         : in    std_logic_vector(11 downto 2);
        HTRANSREG        : in    std_logic_vector(1 downto 0);
        HWRITEREG        : in    std_logic;
        HSIZEREG         : in    std_logic_vector(2 downto 0);
        HWDATAREG        : in    std_logic_vector(31 downto 0);
        HSELREG          : in    std_logic;
        HREADYINREG      : in    std_logic;
        SMMWCS7          : in    std_logic_vector(1 downto 0);
        SMBLS7POL        : in    std_logic;
        Revision         : in    std_logic_vector(3 downto 0);
        WaitStatus       : in    std_logic;
        WaitToutErr      : in    std_logic;
        HTRANSSMC        : in    std_logic;
        HSELSMC          : in    std_logic_vector(7 downto 0);
        HREADYINSMC      : in    std_logic; 
        HselMemBuf1      : in    std_logic_vector(7 downto 0);
        SMBUSREQExt      : in    std_logic;
        SMTICBUSREQExt   : in    std_logic;
        SMMEMCLKRATIO    : in    std_logic_vector(1 downto 0);
        SMBIGENDIAN      : in    std_logic;
        SMEXTBUSMUX      : in    std_logic;
        SMTICBUSGNTEBI   : in    std_logic;
        SMBUSGNTEBI      : in    std_logic;
        SMBUSBACKOFFEBI  : in    std_logic;
        HRDATAREG        : out   std_logic_vector(31 downto 0);
        HREADYOUTREG     : out   std_logic;
        HRESPREG         : out   std_logic_vector(1 downto 0);
        SMTICBUSGNTExt   : out   std_logic;
        SMBUSGNTExt      : out   std_logic;
        SmBusBackOffExt  : out   std_logic;
        BUSMUXEXT        : out   std_logic;
        BIGENDIAN        : out   std_logic;
        SMBUSREQEBI      : out   std_logic;
        SMTICBUSREQEBI   : out   std_logic;
        ClockRatio       : out   std_logic_vector(1 downto 0);
        MemClkRegTogl    : out   std_logic;
        MW1              : out   std_logic_vector(1 downto 0);
        SMBLSPol1        : out   std_logic;
        BMRead1          : out   std_logic;
        BIWriteEn1       : out   std_logic;
        BIReadEn1        : out   std_logic;
        WrapRead         : out   std_logic;
        BMWrite1         : out   std_logic;
        SyncEnRead1      : out   std_logic;
        SyncEnWrite1     : out   std_logic;
        BurstLenRead1    : out   std_logic_vector(1 downto 0);
        BurstLenWrite1   : out   std_logic_vector(1 downto 0);
        AddrValidReadEn1 : out   std_logic;
        AddrValWriteEn1  : out   std_logic;
        SMClockEn        : out   std_logic;
        WP1              : out   std_logic;
        RBLE1            : out   std_logic;
        WaitEn1          : out   std_logic;
        WaitPol1         : out   std_logic;
        WSTRD1           : out   std_logic_vector(4 downto 0);
        WSTBRD1          : out   std_logic_vector(4 downto 0);
        WSTWR1           : out   std_logic_vector(4 downto 0);
        WSTOEN1          : out   std_logic_vector(3 downto 0);
        WSTWEN1          : out   std_logic_vector(3 downto 0);
        IDCYC1           : out   std_logic_vector(3 downto 0)
       );
end component;

component SsmcPadIf
  port (
        SMFBCLK0         : in    std_logic;
        SMFBCLK1         : in    std_logic;
        SMFBCLK2         : in    std_logic;
        SMFBCLK3         : in    std_logic;
        nSMMEMCLK        : in    std_logic;
        SMMEMCLK        : in    std_logic;
        SMMEMCLKDELAY    : in    std_logic;
        HRESETn          : in    std_logic;
        nSMBURSTWAIT     : in    std_logic_vector(7 downto 0);
        BIGENDIAN        : in    std_logic;
        HsizeMemBufWr    : in    std_logic_vector(1 downto 0);
        MWWr             : in    std_logic_vector(1 downto 0);
        RBLEWr           : in    std_logic;
        HwdataBuf        : in    std_logic_vector(31 downto 0);
        MemoryWrSt       : in    std_logic;
        nSMWENMC         : in    std_logic;
        SmAddrTSM        : in    std_logic_vector(1 downto 0);
        SMADDRMC         : in    std_logic_vector(25 downto 0);
        nSMBLSMC         : in    std_logic_vector(3 downto 0);
        SMDATAIN         : in    std_logic_vector(31 downto 0);
        NextAsynAxs      : in   std_logic; -- Indication that Asynchronous
                                            -- memory access in progress
        NextSmOEn        : in  std_logic;
        NxtSMADDRVALIDMC : in  std_logic;
        NextSMBAAMC      : in  std_logic;
        NextSMCSMC       : in  std_logic_vector(7 downto 0);
        NextSMCSMCn      : in  std_logic_vector(7 downto 0);
        NextSMDATAENMCn  : in  std_logic_vector(3 downto 0);

        SMADDR           : out   std_logic_vector(25 downto 0);
        SmBurstWtFbClk   : out   std_logic;
        SyncWtSingle     : out   std_logic;
        SmDataInFbclk    : out   std_logic_vector(31 downto 0);
        SmDataEnCore     : out   std_logic_vector(3 downto 0);
        SmDataOutCore    : out   std_logic_vector(31 downto 0);
        SMCS             : out   std_logic_vector(7 downto 0);
        nSMCS            : out   std_logic_vector(7 downto 0);
        SMBAA            : out   std_logic;
        SMADDRVALID      : out   std_logic;
        nSMWEN           : out   std_logic;
        nSMOEN           : out   std_logic;
        nSMBLS           : out   std_logic_vector(3 downto 0)
       );
end component;

component SsmcSynchroniser
  port (
        SMMEMCLK         : in    std_logic;
        HRESETn          : in    std_logic;
        SMWAIT           : in    std_logic;
        SMCANCELWAIT     : in    std_logic;
        WaitPol          : in    std_logic;
        SmWaitSync       : out   std_logic;
        SmCancelWaitSync : out   std_logic
       );
end component;

component SsmcMemTSM
  port (
        SMMEMCLK         : in    std_logic;
        HRESETn          : in    std_logic;
        MemRdReq         : in    std_logic;
        MemWrReq         : in    std_logic;
        AddrBuf1         : in    std_logic_vector(25 downto 0);
        AddrBuf          : in    std_logic_vector(25 downto 0);
        HburstMemBuf     : in    std_logic_vector(2 downto 0);
        HselMemBuf       : in    std_logic_vector(7 downto 0);
        HselMemBuf1      : in    std_logic_vector(7 downto 0);
        UseSecBuf        : in    std_logic;
        HtranRegCont     : in    std_logic_vector(1 downto 0);
        HtransMemBuf1    : in    std_logic_vector(1 downto 0);
        HsizeEqMWidth    : in    std_logic;
        AhbWider         : in    std_logic;
        AhbNarrow        : in    std_logic;
        AddrNotAligned   : in    std_logic;
        HsizeMemBuf1     : in    std_logic_vector(1 downto 0);
        HsizeMemBuf      : in    std_logic_vector(1 downto 0);
        SyncWtSingle     : in    std_logic;
        SmBurstWtFbClk   : in    std_logic;
        SmWaitSync       : in    std_logic;
        SmCancelWaitSync : in    std_logic;
        MW1              : in    std_logic_vector(1 downto 0);
        MW               : in    std_logic_vector(1 downto 0);
        SMBLSPol         : in    std_logic;
        RBLE             : in    std_logic;
        BMRead1          : in    std_logic;
        BMWrite          : in    std_logic;
        WrapRead         : in    std_logic;
        SyncEnRead1      : in    std_logic;
        SyncEnWrite      : in    std_logic;
        BurstLenRead1    : in    std_logic_vector(1 downto 0);
        BurstLenWrite    : in    std_logic_vector(1 downto 0);
        AddrValidReadEn1 : in    std_logic;
        AddrValidWriteEn : in    std_logic;
        BIWriteEn        : in    std_logic;
        BIReadEn1        : in    std_logic;
        WaitEn           : in    std_logic;
        WSTRD1           : in    std_logic_vector(4 downto 0);
        WSTBRD1          : in    std_logic_vector(4 downto 0);
        WSTWR            : in    std_logic_vector(4 downto 0);
        WSTOEN1          : in    std_logic_vector(3 downto 0);
        WSTWEN           : in    std_logic_vector(3 downto 0);
        IDCYC            : in    std_logic_vector(3 downto 0);
        TurnAround       : in    std_logic;
        NewBurst         : in    std_logic;
        SMClockEn        : in    std_logic;
        ClockRatio       : in    std_logic_vector(1 downto 0);
        SMBUSGNT         : in    std_logic;
        BUSYCYC          : in    std_logic;
        IDLECYC          : in    std_logic;
        WRITECYC         : in    std_logic;
        AhbWideWrCnt     : in    std_logic_vector(2 downto 0);
        AhbWideRdCnt     : in    std_logic_vector(2 downto 0);
        AhbCount         : in    std_logic_vector(4 downto 0);
        NextValByteLane0 : in    std_logic;
        NextValByteLane1 : in    std_logic;
        NextValByteLane2 : in    std_logic;
        NextValByteLane3 : in    std_logic;
        MWWr             : out   std_logic_vector(1 downto 0);
        RBLEWr           : out   std_logic;
        HsizeMemBufWr    : out   std_logic_vector(1 downto 0);
        HsizeEqMWidthWr  : out   std_logic;
        AhbWiderWr       : out   std_logic;
        AhbNarrowWr      : out   std_logic;
        nSMWENMC         : out   std_logic;
        SmCSTSM          : out   std_logic;
        DelSmCSTSM       : out   std_logic;
        SmAddrTSM        : out   std_logic_vector(1 downto 0);
        SMADDRMC         : out   std_logic_vector(25 downto 0);
        nSMBLSMC         : out   std_logic_vector(3 downto 0);
        InitSt           : out   std_logic;
        BurstWriteSt     : out   std_logic;
        TurnAroundSt     : out   std_logic;
        WaitTxrOnBusSt   : out   std_logic;
        WaitDeAssrtSt    : out   std_logic;
        CancelWaitSt     : out   std_logic;
        MemoryRdSt       : out   std_logic;
        MemoryWrSt       : out   std_logic;
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

        Toggle           : out   std_logic;
        WaitWrCycVer     : out   std_logic;
        WaitWrCycDup     : out   std_logic;
        WaitWrCycAhb     : out   std_logic;
        WaitRdCycVer     : out   std_logic;
        WaitRdCyc        : out   std_logic;
        SyncEnWriteReg   : out   std_logic;
        WaitEnReg        : out   std_logic;
        BMWriteReg       : out   std_logic;
        WriteBeatCnt     : out   std_logic_vector(2 downto 0);
        WaitStatus       : out   std_logic;
        nSmBurstWaitReg  : out   std_logic;
        ClkStpd          : out   std_logic;
        SMBUSREQ         : out   std_logic
       );
end component;

component SsmcDerivedClk
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMMEMCLK         : in    std_logic;
        ClockRatio       : in    std_logic_vector(1 downto 0);
        MemClkRegTogl    : in    std_logic;
        SlowClkM         : out   std_logic
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

-- SsmcAhbSlvMemIf Block signals for Memory Accesses
signal UseSecBuf        : std_logic;
-- Indication to use second level buffered resources during Write

signal HtranRegCont     : std_logic_vector(1 downto 0);
-- HTRANS registered on every clock

signal HtransMemBuf1    : std_logic_vector(1 downto 0);
-- Level1 Buffer to hold HTRANSSMC

signal HsizeEqMWidth    : std_logic;
-- Indication that AHB and Memory are of same width

signal AhbWider         : std_logic;
-- Indication that AHB Width is greater than Memory Width

signal AhbNarrow        : std_logic;
-- Indication that AHB Width is narrower than Memory Width

signal MemWrReq         : std_logic;
-- Signal indicating the write transfer has been initiated

signal MemRdReq         : std_logic;
-- Signal indicating the read transfer being initiated

signal TurnAround       : std_logic;
-- TurnAround indication for R->W and R->R for diff memory bank

signal NewBurst         : std_logic;
-- Indication that Burst Broken

signal AhbCount         : std_logic_vector(4 downto 0);
-- Indication of number of Memory transfer requested by AHB

signal WaitToutErr      : std_logic;
-- Waited Access Error indication

signal NextValByteLane0 : std_logic;
-- Indication that Byte Lane0 is valid during write operation

signal NextValByteLane1 : std_logic;
-- Indication that Byte Lane1 is valid during write operation

signal NextValByteLane2 : std_logic;
-- Indication that Byte Lane2 is valid during write operation

signal NextValByteLane3 : std_logic;
-- Indication that Byte Lane3 is valid during write operation

signal BUSYCYC          : std_logic;
-- Indication that SM is in ST_MEM_BUSY state

signal IDLECYC          : std_logic;
-- Indication that SM is in ST_MEM_NOT_SEL state

signal WRITECYC         : std_logic;
-- Indication that SM is in ST_MEM_WRITE state

signal AddrBuf          : std_logic_vector(25 downto 0);
-- Buffered AHB Address

signal AddrBuf1         : std_logic_vector(25 downto 0);
-- Level1 Buffer to hold HADDRSMC

signal HwdataBuf        : std_logic_vector(31 downto 0);
-- Buffered AHB Data

signal HsizeMemBuf      : std_logic_vector(1 downto 0);
-- Buffered AHB HSIZESMC

signal HsizeMemBuf1     : std_logic_vector(1 downto 0);
-- Level1 buffer to hold HSIZESMC

signal HburstMemBuf     : std_logic_vector(2 downto 0);
-- Buffered HBURSTSMC

signal HselMemBuf1      : std_logic_vector(7 downto 0);
-- 1st level registered HSELSMC

signal HselMemBuf       : std_logic_vector(7 downto 0);
-- Buffered HSELSMC

signal AhbWideRdCnt     : std_logic_vector(2 downto 0);
-- Counter which indicates number of Memory accesses required for one AHB Read
-- transfer

signal AhbWideWrCnt     : std_logic_vector(2 downto 0);
-- Counter for number of Memory Write accesses required for 1 AHB Write transfer

signal AddrNotAligned   : std_logic;
-- Indication that starting address is not aligned to Memory Width

signal MW               : std_logic_vector(1 downto 0);
-- The memory width bits selection from one of the bank registers

signal SMBLSPol         : std_logic;
-- Byte lane polarity bit selection from one of the bank registers

signal BMWrite          : std_logic;
-- Burst Mode Write indication

signal SyncEnWrite      : std_logic;
-- Synchronous burst Mode Write

signal BurstLenWrite    : std_logic_vector(1 downto 0);
-- Burst transfer length, supported by Burst devices for Write

signal AddrValidWriteEn : std_logic;
-- SMADDRVALID enable during Write

signal BIWriteEn        : std_logic;
-- Indication that SMBAA active during Synchronous Burst Write access

signal RBLE             : std_logic;
-- Byte lane enabled device of SMWAIT

signal WaitEn           : std_logic;
-- Wait Enable indication

signal WaitPol          : std_logic;
-- Indication of the Wait polarity

signal WSTWR            : std_logic_vector(4 downto 0);
-- Single Write access count for the bank targeted currently

signal WSTWEN           : std_logic_vector(3 downto 0);
-- Delay value for the assertion of the WEN and nSMBLS signals

signal IDCYC            : std_logic_vector(3 downto 0);
-- Count value for the turnaround cycles


-- SsmcAhbSlvRegIf Block signals for Register Accesses
signal BIGENDIAN        : std_logic;
-- Indicates Endianness of the System

signal ClockRatio       : std_logic_vector(1 downto 0);
-- Indicates ratio of Memory Clock with respect to HCLK

signal MemClkRegTogl    : std_logic;
-- Toggle signal indicating that write happened to Clock Register

signal MW1              : std_logic_vector(1 downto 0);
-- 1st level registered memory width bits selection from one of the bank
-- registers

signal SMBLSPol1        : std_logic;
-- 1st level registered memory Byte lane polarity bit from one
-- of the bank registers

signal BMRead1          : std_logic;
-- 1st level Burst Mode read

signal WrapRead         : std_logic;
-- Enables the wrapping burst feature from memory

signal BIWriteEn1       : std_logic;
-- Indication that SMBAA active during Synchronous Burst Write access, 1st level
-- buffered

signal BIReadEn1        : std_logic;
-- Indication that SMBAA and nSMIND active during Synchronous Burst Read access,
-- 1st level buffered

signal BMWrite1         : std_logic;
-- 1st level Burst Mode Write

signal SyncEnRead1      : std_logic;
-- 1st level Sync burst Mode read

signal SyncEnWrite1     : std_logic;
-- 1st level Sync burst Mode Write

signal BurstLenRead1    : std_logic_vector(1 downto 0);
-- 1st level Burst transfer length, by Burst devices for Read

signal BurstLenWrite1   : std_logic_vector(1 downto 0);
-- 1st level Burst transfer length, by Burst devices for Write

signal AddrValidReadEn1 : std_logic;
-- 1st level SMADDRVALID enable during Read

signal AddrValWriteEn1  : std_logic;
-- 1st level SMADDRVALID enable during Write

signal SMClockEn        : std_logic;
-- Zero on this bit indicates that Clock should be active during Memory
-- accesses. One on this bit indicates that clock is always running

signal WP1              : std_logic;
-- 1st level Write protection

signal RBLE1            : std_logic;
-- 1st level Byte lane enable

signal WaitEn1          : std_logic;
-- 1st level Wait Enable indication

signal WaitPol1         : std_logic;
-- 1st level Indication of the polarity of SMWAIT

signal WSTRD1           : std_logic_vector(4 downto 0);
-- 1st level Single Read access count

signal WSTBRD1          : std_logic_vector(4 downto 0);
-- 1st level Burst Read access count

signal WSTWR1           : std_logic_vector(4 downto 0);
-- 1st level Write access count

signal WSTOEN1          : std_logic_vector(3 downto 0);
-- 1st level Delay value for the assertion of the OEN

signal WSTWEN1          : std_logic_vector(3 downto 0);
-- 1st level Delay value for the assertion of the WEN and nSMCS

signal IDCYC1           : std_logic_vector(3 downto 0);
-- 1st level Count value for the turnaround cycles

-- SsmcPadIf Block signals
signal SmBurstWtFbClk   : std_logic;
-- nSMBURSTWAIT registered on FBCLK

signal SyncWtSingle     : std_logic;
-- Single bit Synchronous Wait

signal SmDataInFbclk    : std_logic_vector(31 downto 0);
-- Data from Memory Banks

-- SsmcSynchroniser Block signals
signal SmWaitSync       : std_logic;
-- Double synchronised SMWAIT

signal SmCancelWaitSync : std_logic;
-- Double synchronised SMCANCELWAIT

-- SsmcMemTSM Block signals
signal MWWr             : std_logic_vector(1 downto 0);
-- Buffered MW while writing

signal RBLEWr           : std_logic;
-- RBLE registered during write operation

signal HsizeMemBufWr    : std_logic_vector(1 downto 0);
-- Buffered HsizeMemBuf while writing

signal HsizeEqMWidthWr  : std_logic;
-- Indication that AHB and Memory are of same width

signal AhbWiderWr       : std_logic;
-- Indication that AHB Width is greater than Memory Width

signal AhbNarrowWr      : std_logic;
-- Indication that AHB Width is Narrower than Memory Width

signal nSMWENMC         : std_logic;
-- nSMWEN when Asynchronous memory access is in progress

signal SmCSTSM          : std_logic;
-- Chip Select Assertion

signal DelSmCSTSM       : std_logic;
-- Delayed version of SmCSTSM

signal SmAddrTSM        : std_logic_vector(1 downto 0);
-- Memory Address from TSM Module

signal SMADDRMC         : std_logic_vector(25 downto 0);
-- Memory address output when Asynchronous memory access is progressing

signal nSMBLSMC         : std_logic_vector(3 downto 0);
-- Byte Lane Select when Asynchronous memory access is progressing

signal InitSt           : std_logic;
-- Indication that Memory SM is in ST_NO_REQ State

signal BurstWriteSt     : std_logic;
-- Indication that Memory SM is in ST_BURST_WRITE State

signal TurnAroundSt     : std_logic;
-- Indication that Memory SM is in ST_TURNAROUND State

signal WaitTxrOnBusSt   : std_logic;
-- Indication that Memory SM is in ST_WAITTXRONBUS State

signal WaitDeAssrtSt    : std_logic;
-- Indication that Memory SM is in ST_WAIT_DEASSERTED State

signal CancelWaitSt     : std_logic;
-- Indication that Memory SM is in ST_CANCELWAIT State

signal MemoryRdSt       : std_logic;
-- Indication that Memory TSM is in Read State

signal MemoryWrSt       : std_logic;
-- Indication that Memory TSM is in Write State

signal WBstIntrptd      : std_logic;
-- 

signal Toggle           : std_logic;
-- Indication of State switching when SM is waiting for transfer on AHB Bus

signal WaitWrCycVer     : std_logic;
-- Memory device write completion signal

signal WaitWrCycDup     : std_logic;
-- Memory device write completion signal when Wait Transfer is pipelined

signal WaitWrCycAhb     : std_logic;
-- Memory device write completion signal when Synchronous Transfer is pipelined

signal WaitRdCyc        : std_logic;
-- Memory device read completion signal

signal WaitRdCycVer     : std_logic;
-- Version of WaitRdCyc signal

signal SyncEnWriteReg   : std_logic;
-- Synchronous Write Enable signal registered when write begins

signal WaitStatus       : std_logic;
-- Wait Enable signal registered when write begins

signal WaitEnReg        : std_logic;
-- Wait Enable signal registered when write begins

signal BMWriteReg       : std_logic;
-- Burst Mode Write indication registered when write begins

signal WriteBeatCnt     : std_logic_vector(2 downto 0);
-- Counter used for carrying out Burst Write

signal nSmBurstWaitReg  : std_logic;
-- Wait status for enabled transfers

-- SsmcDerivedClk Block signals
signal SlowClkM         : std_logic;
-- Slow clock indicator to HCLK side

signal NextAsynAxs : std_logic;
-- Next state control signals

signal NextSmOEn        : std_logic;
-- Next state control signals

signal NxtSMADDRVALIDMC : std_logic;
-- Next state control signals

signal NextSMBAAMC      : std_logic;
-- Next state control signals

signal NextSMCSMC       : std_logic_vector(7 downto 0);
-- Next state control signals

signal NextSMCSMCn      : std_logic_vector(7 downto 0);
-- Next state control signals

signal NextSMDATAENMCn  : std_logic_vector(3 downto 0);
-- Next state control signals

signal TxrB4BsyAccptd   : std_logic;
-- 

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

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcAhbSlvMemIf
-- -----------------------------------------------------------------------------
uSsmcAhbSlvMemIf : SsmcAhbSlvMemIf
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDRSMC         => HADDRSMC,
            HTRANSSMC        => HTRANSSMC,
            HWRITESMC        => HWRITESMC,
            HSIZESMC         => HSIZESMC,
            HBURSTSMC        => HBURSTSMC,
            HWDATASMC        => HWDATASMC,
            HSELSMC          => HSELSMC,
            HREADYINSMC      => HREADYINSMC,
            WaitWrCycVer     => WaitWrCycVer,
            WaitWrCycDup     => WaitWrCycDup,
            WaitWrCycAhb     => WaitWrCycAhb,
            WaitRdCycVer     => WaitRdCycVer,
            WaitRdCyc        => WaitRdCyc,
            ClockRatio       => ClockRatio,
            SmCSTSM          => SmCSTSM,
            DelSmCSTSM       => DelSmCSTSM,
            SmDataInFbclk    => SmDataInFbclk,
            HsizeEqMWidthWr  => HsizeEqMWidthWr,
            AhbWiderWr       => AhbWiderWr,
            AhbNarrowWr      => AhbNarrowWr,
            nSmBurstWaitReg  => nSmBurstWaitReg,
            MW1              => MW1,
            SMBLSPol1        => SMBLSPol1,
            BIWriteEn1       => BIWriteEn1,
            BMWrite1         => BMWrite1,
            SyncEnRead1      => SyncEnRead1,
            SyncEnWrite1     => SyncEnWrite1,
            BurstLenRead1    => BurstLenRead1,
            BurstLenWrite1   => BurstLenWrite1,
            AddrValWriteEn1  => AddrValWriteEn1,
            WP1              => WP1,
            RBLE1            => RBLE1,
            WaitEn1          => WaitEn1,
            WaitPol1         => WaitPol1,
            WSTWR1           => WSTWR1,
            WSTWEN1          => WSTWEN1,
            IDCYC1           => IDCYC1,
            InitSt           => InitSt,
            BurstWriteSt     => BurstWriteSt,
            TurnAroundSt     => TurnAroundSt,
            WaitTxrOnBusSt   => WaitTxrOnBusSt,
            WaitDeAssrtSt    => WaitDeAssrtSt,
            CancelWaitSt     => CancelWaitSt,
            MemoryWrSt       => MemoryWrSt,
            MemoryRdSt       => MemoryRdSt,
            Toggle           => Toggle,
            SmAddrTSM        => SmAddrTSM,
            BIGENDIAN        => BIGENDIAN,
            WaitEnReg        => WaitEnReg,
            BMWriteReg       => BMWriteReg,
            SyncEnWriteReg   => SyncEnWriteReg,
            WriteBeatCnt     => WriteBeatCnt,
            WBstIntrptd      => WBstIntrptd,
            TxrB4BsyAccptd   => TxrB4BsyAccptd,
            SlowClkM         => SlowClkM,

            HREADYOUTSMC     => HREADYOUTSMC,
            HRESPSMC         => HRESPSMC,
            HRDATASMC        => HRDATASMC,
            UseSecBuf        => UseSecBuf,
            HtranRegCont     => HtranRegCont,
            HtransMemBuf1    => HtransMemBuf1,
            HsizeEqMWidth    => HsizeEqMWidth,
            AhbWider         => AhbWider,
            AhbNarrow        => AhbNarrow,
            MemWrReq         => MemWrReq,
            MemRdReq         => MemRdReq,
            TurnAround       => TurnAround,
            NewBurst         => NewBurst,
            AhbCount         => AhbCount,
            WaitToutErr      => WaitToutErr,
            NextValByteLane0 => NextValByteLane0,
            NextValByteLane1 => NextValByteLane1,
            NextValByteLane2 => NextValByteLane2,
            NextValByteLane3 => NextValByteLane3,
            BUSYCYC          => BUSYCYC,
            IDLECYC          => IDLECYC,
            WRITECYC         => WRITECYC,
            AddrBuf1         => AddrBuf1,
            AddrBuf          => AddrBuf,
            HwdataBuf        => HwdataBuf,
            HsizeMemBuf1     => HsizeMemBuf1,
            HsizeMemBuf      => HsizeMemBuf,
            HburstMemBuf     => HburstMemBuf,
            HselMemBuf1      => HselMemBuf1,
            HselMemBuf       => HselMemBuf,
            AhbWideRdCnt     => AhbWideRdCnt,
            AhbWideWrCnt     => AhbWideWrCnt,
            AddrNotAligned   => AddrNotAligned,
            MW               => MW,
            SMBLSPol         => SMBLSPol,
            BMWrite          => BMWrite,
            SyncEnWrite      => SyncEnWrite,
            BurstLenWrite    => BurstLenWrite,
            AddrValidWriteEn => AddrValidWriteEn,
            BIWriteEn        => BIWriteEn,
            RBLE             => RBLE,
            WaitEn           => WaitEn,
            WaitPol          => WaitPol,
            WSTWR            => WSTWR,
            WSTWEN           => WSTWEN,
            IDCYC            => IDCYC
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcAhbSlvRegIf
-- -----------------------------------------------------------------------------
uSsmcAhbSlvRegIf : SsmcAhbSlvRegIf
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HADDRREG         => HADDRREG,
            HTRANSREG        => HTRANSREG,
            HWRITEREG        => HWRITEREG,
            HSIZEREG         => HSIZEREG,
            HWDATAREG        => HWDATAREG,
            HSELREG          => HSELREG,
            HREADYINREG      => HREADYINREG,
            SMMWCS7          => SMMWCS7,
            SMBLS7POL        => SMBLS7POL,
            Revision         => Revision,
            WaitStatus       => WaitStatus,
            WaitToutErr      => WaitToutErr,
            HTRANSSMC        => HTRANSSMC(1),
            HSELSMC          => HSELSMC,
            HREADYINSMC      => HREADYINSMC,
            HselMemBuf1      => HselMemBuf1,
            SMBUSREQExt      => SMBUSREQExt,
            SMTICBUSREQExt   => SMTICBUSREQExt,
            SMMEMCLKRATIO    => SMMEMCLKRATIO,
            SMBIGENDIAN      => SMBIGENDIAN,
            SMEXTBUSMUX      => SMEXTBUSMUX,
            SMTICBUSGNTEBI   => SMTICBUSGNTEBI,
            SMBUSGNTEBI      => SMBUSGNTEBI,
            SMBUSBACKOFFEBI  => SMBUSBACKOFFEBI,

            HRDATAREG        => HRDATAREG,
            HREADYOUTREG     => HREADYOUTREG,
            HRESPREG         => HRESPREG,
            SMTICBUSGNTExt   => SMTICBUSGNTExt,
            SMBUSGNTExt      => SMBUSGNTExt,
            SmBusBackOffExt  => SmBusBackOffExt,
            BUSMUXEXT        => BUSMUXEXT,
            BIGENDIAN        => BIGENDIAN,
            SMBUSREQEBI      => SMBUSREQEBI,
            SMTICBUSREQEBI   => SMTICBUSREQEBI,
            ClockRatio       => ClockRatio,
            MemClkRegTogl    => MemClkRegTogl,
            MW1              => MW1,
            SMBLSPol1        => SMBLSPol1,
            BMRead1          => BMRead1,
            BIWriteEn1       => BIWriteEn1,
            BIReadEn1        => BIReadEn1,
            WrapRead         => WrapRead,
            BMWrite1         => BMWrite1,
            SyncEnRead1      => SyncEnRead1,
            SyncEnWrite1     => SyncEnWrite1,
            BurstLenRead1    => BurstLenRead1,
            BurstLenWrite1   => BurstLenWrite1,
            AddrValidReadEn1 => AddrValidReadEn1,
            AddrValWriteEn1  => AddrValWriteEn1,
            SMClockEn        => SMClockEn,
            WP1              => WP1,
            RBLE1            => RBLE1,
            WaitEn1          => WaitEn1,
            WaitPol1         => WaitPol1,
            WSTRD1           => WSTRD1,
            WSTBRD1          => WSTBRD1,
            WSTWR1           => WSTWR1,
            WSTOEN1          => WSTOEN1,
            WSTWEN1          => WSTWEN1,
            IDCYC1           => IDCYC1
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcPadIf
-- -----------------------------------------------------------------------------
uSsmcPadIf : SsmcPadIf
  port map (
            SMFBCLK0         => SMFBCLK0,
            SMFBCLK1         => SMFBCLK1,
            SMFBCLK2         => SMFBCLK2,
            SMFBCLK3         => SMFBCLK3,
            nSMMEMCLK        => nSMMEMCLK,
            SMMEMCLK         => SMMEMCLK,
            SMMEMCLKDELAY    => SMMEMCLKDELAY,
            HRESETn          => HRESETn,
            nSMBURSTWAIT     => nSMBURSTWAIT,
            BIGENDIAN        => BIGENDIAN,
            HsizeMemBufWr    => HsizeMemBufWr,
            MWWr             => MWWr,
            RBLEWr           => RBLEWr,
            HwdataBuf        => HwdataBuf,
            MemoryWrSt       => MemoryWrSt,
            nSMWENMC         => nSMWENMC,
            SmAddrTSM        => SmAddrTSM,
            SMADDRMC         => SMADDRMC,
            nSMBLSMC         => nSMBLSMC,
            SMDATAIN         => SMDATAIN,
            NextAsynAxs   => NextAsynAxs,
            NextSmOEn        => NextSmOEn,
            NxtSMADDRVALIDMC => NxtSMADDRVALIDMC,
            NextSMBAAMC      => NextSMBAAMC,      
            NextSMCSMC       => NextSMCSMC,       
            NextSMCSMCn      => NextSMCSMCn,      
            NextSMDATAENMCn  => NextSMDATAENMCn,

            SMADDR           => SMADDR,
            SmBurstWtFbClk   => SmBurstWtFbClk,
            SyncWtSingle     => SyncWtSingle,
            SmDataInFbclk    => SmDataInFbclk,
            SmDataEnCore     => SmDataEnCore,
            SmDataOutCore    => SmDataOutCore,
            SMCS             => SMCS,
            nSMCS            => nSMCS,
            SMBAA            => SMBAA,
            SMADDRVALID      => SMADDRVALID,
            nSMWEN           => nSMWEN,
            nSMOEN           => nSMOEN,
            nSMBLS           => nSMBLS
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcSynchroniser
-- -----------------------------------------------------------------------------
uSsmcSynchroniser : SsmcSynchroniser
  port map (
            SMMEMCLK         => SMMEMCLK,
            HRESETn          => HRESETn,
            SMWAIT           => SMWAIT,
            SMCANCELWAIT     => SMCANCELWAIT,
            WaitPol          => WaitPol,

            SmWaitSync       => SmWaitSync,
            SmCancelWaitSync => SmCancelWaitSync
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcMemTSM
-- -----------------------------------------------------------------------------
uSsmcMemTSM : SsmcMemTSM
  port map (
            SMMEMCLK         => SMMEMCLK,
            HRESETn          => HRESETn,
            MemRdReq         => MemRdReq,
            MemWrReq         => MemWrReq,
            AddrBuf1         => AddrBuf1,
            AddrBuf          => AddrBuf,
            HburstMemBuf     => HburstMemBuf,
            HselMemBuf1      => HselMemBuf1,
            HselMemBuf       => HselMemBuf,
            HtranRegCont     => HtranRegCont,
            HtransMemBuf1    => HtransMemBuf1,
            UseSecBuf        => UseSecBuf,
            HsizeEqMWidth    => HsizeEqMWidth,
            AhbWider         => AhbWider,
            AhbNarrow        => AhbNarrow,
            AddrNotAligned   => AddrNotAligned,
            HsizeMemBuf1     => HsizeMemBuf1,
            HsizeMemBuf      => HsizeMemBuf,
            SyncWtSingle     => SyncWtSingle,
            SmBurstWtFbClk   => SmBurstWtFbClk,
            SmWaitSync       => SmWaitSync,
            SmCancelWaitSync => SmCancelWaitSync,
            MW1              => MW1,
            MW               => MW,
            SMBLSPol         => SMBLSPol,
            RBLE             => RBLE,
            BMRead1          => BMRead1,
            BMWrite          => BMWrite,
            WrapRead         => WrapRead,
            SyncEnRead1      => SyncEnRead1,
            SyncEnWrite      => SyncEnWrite,
            BurstLenRead1    => BurstLenRead1,
            BurstLenWrite    => BurstLenWrite,
            AddrValidReadEn1 => AddrValidReadEn1,
            AddrValidWriteEn => AddrValidWriteEn,
            BIWriteEn        => BIWriteEn,
            BIReadEn1        => BIReadEn1,
            WaitEn           => WaitEn,
            WSTRD1           => WSTRD1,
            WSTBRD1          => WSTBRD1,
            WSTWR            => WSTWR,
            WSTOEN1          => WSTOEN1,
            WSTWEN           => WSTWEN,
            IDCYC            => IDCYC,
            TurnAround       => TurnAround,
            NewBurst         => NewBurst,
            SMClockEn        => SMClockEn,
            ClockRatio       => ClockRatio,
            SMBUSGNT         => SMBUSGNT,
            BUSYCYC          => BUSYCYC,
            IDLECYC          => IDLECYC,
            WRITECYC         => WRITECYC,
            AhbWideWrCnt     => AhbWideWrCnt,
            AhbWideRdCnt     => AhbWideRdCnt,
            AhbCount         => AhbCount,
            NextValByteLane0 => NextValByteLane0,
            NextValByteLane1 => NextValByteLane1,
            NextValByteLane2 => NextValByteLane2,
            NextValByteLane3 => NextValByteLane3,

            MWWr             => MWWr,
            RBLEWr           => RBLEWr,
            HsizeMemBufWr    => HsizeMemBufWr,
            HsizeEqMWidthWr  => HsizeEqMWidthWr,
            AhbWiderWr       => AhbWiderWr,
            AhbNarrowWr      => AhbNarrowWr,
            nSMWENMC         => nSMWENMC,
            SmCSTSM          => SmCSTSM,
            DelSmCSTSM       => DelSmCSTSM,
            SmAddrTSM        => SmAddrTSM,
            SMADDRMC         => SMADDRMC,
            nSMBLSMC         => nSMBLSMC,
            InitSt           => InitSt,
            BurstWriteSt     => BurstWriteSt,
            TurnAroundSt     => TurnAroundSt,
            WaitTxrOnBusSt   => WaitTxrOnBusSt,
            WaitDeAssrtSt    => WaitDeAssrtSt,
            CancelWaitSt     => CancelWaitSt,
            MemoryRdSt       => MemoryRdSt,
            MemoryWrSt       => MemoryWrSt,
            WBstIntrptd      => WBstIntrptd,
            TxrB4BsyAccptd   => TxrB4BsyAccptd,
            NextAsynAxs      => NextAsynAxs,
            NextSmOEn        => NextSmOEn,
            NxtSMADDRVALIDMC => NxtSMADDRVALIDMC,
            NextSMBAAMC      => NextSMBAAMC,      
            NextSMCSMC       => NextSMCSMC,       
            NextSMCSMCn      => NextSMCSMCn,      
            NextSMDATAENMCn  => NextSMDATAENMCn,
            Toggle           => Toggle,
            WaitWrCycVer     => WaitWrCycVer,
            WaitWrCycDup     => WaitWrCycDup,
            WaitWrCycAhb     => WaitWrCycAhb,
            WaitRdCyc        => WaitRdCyc,
            WaitRdCycVer     => WaitRdCycVer,
            SyncEnWriteReg   => SyncEnWriteReg,
            WaitEnReg        => WaitEnReg,
            BMWriteReg       => BMWriteReg,
            WriteBeatCnt     => WriteBeatCnt,
            WaitStatus       => WaitStatus,
            nSmBurstWaitReg  => nSmBurstWaitReg,
            ClkStpd          => ClkStpd,
            SMBUSREQ         => SMBUSREQ
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SsmcDerivedClk
-- -----------------------------------------------------------------------------
uSsmcDerivedClk : SsmcDerivedClk
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMMEMCLK         => SMMEMCLK,
            ClockRatio       => ClockRatio,
            MemClkRegTogl    => MemClkRegTogl,

            SlowClkM         => SlowClkM
           );


end structural;

-- --================================== End ==================================--
