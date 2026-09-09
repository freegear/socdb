// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AHB.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose             : 4 Master/4 Slave AHB BUS
//  --========================================================================--

`timescale 1ns/1ps

module AHB (
		HCLK,
		HRESETn,

		// Master Common
		HRDATA_M,
		HREADY_M,
		HRESP_M,

		// Master 0 : default Master
		HBUSREQ_M0,
		HGRANT_M0,
		HLOCK_M0,
		HSPLIT_M0,
		HADDR_M0,
		HTRANS_M0,
		HWRITE_M0,
		HSIZE_M0,
		HBURST_M0,
		HPROT_M0,
		HWDATA_M0,

		// Master 1
		HBUSREQ_M1,
		HGRANT_M1,
		HLOCK_M1,
		HSPLIT_M1,
		HADDR_M1,
		HTRANS_M1,
		HWRITE_M1,
		HSIZE_M1,
		HBURST_M1,
		HPROT_M1,
		HWDATA_M1,

		// Master 2
		HBUSREQ_M2,
		HGRANT_M2,
		HLOCK_M2,
		HSPLIT_M2,
		HADDR_M2,
		HTRANS_M2,
		HWRITE_M2,
		HSIZE_M2,
		HBURST_M2,
		HPROT_M2,
		HWDATA_M2,

		// Master 3
		HBUSREQ_M3,
		HGRANT_M3,
		HLOCK_M3,
		HSPLIT_M3,
		HADDR_M3,
		HTRANS_M3,
		HWRITE_M3,
		HSIZE_M3,
		HBURST_M3,
		HPROT_M3,
		HWDATA_M3,

		// Slave Common
		HADDR_S,
		HTRANS_S,
		HWRITE_S,
		HSIZE_S,
		HBURST_S,
		HPROT_S,
		HWDATA_S,
		HMASTLOCK_S,
		HMASTER_S,
		HREADY_S,

		// Slave 0
		HSEL_S0,
		HRDATA_S0,
		HREADY_S0,
		HRESP_S0,
		HSPLIT_S0,

		// Slave 1
		HSEL_S1,
		HRDATA_S1,
		HREADY_S1,
		HRESP_S1,
		HSPLIT_S1,

		// Slave 2
		HSEL_S2,
		HRDATA_S2,
		HREADY_S2,
		HRESP_S2,
		HSPLIT_S2,

		// Slave 3
		HSEL_S3,
		HRDATA_S3,
		HREADY_S3,
		HRESP_S3,
		HSPLIT_S3
);

input         HCLK;		// AHB Clock
input         HRESETn;	// AHB RESET(active low)

output [31:0] HRDATA_M;
output        HREADY_M;
output [1:0]  HRESP_M;

input         HBUSREQ_M0;
output        HGRANT_M0;
input         HLOCK_M0;
output        HSPLIT_M0;
input  [31:0] HADDR_M0;
input  [1:0]  HTRANS_M0;
input         HWRITE_M0;
input  [2:0]  HSIZE_M0;
input  [2:0]  HBURST_M0;
input  [3:0]  HPROT_M0;
input  [31:0] HWDATA_M0;

input         HBUSREQ_M1;
output        HGRANT_M1;
input         HLOCK_M1;
output        HSPLIT_M1;
input  [31:0] HADDR_M1;
input  [1:0]  HTRANS_M1;
input         HWRITE_M1;
input  [2:0]  HSIZE_M1;
input  [2:0]  HBURST_M1;
input  [3:0]  HPROT_M1;
input  [31:0] HWDATA_M1;

input         HBUSREQ_M2;
output        HGRANT_M2;
input         HLOCK_M2;
output        HSPLIT_M2;
input  [31:0] HADDR_M2;
input  [1:0]  HTRANS_M2;
input         HWRITE_M2;
input  [2:0]  HSIZE_M2;
input  [2:0]  HBURST_M2;
input  [3:0]  HPROT_M2;
input  [31:0] HWDATA_M2;

input         HBUSREQ_M3;
output        HGRANT_M3;
input         HLOCK_M3;
output        HSPLIT_M3;
input  [31:0] HADDR_M3;
input  [1:0]  HTRANS_M3;
input         HWRITE_M3;
input  [2:0]  HSIZE_M3;
input  [2:0]  HBURST_M3;
input  [3:0]  HPROT_M3;
input  [31:0] HWDATA_M3;

output [31:0] HADDR_S;
output [1:0]  HTRANS_S;
output        HWRITE_S;
output [2:0]  HSIZE_S;
output [2:0]  HBURST_S;
output [3:0]  HPROT_S;
output [31:0] HWDATA_S;
output        HMASTLOCK_S;
output        HMASTER_S;
output        HREADY_S;

output        HSEL_S0;
input  [31:0] HRDATA_S0;
input         HREADY_S0;
input  [1:0]  HRESP_S0;
input  [3:0]  HSPLIT_S0;

output        HSEL_S1;
input  [31:0] HRDATA_S1;
input         HREADY_S1;
input  [1:0]  HRESP_S1;
input  [3:0]  HSPLIT_S1;

output        HSEL_S2;
input  [31:0] HRDATA_S2;
input         HREADY_S2;
input  [1:0]  HRESP_S2;
input  [3:0]  HSPLIT_S2;

output        HSEL_S3;
input  [31:0] HRDATA_S3;
input         HREADY_S3;
input  [1:0]  HRESP_S3;
input  [3:0]  HSPLIT_S3;

wire   [31:0] HADDR;
wire   [1:0]  HTRANS;
wire          HWRITE;
wire   [2:0]  HSIZE;
wire   [2:0]  HBURST;
wire   [3:0]  HPROT;
wire   [31:0] HWDATA;
wire   [3:0]  HMASTER;
wire   [3:0]  HMASTERD;
wire          HMASTLOCK;
wire   [31:0] HRDATA;
wire          HREADY;
wire   [1:0]  HRESP;
wire   [3:0]  HSPLIT;
wire          HREADY_DefSlv;
wire   [1:0]  HRESP_DefSlv;
wire          HSEL_DefSlv;

//------------------------------------------------------------------------------
// AHB default assignment
//------------------------------------------------------------------------------
assign HADDR_S     = HADDR;
assign HTRANS_S    = HTRANS;
assign HWRITE_S    = HWRITE;
assign HSIZE_S     = HSIZE;
assign HBURST_S    = HBURST;
assign HPROT_S     = HPROT;
assign HWDATA_S    = HWDATA;
assign HMASTLOCK_S = HMASTLOCK;
assign HMASTER_S   = HMASTER[1:0];
assign HREADY_S    = HREADY;

assign HRDATA_M    = HRDATA;
assign HREADY_M    = HREADY;
assign HRESP_M     = HRESP;

assign HSPLIT      = HSPLIT_S0 | HSPLIT_S1 | HSPLIT_S2 | HSPLIT_S3;

//------------------------------------------------------------------------------
// AHB Arbiter
//------------------------------------------------------------------------------
Arbiter3 uArbiterBus (
	.HCLK        	(HCLK),
	.HRESETn     	(HRESETn),
	             	
	.HTRANS      	(HTRANS),
	.HBURST      	(HBURST),
	.HREADY      	(HREADY),
	.HRESP       	(HRESP),
	             	
	.HBUSREQM3   	(HBUSREQ_M3),
	.HBUSREQM2   	(HBUSREQ_M2),
	.HBUSREQM1   	(HBUSREQ_M1),
	.HBUSREQM0   	(HBUSREQ_M0),
	             	
	.HLOCKM3     	(HLOCK_M3),
	.HLOCKM2     	(HLOCK_M2),
	.HLOCKM1     	(HLOCK_M1),
	.HLOCKM0     	(HLOCK_M0),
	             	
	.HSPLIT      	(HSPLIT[3:0]),
	             	
	.HGRANTM3    	(HGRANT_M3),
	.HGRANTM2    	(HGRANT_M2),
	.HGRANTM1    	(HGRANT_M1),
	.HGRANTM0    	(HGRANT_M0),
	             	
	.HMASTER     	(HMASTER),
	.HMASTERD    	(HMASTERD),
	.HMASTLOCK   	(HMASTLOCK)
);

//------------------------------------------------------------------------------
// AHB Decoder
//------------------------------------------------------------------------------
Decoder uDecoder (
 	.HADDR       	(HADDR),
 	.HSELS0      	(HSEL_S0),
 	.HSELS1      	(HSEL_S1),
 	.HSELS2      	(HSEL_S2),
 	.HSELS3      	(HSEL_S3),
 	             	
 	.HSELSR 	 	(HSEL_DefSlv)
);

//------------------------------------------------------------------------------
// AHB Decoder
//------------------------------------------------------------------------------
DefaultSlave uDefaultSlave1 (
	.HCLK        	(HCLK),
	.HRESETn     	(HRESETn),
	             	
	.HTRANS      	(HTRANS),
	.HSEL        	(HSEL_DefSlv),
	.HREADY      	(HREADY),
	             	
	.HREADYOUT   	(HREADY_DefSlv),
	.HRESP       	(HRESP_DefSlv)
);

//------------------------------------------------------------------------------
// AHB Masster-to-Slave Mux
//------------------------------------------------------------------------------
MuxM2S uMuxM2S (
	.HMASTER 		(HMASTER),
	.HMASTERD		(HMASTERD),
	         		
	.HADDRM1 		(HADDR_M1),
	.HTRANSM1		(HTRANS_M1),
	.HWRITEM1		(HWRITE_M1),
	.HSIZEM1 		(HSIZE_M1),
	.HBURSTM1		(HBURST_M1),
	.HPROTM1 		(HPROT_M1),
	.HWDATAM1		(HWDATA_M1),
	         		
	.HADDRM2 		(HADDR_M2),
	.HTRANSM2		(HTRANS_M2),
	.HWRITEM2		(HWRITE_M2),
	.HSIZEM2 		(HSIZE_M2),
	.HBURSTM2		(HBURST_M2),
	.HPROTM2 		(HPROT_M2),
	.HWDATAM2		(HWDATA_M2),
	         		
	.HADDRM3 		(HADDR_M3),
	.HTRANSM3		(HTRANS_M3),
	.HWRITEM3		(HWRITE_M3),
	.HSIZEM3 		(HSIZE_M3),
	.HBURSTM3		(HBURST_M3),
	.HPROTM3 		(HPROT_M3),
	.HWDATAM3		(HWDATA_M3),
	         		
	.HADDR   		(HADDR),
	.HTRANS  		(HTRANS),
	.HWRITE  		(HWRITE),
	.HSIZE   		(HSIZE),
	.HBURST  		(HBURST),
	.HPROT   		(HPROT),
	.HWDATA  		(HWDATA)
);
  
//------------------------------------------------------------------------------
// AHB Slave-to-Master Mux
//------------------------------------------------------------------------------
MuxS2M uMuxS2M (
	.HCLK         	(HCLK),
	.HRESETn      	(HRESETn),
	              	
	.HSELS0       	(HSEL_S0),
	.HSELS1       	(HSEL_S1),
	.HSELS2       	(HSEL_S2),
	.HSELS3       	(HSEL_S3),
	.HSELDefault  	(HSEL_DefSlv),
	              	
	.HRDATAS0     	(HRDATA_S0),
	.HREADYS0     	(HREADY_S0),
	.HRESPS0      	(HRESP_S0),
	              	
	.HRDATAS1     	(HRDATA_S1),
	.HREADYS1     	(HREADY_S1),
	.HRESPS1      	(HRESP_S1),
	              	
	.HRDATAS2     	(HRDATA_S2),
	.HREADYS2     	(HREADY_S2),
	.HRESPS2      	(HRESP_S2),
	              	
	.HRDATAS3     	(HRDATA_S3),
	.HREADYS3     	(HREADY_S3),
	.HRESPS3      	(HRESP_S3),
	              	
	.HREADYDefault	(HREADY_DefSlv),
	.HRESPDefault 	(HRESP_DefSlv),
	              	
	.HRDATA       	(HRDATA),
	.HREADY       	(HREADY),
	.HRESP        	(HRESP)
);

endmodule
