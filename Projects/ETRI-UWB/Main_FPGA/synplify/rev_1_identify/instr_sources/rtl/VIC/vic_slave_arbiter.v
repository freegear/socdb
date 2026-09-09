//
// vic_slave_arbiter
//   : This module is a part of APB_vic(Vectored Interrupt Controller)
//
// This module consists of fully combinational logic
//

`timescale 1ns/1ps
module vic_slave_arbiter (
	FIXED_MODE,		// fixed mode(when 1'b1) or round robin mode(update CSLV, when 1'b0)
	INTPEND,		// Pended interrupt input(8bits)
	ISPR_OUT,		// Arbitration results(8bits, only 1 bit can be high)
	INTERRUPT_OUT,	// Interrupt Out(1'b1 when there are interrupts in INTPEND)
	PSLV,			// Priorities used when fixed mode.
	CSLV,			// Current priorities used when round robin mode
	NEXTCSLV		//  Next current priorities
);

input         FIXED_MODE;
input  [7:0]  INTPEND;
output [7:0]  ISPR_OUT;
output        INTERRUPT_OUT;
input  [23:0] PSLV;
input  [23:0] CSLV;
output [23:0] NEXTCSLV;

wire        FIXED_MODE;
wire [7:0]  INTPEND;
wire [7:0]  ISPR_OUT;
reg         INTERRUPT_OUT;
wire [23:0] PSLV;
wire [23:0] CSLV;
wire [23:0] NEXTCSLV;

// assign priority
wire [2:0] priority0;
wire [2:0] priority1;
wire [2:0] priority2;
wire [2:0] priority3;
wire [2:0] priority4;
wire [2:0] priority5;
wire [2:0] priority6;
wire [2:0] priority7;

assign priority0 = (FIXED_MODE) ? PSLV[ 2: 0] : CSLV[ 2: 0];
assign priority1 = (FIXED_MODE) ? PSLV[ 5: 3] : CSLV[ 5: 3];
assign priority2 = (FIXED_MODE) ? PSLV[ 8: 6] : CSLV[ 8: 6];
assign priority3 = (FIXED_MODE) ? PSLV[11: 9] : CSLV[11: 9];
assign priority4 = (FIXED_MODE) ? PSLV[14:12] : CSLV[14:12];
assign priority5 = (FIXED_MODE) ? PSLV[17:15] : CSLV[17:15];
assign priority6 = (FIXED_MODE) ? PSLV[20:18] : CSLV[20:18];
assign priority7 = (FIXED_MODE) ? PSLV[23:21] : CSLV[23:21];

// reordering bit with priority.
wire [7:0] int0;
wire [7:0] int1;
wire [7:0] int2;
wire [7:0] int3;
wire [7:0] int4;
wire [7:0] int5;
wire [7:0] int6;
wire [7:0] int7;
vic_slave_arbiter_priority_decode
	int0_decode(.PRI(priority0), .INT(INTPEND[0]), .INT_OUT(int0));
vic_slave_arbiter_priority_decode
	int1_decode(.PRI(priority1), .INT(INTPEND[1]), .INT_OUT(int1));
vic_slave_arbiter_priority_decode
	int2_decode(.PRI(priority2), .INT(INTPEND[2]), .INT_OUT(int2));
vic_slave_arbiter_priority_decode
	int3_decode(.PRI(priority3), .INT(INTPEND[3]), .INT_OUT(int3));
vic_slave_arbiter_priority_decode
	int4_decode(.PRI(priority4), .INT(INTPEND[4]), .INT_OUT(int4));
vic_slave_arbiter_priority_decode
	int5_decode(.PRI(priority5), .INT(INTPEND[5]), .INT_OUT(int5));
vic_slave_arbiter_priority_decode
	int6_decode(.PRI(priority6), .INT(INTPEND[6]), .INT_OUT(int6));
vic_slave_arbiter_priority_decode
	int7_decode(.PRI(priority7), .INT(INTPEND[7]), .INT_OUT(int7));

wire [7:0] reordered_int;
assign reordered_int = int0 | int1 | int2 | int3 | int4 | int5 | int6 | int7;

// Search interrupt with highest interrupt
reg  [2:0] highest_priority;
reg  [7:0] highest_priority_int;

always @(reordered_int)
begin
	if(reordered_int[0])
	begin
		highest_priority <= 3'b000;
		highest_priority_int <= 8'b00000001;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[1])
	begin
		highest_priority <= 3'b001;
		highest_priority_int <= 8'b00000010;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[2])
	begin
		highest_priority <= 3'b010;
		highest_priority_int <= 8'b00000100;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[3])
	begin
		highest_priority <= 3'b011;
		highest_priority_int <= 8'b00001000;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[4])
	begin
		highest_priority <= 3'b100;
		highest_priority_int <= 8'b00010000;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[5])
	begin
		highest_priority <= 3'b101;
		highest_priority_int <= 8'b00100000;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[6])
	begin
		highest_priority <= 3'b110;
		highest_priority_int <= 8'b01000000;
		INTERRUPT_OUT <= 1'b1;
	end
	else if(reordered_int[7])
	begin
		highest_priority <= 3'b111;
		highest_priority_int <= 8'b10000000;
		INTERRUPT_OUT <= 1'b1;
	end
	else
	begin
		highest_priority <= 3'b000;
		highest_priority_int <= 8'b00000000;
		INTERRUPT_OUT <= 1'b0;
	end
end

// Reorder highest_prioiry_int to original bit order
vic_slave_arbiter_8to1_mux
	reorder_bit0(.SEL(priority0), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[0]));
vic_slave_arbiter_8to1_mux
	reorder_bit1(.SEL(priority1), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[1]));
vic_slave_arbiter_8to1_mux
	reorder_bit2(.SEL(priority2), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[2]));
vic_slave_arbiter_8to1_mux
	reorder_bit3(.SEL(priority3), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[3]));
vic_slave_arbiter_8to1_mux
	reorder_bit4(.SEL(priority4), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[4]));
vic_slave_arbiter_8to1_mux
	reorder_bit5(.SEL(priority5), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[5]));
vic_slave_arbiter_8to1_mux
	reorder_bit6(.SEL(priority6), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[6]));
vic_slave_arbiter_8to1_mux
	reorder_bit7(.SEL(priority7), .INPUT(highest_priority_int), .OUTPUT(ISPR_OUT[7]));

// calculate next CSLV
assign NEXTCSLV[ 2: 0] = (FIXED_MODE) ? PSLV[ 2: 0] : (CSLV[ 2: 0]-highest_priority);
assign NEXTCSLV[ 5: 3] = (FIXED_MODE) ? PSLV[ 5: 3] : (CSLV[ 5: 3]-highest_priority);
assign NEXTCSLV[ 8: 6] = (FIXED_MODE) ? PSLV[ 8: 6] : (CSLV[ 8: 6]-highest_priority);
assign NEXTCSLV[11: 9] = (FIXED_MODE) ? PSLV[11: 9] : (CSLV[11: 9]-highest_priority);
assign NEXTCSLV[14:12] = (FIXED_MODE) ? PSLV[14:12] : (CSLV[14:12]-highest_priority);
assign NEXTCSLV[17:15] = (FIXED_MODE) ? PSLV[17:15] : (CSLV[17:15]-highest_priority);
assign NEXTCSLV[20:18] = (FIXED_MODE) ? PSLV[20:18] : (CSLV[20:18]-highest_priority);
assign NEXTCSLV[23:21] = (FIXED_MODE) ? PSLV[23:21] : (CSLV[23:21]-highest_priority);

endmodule

module vic_slave_arbiter_priority_decode
(
	PRI,		// priority
	INT,		// interrupt input
	INT_OUT		// decoded interrupt_out
);
input  [2:0] PRI;
input        INT;
output [7:0] INT_OUT;

wire [2:0] PRI;
wire       INT;
reg  [7:0] INT_OUT;

always @(PRI or INT)
begin
	case(PRI)
	3'd0: INT_OUT = {7'b0000000, INT};
	3'd1: INT_OUT = {6'b000000,  INT,1'b0};
	3'd2: INT_OUT = {5'b00000,   INT,2'b00};
	3'd3: INT_OUT = {4'b0000,    INT,3'b000};
	3'd4: INT_OUT = {3'b000,     INT,4'b0000};
	3'd5: INT_OUT = {2'b00,      INT,5'b00000};
	3'd6: INT_OUT = {1'b0,       INT,6'b000000};
	3'd7: INT_OUT = {            INT,7'b0000000};
	default : INT_OUT = 8'h00;
	endcase
end
endmodule

module vic_slave_arbiter_8to1_mux
(
	SEL,		// Mux selection
	INPUT,		// 8 bit input
	OUTPUT		// output
);
input  [2:0] SEL;
input  [7:0] INPUT;
output       OUTPUT;

wire [2:0] SEL;
wire [7:0] INPUT;
reg        OUTPUT;
always @(SEL or INPUT)
begin
	case(SEL)
	3'd0: OUTPUT = INPUT[0];
	3'd1: OUTPUT = INPUT[1];
	3'd2: OUTPUT = INPUT[2];
	3'd3: OUTPUT = INPUT[3];
	3'd4: OUTPUT = INPUT[4];
	3'd5: OUTPUT = INPUT[5];
	3'd6: OUTPUT = INPUT[6];
	3'd7: OUTPUT = INPUT[7];
	default : OUTPUT = 1'b0;
	endcase
end
endmodule

