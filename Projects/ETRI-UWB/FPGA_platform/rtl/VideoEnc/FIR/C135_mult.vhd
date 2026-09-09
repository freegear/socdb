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

entity C135_mult is
port(
  Clk : In Std_logic;
  CLK_EN : In Std_logic;
  DIn : In Std_logic_vector(9 downto 0);
  Mult0 : Out Std_logic_vector(14 downto 0);
  Mult1 : Out Std_logic_vector(14 downto 0);
  Mult2 : Out Std_logic_vector(15 downto 0);
  Mult3 : Out Std_logic_vector(16 downto 0);
  Mult4 : Out Std_logic_vector(15 downto 0);
  Mult5 : Out Std_logic_vector(16 downto 0);
  Mult6 : Out Std_logic_vector(15 downto 0);
  Mult7 : Out Std_logic_vector(14 downto 0);
  Mult8 : Out Std_logic_vector(14 downto 0)
);
end C135_mult;

architecture Behavioral of C135_mult is
  Signal DInReg : Std_logic_vector(9 downto 0);
  Signal Temp0 : Std_logic_vector(9 downto 0);
  Signal Temp1 : Std_logic_vector(12 downto 0);
  Signal Temp2 : Std_logic_vector(15 downto 0);
  Signal Term0 : Std_logic_vector(9 downto 0);
  Signal Term1 : Std_logic_vector(12 downto 0);
  Signal Term2 : Std_logic_vector(15 downto 0);
  Signal Term0_d : Std_logic_vector(9 downto 0);
  Signal Term1_d : Std_logic_vector(12 downto 0);
  Signal Term2_d : Std_logic_vector(15 downto 0);
  Signal Temp3 : Std_logic_vector(14 downto 0);
  Signal Temp4 : Std_logic_vector(13 downto 0);
  Signal Temp5 : Std_logic_vector(15 downto 0);
  Signal Temp6 : Std_logic_vector(13 downto 0);
  Signal Temp7 : Std_logic_vector(16 downto 0);
  Signal Temp8 : Std_logic_vector(14 downto 0);
  Signal Temp9 : Std_logic_vector(13 downto 0);
  Signal Temp10 : Std_logic_vector(16 downto 0);
  Signal Temp11 : Std_logic_vector(15 downto 0);
  Signal Temp12 : Std_logic_vector(13 downto 0);
  Signal Temp13 : Std_logic_vector(14 downto 0);
  Signal Temp14 : Std_logic_vector(14 downto 0);
  Signal Temp15 : Std_logic_vector(14 downto 0);
  Signal Temp16 : Std_logic_vector(15 downto 0);
  Signal Temp17 : Std_logic_vector(16 downto 0);
  Signal Temp18 : Std_logic_vector(15 downto 0);
  Signal Temp19 : Std_logic_vector(16 downto 0);
  Signal Temp20 : Std_logic_vector(15 downto 0);
  Signal Temp21 : Std_logic_vector(14 downto 0);
  Signal Temp22 : Std_logic_vector(14 downto 0);

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
    -- Temp1 = DIn<<2-DIn<<0
  Temp1 <= ((DIn(DIn'high) & DIn & "00") - 
           (DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn));

-- Sign + 

  
  -----------------------------------
    -- Temp2 = DIn<<5-DIn<<0
  Temp2 <= ((DIn(DIn'high) & DIn & "00000") - 
           (DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn));

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
    -- Temp3 = Term0_d<<4+Term1_d<<0
  Temp3 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term1_d(Term1_d'high) & Term1_d(Term1_d'high) & Term1_d(Term1_d'high downto 4)) & Term1_d(3 downto 0));

-- Sign + 

  
  -----------------------------------
    -- Temp4 = Term1_d<<1+Term0_d<<4
  Temp4 <= ((Term1_d(Term1_d'high) & Term1_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 0) & "000"));

-- Sign + 

  
  -----------------------------------
  Temp5 <= Term2_d;-- Sign + 

  
  -----------------------------------
    -- Temp6 = Term0_d<<5+Term0_d<<2
  Temp6 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 3)) & Term0_d(2 downto 0));

-- Sign + 
  -- Temp7 = Temp6<<2+Term0_d<<0
  Temp7 <= ((Temp6(Temp6'high) & Temp6) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 2)) & Term0_d(1 downto 0));

-- Sign + 

  
  -----------------------------------
    -- Temp8 = Term0_d<<5+Term1_d<<1
  Temp8 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term1_d(Term1_d'high) & Term1_d(Term1_d'high) & Term1_d(Term1_d'high downto 4)) & Term1_d(3 downto 0));

-- Sign + 

  
  -----------------------------------
  Temp10 <= Temp7; -- Optimized

  
  -----------------------------------
  Temp11 <= Term2_d;-- Sign + 

  
  -----------------------------------
  Temp12 <= Temp4; -- Optimized

  
  -----------------------------------
  Temp13 <= Temp3; -- Optimized

  
  --------------------------------------------------------------------------------
  --                          Final Stage Multipliers                           --
  --------------------------------------------------------------------------------
  -- Gen_pA_mB : Temp14 = Temp3<<0
  Temp14 <= (Temp3(14 downto 0));
  -- Gen_pA_mB : Temp15 = Temp4<<1
  Temp15 <= (Temp4(13 downto 0) & "0");
  -- Gen_pA_mB : Temp16 = Temp5<<0
  Temp16 <= (Temp5(15 downto 0));
  -- Gen_pA_mB : Temp17 = Temp7<<0
  Temp17 <= (Temp7(16 downto 0));
  -- Gen_pA_mB : Temp18 = Temp8<<1
  Temp18 <= (Temp8(14 downto 0) & "0");
  -- Gen_pA_mB : Temp19 = Temp10<<0
  Temp19 <= (Temp10(16 downto 0));
  -- Gen_pA_mB : Temp20 = Temp11<<0
  Temp20 <= (Temp11(15 downto 0));
  -- Gen_pA_mB : Temp21 = Temp12<<1
  Temp21 <= (Temp12(13 downto 0) & "0");
  -- Gen_pA_mB : Temp22 = Temp13<<0
  Temp22 <= (Temp13(14 downto 0));
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
      end if;
    end if;
  end process;
end Behavioral;
