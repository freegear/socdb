-- VHDL Model Created from SGE Symbol pio01.sym -- Sep 15 12:34:12 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity PIO_TA01 is
      Port (     CLK : In    std_logic;
                  DA : In    std_logic_vector (31 downto 0);
               DDOUT : In    std_logic_vector (31 downto 0);
              DNMREQ : In    std_logic;
                DNRW : In    std_logic;
               RESET : In    std_logic;
                DDIN : Out   std_logic_vector (31 downto 0);
                NFIQ : Out   std_logic;
                NIRQ : Out   std_logic );
end PIO_TA01;

architecture BEHAVIORAL of PIO_TA01 is

	signal cur_fiq_enable,next_fiq_enable: std_logic_vector(31 downto 0);
	signal cur_irq_enable,next_irq_enable: std_logic_vector(31 downto 0);
	signal cur_int_status,next_int_status: std_logic_vector(31 downto 0);
	signal cur_int_clear,next_int_clear: std_logic_vector(31 downto 0);

	signal cur_ctrl0,next_ctrl0: std_logic_vector(31 downto 0);
	signal cur_set_count0,next_set_count0: std_logic_vector(31 downto 0);
	signal cur_run_count0,next_run_count0: std_logic_vector(31 downto 0);
	signal cur_int0,next_int0: std_logic;

	signal cur_ctrl1,next_ctrl1: std_logic_vector(31 downto 0);
	signal cur_set_count1,next_set_count1: std_logic_vector(31 downto 0);
	signal cur_run_count1,next_run_count1: std_logic_vector(31 downto 0);
	signal cur_int1,next_int1: std_logic;

	signal cur_ctrl2,next_ctrl2: std_logic_vector(31 downto 0);
	signal cur_set_count2,next_set_count2: std_logic_vector(31 downto 0);
	signal cur_run_count2,next_run_count2: std_logic_vector(31 downto 0);
	signal cur_int2,next_int2: std_logic;

	signal cur_ctrl3,next_ctrl3: std_logic_vector(31 downto 0);
	signal cur_set_count3,next_set_count3: std_logic_vector(31 downto 0);
	signal cur_run_count3,next_run_count3: std_logic_vector(31 downto 0);
	signal cur_int3,next_int3: std_logic;

	signal cur_ctrl4,next_ctrl4: std_logic_vector(31 downto 0);
	signal cur_set_count4,next_set_count4: std_logic_vector(31 downto 0);
	signal cur_run_count4,next_run_count4: std_logic_vector(31 downto 0);
	signal cur_int4,next_int4: std_logic;

	signal cur_ctrl5,next_ctrl5: std_logic_vector(31 downto 0);
	signal cur_set_count5,next_set_count5: std_logic_vector(31 downto 0);
	signal cur_run_count5,next_run_count5: std_logic_vector(31 downto 0);
	signal cur_int5,next_int5: std_logic;

	signal cur_ctrl6,next_ctrl6: std_logic_vector(31 downto 0);
	signal cur_set_count6,next_set_count6: std_logic_vector(31 downto 0);
	signal cur_run_count6,next_run_count6: std_logic_vector(31 downto 0);
	signal cur_int6,next_int6: std_logic;

	signal cur_ctrl7,next_ctrl7: std_logic_vector(31 downto 0);
	signal cur_set_count7,next_set_count7: std_logic_vector(31 downto 0);
	signal cur_run_count7,next_run_count7: std_logic_vector(31 downto 0);
	signal cur_int7,next_int7: std_logic;

	signal cur_write,next_write: std_logic;
	signal cur_read,next_read: std_logic;
	signal cur_DA,next_DA: std_logic_vector(31 downto 0);
	signal cur_DDOUT,next_DDOUT: std_logic_vector(31 downto 0);
	signal cur_DDIN,next_DDIN: std_logic_vector(31 downto 0);

	signal cur_nfiq,next_nfiq: std_logic;
	signal cur_nirq,next_nirq: std_logic;

	constant ZERO32: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";

   begin

	FF: process(CLK,RESET,
				next_DDOUT,next_DDIN,
				next_DA,
				next_fiq_enable, next_irq_enable, next_int_status, next_int_clear,
				next_nirq, next_nfiq, next_read, next_write,
				next_ctrl0,next_set_count0,next_run_count0,next_int0,
				next_ctrl1,next_set_count1,next_run_count1,next_int1,
				next_ctrl2,next_set_count2,next_run_count2,next_int2,
				next_ctrl3,next_set_count3,next_run_count3,next_int3,
				next_ctrl4,next_set_count4,next_run_count4,next_int4,
				next_ctrl5,next_set_count5,next_run_count5,next_int5,
				next_ctrl6,next_set_count6,next_run_count6,next_int6,
				next_ctrl7,next_set_count7,next_run_count7,next_int7)
	begin
		if(CLK'event and CLK='1') then
			if(RESET='1') then
				-- Interrupt Control
				cur_fiq_enable <= (others=>'0');
				cur_irq_enable <= (others=>'0');
				cur_int_status <= (others=>'0');
				cur_int_clear  <= (others=>'0');

				-- Timer0 Control
				cur_ctrl0 		<= (others=>'0');
				cur_set_count0 	<= (others=>'0');
				cur_run_count0 	<= (others=>'0');
				cur_int0		<= '0';

				-- Timer1 Control
				cur_ctrl1 		<= (others=>'0');
				cur_set_count1 	<= (others=>'0');
				cur_run_count1 	<= (others=>'0');
				cur_int1		<= '0';

				-- Timer2 Control
				cur_ctrl2 		<= (others=>'0');
				cur_set_count2 	<= (others=>'0');
				cur_run_count2 	<= (others=>'0');
				cur_int2		<= '0';

				-- Timer3 Control
				cur_ctrl3 		<= (others=>'0');
				cur_set_count3 	<= (others=>'0');
				cur_run_count3 	<= (others=>'0');
				cur_int3		<= '0';

				-- Timer4 Control
				cur_ctrl4 		<= (others=>'0');
				cur_set_count4 	<= (others=>'0');
				cur_run_count4 	<= (others=>'0');
				cur_int4		<= '0';

				-- Timer5 Control
				cur_ctrl5 		<= (others=>'0');
				cur_set_count5 	<= (others=>'0');
				cur_run_count5 	<= (others=>'0');
				cur_int5		<= '0';

				-- Timer6 Control
				cur_ctrl6 		<= (others=>'0');
				cur_set_count6 	<= (others=>'0');
				cur_run_count6 	<= (others=>'0');
				cur_int6		<= '0';

				-- Timer7 Control
				cur_ctrl7 		<= (others=>'0');
				cur_set_count7 	<= (others=>'0');
				cur_run_count7 	<= (others=>'0');
				cur_int7		<= '0';

				-- Interrupt Signal
				cur_write <= '0';
				cur_read <= '0';
				cur_DA <= (others=>'0');
				cur_DDOUT <= (others=>'0');
				cur_DDIN <= (others=>'0');
				cur_nirq <= '1';
				cur_nfiq <= '1';
			else
				-- Interrupt Control
				cur_fiq_enable <= next_fiq_enable;
				cur_irq_enable <= next_irq_enable;
				cur_int_status <= next_int_status;
				cur_int_clear  <= next_int_clear;

				-- Timer0 Control
				cur_ctrl0 		<= next_ctrl0;
				cur_set_count0 	<= next_set_count0;
				cur_run_count0 	<= next_run_count0;
				cur_int0		<= next_int0;

				-- Timer1 Control
				cur_ctrl1 		<= next_ctrl1;
				cur_set_count1 	<= next_set_count1;
				cur_run_count1 	<= next_run_count1;
				cur_int1		<= next_int1;

				-- Timer2 Control
				cur_ctrl2 		<= next_ctrl2;
				cur_set_count2 	<= next_set_count2;
				cur_run_count2 	<= next_run_count2;
				cur_int2		<= next_int2;

				-- Timer3 Control
				cur_ctrl3 		<= next_ctrl3;
				cur_set_count3 	<= next_set_count3;
				cur_run_count3 	<= next_run_count3;
				cur_int3		<= next_int3;

				-- Timer4 Control
				cur_ctrl4 		<= next_ctrl4;
				cur_set_count4 	<= next_set_count4;
				cur_run_count4 	<= next_run_count4;
				cur_int4		<= next_int4;

				-- Timer5 Control
				cur_ctrl5 		<= next_ctrl5;
				cur_set_count5 	<= next_set_count5;
				cur_run_count5 	<= next_run_count5;
				cur_int5		<= next_int5;

				-- Timer6 Control
				cur_ctrl6 		<= next_ctrl6;
				cur_set_count6 	<= next_set_count6;
				cur_run_count6 	<= next_run_count6;
				cur_int6		<= next_int6;

				-- Timer7 Control
				cur_ctrl7 		<= next_ctrl7;
				cur_set_count7 	<= next_set_count7;
				cur_run_count7 	<= next_run_count7;
				cur_int7		<= next_int7;


				-- Interrupt Signal
				cur_write <= next_write;
				cur_read <= next_read;
				cur_DA <= next_DA;
				cur_DDOUT <= next_DDOUT;
				cur_DDIN <= next_DDIN;

				-- Output
				cur_nfiq <= next_nfiq;
				cur_nirq <= next_nirq;
			end if;
		end if;
	end process;

	MAIN: process(DA,DDOUT,DNMREQ,DNRW,
				cur_DA,cur_DDOUT,cur_DDIN,
				cur_fiq_enable, cur_irq_enable, cur_int_status, cur_int_clear,
				next_fiq_enable, next_irq_enable, next_int_status, next_int_clear,
				cur_nirq, cur_nfiq, cur_read, cur_write,
				cur_ctrl0,cur_set_count0,cur_run_count0,cur_int0,
				cur_ctrl1,cur_set_count1,cur_run_count1,cur_int1,
				cur_ctrl2,cur_set_count2,cur_run_count2,cur_int2,
				cur_ctrl3,cur_set_count3,cur_run_count3,cur_int3,
				cur_ctrl4,cur_set_count4,cur_run_count4,cur_int4,
				cur_ctrl5,cur_set_count5,cur_run_count5,cur_int5,
				cur_ctrl6,cur_set_count6,cur_run_count6,cur_int6,
				cur_ctrl7,cur_set_count7,cur_run_count7,cur_int7
				)
	begin

		-- Default Signals
		next_fiq_enable <= cur_fiq_enable;
		next_irq_enable <= cur_irq_enable;
		next_int_status <= cur_int_status;
		next_int_clear  <= cur_int_clear;
		
		next_ctrl0 		<= cur_ctrl0;
		next_set_count0 <= cur_set_count0;
		next_run_count0 <= cur_run_count0;
		next_int0		<= cur_int0;

		next_ctrl1 		<= cur_ctrl1;
		next_set_count1 <= cur_set_count1;
		next_run_count1 <= cur_run_count1;
		next_int1		<= cur_int1;

		next_ctrl2 		<= cur_ctrl2;
		next_set_count2 <= cur_set_count2;
		next_run_count2 <= cur_run_count2;
		next_int2		<= cur_int2;

		next_ctrl3 		<= cur_ctrl3;
		next_set_count3 <= cur_set_count3;
		next_run_count3 <= cur_run_count3;
		next_int3		<= cur_int3;

		next_ctrl4 		<= cur_ctrl4;
		next_set_count4 <= cur_set_count4;
		next_run_count4 <= cur_run_count4;
		next_int4		<= cur_int4;

		next_ctrl5 		<= cur_ctrl5;
		next_set_count5 <= cur_set_count5;
		next_run_count5 <= cur_run_count5;
		next_int5		<= cur_int5;

		next_ctrl6 		<= cur_ctrl6;
		next_set_count6 <= cur_set_count6;
		next_run_count6 <= cur_run_count6;
		next_int6		<= cur_int6;

		next_ctrl7 		<= cur_ctrl7;
		next_set_count7 <= cur_set_count7;
		next_run_count7 <= cur_run_count7;
		next_int7		<= cur_int7;

		next_write <= cur_write;
		next_read <= cur_read;

		next_DA <= cur_DA;
		next_DDOUT <= cur_DDOUT;
		next_DDIN  <= cur_DDIN;

		next_DA <= DA;

		next_nfiq <= cur_nfiq;
		next_nirq <= cur_nirq;

		-- Output Signals
		NIRQ <= cur_nirq;
		NFIQ <= cur_nfiq;
		DDIN <= cur_DDIN;

		if(DNMREQ='0' and DNRW='1') then
				next_write <= '1';
		elsif(DNMREQ='0' and DNRW='0') then
				next_read <= '1';
		else
				next_write <= '0';
		end if;

		-- Write Register
		if(cur_write='1') then
			-- BASE : 0x00
			if(cur_DA(15 downto 0)="0000000000000000") then	 -- 0x00000
				next_fiq_enable <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000000000100") then	 -- 0x00000
				next_irq_enable <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000000001000") then	 -- 0x00000
				next_int_status <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000000001100") then	 -- 0x00000
				next_int_status <= (cur_int_status and (not DDOUT));

			-- Timer0: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x20
			elsif(cur_DA(15 downto 0)="0000000000100000") then	 -- 0x10000
				next_ctrl0 <= DDOUT;
				next_run_count0 <= cur_set_count0;
			elsif(cur_DA(15 downto 0)="0000000000100100") then	 -- 0x10004
				next_set_count0 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000000101000") then	 -- 0x10008
				next_run_count0 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000000101100") then	 -- 0x1000c
				next_int0 <= '0';
			-- Timer1: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x40
			elsif(cur_DA(15 downto 0)="0000000001000000") then	 -- 0x10000
				next_ctrl1 <= DDOUT;
				next_run_count1 <= cur_set_count1;
			elsif(cur_DA(15 downto 0)="0000000001000100") then	 -- 0x10004
				next_set_count1 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000001001000") then	 -- 0x10008
				next_run_count1 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000001001100") then	 -- 0x1000c
				next_int1 <= '0';
			-- Timer2: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x60
			elsif(cur_DA(15 downto 0)="0000000001100000") then	 -- 0x10000
				next_ctrl2 <= DDOUT;
				next_run_count2 <= cur_set_count2;
			elsif(cur_DA(15 downto 0)="0000000001100100") then	 -- 0x10004
				next_set_count2 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000001101000") then	 -- 0x10008
				next_run_count2 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000001101100") then	 -- 0x1000c
				next_int2 <= '0';
			-- Timer1: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x80
			elsif(cur_DA(15 downto 0)="0000000010000000") then	 -- 0x10000
				next_ctrl3 <= DDOUT;
				next_run_count3 <= cur_set_count3;
			elsif(cur_DA(15 downto 0)="0000000010000100") then	 -- 0x10004
				next_set_count3 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000010001000") then	 -- 0x10008
				next_run_count3 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000010001100") then	 -- 0x1000c
				next_int3 <= '0';

			-- Timer0: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x20
			elsif(cur_DA(15 downto 0)="0000000010100000") then	 -- 0x10000
				next_ctrl4 <= DDOUT;
				next_run_count4 <= cur_set_count4;
			elsif(cur_DA(15 downto 0)="0000000010100100") then	 -- 0x10004
				next_set_count4 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000010101000") then	 -- 0x10008
				next_run_count4 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000010101100") then	 -- 0x1000c
				next_int4 <= '0';
			-- Timer1: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x40
			elsif(cur_DA(15 downto 0)="0000000011000000") then	 -- 0x10000
				next_ctrl5 <= DDOUT;
				next_run_count5 <= cur_set_count5;
			elsif(cur_DA(15 downto 0)="0000000011000100") then	 -- 0x10004
				next_set_count5 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000011001000") then	 -- 0x10008
				next_run_count5 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000011001100") then	 -- 0x1000c
				next_int5 <= '0';
			-- Timer2: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x60
			elsif(cur_DA(15 downto 0)="0000000011100000") then	 -- 0x10000
				next_ctrl6 <= DDOUT;
				next_run_count6 <= cur_set_count6;
			elsif(cur_DA(15 downto 0)="0000000011100100") then	 -- 0x10004
				next_set_count6 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000011101000") then	 -- 0x10008
				next_run_count6 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000011101100") then	 -- 0x1000c
				next_int6 <= '0';
			-- Timer1: ctrl(0): RUN, ctrl(1): IRQ EN
			-- BASE : 0x80
			elsif(cur_DA(15 downto 0)="0000000100000000") then	 -- 0x10000
				next_ctrl7 <= DDOUT;
				next_run_count7 <= cur_set_count7;
			elsif(cur_DA(15 downto 0)="0000000100000100") then	 -- 0x10004
				next_set_count7 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000100001000") then	 -- 0x10008
				next_run_count7 <= DDOUT;
			elsif(cur_DA(15 downto 0)="0000000100001100") then	 -- 0x1000c
				next_int7 <= '0';
			end if;
		elsif(cur_read='1') then
			if(cur_DA(15 downto 0)="0000000000000000") then	 -- 0x00000
				DDIN <= next_fiq_enable;
				next_DDIN <= next_fiq_enable;
			elsif(cur_DA(15 downto 0)="0000000000000100") then	 -- 0x00000
				DDIN <= next_irq_enable;
				next_DDIN <= next_irq_enable;
			elsif(cur_DA(15 downto 0)="0000000000001000") then	 -- 0x00000
				DDIN <= next_int_status;
				next_DDIN <= next_int_status;
			end if;
		end if;

		-- INTERRUPT SIGNAL
--		next_int_status <= (next_int_status or ("0000000000000000000000000000" & cur_int3 & cur_int2 & cur_int1 & cur_int0));
		next_int_status <= cur_int_status(31 downto 8) & cur_int7 & cur_int6 & cur_int5 & cur_int4 & cur_int3 & cur_int2 & cur_int1 & cur_int0;

		if( (cur_int_status and cur_fiq_enable) /= ZERO32 ) then
			next_nfiq <= '0';
		else
			next_nfiq <= '1';
		end if;

		if( (cur_int_status and cur_irq_enable) /= ZERO32 ) then
			next_nirq <= '0';
		else
			next_nirq <= '1';
		end if;


		-- Timer0
		if(cur_ctrl0(0)='1') then -- ctrl(0): RUN
			if(cur_run_count0 = "00000000000000000000000000000000" ) then
				next_run_count0 <= cur_set_count0;
			else
				next_run_count0 <= unsigned(cur_run_count0) - '1';
			end if;
		end if;

		if(cur_run_count0 = "00000000000000000000000000000000" and cur_ctrl0(1)='1' ) then
			next_int0 <= '1'; -- ctrl(1): Interrupt
		end if;

		-- Timer1
		if(cur_ctrl1(0)='1') then -- ctrl(0): RUN
			if(cur_run_count1 = "00000000000000000000000000000000" ) then
				next_run_count1 <= cur_set_count1;
			else
				next_run_count1 <= unsigned(cur_run_count1) - '1';
			end if;
		end if;

		if(cur_run_count1 = "00000000000000000000000000000000" and cur_ctrl1(1)='1' ) then
			next_int1 <= '1'; -- ctrl(1): Interrupt
		end if;

		-- Timer2
		if(cur_ctrl2(0)='1') then -- ctrl(0): RUN
			if(cur_run_count2 = "00000000000000000000000000000000" ) then
				next_run_count2 <= cur_set_count2;
			else
				next_run_count2 <= unsigned(cur_run_count2) - '1';
			end if;
		end if;

		if(cur_run_count2 = "00000000000000000000000000000000" and cur_ctrl2(1)='1' ) then
			next_int2 <= '1'; -- ctrl(1): Interrupt
		end if;

		-- Timer3
		if(cur_ctrl3(0)='1') then -- ctrl(0): RUN
			if(cur_run_count3 = "00000000000000000000000000000000" ) then
				next_run_count3 <= cur_set_count3;
			else
				next_run_count3 <= unsigned(cur_run_count3) - '1';
			end if;
		end if;

		if(cur_run_count3 = "00000000000000000000000000000000" and cur_ctrl3(1)='1' ) then
			next_int3 <= '1'; -- ctrl(1): Interrupt
		end if;



		-- Timer0
		if(cur_ctrl4(0)='1') then -- ctrl(0): RUN
			if(cur_run_count4 = "00000000000000000000000000000000" ) then
				next_run_count4 <= cur_set_count4;
			else
				next_run_count4 <= unsigned(cur_run_count4) - '1';
			end if;
		end if;

		if(cur_run_count4 = "00000000000000000000000000000000" and cur_ctrl4(1)='1' ) then
			next_int4 <= '1'; -- ctrl(1): Interrupt
		end if;

		-- Timer1
		if(cur_ctrl5(0)='1') then -- ctrl(0): RUN
			if(cur_run_count5 = "00000000000000000000000000000000" ) then
				next_run_count5 <= cur_set_count5;
			else
				next_run_count5 <= unsigned(cur_run_count5) - '1';
			end if;
		end if;

		if(cur_run_count5 = "00000000000000000000000000000000" and cur_ctrl5(1)='1' ) then
			next_int5 <= '1'; -- ctrl(1): Interrupt
		end if;

		-- Timer2
		if(cur_ctrl6(0)='1') then -- ctrl(0): RUN
			if(cur_run_count6 = "00000000000000000000000000000000" ) then
				next_run_count6 <= cur_set_count6;
			else
				next_run_count6 <= unsigned(cur_run_count6) - '1';
			end if;
		end if;

		if(cur_run_count6 = "00000000000000000000000000000000" and cur_ctrl6(1)='1' ) then
			next_int6 <= '1'; -- ctrl(1): Interrupt
		end if;

		-- Timer3
		if(cur_ctrl7(0)='1') then -- ctrl(0): RUN
			if(cur_run_count7 = "00000000000000000000000000000000" ) then
				next_run_count7 <= cur_set_count7;
			else
				next_run_count7 <= unsigned(cur_run_count7) - '1';
			end if;
		end if;

		if(cur_run_count7 = "00000000000000000000000000000000" and cur_ctrl7(1)='1' ) then
			next_int7 <= '1'; -- ctrl(1): Interrupt
		end if;
	end process;


end BEHAVIORAL;

configuration CFG_PIO_TA01 of PIO_TA01 is
   for BEHAVIORAL

   end for;

end CFG_PIO_TA01;
