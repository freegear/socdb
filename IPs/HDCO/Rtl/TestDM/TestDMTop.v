// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestDMTop.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is for displace the DM module  
// =======================================================================

`timescale 1ns/1ps

module TestDMTop
(
//	AXI Interface
		ACLK     , 
        CLK27M   ,
        CLK74M   ,
		ARESETn  , 

		// Read Address Channel
		ARADDR   ,
		ARLEN    ,
		ARSIZE   ,
		ARBURST  ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY   ,

//  APB bus
   		PCLK     ,
		PRESETB  ,
        PENABLE  , 
        PSEL     , 
        PWRITE   , 
        PADDR    ,  //[5:2] used
        PWDATA   ,  //[15:0] used
        PRDATA   ,

//  HDC interface
        DAC_CLK,
        HSYNCn,
        VSYNCn,
        BLANKn,
        Rout,
        Gout,
        Bout,

        HD_MODE,
        VCLK
);
//AXI bus//////////////////////
input  ACLK;
input  CLK27M;
input  CLK74M;
input  ARESETn;


output  [31:0] ARADDR;
output  [3:0]  ARLEN;
output  [2:0]  ARSIZE;
output  [1:0]  ARBURST;
output         ARVALID;
input          ARREADY;

input [31:0] RDATA;
input [1:0]  RRESP;
input        RLAST;
input        RVALID;
output       RREADY;

//APB bus//////////////////////
input   PCLK; 
input   PRESETB;
input	[5:2]	PADDR;
input	[31:0]	PWDATA;
input	PSEL;
input	PWRITE ;
input	PENABLE;
input   [1:0]  HD_MODE;

output	[31:0]	PRDATA;
output  VCLK;


wire CLK  = (HD_MODE == 2'b00) ? CLK27M : CLK74M;
assign VCLK = CLK;

//HDC inteface/////////////////
output DAC_CLK;
output HSYNCn;
output VSYNCn;
output BLANKn;
output [7:0] Rout;
output [7:0] Gout;
output [7:0] Bout;

//Wire

wire [4:0]  MEMADDR00;	// discard lower 2 line
wire [4:0]  MEMADDR01;	// discard lower 2 line
wire        MEMWEn00;
wire        MEMWEn01;
wire [31:0] MEMRDATA00;
wire [31:0] MEMRDATA01;
wire [31:0] MEMWDATA00;
wire [31:0] MEMWDATA01;

wire [4:0]  MEMADDR10;	// discard lower 2 line
wire [4:0]  MEMADDR11;	// discard lower 2 line
wire        MEMWEn10;
wire        MEMWEn11;
wire [31:0] MEMRDATA10;
wire [31:0] MEMRDATA11;
wire [31:0] MEMWDATA10;
wire [31:0] MEMWDATA11;

wire [4:0]  MEMADDR20;	// discard lower 2 line
wire [4:0]  MEMADDR21;	// discard lower 2 line
wire        MEMWEn20;
wire        MEMWEn21;
wire [31:0] MEMRDATA20;
wire [31:0] MEMRDATA21;
wire [31:0] MEMWDATA20;
wire [31:0] MEMWDATA21;

wire [4:0]  MEMADDR30;	// discard lower 2 line
wire [4:0]  MEMADDR31;	// discard lower 2 line
wire        MEMWEn30;
wire        MEMWEn31;
wire [31:0] MEMRDATA30;
wire [31:0] MEMRDATA31;
wire [31:0] MEMWDATA30;
wire [31:0] MEMWDATA31;

wire [11:0] LCD_HSW;  //3
wire [11:0] LCD_HBP;  //4
wire [11:0] LCD_ACTPIXEL; //5
wire [11:0] LCD_HFP; //6

wire [11:0] LCD_VSW; //7
wire [11:0] LCD_VBP; //8
wire [11:0] LCD_ACTLINE; //9
wire [11:0] LCD_VFP; //10

wire INVCLK;
wire EnTESTDm;
wire RqDATA;
wire [15:0] DATAin;

assign DAC_CLK = (INVCLK) ? ~CLK : CLK;

// =======================================================================
// VideoEncoderTester 
// -----------------------------------------------------------------------
VideoEncoderTester VideoEncoderTester 
(
//	AXI Interface
		.ACLK     (ACLK     ), 
        .CLK      (CLK),
		.ARESETn  (ARESETn  ), 

		// Read Address Channel
		.ARADDR   (ARADDR   ),
		.ARLEN    (ARLEN    ),
		.ARSIZE   (ARSIZE   ),
		.ARBURST  (ARBURST  ),
		.ARVALID  (ARVALID  ),
		.ARREADY  (ARREADY  ),

		// Read Data Channel
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   ),

        .DMA_REQ  (),

//  APB bus
   		.PCLK     (PCLK     ),
		.PRESETB  (PRESETB  ),
        .PENABLE  (PENABLE  ), 
        .PSEL     (PSEL     ), 
        .PWRITE   (PWRITE   ), 
        .PADDR    (PADDR    ),  
        .PWDATA   (PWDATA   ),  
        .PRDATA   (PRDATA   ),


//	SRAM Interface
		.MEMADDR00  (MEMADDR00  ),
		.MEMADDR01  (MEMADDR01  ),
		.MEMWEn00   (MEMWEn00   ),
		.MEMWEn01   (MEMWEn01   ),
		.MEMRDATA00 (MEMRDATA00 ),
		.MEMRDATA01 (MEMRDATA01 ),
		.MEMWDATA00 (MEMWDATA00 ),
		.MEMWDATA01 (MEMWDATA01 ),

		.MEMADDR10  (MEMADDR10  ),
		.MEMADDR11  (MEMADDR11  ),
		.MEMWEn10   (MEMWEn10   ),
		.MEMWEn11   (MEMWEn11   ),
		.MEMRDATA10 (MEMRDATA10 ),
		.MEMRDATA11 (MEMRDATA11 ),
		.MEMWDATA10 (MEMWDATA10 ),
		.MEMWDATA11 (MEMWDATA11 ),

		.MEMADDR20  (MEMADDR20  ),
		.MEMADDR21  (MEMADDR21  ),
		.MEMWEn20   (MEMWEn20   ),
		.MEMWEn21   (MEMWEn21   ),
		.MEMRDATA20 (MEMRDATA20 ),
		.MEMRDATA21 (MEMRDATA21 ),
		.MEMWDATA20 (MEMWDATA20 ),
		.MEMWDATA21 (MEMWDATA21 ),

		.MEMADDR30  (MEMADDR30  ),
		.MEMADDR31  (MEMADDR31  ),
		.MEMWEn30   (MEMWEn30   ),
		.MEMWEn31   (MEMWEn31   ),
		.MEMRDATA30 (MEMRDATA30 ),
		.MEMRDATA31 (MEMRDATA31 ),
		.MEMWDATA30 (MEMWDATA30 ),
		.MEMWDATA31 (MEMWDATA31 ),

        .RqDATA(RqDATA),
        .DATAout(DATAin),

//Register output
        .EnTESTDm(EnTESTDm),
        .INVCLK(INVCLK),
        .HD_MODE(HD_MODE),
        .LCD_HSW(LCD_HSW),  //3
        .LCD_HBP(LCD_HBP),  //4
        .LCD_ACTPIXEL(LCD_ACTPIXEL), //5
        .LCD_HFP(LCD_HFP),      //6

        .LCD_VSW(LCD_VSW),      //7
        .LCD_VBP(LCD_VBP),      //8
        .LCD_ACTLINE(LCD_ACTLINE),  //9
        .LCD_VFP(LCD_VFP)       //10
);

// =======================================================================
// Internal SRAM
// -----------------------------------------------------------------------

/*
dualram32 SSRAM0(
    .addra(MEMADDR00  ),
    .addrb(MEMADDR01  ),
    .clka (ACLK       ),
    .clkb (CLK        ),
    .dina (MEMWDATA00 ),
    .doutb(MEMRDATA01 ),
    .wea  (MEMWEn00   )
    );
*/

MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM0
(
        .data0  (MEMWDATA00 ),
        .data1  (MEMWDATA01 ),
        .waddr0 (MEMADDR00  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR01  ),
        .we0    (MEMWEn00   ),
        .we1    (MEMWEn01   ),
        .clk0   (ACLK      ),
        .clk1   (CLK  ),
        .q1     (MEMRDATA01 )
);


MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM1
(
        .data0  (MEMWDATA10 ),
        .data1  (MEMWDATA11 ),
        .waddr0 (MEMADDR10  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR11  ),
        .we0    (MEMWEn10   ),
        .we1    (MEMWEn11   ),
        .clk0   (ACLK      ),
        .clk1   (CLK  ),
        .q1     (MEMRDATA11 )
);


MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM2
(
        .data0  (MEMWDATA20 ),
        .data1  (MEMWDATA21 ),
        .waddr0 (MEMADDR20  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR21  ),
        .we0    (MEMWEn20   ),
        .we1    (MEMWEn21   ),
        .clk0   (ACLK      ),
        .clk1   (CLK  ),
        .q1     (MEMRDATA21 )
);


MULTISRAM #(.d_width(32), 
            .addr_width(5),
            .mem_depth(32)
           ) SSRAM3
(
        .data0  (MEMWDATA30 ),
        .data1  (MEMWDATA31 ),
        .waddr0 (MEMADDR30  ),
        .waddr1 (5'd0       ),
        .raddr  (MEMADDR31  ),
        .we0    (MEMWEn30   ),
        .we1    (MEMWEn31   ),
        .clk0   (ACLK      ),
        .clk1   (CLK  ),
        .q1     (MEMRDATA31 )
);

// =======================================================================
// Test Display module 
// -----------------------------------------------------------------------
TestDM TestDM(

        .CLK(CLK),
        .RESETn(ARESETn),

        .Enable(EnTESTDm),
        .HD_MODE(HD_MODE),

        .LCD_HSW(LCD_HSW),
        .LCD_HBP(LCD_HBP),
        .LCD_ACTPIXEL(LCD_ACTPIXEL),
        .LCD_HFP(LCD_HFP),

        .LCD_VSW(LCD_VSW),
        .LCD_VBP(LCD_VBP),
        .LCD_ACTLINE(LCD_ACTLINE),
        .LCD_VFP(LCD_VFP),

        .RqDATA(RqDATA),
        .DATAin(DATAin),

        .HSYNCn(HSYNCn),
        .VSYNCn(VSYNCn),
        .BLANKn(BLANKn),
        .Rout(Rout),
        .Gout(Gout),
        .Bout(Bout)

        );

// -----------------------------------------------------------------------
endmodule
