
module Master (
  HCLK,
  HRESETn,

  HBUSREQ,
  HGRANT,
  HMASTER,
  HLOCK,
  HADDR,
  HTRANS,
  HBURST,
  HWRITE,
  HSIZE,

  HRESP,
  HREADY,
  HDATA,
  nLMINT
);

input           HCLK;
input           HRESETn;

output          HBUSREQ;
input           HGRANT;
input   [3:0]   HMASTER;
output          HLOCK;
output  [31:0]  HADDR;
output  [1:0]   HTRANS;
output  [2:0]   HBURST;
output          HWRITE;
output  [1:0]   HSIZE;

input   [1:0]   HRESP;
input           HREADY;
inout   [31:0]  HDATA;
input           nLMINT;

////////////////////////////////////
// DEBUG
////////////////////////////////////
reg  [31:0]  DATA_RD;
reg  [31:0]  DATA_RD1;
reg  [31:0]  DATA_RD2;
reg  [31:0]  BufNextAddr;
reg  [31:0]  RAWINT_DATA;
reg  [31:0]  SRCINT_DATA;
reg  [31:0]  intr_data0;
reg  [31:0]  intr_data1;

reg  [4:0]   pba_wptr;
reg  [4:0]   pba_wcnt;
reg  [31:0]  pdesc_wptr;
initial pdesc_wptr = `DESC_BADDR_;
reg  [31:0]  pdata_wptr;
initial pdata_wptr = `DATA_BADDR_;

reg          erxd_success;
integer      gint_i;           // To use in for-loop

////////////////////////////////////////////////////////////////////////////////
// Wire/Reg Definition
////////////////////////////////////////////////////////////////////////////////
reg             MASTER;
reg             DATA_EN;

reg             HBUSREQ;
wire            HLOCK = 1'b0;
reg     [31:0]  HADDR_i;
reg     [1:0]   HTRANS_i;
reg     [2:0]   HBURST_i;
reg             HWRITE_i;
reg     [1:0]   HSIZE_i;
reg     [31:0]  HWDATA_i;

reg             WriteEnMaster;

////////////////////////////////////////////////////////////////////////////////
// Arbitration
////////////////////////////////////////////////////////////////////////////////
always @(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn)  MASTER <= 1'b0;
  else if(HREADY) begin
    MASTER <= HGRANT;
  end
end

always @(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn)  DATA_EN <= 1'b0;
  else if(HREADY) begin
    DATA_EN <= MASTER;
  end
end

always @(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) WriteEnMaster <= 1'b0;
  else if(HREADY) begin
    if(HTRANS_i == 2'b10 || HTRANS_i == 2'b11) WriteEnMaster <= HWRITE;
  end
end

////////////////////////////////////////////////////////////////////////////////
// AMBA BUS
////////////////////////////////////////////////////////////////////////////////
assign  HADDR = (HMASTER == 4'b0001 && MASTER) ? HADDR_i : 32'hZZZZZZZZ;
assign  HTRANS = (HMASTER == 4'b0001 && MASTER) ? HTRANS_i : 2'bzz;
assign  HBURST = (HMASTER == 4'b0001 && MASTER) ? HBURST_i : 3'bzzz;
assign  HWRITE = (HMASTER == 4'b0001 && MASTER) ? HWRITE_i : 1'bz;
assign  HSIZE = (HMASTER == 4'b0001 && MASTER) ? HSIZE_i : 2'bzz;

assign  HDATA = (DATA_EN & WriteEnMaster) ? HWDATA_i : 32'hZZZZZZZZ;

////////////////////////////////////////////////////////////////////////////////
// Debug
////////////////////////////////////////////////////////////////////////////////
`include "./ahbtask.v"
`include "./usb_model/read_iqueue.task"
`include "./usb_model/write_txdesc.task"
`include "./usb_model/write_txpque.task"
`include "./usb_model/urx_dcompare.task"
`include "./usb_model/utx_dcompare.task"

////////////////////////////////////////////////////////////////////////////////
// Stimulus
////////////////////////////////////////////////////////////////////////////////
initial begin
  `include "./infile.mst"
end

endmodule
