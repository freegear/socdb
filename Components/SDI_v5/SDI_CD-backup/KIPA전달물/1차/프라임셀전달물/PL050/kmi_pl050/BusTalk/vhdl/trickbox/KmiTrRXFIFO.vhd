--  ----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only
--  as authorised by a licensing agreement from ARM Limited
--  (C) COPYRIGHT 1998 ARM Limited
--  ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised copies
--  and copies may only be made to the extent permitted by a
--  licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information :
--
--
--  Filename            : KmiTrRXFIFO.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
--  ----------------------------------------------------------------------------
-- Purpose : This block provides the Storage for the recieved Data.
--
-- ----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrRXFIFO is
  port (
        PCLK      : in  std_logic;  -- Clock
        BnRES     : in  std_logic;  -- Reset 
        Write     : in  std_logic;  -- FIFO Write enable
        Read      : in  std_logic;  -- FIFO Read  enable
        DataIn    : in  std_logic_vector(7 downto 0); -- Data bus
        Ffull     : out std_logic;  -- FIFO Full
        Fempty    : out std_logic;  -- FIFO Empty
        Fhalfmore : out std_logic;  -- FIFO more than half filled
        DataOut   : out std_logic_vector(7 downto 0)  -- Data Out
        );
end KmiTrRXFIFO;

-- ----------------------------------------------------------------------------
--
--                        KmiTrRXFIFO
--                        ===========
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- This modules stores the received data in the Fifo. Whenever Read signal is 
-- asserted, Next Data stored in FIFO is being routed to the Output Data Bus. 
-- This fifo is 32 word deep. This module also generates various flags to 
-- indicate the current status of fifo. There are two internal pointers,
-- pointing to current read and write locations. Based on the position of 
-- these pointers, fifo flags are being asserted and cleared. 
--
-- ----------------------------------------------------------------------------
--
-- ========================== ARCHITECTURE ====================================
--

architecture behavioural of KmiTrRXFIFO is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal RegFile0      :  std_logic_vector(7 downto 0);  
-- Fifo Register0

signal NextRegFile0  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile0
 
signal RegFile1      :  std_logic_vector(7 downto 0);  
-- Fifo Register1

signal NextRegFile1  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile1
 
signal RegFile2      :  std_logic_vector(7 downto 0);  
-- Fifo Register2

signal NextRegFile2  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile2
 
signal RegFile3      :  std_logic_vector(7 downto 0);  
-- Fifo Register3

signal NextRegFile3  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile3
 
signal RegFile4      :  std_logic_vector(7 downto 0);  
-- Fifo Register4

signal NextRegFile4  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile4
 
signal RegFile5      :  std_logic_vector(7 downto 0);  
-- Fifo Register5

signal NextRegFile5  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile5
 
signal RegFile6      :  std_logic_vector(7 downto 0);  
-- Fifo Register6

signal NextRegFile6  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile6
 
signal RegFile7      :  std_logic_vector(7 downto 0);  
-- Fifo Register7

signal NextRegFile7  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile7
 
signal RegFile8      :  std_logic_vector(7 downto 0);  
-- Fifo Register8

signal NextRegFile8  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile8
 
signal RegFile9      :  std_logic_vector(7 downto 0);  
-- Fifo Register9

signal NextRegFile9  :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile9
 
signal RegFile10     :  std_logic_vector(7 downto 0);  
-- Fifo Register10

signal NextRegFile10 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile10
 
signal RegFile11     :  std_logic_vector(7 downto 0);  
-- Fifo Register11

signal NextRegFile11 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile11
 
signal RegFile12     :  std_logic_vector(7 downto 0);  
-- Fifo Register12

signal NextRegFile12 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile12
 
signal RegFile13     :  std_logic_vector(7 downto 0);  
-- Fifo Register13

signal NextRegFile13 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile13
 
signal RegFile14     :  std_logic_vector(7 downto 0);  
-- Fifo Register14

signal NextRegFile14 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile14
 
signal RegFile15     :  std_logic_vector(7 downto 0);  
-- Fifo Register15

signal NextRegFile15 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile15
 
signal RegFile16     :  std_logic_vector(7 downto 0);  
-- Fifo Register16

signal NextRegFile16 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile16
 
signal RegFile17     :  std_logic_vector(7 downto 0);  
-- Fifo Register17

signal NextRegFile17 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile17
 
signal RegFile18     :  std_logic_vector(7 downto 0);  
-- Fifo Register18

signal NextRegFile18 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile18
 
signal RegFile19     :  std_logic_vector(7 downto 0);  
-- Fifo Register19

signal NextRegFile19 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile19
 
signal RegFile20     :  std_logic_vector(7 downto 0);  
-- Fifo Register20

signal NextRegFile20 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile20
 
signal RegFile21     :  std_logic_vector(7 downto 0);  
-- Fifo Register21

signal NextRegFile21 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile21
 
signal RegFile22     :  std_logic_vector(7 downto 0);  
-- Fifo Register22

signal NextRegFile22 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile22
 
signal RegFile23     :  std_logic_vector(7 downto 0);  
-- Fifo Register23

signal NextRegFile23 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile23
 
signal RegFile24     :  std_logic_vector(7 downto 0);  
-- Fifo Register24

signal NextRegFile24 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile24
 
signal RegFile25     :  std_logic_vector(7 downto 0);  
-- Fifo Register25

signal NextRegFile25 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile25
 
signal RegFile26     :  std_logic_vector(7 downto 0);  
-- Fifo Register26

signal NextRegFile26 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile26
 
signal RegFile27     :  std_logic_vector(7 downto 0);  
-- Fifo Register27

signal NextRegFile27 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile27
 
signal RegFile28     :  std_logic_vector(7 downto 0);  
-- Fifo Register28

signal NextRegFile28 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile28
 
signal RegFile29     :  std_logic_vector(7 downto 0);  
-- Fifo Register29

signal NextRegFile29 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile29
 
signal RegFile30     :  std_logic_vector(7 downto 0);  
-- Fifo Register30

signal NextRegFile30 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile30
 
signal RegFile31     :  std_logic_vector(7 downto 0);  
-- Fifo Register31

signal NextRegFile31 :  std_logic_vector(7 downto 0);  
-- D-Input of RegFile31
 
signal PtrWr         : std_logic_vector(4 downto 0); 
-- Pointer to write
 
signal NextPtrWr     : std_logic_vector(4 downto 0); 
-- D-Input of PtrWr

signal PtrRd         : std_logic_vector(4 downto 0); 
-- Pointer to read
 
signal NextPtrRd     : std_logic_vector(4 downto 0); 
-- D-Input of PtrRd

signal FillLvl       : std_logic_vector(5 downto 0); 
-- Fill Level Indicator

signal NextFfull     : std_logic;  
-- Fifo Full Indicator
 
signal NextFempty    : std_logic;  
-- Fifo Empty Indicator
 
signal NextFhalfmore : std_logic;  
-- Fifo more than half filled
 
signal NextDataOut   : std_logic_vector(7 downto 0); 
-- D-Input of DataOut

signal Wrap          : std_logic;  
-- Wrap bit
 
signal NextWrap      : std_logic;  
-- D-Input of Wrap

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------
 
begin

-- ----------------------------------------------------------------------------
-- This process initializes different signals used in this module. It also
-- updates the signals at positive edge of PCLK.
-- ----------------------------------------------------------------------------
p_ResSeq : process (BnRES, PCLK) 
begin
  if (BnRES = '0') then
    Fempty    <= '1';
    Ffull     <= '0';
    Fhalfmore <= '0';
    Wrap      <= '0';
    PtrWr     <= "00000";
    PtrRd     <= "00000";
    DataOut   <= "00000000";
    RegFile0  <= "00000000";
    RegFile1  <= "00000000";
    RegFile2  <= "00000000";
    RegFile3  <= "00000000";
    RegFile4  <= "00000000";
    RegFile5  <= "00000000";
    RegFile6  <= "00000000";
    RegFile7  <= "00000000";
    RegFile8  <= "00000000";
    RegFile9  <= "00000000";
    RegFile10 <= "00000000";
    RegFile11 <= "00000000";
    RegFile12 <= "00000000";
    RegFile13 <= "00000000";
    RegFile14 <= "00000000";
    RegFile15 <= "00000000";
    RegFile16 <= "00000000";
    RegFile17 <= "00000000";
    RegFile18 <= "00000000";
    RegFile19 <= "00000000";
    RegFile20 <= "00000000";
    RegFile21 <= "00000000";
    RegFile22 <= "00000000";
    RegFile23 <= "00000000";
    RegFile24 <= "00000000";
    RegFile25 <= "00000000";
    RegFile26 <= "00000000";
    RegFile27 <= "00000000";
    RegFile28 <= "00000000";
    RegFile29 <= "00000000";
    RegFile30 <= "00000000";
    RegFile31 <= "00000000";
  elsif (PCLK'event and PCLK = '1') then
    Fempty    <= NextFempty;
    Ffull     <= NextFfull;
    Fhalfmore <= NextFhalfmore;
    Wrap      <= NextWrap;
    PtrWr     <= NextPtrWr;
    PtrRd     <= NextPtrRd;
    DataOut   <= NextDataOut;
    RegFile0  <= NextRegFile0;
    RegFile1  <= NextRegFile1;
    RegFile2  <= NextRegFile2;
    RegFile3  <= NextRegFile3;
    RegFile4  <= NextRegFile4;
    RegFile5  <= NextRegFile5;
    RegFile6  <= NextRegFile6;
    RegFile7  <= NextRegFile7;
    RegFile8  <= NextRegFile8;
    RegFile9  <= NextRegFile9;
    RegFile10 <= NextRegFile10;
    RegFile11 <= NextRegFile11;
    RegFile12 <= NextRegFile12;
    RegFile13 <= NextRegFile13;
    RegFile14 <= NextRegFile14;
    RegFile15 <= NextRegFile15;
    RegFile16 <= NextRegFile16;
    RegFile17 <= NextRegFile17;
    RegFile18 <= NextRegFile18;
    RegFile19 <= NextRegFile19;
    RegFile20 <= NextRegFile20;
    RegFile21 <= NextRegFile21;
    RegFile22 <= NextRegFile22;
    RegFile23 <= NextRegFile23;
    RegFile24 <= NextRegFile24;
    RegFile25 <= NextRegFile25;
    RegFile26 <= NextRegFile26;
    RegFile27 <= NextRegFile27;
    RegFile28 <= NextRegFile28;
    RegFile29 <= NextRegFile29;
    RegFile30 <= NextRegFile30;
    RegFile31 <= NextRegFile31;
  end if;
end process p_ResSeq;
 
-- ----------------------------------------------------------------------------
-- PtrWr is being updated at every Write.
-- ----------------------------------------------------------------------------
p_PtrWrComb : process (Write, PtrWr)
begin
  if (Write = '1') then
    NextPtrWr <= unsigned(PtrWr) + 1;
  else 
    NextPtrWr <= PtrWr; 
  end if;
end process p_PtrWrComb;

-- ----------------------------------------------------------------------------
-- PtrRd is being updated at every Read.
-- ----------------------------------------------------------------------------
p_PtrRdComb : process (Read, PtrRd)
begin
  if ((Read = '1') and (FillLvl /= "000000")) then
     NextPtrRd <= unsigned(PtrRd) + 1;
  else 
     NextPtrRd <= PtrRd; 
  end if;
end process p_PtrRdComb;

-- ----------------------------------------------------------------------------
-- Wrap update
-- ----------------------------------------------------------------------------
p_WrapComb : process (PtrWr, PtrRd, Wrap, Write, Read)
begin
  if (((PtrWr = "11111") and (Write = '1')) xor
      ((PtrRd = "11111") and (Read = '1'))) then
    NextWrap <= not(Wrap);
  else 
    NextWrap <= Wrap; 
  end if;
end process p_WrapComb;

FillLvl <= unsigned(Wrap & PtrWr) - unsigned('0' & PtrRd); 

-- ----------------------------------------------------------------------------
-- Fempty is being asserted whenever FillLvl reaches to zero.
-- ----------------------------------------------------------------------------
p_FemptyComb : process (FillLvl)
begin
  if (FillLvl = "000000") then
    NextFempty <= '1';
  else
    NextFempty <= '0';
  end if;
end process p_FemptyComb;

-- ----------------------------------------------------------------------------
-- Ffull is being asserted whenever FillLvl reaches to 31.
-- ----------------------------------------------------------------------------
p_FfullComb : process (FillLvl)
begin
  if (FillLvl = "011111") then
    NextFfull <= '1';
  else
    NextFfull <= '0';
  end if;
end process p_FfullComb;

-- ----------------------------------------------------------------------------
-- Fhalfmore is being asserted whenever FillLvl greater then 15.
-- ----------------------------------------------------------------------------
p_FhalfmoreComb : process (FillLvl)
begin
  if (FillLvl > "001111") then
    NextFhalfmore  <= '1';
  else
    NextFhalfmore  <= '0';
  end if;
end process p_FhalfmoreComb;

-- ----------------------------------------------------------------------------
-- Write to Register Array
-- ----------------------------------------------------------------------------
p_RegFileComb : process (PtrWr, DataIn, Write, RegFile0, RegFile1, RegFile2, 
                         RegFile3, RegFile4, RegFile5, RegFile6, RegFile7, 
                         RegFile8, RegFile9, RegFile10, RegFile11, RegFile12, 
                         RegFile13, RegFile14, RegFile15, RegFile16, RegFile17, 
                         RegFile18, RegFile19, RegFile20, RegFile21, RegFile22,
                         RegFile23, RegFile24, RegFile25, RegFile26, RegFile27,
                         RegFile28, RegFile29, RegFile30, RegFile31)
begin
NextRegFile0  <= RegFile0;
NextRegFile1  <= RegFile1;
NextRegFile2  <= RegFile2;
NextRegFile3  <= RegFile3;
NextRegFile4  <= RegFile4;
NextRegFile5  <= RegFile5;
NextRegFile6  <= RegFile6;
NextRegFile7  <= RegFile7;
NextRegFile8  <= RegFile8;
NextRegFile9  <= RegFile9;
NextRegFile10 <= RegFile10;
NextRegFile11 <= RegFile11;
NextRegFile12 <= RegFile12;
NextRegFile13 <= RegFile13;
NextRegFile14 <= RegFile14;
NextRegFile15 <= RegFile15;
NextRegFile16 <= RegFile16;
NextRegFile17 <= RegFile17;
NextRegFile18 <= RegFile18;
NextRegFile19 <= RegFile19;
NextRegFile20 <= RegFile20;
NextRegFile21 <= RegFile21;
NextRegFile22 <= RegFile22;
NextRegFile23 <= RegFile23;
NextRegFile24 <= RegFile24;
NextRegFile25 <= RegFile25;
NextRegFile26 <= RegFile26;
NextRegFile27 <= RegFile27;
NextRegFile28 <= RegFile28;
NextRegFile29 <= RegFile29;
NextRegFile30 <= RegFile30;
NextRegFile31 <= RegFile31;
if (Write = '1') then
  case PtrWr is
    when "00000" =>
      NextRegFile0   <= DataIn;

    when "00001" =>
      NextRegFile1   <= DataIn;

    when "00010" =>
      NextRegFile2   <= DataIn;

    when "00011" =>
      NextRegFile3   <= DataIn;

    when "00100" =>
      NextRegFile4   <= DataIn;

    when "00101" =>
      NextRegFile5   <= DataIn;

    when "00110" =>
      NextRegFile6   <= DataIn;

    when "00111" =>
      NextRegFile7   <= DataIn;

    when "01000" =>
      NextRegFile8   <= DataIn;

    when "01001" =>
      NextRegFile9   <= DataIn;

    when "01010" =>
      NextRegFile10  <= DataIn;

    when "01011" =>
      NextRegFile11  <= DataIn;

    when "01100" =>
      NextRegFile12  <= DataIn;

    when "01101" =>
      NextRegFile13  <= DataIn;

    when "01110" =>
      NextRegFile14  <= DataIn;

    when "01111" =>
      NextRegFile15  <= DataIn;

    when "10000" =>
      NextRegFile16  <= DataIn;

    when "10001" =>
      NextRegFile17  <= DataIn;

    when "10010" =>
      NextRegFile18  <= DataIn;

    when "10011" =>
      NextRegFile19  <= DataIn;

    when "10100" =>
      NextRegFile20  <= DataIn;

    when "10101" =>
      NextRegFile21  <= DataIn;

    when "10110" =>
      NextRegFile22  <= DataIn;

    when "10111" =>
      NextRegFile23  <= DataIn;

    when "11000" =>
      NextRegFile24  <= DataIn;

    when "11001" =>
      NextRegFile25  <= DataIn;

    when "11010" =>
      NextRegFile26  <= DataIn;

    when "11011" =>
      NextRegFile27  <= DataIn;

    when "11100" =>
      NextRegFile28  <= DataIn;

    when "11101" =>
      NextRegFile29  <= DataIn;

    when "11110" =>
      NextRegFile30  <= DataIn;

    when "11111" =>
      NextRegFile31  <= DataIn;

    when others =>
      null;
  end case;
end if;
end process p_RegFileComb;

-- ----------------------------------------------------------------------------
-- Output Data is updated.
-- ----------------------------------------------------------------------------
p_DataOutComb : process (PtrRd, RegFile0, RegFile1, RegFile2, RegFile3, 
                         RegFile4, RegFile5, RegFile6, RegFile7, RegFile8, 
                         RegFile9, RegFile10, RegFile11, RegFile12, RegFile13,
                         RegFile14, RegFile15, RegFile16, RegFile17, RegFile18,
                         RegFile19, RegFile20, RegFile21, RegFile22, RegFile23,
                         RegFile24, RegFile25, RegFile26, RegFile27, RegFile28,
                         RegFile29, RegFile30, RegFile31)
begin
  case PtrRd is
    when "00000" => 
      NextDataOut <= RegFile0;
 
    when "00001" => 
      NextDataOut <= RegFile1;

    when "00010" => 
      NextDataOut <= RegFile2;

    when "00011" => 
      NextDataOut <= RegFile3;

    when "00100" => 
      NextDataOut <= RegFile4;

    when "00101" => 
      NextDataOut <= RegFile5;

    when "00110" => 
      NextDataOut <= RegFile6;

    when "00111" => 
      NextDataOut <= RegFile7;

    when "01000" => 
      NextDataOut <= RegFile8;

    when "01001" => 
      NextDataOut <= RegFile9;

    when "01010" => 
      NextDataOut <= RegFile10;

    when "01011" => 
      NextDataOut <= RegFile11;

    when "01100" => 
      NextDataOut <= RegFile12;

    when "01101" => 
      NextDataOut <= RegFile13;

    when "01110" => 
      NextDataOut <= RegFile14;

    when "01111" => 
      NextDataOut <= RegFile15;

    when "10000" => 
      NextDataOut <= RegFile16;

    when "10001" => 
      NextDataOut <= RegFile17;

    when "10010" => 
      NextDataOut <= RegFile18;

    when "10011" => 
      NextDataOut <= RegFile19;

    when "10100" => 
      NextDataOut <= RegFile20;

    when "10101" => 
      NextDataOut <= RegFile21;

    when "10110" => 
      NextDataOut <= RegFile22;

    when "10111" => 
      NextDataOut <= RegFile23;

    when "11000" => 
      NextDataOut <= RegFile24;

    when "11001" => 
      NextDataOut <= RegFile25;

    when "11010" => 
      NextDataOut <= RegFile26;

    when "11011" => 
      NextDataOut <= RegFile27;

    when "11100" => 
      NextDataOut <= RegFile28;

    when "11101" => 
      NextDataOut <= RegFile29;

    when "11110" => 
      NextDataOut <= RegFile30;

    when "11111" => 
      NextDataOut <= RegFile31;
 
    when others  => null;
 end case;
end process p_DataOutComb; 

end behavioural;

--====================== End of KmiTrRXFIFO ==================================
