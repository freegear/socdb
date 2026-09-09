-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2003 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : SmcWrEnGen.vhd.rca
-- File Revision          : 1.22
--
-- Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block has the logic for the generation of positive clocked and
--           negative clocked write enable and byte lane enable signals module.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SmcWrEnGen is
  port (
-- Inputs
        nHCLK            : in    std_logic; -- AHB Clock negative
        HCLK             : in    std_logic; -- Bus Clock
        HRESETn          : in    std_logic; -- Bus Clock
        RBLE             : in    std_logic; -- Byte lane enabled device
        PosSMWEN         : in    std_logic; -- Positive edge (HCLK) triggered
                                            -- Write Enable, SMWEN
        PosSMBLS         : in    std_logic_vector(3 downto 0);
                                            -- Positive edge (HCLK) triggered
                                            -- byte lane select, SMBLS
        ExtWrEnCo        : in    std_logic; -- enable signal for generation
                                            -- of write enable and bytelane
                                            -- select
        XoutEnCo         : in    std_logic; -- Enable signal for the nSMOEN
                                            -- during reads

-- Outputs
        nSMWEN           : out   std_logic; -- Memory device write enable pin
        nSMBLS           : out   std_logic_vector(3 downto 0)
                                            -- Byte Lane selects pins
       );
end SmcWrEnGen;

-- -----------------------------------------------------------------------------
--
--                                 SmcWrEnGen
--                                 ==========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--         The negative clocked flops are placed in this block which are used
--         to generate the negative clocked write enables and byte lane enables
--         The positive clocked write enables and byte lane enables are
--         generated in the SmcEIB module. The final multiplexer chooses
--         between the positive SMWEN/SMBLS and the negative SMWEN/SMBLS. This
--         routing depends on the type of device and the type of transfer. The
--         different scenarios are enumerated :
--         1. For a RBLE device during writes - Negative SMWEN and positive
--            SMBLS are routed. The SMBLS will have same timing as the chip
--            select.
--         2. For a RBLE device during reads - Positive SMBLS signals are routed
--         3. For a non-RBLE device during writes - SMWEN is not used/connected.
--            Negative SMBLS lines are routed out to the memory device.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture synth of SmcWrEnGen is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal NegSMBLS         : std_logic_vector(3 downto 0);
-- Negative edge (nHCLK) triggered Byte lane select, BLS

signal PosBlsSel        : std_logic;
-- Write enable select between the positive and negative clocked SMBLS

signal NextPosBlsSel    : std_logic;
-- D-input of PosBlsSel

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
-- Combinational logic for memory write enables
-- -----------------------------------------------------------------------------
p_BlsSelGenComb : process (ExtWrEnCo, RBLE, XoutEnCo, PosBlsSel)
begin
  NextPosBlsSel      <= PosBlsSel;

  if ((ExtWrEnCo = '1' or XoutEnCo = '1') and (RBLE = '1')) then
    NextPosBlsSel   <= '1';
  elsif (ExtWrEnCo = '1' and RBLE = '0') then
    NextPosBlsSel   <= '0';
  end if;

end process p_BlsSelGenComb;

-- -----------------------------------------------------------------------------
-- Sequential/clocked logic for the positive write enable signals
-- -----------------------------------------------------------------------------
p_PosWrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    PosBlsSel <= '0';
  elsif (HCLK'event and HCLK = '1') then
    PosBlsSel <= NextPosBlsSel;
  end if;

end process p_PosWrGenSeq;

-- -----------------------------------------------------------------------------
-- Generate the negative clock triggered WEN and BLS using nHCLK. There is no
-- separate RESET for the nHCLK domain, but the signals will get reset in the
-- subsequent negative clock edge after the positive clocked signals are reset
-- in the HCLK domain.
-- -----------------------------------------------------------------------------
p_NegWrEnSeq : process (nHCLK)
begin

  if (nHCLK'event and nHCLK = '1') then
    nSMWEN    <= PosSMWEN;
    NegSMBLS  <= PosSMBLS;
  end if;
end process p_NegWrEnSeq;

-- -----------------------------------------------------------------------------
-- This is the final output multiplexer logic which will select between the
-- rising clock domain and falling clock domain sets of the SMBLS
-- output signals as the final pad outputs
-- -----------------------------------------------------------------------------
p_FinalBlsComb : process (PosSMBLS, NegSMBLS, PosBlsSel)
begin

  case PosBlsSel is
    when '1' =>
      nSMBLS  <= PosSMBLS;
    when '0' =>
      nSMBLS  <= NegSMBLS;
    when others =>
      null;
  end case;
end process p_FinalBlsComb;

end synth;

-- --================================== End ==================================--
