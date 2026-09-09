// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SMC_TOP.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : sram controller
//  =============================================================================

`timescale 1ns/10ps
`include "SMC.vh"

module SMC_TOP(
	//AXI SIGNAL
	ACLK      ,
	ARESETn   ,

	// Write Address Channel
	AWID     ,
	AWADDR   ,
	AWLEN    ,
	AWSIZE   ,
	AWBURST  ,
	AWVALID  ,
	AWREADY  ,

	// Write Data Channel
	WID      ,
	WDATA    ,
	WSTRB    ,
	WLAST    ,
	WVALID   ,
	WREADY   ,

	// Write Response Channel
	BID      ,
	BRESP    ,
	BVALID   ,
	BREADY   ,

	// Read Address Channel
	ARID     ,
	ARADDR   ,
	ARLEN    ,
	ARSIZE   ,
	ARBURST  ,
	ARVALID  ,
	ARREADY  ,

	// Read Data Channel
	RID      ,
	RDATA    ,
	RRESP    ,
	RLAST    ,
	RVALID   ,
	RREADY   ,

    BOOT_WIDTH , 

    //APB SIGNAL
	PCLK      ,
	PRESETn   ,
	PADDR     ,
	PSEL      ,
	PENABLE   ,
	PWRITE    ,
	PWDATA    ,
	PRDATA    ,

	EXT_ADDR  ,
	EXT_WDATA ,
	EXT_RDATA ,
	EXT_CSb   ,
	EXT_OEb   ,
	EXT_WEb   ,
	EXT_BEb   ,
	EXT_WBEb  ,
	EXT_BIDEN );
		
//
// module parameter
//
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

input				ACLK      ;
input				ARESETn   ;

input  [WID_WIDTH-1:0] AWID;
input  [31:0]          AWADDR;
input  [3:0]           AWLEN;
input  [2:0]           AWSIZE;
input  [1:0]           AWBURST;
input                  AWVALID;
output                 AWREADY;

input  [WID_WIDTH-1:0] WID;
input  [31:0]          WDATA;
input  [3:0]           WSTRB;
input                  WLAST;
input                  WVALID;
output                 WREADY;

output [WID_WIDTH-1:0] BID;
output [1:0]           BRESP;
output                 BVALID;
input                  BREADY;

input  [RID_WIDTH-1:0] ARID;
input  [31:0]          ARADDR;
input  [3:0]           ARLEN;
input  [2:0]           ARSIZE;
input  [1:0]           ARBURST;
input                  ARVALID;
output                 ARREADY;

output [RID_WIDTH-1:0] RID;
output [31:0]          RDATA;
output [1:0]           RRESP;
output                 RLAST;
output                 RVALID;
input                  RREADY;

input [ 1:0]        BOOT_WIDTH;
//APB SIGN      	          
input				PCLK      ;
input				PRESETn   ;
input [ 5:2]		PADDR     ;
input				PSEL      ;
input				PENABLE   ;
input				PWRITE    ;
input [31:0]		PWDATA    ;
output[31:0]  		PRDATA    ;


output[26:0]		EXT_ADDR  ;
output[31:0]		EXT_WDATA ;
input [31:0]		EXT_RDATA ;
output[`BANK_SIZE-1:0]EXT_CSb   ;
output				EXT_OEb   ;
output				EXT_WEb   ;
output[ 3:0]		EXT_BEb   ;
output[ 3:0]		EXT_WBEb  ;
output				EXT_BIDEN ;
                	
//APB SIGNAL
wire				PCLK      ;
wire				PRESETn   ;
wire[ 5:2]			PADDR     ;
wire				PSEL      ;
wire				PENABLE   ;
wire				PWRITE    ;
wire[31:0]			PWDATA    ;
wire[31:0]  		PRDATA    ;

//SRAM INTERFACE SIGNAL
wire[26:0]			EXT_ADDR  ;
wire[31:0]			EXT_WDATA ;
wire[31:0]			EXT_RDATA ;
wire[`BANK_SIZE-1:0]EXT_CSb   ;
wire				EXT_OEb   ;
wire				EXT_WEb   ;
wire[ 3:0]			EXT_BEb   ;
wire[ 3:0]			EXT_WBEb  ;
wire				EXT_BIDEN ;

//SRAM_CTRL SIGNAL
wire				SMC_READY	  ;
wire[31:0]			SMC_RDATA     ;
wire[26:0]			SMC_ADDR      ;
wire[31:0]			SMC_WDATA     ;
wire				SMC_WRITE     ;
wire[3:0]			SMC_WBEB      ;
wire[`BANK_SIZE-1:0]SMC_BANK_SEL  ;
wire				SMC_SRAM_START;
wire[ 2:0]			SMC_TRANS_SIZE;

//REG setting value
wire[ 2:0]			ADDR_SETUP;
wire[ 2:0]			ADDR_HOLD ;
wire[ 2:0]			CS_SETUP  ;
wire[ 2:0]	 		CS_HOLD   ;
wire[ 3:0]			ACC_CYCLE ;
wire[ 1:0]			BUS_WIDTH ;
wire[ 1:0]			ADDR_SHIFT;	


SMC_REG	uSMC_REG(
        .BOOT_WIDTH (BOOT_WIDTH ),
		.PCLK		(PCLK		),	 	
		.PRESETn 	(PRESETn 	),   
		.PADDR   	(PADDR   	),   
		.PSEL    	(PSEL    	),   
		.PENABLE 	(PENABLE 	),   
		.PWRITE  	(PWRITE  	),   
		.PWDATA  	(PWDATA  	),   
		.PRDATA  	(PRDATA  	),   
		                             
		.SRAM_START (SMC_SRAM_START ),   
		.BANK_SEL	(SMC_BANK_SEL	),   
		//REG_VAL_OUT                
		.ADDR_SETUP (ADDR_SETUP ),   
		.ADDR_HOLD  (ADDR_HOLD  ),   
		.CS_SETUP   (CS_SETUP   ),   
		.CS_HOLD    (CS_HOLD    ),   
		.ACC_CYCLE  (ACC_CYCLE  ),   
		.BUS_WIDTH  (BUS_WIDTH  ),   
		.ADDR_SHIFT (ADDR_SHIFT ));  


/*
AHB_interface uAHB_interface(
		.HCLK       (HCLK 		),             
		.HRESETn    (HRESETn    ),              
		.HADDR      (HADDR      ),              
		.HTRANS     (HTRANS     ),              
		.HWRITE     (HWRITE     ),              
		.HSIZE      (HSIZE      ),       
		.HWDATA     (HWDATA     ),       
		.HSEL0      (HSEL0      ),       
		.HSEL1      (HSEL1      ),       
		.HSEL2      (HSEL2      ),       
		.HSEL3      (HSEL3      ),       
		.HREADY_in  (HREADY_in  ),       
		.HREADY_out (HREADY_out ),       
		.HRESP      (HRESP      ),       
		.HRDATA     (HRDATA	    ),
		
		.READY	    (READY	  	),
		.RDATA      (RDATA    	),
		.ADDR       (ADDR       ),
		.WDATA      (WDATA      ),
		.WRITE      (WRITE      ),
		.READ       (READ	    ),
		.BANK_SEL   (BANK_SEL   ),
		.SRAM_START (SRAM_START ),
		.TRANS_SIZE (TRANS_SIZE ));       	  		
*/
AXI_ESMC_interface
	#(.WID_WIDTH(WID_WIDTH), .RID_WIDTH(RID_WIDTH))
	uAXI_interface(
		.ACLK			(ACLK),
		.ARESETn		(ARESETn),
		// Write Address Channel
		.AWID			(AWID),
		.AWADDR			(AWADDR),
		.AWLEN			(AWLEN),
		.AWSIZE			(AWSIZE),
		.AWBURST		(AWBURST),
		.AWVALID		(AWVALID),
		.AWREADY		(AWREADY),

		// Write Data Channel
		.WID			(WID),
		.WDATA			(WDATA),
		.WSTRB			(WSTRB),
		.WLAST			(WLAST),
		.WVALID			(WVALID),
		.WREADY			(WREADY),

		// Write Response Channel
		.BID			(BID),
		.BRESP			(BRESP),
		.BVALID			(BVALID),
		.BREADY			(BREADY),

		// Read Address Channel
		.ARID			(ARID),
		.ARADDR			(ARADDR),
		.ARLEN			(ARLEN),
		.ARSIZE			(ARSIZE),
		.ARBURST		(ARBURST),
		.ARVALID		(ARVALID),
		.ARREADY		(ARREADY),

		// Read Data Channel
		.RID			(RID),
		.RDATA			(RDATA),
		.RRESP			(RRESP),
		.RLAST			(RLAST),
		.RVALID			(RVALID),
		.RREADY			(RREADY),

//	SRAM_CTRL Interface
		.SMC_READY		(SMC_READY),
		.SMC_RDATA		(SMC_RDATA),
		.SMC_ADDR		(SMC_ADDR),
		.SMC_WDATA		(SMC_WDATA),
		.SMC_WBEB		(SMC_WBEB),
		.SMC_WRITE		(SMC_WRITE),
		.SMC_READ		(SMC_READ),
		.SMC_BANK_SEL	(SMC_BANK_SEL),
		.SMC_SRAM_START	(SMC_SRAM_START),
		.SMC_TRANS_SIZE	(SMC_TRANS_SIZE[1:0])
		);

SRAM_CTRL uSRAM_CTRL(
		.CLK       	(ACLK       ),	 	
		.RSTb      	(ARESETn    ),	 	
		.ADDR      	(SMC_ADDR       ),	 	
		.WRITE     	(SMC_WRITE      ),	 	
		.READ	   	(SMC_READ	   	),    	
		.WDATA     	(SMC_WDATA      ),	 	
		.WBEB     	(SMC_WBEB      ),	 	
		.TRANS_SIZE	({1'b0, SMC_TRANS_SIZE[1:0]} ),	 	
		.BANK_SEL  	(SMC_BANK_SEL   ),	 	
		.SRAM_START	(SMC_SRAM_START ),      
		.ADDR_SETUP	(ADDR_SETUP ),	 	
		.ADDR_HOLD 	(ADDR_HOLD  ),	 	
		.CS_SETUP  	(CS_SETUP   ),	 	
		.CS_HOLD   	(CS_HOLD    ),	 	
		.ACC_CYCLE 	(ACC_CYCLE  ),	 	
		.BUS_WIDTH 	(BUS_WIDTH  ),	 	
		.ADDR_SHIFT	(ADDR_SHIFT ),	 	
		.READY     	(SMC_READY      ),	 	
		.RDATA     	(SMC_RDATA      ),	 	
		          		 	
		.EXT_ADDR  	(EXT_ADDR   ),	 	
		.EXT_WDATA 	(EXT_WDATA  ),	 	
		.EXT_RDATA 	(EXT_RDATA  ),	 	
		.EXT_CSb   	(EXT_CSb    ),	 	
		.EXT_WEb   	(EXT_WEb    ),	 	
		.EXT_OEb   	(EXT_OEb    ),	 	
		.EXT_BEb   	(EXT_BEb    ),	 	
		.EXT_WBEb  	(EXT_WBEb   ),	 	
		.EXT_BIDEN 	(EXT_BIDEN	));    	
        
endmodule
