//-------------------------------------------------------
//--  SDI V5 test rom model for FPGA TEST 
//-------------------------------------------------------
//--  verilog rom model 16bit
//--  made by duck (-,.-;;)


module rom(nRST, clk, dout, a, oe, cs);

input nRST;
input clk;
output [15:0]  dout;
input  [16:0]  a;
input          oe;
input          cs;

wire [15:0]   dout0;
wire [15:0]   dout1;
wire [15:0]   dout2;
assign cs0 = (a[16:14]==3'b000)? 1'b0 : 1'b1 ;
assign cs1 = (a[16:14]==3'b001)? 1'b0 : 1'b1 ;
assign cs2 = (a[16:14]==3'b010)? 1'b0 : 1'b1 ;
assign dout = ((oe==0)&&(cs==0)&&(cs0==0))? dout0 :
              ((oe==0)&&(cs==0)&&(cs1==0))? dout1 :
              ((oe==0)&&(cs==0)&&(cs2==0))? dout2 :
              ((oe==0)&&(cs==0))? 16'h0000: 16'bzzzz_zzzz_zzzz_zzzz;
rom0 rom0 (
.nRST(nRST),
.clk(clk),
.dout(dout0),
.a(a[13:0]),
.oe(oe),
.cs(cs0)
);
rom1 rom1 (
.nRST(nRST),
.clk(clk),
.dout(dout1),
.a(a[13:0]),
.oe(oe),
.cs(cs1)
);
rom2 rom2 (
.nRST(nRST),
.clk(clk),
.dout(dout2),
.a(a[13:0]),
.oe(oe),
.cs(cs2)
);
endmodule 
