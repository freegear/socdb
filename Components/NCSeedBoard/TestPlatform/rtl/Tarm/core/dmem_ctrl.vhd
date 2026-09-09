-- VHDL Model Created from SGE Symbol dmem_ctrl.sym -- Jul  4 10:34:15 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity DMEM_CTRL is
      Port (    ADDR : In    std_logic_vector (31 downto 0);
                 CLK : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
                  EN : In    std_logic;
               FLUSH : In    std_logic;
                  OP : In    std_logic_vector (2 downto 0);
               STALL : In    std_logic;
                  DA : Out   std_logic_vector (31 downto 0);
               DDOUT : Out   std_logic_vector (31 downto 0);
                DMAS : Out   std_logic_vector (1 downto 0);
               DMORE : Out   std_logic;
              DNMREQ : Out   std_logic;
                DNRW : Out   std_logic;
                DSEQ : Out   std_logic );
end DMEM_CTRL;

architecture BEHAVIORAL of DMEM_CTRL is

	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.07.30.
	--------------------------------

	-- Main object of this unit is control DNMREQ according to DCACHE's operation.
	-- 1. Address is transferred to DCACHE when dnwait is '1'.
	-- 2. Data is transferred to DCACHE in next cycle when dnwait is '1', 
	--    If in next cycle, dnwait is '0', the Data must be retained until dnwait is '1'.

	signal cur_ddout: std_logic_vector(31 downto 0);

   	begin

	FF:process(CLK)
	-- DATA that will be sent dcache, must be one cycle delayed according to dcache scheme... 
	begin 
		if(CLK'event and CLK='1') then
			if(FLUSH='1') then			
				cur_ddout <= (others=>'0');
			elsif(STALL='0') then
				cur_ddout <= DATA_IN;
			end if;
		end if;
	end process;

	OUTPUT:process(STALL,FLUSH,ADDR,EN,OP,cur_ddout)
	begin

		-- Default Value
		DA 		<= ADDR;			-- ADDR has direct path to DA, which reduce delay time
		DMAS 	<= OP(2 downto 1); 	-- 00: Byte, 01: Half, 10: Word
		DNRW 	<= OP(0);			-- 0: Read, 1: Write
		DMORE 	<= '0';
		DSEQ 	<= '0';
		DDOUT	<= cur_ddout; 		-- DEBUG_030728b: DMEM multiple write access error!

		-- DNMREQ Control
		if(FLUSH='1') then
			-- DEBUG_030722d: DMEM signal is not output of X2 FF
			-- So We must clear control signal if X2 flush is asserted!
			DNMREQ	<= '1';
		elsif(STALL='1') then
			-- DEBUG_030728b: DMEM multiple write access error!
			-- If toyarm is stall state, no memory request is asserted!
			DNMREQ	<= '1'; 		
		else
			DNMREQ 	<= not EN;		-- 0: request 
		end if;
	end process;

end BEHAVIORAL;

configuration CFG_DMEM_CTRL of DMEM_CTRL is
   for BEHAVIORAL

   end for;

end CFG_DMEM_CTRL;
