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
-- File Name              : MmciTrCrc7gen.vhd.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module is used for computing the CRC7 value while
--           transmitting a response and also for verification of the
--           received CRC7 in case of command reception
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity MmciTrCrc7gen is
  port (
-- Inputs
        MMCICLK          : in    std_logic; -- MMCI Bus clock
        nMMCIRST         : in    std_logic; -- MMCI Bus reset
        Crc7En           : in    std_logic; -- Crc7 Enable bit
        SendResponse     : in    std_logic; -- Qualifies response bits
        MMCICMD          : in    std_logic; -- MMCI Command line
-- Outputs
        CRC7             : out   std_logic_vector(6 downto 0);
                                            -- Crc value computed
        CrcBufferBit     : out   std_logic  -- Used to makeup the 2 clk
                                            -- latency b/w CmdCnt & CRC7
       );
end MmciTrCrc7gen;

-- -----------------------------------------------------------------------------
--
--                                MmciTrCrc7gen
--                                =============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module is used in generation of CRC7 required in command
-- transmission.It uses seven flops and two xor gates to generate the
-- 7 bit CRC on the incoming command bits.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of MmciTrCrc7gen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iCRC7            : std_logic_vector(6 downto 0);
-- Local copy of the CRC7 output

signal ShiftIn          : std_logic;
-- Input to the CRC generation logic

signal DelCRC7          : std_logic_vector(6 downto 0);
-- Delayed iCRC7

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
-- calculation of CRC for response to be sent, then there exists a two
-- clk latency between the transmission of a bit and computation of CRC
-- inclusive the transmitted bit.Since the transmission of CRC has to
-- commence immediately after the last bit of response a CrcBufferBit is
-- used, which will hold the first bit of crc during the clock the last
-- bit of response is being transmitted.When this module is used to
-- compute crc for the command being recieved, which will be used only
-- in verification, the delayed version of computed crc is given out for
-- verification to tackle the one clk latency between the recd bit and
-- computation of crc including this bit
-- -----------------------------------------------------------------------------
CRC7         <= iCRC7 when SendResponse = '1'
             else
                DelCRC7;

CrcBufferBit <= iCRC7(5);

-- -----------------------------------------------------------------------------
-- Computing the Input value to the CRC7 generation logic
-- -----------------------------------------------------------------------------
ShiftIn <= MMCICMD xor iCRC7(6) when (MMCICMD = '1' or MMCICMD = '0')
        else
           '0';

-- -----------------------------------------------------------------------------
-- CRC7 generation process.For incoming bits the crc computation is
-- enabled from the start bit till the last bit of crc is received.If
-- the computed crc results to zero then the command received is not
-- garbled anywhere.For bits, outgoing from the TB, crc computation
-- is enabled for those bits of response, which excludes the crc field
-- crc field and the end bit and at the point where the crc is to be
-- transmitted the computed value is transmitted.
-- -----------------------------------------------------------------------------
p_Crc7gen : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    iCRC7  <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (Crc7En = '1') then
      iCRC7(0)          <= ShiftIn;
      iCRC7(2 downto 1) <= iCRC7(1 downto 0);
      iCRC7(3)          <= iCRC7(2) xor Shiftin;
      iCRC7(6 downto 4) <= iCRC7(5 downto 3);
    else
      iCRC7 <= (others => '0');
    end if;
  end if;
end process p_Crc7gen;

-- -----------------------------------------------------------------------------
-- Sequential process for CRC7 generation
-- -----------------------------------------------------------------------------
p_DelCrc7 : process (MMCICLK, nMMCIRST)
begin
  if (nMMCIRST = '0') then
    DelCRC7 <= (others => '0');
  elsif (MMCICLK'event and MMCICLK = '1') then
    if (Crc7En = '1') then
      DelCRC7 <= iCRC7;
    else
      DelCRC7 <= (others => '0');
    end if;
  end if;
end process p_DelCrc7;

end behavioural;

-- --================================== End ==================================--
