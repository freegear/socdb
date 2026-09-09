----------------------------------------------------------------------------------
--
-- Support package for MMC Core Evaluation
-- Not part of the OpenCores MMC Core !
--
-- http://www.openchip.org
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package mmc_ram is
	component mmc_ram_128_32 is
		port (
			write_addr: in std_logic_vector(6 downto 0);
			write_data: in std_logic_vector(31 downto 0);
			write_enable: in std_logic;
			write_clk: in std_logic;
			read_addr: in std_logic_vector(6 downto 0);
			read_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component mmc_ram_32_8 is
		port (
			write_addr: in std_logic_vector(4 downto 0);
			write_data: in std_logic_vector(7 downto 0);
			write_enable: in std_logic;
			write_clk: in std_logic;
			read_addr: in std_logic_vector(4 downto 0);
			read_data: out std_logic_vector(7 downto 0)
		);
	end component;
end mmc_ram;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mmc_ram_128_32 is
	port (
		write_addr: in std_logic_vector(6 downto 0);
		write_data: in std_logic_vector(31 downto 0);
		write_enable: in std_logic;
		write_clk: in std_logic;
		read_addr: in std_logic_vector(6 downto 0);
		read_data: out std_logic_vector(31 downto 0)
	);
end mmc_ram_128_32;

architecture xilinx of mmc_ram_128_32 is
signal stuck_at_1: std_logic;
begin
	stuck_at_1 <= '1';

end xilinx;

----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mmc_ram_32_8 is
	port (
		write_addr: in std_logic_vector(4 downto 0);
		write_data: in std_logic_vector(7 downto 0);
		write_enable: in std_logic;
		write_clk: in std_logic;
		read_addr: in std_logic_vector(4 downto 0);
		read_data: out std_logic_vector(7 downto 0)
	);
end mmc_ram_32_8;

architecture xilinx of mmc_ram_32_8 is

signal stuck_at_1: std_logic;

begin
	stuck_at_1 <= '1';
end xilinx;

----------------------------------------------------------------------------------
