-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MuxS2M.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Central multiplexer - signals from slaves to masters.
--           Stand-alone module to allow ease of removal if an
--           alternative interconnection scheme is to be used.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

entity MuxS2M is
  port(
    HCLK          : in  std_logic;
    HRESETn       : in  std_logic;
    HSELIntMem    : in  std_logic;
    HSELExtMem    : in  std_logic;
    HSELUUT       : in  std_logic;
    HSELAPBif     : in  std_logic;
    HSELArmTest   : in  std_logic;

    HRDATAIntMem  : in  std_logic_vector(31 downto 0);
    HREADYIntMem  : in  std_logic;
    HRESPIntMem   : in  std_logic_vector(1 downto 0);

    HRDATAExtMem  : in  std_logic_vector(31 downto 0);
    HREADYExtMem  : in  std_logic;
    HRESPExtMem   : in  std_logic_vector(1 downto 0);

    HRDATAUUT     : in  std_logic_vector(31 downto 0);
    HREADYUUT     : in  std_logic;
    HRESPUUT      : in  std_logic_vector(1 downto 0);

    HRDATAAPBif   : in  std_logic_vector(31 downto 0);
    HREADYAPBif   : in  std_logic;
    HRESPAPBif    : in  std_logic_vector(1 downto 0);

    HRDATAArmTest : in  std_logic_vector(31 downto 0);
    HREADYArmTest : in  std_logic;
    HRESPArmTest  : in  std_logic_vector(1 downto 0);

    HREADYDefault : in  std_logic;
    HRESPDefault  : in  std_logic_vector(1 downto 0);

    HRDATA        : out std_logic_vector(31 downto 0);
    HREADY        : out std_logic;
    HRESP         : out std_logic_vector(1 downto 0)
    );
end MuxS2M;

architecture synth of MuxS2M is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- HselReg encoding. This must be extended if more than eight AHB
-- peripherals are used in the system.

  constant HSEL_INTMEM  : std_logic_vector(7 downto 0) := "00000001";
  constant HSEL_EXTMEM  : std_logic_vector(7 downto 0) := "00000010";
  constant HSEL_UUT     : std_logic_vector(7 downto 0) := "00000100";
  constant HSEL_APBIF   : std_logic_vector(7 downto 0) := "00001000";
  constant HSEL_ARMTEST : std_logic_vector(7 downto 0) := "00010000";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
  signal HselNext : std_logic_vector(7 downto 0);
  -- HSEL input bus
  signal HselReg  : std_logic_vector(7 downto 0);
  -- HSEL input register
  signal iHREADY  : std_logic;
  -- Internal HREADY used as HSEL register enable

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
  begin

-- ---------------------------------------------------------------------
-- HSEL bus and registers
-- ---------------------------------------------------------------------
-- The internal HSEL bus is made up of the HSEL inputs and extra
-- padding for the bits that are not used.

  HselNext <= "000" &
              HSELArmTest &
              HSELAPBif &
              HSELUUT &
              HSELExtMem &
              HSELIntMem;

-- Registered HSEL outputs are needed to control the slave output
-- multiplexers, as the multiplexers must be switched in the cycle
-- after the HSEL signals have been driven.

  p_HselSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      HselReg <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if iHREADY = '1' then
        HselReg <= HselNext;
      end if;
    end if;
  end process p_HselSeq;

-- ---------------------------------------------------------------------
-- Multiplexers
-- ---------------------------------------------------------------------
-- Multiplexers controlling read data and responses from slaves to
-- masters.

-- When no slaves are selected by the Decoder, the default outputs are
-- used to generate the response.
-- A default read data value is not strictly required as all reads from
-- undefined regions of memory receive an error response, but may aid
-- debugging by ensuring that the read data bus is zero when no
-- peripherals are being accessed.

  p_HRDATAComb : process (HselReg, HRDATAIntMem, HRDATAExtMem,
                          HRDATAUUT, HRDATAAPBif, HRDATAArmTest)
  begin
    case HselReg is
      when HSEL_INTMEM  => HRDATA <= HRDATAIntMem;
      when HSEL_EXTMEM  => HRDATA <= HRDATAExtMem;
      when HSEL_UUT     => HRDATA <= HRDATAUUT;
      when HSEL_APBIF   => HRDATA <= HRDATAAPBif;
      when HSEL_ARMTEST => HRDATA <= HRDATAArmTest;
      when others       => HRDATA <= "0000" & "0000" & "0000" & "0000" &
                                     "0000" & "0000" & "0000" & "0000";
    end case;
  end process p_HRDATAComb;

  p_HREADYComb : process (HselReg, HREADYIntMem, HREADYExtMem,
                          HREADYUUT, HREADYAPBif, HREADYArmTest,
                          HREADYDefault)
  begin
    case HselReg is
      when HSEL_INTMEM  => iHREADY <= HREADYIntMem;
      when HSEL_EXTMEM  => iHREADY <= HREADYExtMem;
      when HSEL_UUT     => iHREADY <= HREADYUUT;
      when HSEL_APBIF   => iHREADY <= HREADYAPBif;
      when HSEL_ARMTEST => iHREADY <= HREADYArmTest;
      when others       => iHREADY <= HREADYDefault;
    end case;
  end process p_HREADYComb;

  HREADY <= iHREADY;

  p_HRESPComb : process (HselReg, HRESPIntMem, HRESPExtMem, HRESPUUT,
                         HRESPAPBif, HRESPArmTest, HRESPDefault)
  begin
    case HselReg is
      when HSEL_INTMEM  => HRESP <= HRESPIntMem;
      when HSEL_EXTMEM  => HRESP <= HRESPExtMem;
      when HSEL_UUT     => HRESP <= HRESPUUT;
      when HSEL_APBIF   => HRESP <= HRESPAPBif;
      when HSEL_ARMTEST => HRESP <= HRESPArmTest;
      when others       => HRESP <= HRESPDefault;
    end case;
  end process p_HRESPComb;


end synth;

-- --============================== End ==============================--
