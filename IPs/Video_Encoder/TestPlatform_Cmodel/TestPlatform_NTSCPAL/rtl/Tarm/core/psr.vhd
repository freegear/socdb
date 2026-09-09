-- VHDL Model Created from SGE Symbol psr.sym -- Jul  1 14:52:48 2003

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_misc.all;
    use IEEE.std_logic_arith.all;

entity PSR is
port (
    CLK        : in  std_logic;
    CPSR_IN    : in  std_logic_vector (31 downto 0);
    CPSR_WEN   : in  std_logic_vector ( 3 downto 0);
    FLUSH      : in  std_logic;
    SPSR_IN    : in  std_logic_vector (31 downto 0);
    SPSR_RADDR : in  std_logic_vector ( 2 downto 0);
    SPSR_WADDR : in  std_logic_vector ( 2 downto 0);
    SPSR_WEN   : in  std_logic_vector ( 3 downto 0);
    STALL      : in  std_logic;
    CPSR_OUT   : out std_logic_vector (31 downto 0);
    SPSR_OUT   : out std_logic_vector (31 downto 0)
);
end PSR;

architecture BEHAVIORAL of PSR is
	--------------------------------
	-- ToyARM 1.0
	-- Author: Oh, kyungsoo
	-- Last updated: 2003.08.02.
	--------------------------------

	--
	-- PSR Register Configuration
	-- Little endian configuration
	-- Write access size is 1byte
	--
	signal cpsr_buf_cell  : std_logic_vector (31 downto 0);
	signal spsr_buf_cell0 : std_logic_vector (31 downto 0);
	signal spsr_buf_cell1 : std_logic_vector (31 downto 0);
	signal spsr_buf_cell2 : std_logic_vector (31 downto 0);
	signal spsr_buf_cell3 : std_logic_vector (31 downto 0);
	signal spsr_buf_cell4 : std_logic_vector (31 downto 0);

begin

	process (CLK)
	begin
		if (CLK'event and CLK = '1') then
			if (FLUSH = '1') then
				cpsr_buf_cell  <= x"000000d3";
				spsr_buf_cell0 <= (others => '0');
				spsr_buf_cell1 <= (others => '0');
				spsr_buf_cell2 <= (others => '0');
				spsr_buf_cell3 <= (others => '0');
				spsr_buf_cell4 <= (others => '0');
			elsif (STALL = '0') then
				-- CPSR Write 
				if (CPSR_WEN(0) = '1') then
					cpsr_buf_cell( 7 downto  0) <= CPSR_IN( 7 downto  0);
				end if;
				if (CPSR_WEN(1) = '1') then
					cpsr_buf_cell(15 downto  8) <= CPSR_IN(15 downto  8);
				end if;
				if (CPSR_WEN(2) = '1') then
					cpsr_buf_cell(23 downto 16) <= CPSR_IN(23 downto 16);
				end if;
				if (CPSR_WEN(3) = '1') then
					cpsr_buf_cell(31 downto 24) <= CPSR_IN(31 downto 24);
				end if;
				-- SPSR Write
				case SPSR_WADDR is
                when "000" =>
					if (SPSR_WEN(0) = '1') then
						spsr_buf_cell0( 7 downto  0) <= SPSR_IN( 7 downto  0);
					end if;
					if (SPSR_WEN(1) = '1') then
						spsr_buf_cell0(15 downto  8) <= SPSR_IN(15 downto  8);
					end if;
					if (SPSR_WEN(2) = '1') then
						spsr_buf_cell0(23 downto 16) <= SPSR_IN(23 downto 16);
					end if;
					if (SPSR_WEN(3) = '1') then
						spsr_buf_cell0(31 downto 24) <= SPSR_IN(31 downto 24);
					end if;
                when "001" =>
					if (SPSR_WEN(0) = '1') then
						spsr_buf_cell1( 7 downto  0) <= SPSR_IN( 7 downto  0);
					end if;
					if (SPSR_WEN(1) = '1') then
						spsr_buf_cell1(15 downto  8) <= SPSR_IN(15 downto  8);
					end if;
					if (SPSR_WEN(2) = '1') then
						spsr_buf_cell1(23 downto 16) <= SPSR_IN(23 downto 16);
					end if;
					if (SPSR_WEN(3) = '1') then
						spsr_buf_cell1(31 downto 24) <= SPSR_IN(31 downto 24);
					end if;
                when "010" =>
					if (SPSR_WEN(0) = '1') then
						spsr_buf_cell2( 7 downto  0) <= SPSR_IN( 7 downto  0);
					end if;
					if (SPSR_WEN(1) = '1') then
						spsr_buf_cell2(15 downto  8) <= SPSR_IN(15 downto  8);
					end if;
					if (SPSR_WEN(2) = '1') then
						spsr_buf_cell2(23 downto 16) <= SPSR_IN(23 downto 16);
					end if;
					if (SPSR_WEN(3) = '1') then
						spsr_buf_cell2(31 downto 24) <= SPSR_IN(31 downto 24);
					end if;
                when "011" =>
					if (SPSR_WEN(0) = '1') then
						spsr_buf_cell3( 7 downto  0) <= SPSR_IN( 7 downto  0);
					end if;
					if (SPSR_WEN(1) = '1') then
						spsr_buf_cell3(15 downto  8) <= SPSR_IN(15 downto  8);
					end if;
					if (SPSR_WEN(2) = '1') then
						spsr_buf_cell3(23 downto 16) <= SPSR_IN(23 downto 16);
					end if;
					if (SPSR_WEN(3) = '1') then
						spsr_buf_cell3(31 downto 24) <= SPSR_IN(31 downto 24);
					end if;
                when "100" =>
					if (SPSR_WEN(0) = '1') then
						spsr_buf_cell4( 7 downto  0) <= SPSR_IN( 7 downto  0);
					end if;
					if (SPSR_WEN(1) = '1') then
						spsr_buf_cell4(15 downto  8) <= SPSR_IN(15 downto  8);
					end if;
					if (SPSR_WEN(2) = '1') then
						spsr_buf_cell4(23 downto 16) <= SPSR_IN(23 downto 16);
					end if;
					if (SPSR_WEN(3) = '1') then
						spsr_buf_cell4(31 downto 24) <= SPSR_IN(31 downto 24);
					end if;
                when others =>
                end case;
			end if;
		end if;
	end process;

	CPSR_OUT <= cpsr_buf_cell;

	process (SPSR_RADDR, spsr_buf_cell0, spsr_buf_cell1,
			 spsr_buf_cell2, spsr_buf_cell3, spsr_buf_cell4)
	begin
		case SPSR_RADDR is
        when "000"  => SPSR_OUT <= spsr_buf_cell0;
        when "001"  => SPSR_OUT <= spsr_buf_cell1;
        when "010"  => SPSR_OUT <= spsr_buf_cell2;
        when "011"  => SPSR_OUT <= spsr_buf_cell3;
        when "100"  => SPSR_OUT <= spsr_buf_cell4;
        when others => SPSR_OUT <= (others => '0');
        end case;
	end process;

end BEHAVIORAL;

configuration CFG_PSR of PSR is
   for BEHAVIORAL
   end for;
end CFG_PSR;
