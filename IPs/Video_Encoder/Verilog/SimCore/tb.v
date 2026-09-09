// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is Video encoder test bench module
// =======================================================================

`timescale 1ns/1ps
`define NCSIM

//`define __DebugTest__

//Register setting value /////////////////////////////////////////////////
//modify this area for setting register

`define ENABLE  1'b1

`define	EN_DAC0	1'b1	//composite output
`define	EN_DAC1	1'b1	//Y output
`define	EN_DAC2	1'b1	//C output

`define	EN_SQPIXEL	        1'b0	//Squre pixel enable 
`define EN_NONINTERLACE     1'b0    //non-interlace mode
`define OUT_MODE            3'b000  

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

`define LUMA_FILTER_SEL     2'b00 //luma filter selector
`define CHRO_FILTER_SEL     2'b00 //chrominance filter selector
`define EN_RESET_SCH        1'b0
`define EN_INTERNAL_PATTERN 1'b1
`define EN_COLOR_KILL       1'b0
`define COLOR_PATTERN_MODE  2'b00
`define EN_100_COLOR        1'b0
`define CHRO_DELAY          3'b000
`define LUMA_DELAY          3'b000

`define BURST_WID           2'b01
`define HSYNC_WID           3'b010

`define SUB_PHASE           16'd0
`define SUB_REQ             32'd0

`define SATURATION_YLEV  8'd0
`define SATURATION_CLEV  8'd0
`define HUE_LEV         8'd0
`define BRIGHT_LEV      6'b00000

`define BURST_LEV       3'b100
`define BLACK_VALUE     10'd0
`define BLANK_VALUE     10'd0
`define HSYNC_LOW       10'd0

//ADDRESS//

`define VideoEncADDRREG0  4'b0000      //0x00   status register addr.
`define VideoEncADDRREG1  4'b0001      //0x04   Control register addr.
`define VideoEncADDRREG2  4'b0010      //0x08   Internal register addr.
`define VideoEncADDRREG3  4'b0011      //0x0C   Subcarrier adjust phase register addr.
`define VideoEncADDRREG4  4'b0100      //0x10   Subcarrier frequency step register addr.

`define VideoEncADDRREG5  4'b0101
`define VideoEncADDRREG6  4'b0110
`define VideoEncADDRREG7  4'b0111

//////////////////////////////////////////////////////////////////////////

module tb;

parameter TOTAL_PIXEL_NTSC=        1716;
parameter TOTAL_PIXEL_PAL =        1728;
parameter TOTAL_PIXEL_SQ_NTSC=     1560;
parameter TOTAL_PIXEL_SQ_PAL =     1888;

parameter TOTAL_LINE_NTSC         = 525;
parameter TOTAL_LINE_PAL          = 625;
parameter TOTAL_LINE_NTSC_NOINTER = 262;
parameter TOTAL_LINE_PAL_NOINTER  = 312;

parameter MAXAddrCnt_NTSC    = TOTAL_PIXEL_NTSC * TOTAL_LINE_NTSC * 2;
parameter MAXAddrCnt_SQ_NTSC = TOTAL_PIXEL_SQ_NTSC * TOTAL_LINE_NTSC * 2;
parameter MAXAddrCnt_PAL     = TOTAL_PIXEL_PAL * TOTAL_LINE_PAL * 4;     
parameter MAXAddrCnt_SQ_PAL  = TOTAL_PIXEL_SQ_PAL * TOTAL_LINE_PAL * 4;     

parameter MAXAddrCnt_NTSC_NOINTER = TOTAL_PIXEL_NTSC * TOTAL_LINE_NTSC_NOINTER;
parameter MAXAddrCnt_PAL_NOINTER  = TOTAL_PIXEL_PAL  * TOTAL_LINE_PAL_NOINTER ;

parameter PERIOD1=20.83;	// 24MHz
parameter PERIOD2=18.52;	// 27MHz
parameter PHASETIME1=(PERIOD1 / 2);
parameter PHASETIME2=(PERIOD2 / 2);
parameter SDLY=2;

wire  [31:0] Address_00h_DATA; //Video Encoder Stauts register
wire  [31:0] Address_04h_DATA; //Video Encoder Control register
wire  [31:0] Address_08h_DATA; //Video Encoder Internal control register
wire  [31:0] Address_0Ch_DATA; //Subcarrier adjust phase register
wire  [31:0] Address_10h_DATA; //Subcarrier frequency register

wire  [31:0] Address_14h_DATA; // Hue Saturation
wire  [31:0] Address_18h_DATA; 
wire  [31:0] Address_1Ch_DATA; 

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
                             1'd0,
                            `EN_100_COLOR,        
                            `EN_INTERNAL_PATTERN, 
                            `COLOR_PATTERN_MODE,
                            `EN_RESET_SCH, 
                            `EN_COLOR_KILL,
                             3'd0, 
                            `LUMA_FILTER_SEL, 
                            `CHRO_FILTER_SEL, 
                             4'd0};

assign  Address_0Ch_DATA = {16'd0,`SUB_PHASE};
assign  Address_10h_DATA = `SUB_REQ;

assign  Address_14h_DATA = {2'd0,`BRIGHT_LEV, `HUE_LEV, `SATURATION_CLEV, `SATURATION_YLEV};
assign  Address_18h_DATA = {6'd0, `BLANK_VALUE, 6'd0, `BLACK_VALUE};
assign  Address_1Ch_DATA = {13'd0,`BURST_LEV, 6'd0, `HSYNC_LOW};

reg   RESETn;
reg   Clock;
reg   Clock_27M;
reg   mHSYNCn [0:4600000];
reg   mVSYNCn [0:4600000];
reg   mBLANKn [0:4600000];
reg   [23:0] mRGBDATA [0:4600000];

reg	[5:2]	PADDR;
reg	[31:0]	PWDATA;
reg	PSEL;
reg	PWRITE;
reg	PENABLE;

wire   [31:0]  PRDATA;
wire   [7:0]   Rin;
wire   [7:0]   Gin;
wire   [7:0]   Bin;

wire  HSYNCn;
wire  VSYNCn;
wire  BLANKn;
wire  [23:0] RGBDATA;

integer DATAinCnt;
integer STARTs;   //Start signal, setting start signal after register setting

assign  HSYNCn = mHSYNCn[DATAinCnt];
assign  VSYNCn = mVSYNCn[DATAinCnt];
assign  BLANKn  = mBLANKn[DATAinCnt];
assign  RGBDATA= mRGBDATA[DATAinCnt];
assign  Rin    = RGBDATA[23:16];
assign  Gin    = RGBDATA[15:8];
assign  Bin    = RGBDATA[7:0];



always #PHASETIME1 Clock     = ~Clock;
always #PHASETIME2 Clock_27M = ~Clock_27M;

integer    DumpY;
integer    DumpC;
integer    DumpCVBS;
integer    DumpCnt;
integer    DumpSin;
integer    DumpCos;
integer    DumpFPGA;

initial begin
    DumpCnt = 0;
    DumpY  = $fopen("./Dump/Y.out");
    DumpC  = $fopen("./Dump/C.out");
    DumpCVBS  = $fopen("./Dump/Compsite.out");
    DumpSin= $fopen("./Dump/DumpSin.out");
    DumpCos= $fopen("./Dump/DumpCos.out");
    DumpFPGA= $fopen("./Dump/DumpFPGA.out");
end

`ifdef NCSIM
integer SetCnt;
initial begin
  SetCnt = 0;
  $shm_open("./VideoEnC.shm");
  //$shm_probe(Top.Core.SyntheSizer, "AS");
  $shm_probe(Top, "AS");
end

always @(posedge Clock_27M) begin
	if(Top.Core.RESET_ADDR && (SetCnt == 1)) begin
		$stop;
	end
	else if (Top.Core.RESET_ADDR && (SetCnt == 0)) begin
		SetCnt = SetCnt + 1;
	end
end
`endif

always @(posedge Clock_27M) begin

    if(STARTs) begin
        $fwrite(DumpY,"%d %d \n",DumpCnt, Top.DAC1_DATA);
        $fwrite(DumpC,"%d %d \n",DumpCnt, Top.DAC2_DATA);
        $fwrite(DumpCVBS,"%d %d \n",DumpCnt, Top.DAC0_DATA);
        $fwrite(DumpFPGA,"%x\n", (Top.DAC0_DATA[9:2]));
        $fwrite(DumpSin,"%d %d \n",DumpCnt, Top.Core.SIN + 512);
        $fwrite(DumpCos,"%d %d \n",DumpCnt, Top.Core.COS + 512);
        DumpCnt = DumpCnt + 1;
    end
end

`ifdef __DebugTest__

integer    OutSinCos_file;
integer    OutYUV_file;
integer    MULOut_file;

reg [10:0] TestSinCosAddr;
reg [23:0] TestRGB;
reg [20:0] USINinput;

reg [10:0]	   COS_IN [9000:0];
reg [10:0]	   SIN_IN [9000:0];
reg [9:0]	   U_IN [9000:0];
reg [9:0]	   V_IN [9000:0];

initial begin
    TestSinCosAddr = 0;
    TestRGB = 0;
    USINinput = 0;
    OutSinCos_file  = $fopen("./sincos.out");
    OutYUV_file = $fopen("./yuv.out");
    MULOut_file = $fopen("./Mul.out");
    force Top.Core.SubAddrGen.EN_TABLE = 0;
    force Top.Core.ENABLE_PIXEL = 1;

	$readmemh("./inputdata/SIN.in", SIN_IN );
	$readmemh("./inputdata/COS.in", COS_IN );
	$readmemh("./inputdata/U.in", U_IN);
	$readmemh("./inputdata/v.in", V_IN);

end

always @(posedge Clock_27M) begin

    if(STARTs) begin
        force Top.Core.SubAddrGen.ShiftADDR = TestSinCosAddr;
        $fwrite(OutSinCos_file,"%x %x %x\n",TestSinCosAddr, Top.Core.SubAddrGen.SIN, Top.Core.SubAddrGen.COS);
        TestSinCosAddr = TestSinCosAddr + 1;

        force Top.Core.Rout = TestRGB[23:16];
        force Top.Core.Gout = TestRGB[15:8];
        force Top.Core.Bout = TestRGB[7:0];
        $fwrite(OutYUV_file, "%d Y%x U%x V%x\n", TestRGB, Top.Core.RGB2YUV.ShiftY, Top.Core.RGB2YUV.ShiftU, Top.Core.RGB2YUV.ShiftV);
        TestRGB = TestRGB + 1;

        force Top.Core.SyntheSizer.SIN = SIN_IN[USINinput];
        force Top.Core.SyntheSizer.COS = COS_IN[USINinput];

        force Top.Core.SyntheSizer.Filtered_U = U_IN[USINinput];
        force Top.Core.SyntheSizer.Filtered_V = V_IN[USINinput];

        force Top.Core.SyntheSizer.ACT_DISPLAY_SYN = 1;
        force Top.Core.SyntheSizer.BURST_ENABLE = 0;
        $fwrite(MULOut_file,"%x\n",Top.Core.SyntheSizer.NormalC);
        USINinput = USINinput + 1;
        if(USINinput == 7000) begin
            USINinput = 0;
        end
    end
end

`endif

//Read RGB data
initial begin
    DATAinCnt = 0;
    /* NTSC format */
    if((`OUT_MODE & 3'b100) != 3'b100) begin 
        if(`EN_SQPIXEL) begin
            $readmemh("./NTSC_SQ_COLORBAR/HSYNC.in", mHSYNCn);
            $readmemh("./NTSC_SQ_COLORBAR/VSYNC.in", mVSYNCn);
            $readmemh("./NTSC_SQ_COLORBAR/BLANK.in", mBLANKn);
            $readmemh("./NTSC_SQ_COLORBAR/RGB.in",   mRGBDATA);
        end
        else begin
            $readmemh("./NTSC_COLORBAR/HSYNC.in", mHSYNCn);
            $readmemh("./NTSC_COLORBAR/VSYNC.in", mVSYNCn);
            $readmemh("./NTSC_COLORBAR/BLANK.in", mBLANKn);
            $readmemh("./NTSC_COLORBAR/RGB.in",   mRGBDATA);
        end
    end
    else begin
        if(`EN_SQPIXEL) begin
            $readmemh("./PAL_SQ_COLORBAR/HSYNC.in", mHSYNCn);
            $readmemh("./PAL_SQ_COLORBAR/VSYNC.in", mVSYNCn);
            $readmemh("./PAL_SQ_COLORBAR/BLANK.in", mBLANKn);
            $readmemh("./PAL_SQ_COLORBAR/RGB.in",   mRGBDATA);
        end
        else begin
            $readmemh("./PAL_COLORBAR/HSYNC.in", mHSYNCn);
            $readmemh("./PAL_COLORBAR/VSYNC.in", mVSYNCn);
            $readmemh("./PAL_COLORBAR/BLANK.in", mBLANKn);
            $readmemh("./PAL_COLORBAR/RGB.in",   mRGBDATA);
        end
    end

    PENABLE = 0    ;     // Data valid strobe 
    PSEL   	= 0    ;     // Module select signal
    PWRITE  = 0    ;     // Write/nRead signal
    PADDR  	= 0    ;     // Address (used bits only)
    PWDATA  = 0    ;     // Read data

end
  
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
always @(negedge Clock_27M) begin
    if(STARTs == 1 && `EN_INTERNAL_PATTERN == 1'b0) begin
        DATAinCnt = DATAinCnt + 1;
        /* NTSC format */
        if((`OUT_MODE & 3'b100) != 3'b100) begin 
            if(`EN_SQPIXEL && (DATAinCnt == MAXAddrCnt_SQ_NTSC)) begin
                DATAinCnt = 0;
            end
            else if(`EN_NONINTERLACE && (DATAinCnt == MAXAddrCnt_NTSC_NOINTER) ) begin
                DATAinCnt = 0;
            end
            else if(DATAinCnt == MAXAddrCnt_NTSC)begin
                DATAinCnt = 0;
            end
        end
        /* PAL format */
        else begin             
            if(`EN_SQPIXEL && (DATAinCnt == MAXAddrCnt_SQ_PAL)) begin
                DATAinCnt = 0;
            end
            else if(`EN_NONINTERLACE && (DATAinCnt == MAXAddrCnt_PAL_NOINTER) ) begin
                DATAinCnt = 0;
            end
            else if(DATAinCnt == MAXAddrCnt_PAL)begin
                DATAinCnt = 0;
            end
        end
    end
end

//Clock&Reset generation
initial begin
    Clock = 0;
    Clock_27M = 0;
end

//APB register setting
initial begin

    STARTs = 0;
	RESETn = 1'b0;
	repeat(100) @(posedge Clock);
	#(SDLY) RESETn = 1'b1;

    apb_write(`VideoEncADDRREG1, Address_04h_DATA);
    apb_write(`VideoEncADDRREG2, Address_08h_DATA);
    apb_write(`VideoEncADDRREG3, Address_0Ch_DATA);
    if(Address_10h_DATA !== 32'd0)
        apb_write(`VideoEncADDRREG4, Address_10h_DATA);

    if(Address_14h_DATA !== 32'd0)
        apb_write(`VideoEncADDRREG5, Address_14h_DATA);

    if(Address_18h_DATA !== 32'd0)
        apb_write(`VideoEncADDRREG6, Address_18h_DATA);

    if(Address_1Ch_DATA !== 32'd0)
        apb_write(`VideoEncADDRREG7, Address_1Ch_DATA);

    apb_write(`VideoEncADDRREG0, {`ENABLE, 31'd0});
    STARTs = 1;
end

wire    PCLK = Clock;


// TASK for write and read //////////////////////////////////////////
task apb_write; // write
input [31:0] reg_addr;
input [31:0] reg_write;
begin
    @(negedge PCLK);
    PENABLE = 1'b0;
    @(posedge PCLK);
	#2
        PSEL = 1'b1;
        PWRITE = 1'b1;
        PADDR = reg_addr;
        PWDATA = reg_write;
	
    @(posedge PCLK)

    #2  PENABLE = 1'b1;

    @(posedge PCLK)

    #2  $display($time, " << address [%h]      write data [%h] >> ", reg_addr, reg_write);
        PENABLE = 1'b0;
        PSEL    = 1'b0;
        PWDATA  = 32'dz;
end
endtask

task apb_read; // read
input [31:0] reg_addr;
begin
    @(negedge PCLK);
    PENABLE = 1'b0;

    @(posedge PCLK);
        #2  PSEL = 1'b1;
            PWRITE = 1'b0;
            PADDR = reg_addr;
    @(posedge PCLK)
        #2  PENABLE = 1'b1;
    @(posedge PCLK)
            $display($time, " << address [%h]      read data [%h] >> ", reg_addr, PRDATA );
        #2  PENABLE = 1'b0;
            PSEL = 1'b0;
end
endtask
//////////////////////////////////////////////////////////////////


VideoEncTop Top
(
//  APB bus
    .PCLK     (Clock),
    .RESETn  (RESETn),

    .PENABLE  (PENABLE  ), 
    .PSEL     (PSEL     ), 
    .PWRITE   (PWRITE   ), 
    .PADDR    (PADDR    ),  //[5:2]  used
    .PWDATA   (PWDATA   ),  //[31:0] used
    .PRDATA   (PRDATA   ),  //[31:0] used

//input
    .CLK(Clock_27M),       // 27Mhz clock input
    .HSYNCn(HSYNCn),
    .VSYNCn(VSYNCn),
    .BLANKn(BLANKn),
    .Rin(Rin),
    .Gin(Gin),
    .Bin(Bin),

//output
    .DAC0_ENABLE(),
    .DAC1_ENABLE(),
    .DAC2_ENABLE(),

    .DAC0_DATA(),
    .DAC1_DATA(),
    .DAC2_DATA()
);

endmodule
