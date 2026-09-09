library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 
--  Uncomment the following lines to use the declarations that are 
--  provided for instantiating Xilinx primitive components. 
--library UNISIM; 
--use UNISIM.VComponents.all; 
 
entity hc4094_7seg is 
    Port ( clk : in std_logic; 
           rstb : in std_logic; 
           seg_d : in std_logic_vector(15 downto 0);
           --------------------------------------------------------------------
           led_4094d : out std_logic; 
           led_4094clk : out std_logic; 
           led_4094oe : out std_logic; 
           led_4094str : out std_logic_vector(3 downto 0)); 
end hc4094_7seg; 
 
architecture Behavioral of hc4094_7seg is 
 
signal cnt : integer range 0 to 100001; 
signal div_cnt : integer range 0 to 34; 
signal div_clk : std_logic; 
signal led_reg : std_logic_vector(31 downto 0); 
signal cnt_reg_1, cnt_reg_2, cnt_reg_3, cnt_reg_4 : std_logic_vector(3 downto 0);
signal seg_reg_1, seg_reg_2, seg_reg_3, seg_reg_4 : std_logic_vector(7 downto 0); 
 
begin 
 
led_4094oe <= rstb; 
 
process(rstb, clk, cnt, div_clk) 
begin 
if rstb = '0' then 
  cnt <= 0; 
  div_clk <= '0'; 
elsif rising_edge(clk) then 
--  if cnt = 100000 then   -- for simultaion. mask this line.
  if cnt = 100 then   -- for simultaion. mask this line.
--  if cnt = 10 then   -- for test
    cnt <= 0; 
    div_clk <= not div_clk; 
  else 
    cnt <= cnt + 1; 
    div_clk <= div_clk; 
  end if; 
end if; 
end process; 
 
process(rstb, div_clk, div_cnt, seg_reg_1, seg_reg_2, seg_reg_3, seg_reg_4, led_reg) 
--process(rstb, div_clk, div_cnt, seg_d, led_reg) 
begin 
  if rstb = '0' then 
    led_reg <= (others => '0'); 
  elsif rising_edge(div_clk) then 
    if div_cnt = 33 then 
      led_reg <= seg_reg_1 & seg_reg_2 & seg_reg_3 & seg_reg_4;
    else 
      led_reg <= led_reg(30 downto 0) & '0'; 
    end if; 
  end if; 
end process; 
 

led_4094d <= led_reg(31); 
 
process(rstb, div_clk, div_cnt) 
begin 
  if rstb = '0' then 
    div_cnt <= 0; 
elsif rising_edge(div_clk) then 
  if div_cnt = 33 then 
    div_cnt <= 0; 
  else 
    div_cnt <= div_cnt + 1; 
  end if; 
end if; 
end process; 
 
led_4094str(0) <= '1' when div_cnt = 8  and div_clk = '1' and not(cnt = 0) and cnt < 8 else '0'; 
led_4094str(1) <= '1' when div_cnt = 16 and div_clk = '1' and not(cnt = 0 ) and cnt < 8 else '0'; 
led_4094str(2) <= '1' when div_cnt = 24 and div_clk = '1' and not(cnt = 0 ) and cnt < 8 else '0'; 
led_4094str(3) <= '1' when div_cnt = 32 and div_clk = '1' and not(cnt = 0 ) and cnt < 8 else '0'; 
 
led_4094clk <= not div_clk; 
 
process(rstb, div_clk, cnt_reg_1) 
begin 
if rstb = '0' then 
  cnt_reg_1 <= X"0"; 
elsif rising_edge(div_clk) then 
  if div_cnt = 33 then 
    cnt_reg_1 <= cnt_reg_1 + 1; 
  end if; 
end if; 
end process; 
 
process(rstb, div_clk, cnt_reg_2) 
begin 
if rstb = '0' then 
  cnt_reg_2 <= X"1"; 
elsif rising_edge(div_clk) then 
  if div_cnt = 33 then 
    cnt_reg_2 <= cnt_reg_2 + 1; 
  end if; 
end if; 
end process; 
 
process(rstb, div_clk, cnt_reg_3) 
begin 
  if rstb = '0' then 
    cnt_reg_3 <= X"2"; 
  elsif rising_edge(div_clk) then 
    if div_cnt = 33 then 
      cnt_reg_3 <= cnt_reg_3 + 1; 
    end if; 
  end if; 
end process; 
 
process(rstb, div_clk, cnt_reg_4) 
begin 
  if rstb = '0' then 
    cnt_reg_4 <= X"3"; 
  elsif rising_edge(div_clk) then 
    if div_cnt = 33 then 
      cnt_reg_4 <= cnt_reg_4 + 1; 
    end if; 
  end if; 
end process; 
 
 
 
-- 7-Segment Auto Increment Block 
process(cnt_reg_1) 
begin 
   if    seg_d( 3 downto 0) = X"0" then seg_reg_1 <= not X"C0"; 
   elsif seg_d( 3 downto 0) = X"1" then seg_reg_1 <= not X"F9"; 
   elsif seg_d( 3 downto 0) = X"2" then seg_reg_1 <= not X"A4"; 
   elsif seg_d( 3 downto 0) = X"3" then seg_reg_1 <= not X"B0"; 
   elsif seg_d( 3 downto 0) = X"4" then seg_reg_1 <= not X"99"; 
   elsif seg_d( 3 downto 0) = X"5" then seg_reg_1 <= not X"92"; 
   elsif seg_d( 3 downto 0) = X"6" then seg_reg_1 <= not X"82"; 
   elsif seg_d( 3 downto 0) = X"7" then seg_reg_1 <= not X"F8"; 
   elsif seg_d( 3 downto 0) = X"8" then seg_reg_1 <= not X"80"; 
   elsif seg_d( 3 downto 0) = X"9" then seg_reg_1 <= not X"90"; 
   elsif seg_d( 3 downto 0) = X"A" then seg_reg_1 <= not X"88"; 
   elsif seg_d( 3 downto 0) = X"B" then seg_reg_1 <= not X"83"; 
   elsif seg_d( 3 downto 0) = X"C" then seg_reg_1 <= not X"C6"; 
   elsif seg_d( 3 downto 0) = X"D" then seg_reg_1 <= not X"A1"; 
   elsif seg_d( 3 downto 0) = X"E" then seg_reg_1 <= not X"86"; 
   else  seg_reg_1 <= not X"8E";
         
end if;	 
end process; 
 
-- 7-Segment Auto Increment Block 
process(cnt_reg_2) 
begin 
   if seg_d( 7 downto 4)= X"0" then seg_reg_2 <= not X"C0"; 
elsif seg_d( 7 downto 4)= X"1" then seg_reg_2 <= not X"F9"; 
elsif seg_d( 7 downto 4)= X"2" then seg_reg_2 <= not X"A4"; 
elsif seg_d( 7 downto 4)= X"3" then seg_reg_2 <= not X"B0"; 
elsif seg_d( 7 downto 4)= X"4" then seg_reg_2 <= not X"99"; 
elsif seg_d( 7 downto 4)= X"5" then seg_reg_2 <= not X"92"; 
elsif seg_d( 7 downto 4)= X"6" then seg_reg_2 <= not X"82"; 
elsif seg_d( 7 downto 4)= X"7" then seg_reg_2 <= not X"F8"; 
elsif seg_d( 7 downto 4)= X"8" then seg_reg_2 <= not X"80"; 
elsif seg_d( 7 downto 4)= X"9" then seg_reg_2 <= not X"90"; 
elsif seg_d( 7 downto 4)= X"A" then seg_reg_2 <= not X"88"; 
elsif seg_d( 7 downto 4)= X"B" then seg_reg_2 <= not X"83"; 
elsif seg_d( 7 downto 4)= X"C" then seg_reg_2 <= not X"C6"; 
elsif seg_d( 7 downto 4)= X"D" then seg_reg_2 <= not X"A1"; 
elsif seg_d( 7 downto 4)= X"E" then seg_reg_2 <= not X"86"; 
else	seg_reg_2 <= not X"8E"; 
end if;	 
end process; 
 
-- 7-Segment Auto Increment Block 
process(cnt_reg_3) 
begin 
   if seg_d(11 downto 8) = X"0" then seg_reg_3 <= not X"C0"; 
elsif seg_d(11 downto 8) = X"1" then seg_reg_3 <= not X"F9"; 
elsif seg_d(11 downto 8) = X"2" then seg_reg_3 <= not X"A4"; 
elsif seg_d(11 downto 8) = X"3" then seg_reg_3 <= not X"B0"; 
elsif seg_d(11 downto 8) = X"4" then seg_reg_3 <= not X"99"; 
elsif seg_d(11 downto 8) = X"5" then seg_reg_3 <= not X"92"; 
elsif seg_d(11 downto 8) = X"6" then seg_reg_3 <= not X"82"; 
elsif seg_d(11 downto 8) = X"7" then seg_reg_3 <= not X"F8"; 
elsif seg_d(11 downto 8) = X"8" then seg_reg_3 <= not X"80"; 
elsif seg_d(11 downto 8) = X"9" then seg_reg_3 <= not X"90"; 
elsif seg_d(11 downto 8) = X"A" then seg_reg_3 <= not X"88"; 
elsif seg_d(11 downto 8) = X"B" then seg_reg_3 <= not X"83"; 
elsif seg_d(11 downto 8) = X"C" then seg_reg_3 <= not X"C6"; 
elsif seg_d(11 downto 8) = X"D" then seg_reg_3 <= not X"A1"; 
elsif seg_d(11 downto 8) = X"E" then seg_reg_3 <= not X"86"; 
else seg_reg_3  <= not X"8E"; 
end if;	 
end process; 
 
-- 7-Segment Auto Increment Block 
process(cnt_reg_4) 
begin 
   if seg_d(15 downto 12) = X"0" then seg_reg_4 <= not X"C0"; 
elsif seg_d(15 downto 12) = X"1" then seg_reg_4 <= not X"F9"; 
elsif seg_d(15 downto 12) = X"2" then seg_reg_4 <= not X"A4"; 
elsif seg_d(15 downto 12) = X"3" then seg_reg_4 <= not X"B0"; 
elsif seg_d(15 downto 12) = X"4" then seg_reg_4 <= not X"99"; 
elsif seg_d(15 downto 12) = X"5" then seg_reg_4 <= not X"92"; 
elsif seg_d(15 downto 12) = X"6" then seg_reg_4 <= not X"82"; 
elsif seg_d(15 downto 12) = X"7" then seg_reg_4 <= not X"F8"; 
elsif seg_d(15 downto 12) = X"8" then seg_reg_4 <= not X"80"; 
elsif seg_d(15 downto 12) = X"9" then seg_reg_4 <= not X"90"; 
elsif seg_d(15 downto 12) = X"A" then seg_reg_4 <= not X"88"; 
elsif seg_d(15 downto 12) = X"B" then seg_reg_4 <= not X"83"; 
elsif seg_d(15 downto 12) = X"C" then seg_reg_4 <= not X"C6"; 
elsif seg_d(15 downto 12) = X"D" then seg_reg_4 <= not X"A1"; 
elsif seg_d(15 downto 12) = X"E" then seg_reg_4 <= not X"86"; 
else	seg_reg_4 <= not X"8E"; 
end if;	 
end process; 
 
-- 출력시 Invert하여 출력할 것. 
--1 = X"F9";
--2 = X"A4";
--3 = X"B0";
--4 = X"99";
--5 = X"92";
--6 = X"82";
--7 = X"F8";
--8 = X"80";
--9 = X"90";
--A = X"88";
--B = X"83";
--C = X"C6";
--D = X"A1";
--E = X"86";
--F = X"8E";
--0 = X"C0"; 
-- 
 
end Behavioral; 
