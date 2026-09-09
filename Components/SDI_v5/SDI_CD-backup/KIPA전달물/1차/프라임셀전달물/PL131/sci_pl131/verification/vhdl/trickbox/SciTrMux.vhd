-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrMux.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This block work as MUX between the receiver and transmitter   
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--------------------------------------------------------------------------------

entity SciTrMux is
port (
      SCICLK        : in   std_logic;  -- SCICLK input 
      PRESETn       : in   std_logic;  -- reset input
      TrTXEn        : in   std_logic;  -- Transmiter En
      TrRXEn        : in   std_logic;  -- Receiver En
      SCIDATAIN     : in   std_logic;  -- Input
      TXSCIDATAIN   : out  std_logic;  -- Transmiter input
      RXSCIDATAIN   : out  std_logic;  -- Receiver input
      TXSCIDATAOUT  : in   std_logic;  -- Transmiter output
      RXSCIDATAOUT  : in   std_logic;  -- Receiver output
      SCIDATAOUT    : out  std_logic   -- Output
     );
end SciTrMux;

--------------------------------------------------------------------------------
--
--                   SciTrMux
--                   ========
--
--------------------------------------------------------------------------------
-- Overview
-- ========
--
-- Depend on the condition of the transmit or  receive enable this modlue
-- connect transmit or recive state mechine to the output world 
--
--------------------------------------------------------------------------------

--=============================== ARCHITECTURE ===============================--

architecture synth of SciTrMux  is

--------------------------------------------------------------------------------
--  Main body of code 
-- ==================
--
--------------------------------------------------------------------------------

begin
 
p_OutMuxComb : process(TrTXEn,TrRXEn,TXSCIDATAOUT, RXSCIDATAOUT,SCIDATAIN)
begin
  if (TrTXEn ='1') then
    SCIDATAOUT   <= TXSCIDATAOUT;
    TXSCIDATAIN  <= SCIDATAIN;
    RXSCIDATAIN  <= '1';
  elsif (TrRXEn = '1') then
    SCIDATAOUT   <= RXSCIDATAOUT;
    TXSCIDATAIN  <= '1';
    RXSCIDATAIN  <= SCIDATAIN;
  else
    SCIDATAOUT   <= '1';
    TXSCIDATAIN  <= '1';
    RXSCIDATAIN  <= '1';
  end if;       
end process p_OutMuxComb;
      
end synth;

--=============================== End =======================================--













