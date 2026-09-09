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

entity NTSC_YFilter is
port(
  CLK : In Std_logic;
  CLK_EN : In Std_logic;
  DataIn : In Std_logic_vector(10 downto 0);
  DOut : Out Std_logic_vector(22 downto 0)
);
end NTSC_YFilter;

architecture Behavioral of NTSC_YFilter is
  Signal Mult0 : Std_logic_vector(10 downto 0);
  Signal Mult1 : Std_logic_vector(13 downto 0);
  Signal Mult2 : Std_logic_vector(17 downto 0);
  Signal Mult3 : Std_logic_vector(18 downto 0);
  Signal Mult4 : Std_logic_vector(19 downto 0);
  Signal Mult5 : Std_logic_vector(19 downto 0);
  Signal Mult6 : Std_logic_vector(19 downto 0);
  Signal Mult7 : Std_logic_vector(18 downto 0);
  Signal Mult8 : Std_logic_vector(17 downto 0);
  Signal Mult9 : Std_logic_vector(13 downto 0);
  Signal Mult10 : Std_logic_vector(10 downto 0);
  Signal Temp0 : Std_logic_vector(10 downto 0);
  Signal Temp1 : Std_logic_vector(10 downto 0);
  Signal Temp2 : Std_logic_vector(14 downto 0);
  Signal Temp3 : Std_logic_vector(14 downto 0);
  Signal Temp4 : Std_logic_vector(18 downto 0);
  Signal Temp5 : Std_logic_vector(17 downto 0);
  Signal Temp6 : Std_logic_vector(19 downto 0);
  Signal Temp7 : Std_logic_vector(19 downto 0);
  Signal Temp8 : Std_logic_vector(20 downto 0);
  Signal Temp9 : Std_logic_vector(20 downto 0);
  Signal Temp10 : Std_logic_vector(21 downto 0);
  Signal Temp11 : Std_logic_vector(21 downto 0);
  Signal Temp12 : Std_logic_vector(22 downto 0);
  Signal Temp13 : Std_logic_vector(21 downto 0);
  Signal Temp14 : Std_logic_vector(22 downto 0);
  Signal Temp15 : Std_logic_vector(21 downto 0);
  Signal Temp16 : Std_logic_vector(22 downto 0);
  Signal Temp17 : Std_logic_vector(21 downto 0);
  Signal Temp18 : Std_logic_vector(22 downto 0);
  Signal Temp19 : Std_logic_vector(22 downto 0);
  Signal Temp20 : Std_logic_vector(23 downto 0);
  Signal Temp21 : Std_logic_vector(22 downto 0);

  ------------------------------------------------
  component NTSC_YFilter_mult is
  port(
    Clk : In Std_logic;
    CLK_EN : In Std_logic;
    DIn : In Std_logic_vector(10 downto 0);
    Mult0 : Out Std_logic_vector(10 downto 0);
    Mult1 : Out Std_logic_vector(13 downto 0);
    Mult2 : Out Std_logic_vector(17 downto 0);
    Mult3 : Out Std_logic_vector(18 downto 0);
    Mult4 : Out Std_logic_vector(19 downto 0);
    Mult5 : Out Std_logic_vector(19 downto 0);
    Mult6 : Out Std_logic_vector(19 downto 0);
    Mult7 : Out Std_logic_vector(18 downto 0);
    Mult8 : Out Std_logic_vector(17 downto 0);
    Mult9 : Out Std_logic_vector(13 downto 0);
    Mult10 : Out Std_logic_vector(10 downto 0)
  );
  end component;


begin
  ------------------------------------------------
  -- FIR Filter Generator (V1.0)
  
  ------------------------------------------------
  M_MULT:NTSC_YFilter_mult port map (
     CLK   => CLK,
     CLK_EN   => CLK_EN,
     DIn   => DataIn,
     Mult0 => Mult0,
     Mult1 => Mult1,
     Mult2 => Mult2,
     Mult3 => Mult3,
     Mult4 => Mult4,
     Mult5 => Mult5,
     Mult6 => Mult6,
     Mult7 => Mult7,
     Mult8 => Mult8,
     Mult9 => Mult9,
     Mult10 => Mult10
  );

  ------------------------------------------------
  Temp0 <= Mult10;-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp1 <= Temp0(10 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp2 = Mult9<<0+Temp1<<0
  Temp2 <= ((Mult9(Mult9'high) & Mult9) + 
           (Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high) & Temp1(Temp1'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp3 <= Temp2(14 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp4 = Mult8<<0+Temp3<<0
  Temp4 <= ((Mult8(Mult8'high) & Mult8) + 
           (Temp3(Temp3'high) & Temp3(Temp3'high) & Temp3(Temp3'high) & Temp3(Temp3'high) & Temp3(Temp3'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp5 <= Temp4(17 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp6 = Mult7<<0+Temp5<<0
  Temp6 <= ((Mult7(Mult7'high) & Mult7) + 
           (Temp5(Temp5'high) & Temp5(Temp5'high) & Temp5(Temp5'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp7 <= Temp6(19 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp8 = Temp7<<0+Mult6<<0
  Temp8 <= ((Temp7(Temp7'high) & Temp7) + 
           (Mult6(Mult6'high) & Mult6(Mult6'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp9 <= Temp8(20 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp10 = Temp9<<0+Mult5<<0
  Temp10 <= ((Temp9(Temp9'high) & Temp9) + 
           (Mult5(Mult5'high) & Mult5(Mult5'high) & Mult5(Mult5'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp11 <= Temp10(21 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp12 = Temp11<<0+Mult4<<0
  Temp12 <= ((Temp11(Temp11'high) & Temp11) + 
           (Mult4(Mult4'high) & Mult4(Mult4'high) & Mult4(Mult4'high) & Mult4(Mult4'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp13 <= Temp12(21 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp14 = Temp13<<0+Mult3<<0
  Temp14 <= ((Temp13(Temp13'high) & Temp13) + 
           (Mult3(Mult3'high) & Mult3(Mult3'high) & Mult3(Mult3'high) & Mult3(Mult3'high) & Mult3(Mult3'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp15 <= Temp14(21 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp16 = Temp15<<0+Mult2<<0
  Temp16 <= ((Temp15(Temp15'high) & Temp15) + 
           (Mult2(Mult2'high) & Mult2(Mult2'high) & Mult2(Mult2'high) & Mult2(Mult2'high) & Mult2(Mult2'high) & Mult2(Mult2'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp17 <= Temp16(21 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp18 = Temp17<<0+Mult1<<0
  Temp18 <= ((Temp17(Temp17'high) & Temp17) + 
           (Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high) & Mult1(Mult1'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp19 <= Temp18(22 downto 0); -- LIM 

      end if;
    end if;
  end process;
    -- Temp20 = Temp19<<0+Mult0<<0
  Temp20 <= ((Temp19(Temp19'high) & Temp19) + 
           (Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high) & Mult0(Mult0'high downto 0)));

-- Sign + 

  process (Clk) begin
    if (Clk'event and Clk='1') then
      if (CLK_EN='1') then
        Temp21 <= Temp20(22 downto 0); -- LIM 

      end if;
    end if;
  end process;
  DOut <= Temp21;
end Behavioral;
