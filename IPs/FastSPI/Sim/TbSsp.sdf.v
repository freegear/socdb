`timescale 1ns/1ps
module TbSsp;

reg				PCLK	;
reg				PRESETn	;
reg				PENABLE	;
reg				PSEL    ;
reg				PWRITE  ;
reg		[4:0]	PADDR   ;
reg		[31:0]	PWDATA  ;
wire	[31:0]	PRDATA  ;

wire      		SSPINTR;   
wire			SSPRXD;
wire			SSPFSSIN;
wire			SSPCLKIN;


wire         	SSPFSSOUT; 
wire         	SSPCLKOUT; 

wire         	SSPTXD;    
wire         	nSSPOE;     
wire         	nSSPCTLOE;   

wire		   	TxDMAReq;
wire		   	RxDMAReq;



reg				CS;
// -----------------------------------------------------------------------------
// 



reg		[31:0]  REGVALUE;
reg		[31:0]  REGVALUE0;

parameter HALFCYCLE = 5; // 100MHz

initial 
	begin
$sdf_annotate("Ssp.noscan.sdf", TbSsp. Ssp);
		PCLK = 0;
		PRESETn = 0;
		PENABLE	= 0;
		PSEL	= 0;
		PADDR	= 0;
		PWDATA  = 0;
		PWRITE  = 0;
		CS		= 0;
		#100 PRESETn = 1;
	end

always 
 # HALFCYCLE PCLK = ~PCLK;

initial
	begin
	$display ("SPI Initial Value Check");

	#200 APB_READandCOMPARE(0,0);
	#200 APB_READandCOMPARE(1,32'h0000000f);
	#200 APB_READandCOMPARE(2,0);
	#200 APB_READandCOMPARE(3,32'h00000021);
	#200 APB_READandCOMPARE(4,0);
//	#200 APB_READandCOMPARE(5,0);
//	#200 APB_READandCOMPARE(6,0);
	#200 APB_READandCOMPARE(7,32'h00000072);

	$display ("SPI Initialize");
	#200 APB_WRITE(5'h01 , 32'h00000101);// 
	#200 APB_WRITE(5'h00 , 32'h00000008);// 
	// No DMA Mode

	#10000000
	#10 CS = 0;
	#1000
	#200 APB_WRITE(5'h05 , 32'h0000009f);// 
	#200 APB_WRITE(5'h05 , 32'h0000009f);// 
	#200 APB_WRITE(5'h05 , 32'h0000009f);// 
	#200 APB_WRITE(5'h05 , 32'h0000009f);// 
	#200 APB_WRITE(5'h05 , 32'h0000009f);// 
	#200 APB_WRITE(5'h05 , 32'h00000000);// 
	#200 APB_WRITE(5'h05 , 32'h00000000);// 
	#200 APB_WRITE(5'h05 , 32'h00000000);// dummy


	//#200 APB_READ(5);
	//#200 APB_READandCOMPARE(5,32'h01);
	//#200 APB_READandCOMPARE(5,32'h02);
/*

	#1000
	#10 CS = 0;
	#200 APB_WRITE(5'h05 , 32'h0000009f);// 
	#200 APB_WRITE(5'h05 , 32'h00000000);// 
	#200 APB_WRITE(5'h05 , 32'h00000000);// 
	#200 APB_WRITE(5'h05 , 32'h00000000);// dummy

*/
	//#200 APB_READ(5);
	//#200 APB_READandCOMPARE(5,32'h01);
	//#200 APB_READandCOMPARE(5,32'h02);
	//#200 APB_READandCOMPARE(5,32'h07);


	#10 CS = 1;



	end

always @(posedge SSPINTR) begin
	$display (" Interrupt Occur");
end

always @(posedge TxDMAReq) begin
	$display (" TXDMA REQUEST Occur");
end
always @(posedge RxDMAReq) begin
	$display (" RXDMA REQUEST Occur");
end


Ssp 	Ssp( 
// Inputs
           .PCLK		(PCLK), 
           .PRESETn		(PRESETn), 
           .PADDR		(PADDR), 
           .PSEL		(PSEL), 	
           .PENABLE		(PENABLE), 
           .PWRITE		(PWRITE),
           .PWDATA		(PWDATA), 

// Outputs 
           .SSPINTR		(SSPINTR), 

           .SSPRXD		(SSPRXD), 
           .SSPFSSIN	(SSPFSSIN), 
           .SSPCLKIN	(SSPCLKIN),

           .SSPFSSOUT	(SSPFSSOUT),
           .SSPCLKOUT	(SSPCLKOUT),

           .SSPTXD		(SSPTXD), 
           .nSSPOE		(nSSPOE), 
           .nSSPCTLOE	(nSSPCTLOE),

           .PRDATA 		(PRDATA),
		   .TxDMAReq	(TxDMAReq),
		   .RxDMAReq	(RxDMAReq)

           );


s25fl008a SPIMODEL
(
		.SCK      (SSPCLKOUT),
    	.SI       (SSPTXD),
    	.CSNeg    (CS),
    	.HOLDNeg  (1'b1),
    	.WNeg     (1'b1),
    	.SO		  (SSPRXD)
);



parameter DLY = 1;
task APB_READ;
input	[31:0]	Addr;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[4:0];
       			PENABLE = 1'b0;
       			PSEL    = 1'b1;
		       	PWRITE  = 1'b0;
       repeat(1) @(posedge PCLK);
	  	#DLY 	PENABLE = 1'b1;
       repeat(1) @(posedge PCLK);
		$display ("APB Register READ Value: %b\n",PRDATA);
		#DLY 	PENABLE = 1'b0;
				PSEL    = 1'b0;
       repeat(1) @(posedge PCLK);
	
end
endtask

task APB_READVALUE;
input	[31:0]	Addr;
output	[31:0]	Data;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[4:0];
       			PENABLE = 1'b0;
       			PSEL    = 1'b1;
		       	PWRITE  = 1'b0;
       repeat(1) @(posedge PCLK);
	  	#DLY 	PENABLE = 1'b1;
       repeat(1) @(posedge PCLK);
				Data = PRDATA;
		#DLY 	PENABLE = 1'b0;
				PSEL    = 1'b0;
       repeat(1) @(posedge PCLK);
end
endtask
	






task APB_READandCOMPARE;
input	[31:0]	Addr;
input	[31:0]	Data;
begin
		@(posedge PCLK);
  		#DLY 	PADDR   = Addr[4:0];
       			PENABLE = 1'b0;
       			PSEL    = 1'b1;
		       	PWRITE  = 1'b0;
       repeat(1) @(posedge PCLK);
	  	#DLY 	PENABLE = 1'b1;
       repeat(1) @(posedge PCLK);
		$display ("APB Register READ Value: %b\n",PRDATA);
			if (PRDATA!=Data)
			begin
			$display ("Not Matched\n");
			$Finish;
			end 
		#DLY 	PENABLE = 1'b0;
				PSEL    = 1'b0;
       repeat(1) @(posedge PCLK);
end
endtask	

task APB_WRITE;
input	[31:0]	Addr;
input	[31:0]	Wdata;
begin
		@(posedge PCLK);
		#DLY 	PADDR   = Addr[4:0];
	 			PWDATA  = Wdata;
	 			PENABLE = 1'b0;
	 			PSEL    = 1'b1;
	 			PWRITE  = 1'b1;
	 repeat(1) @(posedge PCLK);
		#DLY 	PENABLE = 1'b1;
	 repeat(1) @(posedge PCLK);
		#DLY 	PENABLE = 1'b0;
	 			PSEL    = 1'b0;
	 repeat(1) @(posedge PCLK);
end
endtask

endmodule
