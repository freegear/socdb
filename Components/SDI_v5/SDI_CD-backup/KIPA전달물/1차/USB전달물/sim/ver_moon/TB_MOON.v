
`timescale 1ns/10ps

module TB_MOON_LM;

////////////////////////////////////////////////////////////////////////////////
// Wire / Reg Definition
////////////////////////////////////////////////////////////////////////////////

//-------------------------------
// Register Define
//-------------------------------
`include "reg_define.v"


reg          HCLK;
reg          HRESETn;
wire         RESETn;

wire         HSELSDRAM;
wire         HSELRetry;
wire         HSELLM;
wire         HSELDefault;

wire         HREADYSDRAM;
wire  [1:0]  HRESPSDRAM;
wire  [31:0] HRDATASDRAM;

wire         HREADYRetry;
wire  [1:0]  HRESPRetry;
wire  [31:0] HRDATARetry;
wire         SCANOUTRetry;

wire         HREADYDefault;
wire  [1:0]  HRESPDefault;

wire  [3:0]  HMASTER;
wire  [3:0]  HMASTERD;
wire         HMASTLOCK;

wire  [31:0] HADDR;
wire  [2:0]  HSIZE;
wire         HWRITE;
wire  [1:0]  HTRANS;
wire  [2:0]  HBURST;
wire  [31:0] HDATA;
wire         HREADY;
wire  [1:0]  HRESP;

wire         HBUSREQ3 = 1'b0;       
wire         HBUSREQ2 = 1'b0;       
wire         HBUSREQ1;
wire         HBUSREQ0;

wire         HLOCK3 = 1'b0;
wire         HLOCK2 = 1'b0;
wire         HLOCK1;
wire         HLOCK0;

wire  [3:0]  HSPLIT = 4'b0000;

wire         HGRANT3;
wire         HGRANT2;
wire         HGRANT1;
wire         HGRANT0;

wire         SCANENABLE = 1'b0;
wire         SCANINHCLK = 1'b0;
wire         SCANOUTHCLK;

wire  [31:0] SDATA;
wire  [8:0]  LED;
wire  [18:0] CTRLCLK1;
wire  [18:0] CTRLCLK2;
wire  [3:0]  SnWBYTE;
wire  [19:2] SADDR;
wire  [7:0]  SW;
wire  [3:0]  HDRID = 4'b1110;

////////////////////////////////////////////////////////////////////////////////
// MOON_FPGA_TOP
////////////////////////////////////////////////////////////////////////////////
wire  TCK = 1'b0;
wire  nPBUTT = 1'b1;
wire  TDI = 1'b1;
wire  big_endian = 1'b0;

wire         #5 HGRANT0_DELAY = HGRANT0;
wire  [3:0]  #5 HMASTER_DELAY = HMASTER;
wire            nLMINT;

////////////////////////////////////////////////////////////////////////////////
// Clock & Reset
////////////////////////////////////////////////////////////////////////////////

initial HCLK = 0;
always #50 HCLK <= ~HCLK;  // 10MHz

initial begin
  HRESETn = 1'b1;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  HRESETn = 1'b0;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  @(posedge HCLK) #2;
  HRESETn = 1'b1;
end

////////////////////////////////////////////////////////////////////////////////
pulldown (HADDR[31]);
pulldown (HADDR[30]);
pulldown (HADDR[29]);
pulldown (HADDR[28]);
pulldown (HADDR[27]);
pulldown (HADDR[26]);
pulldown (HADDR[25]);
pulldown (HADDR[24]);
pulldown (HADDR[23]);
pulldown (HADDR[22]);
pulldown (HADDR[21]);
pulldown (HADDR[20]);
pulldown (HADDR[19]);
pulldown (HADDR[18]);
pulldown (HADDR[17]);
pulldown (HADDR[16]);
pulldown (HADDR[15]);
pulldown (HADDR[14]);
pulldown (HADDR[13]);
pulldown (HADDR[12]);
pulldown (HADDR[11]);
pulldown (HADDR[10]);
pulldown (HADDR[9]);
pulldown (HADDR[8]);
pulldown (HADDR[7]);
pulldown (HADDR[6]);
pulldown (HADDR[5]);
pulldown (HADDR[4]);
pulldown (HADDR[3]);
pulldown (HADDR[2]);
pulldown (HADDR[1]);
pulldown (HADDR[0]);
pulldown (HTRANS[1]);
pulldown (HTRANS[0]);
pulldown (HWRITE);
pulldown (HBURST[2]);
pulldown (HBURST[1]);
pulldown (HBURST[0]);
pulldown (HSIZE[1]);
pulldown (HSIZE[0]);
pullup   (HREADY);

////////////////////////////////////////////////////////////////////////////////
Decoder uDecoder (
  .HRESETn(HRESETn),
  .HADDR(HADDR),
  .HSELSDRAM(HSELSDRAM),
  .HSELRetry(HSELRetry),
  .HSELLM(HSELLM),
  .HSELDefault(HSELDefault)
);

MuxS2M uMuxS2M (
  .HCLK(HCLK), 
  .HRESETn(HRESETn),
  .HWRITE(HWRITE),
  .HTRANS(HTRANS),

  .HSELSDRAM(HSELSDRAM),
  .HSELRetry(HSELRetry), 
  .HSELLM(HSELLM), 
  .HSELDefault(HSELDefault),

  .HRDATASDRAM(HRDATASDRAM), 
  .HREADYSDRAM(HREADYSDRAM), 
  .HRESPSDRAM(HRESPSDRAM),

  .HRDATARetry(HRDATARetry), 
  .HREADYRetry(HREADYRetry), 
  .HRESPRetry(HRESPRetry),

  .HREADYDefault(HREADYDefault), 
  .HRESPDefault(HRESPDefault),

  .HRDATA(HDATA), 
  .HREADY(HREADY), 
  .HRESP(HRESP)
);

SDRAM uSDRAM (
  .HCLK(HCLK), 
  .HRESETn(HRESETn), 
  .HADDR(HADDR), 
  .HTRANS(HTRANS), 
  .HWRITE(HWRITE), 
  .HSIZE(HSIZE), 
  .HSELMEM(HSELSDRAM), 
  .HWDATA(HDATA), 
  .HREADYin(HREADY), 
  .HRDATA(HRDATASDRAM),
  .HREADYout(HREADYSDRAM), 
  .HRESP(HRESPSDRAM),
  .RetryAddr(32'h82b1_0024)
//  .RetryAddr(32'hffff_ffff)
);

RetrySlave uRetrySlave (
  .HCLK(HCLK), 
  .HRESETn(HRESETn), 
  .HADDR(HADDR), 
  .HTRANS(HTRANS), 
  .HWRITE(HWRITE), 
  .HSIZE(HSIZE), 
  .HWDATA(HDATA),
  .HSELRetry(HSELRetry), 
  .HREADY(HREADY), 
  .HRDATA(HRDATARetry), 
  .HREADYOUT(HREADYRetry), 
  .HRESP(HRESPRetry),
  .SCANENABLE(1'b0), 
  .SCANINHCLK(1'b0), 
  .SCANOUTHCLK(SCANOUTRetry)
);

DefaultSlave uDefaultSlave (
  .HCLK(HCLK),
  .HRESETn(HRESETn),
  .HTRANS(HTRANS),
  .HSELDefault(HSELDefault),
  .HREADYin(HREADY),
  .HREADYout(HREADYDefault),
  .HRESP(HRESPDefault)
);

////////////////////////////////////////////////////////////////////////////////
Master uMaster (
  .HCLK(HCLK),
  .HRESETn(HRESETn),

  .HBUSREQ(HBUSREQ1),
  .HGRANT(HGRANT1),
  .HMASTER(HMASTER),
  .HLOCK(HLOCK1),
  .HADDR(HADDR),
  .HTRANS(HTRANS),
  .HBURST(HBURST),
  .HWRITE(HWRITE),
  .HSIZE(HSIZE[1:0]),
  .HRESP(HRESP),
  .HREADY(HREADY),
  .HDATA(HDATA),
  .nLMINT(nLMINT)
);

////////////////////////////////////////////////////////////////////////////////
Arbiter3 uArbiter3 (
  // Common AHB signals
  .HCLK(HCLK),
  .HRESETn(HRESETn),

  // AHB Control bus signals of the active master and slave
  .HTRANS(HTRANS),
  .HBURST(HBURST),
  .HREADY(HREADY),
  .HRESP(HRESP),

  // Bus-request signals from individual masters
  .HBUSREQM3(HBUSREQ3),
  .HBUSREQM2(HBUSREQ2),
  .HBUSREQM1(HBUSREQ1),
  .HBUSREQM0(HBUSREQ0),

  // Locked-transfer request signals from individual masters
  .HLOCKM3(HLOCK3),
  .HLOCKM2(HLOCK2),
  .HLOCKM1(HLOCK1),
  .HLOCKM0(HLOCK0),

  // Bus from SPLIT-capable slaves, indicating to the Arbiter
  //  which bus masters should be allowed to re-attempt a split
  //  transaction. Each bit of this bus corresponds to a single
  //  bus master.
  .HSPLIT(HSPLIT),

  // Bus-grant signals to individual masters (mutually exclusive)
  .HGRANTM3(HGRANT3),
  .HGRANTM2(HGRANT2),
  .HGRANTM1(HGRANT1),
  .HGRANTM0(HGRANT0),

  // Granted master number for multiplexor control and slaves
  .HMASTER(HMASTER),
  .HMASTERD(HMASTERD),

  // Indicates the locked status of the current transfer
  .HMASTLOCK(HMASTLOCK),

  // Scan test dummy signals; not connected until scan insertion
  .SCANENABLE(SCANENABLE),     // Scan Test Mode Enbl
  .SCANINHCLK(SCANINHCLK),     // Scan Chain Input
  .SCANOUTHCLK(SCANOUTHCLK));  // Scan Chain Output


//-------------------------------
// USB
//-------------------------------
reg clk_usb;
initial begin
  clk_usb = 1'b0;
  #10;
  `ifdef DBUS_16
    forever #20 clk_usb = ~clk_usb;
  `else
    forever #10 clk_usb = ~clk_usb;
  `endif
end

reg          hspeed;
reg          ext_utm;
reg          dbus16;

initial begin

`ifdef HIGH_SPEED
  hspeed = 1'b1;
  ext_utm = 1'b1;

  `ifdef DBUS_16
    dbus16 = 1'b1;
  `else
    dbus16 = 1'b0;
  `endif

`else
  hspeed = 1'b0;

  `ifdef EXT_UTM
    ext_utm = 1'b1;

    `ifdef DBUS_16
      dbus16 = 1'b1;
    `else
      dbus16 = 1'b0;
    `endif

  `else
    ext_utm = 1'b0;
    dbus16 = 1'b0;
  `endif

`endif

end

wire          DP;
wire          DM;

pullup   (DP);
pulldown (DM);

reg           line_state1;
reg           line_state0;
reg           rx_active;
reg           rx_valid;
reg           rx_error;
reg           tx_ready;
wire          rst_utm;
wire          tx_valid;
wire          psuspend;
wire          xcvr_select;
wire          term_select;
wire          op_mode1;
wire          op_mode0;
wire          valid_h;
wire          usb_data15;
wire          usb_data14;
wire          usb_data13;
wire          usb_data12;
wire          usb_data11;
wire          usb_data10;
wire          usb_data9;
wire          usb_data8;
wire          usb_data7;
wire          usb_data6;
wire          usb_data5;
wire          usb_data4;
wire          usb_data3;
wire          usb_data2;
wire          usb_data1;
wire          usb_data0;

initial line_state1 = 0;
initial line_state0 = 1;
initial rx_active = 0;
initial rx_valid = 0;
initial rx_error = 0;
initial tx_ready = 0;

wire [15:8]  usb_hdata = {usb_data15,usb_data14,usb_data13,usb_data12,
                          usb_data11,usb_data10, usb_data9, usb_data8};
wire  [7:0]  usb_ldata = {usb_data7,usb_data6,usb_data5,usb_data4,
                          usb_data3,usb_data2,usb_data1,usb_data0};

reg         rxvalid_h;
reg  [7:0]  rx_hdata;
reg  [7:0]  rx_ldata;
initial rxvalid_h = 0;
initial rx_hdata = 8'h00;
initial rx_ldata = 8'h00;

assign valid_h = tx_valid ? 1'bz : rxvalid_h;
assign usb_data15 = tx_valid ? 1'bz : rx_hdata[7];
assign usb_data14 = tx_valid ? 1'bz : rx_hdata[6];
assign usb_data13 = tx_valid ? 1'bz : rx_hdata[5];
assign usb_data12 = tx_valid ? 1'bz : rx_hdata[4];
assign usb_data11 = tx_valid ? 1'bz : rx_hdata[3];
assign usb_data10 = tx_valid ? 1'bz : rx_hdata[2];
assign  usb_data9 = tx_valid ? 1'bz : rx_hdata[1];
assign  usb_data8 = tx_valid ? 1'bz : rx_hdata[0];
assign  usb_data7 = tx_valid ? 1'bz : rx_ldata[7];
assign  usb_data6 = tx_valid ? 1'bz : rx_ldata[6];
assign  usb_data5 = tx_valid ? 1'bz : rx_ldata[5];
assign  usb_data4 = tx_valid ? 1'bz : rx_ldata[4];
assign  usb_data3 = tx_valid ? 1'bz : rx_ldata[3];
assign  usb_data2 = tx_valid ? 1'bz : rx_ldata[2];
assign  usb_data1 = tx_valid ? 1'bz : rx_ldata[1];
assign  usb_data0 = tx_valid ? 1'bz : rx_ldata[0];

////////////////////////////////////////////////////////////////////////////////

MOON_FPGA_TOP uMOON_FPGA_TOP (
// Inouts
  .HADDR(HADDR),
  .HTRANS(HTRANS),
  .HBURST(HBURST),
  .HWRITE(HWRITE),
  .HSIZE(HSIZE[1:0]),
  .HRESP(HRESP),
  .HREADY(HREADY),
  .HDATA(HDATA),
  .SDATA(SDATA),

// Outputs
  .HBUSREQ(HBUSREQ0),
  .HLOCK(HLOCK0),
  .RTCK(RTCK),
// APB I/O (SLAVE 1)
  .nLMINT(nLMINT),
  .LED(LED),
  .CTRLCLK1(CTRLCLK1),
  .CTRLCLK2(CTRLCLK2),
// ZBT RAM (SLAVE 2)
  .SCLK(SCLK),
  .SnWBYTE(SnWBYTE),
  .SnOE(SnOE),
  .SnCE(SnCE),
  .SADVnLD(SADVnLD),
  .SnWR(SnWR),
  .SnCKE(SnCKE),
  .SMODE(SMODE),
  .SADDR(SADDR),
// FLASH control signals
  .FnOE(FnOE),
  .FnWE(FnWE),
// misc signals
  .PWRDNCLK1(PWRDNCLK1),
  .PWRDNCLK2(PWRDNCLK2),
  .TDO(TDO),

// Inputs
// AHB interface
  .HCLK(HCLK),
  .TCK(TCK),
  .HRESETn(HRESETn),
  .nPBUTT(nPBUTT),
  .SW(SW),
  .HDRID(HDRID),
  .TDI(TDI),
  .HGRANT(HGRANT0_DELAY),
  .HMASTER(HMASTER_DELAY[2:0]),
////////////////////////////////////////////////////////////////////////////////
// External Pins
////////////////////////////////////////////////////////////////////////////////

// Clock & Reset
  .clk_usb(clk_usb),
  .RESETn(RESETn),

// Configuration
  .ext_utm(ext_utm),
  .dbus16(dbus16),
  .big_endian(big_endian),

// USB 1.1
  .DP(DP),                       // USB 1.1 Data plus
  .DM(DM),                       // USB 1.1 Data minus

// USB 2.0
  .rst_bus(rst_utm),             // USB bus reset
  .line_state1(line_state1),     // Line state
  .line_state0(line_state0),     // Line state
  .tx_valid(tx_valid),           // TX data valid
  .tx_ready(tx_ready),           // TX data ready
  .rx_active(rx_active),         // RX data ready
  .rx_valid(rx_valid),           // RX valid
  .rx_error(rx_error),           // RX error
  .psuspend(psuspend),           // 0: Suspend USB
  .xcvr_select(xcvr_select),     // 0: High speed XCVR
  .term_select(term_select),     // 0: High speed termination
  .op_mode1(op_mode1),           // UTM operation mode
  .op_mode0(op_mode0),           // UTM operation mode
  .valid_h(valid_h),             // Data valid high
  .usb_data15(usb_data15),       // USB data
  .usb_data14(usb_data14),       // USB data
  .usb_data13(usb_data13),       // USB data
  .usb_data12(usb_data12),       // USB data
  .usb_data11(usb_data11),       // USB data
  .usb_data10(usb_data10),       // USB data
  .usb_data9(usb_data9),         // USB data
  .usb_data8(usb_data8),         // USB data
  .usb_data7(usb_data7),         // USB data
  .usb_data6(usb_data6),         // USB data
  .usb_data5(usb_data5),         // USB data
  .usb_data4(usb_data4),         // USB data
  .usb_data3(usb_data3),         // USB data
  .usb_data2(usb_data2),         // USB data
  .usb_data1(usb_data1),         // USB data
  .usb_data0(usb_data0)          // USB data

);


///////////////////////////////////////////////////////////////////////////
// USB modeling
///////////////////////////////////////////////////////////////////////////
`ifdef USB
  `ifdef EXT_UTM
    `include "./usb_model/usb2_stim.v"
  `else
    `include "./usb_model/usb_stim.v"
  `endif
`endif

////////////////////////////////////////////////////////////////////////////////
initial begin
  if ($test$plusargs("DUMP")) begin
      $dumpfile("moon_rtl.dump");
      $dumpvars;
  end
end

endmodule
