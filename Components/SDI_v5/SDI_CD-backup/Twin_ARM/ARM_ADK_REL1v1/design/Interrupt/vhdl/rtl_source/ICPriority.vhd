-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ICPriority.vhd,v
-- File Revision          : 1.4
--
-- Release Information    : ADK_REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block implements the Interrupt Priority Logic.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity ICPriority is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        PriorWrEnCo      : in    std_logic; -- VectAddr Write Enable
        PriorRdEn        : in    std_logic; -- VectAddr Read Enable from ICAhbif
        NonVectIrqCo     : in    std_logic; -- Non-Vectored Interrupt

        ICDefVectAddr    : in    std_logic_vector(31 downto 0);
                                            -- Default Vector address

        nICIRQIN         : in    std_logic; -- Normal interrupt input
        ICVECTADDRIN     : in    std_logic_vector(31 downto 0);
                                            -- Interrupt Vector input
-- Outputs
        ICIRQCo          : out   std_logic; -- IRQ interrupt status
                                            -- to ICITOP1 register
        nICIRQ           : out   std_logic; -- Normal interrupt output
        ICVECTADDROUTCo  : out   std_logic_vector(31 downto 0)
                                            -- Vector Address output
       );
end ICPriority;

-- -----------------------------------------------------------------------------
--
--                             ICPriority
--                             ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This module implements the priority scheme between internal and external
-- (daisy-chain) interrupts. The internal interrupts have priority over external
-- and a read from the ICVectAddr register with a pending internal interrupts
-- will cause the NonVectIrqServ flag to be set, masking that and any external
-- interrupts.
-- A write to the ICVectAddr register will cause NonVectIrqServ flag to be
-- cleared indicating that this Interrupt has been serviced.
--
-- -----------------------------------------------------------------------------

-- --======================== ARCHITECTURE =========================--

architecture synth of ICPriority is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal NonVectIrqServ    : std_logic; -- NonVectored IRQ being serviced
signal NxtNonVectIrqServ : std_logic; -- D-input of NonVectIrqServ
signal NonVectIrqActive  : std_logic; -- Indicates NonVectIrq is active

signal iICIRQ            : std_logic; -- Internal copy of ICIRQ

signal NxtAddrOut : std_logic_vector(31 downto 0);
                                      -- D-input of ICVECTADDROUT

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
-- Combinational logic for generating ICVECTADDROUTCo
--
-- The Output vector is selected based on the following priority
-- Highest -> Non-Vectored Interrupt
-- Lowest  -> External IRQ
--
-- Note that the ICVECTADDRIN will be selected as the output
-- vector only if the Non-Vectored interrupts have been serviced.
-- If no interrupt is there then default Vector Address will be selected.
-- -----------------------------------------------------------------------------
NxtAddrOut       <= ICDefVectAddr when (NonVectIrqCo = '1') else

                    ICVECTADDRIN when (nICIRQIN = '0') else

                    ICDefVectAddr;

-- -----------------------------------------------------------------------------
-- Sequential process for generating the ICVECTADDROUT signal.
-- Also registers the NonVectIrq signal
-- -----------------------------------------------------------------------------
p_VectAddrOutSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    ICVECTADDROUTCo <= (others => '0');
    NonVectIrqActive <= '0';
  elsif (HCLK'event and HCLK = '1') then
    ICVECTADDROUTCo <= NxtAddrOut;
    NonVectIrqActive <= NonVectIrqCo;
  end if;
end process p_VectAddrOutSeq;

-- -----------------------------------------------------------------------------
-- Generate the interrupt from either source, if the service flag is not set.
-- -----------------------------------------------------------------------------
iICIRQ          <= '1' when ((NonVectIrqCo = '1' or nICIRQIN = '0') and
                             NonVectIrqServ = '0') else

                   '0';

-- -----------------------------------------------------------------------------
-- Create the active low version of the output interrupt
-- -----------------------------------------------------------------------------
nICIRQ          <= not iICIRQ;

-- -----------------------------------------------------------------------------
-- Combinational logic for the NonVectIrq service register
-- -----------------------------------------------------------------------------
p_NonVectIrqServComb : process (NonVectIrqActive, NonVectIrqServ, PriorRdEn,
                                PriorWrEnCo)
begin
  -- If a read is detected to the ICVectAddr register, set the NonVectIrqServ
  -- signal, masking out the NonVect IRQ and daisy chain interrupts.
  if (PriorRdEn = '1') then
    NxtNonVectIrqServ <= NonVectIrqActive;

  -- If a write is detected to the ICVectAddr register, clear the NonVectIrqServ
  -- signal, indicating that the ISR has finished servicing this interrupt.
  elsif (PriorWrEnCo = '1') then
    NxtNonVectIrqServ <= '0';
  else
    NxtNonVectIrqServ <= NonVectIrqServ;
  end if;
end process p_NonVectIrqServComb;

-- -----------------------------------------------------------------------------
-- Sequential logic for the NonVectIrq Service register
-- -----------------------------------------------------------------------------
p_NonVectIrqServSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0') then
    NonVectIrqServ <= '0';
  elsif (HCLK'event and HCLK = '1') then
    NonVectIrqServ <= NxtNonVectIrqServ;
  end if;
end process p_NonVectIrqServSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
ICIRQCo          <= iICIRQ;

end synth;

-- --================================== End ==================================--
