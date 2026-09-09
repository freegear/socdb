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
Library IEEE;
   use IEEE.std_logic_1164.all;

Package CUIcommandData is

-----------  Table of Commands  ---------------------

type Command_Type is (None, 
                      ReadA_cmd, ReadB_cmd, ReadC_cmd,
                      ReadElectronicSignature_cmd, ReadStatusRegister_cmd , 
                      PageProgramCmdCode_cmd, PageProgramCfmCode_cmd, 
                      CopyBackProgramCfmCode_cmd,
                      BlockErase_cmd,
                      Reset_cmd
                     ); 
                                            
Constant ADDRCMD: natural := 8;  -- bit
Constant ADDRCMD_hex: natural := ADDRCMD/4;
SubType  ADDRCMD_range is natural range ADDRCMD - 1 downto 0;
SubType  ADDRCMDhex_range is natural range 1 to ADDRCMD_hex;

Constant command_subsequence : integer := 5;
 
Type seqAddr_type is Array(1 to command_subsequence) of  String(ADDRCMDhex_range);

Type vectorCommand_type is array (Integer range <>) of Command_type;

-- ================ Register Interface Command ============= --

--------------   Read Command ----------------
Constant ReadA_seqAddr: seqAddr_type:= ("00", "XX", "XX", "XX", "XX");
Constant ReadA_CmdLen: Integer:= 1;
--------------   Read Command ----------------
Constant ReadB_seqAddr: seqAddr_type:= ("01", "XX", "XX", "XX", "XX");
Constant ReadB_CmdLen: Integer:= 1;
--------------   Read Command ----------------
Constant ReadC_seqAddr: seqAddr_type:= ("50", "XX", "XX", "XX", "XX");
Constant ReadC_CmdLen: Integer:= 1;

--------------   Command  ----------------
Constant ReadElectronicSignature_seqAddr: seqAddr_type:= ("90", "XX", "XX", "XX", "XX");
Constant ReadElectronicSignature_CmdLen: Integer:= 1;

--------------   Command  ----------------
Constant ReadStatusRegister_seqAddr: seqAddr_type:= ("70", "XX", "XX", "XX", "XX");
Constant ReadStatusRegister_CmdLen: Integer:= 1;

--------------   Command  ----------------
Constant PageProgramCmdCode_seqAddr: seqAddr_type:= ("80", "XX", "XX", "XX", "XX");
Constant PageProgramCmdCode_CmdLen: Integer:= 1;

--------------   Command  ----------------
Constant PageProgramCfmCode_seqAddr: seqAddr_type:= ("10", "XX", "XX", "XX", "XX");
Constant PageProgramCfmCode_CmdLen: Integer:= 1;

--------------   Command  ----------------
Constant CopyBackProgramCfmCode_seqAddr: seqAddr_type:= ("8A", "XX", "XX", "XX", "XX" );
Constant CopyBackProgramCfmCode_CmdLen: Integer:= 1;

--------------   Command  ----------------
Constant BlockErase_seqAddr: seqAddr_type:= ("60", "D0", "XX", "XX", "XX");
Constant BlockErase_CmdLen: Integer:= 2;

--------------   Command  ----------------
Constant Reset_seqAddr: seqAddr_type:= ("FF", "XX", "XX", "XX", "XX");
Constant Reset_CmdLen: Integer:= 1 ;


end CUIcommandData;
 

Package body CUIcommandData is

          ---------  The body is empty  -----------

end CUIcommandData;
