-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MpmcTrMemAhbifReg.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the MPMC Memory model with the AHB bus.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.MpmcTrPackage.all;

-- -----------------------------------------------------------------------------

entity MpmcTrMemAhbifReg is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- Bus Reset
        HADDR            : in    std_logic_vector(15 downto 0);
                                            -- AHB Address Bus
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Transfer type
        HWRITE           : in    std_logic; -- AHB Peripheral Write
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- Transfer size
        HBURST           : in    std_logic_vector(2 downto 0);
                                            -- Burst Type
        HREADYIN         : in    std_logic; -- Multiplexed version of
                                            -- HREADY outputs
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- AHB Write Data bus
        HSELMPMCTRMEM    : in    std_logic; -- AHB Peripheral (TrickMem)
                                            -- Select
        AhbRdDataDW      : in    std_logic_vector(31 downto 0);
                                            -- Mem Rd data

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response

        MPMCTrMEMRWr     : out   std_logic; -- MPMCTrMEMR Write enable
        LatchHADDR       : out   std_logic_vector(15 downto 0);
                                            -- Latched AHB Address
        MPMCTrIDCY       : out   std_logic_vector(4 downto 0);
                                            -- MPMCTrIDCY Register
        MPMCTrWaitRd     : out   std_logic_vector(5 downto 0);
                                            -- MPMCTrWaitRd Register
        MPMCTrWaitWr     : out   std_logic_vector(5 downto 0);
                                            -- MPMCTrWaitWr Register
        MPMCTrWaitPg     : out   std_logic_vector(5 downto 0);
                                            -- MPMCTrWaitPg Register
        MPMCTrMEMT       : out   std_logic_vector(10 downto 0);
                                            -- MPMCTrMEMT Register
        MPMCTrMEMB       : out   std_logic_vector(16 downto 0);
                                            -- MPMCTrMEMB Register
        MPMCTrCS2OEN     : out   std_logic_vector(4 downto 0);
                                            -- MPMCTrCS2OEN Register
        MPMCTrCS2WEN     : out   std_logic_vector(4 downto 0);
                                            -- MPMCTrCS2WEN Register
        MPMCTrCSPOL      : out   std_logic_vector(7 downto 0)
                                            -- MPMCTrCSPOL Register
       );
end MpmcTrMemAhbifReg;

-- -----------------------------------------------------------------------------
--
--                              MpmcTrMemAhbifReg
--                              =================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   MPMC Trickmem is an AHB slave. This block interfaces the Trickmem with the
-- AHB bus. All slave response signals are generated from this module.
-- This module decodes AHB accesses and generates the read/write
-- strobe to the appropriate registers.
--
-- -----------------------------------------------------------------------------
--                         MPMC Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register    Type   Width    Describtion
-- -----------------------------------------------------------------------------
-- 0x0000 -  MPMCTrMEMR   R/W    32-bit   32-bit wide and 2K deep Memory. By
-- 0x1FFF                                changing the MemDeep value in
--                                       SmcTrConst file it is possible to
--                                       change the size of the memory array.
--
-- 0x2000    MPMCTrIDCY   R/W    5-bit    Memory data bus turn around time.
--
-- 0x4000    MPMCTrMEMT   R/W   11-bit    Memory type and width configuration
--                                       register.
--
-- 0x5000    MPMCTrMEMB   R/W    17-bit   Memory base address register.
--
-- 0x6000    MPMCTrCS2OEN R/W     5-bit   In the case of SRAMs and ROMs, this
--                                       register determines the time duration
--                                       between Chip Select assertion and the
--                                       nMPMCOEN assertion.
--                                       In the case of page mode ROMs, initial
--                                       access to this register determines the
--                                       time duration between Chip Select
--                                       assertion and the nMPMCOEN assertion
--                                       and is insignificant in successive
--                                       page mode ROM accesses.
--
-- 0x7000    MPMCTrWaitRd R/W    6-bit    This is read access time in case of
--                                       SRAM and ROM. This is initial access
--                                       time in case of page mode ROM.
--
-- 0x8000    MPMCTrCS2WEN R/W     5-bit   In the case of SRAMs, this register
--                                       determines the time duration between
--                                       Chip Select assertion and the nMPMCWEN
--                                       assertion.
--                                       In the case of page mode ROMs and
--                                       ROMs, this field is insignificant.
--
-- 0x9000    MPMCTrWaitWr R/W    6-bit    This is write access time in case of
--                                       SRAM. This is burst access time in
--                                       case of page mode ROM.
--
-- 0xA000    MPMCTrWaitPg R/W    6-bit    This is the delay for asynchronous
--                                       page mode sequential access.
--
-- 0xF000    MPMCTrCSPOL  R/W     8-bit   Chip Select Polarity setting register.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of MpmcTrMemAhbifReg is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant ZEROFILL         : std_logic_vector(31 downto 0)
                            := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- Trickbox registers address constants. Address decode is for
-- bits 12 to 15 (4 bits)
-- -----------------------------------------------------------------------------
constant HADDR_MPMCTrMEMR   : std_logic_vector(15 downto 12)  := "0000";
-- MPMCTrMEMR at offset 0x0000 to 1FFF

constant HADDR_MPMCTrIDCY   : std_logic_vector(15 downto 12)  := "0010";
-- MPMCTrIDCY at offset 0x2000

constant HADDR_MPMCTrMEMT   : std_logic_vector(15 downto 12)  := "0100";
-- MPMCTrMEMT at offset 0x4000

constant HADDR_MPMCTrMEMB   : std_logic_vector(15 downto 12)  := "0101";
-- MPMCTrMEMB at offset 0x5000

constant HADDR_MPMCTrCS2OEN : std_logic_vector(15 downto 12)  := "0110";
-- MPMCTrCS2OEN at offset 0x6000

constant HADDR_MPMCTrWaitRd : std_logic_vector(15 downto 12)  := "0111";
-- MPMCTrWaitRd at offset 0x7000

constant HADDR_MPMCTrCS2WEN : std_logic_vector(15 downto 12)  := "1000";
-- MPMCTrCS2WEN at offset 0x8000

constant HADDR_MPMCTrWaitWr : std_logic_vector(15 downto 12)  := "1001";
-- MPMCTrWaitWr at offset 0x9000

constant HADDR_MPMCTrWaitPg : std_logic_vector(15 downto 12)  := "1010";
-- MPMCTrWaitPg at offset 0xA000

constant HADDR_MPMCTrCSPOL  : std_logic_vector(15 downto 12)  := "1111";
-- MPMCTrCSPOL at offset 0xC000

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iLatchHADDR      : std_logic_vector(15 downto 0)
                          := "0000000000000000";
-- Latched version of HADDR

signal SelLatchHADDR    : std_logic_vector(3 downto 0);
-- Used for Adress decoding

signal iHRESP           : std_logic_vector(1 downto 0);
-- Indicates the type of response for a transfer

-- signal MPMCTrMEMR    : std_logic_vector(31 downto 0);
-- MPMCTrMEMR Register

signal iMPMCTrIDCY      : std_logic_vector(4 downto 0) := "00000";
-- Internal version of MPMCTrIDCY Register

signal iMPMCTrWaitRd    : std_logic_vector(5 downto 0) := "000000";
-- Internal version of MPMCTrWaitRd Register

signal iMPMCTrWaitWr    : std_logic_vector(5 downto 0) := "000000";
-- Internal version of MPMCTrWaitWr Register

signal iMPMCTrWaitPg    : std_logic_vector(5 downto 0) := "000000";
-- Internal version of MPMCTrWaitPg Register

signal iMPMCTrMEMT      : std_logic_vector(10 downto 0) := (others => '0');
-- Internal version of MPMCTrMEMT Register

signal iMPMCTrMEMB      : std_logic_vector(16 downto 0) := (others => '0');
-- Internal version of MPMCTrMEMB Register

signal iMPMCTrCS2OEN    : std_logic_vector(4 downto 0) := "00000";
-- Internal version of MPMCTrCS2OEN Register

signal iMPMCTrCS2WEN    : std_logic_vector(4 downto 0) := "00000";
-- Internal version of MPMCTrCS2WEN Register

signal iMPMCTrCSPOL     : std_logic_vector(7 downto 0);
-- Internal version of MPMCTrCSPOL Register

signal NxtMPMCTrIDCY    : std_logic_vector(4 downto 0);
-- D-Input of MPMCTrIDCY Register

signal NxtMPMCTrWaitRd  : std_logic_vector(5 downto 0);
-- D-Input of MPMCTrWaitRd Register

signal NxtMPMCTrWaitWr  : std_logic_vector(5 downto 0);
-- D-Input of MPMCTrWaitWr Register

signal NxtMPMCTrWaitPg  : std_logic_vector(5 downto 0);
-- D-Input of MPMCTrWaitPg Register

signal NxtMPMCTrMEMT    : std_logic_vector(10 downto 0) := (others => '0');
-- D-Input of MPMCTrMEMT Register

signal NxtMPMCTrMEMB    : std_logic_vector(16 downto 0);
-- D-Input of MPMCTrMEMB Register

signal NxtMPMCTrCS2OEN  : std_logic_vector(4 downto 0);
-- D-Input of MPMCTrCS2OEN Register

signal NxtMPMCTrCS2WEN  : std_logic_vector(4 downto 0);
-- D-Input of MPMCTrCS2WEN Register

signal NxtMPMCTrCSPOL   : std_logic_vector(7 downto 0);
-- D-Input of MPMCTrCSPOL Register

signal RdEn             : std_logic;
-- Read enable signal

signal MPMCTrMEMRRd     : std_logic;
-- MPMCTrMEMR Read

signal MPMCTrIDCYRd     : std_logic;
-- MPMCTrIDCY Read

signal MPMCTrWaitRdRd   : std_logic;
-- MPMCTrWaitRd Read

signal MPMCTrWaitWrRd   : std_logic;
-- MPMCTrWaitWr Read

signal MPMCTrWaitPgRd   : std_logic;
-- MPMCTrWaitPg Read

signal MPMCTrMEMTRd     : std_logic;
-- MPMCTrMEMT Read

signal MPMCTrMEMBRd     : std_logic;
-- MPMCTrMEMB Read

signal MPMCTrCS2OENRd   : std_logic;
-- MPMCTrCS2OEN Read

signal MPMCTrCS2WENRd   : std_logic;
-- MPMCTrCS2WEN Read

signal MPMCTrCSPOLRd    : std_logic;
-- MPMCTrCSPOL Read

signal WrEn             : std_logic;
-- Write enable signal

signal MPMCTrIDCYWr     : std_logic;
-- MPMCTrIDCY Write

signal MPMCTrWaitRdWr   : std_logic;
-- MPMCTrWaitRd Write

signal MPMCTrWaitWrWr   : std_logic;
-- MPMCTrWaitWr Write

signal MPMCTrWaitPgWr   : std_logic;
-- MPMCTrWaitPg Write

signal MPMCTrMEMTWr     : std_logic;
-- MPMCTrMEMT Write

signal MPMCTrMEMBWr     : std_logic;
-- MPMCTrMEMB Write

signal MPMCTrCS2OENWr   : std_logic;
-- MPMCTrCS2OEN Write

signal MPMCTrCS2WENWr   : std_logic;
-- MPMCTrCS2WEN Write

signal MPMCTrCSPOLWr    : std_logic;
-- MPMCTrCSPOL Write

signal ErrorLat         : std_logic := '0';
-- Latch error condition

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
-- It is used for address decoding
-- -----------------------------------------------------------------------------
SelLatchHADDR    <= iLatchHADDR(15 downto 12);

-- -----------------------------------------------------------------------------
-- Write enable for registers
-- -----------------------------------------------------------------------------
MPMCTrMEMRWr     <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrMEMR))
                 else
                    '0';

MPMCTrIDCYWr     <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrIDCY))
                 else
                    '0';

MPMCTrWaitRdWr   <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrWaitRd))
                 else
                    '0';

MPMCTrWaitWrWr   <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrWaitWr))
                 else
                    '0';

MPMCTrMEMTWr     <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrMEMT))
                 else
                    '0';

MPMCTrMEMBWr     <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrMEMB))
                 else
                    '0';

MPMCTrCS2OENWr   <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrCS2OEN))
                 else
                    '0';

MPMCTrCS2WENWr   <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrCS2WEN))
                 else
                    '0';

MPMCTrCSPOLWr    <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrCSPOL))
                 else
                    '0';

MPMCTrWaitPgWr   <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrWaitPg))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Read enable for registers
-- -----------------------------------------------------------------------------
MPMCTrMEMRRd     <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrMEMR))
                 else
                    '0';

MPMCTrIDCYRd     <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrIDCY))
                 else
                    '0';

MPMCTrWaitRdRd   <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrWaitRd))
                 else
                    '0';

MPMCTrWaitWrRd   <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrWaitWr))
                 else
                    '0';

MPMCTrWaitPgRd   <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrWaitPg))
                 else
                    '0';

MPMCTrMEMTRd     <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrMEMT))
                 else
                    '0';

MPMCTrMEMBRd     <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrMEMB))
                 else
                    '0';

MPMCTrCS2OENRd   <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrCS2OEN))
                 else
                    '0';

MPMCTrCS2WENRd   <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrCS2WEN))
                 else
                    '0';

MPMCTrCSPOLRd    <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_MPMCTrCSPOL))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Output Mux
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (HRDATA)
-- -----------------------------------------------------------------------------
HRDATA           <= AhbRdDataDW when
                                (MPMCTrMEMRRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iMPMCTrIDCY when
                                (MPMCTrIDCYRd = '1')
                 else
                    ZEROFILL(31 downto 6) & iMPMCTrWaitRd when
                                (MPMCTrWaitRdRd = '1')
                 else
                    ZEROFILL(31 downto 6) & iMPMCTrWaitWr when
                                (MPMCTrWaitWrRd = '1')
                 else
                    ZEROFILL(31 downto 6) & iMPMCTrWaitPg when
                                (MPMCTrWaitPgRd = '1')
                 else
                    ZEROFILL(31 downto 11) & iMPMCTrMEMT when
                                (MPMCTrMEMTRd = '1')
                 else
                    ZEROFILL(31 downto 17) & iMPMCTrMEMB when
                                (MPMCTrMEMBRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iMPMCTrCS2OEN when
                                (MPMCTrCS2OENRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iMPMCTrCS2WEN when
                                (MPMCTrCS2WENRd = '1')
                 else
                    ZEROFILL(31 downto 8) & iMPMCTrCSPOL when
                                (MPMCTrCSPOLRd = '1')
                 else
                    ZEROFILL;

-- -----------------------------------------------------------------------------
-- This process generate the bus response required for an AHB slave.
-- MPMC trickbox is designed for an HBURST of INCR type and an HSIZE of 32-bit.
-- So this process will generate an ERROR response when the master try to access
-- it in some other mode. Also it display an error message to the output.
-- Trickbox always provides a ZERO wait state OKAY response for IDLE and BUSY
-- HTRANS of the master.
-- -----------------------------------------------------------------------------
p_BusRespSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHRESP          <= "00";
    HREADYOUT       <= '1';
    WrEn            <= '0';
    RdEn            <= '0';
    ErrorLat        <= '0';
    iLatchHADDR     <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if ((iHRESP = HRESP_ERROR) and (HREADYIN = '0') and (ErrorLat = '1')) then
      iHRESP        <= HRESP_ERROR;
      HREADYOUT     <= '1';
      WrEn          <= '0';
      RdEn          <= '0';
      ErrorLat      <= '0';
    elsif (((HTRANS = HTRANS_IDLE) or (HTRANS = HTRANS_BUSY)) and
           (HSELMPMCTRMEM = '1') and (HREADYIN = '1')) then
      iHRESP        <= HRESP_OKAY;
      HREADYOUT     <= '1';
    elsif ((HREADYIN = '1') and (HSELMPMCTRMEM = '1')) then
      if (HSIZE = HSIZE_WORD) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= HRESP_OKAY;
        if (HWRITE = '1') then
          WrEn      <= '1';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '1';
        end if;
      else
        iHRESP      <= HRESP_ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
        assert false
          report "Error Response from MPMC TrickMem slave"
        severity warning;
      end if;
    else
      WrEn          <= '0';
      RdEn          <= '0';
      iHRESP        <= "00";
      HREADYOUT     <= '1';
      ErrorLat      <= '0';
    end if;
  end if;
end process p_BusRespSeq;

-- -----------------------------------------------------------------------------
-- Combinational logic for all functional registers. When the respective
-- write enable input is asserted, copy the contents of the HWDATA Bus into
-- the corresponding registers.
-- -----------------------------------------------------------------------------
NxtMPMCTrIDCY    <= HWDATA(4 downto 0) when (MPMCTrIDCYWr = '1')
                 else
                    iMPMCTrIDCY;

NxtMPMCTrWaitRd  <= HWDATA(5 downto 0) when (MPMCTrWaitRdWr = '1')
                 else
                    iMPMCTrWaitRd;

NxtMPMCTrWaitWr  <= HWDATA(5 downto 0) when (MPMCTrWaitWrWr = '1')
                 else
                    iMPMCTrWaitWr;

NxtMPMCTrWaitPg  <= HWDATA(5 downto 0) when (MPMCTrWaitPgWr = '1')
                 else
                    iMPMCTrWaitPg;

NxtMPMCTrMEMT    <= HWDATA(10 downto 0) when (MPMCTrMEMTWr = '1')
                 else
                    iMPMCTrMEMT;

NxtMPMCTrMEMB    <= HWDATA(16 downto 0) when (MPMCTrMEMBWr = '1')
                 else
                    iMPMCTrMEMB;

NxtMPMCTrCS2OEN  <= HWDATA(4 downto 0) when (MPMCTrCS2OENWr = '1')
                 else
                    iMPMCTrCS2OEN;

NxtMPMCTrCS2WEN  <= HWDATA(4 downto 0) when (MPMCTrCS2WENWr = '1')
                 else
                    iMPMCTrCS2WEN;

NxtMPMCTrCSPOL   <= HWDATA(7 downto 0) when (MPMCTrCSPOLWr = '1')
                 else
                    iMPMCTrCSPOL;

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes.
-- -----------------------------------------------------------------------------
p_RegUpdateSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iMPMCTrIDCY    <= (others => '0');
    iMPMCTrWaitRd  <= "011111";
    iMPMCTrWaitWr  <= "011111";
    iMPMCTrWaitPg  <= "011111";
    iMPMCTrMEMT(5 downto 4)  <= (others => '0');
    iMPMCTrMEMT(10 downto 8) <= (others => '0');
    iMPMCTrMEMB    <= (others => '0');
    iMPMCTrCS2OEN  <= (others => '0');
    iMPMCTrCS2WEN  <= "00000";
    iMPMCTrCSPOL   <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iMPMCTrIDCY    <= NxtMPMCTrIDCY;
    iMPMCTrWaitRd  <= NxtMPMCTrWaitRd;
    iMPMCTrWaitWr  <= NxtMPMCTrWaitWr;
    iMPMCTrWaitPg  <= NxtMPMCTrWaitPg;
    iMPMCTrMEMT    <= NxtMPMCTrMEMT;
    iMPMCTrMEMB    <= NxtMPMCTrMEMB;
    iMPMCTrCS2OEN  <= NxtMPMCTrCS2OEN;
    iMPMCTrCS2WEN  <= NxtMPMCTrCS2WEN;
    iMPMCTrCSPOL   <= NxtMPMCTrCSPOL;
  end if;
end process p_RegUpdateSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HRESP            <= iHRESP;
LatchHADDR       <= iLatchHADDR;
MPMCTrIDCY       <= iMPMCTrIDCY;
MPMCTrWaitRd     <= iMPMCTrWaitRd;
MPMCTrWaitWr     <= iMPMCTrWaitWr;
MPMCTrWaitPg     <= iMPMCTrWaitPg;
MPMCTrMEMT       <= iMPMCTrMEMT;
MPMCTrMEMB       <= iMPMCTrMEMB;
MPMCTrCS2OEN     <= iMPMCTrCS2OEN;
MPMCTrCS2WEN     <= iMPMCTrCS2WEN;
MPMCTrCSPOL      <= iMPMCTrCSPOL;

end behavioural;

-- --================================== End ==================================--
