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
   Use work.Def.all;
   Use work.UserData.all;
   Use work.Data.all;
   use work.StringLib.all;
   use work.CUIcommandData.all;

Package BlockLib is

  Constant Block_Dim : Natural := BlockDim_dev;  
  
-- Block Protection

  subtype lock_range is Natural range 2 downto 0;
  SubType Lock_type is bit_vector(2 downto 0);       -- lock_range);

  Constant UNLOCK       : Lock_type   := "110";
  Constant LOCK         : Lock_type   := "010";
  Constant LOCKDOWN     : Lock_type   := "001";
  Constant UNLOCKDOWN   : Lock_type   := "101";

  Constant first_block : Natural := 0;
  Constant last_block : Natural := Block_Dim - 1;

  -- position of first bit for Block Address
  Constant LastAddrBlock_flag : Natural := 5;
  -- position of last bit for Block Address
  Constant FirstAddrBlock_flag : Natural := 0;

  SubType  BlockDim_range is integer range last_Block downto first_Block;

  Constant Bank_dim : Natural := 1;
  SubType BankDim_range is Natural range 0 to bank_dim - 1;

  -- Numero di Blocchi con dimensioni diverse per ogni Bank
  Constant variousBlock_bank : Natural := 1;
  
  --  Numero di righe della tabella dei Bank
  SubType blockBank_range  is Natural range 0 to variousBlock_bank * 2; 
  
  -- tabella dei Bank
  type BankArchitecture_type is array ( 0 to Bank_Dim, blockBank_range) of Natural;
  
  Constant BankArchitecture : BankArchitecture_type :=
  --  | Bank Size |         Type Block no.1       |        Type Block no.2         | ... |
  --  |           | No. of Blocks  | Block Size   |  No. of Blocks  | Block Size   | ... |
  --  |   Mbit    |    number      |  kword       |     number      |   kword      | ... |
 
     (  (1024      ,      Block_Dim,     BlockSize_dev/1024      ),(0,0,0));

  Type BlockBoundary_Type is array (BlockDim_range) of AddrBoundary_type;

  Signal BlockBoundary : BlockBoundary_type;


  Type BlockLockTaskName_type is (none, getStatusByAddress, getStatusByBlock, putLock, putUnLock, putLockDown);
     type BlockLockTask_type is record
        task            : BlockLockTaskName_type;
        currentStatus   : Lock_type;                 -- there are 4 states : Locked, Unlocked, Locked-down, Unlocked in Locked-down area
        startBlock      : BlockDim_range;
        endBlock        : BlockDim_range;
        address         : AddrMem_type;
        isUnLocked      : Boolean;
        eventTime       : time;
     end record;
Type vectorBlockLockTask_type is array (Integer range <>) of BlockLockTask_type;

  
-------------------------------------------------------------------------------------
  Procedure initBlock(Signal BlockBoundary: out BlockBoundary_type);

  Function  getBlock(BlockBoundary:BlockBoundary_type;  Address: AddrMem_type) Return  BlockDim_range;
  Procedure getBoundaryBlock(b: out AddrBoundary_type; Index: out BlockDim_range; BlockBoundary: BlockBoundary_type; Address: AddrMem_type);
  Function getAddrBlockStart(BlockBoundary:BlockBoundary_type; Address: AddrMem_type) Return AddrMem_Type;
  Function getAddrBlockEnd(BlockBoundary:BlockBoundary_type; Address: AddrMem_type)   Return AddrMem_Type;

  Function getAddrBlockStartbyNumber(BlockBoundary:BlockBoundary_type;i:BlockDim_range) Return AddrMem_Type;
  Function getAddrBlockEndbyNumber(BlockBoundary:BlockBoundary_type;i:BlockDim_range)   Return AddrMem_Type;

  
  ---------------------------------------------------------------------------------------------------
  
  ----------  Function getBlockNumber: from the address return the number of the block  ------------- 
  
  ---------------------------------------------------------------------------------------------------
  
  Function getBlockNumber(BlockBoundary: BlockBoundary_type; Address: AddrMem_type) Return BlockDim_range;

  
End BlockLib;


Package body BlockLib is 

Procedure  getBoundaryBlock(b: out AddrBoundary_type; Index: out BlockDim_range; BlockBoundary:BlockBoundary_type; Address: AddrMem_type) is  
  Variable i: BlockDim_range;  
  begin 
    i := first_block;

    while (i <= Block_Dim - 1 and (Address > (BlockBoundary(i).AddrEnd))) loop
     
              i := i + 1;
              --printString("i = " & int2str(i) & "  ");
    end loop;
    
    Index := i;
    b.AddrStart := BlockBoundary(i).AddrStart;
    b.AddrEnd   := BlockBoundary(i).AddrEnd;

  end getBoundaryBlock;

Function  getBlock(BlockBoundary:BlockBoundary_type;  Address: AddrMem_type) Return  BlockDim_range is 
   Variable i: BlockDim_range; 
   begin 
    i := first_block;
    while (i < Block_Dim and (Address > (BlockBoundary(i).AddrEnd))) loop
              i := i + 1;
    end loop;
    if i = Block_dim then printString("+++ General Error +++ Check Source: getBlock in BlockLib"); return 0; 
                     else Return i;
    end if;
end getBlock;



Procedure initBlock(Signal BlockBoundary: out BlockBoundary_type) is 

     Variable j: Natural; 
     Variable ibank : Natural;

     Variable nBlockStart, nBlockEnd , dimBlock :Integer ;
     variable i_addrBlock : Integer;
     Variable addrBlock : BlockBoundary_Type;

  begin 

       -- initalize  Block and Bank 
       nBlockStart := first_block;
       i_addrBlock:=0;
       iBank:= 0;
                 
       for j in 0 to variousBlock_bank - 1 loop
       
               nBlockEnd := nBlockStart + BankArchitecture(iBank, j * 2 + 1) - 1;
               dimBlock := BankArchitecture(iBank, j * 2 + 2) * 1024;
               
               if dimBlock > 0 then 
                  
                  for iBlock in nBlockStart to nBlockEnd loop
               
                     addrBlock(iBlock).addrStart := i_addrBlock;
                     addrBlock(iBlock).addrEnd := i_addrBlock + dimBlock - 1;
                     i_addrBlock := i_addrBlock + dimBlock;
               
                  end loop;
               
               end if;   
               nBlockStart := nBlockEnd + 1;
           end loop;
  BlockBoundary <= addrBlock;

  end initBlock;

  Function getAddrBlockStart(BlockBoundary: BlockBoundary_type; Address: AddrMem_type) Return AddrMem_Type is 
  Variable i : BlockDim_range;
  Variable b : AddrBoundary_type;
  Begin 
  
    getBoundaryBlock(b, i, BlockBoundary, Address);
    return b.Addrstart;
  
  End getAddrBlockStart;

  Function getAddrBlockEnd( BlockBoundary:BlockBoundary_type; Address: AddrMem_type) Return AddrMem_Type is
  
  Variable i : BlockDim_range;
  Variable b : AddrBoundary_type;
  Begin 
  
    getBoundaryBlock(b, i, BlockBoundary, Address);
    return b.AddrEnd;
  
  end getAddrBlockEnd;

  Function getAddrBlockStartbyNumber( BlockBoundary:BlockBoundary_type; i:BlockDim_range) return AddrMem_type is 
  Begin
    return BlockBoundary(i).AddrStart;
  end getAddrBlockStartbyNumber;
   
  Function getAddrBlockEndbyNumber( BlockBoundary:BlockBoundary_type; i:BlockDim_range) return AddrMem_type is 
  Begin
    return BlockBoundary(i).AddrEnd;
  end getAddrBlockEndbyNumber;
 
  
  Function getBlockNumber(BlockBoundary:BlockBoundary_type; Address: AddrMem_type) Return BlockDim_range is
  
  Variable i : BlockDim_range;
  Variable b : AddrBoundary_type;
  Begin
  
    getBoundaryBlock(b, i, BlockBoundary, Address);
    Return i;
 
  End getBlockNumber;

end BlockLib;
