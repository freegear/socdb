// Copyright (C) 1991-2000 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.

`timescale 1 ns / 100 ps

module arm_top_tb ( );

// Parameter Definitions
`define	reset_width		80
`define reset_delay		100

`define	HRESET_width	20
`define	HRESET_delay	30

// System Clocks
`ifdef		clk_ref_period
`else
  `define	clk_ref_period	10
`endif

`define	HCLOCK_period	20
`define	log_file_name		"sim_log_file.txt"

// Test-bench declarations
reg  clk_ref;
reg  HCLOCK;
reg  HRESET;
tri1 nreset;     // bi-directional open-drain (ie. on-chip pull-up)
reg	npor;
// reg pld_state_en;

reg   DATA_A      ;
reg   DATA_B      ;
reg   DATA_C      ;
reg   DATA_D      ;
reg   DATA_AVAIL  ;


wire	Mwrite     		 ;
wire	hready     		 ;
wire	[31:0] masterhaddr  ;
wire	[2:0] burst  		 ;
wire	[1:0] size  		 ;
wire	[1:0] trans  		 ;
wire	[31:0] masterhwdata ;
wire	[31:0] masterhrdata ;
wire	[1:0] hresp  		 ;


// Clock generation and misc processes
// Drive main source clock at 50 MHz
initial
  begin
    clk_ref = 0;
    while (1) # (`clk_ref_period) clk_ref <= ~clk_ref;
  end

// Drive DPRAM clock at 25 MHz
initial
  begin
	HCLOCK = 0;
	while (1) # (`HCLOCK_period) HCLOCK <= ~HCLOCK; 
  end

// Main test processes
initial
  begin
	npor = 1;
	# (`reset_delay) npor = 0;	// Toggle external reset   
	$display("\n Processor Reset \n");
	# (`reset_width) npor = 1;    
   end

initial
  begin
	HRESET = 0;	// Toggle PLD reset
	# (`HRESET_delay) HRESET = 1;
	$display("\n PLD Reset \n");
	# (`HRESET_width) HRESET = 0;  
  end




initial

{ DATA_A,DATA_B,DATA_C,DATA_D} = 4'b0000 ;
always
begin 
#3600  { DATA_A,DATA_B,DATA_C,DATA_D} = 4'b0000 ; 
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b0010 ;  
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b0001 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1000 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1010 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1001 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b0100 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b0110 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1001 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1110 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1100 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1101 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1100 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1101 ;
#3600  { DATA_A,DATA_B,DATA_C,DATA_D}= 4'b1101 ;
end 

initial

DATA_AVAIL = 1'b0 ;
always
begin 

#1200  DATA_AVAIL = 1'b0 ;
#1200  DATA_AVAIL = 1'b1 ;
#1200  DATA_AVAIL = 1'b0 ;


end 

arm_top dut
(
        .clk_ref   ( clk_ref	),
	.npor      ( npor	),
	.ebiack    (  1'b0         ),
	.intextpin  ( 1'b0),
	.uartrxd    ( ),
	.uartdsrn   ( ),
	.uartctsn   ( ),
	.HCLOCK     ( HCLOCK     ),
	.HRESET     ( HRESET   ),
	.DATA_A     ( DATA_A      ),
	.DATA_B     ( DATA_B      ),
	.DATA_C     ( DATA_C      ),
	.DATA_D     ( DATA_D      ),
	.DATA_AVAIL ( DATA_AVAIL  ),
	.uartdtrn   (  ),
	.uarttxd    (  ),
	.uartrtsn   (   ),
	.ebiwen     (   ),
	.ebioen     (   ),
	.nreset     ( nreset	),
	.uartrin    (   ),
	.uartdcdn   (   ),
	.ebiaddr    (   ),
	.ebicsn     (   ),
	.ebidq      (   ),
	
	.Mwrite 		( Mwrite ),
	.masterhaddr  	( masterhaddr ),
	.burst  		( burst ),
	.size 			( size ),
	.trans  		( trans ),
	.masterhwdata  	( masterhwdata ),
	.hready			( hready ),
	.masterhrdata  	( masterhrdata ),
	.hresp    		( hresp )

	);
initial begin
	# 250000;
	$stop;
end

endmodule
