--*******************************************************************--
-- Copyright (c) 2001-2004  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix Ltd. immediately that you   --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G AMBA
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : apbcmd.vhd
-- File contents        : Entity APBCMD
--                        Architecture SIM of APBCMD
--
-- Purpose              : APB interface stimulator/monitor/checker
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : STD.TEXTIO
--                        IEEE.STD_LOGIC_1164
--                        IEEE.STD_LOGIC_UNSIGNED
--                        IEEE.STD_LOGIC_TEXTIO
--
-- Design Engineer      : L.C.
-- Quality Engineer     : M.B.
-- Version              : 2.02.E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library STD;
use STD.TEXTIO.all;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;
use IEEE.STD_LOGIC_UNSIGNED."+";
use IEEE.STD_LOGIC_TEXTIO.all;

library MAC_1G_LIB;
  use MAC_1G_LIB.UTILITY_MAC_1G.all;

--*******************************************************************--

entity APBCONV is
  generic(
    INFILE          : STRING  := "csrstim.txt";
    OUTFILE         : STRING  := "apbstim.txt";
    TESTNAME        : STRING  := "default";
    TESTPATH        : STRING  := "tests"
    );
end APBCONV;


--*******************************************************************--
architecture SIM of APBCONV is
  
  -- wait command encoding
  constant CMD_WAIT   : INTEGER := 0;
  -- read command encoding
  constant CMD_READ   : INTEGER := 1;
  -- write command encoding
  constant CMD_WRITE  : INTEGER := 2;
  
begin
  
  -------------------------------------------------------------------
  -- STIMFILE reader
  -------------------------------------------------------------------
  stimread_proc:
  process

    -- csr values
    -- csr0 reset value
    variable csr0_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111110000000000000000000000000";
    -- csr1 reset value
    variable csr1_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    -- csr2 reset value
    variable csr2_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    -- csr3 reset value
    variable csr3_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    -- csr4 reset value
    variable csr4_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111111111111111111111";
    -- csr5 reset value
    variable csr5_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11110000000000000000000000000000";
    -- csr6 reset value
    variable csr6_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00110010000000000000000001000000";
    -- csr7 reset value
    variable csr7_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11110011111111100000000000000000";
    -- csr8 reset value
    variable csr8_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11100000000000000000000000000000";
    -- csr9 reset value
    variable csr9_tmp  : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111101001000001111111111";
    -- csr10 reset value
    variable csr10_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    -- csr11 reset value
    variable csr11_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "11111111111111100000000000000000";
    -- csr16 reset value
    variable csr16_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    -- csr17 reset value
    variable csr17_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    -- csr18 reset value
    variable csr18_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    -- csr19 reset value
    variable csr19_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
    -- csr20 reset value
    variable csr20_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00110000000000000000000000000000";
    -- csr21 reset value
    variable csr21_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000001000001100000000";
    -- csr22 reset value
    variable csr22_tmp : STD_LOGIC_VECTOR(31 downto 0) 
                      := "00000000000000000000000000000000";
                    
    variable char_v         : CHARACTER;
    variable stim_cmd_v     : INTEGER;
    variable stim_cycles_v  : INTEGER;
    variable stim_be_v      : STD_LOGIC_VECTOR(3 downto 0);
    variable stim_addr_v    : STD_LOGIC_VECTOR(7 downto 0);
    variable stim_data_v    : STD_LOGIC_VECTOR(31 downto 0);
    variable tim_v    		: INTEGER;
    variable out_row  		: LINE;
    variable in_row   		: LINE;
    file     out_file 		: TEXT is out TESTPATH & "/" & TESTNAME & "/" & OUTFILE;
    file     in_file  		: TEXT is in TESTPATH & "/" & TESTNAME & "/" & INFILE;
    
  begin
	
    while not ENDFILE(in_file) loop
      READLINE(in_file, in_row);
      -- check if it is commented line
      while in_row'length/=0 loop
        if in_row(in_row'left)=' ' or
           in_row(in_row'left)='/'
        then
          while in_row'length/=0 loop
            READ(in_row, char_v);
            WRITE(out_row, char_v);
          end loop;
        else
          READ(in_row,  stim_cmd_v);
          case stim_cmd_v is
            when CMD_READ =>
              HREAD(in_row, stim_addr_v);
              HREAD(in_row, stim_be_v);
              HREAD(in_row, stim_data_v);
              WRITE(out_row, CMD_READ);
              WRITE(out_row, STRING'("  "));
              HWRITE(out_row, stim_addr_v);
              WRITE(out_row, STRING'("  "));
              HWRITE(out_row, stim_data_v);
              while in_row'length/=0 loop
                READ(in_row, char_v);
                WRITE(out_row, char_v);
              end loop;
              
            when CMD_WRITE =>
              HREAD(in_row, stim_addr_v);
              HREAD(in_row, stim_be_v);
              HREAD(in_row, stim_data_v);
              
              if stim_be_v(0)='1' then
                case stim_addr_v(7 downto 2) is
                  when CSR0_ID  => csr0_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR3_ID  => csr3_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR4_ID  => csr4_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR5_ID  => csr5_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR6_ID  => csr6_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR7_ID  => csr7_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR8_ID  => csr8_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR9_ID  => csr9_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR10_ID => csr10_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR11_ID => csr11_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR16_ID => csr16_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR17_ID => csr17_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR18_ID => csr18_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR19_ID => csr19_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR20_ID => csr20_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR21_ID => csr21_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when CSR22_ID => csr22_tmp(7 downto 0) := stim_data_v(7 downto 0);
                  when others   => null;
                end case;
              end if;
              if stim_be_v(1)='1' then
                case stim_addr_v(7 downto 2) is
                  when CSR0_ID  => csr0_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR3_ID  => csr3_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR4_ID  => csr4_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR5_ID  => csr5_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR6_ID  => csr6_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR7_ID  => csr7_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR8_ID  => csr8_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR9_ID  => csr9_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR10_ID => csr10_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR11_ID => csr11_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR16_ID => csr16_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR17_ID => csr17_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR18_ID => csr18_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR19_ID => csr19_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR20_ID => csr20_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR21_ID => csr21_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when CSR22_ID => csr22_tmp(15 downto 8) := stim_data_v(15 downto 8);
                  when others   => null;
                end case;
              end if;
              if stim_be_v(2)='1' then
                case stim_addr_v(7 downto 2) is
                  when CSR0_ID  => csr0_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR3_ID  => csr3_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR4_ID  => csr4_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR5_ID  => csr5_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR6_ID  => csr6_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR7_ID  => csr7_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR8_ID  => csr8_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR9_ID  => csr9_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR10_ID => csr10_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR11_ID => csr11_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR16_ID => csr16_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR17_ID => csr17_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR18_ID => csr18_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR19_ID => csr19_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR20_ID => csr20_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR21_ID => csr21_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when CSR22_ID => csr22_tmp(23 downto 16) := stim_data_v(23 downto 16);
                  when others   => null;
                end case;
              end if;
              if stim_be_v(3)='1' then
                case stim_addr_v(7 downto 2) is
                  when CSR0_ID  => csr0_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR3_ID  => csr3_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR4_ID  => csr4_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR5_ID  => csr5_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR6_ID  => csr6_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR7_ID  => csr7_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR8_ID  => csr8_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR9_ID  => csr9_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR10_ID => csr10_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR11_ID => csr11_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR16_ID => csr16_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR17_ID => csr17_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR18_ID => csr18_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR19_ID => csr19_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR20_ID => csr20_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR21_ID => csr21_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when CSR22_ID => csr22_tmp(31 downto 24) := stim_data_v(31 downto 24);
                  when others   => null;
                end case;
              end if;
              WRITE(out_row, CMD_WRITE);
              WRITE(out_row, STRING'("  "));
              HWRITE(out_row, stim_addr_v);
              WRITE(out_row, STRING'("  "));
              case stim_addr_v(7 downto 2) is
                when CSR0_ID  => HWRITE(out_row, csr0_tmp);
                when CSR1_ID  => HWRITE(out_row, stim_data_v);
                when CSR2_ID  => HWRITE(out_row, stim_data_v);
                when CSR3_ID  => HWRITE(out_row, csr3_tmp);
                when CSR4_ID  => HWRITE(out_row, csr4_tmp);
                when CSR5_ID  => HWRITE(out_row, csr5_tmp);
                when CSR6_ID  => HWRITE(out_row, csr6_tmp);
                when CSR7_ID  => HWRITE(out_row, csr7_tmp);
                when CSR8_ID  => HWRITE(out_row, csr8_tmp);
                when CSR9_ID  => HWRITE(out_row, csr9_tmp);
                when CSR10_ID => HWRITE(out_row, csr10_tmp);
                when CSR11_ID => HWRITE(out_row, csr11_tmp);
                when CSR16_ID => HWRITE(out_row, csr16_tmp);
                when CSR17_ID => HWRITE(out_row, csr17_tmp);
                when CSR18_ID => HWRITE(out_row, csr18_tmp);
                when CSR19_ID => HWRITE(out_row, csr19_tmp);
                when CSR20_ID => HWRITE(out_row, csr20_tmp);
                when CSR21_ID => HWRITE(out_row, csr21_tmp);
                when CSR22_ID => HWRITE(out_row, csr22_tmp);
                when others   => null;
              end case;
              while in_row'length/=0 loop
                READ(in_row, char_v);
                WRITE(out_row, char_v);
              end loop;
              
            when CMD_WAIT =>
              READ(in_row, stim_cycles_v);
              WRITE(out_row, CMD_WAIT);
              WRITE(out_row, STRING'("  "));
              WRITE(out_row, stim_cycles_v);
              READ(in_row, char_v);
              while in_row'length/=0 loop
                READ(in_row, char_v);
                WRITE(out_row, char_v);
              end loop;
            when others =>
              null;
          end case;
        end if;
      end loop;
      WRITELINE(out_file, out_row);
    end loop;
    wait;
  end process;
  
end SIM;
--*******************************************************************--
