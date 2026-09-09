`timescale 1ns/10ps

//`include "/user/bhchoi/rc8051/design/rtl_source/inc_vcode.v"
//`include "/user/bhchoi/rc8051/design/rtl_source/BLKMEMSP_V5_0.v"
//`include "/user/bhchoi/rc8051/design/rtl_source/rom_16kx8.v"
//`include "./spsram_256x8.v"
//`include "/user/bhchoi/rc8051/design/MEM_DB_LIB/SPSRAM256X8.v"
//`include "/user/bhchoi/rc8051/design/rtl_source/spsram_1_5kx8.v"
//`include "/user/bhchoi/rc8051/design/rtl_source/rc8051RtlTop.v"
// Bist
//`include "/user/bhchoi/rc8051/design/BIST/SPSRAM256X8.v"
//`include "/user/bhchoi/rc8051/design/BIST/SPSRAM256X8_rb.v"
//`include "/user/bhchoi/rc8051/design/BIST/SPSRAM256X8_sim.v"
//`include "/user/bhchoi/rc8051/design/BIST/SPSRAM256X8_top.v"
//`include "/user/bhchoi/rc8051/design/BIST/SPSRAM256X8_wrapper.v"



`define   CLK24  41.66
`define   CLK48  20.83 
`define   CLK54  18.52   

`define SDF_FILE "/user/bhchoi/rc8051/design/POST_SIM/rc8051RtlTop.sdf"




module TB_rc8051RtlTop;

parameter FRE  = 100;
//parameter FINISH = 10001;
parameter FINISH =  21;


reg         rst, clk; 
reg         int_source;


assign clkb = ~clk;

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
   $shm_open("Sim_rc8051RtlTop.shm" );
   $shm_probe("AC"); 
end

initial $sdf_annotate( `SDF_FILE, Urc8051RtlTop);

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
        #100 rst_p <= 1;
        #150 rst_p <= 0;
        end

wire[7:0]  p1_io;

assign p1_io = 8'hzz;

// Wire & assignment define
wire     [15:0]  rom_adr_o;
wire     [7:0]   rom_data_i;
wire     [15:0]  addr_xdat;
wire     [7:0]   out_xdat;
wire     [7:0]   in_xdat_a;
wire             in_xdat;
wire             rd_xdat; 
wire		 wr_xdat;
wire	[7:0]    p1_o;
wire    [7:0]    p1_en;
wire 		 BistMode;

assign BistMode = 0;           
                           
rc8051RtlTop Urc8051RtlTop (     
.clk                 (clk),
.rst_p               (rst_p),
.int0_i              (int0_i),
.int1_i              (int1_i),
.all_t0_i            (1'b0),
.all_t1_i            (1'b0),
.p1_io               (p1_io),
.all_txd_o           (all_txd_o),
.all_rxd_i           (all_txd_o),
  //sync rom
.rom_adr_o           (rom_adr_o),
.rom_data_i          (rom_data_i),
  //external data memory
.addr_xdat           (addr_xdat),
.out_xdat            (out_xdat),
.in_xdat_a           (in_xdat_a),
.en_xdat             (en_xdat),
.wr_xdat_d1	     (wr_xdat_d1), 
  //BIST test
.BistMode	     (BistMode),
.BistFail	     (BistFail),
.Finish  	     (Finish), 
.scan_en                (1'b0),
.test_mode              (1'b0),
.ErrMap   	     (ErrMap));

rom_16kx8  rom_16kx8 (
.addr               (rom_adr_o[13:0]),
.clk                (clkb),
.dout               (rom_data_i));

spsram_1_5kx8 spsram_1_5kx8 (
 .addr              (addr_xdat[10:0]),
 .clk               (clkb),
 .din               (out_xdat),
 .dout              (in_xdat_a),
 .en                (en_xdat),
 .we                (wr_xdat_d1));
endmodule
