-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : defslave.vhd.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Drives all the AHB Slave output signals when no other slave
--           is selected.
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

library common;
use common.defs.all;

library tbench;

-- ---------------------------------------------------------------------

entity defslave is
  port (
-- Inputs
        HCLK             : in     std_logic;
        HRESETn          : in     std_logic;
        HSEL             : in     std_logic;
        HTRANS           : in     std_logic;
        HREADYIn         : in     T_line;
-- Outputs
        HRESP            : out    std_logic_vector(1 downto 0);
        HREADYOut        : out    T_line;
        HRDATAOut        : out    T_data
       );
end defslave;
-- ---------------------------------------------------------------------
--
--                             defslave
--                             ========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This modules drives the response, when an access is to a unmapped
-- region. Default slave has to drive its HREADY output high, when other
-- slaves are not selected. It has to drive a zero wait state OK
-- response for IDLE and BUSY transfers and a two cycle ERROR response
-- for an NSEQ or SEQ transfer access to an unmapped address.
--
-- ---------------------------------------------------------------------

-- --========================= ARCHITECTURE ==========================--

architecture behavioural of Defslave is

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ZERO             : T_data
                             := to_stdlogicvector(X"0000000000000000");

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal iHTRANSInt       : std_logic;
-- Internal copy of latched HTRANS signal

signal NxtHTRANSInt     : std_logic;
-- D-input of HTRANS signal

signal Count            : std_logic;
-- Counter to track 2 cycle response

signal NxtCount         : std_logic;
-- D-input of the counter to track 2 cycle response

signal Resetstrd        : std_logic;
-- Status of HRESETn signal

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Latching Control signal HTRANS
-- ---------------------------------------------------------------------
p_HTRANSSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iHTRANSInt <= '0';
  elsif (HCLK'event and HCLK = '1') then
    iHTRANSInt <= NxtHTRANSInt;
  end if;
end process p_HTRANSSeq;

-- ---------------------------------------------------------------------
-- Loading HTRANS signal only when HREADY is set
-- ---------------------------------------------------------------------
p_HTRANSComb : process (HTRANS, HREADYIn, iHTRANSInt)
begin
-- Loading address only when HREADY is set at the posedge of HCLK
  if (HREADYIn = '1') then
      NxtHTRANSInt <= HTRANS;
  else
    NxtHTRANSInt <= iHTRANSInt;
  end if;
end process p_HTRANSComb;

-- ---------------------------------------------------------------------
-- Storing HRESETn status
-- ---------------------------------------------------------------------
p_HRESETn : process (HCLK, HRESETn)
begin

 if (HCLK'event and HCLK = '1') then
   Resetstrd <= HRESETn;
 end if;
end process p_HRESETn;

-- ---------------------------------------------------------------------
HREADYOut        <= '1' after 2 ns when (((iHTRANSInt = '0') or
                                          (HRESETn = '0') or
                                         ((iHTRANSInt = '1') and
                                          (Count = '1') and
                                          (HSEL = '1'))) or
                                           Resetstrd = '0')
                 else
                    '0'after 2 ns;

HRESP            <= "01" after 3 ns when ((HSEL = '1') and
                                          (iHTRANSInt = '1'))
                 else
                    "00" after 3 ns;

HRDATAOut        <= to_stdlogicvector(X"0000000000000000");

-- ---------------------------------------------------------------------
-- Counter to track 2 cycle response
-- ---------------------------------------------------------------------
p_CntSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    Count <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Count <= NxtCount;
  end if;
end process p_CntSeq;

-- ---------------------------------------------------------------------
-- Generating D-input for the counter
-- ---------------------------------------------------------------------
p_CntComb : process (Count, iHTRANSInt)
begin
  if ((iHTRANSInt = '1') and (Count = '0')) then
    NxtCount <= '1';
  else
    NxtCount <= '0';
  end if;
end process p_CntComb;

end behavioural;

-- --============================== End ==============================--
