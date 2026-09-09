// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestTop.v
// File Revision       : 0.1
// -----------------------------------------------------------------
// Purpose            : This module is Video encoder test module
// =================================================================

`timescale 1ns/1ps
`define NCSIM

`define VideoEncADDRREG0 32'h00//0x00   status register addr.
`define VideoEncADDRREG1 32'h04//0x04   Control register addr.
`define VideoEncADDRREG2 32'h08//0x08   Internal register addr.
`define VideoEncADDRREG3 32'h0C//0x0C   Subcarrier adjust phase register addr.
`define VideoEncADDRREG4 32'h10//0x10   Subcarrier frequency step register addr.

//Register setting value /////////////////////////////////////////////////
//modify this area for setting register

`define VIDEO;
//`define NTSC;

`define ENABLE  1'b1
`define	EN_DAC0	1'b1	            //composite output
`define	EN_DAC1	1'b1	            //Y output
`define	EN_DAC2	1'b1	            //C output
`define	EN_SQPIXEL	        1'b0	//Squre pixel enable 
`define EN_NONINTERLACE     1'b0    //non-interlace mode
`define OUT_MODE            3'b100  
/*
  OUT_MODE setting value

        000 :: NTSC M
        001 :: NTSC J
        010 :: NTSC 4.43
        011 :: M PAL
        100 :: PAL(B, D, G, H and I)
        101 :: PAL Nc
        110 :: PAL N
*/
`define LUMA_FILTER_SEL     2'b00   //luma filter selector
`define CHRO_FILTER_SEL     2'b11   //chrominance filter selector
`define EN_RESET_SCH        1'b0
`define EN_INTERNAL_PATTERN 1'b1
`define EN_COLOR_KILL       1'b0
`define COLOR_PATTERN_MODE  2'b00
`define CHRO_DELAY          3'b000
`define LUMA_DELAY          3'b000
`define BURST_WID           2'b01
`define HSYNC_WID           3'b010
`define SUB_PHASE           15'd0
`define SUB_REQ             32'd0


module tb;

parameter GraphicX = 720;
parameter VideoX   = 720;
`ifdef NTSC
parameter GraphicY = 240;
parameter VideoY   = 240;
`else
parameter GraphicY = 288;
parameter VideoY   = 288;
`endif
parameter CursorX  = 64;
parameter CursorY  = 54;

`ifdef VIDEO
`ifdef NTSC
wire NTSC = 1'b1;
parameter LCDX = 720;
parameter LCDY = 240;
parameter ODD_ADDR = 0;
parameter EVEN_ADDR = 32'd345600; 
`else
wire NTSC = 1'b0;
parameter LCDX = 720;
parameter LCDY = 288;
parameter ODD_ADDR = 0;
parameter EVEN_ADDR = 32'd414720; 
`endif
`else
parameter LCDX = 640;//800;
parameter LCDY = 480;//600;
`endif

parameter II = 4-1;		// ID Width
parameter DD = 32-1;	// Data Width
parameter BB = 4-1;		// Byte Width

parameter PERIOD1=5.0;	    
parameter PERIOD2=9.25;	
parameter PHASETIME1=(PERIOD1 / 2);
parameter PHASETIME2=(PERIOD2 / 2);
parameter SDLY=2;

`include "../Rtl/DM/DmPara.v"
`include "../Rtl/Include/LcdSim.v"

reg   RESETn;
reg   Clock;
reg   Clock_27M;

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

wire  HSYNC;
wire  VSYNC;
wire  BLANK;
wire  [23:0] RGBDATA;
wire  DmErrInt;
wire  VideoClock;
wire  PCLK = Clock;

reg  [II:0] AWID;
reg  [31:0] AWADDR;
reg  [3:0]  AWLEN;
reg  [2:0]  AWSIZE;
reg  [1:0]  AWBURST;
reg         AWVALID;
wire        AWREADY;

reg  [II:0] WID;
reg  [DD:0] WDATA;
reg  [BB:0] WSTRB;
wire        WLAST;
reg         WVALID;
wire        WREADY;

wire [II:0] BID;
wire [1:0]  BRESP;
wire        BVALID;
reg         BREADY;

wire [II:0] ARID;
wire [31:0] ARADDR;
wire [3:0]  ARLEN;
wire [2:0]  ARSIZE;
wire [1:0]  ARBURST;
wire        ARVALID;
wire        ARREADY;

wire [II:0] RID;
wire [DD:0] RDATA;
wire [1:0]  RRESP;
wire        RLAST;
wire        RVALID;
wire        RREADY;

wire [2:0] 	ARPROT;

wire DAC0_ENABLE;
wire DAC1_ENABLE;
wire DAC2_ENABLE;

wire [9:0]DAC0_DATA;
wire [9:0]DAC1_DATA;
wire [9:0]DAC2_DATA;

assign  Rin    = RGBDATA[23:16];
assign  Gin    = RGBDATA[15:8];
assign  Bin    = RGBDATA[7:0];

always #PHASETIME1 Clock     = ~Clock;
always #PHASETIME2 Clock_27M = ~Clock_27M;

//Clock&Reset generation
initial begin
    Clock = 0;
    Clock_27M = 0;
end

//Start address change interrupt
reg  DmErrInt_d;
wire RegSetInt = DmErrInt & !DmErrInt_d; 
reg  EvenOdd; // 0--> odd field  1--> even field

//APB register setting
initial begin

	RESETn = 1'b0;
    DmErrInt_d = 1'b0;
    EvenOdd = 1'b0;
	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;

    repeat(100) @(posedge Clock); 

    VideoInitial;
    DMInitial;
end

always @(posedge Clock) begin
    DmErrInt_d <= DmErrInt;
end

always @(posedge Clock) begin
    if(RegSetInt) begin
        if(!EvenOdd) begin
	        //apb_write(2'b10, GBASE, EVEN_ADDR);
	        //apb_write(2'b10, GADDR, EVEN_ADDR);
            EvenOdd = ~EvenOdd;
        end
        else begin
	        //apb_write(2'b10, GBASE, ODD_ADDR);
	        //apb_write(2'b10, GADDR, ODD_ADDR);
            EvenOdd = ~EvenOdd;
        end
    end
end

integer    DumpY;
integer    DumpC;
integer    DumpCVBS;
integer    DumpCnt;
integer    DumpSin;
integer    DumpCos;
integer    DumpFPGA;

initial begin
    DumpCnt   = 0;
    DumpY     = $fopen("./Dump/Y.out");
    DumpC     = $fopen("./Dump/C.out");
    DumpCVBS  = $fopen("./Dump/Compsite.out");
    DumpFPGA  = $fopen("./Dump/DumpFPGA.out");
end

always @(posedge Clock_27M) begin

    if(VideoEncTop.ENABLE) begin
        $fwrite(DumpY,"%d %d \n",DumpCnt, DAC1_DATA);
        $fwrite(DumpC,"%d %d \n",DumpCnt, DAC2_DATA);
        $fwrite(DumpCVBS,"%d %d \n",DumpCnt, DAC0_DATA);
        $fwrite(DumpFPGA,"%x\n", DAC0_DATA[9:2]);
        DumpCnt = DumpCnt + 1;
    end
end

`ifdef NCSIM
integer SetCnt;
reg	    InterAct;
wire    InACT;

initial begin
  SetCnt = 0;
  $shm_open("./shm/VideoEnC.shm");
  $shm_probe(VideoEncTop.Core, "AS");
  $shm_probe("A");
end

always @(posedge Clock_27M) begin
	if(VideoEncTop.Core.RESET_ADDR && (SetCnt == 1)) begin
		$stop;
	end
	else if (VideoEncTop.Core.RESET_ADDR && (SetCnt == 0)) begin
		SetCnt = SetCnt + 1;
	end
end

always @(posedge Clock_27M) begin
	InterAct <= VideoEncTop.Core.ACT_DISPLAY_INTER;
end

assign InACT = (VideoEncTop.Core.ACT_DISPLAY_INTER & !InterAct) ? 1'b1 : 1'b0;


/*
always @(posedge Clock_27M) begin
	if(InACT) begin
		if((VideoEncTop.Core.Rin == 8'hF8) &&
		   (VideoEncTop.Core.Gin == 8'hFC) &&
		   (VideoEncTop.Core.Bin == 8'hF8)) begin
    		$display($time, "<<PASS0>>");
		end
		else if((VideoEncTop.Core.Rin == 8'h00) &&
		   		(VideoEncTop.Core.Gin == 8'h00) &&
		   		(VideoEncTop.Core.Bin == 8'hF8)) begin
    		$display($time, "<<PASS1>>");
		end
		else if((VideoEncTop.Core.Rin == 8'd08) &&
		   		(VideoEncTop.Core.Gin == 8'd60) &&
		   		(VideoEncTop.Core.Bin == 8'd88)) begin
    		$display($time, "<<PASS2>>");
		end
		else begin
    		$display($time, "<<STOP>> %d %d %d\n",Rin, Gin, Bin);
			$stop;
		end
	end
end
*/

/*
always @(posedge Clock_27M) begin
	if(VideoEncTop.Core.RESET_ADDR && (SetCnt == 1)) begin
		$stop;
	end
	else if (VideoEncTop.Core.RESET_ADDR && (SetCnt == 0)) begin
		SetCnt = SetCnt + 1;
	end
end
*/
`endif

// Display Module Top
//initial force DmTop.TGSEL = 1;
DmTop DmTop(
   				.ACLK            	(Clock),
   				.ARESETn           	(RESETn),
				.LCDCLK				(Clock_27M),
				.LCDCLKo			(VideoClock),

   				.ARID           	(ARID[1:0]),
   				.ARADDR         	(ARADDR),
   				.ARLEN          	(ARLEN),
   				.ARSIZE         	(ARSIZE),
   				.ARBURST        	(ARBURST),
   				.ARLOCK         	(),
   				.ARCACHE        	(),
   				.ARPROT         	(ARPROT),
   				.ARVALID        	(ARVALID),
   				.ARREADY        	(ARREADY),

   				.RID            	(RID[1:0]),
   				.RDATA          	(RDATA),
   				.RRESP          	(RRESP),
   				.RLAST          	(RLAST),
   				.RVALID         	(RVALID),
   				.RREADY         	(RREADY),

				.PCLK				(Clock),
				.PRESETB			(RESETn),
    			.PSEL				(PSEL[1]), 
    			.PENABLE			(PENABLE), 
    			.PADDR				(PADDR), 
    			.PWRITE				(PWRITE), 
    			.PWDATA				(PWDATA), 
				.PRDATA				(PRDATA1),
				
				.LCDHSync			(HSYNC),
				.LCDVSync			(VSYNC),
				.LCDDataEn			(BLANK),
				.LCDData  			(RGBDATA),
                .VideoSyncEnPCLK    (),

                .LCDPDIV            (),
				.DmInt			    (DmErrInt)
);

wire [31:0] MEMADDR;
wire [DD:0] MEMRDATA;
wire [DD:0] MEMWDATA;
wire        MEMCEn;
wire [BB:0] MEMWEn;

IntSRAMController IntSRAMController
(
		.ACLK(Clock),
		.ARESETn(RESETn),

		.AWID(4'd0),
		.AWADDR(32'd0),
		.AWLEN(4'd0),
		.AWSIZE(3'd0),
		.AWBURST(2'd0),
		.AWVALID(1'd0),
		.AWREADY(),

		.WID(4'd0),
		.WDATA(32'd0),
		.WSTRB(4'd0),
		.WLAST(1'b0),
		.WVALID(1'b0),
		.WREADY(),

		.BID(),
		.BRESP(),
		.BVALID(),
		.BREADY(1'b0),

		.ARID({2'b0, ARID[1:0]}),
		.ARADDR(ARADDR),
		.ARLEN(ARLEN),
		.ARSIZE(ARSIZE),
		.ARBURST(ARBURST),
		.ARVALID(ARVALID),
		.ARREADY(ARREADY),

		// Read Data Channel
		.RID(RID),
		.RDATA(RDATA),
		.RRESP(RRESP),
		.RLAST(RLAST),
		.RVALID(RVALID),
		.RREADY(RREADY),

		.MEMADDR(MEMADDR[29:0]),
		.MEMCEn(MEMCEn),
		.MEMWEn(MEMWEn),
		.MEMRDATA(MEMRDATA),
		.MEMWDATA(MEMWDATA)
);

VIDEOEnC_SSRAM32bit #(24) SRAM
(
		.CLK(Clock),
		.ADDR(MEMADDR[23:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);

//////////////////////////////////////////////////////////////////

VideoEncTop VideoEncTop
(
//  APB bus
    .ACLK     (Clock),
    .ARESETn  (RESETn),

    .PENABLE  (PENABLE  ), 
    .PSEL     (PSEL[0]  ), 
    .PWRITE   (PWRITE   ), 
    .PADDR   (PADDR[5:2]),  //[5:2]  used
    .PWDATA   (PWDATA   ),  //[31:0] used
    .PRDATA   (PRDATA0  ),  //[31:0] used

//input
    .CLK(VideoClock),       // 27Mhz clock input
    .HSYNCn(HSYNC),
    .VSYNCn(VSYNC),
    .BLANKn(BLANK),
    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

//output
    .DAC0_ENABLE(DAC0_ENABLE),
    .DAC1_ENABLE(DAC1_ENABLE),
    .DAC2_ENABLE(DAC2_ENABLE),

    .DAC0_DATA(DAC0_DATA),
    .DAC1_DATA(DAC1_DATA),
    .DAC2_DATA(DAC2_DATA)
);

// Display modeul register initial //////////////////////////////////
task DMInitial;
begin

    apb_write(2'b10, DMCON, 32'h00000006);
    apb_write(2'b10, BGCOL, 32'hfffdfcfb);
    apb_write(2'b10, CCON,  32'h00000000);
    apb_write(2'b10, VCON,  32'h00000000);
    apb_write(2'b10, GBLND, {GPlaneAlphaValue, GPlaneChromaKey});

	apb_write(2'b10, GBMOD, {1'b0, GPlaneChromaKeyEn, 1'b0, GPlaneAlphaMode, 5'b0, GPlaneXPos, GPlaneYPos});
	apb_write(2'b10, GBASE, 32'h00000000);
	apb_write(2'b10, GADDR, 32'h00000000);
	apb_write(2'b10, SCON,  32'h00000000);

	apb_write(2'b10, HSYNC0, {16'b0, LCDHBP, LCDHFP});
	apb_write(2'b10, HSYNC1, {LCDHSW, LCDCPL});
	apb_write(2'b10, VSYNC0, {16'b0, LCDVBP, LCDVFP});
	apb_write(2'b10, VSYNC1, {LCDVSW, LCDLPS});
	//apb_write(2'b01, VIDCON, {VideoSyncEn, VideoBP, 18'b0, VideoBPWait});
	apb_write(2'b10, LCDCON, {LCDEn, LCDPwrEn, 20'b0, LCDBPP, LCDBGR, LCDIEO, LCDIVS, LCDIHS, 4'b0});
	apb_write(2'b10, GCON,  {GPlaneEn, 1'b0, GPlanePixFormat, GPlaneGammaEn, 4'b0, GPlaneXSize, GPlaneYSize});

end
endtask

// Video register initial ///////////////////////////////////////////
wire  [31:0] Address_00h_DATA; //Video Encoder Stauts register
wire  [31:0] Address_04h_DATA; //Video Encoder Control register
wire  [31:0] Address_08h_DATA; //Video Encoder Internal control register
wire  [31:0] Address_0Ch_DATA; //Subcarrier adjust phase register
wire  [31:0] Address_10h_DATA; //Subcarrier frequency register

assign  Address_04h_DATA = {`OUT_MODE,
                             2'b00,
                            `EN_NONINTERLACE,
                            `EN_SQPIXEL,22'd0,
                            `EN_DAC2, `EN_DAC1, `EN_DAC0};

assign  Address_08h_DATA = { 3'd0, 
                            `HSYNC_WID, 
                            `BURST_WID, 
                            `LUMA_DELAY, 
                            `CHRO_DELAY, 
                             2'd0,
                            `EN_INTERNAL_PATTERN, 
                            `COLOR_PATTERN_MODE,
                            `EN_RESET_SCH, 
                            `EN_COLOR_KILL,
                             3'd0, 
                            `LUMA_FILTER_SEL, 
                            `CHRO_FILTER_SEL, 
                             4'd0};

assign  Address_0Ch_DATA = {16'd0, `SUB_PHASE};
assign  Address_10h_DATA = `SUB_REQ;

task VideoInitial;
begin
    apb_write(2'b01, `VideoEncADDRREG1, Address_04h_DATA);
    apb_write(2'b01, `VideoEncADDRREG2, Address_08h_DATA);
    apb_write(2'b01, `VideoEncADDRREG3, Address_0Ch_DATA);
    if(Address_10h_DATA !== 32'd0)
        apb_write(2'b01, `VideoEncADDRREG4, Address_10h_DATA);

    apb_write(2'b01, `VideoEncADDRREG0, {`ENABLE, 31'd0});
end
endtask

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
