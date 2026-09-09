-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcCore.vhd.rca
-- File Revision          : 1.23
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This is the top level structural module of the Static Memory
--           controller core.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SmcPackage.all;
-- -----------------------------------------------------------------------------

entity SmcCore is
  port (
-- Inputs
        nHCLK            : in    std_logic; -- AHB Clock negative
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB Bus Reset Signal
        HREADYIN         : in    std_logic; -- Multiplexed HREADY input
                                            -- from all slaves
        HADDR            : in    std_logic_vector(28 downto 0);
                                            -- AHB Address Bus
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- The burst transfer information
                                            -- from AHB
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- AHB Bus Transfer type
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB Bus Transfer size
        HWRITE           : in    std_logic; -- AHB Bus Transfer Direction
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELSMC          : in    std_logic; -- Device Select signal of
                                            -- Memory bank on AHB Bus
        HSELREG          : in    std_logic; -- Device Select signal of
                                            -- Configuration registers on
                                            -- AHB Bus
        BIGENDIAN        : in    std_logic; -- Type of endianness of the system
        REMAP            : in    std_logic; -- Indicates the state of the
                                            -- Memory map
        Revision         : in    std_logic_vector(3 downto 0);
                                            -- Revision number setting
   
        SMWAIT           : in    std_logic; -- Async Wait signal from external
                                            -- memory controller
        CANCELSMWAIT     : in    std_logic; -- Asynchronous external input pin
                                            -- to signal that the SMWAIT has
                                            -- timed out
        SMMWCS7          : in    std_logic_vector(1 downto 0);
                                            -- Input pins used to program the
                                            -- memory width bit field of
                                            -- SMCBCR1 register
        SMRBLECS7        : in    std_logic; -- Hardwired input pins for
                                            -- configuring RBLE bit of
                                            -- SMCBCR7 register at reset
        SMCDATAIN        : in    std_logic_vector(31 downto 0);
                                            -- Data from Memory to Smc
        SMBUSGNT         : in    std_logic; -- Bus grant signal to Smc from DBI

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data bus to the AHB
        HREADYOUT        : out   std_logic; -- Signal from the SMC to indicate
                                            -- the completion of the transfer
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Response from the SMC regarding
                                            -- the status of the transfer
        nSMCDATAEN       : out   std_logic_vector(3 downto 0);
                                            -- Memory data bus driver enable
                                            -- from SMC
        nSMWEN           : out   std_logic; -- Memory Write Enable
        nSMOEN           : out   std_logic; -- Memory Output Enable
        SMBUSREQ         : out   std_logic; -- Bus request signal from Smc
                                            -- to DBI
        SMCDATAOUT       : out   std_logic_vector(31 downto 0);
                                            -- Data from Smc to Memory
        SMCS             : out   std_logic_vector(7 downto 0);
                                            -- Memory bank Chip Select output
                                            -- pins
        nSMBLS           : out   std_logic_vector(3 downto 0);
                                            -- Memory device Byte lane enables
        SMCADDR          : out   std_logic_vector(25 downto 0)
                                            -- Memory address bus
       );
end SmcCore;

-- -----------------------------------------------------------------------------
--
--                                   SmcCore
--                                   =======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         This is the top level structural module which interconnects the 
-- following sub-modules :
-- 1. SmcSynchroniser - This sub-block is used to double synchronize the
--                      asynchronous external input signals
-- 2. SmcAhbif - This sub-block interfaces with the AHB bus and contains all
--               the internal registers
-- 3. SmcEIB - The interface to the external world is the function of this
--             sub-module
-- 4. SmcTSM - The main SMC transfer state machine to control all the
--             transactions.
-- 5. SmcTimerWaitCont - The read and write access timings and the external
--                       wait controlled operations are performed.
-- 6. SmcWrEnGen - The appropriate routing of the positive clocked or negative
--                 clocked write enable signals is achieved in this block
--
-- -----------------------------------------------------------------------------

-- --=========================== ARCHITECTURE ================================--

architecture structural of SmcCore is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------
component SmcSynchroniser
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMWAIT           : in    std_logic;
        CANCELSMWAIT     : in    std_logic;

        SmWaitS2         : out   std_logic;
        CnclSmWaitS2     : out   std_logic
       );
end component;

component SmcAhbif
  port (
-- Inputs
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        SMMWCS7          : in    std_logic_vector(1 downto 0);
        SMRBLECS7        : in    std_logic;
        HREADYIN         : in    std_logic;
        HSELSMC          : in    std_logic;
        HSELREG          : in    std_logic;
        HWRITE           : in    std_logic;
        HADDR            : in    std_logic_vector(28 downto 0);
        HWDATA           : in    std_logic_vector(7 downto 0);
        HSIZE            : in    std_logic_vector(2 downto 0);
        HTRANS           : in    std_logic_vector(1 downto 0);
        HBURST           : in    std_logic_vector(2 downto 0);
        REMAP            : in    std_logic;
        Revision         : in    std_logic_vector(3 downto 0);

        WaitToutErr      : in    std_logic;
        MemWrOver        : in    std_logic;
        MemWrOverCo      : in    std_logic;
        MemRdOver        : in    std_logic;
        RdWrBuf          : in    std_logic_vector(31 downto 0);
        SmcAddrReg       : in    std_logic_vector(3 downto 1);
        MemRdOverCo      : in    std_logic;
        BMRdTrans        : in    std_logic;

-- Outputs
        BufWrOver        : out   std_logic;
        BankCmpCo        : out   std_logic;
        MemWrReq         : out   std_logic;
        MemRdReq         : out   std_logic;
        WtdWrReq         : out   std_logic;
        WtdRdReq         : out   std_logic;
        MwPgm            : out   std_logic;
        MSize08          : out   std_logic;
        MSize16          : out   std_logic;
        MSize32          : out   std_logic;
        MW               : out   std_logic_vector(1 downto 0);
        HTransRegCo      : out   std_logic_vector(1 downto 0);
        HSizeRegCo       : out   std_logic_vector(1 downto 0);
        BM               : out   std_logic;
        RBLE             : out   std_logic;
        WaitEn           : out   std_logic;
        WaitPol          : out   std_logic;
        CSPol            : out   std_logic_vector(7 downto 0);
        WST1             : out   std_logic_vector(4 downto 0);
        WST2             : out   std_logic_vector(4 downto 0);
        WSTOEN           : out   std_logic_vector(3 downto 0);
        WSTWEN           : out   std_logic_vector(3 downto 0);
        IDCY             : out   std_logic_vector(3 downto 0);
        HAddrCrnt        : out   std_logic_vector(25 downto 0);
        HAddrWtdCo       : out   std_logic_vector(25 downto 0);
        BnkAddStrCo      : out   std_logic_vector(2 downto 0);
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0);
        BufByPassCo      : out   std_logic;
        HBurstRegCo      : out   std_logic_vector(2 downto 0);
        RemapReg         : out   std_logic;
        AhbRdOver        : out   std_logic;
        MWCfgDone        : out   std_logic
       );
end component;

component SmcEIB
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HWDATA           : in    std_logic_vector(31 downto 0);
        HSizeRegCo       : in    std_logic_vector(1 downto 0);
        MSize08          : in    std_logic;
        MSize16          : in    std_logic;
        MSize32          : in    std_logic;
        BIGENDIAN        : in    std_logic;
        RemapReg         : in    std_logic;
        RBLE             : in    std_logic;
        BM               : in    std_logic;
        CSPol            : in    std_logic_vector(7 downto 0);
        SMCsEnCo         : in    std_logic;
        SMCDATAIN        : in    std_logic_vector(31 downto 0);
        SmcState         : in    std_logic_vector(3 downto 0);
        CntEnd           : in    std_logic;
        HAddrCrnt        : in    std_logic_vector(25 downto 0);
        HAddrWtdCo       : in    std_logic_vector(25 downto 0);
        BnkAddStrCo      : in    std_logic_vector(2 downto 0);
        AddrIncCo        : in    std_logic;
        MemWrReq         : in    std_logic;
        MemRdReq         : in    std_logic;
        WtdWrReq         : in    std_logic;
        WtdRdReq         : in    std_logic;
        MwPgm            : in    std_logic;
        BufWrOver        : in    std_logic;
        ExtWrEnCo        : in    std_logic;
        ExtWrDisCo       : in    std_logic;
        RdCntLdCo        : in    std_logic;
        XoutEnCo         : in    std_logic;
        XoutDisCo        : in    std_logic;
        XdatDisCo        : in    std_logic;
        RdXdatEnCo       : in    std_logic;
        WrXdatEnCo       : in    std_logic;
        BufByPassCo      : in    std_logic;
        BrstAddIncCo     : in    std_logic;
        BMRdTrans        : in    std_logic;
        HBurstRegCo      : in    std_logic_vector(2 downto 0);
        CntEZEnd         : in    std_logic;
        MW               : in    std_logic_vector(1 downto 0);
        HTransRegCo      : in    std_logic_vector(1 downto 0);
        FastRdOp         : in    std_logic;
        WaitToutErr      : in    std_logic;

        PosSMWEN         : out   std_logic;
        PosSMBLS         : out   std_logic_vector(3 downto 0);
        SMCS             : out   std_logic_vector(7 downto 0);
        SMCDATAOUT       : out   std_logic_vector(31 downto 0);
        SMCADDR          : out   std_logic_vector(25 downto 0);
        nSMOEN           : out   std_logic;
        nSMCDATAEN       : out   std_logic_vector(3 downto 0);
        MemWrOver        : out   std_logic;
        MemWrOverCo      : out   std_logic;
        MemRdOver        : out   std_logic;
        MemRdOverCo      : out   std_logic;
        BMlenEnd         : out   std_logic;
        RdWrBuf          : out   std_logic_vector(31 downto 0);
        AhbRdEn          : out   std_logic;
        SmcAddrReg       : out   std_logic_vector(3 downto 1)
       );
end component;

component SmcTSM
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HTransRegCo      : in    std_logic_vector(1 downto 0);
        BM               : in    std_logic;
        MemWrReq         : in    std_logic;
        MemRdReq         : in    std_logic;
        WtdWrReq         : in    std_logic;
        WtdRdReq         : in    std_logic;
        SMBUSGNT         : in    std_logic;
        CntEnd           : in    std_logic;
        DelayEnd         : in    std_logic;
        WaitEn           : in    std_logic;
        BankCmpCo        : in    std_logic;
        WaitToutErr      : in    std_logic;
        BMlenEnd         : in    std_logic;
        BufWrOver        : in    std_logic;
        MemWrOver        : in    std_logic;
        MemRdOver        : in    std_logic;
        MemRdOverCo      : in    std_logic;
        BufByPassCo      : in    std_logic;
        HBurstRegCo      : in    std_logic_vector(2 downto 0);
        AhbRdEn          : in    std_logic;
        AhbRdOver        : in    std_logic;
        HSizeRegCo       : in    std_logic_vector(1 downto 0);
        MW               : in    std_logic_vector(1 downto 0);
        MWCfgDone        : in    std_logic;
        CntEZEnd         : in    std_logic;
        OEnCntEZ         : in    std_logic;
        WEnCntEZ         : in    std_logic;
        RBLE             : in    std_logic;
        BnkAddStrCo      : in    std_logic_vector(2 downto 0);

        SmcState         : out   std_logic_vector(3 downto 0);
        SMBUSREQ         : out   std_logic;
        RdCntLdCo        : out   std_logic;
        RdBMcntLdCo      : out   std_logic;
        WrCntLdCo        : out   std_logic;
        TrArCntLdCo      : out   std_logic;
        ZeroIdleCo       : out   std_logic;
        OEnCntLdCo       : out   std_logic;
        WEnCntLdCo       : out   std_logic;
        ExtWrEnCo        : out   std_logic;
        ExtWrDisCo       : out   std_logic;
        XoutEnCo         : out   std_logic;
        XoutDisCo        : out   std_logic;
        XdatDisCo        : out   std_logic;
        RdXdatEnCo       : out   std_logic;
        WrXdatEnCo       : out   std_logic;
        AddrIncCo        : out   std_logic;
        BrstAddIncCo     : out   std_logic;
        BMRdTrans        : out   std_logic;
        SMCsEnCo         : out   std_logic;
        FastRdOp         : out   std_logic
       );
end component;

component SmcTimerWaitCont
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        WST1             : in    std_logic_vector(4 downto 0);
        WST2             : in    std_logic_vector(4 downto 0);
        IDCY             : in    std_logic_vector(3 downto 0);
        WSTWEN           : in    std_logic_vector(3 downto 0);
        WSTOEN           : in    std_logic_vector(3 downto 0);
        RdCntLdCo        : in    std_logic;
        WrCntLdCo        : in    std_logic;
        TrArCntLdCo      : in    std_logic;
        ZeroIdleCo       : in    std_logic;
        RdBMcntLdCo      : in    std_logic;
        OEnCntLdCo       : in    std_logic;
        WEnCntLdCo       : in    std_logic;
        SmWaitS2         : in    std_logic;
        CnclSmWaitS2     : in    std_logic;
        BM               : in    std_logic;
        WaitEn           : in    std_logic;
        WaitPol          : in    std_logic;
        SmcState         : in    std_logic_vector(3 downto 0);

        CntEnd           : out   std_logic;
        DelayEnd         : out   std_logic;
        WaitToutErr      : out   std_logic;
        OEnCntEZ         : out   std_logic;
        WEnCntEZ         : out   std_logic;
        CntEZEnd         : out   std_logic
       );
end component;

component SmcWrEnGen
  port (
        nHCLK            : in    std_logic;
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        RBLE             : in    std_logic;
        PosSMWEN         : in    std_logic;
        PosSMBLS         : in    std_logic_vector(3 downto 0);
        ExtWrEnCo        : in    std_logic;
        XoutEnCo         : in    std_logic;

        nSMWEN           : out   std_logic;
        nSMBLS           : out   std_logic_vector(3 downto 0)
       );
end component;

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal WaitToutErr      : std_logic;
-- SMWAIT Timeout Error

signal BufWrOver        : std_logic;
-- Buffer storage completion signal during write transfers

signal MemWrOver        : std_logic;
-- Write completion signal to indicate that all data packets have been
-- flushed to the device

signal MemWrOverCo      : std_logic;
-- Combinational version of the MemWrOver

signal MemRdOver        : std_logic;
-- This signal indicates that the all data packets are read from the memory
-- device at the end of read access time

signal RdWrBuf          : std_logic_vector(31 downto 0);
-- Read data path from the EIB block to the HRDATA lines in the AHB
-- interface block

signal MemWrReq         : std_logic;
-- Signal indicating the write transfer being initiated

signal MemRdReq         : std_logic;
-- Signal indicating the read transfer being initiated

signal WtdWrReq         : std_logic;
-- Signal indicating that write transfer is pending on the AHB

signal WtdRdReq         : std_logic;
-- Signal indicating that read transfer is pending on the AHB

signal MwPgm            : std_logic;
-- Indicates that the Waited Read or Write Request
-- is due to MW programming

signal MSize08          : std_logic;
-- Signal to indicate that a 8-bit memory device is being targeted

signal MSize16          : std_logic;
-- Signal to indicate that a 16-bit memory device is being targeted

signal MSize32          : std_logic;
-- Signal to indicate that a 32-bit memory device is being targeted

signal HTransRegCo      : std_logic_vector(1 downto 0);
-- Registered HTRANS   for other blocks

signal HSizeRegCo       : std_logic_vector(1 downto 0);
-- Registered HSIZE   for other blocks

signal BM               : std_logic;
-- Burst ROM device indication

signal RBLE             : std_logic;
-- Byte lane enabled device

signal CSPol            : std_logic_vector(7 downto 0);
-- Chip Select polarity

signal WST1             : std_logic_vector(4 downto 0);
-- Wait State count for single memory read or start of a burst read cycle

signal WST2             : std_logic_vector(4 downto 0);
-- Wait State count for memory write or burst read cycle

signal WSTOEN           : std_logic_vector(3 downto 0);
-- Chip select to Write enable assertion delay

signal WSTWEN           : std_logic_vector(3 downto 0);
-- Chip select to Output enable assertion delay

signal IDCY             : std_logic_vector(3 downto 0);
-- Turn around count value

signal HAddrCrnt        : std_logic_vector(25 downto 0);
-- Registered HADDR for a new transfer

signal BnkAddStrCo      : std_logic_vector(2 downto 0);
-- Stored value of the current Bank Address

signal AddrIncCo        : std_logic;
-- Address increment signal from TSM

signal XoutEnCo         : std_logic;
-- Enable signal for the nSMOEN

signal XoutDisCo        : std_logic;
-- Disable signal for the nSMOEN

signal RdXdatEnCo       : std_logic;
-- Signal to assert the proper byte lanes of external data bus depending on
-- memory width during reads

signal WrXdatEnCo       : std_logic;
-- Signal to assert all the byte lanes of external data bus during a write
-- transfer and during Idle cycles

signal BMlenEnd         : std_logic;
-- Burst length termination signal during burst reads

signal HAddrWtdCo       : std_logic_vector(25 downto 0);
-- Registered HADDR for a waited transfer

signal RdCntLdCo        : std_logic;
-- Load normal read access delay

signal WrCntLdCo        : std_logic;
-- Load write delay

signal TrArCntLdCo      : std_logic;
-- Load Turn around delay

signal ZeroIdleCo       : std_logic;
-- 1 cycle Turn around delay

signal RdBMcntLdCo      : std_logic;
-- Load Burst read delay

signal OEnCntLdCo       : std_logic;
-- Load Output enable delay

signal WEnCntLdCo       : std_logic;
-- Load Write enable delay

signal SmWaitS2         : std_logic;
-- Double Synchronised External wait

signal CnclSmWaitS2     : std_logic;
-- Double synchronised External wait termination

signal WaitEn           : std_logic;
-- Enable for external wait mode

signal WaitPol          : std_logic;
-- External wait Polarity

signal CntEnd           : std_logic;
-- Access timer counter termination signal

signal DelayEnd         : std_logic;
-- Indicates completion of the enable delay {for WEN & OEN}

signal SmcState         : std_logic_vector(3 downto 0);
-- The state machine's current state value

signal ExtWrEnCo        : std_logic;
-- enable signal for generation of write enable and bytelane select

signal ExtWrDisCo       : std_logic;
-- Disabling signal for the write enable and bytelane selects

signal SMCsEnCo         : std_logic;
-- Chip Select enable

signal XdatDisCo        : std_logic;
-- Signal to de-assert the SMCDATAEN output lines

signal BankCmpCo        : std_logic;
-- Signal which checks if the successive transfers are to the same bank

signal PosSMWEN         : std_logic;
-- Positive edge (HCLK) triggered Write Enable, SMWEN

signal PosSMBLS         : std_logic_vector(3 downto 0);
-- Positive edge (HCLK) triggered byte lane select, SMBLS

signal MW               : std_logic_vector(1 downto 0);
-- The registered memory width value of targeted bank

signal BufByPassCo      : std_logic;
-- This signal is used to indicate that the HSIZE = MSIZE and the
-- RdWrBuf can be bypassed during transfers

signal BrstAddIncCo     : std_logic;
-- Signal for incrementing the SMADDR in advance during burst reads

signal BMRdTrans        : std_logic;
-- This signal indicates that current transfer status is burst mode reads

signal HBurstRegCo      : std_logic_vector(2 downto 0);
-- Registered HBURST signal from AHB interface block

signal RemapReg         : std_logic;
-- Registered version of the REMAP input

signal AhbRdEn          : std_logic;
-- Enabling signal to route data to HRDATA bus on read completion

signal AhbRdOver        : std_logic;
-- Signal to indicate the completion of read by AHB

signal SmcAddrReg       : std_logic_vector(3 downto 1);
-- Registered version of SMCADDR bus

signal MWCfgDone        : std_logic;
-- Register bit indicating the completion of the MW bits programming after reset

signal CntEZEnd         : std_logic;
-- Timer counter expiry signal when count values are zero

signal MemRdOverCo      : std_logic;
-- Combinational version of the MemRdOver

signal FastRdOp         : std_logic;
-- In case of Burst reads when the buffer has more data than required by current
-- AHB transfer, it is possible to provide the subsequent data from the
-- internal buffer if the next sequential addresses are in the same field in
-- zero cycles. So speculative advance reads are not done

signal OEnCntEZ          : std_logic;
-- This signal is generated to determine whether the OEnCount delay value is
-- equal to zero

signal WEnCntEZ          : std_logic;
-- This signal is generated to determine whether the WrEnCount delay value is
-- equal to zero

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
-- Instantiation of SmcSynchroniser
-- -----------------------------------------------------------------------------
uSmcSynchroniser : SmcSynchroniser
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMWAIT           => SMWAIT,
            CANCELSMWAIT     => CANCELSMWAIT,

            SmWaitS2         => SmWaitS2,
            CnclSmWaitS2     => CnclSmWaitS2
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcAhbif
-- -----------------------------------------------------------------------------
uSmcAhbif : SmcAhbif
  port map (
-- Inputs
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            SMMWCS7          => SMMWCS7,
            SMRBLECS7        => SMRBLECS7,
            HREADYIN         => HREADYIN,
            HSELSMC          => HSELSMC,
            HSELREG          => HSELREG,
            HWRITE           => HWRITE,
            HADDR            => HADDR,
            HWDATA           => HWDATA(7 downto 0),
            HSIZE            => HSIZE,
            HTRANS           => HTRANS,
            HBURST           => HBURST,
            REMAP            => REMAP,
            Revision         => Revision,

            WaitToutErr      => WaitToutErr,
            MemWrOver        => MemWrOver,
            MemWrOverCo      => MemWrOverCo,
            MemRdOver        => MemRdOver,
            RdWrBuf          => RdWrBuf,
            SmcAddrReg       => SmcAddrReg,
            MemRdOverCo      => MemRdOverCo,
            BMRdTrans        => BMRdTrans,

-- Outputs
            BufWrOver        => BufWrOver,
            BankCmpCo        => BankCmpCo,
            MemWrReq         => MemWrReq,
            MemRdReq         => MemRdReq,
            WtdWrReq         => WtdWrReq,
            WtdRdReq         => WtdRdReq,
            MwPgm            => MwPgm,
            MSize08          => MSize08,
            MSize16          => MSize16,
            MSize32          => MSize32,
            MW               => MW,
            HTransRegCo      => HTransRegCo,
            HSizeRegCo       => HSizeRegCo,
            BM               => BM,
            RBLE             => RBLE,
            WaitEn           => WaitEn,
            WaitPol          => WaitPol,
            CSPol            => CSPol,
            WST1             => WST1,
            WST2             => WST2,
            WSTOEN           => WSTOEN,
            WSTWEN           => WSTWEN,
            IDCY             => IDCY,
            HAddrCrnt        => HAddrCrnt,
            HAddrWtdCo       => HAddrWtdCo,
            BnkAddStrCo      => BnkAddStrCo,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,
            HRDATA           => HRDATA,
            BufByPassCo      => BufByPassCo,
            HBurstRegCo      => HBurstRegCo,
            RemapReg         => RemapReg,
            AhbRdOver        => AhbRdOver,
            MWCfgDone        => MWCfgDone
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcEIB
-- -----------------------------------------------------------------------------
uSmcEIB : SmcEIB
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HWDATA           => HWDATA,

            HSizeRegCo       => HSizeRegCo,
            MSize08          => MSize08,
            MSize16          => MSize16,
            MSize32          => MSize32,
            BIGENDIAN        => BIGENDIAN,
            RemapReg         => RemapReg,
            RBLE             => RBLE,
            BM               => BM,
            CSPol            => CSPol,
            SMCsEnCo         => SMCsEnCo,
            SMCDATAIN        => SMCDATAIN,
            SmcState         => SmcState,
            CntEnd           => CntEnd,
            HAddrCrnt        => HAddrCrnt,
            HAddrWtdCo       => HAddrWtdCo,
            BnkAddStrCo      => BnkAddStrCo,
            AddrIncCo        => AddrIncCo,
            MemWrReq         => MemWrReq,
            MemRdReq         => MemRdReq,
            WtdWrReq         => WtdWrReq,
            WtdRdReq         => WtdRdReq,
            MwPgm            => MwPgm,
            BufWrOver        => BufWrOver,
            ExtWrEnCo        => ExtWrEnCo,
            ExtWrDisCo       => ExtWrDisCo,
            RdCntLdCo        => RdCntLdCo,
            XoutEnCo         => XoutEnCo,
            XoutDisCo        => XoutDisCo,
            XdatDisCo        => XdatDisCo,
            RdXdatEnCo       => RdXdatEnCo,
            WrXdatEnCo       => WrXdatEnCo,
            BufByPassCo      => BufByPassCo,
            BrstAddIncCo     => BrstAddIncCo,
            BMRdTrans        => BMRdTrans,
            HBurstRegCo      => HBurstRegCo,
            CntEZEnd         => CntEZEnd,
            MW               => MW,
            HTransRegCo      => HTransRegCo,
            FastRdOp         => FastRdOp,
            WaitToutErr      => WaitToutErr,

            PosSMWEN         => PosSMWEN,
            PosSMBLS         => PosSMBLS,
            SMCS             => SMCS,
            SMCDATAOUT       => SMCDATAOUT,
            SMCADDR          => SMCADDR,
            nSMOEN           => nSMOEN,
            nSMCDATAEN       => nSMCDATAEN,
            MemWrOver        => MemWrOver,
            MemWrOverCo      => MemWrOverCo,
            MemRdOver        => MemRdOver,
            MemRdOverCo      => MemRdOverCo,
            BMlenEnd         => BMlenEnd,
            RdWrBuf          => RdWrBuf,
            AhbRdEn          => AhbRdEn,
            SmcAddrReg       => SmcAddrReg
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcTSM
-- -----------------------------------------------------------------------------
uSmcTSM : SmcTSM
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HTransRegCo      => HTransRegCo,
            BM               => BM,
            MemWrReq         => MemWrReq,
            MemRdReq         => MemRdReq,
            WtdWrReq         => WtdWrReq,
            WtdRdReq         => WtdRdReq,
            SMBUSGNT         => SMBUSGNT,
            CntEnd           => CntEnd,
            DelayEnd         => DelayEnd,
            WaitEn           => WaitEn,
            BankCmpCo        => BankCmpCo,
            WaitToutErr      => WaitToutErr,
            BMlenEnd         => BMlenEnd,
            BufWrOver        => BufWrOver,
            MemWrOver        => MemWrOver,
            MemRdOver        => MemRdOver,
            MemRdOverCo      => MemRdOverCo,
            BufByPassCo      => BufByPassCo,
            HBurstRegCo      => HBurstRegCo,
            AhbRdEn          => AhbRdEn,
            AhbRdOver        => AhbRdOver,
            HSizeRegCo       => HSizeRegCo,
            MW               => MW,
            MWCfgDone        => MWCfgDone,
            CntEZEnd         => CntEZEnd,
            RBLE             => RBLE,
            BnkAddStrCo      => BnkAddStrCo,
            OEnCntEZ         => OEnCntEZ,
            WEnCntEZ         => WEnCntEZ,

            SmcState         => SmcState,
            SMBUSREQ         => SMBUSREQ,
            RdCntLdCo        => RdCntLdCo,
            RdBMcntLdCo      => RdBMcntLdCo,
            WrCntLdCo        => WrCntLdCo,
            TrArCntLdCo      => TrArCntLdCo,
            ZeroIdleCo       => ZeroIdleCo,
            OEnCntLdCo       => OEnCntLdCo,
            WEnCntLdCo       => WEnCntLdCo,
            ExtWrEnCo        => ExtWrEnCo,
            ExtWrDisCo       => ExtWrDisCo,
            XoutEnCo         => XoutEnCo,
            XoutDisCo        => XoutDisCo,
            XdatDisCo        => XdatDisCo,
            RdXdatEnCo       => RdXdatEnCo,
            WrXdatEnCo       => WrXdatEnCo,
            AddrIncCo        => AddrIncCo,
            BrstAddIncCo     => BrstAddIncCo,
            BMRdTrans        => BMRdTrans,
            SMCsEnCo         => SMCsEnCo,
            FastRdOp         => FastRdOp
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcTimerWaitCont
-- -----------------------------------------------------------------------------
uSmcTimerWaitCont : SmcTimerWaitCont
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            WST1             => WST1,
            WST2             => WST2,
            IDCY             => IDCY,
            SmcState         => SmcState,
            WSTWEN           => WSTWEN,
            WSTOEN           => WSTOEN,
            RdCntLdCo        => RdCntLdCo,
            WrCntLdCo        => WrCntLdCo,
            TrArCntLdCo      => TrArCntLdCo,
            ZeroIdleCo       => ZeroIdleCo,
            RdBMcntLdCo      => RdBMcntLdCo,
            OEnCntLdCo       => OEnCntLdCo,
            WEnCntLdCo       => WEnCntLdCo,
            SmWaitS2         => SmWaitS2,
            CnclSmWaitS2     => CnclSmWaitS2,
            BM               => BM,
            WaitEn           => WaitEn,
            WaitPol          => WaitPol,

            CntEnd           => CntEnd,
            DelayEnd         => DelayEnd,
            WaitToutErr      => WaitToutErr,
            OEnCntEZ         => OEnCntEZ,
            WEnCntEZ         => WEnCntEZ,
            CntEZEnd         => CntEZEnd
           );

-- -----------------------------------------------------------------------------
-- Instantiation of SmcWrEnGen
-- -----------------------------------------------------------------------------
uSmcWrEnGen : SmcWrEnGen
  port map (
            nHCLK            => nHCLK,
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            RBLE             => RBLE,
            PosSMWEN         => PosSMWEN,
            PosSMBLS         => PosSMBLS,
            ExtWrEnCo        => ExtWrEnCo,
            XoutEnCo         => XoutEnCo,

            nSMWEN           => nSMWEN,
            nSMBLS           => nSMBLS
           );

end structural;

-- --================================== End ==================================--
