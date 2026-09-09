//  ========================================================================
//  This is confidential and proprietary software
//  ------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name            : moon_top.v
//
//  First release        : 2003. 05. 28.  by jeonghe
//  Revision Information :
//
//  ========================================================================

module moon_top (

// Clock and reset
  clk_main,        // Main clock
  clk_usb,         // USB 2.0 clock
  clk_bus,         // USB 1.1 line clock
  rst_main,        // Main reset
  rst_usb,         // USB reset
  ext_utm,         // 1: use external UTM
  dbus16,          // 1: 16bytes mode
  big_endian,      // 1: big endian, 0: little endian
  scan_test,       // 1: scan test mode
  uclk_pre,        // Source of clk_bus
  intr_usb,        // USB interrupt
  intr_buffer,     // Buffer allocation request interrupt

// AHB for internal register
  hready_in,       // AHB ready in
  hwrite,          // AHB write
  htrans,          // AHB transfer type
  hsize,           // AHB data size
  haddr,           // AHB address
  hwdata,          // AHB write data

  hsel_usb,        // AHB select USB
  hready_outusb,   // AHB ready out USB
  hresp_usb,       // AHB response USB
  hrdata_usb,      // AHB read data USB

  hsel_dma,        // AHB select DMA
  hready_outdma,   // AHB ready out DMA
  hresp_dma,       // AHB response DMA
  hrdata_dma,      // AHB read data DMA

// AHB for DMA
  hgrant_mdma,     // AHB grant
  hmaster_mdma,    // AHB master
  hresp_mdma,      // AHB response (retry/error/split support)
  hready_mdma,     // AHB ready
  hrdata_mdma,     // AHB data for read
  hbusreq_mdma,    // AHB request
  htrans_mdma,     // AHB Transfer Type
  hburst_mdma,     // AHB Burst Type
  hsize_mdma,      // AHB HSIZE : word or byte
  hwrite_mdma,     // AHB Write control
  haddr_mdma,      // AHB address
  hwdata_mdma,     // AHB data for write
  HLOCK_DMA,       // AHB lock
  HPROT_DMA,       // AHB 

// USB
// For USB1.1
  rxdp,            // RX data plus
  rxdm,            // RX data minus
  rxd,             // RX data
  usbd_oe,         // USB data out enable
  txdp,            // TX data plus
  txdm,            // TX data minus

// For USB2.0
  rst_bus,         // USB bus reset
  line_state,      // Line state
  tx_valid,        // TX data valid
  txvalid_h,       // TX valid high
  tx_data,         // TX data
  tx_ready,        // TX data ready
  rx_active,       // RX data ready
  rx_valid,        // RX valid
  rxvalid_h,       // RX valid high
  rx_error,        // RX error
  rx_data,         // RX data
  psuspend,        // 0: Suspend USB
  xcvr_select,     // 0: High speed XCVR
  term_select,     // 0: High speed termination
  op_mode          // UTM operation mode

);

// Clock and reset
input          clk_main;
input          clk_usb;
input          clk_bus;
input          rst_main;
input          rst_usb;
input          ext_utm;
input          dbus16;
input          big_endian;
input          scan_test;
output         uclk_pre;
output         intr_usb;
output         intr_buffer;


// AHB for internal register
input          hready_in;
input          hwrite;
input   [1:0]  htrans;
input   [1:0]  hsize;
input  [23:0]  haddr;
input  [31:0]  hwdata;

input          hsel_usb;
output         hready_outusb;
output  [1:0]  hresp_usb;
output [31:0]  hrdata_usb;

input          hsel_dma;
output         hready_outdma;
output  [1:0]  hresp_dma;
output [31:0]  hrdata_dma;

// AHB for DMA
input          hgrant_mdma;
input   [2:0]  hmaster_mdma;
input          hready_mdma;
input   [1:0]  hresp_mdma;
input  [31:0]  hrdata_mdma;
output         hbusreq_mdma;
output  [1:0]  htrans_mdma;
output  [2:0]  hburst_mdma;
output  [1:0]  hsize_mdma;
output         hwrite_mdma;
output [31:0]  haddr_mdma;
output [31:0]  hwdata_mdma;
output         HLOCK_DMA;
output  [3:0]  HPROT_DMA;

// USB
input          rxdp;
input          rxdm;
input          rxd;
output         usbd_oe;
output         txdp;
output         txdm;

input   [1:0]  line_state;
input          rx_active;
input          rx_valid;
input          rxvalid_h;
input          rx_error;
input  [15:0]  rx_data;
input          tx_ready;
output         rst_bus;
output         tx_valid;
output         txvalid_h;
output [15:0]  tx_data;
output         psuspend;
output         xcvr_select;
output         term_select;
output  [1:0]  op_mode;

////////////////////////////////////////
// RDMA
////////////////////////////////////////
wire  [3:0]  desc_wack;
wire         desc_wdone;
wire         desc_wend;
wire  [5:2]  desc_waddr;
wire [31:0]  desc_wstptrA;
wire [31:0]  desc_wstptrB;
wire [31:0]  desc_wstptrC;
wire [31:0]  desc_wstptrD;
wire  [3:0]  desc_wreq;
wire  [3:0]  desc_wstpac;
wire  [3:0]  desc_wendpac;
wire  [3:0]  desc_wzero;
wire  [5:0]  desc_wlengthA = 6'h00;
wire  [5:0]  desc_wlengthB;
wire  [5:0]  desc_wlengthC = 6'h00;
wire  [5:0]  desc_wlengthD = 6'h00;
wire [31:0]  desc_wdataA = 32'h0000_0000;
wire [31:0]  desc_wdataB;
wire [31:0]  desc_wdataC = 32'h0000_0000;
wire [31:0]  desc_wdataD = 32'h0000_0000;

wire  [3:0]  desc_rack;
wire         desc_rwen;
wire         desc_rend;
wire  [3:0]  desc_rben;
wire  [5:2]  desc_raddr;
wire [31:0]  desc_rdata;
wire  [3:0]  desc_rreq;
wire  [3:0]  desc_rstpac;
wire  [3:0]  desc_rendpac;
wire  [5:0]  desc_rlengthA = 6'h00;
wire  [5:0]  desc_rlengthB;
wire  [5:0]  desc_rlengthC = 6'h00;
wire  [5:0]  desc_rlengthD = 6'h00;
wire [31:0]  desc_rstptrA = 32'h0000_0000;
wire [31:0]  desc_rstptrB;
wire [31:0]  desc_rstptrC = 32'h0000_0000;
wire [31:0]  desc_rstptrD = 32'h0000_0000;

///////////////////////////////////////////////////////////////////////////
// USB
///////////////////////////////////////////////////////////////////////////
wire         desc_wackB = desc_wack[1];
wire         desc_wreqB;
wire         desc_wstpacB;
wire         desc_wendpacB;
wire         desc_wzeroB;
wire         desc_rackB = desc_rack[1];

usb_top usb_top (
// Global control
  .clk_main      (clk_main),        // Main clock
  .clk_usb       (clk_usb),         // USB clock
  .clk_bus       (clk_bus),         // USB line clock
  .rst_main      (rst_main),        // Main reset
  .rst_usb       (rst_usb),         // USB reset
  .ext_utm       (ext_utm),         // 1: use external UTM
  .dbus16        (dbus16),          // 1: 16bytes mode
  .big_endian    (big_endian),      // 1: big-endian
  .scan_test     (scan_test),       // Scan test mode
  .uclk_pre      (uclk_pre),        // Source of clk_bus
  .intr_usb      (intr_usb),        // USB Interrupt

// AHB for internal register
  .hsel_ahb      (hsel_usb),        // AHB Select
  .hready_in     (hready_in),       // AHB READYin
  .hwrite        (hwrite),          // AHB Write
  .htrans        (htrans),          // AHB Transfer Type
  .hsize         (hsize),           // AHB Data Size
  .haddr         (haddr),           // AHB Address
  .hwdata        (hwdata),          // AHB Write Data
  .hready_out    (hready_outusb),   // AHB READYout
  .hresp         (hresp_usb),       // AHB Response
  .hrdata        (hrdata_usb),      // AHB Read Data

//PHY Interface
  .rxdp          (rxdp),            // RX data plus
  .rxdm          (rxdm),            // RX data minus
  .rxd           (rxd),             // RX data
  .usbd_oe       (usbd_oe),         // USB data out enable
  .txdp          (txdp),            // TX data plus
  .txdm          (txdm),            // TX data minus

  .prst_usb      (rst_bus),         // USB bus reset
  .line_state    (line_state),      // Line state
  .tx_valid      (tx_valid),        // TX data valid
  .txvalid_h     (txvalid_h),       // TX valid high
  .tx_data       (tx_data),         // TX data
  .tx_ready      (tx_ready),        // TX data ready
  .rx_active     (rx_active),       // RX data ready
  .rx_valid      (rx_valid),        // RX valid
  .rxvalid_h     (rxvalid_h),       // RX valid high
  .rx_error      (rx_error),        // RX error
  .rx_data       (rx_data),         // RX data
  .psuspend      (psuspend),        // 0: Suspend USB
  .xcvr_select   (xcvr_select),     // 0: High speed XCVR
  .term_select   (term_select),     // 0: High speed termination
  .op_mode       (op_mode),         // UTM operation mode

// RDMA Interface
  .desc_wack     (desc_wackB),      // RDMA Ack for desc_wreq
  .desc_wdone    (desc_wdone),      // RDMA data request
  .desc_wend     (desc_wend),       // RDMA end of a packet
  .desc_waddr    (desc_waddr),      // RDMA read address
  .desc_wstptr   (desc_wstptrB),    // RDMA descriptor start pointer
  .desc_wreq     (desc_wreqB),      // RDMA request of a packet
  .desc_wstpac   (desc_wstpacB),    // RDMA start part indicator of a packet
  .desc_wendpac  (desc_wendpacB),   // RDMA end part indicator of a packet
  .desc_wzero    (desc_wzeroB),     // RDMA zero bytes
  .desc_wlength  (desc_wlengthB),   // RDMA length
  .desc_wdata    (desc_wdataB),     // RDMA data

// TDMA Interface
  .desc_rack     (desc_rackB),      // TDMA ack for desc_rreq
  .desc_rend     (desc_rend),       // TDMA end
  .desc_rwen     (desc_rwen),       // TDMA write enable
  .desc_rben     (desc_rben),       // TDMA byte enable
  .desc_raddr    (desc_raddr),      // TDMA write address
  .desc_rdata    (desc_rdata),      // TDMA write data
  .desc_rreq     (desc_rreqB),      // TDMA request
  .desc_rstpac   (desc_rstpacB),    // TDMA start part indicator
  .desc_rendpac  (desc_rendpacB),   // TDMA end part indicator
  .desc_rlength  (desc_rlengthB),   // TDMA length
  .desc_rstptr   (desc_rstptrB)     // TDMA packet descriptor start pointer
);


///////////////////////////////////////////////////////////////////////////
// DMA master
///////////////////////////////////////////////////////////////////////////
assign       desc_wreq = {2'b00,desc_wreqB,1'b0};
assign       desc_wstpac = {2'b00,desc_wstpacB,1'b0};
assign       desc_wendpac = {2'b00,desc_wendpacB,1'b0};
assign       desc_wzero = {2'b00,desc_wzeroB,1'b0};
assign       desc_rreq = {2'b00,desc_rreqB,1'b0};
assign       desc_rstpac = {2'b00,desc_rstpacB,1'b0};
assign       desc_rendpac = {2'b00,desc_rendpacB,1'b0};

mdma mdma (
// Clock and reset
  .clk_main       (clk_main),       // Main clock
  .rst_main       (rst_main),       // Main reset
  .big_endian     (big_endian),     // 1: big-endian
  .scan_test      (scan_test),      // Scan test mode
  .intr_buffer    (intr_buffer),    // Buffer allocation request interrupt

// AHB for internal register
  .hsel_ahb       (hsel_dma),       // AHB Select
  .hready_in      (hready_in),      // AHB READYin
  .hwrite         (hwrite),         // AHB Write
  .htrans         (htrans),         // AHB Transfer Type
  .hsize          (hsize),          // AHB Data Size
  .haddr          (haddr),          // AHB Address
  .hwdata         (hwdata),         // AHB Write Data
  .hready_out     (hready_outdma),  // AHB READYout
  .hresp          (hresp_dma),      // AHB Response
  .hrdata         (hrdata_dma),     // AHB Read Data

// AHB for DMA
  .HGRANTdma      (hgrant_mdma),    // AHB grant
  .HMASTER        (hmaster_mdma),   // AHB master
  .HRESP          (hresp_mdma),     // AHB response (retry/error/split support)
  .HREADY         (hready_mdma),    // AHB ready
  .HRDATA         (hrdata_mdma),    // AHB data for read
  .HBUSREQdma     (hbusreq_mdma),   // AHB request
  .HTRANS         (htrans_mdma),    // AHB Transfer Type
  .HBURST         (hburst_mdma),    // AHB Burst Type
  .HSIZE          (hsize_mdma),     // AHB HSIZE : word or byte
  .HWRITE         (hwrite_mdma),    // AHB Write control
  .HADDR          (haddr_mdma),     // AHB address
  .HWDATA         (hwdata_mdma),    // AHB data for write

// RDMA sources interface
  .desc_wreq      (desc_wreq),      // RDMA request source
  .desc_wstpac    (desc_wstpac),    // RDMA start packet indicator source
  .desc_wendpac   (desc_wendpac),   // RDMA end packet indicator source
  .desc_wzero     (desc_wzero),     // RDMA end packet indicator source
  .desc_wlengthA  ({2'b00,desc_wlengthA}),  // RDMA length from port 0
  .desc_wlengthB  ({2'b00,desc_wlengthB}),  // RDMA length from port 1
  .desc_wlengthC  ({2'b00,desc_wlengthC}),  // RDMA length from port 2
  .desc_wlengthD  ({2'b00,desc_wlengthD}),  // RDMA length from port 3
  .desc_wdataA    (desc_wdataA),    // RDMA data from port 0
  .desc_wdataB    (desc_wdataB),    // RDMA data from port 1
  .desc_wdataC    (desc_wdataC),    // RDMA data from port 2
  .desc_wdataD    (desc_wdataD),    // RDMA data from port 3
  .desc_wack      (desc_wack),      // RDMA ack for desc_wreq
  .desc_wdone     (desc_wdone),     // RDMA data valid
  .desc_wend      (desc_wend),      // RDMA end
  .desc_waddr     (desc_waddr),     // RDMA read address
  .desc_wstptrA   (desc_wstptrA),   // RDMA descriptor start pointer for port 0
  .desc_wstptrB   (desc_wstptrB),   // RDMA descriptor start pointer for port 1
  .desc_wstptrC   (desc_wstptrC),   // RDMA descriptor start pointer for port 2
  .desc_wstptrD   (desc_wstptrD),   // RDMA descriptor start pointer for port 3

// TDMA sources interface
  .desc_rreq      (desc_rreq),      // TDMA request source
  .desc_rstpac    (desc_rstpac),    // TDMA start packet indicator source
  .desc_rendpac   (desc_rendpac),   // TDMA end packet indicator source
  .desc_rlengthA  ({2'b00,desc_rlengthA}),  // TDMA length for port 0
  .desc_rlengthB  ({2'b00,desc_rlengthB}),  // TDMA length for port 1
  .desc_rlengthC  ({2'b00,desc_rlengthC}),  // TDMA length for port 2
  .desc_rlengthD  ({2'b00,desc_rlengthD}),  // TDMA length for port 3
  .desc_rstptrA   (desc_rstptrA),   // TDMA packet length for port 0
  .desc_rstptrB   (desc_rstptrB),   // TDMA packet length for port 1
  .desc_rstptrC   (desc_rstptrC),   // TDMA packet length for port 2
  .desc_rstptrD   (desc_rstptrD),   // TDMA packet length for port 3
  .desc_rack      (desc_rack),      // TDMA ack for desc_rreq
  .desc_rdone     (desc_rwen),      // TDMA data valid
  .desc_rdmaend   (desc_rend),      // TDMA end
  .desc_rwben     (desc_rben),      // TDMA write byte enable
  .desc_raddr     (desc_raddr),     // TDMA write address
  .desc_rdata     (desc_rdata)      // TDMA data

);

wire HLOCK_DMA = 1'b0;
wire[3:0] HPROT_DMA = 4'h1;


endmodule
