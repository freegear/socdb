//
// DMA Interface Block Top module
// linerxdib + linetxdib + dib_ctrl
//

module mdma (

// Clock and reset
  clk_main,             // Main clock
  rst_main,             // Main reset
  big_endian,           // 1: big endian
  scan_test,            // 1: scan test mode
  intr_buffer,          // Buffer allocation request interrupt

// AHB for internal register
  hsel_ahb,             // AHB Select
  hready_in,            // AHB READYin
  hwrite,               // AHB Write
  htrans,               // AHB Transfer Type
  hsize,                // AHB Data Size
  haddr,                // AHB Address
  hwdata,               // AHB Write Data
  hready_out,           // AHB READYout
  hresp,                // AHB Response
  hrdata,               // AHB Read Data

// AHB for DMA
  HGRANTdma,            // AHB grant
  HMASTER,              // AHB master
  HRESP,                // AHB response (retry/error/split support)
  HREADY,               // AHB ready
  HRDATA,               // AHB data for read
  HBUSREQdma,           // AHB request
  HTRANS,               // AHB Transfer Type
  HBURST,               // AHB Burst Type
  HSIZE,                // AHB HSIZE : word or byte
  HWRITE,               // AHB Write control
  HADDR,                // AHB address
  HWDATA,               // AHB data for write

// RDMA sources interface
  desc_wreq,       // RDMA request source
  desc_wstpac,     // RDMA start packet indicator source
  desc_wendpac,    // RDMA end packet indicator source
  desc_wzero,      // RDMA zero bytes
  desc_wlengthA,   // RDMA length from port 0
  desc_wlengthB,   // RDMA length from port 1
  desc_wlengthC,   // RDMA length from port 2
  desc_wlengthD,   // RDMA length from port 3
  desc_wdataA,     // RDMA data from port 0
  desc_wdataB,     // RDMA data from port 1
  desc_wdataC,     // RDMA data from port 2
  desc_wdataD,     // RDMA data from port 3
  desc_wack,       // RDMA ack for desc_wreq
  desc_wdone,      // RDMA data valid
  desc_wend,       // RDMA end
  desc_waddr,      // RDMA read address
  desc_wstptrA,    // RDMA descriptor start pointer for port 0
  desc_wstptrB,    // RDMA descriptor start pointer for port 1
  desc_wstptrC,    // RDMA descriptor start pointer for port 2
  desc_wstptrD,    // RDMA descriptor start pointer for port 3

// TDMA sources interface
  desc_rreq,       // TDMA request source
  desc_rstpac,     // TDMA start packet indicator source
  desc_rendpac,    // TDMA end packet indicator source
  desc_rlengthA,   // TDMA length for port 0
  desc_rlengthB,   // TDMA length for port 1
  desc_rlengthC,   // TDMA length for port 2
  desc_rlengthD,   // TDMA length for port 3
  desc_rstptrA,    // TDMA descriptor start pointer for port 0
  desc_rstptrB,    // TDMA descriptor start pointer for port 1
  desc_rstptrC,    // TDMA descriptor start pointer for port 2
  desc_rstptrD,    // TDMA descriptor start pointer for port 3
  desc_rack,       // TDMA ack for desc_rreq
  desc_rdone,      // TDMA data valid
  desc_rdmaend,    // TDMA end
  desc_rwben,      // TDMA write byte enable
  desc_raddr,      // TDMA write address
  desc_rdata       // TDMA data

);

// Clock and reset
input          clk_main;
input          rst_main;
input          big_endian;
input          scan_test;
output         intr_buffer;

// AHB for internal register
input          hsel_ahb;
input          hready_in;
input          hwrite;
input   [1:0]  htrans;
input   [1:0]  hsize;
input  [23:0]  haddr;
input  [31:0]  hwdata;
output         hready_out;
output  [1:0]  hresp;
output [31:0]  hrdata;

// AHB for DMA
input          HGRANTdma;
input   [2:0]  HMASTER;
input   [1:0]  HRESP;
input          HREADY;
input  [31:0]  HRDATA;
output         HBUSREQdma;
output  [1:0]  HTRANS;
output  [2:0]  HBURST;
output  [1:0]  HSIZE;
output         HWRITE;
output [31:0]  HADDR;
output [31:0]  HWDATA;

// RDMA source interfaces
input   [3:0]  desc_wreq;                
input   [3:0]  desc_wstpac;              
input   [3:0]  desc_wendpac;             
input   [3:0]  desc_wzero;
input   [7:0]  desc_wlengthA;        
input   [7:0]  desc_wlengthB;        
input   [7:0]  desc_wlengthC;        
input   [7:0]  desc_wlengthD;        
input  [31:0]  desc_wdataA;         
input  [31:0]  desc_wdataB;         
input  [31:0]  desc_wdataC;         
input  [31:0]  desc_wdataD;         
output  [3:0]  desc_wack;               
output         desc_wdone;              
output         desc_wend;            
output  [5:2]  desc_waddr;         
output [31:0]  desc_wstptrA;
output [31:0]  desc_wstptrB;
output [31:0]  desc_wstptrC;
output [31:0]  desc_wstptrD;

// TDMA source interfaces
input   [3:0]  desc_rreq;                
input   [3:0]  desc_rstpac;              
input   [3:0]  desc_rendpac;              
input   [7:0]  desc_rlengthA;        
input   [7:0]  desc_rlengthB;        
input   [7:0]  desc_rlengthC;        
input   [7:0]  desc_rlengthD;        
input  [31:0]  desc_rstptrA;
input  [31:0]  desc_rstptrB;
input  [31:0]  desc_rstptrC;
input  [31:0]  desc_rstptrD;
output  [3:0]  desc_rack;               
output         desc_rdone;              
output         desc_rdmaend;            
output  [3:0]  desc_rwben;       
output  [5:2]  desc_raddr;         
output [31:0]  desc_rdata;        

///////////////////////////////////////////////////////
// Internal register address decoder
///////////////////////////////////////////////////////
wire  [31:0]  rout0;
wire  [31:0]  rout1;
wire  [31:0]  rout2;
wire  [31:0]  rout3;
wire  [31:0]  rout4;
wire          rd_tx_idx;
wire          rd_hostdescstptr;
wire          rd_hostdatalen;
wire          rd_buf_ptr;
wire          rd_bufsize;
wire          rd_int_idxA;
wire          rd_int_idxB;
wire          rd_int_idxC;
wire          rd_int_idxD;
wire          rd_int_data;
wire          rd_int_addr;
wire  [31:0]  rd_lbuf_addr;
wire  [31:0]  rd_dbuf_addr;
wire          wr_tx_idx;
wire          wr_hostdescstptr;
wire          wr_hostdatalen;
wire          wr_buf_ptr;
wire          wr_bufsize;
wire          wr_int_idxA;
wire          wr_int_idxB;
wire          wr_int_idxC;
wire          wr_int_idxD;
wire  [31:0]  wr_lbuf_addr;
wire  [31:0]  wr_dbuf_addr;


///////////////////////////////////////////////////////////////////////////
// Interface between AHB and Internal register bus
///////////////////////////////////////////////////////////////////////////
wire         mem_ack;
wire [31:0]  mem_rd_data;
wire         mem_wreq;
wire         mem_rreq;
wire [3:0]   mem_ben;
wire [23:0]  mem_addr;
wire [31:0]  mem_wr_data;

dreg_ahbif dreg_ahbif (
// Clock and reset
  .clk_main     (clk_main),
  .rst_main     (rst_main),
  .big_endian   (big_endian),

// AHB for internal register
  .HSELAHBGTX   (hsel_ahb),
  .HWRITE       (hwrite),
  .HREADYIn     (hready_in),
  .HTRANS       (htrans),
  .HSIZE        (hsize),
  .HADDR        (haddr),
  .HWDATA       (hwdata),
  .HREADYOut    (hready_out),
  .HRESP        (hresp),
  .HRDATA       (hrdata),

// Internal bus
  .mem_ack      (mem_ack),
  .mem_rd_data  (mem_rd_data),
  .mem_wreq     (mem_wreq),
  .mem_rreq     (mem_rreq),
  .mem_ben      (mem_ben),
  .mem_addr     (mem_addr),
  .mem_wr_data  (mem_wr_data)
);


///////////////////////////////////////////////////////////////////////////
// Internal register address decoder
///////////////////////////////////////////////////////////////////////////
dma_regdec dma_regdec (
// Clock and reset
  .clk_main        (clk_main),     // Main clock
  .rst_main        (rst_main),     // Main reset
  .scan_test       (scan_test),    // 1: scan test mode

// Register read / write
  .mem_rreq        (mem_rreq),     // Read request by MCU
  .mem_wreq        (mem_wreq),     // Write request by MCU
  .mem_addr        (mem_addr),     // R/W address by MCU
  .mem_ack         (mem_ack),      // Ack for mem_rreq/mem_wreq
  .mem_rd_data     (mem_rd_data),  // Read data by MCU

// Register read data
  .rout0          (rout0),       // 000 ~ 03f
  .rout1          (rout1),       // 040 ~ 07f
  .rout2          (rout2),       // 080 ~ 0bf
  .rout3          (rout3),       // 0c0 ~ 0ff
  .rout4          (rout4),       // 100 ~ 13f

// Decoded signals
  .rd_buf_ptr      (rd_buf_ptr),
  .rd_bufsize      (rd_bufsize),
  .rd_lbuf_addr    (rd_lbuf_addr),
  .rd_dbuf_addr    (rd_dbuf_addr),
  .wr_buf_ptr      (wr_buf_ptr),
  .wr_bufsize      (wr_bufsize),
  .wr_lbuf_addr    (wr_lbuf_addr),
  .wr_dbuf_addr    (wr_dbuf_addr)
);

wire[5:2]  dma_size;  
wire[5:2]  dma_wsize;  
wire[5:2]  dma_rsize;  
wire[3:0]  dma_wben;      
wire[31:0]  dram_rdata;         
wire[1:0] dt_state;
wire[1:0]  warb;
//wire       dram_filldone_r,dram_filldone_t;
wire       dma_ready;

wire[3:0] desc_rstate;   // For debug


wire         mdesc_wreq;
wire         pmdesc_wstpac;
wire         mdesc_wstpac;
wire         mdesc_wendpac;
wire  [7:0]  mdesc_wlength;
wire [31:0]  mdesc_wdata;
wire         mdesc_wack;
wire         rdma_during;

///////////////////////////////////////////////////////////////////////////
// RDMA master controller
///////////////////////////////////////////////////////////////////////////
wire [25:2] dma_addr;
wire [25:2] dma_waddr;
wire [25:2] dma_raddr;
wire [31:0] dma_wdata;
wire        dma_wack;

mrdma_ctrl mrdma_ctrl (
// Clock and reset
  .mclk             (clk_main),         // Main clock
  .mreset           (rst_main),         // Main reset
  .intr_buffer      (intr_buffer),      //buffer request interrupt

// RDMA interface
  .warb             (warb),             // RDMA arbiter state
  .desc_wreq        (mdesc_wreq),       // RDMA request
  .pdesc_wstpac     (pmdesc_wstpac),    // pre mdesc_wstpac
  .desc_wstpac      (mdesc_wstpac),     // RDMA start packet indicator
  .desc_wendpac     (mdesc_wendpac),    // RDMA end packet indicator
  .desc_wzero       (mdesc_wzero),      // RDMA zero bytes
  .desc_wlength     (mdesc_wlength),    // RDMA length
  .desc_wdata       (mdesc_wdata),      // RDMA data
  .pdesc_wack       (mdesc_wack),       // RDMA ack for mdesc_wreq
  .rDMA_During      (rdma_during),      // 1: During RDMA
  .desc_wdone       (desc_wdone),       // RDMA data valid
  .desc_wdmaend     (desc_wend),        // RDMA end
  .wbufdma_period   (desc_wperiod),     // RDMA data request
  .desc_waddr       (desc_waddr),       // RDMA read address
  .rhdesc_stptrA    (desc_wstptrA),     // RDMA descriptor start pointer
  .rhdesc_stptrB    (desc_wstptrB),     // RDMA descriptor start pointer
  .rhdesc_stptrC    (desc_wstptrC),     // RDMA descriptor start pointer
  .rhdesc_stptrD    (desc_wstptrD),     // RDMA descriptor start pointer

// Internal DMA bus
  .dram_wreq_r      (pdma_wreq),        //dram write request
  .dram_addr_r      (dma_waddr),        //dram_addr
  .dram_wdata_r     (dma_wdata),        //data to be written into dram
  .dram_page_size_r (dma_wsize),
  .dram_wben_r      (dma_wben),
  .dram_ack_r       (dma_wack),         //dram ack signal
  .dram_filldone    (dma_ready),        //dram data valid signal

// Register read data
  .rout0            (rout0),
  .rout1            (rout1),
  .rout2            (rout2),
  .rout3            (rout3),
  .rout4            (rout4),

// Internal register read/write
  .wr_lbuf_addr     (wr_lbuf_addr),
  .wr_dbuf_addr     (wr_dbuf_addr),
  .rd_lbuf_addr     (rd_lbuf_addr),
  .rd_dbuf_addr     (rd_dbuf_addr),
  .wr_buf_ptr       (wr_buf_ptr),
  .rd_buf_ptr       (rd_buf_ptr),
  .wr_bufsize       (wr_bufsize),
  .rd_bufsize       (rd_bufsize),
  .mben             (mem_ben),
  .reg_wr_data      (mem_wr_data)
);



wire  [1:0]  rarb;
wire         mdesc_rreq;
wire         mdesc_rstpac;
wire         mdesc_rendpac;
wire  [7:0]  mdesc_rlength;
wire         mdesc_rack;
wire         tdma_during;
wire [31:0]  dma_rdata;
wire         dma_rack;

mtdma_ctrl mtdma_ctrl (

// Clock and reset
  .mclk(clk_main),                 //main clock
  .mreset(rst_main),               //main reset

// Internal DMA bus
  .dram_rreq_t(pdma_rreq),          //dram read request
  .dram_addr_t(dma_raddr),          //dram_addr
  .dram_page_size_t(dma_rsize),
  .dram_filldone(dma_ready),        //dram data valid signal
  .dram_rdata(dma_rdata),           //dram read data
  .dma_rack(dma_rack),              //dram ack signal generated by arbitor
  .dt_state(dt_state),

// TDMA interface
  .rarb           (rarb),            // TDMA arbitor state
  .desc_rreq      (mdesc_rreq),      // TDMA request
  .desc_rstpac    (mdesc_rstpac),    // TDMA start packet indicator
  .desc_rendpac   (mdesc_rendpac),   // TDMA end packet indicator
  .desc_rlength   (mdesc_rlength),   // TDMA length
  .HostDescStPtrA (desc_rstptrA), //Packet start address for ethernet.
  .HostDescStPtrB (desc_rstptrB), //Packet start address for ethernet.
  .HostDescStPtrC (desc_rstptrC), //Packet start address for ethernet.
  .HostDescStPtrD (desc_rstptrD), //Packet start address for ethernet.
  .pdesc_rack     (mdesc_rack),      // TDMA ack for mdesc_rreq
  .tDMA_During    (tdma_during),     // During TDMA
  .desc_rdone     (desc_rdone),      // TDMA write enable
  .desc_rdmaend   (desc_rdmaend),    // TDMA end
  .FIFO_wBen      (desc_rwben),      // TDMA write byte enable 
  .desc_raddr     (desc_raddr),      // TDMA write address
  .desc_rdata     (desc_rdata)       // TDMA write data
);


///////////////////////////////////////////////////////////////////////////
// DMA arbiter
///////////////////////////////////////////////////////////////////////////
dma_arbitor dma_arbitor (
// Clock and reset
  .clk_main       (clk_main),
  .rst_main       (rst_main),

// RDMA interface
  .mdesc_wack     (mdesc_wack),
  .rdma_during    (rdma_during),
  .warb           (warb),
  .mdesc_wreq     (mdesc_wreq),
  .pmdesc_wstpac  (pmdesc_wstpac),
  .mdesc_wstpac   (mdesc_wstpac),
  .mdesc_wendpac  (mdesc_wendpac),
  .mdesc_wzero    (mdesc_wzero),
  .mdesc_wlength  (mdesc_wlength),
  .mdesc_wdata    (mdesc_wdata),

// TDMA interface
  .mdesc_rack     (mdesc_rack),
  .tdma_during    (tdma_during),
  .rarb           (rarb),
  .mdesc_rreq     (mdesc_rreq),
  .mdesc_rstpac   (mdesc_rstpac),
  .mdesc_rendpac  (mdesc_rendpac),
  .mdesc_rlength  (mdesc_rlength),

// RDMA source interface
  .desc_wreq      (desc_wreq),
  .desc_wstpac    (desc_wstpac),
  .desc_wendpac   (desc_wendpac),
  .desc_wzero     (desc_wzero),
  .desc_wlengthA  (desc_wlengthA),
  .desc_wlengthB  (desc_wlengthB),
  .desc_wlengthC  (desc_wlengthC),
  .desc_wlengthD  (desc_wlengthD),
  .desc_wdataA    (desc_wdataA),
  .desc_wdataB    (desc_wdataB),
  .desc_wdataC    (desc_wdataC),
  .desc_wdataD    (desc_wdataD),
  .desc_wack      (desc_wack),

// TDMA source interface
  .desc_rreq      (desc_rreq),
  .desc_rstpac    (desc_rstpac),
  .desc_rendpac   (desc_rendpac),
  .desc_rlengthA  (desc_rlengthA),
  .desc_rlengthB  (desc_rlengthB),
  .desc_rlengthC  (desc_rlengthC),
  .desc_rlengthD  (desc_rlengthD),
  .desc_rack      (desc_rack)
);


///////////////////////////////////////////////////////////////////////////
// Interface between AHB master and DMA master
///////////////////////////////////////////////////////////////////////////
wire dma_ack;

dma_decoder dma_decoder (

// Clock and reset
  .clk_main     (clk_main),       // Main clock
  .rst_main     (rst_main),       // Main reset

// AHB master interface signals
  .dma_ack      (dma_ack),        // Ack. for dma_wreq / dma_rreq
  .dma_wreq     (dma_wreq),       // Write DMA request
  .dma_rreq     (dma_rreq),       // Read DMA request
  .dma_size     (dma_size),       // DMA word size
  .dma_addr     (dma_addr),       // DMA address

// DMA master interface signals
  .dma_waddr    (dma_waddr),      // Write DMA address
  .dma_raddr    (dma_raddr),      // Read DMA address
  .pdma_wreq    (pdma_wreq),      // Write DMA request
  .pdma_rreq    (pdma_rreq),      // Read DMA request
  .dma_wsize    (dma_wsize),      // Write DMA word size
  .dma_rsize    (dma_rsize),      // Read DMA word size
  .rdma_during  (rdma_during),    // During RDMA
  .tdma_during  (tdma_during),    // During TDMA
  .dma_rack     (dma_rack),       // Ack. for pdma_rreq
  .dma_wack     (dma_wack)        // Ack. for pdma_wreq
);


///////////////////////////////////////////////////////////////////////////
// AHB master for DMA
///////////////////////////////////////////////////////////////////////////
wire  [2:0] hburst;

ahb2dma ahb2dma (
// Clock and reset
  .clk_main     (clk_main),      // Main Clock
  .rst_main     (rst_main),      // Main Reset

// AHB
  .HGRANTdma    (HGRANTdma),     // AHB bus grant
  .HMASTER      (HMASTER),       // AHB master
  .HREADY       (HREADY),        // AHB bus ready
  .HRESP        (HRESP),         // AHB bus response
  .HRDATA       (HRDATA),        // AHB data bus for read
  .HBUSREQdma   (HBUSREQdma),    // AHB BUS request
  .HWRITE       (HWRITE),        // 1: write, 0: read 
  .HTRANS       (HTRANS),        // AHB transfer type
  .HBURST       (HBURST),        // AHB burst type
  .HSIZE        (HSIZE),         // AHB Word or byte
  .HADDR        (HADDR),         // AHB address bus
  .HWDATA       (HWDATA),        // AHB data bus for write

// Internal DMA bus
  .dma_wreq     (dma_wreq),      // Write DMA request
  .dma_rreq     (dma_rreq),      // Read DMA request
  .dma_wben_i   (dma_wben),      // DMA write byte enable
  .dma_size     (dma_size),      // DMA size
  .dma_addr_i   (dma_addr),      // DMA address
  .outdma_data_i(dma_wdata),     // dma data for SAR_TOP (in)
  .dma_ready    (dma_ready),
  .dma_ack      (dma_ack), 
  .indma_data_i (dma_rdata)      // dma data for SAR_TOP (out)

);


endmodule
