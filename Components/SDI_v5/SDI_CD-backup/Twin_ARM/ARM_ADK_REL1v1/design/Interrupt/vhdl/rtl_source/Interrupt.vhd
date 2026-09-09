-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Interrupt.vhd,v
-- File Revision          : 1.10
--
-- Release Information    : ADK_REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : This block is the top level of the AHB Interrupt Controller
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- ---------------------------------------------------------------------

entity Interrupt is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HSELIC           : in    std_logic; -- Interrupt Controller select
        HWRITE           : in    std_logic; -- AHB Write
        HREADY           : in    std_logic; -- Shared HREADY line
        HPROT            : in    std_logic; -- Protection mode
        HTRANS           : in    std_logic; -- Bit 1 of HTRANS
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- AHB transfer size
        ICINTSOURCE      : in    std_logic_vector(31 downto 0);
                                            -- Interrupt source
        nICFIQIN         : in    std_logic; -- Fast interrupt input
        nICIRQIN         : in    std_logic; -- Normal interrupt input
        ICVECTADDRIN     : in    std_logic_vector(31 downto 0);
                                            -- Vector Address input
        SCANENABLE       : in    std_logic; -- Scan Enable
        SCANINHCLK       : in    std_logic; -- HCLK domain Scan input
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB write data bus
        HADDR            : in    std_logic_vector(11 downto 2);
                                            -- AHB address bus
-- Outputs
        HREADYOUT        : out   std_logic; -- IC ready signal
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- AHB transfer response
        nICFIQ           : out   std_logic; -- Fast Interrupt request
        nICIRQ           : out   std_logic; -- Normal Interrupt request
        ICVECTADDROUT    : out   std_logic_vector(31 downto 0);
                                            -- Vector Address output
        SCANOUTHCLK      : out   std_logic; -- HLCK domain Scan output
        HRDATA           : out   std_logic_vector(31 downto 0)
                                            -- AHB Read data bus
       );
end Interrupt;

-- ---------------------------------------------------------------------
--
--                                 Interrupt
--                                 =========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This block is the top level of the IC. This block instantiates
-- the following functional sub-blocks.
-- - ICAhbifReg
-- - ICVectBank
-- - ICPriority
-- - ICSynctoHCLK
-- - RevAnd
--
-- ---------------------------------------------------------------------

-- --======================== ARCHITECTURE ===========================--

architecture structural of Interrupt is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

component ICAhbifReg
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        HSELIC           : in    std_logic;
        HWRITE           : in    std_logic;
        HREADY           : in    std_logic;
        HPROT            : in    std_logic;
        HTRANS           : in    std_logic;
        HSIZE            : in    std_logic_vector(2 downto 0);
        HWDATA           : in    std_logic_vector(31 downto 0);
        HADDR            : in    std_logic_vector(11 downto 2);
        Revision         : in    std_logic_vector(3 downto 0);
        ICINTSOURCE      : in    std_logic_vector(31 downto 0);
        nICFIQIN         : in    std_logic;
        nICIRQIN         : in    std_logic;
        ICIRQCo          : in    std_logic;
        ICVECTADDRIN     : in    std_logic_vector(31 downto 0);
        ICVECTADDROUTCo  : in    std_logic_vector(31 downto 0);
        ICRawIntrSync    : in    std_logic_vector(31 downto 0);
        ICIRQStatusSync  : in    std_logic_vector(31 downto 0);
        ICFIQStatusSync  : in    std_logic_vector(31 downto 0);
        PriorWrEnCo      : out   std_logic;
        PriorRdEn        : out   std_logic;
        HREADYOUT        : out   std_logic;
        HRESP            : out   std_logic_vector(1 downto 0);
        NonVectIrqCo     : out   std_logic;
        ICDefVectAddr    : out   std_logic_vector(31 downto 0);
        nICFIQ           : out   std_logic;
        ICIRQStatusCo    : out   std_logic_vector(31 downto 0);
        ICFIQStatusCo    : out   std_logic_vector(31 downto 0);
        ICRawIntrCo      : out   std_logic_vector(31 downto 0);
        HRDATA           : out   std_logic_vector(31 downto 0)
       );
end component;

component ICSynctoHCLK
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        ICRawIntrCo      : in    std_logic_vector(31 downto 0);
        ICIRQStatusCo    : in    std_logic_vector(31 downto 0);
        ICFIQStatusCo    : in    std_logic_vector(31 downto 0);
        ICRawIntrSync    : out   std_logic_vector(31 downto 0);
        ICIRQStatusSync  : out   std_logic_vector(31 downto 0);
        ICFIQStatusSync  : out   std_logic_vector(31 downto 0)
       );
end component;

component ICPriority
  port (
        HCLK             : in    std_logic;
        HRESETn          : in    std_logic;
        PriorWrEnCo      : in    std_logic;
        PriorRdEn        : in    std_logic;
        NonVectIrqCo     : in    std_logic;
        ICDefVectAddr    : in    std_logic_vector(31 downto 0);
        nICIRQIN         : in    std_logic;
        ICVECTADDRIN     : in    std_logic_vector(31 downto 0);
        ICIRQCo          : out   std_logic;
        nICIRQ           : out   std_logic;
        ICVECTADDROUTCo  : out   std_logic_vector(31 downto 0)
       );
end component;

component RevAnd
  port (
        TieOff1          : in    std_logic;
        TieOff2          : in    std_logic;
        Revision         : out   std_logic
       );
end component;

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal ICVECTADDROUTCo : std_logic_vector(31 downto 0);
-- Vector address output

signal PriorWrEnCo     : std_logic;
-- Write enable for VectAddr register

signal PriorRdEn       : std_logic;
-- Read enable for VectAddr register

signal NonVectIrqCo    : std_logic;
-- Non-Vectored Interrupt

signal ICDefVectAddr   : std_logic_vector(31 downto 0);
-- Default Vector Address

signal ICIRQStatusCo   : std_logic_vector(31 downto 0);
-- IRQ status

signal ICFIQStatusCo   : std_logic_vector(31 downto 0);
-- FIQ status

signal ICRawIntrCo     : std_logic_vector(31 downto 0);
-- IC Raw Interrupt

signal ICRawIntrSync   : std_logic_vector(31 downto 0);
-- Synced ICRawIntr

signal ICIRQStatusSync : std_logic_vector(31 downto 0);
-- Synced ICIRQStatus

signal ICFIQStatusSync : std_logic_vector(31 downto 0);
-- Synced ICFIQStatus

signal ICIRQCo         : std_logic;
-- Vectored IRQ Interrupt

signal TieOff1         : std_logic_vector(3 downto 0);
-- Input 1 for RevAnd

signal TieOff2         : std_logic_vector(3 downto 0);
-- Input 2 for RevAnd

signal Revision        : std_logic_vector(3 downto 0);
-- Output of RevAnd

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Instantiation of ICAhbifReg
-- ---------------------------------------------------------------------
uICAhbifReg : ICAhbifReg
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            HSELIC           => HSELIC,
            HWRITE           => HWRITE,
            HREADY           => HREADY,
            HPROT            => HPROT,
            HTRANS           => HTRANS,
            HSIZE            => HSIZE,
            HWDATA           => HWDATA,
            HADDR            => HADDR,
            Revision         => Revision,
            ICINTSOURCE      => ICINTSOURCE,
            nICFIQIN         => nICFIQIN,
            nICIRQIN         => nICIRQIN,
            ICIRQCo          => ICIRQCo,
            ICVECTADDRIN     => ICVECTADDRIN,
            ICVECTADDROUTCo  => ICVECTADDROUTCo,
            ICRawIntrSync    => ICRawIntrSync,
            ICIRQStatusSync  => ICIRQStatusSync,
            ICFIQStatusSync  => ICFIQStatusSync,
            PriorWrEnCo      => PriorWrEnCo,
            PriorRdEn        => PriorRdEn,
            HREADYOUT        => HREADYOUT,
            HRESP            => HRESP,
            NonVectIrqCo     => NonVectIrqCo,
            ICDefVectAddr    => ICDefVectAddr,
            nICFIQ           => nICFIQ,
            ICIRQStatusCo    => ICIRQStatusCo,
            ICFIQStatusCo    => ICFIQStatusCo,
            ICRawIntrCo      => ICRawIntrCo,
            HRDATA           => HRDATA
           );

-- ---------------------------------------------------------------------
-- Instantiation of IntSynctoHCLK
-- ---------------------------------------------------------------------
uICSynctoHCLK : ICSynctoHCLK
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            ICRawIntrCo      => ICRawIntrCo,
            ICIRQStatusCo    => ICIRQStatusCo,
            ICFIQStatusCo    => ICFIQStatusCo,
            ICRawIntrSync    => ICRawIntrSync,
            ICIRQStatusSync  => ICIRQStatusSync,
            ICFIQStatusSync  => ICFIQStatusSync
           );

-- ---------------------------------------------------------------------
-- Instantiation of IntPriority
-- ---------------------------------------------------------------------
uICPriority : ICPriority
  port map (
            HCLK             => HCLK,
            HRESETn          => HRESETn,
            PriorWrEnCo      => PriorWrEnCo,
            PriorRdEn        => PriorRdEn,
            NonVectIrqCo     => NonVectIrqCo,
            ICDefVectAddr    => ICDefVectAddr,
            nICIRQIN         => nICIRQIN,
            ICVECTADDRIN     => ICVECTADDRIN,
            ICIRQCo          => ICIRQCo,
            nICIRQ           => nICIRQ,
            ICVECTADDROUTCo  => ICVECTADDROUTCo
           );

-- ---------------------------------------------------------------------
-- Instantiation of RevAnd for bit 0 of Revision
-- ---------------------------------------------------------------------
u0RevAnd : RevAnd
  port map (
            TieOff1          => TieOff1(0),
            TieOff2          => TieOff2(0),
            Revision         => Revision(0)
           );

-- ---------------------------------------------------------------------
-- Instantiation of RevAnd for bit 1 of Revision
-- ---------------------------------------------------------------------
u1RevAnd : RevAnd
  port map (
            TieOff1          => TieOff1(1),
            TieOff2          => TieOff2(1),
            Revision         => Revision(1)
           );

-- ---------------------------------------------------------------------
-- Instantiation of RevAnd for bit 2 of Revision
-- ---------------------------------------------------------------------
u2RevAnd : RevAnd
  port map (
            TieOff1          => TieOff1(2),
            TieOff2          => TieOff2(2),
            Revision         => Revision(2)
           );

-- ---------------------------------------------------------------------
-- Instantiation of RevAnd for bit 3 of Revision
-- ---------------------------------------------------------------------
u3RevAnd : RevAnd
  port map (
            TieOff1          => TieOff1(3),
            TieOff2          => TieOff2(3),
            Revision         => Revision(3)
           );

-- ---------------------------------------------------------------------
-- Assign the Revision Number
--
-- The Revision Number of the Interrupt Controller is determined by the
-- values assigned to the TieOff1 and TieOff2 signals.
-- A TieOff1 = TieOff2 = 0000 value will set the Revision field of the
-- Peripheral ID to 0000. This is the default.
--
-- If a different Revision number is to be used, change the values
-- assigned to the TieOff1 and TieOff2 signals. For example, to
-- use a Revision Number of 0001, change TieOff1 and TieOff2 to 0001.
-- ---------------------------------------------------------------------
TieOff1          <= "0000";
TieOff2          <= "0000";

-- ---------------------------------------------------------------------
-- Assign internal copies of signals to output ports
-- ---------------------------------------------------------------------
ICVECTADDROUT   <= ICVECTADDROUTCo;

end structural;

-- --============================== End ==============================--
