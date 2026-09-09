`timescale 1ns/10ps

module pc8051_top (
// Input port define
clk           ,
rst           ,
int0_i        ,
int1_i        ,
all_t0_i      ,
all_t1_i      ,
all_rxd_i     ,

// Output port define
all_txd_o     ,

// InOut port define
p0_io         ,
p1_io         ,
p2_io         ,
p3_io         ,


///Test Pin//////////////
rom_adr_o     ,
rom_data_i    );

// Input signal define
input            clk, rst;
input            int0_i, int1_i;
input            all_t0_i, all_t1_i;
input            all_rxd_i;

// Output signal define
output           all_txd_o;


// InOut signal define
inout   [7:0]   p0_io, p1_io, p2_io, p3_io;

// Test Pin///////////////////////
output   [15:0]  rom_adr_o;
output   [7:0]   rom_data_i;

// Register define
reg      [15:0]  addr_xdat;

// Wire & assignment define
wire     [15:0]  rom_adr_o;
wire     [7:0]   rom_data_i;
wire     [7:0]   addr_a, out_idat, in_idat_a;
wire     [7:0]   xaddr_high, out_xdat, in_xdat_a; 
wire     [7:0]   p0_i, p1_i, p2_i, p3_i;
wire     [7:0]   p0_en, p1_en, p2_en, p3_en;
wire     [7:0]   p0_o, p1_o, p2_o, p3_o;
wire             rd_idat, wr_idat;
wire             rd_xdat, wr_xdat;
wire             ale, ale_n;
wire             en_xdat;
assign ale_n   = ~ale;
assign en_xdat = wr_xdat & rd_xdat;

// External sram address
always @(posedge ale_n or negedge rst) begin
   if(rst == 1'b0) begin
      addr_xdat <= 16'd0;
   end
   else begin
      addr_xdat <= {xaddr_high, out_xdat};
   end
end

// P0  bi-direction
assign  p0_i = p0_io;
assign  p0_io[0] = (p0_en[0] == 1'b0) ? p0_o[0] : 1'hz;
assign  p0_io[1] = (p0_en[1] == 1'b0) ? p0_o[1] : 1'hz;
assign  p0_io[2] = (p0_en[2] == 1'b0) ? p0_o[2] : 1'hz;
assign  p0_io[3] = (p0_en[3] == 1'b0) ? p0_o[3] : 1'hz;
assign  p0_io[4] = (p0_en[4] == 1'b0) ? p0_o[4] : 1'hz;
assign  p0_io[5] = (p0_en[5] == 1'b0) ? p0_o[5] : 1'hz;
assign  p0_io[6] = (p0_en[6] == 1'b0) ? p0_o[6] : 1'hz;
assign  p0_io[7] = (p0_en[7] == 1'b0) ? p0_o[7] : 1'hz;

// P1  bi-direction
assign  p1_i = p1_io;
assign  p1_io[0] = (p1_en[0] == 1'b0) ? p1_o[0] : 1'hz;
assign  p1_io[1] = (p1_en[1] == 1'b0) ? p1_o[1] : 1'hz;
assign  p1_io[2] = (p1_en[2] == 1'b0) ? p1_o[2] : 1'hz;
assign  p1_io[3] = (p1_en[3] == 1'b0) ? p1_o[3] : 1'hz;
assign  p1_io[4] = (p1_en[4] == 1'b0) ? p1_o[4] : 1'hz;
assign  p1_io[5] = (p1_en[5] == 1'b0) ? p1_o[5] : 1'hz;
assign  p1_io[6] = (p1_en[6] == 1'b0) ? p1_o[6] : 1'hz;
assign  p1_io[7] = (p1_en[7] == 1'b0) ? p1_o[7] : 1'hz;

// P2  bi-direction
assign  p2_i = p2_io;
assign  p2_io[0] = (p2_en[0] == 1'b0) ? p2_o[0] : 1'hz;
assign  p2_io[1] = (p2_en[1] == 1'b0) ? p2_o[1] : 1'hz;
assign  p2_io[2] = (p2_en[2] == 1'b0) ? p2_o[2] : 1'hz;
assign  p2_io[3] = (p2_en[3] == 1'b0) ? p2_o[3] : 1'hz;
assign  p2_io[4] = (p2_en[4] == 1'b0) ? p2_o[4] : 1'hz;
assign  p2_io[5] = (p2_en[5] == 1'b0) ? p2_o[5] : 1'hz;
assign  p2_io[6] = (p2_en[6] == 1'b0) ? p2_o[6] : 1'hz;
assign  p2_io[7] = (p2_en[7] == 1'b0) ? p2_o[7] : 1'hz;

// P3  bi-direction
assign  p3_i = p3_io;
assign  p3_io[0] = (p3_en[0] == 1'b0) ? p3_o[0] : 1'hz;
assign  p3_io[1] = (p3_en[1] == 1'b0) ? p3_o[1] : 1'hz;
assign  p3_io[2] = (p3_en[2] == 1'b0) ? p3_o[2] : 1'hz;
assign  p3_io[3] = (p3_en[3] == 1'b0) ? p3_o[3] : 1'hz;
assign  p3_io[4] = (p3_en[4] == 1'b0) ? p3_o[4] : 1'hz;
assign  p3_io[5] = (p3_en[5] == 1'b0) ? p3_o[5] : 1'hz;
assign  p3_io[6] = (p3_en[6] == 1'b0) ? p3_o[6] : 1'hz;
assign  p3_io[7] = (p3_en[7] == 1'b0) ? p3_o[7] : 1'hz;

//PC8051  CORE
u_cpu U3_cpu(
.clk                ( clk                      ),
.rst_p              ( !rst                     ),
.in_xrom_a          ( rom_data_i               ),
.in_idat_a          ( in_idat_a                ),
.in_xdat_a          ( in_xdat_a                ),
.p0_in              ( p0_i                     ),
.p1_in              ( p1_i                     ),
.p2_in              ( p2_i                     ),
.p3_in              ( p3_i                     ),
.rxdi               ( all_rxd_i                ),
.t0_pin             ( all_t0_i                 ),
.t1_pin             ( all_t1_i                 ),
.int0_pin           ( int0_i                   ),
.int1_pin           ( int1_i                   ),
.addr_xrom_a        ( rom_adr_o                ),
.addr_a             ( addr_a                   ),
.out_idat           ( out_idat                 ),
.wr_idat            ( wr_idat                  ),
.rd_idat            ( rd_idat                  ),
.xaddr_high         ( xaddr_high               ),
.out_xdat           ( out_xdat                 ),
.ale                ( ale                      ),
.p0_out             ( p0_o                     ),
.p1_out             ( p1_o                     ),
.p2_out             ( p2_o                     ),
.p3_out             ( p3_o                     ),
.p0_en              ( p0_en                    ),
.p1_en              ( p1_en                    ),
.p2_en              ( p2_en                    ),
.p3_en              ( p3_en                    ),
.psen               ( psen                     ),
.xdat_en            (                          ),
.wr_xdat            ( wr_xdat                  ), 
.rd_xdat            ( rd_xdat                  ),
.rxdo               ( all_rxd_o                ),
.txdo               ( all_txd_o                ),
.sel_code_xdat      (                          ));

//sync rom
rom_16kx8  rom_16kx8 (
.addr               ( rom_adr_o[13:0]          ),
.clk                ( !clk                     ),
.dout               ( rom_data_i               ));

//spsram_256x8,  internal memory
spsram_256x8 spsram_256x8 (
 .addr              ( addr_a                   ),
 .clk               ( !clk                     ),      //rising active
 .din               ( out_idat                 ),     
 .dout              ( in_idat_a                ),
 .en                ( 1'b0                     ),      //low active
 .we                ( wr_idat                  ));     //low active 

//spsram_1.5kx8, external data memory
spsram_1_5kx8 spsram_1_5kx8 (
 .addr              ( addr_xdat[10:0]          ),
 .clk               ( !clk                     ),
 .din               ( out_xdat                 ),
 .dout              ( in_xdat_a                ),
 .en                ( en_xdat                  ),
 .we                ( wr_xdat                  ));

endmodule



