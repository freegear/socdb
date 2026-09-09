// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : AHB32bit2AXI64bitBridge.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is AHB-to-AXI interface.
//  =============================================================================
//
//  history :
//


`timescale 1ns/1ps

module AHB32bit2AXI64bitBridge
(
//	Common Interface
		HCLK     , 
		ACLK     , 
		RESETn   , 

        ClockEn  ,
        IDLE     ,
        HOLDBridge,

// AHB Interface
		HADDR    ,
		HTRANS   ,
		HWRITE   ,
		HSIZE    ,
		HBURST   ,
		HPROT    ,
		HWDATA   ,
		HRDATA   ,
		HREADY_IN,
		HREADY_OUT,
		HRESP    ,

		HSEL     ,
		HMASTLOCK,

// AXI Interface
		// Write Address Channel
		AWADDR   ,
		AWLEN    ,
		AWSIZE   ,
		AWBURST  ,
		AWLOCK   ,
		AWCACHE  ,
		AWPROT   ,
		AWVALID  ,
		AWREADY  ,

		// Write Data Channel
		WDATA    ,
		WSTRB    ,
		WLAST    ,
		WVALID   ,
		WREADY   ,

		// Write Response Channel
		BRESP    ,
		BVALID   ,
		BREADY   ,

		// Read Address Channel
		ARADDR   ,
		ARLEN    ,
		ARSIZE   ,
		ARBURST  ,
		ARLOCK   ,
		ARCACHE  ,
		ARPROT   ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY
);

// ==============================================================================
//  Parameter declation
// ------------------------------------------------------------------------------
`define HTRANS_NSEQ 2'b10
`define HTRANS_SEQ  2'b11
`define HTRANS_IDLE 2'b00
`define HTRANS_BUSY 2'b01

`define HRESP_OKAY  2'b00
`define HRESP_ERROR 2'b01

`define RESP_OKAY	2'b00

`define BURST_WRAP	2'b10
`define BURST_INCR	2'b01

`define AXI_SIZE_BYTE       3'b000
`define AXI_SIZE_HALFWORD   3'b001
`define AXI_SIZE_WORD       3'b010
`define AXI_SIZE_DWORD      3'b011

`define AXI_BURST_FIXED     2'b00
`define AXI_BURST_INCR      2'b01
`define AXI_BURST_WRAP      2'b10


// ==============================================================================
//  input output declation
// ------------------------------------------------------------------------------
input                  HCLK;
input                  ACLK;
input                  RESETn;
input                  ClockEn;
output                 IDLE;
input                  HOLDBridge;

input  [31:0]          HADDR;
input  [ 1:0]          HTRANS;
input                  HWRITE;
input  [2:0]           HSIZE;
input  [2:0] 		   HBURST;
input  [3:0]           HPROT;
input  [31:0]          HWDATA;
output [31:0]          HRDATA;
input                  HREADY_IN;
output                 HREADY_OUT;
output [1:0]           HRESP;

input                  HSEL;
input                  HMASTLOCK;

// axi write channel
output [31:0]          AWADDR;
output [3:0]           AWLEN;
output [2:0]           AWSIZE;
output [1:0]           AWBURST;
output [1:0]           AWLOCK;
output [3:0]           AWCACHE;
output [2:0]           AWPROT;
output                 AWVALID;
input                  AWREADY;

output [63:0]          WDATA;
output [7:0]           WSTRB;
output                 WLAST;
output                 WVALID;
input                  WREADY;


input  [1:0]           BRESP;
input                  BVALID;
output                 BREADY;

// axi read channel
output [31:0]          ARADDR;
output [3:0]           ARLEN;
output [2:0]           ARSIZE;
output [1:0]           ARBURST;
output [1:0]           ARLOCK;
output [3:0]           ARCACHE;
output [2:0]           ARPROT;
output                 ARVALID;
input                  ARREADY;

input  [63:0]          RDATA;
input  [1:0]           RRESP;
input                  RLAST;
input                  RVALID;
output                 RREADY;

reg     [63:0] 		   TempRDATA;

   
// ==============================================================================
//  Register & wire define
// ------------------------------------------------------------------------------

reg [31:0]  Addr;     //AddrBuffer
reg [3:0]   WRCnt;    //Buffering Counter for Read & Write
reg [3:0]   BuffCnt;
reg [3:0]   AxiLEN;   //Axi Length 
reg [2:0]   AxiSIZE;  //Axi Size 
reg [1:0]   AxiBURST; //Axi Burst 
reg         AxiWriteRead;

wire [1:0]  AxiLOCK; //Axi Lock 
wire [3:0]  AxiCACHE;//Axi Cache 
wire [2:0]  AxiPROT; //Axi Protect 

// ==============================================================================
//  Assing signal
// ------------------------------------------------------------------------------

assign AxiLOCK  = (HMASTLOCK) ? 2'b10 : 2'b00;
assign AxiCACHE = {2'b00, HPROT[3:2]};
assign AxiPROT  = {~HPROT[0], 1'b0, HPROT[1]};


// ==============================================================================
//  Sync signal
// ------------------------------------------------------------------------------

wire AwEnd    = AWVALID; 
wire WriteEnd = WVALID  & WLAST;
wire Write    = WVALID;
wire ArEnd    = ARVALID;
wire ReadEnd  = RREADY;
wire Read     = RREADY;
wire BchEnd   = BREADY;

wire wAwEnd    =  AwEnd    & AWREADY & ClockEn;
wire wArEnd    =  ArEnd    & ARREADY & ClockEn;
wire wWriteEnd =  WriteEnd & WREADY & ClockEn;
wire wReadEnd  =  ReadEnd  & RVALID & RLAST & ClockEn; 
wire wBchEnd   =  BchEnd   & BVALID & ClockEn; 
wire wWrite    =  Write    & WREADY & ClockEn; 
wire wRead     =  Read     & RVALID & ClockEn;

wire wBchEnd_OKAY  =  ((BRESP == `RESP_OKAY)) ? 1'b1 : 1'b0; 
wire wReadEnd_OKAY =  ((RRESP == `RESP_OKAY)) ? 1'b1 : 1'b0; 


wire HTRANS_VAL = (HSEL == 1'b1 && HREADY_IN == 1'b1 && 
                 ((HTRANS == `HTRANS_NSEQ) || 
                  (HTRANS == `HTRANS_SEQ))) ? 1'b1 : 1'b0; 

wire HTRANS_FIRST_VAL = (HSEL == 1'b1 && 
                         HREADY_IN == 1'b1 && 
                        (HTRANS == `HTRANS_NSEQ)) ? 1'b1 : 1'b0; 

wire HTRANS_BUSY_VAL = (HSEL == 1'b1 && 
                         HREADY_IN == 1'b1 && 
                        (HTRANS == `HTRANS_BUSY)) ? 1'b1 : 1'b0; 

wire HTRANS_IDLE_VAL = (HSEL == 1'b1 && 
                         HREADY_IN == 1'b1 && 
                        (HTRANS == `HTRANS_IDLE)) ? 1'b1 : 1'b0; 
reg EnVALUE;

// synopsys translate_off
//Test Signal
wire VALVAL = EnVALUE & HREADY_IN;
// synopsys translate_on

always @(posedge HCLK or negedge RESETn) begin

    if(!RESETn) begin
        EnVALUE <= 1'b1;
    end
    else begin
        if(HTRANS_BUSY_VAL | HTRANS_IDLE_VAL) EnVALUE <= 1'b0;
        else if(HTRANS_VAL) EnVALUE <= 1'b1;
    end

end

reg HoldData;

// ==============================================================================
//  AHB signal latch
// ------------------------------------------------------------------------------

reg [2:0] rHSIZE;
reg [4:0] rHADDR;
always @(posedge HCLK or negedge RESETn) begin

    if(!RESETn) begin
        rHSIZE <= 3'd0;
        rHADDR <= 3'd0;
    end
    else begin
        if(HTRANS_VAL) begin
            rHSIZE <= HSIZE;
            rHADDR <= HADDR[4:0];
        end
    end
end


// ==============================================================================
//  MAIN state machine
// ------------------------------------------------------------------------------

reg  [3:0] LenCnt;
reg  [6:0] State;	// State
reg  [6:0] NxState;	// Next State
parameter S_IDLE=0, S_AW=1, S_W=2, S_RES=3, S_AR=4, S_R=5, S_ERR=6;

wire StateIsIDLE    = State[0];
wire StateIsAW      = State[1];
wire StateIsW       = State[2];
wire StateIsRES     = State[3];
wire StateIsAR      = State[4];
wire StateIsR       = State[5];
wire StateIsERR     = State[6];
assign IDLE = StateIsIDLE;

wire CommandLatchEn = (StateIsIDLE && HTRANS_FIRST_VAL);

always @(negedge RESETn or posedge HCLK)
begin
	if(!RESETn)
	begin
		State = 0;
		State[S_IDLE] = 1'b1;
	end
	else
		State = NxState;
end

always @(State or 
         HWRITE or 
         HTRANS_VAL or
         HTRANS_FIRST_VAL or 
         HREADY_IN  or
         HoldData   or
         EnVALUE    or
         LenCnt     or
         BuffCnt    or
             
         wAwEnd     or
         wArEnd     or
         wWriteEnd  or
         wReadEnd   or
         wBchEnd_OKAY  or
         wReadEnd_OKAY or
         HOLDBridge    or
         wBchEnd       or
         AxiWriteRead
         )
begin
	NxState = 0;
	case(1'b1)	// synopsys parallel_case full_case

	State[S_IDLE]:
        if(HOLDBridge) begin 
			NxState[S_IDLE] = 1'b1;
        end
        else if((HWRITE == 1'b0 && HTRANS_FIRST_VAL) ||
		        (HWRITE == 1'b0 && HTRANS_VAL) ||
                (HoldData & !AxiWriteRead))
			NxState[S_AR] = 1'b1;
		else if((HWRITE == 1'b1 && HTRANS_FIRST_VAL) ||
		        (HWRITE == 1'b1 && HTRANS_VAL) ||
                (HoldData & AxiWriteRead))
			NxState[S_AW] = 1'b1;
		else
			NxState[S_IDLE] = 1'b1;

    State[S_AW]: // Address Write
        if(wAwEnd)     NxState[S_W]  = 1'b1;
        else           NxState[S_AW] = 1'b1;

    State[S_W]:  // Write
        if(wWriteEnd)  NxState[S_RES]= 1'b1;
        else           NxState[S_W]  = 1'b1;

    State[S_RES]://Write response
        //if(!wBchEnd_OKAY & wBchEnd)         NxState[S_ERR] = 1'b1;//10
        //else if(wBchEnd_OKAY  &  HoldData  & wBchEnd & AxiWriteRead)    
        if(HoldData  & wBchEnd & AxiWriteRead)    
                                            NxState[S_AW]  = 1'b1;//4
        else if((!HoldData  & wBchEnd) ||   
                ( HoldData  & wBchEnd & !AxiWriteRead))
                                            NxState[S_IDLE]= 1'b1;//5
        else                                NxState[S_RES] = 1'b1;

    State[S_AR]: // Address Read
        if(wArEnd)     NxState[S_R]  = 1'b1;
        else           NxState[S_AR] = 1'b1;

    State[S_R]:  // Read
        //if(!wReadEnd_OKAY)                  NxState[S_ERR] = 1'b1;//11
        //else if(wReadEnd_OKAY & HoldData & wReadEnd & !AxiWriteRead)   
        if(HoldData & wReadEnd & !AxiWriteRead)   
                                            NxState[S_AR]  = 1'b1;//8
        else if((LenCnt == 0 && BuffCnt == 0 && EnVALUE && HREADY_IN) ||
                (HoldData    &  AxiWriteRead))
                                            NxState[S_IDLE]= 1'b1;//9
        else                                NxState[S_R]   = 1'b1;

    State[S_ERR]:// Error
        if(HREADY_IN && (HRESP != `HRESP_ERROR))
            NxState[S_IDLE] = 1'b1;
        else
            NxState[S_ERR]  = 1'b1;

	endcase
end

// ==============================================================================
//  Sub read state machine
// ------------------------------------------------------------------------------

parameter S_BUFF=1, S_VALID=2, S_LAST=3;

reg  [3:0] SubReadState;	// SubReadState
reg  [3:0] NxSubReadState;	// Next SubReadState

wire SubReadStateIsIDLE    = SubReadState[0];
wire SubReadStateIsBUFF    = SubReadState[1];
wire SubReadStateIsVALID   = SubReadState[2];
wire SubReadStateIsLAST    = SubReadState[3];

always @(negedge RESETn or posedge HCLK)
begin
	if(!RESETn)
	begin
		SubReadState <= 0;
		SubReadState[S_IDLE] <= 1'b1;
	end
	else
		SubReadState <= NxSubReadState;
end



always @(SubReadState or 
         LenCnt     or
         HREADY_IN  or
         EnVALUE    or
         wArEnd     or
         BuffCnt    or
         wRead        
         )
begin
	NxSubReadState = 0;
	case(1'b1)	// synopsys parallel_case full_case

	SubReadState[S_IDLE]:
        if(wArEnd)  NxSubReadState[S_VALID] = 1'b1; //1
		else        NxSubReadState[S_IDLE]  = 1'b1; 

	SubReadState[S_BUFF]:
    begin
        if((LenCnt != 0)     && (BuffCnt == 4'd0) && (EnVALUE == 1'b1) &&
           (HREADY_IN == 1'b1) 
          ) begin
                    NxSubReadState[S_VALID] = 1'b1;
        end
        else if(LenCnt == 0 && BuffCnt == 0 && EnVALUE == 1'b1 && HREADY_IN == 1'b1) 
        begin
                    NxSubReadState[S_IDLE]  = 1'b1;
        end
        else begin
                    NxSubReadState[S_BUFF]  = 1'b1;
        end
    end

	SubReadState[S_VALID]:
        if(wRead)    NxSubReadState[S_BUFF] = 1'b1;
		else        NxSubReadState[S_VALID] = 1'b1;

    endcase

end

// ==============================================================================
//  Sub write state machine
// ------------------------------------------------------------------------------

reg  [3:0] SubWriteState;	// SubWriteState
reg  [3:0] NxSubWriteState;	// Next SubWriteState

wire SubWriteStateIsIDLE    = SubWriteState[0];
wire SubWriteStateIsBUFF    = SubWriteState[1];
wire SubWriteStateIsVALID   = SubWriteState[2];
wire SubWriteStateIsLAST    = SubWriteState[3];

always @(negedge RESETn or posedge HCLK)
begin
	if(!RESETn)
	begin
		SubWriteState = 0;
		SubWriteState[S_IDLE] = 1'b1;
	end
	else
		SubWriteState = NxSubWriteState;
end

always @(SubWriteState or 
         HREADY_IN  or
         EnVALUE      or
             
         wAwEnd     or
         BuffCnt       or
         LenCnt        or
         wWrite        or
         wWriteEnd   
         )
begin
	NxSubWriteState = 0;
	case(1'b1)	// synopsys parallel_case full_case

	SubWriteState[S_IDLE]:
        if(wAwEnd)       NxSubWriteState[S_BUFF] = 1'b1; //1
		else             NxSubWriteState[S_IDLE] = 1'b1; 

	SubWriteState[S_BUFF]:
        if(LenCnt == 0 && BuffCnt == 0 && HREADY_IN && EnVALUE )     
                         NxSubWriteState[S_LAST]  = 1'b1;
        else if(LenCnt != 0 && BuffCnt == 0 && HREADY_IN && EnVALUE) 
                         NxSubWriteState[S_VALID] = 1'b1;
        else             NxSubWriteState[S_BUFF]  = 1'b1;

	SubWriteState[S_VALID]:
        if(wWrite)       NxSubWriteState[S_BUFF] = 1'b1;
		else             NxSubWriteState[S_VALID] = 1'b1;

	SubWriteState[S_LAST]:
        if(wWriteEnd)    NxSubWriteState[S_IDLE] = 1'b1;
		else             NxSubWriteState[S_LAST] = 1'b1;

    endcase
end

// ==============================================================================
//  HBurst counter
// ------------------------------------------------------------------------------

reg [3:0]   HBurstCnt;

always @(posedge HCLK or negedge RESETn) begin
    
    if(!RESETn) begin
        HBurstCnt <= 0;
    end
    else begin
        if(HTRANS_FIRST_VAL)            HBurstCnt <= 0;
        else if(HREADY_OUT & EnVALUE)   HBurstCnt <= HBurstCnt + 1;
    end

end

// ==============================================================================
//  axi interface calculation
// ------------------------------------------------------------------------------

wire ZeroBuff = (BuffCnt == 0 && LenCnt == 0) ? 1'b1 : 1'b0;

always @(posedge HCLK or negedge RESETn) begin
    if(!RESETn) begin
        HoldData <= 0;
    end
    else if(HTRANS_FIRST_VAL && !StateIsIDLE) begin
        HoldData <= 1'b1;
    end
    else if(ZeroBuff & HTRANS_VAL & EnVALUE) begin
        HoldData <= 1'b1;
    end
    else if(StateIsAW | StateIsAR) begin
        HoldData <= 1'b0;
    end
end

always @(posedge HCLK or negedge RESETn) begin

    if(!RESETn) begin
          Addr <= 32'd0;
          WRCnt <= 4'd0;
          AxiLEN <= 4'd0; 
          AxiWriteRead <= 0;
          AxiSIZE <= 3'd0;
          AxiBURST <= `AXI_BURST_INCR;
    end
    else if(HTRANS_VAL) begin

        case(HSIZE) // synopsys parallel_case full_case
//  -----------------------------------------------------------------------------
//  Byte Access calculation
//  -----------------------------------------------------------------------------
            2'b00: begin 
              case(HBURST) // synopsys parallel_case full_case
                3'b010:      //wrap4 write byte
                begin
                    Addr   <= HADDR & 32'hFFFFFFFC;
                    WRCnt  <= 4'd3;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;
                end

                3'b100:      //wrap8 write byte
                begin
                    Addr   <= HADDR & 32'hFFFFFFF8;
                    WRCnt  <= 4'd7;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                end

                3'b110:      //wrap16 write byte
                begin
                    if(((HBurstCnt < 8) || HTRANS_FIRST_VAL ) && //not 9 to 15 
                       (HADDR[3:0]== 0  || HADDR[3:0]== 8)
                      ) begin // HADDR <= 0|8
                    Addr   <= HADDR;
                    WRCnt  <= 4'd7;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end 
                    else begin
                    Addr   <= HADDR;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_BYTE;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end

                3'b111:      //incr16 write byte
                begin
                    if((HTRANS_FIRST_VAL ) && //not 9 to 15 
                       (HADDR[3:0]== 0  || HADDR[3:0]== 8)
                      ) begin // HADDR <= 0|8
                    Addr   <= HADDR;
                    WRCnt  <= 4'd7;
                    AxiLEN <= 4'd1; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end 
                    else begin
                    Addr   <= HADDR;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_BYTE;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end



                default: begin // single write byte
                               // incr write byte
                    Addr   <= HADDR;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_BYTE;
                    AxiBURST <= `AXI_BURST_INCR;
                end
              endcase
              end
//  -----------------------------------------------------------------------------
//  Half Word Access calcuration
//  -----------------------------------------------------------------------------
            2'b01: begin 
              case(HBURST) // synopsys parallel_case full_case
                3'b010:      //wrap4 write 2 byte
                begin
                    Addr   <= HADDR & 32'hFFFFFFF8;
                    WRCnt  <= 4'd3;
                    AxiLEN <= 4'd0; 
                    AxiWriteRead <= HWRITE;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                end
                3'b100:      //wrap8 write 2 byte
                begin
                    if(((HBurstCnt < 4) || HTRANS_FIRST_VAL) && //not 5 or 6 or 7
                       (HADDR[3:0]== 0 || HADDR[3:0]== 8)
                      ) begin // HADDR <= 0|8
                    Addr   <= HADDR;
                    WRCnt  <= 4'd3;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    AxiWriteRead <= HWRITE;

                    if(HTRANS_FIRST_VAL & HADDR[3:0]== 0) begin   //0  (Length ==2)
                        AxiLEN <= 4'd1; 
                    end
                    else begin
                        AxiLEN <= 4'd0; //--------------// 1 or 2 or 3  (Length ==1)
                    end

                    end
                    else begin // HADDR <= 2|4|6
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_HALFWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                3'b110:      //wrap16 write 2 byte
                begin
                    if(((HBurstCnt < 12) || HTRANS_FIRST_VAL ) && //not 13 or 14 or 15
                    //if(HTRANS_FIRST_VAL  &&                        //not 13 or 14 or 15
                       (HADDR[4:0]== 0 || HADDR[4:0] == 8)
                      ) begin // HADDR <= 0|8

                    if(HTRANS_FIRST_VAL && (HADDR[4:0]== 0)) begin    //0
                        AxiLEN <= 4'd3; 
                    end
                    else begin
                        AxiLEN <= 4'd0; // 9 or 10 or 11
                    end

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd3;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else begin // HADDR <= 2|4|6
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_HALFWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                3'b011:     //incr4 write 2 byte
                begin
                    if(HTRANS_FIRST_VAL &&
                       (HADDR[3:0]== 0 || HADDR[3:0]== 8)
                      ) begin 

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd3;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    AxiLEN <= 4'd0; 

                    end
                    else begin

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_HALFWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                end
                3'b101:     //incr8 write 2 byte
                begin
                    if(((HBurstCnt < 4) || HTRANS_FIRST_VAL) && //not 5 or 6 or 7
                       (HADDR[3:0]== 0 || HADDR[3:0]== 8)
                      ) begin // HADDR <= 0|8
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd3;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    if(HTRANS_FIRST_VAL) begin    //--------------// 0
                        AxiLEN <= 4'd1; 
                    end
                    else begin
                        AxiLEN <= 4'd0; //--------------// 1 or 2 or 3
                    end

                    end
                    else begin // HADDR <= 2|4|6
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_HALFWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                3'b111:     //incr16 write 2 byte
                begin
                    if(((HBurstCnt < 12) || HTRANS_FIRST_VAL) && //not 13 or 14 or 15
                      (HADDR[3:0]== 0 || HADDR[3:0] == 8))
                    begin // HADDR <= 0|8

                    if(HTRANS_FIRST_VAL) begin    //--------------// 0
                        AxiLEN <= 4'd3; 
                    end
                    else if(!HBurstCnt[3] & !HBurstCnt[2] & !(HBurstCnt[1] & HBurstCnt[0])) 
                    begin// 1 or 2 or 3 ( 0 or 1 or 2)
                        AxiLEN <= 4'd2; 
                    end
                    else if(!HBurstCnt[3] &  HBurstCnt[2] & !(HBurstCnt[1] & HBurstCnt[0])) 
                    begin // 5 or 6 or 7 ( 4 or 5 or 6 )
                        AxiLEN <= 4'd1; 
                    end
                    else begin
                        AxiLEN <= 4'd0; // 9 or 10 or 11
                    end

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd3;
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else begin // HADDR <= 2|4|6
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_HALFWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                default:    // single write 2 byte
                begin
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_HALFWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                end
              endcase
              end

//  -----------------------------------------------------------------------------
//  Word Access calcuration
//  -----------------------------------------------------------------------------
            2'b10: begin 
              case(HBURST) // synopsys parallel_case full_case
                3'b010:      //wrap4 write 4 byte
                begin
                    if((HTRANS_FIRST_VAL == 1) && // 0
                       (HADDR[3:0]== 0)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd1; //length == 2
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else if((HBurstCnt[1] == 0) && (HTRANS_FIRST_VAL != 1) && // 0 or 1
                       (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd0; //length == 1
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else begin
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                3'b100:      //wrap8 write 4 byte
                begin
                    if((HTRANS_FIRST_VAL == 1) && // 0
                       (HADDR[4:0]== 0)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd3; //length == 4
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else if((HBurstCnt[2:0] != 6) && (HBurstCnt[2:0] != 7) && 
                            (HTRANS_FIRST_VAL != 1) && // 1
                            (HADDR[3:0]== 0 || HADDR[3:0] == 5'h8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd0; //length == 2
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else begin

                    Addr         <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt        <= 4'd0;
                    AxiLEN       <= 4'd0; 
                    AxiSIZE      <= `AXI_SIZE_WORD;
                    AxiBURST     <= `AXI_BURST_INCR;

                    end

                end
                3'b110:     //wrap16 write 4 byte
                begin
                    if((HTRANS_FIRST_VAL == 1) && // 0
                       (HADDR[5:0]== 0)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd7; //length == 8
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                    else if((HBurstCnt != 13) && 
                            (HBurstCnt != 14) &&
                            (HBurstCnt != 15) &&
                            (HTRANS_FIRST_VAL != 1) && // 1
                            (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd0; //length == 1
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else begin

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end

                end
                3'b011:     //incr4 write 4 byte
                begin

                    if((HTRANS_FIRST_VAL == 1) && // 0
                       (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd1; //length == 2
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else if((HBurstCnt[1] == 0) && (HTRANS_FIRST_VAL != 1) && // 0 or 1
                            (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd0; //length == 1
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else begin

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end

                end
                3'b101:     //incr8 write 4 byte
                begin
                    if((HTRANS_FIRST_VAL == 1) && // 0
                       (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd3; //length == 4
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;

                    end
                    else if((HBurstCnt[2:0] != 6) && (HBurstCnt[2:0] != 7) && 
                       (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd2; //length == 3
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                    else begin
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                3'b111:     //incr16 write 4 byte
                begin
                    if((HTRANS_FIRST_VAL == 1) && // 0
                       (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd7; //length == 8
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                    else if((HBurstCnt != 13) && 
                            (HBurstCnt != 14) &&
                            (HBurstCnt != 15) &&
                       (HADDR[3:0]== 0 || HADDR[3:0] == 8)
                      ) begin // HADDR <= 0|8

                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd1;
                    AxiLEN <= 4'd0; //length == 1
                    AxiSIZE  <= `AXI_SIZE_DWORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                    else begin
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;
                    end
                end
                default:    // single write 4 byte
                begin
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;
                end
              endcase
              end

            default: begin
                    Addr   <= HADDR;
                    AxiWriteRead <= HWRITE;
                    WRCnt  <= 4'd0;
                    AxiLEN <= 4'd0; 
                    AxiSIZE  <= `AXI_SIZE_WORD;
                    AxiBURST <= `AXI_BURST_INCR;
                end
        endcase
    end
end

// ==============================================================================
//  Address Write/Read process
// ------------------------------------------------------------------------------

always @(posedge ACLK or negedge RESETn) begin

    if(!RESETn) begin
        LenCnt <= 0;
    end
    else if(StateIsAW ) begin
        LenCnt <= AxiLEN;
    end
    else if(StateIsAR) begin
        LenCnt <= AxiLEN+1;
    end
    else if((wWrite | wRead)) begin 
        LenCnt <= LenCnt - 1;
    end
end

assign  AWVALID = StateIsAW;
assign  ARVALID = StateIsAR;
assign  AWADDR  = Addr;
assign  ARADDR  = Addr;
assign  AWLEN   = AxiLEN;
assign  ARLEN   = AxiLEN;
assign  AWSIZE  = AxiSIZE;
assign  ARSIZE  = AxiSIZE;
assign  AWBURST = AxiBURST;
assign  ARBURST = AxiBURST;
assign  AWLOCK  = AxiLOCK;  
assign  AWCACHE = AxiCACHE;
assign  AWPROT  = AxiPROT;
assign  ARLOCK  = AxiLOCK;  
assign  ARCACHE = AxiCACHE;
assign  ARPROT  = AxiPROT;


// ==============================================================================
//  Write process
// ------------------------------------------------------------------------------

reg [7:0]  TempWSTRB;
reg [31:0] TempWDATA_Low;
reg [31:0] TempWDATA_High;
reg [63:0] TempWDATA;
reg [63:0] BuffMask;

assign WSTRB  = TempWSTRB;
assign WDATA  = TempWDATA;  
assign WVALID = StateIsW & (SubWriteStateIsVALID | SubWriteStateIsLAST);
assign WLAST  = StateIsW &  SubWriteStateIsLAST;

// -----------------------------------------------
//   Buffer Masking sig. generation ==============
// -----------------------------------------------

always @(rHSIZE or rHADDR) begin

    case(rHSIZE)  // synopsys parallel_case full_case
        2'b00: begin //byte access_______________
                case(rHADDR[2:0])   // synopsys parallel_case full_case
                3'd0: BuffMask = 64'h00000000000000FF;
                3'd1: BuffMask = 64'h000000000000FF00;  
                3'd2: BuffMask = 64'h0000000000FF0000;
                3'd3: BuffMask = 64'h00000000FF000000;
                3'd4: BuffMask = 64'h000000FF00000000;
                3'd5: BuffMask = 64'h0000FF0000000000;
                3'd6: BuffMask = 64'h00FF000000000000;
                3'd7: BuffMask = 64'hFF00000000000000;
                endcase
               end
        2'b01: begin //half word access_________
                case(rHADDR[2:0]) // synopsys parallel_case full_case
                3'd0: BuffMask = 64'h000000000000FFFF;
                3'd1: BuffMask = 64'h000000000000FFFF;  
                3'd2: BuffMask = 64'h00000000FFFF0000;
                3'd3: BuffMask = 64'h00000000FFFF0000;
                3'd4: BuffMask = 64'h0000FFFF00000000;
                3'd5: BuffMask = 64'h0000FFFF00000000;
                3'd6: BuffMask = 64'hFFFF000000000000;
                3'd7: BuffMask = 64'hFFFF000000000000;
                endcase
               end

        2'b10: begin //word access_____________ 
                case(rHADDR[2:0]) // synopsys parallel_case full_case
                3'd0: BuffMask = 64'h00000000FFFFFFFF;
                3'd1: BuffMask = 64'h00000000FFFFFFFF;  
                3'd2: BuffMask = 64'h00000000FFFFFFFF;
                3'd3: BuffMask = 64'h00000000FFFFFFFF;
                3'd4: BuffMask = 64'hFFFFFFFF00000000;
                3'd5: BuffMask = 64'hFFFFFFFF00000000;
                3'd6: BuffMask = 64'hFFFFFFFF00000000;
                3'd7: BuffMask = 64'hFFFFFFFF00000000;
                endcase
               end
        default:
                BuffMask = 64'hFFFFFFFFFFFFFFFF;
    endcase
end

// -----------------------------------------------
//   Buffer ======================================
// -----------------------------------------------

wire [63:0] TempWDATA01 = ({HWDATA, HWDATA} & BuffMask);
reg [3:0]   BuffMaxCnt;    //Buffering Counter for Read & Write

always @(posedge HCLK or negedge RESETn) begin

    if(!RESETn) begin
        TempWDATA <= 64'd0;
        BuffCnt   <= 0; 
    end
    else begin

        if(EnVALUE & HREADY_IN)
            TempWDATA <= ({HWDATA, HWDATA} & BuffMask) |
                         (TempWDATA        & ~BuffMask);

        if(StateIsAW) begin 
                                             BuffCnt    <= WRCnt;
                                             BuffMaxCnt <= WRCnt;
        end
        if(StateIsAR) begin 
                                             BuffCnt    <= WRCnt;
                                             BuffMaxCnt <= WRCnt;
        end
        else if(SubWriteStateIsVALID | SubReadStateIsVALID)    
                                             BuffCnt <= BuffMaxCnt;
        else if(HREADY_OUT & EnVALUE & SubWriteStateIsBUFF & StateIsW)        
                                             BuffCnt <= BuffCnt - 1;
        else if(EnVALUE & HREADY_OUT & SubReadStateIsBUFF)
                                             BuffCnt <= BuffCnt - 1;

    end
end

// -----------------------------------------------
//   Wstrobe generation ===========================
// -----------------------------------------------

reg [2:0] rAWADDR;
reg [2:0] rAWSIZE;

always @(posedge ACLK or negedge RESETn) begin

    if(!RESETn) begin
        rAWADDR <= 3'd0;
        rAWSIZE <= 3'd0;
    end
    else begin
        if(AWVALID & AWREADY) begin
            rAWADDR <= AWADDR[2:0];
            rAWSIZE <= AWSIZE;
        end
    end
end


always @(rAWADDR or rAWSIZE) begin
    case(rAWSIZE)  // synopsys parallel_case full_case
        3'b000: //Byte
        begin
            case(rAWADDR)  // synopsys parallel_case full_case
                3'd0: TempWSTRB = 8'b00000001;
                3'd1: TempWSTRB = 8'b00000010;  
                3'd2: TempWSTRB = 8'b00000100;
                3'd3: TempWSTRB = 8'b00001000;
                3'd4: TempWSTRB = 8'b00010000;
                3'd5: TempWSTRB = 8'b00100000;
                3'd6: TempWSTRB = 8'b01000000;
                3'd7: TempWSTRB = 8'b10000000;
            endcase
        end
        3'b001: //Half word
        begin
            case(rAWADDR) // synopsys parallel_case full_case 
                3'd0: TempWSTRB = 8'b00000011;
                3'd1: TempWSTRB = 8'b00000011;  
                3'd2: TempWSTRB = 8'b00001100;
                3'd3: TempWSTRB = 8'b00001100;
                3'd4: TempWSTRB = 8'b00110000;
                3'd5: TempWSTRB = 8'b00110000;
                3'd6: TempWSTRB = 8'b11000000;
                3'd7: TempWSTRB = 8'b11000000;
            endcase
        end
        3'b010: //Word
        begin
            case(rAWADDR) // synopsys parallel_case full_case
                3'd0: TempWSTRB = 8'b00001111;
                3'd1: TempWSTRB = 8'b00001111;  
                3'd2: TempWSTRB = 8'b00001111;
                3'd3: TempWSTRB = 8'b00001111;
                3'd4: TempWSTRB = 8'b11110000;
                3'd5: TempWSTRB = 8'b11110000;
                3'd6: TempWSTRB = 8'b11110000;
                3'd7: TempWSTRB = 8'b11110000;
            endcase
        end
        3'b011: //Double Word
        begin
            TempWSTRB = 8'b11111111;
        end
        default:
            TempWSTRB = 8'b11111111;
    endcase
end

// ==============================================================================
//  Write Response process
// ------------------------------------------------------------------------------
//assign BREADY = (StateIsRES) ? 1'b1 : 1'b0;
assign BREADY = 1'b1;


// ==============================================================================
//  Read process
// ------------------------------------------------------------------------------
reg    [63:0] rRDATA;
wire   RDATA_HighLow = ((rHADDR[3:0] & 4'h4) == 4'h4) ? 1'b1 : 1'b0;
assign RREADY = StateIsR & (SubReadStateIsVALID | SubReadStateIsLAST);
assign HRDATA  = (RDATA_HighLow) ? rRDATA[63:32] : rRDATA[31:0];


always @(posedge ACLK or negedge RESETn) begin
    if(!RESETn) begin
        rRDATA <= 0;
    end
    else if(RVALID & RREADY)begin
        rRDATA <= RDATA;
    end
end

// ==============================================================================
//  Error detect
// ------------------------------------------------------------------------------

reg [1:0] HRESP;
reg  ErrorDetected_1d;
wire ErrorDetected;

always @(ErrorDetected_1d or State or HTRANS or RVALID or RRESP or BVALID or BRESP)
begin
	if(ErrorDetected_1d == 1'b1)
		HRESP = `HRESP_ERROR;
	else
	begin
		case(1'b1)	// synopsys parallel_case full_case
		State[S_IDLE]: HRESP = `HRESP_OKAY;
        State[S_AW]  : HRESP = `HRESP_OKAY;
		State[S_R]   : HRESP = (RVALID == 1'b0 || RRESP == `RESP_OKAY) ? `HRESP_OKAY : `HRESP_ERROR;
		State[S_W]   : HRESP = `HRESP_OKAY;
		State[S_RES] : HRESP = (BVALID == 1'b0 || BRESP == `RESP_OKAY) ? `HRESP_OKAY : `HRESP_ERROR;
		endcase
	end
end

// 2 cycle HRESP_ERROR processing
assign ErrorDetected = (HRESP == `HRESP_ERROR && ErrorDetected_1d == 0);
always @(negedge RESETn or posedge HCLK)
begin
	if(!RESETn)
		ErrorDetected_1d <= 0;
	else
		ErrorDetected_1d <= ErrorDetected;
end


// ==============================================================================
//  AHB Output
// ------------------------------------------------------------------------------

reg    HREADY_OUT;

always @(StateIsIDLE or HoldData or StateIsW or StateIsR or
         SubWriteStateIsVALID or SubReadStateIsVALID or
         SubWriteStateIsLAST  or HoldData or StateIsIDLE or HOLDBridge or ErrorDetected_1d)
begin

    if(ErrorDetected_1d)
        HREADY_OUT = 1'b1;
    else
        HREADY_OUT =((StateIsIDLE & !HoldData)  | StateIsW | StateIsR) & 
                    (!SubWriteStateIsVALID & !SubReadStateIsVALID)     &
                    (!SubWriteStateIsLAST) & !HoldData & !(StateIsIDLE & HOLDBridge);


end

/*
assign HREADY_OUT = ((StateIsIDLE & !HoldData)  | StateIsW | StateIsR) & 
                    (!SubWriteStateIsVALID & !SubReadStateIsVALID)     &
                    (!SubWriteStateIsLAST) & !HoldData & !(StateIsIDLE & HOLDBridge);
assign HRESP      = (StateIsERR) ? `HRESP_ERROR : `HRESP_OKAY;  
*/

// ------------------------------------------------------------------------------
endmodule
