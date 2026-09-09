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
-------------------------------------------------------------------------------
--                         TIME MANAGER                                      --
-------------------------------------------------------------------------------
Library IEEE;
  Use IEEE.std_logic_1164.all;
  Use IEEE.Std_Logic_signed.all;
  
Library Work;
  Use work.Def.all;
  Use work.Data.all;
  use work.TimingData.all;
  Use work.StringLib.all;
  Use work.UserData.all;

Entity TimingCheck_entity is 
  port(  
        I_O             : in   IObus_type;
        E_N             : in   std_logic;
        R_N             : in   std_logic;
        W_N             : in   std_logic;
        AL              : in   std_logic;
        CL              : in   std_logic;
        WP_N            : in   std_logic;
        Ready_busy      : in   std_logic;

        timingCheck_on  : in boolean
     );

End TimingCheck_entity;


Architecture behavior of TimingCheck_entity is 
signal TimeIndex_dev : natural;
signal Data_Bus : DataBus_type;              -- DataBus is ADQ when ADQ contain a data


Function is_DataValid(D: IObus_type) Return boolean is

variable i: Integer;

Begin 

   for i in 0 to IOBus_dim - 1 loop 

        if (D(i) /= '1') and (D(i) /= '0') then return false;             -- Data not valid (X, Z, U, ...)
        end if;

   end loop;     

   return true;

end Function; 


Function is_DataXX(D: IOBus_type) Return boolean is

variable i: Integer;

Begin 

   for i in 0 to IOBus_dim - 1 loop 

        if (D(i) /= 'X') then return false;                              -- Data not XXX...XX 
        end if;

   end loop;     

   return true;

end Function; 


Function is_DataHZ(D: IOBus_type) Return boolean is

variable i: Integer;

Begin 

   for i in 0 to IOBus_dim - 1 loop 

        if (D(i) /= 'Z') then return false;                              -- Data not Hi-Z 
        end if;

   end loop;     

   return true;

end Function; 

 signal timeWL        : time := 0 ns;          -- W_N Low time
 signal timeWH        : time := 0 ns;          -- W_N High time
 signal timeEL        : time := 0 ns;          -- E_N Low time
 signal timeGL        : time := 0 ns;          -- G_N Low time
 signal timeEH        : time := 0 ns;          -- E_N High time
 signal timeGH        : time := 0 ns;          -- G_N High time
 signal timeDV        : time := 0 ns;          -- Data Valid time

 begin
 
  -----------------------------------
  --   TIMING CHECK PROCESS
  -----------------------------------

  timingCheck_process : Process 

  variable DataValid_time       : time    := 0 ns;
  variable DataXX_time          : time    := 0 ns;
  variable DataHZ_time          : time    := 0 ns;
  variable AddLatchLow_time     : time    := 0 ns;
  variable AddLatchHigh_time    : time    := 0 ns;
  variable CmdLatchLow_time     : time    := 0 ns;
  variable CmdLatchHigh_time    : time    := 0 ns;
  variable EnableLow_time       : time    := 0 ns;
  variable EnableHigh_time      : time    := 0 ns;
  variable WriteLow_time        : time    := 0 ns;
  variable WriteHigh_time       : time    := 0 ns;
  variable ReadLow_time         : time    := 0 ns;
  variable ReadHigh_time        : time    := 0 ns;
  variable BusyLow_time         : time    := 0 ns;
  variable BusyHiZ_time         : time    := 0 ns;

  variable reading              : boolean := false;
  variable writing              : boolean := false;
  variable readStatusReg_op     : boolean := false;
  variable readElectSign_op     : boolean := false;

  variable checkWL              : boolean := false;

  begin
  
        wait until (I_O'event or CL'event or AL'event or W_N'event or E_N'event or R_N'event or Ready_Busy'event);

        if (now >= Reset_time and timingCheck_on) then

        -------------------------
        ----  I_O event
        -------------------------

        if I_O'event then 
                
               if is_DataValid(I_O) then 
                
                        if R_N = '0' then 
                                
                                assert (now - ReadLow_time <= tRLQV(TimeIndex_dev))          -- max value
                                report "(Read Enable Low to Data Valid (tRLQV) !!)"
                                severity warning;

                                if readStatusReg_op and EnableLow_time > 0 ns then 
                                
                                        assert (now - EnableLow_time <= tELQV(TimeIndex_dev))          -- max value
                                        report "(Chip Enable Low to Data Valid (tELQV) !!)"
                                        severity warning;

                                        readStatusReg_op := false;
                                end if;        

                        elsif W_N = '0' then 
                        
                                if I_O = StatusReg_cmd then 
                                        
                                        readStatusReg_op := true;
                                        readElectSign_op := false;
                                
                                elsif I_O = ElectronicSign_cmd then 
                                        
                                        readElectSign_op := true;
                                        readStatusReg_op := true;

                                else 
                                        readStatusReg_op := false;
                                        readElectSign_op := false;
                                 
                                end if;

                        end if;
                        
                        DataValid_time := now;

                else    -- Data not Valid
                        
                        if R_N = '1' then 
                                
                                assert (now - WriteHigh_time >= tWHDX(TimeIndex_dev))          -- min value
                                report "(Write Enable High to Data Transition (tWHDX) !!)"
                                severity warning;
                        end if;        

                        if is_DataXX(I_O) then DataXX_time := now;
                        
                        else 
                                if is_DataHZ(I_O) and (reading) then 
                                
                                        assert ( (now - ReadHigh_time >= tRHQZ_min(TimeIndex_dev)) and
                                                 (now - ReadHigh_time <= tRHQZ_max(TimeIndex_dev)))        -- min value
                                        report "(Read Enable High to Data Hi-Z (tRHQZ) !!)"
                                        severity warning;
                                        
                                        assert (now - EnableHigh_time >= tEHQZ(TimeIndex_dev)) 
                                        report "(Chip Enable High to Data Hi-Z (tEHQZ) !!)"
                                        severity warning;

                                        DataHZ_time := now;
                                end if;
                        end if;
                end if;
        end if;

        
        --------------------
        ---   CL event   ---
        --------------------

        if CL'event then

                if CL = '1' then
        
                        if AL = '0' then
                        
                                assert (now - WriteHigh_time >= tWHCLH(TimeIndex_dev))          -- min value
                                report "(Write Enable High to Command Latch Low valid time violation (tWHCLH) !!)"
                                severity warning;
                        end if;
                        
                        CmdLatchHigh_time := now;

                elsif CL = '0' then

                        assert (now - WriteHigh_time >= tWHCLL(TimeIndex_dev))          -- min value
                        report "(Write Enable High to Command Latch Low valid time violation (tWHCLL) !!)"
                        severity warning;

                        CmdLatchLow_time := now;

                end if;

        end if;

        --------------------
        ---   AL event   ---
        --------------------

        if AL'event then

                if AL = '1' then

                        assert (now - WriteHigh_time >= tWHALH(TimeIndex_dev))          -- min value
                        report "(Write Enable to Write Enable High valid time violation (tWHALH) !!)"
                        severity warning;

                        AddLatchHigh_time := now;

                elsif AL = '0' then

                        checkWL := true;   -- control enable on tALLWL

                        if CL = '0' then  -- not in command latch


                        end if;

                        AddLatchLow_time := now;

                end if;

        end if;

        ---------------------
        ---   W_N event   ---
        ---------------------

        if W_N'event then

                if W_N = '1' then

                        assert (now - DataValid_time >= tDVWH(TimeIndex_dev))          -- min value
                        report "(Data Valid to Write Enable High valid time violation (tDVWH) !!)"
                        severity warning;

                        assert (now - WriteLow_time >= tWLWH(TimeIndex_dev))          -- min value
                        report "(Write Enable to Write Enable High valid time violation (tWLWH) !!)"
                        severity warning;

                        WriteHigh_time := now;

                elsif W_N = '0' then

                        writing := true;
                        reading := false;

                        if AL = '1' then    -- Address Latch

                                assert (now - CmdLatchLow_time >= tCLLWL(TimeIndex_dev))          -- min value
                                report "(Command Latch Low to Write Enable Low valid time violation (tCLLWL) !!)"
                                severity warning;

                                assert (now - AddLatchHigh_time >= tALHWL(TimeIndex_dev))          -- min value
                                report "(Address Latch High to Write Enable Low valid time violation (tALHWL) !!)"
                                severity warning;
                        
                        else    -- AL = '0'

                                if checkWL then 
                                        
                                        assert (now - AddLatchLow_time >= tALLWL(TimeIndex_dev))          -- min value
                                        report "(Address Latch Low to Write Enable Low valid time violation (tALLWL) !!)"
                                        severity warning;

                                        checkWL := false;
                                end if;        
                        
                        end if;

                        if CL = '1' then  -- only Command Latch 

                                assert (now - CmdLatchLow_time >= tCLHWL(TimeIndex_dev))          -- min value
                                report "(Command Latch High to Write Enable High valid time violation (tCLHWL) !!)"
                                severity warning;
                        
                        else    -- CL = '0'

                                assert (now - WriteLow_time >= tWLWL(TimeIndex_dev))          -- min value
                                report "(Write Enable Low to Write Enable Low valid time violation (tWLWL) !!)"
                                severity warning;

                        end if;

                        assert (now - EnableLow_time >= tELWL(TimeIndex_dev))          -- min value
                        report "(Chip Enable Low to Write Enable Low valid time violation (tELWL) !!)"
                        severity warning;

                        WriteLow_time := now;

                end if;

        end if;

        ---------------------
        ---   R_N event   ---
        ---------------------

        if R_N'event then

                if R_N = '1' then
                
                        ReadHigh_time := now;

                elsif R_N = '0' then

                        reading := true;
                        writing := false;

                        if W_N = '1' then

                                assert (now - CmdLatchLow_time >= tCLLRL(TimeIndex_dev))          -- min value
                                report "(Command Latch Low to Read Enable Low valid time violation (tCLLRL) !!)"
                                severity warning;

                                if readStatusReg_op then 

                                        assert (now - WriteHigh_time >= tWHRL(TimeIndex_dev))          -- min value
                                        report "(Write Enable High to Read Enable Low valid time violation (tWHRL) !!)"
                                        severity warning;

                                        readStatusReg_op := false;

                                elsif readElectSign_op then

                                        assert (now - AddLatchLow_time >= tALLRL1(TimeIndex_dev))          -- min value
                                        report "(Address Latch Low to Read Enable Low valid time violation (tALLRL1) !!)"
                                        severity warning;

                                        readElectSign_op := false;

                                end if;

                        end if;

                        assert (now - ReadHigh_time >= tRHRL(TimeIndex_dev))          -- min value
                        report "(Read Enable High to Read Enable Low valid time violation (tRHRL) !!)"
                        severity warning;

                        assert (now - ReadLow_time >= tRLRL(TimeIndex_dev))          -- min value
                        report "(Read Enable Low to Read Enable Low valid time violation (tRLRL) !!)"
                        severity warning;

                        assert (now - BusyHiZ_time >= tBHRL(TimeIndex_dev))          -- min value
                        report "(Read/Busy Hi-Z to Read Enable Low valid time violation (tBHRL) !!)"
                        severity warning;

                        if CL = '0' then 

                                assert (now - DataHZ_time >= tDZRL(TimeIndex_dev))          -- min value
                                report "(Data Hi-Z to Read Enable Low valid time violation (tDZRL) !!)"
                                severity warning;
   

                        end if;

                        ReadLow_time := now;

                end if;

        end if;

        ---------------------
        ---   E_N event   ---
        ---------------------

        if E_N'event then

                if E_N = '1' then

                        if AL = '0' then
                                
                                assert (now - WriteHigh_time >= tWHEH(TimeIndex_dev))          -- min value
                                report "(Write Enable High to Chip Enable High valid time violation (tWHEH) !!)"
                                severity warning;
                        
                        end if;        

                        EnableHigh_time := now;

                elsif E_N = '0' then

                        checkWL := true;
                        
                        assert (now - EnableHigh_time >= tEHEL(TimeIndex_dev))          -- min value
                        report "(Chip Enable High to Chip Enable Low valid time violation (tEHEL) !!)"
                        severity warning;

                        EnableLow_time := now;

                end if;

        end if;

        ----------------------
        ---   RB_N event   ---
        ----------------------

        if Ready_busy'event then

                if Ready_busy = 'Z' then

                        BusyHiZ_time := now;

                        assert (now - EnableHigh_time >= tEHBH(TimeIndex_dev))          -- min value
                        report "(Chip Enable High to Ready/Busy Hi-Z valid time violation (tEHBH) !!)"
                        severity warning;

                elsif Ready_busy = '0' then

                        assert (now - WriteHigh_time >= tWHBL(TimeIndex_dev))          -- min value
                        report "(Write Enable High to Ready/Busy Low valid time violation (tWHBL) !!)"
                        severity warning;

                        BusyLow_time := now;

                end if;

        end if;

   end if;
        
  end process ; 

End behavior;
LIBRARY IEEE;
   Use IEEE.std_logic_1164.all;
   Use IEEE.std_logic_TextIO.all;
   Use IEEE.std_logic_arith.all;


LIBRARY Work;
    Use work.def.all;
    Use work.UserData.all;
    Use work.CUIcommandData.all;
    Use work.data.all;
    Use work.TimingData.all;
    Use work.StringLib.all;
    Use work.BlockLib.all;

ENTITY NANDxxxWxA IS
 
  GENERIC (         
                MemoryFileName  : String := "./memory_file";            -- memory load file.
                timingCheck_on  : Boolean := false
          );

  PORT  (
      I_O   : inout IObus_type;              

      E_N   : in std_logic;
      R_N   : in std_logic;  
      W_N   : in std_logic;
      AL    : in std_logic;
      CL    : in std_logic;
      WP_N  : in std_logic;
      RB_N  : out std_logic;
      Vss   : in real;
      Vdd   : in real
  );
END NANDxxxWxA;


ARCHITECTURE behavior OF NANDxxxWxA IS


-- === Internal Signal ===
-- === Bus Latch ===
-- Data Bus
Signal  DataBusIn     : DataBus_type;
Signal  DataBusOut    : DataBus_type;
Signal  DataBusBUFFER : DataBus_type;
-- Address Bus
signal  A8            : Std_Logic;
signal  A8_spare      : Std_Logic;
Signal  latch_address : Address_type;         -- address to latch
Signal  real_address  : Address_type;         -- latchaddress + A8
Signal  hold_Address  : InternalAddress_type; -- latchaddress + A8 + A8_spare
-- Address Bus
Signal  hold_Command  : CommandBus_type;
Signal  hold_block    : Address_type;


-- Chip Enable
Signal  CE_N      : Std_Logic;

-- Data Write Enable
Signal  WLE_N      : Std_Logic;

-- Data Read Enable 
Signal  RLE_N      : Std_Logic;

-- Address Latch Enable
Signal  ALE_N      : Std_Logic;

-- Command Latch Enable
Signal  CLE_N      : Std_Logic;

-- is Voltage in Range
Signal  VddOK      : Std_Logic := '1';

-- Reset
--Signal  ResetHardware : Boolean := false;
Signal  ResetSoftware : Boolean := false; 
-- -- is TRUE if Reset Hardware or Software is active
signal  PowerUp        : Boolean := false;
Signal  WriteProtect   : std_logic;
Signal  Reset          : Boolean := false; 

-- ---------------- Guarded Function for Guarded Signal -------------------------------
-- return '1' if all signal is '1' otherwise return 'X'
Function EventGuarded(VE: vectorErrorEvent_type) Return ErrorEvent is
Variable i:Integer; 
Variable V:ErrorEvent;
  Begin 
     V:='1';
     for i in VE'range loop
         if VE(i)='X' then 
                      V:='X';
         end if;
     end loop;
     Return V;
End Function;

Function EventTimeGuarded(V: vectorTimeEvent_type) Return TimeEvent is
Variable i:Integer;
Variable big : Time;
  Begin 
  big := V(V'LOW);
  for i in V'range loop
      if V(i)>big then 
                big:=V(i);
      end if;
  end loop;
return big; 
End Function;



Function CommandGuarded(vComm: vectorCommand_type) Return Command_type is
Variable i : Integer; 
Variable result : command_type;
  begin 
   result := None;
   for i in vComm'range loop
          if vComm(i)/=None then 
                result:=vComm(i);
                exit;
          end if;
   end loop;
  

  Return result;
End Function;

Function IndexCommandGuarded(viCommand : vectorIndexCommand_type) Return IndexCommand_type is
Variable i : Integer;
Variable Max : IndexCommand_type;
Variable cZero: Integer;
Begin 
   cZero := 0;
   Max := 1;
   for i in viCommand'range loop
         if viCommand(i)>Max then Max:=viCommand(i);end if;
         if viCommand(i)=0 then cZero:=cZero+1;end if;
   end loop;
   if cZero = viCommand'length then Max:=1;end if;
   return Max;
End Function;

Function BufferTaskGuarded(VMT: vectorBufferTask_type) Return BufferTask_type is 
Variable i:Integer;
Variable bigMT : BufferTask_type;
Variable MTN : BufferTask_type;
  Begin 
  bigMT  := VMT(VMT'LOW);

  for i in VMT'low + 1 to VMT'high loop
      MTN:= VMT(i);
      if VMT(i).eventTime > bigMT.eventTime then bigMT := VMT(i);
      elsif VMT(i).eventTime = bigMT.eventTime then 
         if VMT(i).putTime > BigMT.putTime
               then bigMT := VMT(i); 
         end if;
      end if;
  end loop;
Return bigMT; 
End Function;

-- ==== Page Buffer: Guarded Task ==== --
Function PageBufferTaskGuarded(VMT: vectorPageBufferTask_type) Return PageBufferTask_type is 
Variable i:Integer;
Variable bigMT : PageBufferTask_type;
Variable MTN : PageBufferTask_type;
  Begin 
  bigMT  := VMT(VMT'LOW);
  for i in VMT'low + 1 to VMT'high loop
      MTN:= VMT(i);
      if VMT(i).eventTime > bigMT.eventTime then bigMT := VMT(i); end if;
  end loop;
Return bigMT; 
End Function;


Function KernelReportGuarded(VKR: vectorKernelReport_type) Return KernelReport_type is 
Variable i:Integer;
Variable bigKR : KernelReport_type;
Variable KRN   : KernelReport_type;
  Begin 
  bigKR  := VKR(VKR'LOW);
  
  for i in VKR'low + 1 to VKR'high loop
      KRN:= VKR(i);

      if VKR(i).eventTime > bigKR.eventTime then bigKR := VKR(i); end if;
      
  end loop;
Return bigKR; 
End Function;


Function StatusRegisterTaskGuarded(VET: vectorStatusRegisterTask_type) Return StatusRegisterTask_type is 
Variable i:Integer;
Variable bigET : StatusRegisterTask_type;
  Begin 
  bigET  := VET(VET'LOW);
  
  for i in VET'range loop
      if VET(i).eventTime > bigET.eventTime then bigET := VET(i); end if;

  end loop;
return bigET; 
End Function;


-- ==== Page Buffer: Guarded Task ==== --
Function ReadTaskGuarded(VMT: vectorReadTask_type) Return ReadTask_type is 
Variable i:Integer;
Variable bigMT : ReadTask_type;
Variable MTN : ReadTask_type;
  Begin 
  bigMT  := VMT(VMT'LOW);
  for i in VMT'low + 1 to VMT'high loop
      MTN:= VMT(i);
      if VMT(i).eventTime > bigMT.eventTime then bigMT := VMT(i); end if;
  end loop;
Return bigMT; 
End Function;

Function ReadModeGuarded(VET: vectorReadMode_type) Return ReadMode_type is 
Variable i:Integer;
Variable bigET : ReadMode_type;
  Begin 
  bigET  := VET(VET'LOW);
  
  for i in VET'range loop
      if VET(i).eventTime > bigET.eventTime then bigET := VET(i); end if;
      
  end loop;
return bigET; 
End Function;

Function EraseTaskGuarded(VET: vectorEraseTask_type) Return EraseTask_type is 
Variable i:Integer;
Variable bigET : EraseTask_type;
  Begin 
  bigET  := VET(VET'LOW);
  
  for i in VET'range loop
      if VET(i).eventTime > bigET.eventTime then bigET := VET(i); end if;
  end loop;
return bigET; 
End Function;

Function MemoryTaskGuarded(VMT: vectorMemoryTask_type) Return MemoryTask_type is 
Variable i:Integer;
Variable bigMT : MemoryTask_type;
Variable MTN : MemoryTask_type;
  Begin 
  bigMT  := VMT(VMT'LOW);
  
  for i in VMT'low + 1 to VMT'high loop
      MTN:= VMT(i);
      if VMT(i).eventTime > bigMT.eventTime then bigMT := VMT(i); end if;
  end loop;
Return bigMT; 
End Function;


Function ProgramTaskGuarded(VPT: vectorProgramTask_type) Return ProgramTask_type is 
Variable i:Integer;
Variable bigPT : ProgramTask_type;
Variable KRN   : ProgramTask_type;
  Begin 
  bigPT  := VPT(VPT'LOW);
  for i in VPT'range loop
      KRN:= VPT(i);
      if VPT(i).eventTime > bigPT.eventTime then bigPT := VPT(i); end if;
  end loop;
return bigPT; 
End Function;



Function BlockLockTaskGuarded(VET: vectorBlockLockTask_type) Return BlockLockTask_type is 
Variable i:Integer;
Variable bigET : BlockLockTask_type;
  Begin 
  bigET  := VET(VET'LOW);
  for i in VET'range loop
      if VET(i).eventTime > bigET.eventTime then bigET := VET(i); end if;
  end loop;
return bigET; 
End Function;



-- ==== Signal Declaration ==== --
-- Kernel Signal
Signal  Kernel_Status           : Status_type;
Signal  Kernel_Report           : KernelReportGuarded KernelReport_type register;

Signal  Kernel_CUIcommand       : Event := False;
Signal  Kernel_CommandDecode    : CommandGuarded Command_type register := None;
Signal  Kernel_IseqCommand      : IndexCommandGuarded IndexCommand_type register := 1;
Signal  Kernel_ReadEvent        : Event := False;
Signal  Kernel_ErrorEvent       : EventGuarded ErrorEvent register := 'X';
Signal  Kernel_VerifyEvent      : EventTimeGuarded TimeEvent register := 0 ns;
Signal  Kernel_LatchAddress     : TimeEvent := 0 ns;
Signal  Kernel_LatchBlockAddress: TimeEvent := 0 ns;
Signal  Kernel_SequentialRowRead: TimeEvent := 0 ns;
Signal  isInit                  : boolean := true;
-- Output Buffer 
Signal  Buffer_task             : BufferTaskGuarded BufferTask_type register;
-- Read Array 
Signal  Read_Status             : Status_type;
Signal  Read_mode               : ReadModeGuarded ReadMode_type register;
Signal  Read_task               : ReadTaskGuarded ReadTask_type register;
Signal  Kernel_ReadTaskComplete : EventTimeGuarded TimeEvent register := 0 ns;
-- Page Buffer 
Signal  PageBuffer_task         : PageBufferTaskGuarded PageBufferTask_type register;
Signal  Kernel_PageComplete     : EventTimeGuarded TimeEvent register := 0 ns;
-- Memory task and signal
Signal  Memory_Task             : MemoryTaskGuarded MemoryTask_type register; 
Signal  Memory_Status           : Status_type;
Signal  Kernel_MemComplete      : EventTimeGuarded TimeEvent register := 0 ns;
-- Page Program 
Shared Variable isPageProgramCmdCode   : Boolean := false;
Shared Variable PageBufferActive       : Natural := 0;
-- Program
Signal  Program_task            : ProgramTaskGuarded ProgramTask_type register;
Signal  Program_Status          : Status_type;
-- Cache Program
Shared Variable isFirstCPoperation     : Boolean := true;
-- Copy Back Program
Shared Variable isCopyBackCmdCode      : Boolean := false;
-- Cache Read
Shared Variable isSR_underCACHEREAD    : Boolean := false;
-- Block Lock 
Signal BlockLock_task          : BlockLockTaskGuarded BlockLockTask_type register;
Signal Kernel_BlockLockComplete: EventTimeGuarded TimeEvent register := 0 ns;
Signal BlockLock_Status        : Status_type;
Signal BlockMode_on            : boolean := false;
Signal SetBlocks               : TimeEvent;
Shared Variable isLatchBlockAddress : boolean := false;
Shared Variable isStartBlockAddress : Boolean := false;

-- Erase
Signal  Erase_task                   : EraseTaskGuarded EraseTask_type register;
Signal  Erase_Status                 : Status_type;

-- Electronic Signature
Signal  Signature_data               : SignatureData_type;

-- Status Register
Signal  StatusRegister_task          : StatusRegisterTaskGuarded StatusRegisterTask_type register;
Signal  Kernel_ReadStatusRegComplete : EventTimeGuarded TimeEvent register := 0 ns;

-- Address selector
Shared Variable MainArea : Boolean  := true;
Shared Variable SpareArea : Boolean := false;
Shared Variable isLoadBufferAfterLatchAddress : Boolean := false;

-- Reset Cmd
Signal  Ready_Busy                   : std_logic := '1';

-- DC Digitalizer Signal
Signal  VDD_check                    : Boolean := false; 

-- Support Declaration
Constant ColumnAddress0 : Std_Logic_vector(ColumnAddress_range) := (Others => '0' );
------------------------------------ Component Declaration -----------------------------------
Component OutputBuffer_entity
   port(
         DataInput    : in DataBus_type;
         DataOutput   : out DataBus_type;
         OutputEnable : in Std_Logic;
         Buffer_Task  : in BufferTask_type;
         Reset        : in Boolean
  );
End Component;

----- CUI DECODER Component --
Component CUIdecoder_entity
  generic(
         Command     : Command_type;
         AddrSeq     : SeqAddr_type;
         cmdLen      : IndexCommand_type
        );
   port( 
         CommandBus            : in CommandBus_type;
         Kernel_CUIcommand     : in Event;
         Kernel_VerifyEvent    : out TimeEvent;
         Kernel_CommandDecode  : out command_type;
         Kernel_IseqCommand    : inout IndexCommand_type
        );
End Component;

------ Memory Component
Component Memory_entity is 
  Generic(
        MemoryFileName       : string
        );
  Port (
        Memory_Status        : out Status_type;
        Memory_Task          : inout MemoryTask_type;
        Kernel_MemComplete   : out TimeEvent;
        Reset                : in Boolean
        );
End Component;

------ Page Buffer Component
Component PageBuffer_entity is 
   Generic(
        nPage                : Natural 
        );
   Port(
        PageBuffer_task      : inout PageBufferTask_type;
        Kernel_PageComplete  : out TimeEvent;
        Memory_Task          : inout MemoryTask_type;
        Kernel_MemComplete   : in TimeEvent;
        Kernel_SequentialRowRead : out TimeEvent;
        
        Reset                : in Boolean
        );

End Component;

------- Kernel Component
Component Kernel_entity is 
  port( 
        VDD                  : in Real;
        Read_Status          : in Status_type;
        Program_Status       : in Status_type;
        Erase_Status         : in Status_type;
        Kernel_Status        : out Status_type;
        Kernel_Report        : in KernelReport_type;
        Kernel_LatchAddress  : in TimeEvent;
        Kernel_VerifyEvent   : out TimeEvent;
        Kernel_ErrorEvent    : in ErrorEvent;

        Read_mode            : out ReadMode_type;
        Reset                : in boolean
  
      );
end Component;

------ Device Read  Component
Component Read_entity is 
  Port (
        Read_Status                     : out Status_type;
        DataOutput                      : out DataBus_type;
        BlockAddress                    : in    Address_type;
        Signature_data                  : in    SignatureData_type;

        Read_mode                       : in ReadMode_type;
        Kernel_ReadEvent                : in  Event;
        
        
        Read_task                       : in ReadTask_type;
        Kernel_ReadTaskComplete         : out TimeEvent;
        BlockLock_task                  : inout BlockLockTask_type;
        StatusRegister_task             : inout StatusRegisterTask_type;

        PageBuffer_task          : inout PageBufferTask_type;
        Kernel_PageComplete      : in    TimeEvent;
        Kernel_BlockLockComplete        : inout TimeEvent;
        Kernel_ReadStatusRegComplete    : inout TimeEvent;

        Kernel_Status            : in    Status_type;
        Kernel_Report            : out   KernelReport_type;

        Reset                    : in  Boolean
        );
End Component;

Component Program_entity is 
  port (
        Program_Status          : out   Status_type;
        Program_Task            : inout ProgramTask_type;

        BlockLock_task          : inout BlockLockTask_type;
        Kernel_BlockLockComplete: in TimeEvent;

        PageBuffer_task         : inout PageBufferTask_type;
        Kernel_PageComplete     : in TimeEvent;

        VDD_check               : in Boolean;

        Kernel_CUIcommand       : in Event;
        Reset                   : in Boolean
        );
End Component;
  
Component BlockLock_entity is 
  Port(
        BlockLock_task           : inout BlockLockTask_type;
        Kernel_BlockLockComplete : out TimeEvent;
        BlockLock_status         : out status_type;
        WriteProtect             : in Std_Logic;
        SetBlocks                : in TimeEvent;       
        BlockMode_on             : in boolean;
        Reset                    : in Boolean
        );
End Component;

Component Erase_entity is 
  port (
        Erase_Status                 : out Status_type;
        Erase_Task                   : inout EraseTask_type;
        Memory_Task              : inout MemoryTask_type;
        Kernel_MemComplete           : in TimeEvent;
        BlockLock_task               : inout BlockLockTask_type;
        Kernel_BlockLockComplete     : in TimeEvent;
        Kernel_CUIcommand            : in Event;
        Reset                : in Boolean
        );
End Component;

Component StatusRegister_entity is 
  Port(
        Kernel_status                : in Status_type;
        Program_Status               : in Status_type;
        Read_Status                  : in Status_type;
        Kernel_ReadStatusRegComplete : out TimeEvent;
        StatusRegister_task          : inout StatusRegisterTask_type;
        Kernel_CUIcommand            : in Event;
        Reset                        : in Boolean

  );
End Component;

Component ElectronicSignature_entity is 
  Port(
        Signature_data           : out SignatureData_type;
        Reset                    : in Boolean
        );
End Component;

Component TimingCheck_entity is

        Port (
                I_O             : in   IObus_type;
                E_N             : in   std_logic;
                R_N             : in   std_logic;
                W_N             : in   std_logic;
                AL              : in   std_logic;
                CL              : in   std_logic;
                WP_N            : in   std_logic;
                Ready_Busy      : in   std_logic;

                timingCheck_on  : in   boolean
     );
End Component;


--                                      ==== Architecture ===== 

Begin                              
-- ==== -------------------------- Component Istantation -----------------------------------------------
  Kernel :  Kernel_entity
      Port map( VDD, 
                Read_status, Program_Status, Erase_Status,
                Kernel_Status,
                Kernel_Report, 
                Kernel_LatchAddress,
                Kernel_VerifyEvent, Kernel_ErrorEvent,
                Read_mode,
                Reset );



  ReadManager         : Read_entity 
                      Port map ( Read_Status,
                                 DataBusBUFFER, 
                                 hold_block, 
                                 Signature_data, 
                                 Read_mode, 
                                 Kernel_ReadEvent, 
                                 Read_task, Kernel_ReadTaskComplete,
                                 BlockLock_task, 
                                 StatusRegister_task, 

                                 PageBuffer_task, Kernel_PageComplete, 
                                 Kernel_BlockLockComplete, 
                                 Kernel_ReadStatusRegComplete, 

                                 Kernel_Status, Kernel_Report, 
                                 Reset );

  ProgramManager      : Program_entity
                      Port Map (
                                 Program_Status, 
                                 Program_Task, 

                                 BlockLock_task,
                                 Kernel_BlockLockComplete,

                                 PageBuffer_task,
                                 Kernel_PageComplete,

                                 VDD_check,
                                 Kernel_CUIcommand,
                                 Reset );

  BlockLock_Manager   : BlockLock_entity
                      Port map( BlockLock_task, 
                                Kernel_BlockLockComplete, 
                                BlockLock_status, 
                                WP_N, 
                                SetBlocks,
                                BlockMode_on, 
                                Reset );
 --TimingCheck_Manager  : TimingCheck_entity 
 --       Port map ( I_O, E_N, R_N, W_N, AL, CL, WP_N, Ready_Busy, timingCheck_on );



  -- Command Recognition --
   ReadArrayLoadA_decode: CUIdecoder_entity
                       generic map (ReadA_cmd, ReadA_seqAddr, ReadA_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);
  
   ReadArrayLoadB_decode: CUIdecoder_entity
                       generic map (ReadB_cmd, ReadB_seqAddr, ReadB_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

   ReadArrayLoadC_decode: CUIdecoder_entity
                       generic map (ReadC_cmd, ReadC_seqAddr, ReadC_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);


     PageProgramCmdCode_decode: CUIdecoder_entity
                       generic map (PageProgramCmdCode_cmd, PageProgramCmdCode_seqAddr, PageProgramCmdCode_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

     PageProgramCfmCode_decode: CUIdecoder_entity
                       generic map (PageProgramCfmCode_cmd, PageProgramCfmCode_seqAddr, PageProgramCfmCode_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

   CopyBackProgramCfmCode_decode: CUIdecoder_entity
                       generic map (CopyBackProgramCfmCode_cmd, CopyBackProgramCfmCode_seqAddr, CopyBackProgramCfmCode_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

     BlockErase_decode: CUIdecoder_entity
                       generic map (BlockErase_cmd, BlockErase_seqAddr, BlockErase_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

     ReadStatusRegister_decode: CUIdecoder_entity
                       generic map (ReadStatusRegister_cmd, ReadStatusRegister_seqAddr, ReadStatusRegister_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

  ReadElectronicSignature_decode: CUIdecoder_entity
                       generic map (ReadElectronicSignature_cmd, ReadElectronicSignature_seqAddr, ReadElectronicSignature_CmdLen)
                       port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

  ResetCmd_decode: CUIdecoder_entity
                   generic map (Reset_cmd, Reset_seqAddr, Reset_CmdLen)
                   port map (hold_Command, Kernel_CUIcommand, Kernel_VerifyEvent, Kernel_CommandDecode, Kernel_IseqCommand);

-------------------------------------------------------------------------------------
  OutputBufferManager  : OutputBuffer_entity 
                      Port map ( DataBusBUFFER, DataBusOut, RLE_N, Buffer_Task, Reset );

  MemoryManager        : Memory_entity
                      Generic map ( MemoryFileName )
                      Port map ( Memory_Status, Memory_Task, Kernel_MemComplete, Reset );

  Erase_Manager        : Erase_Entity
                      port map (Erase_Status, Erase_Task, Memory_Task, Kernel_MemComplete, BlockLock_task, Kernel_BlockLockComplete, 
                      Kernel_CUIcommand, Reset);

  StatusRegister_Manager : StatusRegister_entity
        port map (Kernel_status, Program_Status, Read_Status, Kernel_ReadStatusRegComplete, StatusRegister_task,  Kernel_CUIcommand, Reset); 

 ElectronicSignature_Manager : ElectronicSignature_entity
        port map (Signature_data, Reset);

PageBuffer0Manager    :  PageBuffer_entity 
                                Generic map ( 0 )
                                Port map    ( PageBuffer_task, Kernel_PageComplete, 
                                              Memory_Task, Kernel_MemComplete,
                                              Kernel_SequentialRowRead,
                                              Reset 
                                );

-- Internal Signal 
  -- Chip Enable 
  CE_N <= E_N and VddOK ;
  -- Write Enable for Data
  WLE_N <= W_N or CE_N or CL or AL or not(R_N);
  -- Read Enable for Data
  RLE_N <= R_N or CE_N or CL or AL or not(W_N);
  -- Address Latch Enable
  ALE_N <= not(AL) or CE_N or not(CLE_N) or not(R_N) or W_N;
  -- Command Latch Enable
  CLE_N <= not(CL) or CE_N or not(ALE_N) or not(R_N) or W_N;

-- Ready/Busy 
  RB_N          <= '0' after tWHBL(TimeIndex_dev) when (Kernel_Status.busy or Ready_Busy='0') else 'Z';
  
  WriteProtect  <= WP_N;

  
  -- Init Process for reset value any value
  Init_process : process(isInit) begin 
                 if (isInit) then
                        Powerup <= true, false after tBLBH4(TimeIndex_dev); 
                        isInit  <= false;
                        isLatchBlockAddress  := false;
                        isPageProgramCmdCode := false; 
                        isCopyBackCmdCode    := false;
                        isSR_underCACHEREAD  := false;
                        isFirstCPoperation   := true;
                        MainArea  := true;
                        SpareArea := false;
                        isLoadBufferAfterLatchAddress := false;
                        PageBufferActive     := 0;
                 end if;
  end process Init_process;

  PowerUp_process : process begin 
                    wait until PowerUp'event;
                    if not(PowerUp) then 
                        SetBlocks <= now;
                        Read_mode.mode <= ReadArray_status; -- Default Value
                        Read_mode.eventTime <= now;
                    end if;
  end process PowerUp_process;


  -- Reset Signal
  Reset <=  Powerup or ResetSoftware;  
                                        --ResetHardware or ResetSoftware;  

  -- Buffer DATA
  DataBusOut_process : process(DataBusOut) begin
                                 I_O <= DataBusOut;
  end process DataBusOut_process;
  
  -- Latch Data
  DataBusIn_Process: Process begin
                     wait until (WLE_N'event and WLE_N='1');
                     DataBusIn <= I_O;
                     if (now>0 ns) then --PrintString("[" & time2str(now) & "]  Data Input: " & Str2Hex(Slv2Str(I_O)));
                     
                             PageBuffer_task.task      <= PutData;
                             PageBuffer_task.nPage     <= PageBufferActive;
                             PageBuffer_task.data      <= to_bitvector(I_O);     
                             PageBuffer_task.eventTime <= now;    
                             PageBuffer_task.LenArea    <= 256;   -- NP
                             PageBuffer_task.EndArea    <= 263;   -- NP
                             PageBuffer_task.MemAddress <= 0;     -- NP;
                             PageBuffer_task.alldata <= (Others => (Others => '0' )); -- NP
                             PageBuffer_task.Index <= 0;          -- NP
                             PageBuffer_task.IndexArea <= 0;      -- NP
                             PageBuffer_task.PointerName <= AreaA;      -- NP

                                 wait until Kernel_PageComplete'event;
                     end if;
  End Process DataBusIn_Process;

  -- Latch Address
  Address_latch: process     
  Variable nCycle : Natural := 1; 
    Begin
    wait until ALE_N'event or Reset'event or Kernel_CUIcommand'event or Kernel_ReadEvent'event; 

        if ( Reset'event and Reset) then 
                latch_address<=(Others =>  '0');
                hold_block <= (Others => '0');     
                isPageProgramCmdCode := false;
                nCycle:=1;

         elsif (Kernel_CUIcommand'event or Kernel_ReadEvent'event) then 
                nCycle := 1;

         elsif (ALE_N='1' and ALE_N'event) then 
           case nCycle is
               when 1 =>
                    latch_address(7 downto 0) <= I_O(7 downto 0);
                    hold_block(2 downto 0) <= I_O(7 downto 5);
                        
                    nCycle := nCycle + 1;
               when 2 =>

                    hold_block(10 downto 3) <= I_O(7 downto 0);

                    latch_address(16 downto 9) <= I_O(7 downto 0);

                        -- Change Index Page in PageBuffer0 for Copy to Back command Code
                    nCycle := nCycle + 1; -- latch next address;
                    if (isLatchBlockAddress and Size_dev < NAND512Gbit) then 
                                nCycle := 0;
                                isLatchBlockAddress := false;
                                Kernel_LatchBlockAddress <= now;         
                    end if;
               when 3 =>
                    latch_address(24 downto 17)<= I_O(7 downto 0);
                    hold_block(11) <= I_O(0);
                    if Size_dev >= NAND512Gbit then nCycle:=nCycle + 1;
                                               else nCycle:=1;
                                                    Kernel_LatchAddress <= now;
                    end if;
                    if (isLatchBlockAddress) then 
                                             nCycle := 1;
                                             isLatchBlockAddress := false;
                                             Kernel_LatchBlockAddress <= now;
                    end if;


               when 4 =>
                    latch_address(25) <= I_O(0);
                    if I_O(7 downto 2)/="000000" then 
                                                 PrintString("[" & time2str(now) & "]  #Warning: Address not valid : I_O[7 downto 2] must be equal to  ");
                    end if;
                    if (A8_spare='0') then --PrintString("[" & time2str(now) & "]  Address Input: " & slv2hex(I_O(1 downto 0) & latch_address(24 downto 9) & A8 & latch_address(7 downto 0)));
                                     else --PrintString("[" & time2str(now) & "]  Spare Area Address Input: " & slv2hex(I_O(1 downto 0) & latch_address(24 downto 9) & A8 & latch_address(3 downto 0)));
                    end if;
                    nCycle := 1;
                    Kernel_LatchBlockAddress <= now after 1 fs;
                 -- comment this line if Device size is over 1Gbit
               when Others =>  
           end case;
           
         end if;
  end process;
  

  hold_address <= '0' & latch_address(PageAddress_range) & A8_spare & latch_address(ColumnAddress_range) when mode16bit else latch_address(PageAddress_range) & A8_spare & A8 & latch_address(ColumnAddress_range);
  real_address <= '0' & latch_address(PageAddress_range) & latch_address(ColumnAddress_range) when mode16bit else latch_address(PageAddress_range) & A8 & latch_address(ColumnAddress_range);

  Command_latch: process begin
        Wait Until (CLE_N='0' and CLE_N'event);
             Wait Until (CLE_N='1' and CLE_N'event);
                                Kernel_CUIcommand <= not(Kernel_CUIcommand);
                                hold_Command <= I_O(CommandBus_range);
  end process;                                    

  Verify_Error : Process begin
                 Wait Until Kernel_CUIcommand'event;
                      Kernel_ErrorEvent <= '1' after 1 ps; --Error if not verify event at same delta time
                      Wait Until Kernel_VerifyEvent'event;
                         Kernel_ErrorEvent <= 'X'; -- Error Suppressed
  End Process Verify_Error;


  OutputEnable_SetTiming : Process begin 
                           wait until (RLE_N'event or R_N'event or reset'event);

                           if (reset'event and not(reset)) then 
                              Buffer_task.task<=setDataZ;
                              Buffer_task.putTime<=0 ns;
                           elsif (RLE_N'event and not(Kernel_Status.busy)) then  -- Bus Read Operation: G_N controlled
                                if (RLE_N='0') then 
                                   Kernel_ReadEvent <= not (Kernel_ReadEvent); -- Bus Read Operation Event 
                                   wait for 1 ps;
                                   if (tRLQV(TimeIndex_dev) > 1 ps) then 
                                                Buffer_task.putTime <= tRLQV(TimeIndex_dev) - 1 ps;
                                                Buffer_task.task<=setDataValid;
                                                Buffer_task.eventTime <= now;
                                           else PrintString("+++ General Error +++ Check Source: Output Enable");
                                   end if;
                                else -- RLE_N ='1' -- IObus released
                                   Buffer_task.putTime <= tRHQZ(TimeIndex_dev); Buffer_task.task<=setDataZ;Buffer_task.eventTime <= now;
                                end if;
                            elsif (R_N'event and R_N='1') then 
                                   Buffer_task.putTime <= tRHQZ(TimeIndex_dev); Buffer_task.task<=setDataZ;Buffer_task.eventTime <= now;
                            end if;
  end Process OutputEnable_SetTiming;

  Voltage_controller   : Process (Vdd) begin
                         --if (Vdd>=Vdd_low and Vdd<=Vdd_High) 
                           --     then 
                                     VDD_check <= true;
                                     PrintString("[" & time2str(now) & "]  VDD range is OK");
--                               else 
--                                    VDD_check <= false;
--                                    Assert (false)
--                                    report ("!ATTENTION: VDD out of Range")
--                                    Severity Warning;
--                        end if;
  End Process Voltage_controller;



  PointerSelector : Process 
                    begin
                    wait until Kernel_CommandDecode'event;
                    if (kernel_commandDecode = readA_cmd or 
                      Kernel_commandDecode = readB_cmd or 
                      Kernel_commandDecode = readC_cmd) then 
                      isLoadBufferAfterLatchAddress:=true;
                      Case (Kernel_CommandDecode) is 
--                      A26...A9 | A8_spare | A8 | A7..A0       |  Pointer
--                      xxxxxxxx      0       0    xxxxxx       |   Area A
--                      xxxxxxxx      0       1    xxxxxx       |   Area B
--                      xxxxxxxx      1       0    xxxxxx       |   Area C
--                      xxxxxxxx      1       1    xxxxxx       |   Not Used
                         when ReadA_cmd => 
                                    PrintString("[" & time2str(now) & "]  Command Issued: Read A - Set Pointer Area A -"); 

                                        A8 <= '0';
                                        A8_spare <= '0';

                                        MainArea  := true;
                                        SpareArea := false;
                                        PageBuffer_task.task       <= setPointer;
                                        PageBuffer_task.IndexArea  <= IndexAreaA;
                                        PageBuffer_task.LenArea    <= LenAreaA;
                                        PageBuffer_task.EndArea    <= EndAreaA;
                                        PageBuffer_task.PointerName <= AreaA;

                         when ReadB_cmd => 
                                    PrintString("[" & time2str(now) & "]  Command Issued: Read B - Set Pointer Area B -"); 

                                        A8 <= '1';
                                        A8_spare <= '0';

                                        MainArea  := true;
                                        SpareArea := false;
                                        PageBuffer_task.task       <= setPointer;
                                        PageBuffer_task.IndexArea  <= IndexAreaB;
                                        PageBuffer_task.LenArea    <= LenAreaB;
                                        PageBuffer_task.EndArea    <= EndAreaB;
                                        PageBuffer_task.PointerName <= AreaB;     

                         when ReadC_cmd => 
                                    PrintString("[" & time2str(now) & "]  Command Issued: Read C - Set Pointer Area C -"); 
                                    
                                        A8 <= '0';
                                        A8_spare <= '1';

                                        MainArea  := false;
                                        SpareArea := true;
 
                                        PageBuffer_task.task       <= setPointer;
                                        PageBuffer_task.IndexArea  <= IndexAreaC;
                                        PageBuffer_task.LenArea    <= LenAreaC;
                                        PageBuffer_task.EndArea    <= EndAreaC;
                                        PageBuffer_task.PointerName <= AreaC;     
                         when Others =>  
                      End Case;
                      PageBuffer_task.nPage      <= PageBuffer0; -- NP
                      PageBuffer_task.MemAddress <= 0; -- Address = 0
                      PageBuffer_task.Index      <= 0;
                      PageBuffer_task.eventTime  <= now; 
                      PageBuffer_task.alldata <= (Others =>  (Others => '0' )); -- NP
                      PageBuffer_task.data <= X"00";       -- NP
                         wait until Kernel_PageComplete'event;
                   else 
                      isLoadBufferAfterLatchAddress:=false;
                   end if;
  end process;
  
  LoadBuffer      : Process 
                    Variable AddressWithColumn0 : InternalAddress_type;
                    begin
                    wait until Kernel_LatchBlockAddress'event or Kernel_SequentialRowRead'event;
                    PageBuffer_task.nPage      <= PageBuffer0;
                    AddressWithColumn0         := hold_address(InternalPageAddress_range) & "00" & ColumnAddress0;
                    PageBuffer_task.MemAddress <= slv2int(AddressWithColumn0); 
                    if (A8_spare='1') then -- Area C 
                                   PageBuffer_task.IndexArea  <= IndexAreaC;
                                   PageBuffer_task.Index      <= slv2int(hold_address(SpareAddress_range)); -- Area Spare
                                   PageBuffer_task.LenArea    <= LenAreaC;
                              else 
                                   if A8='1' then -- Area B
                                              PageBuffer_task.IndexArea  <= IndexAreaB;
                                              PageBuffer_task.Index      <= slv2int(hold_Address(ColumnAddress_range)); -- Area B
                                              PageBuffer_task.LenArea    <= LenAreaB;
                                         else     -- Area A
                                              PageBuffer_task.IndexArea  <= IndexAreaA;
                                              PageBuffer_task.Index      <= slv2int(hold_Address(ColumnAddress_range)); -- Area A
                                              PageBuffer_task.LenArea    <= LenAreaA;
                                         end if;
                    end if;
                    PageBuffer_task.eventTime  <= now; 
                                 PageBuffer_task.alldata    <= (Others =>  (Others => '0' )); -- NP
                                 PageBuffer_task.data       <= X"00";       -- NP
                                 PageBuffer_task.EndArea    <= 263;   -- NP
                                        PageBuffer_task.PointerName <= AreaA; --NP
                    if Kernel_SequentialRowRead'event then 
                                            PageBuffer_task.task <= none; --Sequential Row read has not effect in PageBuffer                                             Read_task.task      <= ReadArray;
                                            Read_task.task      <= ReadArray;
                                            Read_task.Address   <= real_address;
                                            Read_task.eventTime <= now;
                                            wait until Kernel_ReadTaskComplete'event;
                    elsif isLoadBufferAfterLatchAddress then
                                            PageBuffer_task.task <= PutDataFromMemory;
                                            Read_task.task      <= ReadArray;
                                            Read_task.Address   <= real_address;
                                            Read_task.eventTime <= now;
                                            wait until Kernel_ReadTaskComplete'event;
                    else
                             PageBuffer_task.task <= PutMemAddress;
                    end if;
                    wait until Kernel_PageComplete'event;

                                 -- Read Memory Page and storage in the Page Buffer

                                 -- Call to Read task

  end Process;
                    

  PageProgramCmdCode_command: Process begin 
                              wait until Kernel_CommandDecode'event;
                              if (Kernel_Status.busy) then 
                                 PrintString("[" & time2str(now) & "]  #Warning: Device is Busy Command Ignored");
                              elsif  (Kernel_CommandDecode = PageProgramCmdCode_cmd) then
                                     PrintString("[" & time2str(now) & "]  Command Issued: Page Program [Setup code]"); 
                                     isPageProgramCmdCode := true;
                                     isCopyBackCmdCode := false;
                                     isLoadBufferAfterLatchAddress := false;
                                             PageBuffer_task.task       <= ResetIndex;
                                             PageBuffer_task.nPage      <= PageBufferActive;
                                             PageBuffer_task.eventTime  <= now; 
                                             PageBuffer_task.MemAddress <= 0; -- NP;
                                             PageBuffer_task.Index <= 0; -- NP;
                                             PageBuffer_task.AllData <= (Others =>  (Others =>  '0')); -- NP;
                                             PageBuffer_task.data <= X"00";    -- NP;
                                             PageBuffer_task.IndexArea <= 0; -- NP;
                                             PageBuffer_task.LenArea <= 256;   -- NP;
                                             PageBuffer_task.EndArea    <= 263; -- NP;
                                             PageBuffer_task.PointerName <= AreaA; --NP
                                                wait until Kernel_PageComplete'event;
 
                              end if;
  End Process PageProgramCmdCode_Command;
   
  PageProgramCfmCode_command: Process 
                              Variable AddressWithColumn0 : InternalAddress_type;
                              begin 
                              wait until Kernel_CommandDecode'event;
                              If (Kernel_Status.busy) then 
                                 PrintString("[" & time2str(now) & "]  #Warning: Device is Busy Command Ignored");
                              ElsIf  (Kernel_CommandDecode = PageProgramCfmCode_cmd ) then
                                    if isCopyBackCmdCode then PrintString("[" & time2str(now) & "]  Command Issued: Copy Back Program [Confirm code]"); 
                                                         else PrintString("[" & time2str(now) & "]  Command Issued: Page Program [Confirm code]"); 
                                    end if;
                                    isPageProgramCmdCode := false;
                                    isFirstCPoperation   := true;
                                    PageBuffer_task.task       <= PutDataToMemory;
                                    PageBuffer_task.nPage      <= PageBufferActive;
                                    AddressWithColumn0   := hold_address(InternalPageAddress_range) & "00" & ColumnAddress0;
                                    PageBuffer_task.MemAddress <= slv2int(AddressWithColumn0);
                                    if (A8_spare='1') then 
                                                    PageBuffer_task.IndexArea  <= 512; 
                                                    PageBuffer_task.Index      <= slv2int(hold_Address(SpareAddress_range)); -- Area Spare
                                                   else 
                                                    if A8='1' then 
                                                                PageBuffer_task.IndexArea  <= 256; 
                                                                PageBuffer_task.Index      <= slv2int(hold_Address(ColumnAddress_range)); -- Area B
                                                            else 
                                                                PageBuffer_task.IndexArea  <= 0; 
                                                                PageBuffer_task.Index      <= slv2int(hold_Address(ColumnAddress_range)); -- Area A
                                                  end if;
                                    end if;

                                             PageBuffer_task.eventTime  <= now; 
                                             PageBuffer_task.AllData <= (Others =>  (Others =>  '0')); -- NP;
                                             PageBuffer_task.data <= X"00";    -- NP;
                                             PageBuffer_task.LenArea <= 256;   -- NP;
                                             PageBuffer_task.EndArea    <= 263; -- NP;
                                             PageBuffer_task.PointerName <= AreaA; --NP
                                             wait until Kernel_PageComplete'event;
                                             
                                    if isCopyBackCmdCode then 
                                       Program_task.task <= CopyBackProgram;
                                       -- Set Address with coloumn address = 0
                                       AddressWithColumn0 := hold_address(InternalPageAddress_range) & A8_spare & A8 & ColumnAddress0;
                                       Program_task.address <= slv2int(AddressWithColumn0); 
                                       isCopyBackCmdCode := false;
                                    else 
                                       Program_task.task <= PageProgram;
                                       AddressWithColumn0 := hold_address(InternalPageAddress_range) & A8_spare & A8 & ColumnAddress0;
                                       Program_task.address <= slv2int(AddressWithColumn0); 
                                    end if;
                                    
                                    Program_task.PageBuffer <= 0; --NP
                                    Program_task.eventTime <= now;
                                       
                                       wait until Program_Status.message'event;
                                       
                                    Kernel_Report.status <= Program_Status.message;
                                    Kernel_Report.eventTime <= now;

                              End if;
  End Process PageProgramCfmCode_Command;

  CopyBackProgramCfmCode_command: Process begin 
                              Wait until Kernel_CommandDecode'event;
                              if (Kernel_Status.busy) then 
                                 PrintString("[" & time2str(now) & "]  #Warning: Device is Busy Command Ignored");
                              elsif  (Kernel_CommandDecode = CopyBackProgramCfmCode_cmd) then
                                   PrintString("[" & time2str(now) & "]  Command Issued: Copy Back Program");
                                   isPageProgramCmdCode := false;
                                   isCopyBackCmdCode := true;
                              End if;                     
  End Process CopyBackProgramCfmCode_command;



  BlockErase_command: Process 
        begin
                wait until Kernel_CommandDecode'event;
                
                      if (Kernel_Status.busy) then 
                                 PrintString("[" & time2str(now) & "]  #Warning: Device is Busy Command Ignored");
                             elsif (Kernel_CommandDecode = BlockErase_cmd) then  
                                PrintString("[" & time2str(now) & "]  Command Issued: Block Erase"); 
                                isLatchBlockAddress := true;

                                Read_mode.mode <= ReadArray_status;
                                Read_mode.eventTime <= now;

                                Erase_task.task         <= BlockErase;
                                Erase_task.BlockNumber  <= slv2int(hold_block);
                                Erase_task.eventTime    <= now;

                                wait until Erase_Status.message'event;

                                Kernel_Report.status    <= Erase_status.message;
                                Kernel_Report.eventTime <= now;
                             
                         end if;

  end process BlockErase_Command;


  -------------------------------------------------------
  ----  Read Status Register Commmand Recognition  ------
  -------------------------------------------------------

  ReadStatusRegister_command: Process 
        begin
                wait until (Kernel_CommandDecode'event);
                
                        if (Kernel_CommandDecode'event and Kernel_CommandDecode = ReadStatusRegister_cmd) then  
                                PrintString("[" & time2str(now) & "]  Command Issued: Read Status Register "); 
                                
                                if (read_mode.mode = CacheRead_status) then 
                                                isSR_underCACHEREAD := true;
                                        else    
                                                isSR_underCACHEREAD := false;
                                end if;
                                Read_mode.mode <= readStatusReg_status;
                                Read_mode.eventTime <= now;

                         end if;

  end process ReadStatusRegister_Command;

  ------------------------------------------------------------
  ----  Read Electronic Signature Commmand Recognition  ------
  ------------------------------------------------------------

  ReadElectronicSignature_command: Process 
        begin
                wait until (Kernel_CommandDecode'event);
                
                      if (Kernel_Status.busy) then 
                                 PrintString("[" & time2str(now) & "]  #Warning: Device is Busy Command Ignored");
                             elsif (Kernel_CommandDecode'event and Kernel_CommandDecode = ReadElectronicSignature_cmd) then  
                                PrintString("[" & time2str(now) & "]  Command Issued: Read Electronic Signature "); 
                                
                                Read_mode.mode <= ReadElectSignature_status;
                                Read_mode.eventTime <= now;

                         end if;

  end process ReadElectronicSignature_Command;

---------------------------------------
----  Reset Command Recognition  ------
---------------------------------------

  ResetCmd_command: Process 
        begin
                wait until Kernel_CommandDecode'event;
                
                        if (Kernel_CommandDecode = Reset_cmd) then  
                                PrintString("[" & time2str(now) & "]  Command Issued: Reset"); 
                                
                                ResetSoftware <= true, false after tBLBH4(TimeIndex_dev);
                                Ready_Busy <= '0', '1' after tBLBH4(TimeIndex_dev);
                                isLatchBlockAddress := false;
                                isStartBlockAddress := false;
                                isPageProgramCmdCode:= false;
                                isCopyBackCmdCode := false;
                                isSR_underCACHEREAD := false;
                                isFirstCPoperation := true;
                                MainArea := true;
                                SpareArea := false;
                                isLoadBufferAfterLatchAddress := false;
                                PageBufferActive    := 0;
                         end if;

  end process ResetCmd_Command;


-- End of Command Recognition

End Behavior;
-------------------------------------------------------------------------------
--                        OUTPUT BUFFER                                      --
-------------------------------------------------------------------------------
Library IEEE;
  Use IEEE.std_logic_1164.all;
  Use IEEE.Std_Logic_signed.all;
Library Work;
  Use work.def.all;
  Use work.data.all;
  Use work.StringLib.all;

Entity OutputBuffer_entity is 
  port(  
         DataInput    : in DataBus_type;
         DataOutput   : out DataBus_type;
         OutputEnable : in Std_Logic;
         Buffer_Task  : in BufferTask_type;
         Reset        : in Boolean
  );
End OutputBuffer_entity;

Architecture behavior of OutputBuffer_entity is 

 Signal timeDataV, timeDataX, timeDataZ: time:= 0 ns;
 Signal goValid :Boolean := false;
 Signal goZ: boolean := false;
 Signal goX: boolean := false;
 Begin
  
  Process begin
  wait until Buffer_Task'event;
  case Buffer_Task.task is 
         when setDataValid =>
                 if (( Buffer_Task.putTime + now > timeDataV ) or ( timeDataV  <  now )) then 
                       timeDataV <= Buffer_Task.putTime + now;
                       goValid <= not(goValid);
                 end if;
         when SetDataX =>
                 if (( Buffer_Task.putTime + now > timeDataX) or ( timeDataX  <  now )) then 
                       timeDataX <= Buffer_Task.putTime + now;
                       goX <= not(goX);
                       if (Buffer_Task.putTime + now < timeDataV) then 
                                                wait for 1 ps;
                                                goValid <= not(goValid); 
                       end if;
                 end if;
         when SetDataZ =>
                 if (( Buffer_Task.putTime + now > timeDataZ) or ( timeDataZ  <  now )) then
                       timeDataZ <= Buffer_Task.putTime + now;
                       goZ <= not(goZ);
                       if (Buffer_Task.putTime + now < timeDataV) then 
                                                goValid <= not(goValid); 
                       end if;
                       if (Buffer_Task.putTime + now < timeDataX) then 
                                                goX <= not(goX); 
                       end if;
                 end if;
         when others => 
      end case;
  end process; 

  goDataValid_process: Process (goValid, goX, goZ, reset)
       Variable  timeTemp: time := 0 ns; begin 
       If (reset) then DataOutput <= (Others =>  'Z');
            else
              if (goValid'event) then
                if (OutputEnable='0') then 
                        timeTemp := timeDataV - now;
                           if  (timeDataV>timeDataZ) and (timeDataZ>now) then
                               DataOutput <= (Others => 'Z') after (timeDataZ-now), DataInput after (timeDataV-now);
                           else 
                               DataOutput <= DataInput after timeTemp;
                           end if;
                end if;
              end if;
              if (goX'event) then
                if (OutputEnable='0') then 
                        timeTemp := timeDataX - now;
                        DataOutput <= (Others => 'X' ) after timeTemp;
                end if;
              end if;
              if (goZ'event) then
                          timeTemp := timeDataZ - now;
                          if (timeDataZ>timeDataV) and (timeDataV > now) then -- // if DQ is not valid when OutputEnable Signal is deasserted
                               DataOutput <= DataInput after (timeDataV-now), (Others =>  'Z') after timeTemp;
                          else 
                               DataOutput <= (Others => 'Z' ) after timeTemp;
                          end if;
              end if;

       End If;
  end process goDataValid_process;

End behavior;

-------------------------------------------------------------------------------
--                      CUI DECODER ENTITY                                   --
-------------------------------------------------------------------------------
LIbrary IEEE;
  Use IEEE.std_logic_1164.all;
  Use IEEE.Std_Logic_arith.all;

Library Work;
  Use work.def.all;
  Use work.CUIcommandData.all;
  Use work.data.all;
  Use work.StringLib.all;
  
Entity CUIdecoder_entity is 
  generic (

        Command     : Command_type;
        AddrSeq     : SeqAddr_type; 
        cmdLen      : IndexCommand_type
       );
  port (
        CommandBus           : in CommandBus_type;
        Kernel_CUIcommand    : in Event;
        Kernel_VerifyEvent   : out TimeEvent;
        Kernel_CommandDecode : out Command_type;
        Kernel_IseqCommand   : inout IndexCommand_type
        );
End CUIdecoder_entity;
  
Architecture behavior of CUIdecoder_entity is 
  Begin

  decode: Process
    Variable iSeq: Integer := 1;
    Variable checkAddr: Boolean; 

    
    -- "45EC" = "45XC"; "2314" /= "2324"; "A231" = "XXXX"
    Function isMatchSLV(d:string; s:string) Return boolean is 
       Variable i:Integer := 1;
       Variable dc,sc: Character;
    begin 
       loop
          If i<=d'right  Then dc:=d(i); Else dc:=NUL; End If;
          If i<=s'right  Then sc:=s(i); Else sc:=NUL; End If;

          If ((dc/=sc and sc/='X') or dc=NUL) Then
               Return (character'pos(dc) - character'pos(sc)=0);
          Else
               i:=i+1;
          End If;
             
       end Loop;
    end isMatchSLV;
    
  Begin 
  Wait Until Kernel_CUIcommand'event;  -- @Kernel.CUIcommandEvent
       if (iSeq=Kernel_IseqCommand)  then
          
             checkAddr := isMatchSLV( slv2hex(CommandBus(ADDRCMD_RANGE)), AddrSeq(Kernel_IseqCommand) );

          if (checkAddr) then -- Sequence confirmed
          
              Kernel_VerifyEvent <= now;    -- No Error
              
              if (iSeq = cmdLen) then -- Last Sequence --> Command Recognized 
                     Kernel_IseqCommand <= 0;
                     iSeq:=1;
                     Kernel_CommandDecode <=  Command;

              else 
                   Kernel_CommandDecode <= None;
                   Kernel_IseqCommand <= Kernel_IseqCommand + 1; -- Check Sequence continue
                   iSeq := iSeq + 1;
              end if;
          else                        -- Sequence not confirmed 
              Kernel_CommandDecode <= None; 
              iSeq := 1;
              Kernel_IseqCommand <= 0;
          end if;
       else                            -- Sequence not confirmed 
          Kernel_CommandDecode <= None; 
          iSeq := 1;
          Kernel_IseqCommand <= 0;
        
    end if;
  End Process decode;

End behavior;

---------------------- KERNEL ENTITY ----------------------------------------------------------------------
Library IEEE;
   Use IEEE.std_logic_1164.all;
Library Work;
  Use work.def.all;
  Use work.UserData.all;
  Use work.CUIcommandData.all;
  Use work.data.all;
  Use work.TimingData.all;
  Use work.StringLib.all;

Entity Kernel_entity is 
  port( 
        VDD                  : in Real;
        Read_Status          : in Status_type;
        Program_Status       : in Status_type;
        Erase_Status         : in Status_type;
        Kernel_Status        : out Status_type;
        Kernel_Report        : in KernelReport_type;
        Kernel_LatchAddress  : in TimeEvent;
        Kernel_VerifyEvent   : out TimeEvent;
        Kernel_ErrorEvent    : in ErrorEvent;

        Read_mode            : out ReadMode_type;
        Reset                : in boolean
      );
end Kernel_entity;

Architecture behavior of Kernel_entity is 
  Begin
  StatusUpDate: Process (Read_Status, Program_Status, Erase_status, Reset) begin
                
                 If (Reset'event and Reset) then 
                               
                               Kernel_Status.message        <= NoError_msg;
                               Kernel_status.busy           <= false;

                  Else 
                       Kernel_Status.busy <= Read_Status.busy or Program_status.busy or Erase_status.busy;
                       Kernel_Status.isError <= Read_Status.isError or Program_status.isError or Erase_status.isError;
                       if  Program_Status'event  then  
                                Kernel_Status.message <= Program_Status.message;  
                       end if;
                       if    Erase_Status'event  then  
                                Kernel_Status.message <= Erase_Status.message;
                       end if;
                       if    Read_Status'event  then  
                                Kernel_Status.message <= Read_Status.message;
                       end if;

                  End If;
  End Process; 

  KernelReport_Process: Process (Kernel_Report) begin 
                        If not(Reset) then
                               Case (Kernel_Report.status) is 
                                     when NoError_msg        => 
                                     when SuspCmd_msg        => 
                                                PrintString(" !Error:   [Invalid Command]  Cannot execute this command during suspend"); 

                                     when SuspAcc_msg        => 
                                                PrintString(" !Error:   [Invalid Command]  Cannot access this address due to suspend"); 
                                                
                                     when InvAddrRange_msg      => 
                                                PrintString(" !Error:   [Invalid Register] Start Address out of range"); 

                                     when AddrTog_msg        => 
                                                PrintString(" !Error:   [Program Buffer]   Cannot change block address during command sequence"); 

                                     when InvVDD_msg         => 
                                                PrintString(" #Warning:   [Invalid Supply]   Voltage Supply must be: VDD>VDDmin or VDD<VDDmax "); 

                                     when InvVPP_msg         => 
                                                PrintString(" !Error:   [Invalid Supply]   VPP out of Range"); 
                                     
                                     when PreProg_msg        => 
                                                PrintString(" !Error:   [Program Failure]  Program Failure due to cell failure"); 

                                     when BlockLockError_msg      => 
                                                PrintString(" !Error: [Locked Error]   Cannot complete operation when the block is locked "); 
                                                Read_Mode.mode <= ReadStatusReg_status;
                                                Read_Mode.eventTime <= now;
                                     when BlockLockDown_msg      => 
                                                PrintString(" !Error: [Locked Error]   Cannot complete operation when the block is Locked Down"); 
                                                Read_Mode.mode <= ReadStatusReg_status;
                                                Read_Mode.eventTime <= now;

                                     when NoBusy_msg         => 
                                                PrintString(" #Warning: [NO Busy]      Device is Not Busy");

                                     when NoSusp_msg         => 
                                                PrintString(" #Warning: [NO Suspend]   Nothing previus suspend command");
                                                
                                     
                                     when WrongReg_msg   => 
                                                PrintString(" #Warning: [Invalid Register]  Addressed Register doesn't exist");
                                                
                                     when NoRegWrite_msg =>
                                                PrintString(" #Warning:   [Invalid Register]  It isn't possible write in this register");
                                     when NoRegRead_msg  =>
                                                PrintString(" !Warning:   [Invalid Register]  It isn't possible read in this register");
                                     when ResetInLoad_msg =>
                                                PrintString(" !Warning:   [Load Failure]     Reset down in Load Data Into Buffer Operation");

                                     when ResetInReadAll1_msg =>
                                                PrintString(" !Warning:   [Read All 1 Failure]     Reset down in Read All 1 Operation");

                                     when ResetInErase_msg =>
                                                PrintString(" !Warning:   [Erase Failure]     Reset down in Erase Operation");
                                     when ResetInProgram_msg =>
                                                PrintString(" !Warning:   [Program Failure]   Reset down in Program Operation");
                                               
                                     when BlockAddrError_msg =>
                                                PrintString(" !Error:   [Invalid Register]  Start Block Address is greater than the End Block Address");
                                                --> ErrorEvent
                                     when StartBlockRegOutOfBound_msg =>
                                                PrintString(" #Warning: [Invalid Register]  Start Block Address Register Out of Bound");
                                     when EndBlockRegOutOfBound_msg =>
                                                PrintString(" #Warning: [Invalid Register]  End Block Address Register Out of Bound");
                                                --> ErrorEvent
                                     when NoUnLockBlock_msg =>
                                                PrintString(" #Warning: [Invalid Operation] Invalid Lock Block command in Locked-Down Block");
                                     when NoLockBlock_msg =>
                                                PrintString(" #Warning: [Invalid Operation] Invalid UnLock Block command in Locked-Down Block");
                                     when NoLockDownBlock_msg =>
                                                PrintString(" #Warning: [Invalid Operation] Invalid Lock-Down Block command in Unlocked Block");
                                     when InvReadID_msg =>
                                                PrintString(" #Warning: [Invalid Operation] Invalid Read ID Address");
                                     when OTPlock_msg        =>
                                                PrintString(" !Error:   [Locked Error]   Cannot complete operation when the OTP is locked "); 
                                     
                                     when resetCDI_msg       =>
                                                PrintString(" #Warning: [Reset in CDI]   Reset command during CDI Query Operation  "); 

                                                
                                     when GENERIC_ERROR_msg  =>
                                                Assert (false)
                                                Severity ERROR;
                                                Report "-- GENERAL ERROR CODE -- Don't Continue";
                                     when Suspend_msg        => 
                                     when Busy_msg           => 
                                     when others =>                
                               End case;
                        
                        end if;
  End Process KernelReport_Process;

                
  ErrorReport: Process(Kernel_ErrorEvent)
               Begin 
                 If Kernel_ErrorEvent='1' Then 
                        PrintString("[" & time2str(now) & "] -- ERROR --- during write bus operation command not recognized" );
                        Kernel_VerifyEvent <= now;
               End if;
  End Process ErrorReport;
End behavior;

-------------------------------------------------------------------------------
--                         READ ENTITY                                       --
-------------------------------------------------------------------------------

Library IEEE;
  Use IEEE.std_logic_1164.all;
  use IEEE.std_logic_arith.conv_std_logic_vector;
Library Work;
  Use work.def.all;
  Use work.UserData.all;
  Use work.TimingData.all;
  Use work.data.all;
  Use work.StringLib.all;
  Use work.BlockLib.all;

Entity Read_entity is 
  port (
        Read_Status              : out Status_type;
        
        DataOutput               : out DataBus_type;
        BlockAddress             : in Address_type;
        Signature_data           : in SignatureData_type;

        Read_Mode                : in ReadMode_type;
        Kernel_ReadEvent         : in  Event;

        Read_task                : in ReadTask_type;
        BlockLock_task           : inout BlockLockTask_type;
        StatusRegister_task      : inout StatusRegisterTask_type;

        Kernel_ReadTaskComplete  : out TimeEvent;
        
        PageBuffer_task          : inout PageBufferTask_type;
        Kernel_PageComplete      : in  TimeEvent;
        
        Kernel_Status            : in    Status_type;
        Kernel_Report            : out   KernelReport_type;
        Kernel_ReadComplete      : out TimeEvent;
        Kernel_BlockLockComplete : inout TimeEvent;
        Kernel_ReadStatusRegComplete : inout TimeEvent;


        Reset                    : in  Boolean
        );
End Read_entity;

Architecture behavior of Read_entity is 
Shared Variable Address   : Address_type;
Shared Variable Column_Address  : Natural;
Shared Variable Page_Address    : Natural;
  Begin
  
  ReadTask:    Process 
               begin 
               wait until Read_Task'event or Reset'event;
               if (reset and reset'event) then
                   Address := (Others =>  '0');
                   Page_Address  := 0;
                   Column_Address := 0;
                   Read_Status.busy <= false;
               Elsif (Read_Task'event) then
                 Case (Read_task.task) is
                   When Cache =>
                     If (mode16bit) then 
                            Page_Address := slv2int(Read_Task.address(16 downto 11));
                            Column_Address := 0;
                        Else 
                            Page_Address := slv2int(Read_task.address(17 downto 12));
                            Column_Address := 0;
                     End if;
                     Read_Status.busy <= true, false after READ_BUSY_time;
                   When RandomDataOutput =>
                   
                     Read_Status.busy <= true, false after READ_BUSY_time;
                     
                   When ReadArray =>
 
                     Read_Status.busy <= true, false after READ_BUSY_time;

                   When ReadInCacheProgram =>
                  
                     Read_Status.busy <= true, false after CACHE_BUSY_time;
                     Read_Status.ProgramMode <= CacheProgram_mode, none_mode after CACHE_BUSY_time;

                   When Others =>
                 End case;
                 Kernel_ReadTaskComplete <= now;
               End if;
  end process ReadTask;
               
  ReadEvent:   Process 
               Variable ReadValue       : DataBus_type;
               Variable latch_Address   : Address_type;
               Variable IndexBuffer     : Natural; 
               Variable Cache           : PageBuffer_type;
               variable signatureCycle  : natural:= 0;
               Begin 
               wait until (Kernel_ReadEvent'event or Reset'event);
               If (reset and reset'event) then 
                       ReadValue := (Others => 'Z');
                       Latch_Address := (Others =>  '0');
                       Kernel_Report.status <= NoError_msg;
               ElsIf (Kernel_ReadEvent'event) then 
                       Case (Read_Mode.mode) is 
                            When ReadArray_status |
                                 RandomDataOutput_status =>

                                       PageBuffer_task.task <= getData;
                                       PageBuffer_task.nPage <= PageBuffer0;
                                       PageBuffer_task.eventTime <= now;
                                               wait until Kernel_PageComplete'event;
                                       ReadValue := to_stdlogicvector(PageBuffer_task.data);
                                       --PrintString("[" & time2str(now) & "]  Read result: " & Str2Hex(Slv2Str(ReadValue)));


                            when ReadStatusReg_status =>


                                ReadValue := to_stdLogicVector(StatusRegister_task.SR);

                        when ReadElectSignature_status =>
                                
                                case signatureCycle is
                                        
                                        when 0 => ReadValue := to_stdLogicVector(Signature_data.ManufacturerCode);
                                        when 1 => ReadValue := to_stdLogicVector(Signature_data.DeviceCode);
                                        when 2 => ReadValue := to_stdLogicVector(Signature_data.ThirdColumn);
                                        when 3 => ReadValue := to_stdLogicVector(Signature_data.FourthColumn);
                                        when others =>

                                end case;
  
                               signatureCycle := signatureCycle + 1;
                               if signatureCycle > 3 then signatureCycle := signatureCycle - 4;
                               end if;

           
                            When Others =>  
                       End Case;
               End If;
               DataOutput <= ReadValue;
  end process ReadEvent;
end behavior;

-------------------------------------------------------------------------------
--                           Page Buffer ENTITY                              --
-------------------------------------------------------------------------------
LIbrary IEEE;
  Use IEEE.std_logic_1164.all;
  Use IEEE.Std_Logic_arith.all;

Library Work;
  Use work.def.all;
  Use work.UserData.all;
  Use work.CUIcommandData.all;
  Use work.data.all;
  Use work.StringLib.all;
  Use work.BlockLib.all;

Entity PageBuffer_entity is 
         Generic(
                  nPage                : Natural := 1
                );
            Port(
                  PageBuffer_task      : inout PageBufferTask_type;
                  Kernel_PageComplete  : out TimeEvent;

                  Memory_Task          : inout MemoryTask_type;
                  Kernel_MemComplete   : in TimeEvent;

                  Kernel_SequentialRowRead : out TimeEvent;
 
                  reset                : in Boolean
                );

End PageBuffer_entity;

Architecture behavior of PageBuffer_entity is 
Constant defaultValue_data : PageBuffer_type := (Others => (Others => '0'));
begin

  Process -- Client Process
     Variable PageBuffer : PageBuffer_type := defaultValue_data;
     Variable Index: Natural range 0 to PageSize_dev-1;
     Variable Len : Natural range 0 to PageSize_dev;
     Variable MemAddress: Natural := 0;
     Variable IndexArea : Natural range 0 to PageSize_dev-1;
     Variable LenArea : Natural range 0 to PageSize_dev-1;
     Variable EndArea : Natural range 0 to PageSize_dev-1;
     Variable EndIndex : Natural range 0 to PageSize_dev-1;
     Variable PointerName : PointerName_type := AreaA;
    Variable  iBlock,newBlock : BlockDim_range;
     begin 
       wait until PageBuffer_task'event or reset'event;
       if (reset'event and reset) then
              PageBuffer := defaultValue_data;
              Index := 0;
              EndIndex := 0;
              MemAddress := 0;
              PointerName := AreaA;
              PageBuffer_task.task<=none;
       elsif (PageBuffer_task'event and nPage=PageBuffer_task.nPage) then 
                    Case (PageBuffer_task.task) is  
                       When None    =>
                       When SetPointer =>
                            IndexArea := PageBuffer_task.IndexArea;
                            LenArea := PageBuffer_task.LenArea;
                            EndArea := PageBuffer_task.EndArea;
                            PointerName := PageBuffer_task.PointerName;
                       When PutAllData =>
                                Index := 0;
                                For i in 0 to PageSize_dev - 1 loop
                                        PageBuffer(i)  := PageBuffer_task.alldata(i); -- test
                                End loop;
                       When GetData =>
                                 PageBuffer_task.data <= PageBuffer(Index + IndexArea);
                                 PageBuffer_task.eventTime <= now + 1 ps;
                                 If Index + IndexArea < PageSize_dev - 1 then 
                                               Index := Index + 1; 
                                 Else
                                         newBlock := getBlock(BlockBoundary, MemAddress + 1024 );
                                         If (newBlock = iBlock) then -- Change Block in Sequential Row Read
                                                
                                                 MemAddress := MemAddress + 1024;

                                                 Memory_task.task       <= getBlock;
                                                 Memory_task.Address    <= MemAddress;
                                                 Memory_task.AddressEnd <= MemAddress + PageSize_dev - 1;
                                                 Memory_task.eventTime <= now;
                                                      wait until Kernel_MemComplete'event;
                                                 for i in 0 to PageSize_dev  - 1 loop
                                                           PageBuffer(i)  := Memory_task.MemBuffer(i); 
                                                 end loop;
                                                 if PointerName = AreaC then 
                                                                Index :=0;
                                                                IndexArea := IndexAreaC;
                                                 else 
                                                                Index := 0;
                                                                IndexArea := 0;
                                                 end if;
                                                 Kernel_SequentialRowRead <= now;
                                         Else 
                                                 PrintString("[" & time2str(now) & "]  Warning Block boundary exceded"); 
                                         End if;
                                         
                                 End if;

                       When PutData =>
                                 if EndIndex < EndArea then 
                                                PageBuffer(IndexArea + EndIndex) := PageBuffer_task.data;
                                                EndIndex := EndIndex + 1;
                                 Len := EndIndex - Index;
                                 end if;
                       When PutMemAddress =>
                                 MemAddress := PageBuffer_task.MemAddress;
                                 iBlock := getBlock(BlockBoundary, MemAddress);
                                 Index := PageBuffer_task.Index;
                                 IndexArea := PageBuffer_task.IndexArea;
                                 LenArea := PageBuffer_task.LenArea;
                                 EndIndex := Index;
                       When ResetLen =>
                                 Index := 0;
                                 Len := 0;
                       When ResetIndex =>
                                 Index := 0;
                       When SetIndex =>
                                 Index := PageBuffer_task.Index;
                       -- Get Block Data from MemAddres with Len: (PageSize_dev - Index);
                       when PutDataFromMemory =>
                             
                                 IndexArea := PageBuffer_task.IndexArea;
                                 Index := PageBuffer_task.Index;
                                                                  MemAddress := PageBuffer_task.MemAddress;
                                 Memory_task.task       <= getBlock;
                                 Memory_task.Address    <= MemAddress;
                                 Memory_task.AddressEnd <= MemAddress + PageSize_dev - 1;
                                 Memory_task.eventTime <= now;
                                    wait until Kernel_MemComplete'event;
                                 for i in 0 to PageSize_dev  - 1 loop
                                      PageBuffer(i)  := Memory_task.MemBuffer(i); 
                                 end loop;
                                 PageBuffer_task.alldata <= PageBuffer;
                                 PageBuffer_task.eventTime <= now + 1 ps;
                                 wait for 1 ps;




                       when PutAllDataFromMemory =>
                                 Index :=PageBuffer_task.Index;
                                 Memory_task.task    <= getBlock;
                                 Memory_task.Address <=  PageBuffer_task.MemAddress;
                                 Memory_task.AddressEnd <= PageBuffer_task.MemAddress + PageSize_dev - 1;
                                 Memory_task.eventTime <= now;
                                    wait until Kernel_MemComplete'event;
                                 for i in 0 to PageSize_dev - 1 loop
                                      PageBuffer(i)  := Memory_task.MemBuffer(i); 
                                 end loop;
                                 PageBuffer_task.alldata <= PageBuffer;
                                 PageBuffer_task.eventTime <= now + 1 ps;
                                 wait for 1 ps;
                                 

                       when PutDataToMemory =>
                            if Len > 0 then 
                                         for i in IndexArea + Index to IndexArea + EndIndex - 1 Loop
                                              Memory_task.MemBuffer(i - IndexArea - Index) <= PageBuffer(i);
                                         end loop;
                                         Memory_task.task       <= putBlock;
                                         Memory_task.Address    <= MemAddress + IndexArea + Index;
                                         Memory_task.AddressEnd <= MemAddress + IndexArea + EndIndex - 1;
                                         Memory_task.eventTime  <= now;
                                            wait until Kernel_MemComplete'event;
                                         wait for 0 ns;
                            end if;
                       when PutAllDataToMemory =>
                                         for i in 0 to PageSize_dev - 1 Loop
                                              Memory_task.MemBuffer(i) <= PageBuffer(i);
                                         end loop;
                                         Memory_task.task       <= putBlock;
                                         Memory_task.Address    <= MemAddress;
                                         Memory_task.AddressEnd <= MemAddress + LenArea - 1;
                                         Memory_task.eventTime  <= now;
                                            wait until Kernel_MemComplete'event;
                                         wait for 0 ns;


                       When Others =>
                             PrintString("+++ General Error +++ Task of Page Buffer Entity not recognized");
                    End Case;
              Kernel_PageComplete <= now;
      end if;               
    End Process;
End behavior;

--------------------------------------------------------------------------------
--                      Mass Memory Entity                                    --
--------------------------------------------------------------------------------
Library IEEE;
  Use IEEE.std_logic_1164.all;
Library Work;
  Use work.def.all;
  Use work.data.all;
  Use work.StringLib.all;
  Use work.MemoryLib.all;

Entity Memory_entity is 
  generic(
        MemoryFileName       : string
        );
  port (
        Memory_Status    : out Status_type;
        Memory_Task      : inout MemoryTask_type;
        Kernel_MemComplete   : out TimeEvent;
        Reset                : in Boolean
        );
End Memory_entity;

Architecture behavior of Memory_entity is 
Begin

  Process 
    Variable Memory  : memory_rec;
    Variable Status      : Status_type;
    Variable address     : AddrMem_type;
    Variable addressEnd  : AddrMem_type;
    Variable iAddr       : AddrMem_type;
    Variable len         : Integer; 
    Variable i           : Natural;
    Variable numData     : Integer;
    Variable data        : DataMem_type;
    Variable dataFFFF    : DataMem_type := (Others => '1' );
    Variable MemBuffer   : MemBuffer_type;
    Variable PowerUp        : Boolean := false;
    Variable isAll1 : Boolean;
    Begin
    if not(PowerUp) then 
                  if (MemoryFileName="") then InitMemory(Memory);
                                         else 
                                              LoadMemoryFile(MemoryFileName, Memory);
                  end if;
                  PowerUp:=true;
    end if;

    wait until Memory_Task'event or Reset'event;
    if (reset) then
               Status.Message := NoError_msg;
    else 
        case Memory_task.task is 
             when put =>
 
                      address := Memory_task.address;
                      getMemory(Memory, address, data);
                      if (data=dataFFFF) then 
                                  data := Memory_task.data;
                                  putMemory(Memory, address, data);
                                  Memory_task.eventTime <= now;
                             else Status.Message:= PreProg_msg;
                      end if;

             when get =>
                      address := Memory_task.address;
                      getMemory(Memory, address, data);
                      Memory_task.data <= data;
                      Memory_task.eventTime <= now + 1 ps;
                      wait for 1 ps;

             when BlockErase =>
                      Address    := Memory_task.address;
                      AddressEnd := Memory_task.addressEnd;
                      if Address > AddressEnd then 
                                  PrintString("+++ General Error +++ in Mass Memory Entity: Address is greater than AddressEnd" );
                         else 
                                  For i in Address to AddressEnd loop
                                   iAddr := i;
                                   putMemory(Memory, iAddr, dataFFFF);
                                  End Loop;
                      end if;
             when getBlock =>
                      Address := Memory_task.address;
                      AddressEnd := Memory_task.addressEnd;
                      Len := AddressEnd - Address + 1;
                      if Address > AddressEnd then 
                                  PrintString("+++ General Error +++ in Mass Memory Entity: Address is greater than AddressEnd" );
                         elsif Len > MemBufferSize_dim then 
                                  PrintString("+++ General Error +++ in Mass Memory Entity: Length of getBlock is greater than MemBufferSize_dim" );
                         else 
                              numData := Len - 1;
                              i:=0;
                              iAddr := Address;
                              while NumData >= 0 loop
                                            getMemory(Memory, iAddr, data);
                                            MemBuffer(i) := data;
                                            if iAddr + 1 > Last_Addr then iAddr := 0;
                                                                     else iAddr := iAddr + 1;
                                            end if;
                                            NumData := NumData - 1;
                                            i := i + 1;
                              end loop;
                                                                
                              Memory_task.MemBuffer <= MemBuffer;
                              Memory_task.eventTime <= now + 1 ps; 
                              wait for 1 ps;
                     end if;
             when putBlock =>
                      Address := Memory_task.address;
                      AddressEnd := Memory_task.addressEnd;
                      Len := AddressEnd - Address + 1;
                      if Address > AddressEnd then 
                                  PrintString("+++ General Error +++ in Mass Memory Entity: Address is greater than AddressEnd" );
                         elsif Len>MemBufferSize_dim then 
                                  PrintString("+++ General Error +++ in Mass Memory Entity: Length of putBlock is greater than MemBufferSize_dim" );
                         else 
                              numData := Len - 1;
                              i:=0;
                              iAddr := Address;
                              MemBuffer := Memory_task.MemBuffer;
                              while NumData >= 0 loop
                                            putMemory(Memory, iAddr, MemBuffer(i));
                                            if iAddr + 1 > Last_Addr then iAddr := 0;
                                                                     else iAddr := iAddr + 1;
                                            end if;
                                            NumData := NumData - 1;
                                            i := i + 1;
                              end loop;
                                                                
                              Memory_task.MemBuffer <= MemBuffer;
                              Memory_task.eventTime <= now + 1 ps; 
                              wait for 1 ps;
                     end if;
             when readIFall1 => 
                      Address := Memory_task.address;
                      AddressEnd := Memory_task.addressEnd;
                      Len := AddressEnd - Address + 1;
                      if Address > AddressEnd then 
                                  PrintString("+++ General Error +++ in Mass Memory Entity: Address is greater than AddressEnd" );
                         else 
                              for i in Address to AddressEnd loop
                                       iAddr := i;
                                       getMemory(Memory, iAddr, data);
                                       if (data/=dataFFFF) then exit;end if;
                              end loop;
                              if (data/=dataFFFF) then isAll1:= false;
                                                  else isAll1:= true;
                              end if;
                      Memory_task.AddressEnd <= iAddr;
                      Memory_task.isAll1 <= isAll1;
                      Memory_task.eventTime <= now + 1 ps; 
                      wait for 1 ps;
                      end if;

             when load =>
             when save =>
             when printList =>
                      PrintList(Memory);
             when printData =>
                      PrintData(address, data);
             when others =>
        end case;
    Memory_Status <= Status;  
    Kernel_MemComplete <= now;
 
    end if;
  End Process;
End behavior;
-------------------------------------------------------------------------------
--                      Program Entity                                       --
-------------------------------------------------------------------------------
Library IEEE;
  Use IEEE.std_logic_1164.all;
Library Work;
  Use work.def.all;
  Use work.data.all;
  Use work.TimingData.all;
  Use work.StringLib.all;
  Use work.MemoryLib.all;
  Use work.BlockLib.all; 

Entity Program_entity is 
  port (
        Program_Status          : out   Status_type;
        Program_Task            : inout ProgramTask_type;

        BlockLock_task          : inout BlockLockTask_type;
        Kernel_BlockLockComplete: in TimeEvent;

        PageBuffer_task         : inout PageBufferTask_type;
        Kernel_PageComplete     : in TimeEvent;
        
        Vdd_check               : in Boolean;
        Kernel_CUIcommand       : in Event;
        Reset                   : in Boolean
        );
End Program_entity;
  
Architecture behavior of Program_entity is 
        Function EventTimeGuarded(V: vectorTimeEvent_type) Return TimeEvent is
        Variable i:Integer;
        Variable big : Time;
          Begin 
          big := V(V'LOW);
          For i in V'range Loop
              If V(i)>big Then 
                        big:=V(i);
                      End If;
          End Loop;
        Return big; 
        end Function; 

  Signal Program_Event            : boolean := false;
  Signal ErrorCheck_Event         : boolean := false;
  Signal ErrorCheckDisable_Event  : EventTimeGuarded TimeEvent register := 0 ns;

  Shared Variable hold_address    : AddrMem_type;
  Shared Variable Busy            : boolean := false;

  Shared Variable isError         : boolean := false;
  -- Variable for program
  Shared Variable isBlockProtect  : boolean := false;
  Shared Variable Status          : message_type := NoError_msg;
  Shared Variable ProgramMode     : ProgramMode_type;
  Shared Variable PageBuffer      : Natural ;
  Begin

ProgramTask_process :  Process
  Variable startProgramTime : time := 0 ns;
  Variable delayProgramTime : time := 0 ns;
    begin
    wait until (Program_Task'event);

             Case (Program_Task.task) is

                  When PageProgram =>
                  
                       ProgramMode := PageProgram_mode;
                       
                       hold_address := Program_task.address;
                       
                       Busy := True;
                       isError := False;
                       Status := Busy_msg;
                       startProgramTime := now;
                       delayProgramTime := Program_time; 
                       Program_Event    <= not(Program_Event) after delayProgramTime; 
                       ErrorCheck_event <= not ErrorCheck_event;

                  When CacheProgram =>

                       ProgramMode := CacheProgram_mode;
                       
                       hold_address := Program_task.address;
                       PageBuffer   := Program_task.PageBuffer;

                       Busy := True;
                       isError := False;
                       Status := Busy_msg;
                       startProgramTime := now;
                       delayProgramTime := Program_time; 
                       Program_Event    <= not(Program_Event) after delayProgramTime; 
                       ErrorCheck_event <= not ErrorCheck_event;

                  When CopyBackProgram =>

                       ProgramMode := CopyBackProgram_mode;
                       
                       hold_address := Program_task.address;
                       Busy := True;
                       isError := False;
                       Status := Busy_msg;
                       startProgramTime := now;
                       delayProgramTime := Program_time; 
                       Program_Event    <= not(Program_Event) after delayProgramTime; 
                       ErrorCheck_event <= not ErrorCheck_event;

                  When Others =>
                  End Case;
    End process ProgramTask_process;

    Program_process: Process 
      Variable startAddrMMI, endAddrMMI    : AddrMem_type;

      begin
      wait until (Program_Event'event  or Reset'event);
      if (reset'event and not(reset))  then
             Status := NoError_msg;
             hold_address := 0;
             busy:=false;
             isError := False;
             ProgramMode := none_mode;
      elsif (Program_Event'event and Status = Busy_msg) then  -- Program
             case (ProgramMode) is
                  when PageProgram_mode => 
                          PageBuffer_task.task <= PutDataToMemory;
                          PageBuffer_task.nPage <= 0;
                          PageBuffer_task.eventTime <= now; -- NP
                                 wait until Kernel_PageComplete'event;
                          wait for 1 ps;
                 

                  when CacheProgram_mode => 
                             PageBuffer_task.task <= PutDataToMemory;
                             PageBuffer_task.nPage <= PageBuffer;
                             PageBuffer_task.eventTime <= now; -- NP
                                 wait until Kernel_PageComplete'event;
                             wait for 1 ps;
                             
                  when CopyBackProgram_mode => 
                             PageBuffer_task.task <= PutAllDataToMemory;
                             PageBuffer_task.nPage <= 0;
                             PageBuffer_task.eventTime <= now; -- NP
                                 wait until Kernel_PageComplete'event;
                             wait for 1 ps;
                             
                  when Others => 
             end case; 
           ProgramMode := none_mode;
           isError := false;
           ErrorCheckDisable_event <= now;
      end if;
    End Process Program_process; 
    
    ErrorCheck_Process: Process
    Variable isNextOption_check:Boolean ;
    
      begin 
      wait until (ErrorCheck_event'event or Kernel_CUIcommand'event or Reset'event);
         if ((reset'event) and not(reset))  then
             Status := NoError_msg;
             hold_address := 0;
             busy:=false;
             isError := False;
             ProgramMode := none_mode;
             
         elsif  Kernel_CUIcommand'Event then 

             isError := False;
             Status  := NoError_msg;

         elsif (ErrorCheck_event'event) then 
                  BlockLock_task.task <= getStatusByAddress;
                  BlockLock_task.address <= hold_address;
                  BlockLock_task.eventTime <= now;

                  wait until Kernel_BlockLockComplete'event;
--********************************************************************************                   
                  isBlockProtect:=not(BlockLock_task.isUnLocked); --******************************************************************************** 
--********************************************************************************                   
              
                  if (isBlockProtect) then
                        Status := BlockLockError_msg;
                        isError := true;
                  else 
--                    program is ongoing
                      If (Status=Busy_msg) then 

                            Program_Status.message    <= Status;
                            Program_Status.busy       <= busy;
                            Program_Status.isError    <= isError;
                            Program_Status.ProgramMode <= ProgramMode;
                        
                            wait until reset'event or ErrorCheckDisable_event'event or Vdd_check'event;
                            if Vdd_check'event then 
                                Status := InvVpp_msg;
                            end if;
                            if Reset'event then 
                                 isNextOption_check := false;
                                 Status:=NoError_msg;
                            end if;
                            if ErrorCheckDisable_event'event then
                                        if Status=Busy_msg then -- Program Complete
                                                Status := NoError_msg;
                                        end if; 
                            end if;
                         end if;
                      End if;
            If Status/=Busy_msg then busy:=false; end if;
        
            if Status=NoError_msg then -- Program Complete
            end if; -- end reset
        end if; -- Reset Event
      Program_Status.busy        <= busy;
      Program_Status.ProgramMode <= ProgramMode;
      Program_Status.isError     <= isError;
      Program_Status.Message     <= Status;
      end Process ErrorCheck_Process;
end behavior;

--------------------------------------------------------------------------------
--                      Erase Entity                                          --
--------------------------------------------------------------------------------

Library IEEE;
  Use IEEE.std_logic_1164.all;
  
Library Work;
  Use work.def.all;
  Use work.data.all;
  Use work.TimingData.all;
  Use work.StringLib.all;
  Use work.MemoryLib.all;
  Use work.BlockLib.all;
  

----------------------
--
--  Erase Entity
--
----------------------

Entity Erase_entity is 
  Port (
        Erase_Status                 : out Status_type;
        Erase_Task                   : inout EraseTask_type;
        Memory_Task                  : inout MemoryTask_type;
        Kernel_MemComplete           : in TimeEvent;
        BlockLock_task               : inout BlockLockTask_type;
        Kernel_BlockLockComplete     : in TimeEvent;
        Kernel_CUIcommand            : in Event;
        Kernel_Report                : out KernelReport_type;
        Reset                : in Boolean
        );
End Erase_entity;
  
Architecture behavior of Erase_entity is 

  Function EventTimeGuarded(V: vectorTimeEvent_type) Return TimeEvent is
  
        Variable i:Integer;
        Variable big : Time;
  
        Begin 
          
          big := V(V'LOW);
          For i in V'range Loop
              If V(i)>big Then 
                        big:=V(i);
              End If;
          End Loop;
        Return big; 
   end Function; 

  type protectStatus_type is array(BlockDim_range) of Boolean;
  Signal Erase_Event              : boolean := false;
  Signal ErrorCheck_Event         : boolean := false;
  signal RestoreDefaults_event    : boolean := false;
  Signal ErrorCheckDisable_Event  : EventTimeGuarded TimeEvent register := 0 ns;
  Signal Message                  : message_type;

  Shared Variable Error_Event     : boolean := false;
  Shared Variable Busy            : boolean := false;
  Shared Variable isError         : boolean := false;
  Shared Variable Successful      : boolean := false;
  Shared Variable isResetEvent    : boolean := false;
  Shared Variable Erase_cmd       : EraseTaskName_type := none;
  Shared Variable HoldAddress     : AddrMem_type := 0;
  Shared Variable BlockStartAddress : AddrMem_type := 0;
  Shared Variable BlockEndAddress   : AddrMem_type := 0;

  Shared Variable HoldBlock_Start : BlockDim_range := 0;
  Shared Variable HoldBlock_End : BlockDim_range := 0;   
  shared Variable HoldBlock_protectStatus : protectStatus_type;
 
  Shared Variable hold_data       : DataMem_type := (Others =>  '0');
  Shared Variable startTime       : time := 0 ns;
  Shared Variable delayTime       : time := Erase_time;
  Shared Variable isBlockProtect  : boolean := false;
  shared Variable isBlockError    : Boolean := false;
  Shared Variable isStartBlockWrong : Boolean := false;
  Shared Variable isEndBlockWrong : Boolean := false;
  Shared Variable Status          : message_type := NoError_msg;
  Shared Variable numBlock        : Integer:= 0;
  
  Begin
  
  Process
    begin
    wait until (Erase_Task'event);
    
          Case (Erase_Task.task) is
          
                  When BlockErase =>
                       Successful:=false;
                         Erase_cmd := BlockErase;
                         isEndBlockWrong := false;
                         numBlock:= Erase_task.BlockNumber;
                         if (numBlock > last_Block or numBlock < first_Block) then
                            isStartBlockWrong := true;
                         else 
                            isStartBlockWrong := false;
                            BlockStartAddress := getAddrBlockStartbyNumber(BlockBoundary, numBlock);
                            BlockEndAddress   := getAddrBlockEndByNumber(BlockBoundary, numBlock);
                            startTime := now;
                                               ----------------------   Error Check : The block is protect ??
                            BlockLock_task.task <= getStatusByBlock;
                            BlockLock_task.startBlock <= numBlock;
                            BlockLock_task.eventTime <= now;
                                 wait until Kernel_BlockLockComplete'event;
                            isBlockProtect := not(BlockLock_task.isUnLocked);

                            if not(isBlockProtect) then 
                               
                               Busy    := True;
                               isError := false;
                               Status  := Busy_msg;
                               
                               Erase_Event <= not(Erase_Event) after Erase_time; 

                            
                            end if;
                         end if;
                         ErrorCheck_event <= not ErrorCheck_event;
                  When Others =>
                  End Case;
    End process;

    Erase_process: Process 
    Variable temp_Data : DataMem_type;
    Variable isBlockUnProtect : Boolean ;
    Variable tElaps : time;
    begin
    wait until (Erase_Event'event);
    
    if (Status = Busy_msg and not(isResetEvent)) then -- no error found  
          if (erase_cmd = BlockErase) then 
                  Memory_task.task       <= BlockErase;
                  Memory_task.address    <= BlockStartAddress;
                  Memory_task.addressEnd <= BlockEndAddress;
                  Memory_task.eventTime  <= now;
                      Wait Until Kernel_MemComplete'event;
                  busy:=false;
                  ErrorCheckDisable_event <= now;
          end if;
   end if;
   End Process Erase_process; 
    
ErrorCheck_Process: Process
begin 

        wait until ErrorCheck_event'event or RestoreDefaults_event'event or Kernel_CUIcommand or Reset'event;  -- or disableOp'event or Kernel_CUIcommand'event;
        if Kernel_CUIcommand'event then 
            isError := false;
            Status := NoError_msg;


        elsif ((Reset'event) and Reset)  then
                        Erase_cmd := none;
                        Status := NoError_msg;
                        busy:=false;
                        isError   := false;
                        Successful:=false;

                        HoldAddress := 0;
                        BlockStartAddress := 0;
                        BlockEndAddress := 0;
                        startTime := 0 ns; 
                        delayTime := Erase_time;


                elsif (ErrorCheck_event'event) then
                        --if (Status = Busy_msg) then
                                if (isBlockProtect) then 
                                        Status := BlockLockError_msg;
                                        isError := true;
                                elsif (isBlockError) then 
                                        Status := BlockAddrError_msg;
                                        isError := true;
                                elsif (isStartBlockWrong) then 
                                        Status := StartBlockRegOutOfBound_msg;
                                        isError := true;
                                elsif (isEndBlockWrong) then 
                                        Status := EndBlockRegOutOfBound_msg;
                                        isError := true;
                                else 
                                        if (Status=Busy_msg) then 
                                                Erase_Status.message <= Status;
                                                message              <= Status;
                                                Erase_Status.busy <= busy;
                                                Erase_Status.isError <= isError;
                                                Erase_Status.Successful<= Successful;
                                                isResetEvent:=false;
                                                wait until Reset'event or ErrorCheckDisable_event'event; --or VppRange_check'event;  

                                                --wait until disableOp'event or reset'event or ErrorCheckDisable_event'event; --or VppRange_check'event;  

                                                if (Reset'event and Reset) then 
                                                
                                                        isError :=false;
                                                        Status  :=NoError_msg;
                                                        Busy    := false;
                                                end if;
                                                If ErrorCheckDisable_event'event then
                                                        isError:=false;
                                                        if Status = Busy_msg  then --and not(Suspended) then 
                                           
                                                                Status     := NoError_msg; 
                                                                Successful := true;
                                                        end if; -- Erase Complete
                                                End if;
                                        End if;
                                --End if;
           --end if;
                              end if;
      end if;
      Erase_Status.busy       <= busy;
      Erase_Status.isError    <= isError; 
      Erase_Status.Successful <= Successful; 
      Erase_status.message    <= status;
    --end if;-- end Kernel_CUIcommand
    
    end Process ErrorCheck_Process;
end behavior;
-------------------------------------------------------------------------------
--                          Block Lock ENTITY                                --
-------------------------------------------------------------------------------
LIbrary IEEE;
  Use IEEE.std_logic_1164.all;
  Use IEEE.Std_Logic_arith.all;

Library Work;
  Use work.def.all;
  Use work.CUIcommandData.all;
  Use work.data.all;
  Use work.StringLib.all;
  Use work.BlockLib.all;

Entity BlockLock_entity is 
            Port(
                  BlockLock_task           : inout BlockLockTask_type;
                  Kernel_BlockLockComplete : out TimeEvent;
                  BlockLock_status         : out status_type;
                  WriteProtect             : in std_logic;
                  SetBlocks                : in TimeEvent;
                  BlockMode_on             : in boolean;
                  Reset                    : in Boolean
                );
End BlockLock_entity;

Architecture behavior of BlockLock_entity is 

-- Default Value of Start Block Address after power-up or Hardware/Software Reset
Type BlockLock_type is array (BlockDim_range) of Lock_type;

Constant Default_StartBlockAddress : Natural := 0; 
signal init                     : Boolean := true;
signal WP_check                    : boolean := false;
shared variable BlockLockArray        : BlockLock_type;
shared variable allUnlock      : boolean := false;

begin

  Set_blocks : Process (SetBlocks)

  begin

        --if not Powerup then 
        if BlockMode_on then 

                        for iBlock in BlockLockArray'range loop 
                                BlockLockArray(iBlock) :=  LOCK;  -- All Blocks are locked at power-up
                                allUnlock := false;
                        end loop;
                        
                else 
                        for iBlock in BlockLockArray'range loop 
                                BlockLockArray(iBlock) :=  UNLOCK;  -- All Blocks are un-locked at power-up
                                 allUnlock:= true;
                        end loop;

                end if;


  end process Set_blocks;

  Process (BlockLock_task, WriteProtect, Reset)
  
  Variable iBlock, j             : BlockDim_range;
  Variable startBlock, endBlock  : BlockDim_range;
  Variable Status                : Message_type := NoError_msg;
  variable isError               : boolean := false;
  variable WP_LowEvent           : TimeEvent := 0 ns;
  variable WP_delay              : time := 100 ns;
  

  Begin 
        if (init) then  
        
                      initBlock(BlockBoundary);
                      
                      
                      init <= false;
        
        
        elsif (WriteProtect'event and WriteProtect = '0') then

                if BlockMode_on then
                
                        for iBlock in BlockLockArray'range loop 
                        
                                if BlockLockArray(iBlock) = UNLOCK then 
                                
                                        BlockLockArray(iBlock) := LOCK;    -- All Blocks are locked when WP_N is Low
                                end if;

                                allUnlock:= false;
                                
                        end loop; 
                end if;        

                WP_LowEvent := now;
                WP_check <= not WP_check after WP_delay;
                
        elsif (Reset'event and Reset = true) then

         else 
         
              Case (BlockLock_task.task) is  
              
              When None    =>

               When getStatusByBlock =>
                       
                        iBlock := BlockLock_task.startBlock;
               
                        if (iBlock > last_Block or iBlock < first_Block) then
                                  PrintString("+++ General Error +++ in Block Lock Entity: BlockNumber out of bound" );
                                  Status := BlockAddrError_msg;
                                  isError := true;

                        else 

                                  BlockLock_task.currentStatus <= BlockLockArray(iBlock);

                                  if (BlockLockArray(iBlock) = UNLOCK) then BlockLock_task.isUnLocked <= true;
                              
                                  else BlockLock_task.isUnLocked <= false;
                              
                                  end if;
                              
                                  BlockLock_task.eventTime <= now + 1 ps;
                              
                         end if;

               When getStatusByAddress =>
                       
                        iBlock := getBlock(BlockBoundary, BlockLock_task.address);
               
                        if (iBlock > last_Block or iBlock < first_Block) then
                                  PrintString("+++ General Error +++ in Block Lock Entity: BlockNumber out of bound" );
                                  Status := BlockAddrError_msg;
                                  isError := true;

                        else 

                                  BlockLock_task.currentStatus <= BlockLockArray(iBlock);

                                  if (BlockLockArray(iBlock) = UNLOCK) then BlockLock_task.isUnLocked <= true;
                              
                                  else BlockLock_task.isUnLocked <= false;
                              
                                  end if;
                              
                                  BlockLock_task.eventTime <= now + 1 ps;
                              
                         end if;

                When putUnLock =>   -- Unlock a sequence of Blocks
                
                        if BlockMode_on then 
                                
                                startBlock := BlockLock_task.startBlock;
                                endBlock   := BlockLock_task.endBlock;

                                if (startBlock > endBlock) then 
                                        
                                        PrintString("+++ General Error +++ in Block UnLock Command : startBlock is greater than endBlock" );
                                        Status := BlockAddrError_msg;
                                        isError:= true;

                                else 

                                        for iBlock in startBlock to endBlock loop
                         
                                                If BlockLockArray(iBlock) = LOCK then 
                                
                                                        BlockLockArray(iBlock) := UNLOCK; 
                                                        PrintString("[" & time2str(now) & "]  Block Lock Update: Block[" & int2str(iBlock) & "] => UnLocked ") ;
                                
                                                end if;
                         
                                        end loop;

                                       if (startBlock = first_block and endBlock = last_block) then allUnlock := true;
                                       else allUnlock := false;
                                       end if;
                                end if;        
                         else              -- not in BlockMode
                                PrintString("[" & time2str(now) & "]  Block Lock Error: Device not in Block Lock Mode") ;
                                Status:= LockModeError_msg;
                                isError:= true;

                         end if;


                When putLock =>   -- Lock all blocks

                        if BlockMode_on then 

                                for iBlock in BlockLockArray'range loop
                         
                                        If BlockLockArray(iBlock) = UNLOCK then 
                                        
                                                BlockLockArray(iBlock) := LOCK;
                                
                                        end if;
                         
                                end loop;

                                allUnlock := false;

                         else              -- not in BlockMode
                                PrintString("[" & time2str(now) & "]  Block Lock Error: Device not in Block Lock Mode") ;
                                Status:= LockModeError_msg;
                                isError:= true;

                         end if;
     
                 When putLockDown =>   -- Lock Down all locked blocks (???)
                       
                          if BlockMode_on then 

                                for iBlock in BlockLockArray'range loop
                         
                                        If BlockLockArray(iBlock) = LOCK then 
                                                
                                                BlockLockArray(iBlock) := LOCKDOWN;
                                                PrintString("[" & time2str(now) & "]  Block Lock Update: Block[" & int2str(iBlock) & "] => Locked Down") ;
                                                allUnlock := false;
                                
                                        elsif (BlockLockArray(iBlock) = UNLOCK and not allUnlock) then 
                                                
                                                BlockLockArray(iBlock) := UNLOCKDOWN;
                                                PrintString("[" & time2str(now) & "]  Block Lock Update: Block[" & int2str(iBlock) & "] => UnLocked Down") ;
                                                allUnlock:= false;

                                        end if;

                                end loop;
                                
                        else              -- not in BlockMode
                                PrintString("[" & time2str(now) & "]  Block Lock Error: Device not in Block Lock Mode") ;
                                Status:= LockModeError_msg;
                                isError:= true;

                        end if;


                  When Others =>

                             PrintString("+++ General Error +++ Task of BlockLock Entity not recognized");
                             Status := GENERIC_ERROR_msg;
                             isError:= true;

              End Case;
              
              Kernel_BlockLockComplete  <= now;
              
              BlockLock_status.Message  <= Status;
              BlockLock_status.isError  <= isError;
      
      end if;
      
    End Process;

 
   WPlow_Process : process
   begin

        wait until WP_check'event;

                if WriteProtect = '0' then  -- WP_N is 0 for 100 ns

                        for iBlock in BlockLockArray'range loop 
                        
                                if BlockLockArray(iBlock) = LOCKDOWN then 
                                
                                        BlockLockArray(iBlock) := LOCK;    -- All Blocks are locked when WP_N is Low
                                        
                                elsif BlockLockArray(iBlock) = UNLOCKDOWN then 
                                
                                        BlockLockArray(iBlock) := UNLOCK;    -- All Blocks are locked when WP_N is Low

                                end if;
                        end loop; 

                        allUnlock := false;

                end if;

   end process WPlow_Process;
 

End behavior;

--------------------------------------------------------------------------------
--                      Status Register Entity                                --
--------------------------------------------------------------------------------
Library IEEE;
  Use IEEE.std_logic_1164.all;

Library Work;
  Use work.def.all;
  Use work.data.all;
  Use work.StringLib.all;
  
Entity StatusRegister_entity is 
  port (
        Kernel_status        : in Status_type;
        Program_status       : in Status_type;
        Read_status          : in Status_type;
        Kernel_ReadStatusRegComplete : out TimeEvent;
        StatusRegister_task  : inout StatusRegisterTask_type;
        --ExtStatusReg_device  : natural;
        Kernel_CUIcommand            : in Event;
        Reset        : in Boolean

        );
End StatusRegister_entity;
  
Architecture behavior of StatusRegister_entity is 

  Signal SR_reg : DataReg_type;
  --signal SR_vett : SRregVett_type;

  Signal WriteProtectionBit     : bit;        -- SR7
  Signal PERCacheRBBit          : bit;        -- SR6
  Signal PERControllerBit       : bit;        -- SR5
                                              -- SR4, SR3 and SR2 are reserved
  Signal CacheProgramErrorBit   : bit;        -- SR1
  Signal ErrorBit               : bit;        -- SR0

  signal afterReset             : boolean := false;
  
  Begin

  SR_reg <= (   7 => WriteProtectionBit,
                6 => PERCacheRBBit,
                5 => PERControllerBit,
                1 => CacheProgramErrorBit,
                0 => ErrorBit,
            Others =>  '0'
            );

  StatusTask_process : process 
  begin

        wait until SR_reg'event;

--        PrintString("[" & time2str(now) & "]  Status Register Update: " & slv2str(to_stdlogicvector(SR_reg)) & "; hex = " & slv2hex(to_stdlogicvector(SR_reg)));
                    
        StatusRegister_task.task <= UpDateRegister;
        StatusRegister_task.SR <= SR_reg;
        
        StatusRegister_task.eventTime <= now;

  end process StatusTask_process;
  

  main_process : process (Reset, Kernel_Status)

  begin

        if (Reset'event) then 
                if Reset then 

                    WriteProtectionBit   <= '0';         -- device protected during power-up
                    PERCacheRBBit        <= '0';         -- device busy during power-up
                    PERControllerBit     <= '0';         -- device busy during power-up
                    CacheProgramErrorBit <= '0';
                    ErrorBit             <= '0';
                
                else     --after Reset

                    WriteProtectionBit   <= '1';         -- device not protected after power-up
                    PERCacheRBBit        <= '1';         -- device not busy after power-up
                    PERControllerBit     <= '1';         -- device not busy after power-up
                    CacheProgramErrorBit <= '0';
                    ErrorBit             <= '0';

                    afterReset  <= true;
                    
                end if;
        else 
        
                if afterReset then
        
                        if (Kernel_status.isError'event and Kernel_status.isError) then 
                      
                                ErrorBit  <= '1';

                        else                 -- NO ERROR
                        
                                ErrorBit  <= '0';
                                
                                if (Program_Status.ProgramMode = CacheProgram_Mode or Read_Status.ProgramMode = CacheProgram_Mode) then 

                                        if (Read_Status.busy)  then 
                                                PERCacheRBBit     <= '0';  -- Read busy -- SR6 --
                                        else 
                                                PERCacheRBBit     <= '1';  -- Read Ready
                                        end if;

                                        if (Program_Status.busy)  then 
                                                PERControllerBit  <= '0';  -- Program Busy -- SR5 --
                                        else 
                                                PERControllerBit  <= '1';  -- Program Ready 
                                        end if;

                                   
                                else 
                                        if (Kernel_status.busy)  then 
                                                PERCacheRBBit     <= '0';   -- device busy
                                                PERControllerBit  <= '0';
                                        else 
                                                PERCacheRBBit     <= '1';   -- device ready
                                                PERControllerBit  <= '1';
                                        end if;

                                end if;
                        end if;
                end if;
        end if;
  
  end process main_process;

  
End behavior;
-- =============================================================
--                                                            --
--             Electronic Signature ENTITY                    --
--                                                            --
--   This Entity implements the Electronic Signature Command  --
--                                                            --
-- =============================================================


-----------------------------
---   Utility Libraries   ---
-----------------------------

LIbrary IEEE;
  Use IEEE.std_logic_1164.all;
  Use IEEE.Std_Logic_arith.all;
  Use IEEE.Std_logic_unsigned.all;

Library Work;
  Use work.def.all;
  Use work.CUIcommandData.all;
  Use work.data.all;
  use work.Userdata.all;
  Use work.TimingData.all;
  Use work.StringLib.all;
  
  
-------------------------------------
---  Entity Electronic Signature  ---
-------------------------------------

Entity ElectronicSignature_entity is 
       port(

            Signature_data               : out SignatureData_type;
            reset                        : in    Boolean
       );
End ElectronicSignature_entity;


------------------------------------------
-----  Architecture of the Entity  -------
------------------------------------------

Architecture behavior of ElectronicSignature_entity is 

Constant ManufacturerCode : DataMem_type := X"20";
Constant ThirdColumn      : DataMem_type := X"00";

signal PowerUp : boolean := false;

Begin 

  --------------------------
  ----   Main Process   ----
  --------------------------

  init_process : Process (PowerUp)

  variable Device         : DataMem_type;
  variable FourthColumn   : DataMem_type;
 
  Begin
    
        if not PowerUp then 
        
                Signature_data.ManufacturerCode  <= ManufacturerCode;
                Signature_data.DeviceCode        <= SignatureTab (DeviceName, 0);
                Signature_data.ThirdColumn       <= ThirdColumn;
                Signature_data.FourthColumn      <= SignatureTab (DeviceName, 1);
                Signature_data.Device            <= DeviceName;

                PowerUp <= true;
                
        end if;
                      
  End Process init_process;
  
End behavior;
