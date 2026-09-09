
`timescale 1ns/10ps

module TbSEIP;

`include "SEIPPara.v"

parameter CKP1 = 5; // 100MHz
parameter DLY  = 2;

reg MCK;
reg XRST;

reg           TI4, TE, TI0, TI3, TI2, TI1;
wire          TO4, TO0, TO1, TO3, TO2;

reg         PENABLE;
reg         PSEL;
reg         PWRITE;
reg  [13:0] PADDR;
reg  [31:0] PWDATA;
wire [31:0] PRDATA;
wire		PREADY;

wire		RxDmaRequest;
wire		TxDmaRequest;
wire		SEIPInt;

reg           SDI1, SDI2;
wire          SCKO, ADMCK, LRCKO, SD2O, SD1O, MLRCK, MSCK;

wire  [23:0]  WEMA;
wire   #2     EXMBIH, XWEMOC, XWEMWE;

tri	   [7:0]  WEMD;

wire  [7:0]   WEMDO;
wire  [7:0]   WEMDI;

assign WEMDO = WEMD;
assign WEMD  = ~XWEMOC ? WEMDI : 8'bz;

reg	 SerialEn;
reg	 PcmRxEn;
integer i, j;

wire [15:0]EEMA_M;
wire [31:0]EEMDI_M;
wire [ 3:0]XEEMWE_M;
wire [31:0]EEMDO_M;
//------------------------------------------------------
s29gl128m_r2 NorFlash
(
    .A22      (WEMA[23]),
    .A21      (WEMA[22]),
    .A20      (WEMA[21]),
    .A19      (WEMA[20]),
    .A18      (WEMA[19]),
    .A17      (WEMA[18]),
    .A16      (WEMA[17]),
    .A15      (WEMA[16]),
    .A14      (WEMA[15]),
    .A13      (WEMA[14]),
    .A12      (WEMA[13]),
    .A11      (WEMA[12]),
    .A10      (WEMA[11]),
    .A9       (WEMA[10]),
    .A8       (WEMA[9]),
    .A7       (WEMA[8]),
    .A6       (WEMA[7]),
    .A5       (WEMA[6]),
    .A4       (WEMA[5]),
    .A3       (WEMA[4]),
    .A2       (WEMA[3]),
    .A1       (WEMA[2]),
    .A0       (WEMA[1]),

    .DQ15     (WEMA[0]),
    .DQ14     (),
    .DQ13     (),
    .DQ12     (),
    .DQ11     (),
    .DQ10     (),
    .DQ9      (),
    .DQ8      (),
    .DQ7      (WEMD[7]),
    .DQ6      (WEMD[6]),
    .DQ5      (WEMD[5]),
    .DQ4      (WEMD[4]),
    .DQ3      (WEMD[3]),
    .DQ2      (WEMD[2]),
    .DQ1      (WEMD[1]),
    .DQ0      (WEMD[0]),

    .CENeg    (1'b0),
    .OENeg    (~XWEMWE),
    //.OENeg    (EXMBIH),
    .WENeg    (XWEMWE),
    .RESETNeg (XRST),
    .WPNeg    (1'b1),	// Can Write
    .BYTENeg  (1'b0),	// 8bit Mode
    .RY		()
);

//initial $sdf_annotate("../Mod/s29gl128m_r2_verilog.ftm", NorFlash);
//------------------------------------------------------
SEIPTop SEIP(
// System
		.MCK		(MCK),
		.XRST		(XRST),
		
		.TE			(TE),
		.TI0		(TI0),
		.TI1		(TI1),
		.TI2		(TI2),
		.TI3		(TI3),
		.TI4		(TI4),
		.TO0		(TO0),
		.TO1		(TO1),
		.TO2		(TO2),
		.TO3		(TO3),
		.TO4		(TO4),

// MPU Interface
    	.PSEL		(PSEL), 
    	.PENABLE	(PENABLE), 
    	.PADDR		(PADDR[13:2]), 
    	.PWRITE		(PWRITE), 
    	.PWDATA		(PWDATA), 
		.PRDATA		(PRDATA),
		.PREADY		(PREADY),

		.RxDmaRequest(RxDmaRequest),
		.TxDmaRequest(TxDmaRequest),
		.SEIPInt	(SEIPInt),

// RAM4 Interface
		.EEMA_M		(EEMA_M), 
		.EEMDI_M	(EEMDI_M), 
		.EEMDO_M	(EEMDO_M), 
		.XEEMWE_M	(XEEMWE_M), 

// I2S Interface
		.SD1O		(SD1O),
		.SD2O		(SD2O),
		.LRCKO		(LRCKO),
		.SCKO		(SCKO),
		.ADMCK		(ADMCK),
		.SDI1		(SDI1),
		.SDI2		(SDI2),
		.MLRCK		(MLRCK),
		.MSCK		(MSCK),

// Wave-Table ROM Interface
		.WEMA		(WEMA),
		.WEMDO		(WEMDO),
		.WEMDI		(WEMDI),
		.EXMBIH		(EXMBIH),
		.XWEMOC		(XWEMOC),
		.XWEMWE		(XWEMWE)
);

// Mux btw. Internal SRAM and RAM4
//wire		 RAM4Sel = 1;
reg 		 RAM4Sel;
wire  [14:0] #2 RAM4_A;
wire  [ 3:0] #2 RAM4_WEn;
reg   [31:0] RAM4_D;
wire  [31:0] RAM4_Q;
wire  [31:0] RAM4_Q0;
wire  [31:0] RAM4_Q1;

RA1SH16384x32 RAM4_0(
        .CLK     	(MCK),
`ifdef TEST
        .nRST    	(XRST),
`endif
        .A    		(RAM4_A[13:0]),
        .CEN     	(RAM4_A[14]),
        .WEN     	(RAM4_WEn),
        .Q   		(RAM4_Q0),
        .D			(RAM4_D)
);

RA1SH16384x32 RAM4_1(
        .CLK     	(MCK),
`ifdef TEST
        .nRST    	(XRST),
`endif
        .A    		(RAM4_A[13:0]),
        .CEN     	(~RAM4_A[14]),
        .WEN     	(RAM4_WEn),
        .Q   		(RAM4_Q1),
        .D			(RAM4_D)
);

assign RAM4_Q = RAM4_A[14] ? RAM4_Q1 : RAM4_Q0;

/*
wire [14:0] IntSRAM_A;
wire [31:0] IntSRAM_D;
wire [ 3:0] IntSRAM_WEn;
*/
reg  [14:0] IntSRAM_A;
reg  [31:0] IntSRAM_D;
reg  [ 3:0] IntSRAM_WEn;

assign RAM4_A   = RAM4Sel ? EEMA_M    : IntSRAM_A;
assign RAM4_WEn = RAM4Sel ? XEEMWE_M  : IntSRAM_WEn;

always @(RAM4Sel or EEMDI_M or IntSRAM_D)
	if (RAM4Sel) #2 RAM4_D =  EEMDI_M;
	else 		 #2 RAM4_D = IntSRAM_D;

assign EEMDO_M = RAM4_Q;
//------------------------------------------------------
// Clock Define
always #CKP1 MCK = ~MCK;
//------------------------------------------------------
reg [15:0] RData;
always @(posedge MCK)
	if (PREADY & PSEL & PENABLE)
		RData <= PRDATA;
//------------------------------------------------------
//`include "./Include/WaveRom.v"
//`include "./Include/MPUIfTask.v"
`include "./Include/PeriRWTask.v"
`include "./Include/MPUInitial.v"
`include "./Include/SerialIn.v"
`include "./Include/FunctionTest.v"
//`include "./Include/PCMRX.v"
//------------------------------------------------------
// Initialize
initial begin
  	XRST = 0;
  	MCK  = 0;
  	TE   = 0;
	TI0 = 0;
	TI1 = 0;
	TI2 = 0;
	TI3 = 0;
	TI4 = 0;

	SDI1 = 0; 
    SDI2 = 0;

//	WEMDO = 0;

	SerialEn = 0;
	PcmRxEn  = 0;

	IntSRAM_A = 0;
	IntSRAM_D = 0;
	IntSRAM_WEn = 4'hf;
	RAM4Sel = 0;
end

// Main Routine
initial begin
  	repeat(18) @(posedge MCK);
//	MPUInitial;
//  	$display ("MPU Initialize End NOW >>>");
  	repeat(10) @(posedge MCK);

  	#(DLY) XRST = 1'b1;
  	$display ("Reset Disabled, Simulation Start NOW >>>");

  	repeat(30) @(posedge MCK);
	APBWrite(SEIPRST, 0);	// SEIP Reset Active
	APBWrite(SEIPRST, 1);	// SEIP Reset Release

/*
// initialize
for(i=0;i<256;i=i+1) begin
	APBWrite(12'h000+i, 16'h0000);
end
*/

`ifdef RAM4TEST
//for(i=0;i<65536;i=i+1) begin
for(i=0;i<32768;i=i+1) begin
	IntSRAM_A   = i;
	IntSRAM_D   = i;
	IntSRAM_WEn = 0;
  	repeat(1) @(posedge MCK);
end
	IntSRAM_WEn = 4'hf;

	i = 0;

/*
for(i=0;i<32768;i=i+1) begin
	IntSRAM_A   = i;
  	//@(posedge MCK)
	//if (RAM4_Q !== i) $display ("RAM4 ERROR");
  	repeat(2) @(posedge MCK);
end
*/

	RAM4Sel = 1;
`endif

	MPUInitial;
  	$display ("MPU Initialize End NOW >>>");
	RAM4Sel = 1;

/*
  	#(DLY) XRST = 1'b0;
  	repeat(30) @(posedge MCK);
  	#(DLY) XRST = 1'b1;
*/
	APBWrite(SEIPRST, 0);	// SEIP Reset Active
	APBWrite(SEIPRST, 1);	// SEIP Reset Release

  	repeat(1600) @(posedge MCK);
	FunctionTest;
end

// Serial Data Input Interface
initial begin
	@(posedge XRST);
  	repeat(10) @(posedge MCK);

	wait(SerialEn);

	@(negedge MLRCK);	SerialIn1(20'hC98B4);
	@(negedge MSCK);    SerialIn1(20'h6374B);
	@(negedge MLRCK);   SerialIn1(20'h4d1AC);
	@(negedge MSCK);    SerialIn1(20'hA8D3C);
	@(negedge MLRCK);   SerialIn1(20'h4CA76);
    @(negedge MSCK);    SerialIn1(20'hB269C);
end

initial begin
	@(posedge XRST);
  	repeat(10) @(posedge MCK);

	wait(SerialEn);

	@(negedge MLRCK);	SerialIn2(20'hB3A65);
    @(negedge MSCK);    SerialIn2(20'h4C59A);
	@(negedge MLRCK);   SerialIn2(20'hB2E53);
	@(negedge MSCK);    SerialIn2(20'h572C3);
	@(negedge MLRCK);   SerialIn2(20'hB3589);
	@(negedge MSCK);    SerialIn2(20'h4D936);
end

// PCM RX Interface
wire        RxDmaEn = 1'b1;
wire        RxDmaReqIntEn = 1'b1;
wire        RxDmaErrIntEn = 1'b1;
wire [2:0]  RxDmaSize = 3'd1;	// one by one Process
wire        RxDmaReset = 1'b1;
wire        RxFIFOFlush = 1'b1;

initial begin
    repeat(1) @(posedge SEIP.SEIP.XRST);
    repeat(1000) @(posedge MCK);

	//wait(PcmRxEn);
	//@(negedge MLRCK);
    APBWrite(RXCON,	{24'b0, 1'b0, RxDmaSize, 1'b0, RxDmaErrIntEn, RxDmaReqIntEn, RxDmaEn});
	wait(RxDmaRequest);
	APBWrite(RXDAT, 32'h00000000);
	APBWrite(RXDAT, 32'hCCCC3333);
	APBWrite(RXDAT, 32'h66669999);
	APBWrite(RXDAT, 32'hFFFF0000);
	APBWrite(RXSTS, 32'h00000000);	// Interrupt Status Clear
    APBWrite(RXCON,	{24'b0, 1'b0, RxDmaSize, 1'b0, RxDmaErrIntEn, 1'b0, RxDmaEn});	// Request Interrupt Clear

	repeat(3) @(posedge SEIP.RXSYNC);

  	repeat(20000) @(posedge MCK);

	$stop;
end


// PCM TX Interface
wire        TxDmaEn = 1'b1;
wire        TxDmaReqIntEn = 1'b1;
wire        TxDmaErrIntEn = 1'b1;
wire [2:0]  TxDmaSize = 3'd4;	// Burst 4 for DDR
//wire [2:0]  TxDmaSize = 3'd1;	// Single
wire        TxDmaReset = 1'b1;
wire        TxFIFOFlush = 1'b1;

initial begin
    repeat(2) @(posedge SEIP.SEIP.XRST);
    repeat(10000) @(posedge MCK);

	APBWrite(TXCON, {24'b0, 1'b0, TxDmaSize, 1'b0, TxDmaErrIntEn, TxDmaReqIntEn, TxDmaEn}); 
	forever @(posedge TxDmaRequest) begin
		APBRead(TXDAT);
		APBRead(TXDAT);
		APBRead(TXDAT);
		APBRead(TXDAT);
		APBWrite(TXSTS, 32'h00000000);	// Interrupt Status Clear
	end
end

//------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("../Syn/Sdf/SEIPTop.sdf", SEIP);
//initial $sdf_annotate("../Syn/Sdf/SEIP_o.sdf", SEIP.SEIP);
//initial $sdf_annotate("../Syn/Org/SEIP.sdf", SEIP);
`endif
//------------------------------------------------------
`ifdef STROBE
integer MpuReadLog;
integer MpuWriteLog;
initial MpuReadLog   = $fopen("./Result/MpuRead.log");
initial MpuWriteLog  = $fopen("./Result/MpuWrite.log");

always @(posedge MCK)
	if (PREADY & PENABLE & PWRITE & PSEL) $fdisplay(MpuWriteLog, "MPU Write Address:%h, Data:%h", PADDR[12:2], PWDATA[15:0]);

/*
integer MpuWriteLog0;
initial MpuWriteLog0 = $fopen("./Result/MpuWrite_org.log");
always @(posedge MCK)
	if (SEIP.PRDY & ~SEIP.XPWE) $fdisplay(MpuWriteLog0, "MPU Write Address:%h, Data:%h", SEIP.PIA, SEIP.PIDI);
*/

always @(posedge SEIP.XPOE)
	if (SEIP.PRDY) $fdisplay(MpuReadLog, "MPU Read Address:%h, Data:%h", SEIP.PIA, SEIP.PIDO);

integer sd1oLog;
initial sd1oLog  = $fopen("./Result/sd1o.log");

reg [19:0] sd1oRegL;
reg [19:0] sd1oRegR;

initial begin
	@(posedge XRST);
  	repeat(10) @(posedge MCK);

// Left Channel SDO1 Output
forever @(posedge MCK) begin
	@(posedge LRCKO);
	@(posedge SCKO) sd1oRegL[19] = SD1O;
    @(posedge SCKO) sd1oRegL[18] = SD1O;
    @(posedge SCKO) sd1oRegL[17] = SD1O;
    @(posedge SCKO) sd1oRegL[16] = SD1O;
    @(posedge SCKO) sd1oRegL[15] = SD1O;
    @(posedge SCKO) sd1oRegL[14] = SD1O;
    @(posedge SCKO) sd1oRegL[13] = SD1O;
    @(posedge SCKO) sd1oRegL[12] = SD1O;
    @(posedge SCKO) sd1oRegL[11] = SD1O;
    @(posedge SCKO) sd1oRegL[10] = SD1O;
    @(posedge SCKO) sd1oRegL[9]  = SD1O;
    @(posedge SCKO) sd1oRegL[8]  = SD1O;
    @(posedge SCKO) sd1oRegL[7]  = SD1O;
    @(posedge SCKO) sd1oRegL[6]  = SD1O;
    @(posedge SCKO) sd1oRegL[5]  = SD1O;
    @(posedge SCKO) sd1oRegL[4]  = SD1O;
    @(posedge SCKO) sd1oRegL[3]  = SD1O;
    @(posedge SCKO) sd1oRegL[2]  = SD1O;
    @(posedge SCKO) sd1oRegL[1]  = SD1O;
    @(posedge SCKO) sd1oRegL[0]  = SD1O;
	$fdisplay(sd1oLog, "Left  Channel1 Data = %h", sd1oRegL);
end
end

initial begin
    @(posedge XRST);
    repeat(10) @(posedge MCK);

// Right Channel SDO1 Output
forever @(posedge MCK) begin
    @(negedge LRCKO);
    @(posedge SCKO) sd1oRegR[19] = SD1O;
    @(posedge SCKO) sd1oRegR[18] = SD1O;
    @(posedge SCKO) sd1oRegR[17] = SD1O;
    @(posedge SCKO) sd1oRegR[16] = SD1O;
    @(posedge SCKO) sd1oRegR[15] = SD1O;
    @(posedge SCKO) sd1oRegR[14] = SD1O;
    @(posedge SCKO) sd1oRegR[13] = SD1O;
    @(posedge SCKO) sd1oRegR[12] = SD1O;
    @(posedge SCKO) sd1oRegR[11] = SD1O;
    @(posedge SCKO) sd1oRegR[10] = SD1O;
    @(posedge SCKO) sd1oRegR[9]  = SD1O;
    @(posedge SCKO) sd1oRegR[8]  = SD1O;
    @(posedge SCKO) sd1oRegR[7]  = SD1O;
    @(posedge SCKO) sd1oRegR[6]  = SD1O;
    @(posedge SCKO) sd1oRegR[5]  = SD1O;
    @(posedge SCKO) sd1oRegR[4]  = SD1O;
    @(posedge SCKO) sd1oRegR[3]  = SD1O;
    @(posedge SCKO) sd1oRegR[2]  = SD1O;
    @(posedge SCKO) sd1oRegR[1]  = SD1O;
    @(posedge SCKO) sd1oRegR[0]  = SD1O;
    $fdisplay(sd1oLog, "Right Channel1 Data = %h", sd1oRegR);
end
end

integer PCMTXLog;
initial PCMTXLog = $fopen("./Result/PCMTX.log");
always @(posedge MCK)
	if (SEIP.TXRD & SEIP.TXRDY) $fdisplay(PCMTXLog, "PCM TX L/R DATA:%h", SEIP.TXD);
`endif
//------------------------------------------------------
`ifdef WAVE
initial begin
  $shm_open("TbSEIP.shm");
  $shm_probe("ASC");
end
`endif

endmodule
