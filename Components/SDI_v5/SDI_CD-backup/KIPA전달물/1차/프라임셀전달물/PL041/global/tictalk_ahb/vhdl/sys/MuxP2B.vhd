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
-- File Name              : MuxP2B.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Central mux - signals from peripherals to bridge.
--           Stand-alone module to allow ease of removal if an
--           alternative interconnection scheme is to be used.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

entity MuxP2B is
  port(
    PSELUUT   : in  std_logic;
    PSELRPC   : in  std_logic;

    PRDATAUUT : in  std_logic_vector(31 downto 0);
    PRDATARPC : in  std_logic_vector(31 downto 0);

    PRDATA    : out std_logic_vector(31 downto 0)
    );
end MuxP2B;

architecture synth of MuxP2B is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- PselReg encoding. This must be extended if more than eight APB
-- peripherals are used in the system.

  constant PSEL_UUT : std_logic_vector(7 downto 0) := "00000001";
  constant PSEL_RPC : std_logic_vector(7 downto 0) := "00000010";

-- ---------------------------------------------------------------------
-- Signal declaration
-- ---------------------------------------------------------------------
  signal PselBus : std_logic_vector(7 downto 0); -- PSEL input bus

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
  begin

-- ---------------------------------------------------------------------
-- PSEL bus
-- ---------------------------------------------------------------------
-- The internal PSEL bus is made up of the PSEL inputs and extra
-- padding for the bits that are not used.

  PselBus <= "000000" &
             PSELRPC &
             PSELUUT;

-- ---------------------------------------------------------------------
-- Multiplexers
-- ---------------------------------------------------------------------
-- Multiplexers controlling read data from peripherals to the bridge.

-- This module only needs to be as wide as the widest peripheral read
-- data bus, but in this default system it is set to the full 32 bits.
-- The default all zeros case is not strictly required, but may aid
-- debugging by ensuring that the read data bus is zero when no
-- peripherals are being accessed.

  p_PRDATAComb : process (PselBus, PRDATAUUT, PRDATARPC)
  begin
    case PselBus is
      when PSEL_UUT => PRDATA <= PRDATAUUT;
      when PSEL_RPC => PRDATA <= PRDATARPC;
      when others   => PRDATA <= "0000" & "0000" & "0000" & "0000" &
                                 "0000" & "0000" & "0000" & "0000";
    end case;
  end process p_PRDATAComb;

end synth;

-- --============================== End ==============================--
