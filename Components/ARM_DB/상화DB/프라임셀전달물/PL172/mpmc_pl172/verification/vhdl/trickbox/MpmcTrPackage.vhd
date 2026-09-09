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
-- File Name              : MpmcTrPackage.vhd.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           All constants needs to be change in the tricbox design are
--           declared here
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

-- -----------------------------------------------------------------------------

package MpmcTrPackage is

-- -----------------------------------------------------------------------------
--
--                               MpmcTrPackage
--                               =============
--
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant MemDeep          : Integer := 2048;
-- Determines the size of memory array

constant AddWrHoldTime    : time := 4 ns;
-- Address hold time with respect to the rising edge (finishing end) of write

constant AddWrSetupTime   : time := 3 ns;
-- Address setup time with respect to the falling edge of (starting edge) write

constant DataWrHoldTime   : time := 4 ns;
-- Data hold time with respect to the rising edge (finishing end) of write

constant DataWrSetupTime  : time := 3 ns;
-- Data hold time with respect to the rising edge (finishing end) of write

constant DelayTime        : time := 3 ns;
-- Error window in time calculations

-- -----------------------------------------------------------------------------
-- Peripheral Address range Definations for AHB 1
-- -----------------------------------------------------------------------------
constant MPMC00LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"00000000");

constant MPMC01LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"10000000");

constant MPMC02LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"20000000");

constant MPMC03LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"30000000");

constant MPMC04LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"40000000");

constant MPMC05LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"50000000");

constant MPMC06LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"60000000");

constant MPMC07LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"70000000");

constant MCTR0LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"C0000000");

constant MPMC10LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"00000000");

constant MPMC11LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"10000000");

constant MPMC12LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"20000000");

constant MPMC13LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"30000000");

constant MPMC14LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"40000000");

constant MPMC15LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"50000000");

constant MPMC16LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"60000000");

constant MPMC17LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"70000000");

constant MCTR1LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"C0000000");

constant MPMC20LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"00000000");

constant MPMC21LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"10000000");

constant MPMC22LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"20000000");

constant MPMC23LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"30000000");

constant MPMC24LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"40000000");

constant MPMC25LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"50000000");

constant MPMC26LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"60000000");

constant MPMC27LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"70000000");

constant MCTR2LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"C0000000");

constant MPMC00HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"0FFFFFFF");

constant MPMC01HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"1FFFFFFF");

constant MPMC02HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"2FFFFFFF");

constant MPMC03HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"3FFFFFFF");

constant MPMC04HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"4FFFFFFF");

constant MPMC05HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"5FFFFFFF");

constant MPMC06HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"6FFFFFFF");

constant MPMC07HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"7FFFFFFF");

constant MCTR0HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"FFFFFFFF");

constant MPMC10HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"0FFFFFFF");

constant MPMC11HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"1FFFFFFF");

constant MPMC12HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"2FFFFFFF");

constant MPMC13HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"3FFFFFFF");

constant MPMC14HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"4FFFFFFF");

constant MPMC15HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"5FFFFFFF");

constant MPMC16HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"6FFFFFFF");

constant MPMC17HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"7FFFFFFF");

constant MCTR1HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"FFFFFFFF");

constant MPMC20HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"0FFFFFFF");

constant MPMC21HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"1FFFFFFF");

constant MPMC22HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"2FFFFFFF");

constant MPMC23HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"3FFFFFFF");

constant MPMC24HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"4FFFFFFF");

constant MPMC25HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"5FFFFFFF");

constant MPMC26HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"6FFFFFFF");

constant MPMC27HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"7FFFFFFF");

constant MCTR2HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                      to_stdlogicvector(X"FFFFFFFF");

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HTRANS transactions
-- -----------------------------------------------------------------------------
constant HTRANS_IDLE      : std_logic_vector(1 downto 0) := "00";
-- Master IDLE respone

constant HTRANS_BUSY      : std_logic_vector(1 downto 0) := "01";
-- Master BUSY respone

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HRESP responses
-- -----------------------------------------------------------------------------
constant HRESP_OKAY       : std_logic_vector(1 downto 0) := "00";
-- Slave OKAY respone

constant HRESP_ERROR      : std_logic_vector(1 downto 0) := "01";
-- Slave ERROR respone

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HSIZE transactions
-- -----------------------------------------------------------------------------
constant HSIZE_WORD       : std_logic_vector(2 downto 0) := "010";
-- 32-bit operation

-- -----------------------------------------------------------------------------
-- Definitions for different AHB HBURST transactions
-- -----------------------------------------------------------------------------
constant HBURST_INCR      : std_logic_vector(2 downto 0) := "001";
-- Undefined length burst

end MpmcTrPackage;

-- --================================= End ===================================--
