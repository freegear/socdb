--*******************************************************************--
-- Copyright (c) 2001-2003  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix Ltd. immediately that you   --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G AMBA
-- Project description  : Ethernet Media Access Controller
--
-- File name            : ambaarbcmd.vhd
-- File contents        : Entity AMBAARBCMD
--                        Architecture SIM of AMBAARBCMD
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
-- Version              : 2.00.E00
-- Last modification    : 2003-11-27
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

--*******************************************************************--

entity AMBAARBCMD is
  generic(
    MODE            : INTEGER := 1; -- operating mode
    --                              -- 0 - no occurrence
    --                              -- 1 - stimulate
    STIMFILE        : STRING  := "arbstim.txt";
    TESTNAME        : STRING  := "default";
    TESTPATH        : STRING  := "tests";
    CLK_PERIOD      : TIME    := 40 ns 
    );
  
  port(
    -- AHB interface clock --
    hclk        : in  STD_LOGIC;
    -- AHB bus reset --
    hresetn     : in  STD_LOGIC;
    -- AHB MAC bus request
    hbusreqmac  : in  STD_LOGIC;
    -- AHB MAC lock transfer
    hlockmac    : in  STD_LOGIC;
    -- AHB Master identifier --
    hmaster     : out STD_LOGIC_VECTOR(3 downto 0);
    -- AHB master lock transfer --
    hmastlock   : out STD_LOGIC;
    -- AHB MAC bus grant
    hgrantmac   : out STD_LOGIC;
    -- RAM_AHB select
    hselram     : out STD_LOGIC;
    -- memory wait cycles
    waitstates  : out STD_LOGIC_VECTOR(2 downto 0)
    );
end AMBAARBCMD;


--*******************************************************************--
architecture SIM of AMBAARBCMD is
  
  -- hold time
  constant hold         : TIME := CLK_PERIOD/10;
  -- setup time
  constant setup        : TIME := CLK_PERIOD/10 * 9;
  
  -- grant set opcode 
  constant CMD_GRANTSET : INTEGER := 0;
  -- wait request opcode 
  constant CMD_WAITREQ  : INTEGER := 1;
  -- wait n clk cycles opcode 
  constant CMD_WAITCLK  : INTEGER := 2;
  
  -- sample generator #1
  signal sample1        : STD_LOGIC;
  -- sample generator #2
  signal sample2        : STD_LOGIC;
  
  
begin
  
  ---------------------------------------------------------------------
  -- sample generator
  ---------------------------------------------------------------------
  sample_proc:
    process
  begin
    loop
      wait on hclk until hclk='1' and hresetn='1';
      if sample1='U' then
        sample1 <= '0';
      else
        sample1 <= not sample1 after CLK_PERIOD/10;
      end if;
      if sample2='U' then
        sample2 <= '0';
      else
        sample2 <= not sample2 after CLK_PERIOD/10*9;
      end if;
    end loop;
  end process; -- sample_proc
  
  -- locked trasfers --
  hmastlock_drv:
  hmastlock  <= hlockmac;
  
  -------------------------------------------------------------------
  -- STIMFILE reader
  -------------------------------------------------------------------
  stimread_proc:
    process
    variable char           : CHARACTER;
    variable stim_cmd_v     : INTEGER;
    variable stim_value_v   : INTEGER;
    variable stim_logic_v   : STD_LOGIC;
    variable stim_num       : INTEGER := 0;
    variable stim_row       : LINE;
    file     stim           : TEXT is in TESTPATH & "/" &  TESTNAME & "/" & STIMFILE;
    
  begin
    
        
    hselram    <= '1';
    hmaster    <= "0001";
    waitstates <= "001";
    hgrantmac  <= '0';
    
    wait on hclk until hclk='1' and hresetn='1';

    
    while not ENDFILE(stim) loop
      
      READLINE(stim, stim_row);
      stim_num := stim_num+1;
      
      -- check if it is commented line
      while stim_row'length/=0 loop
        if stim_row(stim_row'left)='/' then
          exit;
        elsif stim_row(stim_row'left)/=' ' then
          exit;
        end if;
        READ(stim_row, char);
      end loop;
      
      -- only uncommented and non empty line
      
      if stim_row'length/=0 and stim_row(stim_row'left)/='/' then
        
        READ(stim_row,  stim_cmd_v);
        
        
        case stim_cmd_v is
          
          ----------------------------
          when CMD_GRANTSET =>
          ----------------------------
          READ(stim_row,  stim_logic_v);
          hgrantmac <= stim_logic_v;
          
          ----------------------------
          when CMD_WAITREQ =>  
          ----------------------------
          READ(stim_row,  stim_value_v);
          if stim_value_v=1 then
            -- wait for new hbusreqmac --
            if hbusreqmac='1' then
              wait on sample2 until hbusreqmac='0';
            end if; 
            wait on sample2 until hbusreqmac='1';
          end if;
          
          if stim_value_v=0 then
            -- wait for new hbusreqmac --
            if hbusreqmac='0' then
              wait on sample2 until hbusreqmac='1';
            end if; 
            wait on sample2 until hbusreqmac='0';
          end if;
          
          ----------------------------
          when CMD_WAITCLK =>  
          ----------------------------
          READ(stim_row,  stim_value_v);
          wait for stim_value_v*CLK_PERIOD;
          
          ----------------------------
          when others => 
          ----------------------------
        end case;      
        
      end if;
      
    end loop;
    wait;
    
  end process;
  
end SIM;
--*******************************************************************--
