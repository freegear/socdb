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

entity PAL_N0_mult is
port(
  Clk : In Std_logic;
  CLK_EN : In Std_logic;
  DIn : In Std_logic_vector(10 downto 0);
  Mult0 : Out Std_logic_vector(18 downto 0);
  Mult1 : Out Std_logic_vector(16 downto 0);
  Mult2 : Out Std_logic_vector(16 downto 0);
  Mult3 : Out Std_logic_vector(16 downto 0);
  Mult4 : Out Std_logic_vector(18 downto 0)
);
end PAL_N0_mult;

architecture Behavioral of PAL_N0_mult is
  Signal DInReg : Std_logic_vector(10 downto 0);
  Signal Temp0 : Std_logic_vector(10 downto 0);
  Signal Temp1 : Std_logic_vector(15 downto 0);
  Signal Temp2 : Std_logic_vector(13 downto 0);
  Signal Term0 : Std_logic_vector(10 downto 0);
  Signal Term1 : Std_logic_vector(15 downto 0);
  Signal Term2 : Std_logic_vector(13 downto 0);
  Signal Term0_d : Std_logic_vector(10 downto 0);
  Signal Term1_d : Std_logic_vector(15 downto 0);
  Signal Term2_d : Std_logic_vector(13 downto 0);
  Signal Temp3 : Std_logic_vector(16 downto 0);
  Signal Temp4 : Std_logic_vector(18 downto 0);
  Signal Temp5 : Std_logic_vector(15 downto 0);
  Signal Temp6 : Std_logic_vector(16 downto 0);
  Signal Temp7 : Std_logic_vector(15 downto 0);
  Signal Temp8 : Std_logic_vector(16 downto 0);
  Signal Temp9 : Std_logic_vector(18 downto 0);
  Signal Temp10 : Std_logic_vector(18 downto 0);
  Signal Temp11 : Std_logic_vector(16 downto 0);
  Signal Temp12 : Std_logic_vector(16 downto 0);
  Signal Temp13 : Std_logic_vector(16 downto 0);
  Signal Temp14 : Std_logic_vector(18 downto 0);

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
    -- Temp2 = DIn<<2-DIn<<0
  Temp2 <= ((DIn(DIn'high) & DIn & "00") - 
           (DIn(DIn'high) & DIn(DIn'high) & DIn(DIn'high) & DIn));

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
    -- Temp3 = Term0_d<<6-Term0_d<<1
  Temp3 <= ((Term0_d(Term0_d'high) & Term0_d & "00000") - 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d));

-- Sign + 
  -- Temp4 = Temp3<<1+Term1_d<<0
  Temp4 <= ((Temp3(Temp3'high) & Temp3) + 
           (Term1_d(Term1_d'high) & Term1_d(Term1_d'high) & Term1_d(Term1_d'high) & Term1_d(Term1_d'high downto 1)) & Term1_d(0 downto 0));

-- Sign + 

  
  -----------------------------------
    -- Temp5 = Term0_d<<5+Term0_d<<1
  Temp5 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high) & Term0_d(Term0_d'high downto 4)) & Term0_d(3 downto 0));

-- Sign + 

  
  -----------------------------------
    -- Temp6 = Term0_d<<5+Term2_d<<0
  Temp6 <= ((Term0_d(Term0_d'high) & Term0_d) + 
           (Term2_d(Term2_d'high) & Term2_d(Term2_d'high) & Term2_d(Term2_d'high) & Term2_d(Term2_d'high downto 5)) & Term2_d(4 downto 0));

-- Sign + 

  
  -----------------------------------
  Temp7 <= Temp5; -- Optimized

  
  -----------------------------------
  Temp9 <= Temp4; -- Optimized

  
  --------------------------------------------------------------------------------
  --                          Final Stage Multipliers                           --
  --------------------------------------------------------------------------------
  -- Gen_pA_mB : Temp10 = Temp4<<0
  Temp10 <= (Temp4(18 downto 0));
  -- Gen_pA_mB : Temp11 = Temp5<<1
  Temp11 <= (Temp5(15 downto 0) & "0");
  -- Gen_pA_mB : Temp12 = Temp6<<0
  Temp12 <= (Temp6(16 downto 0));
  -- Gen_pA_mB : Temp13 = Temp7<<1
  Temp13 <= (Temp7(15 downto 0) & "0");
  -- Gen_pA_mB : Temp14 = Temp9<<0
  Temp14 <= (Temp9(18 downto 0));
  --------------------------------------------------------------------------------
  --                      Final Stage Multipliers Resample                      --
  --------------------------------------------------------------------------------
  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
         Mult0 <= Temp10;
         Mult1 <= Temp11;
         Mult2 <= Temp12;
         Mult3 <= Temp13;
         Mult4 <= Temp14;
      end if;
    end if;
  end process;
end Behavioral;
