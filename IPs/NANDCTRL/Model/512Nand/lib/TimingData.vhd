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
-- Common Time Parameter and data types 
LIBRARY IEEE;
    Use IEEE.std_logic_1164.all;
LIBRARY Work;
    Use work.Def.all;
    Use Work.Userdata.all;

package TimingData is 

constant t_accessDim : natural := 2;         -- two access time
type timings is array(0 to t_accessDim - 1) of time;

constant StatusReg_cmd      : natural := 112;  -- 70h
constant ElectronicSign_cmd : natural := 144;  -- 90h

-----------  Table 25 - AC Characteristics for Command, Address, Data Input  ----------------------

constant tALLWL   : timings := (  0 ns,  0 ns);          -- Address Latch  Low to Write Enable Low
constant tALHWL   : timings := (  0 ns,  0 ns);          -- Address Latch High to Write Enable Low
constant tCLHWL   : timings := (  0 ns,  0 ns);          -- Command Latch High to Write Enable Low
constant tCLLWL   : timings := (  0 ns,  0 ns);          -- Command Latch  Low to Write Enable Low
constant tDVWH    : timings := ( 20 ns, 20 ns);          -- Data Valid to Write Enable High
constant tELWL    : timings := (  0 ns,  0 ns);          -- Chip Enable Low to Write Enable Low
constant tWHALH   : timings := ( 10 ns, 10 ns);          -- Write Enable High to Address Latch High
constant tWHCLH   : timings := ( 10 ns, 10 ns);          -- Write Enable High to Command Latch High
constant tWHCLL   : timings := ( 10 ns, 10 ns);          -- Write Enable High to Command Latch Low 
constant tWHDX    : timings := ( 10 ns, 10 ns);          -- Write Enable High to Data Transition
constant tWHEH    : timings := ( 10 ns, 10 ns);          -- Write Enable High to Chip Enable High
constant tWHWL    : timings := ( 20 ns, 15 ns);          -- Write Enable High to Write Enable Low
constant tWLWH    : timings := ( 40 ns, 25 ns);          -- Write Enable Low  to Write Enable High
constant tWLWL    : timings := ( 60 ns, 50 ns);          -- Write Enable Low  to Write Enable Low 

-----------  Table 26 - AC Characteristics for Operations  ----------------------

constant tALLRL1   : timings := (  10 ns,  10 ns);        -- Address Latch Low to Read Enable Low - Read Electronic Signature
constant tALLRL2   : timings := (  10 ns,  10 ns);        -- Address Latch Low to Read Enable Low - Read Cycle
constant tBHRL     : timings := (  20 ns,  20 ns);        -- Ready/Busy High to Read Enable Low
constant tBLBH1    : timings := (  15 us,  12 us);        -- Ready/Busy Low to Ready/Busy High - Read Busy time
constant tBLBH2    : timings := ( 500 us, 500 us);        -- Ready/Busy Low to Ready/Busy High - Program Busy time
constant tBLBH3    : timings := (   3 ms,   3 ms);        -- Ready/Busy Low to Ready/Busy High - Erase Busy time
constant tBLBH4    : timings := (   5 us,   5 us);        -- Ready/Busy Low to Ready/Busy High - Reset Busy time, during ready
constant tBLBH5    : timings := (   3 us,   3 us);        -- Ready/Busy Low to Ready/Busy High - Cache Busy time
constant tWHBH1_1  : timings := (   5 us,   5 us);        -- Write Enable High to Ready/Busy High - Reset Busy time, during read 
constant tWHBH1_2  : timings := (  10 us,  10 us);        -- Write Enable High to Ready/Busy High - Reset Busy time, during program 
constant tWHBH1_3  : timings := ( 500 us, 500 us);        -- Write Enable High to Ready/Busy High - Reset Busy time, during erase 
constant tCLLRL    : timings := (  10 ns,  10 ns);        -- Command Latch Low to Read Enable Low
constant tDZRL     : timings := (   0 ns,   0 ns);        -- Data Hi-Z to Read Enable Low
constant tEHBH     : timings := (  90 ns, 300 ns);        -- Chip Enable High to Ready/Busy High
constant tEHEL     : timings := ( 100 ns, 100 ns);        -- Chip Enable High to Chip Enable Low 
constant tEHQZ     : timings := (  20 ns,  20 ns);        -- Chip Enable High to Output Hi-Z 
constant tELQV     : timings := (  45 ns,  45 ns);        -- Chip Enable Low to Output Valid
constant tRHBL     : timings := ( 100 ns, 100 ns);        -- Read Enable High to Ready/Busy Low
constant tRHRL     : timings := (  15 ns,  15 ns);        -- Read Enable High to Read Enable Low 
constant tRHQZ_min : timings := (  15 ns,  15 ns);        -- Read Enable High to Output Hi-Z
constant tRHQZ_max : timings := (  30 ns,  30 ns);        -- Read Enable High to Output Hi-Z
constant tRHQZ     : timings := (  30 ns,  30 ns);        -- Read Enable High to Output Hi-Z  -- max value
constant tRLRH     : timings := (  30 ns,  30 ns);        -- Read Enable Low to Read Enable High
constant tRLRL     : timings := (  60 ns,  50 ns);        -- Read Enable Low to Read Enable Low
constant tRLQV     : timings := (  35 ns,  35 ns);        -- Read Enable Low to Output Valid
constant tWHBH     : timings := (  15 us,  12 us);        -- Write Enable High to Ready/Busy High 
constant tWHBL     : timings := ( 100 ns, 100 ns);        -- Write Enable High to Ready/Busy Low
constant tWHRL     : timings := (  60 ns,  60 ns);        -- Write Enable High to Read Enable Low

----------  Table 31 - Reset and Power-up AC Characteristics  -------------------

constant tPLXX_Load    : timings := (  50 us,  50 us);    -- Data Valid to Chip Enable High
constant tPLXX_Program : timings := (  50 us,  50 us);    -- Chip Enable High to Input Transition
constant tPLXX_Erase   : timings := ( 100 us, 100 us);    -- Chip Enable High to Chip Enable Low
constant tPLXX_Idle    : timings := (  80 ns,  80 ns);    -- Chip Enable High to Latch Enable Low

constant tPLPH   : timings := (  50 ns,  50 ns);          -- Latch Enable Pulse Width
 
-- ======== Long Time value ====== --
Constant READ_BUSY_time          : time := tBLBH1(TimeIndex_dev);  
Constant PROGRAM_time            : time := tBLBH2(TimeIndex_dev);     
Constant ERASE_time              : time := tBLBH3(TimeIndex_dev); 
Constant RESET_time              : time := tBLBH4(TimeIndex_dev);
Constant CACHE_BUSY_time       : time := tBLBH5(TimeIndex_dev); 

Constant POWERUP_time            : time := 1030 ns;

end;

----------------------------------------------------------------------------------------------------
