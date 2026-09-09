
`timescale 1ns/10ps

//`define TIMING
//`define WAVE

//`define SINGLE
`define BURST

//`define MISS

module TbSDR;

parameter CKP1 = 3.76/2;
parameter QCKD = 3.76/4;

parameter DLY  = 0.5;
parameter SDLY = 2;

`include "../Rtl/SDRPara.v"

reg			 porb;
reg          rstb; 
reg          ACLK; 
reg			 MCLK;
wire         SDclk;
wire [RAW:0] #SDLY SDadr;
wire [BAW:0] #SDLY SDba;
wire         #SDLY SDcsb;
wire         #SDLY SDrasb;
wire         #SDLY SDcasb;
wire         #SDLY SDweb;
wire [DMW:0] #SDLY SDdqm;
wire		 #SDLY SDcke;

wire         SDdate;
wire [MDW:0] SDdati;
wire [MDW:0] SDdato;
tri  [MDW:0] SDdat;

assign #SDLY SDdat  = SDdate ? SDdato : {MDW+1{1'bz}};
assign #QCKD SDdati = SDdat;

wire 		 SDdqse;
tri  [DMW:0] SDdqs;
wire [DMW:0] SDdqso;
wire [DMW:0] SDdqsi;

assign #DLY  SDdqs  = SDdqse ? SDdqso : {DMW+1{1'bz}};
assign #QCKD SDdqsi = SDdqs;

assign SDclk  = ACLK;

// Write Command
wire        AWReady;
reg  [31:0] AWAddr;
reg  [BBL:0] AWLen;
reg  [ID:0] AWId;
reg         AWValid;
reg  [1:0]  AWBurst;

// Write Data Bus Interface
reg  		WValid;
reg 		WLast;
wire 		WReady;
reg  [BW:0] WStrb;
reg  [DW:0] WData;
reg  [ID:0] WId;

// Write Response
wire [1:0]	BResp;
reg			BReady;
wire		BValid;
wire [ID:0] BId;

// Read Command
wire        ARReady;
reg  [31:0] ARAddr;
reg  [BBL:0] ARLen;
reg  [ID:0] ARId;
reg         ARValid;
reg  [1:0]  ARBurst;

// Read Data
wire 		RLast;
wire 		RValid;
reg  		RReady;
wire [ 1:0] RResp;
wire [DW:0] RData;
wire [ID:0] RId;

// Controller Interface
wire [13:0] Status = TbSDR.SDRTop.BA_STS;

// Register Interface
reg         PENABLE;     // Data valid strobe 
reg         PSEL   ;     // Module select signal
reg         PWRITE ;     // Write/nRead signal
reg  [ 7:2] PADDR  ;     // Address (used bits only)
reg  [31:0] PWDATA ;     // Read data
wire [31:0] PRDATA ;     // Read data

SDRTop SDRTop(
		.MCLK		(MCLK),
		.ACLK		(ACLK), 
		.ARESETB	(rstb),
		.PORESETB	(porb),

		.AWAddr		(AWAddr[AW+2:2]),
		.AWLen		(AWLen),
		.AWValid	(AWValid),
		.AWReady	(AWReady),
		.AWId		(AWId),
		.AWBurst	(AWBurst),
	
		.WLast		(WLast),
		.WStrb  	(WStrb ),
		.WData   	(WData ),
		.WValid		(WValid),
		.WReady		(WReady),
		.WId		(WId),

		.BResp 		(BResp ),
    	.BValid		(BValid),
    	.BReady		(BReady),
    	.BId		(BId),
    	
		.ARAddr		(ARAddr[AW+2:2]),
		.ARLen		(ARLen),
		.ARValid	(ARValid),
		.ARReady	(ARReady),
		.ARId		(ARId),
		.ARBurst	(ARBurst),

		.RReady		(RReady),
		.RValid		(RValid),
		.RResp		(RResp),
		.RLast		(RLast),
		.RData   	(RData),
		.RId		(RId),
		
		.PCLK		(ACLK), 
		.PRESETB	(rstb),
		.PENABLE 	(PENABLE), 
		.PSEL    	(PSEL), 
		.PWRITE  	(PWRITE), 
		.PADDR   	(PADDR), 
		.PWDATA  	(PWDATA),
		.PRDATA  	(PRDATA),
		
		.SD_CSB		(SDcsb), 
		.SD_RASB	(SDrasb), 
		.SD_CASB	(SDcasb), 
		.SD_WEB		(SDweb), 
		.SD_CKE		(SDcke), 
		.SD_BADDR	(SDba), 
		.SD_ADDR	(SDadr),
		.SD_DQE		(SDdate),
		.SD_DQI		(SDdati), 
		.SD_DQO		(SDdato),
		.SD_DQM		(SDdqm),
		.SD_DQSE	(SDdqse),
		.SD_DQSO	(SDdqso),
		.SD_DQSI	(SDdqsi)
);

//initial force sdram16bit.Debug = 1;

ddr sdram16bit (
                   .Dq		(SDdat),
                   .Addr	(SDadr),
                   .Ba		(SDba),
                   .Clk		(SDclk),
                   .Clk_n	(~SDclk),
                   .Cke		(SDcke),
                   .Cs_n	(SDcsb),
                   .Ras_n	(SDrasb),
                   .Cas_n	(SDcasb),
                   .We_n	(SDweb),
                   .Dqs		(SDdqs), 
                   .Dm		(SDdqm)
);

/*
ddr sdram16bitLow (
                   .Dq		(SDdat[31:16]),
                   .Addr	(SDadr),
                   .Ba		(SDba),
                   .Clk		(SDclk),
                   .Clk_n	(~SDclk),
                   .Cke		(SDcke),
                   .Cs_n	(SDcsb),
                   .Ras_n	(SDrasb),
                   .Cas_n	(SDcasb),
                   .We_n	(SDweb),
                   .Dqs		(SDdqs[3:2]), 
                   .Dm		(SDdqm[3:2])
);
*/

//always #CKP1 ACLK = ~ACLK;

always #CKP1 MCLK = ~MCLK;

always @(negedge rstb or posedge MCLK) 
  if (!rstb) ACLK <= 1'b0;
  else       ACLK <= #DLY ACLK + 1;

integer i, j;
//--------------------------------------------------
task APBRead;
input [31:0] Addr;
begin
  #DLY PADDR   = Addr[7:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b0;
	repeat(1) @(posedge ACLK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge ACLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
	repeat(3) @(posedge ACLK);
end
endtask

task APBWrite;
input [31:0] Addr;
input [31:0] WData;
begin
  #DLY PADDR   = Addr[7:2];
       PENABLE = 1'b0;
       PSEL    = 1'b1;
       PWRITE  = 1'b1;
       PWDATA  = WData;
	repeat(1) @(posedge ACLK);
  #DLY PENABLE = 1'b1;
	repeat(1) @(posedge ACLK);
  #DLY PENABLE = 1'b0;
       PSEL    = 1'b0;
       PWRITE  = 1'b0;
	repeat(3) @(posedge ACLK);
end
endtask
//--------------------------------------------------
task AXIWriteCmd;
     input [31:0] address;
     input [BBL:0] length;
     input [ID:0] aid;
     input  [1:0] burst;
begin
                    #DLY AWLen   = length;
                         AWAddr  = address;
                         AWValid = 1'b1;
                         AWId    = aid;
                         AWBurst = burst;
	 if(AWReady) @(posedge ACLK);
	 else while(!AWReady) @(posedge ACLK);
	 				#DLY AWValid = 1'b0;
//                         AWId    = 0;
	repeat(1) @(posedge ACLK);
end
endtask

task AXIWriteData;
	 input [BW:0] length;
     input [BW:0] beb;
     input [DW:0] data;
     input [ID:0] did;
begin
                    #DLY WData  = data;
                         WStrb  = ~beb;
                         WValid = 1'b1;
                         WId    = did;
	for (j=0;j<length+1;j=j+1) begin
	 WLast  <= (length==j);
	 if(WReady) @(posedge ACLK);
	 else while(!WReady) @(posedge ACLK);
	 				#DLY WData  = WData  + 2;
	end
                    #DLY WStrb  = {BW+1{1'b1}};
                    	 WValid = 1'b0;
                         j = 0;
//                         WId    <= 0;
	repeat(1) @(posedge ACLK);
end
endtask

//assign WLast = (AWLen==j) ? 1'b1 : 1'b0;
always @(posedge ACLK) #DLY BReady <= BValid;

task AXIReadCmd;
     input [31:0] address;
     input [BBL:0] length;
     input [ID:0] id;
     input  [1:0] burst;
begin
                    #DLY ARLen   = length;
                         ARAddr  = address;
                         ARValid = 1'b1;
                         ARId    = id;
                         ARBurst = burst;
	 if(ARReady) @(posedge ACLK);
	 else while(!ARReady) @(posedge ACLK);
	 				#DLY ARValid = 1'b0;
//                         ARId    = 0;
	repeat(1) @(posedge ACLK);
end
endtask
//--------------------------------------------------
reg DataEn;
reg ReadEn;

task SingleWrite;
begin
// Same Bank and Different Row Read/Write
  DataEn = 1'b1;
  AXIWriteCmd(32'h00000000, 0, 0, 1);
  AXIWriteCmd(32'h00000204, 0, 1, 1);
  AXIWriteCmd(32'h00000408, 0, 2, 1);
  AXIWriteCmd(32'h0000060c, 0, 3, 1);
  AXIWriteCmd(32'h00000100, 0, 4, 1);
  AXIWriteCmd(32'h00000304, 0, 5, 1);
  AXIWriteCmd(32'h00000508, 0, 6, 1);
  AXIWriteCmd(32'h0000070c, 0, 7, 1);

// Same Bank & Row Write/Read
  AXIWriteCmd(32'h00000010, 0, 0, 1);
  AXIWriteCmd(32'h00000014, 0, 1, 1);
  AXIWriteCmd(32'h00000018, 0, 2, 1);
  AXIWriteCmd(32'h0000001c, 0, 3, 1);
  AXIWriteCmd(32'h00000020, 0, 4, 1);
  AXIWriteCmd(32'h00000024, 0, 5, 1);
  AXIWriteCmd(32'h00000028, 0, 6, 1);
  AXIWriteCmd(32'h0000002c, 0, 7, 1);

// Different Bank and Row Read/Write
  AXIWriteCmd(32'h00000f00, 0, 0, 1);
  AXIWriteCmd(32'h01000204, 0, 1, 1);
  AXIWriteCmd(32'h02000408, 0, 2, 1);
  AXIWriteCmd(32'h0300060c, 0, 3, 1);
  AXIWriteCmd(32'h00000110, 0, 4, 1);
  AXIWriteCmd(32'h01000304, 0, 5, 1);
  AXIWriteCmd(32'h02000508, 0, 6, 1);
  AXIWriteCmd(32'h0300070c, 0, 7, 1);

// Mix Read/Write
  AXIWriteCmd(32'h01000000, 0, 0, 1);
  AXIWriteCmd(32'h02000204, 0, 1, 1);
  AXIWriteCmd(32'h01000408, 0, 2, 1);
  AXIWriteCmd(32'h0200060c, 0, 3, 1);
  AXIWriteCmd(32'h01000100, 0, 4, 1);
  AXIWriteCmd(32'h02000304, 0, 5, 1);
  AXIWriteCmd(32'h01000508, 0, 6, 1);
  AXIWriteCmd(32'h0200070c, 0, 7, 1);

// Mix Single/Burst
  AXIWriteCmd(32'h03000000, 3, 8, 1);
  AXIWriteCmd(32'h03000000, 0, 9, 1);
  
  // DQM Mask Test
  AXIWriteCmd(32'h03000010, 0, 10, 1);
  AXIWriteCmd(32'h03000010, 0, 11, 1);
end
endtask

task SingleData;
begin
// Same Bank and Different Row Read/Write
  AXIWriteData(0, 2'b0, 32'h00001110, 0);
  AXIWriteData(0, 2'b0, 32'h00002220, 1);
  AXIWriteData(0, 2'b0, 32'h00003330, 2);
  AXIWriteData(0, 2'b0, 32'h00004440, 3);
  AXIWriteData(0, 2'b0, 32'h00001111, 4);
  AXIWriteData(0, 2'b0, 32'h00002222, 5);
  AXIWriteData(0, 2'b0, 32'h00003333, 6);
  AXIWriteData(0, 2'b0, 32'h00004444, 7);

// Same Bank & Row Write/Read
  AXIWriteData(0, 2'b0, 32'h00005551, 0);
  AXIWriteData(0, 2'b0, 32'h00006661, 1);
  AXIWriteData(0, 2'b0, 32'h00007771, 2);
  AXIWriteData(0, 2'b0, 32'h00008881, 3);
  AXIWriteData(0, 2'b0, 32'h00005555, 4);
  AXIWriteData(0, 2'b0, 32'h00006666, 5);
  AXIWriteData(0, 2'b0, 32'h00007777, 6);
  AXIWriteData(0, 2'b0, 32'h00008888, 7);

// Different Bank and Row Read/Write
  AXIWriteData(0, 2'b0, 32'h00009992, 0);
  AXIWriteData(0, 2'b0, 32'h0000aaa2, 1);
  AXIWriteData(0, 2'b0, 32'h0000bbb2, 2);
  AXIWriteData(0, 2'b0, 32'h0000ccc2, 3);
  AXIWriteData(0, 2'b0, 32'h00009999, 4);
  AXIWriteData(0, 2'b0, 32'h0000aaaa, 5);
  AXIWriteData(0, 2'b0, 32'h0000bbbb, 6);
  AXIWriteData(0, 2'b0, 32'h0000cccc, 7);

// Mix Read/Write
  AXIWriteData(0, 2'b0, 32'h0000ddd3, 0);
  AXIWriteData(0, 2'b0, 32'h0000eee3, 1);
  AXIWriteData(0, 2'b0, 32'h0000fff3, 2);
  AXIWriteData(0, 2'b0, 32'h00000003, 3);
  AXIWriteData(0, 2'b0, 32'h0000dddd, 4);
  AXIWriteData(0, 2'b0, 32'h0000eeee, 5);
  AXIWriteData(0, 2'b0, 32'h0000ffff, 6);
  AXIWriteData(0, 2'b0, 32'h00000000, 7);

// Mix Single/Burst
  AXIWriteData(3, 2'b0, 32'h00001110, 8);
  AXIWriteData(0, 2'b0, 32'h00001111, 9);
  
  // DQM Mask Test
  AXIWriteData(0, 2'b01, 32'h0000ee00, 10);
  AXIWriteData(0, 2'b10, 32'h000000dd, 11);
  DataEn = 1'b0;
end
endtask

task SingleRead;
begin
// Same Bank and Different Row Read/Write
  AXIReadCmd(32'h00000000, 0, 0, 1);
  AXIReadCmd(32'h00000204, 0, 1, 1);
  AXIReadCmd(32'h00000408, 0, 2, 1);
  AXIReadCmd(32'h0000060c, 0, 3, 1);
  AXIReadCmd(32'h00000100, 0, 4, 1);
  AXIReadCmd(32'h00000304, 0, 5, 1);
  AXIReadCmd(32'h00000508, 0, 6, 1);
  AXIReadCmd(32'h0000070c, 0, 7, 1);

// Same Bank & Row Write/Read
  AXIReadCmd(32'h00000010, 0, 0, 1);
  AXIReadCmd(32'h00000014, 0, 1, 1);
  AXIReadCmd(32'h00000018, 0, 2, 1);
  AXIReadCmd(32'h0000001c, 0, 3, 1);
  AXIReadCmd(32'h00000020, 0, 4, 1);
  AXIReadCmd(32'h00000024, 0, 5, 1);
  AXIReadCmd(32'h00000028, 0, 6, 1);
  AXIReadCmd(32'h0000002c, 0, 7, 1);

// Different Bank and Row Read/Write
  AXIReadCmd(32'h00000f00, 0, 0, 1);
  AXIReadCmd(32'h01000204, 0, 1, 1);
  AXIReadCmd(32'h02000408, 0, 2, 1);
  AXIReadCmd(32'h0300060c, 0, 3, 1);
  AXIReadCmd(32'h00000110, 0, 4, 1);
  AXIReadCmd(32'h01000304, 0, 5, 1);
  AXIReadCmd(32'h02000508, 0, 6, 1);
  AXIReadCmd(32'h0300070c, 0, 7, 1);

// Mix Read/Write
  AXIReadCmd(32'h01000000, 0, 0, 1);
  AXIReadCmd(32'h02000204, 0, 1, 1);
  AXIReadCmd(32'h01000408, 0, 2, 1);
  AXIReadCmd(32'h0200060c, 0, 3, 1);
  AXIReadCmd(32'h01000100, 0, 4, 1);
  AXIReadCmd(32'h02000304, 0, 5, 1);
  AXIReadCmd(32'h01000508, 0, 6, 1);
  AXIReadCmd(32'h0200070c, 0, 7, 1);

// Mix Single/Burst
  AXIReadCmd(32'h03000000, 0, 8, 1);
  AXIReadCmd(32'h03000004, 0, 8, 1);
  AXIReadCmd(32'h03000008, 0, 9, 1);
  AXIReadCmd(32'h0300000c, 0, 9, 1);
  AXIReadCmd(32'h03000000, 3, 10, 1);

  // DQM Mask Test
  AXIReadCmd(32'h03000010, 0, 11, 1);
end
endtask

task BurstWrite;
begin
// Different Bank & Row
  DataEn = 1'b1;
`ifdef MISS
  AXIWriteCmd(32'h000007F4, 7, 0, 1);
`else
  AXIWriteCmd(32'h0000000C, 12, 0, 1);
`endif
`ifdef MISS
  AXIWriteCmd(32'h010027F8, 8, 1, 1);
`else
  AXIWriteCmd(32'h01002018, 8, 1, 1);
`endif
  AXIWriteCmd(32'h02004020, 1, 2, 1);
  AXIWriteCmd(32'h03008034, 3, 3, 2);
  AXIWriteCmd(32'h00001000, 3, 4, 1);
  AXIWriteCmd(32'h01003010, 3, 5, 1);
  AXIWriteCmd(32'h02005020, 3, 6, 1);
  AXIWriteCmd(32'h03007030, 3, 7, 1);

// Different Row & Same Bank
  AXIWriteCmd(32'h00000040, 3, 0, 1);
  AXIWriteCmd(32'h00002010, 3, 1, 1);
  AXIWriteCmd(32'h00004020, 3, 2, 1);
  AXIWriteCmd(32'h00008030, 3, 3, 1);

// Same Bank & Row
  AXIWriteCmd(32'h00000050, 1, 4, 1);
  AXIWriteCmd(32'h00000064, 1, 5, 2);
  AXIWriteCmd(32'h00000020, 1, 6, 1);
  AXIWriteCmd(32'h00000030, 1, 7, 1);

// Mix Single/Burst
  AXIWriteCmd(32'h00010000, 15, 8, 1);
  AXIWriteCmd(32'h00020000, 0, 9, 1);

  // DQM Mask Test
  AXIWriteCmd(32'h00030000, 3, 10, 1);
end
endtask

task BurstData;
begin
// Different Bank & Row
  AXIWriteData(12, 2'b0, 32'h00001110, 0);
  AXIWriteData(8, 2'b0, 32'h00002220, 1);
  AXIWriteData(1, 2'b0, 32'h00003330, 2);
  AXIWriteData(3, 2'b0, 32'h00004440, 3);
  AXIWriteData(3, 2'b0, 32'h00001100, 4);
  AXIWriteData(3, 2'b0, 32'h00002200, 5);
  AXIWriteData(3, 2'b0, 32'h00003300, 6);
  AXIWriteData(3, 2'b0, 32'h00004400, 7);

// Different Row & Same Bank
  AXIWriteData(3, 2'b0, 32'h00005550, 0);
  AXIWriteData(3, 2'b0, 32'h00006660, 1);
  AXIWriteData(3, 2'b0, 32'h00007770, 2);
  AXIWriteData(3, 2'b0, 32'h00008880, 3);

// Same Bank & Row
  AXIWriteData(1, 2'b0, 32'h00009990, 4);
  AXIWriteData(1, 2'b0, 32'h0000aaa0, 5);
  AXIWriteData(1, 2'b0, 32'h0000bbb0, 6);
  AXIWriteData(1, 2'b0, 32'h0000ccc0, 7);

// Mix Single/Burst
  AXIWriteData(15, 2'b0, 32'h0000ddd0, 8);
  AXIWriteData(0, 2'b0, 32'h0000eeee, 9);

  // DQM Mask Test
  AXIWriteData(3, 2'b0, 32'h0000fff0, 10);
  DataEn = 1'b0;
end
endtask

task BurstRead;
begin
// Different Bank & Row
`ifdef MISS
  AXIReadCmd(32'h000007F4, 7, 0, 1);
  AXIReadCmd(32'h010027F8, 8, 1, 1);
`else
  AXIReadCmd(32'h0000000C, 12, 0, 1);
  AXIReadCmd(32'h01002018, 8, 1, 1);
`endif
  AXIReadCmd(32'h02004020, 1, 2, 1);
  AXIReadCmd(32'h03008034, 3, 3, 2);
  AXIReadCmd(32'h00001000, 3, 4, 1);
  AXIReadCmd(32'h01003010, 3, 5, 1);
  AXIReadCmd(32'h02005020, 3, 6, 1);
  AXIReadCmd(32'h03007030, 3, 7, 1);

// Different Row & Same Bank
  AXIReadCmd(32'h00000040, 3, 0, 1);
  AXIReadCmd(32'h00002010, 3, 1, 1);
  AXIReadCmd(32'h00004020, 3, 2, 1);
  AXIReadCmd(32'h00008030, 3, 3, 1);

// Same Bank & Row
  AXIReadCmd(32'h00000050, 1, 4, 1);
  AXIReadCmd(32'h00000060, 1, 5, 1);
  AXIReadCmd(32'h00000020, 1, 6, 1);
  AXIReadCmd(32'h00000030, 1, 7, 1);

// Mix Single/Burst
  AXIReadCmd(32'h00010000, 15, 8, 1);
  AXIReadCmd(32'h00020000, 0, 9, 1);

  // DQM Mask Test
  AXIReadCmd(32'h00030000, 3, 10, 1);
end
endtask
//--------------------------------------------------
// Initialize
initial begin
  porb  = 1;
  rstb  = 1;
  MCLK   = 0;

  AWAddr  = 0; 
  AWLen   = 0;
  AWValid = 0;
  AWId    = 0;
  AWBurst = 0;

  ARAddr  = 0; 
  ARLen   = 0;
  ARValid = 0;
  ARId    = 0;
  ARBurst = 0;
  
  BReady = 1;
  
  WStrb  = 0; 
  WData  = 0; 
  WValid = 0;
  WLast  = 0;
  WId    = 0;

//  RReady = 0;

  PADDR   = 0;
  PWDATA  = 0;
  PENABLE = 0;
  PSEL    = 0;
  PWRITE  = 0;
  
  DataEn  = 0;
  ReadEn  = 0;
end

always @(posedge ACLK) RReady <= 1;//$random/16;
//--------------------------------------------------
// Main Routine
// Reset Routine
initial begin
  repeat(10) @(posedge MCLK);
  #(3) porb = 1'b0;
  repeat(10) @(posedge MCLK);
  #(3) porb = 1'b1;
       rstb = 1'b0;
  repeat(10) @(posedge MCLK);
  #(3) rstb = 1'b1;
  $display ("Reset Disabled, Simulation Start NOW >>>");
end

// Register Set
initial begin  
// timing parameters
// +------------+-----------+---------------+----------------------------------------+
// |  symbol    |  default  |  alternative  |  description                           |
// +------------+-----------+---------------+----------------------------------------+
// |  tmrs      |     2                     |  mode register set time                |
// |  trp       |     3     |   4,  2       |  precharge time                  		 |
// |  trrd      |     2                     |  row active to row active              |
// |  trcd      |     3     |   4,  2       |  ras to cas delay                 	 |
// |  tcl       |     3     |   2           |  cas latency                           |
// |  trasmin   |     8     |   9,  7,  5   |  row active time min                   |
// |  trasmax   |   100 usec                |  row active time max (not used)        |
// |  trc       |    11     |  13, 10,  7   |  row cycle time = trp + trasmin        |
// |  trdl      |     2                     |  last data in to precharge (not used)  |
// |  trefresh  |   62.5 usec (6144)        |  4 auto refresh time                   |
// +------------+-----------+---------------+----------------------------------------+
  
  repeat(200) @(posedge ACLK); // 200usec wait
  APBWrite(32'h00000000, 32'h0000_b91a); //{trc, trasmin,  1'b0, tcl, trcd, trp}
  APBWrite(32'h00000004, 32'h0000_0003); // SDRAM Enable & Swap Disable
//  APBWrite(32'h00000004, 32'h0000_0001); // SDRAM Enable & Swap Enable
//  APBWrite(32'h0000000C, 32'h0003_17FF); // 64us, 4 Refresh
//  APBWrite(10'h008, 32'h0001_00FF); // Power Down Enable
  APBWrite(10'h00C, 32'h0001_01FF); // short simulation
  APBRead(10'h000);
  APBRead(10'h004);
  APBRead(10'h008);
  APBRead(10'h00C);
end

initial begin 
  repeat(300) @(posedge ACLK);

`ifdef SINGLE
  SingleWrite;
  repeat(100) @(posedge ACLK);
  SingleRead;
  repeat(200) @(posedge ACLK);

  ReadEn=1;
  SingleWrite;
`endif

`ifdef BURST
  BurstWrite;
  repeat(100) @(posedge ACLK);
  BurstRead;
  repeat(200) @(posedge ACLK);

  ReadEn=1;
  BurstWrite;
`endif

  repeat(300) @(posedge ACLK);
//  while(!Status[2]) @(posedge ACLK);
  DataEn = 1'b0;
  ReadEn=0;
  repeat(200) @(posedge ACLK);

/*
// Self Refresh Test  
  APBWrite(10'h008, 32'h8000_00FF); // self refresh enable
  repeat(1000) @(posedge ACLK);
  APBWrite(10'h008, 32'h0000_00FF); // self refresh clear
  repeat(100) @(posedge ACLK);

  BurstWrite;BurstRead;
  while(!Status[2]) @(posedge ACLK);
  repeat(100) @(posedge ACLK);
*/

 $finish;
end

initial begin
  repeat(300) @(posedge ACLK);

  forever @(posedge ACLK) begin
  if(DataEn) begin
`ifdef SINGLE  
  SingleData;
`endif

`ifdef BURST  
  BurstData;
`endif
  end
  end
  
  repeat(300) @(posedge ACLK);
end

initial begin 
  repeat(300) @(posedge ACLK); // should wait after SDREn

  wait(ReadEn); 
`ifdef SINGLE
  repeat(30) @(posedge ACLK);
  SingleRead;
`endif

`ifdef BURST
  repeat(30) @(posedge ACLK);
  BurstRead;
`endif

  repeat(300) @(posedge ACLK);
end
//------------------------------------------------------
integer BusRead0;
initial begin
  BusRead0 = $fopen("./Result/BusOut0.txt");
  forever @(posedge ACLK) begin
    if (RValid & RReady & (RResp == 0)) $fdisplay(BusRead0, "%d:%h", RId, RData[15:0]);
  end
end
//------------------------------------------------------
`ifdef TIMING
initial $sdf_annotate("./Syn/Sdf/SDRCtl.noscan.sdf", SDRCtl);
`endif
//------------------------------------------------------
`ifdef WAVE
initial begin
  $shm_open("TbSDR.shm");
  $shm_probe(TbSDR, "ASC");
end
`endif
//------------------------------------------------------
endmodule
