--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : SmiCore.vhd,v
--  File Revision       : 1.4
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Synthesizable demonstration of an AMBA static memory
--                        interface with configurable wait states (2-3 write
--                        wait and 1-3 read waits).
--                        Assumes external memory constructed from 8-bit devices
--                        that use the byte lane select instead of the dedicated
--                        write enable.
--  --========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned."-";

entity SmiCore is
  port(
    HCLK      : in  std_logic;
    HRESETn   : in  std_logic;
    HADDR     : in  std_logic_vector(28 downto 0);
    HTRANS    : in  std_logic_vector(1 downto 0);
    HWRITE    : in  std_logic;
    HSIZE     : in  std_logic_vector(2 downto 0);
    HWDATA    : in  std_logic_vector(31 downto 0);
    HSELSMC   : in  std_logic;
    HREADYIN  : in  std_logic;

    HRDATA    : out std_logic_vector(31 downto 0);
    HREADYOUT : out std_logic;
    HRESP     : out std_logic_vector(1 downto 0);

    REMAP     : in  std_logic; -- Reset memory map in use
 
    SMDATAIN  : in  std_logic_vector(31 downto 0); -- Data from Memory to Smi
    SMDATAOUT : out std_logic_vector(31 downto 0); -- Data from Smi to Memory
    nSMDATAEN : out std_logic_vector(3 downto 0);  -- Data tri-state pad enable
    SMADDR    : out std_logic_vector(25 downto 0); -- External address bus
    SMCS      : out std_logic_vector(7 downto 0);  -- External chip selects
    nSMBLS    : out std_logic_vector(3 downto 0);  -- External byte lane enables
    nSMOEN    : out std_logic  -- External read enable
    );
end SmiCore;

architecture synth of SmiCore is

--------------------------------------------------------------------------------
-- Constant declarations
--------------------------------------------------------------------------------
-- Used to set the number of wait states that are inserted for reads and writes
-- Writes must have at least 2 wait states to avoid the use of a falling edge
--  register to generate the nSMBLS outputs.
  constant READWAIT   : std_logic_vector(1 downto 0) := "01"; -- Range 1-3
  constant WRITEWAIT  : std_logic_vector(1 downto 0) := "10"; -- Range 2-3
  constant ZERO       : std_logic_vector(1 downto 0) := "00";

-- HTRANS transfer type signal encoding
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

-- HSIZE transfer type signal encoding
  constant SZ_BYTE    : std_logic_vector(2 downto 0) := "000";
  constant SZ_HALF    : std_logic_vector(2 downto 0) := "001";
  constant SZ_WORD    : std_logic_vector(2 downto 0) := "010";

-- HRESP transfer response signal encoding
  constant RSP_OKAY   : std_logic_vector(1 downto 0) := "00";
  constant RSP_ERROR  : std_logic_vector(1 downto 0) := "01";
  constant RSP_RETRY  : std_logic_vector(1 downto 0) := "10";
  constant RSP_SPLIT  : std_logic_vector(1 downto 0) := "11";

-- nSMBLS output signal encoding
  constant NONE       : std_logic_vector(3 downto 0) := "1111";
  constant WORD       : std_logic_vector(3 downto 0) := "0000";
  constant HALF1      : std_logic_vector(3 downto 0) := "0011";
  constant HALF0      : std_logic_vector(3 downto 0) := "1100";
  constant BYTE3      : std_logic_vector(3 downto 0) := "0111";
  constant BYTE2      : std_logic_vector(3 downto 0) := "1011";
  constant BYTE1      : std_logic_vector(3 downto 0) := "1101";
  constant BYTE0      : std_logic_vector(3 downto 0) := "1110";

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------
  signal HselReg     : std_logic; -- HSELSMC register
  signal Valid       : std_logic; -- Module currently selected and valid
  signal ValidReg    : std_logic; -- Module was selected with valid transfer

  signal ACRegEn     : std_logic; -- Enable for holding registers
  signal HaddrReg    : std_logic_vector(28 downto 0);
  signal HtransReg   : std_logic_vector(1 downto 0);
  signal HwriteReg   : std_logic;
  signal HsizeReg    : std_logic_vector(2 downto 0);

  signal NextWait    : std_logic_vector(1 downto 0);  -- Wait counter
  signal CurrentWait : std_logic_vector(1 downto 0);

  signal HreadyNext  : std_logic; -- HREADYOUT register input
  signal iHREADYOUT  : std_logic; -- HREADYOUT register
  signal nSMBLSEn    : std_logic;                     -- Enable for nSMBLSNext
  signal nSMBLSNext  : std_logic_vector(3 downto 0);  -- nSMBLS register input
  signal inSMOEN     : std_logic;                     -- Output enable
  signal SMCSNext    : std_logic_vector(7 downto 0);  -- SMCS register input

--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------
  begin

--------------------------------------------------------------------------------
-- Valid transfer detection
--------------------------------------------------------------------------------
-- The slave must only respond to a valid transfer, so this must be detected.

  p_HselRegSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HselReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if HREADYIN = '1' then
        HselReg <= HSELSMC;
      end if;
    end if;
  end process p_HselRegSeq;

-- Valid AHB transfers only take place when a non-sequential or sequential
--  transfer is shown on HTRANS - an idle or busy transfer should be ignored.

  Valid <= '1' when (HSELSMC = '1' and HREADYIN = '1' and
                     (HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ))
           else '0';

  ValidReg <= '1' when HselReg = '1' and (HtransReg = TRN_NONSEQ or
                                          HtransReg = TRN_SEQ)
              else '0';

--------------------------------------------------------------------------------
-- Address and control registers
--------------------------------------------------------------------------------
-- Registers are used to store the address and control signals from the address
--  phase for use in the data phase of the transfer.
-- Only enabled when the HREADYIN input is HIGH and the module is addressed.

  ACRegEn <= HSELSMC and HREADYIN;

  p_ACRegSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HaddrReg  <= (others => '0');
      HtransReg <= (others => '0');
      HwriteReg <= '0';
      HsizeReg  <= (others => '0');
    elsif (HCLK'event and HCLK = '1') then
      if ACRegEn = '1' then
        HaddrReg  <= HADDR;
        HtransReg <= HTRANS;
        HwriteReg <= HWRITE;
        HsizeReg  <= HSIZE;
      end if;
    end if;
  end process p_ACRegSeq;

--------------------------------------------------------------------------------
-- Wait state counter
--------------------------------------------------------------------------------
-- Generates count signal depending on the values set in the constants
--  READWAIT and WRITEWAIT, which are decremented to zero.
-- Wait states are inserted when CurrentWait is not equal to ZERO.

  NextWait <= READWAIT  when iHREADYOUT = '1' and Valid = '1' and HWRITE = '0'
              else
              WRITEWAIT when iHREADYOUT = '1' and Valid = '1' and HWRITE = '1'
              else
              ZERO when CurrentWait = ZERO
              else
              CurrentWait - '1';

  p_WaitCounterSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      CurrentWait <= ZERO;
    elsif (HCLK'event and HCLK = '1') then
      CurrentWait <= NextWait;
    end if;
  end process p_WaitCounterSeq;

--------------------------------------------------------------------------------
-- Output data bus generation
--------------------------------------------------------------------------------
-- HRDATA driven to SMDATAIN during a read transfer, and to zero at all other
--  times.

  HRDATA <= SMDATAIN when inSMOEN = '0' else (others => '0');

--------------------------------------------------------------------------------
-- iHREADYOUT generation
--------------------------------------------------------------------------------
-- HREADYOUT is generated from the value of NextWait, and is stored in a
--  register to improve the output timing.

  HreadyNext <= '1' when NextWait = ZERO else '0';

  p_iHREADYOUTSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iHREADYOUT <= '1';
    elsif (HCLK'event and HCLK = '1') then
      iHREADYOUT <= HreadyNext;
    end if;
  end process p_iHREADYOUTSeq;

--------------------------------------------------------------------------------
-- SMDATAOUT generation
--------------------------------------------------------------------------------
-- Directly driven by HWDATA during a normal write transfer.

  SMDATAOUT <= HWDATA when HwriteReg = '1' else (others => '0');

--------------------------------------------------------------------------------
-- nSMDATAEN generation
--------------------------------------------------------------------------------
-- The full data bus is enabled during a write transfer, and disabled during a
--  read.

  nSMDATAEN <= "0000" when (inSMOEN = '1' and HwriteReg = '1') else "1111";

--------------------------------------------------------------------------------
-- SMCSNext generation
--------------------------------------------------------------------------------
-- Decodes the chip enable signals from the current transfer address. Before
--  the system memory is remapped, the boot ROM (at address 0x30000000) is also
--  mapped at address 0x00000000. RAM is accessed as normal.
-- Extra banks of memory can be added by increasing the size of the XCSN output
--  and altering the address decoding to select the new memory.

  p_SMCSComb : process (Valid, REMAP, HADDR)
  begin
    if (Valid = '1' and REMAP = '0') then
      case HADDR(28 downto 26) is
        when "000"  => SMCSNext <= "01111111"; -- 0x1C000000
        when "001"  => SMCSNext <= "11111101"; -- 0x04000000
        when "010"  => SMCSNext <= "11111011"; -- 0x08000000
        when "011"  => SMCSNext <= "11110111"; -- 0x0C000000
        when "100"  => SMCSNext <= "11101111"; -- 0x10000000
        when "101"  => SMCSNext <= "11011111"; -- 0x14000000
        when "110"  => SMCSNext <= "10111111"; -- 0x18000000
        when "111"  => SMCSNext <= "01111111"; -- 0x1C000000
        when others => SMCSNext <= "11111111";
      end case;
    elsif Valid = '1' then
      case HADDR(28 downto 26) is
        when "000"  => SMCSNext <= "11111110"; -- 0x??000000
        when "001"  => SMCSNext <= "11111101"; -- 0x??100000
        when "010"  => SMCSNext <= "11111011"; -- 0x??200000
        when "011"  => SMCSNext <= "11110111"; -- 0x??300000
        when "100"  => SMCSNext <= "11101111"; -- 0x??400000
        when "101"  => SMCSNext <= "11011111"; -- 0x??500000
        when "110"  => SMCSNext <= "10111111"; -- 0x??600000
        when "111"  => SMCSNext <= "01111111"; -- 0x??700000
        when others => SMCSNext <= "11111111";
      end case;
    else
      SMCSNext <= "11111111";
    end if;
  end process p_SMCSComb;

--------------------------------------------------------------------------------
-- inSMOEN generation
--------------------------------------------------------------------------------
-- Output enable generated during reads from memory.

  inSMOEN <= '0' when (ValidReg = '1' and
                       HwriteReg = '0' and
                       CurrentWait = ZERO) else
             '1';
  
--------------------------------------------------------------------------------
-- nSMBLS generation
--------------------------------------------------------------------------------
-- Memory write enables generated from registered HSIZE and address. Enabled
--  while the external memory is addressed and when no more wait states are to
--  be inserted. Deasserted when transfer sizes greater than 32-bit (word) are
--  performed.

  nSMBLSEn <= '1' when (ValidReg = '1' and HwriteReg = '1' and NextWait = "01")
              else '0';

  nSMBLSNext <= WORD  when nSMBLSEn = '1' and HsizeReg = SZ_WORD else
                HALF1 when nSMBLSEn = '1' and HsizeReg = SZ_HALF and
                                              HaddrReg(1) = '1' else
                HALF0 when nSMBLSEn = '1' and HsizeReg = SZ_HALF and
                                              HaddrReg(1) = '0' else
                BYTE3 when nSMBLSEn = '1' and HsizeReg = SZ_BYTE and
                                              HaddrReg(1 downto 0) = "11" else
                BYTE2 when nSMBLSEn = '1' and HsizeReg = SZ_BYTE and
                                              HaddrReg(1 downto 0) = "10" else
                BYTE1 when nSMBLSEn = '1' and HsizeReg = SZ_BYTE and
                                              HaddrReg(1 downto 0) = "01" else
                BYTE0 when nSMBLSEn = '1' and HsizeReg = SZ_BYTE and
                                              HaddrReg(1 downto 0) = "00" else
                NONE;

--------------------------------------------------------------------------------
-- External bus output port drivers
--------------------------------------------------------------------------------
-- SMADDR is always driven with the previous value of HADDR stored in HaddrReg.

  SMADDR <= HaddrReg(25 downto 0);

-- Output port driven with internal value.

  nSMOEN <= inSMOEN;

-- Registered output chip select lines

  p_SMCSSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      SMCS <= (others => '1');
    elsif (HCLK'event and HCLK = '1') then
      if HREADYIN = '1' then
        SMCS <= SMCSNext;
      end if;
    end if;
  end process p_SMCSSeq;

-- Registered nSMBLS to avoid glitches on the outputs

  p_nSMBLSSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      nSMBLS <= NONE;
    elsif (HCLK'event and HCLK = '1') then
      nSMBLS <= nSMBLSNext;
    end if;
  end process p_nSMBLSSeq;

--------------------------------------------------------------------------------
-- Slave response output drivers
--------------------------------------------------------------------------------
-- Drive the output ports with the internal versions.

  HREADYOUT <= iHREADYOUT;
  HRESP     <= RSP_OKAY;


end synth;

-- --================================= End ===================================--
