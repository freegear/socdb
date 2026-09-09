module FPGA0Core(

        /* BUS for Video Encoder tester */
        BUS_CLK,
        VIDEO_CLK,
        BUS_RESETn,

        //Read address channel
        ARADDR_VideoEnC,
        ARLEN_VideoEnC,
        ARSIZE_VideoEnC,
        ARBURST_VideoEnC,

        ARVALID_VideoEnC,
        ARREADY_2_VideoEnC,

        //Read data channel
        RRESP_2_VideoEnC,   
        RDATA_2_VideoEnC,
        RLAST_2_VideoEnC,
        RVALID_2_VideoEnC,  
        RREADY_VideoEnC,
        
        //APB bus
        PADDR0_2_VideoEnc,
        PWDATA0_2_VideoEnc,
        PENABLE0_2_VideoEnc,
        PSEL0_3_VideoEnc,

        DAC_CLK,
        DAC_OUT,
        SYNC,
        BLANK

        );

//Read address channel
input  BUS_CLK:
input  VIDEO_CLK;
input  BUS_RESETn;

output   [31:0] ARADDR_VideoEnC;
output   [3:0]  ARLEN_VideoEnC;
output   [2:0]  ARSIZE_VideoEnC;  
output   [1:0]  ARBURST_VideoEnC; 

output   ARVALID_VideoEnC; 
input    ARREADY_2_VideoEnC; 

//Read data channel
input    [1:0]   RRESP_2_VideoEnC;   
input    [31:0]  RDATA_2_VideoEnC;
input    RLAST_2_VideoEnC;
input    RVALID_2_VideoEnC;  
output   RREADY_VideoEnC;  

//APB bus
input  [1:0]  PADDR0_2_VideoEnc;
input  [31:0] PWDATA0_2_VideoEnc;
input         PENABLE0_2_VideoEnc;
input         PSEL0_3_VideoEnc;

/* DAC output signal */
output         DAC_CLK; 
output [7:0]   DAC_OUT;
output         SYNC;
output         BLANK;
assign DAC_CLK = VIDEO_CLK;

// AXI Slave5  : NTSC/PAL Vidoe encoder Tester 
wire [4:0]  MEMADDR0;	// discard lower 2 line
wire        MEMCEn0;
wire [3:0]  MEMWEn0;
wire [31:0] MEMRDATA0;
wire [31:0] MEMWDATA0;

wire [4:0]  MEMADDR1;	// discard lower 2 line
wire        MEMCEn1;
wire [3:0]  MEMWEn1;
wire [31:0] MEMRDATA1;
wire [31:0] MEMWDATA1;

wire [4:0]  MEMADDR2;	// discard lower 2 line
wire        MEMCEn2;
wire [3:0]  MEMWEn2;
wire [31:0] MEMRDATA2;
wire [31:0] MEMWDATA2;

wire [4:0]  MEMADDR3;	// discard lower 2 line
wire        MEMCEn3;
wire [3:0]  MEMWEn3;
wire [31:0] MEMRDATA3;
wire [31:0] MEMWDATA3;

wire        CLK0;
wire        CLK1;
wire        CLK2;
wire        CLK3;

VideoEncoderTester VideoEnC
(
//	AXI Interface
		.ACLK(ACLK_BUS),
		.ARESETn(ARESETn),
        .CLK_27MHZ(Clock2),

		// Read Address Channel
		.ARADDR   (ARADDR_VideoEnC  ),
		.ARLEN    (ARLEN_VideoEnC    ),
		.ARSIZE   (ARSIZE_VideoEnC   ),
		.ARBURST  (ARBURST_VideoEnC  ),
		.ARVALID  (ARVALID_VideoEnC  ),
		.ARREADY  (ARREADY_2_VideoEnC),

		// Read Data Channel
		.RDATA    (RDATA_2_VideoEnC    ),
		.RRESP    (RRESP_2_VideoEnC    ),
		.RLAST    (RLAST_2_VideoEnC    ),
		.RVALID   (RVALID_2_VideoEnC   ),
		.RREADY   (RREADY_VideoEnC     ),

        .DMA_REQ  (),

//  APB bus
        .PENABLE  (PENABLE0), 
        .PSEL     (PSEL0_3), 
        .PWRITE   (PWRITE0), 
        .PADDR    (PADDR0[3:2]),  //[3:2] used
        .PWDATA   (PWDATA0),  
        .PRDATA   (PRDATA0_3),

//	SRAM Interface
		.MEMADDR0  (MEMADDR0  ),
		.MEMCEn0   (MEMCEn0   ),
		.MEMWEn0   (MEMWEn0   ),
		.MEMRDATA0 (MEMRDATA0 ),
		.MEMWDATA0 (MEMWDATA0 ),

		.MEMADDR1  (MEMADDR1  ),
		.MEMCEn1   (MEMCEn1   ),
		.MEMWEn1   (MEMWEn1   ),
		.MEMRDATA1 (MEMRDATA1 ),
		.MEMWDATA1 (MEMWDATA1 ),

		.MEMADDR2  (MEMADDR2  ),
		.MEMCEn2   (MEMCEn2   ),
		.MEMWEn2   (MEMWEn2   ),
		.MEMRDATA2 (MEMRDATA2 ),
		.MEMWDATA2 (MEMWDATA2 ),

		.MEMADDR3  (MEMADDR3  ),
		.MEMCEn3   (MEMCEn3   ),
		.MEMWEn3   (MEMWEn3   ),
		.MEMRDATA3 (MEMRDATA3 ),
		.MEMWDATA3 (MEMWDATA3 ),

        .ADC_OUT   (DAC_OUT   ),
        .SYNC      (SYNC      ),
        .BLANK     (BLANK     ),

        .CLK0      (CLK0      ),
        .CLK1      (CLK1      ),
        .CLK2      (CLK2      ),
        .CLK3      (CLK3      )
);

SSRAM32bit #(.ADDR_WIDTH(5)) VideoEnCBuffer0
(
		.CLK   (CLK0), 

		.ADDR  (MEMADDR0[4:0]  ),
		.CEn   (MEMCEn0   ),
		.WEn   (MEMWEn0   ),
		.RDATA (MEMRDATA0 ),
		.WDATA (MEMWDATA0 )
);

SSRAM32bit #(.ADDR_WIDTH(5)) VideoEnCBuffer1
(
		.CLK     (CLK1), 

		.ADDR  (MEMADDR1[4:0] ),
		.CEn   (MEMCEn1   ),
		.WEn   (MEMWEn1   ),
		.RDATA (MEMRDATA1 ),
		.WDATA (MEMWDATA1 )
);

SSRAM32bit #(.ADDR_WIDTH(5)) VideoEnCBuffer2
(
		.CLK   (CLK2), 

		.ADDR  (MEMADDR2[4:0] ),
		.CEn   (MEMCEn2   ),
		.WEn   (MEMWEn2   ),
		.RDATA (MEMRDATA2 ),
		.WDATA (MEMWDATA2 )
);

SSRAM32bit #(.ADDR_WIDTH(5)) VideoEnCBuffer3
(
		.CLK     (CLK3), 

		.ADDR  (MEMADDR3[4:0]  ),
		.CEn   (MEMCEn3   ),
		.WEn   (MEMWEn3   ),
		.RDATA (MEMRDATA3 ),
		.WDATA (MEMWDATA3 )
);

endmodule
