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
-- File Name              : Decoder.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Provides the HSELx module select outputs to the AHB
--           system slaves, and controls the read data multiplexer.
--           This module is specific to a particular implementation
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

entity Decoder is
  port(
    HRESETn     : in  std_logic;
    HADDR       : in  std_logic_vector(31 downto 0);

    Remap       : in  std_logic;

    HSELIntMem  : out std_logic; -- Internal Memory
    HSELExtMem  : out std_logic; -- External Memory
    HSELUUT     : out std_logic; -- AHB UUT
    HSELAPBif   : out std_logic; -- APB Peripherals
    HSELArmTest : out std_logic; -- ARM Test
    HSELDefault : out std_logic  -- Default Slave
    );
end Decoder;

architecture synth of Decoder is

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
begin

-- ---------------------------------------------------------------------
-- AHB address decoding for slave selection and read data multiplexer
-- control
-- ---------------------------------------------------------------------
-- Address decoding of HADDR is performed continuously.
-- Address map is:
--
-- 0x00000000 - 0x000003FF Internal RAM (1 bank)  (Remap HIGH)
-- 0x00000400 - 0x1FFFFFFF External RAM (2 banks) (Remap HIGH)
-- 0x00000000 - 0x3FFFFFFF External RAM (2 banks) (Remap LOW)
-- 0x20000000 - 0x2FFFFFFF Tube
-- 0x30000000 - 0x3FFFFFFF External ROM (1 bank)
-- 0x40000000 - 0x5FFFFFFF AHB Unit Under Test
-- 0x60000000 - 0x7FFFFFFF Undefined (Default Slave)
-- 0x80000000 - 0xBFFFFFFF APB Peripherals
-- 0xC0000000 - 0xDFFFFFFF ARM Core Test Interface
-- 0xE0000000 - 0xFFFFFFFF Undefined (Default Slave)

  p_AddressDecodeComb : process (HRESETn, HADDR, Remap)
  begin
    HSELIntMem  <= '0';
    HSELExtMem  <= '0';
    HSELUUT     <= '0';
    HSELAPBif   <= '0';
    HSELArmTest <= '0';
    HSELDefault <= '0';

    if HRESETn = '0' then
      HSELDefault <= '1';                  -- Reset (Default Slave)
    elsif (HADDR(31 downto 10) = "0000000000000000000000" and
           Remap = '1') then
      HSELIntMem  <= '1';                  -- Internal Memory
    elsif HADDR(31 downto 30) = "00" then
      HSELExtMem  <= '1';                  -- External Memory + Tube
    elsif HADDR(31 downto 29) = "010" then
      HSELUUT     <= '1';                  -- AHB UUT
    elsif HADDR(31 downto 30) = "10" then
      HSELAPBif   <= '1';                  -- APB Peripherals
    elsif HADDR(31 downto 29) = "110" then
      HSELArmTest <= '1';                  -- ARM Core Test Interface
    else
      HSELDefault <= '1';                  -- Undefined (Default Slave)
    end if;
  end process p_AddressDecodeComb;


end synth;

-- --============================== End ==============================--
