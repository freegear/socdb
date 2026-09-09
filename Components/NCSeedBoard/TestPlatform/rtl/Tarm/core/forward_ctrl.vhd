-- VHDL Model Created from SGE Symbol forward_ctrl.sym -- Jun 27 14:46:20 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity FORWARD_CTRL is
      Port (     CLK : In    std_logic;
               FLUSH : In    std_logic;
             ID_COND_ROP : In    std_logic;
              ID_RA1 : In    std_logic_vector (4 downto 0);
              ID_RA2 : In    std_logic_vector (4 downto 0);
              ID_RA3 : In    std_logic_vector (4 downto 0);
              ID_RA4 : In    std_logic_vector (4 downto 0);
             ID_ROP1 : In    std_logic;
             ID_ROP2 : In    std_logic;
             ID_ROP3 : In    std_logic;
             ID_ROP4 : In    std_logic;
               STALL : In    std_logic;
             X1_COND_WOP : In    std_logic_vector (1 downto 0);
              X1_WA1 : In    std_logic_vector (4 downto 0);
              X1_WA2 : In    std_logic_vector (4 downto 0);
             X1_WOP1 : In    std_logic_vector (1 downto 0);
             X1_WOP2 : In    std_logic_vector (1 downto 0);
             X2_COND_WOP : In    std_logic_vector (1 downto 0);
              X2_WA1 : In    std_logic_vector (4 downto 0);
              X2_WA2 : In    std_logic_vector (4 downto 0);
             X2_WOP1 : In    std_logic_vector (1 downto 0);
             X2_WOP2 : In    std_logic_vector (1 downto 0);
             COND_SEL : Out   std_logic_vector (1 downto 0);
              R1_SEL : Out   std_logic_vector (1 downto 0);
              R2_SEL : Out   std_logic_vector (1 downto 0);
              R3_SEL : Out   std_logic_vector (1 downto 0);
              R4_SEL : Out   std_logic_vector (1 downto 0) );
end FORWARD_CTRL;

architecture BEHAVIORAL of FORWARD_CTRL is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

    -- XX_WOP#(1 downto 0)
	-- XX: Operation Stage
	-- #: Write Register Port Number

	-- XX_WOP#(0): 0=write disable, 1=write enable
	-- XX_WOP#(1): 0=write value is created in X1 stage
	-- XX_WOP#(1): 1=write value is created in X2 stage
	signal r1_seli,r2_seli,r3_seli,r4_seli : std_logic_vector (1 downto 0);
	signal cond_seli :  std_logic_vector (1 downto 0);
begin

	FORWARD : process (ID_ROP1,ID_ROP2,ID_ROP3,ID_ROP4, 
					   ID_RA1,ID_RA2,ID_RA3,ID_RA4,
					   X1_WOP1,X1_WOP2,X1_WA1,X1_WA2,
					   X2_WOP1,X2_WOP2,X2_WA1,X2_WA2,
					   X1_COND_WOP,X2_COND_WOP)
	begin

		-- R1 Select
		if (ID_ROP1='1' and X1_WOP1 = "01" and ID_RA1 = X1_WA1  ) then
			r1_seli <= "01";  		-- R1 <= X1_WR
		elsif (ID_ROP1='1' and X1_WOP2 = "01" and ID_RA1 = X1_WA2  ) then
			r1_seli <= "01";  		-- R1 <= X1_WR
		elsif (ID_ROP1='1' and X2_WOP1(0) = '1' and ID_RA1 = X2_WA1  ) then
			r1_seli <= "10";  		-- R1 <= X2_WR1
		elsif (ID_ROP1='1' and X2_WOP2(0) = '1' and ID_RA1 = X2_WA2  ) then
			r1_seli <= "11";  		-- R1 <= X2_WR2
		else
			r1_seli <= "00";
		end if;

		-- R2 Select
		if (ID_ROP2='1' and X1_WOP1 = "01" and ID_RA2 = X1_WA1  ) then
			r2_seli <= "01";  		-- R2 <= X1_WR
		elsif (ID_ROP2='1' and X1_WOP2 = "01" and ID_RA2 = X1_WA2  ) then
			r2_seli <= "01";  		-- R2 <= X1_WR
		elsif (ID_ROP2='1' and X2_WOP1(0) = '1' and ID_RA2 = X2_WA1  ) then
			r2_seli <= "10";  		-- R2 <= X2_WR1
		elsif (ID_ROP2='1' and X2_WOP2(0) = '1' and ID_RA2 = X2_WA2  ) then
			r2_seli <= "11";  		-- R2 <= X2_WR2
		else
			r2_seli <= "00";
		end if;

		-- R3 Select
		if (ID_ROP3='1' and X1_WOP1 = "01" and ID_RA3 = X1_WA1  ) then
			r3_seli <= "01";  		-- R3 <= X1_WR
		elsif (ID_ROP3='1' and X1_WOP2 = "01" and ID_RA3 = X1_WA2  ) then
			r3_seli <= "01";  		-- R3 <= X1_WR
		elsif (ID_ROP3='1' and X2_WOP1(0) = '1' and ID_RA3 = X2_WA1  ) then
			r3_seli <= "10";  		-- R3 <= X2_WR1
		elsif (ID_ROP3='1' and X2_WOP2(0) = '1' and ID_RA3 = X2_WA2  ) then
			r3_seli <= "11";  		-- R3 <= X2_WR2
		else
			r3_seli <= "00";
		end if;

		-- R4 Select
		if (ID_ROP4='1' and X1_WOP1 = "01" and ID_RA4 = X1_WA1  ) then
			r4_seli <= "01";  		-- R4 <= X1_WR
		elsif (ID_ROP4='1' and X1_WOP2 = "01" and ID_RA4 = X1_WA2  ) then
			r4_seli <= "01";  		-- R4 <= X1_WR
		elsif (ID_ROP4='1' and X2_WOP1(0) = '1' and ID_RA4 = X2_WA1  ) then
			r4_seli <= "10";  		-- R4 <= X2_WR1
		elsif (ID_ROP4='1' and X2_WOP2(0) = '1' and ID_RA4 = X2_WA2  ) then
			r4_seli <= "11";  		-- R4 <= X2_WR2
		else
			r4_seli <= "00";
		end if;

		if (X1_COND_WOP = "01") then
			cond_seli <= "01";  -- X1_COND
		elsif (X2_COND_WOP(0) = '1') then
			cond_seli <= "10";  -- X2_COND
		else
			cond_seli <= "00"; 
		end if;

	end process;	-- End of FORWARD


	FF_REG : process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (FLUSH = '1') then
				R1_SEL <= "00";
				R2_SEL <= "00";
				R3_SEL <= "00";
				R4_SEL <= "00";
				COND_SEL <= "00";
			elsif (STALL= '0') then
				R1_SEL <= r1_seli;
				R2_SEL <= r2_seli;
				R3_SEL <= r3_seli;
				R4_SEL <= r4_seli;
				COND_SEL <= cond_seli;
			end if;
		end if;
	end process;
end BEHAVIORAL;

configuration CFG_FORWARD_CTRL of FORWARD_CTRL is
   for BEHAVIORAL

   end for;

end CFG_FORWARD_CTRL;
