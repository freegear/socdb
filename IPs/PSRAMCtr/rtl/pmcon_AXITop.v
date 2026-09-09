module pmcon_AXITop
(
//      AXI Interface
                ACLK     ,
                ARESETn  ,
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
		//---------------Register setting APB bus
     		   	R_PCLK   ,
        		R_PSEL   ,
       			R_PENABLE,

		      	R_PWRITE ,
        		R_PADDR  ,
       		 	R_PWDATA ,
        		R_PRDATA ,
      		//----------- PSRAM
                CSb      ,
                ZZb      ,
                OEb      ,
                WEb      ,
                UBb      ,
                LBb      ,

                ADDR     ,
                DATAIN   ,
                nDATAEN  ,
                DATAOUT

);


parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
// auto assign from above parameter
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

parameter ADDRESSWIDTH = 18;

`define RESP_OKAY       2'b00


//
// input/output port
//
input                  ACLK;
input                  ARESETn;

input  [WID_WIDTH-1:0] AWID;
input  [31:0]          AWADDR;
input  [3:0]           AWLEN;
input  [2:0]           AWSIZE;
input  [1:0]           AWBURST;
input                  AWVALID;
output                 AWREADY;

input  [WID_WIDTH-1:0] WID;
input  [31:0]          WDATA;
input  [3:0]   		   WSTRB;
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


            //---------------Register setting APB bus
input					R_PCLK   ;
input	                R_PSEL   ;
input	                R_PENABLE;

input	                R_PWRITE ;
input [1:0]             R_PADDR  ;
input [31:0]            R_PWDATA ;
output[31:0]            R_PRDATA ;
                //----------- PSRAM
output	                CSb     ;
output	                ZZb     ;
output	                OEb     ;
output	                WEb     ;
output	                UBb     ;
output	                LBb     ;

output	[ADDRESSWIDTH-1:0]  ADDR    ;

input	[15:0]          DATAIN  ;
output	                nDATAEN ;
output	[15:0]          DATAOUT ;

wire 	[31:0] 			PADDR;
wire	[31:0]			PRDATA;
wire	[31:0]			PWDATA;
wire	[3:0] 			PWSTRB;

pmcon_AXIIF #(  WID_WIDTH,
		RID_WIDTH,
		ID_WIDTH)
AXIPSRAMIF
(
//      AXI Interface    
                .ACLK     	(ACLK),
                .ARESETn  	(ARESETn),
                // Write Address Channel
                .AWID     	(AWID),
                .AWADDR   	(AWADDR),
                .AWLEN    	(AWLEN),
                .AWSIZE   	(AWSIZE),
                .AWBURST  	(AWBURST),
                .AWVALID  	(AWVALID),
                .AWREADY  	(AWREADY),

                // Write Data Channel
                .WID      	(WID),
                .WDATA    	(WDATA),
                .WSTRB      (WSTRB),
                .WLAST    	(WLAST),
                .WVALID   	(WVALID),
                .WREADY   	(WREADY),

                // Write Response Channel
                .BID      	(BID),
                .BRESP    	(BRESP),
                .BVALID   	(BVALID),
                .BREADY   	(BREADY),

                // Read Address Channel
                .ARID     	(ARID),
                .ARADDR   	(ARADDR),
                .ARLEN    	(ARLEN),
                .ARSIZE   	(ARSIZE),
                .ARBURST  	(ARBURST),
                .ARVALID  	(ARVALID),
                .ARREADY  	(ARREADY),

                // Read Data Channel
                .RID      	(RID),
                .RDATA   	(RDATA),
                .RRESP    	(RRESP),
                .RLAST    	(RLAST),
                .RVALID   	(RVALID),
                .RREADY   	(RREADY),

//      APB Interface // Dedicated PSRAM Controller Interface
                .PADDR    	(PADDR),
                .PWRITE   	(PWRITE),
                .PSEL     	(PSEL),
                .PENABLE  	(PENABLE),
				.PWSTRB		(PWSTRB),
                .PRDATA   	(PRDATA),
                .PREADY   	(PREADY),
                .PWDATA		(PWDATA)
);


pmcon_APBIF #(ADDRESSWIDTH)
PSRAMAPB3IF
(
        //------------------------------
        // AMBA3APB for momory access
        //------------------------------
	        .M_PCLK          (ACLK),
        	.PRESETn 	 	 (ARESETn),
	        .M_PSEL          (PSEL),
        	.M_PENABLE       (PENABLE),
	        .M_PREADY        (PREADY),

		.M_PWSTRB		 (PWSTRB),
	        .M_PWRITE        (PWRITE),
       		.M_PADDR         (PADDR[ADDRESSWIDTH:0]),
        	.M_PWDATA        (PWDATA),
        	.M_PRDATA        (PRDATA),

        //-----------------------------------
        // APB Interface for Register setting
        //-----------------------------------
        	.R_PCLK         (R_PCLK),
        	.R_PSEL         (R_PSEL),
       		.R_PENABLE      (R_PENABLE),

        	.R_PWRITE       (R_PWRITE),
        	.R_PADDR        (R_PADDR),
        	.R_PWDATA       (R_PWDATA),
        	.R_PRDATA       (R_PRDATA),


        //----------- PSRAM
        	.CSb            (CSb),
        	.ZZb            (ZZb),
        	.OEb            (OEb),
        	.WEb            (WEb),
        	.UBb            (UBb),
        	.LBb            (LBb),

        	.ADDR           (ADDR),
        	.DATAIN         (DATAIN),
        	.nDATAEN	(nDATAEN),
        	.DATAOUT	(DATAOUT)

);




endmodule


