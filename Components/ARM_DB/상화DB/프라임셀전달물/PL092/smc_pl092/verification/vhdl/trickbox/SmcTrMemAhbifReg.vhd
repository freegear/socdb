-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcTrMemAhbifReg.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block interfaces the SMC Memory model with the AHB bus.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrMemAhbifReg is
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
        HSELSMCTRMEM     : in    std_logic; -- AHB Peripheral (TrickMem)
                                            -- Select
        AhbRdDataDW      : in    std_logic_vector(31 downto 0);
                                            -- Mem Rd data

-- Outputs
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- AHB Read Data bus
        HREADYOUT        : out   std_logic; -- Slave HREADY output
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Slave response

        SMCTrMEMRWr      : out   std_logic; -- SMCTrMEMR Write enable
        LatchHADDR       : out   std_logic_vector(15 downto 0);
                                            -- Latched AHB Address
        SMCTrIDCY        : out   std_logic_vector(4 downto 0);
                                            -- SMCTrIDCY Register
        SMCTrWST1        : out   std_logic_vector(5 downto 0);
                                            -- SMCTrWST1 Register
        SMCTrWST2        : out   std_logic_vector(5 downto 0);
                                            -- SMCTrWST2 Register
        SMCTrMEMT        : out   std_logic_vector(10 downto 0);
                                            -- SMCTrMEMT Register
        SMCTrMEMB        : out   std_logic_vector(14 downto 0);
                                            -- SMCTrMEMB Register
        SMCTrCS2OEN      : out   std_logic_vector(4 downto 0);
                                            -- SMCTrCS2OEN Register
        SMCTrCS2WEN      : out   std_logic_vector(4 downto 0);
                                            -- SMCTrCS2WEN Register
        SMCTrCSPOL       : out   std_logic_vector(7 downto 0)
                                            -- SMCTrCSPOL Register
       );
end SmcTrMemAhbifReg;

-- -----------------------------------------------------------------------------
--
--                              SmcTrMemAhbifReg
--                              ================
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SMC Tricbox is an AHB slave. This block interfaces the trickbox with the AHB
-- bus. All slave response signals are generated from this module.
-- This module decodes AHB accesses and generates the read/write
-- strobe to the appropriate registers. HCLK period calculation logic also
-- contained in this module.
--
-- -----------------------------------------------------------------------------
--                         SMC Trickbox Register Map
-- -----------------------------------------------------------------------------
-- Offset    Register    Type   Width    Describtion
-- -----------------------------------------------------------------------------
-- 0x0000 -  SMCTrMEMR   R/W    32-bit   32-bit wide and 2K deep Memory. By
-- 0x1FFF                                changing the MemDeep value in
--                                       SmcTrConst file it is possible to
--                                       change the size of the memory array.
--
-- 0x2000    SMCTrIDCY   R/W    5-bit    Memory data bus turn around time.
--
-- 0x4000    SMCTrWST1   R/W    6-bit    This is read access time in case of
--                                       SRAM and ROM. This is initial access
--                                       time in case of Burst ROM.
--
-- 0x6000    SMCTrWST2   R/W    6-bit    This is write access time in case of
--                                       SRAM. This is burst access time in
--                                       case of BURST ROM.
--
-- 0x8000    SMCTrMEMT   R/W   11-bit    Memory type and width configuration
--                                       register.
--
-- 0x9000    SMCTrMEMB   R/W    15-bit   Memory base address register.
--
-- 0xA000    SMCTrCS2OEN R/W     5-bit   In the case of SRAMs and ROMs, this
--                                       register determines the time duration
--                                       between Chip Select assertion and the
--                                       nSMOEN assertion.
--                                       In the case of BROMs initial access
--                                       to this register determines the time
--                                       duration between Chip Select
--                                       assertion and the nSMOEN assertion
--                                       and is insignificant in successive
--                                       BROM accesses.
--
-- 0xB000    SMCTrCS2WEN R/W     5-bit   In the case of SRAMs, this register
--                                       determines the time duration between
--                                       Chip Select assertion and the nSMWEN
--                                       assertion.
--                                       In the case of BROMs and ROMs, this
--                                       field is insignificant.
--
-- 0xC000    SMCTrCSPOL  R/W     8-bit   Chip Select Polarity setting register.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SmcTrMemAhbifReg is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant IDLE             : std_logic_vector(1 downto 0) := "00";
-- Master IDLE respone

constant BUSY             : std_logic_vector(1 downto 0) := "01";
-- Master BUSY respone

constant OKAY             : std_logic_vector(1 downto 0) := "00";
-- Slave OKAY respone

constant ERROR            : std_logic_vector(1 downto 0) := "01";
-- Slave ERROR respone

constant WORD             : std_logic_vector(2 downto 0) := "010";
-- 32-bit operation

constant INCR             : std_logic_vector(2 downto 0) := "001";
-- Undefined length burst

constant ZEROFILL         : std_logic_vector(31 downto 0)
                            := "00000000000000000000000000000000";

-- -----------------------------------------------------------------------------
-- Trickbox registers address constants. Address decode is for
-- bits 12 to 15 (4 bits)
-- -----------------------------------------------------------------------------
constant HADDR_SMCTrMEMR   : std_logic_vector(15 downto 12)  := "0000";
-- SMCTrMEMR at offset 0x0000 to 1FFF

constant HADDR_SMCTrIDCY   : std_logic_vector(15 downto 12)  := "0010";
-- SMCTrIDCY at offset 0x2000

constant HADDR_SMCTrWST1   : std_logic_vector(15 downto 12)  := "0100";
-- SMCTrWST1 at offset 0x4000

constant HADDR_SMCTrWST2   : std_logic_vector(15 downto 12)  := "0110";
-- SMCTrWST2 at offset 0x6000

constant HADDR_SMCTrMEMT   : std_logic_vector(15 downto 12)  := "1000";
-- SMCTrMEMT at offset 0x8000

constant HADDR_SMCTrMEMB   : std_logic_vector(15 downto 12)  := "1001";
-- SMCTrMEMB at offset 0x9000

constant HADDR_SMCTrCS2OEN : std_logic_vector(15 downto 12)  := "1010";
-- SMCTrCS2OEN at offset 0xA000

constant HADDR_SMCTrCS2WEN : std_logic_vector(15 downto 12)  := "1011";
-- SMCTrCS2WEN at offset 0xB000

constant HADDR_SMCTrCSPOL  : std_logic_vector(15 downto 12)  := "1100";
-- SMCTrCSPOL at offset 0xC000

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

-- signal SMCTrMEMR     : std_logic_vector(31 downto 0);
-- SMCTrMEMR Register

signal iSMCTrIDCY       : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMCTrIDCY Register

signal iSMCTrWST1       : std_logic_vector(5 downto 0) := "000000";
-- Internal version of SMCTrWST1 Register

signal iSMCTrWST2       : std_logic_vector(5 downto 0) := "000000";
-- Internal version of SMCTrWST2 Register

signal iSMCTrMEMT       : std_logic_vector(10 downto 0);
-- Internal version of SMCTrMEMT Register

signal iSMCTrMEMB       : std_logic_vector(14 downto 0) := "000000000000000";
-- Internal version of SMCTrMEMB Register

signal iSMCTrCS2OEN     : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMCTrCS2OEN Register

signal iSMCTrCS2WEN     : std_logic_vector(4 downto 0) := "00000";
-- Internal version of SMCTrCS2WEN Register

signal iSMCTrCSPOL      : std_logic_vector(7 downto 0);
-- Internal version of SMCTrCSPOL Register

signal NxtSMCTrIDCY     : std_logic_vector(4 downto 0);
-- D-Input of SMCTrIDCY Register

signal NxtSMCTrWST1     : std_logic_vector(5 downto 0);
-- D-Input of SMCTrWST1 Register

signal NxtSMCTrWST2     : std_logic_vector(5 downto 0);
-- D-Input of SMCTrWST2 Register

signal NxtSMCTrMEMT     : std_logic_vector(10 downto 0);
-- D-Input of SMCTrMEMT Register

signal NxtSMCTrMEMB     : std_logic_vector(14 downto 0);
-- D-Input of SMCTrMEMB Register

signal NxtSMCTrCS2OEN   : std_logic_vector(4 downto 0);
-- D-Input of SMCTrCS2OEN Register

signal NxtSMCTrCS2WEN   : std_logic_vector(4 downto 0);
-- D-Input of SMCTrCS2WEN Register

signal NxtSMCTrCSPOL    : std_logic_vector(7 downto 0);
-- D-Input of SMCTrCSPOL Register

signal RdEn             : std_logic;
-- Read enable signal

signal SMCTrMEMRRd      : std_logic;
-- SMCTrMEMR Read

signal SMCTrIDCYRd      : std_logic;
-- SMCTrIDCY Read

signal SMCTrWST1Rd      : std_logic;
-- SMCTrWST1 Read

signal SMCTrWST2Rd      : std_logic;
-- SMCTrWST2 Read

signal SMCTrMEMTRd      : std_logic;
-- SMCTrMEMT Read

signal SMCTrMEMBRd      : std_logic;
-- SMCTrMEMB Read

signal SMCTrCS2OENRd    : std_logic;
-- SMCTrCS2OEN Read

signal SMCTrCS2WENRd    : std_logic;
-- SMCTrCS2WEN Read

signal SMCTrCSPOLRd     : std_logic;
-- SMCTrCSPOL Read

signal WrEn             : std_logic;
-- Write enable signal

signal SMCTrIDCYWr      : std_logic;
-- SMCTrIDCY Write

signal SMCTrWST1Wr      : std_logic;
-- SMCTrWST1 Write

signal SMCTrWST2Wr      : std_logic;
-- SMCTrWST2 Write

signal SMCTrMEMTWr      : std_logic;
-- SMCTrMEMT Write

signal SMCTrMEMBWr      : std_logic;
-- SMCTrMEMB Write

signal SMCTrCS2OENWr    : std_logic;
-- SMCTrCS2OEN Write

signal SMCTrCS2WENWr    : std_logic;
-- SMCTrCS2WEN Write

signal SMCTrCSPOLWr     : std_logic;
-- SMCTrCSPOL Write

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
SelLatchHADDR     <= iLatchHADDR(15 downto 12);

-- -----------------------------------------------------------------------------
-- Write enable for registers
-- -----------------------------------------------------------------------------
SMCTrMEMRWr      <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrMEMR))
                 else
                    '0';

SMCTrIDCYWr      <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrIDCY))
                 else
                    '0';

SMCTrWST1Wr      <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrWST1))
                 else
                    '0';

SMCTrWST2Wr      <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrWST2))
                 else
                    '0';

SMCTrMEMTWr      <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrMEMT))
                 else
                    '0';

SMCTrMEMBWr      <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrMEMB))
                 else
                    '0';

SMCTrCS2OENWr    <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrCS2OEN))
                 else
                    '0';

SMCTrCS2WENWr    <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrCS2WEN))
                 else
                    '0';

SMCTrCSPOLWr     <= '1' when ((WrEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrCSPOL))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Read enable for registers
-- -----------------------------------------------------------------------------
SMCTrMEMRRd      <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrMEMR))
                 else
                    '0';

SMCTrIDCYRd      <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrIDCY))
                 else
                    '0';

SMCTrWST1Rd      <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrWST1))
                 else
                    '0';

SMCTrWST2Rd      <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrWST2))
                 else
                    '0';

SMCTrMEMTRd      <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrMEMT))
                 else
                    '0';

SMCTrMEMBRd      <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrMEMB))
                 else
                    '0';

SMCTrCS2OENRd    <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrCS2OEN))
                 else
                    '0';

SMCTrCS2WENRd    <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrCS2WEN))
                 else
                    '0';

SMCTrCSPOLRd     <= '1' when ((RdEn = '1') and
                              (SelLatchHADDR = HADDR_SMCTrCSPOL))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Output Mux
-- When the peripheral is not being accessed, '0's are driven
-- on the Read Databus (HRDATA)
-- -----------------------------------------------------------------------------
HRDATA           <= AhbRdDataDW when
                                (SMCTrMEMRRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iSMCTrIDCY when
                                (SMCTrIDCYRd = '1')
                 else
                    ZEROFILL(31 downto 6) & iSMCTrWST1 when
                                (SMCTrWST1Rd = '1')
                 else
                    ZEROFILL(31 downto 6) & iSMCTrWST2 when
                                (SMCTrWST2Rd = '1')
                 else
                    ZEROFILL(31 downto 11) & iSMCTrMEMT when
                                (SMCTrMEMTRd = '1')
                 else
                    ZEROFILL(31 downto 15) & iSMCTrMEMB when
                                (SMCTrMEMBRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iSMCTrCS2OEN when
                                (SMCTrCS2OENRd = '1')
                 else
                    ZEROFILL(31 downto 5) & iSMCTrCS2WEN when
                                (SMCTrCS2WENRd = '1')
                 else
                    ZEROFILL(31 downto 8) & iSMCTrCSPOL when
                                (SMCTrCSPOLRd = '1')
                 else
                    ZEROFILL;

-- -----------------------------------------------------------------------------
-- This process generate the bus response required for an AHB slave.
-- SMC trickbox is designed for an HBURST of INCR type and an HSIZE of 32-bit.
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
    if ((iHRESP = ERROR) and (HREADYIN = '0') and (ErrorLat = '1')) then
      iHRESP        <= ERROR;
      HREADYOUT     <= '1';
      WrEn          <= '0';
      RdEn          <= '0';
      ErrorLat      <= '0';
    elsif (((HTRANS = IDLE) or (HTRANS = BUSY)) and
           (HSELSMCTRMEM = '1') and (HREADYIN = '1')) then
      iHRESP        <= OKAY;
      HREADYOUT     <= '1';
    elsif ((HREADYIN = '1') and (HSELSMCTRMEM = '1')) then
      if ((HBURST = INCR) and (HSIZE = WORD)) then
        HREADYOUT   <= '1';
        iLatchHADDR <= HADDR;
        iHRESP      <= OKAY;
        if (HWRITE = '1') then
          WrEn      <= '1';
          RdEn      <= '0';
        else
          WrEn      <= '0';
          RdEn      <= '1';
        end if;
      else
        iHRESP      <= ERROR;
        HREADYOUT   <= '0';
        WrEn        <= '0';
        RdEn        <= '0';
        ErrorLat    <= '1';
        assert false
          report "Error Response from SMC TrickMem slave"
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
NxtSMCTrIDCY     <= HWDATA(4 downto 0) when (SMCTrIDCYWr = '1')
                 else
                    iSMCTrIDCY;

NxtSMCTrWST1     <= HWDATA(5 downto 0) when (SMCTrWST1Wr = '1')
                 else
                    iSMCTrWST1;

NxtSMCTrWST2     <= HWDATA(5 downto 0) when (SMCTrWST2Wr = '1')
                 else
                    iSMCTrWST2;

NxtSMCTrMEMT     <= HWDATA(10 downto 0) when (SMCTrMEMTWr = '1')
                 else
                    iSMCTrMEMT;

NxtSMCTrMEMB     <= HWDATA(14 downto 0) when (SMCTrMEMBWr = '1')
                 else
                    iSMCTrMEMB;

NxtSMCTrCS2OEN   <= HWDATA(4 downto 0) when (SMCTrCS2OENWr = '1')
                 else
                    iSMCTrCS2OEN;

NxtSMCTrCS2WEN   <= HWDATA(4 downto 0) when (SMCTrCS2WENWr = '1')
                 else
                    iSMCTrCS2WEN;

NxtSMCTrCSPOL    <= HWDATA(7 downto 0) when (SMCTrCSPOLWr = '1')
                 else
                    iSMCTrCSPOL;

-- -----------------------------------------------------------------------------
-- Sequential process for all functional registers writes.
-- -----------------------------------------------------------------------------
p_RegUpdateSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iSMCTrIDCY   <= (others => '0');
    iSMCTrWST1   <= "011111";
    iSMCTrWST2   <= "011111";
    iSMCTrMEMT   <= (others => '0');
    iSMCTrMEMB   <= (others => '0');
    iSMCTrCS2OEN <= (others => '0');
    iSMCTrCS2WEN <= "00001";
    iSMCTrCSPOL  <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    iSMCTrIDCY   <= NxtSMCTrIDCY;
    iSMCTrWST1   <= NxtSMCTrWST1;
    iSMCTrWST2   <= NxtSMCTrWST2;
    iSMCTrMEMT   <= NxtSMCTrMEMT;
    iSMCTrMEMB   <= NxtSMCTrMEMB;
    iSMCTrCS2OEN <= NxtSMCTrCS2OEN;
    iSMCTrCS2WEN <= NxtSMCTrCS2WEN;
    iSMCTrCSPOL  <= NxtSMCTrCSPOL;
  end if;
end process p_RegUpdateSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
HRESP            <= iHRESP;
LatchHADDR       <= iLatchHADDR;
SMCTrIDCY        <= iSMCTrIDCY;
SMCTrWST1        <= iSMCTrWST1;
SMCTrWST2        <= iSMCTrWST2;
SMCTrMEMT        <= iSMCTrMEMT;
SMCTrMEMB        <= iSMCTrMEMB;
SMCTrCS2OEN      <= iSMCTrCS2OEN;
SMCTrCS2WEN      <= iSMCTrCS2WEN;
SMCTrCSPOL       <= iSMCTrCSPOL;

end behavioural;

-- --================================== End ==================================--
