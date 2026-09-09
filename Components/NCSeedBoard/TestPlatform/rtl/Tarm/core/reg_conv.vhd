-- VHDL Model Created from SGE Symbol reg_conv.sym -- Aug 27 11:28:29 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity REG_CONV is
      Port ( ADDR_IN : In    std_logic_vector (3 downto 0);
                MODE : In    std_logic_vector (4 downto 0);
             ADDR_OUT : Out   std_logic_vector (4 downto 0) );
end REG_CONV;

architecture BEHAVIORAL of REG_CONV is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.27.
	--------------------------------
	-- DEBUG_030826 :  For base address forwarding
	-- DEBUG_030826b: For User mode register access and mode specific base register access

	-- Mode bits
	constant MODE_USER 		: std_logic_vector(4 downto 0) := "10000";
	constant MODE_FIQ 		: std_logic_vector(4 downto 0) := "10001";
	constant MODE_IRQ 		: std_logic_vector(4 downto 0) := "10010";
	constant MODE_SUPERVISOR: std_logic_vector(4 downto 0) := "10011";
	constant MODE_ABORT		: std_logic_vector(4 downto 0) := "10111";
	constant MODE_UNDEFINED	: std_logic_vector(4 downto 0) := "11011";
	constant MODE_SYSTEM 	: std_logic_vector(4 downto 0) := "11111";
	-- DEBUG_030826: For base address forwarding
	constant MODE_NOP		: std_logic_vector(4 downto 0) := "00000";


   begin
	process(MODE,ADDR_IN)
	begin 

	case MODE is
	when MODE_FIQ =>
		-- DEBUG_030722: pc is not translated
		if(ADDR_IN(3)='1' and ADDR_IN /= "1111" ) then -- banked R8~R14
			ADDR_OUT <= '1' & ADDR_IN;
		else
			ADDR_OUT <= '0' & ADDR_IN;
		end if;
	when MODE_SUPERVISOR =>
		if(ADDR_IN="1101") then -- R13_svr
			ADDR_OUT <= "10000"; -- 0x10
		elsif(ADDR_IN="1110") then -- R14_svr
			ADDR_OUT <= "10001"; -- 0x11
		else
			ADDR_OUT <= '0' & ADDR_IN;
		end if;
	when MODE_ABORT =>
		if(ADDR_IN="1101") then -- R13_abt
			ADDR_OUT <= "10010"; -- 0x12
		elsif(ADDR_IN="1110") then -- R14_abt
			ADDR_OUT <= "10011"; -- 0x13
		else
			ADDR_OUT <= '0' & ADDR_IN;
		end if;
	when MODE_UNDEFINED =>
		if(ADDR_IN="1101") then -- R13_und
			ADDR_OUT <= "10100"; -- 0x14
		elsif(ADDR_IN="1110") then -- R14_und
			ADDR_OUT <= "10101"; -- 0x15
		else
			ADDR_OUT <= '0' & ADDR_IN;
		end if;
	when MODE_IRQ =>
		if(ADDR_IN="1101") then -- R13_irq
			ADDR_OUT <= "10110"; -- 0x16
		elsif(ADDR_IN="1110") then -- R14_irq
			ADDR_OUT <= "10111"; -- 0x17
		else
			ADDR_OUT <= '0' & ADDR_IN;
		end if;
	when MODE_NOP =>
		-- DEBUG_030826: For base address forwarding
		ADDR_OUT <= "11111"; -- 0x1F : base address
	when others =>
		ADDR_OUT <= '0' & ADDR_IN;
	end case;
	end process;


end BEHAVIORAL;

configuration CFG_REG_CONV of REG_CONV is
   for BEHAVIORAL

   end for;

end CFG_REG_CONV;
