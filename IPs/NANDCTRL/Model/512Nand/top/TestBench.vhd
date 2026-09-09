--        ____________________________________ 
--       /                                    |
--      |                                     |
--      |      __________________   __________|
--      |     |                 |   |
--       \     \                |   |   _______________________________________________________
--        \     \               |   |
--         \     \              |   |                                                
--          \     \             |   |                                                NAND512W3A   
--           \     \            |   |      
--            \     \           |   |                                               512Gbit (x8)       
--             \     \          |   |                    528 Byte Page, 3V, NAND Flash Memories
--              \     \         |   |       
--               \     \        |   |                                     VHDL Behavioral Model
--                |     \       |   |                                               Version 1.0
--                |     |       |   |                                               
--  ______________|     |       |   |                     Copyright (c) 2005 STMicroelectronics
-- |                    |       |   |  
-- |                    |       |   |  _________________________________________________________
-- |___________________/        |___|
-- 
-- 
-- ********************************************************************************************* 
-- 

LIBRARY IEEE;
    Use IEEE.std_logic_1164.all;

LIBRARY Work;
    Use work.def.all;
    Use work.data.all;

entity Top is
  begin
end Top;

architecture TestBench of top is

Component stimuli
port 
      (
      I_O : inout IObus_type;
      E_N, R_N, W_N, WP_N : out std_logic;
      AL, CL: out std_logic;
      Vss, Vdd: out real
      );
end component;

Component NANDxxxWxA
port
      (
      I_O : inout IObus_type;
      E_N, R_N, W_N, WP_N : in std_logic;
      AL, CL: in std_logic;
      RB_N  : out std_logic;
      Vss, Vdd  : in real
      );
end component;

  signal  I_O  : IObus_type;
  signal  E_N, R_N, W_N, WP_N  : std_logic;
  signal  AL, CL               : std_logic;
  signal  RB_N                 : std_logic;
  signal  Vss, Vdd             : real;     
 

begin

stim    : stimuli port map
                 (
                  I_O   => I_O, 
                  E_N   => E_N,  
                  R_N   => R_N, 
                  W_N   => W_N, 
                  WP_N  => WP_N,
                  AL    => AL,
                  CL    => CL,
                  Vss   => Vss,
                  Vdd   => Vdd 
                  );

DUT     : NANDxxxWxA
		port map
                 (
                 I_O   => I_O, 
                 E_N   => E_N, 
                 R_N   => R_N, 
                 W_N   => W_N, 
                 WP_N  => WP_N,
                 AL    => AL,
                 CL    => CL,
                 RB_N  => RB_N,
                 Vss   => Vss,
                 Vdd   => Vdd 
                 );

end TestBench;

