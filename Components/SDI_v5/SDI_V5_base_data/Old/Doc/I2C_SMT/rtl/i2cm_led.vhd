--------------------------------------------------------------------------------
-- TITLE :                 LED For Test 
-- FILE NAME :             i2cm_led.vhd
-- AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
-- ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
-- CREATED :               Februray 15, 2002
-- LAST UPDATED :          Februray 15, 2002
-- PLATFORM :              MS Windows 2000 professional
-- SIMULATOR :             ModelSim SE 5.5c
-- SYNTHESIZER :           Synplify pro 7.0
-- TARGET :                FPGA (ALTERA EPF10K10TC144-3)
-- DISCRIPTION :           This module defines LED For Test
-- REVISION NUMBER :       -
-- VERSION NUMBER :        1.0
-- DATE OF CHANGE :        -
-- MODIFIEER :             -
-- DESCRIPTION OF CHANGE : -
-- NOTICE :                -
--------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;
use IEEE.std_logic_unsigned.all ;


entity i2cm_led is
  port (
        clk     : in  std_logic ;
        rst_n   : in  std_logic ;

        tst_led : out std_logic
  ) ;
end i2cm_led ;


architecture rtl of i2cm_led is
  signal nco_register  : std_logic_vector (23 downto 0) ;
  signal nco_reg_msb_d : std_logic ;
  signal nco_toggle    : std_logic ;
  signal cnt           : std_logic_vector (3  downto 0) ;
  signal cnt_above_8   : std_logic ;
  signal tst_led_r     : std_logic ;
begin

NCO_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    nco_register  <= (others => '0') ;
    nco_reg_msb_d <= '0' ;
  elsif clk = '1' and clk'event then
    nco_register  <= nco_register + '1' ;
    nco_reg_msb_d <= nco_register (23) ;
  end if ;
end process ;

nco_toggle <= nco_reg_msb_d xor nco_register (23) ;

CNT_PROC : process (clk, rst_n, nco_toggle)
begin
  if rst_n = '0' then
    cnt <= (others => '0') ;
  elsif clk = '1' and clk'event then
    if nco_toggle = '1' then
      cnt <= cnt + '1' ;
    end if ;
  end if ;
end process ;

CNT_ABOVE_8_PROC : process (clk, rst_n, cnt)
begin
  if rst_n = '0' then
    cnt_above_8 <= '0' ;
  elsif clk = '1' and clk'event then
    if cnt = "1111" then
      cnt_above_8 <= '1' ;
    end if ;
  end if ;
end process ;

LED_PROC : process (clk, rst_n, cnt_above_8, nco_register)
begin
  if rst_n = '0' then
    tst_led_r <= nco_register (23) ;
  elsif clk = '1' and clk'event then
    if cnt_above_8 = '1' then
      tst_led_r <= '0' ;
    else
      tst_led_r <= nco_register (23) ;
    end if ;
  end if ;
end process ;

tst_led <= tst_led_r ;

end rtl ;
