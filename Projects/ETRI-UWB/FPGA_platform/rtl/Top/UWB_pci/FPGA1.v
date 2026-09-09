// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : FPGA1.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : ETRI UWB Top module for FPGA1 implementaion
// --========================================================================--

`timescale 1ns/1ps
module FPGA1(
	CLK,
	nRESET,
 /*
    I2S_MCLK, 
    I2S_BCLK, 
    I2S_LRCLK,
    I2S_SDOUT,
    I2S_SDIN, 
    L3MODE,     //GPIO0[21]}
    L3CLOCK,    //GPIO0[22]}
    L3DATA,     //GPIO0[23]}
*/
	// Mac Interrupt source
	MacIntSrc,

	// AHB MASTER0 Interface for MAC
	HADDR_M0,
	HTRANS_M0,
	HWRITE_M0,
	HSIZE_M0,
	HBURST_M0,
	HPROT_M0,
	HWDATA_M0,
	HRDATA_M0,
	HREADY_IN_M0,
	HRESP_M0,

	// AHB SLAVE0 Interface for MAC
	HADDR_S0,
	HTRANS_S0,
	HWRITE_S0,
	HSIZE_S0,
	HBURST_S0,
	HPROT_S0,
	HWDATA_S0,
	HRDATA_S0,
	HREADY_OUT_S0,
	HRESP_S0,	

	HSEL_S0,
	
	// AHB SLAVE1 Interface for MAC
	HADDR_S1,
	HTRANS_S1,
	HWRITE_S1,
	HSIZE_S1,
	HBURST_S1,
	HPROT_S1,
	HWDATA_S1,
	HRDATA_S1,
	HREADY_OUT_S1,
	HRESP_S1,	

	HSEL_S1,

    //from FPGA0 UART
    UART_TXD0_F0,
    UART_RXD0_F0,
    UART_TXD1_F0,
    UART_RXD1_F0,
    
    //from FPGA0 SevenSegment
    SevenSegCtrl_FPGA0,
    SevenSegComm_FPGA0,

    //FPGA1 interface
    UART_TXD0,
    UART_RXD0,
    UART_TXD1,
    UART_RXD1,
 
    CLK200M_Out,
    CLK100M_Out,
    CLK50M_Out ,

	SevenSegCtrl,
    SevenSegComm );

// AHB MASTER0 for MAC

input			CLK;
input			nRESET;

// Mac Interrupt source
output[ 1:0] 	MacIntSrc;

	// AHB MASTER0 Interface for MAC
output[31:0]	HADDR_M0;
output[ 1:0]	HTRANS_M0;
output			HWRITE_M0;
output[ 2:0]	HSIZE_M0;
output[ 2:0]	HBURST_M0;
output[ 3:0]	HPROT_M0;
output[31:0]	HWDATA_M0;
input [31:0]	HRDATA_M0;
input			HREADY_IN_M0;
input [ 1:0]	HRESP_M0;

	// AHB SLAVE0 Interface for MAC
input [31:0]	HADDR_S0;
input [ 1:0]	HTRANS_S0;
input			HWRITE_S0;
input [ 2:0]	HSIZE_S0;
input [ 2:0]	HBURST_S0;
input [ 3:0]	HPROT_S0;
input [31:0]	HWDATA_S0;
output[31:0]	HRDATA_S0;
output			HREADY_OUT_S0;
output[ 1:0]	HRESP_S0;	

input			HSEL_S0;
	
	// AHB SLAVE1 Interface for MAC
input [31:0]  	HADDR_S1;
input [ 1:0]    HTRANS_S1;
input		    HWRITE_S1;
input [ 2:0]    HSIZE_S1;
input [ 2:0]    HBURST_S1;
input [ 3:0]    HPROT_S1;
input [31:0]    HWDATA_S1;
output[31:0]    HRDATA_S1;
output		    HREADY_OUT_S1;
output[ 1:0]    HRESP_S1;	

input		    HSEL_S1;
//from FPGA0 UART
input           UART_TXD0_F0;
output          UART_RXD0_F0;
    
input           UART_TXD1_F0;
output          UART_RXD1_F0;

output          CLK200M_Out;
output          CLK100M_Out;
output          CLK50M_Out ;

    //from FPGA0 SevenSegment
input  [ 7:0]   SevenSegCtrl_FPGA0;
input  [ 3:0]   SevenSegComm_FPGA0;

    //FPGA1 interface
output          UART_TXD0;
input           UART_RXD0;
output          UART_TXD1;
input           UART_RXD1;

output [ 7:0]   SevenSegCtrl;
output [ 3:0]   SevenSegComm;

wire [ 1:0] MacIntSrc;
assign MacIntSrc = 2'b00;


wire [31:0]	HADDR_M0;
wire [ 1:0]	HTRANS_M0;
wire    	HWRITE_M0;
wire [ 2:0]	HSIZE_M0;
wire [ 2:0]	HBURST_M0;
wire [ 3:0]	HPROT_M0;
wire [31:0]	HWDATA_M0;
wire		HSEL_M0;

   
assign HADDR_M0= 32'd0;
assign HTRANS_M0= 2'b00;
assign HWRITE_M0= 1'b0;
assign HSIZE_M0= 3'h0;
    
assign HBURST_M0= 3'h0;
assign HPROT_M0= 4'h0;
   
assign HWDATA_M0= 32'd0;
    

wire [31:0]	HRDATA_S0;
wire 		HREADY_OUT_S0;
wire [ 1:0]	HRESP_S0;	

/*
assign HRDATA_S0= 32'd0;
assign HREADY_OUT_S0=1'b1;
assign HRESP_S0=2'd0;
*/

wire [31:0]	HRDATA_S1;
wire 		HREADY_OUT_S1;
wire [ 1:0]	HRESP_S1;	

/*
assign HRDATA_S1= 32'd0;
assign HREADY_OUT_S1=1'b1;
assign HRESP_S1=2'd0;
*/

assign UART_TXD0 = UART_TXD0_F0;
assign UART_RXD0_F0 = UART_RXD0;

assign UART_TXD1 = UART_TXD1_F0;
assign UART_RXD1_F0 = UART_RXD1;

assign SevenSegCtrl = SevenSegCtrl_FPGA0;
assign SevenSegComm = SevenSegComm_FPGA0;



wire        CLK200M;
wire        CLK100M;
wire        CLK50M;

// Clock Generator for FPGA
mypll2x PLL1(
	.CLKIN_IN(CLK),
	.CLKDV_OUT(CLK50M),
	.CLKIN_IBUFG_OUT(),
	.CLK0_OUT(CLK100M),
	.CLK2X_OUT(CLK200M),
	.LOCKED_OUT()
);

reg [26:0] CLK200MCnt;
reg [26:0] CLK100MCnt;
reg [26:0] CLK50MCnt;

always @(posedge CLK200M or negedge nRESET)
	if(!nRESET)
		CLK200MCnt <= 0;
	else
		CLK200MCnt <= CLK200MCnt + 1;

always @(posedge CLK100M or negedge nRESET)
	if(!nRESET)
		CLK100MCnt <= 0;
	else
		CLK100MCnt <= CLK100MCnt + 1;

always @(posedge CLK50M or negedge nRESET)
	if(!nRESET)
		CLK50MCnt <= 0;
	else
		CLK50MCnt <= CLK50MCnt + 1;

assign CLK200M_Out = CLK200MCnt[26];
assign CLK100M_Out = CLK100MCnt[26];
assign CLK50M_Out  = CLK50MCnt[26];


wire ACLK_BUS;
assign ACLK_BUS = CLK100M;

wire[12:0] addr0;
wire[3:0]  wrb0;
wire       oeb0;
wire	   csb0;
wire[31:0] dout0;
wire[31:0] din0;

wire[12:0] addr1;
wire[3:0]  wrb1;
wire       oeb1;
wire	   csb1;
wire[31:0] dout1;
wire[31:0] din1;
	    
ismc_ahb ismc0(
	.clk          (ACLK_BUS),   
	.rstb         (nRESET),
	
	.ahb_sel      (HSEL_S0),
	.ahb_readyin  (1'b1),   
	.ahb_htrans   (HTRANS_S0),   
	.ahb_addr     (HADDR_S0),   
	.ahb_write    (HWRITE_S0),   
	.ahb_size     (HSIZE_S0),   
	.ahb_wdata    (HWDATA_S0),   
	.ahb_rdata    (HRDATA_S0),   
	.ahb_ready    (HREADY_OUT_S0),   
	.ahb_resp     (HRESP_S0),   
	
	.sram_csb     (csb0),   
	.sram_addr    (addr0),   
	.sram_wrb     (wrb0),   
	.sram_oeb     (oeb0),   
	.sram_dout    (dout0),   
	.sram_din     (din0));


SSRAM32bit sram0(
	.CLK        (ACLK_BUS),

	.ADDR       (addr0[11:0]),
	.CEn        (csb0),
	.WEn        (wrb0),
	.RDATA      (dout0),
	.WDATA      (din0)
);


ismc_ahb ismc1(
    .clk          (ACLK_BUS),   
    .rstb         (nRESET),
  
    .ahb_sel      (HSEL_S1),
    .ahb_readyin  (1'b1),   
    .ahb_htrans   (HTRANS_S1),   
    .ahb_addr     (HADDR_S1),   
    .ahb_write    (HWRITE_S1),   
    .ahb_size     (HSIZE_S1),   
    .ahb_wdata    (HWDATA_S1),   
    .ahb_rdata    (HRDATA_S1),   
    .ahb_ready    (HREADY_OUT_S1),   
    .ahb_resp     (HRESP_S1),   
  
    .sram_csb     (csb1),   
    .sram_addr    (addr1),   
    .sram_wrb     (wrb1),   
    .sram_oeb     (oeb1),   
    .sram_dout    (dout1),   
    .sram_din     (din1));

SSRAM32bit sram1(
	.CLK        (ACLK_BUS),

	.ADDR       (addr1[11:0]),
	.CEn        (csb1),
	.WEn        (wrb1),
	.RDATA      (dout1),
	.WDATA      (din1)
);

//============= FOR AHB MASTER TEST ================
/*
reg[31:0] HADDR;
reg[31:0] HWDATA;
reg[ 2:0] HSIZE;
reg		  HWRITE;
reg[ 1:0] HTRANS;
   wire   HREADY;
   

   assign HADDR_M0 = HADDR;
   assign HTRANS_M0 = HTRANS;
   assign HWRITE_M0 = HWRITE;
   assign HWDATA_M0 = HWDATA;
   assign HSIZE_M0 = HSIZE;
   assign HREADY = HREADY_IN_M0;
   


  // mem write
   task mem_write_M0;
	  input [31:0] addr;
	  input [2:0] size;
	  input [31:0] data;
	  begin
		 @(posedge CLK) 
		 HWRITE = 1'b1;
		 HTRANS = 2'h2;
		 HSIZE  = size;

		 HADDR = addr;
		 
		 wait(HREADY);
		 
		 @(posedge CLK) 
		 HWRITE = 1'b0;
		 HTRANS = 2'h0;
		 HWDATA = data;
		 
		 wait(HREADY);
	  end
   endtask // mem_write

   // mem read
   task mem_read_M0;
	  input [31:0] addr;
	  input [2:0] size;
	  begin
		 @(posedge CLK) 
		 HWRITE = 1'b0;
		 HTRANS = 2'h2;
		 HSIZE = size;

		 HADDR = addr;		 
		 wait(HREADY);
		 
		 @(posedge CLK) 
		 HWRITE = 1'b0;
		 HTRANS = 2'h0;
		 
		 wait(HREADY);
	  end
   endtask // mem_write


initial begin
   wait(nRESET);
   #22000 
	mem_write_M0(32'h20000a00,3'd2,32'h11223344);
	mem_write_M0(32'h20000a04,3'd2,32'h55667788);
	mem_write_M0(32'h20000a08,3'd2,32'haabbccdd);
	mem_write_M0(32'h20000a0c,3'd2,32'hff00ff00);
	mem_read_M0 (32'h20000a00,3'd2);
	mem_read_M0 (32'h20000a04,3'd2);
	mem_read_M0 (32'h20000a08,3'd2);
	mem_read_M0 (32'h20000a0c,3'd2);
end
*/
//=============================================================

   
endmodule

