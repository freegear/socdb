--
--       ModifiedBoothEncoder.VHD
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

entity MBE is
    port (a : in std_logic_vector (33 downto 0);
          b : in std_logic_vector (2 downto 0);
          carry : out std_logic;
          data  : out std_logic_vector (63 downto 0));
end MBE;

architecture BEHAVIORAL of MBE is
begin
    process (a, b)
        variable inva : std_logic_vector (33 downto 0);
        variable doublea,
                 temp : std_logic_vector (63 downto 0);
    begin
        inva    := not a;
        doublea := sxt(a, 63) & '0';
        case b is
            when "000"  => carry <= '0'; temp := (others => '0');
            when "001"  => carry <= '0'; temp := sxt(a, 64);
            when "010"  => carry <= '0'; temp := sxt(a, 64);
            when "011"  => carry <= '0'; temp := doublea;
            when "100"  => carry <= '1'; temp := not doublea;
            when "101"  => carry <= '1'; temp := sxt(inva, 64);
            when "110"  => carry <= '1'; temp := sxt(inva, 64);
            when "111"  => carry <= '0'; temp := (others => '0');
--            when others => null;
            when  others  => carry <= '0'; temp := (others => '0');
        end case;
--      data <= "0000000000000000000000000000000" & (not temp(32)) & temp(31 downto 0); -- sign generation method
        data <= "00000000000000000000000000000"   & (not temp(34)) & temp(33 downto 0); -- sign generation method
    end process;
end BEHAVIORAL;

configuration CFG_MBE of MBE is
   for BEHAVIORAL

   end for;

end CFG_MBE;
