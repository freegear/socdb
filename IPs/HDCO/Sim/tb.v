
//TestDM testbench

//`define P480
//`define P720
`define I1080

`define ADDRREG0  6'b000000      //0x00   register addr.
                               //    31 :: enable bit 
                               //    28 :: Enable HDmode

`define ADDRREG1  6'b000100      //0x04   start register addr.
`define ADDRREG2  6'b001000      //0x08   end register addr.

`define HSW       6'b001100      //0x0C   
`define HBP       6'b010000      //0x00   
`define ACTPIXEL  6'b010100      //0x04   
`define HFP       6'b011000      //0x08   
`define VSW       6'b011100      //0x0C   
`define VBP       6'b100000      //0x00   
`define ACTLINE   6'b100100      //0x04   
`define VFP       6'b101000      //0x08   


`define HD_ADDRREG0  8'b00110000      //0x30   
`define HD_ADDRREG1  8'b00110100      //0x34   
`define HD_ADDRREG2  8'b00111000      //0x38   
`define HD_ADDRREG3  8'b00111100      //0x3C   
`define HD_ADDRREG4  8'b01000000      //0x40   
`define HD_ADDRREG5  8'b01000100      //0x44   
`define HD_ADDRREG6  8'b01001000      //0x48   
`define HD_ADDRREG7  8'b01001100      //0x4C   
`define HD_ADDRREG8   8'b01010000     //0x50   
`define HD_ADDRREG9   8'b01010100     //0x54   
`define HD_ADDRREG10  8'b01011000     //0x58   
`define HD_ADDRREG11  8'b01011100     //0x5C   
`define HD_ADDRREG12  8'b01100000     //0x60   
`define HD_ADDRREG13  8'b01100100     //0x64   
`define HD_ADDRREG14  8'b01101000     //0x68   
`define HD_ADDRREG15  8'b01101100     //0x6C   
`define HD_ADDRREG16  8'b01110000     //0x70   
`define HD_ADDRREG17  8'b01110100     //0x74   
`define HD_ADDRREG18  8'b01111000     //0x78   
`define HD_ADDRREG19  8'b01111100     //0x7C   

`define VideoEncADDRREG0 32'h00//0x00   status register addr.
`define VideoEncADDRREG1 32'h04//0x04   Control register addr.
`define VideoEncADDRREG2 32'h08//0x08   Internal register addr.
`define VideoEncADDRREG3 32'h0C//0x0C   Subcarrier adjust phase register addr.
`define VideoEncADDRREG4 32'h10//0x10   Subcarrier frequency step register addr.

`define VideoEncADDRREG5 32'h14
`define VideoEncADDRREG6 32'h18
`define VideoEncADDRREG7 32'h1C

//apb_write(2'b01, `VideoEncADDRREG2, Address_08h_DATA);


module tb;

//parameter PERIOD1=13.46;	// 74.25Mhz
parameter PERIOD1=20.00;	// 50.00Mhz

parameter PERIOD2=37.00;	// 27Mhz
parameter PERIOD3=13.46;	// 74.25Mhz

parameter PHASETIME1=(PERIOD1 / 2);
parameter PHASETIME2=(PERIOD2 / 2);
parameter PHASETIME3=(PERIOD3 / 2);

parameter SDLY=2;

reg Clock;
reg ClockVideo27M;
reg ClockVideo74M;
reg RESETn;
reg Enable;

wire PCLK = Clock;
wire VCLK;
wire [1:0] wHD_MODE;

wire EN_INTERNAL_PATTERN = 1'b0;
`ifdef P480
wire  [1:0]  HD_MODE = 2'b00;

wire  [11:0] LCD_HSW = 12'd63-1;
wire  [11:0] LCD_HBP = 12'd59-1;
wire  [11:0] LCD_ACTPIXEL = 12'd720-1;
wire  [11:0] LCD_HFP = 12'd16-1;

wire  [11:0] LCD_VSW = 12'd3-1;
wire  [11:0] LCD_VBP = 12'd40-1;
wire  [11:0] LCD_ACTLINE = 12'd480-1;
wire  [11:0] LCD_VFP = 12'd2-1;
wire  [31:0] EndADDR = 32'd691200;//720 x 480 x 2

/*
wire  [11:0] LCD_HSW = 12'd126-1;
wire  [11:0] LCD_HBP = 12'd118-1;
wire  [11:0] LCD_ACTPIXEL = 12'd1440-1;
wire  [11:0] LCD_HFP = 12'd32-1;

wire  [11:0] LCD_VSW = 12'd3-1;
wire  [11:0] LCD_VBP = 12'd40-1;
wire  [11:0] LCD_ACTLINE = 12'd480-1;
wire  [11:0] LCD_VFP = 12'd2-1;
wire  [31:0] EndADDR = 32'd691200;//720 x 480 x 2
*/


wire EnSYNC_PbPr = 1'b1;
wire [7:0] LUMA_AMP = 8'd75;
wire [7:0] Pr_AMP = 8'd75;
wire [7:0] Pb_AMP = 8'd75;

wire [9:0] YH0to1_1 = 10'd134;
wire [9:0] YH0to1_2 = 10'd134;
wire [9:0] YH0to1_3 = 10'd134;
wire [9:0] YH0to2_1 = 10'd0;
wire [9:0] YH0to2_2 = 10'd0;
wire [9:0] YH0to2_3 = 10'd0;
wire [9:0] YH2to1_1 = 10'd0;
wire [9:0] YH2to1_2 = 10'd0;
wire [9:0] YH2to1_3 = 10'd0;

wire [9:0] YLevel00 = 10'd16;
wire [9:0] YLevel01 = 10'd252;
wire [9:0] YLevel02 = 10'd0;

wire [9:0] PH0to1_1 = 10'd394;
wire [9:0] PH0to1_2 = 10'd394;
wire [9:0] PH0to1_3 = 10'd394;
wire [9:0] PH0to2_1 = 10'd0;
wire [9:0] PH0to2_2 = 10'd0;
wire [9:0] PH0to2_3 = 10'd0;
wire [9:0] PH2to1_1 = 10'd0;
wire [9:0] PH2to1_2 = 10'd0;
wire [9:0] PH2to1_3 = 10'd0;

wire [9:0] PLevel00 = 10'd276;
wire [9:0] PLevel01 = 10'd512;
wire [9:0] PLevel02 = 10'd0;

wire [11:0] ACT_DISPLAY = 12'd138-1;
wire [11:0] H1 = 12'd15;
wire [11:0] H2 = 12'd78;
wire [11:0] H3 = 12'd794;
wire [11:0] H4 = 12'd857;
wire [11:0] H5 = 12'd31;
wire [11:0] H6 = 12'd31;
wire [11:0] H7 = 12'd31;
wire [11:0] H8 = 12'd31;
wire [11:0] H9 = 12'd31;
wire [11:0] H10 = 12'd31;
/*
wire [11:0] ACT_DISPLAY = 12'd276-1;
wire [11:0] H1 = 12'd30;
wire [11:0] H2 = 12'd156;
wire [11:0] H3 = 12'd1588;
wire [11:0] H4 = 12'd1714;
wire [11:0] H5 = 12'd31;
wire [11:0] H6 = 12'd31;
wire [11:0] H7 = 12'd31;
wire [11:0] H8 = 12'd31;
wire [11:0] H9 = 12'd31;
wire [11:0] H10 = 12'd31;
*/

wire [9:0] YRpara = 10'd306; 
wire [9:0] YGpara = 10'd601; 
wire [9:0] YBpara = 10'd117; 
                   
wire [9:0] PbRpara = 10'd173; 
wire [9:0] PbGpara = 10'd334; 
wire [9:0] PbBpara = 10'd512; 
                   
wire [9:0] PrRpara = 10'd512; 
wire [9:0] PrGpara = 10'd429; 
wire [9:0] PrBpara = 10'd83; 

`endif


`ifdef P720
wire  [1:0]  HD_MODE = 2'b01;
wire  [11:0] LCD_HSW = 12'd39;
wire  [11:0] LCD_HBP = 12'd259;
wire  [11:0] LCD_ACTPIXEL = 12'd1280-1;
wire  [11:0] LCD_HFP = 12'd69;

wire  [11:0] LCD_VSW = 12'd3-1;
wire  [11:0] LCD_VBP = 12'd22-1;
wire  [11:0] LCD_ACTLINE = 12'd720-1;
wire  [11:0] LCD_VFP = 12'd5-1;
wire  [31:0] EndADDR = 32'd921600;//1280 x 720 x 2

wire EnSYNC_PbPr = 1'b1;
wire [7:0] LUMA_AMP = 8'd77;
wire [7:0] Pr_AMP = 8'd77;
wire [7:0] Pb_AMP = 8'd77;

wire [9:0] YH0to1_1 = 10'd57;
wire [9:0] YH0to1_2 = 10'd129;
wire [9:0] YH0to1_3 = 10'd186;
wire [9:0] YH0to2_1 = 10'd129;
wire [9:0] YH0to2_2 = 10'd242;
wire [9:0] YH0to2_3 = 10'd363;
wire [9:0] YH2to1_1 = 10'd424;
wire [9:0] YH2to1_2 = 10'd363;
wire [9:0] YH2to1_3 = 10'd303;

wire [9:0] YLevel00 = 10'd16;
wire [9:0] YLevel01 = 10'd242;
wire [9:0] YLevel02 = 10'd484;

wire [9:0] PH0to1_1 = 10'd331;
wire [9:0] PH0to1_2 = 10'd391;
wire [9:0] PH0to1_3 = 10'd452;
wire [9:0] PH0to2_1 = 10'd391;
wire [9:0] PH0to2_2 = 10'd512;
wire [9:0] PH0to2_3 = 10'd647;
wire [9:0] PH2to1_1 = 10'd715;
wire [9:0] PH2to1_2 = 10'd647;
wire [9:0] PH2to1_3 = 10'd580;

wire [9:0] PLevel00 = 10'd270;
wire [9:0] PLevel01 = 10'd512;
wire [9:0] PLevel02 = 10'd782;

wire [11:0] ACT_DISPLAY = 12'd370-1;
wire [11:0] H1 = 12'd68;
wire [11:0] H2 = 12'd108;
wire [11:0] H3 = 12'd148;
wire [11:0] H4 = 12'd368;
wire [11:0] H5 = 12'd31;
wire [11:0] H6 = 12'd31;
wire [11:0] H7 = 12'd31;
wire [11:0] H8 = 12'd31;
wire [11:0] H9 = 12'd31;
wire [11:0] H10 = 12'd1648;

wire [9:0] YRpara = 10'd218; 
wire [9:0] YGpara = 10'd732; 
wire [9:0] YBpara = 10'd74; 
                   
wire [9:0] PbRpara = 10'd118; 
wire [9:0] PbGpara = 10'd394; 
wire [9:0] PbBpara = 10'd512; 
                   
wire [9:0] PrRpara = 10'd512; 
wire [9:0] PrGpara = 10'd465; 
wire [9:0] PrBpara = 10'd47; 

`endif

`ifdef I1080
wire  [1:0]  HD_MODE = 2'b10;
wire  [11:0] LCD_HSW = 12'd44-1;
wire  [11:0] LCD_HBP = 12'd192-1;
wire  [11:0] LCD_ACTPIXEL = 12'd1920-1;
wire  [11:0] LCD_HFP = 12'd44-1;

wire  [11:0] LCD_VSW = 12'd3-1;
wire  [11:0] LCD_VBP = 12'd17-1;
wire  [11:0] LCD_ACTLINE = 12'd540-1;
wire  [11:0] LCD_VFP = 12'd2-1;
wire  [31:0] EndADDR = 32'd4147200;//1920 x 1080 x 2

wire EnSYNC_PbPr = 1'b1;
wire [7:0] LUMA_AMP = 8'd77;
wire [7:0] Pr_AMP = 8'd77;
wire [7:0] Pb_AMP = 8'd77;

wire [9:0] YH0to1_1 = 10'd57;
wire [9:0] YH0to1_2 = 10'd129;
wire [9:0] YH0to1_3 = 10'd186;
wire [9:0] YH0to2_1 = 10'd129;
wire [9:0] YH0to2_2 = 10'd242;
wire [9:0] YH0to2_3 = 10'd363;
wire [9:0] YH2to1_1 = 10'd424;
wire [9:0] YH2to1_2 = 10'd363;
wire [9:0] YH2to1_3 = 10'd303;

wire [9:0] YLevel00 = 10'd16;
wire [9:0] YLevel01 = 10'd242;
wire [9:0] YLevel02 = 10'd484;

wire [9:0] PH0to1_1 = 10'd331;
wire [9:0] PH0to1_2 = 10'd391;
wire [9:0] PH0to1_3 = 10'd452;
wire [9:0] PH0to2_1 = 10'd391;
wire [9:0] PH0to2_2 = 10'd512;
wire [9:0] PH0to2_3 = 10'd647;
wire [9:0] PH2to1_1 = 10'd715;
wire [9:0] PH2to1_2 = 10'd647;
wire [9:0] PH2to1_3 = 10'd580;

wire [9:0] PLevel00 = 10'd270;
wire [9:0] PLevel01 = 10'd512;
wire [9:0] PLevel02 = 10'd782;

wire [11:0] ACT_DISPLAY = 12'd280-1;
wire [11:0] H1 = 12'd42;
wire [11:0] H2 = 12'd86;
wire [11:0] H3 = 12'd130;
wire [11:0] H4 = 12'd218;
wire [11:0] H5 = 12'd1098;
wire [11:0] H6 = 12'd1142;
wire [11:0] H7 = 12'd1186;
wire [11:0] H8 = 12'd1230;
wire [11:0] H9 = 12'd1318;
wire [11:0] H10 = 12'd2200-2;

wire [9:0] YRpara = 10'd218; 
wire [9:0] YGpara = 10'd732; 
wire [9:0] YBpara = 10'd74; 
                   
wire [9:0] PbRpara = 10'd118; 
wire [9:0] PbGpara = 10'd394; 
wire [9:0] PbBpara = 10'd512; 
                   
wire [9:0] PrRpara = 10'd512; 
wire [9:0] PrGpara = 10'd465; 
wire [9:0] PrBpara = 10'd47; 


`endif

always #PHASETIME1 Clock         = ~Clock;
always #PHASETIME2 ClockVideo27M = ~ClockVideo27M;
always #PHASETIME3 ClockVideo74M = ~ClockVideo74M;

initial
begin
	RESETn = 1'b0;
    Clock  = 1'b0;
    Enable = 1'b0;
    ClockVideo27M = 1'b0;
    ClockVideo74M = 1'b0;

	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;
	#(SDLY) Enable = 1'b1;

    HDCInitial;
    DMInitial;
#9990000;
    DisableMod;
    HDCInitial;
    DMInitial;
end

initial begin
  $shm_open("./TestDM_A.shm");
  $shm_probe("AS");
end

// =======================================================================
// Disable 
// -----------------------------------------------------------------------
task DisableMod;
begin
    apb_write(2'b10, `ADDRREG0,     32'h00000000); //Disable
    apb_write(2'b01, `HD_ADDRREG0,  32'h00000000); 
#5000;
end
endtask


// =======================================================================
// Display module initial
// -----------------------------------------------------------------------
task DMInitial;
begin
    apb_write(2'b10, `ADDRREG1, 32'h00000000);
    apb_write(2'b10, `ADDRREG2, EndADDR);
    apb_write(2'b10, `HSW, LCD_HSW);
    apb_write(2'b10, `HBP, LCD_HBP);
    apb_write(2'b10, `ACTPIXEL, LCD_ACTPIXEL);
    apb_write(2'b10, `HFP, LCD_HFP);

    apb_write(2'b10, `VSW, LCD_VSW);
    apb_write(2'b10, `VBP, LCD_VBP);
    apb_write(2'b10, `ACTLINE, LCD_ACTLINE);
    apb_write(2'b10, `VFP, LCD_VFP);

    apb_write(2'b10, `ADDRREG0, 32'h98000000); //Enable
end
endtask

// =======================================================================
// HDC initial
// -----------------------------------------------------------------------
task HDCInitial;
begin
    if(EN_INTERNAL_PATTERN == 1'b1)
        apb_write(2'b01, `VideoEncADDRREG2, 32'h10000);
    else
        apb_write(2'b01, `VideoEncADDRREG2, 32'h0);

    apb_write(2'b01, `VideoEncADDRREG1, 32'h7); //DAC enable

    apb_write(2'b01, `HD_ADDRREG1 , {2'd0,YH0to1_3,YH0to1_2,YH0to1_1});   
    apb_write(2'b01, `HD_ADDRREG2 , {2'd0,YH0to2_3,YH0to2_2,YH0to2_1});   
    apb_write(2'b01, `HD_ADDRREG3 , {2'd0,YH2to1_3,YH2to1_2,YH2to1_1});   
    apb_write(2'b01, `HD_ADDRREG4 , {2'd0,YLevel02,YLevel01,YLevel00});   
    apb_write(2'b01, `HD_ADDRREG5 , {2'd0,PH0to1_3,PH0to1_2,PH0to1_1});
    apb_write(2'b01, `HD_ADDRREG6 , {2'd0,PH0to2_3,PH0to2_2,PH0to2_1});
    apb_write(2'b01, `HD_ADDRREG7 , {2'd0,PH2to1_3,PH2to1_2,PH2to1_1});
    apb_write(2'b01, `HD_ADDRREG8 , {2'd0,PLevel02,PLevel01,PLevel00});
    apb_write(2'b01, `HD_ADDRREG9 , {8'd0,H2,H1});
    apb_write(2'b01, `HD_ADDRREG10, {8'd0,H4,H3});
    apb_write(2'b01, `HD_ADDRREG11, {8'd0,H6,H5});
    apb_write(2'b01, `HD_ADDRREG12, {8'd0,H8,H7});
    apb_write(2'b01, `HD_ADDRREG13, {8'd0,H10,H9});
    apb_write(2'b01, `HD_ADDRREG14, {20'd0,ACT_DISPLAY});
    apb_write(2'b01, `HD_ADDRREG15, {2'd0,YBpara ,YGpara,YRpara});
    apb_write(2'b01, `HD_ADDRREG16, {2'd0,PbBpara ,PbGpara,PbRpara});
    apb_write(2'b01, `HD_ADDRREG17, {2'd0,PrBpara ,PrGpara,PrRpara});

    apb_write(2'b01, `HD_ADDRREG0, {1'b1, HD_MODE,EnSYNC_PbPr,4'd0,Pr_AMP ,Pb_AMP,LUMA_AMP});
end
endtask


// =======================================================================
// Wire define
// -----------------------------------------------------------------------
wire [3:0]  ARID;
wire [31:0] ARADDR;
wire [3:0]  ARLEN;
wire [2:0]  ARSIZE;
wire [1:0]  ARBURST;
wire        ARVALID;
wire        ARREADY;

wire  [3:0]  RID;
wire  [31:0] RDATA;
wire  [1:0]  RRESP;
wire         RLAST;
wire         RVALID;
wire         RREADY;

wire [29:0] MADDR;	// discard lower 2 line
wire        MCEn;
wire [3:0]	MWEn;
wire [31:0]  MRDATA;
wire [31:0]  MWDATA;

reg	[9:2]	PADDR;
reg	[31:0]	PWDATA;
reg	[1:0]   PSEL;
reg	PWRITE;
reg	PENABLE;

wire   [31:0]  PRDATA0;
wire   [31:0]  PRDATA1;
wire   [7:0]   Rin;
wire   [7:0]   Gin;
wire   [7:0]   Bin;

wire  HSYNCn;
wire  VSYNCn;
wire  BLANKn;
wire  DAC_CLK;

wire  DAC0_ENABLE;
wire  DAC1_ENABLE;
wire  DAC2_ENABLE;

real OUT_DAC0;
real OUT_DAC1;
real OUT_DAC2;

wire  [9:0]   DAC0_DATA;
wire  [9:0]   DAC1_DATA;
wire  [9:0]   DAC2_DATA;

always @(posedge VCLK) OUT_DAC0 = $itor(DAC0_DATA)/{10{1'b1}};
always @(posedge VCLK) OUT_DAC1 = $itor(DAC1_DATA)/{10{1'b1}};
always @(posedge VCLK) OUT_DAC2 = $itor(DAC2_DATA)/{10{1'b1}};

// =======================================================================
// Test Display module TOP
// -----------------------------------------------------------------------

HDCTop HDCTop
(
//  APB bus
    .PCLK    (Clock   ),
    .RESETn  (RESETn  ),

    .PENABLE  (PENABLE  ), 
    .PSEL     (PSEL[0]  ), 
    .PWRITE   (PWRITE   ), 
    .PADDR    (PADDR[7:2]    ),  //[7:2]  used
    .PWDATA   (PWDATA   ),  //[31:0] used
    .PRDATA   (PRDATA0  ),  //[31:0] used

//input
    .CLK(VCLK),       // 27Mhz or 74.25Mhz clock input
    .HSYNCn(~HSYNCn),
    .VSYNCn(~VSYNCn),
    .BLANKn(BLANKn),
    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

    .DAC0_ENABLE(DAC0_ENABLE),
    .DAC1_ENABLE(DAC1_ENABLE),
    .DAC2_ENABLE(DAC2_ENABLE),

    .DAC0_DATA(DAC0_DATA),
    .DAC1_DATA(DAC1_DATA),
    .DAC2_DATA(DAC2_DATA),

    //Test platform
    .HD_MODE(wHD_MODE)
    );


// =======================================================================
// Test Display module TOP
// -----------------------------------------------------------------------

TestDMTop TestDMTop
(
//	AXI Interface
		.ACLK     (Clock     ), 
        .CLK27M   (ClockVideo27M),
        .CLK74M   (ClockVideo74M),
		.ARESETn  (RESETn   ), 

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


//  APB bus
   		.PCLK     (Clock),
		.PRESETB  (RESETn),
        .PSEL	(PSEL[1]), 
        .PENABLE(PENABLE), 
        .PADDR	(PADDR[5:2]), 
        .PWRITE	(PWRITE), 
        .PWDATA	(PWDATA), 
	    .PRDATA	(PRDATA1),

//  HDC interface
        .DAC_CLK(DAC_CLK),
        .HSYNCn(HSYNCn),
        .VSYNCn(VSYNCn),
        .BLANKn(BLANKn),
        .Rout(Rin),
        .Gout(Gin),
        .Bout(Bin),

        .HD_MODE(wHD_MODE),
        .VCLK(VCLK)
);


// =======================================================================
// Test Memory
// -----------------------------------------------------------------------
TestSlave VideoMem
(
//	AXI Interface
		.ACLK     (Clock    ), 
		.ARESETn  (RESETn  ), 
		// Write Address Channel
		.AWID     (4'd0),
		.AWADDR   (32'd0),
		.AWLEN    (4'd0),
		.AWSIZE   (3'd0),
		.AWBURST  (2'd0),
		.AWVALID  (1'b0),
		.AWREADY  (),
//Disable lock port
//Disable cache port
//Disable protect port

		// Write Data Channel
		.WID      (4'd0),
		.WDATA    (32'd0),
//Disable Wstrb
		.WLAST    (1'b0),
		.WVALID   (1'b0),
		.WREADY   (),

		// Write Response Channel
		.BID      (),
		.BRESP    (),
		.BVALID   (),
		.BREADY   (1'b0),

		// Read Address Channel
		.ARID     (4'd0),
		.ARADDR   (ARADDR   ),
		.ARLEN    (ARLEN    ),
		.ARSIZE   (ARSIZE   ),
		.ARBURST  (ARBURST  ),
		.ARVALID  (ARVALID  ),
		.ARREADY  (ARREADY  ),
//Disable lock port
//Disable cache port
//Disable protect port

		// Read Data Channel
		.RID      (),
		.RDATA    (RDATA    ),
		.RRESP    (RRESP    ),
		.RLAST    (RLAST    ),
		.RVALID   (RVALID   ),
		.RREADY   (RREADY   ),

//	SRAM Interface
		.MEMADDR  (MADDR  ),
		.MEMCEn   (MCEn   ),
		.MEMWEn   (MWEn   ),
		.MEMRDATA (MRDATA ),
		.MEMWDATA (MWDATA )
);

VIDEOEnC_SSRAM32bit  VIDEOEnC_SRAM32bit  
(
		.CLK   (Clock), 

		.ADDR  (MADDR  ),
		.CEn   (MCEn   ),
		.WEn   (MWEn   ),
		.RDATA (MRDATA ),
		.WDATA (MWDATA )
);

// TASK for write and read //////////////////////////////////////////

task apb_write; // write
input [1:0]  psel;
input [31:0] reg_addr;
input [31:0] reg_write;
begin
    @(negedge PCLK);
    PENABLE = 1'b0;
    @(posedge PCLK);
	#2
        PSEL = psel;
        PWRITE = 1'b1;
        PADDR = reg_addr[9:2];
        PWDATA = reg_write;
	
    @(posedge PCLK)

    #2  PENABLE = 1'b1;

    @(posedge PCLK)

    #2  $display($time, "<<address [%h] psel[%h] write data [%h]>> ", reg_addr, PSEL, reg_write);
        PENABLE = 1'b0;
        PSEL    = 2'b00;
        PWDATA  = 32'dz;
end
endtask

task apb_read; // read
input [1:0]  psel;
input [31:0] reg_addr;
begin
    @(negedge PCLK);
    PENABLE = 1'b0;

    @(posedge PCLK);
        #2  PSEL = psel;
            PWRITE = 1'b0;
            PADDR = reg_addr[9:2];
    @(posedge PCLK)
        #2  PENABLE = 1'b1;
    @(posedge PCLK)
            $display($time, " <<address [%h] psel[%h] read data [??]>> ", reg_addr, PSEL);
        #2  PENABLE = 1'b0;
            PSEL = 2'b00;
end
endtask
//////////////////////////////////////////////////////////////////

endmodule
