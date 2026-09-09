
// set FIFO_RW_CHECK to prevent writing to a FullFlag and reading from an EmptyFlag FIFO
//`define FIFO_RW_CHECK

// Long Pseudo Random Generators can generate (N^2 -1) combinations. This means
// 1 FIFO entry is unavailable. This might be a problem, especially for small
// FIFOs. Setting FIFO_ALL_ENTRIES creates additional logic that ensures that
// all FIFO entries are used at the expense of some additional logic.
`define FIFO_ALL_ENTRIES

module SDRGFF (
	Clk,
	nRst,
	rst,
	WriteEn,
	ReadEn,
	WrData,
	RdData,
	EmptyFlag,
	FullFlag,
	aEmptyFlag,
	aFullFlag
	);

	//
	// parameters
	//
	parameter aw =  3;                         // no.of entries (in bits; 2^7=128 entries)
	parameter dw =  8;                         // datawidth (in bits)

	//
	// inputs & outputs
	//
	input           Clk;                       // master clock
	input 			nRst;                      // asynchronous active low reset
	input 			rst;                       // synchronous active high reset

	input           WriteEn;                   // write request
	input           ReadEn;                    // read request
	input  [dw:1]   WrData;                    // data-input
	output [dw:1]   RdData;                    // data-output

	output            EmptyFlag;                   // fifo EmptyFlag
	output            FullFlag;                    // fifo FullFlag

	output            aEmptyFlag;                  // fifo asynchronous/almost EmptyFlag (1 entry left)
	output            aFullFlag;                   // fifo asynchronous/almost FullFlag (1 entry left)

	reg EmptyFlag, FullFlag;

	//
	// Module body
	//
	reg  [aw:1] RdCnt, WrCnt;
	wire [dw:1] ramq;
	wire fWriteEn, fReadEn;

`ifdef FIFO_ALL_ENTRIES
	function lsb;
	   input [aw:1] RdData;
	   case (aw)
	       2: lsb = ~RdData[2];
	       3: lsb = &RdData[aw-1:1] ^ ~(RdData[3] ^ RdData[2]);
	       4: lsb = &RdData[aw-1:1] ^ ~(RdData[4] ^ RdData[3]);
	       5: lsb = &RdData[aw-1:1] ^ ~(RdData[5] ^ RdData[3]);
	       6: lsb = &RdData[aw-1:1] ^ ~(RdData[6] ^ RdData[5]);
	       7: lsb = &RdData[aw-1:1] ^ ~(RdData[7] ^ RdData[6]);
	       8: lsb = &RdData[aw-1:1] ^ ~(RdData[8] ^ RdData[6] ^ RdData[5] ^ RdData[4]);
	       9: lsb = &RdData[aw-1:1] ^ ~(RdData[9] ^ RdData[5]);
	      10: lsb = &RdData[aw-1:1] ^ ~(RdData[10] ^ RdData[7]);
	      11: lsb = &RdData[aw-1:1] ^ ~(RdData[11] ^ RdData[9]);
	      12: lsb = &RdData[aw-1:1] ^ ~(RdData[12] ^ RdData[6] ^ RdData[4] ^ RdData[1]);
	      13: lsb = &RdData[aw-1:1] ^ ~(RdData[13] ^ RdData[4] ^ RdData[3] ^ RdData[1]);
	      14: lsb = &RdData[aw-1:1] ^ ~(RdData[14] ^ RdData[5] ^ RdData[3] ^ RdData[1]);
	      15: lsb = &RdData[aw-1:1] ^ ~(RdData[15] ^ RdData[14]);
	      16: lsb = &RdData[aw-1:1] ^ ~(RdData[16] ^ RdData[15] ^ RdData[13] ^ RdData[4]);
	   endcase
	endfunction
`else
	function lsb;
	   input [aw:1] RdData;
	   case (aw)
	       2: lsb = ~RdData[2];
	       3: lsb = ~(RdData[3] ^ RdData[2]);
	       4: lsb = ~(RdData[4] ^ RdData[3]);
	       5: lsb = ~(RdData[5] ^ RdData[3]);
	       6: lsb = ~(RdData[6] ^ RdData[5]);
	       7: lsb = ~(RdData[7] ^ RdData[6]);
	       8: lsb = ~(RdData[8] ^ RdData[6] ^ RdData[5] ^ RdData[4]);
	       9: lsb = ~(RdData[9] ^ RdData[5]);
	      10: lsb = ~(RdData[10] ^ RdData[7]);
	      11: lsb = ~(RdData[11] ^ RdData[9]);
	      12: lsb = ~(RdData[12] ^ RdData[6] ^ RdData[4] ^ RdData[1]);
	      13: lsb = ~(RdData[13] ^ RdData[4] ^ RdData[3] ^ RdData[1]);
	      14: lsb = ~(RdData[14] ^ RdData[5] ^ RdData[3] ^ RdData[1]);
	      15: lsb = ~(RdData[15] ^ RdData[14]);
	      16: lsb = ~(RdData[16] ^ RdData[15] ^ RdData[13] ^ RdData[4]);
	   endcase
	endfunction
`endif

`ifdef RW_CHECK
  assign fWriteEn = WriteEn & ~FullFlag;
  assign fReadEn = ReadEn & ~EmptyFlag;
`else
  assign fWriteEn = WriteEn;
  assign fReadEn = ReadEn;
`endif

	// hookup read-pointer
	always @(posedge Clk or negedge nRst)
	  if (~nRst)      RdCnt <= #1 0;
	  else if (rst)   RdCnt <= #1 0;
	  else if (fReadEn) RdCnt <= #1 {RdCnt[aw-1:1], lsb(RdCnt)};

	// hookup write-pointer
	always @(posedge Clk or negedge nRst)
	  if (~nRst)      WrCnt <= #1 0;
	  else if (rst)   WrCnt <= #1 0;
	  else if (fWriteEn) WrCnt <= #1 {WrCnt[aw-1:1], lsb(WrCnt)};


reg [dw:0] FIFO[0:BLQD];
integer i;

always @(negedge nRST or posedge Clk)
  if (!nRST) begin
    for (i=0; i<=BLQD; i=i+1) FIFO[i] <= 0;
  end
  else begin
    if (WriteEn) FIFO[WrCnt] <= WrData;
    else         FIFO[WrCnt] <= FIFO[WrCnt];
  end

assign RdData = FIFO[RdCnt];

/*
	// hookup RAM-block
	generic_dpram #(aw, dw)
	fiforam (
		// write section
		.wclk(Clk),
		.wrst(1'b0),
		.wce(1'b1),
		.we(fWriteEn),
		.waddr(WrCnt),
		.di(WrData),

		// read section
		.rclk(Clk),
		.rrst(1'b0),
		.rce(1'b1),
		.oe(1'b1),
		.raddr(RdCnt),
		.do(RdData)
	);
*/

	// generate FullFlag/EmptyFlag signals
	assign aEmptyFlag = (RdCnt[aw-1:1] == WrCnt[aw:2]) & (lsb(RdCnt) == WrCnt[1]) & fReadEn & ~fWriteEn;
	always @(posedge Clk or negedge nRst)
	  if (~nRst)
	    EmptyFlag <= #1 1'b1;
	  else if (rst)
	    EmptyFlag <= #1 1'b1;
	  else
	    EmptyFlag <= #1 aEmptyFlag | (EmptyFlag & (~fWriteEn + fReadEn));

	assign aFullFlag = (WrCnt[aw-1:1] == RdCnt[aw:2]) & (lsb(WrCnt) == RdCnt[1]) & fWriteEn & ~fReadEn;
	always @(posedge Clk or negedge nRst)
	  if (~nRst)
	    FullFlag <= #1 1'b0;
	  else if (rst)
	    FullFlag <= #1 1'b0;
	  else
	    FullFlag <= #1 aFullFlag | ( FullFlag & (~fReadEn + fWriteEn) );

	//
	// Simulation checks
	//
	// synopsys translate_off
	always @(posedge Clk)
	  if (FullFlag & fWriteEn)
	    $display("Writing while FIFO FullFlag\n");

	always @(posedge Clk)
	  if (EmptyFlag & fReadEn)
	    $display("Reading while FIFO EmptyFlag\n");
	// synopsys translate_on
endmodule

