----------------------------------------------------------------------------------------------------
-- Test Vector Program for K9F2G08X0M. 
-- Programmed By NAND FLASH Memory Design Team, Samsung Semiconductor Co. LTD.
-- Rev. 0.0
----------------------------------------------------------------------------------------------------

library IEEE;
library k9f2g08u0m;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

ENTITY tbench IS
GENERIC(
	PWRUP    : time :=   50.0  us;
        tR       : time :=   25.1 us;
        tPROG    : time :=  300.1 us;
	tCBSY	 : time :=    3.1 us;
        tBERS    : time :=    2.1 ms
);
END tbench;

ARCHITECTURE T_K9F2G08X0M of tbench is
COMPONENT k9f2g08x0m --K9F2G08X0M
	PORT (
         	ios : INOUT std_logic_vector(7 downto 0);
         	cle : IN    std_logic;
         	ale : IN    std_logic;
         	ceb : IN    std_logic;
         	reb : IN    std_logic;
         	web : IN    std_logic;
         	wpb : IN    std_logic;
         	rbb : OUT   std_logic;
		pre : IN    std_logic
	);
END COMPONENT;

signal         cle : std_logic;
signal         ale : std_logic;
signal         ceb : std_logic;
signal         reb : std_logic;
signal         web : std_logic;
signal         wpb : std_logic;
signal         rbb : std_logic;
signal         pre : std_logic;
signal         ios : std_logic_vector (7 downto 0);

begin

--U1: K9F2G08X0M
U1 : k9f2g08x0m
	port map (ios, cle, ale, ceb, reb, web, wpb, rbb, pre);

test: process
--------------------------------
-- USER Defines Variables Here -
-------------------------------

constant addr_zero 	: std_logic_vector(7 downto 0) := ('0','0','0','0','0','0','0','0');
constant X_data 	: std_logic_vector(7 downto 0) := ('X','X','X','X','X','X','X','X');
constant Z_data 	: std_logic_vector(7 downto 0) := ('Z','Z','Z','Z','Z','Z','Z','Z');
constant one_data 	: std_logic_vector(7 downto 0) := ('1','1','1','1','1','1','1','1');
constant zero_data 	: std_logic_vector(7 downto 0) := ('0','0','0','0','0','0','0','0');
constant mix1_data 	: std_logic_vector(7 downto 0) := ('0','1','1','1','1','1','1','1');
constant mix2_data 	: std_logic_vector(7 downto 0) := ('1','0','0','0','0','0','0','0');

constant H00        : std_logic_vector(7 downto 0) := zero_data;
constant H30	    : std_logic_vector(7 downto 0) := ('0','0','1','1','0','0','0','0');
constant H35	    : std_logic_vector(7 downto 0) := ('0','0','1','1','0','1','0','1');
constant H05        : std_logic_vector(7 downto 0) := ('0','0','0','0','0','1','0','1');
constant HE0        : std_logic_vector(7 downto 0) := ('1','1','1','0','0','0','0','0');
constant H80        : std_logic_vector(7 downto 0) := ('1','0','0','0','0','0','0','0');
constant H85        : std_logic_vector(7 downto 0) := ('1','0','0','0','0','1','0','1');
constant H10        : std_logic_vector(7 downto 0) := ('0','0','0','1','0','0','0','0');
constant H15        : std_logic_vector(7 downto 0) := ('0','0','0','1','0','1','0','1');
constant H60        : std_logic_vector(7 downto 0) := ('0','1','1','0','0','0','0','0');
constant HD0        : std_logic_vector(7 downto 0) := ('1','1','0','1','0','0','0','0');
constant H70        : std_logic_vector(7 downto 0) := ('0','1','1','1','0','0','0','0');
constant H90        : std_logic_vector(7 downto 0) := ('1','0','0','1','0','0','0','0');
constant HFF   	    : std_logic_vector(7 downto 0) := ('1','1','1','1','1','1','1','1');

variable cur_com : std_logic_vector(7 downto 0) := x_data;
variable k : integer;

procedure command_latch(com: in std_logic_vector(7 downto 0)) is
begin
	wpb <= '1';
  	ceb <= '0';  
  	cle <= '1';
  	ale <= '0';
  	reb <= '1';
	wait for 2 ns; 	-- tWC : 50 ns
  	web <= '0';
  	wait for 5 ns;
  	ios <= com;
  	wait for 22 ns;
  	web <= '1';
  	wait for 25 ns;
  	cle <= '0';
--        ceb <= '1';
  	ios <= z_data;
	cur_com := com;
end command_latch;

procedure addr_latch(addin: in std_logic_vector(7 downto 0)) is
begin
		wpb <= '1';
  		ceb <= '0';
  		cle <= '0';
  		ale <= '1';
  		reb <= '1';
		wait for 2 ns;   -- tWC : 50 ns
  		web <= '0';
		wait for 5 ns;
		ios <= addin;
		wait for 22 ns;
		web <= '1';
		wait for 25 ns;
		ale <= '0';
		ios <= z_data;
end addr_latch;

procedure data_latch(d: in std_logic_vector(7 downto 0); size: in integer) is
variable i: integer;
begin
	wpb <= '1';
  	for i in 0 to size-1 loop
  		ceb <= '0';
  		cle <= '0';
  		ale <= '0';
  		reb <= '1';
		wait for 2 ns;	-- tWC : 50 ns
  		web <= '0';
      		wait for 5 ns;
      		ios <= d + i;
      		wait for 22 ns;
      		web <= '1';
      		wait for 25 ns;
      		ios <= z_data;
  	end loop;
end data_latch;
	
procedure read_data(size: in integer) is
variable i, j: integer;
begin
	wpb <= '1';
  	for i in 1 to size loop
  			ceb <= '0';
  			cle <= '0';
  			ale <= '0';
  			web <= '1';
			wait for 2 ns;	-- tRC : 50 ns
  			reb <= '0';
			wait for 42 ns;
			reb <= '1';
			wait for 40 ns;
  	end loop;
	wait for 30 ns;
end read_data;

--procedure ce_interrupt is
--begin
--	ceb <= '1';
--	wait for 100 ns;
--	ceb <= '0'; 
--end ce_interrupt;

procedure ce_high is
begin
	wait for 100 ns;
	ceb <= '1';
end ce_high;

procedure ce_low is
begin
	ceb <= '0';
	wait for 100 ns;
end ce_low;

-- ********  START HERE *************** --
--------------------------------
-- USER Test Program Here ------
--------------------------------
begin

  	cle <= '0';
  	ale <= '0';
  	ceb <= '0';
  	web <= '1';
  	reb <= '1';
  	wpb <= '1';
	pre <= '1';
  	ios <= z_data;
	wait for PWRUP;
        read_data(100);

      --ID Read
        command_latch(H90);
        addr_latch("00000000");
        wait for 100 ns;
        read_data(5);
        wait for 100 ns;

        command_latch(H80);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
	addr_latch("00000000");
        wait for 100 ns;
        data_latch("00000000", 3);
        wait for 100 ns;

	command_latch(H85);
	addr_latch("00001000");
	addr_latch("11100000");
        wait for 100 ns;
        data_latch("00000000", 3);
        wait for 100 ns;

	command_latch(H85);
	addr_latch("00001100");
	addr_latch("11100000");
        wait for 100 ns;
        data_latch("00000000", 10);
        wait for 100 ns;

        command_latch(H15);
        wait for 100 ns;
        command_latch(H70);
        wait for 100 ns;
        read_data(1);
        ce_high;
        wait for tCBSY;
        ce_low;
        command_latch(H70);
        wait for 100 ns;
        read_data(1);
        wait for 100 ns;

        command_latch(H80);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000001");
        addr_latch("00000000");
	addr_latch("00000000");
        wait for 100 ns;
        data_latch("00000000", 16);
        wait for 100 ns;
        command_latch(H10);
        wait for 100 ns;
        command_latch(H70);
        wait for 100 ns;
        read_data(1);
        ce_high;
        wait for tPROG;
        wait for tPROG;
        ce_low;
        command_latch(H70);
        wait for 100 ns;
        read_data(1);
        wait for 100 ns;

        command_latch(H00);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
	addr_latch("00000000");
        command_latch(H30);
        wait for 100 ns;
        ce_high;
        wait for tR;
        ce_low;
        wait for 100 ns;
	read_data(16);

        command_latch(H00);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000001");
        addr_latch("00000000");
	addr_latch("00000000");
        command_latch(H30);
        wait for 100 ns;
        ce_high;
        wait for tR;
        ce_low;
        wait for 100 ns;
	read_data(4);

	command_latch(H05);
        addr_latch("00001000");
        addr_latch("00000000");
        command_latch(HE0);
        wait for 100 ns;
	read_data(4);

	command_latch(H05);
        addr_latch("00001100");
        addr_latch("00000000");
        command_latch(HE0);
        wait for 100 ns;
	read_data(16);

        command_latch(H00);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
	addr_latch("00000000");
        command_latch(H35);
        command_latch(H35);
        wait for 100 ns;
        ce_high;
        wait for tR;
        ce_low;
        wait for 100 ns;

        command_latch(H85);
        addr_latch("00000100");
        addr_latch("00000000");
        addr_latch("01000000");
        addr_latch("00000000");
	addr_latch("00000000");
	wait for 100 ns;
        data_latch("00000100", 3);
	wait for 100 ns;

        command_latch(H85);
        addr_latch("00001100");
        addr_latch("00000000");
	wait for 100 ns;
        data_latch("00001100", 4);
        wait for 100 ns;
        command_latch(H10);
        wait for 100 ns;
        command_latch(H70);
        wait for 100 ns;
        read_data(1);
        ce_high;
        wait for tPROG;
        ce_low;
        command_latch(H70);
        wait for 100 ns;
        read_data(1);
        wait for 100 ns;

        command_latch(H00);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("01000000");
        addr_latch("00000000");
	addr_latch("00000000");
        command_latch(H30);
        wait for 100 ns;
        ce_high;
	wait for tR;
        ce_low;
        wait for 100 ns;
	read_data(16);

        command_latch(H60);
        addr_latch("00111111");
        addr_latch("00000000");
	addr_latch("00000000");
        command_latch(HD0);
        wait for 100 ns;
        ce_high;
	wait for tBERS;
	ce_low;
	wait for 100 ns;

        command_latch(H00);
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
        addr_latch("00000000");
	addr_latch("00000000");
        command_latch(H30);
        wait for 100 ns;
        ce_high;
	wait for tR;
	ce_low;
	wait for 100 ns;
	read_data(16);

	wait;

end process test;

end;

configuration T_K9F2G08X0M of tbench is
   for T_K9F2G08X0M
     for u1: K9F2G08X0M use configuration k9f2g08u0m.C_K9F2G08X0M;
     end for;
   end for;
end T_K9F2G08X0M;

