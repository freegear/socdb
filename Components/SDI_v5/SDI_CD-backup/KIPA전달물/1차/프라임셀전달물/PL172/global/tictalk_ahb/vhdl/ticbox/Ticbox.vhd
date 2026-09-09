-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Ticbox.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           External AMBA TIC testbox
--           Reads data from input file and ouptuts AMBA test
--           interface signals TESTREQA, TESTREQB and the data bus
--           TESTBUS.
--           When performing reads, a comparison is made between
--           the read value and the expected value (both previously
--           masked by a mask value) and a result message is
--           broadcast.
--
-- --=================================================================--

-- ---------------------------------------------------------------------
--  INPUT FILE FORMAT
--
-- ; at beginning of line implies a comment
-- Vector Type    Data    Mask
--
-- Vector Type
--    A   - Address
--    W   - Write (also used for burst writes)
--    R   - Read
--    L   - Loop
--    E   - Exit test mode
--
-- Data (In hex, integer for Loop)
--
-- Mask (In hex) - only used in read cycles
--
-- ---------------------------------------------------------------------
-- Three generics are used with this model:
--  Filename is used to set the test vector input file to be used.
--  HaltOnMismatch is used to make the simulation end when a read error
--  is detected. The default is to just display a warning for a read
--  error.
--  Verbosity is used to turn off the displaying of the TIF input vector
--   comments. The default is to display all TIF vector comments.
--
-- The default values set in this module are the same as those in the
-- TBTic module.
-- System specific changes to the values should be made in the TBTic
-- module.
-- ---------------------------------------------------------------------

library IEEE;
use     IEEE.std_logic_1164.all;

use     std.textio.all;

library common;
use     common.conv.all;

entity Ticbox is
  generic (
           FileName       : string  := "infile.tif";
           HaltOnMismatch : boolean := FALSE;
           Verbosity      : boolean := TRUE
          );
  port (
        nReset           : in    std_logic; -- System reset
        TESTCLK          : in    std_logic; -- Test mode clock input
        TESTACK          : in    std_logic; -- Test acknowledge

        TESTBUS          : inout std_logic_vector(31 downto 0);
                                -- Bidirectional test port

        TESTREQA         : out   std_logic := '0'; -- Test bus request A
        TESTREQB         : out   std_logic := '0'  -- Test bus request B
       );
end Ticbox;
-- ---------------------------------------------------------------------

-- --======================= ARCHITECTURE ============================--

architecture behavioural of Ticbox is

-- ---------------------------------------------------------------------
file Infile : text is in "../../bustest/invec/infile.tif";

-- ---------------------------------------------------------------------
-- Function declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- StdVec2Hex
-- ----------
--   This function converts a 32-bit std_logic_vector to an 8 character
-- hex string
-- ---------------------------------------------------------------------
function StdVec2Hex (
         VAL : std_logic_vector
                    ) return string is
variable Result : string (1 to 8);
-- Output string

variable Temp   : std_logic_vector(3 downto 0);
-- Temp input data

begin
  for i in 7 downto 0 loop    -- Loops round 8 characters of output
                              -- string
    Result(8-i) := ' ';
    for j in 3 downto 0 loop  -- Loops round four bits of each
                              -- character
      Temp(j) := VAL((i*4)+j);
    end loop;
    case Temp(3 downto 0) is
      when "0000" => Result(8-i) := '0';
      when "0001" => Result(8-i) := '1';
      when "0010" => Result(8-i) := '2';
      when "0011" => Result(8-i) := '3';
      when "0100" => Result(8-i) := '4';
      when "0101" => Result(8-i) := '5';
      when "0110" => Result(8-i) := '6';
      when "0111" => Result(8-i) := '7';
      when "1000" => Result(8-i) := '8';
      when "1001" => Result(8-i) := '9';
      when "1010" => Result(8-i) := 'A';
      when "1011" => Result(8-i) := 'B';
      when "1100" => Result(8-i) := 'C';
      when "1101" => Result(8-i) := 'D';
      when "1110" => Result(8-i) := 'E';
      when "1111" => Result(8-i) := 'F';
      when "ZZZZ" => Result(8-i) := 'Z';
      when others => Result(8-i) := 'X';
    end case;
  end loop;
  return Result;
end StdVec2Hex;

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
-- Used to initialise the system test
signal Start            : std_logic := '0';

-- Used to generate the TESTREQA/B outputs
signal iTESTREQA        : std_logic := '0';
signal iTESTREQB        : std_logic := '0';
signal REQA             : std_logic := '0';
signal REQB             : std_logic := '0';
signal TestreqPrev      : std_logic_vector(1 downto 0)
                        := (others => '0');
signal TestackPrev      : std_logic := '1';

-- Indicates turnaround at end of read cycle
signal LastRead         : std_logic := '0';

-- Registered values for read vector checking, used as there is a delay
-- between starting a read transfer (when reach 'R' command in TIF
-- file) and checking the read value (when the slave has driven out the
-- read data).
signal Compare          : std_logic := '0';
signal CompReg0         : std_logic := '0';
signal CompReg1         : std_logic := '0';
signal CompReg2         : std_logic := '0';
-- Mask from read command
signal Mask             : std_logic_vector(31 downto 0)
                        := (others => '1');
signal MaskReg1         : std_logic_vector(31 downto 0)
                        := (others => '0');
signal MaskReg2         : std_logic_vector(31 downto 0)
                        := (others => '0');
signal MaskReg3         : std_logic_vector(31 downto 0)
                        := (others => '0');
-- Expected read data registers
signal ReadReg1         : std_logic_vector(31 downto 0)
                        := (others => '0');
signal ReadReg2         : std_logic_vector(31 downto 0)
                        := (others => '0');
signal ReadReg3         : std_logic_vector(31 downto 0)
                        := (others => '0');

-- Expected read or write data, or address value
signal Data             : std_logic_vector(31 downto 0)
                        := (others => 'Z');
-- Write data or address value registers
signal DataReg1         : std_logic_vector(31 downto 0)
                        := (others => 'Z');
signal DataReg2         : std_logic_vector(31 downto 0)
                        := (others => 'Z');

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Start signal generation
-- ---------------------------------------------------------------------
-- Start is initially set LOW, and is used to set the TESTREQA/B
-- outputs to indicate that test mode is being requested.
-- It is then set HIGH when TESTACK is first set HIGH, indicating that
-- test mode has been entered.

p_StartComb : process
begin
  Start <= '0';
  wait until (TESTCLK'event and TESTCLK = '1' and TESTACK = '1');
  Start <= '1';
  wait on nReset; -- Will loop back if system is reset
end process p_StartComb;

-- ---------------------------------------------------------------------
-- TESTREQA/B output generation
-- ---------------------------------------------------------------------
-- Sets the TESTREQA/B outputs to indicate the start of system testing,
-- or to REQA/B at all other times.

p_TestReqSeq : process (Start, TESTCLK)
begin
  if Start = '0' then
    iTESTREQA <= '1';
    iTESTREQB <= '0';
  elsif (TESTCLK'event and TESTCLK = '1' and TESTACK = '1' and
         LastRead = '0') then
    iTESTREQA <= REQA;
    iTESTREQB <= REQB;
    CompReg0  <= Compare;

-- End the test when HaltOnMismatch is set and the 'E' command is
-- reached in the input file, otherwise TBTic will end the simulation
-- when TESTREQA/B and TESTACK are LOW.
    assert (not (REQA = '0' and REQB = '0' and HaltOnMismatch))
      report "Vector run completed : halting simulation"
      severity failure;
  end if;
end process p_TestReqSeq;

-- ---------------------------------------------------------------------
-- TESTREQA/B previous value
-- ---------------------------------------------------------------------
-- Previous value of TESTREQA/B used during a burst of reads.

p_TestreqPrevSeq : process (TESTCLK)
begin
  if (TESTCLK'event and TESTCLK = '1') then
    if TESTACK = '1' then
      TestreqPrev <= iTESTREQA & iTESTREQB;
    end if;
  end if;
end process p_TestreqPrevSeq;

-- ---------------------------------------------------------------------
-- TESTACK previous value
-- ---------------------------------------------------------------------
-- Previous value of TESTACK used to control the reading of the input
-- data file.

p_TestackPrevSeq : process (TESTCLK)
begin
  if (TESTCLK'event and TESTCLK = '1') then
    TestackPrev <= TESTACK;
  end if;
end process p_TestackPrevSeq;

-- ---------------------------------------------------------------------
-- End of read cycle turnaround detection
-- ---------------------------------------------------------------------
-- Set HIGH when TESTREQA/B change after a read vector, either after a
-- single read or at the end of a burst of reads. Used to stop the
-- input file from being read and the TESTREQ outputs from changing
-- until after the turnaround cycle needed after a read.

LastRead <= '1' when (TestreqPrev = "01" and iTESTREQA = '1' and
                        iTESTREQB = '1')
              else '0';

-- ---------------------------------------------------------------------
-- Read input TIF file
-- ---------------------------------------------------------------------
-- Reads in the tif file a line at a time, and uses VecType to check the
--  command type of the current line - comment, address, write, read,
-- loop or end of test. DataStr and MaskStr are used to get the Data
-- and Mask strings from the current line of the file, and Hex2StdVec
-- is used to convert it from a Hex String into a 32 bit
-- std_logic_vector

-- The Start signal is used as an enable so that the input file is not
-- read until test mode has been entered.
-- This runs from the falling edge of the clock so that the data from
-- the input file is valid 1/2 a cycle before it is needed. This
-- simplifies the module as less register stages are needed than if the
-- input data was read on the rising edge during the previous transfer.

-- TestackPrev is used as TESTACK is not guaranteed to be stable until
-- the rising edge of the clock, so a registered version is used
-- instead. This means that when TESTACK is set, this process will
-- generate the output data early, but will not read any new data in
-- during the next cycle when the rising edge TESTACK enabled data
-- registers are reading in the new values generated in the previous
-- cycle when TESTACK was set.

p_ReadFileSeq : process (TESTCLK)
variable L       : line;               -- Holds the current line
variable LLen    : integer;            -- Checks for empty line
variable VecType : string(1 downto 1); -- Single character vector
                                       -- type
variable LineStr : string(1 to 255);   -- Holds comment string
variable Space   : string(1 downto 1); -- Used to avoid spaces in
                                       -- file
variable DataStr : string(8 downto 1); -- Data part of A, W and R
                                       -- lines
variable MaskStr : string(8 downto 1); -- Mask part of R line
variable Count   : integer := 0;       -- Controls Loop counting
variable Loopon  : std_logic := '0';   -- Controls Loop command
begin
  if (TESTCLK'event and TESTCLK = '0' and TestackPrev = '1' and
      LastRead = '0' and Start = '1') then
    if (not endfile(Infile) and Loopon = '0') then
      readline (Infile, L);
      LLen := L'length;
      VecType := "-";      -- Initialise it to an unused value
      if LLen /= 0 then    -- If empty line, don't read from L as will
        read (L, VecType); --  generate an error.
      end if;
      while (VecType = ";" or LLen = 0) loop
        if VecType = ";" then
          LineStr := (others => ' ');   -- Initialise linestr when
                                        -- looping
          read (L, LineStr(1 to L'length)); -- Assumes max line of
                                            -- 255 chars
          LineStr := VecType & LineStr(1 to 254);
          VecType := "-";          -- Changes VecType to avoid
                                   -- staying in loop
          assert not(Verbosity)
            report LineStr(1 to (LLen + 1))
            severity note;
        end if;
        if not endfile(Infile) then -- Ensures does not read past end
                                    -- of file
          readline (Infile, L);
          LLen := L'length;
          if LLen /= 0 then
            read (L, VecType);
          end if;
        end if;
      end loop;  -- Only exits from loop if not a blank line or a
                 -- comment

      if VecType = "A" then  -- Address vector
        REQA <= '1';
        REQB <= '1';
        Compare <= '0';
        read (L, Space);
        read (L, DataStr);
        if DataStr = "ZZZZZZZZ" then
          Data <= (others => 'Z');
        else
          Data <= Hex2StdVec(DataStr);
        end if;

      elsif VecType = "W" then  -- Write vector
        REQA <= '1';
        REQB <= '0';
        Compare <= '0';
        read (L, Space);
        read (L, DataStr);
        Data <= Hex2StdVec(DataStr);

      elsif VecType = "R" then  -- Read vector
        REQA <= '0';
        REQB <= '1';
        Compare <= '1';
        read (L, Space);
        read (L, DataStr);
        read (L, Space);
        read (L, MaskStr);
        Data <= Hex2StdVec(DataStr);
        Mask <= Hex2StdVec(MaskStr);

      elsif VecType = "L" then  -- Loop vector
        read (L, Space);
        read (L, Count);
        Count := Count - 1;
        if Count <= 0 then
          Loopon := '0';
        else
          Loopon := '1';
        end if;

      elsif VecType = "E" then  -- End of test
        REQA <= '0';
        REQB <= '0';
        Compare <= '0';
      else                -- Should never be reached
        null;
      end if;

    elsif Loopon = '1' then
      Count := Count - 1;
      if Count <= 0 then
        Loopon := '0';
      end if;
    else                  -- If end of file, drive REQA and REQB LOW.
      REQA <= '0';
      REQB <= '0';
      Data <= (others => 'Z');
    end if;
  end if;
end process p_ReadFileSeq;

-- ---------------------------------------------------------------------
-- Read cycle registers
-- ---------------------------------------------------------------------
-- Registers to hold the Compare signal (to indicate that TESTBUS
-- should be compared with the data in the read register), and the read
-- and mask data.

p_CompRegSeq : process (TESTCLK)
begin
  if (TESTCLK'event and TESTCLK = '1' and TESTACK = '1') then
    CompReg2 <= CompReg1;
    CompReg1 <= CompReg0;
  end if;
end process p_CompRegSeq;

p_ReadMaskSeq : process (TESTCLK)
begin
  if (TESTCLK'event and TESTCLK = '1' and TESTACK = '1') then
    ReadReg3 <= ReadReg2;
    ReadReg2 <= ReadReg1;
    MaskReg3 <= MaskReg2;
    MaskReg2 <= MaskReg1;
    if Compare = '1' then
      ReadReg1 <= Data;
      MaskReg1 <= Mask;
    end if;
  end if;
end process p_ReadMaskSeq;

-- ---------------------------------------------------------------------
-- TIF address/write data register
-- ---------------------------------------------------------------------
-- A register is used to hold the address/write data value from the
-- input test file.

p_DataRegSeq : process (TESTCLK)
begin
  if (TESTCLK'event and TESTCLK = '1' and TESTACK = '1') then
    DataReg2 <= DataReg1;
    DataReg1 <= Data;
  end if;
end process p_DataRegSeq;

-- ---------------------------------------------------------------------
-- Compare read data
-- ---------------------------------------------------------------------
-- When the read data is ready, check the masked actual value against
-- the masked expected value.

p_CompareSeq : process (TESTCLK)
variable ReadReg3Hex : string(8 downto 1); -- Hex read data for
                                           -- output
variable TestbusHex  : string(8 downto 1); -- Hex TESTBUS value for
                                           -- output
variable MaskReg3Hex : string(8 downto 1); -- Hex mask value for
                                           -- output
variable ErrorStr    : string(1 to 72);    -- Read vector error
                                           -- message
begin
  if (TESTCLK'event and TESTCLK = '1') then
    if (TESTACK = '1' and CompReg2 = '1' and -- Indicates read data
                                             -- is ready
        ((TESTBUS and MaskReg3) /= (ReadReg3 and MaskReg3))) then
      ReadReg3Hex := StdVec2Hex(ReadReg3);
      TestbusHex  := StdVec2Hex(TESTBUS);
      MaskReg3Hex := StdVec2Hex(MaskReg3);
      ErrorStr    := "Error on vector read. Expected: " &
                     ReadReg3Hex &
                     " Actual: " & TestbusHex & " Mask: " &
                     MaskReg3Hex;

-- If HaltOnMismatch is set then the simulation will end.
      assert not(HaltOnMismatch)
        report ErrorStr
        severity failure;
        assert HaltOnMismatch
        report ErrorStr
        severity warning;
    end if;
  end if;
end process p_CompareSeq;

-- ---------------------------------------------------------------------
-- TESTBUS driver
-- ---------------------------------------------------------------------
-- Drives TESTBUS to high impedance during a read cycle, and to DataReg
-- at all other times (during address or write cycles).

p_TestbusSeq : process (CompReg2, TestreqPrev, DataReg2)
begin
  if (CompReg2 = '1' or TestreqPrev = "01") then
                                           -- Waiting for read data
    TESTBUS <= (others => 'Z');
  else                                     -- Address or write vector
    TESTBUS <= DataReg2;
  end if;
end process p_TestbusSeq;

-- ---------------------------------------------------------------------
-- Output drivers
-- ---------------------------------------------------------------------
-- Delay needed to avoid hold delay violations on synthesised TIC
-- register SyncTestreqA.

TESTREQA <= iTESTREQA after 1 ns;
TESTREQB <= iTESTREQB;

end behavioural;

-- --============================== End ==============================--
