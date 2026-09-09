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
-- File Name              : SmcTrMCBusBlk.vhd.rca
-- File Revision          : 1.9
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module checks the MCBUS protocols on the SMC
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcTrMCBusBlk is
  generic (
           Tclk             : time := 10.52 ns  -- HCLK Period
          );
  port (
-- Inputs
        -- AHB bus signals
        HCLK             : in    std_logic; -- AHB Bus Clock
        HRESETn          : in    std_logic; -- Bus Reset

        -- SMBUS signals
        SMADDR           : in    std_logic_vector(25 downto 0);
                                            -- SMBUS Address signals
        SMDATAOUT        : in    std_logic_vector(31 downto 0);
                                            -- SMBUS Data Out signals
        nSMDATAEN        : in    std_logic_vector(3 downto 0);
                                            -- SMBUS Data Enable lines

        -- MCBUS Signals
        MCBUSGNT         : in    std_logic; -- MCBUS Grant
        SMCTrMCREQD      : in    std_logic_vector(4 downto 0);
                                            -- MCBUS Access to REQUEST Delay
                                            -- Count Register
        SMCTrGNT2RMREQ   : in    std_logic_vector(4 downto 0);
                                            -- MCBUS Grant to REQUEST
                                            -- de-assertion delay count
                                            -- Register
        SMCTrMCADDR      : in    std_logic_vector(25 downto 0);
                                            -- Address to eb driven out
                                            -- to the MCADDR bus of the SMC
        SMCTrMCDATAOUT   : in    std_logic_vector(31 downto 0);
                                            -- Data to be driven out to the
                                            -- MCDATAOUT bus of the SMC
        SMCTrMCBUSRRd    : in    std_logic; -- MCBUS Read Enable
        SMCTrMCBUSRWr    : in    std_logic; -- MCBUS Write Enable

-- Outputs
        MCBUSREQ         : out   std_logic; -- MCBUS Access Request signal
        MCADDR           : out   std_logic_vector(25 downto 0);
                                            -- MCBUS Address signals
        MCDATAOUT        : out   std_logic_vector(31 downto 0);
                                            -- MCBUS Data Out signals
        MCDATAEN         : out   std_logic_vector(3 downto 0)
                                            -- MCBUS Data Enable lines
       );
end SmcTrMCBusBlk;

-- -----------------------------------------------------------------------------
--
--                                SmcTrMCBusBlk
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- SMC Tricbox is an AHB slave. This block performs the following operations:
--   - Generates the MCBUSREQ, MCADDR, MCDATAOUT and MCDATAEN signals.
--   - Watches the MCBUSGNT, SMADDR, SMDATAOUT and SMDATAEN for the expected
--     data.
--   - Flags Error messages when a mismatch is found on the SMBUS signals.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of SmcTrMCBusBlk is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iMCDATAEN        : std_logic_vector(3 downto 0) := "1111";
-- Internal version of MCDATAEN output

signal iMCDATAOUT       : std_logic_vector(31 downto 0) := (others => '0');
-- Internal version of MCDATAOUT output

signal iMCBUSREQ        : std_logic := '0';
-- Internal version of MCBUSREQ output

signal IntMCREQD        : time := 0 ns;
-- MCBUS access to Bus Request assertion delay

signal IntGNT2RMREQ     : time := 0 ns;
-- MCBUS Grant to Bus Request de-assertion delay

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- ToInteger
-- ---------
--   This function converts the std_logic_vector input argument into integer
-- and returns the integer value.
-- -----------------------------------------------------------------------------
function ToInteger (val : std_logic_vector;
                    x   : integer := 0)
return integer is
variable return_int, x_tmp : integer;
begin
  return_int := 0;
  x_tmp := 0;
    if x /= 0 then
      x_tmp := 1;
    end if;
    for i in val'range loop
      return_int := return_int + return_int;
      case val(i) is
        when '0' =>    null;
        when '1' =>    return_int := return_int + 1;
        when others => return_int := return_int + x_tmp;
      end case;
    end loop;
  return return_int;
end ToInteger;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- MCBUS Signal generation
-- -----------------------------------------------------------------------------
MCADDR           <= SMCTrMCADDR;

iMCDATAEN        <= "0101" when (SMCTrMCBUSRRd = '1')
                 else
                    "1010" when (SMCTrMCBUSRWr = '1')
                 else
                    iMCDATAEN;

iMCDATAOUT       <= SMCTrMCDATAOUT when ((SMCTrMCBUSRRd = '1') or
                                        (SMCTrMCBUSRWr = '1'))
                 else
                    iMCDATAOUT;

-- -----------------------------------------------------------------------------
-- Converting std_logic_vector to time.
-- -----------------------------------------------------------------------------
IntMCREQD        <= ToInteger(SMCTrMCREQD) * Tclk;
IntGNT2RMREQ     <= ToInteger(SMCTrGNT2RMREQ) * Tclk;

-- -----------------------------------------------------------------------------
-- MCBUSREQ Generation
-- -----------------------------------------------------------------------------
p_MCBUSREQComb : process (SMCTrMCBUSRRd, SMCTrMCBUSRWr, iMCBUSREQ,
                          MCBUSGNT)
begin
  if ((SMCTrMCBUSRRd'event and SMCTrMCBUSRRd = '1') or
      (SMCTrMCBUSRWr'event and SMCTrMCBUSRWr = '1')) then
    if (iMCBUSREQ = '0') then
      iMCBUSREQ <= '1' after IntMCREQD;
    end if;
  elsif (MCBUSGNT'event and MCBUSGNT = '1') then
    iMCBUSREQ <= '0' after IntGNT2RMREQ;
  end if;
end process p_MCBUSREQComb;

-- -----------------------------------------------------------------------------
-- Check the external BUS signals for the correct data
-- -----------------------------------------------------------------------------
p_SMBUSWatchComb : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    null;
  elsif (HCLK'event and HCLK = '1') then
    if (MCBUSGNT = '1') then
      assert (SMADDR = SMCTrMCADDR)
        report "SMCTB8: Error in the SMADDR received"
        severity warning;

      assert (nSMDATAEN = iMCDATAEN)
        report "SMCTB9: Error in the nSMDATAEN received"
        severity warning;

      assert (SMDATAOUT = iMCDATAOUT)
        report "SMCTB10: Error in the SMDATAOUT received"
        severity warning;
    end if;
  end if;
end process p_SMBUSWatchComb;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
MCDATAEN         <= iMCDATAEN;
MCDATAOUT        <= iMCDATAOUT;
MCBUSREQ         <= iMCBUSREQ;

end behavioural;

-- --================================== End ==================================--
