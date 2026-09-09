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
-- File Name              : MpmcTrMemArray.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block serves as Memory array for the Trickmem memory model
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

use work.MpmcTrPackage.all;

-- -----------------------------------------------------------------------------
entity MpmcTrMemArray is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB clock input
        HRESETn          : in    std_logic; -- Bus Reset
        nCS              : in    std_logic; -- Chip select
        nMPMCBLS         : in    std_logic; -- MPMC Write enable
        MPMCTrMEMRWr     : in    std_logic; -- AHB Write enable
        LatchHADDR       : in    std_logic_vector(10 downto 0);
                                            -- Latched AHB Address
        LatchMCADDR      : in    std_logic_vector(10 downto 0);
                                            -- Latched Memory Address
        HWDATA           : in    std_logic_vector(7 downto 0);
                                            -- AHB Write data
        MemWrDatab       : in    std_logic_vector(7 downto 0);
                                            -- Mem Write data

-- Outputs
        AhbRdDatab       : out   std_logic_vector(7 downto 0);
                                            -- AHB read data
        MemRdDatab       : out   std_logic_vector(7 downto 0)
                                            -- Mem Read Data
       );
end MpmcTrMemArray;

-- -----------------------------------------------------------------------------
--
--                               MpmcTrMemArray
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This block contains an array of memory of width 8-bit. Its depth depends
-- on the parameter MemDeep in the MpmcTrPackage file. It is possible to access
-- this memory array both from the AHB and the memory side.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture behavioural of MpmcTrMemArray is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------
type t_MemFile is array (0 to MemDeep) of std_logic_vector(7 downto 0);
-- Type declaration for a memory File MemDeep-deep and 8-bit wide

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MemFile          : t_MemFile;
-- Memory array

signal IntLatchMCADDR   : integer := 0;
-- Integer value of memory address.

signal IntLatchHADDR    : integer := 0;
-- Integer value of AHB address.

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
-- Main body of Code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- ToInteger function convert the std_logic_vector to integer value.
-- -----------------------------------------------------------------------------
IntLatchMCADDR   <= ToInteger(LatchMCADDR);
IntLatchHADDR    <= ToInteger(LatchHADDR);

-- -----------------------------------------------------------------------------
-- The contents of the location pointed to by the current value of
-- the pointer IntLatchHADDR and IntLatchXADDR are driven to the AhbRdDatab
-- and MemRdDatab.
-- -----------------------------------------------------------------------------
AhbRdDatab       <= MemFile(IntLatchHADDR);
MemRdDatab       <= MemFile(IntLatchMCADDR);

-- -----------------------------------------------------------------------------
-- This process performing two functions.
-- Initialise the all memory with '0' at the starting.
-- Perform write operation both from the AHB and the Smc side. If both AHB
-- and Smc try to write at the same location, preference is given to Smc.
-- -----------------------------------------------------------------------------
p_MemWriteComb : process (HRESETn, MPMCTrMEMRWr, nMPMCBLS, HCLK, IntLatchMCADDR,
                          IntLatchHADDR, nCS)
begin
  if (HRESETn'event and HRESETn = '1') then
    FOR i IN 0 TO MemDeep LOOP
      MemFile(i) <= "00000000";
    END LOOP;
  else
    if (IntLatchMCADDR /= IntLatchHADDR) then
      if ((nMPMCBLS = '0') and (nCS = '0')) then
        MemFile(IntLatchMCADDR)  <= MemWrDatab;
      end if;
      if (HCLK'event and HCLK = '1' and MPMCTrMEMRWr = '1') then
        MemFile(IntLatchHADDR)  <= HWDATA;
      end if;
    else
      if ((nMPMCBLS = '0') and (nCS = '0')) then
        MemFile(IntLatchMCADDR)  <= MemWrDatab;
      elsif (HCLK'event and HCLK = '1' and MPMCTrMEMRWr = '1') then
        MemFile(IntLatchHADDR)  <= HWDATA;
      end if;
    end if;
  end if;
end process p_MemWriteComb;

end behavioural;

-- --================================== End ==================================--
