--
--       FullAdder.VHD
--       for ?
--
--       Version 1.0 (?/?/?)
--       Designed by ?, ?, ? and ImJH.
--
--       Copyright (c) ? by ? in ?
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity FADD is
    port (A,
          B,
          C : in std_logic;
          SUM,
          CARRY : out std_logic);
end FADD;

architecture BEHAVIORAL of FADD is
begin
    SUM   <= A xor B xor C;
    CARRY <= (A and B) or (B and C) or (C and A);
end BEHAVIORAL;

configuration CFG_FADD of FADD is
	for BEHAVIORAL

	end for;
end CFG_FADD;
