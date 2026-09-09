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
-- File Name              : SmcAhbif.vhd.rca
-- File Revision          : 1.26
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module interfaces with the AHB bus.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.SmcPackage.all;

-- -----------------------------------------------------------------------------

entity SmcAhbif is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- AHB system level Reset
        SMMWCS7          : in    std_logic_vector(1 downto 0);
                                            -- Hardwired input pins for
                                            -- configuring the MW bits of
                                            -- SMCBCR7 register at reset
        SMRBLECS7        : in    std_logic; -- Hardwired input pins for
                                            -- configuring RBLE bit of
                                            -- SMCBCR7 register at reset
        HREADYIN         : in    std_logic; -- Transfer completion input signal
        HSELSMC          : in    std_logic; -- Select signal for the memory
                                            -- transfer by the SmcCore
        HSELREG          : in    std_logic; -- Select signal for accessing
                                            -- the SmcCore internal registers
        HWRITE           : in    std_logic; -- Signal to indicate the direction
                                            -- of transfer (read or write)
        HADDR            : in    std_logic_vector(28 downto 0);
                                            -- The address bus input from AHB
        HWDATA           : in    std_logic_vector(7 downto 0);
                                            -- Slice of the Write data
                                            -- input bus from AHB
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size indication
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Signal to indicate the current
                                            -- transfer type
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- The burst transfer information
                                            -- from AHB
        REMAP            : in    std_logic; -- Indicates the state of the
                                            -- Memory map
        Revision         : in    std_logic_vector(3 downto 0);
                                            -- Revision number from SmcRevAnd

        WaitToutErr      : in    std_logic; -- Signal indicating the timeout
                                            -- error on SMWAIT
        MemWrOver        : in    std_logic; -- Memory device write completion
                                            -- signal
        MemWrOverCo      : in    std_logic; -- This signal is the combinational
                                            -- version of the MemWrOver
        MemRdOver        : in    std_logic; -- Data read completion from
                                            -- the memory
        RdWrBuf          : in    std_logic_vector(31 downto 0);
                                            -- The registered Read data bus from
                                            -- the EIB
        SmcAddrReg       : in    std_logic_vector(3 downto 1);
                                            -- Registered splice version of
                                            -- SMCADDR bus
        MemRdOverCo      : in    std_logic; -- Combinational version of the
                                            -- MemRdOver
        BMRdTrans        : in    std_logic; -- This signal indicates that 
                                            -- current transfer status is burst
                                            -- mode reads

-- Outputs
        HREADYOUT        : out   std_logic; -- This signal is used to
                                            -- indicate the completion of
                                            -- transfer
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- SmcCore response output
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB read data bus

        BufWrOver        : out   std_logic; -- Signal to flag completion of the
                                            -- write operation in the internal
                                            -- buffer
        BankCmpCo        : out   std_logic; -- Signal which checks if the
                                            -- successive transfers are to
                                            -- the same bank
        MemWrReq         : out   std_logic; -- Signal indicating the write
                                            -- transfer has been initiated
        MemRdReq         : out   std_logic; -- Signal indicating the read
                                            -- transfer being initiated
        WtdWrReq         : out   std_logic; -- Signal indicating that write
                                            -- transfer is pending on the AHB
        WtdRdReq         : out   std_logic; -- Signal indicating that read
                                            -- transfer is pending on the AHB
        MwPgm            : out   std_logic; -- Indicates that the Waited Read or
                                            -- Write Request is due to MW
                                            -- programming
        MSize08          : out   std_logic; -- Signal to indicate that a 8-bit
                                            -- memory device is being targeted
        MSize16          : out   std_logic; -- Signal to indicate that a 16-bit
                                            -- memory device is being targeted
        MSize32          : out   std_logic; -- Signal to indicate that a 32-bit
                                            -- memory device is being targeted
        MW               : out   std_logic_vector(1 downto 0);
                                            -- The memory width bits selection
                                            -- from one of the bank registers
        HTransRegCo      : out   std_logic_vector(1 downto 0);
                                            -- Registered HTRANS for a current
                                            -- or waited transfer
        HSizeRegCo       : out   std_logic_vector(1 downto 0);
                                            -- Registered HSIZE for a current
                                            -- waited transfer
        BM               : out   std_logic; -- Burst Mode
        RBLE             : out   std_logic; -- Byte lane enabled device
        WaitEn           : out   std_logic; -- Enable signal for using
                                            -- SMWAIT input
        WaitPol          : out   std_logic; -- Indication of the polarity
                                            -- of SMWAIT
        CSPol            : out   std_logic_vector(7 downto 0);
                                            -- Indication of chip select
                                            -- polarity
        WST1             : out   std_logic_vector(4 downto 0);
                                            -- Read access count value of the
                                            -- bank targeted currently
        WST2             : out   std_logic_vector(4 downto 0);
                                            -- Write access count or Burst
                                            -- read value of the bank targeted
                                            -- currently
        WSTOEN           : out   std_logic_vector(3 downto 0);
                                            -- Delay value for the assertion
                                            -- of the OEN
        WSTWEN           : out   std_logic_vector(3 downto 0);
                                            -- Delay value for the assertion
                                            -- of the WEN and BLS signals
        IDCY             : out   std_logic_vector(3 downto 0);
                                            -- Count value for the
                                            -- turnaround cycles
        HAddrCrnt        : out   std_logic_vector(25 downto 0);
                                            -- The registered HADDR for a new
                                            -- memory transfer
        HAddrWtdCo       : out   std_logic_vector(25 downto 0);
                                            -- The combinational version of 
                                            -- HAddrCrnt for a waited memory
                                            -- transfer
        BnkAddStrCo      : out   std_logic_vector(2 downto 0);
                                            -- Stored value of the Bank Address
        BufByPassCo      : out   std_logic; -- This signal is used to indicate
                                            -- that the HSIZE = MSIZE and the
                                            -- RdWrBuf can be bypassed during
                                            -- write transfers
        HBurstRegCo      : out   std_logic_vector(2 downto 0);
                                            -- Registered HBURST signal from
                                            -- AHB interface block
        RemapReg         : out   std_logic; -- Registered version of REMAP
        AhbRdOver        : out   std_logic; -- Signal to indicate the completion
                                            -- of read by AHB
        MWCfgDone        : out   std_logic  -- Register bit indicating the
                                            -- completion of the MW bits
                                            -- programming after reset
       );
end SmcAhbif;

-- -----------------------------------------------------------------------------
--
--                                  SmcAhbif
--                                  ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--           It consists of the AHB response generation logic, the memory
--           device parameter registers, control registers and status registers.
--
-- -----------------------------------------------------------------------------
--                          SMC Control Register Map
-- -----------------------------------------------------------------------------
-- Offset  Read (Width)          Write (Width)       Description
-- -----------------------------------------------------------------------------
--                              Memory Bank 0

-- 0x000 SMBIDCYR0(4-bit)     SMCIDCYR0(4-bit)     Idle Cycle
-- 0x004 SMBWST1R0(5-bit)     SMBWST1R0(5-bit)     Wait State 1
-- 0x008 SMBWST2R0(5-bit)     SMBWST2R0(5-bit)     Wait State 2
-- 0x00C SMBWSTOENR0(4-bit)   SMBWSTOENR0(4-bit)   OE Assertion Delay
-- 0x010 SMBWSTWENR0(4-bit)   SMBWSTWENR0(4-bit)   WE Assertion Delay
-- 0x014 SMBCR0(8-bit)        SMBCR0(8-bit)        Control Register
-- 0x018 SMBSR0(3-bit)        SMBSR0(3-bit)        Status Register

--                              Memory Bank 1

-- 0x01C SMBIDCYR1(4-bit)     SMCIDCYR1(4-bit)     Idle Cycle
-- 0x020 SMBWST1R1(5-bit)     SMBWST1R1(5-bit)     Wait State 1
-- 0x024 SMBWST2R1(5-bit)     SMBWST2R1(5-bit)     Wait State 2
-- 0x028 SMBWSTOENR1(4-bit)   SMBWSTOENR1(4-bit)   OE Assertion Delay
-- 0x02C SMBWSTWENR1(4-bit)   SMBWSTWENR1(4-bit)   WE Assertion Delay
-- 0x030 SMBCR1(8-bit)        SMBCR1(8-bit)        Control Register
-- 0x034 SMBSR1(3-bit)        SMBSR1(3-bit)        Status Register

--                              Memory Bank 2

-- 0x038 SMBIDCYR2(4-bit)     SMCIDCYR2(4-bit)     Idle Cycle
-- 0x03C SMBWST1R2(5-bit)     SMBWST1R2(5-bit)     Wait State 1
-- 0x040 SMBWST2R2(5-bit)     SMBWST2R2(5-bit)     Wait State 2
-- 0x044 SMBWSTOENR2(4-bit)   SMBWSTOENR2(4-bit)   OE Assertion Delay
-- 0x048 SMBWSTWENR2(4-bit)   SMBWSTWENR2(4-bit)   WE Assertion Delay
-- 0x04C SMBCR2(8-bit)        SMBCR2(8-bit)        Control Register
-- 0x050 SMBSR2(3-bit)        SMBSR2(3-bit)        Status Register

--                              Memory Bank 3

-- 0x054 SMBIDCYR3(4-bit)     SMCIDCYR3(4-bit)     Idle Cycle
-- 0x058 SMBWST1R3(5-bit)     SMBWST1R3(5-bit)     Wait State 1
-- 0x05C SMBWST2R3(5-bit)     SMBWST2R3(5-bit)     Wait State 2
-- 0x060 SMBWSTOENR3(4-bit)   SMBWSTOENR3(4-bit)   OE Assertion Delay
-- 0x064 SMBWSTWENR3(4-bit)   SMBWSTWENR3(4-bit)   WE Assertion Delay
-- 0x068 SMBCR3(8-bit)        SMBCR3(8-bit)        Control Register
-- 0x06C SMBSR3(3-bit)        SMBSR3(3-bit)        Status Register

--                              Memory Bank 4

-- 0x070 SMBIDCYR4(4-bit)     SMCIDCYR4(4-bit)     Idle Cycle
-- 0x074 SMBWST1R4(5-bit)     SMBWST1R4(5-bit)     Wait State 1
-- 0x078 SMBWST2R4(5-bit)     SMBWST2R4(5-bit)     Wait State 2
-- 0x07C SMBWSTOENR4(4-bit)   SMBWSTOENR4(4-bit)   OE Assertion Delay
-- 0x080 SMBWSTWENR4(4-bit)   SMBWSTWENR4(4-bit)   WE Assertion Delay
-- 0x084 SMBCR4(8-bit)        SMBCR4(8-bit)        Control Register
-- 0x088 SMBSR4(3-bit)        SMBSR4(3-bit)        Status Register

--                              Memory Bank 5

-- 0x08C SMBIDCYR5(4-bit)     SMCIDCYR5(4-bit)     Idle Cycle
-- 0x090 SMBWST1R5(5-bit)     SMBWST1R5(5-bit)     Wait State 1
-- 0x094 SMBWST2R5(5-bit)     SMBWST2R5(5-bit)     Wait State 2
-- 0x098 SMBWSTOENR5(4-bit)   SMBWSTOENR5(4-bit)   OE Assertion Delay
-- 0x09C SMBWSTWENR5(4-bit)   SMBWSTWENR5(4-bit)   WE Assertion Delay
-- 0x0A0 SMBCR5(8-bit)        SMBCR5(8-bit)        Control Register
-- 0x0A4 SMBSR5(3-bit)        SMBSR5(3-bit)        Status Register

--                              Memory Bank 6

-- 0x0A8 SMBIDCYR6(4-bit)     SMCIDCYR6(4-bit)     Idle Cycle
-- 0x0AC SMBWST1R6(5-bit)     SMBWST1R6(5-bit)     Wait State 1
-- 0x0B0 SMBWST2R6(5-bit)     SMBWST2R6(5-bit)     Wait State 2
-- 0x0B4 SMBWSTOENR6(4-bit)   SMBWSTOENR6(4-bit)   OE Assertion Delay
-- 0x0B8 SMBWSTWENR6(4-bit)   SMBWSTWENR6(4-bit)   WE Assertion Delay
-- 0x0BC SMBCR6(8-bit)        SMBCR6(8-bit)        Control Register
-- 0x0C0 SMBSR6(3-bit)        SMBSR6(3-bit)        Status Register

--                              Memory Bank 7

-- 0x0C4 SMBIDCYR7(4-bit)     SMCIDCYR7(4-bit)     Idle Cycle
-- 0x0C8 SMBWST1R7(5-bit)     SMBWST1R7(5-bit)     Wait State 1
-- 0x0CC SMBWST2R7(5-bit)     SMBWST2R7(5-bit)     Wait State 2
-- 0x0D0 SMBWSTOENR7(4-bit)   SMBWSTOENR7(4-bit)   OE Assertion Delay
-- 0x0D4 SMBWSTWENR7(4-bit)   SMBWSTWENR7(4-bit)   WE Assertion Delay
-- 0x0D8 SMBCR7(8-bit)        SMBCR7(8-bit)        Control Register
-- 0x0DC SMBSR7(3-bit)        SMBSR7(3-bit)        Status Register

--                 External Wait Status bit after a timeout error

-- 0x0E0 SMBEWS(1-bit)        SMBEWS(RO)        External Wait Status bit

--                        SMC Identification Registers

-- 0xFE0 SMCPeriphID0(8-bit)          -            Peripheral Id register0
-- 0xFE4 SMCPeriphID1(8-bit)          -            Peripheral Id register1
-- 0xFE8 SMCPeriphID2(8-bit)          -            Peripheral Id register2
-- 0xFEC SMCPeriphID3(8-bit)          -            Peripheral Id register3
-- 0xFF0 SMCPCellID0(8-bit)           -            Prime Cell Id register0
-- 0xFF4 SMCPCellID1(8-bit)           -            Prime Cell Id register1
-- 0xFF8 SMCPCellID2(8-bit)           -            Prime Cell Id register2
-- 0xFFC SMCPCellID3(8-bit)           -            Prime Cell Id register3
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture synth of SmcAhbif is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iMWCfgDone       : std_logic;
-- Register bit indicating the completion of the MW bits programming after
-- reset

signal NextMWCfgDone    : std_logic;
-- D-input of the MWCfgDone signal

signal HResetDet1       : std_logic;
signal HResetDet2       : std_logic;
-- Signals to detect the reset condition on the HRESETn input pin

signal HSizeErr         : std_logic;
-- Signal indicating the transfer size error

signal NextHSizeErr     : std_logic;
-- D-input of HSizeErr

signal WP               : std_logic;
-- Local Copy of Write Protect bit

signal HAddrReg         : std_logic_vector(11 downto 2);
-- The HAddr slice used during Internal register read & write

signal NextHAddrReg     : std_logic_vector(11 downto 2);
-- D-input of HAddrReg

signal HTransCrnt       : std_logic_vector(1 downto 0);
-- Internal version of HTransCrnt

signal NextHTransCrnt   : std_logic_vector(1 downto 0);
-- D-input of HTransCrnt

signal HTransWtd        : std_logic_vector(1 downto 0);
-- Internal version of HTransWtd

signal NextHTransWtd    : std_logic_vector(1 downto 0);
-- D-input of HTransWtd

signal iHTransReg       : std_logic_vector(1 downto 0);
-- Internal version of HTransReg

signal NextHTransReg    : std_logic_vector(1 downto 0);
-- D-input of HTransReg

signal HWriteReg        : std_logic;
-- Internally registered HWRITE

signal NextHWriteReg    : std_logic;
-- D-input of HWriteReg

signal SMBIDCYR0        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 0

signal SMBWST1R0        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank

signal SMBWST2R0        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 0

signal SMBWSTOENR0      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 0

signal SMBWSTWENR0      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 0

signal SMBCR0           : std_logic_vector(7 downto 0);
-- Control Register for Bank 0

signal SMBIDCYR1        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 1

signal SMBWST1R1        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 1

signal SMBWST2R1        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 1

signal SMBWSTOENR1      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 1

signal SMBWSTWENR1      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 1

signal SMBCR1           : std_logic_vector(7 downto 0);
-- Control Register for Bank 1

signal SMBIDCYR2        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 2

signal SMBWST1R2        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 2

signal SMBWST2R2        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 2

signal SMBWSTOENR2      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 2

signal SMBWSTWENR2      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 2

signal SMBCR2           : std_logic_vector(7 downto 0);
-- Control Register for Bank 2

signal SMBIDCYR3        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 3

signal SMBWST1R3        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 3

signal SMBWST2R3        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 3

signal SMBWSTOENR3      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 3

signal SMBWSTWENR3      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 3

signal SMBCR3           : std_logic_vector(7 downto 0);
-- Control Register for Bank 3

signal SMBIDCYR4        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 4

signal SMBWST1R4        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 4

signal SMBWST2R4        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 4

signal SMBWSTOENR4      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 4

signal SMBWSTWENR4      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 4

signal SMBCR4           : std_logic_vector(7 downto 0);
-- Control Register for Bank 4

signal SMBIDCYR5        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 5

signal SMBWST1R5        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 5

signal SMBWST2R5        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 5

signal SMBWSTOENR5      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 5

signal SMBWSTWENR5      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 5

signal SMBCR5           : std_logic_vector(7 downto 0);
-- Control Register for Bank 5

signal SMBIDCYR6        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 6

signal SMBWST1R6        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 6

signal SMBWST2R6        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 6

signal SMBWSTOENR6      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 6

signal SMBWSTWENR6      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 6

signal SMBCR6           : std_logic_vector(7 downto 0);
-- Control Register for Bank 6

signal SMBIDCYR7        : std_logic_vector(3 downto 0);
-- Idle cycle Control Register for Bank 7

signal SMBWST1R7        : std_logic_vector(4 downto 0);
-- Wait State 1 Control Register for Bank 7

signal SMBWST2R7        : std_logic_vector(4 downto 0);
-- Wait State 2 control Register for Bank 7

signal SMBWSTOENR7      : std_logic_vector(3 downto 0);
-- OE Assertion Delay Control Register for Bank 7

signal SMBWSTWENR7      : std_logic_vector(3 downto 0);
-- WE Assertion Delay Control Register for Bank 7

signal SMBCR7           : std_logic_vector(7 downto 0);
-- Control Register for Bank 7

signal SMCPeriphID0     : std_logic_vector(7 downto 0);
-- Peripheral ID Register0 Bits

signal SMCPeriphID1     : std_logic_vector(7 downto 0);
-- Peripheral ID Register1 Bits

signal SMCPeriphID2     : std_logic_vector(3 downto 0);
-- Peripheral ID Register2 Bits

signal SMCPeriphID3     : std_logic_vector(7 downto 0);
-- Peripheral ID Register3 Bits

signal SMCPCellID0      : std_logic_vector(7 downto 0);
-- Prime Cell ID Register0 Bits

signal SMCPCellID1      : std_logic_vector(7 downto 0);
-- Prime Cell ID Register1 Bits

signal SMCPCellID2      : std_logic_vector(7 downto 0);
-- Prime Cell ID Register2 Bits

signal SMCPCellID3      : std_logic_vector(7 downto 0);
-- Prime Cell ID Register3 Bits

signal NextSMBIDCYR0    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 0

signal NextSMBWST1R0    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank

signal NextSMBWST2R0    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 0

signal NextSMBWSTOENR0  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 0

signal NextSMBWSTWENR0  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 0

signal NextSMBCR0       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 0

signal NextSMBIDCYR1    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 1

signal NextSMBWST1R1    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 1

signal NextSMBWST2R1    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 1

signal NextSMBWSTOENR1  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 1

signal NextSMBWSTWENR1  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 1

signal NextSMBCR1       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 1

signal NextSMBIDCYR2    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 2

signal NextSMBWST1R2    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 2

signal NextSMBWST2R2    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 2

signal NextSMBWSTOENR2  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 2

signal NextSMBWSTWENR2  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 2

signal NextSMBCR2       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 2

signal NextSMBIDCYR3    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 3

signal NextSMBWST1R3    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 3

signal NextSMBWST2R3    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 3

signal NextSMBWSTOENR3  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 3

signal NextSMBWSTWENR3  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 3

signal NextSMBCR3       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 3

signal NextSMBIDCYR4    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 4

signal NextSMBWST1R4    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 4

signal NextSMBWST2R4    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 4

signal NextSMBWSTOENR4  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 4

signal NextSMBWSTWENR4  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 4

signal NextSMBCR4       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 4

signal NextSMBIDCYR5    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 5

signal NextSMBWST1R5    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 5

signal NextSMBWST2R5    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 5

signal NextSMBWSTOENR5  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 5

signal NextSMBWSTWENR5  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 5

signal NextSMBCR5       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 5

signal NextSMBIDCYR6    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 6

signal NextSMBWST1R6    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 6

signal NextSMBWST2R6    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 6

signal NextSMBWSTOENR6  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 6

signal NextSMBWSTWENR6  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 6

signal NextSMBCR6       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 6

signal NextSMBIDCYR7    : std_logic_vector(3 downto 0);
-- D-input of Idle cycle Control Register for Bank 7

signal NextSMBWST1R7    : std_logic_vector(4 downto 0);
-- D-input of Wait State 1 Control Register for Bank 7

signal NextSMBWST2R7    : std_logic_vector(4 downto 0);
-- D-input of Wait State 2 control Register for Bank 7

signal NextSMBWSTOENR7  : std_logic_vector(3 downto 0);
-- D-input of OE Assertion Delay Control Register for Bank 7

signal NextSMBWSTWENR7  : std_logic_vector(3 downto 0);
-- D-input of WE Assertion Delay Control Register for Bank 7

signal NextSMBCR7       : std_logic_vector(7 downto 0);
-- D-input of Control Register for Bank 7

signal SMBCR7WrEn       : std_logic;
-- SMBCR7 Write Enable signal

signal RegWrEn          : std_logic;
-- Write enable signal for the internal registers

signal NextRegWrEn      : std_logic;
-- D-input of RegWrEn

signal WtdRegWr         : std_logic;
-- Waited WR to register if transfer is attempted when MWCfgDone=0

signal NextWtdRegWr     : std_logic;
-- D-input of WtdRegWr

signal RegRdEn          : std_logic;
-- Read enable signal from the internal registers

signal NextRegRdEn      : std_logic;
-- D-input of RegRdEn

signal WtdRegRd         : std_logic;
-- Waited RD to register if transfer is attempted when MWCfgDone=0

signal NextWtdRegRd     : std_logic;
-- D-input of WtdRegRd

signal WtdRegRdEn       : std_logic;
-- Waited read enable after the MWCfgDone becomes 1

signal NextWtdRegRdEn   : std_logic;
-- D-input of WtdRegRdEn

signal HSelREGD1        : std_logic;
-- One clock delayed version of HSELREG

signal HAddrGated       : std_logic_vector (11 downto 2);
-- Gated HADDR to reduce the power comsumption

signal HWdataGtd        : std_logic_vector (7 downto 0);
-- Gated HWDATA to reduce the power comsumption

signal iHRESPReg        : std_logic_vector (1 downto 0);
-- Internal version of the HRESPReg for Reg transactions

signal NextHRESPReg     : std_logic_vector (1 downto 0);
-- D-input of the HRESPReg

signal iHRESPMem        : std_logic_vector (1 downto 0);
-- Internal version of the HRESPMem for Mem transactions

signal NextHRESPMem     : std_logic_vector (1 downto 0);
-- D-input of the HRESPMem

signal iHREADYOUTReg    : std_logic;
-- Internal version of the HREADYOUTReg 

signal NextHREADYOUTReg : std_logic;
-- D-input of the HREADYOUTReg

signal iHREADYOUTMem    : std_logic;
-- Internal version of the HREADYOUTMem 

signal NextHREADYOUTMem : std_logic;
-- D-input of the HREADYOUTMem

signal AddrContStr      : std_logic;
-- Combinational signal used to store the HADDR for waited/pending
-- write or read transfer

signal NxtAddrContStr   : std_logic;
-- D-input of AddrContStr

signal iMemWrReq        : std_logic;
-- Internal version of the MemWrReq signal

signal NextMemWrReq     : std_logic;
-- D-input of the MemWrReq

signal iMemRdReq        : std_logic;
-- Internal version of the MemRdReq signal

signal NextMemRdReq     : std_logic;
-- D-input of the MemRdReq

signal iWtdWrReq        : std_logic;
-- Internal version of the WtdWrReq signal

signal NextWtdWrReq     : std_logic;
-- D-input of the WtdWrReq

signal iWtdRdReq        : std_logic;
-- Internal version of the WtdRdReq signal

signal NextWtdRdReq     : std_logic;
-- D-input of the WtdRdReq

signal iMwPgm           : std_logic;
-- Internal version of the MwPgm signal

signal NextMwPgm        : std_logic;
-- D-input of the MwPgm

signal WpErrTmp         : std_logic;
-- temporary combinational signal to flag the write protect error

signal NextWpErrTmp     : std_logic;
-- D-input of the WpErrTmp

signal iWaitEn          : std_logic;
-- Internal version of WaitEn

signal NextWaitEn       : std_logic;
-- D-input of the WaitEn

signal Wait1Cyc         : std_logic;
-- Signal used for inserting 1 wait cycle

signal NextWait1Cyc     : std_logic;
-- D-input of the Wait1Cyc

signal IntHSelReg       : std_logic;
-- Internal registered version of HSELREG

signal NextIntHSelReg   : std_logic;
-- D-input of the IntHSelReg

signal iCSPol           : std_logic_vector(7 downto 0);
-- Internal copy of CSPol

signal NextCSPol        : std_logic_vector(7 downto 0);
-- D-input of CSPol

signal iMSize08         : std_logic;
-- Internal copy of MSize08

signal iMSize16         : std_logic;
-- Internal copy of MSize16

signal iMSize32         : std_logic;
-- Internal copy of MSize32

signal iHAddrCrnt       : std_logic_vector(28 downto 0);
-- Internal version of HAddrCrnt

signal NextHAddrCrnt    : std_logic_vector(28 downto 0);
-- D-input of HAddrCrnt

signal iHAddrWtd        : std_logic_vector(25 downto 0);
-- Internal version of HAddrWtd

signal NextHAddrWtd     : std_logic_vector(25 downto 0);
-- D-input of HAddrWtd

signal HSizeCrnt        : std_logic_vector(1 downto 0);
-- Internal copy of HSizeCrnt

signal NextHSizeCrnt    : std_logic_vector(1 downto 0);
-- D-input of HSizeCrnt

signal HSizeWtd         : std_logic_vector(1 downto 0);
-- Internal copy of HSizeWtd

signal NextHSizeWtd     : std_logic_vector(1 downto 0);
-- D-input of HSizeWtd

signal iHSizeReg        : std_logic_vector(1 downto 0);
-- Internal copy of HSizeReg

signal NextHSizeReg     : std_logic_vector(1 downto 0);
-- D-input of HSizeReg

signal iMW              : std_logic_vector(1 downto 0);
-- The memory width bits selection from one of the bank registers

signal NextMW           : std_logic_vector(1 downto 0);
-- D-input of MW

signal ToutErrClr0      : std_logic;
signal ToutErrClr1      : std_logic;
signal ToutErrClr2      : std_logic;
signal ToutErrClr3      : std_logic;
signal ToutErrClr4      : std_logic;
signal ToutErrClr5      : std_logic;
signal ToutErrClr6      : std_logic;
signal ToutErrClr7      : std_logic;
-- Signals to clear the WaitToutErr status flag bit

signal WPErrClr0        : std_logic;
signal WPErrClr1        : std_logic;
signal WPErrClr2        : std_logic;
signal WPErrClr3        : std_logic;
signal WPErrClr4        : std_logic;
signal WPErrClr5        : std_logic;
signal WPErrClr6        : std_logic;
signal WPErrClr7        : std_logic;
-- Signals to clear the WrProtErr status flag bit

signal HSizeErrClr0     : std_logic;
signal HSizeErrClr1     : std_logic;
signal HSizeErrClr2     : std_logic;
signal HSizeErrClr3     : std_logic;
signal HSizeErrClr4     : std_logic;
signal HSizeErrClr5     : std_logic;
signal HSizeErrClr6     : std_logic;
signal HSizeErrClr7     : std_logic;
-- Signals to clear the HSizeErr status flag bit

signal iBnkAddStr       : std_logic_vector(2 downto 0);
-- Internal copy of BnkAddStr

signal NextBnkAddStr    : std_logic_vector(2 downto 0);
-- D-input of BnkAddStr

signal BnkAddWtd        : std_logic_vector(2 downto 0);
-- Internal copy of BnkAddWtd

signal NextBnkAddWtd    : std_logic_vector(2 downto 0);
-- D-input of BnkAddWtd

signal ToutErrGen0      : std_logic;
signal ToutErrGen1      : std_logic;
signal ToutErrGen2      : std_logic;
signal ToutErrGen3      : std_logic;
signal ToutErrGen4      : std_logic;
signal ToutErrGen5      : std_logic;
signal ToutErrGen6      : std_logic;
signal ToutErrGen7      : std_logic;
-- Generation of the WaitToutErr for different banks

signal WPErrGen0        : std_logic;
signal WPErrGen1        : std_logic;
signal WPErrGen2        : std_logic;
signal WPErrGen3        : std_logic;
signal WPErrGen4        : std_logic;
signal WPErrGen5        : std_logic;
signal WPErrGen6        : std_logic;
signal WPErrGen7        : std_logic;
-- Generation of the WrProtErr for different banks

signal HSizeErrGen0     : std_logic;
signal HSizeErrGen1     : std_logic;
signal HSizeErrGen2     : std_logic;
signal HSizeErrGen3     : std_logic;
signal HSizeErrGen4     : std_logic;
signal HSizeErrGen5     : std_logic;
signal HSizeErrGen6     : std_logic;
signal HSizeErrGen7     : std_logic;
-- Generation of the HSizeErr for different banks

signal ToutErrR0        : std_logic;
signal ToutErrR1        : std_logic;
signal ToutErrR2        : std_logic;
signal ToutErrR3        : std_logic;
signal ToutErrR4        : std_logic;
signal ToutErrR5        : std_logic;
signal ToutErrR6        : std_logic;
signal ToutErrR7        : std_logic;
-- The WaitToutErr storage flag register

signal NextToutErrR0    : std_logic;
signal NextToutErrR1    : std_logic;
signal NextToutErrR2    : std_logic;
signal NextToutErrR3    : std_logic;
signal NextToutErrR4    : std_logic;
signal NextToutErrR5    : std_logic;
signal NextToutErrR6    : std_logic;
signal NextToutErrR7    : std_logic;
-- D-input of ToutErrR0 to ToutErrR7

signal WPErrReg0        : std_logic;
signal WPErrReg1        : std_logic;
signal WPErrReg2        : std_logic;
signal WPErrReg3        : std_logic;
signal WPErrReg4        : std_logic;
signal WPErrReg5        : std_logic;
signal WPErrReg6        : std_logic;
signal WPErrReg7        : std_logic;
-- The WrProtErr storage flag register

signal NextWPErrReg0    : std_logic;
signal NextWPErrReg1    : std_logic;
signal NextWPErrReg2    : std_logic;
signal NextWPErrReg3    : std_logic;
signal NextWPErrReg4    : std_logic;
signal NextWPErrReg5    : std_logic;
signal NextWPErrReg6    : std_logic;
signal NextWPErrReg7    : std_logic;
-- D-input of NextWPErrReg0 to NextWPErrReg7

signal HSizeErrR0       : std_logic;
signal HSizeErrR1       : std_logic;
signal HSizeErrR2       : std_logic;
signal HSizeErrR3       : std_logic;
signal HSizeErrR4       : std_logic;
signal HSizeErrR5       : std_logic;
signal HSizeErrR6       : std_logic;
signal HSizeErrR7       : std_logic;
-- The HSizeErr storage flag register

signal NextHSizeErrR0   : std_logic;
signal NextHSizeErrR1   : std_logic;
signal NextHSizeErrR2   : std_logic;
signal NextHSizeErrR3   : std_logic;
signal NextHSizeErrR4   : std_logic;
signal NextHSizeErrR5   : std_logic;
signal NextHSizeErrR6   : std_logic;
signal NextHSizeErrR7   : std_logic;
-- D-input of NextHSizeErrR0 to NextHSizeErrR7

signal iBufWrOver       : std_logic;
-- Local copy of BufWrOver

signal NextBufWrOver    : std_logic;
-- D-input of BufWrOver

signal HAddrSel         : std_logic_vector(1 downto 0);
-- The lower order of registered address selected, depending on whether transfer
-- is a new transfer or a waited transfer

signal CrntMemWr        : std_logic;
-- This signal indicates the status of the WR transaction in process

signal NextCrntMemWr    : std_logic;
-- D-input of CrntMemWr

signal WtdMemWr         : std_logic;
-- This signal indicates the status of the waited WR transaction

signal NextWtdMemWr     : std_logic;
-- D-input of WtdMemWr

signal BufWrOvStr       : std_logic;
-- The buffer WR completion signal is stored till the MemWrOverCo is asserted

signal NextBufWrOvStr   : std_logic;
-- D-input of BufWrOvStr

signal MemRdTrans       : std_logic;
-- Signal which indicates that the Memory read is in progress

signal NextMemRdTrans   : std_logic;
-- D-input of MemRdTrans

signal WaitStatus       : std_logic;
-- The external wait timeout error status storage flag register.
-- This is a Read-Only register bit and common for all banks.

signal NextWaitStatus   : std_logic;
-- D-input of WaitStatus

signal HBurstCrnt       : std_logic_vector(2 downto 0);
-- The registered HBURST signal related to the current transfer

signal NextHBurstCrnt   : std_logic_vector(2 downto 0);
-- D-input of HBurstCrnt

signal HBurstWtd        : std_logic_vector(2 downto 0);
-- The registered HBURST signal related to the waited transfer

signal NextHBurstWtd    : std_logic_vector(2 downto 0);
-- D-input of HBurstWtd

signal iHBurstReg       : std_logic_vector(2 downto 0);
-- Internal copy of HBurstReg

signal NextHBurstReg    : std_logic_vector(2 downto 0);
-- D-input of HBurstReg

signal iRemapReg        : std_logic;
-- Internal copy of RemapReg

signal HSelSmcD1        : std_logic;
-- One clock delayed version of HSELSMC

signal AhbRdEnStr       : std_logic;
-- Registered version of the AhbRdEn for fast reads from internal buffer

signal NextAhbRdEnStr   : std_logic;
-- D-input of AhbRdEnStr

signal NextAhbRdOver    : std_logic;
-- D-input of AhbRdOver

signal NewTrans         : std_logic;
-- Signal to store a fresh new transfer status to break the zero cycle
-- speculative burst reads. Can be a new RD or a WR transaction.

signal NextNewTrans     : std_logic;
-- D-input of the NewTrans

signal HSizeSel         : std_logic_vector(1 downto 0);
-- One of HSizeCrnt or HSizeWtd is selected, depending on whether transfer
-- is a new transfer or a waited transfer

signal CrntMemWrBa      : std_logic;
-- This is similar to the CrntMemWr but is deasserted one clock cycle
-- earlier so that Bank address is generated properly.

signal NextCrntMemWrBa  : std_logic;
-- D-input of CrntMemWrBa

signal BusyInBM         : std_logic;
-- Detect Busy Insertion during Burst Mode Read transfers

signal NextBusyInBM     : std_logic;
-- D-input of BusyInBM

signal PartWtdWr        : std_logic;
-- Signal indicating partial Write operation with HSIZE < MSIZE

signal NextPartWtdWr    : std_logic;
-- D-input of PartWtdWr

signal BankAddr         : std_logic_vector(2 downto 0);
-- The bank address to be selected depending on whether its a waited transfer
-- or current transfer

signal NextBankAddr     : std_logic_vector(2 downto 0);
-- D-input of BankAddr

signal HSelRegCo        : std_logic; 
-- HSELREG qualified with HREADYIN

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

-- ----------------------------------------------------------------------------
-- Assign the SMC Peripheral ID
--
-- The SMC Peripheral ID is a 32-bit value composed of the
-- following 4 fields:
-- Bits [11:0] -> Part Number used to identify the peripheral
--                For the SMC this is 0x092
-- Bits[19:12] -> Designer ID (ARM)
--                ARM is designated 0x41
-- Bits[23:20] -> Peripheral Revision Number
--                For the SMC this is 0x00
-- Bits[31:24] -> Peripheral Configuration Options
--                For the SMC this is 0x00
--
-- The 32-bits are readable via 4 separate address locations with
-- each location returning 8 valid bits at positions [7:0]. The
-- values returned by the 4 Peripheral ID registers are given below:
--
-- SMCPeriphID0 = 0x92
-- SMCPeriphID1 = 0x10
-- SMCPeriphID2 = 0x04
-- SMCPeriphID3 = 0x00
-- -----------------------------------------------------------------------------
SMCPeriphID0     <= "10010010";
SMCPeriphID1     <= "00010000";
SMCPeriphID2     <= "0100";
SMCPeriphID3     <= "00000000";

-- -----------------------------------------------------------------------------
-- Assign the SMC PrimeCell ID
--
-- SMCPCellID0 = 0x0D
-- SMCPCellID1 = 0xF0
-- SMCPCellID2 = 0x05
-- SMCPCellID3 = 0xB1
-- These PrimeCell ID values should not be changed.
-- -----------------------------------------------------------------------------
SMCPCellID0      <= "00001101";
SMCPCellID1      <= "11110000";
SMCPCellID2      <= "00000101";
SMCPCellID3      <= "10110001";

-- -----------------------------------------------------------------------------
-- Detection of the system reset by the HRESETn input
-- -----------------------------------------------------------------------------
p_HResetDetSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HResetDet1       <= '0';
    HResetDet2       <= '0';
  elsif (HCLK'event and HCLK = '1') then
    HResetDet1       <= '1';
    HResetDet2       <= HResetDet1;
  end if;
end process p_HResetDetSeq;

-- -----------------------------------------------------------------------------
-- NOTE: The SMBCR7(7 downto 6) - the MW bits - are programmed differently
-- because these MW bits are configurable at reset based on the state of the
-- SMMWCS7 input pins. The memory device at this bank is used for the boot
-- code read. If the SMMWCS7 pins are tied to "11", then the MW bits defaults to
-- "00".
-- -----------------------------------------------------------------------------
p_MWconfComb : process (HResetDet1, HResetDet2, SMBCR7WrEn,
                        SMBCR7, HWdataGtd, SMMWCS7, iMWCfgDone, SMRBLECS7)
begin
  NextMWCfgDone          <= iMWCfgDone;
  NextMwPgm              <= '0';
  NextSMBCR7(7 downto 6) <= SMBCR7(7 downto 6);
  NextSMBCR7(0)          <= SMBCR7(0);

  -- The system reset has got completed in the previous clock cycle
  -- and the MW bits of the SMBCR7 reg. are configured based on SMMWCS7 pins
  if (HResetDet1 = '1') and (HResetDet2 = '0') then
    NextMWCfgDone          <= '1';
    NextMwPgm              <= '1';
    NextSMBCR7(0)          <= SMRBLECS7;
    case SMMWCS7 is
      when "00" | "11" =>
        NextSMBCR7(7 downto 6) <= "00";
      when "01" =>
        NextSMBCR7(7 downto 6) <= "01";
      when "10" =>
        NextSMBCR7(7 downto 6) <= "10";
      when others =>
        NextSMBCR7(7 downto 6) <= "00";
    end case;
  elsif (SMBCR7WrEn = '1') then
    NextSMBCR7(7 downto 6) <= HWdataGtd(7 downto 6);
    NextSMBCR7(0)          <= HWdataGtd(0);
  end if;
end process p_MWconfComb;

-- -----------------------------------------------------------------------------
-- Clocked process for storing the MWCfgDone signal
-- -----------------------------------------------------------------------------
p_MWconfSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iMWCfgDone       <= '0';
    iMwPgm           <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iMWCfgDone       <= NextMWCfgDone;
    iMwPgm           <= NextMwPgm;
  end if;
end process p_MWconfSeq;

-- -----------------------------------------------------------------------------
-- Generation of BCR7 WrEn signal for writing MW bits
-- -----------------------------------------------------------------------------
SMBCR7WrEn       <= '1' when ((RegWrEn = '1') and (HAddrReg = HADDR_SMBCR7))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Generation of HSelRegCo qualifying HSELREG with HREADYIN
-- ---------------------------------------------------------------------------
HSelRegCo        <= HSELREG when (HREADYIN = '1') 
                 else
                    HSelREGD1; 

-- -----------------------------------------------------------------------------
-- Delay the control signals for required amount of clocks
-- -----------------------------------------------------------------------------
p_Dly1ClkSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HSelREGD1  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    HSelREGD1  <= HSelRegCo;
  end if;
end process p_Dly1ClkSeq;

-- -----------------------------------------------------------------------------
-- Save power by preventing change in internal data bus and address bus
-- when the device is not selected.
-- -----------------------------------------------------------------------------
HAddrGated       <= HADDR(11 downto 2) when (HSELREG = '1')
                 else
                    ZEROFILL(11 downto 2);

HWdataGtd        <= HWDATA when (HSelREGD1 = '1' and HWriteReg = '1')
                 else
                    ZEROFILL(7 downto 0);

HAddrSel         <= iHAddrCrnt(1 downto 0) when (iMemWrReq = '1')
                 else
                   NextHAddrWtd(1 downto 0) when (iWtdWrReq = '1' and
                                                  (MemWrOver = '1' or
                                                   iMwPgm = '1'))
                 else
                   "00";

HSizeSel         <= HSizeCrnt(1 downto 0) when (iMemWrReq = '1')
                 else
                   NextHSizeWtd(1 downto 0) when (iWtdWrReq = '1' and
                                                  (MemWrOver = '1' or
                                                   iMwPgm = '1'))
                 else
                   "00";

-- -----------------------------------------------------------------------------
-- Logic to determine the completion of writing/storing data into the
-- internal Rd-Wr buffer. It depends on the HSIZE and MSIZE values.
-- It also depends on the WaitEn for the bank. If WaitEn=1 then each
-- WR from the AHB will be processed individually.
-- During a WR transaction if the HSIZE < MSIZE and if there is an IDLE
-- or NSEQ, then the Buffer write is completed. The packets are expected to
-- follow N-S-S sequence and it is broken if an I or N is issued.
-- -----------------------------------------------------------------------------
p_BufWrComb : process (iMemWrReq, MemWrOver, iMSize32, iWtdWrReq, iWaitEn,
                       HTRANS, iMSize16, iMSize08, iMwPgm, HSizeSel, HAddrSel,
                       CrntMemWrBa, BufWrOvStr, PartWtdWr)
begin
  NextBufWrOver    <= '0';

  if ((iMemWrReq = '1' or
       ((CrntMemWrBa = '1' or (PartWtdWr = '1' and MemWrOver = '0')) and
        BufWrOvStr = '0') or
       ((MemWrOver = '1' or iMwPgm = '1') and iWtdWrReq = '1'))
     and
      (HSizeSel = "10" or iWaitEn = '1' or HTRANS(0) = '0' or 
       ((HSizeSel = "01" and
         (iMSize08 = '1' or iMSize16 = '1' or
          (iMSize32 = '1' and HAddrSel(1) = '1')))
       or
        (HSizeSel = "00" and
         (iMSize08 = '1' or
          (iMSize16 = '1' and HAddrSel(0) = '1') or
          (iMSize32 = '1' and HAddrSel = "11")))
       )
      )
     ) then
    NextBufWrOver     <= '1';
  end if;
end process p_BufWrComb;

-- -----------------------------------------------------------------------------
-- Logic for storing the BufWrOver signal in cases when a NS(WR) is followed
-- by B-I-I or I-I-I etc.
-- -----------------------------------------------------------------------------
NextBufWrOvStr   <= '1' when (NextBufWrOver = '1')
                 else
                   '0' when (MemWrOverCo = '1' or WaitToutErr = '1')
                 else
                   BufWrOvStr;

-- -----------------------------------------------------------------------------
-- Logic to generate the signal which is used to bypass the internal buffer
-- -----------------------------------------------------------------------------
BufByPassCo      <= '1' when ((NextHSizeReg = NextMW) and iMWCfgDone = '1')
                 else
                   '0';

-- -----------------------------------------------------------------------------
-- Storing the register WR and RD signals requests which were attempted when
-- the configuration of the MW bits of SMBCR7 is still in progress. The
-- transfers are carried out once the MWCfgDone is asserted
-- -----------------------------------------------------------------------------
NextWtdRegWr     <= '1' when ((HSELREG = '1' and HTRANS(1) = '1' and
                               HREADYIN = '1') and HWRITE = '1' and
                              iMWCfgDone = '0')
                 else
                    '0' when (iMWCfgDone = '1' and WtdRegWr = '1')
                 else
                    WtdRegWr;

NextWtdRegRd     <= '1' when ((HSELREG = '1' and HTRANS(1) = '1' and
                               HREADYIN = '1') and HWRITE = '0' and
                              iMWCfgDone = '0')
                 else
                    '0' when (iMWCfgDone = '1' and WtdRegRd = '1')
                 else
                    WtdRegRd;

NextWtdRegRdEn   <= '1' when (iMWCfgDone = '1' and WtdRegRd = '1')
                 else
                    '0';

NextRegWrEn      <= '1' when ((HSELREG = '1' and HTRANS(1) = '1' and
                               HREADYIN = '1') and HWRITE = '1' and
                              iMWCfgDone = '1')
                 else
                    '0';

NextRegRdEn      <= '1' when ((HSELREG = '1' and HTRANS(1) = '1' and
                               HREADYIN = '1') and HWRITE = '0' and
                              iMWCfgDone = '1')
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Signals used to indicate the status of ongoing current WR or waited WR
-- transactions and the progress of the read transactions
-- CrntMemWrBa status signal is used to prevent the BankAddr from unnecessary
-- toggling. Has the same behaviour as CrntMemWr but gets de-asserted one HCLK
-- early.
-- -----------------------------------------------------------------------------
NextCrntMemWr    <= '1' when (iMemWrReq = '1')
                 else
                   '0' when (MemWrOver = '1' or WaitToutErr = '1')
                 else
                   CrntMemWr;

NextWtdMemWr     <= '1' when (((MemWrOver = '1' and NextBufWrOver = '1') or
                               iMwPgm = '1') and iWtdWrReq = '1')
                 else
                   '0' when (MemWrOver = '1' or WaitToutErr = '1') 
                 else
                   WtdMemWr;

NextMemRdTrans   <= '1' when (iMemRdReq = '1' or
                              ((MemWrOver = '1' or iMwPgm = '1') and
                               iWtdRdReq = '1'))
                 else
                   '0' when (MemRdOver = '1' or WaitToutErr = '1')
                 else
                   MemRdTrans;

NextCrntMemWrBa  <= '1' when (iMemWrReq = '1')
                 else
                   '0' when (MemWrOverCo = '1' or WaitToutErr = '1')
                 else
                    CrntMemWrBa;

NextPartWtdWr    <= '1' when (MemWrOver = '1' and (NextHSizeReg < iMW) and
                              iWtdWrReq = '1' and PartWtdWr = '0')
                 else
                   '0' when ((MemWrOver = '1' and PartWtdWr = '1') or
                             WaitToutErr = '1' or iMemWrReq = '1') 
                 else
                   PartWtdWr;

-- -----------------------------------------------------------------------------
-- Clocked process to register temporary signals and status signals
-- -----------------------------------------------------------------------------
p_TmpStatComb : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegWrEn          <= '0';
    RegRdEn          <= '0';
    WtdRegWr         <= '0';
    WtdRegRd         <= '0';
    WtdRegRdEn       <= '0';
    iBufWrOver       <= '0';
    BufWrOvStr       <= '0';
    CrntMemWr        <= '0';
    CrntMemWrBa      <= '0';
    WtdMemWr         <= '0';
    MemRdTrans       <= '0';
    AhbRdEnStr       <= '0';
    AhbRdOver        <= '0';
    PartWtdWr        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    RegWrEn          <= NextRegWrEn;
    RegRdEn          <= NextRegRdEn;
    WtdRegWr         <= NextWtdRegWr;
    WtdRegRd         <= NextWtdRegRd;
    WtdRegRdEn       <= NextWtdRegRdEn;
    iBufWrOver       <= NextBufWrOver;
    BufWrOvStr       <= NextBufWrOvStr;
    CrntMemWr        <= NextCrntMemWr;
    CrntMemWrBa      <= NextCrntMemWrBa;
    WtdMemWr         <= NextWtdMemWr;
    MemRdTrans       <= NextMemRdTrans;
    AhbRdEnStr       <= NextAhbRdEnStr;
    AhbRdOver        <= NextAhbRdOver;
    PartWtdWr        <= NextPartWtdWr;
  end if;
end process p_TmpStatComb;

-- -----------------------------------------------------------------------------
-- Storing the AhbRdEn signal for the read cases when the HSIZE < MSize and
-- subsequent datas can be given from the internal buffer, RdWrBuf with zero
-- wait cycles and without extra memory accesses
-- -----------------------------------------------------------------------------
p_AhbRdStr : process (AhbRdEnStr, MemRdOver,iHREADYOUTMem, HTRANS, 
                      iHSizeReg, NextMW,SmcAddrReg, HADDR)
begin
  NextAhbRdEnStr   <= AhbRdEnStr;
  NextAhbRdOver    <= '0';

  if (MemRdOver = '1' or AhbRdEnStr = '1') then
    if ((iHREADYOUTMem = '1' ) and HTRANS = T_SEQ) then
      if ((((iHSizeReg = "00" or iHSizeReg = "01") and NextMW = "10") and
           (SmcAddrReg(3 downto 2) = HADDR(3 downto 2))) or
          ((iHSizeReg = "00" and NextMW = "01") and
           (SmcAddrReg(3 downto 1) = HADDR(3 downto 1)))) then
        NextAhbRdEnStr   <= '1';
      else
        NextAhbRdOver    <= '1';
        NextAhbRdEnStr   <= '0';
      end if;
    else
      NextAhbRdOver    <= '1';
      NextAhbRdEnStr   <= '0';
    end if;
  end if;
end process p_AhbRdStr;

-- -----------------------------------------------------------------------------
-- 1. Logic to store the memory write attempt before completion of the current
--    write in progress OR when the MW bits of the SMBCR7 are still being
--    programmed.
--    When the waited write transfer is being serviced [on the completion of the
--    previous write transfer], then the status is stored in the WtdMemWr
--    register. The WtdWrReq signal can then be de-asserted.
-- 2. Logic to store the memory read attempt before completion of the current
--    write in progress OR when the MW bits of the SMBCR7 are still being
--    programmed.
-- The MemRdReq and WtdRdReq will not be generated simultaneously, they are
--    mutually exclusive events.
-- -----------------------------------------------------------------------------
NextWtdWrReq     <= '1' when (((MemWrOver = '0' and
                               (((iMemWrReq = '1' or PartWtdWr = '1' or
                                  CrntMemWr = '1') and
                                 NextBufWrOver = '1') or
                                ((CrntMemWr = '1' or PartWtdWr = '1') and
                                 BufWrOvStr = '1')) and
                               ((HSELSMC = '1' and HREADYIN ='1' and
                                 HTRANS(1) = '1') and HWRITE = '1' and
                                WP = '0'))
                             or
                              ((HSELSMC = '1' and HTRANS(1) = '1' and
                                HREADYIN = '1') and iMWCfgDone = '0' and
                               HWRITE = '1'))
                             and NextHSizeErr = '0'
                             )
                 else
                    '0' when ((NextBufWrOver = '0' and
                               (MemWrOver = '1' and iWtdWrReq = '1')) or
                              WtdMemWr = '1')
                 else
                    iWtdWrReq;

NextWtdRdReq     <= '1' when (((MemWrOver = '0' and
                               (((iMemWrReq = '1' or PartWtdWr = '1' or
                                  CrntMemWr = '1') and
                                 NextBufWrOver = '1') or
                                ((CrntMemWr = '1' or PartWtdWr = '1') and
                                 BufWrOvStr = '1')) and
                               ((HSELSMC = '1' and HREADYIN = '1' and
                                 HTRANS(1) = '1') and HWRITE = '0'))
                             or
                              ((HSELSMC = '1' and HTRANS(1) = '1' and
                                HREADYIN = '1') and iMWCfgDone = '0' and
                               HWRITE = '0'))
                             and NextHSizeErr = '0'
                             )
                 else
                    '0' when (MemRdOver = '1')
                 else
                    iWtdRdReq;

-- -----------------------------------------------------------------------------
-- Register a fresh valid read request
-- 1. MemRdReq : Memory Read request generation.
--    For a NSEQ or SEQ Read transaction from AHB [with SMC selected], the 
--    following conditions are evaluated
--    - A Read request during a Burst Read operation, when the Burst is not
--      broken. Condition checked at the end of current read access.
--    - A Read request is detected, in the condition when previous Reads are
--      completed and followed by a Write request which is given a Zero Wait
--      DONE response and this Write is completed. For the Write Not completed
--      condition, the Read request should be registered as a Waited transaction
--      by enabling WtdRdReq 
--    - A new valid Read request is detected, without any error conditions,
--      after individual Read transactions or when previous Write operation has
--      been completed.
--    The MemRdReq and WtdRdReq will not be generated at the same time, they are
--    mutually exclusive events
-- -----------------------------------------------------------------------------
NextMemRdReq     <= '1' when ((HSELSMC = '1' and HWRITE = '0' and
                               HTRANS(1) = '1' and WaitToutErr = '0') 
                             and
                              ((MemRdOverCo = '1' and NewTrans = '0' and
                                iHREADYOUTMem = '1')
                              or
                               ((MemRdOver = '1' or AhbRdEnStr = '1') and
                                NextAhbRdOver = '1' and
                                (not(iMemWrReq = '1' and NextBufWrOver = '1'))
                                and
                                (not(MemRdOverCo = '1' and NewTrans = '0')))
                              or
                               (HREADYIN = '1' and iMWCfgDone = '1' and
                                WaitToutErr = '0' and NextHSizeErr = '0' and
                                (not((MemRdOver = '1' or AhbRdEnStr = '1') and
                                      NextAhbRdOver = '0')) and
                                (not(MemWrOver = '0' and
                                     (((iMemWrReq = '1' or PartWtdWr = '1' or
                                        CrntMemWr = '1') and
                                       NextBufWrOver = '1') or
                                      ((CrntMemWr = '1' or PartWtdWr = '1') and
                                       BufWrOvStr = '1'))))
                               )
                              )
                             )
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Register a fresh valid write request
-- - At the end of a Read transaction, a Write request is detected to a
--   writable memory. 
-- - When the HSIZE < MSIZE and buffer can collect the data to construct a
--   larger data. 
-- -----------------------------------------------------------------------------
NextMemWrReq     <= '1' when ((MemRdOverCo = '1' and NewTrans = '0' and
                               iHREADYOUTMem = '1' and HSELSMC = '1' and
                               HTRANS(1) = '1' and
                               HWRITE = '1' and WP = '0' and WaitToutErr = '0')
                             or
                              ((HSELSMC = '1' and HTRANS(1) = '1' and
                                HREADYIN = '1') and iMWCfgDone = '1' and
                               HWRITE = '1' and WP = '0' and
                               WaitToutErr = '0' and NextHSizeErr = '0' and 
                               (not(MemWrOver = '0' and
                                    (((iMemWrReq = '1' or PartWtdWr = '1' or
                                       CrntMemWr = '1') and
                                      NextBufWrOver = '1') or
                                     ((CrntMemWr = '1' or PartWtdWr = '1') and
                                      BufWrOvStr = '1'))))))
                 else
                    '0';


-- -----------------------------------------------------------------------------
-- Setting a temporary error signal when a write is attempted to a write
-- protected memory
-- -----------------------------------------------------------------------------
NextWpErrTmp     <= '1' when ((MemWrOver = '0' and
                              ((iMemWrReq = '1' and NextBufWrOver = '1') or
                               ((CrntMemWr = '1' or PartWtdWr = '1') and
                                BufWrOvStr = '1')) and
                              (HSELSMC = '1' and (iHREADYOUTMem = '1' ) and
                               HTRANS(1) = '1' and HWRITE = '1' and
                               WP = '1'))
                             or
                              (MemRdOverCo = '1' and NewTrans = '0' and
                               iHREADYOUTMem = '1' and HSELSMC = '1' and
                               HWRITE = '1' and WP = '1')
                             or
                              ((HSELSMC = '1' and HTRANS(1) = '1' and
                                HREADYIN = '1') and iMWCfgDone = '1' and
                               HWRITE = '1' and WP = '1')
                             )
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Register a fresh NONSEQ read or write transfer which aborts the BM reads
-- with zero wait access time
-- -----------------------------------------------------------------------------
NextNewTrans     <= '1' when (MemRdOverCo = '1' and NewTrans = '0' and
                              (iHREADYOUTMem = '1') and HSELSMC = '1' and
                              HTRANS = T_NONSEQ)
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- During Burst Read transfer when speculative/predictive Reads are performed
-- if there is a BUSY transfer then, speculative/predictive Read operations
-- will be terminated so as to synchronize with the AHB. This signal is used to
-- detect such a condition.
-- -----------------------------------------------------------------------------
NextBusyInBM     <= '1' when (BMRdTrans = '1' and HTRANS = T_BUSY)
                 else
                    '0' when (iMemRdReq = '1' or iMemWrReq = '1') 
                 else
                    BusyInBM;


-- -----------------------------------------------------------------------------
-- Generation of the SMC's response signals
-- This block generates the respone output for the memory transactions.
-- -----------------------------------------------------------------------------
p_MemRespGenComb : process (iHRESPMem, iHREADYOUTMem, WaitToutErr, NextHSizeErr,
                            iMemWrReq, iWtdWrReq, iWtdRdReq, iMWCfgDone,
                            NextWaitEn, HTRANS, HWRITE, HREADYIN, MemWrOver,
                            MemRdOverCo, HSELSMC,  NextBufWrOver, CrntMemWr,
                            BufWrOvStr, MemRdOver, AhbRdEnStr, WP, BusyInBM,
                            NextAhbRdOver, NewTrans, WtdMemWr, MemRdTrans,
                            PartWtdWr)
begin

  NextHRESPMem     <= iHRESPMem;
  NextHREADYOUTMem <= iHREADYOUTMem;

  -- check if the previous cycle was the first cycle of the ERROR response
  -- by looking for the condition when the HRESP drives ERROR and HREADYOUT
  -- is low. If this condition is true then drive HREADYOUT high maintaining
  -- ERROR response. This gives the two cycle ERROR response.
  if (iHRESPMem = H_ERROR and iHREADYOUTMem = '0') then
    NextHREADYOUTMem <= '1';
    NextHRESPMem     <= H_ERROR;

  -- Generate ERROR response when following conditions are satisfied
  -- Check for WaitToutErr condition so as to drive the ERROR
  -- response. If the AHB tries to initiate transfer when the SMWAIT input is
  -- still asserted due to previous transfer, then SMC will keep giving ERROR
  -- response
  elsif (NextHSizeErr = '1' or
         (WaitToutErr = '1' and
          ((HSELSMC = '1' and HTRANS(1) = '1') or
           MemRdTrans = '1' or CrntMemWr = '1' or WtdMemWr = '1'))) then
    NextHREADYOUTMem <= '0';
    NextHRESPMem     <= H_ERROR;


  -- 1. If the master drives either an IDLE or a BUSY, then respond by driving
  --    OKAY/DONE response
  -- 2. During WR transaction due to HSIZE < MSIZE difference, if the internal
  --    RD-WR buffer is not filled with all sub pkts of data then, drive OKAY
  --    response till the buffer is filled and then only one access to memory
  --    is needed to write the data out. For eg. HSIZE = 8 & MSIZE = 32, and
  --    if the 1st address is aligned and the WaitEn = 0, then upto 4 bytes
  --    can be collected into the buffer before flushing out the data.
  --    This check condition caters to the Waited write transfer
  elsif (((HTRANS = T_IDLE or HTRANS = T_BUSY) and HREADYIN = '1') or
         (NextBufWrOver = '0' and (MemWrOver = '1' and iWtdWrReq = '1'))
        ) then
    NextHREADYOUTMem <= '1';
    NextHRESPMem     <= H_OKAY;

  -- if a write or a read transaction is initiated on the bus before the
  -- completion of the ongoing write transfer, then register the request
  -- and insert wait cycles on the AHB. The status of the waited transfer is
  -- stored as waited read or waited write pending request. In case of writes
  -- check is performed to determine if the device is write protected, before
  -- committing to the write operation.
  elsif (MemWrOver = '0' and
         (((iMemWrReq = '1' or PartWtdWr = '1' or CrntMemWr = '1') and
           NextBufWrOver = '1') or
          ((CrntMemWr = '1' or PartWtdWr = '1') and BufWrOvStr = '1')) and
         (HSELSMC = '1' and HTRANS(1) = '1' and HREADYIN = '1')) then
    NextHREADYOUTMem    <= '0';
    if (HWRITE = '1') then
      if (WP = '1') then
        NextHRESPMem     <= H_ERROR;
      else
        NextHRESPMem     <= H_OKAY;
      end if;
    else
      NextHRESPMem      <= H_OKAY;
    end if;

  -- If the external read data from the memory is ready to be given to the
  -- the AHB then generate the enable signal and assert the HREADYOUT with
  -- OKAY response. The transfer was successful for either the initial
  -- read transaction or the waited read transaction.
  -- During BM reads if the Access count = 0 that is WST1/2=0, then data
  -- streams in each cycle. The SmcCore would already have started the
  -- subsequent reads in advance and as read finishes in 1 clock, it is
  -- important to check when the burst is terminated or gets aborted. These
  -- checking basically for the a new NONSEQ read or a new write is done
  -- before giving out the next DONE response {by driving HREADYOUT=1}
  -- The new read or write transfers requests are registered appropriately
  elsif (MemRdOverCo = '1' and NewTrans = '0') then
   NextHREADYOUTMem <= '1';
   NextHRESPMem     <= H_OKAY;
     if (HREADYIN = '1' and HSELSMC = '1') then
      if (HWRITE = '0' and (HTRANS = T_NONSEQ or BusyInBM = '1')) then
       NextHREADYOUTMem <= '0';
      elsif (HWRITE = '1') then
        if (WP = '1') then
          NextHREADYOUTMem <= '0';
          NextHRESPMem     <= H_ERROR;
        else
              NextHRESPMem     <= H_OKAY;
          if (NextWaitEn = '1') then
            NextHREADYOUTMem <= '0';
          end if;
       end if;
      end if;
   end if;

  -- In the case of read transfer when the HSIZE < MSize, one memory access
  -- can fetch more data than required by the current transfer. In this
  -- scenario, if the next sequential AHB address falls in the address space
  -- of the larger data held by the internal buffer, then the data is returned
  -- with zero wait cycles to the AHB from the buffer itself and no extra
  -- memory accesses are required.
  elsif ((MemRdOver = '1' or AhbRdEnStr = '1') and HWRITE = '0' and
       HSELSMC = '1' ) then
    NextHRESPMem     <= H_OKAY;
    if (NextAhbRdOver = '1') then
      NextHREADYOUTMem <= '0';
    else
      NextHREADYOUTMem <= '1';
    end if;

  -- If the external memory device is being targeted with a NONSEQ or SEQ,
  -- then check if the MW bits programming of the SMBCR7 is complete. If the
  -- programming is not complete, store requests as pending requests and insert
  -- waits on AHB. If the programming is complete then
  -- * if it is a write transfer then check if the WP bit is
  -- active. If write protect bit is asserted, then drive ERROR response.
  -- If WP bit is inactive then register the write request. If the WaitEn
  -- is '0' then for this first write request drive OKAY response, otherwise
  -- drive waits on the AHB (so that SMC has a chance to flag error due
  -- to Wait Time out).
  -- * if it is a read transfer, then register the request and drive waits
  -- on the AHB.
  elsif (HSELSMC = '1' and HTRANS(1) = '1' and HREADYIN = '1') then
    if (iMWCfgDone = '1') then
      if (HWRITE = '1') then
        if (WP = '1') then
          NextHREADYOUTMem <= '0';
          NextHRESPMem     <= H_ERROR;
        else
          NextHRESPMem     <= H_OKAY;
          if (NextWaitEn = '1') then
            NextHREADYOUTMem <= '0';
          end if;
        end if;
      else
        NextHREADYOUTMem <= '0';
        NextHRESPMem     <= H_OKAY;
      end if;
    else
      NextHREADYOUTMem <= '0';
      NextHRESPMem     <= H_OKAY;
    end if;

  -- 1. If the error response was already generated in the previous cycle and
  --    there are no more transfers performed, then OKAY response is driven
  -- 2. If the ongoing external WR to the memory device is complete then drive
  --    OKAY response. This is for the cases when each WR is completed
  --    individually, when WaitEn=1 and in case of WtdWrReq=1.
  elsif ((iHRESPMem = H_ERROR and iHREADYOUTMem = '1') or
         (MemWrOver = '1' and
          ((CrntMemWr = '1' and (iWtdWrReq = '0' and iWtdRdReq = '0')) or
           WtdMemWr = '1'))) then
    NextHREADYOUTMem <= '1';
    NextHRESPMem     <= H_OKAY;
  end if;
end process p_MemRespGenComb;

-- ----------------------------------------------------------------------------
-- This block generates the respone output for the register transactions.
-- 1. Wait for one cycle before driving the OKAY/DONE response. This is used
--    after any internal register WR, so that the parameters get updated
--    in the register, before using them.
-- 2. If the internal registers are being targeted for a write or read with
--    a NONSEQ or SEQ transfer, then
--    check if the MW bits programming of the SMBCR7 is complete. If the
--    programming is not complete, register the request and insert waits on AHB.
--    This request will be serviced after the programming is complete.
--    If the programming is already complete, then give an OKAY response and
--    enable the register access.
-- 3. On the completion of the configuration of the MW bits after reset, the
--    pending read or write transfers to the registers are completed
-- ---------------------------------------------------------------------------
p_RegRespGenComb : process (iMWCfgDone, Wait1Cyc,HTRANS, HWRITE, HREADYIN,
                            HSELREG, iHRESPReg, iHREADYOUTReg, WtdRegWr,
                            WtdRegRd)
begin

  NextHRESPReg     <= iHRESPReg;
  NextHREADYOUTReg <= iHREADYOUTReg;
  NextWait1Cyc     <= Wait1Cyc;

  if (Wait1Cyc = '1' 
     or 
      ((HTRANS = T_IDLE or HTRANS = T_BUSY) and HREADYIN = '1')) then
    NextHRESPReg     <= H_OKAY;
    NextHREADYOUTReg <= '1';
    NextWait1Cyc     <= '0';

  elsif (HSELREG = '1' and HTRANS(1) = '1' and HREADYIN = '1') then
    NextHRESPReg    <= H_OKAY;
    if (iMWCfgDone = '1') then
      if (HWRITE = '1') then
        NextWait1Cyc     <= '1';
        NextHREADYOUTReg <= '0';
      else
        NextHREADYOUTReg <= '1';
      end if;
    else
      NextHREADYOUTReg <= '0';
    end if;

  elsif (iMWCfgDone = '1' and (WtdRegWr = '1' or WtdRegRd = '1')) then
    NextHREADYOUTReg <= '1';
    NextHRESPReg     <= H_OKAY;

  end if;
end process p_RegRespGenComb;

-- ---------------------------------------------------------------------------
-- Multiplexer which selects either the memory respone or the register response
-- depending on HSelSmcD1 and HSelREGD1.
-- 1. When HSelSmcD1 is 1, if waited register write transaction is going
--    on then register response is driven else the memory response is routed.
-- 2. When HSelSmcD1 is 0, if some memory transaction is going on 
--    (read or write) the memory response is routed else if HSelREGD1 is 1
--    then register respone is routed, otherwise if none of memory or register
--    is selected for transaction, HREADYOUT is asserted and OKAY response
--    is driven.
-- ----------------------------------------------------------------------------
p_RespSelComb : process (iHREADYOUTReg, iHRESPReg, iHREADYOUTMem,
                         iHRESPMem, CrntMemWr, MemRdTrans, WtdMemWr, WtdRegWr,
                         HSelSmcD1, HSelREGD1, iWtdRdReq, iWtdWrReq, WtdRegRd)
begin
  case (HSelSmcD1) is
    when '1' =>
      if (WtdRegWr = '1' or WtdRegRd = '1') then
        HREADYOUT          <= iHREADYOUTReg;
        HRESP              <= iHRESPReg;
      else
        HREADYOUT          <= iHREADYOUTMem;
        HRESP              <= iHRESPMem;
      end if;

    when '0' =>
      if ((CrntMemWr = '1' and HSelREGD1 = '0') or MemRdTrans = '1' or
           WtdMemWr = '1' or iHRESPMem = H_ERROR or iWtdRdReq = '1' or
           iWtdWrReq = '1') then 
        HREADYOUT          <= iHREADYOUTMem;
        HRESP              <= iHRESPMem;
      elsif (HSelREGD1 = '1') then
        HREADYOUT          <= iHREADYOUTReg;
        HRESP              <= iHRESPReg;
      else
        HREADYOUT          <= '1';
        HRESP              <= H_OKAY;
      end if;

    when others =>
      HREADYOUT          <= '1';
      HRESP              <= H_OKAY;
  end case;
end process p_RespSelComb;

-- -----------------------------------------------------------------------------
-- Clocked process to register the response & control signals
-- -----------------------------------------------------------------------------
p_RespGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHRESPReg        <= H_OKAY;
    iHREADYOUTReg    <= '1';
    iHRESPMem        <= H_OKAY;
    iHREADYOUTMem    <= '1';
    iMemWrReq        <= '0';
    iMemRdReq        <= '0';
    iWtdWrReq        <= '0';
    iWtdRdReq        <= '0';
    Wait1Cyc         <= '0';
    AddrContStr      <= '0';
    NewTrans         <= '0';
    BusyInBM         <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iHRESPReg        <= NextHRESPReg;
    iHREADYOUTReg    <= NextHREADYOUTReg;
    iHRESPMem        <= NextHRESPMem;
    iHREADYOUTMem    <= NextHREADYOUTMem;
    iMemWrReq        <= NextMemWrReq;
    iMemRdReq        <= NextMemRdReq;
    iWtdWrReq        <= NextWtdWrReq;
    iWtdRdReq        <= NextWtdRdReq;
    Wait1Cyc         <= NextWait1Cyc;
    AddrContStr      <= NxtAddrContStr;
    NewTrans         <= NextNewTrans;
    BusyInBM         <= NextBusyInBM;
  end if;
end process p_RespGenSeq;

-- -----------------------------------------------------------------------------
-- This signal is generated to store the address and controls for
-- waited/pending write or read transfer
-- -----------------------------------------------------------------------------
NxtAddrContStr   <= '1' when (NextHSizeErr = '0' and HSELSMC = '1' and
                              HTRANS(1) = '1' and HREADYIN = '1' and
                              ((MemWrOver = '0' and
                                (((iMemWrReq = '1' or PartWtdWr = '1' or
                                   CrntMemWr = '1') and
                                  NextBufWrOver = '1') or
                                 ((CrntMemWr = '1' or PartWtdWr = '1') and
                                  BufWrOvStr = '1')) and
                                ((HWRITE = '1' and WP = '0') or
                                 HWRITE = '0')) or
                               iMWCfgDone = '0'))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- In the CLK when a new memory/SMC transfer is requested, register all the
-- AHB control signals and the address for the current transfer.
-- -----------------------------------------------------------------------------
p_StrHaContComb : process (iHAddrCrnt, HSELSMC, HREADYIN, HADDR, HTransCrnt,
                           HTRANS, HSizeCrnt, HSIZE, HBurstCrnt, HBURST)
begin
  NextHAddrCrnt    <= iHAddrCrnt;
  NextHTransCrnt   <= HTransCrnt;
  NextHSizeCrnt    <= HSizeCrnt;
  NextHBurstCrnt   <= HBurstCrnt;

  if (HSELSMC = '1' and HREADYIN = '1') then
    NextHAddrCrnt    <= HADDR;
    NextHTransCrnt   <= HTRANS;
    NextHSizeCrnt    <= HSIZE(1 downto 0);
    NextHBurstCrnt   <= HBURST;
  end if;
end process p_StrHaContComb;

-- -----------------------------------------------------------------------------
-- Store the address and controls of the next Write or a Read transfer which
-- is requested before the completion of the current write.
-- [For the first write transfer the HREADY
-- is given immediately making use of the internal buffer, in the non-SMWAIT
-- controlled mode]
-- -----------------------------------------------------------------------------
p_WtdHaContComb : process (iHAddrWtd, AddrContStr, BnkAddWtd, iHAddrCrnt,
                           HTransCrnt, HSizeCrnt, HTransWtd, HSizeWtd,
                           HBurstWtd, HBurstCrnt)
begin
  NextHAddrWtd     <= iHAddrWtd;
  NextHTransWtd    <= HTransWtd;
  NextHSizeWtd     <= HSizeWtd;
  NextHBurstWtd    <= HBurstWtd;
  NextBnkAddWtd    <= BnkAddWtd;

  if (AddrContStr = '1') then
    NextHAddrWtd     <= iHAddrCrnt(25 downto 0);
    NextHTransWtd    <= HTransCrnt;
    NextHSizeWtd     <= HSizeCrnt;
    NextHBurstWtd    <= HBurstCrnt;
    NextBnkAddWtd    <= iHAddrCrnt(28 downto 26);
  end if;
end process p_WtdHaContComb;

-- -----------------------------------------------------------------------------
-- The relevant HTRANS, HSIZE and HBURST control informations are routed
-- The Bank address is generated for a valid transfer to memory
-- -----------------------------------------------------------------------------
p_ContSelComb : process (iHTransReg, iHSizeReg, iHBurstReg, iMemWrReq,
                         iMemRdReq, HTransCrnt, HSizeCrnt,
                         HBurstCrnt, MemWrOver, iMwPgm, iWtdWrReq, iWtdRdReq,
                         NextHTransWtd, NextHSizeWtd, NextHBurstWtd,
                         iBnkAddStr, iHAddrCrnt, NextBnkAddWtd)
begin
  NextHTransReg    <= iHTransReg;
  NextHSizeReg     <= iHSizeReg;
  NextHBurstReg    <= iHBurstReg;
  NextBnkAddStr    <= iBnkAddStr;

  if (iMemWrReq = '1' or iMemRdReq = '1') then
    NextHTransReg    <= HTransCrnt;
    NextHSizeReg     <= HSizeCrnt;
    NextHBurstReg    <= HBurstCrnt;
    NextBnkAddStr    <= iHAddrCrnt(28 downto 26);
  elsif ((MemWrOver = '1' or iMwPgm = '1') and
         (iWtdRdReq = '1' or iWtdWrReq = '1')) then
    NextHTransReg    <= NextHTransWtd;
    NextHSizeReg     <= NextHSizeWtd;
    NextHBurstReg    <= NextHBurstWtd;
    NextBnkAddStr    <= NextBnkAddWtd;
  end if;
end process p_ContSelComb;

-- -----------------------------------------------------------------------------
-- Check performed to ascertain if subsequent bank addresses are same
-- -----------------------------------------------------------------------------
p_BnkCmpComb : process (iMemRdReq, iBnkAddStr, iHAddrCrnt, MemWrOver,
                        iWtdWrReq)
begin
  BankCmpCo    <= '0';

  if (iMemRdReq = '1') then
    if (iBnkAddStr = iHAddrCrnt(28 downto 26)) then
      BankCmpCo        <= '1';
    end if;
  elsif (MemWrOver = '1' and iWtdWrReq = '1') then
    if (iBnkAddStr = iHAddrCrnt(28 downto 26)) then
      BankCmpCo        <= '1';
    end if;
  end if;
end process p_BnkCmpComb;

-- -----------------------------------------------------------------------------
-- Store the AHB input control signals - combinational process
-- -----------------------------------------------------------------------------
p_StrAhbContComb : process (HWRITE, HSELREG, HREADYIN, HWriteReg,
                            IntHSelReg, HAddrGated, HAddrReg)
begin
  NextHWriteReg    <= HWriteReg;
  NextIntHSelReg   <= IntHSelReg;
  NextHAddrReg     <= HAddrReg;

  if (HREADYIN = '1' and HSELREG = '1') then
    NextHWriteReg    <= HWRITE;
    NextIntHSelReg   <= HSELREG;
    NextHAddrReg     <= HAddrGated;
  end if;
end process p_StrAhbContComb;

-- -----------------------------------------------------------------------------
-- Store the AHB input control signals - clocked process
-- -----------------------------------------------------------------------------
p_StrAhbContSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HTransCrnt       <= (others => '0');
    HTransWtd        <= (others => '0');
    iHTransReg       <= (others => '0');
    HWriteReg        <= '0';
    IntHSelReg       <= '0';
    HSizeCrnt        <= (others => '0');
    HSizeWtd         <= (others => '0');
    iHSizeReg        <= (others => '0');
    iHAddrCrnt       <= (others => '0');
    iHAddrWtd        <= (others => '0');
    HAddrReg         <= (others => '0');
    BnkAddWtd        <= (others => '0');
    iBnkAddStr       <= (others => '0');
    HBurstCrnt       <= (others => '0');
    HBurstWtd        <= (others => '0');
    iHBurstReg       <= (others => '0');
    WpErrTmp         <= '0';
    HSizeErr         <= '0';
  elsif (HCLK'event and HCLK = '1') then
    HTransCrnt       <= NextHTransCrnt;
    HTransWtd        <= NextHTransWtd;
    iHTransReg       <= NextHTransReg;
    HWriteReg        <= NextHWriteReg;
    IntHSelReg       <= NextIntHSelReg;
    HSizeCrnt        <= NextHSizeCrnt;
    HSizeWtd         <= NextHSizeWtd;
    iHSizeReg        <= NextHSizeReg;
    iHAddrCrnt       <= NextHAddrCrnt;
    iHAddrWtd        <= NextHAddrWtd;
    HAddrReg         <= NextHAddrReg;
    BnkAddWtd        <= NextBnkAddWtd;
    iBnkAddStr       <= NextBnkAddStr;
    HBurstCrnt       <= NextHBurstCrnt;
    HBurstWtd        <= NextHBurstWtd;
    iHBurstReg       <= NextHBurstReg;
    WpErrTmp         <= NextWpErrTmp;
    HSizeErr         <= NextHSizeErr;
  end if;
end process p_StrAhbContSeq;

-- -----------------------------------------------------------------------------
-- HSIZE error detection logic.
-- 1. The external memory transfer size cannot be greater than 32-bits
-- 2. For the internal registers, only 32-bit transfer size is allowed
-- -----------------------------------------------------------------------------
NextHSizeErr     <= '1' when (HREADYIN = '1' and
                              ((HSELSMC = '1' and
                               ((HSIZE(2) = '1') or (HSIZE(1 downto 0) = "11")))
                              )
                             )
                else
                   '0';

-- -----------------------------------------------------------------------------
-- Read Data Output Multiplexer
-- -----------------------------------------------------------------------------
p_AhbRdComb : process (RegRdEn, HAddrReg, SMBIDCYR0, SMBWST1R0, SMBWST2R0,
                       SMBWSTOENR0, SMBWSTWENR0, SMBCR0,
                       SMBIDCYR1, SMBWST1R1, SMBWST2R1, SMBWSTOENR1,
                       SMBWSTWENR1, SMBCR1, SMBIDCYR2, SMBWST1R2,
                       SMBWST2R2, SMBWSTOENR2, SMBWSTWENR2, SMBCR2,
                       SMBIDCYR3, SMBWST1R3, SMBWST2R3,
                       SMBWSTOENR3,SMBWSTWENR3, SMBCR3,
                       SMBIDCYR4, SMBWST1R4, SMBWST2R4, SMBWSTOENR4,
                       SMBWSTWENR4, SMBCR4, SMBIDCYR5, SMBWST1R5,
                       SMBWST2R5, SMBWSTOENR5, SMBWSTWENR5, SMBCR5,
                       SMBIDCYR6, SMBWST1R6, SMBWST2R6,
                       SMBWSTOENR6, SMBWSTWENR6, SMBCR6,
                       SMBIDCYR7, SMBWST1R7, SMBWST2R7, SMBWSTOENR7,
                       SMBWSTWENR7, SMBCR7,
                       SMCPeriphID0, SMCPeriphID1, SMCPeriphID2,
                       SMCPeriphID3, SMCPCellID0, SMCPCellID1,
                       SMCPCellID2, SMCPCellID3, RdWrBuf,
                       ToutErrR0, ToutErrR1, ToutErrR2, ToutErrR3,
                       ToutErrR4, ToutErrR5, ToutErrR6, ToutErrR7,
                       HSizeErrR0, HSizeErrR1, HSizeErrR2, HSizeErrR3,
                       HSizeErrR4, HSizeErrR5, HSizeErrR6, HSizeErrR7,
                       WPErrReg0, WPErrReg1, WPErrReg2, WPErrReg3,
                       WPErrReg4, WPErrReg5, WPErrReg6, WPErrReg7, WtdRegRdEn,
                       WaitStatus, Revision, MemRdOver, AhbRdEnStr)
begin
  HRDATA <= ZEROFILL;

  if (RegRdEn = '1' or WtdRegRdEn = '1') then
    case HAddrReg is
      when HADDR_SMBIDCYR0    => HRDATA(3 downto 0) <= SMBIDCYR0;

      when HADDR_SMBWST1R0    => HRDATA(4 downto 0) <= SMBWST1R0;

      when HADDR_SMBWST2R0    => HRDATA(4 downto 0) <= SMBWST2R0;

      when HADDR_SMBWSTOENR0  => HRDATA(3 downto 0) <= SMBWSTOENR0;

      when HADDR_SMBWSTWENR0  => HRDATA(3 downto 0) <= SMBWSTWENR0;

      when HADDR_SMBCR0       => HRDATA(7 downto 0) <= SMBCR0;

      when HADDR_SMBSR0       =>
        HRDATA(2 downto 0) <= ToutErrR0 & WPErrReg0 & HSizeErrR0;

      when HADDR_SMBIDCYR1    => HRDATA(3 downto 0) <= SMBIDCYR1;

      when HADDR_SMBWST1R1    => HRDATA(4 downto 0) <= SMBWST1R1;

      when HADDR_SMBWST2R1    => HRDATA(4 downto 0) <= SMBWST2R1;

      when HADDR_SMBWSTOENR1  => HRDATA(3 downto 0) <= SMBWSTOENR1;

      when HADDR_SMBWSTWENR1  => HRDATA(3 downto 0) <= SMBWSTWENR1;

      when HADDR_SMBCR1       => HRDATA(7 downto 0) <= SMBCR1;

      when HADDR_SMBSR1       =>
        HRDATA(2 downto 0) <= ToutErrR1 & WPErrReg1 & HSizeErrR1;

      when HADDR_SMBIDCYR2    => HRDATA(3 downto 0) <= SMBIDCYR2;

      when HADDR_SMBWST1R2    => HRDATA(4 downto 0) <= SMBWST1R2;

      when HADDR_SMBWST2R2    => HRDATA(4 downto 0) <= SMBWST2R2;

      when HADDR_SMBWSTOENR2  => HRDATA(3 downto 0) <= SMBWSTOENR2;

      when HADDR_SMBWSTWENR2  => HRDATA(3 downto 0) <= SMBWSTWENR2;

      when HADDR_SMBCR2       => HRDATA(7 downto 0) <= SMBCR2;

      when HADDR_SMBSR2       =>
        HRDATA(2 downto 0) <= ToutErrR2 & WPErrReg2 & HSizeErrR2;

      when HADDR_SMBIDCYR3    => HRDATA(3 downto 0) <= SMBIDCYR3;

      when HADDR_SMBWST1R3    => HRDATA(4 downto 0) <= SMBWST1R3;

      when HADDR_SMBWST2R3    => HRDATA(4 downto 0) <= SMBWST2R3;

      when HADDR_SMBWSTOENR3  => HRDATA(3 downto 0) <= SMBWSTOENR3;

      when HADDR_SMBWSTWENR3  => HRDATA(3 downto 0) <= SMBWSTWENR3;

      when HADDR_SMBCR3       => HRDATA(7 downto 0) <= SMBCR3;

      when HADDR_SMBSR3       =>
        HRDATA(2 downto 0) <= ToutErrR3 & WPErrReg3 & HSizeErrR3;

      when HADDR_SMBIDCYR4    => HRDATA(3 downto 0) <= SMBIDCYR4;

      when HADDR_SMBWST1R4    => HRDATA(4 downto 0) <= SMBWST1R4;

      when HADDR_SMBWST2R4    => HRDATA(4 downto 0) <= SMBWST2R4;

      when HADDR_SMBWSTOENR4  => HRDATA(3 downto 0) <= SMBWSTOENR4;

      when HADDR_SMBWSTWENR4  => HRDATA(3 downto 0) <= SMBWSTWENR4;

      when HADDR_SMBCR4       => HRDATA(7 downto 0) <= SMBCR4;

      when HADDR_SMBSR4       =>
        HRDATA(2 downto 0) <= ToutErrR4 & WPErrReg4 & HSizeErrR4;

      when HADDR_SMBIDCYR5    => HRDATA(3 downto 0) <= SMBIDCYR5;

      when HADDR_SMBWST1R5    => HRDATA(4 downto 0) <= SMBWST1R5;

      when HADDR_SMBWST2R5    => HRDATA(4 downto 0) <= SMBWST2R5;

      when HADDR_SMBWSTOENR5  => HRDATA(3 downto 0) <= SMBWSTOENR5;

      when HADDR_SMBWSTWENR5  => HRDATA(3 downto 0) <= SMBWSTWENR5;

      when HADDR_SMBCR5       => HRDATA(7 downto 0) <= SMBCR5;

      when HADDR_SMBSR5       =>
        HRDATA(2 downto 0) <= ToutErrR5 & WPErrReg5 & HSizeErrR5;

      when HADDR_SMBIDCYR6    => HRDATA(3 downto 0) <= SMBIDCYR6;

      when HADDR_SMBWST1R6    => HRDATA(4 downto 0) <= SMBWST1R6;

      when HADDR_SMBWST2R6    => HRDATA(4 downto 0) <= SMBWST2R6;

      when HADDR_SMBWSTOENR6  => HRDATA(3 downto 0) <= SMBWSTOENR6;

      when HADDR_SMBWSTWENR6  => HRDATA(3 downto 0) <= SMBWSTWENR6;

      when HADDR_SMBCR6       => HRDATA(7 downto 0) <= SMBCR6;

      when HADDR_SMBSR6       =>
        HRDATA(2 downto 0) <= ToutErrR6 & WPErrReg6 & HSizeErrR6;

      when HADDR_SMBIDCYR7    => HRDATA(3 downto 0) <= SMBIDCYR7;

      when HADDR_SMBWST1R7    => HRDATA(4 downto 0) <= SMBWST1R7;

      when HADDR_SMBWST2R7    => HRDATA(4 downto 0) <= SMBWST2R7;

      when HADDR_SMBWSTOENR7  => HRDATA(3 downto 0) <= SMBWSTOENR7;

      when HADDR_SMBWSTWENR7  => HRDATA(3 downto 0) <= SMBWSTWENR7;

      when HADDR_SMBCR7       => HRDATA(7 downto 0) <= SMBCR7;

      when HADDR_SMBSR7       =>
        HRDATA(2 downto 0) <= ToutErrR7 & WPErrReg7 & HSizeErrR7;

      when HADDR_SMBEWS       => HRDATA(0) <= WaitStatus;

      when HADDR_SMCPeriphID0 => HRDATA(7 downto 0) <= SMCPeriphID0;

      when HADDR_SMCPeriphID1 => HRDATA(7 downto 0) <= SMCPeriphID1;

      when HADDR_SMCPeriphID2 => HRDATA(7 downto 0) <= Revision & SMCPeriphID2;

      when HADDR_SMCPeriphID3 => HRDATA(7 downto 0) <= SMCPeriphID3;

      when HADDR_SMCPCellID0  => HRDATA(7 downto 0) <= SMCPCellID0;

      when HADDR_SMCPCellID1  => HRDATA(7 downto 0) <= SMCPCellID1;

      when HADDR_SMCPCellID2  => HRDATA(7 downto 0) <= SMCPCellID2;

      when HADDR_SMCPCellID3  => HRDATA(7 downto 0) <= SMCPCellID3;

      when others             => HRDATA <= (others => '0');
    end case;

  elsif (MemRdOver = '1' or AhbRdEnStr = '1') then
    HRDATA      <= RdWrBuf;
  else
    HRDATA      <= ZEROFILL;
  end if;
end process p_AhbRdComb;

-- -----------------------------------------------------------------------------
-- logic for associating the errors generated to the particular bank
-- -----------------------------------------------------------------------------
p_BSRerrComb : process (iBnkAddStr, WaitToutErr, WaitStatus)
begin
  ToutErrGen0      <= '0';
  ToutErrGen1      <= '0';
  ToutErrGen2      <= '0';
  ToutErrGen3      <= '0';
  ToutErrGen4      <= '0';
  ToutErrGen5      <= '0';
  ToutErrGen6      <= '0';
  ToutErrGen7      <= '0';
  NextWaitStatus   <= WaitStatus;

  case iBnkAddStr is
    when "000" =>
      ToutErrGen0     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "001" =>
      ToutErrGen1     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "010" =>
      ToutErrGen2     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "011" =>
      ToutErrGen3     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "100" =>
      ToutErrGen4     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "101" =>
      ToutErrGen5     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "110" =>
      ToutErrGen6     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when "111" =>
      ToutErrGen7     <= WaitToutErr;
      NextWaitStatus  <= WaitToutErr;
    when others =>
      null;
  end case;
end process p_BSRerrComb;

-- -----------------------------------------------------------------------------
-- Delay the control signals for required amount of clocks
-- -----------------------------------------------------------------------------
p_HSelDly1ClkSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HSelSmcD1  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    HSelSmcD1  <= HSELSMC;
  end if;
end process p_HSelDly1ClkSeq;

-- -----------------------------------------------------------------------------
-- logic for associating the Write protect errors generated to the
-- particular bank
-- -----------------------------------------------------------------------------
p_WPerrComb : process (WpErrTmp, HSelSmcD1, HSizeErr, iHAddrCrnt)
begin
  WPErrGen0        <= '0';
  HSizeErrGen0     <= '0';
  WPErrGen1        <= '0';
  HSizeErrGen1     <= '0';
  WPErrGen2        <= '0';
  HSizeErrGen2     <= '0';
  WPErrGen3        <= '0';
  HSizeErrGen3     <= '0';
  WPErrGen4        <= '0';
  HSizeErrGen4     <= '0';
  WPErrGen5        <= '0';
  HSizeErrGen5     <= '0';
  WPErrGen6        <= '0';
  HSizeErrGen6     <= '0';
  WPErrGen7        <= '0';
  HSizeErrGen7     <= '0';

  if (HSelSmcD1 = '1') then
    case iHAddrCrnt(28 downto 26) is
      when "000" =>
        WPErrGen0       <= WpErrTmp;
        HSizeErrGen0    <= HSizeErr;
      when "001" =>
        WPErrGen1       <= WpErrTmp;
        HSizeErrGen1    <= HSizeErr;
      when "010" =>
        WPErrGen2       <= WpErrTmp;
        HSizeErrGen2    <= HSizeErr;
      when "011" =>
        WPErrGen3       <= WpErrTmp;
        HSizeErrGen3    <= HSizeErr;
      when "100" =>
        WPErrGen4       <= WpErrTmp;
        HSizeErrGen4    <= HSizeErr;
      when "101" =>
        WPErrGen5       <= WpErrTmp;
        HSizeErrGen5    <= HSizeErr;
      when "110" =>
        WPErrGen6       <= WpErrTmp;
        HSizeErrGen6    <= HSizeErr;
      when "111" =>
        WPErrGen7       <= WpErrTmp;
        HSizeErrGen7    <= HSizeErr;
      when others =>
        null;
    end case;
  end if;
end process p_WPerrComb;

-- -----------------------------------------------------------------------------
-- Write Data Output Multiplexer
-- -----------------------------------------------------------------------------
p_RegWrComb : process (RegWrEn, HAddrReg, SMBIDCYR0, SMBWST1R0, SMBWST2R0,
                       SMBWSTOENR0, SMBWSTWENR0, SMBCR0,
                       SMBIDCYR1, SMBWST1R1, SMBWST2R1, SMBWSTOENR1,
                       SMBWSTWENR1, SMBCR1, SMBIDCYR2, SMBWST1R2,
                       SMBWST2R2, SMBWSTOENR2, SMBWSTWENR2, SMBCR2,
                       SMBIDCYR3, SMBWST1R3, SMBWST2R3,
                       SMBWSTOENR3,SMBWSTWENR3, SMBCR3,
                       SMBIDCYR4, SMBWST1R4, SMBWST2R4, SMBWSTOENR4,
                       SMBWSTWENR4, SMBCR4, SMBIDCYR5, SMBWST1R5,
                       SMBWST2R5, SMBWSTOENR5, SMBWSTWENR5, SMBCR5,
                       SMBIDCYR6, SMBWST1R6, SMBWST2R6,
                       SMBWSTOENR6, SMBWSTWENR6, SMBCR6,
                       SMBIDCYR7, SMBWST1R7, SMBWST2R7, SMBWSTOENR7,
                       SMBWSTWENR7, SMBCR7, HWdataGtd, iMWCfgDone, WtdRegWr)
begin
  NextSMBIDCYR0    <= SMBIDCYR0;
  NextSMBWST1R0    <= SMBWST1R0;
  NextSMBWST2R0    <= SMBWST2R0;
  NextSMBWSTOENR0  <= SMBWSTOENR0;
  NextSMBWSTWENR0  <= SMBWSTWENR0;
  NextSMBCR0       <= SMBCR0;
  NextSMBIDCYR1    <= SMBIDCYR1;
  NextSMBWST1R1    <= SMBWST1R1;
  NextSMBWST2R1    <= SMBWST2R1;
  NextSMBWSTOENR1  <= SMBWSTOENR1;
  NextSMBWSTWENR1  <= SMBWSTWENR1;
  NextSMBCR1       <= SMBCR1;
  NextSMBIDCYR2    <= SMBIDCYR2;
  NextSMBWST1R2    <= SMBWST1R2;
  NextSMBWST2R2    <= SMBWST2R2;
  NextSMBWSTOENR2  <= SMBWSTOENR2;
  NextSMBWSTWENR2  <= SMBWSTWENR2;
  NextSMBCR2       <= SMBCR2;
  NextSMBIDCYR3    <= SMBIDCYR3;
  NextSMBWST1R3    <= SMBWST1R3;
  NextSMBWST2R3    <= SMBWST2R3;
  NextSMBWSTOENR3  <= SMBWSTOENR3;
  NextSMBWSTWENR3  <= SMBWSTWENR3;
  NextSMBCR3       <= SMBCR3;
  NextSMBIDCYR4    <= SMBIDCYR4;
  NextSMBWST1R4    <= SMBWST1R4;
  NextSMBWST2R4    <= SMBWST2R4;
  NextSMBWSTOENR4  <= SMBWSTOENR4;
  NextSMBWSTWENR4  <= SMBWSTWENR4;
  NextSMBCR4       <= SMBCR4;
  NextSMBIDCYR5    <= SMBIDCYR5;
  NextSMBWST1R5    <= SMBWST1R5;
  NextSMBWST2R5    <= SMBWST2R5;
  NextSMBWSTOENR5  <= SMBWSTOENR5;
  NextSMBWSTWENR5  <= SMBWSTWENR5;
  NextSMBCR5       <= SMBCR5;
  NextSMBIDCYR6    <= SMBIDCYR6;
  NextSMBWST1R6    <= SMBWST1R6;
  NextSMBWST2R6    <= SMBWST2R6;
  NextSMBWSTOENR6  <= SMBWSTOENR6;
  NextSMBWSTWENR6  <= SMBWSTWENR6;
  NextSMBCR6       <= SMBCR6;
  NextSMBIDCYR7    <= SMBIDCYR7;
  NextSMBWST1R7    <= SMBWST1R7;
  NextSMBWST2R7    <= SMBWST2R7;
  NextSMBWSTOENR7  <= SMBWSTOENR7;
  NextSMBWSTWENR7  <= SMBWSTWENR7;
  NextSMBCR7(5 downto 1) <= SMBCR7(5 downto 1);
  ToutErrClr0      <= '0';
  WPErrClr0        <= '0';
  HSizeErrClr0     <= '0';
  ToutErrClr1      <= '0';
  WPErrClr1        <= '0';
  HSizeErrClr1     <= '0';
  ToutErrClr2      <= '0';
  WPErrClr2        <= '0';
  HSizeErrClr2     <= '0';
  ToutErrClr3      <= '0';
  WPErrClr3        <= '0';
  HSizeErrClr3     <= '0';
  ToutErrClr4      <= '0';
  WPErrClr4        <= '0';
  HSizeErrClr4     <= '0';
  ToutErrClr5      <= '0';
  WPErrClr5        <= '0';
  HSizeErrClr5     <= '0';
  ToutErrClr6      <= '0';
  WPErrClr6        <= '0';
  HSizeErrClr6     <= '0';
  ToutErrClr7      <= '0';
  WPErrClr7        <= '0';
  HSizeErrClr7     <= '0';

  if ((RegWrEn = '1') or (iMWCfgDone = '1' and WtdRegWr = '1')) then
    case HAddrReg is
      when HADDR_SMBIDCYR0   => NextSMBIDCYR0    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R0   => NextSMBWST1R0    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R0   => NextSMBWST2R0    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR0 => NextSMBWSTOENR0  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR0 => NextSMBWSTWENR0  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR0      => NextSMBCR0       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR0      =>
        ToutErrClr0  <= HWdataGtd(2);
        WPErrClr0    <= HWdataGtd(1);
        HSizeErrClr0 <= HWdataGtd(0);

      when HADDR_SMBIDCYR1   => NextSMBIDCYR1    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R1   => NextSMBWST1R1    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R1   => NextSMBWST2R1    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR1 => NextSMBWSTOENR1  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR1 => NextSMBWSTWENR1  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR1      => NextSMBCR1       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR1      =>
        ToutErrClr1  <= HWdataGtd(2);
        WPErrClr1    <= HWdataGtd(1);
        HSizeErrClr1 <= HWdataGtd(0);

      when HADDR_SMBIDCYR2   => NextSMBIDCYR2    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R2   => NextSMBWST1R2    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R2   => NextSMBWST2R2    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR2 => NextSMBWSTOENR2  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR2 => NextSMBWSTWENR2  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR2      => NextSMBCR2       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR2      =>
        ToutErrClr2  <= HWdataGtd(2);
        WPErrClr2    <= HWdataGtd(1);
        HSizeErrClr2 <= HWdataGtd(0);

      when HADDR_SMBIDCYR3   => NextSMBIDCYR3    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R3   => NextSMBWST1R3    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R3   => NextSMBWST2R3    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR3 => NextSMBWSTOENR3  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR3 => NextSMBWSTWENR3  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR3      => NextSMBCR3       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR3      =>
        ToutErrClr3  <= HWdataGtd(2);
        WPErrClr3    <= HWdataGtd(1);
        HSizeErrClr3 <= HWdataGtd(0);

      when HADDR_SMBIDCYR4   => NextSMBIDCYR4    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R4   => NextSMBWST1R4    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R4   => NextSMBWST2R4    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR4 => NextSMBWSTOENR4  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR4 => NextSMBWSTWENR4  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR4      => NextSMBCR4       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR4      =>
        ToutErrClr4  <= HWdataGtd(2);
        WPErrClr4    <= HWdataGtd(1);
        HSizeErrClr4 <= HWdataGtd(0);

      when HADDR_SMBIDCYR5   => NextSMBIDCYR5    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R5   => NextSMBWST1R5    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R5   => NextSMBWST2R5    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR5 => NextSMBWSTOENR5  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR5 => NextSMBWSTWENR5  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR5      => NextSMBCR5       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR5      =>
        ToutErrClr5  <= HWdataGtd(2);
        WPErrClr5    <= HWdataGtd(1);
        HSizeErrClr5 <= HWdataGtd(0);

      when HADDR_SMBIDCYR6   => NextSMBIDCYR6    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R6   => NextSMBWST1R6    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R6   => NextSMBWST2R6    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR6 => NextSMBWSTOENR6  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR6 => NextSMBWSTWENR6  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR6      => NextSMBCR6       <= HWdataGtd(7 downto 0);

      when HADDR_SMBSR6      =>
        ToutErrClr6  <= HWdataGtd(2);
        WPErrClr6    <= HWdataGtd(1);
        HSizeErrClr6 <= HWdataGtd(0);

      when HADDR_SMBIDCYR7   => NextSMBIDCYR7    <= HWdataGtd(3 downto 0);

      when HADDR_SMBWST1R7   => NextSMBWST1R7    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWST2R7   => NextSMBWST2R7    <= HWdataGtd(4 downto 0);

      when HADDR_SMBWSTOENR7 => NextSMBWSTOENR7  <= HWdataGtd(3 downto 0);

      when HADDR_SMBWSTWENR7 => NextSMBWSTWENR7  <= HWdataGtd(3 downto 0);

      when HADDR_SMBCR7      => NextSMBCR7(5 downto 1) <= HWdataGtd(5 downto 1);

      when HADDR_SMBSR7      =>
        ToutErrClr7      <= HWdataGtd(2);
        WPErrClr7        <= HWdataGtd(1);
        HSizeErrClr7     <= HWdataGtd(0);

      when others => null;

    end case;
  end if;
end process p_RegWrComb;

-- -----------------------------------------------------------------------------
-- Sequential Process for Writeable Registers
-- -----------------------------------------------------------------------------
p_RegWrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    SMBIDCYR0        <= "1111";
    SMBWST1R0        <= "11111";
    SMBWST2R0        <= "11111";
    SMBWSTOENR0      <= ZEROFILL(3 downto 0);
    SMBWSTWENR0      <= "0001";
    SMBCR0           <= "10000000";
    SMBIDCYR1        <= "1111";
    SMBWST1R1        <= "11111";
    SMBWST2R1        <= "11111";
    SMBWSTOENR1      <= ZEROFILL(3 downto 0);
    SMBWSTWENR1      <= "0001";
    SMBCR1           <= "00000000";
    SMBIDCYR2        <= "1111";
    SMBWST1R2        <= "11111";
    SMBWST2R2        <= "11111";
    SMBWSTOENR2      <= ZEROFILL(3 downto 0);
    SMBWSTWENR2      <= "0001";
    SMBCR2           <= "01000000";
    SMBIDCYR3        <= "1111";
    SMBWST1R3        <= "11111";
    SMBWST2R3        <= "11111";
    SMBWSTOENR3      <= ZEROFILL(3 downto 0);
    SMBWSTWENR3      <= "0001";
    SMBCR3           <= "00000000";
    SMBIDCYR4        <= "1111";
    SMBWST1R4        <= "11111";
    SMBWST2R4        <= "11111";
    SMBWSTOENR4      <= ZEROFILL(3 downto 0);
    SMBWSTWENR4      <= "0001";
    SMBCR4           <= "10000000";
    SMBIDCYR5        <= "1111";
    SMBWST1R5        <= "11111";
    SMBWST2R5        <= "11111";
    SMBWSTOENR5      <= ZEROFILL(3 downto 0);
    SMBWSTWENR5      <= "0001";
    SMBCR5           <= "10000000";
    SMBIDCYR6        <= "1111";
    SMBWST1R6        <= "11111";
    SMBWST2R6        <= "11111";
    SMBWSTOENR6      <= ZEROFILL(3 downto 0);
    SMBWSTWENR6      <= "0001";
    SMBCR6           <= "01000000";
    SMBIDCYR7        <= "1111";
    SMBWST1R7        <= "11111";
    SMBWST2R7        <= "11111";
    SMBWSTOENR7      <= ZEROFILL(3 downto 0);
    SMBWSTWENR7      <= "0001";
    SMBCR7           <= "00000000";
  elsif (HCLK'event and HCLK = '1') then
    SMBIDCYR0        <= NextSMBIDCYR0;
    SMBWST1R0        <= NextSMBWST1R0;
    SMBWST2R0        <= NextSMBWST2R0;
    SMBWSTOENR0      <= NextSMBWSTOENR0;
    SMBWSTWENR0      <= NextSMBWSTWENR0;
    SMBCR0           <= NextSMBCR0;
    SMBIDCYR1        <= NextSMBIDCYR1;
    SMBWST1R1        <= NextSMBWST1R1;
    SMBWST2R1        <= NextSMBWST2R1;
    SMBWSTOENR1      <= NextSMBWSTOENR1;
    SMBWSTWENR1      <= NextSMBWSTWENR1;
    SMBCR1           <= NextSMBCR1;
    SMBIDCYR2        <= NextSMBIDCYR2;
    SMBWST1R2        <= NextSMBWST1R2;
    SMBWST2R2        <= NextSMBWST2R2;
    SMBWSTOENR2      <= NextSMBWSTOENR2;
    SMBWSTWENR2      <= NextSMBWSTWENR2;
    SMBCR2           <= NextSMBCR2;
    SMBIDCYR3        <= NextSMBIDCYR3;
    SMBWST1R3        <= NextSMBWST1R3;
    SMBWST2R3        <= NextSMBWST2R3;
    SMBWSTOENR3      <= NextSMBWSTOENR3;
    SMBWSTWENR3      <= NextSMBWSTWENR3;
    SMBCR3           <= NextSMBCR3;
    SMBIDCYR4        <= NextSMBIDCYR4;
    SMBWST1R4        <= NextSMBWST1R4;
    SMBWST2R4        <= NextSMBWST2R4;
    SMBWSTOENR4      <= NextSMBWSTOENR4;
    SMBWSTWENR4      <= NextSMBWSTWENR4;
    SMBCR4           <= NextSMBCR4;
    SMBIDCYR5        <= NextSMBIDCYR5;
    SMBWST1R5        <= NextSMBWST1R5;
    SMBWST2R5        <= NextSMBWST2R5;
    SMBWSTOENR5      <= NextSMBWSTOENR5;
    SMBWSTWENR5      <= NextSMBWSTWENR5;
    SMBCR5           <= NextSMBCR5;
    SMBIDCYR6        <= NextSMBIDCYR6;
    SMBWST1R6        <= NextSMBWST1R6;
    SMBWST2R6        <= NextSMBWST2R6;
    SMBWSTOENR6      <= NextSMBWSTOENR6;
    SMBWSTWENR6      <= NextSMBWSTWENR6;
    SMBCR6           <= NextSMBCR6;
    SMBIDCYR7        <= NextSMBIDCYR7;
    SMBWST1R7        <= NextSMBWST1R7;
    SMBWST2R7        <= NextSMBWST2R7;
    SMBWSTOENR7      <= NextSMBWSTOENR7;
    SMBWSTWENR7      <= NextSMBWSTWENR7;
    SMBCR7           <= NextSMBCR7;
  end if;
end process p_RegWrSeq;

-- -----------------------------------------------------------------------------
-- Updating or clearing the WaitToutErr flag registers
-- -----------------------------------------------------------------------------
p_ToutErRComb : process (ToutErrGen0, ToutErrGen1, ToutErrGen2, ToutErrGen3,
                         ToutErrGen4, ToutErrGen5, ToutErrGen6, ToutErrGen7,
                         ToutErrClr0, ToutErrClr1, ToutErrClr2, ToutErrClr3,
                         ToutErrClr4, ToutErrClr5, ToutErrClr6, ToutErrClr7,
                         ToutErrR0, ToutErrR1, ToutErrR2, ToutErrR3,
                         ToutErrR4, ToutErrR5, ToutErrR6, ToutErrR7)
begin
  NextToutErrR0  <= ToutErrR0;
  NextToutErrR1  <= ToutErrR1;
  NextToutErrR2  <= ToutErrR2;
  NextToutErrR3  <= ToutErrR3;
  NextToutErrR4  <= ToutErrR4;
  NextToutErrR5  <= ToutErrR5;
  NextToutErrR6  <= ToutErrR6;
  NextToutErrR7  <= ToutErrR7;

  if (ToutErrGen0 = '1') then
    NextToutErrR0    <= '1';
  elsif (ToutErrClr0 = '1') then
    NextToutErrR0    <= '0';
  end if;

  if (ToutErrGen1 = '1') then
    NextToutErrR1    <= '1';
  elsif (ToutErrClr1 = '1') then
    NextToutErrR1    <= '0';
  end if;

  if (ToutErrGen2 = '1') then
    NextToutErrR2    <= '1';
  elsif (ToutErrClr2 = '1') then
    NextToutErrR2    <= '0';
  end if;

  if (ToutErrGen3 = '1') then
    NextToutErrR3    <= '1';
  elsif (ToutErrClr3 = '1') then
    NextToutErrR3    <= '0';
  end if;

  if (ToutErrGen4 = '1') then
    NextToutErrR4    <= '1';
  elsif (ToutErrClr4 = '1') then
    NextToutErrR4    <= '0';
  end if;

  if (ToutErrGen5 = '1') then
    NextToutErrR5    <= '1';
  elsif (ToutErrClr5 = '1') then
    NextToutErrR5    <= '0';
  end if;

  if (ToutErrGen6 = '1') then
    NextToutErrR6    <= '1';
  elsif (ToutErrClr6 = '1') then
    NextToutErrR6    <= '0';
  end if;

  if (ToutErrGen7 = '1') then
    NextToutErrR7    <= '1';
  elsif (ToutErrClr7 = '1') then
    NextToutErrR7    <= '0';
  end if;

end process p_ToutErRComb;

-- -----------------------------------------------------------------------------
-- Updating or clearing the WrProtErr flag registers
-- -----------------------------------------------------------------------------
p_WrProtErrComb : process (WPErrReg0, WPErrReg1, WPErrReg2, WPErrReg3,
                           WPErrReg4, WPErrReg5, WPErrReg6, WPErrReg7,
                           WPErrGen0, WPErrGen1, WPErrGen2, WPErrGen3,
                           WPErrGen4, WPErrGen5, WPErrGen6, WPErrGen7,
                           WPErrClr0, WPErrClr1, WPErrClr2, WPErrClr3,
                           WPErrClr4, WPErrClr5, WPErrClr6, WPErrClr7)
begin
  NextWPErrReg0  <= WPErrReg0;
  NextWPErrReg1  <= WPErrReg1;
  NextWPErrReg2  <= WPErrReg2;
  NextWPErrReg3  <= WPErrReg3;
  NextWPErrReg4  <= WPErrReg4;
  NextWPErrReg5  <= WPErrReg5;
  NextWPErrReg6  <= WPErrReg6;
  NextWPErrReg7  <= WPErrReg7;

  if (WPErrGen0 = '1') then
    NextWPErrReg0    <= '1';
  elsif (WPErrClr0 = '1') then
    NextWPErrReg0    <= '0';
  end if;

  if (WPErrGen1 = '1') then
    NextWPErrReg1    <= '1';
  elsif (WPErrClr1 = '1') then
    NextWPErrReg1    <= '0';
  end if;

  if (WPErrGen2 = '1') then
    NextWPErrReg2    <= '1';
  elsif (WPErrClr2 = '1') then
    NextWPErrReg2    <= '0';
  end if;

  if (WPErrGen3 = '1') then
    NextWPErrReg3    <= '1';
  elsif (WPErrClr3 = '1') then
    NextWPErrReg3    <= '0';
  end if;

  if (WPErrGen4 = '1') then
    NextWPErrReg4    <= '1';
  elsif (WPErrClr4 = '1') then
    NextWPErrReg4    <= '0';
  end if;

  if (WPErrGen5 = '1') then
    NextWPErrReg5    <= '1';
  elsif (WPErrClr5 = '1') then
    NextWPErrReg5    <= '0';
  end if;

  if (WPErrGen6 = '1') then
    NextWPErrReg6    <= '1';
  elsif (WPErrClr6 = '1') then
    NextWPErrReg6    <= '0';
  end if;

  if (WPErrGen7 = '1') then
    NextWPErrReg7    <= '1';
  elsif (WPErrClr7 = '1') then
    NextWPErrReg7    <= '0';
  end if;

end process p_WrProtErrComb;

-- -----------------------------------------------------------------------------
-- Updating or clearing the HSizeErr flag registers
-- -----------------------------------------------------------------------------
p_HSizeErrRegComb : process (HSizeErrR0, HSizeErrR1, HSizeErrR2, HSizeErrR3,
                             HSizeErrR4, HSizeErrR5, HSizeErrR6, HSizeErrR7,
                             HSizeErrGen0, HSizeErrGen1, HSizeErrGen2,
                             HSizeErrGen3, HSizeErrGen4, HSizeErrGen5,
                             HSizeErrGen6, HSizeErrGen7,
                             HSizeErrClr0, HSizeErrClr1, HSizeErrClr2,
                             HSizeErrClr3, HSizeErrClr4, HSizeErrClr5,
                             HSizeErrClr6, HSizeErrClr7)
begin
  NextHSizeErrR0   <= HSizeErrR0;
  NextHSizeErrR1   <= HSizeErrR1;
  NextHSizeErrR2   <= HSizeErrR2;
  NextHSizeErrR3   <= HSizeErrR3;
  NextHSizeErrR4   <= HSizeErrR4;
  NextHSizeErrR5   <= HSizeErrR5;
  NextHSizeErrR6   <= HSizeErrR6;
  NextHSizeErrR7   <= HSizeErrR7;

  if (HSizeErrGen0 = '1') then
    NextHSizeErrR0   <= '1';
  elsif (HSizeErrClr0 = '1') then
    NextHSizeErrR0   <= '0';
  end if;

  if (HSizeErrGen1 = '1') then
    NextHSizeErrR1   <= '1';
  elsif (HSizeErrClr1 = '1') then
    NextHSizeErrR1   <= '0';
  end if;

  if (HSizeErrGen2 = '1') then
    NextHSizeErrR2   <= '1';
  elsif (HSizeErrClr2 = '1') then
    NextHSizeErrR2   <= '0';
  end if;

  if (HSizeErrGen3 = '1') then
    NextHSizeErrR3   <= '1';
  elsif (HSizeErrClr3 = '1') then
    NextHSizeErrR3   <= '0';
  end if;

  if (HSizeErrGen4 = '1') then
    NextHSizeErrR4   <= '1';
  elsif (HSizeErrClr4 = '1') then
    NextHSizeErrR4   <= '0';
  end if;

  if (HSizeErrGen5 = '1') then
    NextHSizeErrR5   <= '1';
  elsif (HSizeErrClr5 = '1') then
    NextHSizeErrR5   <= '0';
  end if;

  if (HSizeErrGen6 = '1') then
    NextHSizeErrR6   <= '1';
  elsif (HSizeErrClr6 = '1') then
    NextHSizeErrR6   <= '0';
  end if;

  if (HSizeErrGen7 = '1') then
    NextHSizeErrR7   <= '1';
  elsif (HSizeErrClr7 = '1') then
    NextHSizeErrR7   <= '0';
  end if;

end process p_HSizeErrRegComb;

-- -----------------------------------------------------------------------------
-- Sequential Process for storing the error status flag registers
-- -----------------------------------------------------------------------------
p_ErrFlgRegSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ToutErrR0        <= '0';
    ToutErrR1        <= '0';
    ToutErrR2        <= '0';
    ToutErrR3        <= '0';
    ToutErrR4        <= '0';
    ToutErrR5        <= '0';
    ToutErrR6        <= '0';
    ToutErrR7        <= '0';
    WPErrReg0        <= '0';
    WPErrReg1        <= '0';
    WPErrReg2        <= '0';
    WPErrReg3        <= '0';
    WPErrReg4        <= '0';
    WPErrReg5        <= '0';
    WPErrReg6        <= '0';
    WPErrReg7        <= '0';
    HSizeErrR0       <= '0';
    HSizeErrR1       <= '0';
    HSizeErrR2       <= '0';
    HSizeErrR3       <= '0';
    HSizeErrR4       <= '0';
    HSizeErrR5       <= '0';
    HSizeErrR6       <= '0';
    HSizeErrR7       <= '0';
    WaitStatus       <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ToutErrR0        <= NextToutErrR0;
    ToutErrR1        <= NextToutErrR1;
    ToutErrR2        <= NextToutErrR2;
    ToutErrR3        <= NextToutErrR3;
    ToutErrR4        <= NextToutErrR4;
    ToutErrR5        <= NextToutErrR5;
    ToutErrR6        <= NextToutErrR6;
    ToutErrR7        <= NextToutErrR7;
    WPErrReg0        <= NextWPErrReg0;
    WPErrReg1        <= NextWPErrReg1;
    WPErrReg2        <= NextWPErrReg2;
    WPErrReg3        <= NextWPErrReg3;
    WPErrReg4        <= NextWPErrReg4;
    WPErrReg5        <= NextWPErrReg5;
    WPErrReg6        <= NextWPErrReg6;
    WPErrReg7        <= NextWPErrReg7;
    HSizeErrR0       <= NextHSizeErrR0;
    HSizeErrR1       <= NextHSizeErrR1;
    HSizeErrR2       <= NextHSizeErrR2;
    HSizeErrR3       <= NextHSizeErrR3;
    HSizeErrR4       <= NextHSizeErrR4;
    HSizeErrR5       <= NextHSizeErrR5;
    HSizeErrR6       <= NextHSizeErrR6;
    HSizeErrR7       <= NextHSizeErrR7;
    WaitStatus       <= NextWaitStatus;
  end if;

end process p_ErrFlgRegSeq;

-- -----------------------------------------------------------------------------
-- Registering the REMAP input after reset
-- -----------------------------------------------------------------------------
p_StrRmpSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iRemapReg      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iRemapReg      <= REMAP;
  end if;
end process p_StrRmpSeq;

-- -----------------------------------------------------------------------------
-- Bank specific parameter selection logic for WST1, WST2, WSTWEN, WSTOEN, RBLE,
-- BM, CSPol, WaitPol and MW
-- -----------------------------------------------------------------------------
p_ParaSelComb : process (SMBWST1R0, SMBWST2R0,
                         SMBWSTOENR0, SMBWSTWENR0, SMBCR0,
                         SMBWST1R1, SMBWST2R1, SMBWSTOENR1,
                         SMBWSTWENR1, SMBCR1, SMBWST1R2,
                         SMBWST2R2, SMBWSTOENR2, SMBWSTWENR2, SMBCR2,
                         SMBWST1R3, SMBWST2R3,
                         SMBWSTOENR3,SMBWSTWENR3, SMBCR3,
                         SMBWST1R4, SMBWST2R4, SMBWSTOENR4,
                         SMBWSTWENR4, SMBCR4, SMBWST1R5,
                         SMBWST2R5, SMBWSTOENR5, SMBWSTWENR5, SMBCR5,
                         SMBWST1R6, SMBWST2R6,
                         SMBWSTOENR6, SMBWSTWENR6, SMBCR6,
                         SMBWST1R7, SMBWST2R7, SMBWSTOENR7,
                         SMBWSTWENR7, SMBCR7, iCSPol, NextBnkAddStr,
                         iRemapReg, iMW)
begin
  WST1             <= "11111";
  WST2             <= "11111";
  WSTOEN           <= "1111";
  WSTWEN           <= "1111";
  RBLE             <= '0';
  WaitPol          <= '0';
  BM               <= '0';
  NextCSPol        <= iCSPol;
  NextMW           <= iMW;

  case NextBnkAddStr is
    when "000" =>
      if (iRemapReg = '1') then
        WST1             <= SMBWST1R0;
        WST2             <= SMBWST2R0;
        WSTOEN           <= SMBWSTOENR0;
        WSTWEN           <= SMBWSTWENR0;
        RBLE             <= SMBCR0(0);
        WaitPol          <= SMBCR0(1);
        BM               <= SMBCR0(5);
        NextMW           <= SMBCR0(7 downto 6);
      else
        WST1             <= SMBWST1R7;
        WST2             <= SMBWST2R7;
        WSTOEN           <= SMBWSTOENR7;
        WSTWEN           <= SMBWSTWENR7;
        RBLE             <= SMBCR7(0);
        WaitPol          <= SMBCR7(1);
        BM               <= SMBCR7(5);
        NextMW           <= SMBCR7(7 downto 6);
      end if;
    when "001" =>
      WST1             <= SMBWST1R1;
      WST2             <= SMBWST2R1;
      WSTOEN           <= SMBWSTOENR1;
      WSTWEN           <= SMBWSTWENR1;
      RBLE             <= SMBCR1(0);
      WaitPol          <= SMBCR1(1);
      BM               <= SMBCR1(5);
      NextMW           <= SMBCR1(7 downto 6);
    when "010" =>
      WST1             <= SMBWST1R2;
      WST2             <= SMBWST2R2;
      WSTOEN           <= SMBWSTOENR2;
      WSTWEN           <= SMBWSTWENR2;
      RBLE             <= SMBCR2(0);
      WaitPol          <= SMBCR2(1);
      BM               <= SMBCR2(5);
      NextMW           <= SMBCR2(7 downto 6);
    when "011" =>
      WST1             <= SMBWST1R3;
      WST2             <= SMBWST2R3;
      WSTOEN           <= SMBWSTOENR3;
      WSTWEN           <= SMBWSTWENR3;
      RBLE             <= SMBCR3(0);
      WaitPol          <= SMBCR3(1);
      BM               <= SMBCR3(5);
      NextMW           <= SMBCR3(7 downto 6);
    when "100" =>
      WST1             <= SMBWST1R4;
      WST2             <= SMBWST2R4;
      WSTOEN           <= SMBWSTOENR4;
      WSTWEN           <= SMBWSTWENR4;
      RBLE             <= SMBCR4(0);
      WaitPol          <= SMBCR4(1);
      BM               <= SMBCR4(5);
      NextMW           <= SMBCR4(7 downto 6);
    when "101" =>
      WST1             <= SMBWST1R5;
      WST2             <= SMBWST2R5;
      WSTOEN           <= SMBWSTOENR5;
      WSTWEN           <= SMBWSTWENR5;
      RBLE             <= SMBCR5(0);
      WaitPol          <= SMBCR5(1);
      BM               <= SMBCR5(5);
      NextMW           <= SMBCR5(7 downto 6);
    when "110" =>
      WST1             <= SMBWST1R6;
      WST2             <= SMBWST2R6;
      WSTOEN           <= SMBWSTOENR6;
      WSTWEN           <= SMBWSTWENR6;
      RBLE             <= SMBCR6(0);
      WaitPol          <= SMBCR6(1);
      BM               <= SMBCR6(5);
      NextMW           <= SMBCR6(7 downto 6);
    when "111" =>
      WST1             <= SMBWST1R7;
      WST2             <= SMBWST2R7;
      WSTOEN           <= SMBWSTOENR7;
      WSTWEN           <= SMBWSTWENR7;
      RBLE             <= SMBCR7(0);
      WaitPol          <= SMBCR7(1);
      BM               <= SMBCR7(5);
      NextMW           <= SMBCR7(7 downto 6);
    when others =>
      null;
  end case;
  NextCSPol        <= SMBCR7(3) & SMBCR6(3) & SMBCR5(3) & SMBCR4(3) &
                      SMBCR3(3) & SMBCR2(3) & SMBCR1(3) & SMBCR0(3);

end process p_ParaSelComb;

-- -----------------------------------------------------------------------------
-- Bank specific parameter selection logic for IDCY
-- -----------------------------------------------------------------------------
p_IdcySelComb : process (SMBIDCYR0, SMBIDCYR1, SMBIDCYR2,
                         SMBIDCYR3, SMBIDCYR4, SMBIDCYR5,
                         SMBIDCYR6, SMBIDCYR7, iBnkAddStr, iRemapReg)
begin
  IDCY             <= "1111";

  case iBnkAddStr is
    when "000" =>
      if (iRemapReg = '1') then
        IDCY             <= SMBIDCYR0;
      else
        IDCY             <= SMBIDCYR7;
      end if;
    when "001" =>
      IDCY             <= SMBIDCYR1;
    when "010" =>
      IDCY             <= SMBIDCYR2;
    when "011" =>
      IDCY             <= SMBIDCYR3;
    when "100" =>
      IDCY             <= SMBIDCYR4;
    when "101" =>
      IDCY             <= SMBIDCYR5;
    when "110" =>
      IDCY             <= SMBIDCYR6;
    when "111" =>
      IDCY             <= SMBIDCYR7;
    when others =>
      null;
  end case;
end process p_IdcySelComb;


-- -----------------------------------------------------------------------------
-- Bank address selection
-- -----------------------------------------------------------------------------
NextBankAddr     <= HADDR(28 downto 26) when
                     ((CrntMemWrBa = '0' and iMemWrReq = '0') and
                      (HSELSMC = '1' and HREADYIN = '1' and HTRANS(1) = '1'))
                 else
                   NextBnkAddWtd when
                     (MemWrOver = '1' and (iWtdWrReq = '1' or iWtdRdReq = '1'))
                 else
                   BankAddr;

-- -----------------------------------------------------------------------------
-- Selection logic for WaitEn parameter
-- -----------------------------------------------------------------------------
p_WaitEnSelComb : process (SMBCR0, SMBCR1, SMBCR2, SMBCR3, SMBCR4, SMBCR5,
                           SMBCR6, SMBCR7, iWaitEn, NextBankAddr, iRemapReg)
begin
  NextWaitEn       <= iWaitEn;

   case NextBankAddr is
    when "000" =>
      if (iRemapReg = '1') then
        NextWaitEn       <= SMBCR0(2);
      else
        NextWaitEn       <= SMBCR7(2);
      end if;
    when "001" =>
      NextWaitEn       <= SMBCR1(2);
    when "010" =>
      NextWaitEn       <= SMBCR2(2);
    when "011" =>
      NextWaitEn       <= SMBCR3(2);
    when "100" =>
      NextWaitEn       <= SMBCR4(2);
    when "101" =>
      NextWaitEn       <= SMBCR5(2);
    when "110" =>
      NextWaitEn       <= SMBCR6(2);
    when "111" =>
      NextWaitEn       <= SMBCR7(2);
    when others =>
      null;
  end case;
end process p_WaitEnSelComb;

-- -----------------------------------------------------------------------------
-- Bank specific WP selection logic
-- -----------------------------------------------------------------------------
p_WPSelComb : process (SMBCR0, SMBCR1, SMBCR2, SMBCR3, SMBCR4,
                       SMBCR5, SMBCR6, SMBCR7, HADDR, HSELSMC,
                       HREADYIN, HTRANS, iRemapReg)
begin
  WP               <= '0';

  if (HSELSMC = '1' and HREADYIN = '1' and HTRANS(1) = '1') then
    case HADDR(28 downto 26) is
      when "000" =>
        if (iRemapReg = '1') then
          WP               <= SMBCR0(4);
        else
          WP               <= SMBCR7(4);
        end if;
      when "001" =>
        WP               <= SMBCR1(4);
      when "010" =>
        WP               <= SMBCR2(4);
      when "011" =>
        WP               <= SMBCR3(4);
      when "100" =>
        WP               <= SMBCR4(4);
      when "101" =>
        WP               <= SMBCR5(4);
      when "110" =>
        WP               <= SMBCR6(4);
      when "111" =>
        WP               <= SMBCR7(4);
      when others =>
        null;
    end case;
  end if;
end process p_WPSelComb;

-- -----------------------------------------------------------------------------
-- Sequential Process for Writeable Registers
-- -----------------------------------------------------------------------------
p_ParamSelSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iWaitEn          <= '0';
    iCSPol           <= (others => '0');
    iMW              <= "10";
    BankAddr         <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iWaitEn          <= NextWaitEn;
    iCSPol           <= NextCSPol;
    iMW              <= NextMW;
    BankAddr         <= NextBankAddr;
  end if;
end process p_ParamSelSeq;

-- -----------------------------------------------------------------------------
-- The memory size generation logic.
-- -----------------------------------------------------------------------------
-- p_MSizeSelComb : process (iMW)
p_MSizeSelComb : process (NextMW)
begin
  iMSize08         <= '0';
  iMSize16         <= '0';
  iMSize32         <= '0';

--  case iMW is
  case NextMW is
    when "00" =>
      iMSize08         <= '1';
    when "01" =>
      iMSize16         <= '1';
    when "10" =>
      iMSize32         <= '1';
    when others =>
      null;
  end case;
end process p_MSizeSelComb;

-- -----------------------------------------------------------------------------
-- Connecting the local copies to the respective outputs
-- -----------------------------------------------------------------------------
WaitEn           <= iWaitEn;
MSize08          <= iMSize08;
MSize16          <= iMSize16;
MSize32          <= iMSize32;
MW               <= NextMW;
CSPol            <= iCSPol;
HAddrCrnt        <= iHAddrCrnt(25 downto 0);
HAddrWtdCo       <= NextHAddrWtd;
HTransRegCo      <= NextHTransReg;
MemWrReq         <= iMemWrReq;
MemRdReq         <= iMemRdReq;
WtdRdReq         <= iWtdRdReq;
WtdWrReq         <= iWtdWrReq;
HSizeRegCo       <= NextHSizeReg;
BnkAddStrCo      <= NextBnkAddStr;
BufWrOver        <= iBufWrOver;
MwPgm            <= iMwPgm;
HBurstRegCo      <= NextHBurstReg;
RemapReg         <= iRemapReg;
MWCfgDone        <= iMWCfgDone;

end synth;

-- --================================== End ==================================--

