--*******************************************************************--
-- Copyright (c) 2001-2004  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix Ltd. immediately that you   --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : linkmon.vhd
-- File contents        : Entity LINKMON
--                        Architecture SIM of LINKMON
--
-- Purpose              : GMII/MII interface monitor
--
-- Destination library  : MAC_1G_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--                        IEEE.STD_LOGIC_TEXTIO
--                        STD.TEXTIO
--
-- Design Engineer      : T.K.
-- Quality Engineer     : M.B.
-- Version              : 2.02E00
-- Last modification    : 2004-08-16
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use STD.TEXTIO.all;
  use IEEE.STD_LOGIC_TEXTIO.all;


entity LINKMON is
  generic (
      MODE       : INTEGER := 0; -- Comparator mode
                                 -- 0 - no occurrence
                                 -- 1 - the COMPFILE writer
                                 -- 2 - vectors comparator
      -- clock period
      CLK_PERIOD : TIME    := 40 ns;
      -- file with compare vectors
      COMPFILE   : STRING  := "linkcomp.txt";
      -- file with differences
      DIFFFILE   : STRING  := "linkdiff.txt";
      -- file with stimulus vectors
      STIMFILE   : STRING  := "linkstim.txt";
      -- test name
      TESTNAME   : STRING  := "default";
      -- path to the filename
      TESTPATH   : STRING  := "tests"
  );
  port(
      -- mii clock
      clk       : in  STD_LOGIC;
      -- reset
      rst       : in  STD_LOGIC;
      -- gigabit mode selection
      gb        : in  STD_LOGIC;
      -- transmit enable
      txen      : in  STD_LOGIC;
      -- transmit error
      txer      : in  STD_LOGIC;
      -- transmit data
      txd       : in  STD_LOGIC_VECTOR(7 downto 0);
      -- collision detection
      col       : out STD_LOGIC;
      -- carrier sense
      crs       : out STD_LOGIC;
      -- receive data valid
      rxdv      : out STD_LOGIC;
      -- receive error
      rxer      : out STD_LOGIC;
      -- receive data
      rxd       : out STD_LOGIC_VECTOR(7 downto 0)
  );
end LINKMON;


--*******************************************************************--
architecture SIM of LINKMON is

  -- reset registered for mii domain
  signal rstmii    : STD_LOGIC;
  -- sample generator #1
  signal sample1   : STD_LOGIC; 
  -- sample generator #2
  signal sample2   : STD_LOGIC;
  -- monitor states
  type ST is (
                 ST_IDLE,
                 ST_PRE,
                 ST_SFD,
                 ST_DEST,
                 ST_SOURCE,
                 ST_LENGTH,
                 ST_INFO,
                 ST_EXT,
                 ST_END
               );
  
  -- comments
  constant ST_IDLE_STR   : STRING := "  IDLE";
  constant ST_PRE_STR    : STRING := "  PREAMBLE";
  constant ST_SFD_STR    : STRING := "  SFD";
  constant ST_DEST_STR   : STRING := "  DEST";
  constant ST_SOURCE_STR : STRING := "  SOURCE";
  constant ST_LENGTH_STR : STRING := "  LENGTH";
  constant ST_INFO_STR   : STRING := "  INFO";
  constant ST_EXT_STR    : STRING := "  EXTENSION";
  constant ST_END_STR    : STRING := "               END";
  
  -- hold time
  constant hold       : TIME := 1 ns;  
  -- setup time
  constant setup      : TIME := CLK_PERIOD - 1 ns;
  
  -- state of transmit mii
  signal state    : ST;
  -- frame on transmit mii
  signal frame    : STD_LOGIC;
  -- all nibble/byte counter
  signal acnt     : INTEGER;
  -- field counter
  signal fcnt     : INTEGER;
  -- data counter
  signal dcnt     : INTEGER;
  -- interframe space counter
  signal ifs      : INTEGER;
  
  -- crc remainder of the frame
  signal vcrc  : STD_LOGIC_VECTOR(31 downto 0);
  
  signal vtime     : INTEGER;
  signal vtxen     : STD_LOGIC;
  signal vtxer     : STD_LOGIC;
  signal vcol      : STD_LOGIC;
  signal vcrs      : STD_LOGIC;
  signal vtxd      : STD_LOGIC_VECTOR(7 downto 0);
  
  signal comp_time : INTEGER;
  signal comp_txen : STD_LOGIC;
  signal comp_txer : STD_LOGIC;
  signal comp_txd  : STD_LOGIC_VECTOR(7 downto 0);
  
  -- comparator aacknowledge
  signal compack   : STD_LOGIC;
  -- compfile end
  signal compend   : STD_LOGIC;
  -- read comparator
  signal read_comp : STD_LOGIC;
 
begin

  ---------------------------------------------------------------------
  -- reset registered for mii domain
  ---------------------------------------------------------------------
  rstmii_reg_proc:
  process(clk)
  begin
    if clk'event and clk='1' then
      -- synchronous reset ----------------------
      if rst='1' then
        rstmii <= '0';
      else
        rstmii <= rst;
      end if;
    end if;
  end process; -- rstmii_reg_proc

  ---------------------------------------------------------------------
  -- sample generator
  ---------------------------------------------------------------------
  sample_proc:
  process
  begin
    loop
      wait on clk until clk='1' and rstmii='0';
      if sample1='U' then
        sample1 <= '0';
      else
        sample1 <= not sample1 after hold;
      end if;
      if sample2='U' then
        sample2 <= '0';
      else
        sample2 <= not sample2 after setup;
      end if;
    end loop;
  end process; -- sample_proc
  
  ---------------------------------------------------------------------
  -- mii state monitor
  ---------------------------------------------------------------------
  monitor_proc:
  process
    -- actual frame state
    variable temps : ST;
    variable xor0  : STD_LOGIC;
    variable xor1  : STD_LOGIC;
    variable xor2  : STD_LOGIC;
    variable xor4  : STD_LOGIC;
    variable xor5  : STD_LOGIC;
    variable xor7  : STD_LOGIC;
    variable xor8  : STD_LOGIC;
    variable xor10 : STD_LOGIC;
    variable xor11 : STD_LOGIC;
    variable xor12 : STD_LOGIC;
    variable xor16 : STD_LOGIC;
    variable xor22 : STD_LOGIC;
    variable xor23 : STD_LOGIC;
    variable xor26 : STD_LOGIC;
    variable crc   : STD_LOGIC_VECTOR(31 downto 0);
  begin
    ifs <= 0;
    loop
      wait on sample2;
      vtxd  <= txd;
      vtxen <= txen;
      vtxer <= txer;
      
      case state is
        ---------------------------------------
        when ST_IDLE =>
        ---------------------------------------
          if txen='1' then
            if (gb='0' and txd(3 downto 0)="0101") or
               (gb='1' and txd="01010101")
            then
              temps := ST_PRE;
            end if;
          end if;
          
        ---------------------------------------
        when ST_PRE =>
        ---------------------------------------
          if txen='1' then
            if (gb='0' and txd(3 downto 0)="1101") or
               (gb='1' and txd="11010101")
            then
              temps := ST_SFD;
            end if;
          else
            temps := ST_IDLE;
          end if;
          
        ---------------------------------------
        when ST_SFD =>
        ---------------------------------------
          if txen='1' then
            temps := ST_DEST;
          else
            temps := ST_END;
          end if;
          
        ---------------------------------------
        when ST_DEST =>
        ---------------------------------------
          if txen='1' then
            if (gb='0' and fcnt=11) or
               (gb='1' and fcnt=5)
            then
              temps := ST_SOURCE;
            end if;
          else
            temps := ST_END;
          end if;
          
        ---------------------------------------
        when ST_SOURCE =>
        ---------------------------------------
          if txen='1' then
            if (gb='0' and fcnt=11) or
               (gb='1' and fcnt=5)
            then
              temps := ST_LENGTH;
            end if;
          else
            temps := ST_END;
          end if;
        
        ---------------------------------------
        when ST_LENGTH =>
        ---------------------------------------
          if txen='1' then
            if (gb='0' and fcnt=3) or
               (gb='1' and fcnt=1)
            then
              temps := ST_INFO;
            end if;
          else
            temps := ST_END;
          end if;
        
        ---------------------------------------
        when ST_INFO =>
        ---------------------------------------
          if txen='0' then
            temps := ST_END;
          end if;
          
        ---------------------------------------
        when others => -- ST_END
        ---------------------------------------
          temps := ST_IDLE;
      end case;
      state <= temps;
      
      -- crc remainder
      if temps=ST_DEST or temps=ST_SOURCE or
         temps=ST_LENGTH or temps=ST_INFO
      then
        -- gigabit ethernet mode
        if gb='1' then
          for i in 0 to 7 loop
            xor0  := crc(31) xor txd(i);
            xor1  := xor0  xor crc(0);
            xor2  := xor0  xor crc(1);
            xor4  := xor0  xor crc(3);
            xor5  := xor0  xor crc(4);
            xor7  := xor0  xor crc(6);
            xor8  := xor0  xor crc(7);
            xor10 := xor0  xor crc(9);
            xor11 := xor0  xor crc(10);
            xor12 := xor0  xor crc(11);
            xor16 := xor0  xor crc(15);
            xor22 := xor0  xor crc(21);
            xor23 := xor0  xor crc(22);
            xor26 := xor0  xor crc(25);
            crc := crc(30 downto 26) & xor26 & 
                   crc(24 downto 23) & xor23 & xor22 &
                   crc(20 downto 16) & xor16 & 
                   crc(14 downto 12) & xor12 & xor11 & 
                   xor10 & crc(8) & xor8 & xor7 & crc(5) &
                   xor5 & xor4 & crc(2) & xor2 & xor1 & xor0;
          end loop;
        -- fast ethernet mode
        else
          for i in 0 to 3 loop
            xor0  := crc(31) xor txd(i);
            xor1  := xor0  xor crc(0);
            xor2  := xor0  xor crc(1);
            xor4  := xor0  xor crc(3);
            xor5  := xor0  xor crc(4);
            xor7  := xor0  xor crc(6);
            xor8  := xor0  xor crc(7);
            xor10 := xor0  xor crc(9);
            xor11 := xor0  xor crc(10);
            xor12 := xor0  xor crc(11);
            xor16 := xor0  xor crc(15);
            xor22 := xor0  xor crc(21);
            xor23 := xor0  xor crc(22);
            xor26 := xor0  xor crc(25);
            crc := crc(30 downto 26) & xor26 & 
                   crc(24 downto 23) & xor23 & xor22 &
                   crc(20 downto 16) & xor16 & 
                   crc(14 downto 12) & xor12 & xor11 & 
                   xor10 & crc(8) & xor8 & xor7 & crc(5) &
                   xor5 & xor4 & crc(2) & xor2 & xor1 & xor0;
          end loop;
        end if;
      elsif temps=ST_IDLE then
        crc := (others=>'1');
      end if;
      for i in 31 downto 0 loop
        vcrc(i) <= crc(i);
      end loop;
      
      -- interframe space
      if state=ST_END then
        ifs <= 0;
      elsif temps=ST_IDLE then
        ifs <= ifs + 1;
      end if;
      
      -- frame in progress
      if temps=ST_IDLE then
        frame <= '0';
      else
        frame <= '1';
      end if;
      
      -- all nibble/byte counter
      if temps=ST_IDLE then
        acnt <= 0;
      else
        acnt <= acnt + 1;
      end if;
      
      -- field counter
      if temps/=state then
        fcnt <= 0;
      else
        fcnt <= fcnt + 1;
      end if;
      
      -- data counter
      if temps=ST_IDLE then
        dcnt <= 0;
      elsif temps=ST_DEST or temps=ST_SOURCE or
            temps=ST_LENGTH or temps=ST_INFO
      then
        dcnt <= dcnt + 1;
      end if;
    end loop;
  end process; -- monitor_proc


  ---------------------------------------------------------------------
  --                     Link monitor writer                         --
  ---------------------------------------------------------------------
  writer_generate:
  if MODE=1 generate
    
    -------------------------------------------------------------------
    writer_proc:
    -------------------------------------------------------------------
    process
      variable writer_row : LINE;
      file     writer     : TEXT is out TESTPATH & "/" &
                                        TESTNAME & "/" &
                                        COMPFILE;
    begin
      WRITE(writer_row, STRING'("// Auto generated mii link monitor file"));
      WRITELINE(writer, writer_row);
      WRITE(writer_row, STRING'("// -------------------------------------------------------------------"));
      WRITELINE(writer, writer_row);
      WRITE(writer_row, STRING'("//      time       txd txen txer col crs    comments"));
      WRITELINE(writer, writer_row);
      WRITE(writer_row, STRING'("// -------------------------------------------------------------------"));
      WRITELINE(writer, writer_row);
      loop
        wait on clk until clk='1' and frame='1';
        WRITE(writer_row, now / ns, right, 12);
        WRITE(writer_row, vtxd, right, 10);
        WRITE(writer_row, vtxen, right, 5);
        WRITE(writer_row, vtxer, right, 5);
        WRITE(writer_row, vcol, right, 4);
        WRITE(writer_row, vcrs, right, 4);
        WRITE(writer_row, STRING'("    // "));
        if state /= ST_END then
          WRITE(writer_row, acnt, right, 6);
          WRITE(writer_row, fcnt, right, 6);
        end if;
        case state is
          -----------------------------------------------
          when ST_PRE    =>
          -----------------------------------------------
            WRITE(writer_row, ST_PRE_STR);
            
          -----------------------------------------------
          when ST_SFD    =>
          -----------------------------------------------
            WRITE(writer_row, ST_SFD_STR);
            
          -----------------------------------------------
          when ST_DEST   =>
          -----------------------------------------------
            WRITE(writer_row, ST_DEST_STR);
            
          -----------------------------------------------
          when ST_SOURCE =>
          -----------------------------------------------
            WRITE(writer_row, ST_SOURCE_STR);
          
          -----------------------------------------------
          when ST_LENGTH =>
          -----------------------------------------------
            WRITE(writer_row, ST_LENGTH_STR);
          
          -----------------------------------------------
          when ST_INFO   =>
          -----------------------------------------------
            WRITE(writer_row, ST_INFO_STR);
          
          -----------------------------------------------
          when ST_END    =>
          -----------------------------------------------
            WRITE(writer_row, ST_END_STR);
            WRITELINE(writer, writer_row);
            WRITELINE(writer, writer_row);
            WRITE(writer_row, STRING'(" // ifs          : "));
            WRITE(writer_row, ifs, right, 6);
            WRITELINE(writer, writer_row);
            WRITE(writer_row, STRING'(" // data bytes   : "));
            WRITE(writer_row, dcnt, right, 6);
            WRITELINE(writer, writer_row);
            if vcrc="11000111000001001101110101111011" then
              WRITE(writer_row, STRING'(" // crc valid "));
            else
              WRITE(writer_row, STRING'(" // crc invalid "));
            end if;
            WRITELINE(writer, writer_row);
            
          -----------------------------------------------
          when others    =>
          -----------------------------------------------
            WRITE(writer_row, ST_IDLE_STR);
        end case;
        WRITELINE(writer, writer_row);
      end loop;
    end process; -- writer_proc
  end generate; -- writer_generate


  ---------------------------------------------------------------------
  --                          Comparator                             --
  ---------------------------------------------------------------------
  mode2_generate:
  if MODE=2 generate

    -------------------------------------------------------------------
    -- Comparator
    -------------------------------------------------------------------
    comp_proc:
    process
      variable errors   : INTEGER := 0;
      variable diff_row : LINE;
      file     diff     : TEXT is out TESTPATH & "/" & TESTNAME &
                                                 "/" & DIFFFILE;
    begin
      compack <= '0';
      wait on sample2 until rst='0';
      while compend='0' loop
        if txen='1' then
          if txd/=comp_txd then
            errors := errors+1;
            WRITE(diff_row, STRING'("TIME: "));
            WRITE(diff_row, now);
            WRITE(diff_row, STRING'(" txd is: "));
            WRITE(diff_row, txd);
            WRITE(diff_row, STRING'(" but expected is: "));
            WRITE(diff_row, comp_txd);
            WRITELINE(diff, diff_row);
          end if;
          compack <= not compack;
        end if;
        wait on sample2;
      end loop;
      
      WRITE(diff_row, now);
      WRITE(diff_row, STRING'(" : End of the test detected."));
      WRITELINE(diff, diff_row);
      
      if errors=0 then
         assert false
            report "Test " & TESTNAME & " passed."
            severity note;
         WRITE(diff_row, STRING'("Test passed."));
         WRITELINE(diff, diff_row);
      else
         assert false
            report "Test " & TESTNAME &
            " failed. Differences are in the file " &
            TESTPATH & TESTNAME & "/" & DIFFFILE
            severity note;
         WRITE(diff_row, STRING'("Test failed."));
         WRITELINE(diff, diff_row);
         WRITE(diff_row, errors);
         WRITE(diff_row, STRING'(" difference(s) detected"));
         WRITELINE(diff, diff_row);
      end if;
      wait;
    end process; -- comp_proc
  
    -------------------------------------------------------------------
    -- Compfile reader
    -------------------------------------------------------------------
    compfile_proc:
    process
      variable char     : CHARACTER;
      variable comp_num : INTEGER := 0;
      variable comp_row : LINE;
      variable comp_t   : TIME;
      variable comp_i   : INTEGER;
      variable comp_l1  : STD_LOGIC;
      variable comp_l2  : STD_LOGIC;
      variable comp_v   : STD_LOGIC_VECTOR(7 downto 0);
      file     comp     : TEXT is in TESTPATH & "/" & TESTNAME & 
                                               "/" & COMPFILE;
    begin
      compend <= '0';
      wait on clk until rst='0';
      
      while not ENDFILE(comp) loop

        READLINE(comp, comp_row);
        comp_num := comp_num+1;
        -- process lines longer than 60 chars
        if comp_row'length > 60 then
        
          -- check if it is commented line
          while comp_row'length/=0 loop
            if comp_row(comp_row'left)='/' then
              exit;
            elsif comp_row(comp_row'left)/=' ' then
              exit;
            end if;
            READ(comp_row, char);
          end loop;
          
          -- process only uncommented and non empty line
          if comp_row'length/=0 then
            if comp_row(comp_row'left)/='/' then
              READ(comp_row, comp_i);

              comp_time <= comp_i;
              comp_t := comp_i * ns;
              comp_time <= comp_i;
              READ(comp_row, comp_v);
              comp_txd <= comp_v;
              READ(comp_row, comp_l1);
              comp_txen <= comp_l1;
              READ(comp_row, comp_l2);
              comp_txer <= comp_l2;
              if comp_l1='1' or comp_l2='1' then
                wait on compack;
              end if;
            end if;
          end if;
        end if;
      end loop;
      compend <= '1';
      wait;
    end process; --compfile_proc
  end generate; -- mode2_generate
  

  ---------------------------------------------------------------------
  -- Stimfile reader
  ---------------------------------------------------------------------
  stimfile_proc:
  process
    variable char     : CHARACTER;
    variable stim_num : INTEGER := 0;
    variable stim_row : LINE;
    variable stim_t   : TIME;
    variable stim_i   : INTEGER;
    variable stim_l   : STD_LOGIC;
    variable stim_v   : STD_LOGIC_VECTOR(7 downto 0);
    file     stim     : TEXT is in TESTPATH & "/" &
                                   TESTNAME & "/" &
                                   STIMFILE;
  begin

    while not ENDFILE(stim) loop
      READLINE(stim, stim_row);
      
      -- check if it is commented line
      while stim_row'length>0 loop
        if stim_row(stim_row'left)='/' then
          exit;
        elsif stim_row(stim_row'left)/=' ' then
          exit;
        end if;
        READ(stim_row, char);	
      end loop;
      
      -- process only uncommented and non empty line
      if stim_row'length>10 then
        if stim_row(stim_row'left)/='/' then
          READ(stim_row, stim_i);
          stim_t := stim_i * ns;
          if now > stim_t then
            assert true
              report "Detected a time in the " &
              TESTNAME & "/" & STIMFILE &
              " that is in the past."
              severity error;
          else
            wait for stim_t-now;
          end if;
          READ(stim_row, stim_v);
          rxd <= stim_v after hold;
          READ(stim_row, stim_l);
          rxdv <= stim_l after hold;
          READ(stim_row, stim_l);
          rxer <= stim_l after hold;
          READ(stim_row, stim_l);
          vcol <= stim_l after hold;
          READ(stim_row, stim_l);
          vcrs <= stim_l after hold;
        end if;
      end if;
    end loop;
    wait;
  end process; -- stimfile_proc
  
  ---------------------------------------------------------------------
  -- carrier sense
  ---------------------------------------------------------------------
  crs_drv:
    crs <= vcrs;
  
  ---------------------------------------------------------------------
  -- collision detect
  ---------------------------------------------------------------------
  col_drv:
    col <= vcol;

end SIM;
--*******************************************************************--
