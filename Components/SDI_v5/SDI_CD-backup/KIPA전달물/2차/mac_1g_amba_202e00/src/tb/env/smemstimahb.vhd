--*******************************************************************--
-- Copyright (c) 2001-2004  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix Ltd. immediately that you   --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC_AHB
-- Project description  : Ethernet Media Access Controller
--
-- File name            : smemstimahb.vhd
-- File contents        : Entity SMEMSTIMAHB
--                        Architecture SIM of SMEMSTIMAHB
--
-- Purpose              : Shared memory model on AHB
--
-- Destination library  : MAC_AHB_LIB
-- Dependencies         :
--                        IEEE.STD_LOGIC_1164
--                        IEEE.STD_LOGIC_ARITH
--                        IEEE.STD_LOGIC_UNSIGNED
--                        STD.TEXTIO
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
use IEEE.STD_LOGIC_TEXTIO.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.CONV_STD_LOGIC_VECTOR;
use IEEE.STD_LOGIC_UNSIGNED.CONV_INTEGER;


entity SMEMSTIMAHB is
	generic(
		DATAWIDTH   : INTEGER := 32;
		ADDRWIDTH   : INTEGER := 32;
		MODE        : INTEGER := 0; -- Comparator mode:
		--                          -- 0 - no occurrence
		--                          -- 1 - stimulator with COMPFILE diff_file
		--                          -- 2 - stimulator with comparator
		STIMFILE    : STRING  := "smemstim.txt";
		COMPFILE    : STRING  := "ahbcomp.txt";
		DIFFFILE    : STRING  := "ahbdiff.txt";
		TESTNAME    : STRING  := "default";
		TESTPATH    : STRING  := "tests";
		CLK_PERIOD  : TIME    := 40 ns
		);
	port(
		--       AHB interface 
		-- Bus clock
		hclk          : in  STD_LOGIC;
		-- Reset
		hresetn       : in  STD_LOGIC;
		-- Select
		hsel          : in STD_LOGIC;
		-- Transfer direction
		hwr            : in STD_LOGIC;
		-- Locked transfers
		hmastlock     : in STD_LOGIC;
		-- Master select
		hmaster       : in STD_LOGIC_VECTOR(3 downto 0);
		-- Transfer type
		htrans        : in STD_LOGIC_VECTOR(1 downto 0);
		-- Transfer size
		hsize         : in STD_LOGIC_VECTOR(2 downto 0);
		-- Burst type
		hburst        : in STD_LOGIC_VECTOR(2 downto 0);
		-- Write data bus
		hwdata        : in STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
		-- Address bus
		haddr         : in STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
		-- Transfer done 
		hready        : out  STD_LOGIC;
		-- Transfer response 
		hresp         : out STD_LOGIC_VECTOR(1 downto 0);
		-- Read data bus
		hrdata        : out STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0)
		);
end SMEMSTIMAHB;


--*******************************************************************--
architecture SIM of SMEMSTIMAHB is
	
	-- memory size
	constant memsize    : INTEGER := 2**16;
	-- hold time
	constant hold       : TIME := CLK_PERIOD/10;
	-- setup time
	constant setup      : TIME := CLK_PERIOD/10 * 9;
	-- waitcycles 
	constant waitcycles : INTEGER := 1;
	
	-- sample generator #1
	signal sample1      : STD_LOGIC;
	-- sample generator #2
	signal sample2      : STD_LOGIC;
	
	-- single memory word
	subtype TWORD is STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
	-- memory type
	type TMEMORY is array (memsize downto 0) of TWORD;
	
	-- ihraedy
	signal ihready      : STD_LOGIC;
	-- iwrite
	signal iwrite       : STD_LOGIC;
	-- iread
	signal iread        : STD_LOGIC;
  
  
  signal validaddr_r  : STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
  -- valid ready 
	signal validready   : STD_LOGIC;
	-- valid write --
	signal validwrite   : STD_LOGIC;
	-- valid read 
	signal validread    : STD_LOGIC;
	-- valid address
	signal validaddrh   : STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
	-- valid data
	signal validdatah   : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  -- previous htrans value --
  signal prevhtrans   : STD_LOGIC_VECTOR(1 downto 0);
  -- comparable operaion --
  signal compoper     : STD_LOGIC;
	-- compare moment indicator --
  signal compare      : STD_LOGIC;
  -- read file line --
  signal compreadline : INTEGER;

  -- memory write moment --
  signal memwr        : STD_LOGIC :='0';
  
  
	signal ad2000      : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
	signal ad2004      : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
	signal ad2008      : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
	signal ad200c      : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
  
  
begin
	
	---------------------------------------------------------------------
	-- sample generator
	---------------------------------------------------------------------
	sample_proc:
		process
	begin
		loop
			wait on hclk until hclk='1';
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
	
	
	--=================================================================--
	stimulator_reader:
		--=================================================================--
		if MODE=1 or MODE=2 generate
		
		-------------------------------------------------------------------
		-- stim file comp_file
		-------------------------------------------------------------------
		stimread_proc:
			process
			variable char      : CHARACTER;
			variable cycle     : INTEGER;
			variable cyclef    : INTEGER;
			variable addrf     : INTEGER;
			variable addrmac   : INTEGER;
			variable mem       : TMEMORY;
			variable row       : LINE;
			variable tim       : INTEGER;
			variable numline   : INTEGER := 0;
			variable addr      : STD_LOGIC_VECTOR(31 downto 0);
			variable data      : STD_LOGIC_VECTOR(31 downto 0);
			file     stim      : TEXT is in TESTPATH & "/" & TESTNAME & "/" & STIMFILE;
			variable validaddr : INTEGER;
      variable vaddrmac  : INTEGER;
			
			
		begin
			
			-- memory clear
			for i in memsize downto 0 loop
				mem(i) := (others=>'0');  
			end loop;
			
      hrdata     <= (others => '0');
			validdatah <= (others => '0');
			ihready    <= '0';
			iwrite     <= '0';
			iread      <= '0';
      validready <= '0';
			validwrite <= '0'; 
			validread  <= '0';
			
			cycle := 0;
			cyclef := 0;
			addr := (others=>'0');
			data := (others=>'0');
      validaddr := 0;
			
			wait on hclk until hclk='1' and hresetn='1';
			
			loop
				-- process stimulus vectors from file
				
				-- wait on drive moment --
				wait on sample1;
				
				-- drive memory --
				while cycle=cyclef and not ENDFILE(stim) loop
					case DATAWIDTH is
						-------------------------------------
						when 8 =>
						-------------------------------------
						addrf        := CONV_INTEGER(addr(15 downto 2) & "00" );
						mem(addrf)   := data(DATAWIDTH-1 downto 0);
						mem(addrf+1) := data(2*DATAWIDTH-1 downto DATAWIDTH);
						mem(addrf+2) := data(3*DATAWIDTH-1 downto 2*DATAWIDTH);
						mem(addrf+3) := data(4*DATAWIDTH-1 downto 3*DATAWIDTH);
						
						
						-------------------------------------
						when 16 =>
						-------------------------------------
						addrf        := CONV_INTEGER(addr(16 downto 2) & '0');
						mem(addrf)   := data(DATAWIDTH-1 downto 0);
						mem(addrf+1) := data(2*DATAWIDTH-1 downto DATAWIDTH);
						
						
						-------------------------------------
						when 32 =>
						-------------------------------------
						addrf := CONV_INTEGER(addr(17 downto 2));
						mem(addrf)   := data;
						
						
						-------------------------------------
						when others => -- 64
						-------------------------------------
						addrf := CONV_INTEGER(addr(18 downto 3));
						if addr(2)='0' then
							mem(addrf)(DATAWIDTH/2-1 downto 0) := data;
						else
							mem(addrf)(DATAWIDTH-1 downto DATAWIDTH/2) := data;
						end if;
					end case;
					
					READLINE(stim, row);
					numline := numline + 1;
					-- check if it is commented line
					while row'length/=0 loop
						if row(row'left)='/' then
							exit;
						elsif row(row'left)/=' ' then
							exit;
						end if;
						READ(row, char);
					end loop;
					
					-- process only uncommented and non empty line
					if row'length/=0 then
						if row(row'left)/='/' then
							READ(row, cyclef);
							HREAD(row, addr);
							HREAD(row, data);
						end if;
					end if;
				end loop;
				
				-- drive signals --  
				hrdata     <= mem(validaddr);
				validdatah <= mem(validaddr);
				ihready    <= validready;
				iwrite     <= validwrite; 
				iread      <= validread;
				
				
				-- and wait for sample moment --
				
				wait on sample2;
				cycle:=cycle+1;
				
				case DATAWIDTH is
					-----------------------------------
					when 8 =>
					-----------------------------------
					if ADDRWIDTH > 15 then
						addrmac := CONV_INTEGER(haddr(15 downto 0));
					else
						addrmac := CONV_INTEGER(haddr(ADDRWIDTH-1 downto 0));
					end if;
					
					-----------------------------------
					when 16 =>
					-----------------------------------
					if ADDRWIDTH > 16 then
						addrmac := CONV_INTEGER(haddr(16 downto 1));
					else
						addrmac := CONV_INTEGER(haddr(ADDRWIDTH-1 downto 1));
					end if;
					
					-----------------------------------
					when 32 =>
					-----------------------------------
					if ADDRWIDTH > 17 then
						addrmac := CONV_INTEGER(haddr(17 downto 2));
					else
						addrmac := CONV_INTEGER(haddr(ADDRWIDTH-1 downto 2));
					end if;
					
					-----------------------------------
					when others => -- 64
					-----------------------------------
					if ADDRWIDTH > 18 then
						addrmac := CONV_INTEGER(haddr(18 downto 3));
					else
						addrmac := CONV_INTEGER(haddr(ADDRWIDTH-1 downto 3));
					end if;
				end case;
				
				-- ready signal prepare --
				if (htrans="10" and ihready='1') or (htrans="11" and ihready='1') then
					
					validaddr  := addrmac;
					validaddrh <= haddr;
					
					if waitcycles = 0 then
						validready <= '1';
					else
						validready <= '0', '1' after waitcycles*CLK_PERIOD;
					end if;
				end if;
				if htrans="00" then
					validready <= '1';
				end if;
				
				-- write signal prepare --
				if (htrans="10" or htrans="11") and hwr='1' and ihready='1' then
					validwrite <= '1';
				else 
					if htrans="00" and ihready='1' then
						validwrite <= '0';
					end if;
				end if;
				
				-- read signal prepare --
				if (htrans="10" or htrans="11") and hwr='0' and ihready='1' then
					validread <= '1';
				else 
					if htrans="00" and ihready='1' then
						validread <= '0';
					end if;
				end if;
				
				-- write to memory --
        if iwrite='1' and ihready='1' then
					case DATAWIDTH is
						-----------------------------------
						when 8 =>
						-----------------------------------
						if ADDRWIDTH > 15 then
							vaddrmac := CONV_INTEGER(validaddr_r(15 downto 0));
						else
							vaddrmac := CONV_INTEGER(validaddr_r(ADDRWIDTH-1 downto 0));
						end if;
						
						-----------------------------------
						when 16 =>
						-----------------------------------
						if ADDRWIDTH > 16 then
							vaddrmac := CONV_INTEGER(validaddr_r(16 downto 1));
						else
							vaddrmac := CONV_INTEGER(validaddr_r(ADDRWIDTH-1 downto 1));
						end if;
						
						-----------------------------------
						when 32 =>
						-----------------------------------
						if ADDRWIDTH > 17 then
							vaddrmac := CONV_INTEGER(validaddr_r(17 downto 2));
						else
							vaddrmac := CONV_INTEGER(validaddr_r(ADDRWIDTH-1 downto 2));
						end if;
						
						-----------------------------------
						when others => -- 64
						-----------------------------------
						if ADDRWIDTH > 18 then
							vaddrmac := CONV_INTEGER(validaddr_r(18 downto 3));
						else
							vaddrmac := CONV_INTEGER(validaddr_r(ADDRWIDTH-1 downto 3));
						end if;
					end case;
				
					mem(vaddrmac) := hwdata;
          memwr <= '1', '0' after 1 ns;
				end if;
				
			end loop;
		end process; -- stimread_proc
	end generate; -- stimulator_reader
	 
	-- hready driver
	hready_drv: hready <= ihready;
	
	-- hready driver
	hresp_drv: hresp <= "00";
	
	process
	begin
    loop 
      wait on sample2;
        if ihready='1' then
          validaddr_r <= haddr;
        end if;        
    end loop;
  end process;  

	--------------------------------------------------------
	--- COMP file
	--------------------------------------------------------
	
	compfile_writer:
		if MODE=1 generate
		process
			
			variable diff_row      : LINE;
			file     diff_file     : TEXT is out TESTPATH & "/" & TESTNAME & "/" & COMPFILE;
		begin
			
			WRITE(diff_row, STRING'("// AHB interface monitor file"));
			WRITELINE(diff_file, diff_row);
			WRITELINE(diff_file, diff_row);
			
			wait on hclk until hclk='1' and hresetn='1'; 
			loop
				
				wait on sample2;
				
				if ihready='1' and iwrite='1' and compoper='1' then
					-- write
					WRITE(diff_row, STRING'(" 2 "));
					HWRITE(diff_row, validaddr_r, RIGHT, 10 );
					HWRITE(diff_row, hwdata  , RIGHT, 10 );
					WRITELINE(diff_file, diff_row);
					
				end if;
				
				if ihready='1' and iread='1' and compoper='1' then
					-- read
					WRITE(diff_row, STRING'(" 1 "));
					HWRITE(diff_row, validaddr_r, RIGHT, 10 );
					HWRITE(diff_row, validdatah, RIGHT, 10 );
					WRITELINE(diff_file, diff_row);
				end if;
				
				
			end loop;  
			
		end process;
	end generate;
	
	--------------------------------------------------------
	--- Comparator 
	--------------------------------------------------------
	
	comparator:
		if MODE=2 generate
		process
			variable readopcode      : INTEGER;
			variable readaddress     : STD_LOGIC_VECTOR(ADDRWIDTH-1 downto 0);
			variable readdata        : STD_LOGIC_VECTOR(DATAWIDTH-1 downto 0);
      variable readx           : STD_LOGIC_VECTOR(3 downto 0);
			variable comp_row        : LINE;
			file     comp_file       : TEXT is in TESTPATH & "/" & TESTNAME & "/" & COMPFILE;
			variable diff_row        : LINE;
			file     diff_file       : TEXT is out TESTPATH & "/" & TESTNAME & "/" & DIFFFILE;
			variable numline         : INTEGER := 0; 
			variable errors          : INTEGER := 0;
		begin
			
			WRITE(diff_row, STRING'("MAHB interface checking:"));
			WRITELINE(diff_file, diff_row);
			WRITELINE(diff_file, diff_row);
			WRITE(diff_row, STRING'("Waiting for signals..."));
			WRITELINE(diff_file, diff_row);
			compare <= '-';
      
			wait on hclk until hclk='1' and hresetn='1'; 
			
			WRITE(diff_row, STRING'("OK."));
			WRITELINE(diff_file, diff_row);
			
			WRITELINE(diff_file, diff_row);
			WRITE(diff_row, STRING'(" ----------------------------------------------------------------------- "));
			WRITELINE(diff_file, diff_row);
			
			WRITE(diff_row, now, RIGHT, 10);
			WRITE(diff_row, STRING'(" : Note:   comparision process started "));
			WRITELINE(diff_file, diff_row);
			
      compare <= '0';
      
			-- main compare loop --
			loop
				
				-- read line loop --
				loop
					-- check endfile --
					if endfile(comp_file) then 
						exit;
					end if;
					-- read line --
					READLINE(comp_file, comp_row);
					numline := numline + 1;
					-- check if it is commented line
					if comp_row'length>10 and comp_row(1)/='/' and comp_row(1)/='\' then
						exit;
					end if;
				end loop;
				
        compreadline <= numline;
        
				--check endfile --
				if endfile(comp_file) then 
					exit;
				end if;
				
				READ(comp_row, readopcode);
				HREAD(comp_row, readaddress);
--        HREAD(comp_row, readx);
				HREAD(comp_row, readdata);
				
				wait on sample2 until ihready='1' and (iwrite='1' or iread='1') and compoper='1';
        
        compare <= '1', '0' after 1 ns;
				
				if ihready='1' and iread='1' and readopcode/=1 then 
					WRITE(diff_row, now , RIGHT, 10);
					WRITE(diff_row, STRING'(" : Error:  read operation detected while write expecting"));	
					WRITELINE(diff_file, diff_row);	 
					errors:=errors+1;
				end if;
        
				if ihready='1' and iwrite='1' and readopcode/=2 then 
					WRITE(diff_row, now , RIGHT, 10);
					WRITE(diff_row, STRING'(" : Error:  write operation detected while read expecting"));	
					WRITELINE(diff_file, diff_row);
					errors:=errors+1;
				end if;
				
				if readaddress/=validaddr_r then
					WRITE(diff_row, now , RIGHT, 10);
					WRITE(diff_row, STRING'(" : Error:  haddr is "));	
					HWRITE(diff_row, validaddr_r);
					WRITE(diff_row, STRING'(" but expected is "));	
					HWRITE(diff_row, readaddress);
					WRITE(diff_row, STRING'("."));	
					WRITELINE(diff_file, diff_row);
					errors:=errors+1;
				end if;
				
				if (iwrite='1') and (hwdata/=readdata) then
					WRITE(diff_row, now , RIGHT, 10);
					WRITE(diff_row, STRING'(" : Error:  hwdata is "));	
					HWRITE(diff_row, hwdata);
					WRITE(diff_row, STRING'(" but expected is "));	
					HWRITE(diff_row, readdata);
					WRITE(diff_row, STRING'("."));	
					WRITELINE(diff_file, diff_row);
					errors:=errors+1;
				end if;
				
				if (iread='1') and (validdatah/=readdata) then
					WRITE(diff_row, now , RIGHT, 10);
					WRITE(diff_row, STRING'(" : Error:  hrdata is "));	
					HWRITE(diff_row, validdatah);
					WRITE(diff_row, STRING'(" but expected is "));	
					HWRITE(diff_row, readdata);
					WRITE(diff_row, STRING'("."));	
					WRITELINE(diff_file, diff_row);
					errors:=errors+1;
				end if;
			end loop; 
			WRITE(diff_row, now, RIGHT, 10);
			WRITE(diff_row, STRING'(" : Note:   end of comapre file detected."));
			WRITELINE( diff_file, diff_row);
			
			WRITE(diff_row, now, RIGHT, 10);
			WRITE(diff_row, STRING'(" : Note:   comparision process stopped."));
			WRITELINE( diff_file, diff_row);
			
			WRITE(diff_row, STRING'(" ----------------------------------------------------------------------- "));
			WRITELINE(diff_file, diff_row);
			WRITELINE(diff_file, diff_row);
			
			
			if errors=0 then
				assert false
				report "Test " & TESTNAME & " passed."
				severity note;
				WRITE(diff_row, STRING'("Test passed."));
				WRITELINE(diff_file, diff_row);
			else
				assert false
				report "Test " & TESTNAME & " failed. Differences are in the file " &
				TESTPATH & "/" & TESTNAME & "/" & DIFFFILE
				severity note;
				WRITE(diff_row, STRING'("Test failed - "));
				WRITE(diff_row, errors);
				WRITE(diff_row, STRING'(" difference(s) detected"));
				WRITELINE(diff_file, diff_row);
			end if;
			wait;
			
		end process;
	end generate;
  
    -- remember previous htrans --
    process (sample2)
    begin
      if ihready='1' then
        prevhtrans <= htrans;
      end if;
    end process;

    -- compare operation ?? --
    process (sample2)
    begin
      if htrans="00" and prevhtrans="00" then 
        compoper <= '0';
      else
        compoper <= '1';
      end if;
    end process;


	
	
	
	
end SIM;
--*******************************************************************--
