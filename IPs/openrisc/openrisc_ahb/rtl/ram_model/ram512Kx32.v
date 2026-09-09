`timescale 1ns/1ps

module ram512Kx32(
        clk, rstb, csb, wrb, oeb, addr, din, dout
);

parameter ADDR_WIDTH = 19;
parameter Load = 0;

//
// Generic synchronous single-port RAM interface
//
input                   clk;    // Clock
input                   rstb;    // Reset
input                   csb;     // Chip enable input
input   [3:0]           wrb;     // Write enable input
input                   oeb;     // Output enable input
input   [ADDR_WIDTH-1:0]          addr;   // address bus inputs
input   [31:0]          din;     // input data bus
output  [31:0]          dout;     // output data bus

//
// Generic single-port synchronous RAM model
//

//
// Generic RAM's registers and wires
//
reg     [31:0]       mem [{ADDR_WIDTH{1'b1}}:0];  // RAM content
reg     [ADDR_WIDTH-1:0]       addr_reg;          // RAM address register

initial if(Load) $readmemh ("../rom/program.rom", mem);

//
// Data output drivers
//
assign dout = (!oeb) ? mem[addr_reg] : 32'h00000000;

//
// RAM address register
//
always @(posedge clk or negedge rstb)
        if (!rstb)
                addr_reg <= #1 0;
        else if (!csb)
                addr_reg <= #1 addr;
                                                                                                                                                                                                     
wire [31:0] mask;
assign mask = {{8{wrb[3]}}, {8{wrb[2]}}, {8{wrb[1]}}, {8{wrb[0]}}};

always @(posedge clk)
        if (!csb)
                mem[addr] <= #1 {mem[addr] & mask} | {din & ~mask};

endmodule
