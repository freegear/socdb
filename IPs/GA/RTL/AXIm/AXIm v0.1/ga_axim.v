/****************************************************
 
    AXI interface for Graphic Accelerator
 
    file name : ga_axim.v
    created by gtlee
    data : 2006.7.5
 
    note :
 
    history : 
 
******************************************************/

`timescale 1ns/10ps

module  ga_axim
  (

   );

   parameter        WID_WIDTH = 4;	// AWID/WID/BID width
   parameter 		RID_WIDTH = 4;	// ARID/RID width
   parameter 		DATA_WIDTH = 64;
   parameter 		NUM_BYTE = DATA_WIDTH/8;
   
   
   // AXI Signals
   input [1:0] 		MASTER_ID;
   
   input 			ACLK;
   input 			ARESETn;
   
   output [WID_WIDTH-1:0] AWID;
   output [31:0] 	AWADDR;
   output [3:0] 	AWLEN;
   output [2:0] 	AWSIZE;
   output [1:0] 	AWBURST;
   output [1:0] 	AWLOCK;
   output [3:0] 	AWCACHE;
   output [2:0] 	AWPROT;
   output 			AWVALID;
   input 			AWREADY;
   
   output [WID_WIDTH-1:0] WID;
   output [DATA_WIDTH-1:0] WDATA;
   output [NUM_BYTE-1:0]   WSTRB;
   output           WLAST;
   output 			WVALID;
   input 			WREADY;
   

   input [WID_WIDTH-1:0] BID;
   input [1:0] 			 BRESP;
   input 				 BVALID;
   output 				 BREADY;

   //-------------------------------
   output [RID_WIDTH-1:0] ARID;
   output [31:0] 		  ARADDR;
   output [3:0] 		  ARLEN;
   output [2:0] 		  ARSIZE;
   output [1:0] 		  ARBURST;
   output [1:0] 		  ARLOCK;
   output [3:0] 		  ARCACHE;
   output [2:0] 		  ARPROT;
   output 				  ARVALID;
   input 				  ARREADY;
   
   input [RID_WIDTH-1:0]  RID;
   input [DATA_WIDTH-1:0] RDATA;
   input [1:0] 			  RRESP;
   input 				  RLAST;
   input 				  RVALID;
   output 				  RREADY;

   //-------------------------------------
   // Internal bus signals
   input                  grd;
   input [31:0] 		  graddr;
   input [4:0] 			  grsize;
   output [7:0] 		  grbe;
   output [63:0] 		  grdata;
   output 				  grvalid;
   output 				  grlast;

   input 				  gwr;
   input [31:0] 		  gwaddr;
   input [4:0] 			  gwsize;
   input [7:0] 			  gwbe;
   input [63:0] 		  gwdata;
   output 				  gwready;
   output 				  gwlast;
   
   

   

   //===============================================

   wire [WID_WIDTH-1:0]   AWID;
   wire [31:0] 			  AWADDR;
   wire [3:0] 			  AWLEN;
   wire [2:0] 			  AWSIZE;
   wire [1:0] 			  AWBURST;
   wire [1:0] 			  AWLOCK;
   wire [3:0] 			  AWCACHE;
   wire [2:0] 			  AWPROT;
   wire 				  AWVALID;
   
   wire [WID_WIDTH-1:0]   WID;
   wire [DATA_WIDTH-1:0]  WDATA;
   wire [NUM_BYTE-1:0] 	  WSTRB;
   wire 				  WLAST;
   wire 				  WVALID;
   
   wire [WID_WIDTH-1:0]   WID;
   wire [DATA_WIDTH-1:0]  WDATA;
   wire [NUM_BYTE-1:0] 	  WSTRB;
   wire 				  WLAST;
   wire 				  WVALID;
   
   wire 				  BREADY;
   
   wire [RID_WIDTH-1:0]   ARID;
   wire [31:0] 			  ARADDR;
   wire [3:0] 			  ARLEN;
   wire [2:0] 			  ARSIZE;
   wire [1:0] 			  ARBURST;
   wire [1:0] 			  ARLOCK;
   wire [3:0] 			  ARCACHE;
   wire [2:0] 			  ARPROT;
   wire 				  ARVALID;
   
   wire 				  RREADY;
   
   //---------------------------------
   wire [7:0] 			  grbe;
   wire [63:0] 			  grdata;
   wire 				  grvalid;
   wire 				  grlast;

   wire 				  gwready;
   wire 				  gwlast;
   
   //=======================================================


   








   
   

endmodule // ga_axim
