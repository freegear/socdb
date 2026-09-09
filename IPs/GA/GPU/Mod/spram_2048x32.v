// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module spram_2048x32(
        // Generic synchronous single-port RAM interface
        clk, rst, ce, we, sel, oe, addr, di, doq
);

//
// Generic synchronous single-port RAM interface
//
input                   clk;    // Clock
input                   rst;    // Reset
input                   ce;     // Chip enable input
input                   we;     // Write enable input
input   [3:0]           sel;    // Write enable input
input                   oe;     // Output enable input
input   [10:0]          addr;   // address bus inputs
input   [31:0]          di;     // input data bus
output  [31:0]          doq;     // output data bus

//
// Generic single-port synchronous RAM model
//

//
// Generic RAM's registers and wires
//
reg     [31:0]       mem [2047:0];              // RAM content
reg     [10:0]       addr_reg;                    // RAM address register

initial $readmemh ("../rom/program.rom", mem);

//
// Data output drivers
//
assign doq = (oe) ? mem[addr_reg] : 32'h00000000;
//assign doq = (oe) ? mem[addr] : 32'h00000000;

//
// RAM address register
//
always @(posedge clk or posedge rst)
        if (rst)
                addr_reg <= #1 11'h000;
        else if (ce)
                addr_reg <= #1 addr;
                                                                                                                                                                                                     
wire [31:0] mask;
assign mask = {{8{sel[3]}}, {8{sel[2]}}, {8{sel[1]}}, {8{sel[0]}}};

always @(posedge clk)
        if (ce && we)
                mem[addr] <= #1 {mem[addr] & ~mask} | {di & mask};

endmodule
