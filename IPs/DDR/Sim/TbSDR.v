
`timescale 1ns/10ps

//`define TIMING
//`define WAVE
//`define PWDN

module TbSDR;

parameter CKP1 = 3.76/2;
parameter DLY  = 0.5;
parameter SDLY = 2;
parameter QCKD = CKP1/2;

`include "../Rtl/SDRPara.v"

reg			 PORESETB;
reg          ARESETB; 
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

wire         #0.5 SDdate;
wire [MDW:0] SDdati;
wire [MDW:0] SDdato;
tri  [MDW:0] SDdat;

assign #SDLY SDdat  = SDdate ? SDdato : {MDW+1{1'bz}};
assign #CKP1 SDdati = SDdat;

wire 		 #0.5 SDdqse;
tri  [DMW:0] SDdqs;
wire [DMW:0] SDdqso;
wire [DMW:0] SDdqsi;

assign #SDLY  SDdqs  = SDdqse ? SDdqso : {DMW+1{1'bz}};
assign #CKP1 SDdqsi = SDdqs;	// Input Pad Delay

assign SDclk  = ACLK;

// Write Command
wire         AWReady;
wire  [31:0] AWAddr;
wire  [BBL:0] AWLen;
wire  [ID:0] AWId;
wire         AWValid;
wire [2:0]   AWSize;
wire [1:0]   AWBurst;

// Write Data Bus Interface
wire  		WValid;
wire 		WLast;
wire 		WReady;
wire  [BW:0] WStrb;
wire  [DW:0] WData;
wire  [ID:0] WId;

// Write Response
wire [1:0]	BResp;
wire		BReady;
wire		BValid;
wire [ID:0] BId;

// Read Command
wire         ARReady;
wire  [31:0] ARAddr;
wire  [BBL:0] ARLen;
wire  [ID:0] ARId;
wire         ARValid;
wire [2:0]   ARSize;
wire [1:0]   ARBurst;

// Read Data
wire 		RLast;
wire 		RValid;
wire  		RReady;
wire [DW:0] RData;
wire [ID:0] RId;
wire [1:0]  RResp;

// Controller Interface
wire [14:0] Status = TbSDR.SDRTop.BA_STS;

// Register Interface
reg         PENABLE;     // Data valid strobe 
reg         PSEL   ;     // Module select signal
reg         PWRITE ;     // Write/nRead signal
reg  [ 7:2] PADDR  ;     // Address (used bits only)
reg  [31:0] PWDATA ;     // Read data
wire [31:0] PRDATA ;     // Read data

wire #0.1 nMCLK = ~MCLK;
wire #0.1 nACLK = ~ACLK;
SDRTop SDRTop(
			.ACLK			(ACLK), 
			.nACLK			(nACLK),
			.ARESETB		(ARESETB),
			.nPOR			(ARESETB),
			.MCLK			(MCLK),
			.nMCLK			(nMCLK),

			.AWAddr			(AWAddr[AW+2:2]),
			.AWLen			(AWLen),
			.AWValid		(AWValid),
			.AWReady		(AWReady),
			.AWId			(AWId),
			.AWBurst		(AWBurst),
	    	            	
			.WLast			(WLast),
			.WStrb  		(WStrb ),
			.WData   		(WData ),
			.WValid			(WValid),
			.WReady			(WReady),
			.WId			(WId),
        	            	
			.BResp 			(BResp ),
    		.BValid			(BValid),
    		.BReady			(BReady),
    		.BId			(BId),
    		            	
			.ARAddr			(ARAddr[AW+2:2]),
			.ARLen			(ARLen),
			.ARValid		(ARValid),
			.ARReady		(ARReady),
			.ARId			(ARId),
			.ARBurst		(ARBurst),
        	            	
			.RReady			(RReady),
			.RValid			(RValid),
			.RLast			(RLast),
			.RData   		(RData),
			.RId			(RId),
			.RResp			(RResp),
			            	
			.PCLK			(ACLK), 
			.PRESETB		(ARESETB),
			.PENABLE 		(PENABLE), 
			.PSEL    		(PSEL), 
			.PWRITE  		(PWRITE), 
			.PADDR   		(PADDR), 
			.PWDATA  		(PWDATA),
			.PRDATA  		(PRDATA),
			            	
			.SD_CSB			(SDcsb), 
			.SD_RASB		(SDrasb), 
			.SD_CASB		(SDcasb), 
			.SD_WEB			(SDweb), 
			.SD_CKE			(SDcke), 
			.SD_BADDR		(SDba), 
			.SD_ADDR		(SDadr),
			.SD_DQE			(SDdate),
			.SD_DQI			(SDdati), 
			.SD_DQO			(SDdato),
			.SD_DQM			(SDdqm),
			.SD_DQSE		(SDdqse),
			.SD_DQSO		(SDdqso),
			.SD_DQSI		(SDdqsi)
);

TestMaster TestMaster
(
			.ACLK			(ACLK),
			.ARESETn		(ARESETB),
        	            	
			.AWID			(AWId),
			.AWADDR			(AWAddr),
			.AWLEN			(AWLen),
			.AWSIZE			(AWSize),
			.AWBURST		(AWBurst),
			.AWLOCK			(),
			.AWCACHE		(),
			.AWPROT			(),
			.AWVALID		(AWValid),
			.AWREADY		(AWReady),
        	            	
			.WID			(WId),
			.WDATA			(WData),
			.WSTRB			(WStrb),
			.WLAST			(WLast),
			.WVALID			(WValid),
			.WREADY			(WReady),
        	            	
			.BID			(BId),
			.BRESP			(BResp),
			.BVALID			(BValid),
			.BREADY			(BReady),
        	            	
			.ARID			(ARId),
			.ARADDR			(ARAddr),
			.ARLEN			(ARLen),
			.ARSIZE			(ARSize),
			.ARBURST		(ARBurst),
			.ARLOCK			(),
			.ARCACHE		(),
			.ARPROT			(),
			.ARVALID		(ARValid),
			.ARREADY		(ARReady),
        	
			// Read Data Channel
			.RID			(RId),
			.RDATA			(RData),
			.RRESP			(RResp),
			.RLAST			(RLast),
			.RVALID			(RValid),
			.RREADY			(RReady)
);

`ifdef DEBUG
defparam sdram16bit.Debug = 1;
`endif

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

always #CKP1 MCLK = ~MCLK;

always @(negedge ARESETB or posedge MCLK) 
  if (!ARESETB) ACLK <= 1'b0;
  else          ACLK <= #DLY ACLK + 1;

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
// Initialize
initial begin
//  PORESETB  = 1;
  ARESETB  = 1;
//  ARESETB  = 0;
  MCLK   = 0;

  PADDR   = 0;
  PWDATA  = 0;
  PENABLE = 0;
  PSEL    = 0;
  PWRITE  = 0;
end
//--------------------------------------------------
// Main Routine
// Reset Routine
initial begin
  repeat(10) @(posedge MCLK);
//  #(3) PORESETB = 1'b0;
//  repeat(10) @(posedge MCLK);
//  #(3) PORESETB = 1'b1;
       ARESETB = 1'b0;
  repeat(10) @(posedge MCLK);
  #(3) ARESETB = 1'b1;
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
  
  repeat(200) @(posedge MCLK); // 200usec wait
  APBWrite(32'h00000000, 32'h0000_b91a);
//  APBWrite(32'h00000000, 32'h0000_b92a); // CL2.5
//  APBWrite(32'h00000004, 32'h0000_0003); // SDRAM Enable & Swap Disable
  APBWrite(32'h00000004, 32'h0000_8011); // SDRAM Enable & Swap Enable
//  APBWrite(32'h00000008, 32'h0001_00FF); // power down enable
//  APBWrite(32'h0000000C, 32'h0003_2080); // 64us, 4 Refresh
  APBWrite(32'h0000000C, 32'h0000_0820); // 15.6us, 1 Refresh at 133MHz
  APBRead(10'h000);
  APBRead(10'h004);
  APBRead(10'h008);
  APBRead(10'h00C);

`ifdef PWDN
  #10000;

  for(i=0;i<100;i=i+1) begin
// Self Refresh Test  
  APBWrite(10'h008, 32'h8000_00FF); // self refresh enable
  repeat(10000) @(posedge ACLK);
  APBWrite(32'h00000008, 32'h0000_00FF); // self refresh clear
  repeat(20000) @(posedge ACLK);
  end
`endif

end
//------------------------------------------------------
`ifdef SAMPLE
wire #1 SampleClk = SDclk;

reg [10:0] Count;
always @(negedge ARESETB or posedge SampleClk)
    if (!ARESETB)   Count <= 0;
    else            Count <= Count + 1;

wire SampleCountEn = Count[10] & $random/32;

integer SampleCount;
always @(negedge ARESETB or posedge SampleClk)
    if  (!ARESETB)              SampleCount <= 0;
    else begin
        if (!SampleCountEn)     SampleCount <= 0;
        else begin
            if (SDdat === {MDW+1{1'bz}}) 
								SampleCount <= SampleCount;
            else                SampleCount <= SampleCount + 2;
        end
    end

integer SampleReport;
initial begin
  SampleReport = $fopen("./Result/SampleReport.txt");
  forever @(posedge SampleClk) begin
    if (SampleCountEn & (&Count) & TestMaster.SampleEn) $fdisplay(SampleReport, "%d", SampleCount);
  end
end
`endif
//------------------------------------------------------
`ifdef STROBE
integer BusRead0;
initial begin
  BusRead0 = $fopen("./Result/BusOut0.txt");
  forever @(posedge ACLK) begin
    if (RValid & RReady) $fdisplay(BusRead0, "%d:%h", RId, RData[15:0]);
  end
end
`endif
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
