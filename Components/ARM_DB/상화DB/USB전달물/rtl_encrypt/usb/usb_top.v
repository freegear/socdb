// ************************************************************************
// USB TOP module
//
// start: 2003. 05. 28
// by jeonghe
//
// USB AHB interface:           ureg_ahbif
// USB register decoder:        ureg_dec
// USB register read/write:     usb_reg
// USB SIE controller:          sie_ctrl
// USB RDMA controller:         urdma_ctrl
// USB TDMA controller:         utxpq_ctrl
// USB TDMA controller:         utdma_ctrl
// USB interrupt controller:    uintr_ctrl
// ************************************************************************


module usb_top (

///////////////////////////////////////////////
// Global control
///////////////////////////////////////////////
  clk_main,       // Main clock
  clk_usb,        // USB clock
  clk_bus,        // Bus clock
  rst_main,       // Main reset
  rst_usb,        // USB reset
  ext_utm,        // 1: use external UTM
  dbus16,         // 1: 16bytes mode
  big_endian,     // 1: big-endian
  scan_test,      // Scan test mode
  uclk_pre,       // Source of clk_bus
  intr_usb,       // USB interrupt

///////////////////////////////////////////////
// AHB for internal register
///////////////////////////////////////////////
  hsel_ahb,      // AHB Select
  hready_in,     // AHB READYin
  hwrite,        // AHB Write
  htrans,        // AHB Transfer Type
  hsize,         // AHB Data Size
  haddr,         // AHB Address
  hwdata,        // AHB Write Data
  hready_out,    // AHB READYout
  hresp,         // AHB Response
  hrdata,        // AHB Read Data

///////////////////////////////////////////////
// PAD (USB PHY)
///////////////////////////////////////////////
// For USB1.1
  rxdp,           // RX data plus
  rxdm,           // RX data minus
  rxd,            // RX data
  usbd_oe,        // USB data out enable
  txdp,           // TX data plus
  txdm,           // TX data minus

// For USB2.0
  prst_usb,       // USB bus reset
  line_state,     // Line state
  tx_valid,       // TX data valid
  txvalid_h,      // TX valid high
  tx_data,        // TX data
  tx_ready,       // TX data ready
  rx_active,      // RX data ready
  rx_valid,       // RX valid
  rxvalid_h,      // RX valid high
  rx_error,       // RX error
  rx_data,        // RX data
  psuspend,       // 0: Suspend USB
  xcvr_select,    // 0: High speed XCVR
  term_select,    // 0: High speed termination
  op_mode,        // UTM operation mode

///////////////////////////////////////////////
// RDMA control
///////////////////////////////////////////////
  desc_wack,      // RDMA Ack for desc_wreq
  desc_wdone,     // RDMA data request
  desc_wend,      // RDMA end of a packet
  desc_waddr,     // RDMA read address
  desc_wstptr,    // RDMA descriptor start pointer
  desc_wreq,      // RDMA request of a packet
  desc_wstpac,    // RDMA start part indicator of a packet
  desc_wendpac,   // RDMA end part indicator of a packet
  desc_wzero,     // RDMA zero length
  desc_wlength,   // RDMA length
  desc_wdata,     // RDMA data

///////////////////////////////////////////////
// TDMA control
///////////////////////////////////////////////
  desc_rack,      // TDMA ack for desc_rreq
  desc_rend,      // TDMA end
  desc_rwen,      // TDMA write enable
  desc_rben,      // TDMA byte enable
  desc_raddr,     // TDMA write address
  desc_rdata,     // TDMA write data
  desc_rreq,      // TDMA request
  desc_rstpac,    // TDMA start part indicator
  desc_rendpac,   // TDMA end part indicator
  desc_rlength,   // TDMA length
  desc_rstptr     // TDMA packet descriptor start pointer
);

///////////////////////////////////////////////
// Global control
///////////////////////////////////////////////
input         clk_main;
input         clk_usb;
input         clk_bus;
input         rst_main;
input         rst_usb;
input         ext_utm;
input         dbus16;
input         big_endian;
input         scan_test;
output        uclk_pre;
output        intr_usb;

///////////////////////////////////////////////
// AHB for internal register
///////////////////////////////////////////////
input          hsel_ahb;
input          hready_in;
input          hwrite;
input  [1:0]   htrans;
input  [1:0]   hsize;
input  [23:0]  haddr;
input  [31:0]  hwdata;
output         hready_out;
output [1:0]   hresp;
output [31:0]  hrdata;

///////////////////////////////////////////////
// PAD (USB PHY)
///////////////////////////////////////////////
// For USB1.1
input          rxdp;
input          rxdm;
input          rxd;
output         usbd_oe;
output         txdp;
output         txdm;

// For USB2.0
input   [1:0]  line_state;
input          rx_active;
input          rx_valid;
input          rxvalid_h;
input          rx_error;
input  [15:0]  rx_data;
input          tx_ready;
output         prst_usb;
output         tx_valid;
output         txvalid_h;
output [15:0]  tx_data;
output         psuspend;
output         xcvr_select;
output         term_select;
output  [1:0]  op_mode;

///////////////////////////////////////////////
// RDMA control
///////////////////////////////////////////////
input          desc_wack;
input          desc_wdone;
input          desc_wend;
input   [5:2]  desc_waddr;
input  [31:0]  desc_wstptr;
output         desc_wreq;
output         desc_wstpac;
output         desc_wendpac;
output         desc_wzero;
output  [5:0]  desc_wlength;
output [31:0]  desc_wdata;

///////////////////////////////////////////////
// TDMA control
///////////////////////////////////////////////
input          desc_rack;
input          desc_rend;
input          desc_rwen;
input   [3:0]  desc_rben;
input   [5:2]  desc_raddr;
input  [31:0]  desc_rdata;
output         desc_rreq;
output         desc_rstpac;
output         desc_rendpac;
output  [5:0]  desc_rlength;
output [31:0]  desc_rstptr;


////////////////////////////////////////////////////////////////////////
// Mux USB1.1 with USB2.0
////////////////////////////////////////////////////////////////////////
wire  [1:0]  line_state_1;
wire         rx_active_1;
wire         rx_error_1;
wire         rx_valid_1;
wire  [7:0]  rx_data_1;
wire         tx_ready_1;
wire  [1:0]  op_mode;
wire         bus_reset;
reg          yfd_bus_reset;
wire         rst_bus = rst_usb | bus_reset;

wire  [1:0]  pline_state = ext_utm ? line_state : line_state_1;
wire         prx_active = ext_utm ? rx_active : rx_active_1;
wire         prx_error = ext_utm ? rx_error : rx_error_1;
wire         trx_valid = ext_utm ? rx_valid : rx_valid_1;
wire         prxvalid_h = ext_utm ? rxvalid_h : 1'b0;
wire         prx_valid = prx_active & trx_valid;
wire [15:0]  prx_data = ext_utm ? rx_data : {8'h00,rx_data_1};
wire         ptx_ready = ext_utm ? tx_ready : tx_ready_1;
wire         pend_resume;


wire dsetup_ok;
wire dnext_data;
wire daccept;

wire pmsetup_ok;
wire pmnext_data;
wire pmaccept;
wire pe0_next;
wire pe1_next;
wire pe2_next;
wire pe0_accept;
wire pe3_accept;

////////////////////////////////////////////////////////////////////////
// AHB interface of internal register
////////////////////////////////////////////////////////////////////////
wire         mem_ack;
wire [31:0]  mem_rd_data;
wire         mem_wreq;
wire         mem_rreq;
wire [3:0]   mem_ben;
wire [23:0]  mem_addr;
wire [31:0]  mem_wr_data;

ureg_ahbif ureg_ahbif (
// Clock and reset
  .clk_main     (clk_main),         // Main clock
  .rst_main     (rst_main),         // Main reset
  .big_endian   (big_endian),       // 1: big endian

// AHB
  .HSELAHBGTX   (hsel_ahb),         // AHB Select
  .HREADYIn     (hready_in),        // AHB READYin
  .HWRITE       (hwrite),           // AHB Write
  .HTRANS       (htrans),           // AHB Transfer Type
  .HSIZE        (hsize),            // AHB Data Size
  .HADDR        (haddr),            // AHB Address
  .HWDATA       (hwdata),           // AHB Write Data
  .HREADYOut    (hready_out),       // AHB READYout
  .HRESP        (hresp),            // AHB Response
  .HRDATA       (hrdata),           // AHB Read Data

// Internal bus
  .mem_ack      (mem_ack),
  .mem_rd_data  (mem_rd_data),
  .mem_wreq     (mem_wreq),
  .mem_rreq     (mem_rreq),
  .mem_ben      (mem_ben),
  .mem_addr     (mem_addr),
  .mem_wr_data  (mem_wr_data)
);


////////////////////////////////////////////////////////////////////////
// USB REGISTER decoder
////////////////////////////////////////////////////////////////////////
wire         umff_wreq,umff_rreq,umff_wack,umff_rack;
wire         smff_wreq,smff_rreq,smff_wack,smff_rack;
wire [31:0]  rdata2_uff;
wire [31:0]  rdata_usff;
wire [31:0]  rout0,rout1,rout2;
wire         wr_cfg,rd_cfg;
wire         wr_txpkt_que,rd_txpkt_que;
wire         wr_txpkt_sptr,rd_txpkt_sptr;
wire         wr_txpkt_len,rd_txpkt_len;
wire         wr_intr_en,rd_intr_en;
wire         wr_intr_mask,rd_intr_mask;
wire         wr_intr_src,rd_intr_src;
wire         rd_setup_lword;
wire         rd_setup_hword;
wire         wr_e0_status,rd_e0_status;
wire         wr_e1_status,rd_e1_status;
wire         wr_e2_status,rd_e2_status;
wire         wr_e3_status,rd_e3_status;
wire         rd_dev_d0,rd_dev_d1,rd_dev_d2,rd_dev_d3,rd_dev_d4;
wire         rd_dev_q0,rd_dev_q1,rd_dev_q2;
wire         rd_cfg_d0,rd_cfg_d1,rd_cfg_d2;
wire         rd_oscfg_d0,rd_oscfg_d1,rd_oscfg_d2;
wire         rd_intf_d0,rd_intf_d1,rd_intf_d2;
wire         rd_endp1_d0,rd_endp1_d1;
wire         rd_endp2_d0,rd_endp2_d1;
wire         rd_endp3_d0,rd_endp3_d1;

ureg_dec ureg_dec (
  .clk_main         (clk_main),       // Main clock
  .scan_test        (scan_test),      // 1: Scan test mode

  .mem_rreq         (mem_rreq),       // MCU read request
  .mem_wreq         (mem_wreq),       // MCU write request
  .mem_addr         (mem_addr[23:2]), // Address for mcu_wreq or mcu_rreq
  .mem_ack          (mem_ack),        // Ack for mem_wreq or mem_rreq
  .mem_rd_data      (mem_rd_data),    // MCU read data out

  .mff_wack         (umff_wack),      // MCU FIFO write Ack.
  .mff_rack         (umff_rack),      // MCU FIFO read Ack.
  .rdata_uff        (rdata2_uff),     // MCU FIFO read data
  .mff_wreq         (umff_wreq),      // MCU FIFO write request
  .mff_rreq         (umff_rreq),      // MCU FIFO read request
  .smff_wack        (smff_wack),      // MCU status FIFO write Ack.
  .smff_rack        (smff_rack),      // MCU status FIFO read Ack.
  .rdata_sff        (rdata_usff),     // MCU status FIFO read data
  .smff_wreq        (smff_wreq),      // MCU status FIFO write request
  .smff_rreq        (smff_rreq),      // MCU status FIFO read request

  .rout0            (rout0),          // Register read data, 000 ~ 03f
  .rout1            (rout1),          // Register read data, 040 ~ 07f
  .rout2            (rout2),          // Register read data, 080 ~ 0bf
  .wr_cfg           (wr_cfg),         // Write request, 000
  .wr_e0_status     (wr_e0_status),   // Write request, 004
  .wr_e1_status     (wr_e1_status),   // Write request, 008
  .wr_e2_status     (wr_e2_status),   // Write request, 00c
  .wr_e3_status     (wr_e3_status),   // Write request, 010
  .wr_txpkt_que     (wr_txpkt_que),   // Write request, 014
  .wr_txpkt_sptr    (wr_txpkt_sptr),  // Write request, 018
  .wr_txpkt_len     (wr_txpkt_len),   // Write request, 01c
  .wr_intr_en       (wr_intr_en),     // Write request, 020
  .wr_intr_mask     (wr_intr_mask),   // Write request, 024
  .wr_intr_src      (wr_intr_src),    // Write request, 028
  .rd_cfg           (rd_cfg),         // Read request, 000
  .rd_e0_status     (rd_e0_status),   // Read request, 004
  .rd_e1_status     (rd_e1_status),   // Read request, 008
  .rd_e2_status     (rd_e2_status),   // Read request, 00c
  .rd_e3_status     (rd_e3_status),   // Read request, 010
  .rd_txpkt_que     (rd_txpkt_que),   // Read request, 014
  .rd_txpkt_sptr    (rd_txpkt_sptr),  // Read request, 018
  .rd_txpkt_len     (rd_txpkt_len),   // Read request, 01c
  .rd_intr_en       (rd_intr_en),     // Read request, 020
  .rd_intr_mask     (rd_intr_mask),   // Read request, 024
  .rd_intr_src      (rd_intr_src),    // Read request, 028
  .rd_setup_lword   (rd_setup_lword), // Read request, 02c
  .rd_setup_hword   (rd_setup_hword), // Read request, 030
  .rd_dev_d0        (rd_dev_d0),      // Read request, 040
  .rd_dev_d1        (rd_dev_d1),      // Read request, 044
  .rd_dev_d2        (rd_dev_d2),      // Read request, 048
  .rd_dev_d3        (rd_dev_d3),      // Read request, 04c
  .rd_dev_d4        (rd_dev_d4),      // Read request, 050
  .rd_dev_q0        (rd_dev_q0),      // Read request, 054
  .rd_dev_q1        (rd_dev_q1),      // Read request, 058
  .rd_dev_q2        (rd_dev_q2),      // Read request, 05c
  .rd_cfg_d0        (rd_cfg_d0),      // Read request, 060
  .rd_cfg_d1        (rd_cfg_d1),      // Read request, 064
  .rd_cfg_d2        (rd_cfg_d2),      // Read request, 068
  .rd_oscfg_d0      (rd_oscfg_d0),    // Read request, 06c
  .rd_oscfg_d1      (rd_oscfg_d1),    // Read request, 070
  .rd_oscfg_d2      (rd_oscfg_d2),    // Read request, 074
  .rd_intf_d0       (rd_intf_d0),     // Read request, 078
  .rd_intf_d1       (rd_intf_d1),     // Read request, 07c
  .rd_intf_d2       (rd_intf_d2),     // Read request, 080
  .rd_endp1_d0      (rd_endp1_d0),    // Read request, 084
  .rd_endp1_d1      (rd_endp1_d1),    // Read request, 088
  .rd_endp2_d0      (rd_endp2_d0),    // Read request, 08c
  .rd_endp2_d1      (rd_endp2_d1),    // Read request, 090
  .rd_endp3_d0      (rd_endp3_d0),    // Read request, 094
  .rd_endp3_d1      (rd_endp3_d1)     // Read request, 098
);


////////////////////////////////////////////////////////////////////////
// USB REGISTERs
////////////////////////////////////////////////////////////////////////
reg          yfd_set_addr;
wire  [3:0]  endp;
wire  [3:0]  gdesc_type;
wire  [3:0]  d_wcnt = 4'h0;
wire [10:0]  dtxpkt_len;
wire [15:0]  w_index;
wire [15:0]  w_value;
wire [15:0]  w_length;
wire         hspeed_mode;
wire         self_power;
wire         remote_wu;
wire         zerolen_send;
wire  [6:0]  device_addr;
wire [31:0]  pdesc_wdata;

usb_reg usb_reg (
  .clk_main         (clk_main),        // Main clock
  .rst_main         (rst_main),        // Reset sync. in clk_main

  .bus_reset        (yfd_bus_reset),   // Bus reset
  .hspeed_mode      (hspeed_mode),     // 1: High-speed mode
  .set_addr         (yfd_set_addr),    // Setup command, SET_ADDR
  .gdesc_type       (gdesc_type),      // w_value[11:8] for get_descriptor
  .d_wcnt           (d_wcnt),          // Descriptor write counter
  .dtxpkt_len       (dtxpkt_len),      // TX length of the current packet
  .w_value          (w_value[6:0]),    // Setup command, wValue
  .self_power       (self_power),      // 1: Self-powered
  .remote_wu        (remote_wu),       // 1: Remote wake-up ability
  .zerolen_send     (zerolen_send),    // In no data, zero length packet send
  .device_addr      (device_addr),     // Device address
  .pdesc_wdata      (pdesc_wdata),     // Descriptor write data

  .wr_cfg           (wr_cfg),          // Write request, 000
  .rd_cfg           (rd_cfg),          // Read request, 000
  .rd_dev_d0        (rd_dev_d0),       // Read request, 040
  .rd_dev_d1        (rd_dev_d1),       // Read request, 044
  .rd_dev_d2        (rd_dev_d2),       // Read request, 048
  .rd_dev_d3        (rd_dev_d3),       // Read request, 04c
  .rd_dev_d4        (rd_dev_d4),       // Read request, 050
  .rd_dev_q0        (rd_dev_q0),       // Read request, 054
  .rd_dev_q1        (rd_dev_q1),       // Read request, 058
  .rd_dev_q2        (rd_dev_q2),       // Read request, 05c
  .rd_cfg_d0        (rd_cfg_d0),       // Read request, 060
  .rd_cfg_d1        (rd_cfg_d1),       // Read request, 064
  .rd_cfg_d2        (rd_cfg_d2),       // Read request, 068
  .rd_oscfg_d0      (rd_oscfg_d0),     // Read request, 06c
  .rd_oscfg_d1      (rd_oscfg_d1),     // Read request, 070
  .rd_oscfg_d2      (rd_oscfg_d2),     // Read request, 074
  .rd_intf_d0       (rd_intf_d0),      // Read request, 078
  .rd_intf_d1       (rd_intf_d1),      // Read request, 07c
  .rd_intf_d2       (rd_intf_d2),      // Read request, 080
  .rd_endp1_d0      (rd_endp1_d0),     // Read request, 084
  .rd_endp1_d1      (rd_endp1_d1),     // Read request, 088
  .rd_endp2_d0      (rd_endp2_d0),     // Read request, 08c
  .rd_endp2_d1      (rd_endp2_d1),     // Read request, 090
  .rd_endp3_d0      (rd_endp3_d0),     // Read request, 094
  .rd_endp3_d1      (rd_endp3_d1),     // Read request, 098
  .mem_ben          (mem_ben),         // Register write byte enable
  .mem_wr_data      (mem_wr_data),     // Register write data
  .rout0            (rout0),           // Register read data, 000 ~ 03f
  .rout1            (rout1),           // Register read data, 040 ~ 07f
  .rout2            (rout2)            // Register read data, 080 ~ 0bf
);


////////////////////////////////////////////////////////////////////////
// USB Tranceiver Module (USB1.1)
////////////////////////////////////////////////////////////////////////
tranceiver tranceiver (
// USB PAD
  .rxdp            (rxdp),           // RX data plus
  .rxdm            (rxdm),           // RX data minus
  .rxd             (rxd),            // RX data
  .usbd_oe         (usbd_oe),        // USB data out enable
  .txdp            (txdp),           // TX data plus
  .txdm            (txdm),           // TX data minus

// Global control
  .clk_usb         (clk_usb),        // USB clock
  .clk_bus         (clk_bus),        // Bus clock
  .rst_bus         (rst_bus),        // USB reset
  .uclk_pre        (uclk_pre),       // Bus clock source
  .pend_resume     (pend_resume),    // Resume

// UTMI
  .line_state      (line_state_1),     // Line state
  .tx_valid        (tx_valid),         // TX data valid
  .tx_data         (tx_data[7:0]),     // TX data
  .tx_ready        (tx_ready_1),       // TX data ready
  .rx_active       (rx_active_1),      // RX data ready
  .rx_valid        (rx_valid_1),       // RX valid
  .rx_error        (rx_error_1),       // RX error
  .rx_data         (rx_data_1)         // RX data
);


////////////////////////////////////////////////////////////////////////
// USB SIE controller
////////////////////////////////////////////////////////////////////////
wire         e0_halt,e1_halt,e2_halt,e3_halt;
wire         e0_valid,e1_valid,e2_valid,e3_valid;
wire         e0_full,e3_full;
wire         e0_wtoggle;
wire         e0_rtoggle;
wire         e2_rtoggle;
wire         e3_wtoggle;
wire         configured;
wire         pget_descriptor;
wire         pset_descriptor;
wire         pget_status;
wire         pget_conf;
wire         dset_addr;
wire         pin_device;
wire         pin_intf;
wire         dwr_finish;
wire  [3:0]  endp_seqbit;
wire         e3_seqbit = endp_seqbit[3];
wire         e2_seqbit = endp_seqbit[2];
wire         e1_seqbit = endp_seqbit[1];
wire         e0_seqbit = endp_seqbit[0];
wire  [3:0]  endp_halt = {e3_halt,e2_halt,e1_halt,e0_halt};
wire  [3:0]  endp_valid = {e3_valid,e2_valid,e1_valid,e0_valid};
wire  [3:0]  endp_full = {e3_full,1'b0,1'b0,e0_full};
reg   [3:0]  yfd_endp_halt;
reg   [3:0]  yfd_endp_valid;
reg   [3:0]  yfd_endp_full;
wire  [6:0]  pe0_txlen;
wire  [6:0]  pe1_txlen;
wire  [9:0]  pe2_txlen;
wire  [1:0]  device_flag;
wire  [3:0]  uptl_state;
wire  [4:0]  device_state;
wire  [9:0]  rx_bcnt;
wire [31:0]  rdata1_uff;
wire [31:0]  bwen1_uff;
wire [11:2]  addr1_uff;
wire [31:0]  wdata1_uff;

sie_ctrl sie_ctrl (
  .clk_usb        (clk_usb),       // USB clock
  .rst_usb        (rst_usb),       // USB reset
  .ext_utm        (ext_utm),       // 1: External UTM
  .dbus16         (dbus16),        // 1: 16bytes mode
  .device_addr    (device_addr),   // Device address

  .line_state     (pline_state),   // 0: SE0, 1: 'J', 2: 'K', 3: SE1
  .rx_active      (prx_active),    // USB line is active
  .rx_valid       (prx_valid),     // RX data is valid
  .rxvalid_h      (prxvalid_h),    // RX valid high
  .rx_error       (prx_error),     // RX coding error
  .rx_data        (prx_data),      // RX data
  .tx_ready       (ptx_ready),     // TX data is ready
  .tx_valid       (tx_valid),      // TX data is available
  .txvalid_h      (txvalid_h),     // TX valid high
  .tx_data        (tx_data),       // TX data
  .psuspend       (psuspend),      // 0: Suspend USB
  .xcvr_select    (xcvr_select),   // 0: High speed XCVR
  .term_select    (term_select),   // 0: High speed termination
  .op_mode        (op_mode),       // UTM operation mode

  .remote_wu      (remote_wu),     // Remote wake-up
  .self_power     (self_power),    // 1: Self-powered
  .dwr_finish     (dwr_finish),    // Write finish
  .e0_wtoggle     (e0_wtoggle),    // Endpoint0 high write address
  .e0_rtoggle     (e0_rtoggle),    // Endpoint0 high read address
  .e2_rtoggle     (e2_rtoggle),    // Endpoint2 high read address
  .e3_wtoggle     (e3_wtoggle),    // Endpoint3 high write address
  .endp_halt      (yfd_endp_halt), // {e3_halt,e2_halt,e1_halt,e0_halt}
  .endp_full      (yfd_endp_full), // {e3_full,e2_full,e2_full,e0_full}
  .endp_valid     (yfd_endp_valid),// {e3_valid,e2_valid,e1_valid,e0_valid}
  .pe0_txlen      (pe0_txlen),     // Endpoint0 TX length
  .pe1_txlen      (pe1_txlen),     // Endpoint1 TX length
  .pe2_txlen      (pe2_txlen),     // Endpoint2 TX length
  .hspeed_mode    (hspeed_mode),   // 1: high speed mode
  .bus_reset      (bus_reset),     // BUS reset
  .configured     (configured),    // Configured state
  .pend_resume    (pend_resume),   // End resume
  .dsetup_ok      (dsetup_ok),     // Received a setup command
  .dnext_data     (dnext_data),    // Sent a data
  .daccept        (daccept),       // Received a data
  .pget_descriptor(pget_descriptor),// Get descriptor
  .pset_descriptor(pset_descriptor),// Set descriptor
  .pget_status    (pget_status),   // Get status
  .pget_conf      (pget_conf),     // Get configuration
  .dset_addr      (dset_addr),     // Set address
  .pin_device     (pin_device),    // bmRequestType == 8'h80
  .pin_intf       (pin_intf),      // bmRequestType == 8'h80
  .gdesc_device   (gdesc_device),  // Get_descriptor for device
  .gdesc_config   (gdesc_config),  // Get_descriptor for configuration
  .gdesc_qlfier   (gdesc_qlfier),  // Get_descriptor for device qualifier
  .gdesc_osconf   (gdesc_osconf),  // Get_descriptor for other speed config
  .sdesc_device   (sdesc_device),  // Set_descriptor for device
  .sdesc_config   (sdesc_config),  // Set_descriptor for configuration
  .endp           (endp),          // Current endpoint
  .endp_seqbit    (endp_seqbit),   // {e3_seq,e2_seq,e1_seq,e0_seq}
  .device_flag    (device_flag),   // 0:Powered, 1:Default, 2:Addr, 3:Config
  .gdesc_type     (gdesc_type),    // Type for get_descriptor
  .uptl_state     (uptl_state),    // USB protocol state
  .device_state   (device_state),  // Device state
  .rx_bcnt        (rx_bcnt),       // RX byte counter
  .w_index        (w_index),       // wIndex in setup command
  .w_value        (w_value),       // wValue in setup command
  .w_length       (w_length),      // wLength in setup command

  .rd_setup_lword (rd_setup_lword),// Read request, 02c
  .rd_setup_hword (rd_setup_hword),// Read request, 030
  .rout0          (rout0),         // Register read data, 000 ~ 03f

  .rdata1_uff     (rdata1_uff),    // Data #1 for read
  .csn1_uff       (csn1_uff),      // Chip select #1, active low
  .wen1_uff       (wen1_uff),      // Write enable #1, active low
  .oen1_uff       (oen1_uff),      // Out enable #1, active low
  .bwen1_uff      (bwen1_uff),     // Bit write enable #1, active low
  .addr1_uff      (addr1_uff),     // Address #1 for read/write
  .wdata1_uff     (wdata1_uff)     // Data #1 for write
);


////////////////////////////////////////////////////////////////////////
// USB RDMA controller (Endpoint3)
////////////////////////////////////////////////////////////////////////
wire         reofi_full;
wire         prdma_end;
wire         prx_rreq;
wire  [9:2]  prx_raddr;
wire [31:0]  rf_status;

urdma_ctrl urdma_ctrl (
  .clk_main         (clk_main),       // Main clock
  .rst_main         (rst_main),       // Main reset

  .reofi_full       (reofi_full),     // RX EOF interrupt queue full
  .hspeed_mode      (hspeed_mode),    // 1: High speed mode
  .e3_seqbit        (e3_seqbit),      // Endpoint3 sequence bit
  .pe3_accept       (pe3_accept),     // Endpoint3 received a data
  .rx_bcnt          (rx_bcnt),        // RX byte counter
  .rdata_rff        (rdata2_uff),     // USB fifo read data
  .e3_halt          (e3_halt),        // Endpoint3 halt
  .e3_full          (e3_full),        // Endpoint3 full
  .e3_valid         (e3_valid),       // Endpoint3 valid
  .e3_wtoggle       (e3_wtoggle),     // Endpoint3 write high address
  .prdma_end        (prdma_end),      // RDMA end of a packet
  .prx_rreq         (prx_rreq),       // RX fifo read request
  .prx_raddr        (prx_raddr),      // RX fifo read high address
  .rf_status        (rf_status),      // RX frame status

  .desc_wack        (desc_wack),      // RDMA Ack for desc_wreq
  .desc_wdone       (desc_wdone),     // RDMA data request
  .desc_wend        (desc_wend),      // RDMA end of a packet
  .desc_waddr       (desc_waddr),     // RDMA read address
  .desc_wreq        (desc_wreq),      // RDMA request of a packet
  .desc_wstpac      (desc_wstpac),    // RDMA start part indicator of a packet
  .desc_wendpac     (desc_wendpac),   // RDMA end part indicator of a packet
  .desc_wzero       (desc_wzero),     // RDMA zero length
  .desc_wlength     (desc_wlength),   // RDMA length
  .desc_wdata       (desc_wdata),     // RDMA data

  .wr_e3_status     (wr_e3_status),   // Write request, 010
  .rd_e3_status     (rd_e3_status),   // Read request, 010
  .mem_ben          (mem_ben),        // Register write byte enable
  .mem_wr_data      (mem_wr_data),    // Register write data
  .rout0            (rout0)           // Register read data, 000 ~ 03f
);


////////////////////////////////////////////////////////////////////////
// USB endpoint0 read / write
////////////////////////////////////////////////////////////////////////
wire  [3:0]  e0_rwcnt;
wire [31:0]  e0_wdata;
wire  [1:0]  pendp_index;

e0rw_ctrl e0rw_ctrl (
  .clk_main         (clk_main),          // USB clock
  .rst_main         (rst_main),          // Main reset

  .remote_wu        (remote_wu),         // 1: Remote wake-up enable
  .self_power       (self_power),        // 1: Self-powered
  .configured       (configured),        // Configured state
  .pe0_accept       (pe0_accept),        // Endpoint0 received a data
  .pmsetup_ok       (pmsetup_ok),        // Successful setup command
  .pe0_next         (pe0_next),          // Endpoint0 sent a data
  .pget_descriptor  (pget_descriptor),   // Get descriptor
  .pset_descriptor  (pset_descriptor),   // Set descriptor
  .pget_status      (pget_status),       // Get status
  .pget_conf        (pget_conf),         // Get configuration
  .pin_device       (pin_device),        // bmRequestType == 8'h80
  .pin_intf         (pin_intf),          // bmRequestType == 8'h80
  .pendp_index      (w_index[1:0]),      // Endpoint index
  .e0_seqbit        (e0_seqbit),         // Endpoint0 sequence bit
  .endp_halt        (endp_halt),         // {e3_halt,e2_halt,e1_halt,e0_halt}
  .rx_bcnt          (rx_bcnt),           // RX byte counter
  .w_value          (w_value),           // wValue in setup command
  .w_length         (w_length),          // wLength in setup command
  .desc_rdata       (rdata_usff),        // Descriptor read data
  .dwr_finish       (dwr_finish),        // Write finish
  .e0_halt          (e0_halt),           // Endpoint0 halt
  .e0_valid         (e0_valid),          // Endpoint0 valid
  .e0_full          (e0_full),           // Endpoint0 full
  .pe0_read         (pe0_read),          // Endpoint0 read request
  .pe0_write        (pe0_write),         // Endpoint0 write request
  .e0_wtoggle       (e0_wtoggle),        // Endpoint0 high write address
  .e0_rtoggle       (e0_rtoggle),        // Endpoint0 high read address
  .e0_rwcnt         (e0_rwcnt),          // Endpoint0 read/write counter
  .pe0_txlen        (pe0_txlen),         // Endpoint0 TX length
  .e0_wdata         (e0_wdata),          // Endpoint0 write data

  .wr_e0_status     (wr_e0_status),      // Write request, 004
  .rd_e0_status     (rd_e0_status),      // Read request, 004
  .mem_ben          (mem_ben),           // Register write byte enable
  .mem_wr_data      (mem_wr_data),       // Register write data
  .rout0            (rout0)              // Register read data, 000 ~ 03f
);

////////////////////////////////////////////////////////////////////////
// USB TX packet queue controller
////////////////////////////////////////////////////////////////////////
wire         ptdma_sreq;
wire         ptdma_sack;
wire         txpq_wack;
wire         txpq_rack;
wire         txpq_wreq;
wire         txpq_rreq;
wire  [7:2]  txpq_addr;
wire [31:0]  txpq_wdata;

utxpq_ctrl utxpq_ctrl (
  .clk_main       (clk_main),        // Main clock
  .rst_main       (rst_main),        // Main reset

  .ptdma_sreq     (ptdma_sreq),      // TDMA start request
  .ptdma_sack     (ptdma_sack),      // TDMA start ack.
  .dtxpkt_len     (dtxpkt_len),      // TX length of the current packet
  .dtxpkt_sptr    (desc_rstptr),     // TX start pointer of the current packet

  .txpq_wack      (txpq_wack),       // TX packet queue write ack
  .txpq_rack      (txpq_rack),       // TX packet queue read ack
  .rdata_txpq     (rdata_usff),      // TX packet queue read data
  .txpq_wreq      (txpq_wreq),       // TX packet queue write request
  .txpq_rreq      (txpq_rreq),       // TX packet queue read request
  .txpq_addr      (txpq_addr),       // TX packet queue write/read address
  .txpq_wdata     (txpq_wdata),      // TX packet queue write data

  .e1_seqbit      (e1_seqbit),       // Endpoint1 sequence bit
  .e1_valid       (e1_valid),        // Endpoint1 valid
  .e1_halt        (e1_halt),         // Endpoint1 halt
  .pe1_txlen      (pe1_txlen),       // Endpoint1 data length

  .wr_e1_status   (wr_e1_status),    // Write request, 008
  .wr_txpkt_que   (wr_txpkt_que),    // Write request, 014
  .wr_txpkt_sptr  (wr_txpkt_sptr),   // Write request, 018
  .wr_txpkt_len   (wr_txpkt_len),    // Write request, 01c
  .rd_e1_status   (rd_e1_status),    // Read request, 008
  .rd_txpkt_que   (rd_txpkt_que),    // Read request, 014
  .rd_txpkt_sptr  (rd_txpkt_sptr),   // Read request, 018
  .rd_txpkt_len   (rd_txpkt_len),    // Read request, 01c
  .mem_ben        (mem_ben),         // Register write data
  .mem_wr_data    (mem_wr_data),     // Register write data
  .rout0          (rout0)            // Register Read data, 000 ~ 03f
);


////////////////////////////////////////////////////////////////////////
// USB TDMA controller(Endpoint2)
////////////////////////////////////////////////////////////////////////
wire         ptx_wreq;
wire  [9:6]  ptx_whaddr;
wire         teofi_full;
wire [10:0]  ptdma_status;

utdma_ctrl utdma_ctrl (
  .clk_main       (clk_main),        // Main clock
  .rst_main       (rst_main),        // Main reset

  .ptdma_sack     (ptdma_sack),      // TDMA start ack.
  .dtxpkt_len     (dtxpkt_len),      // TX length of the current packet
  .ptdma_sreq     (ptdma_sreq),      // TDMA start request

  .hspeed_mode    (hspeed_mode),     // 1: High speed mode
  .zerolen_send   (zerolen_send),    // In no data, zero length packet send
  .e2_seqbit      (e2_seqbit),       // Endpoint2 sequence bit
  .teofi_full     (teofi_full),      // TX EOF interrupt queue full
  .pe2_next       (pe2_next),        // Sent a data
  .endp           (endp),            // Current endpoint
  .ptxd_pend      (ptxd_pend),       // TX packet end
  .e2_halt        (e2_halt),         // Endpoint2 halt
  .e2_valid       (e2_valid),        // Endpoint2 valid
  .e2_rtoggle     (e2_rtoggle),      // Endpoint2 read high address
  .ptx_wreq       (ptx_wreq),        // TX FIFO write request
  .ptx_whaddr     (ptx_whaddr),      // TX FIFO write adddress
  .pe2_txlen      (pe2_txlen),       // TX length
  .ptdma_status   (ptdma_status),    // TDMA status

  .desc_rack      (desc_rack),       // TDMA ack for desc_rreq
  .desc_rdone     (desc_rwen),       // TDMA data valid
  .desc_rend      (desc_rend),       // TDMA end
  .desc_rreq      (desc_rreq),       // TDMA request
  .desc_rstpac    (desc_rstpac),     // TDMA start part indicator
  .desc_rendpac   (desc_rendpac),    // TDMA end part indicator
  .desc_rlength   (desc_rlength),    // TDMA length

  .wr_e2_status   (wr_e2_status),    // Write request, 00c
  .rd_e2_status   (rd_e2_status),    // Read request, 00c
  .mem_ben        (mem_ben),         // Register write data
  .mem_wr_data    (mem_wr_data),     // Register write data
  .rout0          (rout0)            // Register Read data, 000 ~ 03f
);

////////////////////////////////////////////////////////////////////////
// USB FIFO port2 read/write controller
////////////////////////////////////////////////////////////////////////
wire  [9:2] ptx_waddr = {ptx_whaddr,desc_raddr};
wire [31:0] bwen2_uff;
wire [11:2] addr2_uff;
wire [31:0] wdata2_uff;

ufifo_port2 ufifo_port2 (
  .clk_main     (clk_main),       // Main clock
  .rst_main     (rst_main),       // Main reset

  .pe0_write    (pe0_write),      // Endpoint0 write request
  .pe0_read     (pe0_read),       // Endpoint0 read request
  .e0_wtoggle   (e0_wtoggle),     // Endpoint0 high write address
  .e0_rtoggle   (e0_rtoggle),     // Endpoint0 high read address
  .e0_rwcnt     (e0_rwcnt),       // Endpoint0 read/write counter
  .e0_wdata     (e0_wdata),       // Endpoint0 write data
  .ptx_wreq     (ptx_wreq),       // TX FIFO write request
  .ptx_waddr    (ptx_waddr),      // TX FIFO write adddress
  .ptx_wdata    (desc_rdata),     // TX FIFO write data
  .prx_rreq     (prx_rreq),       // RX fifo read request
  .prx_raddr    (prx_raddr),      // RX fifo read high address

  .mff_wreq     (umff_wreq),      // MCU FIFO write request
  .mff_rreq     (umff_rreq),      // MCU FIFO read request
  .mem_ben      (mem_ben),        // MCU FIFO Write byte enable
  .mem_addr     (mem_addr[11:2]), // MCU FIFO read/write address
  .mem_wr_data  (mem_wr_data),    // MCU FIFO write data
  .mff_wack     (umff_wack),      // MCU FIFO write Ack.
  .mff_rack     (umff_rack),      // MCU FIFO read Ack.

  .csn2_uff     (csn2_uff),       // Chip select #2, active low
  .wen2_uff     (wen2_uff),       // Write enable #2, active low
  .oen2_uff     (oen2_uff),       // Out enable #2, active low
  .bwen2_uff    (bwen2_uff),      // Bit write enable #2, active low
  .addr2_uff    (addr2_uff),      // Address #2 for read/write
  .wdata2_uff   (wdata2_uff)      // Data #2 for write
);


////////////////////////////////////////////////////////////////////////
// USB frame status FIFO read / write
////////////////////////////////////////////////////////////////////////
wire         reofi_wreq;
wire  [3:0]  reofi_wid;
wire [31:0]  reofi_wdata;
wire         reofi_wack;
wire         reofi_wcnt;
wire         teofi_wreq;
wire  [3:0]  teofi_wid;
wire [31:0]  teofi_wdata;
wire         teofi_wack;
wire         teofi_wcnt;
wire         csn_usff;
wire         wen_usff;
wire         oen_usff;
wire [31:0]  bwen_usff;
wire  [9:2]  addr_usff;
wire [31:0]  wdata_usff;

ufinfo_rw ufinfo_rw (
  .clk_main     (clk_main),      // Main clock
  .rst_main     (rst_main),      // Main reset
  .big_endian   (big_endian),    // 1: big-endian

  .gdesc_device (gdesc_device),  // Get_descriptor for device
  .gdesc_qlfier (gdesc_qlfier),  // Get_descriptor for device qualifier
  .gdesc_osconf (gdesc_osconf),  // Get_descriptor for other speed config
  .sdesc_config (sdesc_config),  // Set_descriptor for configuration
  .pe0_write    (pe0_write),     // Endpoint0 write request
  .pe0_read     (pe0_read),      // Endpoint0 read request
  .e0_rwcnt     (e0_rwcnt),      // Endpoint0 read/write counter
  .e0_rdata     (rdata2_uff),    // Endpoint0 read data

  .reofi_wreq   (reofi_wreq),    // RX EOF write request
  .reofi_wid    (reofi_wid),     // RX EOF write index
  .reofi_wdata  (reofi_wdata),   // RX EOF interrupt write data
  .reofi_wack   (reofi_wack),    // Ack. for reofi_wreq
  .reofi_wcnt   (reofi_wcnt),    // RX EOF write count

  .teofi_wreq   (teofi_wreq),    // TX EOF write request
  .teofi_wid    (teofi_wid),     // TX EOF write index
  .teofi_wdata  (teofi_wdata),   // TX EOF interrupt write data
  .teofi_wack   (teofi_wack),    // Ack. for teofi_wreq
  .teofi_wcnt   (teofi_wcnt),    // TX EOF write count

  .txpq_wreq    (txpq_wreq),     // TX packet queue write request
  .txpq_rreq    (txpq_rreq),     // TX packet queue read request
  .txpq_addr    (txpq_addr),     // TX packet queue write/read address
  .txpq_wdata   (txpq_wdata),    // TX packet queue write data
  .txpq_wack    (txpq_wack),     // TX packet queue write ack
  .txpq_rack    (txpq_rack),     // TX packet queue read ack
  .mff_wreq     (smff_wreq),     // MCU FIFO write request
  .mff_rreq     (smff_rreq),     // MCU FIFO read request
  .mem_ben      (mem_ben),       // MCU FIFO Write byte enable
  .mem_addr     (mem_addr[9:2]), // MCU FIFO read/write address
  .mem_wr_data  (mem_wr_data),   // MCU FIFO write data
  .mff_wack     (smff_wack),     // MCU FIFO write Ack.
  .mff_rack     (smff_rack),     // MCU FIFO read Ack.

  .csn_ufinfo   (csn_usff),      // Chip select, active low
  .wen_ufinfo   (wen_usff),      // Write enable, active low
  .oen_ufinfo   (oen_usff),      // Out enable, active low
  .bwen_ufinfo  (bwen_usff),     // Bit write enable, active low
  .addr_ufinfo  (addr_usff),     // Address for read/write
  .wdata_ufinfo (wdata_usff)     // Write data
);


////////////////////////////////////////////////////////////////////////
// USB INTERRUPT controller
////////////////////////////////////////////////////////////////////////
uintr_ctrl uintr_ctrl (
// Clock and reset
  .clk_main       (clk_main),           // Main clock
  .rst_main       (rst_main),           // Reset synchronized to clk_main

  .prdma_end      (prdma_end),          // RDMA end
  .rf_status      (rf_status),          // RX frame status
  .desc_wstptr    (desc_wstptr),        // RX frame write start pointer
  .reofi_full     (reofi_full),         // RX EOF interrupt queue full
  .ptxd_pend      (ptxd_pend),          // TX end
  .dtxpkt_len     (dtxpkt_len),         // TX length
  .dtxpkt_sptr    (desc_rstptr),        // TX start descriptor pointer
  .dteofi_wreq    (dteofi_wreq),        // TX eof write request
  .teofi_full     (teofi_full),         // TX EOF interrupt queue full
  .intr_usb       (intr_usb),           // USB interrupt

  .reofi_wack     (reofi_wack),         // Ack. for reofi_wreq
  .reofi_wcnt     (reofi_wcnt),         // RX EOF write count
  .reofi_wreq     (reofi_wreq),         // RX EOF write request
  .reofi_wid      (reofi_wid),          // RX EOF write index
  .reofi_wdata    (reofi_wdata),        // RX EOF interrupt write data

  .teofi_wack     (teofi_wack),         // Ack. for teofi_wreq
  .teofi_wcnt     (teofi_wcnt),         // TX EOF write count
  .teofi_wreq     (teofi_wreq),         // TX EOF write request
  .teofi_wid      (teofi_wid),          // TX EOF write index
  .teofi_wdata    (teofi_wdata),        // TX EOF interrupt write data

  .wr_intr_en     (wr_intr_en),         // Write request, 020
  .wr_intr_mask   (wr_intr_mask),       // Write request, 024
  .wr_intr_src    (wr_intr_src),        // Write request, 028
  .rd_intr_en     (rd_intr_en),         // Read request, 020
  .rd_intr_mask   (rd_intr_mask),       // Read request, 024
  .rd_intr_src    (rd_intr_src),        // Read request, 028
  .mem_ben        (mem_ben[1:0]),       // Write byte enable, MCU
  .mem_wr_data    (mem_wr_data[9:0]),   // Write data, MCU
  .rout0          (rout0)               // Register read data, 000 ~ 03f
);


////////////////////////////////////////////////////////////////////////
// USB FIFO
////////////////////////////////////////////////////////////////////////
DPSRAMBW576x32 usb_fifo (
  .CK1      (clk_usb),         // Clock
  .CK2      (clk_main),        // Clock
  .CSN1     (csn1_uff),        // Chip Select Negative
  .CSN2     (csn2_uff),        // Chip Select Negative
  .WEN1     (wen1_uff),        // Write Enable Negative
  .WEN2     (wen2_uff),        // Write Enable Negative
  .OEN1     (oen1_uff),        // Output Enable Negative
  .OEN2     (oen2_uff),        // Output Enable Negative
  .BWEN1    (bwen1_uff),       // Bit Write Enable Negative
  .BWEN2    (bwen2_uff),       // Bit Write Enable Negative
  .A1       (addr1_uff),       // Address
  .A2       (addr2_uff),       // Address
  .DI1      (wdata1_uff),      // Data input
  .DI2      (wdata2_uff),      // Data input

  .DOUT1    (rdata1_uff),      // Data output
  .DOUT2    (rdata2_uff)       // Data output
);

////////////////////////////////////////////////////////////////////////
// USB frame status information FIFO
////////////////////////////////////////////////////////////////////////
SPSRAMBW192x32 ufs_fifo (
  .CK       (clk_main),        // Clock
  .CSN      (csn_usff),        // Chip Select Negative
  .WEN      (wen_usff),        // Write Enable Negative
  .OEN      (oen_usff),        // Output Enable Negative
  .BWEN     (bwen_usff),       // Bit Write Enable Negative
  .A        (addr_usff),       // Address
  .DI       (wdata_usff),      // Data input

  .DOUT     (rdata_usff)       // Data output
);

///////////////////////////////////////////////////////////////////
// Change clock domain
///////////////////////////////////////////////////////////////////
reg prst_usb;
always @(posedge clk_main) prst_usb <= rst_usb;

always @(posedge clk_main) yfd_bus_reset <= bus_reset;

reg yfd_setup_ok;
always @(posedge clk_main) yfd_setup_ok <= dsetup_ok;
reg msetup_ok;
always @(posedge clk_main) msetup_ok <= yfd_setup_ok;
assign pmsetup_ok = yfd_setup_ok & ~msetup_ok;

reg yfd_next_data;
always @(posedge clk_main) yfd_next_data <= dnext_data;
reg mnext_data;
always @(posedge clk_main) mnext_data <= yfd_next_data;
assign pmnext_data = yfd_next_data & ~mnext_data;
assign pe0_next = pmnext_data & endp == 4'h0;
assign pe1_next = pmnext_data & endp == 4'h1;
assign pe2_next = pmnext_data & endp == 4'h2;

reg yfd_accept;
always @(posedge clk_main) yfd_accept <= daccept;
reg maccept;
always @(posedge clk_main) maccept <= yfd_accept;
assign pmaccept = yfd_accept & ~maccept;
assign pe0_accept = pmaccept & endp == 4'h0;
assign pe3_accept = pmaccept & endp == 4'h3;

always @(posedge clk_main) yfd_set_addr <= dset_addr;

always @(posedge clk_usb) yfd_endp_halt <= endp_halt;

always @(posedge clk_usb) yfd_endp_valid <= endp_valid;

always @(posedge clk_usb) yfd_endp_full <= endp_full;



endmodule
