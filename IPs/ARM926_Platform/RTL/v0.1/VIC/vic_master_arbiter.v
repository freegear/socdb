//
// vic_master_arbiter
//   : This module is a part of APB_vic(Vectored Interrupt Controller)
//
// This module consists of fully combinational logic
//

`timescale 1ns/1ps
module vic_master_arbiter (
	FIXED_MODE,		// fixed mode(when 1'b1) or round robin mode(update CMST, when 1'b0)
	INTPEND,		// Pended interrupt input(4bits)
	ISPR_OUT,		// Arbitration results(4bits, only 1 bit can be high)
	INTERRUPT_OUT,	// Interrupt Out(1'b1 when there are interrupts in INTPEND)
	PMST,			// Priorities used when fixed mode.
	CMST,			// Current priorities used when round robin mode
	NEXTCMST		// Next current priorities
);

input        FIXED_MODE;
input  [3:0] INTPEND;
output [3:0] ISPR_OUT;
output       INTERRUPT_OUT;
input  [7:0] PMST;
input  [7:0] CMST;
output [7:0] NEXTCMST;

wire       FIXED_MODE;
wire [3:0] INTPEND;
wire [3:0] ISPR_OUT;
reg        INTERRUPT_OUT;
wire [7:0] PMST;
wire [7:0] CMST;
wire [7:0] NEXTCMST;

// assign priority
wire [1:0] priority0;
wire [1:0] priority1;
wire [1:0] priority2;
wire [1:0] priority3;

assign priority0 = (FIXED_MODE) ? PMST[ 1: 0] : CMST[ 1: 0];
assign priority1 = (FIXED_MODE) ? PMST[ 3: 2] : CMST[ 3: 2];
assign priority2 = (FIXED_MODE) ? PMST[ 5: 4] : CMST[ 5: 4];
assign priority3 = (FIXED_MODE) ? PMST[ 7: 6] : CMST[ 7: 6];

// reordering bit with priority.
wire [3:0] int0;
wire [3:0] int1;
wire [3:0] int2;
wire [3:0] int3;
vic_master_arbiter_priority_decode
	int0_decode(.PRI(priority0), .INT(INTPEND[0]), .INT_OUT(int0));
vic_master_arbiter_priority_decode
	int1_decode(.PRI(priority1), .INT(INTPEND[1]), .INT_OUT(int1));
vic_master_arbiter_priority_decode
	int2_decode(.PRI(priority2), .INT(INTPEND[2]), .INT_OUT(int2));
vic_master_arbiter_priority_decode
	int3_decode(.PRI(priority3), .INT(INTPEND[3]), .INT_OUT(int3));

wire [3:0] reordered_int;
assign reordered_int = int0 | int1 | int2 | int3;

// Search interrupt with highest interrupt
reg  [1:0] highest_priority;
reg  [3:0] highest_priority_int;

always @(reordered_int)
begin
	if(reordered_int[0])
	begin
		highest_priority <= 2'b00;
		highest_priority_int <= 4'b0001;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[1])
	begin
		highest_priority <= 2'b01;
		highest_priority_int <= 4'b0010;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[2])
	begin
		highest_priority <= 2'b10;
		highest_priority_int <= 4'b0100;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[3])
	begin
		highest_priority <= 2'b11;
		highest_priority_int <= 4'b1000;
		INTERRUPT_OUT <= 1'b1;
	end
	else
	begin
		highest_priority <= 2'b00;
		highest_priority_int <= 4'b0000;
		INTERRUPT_OUT <= 1'b0;
	end
end

// Reorder highest_prioiry_int to original bit order
vic_master_arbiter_4to1_mux
	reorder_bit0(.SEL(priority0), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[0]));
vic_master_arbiter_4to1_mux
	reorder_bit1(.SEL(priority1), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[1]));
vic_master_arbiter_4to1_mux
	reorder_bit2(.SEL(priority2), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[2]));
vic_master_arbiter_4to1_mux
	reorder_bit3(.SEL(priority3), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[3]));

// calculate next CMST
assign NEXTCMST[ 1: 0] = (FIXED_MODE) ? PMST[ 1: 0] : (CMST[ 1: 0]-highest_priority);
assign NEXTCMST[ 3: 2] = (FIXED_MODE) ? PMST[ 3: 2] : (CMST[ 3: 2]-highest_priority);
assign NEXTCMST[ 5: 4] = (FIXED_MODE) ? PMST[ 5: 4] : (CMST[ 5: 4]-highest_priority);
assign NEXTCMST[ 7: 6] = (FIXED_MODE) ? PMST[ 7: 6] : (CMST[ 7: 6]-highest_priority);

endmodule

module vic_master_arbiter_priority_decode
(
	PRI,		// priority
	INT,		// interrupt input
	INT_OUT		// decoded interrupt_out
);
input  [1:0] PRI;
input        INT;
output [3:0] INT_OUT;

wire [1:0] PRI;
wire       INT;
reg  [3:0] INT_OUT;

always @(PRI or INT)
begin
	case(PRI)
	3'd0: INT_OUT = {3'b000, INT};
	3'd1: INT_OUT = {2'b00,  INT,1'b0};
	3'd2: INT_OUT = {1'b0,   INT,2'b00};
	3'd3: INT_OUT = {        INT,3'b000};
	default: INT_OUT = 4'h0;
	endcase
end
endmodule

module vic_master_arbiter_4to1_mux
(
	SEL,		// Mux selection
	INPUT,		// 4 bit input
	OUTPUT		// output
);
input  [1:0] SEL;
input  [3:0] INPUT;
output       OUTPUT;

wire [1:0] SEL;
wire [3:0] INPUT;
reg        OUTPUT;
always @(SEL or INPUT)
begin
	case(SEL)
	3'd0: OUTPUT = INPUT[0];
	3'd1: OUTPUT = INPUT[1];
	3'd2: OUTPUT = INPUT[2];
	3'd3: OUTPUT = INPUT[3];
	default : OUTPUT = 1'b0;
	endcase
end
endmodule

