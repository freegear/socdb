-- --=========================================================================--
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
--  File Name              : CLTrCLCDIf.vhd.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
--  ----------------------------------------------------------------------------

--  ----------------------------------------------------------------------------
--  Purpose : CLCD Trickbox CLCD Master AHB Port Interface
--
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;
use     std.textio.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;
--- use     ieee.std_logic_unsigned.all;

-- -----------------------------------------------------------------------------

entity CLTrCLCDIf is
  port (
        HCLK           : in std_logic;
        -- AHB Bus Clock
        HRESETN        : in std_logic;
        -- AHB Reset
        HADDR          : in std_logic_vector(31 downto 0);
        -- AHB Address Bus
        HTRANS         : in std_logic_vector(1 downto 0);
        -- AHB Transfer Type
        HWRITE         : in std_logic;
        -- AHB Transfer Direction
        HSIZE          : in std_logic_vector(2 downto 0);
        -- AHB Transfer Size
        HBURST         : in std_logic_vector(2 downto 0);
        -- AHB Burst Type
        HRDATA         : out std_logic_vector(31 downto 0);
        -- AHB Read  Data Bus
        HREADY         : out std_logic;
        -- AHB Transfer Done
        HPROT          : in std_logic_vector(3 downto 0);
        -- AHB Protection Signal
        HLOCK          : in std_logic;
        -- AHB Lock mode
        HRESP          : out std_logic_vector(1 downto 0);
        -- AHB Transfer Response
        HBUSREQ        : in std_logic;
        -- AHB Bus Request from CLCD Master
        HGRANT         : out std_logic;
        -- AHB Bus Grant for CLCD Master
        CLTrEn         : in std_logic;
        -- CLCD Trickbox Enable
        CLTrUPBASE     : in std_logic_vector(31 downto 0);
        -- CLCD Data Base Address for Upper Panel
        CLTrLPBASE     : in std_logic_vector(31 downto 0);
        -- CLCD Data Base Address for Lower Panel
        CLTrError      : in std_logic;
        -- CLCD Trickbox ERROR Response bit
        CLTrGrant      : in std_logic;
        -- CLCD Trickbox Grant Control
        CLTrRand       : in std_logic;
        -- CLCD Trickbox responce Control
        CLTrPanel      : out std_logic;
        -- Indicates active panel
        Dual           : in std_logic;
        -- CLCD Dual Panel Mode Bit
        PPL            : in std_logic_vector(5 downto 0);
        -- Pixel Per Line
        LPP            : in std_logic_vector(9 downto 0);
        -- Line Per Panel
        BPP            : in std_logic_vector(2 downto 0);
        -- Bits per pixel
        DataAvail      : out std_logic;
        -- Indicate that Master is sampling data
        SlaveState     : out std_logic_vector(2 downto 0);
        -- Slave condition to Reg Block for CLTrError
        ResetWritePtrs : out std_logic;
        -- Signal to reset the write pointers for data
        CLTrBaseUpdate : in std_logic
        -- CLCD Trickbox Base Update Request Signal
       );
end CLTrCLCDIf;
 
-- -----------------------------------------------------------------------------
--                             CLTrCLCDIf
--                             ==========
-- -----------------------------------------------------------------------------
-- Overview:
-- ========
-- This module is to interface with CLCD Master Port. This module includes:
-- - Image Uploading mechanism
-- - Latching block of Address and Control Signals
-- - Slave State Generation State m/c
-- - Arbiter block
-- - Data Generation block
-- - HREADY, HRESP and DataAvail Signal generation block
-- - AHB bus signal protocol checking
-- - AHB Address Checking Block
-- - CLTrPanel & DataAvail Signal Generation Blocks 
--
-- Note: Two variable `define s are there:
-- ----  o EXIT  : Indicates what to do on ERROR : Exit or Continue
--       o IMAGE : Indicates Image or random testing
-- -----------------------------------------------------------------------------

--============================== ARCHITECTURE ================================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of CLTrCLCDIf is
 
--------------------------------------------------------------------------------
-- Component declaration
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------

-- Constant Declarations
-- -----------------------------------------------------------------------------
-- Slave Response state m/c states (not HRESP) 
-- -------------------------------------------
-- Encoding of Slave State values are done in such a way that, 
-- HRESP = SlaveState[1:0].
constant  IMAGE       : std_logic := '0';
-- Read from Image file
constant  S_OKAY      :std_logic_vector(2 downto 0) := "000";
-- Slave can provide data
constant  S_BUSY      :std_logic_vector(2 downto 0) := "100";
-- Slave is busy to prepare data
constant  S_RETRY     :std_logic_vector(2 downto 0) := "010";
-- Slave gives a RETRY response
constant  S_SPLIT     :std_logic_vector(2 downto 0) := "011";
-- Slave gives a SPLIT response
constant  S_ERROR     :std_logic_vector(2 downto 0) := "101";
-- Slave gives a ERROR response

-- What to do on ERROR : Exit or Continue
-- --------------------------------------
constant ERR_EXIT         : std_logic                    := '0';
--`ifdef EXIT
--  `define ERR_EXIT   $finish
--`else
--  `define ERR_EXIT   $display("Error Exit\n")
--`endif

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
-- Wait Numbers
-- ------------
signal SPLITNO     : std_logic_vector(2 downto 0);
 
-- Number of HCLKs for which Grant will be removed after a SPLIT response
signal WaitNo      : std_logic_vector(2 downto 0); 
-- Number of HCLKs for which slave is busy to prepare data the master is
-- requesting for. After that the slave may provide it to the master with an
-- OKAY response or may give RETRY or SPLIT response.

signal ADDWindow : std_logic_vector(31 downto 0);
-- CLCD Address Window

signal iHADDR           : std_logic_vector(31 downto 0);
signal iHTRANS          : std_logic_vector(1 downto 0);
 
-- Internal Registers
-- ------------------
signal iHRDATA          : std_logic_vector(31 downto 0);
-- AHB Read  Data Bus

signal iHREADY          : std_logic;
-- HREADY Out pin for CLCD Master Port

signal iHGRANT          : std_logic;
-- HGRANT Signal from built-in Arbiter

signal iSlaveState      : std_logic_vector(2 downto 0);
-- Slave condition

signal RandomReg        : std_logic_vector(31 downto 0);
-- Shift Register to generate Random No

signal Wait1            : std_logic;
-- To indicate that Retry / Split Response 1st phase 

signal UPADD            : std_logic_vector(31 downto 0);
-- CLCD Upper Panel Address

signal LPADD            : std_logic_vector(31 downto 0);
-- CLCD Lower Panel Address

signal NextUPADD        : std_logic_vector(31 downto 0);
-- D Input to UPADD

signal NextLPADD        : std_logic_vector(31 downto 0);
-- D Input to LPADD

signal iBaseUpdate      : std_logic;
-- Clocked version of CLTrBaseUpdate

signal BPPValue         : std_logic_vector(3 downto 0);
-- Actual BPP value

signal iCLTrPanel       : std_logic;
-- Panel Indicating Signal
--  0 : Data corresponds to CLCD Upper Panel
--  1 : Data corresponds to CLCD Lower Panel
--  0 : In Single Panel mode or Idle/Wait State

--`ifdef IMAGE
-- type ImageMemory is array(393215 downto 0) of std_logic_vector(7 downto 0);

-- signal ImageMem      : ImageMemory;

signal iDataAvail       : std_logic;
-- Internal copy of Dataavali Signal

-- file iINFILE         : ascii_text is in "Image.dat";
--signal INFILE         : in ascii_text;

signal Linestr          : string(1 to 2);
-- Represents one entire line read from infile

signal   COUNTLIMIT     : std_logic_vector(2 downto 0);

signal NxtRandomReg     : std_logic_vector(31 downto 0); 
-- -----------------------------------------------------------------------------
-- Function Definition
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Random Generator:
-- ----------------
-- One 32 bit Shift Register, RandomReg is shifted by one bit every time the 
-- function is called. The input bit serial bit is XOR of some bits of 
-- RandomReg.
-- -----------------------------------------------------------------------------
function Randomaize (
                      signal RandomReg : in  std_logic_vector(31 downto 0)
                     ) return std_logic_vector is
variable iLSBit : std_logic; 
variable Randomaize : std_logic_vector(31 downto 0);
begin
  iLSBit      := RandomReg(0) xor RandomReg(3) xor RandomReg(5) xor 
                RandomReg(24);
  Randomaize  := (RandomReg(30 downto 0) & iLSBit);  
  return Randomaize;
end Randomaize;

-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------

begin

-- -----------------------------------------------------------------------------
HGRANT     <= iHGRANT; 
HREADY     <= iHREADY;
SPLITNO    <= RandomReg(21 downto 19); 
WAITNO     <= RandomReg(7 downto 5);
SlaveState <= iSlaveState;
DataAvail  <= iDataAvail;
CLTrPanel  <= iCLTrPanel;
-- -----------------------------------------------------------------------------
-- Latching of Address & Control Signals.
-- -----------------------------------------------------------------------------
--p_Image : process 
--begin
--  if (IMAGE = '1') then
--    while not endfile(iINFILE) loop 
--      fgetline (linestr,iINFILE);
--      fscan (linestr,"%s",ImageMem);
--    end loop;
--  end if;
--end process p_Image;
--p_ImageComb : process (Image) 
--begin
--  if (IMAGE = '1') then
--  -- Loading Image data from file Image.dat to Memory ImageMem
--  --  $readmemh("Image.dat",ImageMem);
--  end if;
--end process p_ImageComb;

-- -----------------------------------------------------------------------------
-- Latching of Address & Control Signals.
-- -----------------------------------------------------------------------------
p_LatchSeq : process (HCLK, HRESETN) 
begin
  if (HRESETN'event and HRESETn = '0') then
    iHADDR    <= (others => '0');
    iHTRANS   <= (others => '0');
  elsif (HCLK'event and HCLK = '1' and iHREADY = '1') then
    iHADDR    <= HADDR;
    iHTRANS   <= HTRANS;
  end if;
end process p_LatchSeq;
 
-- -----------------------------------------------------------------------------
-- Slave State Generation:
-- ----------------------
-- It denotes the state of slave on which HREADY and HRESP signals will be 
-- generated. For generating the RETRY, SPLIT and Wait State randomly, a
-- random no. is generated that may vary from 0, 1, 2, ... 7. To increase the
-- probability of OKAY State compared to RETRY, SPLIT and Busy State, the states
-- will be mapped on the random numbers as follows:
--   Random number            State
--   -------------            -----
--   0, 1, ... 4              OKAY
--        5                   RETRY
--        6                   SPLIT
--        7                   BUSY
-- Note: ERROR State will come in an deterministic manner depending on CLTrERROR
-- bit. And BUSY state denotes that Slave is busy in processing and will be     
-- indicated by setting the HREADY low.
-- -----------------------------------------------------------------------------
NxtRandomReg <= Randomaize(RandomReg);

p_SlaveState : process (HCLK, HRESETN) 

variable randomno           : std_logic_vector(2 downto 0);
-- To hold Random No


begin
  if (HRESETn = '0') then
    -- Default Slave State
    iSlaveState <= S_OKAY;
    Wait1      <= '0';
    -- Initialize the Shift Register in Randomaize function
    RandomReg  <= "00000000000000000000000101010000";
  elsif (HCLK'event and HCLK = '1') then
    if (IMAGE = '1') then
      -- If IMAGE option is set, we should not invoke random responses.
      randomno := (others => '0');
    else
      -- Update RandomReg by a new random number
      RandomReg <= NxtRandomReg;
      if (CLTrRand = '1') then 
        randomno := NxtRandomReg(2 downto 0);  
      else
        randomno := (others => '0');
      end if;
    end if;
    -- If Wait1 = 1 it will extend the Slave state by one HCLK
    if (Wait1 = '1') then
      Wait1 <= '0';
    elsif ((CLTrError = '1') and (HTRANS(1) = '1') and (iHGRANT = '1')) then
    -- Not iHTRANS[1]
      iSlaveState <= S_ERROR;
      -- To extend the Slave state by one HCLK
      Wait1 <= '1';
    elsif (randomno = "101" and HTRANS(1) = '1') then
      iSlaveState <= S_RETRY;
      -- To extend the Slave state by one HCLK
      Wait1 <= '1';
    elsif (randomno = "110" and HTRANS(1) = '1') then
      iSlaveState <= S_SPLIT;
      -- To extend the Slave state by one HCLK
      Wait1 <= '1';
    else
      -- Default Slave State
        iSlaveState <= S_OKAY;
    end if;
  end if;
end process p_SlaveState;

-- -----------------------------------------------------------------------------
-- HREADY Generation:
-- -----------------
-- For OKAY State, it will be High.
-- For Wait State in BUSY mode it will be Low.
-- For RETRY, SPLIT and ERROR State, for the 1st HCLK it will be low and for the
-- next HCLK it will be high to indicate end of transfer.
-- -----------------------------------------------------------------------------
p_CombHREADY : process (iSlaveState, Wait1) 
begin
  case iSlaveState is
    when S_OKAY  => iHREADY <= '1';
    when S_RETRY => iHREADY <= not(Wait1);
    when S_SPLIT => iHREADY <= not(Wait1);
    when S_ERROR => iHREADY <= not(Wait1);
    when S_BUSY  => iHREADY <= '0';
    when others  => null;
  end case;
end process p_CombHREADY;

-- -----------------------------------------------------------------------------
-- HRESP Generation:
-- ----------------
-- HRESP will reflect the Slave state. The Slave State is so formed so 
-- that HRESP = iSlaveState[1:0].
-- -----------------------------------------------------------------------------
 HRESP <= iSlaveState(1 downto 0);

-- -----------------------------------------------------------------------------
-- Arbiter Block:
-- -------------
-- This block is going to generate HGRANT depending on HBUSREQ and SPLIT 
-- response from the slave.
-- -----------------------------------------------------------------------------
p_Arbiter : process
variable SPLITCount     : std_logic_vector(2 downto 0);
begin 
  wait until ((HRESETN'event and HRESETn = '0') or (HCLK'event and HCLK = '1'));
  if (HRESETN = '0' or CLTrGrant = '0') then
    --  Condition to remove the Grant
      iHGRANT <= '0';
  -- Remove the grant at the 2nd phase of Split Response, i.e. when HREADY = 1
  elsif (HCLK'event and HCLK = '1') then
    if (iSlaveState = S_SPLIT and iHREADY = '1') then
      -- Remove the Grant in SPLIT for a number of HCLKs
      iHGRANT <= '0';
      SPLITCount := SPLITNO;
      while (SPLITCount  > "000") loop
        wait until (HCLK'event and HCLK = '1');
        SPLITCount := SPLITCount - "001";
      end loop;
    elsif (HBUSREQ = '1' and iHREADY = '1') then
      -- Grant will come after 2 HCLK on request by a Master
      -- As after split no signal will change, so in the sensitivity list,
      -- positive edge of HCLK should be added.
      wait until (HCLK'event and HCLK = '1'); 
      wait until (HCLK'event and HCLK = '1');
      iHGRANT <= '1';
    elsif (HBUSREQ = '0') then
      -- Remove the Grant when HBUSREQ goes low after one HCLK
      wait until (HCLK'event and HCLK = '1');
      -- Randomise the Grant
      iHGRANT    <= RandomReg(20);
    end if;
  end if;
end process p_Arbiter;

-- -----------------------------------------------------------------------------
-- Data Generation Block:
-- ---------------------
-- Depending on the Rand, this block is going to generate HRDATA in a 
-- random manner or from an image file.
-- -----------------------------------------------------------------------------
p_AHBIF : process (HRESETN, CLTrEn, iHADDR, iDataAvail, RandomReg) 
begin
  if (HRESETN'event and HRESETN = '0' and CLTrEn = '0') then
    HRDATA <= (others => 'X');
  elsif (iDataAvail = '1') then
    if (IMAGE = '0') then
--       HRDATA <= "000000000000000000000000" & 
--                 ImageMem(to_integer((iHADDR)));
        HRDATA <= RandomReg;
    end if;
  else
    HRDATA <= (others => 'X');
  end if;
end process p_AHBIF;

-- -----------------------------------------------------------------------------
-- Data Avaiable Signal Generation
-- -----------------------------------------------------------------------------
 iDataAvail <= HRESETN and CLTrEn and iHTRANS(1) and 
              iHREADY  and (iSlaveState = S_OKAY);
-- -----------------------------------------------------------------------------
--  Assignment of BPP value
-- -----------------------------------------------------------------------------
p_BPPComb : process (BPP)
begin
  case BPP(1 downto 0) is
    when "00" => BPPValue <= "0001";
    when "01" => BPPValue <= "0010";
    when "10" => BPPValue <= "0100";
    when "11" => BPPValue <= "1000";
    when others  => BPPValue <= "0000";           
  end case;
end process p_BPPComb;  

-- CLCD Address Window Value Genration:
-- -----------------------------------------------------------------------------
 ADDWindow <= (((PPL + 1) * (("0000000000000000000000" & LPP) + 1) 
              * BPPValue) / 2);

-- -----------------------------------------------------------------------------
-- Address Checkup Block:-
-- -----------------------
-- This block will check up the HADDR for satisfying the following condtions:
--   o HADDR should increment properly.
--   o HADDR should be bounded by the maximum offset.
--   o Last HADDR is corresponding to the last data of the image or not.
--   o After each frame it should be loaded by the Base Addrss registers.
--   Checking is to be done for both the panels in STN Dual Panel mode.
-- This block is also responsible for generating a signal - CLTrPanel,
-- indicating the panel in STN Dual panel mode. This block is also 
-- responsible for Base Address check up.
-- -----------------------------------------------------------------------------
p_AddCheck : process (HRESETN, CLTrEn, CLTrBaseUpdate, iBaseUpdate, Dual, 
                      UPADD, LPADD, ADDWindow,iDataAvail, iHADDR)
variable printstr : string (1 to 255); 
begin
  NextUPADD <= UPADD;
  NextLPADD <= LPADD;

  if (HRESETN = '0' or CLTrEn = '0') then
    -- Reset value
    iCLTrPanel <= 'X';
  elsif (CLTrBaseUpdate = '1' and iBaseUpdate = '0') then
    -- --------------------------------------------------------
    -- Load Address Counters by their respective base address
    --                      __    __    __    __    __    __ 
    --  HCLK           : __1  |__1  |__1  |__1  |__1  |__1  |__
    --                              ___________________________
    --  CLTrBaseUpdate : __________|
    --                                  _______________________
    --  iBaseUpdate    : ______________|
    --                              ___
    --  Logic          : __________|   |_______________________
    --                                 ^ Address Counters will
    --                                   get upadated here.
    -- --------------------------------------------------------
    -- Next base Address Update
    NextUPADD <= CLTrUPBASE;
    NextLPADD <= CLTrLPBASE;
  elsif (iDataAvail = '1') then
    -- Check when HRDATA is valid
    if (iHADDR = UPADD) then
      NextUPADD <= UPADD + 4;
      iCLTrPanel <= '0';
    elsif (Dual = '1' and iHADDR = LPADD) then
      NextLPADD <= LPADD + 4;
      iCLTrPanel <= '1';
    end if; 
  end if; 
end process p_AddCheck;

-- -----------------------------------------------------------------------------
-- Clocking of UPADD and LPADD
-- -----------------------------------------------------------------------------
p_SeqADD : process (HRESETN, HCLK) 
begin
  if (HRESETN = '0' or CLTrEn = '0') then
    UPADD       <= (others => '0');
    LPADD       <= (others => '0');
    iBaseUpdate <= '0';
  elsif (HCLK'event and HCLK = '1') then
    UPADD       <= NextUPADD;
    LPADD       <= NextLPADD;
    iBaseUpdate <= CLTrBaseUpdate;
  end if;
end process p_SeqADD;

-- -----------------------------------------------------------------------------
-- Assigning the position for write pointers to initialise
-- -----------------------------------------------------------------------------
ResetWritePtrs <= '1' when (CLTrUPBASE = HADDR)
               else
                  '0';

-- -----------------------------------------------------------------------------
-- Check HSIZE, HPROT, HBURST
-- -----------------------------------------------------------------------------
p_Check : process (HCLK)
variable printstr : string (1 to 255);
begin
  if (HCLK'event and HCLK ='0') then
    if (HSIZE /= "010" and iHGRANT = '1') then
      fprint(printstr,"ERROR : HSIZE is not 32 bit \n");
      assert false
      report printstr
      severity error;
      fprint(printstr, "Error Exit");
      if (ERR_EXIT = '0') then
        assert false
        report printstr
        severity error;
      else
        assert false
        report printstr
        severity failure;
      end if;
    end if;
    if (HPROT /= "0001"and iHGRANT = '1') then
      fprint(printstr,"ERROR : HPROT IS NOT IN USER DATA ACCESS MODE \n");
      assert false
      report printstr
      severity error;
      fprint(printstr, "Error Exit");
      if (ERR_EXIT = '0') then
        assert false
        report printstr
        severity error;
      else
        assert false
        report printstr
        severity failure;
      end if;
    end if;
    if (HWRITE = '1'and iHGRANT = '1') then
      fprint(printstr,"ERROR : WRITE REQUEST FROM CLCD MASTER\n");
      assert false
      report printstr
      severity error;
      fprint(printstr, "Error Exit");
      if (ERR_EXIT = '0') then
        assert false
        report printstr
        severity error;
      else
        assert false
        report printstr
        severity failure;
      end if;
    end if;
  end if;
end process p_Check;

end behavioural;
 
-- --================================== End ==================================--

