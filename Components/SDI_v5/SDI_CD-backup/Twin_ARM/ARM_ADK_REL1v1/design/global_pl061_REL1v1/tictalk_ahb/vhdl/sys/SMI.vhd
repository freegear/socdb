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
-- File Name              : SMI.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Synthesizable demonstration of an AMBA static
--           memory interface with configurable wait states (at least 2
--           write wait and up to three read or write waits).
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_unsigned."-";

entity SMI is
  port(
    HCLK       : in    std_logic;
    HRESETn    : in    std_logic;
    HADDR      : in    std_logic_vector(31 downto 0);
    HTRANS     : in    std_logic_vector(1 downto 0);
    HWRITE     : in    std_logic;
    HSIZE      : in    std_logic_vector(2 downto 0);
    HWDATAin   : in    std_logic_vector(31 downto 0);
    HSELExtMem : in    std_logic;
    HRDATAin   : in    std_logic_vector(31 downto 0);
    HREADYin   : in    std_logic;

    HRDATAout  : out   std_logic_vector(31 downto 0);
    HREADYout  : out   std_logic;
    HRESP      : out   std_logic_vector(1 downto 0);

    Remap      : in    std_logic; -- Reset memory map in use
    TicRead    : in    std_logic; -- Drive AHB read data onto XD

    XD         : inout std_logic_vector(31 downto 0);
                                  -- External data bus

    XA         : out   std_logic_vector(30 downto 0);
                                  -- External address bus
    XCSN       : out   std_logic_vector(3 downto 0);
                                  -- External chip select
    XOEN       : out   std_logic; -- External output enable
    XWEN       : out   std_logic_vector(3 downto 0)
                                  -- External write enable
    );
end SMI;

architecture synth of SMI is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
-- Used to set the number of wait states that are inserted for reads
-- and writes Writes must have at least 2 wait states to avoid the use
-- of a falling edge register to generate the XWEN outputs.
  constant READWAIT  : std_logic_vector(1 downto 0) := "00";
  -- Range 0-3
  constant WRITEWAIT : std_logic_vector(1 downto 0) := "10";
  -- Range 2-3
  constant ZERO      : std_logic_vector(1 downto 0) := "00";

  -- HTRANS transfer type signal encoding
  constant TRN_IDLE   : std_logic_vector(1 downto 0) := "00";
  constant TRN_BUSY   : std_logic_vector(1 downto 0) := "01";
  constant TRN_NONSEQ : std_logic_vector(1 downto 0) := "10";
  constant TRN_SEQ    : std_logic_vector(1 downto 0) := "11";

  -- HSIZE transfer type signal encoding
  constant SZ_BYTE : std_logic_vector(2 downto 0) := "000";
  constant SZ_HALF : std_logic_vector(2 downto 0) := "001";
  constant SZ_WORD : std_logic_vector(2 downto 0) := "010";

  -- HRESP transfer response signal encoding
  constant RSP_OKAY  : std_logic_vector(1 downto 0) := "00";
  constant RSP_ERROR : std_logic_vector(1 downto 0) := "01";
  constant RSP_RETRY : std_logic_vector(1 downto 0) := "10";
  constant RSP_SPLIT : std_logic_vector(1 downto 0) := "11";

  -- XWEN output signal encoding
  constant NONE      : std_logic_vector(3 downto 0) := "1111";
  constant WORD      : std_logic_vector(3 downto 0) := "0000";
  constant HALF1     : std_logic_vector(3 downto 0) := "0011";
  constant HALF0     : std_logic_vector(3 downto 0) := "1100";
  constant BYTE3     : std_logic_vector(3 downto 0) := "0111";
  constant BYTE2     : std_logic_vector(3 downto 0) := "1011";
  constant BYTE1     : std_logic_vector(3 downto 0) := "1101";
  constant BYTE0     : std_logic_vector(3 downto 0) := "1110";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
  signal HselReg     : std_logic;
  -- HSELExtMem register

  signal Valid       : std_logic;
  -- Module currently selected and valid

  signal ValidReg    : std_logic;
  -- Module was selected with valid transfer

  signal ACRegEn     : std_logic;
  -- Enable for holding registers

  signal HaddrReg    : std_logic_vector(31 downto 0);
  signal HtransReg   : std_logic_vector(1 downto 0);
  signal HwriteReg   : std_logic;
  signal HsizeReg    : std_logic_vector(2 downto 0);

  signal NextWait    : std_logic_vector(1 downto 0);
  -- Wait counter

  signal CurrentWait : std_logic_vector(1 downto 0);

  signal HreadyNext  : std_logic;
  -- HREADYout register input

  signal iHREADYout  : std_logic;
  signal XwenEn      : std_logic;
  -- Enable for XwenNext

  signal XwenNext    : std_logic_vector(3 downto 0);
  -- XWEN register input

  signal XdInt       : std_logic_vector(31 downto 0);
  -- Data out latch

  signal iXOEN       : std_logic;
  -- Output enable

  signal XdEn        : std_logic;
  -- Data out enable

  signal XcsnNext    : std_logic_vector(3 downto 0);
  -- XCSN register input

-- ---------------------------------------------------------------------
-- Beginning of main code
-- ---------------------------------------------------------------------
  begin

-- ---------------------------------------------------------------------
-- Valid transfer detection
-- ---------------------------------------------------------------------
-- The slave must only respond to a valid transfer, so this must be
-- detected.

  p_HselRegSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      HselReg <= '0';
    elsif (HCLK'event and HCLK = '1') then
      if HREADYin = '1' then
        HselReg <= HSELExtMem;
      end if;
    end if;
  end process p_HselRegSeq;

-- Valid AHB transfers only take place when a non-sequential or
-- sequential transfer is shown on HTRANS - an idle or busy transfer
-- should be ignored.

  Valid <= '1' when (HSELExtMem = '1' and HREADYin = '1' and
                     (HTRANS = TRN_NONSEQ or HTRANS = TRN_SEQ))
           else '0';

  ValidReg <= '1' when HselReg = '1' and (HtransReg = TRN_NONSEQ or
                                          HtransReg = TRN_SEQ)
              else '0';

-- ---------------------------------------------------------------------
-- Address and control registers
-- ---------------------------------------------------------------------
-- Registers are used to store the address and control signals from
-- the address phase for use in the data phase of the transfer.
-- Only enabled when the HREADYin input is HIGH and the module is
-- addressed.

  ACRegEn <= HSELExtMem and HREADYin;

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

-- ---------------------------------------------------------------------
-- Wait state counter
-- ---------------------------------------------------------------------
-- Generates count signal depending on the values set in the constants
-- READWAIT and WRITEWAIT, which are decremented to zero.
-- Wait states are inserted when CurrentWait is not equal to ZERO.

  NextWait <= READWAIT when iHREADYout = '1' and Valid = '1' and
                            HWRITE = '0'
              else
              WRITEWAIT when iHREADYout = '1' and Valid = '1' and
                             HWRITE = '1'
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

-- ---------------------------------------------------------------------
-- Output data bus generation
-- ---------------------------------------------------------------------
-- HRDATAout driven to XD during a read transfer, and to zero at all
-- other times

  HRDATAout <= XD when iXOEN = '0' else (others => '0');

-- ---------------------------------------------------------------------
-- iHREADYout generation
-- ---------------------------------------------------------------------
-- HREADYout is generated from the value of NextWait, and is stored in
-- a register to improve the output timing.

  HreadyNext <= '1' when NextWait = ZERO else '0';

  p_iHREADYoutSeq : process (HRESETn, HCLK)
  begin
    if (HRESETn = '0') then
      iHREADYout <= '0';
    elsif (HCLK'event and HCLK = '1') then
      iHREADYout <= HreadyNext;
    end if;
  end process p_iHREADYoutSeq;

-- ---------------------------------------------------------------------
-- XdInt generation
-- ---------------------------------------------------------------------
-- Directly driven by HWDATAin during a normal write transfer, or by
-- HRDATAin during TIC testing when TicRead is set HIGH.

  XdInt <= HWDATAin when (HwriteReg = '1' and TicRead = '0') else
           HRDATAin when TicRead = '1' else
           (others => '0');

-- ---------------------------------------------------------------------
-- XcsnNext generation
-- ---------------------------------------------------------------------
-- Decodes the chip enable signals from the current transfer address.
-- Before the system memory is remapped, the boot ROM (at address
-- 0x30000000) is also mapped at address 0x00000000. RAM is accessed
-- as normal.
-- Extra banks of memory can be added by increasing the size of the
-- XCSN output and altering the address decoding to select the new
-- memory.

  p_XCSNComb : process (Valid, Remap, HADDR)
  begin
    if (Valid = '1' and Remap = '0') then
      case HADDR(29 downto 28) is
        when "00"   => XcsnNext <= "0111"; -- 0x30000000
        when "01"   => XcsnNext <= "1101"; -- 0x10000000
        when "10"   => XcsnNext <= "1011"; -- 0x20000000
        when "11"   => XcsnNext <= "0111"; -- 0x30000000
        when others => XcsnNext <= "1111";
      end case;
    elsif Valid = '1' then
      case HADDR(29 downto 28) is
        when "00"   => XcsnNext <= "1110"; -- 0x00000000
        when "01"   => XcsnNext <= "1101"; -- 0x10000000
        when "10"   => XcsnNext <= "1011"; -- 0x20000000
        when "11"   => XcsnNext <= "0111"; -- 0x30000000
        when others => XcsnNext <= "1111";
      end case;
    else
      XcsnNext <= "1111";
    end if;
  end process p_XCSNComb;

-- ---------------------------------------------------------------------
-- iXOEN generation
-- ---------------------------------------------------------------------
-- Output enable generated during reads from memory.

  iXOEN <= '0' when ValidReg = '1' and HwriteReg = '0' else '1';

-- ---------------------------------------------------------------------
-- XWEN generation
-- ---------------------------------------------------------------------
-- Memory write enable generated from registered HSIZE and address.
-- Enabled while the external memory is addressed and when no more wait
-- states are to be inserted. Set to X when transfer sizes greater than
-- 32 bits (word) are performed.

  XwenEn <= '1' when (ValidReg = '1' and HwriteReg = '1' and
                      NextWait = "01")
            else '0';

  XwenNext <= WORD  when XwenEn = '1' and HsizeReg = SZ_WORD
                    else
              HALF1 when XwenEn = '1' and HsizeReg = SZ_HALF and
                                          HaddrReg(1) = '1'
                    else
              HALF0 when XwenEn = '1' and HsizeReg = SZ_HALF and
                                          HaddrReg(1) = '0' else
              BYTE3 when XwenEn = '1' and HsizeReg = SZ_BYTE and
                                          HaddrReg(1 downto 0) = "11"
                    else
              BYTE2 when XwenEn = '1' and HsizeReg = SZ_BYTE and
                                          HaddrReg(1 downto 0) = "10"
                    else
              BYTE1 when XwenEn = '1' and HsizeReg = SZ_BYTE and
                                          HaddrReg(1 downto 0) = "01"
                    else
              BYTE0 when XwenEn = '1' and HsizeReg = SZ_BYTE and
                                          HaddrReg(1 downto 0) = "00"
                    else
              NONE;

-- ---------------------------------------------------------------------
-- XD Output enable
-- ---------------------------------------------------------------------
-- Output enable signal used to enable the output data bus to be driven.

  XdEn <= ((iXOEN and HwriteReg) or TicRead);

-- ---------------------------------------------------------------------
-- Tristate output drivers
-- ---------------------------------------------------------------------
-- Tristate outputs for XD.

  XD <= XdInt when XdEn = '1' else (others => 'Z');

-- ---------------------------------------------------------------------
-- External bus output port drivers
-- ---------------------------------------------------------------------
-- XA is always driven with the previous value of HADDR stored in
-- HaddrReg.

  XA <= HaddrReg(30 downto 0);

-- Output port driven with internal value.

  XOEN <= iXOEN;

-- Registered output chip select lines

  p_XCSNSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      XCSN <= "1111";
    elsif (HCLK'event and HCLK = '1') then
      if HREADYin = '1' then
        XCSN <= XcsnNext;
      end if;
    end if;
  end process p_XCSNSeq;

-- Registered XWEN to avoid glitches on the outputs

  p_XWENSeq : process (HRESETn, HCLK)
  begin
    if HRESETn = '0' then
      XWEN <= NONE;
    elsif (HCLK'event and HCLK = '1') then
      XWEN <= XwenNext;
    end if;
  end process p_XWENSeq;

-- ---------------------------------------------------------------------
-- Slave response output drivers
-- ---------------------------------------------------------------------
-- Drive the output ports with the internal versions.

  HREADYout <= iHREADYout;
  HRESP     <= RSP_OKAY;


end synth;

-- --============================== End ==============================--
