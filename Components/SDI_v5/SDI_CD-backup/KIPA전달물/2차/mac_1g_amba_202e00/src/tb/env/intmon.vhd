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
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : intmon.vhd
-- File contents        : Entity 
--                        Architecture SIM of INTMON 
--
-- Purpose              : Ethernet interrups monitor
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--                      : IEEE.STD_LOGIC_TEXTIO
--                        STD.TEXTIO
--
-- Design Engineer      : A.B., T.K
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
  use IEEE.STD_LOGIC_TEXTIO.all;


--*******************************************************************--  
entity INTMON is
  generic (
      MODE       : INTEGER := 0;  -- Comparator mode
                                  -- 0 - no occurrence
                                  -- 1 - the COMPFILE writer
                                  -- 2 - vectors comparator
      CLK_PERIOD : TIME    := 40 ns;
      -- File with compare values
      COMPFILE   : STRING  := "intcomp.txt";
      -- File with simulation differences
      DIFFFILE   : STRING  := "intdiff.txt";
      -- Test directory name
      TESTNAME   : STRING  := "default";
      -- Path to the test directory
      TESTPATH   : STRING  := "tests"
  );
  port(
      -- clock
      clk       : in  STD_LOGIC;
      -- interrupt line
      int       : in  STD_LOGIC;
      -- reset
      rst       : in  STD_LOGIC
      );
end INTMON;
--*******************************************************************--

architecture SIM of INTMON is

  
  signal vint     : STD_LOGIC;
  signal int_int  : STD_LOGIC := '0';
  signal comptrig : STD_LOGIC := '0';
  signal compack  : STD_LOGIC := '0';
  signal compend  : STD_LOGIC := '0';
  signal compt    : TIME      := 0 ns;
  constant setup  : TIME      := CLK_PERIOD/10*9;
  constant hold   : TIME      := CLK_PERIOD/10;
  

begin


  ---------------------------------------------------------------------
  --========================Link monitor writer======================--
  ---------------------------------------------------------------------
  mode1_generate:
  if MODE=1 generate   
     
    -------------------------------------------------------------------
    state_monitor:
    -------------------------------------------------------------------
    process(clk)
    begin
      if clk'event and clk='1' then
        if int='1' then
           int_int<='1'; 
        else
           int_int<='0';
        end if;   
      end if;       
    end process; 
  
    -------------------------------------------------------------------
    state_writer:
    -------------------------------------------------------------------
    process
      variable row     : LINE;
      file     compwr  : TEXT is out TESTPATH & "/" & TESTNAME &
                                                "/" & COMPFILE;
    begin
      WRITE(row, STRING'("// Interrupt monitor file"));
      WRITELINE(compwr, row);
      WRITE(row, STRING'("// -------------------------------------------------------------------"));
      WRITELINE(compwr, row);
      WRITE(row, STRING'("//        time   int                                       "));
      WRITELINE(compwr, row);
      WRITE(row, STRING'("// -------------------------------------------------------------------"));
      WRITELINE(compwr, row);
      wait on clk until rst='1';
      loop
         wait on int_int;
         WRITE(row, now/ns, right, 14);
         WRITE(row, STRING'("1"), right, 6);
         WRITELINE(compwr, row); 
         
         wait on int_int;
         WRITE(row, now/ns, right, 14);
         WRITE(row, STRING'("0"), right, 6);
         WRITELINE(compwr, row);    
      end loop;    
    end process; --state_writer
  end generate; --mode1_generate

  ---------------------------------------------------------------------
  --=============================Comparator==========================--
  ---------------------------------------------------------------------
  mode2_generate:
  if MODE=2 generate
  
    -------------------------------------------------------------------
    -- Compfile reader
    -------------------------------------------------------------------
    compfile_proc:
    process
      variable i       : INTEGER;
      variable t       : TIME;
      variable int_val : STD_LOGIC;
      variable char    : CHARACTER;
      variable row     : LINE;
      file     rdfile  : TEXT is in TESTPATH & "/" & TESTNAME & 
                                               "/" & COMPFILE;
    begin
      wait on clk until rst='0';
      while not ENDFILE(rdfile) loop
        READLINE(rdfile, row);
        if row'length<3 then
          next;
        end if;
        if row(1 to 2)="//" then
          next;
        end if;
        READ(row, i);
        compt <= i * ns;
        READ(row, int_val);
        vint <= int_val;
        comptrig <= not comptrig;
        wait on compack;
      end loop;
      compend <= '1';
      comptrig <= not comptrig;
      wait;
    end process; -- compfile_proc
    
    
    -------------------------------------------------------------------
    -- Comparator
    -------------------------------------------------------------------
    comp_proc:
    process
      variable errors  : INTEGER := 0;
      variable row     : LINE;
      file     diff    : TEXT is out TESTPATH & "/" & TESTNAME &
                                                "/" & DIFFFILE;
    begin
      loop
        wait on comptrig;
        if compend='1' then
          exit;
        end if;

        wait on int;
        if int/=vint then
          errors  := errors+1;
          WRITE(row, STRING'("TIME: "));
          WRITE(row, now);
          WRITE(row, STRING'(" int is: "));
          WRITE(row, int);
          WRITE(row, STRING'(" but expected is: "));
          WRITE(row, vint);
          WRITELINE(diff, row);
        end if;
        compack <= not compack;
      end loop;
      
      WRITE(row, now);
      WRITE(row, STRING'(" : End of the intmon test detected."));
      WRITELINE(diff,row);
      
      if errors=0 then
         assert false
            report "Test " & TESTNAME & " intmon passed."
            severity note;
         WRITE(row, STRING'("Test intmon passed."));
         WRITELINE(diff, row);
      else
         assert false
            report "Test " & TESTNAME &
            " intmon failed. Differences are in the file " &
            TESTPATH & TESTNAME & "/" & DIFFFILE
            severity note;
         WRITE(row, STRING'("Test intmon failed."));
         WRITELINE(diff, row);
         WRITE(row, errors);
         WRITE(row, STRING'(" difference(s) detected"));
         WRITELINE(diff, row);
      end if;
      wait;
    end process; -- comp_proc                                            
  end generate; -- mode2_generate
  
end SIM;
--*******************************************************************--