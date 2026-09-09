-- VHDL Model Created from SGE Symbol wr_backup.sym -- Jul 11 15:38:48 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity WR_BACKUP is
      Port ( BACKUP_OP : In    std_logic_vector (1 downto 0);
                 CLK : In    std_logic;
               FLUSH : In    std_logic;
                 IN1 : In    std_logic_vector (31 downto 0);
                 IN2 : In    std_logic_vector (31 downto 0);
               STALL : In    std_logic;
                OUT1 : Out   std_logic_vector (31 downto 0) );
end WR_BACKUP;

architecture BEHAVIORAL of WR_BACKUP is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.07.
	--------------------------------

   begin
	process(CLK)
	begin
		if(CLK'event and CLK='1') then
			if(FLUSH='1') then
				OUT1 <= (others=>'0');
			elsif(BACKUP_OP(0)='1') then -- write
				if(BACKUP_OP(1)='0') then -- select backuped sorce
					OUT1 <= IN1;		-- From X2_WR1
				else
					OUT1 <= IN2;		-- From X2_WR2
				end if;
			end if;
		end if;

	end process;

end BEHAVIORAL;

configuration CFG_WR_BACKUP of WR_BACKUP is
   for BEHAVIORAL

   end for;

end CFG_WR_BACKUP;
