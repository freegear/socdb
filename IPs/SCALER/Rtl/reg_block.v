//*****************************************
// module name : reg_block.v
// by  : Brother
// date: 2006-7-6
//*****************************************
`timescale 1ns/10ps

module reg_block(
	pclk,
	presetn,
	paddr,
	psel,
	penable,
	pwrite,
	pwdata,
	prdata,
    
    finish_write,
    start,
    bpp,
    width,
    height,
    src_width,
    src_height,
    new_width,
    new_height,
    src_img_addr,
    new_img_addr
);

input pclk;
input presetn;
input [3:2] paddr;
input psel;
input penable;
input pwrite;
input [31:0] pwdata;
output[31:0] prdata;

input finish_write;

output start;
output[ 2:0] bpp;
output[11:0] width;
output[11:0] height;
output[11:0] src_width;
output[11:0] src_height;
output[11:0] new_width;
output[11:0] new_height;
output[31:0] src_img_addr;
output[31:0] new_img_addr;

reg[31:0] rdata;

reg[31:0] src_size_reg;
reg[31:0] new_size_reg;
reg[31:0] src_addr_reg;
reg[31:0] new_addr_reg;

wire[11:0] height;
wire[11:0] width;


wire		reg_wr;
wire		reg_rd;


assign	reg_wr = psel & penable & pwrite;
assign  reg_rd = psel & ~pwrite;
// synopsys translate_off
assign ready = src_size_reg[31];
// synopsys translate_on
// src size reg[31:0] : ready[31],start[30],src_width[27:16],src_height[11:0]
// new size reg[31:0] : bpp[31:29],new_width[27:16],new_height[11:0]
// src addr reg[31:0] : source image address
// dst addr reg[31:0] : new image address

assign width  = src_width-new_width;
assign height = src_height-new_height;

always @(posedge pclk or negedge presetn)
begin
    if(!presetn) begin
        src_size_reg[31]<=1'b1;
        src_size_reg[30:0]<=1'b0;
        new_size_reg<=0;
        src_addr_reg<=0;
        new_addr_reg<=0;
    end
    else begin
        if(reg_wr) begin
            case(paddr[3:2]) // synopsys parallel_case
            0: src_size_reg[30:0] <= pwdata[30:0];
            1: new_size_reg <= pwdata[31:0];
            2: src_addr_reg <= pwdata[31:0];
            default: new_addr_reg <= pwdata[31:0];
            endcase
        end
        if(src_size_reg[30]) begin
            src_size_reg[30]<=0;
            src_size_reg[31]<=1'b0;//ready <= 0;
        end
        else if(finish_write) src_size_reg[31]<=1'b1; //ready<=1'b1;
    
    end
end

always @(posedge pclk or negedge presetn)
begin
    if(!presetn) begin
        rdata<=0;
    end
    else begin
        if(reg_rd) begin
            case(paddr[3:2]) // synopsys parallel_case
                0: rdata <= src_size_reg;
                1: rdata <= new_size_reg;
                2: rdata <= src_addr_reg;
                default: rdata <= new_addr_reg;
            endcase
        end
        else
            rdata<=0;
    end
end

assign prdata = rdata;
assign start = src_size_reg[30];
assign bpp = new_size_reg[31:29];
assign src_width  = src_size_reg[27:16];
assign src_height = src_size_reg[11:0 ];
assign new_width  = new_size_reg[27:16];
assign new_height = new_size_reg[11:0 ];

assign src_img_addr = src_addr_reg; 
assign new_img_addr = new_addr_reg;

endmodule

