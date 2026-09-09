module asic_top_8051 (
		PI_clk, 
		PI_rst_p, 
		PI_int0, 
		PI_int1, 
		PI_t0, 
		PI_t1, 
		PI_rxd, 
        	PB_p1_io, 
		PO_rom_adr, 
		PI_rom_data, 
		PO_addr_xdat, 
		PB_xdat, 
		PO_txd, 
		PO_clkb, 
		PO_en_xdat, 
		PO_wr_xdat, 
		PO_rd_xdat 
		);

  input 	PI_clk, 
		PI_rst_p, 
		PI_int0, 
		PI_int1, 
		PI_t0, 
		PI_t1, 
		PI_rxd;
  inout	[7:0] 	PB_p1_io;
  output[15:0] 	PO_rom_adr;
  input [7:0] 	PI_rom_data;
  output[15:0] 	PO_addr_xdat;
  inout[7:0] 	PB_xdat;
  output 	PO_txd, 
		PO_clkb, 
		PO_en_xdat, 
		PO_wr_xdat,
		PO_rd_xdat;

  wire  	n0_clk, 
		n0_rst_p, 
		n0_int0, 
		n0_int1, 
		n0_t0, 
		n0_t1, 
		n0_rxd,
    		n0_p1_i,
    		n1_p1_i,
    		n2_p1_i,
    		n3_p1_i,
    		n4_p1_i,
    		n5_p1_i,
    		n6_p1_i,
    		n7_p1_i,
    		n0_p1_o,
    		n1_p1_o,
    		n2_p1_o,
    		n3_p1_o,
    		n4_p1_o,
    		n5_p1_o,
    		n6_p1_o,
    		n7_p1_o,
		n0_p1_en,
    		n1_p1_en,
    		n2_p1_en,
    		n3_p1_en,
    		n4_p1_en,
    		n5_p1_en,
    		n6_p1_en,
    		n7_p1_en,
         	n0_rom_adr,
         	n1_rom_adr,
         	n2_rom_adr,
         	n3_rom_adr,
         	n4_rom_adr,
         	n5_rom_adr,
         	n6_rom_adr,
         	n7_rom_adr,
         	n8_rom_adr,
         	n9_rom_adr,
         	n10_rom_adr,
         	n11_rom_adr,
         	n12_rom_adr,
         	n13_rom_adr,
         	n14_rom_adr,
         	n15_rom_adr,
         	n0_rom_data,
         	n1_rom_data,
         	n2_rom_data,
         	n3_rom_data,
         	n4_rom_data,
         	n5_rom_data,
         	n6_rom_data,
         	n7_rom_data,
               	n0_addr_xdat,
               	n1_addr_xdat,
               	n2_addr_xdat,
               	n3_addr_xdat,
               	n4_addr_xdat,
               	n5_addr_xdat,
               	n6_addr_xdat,
               	n7_addr_xdat,
               	n8_addr_xdat,
               	n9_addr_xdat,
               	n10_addr_xdat,
               	n11_addr_xdat,
               	n12_addr_xdat,
               	n13_addr_xdat,
               	n14_addr_xdat,
               	n15_addr_xdat,
             	n0_xdat_i,
             	n1_xdat_i,
             	n2_xdat_i,
             	n3_xdat_i,
             	n4_xdat_i,
             	n5_xdat_i,
             	n6_xdat_i,
             	n7_xdat_i,
             	n0_xdat_o,
             	n1_xdat_o,
             	n2_xdat_o,
             	n3_xdat_o,
             	n4_xdat_o,
             	n5_xdat_o,
             	n6_xdat_o,
             	n7_xdat_o,
                n0_txd, 
		n0_clkb, 
		n0_en_xdat, 
		n0_wr_xdat,
		n0_rd_xdat;


  PDISDGZ U0_clk 	( .PAD(PI_clk), .C(n0_clk) );
 
  PDISDGZ U1_rst_p 	( .PAD(PI_rst_p), .C(n0_rst_p) );

  PDISDGZ U2_int0   	( .PAD(PI_int0), .C(n0_int0) );
  PDISDGZ U3_int1	( .PAD(PI_int1), .C(n0_int1) );

  PDISDGZ U4_t0         ( .PAD(PI_t0), .C(n0_t0) );
  PDISDGZ U5_t1         ( .PAD(PI_t1), .C(n0_t1) );

  PDISDGZ U6_rxd        ( .PAD(PI_rxd), .C(n0_rxd) );

  PDB24DGZ U7_p1        ( .I(n0_p1_o), .OEN(n7_p1_en), .PAD(PB_p1_io[7]), .C(n7_p1_i) );
  PDB24DGZ U8_p1        ( .I(n1_p1_o), .OEN(n6_p1_en), .PAD(PB_p1_io[6]), .C(n6_p1_i) );
  PDB24DGZ U9_p1        ( .I(n2_p1_o), .OEN(n5_p1_en), .PAD(PB_p1_io[5]), .C(n5_p1_i) );
  PDB24DGZ U10_p1       ( .I(n3_p1_o), .OEN(n4_p1_en), .PAD(PB_p1_io[4]), .C(n4_p1_i) );
  PDB24DGZ U11_p1       ( .I(n4_p1_o), .OEN(n3_p1_en), .PAD(PB_p1_io[3]), .C(n3_p1_i) );
  PDB24DGZ U12_p1       ( .I(n5_p1_o), .OEN(n2_p1_en), .PAD(PB_p1_io[2]), .C(n2_p1_i) );
  PDB24DGZ U13_p1       ( .I(n6_p1_o), .OEN(n1_p1_en), .PAD(PB_p1_io[1]), .C(n1_p1_i) );
  PDB24DGZ U14_p1       ( .I(n7_p1_o), .OEN(n0_p1_en), .PAD(PB_p1_io[0]), .C(n0_p1_i) );

  PDO24CDG U15_txd      ( .I(n0_txd), .PAD(PO_txd) );

  PDO24CDG U16_rom_addr ( .I(n15_rom_adr), .PAD(PO_rom_adr[15]) );
  PDO24CDG U17_rom_addr ( .I(n14_rom_adr), .PAD(PO_rom_adr[14]) );
  PDO24CDG U18_rom_addr ( .I(n13_rom_adr), .PAD(PO_rom_adr[13]) );
  PDO24CDG U19_rom_addr ( .I(n12_rom_adr), .PAD(PO_rom_adr[12]) );
  PDO24CDG U20_rom_addr ( .I(n11_rom_adr), .PAD(PO_rom_adr[11]) );
  PDO24CDG U21_rom_addr ( .I(n10_rom_adr), .PAD(PO_rom_adr[10]) );
  PDO24CDG U22_rom_addr ( .I(n9_rom_adr),  .PAD(PO_rom_adr[9]) );
  PDO24CDG U23_rom_addr ( .I(n8_rom_adr),  .PAD(PO_rom_adr[8]) );
  PDO24CDG U24_rom_addr ( .I(n7_rom_adr),  .PAD(PO_rom_adr[7]) );
  PDO24CDG U25_rom_addr ( .I(n6_rom_adr),  .PAD(PO_rom_adr[6]) );
  PDO24CDG U26_rom_addr ( .I(n5_rom_adr),  .PAD(PO_rom_adr[5]) );
  PDO24CDG U27_rom_addr ( .I(n4_rom_adr),  .PAD(PO_rom_adr[4]) );
  PDO24CDG U28_rom_addr ( .I(n3_rom_adr),  .PAD(PO_rom_adr[3]) );
  PDO24CDG U29_rom_addr ( .I(n2_rom_adr),  .PAD(PO_rom_adr[2]) );
  PDO24CDG U30_rom_addr ( .I(n1_rom_adr),  .PAD(PO_rom_adr[1]) );
  PDO24CDG U31_rom_addr ( .I(n0_rom_adr),  .PAD(PO_rom_adr[0]) );

  PDISDGZ  U32_rom_data ( .PAD(PI_rom_data[7]), .C(n7_rom_data) );
  PDISDGZ  U33_rom_data ( .PAD(PI_rom_data[6]), .C(n6_rom_data) );
  PDISDGZ  U34_rom_data ( .PAD(PI_rom_data[5]), .C(n5_rom_data) );
  PDISDGZ  U35_rom_data ( .PAD(PI_rom_data[4]), .C(n4_rom_data) );
  PDISDGZ  U36_rom_data ( .PAD(PI_rom_data[3]), .C(n3_rom_data) );
  PDISDGZ  U37_rom_data ( .PAD(PI_rom_data[2]), .C(n2_rom_data) );
  PDISDGZ  U38_rom_data ( .PAD(PI_rom_data[1]), .C(n1_rom_data) );
  PDISDGZ  U39_rom_data ( .PAD(PI_rom_data[0]), .C(n0_rom_data) );

  PDO24CDG U40_addr_xdat( .I(n15_addr_xdat), .PAD(PO_addr_xdat[15]) );
  PDO24CDG U41_addr_xdat( .I(n14_addr_xdat), .PAD(PO_addr_xdat[14]) );
  PDO24CDG U42_addr_xdat( .I(n13_addr_xdat), .PAD(PO_addr_xdat[13]) );
  PDO24CDG U43_addr_xdat( .I(n12_addr_xdat), .PAD(PO_addr_xdat[12]) );
  PDO24CDG U44_addr_xdat( .I(n11_addr_xdat), .PAD(PO_addr_xdat[11]) );
  PDO24CDG U45_addr_xdat( .I(n10_addr_xdat), .PAD(PO_addr_xdat[10]) );
  PDO24CDG U46_addr_xdat( .I(n9_addr_xdat), .PAD(PO_addr_xdat[9]) );
  PDO24CDG U47_addr_xdat( .I(n8_addr_xdat), .PAD(PO_addr_xdat[8]) );
  PDO24CDG U48_addr_xdat( .I(n7_addr_xdat), .PAD(PO_addr_xdat[7]) );
  PDO24CDG U49_addr_xdat( .I(n6_addr_xdat), .PAD(PO_addr_xdat[6]) );
  PDO24CDG U50_addr_xdat( .I(n5_addr_xdat), .PAD(PO_addr_xdat[5]) );
  PDO24CDG U51_addr_xdat( .I(n4_addr_xdat), .PAD(PO_addr_xdat[4]) );
  PDO24CDG U52_addr_xdat( .I(n3_addr_xdat), .PAD(PO_addr_xdat[3]) );
  PDO24CDG U53_addr_xdat( .I(n2_addr_xdat), .PAD(PO_addr_xdat[2]) );
  PDO24CDG U54_addr_xdat( .I(n1_addr_xdat), .PAD(PO_addr_xdat[1]) );
  PDO24CDG U55_addr_xdat( .I(n0_addr_xdat), .PAD(PO_addr_xdat[0]) );

  PDB24DGZ U56_xdat     ( .I(n7_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[7]), .C(n0_xdat_i) );
  PDB24DGZ U57_xdat     ( .I(n6_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[6]), .C(n1_xdat_i) );
  PDB24DGZ U58_xdat     ( .I(n5_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[5]), .C(n2_xdat_i) );
  PDB24DGZ U59_xdat     ( .I(n4_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[4]), .C(n3_xdat_i) );
  PDB24DGZ U60_xdat     ( .I(n3_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[3]), .C(n4_xdat_i) );
  PDB24DGZ U61_xdat     ( .I(n2_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[2]), .C(n5_xdat_i) );
  PDB24DGZ U62_xdat     ( .I(n1_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[1]), .C(n6_xdat_i) );
  PDB24DGZ U63_xdat     ( .I(n0_xdat_o), .OEN(n0_wr_xdat), .PAD(PB_xdat[0]), .C(n7_xdat_i) );

  PDO02CDG U64_clkb 	( .I(n0_clkb), .PAD(PO_clkb) );
  
  PDO24CDG U65_PO_en_xdat( .I(n0_en_xdat),  .PAD(PO_en_xdat) );
  PDO24CDG U66_PO_wr_xdat( .I(n0_wr_xdat),  .PAD(PO_wr_xdat) );
  PDO24CDG U67_PO_rd_xdat( .I(n0_rd_xdat),  .PAD(PO_rd_xdat) );

wire[7:0] test ;

assign test = 8'hff;

  pc8051_top U68_pc8051_top ( 
		.clk(n0_clk), 
		.rst_p(n0_rst_p), 
		.int0_i(n0_int0), 
		.int1_i(n0_int0), 
        	.all_t0_i(n0_t0), 
		.all_t1_i(n0_t1), 
		.all_rxd_i(n0_rxd), 
		.p1_i( {n7_p1_i,	 
			n6_p1_i,	
			n5_p1_i,	
			n4_p1_i,	
			n3_p1_i,	
			n2_p1_i,	
			n1_p1_i,	
			n0_p1_i}), 
       		.p1_o({ n7_p1_o,	 
			n6_p1_o,	
			n5_p1_o,	
			n4_p1_o,	
			n3_p1_o,	
			n2_p1_o,	
			n1_p1_o,	
			n0_p1_o}), 
		.p1_en({n7_p1_en,	 
			n6_p1_en,	
			n5_p1_en,	
			n4_p1_en,	
			n3_p1_en,	
			n2_p1_en,	
			n1_p1_en,	
			n0_p1_en}), 
		.all_txd_o(n0_txd), 
		.clkb(n0_clkb), 
		.rom_adr_o(
                       {n15_rom_adr,
                 	n14_rom_adr,
                 	n13_rom_adr,
                 	n12_rom_adr,
                 	n11_rom_adr,
                 	n10_rom_adr,
                 	n9_rom_adr,
                 	n8_rom_adr,
                 	n7_rom_adr,
                 	n6_rom_adr,
                 	n5_rom_adr,
                 	n4_rom_adr,
                 	n3_rom_adr,
                 	n2_rom_adr,
                 	n1_rom_adr,
                 	n0_rom_adr}),
		.rom_data_i(
		       {n7_rom_data,
                 	n6_rom_data,
                 	n5_rom_data,
                 	n4_rom_data,
                 	n3_rom_data,
                 	n2_rom_data,
                 	n1_rom_data,
                 	n0_rom_data}),
		.addr_xdat(
		       {n15_addr_xdat,
               	       	n14_addr_xdat,
               	       	n13_addr_xdat,
               	       	n12_addr_xdat,
               	       	n11_addr_xdat,
               	       	n10_addr_xdat,
               	       	n9_addr_xdat,
               	       	n8_addr_xdat,
               	       	n7_addr_xdat,
               	       	n6_addr_xdat,
               	       	n5_addr_xdat,
               	       	n4_addr_xdat,
               	       	n3_addr_xdat,
               	       	n2_addr_xdat,
               	       	n1_addr_xdat,
               	       	n0_addr_xdat}),
  	        .out_xdat(
                       {n7_xdat_o,
                        n6_xdat_o,
                   	n5_xdat_o,
                   	n4_xdat_o,
                   	n3_xdat_o,
                   	n2_xdat_o,
                   	n1_xdat_o,
                   	n0_xdat_o}), 
		.in_xdat_a(
		       {n7_xdat_i,
             	     	n6_xdat_i,
             	     	n5_xdat_i,
             	     	n4_xdat_i,
             	     	n3_xdat_i,
             	     	n2_xdat_i,
             	     	n1_xdat_i,
             	     	n0_xdat_i}),
		.en_xdat(n0_en_xdat), 
		.wr_xdat_d1(n0_wr_xdat), 
		.rd_xdat(n0_rd_xdat)  
		);

endmodule
