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
-- File name            : csrcmd.vhd
-- File contents        : Entity CSRCMD
--                        Architecture SIM of CSRCMD
--
-- Purpose              : csr interface monitor
--
-- Destination library  : MAC_1G_LIB
-- Dependencies         :
--                        IEEE.STD_LOGIC_1164
--                        STD.TEXTIO
--
-- Design Engineer      : T.K. , L.C.
-- Quality Engineer     : M.B.
-- Version              : 2.02E02
-- Last modification    : 2004-04-07
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;
  use IEEE.STD_LOGIC_UNSIGNED."+";
  use STD.TEXTIO.all;
  use IEEE.STD_LOGIC_TEXTIO.all;


  entity CSRCMD is
    generic(
         MODE       : INTEGER := 0; -- operating mode
                              -- 0 - no occurrence
                              -- 1 - the COMPFILE writer
                              -- 2 - vectors comparator
         CSRWIDTH   : INTEGER := 32;
         CSRDEPTH   : INTEGER := 8;
         STIMFILE   : STRING  := "stim.txt";
         COMPFILE   : STRING  := "comp.txt";
         DIFFFILE   : STRING  := "diff.txt";
         TESTNAME   : STRING  := "default";
         TESTPATH   : STRING  := "tests";
         CLK_PERIOD : TIME    := 40 ns
         );
    port(
       -- clock
       clk        : in  STD_LOGIC;
       -- reset
       rst        : in  STD_LOGIC;
       -- acknowledge input
       csrack     : in  STD_LOGIC;
       -- read data
       csrdatar   : in  STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
       -- request
       csrreq     : out STD_LOGIC;
       -- read/not write
       csrrw      : out STD_LOGIC;
       -- write data
       csrdataw   : out STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
       -- byte enable
       csrbe      : out STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
       -- address
       csraddr    : out STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0)
       );
  end CSRCMD;


--*******************************************************************--
  architecture SIM of CSRCMD is

  -- hold time
    constant hold       : TIME := 1 ns;  
  -- setup time
    constant setup      : TIME := CLK_PERIOD - 1 ns;
  
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
  -- byte enable from stimfile
    signal stim_be      : STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
  -- address from stimfile
    signal stim_addr    : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
  -- data from stimfile
    signal stim_data    : STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);

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
  -- byte enable from compfile
    signal comp_be      : STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
  -- address from compfile
    signal comp_addr    : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
  -- data from compfile
    signal comp_data    : STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);

  -- internal csr request
    signal icsrreq      : STD_LOGIC;
  -- internal csr read/not write
    signal icsrrw       : STD_LOGIC;
  -- internal csr byte enable
    signal icsrbe       : STD_LOGIC_VECTOR(CSRWIDTH/8-1 downto 0);
  -- internal csr write data
    signal icsrdataw    : STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
  -- internal csr write data
	  signal icsraddr     : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
	
  -- debug purpose signal
    signal compare_now  : STD_LOGIC;

  begin

  ---------------------------------------------------------------------
  -- sample generator
  ---------------------------------------------------------------------
  sample_proc:
    process
    begin
      loop
        wait on clk until clk='1' and rst='0';
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

  -------------------------------------------------------------------
  -- STIMFILE reader
  -------------------------------------------------------------------
  stimread_proc:
    process
      variable char           : CHARACTER;
      variable stim_cmd_v     : INTEGER;
      variable stim_cycles_v  : INTEGER;
      variable stim_eob_v     : STD_LOGIC;
      variable stim_be_v      : STD_LOGIC_VECTOR(3 downto 0);
      variable stim_addr_v    : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
      variable stim_data_v    : STD_LOGIC_VECTOR(31 downto 0);
      variable stim_num       : INTEGER := 0;
      variable stim_row       : LINE;
      file     stim           : TEXT is in TESTPATH & "/" &
      TESTNAME & "/" &
      STIMFILE;

    begin
      stimtrig <= '0';
      wait on clk until clk='1' and rst='0';

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

      -- process only uncommented and non empty line
      
      if stim_row'length/=0 then
        
        if stim_row(stim_row'left)/='/' then
          
            READ(stim_row,  stim_cmd_v);

            case stim_cmd_v is
            ---------------------------------------
              when CMD_READ | CMD_WRITE =>
            ---------------------------------------
                 HREAD(stim_row, stim_addr_v);
                 HREAD(stim_row, stim_be_v);
                 HREAD(stim_row, stim_data_v);

            ---------------------------------------
              when CMD_WAIT =>
            ---------------------------------------
                 READ(stim_row, stim_cycles_v);

            ---------------------------------------
              when others =>
            ---------------------------------------

            end case;


            case CSRWIDTH is
            ---------------------------------------
              when 32 =>
            ---------------------------------------
                 stim_cmd <= stim_cmd_v;
                 stim_addr <= stim_addr_v;
                 stim_be <= stim_be_v;
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
                    stim_be <= stim_be_v(1 downto 0);
                    stim_data <= stim_data_v(15 downto 0);
                    stimtrig <= not stimtrig;
                    wait on stimack;

                 -- 2nd word
                    stim_addr <= stim_addr_v+2;
                    stim_be <= stim_be_v(3 downto 2);
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
                    stim_be <= stim_be_v(0 downto 0);
                    stim_data <= stim_data_v(7 downto 0);
                    stimtrig <= not stimtrig;
                    wait on stimack;

                 -- 2nd byte
                    stim_addr <= stim_addr_v+1;
                    stim_be <= stim_be_v(1 downto 1);
                    stim_data <= stim_data_v(15 downto 8);
                    stimtrig <= not stimtrig;
                    wait on stimack;

                 -- 3rd byte
                    stim_addr <= stim_addr_v+2;
                    stim_be <= stim_be_v(2 downto 2);
                    stim_data <= stim_data_v(23 downto 16);
                    stimtrig <= not stimtrig;
                    wait on stimack;

                 -- 4th byte
                    stim_addr <= stim_addr_v+3;
                    stim_be <= stim_be_v(3 downto 3);
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
      stimack <= '0';
      icsrreq <= '0';
      icsrrw <= '1';
      icsrbe <= (others=>'1');
      icsrdataw <= (others=>'1');
      icsraddr <= (others=>'1');
      wait on clk until clk='1' and rst='1';

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
            icsrreq <= '1';
            icsrrw <= '1';
            icsrbe <= stim_be;
            icsraddr <= stim_addr;
            wait on sample2 until csrack='1';
            icsrreq <= '0' after CLK_PERIOD - setup + hold;

        ---------------------------------------
          when CMD_WRITE =>
        ---------------------------------------
            wait on sample1;
            icsrreq <= '1';
            icsrrw <= '0';
            icsrbe <= stim_be;
            icsraddr <= stim_addr;
            icsrdataw <= stim_data;
            wait on sample2 until csrack='1';
            icsrreq <= '0' after CLK_PERIOD - setup + hold;

        ---------------------------------------
          when others =>
        ---------------------------------------
        end case;
        stimack <= not stimack;
      end loop;
      wait;
    end process; -- stimulator_proc

  -----------------------------------------------------------------------
  -- csr request
  -----------------------------------------------------------------------
  csrreq_drv:
    csrreq <= icsrreq;

  -----------------------------------------------------------------------
  -- csr byte enable
  -----------------------------------------------------------------------
  csrbe_drv:
    csrbe <= icsrbe;

  -----------------------------------------------------------------------
  -- csr read/not write
  -----------------------------------------------------------------------
  csrrw_drv:
    csrrw <= icsrrw;

  -----------------------------------------------------------------------
  -- csr write data
  -----------------------------------------------------------------------
  csrdataw_drv:
    csrdataw <= icsrdataw;

  -----------------------------------------------------------------------
  -- csr address
  -----------------------------------------------------------------------
  csraddr_drv:
    csraddr <= icsraddr;


  --=================================================================--
  comparator:
  --=================================================================--
    if MODE=2 generate

    -------------------------------------------------------------------
    -- COMPFILE reader
    -------------------------------------------------------------------
    compread_proc:
      process
        variable comp_cmd_v     : INTEGER;
        variable comp_cycles_v  : INTEGER;
        variable comp_eob_v     : STD_LOGIC;
        variable comp_be_v     : STD_LOGIC_VECTOR(3 downto 0);
        variable comp_addr_v    : STD_LOGIC_VECTOR(CSRDEPTH-1 downto 0);
        variable comp_data_v    : STD_LOGIC_VECTOR(CSRWIDTH-1 downto 0);
        variable comp_num       : INTEGER := 0;
        variable comp_row       : LINE;
        file     comp           : TEXT is in TESTPATH & "/" &
        TESTNAME & "/" &
        COMPFILE;

      begin
        eofcomp <= '0';
        wait on clk until clk='1' and rst='0';

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
            HREAD(comp_row, comp_be_v);
            HREAD(comp_row, comp_data_v);
            comp_cmd  <= comp_cmd_v;
            comp_addr <= comp_addr_v;

            case CSRWIDTH is
              when 32 => comp_be   <= comp_be_v;
              when 16 => comp_be   <= comp_be_v(1 downto 0);
              when 8  => comp_be   <= comp_be_v(0 downto 0);
              when others => comp_be  <= ( others => '0');
            end case;

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
        file     diff      : TEXT is out TESTPATH & "/" &
        TESTNAME & "/" &
        DIFFFILE;
      begin
        
				comptrig <= '0';						 
				compare_now <= '0';
				
				
        wait on clk until clk='1' and rst='1';
        while eofcomp='0' loop
          wait on sample2 until icsrreq='1' and csrack='1';	
					
	--				compare_now <= '1', '0' after 1 ps;
					
          if icsrrw='1' then
            if comp_data/=csrdatar then
              errors := errors+1;
              WRITE(diff_row, now);
              WRITE(diff_row, STRING'(" : csrdatai is "));
							HWRITE(diff_row, csrdatar);									
							WRITE(diff_row, STRING'(" ( @"));
							HWRITE(diff_row, icsraddr);		 
							WRITE(diff_row, STRING'(" )" ));
              WRITE(diff_row, STRING'(" but expected is "));
              HWRITE(diff_row, comp_data);									
							WRITE(diff_row, STRING'(" ( @"));
							HWRITE(diff_row, comp_addr);		 
							WRITE(diff_row, STRING'(" )" )); 
							WRITELINE( diff, diff_row);

              WRITE(diff_row, now);
              WRITE(diff_row, STRING'(" : csrdatai is "));
							HWRITE(diff_row, csrdatar);									
							WRITE(diff_row, STRING'(" ( @"));
							HWRITE(diff_row, icsraddr);		 
							WRITE(diff_row, STRING'(" )" ));
              WRITE(diff_row, STRING'(" but expected is "));
              HWRITE(diff_row, comp_data);									
							WRITE(diff_row, STRING'(" ( @"));
							HWRITE(diff_row, comp_addr);		 
							WRITE(diff_row, STRING'(" )" ));
              assert false report diff_row.all severity note;
              DEALLOCATE(diff_row);
            end if;
            wait on clk until clk='1';
          end if;
          comptrig <= not comptrig;
        end loop;

        WRITE(diff_row, now);
        WRITE(diff_row, STRING'(" : End of the test detected."));
        WRITELINE( diff, diff_row);

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
      end process; -- comparator_proc
    end generate; -- comparator



  --=================================================================--
  compfile_writer:
  --=================================================================--
    if MODE=1 generate

    -------------------------------------------------------------------
    -- compfile writer
    -------------------------------------------------------------------
    writer_proc:
      process
        variable ebe  		 : STD_LOGIC_VECTOR(3 downto 0);
        variable writer_row  : LINE;
        file     writer      : TEXT is out TESTPATH & "/" &
        TESTNAME & "/" &
        COMPFILE;
      begin
        wait on clk until clk='1' and rst='1';
        loop
          wait on sample2;
          if icsrreq='1' and csrack='1' then

            case CSRWIDTH is
              when 32 => ebe := icsrbe;
              when 16 => ebe := "00" & icsrbe;
              when 8  => ebe := "000" & icsrbe;
              when others => ebe := "0000";
            end case;

          -- read operation -----------------------
            if icsrrw='1' then
              WRITE(writer_row, CMD_READ);
              WRITE(writer_row, STRING'("  "));
              HWRITE(writer_row, icsraddr);
              WRITE(writer_row, STRING'("  "));
              HWRITE(writer_row, ebe);
              WRITE(writer_row, STRING'("  "));
              HWRITE(writer_row, csrdatar);
              WRITE(writer_row, STRING'("  // read"));
            -- write operation
            else
              WRITE(writer_row, CMD_WRITE);
              WRITE(writer_row, STRING'("  "));
              HWRITE(writer_row, icsraddr);
              WRITE(writer_row, STRING'("  "));
              HWRITE(writer_row, ebe);
              WRITE(writer_row, STRING'("  "));
              HWRITE(writer_row, icsrdataw);
              WRITE(writer_row, STRING'("  // write"));
            end if;
            WRITELINE(writer, writer_row);
          end if;
        end loop;
      end process; -- writer_proc
    end generate; -- compfile_writer

  end SIM;
--*******************************************************************--
