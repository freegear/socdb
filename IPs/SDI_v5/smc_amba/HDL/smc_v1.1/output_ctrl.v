/*******************************************************************
 SMC for SDI V5
 
 using AHB
 
 Modified : 2006.2.23
 
*******************************************************************/
 

 
module output_ctrl ( resetx, clk, sram,
                     reg_rdata, reg_rdyx, m2b_data, esb_adr26_2, esb_dout,
                     sram_adr, sram_ibex, sram_latch, sram_rdyx, sram_wenx, 
                     mem_adr, mem_rdyx, mem_wenx, b2m_data, mem_rdata );

input         resetx;
input         clk;
input         sram;         // from register block
input  [17:0] reg_rdata;    // from register block
input         reg_rdyx;     // from register block
input  [31:0] m2b_data;     // from EXT
input  [26:2] esb_adr26_2;  // from esb block
input  [31:0] esb_dout;     // from esb block
input  [26:0] sram_adr;     // from sram block. add low address.
input  [ 3:0] sram_ibex;    // from sram block
input         sram_latch;   // from sram block
input         sram_rdyx;    // from sram block
input         sram_wenx;    // from sram block

output [26:0] mem_adr;      // to EXT (pin_mux). add low address.
output        mem_rdyx;     // to esb block
output        mem_wenx;     // to pin_mux
output [31:0] b2m_data;     // to EXT (pin_mux)
output [31:0] mem_rdata;     // to esb block

//-----------------------------------------------------------------
supply1    vdd;
wire [26:0] tex_adr; // low 2 bit include
wire [ 3:0] mux_ibex;
reg [31:0] x2s_data_mux;
reg [31:0] b2m_data_mux;
//-----------------------------------------------------------------
wire          reset    = ~resetx;
wire          latch_en =  sram_latch;
wire [31:0]   data_in  = m2b_data;

assign      tex_adr = sram_adr;
assign      mux_ibex = sram_ibex;
   
always @(posedge reset or posedge clk)
  if   (reset)  x2s_data_mux        <= {32{1'b0}};
  else if (latch_en) begin
    case (mux_ibex)  // synopsys parallel_case full_case
      4'b1110 : x2s_data_mux[ 7: 0] <= data_in[7 :0];
      4'b1101 : x2s_data_mux[15: 8] <= data_in[7 :0];
      4'b1011 : x2s_data_mux[23:16] <= data_in[7 :0];
      4'b0111 : x2s_data_mux[31:24] <= data_in[7 :0];
      4'b1100 : x2s_data_mux[15: 0] <= data_in[15:0];
      4'b0011 : x2s_data_mux[31:16] <= data_in[15:0];
      4'b0000 : x2s_data_mux[31: 0] <= data_in[31:0];
      default : x2s_data_mux[31: 0] <= {32{1'b0}};
    endcase
    end

always @(mux_ibex or esb_dout)
  case (mux_ibex) // synopsys parallel_case full_case
      4'b1110 : b2m_data_mux = {24'b0, esb_dout[ 7: 0]};
      4'b1101 : b2m_data_mux = {24'b0, esb_dout[15: 8]};
      4'b1011 : b2m_data_mux = {24'b0, esb_dout[23:16]};
      4'b0111 : b2m_data_mux = {24'b0, esb_dout[31:24]};
      4'b1100 : b2m_data_mux = {16'b0, esb_dout[15: 0]};
      4'b0011 : b2m_data_mux = {16'b0, esb_dout[31:16]};
      4'b0000 : b2m_data_mux =         esb_dout[31: 0];
      default : b2m_data_mux =  {32{1'b0}};
  endcase

wire [31:0] x2s_data_temp = x2s_data_mux;

assign mem_adr    =  tex_adr;
assign mem_rdyx   =  reg_rdyx  & sram_rdyx;
assign mem_wenx   =  sram_wenx;
assign b2m_data   =  b2m_data_mux;
//assign mem_rdata  =  reg_rdyx  ? x2s_data_temp  : {14'b0, reg_rdata};
assign mem_rdata  =  x2s_data_temp;
   
//-----------------------------------------------------------------

endmodule

