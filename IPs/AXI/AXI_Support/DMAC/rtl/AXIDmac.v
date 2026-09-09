
// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB2AHB.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : APB2AHB glue logic for DMAC
//                     : This module is NOT a generation APB-to-AHB interface.
//  =============================================================================

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module AXIDmac (
             // Clock and reset
             ACLK,
             ARESETn,
			// APB signals
             PADDR,
             PWRITE,
             PSEL,
             PENABLE,
             PRDATA,
             PWDATA,
             PREADY,

			// AXI Interface 1
			// Write Address Channel
             AWADDR1,
             AWLEN1,
             AWSIZE1,
             AWBURST1,
             AWLOCK1,
             AWCACHE1,
             AWPROT1,
             AWVALID1,
             AWREADY1,
	
			// Write Data Channel
             WDATA1,
             WSTRB1,
             WLAST1,
             WVALID1,
             WREADY1,

			// Write Response Channel
             BRESP1,
             BVALID1,
             BREADY1,

			// Read Address Channel
             ARADDR1,
             ARLEN1,
             ARSIZE1,
             ARBURST1,
             ARLOCK1,
             ARCACHE1,
             ARPROT1,
             ARVALID1,
             ARREADY1,

			// Read Data Channel
             RDATA1,
             RRESP1,
             RLAST1,
             RVALID1,
             RREADY1,

			// AXI Interface 2
			// Write Address Channel
             AWADDR2,
             AWLEN2,
             AWSIZE2,
             AWBURST2,
             AWLOCK2,
             AWCACHE2,
             AWPROT2,
             AWVALID2,
             AWREADY2,
	
			// Write Data Channel
             WDATA2,
             WSTRB2,
             WLAST2,
             WVALID2,
             WREADY2,

			// Write Response Channel
             BRESP2,
             BVALID2,
             BREADY2,

			// Read Address Channel
             ARADDR2,
             ARLEN2,
             ARSIZE2,
             ARBURST2,
             ARLOCK2,
             ARCACHE2,
             ARPROT2,
             ARVALID2,
             ARREADY2,

			// Read Data Channel
             RDATA2,
             RRESP2,
             RLAST2,
             RVALID2,
             RREADY2,

             // DMA request signals
             DMACBREQ,
             DMACLBREQ,
             DMACSREQ,
             DMACLSREQ,

             // DMA response signals
             DMACCLR,
             DMACTC,
             // DMA interrupt request signals
             DMACINTERR,
             DMACINTTC,
             DMACINTR
            );

// Inputs
// Clock and reset
input         ACLK;             // AXI clock
input         ARESETn;          // AXI reset

// AHB slave signals
input [11:2]  PADDR;
input         PWRITE;
input         PSEL;
input         PENABLE;
output [31:0] PRDATA;
input  [31:0] PWDATA;
output        PREADY;

// AXI Interface 1
output [31:0] AWADDR1;
output [3:0]  AWLEN1;
output [2:0]  AWSIZE1;
output [1:0]  AWBURST1;
output [1:0]  AWLOCK1;
output [3:0]  AWCACHE1;
output [2:0]  AWPROT1;
output        AWVALID1;
input         AWREADY1;

output [31:0] WDATA1;
output [3:0]  WSTRB1;
output        WLAST1;
output        WVALID1;
input         WREADY1;


input  [1:0]  BRESP1;
input         BVALID1;
output        BREADY1;

output [31:0] ARADDR1;
output [3:0]  ARLEN1;
output [2:0]  ARSIZE1;
output [1:0]  ARBURST1;
output [1:0]  ARLOCK1;
output [3:0]  ARCACHE1;
output [2:0]  ARPROT1;
output        ARVALID1;
input         ARREADY1;

input  [31:0] RDATA1;
input  [1:0]  RRESP1;
input         RLAST1;
input         RVALID1;
output        RREADY1;

// AXI Interface 2
output [31:0] AWADDR2;
output [3:0]  AWLEN2;
output [2:0]  AWSIZE2;
output [1:0]  AWBURST2;
output [1:0]  AWLOCK2;
output [3:0]  AWCACHE2;
output [2:0]  AWPROT2;
output        AWVALID2;
input         AWREADY2;

output [31:0] WDATA2;
output [3:0]  WSTRB2;
output        WLAST2;
output        WVALID2;
input         WREADY2;


input  [1:0]  BRESP2;
input         BVALID2;
output        BREADY2;

output [31:0] ARADDR2;
output [3:0]  ARLEN2;
output [2:0]  ARSIZE2;
output [1:0]  ARBURST2;
output [1:0]  ARLOCK2;
output [3:0]  ARCACHE2;
output [2:0]  ARPROT2;
output        ARVALID2;
input         ARREADY2;

input  [31:0] RDATA2;
input  [1:0]  RRESP2;
input         RLAST2;
input         RVALID2;
output        RREADY2;

// DMA request signals
input  [15:0] DMACBREQ;         // DMA burst transfer request
input  [15:0] DMACLBREQ;        // DMA last burst transfer request
input  [15:0] DMACSREQ;         // DMA single transfer request
input  [15:0] DMACLSREQ;        // DMA last single transfer request

// DMA response signals
output [15:0] DMACCLR;          // DMA request clear
output [15:0] DMACTC;           // DMA terminal count
// DMA interrupt request signals
output        DMACINTERR;       // DMA error interrupt request
output        DMACINTTC;        // DMA terminal count interrupt request
output        DMACINTR;         // DMA combined interrupt request

// Inputs
// Clock and reset
wire          HCLK;             // AHB clock
wire          HRESETn;          // AHB reset
// AHB slave signals
wire          HSELDMAC;         // Slave Select for DMAC
wire          HWRITE;           // Transfer direction
wire          HTRANS;           // Type of transfer on AHB Only HTRANS(1)
                                // of the slave AHB should connect
wire   [11:2] HADDR;            // AHB address bus
wire    [2:0] HSIZE;            // The width of the transfer on AHB
wire          HREADYIN;         // Transfer done response on AHB from
                                // previous Slave
wire   [31:0] HWDATA;           // AHB slave write data
// AHB master signals
wire          HGRANTDMACM1;     // AHB bus grant for master1
wire          HGRANTDMACM2;     // AHB bus grant for master2
wire          HREADYINM1;       // Transfer done response from AHB 1
wire          HREADYINM2;       // Transfer done response from AHB 2
wire    [1:0] HRESPM1;          // Transfer response from AHB 1
wire    [1:0] HRESPM2;          // Transfer response from AHB 2
wire   [31:0] HRDATAM1;         // Read Data from AHB 1
wire   [31:0] HRDATAM2;         // Read Data from AHB 2
// DMA request signals
wire   [15:0] DMACBREQ;         // DMA burst transfer request
wire   [15:0] DMACLBREQ;        // DMA last burst transfer request
wire   [15:0] DMACSREQ;         // DMA single transfer request
wire   [15:0] DMACLSREQ;        // DMA last single transfer request

// Outputs
// AHB slave signals
wire          HREADYOUT;        // Transfer done response to AHB
wire    [1:0] HRESP;            // Transfer response to AHB
wire   [31:0] HRDATA;           // Read data bus to AHB
// AHB master signals
wire          HBUSREQDMACM1;    // Bus request signal to the AHB arbiter 1
wire          HBUSREQDMACM2;    // Bus request signal to the AHB arbiter 2
wire          HLOCKDMACM1;      // Indicates locked-burst request on AHB 1
wire          HLOCKDMACM2;      // Indicates locked-burst request on AHB 2
wire    [1:0] HTRANSM1;         // Type of transfer on AHB1
wire    [1:0] HTRANSM2;         // Type of transfer on AHB2
wire   [31:0] HADDRM1;          // AHB1 address bus
wire   [31:0] HADDRM2;          // AHB2 address bus
wire    [2:0] HSIZEM1;          // Width of transfer on AHB1
wire    [2:0] HSIZEM2;          // Width of transfer on AHB2
wire    [2:0] HBURSTM1;         // Burst length on AHB1
wire    [2:0] HBURSTM2;         // Burst length on AHB2
wire    [3:0] HPROTM1;          // Protection information on AHB1
wire    [3:0] HPROTM2;          // Protection information on AHB2
wire          HWRITEM1;         // Transfer direction on AHB1
wire          HWRITEM2;         // Transfer direction on AHB2
wire   [31:0] HWDATAM1;         // Write data to AHB1
wire   [31:0] HWDATAM2;         // Write data to AHB2
// DMA response signals
wire   [15:0] DMACCLR;          // DMA request clear
wire   [15:0] DMACTC;           // DMA terminal count
// DMA interrupt request signals
wire          DMACINTERR;       // DMA error interrupt request
wire          DMACINTTC;        // DMA terminal count interrupt request
wire          DMACINTR;         // DMA combined interrupt request

// -----------------------------------------------------------------------------
// Instantiation of Dmac
// -----------------------------------------------------------------------------
Dmac DmacCore(
// Inputs
             // Clock and reset
             .HCLK(ACLK),
             .HRESETn(ARESETn),
             // AHB slave signals
             .HSELDMAC(HSELDMAC),
             .HWRITE(HWRITE),
             .HTRANS(HTRANS),
             .HADDR(HADDR),
             .HSIZE(HSIZE),
             .HREADYIN(HREADYIN),
             .HWDATA(HWDATA),
             // AHB master signals
             .HGRANTDMACM1(1'b1),	// always granted
             .HGRANTDMACM2(1'b1),	// always granted
             .HREADYINM1(HREADYINM1),
             .HREADYINM2(HREADYINM2),
             .HRESPM1(HRESPM1),
             .HRESPM2(HRESPM2),
             .HRDATAM1(HRDATAM1),
             .HRDATAM2(HRDATAM2),
             // DMA request signals
             .DMACBREQ(DMACBREQ),
             .DMACLBREQ(DMACLBREQ),
             .DMACSREQ(DMACSREQ),
             .DMACLSREQ(DMACLSREQ),
             // Scan related signals
             .SCANINHCLK(1'b0),
             .SCANENABLE(1'b0),

// Outputs
             // AHB slave signals
             .HREADYOUT(HREADYOUT),
             .HRESP(HRESP),
             .HRDATA(HRDATA),
             // AHB master signals
             .HBUSREQDMACM1(HBUSREQDMACM1),
             .HBUSREQDMACM2(HBUSREQDMACM2),
             .HLOCKDMACM1(HLOCKDMACM1),
             .HLOCKDMACM2(HLOCKDMACM2),
             .HTRANSM1(HTRANSM1),
             .HTRANSM2(HTRANSM2),
             .HADDRM1(HADDRM1),
             .HADDRM2(HADDRM2),
             .HSIZEM1(HSIZEM1),
             .HSIZEM2(HSIZEM2),
             .HBURSTM1(HBURSTM1),
             .HBURSTM2(HBURSTM2),
             .HPROTM1(HPROTM1),
             .HPROTM2(HPROTM2),
             .HWRITEM1(HWRITEM1),
             .HWRITEM2(HWRITEM2),
             .HWDATAM1(HWDATAM1),
             .HWDATAM2(HWDATAM2),
             // DMA response signals
             .DMACCLR(DMACCLR),
             .DMACTC(DMACTC),
             // DMA interrupt request signals
             .DMACINTERR(DMACINTERR),
             .DMACINTTC(DMACINTTC),
             .DMACINTR(DMACINTR),
             // Scan related signals
             .SCANOUTHCLK()
            );

APB2AHB APB2AHB(
			.CLK(ACLK),
			.RESETn(ARESETn),

			.PADDR(PADDR),
			.PWRITE(PWRITE),
			.PSEL(PSEL),
			.PENABLE(PENABLE),
			.PRDATA(PRDATA),
			.PWDATA(PWDATA),
			.PREADY(PREADY),

			.HSEL(HSELDMAC),
			.HWRITE(HWRITE),
			.HTRANS(HTRANS),
			.HADDR(HADDR),
			.HSIZE(HSIZE),
			.HREADYIN(HREADYIN),
			.HWDATA(HWDATA),
			.HREADYOUT(HREADYOUT),
			.HRESP(HRESP),
			.HRDATA(HRDATA)
);

AHB2AXIBridge  AXIIF1
(
		//	Common Interface
			.CLK(ACLK),
			.RESETn(ARESETn),

		// AHB Interface
			.HADDR(HADDRM1),
			.HTRANS(HTRANSM1),
			.HWRITE(HWRITEM1),
			.HSIZE(HSIZEM1),
			.HBURST(HBURSTM1),
			.HPROT(HPROTM1),
			.HWDATA(HWDATAM1),
			.HRDATA(HRDATAM1),
			.HREADY_IN(HREADYINM1),
			.HREADY_OUT(HREADYINM1),
			.HRESP(HRESPM1),

			.HSEL(1'b1),		// always selected
			.HMASTLOCK(1'b0),	// always NOT Locked

		// AXI Interface
		// Write Address Channel
			.AWADDR(AWADDR1),
			.AWLEN(AWLEN1),
			.AWSIZE(AWSIZE1),
			.AWBURST(AWBURST1),
			.AWLOCK(AWLOCK1),
			.AWCACHE(AWCACHE1),
			.AWPROT(AWPROT1),
			.AWVALID(AWVALID1),
			.AWREADY(AWREADY1),
	
		// Write Data Channel
			.WDATA(WDATA1),
			.WSTRB(WSTRB1),
			.WLAST(WLAST1),
			.WVALID(WVALID1),
			.WREADY(WREADY1),

		// Write Response Channel
			.BRESP(BRESP1),
			.BVALID(BVALID1),
			.BREADY(BREADY1),

		// Read Address Channel
			.ARADDR(ARADDR1),
			.ARLEN(ARLEN1),
			.ARSIZE(ARSIZE1),
			.ARBURST(ARBURST1),
			.ARLOCK(ARLOCK1),
			.ARCACHE(ARCACHE1),
			.ARPROT(ARPROT1),
			.ARVALID(ARVALID1),
			.ARREADY(ARREADY1),

		// Read Data Channel
			.RDATA(RDATA1),
			.RRESP(RRESP1),
			.RLAST(RLAST1),
			.RVALID(RVALID1),
			.RREADY(RREADY1)
);

AHB2AXIBridge  AXIIF2
(
		//	Common Interface
			.CLK(ACLK),
			.RESETn(ARESETn),

		// AHB Interface
			.HADDR(HADDRM2),
			.HTRANS(HTRANSM2),
			.HWRITE(HWRITEM2),
			.HSIZE(HSIZEM2),
			.HBURST(HBURSTM2),
			.HPROT(HPROTM2),
			.HWDATA(HWDATAM2),
			.HRDATA(HRDATAM2),
			.HREADY_IN(HREADYINM2),
			.HREADY_OUT(HREADYINM2),
			.HRESP(HRESPM2),

			.HSEL(1'b1),		// always selected
			.HMASTLOCK(1'b0),	// always NOT Locked

		// AXI Interface
		// Write Address Channel
			.AWADDR(AWADDR2),
			.AWLEN(AWLEN2),
			.AWSIZE(AWSIZE2),
			.AWBURST(AWBURST2),
			.AWLOCK(AWLOCK2),
			.AWCACHE(AWCACHE2),
			.AWPROT(AWPROT2),
			.AWVALID(AWVALID2),
			.AWREADY(AWREADY2),
	
		// Write Data Channel
			.WDATA(WDATA2),
			.WSTRB(WSTRB2),
			.WLAST(WLAST2),
			.WVALID(WVALID2),
			.WREADY(WREADY2),

		// Write Response Channel
			.BRESP(BRESP2),
			.BVALID(BVALID2),
			.BREADY(BREADY2),

		// Read Address Channel
			.ARADDR(ARADDR2),
			.ARLEN(ARLEN2),
			.ARSIZE(ARSIZE2),
			.ARBURST(ARBURST2),
			.ARLOCK(ARLOCK2),
			.ARCACHE(ARCACHE2),
			.ARPROT(ARPROT2),
			.ARVALID(ARVALID2),
			.ARREADY(ARREADY2),

		// Read Data Channel
			.RDATA(RDATA2),
			.RRESP(RRESP2),
			.RLAST(RLAST2),
			.RVALID(RVALID2),
			.RREADY(RREADY2)
);

endmodule
// --================================== End ==================================--
