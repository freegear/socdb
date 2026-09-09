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
--  Filename            : KmiTrPulseGen.vhd,v
--
--  File Revision       : 1.1
--
--  Release Information : PL050-REL1v1
--
--  ----------------------------------------------------------------------------
--  Purpose : this module generates the REFCLK and Pulse8MHz signal.
--
--  ---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity KmiTrPulseGen is
  port (
       BnRES       : in  std_logic; -- APB Reset 
       PCLK        : in  std_logic; -- APB Clock
       KmiTrREFCLK : in  std_logic_vector(7 downto 0); -- Reference Clock Value
       KmiTrCLKDIV : in  std_logic_vector(7 downto 0); -- Clock Divisor Value
       KmiTrMODEREG: in  std_logic_vector(3 downto 0); -- Clock/Reset mode 
       WrenMREG    : in  std_logic; -- Indicates the write status to MODEREG.
       Pulse8MHz   : out std_logic; -- 8MHz Pulse Output
       REFCLK      : out std_logic; -- Reference Clock Output
       nKMIRST     : out std_logic; -- KMI Reset Output 
       PCLKOn      : out std_logic; -- PCLK Enable Status
       REFCLKOn    : out std_logic -- REFCLK Enable Status 
       );
end KmiTrPulseGen;

-- ---------------------------------------------------------------------------
--
--                           KmiTrPulseGen
--                           =============
--
-- ----------------------------------------------------------------------------
--
-- Overview
-- ========
-- The block generates the REFCLK and Pulse8MHz based on the programmed value
-- in the registers.
-- ----------------------------------------------------------------------------
--
-- ========================== ARCHITECTURE ==================================--
--

architecture behavioural of KmiTrPulseGen  is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal iREFCLK       : std_logic;
-- Internal Copy of REFCLK.

signal FreeREFCLK    : std_logic := '0';
-- Free running REFCLK.

signal CountReg      : std_logic_vector(7 downto 0); 
-- Counter Value 

signal NextCountReg  : std_logic_vector(7 downto 0); 
-- D-Input to Counter

signal NextPulse8MHz : std_logic;   
-- D-Input of Pulse8MHz Signal

signal ClockLow      : time := 10 ns;  
-- Clock Low Time

signal ClockHigh     : time := 10 ns;  
-- Clock High Time 

signal PCLKEn        : std_logic;
-- Clocked PCLK Enable Bit in MODE Register

signal REFCLKEn      : std_logic;
-- Clocked REFCLK Enable Bit in MODE Register

signal MuxInREFCLK   : std_logic;
-- Gated REFCLK signal

signal MuxInPCLK     : std_logic;
-- Gated PCLK signal

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

-- ----------------------------------------------------------------------------
-- Generation of KMI Reset.
-- ----------------------------------------------------------------------------
p_nKMIRSTSeq: process (iREFCLK, BnRES)
begin
  if (BnRES = '0') then
    nKMIRST <= '0';
  elsif (iREFCLK'event and iREFCLK = '1') then
    nKMIRST <= KmiTrMODEREG(0);
  end if;
end process p_nKMIRSTSeq;

-- ----------------------------------------------------------------------------
-- Register values are being converted into time.
-- ----------------------------------------------------------------------------
p_TimeComb : process (KmiTrREFCLK)
begin
  if (KmiTrREFCLK > "00000000") then
    if (KmiTrREFCLK(0) = '1') then
      Clocklow <= CONV_INTEGER(unsigned('0' & KmiTrREFCLK(7 downto 1)) + '1')
                                     *1 ns;
    else
      Clocklow <= CONV_INTEGER(unsigned('0' & KmiTrREFCLK(7 downto 1))) * 1 ns;
    end if;
 
    Clockhigh <= CONV_INTEGER(unsigned ( '0' & KmiTrREFCLK(7 downto 1))) * 1 ns;
  end if;
end process p_TimeComb;

-- ----------------------------------------------------------------------------
-- Free running REFCLK generation
-- ----------------------------------------------------------------------------
p_FreeREFCLKComb : process 
begin
  FreeREFCLK <= '0';
  wait for Clocklow;
  FreeREFCLK <= '1'; 
  wait for Clockhigh;
end process p_FreeREFCLKComb;

-- -----------------------------------------------------------------------------
-- This process generates synchronized PCLKEn bit from KmiTrMODEREG(2) with 
-- falling edge of PCLK
-- -----------------------------------------------------------------------------
p_PCLKEnSeq : process (PCLK, BnRES)
begin
  if (BnRES = '0') then
    PCLKEn <= '0';
  elsif (PCLK'event and PCLK = '0') then
    PCLKEn <= KmiTrMODEREG(2);
  end if;
end process p_PCLKEnSeq;
 
-- -----------------------------------------------------------------------------
-- This process generates synchronized REFCLKEn bit from KmiTrMODEREG(3) with 
-- falling edge of REFCLK
-- -----------------------------------------------------------------------------
p_REFCLKEnSeq : process (FreeREFCLK, BnRES)
begin
  if (BnRES = '0') then
    REFCLKEn <= '0';
  elsif (FreeREFCLK'event and FreeREFCLK = '0') then
    REFCLKEn <= KmiTrMODEREG(3);
  end if;
end process p_REFCLKEnSeq;

-- The MuxInREFCLK signal is freeREFCLK gated with REFCLKEn signal
MuxInREFCLK   <= FreeREFCLK and REFCLKEn;

-- The MuxInPCLK signal is PCLK gated with PCLKEn signal
MuxInPCLK     <= PCLK and PCLKEn;

-- REFCLK is being routed according to programmed value.
iREFCLK       <= MuxInREFCLK when KmiTrMODEREG(1) = '0' 
              else
                 MuxInPCLK;

REFCLK        <= iREFCLK;

-- -----------------------------------------------------------------------------
-- This process generates the out version of PCLKEn and REFCLKEn with falling
-- edge of RCLK
-- -----------------------------------------------------------------------------
p_StatGenSeq : process (PCLK, BnRES)
begin
  if(BnRES = '0') then
    PCLKOn   <= '0';
    REFCLKOn <= '0';
  elsif (PCLK'event and PCLK = '1') then
    PCLKOn   <= PCLKEn;
    REFCLKOn <= REFCLKEn;
  end if;
end process p_StatGenSeq;

-- ----------------------------------------------------------------------------
-- Generation of Pulse8MHz Signal
-- ----------------------------------------------------------------------------
NextPulse8MHz <= '1' when CountReg = "00000000" 
              else
                 '0';

NextCountReg  <= KmiTrCLKDIV when CountReg = "00000000"
              else
                 (unsigned(CountReg) - 1); 

-- ----------------------------------------------------------------------------
-- This process updates the CountReg at the positive edge of REFCLK.
-- ----------------------------------------------------------------------------
p_CountRegSeq : process (iREFCLK, BnRES)
begin
  if (BnRES = '0') then
    CountReg  <= "00000000";
  elsif (iREFCLK'event and iREFCLK = '1') then
    CountReg  <= NextCountReg;
  end if;
end process p_CountRegSeq;

-- ----------------------------------------------------------------------------
-- Pulse8MHz signal is being generated.
-- ----------------------------------------------------------------------------
p_Pulse8MHzSeq : process (iREFCLK, BnRES)
begin
  if (BnRES = '0') then
    Pulse8MHz <= '0';
  elsif (iREFCLK'event and iREFCLK = '1') then
    Pulse8MHz <= NextPulse8MHz;
  end if;
end process p_Pulse8MHzSeq;

end behavioural;

--========================== End of KmiTrPulseGen  ============================
