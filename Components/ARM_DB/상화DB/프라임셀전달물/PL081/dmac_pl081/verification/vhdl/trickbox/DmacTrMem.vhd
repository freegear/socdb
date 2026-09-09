-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacTrMem.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This block mimics a Memory Interface on the AHB bus.
--
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.DmacTrPackage.all;

-- -----------------------------------------------------------------------------

entity DmacTrMem is
  port (
-- Inputs
        HCLK             : in    std_logic; -- AHB Clock
        HRESETn          : in    std_logic; -- AHB Reset
        HADDR            : in    std_logic_vector
                                            (SLAVEADDRHB downto SLAVEADDRLB);
                                            -- Register Address
        HSELREG          : in    std_logic; -- Register Select
        HWRITE           : in    std_logic; -- Register Read/Write
        HTRANS           : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on
                                            -- Register interface
        HSIZE            : in    std_logic_vector(2 downto 0);
                                            -- The width of the
                                            -- register data transfer
        HWDATA           : in    std_logic_vector(31 downto 0);
                                            -- Register Write Data
        HREADYIN         : in    std_logic; -- Ready response
                                            -- to register interface
        HADDRM           : in    std_logic_vector
                                            (MASTERADDRHB downto MASTERADDRLB);
                                            -- Memory Address
        HSELMEM          : in    std_logic; -- Memory Select
        HWRITEM          : in    std_logic; -- Memory Read/Write
        HTRANSM          : in    std_logic_vector(1 downto 0);
                                            -- Type of transfer on
                                            -- Memory Interface
        HBURSTM          : in    std_logic_vector(2 downto 0);
                                            -- Type of AHB Burst on
                                            -- Memory Interface
        HSIZEM           : in    std_logic_vector(2 downto 0);
                                            -- The width of the
                                            -- transfer on Memory
                                            -- Interface
        HWDATAM          : in    std_logic_vector(31 downto 0);
                                            -- Memory Write Data
        HREADYINM        : in    std_logic; -- Ready response to
                                            -- Memory interface

-- Outputs
        HREADYOUT        : out   std_logic; -- Ready response from
                                            -- Register interface
        HRESP            : out   std_logic_vector(1 downto 0);
                                            -- Transfer response from
                                            -- Register interface
        HRDATA           : out   std_logic_vector(31 downto 0);
                                            -- Register read Data
        HREADYOUTM       : out   std_logic; -- Ready response from
                                            -- Memory interface
        HRESPM           : out   std_logic_vector(1 downto 0);
                                            -- Transfer response from
                                            -- Memory interface
        HRDATAM          : out   std_logic_vector(31 downto 0)
                                            -- Memory read data
       );
end DmacTrMem;

-- -----------------------------------------------------------------------------
--
--                                  DmacTrMem
--                                  =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--        This module is a behavioural model of a Memory interface. It has 2 AHB
-- slave interfaces. One AHB slave port is used to program the control registers
-- and the other slave port is used by the DMAC for memory access. The control
-- registers are programmed to provide different data generation methods and
-- various responses depending on data pattern. During read operation, this
-- module generates the required number of data depending on data generation
-- method. Any one data generation method, out of Four data generation methods,
-- can be used. During write operation, it generates the expected data and
-- compares it with incoming data. The module flags an error if there is
-- mismatch in incoming and expected data. This block also responsible for LLI
-- Linked List Items)loading. The LLI block is used to support scatter/gather
-- data transfer. The LLI block consists of four words, the source address,
-- destination address, pointer to next LLI block, and a control word. In the
-- last LLI, next LLI pointer is set to NULL. The Data generation methods are
-- Random, GRAYCODE, Address based and Data based method. The following sub
-- methods are used along with above data generation methods. The sub methods
-- are Increment, Decrement, 1's complement and 2's complement. The above sub
-- methods are only applicable to Address and Data generation method.
--
-- -----------------------------------------------------------------------------

-- --============================= ARCHITECTURE ==============================--

architecture behavioural of DmacTrMem is

-- -----------------------------------------------------------------------------
-- Component declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- The following constatns are used to define LLI block address range.
-- The LLI block slave address range is 0x200 to 0x23F and master address range
-- is 0x000000 to 0x000003F.
constant LLILOWADDRRANGE  : std_logic_vector(MASTERADDRHB downto 2)
                                :="0000000000000000000000000";

constant LLIHIGHADDRRANGE : std_logic_vector(MASTERADDRHB downto 2)
                                :="0000000000000000000001111";

constant LLILOWSLAVERANGE : std_logic_vector(SLAVEADDRHB downto 2)
                                :="10000000";

constant LLIHIGHSLAVERANGE : std_logic_vector(SLAVEADDRHB downto 2)
                                :="10001111";
-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal MemAddr          : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- Clocked memory address

signal RegAddr          : std_logic_vector(SLAVEADDRHB downto SLAVEADDRLB);
-- Clocked register address

signal RegSize          : std_logic_vector(2 downto 0);
-- Clocked HSIZE

signal MemSize          : std_logic_vector(2 downto 0);
-- Clocked HSIZEM

signal RegTrans         : std_logic_vector(1 downto 0);
-- Clocked HTRANS

signal MemTrans         : std_logic_vector(1 downto 0);
-- Clocked HTRANSM

signal Selected         : std_logic;
-- Selected state of the memory

signal iHRESP           : std_logic_vector(1 downto 0);
-- Data transfer response from register interface

signal iHRESPM          : std_logic_vector(1 downto 0);
-- Data transfer response from memory interface

signal iHREADYOUT       : std_logic;
-- Ready response from register interface

signal iHREADYOUTM      : std_logic;
-- Ready response from memory interface

signal iHRDATA          : std_logic_vector(31 downto 0);
-- Register read data

signal iHRDATAM         : std_logic_vector(31 downto 0);
-- Memory read data

signal MemRegWrEn       : std_logic;
-- Write enable for memory-specific register

signal LLIRegWrEn       : std_logic;
-- Write enable for LLI memory block

signal Cyc1             : std_logic;
-- First cycle of error response

signal Cyc2             : std_logic;
-- Second cycle of error response

signal Err1             : std_logic;
-- First cycle of split/retry/error response

signal Err2             : std_logic;
-- Second cycle of split/retry/error response

signal MemWrEn          : std_logic;
-- Memory write enable

signal LLIRdEn          : std_logic;
-- LLI read enable

signal MemEnable        : std_logic;
-- Memory model enable bit

signal MemReset         : std_logic;
-- Memory reset bit

signal DataGenMethod    : std_logic_vector(9 downto 8);
-- Data pattern generation method

signal DefaultNoOfResp  : std_logic_vector(7 downto 6);
-- Default number of split and retry response

signal PrgmRespCount    : std_logic_vector(23 downto 22) := (others =>'0');
-- Programmed number of split and retry response

signal RespCount        : std_logic_vector(2 downto 0)   := (others =>'0');
-- To Count number of split and retry response asserted

signal DefIndicate      : std_logic := '0';
-- To indicate Default split and retry response asserted

signal PrgmIndicate     : std_logic := '0';
-- To indicate programmed split and retry response asserted

signal PrgmIndSync      : std_logic := '0';
-- Delayed PrgmIndicate

signal PrgmRespSync     : std_logic_vector(1 downto 0) := "00";
-- Delayed Programmed Response

signal DefaultWaitCyc   : std_logic_vector(5 downto 2);
-- Default wait cycles to be asserted by memory

signal ProgramedWaitCyc : std_logic_vector(21 downto 18) := "0000";
-- Programmed wait cycles to be asserted by memory.

signal MemWaitCyc       : std_logic := '0';
-- To indicate wait cycle to be asserted

signal Endianness       : std_logic := '0';
-- Indicate memory module is configured for Little/Big endian mode

signal DataTransfer     : std_logic := '0';
-- To indicate data is transferred

signal TransferClear    : std_logic := '0';
-- To clear DataTransfer signal

signal WaitCycCount     : std_logic_vector(3 downto 0)   := (others =>'0');
-- To count number of wait cycle asserted

signal RdTotalTrans     : std_logic_vector(15 downto 0)  := (others =>'0');
-- To count number of read data

signal WrTotalTrans     : std_logic_vector(15 downto 0)  := (others =>'0');
-- To count number of write data

signal DefaultResp      : std_logic_vector(1 downto 0);
-- Default Response should be asserted by memory

signal Offset           : std_logic_vector(3 downto 0);
-- Offset to generate address based data

signal DataMethod       : std_logic_vector(7 downto 6);
-- Type of method to be used to generate address based data

signal RdPreviousData   : std_logic_vector(7 downto 0) := (others =>'0');
-- To hold the previous cycle memory read data

signal WrPreviousData   : std_logic_vector(7 downto 0) := (others =>'0');
-- To hold the previous cycle memory write data

signal ExpectedData     : std_logic_vector(31 downto 0) := (others => '0');
-- To hold expected data

signal RespOkInform     : std_logic;
-- Indicates OK response should be asserted

signal RespClear        : std_logic;
-- To clear response count.

signal NxtRegAddr       : std_logic_vector(SLAVEADDRHB downto SLAVEADDRLB);
-- D Input RegAddr

signal NxtRespCount     : std_logic_vector(2 downto 0)   := (others =>'0');
-- D Input of RespCount

signal FirstAccess      : std_logic := '0';
-- Indicate first access of DMAC

signal NxtMemAddr       : std_logic_vector(MASTERADDRHB downto MASTERADDRLB);
-- D Input MemAddr

signal NxtRegTrans      : std_logic_vector(1 downto 0);
-- D input of RegTrans

signal NxtMemTrans      : std_logic_vector(1 downto 0);
-- D input of MemTrans

signal NxtRegSize       : std_logic_vector(2 downto 0);
-- D input of RegSize

signal NxtMemSize       : std_logic_vector(2 downto 0);
-- D input of MemSize

signal NxtMemRegWrEn    : std_logic;
-- D Input of MemRegWrEn

signal NxtLLIRegWrEn    : std_logic;
-- D Input of LLIRegWrEn

signal NxtMemWrEn       : std_logic;
-- D Input of MemRegWrEn

signal NxtLLIRdEn       : std_logic;
-- D Input of MemRegWrEn

signal NxtPrgmRespSync  : std_logic_vector(1 downto 0);
-- D Input of PrgmRespSync

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Type declarations
-- -----------------------------------------------------------------------------
type RegArray is array ((NO_OF_REG-1) downto 0) of
                                        std_logic_vector(31 downto 0);

type LLIMEM is array ((MEMORYDEPTH-1) downto 0) of
                                        std_logic_vector(31 downto 0);
signal iDMACTrMemReg     : RegArray;
-- Memory Registers

signal iLLIBlock         : LLIMEM;
-- LLI Block

signal NxtLLIBlock       : LLIMEM;
-- D input of iLLIBlock

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Latching of Register Address
-- -----------------------------------------------------------------------------
p_RegAddrComb : process (HSELREG, HREADYIN, HTRANS, HADDR, RegAddr)
begin
  NxtRegAddr        <= RegAddr;
  if ((HSELREG = '1') and (HREADYIN = '1') and
      (HTRANS = NSEQ or HTRANS = SEQ)) then
     NxtRegAddr          <= HADDR(SLAVEADDRHB downto SLAVEADDRLB);
  end if;
end process p_RegAddrComb;

-- -----------------------------------------------------------------------------
-- Register Address sequential logic
-- -----------------------------------------------------------------------------
p_RegAddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegAddr           <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RegAddr           <= NxtRegAddr;
  end if;
end process p_RegAddrSeq;

-- -----------------------------------------------------------------------------
-- Latching of Memory Address
-- -----------------------------------------------------------------------------
p_MemAddrComb : process (HSELMEM, HREADYINM, HTRANSM, HADDRM, MemAddr)
begin
  NxtMemAddr        <= MemAddr;
  if ((HSELMEM = '1') and (HREADYINM = '1') and
      (HTRANSM = NSEQ or HTRANSM = SEQ)) then
    NxtMemAddr           <= HADDRM(MASTERADDRHB downto MASTERADDRLB);
  end if;
end process p_MemAddrComb;

-- -----------------------------------------------------------------------------
-- Memory Address sequential logic
-- -----------------------------------------------------------------------------
p_MemAddrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MemAddr           <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    MemAddr           <= NxtMemAddr;
  end if;
end process p_MemAddrSeq;

-- -----------------------------------------------------------------------------
-- Latching of HTRANS
-- -----------------------------------------------------------------------------
p_RegTransComb : process (HSELREG, HREADYIN, HTRANS, RegTrans)
begin
  NxtRegTrans       <= RegTrans;
  if (HSELREG = '1') and (HREADYIN = '1') then
    NxtRegTrans         <= HTRANS(1 downto 0);
  else
    NxtRegTrans         <= (others =>'0');
  end if;
end process p_RegTransComb;

-- -----------------------------------------------------------------------------
-- Register Trans sequential logic
-- -----------------------------------------------------------------------------
p_RegTransSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegTrans          <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RegTrans          <= NxtRegTrans;
  end if;
end process p_RegTransSeq;

-- -----------------------------------------------------------------------------
-- Latching of HTRANSM
-- -----------------------------------------------------------------------------
p_MemTransComb : process (HSELMEM, HREADYINM, HTRANSM, MemTrans, Selected)
begin
  NxtMemTrans       <= MemTrans;
  if (HREADYINM = '1' and HSELMEM = '1') then
    NxtMemTrans       <= HTRANSM;
  elsif (Selected = '0') then
    NxtMemTrans       <= IDLE;
  end if;
end process p_MemTransComb;

-- -----------------------------------------------------------------------------
-- Memory Selected State Generation Block
-- The Selected signal indicates selected state of the memory block. It
-- indicates valid duration where the memory block should assert default/
-- programmed response The Selected signal is set when there is HREADYINM or
-- default/programmed response to be asserted. The signal is cleared when all
-- default/programmed responses are asserted for current transfer.
-- -----------------------------------------------------------------------------
p_SelcectedSeq : process (HRESETn, HREADYINM, MemWaitCyc, RespClear, MemEnable,
                          DefIndicate, PrgmIndicate)
begin
 if (HRESETn = '0') then
    Selected          <= '0';
 else
   if (HREADYINM = '1' or ((DefIndicate = '1' or PrgmIndicate = '1') or
       (MemWaitCyc = '1' and RespClear = '0' and MemEnable = '1'))) then
     Selected       <= '1';
   else
     Selected       <= '0';
   end if;
 end if;
end process p_SelcectedSeq;

-- -----------------------------------------------------------------------------
-- Memory Trans sequential logic
-- -----------------------------------------------------------------------------
p_MemTransSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MemTrans          <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    MemTrans          <= NxtMemTrans;
  end if;
end process p_MemTransSeq;

-- -----------------------------------------------------------------------------
-- Latching of HSIZE
-- -----------------------------------------------------------------------------
p_RegSizeComb : process (HSELREG, HREADYIN, HSIZE, HTRANS, RegSize)
begin
  NxtRegSize        <= RegSize;
  if ((HSELREG = '1') and (HREADYIN = '1') and
        (HTRANS = NSEQ or HTRANS = SEQ)) then
    NxtRegSize          <= HSIZE(2 downto 0);
  end if;
end process p_RegSizeComb;

-- -----------------------------------------------------------------------------
-- Register Size sequential logic
-- -----------------------------------------------------------------------------
p_RegSizeSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RegSize           <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    RegSize           <= NxtRegSize;
  end if;
end process p_RegSizeSeq;

-- -----------------------------------------------------------------------------
-- LLI Read signal combinational block.
-- The LLI read signal is set when HADDRM lies in the LLI block Master address
-- range and there is valid read access to Memory block.
-- -----------------------------------------------------------------------------
p_LLIRdComb : process (HSELMEM, HWRITEM, HREADYINM, HTRANSM, HADDRM, LLIRdEn)
begin
 NxtLLIRdEn            <= LLIRdEn;
 if ((HSELMEM = '1' and HREADYINM = '1') and
     (HTRANSM = NSEQ or HTRANSM = SEQ) and
     ((HADDRM(MASTERADDRHB downto 2) >= LLILOWADDRRANGE) and
     (HADDRM(MASTERADDRHB downto 2)  <= LLIHIGHADDRRANGE)) and
     HWRITEM = '0') then
   NxtLLIRdEn          <= '1';
 else
   NxtLLIRdEn          <= '0';
 end if;
end process p_LLIRdComb;

-- -----------------------------------------------------------------------------
-- LLI Read Signal Sequential block
-- -----------------------------------------------------------------------------
p_LLIWrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    LLIRdEn          <= '0';
  elsif (HCLK'event and HCLK = '1') then
    LLIRdEn        <= NxtLLIRdEn;
  end if;
end process p_LLIWrSeq;

-- -----------------------------------------------------------------------------
-- Memory SIZE Combinational logic
-- -----------------------------------------------------------------------------
p_MemSizeComb : process (HSELMEM, HREADYINM, HSIZEM, HTRANSM, MemSize)
begin
  NxtMemSize        <= MemSize;
  if ((HSELMEM = '1') and (HREADYINM = '1') and
      (HTRANSM = NSEQ or HTRANSM = SEQ)) then
    NxtMemSize          <= HSIZEM(2 downto 0);
  end if;
end process p_MemSizeComb;

-- -----------------------------------------------------------------------------
-- Latching of HSIZEM
-- -----------------------------------------------------------------------------
p_MemSizeSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MemSize           <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    MemSize           <= NxtMemSize;
  end if;
end process p_MemSizeSeq;

-- -----------------------------------------------------------------------------
-- Generation of Register Read/Write signal
-- -----------------------------------------------------------------------------
p_RegWrGenComb : process (HTRANS, HSELREG, HREADYIN, HWRITE)
begin
  if ((HSELREG = '1') and (HREADYIN = '1') and
       (HTRANS = NSEQ or HTRANS = SEQ) and HWRITE = '1') then
    NxtMemRegWrEn  <= '1';
  else
    NxtMemRegWrEn  <= '0';
  end if;
end process p_RegWrGenComb;

-- -----------------------------------------------------------------------------
-- Latching of Register read/write signal
-- -----------------------------------------------------------------------------
p_RegWrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MemRegWrEn        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    MemRegWrEn <= NxtMemRegWrEn;
  end if;
end process p_RegWrGenSeq;

-- -----------------------------------------------------------------------------
-- Generation of Memory Read/Write signal
-- -----------------------------------------------------------------------------
p_MemWrGenComb : process (HTRANSM, HSELMEM, HREADYINM, HWRITEM, MemWrEn)
begin
    NxtMemWrEn           <= MemWrEn;
  if ((HSELMEM = '1') and (HREADYINM = '1') and
       (HTRANSM = NSEQ or HTRANSM = SEQ) and HWRITEM = '1') then
    NxtMemWrEn  <= '1';
  else
    NxtMemWrEn  <= '0';
  end if;
end process p_MemWrGenComb;

-- -----------------------------------------------------------------------------
-- Latching of Memory read/write signal
-- -----------------------------------------------------------------------------
p_MemWrGenSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    MemWrEn        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    MemWrEn <= NxtMemWrEn;
  end if;
end process p_MemWrGenSeq;

-- -----------------------------------------------------------------------------
-- LLI block write combo logic
-- The LLI block slave write signal is set when HADDR lies in the LLI block
-- Slave address range and there is valid Write to register block.
-- -----------------------------------------------------------------------------
p_LLIRegWrComb : process (HTRANS, HSELREG, HREADYIN, HWRITE, HADDR, LLIRegWrEn)
begin
  NxtLLIRegWrEn    <= LLIRegWrEn;
  if ((HSELREG = '1' and HREADYIN = '1' and (HTRANS = NSEQ or HTRANS = SEQ))and
       ((HADDR(SLAVEADDRHB downto SLAVEADDRLB) >= LLILOWSLAVERANGE) and
        (HADDR(SLAVEADDRHB downto SLAVEADDRLB)  <= LLIHIGHSLAVERANGE)) and
         HWRITE = '1') then
    NxtLLIRegWrEn    <= '1';
  else
    NxtLLIRegWrEn    <= '0';
  end if;
end process p_LLIRegWrComb;

-- -----------------------------------------------------------------------------
-- Generation of Register read/write signal
-- -----------------------------------------------------------------------------
p_LLIRegWrSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    LLIRegWrEn        <= '0';
  elsif (HCLK'event and HCLK = '1') then
    LLIRegWrEn <= NxtLLIRegWrEn;
  end if;
end process p_LLIRegWrSeq;

-- ----------------------------------------------------------------------------
-- Memory Register Read Write Block.
-- This combination process is responsible for writing in Register/LLI slave
-- block and reading of register block. It also gives AHB response for each
-- read/write to register/LLI block.
-- ----------------------------------------------------------------------------
p_RegRdWrComb : process (HRESETn, MemRegWrEn, iDMACTrMemReg, RegTrans, RegSize,
                         RegAddr, HWDATA, iLLIBlock, LLIRegWrEn)
begin
  iHRDATA           <= (others => '0');
  NxtLLIBlock       <= iLLIBlock;

  if (HRESETn = '0') then
    iHRDATA           <= (others => '0');
    iHRESP            <= (others => '0');
  end if;

  if (MemRegWrEn = '1') then
    if (LLIRegWrEn = '1') then
      if (RegTrans = NSEQ or RegTrans = SEQ) then
        -- If the write access to LLI block is word wide, update LLI block
        -- with new data. If the LLI write access is not word wide, flag
        -- Error message.
        if (RegSize = WORD) then
          NxtLLIBlock(to_integer(RegAddr(5 downto 2))) <= HWDATA(31 downto 0);
          iHRESP            <= OKAY_RESP;
        else
          assert RegSize = WORD
          report "DmacTrMem1 : LLI WRITE ACCESS IS NOT WORD WIDE"
          severity ERROR;
          iHRESP            <= ERROR_RESP;
        end if;
      end if;
    else
      if (RegTrans = NSEQ or RegTrans = SEQ) then
        -- If the write access to register block is word wide, update register
        -- block with new data. If the register write access is not word wide,
        -- flag Error message.
        if (RegSize = WORD) then
          iHRESP            <= OKAY_RESP;
        else
          assert RegSize = WORD
          report " DmacTrMem2 : WRITE ACCESS IS NOT WORD WIDE"
          severity ERROR;
          iHRESP            <= ERROR_RESP;
        end if;
      else
        iHRESP   <= OKAY_RESP;
      end if;
    end if;
  else
    if (RegTrans = NSEQ or RegTrans = SEQ) then
      if (LLIRegWrEn = '0') then
        if ((RegAddr(SLAVEADDRHB downto SLAVEADDRLB) >= LLILOWSLAVERANGE) and
           (RegAddr(SLAVEADDRHB downto SLAVEADDRLB)  <= LLIHIGHSLAVERANGE)) then
        -- If the LLI read access is not word wide, flag Error message.
          if (RegSize = WORD) then
            iHRDATA <=
           iLLIBlock(to_integer(RegAddr((SLAVEADDRLB +3) downto SLAVEADDRLB)));
          else
            assert RegSize = WORD
            report " DmacTrMem3 : LLI SLAVE READ ACCESS IS NOT WORD WIDE"
            severity ERROR;
          end if;
        end if;
      else
        -- If the register read access is not word wide, flag Error message
        if (RegSize = WORD) then
          iHRDATA           <= iDMACTrMemReg(to_integer(RegAddr));
          iHRESP            <= OKAY_RESP;
        else
          assert RegSize = WORD
          report " DmacTrMem4 : READ ACCESS IS NOT WORD WIDE"
          severity ERROR;
          iHRESP            <= ERROR_RESP;
        end if;
      end if;
    else
      iHRESP            <= OKAY_RESP;
    end if;
  end if;
end process p_RegRdWrComb;

-- -----------------------------------------------------------------------------
-- LLI write sequential block
-- -----------------------------------------------------------------------------
p_LLISeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    iLLIBlock <= (others =>(others => '0'));
  elsif (HCLK'event and HCLK = '1') then
    iLLIBlock  <= NxtLLIBlock;
  end if;
end process p_LLISeq;

-- ----------------------------------------------------------------------------
-- Write Block for Memory Registers
-- This process is responsible for the updating of register block. When there is
-- valid write to register block, it writes in register indicated by RegAddr.
-- This process clears all control register except control 1 register when
-- Memory reset bit is set. It clears all registers when HRESETn is asserted.
-- -----------------------------------------------------------------------------
p_RegSeq : process (HCLK, HRESETn)
variable TempRegValue : std_logic_vector(31 downto 0) := (others => '0');
begin
  if (HRESETn = '0') then
    iDMACTrMemReg <= (others =>(others => '0'));
  elsif (HCLK'event and HCLK = '1') then
    if (MemReset = '1') then
      TempRegValue :=iDMACTrMemReg(0);
      iDMACTrMemReg <= (others =>(others => '0'));
      iDMACTrMemReg(0) <= TempRegValue;
    end if;
    if ((MemRegWrEn = '1') and (RegSize = WORD) and LLIRegWrEn = '0') then
      iDMACTrMemReg(to_integer(RegAddr)) <= HWDATA;
    end if;
  end if;
end process p_RegSeq;

-- -----------------------------------------------------------------------------
-- Assigning internal signals values
-- -----------------------------------------------------------------------------
MemEnable         <= iDMACTrMemReg(0)(31);

MemReset          <= iDMACTrMemReg(0)(30);

DataGenMethod     <= iDMACTrMemReg(0)(9 downto 8);

DefaultNoOfResp   <= iDMACTrMemReg(0)(7 downto 6);

DefaultWaitCyc    <= iDMACTrMemReg(0)(5 downto 2);

DefaultResp       <= iDMACTrMemReg(0)(1 downto 0);

Endianness        <= iDMACTrMemReg(0)(10);

DataMethod        <= iDMACTrMemReg(1)(7 downto 6);

Offset            <= iDMACTrMemReg(1)(3 downto 0);

-- -----------------------------------------------------------------------------
-- Register two Cycle Response Generation
-- Cyc1 Generation
-- -----------------------------------------------------------------------------
-- Cyc1 is set HIGH during the first cycle of an error response.
-- The registered Cyc2 is HIGH during the second cycle of the error
-- response.

Cyc1 <= '1' when (iHRESP = ERROR_RESP and Cyc2 = '0')
     else
        '0';

-- -----------------------------------------------------------------------------
-- Cyc2 Generation
-- Cyc2 is delayed version of Cyc1
-- -----------------------------------------------------------------------------
p_Cyc2Seq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    Cyc2              <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Cyc2              <= Cyc1;
  end if;
end process p_Cyc2Seq;

-- -----------------------------------------------------------------------------
-- Memory two Cycle Response Generation
-- Err1 Generation
-- -----------------------------------------------------------------------------
-- Err1 is set HIGH during the first cycle of an error response.
-- The registered Err2 is HIGH during the second cycle of the error
-- response.

Err1 <= '1' when (iHRESPM /= OKAY_RESP and Err2 = '0')
     else
        '0';

-- -----------------------------------------------------------------------------
-- Err2 Generation
-- Err2 is delayed version of Err1
-- ---------------------------------------------------------------------
p_Err2Seq : process (HRESETn, HCLK)
begin
  if HRESETn = '0' then
    Err2              <= '0';
  elsif (HCLK'event and HCLK = '1') then
    Err2              <= Err1;
  end if;
end process p_Err2Seq;

-- ----------------------------------------------------------------------------
-- Register Ready Response generator Block.
-- The HREADYOUT is kept low in first cycle of two cycle response(i.e. When Cyc1
-- is set and Cyc2 is cleared).
-- ----------------------------------------------------------------------------
p_RegReadyComb  : process (HRESETn, Cyc1, Cyc2)
begin
  if (HRESETn = '0') then
    iHREADYOUT        <= '1';
  end if;
  if (Cyc1 = '1' and Cyc2 = '0') then
    iHREADYOUT        <= '0';
  elsif (Cyc1 = '0' and Cyc2 = '1') then
    iHREADYOUT        <= '1';
  end if;
end process p_RegReadyComb;

-- ----------------------------------------------------------------------------
-- Memory Ready Response generator Block
-- The HREADYOUTM is kept low in first cycle of two cycle response(i.e. When
-- Err1 is set and Err2 is cleared) or when Wait response is asserted.
-- ----------------------------------------------------------------------------
p_MemoryReadyComb  : process (HRESETn, Err1, Err2, MemWaitCyc)
begin
  if (HRESETn = '0') then
    iHREADYOUTM       <= '1';
  elsif (Err1 = '1' and Err2 = '0') then
    iHREADYOUTM       <= '0';
  elsif (Err1 = '0' and Err2 = '1') then
    iHREADYOUTM       <= '1';
  elsif (MemWaitCyc = '1') then
    iHREADYOUTM       <= '0';
  elsif (MemWaitCyc ='0') then
    iHREADYOUTM       <= '1';
  end if;
end process p_MemoryReadyComb;

-- ----------------------------------------------------------------------------
-- First Access signal Generation Block
-- ----------------------------------------------------------------------------
p_FirstAccComb : process (HRESETn, HREADYINM)
begin
  if (HRESETn = '0') then
    FirstAccess        <= '0';
  elsif (HREADYINM = '1') then
    FirstAccess        <= '1';
  end if;
end process p_FirstAccComb;

-- ----------------------------------------------------------------------------
-- Memory Read Sequential Block
-- This process is responsible for Memory/LLI Master block read access.
-- ----------------------------------------------------------------------------
p_MemoryRdSeq : process (HRESETn, HCLK)
variable RdCount             : integer := 0;
variable Shifted_DataRd      : std_logic_vector(31 downto 0) := (others =>'0');
variable TempRd              : std_logic_vector(7 downto 0) := (others =>'0');
variable RdFlag              : boolean;
variable TempAddr            : std_logic_vector(7 downto 0) := (others =>'0');

begin
  if (HRESETn = '0') then
    -- Clear previous cycle memory read data.
    RdPreviousData    <= (others => '0');
    -- Clear HRDATAM.
    iHRDATAM          <= (others => '0');
    -- Clear Number of total read data transfer.
    RdTotalTrans      <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (MemReset = '1') then
      -- If Memory Reset bit is set, clear previous cycle memory data and
      -- number of total read data transfer.
      RdPreviousData    <= (others => '0');
      RdTotalTrans      <= (others => '0');
    end if;

    if (RdTotalTrans = to_stdlogicvector(X"0000")) then
      RdFlag            := TRUE;
    end if;

    if (RdFlag = TRUE) then
      -- Load seed from control register 1 for read data generation.
      RdPreviousData    <= iDMACTrMemReg(1)(31 downto 24);
    end if;

    -- The RdCount indicates number of times data generation function to be
    -- called to generate read data. The Data generation functions returns byte
    -- wide data.
    -- If HSIZEM is BYTE then Data generation function is called only once.
    -- If HSIZEM is Half Word then Data generation function is called twice as
    -- function returns only byte wide data.
    if (HSIZEM = BYTE) then
      RdCount             := 1;
    elsif (HSIZEM = HWORD) then
      RdCount             := 2;
    elsif (HSIZEM = WORD) then
      RdCount             := 4;
    end if;

    if ((HSELMEM = '1') and (HREADYINM = '1')) then
      if (HWRITEM = '0' and RespCount = "000" and RespClear = '0') then
        if (MemEnable = '1') then
          if ((HADDRM(MASTERADDRHB downto 2) >= LLILOWADDRRANGE) and
              (HADDRM(MASTERADDRHB downto 2)  <= LLIHIGHADDRRANGE)) then
            if (HSIZEM = WORD) then
              -- If there is valid LLI word wide read access, output HRDTAM from
              -- location indicated by HADDRM from LLI block
              iHRDATAM          <= iLLIBlock(to_integer(HADDRM(5 downto 2)));
            elsif (HTRANSM /= IDLE and Selected = '1') then
              -- If LLI read is Non Word access, assert error
              assert HSIZEM = WORD
              report " DmacTrMem5 : LLI READ ACCESS IS NOT WORD WIDE"
              severity ERROR;
            end if;
          elsif (FirstAccess = '1') then
            if (HTRANSM = NSEQ or HTRANSM = SEQ) then
              if (HSIZEM = BYTE or HSIZEM = HWORD or HSIZEM = WORD) then
                -- Load previous cycle Read data.
                TempRd           := RdPreviousData;
                Shifted_DataRd   := (others =>'0');
                TempAddr         := HADDRM(7 downto 0);
                R2: for i in 1 to RdCount loop
                  case DataGenMethod is
                    when RANDOM =>
                      -- RANDOM Data generation method. Call Random Data
                      -- generator function
                      RdFlag           := False;
                      TempRd           := PRBSDataGen(TempRd);
                    when GRAYCODE =>
                      -- GRAYCODE Data generation method. Call GRAYCODE Data
                      -- generator function
                      RdFlag           := False;
                      TempRd           := GrayDataGen(TempRd);
                    when ADDRESSBASED =>
                      -- Address Based Data Generation Method
                      TempRd           := AddrBasedGen(TempAddr, Offset,
                                                       DataMethod);
                      TempAddr         := TempAddr + 1;
                    when DATABASED =>
                      -- Data Based Data generation Method.
                      RdFlag           := False;
                      TempRd           := DataBasedGen(TempRD, Offset,
                                                      DataMethod);
                    when others =>
                      -- Invalid Data Generation Method, assert error message
                      assert (DataGenMethod = RANDOM or
                              DataGenMethod = GRAYCODE or
                              DataGenMethod = ADDRESSBASED or
                              DataGenMethod = DATABASED
                             )
                      report " DmacTrMem6 : INVALID DATA GENERATION METHOD FOR"&
                             " READ DATA COMPARISION"
                      severity ERROR;
                  end case;
                  if (Endianness = '0') then
                    -- Little Endian Mode
                    if (HSIZEM = BYTE) then
                      if (HADDRM(1 downto 0) = "00") then
                        Shifted_DataRd(7 downto 0) := TempRd;
                      elsif (HADDRM(1 downto 0) = "01") then
                        Shifted_DataRd(15 downto 8) := TempRd;
                      elsif (HADDRM(1 downto 0) = "10") then
                        Shifted_DataRd(23 downto 16) := TempRd;
                      elsif (HADDRM(1 downto 0) = "11") then
                        Shifted_DataRd(31 downto 24) := TempRd;
                      end if;
                    elsif (HSIZEM = HWORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8)
                                                                  := TempRd;
                      if (i = 2) then
                        if (HADDRM(1 downto 0) = "10") then
                          Shifted_DataRd := Shifted_DataRd(15 downto 0)
                                              & "0000000000000000";
                         end if;
                      end if;
                    elsif (HSIZEM = WORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                    end if;
                  else
                    -- Big Endian Mode
                    if (HSIZEM = BYTE) then
                      if (HADDRM(1 downto 0) = "00") then
                        Shifted_DataRd(31 downto 24) := TempRd;
                      elsif (HADDRM(1 downto 0) = "01") then
                        Shifted_DataRd(23 downto 16) := TempRd;
                      elsif (HADDRM(1 downto 0) = "10") then
                        Shifted_DataRd(15 downto 8) := TempRd;
                      elsif (HADDRM(1 downto 0) = "11") then
                        Shifted_DataRd(7 downto 0) := TempRd;
                      end if;
                    elsif (HSIZEM = HWORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                      if (i = 2) then
                        if (HADDRM(1 downto 0) = "00") then
                          Shifted_DataRd := Shifted_DataRd(15 downto 0) &
                                                            "0000000000000000";
                        end if;
                      end if;
                    elsif (HSIZEM = WORD) then
                      Shifted_DataRd((8 * i )- 1 downto (8* i) -8) := TempRd;
                    end if;
                  end if;
                end loop R2;
                if (DataGenMethod = RANDOM or DataGenMethod = GRAYCODE or
                    DataGenMethod = ADDRESSBASED or DataGenMethod = DATABASED
                   ) then
                  iHRDATAM         <= Shifted_DataRd;
                  RdTotalTrans     <= unsigned(RdTotalTrans) + '1';
                  if (RdFlag = false) then
                    RdPreviousData     <= TempRd;
                  end if;
                else
                  iHRDATAM         <= (others => '0');
                end if;
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_MemoryRdSeq;

-- -----------------------------------------------------------------------------
-- Memory Read Write Combo Logic.
-- -----------------------------------------------------------------------------
p_RdWrDataComb : process (MemWrEn, MemEnable, MemTrans, MemSize, FirstAccess,
                          Selected)
begin
  -- If Memory Read/Write access is non BYTE/Half Word/Word access then assert
  -- error message. If memory model is not enabled, return error message to
  -- memory read/write access.

  if (MemWrEn = '1') then
    if (MemEnable = '1') then
      if (MemTrans = NSEQ or MemTrans = SEQ) then
        if (MemSize /= BYTE or MemSize /= HWORD or MemSize /= WORD) then
          assert MemSize = BYTE or MemSize = HWORD or MemSize = WORD
          report " DmacTrMem7 : WRITE ACCESS OF INVALID HSIZEM "
          severity ERROR;
        end if;
      end if;
    else
      assert MemEnable = '1'
      report " MEMORY MODEL IS NOT ENABLED. INVALID WRITE ACCESS"
      severity ERROR;
    end if;
  else
    if (MemEnable = '1') then
      if (FirstAccess = '1') then
        if (MemTrans = NSEQ or MemTrans = SEQ) then
          if (MemSize /= BYTE or MemSize /= HWORD or MemSize /= WORD) then
            assert MemSize = BYTE or MemSize = HWORD or MemSize = WORD
            report " DmacTrMem8 : READ ACCESS OF INVALID HSIZEM "
            severity ERROR;
          end if;
        end if;
      end if;
    else
      if (Selected = '1' and FirstAccess = '1' and MemTrans /= IDLE) then
        assert MemEnable = '1'
        report " DmacTrMem9 : MEMORY MODEL IS NOT ENABLED. INVALID READ ACCESS"
        severity ERROR;
      end if;
    end if;
  end if;
end process p_RdWrDataComb;

-- -----------------------------------------------------------------------------
-- Expected Data Generation Block.
-- This process is responsible for the generation of expected data.
-- -----------------------------------------------------------------------------
p_ExpectDataSeq : process (HRESETn, HCLK)
variable WrCount             : integer := 0;
variable Shifted_DataWr      : std_logic_vector(31 downto 0) := (others =>'0');
variable TempWr              : std_logic_vector(7 downto 0)  := (others =>'0');
variable WrFlag              : boolean;
variable TempAddr            : std_logic_vector(7 downto 0)  := (others =>'0');
begin
  if (HRESETn = '0') then
    -- Clear Expected Data
    ExpectedData      <= (others => '0');
    -- Clear previous cycle memory write data.
    WrPreviousData    <= (others => '0');
    -- Clear Number of total write data transfer.
    WrTotalTrans      <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if (MemReset = '1') then
    -- Clear previous cycle memory write data.
      WrPreviousData    <= (others => '0');
    -- Clear Number of total write data transfer.
      WrTotalTrans      <= (others => '0');
    end if;

    if (WrTotalTrans = to_stdlogicvector(X"0000")) then
      WrFlag            := TRUE;
    end if;

    if (WrFlag = TRUE) then
      -- Load seed from control register 1 for write data generation.
      WrPreviousData    <= iDMACTrMemReg(1)(31 downto 24);
    end if;

    -- The WrCount indicates number of times data generation function to be
    -- called to generate the Expected data. The Data generation functions
    -- returns byte wide data.
    -- If HSIZEM is BYTE then Data generation function is called only once.
    -- If HSIZEM is Half Word then Data generation function is called twice as
    -- function returns only byte wide data.
    if (HSIZEM = BYTE) then
      WrCount             := 1;
    elsif (HSIZEM = HWORD) then
      WrCount             := 2;
    elsif (HSIZEM = WORD) then
      WrCount             := 4;
    end if;

    if ((HSELMEM = '1') and (HREADYINM = '1')) then
      if (HWRITEM = '1' and RespCount = "000" and RespClear = '0') then
        if (MemEnable = '1') then
          if (HTRANSM = NSEQ or HTRANSM = SEQ) then
            if (HSIZEM = BYTE or HSIZEM = HWORD or HSIZEM = WORD) then
              -- Increment Total Write Data transfer count
              WrTotalTrans       <= unsigned(WrTotalTrans) + '1';
              -- Load previous cycle write data
              TempWr           := WrPreviousData;
              Shifted_DataWr   := (others =>'0');
              TempAddr         := HADDRM(7 downto 0);
              R1: for i in 1 to WrCount loop
                case DataGenMethod is
                  when RANDOM =>
                    -- RANDOM Data generation method. Call Random Data generator
                    -- function
                    WrFlag           := False;
                    TempWr           := PRBSDataGen(TempWr);
                  when GRAYCODE =>
                    -- GRAYCODE Data generation method
                    WrFlag           := False;
                    TempWr           := GrayDataGen(TempWr);
                  when ADDRESSBASED =>
                    -- Address Based Data Generation Method
                    TempWr           := AddrBasedGen(TempAddr, Offset,
                                                     DataMethod);
                    TempAddr         := TempAddr + 1;
                  when DATABASED =>
                    -- Data Based Data generation Method.Call Databased Data
                    -- generator function
                    WrFlag           := False;
                    TempWr           := DataBasedGen(TempWr, Offset,
                                                     DataMethod);
                  when others =>
                    -- Invalid Data Generation method, assert Error message
                    assert (DataGenMethod = RANDOM or
                            DataGenMethod = GRAYCODE or
                            DataGenMethod = ADDRESSBASED or
                            DataGenMethod = DATABASED
                           )
                    report " DmacTrMem10 : INVALID DATA GENERATION METHOD FOR"&
                           " WRITE DATA COMPARISION"
                    severity ERROR;
                end case;
                Shifted_DataWr((8 * i )- 1 downto (8* i) -8) := TempWr;
              end loop R1;
              if (HSIZEM = BYTE) then
                ExpectedData     <= Shifted_DataWr(7 downto 0) &
                                    Shifted_DataWr(7 downto 0) &
                                    Shifted_DataWr(7 downto 0) &
                                    Shifted_DataWr(7 downto 0);
              elsif (HSIZEM = HWORD) then
                ExpectedData   <= Shifted_DataWr(15 downto 0) &
                                  Shifted_DataWr(15 downto 0);
              else
                ExpectedData      <= Shifted_DataWr;
              end if;
              if (DataGenMethod = RANDOM or DataGenMethod = GRAYCODE or
                  DataGenMethod = ADDRESSBASED or
                  DataGenMethod = DATABASED) then
                if (WrFlag = false) then
                  WrPreviousData     <= TempWr;
                end if;
              else
                ExpectedData      <= (others=>'0');
              end if;
            end if;
          end if;
        end if;
      end if;
    end if;
  end if;
end process p_ExpectDataSeq;

-- ----------------------------------------------------------------------------
-- Master Response decision Block
-- This process is responsible for the assertion of HRESPM for memory Read/Write
-- access.
-- ----------------------------------------------------------------------------
p_RespDecideComb : process (HRESETn, MemReset, MemAddr, MemTrans, PrgmIndSync,
                            MemSize, LLIRdEn, MemEnable, iDMACTrMemReg,
                            DefaultResp, FirstAccess, MemWrEn, TransferClear,
                            Err2, RespClear, RespCount, RespOkInform,
                            MemWaitCyc, Selected, PrgmRespSync)
variable Flag              : boolean := false;
variable Found             : boolean := false;
variable ValidBits         : integer := 0;
variable TransCount        : std_logic_vector(15 downto 0);
variable i                 : integer := 0;
begin
  NxtRespCount      <= RespCount;
  NxtPrgmRespSync   <= PrgmRespSync;

  if (HRESETn = '0') then
    -- Assert OK response on reset
    iHRESPM           <= (others => '0');
  end if;

  if (HRESETn = '0' or MemReset = '1') then
    -- Clear Response count on HRESETn or Memory Reset.
    NxtRespCount      <= (others =>'0');
    -- Clear programmed response on HRESETn or Memory Reset.
    NxtPrgmRespSync   <= (others => '0');
  end if;

  if (TransferClear = '1') then
    -- Clear Data Transfer single when last data transfer is done
    DataTransfer      <= '0';
  end if;

  -- TransCount variable is used for assertion of programmed response. It holds
  -- number of total read/write count depending memory read/write data transfer.
  -- For Data based programmed response(i.e. bit 30 of Memory Control register
  -- is set)assertion, TransCount is compared with DataCount field of control
  -- register. If TransCount is equal to DataCount, Programmed Response is
  -- asserted.
  if (MemWrEn = '1') then
    -- Assign Total number of Write Data Transfer to TransCount
    TransCount := WrTotalTrans;
  else
    -- Assign Total number of Read Data Transfer to TransCount
    TransCount := RdTotalTrans;
  end if;

  if (Selected = '1') then
    if (MemTrans = IDLE) then
      -- Assert OK response to IDLE transfer
      iHRESPM           <= OKAY_RESP;
    elsif (LLIRdEn = '1' and MemSize /= WORD) then
      -- Assert Error Response for non word LLI read access
      iHRESPM           <= ERROR_RESP;
    else
      iHRESPM           <= OKAY_RESP;
      if (MemEnable = '1') then
        if (MemSize = BYTE or MemSize = HWORD or MemSize = WORD) then
          if (MemReset = '1') then
          -- If Memory reset bit is set, assert Error Response for memory read/
          -- write access.
            iHRESPM           <= ERROR_RESP;
            assert MemReset = '0'
            report " MemReset1: Memory Reset bit is set. In Valid Access."
            severity Error;
          else
            if (HREADYINM = '1') then
              -- Programmed response assertion block.
              L4 : for j in 2 to (NO_OF_REG-1) loop
               -- Check Control register Enable bit is set
               if (iDMACTrMemReg(j)(31) ='1') then
                 if (iDMACTrMemReg(j)(30) = '0') then
                   -- Address based Programmed Response assertion method
                   -- Determine Valid bits and Compare Memory address with
                   -- AddressCount. If it equals set Flag True.
                   ValidBits := to_integer(iDMACTrMemReg(j)(27 downto 24));
                   if (iDMACTrMemReg(j)(29 downto 28) = "00") then
                     if (MemAddr(ValidBits downto 0) =
                               iDMACTrMemReg(j)(ValidBits downto 0)) then
                       Flag              := TRUE;
                     end if;
                   elsif (iDMACTrMemReg(j)(29 downto 28) = "01") then
                     if (MemAddr((ValidBits+ 1) downto 1) =
                               iDMACTrMemReg(j)(ValidBits downto 0)) then
                        Flag              := TRUE;
                     end if;
                   elsif (iDMACTrMemReg(j)(29 downto 28) = "10") then
                     if (MemAddr(ValidBits+2 downto 2) =
                               iDMACTrMemReg(j)(ValidBits downto 0)) then
                       Flag              := TRUE;
                     end if;
                   end if;
                   if (Flag = TRUE) then
                     Found             := TRUE;
                     DataTransfer      <= '1';
                   end if;
                 else
                   -- Data Based Programmed Response assertion
                   -- Determine Valid number of bits and compare TransCount(i.e.
                   -- Total Read/Write transfer count) with Data Count. If it is
                   -- equals set Flag True.
                   ValidBits := to_integer(iDMACTrMemReg(j)(27 downto 24));
                   if (TransCount(ValidBits downto 0) =
                                    iDMACTrMemReg(j)(ValidBits downto 0)) then
                     Flag              := TRUE;
                   end if;
                   if (Flag = TRUE) then
                     Found             := TRUE;
                     DataTransfer      <= '1';
                   end if;
                 end if;
               end if;
               -- Exit loop if any programmed response is found.
               if (Found = TRUE) then
                 i := j;
                 exit L4;
               end if;
              end loop L4;
            end if;

            if (Flag = TRUE or PrgmIndSync /= '0') then
              if (Flag = TRUE) then
                -- If Programmed response is found for current transfer, assert
                -- programmed response.
                iHRESPM           <= iDMACTrMemReg(i)(17 downto 16);
                if ((iDMACTrMemReg(i)(17 downto 16) = SPLIT_RESP or
                     iDMACTrMemReg(i)(17 downto 16) = RETRY_RESP or
                     iDMACTrMemReg(i)(17 downto 16) = ERROR_RESP) and
                     RespOkInform = '0') then
                  -- Store Programmed Response and set PrgmIndicate(It indicates
                  -- Programmed response is asserted)
                  PrgmRespCount     <= iDMACTrMemReg(i)(23 downto 22);
                  PrgmIndicate      <= '1';
                  -- During Wait Cycle assert Ok Response
                  if (MemWaitCyc = '1' and Err2 = '0') then
                    iHRESPM       <= OKAY_RESP;
                  else
                    -- Increment Response counter
                    if (Err2 = '0' and
                        (iDMACTrMemReg(i)(17 downto 16) /= ERROR_RESP)) then
                      NxtRespCount      <= unsigned(RespCount) + '1';
                    end if;
                  end if;
                end if;
                -- Latch Programmed response and Programmed Wait cycle
                NxtPrgmRespSync   <= iDMACTrMemReg(i)(17 downto 16);
                ProgramedWaitCyc  <= iDMACTrMemReg(i)(21 downto 18);
              else
                if (RespOkInform = '0') then
                  PrgmIndicate      <= '1';
                  if (MemWaitCyc = '1' and Err2 = '0') then
                    -- For Programmed Wait Cycle response assert Ok response
                    iHRESPM       <= OKAY_RESP;
                  else
                    -- If Programmed Wait Cycles are asserted, assert
                    -- programmed response if any.
                    iHRESPM           <= PrgmRespSync;
                    if (Err2 = '0' and (PrgmRespSync /= ERROR_RESP)) then
                    -- Increment Response counter
                      NxtRespCount      <= unsigned(RespCount) + '1';
                    end if;
                  end if;
                end if;
              end if;
            else
              -- if there is no programmed response for current transaction
              -- assert default response
              iHRESPM           <= DefaultResp;
              if ((DefaultResp = SPLIT_RESP or DefaultResp = RETRY_RESP or
                   DefaultResp = ERROR_RESP) and (RespOkInform = '0')) then
                if (MemWaitCyc = '1' and Err2 = '0') then
                -- If default wait cycle any, assert Ok response
                  iHRESPM       <= OKAY_RESP;
                else
                  DefIndicate       <= '1';
                  if ((Err2 = '0') and (DefaultResp /= ERROR_RESP)) then
                    -- Increment response count
                    NxtRespCount      <= unsigned(RespCount) + '1';
                  end if;
                end if;
              end if;
            end if;
          end if;
        else
          -- assert error response for Non byte/Half word/Word memory access
          iHRESPM           <= ERROR_RESP;
        end if;
      else
        if (FirstAccess = '1') then
          -- assert error response when there is access to memory when memory
          -- is not enabled
          iHRESPM           <= ERROR_RESP;
        end if;
      end if;
    end if;
  end if;

  if (RespOkInform = '1') then
    -- assert ok response after all programmed/default responses are asserted.
    iHRESPM           <= OKAY_RESP;
    NxtPrgmRespSync   <= (others => '0');
    DefIndicate       <= '0';
    PrgmIndicate      <= '0';
  end if;
  if (RespClear = '1') then
    -- All programmed/Default responses are asserted, clear response count
    NxtRespCount      <= (others => '0');
    -- All programmed/Default responses are asserted, clear programmed response
    -- indicate and default response indicate signal
    DefIndicate       <= '0';
    PrgmIndicate      <= '0';
    PrgmRespCount     <= (others => '0');
    NxtPrgmRespSync   <= (others => '0');
  end if;

  -- clear Flag and Found flags
  Flag              := False;
  Found             := False;
end process p_RespDecideComb;

-- ----------------------------------------------------------------------------
-- Response Count Sequential Block
-- ----------------------------------------------------------------------------
p_RespCountSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RespCount           <= (others => '0');
    PrgmIndSync         <= '0';
    PrgmRespSync        <= OKAY_RESP;
  elsif (HCLK'event and HCLK = '1') then
    RespCount           <= NxtRespCount;
    PrgmIndSync         <= PrgmIndicate;
    PrgmRespSync        <= NxtPrgmRespSync;
  end if;
end process p_RespCountSeq;

-- ----------------------------------------------------------------------------
-- Response Counter Clear Generation Block
-- This process is responsible generation of RespClear signal. The RespClear
-- signal is used to clear programmed response counter.
-- ----------------------------------------------------------------------------
p_RSPComb : process (HRESETn, HCLK)
variable Count : std_logic_vector(2 downto 0);
variable PrgmCount : std_logic_vector(2 downto 0);
variable DefCount : std_logic_vector(2 downto 0);
begin
 if (HRESETn = '0') then
   RespClear       <= '0';
 elsif (HCLK'event and HCLK = '1') then
   Count     := RespCount;
   PrgmCount := '0' & PrgmRespCount;
   DefCount  := '0' & DefaultNoOfResp;
   PrgmCount := PrgmCount + 1;
   DefCount  := DefCount + 1;
   if (MemReset = '1') then
     RespClear       <= '0';
   elsif (PrgmIndicate = '1' and Count = PrgmCount) then
     -- Check actual response asserted and programmed response asserted are
     -- equal. If it is equal generate RespClear signal to clear response
     -- counter.
     RespClear       <= '1';
   elsif (DefIndicate = '1' and Count = DefCount) then
     -- Check actual response asserted and default response asserted are
     -- equal. If it is equal generate RespClear signal to clear response
     -- counter.
     RespClear       <= '1';
   elsif (HTRANSM /= IDLE) then
     RespClear       <= '0';
   end if;
 end if;
end process p_RSPComb;

-- ----------------------------------------------------------------------------
-- Ok Response Decision Sequential block
-- ----------------------------------------------------------------------------
p_RespOkInfSeq : process (HCLK, HRESETn)
begin
  if (HRESETn = '0') then
    RespOkInform           <= '0';
  elsif (HCLK'event and HCLK = '1') then
     if (RespClear = '1' or (iHRESPM = ERROR_RESP and Err2 = '1')) then
       RespOkInform        <= '1';
     else
       RespOkInform        <= '0';
     end if;
  end if;
end process p_RespOkInfSeq;

-- ----------------------------------------------------------------------------
-- Memory Wait Cycle assertion Block
-- This block is responsible for assertion of wait cycle response. If there is
-- default wait cycle response or programmed wait cycle response to current
-- data transfer, this block asserts wait cycle response.
-- ----------------------------------------------------------------------------
p_MemWaitCycSeq : process (HRESETn, HCLK)
begin
  if (HRESETn = '0' or MemReset = '1') then
    TransferClear     <= '0';
    MemWaitCyc        <= '0';
    WaitCycCount      <= (others =>'0');
  elsif (HCLK'event and HCLK ='1') then
    if (MemEnable = '1' and Selected = '1') then
      if (HTRANSM = IDLE and HREADYINM = '1') then
        -- For Idle cycle No Wait Cycle to be asserted
        MemWaitCyc       <= '0';
      elsif ((ProgramedWaitCyc /="0000") and (DataTransfer = '1') and
              iHRESPM = OKAY_RESP) then
        if (WaitCycCount < ProgramedWaitCyc and RespClear = '0' and
              Err2 = '0') then
          -- If number of wait cycle asserted is not equal to programmed wait
          -- cycle count, Assert wait cycle and increment wait cycle counter
          TransferClear     <= '0';
          MemWaitCyc        <= '1';
          WaitCycCount      <= unsigned(WaitCycCount) + 1;
        else
          -- If number of wait cycle asserted is equal to programmed Wait Cycle
          -- count, Clear wait cycle counter
          WaitCycCount      <= (others =>'0');
          MemWaitCyc        <= '0';
          TransferClear     <= '1';
        end if;
      elsif (DefaultWaitCyc /="0000" and iHRESPM = OKAY_RESP) then
        if (WaitCycCount < DefaultWaitCyc and RespClear = '0'
              and Err2 = '0') then
          -- If number of Wait Cycle asserted is not equal to Default Wait
          -- Cycle count. Assert Wait Cycle and Increment Wait Cycle counter
          TransferClear     <= '0';
          MemWaitCyc        <= '1';
          WaitCycCount      <= unsigned(WaitCycCount) + 1;
        else
          -- If number of wait cycle asserted is equal to default wait Cycle
          -- count, Clear wait cycle counter
          WaitCycCount      <= (others =>'0');
          MemWaitCyc        <= '0';
          TransferClear     <= '1';
        end if;
      else
        MemWaitCyc        <= '0';
        TransferClear     <= '1';
      end if;
    else
      MemWaitCyc        <= '0';
      TransferClear     <= '1';
    end if;
  end if;
end process p_MemWaitCycSeq;

-- -----------------------------------------------------------------------------
-- Data Check Sequential Block.
-- This block is responsible for data comparison. It compares the HWDATAM and
-- Expected data. It flags an error message if there is mismatch.
-- -----------------------------------------------------------------------------
p_DataCheckSeq : process (HCLK)
variable ErrorStr         : string (1 to 255);
begin
  if (HCLK'event and HCLK = '1') then
    if (MemWrEn = '1') then
      if (DataGenMethod = RANDOM) then
        fprint (ErrorStr, " DmacTrMem11 : RANDOM METHOD : MISMATCH IN EXPECTED"&
                       " AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      elsif (DataGenMethod = GRAYCODE) then
        fprint (ErrorStr, " DmacTrMem12 : GRAYCODE METHOD : MISMATCH IN"&
            " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      elsif (DataGenMethod = ADDRESSBASED) then
        fprint (ErrorStr, " DmacTrMem13 : ADDRESSBASED METHOD : MISMATCH IN "&
               " EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      elsif (DataGenMethod = DATABASED) then
        fprint (ErrorStr, " DmacTrMem14 : DATABASED METHOD : MISMATCH IN"&
              "EXPECTED AND ACTUAL DATA. EXPECTED DATA : %s ACTUAL DATA :%s ",
                To_HexString(ExpectedData), To_HexString(HWDATAM));
        assert ExpectedData = HWDATAM
        report ErrorStr
        severity ERROR;
      end if;
    end if;
  end if;
end process p_DataCheckSeq;

-- -----------------------------------------------------------------------------
-- Assigning internal signals to the outputs
-- -----------------------------------------------------------------------------
HRESP             <= iHRESP;

HRESPM            <= iHRESPM;

HREADYOUT         <= iHREADYOUT;

HREADYOUTM        <= iHREADYOUTM;

HRDATA            <= iHRDATA;

HRDATAM           <= iHRDATAM;

-- -----------------------------------------------------------------------------
-- START OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- END OF PROTOCOL CHECKERS
-- -----------------------------------------------------------------------------

end behavioural;

-- --================================== End ==================================--
