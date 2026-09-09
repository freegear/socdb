//////////////////////////////////////////////////////////////////////////////
// 
// module name : ahb2dma
// Description : interface logic between system bus(AHB) and DMA
// Date        : 2001 / Jul / 10
// Author      : Mark Ryoo
// 
//////////////////////////////////////////////////////////////////////////////

`define  AHBDMA_IDLE               4'b0000
`define  FILL_WBUF                 4'b0001
`define  STADDR_LOAD               4'b0010
`define  XFERGRP                   4'b0011
`define  XFERGRPEND                4'b0100
`define  IDLE                      4'b0101
`define  IDLE_END                  4'b1001
`define  XFERFINISH                4'b1010
`define  FLUSH_START               4'b1011
`define  FLUSH_WBUF                4'b1100

module ahb2dma (

// Clock and reset
  clk_main,                 // System Clock
  rst_main,                 // System Reset

// AHB
  HGRANTdma,                // System bus grant
  HMASTER,                  // System bus master
  HRESP,                    // System bus response (retry/error/split support)
  HREADY,                   // System bus ready
  HRDATA,                   // System data bus for read
  HBUSREQdma,               // System BUS request
  HTRANS,                   // Transfer Type
  HBURST,                   // Burst Type : always increment sequence
  HSIZE,                    // HSIZE : word
  HWRITE,                   // Write control
  HADDR,                    // System address bus
  HWDATA,                   // System data bus for write

// DMA master
  dma_wreq, 
  dma_rreq,
  dma_size,
  dma_wben_i,
  dma_addr_i, 
  outdma_data_i,            // dma data for USB (in)
  dma_ack, 
  dma_ready, 
  indma_data_i              // dma data for USB (out)

);

// Clock and reset
input            clk_main;
input            rst_main;

// AHB
input            HGRANTdma;
input   [2:0]    HMASTER;
input   [1:0]    HRESP;
input            HREADY;
input   [31:0]   HRDATA;
output           HBUSREQdma;
output  [1:0]    HTRANS;
output  [2:0]    HBURST;
output  [1:0]    HSIZE;
output           HWRITE;
output  [31:0]   HADDR;
output  [31:0]   HWDATA;

// DMA master
input            dma_wreq;
input            dma_rreq;
input    [5:2]   dma_size;
input    [3:0]   dma_wben_i;
input   [25:2]   dma_addr_i;
input   [31:0]   outdma_data_i;
output           dma_ack;
output           dma_ready;
output  [31:0]   indma_data_i;

//////////////////////////////////////////////////////////////
// Wire Definition
//////////////////////////////////////////////////////////////
reg              HBUSREQdma;
reg              ReXfer;
reg              pdma_ack, dma_ack;
reg     [25:2]   dma_st_addr;
reg     [5:2]    dma_length;

wire    [31:0]   HADDR_i;
reg     [5:2]    HADDR_reg;

reg     [31:0]   HWDATA_pre;
reg     [31:0]   HWDATA_i;

wire    [7:0]    DummySum;
wire             ONEKBOUND;
wire    [2:0]    HBURST_i;

reg              HWRITE_reg;
wire             HWRITE_i;

wire    [1:0]    HSIZE_i;
wire    [1:0]    HTRANS_i;
wire             OKAY;
wire             ERROR;       // No Error Opertration is supported
wire             RETRY;
wire             SPLIT;

reg     [5:2]    dma_cnt;
wire             fillflushend;
reg     [25:2]   dma_int_addr;
reg              ahbaddr_load;
reg              ahbaddr_reload;
reg              ahbaddr_dec;
reg              ahbaddr_on;
reg              ahbdata_on;
wire             Xferend;

reg     [3:0]    state, nstate;

reg              iMASTER, MASTER, DATA_EN;

reg     [31:0]   DBuf0, DBuf1, DBuf2, DBuf3, DBuf4, DBuf5, DBuf6, DBuf7;
reg     [31:0]   DBuf8, DBuf9, DBufA, DBufB, DBufC, DBufD, DBufE, DBufF;

//////////////////////////////////////////////////////////////
// DMA Condition Setup / Internal AHB Bus 
//////////////////////////////////////////////////////////////

// page size, initial address fetch
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) dma_ack <= 0;
  else dma_ack <= pdma_ack;
end

// dma start address
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) dma_st_addr <= 0;
  else if(dma_ack) dma_st_addr <= dma_addr_i;
end

// dma length
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) dma_length <= 0;
  else if(dma_ack) dma_length <= dma_size;
end

// HADDR_i
assign  HADDR_i = {6'b100000, dma_int_addr, 2'b00};

// HWDATA_i
always @(dma_int_addr or 
         DBuf0 or DBuf1 or DBuf2 or DBuf3 or
         DBuf4 or DBuf5 or DBuf6 or DBuf7 or
         DBuf8 or DBuf9 or DBufA or DBufB or
         DBufC or DBufD or DBufE or DBufF) begin
  case (dma_int_addr[5:2]) 
    4'b0000 : HWDATA_pre = DBuf0;
    4'b0001 : HWDATA_pre = DBuf1;
    4'b0010 : HWDATA_pre = DBuf2;
    4'b0011 : HWDATA_pre = DBuf3;
    4'b0100 : HWDATA_pre = DBuf4;
    4'b0101 : HWDATA_pre = DBuf5;
    4'b0110 : HWDATA_pre = DBuf6;
    4'b0111 : HWDATA_pre = DBuf7;
    4'b1000 : HWDATA_pre = DBuf8;
    4'b1001 : HWDATA_pre = DBuf9;
    4'b1010 : HWDATA_pre = DBufA;
    4'b1011 : HWDATA_pre = DBufB;
    4'b1100 : HWDATA_pre = DBufC;
    4'b1101 : HWDATA_pre = DBufD;
    4'b1110 : HWDATA_pre = DBufE;
    4'b1111 : HWDATA_pre = DBufF;
  endcase
end

always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) HWDATA_i <= 32'h00000000;
  else if(HREADY & OKAY) HWDATA_i <= HWDATA_pre;
end

// ONEKBOUND
assign  {ONEKBOUND, DummySum} = ({1'b0, dma_addr_i[9:2]} + {5'b00000, dma_size});

// HBURST_i 
assign  HBURST_i = 3'b001;                                      // INC

// HWRITE_reg
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) HWRITE_reg <= 1'b0;
  else if(dma_wreq & (state == `AHBDMA_IDLE )) HWRITE_reg <= 1'b1;
  else if(dma_rreq & (state == `AHBDMA_IDLE )) HWRITE_reg <= 1'b0;
end

assign  HWRITE_i = HWRITE_reg & ahbaddr_on;

// assign  HWRITE_i = ((state == `IDLE) || (state == `IDLE_END)) ?
//                            (MASTER & HREADY & OKAY & HWRITE_reg) :
//                    ((state == `STADDR_LOAD) || 
//                     (state == `XFERGRP) || (state == `XFERGRPEND)) ? HWRITE_reg :
//                     1'b0;

// HSIZE_i
assign  HSIZE_i = 2'b10;                                       // 32 bit

// HTRANS_i
assign  HTRANS_i = ((state == `IDLE) || (state == `IDLE_END)) ? 
                                               {(MASTER & HREADY & OKAY), 1'b0} :
                   ((state == `XFERGRP ) & ahbaddr_on) ? 2'b10 : 
                   ((state == `XFERGRPEND)) ? (2'b11 & {1'b1, ~ONEKBOUND}) : 
                   2'b00;

// HRESP
assign  OKAY = (HRESP == 2'b00);
assign  ERROR = (HRESP == 2'b01);
assign  RETRY = (HRESP == 2'b10);
assign  SPLIT = (HRESP == 2'b11);

//////////////////////////////////////////////////////////////
// DMA Control 
//////////////////////////////////////////////////////////////

// fillflushend indicates data buffer fill is completed
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) dma_cnt <= 0;
  else if(dma_ack) dma_cnt <= dma_size;
  else if(dma_ready && (dma_cnt != 0)) dma_cnt <= dma_cnt - 1;
end

assign   fillflushend = (HWRITE_reg & ~dma_ack & (dma_cnt == 0)) |
                   (~HWRITE_reg & (dma_cnt ==0));

assign   dma_ready = (HWRITE_reg & ~dma_ack & (state == `FILL_WBUF)) |
                     (~HWRITE_reg & (state == `FLUSH_WBUF));

// dma start address
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) dma_int_addr <= 0;
  else if(ahbaddr_dec) dma_int_addr <= dma_int_addr - 1;
  else if(ahbaddr_load) begin
    if(HWRITE_reg) dma_int_addr <= dma_st_addr;
    else dma_int_addr <= dma_addr_i;
  end
  else if(ahbaddr_reload) begin
    dma_int_addr <= dma_st_addr;
  end
  else if(MASTER & HREADY & OKAY & ahbaddr_on) dma_int_addr <= dma_int_addr + 1;
  else if(~HWRITE_reg & (state == `FLUSH_WBUF)) dma_int_addr <= dma_int_addr + 1;
end

// dma count
reg  [5:2]  dma_count;
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) dma_count <= 4'b0000;
  else if(ahbaddr_dec) dma_count <= dma_count - 1;
  else if(ahbaddr_load | ahbaddr_reload) dma_count <= 0;
  else if(MASTER & HREADY & OKAY & ahbaddr_on & ~Xferend) dma_count <= dma_count + 1;
end

// ahbdata_on
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) ahbdata_on <= 1'b0;
  else if(ahbaddr_load) ahbdata_on <= 1'b0;
  else if(MASTER & HREADY & OKAY) ahbdata_on <= ahbaddr_on;
end

// Xferend
assign   Xferend = (dma_count == dma_length) ? 1'b1 : 1'b0;

// indma_data_i
assign  indma_data_i = HWDATA_pre;

//////////////////////////////////////////////////////////////
// Data Buffer
//////////////////////////////////////////////////////////////

// dma_addr_reg
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) HADDR_reg <= 0;
  else if(ahbaddr_on & HREADY & OKAY) HADDR_reg <= dma_int_addr[5:2];
end

// DBuf0
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf0 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0000) DBuf0 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0000) DBuf0 <= HRDATA;
end

// DBuf1
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf1 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0001) DBuf1 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0001) DBuf1 <= HRDATA;
end

// DBuf2
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf2 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0010) DBuf2 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0010) DBuf2 <= HRDATA;
end

// DBuf3
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf3 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0011) DBuf3 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0011) DBuf3 <= HRDATA;
end

// DBuf4
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf4 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0100) DBuf4 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0100) DBuf4 <= HRDATA;
end

// DBuf5
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf5 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0101) DBuf5 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0101) DBuf5 <= HRDATA;
end

// DBuf6
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf6 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0110) DBuf6 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0110) DBuf6 <= HRDATA;
end

// DBuf7
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf7 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b0111) DBuf7 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b0111) DBuf7 <= HRDATA;
end

// DBuf8
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf8 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1000) DBuf8 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1000) DBuf8 <= HRDATA;
end

// DBuf9
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBuf9 <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1001) DBuf9 <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1001) DBuf9 <= HRDATA;
end

// DBufA
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBufA <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1010) DBufA <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1010) DBufA <= HRDATA;
end

// DBufB
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBufB <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1011) DBufB <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1011) DBufB <= HRDATA;
end

// DBufC
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBufC <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1100) DBufC <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1100) DBufC <= HRDATA;
end

// DBufD
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBufD <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1101) DBufD <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1101) DBufD <= HRDATA;
end

// DBufE
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBufE <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1110) DBufE <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1110) DBufE <= HRDATA;
end

// DBufF
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DBufF <= 0;
  else if(HWRITE_reg && dma_ready && dma_addr_i[5:2] == 4'b1111) DBufF <= outdma_data_i;
  else if(ahbdata_on & ~HWRITE_reg && HADDR_reg == 4'b1111) DBufF <= HRDATA;
end

//////////////////////////////////////////////////////////////
// Main State Machine
//////////////////////////////////////////////////////////////

// current state
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) state <= `AHBDMA_IDLE;
  else state <= nstate;
end

// state combinational logic
always @(state or dma_wreq or dma_rreq or fillflushend 
        or MASTER or HWRITE_reg or Xferend
        or HREADY or OKAY or ERROR or RETRY or SPLIT or HGRANTdma ) begin

  HBUSREQdma = 1'b1;
  pdma_ack = 1'b0;
  ahbaddr_load = 1'b0;
  ahbaddr_reload = 1'b0;
  ahbaddr_dec = 1'b0;
  ahbaddr_on = 1'b0;
  nstate = state;

  case (state) // synopsys full_case parallel_case

    `AHBDMA_IDLE : begin
      if(dma_wreq) begin
          pdma_ack = 1'b1;
          nstate = `FILL_WBUF;
      end
      else if(dma_rreq) begin
          pdma_ack = 1'b1;
          nstate = `STADDR_LOAD;
      end
      else begin
          HBUSREQdma = 1'b0;
      end
    end

    `FILL_WBUF : begin
      ahbaddr_load = 1'b1;
      if(MASTER & fillflushend) nstate = `XFERGRP;
    end

    `STADDR_LOAD : begin
      ahbaddr_load = 1'b1;
      if(MASTER & HREADY & OKAY) nstate = `XFERGRP;
    end
  
    `XFERGRP : begin
      if(MASTER & HREADY & OKAY) begin 
        ahbaddr_on = 1'b1;
        if(Xferend) begin
          nstate = `XFERFINISH;
        end
        else nstate = `XFERGRPEND;
      end
    end

    `XFERGRPEND : begin
      if(MASTER & ERROR) begin
        ahbaddr_reload = 1'b1;
        nstate = `XFERGRP;
      end
      else if(MASTER & (RETRY | SPLIT)) begin
        ahbaddr_dec = 1'b1;
        nstate = `IDLE;
      end
      else if(MASTER & HREADY & OKAY) begin
        ahbaddr_on = 1'b1;
        if(Xferend) nstate = `XFERFINISH;
      end
    end

    `IDLE : begin
      if(MASTER & ERROR) begin
        ahbaddr_reload = 1'b1;
        nstate = `XFERGRP;
      end
      else if(MASTER & HREADY & OKAY) begin
        ahbaddr_on = 1'b1;
        if(Xferend) nstate = `XFERFINISH;
        else nstate = `XFERGRPEND;
      end
    end

    `IDLE_END : begin
      if(MASTER & ERROR) begin
        ahbaddr_reload = 1'b1;
        nstate = `XFERGRP;
      end
      else if(MASTER & HREADY & OKAY) begin
        ahbaddr_on = 1'b1;
        nstate = `XFERFINISH;
      end
    end

    `XFERFINISH : begin
      if (MASTER & ERROR) begin
        ahbaddr_reload = 1'b1;
        nstate = `XFERGRP;
      end
      else if(MASTER & (RETRY | SPLIT)) begin
        ahbaddr_dec = 1'b1;
        nstate = `IDLE_END;
      end
      else if(MASTER & HREADY & OKAY) begin
        if(HWRITE_reg) nstate = `AHBDMA_IDLE;
        else nstate = `FLUSH_START;
      end
    end

    `FLUSH_START : begin
      HBUSREQdma = 1'b0;
      ahbaddr_load = 1'b1;
      nstate = `FLUSH_WBUF;
    end

    `FLUSH_WBUF : begin
      HBUSREQdma = 1'b0;
      if(fillflushend) nstate = `AHBDMA_IDLE;
    end

  endcase

end

//////////////////////////////////////////////////////////////////
// bus arbitration
//////////////////////////////////////////////////////////////////

// Write Period
  reg  HWRITEReg;
  always @( posedge clk_main or posedge rst_main ) begin
    if(rst_main) HWRITEReg <= 1'b0;
    else if(HREADY & (HTRANS_i == 2'b10 || HTRANS == 2'b11)) HWRITEReg <= HWRITE_reg;
  end

// MASTER indicates Valid Control signal window
//                  (HADDR, HTRANS, HWRITE, HBURST, HSIZE)
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) iMASTER <= 1'b0;
  else if(HGRANTdma & HREADY) iMASTER <= 1'b1;
  else if(~HGRANTdma & HREADY) iMASTER <= 1'b0;
end
always @(HMASTER or iMASTER) begin
  MASTER = iMASTER & (HMASTER == 3'b000);
end

// DATA_EN indicates Valid Response signal window and HWDATA
//                  (HREADY, HRDATA, HRESP)
//                  (HWDATA)
always @(posedge clk_main or posedge rst_main) begin
  if(rst_main) DATA_EN <= 1'b0;
  else if(MASTER & HREADY & OKAY) DATA_EN <= 1'b1;
  else if (HREADY) DATA_EN <= 1'b0;
end

//////////////////////////////////////////////////////////////////
// bus tri-state
//////////////////////////////////////////////////////////////////
assign  HADDR = (MASTER) ? HADDR_i : 32'hZZZZZZZZ;
assign  HTRANS = (MASTER) ? HTRANS_i : 2'bzz;
assign  HBURST = (MASTER) ? HBURST_i : 3'bzzz;
assign  HSIZE = (MASTER) ? HSIZE_i : 3'bzzz;
assign  HWRITE = (MASTER) ? HWRITE_i : 1'bz;
assign  HWDATA = (DATA_EN & HWRITEReg) ? HWDATA_i : 32'hZZZZZZZZ;

endmodule
