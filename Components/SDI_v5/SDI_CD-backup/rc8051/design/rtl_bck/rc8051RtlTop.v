`timescale 1ns/10ps

module rc8051RtlTop (
// Input port define
clk           ,
rst_p           ,
int0_i        ,
int1_i        ,
all_t0_i      ,
all_t1_i      ,
all_rxd_i     ,
p1_i	      ,
p1_o          ,
p1_en         ,
// Output port define
all_txd_o     ,
// memory interface
clkb           ,
rom_adr_o      , 
rom_data_i     , 
  //external data memory
addr_xdat      ,
out_xdat       ,
in_xdat_a      ,
en_xdat        ,
wr_xdat_d1     ,  
rd_xdat         
);

// Input signal define
input            clk, rst_p;
input            int0_i, int1_i;
input            all_t0_i, all_t1_i;
input            all_rxd_i;
input [7:0]      p1_i;

// Output signal define
output [7:0]     p1_o;
output [7:0]     p1_en;
output           all_txd_o;

// memory interfac
   //sync rom
output 		 clkb;
output 	[15:0]	 rom_adr_o; 
input	[7:0]	 rom_data_i; 
  //external data 
output	[15:0]	 addr_xdat;
output	[7:0]	 out_xdat;
input	[7:0]	 in_xdat_a;
output		 en_xdat;
output		 wr_xdat_d1;       
output		 rd_xdat;       

// Register define
reg      [15:0]  addr_xdat;
reg      [7:0]   xaddr_low;
reg              ale_d1;
reg              en_xdat, wr_xdat_d1;

// Wire & assignment define
wire     [15:0]  rom_adr_o;
wire     [7:0]   rom_data_i;
wire     [7:0]   addr_a, out_idat, in_idat_a;
wire     [7:0]   xaddr_high, out_xdat, in_xdat_a; 
wire     [7:0]   p0_en, p1_en, p2_en, p3_en;
wire     [7:0]   p0_i, p1_i, p2_i, p3_i;
wire     [7:0]   p0_o, p1_o, p2_o, p3_o;
wire             rd_idat, wr_idat;
wire             rd_xdat, wr_xdat;
wire             ale;
wire		 clkb;

// clk bar
assign clkb = !clk;


// Ale delay
always @(posedge clk or posedge rst_p) begin
   if(rst_p == 1'b1) begin
      ale_d1 <= 1'b0;
   end
   else begin
      ale_d1 <= ale;
   end
end

// External sram low address
always @(posedge clk or posedge rst_p) begin
   if(rst_p == 1'b1) begin
      xaddr_low <= 8'd0;
   end
   else if(ale_d1 == 1'b1) begin
      xaddr_low <= out_xdat;
   end
   else begin
      xaddr_low <=  xaddr_low;
   end
end

// External sram address
always @(posedge clk or posedge rst_p) begin
   if(rst_p == 1'b1) begin
      addr_xdat <= 16'd0;
   end
   else begin
      addr_xdat <= {xaddr_high, xaddr_low};
   end
end

// External data , en signal
always @(posedge clk or posedge rst_p) begin
   if(rst_p == 1'b1) begin
      en_xdat <= 1'b1;
      wr_xdat_d1 <= 1'b1;
   end
   else begin
      en_xdat <= wr_xdat & rd_xdat;
      wr_xdat_d1 <= wr_xdat;
   end
end

//PC8051  CORE
u_cpu U3_cpu(
.clk                ( clk                      ),
.rst_p              ( rst_p                      ),
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


wire idat_en;

assign idat_en =   wr_idat & rd_idat         ; 
//spsram_256x8,  internal memory
spsram_256x8 spsram_256x8 (
 .addr              ( addr_a                   ),
 .clk               ( clkb                     ),      //rising active
 .din               ( out_idat                 ),     
 .dout              ( in_idat_a                ),
 .en                ( idat_en                  ),      //low active
 .we                ( wr_idat                  ));     //low active 

/*
spsram_256x8 spsram_256x8 (
 .A                 ( addr_a                   ),
 .CLK               ( clkb                     ),      //rising active
 .D                 ( out_idat                 ),     
 .Q                 ( in_idat_a                ),
 .CEN		    ( idat_en                  ),      //low active
 .WEN               ( wr_idat                  ));     //low active 

*/
endmodule
