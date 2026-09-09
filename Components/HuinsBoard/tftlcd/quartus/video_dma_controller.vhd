LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY video_dma_controller IS
	PORT (

	-- inputs from AHB slave side interface
	buffer_address	: IN std_logic_vector(31 downto 0);
	num_words_per_line	: IN std_logic_vector(15 downto 0);
	num_lines		: IN std_logic_vector(15 downto 0);	
	enable_dma		: IN std_logic;
	
	-- inputs from VGA driver 
	vblank			: IN std_logic;
	hblank			: IN std_logic;

	-- AHB master interface signals	
	-- These signals connect to the PLD-to-stripe bridge
	reset_n 		: IN std_logic;
	masterhclk		: IN std_logic;
	masterhgrant		: IN std_logic;
	masterhready		: IN std_logic;
	masterhrdata		: IN std_logic_vector(31 downto 0);
	masterhlock		: OUT std_logic;
	masterhaddr		: OUT std_logic_vector(31 downto 0);  
	masterhbusreq		: OUT std_logic;
	masterhsize		: OUT std_logic_vector(1 downto 0);
	masterhtrans		: OUT std_logic_vector(1 downto 0);
	masterhburst		: OUT std_logic_vector(2 downto 0);
	masterhwdata		: OUT std_logic_vector(31 downto 0);

	-- data and control signals for output of DMA 
	set_irq				: OUT std_logic;
	buffer_select		: OUT std_logic; 
	dma_data		: OUT std_logic_vector(31 downto 0);
	rx_buffer_wraddress	: OUT std_logic_vector(9 downto 0);
	dma_data_valid		: OUT std_logic
	);
END video_dma_controller;

ARCHITECTURE rtl OF video_dma_controller IS
	SIGNAL masterhaddr_sig		: std_logic_vector(31 downto 0);
	SIGNAL masterhbusreq_sig	: std_logic;
	SIGNAL rx_buffer_wraddress_sig	: std_logic_vector(9 downto 0);

	-- Declare signals for AHB Transactor FSM
	TYPE ahb_state_type IS (idle,seq,nonseq);
	SIGNAL ahb_state : ahb_state_type;
	
	-- Declare signals for DMA control FSM
	TYPE control_state_type IS (idle, begin_line, transmit_line, end_line);
	SIGNAL control_state : control_state_type;		
	
	SIGNAL start_transfer			: std_logic;
	SIGNAL end_transfer			: std_logic;

	SIGNAL buffered_hrdata			: std_logic_vector(31 downto 0);
	SIGNAL load_address			: std_logic;
	SIGNAL incr_masterhaddr_sig		: std_logic;
	SIGNAL incr_burst_beat_counter		: std_logic;
	
	SIGNAL burst_counter 			: std_logic_vector(5 downto 0);
	SIGNAL incr_burst_counter		: std_logic;

	SIGNAL burst_beat_counter		: std_logic_vector(2 downto 0);
	
	SIGNAL current_line_address		: std_logic_vector(31 downto 0);
	SIGNAL line_counter			: std_logic_vector(9 downto 0);
	SIGNAL reset_line_counter		: std_logic;

	SIGNAL dma_vblank			: std_logic;
	SIGNAL dma_hblank			: std_logic;
	SIGNAL delay_dma_hblank			: std_logic;  
	SIGNAL start_of_line			: std_logic;

		
BEGIN 

masterhaddr <= masterhaddr_sig;
masterhbusreq <= masterhbusreq_sig;
rx_buffer_wraddress <= rx_buffer_wraddress_sig;

-- Register the hrdata signal to help ensure that we can run the dma at fast clock frequencies.
REGISTER_HRDATA: PROCESS(masterhclk, reset_n)
BEGIN
	IF reset_n = '0' THEN
		buffered_hrdata <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		buffered_hrdata <= masterhrdata;
	END IF;
END PROCESS;

-- hsize is always 32 bits
masterhsize <= "10";
-- we always do unspecified length bursts to get maximum bandwidth out of the PLD-to-stripe bridge
masterhburst <= "001";

-- The VGA controller is on a 25MHZ clock domain so we need to transfer the controller signals from
-- the 25MHz domain to the 100MHz master domain. Ideally the 100MHz and 25MHz clocks will be 
-- synchronous and we will not see metastability issues.
register_vga_signals: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		dma_vblank <= '0';
		dma_hblank <= '0';
		start_of_line <= '0';
		delay_dma_hblank <= '0';
	ELSIF rising_edge(masterhclk) THEN
		dma_vblank <= vblank;
		dma_hblank <= hblank;
		delay_dma_hblank <= dma_hblank;
		-- This segment of code generates a start of line signal which is active for a 
		-- single clock cycle immedietly following the deassertion of the hblank signal.
		IF delay_dma_hblank = '1' AND dma_hblank = '0' AND dma_vblank = '1' THEN
			start_of_line <= '1';
		ELSE
			start_of_line <= '0';
		END IF;
	END IF;
END PROCESS;

-- CONTROL PROCESS
control_FSM: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		control_state <= idle;
		start_transfer <= '0';		-- begin transferring a line from SDRAM
		end_transfer <= '0';		-- end line transfer
		incr_burst_counter <= '0';	-- enable_dma signal for burst counter
		reset_line_counter <= '0';
		masterhbusreq_sig <= '0';	-- request access to the stripe AHB buses
		masterhlock <= '0';
		set_irq <= '0';
	ELSIF rising_edge(masterhclk) THEN
		CASE control_state IS
			-- We are in the idle state in between horizontal line transfers.
			-- When in this state we do not request access to the stripe.
			WHEN idle =>
				IF start_of_line = '1' AND enable_dma = '1' THEN
					masterhbusreq_sig <= '1';
					control_state <= begin_line;
				ELSE
					masterhbusreq_sig <= '0';
					control_state <= idle;
				END IF;
				incr_burst_counter <= '0';
				start_transfer <= '0';
				end_transfer <= '0';
				reset_line_counter <= '0';
				masterhlock <= '0';
				set_irq <= '0';

			-- Once the blanking signals are detected we enter this state which
			-- initiates an undefined length burst read 	
			WHEN begin_line =>
				control_state <= transmit_line;
				start_transfer <= '1';
				incr_burst_counter <= '0';
				end_transfer <= '0';
				reset_line_counter <= '0';
				masterhbusreq_sig <= '1';
				masterhlock <= '1'; 
				set_irq <= '0';
				
			-- During this state we are performing an undefined length burst read 
			-- from the stripe.   
			WHEN transmit_line =>
				-- Count a burst every time the burst beat counter has a value of 1.
				IF burst_beat_counter = 1 AND incr_burst_beat_counter = '1' THEN
					incr_burst_counter <= '1';
				ELSE
					incr_burst_counter <= '0';
				END IF;
				
				-- We will transition to the end line state if the burst_counter is equal to
				-- the number of words per line divided by 8.  We divivde by 8 because the 
				-- burst counter counts 8 beats at a time.
				IF burst_counter = num_words_per_line(8 downto 3) 
				   AND burst_beat_counter = 5 THEN
					end_transfer <= '1';
					masterhbusreq_sig <= '0';
					control_state <= end_line;
				ELSE
					end_transfer <= '0';
					masterhbusreq_sig <= '1';
					control_state <= transmit_line;
				END IF;
				start_transfer <= '0';
				reset_line_counter <= '0';
				masterhlock <= '1'; 
				set_irq <= '0';
					
			WHEN end_line =>
				control_state <= idle;
				incr_burst_counter <= '0';
				start_transfer <= '0';
				end_transfer <= '0';
				masterhbusreq_sig <= '0';
				IF line_counter = num_lines THEN  
					reset_line_counter <= '1';
					set_irq <= '1';
				ELSE
					reset_line_counter <= '0';
					set_irq <= '0';
				END IF;
				masterhlock <= '0';
							
			WHEN others =>
				null;
		END CASE;
	END IF;
END PROCESS;

-- keeps track of which line is being displayed on the screen
line_count: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		line_counter <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		IF reset_line_counter = '1' THEN
			line_counter <= (others => '0');
		ELSIF start_transfer = '1' THEN
			line_counter <= line_counter + 1;
		END IF;
	END IF;
END PROCESS;

line_address_generator: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		current_line_address <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		-- Load the current_line_address with the base address of the current frame buffer
		-- whenever the vga driver is asserting the vertical blanking signal.
		IF dma_vblank = '0' THEN
			current_line_address <= buffer_address;
		-- Otherwise if we are starting a new line that is not the first line of a frame 
		-- we will keep the current address value.
		ELSIF end_transfer = '1' AND masterhbusreq_sig = '0' THEN
			current_line_address <= masterhaddr_sig;
		END IF;
	END IF;
END PROCESS;

-- Keep track of the number of burst we have read across the PLD-to-Stripe bridge
burst_count: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		burst_counter <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		IF end_transfer = '1' THEN
			burst_counter <= (others => '0');
		ELSIF incr_burst_counter = '1' THEN
			burst_counter <= burst_counter + 1;
		END IF;
	END IF;		
END PROCESS;

ahb_transactor_fsm: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		ahb_state <= idle;
		incr_burst_beat_counter <= '0';
	ELSIF rising_edge(masterhclk) THEN
		CASE ahb_state IS 
			WHEN idle =>
				-- Begin an AHB transaction if the DMA controller has been granted 
				-- the bus and if the control state machine has signalled that it 
				-- is beginning a transfer.
				IF start_transfer = '1' AND masterhgrant = '1' AND masterhready = '1' THEN
					ahb_state <= nonseq;
				-- Return to the nonseq state if we have been sent to the idle 
				-- state due to crossing a 1K boundary or if we had an hready timeout.
				ELSIF control_state = transmit_line AND masterhgrant = '1' AND masterhready = '1' THEN
					ahb_state <= nonseq;
				ELSE
					ahb_state <= idle;
				END IF;
				-- incr_burst_beat_counter is used to increment the burst beat 
				-- counter but it is also used as a wren signal for the video line
				-- buffer.  Therefore it is important to make sure that this signal 
				-- is high for the very last word of a line.  
				IF burst_beat_counter /= 0 AND burst_beat_counter /= 7 AND masterhready = '1' THEN
					incr_burst_beat_counter <= '1';
				ELSIF end_transfer = '1' THEN
					incr_burst_beat_counter <= '1';
				ELSE
					incr_burst_beat_counter <= '0';
				END IF;
			
			-- We can always transition to the seq state from the nonseq state.	
			WHEN nonseq =>
				IF burst_beat_counter /=7 AND burst_beat_counter /=0 AND masterhready = '1' THEN 
					incr_burst_beat_counter <= '1';
				ELSIF burst_beat_counter = 7 AND incr_burst_beat_counter = '0' AND masterhready = '1' THEN
					incr_burst_beat_counter <= '1';
				ELSE
					incr_burst_beat_counter <= '0';
				END IF;
				
				ahb_state <= seq;
										
			WHEN seq =>
				-- We will leave the seq state and transition to idle state if 
				-- we have reached the end of a line.
				IF end_transfer = '1' OR enable_dma = '0' THEN
					ahb_state <= idle;
				-- This case takes care of 1K boundaries.  We know that we need to 
				-- do a idle transfer if we have an address value of 0xXXXXX3FC as 
				-- the next address is a 1K boundary.
				ELSIF masterhaddr_sig(9 downto 0) = "11" & X"FC" THEN
					ahb_state <= idle;
				ELSE 
					ahb_state <= seq;
				END IF;		
				IF masterhready = '1' THEN
					incr_burst_beat_counter <= '1';
				ELSE
					incr_burst_beat_counter <= '0';
				END IF;
			WHEN others =>
				null;
		END CASE;
	END IF;
END PROCESS;

-- Decide when we should increment the masterhaddr signal and drive the htrans signal.
decode_ahb_transactor_fsm: PROCESS(ahb_state,masterhready,masterhgrant,masterhbusreq_sig,control_state,masterhaddr_sig)
BEGIN
	CASE ahb_state IS
		WHEN idle =>
			masterhtrans <= "00";  -- idle 
			IF masterhready = '1' AND masterhgrant = '1' AND masterhbusreq_sig = '1' AND masterhaddr_sig(4 downto 0) = '1' & X"C" THEN
				incr_masterhaddr_sig <= '1';
			ELSE
				incr_masterhaddr_sig <= '0';
			END IF;

		-- We are never in the nonseq state for more than one consecutive clock cycle so we
		-- can always increment the haddr signal when in this state.
		WHEN nonseq =>
			masterhtrans <= "10";  -- nonseq
			incr_masterhaddr_sig <= '1';

		WHEN seq =>
			masterhtrans <= "11";  -- seq
			IF masterhready = '1' AND masterhgrant = '1' AND masterhbusreq_sig = '1' THEN
				incr_masterhaddr_sig <= '1';			
			ELSE
				incr_masterhaddr_sig <= '0';				
			END IF;
	END CASE;
END PROCESS;

-- Generate the address to send to the bridge.  The address should be incremented by 4 if we are in
-- any state other than the idle state and the slave has asserted the masterhready signal.
masterhaddr_sig_generator: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		masterhaddr_sig <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		IF start_transfer = '1' THEN  
			masterhaddr_sig <= current_line_address;  
		ELSE
			IF incr_masterhaddr_sig = '1' THEN
				masterhaddr_sig <= masterhaddr_sig + 4;
			END IF;
		END IF;
	END IF;
END PROCESS;


-- Keep track of the number of beats within a burst transfer.  An XA10 will send 8 beats in a burst
-- whereas an XA1 will only send 4.  This counter counts 8 bursts but it will work for both XA1 and 
-- XA10 devices.
burst_beat_counter_generator: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		burst_beat_counter <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		IF burst_beat_counter = 7 AND incr_burst_beat_counter = '1' THEN
			burst_beat_counter <= (others => '0');
		ELSIF incr_burst_beat_counter = '1' THEN
			burst_beat_counter <= burst_beat_counter + 1;
		END IF;
	END IF;
END PROCESS;

-- here is yet another counter.  This one is used to index the addresses into the line buffer.  
-- It should be incremented whenver the incr_burst_beat_counter is active and it should reset when
-- we hit the last horizontal line.
rx_buffer_index: PROCESS(masterhclk,reset_n)
BEGIN
	IF reset_n = '0' THEN
		rx_buffer_wraddress_sig <= (others => '0');
	ELSIF rising_edge(masterhclk) THEN
		IF rx_buffer_wraddress_sig = (num_words_per_line-1) AND incr_burst_beat_counter = '1' THEN
			rx_buffer_wraddress_sig <= (others => '0');
		ELSIF incr_burst_beat_counter = '1' THEN
			rx_buffer_wraddress_sig <= rx_buffer_wraddress_sig + 1;
		END IF;
	END IF;
END PROCESS;

dma_data <= buffered_hrdata;
dma_data_valid <= incr_burst_beat_counter;

END rtl;