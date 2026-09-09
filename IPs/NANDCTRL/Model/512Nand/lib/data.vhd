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
-- common parameter and data types 
LIBRARY IEEE;
    Use IEEE.std_logic_1164.all;
    Use IEEE.std_logic_unsigned.all;
LIBRARY Work;
    Use work.def.all;
    use work.UserData.all;
    
package data is 

  Constant IObus_Dim        : natural := IOBusWidth_dev; -- IO bus dimension 
  Subtype  IObus_range      is Integer range IObus_Dim - 1  downto 0;
  Subtype  IObus_type       is  Std_Logic_vector(IObus_range);
  
  Constant DataBus_Dim      : natural := IOBusWidth_dev; -- data dimension 
  Subtype  DataBus_range    is Integer range DataBus_Dim - 1  downto 0;
  SubType  DataBus_type     is Std_Logic_Vector(DataBus_range);

  Constant Address_Dim      : natural := AddressWidth_dev; -- address dimension 
  Subtype  Address_range    is Natural range Address_Dim - 1  downto 0;
  Subtype  Address_type     is  Std_Logic_Vector(Address_range);

  Constant InternalAddress_Dim      : natural := InternalAddressWidth_dev; -- address dimension 
  Subtype  InternalAddress_range    is Natural range InternalAddress_Dim - 1  downto 0;
  Subtype  InternalAddress_type     is Std_Logic_Vector(InternalAddress_range);


  Constant CommandBus_Dim   : natural := 8; -- Command dimension 
  Subtype  CommandBus_range is Natural range CommandBus_Dim - 1  downto 0;
  Subtype  CommandBus_type  is  Std_Logic_Vector(CommandBus_range);

  SubType  Data16_type   is Std_Logic_vector(WORD_range);
  SubType  Data8_type    is Std_Logic_vector(BYTE_range);
  
  subtype  DataReg_type  is bit_vector(BYTE_range);

  -- Declare for memory storage
  Constant DataMem_dim  : natural := IOBusWidth_dev;
  Constant AddrMem_dim  : natural := AddressWidth_dev;  
  subtype  DataMem_range is Natural range DataMem_dim - 1 downto 0;
  Constant Memory_Dim   : natural := 2**InternalAddressWidth_dev;     -- memory dimension
  Constant Last_Addr    : natural := Memory_Dim -1;
  Subtype  DataMem_type is bit_vector(DataMem_range);
  Subtype  AddrMem_type is Natural range 0 to Memory_Dim - 1;
 
  type DataMemVector_type is array(1 to BlockDim_dev) of DataMem_type;

  SubType  String30     is String(1 to 30);

--------- DC Parameters ----------------------------------------------------
Constant Vdd_low : real := 1.7;
Constant Vdd_high : real := 2.0;
Constant Vddq_low : real := 1.7;
Constant Vddq_high : real := 2.0;

Constant Vpp1_low : real := 1.3;
Constant Vpp1_high : real := 2.4;

Constant Vpph_low : real := 8.5;
Constant Vpph_high : real := 9.5;
----------------------------------------------------------------------------
  Type AddrBoundary_type is record 
       addrStart: AddrMem_type;
       addrEnd: AddrMem_type;
  End Record;

  type activity_type is (free, in_load, in_program);
  
type message_type is ( NoError_msg, CmdSeq_msg, SuspCmd_msg, SuspAcc_msg , InvAddrRange_msg,
                       AddrTog_msg, BuffSize_msg, SuspAccWarn_msg, 
                       InvVDD_msg, InvVPP_msg,
                       BlockLockError_msg, BlockLockDown_msg, LockModeError_msg,
                       ByteToggle_msg, BlkBuffer_msg, AddrCFI_msg, PreProg_msg, NoBusy_msg,
                       NoSusp_msg, Suspend_msg, UDNlock_msg, UPlock_msg,
                       Busy_msg, PRegPreProg_msg,                        NoOPallowed_msg, NoOPSameBlock_msg, NoOPguaranteed_msg, -- for Multiple Bank
                       WrongReg_msg,   -- Error -- Register Address Error -- Register not found
                       NoRegWrite_msg, -- Error -- is not possible write in this register
                       NoRegRead_msg,  -- Error -- is not possible Read in this register
                       InvDataUnitCount_msg,   -- Error -- invalid Data Unit Count in Start Buffer Register
                       InvPartialDataUnit_msg, -- ???Warning??? -- invalid Partial Data Unit from command
                       ResetInLoad_msg,    -- Error -- Reset down in Load Operation
                       ResetInReadAll1_msg,    -- Error -- Reset down in Read All 1 Operation
                       ResetInErase_msg,    -- Error -- Reset down in Erase Operation
                       ResetInProgram_msg,  -- Error -- Reset down in Program Operation
                       BlockAddrError_msg,  -- Error -- the Start Block Address is greater than the End Block Address 
                       StartBlockRegOutOfBound_msg,  -- Warning -- Start Block Address Register Out of Bound
                       EndBlockRegOutOfBound_msg,    -- Warning -- Start Block Address Register Out of Bound
                       NoUnLockBlock_msg,   -- Warning -- Invalid Lock Block operation in Locked-Down Block
                       NoLockBlock_msg,     -- Warning -- Invalid UnLock Block operation in Locked-Down Block
                       NoLockDownBlock_msg, -- Warning -- Invalid Lock-Down Block operation in Unlocked Block
                       InvReadID_msg,       -- Warning -- Invalid Read ID Address 
                       OTPlock_msg, resetCDI_msg,   -- Added by GT
                       GENERIC_ERROR_msg    -- Errore Generico
                     );  

-- ---------- CUI Status --------------- --
 
-- ----- Read Bus Status Operation ----  --
  Type ReadModeName_type is ( ReadArray_status,  RandomDataOutput_status, RandomDataInput_status, CacheRead_status, 
                                 ReadElectSignature_status, ReadStatusReg_status, ReadBlockLock_status
                            );
   Type ReadMode_type is record
        Mode: ReadModeName_type;
        eventTime  : time;
   End record;
   Type vectorReadMode_type is array (Integer range <>) of ReadMode_type;
 
  type ProgramMode_type is (none_mode, PageProgram_mode, CacheProgram_mode, CopyBackProgram_mode);
  
-- Device Status
  Type Status_type is Record
        Busy      : Boolean;
        ProgramMode  : ProgramMode_type; 
        --Suspended : Boolean;
        message   : Message_type;
        isError   : Boolean; 
        successful : Boolean; 
  End Record;

-- === Declaration for Kernel and CUI decoder === -- 
  type KernelReport_type is record 
       status : message_type;
       eventTime : time;
  end record;
  type vectorKernelReport_type is array (Integer range <>) of KernelReport_type;

 
  SubType Event is boolean;

  SubType ErrorEvent is Std_Logic;
  Type vectorErrorEvent_type is array (Integer range <>) of ErrorEvent;


  SubType TimeEvent is Time;
  Type vectorTimeEvent_type is array (Integer range <>) of TimeEvent;
 
  SubType IndexCommand_type is Integer;
  Type vectorIndexCommand_type is array (Integer range <>) of IndexCommand_type;

-- === Output Buffer === --
type BufferTaskName_type is (setDataValid, SetDataX, SetDataZ);
type BufferTask_type is record
        task: BufferTaskName_type;
        putTime: time;
        eventTime : time;
end record;
Type vectorBufferTask_type is array (Integer range <>) of BufferTask_type;
-- === Read Array 
type ReadTaskName_type is (none, Cache, RandomDataOutput, ReadArray, ReadInCacheProgram);
type ReadTask_type is record
        Task      : ReadTaskName_type;
        Address   : Address_type;
        EventTime : time;
end record;
Type vectorReadTask_type is array (Integer range <>) of ReadTask_type;

-- === Page Buffer === --
type PointerName_type is (AreaA, AreaB, AreaC);
Constant IndexAreaA : Natural := 0;
Constant LenAreaA   : Natural := 256;
Constant EndAreaA   : Natural := 255;

Constant IndexAreaB : Natural := 256;
Constant LenAreaB   : Natural := 256;
Constant EndAreaB   : Natural := 511;

Constant IndexAreaC : Natural := 512;
Constant LenAreaC   : Natural := 16;
Constant EndAreaC   : Natural := 527;


Constant PageBuffer0 : Natural := 0;
Constant PageBuffer1 : Natural := 1;
Constant PageBuffer2 : Natural := 2;
Constant PageBuffer3 : Natural := 3;
Constant PageBuffer_dim : Natural := 4;
Constant nPage       : Natural := 64;
type PageBuffer_type is array (0 to PageSize_dev - 1) of DataMem_type;
type PageBufferTaskName_type is (none, SetPointer, ResetLen, GetData, PutData, PutAllData, PutAllDataToMemory, PutDataToMemory, ResetIndex, SetIndex, PutDataFromMemory, PutAllDataFromMemory, PutMemAddress);
type PageBufferTask_type is record
        task: PageBufferTaskName_type;
        nPage : Natural;
        alldata: PageBuffer_type;
        data: DataMem_type;
        Index : Natural range 0 to PageSize_dev - 1;
        IndexArea : Natural range 0 to PageSize_dev - 1;
        LenArea :Natural range 0 to PageSize_dev - 1; 
        EndArea :Natural range 0 to PageSize_dev - 1; 
        MemAddress : Natural;
        PointerName : PointerName_type;
        eventTime : time;
end record;
Type vectorPageBufferTask_type is array (Integer range <>) of PageBufferTask_type;

-- === Memory === --
Constant MemBufferSize_dim : Natural := PageSize_dev;
type MemBuffer_type is array (0 to MemBufferSize_dim - 1) of DataMem_type;
type MemTaskName_type is (none, init, put, get, BlockErase, getBlock, putBlock, ReadIFall1, load, save, printList, printData);
     type MemoryTask_type is record
         task     : MemTaskName_type;
         data     : DataMem_type;
         address  : AddrMem_type;
       addressEnd : AddrMem_type;
         MemBuffer: MemBuffer_type;
         isAll1   : Boolean;
       eventTime  : time;
     end record;
Type vectorMemoryTask_type is array (Integer range <>) of MemoryTask_type;


-- === Program === --        
Type ProgTaskName_type is (none, PageProgram, CacheProgram, CopyBackProgram);
     type ProgramTask_type is record
        task          : ProgTaskName_type;
        Address       : AddrMem_type;
        PageBuffer    : Natural; 
        eventTime     : time;
     end record;    
Type vectorProgramTask_type is array (Integer range <>) of ProgramTask_type;


type EraseTaskName_type is (none, BlockErase);   
constant BKEsetup_code   : natural := 16#60#;
constant BKEconfirm_code : natural := 16#D0#;

type EraseTask_type is record
        task            : EraseTaskName_type;
        BlockNumber      : Natural; 
        eventTime       : time;
end record;


Type vectorEraseTask_type is array (Integer range <>) of EraseTask_type;

---------------------------
-- Electronic Signature  --
---------------------------
--Constant NumDifferent_dev : natural := 20;

Subtype DeviceName_range is DeviceName_type range NAND128R3A to NAND01GW4A;

type SignatureTab_type is array ( DeviceName_range, 0 to 1) of DataMem_type;
  
Constant SignatureTab : SignatureTab_type :=    -- Table 12 Pg. 27
   
  --  Device Code   Byte/Word 4  --
   ( (    X"33"  ,   X"15"  ),
     (    X"73"  ,   X"15"  ),
     (    X"43"  ,   X"40"  ),
     (    X"53"  ,   X"40"  ),
     (    X"35"  ,   X"15"  ),
     (    X"75"  ,   X"15"  ),
     (    X"45"  ,   X"40"  ),
     (    X"55"  ,   X"40"  ),
     (    X"36"  ,   X"15"  ),
     (    X"76"  ,   X"15"  ),
     (    X"46"  ,   X"40"  ),
     (    X"56"  ,   X"40"  ),
     (    X"39"  ,   X"15"  ),
     (    X"79"  ,   X"15"  ),
     (    X"49"  ,   X"40"  ),
     (    X"59"  ,   X"40"  )
   );

  
 -- ===================================

Type SignatureData_type is record
     Device                   : DeviceName_type;
     ManufacturerCode         : DataMem_type;
     DeviceCode               : DataMem_type;  
     ThirdColumn              : DataMem_type;
     FourthColumn             : DataMem_type;
End Record;
Type vectorSignatureData_type is array (Integer range <>) of SignatureData_type;


-- =====================================================================
Constant SR_dim: natural := 4;

--Type SRregVett_type is array(SR_dim - 1 downto 0) of DataReg_type;

Type StatusRegisterTaskName_type is (none, Clear, Read, UpDateRegister);
     Type StatusRegisterTask_type is record
          task          : StatusRegisterTaskName_type;
          SR            : DataReg_Type;
          --SRvett        : SRregVett_type;
          eventTime     : time;
     End Record;
Type vectorStatusRegisterTask_type is array (Integer range <>) of StatusRegisterTask_type;


end data;
