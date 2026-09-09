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
package UserData is
-- ************************************ 
--
-- User Data definition file :
--
--      here are defined all parameters
--      that the user can change
--
-- ************************************ 
type DeviceName_type is (
                          NAND128R3A, NAND128W3A, NAND128R4A, NAND128W4A, 
                          NAND256R3A, NAND256W3A, NAND256R4A, NAND256W4A, 
                          NAND512R3A, NAND512W3A, NAND512R4A, NAND512W4A, 
                          NAND01GR3A, NAND01GW3A, NAND01GR4A, NAND01GW4A
                         );

type SizeDev_type is (NAND128Mbit, NAND256Gbit, NAND512Gbit, NAND01Gbit);
                                           
-- *********** Device Characteristics *********** --
Constant DeviceName : DeviceName_type :=  NAND512W3A; 
        -- Possible value are:
--               NAND128R3A
--		 NAND128W3A                         
--		 NAND128R4A
--		 NAND128W4A
--		 
--		 NAND256R3A
--		 NAND256W3A
--		 NAND256R4A
--		 NAND256W4A
--		 
--		 NAND512R3A
--		 NAND512W3A
--		 NAND512R4A
--		 NAND512W4A
--		 
--		 NAND01GR3A
--		 NAND01GW3A
--		 NAND01GR4A
--		 NAND01GW4A
--			



Constant IOBusWidth_dev   : Natural := 8;     -- Architecture 8 bit
Constant PageSize_dev     : Natural := 528;   -- 512 Byte + 16
Constant ColumnSize_dev   : Natural := 256;   -- 2048 for 8 bit; 1024 for 16 bit
Constant BlockSize_dev    : Natural := 32768;  -- Size of Block
Constant BlockDim_dev     : Natural := 4096;   -- Num of Block 
Constant VddMin_dev       : real    := 2.7;
Constant VddMax_dev       : real    := 3.6;
-- Parameter Deduced
Constant mode16bit        : Boolean := false;
Constant AddrBusCycle_dev : Natural := 4;     -- number of Bus Cycle for Address Latch
Constant AddressWidth_dev : Natural := 26;    -- address bit number
Constant InternalAddressWidth_dev : Natural := 27;    -- address bit number

Constant TimeIndex_dev    : Natural := 1;     -- Value 0 or 1 depend of Vdd
                                              --  1.7 <= Vdd <= 1.95 TimeIndex_dev must be set to 0
                                              --  2.7 <= Vdd <= 3.6  TimeIndex_dev must be set to 1


Constant Size_dev : SizeDev_type := NAND512Gbit;
Subtype ColumnAddress_range  is Integer range 7 downto 0;
Subtype PageAddress_range  is Integer range 25 downto 9;
Subtype BlockAddress_range  is Integer range 25 downto 14;
Subtype AddressInBlock_range  is Integer range 13 downto 9;

Subtype InternalPageAddress_range  is Integer range 26 downto 10;
--Spare Area
Constant SpareAddressWidth_dev : Natural := 4;    -- address bit number for spare area 
subtype  SpareAddress_range  is Integer range SpareAddressWidth_dev-1 downto 0;

-- *********************************** --
         
Constant BLOCKPROTECT : Boolean := true;                -- if true all blocks are locked at power-up
Constant TimingChecks : Boolean := true;                -- true for checking timing constraints

end UserData;
