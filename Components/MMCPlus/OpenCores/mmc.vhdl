----------------------------------------------------------------------------------
--
-- OpenCores: mmc-1.0
-- High-level MultiMediaCard compliant controller core
-- (c) 2003 Stanislaw Skowronek / LARK
-- obtained from OpenCores (http://www.opencores.org/projects/mmc/)
--
-- LICENSE:
--   You may use the core in any product, commercial or not. There is no requirement to
--   release the source for this product. However, there are two requirements that are
--   enforced in order to ensure interoperability: if you use an unmodified core, then
--   information on the core used should be publicly and easily available (e.g. on product
--   Web page: "This product uses a mmc-1.0 core by LARK."). If you modify the core, you
--   are required to place full programming specifications in a publicly and easily
--   reachable place. Again, these requirements are introduced ONLY to achieve
--   interoperability with Open Source software. We developers can't sign NDAs - if the
--   driver would be under NDA it could not be Open Source.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package mmc_controller is
	component mmc is
		port(
			data_bus: inout std_logic_vector(31 downto 0);
			addr_bus: in std_logic_vector(8 downto 0);
			output_enable_n: in std_logic;
			write_enable_n: in std_logic;
			chip_select_n: in std_logic;
			acknowledge_n: out std_logic;
			interrupt_n: out std_logic;
			clock: in std_logic;
			dat0: inout std_logic;
			dat1: inout std_logic;
			dat2: inout std_logic;
			dat3: inout std_logic;
			cmd: inout std_logic;
			clk: out std_logic;
			card_detect: in std_logic;
			write_protect: in std_logic;
			card_power: out std_logic
		);
	end component;
	component mmc_clock is
		port(
			load_pre: in std_logic_vector(2 downto 0);
			load_div: in std_logic_vector(4 downto 0);
			load: in std_logic;
			clk_in: in std_logic;
			clk_out: out std_logic
		);
	end component;
	component mmc_crc_7 is
		port(
			data: in std_logic;
			clear: in std_logic;
			clk: in std_logic;
			crc: out std_logic_vector(6 downto 0)
		);
	end component;
	component mmc_crc_16 is
		port(
			data: in std_logic;
			clear: in std_logic;
			clk: in std_logic;
			crc: out std_logic_vector(15 downto 0)
		);
	end component;
	component mmc_cmd_tx is
		port(
			ram_addr: out std_logic_vector(4 downto 0);
			ram_data: in std_logic_vector(7 downto 0);
			start_len: in std_logic_vector(7 downto 0);
			start_crc: in std_logic_vector(7 downto 0);
			start_off: in std_logic_vector(7 downto 0);
			start: in std_logic;
			left_bits: out std_logic_vector(7 downto 0);
			last_crc: out std_logic_vector(6 downto 0);
			clk: in std_logic;
			tx: out std_logic;
			tx_enable: out std_logic
		);
	end component;
	component mmc_cmd_rx is
		port(
			ram_addr: out std_logic_vector(4 downto 0);
			ram_data: out std_logic_vector(7 downto 0);
			ram_write: out std_logic;
			load_len: in std_logic_vector(7 downto 0);
			load_crc: in std_logic_vector(7 downto 0);
			load_off: in std_logic_vector(7 downto 0);
			load: in std_logic;
			start: in std_logic;
			left_bits: out std_logic_vector(7 downto 0);
			last_crc: out std_logic_vector(6 downto 0);
			clk: in std_logic;
			rx: in std_logic
		);
	end component;
	component mmc_dat_tx is
		port(
			ram_addr: out std_logic_vector(6 downto 0);
			ram_data: in std_logic_vector(31 downto 0);
			start_len: in std_logic_vector(7 downto 0);
			start_wide: in std_logic;
			start_crc: in std_logic;
			start: in std_logic;
			left_len: out std_logic_vector(7 downto 0);
			clk: in std_logic;
			tx0: out std_logic;
			tx1: out std_logic;
			tx2: out std_logic;
			tx3: out std_logic;
			tx_enable_0: out std_logic;
			tx_enable_123: out std_logic
		);
	end component;
	component mmc_dat_rx is
		port(
			ram_addr: out std_logic_vector(6 downto 0);
			ram_data: out std_logic_vector(31 downto 0);
			ram_write: out std_logic;
			load_len: in std_logic_vector(7 downto 0);
			load_wide: in std_logic;
			load: in std_logic;
			start: in std_logic;
			done: out std_logic;
			left_len: out std_logic_vector(7 downto 0);
			crc_status: out std_logic;
			clk: in std_logic;
			rx0: in std_logic;
			rx1: in std_logic;
			rx2: in std_logic;
			rx3: in std_logic
		);
	end component;
	component mmc_stat_rx is
		port(
			start: in std_logic;
			status: out std_logic_vector(4 downto 0);
			clk: in std_logic;
			rx0: in std_logic
		);
	end component;
end mmc_controller;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.mmc_ram.all;
use work.mmc_controller.all;

entity mmc is
	port(
--# System port
		data_bus: inout std_logic_vector(31 downto 0);
		addr_bus: in std_logic_vector(8 downto 0);
		output_enable_n: in std_logic;
		write_enable_n: in std_logic;
		chip_select_n: in std_logic;
		acknowledge_n: out std_logic;
		interrupt_n: out std_logic;
		clock: in std_logic;
--# Card side port
		dat0: inout std_logic;
		dat1: inout std_logic;
		dat2: inout std_logic;
		dat3: inout std_logic;
		cmd: inout std_logic;
		clk: out std_logic;
		card_detect: in std_logic;
		write_protect: in std_logic;
		card_power: out std_logic
	);
end mmc;

architecture standard of mmc is
signal clk_int, wr, rd, wr_1, load, wr_clk, wr_half: std_logic;
signal ack, ack_m, ck_load, ck_really_load: std_logic;
signal wr_h, wr_1_h, wr_half_h, ack_h: std_logic;
signal data_out, ck_out: std_logic_vector(31 downto 0);
signal int_buf: std_logic;
---------------------- INTR -----------------------
signal isr, imr, intr, isr_buf: std_logic_vector(7 downto 0);
signal card_detect_1, cmd_txe_1h, dat_txe_1h: std_logic;
signal cmd_rx_left, cmd_rx_left_1: std_logic;
signal dat_rx_done, dat_rx_done_1: std_logic;
signal stat_rx_empty, stat_rx_empty_1: std_logic;
signal dat0_1, dat1_1: std_logic;
--------------------- CMD_TX ----------------------
signal ram_ct_write: std_logic;
signal ram_ct_addr: std_logic_vector(4 downto 0);
signal ram_ct_data: std_logic_vector(7 downto 0);
signal cmd_txe, cmd_tx, ct_load, cmd_txe_1: std_logic;
signal ct_out: std_logic_vector(31 downto 0);
--------------------- CMD_RX ----------------------
signal ram_cr_write: std_logic;
signal ram_cr_addr: std_logic_vector(4 downto 0);
signal ram_cr_data: std_logic_vector(7 downto 0);
signal ram_cr_out: std_logic_vector(31 downto 0);
signal cr_load, cr_start: std_logic;
signal cr_out: std_logic_vector(31 downto 0);
--------------------- DAT_TX ----------------------
signal ram_dt_write: std_logic;
signal ram_dt_addr: std_logic_vector(6 downto 0);
signal ram_dt_data: std_logic_vector(31 downto 0);
signal dat_txe, dat_txe_h, dat_tx0, dat_tx1: std_logic;
signal dat_tx2, dat_tx3, dat_txe_1, dt_load: std_logic;
signal dt_out: std_logic_vector(31 downto 0);
--------------------- DAT_RX ----------------------
signal ram_dr_write: std_logic;
signal ram_dr_addr: std_logic_vector(6 downto 0);
signal ram_dr_data: std_logic_vector(31 downto 0);
signal ram_dr_out: std_logic_vector(31 downto 0);
signal dr_load: std_logic;
signal dr_out: std_logic_vector(31 downto 0);
--------------------- STAT_RX ---------------------
signal sr_start, sr_enable: std_logic;
begin
--------------------- CMD_TX ----------------------
	ram_ct: mmc_ram_32_8 port map (
		write_addr => addr_bus(4 downto 0),
		write_data => data_bus(7 downto 0),
		write_enable => ram_ct_write,
		write_clk => wr_clk,
		read_addr => ram_ct_addr,
		read_data => ram_ct_data);
	ct: mmc_cmd_tx port map (
		ram_addr => ram_ct_addr,
		ram_data => ram_ct_data,
		start_len => data_bus(7 downto 0),
		start_crc => data_bus(15 downto 8),
		start_off => data_bus(23 downto 16),
		start => ct_load,
		left_bits => ct_out(7 downto 0),
		last_crc => ct_out(14 downto 8),
		clk => clk_int,
		tx => cmd_tx,
		tx_enable => cmd_txe);
	ct_out(31 downto 15) <= (others => '0');
--------------------- CMD_RX ----------------------
	ram_cr: mmc_ram_32_8 port map (
		write_addr => ram_cr_addr,
		write_data => ram_cr_data,
		write_enable => ram_cr_write,
		write_clk => clk_int,
		read_addr => addr_bus(4 downto 0),
		read_data => ram_cr_out(7 downto 0));
    ram_cr_out(31 downto 8) <= (others => '0');
	cr: mmc_cmd_rx port map (
		ram_addr => ram_cr_addr,
		ram_data => ram_cr_data,
		ram_write => ram_cr_write,
		load_len => data_bus(7 downto 0),
		load_crc => data_bus(15 downto 8),
		load_off => data_bus(23 downto 16),
		load => cr_load,
		start => cr_start,
		left_bits => cr_out(7 downto 0),
		last_crc => cr_out(14 downto 8),
		clk => clk_int,
		rx => cmd);
	cr_out(31 downto 15) <= (others => '0');
--------------------- DAT_TX ----------------------
	ram_dt: mmc_ram_128_32 port map (
		write_addr => addr_bus(6 downto 0),
		write_data => data_bus,
		write_enable => ram_dt_write,
		write_clk => wr_clk,
		read_addr => ram_dt_addr,
		read_data => ram_dt_data);
	dt: mmc_dat_tx port map (
		ram_addr => ram_dt_addr,
		ram_data => ram_dt_data,
		start_len => data_bus(7 downto 0),
		start_wide => data_bus(8),
		start_crc => data_bus(9),
		start => dt_load,
		left_len => dt_out(7 downto 0),
		clk => clk_int,
		tx0 => dat_tx0,
		tx1 => dat_tx1,
		tx2 => dat_tx2,
		tx3 => dat_tx3,
		tx_enable_0 => dat_txe,
		tx_enable_123 => dat_txe_h
	);
	dt_out(31 downto 14) <= (others => '0');
--------------------- DAT_RX ----------------------
	ram_dr: mmc_ram_128_32 port map (
		write_addr => ram_dr_addr,
		write_data => ram_dr_data,
		write_enable => ram_dr_write,
		write_clk => clk_int,
		read_addr => addr_bus(6 downto 0),
		read_data => ram_dr_out);
	dr: mmc_dat_rx port map (
		ram_addr => ram_dr_addr,
		ram_data => ram_dr_data,
		ram_write => ram_dr_write,
		load_len => data_bus(7 downto 0),
		load_wide => data_bus(8),
		load => dr_load,
		start => dr_load,
		done => dat_rx_done,
		left_len => dr_out(7 downto 0),
		crc_status => dr_out(8),
		clk => clk_int,
		rx0 => dat0,
		rx1 => dat1,
		rx2 => dat2,
		rx3 => dat3
	);
	dr_out(31 downto 10) <= (others => '0');
	dr_out(9) <= dat_rx_done;
--------------------- STAT_RX ---------------------
	sr: mmc_stat_rx port map (
		start => sr_start,
		status => dt_out(12 downto 8),
		clk => clk_int,
		rx0 => dat0);
---------------------- CLOCK ----------------------
	ck: mmc_clock port map (
		load_div => data_bus(4 downto 0),
		load_pre => data_bus(7 downto 5),
		load => ck_really_load,
		clk_in => clock,
		clk_out => clk_int);
	ck_out(7 downto 0) <= (others => '0');
	ck_out(8) <= card_detect;
	ck_out(9) <= write_protect;
	ck_out(23 downto 10) <= (others => '0');
	ck_out(31 downto 24) <= isr_buf;
---------------------- INTR -----------------------
	cmd_rx_left <= '0' when cr_out(7 downto 0) = X"00" else '1';
	stat_rx_empty <= dt_out(12);
	intr(0) <= cmd_txe_1h and not cmd_txe;			-- command transmitted
	intr(1) <= cmd_rx_left_1 and not cmd_rx_left;	-- response received
	intr(2) <= dat_txe_1h and not dat_txe;			-- data block transmitted
	intr(3) <= dat_rx_done and not dat_rx_done_1;	-- data block received
	intr(4) <= stat_rx_empty_1 and not stat_rx_empty;	-- CRC status received
	intr(5) <= dat0 and not dat0_1;					-- busy state finished
	intr(6) <= dat1 and not dat1_1;					-- SDIO card interrupt
	intr(7) <= card_detect xor card_detect_1;		-- card change detect
	int_buf <= '1' when isr = X"00" else '0';
---------------------- GLUE -----------------------
	clk <= clk_int;
	rd <= (not chip_select_n) and (not output_enable_n);
	wr_half <= (not chip_select_n) and (not write_enable_n);
	wr_clk <= not wr_half;
	acknowledge_n <= '0' when (chip_select_n = '0') and (ack_m = '1') else 'Z';
	ack <= rd or (wr_1 and addr_bus(8)) or (wr_half and not addr_bus(8));
	ack_h <= rd or wr_1_h;
	ack_m <= ack_h when addr_bus = "111111111" else ack;
	data_bus <= (others => 'Z') when rd = '0' else data_out;
	load <= wr and not wr_1;
	ram_ct_write <= not chip_select_n when addr_bus(8 downto 5) = "0100" else '0';
	ram_dt_write <= not chip_select_n when addr_bus(8 downto 7) = "00" else '0';
	ct_load <= load when addr_bus = "100000000" else '0';
	cr_load <= load when addr_bus = "100000001" else '0';
	dt_load <= load when addr_bus = "100000010" else '0';
	dr_load <= load when addr_bus = "100000011" else '0';
	ck_load <= (wr_h and not wr_1_h) when addr_bus = "111111111" else '0';
	ck_really_load <= ck_load and data_bus(9);
	cr_start <= cmd_txe_1 and not cmd_txe;
	sr_start <= (dat_txe_1 and not dat_txe) and sr_enable;
	dt_out(13) <= not dat0;
	cmd <= cmd_tx when cmd_txe = '1' else 'Z';
	dat0 <= dat_tx0 when dat_txe = '1' else 'Z';
	dat1 <= dat_tx1 when dat_txe_h = '1' else 'Z';
	dat2 <= dat_tx2 when dat_txe_h = '1' else 'Z';
	dat3 <= dat_tx3 when dat_txe_h = '1' else 'Z';
    data_out <= ram_dr_out when addr_bus(8 downto 7) = "00" else
                ram_cr_out when addr_bus(8 downto 5) = "0100" else
				ct_out when addr_bus = "100000000" else
				cr_out when addr_bus = "100000001" else
				dt_out when addr_bus = "100000010" else
				dr_out when addr_bus = "100000011" else
				ck_out when addr_bus = "111111111" else
				(others => '0');
	hstep: process(clock)
	begin
		if rising_edge(clock) then
			wr_1_h <= wr_h;
			dat0_1 <= dat0;
			dat1_1 <= dat1;
			card_detect_1 <= card_detect;
			stat_rx_empty_1 <= stat_rx_empty;
			cmd_txe_1h <= cmd_txe;
			dat_txe_1h <= dat_txe;
			cmd_rx_left_1 <= cmd_rx_left;
			dat_rx_done_1 <= dat_rx_done;
			if ck_load = '1' then
				card_power <= data_bus(8);
				imr <= data_bus(31 downto 24);
				isr_buf <= isr;
				isr <= intr and imr;
			else
				isr <= isr or (intr and imr);
			end if;
		end if;
		if falling_edge(clock) then
			wr_h <= wr_half and addr_bus(8);
			if int_buf = '1' then
				interrupt_n <= 'Z';
			else
				interrupt_n <= '0';
			end if;
		end if;
	end process;
	step: process(clk_int)
	begin
		if rising_edge(clk_int) then
			wr_1 <= wr;
			if dt_load = '1' then
				sr_enable <= data_bus(10);
			end if;
		end if;
		if falling_edge(clk_int) then
			cmd_txe_1 <= cmd_txe;
			dat_txe_1 <= dat_txe;
			wr <= wr_half and addr_bus(8);
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mmc_clock is
--| Entity <mmc_clock> is a programmable clock divider with prescaler.
	port(
		load_pre: in std_logic_vector(2 downto 0);
--@ prescaler value (scale = 2^(-<load_pre>))
		load_div: in std_logic_vector(4 downto 0);
--@ divider value (scale = 1/<load_div>); if zero then clock stopped
		load: in std_logic;
--@ load values
		clk_in: in std_logic;
--@ clock input; also user for loading values
		clk_out: out std_logic
--@ clock output
	);
end mmc_clock;

architecture standard of mmc_clock is
signal pre_ctr: std_logic_vector(6 downto 0);
signal pre_clk, div_clk: std_logic;
signal pre: std_logic_vector(2 downto 0);
signal div_h, div_l, tmp_h_1, tmp_h_2: std_logic_vector(4 downto 0);
signal div_h_zero, div_l_zero, div_h_div, div_l_div: std_logic;
signal div: std_logic_vector(4 downto 0);
begin
	pre_clk <= clk_in when pre = "000" else
			   pre_ctr(0) when pre = "001" else
			   pre_ctr(1) when pre = "010" else
			   pre_ctr(2) when pre = "011" else
			   pre_ctr(3) when pre = "100" else
			   pre_ctr(4) when pre = "101" else
			   pre_ctr(5) when pre = "110" else
			   pre_ctr(6) when pre = "111";
	div_h_zero <= '1' when div_h = "00000" else '0';
	div_l_zero <= '1' when div_l = "00000" else '0';
	div_h_div <= '1' when div_h = div else '0';
	div_l_div <= '1' when div_l = div else '0';
	tmp_h_1(3 downto 0) <= load_div(4 downto 1);
	tmp_h_1(4) <= '0';
	tmp_h_2(0) <= load_div(0);
	tmp_h_2(4 downto 1) <= (others => '0');
	clk_out <= '0' when (div_h_zero = '1') and (div_l_zero = '1') else
			   pre_clk when (div_l_zero = '1') and (div_h_zero = '0') else
			   div_clk;
	step: process(clk_in)
	begin
		if rising_edge(clk_in) then
			pre_ctr <= pre_ctr + 1;
			if load = '1' then
				div_h <= tmp_h_1 + tmp_h_2;
				div_l(3 downto 0) <= load_div(4 downto 1);
				div_l(4) <= '0';
				pre <= load_pre;
				div <= "00001";
			else
				if ((div_h_div and div_clk) or (div_l_div and not div_clk)) = '1' then
					div <= "00001";
					div_clk <= not div_clk;
				else
					div <= div + 1;
				end if;
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mmc_crc_7 is
--| Entity <mmc_crc_7> calculates a running CRC-7 of a data stream.
	port(
		data: in std_logic;
--@ serial data input (MSB first of course)
		clear: in std_logic;
--@ clear whole CRC register
		clk: in std_logic;
--@ clock signal (rising edge active)
		crc: out std_logic_vector(6 downto 0)
--@ calculated running CRC-7 (valid only after seven zeroes on <data>)
	);
end mmc_crc_7;

architecture standard of mmc_crc_7 is
signal crc_reg: std_logic_vector(6 downto 0);
begin
	crc <= crc_reg;
	step: process(clk)
	begin
		if rising_edge(clk) then
			if clear = '1' then
				crc_reg <= "0000000";
			else
				crc_reg(0) <= data xor crc_reg(6);
				crc_reg(1) <= crc_reg(0);
				crc_reg(2) <= crc_reg(1);
				crc_reg(3) <= crc_reg(2) xor crc_reg(6);
				crc_reg(4) <= crc_reg(3);
				crc_reg(5) <= crc_reg(4);
				crc_reg(6) <= crc_reg(5);
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.mmc_controller.all;

entity mmc_cmd_tx is
--| Entity <mmc_cmd_tx> is used to represent a command transmitter.
--| It is a highly programmable one, it can insert a CRC-7 string
--| into a datastream at any position or not insert one at all. The
--| datastream itself is read from external memory space and can be
--| of any length from 1 to 255 bits.
	port(
--# Buffer memory port
		ram_addr: out std_logic_vector(4 downto 0);
--@ address to external buffer memory 
		ram_data: in std_logic_vector(7 downto 0);
--@ data from external buffer memory
--# System port
		start_len: in std_logic_vector(7 downto 0);
--@ length, latched by high on <start> when <clk> rises
		start_crc: in std_logic_vector(7 downto 0);
--@ bits up to and including inserted CRC-7 string (see notes), latched
--| by high on <start> when <clk> rises
		start_off: in std_logic_vector(7 downto 0);
--@ bits before CRC-7 starts accumulating, latched by high on <start>
--| when <clk> rises
		start: in std_logic;
--@ latches <start_len>, <start_crc> and <start_off>; initializes internal
--| transmission engine
		left_bits: out std_logic_vector(7 downto 0);
--@ bits left to be transmitted out of buffer memory (0 - transmission done)
		last_crc: out std_logic_vector(6 downto 0);
--@ calculated and transmitted CRC-7 for verification by system
		clk: in std_logic;
--@ clock signal (rising edge active)
--#	Card side port
		tx: out std_logic;
--@ transmitted signal to CMD line
		tx_enable: out std_logic
--@ transmitter enable on CMD line
		);
--# CRC-7 insertion notes:
--| If you want to insert a CRC-7 into your output stream, you have
--| to prepare place for it. The place should be filled with zeroes.
--| Write the correct value into <start_crc> (47 bits for typical MMC
--| commands). If the <start_crc> value exceeds <start_len> by more
--| than 7 bits, the CRC will neither be transmitted nor calculated.
end mmc_cmd_tx;

architecture standard of mmc_cmd_tx is
signal bit_counter, crc_counter, off_counter: std_logic_vector(7 downto 0);
signal off_counter_nz, off_counter_en: std_logic;
signal crc_counter_en, crc_reg_load: std_logic;
signal bit_counter_en, bit_counter_en_1: std_logic;
signal bit_counter_clr, bit_counter_clr_1: std_logic;
signal bit_counter_nz, bit_counter_nz_1: std_logic;
signal crc_counter_nz, crc_counter_nz_1: std_logic;
signal ram_counter: std_logic_vector(4 downto 0);
signal shift_counter: std_logic_vector(2 downto 0);
signal ram_counter_en, ser_load_en: std_logic;
signal ser_reg: std_logic_vector(7 downto 0);
signal ser_reg_out, ser_reg_out_1: std_logic;
signal txe_shift: std_logic_vector(7 downto 0);
signal crc_out, crc_shift: std_logic_vector(6 downto 0);
signal tx_enable_half, tx_half: std_logic;
signal crc_clear: std_logic;
begin
	crc7: mmc_crc_7 port map(data => ser_reg_out, clk => clk,
	                         clear => crc_clear, crc => crc_out);
    left_bits <= bit_counter;
	ram_addr <= ram_counter;
	bit_counter_nz <= '0' when bit_counter = X"00" else '1';
	crc_counter_nz <= '0' when crc_counter = X"00" else '1';
	off_counter_nz <= '0' when off_counter = X"FF" else '1';
	crc_clear <= '1' when off_counter = X"00" else '0';
	bit_counter_en <= bit_counter_nz and bit_counter_nz_1;
	off_counter_en <= bit_counter_en and off_counter_nz;
	bit_counter_clr <= bit_counter_nz and not bit_counter_nz_1;
	crc_counter_en <= bit_counter_en_1 and crc_counter_nz;
	crc_reg_load <= crc_counter_nz_1 and not crc_counter_nz;
	ram_counter_en <= '1' when shift_counter = "111" else '0';
	ser_load_en <= '1' when shift_counter = "000" else '0';
	ser_reg_out <= ser_reg(7);
	tx_enable_half <= txe_shift(7);
	tx_half <= crc_shift(6) or not txe_shift(7);
	step: process(clk)
	begin
		if falling_edge(clk) then
			tx <= tx_half;
			tx_enable <= tx_enable_half;
		end if;
		if rising_edge(clk) then
			bit_counter_nz_1 <= bit_counter_nz;
			crc_counter_nz_1 <= crc_counter_nz;
			bit_counter_en_1 <= bit_counter_en;
			bit_counter_clr_1 <= bit_counter_clr;
			ser_reg_out_1 <= ser_reg_out;
			txe_shift(7 downto 1) <= txe_shift(6 downto 0);
			txe_shift(0) <= bit_counter_en_1;
			if start = '1' then
				bit_counter <= start_len;
				crc_counter <= start_crc;
				off_counter <= start_off;
			else
				if bit_counter_en = '1' then
					bit_counter <= bit_counter - 1;
				end if;
				if crc_counter_en = '1' then
					crc_counter <= crc_counter - 1;
				end if;
				if off_counter_en = '1' then
					off_counter <= off_counter - 1;
				end if;
			end if;
			if crc_reg_load = '1' then
				last_crc <= crc_out;
				crc_shift <= crc_out;
			else
				crc_shift(6 downto 1) <= crc_shift(5 downto 0);
				crc_shift(0) <= ser_reg_out_1;
			end if;
			if ser_load_en = '1' then
				ser_reg <= ram_data;
			else
				ser_reg(7 downto 1) <= ser_reg(6 downto 0);
			end if;
			if bit_counter_clr = '1' then
				shift_counter <= "000";
				ram_counter <= "00000";
			else
				if bit_counter_en = '1' then
					shift_counter <= shift_counter + 1;
				end if;
				if ram_counter_en = '1' then
					ram_counter <= ram_counter + 1;
				end if;
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.mmc_controller.all;

entity mmc_cmd_rx is
--| Entity <mmc_cmd_rx> is used to represent a response receiver.
--| It is also a programmable one, it can verify a CRC-7 string
--| in a datastream at arbitrary position. The datastream itself is
--| written to external memory space and can be of any length from
--| 1 to 255 bits. Lengths not divisible by 8 are also supported,
--| because overhead is very small.
	port(
--# Buffer memory port
		ram_addr: out std_logic_vector(4 downto 0);
--@ address to external buffer memory 
		ram_data: out std_logic_vector(7 downto 0);
--@ data to external buffer memory
		ram_write: out std_logic;
--@ write enable to external buffer memory (high at <clk> rising
--| edge should cause write)
--# System port
		load_len: in std_logic_vector(7 downto 0);
--@ length, latched by high on <load> when <clk> rises
		load_crc: in std_logic_vector(7 downto 0);
--@ bits up to and including inserted CRC-7 string, latched by high
--| on <load> when <clk> rises
		load_off: in std_logic_vector(7 downto 0);
--@ bits before CRC-7 starts accumulating, latched by high on <load>
--| when <clk> rises
		load: in std_logic;
--@ latches <load_len>, <load_crc> and <load_off>
		start: in std_logic;
--@ initializes internal reception engine
		left_bits: out std_logic_vector(7 downto 0);
--@ bits left to be received into the buffer memory (0 - reception done)
		last_crc: out std_logic_vector(6 downto 0);
--@ calculated CRC-7 checksum for verification (0 - checksum OK)
		clk: in std_logic;
--@ clock signal (rising edge active)
--#	Card side port
		rx: in std_logic
--@ received signal from CMD line
	);
end mmc_cmd_rx;

architecture standard of mmc_cmd_rx is
signal rx_1, crc_clear, crc_load: std_logic;
signal crc_out: std_logic_vector(6 downto 0);
signal waiting, rx_pulse: std_logic;
signal bit_counter, crc_counter, off_counter: std_logic_vector(7 downto 0);
signal bit_counter_nz, bit_counter_en: std_logic;
signal crc_counter_nz, crc_counter_en: std_logic;
signal off_counter_nz, off_counter_en: std_logic;
signal shift_counter: std_logic_vector(2 downto 0);
signal addr_counter: std_logic_vector(4 downto 0);
signal shift_counter_en, addr_counter_en: std_logic;
signal shift_reg: std_logic_vector(7 downto 0);
begin
	crc7: mmc_crc_7 port map(data => rx_1, clk => clk,
	                         clear => crc_clear, crc => crc_out);
	bit_counter_nz <= '0' when bit_counter = X"00" else '1';
	crc_counter_nz <= '0' when crc_counter = X"00" else '1';
	off_counter_nz <= '0' when off_counter = X"FF" else '1';
	crc_clear <= '1' when off_counter = X"00" else '0';
	rx_pulse <= waiting and not rx;
	bit_counter_en <= (rx_pulse or shift_counter_en) and bit_counter_nz;
	crc_counter_en <= shift_counter_en and crc_counter_nz;
	off_counter_en <= bit_counter_en and off_counter_nz;
	addr_counter_en <= '1' when shift_counter = "111" else '0';
	left_bits <= bit_counter;
	ram_addr <= addr_counter;
	ram_data <= shift_reg;
	ram_write <= (shift_counter_en and not bit_counter_nz) or addr_counter_en;
	step: process(clk)
	begin
		if rising_edge(clk) then
			rx_1 <= rx;
			crc_load <= crc_counter_nz;
			shift_reg(7 downto 1) <= shift_reg(6 downto 0);
			shift_reg(0) <= rx;
			if rx_pulse = '1' then
				shift_counter <= "000";
				addr_counter <= "00000";
			else
				if shift_counter_en = '1' then
					shift_counter <= shift_counter + 1;
				end if;
				if addr_counter_en = '1' then
					addr_counter <= addr_counter + 1;
				end if;
			end if;
			if load = '1' then
				bit_counter <= load_len;
				crc_counter <= load_crc;
				off_counter <= load_off;
			else
				if bit_counter_en = '1' then
					bit_counter <= bit_counter - 1;
				end if;
				if crc_counter_en = '1' then
					crc_counter <= crc_counter - 1;
				end if;
				if off_counter_en = '1' then
					off_counter <= off_counter - 1;
				end if;
			end if;
			if bit_counter_nz = '0' then
				shift_counter_en <= '0';
			else
				if rx_pulse = '1' then
					shift_counter_en <= '1';
				end if;
			end if;
			if start = '1' then
				waiting <= '1';
			else
				if rx = '0' then
					waiting <= '0';
				end if;
			end if;
			if crc_load = '1' then
				last_crc <= crc_out;
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mmc_crc_16 is
--| Entity <mmc_crc_16> calculates a running CRC-16 of a data stream.
	port(
		data: in std_logic;
--@ serial data input (MSB first of course)
		clear: in std_logic;
--@ clear whole CRC register
		clk: in std_logic;
--@ clock signal (rising edge active)
		crc: out std_logic_vector(15 downto 0)
--@ calculated running CRC-16 (valid only after 16 zeroes on <data>)
	);
end mmc_crc_16;

architecture standard of mmc_crc_16 is
signal crc_reg: std_logic_vector(15 downto 0);
begin
	crc <= crc_reg;
	step: process(clk)
	begin
		if rising_edge(clk) then
			if clear = '1' then
				crc_reg <= X"0000";
			else
				crc_reg(0) <= data xor crc_reg(15);
				crc_reg(1) <= crc_reg(0);
				crc_reg(2) <= crc_reg(1);
				crc_reg(3) <= crc_reg(2);
				crc_reg(4) <= crc_reg(3);
				crc_reg(5) <= crc_reg(4) xor crc_reg(15);
				crc_reg(6) <= crc_reg(5);
				crc_reg(7) <= crc_reg(6);
				crc_reg(8) <= crc_reg(7);
				crc_reg(9) <= crc_reg(8);
				crc_reg(10) <= crc_reg(9);
				crc_reg(11) <= crc_reg(10);
				crc_reg(12) <= crc_reg(11) xor crc_reg(15);
				crc_reg(13) <= crc_reg(12);
				crc_reg(14) <= crc_reg(13);
				crc_reg(15) <= crc_reg(14);
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.mmc_controller.all;

entity mmc_dat_tx is
--| Entity <mmc_dat_tx> is used to represent a data block transmitter.
	port(
--# Buffer memory port
		ram_addr: out std_logic_vector(6 downto 0);
--@ address to external buffer memory 
		ram_data: in std_logic_vector(31 downto 0);
--@ data from external buffer memory
--# System port
		start_len: in std_logic_vector(7 downto 0);
--@ length in dwords, latched by high on <start> when <clk> rises
		start_wide: in std_logic;
--@ if set, 4-bit mode enabled
		start_crc: in std_logic;
--@ if set, send CRC-16 after the block
		start: in std_logic;
--@ latches <start_len>; initializes internal transmission engine
		left_len: out std_logic_vector(7 downto 0);
--@ dwords left to be transmitted out of buffer memory (0 - transmission done)
		clk: in std_logic;
--@ clock signal (rising edge active)
--#	Card side port
		tx0: out std_logic;
--@ transmitted signal to DAT0 line
		tx1: out std_logic;
--@ transmitted signal to DAT1 line
		tx2: out std_logic;
--@ transmitted signal to DAT2 line
		tx3: out std_logic;
--@ transmitted signal to DAT3 line
		tx_enable_0: out std_logic;
--@ transmitter enable on DAT0 line
		tx_enable_123: out std_logic
--@ transmitter enable on DAT1,2,3 lines
	);
end mmc_dat_tx;

architecture standard of mmc_dat_tx is
signal crc0_out, crc1_out, crc2_out, crc3_out: std_logic_vector(15 downto 0);
signal dword_counter: std_logic_vector(7 downto 0);
signal bit_counter: std_logic_vector(4 downto 0);
signal crc_counter: std_logic_vector(4 downto 0);
signal addr_counter: std_logic_vector(6 downto 0);
signal dword_counter_en, dword_counter_nz: std_logic;
signal ser_load, crc_clear, ser_load_w, ser_load_n: std_logic;
signal bit_counter_en, dword_counter_en_w, dword_counter_en_n: std_logic;
signal crc_counter_en, crc_counter_nz, crc_counter_nz_1: std_logic;
signal ser_reg: std_logic_vector(31 downto 0);
signal ser_reg0, ser_reg1, ser_reg2, ser_reg3, ser_reg_en: std_logic;
signal ser_reg0_t, ser_reg1_t, ser_reg2_t, ser_reg3_t: std_logic;
signal ser_reg0_1, ser_reg1_1, ser_reg2_1, ser_reg3_1: std_logic;
signal crc_reg0, crc_reg1, crc_reg2, crc_reg3, txe_reg: std_logic_vector(15 downto 0);
signal wide_mode, crc_load, ser_reg_en_1, send_crc: std_logic;
signal crc_load_1, txe_1, stop_bit: std_logic;
signal txe_half, tx0_half, tx1_half, tx2_half, tx3_half: std_logic;
begin
	crc0: mmc_crc_16 port map(data => ser_reg0, clk => clk,
	                          clear => crc_clear, crc => crc0_out);
	crc1: mmc_crc_16 port map(data => ser_reg1, clk => clk,
	                          clear => crc_clear, crc => crc1_out);
	crc2: mmc_crc_16 port map(data => ser_reg2, clk => clk,
	                          clear => crc_clear, crc => crc2_out);
	crc3: mmc_crc_16 port map(data => ser_reg3, clk => clk,
	                          clear => crc_clear, crc => crc3_out);
	dword_counter_nz <= '0' when dword_counter = X"0000" else '1';
	dword_counter_en_w <= '1' when bit_counter(2 downto 0) = "111" else '0';
	dword_counter_en_n <= '1' when bit_counter = "11111" else '0';
	dword_counter_en <= dword_counter_en_w when wide_mode = '1' else dword_counter_en_n;
	crc_counter_nz <= not crc_counter(4);
	crc_counter_en <= crc_counter_nz and not dword_counter_nz;
	bit_counter_en <= dword_counter_nz;
	ser_load_n <= '1' when bit_counter = "00000" else '0';
	ser_load_w <= '1' when bit_counter(2 downto 0) = "000" else '0';
	ser_load <= ser_load_w when wide_mode = '1' else ser_load_n;
	ram_addr <= addr_counter;
	left_len <= dword_counter;
	stop_bit <= txe_1 and not txe_reg(15);
	tx0_half <= crc_reg0(15) or stop_bit;
	tx1_half <= crc_reg1(15) or (stop_bit and wide_mode);
	tx2_half <= crc_reg2(15) or (stop_bit and wide_mode);
	tx3_half <= crc_reg3(15) or (stop_bit and wide_mode);
	txe_half <= txe_reg(15) or txe_1;
	ser_reg3_t <= ser_reg(31) when wide_mode = '1' else '0';
	ser_reg2_t <= ser_reg(30) when wide_mode = '1' else '0';
	ser_reg1_t <= ser_reg(29) when wide_mode = '1' else '0';
	ser_reg0_t <= ser_reg(28) when wide_mode = '1' else ser_reg(31);
	ser_reg3 <= ser_reg3_t and ser_reg_en;
	ser_reg2 <= ser_reg2_t and ser_reg_en;
	ser_reg1 <= ser_reg1_t and ser_reg_en;
	ser_reg0 <= ser_reg0_t and ser_reg_en;
	crc_clear <= dword_counter_nz and not ser_reg_en;
	crc_load <= crc_counter_nz_1 and not crc_counter_nz;
	step: process(clk)
	begin
		if falling_edge(clk) then
			tx_enable_0 <= txe_half;
			tx_enable_123 <= txe_half and wide_mode;
			tx0 <= tx0_half;
			tx1 <= tx1_half;
			tx2 <= tx2_half;
			tx3 <= tx3_half;
		end if;
		if rising_edge(clk) then
			txe_1 <= txe_reg(15);
			ser_reg_en <= dword_counter_nz;
			ser_reg_en_1 <= ser_reg_en;
			crc_counter_nz_1 <= crc_counter_nz;
			ser_reg0_1 <= ser_reg0;
			ser_reg1_1 <= ser_reg1;
			ser_reg2_1 <= ser_reg2;
			ser_reg3_1 <= ser_reg3;
			crc_load_1 <= crc_load;
			if (crc_load_1 = '1') and (send_crc = '1') then
				crc_reg0 <= crc0_out;
				crc_reg1 <= crc1_out;
				crc_reg2 <= crc2_out;
				crc_reg3 <= crc3_out;
				txe_reg <= X"FFFF";
			else
				crc_reg0(15 downto 1) <= crc_reg0(14 downto 0);
				crc_reg1(15 downto 1) <= crc_reg1(14 downto 0);
				crc_reg2(15 downto 1) <= crc_reg2(14 downto 0);
				crc_reg3(15 downto 1) <= crc_reg3(14 downto 0);
				crc_reg0(0) <= ser_reg0_1;
				crc_reg1(0) <= ser_reg1_1;
				crc_reg2(0) <= ser_reg2_1;
				crc_reg3(0) <= ser_reg3_1;
				txe_reg(15 downto 1) <= txe_reg(14 downto 0);
				txe_reg(0) <= ser_reg_en or ser_reg_en_1;
			end if;
			if ser_load = '1' then
				ser_reg <= ram_data;
			else
				if wide_mode = '1' then
					ser_reg(31 downto 4) <= ser_reg(27 downto 0);
					ser_reg(0) <= '0';
					ser_reg(1) <= '0';
					ser_reg(2) <= '0';
					ser_reg(3) <= '0';
				else
					ser_reg(31 downto 1) <= ser_reg(30 downto 0);
					ser_reg(0) <= '0';
				end if;
			end if;
			if start = '1' then
				dword_counter <= start_len;
				bit_counter <= "00000";
				crc_counter <= "00000";
				addr_counter <= "0000000";
				wide_mode <= start_wide;
				send_crc <= start_crc;
			else
				if bit_counter_en = '1' then
					bit_counter <= bit_counter + 1;
				end if;
				if crc_counter_en = '1' then
					crc_counter <= crc_counter + 1;
				end if;
				if dword_counter_en = '1' then
					dword_counter <= dword_counter - 1;
					addr_counter <= addr_counter + 1;
				end if;
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.mmc_controller.all;

entity mmc_dat_rx is
--| Entity <mmc_dat_rx> is used to represent a data block receiver.
	port(
--# Buffer memory port
		ram_addr: out std_logic_vector(6 downto 0);
--@ address to external buffer memory 
		ram_data: out std_logic_vector(31 downto 0);
--@ data to external buffer memory
		ram_write: out std_logic;
--@ write enable to external buffer memory (high at <clk> rising
--| edge should cause write)
--# System port
		load_len: in std_logic_vector(7 downto 0);
--@ length in dwords, latched by high on <load> when <clk> rises
		load_wide: in std_logic;
--@ if set, 4-bit mode enabled
		load: in std_logic;
--@ latches <load_len>
		start: in std_logic;
--@ initializes internal reception engine
		done: out std_logic;
--@ signals receive completion
		left_len: out std_logic_vector(7 downto 0);
--@ dwords left to be transmitted out of buffer memory (0 - transmission done)
		crc_status: out std_logic;
--@ CRC-16 status (set on error)
		clk: in std_logic;
--@ clock signal (rising edge active)
--#	Card side port
		rx0: in std_logic;
--@ transmitted signal from DAT0 line
		rx1: in std_logic;
--@ transmitted signal from DAT1 line
		rx2: in std_logic;
--@ transmitted signal from DAT2 line
		rx3: in std_logic
--@ transmitted signal from DAT3 line
	);
end mmc_dat_rx;

architecture standard of mmc_dat_rx is
signal crc0_out, crc1_out, crc2_out, crc3_out: std_logic_vector(15 downto 0);
signal waiting, rx_pulse, crc_load, crc0_set, crc1_set, crc2_set, crc3_set: std_logic;
signal wide_mode, clear_cntr: std_logic;
signal dword_counter: std_logic_vector(7 downto 0);
signal addr_counter: std_logic_vector(6 downto 0);
signal bit_counter, bit_counter_w: std_logic_vector(4 downto 0);
signal dword_counter_nz, dword_counter_en, bit_counter_en: std_logic;
signal crc_counter: std_logic_vector(4 downto 0);
signal crc_counter_en, crc_counter_nz: std_logic;
signal shift_reg: std_logic_vector(31 downto 0);
begin
	crc0: mmc_crc_16 port map(data => rx0, clk => clk,
	                          clear => rx_pulse, crc => crc0_out);
	crc1: mmc_crc_16 port map(data => rx1, clk => clk,
	                          clear => rx_pulse, crc => crc1_out);
	crc2: mmc_crc_16 port map(data => rx2, clk => clk,
	                          clear => rx_pulse, crc => crc2_out);
	crc3: mmc_crc_16 port map(data => rx3, clk => clk,
	                          clear => rx_pulse, crc => crc3_out);
	rx_pulse <= waiting and not rx0;
	crc0_set <= '0' when crc0_out = X"0000" else '1';
	crc1_set <= '0' when crc1_out = X"0000" else '1';
	crc2_set <= '0' when crc2_out = X"0000" else '1';
	crc3_set <= '0' when crc3_out = X"0000" else '1';
	bit_counter_w(2 downto 0) <= bit_counter(2 downto 0);
	bit_counter_w(3) <= bit_counter(3) or wide_mode;
	bit_counter_w(4) <= bit_counter(4) or wide_mode;
	dword_counter_en <= '1' when bit_counter_w = "11111" else '0';
	dword_counter_nz <= '0' when dword_counter = X"00" else '1';
	crc_counter_nz <= not crc_counter(4);
	crc_counter_en <= crc_counter_nz and not dword_counter_nz;
	crc_load <= '1' when crc_counter = "01111" else '0';
	left_len <= dword_counter;
	ram_addr <= addr_counter;
	ram_data <= shift_reg;
	ram_write <= dword_counter_en;
	done <= (not crc_counter_nz) and not dword_counter_nz;
	step: process(clk)
	begin
		if rising_edge(clk) then
			clear_cntr <= rx_pulse;
			if wide_mode = '1' then
				shift_reg(31 downto 4) <= shift_reg(27 downto 0);
				shift_reg(3) <= rx3;
				shift_reg(2) <= rx2;
				shift_reg(1) <= rx1;
				shift_reg(0) <= rx0;
			else
				shift_reg(31 downto 1) <= shift_reg(30 downto 0);
				shift_reg(0) <= rx0;
			end if;
			if clear_cntr = '1' then
				addr_counter <= "0000000";
				bit_counter <= "00000";
				crc_counter <= "00000";
				bit_counter_en <= '1';
			else
				if dword_counter_nz = '0' then
					bit_counter_en <= '0';
				end if;
				if crc_counter_en = '1' then
					crc_counter <= crc_counter + 1;
				end if;
				if bit_counter_en = '1' then
					bit_counter <= bit_counter + 1;
				end if;
				if dword_counter_en = '1' then
					addr_counter <= addr_counter + 1;
				end if;
			end if;
			if crc_load = '1' then
				if wide_mode = '1' then
					crc_status <= crc0_set or crc1_set or crc2_set or crc3_set;
				else
					crc_status <= crc0_set;
				end if;
			end if;
			if load = '1' then
				wide_mode <= load_wide;
				dword_counter <= load_len;
			else
				if dword_counter_en = '1' then
					dword_counter <= dword_counter - 1;
				end if;
			end if;
			if start = '1' then
				waiting <= '1';
			else
				if rx0 = '0' then
					waiting <= '0';
				end if;
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mmc_stat_rx is
--| Entity <mmc_stat_rx> is used to represent a data status receiver.
	port(
--# System port
		start: in std_logic;
--@ initializes internal reception engine
		status: out std_logic_vector(4 downto 0);
--@ status word from card
		clk: in std_logic;
--@ clock signal (rising edge active)
--#	Card side port
		rx0: in std_logic
--@ transmitted signal from DAT0 line
	);
end mmc_stat_rx;

architecture standard of mmc_stat_rx is
signal shift_reg: std_logic_vector(4 downto 0);
signal waiting: std_logic;
begin
	step: process(clk)
	begin
		if rising_edge(clk) then
			if start = '1' then
				waiting <= '1';
				status <= "11111";
				shift_reg <= "11111";
			else
				shift_reg(4 downto 1) <= shift_reg(3 downto 0);
				shift_reg(0) <= rx0;
				if (shift_reg(4) = '0') and (waiting = '1') then
					status <= shift_reg;
					waiting <= '0';
				end if;
			end if;
		end if;
	end process;
end standard;

----------------------------------------------------------------------------------
