-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : VicAhbif.vhd.rca
-- File Revision          : 1.17
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module provides the AHB system bus interface to the VIC.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.VicPackage.all;

-- -----------------------------------------------------------------------------

entity VicAhbif is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HSELVIC          : in    std_logic; -- VIC select
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- AHB address bus
        HTRANS1          : in    std_logic; -- 1st bit of AHB transfer type
        HWRITE           : in    std_logic; -- AHB Write
        HREADYIN         : in    std_logic; -- Shared HREADY line
        HPROT1           : in    std_logic; -- 1st bit of AHB protection mode
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB transfer size
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB write data bus
        Revision         : in    std_logic_vector(3 downto 0);
                                            -- Revision number of VIC

-- Interrupt related signals
        VICFIQStatus     : in    std_logic_vector(31 downto 0);
                                            -- Status of the FIQ after
                                            -- disabling
                                            -- the interrupt
        VICIRQStatus     : in    std_logic_vector(31 downto 0);
                                            -- Status of the IRQ after
                                            -- disabling
                                            -- the interrupt
        VICRawIntr       : in    std_logic_vector(31 downto 0);
                                            -- Status of the interrupts before
                                            -- masking
        VICINTSOURCE     : in    std_logic_vector(31 downto 0);
                                            -- Peripheral interrupt source
                                            -- input
        VICVectAddrVal   : in    std_logic_vector(31 downto 0);
                                            -- Vector address from VicCpuif for
                                            -- read by
                                            -- software
-- Test interface inputs
        IRQACKTestVal    : in    std_logic; -- Integration test value of
                                            -- VICIRQACK
        nIRQINTestVal    : in    std_logic; -- Integration test value of
                                            -- nVICIRQIN
        nFIQINTestVal    : in    std_logic; -- Integration test value of
                                            -- nVICFIQIN
        VADDRINTestVal   : in    std_logic_vector(31 downto 0);
                                            -- Integration test value of
                                            -- VICVECTADDRIN
        VADDRVTestVal    : in    std_logic; -- Integration test value of
                                            -- VICVECTADDRV
        IRQTestVal       : in    std_logic; -- Integration test value of VICIRQ
        FIQTestVal       : in    std_logic; -- Integration test value of VICFIQ
        ACKOUTTestVal    : in    std_logic; -- Integration test value of
                                            -- VICIRQACK
        VADDRTestVal     : in    std_logic_vector(31 downto 0);
                                            -- Integration test value of
                                            -- VICVECTADDR

-- Daisy chain input register configuration for read back in test register
        VICFIQINREG      : in    std_logic; -- Register enable signal for
                                            -- VICFIQIN
        VICIRQINREG      : in    std_logic; -- Register enable signal for
                                            -- VICIRQIN

-- Outputs
-- AHB signals
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response
        HREADYOUT        : out   std_logic; -- Slave ready output
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Read Data
-- Interrupt controls
        VICSoftInt       : out   std_logic_vector(31 downto 0);
                                            -- Software interrupt
        VICIntEnable     : out   std_logic_vector(31 downto 0);
                                            -- Interrupt enable
        VICIntSelect     : out   std_logic_vector(31 downto 0);
                                            -- Interrupt type
        SWPriorityMask   : out   std_logic_vector(15 downto 0);
                                            -- Software mask
        VectAddr0        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 0th interrupt
                                            -- source
        VectAddr1        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 1st interrupt
                                            -- source
        VectAddr2        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 2nd interrupt
                                            -- source
        VectAddr3        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 3rd interrupt
                                            -- source
        VectAddr4        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 4th interrupt
                                            -- source
        VectAddr5        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 5th interrupt
                                            -- source
        VectAddr6        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 6th interrupt
                                            -- source
        VectAddr7        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 7th interrupt
                                            -- source
        VectAddr8        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 8th interrupt
                                            -- source
        VectAddr9        : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 9th interrupt
                                            -- source
        VectAddr10       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 10th
                                            -- interrupt source
        VectAddr11       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 11th
                                            -- interrupt source
        VectAddr12       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 12th
                                            -- interrupt source
        VectAddr13       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 13th
                                            -- interrupt source
        VectAddr14       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 14th
                                            -- interrupt source
        VectAddr15       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 15th
                                            -- interrupt source
        VectAddr16       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 16th
                                            -- interrupt source
        VectAddr17       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 17th
                                            -- interrupt source
        VectAddr18       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 18th
                                            -- interrupt source
        VectAddr19       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 19th
                                            -- interrupt source
        VectAddr20       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 20th
                                            -- interrupt source
        VectAddr21       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 21st
                                            -- interrupt source
        VectAddr22       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 22nd
                                            -- interrupt source
        VectAddr23       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 23rd
                                            -- interrupt source
        VectAddr24       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 24th
                                            -- interrupt source
        VectAddr25       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 25th
                                            -- interrupt source
        VectAddr26       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 26th
                                            -- interrupt source
        VectAddr27       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 27th
                                            -- interrupt source
        VectAddr28       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 28th
                                            -- interrupt source
        VectAddr29       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 29th
                                            -- interrupt source
        VectAddr30       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 30th
                                            -- interrupt source
        VectAddr31       : out   std_logic_vector(31 downto 0);
                                            -- Vector address for 31st
                                            -- interrupt source
        VectPriority0    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 0th
                                            -- interrupt source
        VectPriority1    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 1st
                                            -- interrupt source
        VectPriority2    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 2nd
                                            -- interrupt source
        VectPriority3    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 3rd
                                            -- interrupt source
        VectPriority4    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 4th
                                            -- interrupt source
        VectPriority5    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 5th
                                            -- interrupt source
        VectPriority6    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 6th
                                            -- interrupt source
        VectPriority7    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 7th
                                            -- interrupt source
        VectPriority8    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 8th
                                            -- interrupt source
        VectPriority9    : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 9th
                                            -- interrupt source
        VectPriority10   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 10th
                                            -- interrupt source
        VectPriority11   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 11th
                                            -- interrupt source
        VectPriority12   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 12th
                                            -- interrupt source
        VectPriority13   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 13th
                                            -- interrupt source
        VectPriority14   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 14th
                                            -- interrupt source
        VectPriority15   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 15th
                                            -- interrupt source
        VectPriority16   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 16th
                                            -- interrupt source
        VectPriority17   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 17th
                                            -- interrupt source
        VectPriority18   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 18th
                                            -- interrupt source
        VectPriority19   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 19th
                                            -- interrupt source
        VectPriority20   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 20th
                                            -- interrupt source
        VectPriority21   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 21st
                                            -- interrupt source
        VectPriority22   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 22nd
                                            -- interrupt source
        VectPriority23   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 23rd
                                            -- interrupt source
        VectPriority24   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 24th
                                            -- interrupt source
        VectPriority25   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 25th
                                            -- interrupt source
        VectPriority26   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 26th
                                            -- interrupt source
        VectPriority27   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 27th
                                            -- interrupt source
        VectPriority28   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 28th
                                            -- interrupt source
        VectPriority29   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 29th
                                            -- interrupt source
        VectPriority30   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 30th
                                            -- interrupt source
        VectPriority31   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for 31st
                                            -- interrupt source
        VectPriority32   : out   std_logic_vector(3 downto 0);
                                            -- Vector priority for daisy chain
                                            -- interrupt
-- VIC priority stack controls
        IRQSWAck         : out   std_logic; -- Software IRQ acknowledge
        IRQSWClear       : out   std_logic; -- Software IRQ clear
-- Integration Test interface
        ITEN             : out   std_logic; -- Integration test enable
        IRQACKForceVal   : out   std_logic; -- Force value for VICIRQACK
        nIRQINForceVal   : out   std_logic; -- Force value for nVICIRQIN
        nFIQINForceVal   : out   std_logic; -- Force value for nVICFIQIN
        VECTADDRINFrcVal : out   std_logic_vector(31 downto 0);
                                            -- Force value for VICVECTADDRIN
        VECTADDRVFrcVal  : out   std_logic; -- Force value for VICVECTADDRV
        IRQForceVal      : out   std_logic; -- Force value for VICIRQ
                                            -- (non-invert)
        FIQForceVal      : out   std_logic; -- Force value for VICFIQ
                                            -- (non-invert)
        IRQACKOUTFrcVal  : out   std_logic; -- Force value for IRQACKOUT
        VECTADDRFrcVal   : out   std_logic_vector(31 downto 0)
                                            -- Force value for VICVECTADDR
       );
end VicAhbif;

-- -----------------------------------------------------------------------------
--
--                                  VicAhbif
--                                  ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module has the following functionality,
--
-- - AHB Slave response generation : HRESP and HREADYOUT.
-- The module returns the error response when the registers of the VIC are
-- accessed with HSIZE other than WORD.
--
-- - Writing to and reading from the registers.
-- When the registers are accessed, depending on the operation, the module
-- generates either the ReadEnable or the WriteEnable. When the registered
-- HADDR matches the address of the register, data is either stored
-- in the register or returned, depending on the operation. Note that the
-- registers will be updated only when the HTRANS is either NSEQ or SEQ.
--
-- - Generates the IRQSWAck, IRQSWClear depending on the VICADDRESS register
-- read or written by the CPU.
--
-- - Returns the integration test register values to the VicInterrupt block.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of VicAhbif is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal TransferValid    : std_logic;
-- Transfer on AHB bus is valid

signal TransferSizeErr  : std_logic;
-- Transfer on AHB is invalid due to HSIZE interrupt

signal OneWaitSt        : std_logic;
-- Onewait state register indicator interrupt

signal TieLow           : std_logic_vector(29 downto 0);
-- Tie values to zeros interrupt

signal TransferValidQ   : std_logic;
-- Transfer on AHB bus is valid interrupt (dataphase)

signal TransSizeErrQ    : std_logic_vector(1 downto 0);
-- Transfer on AHB is invalid due to HSIZE interrupt (data phase).
-- 2-bit shift register is used for error response generation

signal ReadEnable       : std_logic;
-- Read access enable signal interrupt

signal WriteEnable      : std_logic;
-- Write access enable signal interrupt

signal HADDRQ           : std_logic_vector(11 downto 2);
-- Registered version of HADDR interrupt

signal HWRITEQ          : std_logic;
-- Registered version of HWRITE interrupt

signal HPROT1Q          : std_logic;
-- Registered version of HPROT(1) interrupt

signal ProtEnQ          : std_logic;
-- Protection feature enable interrupt

signal VICSoftIntQ      : std_logic_vector(31 downto 0);
-- Software interrupt interrupt

signal VICADDRESSQ      : std_logic_vector(31 downto 0);
-- Registered version of the VICADDRESS interrupt

signal VICIntEnQ        : std_logic_vector(31 downto 0);
-- Interrupt enable interrupt

signal VICIntSelQ       : std_logic_vector(31 downto 0);
-- Interrupt type interrupt

signal SWPrioMaskQ      : std_logic_vector(15 downto 0);
-- Software priority level mask interrupt

signal VectAddr0Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 0th interrupt interrupt

signal VectAddr1Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 1st interrupt interrupt

signal VectAddr2Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 2nd interrupt interrupt

signal VectAddr3Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 3rd interrupt interrupt

signal VectAddr4Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 4th interrupt interrupt

signal VectAddr5Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 5th interrupt interrupt

signal VectAddr6Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 6th interrupt interrupt

signal VectAddr7Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 7th interrupt interrupt

signal VectAddr8Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 8th interrupt interrupt

signal VectAddr9Q       : std_logic_vector(31 downto 0);
-- Register for vector address of 9th interrupt interrupt

signal VectAddr10Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 10th interrupt interrupt

signal VectAddr11Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 11th interrupt interrupt

signal VectAddr12Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 12th interrupt interrupt

signal VectAddr13Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 13th interrupt interrupt

signal VectAddr14Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 14th interrupt interrupt

signal VectAddr15Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 15th interrupt interrupt

signal VectAddr16Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 16th interrupt interrupt

signal VectAddr17Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 17th interrupt interrupt

signal VectAddr18Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 18th interrupt interrupt

signal VectAddr19Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 19th interrupt interrupt

signal VectAddr20Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 20th interrupt interrupt

signal VectAddr21Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 21st interrupt interrupt

signal VectAddr22Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 22nd interrupt interrupt

signal VectAddr23Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 23rd interrupt interrupt

signal VectAddr24Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 24th interrupt interrupt

signal VectAddr25Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 25th interrupt interrupt

signal VectAddr26Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 26th interrupt interrupt

signal VectAddr27Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 27th interrupt interrupt

signal VectAddr28Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 28th interrupt interrupt

signal VectAddr29Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 29th interrupt interrupt

signal VectAddr30Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 30th interrupt interrupt

signal VectAddr31Q      : std_logic_vector(31 downto 0);
-- Register for vector address of 31st interrupt interrupt

signal VectPrio0Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 0th interrupt

signal VectPrio1Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 1st interrupt

signal VectPrio2Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 2nd interrupt

signal VectPrio3Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 3rd interrupt

signal VectPrio4Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 4th interrupt

signal VectPrio5Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 5th interrupt

signal VectPrio6Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 6th interrupt

signal VectPrio7Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 7th interrupt

signal VectPrio8Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 8th interrupt

signal VectPrio9Q       : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 9th interrupt

signal VectPrio10Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 10th interrupt

signal VectPrio11Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 11th interrupt

signal VectPrio12Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 12th interrupt

signal VectPrio13Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 13th interrupt

signal VectPrio14Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 14th interrupt

signal VectPrio15Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 15th interrupt

signal VectPrio16Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 16th interrupt

signal VectPrio17Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 17th interrupt

signal VectPrio18Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 18th interrupt

signal VectPrio19Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 19th interrupt

signal VectPrio20Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 20th interrupt

signal VectPrio21Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 21st interrupt

signal VectPrio22Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 22nd interrupt

signal VectPrio23Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 23rd interrupt

signal VectPrio24Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 24th interrupt

signal VectPrio25Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 25th interrupt

signal VectPrio26Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 26th interrupt

signal VectPrio27Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 27th interrupt

signal VectPrio28Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 28th interrupt

signal VectPrio29Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 29th interrupt

signal VectPrio30Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 30th interrupt

signal VectPrio31Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority level for 31st interrupt

signal VectPrio32Q      : std_logic_vector(3 downto 0);
-- Register of interrupt priority of Daisy chain

-- Test registers
signal VICITCRQ         : std_logic_vector(1 downto 0);
-- Integration test mode

signal VICITIP1Q        : std_logic_vector(8 downto 6);
-- I/P test register 1

signal VICITIP2Q        : std_logic_vector(31 downto 0);
-- I/P test register 2

signal VICITOP1Q        : std_logic_vector(9 downto 6);
-- O/P test register 1

signal VICITOP2Q        : std_logic_vector(31 downto 0);
-- O/P test register 2

signal IntSStatusQ      : std_logic_vector(31 downto 0);
-- Sampled interrupt source status

-- Registered version of read value for Integration test register
signal IRQACKTestValQ1  : std_logic;
-- Registered version of VICIRQACK

signal nIRQINTestValQ1  : std_logic;
-- Registered version of nVICIRQIN

signal nFIQINTestValQ1  : std_logic;
-- Registered version of nVICFIQIN

signal IRQTestValQ1     : std_logic;
-- Registered version of VICIRQ

signal FIQTestValQ1     : std_logic;
-- Registered version of VICFIQ

signal ACKOUTTestValQ1  : std_logic;
-- Registered version of VICIRQACKOUT

signal IRQACKTestValQ2  : std_logic;
-- Two times clocked version of VICIRQACK

signal nIRQINTestValQ2  : std_logic;
-- Two times clocked version of nVICIRQIN

signal nFIQINTestValQ2  : std_logic;
-- Two times clocked version of nVICFIQIN

signal IRQTestValQ2     : std_logic;
-- Two times clocked version of VICIRQ

signal FIQTestValQ2     : std_logic;
-- Two times clocked version of VICFIQ

signal ACKOUTTestValQ2  : std_logic;
-- Two times clocked version of VICIRQACKOUT

-- Synchronization registers for interrupt status
signal VICFIQStatusQ1   : std_logic_vector(31 downto 0);
-- FIQ status (1st synchronised register)

signal VICIRQStatusQ1   : std_logic_vector(31 downto 0);
-- IRQ status (1st synchronised register)

signal VICRawIntrQ1     : std_logic_vector(31 downto 0);
-- Raw interrupt (1st synchronised register)

signal VICIntSourceQ1   : std_logic_vector(31 downto 0);
-- Interrupt source (1st synchronised register)

signal VICFIQStatusQ2   : std_logic_vector(31 downto 0);
-- FIQ status (2nd synchronised register)

signal VICIRQStatusQ2   : std_logic_vector(31 downto 0);
-- IRQ status (2nd synchronised register)

signal VICRawIntrQ2     : std_logic_vector(31 downto 0);
-- Raw interrupt (2nd synchronised register)

signal VICIntSourceQ2   : std_logic_vector(31 downto 0);
-- Interrupt source (2nd synchronised register)

signal IDReadMux        : std_logic_vector(7 downto 0);
-- Read Mux for Cell ID and Peripheral ID

signal NxtVectAddr0     : std_logic_vector(31 downto 0);
-- D-input of VectAddr0Q

signal NxtVectAddr1     : std_logic_vector(31 downto 0);
-- D-input of VectAddr1Q

signal NxtVectAddr2     : std_logic_vector(31 downto 0);
-- D-input of VectAddr2Q

signal NxtVectAddr3     : std_logic_vector(31 downto 0);
-- D-input of VectAddr3Q

signal NxtVectAddr4     : std_logic_vector(31 downto 0);
-- D-input of VectAddr4Q

signal NxtVectAddr5     : std_logic_vector(31 downto 0);
-- D-input of VectAddr5Q

signal NxtVectAddr6     : std_logic_vector(31 downto 0);
-- D-input of VectAddr6Q

signal NxtVectAddr7     : std_logic_vector(31 downto 0);
-- D-input of VectAddr7Q

signal NxtVectAddr8     : std_logic_vector(31 downto 0);
-- D-input of VectAddr8Q

signal NxtVectAddr9     : std_logic_vector(31 downto 0);
-- D-input of VectAddr9Q

signal NxtVectAddr10    : std_logic_vector(31 downto 0);
-- D-input of VectAddr10Q

signal NxtVectAddr11    : std_logic_vector(31 downto 0);
-- D-input of VectAddr11Q

signal NxtVectAddr12    : std_logic_vector(31 downto 0);
-- D-input of VectAddr12Q

signal NxtVectAddr13    : std_logic_vector(31 downto 0);
-- D-input of VectAddr13Q

signal NxtVectAddr14    : std_logic_vector(31 downto 0);
-- D-input of VectAddr14Q

signal NxtVectAddr15    : std_logic_vector(31 downto 0);
-- D-input of VectAddr15Q

signal NxtVectAddr16    : std_logic_vector(31 downto 0);
-- D-input of VectAddr16Q

signal NxtVectAddr17    : std_logic_vector(31 downto 0);
-- D-input of VectAddr17Q

signal NxtVectAddr18    : std_logic_vector(31 downto 0);
-- D-input of VectAddr18Q

signal NxtVectAddr19    : std_logic_vector(31 downto 0);
-- D-input of VectAddr19Q

signal NxtVectAddr20    : std_logic_vector(31 downto 0);
-- D-input of VectAddr20Q

signal NxtVectAddr21    : std_logic_vector(31 downto 0);
-- D-input of VectAddr21Q

signal NxtVectAddr22    : std_logic_vector(31 downto 0);
-- D-input of VectAddr22Q

signal NxtVectAddr23    : std_logic_vector(31 downto 0);
-- D-input of VectAddr23Q

signal NxtVectAddr24    : std_logic_vector(31 downto 0);
-- D-input of VectAddr24Q

signal NxtVectAddr25    : std_logic_vector(31 downto 0);
-- D-input of VectAddr25Q

signal NxtVectAddr26    : std_logic_vector(31 downto 0);
-- D-input of VectAddr26Q

signal NxtVectAddr27    : std_logic_vector(31 downto 0);
-- D-input of VectAddr27Q

signal NxtVectAddr28    : std_logic_vector(31 downto 0);
-- D-input of VectAddr28Q

signal NxtVectAddr29    : std_logic_vector(31 downto 0);
-- D-input of VectAddr29Q

signal NxtVectAddr30    : std_logic_vector(31 downto 0);
-- D-input of VectAddr30Q

signal NxtVectAddr31    : std_logic_vector(31 downto 0);
-- D-input of VectAddr31Q

signal NxtVectPrio0     : std_logic_vector(3 downto 0);
-- D-input of VectPrio0Q

signal NxtVectPrio1     : std_logic_vector(3 downto 0);
-- D-input of VectPrio1Q

signal NxtVectPrio2     : std_logic_vector(3 downto 0);
-- D-input of VectPrio2Q

signal NxtVectPrio3     : std_logic_vector(3 downto 0);
-- D-input of VectPrio3Q

signal NxtVectPrio4     : std_logic_vector(3 downto 0);
-- D-input of VectPrio4Q

signal NxtVectPrio5     : std_logic_vector(3 downto 0);
-- D-input of VectPrio5Q

signal NxtVectPrio6     : std_logic_vector(3 downto 0);
-- D-input of VectPrio6Q

signal NxtVectPrio7     : std_logic_vector(3 downto 0);
-- D-input of VectPrio7Q

signal NxtVectPrio8     : std_logic_vector(3 downto 0);
-- D-input of VectPrio8Q

signal NxtVectPrio9     : std_logic_vector(3 downto 0);
-- D-input of VectPrio9Q

signal NxtVectPrio10    : std_logic_vector(3 downto 0);
-- D-input of VectPrio10Q

signal NxtVectPrio11    : std_logic_vector(3 downto 0);
-- D-input of VectPrio11Q

signal NxtVectPrio12    : std_logic_vector(3 downto 0);
-- D-input of VectPrio12Q

signal NxtVectPrio13    : std_logic_vector(3 downto 0);
-- D-input of VectPrio13Q

signal NxtVectPrio14    : std_logic_vector(3 downto 0);
-- D-input of VectPrio14Q

signal NxtVectPrio15    : std_logic_vector(3 downto 0);
-- D-input of VectPrio15Q

signal NxtVectPrio16    : std_logic_vector(3 downto 0);
-- D-input of VectPrio16Q

signal NxtVectPrio17    : std_logic_vector(3 downto 0);
-- D-input of VectPrio17Q

signal NxtVectPrio18    : std_logic_vector(3 downto 0);
-- D-input of VectPrio18Q

signal NxtVectPrio19    : std_logic_vector(3 downto 0);
-- D-input of VectPrio19Q

signal NxtVectPrio20    : std_logic_vector(3 downto 0);
-- D-input of VectPrio20Q

signal NxtVectPrio21    : std_logic_vector(3 downto 0);
-- D-input of VectPrio21Q

signal NxtVectPrio22    : std_logic_vector(3 downto 0);
-- D-input of VectPrio22Q

signal NxtVectPrio23    : std_logic_vector(3 downto 0);
-- D-input of VectPrio23Q

signal NxtVectPrio24    : std_logic_vector(3 downto 0);
-- D-input of VectPrio24Q

signal NxtVectPrio25    : std_logic_vector(3 downto 0);
-- D-input of VectPrio25Q

signal NxtVectPrio26    : std_logic_vector(3 downto 0);
-- D-input of VectPrio26Q

signal NxtVectPrio27    : std_logic_vector(3 downto 0);
-- D-input of VectPrio27Q

signal NxtVectPrio28    : std_logic_vector(3 downto 0);
-- D-input of VectPrio28Q

signal NxtVectPrio29    : std_logic_vector(3 downto 0);
-- D-input of VectPrio29Q

signal NxtVectPrio30    : std_logic_vector(3 downto 0);
-- D-input of VectPrio30Q

signal NxtVectPrio31    : std_logic_vector(3 downto 0);
-- D-input of VectPrio31Q

signal NxtVectPrio32    : std_logic_vector(3 downto 0);
-- D-input of VectPrio32Q

signal NxtVICIntSel     : std_logic_vector(31 downto 0);
-- D-input of VICIntSelQ

signal NxtVICIntEn      : std_logic_vector(31 downto 0);
-- D-input of VICIntEnQ

signal NxtVICSoftInt    : std_logic_vector(31 downto 0);
-- D-input of VICSoftIntQ

signal NxtSWPrioMask    : std_logic_vector(15 downto 0);
-- D-input of SWPrioMaskQ

signal NxtVICITCR       : std_logic_vector(1 downto 0);
-- Integration test mode

signal NxtVICITIP1      : std_logic_vector(8 downto 6);
-- I/P test register 1

signal NxtVICITIP2      : std_logic_vector(31 downto 0);
-- I/P test register 2

signal NxtVICITOP1      : std_logic_vector(9 downto 6);
-- O/P test register 1

signal NxtVICITOP2      : std_logic_vector(31 downto 0);
-- O/P test register 2

signal NxtIntSStatus    : std_logic_vector(31 downto 0);
-- Sampled interrupt source status

signal NxtIDReadMux     : std_logic_vector(7 downto 0);
-- D-input of IDReadMux

signal NxtProtEn        : std_logic;
-- D-input of ProtEnQ

signal NxtHADDR         : std_logic_vector(11 downto 2);
-- D-input of HADDR

signal NxtHWRITE        : std_logic;
-- D-input of HWRITEQ

signal NxtHPROT1        : std_logic;
-- D-input of HPROT1Q

signal NxtReadEnable    : std_logic;
-- D-input of ReadEnable

signal NxtWriteEnable   : std_logic;
-- D-input of WriteEnable

signal OneWaitSt1Q      : std_logic;
-- Registered OneWaitSt

signal OneWaitSt2Q      : std_logic;
-- Registered OneWaitSt1Q

signal HRDATA1          : std_logic_vector(31 downto 0);
-- Internal version of HRDATA for 1st set of read data

signal HRDATA2          : std_logic_vector(31 downto 0);
-- Internal version of HRDATA for 2nd set of read data

signal HRDATA3          : std_logic_vector(31 downto 0);
-- Internal version of HRDATA for 3rd set of read data

signal HRDATA4          : std_logic_vector(31 downto 0);
-- Internal version of HRDATA for 4th set of read data

signal HRDATA5          : std_logic_vector(31 downto 0);
-- Internal version of HRDATA for 5th set of read data

signal NxtHRDATA1       : std_logic_vector(31 downto 0);
-- D-input of HRDATA1

signal NxtHRDATA2       : std_logic_vector(31 downto 0);
-- D-input of HRDATA2

signal VICFIQINREGQ     : std_logic;
-- Clocked VICFIQINREG

signal VICIRQINREGQ     : std_logic;
-- Clocked VICIRQINREG

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------

-- synopsys translate_on
-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin
-- -----------------------------------------------------------------------------
-- Detect legal transfers
-- When the registers are accessed with HSIZE as WORD and HTRANS is either NSEQ
-- or SEQ then the transfer is a valid.
-- -----------------------------------------------------------------------------
TransferValid    <= '1' when (((HSELVIC and HTRANS1 and HREADYIN) = '1') and
                              (HSIZE = "010"))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Detect illegal transfers
-- When the registers are accessed with HSIZE other than WORD then the transfer
-- is an invalid transfer.
-- -----------------------------------------------------------------------------
TransferSizeErr  <= '1' when (((HSELVIC and HTRANS1 and HREADYIN) = '1') and
                              (HSIZE /="010"))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Detect one wait state register access
-- When the access to vector address registers[0-31] or to the priority
-- registers, assert the OneWaitSt signal
-- -----------------------------------------------------------------------------
OneWaitSt        <= '1' when ((TransferValid = '1')and
                             ((HADDR(11 downto 7) = "00010") or
                              (HADDR(11 downto 7) = "00100")))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Sequential logic to clock the OneWaitSt
-- -----------------------------------------------------------------------------
p_OneWtSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    OneWaitSt1Q      <= '0';
    OneWaitSt2Q      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    OneWaitSt1Q      <= OneWaitSt;
    OneWaitSt2Q      <= OneWaitSt1Q;
  end if;
end process p_OneWtSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic to generate the protect enable
-- -----------------------------------------------------------------------------
p_ProtRegComb : process (TransferValidQ, HWRITEQ, HPROT1Q, HADDRQ, HWDATA,
                         ProtEnQ)
begin
  if (((TransferValidQ and HWRITEQ and HPROT1Q) = '1') and
        HADDRQ(11 downto 2) = HADDR_VICPROTECTION) then
    NxtProtEn        <= HWDATA(0);
  else
    NxtProtEn        <= ProtEnQ;
  end if;
end process p_ProtRegComb;

-- -----------------------------------------------------------------------------
-- Protection register clocking
-- -----------------------------------------------------------------------------
p_ProtReg_WrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ProtEnQ          <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ProtEnQ          <= NxtProtEn;
  end if;
end process p_ProtReg_WrSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic to store the AHB parameters
-- -----------------------------------------------------------------------------
p_AHBSigStoreComb : process (TransferValid, HADDR, HWRITE, HPROT1, HADDRQ,
                             HWRITEQ, HPROT1Q)
begin
  if (TransferValid = '1') then
    NxtHADDR         <= HADDR;
    NxtHWRITE        <= HWRITE;
    NxtHPROT1        <= HPROT1;
  else
    NxtHADDR         <= HADDRQ;
    NxtHWRITE        <= HWRITEQ;
    NxtHPROT1        <= HPROT1Q;
  end if;
end process p_AHBSigStoreComb;

-- -----------------------------------------------------------------------------
-- Register HADDR and AHB control signals for read write operation
-- -----------------------------------------------------------------------------
p_RegHADDRSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HADDRQ           <= (others => '0');
    HWRITEQ          <= '0';
    HPROT1Q          <= '0';
    TransferValidQ   <= '0';
    TransSizeErrQ    <= "00";
  elsif (HCLK'event and HCLK = '1') then
    HADDRQ           <= NxtHADDR;
    HWRITEQ          <= NxtHWRITE;
    HPROT1Q          <= NxtHPROT1;
    TransferValidQ   <= TransferValid;
    TransSizeErrQ(0) <= TransferSizeErr;
    TransSizeErrQ(1) <= TransSizeErrQ(0);
  end if;
end process p_RegHADDRSeq;

-- -----------------------------------------------------------------------------
-- Generate error response if invalid transfer size is detected
-- -----------------------------------------------------------------------------
HRESP            <= "01" when (TransSizeErrQ /= "00")
                 else
                    "00";

-- -----------------------------------------------------------------------------
-- Generate HREADYOUT
-- When the access is to the vector address registers or to the priority
-- registers or if the access to the registers with HSIZE other than WORD then
-- deassert the HREADYOUT for one clock
-- -----------------------------------------------------------------------------
HREADYOUT  <= ((not(OneWaitSt1Q and not(OneWaitSt2Q))) and
              not(TransSizeErrQ(0)));

-- -----------------------------------------------------------------------------
-- Generate read and write enable controls for registers
-- Privileged accesses are allowed when ProtectionEnable bit is high.
-- If the normal access is performed with the ProtectionEnable high then read
-- and write enables are not asserted.
-- If the ProtectionEnable is low, then both the normal and privileged accesses
-- are valid.
-- -----------------------------------------------------------------------------
p_EnableComb : process (TransferValid, ProtEnQ, HWRITE, HPROT1)
begin
  if ((TransferValid = '1') and (((ProtEnQ = '1') and (HPROT1 = '1')) or
      (ProtEnQ = '0'))) then
    NxtReadEnable    <= not(HWRITE);
    NxtWriteEnable   <= HWRITE;
  else
    NxtReadEnable    <= '0';
    NxtWriteEnable   <= '0';
  end if;
end process p_EnableComb;

-- -----------------------------------------------------------------------------
-- Sequential circuit to register the Read and write enable
-- -----------------------------------------------------------------------------
p_EnableSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ReadEnable       <= '0';
    WriteEnable      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ReadEnable       <= NxtReadEnable;
    WriteEnable      <= NxtWriteEnable;
  end if;
end process p_EnableSeq;

-- -----------------------------------------------------------------------------
-- Combinational circuit for register write
-- -----------------------------------------------------------------------------
p_RegWriteComb : process (WriteEnable, HADDRQ, HWDATA, VectAddr0Q,
                          VectAddr1Q, VectAddr2Q, VectAddr3Q, VectAddr4Q,
                          VectAddr5Q, VectAddr6Q, VectAddr7Q, VectAddr8Q,
                          VectAddr9Q, VectAddr10Q, VectAddr11Q,
                          VectAddr12Q, VectAddr13Q, VectAddr14Q,
                          VectAddr15Q, VectAddr16Q, VectAddr17Q,
                          VectAddr18Q, VectAddr19Q, VectAddr20Q,
                          VectAddr21Q, VectAddr22Q, VectAddr23Q,
                          VectAddr24Q, VectAddr25Q, VectAddr26Q,
                          VectAddr27Q, VectAddr28Q, VectAddr29Q,
                          VectAddr30Q, VectAddr31Q, VectPrio0Q, VectPrio1Q,
                          VectPrio2Q, VectPrio3Q, VectPrio4Q, VectPrio5Q,
                          VectPrio6Q, VectPrio7Q, VectPrio8Q, VectPrio9Q,
                          VectPrio10Q, VectPrio11Q, VectPrio12Q,
                          VectPrio13Q, VectPrio14Q, VectPrio15Q,
                          VectPrio16Q, VectPrio17Q, VectPrio18Q,
                          VectPrio19Q, VectPrio20Q, VectPrio21Q,
                          VectPrio22Q, VectPrio23Q, VectPrio24Q,
                          VectPrio25Q, VectPrio26Q, VectPrio27Q,
                          VectPrio28Q, VectPrio29Q, VectPrio30Q,
                          VectPrio31Q, VICIntSelQ, VICIntEnQ, VICSoftIntQ,
                          SWPrioMaskQ, VectPrio32Q, VICITCRQ, VICITIP1Q,
                          VICITIP2Q, VICITOP1Q, VICITOP2Q)
begin
  NxtVectAddr0     <= VectAddr0Q;
  NxtVectAddr1     <= VectAddr1Q;
  NxtVectAddr2     <= VectAddr2Q;
  NxtVectAddr3     <= VectAddr3Q;
  NxtVectAddr4     <= VectAddr4Q;
  NxtVectAddr5     <= VectAddr5Q;
  NxtVectAddr6     <= VectAddr6Q;
  NxtVectAddr7     <= VectAddr7Q;
  NxtVectAddr8     <= VectAddr8Q;
  NxtVectAddr9     <= VectAddr9Q;
  NxtVectAddr10    <= VectAddr10Q;
  NxtVectAddr11    <= VectAddr11Q;
  NxtVectAddr12    <= VectAddr12Q;
  NxtVectAddr13    <= VectAddr13Q;
  NxtVectAddr14    <= VectAddr14Q;
  NxtVectAddr15    <= VectAddr15Q;
  NxtVectAddr16    <= VectAddr16Q;
  NxtVectAddr17    <= VectAddr17Q;
  NxtVectAddr18    <= VectAddr18Q;
  NxtVectAddr19    <= VectAddr19Q;
  NxtVectAddr20    <= VectAddr20Q;
  NxtVectAddr21    <= VectAddr21Q;
  NxtVectAddr22    <= VectAddr22Q;
  NxtVectAddr23    <= VectAddr23Q;
  NxtVectAddr24    <= VectAddr24Q;
  NxtVectAddr25    <= VectAddr25Q;
  NxtVectAddr26    <= VectAddr26Q;
  NxtVectAddr27    <= VectAddr27Q;
  NxtVectAddr28    <= VectAddr28Q;
  NxtVectAddr29    <= VectAddr29Q;
  NxtVectAddr30    <= VectAddr30Q;
  NxtVectAddr31    <= VectAddr31Q;
  NxtVectPrio0     <= VectPrio0Q;
  NxtVectPrio1     <= VectPrio1Q;
  NxtVectPrio2     <= VectPrio2Q;
  NxtVectPrio3     <= VectPrio3Q;
  NxtVectPrio4     <= VectPrio4Q;
  NxtVectPrio5     <= VectPrio5Q;
  NxtVectPrio6     <= VectPrio6Q;
  NxtVectPrio7     <= VectPrio7Q;
  NxtVectPrio8     <= VectPrio8Q;
  NxtVectPrio9     <= VectPrio9Q;
  NxtVectPrio10    <= VectPrio10Q;
  NxtVectPrio11    <= VectPrio11Q;
  NxtVectPrio12    <= VectPrio12Q;
  NxtVectPrio13    <= VectPrio13Q;
  NxtVectPrio14    <= VectPrio14Q;
  NxtVectPrio15    <= VectPrio15Q;
  NxtVectPrio16    <= VectPrio16Q;
  NxtVectPrio17    <= VectPrio17Q;
  NxtVectPrio18    <= VectPrio18Q;
  NxtVectPrio19    <= VectPrio19Q;
  NxtVectPrio20    <= VectPrio20Q;
  NxtVectPrio21    <= VectPrio21Q;
  NxtVectPrio22    <= VectPrio22Q;
  NxtVectPrio23    <= VectPrio23Q;
  NxtVectPrio24    <= VectPrio24Q;
  NxtVectPrio25    <= VectPrio25Q;
  NxtVectPrio26    <= VectPrio26Q;
  NxtVectPrio27    <= VectPrio27Q;
  NxtVectPrio28    <= VectPrio28Q;
  NxtVectPrio29    <= VectPrio29Q;
  NxtVectPrio30    <= VectPrio30Q;
  NxtVectPrio31    <= VectPrio31Q;
  NxtVICIntSel     <= VICIntSelQ;
  NxtVICIntEn      <= VICIntEnQ;
  NxtVICSoftInt    <= VICSoftIntQ;
  NxtSWPrioMask    <= SWPrioMaskQ;
  NxtVectPrio32    <= VectPrio32Q;
  NxtVICITCR       <= VICITCRQ;
  NxtVICITIP1      <= VICITIP1Q;
  NxtVICITIP2      <= VICITIP2Q;
  NxtVICITOP1      <= VICITOP1Q;
  NxtVICITOP2      <= VICITOP2Q;
  if (WriteEnable = '1') then
    case HADDRQ(11 downto 2) is
        when HADDR_VICVECTADDR0 =>
          NxtVectAddr0     <= HWDATA;
        when HADDR_VICVECTADDR1 =>
          NxtVectAddr1     <= HWDATA;
        when HADDR_VICVECTADDR2 =>
          NxtVectAddr2     <= HWDATA;
        when HADDR_VICVECTADDR3 =>
          NxtVectAddr3     <= HWDATA;
        when HADDR_VICVECTADDR4 =>
          NxtVectAddr4     <= HWDATA;
        when HADDR_VICVECTADDR5 =>
          NxtVectAddr5     <= HWDATA;
        when HADDR_VICVECTADDR6 =>
          NxtVectAddr6     <= HWDATA;
        when HADDR_VICVECTADDR7 =>
          NxtVectAddr7     <= HWDATA;
        when HADDR_VICVECTADDR8 =>
          NxtVectAddr8     <= HWDATA;
        when HADDR_VICVECTADDR9 =>
          NxtVectAddr9     <= HWDATA;
        when HADDR_VICVECTADDR10 =>
          NxtVectAddr10    <= HWDATA;
        when HADDR_VICVECTADDR11 =>
          NxtVectAddr11    <= HWDATA;
        when HADDR_VICVECTADDR12 =>
          NxtVectAddr12    <= HWDATA;
        when HADDR_VICVECTADDR13 =>
          NxtVectAddr13    <= HWDATA;
        when HADDR_VICVECTADDR14 =>
          NxtVectAddr14    <= HWDATA;
        when HADDR_VICVECTADDR15 =>
          NxtVectAddr15    <= HWDATA;
        when HADDR_VICVECTADDR16 =>
          NxtVectAddr16    <= HWDATA;
        when HADDR_VICVECTADDR17 =>
          NxtVectAddr17    <= HWDATA;
        when HADDR_VICVECTADDR18 =>
          NxtVectAddr18    <= HWDATA;
        when HADDR_VICVECTADDR19 =>
          NxtVectAddr19    <= HWDATA;
        when HADDR_VICVECTADDR20 =>
          NxtVectAddr20    <= HWDATA;
        when HADDR_VICVECTADDR21 =>
          NxtVectAddr21    <= HWDATA;
        when HADDR_VICVECTADDR22 =>
          NxtVectAddr22    <= HWDATA;
        when HADDR_VICVECTADDR23 =>
          NxtVectAddr23    <= HWDATA;
        when HADDR_VICVECTADDR24 =>
          NxtVectAddr24    <= HWDATA;
        when HADDR_VICVECTADDR25 =>
          NxtVectAddr25    <= HWDATA;
        when HADDR_VICVECTADDR26 =>
          NxtVectAddr26    <= HWDATA;
        when HADDR_VICVECTADDR27 =>
          NxtVectAddr27    <= HWDATA;
        when HADDR_VICVECTADDR28 =>
          NxtVectAddr28    <= HWDATA;
        when HADDR_VICVECTADDR29 =>
          NxtVectAddr29    <= HWDATA;
        when HADDR_VICVECTADDR30 =>
          NxtVectAddr30    <= HWDATA;
        when HADDR_VICVECTADDR31 =>
          NxtVectAddr31    <= HWDATA;
        when HADDR_VICPRIORITY0 =>
          NxtVectPrio0     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY1 =>
          NxtVectPrio1     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY2 =>
          NxtVectPrio2     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY3 =>
          NxtVectPrio3     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY4 =>
          NxtVectPrio4     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY5 =>
          NxtVectPrio5     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY6 =>
          NxtVectPrio6     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY7 =>
          NxtVectPrio7     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY8 =>
          NxtVectPrio8     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY9 =>
          NxtVectPrio9     <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY10 =>
          NxtVectPrio10    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY11 =>
          NxtVectPrio11    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY12 =>
          NxtVectPrio12    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY13 =>
          NxtVectPrio13    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY14 =>
          NxtVectPrio14    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY15 =>
          NxtVectPrio15    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY16 =>
          NxtVectPrio16    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY17 =>
          NxtVectPrio17    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY18 =>
          NxtVectPrio18    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY19 =>
          NxtVectPrio19    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY20 =>
          NxtVectPrio20    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY21 =>
          NxtVectPrio21    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY22 =>
          NxtVectPrio22    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY23 =>
          NxtVectPrio23    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY24 =>
          NxtVectPrio24    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY25 =>
          NxtVectPrio25    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY26 =>
          NxtVectPrio26    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY27 =>
          NxtVectPrio27    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY28 =>
          NxtVectPrio28    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY29 =>
          NxtVectPrio29    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY30 =>
          NxtVectPrio30    <= HWDATA(3 downto 0);
        when HADDR_VICPRIORITY31 =>
          NxtVectPrio31    <= HWDATA(3 downto 0);
        when HADDR_VICINTSELECT =>
          NxtVICIntSel     <= HWDATA;
        when HADDR_VICINTENABLE =>
          NxtVICIntEn      <= (HWDATA or VICIntEnQ);
        when HADDR_VICINTENCLEAR =>
          NxtVICIntEn      <= (not(HWDATA) and VICIntEnQ);
        when HADDR_VICSOFTINT =>
          NxtVICSoftInt    <= (HWDATA or VICSoftIntQ);
        when HADDR_VICSOFTINTCLEAR =>
          NxtVICSoftInt    <= (not(HWDATA) and VICSoftIntQ);
        when HADDR_VICSWPRIORITYMASK =>
          NxtSWPrioMask    <= HWDATA(15 downto 0);
        when HADDR_VICSWPRIORITYDAISY =>
          NxtVectPrio32    <= HWDATA(3 downto 0);
        when HADDR_VICITCR =>
          NxtVICITCR       <= HWDATA(1 downto 0);
        when HADDR_VICITIP1 =>
          NxtVICITIP1      <= HWDATA(8 downto 6);
        when HADDR_VICITIP2 =>
          NxtVICITIP2      <= HWDATA;
        when HADDR_VICITOP1 =>
          NxtVICITOP1      <= HWDATA(9 downto 6);
        when HADDR_VICITOP2 =>
          NxtVICITOP2      <= HWDATA;
         when others =>
            NxtVectAddr0     <= VectAddr0Q;
            NxtVectAddr1     <= VectAddr1Q;
            NxtVectAddr2     <= VectAddr2Q;
            NxtVectAddr3     <= VectAddr3Q;
            NxtVectAddr4     <= VectAddr4Q;
            NxtVectAddr5     <= VectAddr5Q;
            NxtVectAddr6     <= VectAddr6Q;
            NxtVectAddr7     <= VectAddr7Q;
            NxtVectAddr8     <= VectAddr8Q;
            NxtVectAddr9     <= VectAddr9Q;
            NxtVectAddr10    <= VectAddr10Q;
            NxtVectAddr11    <= VectAddr11Q;
            NxtVectAddr12    <= VectAddr12Q;
            NxtVectAddr13    <= VectAddr13Q;
            NxtVectAddr14    <= VectAddr14Q;
            NxtVectAddr15    <= VectAddr15Q;
            NxtVectAddr16    <= VectAddr16Q;
            NxtVectAddr17    <= VectAddr17Q;
            NxtVectAddr18    <= VectAddr18Q;
            NxtVectAddr19    <= VectAddr19Q;
            NxtVectAddr20    <= VectAddr20Q;
            NxtVectAddr21    <= VectAddr21Q;
            NxtVectAddr22    <= VectAddr22Q;
            NxtVectAddr23    <= VectAddr23Q;
            NxtVectAddr24    <= VectAddr24Q;
            NxtVectAddr25    <= VectAddr25Q;
            NxtVectAddr26    <= VectAddr26Q;
            NxtVectAddr27    <= VectAddr27Q;
            NxtVectAddr28    <= VectAddr28Q;
            NxtVectAddr29    <= VectAddr29Q;
            NxtVectAddr30    <= VectAddr30Q;
            NxtVectAddr31    <= VectAddr31Q;
            NxtVectPrio0     <= VectPrio0Q;
            NxtVectPrio1     <= VectPrio1Q;
            NxtVectPrio2     <= VectPrio2Q;
            NxtVectPrio3     <= VectPrio3Q;
            NxtVectPrio4     <= VectPrio4Q;
            NxtVectPrio5     <= VectPrio5Q;
            NxtVectPrio6     <= VectPrio6Q;
            NxtVectPrio7     <= VectPrio7Q;
            NxtVectPrio8     <= VectPrio8Q;
            NxtVectPrio9     <= VectPrio9Q;
            NxtVectPrio10    <= VectPrio10Q;
            NxtVectPrio11    <= VectPrio11Q;
            NxtVectPrio12    <= VectPrio12Q;
            NxtVectPrio13    <= VectPrio13Q;
            NxtVectPrio14    <= VectPrio14Q;
            NxtVectPrio15    <= VectPrio15Q;
            NxtVectPrio16    <= VectPrio16Q;
            NxtVectPrio17    <= VectPrio17Q;
            NxtVectPrio18    <= VectPrio18Q;
            NxtVectPrio19    <= VectPrio19Q;
            NxtVectPrio20    <= VectPrio20Q;
            NxtVectPrio21    <= VectPrio21Q;
            NxtVectPrio22    <= VectPrio22Q;
            NxtVectPrio23    <= VectPrio23Q;
            NxtVectPrio24    <= VectPrio24Q;
            NxtVectPrio25    <= VectPrio25Q;
            NxtVectPrio26    <= VectPrio26Q;
            NxtVectPrio27    <= VectPrio27Q;
            NxtVectPrio28    <= VectPrio28Q;
            NxtVectPrio29    <= VectPrio29Q;
            NxtVectPrio30    <= VectPrio30Q;
            NxtVectPrio31    <= VectPrio31Q;
            NxtVICIntSel     <= VICIntSelQ;
            NxtVICIntEn      <= VICIntEnQ;
            NxtVICSoftInt    <= VICSoftIntQ;
            NxtSWPrioMask    <= SWPrioMaskQ;
            NxtVectPrio32    <= VectPrio32Q;
            NxtVICITCR       <= VICITCRQ;
            NxtVICITIP1      <= VICITIP1Q;
            NxtVICITIP2      <= VICITIP2Q;
            NxtVICITOP1      <= VICITOP1Q;
            NxtVICITOP2      <= VICITOP2Q;
      end case;
  end if;
end process p_RegWriteComb;

-- -----------------------------------------------------------------------------
-- Clock the register write
-- -----------------------------------------------------------------------------
p_RegWriteSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VectAddr0Q       <= (others => '0');
    VectAddr1Q       <= (others => '0');
    VectAddr2Q       <= (others => '0');
    VectAddr3Q       <= (others => '0');
    VectAddr4Q       <= (others => '0');
    VectAddr5Q       <= (others => '0');
    VectAddr6Q       <= (others => '0');
    VectAddr7Q       <= (others => '0');
    VectAddr8Q       <= (others => '0');
    VectAddr9Q       <= (others => '0');
    VectAddr10Q      <= (others => '0');
    VectAddr11Q      <= (others => '0');
    VectAddr12Q      <= (others => '0');
    VectAddr13Q      <= (others => '0');
    VectAddr14Q      <= (others => '0');
    VectAddr15Q      <= (others => '0');
    VectAddr16Q      <= (others => '0');
    VectAddr17Q      <= (others => '0');
    VectAddr18Q      <= (others => '0');
    VectAddr19Q      <= (others => '0');
    VectAddr20Q      <= (others => '0');
    VectAddr21Q      <= (others => '0');
    VectAddr22Q      <= (others => '0');
    VectAddr23Q      <= (others => '0');
    VectAddr24Q      <= (others => '0');
    VectAddr25Q      <= (others => '0');
    VectAddr26Q      <= (others => '0');
    VectAddr27Q      <= (others => '0');
    VectAddr28Q      <= (others => '0');
    VectAddr29Q      <= (others => '0');
    VectAddr30Q      <= (others => '0');
    VectAddr31Q      <= (others => '0');
    VectPrio0Q       <= (others => '1');
    VectPrio1Q       <= (others => '1');
    VectPrio2Q       <= (others => '1');
    VectPrio3Q       <= (others => '1');
    VectPrio4Q       <= (others => '1');
    VectPrio5Q       <= (others => '1');
    VectPrio6Q       <= (others => '1');
    VectPrio7Q       <= (others => '1');
    VectPrio8Q       <= (others => '1');
    VectPrio9Q       <= (others => '1');
    VectPrio10Q      <= (others => '1');
    VectPrio11Q      <= (others => '1');
    VectPrio12Q      <= (others => '1');
    VectPrio13Q      <= (others => '1');
    VectPrio14Q      <= (others => '1');
    VectPrio15Q      <= (others => '1');
    VectPrio16Q      <= (others => '1');
    VectPrio17Q      <= (others => '1');
    VectPrio18Q      <= (others => '1');
    VectPrio19Q      <= (others => '1');
    VectPrio20Q      <= (others => '1');
    VectPrio21Q      <= (others => '1');
    VectPrio22Q      <= (others => '1');
    VectPrio23Q      <= (others => '1');
    VectPrio24Q      <= (others => '1');
    VectPrio25Q      <= (others => '1');
    VectPrio26Q      <= (others => '1');
    VectPrio27Q      <= (others => '1');
    VectPrio28Q      <= (others => '1');
    VectPrio29Q      <= (others => '1');
    VectPrio30Q      <= (others => '1');
    VectPrio31Q      <= (others => '1');
    VectPrio32Q      <= (others => '1');
    VICADDRESSQ      <= (others => '0');
    VICSoftIntQ      <= (others => '0');
    VICIntEnQ        <= (others => '0');
    VICIntSelQ       <= (others => '0');
    SWPrioMaskQ      <= (others => '1');
    VICITCRQ         <= (others => '0');
    VICITIP1Q        <= (others => '0');
    VICITIP2Q        <= (others => '0');
    VICITOP1Q        <= (others => '0');
    VICITOP2Q        <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    VectAddr0Q       <= NxtVectAddr0;
    VectAddr1Q       <= NxtVectAddr1;
    VectAddr2Q       <= NxtVectAddr2;
    VectAddr3Q       <= NxtVectAddr3;
    VectAddr4Q       <= NxtVectAddr4;
    VectAddr5Q       <= NxtVectAddr5;
    VectAddr6Q       <= NxtVectAddr6;
    VectAddr7Q       <= NxtVectAddr7;
    VectAddr8Q       <= NxtVectAddr8;
    VectAddr9Q       <= NxtVectAddr9;
    VectAddr10Q      <= NxtVectAddr10;
    VectAddr11Q      <= NxtVectAddr11;
    VectAddr12Q      <= NxtVectAddr12;
    VectAddr13Q      <= NxtVectAddr13;
    VectAddr14Q      <= NxtVectAddr14;
    VectAddr15Q      <= NxtVectAddr15;
    VectAddr16Q      <= NxtVectAddr16;
    VectAddr17Q      <= NxtVectAddr17;
    VectAddr18Q      <= NxtVectAddr18;
    VectAddr19Q      <= NxtVectAddr19;
    VectAddr20Q      <= NxtVectAddr20;
    VectAddr21Q      <= NxtVectAddr21;
    VectAddr22Q      <= NxtVectAddr22;
    VectAddr23Q      <= NxtVectAddr23;
    VectAddr24Q      <= NxtVectAddr24;
    VectAddr25Q      <= NxtVectAddr25;
    VectAddr26Q      <= NxtVectAddr26;
    VectAddr27Q      <= NxtVectAddr27;
    VectAddr28Q      <= NxtVectAddr28;
    VectAddr29Q      <= NxtVectAddr29;
    VectAddr30Q      <= NxtVectAddr30;
    VectAddr31Q      <= NxtVectAddr31;
    VectPrio0Q       <= NxtVectPrio0;
    VectPrio1Q       <= NxtVectPrio1;
    VectPrio2Q       <= NxtVectPrio2;
    VectPrio3Q       <= NxtVectPrio3;
    VectPrio4Q       <= NxtVectPrio4;
    VectPrio5Q       <= NxtVectPrio5;
    VectPrio6Q       <= NxtVectPrio6;
    VectPrio7Q       <= NxtVectPrio7;
    VectPrio8Q       <= NxtVectPrio8;
    VectPrio9Q       <= NxtVectPrio9;
    VectPrio10Q      <= NxtVectPrio10;
    VectPrio11Q      <= NxtVectPrio11;
    VectPrio12Q      <= NxtVectPrio12;
    VectPrio13Q      <= NxtVectPrio13;
    VectPrio14Q      <= NxtVectPrio14;
    VectPrio15Q      <= NxtVectPrio15;
    VectPrio16Q      <= NxtVectPrio16;
    VectPrio17Q      <= NxtVectPrio17;
    VectPrio18Q      <= NxtVectPrio18;
    VectPrio19Q      <= NxtVectPrio19;
    VectPrio20Q      <= NxtVectPrio20;
    VectPrio21Q      <= NxtVectPrio21;
    VectPrio22Q      <= NxtVectPrio22;
    VectPrio23Q      <= NxtVectPrio23;
    VectPrio24Q      <= NxtVectPrio24;
    VectPrio25Q      <= NxtVectPrio25;
    VectPrio26Q      <= NxtVectPrio26;
    VectPrio27Q      <= NxtVectPrio27;
    VectPrio28Q      <= NxtVectPrio28;
    VectPrio29Q      <= NxtVectPrio29;
    VectPrio30Q      <= NxtVectPrio30;
    VectPrio31Q      <= NxtVectPrio31;
    VICADDRESSQ      <= VICVectAddrVal;
    VICIntSelQ       <= NxtVICIntSel;
    VICIntEnQ        <= NxtVICIntEn;
    VICSoftIntQ      <= NxtVICSoftInt;
    SWPrioMaskQ      <= NxtSWPrioMask;
    VectPrio32Q      <= NxtVectPrio32;
    VICITCRQ         <= NxtVICITCR;
    VICITIP1Q        <= NxtVICITIP1;
    VICITIP2Q        <= NxtVICITIP2;
    VICITOP1Q        <= NxtVICITOP1;
    VICITOP2Q        <= NxtVICITOP2;
  end if;
end process p_RegWriteSeq;

-- -----------------------------------------------------------------------------
-- Registering the integration test read back value
-- -----------------------------------------------------------------------------
p_ITestSampleSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    IRQACKTestValQ1  <= '0';
    nIRQINTestValQ1  <= '0';
    nFIQINTestValQ1  <= '0';
    IRQTestValQ1     <= '0';
    FIQTestValQ1     <= '0';
    ACKOUTTestValQ1  <= '0';
    IRQACKTestValQ2  <= '0';
    nIRQINTestValQ2  <= '0';
    nFIQINTestValQ2  <= '0';
    IRQTestValQ2     <= '0';
    FIQTestValQ2     <= '0';
    ACKOUTTestValQ2  <= '0';
  elsif (HCLK'event and HCLK = '1') then
    IRQACKTestValQ1  <= IRQACKTestVal;
    nIRQINTestValQ1  <= nIRQINTestVal;
    nFIQINTestValQ1  <= nFIQINTestVal;
    IRQTestValQ1     <= IRQTestVal;
    FIQTestValQ1     <= FIQTestVal;
    ACKOUTTestValQ1  <= ACKOUTTestVal;
    IRQACKTestValQ2  <= IRQACKTestValQ1;
    nIRQINTestValQ2  <= nIRQINTestValQ1;
    nFIQINTestValQ2  <= nFIQINTestValQ1;
    IRQTestValQ2     <= IRQTestValQ1;
    FIQTestValQ2     <= FIQTestValQ1;
    ACKOUTTestValQ2  <= ACKOUTTestValQ1;
  end if;
end process p_ITestSampleSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the status of the interrupts before starting read by software
-- -----------------------------------------------------------------------------
p_IntStatSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VICFIQStatusQ1   <= (others => '0');
    VICFIQStatusQ2   <= (others => '0');
    VICIRQStatusQ1   <= (others => '0');
    VICIRQStatusQ2   <= (others => '0');
    VICRawIntrQ1     <= (others => '0');
    VICRawIntrQ2     <= (others => '0');
    VICIntSourceQ1   <= (others => '0');
    VICIntSourceQ2   <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    VICFIQStatusQ1   <= VICFIQStatus;
    VICFIQStatusQ2   <= VICFIQStatusQ1;
    VICIRQStatusQ1   <= VICIRQStatus;
    VICIRQStatusQ2   <= VICIRQStatusQ1;
    VICRawIntrQ1     <= VICRawIntr;
    VICRawIntrQ2     <= VICRawIntrQ1;
    VICIntSourceQ1   <= VICINTSOURCE;
    VICIntSourceQ2   <= VICIntSourceQ1;
  end if;
end process p_IntStatSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic to generate the IntSStatus. Status bit can be cleared
-- by writing into the IntSStatusClear register
-- -----------------------------------------------------------------------------
p_IntSStatusComb : process (WriteEnable, HADDRQ, VICIntSourceQ2, HWDATA,
                            IntSStatusQ, VICITCRQ)
begin
  if ((WriteEnable = '1') and
      (HADDRQ(11 downto 2) = HADDR_VICINTSSTATUSCLEAR) and
      (VICITCRQ(1) = '1')) then
    NxtIntSStatus    <= ((IntSStatusQ or VICIntSourceQ2) and not(HWDATA));
  elsif (VICITCRQ(1)= '1') then
    NxtIntSStatus    <= (IntSStatusQ or VICIntSourceQ2);
  else
    NxtIntSStatus    <= IntSStatusQ;
  end if;
end process p_IntSStatusComb;

-- -----------------------------------------------------------------------------
-- Sequential circuit to generate the IntSStatus.
-- -----------------------------------------------------------------------------
p_IntSStatusSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    IntSStatusQ      <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    IntSStatusQ      <= NxtIntSStatus;
  end if;
end process p_IntSStatusSeq;

-- -----------------------------------------------------------------------------
-- Clock the VICIRQINREG and VICFIQINREG
-- -----------------------------------------------------------------------------
p_IntInRegisterSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    VICIRQINREGQ      <= '0';
    VICFIQINREGQ      <= '0';
  elsif (HCLK'event and HCLK = '1') then
    VICIRQINREGQ      <= VICIRQINREG;  
    VICFIQINREGQ      <= VICFIQINREG;
  end if;
end process p_IntInRegisterSeq;
-- -----------------------------------------------------------------------------
-- Register read operation. When the AHB initiates the read operation to the
-- vector address registers, combinatorially generate the input of the flip
-- flop of the HRDATA for the access of address registers.
-- -----------------------------------------------------------------------------
p_RegRead1Comb : process (HADDRQ, ReadEnable, VectAddr0Q, VectAddr1Q,
                          VectAddr2Q, VectAddr3Q, VectAddr4Q, VectAddr5Q,
                          VectAddr6Q, VectAddr7Q, VectAddr8Q, VectAddr9Q,
                          VectAddr10Q, VectAddr11Q, VectAddr12Q,
                          VectAddr13Q, VectAddr14Q, VectAddr15Q,
                          VectAddr16Q, VectAddr17Q, VectAddr18Q,
                          VectAddr19Q, VectAddr20Q, VectAddr21Q,
                          VectAddr22Q, VectAddr23Q, VectAddr24Q,
                          VectAddr25Q, VectAddr26Q, VectAddr27Q,
                          VectAddr28Q, VectAddr29Q, VectAddr30Q,
                          VectAddr31Q)
begin
  if (ReadEnable = '1') then
    case HADDRQ is
        when HADDR_VICVECTADDR0 =>
          NxtHRDATA1       <= VectAddr0Q;
        when HADDR_VICVECTADDR1 =>
          NxtHRDATA1       <= VectAddr1Q;
        when HADDR_VICVECTADDR2 =>
          NxtHRDATA1       <= VectAddr2Q;
        when HADDR_VICVECTADDR3 =>
          NxtHRDATA1       <= VectAddr3Q;
        when HADDR_VICVECTADDR4 =>
          NxtHRDATA1       <= VectAddr4Q;
        when HADDR_VICVECTADDR5 =>
          NxtHRDATA1       <= VectAddr5Q;
        when HADDR_VICVECTADDR6 =>
          NxtHRDATA1       <= VectAddr6Q;
        when HADDR_VICVECTADDR7 =>
          NxtHRDATA1       <= VectAddr7Q;
        when HADDR_VICVECTADDR8 =>
          NxtHRDATA1       <= VectAddr8Q;
        when HADDR_VICVECTADDR9 =>
          NxtHRDATA1       <= VectAddr9Q;
        when HADDR_VICVECTADDR10 =>
          NxtHRDATA1       <= VectAddr10Q;
        when HADDR_VICVECTADDR11 =>
          NxtHRDATA1       <= VectAddr11Q;
        when HADDR_VICVECTADDR12 =>
          NxtHRDATA1       <= VectAddr12Q;
        when HADDR_VICVECTADDR13 =>
          NxtHRDATA1       <= VectAddr13Q;
        when HADDR_VICVECTADDR14 =>
          NxtHRDATA1       <= VectAddr14Q;
        when HADDR_VICVECTADDR15 =>
          NxtHRDATA1       <= VectAddr15Q;
        when HADDR_VICVECTADDR16 =>
          NxtHRDATA1       <= VectAddr16Q;
        when HADDR_VICVECTADDR17 =>
          NxtHRDATA1       <= VectAddr17Q;
        when HADDR_VICVECTADDR18 =>
          NxtHRDATA1       <= VectAddr18Q;
        when HADDR_VICVECTADDR19 =>
          NxtHRDATA1       <= VectAddr19Q;
        when HADDR_VICVECTADDR20 =>
          NxtHRDATA1       <= VectAddr20Q;
        when HADDR_VICVECTADDR21 =>
          NxtHRDATA1       <= VectAddr21Q;
        when HADDR_VICVECTADDR22 =>
          NxtHRDATA1       <= VectAddr22Q;
        when HADDR_VICVECTADDR23 =>
          NxtHRDATA1       <= VectAddr23Q;
        when HADDR_VICVECTADDR24 =>
          NxtHRDATA1       <= VectAddr24Q;
        when HADDR_VICVECTADDR25 =>
          NxtHRDATA1       <= VectAddr25Q;
        when HADDR_VICVECTADDR26 =>
          NxtHRDATA1       <= VectAddr26Q;
        when HADDR_VICVECTADDR27 =>
          NxtHRDATA1       <= VectAddr27Q;
        when HADDR_VICVECTADDR28 =>
          NxtHRDATA1       <= VectAddr28Q;
        when HADDR_VICVECTADDR29 =>
          NxtHRDATA1       <= VectAddr29Q;
        when HADDR_VICVECTADDR30 =>
          NxtHRDATA1       <= VectAddr30Q;
        when HADDR_VICVECTADDR31 =>
          NxtHRDATA1       <= VectAddr31Q;
        when others =>
          NxtHRDATA1       <= (others => '0');
       end case;
  else
    NxtHRDATA1       <= (others => '0');
  end if;
end process p_RegRead1Comb;

-- -----------------------------------------------------------------------------
-- Register read operation. When the AHB initiates the read operation to the
-- vector priority registers, combinatorially generate the input of the flip
-- flop of the HRDATA for the access of priority registers.
-- -----------------------------------------------------------------------------
p_RegRead2Comb : process (HADDRQ, ReadEnable, VectPrio0Q, VectPrio1Q,
                          VectPrio2Q, VectPrio3Q, VectPrio4Q, VectPrio5Q,
                          VectPrio6Q, VectPrio7Q, VectPrio8Q, VectPrio9Q,
                          VectPrio10Q, VectPrio11Q, VectPrio12Q,
                          VectPrio13Q, VectPrio14Q, VectPrio15Q,
                          VectPrio16Q, VectPrio17Q, VectPrio18Q,
                          VectPrio19Q, VectPrio20Q, VectPrio21Q,
                          VectPrio22Q, VectPrio23Q, VectPrio24Q,
                          VectPrio25Q, VectPrio26Q, VectPrio27Q,
                          VectPrio28Q, VectPrio29Q, VectPrio30Q,
                          VectPrio31Q)
begin
  if (ReadEnable = '1') then
    case HADDRQ is
        when HADDR_VICPRIORITY0 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio0Q;
        when HADDR_VICPRIORITY1 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio1Q;
        when HADDR_VICPRIORITY2 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio2Q;
        when HADDR_VICPRIORITY3 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio3Q;
        when HADDR_VICPRIORITY4 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio4Q;
        when HADDR_VICPRIORITY5 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio5Q;
        when HADDR_VICPRIORITY6 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio6Q;
        when HADDR_VICPRIORITY7 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio7Q;
        when HADDR_VICPRIORITY8 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio8Q;
        when HADDR_VICPRIORITY9 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio9Q;
        when HADDR_VICPRIORITY10 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio10Q;
        when HADDR_VICPRIORITY11 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio11Q;
        when HADDR_VICPRIORITY12 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio12Q;
        when HADDR_VICPRIORITY13 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio13Q;
        when HADDR_VICPRIORITY14 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio14Q;
        when HADDR_VICPRIORITY15 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio15Q;
        when HADDR_VICPRIORITY16 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio16Q;
        when HADDR_VICPRIORITY17 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio17Q;
        when HADDR_VICPRIORITY18 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio18Q;
        when HADDR_VICPRIORITY19 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio19Q;
        when HADDR_VICPRIORITY20 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio20Q;
        when HADDR_VICPRIORITY21 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio21Q;
        when HADDR_VICPRIORITY22 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio22Q;
        when HADDR_VICPRIORITY23 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio23Q;
        when HADDR_VICPRIORITY24 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio24Q;
        when HADDR_VICPRIORITY25 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio25Q;
        when HADDR_VICPRIORITY26 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio26Q;
        when HADDR_VICPRIORITY27 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio27Q;
        when HADDR_VICPRIORITY28 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio28Q;
        when HADDR_VICPRIORITY29 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio29Q;
        when HADDR_VICPRIORITY30 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio30Q;
        when HADDR_VICPRIORITY31 =>
          NxtHRDATA2       <= TIELOW28 & VectPrio31Q;
        when others =>
          NxtHRDATA2       <= (others => '0');
      end case;
  else
    NxtHRDATA2       <= (others => '0');
  end if;
end process p_RegRead2Comb;

-- -----------------------------------------------------------------------------
-- Register read operation. When the AHB initiates the read to the control
-- registers, use the registered version of the HADDR to select the register.
-- -----------------------------------------------------------------------------
p_RegRead3Comb : process (HADDRQ, ReadEnable, SWPrioMaskQ, VICIRQStatusQ2,
                          VICFIQStatusQ2, VICRawIntrQ2, VICIntSelQ,
                          VICADDRESSQ, VICIntEnQ, VICSoftIntQ, ProtEnQ,
                          VectPrio32Q)
begin
  if (ReadEnable = '1') then
    case HADDRQ is
        when HADDR_VICIRQSTATUS =>
          HRDATA3          <= VICIRQStatusQ2;
        when HADDR_VICFIQSTATUS =>
          HRDATA3          <= VICFIQStatusQ2;
        when HADDR_VICADDRESS =>
          HRDATA3          <= VICADDRESSQ;
        when HADDR_VICRAWINTR =>
          HRDATA3          <= VICRawIntrQ2;
        when HADDR_VICINTSELECT=>
          HRDATA3          <= VICIntSelQ;
        when HADDR_VICINTENABLE =>
          HRDATA3          <= VICIntEnQ;
        when HADDR_VICINTENCLEAR =>
          HRDATA3          <= (others => '0');
        when HADDR_VICSOFTINT =>
          HRDATA3          <= VICSoftIntQ;
        when HADDR_VICSOFTINTCLEAR =>
          HRDATA3          <= (others => '0');
        when HADDR_VICPROTECTION =>
          HRDATA3          <= ("0000000000000000000000000000000" & ProtEnQ);
        when HADDR_VICSWPRIORITYMASK =>
          HRDATA3          <= TIELOW16 & SWPrioMaskQ;
        when HADDR_VICSWPRIORITYDAISY =>
          HRDATA3          <= TIELOW28 & VectPrio32Q;
        when others =>
          HRDATA3          <= (others => '0');
      end case;
  else
    HRDATA3          <= (others => '0');
  end if;
end process p_RegRead3Comb;

-- -----------------------------------------------------------------------------
-- Register read operation. When the AHB initiates the read to the peripheral
-- ID registers, use the registered version of the HADDR to select the register.
-- -----------------------------------------------------------------------------
p_RegRead4Comb : process (HADDRQ, ReadEnable, IDReadMux)
begin
  if (ReadEnable = '1') then
    case HADDRQ is
        when HADDR_VICPERIPHID0 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPERIPHID1 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPERIPHID2 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPERIPHID3 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPCELLID0 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPCELLID1 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPCELLID2 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when HADDR_VICPCELLID3 =>
          HRDATA4          <= TIELOW24 & IDReadMux;
        when others =>
          HRDATA4          <= (others => '0');
      end case;
  else
    HRDATA4          <= (others => '0');
  end if;
end process p_RegRead4Comb;

-- -----------------------------------------------------------------------------
-- Register read operation. When the AHB initiates the read to the integration
-- registers, use the registered version of the HADDR to select the register.
-- -----------------------------------------------------------------------------
p_RegRead5Comb : process (HADDRQ, ReadEnable, VICITCRQ, VICFIQINREGQ,
                          VICIRQINREGQ, IRQACKTestValQ2, nIRQINTestValQ2,
                          nFIQINTestValQ2, VADDRINTestVal, ACKOUTTestValQ2,
                          VADDRVTestVal, IRQTestValQ2, FIQTestValQ2,
                          VADDRTestVal, IntSStatusQ, TieLow)
begin
  if (ReadEnable = '1') then
    case HADDRQ is
        when HADDR_VICITCR =>
          HRDATA5          <= TieLow(29 downto 0) & VICITCRQ;
        when HADDR_VICITIP1 =>
          HRDATA5          <= TieLow(21 downto 1) & VICFIQINREGQ &
                             VICIRQINREGQ & IRQACKTestValQ2 &
                             nIRQINTestValQ2 & nFIQINTestValQ2 & "000000";
        when HADDR_VICITIP2 =>
          HRDATA5          <= VADDRINTestVal;
        when HADDR_VICITOP1 =>
          HRDATA5          <= TieLow(22 downto 1) & ACKOUTTestValQ2 &
                             VADDRVTestVal & IRQTestValQ2 & FIQTestValQ2 &
                             "000000";
        when HADDR_VICITOP2 =>
          HRDATA5          <= VADDRTestVal;
        when HADDR_VICINTSSTATUS =>
          HRDATA5          <= IntSStatusQ;
        when others =>
          HRDATA5          <= (others => '0');
      end case;
  else
    HRDATA5          <= (others => '0');
  end if;
end process p_RegRead5Comb;

-- -----------------------------------------------------------------------------
-- Register the AHB read data
-- -----------------------------------------------------------------------------
p_HRDATA1Seq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    HRDATA1          <= (others => '0');
    HRDATA2          <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    HRDATA1          <= NxtHRDATA1;
    HRDATA2          <= NxtHRDATA2;
  end if;
end process p_HRDATA1Seq;

-- -----------------------------------------------------------------------------
-- Select the different AHB read bus according to the registered AHB address.
-- -----------------------------------------------------------------------------
HRDATA <= (HRDATA1 or HRDATA2 or HRDATA3 or HRDATA4 or HRDATA5);

-- -----------------------------------------------------------------------------
-- Clocking the ID read
-- -----------------------------------------------------------------------------
p_IDRdMuxSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    IDReadMux        <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    IDReadMux        <= NxtIDReadMux;
  end if;
end process p_IDRdMuxSeq;

-- -----------------------------------------------------------------------------
-- Generate control signals for Priority logic
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Reading VICVectAddr (0x008) acknowledges the interrupt
-- -----------------------------------------------------------------------------
IRQSWAck         <= '1' when ((NxtReadEnable = '1') and
                              (HADDR = HADDR_VICADDRESS))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Writing VICVectAddr (0x008) clears the interrupt
-- -----------------------------------------------------------------------------
IRQSWClear       <= '1' when ((WriteEnable = '1') and
                              (HADDRQ = HADDR_VICADDRESS))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Combinational logic for the ID read
-- -----------------------------------------------------------------------------
p_IDReadComb : process (HREADYIN, HADDR, Revision, IDReadMux)
begin
  if (HREADYIN = '1') then
    case HADDR(4 downto 2) is
        when "000" =>
          NxtIDReadMux     <= PERIPHID0;
        when "001" =>
          NxtIDReadMux     <= PERIPHID1;
        when "010" =>
          NxtIDReadMux     <= Revision & PERIPHID2;
        when "011" =>
          NxtIDReadMux     <= PERIPHID3;
        when "100" =>
          NxtIDReadMux     <= PCELLID0;
        when "101" =>
          NxtIDReadMux     <= PCELLID1;
        when "110" =>
          NxtIDReadMux     <= PCELLID2;
        when others =>
          NxtIDReadMux     <= PCELLID3;
      end case;
  else
    NxtIDReadMux     <= IDReadMux;
  end if;
end process p_IDReadComb;

-- -----------------------------------------------------------------------------
-- Connect signals to top level
-- -----------------------------------------------------------------------------
VICSoftInt       <= VICSoftIntQ;
VICIntEnable     <= VICIntEnQ;
VICIntSelect     <= VICIntSelQ;
SWPriorityMask   <= SWPrioMaskQ;
VectAddr0        <= VectAddr0Q;
VectAddr1        <= VectAddr1Q;
VectAddr2        <= VectAddr2Q;
VectAddr3        <= VectAddr3Q;
VectAddr4        <= VectAddr4Q;
VectAddr5        <= VectAddr5Q;
VectAddr6        <= VectAddr6Q;
VectAddr7        <= VectAddr7Q;
VectAddr8        <= VectAddr8Q;
VectAddr9        <= VectAddr9Q;
VectAddr10       <= VectAddr10Q;
VectAddr11       <= VectAddr11Q;
VectAddr12       <= VectAddr12Q;
VectAddr13       <= VectAddr13Q;
VectAddr14       <= VectAddr14Q;
VectAddr15       <= VectAddr15Q;
VectAddr16       <= VectAddr16Q;
VectAddr17       <= VectAddr17Q;
VectAddr18       <= VectAddr18Q;
VectAddr19       <= VectAddr19Q;
VectAddr20       <= VectAddr20Q;
VectAddr21       <= VectAddr21Q;
VectAddr22       <= VectAddr22Q;
VectAddr23       <= VectAddr23Q;
VectAddr24       <= VectAddr24Q;
VectAddr25       <= VectAddr25Q;
VectAddr26       <= VectAddr26Q;
VectAddr27       <= VectAddr27Q;
VectAddr28       <= VectAddr28Q;
VectAddr29       <= VectAddr29Q;
VectAddr30       <= VectAddr30Q;
VectAddr31       <= VectAddr31Q;
VectPriority0    <= VectPrio0Q;
VectPriority1    <= VectPrio1Q;
VectPriority2    <= VectPrio2Q;
VectPriority3    <= VectPrio3Q;
VectPriority4    <= VectPrio4Q;
VectPriority5    <= VectPrio5Q;
VectPriority6    <= VectPrio6Q;
VectPriority7    <= VectPrio7Q;
VectPriority8    <= VectPrio8Q;
VectPriority9    <= VectPrio9Q;
VectPriority10   <= VectPrio10Q;
VectPriority11   <= VectPrio11Q;
VectPriority12   <= VectPrio12Q;
VectPriority13   <= VectPrio13Q;
VectPriority14   <= VectPrio14Q;
VectPriority15   <= VectPrio15Q;
VectPriority16   <= VectPrio16Q;
VectPriority17   <= VectPrio17Q;
VectPriority18   <= VectPrio18Q;
VectPriority19   <= VectPrio19Q;
VectPriority20   <= VectPrio20Q;
VectPriority21   <= VectPrio21Q;
VectPriority22   <= VectPrio22Q;
VectPriority23   <= VectPrio23Q;
VectPriority24   <= VectPrio24Q;
VectPriority25   <= VectPrio25Q;
VectPriority26   <= VectPrio26Q;
VectPriority27   <= VectPrio27Q;
VectPriority28   <= VectPrio28Q;
VectPriority29   <= VectPrio29Q;
VectPriority30   <= VectPrio30Q;
VectPriority31   <= VectPrio31Q;
VectPriority32   <= VectPrio32Q;
ITEN             <= VICITCRQ(0);
IRQACKForceVal   <= VICITIP1Q(8);
nIRQINForceVal   <= VICITIP1Q(7);
nFIQINForceVal   <= VICITIP1Q(6);
VECTADDRINFrcVal <= VICITIP2Q;
IRQACKOUTFrcVal  <= VICITOP1Q(9);
VECTADDRVFrcVal  <= VICITOP1Q(8);
IRQForceVal      <= VICITOP1Q(7);
FIQForceVal      <= VICITOP1Q(6);
VECTADDRFrcVal   <= VICITOP2Q;

-- -----------------------------------------------------------------------------
-- Assign zeros to the TieLow
-- -----------------------------------------------------------------------------
TieLow <= "000000000000000000000000000000";

-- synopsys translate_off
-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------
-- synopsys translate_on

end synth;
-- --================================== End ==================================--
