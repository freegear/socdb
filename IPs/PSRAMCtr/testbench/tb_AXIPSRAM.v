`timescale 1 ns / 10ps
module tb_AXI2PSRAM;
parameter CLK_HALFPERIOD=5;

parameter DATA_WIDTH = 32;      // only support 32 now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;

parameter CNT_WIDTH = 32;        // I think it is sufficient
parameter ADDRESSWIDTH = 22;

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

`define SIZE_BYTE       3'b000
`define SIZE_HWORD      3'b001
`define SIZE_WORD       3'b010
`define SIZE_DWORD      3'b011

`define BURST_FIXED     2'b00
`define BURST_INCR      2'b01    
`define BURST_WRAP      2'b10

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset

wire [WID_WIDTH-1:0]  AWID;
wire [31:0]           AWADDR;
wire [3:0]            AWLEN;
wire [2:0]            AWSIZE;
wire [1:0]            AWBURST;
wire                  AWVALID;
wire                  AWREADY;

wire [WID_WIDTH-1:0]  WID;
wire [DATA_WIDTH-1:0] WDATA;
wire [NUM_BYTE-1:0]   WSTRB;
wire                  WLAST;
wire                  WVALID;
wire                  WREADY;

wire [WID_WIDTH-1:0]  BID;
wire [1:0]            BRESP;
wire                  BVALID;
wire                  BREADY;

wire [RID_WIDTH-1:0]  ARID;
wire [31:0]           ARADDR;
wire [3:0]            ARLEN;
wire [2:0]            ARSIZE;
wire [1:0]            ARBURST;
wire                  ARVALID;
wire                  ARREADY;

wire [RID_WIDTH-1:0]  RID;
wire [DATA_WIDTH-1:0] RDATA;
wire [1:0]            RRESP;
wire                  RLAST;
wire                  RVALID;
wire                  RREADY;

            //---------------Register setting APB bus
reg                   R_PCLK   ;
reg                   R_PSEL   ;
reg                   R_PENABLE;

reg                   R_PWRITE ;
reg [1:0]             R_PADDR  ;
reg [31:0]            R_PWDATA ;
wire[31:0]            R_PRDATA ;
                //----------- PSRAM
wire                  CSb      ;
wire                  ZZb      ;
wire                  OEb      ;
wire                  WEb      ;
wire                  UBb      ;
wire                  LBb      ;

wire  [ADDRESSWIDTH-1:0]            ADDR     ;


tri     [15:0]  DATA;   
wire    [15:0]  DATAIN;
wire    [15:0]  DATAOUT;
wire            nDATAEN;

assign  DATAIN = DATA;
assign  DATA = nDATAEN ? 16'bzzzzzzzzzzzzzzzz :DATAOUT;


reg	RESETn;


always #CLK_HALFPERIOD  ACLK = ~ACLK;

initial ACLK            = 0;     // clock
initial
begin
		RESETn			= 0;
        ARESETn         = 0;     // reset
		
        repeat(10) @(posedge ACLK);
		RESETn 			= 1;
		#500000 /// for psram initial done
        ARESETn = 1;
end


initial 
	begin
	// register APB signal
	R_PSEL   =  0;
    R_PENABLE=  0;
    R_PWRITE =  0;
    R_PADDR  =  0;
    R_PWDATA =  0;
	R_PCLK	 =  0;
	end
`define psramcon    0
`define psramtcon   1
`define psramtout   2
`define Enable      32'b1
`define PageSize    32'b111
`define BurstRMode  32'b1
`define PowerUp     32'b1

`define tRC         32'b1111
`define tAA         32'b1111
`define tPRC        32'b111
`define tPA         32'b111
`define tWC         32'b1111
`define tAS         32'b11
`define tWP         32'b1111
`define tDW         32'b1111
`define tDH         32'b1111


always  # (2*CLK_HALFPERIOD) R_PCLK = ~R_PCLK;
integer rvalue;
initial 
begin
 #100
    $display ("Register Default Value Check!!\n");
    $display ("PSRAMCON Register Default Value Check!!");
    REG_Read(`psramcon);
    $display ("PSRAMTCON Register Default Value Check!!");
    REG_Read(`psramtcon);
    //----------------------------------------------------
    
    //----------------------------------------------------
    $display ("PSRAM Initial Setting!!\n");

    rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b0)<<3)|((`BurstRMode&1'b0)<<2)|((`PowerUp&1'b1)<<1);
    $display ("PSRAM -> PowerUP!!!!!\n");
    REG_Write(`psramcon, rvalue);
    #200000
    $display ("PSRAM -> PowerUPClr!!!!!\n");
    $display ("BurstMode Enable!!!!!\n");
    rvalue = ((`Enable&1'b1)<<0)|((`PageSize&3'b011)<<3)|((`BurstRMode&1'b1)<<2)|((`PowerUp&1'b0)<<1);
    REG_Write(`psramcon, rvalue);
    #100
    $display ("PSRAM Timing Control register Setting!\n");
    rvalue = ((`tRC &4'b0111)<<28)|    	// READ cycle timing setting
             ((`tAA &4'b0111)<<24)|		// READ access timing setting
             ((`tPRC&3'b011)<<21)|		// PAGE READ cycle timing setting
             ((`tPA &3'b011)<<18)|		// PAGE READ access timing setting
             ((`tWC &4'b1000)<<14)|		// WRITE cycle timing setting
             ((`tAS &2'b00)<<12)|		// ADDRESS SETUP timing setting
             ((`tWP &4'b0110)<<8)| 		// relative WE line
             ((`tDW &4'b0000)<<4)| // new
             ((`tDH &4'b0111)); // new
    REG_Write(`psramtcon, rvalue);
    //-----------------------------------------------------
    $display ("PSRAM Burst Time out Value register Setting!\n");
    rvalue = 11'b10000000000;
    REG_Write(`psramtout, rvalue);

end





 parameter DLY = 1;


task REG_Read;
input   [31:0]  Addr;
begin
                @(posedge R_PCLK);
                #DLY    R_PADDR   = Addr[1:0];
                        R_PENABLE = 1'b0;
                        R_PSEL    = 1'b1;
                        R_PWRITE  = 1'b0;
       repeat(1) @(posedge R_PCLK);
                #DLY    R_PENABLE = 1'b1;
       repeat(1) @(posedge R_PCLK);
                $display ("APB Register READ Value: %b\n",R_PRDATA);
                #DLY    R_PENABLE = 1'b0;
                                R_PSEL    = 1'b0;
       repeat(1) @(posedge R_PCLK);

end
endtask


task REG_Write;
input   [31:0]  Addr;
input   [31:0]  Wdata;
begin
                @(posedge R_PCLK);
                #DLY    R_PADDR   = Addr[1:0];
                                R_PWDATA  = Wdata;
                                R_PENABLE = 1'b0;
                                R_PSEL    = 1'b1;
                                R_PWRITE  = 1'b1;
         repeat(1) @(posedge R_PCLK);
                #DLY    R_PENABLE = 1'b1;
         repeat(1) @(posedge R_PCLK);
                #DLY    R_PENABLE = 1'b0;
                                R_PSEL    = 1'b0;
         repeat(1) @(posedge R_PCLK);
end
endtask
















TestMaster TestMaster
(
                .ACLK(ACLK),
                .ARESETn(ARESETn),

                .AWID(AWID),
                .AWADDR(AWADDR),
                .AWLEN(AWLEN),
                .AWSIZE(AWSIZE),
                .AWBURST(AWBURST),
                .AWLOCK(),
                .AWCACHE(),
                .AWPROT(),
                .AWVALID(AWVALID),
                .AWREADY(AWREADY),

                .WID(WID),
                .WDATA(WDATA),
                .WSTRB(WSTRB),
                .WLAST(WLAST),
                .WVALID(WVALID),
                .WREADY(WREADY),

                .BID(BID),
                .BRESP(BRESP), 
                .BVALID(BVALID),
                .BREADY(BREADY), 

                .ARID(ARID),
                .ARADDR(ARADDR),
                .ARLEN(ARLEN),
                .ARSIZE(ARSIZE),
                .ARBURST(ARBURST),
                .ARLOCK(),
                .ARCACHE(),
			    .ARPROT(),
                .ARVALID(ARVALID),
                .ARREADY(ARREADY),

                // Read Data Channel
                .RID(RID),
                .RDATA(RDATA),
                .RRESP(RRESP),
                .RLAST(RLAST),
                .RVALID(RVALID),
                .RREADY(RREADY)
);

                                        


pmcon_AXITop AXI2PSRAM
(
//      AXI Interface
				.ACLK     (ACLK),
				.ARESETn  (RESETn),
                // Write Address Channel
				.AWID     (AWID),
				.AWADDR   (AWADDR),
				.AWLEN    (AWLEN),
				.AWSIZE   (AWSIZE),
				.AWBURST  (AWBURST),
				.AWVALID  (AWVALID),
				.AWREADY  (AWREADY),

                // Write Data Channel
				.WID      (WID),
				.WDATA    (WDATA),
	            .WSTRB    (WSTRB),
			    .WLAST    (WLAST),
			    .WVALID   (WVALID),
			    .WREADY   (WREADY),

                // Write Response Channel
			    .BID      (BID),
			    .BRESP    (BRESP),
			    .BVALID   (BVALID),
				.BREADY   (BREADY),

                // Read Address Channel
				.ARID     (ARID),
			   	.ARADDR   (ARADDR),
			   	.ARLEN    (ARLEN),
			   	.ARSIZE   (ARSIZE),
			   	.ARBURST  (ARBURST),
			   	.ARVALID  (ARVALID),
			   	.ARREADY  (ARREADY),

            // Read Data Channel
			  	.RID      (RID),
			  	.RDATA    (RDATA),
			  	.RRESP    (RRESP),
			  	.RLAST    (RLAST),
			  	.RVALID   (RVALID),
			  	.RREADY   (RREADY),
                //---------------Register setting APB bus
				.R_PCLK   (R_PCLK),
			 	.R_PSEL   (R_PSEL),
 				.R_PENABLE(R_PENABLE),
	
				.R_PWRITE (R_PWRITE),
				.R_PADDR  (R_PADDR),
			   	.R_PWDATA (R_PWDATA),
			   	.R_PRDATA (R_PRDATA),
            //----------- PSRAM
			    .CSb      (CSb),
			    .ZZb      (ZZb),
			    .OEb      (OEb),
			    .WEb      (WEb),
			    .UBb      (UBb),
			    .LBb      (LBb),

				.ADDR     (ADDR),
			   	.DATAIN   (DATAIN),
			   	.nDATAEN  (nDATAEN),
			   	.DATAOUT  (DATAOUT)
);

psram32m    PSRAM32
   		(
            .Dq		(DATA),
            .Addr   	(ADDR[20:0]),
            .Ce_n   	(CSb),
            .We_n   	(WEb),
            .Oe_n   	(OEb),
            .Lb_n   	(LBb),
            .Ub_n   	(UBb),
            .Zz_n   	(ZZb)
        );


endmodule
