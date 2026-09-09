library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity MUL is
      Port ( 
				 CLK : In    std_logic;
			 EXEC_EN : In    std_logic;
             FLUSH_X2 : In    std_logic;
                  OP : In    std_logic_vector (2 downto 0);
                  RM : In    std_logic_vector (31 downto 0);
               RN_HI : In    std_logic_vector (31 downto 0);
               RN_LO : In    std_logic_vector (31 downto 0);
                  RS : In    std_logic_vector (31 downto 0);
             STALL_X2 : In    std_logic;
             FLAG_NZ : Out   std_logic_vector (1 downto 0);
               RD_HI : Out   std_logic_vector (31 downto 0);
               RD_LO : Out   std_logic_vector (31 downto 0) );
end MUL;

architecture BEHAVIORAL of MUL is

-- OP(2): long, OP(1): sign, OP(0): ACC

    component mbe
        port (a : in std_logic_vector (33 downto 0);
              b : in std_logic_vector (2 downto 0);
              carry : out std_logic;
              data  : out std_logic_vector (63 downto 0));
    end component;

    component csa
        port (a,
              b,
              c : in std_logic_vector (63 downto 0);
              d,
              e : out std_logic_vector (63 downto 0));
    end component;

    signal blsb, bmsb : std_logic_vector (2 downto 0);
    signal pp0c, pp1c, pp2c, pp3c, pp4c, pp5c, pp6c, pp7c, pp8c,
           pp9c, pp10c,pp11c,pp12c,pp13c,pp14c,pp15c,pp16c : std_logic;
    signal pp0d, pp1d, pp2d, pp3d, pp4d, pp5d, pp6d, pp7d, pp8d,
           pp9d, pp10d,pp11d,pp12d,pp13d,pp14d,pp15d,pp16d : 
           std_logic_vector(63 downto 0);
    signal stage0d0,  stage0d1,  stage0d2,  stage0d3,  stage0d4,  stage0d5,
           stage0d6,  stage0d7,  stage0d8,  stage0d9,  stage0d10, stage0d11,
           stage0d12, stage0d13, stage0d14, stage0d15, stage0d16, stage0d17,
           stage1d0,  stage1d1,  stage1d2,  stage1d3,  stage1d4,  stage1d5,
           stage1d6,  stage1d7,  stage1d8,  stage1d9,  stage1d10, stage1d11,
           stage2d0,  stage2d1,  stage2d2,  stage2d3,  stage2d4, 
           stage2d5,  stage2d6,  stage2d7,
           stage3d0,  stage3d1,  stage3d2,  stage3d3,  stage3d4,  stage3d5,
           stage4d0,  stage4d1,  stage4d2,  stage4d3,   
           stage5d0,  stage5d1,  stage5d2,     
           stage6d0,  stage6d1,  stage6d2,  stage6d0q, stage6d1q,
           stage7d0,  stage7d1   : std_logic_vector (63 downto 0);
    signal aext       : std_logic_vector(33 downto 0);
    signal asign      : std_logic_vector( 1 downto 0); 
    signal bsign      : std_logic_vector( 1 downto 0);
	signal stage4d0q,stage4d1q,stage4d2q,stage5d2q, stage6d2q : std_logic_vector (63 downto 0);
	signal a,b : std_logic_vector(31 downto 0);
	signal c,d : std_logic_vector(63 downto 0);
    signal sign      : std_logic; 
	-- DEBUG_030821c: OP must go through pipeline register
	signal OP_ff : std_logic_vector(2 downto 0);
begin

	-- Input signal conversion
	process(RM,RS,OP,RN_HI,RN_LO)
	begin
		sign <= OP(1);
		a <= RM;
		b <= RS;
		c <= RN_HI & RN_LO;
	end process;
		

    process(a, b, sign)
    begin
        if sign = '1' then
            if a(31) = '1' then
                asign <= "11";
            else
                asign <= "00";
            end if;
            if b(31) = '1' then
                bsign <= "11";
            else
                bsign <= "00";
            end if;
        else 
            asign <= "00";
            bsign <= "00";
        end if;
    end process;
  
    aext <= asign & a;

    blsb <= b(1 downto 0) & '0';
    bmsb <= bsign & b(31);
    
    pp0blk  : mbe port map (aext, blsb,            pp0c,  pp0d);
    pp1blk  : mbe port map (aext, b( 3 downto  1), pp1c,  pp1d);
    pp2blk  : mbe port map (aext, b( 5 downto  3), pp2c,  pp2d);
    pp3blk  : mbe port map (aext, b( 7 downto  5), pp3c,  pp3d);
    pp4blk  : mbe port map (aext, b( 9 downto  7), pp4c,  pp4d);
    pp5blk  : mbe port map (aext, b(11 downto  9), pp5c,  pp5d);
    pp6blk  : mbe port map (aext, b(13 downto 11), pp6c,  pp6d);
    pp7blk  : mbe port map (aext, b(15 downto 13), pp7c,  pp7d);
    pp8blk  : mbe port map (aext, b(17 downto 15), pp8c,  pp8d);
    pp9blk  : mbe port map (aext, b(19 downto 17), pp9c,  pp9d);
    pp10blk : mbe port map (aext, b(21 downto 19), pp10c, pp10d);
    pp11blk : mbe port map (aext, b(23 downto 21), pp11c, pp11d);
    pp12blk : mbe port map (aext, b(25 downto 23), pp12c, pp12d);
    pp13blk : mbe port map (aext, b(27 downto 25), pp13c, pp13d);
    pp14blk : mbe port map (aext, b(29 downto 27), pp14c, pp14d);
    pp15blk : mbe port map (aext, b(31 downto 29), pp15c, pp15d);
    pp16blk : mbe port map (aext, bmsb           , pp16c, pp16d);

    stage0d0  <= pp0d;
    stage0d1  <= pp1d (61 downto 0) & "00";
    stage0d2  <= pp2d (59 downto 0) & "0000";
    stage0d3  <= pp3d (57 downto 0) & "000000";
    stage0d4  <= pp4d (55 downto 0) & "00000000";
    stage0d5  <= pp5d (53 downto 0) & "0000000000";
    stage0d6  <= pp6d (51 downto 0) & "000000000000";
    stage0d7  <= pp7d (49 downto 0) & "00000000000000";
    stage0d8  <= pp8d (47 downto 0) & "0000000000000000";
    stage0d9  <= pp9d (45 downto 0) & "000000000000000000";
    stage0d10 <= pp10d(43 downto 0) & "00000000000000000000";
    stage0d11 <= pp11d(41 downto 0) & "0000000000000000000000";
    stage0d12 <= pp12d(39 downto 0) & "000000000000000000000000";
    stage0d13 <= pp13d(37 downto 0) & "00000000000000000000000000";
    stage0d14 <= pp14d(35 downto 0) & "0000000000000000000000000000";
    stage0d15 <= pp15d(33 downto 0) & "000000000000000000000000000000";
    stage0d16 <= pp16d(31 downto 0) & "00000000000000000000000000000000";
    stage0d17 <= "1010101010101010101010101010110"              & pp16c &
                  '0' & pp15c & '0' & pp14c & '0' & pp13c & '0' & pp12c &
                  '0' & pp11c & '0' & pp10c & '0' & pp9c  & '0' & pp8c  &
                  '0' & pp7c  & '0' & pp6c  & '0' & pp5c  & '0' & pp4c  &
                  '0' & pp3c  & '0' & pp2c  & '0' & pp1c  & '0' & pp0c;

    stage00 : csa port map (stage0d0 ,stage0d1 ,stage0d2 ,stage1d0,stage1d1);
    stage01 : csa port map (stage0d3 ,stage0d4 ,stage0d5 ,stage1d2,stage1d3);
    stage02 : csa port map (stage0d6 ,stage0d7 ,stage0d8 ,stage1d4,stage1d5);
    stage03 : csa port map (stage0d9 ,stage0d10,stage0d11,stage1d6,stage1d7);
    stage04 : csa port map (stage0d12,stage0d13,stage0d14,stage1d8,stage1d9);
    stage05 : csa port map (stage0d15,stage0d16,stage0d17,stage1d10,stage1d11);
  
    stage10 : csa port map (stage1d0, stage1d1,  stage1d2,  stage2d0, stage2d1);
    stage11 : csa port map (stage1d3, stage1d4,  stage1d5,  stage2d2, stage2d3);
    stage12 : csa port map (stage1d6, stage1d7,  stage1d8,  stage2d4, stage2d5);
    stage13 : csa port map (stage1d9, stage1d10, stage1d11, stage2d6, stage2d7);

    stage20 : csa port map (stage2d0, stage2d1, stage2d2, stage3d0, stage3d1);
    stage21 : csa port map (stage2d3, stage2d4, stage2d5, stage3d2, stage3d3);
  
    stage3d4 <= stage2d6;
    stage3d5 <= stage2d7;

    stage30 : csa port map (stage3d0, stage3d1, stage3d2, stage4d0, stage4d1);
    stage31 : csa port map (stage3d3, stage3d4, stage3d5, stage4d2, stage4d3);

-- divided in this stage
--    stage40 : csa port map (stage4d0, stage4d1, stage4d2, stage5d0, stage5d1);
    stage40 : csa port map (stage4d0q, stage4d1q, stage4d2q, stage5d0, stage5d1);

    stage5d2 <= stage4d3;

--    stage50 : csa port map (stage5d0, stage5d1, stage5d2, stage6d0, stage6d1);
    stage50 : csa port map (stage5d0, stage5d1, stage5d2q, stage6d0, stage6d1);

    process (CLK)
    begin
        if CLK'event and CLK = '1' then
        	if (FLUSH_X2 = '1') then
           	 	stage4d0q <= (others=>'0'); 
           	 	stage4d1q <= (others=>'0'); 
           	 	stage4d2q <= (others=>'0'); 
           		stage5d2q <= (others=>'0'); 
            	stage6d2q <= (others=>'0'); 
				OP_ff	  <= (others=>'0');
			elsif( STALL_X2='0') then
            	stage4d0q <= stage4d0; 
            	stage4d1q <= stage4d1; 
            	stage4d2q <= stage4d2; 
            	stage5d2q <= stage5d2; 
            	stage6d2q <= stage6d2; 
				-- DEBUG_030821c: OP must go through pipeline register
				OP_ff	  <= OP;
			end if;
        end if;             
    end process;

    stage6d2 <= c;

--   stage60 : csa port map (stage6d0q, stage6d1q, stage6d2, stage7d0, stage7d1);
--   stage60 : csa port map (stage6d0, stage6d1, stage6d2, stage7d0, stage7d1);
   stage60 : csa port map (stage6d0, stage6d1, stage6d2q, stage7d0, stage7d1);

    d <= unsigned(stage7d0) + unsigned(stage7d1);

	-- Output signal conversion
	process(OP_ff,d)
	begin
		RD_HI <= d(63 downto 32);
		RD_LO <= d(31 downto 0);
		-- DEBUG_030821c: OP must go through pipeline register
		if(OP_ff(2)='1') then -- long
			FLAG_NZ(1) <= d(63);
			if( d = "0000000000000000000000000000000000000000000000000000000000000000" ) then
				FLAG_NZ(0) <= '1';
			else
				FLAG_NZ(0) <= '0';
			end if;
		else
			FLAG_NZ(1) <= d(31);
			if( d(31 downto 0) = "00000000000000000000000000000000" ) then
				FLAG_NZ(0) <= '1';
			else
				FLAG_NZ(0) <= '0';
			end if;
		end if;
		
	end process;
		
   
end BEHAVIORAL;

configuration CFG_MUL of MUL is
   for BEHAVIORAL

   end for;

end CFG_MUL;
