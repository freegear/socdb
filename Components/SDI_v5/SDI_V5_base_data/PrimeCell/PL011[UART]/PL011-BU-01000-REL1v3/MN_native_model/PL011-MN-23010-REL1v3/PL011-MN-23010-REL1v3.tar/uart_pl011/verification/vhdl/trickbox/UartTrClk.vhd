-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--
--  File Name              : UartTrClk.vhd.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- -----------------------------------------------------------------------------
-- Purpose      : This generates the UartCLK from either PCLK or an 
--                internally generated clock.It also has the RESET controller.
-- -----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity UartTrClk is
  port (
        PCLK         : in  std_logic;  -- APB bus clock
        PRESETn        : in  std_logic;  -- APB Reset
        RESETBIT     : in  std_logic;  -- Uart Reset status
        ClkPeriod    : in  std_logic_vector(7 downto 0);   -- Clock Width
        RSTMODEREG   : in  std_logic_vector(3  downto 0); -- Clock and RST Cntlr 
        UartClk      : out std_logic; -- Uart Clock
        PCLKOn       : out std_logic; -- PCLK is routed to UartCLK line
        REFCLKOn     : out std_logic; -- UartRefCLK routed to UartClk 
        nUARTRST     : out std_logic -- Uart reset                      
       );
end UartTrClk;

-- -----------------------------------------------------------------------------
--
--                               UartTrClk 
--                               =========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This Clock-Reset Controller provides the nUartRST and UartCLK signal to the 
-- UUT. The nUartRST is derived from the RSTMODE bit of the TB_SET_PINS Register.
-- Whenever the RSTMODE bit is asserted. The nUartRST is asserted asynchronously 
-- but the deassertion is synchronized with respect to the UartCLK.
-- The UartRefClk generator generates a clock whose frequency is dependent on 
-- the SCLKTBCLKREG.  
-- Depending on the state of RSTMODEREG either UartRefClk or PCLK is routed 
-- as the final UartCLK.
--
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of UartTrClk  is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
signal UartRefClk        : std_logic := '0'; 
-- generated as per ClkPeriod
signal iUartClk          : std_logic := '0'; 
-- internal UartClk
signal PCLKEnNegSync    : std_logic := '0'; 
-- PCLKEN bit synced to falling edge of PCLK
signal RCLKEnNegSync    : std_logic := '0';
-- RCLKEn bit synced to falling edge of UartRefClk
signal MuxInRCLK        : std_logic := '0';
-- RCLKEnNegSync anded with UartRefClk
signal MuxInPCLK        : std_logic := '0';
-- PCLKEnNegSync anded with PCLK

-- -----------------------------------------------------------------------------
-- Function declarations
-- -----------------------------------------------------------------------------
function CONV_INTEGER(arg: std_logic_vector) return integer is
variable OutVal : integer;
begin
  if (arg = "UUUUUUUUUUUUUUUU") then
    OutVal := 2;
  else
    OutVal := CONV_INTEGER(arg);
  end if;
    return OutVal;
end CONV_INTEGER;

-- -----------------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- -----------------------------------------------------------------------------

begin

UartClk <= iUartClk;

-- -----------------------------------------------------------------------------
-- UartRefClk generation based on the value in UTCLKREG
-- -----------------------------------------------------------------------------
p_UartCLKGenSeq: process (ClkPeriod, UartRefClk)
 
  variable  Clk_low  : time := 1 ns ;  --Clock Width 
 
  variable  Clk_high : time := 1 ns ;  --Clock Width

begin
    if (ClkPeriod /= "00000000" and ClkPeriod /= "UUUUUUUU")
       then
      if (ClkPeriod(0) = '1') then
        Clk_low := (CONV_INTEGER(unsigned('0' & ClkPeriod(7 downto 1))) + 1 )
                    * 1 ns;
      else
        Clk_low := CONV_INTEGER (unsigned('0' & ClkPeriod(7 downto 1)))
                   * 1 ns;    
      end if;
      Clk_high := CONV_INTEGER(unsigned( '0' & ClkPeriod(7 downto 1))) * 1 ns
                  ;
      if (UartRefClk = '1') then
        UartRefClk <= '0' after Clk_high ;
      else
        UartRefClk <= '1' after Clk_low ;
      end if;
    end if;
end process p_UartCLKGenSeq; 

-- -----------------------------------------------------------------------------
-- Reset signal generator.The Reset is done asynchronously but the deassertion
-- is done synchronous to the UartClk clock.
-- -----------------------------------------------------------------------------
p_RstCntrlSeq: process(PRESETn, iUartClk)
begin
  if (PRESETn = '0') then
    nUartRST <= '0';
  elsif (iUartClk'event and iUartClk = '0') then
    nUartRST <= RESETBIT;
  end if;
end process p_RstCntrlSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the PCLK to the PCLK domain.
-- -----------------------------------------------------------------------------
p_PCLKEnSynczrSeq: process(PCLK, RSTMODEREG(2))
begin
  if (PCLK'event and PCLK = '0') then
    PCLKEnNegSync <= RSTMODEREG(2);
  end if;
end process p_PCLKEnSynczrSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the UartRefClk to the UartRefClk domain.
-- -----------------------------------------------------------------------------
p_RCLKEnSynczrSeq: process(UartRefClk, RSTMODEREG)
begin
  if (UartRefClk'event and UartRefClk = '0') then
    RCLKEnNegSync <= RSTMODEREG(3);
  end if;
end process p_RCLKEnSynczrSeq;

-- -----------------------------------------------------------------------------
-- Writes the Status Bits PCLKOn and REFCLKOn into the Status Register of the 
-- TrickBox and the write is done on seeing the positive edge of the PCLK  
-- -----------------------------------------------------------------------------
p_StatGeneratorSeq: process(PCLK, PCLKEnNegSync, RCLKEnNegSync)
begin
  if (PCLK'event and PCLK = '1') then
    PCLKOn   <= PCLKEnNegSync;
    REFCLKOn <= RCLKEnNegSync;
  end if;
end process p_StatGeneratorSeq;

MuxInRCLK <= UartRefClk and RCLKEnNegSync;

MuxInPCLK <= PCLK      and PCLKEnNegSync;

-- -----------------------------------------------------------------------------
-- This process routes either the UartRefClk or the PCLK clock to the UartCLK
-- line based on the value of the Select Bit of the RSTMODEREG Register.
-- -----------------------------------------------------------------------------
p_MuxComb: process(RSTMODEREG, MuxInPCLK, MuxInRCLK)
begin
   if (RSTMODEREG(1) = '1') then
     iUartClk <= MuxInPCLK;
   else
     iUartClk <= MuxInRCLK;
   end if;
end process p_MuxComb;

end behavioural;

-- ========================== End of UartTrClk ==============================--

