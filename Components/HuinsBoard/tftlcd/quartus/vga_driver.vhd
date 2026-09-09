LIBRARY ieee,work;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY vga_driver IS 
	PORT (
		clock25			: IN std_logic;
		reset_n			: IN std_logic;
		enable			: IN std_logic;

		-- video memory signals
		video_data		: IN std_logic_vector(31 downto 0);
		video_address		: OUT std_logic_vector(31 downto 0);

		-- parameter signals from AHB slave interface
		num_lines	   	    : BUFFER std_logic_vector(15 downto 0);
		image_dimensions    : in std_logic_vector(31 downto 0);		
		num_words_per_line  : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		-- blanking outputs to any external logic that might need it
		hblank			: OUT std_logic;
		vblank			: OUT std_logic;

		-- outputs to VGA daughter card
		clockext		: OUT std_logic;
		vsync			: OUT std_logic;
		hsync			: OUT std_logic;
        DE              : out std_logic;
        pwr_en      : out std_logic;     
		R			: OUT std_logic_vector(7 downto 0);
		G			: OUT std_logic_vector(7 downto 0);
		B			: OUT std_logic_vector(7 downto 0)
	);
END vga_driver;

ARCHITECTURE rtl OF vga_driver IS

	SIGNAL pixel_counter	: std_logic_vector(9 downto 0);
	SIGNAL line_counter		: std_logic_vector(9 downto 0);	
	SIGNAL half_word_sel		: std_logic;
	SIGNAL video_address_sig	: std_logic_vector(31 downto 0);
	SIGNAL vblank_sig		: std_logic;
	SIGNAL hblank_sig		: std_logic;
    SIGNAL num_pixels_per_line : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL x_offset			: std_logic_vector(9 downto 0);
	SIGNAL y_offset			: std_logic_vector(9 downto 0);

	SIGNAL active			: std_logic;
	SIGNAL active_delay		: std_logic;

	SIGNAL last_hblank		: std_logic;
    
    signal line1     : std_logic;
    signal cnt_5M    : std_logic_vector(2 downto 0); 
    signal hclock    : std_logic;

	CONSTANT hwidth			: integer := 254;
	CONSTANT vdepth			: integer := 326;
	CONSTANT line_width 	: integer := 240;
	CONSTANT number_lines	: integer := 320;
	
	-- blanking and sync pulse constants
	CONSTANT begin_hblank	: integer := 11;  
	CONSTANT end_hblank		: integer := 11+line_width;
	CONSTANT end_hsync		: integer := 4;
	
	CONSTANT begin_vblank	: integer := 4;  
	CONSTANT end_vblank		: integer := 4+number_lines;
	CONSTANT end_vsync		: integer := 2;	



BEGIN
video_address <= video_address_sig;
half_word_sel <= video_address_sig(0);
num_words_per_line <= '0' & image_dimensions(31 downto 17);
num_pixels_per_line <= image_dimensions(25 downto 16);
num_lines <= image_dimensions(15 downto 0);
hblank <= hblank_sig;
vblank <= vblank_sig;
pwr_en  <= '1';

process(pixel_counter)
begin
   if pixel_counter<253 then
      clockext <= hclock;
   else
      clockext<='0';
   end if;
end process;

       


--generate approximate 5MHz clock
process(reset_n,clock25)
begin
   if reset_n='0' then
      hclock <= '0';
      cnt_5M <= (others=>'0');
   elsif clock25'event and clock25='1' then
  --    cnt_5M <= cnt_5M +1; 
  --    if cnt_5M=5 then
 --        hclock <=not(hclock);
--		cnt_5M <=(others=>'0');
	if cnt_5M = 2 then
		hclock <=not hclock;
		cnt_5M <=(others=>'0');
	else
		cnt_5M <= cnt_5M +1;
  
        end if;
   end if;
end process;

--display_offset
PROCESS(hclock,reset_n)
	VARIABLE x_offset_reg : std_logic_vector(9 downto 0);
	VARIABLE y_offset_reg : std_logic_vector(9 downto 0);
BEGIN
	IF reset_n = '0' THEN
		x_offset_reg := (others => '0');
		y_offset_reg := (others => '0');
	ELSIF hclock'event and hclock='1' THEN
		IF vblank_sig = '0' THEN
			x_offset_reg := LINE_WIDTH - num_pixels_per_line;
			y_offset_reg := NUMBER_LINES - num_lines(9 DOWNTO 0);
		END IF;
	END IF;
	-- divide offsets by 2 to balance borders on each side of image
	x_offset <= '0' & x_offset_reg(9 downto 1);
	y_offset <= '0' & y_offset_reg(9 downto 1);
END PROCESS;


-- Horizontal counter & Hsync
-- Hsync  --    --------------------------------------------    --
--          ----                                            ----  
--         | 4m |  7m  |           240m               | 3m  |
 
-- DE                  --------------------------------    
--        -------------                                 -----------
--              |  7m  |                               | 3m |
process(reset_n, hclock, pixel_counter, line_counter)
begin
   if (reset_n='0') then
      pixel_counter <= (others=>'0');
      Hsync     <= '0';
      DE        <= '0';
      line1     <= '0';   
   elsif hclock'event and hclock='1' then
     if pixel_counter=254 then 
         pixel_counter <= (others=>'0');
      else
         pixel_counter <= pixel_counter + 1;
      end if;
      -- Hsync
      if (pixel_counter<4 or pixel_counter>252) then
          Hsync <= '0';
      else
          Hsync <= '1';
      end if;

      --DE
      if ((line_counter<4 or line_counter>323) or (pixel_counter<11 or pixel_counter>251)) then
          DE    <= '0';
      else
          DE    <= '1';
      end if; 

   end if;
end process;

-- Vertical counter
--                                                           |<-327th line_counter 
-- --    ----------------------------------------------------    --
--   ----                                                    ---- 
--  | 2H | 2H |              DATA 320H                 | 3H  |
process(reset_n, hclock, line_counter, pixel_counter)
begin
   if (reset_n='0' or (line_counter=327 and pixel_counter=253)) then  --254
      line_counter <= (others=>'0');
      Vsync     <= '0';
   elsif hclock'event and hclock='1' then
      if pixel_counter=253 then
         line_counter <= line_counter + 1;
      end if;
         -- Vsync
      if (line_counter<2) then
         Vsync <= '0';
      else
         Vsync <= '1';
      end if;
   end if;
end process;

PROCESS(hclock,reset_n)
BEGIN
	IF reset_n = '0' THEN
		last_hblank <= '0';
	ELSIF rising_edge(hclock) THEN
			last_hblank <= '1';
    END IF;
END PROCESS;

PROCESS(hclock,reset_n)
BEGIN
	IF reset_n = '0' THEN
		hblank_sig <= '0';
		video_address_sig <= (others => '0');
		active <= '0';
		vblank_sig <= '0';
	ELSIF rising_edge(hclock) THEN
		-- generate the blanking signal and the address to the line buffer
		IF (pixel_counter > 10 AND pixel_counter < 250) THEN  
			hblank_sig <= last_hblank;
		ELSE 
			hblank_sig <= '0';
		END IF;
		
		IF (line_counter > 2+y_offset AND line_counter <= 323-y_offset) THEN
			vblank_sig <= '1';
		ELSE
			vblank_sig <= '0';
		END IF;

		IF (line_counter > y_offset+3 AND line_counter <= 322-y_offset) THEN
			IF (pixel_counter > 9 AND pixel_counter < 249 and video_address_sig<239) THEN  
		  		active <= '1';
		        video_address_sig <= video_address_sig + 1;
			ELSE 
				active <= '0';
				video_address_sig <= (others => '0');  
			END IF;
		ELSE
			active <= '0';
			video_address_sig <= (others => '0');
		END IF;

	END IF;
END PROCESS;


color_generator: PROCESS(reset_n,hclock)
BEGIN
	IF reset_n = '0' THEN
		R <= (others => '0');
		G <= (others => '0');
		B <= (others => '0');
		active_delay <= '0';
	ELSIF rising_edge(hclock) THEN
		active_delay <= active;
		IF active_delay = '1' AND enable = '1' THEN
			IF (half_word_sel = '1') THEN  
				R <= video_data(31 downto 27) & "111";
				G <= video_data(26 downto 21) & "11";
				B <= video_data(20 downto 16) & "111";
			ELSE 
				R <= video_data(15 downto 11) & "111";
				G <= video_data(10 downto 5) & "11";
				B <= video_data(4 downto 0) & "111";	
			END IF;
		ELSE
			R <= X"00";
			G <= X"00";
			B <= X"00";
		END IF;
	END IF;
END PROCESS;

END rtl;



