-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SciTrREFCLKGen.vhd.rcaS
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL131-REL1v0
--
--  ----------------------------------------------------------------------------
 
--  ----------------------------------------------------------------------------
--  Purpose : This generates the SCIREFCLK from either PCLK or an 
--                internally generated clock.It also has the RESET controller.
-- --=========================================================================--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- -----------------------------------------------------------------------------

entity SciTrREFCLKGen is
  port (
        PCLK          : in  std_logic;  -- APB bus clock
        PRESETn       : in  std_logic;  -- APB Reset
        SCICLK        : out std_logic;  -- SCI Reference Clock Signal
        PCLKOn        : out std_logic;  -- PCLK is routed to SCICLK
        REFCLKOn      : out std_logic;  -- SCICLK is routed to SCICLK 
        SCITrRFCK     : in  std_logic_vector(15 downto 0) := "0000000000000100";
                                        -- SCICLK frequency value
        SCICLKOUT     : out std_logic;  -- Sync for BLKGUUpdate
        SCITrCKICC    : in  std_logic_vector(15 downto 0) := "0000000000000100";
 
        SCITrRFCNTL   : in  std_logic_vector(2 downto 0);
                                        -- Clock Select
        TrSCICLKEn    : in  std_logic
       );
end SciTrREFCLKGen;

-- -----------------------------------------------------------------------------
--
--                               SciTrREFCLKGen
--                               ==============
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
--
-- This Clock Controller provides the SCICLK signal to the UUT. The 
-- SCICLK generator generates a clock whose frequency is dependent on
-- the SCLTrRFCK. Depending on the state of SCITrRFCNTL either 
-- SCICLK or PCLK is routed as the final SCICLK.
 
-- -----------------------------------------------------------------------------

-- --============================ ARCHITECTURE ===============================--

architecture behavioural of  SciTrREFCLKGen is

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------

signal IntSCICLK     : std_logic := '0'; 
-- internal SCICLK

signal PCLKEnNegSync    : std_logic := '0'; 
-- PCLKEN bit synced to falling edge of PCLK

signal RCLKEnNegSync    : std_logic := '0';
-- RCLKEn bit synced to falling edge of SCICLK

signal MuxInRCLK        : std_logic := '0';
-- RCLKEnNegSync anded with SCICLK

signal MuxInPCLK        : std_logic := '0';
-- PCLKEnNegSync anded with PCLK

signal Value            : integer;
-- Internal storage  
 
signal SCICLKPhasetime  : time := 10 ns;
-- SCICLKOUT phase in integer value

signal IntSCICLKOUT     : std_logic;
-- Internal gnerated SCICLKOUT

signal REFCLKPeriod     : integer;
-- REFCLK period in intger value

-- ------------------------------------------------------------------------------- 
--   Function declarations
-- -----------------------------------------------------------------------------

function to_integer (val : std_logic_vector; x : integer := 0)
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
end to_integer;

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

-- -----------------------------------------------------------------------------
-- SCICLK generation based on the value in SCITrRFCK
-- -----------------------------------------------------------------------------
p_SCICLKGenSeq: process (SCITrRFCK, IntSCICLK)
 
  variable  Clk_low  : time := 10 ns ;  --Clock Width 
 
  variable  Clk_high : time := 10 ns ;  --Clock Width

begin
  if (SCITrRFCK /= "0000000000000000" and SCITrRFCK /= "UUUUUUUUUUUUUUUU") then
    if (SCITrRFCK(0) = '1') then
      Clk_low  := (CONV_INTEGER(unsigned('0' & SCITrRFCK(15 downto 1))) + 1 )
                 * 1 ns;
    else
      Clk_low  := CONV_INTEGER (unsigned('0' & SCITrRFCK(15 downto 1)))
                 * 1 ns;    
    end if;
      Clk_high := CONV_INTEGER(unsigned( '0' & SCITrRFCK(15 downto 1))) * 1 ns
                  ;
    if (IntSCICLK = '1') then
      IntSCICLK <= '0' after Clk_high ;
    else
      IntSCICLK <= '1' after Clk_low ;
    end if;
  end if;
end process p_SCICLKGenSeq; 

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the PCLK to the PCLK domain.
-- -----------------------------------------------------------------------------
p_PCLKEnSynczrSeq: process(PCLK, SCITrRFCNTL)
begin
  if (PCLK'event and PCLK = '0') then
    PCLKEnNegSync <= SCITrRFCNTL(1);
  end if;
end process p_PCLKEnSynczrSeq;

-- -----------------------------------------------------------------------------
-- Synchronize the Enable of the IntSCICLK to the SCICLK domain.
-- -----------------------------------------------------------------------------
p_RCLKEnSynczrSeq: process(IntSCICLK, SCITrRFCNTL)
begin
  if (IntSCICLK'event and IntSCICLK = '0') then
    RCLKEnNegSync <= SCITrRFCNTL(2);
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

MuxInRCLK <= IntSCICLK and RCLKEnNegSync;

MuxInPCLK <= PCLK      and PCLKEnNegSync;

-- -----------------------------------------------------------------------------
-- This process routes either the SCICLK or the PCLK clock to the SCICLK
-- line based on the value of the Select Bit of the SCITrRFCNTL Register.
-- -----------------------------------------------------------------------------
p_MuxComb: process(SCITrRFCNTL, MuxInPCLK, MuxInRCLK)
begin
  if (SCITrRFCNTL(0) = '1') then
    SCICLK <= MuxInPCLK;
  else
    SCICLK <= MuxInRCLK;
  end if;
end process p_MuxComb;


-- -----------------------------------------------------------------------------
-- IntSCICLKOUT generation based on the value in the SCITrCKICC register
-- -----------------------------------------------------------------------------

Value           <= to_Integer(SCITrCKICC);
REFCLKPeriod    <= to_integer(SCITrRFCK);
SCICLKPhasetime <=  ( Value + 1) * (REFCLKPeriod/2) * 2  * 1 ns;

p_SCICLKGen : process
begin
  IntSCICLKOUT <= '0';
  wait for SCICLKPhasetime;
  IntSCICLKOUT <= '1';
  wait for SCICLKPhasetime;
end process p_SCICLKGen;
 
-- -----------------------------------------------------------------------------
-- IntSCICLKOUT is connected to pin based on the condition of TrSCICLKEn  
-- -----------------------------------------------------------------------------

process(TrSCICLKEn,IntSCICLKOUT)
begin
  if (TrSCICLKEn = '1') then
    SCICLKOUT  <= IntSCICLKOUT;
  else
    SCICLKOUT  <= '1';
  end if;
end process;

end behavioural;

-- ============================== End ========================================--

