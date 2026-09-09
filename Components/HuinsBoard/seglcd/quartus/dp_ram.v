`define RAM_WIDTH 8
`define RAM_DEPTH 40
`define ADDR_SIZE 6

module dp_ram( clk, write, wr_address, wr_data, read, rd_address, rd_data);

//INPUTS
input                    clk;
input                    write;
input  [`ADDR_SIZE-1:0]  wr_address;
input  [`RAM_WIDTH-1:0]  wr_data;
input                    read;
input  [`ADDR_SIZE-1:0]  rd_address;

//OUTPUTS
output [`RAM_WIDTH-1:0]  rd_data;

//REGISTERS
reg    [`RAM_WIDTH-1:0]  mem[`RAM_DEPTH-1:0];
reg    [`RAM_WIDTH-1:0]  rd_data;

always @(posedge clk)    
begin
   if (write)
       mem[wr_address] <= wr_data;

end

always @(negedge clk)    
begin
   if (read)
       rd_data <= mem[rd_address];
end

endmodule
    
