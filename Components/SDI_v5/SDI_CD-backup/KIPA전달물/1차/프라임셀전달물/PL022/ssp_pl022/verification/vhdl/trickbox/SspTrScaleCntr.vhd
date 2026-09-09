--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name              : SspTrScaleCntr.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
-- -----------------------------------------------------------------------------
-- Purpose      : This module implements the SSPCLK-domain 
--                buffers of the 2-buffer synchronisation mechanism.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SspTrScaleCntr is
  port (
        SSPCLK        :	in    std_logic;  -- Main SSP clock
        nSSPRES       :	in    std_logic;  -- Muxed reset (from nSSPRST)
        SSESync       :	in    std_logic;  -- SSP enable
        CR0UpdateSync :	in    std_logic;  -- SSCR0 update
        CR1UpdateSync :	in    std_logic;  -- SSCR0 update
        SSPTBCR0      :	in    std_logic_vector(15 downto 0);
                                          -- 2nd buffer
        SSPTBCR1      :	in    std_logic_vector(5 downto 0);
                                          -- 2nd buffer
        SSPTBPRE      : in    std_logic_vector(3 downto 0);
                                          -- Prescale Reg
        SPO           :	out   std_logic;  -- SCLK polarity
        SPH           :	out   std_logic;  -- SCLK phase
        SSPCLKDIV     : out   std_logic;  -- Prescaled output
        DSS           :	out   std_logic_vector(3 downto 0);
                                          -- Bits per frame
        FRF           : out   std_logic_vector(1 downto 0);
                                          -- Frame format
        SCR           : out   std_logic_vector(7 downto 0)
                                          -- Serial clk rate
       );
end SspTrScaleCntr;

-- -----------------------------------------------------------------------------
--
--                            SspTrScaleCntr
--                            ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
--  This module  contains the SSPCLK domain buffers of the SSP control
-- registers. The distinct bit information from these buffers is separated out
-- and driven as individual outputs.
-- 
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of SspTrScaleCntr  is

-- -----------------------------------------------------------------------------
-- signal declarations 
-- -----------------------------------------------------------------------------
signal SSPCPSC          : std_logic_vector(6 downto 0);
-- SSP Clock Pre-Scale Counter 

signal NextSSPCPSC      : std_logic_vector(6 downto 0);
-- D-input of SSPCPSC

signal CR0              : std_logic_vector(15 downto 0);
-- Second stage buffer for SSPTBCR0

signal CR1              : std_logic_vector(5 downto 0);
-- Second stage buffer for SSPTBCR0

signal NextCR0          : std_logic_vector(15 downto 0);
-- D-input of SSPTBCR0

signal NextCR1          : std_logic_vector(5 downto 0);
-- D-input of SSPTBCR0

signal DelCR0Update     : std_logic;
-- Delayed version of SSPTBCR0UpdateSync

signal DelCR1Update     : std_logic;
-- Delayed version of SSPTBCR0UpdateSync

signal CR0Stg2WrEn      : std_logic;
-- Load signal for the second stage buffer for SSPPTBCR0 register

signal CR1Stg2WrEn      : std_logic;
-- Load signal for the second stage buffer for SSPPTBCR0 register

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Prescaler to divide SSPCLK by the value programmed in SSCPSR register
-- -----------------------------------------------------------------------------
p_CntSeq : process (SSPCLK, nSSPRES)
begin
  if (nSSPRES = '0') then
    SSPCPSC <= (others => '1');
  elsif (SSPCLK'event and SSPCLK = '1') then
    SSPCPSC <= NextSSPCPSC;
  end if;
end process p_CntSeq;
 
-- -----------------------------------------------------------------------------
--  Prescaler to divide SSPCLK by the value programmed in SSCPSR register. The
-- counter is reloaded with the value in the SSCPSRBuf3 register when any of
-- the following conditions occur:
--  * When the counter counts down and reaches the value of "0001"
--  * When the SSP is disabled (so that on enabling the SSP, the counter starts
--    counting down from the reload value)
-- 
--  When the CPSR register is rewritten, i.e. when then reload value is changed,
-- the counter continues counting down and after reaching the count of "0001",
-- new reload value is loaded into the counter. Thus, there is a maximum
-- possible latency of 15 SSPCLK cycles before the new reload value takes
-- full effect after the second stage buffer has been updated.
-- -----------------------------------------------------------------------------
p_CntComb : process (SSPCPSC, SSPTBPRE, SSESync )
begin
  if ((SSESync = '0') or (SSPCPSC = "0000001")) then
    NextSSPCPSC <= "000" & SSPTBPRE;
  else
    NextSSPCPSC <= unsigned(SSPCPSC) - 1;
  end if;
end process p_CntComb;
 
-- -----------------------------------------------------------------------------
-- When the SSPCPSC counter reaches 1, assert the SSPCLKDIV signal.
-- -----------------------------------------------------------------------------
SSPCLKDIV <= '1' when (SSPCPSC = "0000001")
          else
             '0';

-- -----------------------------------------------------------------------------
-- Second stage buffers for the SSPTBCR0 and SSPTBCR1 registers.
-- -----------------------------------------------------------------------------
p_RegSeq: process (SSPCLK, nSSPRES)
begin
  if (nSSPRES = '0') then
    CR0  <= (others => '0');
    CR1  <= (others => '0');
  elsif (SSPCLK'event and SSPCLK = '1') then
    CR0  <= NextCR0;
    CR1  <= NextCR1;
  end if;
end process p_RegSeq;

-- -----------------------------------------------------------------------------
-- Generation of delayed versions of the Update trigger inputs.
-- -----------------------------------------------------------------------------
p_TriggerDel: process (SSPCLK, nSSPRES)
begin
  if (nSSPRES = '0') then
    DelCR0Update  <= '0';
    DelCR1Update  <= '0';
  elsif (SSPCLK'event and SSPCLK = '1') then
    DelCR0Update  <= CR0UpdateSync;
    DelCR1Update  <= CR0UpdateSync;
  end if;
end process p_TriggerDel;
 
-- -----------------------------------------------------------------------------
-- Generation of load signals for second stage buffers.
-- -----------------------------------------------------------------------------
CR0Stg2WrEn  <= CR0UpdateSync xor DelCR0Update;
CR1Stg2WrEn  <= CR1UpdateSync xor DelCR1Update;

-- -----------------------------------------------------------------------------
-- When the CR0Stg2WrEn signal is asserted, clock in the value on the 
-- SSPTBCR0 input into the CR0 register.
-- -----------------------------------------------------------------------------
p_CR0Comb: process (CR0Stg2WrEn, SSPTBCR0, CR0)
begin
  if (CR0Stg2WrEn = '1') then
    NextCR0 <= SSPTBCR0;
  else
    NextCR0 <= CR0;
  end if;
end process p_CR0Comb;

-- -----------------------------------------------------------------------------
-- When the CR1Stg2WrEn signal is asserted, clock in the value on the 
-- SSPTBCR1 input into the CR1 register.
-- -----------------------------------------------------------------------------
p_CR1Comb: process (CR1Stg2WrEn, SSPTBCR1, CR1)
begin
  if (CR1Stg2WrEn = '1') then
    NextCR1 <= SSPTBCR1;
  else
    NextCR1 <= CR1;
  end if;
end process p_CR1Comb;

-- -----------------------------------------------------------------------------
-- Separate the bit fields in CR0 and assign them to the respective 
-- outputs
-- -----------------------------------------------------------------------------
DSS   <= CR0(3 downto 0);
FRF   <= CR0(5 downto 4);
SPO   <= CR1(0);
SPH   <= CR1(1);
SCR   <= CR0(15 downto 8);
end behavioural;

-- --============================ End ========================================--
