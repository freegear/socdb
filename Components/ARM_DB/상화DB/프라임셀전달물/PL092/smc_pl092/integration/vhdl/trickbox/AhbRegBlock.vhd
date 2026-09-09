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
-- File Name              : AhbRegBlock.vhd.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This module implements registers and memory arrays.
--
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- --=========================================================================--

entity AhbRegBlock is
  port (
        HCLK             : in    std_logic; -- AHB Clock Signal
        HRESETn          : in    std_logic; -- AHB Reset Signal
        HWRITEdlyInt     : in    std_logic; -- AHB Read/Write Signal
        HREADYIn         : in    std_logic; -- AHB HREADY Signal
        WrEn             : in    std_logic; -- Write Enable Signal
        RdEn             : in    std_logic; -- Read Enable Signal
        HSELdlyInt       : in    std_logic; -- Device Select Signal
        ARRAY1Sel        : in    std_logic; -- ARRAY1 Select Signal
        ARRAY2Sel        : in    std_logic; -- ARRAY2 Select Signal
        WSCReg1Sel       : in    std_logic; -- Wait State Register 1 Select
                                            -- Signal
        WSCReg2Sel       : in    std_logic; -- Wait State Register 2 Select
                                            -- Signal
        CRSel            : in    std_logic; -- Control Register  Select Signal
        TMRegSel         : in    std_logic; -- Timeout Register Select Signal
        XRDlyRegSel      : in    std_logic; -- Transfer Delay Register Select
                                            -- Signal
        BYTE0En          : in    std_logic; -- Enable signal for 0th Byte in a
                                            -- Double Word
        BYTE1En          : in    std_logic; -- Enable signal for 1th Byte in a
                                            -- Double Word
        BYTE2En          : in    std_logic; -- Enable signal for 2th Byte in a
                                            -- Double Word
        BYTE3En          : in    std_logic; -- Enable signal for 3th Byte in a
                                            -- Double Word
        BYTE4En          : in    std_logic; -- Enable signal for 4th Byte in a
                                            -- Double Word
        BYTE5En          : in    std_logic; -- Enable signal for 5th Byte in a
                                            -- Double Word
        BYTE6En          : in    std_logic; -- Enable signal for 6th Byte in a
                                            -- Double Word
        BYTE7En          : in    std_logic; -- Enable signal for 7th Byte in a
                                            -- Double Word
        HADDRdlyInt      : in    std_logic_vector(31 downto 0);
                                            -- Internal AHB Address Bus
        HSIZEdlyInt      : in    std_logic_vector(2 downto 0);
                                            -- AHB Size
        HWDATAdly        : in    std_logic_vector(63 downto 0);
                                            -- AHB Write Data Bus
        WSCReg1          : out   std_logic_vector(31 downto 0);
                                            -- Wait State Register 1
        WSCReg2          : out   std_logic_vector(31 downto 0);
                                            -- Wait State Register 2
        CR               : out   std_logic_vector(31 downto 0);
                                            -- Control Register
        TMReg            : out   std_logic_vector(31 downto 0);
                                            -- Timeout Register
        XRDlyReg         : out   std_logic_vector(31 downto 0);
                                            -- Transfr Delay Register
        HRDATAOut        : out   std_logic_vector(63 downto 0)
                                            -- AHB Read Data Bus
       );
end AhbRegBlock;

-- -----------------------------------------------------------------------------
--
--                                AhbRegBlock
--                                ===========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--   This module writes and reads data  into the registers and memory arrays,
-- depending upon the select signals, when HREADYIn is high. Depending upon the -- endianness, the device has to access the data from the proper data bus lines.-- If the EndianEn bit is set, then data has to be driven only in the lines
-- which is intended to, according to the endianness. Otherwise, HRDATA is
-- driven such that, it is compatible for both endian systems.
--
-- -----------------------------------------------------------------------------

-- --============================== ARCHITECTURE =============================--

architecture behavioural of AhbRegBlock is

-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
constant DATABUSWIDTH   : integer := 32;
-- Data bus width size

--------------------------------------------------------------------------------
-- Signal Declarations
--------------------------------------------------------------------------------
type MEMARRAY is array(255 downto 0) of std_logic_vector(7 downto 0);
-- Memory Array of 256 bytes

signal ARRAY1A          : MEMARRAY;
-- Memory Block A in Array 1

signal ARRAY2A          : MEMARRAY;
-- Memory Block A in Array 2

signal ARRAY1B          : MEMARRAY;
-- Memory Block B in Array 1

signal ARRAY2B          : MEMARRAY;
-- Memory Block B in Array 2

signal ARRAY1C          : MEMARRAY;
-- Memory Block C in Array 1

signal ARRAY2C          : MEMARRAY;
-- Memory Block C in Array 2

signal ARRAY1D          : MEMARRAY;
-- Memory Block D in Array 1

signal ARRAY2D          : MEMARRAY;
-- Memory Block D in Array 2

signal ARRAY1E          : MEMARRAY;
-- Memory Block E in Array 1

signal ARRAY2E          : MEMARRAY;
-- Memory Block E in Array 2

signal ARRAY1F          : MEMARRAY;
-- Memory Block F in Array 1

signal ARRAY2F          : MEMARRAY;
-- Memory Block F in Array 2

signal ARRAY1G          : MEMARRAY;
-- Memory Block G in Array 1

signal ARRAY2G          : MEMARRAY;
-- Memory Block G in Array 2

signal ARRAY1H          : MEMARRAY;
-- Memory Block H in Array 1

signal ARRAY2H          : MEMARRAY;
-- Memory Block H in Array 2

signal iWSCReg1         : std_logic_vector(31 downto 0);
-- Internal Wait State Counter Register 1

signal iWSCReg2         : std_logic_vector(31 downto 0);
-- Internal Wait State Counter Register 2

signal NextWSCReg1      : std_logic_vector(31 downto 0);
-- D-input of Wait State Counter Register 1 flip-flop

signal NextWSCReg2      : std_logic_vector(31 downto 0);
-- D-input of Wait State Counter Register 2 flip-flop

signal iTMReg           : std_logic_vector(31 downto 0);
-- Internal Timeout Register

signal NextTMReg        : std_logic_vector(31 downto 0);
-- D-input of TimeOut Register flip-flop

signal iXRDlyReg        : std_logic_vector(31 downto 0);
-- Internal Transfer Delay Register

signal NextXRDlyReg     : std_logic_vector(31 downto 0);
-- D-input of Transfer Delay Register flip-flop

signal NextARRAY1A      : std_logic_vector(7 downto 0);
-- D-input of Array 1A flip-flop

signal NextARRAY1B      : std_logic_vector(7 downto 0);
-- D-input of Array 1B flip-flop

signal NextARRAY1C      : std_logic_vector(7 downto 0);
-- D-input of Array 1C flip-flop

signal NextARRAY1D      : std_logic_vector(7 downto 0);
-- D-input of Array 1D flip-flop

signal NextARRAY1E      : std_logic_vector(7 downto 0);
-- D-input of Array 1E flip-flop

signal NextARRAY1F      : std_logic_vector(7 downto 0);
-- D-input of Array 1F flip-flop

signal NextARRAY1G      : std_logic_vector(7 downto 0);
-- D-input of Array 1G flip-flop

signal NextARRAY1H      : std_logic_vector(7 downto 0);
-- D-input of Array 1H flip-flop

signal NextARRAY2A      : std_logic_vector(7 downto 0);
-- D-input of Array 2A flip-flop

signal NextARRAY2B      : std_logic_vector(7 downto 0);
-- D-input of Array 2B flip-flop

signal NextARRAY2C      : std_logic_vector(7 downto 0);
-- D-input of Array 2C flip-flop

signal NextARRAY2D      : std_logic_vector(7 downto 0);
-- D-input of Array 2D flip-flop

signal NextARRAY2E      : std_logic_vector(7 downto 0);
-- D-input of Array 2E flip-flop

signal NextARRAY2F      : std_logic_vector(7 downto 0);
-- D-input of Array 2F flip-flop

signal NextARRAY2G      : std_logic_vector(7 downto 0);
-- D-input of Array 2G flip-flop

signal NextARRAY2H      : std_logic_vector(7 downto 0);
-- D-input of Array 2H flip-flop

signal ByteOut          : std_logic_vector(7 downto 0);
-- Actual Data byte read out in Byte Access mode

signal HWordOut         : std_logic_vector(15 downto 0);
-- Actual Half-word read out in Half Word Access mode

signal WordOut          : std_logic_vector(31 downto 0);
-- Actual Word read out in Word Access mode

signal DWordOut         : std_logic_vector(63 downto 0);
-- Actual Double Word read out in Double Word Access mode

signal ByteDataOut      : std_logic_vector(63 downto 0);
-- Data read out in Byte Access mode if it is strong Endian System

signal HWordDataOut     : std_logic_vector(63 downto 0);
-- Data read out in Half-Word Access mode if it is strong Endian System

signal WordDataOut      : std_logic_vector(63 downto 0);
-- Data read out in Word Access mode if it is strong Endian System

signal Data             : std_logic_vector(63 downto 0);
-- Double Word Data present in the location being written

signal NextData         : std_logic_vector(63 downto 0);
-- Double Word Data input to the location being accessed

signal iCR              : std_logic_vector(31 downto 0);
-- Internal Control Register

signal NextCR           : std_logic_vector(31 downto 0);
-- D-input to Control Register flip-flop

signal BigEndian        : std_logic := '0';
-- Denoting BigEndian System

signal EndianEn         : std_logic := '0';
-- Denotes Strong Endian System

signal iHRDATAOut       : std_logic_vector(63 downto 0);
-- Internal HRDATA Output signal

signal ARRAY1RdEn       : std_logic;
-- ARRAY1 Read Enable Signal

signal ARRAY2RdEn       : std_logic;
-- ARRAY2 Read Enable Signal

signal ARRAY1WrEn       : std_logic;
-- ARRAY1 Write Enable Signal

signal ARRAY2WrEn       : std_logic;
-- ARRAY2 Write Enable Signal

signal WSCReg1RdEn      : std_logic;
-- Wait State Register 1 Enable Signal

signal WSCReg2RdEn      : std_logic;
-- Wait State Register 2 Enable Signal

signal CRRdEn           : std_logic;
-- Control Register Read Enable Signal

signal TMRegRdEn        : std_logic;
-- TimeOut Reg Read Enable Signal

signal XRDlyRegRdEn     : std_logic;
-- Transfer Delay Reg Read Enable

-- ----------------------------------------------------------------------------
-- ToInteger
-- ---------
--   This function converts the std_logic_vector input argument into integer
-- and returns the integer value.
-- ----------------------------------------------------------------------------
function ToInteger (val : std_logic_vector; x : integer := 0)
return integer is
variable return_int, x_tmp : integer;
begin
  return_int := 0;
  x_tmp := 0;
    if x /= 0 then
      x_tmp := 1;
    end if;
    for i in val'range loop
      return_int := return_int + return_int;
      case val(i) is
        when '0' =>     null;
        when '1' =>     return_int := return_int + 1;
        when others =>  return_int := return_int + x_tmp;
      end case;
    end loop;
  return return_int;
end ToInteger;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
-- Generating HRDATA
-- Negated HRDATA is sent out if Forced Error bit for HRDATA is set
-- Otherwise Internal HRDATA generated is fed out if any of the Device
-- address is selected for reading.
-- -----------------------------------------------------------------------------
HRDATAOut        <= not(iHRDATAOut) when ((HREADYIn = '1') and
                                         (iCR(3) = '1') and
                                         (HSELdlyInt = '1') and (RdEn = '1'))
                 else
                    iHRDATAOut when ((HREADYIn = '1') and
                                    (HSELdlyInt = '1') and (RdEn = '1'))
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Actual Byte being accessed
-- -----------------------------------------------------------------------------
ByteOut          <= DWordOut(7 downto 0) when (BYTE0En = '1')
                 else
                    DWordOut(15 downto 8) when (BYTE1En = '1')
                 else
                    DWordOut(23 downto 16) when (BYTE2En = '1')
                 else
                    DWordOut(31 downto 24) when (BYTE3En = '1')
                 else
                    DWordOut(39 downto 32) when (BYTE4En = '1')
                 else
                    DWordOut(47 downto 40) when (BYTE5En = '1')
                 else
                    DWordOut(55 downto 48) when (BYTE6En = '1')
                 else
                    DWordOut(63 downto 56) when (BYTE7En = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Actual Half-Word being accessed
-- -----------------------------------------------------------------------------
HWordOut         <= DWordOut(15 downto 0) when (BYTE0En = '1')
                 else
                    DWordOut(31 downto 16) when (BYTE2En = '1')
                 else
                    DWordOut(47 downto 32) when (BYTE4En = '1')
                 else
                    DWordOut(63 downto 48) when (BYTE6En = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Actual Word being accessed
-- -----------------------------------------------------------------------------
WordOut          <= DWordOut(63 downto 32) when (BYTE4En = '1')
                 else
                    DWordOut(31 downto 0) when (BYTE0En = '1')
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Actual ByteData being fed out in a strong Endian system
-- -----------------------------------------------------------------------------
ByteDataOut(7 downto 0) <= ByteOut when (((BigEndian = '0') and
                                   ((BYTE0En = '1') or ((BYTE4En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   ((BigEndian = '1') and ((BYTE7En = '1') or
                                   ((DATABUSWIDTH = 32) and (BYTE3En = '1')))))
                        else
                           (others => '0');

ByteDataOut(15 downto 8) <= ByteOut when (((BigEndian = '0') and
                                   ((BYTE1En = '1') or ((BYTE5En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   ((BigEndian = '1') and ((BYTE6En = '1') or
                                   ((DATABUSWIDTH = 32) and (BYTE2En = '1')))))
                         else
                            (others => '0');

ByteDataOut(23 downto 16) <= ByteOut when (((BigEndian = '0') and
                                   ((BYTE2En = '1') or ((BYTE6En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   ((BigEndian = '1') and ((BYTE5En = '1') or
                                   ((DATABUSWIDTH = 32) and (BYTE1En = '1')))))
                          else
                             (others => '0');

ByteDataOut(31 downto 24) <= ByteOut when (((BigEndian = '0') and
                                   ((BYTE3En = '1') or ((BYTE7En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   (((BigEndian = '1') and ((BYTE4En = '1') or
                                   ((DATABUSWIDTH = 32) and (BYTE0En = '1'))))))
                          else
                             (others => '0');
ByteDataOut(39 downto 32) <= ByteOut when ((DATABUSWIDTH = 64) and
                                   (((BYTE3En = '1') and (BigEndian = '1')) or
                                   ((BYTE4En = '1') and (BigEndian = '0'))))
                          else
                             (others => '0');

ByteDataOut(47 downto 40) <= ByteOut when ((DATABUSWIDTH = 64) and
                                   (((BYTE2En = '1') and (BigEndian = '1')) or
                                   ((BYTE5En = '1') and (BigEndian = '0'))))
                          else
                             (others => '0');

ByteDataOut(55 downto 48) <= ByteOut when ((DATABUSWIDTH = 64) and
                                   (((BYTE1En = '1') and (BigEndian = '1')) or
                                   ((BYTE6En = '1') and (BigEndian = '0'))))
                          else
                             (others => '0');

ByteDataOut(63 downto 56) <= ByteOut when ((DATABUSWIDTH = 64) and
                                   (((BYTE0En = '1') and (BigEndian = '1')) or
                                   ((BYTE7En = '1') and (BigEndian = '0'))))
                          else
                             (others => '0');

-- -----------------------------------------------------------------------------
-- Actual Half-Word Data being fed out in a strong Endian system
-- -----------------------------------------------------------------------------
HWordDataOut(15 downto 0) <= HWordOut when (((BigEndian = '0') and
                                   ((BYTE0En = '1') or ((BYTE4En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   ((BigEndian = '1') and ((BYTE6En = '1') or
                                   ((BYTE2En = '1') and (DATABUSWIDTH = 32)))))
                          else
                             (others => '0');

HWordDataOut(31 downto 16) <= HWordOut when (((BigEndian = '0') and
                                   ((BYTE1En = '1')or((BYTE6En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   ((BigEndian = '1') and ((BYTE4En = '1') or
                                   ((BYTE0En = '1') and (DATABUSWIDTH = 32)))))
                           else
                              (others => '0');

HWordDataOut(47 downto 32) <= HWordOut when ((DATABUSWIDTH = 64) and
                                   (((BigEndian = '1') and (BYTE2En = '1')) or
                                   ((BYTE4En = '1') and (BigEndian = '0'))))
                           else
                              (others => '0');

HWordDataOut(63 downto 48) <= HWordOut when ((DATABUSWIDTH = 64) and
                                   (((BigEndian = '1') and (BYTE0En = '1')) or
                                   ((BYTE6En = '1') and (BigEndian = '0'))))
                           else
                              (others => '0');

-- -----------------------------------------------------------------------------
-- Actual Word Data being fed out in a strong Endian system
-- -----------------------------------------------------------------------------
WordDataOut (63 downto 32) <= WordOut when ((DATABUSWIDTH = 64) and
                                   (((BigEndian = '1') and (BYTE0En = '1')) or
                                   ((BYTE4En = '1') and (BigEndian = '0'))))
                           else
                              (others => '0');

WordDataOut(31 downto 0) <= WordOut when (((BigEndian = '0') and
                                   ((BYTE0En = '1') or ((BYTE4En = '1') and
                                   (DATABUSWIDTH = 32)))) or
                                   ((BigEndian = '1') and ((BYTE4En = '1') or
                                   ((BYTE0En = '1') and (DATABUSWIDTH = 32)))))
                         else
                            (others => '0');

-- -----------------------------------------------------------------------------
-- Internal HRDATA being fed out depending upon HSIZE and Strong Endianness
-- -----------------------------------------------------------------------------
iHRDATAOut       <= ByteDataOut when ((HSIZEdlyInt = "000") and
                                     (EndianEn = '1'))
                 else
                    ByteOut & ByteOut & ByteOut & ByteOut & ByteOut & ByteOut &
                    ByteOut & ByteOut when ((HSIZEdlyInt = "000") and
                                           (EndianEn = '0'))
                 else
                    HWordDataOut when ((HSIZEdlyInt = "001") and
                                      (EndianEn = '1'))
                 else
                    HWordOut & HWordOut & HWordOut & HWordOut
                              when ((HSIZEdlyInt = "001") and (EndianEn = '0'))
                 else
                    WordDataOut when ((HSIZEdlyInt = "010") and
                                     (EndianEn = '1'))
                 else
                    WordOut & WordOut when ((HSIZEdlyInt = "010") and
                                           (EndianEn = '0'))
                 else
                    DWordOut when (HSIZEdlyInt = "011")
                 else
                    (others => '0');

-- -----------------------------------------------------------------------------
-- Data input for the location being written into
-- -----------------------------------------------------------------------------
NextData(7 downto 0) <= HWDATAdly(7 downto 0) when ((BigEndian = '0') and
                          (BYTE0En = '1') and (HREADYIn = '1'))
                     else
                        HWDATAdly(23 downto 16) when ((BYTE0En = '1') and
                          (BigEndian = '1') and (DATABUSWIDTH = 32) and
                          (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                     else
                        HWDATAdly(31 downto 24) when ( (BYTE0En = '1') and
                          (BigEndian = '1') and (DATABUSWIDTH = 32) and
                          (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                     else
                        HWDATAdly(63 downto 56) when ( (BYTE0En = '1') and
                          (BigEndian = '1') and (DATABUSWIDTH = 64) and
                          (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                     else
                        HWDATAdly(55 downto 48) when ( (BYTE0En = '1') and
                          (BigEndian = '1') and (DATABUSWIDTH = 64) and
                          (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                     else
                        HWDATAdly(39 downto 32) when ( (BYTE0En = '1') and
                          (BigEndian = '1') and (DATABUSWIDTH = 64) and
                          (HSIZEdlyInt = "010") and (HREADYIn = '1'))
                     else
                        Data(7 downto 0);

NextData(15 downto 8) <= HWDATAdly(15 downto 8) when ((BigEndian = '0') and
                           (BYTE1En = '1') and (HREADYIn = '1'))
                      else
                         HWDATAdly(31 downto 24) when ((BYTE1En = '1') and
                           (BigEndian = '1') and (DATABUSWIDTH = 32) and
                           (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                      else
                         HWDATAdly(23 downto 16) when ( (BYTE1En = '1') and
                           (BigEndian = '1') and (DATABUSWIDTH = 32) and
                           (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                      else
                         HWDATAdly(55 downto 48) when ( (BYTE1En = '1') and
                           (BigEndian = '1') and (DATABUSWIDTH = 64) and
                           (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                      else
                         HWDATAdly(63 downto 56) when ( (BYTE1En = '1') and
                           (BigEndian = '1') and (DATABUSWIDTH = 64) and
                           (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                      else
                         HWDATAdly(47 downto 40) when ( (BYTE1En = '1') and
                           (BigEndian = '1') and (DATABUSWIDTH = 64) and
                           (HSIZEdlyInt = "010") and (HREADYIn = '1'))
                      else
                         Data(15 downto 8);

NextData(23 downto 16) <= HWDATAdly(23 downto 16) when ((BigEndian = '0') and
                            (BYTE2En = '1') and (HREADYIn = '1'))
                       else
                          HWDATAdly(7 downto 0) when ((BYTE2En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 32) and
                            (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                       else
                          HWDATAdly(15 downto 8) when ( (BYTE2En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 32) and
                            (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                       else
                          HWDATAdly(47 downto 40) when ( (BYTE2En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 64) and
                            (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                       else
                          HWDATAdly(39 downto 32) when ( (BYTE2En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 64) and
                            (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                       else
                          HWDATAdly(55 downto 48) when ( (BYTE2En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 64) and
                            (HSIZEdlyInt = "010") and (HREADYIn = '1'))
                       else
                          Data(23 downto 16);

NextData(31 downto 24) <= HWDATAdly(31 downto 24) when ((BigEndian = '0') and
                            (BYTE3En = '1') and (HREADYIn = '1'))
                       else
                          HWDATAdly(15 downto 8) when ((BYTE3En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 32) and
                            (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                       else
                          HWDATAdly(7 downto 0) when ( (BYTE3En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 32) and
                            (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                       else
                          HWDATAdly(39 downto 32) when ( (BYTE3En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 64) and
                            (HSIZEdlyInt = "000") and (HREADYIn = '1'))
                       else
                          HWDATAdly(47 downto 40) when ( (BYTE3En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 64) and
                            (HSIZEdlyInt = "001") and (HREADYIn = '1'))
                       else
                          HWDATAdly(63 downto 56) when ( (BYTE3En = '1') and
                            (BigEndian = '1') and (DATABUSWIDTH = 64) and
                            (HSIZEdlyInt = "010") and (HREADYIn = '1'))
                       else
                          Data(31 downto 24);

NextData(39 downto 32) <= HWDATAdly(39 downto 32) when ((BigEndian = '0') and
                            (BYTE4En = '1') and (DATABUSWIDTH = 64) and
                            (HREADYIn = '1'))
                       else
                          HWDATAdly(7 downto 0) when (((BigEndian = '0') and
                            (DATABUSWIDTH = 32))  or (BigEndian = '1' and
                            (DATABUSWIDTH = 64))) and (BYTE4En = '1') and
                            (HREADYIn = '1')
                       else
                          HWDATAdly(23 downto 16) when ((BYTE4En = '1') and
                            (BigEndian = '1') and (HREADYIn = '1') and
                            ((HSIZEdlyInt(1 downto 0) = "01")))
                       else
                          HWDATAdly(31 downto 24) when ((BYTE4En = '1') and
                            (BigEndian = '1') and (HSIZEdlyInt = "000") and
                            (HREADYIn = '1'))
                       else
                          Data(39 downto 32);

NextData(47 downto 40) <= HWDATAdly(47 downto 40) when ((BigEndian = '0') and
                            (BYTE5En = '1') and (DATABUSWIDTH = 64) and
                            (HREADYIn = '1'))
                       else
                          HWDATAdly(15 downto 8) when (((BigEndian = '0') and
                            (DATABUSWIDTH = 32))  or (BigEndian = '1' and
                            (DATABUSWIDTH = 64))) and (BYTE5En = '1') and
                            (HREADYIn = '1')
                       else
                          HWDATAdly(31 downto 24) when ((BYTE5En = '1') and
                            (BigEndian = '1') and (HREADYIn = '1') and
                            ((HSIZEdlyInt(1 downto 0) = "01")))
                       else
                          HWDATAdly(23 downto 16) when ((BYTE5En = '1') and
                            (BigEndian = '1') and (HSIZEdlyInt = "000") and
                            (HREADYIn = '1'))
                       else
                          Data(47 downto 40);

NextData(55 downto 48) <= HWDATAdly(55 downto 48) when ((BigEndian = '0') and
                            (BYTE6En = '1') and (DATABUSWIDTH = 64) and
                            (HREADYIn = '1'))
                       else
                          HWDATAdly(23 downto 16) when (((BigEndian = '0') and
                            (DATABUSWIDTH = 32))  or (BigEndian = '1' and
                            (DATABUSWIDTH = 64))) and (BYTE6En = '1') and
                            (HREADYIn = '1')
                       else
                          HWDATAdly(31 downto 24) when ((BYTE6En = '1') and
                            (BigEndian = '1') and (HREADYIn = '1') and
                            ((HSIZEdlyInt(1 downto 0) = "01")))
                       else
                          HWDATAdly(23 downto 16) when ((BYTE6En = '1') and
                            (BigEndian = '1') and (HSIZEdlyInt = "000") and
                            (HREADYIn = '1'))
                       else
                          Data(55 downto 48);

NextData(63 downto 56) <= HWDATAdly(63 downto 56) when ((BigEndian = '0') and
                            (BYTE7En = '1') and (DATABUSWIDTH = 64) and
                            (HREADYIn = '1'))
                       else
                          HWDATAdly(31 downto 24) when (((BigEndian = '0') and
                            (DATABUSWIDTH = 32))  or (BigEndian = '1' and
                            (DATABUSWIDTH = 64))) and (BYTE7En = '1') and
                            (HREADYIn = '1')
                       else
                          HWDATAdly(15 downto 8) when ((BYTE7En = '1') and
                            (BigEndian = '1') and  (HREADYIn = '1') and
                            ((HSIZEdlyInt(1 downto 0) = "01")))
                       else
                          HWDATAdly(7 downto 0) when ((BYTE7En = '1') and
                            (BigEndian = '1') and (HSIZEdlyInt = "000") and
                            (HREADYIn = '1'))
                       else
                          Data(63 downto 56);

-- -----------------------------------------------------------------------------
-- Latching the double word being accessed during read & Write operations
-- -----------------------------------------------------------------------------
p_RdARRAYComb : process (HADDRdlyInt, ARRAY1RdEn, ARRAY2RdEn,HWRITEdlyInt,
                         NextData, HWDATAdly, ARRAY1WrEn, ARRAY2WrEn,
                         ARRAY1A, ARRAY1B, ARRAY1C, ARRAY1D, ARRAY1E, ARRAY1F,
                         ARRAY1G, ARRAY1H, ARRAY2A, ARRAY2B, ARRAY2C, ARRAY2D,
                         ARRAY2E, ARRAY2F, ARRAY2G, ARRAY2H, iWSCReg1, iWSCReg2,
                         iCR, WSCReg1RdEn, WSCReg2RdEn, CRRdEn, HREADYIn,
                         WSCReg1Sel, WSCReg2Sel, CRSel, TMRegRdEn, TMRegSel,
                         XRDlyRegRdEn, XRDlyRegSel, iTMReg, iXRDlyReg)
begin

  if ((ARRAY1WrEn = '1')) then
    Data(7 downto 0)  <=
                     ARRAY1A(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(15 downto 8) <=
                     ARRAY1B(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(23 downto 16) <=
                     ARRAY1C(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(31 downto 24) <=
                     ARRAY1D(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(39 downto 32) <=
                     ARRAY1E(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(47 downto 40) <=
                     ARRAY1F(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(55 downto 48) <=
                     ARRAY1G(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(63 downto 56) <=
                     ARRAY1H(ToInteger(HADDRdlyInt(10 downto 3)));
  elsif ((ARRAY2WrEn = '1')) then
    Data(7 downto 0) <=
                     ARRAY2A(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(15 downto 8) <=
                     ARRAY2B(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(23 downto 16) <=
                     ARRAY2C(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(31 downto 24) <=
                     ARRAY2D(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(39 downto 32) <=
                     ARRAY2E(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(47 downto 40) <=
                     ARRAY2F(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(55 downto 48) <=
                     ARRAY2G(ToInteger(HADDRdlyInt(10 downto 3)));
    Data(63 downto 56) <=
                     ARRAY2H(ToInteger(HADDRdlyInt(10 downto 3)));
  elsif ((WSCReg1Sel = '1') and (WrEn = '1')) then
    Data(63 downto 0) <= to_stdlogicvector(X"00000000") & iWSCReg1;
  elsif ((WSCReg2Sel = '1') and (WrEn = '1')) then
    Data(63 downto 0) <= iWSCReg2 & to_stdlogicvector(X"00000000");
  elsif ((CRSel = '1') and (WrEn = '1')) then
    Data(63 downto 0) <= to_stdlogicvector(X"00000000") & iCR;
  elsif ((TMRegSel = '1') and (WrEn = '1')) then
    Data(63 downto 0) <= iTMReg & to_stdlogicvector(X"00000000");
  elsif ((XRDlyRegSel = '1') and (WrEn = '1')) then
    Data(63 downto 0) <= to_stdlogicvector(X"00000000") & iXRDlyReg;
  end if;

  if (ARRAY1RdEn = '1') then
    DWordOut <= ARRAY1H(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1G(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1F(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1E(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1D(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1C(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1B(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY1A(ToInteger(HADDRdlyInt(10 downto 3)));
  elsif (ARRAY2RdEn = '1') then
    DWordOut <= ARRAY2H(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2G(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2F(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2E(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2D(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2C(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2B(ToInteger(HADDRdlyInt(10 downto 3))) &
                ARRAY2A(ToInteger(HADDRdlyInt(10 downto 3)));
  elsif (WSCReg1RdEn = '1') then
    DWordOut <= to_stdlogicvector(X"00000000") & iWSCReg1;
  elsif (WSCReg2RdEn = '1') then
    DWordOut <= iWSCReg2 & to_stdlogicvector(X"00000000");
  elsif (CRRdEn = '1') then
    DWordOut <= to_stdlogicvector(X"00000000") & iCR;
  elsif (TMRegRdEn = '1') then
    DWordOut <= iTMReg & to_stdlogicvector(X"00000000");
  elsif (XRDlyRegRdEn = '1') then
    DWordOut <= to_stdlogicvector(X"00000000") & iXRDlyReg;
  else
    DWordOut <= (others => '0');
  end if;
end process p_RdARRAYComb;

-- -----------------------------------------------------------------------------
-- Latching the double word being accessed during read & Write operations
-- -----------------------------------------------------------------------------
p_WrARRAYComb : process (HADDRdlyInt, ARRAY1RdEn, ARRAY2RdEn,HWRITEdlyInt,
                         NextData, HWDATAdly, ARRAY1WrEn, ARRAY2WrEn,
                         ARRAY1A, ARRAY1B, ARRAY1C, ARRAY1D, ARRAY1E, ARRAY1F,
                         ARRAY1G, ARRAY1H, ARRAY2A, ARRAY2B, ARRAY2C, ARRAY2D,
                         ARRAY2E, ARRAY2F,ARRAY2G, ARRAY2H, iWSCReg1, iWSCReg2,
                         iCR, WSCReg1RdEn, WSCReg2RdEn, CRRdEn, HREADYIn,
                         WSCReg1Sel, WSCReg2Sel, CRSel, TMRegRdEn, TMRegSel,
                         XRDlyRegRdEn, XRDlyRegSel, iTMReg, iXRDlyReg)
begin

  if ((HREADYIn = '1') and (ARRAY1WrEn = '1')) then
    NextARRAY1A <= NextData(7 downto 0);
    NextARRAY1B <= NextData(15 downto 8);
    NextARRAY1C <= NextData(23 downto 16);
    NextARRAY1D <= NextData(31 downto 24);
    NextARRAY1E <= NextData(39 downto 32);
    NextARRAY1F <= NextData(47 downto 40);
    NextARRAY1G <= NextData(55 downto 48);
    NextARRAY1H <= NextData(63 downto 56);
  else
    NextARRAY1A <= ARRAY1A(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1B <= ARRAY1B(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1C <= ARRAY1C(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1D <= ARRAY1D(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1E <= ARRAY1E(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1F <= ARRAY1F(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1G <= ARRAY1G(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY1H <= ARRAY1H(ToInteger(HADDRdlyInt(10 downto 3)));
  end if;

  if ((HREADYIn = '1') and (ARRAY2WrEn = '1')) then
    NextARRAY2A <= NextData(7 downto 0);
    NextARRAY2B <= NextData(15 downto 8);
    NextARRAY2C <= NextData(23 downto 16);
    NextARRAY2D <= NextData(31 downto 24);
    NextARRAY2E <= NextData(39 downto 32);
    NextARRAY2F <= NextData(47 downto 40);
    NextARRAY2G <= NextData(55 downto 48);
    NextARRAY2H <= NextData(63 downto 56);
  else
    NextARRAY2A <= ARRAY2A(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2B <= ARRAY2B(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2C <= ARRAY2C(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2D <= ARRAY2D(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2E <= ARRAY2E(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2F <= ARRAY2F(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2G <= ARRAY2G(ToInteger(HADDRdlyInt(10 downto 3)));
    NextARRAY2H <= ARRAY2H(ToInteger(HADDRdlyInt(10 downto 3)));
  end if;

  if ((HREADYIn = '1') and (WSCReg1Sel = '1') and (WrEn = '1')) then
    NextWSCReg1 <= NextData(31 downto 0);
  else
    NextWSCReg1 <= iWSCReg1;
  end if;

  if ((HREADYIn = '1') and (WSCReg2Sel = '1') and (WrEn = '1')) then
    NextWSCReg2 <= NextData(63 downto 32);
  else
    NextWSCReg2 <= iWSCReg2;
  end if;

  if ((HREADYIn = '1') and (CRSel = '1') and (WrEn = '1')) then
    NextCR <= NextData(31 downto 0);
  else
    NextCR <= iCR;
  end if;

  if ((HREADYIn = '1') and (TMRegSel = '1') and (WrEn = '1')) then
    NextTMReg <= NextData(63 downto 32);
  else
    NextTMReg <= iTMReg;
  end if;

   if ((HREADYIn = '1') and (XRDlyRegSel = '1') and (WrEn = '1')) then
    NextXRDlyReg <= NextData(31 downto 0);
  else
    NextXRDlyReg <= iXRDlyReg;
  end if;
end process p_WrARRAYComb;

-- -----------------------------------------------------------------------------
-- Latching Data into the Arrays and registers
-- -----------------------------------------------------------------------------
p_WrSeq : process (HCLK, HRESETn)
begin

  if (HRESETn = '0') then
    iWSCReg1  <= (others => '0');
    iWSCReg2  <= (others => '0');
    iCR       <= (others => '0');
    iTMReg    <= (others => '0');
    iXRDLyReg <= (others => '0');
    ARRAY1A   <=  (others => ( others => '0'));
    ARRAY2A   <=  (others => ( others => '0'));
    ARRAY1B   <=  (others => ( others => '0'));
    ARRAY2B   <=  (others => ( others => '0'));
    ARRAY1C   <=  (others => ( others => '0'));
    ARRAY2C   <=  (others => ( others => '0'));
    ARRAY1D   <=  (others => ( others => '0'));
    ARRAY2D   <=  (others => ( others => '0'));
    ARRAY1E   <=  (others => ( others => '0'));
    ARRAY2E   <=  (others => ( others => '0'));
    ARRAY1F   <=  (others => ( others => '0'));
    ARRAY2F   <=  (others => ( others => '0'));
    ARRAY1G   <=  (others => ( others => '0'));
    ARRAY2G   <=  (others => ( others => '0'));
    ARRAY1H   <=  (others => ( others => '0'));
    ARRAY2H   <=  (others => ( others => '0'));
  elsif(HCLK'event and HCLK ='1') then
    iWSCReg1  <= NextWSCReg1;
    iWSCReg2  <= NextWSCReg2;
    iCR       <= NextCR;
    iTMReg    <= NextTMReg;
    iXRDlyReg <= NextXRDlyReg;
    ARRAY1A(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1A;
    ARRAY1B(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1B;
    ARRAY1C(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1C;
    ARRAY1D(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1D;
    ARRAY1E(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1E;
    ARRAY1F(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1F;
    ARRAY1G(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1G;
    ARRAY1H(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY1H;
    ARRAY2A(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2A;
    ARRAY2B(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2B;
    ARRAY2C(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2C;
    ARRAY2D(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2D;
    ARRAY2E(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2E;
    ARRAY2F(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2F;
    ARRAY2G(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2G;
    ARRAY2H(ToInteger(HADDRdlyInt(10 downto 3))) <= NextARRAY2H;
  end if;
end process p_WrSeq;

-- -----------------------------------------------------------------------------
-- Assign local copies of signals to the outputs
-- -----------------------------------------------------------------------------
WSCReg1          <= iWSCReg1;

WSCReg2          <= iWSCReg2;

CR               <= iCR;

TMReg            <= iTMReg;

XRDlyReg         <= iXRDlyReg;

BigEndian        <= iCR(0);

EndianEn         <= iCR(1);

ARRAY1WrEn       <= ARRAY1Sel and WrEn;

ARRAY2WrEn       <= ARRAY2Sel and  WrEn;

ARRAY1RdEn       <= ARRAY1Sel and RdEn;

ARRAY2RdEn       <= ARRAY2Sel and  RdEn;

WSCReg1RdEn      <= WSCReg1Sel and  RdEn;

WSCReg2RdEn      <= WSCReg2Sel and  RdEn;

CRRdEn           <= CRSel and  RdEn;

TMRegRdEn        <= TMRegSel and  RdEn;

XRDlyRegRdEn     <= XRDlyRegSel and  RdEn;

end behavioural;

-- --================================= END ===================================--
