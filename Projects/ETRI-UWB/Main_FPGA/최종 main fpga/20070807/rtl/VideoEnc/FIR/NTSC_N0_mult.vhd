-- =======================================================================
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from SANGHWA MICRO Technology
-- ALL RIGHTS RESERVED SANGHWA MICRO Technology      
-- -----------------------------------------------------------------------
-- =======================================================================

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity NTSC_N0_mult is
port(
  Clk : In Std_logic;
  CLK_EN : In Std_logic;
  DIn : In Std_logic_vector(10 downto 0);
  Mult0 : Out Std_logic_vector(18 downto 0);
  Mult1 : Out Std_logic_vector(14 downto 0);
  Mult2 : Out Std_logic_vector(14 downto 0);
  Mult3 : Out Std_logic_vector(14 downto 0);
  Mult4 : Out Std_logic_vector(18 downto 0)
);
end NTSC_N0_mult;

architecture Behavioral of NTSC_N0_mult is
  Signal DInReg : Std_logic_vector(10 downto 0);
  Signal Temp0 : Std_logic_vector(10 downto 0);
  Signal Temp1 : Std_logic_vector(14 downto 0);
  Signal Term0 : Std_logic_vector(10 downto 0);
  Signal Term1 : Std_logic_vector(14 downto 0);
  Signal Term0_d : Std_logic_vector(10 downto 0);
  Signal Term1_d : Std_logic_vector(14 downto 0);
  Signal Temp2 : Std_logic_vector(18 downto 0);
  Signal Temp3 : Std_logic_vector(13 downto 0);
  Signal Temp4 : Std_logic_vector(13 downto 0);
  Signal Temp5 : Std_logic_vector(13 downto 0);
  Signal Temp6 : Std_logic_vector(18 downto 0);
  Signal Temp7 : Std_logic_vector(18 downto 0);
  Signal Temp8 : Std_logic_vector(14 downto 0);
  Signal Temp9 : Std_logic_vector(14 downto 0);
  Signal Temp10 : Std_logic_vector(14 downto 0);
  Signal Temp11 : Std_logic_vector(18 downto 0);

begin
  --------------------------------------------------------------------------------
  --                                Common Code                                 --
  --------------------------------------------------------------------------------
  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
      DInReg <= DIn;
      end if;
    end if;
  end process;
  --------------------------------------------------------------------------------
  --                               Generate Terms                               --
  --------------------------------------------------------------------------------
  -----------------------------------
  Temp0 <= DIn;
-- Sign + 

  
  -----------------------------------
    -- Temp1 = DIn<<3-DIn<<0
  Temp1 <= ((DIn(DIn'high) & DIn & "000") - 
           (DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn));

-- Sign + 

  
  --------------------------------------------------------------------------------
  --                    Copy Terms Result from Temp to Term                     --
  --------------------------------------------------------------------------------
  Term0 <= Temp0;
  Term1 <= Temp1;
  --------------------------------------------------------------------------------
  --                                Sample Terms                                --
  --------------------------------------------------------------------------------
  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
         Term0_d <= Term0;
         Term1_d <= Term1;
      end if;
    end if;
  end process;
  --------------------------------------------------------------------------------
  --                         Generate Multipliers Array                         --
  --------------------------------------------------------------------------------
  -----------------------------------
    -- Temp2 = Term1_d<<4+Term0_d<<1
  Temp2 <= ((Term1_d(Term1_d'high) & Term1_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 3)) & Term0_d(2 downto 0));

-- Sign + 

  
  -----------------------------------
    -- Temp3 = Term0_d<<3+Term0_d<<1
  Temp3 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 2)) & Term0_d(1 downto 0));

-- Sign + 

  
  -----------------------------------
  Temp4 <= Temp3; -- Optimized

  
  -----------------------------------
  Temp5 <= Temp3; -- Optimized

  
  -----------------------------------
  Temp6 <= Temp2; -- Optimized

  
  --------------------------------------------------------------------------------
  --                          Final Stage Multipliers                           --
  --------------------------------------------------------------------------------
  -- Gen_pA_mB : Temp7 = Temp2<<1
  Temp7 <= (Temp2(17 downto 0) & "0");
  -- Gen_pA_mB : Temp8 = Temp3<<1
  Temp8 <= (Temp3(13 downto 0) & "0");
  -- Gen_pA_mB : Temp9 = Temp4<<1
  Temp9 <= (Temp4(13 downto 0) & "0");
  -- Gen_pA_mB : Temp10 = Temp5<<1
  Temp10 <= (Temp5(13 downto 0) & "0");
  -- Gen_pA_mB : Temp11 = Temp6<<1
  Temp11 <= (Temp6(17 downto 0) & "0");
  --------------------------------------------------------------------------------
  --                      Final Stage Multipliers Resample                      --
  --------------------------------------------------------------------------------
  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
         Mult0 <= Temp7;
         Mult1 <= Temp8;
         Mult2 <= Temp9;
         Mult3 <= Temp10;
         Mult4 <= Temp11;
      end if;
    end if;
  end process;
end Behavioral;
