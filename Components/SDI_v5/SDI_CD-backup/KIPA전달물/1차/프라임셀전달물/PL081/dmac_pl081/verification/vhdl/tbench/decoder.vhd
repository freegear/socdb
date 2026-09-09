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
-- File Name              : decoder.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module generates select signals HSELx for the slaves.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity decoder is
  port (
-- Input
        HADDR            : in    std_logic_vector(31 downto 0);
                                            -- AHB Address Bus
-- Outputs
        HSEL             : out   std_logic_vector(15 downto 0);
                                            -- Slave Select Signal
        DefSlaveSel      : out   std_logic  -- Default Slave Sel.
       );
end decoder;

-- -----------------------------------------------------------------------------
--
--                             decoder
--                             =======
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--   This module decodes the address and generates the HSELx signals.
-- This module generates the select signals for max. of 16 slaves.
-- Note : The low address range and high address range of the slaves
-- being tested has to be defined by the user.
-- For example, SLAVE0LOWADDRRANGE and SLAVE0HIGHADDRANGE maps to the
-- memory space of SLAVE 0 and has to be defined, if it is being tested.
-- For all the other slaves, which are dummy slaves, their LOWADDRRANGE
-- has to be defined with OxFFFFFFFF and HIGHADDRANGE with 0x00000000 so
-- that default slave will be selected when HADDR goes to unmapped
-- region.
-- --============================= ARCHITECTURE ==============================--

architecture behavioural of Decoder is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

constant SLAVE0LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"50000000");
constant SLAVE1LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"A0000000");
constant SLAVE2LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE3LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE4LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE5LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE6LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE7LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE8LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE9LOWADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE10LOWADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE11LOWADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE12LOWADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE13LOWADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE14LOWADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");
constant SLAVE15LOWADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"FFFFFFFF");

constant SLAVE0HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"5FFFFFFF");
constant SLAVE1HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"AFFFFFFF");
constant SLAVE2HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE3HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE4HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE5HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE6HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE7HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE8HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE9HIGHADDRRANGE  : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE10HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE11HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE12HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE13HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE14HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");
constant SLAVE15HIGHADDRRANGE : std_logic_vector(31 downto 0) :=
                                        to_stdlogicvector(X"00000000");

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iHSEL            : std_logic_vector(15 downto 0);
-- Internal Select signals of all slaves

signal iDefSlaveSel     : std_logic;
-- Internal default Slave Select signal

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Assign internal copies of signals to output ports
-- -----------------------------------------------------------------------------
HSEL             <= iHSEL;

DefSlaveSel      <= iDefSlaveSel after 1 ns when
                         (HADDR /= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
                 else
                    '0';
-- -----------------------------------------------------------------------------
-- Generation of HSELx signals
-- -----------------------------------------------------------------------------
iHSEL(0)         <= '1' when ((SLAVE0LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE0HIGHADDRRANGE))
                 else
                    '0';

iHSEL(1)         <= '1' when ((SLAVE1LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE1HIGHADDRRANGE))
                 else
                    '0';

iHSEL(2)         <= '1' when ((SLAVE2LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE2HIGHADDRRANGE))
                 else
                    '0';

iHSEL(3)         <= '1' when ((SLAVE3LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE3HIGHADDRRANGE))
                 else
                    '0';

iHSEL(4)         <= '1' when ((SLAVE4LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE4HIGHADDRRANGE))
                 else
                    '0';

iHSEL(5)         <= '1' when ((SLAVE5LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE5HIGHADDRRANGE))
                 else
                    '0';

iHSEL(6)         <= '1' when ((SLAVE6LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE6HIGHADDRRANGE))
                 else
                    '0';

iHSEL(7)         <= '1' when ((SLAVE7LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE7HIGHADDRRANGE))
                 else
                    '0';

iHSEL(8)         <= '1' when ((SLAVE8LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE8HIGHADDRRANGE))
                 else
                    '0';

iHSEL(9)         <= '1' when ((SLAVE9LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE9HIGHADDRRANGE))
                 else
                    '0';

iHSEL(10)        <= '1' when ((SLAVE10LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE10HIGHADDRRANGE))
                 else
                    '0';

iHSEL(11)        <= '1' when ((SLAVE11LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE11HIGHADDRRANGE))
                 else
                    '0';

iHSEL(12)        <= '1' when ((SLAVE12LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE12HIGHADDRRANGE))
                 else
                    '0';

iHSEL(13)        <= '1' when ((SLAVE13LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE13HIGHADDRRANGE))
                 else
                    '0';

iHSEL(14)        <= '1' when ((SLAVE14LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE14HIGHADDRRANGE))
                 else
                    '0';

iHSEL(15)        <= '1' when ((SLAVE15LOWADDRRANGE <= HADDR) and
                               (HADDR <= SLAVE15HIGHADDRRANGE))
                 else
                    '0';

-- -----------------------------------------------------------------------------
-- Default Slave's HSEL generation
-- If any of the slaves are not selected then defaultslave is selected
-- -----------------------------------------------------------------------------
iDefSlaveSel     <= '1' when ((iHSEL(1) or iHSEL(2) or
                               iHSEL(3) or iHSEL(4) or
                               iHSEL(5) or iHSEL(6) or iHSEL(7) or
                               iHSEL(8) or iHSEL(9) or iHSEL(10) or
                               iHSEL(11) or iHSEL(12) or iHSEL(13) or
                               iHSEL(14) or iHSEL(15) or
                               iHSEL(0)) /= '1')
                 else
                    '0';

end behavioural;

-- --================================ End ====================================--
