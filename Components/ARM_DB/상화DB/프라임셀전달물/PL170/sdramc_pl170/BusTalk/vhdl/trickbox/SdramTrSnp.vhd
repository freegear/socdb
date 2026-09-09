--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : $RCS: $
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
--  ----------------------------------------------------------------------------
--  Purpose                :  Module to "log" commands issued by the controller
--                            to the SDRAM devices
--  ----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

entity SdramTrSnp is
  port (
        HCLK       : in   std_logic;  -- Input Clock To The Snooper 
        nReset     : in   std_logic;  -- Input Reset To The Snooper 
        FifoIn     : in   std_logic_vector(16 downto 0); 
                                      -- Input data to the Snooper
        ChipSelect : in   std_logic_vector(3 downto 0); 
                                      -- Chip Select Signal
        FifoClear  : in   std_logic;  -- Signal to clear the FIFO
        FifoEn     : in   std_logic;  -- Signal to Enable the FIFO
        ReadEn     : in   std_logic;  -- To Read the FIFO
        ModeBit    : in   std_logic;  -- Mode Select bit
        SupREFBit  : in   std_logic;  -- Prevents REF beign stored in the FIFO
        SupALL     : in   std_logic;  -- Disables the storing of ALL commands
                                      -- except READ and WRITE
        FifoOut    : out  std_logic_vector(31 downto 0)   
                                      -- Fifo Data Output 
       );
end SdramTrSnp;

--  ----------------------------------------------------------------------------
--
--                    SdramTrSnooper 
--                    ===============
--
--  ----------------------------------------------------------------------------
--  Overview
--  ========
-- This module "snoops" the SDRAM bus and stores the command encoding and
-- the access address in a FIFO. This FIFO may be read or cleared under
-- program control.
--
--===========================ARCHITECTURE=======================================
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of SdramTrSnp is
-- ----------------------------------------------------------------------------
--  Constant Declarations
-- ----------------------------------------------------------------------------
--  ---------------------------------------------------------------------------
--  Range and Width Definitions
--  ---------------------------------------------------------------------------
constant FIFO_DEPTH          : integer := 128;
constant MAXADDR             : integer := 7;

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
signal  DevSel               : std_logic;
-- Signal which indicates whether a Device is selected

signal  iFifoOut             : std_logic_vector(31 downto 0); 
-- local copy of FIFO data output 

signal  NextFifoOut          : std_logic_vector(31 downto 0); 
-- D-input of iFifoOut register

type FIFOARRAY is array((FIFO_DEPTH - 1) downto 0)
                       of std_logic_vector(31 downto 0);

signal  FifoData             : FIFOARRAY;
-- Array of Fifo datas each 32 bit wide

signal  ShiftFifoData        : FIFOARRAY;

signal  NextFifoData         : std_logic_vector(31 downto 0);
-- Input to the ShiftFifoData

signal  SnoopEn              : std_logic;
-- Signal which decides whether data has to be encoded in the FIFO

signal  WritePntr            : integer := 0;
-- Gives the number of the FIFO word into which the encoded data is written

signal  NextWritePntr        : integer := 0; 
-- D - input of the WritePntr

--------------------------------------------------------------------------------
-- Main VHDL code
-- ==============
--------------------------------------------------------------------------------
 
begin

DevSel  <=  not(ChipSelect(3) and ChipSelect(2) and ChipSelect(1)
                 and ChipSelect(0));

FifoOut <= iFifoOut;
--------------------------------------------------------------------------------
--   Combinational block which checks for a Snoop Enable condition and does
--   the encoding of the FIFO data to a 32 bit register NextFifoData.
--------------------------------------------------------------------------------
p_EncodeComb : process (FifoIn, FifoEn, ChipSelect, SnoopEn,
                        DevSel, SupREFBit, SupALL, ModeBit)

   variable VarSnoopEn : std_logic;
   variable VarREF     : std_logic;
   variable VarSCCR    : std_logic;

begin

  NextFifoData  <= (others => '0');
  VarSnoopEn    := '0';
  VarREF        := '0';
  VarSCCR       := '0';
------------------------------------------------------------------------------
--  Command Field - 3 bits
-----------------------------------------------------------------------------
  if (FifoEn = '1') then
    if (DevSel = '1' and FifoIn(16) = '0' and FifoIn(15) = '0' and 
        FifoIn(14) = '1' and SupREFBit = '0' and SupALL = '0') then
      NextFifoData(31 downto 29)     <= "111";       -- REF
      VarSnoopEn                     := '1';
      VarREF                         := '1';
    end if;

    if (DevSel = '1' and FifoIn(16) = '1' and FifoIn(15) = '1' and 
        FifoIn(14) = '0' and FifoIn(10) = '1' and ModeBit ='1' and 
        SupALL = '0') then
      if (FifoIn(7) = '0' and FifoIn(6) ='0' and FifoIn(5) ='0') then 
        NextFifoData(31 downto 29)   <= "110";       -- PFCA
        VarSnoopEn                   := '1';
      elsif (FifoIn(7) = '1') then
        NextFifoData(31 downto 29)   <= "010";       -- RSTA
        VarSnoopEn                   := '1';
      end if;
    end if;
-------------------------------------------------------------------------------
--  In DRAM mode, (ModeBit = 0),Check for PFCA replaced by PRE
-------------------------------------------------------------------------------
    if (DevSel = '1' and FifoIn(16) = '0' and FifoIn(15) ='1' and 
        ModeBit ='0' and FifoIn(14) = '0' and FifoIn(10) ='0' and 
        SupALL = '0') then
      NextFifoData(31 downto 29)     <= "110";         -- PRE
      VarSnoopEn                     := '1';
    end if;
 
    if (DevSel = '1' and FifoIn(16) = '1' and FifoIn(15) ='0' and 
        FifoIn(14) = '1') then
      NextFifoData(31 downto 29)     <= "101";         -- READ
      VarSnoopEn                     := '1';
    end if;

    if (DevSel = '1' and FifoIn(16) ='1' and FifoIn(15) ='0' and FifoIn(14) ='0'
        and ((ModeBit ='1' and FifoIn(13) ='0') or ModeBit ='0')) then
      NextFifoData(31 downto 29)     <= "100";         -- WRITE
      VarSnoopEn                     := '1';
    end if;

    if (DevSel = '1' and FifoIn(16) = '0' and FifoIn(15) ='1' and 
        FifoIn(14) = '1' and SupALL = '0') then
      NextFifoData(31 downto 29)     <= "011";         -- ACT
      VarSnoopEn                     := '1';
    end if;

    if (DevSel ='1' and FifoIn(16) ='0' and  FifoIn(15) ='0' and 
       FifoIn(14) ='0' and SupALL = '0') then
      if (ModeBit = '0') then
        NextFifoData(31 downto 29)   <= "000";       -- SDRAM MODE
        VarSnoopEn                   := '1';   
      elsif (FifoIn(13 downto 5) = "000000001") then
        NextFifoData(31 downto 29)   <= "000";       -- SCLR
        VarSnoopEn                   := '1';  
      elsif (FifoIn(8 downto 5) = "0011") then
        NextFifoData(31 downto 29)   <= "001";       -- SCCR
        VarSnoopEn                   := '1';
        VarSCCR                      := '1';  
      end if;
    end if;
-------------------------------------------------------------------------------
--             Device Field - 2 bits
-------------------------------------------------------------------------------
  if (VarSnoopEn ='1') then
    if ( VarREF ='1') then
      NextFifoData(28 downto 25)     <= ChipSelect(3 downto 0);
      NextFifoData(24 downto 13)     <= FifoIn(13 downto 2);
    else
      case ChipSelect is
        when "1110" =>
          NextFifoData(28 downto 27) <= "00";
        when "1101" =>
          NextFifoData(28 downto 27) <= "01";
        when "1011" =>
          NextFifoData(28 downto 27) <= "10";
        when "0111" =>
          NextFifoData(28 downto 27) <= "11";
        when others =>
          NextFifoData(28 downto 27) <= "00";
      end case;
---------------------------------- -------------------------------------------
--            Bank Field - 1 bits
------------------------------------------------------------------------------
      NextFifoData(26)               <= FifoIn(13);
-------------------------------------------------------------------------------
--             Page Field - 13 bits
-------------------------------------------------------------------------------
      NextFifoData(25 downto 13)     <= FifoIn(12 downto 0);
    end if;
------------------------------------------------------------------------------
--            Channel Fields - 4 bits
------------------------------------------------------------------------------
    if (VarSCCR ='1') then
      NextFifoData(12 downto 9)      <= FifoIn(12 downto 9);
    else
      NextFifoData(12 downto 11)     <= FifoIn(12 downto 11);
      NextFifoData(10 downto 9)      <= FifoIn(9 downto 8);
    end if;
-------------------------------------------------------------------------------
--            Segment Field - 2 bits
-------------------------------------------------------------------------------
    NextFifoData(8 downto 7)         <= FifoIn(1 downto 0);
-------------------------------------------------------------------------------
--            Column Field - 6 bits
-------------------------------------------------------------------------------
    NextFifoData(6 downto 1)         <= FifoIn(5 downto 0);
-------------------------------------------------------------------------------
--             Valid Field - 1 bit
--------------------------------------------------------------------------------
    NextFifoData(0)                  <= '1';
  end if;

  SnoopEn  <= VarSnoopEn; 
  end if;
end process p_EncodeComb;

-------------------------------------------------------------------------------
-- Whenever a Fifo Clear or Snoop Enable or Read Enable comes ,the required
-- changes will be made to ShiftFifoData[i] respectively. The contents of the
-- ShiftFifoData[i] will be moved to the FifoData[i] at the positive edge
-- of the HCLK in the sequential block.
-------------------------------------------------------------------------------

p_ShiftRegComb : process (FifoClear, SnoopEn, ReadEn, NextFifoData,
                          WritePntr, FifoData(0), FifoIn, iFifoOut)

variable TempFifoData : std_logic_vector(31 downto 0);
begin
  for i in 0 to (FIFO_DEPTH - 1) loop
    ShiftFifoData(i)         <= FifoData(i);
  end loop;

  if (FifoClear ='1') then
    NextWritePntr            <= 0;
    for i in 0 to (FIFO_DEPTH - 1) loop
      TempFifoData           := FifoData(i);
      TempFifoData(0)        := '0';
      ShiftFifoData(i)       <= TempFifoData;
    end loop;
  elsif (SnoopEn ='1') then
-------------------------------------------------------------------------------
-- Moving the encoded data to the WritePntr location of ShiftFifoData, when
-- Snoop Enable is set, which will be refreshed to FifoData at posedge of
-- the HCLK.
-------------------------------------------------------------------------------
    NextWritePntr            <= WritePntr + 1;
    ShiftFifoData(WritePntr) <= NextFifoData;
  elsif (ReadEn ='1') then 
-------------------------------------------------------------------------------
-- The data in the FIFO register header is transfered to
-- NextFifoOut, when Read Enable is set.This information will later be
-- transfered to FifoOut at the positive edge of the HCLK.
-------------------------------------------------------------------------------
    NextFifoOut              <= FifoData(0);
    NextWritePntr            <= WritePntr - 1;
    for i in 0 to (FIFO_DEPTH - 2) loop
      ShiftFifoData(i)       <= FifoData(i + 1);
    end loop;
  else
    NextFifoOut              <= iFifoOut;
    NextWritePntr            <= WritePntr;
  end if;

end process p_ShiftRegComb;

-------------------------------------------------------------------------------
-- Sequential block in which the data is transfered to FIFO registers at
-- the positive edge of the HCLK.
-------------------------------------------------------------------------------
p_ShiftRegSeq : process (HCLK, nReset)
begin
  if(nReset = '0') then
    WritePntr          <= 0;
    iFifoOut           <= (others => '0');
    for i in 0 to (FIFO_DEPTH - 1) loop
      FifoData(i)      <= (others => '0');
--      ShiftFifoData(i) <= (others => '0');
    end loop;
  elsif (HCLK'event and HCLK = '1') then
    WritePntr          <= NextWritePntr ;
    iFifoOut           <= NextFifoOut ;
    for i in 0 to (FIFO_DEPTH - 1) loop
      FifoData(i)      <= ShiftFifoData(i);
    end loop;
  end if;
end process p_ShiftRegSeq;

end behavioural;

-- ==========================End of SdramTrSnp==============================












