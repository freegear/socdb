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
	RESETn,
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
    
	SevenSegCtrl,
    SevenSegComm );

// AHB MASTER0 for MAC

input			CLK;
input			RESETn;

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

   /*
assign HADDR_M0= 32'd0;
assign HTRANS_M0= 2'b00;
assign HWRITE_M0= 1'b0;
assign HSIZE_M0= 3'h0;
    */
assign HBURST_M0= 3'h0;
assign HPROT_M0= 4'h0;
   /*
assign HWDATA_M0= 32'd0;
    */

wire [31:0]	HRDATA_S0;
wire 		HREADY_OUT_S0;
wire [ 1:0]	HRESP_S0;	

assign HRDATA_S0= 32'd0;
assign HREADY_OUT_S0=1'b1;
assign HRESP_S0=2'd0;


wire [31:0]	HRDATA_S1;
wire 		HREADY_OUT_S1;
wire [ 1:0]	HRESP_S1;	

assign HRDATA_S1= 32'd0;
assign HREADY_OUT_S1=1'b1;
assign HRESP_S1=2'd0;


assign UART_TXD0 = UART_TXD0_F0;
assign UART_RXD0_F0 = UART_RXD0;

assign UART_TXD1 = UART_TXD1_F0;
assign UART_RXD1_F0 = UART_RXD1;

assign SevenSegCtrl = SevenSegCtrl_FPGA0;
assign SevenSegComm = SevenSegComm_FPGA0;





   
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
   wait(RESETn);
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

