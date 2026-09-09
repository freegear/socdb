`timescale 1ns/10ps
module tbSPI;

reg	 PCLK ;
reg  PRESETn;
reg  [9:0]PADDR;
reg  PSEL;
reg  PENABLE;
reg  PWRITE;
reg  [15:0]	PWDATA;

// Outputs 
wire	SSPINTR;

wire	SSPRXD;
reg	SSPFSSIN;
reg	SSPCLKIN;

wire	SSPFSSOUT;
wire	SSPCLKOUT;

wire	SSPTXD;
wire    nSSPOE;
wire    nSSPCTLOE;

wire [31:0]	PRDATA;
wire	RxDMAReq;
wire    TxDMAReq;
reg	ChipEn;
reg	Hold;
reg	WriteEnable;


`define MODEL1

`ifdef MODEL0 
spi_slave_model spi_slave ( 

				.csn (SSPFSSOUT),
                .sck (SSPCLKOUT),  
                .di  (SSPTXD), 
                .do  (SSPRXD)
);     
`endif 

`ifdef MODEL1
s25fl008a SPI_model
(
    .SCK     (SSPCLKOUT) ,
    .SI      (SSPTXD) ,
    .CSNeg   (ChipEn) , // Chip select
    .HOLDNeg (Hold) ,
    .WNeg    (WriteEnable)	,
    .SO		 (SSPRXD)
);
`endif 

Ssp SPI(
// Inputs
           .PCLK		(PCLK		),
           .PRESETn		(PRESETn	),
           .PADDR		(PADDR		),
           .PSEL		(PSEL		),
           .PENABLE		(PENABLE	),
           .PWRITE		(PWRITE		),
           .PWDATA		(PWDATA		),

// Outputs 
           .SSPINTR		(SSPINTR 	),

           .SSPRXD		(SSPRXD		), 
           .SSPFSSIN	(SSPFSSIN	), 
           .SSPCLKIN	(SSPCLKIN	),

           .SSPFSSOUT	(SSPFSSOUT	), 
           .SSPCLKOUT	(SSPCLKOUT	),

           .SSPTXD		(SSPTXD		),
           .nSSPOE		(nSSPOE		), 
           .nSSPCTLOE	(nSSPCTLOE	),

           .PRDATA		(PRDATA		),
           .TxDMAReq	(TxDMAReq	),
		   .RxDMAReq	(RxDMAReq	)
           );


parameter SPICON     = 32'h0; 
parameter SPIPRE     = 32'h4;
parameter SPISTA     = 32'h8;
parameter SPIINTDMA  = 32'hc;
parameter SPIINTSTA  = 32'h10;
parameter SPITXDAT   = 32'h14;
parameter SPIRXDAT   = 32'h18;
parameter SPIHIDDEN  = 32'h1c;


//===============================================
//---------------SPICON Register Bit-------------
parameter Enable 		= 16'b0000000000001000;
parameter MasterSlave 	= 16'b0000000000000100;
parameter CPHA 			= 16'b0000000000000010;
parameter CPOL 			= 16'b0000000000000001;

//===============================================
//---------------SPIPRE Register Bit-------------
parameter PreScalVal 	= 16'b0000000011111111;
parameter DivVal	 	= 16'b1111111100000000;

//===============================================
//---------------SPISTA Register Bit-------------
parameter TxFIFOFull	= 16'b0000000000100000;
parameter TxFIFOEmpty	= 16'b0000000000010000;
parameter RxFIFOFull 	= 16'b0000000000001000;
parameter RxFIFOEmpty	= 16'b0000000000000100;
parameter Busy			= 16'b0000000000000010;
parameter Error			= 16'b0000000000000001;

//===============================================
//---------------SPIINTDMA Register Bit----------
parameter TxFIFOInt		= 16'b0010000000000000;
parameter RxFIFOInt 	= 16'b0001000000000000;
parameter RxTimeOutInt	= 16'b0000100000000000;
parameter RxOverrunInt	= 16'b0000010000000000;
parameter TxDMAEnable	= 16'b0000001000000000;
parameter TxDMALevel	= 16'b0000000111100000;
parameter RxDMAEnable	= 16'b0000000000010000;
parameter RxDMALevel	= 16'b0000000000001111;

//===============================================
//---------------SPIINTSTA Register Bit----------
parameter RTIC 				= 16'b0000000000100000;
parameter RORIC 			= 16'b0000000000010000;
parameter TxFIFOIntSta		= 16'b0000000000001000;
parameter RxFIFOIntSta		= 16'b0000000000000100;
parameter RxTimeOutIntSta	= 16'b0000000000000010;
parameter RxOverrunIntSta	= 16'b0000000000000001;

//===============================================
//---------------SPITXDAT Register Bit-----------
parameter TxDat 		= 16'b1111111111111111;

//===============================================
//---------------SPIRXDAT Register Bit-----------
parameter RxDat 		= 16'b1111111111111111;

//===============================================
//---------------SPIHIDDEN Register Bit-----------
parameter DataSize 		= 16'b0000000011110000;
parameter DataSize8 		= 16'b0000000001110000;
parameter Mode	 		= 16'b0000000000001100;
parameter SlaveOutEn	= 16'b0000000000000010;
parameter LBM	 		= 16'b0000000000000001;


parameter CKP = 5;

always #CKP PCLK = ~PCLK;

`include "./Include/PeriRWTask.v"
initial begin
  PRESETn = 1;
  PCLK    = 0;	
  SSPFSSIN = 0;
  SSPCLKIN = 0;
  ChipEn   = 1;
  Hold     = 1;
  WriteEnable =1;
end

initial begin
  	repeat(10) @(posedge PCLK);
    PRESETn = 1'b0;
  	repeat(10) @(posedge PCLK);
  	#(3) PRESETn = 1'b1;
  	$display ("Reset Disabled, Simulation Start NOW >>>");
  	repeat(10) @(posedge PCLK);

  	$display ("Check Register Initial Value ");
  	$display ("SPICON initial Value: ");
	APBRead(SPICON);	// SPI 16bit
	APBRead(SPIPRE);	// SPI 16bit
	APBRead(SPISTA);	// SPI 16bit
	APBRead(SPIINTDMA);	// SPI 16bit
	APBRead(SPIINTSTA);	// SPI 16bit
	APBRead(SPITXDAT);	// SPI 16bit
	//APBRead(SPIRXDAT);	// SPI 16bit
	APBRead(SPIHIDDEN);	// SPI 16bit


  	//$display ("SPI LoopBack Test ");
	$display ("Hidden Register Setting ");
	APBWrite (SPIHIDDEN, /*LBM|*/DataSize8); // DataSize == 16
  	$display ("Prescaler Setting ");
	APBWrite(SPIPRE, 16'h08F4);	

  	//$display ("Control Register Setting ");
	//APBWrite(SPICON, Enable|CPHA|CPOL );	// SPI 16bit

  	$display ("Interrupt & DMA Setting ");
	APBWrite(SPIINTDMA, TxFIFOInt|RxFIFOInt|
				RxTimeOutInt|RxOverrunInt|
				TxDMAEnable|RxDMAEnable|((4'b0010)<<5)|
				((4'b0010)<<1)

							);	// SPI 16bit

  	$display ("Writing Transmit Data ");
	APBWrite(SPITXDAT, 16'd0);	
	APBWrite(SPITXDAT, 16'd1);	
	APBWrite(SPITXDAT, 16'd2);	
	APBWrite(SPITXDAT, 16'd3);	
	APBWrite(SPICON, Enable|CPHA|CPOL );	// SPI 16bit
	APBWrite(SPITXDAT, 16'd4);	
	APBWrite(SPITXDAT, 16'd5);	
	APBWrite(SPITXDAT, 16'd6);	
	APBWrite(SPITXDAT, 16'd7);	
	APBWrite(SPIINTSTA, RTIC|RORIC);	


//  	repeat(10000) @(posedge PCLK);
    repeat(48) @(posedge SSPCLKOUT);
	APBWrite(SPITXDAT, 16'h55);	
	APBRead(SPIRXDAT); // ReadData
	APBRead(SPIRXDAT); // ReadData
	APBRead(SPIRXDAT); // ReadData
	APBRead(SPIRXDAT); // ReadData
	APBRead(SPIRXDAT); // ReadData
/*	APBWrite(SPITXDAT, 16'd7);	
	APBWrite(SPITXDAT, 16'd8);	
	APBWrite(SPITXDAT, 16'd9);	
	APBWrite(SPITXDAT, 16'd10);	
	APBWrite(SPITXDAT, 16'd11);	
	APBWrite(SPITXDAT, 16'd12);	
	APBWrite(SPITXDAT, 16'd13);	
	APBWrite(SPITXDAT, 16'd14);	
	APBWrite(SPITXDAT, 16'd15);	
	APBWrite(SPITXDAT, 16'd16);	
	APBWrite(SPITXDAT, 16'd17);	
	APBWrite(SPITXDAT, 16'd18);	
	APBWrite(SPITXDAT, 16'd19);	
*/

    repeat(12) @(posedge SSPCLKOUT);
	#4000000
	APBRead(SPIRXDAT); // ReadData // Rx overrun이 발생하면 동작을 하지 않게 된다.

	#1000
	ChipEn = 1'b0;
//--------------------------------------------------------
  	$display ("SPI Memory Test");
	APBWrite(SPITXDAT, 16'h009F); // Device ID Read
    repeat(8) @(posedge SSPCLKOUT);
	APBWrite(SPITXDAT, 16'h0000); // Dummy Byte Write
	APBWrite(SPITXDAT, 16'h0000); // Dummy Byte Write
	APBWrite(SPITXDAT, 16'h0000); // Dummy Byte Write

    repeat(24) @(posedge SSPCLKOUT);
  	$display ("SPI Memory Device ID:");
	APBRead(SPIRXDAT); 
	APBRead(SPIRXDAT);
	APBRead(SPIRXDAT);
	APBRead(SPIRXDAT);
	APBRead(SPIRXDAT);
	APBRead(SPIRXDAT);
	#10000
	ChipEn = 1'b1;
//--------------------------------------------------------

//--------------------------------------------------------
	#5000
	ChipEn = 1'b0;
	$display ("SPI Memory WriteEn");
	APBWrite(SPITXDAT, 16'h0006); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	#10000
	ChipEn = 1'b1;
//--------------------------------------------------------



//--------------------------------------------------------
	#5000
	ChipEn = 1'b0;
	$display ("SPI Memory Write");
	APBWrite(SPITXDAT, 16'h0002); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0000); //Second Address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0000); //Second Address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0000); //Second Address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0004); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0005); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0006); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0007); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	APBWrite(SPITXDAT, 16'h0008); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	#10000
	ChipEn = 1'b1;
//--------------------------------------------------------

//--------------------------------------------------------
	#5000
	ChipEn = 1'b0;
	$display ("SPI Memory Disable");
	APBWrite(SPITXDAT, 16'h0004); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
	#10000
	ChipEn = 1'b1;
//--------------------------------------------------------

//--------------------------------------------------------
	#10000
	ChipEn = 1'b0;
	$display ("SPI Memory Read");
	APBWrite(SPITXDAT, 16'h0003); //Page program
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Second address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Second address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Second address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Second address
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);

	APBWrite(SPITXDAT, 16'h0000); //Dummy Byte
    repeat(8) @(posedge SSPCLKOUT);
	APBRead(SPIRXDAT);
  	repeat(300) @(posedge PCLK);
  	$stop;
end


always @(posedge SSPINTR)
$display (" Interrupt Occur " );

//-------------------------------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("../Syn/Sdf/Ssp.noscan.sdf", Ssp);
`endif
//------------------------------------------------------
`ifdef WAVE
initial begin
  $shm_open("tbSPI.shm");
  $shm_probe(tbSPI, "ASC");
end
`endif
//------------------------------------------------------
endmodule
