
`timescale 1ns/10ps

module TbSSP;

parameter CKP1 = 10;	// 50MHz

parameter DLY  = 0.2;

reg			PRESETn, PCLK;
reg         PENABLE;
reg  	 	PSEL;
reg         PWRITE;
reg  [11:2] PADDR;
reg  [31:0] PWDATA;
wire [31:0] PRDATA;

reg			SSPTXDMACLR;
wire		SSPTXDMASREQ, SSPTXDMABREQ;

reg			SSPRXDMACLR;
wire		SSPRXDMASREQ, SSPRXDMABREQ;

wire        SSPFSSOUT;       // Serial Frame Output pin
wire        SSPCLKOUT;       // Serial Clock Output pin
wire        SSPTXD;          // SSP Serial Transmit output
wire		SSPRXD;
reg			SSPFSSIN, SSPCLKIN;

`include "./include/PeriRWTask.v"
//------------------------------------------------------------------------------
Ssp Ssp(
				.PCLK				(PCLK),
				.PRESETn			(PRESETn),
    			.PSEL				(PSEL), 
    			.PENABLE			(PENABLE), 
    			.PADDR				(PADDR), 
    			.PWRITE				(PWRITE), 
    			.PWDATA				(PWDATA[15:0]), 
				.PRDATA				(PRDATA),
				
				.SSPTXDMACLR		(SSPTXDMACLR),
            	.SSPRXDMACLR		(SSPRXDMACLR),
            	
            	.SSPTXDMABREQ		(SSPTXDMABREQ),
            	.SSPRXDMABREQ		(SSPRXDMABREQ),
            	
            	.SSPFSSOUT			(SSPFSSOUT), 
            	.SSPCLKOUT			(SSPCLKOUT),
            	.SSPTXD	  			(SSPTXD),
            	.SSPRXD				(SSPRXD), 
            	.SSPFSSIN			(SSPFSSIN), 
            	.SSPCLKIN			(SSPCLKIN)
);

spi_slave_model spi_slave (
				.csn				(SSPFSSOUT),
				.sck				(SSPCLKOUT),
				.di 				(SSPTXD),
				.do 				(SSPRXD)
);
//-------------------------------------------------------------------------------
always #CKP1 PCLK = ~PCLK;
//-------------------------------------------------------------------------------
// Initialize
initial begin
  PRESETn = 1;
  PCLK    = 0;
  
  SSPTXDMACLR = 0;
  SSPRXDMACLR = 0;
  
  SSPFSSIN = 1;
  SSPCLKIN = 0;
end
//-------------------------------------------------------------------------------
integer i;
// Main Routine
initial begin
  	repeat(10) @(posedge PCLK);
    PRESETn = 1'b0;
  	repeat(10) @(posedge PCLK);
  	#(3) PRESETn = 1'b1;
  	$display ("Reset Disabled, Simulation Start NOW >>>");
  	repeat(10) @(posedge PCLK);

	APBWrite('h0, 16'h00f);	// SPI 16bit
	APBWrite('h4, 16'h03);		// SSP Enable, Loop Back
	APBWrite('h10, 16'd50);	// Clock Prescale -> 1MHz
	APBWrite('h24, 3);		// SSP TX/RX DMA Enable

	APBWrite('h8, 16'h0000);	// SSP Data Write
	APBWrite('h8, 16'hffff);	// SSP Data Write
	APBWrite('h8, 16'haaaa);	// SSP Data Write
	APBWrite('h8, 16'h5555);	// SSP Data Write
	APBWrite('h8, 16'haa55);	// SSP Data Write
	APBWrite('h8, 16'h55aa);	// SSP Data Write
	APBWrite('h8, 16'h00FF);	// SSP Data Write
	APBWrite('h8, 16'hff00);	// SSP Data Write
//	APBWrite('h8, 16'h5a5a);	// SSP Data Write
  	repeat(10000) @(posedge PCLK);

  	wait(SSPRXDMABREQ);
	for(i=0;i<8;i=i+1) begin
	APBRead('h8);
	end
	SSPRXDMACLR = 1;
  	repeat(1000) @(posedge PCLK);
	SSPRXDMACLR = 0;

/*
	APBWrite('h0, 16'h007);	// SPI 8bit
	APBWrite('h4, 16'h02);		// SSP Enable

// Write
	wait(SSPTXDMABREQ);
	for(i=0;i<8;i=i+1) begin
	APBWrite('h8, i);	// SSP Data Write
	end
	SSPTXDMACLR = 1;
  	repeat(6000) @(posedge PCLK);

  	wait(SSPRXDMABREQ);
	for(i=0;i<8;i=i+1) begin
	APBRead('h8);
	end  	

// Read
	for(i=0;i<8;i=i+1) begin
	APBWrite('h8, ~i);	// SSP Data Write
	end
  	repeat(6000) @(posedge PCLK);

  	wait(SSPRXDMABREQ);
	for(i=0;i<8;i=i+1) begin
	APBRead('h8);
	end
	SSPRXDMACLR = 1;
*/

  	repeat(300) @(posedge PCLK);
  	$stop;
end
//-------------------------------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("../Syn/Sdf/Ssp.noscan.sdf", Ssp);
`endif
//------------------------------------------------------
`ifdef WAVE
initial begin
  $shm_open("TbSSP.shm");
  $shm_probe(TbSSP, "ASC");
end
`endif
//------------------------------------------------------
endmodule
