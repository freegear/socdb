--  --========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : BWMonitor.vhd,v
--  File Revision       : 1.0
--  
--  Release Information : -
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Monitors memory bus transfers
--                       
--  --========================================================================--

    
library ieee;
use     ieee.std_logic_1164.all;
use     std.textio.all;

entity BWMonitor is
  port(
    CLK       : in std_logic;
    nCS       : in std_logic_vector(3 downto 0);
    nRAS      : in std_logic; 
    nCAS      : in std_logic;
    nWE       : in std_logic;
    DQM       : in std_logic_vector(3 downto 0);
    Addr      : in std_logic_vector(27 downto 0)
    );

end BWMonitor;

architecture behavioural of BWMonitor is


--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

-- Integers for statistics purposes
  signal Total      : integer := 0;     -- Total cycles counter
  signal Deselects  : integer := 0;     -- Deselcts counter
  signal NOPs       : integer := 0;     -- NOPs counter
  signal Actives    : integer := 0;     -- Actives counter
  signal Read_Bs    : integer := 0;     -- Read bytes counter
  signal Read_Hs    : integer := 0;     -- Read halfwords counter
  signal Read_Ws    : integer := 0;     -- Read words counter
  signal Write_Bs   : integer := 0;     -- Write bytes counter
  signal Write_Hs   : integer := 0;     -- Write halfwords counter
  signal Write_Ws   : integer := 0;     -- Write words counter
  signal BTs        : integer := 0;     -- Burst Terminates counter
  signal PBs        : integer := 0;     -- Precharge banks counter
  signal PAs        : integer := 0;     -- Precharge all counter
  signal Refreshs   : integer := 0;     -- Refreshs counter
  signal LMRegs     : integer := 0;     -- Load Mode register counter
  signal UnDef      : integer := 0;     -- Udefined functions counter

  
--------------------------------------------------------------------------------
-- Int2HexChar converts an integer (0-15) to a hex char
--------------------------------------------------------------------------------

  function Int2HexChar (Int : integer) return character is

  variable Char : character;
  begin
    if Int<16 then  
      if Int<10 then
        Char := character'val(Int + 48);
      else
        Char := character'val(Int + 55);  
      end if;
    else
      Char := 'X';
    end if; 
    return Char;

  end Int2HexChar;


--------------------------------------------------------------------------------
-- Int2HexStr converts an integer to a hex string
--------------------------------------------------------------------------------

  function Int2HexStr (Int : integer) return string is

  variable str : string(1 to 8);
  begin
    if Int<0 then
      str := "Negative";
    else
      str(1) := Int2HexChar((Int / 268435456) MOD 16);
      str(2) := Int2HexChar((Int / 16777216) MOD 16);
      str(3) := Int2HexChar((Int / 1048576) MOD 16);  
      str(4) := Int2HexChar((Int / 65536) MOD 16);
      str(5) := Int2HexChar((Int / 4096) MOD 16);
      str(6) := Int2HexChar((Int / 256) MOD 16);
      str(7) := Int2HexChar((Int / 16) MOD 16);
      str(8) := Int2HexChar(Int MOD 16);
    end if;
    return str;

  end Int2HexStr;


-------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------
begin

-------------------------------------------------------------------------------
-- Counter counts the occurences of different commands
-------------------------------------------------------------------------------  
  
  Counter : process(CLK)
    variable control : std_logic_vector(2 downto 0);  -- Join RAS, CAS & WE
  begin
    if CLK = '1' then
      Total <= Total + 1;
      if nCS = "1111" then
        Deselects <= Deselects + 1;
      else
        control := (nRAS & nCAS & nWE);
        case control is
          when "111" => NOPs <= NOPs + 1;
          when "011" => Actives <= Actives + 1;
          when "101" => case DQM is
              when "0000" => Read_Ws <= Read_Ws + 1;
              when "1100" => Read_Hs <= Read_Hs + 1;
              when "0011" => Read_Hs <= Read_Hs + 1;
              when "1110" => Read_Bs <= Read_Bs + 1;
              when "1101" => Read_Bs <= Read_Bs + 1;
              when "1011" => Read_Bs <= Read_Bs + 1;
              when "0111" => Read_Bs <= Read_Bs + 1;
              when others => null;
            end case;               
          when "100" => case DQM is
              when "0000" => Write_Ws <= Write_Ws + 1;
              when "1100" => Write_Hs <= Write_Hs + 1;
              when "0011" => Write_Hs <= Write_Hs + 1;
              when "1110" => Write_Bs <= Write_Bs + 1;
              when "1101" => Write_Bs <= Write_Bs + 1;
              when "1011" => Write_Bs <= Write_Bs + 1;
              when "0111" => Write_Bs <= Write_Bs + 1;
              when others => null;
            end case;                           
          when "110" => BTs <= BTs + 1;
          when "010" => if Addr(10)='1' then
                          PAs <= PAs + 1;
                        else
                          PBs <= PBs + 1;
                        end if;                        
          when "001" => Refreshs <= Refreshs + 1;
          when "000" => LMRegs <= LMRegs + 1;
          when others => UnDef <= UnDef + 1;
        end case; 
      end if;
   end if;
  end process Counter;


-------------------------------------------------------------------------------
-- Regular output of command statistics when total count gets to 1024
-------------------------------------------------------------------------------
  
  RegularOutput : process (Total)
    variable L : line;
  begin 
      if ((Total-UnDef) > 0 and ((Total-UnDef) MOD 1024 = 0)) then
         -- output stats every 1024 cycles
        write(L,string'("BM***  Memory Bandwidth Monitor Statistics   *****"));
        writeline(OUTPUT, L); 
        write(L,string'("BM    Total Memory Clock Cycles = 0x"));
        write(L,string'(Int2HexStr(Total-UnDef) & "    **"));
        writeline(OUTPUT, L); 
        write(L,string'("BM    Report Time             "));
        write(L, NOW, RIGHT, 14, NS);
        write(L,string'("    **"));
        writeline(OUTPUT, L); 
        write(L,string'("**----------------------------------------------**"));
        writeline(OUTPUT, L);
        write(L,string'("**          Command                 Count       **"));
        writeline(OUTPUT, L); 
        write(L,string'("BM    DESELECT                    0x"));
        write(L,string'(Int2HexStr(Deselects) & "    **"));
        writeline(OUTPUT, L); 
        write(L,string'("BM    NOP                         0x"));
        write(L,string'(Int2HexStr(NOPs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    ACTIVE                      0x"));
        write(L,string'(Int2HexStr(Actives) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    READ_B    - BYTE            0x"));
        write(L,string'(Int2HexStr(Read_Bs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    READ_H    - HALF WORD       0x"));
        write(L,string'(Int2HexStr(Read_Hs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    READ_W    - WORD            0x"));
        write(L,string'(Int2HexStr(Read_Ws) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    WRITE_B   - BYTE            0x"));
        write(L,string'(Int2HexStr(Write_Bs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    WRITE_H   - HALF WORD       0x"));
        write(L,string'(Int2HexStr(Write_Hs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    WRITE_W   - WORD            0x"));
        write(L,string'(Int2HexStr(Write_Ws) & "    **"));
        writeline(OUTPUT, L);              
        write(L,string'("BM    BURST TERMINATE             0x"));
        write(L,string'(Int2HexStr(BTs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    PRECHARGE_BANK              0x"));
        write(L,string'(Int2HexStr(PBs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    PRECHARGE_ALL               0x"));
        write(L,string'(Int2HexStr(PAs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    REFRESH                     0x"));
        write(L,string'(Int2HexStr(Refreshs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("BM    LOAD MODE REGISTER          0x"));
        write(L,string'(Int2HexStr(LMRegs) & "    **"));
        writeline(OUTPUT, L);
        write(L,string'("**************************************************"));
        writeline(OUTPUT, L);               
      end if;
  end process RegularOutput;
  
end behavioural;



-- --================================= End ===================================--

