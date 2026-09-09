
library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_arith.all;
   use IEEE.std_logic_misc.all;

entity COND_CHECK is
      Port ( 
           		CPSR_COND : In    std_logic_vector (3 downto 0);
             	INST_COND : In    std_logic_vector (3 downto 0);
                COND_PASS : Out   std_logic);
end COND_CHECK;

architecture BEHAVIORAL of COND_CHECK is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------
begin
	-- According to ARM_ARM. Table 3-1 condition codes
    process (CPSR_COND, INST_COND )
	variable n_flag,z_flag,c_flag,v_flag: std_logic;
	begin
		n_flag := CPSR_COND(3);
		z_flag := CPSR_COND(2);
		c_flag := CPSR_COND(1);
		v_flag := CPSR_COND(0);
		case INST_COND is
		when "0000" => -- Equal: Z set
			if(z_flag='1') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0001" => -- Not equal: Z clear
			if(z_flag='0') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0010" => -- Carry set/unsigned higher or same: C set
			if(c_flag='1') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0011" => -- Carry clear/unsigned lower: C clear
			if(c_flag='0') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0100" => -- Minus/negative: N set
			if(n_flag='1') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0101" => -- Plus/positive or zero: N clear
			if(n_flag='0') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0110" => -- Overflow: V set
			if(v_flag='1') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "0111" => -- No overflow: V clear
			if(v_flag='0') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "1000" => -- Unsigned higher: C set and Z clear
			if(c_flag='1' and z_flag='0') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "1001" => -- Unsigned lower or same: C clear or Z set
			if(c_flag='0' or z_flag='1') then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "1010" => -- Signed greater than or equal: N==V
			if(n_flag=v_flag) then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "1011" => -- Signed less : N!=V
			if(n_flag/=v_flag) then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "1100" => -- Signed greater than: Z==0 and N==V
			if(z_flag ='0' and n_flag=v_flag) then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;
		when "1101" => -- Signed less than or equal: Z==1 or N!=V
			if(z_flag='1' or n_flag/=v_flag) then
				COND_PASS <= '1';
			else
				COND_PASS <= '0';
			end if;

		when "1110" => -- Always (unconditional)
			COND_PASS <= '1';

		when "1111" => -- ToyARM implements as Always
			COND_PASS <= '1';

		when others =>
			COND_PASS <= '0';
		end case;
			
	end process;

end BEHAVIORAL;

configuration CFG_COND_CHECK of COND_CHECK is
   for BEHAVIORAL

   end for;

end CFG_COND_CHECK;
