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

entity PAL_N1 is
port(
  CLK : In Std_logic;
  CLK_EN : In Std_logic;
  DataIn : In Std_logic_vector(10 downto 0);
  DOut : Out Std_logic_vector(19 downto 0)
);
end PAL_N1;

architecture Behavioral of PAL_N1 is
  Signal Mult0 : Std_logic_vector(11 downto 0);
  Signal Mult1 : Std_logic_vector(15 downto 0);
  Signal Mult2 : Std_logic_vector(17 downto 0);
  Signal Mult3 : Std_logic_vector(18 downto 0);
  Signal Mult4 : Std_logic_vector(17 downto 0);
  Signal Mult5 : Std_logic_vector(15 downto 0);
  Signal Mult6 : Std_logic_vector(11 downto 0);
  Signal Temp0 : Std_logic_vector(11 downto 0);
  Signal Temp1 : Std_logic_vector(11 downto 0);
  Signal Temp2 : Std_logic_vector(16 downto 0);
  Signal Temp3 : Std_logic_vector(16 downto 0);
  Signal Temp4 : Std_logic_vector(18 downto 0);
  Signal Temp5 : Std_logic_vector(18 downto 0);
  Signal Temp6 : Std_logic_vector(19 downto 0);
  Signal Temp7 : Std_logic_vector(19 downto 0);
  Signal Temp8 : Std_logic_vector(20 downto 0);
  Signal Temp9 : Std_logic_vector(19 downto 0);
  Signal Temp10 : Std_logic_vector(20 downto 0);
  Signal Temp11 : Std_logic_vector(19 downto 0);
  Signal Temp12 : Std_logic_vector(20 downto 0);
  Signal Temp13 : Std_logic_vector(19 downto 0);

  ------------------------------------------------
  component PAL_N1_mult is
  port(
    Clk : In Std_logic;
    CLK_EN : In Std_logic;
    DIn : In Std_logic_vector(10 downto 0);
    Mult0 : Out Std_logic_vector(11 downto 0);
    Mult1 : Out Std_logic_vector(15 downto 0);
    Mult2 : Out Std_logic_vector(17 downto 0);
    Mult3 : Out Std_logic_vector(18 downto 0);
    Mult4 : Out Std_logic_vector(17 downto 0);
    Mult5 : Out Std_logic_vector(15 downto 0);
    Mult6 : Out Std_logic_vector(11 downto 0)
  );
  end component;


begin
  ------------------------------------------------
  -- FIR Filter Generator (V1.0)
  
  ------------------------------------------------
  M_MULT:PAL_N1_mult port map (
     CLK   => CLK,
     CLK_EN   => CLK_EN,
     DIn   => DataIn,
     Mult0 => Mult0,
     Mult1 => Mult1,
     Mult2 => Mult2,
     Mult3 => Mult3,
     Mult4 => Mult4,
     Mult5 => Mult5,
     Mult6 => Mult6
  );

  ------------------------------------------------
  Temp0 <= Mult6;-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp1 <= Temp0(11 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp2 = Mult5<<0+Temp1<<0
  Temp2 <= ((Mult5(Mult5'high) & Mult5) + 
           (Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp3 <= Temp2(16 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp4 = Mult4<<0+Temp3<<0
  Temp4 <= ((Mult4(Mult4'high) & Mult4) + 
           (Temp3(Temp3'high) & Temp3(Temp3'high) & Temp3(Temp3'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp5 <= Temp4(18 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp6 = Temp5<<0+Mult3<<0
  Temp6 <= ((Temp5(Temp5'high) & Temp5) + 
           (Mult3(Mult3'high) & Mult3(Mult3'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp7 <= Temp6(19 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp8 = Temp7<<0+Mult2<<0
  Temp8 <= ((Temp7(Temp7'high) & Temp7) + 
           (Mult2(Mult2'high) & Mult2(Mult2'high) & Mult2(Mult2'high) & Mult2(Mult2'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp9 <= Temp8(19 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp10 = Temp9<<0+Mult1<<0
  Temp10 <= ((Temp9(Temp9'high) & Temp9) + 
           (Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp11 <= Temp10(19 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp12 = Temp11<<0+Mult0<<0
  Temp12 <= ((Temp11(Temp11'high) & Temp11) + 
           (Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp13 <= Temp12(19 downto 0); -- LIM 

      end if;
    end if;
  end process;
  DOut <= Temp13;
end Behavioral;
