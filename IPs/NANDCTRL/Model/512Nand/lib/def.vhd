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
-- generic definition for all VHDL model
LIBRARY IEEE;
    Use IEEE.std_logic_1164.all;

package def is 
  Constant HIGH     : Integer := 1;
  Constant LOW      : Integer := 0;
  Constant UNLOCKED : Std_Logic := '0';
  Constant LOCKED   : Std_Logic := '1';
  Constant BUSY     : Std_Logic := '0';
  Constant READY    : Std_Logic := '1';
  subtype  NIBBLE_range is Integer range 3 downto 0;
  Subtype  BYTE_range is Integer range 7 downto 0;
  Subtype  WORD_range is Integer range 15 downto 0;
  Subtype  HIGH_range is Integer range 15 downto 8;
  Subtype  LOW_range  is Integer range 7 downto 0;
  Constant BYTENP   : Integer := 16#FF#;
end;

