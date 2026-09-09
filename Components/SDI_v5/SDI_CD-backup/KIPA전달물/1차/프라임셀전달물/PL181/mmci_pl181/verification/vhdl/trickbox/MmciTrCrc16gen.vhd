-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciTrCrc16gen.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is used for computing the CRC16 value
--           while transmitting data and also for verification of the
--           received CRC16 in case of data reception.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrCrc16gen is
  port (
-- Inputs
        MMCICLK          : in    std_logic; -- MMCI Bus Clock
        nMMCIRST         : in    std_logic; -- MMCI bus reset
        CRC16En          : in    std_logic; -- Data Crc enable
        DataDirection    : in    std_logic; -- Data direction bit
        MMCIDAT          : in    std_logic; -- MMCI data serial input
-- Outputs
        CRC16            : out   std_logic_vector(15 downto 0);
                                            -- CRC16 computed value
        DCrcBufferBit    : out   std_logic  -- Crc buffer bit to
                                            -- counter 1 clk latency
                                            -- in CRC16 calculation
       );
end MmciTrCrc16gen;

-- -----------------------------------------------------------------------------
--
--                               MmciTrCrc16gen
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--  This module is used in generation of CRC16 required in data
-- transmission and reception.This module uses 16 flops and three xor
-- gates to generate a 16 bit Crc on the incoming data bits.
--
-- -----------------------------------------------------------------------------

-- --=============================== ARCHITECTURE ============================--

architecture behavioural of MmciTrCrc16gen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iCRC16           : std_logic_vector(15 downto 0);
-- Local copy of the CRC16 output

signal DelCRC16         : std_logic_vector(15 downto 0);
-- Delayed iCRC16

signal DataBit          : std_logic;
-- Data bit obtained serially on Data line

signal ShiftIn          : std_logic;
-- Input to the CRC generation logic

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
-- Connect local copies to output ports.When this module is used for
-- calculation of CRC for data to be sent, then there exists a two clk
-- latency between the transmission of a bit and computation of CRC
-- inclusive the transmitted bit.Since the transmission of CRC has to
-- commence immediately after the last bit of response a DCrcBufferBit
-- is used, which will hold the first bit of crc during the clock the
-- last bit of data is being transmitted.When this module is used to
-- compute crc for the data being recieved, which will be used only in
-- verification, the delayed version of computed crc is given out for
-- verification to tackle the one clk latency between the recd bit and
-- computation of crc including this bit.
-- -----------------------------------------------------------------------------
CRC16         <= DelCRC16 when DataDirection = '0'
              else
                 iCRC16;

-- -----------------------------------------------------------------------------
-- Computing the Input value to the CRC16 generation logic
-- -----------------------------------------------------------------------------
DataBit       <= MMCIDAT;
ShiftIn       <= DataBit xor iCRC16(15) when (DataBit = '1' or
                                              DataBit = '0')
              else
                 '0';
DCrcBufferBit <= iCRC16(14);

-- -----------------------------------------------------------------------------
-- CRC16 generation process.For incoming bits the crc computation is
-- enabled from the start bit till the last bit of crc is received.If
-- the computed crc results to zero then the data received is not
-- garbled anywhere.For bits, outgoing from the trickbox, crc
-- computation is enabled for those bits of response, which excludes
-- the crc field and the end bit and at the point where the crc is to be
-- transmitted the computed value is transmitted.
-- -----------------------------------------------------------------------------
p_Crc16gen : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iCRC16    <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CRC16En = '1') then
      iCRC16(0)            <= ShiftIn;
      iCRC16(4 downto 1)   <= iCRC16(3 downto 0);
      iCRC16(5)            <= ShiftIn xor iCRC16(4);
      iCRC16(11 downto 6)  <= iCRC16(10 downto 5);
      iCRC16(12)           <= ShiftIn xor iCRC16(11);
      iCRC16(15 downto 13) <= iCRC16(14 downto 12);
    else
      iCRC16  <= (others => '0');
    end if;
  end if;
end process p_Crc16gen;

-- -----------------------------------------------------------------------------
-- Sequential process for Delayed CRC16 generation
-- -----------------------------------------------------------------------------
p_DelCrc16 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCRC16 <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (CRC16En = '1') then
      DelCRC16 <= iCRC16;
    else
      DelCRC16 <= (others => '0');
    end if;
  end if;
end process p_DelCrc16;
end behavioural;

-- --================================== End ==================================--
