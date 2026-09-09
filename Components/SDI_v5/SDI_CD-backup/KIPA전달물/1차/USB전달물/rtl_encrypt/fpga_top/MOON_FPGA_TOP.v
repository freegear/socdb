////////////////////////////////////////////////////////////////////////////////
// 
// FPGA_TOP      : USB2.0 IP
// DATE          : Aug 20, 2003
// Designer      : J.H. Ryoo
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module MOON_FPGA_TOP (
// Inouts
  HADDR,
  HTRANS,
  HBURST,
  HWRITE,
  HSIZE,
  HRESP,
  HREADY,
  HDATA,
  SDATA,

// Outputs
  HBUSREQ,
  HLOCK,
  RTCK,
// APB I/O (SLAVE 1)
  nLMINT,
  LED,
  CTRLCLK1,
  CTRLCLK2,
// ZBT RAM (SLAVE 2)
  SCLK,
  SnWBYTE,
  SnOE,
  SnCE,
  SADVnLD,
  SnWR,
  SnCKE,
  SMODE,
  SADDR,
// FLASH control signals
  FnOE,
  FnWE,
// misc signals
  PWRDNCLK1,
  PWRDNCLK2,
  TDO,

// Inputs
// AHB interface
  HCLK,
  TCK,
  HRESETn,
  nPBUTT,
  SW,
  HDRID,
  TDI,
  HGRANT,
  HMASTER,

////////////////////////////////////////////////////////////////////////////////
// External Pins
////////////////////////////////////////////////////////////////////////////////

// Clock & Reset
  clk_usb,
  RESETn,

// Configuration
  ext_utm,
  dbus16,
  big_endian,

// USB 1.1
  DP,              // USB 1.1 Data plus
  DM,              // USB 1.1 Data minus

// USB 2.0
  rst_bus,         // USB bus reset
  line_state1,     // Line state
  line_state0,     // Line state
  tx_valid,        // TX data valid
  tx_ready,        // TX data ready
  rx_active,       // RX data ready
  rx_valid,        // RX valid
  rx_error,        // RX error
  psuspend,        // 0: Suspend USB
  xcvr_select,     // 0: High speed XCVR
  term_select,     // 0: High speed termination
  op_mode1,        // UTM operation mode
  op_mode0,        // UTM operation mode
  valid_h,         // Data valid high
  usb_data15,      // USB data
  usb_data14,      // USB data
  usb_data13,      // USB data
  usb_data12,      // USB data
  usb_data11,      // USB data
  usb_data10,      // USB data
  usb_data9,       // USB data
  usb_data8,       // USB data
  usb_data7,       // USB data
  usb_data6,       // USB data
  usb_data5,       // USB data
  usb_data4,       // USB data
  usb_data3,       // USB data
  usb_data2,       // USB data
  usb_data1,       // USB data
  usb_data0        // USB data

);

// Inouts
inout     [31:0] HADDR;     // AHB address bus
inout      [1:0] HTRANS;    // AHB transfer type CONT [1:0]
inout      [2:0] HBURST;    // AHB burst type
inout            HWRITE;    // AHB hwrite CONT 11
inout      [1:0] HSIZE;     // AHB hsize CONT [3:2]
inout      [1:0] HRESP;     // AHB response CONT [14:13]
inout            HREADY;    // AHB ready CONT 12
inout     [31:0] HDATA;     // AHB data bus (bi directional)
inout     [31:0] SDATA;     // ZBT data bus

// Outputs
output           HBUSREQ;  // AHB request
output           HLOCK;    // AHB lock
output           RTCK;     // return test clock (Multi-ICE feature)
// APB I/O (SLAVE 1)
output           nLMINT;   // LM peripheral interrupt request
output     [8:0] LED;      // LED control
output    [18:0] CTRLCLK1;  // sets frequency of CLK1
output    [18:0] CTRLCLK2;  // sets frequency of CLK2
// ZBT RAM (SLAVE 2)
output           SCLK;      // ZBT CLK
output     [3:0] SnWBYTE;   // ZBT byte write control signals
output           SnOE;      // ZBT output enable select
output           SnCE;      // ZBT chip select
output           SADVnLD;   // ZBT Mode pin
output           SnWR;      // ZBT advance signal
output           SnCKE;     // ZBT Clock enable signal
output           SMODE;     // ZBT mode signal
// FLASH control signals
output           FnOE;      // FLASH output enable
output           FnWE;      // FLASH write enable
// misc signals
output           PWRDNCLK1; // clock power-down control
output           PWRDNCLK2; // clock power-down control
output           TDO;       // test data out
output    [19:2] SADDR;     // ZBT address bus

// Inputs

// AHB interface
input            HCLK;      // system bus clock
input            TCK;       // test clock
input            HRESETn;    // reset input (active high)
input            nPBUTT;    // push button used as interrupt source
input      [7:0] SW;        // switches
input      [3:0] HDRID;     // LM ID
input            TDI;       // test data in
input            HGRANT;    // AHB grant
input      [2:0] HMASTER;   // AHB master indication

////////////////////////////////////////////////////////////////////////////////
// External Pins
////////////////////////////////////////////////////////////////////////////////

// Clock & Reset
input          clk_usb;
output         RESETn;

// Configuration
input          ext_utm;
input          dbus16;
input          big_endian;

// USB 1.1
inout          DP;
inout          DM;

// USB 2.0
output         rst_bus;
input          line_state1;
input          line_state0;
input          rx_active;
input          rx_valid;
input          rx_error;
input          tx_ready;
output         tx_valid;
output         psuspend;
output         xcvr_select;
output         term_select;
output         op_mode1;
output         op_mode0;
inout          valid_h;
inout          usb_data15;
inout          usb_data14;
inout          usb_data13;
inout          usb_data12;
inout          usb_data11;
inout          usb_data10;
inout          usb_data9;
inout          usb_data8;
inout          usb_data7;
inout          usb_data6;
inout          usb_data5;
inout          usb_data4;
inout          usb_data3;
inout          usb_data2;
inout          usb_data1;
inout          usb_data0;

////////////////////////////////////////////////////////////////////////////////
// PAD
////////////////////////////////////////////////////////////////////////////////

// USB1.1
wire         rxdp;
wire         rxdm;
wire         rxd;
wire         usbd_oe;
wire         txdp;
wire         txdm;

assign DP = usbd_oe ? 1'bz : txdp;
assign DM = usbd_oe ? 1'bz : txdm;
assign rxdp = DP;
assign rxdm = DM;
assign rxd = DP & ~DM;

// USB2.0 
wire  [1:0]  line_state = {line_state1,line_state0};
wire         rxvalid_h;
wire [15:0]  rx_data;
wire         txvalid_h;
wire [15:0]  tx_data;
wire  [1:0]  op_mode;
wire         op_mode1 = op_mode[1];
wire         op_mode0 = op_mode[0];

assign valid_h = tx_valid ? txvalid_h : 1'bz;
assign rxvalid_h = valid_h;

assign usb_data15 = tx_valid ? tx_data[15] : 1'bz;
assign usb_data14 = tx_valid ? tx_data[14] : 1'bz;
assign usb_data13 = tx_valid ? tx_data[13] : 1'bz;
assign usb_data12 = tx_valid ? tx_data[12] : 1'bz;
assign usb_data11 = tx_valid ? tx_data[11] : 1'bz;
assign usb_data10 = tx_valid ? tx_data[10] : 1'bz;
assign usb_data9  = tx_valid ? tx_data[9]  : 1'bz;
assign usb_data8  = tx_valid ? tx_data[8]  : 1'bz;
assign usb_data7  = tx_valid ? tx_data[7]  : 1'bz;
assign usb_data6  = tx_valid ? tx_data[6]  : 1'bz;
assign usb_data5  = tx_valid ? tx_data[5]  : 1'bz;
assign usb_data4  = tx_valid ? tx_data[4]  : 1'bz;
assign usb_data3  = tx_valid ? tx_data[3]  : 1'bz;
assign usb_data2  = tx_valid ? tx_data[2]  : 1'bz;
assign usb_data1  = tx_valid ? tx_data[1]  : 1'bz;
assign usb_data0  = tx_valid ? tx_data[0]  : 1'bz;

assign rx_data = {usb_data15,usb_data14,usb_data13,usb_data12,
                  usb_data11,usb_data10, usb_data9, usb_data8,
                   usb_data7, usb_data6, usb_data5, usb_data4,
                   usb_data3, usb_data2, usb_data1, usb_data0};


////////////////////////////////////////////////////////////////////////////////
// WIRE/REG Define
////////////////////////////////////////////////////////////////////////////////
wire           rst_main = ~HRESETn;
wire           RESETn = HRESETn;

wire           intr_usb, intr_buffer;
wire           nLMINT;

wire   [1:0]   HRESP_USB;
wire   [1:0]   HRESP_DMA;
wire   [1:0]   HRESP_IRC;
wire   [1:0]   HRESPDefault;
 
wire   [31:0]  HRDATA;
wire   [31:0]  HRDATA_USB;
wire   [31:0]  HRDATA_DMA;
wire   [31:0]  HRDATA_IRC;

wire           HBUSREQ;
wire   [3:0]   HPROT_DMA;
wire   [1:0]   iHRespOut;

// USB1.1
wire           uclk_pre;

// MISC
wire           scan_test = 1'b0;

////////////////////////////////////////////////////////////////////////////////
// USB2.0 TOP
////////////////////////////////////////////////////////////////////////////////

moon_top umoon_top (

// Clock and reset
  .clk_main(HCLK),               // Main clock
  .clk_usb(clk_usb),             // USB clock
  .clk_bus(uclk_pre),            // USB line clock
  .rst_main(rst_main),           // Main reset
  .rst_usb(rst_main),            // USB reset
  .ext_utm(ext_utm),             // 1: use external UTM
  .dbus16(dbus16),               // 1: 16bytes mode
  .big_endian(big_endian),       // 1: big endian, 0: little endian
  .scan_test(scan_test),         // 1: scan test mode
  .uclk_pre(uclk_pre),           // Source of clk_bus
  .intr_usb(intr_usb),           // USB interrupt
  .intr_buffer(intr_buffer),     // Buffer allocation request interrupt

// AHB for internal register
  .hready_in(HREADY),            // AHB ready in
  .hwrite(HWRITE),               // AHB write
  .htrans(HTRANS),               // AHB transfer type
  .hsize(HSIZE),                 // AHB data size
  .haddr(HADDR[23:0]),           // AHB address
  .hwdata(HDATA),                // AHB write data

  .hsel_usb(HSEL_USB),           // AHB select USB
  .hready_outusb(HREADY_USB),    // AHB ready out USB
  .hresp_usb(HRESP_USB),         // AHB response USB
  .hrdata_usb(HRDATA_USB),       // AHB read data USB

  .hsel_dma(HSEL_DMA),           // AHB select DMA
  .hready_outdma(HREADY_DMA),    // AHB ready out DMA
  .hresp_dma(HRESP_DMA),         // AHB response DMA
  .hrdata_dma(HRDATA_DMA),       // AHB read data DMA

// AHB for DMA
  .hgrant_mdma(HGRANT),          // AHB grant
  .hmaster_mdma(HMASTER),        // AHB HMASTER
  .hresp_mdma(HRESP),            // AHB response (retry/error/split support)
  .hready_mdma(HREADY),          // AHB ready
  .hrdata_mdma(HDATA),           // AHB data for read
  .hbusreq_mdma(HBUSREQ),        // AHB request
  .htrans_mdma(HTRANS),          // AHB Transfer Type
  .hburst_mdma(HBURST),          // AHB Burst Type
  .hsize_mdma(HSIZE),            // AHB HSIZE : word only
  .hwrite_mdma(HWRITE),          // AHB Write control
  .haddr_mdma(HADDR),            // AHB address
  .hwdata_mdma(HDATA),           // AHB data for write
  .HLOCK_DMA(HLOCK),             // AHB lock
  .HPROT_DMA(HPROT_DMA),         // AHB

// USB
// For USB1.1
  .rxdp(rxdp),                   // RX data plus
  .rxdm(rxdm),                   // RX data minus
  .rxd(rxd),                     // RX data
  .usbd_oe(usbd_oe),             // USB data out enable
  .txdp(txdp),                   // TX data plus
  .txdm(txdm),                   // TX data minus

// For USB2.0
  .rst_bus(rst_bus),             // USB bus reset
  .line_state(line_state),       // Line state
  .tx_valid(tx_valid),           // TX data valid
  .txvalid_h(txvalid_h),         // TX valid high
  .tx_data(tx_data),             // TX data
  .tx_ready(tx_ready),           // TX data ready
  .rx_active(rx_active),         // RX data ready
  .rx_valid(rx_valid),           // RX valid
  .rxvalid_h(rxvalid_h),         // RX valid high
  .rx_error(rx_error),           // RX error
  .rx_data(rx_data),             // RX data
  .psuspend(psuspend),           // 0: Suspend USB
  .xcvr_select(xcvr_select),     // 0: High speed XCVR
  .term_select(term_select),     // 0: High speed termination
  .op_mode(op_mode)              // UTM operation mode
);

////////////////////////////////////////////////////////////////////////////////
// Interrupt Controller
////////////////////////////////////////////////////////////////////////////////
IntCtrl uIntCtrl (
  .HCLK(HCLK), 
  .HRESETn(HRESETn), 
  .HSEL_IRC(HSEL_IRC),
  .HADDR(HADDR[3:0]), 
  .HTRANS(HTRANS), 
  .HWRITE(HWRITE), 
  .HSIZE({1'b0, HSIZE}), 
  .HWDATA(HDATA),
  .HREADYin(HREADY), 
  .BIGENDIAN(1'b0), 
  .INTSRC({intr_buffer, intr_usb, 1'b0}),

  .HRDATA(HRDATA_IRC), 
  .HREADYout(HREADY_IRC), 
  .HRESP(HRESP_IRC),
  .nLMINT(nLMINT)
);

////////////////////////////////////////////////////////////////////////////////
// AHB Bus Decoder
////////////////////////////////////////////////////////////////////////////////
AHBDecoder uAHBDecoder (
  .HSEL_USB          (HSEL_USB),
  .HSEL_DMA          (HSEL_DMA),
  .HSEL_IRC          (HSEL_IRC),
  .HSELLOGICMODULE   (HSELLOGICMODULE),
  .HSELDefault       (HSELDefault),
  .HREADYOut         (HREADYDefault),
  .HRESP             (HRESPDefault),

  .HCLK              (HCLK),
  .HRESETn           (HRESETn),
  .HTRANS            (HTRANS),
  .HREADYIn          (HREADY),
  .HDRID             (HDRID),
  .HADDR             (HADDR)
);

////////////////////////////////////////////////////////////////////////////////
// AHB Mux
////////////////////////////////////////////////////////////////////////////////
AHBMuxS2M uAHBMuxS2M (
  .HREADYOut         (iHReadyOut),
  .HRESP             (iHRespOut),
  .HRDATA            (HRDATA),

  .HCLK              (HCLK),
  .HRESETn           (HRESETn),

  .HREADYIn          (HREADY),

  .HSEL_USB          (HSEL_USB),
  .HSEL_DMA          (HSEL_DMA),
  .HSEL_IRC          (HSEL_IRC),

  .HREADY_USB        (HREADY_USB),
  .HREADY_DMA        (HREADY_DMA),
  .HREADY_IRC        (HREADY_IRC),
  .HREADYDefault     (HREADYDefault),

  .HRESP_USB         (HRESP_USB),
  .HRESP_DMA         (HRESP_DMA),
  .HRESP_IRC         (HRESP_IRC),
  .HRESPDefault      (HRESPDefault),

  .HRDATA_USB        (HRDATA_USB),
  .HRDATA_DMA        (HRDATA_DMA),
  .HRDATA_IRC        (HRDATA_IRC)
);

reg  ReadEnable;
reg  RespEnable;
wire SDATAEN;
wire [31:0] SWDATA = 32'h00000000;

// Ready/Response/HDATA
always @(posedge HCLK or negedge HRESETn)
begin : p_ReadEnSeq
  if (HRESETn == 1'b0)
    begin
      ReadEnable  <= 1'b0;
      RespEnable  <= 1'b0;
    end
  else
    if (HREADY == 1'b1)
    // start new data phase when HREADY ='1'
      if (HSELLOGICMODULE == 1'b1)
        begin
          RespEnable  <= 1'b1;
          ReadEnable  <= ~(HWRITE);
        end
      else
        begin
          ReadEnable      <= 1'b0;
          RespEnable      <= 1'b0;
       end
end // p_ReadEnSeq

assign HREADY     = (RespEnable == 1'b1) ? iHReadyOut : 1'bz;

assign HRESP      = (RespEnable == 1'b1) ? iHRespOut  : 2'bzz;

assign HDATA      = (ReadEnable == 1'b1) ? HRDATA  : 32'hzzzzzzzz;

assign SDATAEN = 1'b0;
assign SDATA      = (SDATAEN == 1'b1)    ? SWDATA     : 32'hzzzzzzzz;

// Ensure flash is disabled
assign FnOE             = 1'b1;
assign FnWE             = 1'b1;

// Route virtual JTAG signals through. If this module is stacked with something
// that uses a TAP controller, then it will still work OK
assign TDO              = TDI;
assign RTCK             = TCK;

// clk 1 running
assign PWRDNCLK1        = 1'b0;
// assign CTRLCLK1         = 19'b001_0000_0100_0000_0010;   // 60 MHz
assign CTRLCLK1         = 19'b000_0001_0100_0000_0100;   // 4.8 MHz

// clk 2 disabled as this is the SYSCLK OUT from the LM, must be disabled
// when the LM is connected to a motherboard that supplies these clocks.
assign PWRDNCLK2        = 1'b1;

// Interrupt
// assign nLMINT = ~(intr_usb | intr_buffer);

// SRAM
assign SCLK = 1'b0;
assign SnWBYTE = 4'hf;
assign SnOE = 1'b1;
assign SnCE = 1'b1;
assign SADVnLD = 1'b0;
assign SnWR = 1'b0;
assign SnCKE = 1'b0;
assign SMODE = 1'b0;

endmodule

// --================================= End ===================================--
