`include "./inc_vcode.v"
`include "./BLKMEMSP_V5_0.v"
//`include "./C_DIST_MEM_V6_0.v"
//`include "./C_REG_FD_V6_0.v"
//`include "./../arom_4kx8.v"
//`include "./../test_mem.v"
`include "./rom_16kx8.v"
`include "./LIB/spsram_256x8.v"
//`include "./spsram_256x8.v"
`include "./spsram_1_5kx8.v"
//`include "./../spsram_65536x8.v"
`include "./asic_top_8051.v"
`include "./pc8051_top.v"

//`include "./imggen.v"

`define   CLK24  41.66
`define   CLK48  20.83 
`define   CLK54  18.52   

`timescale 100ps/ 10ps

module tb_asic;

parameter       FRE  = 100;
parameter FINISH = 5001;

reg         rst, clk; 
reg         int_source;

initial begin
   rst        <= 1'b0; 
   clk        <= 1'b0;
   # (FRE*5 + 0)  rst <= 1'b1; 
   # 945000;   
end
always #45.2   clk = ~clk;

initial begin

   # (FRE*10 + 5) rst = 0;
   # (FRE*30 + 5) rst = 1;
   # (FRE*30 + 5) rst = 0;
  # (FRE*30 + 5) rst = 1;
end

initial begin
   $shm_open("sim_asic_top_8051.shm" );
   $shm_probe("AC"); 
end

wire [9:0]  p_data, YorGout, CborBout, CrorRout;
wire [15:0] mdata;  
wire [25:0] TEST_OUT;
wire [7:0]  Ext_odata; 
wire [7:0]  ext_data;
wire        Vsync, Hsync;
wire        mcs, mrd, mwr, ale, sen_clk, data_clk;
wire        Null_rst, Null_pwdn, Null_clk;

wire        I2C_mst_scl, I2C_mst_sda;
wire        i2c_slave_scl, i2c_slave_sda;
wire        all_rxd, all_txd_o;

reg  [100:0] cnt;
reg         tmp_en_d1;


always @ (posedge clk or negedge rst) begin
   if(rst == 1'b0) begin
      int_source <= 1'b1;
   end
   else begin 
      int_source <= 1'b0;
   end
end


always @(posedge clk or negedge rst) begin
   if(rst == 1'b0) begin
      cnt <= 31'd0;
   end else if (cnt == FINISH)begin 
      $finish;
$display("##################################");
$display("## END SIMULATION               ##");
$display("## See Waveform Editor!!        ##");
$display("## If find debugs, debugging.   ##");
$display("## Don't find it, I'm happy.^_^ ##");
$display("##################################");
   end else begin
$display("COUNTING:%d(END:%d)",cnt,FINISH-1);
      cnt <= cnt + 31'd1;
   end
end

wire   tmp_en;
wire   int0_i, int1_i;
assign   tmp_en = (cnt==31'd900) ? 1'b0 : 1'b1;
//assign   int0_i = ((cnt>=31'd3267)&&(cnt<=31'd3277)) ? 1'b0 : 1'b1;
//assign   int1_i = ((cnt>=31'd6859)&&(cnt<=31'd6870)) ? 1'b0 : 1'b1;
assign   int0_i = ((cnt>=31'd3260)&&(cnt<=31'd3277)) ? 1'b0 : 1'b1;
assign   int1_i = ((cnt>=31'd6860)&&(cnt<=31'd6870)) ? 1'b0 : 1'b1;
//assign   int1_i =  1'b1;


reg rst_p;

initial begin
        #50 rst_p  <= 0;
        #300 rst_p <= 1;
        #150 rst_p <= 0;
        end

wire[7:0] test;
wire[7:0]  p1_i;

assign p1_i = 8'hzz;

// Wire & assignment define
wire     [15:0]  rom_adr_o;
wire     [7:0]   rom_data_i;
wire     [15:0]  addr_xdat;
wire     [7:0]   out_xdat;
wire     [7:0]   in_xdat_a;
wire     [7:0]   xdat;
wire             in_xdat;
wire             rd_xdat; 
wire		 wr_xdat;
wire             clkb; 
                                      
asic_top_8051  u0_asic_top_8051 (     
.PI_clk             (clk                  ),
.PI_rst_p            (rst_p                ),
.PI_int0            (int0_i               ),
.PI_int1            (int1_i               ),
.PI_t0              (1'b0                 ),
.PI_t1              (1'b0                 ),
.PI_rxd             (all_txd_o            ),
.PB_p1_io           (p1_i              	  ),
.PO_rom_adr         (rom_adr_o	 	  ),
.PI_rom_data        (rom_data_i		  ),
.PO_addr_xdat       (addr_xdat		  ),
.PB_xdat            (xdat		  ),
.PO_txd             ( all_txd_o           ),
.PO_clkb            (clkb		  ),
.PO_en_xdat         (en_xdat		  ),
.PO_wr_xdat         (wr_xdat_d1		  ), 
.PO_rd_xdat         (rd_xdat   		  ) 
);

rom_16kx8  rom_16kx8 (
.addr               ( rom_adr_o[13:0]      ),
.clk                ( clkb                 ),
.dout               ( rom_data_i           )
);

assign  out_xdat =  xdat;  
assign  in_xdat =  (rd_xdat)?  xdat:8'hzz;  

spsram_1_5kx8 spsram_1_5kx8 (
 .addr              ( addr_xdat[10:0]       ),
 .clk               ( clkb                  ),
 .din               ( out_xdat              ),
 .dout              ( in_xdat_a             ),
 .en                ( en_xdat               ),
 .we                ( wr_xdat_d1            )
);
endmodule


