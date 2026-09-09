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

--*******************************************************************--

entity APBCMD is
  generic(
    MODE            : INTEGER := 1; -- operating mode
    --                              -- 0 - no occurrence
    --                              -- 1 - the COMPFILE writer
    --                              -- 2 - vectors comparator
    APBDATAWIDTH    : INTEGER := 32;
    APBADDRESSWIDTH : INTEGER := 8;
    STIMFILE        : STRING  := "apbstim.txt";
    COMPFILE        : STRING  := "apbcomp.txt";
    DIFFFILE        : STRING  := "apbdiff.txt";
    TESTNAME        : STRING  := "default";
    TESTPATH        : STRING  := "tests";
    CLK_PERIOD      : TIME    := 40 ns 
    );
  
  port(
    
    ---------------------------------
    --  AMBA APB master interface  --
    ---------------------------------
    
    -- interface clock --
    pclk        : in  STD_LOGIC;
    -- bus reset --
    presetn     : in  STD_LOGIC;
    -- read data  --
    prdata      : in  STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);  
    -- bus address --
    paddr       : out STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
    -- device select --
    pselmaccsr  : out STD_LOGIC;
    -- device enable --
    penable     : out STD_LOGIC;
    -- transfer direction --
    pwrite      : out STD_LOGIC;
    -- write data --
    pwdata      : out STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0)
    
    );
end APBCMD;


--*******************************************************************--
architecture SIM of APBCMD is
  
  -- hold time
  constant hold       : TIME := CLK_PERIOD/10;
  -- setup time
  constant setup      : TIME := CLK_PERIOD/10 * 9;
  
  -- sample generator #1
  signal sample1      : STD_LOGIC;
  -- sample generator #2
  signal sample2      : STD_LOGIC;
  
  -- wait command encoding
  constant CMD_WAIT   : INTEGER := 0;
  -- read command encoding
  constant CMD_READ   : INTEGER := 1;
  -- write command encoding
  constant CMD_WRITE  : INTEGER := 2;
  
  -- stim file trigger
  signal stimtrig     : STD_LOGIC;
  -- stimulator acknowledge
  signal stimack      : STD_LOGIC;
  
  -- command from stimfile
  signal stim_cmd     : INTEGER;
  -- wait cycles from stimfile
  signal stim_cycles  : INTEGER;
  -- address from stimfile
  signal stim_addr    : STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
  -- data from stimfile
  signal stim_data    : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
  
  -- comp file trigger
  signal comptrig     : STD_LOGIC;
  -- comparator acknowledge
  signal compack      : STD_LOGIC;
  -- end of comp file
  signal eofcomp      : STD_LOGIC;
  
  -- command from compfile
  signal comp_cmd     : INTEGER;
  -- read / not write from compfile
  signal comp_rw      : STD_LOGIC;
  -- address from compfile
  signal comp_addr    : STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
  -- data from compfile
  signal comp_data    : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
    
  -- apb bus address --
  signal ipaddr       : STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
  -- apb device select --
  signal ipselmaccsr  : STD_LOGIC;
  -- apb device enable --
  signal ipenable     : STD_LOGIC;
  -- apb transfer direction --
  signal ipwrite      : STD_LOGIC;
  -- apb write data --
  signal ipwdata      : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);  
  
begin
  
  ---------------------------------------------------------------------
  -- sample generator
  ---------------------------------------------------------------------
  sample_proc:
    process
  begin
    loop
      wait on pclk until pclk='1' and presetn='1';
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
  
  -------------------------------------------------------------------
  -- STIMFILE reader
  -------------------------------------------------------------------
  stimread_proc:
    process
    variable char           : CHARACTER;
    variable stim_cmd_v     : INTEGER;
    variable stim_cycles_v  : INTEGER;
    variable stim_eob_v     : STD_LOGIC;
    variable stim_addr_v    : STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
    variable stim_data_v    : STD_LOGIC_VECTOR(31 downto 0);
    variable stim_num       : INTEGER := 0;
    variable stim_row       : LINE;
    file     stim           : TEXT is in TESTPATH & "/" &  TESTNAME & "/" & STIMFILE;
    
  begin
    stimtrig <= '0';
    wait on pclk until pclk='1' and presetn='1';
    
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
      
      if stim_row'length/=0 then
        
        if stim_row(stim_row'left)/='/' then
          
          READ(stim_row,  stim_cmd_v);
          
          case stim_cmd_v is
            ---------------------------------------
            when CMD_READ =>
            ---------------------------------------
            HREAD(stim_row, stim_addr_v);
            
            ---------------------------------------
            when CMD_WRITE =>
            ---------------------------------------
            HREAD(stim_row, stim_addr_v);
            HREAD(stim_row, stim_data_v);            
            
            ---------------------------------------
            when CMD_WAIT =>
            ---------------------------------------
            READ(stim_row, stim_cycles_v);
            
            ---------------------------------------
            when others =>
            ---------------------------------------
            
          end case;
          
          
          case APBDATAWIDTH is
            ---------------------------------------
            when 32 =>
            ---------------------------------------
            stim_cmd <= stim_cmd_v;
            stim_addr <= stim_addr_v;
            stim_data <= stim_data_v;
            stim_cycles <= stim_cycles_v;
            stimtrig <= not stimtrig;
            wait on stimack;
            
            ---------------------------------------
            when 16 =>
            ---------------------------------------
            if stim_cmd_v = 0 then
              -- wait commmand --
              stim_cmd      <= stim_cmd_v;
              stim_cycles   <= stim_cycles_v;
              stimtrig      <= not stimtrig;
              wait on stimack;
            else
              -- read/write command --
              stim_cmd <= stim_cmd_v;
              
              -- 1st word
              stim_addr <= stim_addr_v+0;
              stim_data <= stim_data_v(15 downto 0);
              stimtrig <= not stimtrig;
              wait on stimack;
              
              -- 2nd word
              stim_addr <= stim_addr_v+2;
              stim_data <= stim_data_v(31 downto 16);
              stimtrig <= not stimtrig;
              wait on stimack;
              
            end if;
            
            ---------------------------------------
            when 8 =>
            ---------------------------------------
            if stim_cmd_v = 0 then
              -- wait commmand --
              stim_cmd      <= stim_cmd_v;
              stim_cycles   <= stim_cycles_v;
              stimtrig      <= not stimtrig;
              wait on stimack;
            else
              -- read/write command --
              stim_cmd <= stim_cmd_v;
              
              -- 1st byte
              stim_addr <= stim_addr_v+0;
              stim_data <= stim_data_v(7 downto 0);
              stimtrig <= not stimtrig;
              wait on stimack;
              
              -- 2nd byte
              stim_addr <= stim_addr_v+1;
              stim_data <= stim_data_v(15 downto 8);
              stimtrig <= not stimtrig;
              wait on stimack;
              
              -- 3rd byte
              stim_addr <= stim_addr_v+2;
              stim_data <= stim_data_v(23 downto 16);
              stimtrig <= not stimtrig;
              wait on stimack;
              
              -- 4th byte
              stim_addr <= stim_addr_v+3;
              stim_data <= stim_data_v(31 downto 24);
              stimtrig <= not stimtrig;
              wait on stimack;
              
            end if;
            
            ---------------------------------------
            when others => -- unsupported --
            ---------------------------------------
            assert false report "Unsupported CSRWIDTH size" severity ERROR;
            wait;
            
          end case;
          
        end if;
      end if;
    end loop;
    wait;
    
    
  end process; -- stimread_proc
  
  -------------------------------------------------------------------
  -- stimulator
  -------------------------------------------------------------------
  stimulator_proc:
    process
  begin
    stimack     <= '0';
    
    ipselmaccsr <= '0';
    ipwrite     <= '0';
    ipenable    <= '0';
    ipaddr      <= (others => '1');
    ipwdata     <= (others => '1');
    
    wait on pclk until pclk='1' and presetn='0';
    
    loop
      
      wait on stimtrig;
      
      case stim_cmd is
        
        ---------------------------------------
        when CMD_WAIT =>
        ---------------------------------------
        wait for stim_cycles * CLK_PERIOD;
        
        ---------------------------------------
        when CMD_READ =>
        ---------------------------------------
        wait on sample1;
        ipaddr      <= stim_addr, (others=>'1') after 2*CLK_PERIOD;
        ipwrite     <= '0';
        ipselmaccsr <= '1', '0' after 2*CLK_PERIOD;
        ipenable    <= '0', '1' after CLK_PERIOD, '0' after 2*CLK_PERIOD;
        
        wait on sample1;
        
        ---------------------------------------
        when CMD_WRITE =>
        ---------------------------------------
        wait on sample1;
        ipaddr      <= stim_addr, (others=>'1') after 2*CLK_PERIOD;
        ipwdata     <= stim_data, (others=>'1') after 2*CLK_PERIOD;
        ipwrite     <= '1';
        ipselmaccsr <= '1', '0' after 2*CLK_PERIOD;
        ipenable    <= '0', '1' after CLK_PERIOD, '0' after 2*CLK_PERIOD;
        
        wait on sample1;
        
        ---------------------------------------
        when others =>
        ---------------------------------------
      end case;
      stimack <= not stimack;
    end loop;
    wait;
  end process; -- stimulator_proc
  
  -----------------------------------------------------------------------
  -- APB select MAC CSR
  -----------------------------------------------------------------------
  pselmaccsr_drv:
  pselmaccsr <= ipselmaccsr;
  
  -----------------------------------------------------------------------
  -- APB write / read
  -----------------------------------------------------------------------
  pwrite_drv:
  pwrite <= ipwrite;
  
  -----------------------------------------------------------------------
  -- APB write data
  -----------------------------------------------------------------------
  pwdata_drv:
  pwdata <= ipwdata;
  
  -----------------------------------------------------------------------
  -- APB enable
  -----------------------------------------------------------------------
  penable_drv:
  penable <= ipenable;
  
  -----------------------------------------------------------------------
  -- APB address
  -----------------------------------------------------------------------
  pwaddr_drv:
  paddr <= ipaddr;
  
  
  --=================================================================--
  -- Compfile reader
  --=================================================================--
  
  compfile_reader: 
    if MODE=2 generate
    
    -------------------------------------------------------------------
    -- COMPFILE reader
    -------------------------------------------------------------------
    compread_proc:
      process
      variable comp_cmd_v     : INTEGER;
      variable comp_cycles_v  : INTEGER;
      variable comp_eob_v     : STD_LOGIC;
      variable comp_addr_v    : STD_LOGIC_VECTOR(APBADDRESSWIDTH-1 downto 0);
      variable comp_data_v    : STD_LOGIC_VECTOR(APBDATAWIDTH-1 downto 0);
      variable comp_num       : INTEGER := 0;
      variable comp_row       : LINE;
      file     comp           : TEXT is in TESTPATH & "/" & TESTNAME & "/" & COMPFILE;
      
    begin
      eofcomp <= '0';
      wait on pclk until pclk='1' and presetn='1';
      
      while not ENDFILE(comp) loop
        
        READLINE(comp, comp_row);
        comp_num := comp_num+1;
        while not ENDFILE(comp) loop
          if comp_row'length/=0 then
            if comp_row(comp_row'left)/='/' then
              exit;
            end if;
          end if;
          READLINE(comp, comp_row);
          comp_num := comp_num+1;
        end loop;
        if ENDFILE(comp) then
          eofcomp <= '1';
        end if;
        
        READ(comp_row,  comp_cmd_v);
        if comp_cmd_v=CMD_READ or comp_cmd_v=CMD_WRITE then
          HREAD(comp_row, comp_addr_v);
          HREAD(comp_row, comp_data_v);
          comp_cmd  <= comp_cmd_v;
          comp_addr <= comp_addr_v;
          
          comp_data <= comp_data_v;
          wait on comptrig;
        end if;
      end loop;
      wait;
    end process; -- compread_proc
    
    -------------------------------------------------------------------
    -- comparator
    -------------------------------------------------------------------
    comparator_proc:
      process
      variable errors    : INTEGER := 0;
      variable diff_row  : LINE;
      file     diff      : TEXT is out TESTPATH & "/" &  TESTNAME & "/" & DIFFFILE;
    begin
      
      WRITE(diff_row, STRING'(" APB interface checking: "));
      WRITELINE(diff, diff_row);
      WRITELINE(diff, diff_row);
      WRITE(diff_row, STRING'(" Waiting for signals..."));
      WRITELINE(diff, diff_row);
      
      comptrig <= '0';
      wait on pclk until pclk='1' and presetn='0';
      WRITE(diff_row, STRING'(" OK. "));
      WRITELINE(diff, diff_row);
      WRITELINE(diff, diff_row);
      WRITE(diff_row, STRING'(" ----------------------------------------------------------------------- "));
      WRITELINE(diff, diff_row);
      
      WRITE(diff_row, now, RIGHT, 10);
      WRITE(diff_row, STRING'(" : Note:   comparision process started "));
      WRITELINE(diff, diff_row);
      
      while eofcomp='0' loop
        
        wait on sample2 until ipselmaccsr='1' and ipenable='1';
        
        if (ipwrite='1' and comp_cmd/=CMD_WRITE) or (ipwrite='0' and comp_cmd/=CMD_READ) then
          errors := errors+1;
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" : Error:  operation code is "));
          if ipwrite='1' then
            WRITE(diff_row, CMD_WRITE);
          else
            WRITE(diff_row, CMD_READ);
          end if;
          WRITE(diff_row, STRING'(" but expected is "));
          WRITE(diff_row, comp_cmd);
          WRITELINE(diff, diff_row);
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" - APB monitor : operation code is "));
          if ipwrite='1' then
            WRITE(diff_row, CMD_READ);
          else
            WRITE(diff_row, CMD_WRITE);
          end if;
          WRITE(diff_row, STRING'(" but expected is "));
          WRITE(diff_row, comp_cmd);
          assert false report diff_row.all severity note;
          DEALLOCATE(diff_row);
        end if;
        
        if comp_addr/=ipaddr then
          errors := errors+1;
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" : Error:  paddr is "));
          HWRITE(diff_row, ipaddr);
          WRITE(diff_row, STRING'(" but expected is "));
          HWRITE(diff_row, comp_addr);
          WRITELINE(diff, diff_row);
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" - APB monitor :  paddr is "));
          HWRITE(diff_row, ipaddr);
          WRITE(diff_row, STRING'(" but expected is "));
          HWRITE(diff_row, comp_addr);
          assert false report diff_row.all severity note;
          DEALLOCATE(diff_row);
        end if;
        
        if ipwrite='1' and comp_data/=ipwdata then
          errors := errors+1;
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" : Error:  pwdata is "));
          HWRITE(diff_row, ipwdata);
          WRITE(diff_row, STRING'(" but expected is "));
          HWRITE(diff_row, comp_data);
          WRITELINE(diff, diff_row);
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" - APB monitor :  pwdata is "));
          HWRITE(diff_row, ipwdata);
          WRITE(diff_row, STRING'(" but expected is "));
          HWRITE(diff_row, comp_data);
          assert false report diff_row.all severity note;
          DEALLOCATE(diff_row);
        end if;
        
        if ipwrite='0' and comp_data/=prdata then
          errors := errors+1;
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" : Error:  prdata is "));
          HWRITE(diff_row, prdata);
          WRITE(diff_row, STRING'(" but expected is "));
          HWRITE(diff_row, comp_data);
          WRITELINE(diff, diff_row);
          WRITE(diff_row, now , RIGHT, 10);
          WRITE(diff_row, STRING'(" - APB monitor :  prdata is "));
          HWRITE(diff_row, prdata);
          WRITE(diff_row, STRING'(" but expected is "));
          HWRITE(diff_row, comp_data);
          assert false report diff_row.all severity note;
          DEALLOCATE(diff_row);
        end if;
        comptrig <= not comptrig;
      end loop;
      
      
      WRITE(diff_row, now, RIGHT, 10);
      WRITE(diff_row, STRING'(" : Note:   end of comapre file detected."));
      WRITELINE( diff, diff_row);
      
      WRITE(diff_row, now, RIGHT, 10);
      WRITE(diff_row, STRING'(" : Note:   comparision process stopped."));
      WRITELINE( diff, diff_row);
      
      WRITE(diff_row, STRING'(" ----------------------------------------------------------------------- "));
      WRITELINE(diff, diff_row);
      WRITELINE(diff, diff_row);
      
      
      if errors=0 then
        assert false
        report "Test " & TESTNAME & " csrcmd passed."
        severity note;
        WRITE(diff_row, STRING'("Test passed."));
        WRITELINE(diff, diff_row);
      else
        assert false
        report "Test " & TESTNAME &
        " csrcmd failed. Differences are in the file " &
        TESTPATH & TESTNAME & "/" & DIFFFILE
        severity note;
        WRITE(diff_row, STRING'("Test failed - "));
        WRITE(diff_row, errors);
        WRITE(diff_row, STRING'(" difference(s) detected"));
        WRITELINE(diff, diff_row);
      end if;
      wait;
    end process; -- comparator_proc
  end generate; -- comparator
  
  
  
  
  --=================================================================--
  -- comp file writer
  --=================================================================--
  
  compfile_writer:
    if MODE=1 generate
    
    -------------------------------------------------------------------
    -- compfile writer
    -------------------------------------------------------------------
    writer_proc:
      process
      variable ebe       : STD_LOGIC_VECTOR(3 downto 0);
      variable writer_row  : LINE;
      file     writer      : TEXT is out TESTPATH & "/" & TESTNAME & "/" & COMPFILE;
      
    begin
      
      WRITE(writer_row, STRING'("// APB operation monitor: "));
      WRITELINE(writer, writer_row);
      WRITE(writer_row, STRING'("//"));
      WRITELINE(writer, writer_row);
      wait on pclk until pclk='1' and presetn='1';
      loop
        wait on sample2;
        
        if ipselmaccsr='1' and ipenable='1' then
          -- compare operation --
          if ipwrite='0' then
            WRITE(writer_row, CMD_READ);
            WRITE(writer_row, STRING'("  "));
            HWRITE(writer_row, ipaddr);
            WRITE(writer_row, STRING'("  "));
            HWRITE(writer_row, prdata);
            WRITE(writer_row, STRING'("  // read"));
          else
            WRITE(writer_row, CMD_WRITE);
            WRITE(writer_row, STRING'("  "));
            HWRITE(writer_row, ipaddr);
            WRITE(writer_row, STRING'("  "));
            HWRITE(writer_row, ipwdata);
            WRITE(writer_row, STRING'("  // write"));
          end if;
          WRITELINE(writer, writer_row);
        end if;
        
      end loop;
    end process; -- writer_proc
  end generate; -- compfile_writer
  
  
end SIM;
--*******************************************************************--
