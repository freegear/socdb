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
`define BANK_SIZE 4

module SMC_TOP(
	//AHB SIGNAL
	HCLK      ,
	HRESETn   ,
	HADDR     ,
	HTRANS    ,
	HWRITE    ,
	HSIZE	  ,
	HWDATA    ,
	HSEL0     ,
	HSEL1     ,
	HSEL2     ,
	HSEL3     ,
	HREADY_in ,
	HREADY_out,
	HRESP     ,
	HRDATA    ,
	
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
		
input				HCLK      ;
input				HRESETn   ;
input [19:0]		HADDR     ;
input [ 1:0]		HTRANS    ;
input				HWRITE    ;
input [ 2:0]		HSIZE	  ;
input [31:0]		HWDATA    ;
input				HSEL0     ;
input				HSEL1     ;
input				HSEL2     ;
input				HSEL3     ;
input				HREADY_in ;
output				HREADY_out;
output[ 1:0]		HRESP     ;
output[31:0]		HRDATA    ;
                	          
//APB SIGN      	          
input				PCLK      ;
input				PRESETn   ;
input [ 3:2]		PADDR     ;
input				PSEL      ;
input				PENABLE   ;
input				PWRITE    ;
input [31:0]		PWDATA    ;
output[31:0]  		PRDATA    ;
                	          
output[19:0]		EXT_ADDR  ;
output[31:0]		EXT_WDATA ;
input [31:0]		EXT_RDATA ;
output[ 3:0]		EXT_CSb   ;
output				EXT_OEb   ;
output				EXT_WEb   ;
output[ 3:0]		EXT_BEb   ;
output[ 3:0]		EXT_WBEb  ;
output				EXT_BIDEN ;
                	
//AHB SIGNAL    	
wire				HCLK      ;
wire				HRESETn   ;
wire[19:0]			HADDR     ;
wire[ 1:0]			HTRANS    ;
wire				HWRITE    ;
wire[ 2:0]			HSIZE	  ;
wire[31:0]			HWDATA    ;
wire				HSEL0     ;
wire				HSEL1     ;
wire				HSEL2     ;
wire				HSEL3     ;
wire				HREADY_in ;
wire				HREADY_out;
wire[ 1:0]			HRESP     ;
wire[31:0]			HRDATA    ;

//APB SIGNAL
wire				PCLK      ;
wire				PRESETn   ;
wire[ 2:3]			PADDR     ;
wire				PSEL      ;
wire				PENABLE   ;
wire				PWRITE    ;
wire[31:0]			PWDATA    ;
wire[31:0]  		PRDATA    ;

//SRAM INTERFACE SIGNAL
wire[19:0]			EXT_ADDR  ;
wire[31:0]			EXT_WDATA ;
wire[31:0]			EXT_RDATA ;
wire[ 3:0]			EXT_CSb   ;
wire				EXT_OEb   ;
wire				EXT_WEb   ;
wire[ 3:0]			EXT_BEb   ;
wire[ 3:0]			EXT_WBEb  ;
wire				EXT_BIDEN ;

//SRAM_CTRL SIGNAL
wire				READY	  ;
wire[31:0]			RDATA     ;
wire[19:0]			ADDR      ;
wire[31:0]			WDATA     ;
wire				WRITE     ;
wire[`BANK_SIZE-1:0]BANK_SEL  ;
wire				SRAM_START;
wire[ 2:0]			TRANS_SIZE;

//REG setting value
wire[ 2:0]			ADDR_SETUP;
wire[ 2:0]			ADDR_HOLD ;
wire[ 2:0]			CS_SETUP  ;
wire[ 2:0]	 		CS_HOLD   ;
wire[ 3:0]			ACC_CYCLE ;
wire[ 1:0]			BUS_WIDTH ;
wire[ 1:0]			ADDR_SHIFT;	


SMC_REG	uSMC_REG(
		.PCLK		(PCLK		),	 	
		.PRESETn 	(PRESETn 	),   
		.PADDR   	(PADDR   	),   
		.PSEL    	(PSEL    	),   
		.PENABLE 	(PENABLE 	),   
		.PWRITE  	(PWRITE  	),   
		.PWDATA  	(PWDATA  	),   
		.PRDATA  	(PRDATA  	),   
		                             
		.SRAM_START (SRAM_START ),   
		.BANK_SEL	(BANK_SEL	),   
		//REG_VAL_OUT                
		.ADDR_SETUP (ADDR_SETUP ),   
		.ADDR_HOLD  (ADDR_HOLD  ),   
		.CS_SETUP   (CS_SETUP   ),   
		.CS_HOLD    (CS_HOLD    ),   
		.ACC_CYCLE  (ACC_CYCLE  ),   
		.BUS_WIDTH  (BUS_WIDTH  ),   
		.ADDR_SHIFT (ADDR_SHIFT ));  


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

SRAM_CTRL uSRAM_CTRL(
		.CLK       	(HCLK       ),	 	
		.RSTb      	(HRESETn    ),	 	
		.ADDR      	(ADDR       ),	 	
		.WRITE     	(WRITE      ),	 	
		.READ	   	(READ	   	),    	
		.WDATA     	(WDATA      ),	 	
		.TRANS_SIZE	(TRANS_SIZE ),	 	
		.BANK_SEL  	(BANK_SEL   ),	 	
		.SRAM_START	(SRAM_START ),      
		.ADDR_SETUP	(ADDR_SETUP ),	 	
		.ADDR_HOLD 	(ADDR_HOLD  ),	 	
		.CS_SETUP  	(CS_SETUP   ),	 	
		.CS_HOLD   	(CS_HOLD    ),	 	
		.ACC_CYCLE 	(ACC_CYCLE  ),	 	
		.BUS_WIDTH 	(BUS_WIDTH  ),	 	
		.ADDR_SHIFT	(ADDR_SHIFT ),	 	
		.READY     	(READY      ),	 	
		.RDATA     	(RDATA      ),	 	
		          		 	
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
