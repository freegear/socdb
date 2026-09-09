LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE video_components IS

COMPONENT vga_pll PORT (
	inclock : IN std_logic;
	clock1 : OUT std_logic
);
END COMPONENT;

COMPONENT vga_driver  
	PORT (
		reset_n		: IN std_logic;
		clock25		: IN std_logic;
		enable		: IN std_logic;
		mode		: IN std_logic;

		-- video memory signals
		video_data	: IN std_logic_vector(31 downto 0);
		video_address	: OUT std_logic_vector(31 downto 0);
		
		num_lines		: IN std_logic_vector(9 downto 0);
		num_pixels_per_line	: IN std_logic_vector(9 downto 0);

		-- blanking and clock outputs to any logic that could use it
		hblank		: OUT std_logic;
		vblank		: OUT std_logic;

		-- outputs to VGA daughter card
		clockext	: OUT std_logic;
		vsync		: OUT std_logic;
		hsync		: OUT std_logic;
		sync_n			: OUT std_logic;
		sync_t			: OUT std_logic;
		blank_n			: OUT std_logic;
		M1			: OUT std_logic;
		M2			: OUT std_logic;
		R		: OUT std_logic_vector(7 downto 0);
		G		: OUT std_logic_vector(7 downto 0);
		B		: OUT std_logic_vector(7 downto 0)
	);
END COMPONENT;

COMPONENT line_buffer 
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wraddress	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		wren		: IN STD_LOGIC  := '1';
		rden		: IN STD_LOGIC  := '1';
		wrclock		: IN STD_LOGIC ;
		rdclock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT slave_interface 
	PORT (
	
		-- AHB interface
		hresetn		: IN std_logic;
		hclock		: IN std_logic;
		hwrite		: IN std_logic;
		hsel		: IN std_logic;
		htrans		: IN std_logic_vector(1 downto 0);
		hsize		: IN std_logic_vector(1 downto 0);
		hburst		: IN std_logic_vector(2 downto 0);
		haddress	: IN std_logic_vector(31 downto 0);
		hwdata		: IN std_logic_vector(31 downto 0);
		hready		: OUT std_logic;
		hresp		: OUT std_logic_vector(1 downto 0);
		hrdata		: OUT std_logic_vector(31 downto 0);
		
		-- Inteface to DMA Controller and VGA Driver
		status			: IN std_logic_vector(31 downto 0);
		current_address		: IN std_logic_vector(31 downto 0);
		buffer_address	: OUT std_logic_vector(31 downto 0);
		image_dimensions	: OUT std_logic_vector(31 downto 0);
		control			: OUT std_logic_vector(31 downto 0)
		);
END COMPONENT;

COMPONENT default_slave 
	PORT (
		hclock		: IN std_logic;
		hresetn		: IN std_logic;
		hsel		: IN std_logic;
		htrans		: IN std_logic_vector(1 downto 0);
		hready		: OUT std_logic;
		hresp		: OUT std_logic_vector(1 downto 0);
		hrdata		: OUT std_logic_vector(31 downto 0)	
	);
END COMPONENT;

COMPONENT response_and_data_mux 
	PORT (
	-- system signals
	hclock			: IN std_logic;
	hresetn			: IN std_logic;

	-- slave iface signals
	hsel_slave_iface	: IN std_logic;
	hready_slave_iface	: IN std_logic;
	hresp_slave_iface	: IN std_logic_vector(1 downto 0);
	hrdata_slave_iface	: IN std_logic_vector(31 downto 0);

	-- default slave signals
	hsel_default_slave	: IN std_logic;
	hready_default_slave	: IN std_logic;
	hresp_default_slave	: IN std_logic_vector(1 downto 0);

	-- outputs to bridge
	hready			: OUT std_logic;
	hresp			: OUT std_logic_vector(1 downto 0);
	hrdata			: OUT std_logic_vector(31 downto 0));	
END COMPONENT;

COMPONENT slave_decoder PORT 
	(
	-- bridge signals
	hbusreq			: IN std_logic;
	haddr			: IN std_logic_vector(31 downto 0);

	-- outputs to slave iface
	hsel_slave_iface	: OUT std_logic;
	hsel_default_slave	: OUT std_logic
	);
END COMPONENT;

COMPONENT system_pll 
	PORT
	(
		inclock		: IN STD_LOGIC ;
		clock0		: OUT STD_LOGIC ;
		clock1		: OUT STD_LOGIC 
	);
END COMPONENT;

COMPONENT video_dma_controller 
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
	set_irq			: OUT std_logic;
	buffer_select		: OUT std_logic; 
	dma_data		: OUT std_logic_vector(31 downto 0);
	rx_buffer_wraddress	: OUT std_logic_vector(9 downto 0);
	dma_data_valid		: OUT std_logic
	);
END COMPONENT;

COMPONENT video_dma 
	PORT 
	(
		-- System signals
		reset_n				: IN std_logic;
		hclock				: IN std_logic;		-- clock to the AHM master interace
		clock25				: IN std_logic;		-- clock to the VGA driver
		clock50				: IN std_logic;		-- clock to the slave interface and VGA driver

		--Slave Interface signals
		siface_hsel			: IN std_logic;
		siface_hwrite_from_stripe	: IN std_logic;
		siface_hbusreq_from_stripe	: IN std_logic;
		siface_htrans_from_stripe	: IN std_logic_vector(1 downto 0);
		siface_hsize_from_stripe	: IN std_logic_vector(1 downto 0);
		siface_hburst_from_stripe	: IN std_logic_vector(2 downto 0);
		siface_haddress_from_stripe	: IN std_logic_vector(31 downto 0);
		siface_hwdata_from_stripe	: IN std_logic_vector(31 downto 0);
		siface_hready_to_stripe		: OUT std_logic;
		siface_hresp_to_stripe		: OUT std_logic_vector(1 downto 0);
		siface_hrdata_to_stripe		: OUT std_logic_vector(31 downto 0);

		-- DMA Controller Master Interface signals
		miface_hready_from_stripe	: IN std_logic;
		miface_hgrant_from_stripe	: IN std_logic;
		irq				: OUT std_logic;  -- this is currently not used
		miface_hlock_to_stripe		: OUT std_logic;
		miface_hbusreq_to_stripe	: OUT std_logic;
		miface_htrans_to_stripe		: OUT std_logic_vector(1 downto 0);
		miface_hsize_to_stripe		: OUT std_logic_vector(1 downto 0);
		miface_hburst_to_stripe		: OUT std_logic_vector(2 downto 0);
		miface_hwdata_to_stripe		: OUT std_logic_vector(31 downto 0);
		miface_hrdata_from_stripe	: IN std_logic_vector(31 downto 0);
		miface_haddr_to_stripe		: OUT std_logic_vector(31 downto 0);

		-- VGA outputs
		vga_clk				: OUT std_logic;
		vsync				: OUT std_logic;
		hsync				: OUT std_logic;
		sync_n			: OUT std_logic;
		sync_t			: OUT std_logic;
		blank_n			: OUT std_logic;
		M1			: OUT std_logic;
		M2			: OUT std_logic;
		R				: OUT std_logic_vector(7 downto 0);
		G				: OUT std_logic_vector(7 downto 0);
		B				: OUT std_logic_vector(7 downto 0)
	);
END COMPONENT;

COMPONENT stripe 
	PORT (
		clk_ref	: IN	STD_LOGIC;
		npor	: IN	STD_LOGIC;
		nreset	: INOUT	STD_LOGIC;
		uartrxd	: IN	STD_LOGIC;
		uartdsrn	: IN	STD_LOGIC;
		uartctsn	: IN	STD_LOGIC;
		uartrin	: INOUT	STD_LOGIC;
		uartdcdn	: INOUT	STD_LOGIC;
		uarttxd	: OUT	STD_LOGIC;
		uartrtsn	: OUT	STD_LOGIC;
		uartdtrn	: OUT	STD_LOGIC;
		intextpin	: IN	STD_LOGIC;
		ebiack	: IN	STD_LOGIC;
		ebidq	: INOUT	STD_LOGIC_VECTOR(15 downto 0);
		ebiclk	: OUT	STD_LOGIC;
		ebiwen	: OUT	STD_LOGIC;
		ebioen	: OUT	STD_LOGIC;
		ebiaddr	: OUT	STD_LOGIC_VECTOR(24 downto 0);
		ebibe	: OUT	STD_LOGIC_VECTOR(1 downto 0);
		ebicsn	: OUT	STD_LOGIC_VECTOR(3 downto 0);
		sdramdq	: INOUT	STD_LOGIC_VECTOR(15 downto 0);
		sdramdqs	: INOUT	STD_LOGIC_VECTOR(1 downto 0);
		sdramclk	: OUT	STD_LOGIC;
		sdramclkn	: OUT	STD_LOGIC;
		sdramclke	: OUT	STD_LOGIC;
		sdramwen	: OUT	STD_LOGIC;
		sdramcasn	: OUT	STD_LOGIC;
		sdramrasn	: OUT	STD_LOGIC;
		sdramaddr	: OUT	STD_LOGIC_VECTOR(14 downto 0);
		sdramcsn	: OUT	STD_LOGIC_VECTOR(1 downto 0);
		sdramdqm	: OUT	STD_LOGIC_VECTOR(1 downto 0);
		slavehclk	: IN	STD_LOGIC;
		slavehwrite	: IN	STD_LOGIC;
		slavehreadyi	: IN	STD_LOGIC;
		slavehselreg	: IN	STD_LOGIC;
		slavehsel	: IN	STD_LOGIC;
		slavehmastlock	: IN	STD_LOGIC;
		slavehaddr	: IN	STD_LOGIC_VECTOR(31 downto 0);
		slavehtrans	: IN	STD_LOGIC_VECTOR(1 downto 0);
		slavehsize	: IN	STD_LOGIC_VECTOR(1 downto 0);
		slavehburst	: IN	STD_LOGIC_VECTOR(2 downto 0);
		slavehwdata	: IN	STD_LOGIC_VECTOR(31 downto 0);
		slavehreadyo	: OUT	STD_LOGIC;
		slavebuserrint	: OUT	STD_LOGIC;
		slavehresp	: OUT	STD_LOGIC_VECTOR(1 downto 0);
		slavehrdata	: OUT	STD_LOGIC_VECTOR(31 downto 0);
		masterhclk	: IN	STD_LOGIC;
		masterhready	: IN	STD_LOGIC;
		masterhgrant	: IN	STD_LOGIC;
		masterhrdata	: IN	STD_LOGIC_VECTOR(31 downto 0);
		masterhresp	: IN	STD_LOGIC_VECTOR(1 downto 0);
		masterhwrite	: OUT	STD_LOGIC;
		masterhlock	: OUT	STD_LOGIC;
		masterhbusreq	: OUT	STD_LOGIC;
		masterhaddr	: OUT	STD_LOGIC_VECTOR(31 downto 0);
		masterhburst	: OUT	STD_LOGIC_VECTOR(2 downto 0);
		masterhsize	: OUT	STD_LOGIC_VECTOR(1 downto 0);
		masterhtrans	: OUT	STD_LOGIC_VECTOR(1 downto 0);
		masterhwdata	: OUT	STD_LOGIC_VECTOR(31 downto 0);
		intpld		: IN	STD_LOGIC_VECTOR(5 downto 0)
	);
END COMPONENT;

END video_components;