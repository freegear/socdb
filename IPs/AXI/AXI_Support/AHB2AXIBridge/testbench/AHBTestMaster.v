// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AHBTestMaster.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            :
//  =============================================================================

`timescale 1ns/10ps

module AHBTestMaster 	// AHB-lite master
(
		HCLK     , 
		HRESETn  , 
		HADDR    ,
		HTRANS   ,
		HWRITE   ,
		HSIZE    ,
		HBURST   ,
		HPROT    ,
		HLOCK    ,	// same timing with HMASTLOCK
		HWDATA   ,
		HRDATA   ,
		HREADY   ,
		HRESP
);

parameter RANDOMIZE = 1;

//
// input/output port
//
input  HCLK;
input  HRESETn;

output [31:0]          HADDR;
output [ 1:0]          HTRANS;
output                 HWRITE;
output [2:0]           HSIZE;
output [2:0]           HBURST;
output [3:0]           HPROT;
output                 HLOCK;
output [31:0]          HWDATA;
input  [31:0]          HRDATA;
input                  HREADY;
input  [1:0]           HRESP;


`define HTRANS_NSEQ 2'b10
`define HTRANS_SEQ  2'b11
`define HTRANS_IDLE 2'b00
`define HTRANS_BUSY 2'b01

`define HRESP_OKAY  2'b00
`define HRESP_ERROR 2'b01

`define HBURST_SINGLE 3'b000
`define HBURST_INCR   3'b001
`define HBURST_WRAP4  3'b010
`define HBURST_INCR4  3'b011
`define HBURST_WRAP8  3'b100
`define HBURST_INCR8  3'b101
`define HBURST_WRAP16 3'b110
`define HBURST_INCR16 3'b111

`define HSIZE_BYTE  3'b000
`define HSIZE_HWORD 3'b001
`define HSIZE_WORD  3'b010

reg  [31:0]          HADDR;
reg  [ 1:0]          HTRANS;
reg                  HWRITE;
reg  [2:0]           HSIZE;
reg  [2:0]           HBURST;
reg  [3:0]           HPROT;
reg                  HLOCK;
reg  [31:0]          HWDATA;

// Que
reg         QUE_RINDEX;
reg         QUE_WINDEX;
reg  [31:0] HADDR_Q[1:0];
reg         HWRITE_Q[1:0];
reg  [3:0]  HSIZE_Q[1:0];
reg  [2:0]  HBURST_Q[1:0];
reg  [3:0]  BURSTLEN_Q[1:0];

wire QUE_empty = (QUE_RINDEX == QUE_WINDEX) ? 1'b1 : 1'b0;
function QUE_full;
	QUE_full  = (QUE_RINDEX == ~QUE_WINDEX) ? 1'b1 : 1'b0;
endfunction

reg  [4:0]  DATAQUE_RINDEX;
reg  [4:0]  DATAQUE_WINDEX;
reg  [31:0] HDATA_Q[31:0];

reg  [31:0] NextHADDR;
reg  [31:0] HADDRMask;
always @(HBURST)
begin
	case(HBURST[2:1])
	2'b00: HADDRMask <= 32'h00000000;
	2'b01: HADDRMask <= 32'hfffffffc;
	2'b10: HADDRMask <= 32'hfffffff8;
	2'b10: HADDRMask <= 32'hfffffff0;
	endcase
end

always @(HADDR or HSIZE or HADDRMask)
begin
	case(HSIZE)
	`HSIZE_BYTE:	// byte
		NextHADDR = (HADDR&HADDRMask)|((HADDR + 1)&(~HADDRMask));
	`HSIZE_HWORD: // half word
		NextHADDR = (HADDR&(HADDRMask<<1))|((HADDR + 2)&(~(HADDRMask<<1)));
	`HSIZE_WORD: // word
		NextHADDR = (HADDR&(HADDRMask<<2))|((HADDR + 4)&(~(HADDRMask<<2)));
	default:
	begin
		$display("Cannot support larger size than word");
		$stop;
	end
	endcase
end

reg  [3:0]  BURSTLEN;
reg  ReadDataCheck;
reg  RANDOMBit;
always @(posedge HCLK or negedge HRESETn)
begin
	if(!HRESETn)
	begin
		QUE_RINDEX <= 0;
		DATAQUE_RINDEX <= 0;
		HADDR <= 32'h00000000;
		HTRANS <= `HTRANS_IDLE;
		HSIZE <= 3'b010;	// always 32 bit transfer
		HPROT <= 0;
		HLOCK <= 0;
		HWDATA <= 32'h00000000;
		ReadDataCheck <= 1'b0;
		BURSTLEN <= 0;
	end
	else
	begin
		if(RANDOMIZE == 1)
			RANDOMBit = $random/16;

		if(HREADY == 1'b1 && ReadDataCheck == 1'b1)
		begin
			if(HRDATA !== HDATA_Q[DATAQUE_RINDEX])
			begin
				$display("Read Data(%h) is not expected value(%h)", HRDATA, HDATA_Q[DATAQUE_RINDEX]);
				$stop;
			end
			DATAQUE_RINDEX = DATAQUE_RINDEX + 1'b1;
		end

		if(HTRANS == `HTRANS_IDLE && HREADY == 1'b1)
		begin
			if(QUE_empty == 1'b0)
			begin
				HADDR <= HADDR_Q[QUE_RINDEX];
				HTRANS <= `HTRANS_NSEQ;
				HWRITE <= HWRITE_Q[QUE_RINDEX];
				HSIZE <= HSIZE_Q[QUE_RINDEX];
				HBURST <= HBURST_Q[QUE_RINDEX];
				BURSTLEN <= BURSTLEN_Q[QUE_RINDEX];
				QUE_RINDEX <= QUE_RINDEX + 1'b1;
			end
			ReadDataCheck <= 1'b0;
		end
		else
		begin
			if(HREADY == 1'b1)
			begin
				if(BURSTLEN != 0)
				begin
					if(RANDOMIZE == 0 || RANDOMBit == 0)
					begin
						HADDR <= NextHADDR;
						HTRANS <= `HTRANS_SEQ;
						BURSTLEN <= BURSTLEN - 1'b1;
					end
					else
						HTRANS <= `HTRANS_BUSY;
				end
				else if(QUE_empty == 1'b0 && (RANDOMIZE == 0 || RANDOMBit == 0))
				begin
					HADDR <= HADDR_Q[QUE_RINDEX];
					HTRANS <= `HTRANS_NSEQ;
					HWRITE <= HWRITE_Q[QUE_RINDEX];
					HSIZE <= HSIZE_Q[QUE_RINDEX];
					HBURST <= HBURST_Q[QUE_RINDEX];
					BURSTLEN <= BURSTLEN_Q[QUE_RINDEX];
					QUE_RINDEX <= QUE_RINDEX + 1'b1;
				end
				else
				begin
					HTRANS <= `HTRANS_IDLE;
				end

				if(HTRANS == `HTRANS_NSEQ || HTRANS == `HTRANS_SEQ)
				begin
					if(HWRITE == 1'b1)
					begin
						HWDATA <= HDATA_Q[DATAQUE_RINDEX];
						DATAQUE_RINDEX = DATAQUE_RINDEX + 1'b1;
						ReadDataCheck <= 1'b0;
					end
					else
						ReadDataCheck <= 1'b1;
				end
				else
				begin
					HWDATA <= 32'hxxxxxxxx;
					ReadDataCheck <= 1'b0;
				end
			end
		end
	end
end

// Response Check
always @(posedge HCLK)
begin
	if(HRESETn == 1'b1 && HREADY == 1'b1 && HRESP != `HRESP_OKAY)
	begin
		$display("HRESP is not OKAY");
		$stop;
	end
end

task AHBTrans4;
	input [31:0] haddr;
	input        hwrite;
	input [3:0]  hsize;
	input [2:0]  hburst;
	input [31:0] hdata0;
	input [31:0] hdata1;
	input [31:0] hdata2;
	input [31:0] hdata3;
	begin
		while(QUE_full() == 1'b1) @(posedge HCLK);
		HADDR_Q[QUE_WINDEX] = haddr;
		HWRITE_Q[QUE_WINDEX] = hwrite;
		HSIZE_Q[QUE_WINDEX] = hsize;
		HBURST_Q[QUE_WINDEX] = hburst;
		BURSTLEN_Q[QUE_WINDEX] = 4'd3;
		QUE_WINDEX = QUE_WINDEX + 1'b1;
		
		HDATA_Q[DATAQUE_WINDEX] = hdata0;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
		HDATA_Q[DATAQUE_WINDEX] = hdata1;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
		HDATA_Q[DATAQUE_WINDEX] = hdata2;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
		HDATA_Q[DATAQUE_WINDEX] = hdata3;
		DATAQUE_WINDEX = DATAQUE_WINDEX + 1'b1;
	end
endtask

// Real Test bench
initial
begin
	DATAQUE_WINDEX = 0;
	QUE_WINDEX = 0;
	@(posedge HCLK);
	while(HRESETn != 1'b1) @(posedge HCLK);

	AHBTrans4(32'h00000000, 1, `HSIZE_WORD, `HBURST_INCR4, 0<<2, 1<<2, 2<<2, 3<<2);
	AHBTrans4(32'h00000010, 1, `HSIZE_WORD, `HBURST_INCR4, 4<<2, 5<<2, 6<<2, 7<<2);
	AHBTrans4(32'h00000000, 0, `HSIZE_WORD, `HBURST_INCR4, 0<<2, 1<<2, 2<<2, 3<<2);
	AHBTrans4(32'h00000010, 0, `HSIZE_WORD, `HBURST_INCR4, 4<<2, 5<<2, 6<<2, 7<<2);
	AHBTrans4(32'h0000001c, 0, `HSIZE_WORD, `HBURST_WRAP4, 7<<2, 4<<2, 5<<2, 6<<2);
	AHBTrans4(32'h00000008, 0, `HSIZE_WORD, `HBURST_INCR, 2<<2, 3<<2, 4<<2, 5<<2);
	AHBTrans4(32'h00000000, 1, `HSIZE_BYTE, `HBURST_INCR4, 0, 1<<8, 2<<16, 3<<24);
	AHBTrans4(32'h00000000, 0, `HSIZE_WORD, `HBURST_INCR4, 32'h03020100, 1<<2, 2<<2, 3<<2);
	AHBTrans4(32'h00000000, 1, `HSIZE_HWORD, `HBURST_INCR4, 0, 1<<16, 2, 3<<16);
	AHBTrans4(32'h00000000, 0, `HSIZE_WORD, `HBURST_INCR4, 32'h00010000, 32'h00030002, 2<<2, 3<<2);

	initial_data_write;
	repeat(100000) random_read_write;

	while(QUE_RINDEX != QUE_WINDEX || HTRANS != `HTRANS_IDLE)
		@(posedge HCLK);

	$display("Simulation ended without error");
	$finish;
end

parameter ADDR_WIDTH = 10;
parameter MAX_ADDR = 1 << ADDR_WIDTH;
task initial_data_write;
integer i;
integer j;
begin
	for(i = 0; i <= MAX_ADDR; i = i + 4)
		AHBTrans4(i<<2, 1, `HSIZE_WORD, `HBURST_INCR4, i<<2, (i+1)<<2, (i+2)<<2, (i+3)<<2);
end
endtask

task random_read_write;
reg [ADDR_WIDTH-1:0] haddr;
reg  hwrite;
reg  incr4;
begin
	haddr = $random;
	hwrite = $random;
	incr4 = $random/16;
	haddr[1:0] = 0;

	if(incr4)
		AHBTrans4(haddr, hwrite, `HSIZE_WORD, `HBURST_INCR4, haddr, haddr+4, haddr+8, haddr+12);
	else
		AHBTrans4(haddr, hwrite, `HSIZE_WORD, `HBURST_INCR, haddr, haddr+4, haddr+8, haddr+12);
end
endtask

endmodule
