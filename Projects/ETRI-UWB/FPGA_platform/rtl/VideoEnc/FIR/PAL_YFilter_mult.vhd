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

entity PAL_YFilter_mult is
port(
  Clk : In Std_logic;
  CLK_EN : In Std_logic;
  DIn : In Std_logic_vector(10 downto 0);
  Mult0 : Out Std_logic_vector(10 downto 0);
  Mult1 : Out Std_logic_vector(0 downto 0);
  Mult2 : Out Std_logic_vector(13 downto 0);
  Mult3 : Out Std_logic_vector(16 downto 0);
  Mult4 : Out Std_logic_vector(17 downto 0);
  Mult5 : Out Std_logic_vector(17 downto 0);
  Mult6 : Out Std_logic_vector(17 downto 0);
  Mult7 : Out Std_logic_vector(16 downto 0);
  Mult8 : Out Std_logic_vector(13 downto 0);
  Mult9 : Out Std_logic_vector(0 downto 0);
  Mult10 : Out Std_logic_vector(10 downto 0)
);
end PAL_YFilter_mult;

architecture Behavioral of PAL_YFilter_mult is
  Signal DInReg : Std_logic_vector(10 downto 0);
  Signal Temp0 : Std_logic_vector(10 downto 0);
  Signal Temp1 : Std_logic_vector(15 downto 0);
  Signal Temp2 : Std_logic_vector(14 downto 0);
  Signal Term0 : Std_logic_vector(10 downto 0);
  Signal Term1 : Std_logic_vector(15 downto 0);
  Signal Term2 : Std_logic_vector(14 downto 0);
  Signal Term0_d : Std_logic_vector(10 downto 0);
  Signal Term1_d : Std_logic_vector(15 downto 0);
  Signal Term2_d : Std_logic_vector(14 downto 0);
  Signal Temp3 : Std_logic_vector(10 downto 0);
  Signal Temp4 : Std_logic_vector(0 downto 0);
  Signal Temp5 : Std_logic_vector(10 downto 0);
  Signal Temp6 : Std_logic_vector(15 downto 0);
  Signal Temp7 : Std_logic_vector(18 downto 0);
  Signal Temp8 : Std_logic_vector(15 downto 0);
  Signal Temp9 : Std_logic_vector(18 downto 0);
  Signal Temp10 : Std_logic_vector(15 downto 0);
  Signal Temp11 : Std_logic_vector(10 downto 0);
  Signal Temp12 : Std_logic_vector(0 downto 0);
  Signal Temp13 : Std_logic_vector(10 downto 0);
  Signal Temp14 : Std_logic_vector(10 downto 0);
  Signal Temp15 : Std_logic_vector(0 downto 0);
  Signal Temp16 : Std_logic_vector(13 downto 0);
  Signal Temp17 : Std_logic_vector(16 downto 0);
  Signal Temp18 : Std_logic_vector(17 downto 0);
  Signal Temp19 : Std_logic_vector(17 downto 0);
  Signal Temp20 : Std_logic_vector(17 downto 0);
  Signal Temp21 : Std_logic_vector(16 downto 0);
  Signal Temp22 : Std_logic_vector(13 downto 0);
  Signal Temp23 : Std_logic_vector(0 downto 0);
  Signal Temp24 : Std_logic_vector(10 downto 0);

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
    -- Temp1 = DIn<<4-DIn<<0
  Temp1 <= ((DIn(DIn'high) & DIn & "0000") - 
           (DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn));

-- Sign + 

  
  -----------------------------------
    -- Temp2 = DIn<<3-DIn<<0
  Temp2 <= ((DIn(DIn'high) & DIn & "000") - 
           (DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn));

-- Sign + 

  
  --------------------------------------------------------------------------------
  --                    Copy Terms Result from Temp to Term                     --
  --------------------------------------------------------------------------------
  Term0 <= Temp0;
  Term1 <= Temp1;
  Term2 <= Temp2;
  --------------------------------------------------------------------------------
  --                                Sample Terms                                --
  --------------------------------------------------------------------------------
  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
         Term0_d <= Term0;
         Term1_d <= Term1;
         Term2_d <= Term2;
      end if;
    end if;
  end process;
  --------------------------------------------------------------------------------
  --                         Generate Multipliers Array                         --
  --------------------------------------------------------------------------------
  -----------------------------------
  Temp3 <= Term0_d;-- Sign - 

  
  -----------------------------------
  Temp4 <= "0"; 
  
  -----------------------------------
  Temp5 <= Term0_d;-- Sign + 

  
  -----------------------------------
  Temp6 <= Term1_d;-- Sign + 

  
  -----------------------------------
    -- Temp7 = Term2_d<<3+Term0_d<<0
  Temp7 <= ((Term2_d(Term2_d'high) & Term2_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 3)) & Term0_d(2 downto 0));

-- Sign + 

  
  -----------------------------------
    -- Temp8 = Term0_d<<6+Term0_d<<2
  Temp8 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 4)) & Term0_d(3 downto 0));

-- Sign + 

  
  -----------------------------------
  Temp9 <= Temp7; -- Optimized

  
  -----------------------------------
  Temp10 <= Term1_d;-- Sign + 

  
  -----------------------------------
  Temp11 <= Term0_d;-- Sign + 

  
  -----------------------------------
  Temp12 <= "0"; 
  
  -----------------------------------
  Temp13 <= Term0_d;-- Sign - 

  
  --------------------------------------------------------------------------------
  --                          Final Stage Multipliers                           --
  --------------------------------------------------------------------------------
  -- Gen_pA_mB : Temp14 = -Temp3<<0
  Temp14 <= ( (not((Temp3(10 downto 0)))) + 1);
  -- Gen_pA_mB : Temp15 = Temp4<<0
  Temp15 <= (Temp4(0 downto 0));
  -- Gen_pA_mB : Temp16 = Temp5<<3
  Temp16 <= (Temp5(10 downto 0) & "000");
  -- Gen_pA_mB : Temp17 = Temp6<<1
  Temp17 <= (Temp6(15 downto 0) & "0");
  -- Gen_pA_mB : Temp18 = Temp7<<0
  Temp18 <= (Temp7(17 downto 0));
  -- Gen_pA_mB : Temp19 = Temp8<<2
  Temp19 <= (Temp8(15 downto 0) & "00");
  -- Gen_pA_mB : Temp20 = Temp9<<0
  Temp20 <= (Temp9(17 downto 0));
  -- Gen_pA_mB : Temp21 = Temp10<<1
  Temp21 <= (Temp10(15 downto 0) & "0");
  -- Gen_pA_mB : Temp22 = Temp11<<3
  Temp22 <= (Temp11(10 downto 0) & "000");
  -- Gen_pA_mB : Temp23 = Temp12<<0
  Temp23 <= (Temp12(0 downto 0));
  -- Gen_pA_mB : Temp24 = -Temp13<<0
  Temp24 <= ( (not((Temp13(10 downto 0)))) + 1);
  --------------------------------------------------------------------------------
  --                      Final Stage Multipliers Resample                      --
  --------------------------------------------------------------------------------
  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
         Mult0 <= Temp14;
         Mult1 <= Temp15;
         Mult2 <= Temp16;
         Mult3 <= Temp17;
         Mult4 <= Temp18;
         Mult5 <= Temp19;
         Mult6 <= Temp20;
         Mult7 <= Temp21;
         Mult8 <= Temp22;
         Mult9 <= Temp23;
         Mult10 <= Temp24;
      end if;
    end if;
  end process;
end Behavioral;
