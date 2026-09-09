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
--  File Name              : CLTrRegBlock.vhd.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
--  ----------------------------------------------------------------------------

--  ----------------------------------------------------------------------------
--  Purpose : CLCD Trickbox Register Block
--
-- --=========================================================================--
 
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;
 
-- -----------------------------------------------------------------------------

entity CLTrRegBlock is
  port (
      -- Inputs
        HCLK            : in std_logic;  
        -- AHB Bus Clock
        HRESETN         : in std_logic;  
        -- AHB Reset
        CLTrWRITE       : in std_logic;  
        -- CLCD Trickbox Write
        CLTrWDATA       : in std_logic_vector(31 downto 0); 
        -- CLCD Trickbox Block Write Data
        CLTrRegSel      : in std_logic;  
        -- CLCD Trickbox Test Control Register
        DelayRegSel     : in std_logic;
        -- CLCD Trickbox Test Control Register
        CLTrControlSel  : in std_logic;  
        -- CLCD Trickbox Control  Select
        CLTrTiming0Sel  : in std_logic;  
        -- CLCD Trickbox Timing 0  Select
        CLTrTiming1Sel  : in std_logic;  
        -- CLCD Trickbox Timing 1  Select
        CLTrTiming2Sel  : in std_logic;  
        -- CLCD Trickbox Timing 2  Select
        CLTrTiming3Sel  : in std_logic;  
        -- CLCD Trickbox Timing 3  Select
        CLTrUPBASESel   : in std_logic;  
        -- CLCD Trickbox Upper Panel Base Select
        CLTrLPBASESel   : in std_logic;  
        -- CLCD Trickbox Lower Panel Base Select
        CLTrUPBASE      : out std_logic_vector(31 downto 0);  
        -- CLCD Trickbox Upper Panel Base Register 
        CLTrLPBASE      : out std_logic_vector(31 downto 0);  
        -- CLCD Trickbox Lower Panel Base Register 
        SlaveState      : in std_logic_vector(2 downto 0);   
        -- Gives CLCD Panel Status to check Interrupt 

        -- Interrupt Lines
        BEINTTR         : in std_logic;  
        -- CLCD Bus Error Interrupt
        FUFINTR         : in std_logic;  
        -- CLCD DMA Lower FIFO Underflow Interrupt
        LNBUINTR        : in std_logic;  
        -- CLCD Next Base Address Update Interrupt

        VCOMPINTR       : in std_logic;  
        -- CLCD Vertical Compare Interrupt
        VCOMPINTRout    : out std_logic;  
        -- CLCD VComp Interrupt to protocol check
        LNBUINTRout     : out std_logic;
        -- CLCD LNBU Interrupt to protocol check

        INTR            : in std_logic;  
        -- CLCD Combined Interrupt

      -- Output
        CLTrRDATA       : out std_logic_vector(31 downto 0);  
        -- CLCD Trickbox Block Read  Data
        -- Control bit fields
        CLTrEn          : out std_logic;  
        -- CLCD Trickbox Enable
        CLTrGrant       : out std_logic;  
        -- CLCD Dual Panel Mode Bit
        CLTrReset       : out std_logic;
        -- CLCD  clock domain reset Bit
        CLTrIntrTest    : out std_logic;
        -- CLCD interupt test Bit
        CLTrError       : out std_logic;  
        -- CLCD Trickbox ERROR Response bit
        CLTrRand        : out std_logic;
        -- CLCD Trickbox bit gernerate random
        CLTrFUFIntrTst  : out std_logic;
        -- CLCD Trickbox for not checking data
        LcdEn           : out std_logic;
        -- Enable signal for LCD controller
        LcdPwr          : out std_logic;
        -- Panel Power
        BPP             : out std_logic_vector(2 downto 0);  
        -- Bits per pixel
        BW              : out std_logic;  
        -- Black-White mode in STN
        TFT             : out std_logic;  
        -- Indicates TFT or STN Mode
        Mono8           : out std_logic;  
        -- Indicates MONO 8 bit or 4 bit mode
        Dual            : out std_logic;  
        -- Indicates Single or Dual Panel STN mode
        BGR             : out std_logic;  
        -- Indicates BGR or RGB format
        BEBO            : out std_logic;  
        -- Indicates Byte order
        BEPO            : out std_logic;  
        -- Indicates Pixel order within Byte
        VComp           : out std_logic_vector(1 downto 0); 
        -- VComp Interrupt Control bit
        PPL             : out std_logic_vector(5 downto 0); 
        -- Pixel Per Line
        HSW             : out std_logic_vector(7 downto 0); 
        -- Horizontal Sync Pulse Width
        HFP             : out std_logic_vector(7 downto 0); 
        -- Horizontal Front Porch
        HBP             : out std_logic_vector(7 downto 0); 
        -- Horizontal Back Porch
        LPP             : out std_logic_vector(9 downto 0); 
        -- Line Per Panel
        VSW             : out std_logic_vector(5 downto 0); 
        -- Vertical Sync Pulse Width
        VFP             : out std_logic_vector(7 downto 0); 
        -- Vertical Front Porch
        VBP             : out std_logic_vector(7 downto 0); 
        -- Vertical Back Porch
        PCD             : out std_logic_vector(9 downto 0); 
        -- Panel Clock Divisor
        CSEL            : out std_logic;  
        -- Clock Select
        ACB             : out std_logic_vector(4 downto 0); 
        -- AC Bias Pin Frequency
        IVS             : out std_logic;  
        -- Invert VSync
        IHS             : out std_logic;  
        -- Invert HSync
        IPC             : out std_logic;  
        -- Invert Panel Clock
        IEO             : out std_logic;  
        -- Invert Output Enable
        CPL             : out std_logic_vector(9 downto 0);  
        -- Clocks Per Line
        BCD             : out std_logic;  
        -- ByPass Pixel Clock Divisor
        LED             : out std_logic_vector(6 downto 0);  
        -- Line End Delay
        LEE             : out std_logic;
        -- Line End Select
        Delay           : out std_logic_vector(31 downto 0)
        -- CLCD Trickbox delay for wait responces
       );
end CLTrRegBlock;

-- -----------------------------------------------------------------------------
--
--                             CLTrRegBlock
--                             ============
--
-- -----------------------------------------------------------------------------
--
-- Overview:
-- ========
-- This module is intended for Reading and Writing the registers in CLCD 
-- Trickbox. This includes the following blocks:
-- - All the Trickbox Registers 
-- - Their Write mechanism
-- - Their Read mechanism
-- - Control signal generation for other internal modules
-- -----------------------------------------------------------------------------

--============================== ARCHITECTURE ================================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of CLTrRegBlock is
 
--------------------------------------------------------------------------------
-- Component declaration
--------------------------------------------------------------------------------
 
--------------------------------------------------------------------------------
-- Internal Constants
--------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- Slave State value to be checked for reseting CLTrError bit
constant S_ERROR     : std_logic_vector(2 downto 0) := "101"; 
-- Slave gives a ERROR response

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal CLTrDATA     : std_logic_vector(31 downto 0); 
-- CLCD Trickbox Block Read  Data

signal CLTrTest     : std_logic_vector(31 downto 0);
-- CLCD Trickbox Control Register

signal DelayReg     : std_logic_vector(31 downto 0);
-- Delay register for wait state addition

signal CLTrControl  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Control Register

signal CLTrTiming0  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Timing 0 Register

signal CLTrTiming1  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Timing 1 Register
 
signal CLTrTiming2  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Timing 2 Register

signal CLTrTiming3  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Timing 3 Register

signal CLTrIntr     : std_logic_vector(31 downto 0);
-- CLCD Trickbox Interrupt Register

signal iCLTrUPBASE  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Upper Panel Base Register

signal iCLTrLPBASE  : std_logic_vector(31 downto 0);
-- CLCD Trickbox Lower Panel Base Register

-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------

begin

-------------------------------------------------------------------------------
--  Assigning the interupt out to the protocol checker
-------------------------------------------------------------------------------
VCOMPINTRout <= VCOMPINTR;
CLTrUPBASE    <= iCLTrUPBASE;
CLTrLPBASE    <= iCLTrLPBASE;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Test Control Register (Trickbox Specific)
-- -----------------------------------------------------------------------------
p_Test : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrTest      <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1') then 
    if (CLTrRegSel = '1' and CLTrWRITE = '1') then
      CLTrTest(6 downto 0)  <= CLTrWDATA(6 downto 0);
    end if;
    -- If Slave State is ERROR, reset CLTrError bit
    if (SlaveState = S_ERROR) then
      CLTrTest(2)    <= '0';
    end if;
  end if;
end process p_Test;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Control Register
-- -----------------------------------------------------------------------------
p_Control : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrControl   <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrControlSel = '1' 
         and CLTrWRITE = '1') then 
    CLTrControl(13 downto 0) <= CLTrWDATA(13 downto 0);
  end if;
end process p_Control;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Delay Register
-- -----------------------------------------------------------------------------
p_Delay : process (HRESETN, HCLK)
begin
  if (HRESETN = '0') then
   DelayReg <= (others => '0');
  elsif (HCLK'event and HCLK = '1') then
    if ((DelayRegSel = '1') and (CLTrWRITE = '1')) then
      DelayReg(31 downto 0) <= CLTrWDATA(31 downto 0);
    elsif(DelayReg /= "00000000000000000000000000000000") then
      DelayReg <= (DelayReg) - 1;
    end if;
  end if;
end process p_Delay;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Timing 0 Register
-- -----------------------------------------------------------------------------
p_Timing0 : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrTiming0   <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrTiming0Sel = '1' 
         and CLTrWRITE = '1') then
      CLTrTiming0(31 downto 2) <= CLTrWDATA(31 downto 2);
  end if;
end process p_Timing0;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Timing 1 Register
-- -----------------------------------------------------------------------------
p_Timing1 : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrTiming1   <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrTiming1Sel = '1'
         and CLTrWRITE = '1') then
      CLTrTiming1 <= CLTrWDATA;
  end if;
end process p_Timing1;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Timing 2 Register
-- -----------------------------------------------------------------------------
p_Timing2 : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrTiming2   <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrTiming2Sel = '1'
         and CLTrWRITE = '1') then
    CLTrTiming2(31 downto 0) <= CLTrWDATA(31 downto 0);
  end if;
end process p_Timing2;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Timing 3 Register
-- -----------------------------------------------------------------------------
p_Timing3 : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrTiming3   <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrTiming3Sel = '1'
         and CLTrWRITE = '1') then
    CLTrTiming3(16)  <= CLTrWDATA(16);
    CLTrTiming3(6 downto 0) <= CLTrWDATA(6 downto 0);
  end if;
end process p_Timing3;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Upper Panel Base Register
-- -----------------------------------------------------------------------------
p_UPBASE : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    iCLTrUPBASE    <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrUPBASESel = '1'
         and CLTrWRITE = '1') then
    iCLTrUPBASE  <= CLTrWDATA;
  end if;
end process p_UPBASE;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Lower Panel Base Register
-- -----------------------------------------------------------------------------
p_LPBASE : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    iCLTrLPBASE    <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1' and CLTrLPBaseSel = '1'
         and CLTrWRITE = '1') then
    iCLTrLPBASE    <= CLTrWDATA;
  end if;
end process p_LPBASE;

-- -----------------------------------------------------------------------------
-- Write Block for CLCD Trickbox Interrupt Status Register (Trickbox Specific)
-- -----------------------------------------------------------------------------
p_Intr : process (HRESETN, HCLK) 
begin
  if (HRESETN'event and HRESETn = '0') then
    CLTrIntr   <= "00000000000000000000000000000000";
  elsif (HCLK'event and HCLK = '1') then 
      CLTrIntr(5 downto 0)  <= BEINTTR & FUFINTR & '0' & LNBUINTR & 
                               VCOMPINTR & INTR;
      CLTrIntr(31 downto 6) <= (others => '0');
    end if;
end process p_Intr;

-- -----------------------------------------------------------------------------
-- Read Block : CLCD Trickbox Read gives the Register Values
-- Read block is Asynchronous.
-- -----------------------------------------------------------------------------
p_Read : process (CLTrWRITE, CLTrRegSel) 
begin
  if (CLTrWRITE = '0' and CLTrRegSel = '1') then
    CLTrRDATA <= CLTrIntr;
  end if;
  if (CLTrWRITE'event) then
    if (CLTrWRITE = '1' and CLTrRegSel = '1') then
      CLTrRDATA <= CLTrIntr;
    elsif (CLTrWRITE = '0' and CLTrControlSel = '1') then
      CLTrRDATA <= CLTrControl;
    elsif (CLTrWRITE = '0' and CLTrTiming0Sel = '1' ) then
      CLTrRDATA <= CLTrTiming0;
    elsif (CLTrWRITE = '0' and CLTrTiming1Sel = '1') then
      CLTrRDATA <= CLTrTiming1;
    elsif (CLTrWRITE = '0' and CLTrTiming2Sel = '1') then
      CLTrRDATA <= CLTrTiming2;
    elsif (CLTrWRITE = '0' and CLTrTiming3Sel = '1') then
      CLTrRDATA <= CLTrTiming3;
    elsif (CLTrWRITE = '0' and CLTrUPBASESel = '1') then
      CLTrRDATA <= iCLTrUPBASE;
    elsif (CLTrWRITE = '0' and CLTrLPBaseSel = '1') then
      CLTrRDATA <= iCLTrLPBASE;
    else
      CLTrRDATA <= "00000000000000000000000000000000";
    end if;
  end if;
end process p_Read;

-- -----------------------------------------------------------------------------
-- Control Bit Fields and Data Outputs
-- -----------------------------------------------------------------------------
-- Control fields from  CLTrTest Register
-- ----------------------------------------
CLTrEn         <= CLTrTest(0);
CLTrGrant      <= CLTrTest(1);
CLTrError      <= CLTrTest(2);
CLTrIntrTest   <= CLTrTest(3);
CLTrFUFIntrTst <= CLTrTest(4);
CLTrRand       <= CLTrTest(5);
CLTrReset      <= CLTrTest(6);


-- Control fields from  CLTrControl Register
-- ----------------------------------------
LcdEn         <= CLTrControl(0);
BPP           <= CLTrControl(3 downto 1);
BW            <= CLTrControl(4);
TFT           <= CLTrControl(5);
Mono8         <= CLTrControl(6);
Dual          <= CLTrControl(7);
BGR           <= CLTrControl(8);
BEBO          <= CLTrControl(9);
BEPO          <= CLTrControl(10);
LcdPwr        <= CLTrControl(11);
VComp         <= CLTrControl(13 downto 12);

-- Control fields from  CLTrTiming0 Register
-- ----------------------------------------
PPL           <= CLTrTiming0(7 downto 2);
HSW           <= CLTrTiming0(15 downto 8);
HFP           <= CLTrTiming0(23 downto 16);
HBP           <= CLTrTiming0(31 downto 24);

-- Control fields from <= CLTrTiming1 Register
-- ----------------------------------------
LPP           <= CLTrTiming1(9 downto 0);
VSW           <= CLTrTiming1(15 downto 10);
VFP           <= CLTrTiming1(23 downto 16);
VBP           <= CLTrTiming1(31 downto 24);

-- Control fields from  CLTrTiming2 Register
-- ----------------------------------------
PCD           <= CLTrTiming2(31 downto 27) & CLTrTiming2(4 downto 0);
CSEL          <= CLTrTiming2(5);
ACB           <= CLTrTiming2(10 downto 6);
IVS           <= CLTrTiming2(11);
IHS           <= CLTrTiming2(12);
IPC           <= CLTrTiming2(13);
IEO           <= CLTrTiming2(14);
CPL           <= CLTrTiming2(25 downto 16);
BCD           <= CLTrTiming2(26);

-- Control fields from CLTrTiming2 Register
-- ----------------------------------------
LED           <= CLTrTiming3(6 downto 0);
LEE           <= CLTrTiming3(16);
-- Delay value to be passed to AHB interface
-- ----------------------------------------
Delay         <= DelayReg;
 

end behavioural;
 
-- --================================== End ==================================--
