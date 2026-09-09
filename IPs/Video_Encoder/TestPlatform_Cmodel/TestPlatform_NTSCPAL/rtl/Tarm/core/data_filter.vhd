-- VHDL Model Created from SGE Symbol data_filter.sym -- Jul 30 12:34:49 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity DATA_FILTER is
      Port ( ABORT_IN : In    std_logic;
                 CLK : In    std_logic;
             DATA_IN : In    std_logic_vector (31 downto 0);
               FLUSH : In    std_logic;
                NREQ : In    std_logic;
                 NRW : In    std_logic;
               NWAIT : In    std_logic;
               STALL : In    std_logic;
             ABORT_OUT : Out   std_logic;
             DATA_OUT : Out   std_logic_vector (31 downto 0) );
end DATA_FILTER;

architecture BEHAVIORAL of DATA_FILTER is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.07.30.
	--------------------------------

	-- This unit aids pipeline to capture correct data.
	-- If nwait is '1' and wanted data is coming but pipeline is stalled , this unit capture the data.
	type state_type is (S_CAPTURE, S_RELEASE);
	signal cur_state,next_state: state_type;
	signal cur_data,next_data: std_logic_vector(31 downto 0);
	signal cur_abort,next_abort: std_logic;

   begin

	FF:process(CLK)
	begin
	if(CLK'event and CLK='1') then
		if(FLUSH='1') then
			cur_state <= S_CAPTURE;
			cur_data  <= (others=>'0');
			cur_abort  <= '0';
		else
			cur_state <= next_state;
			cur_data  <= next_data;
			cur_abort  <= next_abort;
		end if;
	end if;
	end process;

	CTRL:process(cur_state,cur_data,cur_abort,DATA_IN,NWAIT,STALL,ABORT_IN)
	begin

		-- default value
		DATA_OUT <= DATA_IN;
		ABORT_OUT <= ABORT_IN;

		next_state <= cur_state;
		next_data <= cur_data;
		next_abort <= cur_abort;

		case cur_state is
		when S_CAPTURE =>
			-- 1. Always capture input data
			next_data 	<=  DATA_IN;
			next_abort 	<=  ABORT_IN;
			-- 2. Wanted data is coming but pipeline is stalled, 
			--    then this unit must save this data.
			if(NWAIT='1' and STALL='1') then 
				next_state <= S_RELEASE; -- Important part
			end if;

		when S_RELEASE =>
			-- 3. The correct data must be delivered to pipeline 
			--    until pipeline is running again.
			DATA_OUT 	<= cur_data; -- Saved data
			ABORT_OUT 	<= cur_abort; -- Saved abort
			if(STALL='0') then
				next_state <= S_CAPTURE;
			end if;
		when others =>
            DATA_OUT <= DATA_IN;
            ABORT_OUT <= ABORT_IN;
            next_state <= cur_state;
            next_data <= cur_data;
            next_abort <= cur_abort;
		end case;
	end process;

end BEHAVIORAL;

configuration CFG_DATA_FILTER of DATA_FILTER is
   for BEHAVIORAL

   end for;

end CFG_DATA_FILTER;
