// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : VideoEncoderTester.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is AXI Internal NTSC/PAL video test 
// =======================================================================


//Synthesis
//Bug ACLK -> CLK27MHZ
//rENABLE = 1;
//rEND_ADDR = ; ntsc set
//MultiPort sram modified
//End address setting

`timescale 1ns/1ps
`define ADDRREG0  2'b00      //0x00   register addr.
                             //    31 :: enable bit 
                             //    30 :: NTSC/PAL mode 0->NTSC 1->PAL

`define ADDRREG1  2'b01      //0x04   start register addr.
`define ADDRREG2  2'b10      //0x08   end register addr.

module VideoEncoderTester 
(
//	AXI Interface
		ACLK     , 
        CLK_27MHZ,
		ARESETn  , 

		// Read Address Channel
		ARADDR   ,
		ARLEN    ,
		ARSIZE   ,
		ARBURST  ,
		ARVALID  ,
		ARREADY  ,

		// Read Data Channel
		RDATA    ,
		RRESP    ,
		RLAST    ,
		RVALID   ,
		RREADY   ,

        DMA_REQ  ,

//  APB bus
        PENABLE  , 
        PSEL     , 
        PWRITE   , 
        PADDR    ,  //[3:2] used
        PWDATA   ,  //[15:0] used
        PRDATA   ,


//	SRAM Interface

		MEMADDR00,
		MEMADDR01,
		MEMWEn00,  
		MEMWEn01, 
		MEMRDATA00, 
		MEMRDATA01,
		MEMWDATA00,
		MEMWDATA01,

		MEMADDR10,
		MEMADDR11,
		MEMWEn10,  
		MEMWEn11, 
		MEMRDATA10, 
		MEMRDATA11,
		MEMWDATA10,
		MEMWDATA11,

		MEMADDR20,
		MEMADDR21,
		MEMWEn20,  
		MEMWEn21, 
		MEMRDATA20, 
		MEMRDATA21,
		MEMWDATA20,
		MEMWDATA21,

		MEMADDR30,
		MEMADDR31,
		MEMWEn30,  
		MEMWEn31, 
		MEMRDATA30, 
		MEMRDATA31,
		MEMWDATA30,
		MEMWDATA31,

        ADC_OUT,
        SYNC,
        BLANK
);

//
// module parameter
//
parameter DATA_WIDTH = 32;	// only support 32 bit now
parameter WID_WIDTH = 4;
parameter RID_WIDTH = 4;
parameter ADDR_WIDTH = 32;	// Memory Address Width : should be at least 12(4KB)

parameter MADDR_WIDTH = (DATA_WIDTH == 32) ? (ADDR_WIDTH-2) : (ADDR_WIDTH-3);
// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;
parameter ID_WIDTH = (WID_WIDTH > RID_WIDTH) ? WID_WIDTH : RID_WIDTH;

parameter START_ADDR_ALL    = 0;
parameter END_ADDR_NTSC     = START_ADDR_ALL + 1801800; //(1716 * 525 * 2)
parameter END_ADDR_PAL      = START_ADDR_ALL + 4320000; //(1728 * 625 * 4)


`define RESP_OKAY	2'b00

// input/output port
////////////////////////////////////////////////////////////////////////////////////////
input  ACLK;
input  CLK_27MHZ;
input  ARESETn;

output  [ADDR_WIDTH-1:0] ARADDR;
output  [3:0]            ARLEN;
output  [2:0]            ARSIZE;
output  [1:0]            ARBURST;
output                   ARVALID;
input                    ARREADY;

input [DATA_WIDTH-1:0] RDATA;
input [1:0]            RRESP;
input                  RLAST;
input                  RVALID;
output                 RREADY;


//APB bus//////////////////////
input	[3:2]	PADDR;
input	[31:0]	PWDATA;
input	PSEL;
input	PWRITE ;
input	PENABLE;
output	[31:0]	PRDATA;


wire  	[31:0]	PRDATA;
wire    Valid;
wire    READOP  = PENABLE && PSEL && !PWRITE ;  // Read operation
wire    WRITEOP = PENABLE && PSEL && PWRITE  ;  // Write operation

assign  Valid = (PSEL & (!PENABLE));

/////////////////////////////////


output                   DMA_REQ;


output [4:0]  MEMADDR00;	// discard lower 2 line
output [4:0]  MEMADDR01;	// discard lower 2 line
output        MEMWEn00;
output        MEMWEn01;
input  [31:0] MEMRDATA00;
input  [31:0] MEMRDATA01;
output [31:0] MEMWDATA00;
output [31:0] MEMWDATA01;

output [4:0]  MEMADDR10;	// discard lower 2 line
output [4:0]  MEMADDR11;	// discard lower 2 line
output        MEMWEn10;
output        MEMWEn11;
input  [31:0] MEMRDATA10;
input  [31:0] MEMRDATA11;
output [31:0] MEMWDATA10;
output [31:0] MEMWDATA11;

output [4:0]  MEMADDR20;	// discard lower 2 line
output [4:0]  MEMADDR21;	// discard lower 2 line
output        MEMWEn20;
output        MEMWEn21;
input  [31:0] MEMRDATA20;
input  [31:0] MEMRDATA21;
output [31:0] MEMWDATA20;
output [31:0] MEMWDATA21;

output [4:0]  MEMADDR30;	// discard lower 2 line
output [4:0]  MEMADDR31;	// discard lower 2 line
output        MEMWEn30;
output        MEMWEn31;
input  [31:0] MEMRDATA30;
input  [31:0] MEMRDATA31;
output [31:0] MEMWDATA30;
output [31:0] MEMWDATA31;

/*
output [4:0] MEMADDR0;	// discard lower 2 line
output                   MEMCEn0;
output [NUM_BYTE-1:0]    MEMWEn0;
input  [DATA_WIDTH-1:0]  MEMRDATA0;
output [DATA_WIDTH-1:0]  MEMWDATA0;

output [4:0] MEMADDR1;	// discard lower 2 line
output                   MEMCEn1;
output [NUM_BYTE-1:0]    MEMWEn1;
input  [DATA_WIDTH-1:0]  MEMRDATA1;
output [DATA_WIDTH-1:0]  MEMWDATA1;

output [4:0] MEMADDR2;	// discard lower 2 line
output                   MEMCEn2;
output [NUM_BYTE-1:0]    MEMWEn2;
input  [DATA_WIDTH-1:0]  MEMRDATA2;
output [DATA_WIDTH-1:0]  MEMWDATA2;


output [4:0] MEMADDR3;	// discard lower 2 line
output                   MEMCEn3;
output [NUM_BYTE-1:0]    MEMWEn3;
input  [DATA_WIDTH-1:0]  MEMRDATA3;
output [DATA_WIDTH-1:0]  MEMWDATA3;
*/



output [7:0] ADC_OUT;
output SYNC;
output BLANK;
////////////////////////////////////////////////////////////////////////////////////////

reg     rENABLE;
reg     rNTSC_PAL;
reg     rCLEAR;
reg     [31:0]  START_ADDR;
reg     [31:0]  rEND_ADDR;


// INTERFACE READ & WRITE_________________________________
// register write 
always @(negedge ARESETn or posedge ACLK)	begin

	if(!ARESETn) 
    begin
        rENABLE    <= 1'b1;
        rNTSC_PAL  <= 1'b0;
        rCLEAR     <= 1'b0;
        START_ADDR <= 32'h00000000;
		rEND_ADDR  <= 32'd1801800;
		//rEND_ADDR  <= 32'd0;
	end
	else	begin
		if(WRITEOP && (PADDR[3:2] == `ADDRREG0))      begin
            rENABLE    <= PWDATA[31];
            rNTSC_PAL  <= PWDATA[30];
            rCLEAR     <= PWDATA[29];
        end
        else if(WRITEOP && (PADDR[3:2] == `ADDRREG1)) begin   // clear 
            START_ADDR <= PWDATA;
        end
        else if(WRITEOP && (PADDR[3:2] == `ADDRREG2)) begin   
            rEND_ADDR <= PWDATA;
        end
        else
            rCLEAR     <= 1'b0;
    end
end

reg  [31:0] nextPRDATA      ;    // Mux, Register and Enable for PRDATA
reg  [31:0] ReadRegs        ;
reg  [31:0] iPRDATA         ;
wire ReadRegEn;

assign  ReadRegEn = (Valid & (~PWRITE));
assign  PRDATA = (PSEL) ? iPRDATA : 32'd0;

always @ (PADDR or ReadRegs )
begin : p_ReadMuxComb
    nextPRDATA = ReadRegs;  // Read as zero default
end

always @ (PADDR or rENABLE or rNTSC_PAL or START_ADDR)
begin : p_RdRegMuxComb
    case (PADDR[3:2]) 
    //synopsys parallel_case
        `ADDRREG0 : ReadRegs  = {rENABLE, rNTSC_PAL, {29{1'd0}}};
        `ADDRREG1 : ReadRegs  = START_ADDR;
         default  : ReadRegs  = {32{1'b0}};  // Read as zero default
    endcase
end 

always @ (posedge ACLK or negedge ARESETn)
begin : p_PrdataSeq
    if ((!ARESETn))
        iPRDATA <= {32{1'b0}};
    else if (ReadRegEn)
        iPRDATA <= nextPRDATA;
end

/////////////////////////////////
//Main state for request address channel

parameter IDLE          = 0;
parameter ARREQ         = 1;
parameter RECEIVE       = 1;

reg [4:0]MainState;
reg [4:0]NxMainState;

reg [3:0]ReadState;
reg [3:0]NxReadState;

always  @(DMA_REQ or
          rENABLE or
          MainState 
         ) 
begin
	NxMainState <= 0;
	case(1'b1)	// synopsys parallel_case full_case
        MainState[IDLE]:
            begin
                if(DMA_REQ & rENABLE)
                    NxMainState[ARREQ] <= 1'b1;
                else
                    NxMainState[IDLE]  <= 1'b1;
            end

        MainState[ARREQ]:
            begin
                if(!rENABLE)
                    NxMainState[IDLE]  <= 1'b1;
                else
                    NxMainState[ARREQ] <= 1'b1;
            end

    endcase
end

always @(RVALID  or RLAST or RREADY or 
         DMA_REQ or
         rENABLE or 
         ReadState)
begin
	NxReadState <= 0;
	case(1'b1)	// synopsys parallel_case full_case
        ReadState[IDLE]:
            begin
                if(DMA_REQ & rENABLE)
                    NxReadState[RECEIVE] <= 1'b1;
                else
                    NxReadState[IDLE]    <= 1'b1;
            end
        ReadState[RECEIVE]:
            begin
                if(!rENABLE | !DMA_REQ)
                    NxReadState[IDLE]    <= 1'b1;
                else
                    NxReadState[RECEIVE] <= 1'b1;
            end

    endcase
end

always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        MainState[0]    <= 1'b1;
        MainState[4:1]  <= 4'd0;
        ReadState[0]    <= 1'b1;
        ReadState[3:1]  <= 3'b0;
    end
    else
    begin
        MainState <= NxMainState;
        ReadState <= NxReadState;
    end
end


//Address channel request
////////////////////////////////////////////////////////////////////////////////////////////
reg    [DATA_WIDTH-1:0]  REQADDR;
reg    [3:0] ARLEN;
reg    ARVALID;

wire   [DATA_WIDTH-1:0] BURST_LEN;
wire   [DATA_WIDTH-1:0] END_ADDR;

/*
assign  END_ADDR   = (!rNTSC_PAL) ? (START_ADDR + END_ADDR_NTSC) 
                                  : (START_ADDR + END_ADDR_PAL);
*/
assign END_ADDR = rEND_ADDR;

assign  ARSIZE  = 3'b010; //Word size
assign  ARBURST = 2'b01;  //Inc

wire    OVERBURST16 = (END_ADDR < REQADDR+(16*4))  ? 1'b1 : 1'b0; 
wire    EQBURST     = (END_ADDR == REQADDR+(16*4)) ? 1'b1 : 1'b0;
assign  BURST_LEN   = ((END_ADDR - REQADDR ) >> 2) -1;

assign  ARADDR = REQADDR;

/*
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        ARLEN   <= 4'd0;
        ARVALID <= 1'd0;
    end
    else
    begin
        //if(NxMainState[ARREQ] & !ARVALID)
        if(MainState[ARREQ] & ARREADY)
        begin
            if(!OVERBURST16 | EQBURST)
                ARLEN   <= 4'b1111;
            else
                ARLEN   <= BURST_LEN[3:0];

            ARVALID <= 1'b1;
        end
        else if(!ARREADY)
            ARVALID <= 1'b1;
        else
            ARVALID <= 1'b0;
    end
end
*/

always @(OVERBURST16 or BURST_LEN)
begin
    if(!OVERBURST16)
        ARLEN = 4'b1111;
    else 
        ARLEN = BURST_LEN[3:0];
end

reg FirstStep_b;
always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        REQADDR   <= 32'd0;
        FirstStep_b <= 1'b0;
        //ARLEN   <= 4'd0;
        ARVALID <= 1'd0;
    end
    else
    begin
        if(WRITEOP && (PADDR[3:2] == `ADDRREG1)) // clear 
            REQADDR    <= PWDATA;
        else if(MainState[ARREQ]   & ARREADY & FirstStep_b)
        begin
            ARVALID <= 1'b1;
            if(EQBURST)
            begin
                REQADDR <= START_ADDR;
                //ARLEN   <= 4'b1111;
            end
            else if(!OVERBURST16)
            begin
                REQADDR <= REQADDR + (16*4);
                //ARLEN   <= 4'b1111;
            end
            else 
            begin
                //ARLEN   <= BURST_LEN[3:0];
                REQADDR <= START_ADDR;
            end
        end
        else if(MainState[ARREQ]   & ARREADY & !FirstStep_b)
        begin
            REQADDR <= START_ADDR;
            //ARLEN   <= 4'b1111;
            ARVALID <= 1'b1;
            FirstStep_b <= 1'b1;
        end
    end
end

////////////////////////////////////////////////////////////////


// Read channel process
////////////////////////////////////////////////////////////////
wire  [NUM_BYTE-1:0]    MEMWEn;
reg   [29:0]    MEMADDR;
wire            EmptyFIFO;
wire            FullFIFO;
wire  [1:0]     RemainFIFO;
wire            RemainOver1;
wire            MEMCEn;

assign  MEMWEn = (!ReadState[RECEIVE]) ? {NUM_BYTE{1'b1}} : {NUM_BYTE{1'b0}};
assign  MEMCEn = !ReadState[RECEIVE];
assign  RREADY = ReadState[RECEIVE];

always @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        MEMADDR <= {DATA_WIDTH{1'b0}};
    end
    else
    begin
        if(rCLEAR)
            MEMADDR <= {DATA_WIDTH{1'b0}}; 
        else if(ReadState[RECEIVE] & RVALID)// & !RLAST)
        begin
            MEMADDR <= MEMADDR + 1;
        end
    end
end

////////////////////////////////////////////////////////////////

//Register setting
wire    [1:0]   FIFO_WRITE;

reg     [31:0]  Buffer0;
reg     [31:0]  Buffer1;
reg     [2:0]   BufferCnt;
reg     [7:0]   TempBuffer;
reg     [6:0]   RAddressCnt;

wire    [1:0]   FIFO_READ = RAddressCnt[6:5];
wire    [1:0]   FIFO_WRITE_1up = FIFO_WRITE+2'd1;


////////////////////////////////////////////////////////////////////////

//Write process
assign  FIFO_WRITE = MEMADDR[6:5];

//Read process
always @(BufferCnt or Buffer0 or Buffer1)
begin
    case(BufferCnt)
        3'b000: TempBuffer = Buffer0[7:0];
        3'b001: TempBuffer = Buffer0[15:8];
        3'b010: TempBuffer = Buffer0[23:16];
        3'b011: TempBuffer = Buffer0[31:24];
        3'b100: TempBuffer = Buffer1[7:0];
        3'b101: TempBuffer = Buffer1[15:8];
        3'b110: TempBuffer = Buffer1[23:16];
        3'b111: TempBuffer = Buffer1[31:24];
    endcase
end

reg EmptyFIFO_1d;
reg EmptyFIFO_2d;
reg EmptyFIFO_3d;
reg EmptyFIFO_4d;
reg EmptyFIFO_5d;
reg EmptyFIFO_6d;
reg EmptyFIFO_7d;
reg EmptyFIFO_8d;
reg EmptyFIFO_9d;

always @(negedge ARESETn or posedge CLK_27MHZ)
begin
    if(!ARESETn)
    begin
        EmptyFIFO_1d <=1 ;
        EmptyFIFO_2d <=1 ;
        EmptyFIFO_3d <=1 ;
        EmptyFIFO_4d <=1 ;
        EmptyFIFO_5d <=1 ;
        EmptyFIFO_6d <=1 ;
        EmptyFIFO_7d <=1 ;
        EmptyFIFO_8d <=1 ;
        EmptyFIFO_9d <=1 ;
    end
    else
    begin
        EmptyFIFO_1d <= EmptyFIFO;
        EmptyFIFO_2d <= EmptyFIFO_1d;
        EmptyFIFO_3d <= EmptyFIFO_2d;
        EmptyFIFO_4d <= EmptyFIFO_3d;
        EmptyFIFO_5d <= EmptyFIFO_4d;
        EmptyFIFO_6d <= EmptyFIFO_5d;
        EmptyFIFO_7d <= EmptyFIFO_6d;
        EmptyFIFO_8d <= EmptyFIFO_7d;
        EmptyFIFO_9d <= EmptyFIFO_8d;
    end
end

always @(negedge ARESETn or posedge CLK_27MHZ)
begin
    if(!ARESETn)
    begin
       BufferCnt  <= 3'b000;
    end
    else
    begin
        if(rCLEAR)
            BufferCnt  <= 3'b000;
        else if(!EmptyFIFO_9d)
        begin
            BufferCnt <= BufferCnt + 1;
        end
    end
end


always @(negedge ARESETn or posedge CLK_27MHZ)
begin
    if(!ARESETn)
        RAddressCnt <= 0;
    else
    begin
        if(rCLEAR)
            RAddressCnt <= 0;
        else if(BufferCnt[1:0] == 2'b11)
            RAddressCnt <= RAddressCnt + 1;
    end
end

reg [DATA_WIDTH-1:0] RDATA_Temp;

/*
always @(FIFO_READ or 
         MEMRDATA0 or 
         MEMRDATA1 or
         MEMRDATA2 or
         MEMRDATA3 )
begin
    case(FIFO_READ)
        2'b00: RDATA_Temp <= MEMRDATA0 ;
        2'b01: RDATA_Temp <= MEMRDATA1 ;
        2'b10: RDATA_Temp <= MEMRDATA2 ;
        2'b11: RDATA_Temp <= MEMRDATA3 ;
    endcase
end
*/

always @(FIFO_READ or 
         MEMRDATA01 or 
         MEMRDATA11 or
         MEMRDATA21 or
         MEMRDATA31 )
begin
    case(FIFO_READ)
        2'b00: RDATA_Temp <= MEMRDATA01 ;
        2'b01: RDATA_Temp <= MEMRDATA11 ;
        2'b10: RDATA_Temp <= MEMRDATA21 ;
        2'b11: RDATA_Temp <= MEMRDATA31 ;
    endcase
end


wire                     RMEMCEn;

always @(negedge ARESETn or posedge CLK_27MHZ)
begin
    if(!ARESETn)
    begin
        Buffer0 <= 0;
        Buffer1 <= 0;
    end
    else
    begin
        if(BufferCnt[2] & !RMEMCEn & BufferCnt[1])
            Buffer0 <= RDATA_Temp;
        else if(!BufferCnt[2] & !RMEMCEn& BufferCnt[1])
            Buffer1 <= RDATA_Temp;
    end
end

//ouput process
reg     REQreg;
assign  EmptyFIFO = (FIFO_WRITE     == FIFO_READ) ? 1'b1 : 1'b0;
assign  FullFIFO  = (FIFO_WRITE_1up == FIFO_READ) ? 1'b1 : 1'b0;
assign  RemainFIFO= FIFO_WRITE - FIFO_READ;
assign  DMA_REQ   = REQreg;


reg     REQreg_1d;
reg     REQreg_2d;

always @(negedge ARESETn or posedge ACLK)
begin
    if(!ARESETn)
    begin
        REQreg    <= 1'b0;
        REQreg_1d <= 1'b0;
        REQreg_2d <= 1'b0;
    end
    else
    begin
        REQreg_1d <= !FullFIFO;
        REQreg_2d <= REQreg_1d;
        REQreg    <= REQreg_2d;
    end
end

wire   [DATA_WIDTH-1:0]  WrMEMADDR0;
wire   [DATA_WIDTH-1:0]  WrMEMADDR1;
wire   [DATA_WIDTH-1:0]  WrMEMADDR2;
wire   [DATA_WIDTH-1:0]  WrMEMADDR3;

wire                     WrMEMCEn0;
wire                     WrMEMCEn1;
wire                     WrMEMCEn2;
wire                     WrMEMCEn3;

//fifo remain 1 over
assign RemainOver1 = (RemainFIFO > 1) ? 1'b1 : 1'b0;
assign RMEMCEn     = (BufferCnt[0] | BufferCnt[1]) & EmptyFIFO_9d ; 

assign MEMADDR01 = (!FIFO_READ[0] & !FIFO_READ[1] & !EmptyFIFO_7d) ? RAddressCnt[4:0] : 5'd0 ;
assign MEMADDR11 = (FIFO_READ[0]  & !FIFO_READ[1] & !EmptyFIFO_7d) ? RAddressCnt[4:0] : 5'd0 ;
assign MEMADDR21 = (!FIFO_READ[0] & FIFO_READ[1] &  !EmptyFIFO_7d) ? RAddressCnt[4:0] : 5'd0 ;
assign MEMADDR31 = (FIFO_READ[0]  & FIFO_READ[1] &  !EmptyFIFO_7d) ? RAddressCnt[4:0] : 5'd0 ;

/*
assign MEMCEn0 = (!FIFO_READ[0] & !FIFO_READ[1] & !EmptyFIFO_9d) ? RMEMCEn : WrMEMCEn0;
assign MEMCEn1 = (FIFO_READ[0]  & !FIFO_READ[1] & !EmptyFIFO_9d) ? RMEMCEn : WrMEMCEn1;
assign MEMCEn2 = (!FIFO_READ[0] & FIFO_READ[1]  & !EmptyFIFO_9d) ? RMEMCEn : WrMEMCEn2;
assign MEMCEn3 = (FIFO_READ[0]  & FIFO_READ[1]  & !EmptyFIFO_9d) ? RMEMCEn : WrMEMCEn3;
*/

/*
assign MEMADDR0 = (!FIFO_READ[0] & !FIFO_READ[1] & !EmptyFIFO_9d) ? RAddressCnt[4:0] : WrMEMADDR0 ;
assign MEMADDR1 = (FIFO_READ[0]  & !FIFO_READ[1] & !EmptyFIFO_9d) ? RAddressCnt[4:0] : WrMEMADDR1 ;
assign MEMADDR2 = (!FIFO_READ[0] & FIFO_READ[1] &  !EmptyFIFO_9d) ? RAddressCnt[4:0] : WrMEMADDR2 ;
assign MEMADDR3 = (FIFO_READ[0]  & FIFO_READ[1] &  !EmptyFIFO_9d) ? RAddressCnt[4:0] : WrMEMADDR3 ;
*/


/*
wire MUX_CLK0;
wire MUX_CLK1;
wire MUX_CLK2;
wire MUX_CLK3;

assign MUX_CLK0 = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? ACLK : 1'b0;
assign MUX_CLK1 = (FIFO_WRITE[0]  & !FIFO_WRITE[1]) ? ACLK : 1'b0;
assign MUX_CLK2 = (!FIFO_WRITE[0] &  FIFO_WRITE[1]) ? ACLK : 1'b0;
assign MUX_CLK3 = (FIFO_WRITE[0]  & FIFO_WRITE[1] ) ? ACLK : 1'b0;


assign CLK0 = (!FIFO_READ[0] & !FIFO_READ[1] & !EmptyFIFO_2d) 
                               ? CLK_27MHZ: MUX_CLK0 ;

assign CLK1 = (FIFO_READ[0]  & !FIFO_READ[1]& !EmptyFIFO_2d) 
                               ? CLK_27MHZ: MUX_CLK1 ;

assign CLK2 = (!FIFO_READ[0] & FIFO_READ[1] & !EmptyFIFO_2d) 
                               ? CLK_27MHZ: MUX_CLK2 ;

assign CLK3 = (FIFO_READ[0]  & FIFO_READ[1] & !EmptyFIFO_2d) 
                               ? CLK_27MHZ: MUX_CLK3 ;
*/

//Write output
assign MEMADDR00   = WrMEMADDR0; 
assign MEMADDR10   = WrMEMADDR1; 
assign MEMADDR20   = WrMEMADDR2; 
assign MEMADDR30   = WrMEMADDR3; 

assign MEMWEn00    = !WrMEMCEn0;
assign MEMWEn10    = !WrMEMCEn1;
assign MEMWEn20    = !WrMEMCEn2;
assign MEMWEn30    = !WrMEMCEn3;

/*
assign MEMWEn00 = = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? !MEMWEn[0] : 1'b0;
assign MEMWEn10 = = ( FIFO_WRITE[0] & !FIFO_WRITE[1]) ? !MEMWEn[0] : 1'b0;
assign MEMWEn20 = = (!FIFO_WRITE[0] &  FIFO_WRITE[1]) ? !MEMWEn[0] : 1'b0;
assign MEMWEn30 = = ( FIFO_WRITE[0] &  FIFO_WRITE[1]) ? !MEMWEn[0] : 1'b0;
*/

assign MEMWDATA00 = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? RDATA : 0;
assign MEMWDATA10 = (FIFO_WRITE[0]  & !FIFO_WRITE[1]) ? RDATA : 0;
assign MEMWDATA20 = (!FIFO_WRITE[0] &  FIFO_WRITE[1]) ? RDATA : 0;
assign MEMWDATA30 = (FIFO_WRITE[0]  & FIFO_WRITE[1] ) ? RDATA : 0;

assign MEMWDATA01 = 0;
assign MEMWDATA11 = 0;
assign MEMWDATA21 = 0;
assign MEMWDATA31 = 0;

assign MEMWEn01 = 1'b0;
assign MEMWEn11 = 1'b0;
assign MEMWEn21 = 1'b0;
assign MEMWEn31 = 1'b0;

/*
assign MEMWEn0 = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? MEMWEn : {NUM_BYTE{1'b1}};
assign MEMWEn1 = (FIFO_WRITE[0]  & !FIFO_WRITE[1]) ? MEMWEn : {NUM_BYTE{1'b1}};
assign MEMWEn2 = (!FIFO_WRITE[0] & FIFO_WRITE[1] ) ? MEMWEn : {NUM_BYTE{1'b1}};
assign MEMWEn3 = (FIFO_WRITE[0]  & FIFO_WRITE[1] ) ? MEMWEn : {NUM_BYTE{1'b1}};
*/

assign WrMEMCEn0 = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? MEMCEn : 1'b1;
assign WrMEMCEn1 = (FIFO_WRITE[0]  & !FIFO_WRITE[1]) ? MEMCEn : 1'b1;
assign WrMEMCEn2 = (!FIFO_WRITE[0] & FIFO_WRITE[1] ) ? MEMCEn : 1'b1;
assign WrMEMCEn3 = (FIFO_WRITE[0]  & FIFO_WRITE[1] ) ? MEMCEn : 1'b1;

assign WrMEMADDR0 = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? MEMADDR : 0;
assign WrMEMADDR1 = (FIFO_WRITE[0]  & !FIFO_WRITE[1]) ? MEMADDR : 0;
assign WrMEMADDR2 = (!FIFO_WRITE[0] &  FIFO_WRITE[1]) ? MEMADDR : 0;
assign WrMEMADDR3 = (FIFO_WRITE[0]  & FIFO_WRITE[1] ) ? MEMADDR : 0;

/*
assign MEMWDATA0 = (!FIFO_WRITE[0] & !FIFO_WRITE[1]) ? RDATA : 0;
assign MEMWDATA1 = (FIFO_WRITE[0]  & !FIFO_WRITE[1]) ? RDATA : 0;
assign MEMWDATA2 = (!FIFO_WRITE[0] &  FIFO_WRITE[1]) ? RDATA : 0;
assign MEMWDATA3 = (FIFO_WRITE[0]  & FIFO_WRITE[1] ) ? RDATA : 0;
*/

wire [7:0] SubBuffer     = (TempBuffer >15 ) ? (TempBuffer-15) : 0;
wire [7:0] LimitedBuffer = (SubBuffer  >186) ? 186 : SubBuffer;

reg    rSYNC;
wire   wSYNC = (SubBuffer == 0) ? 1'b0: 1'b1;
assign SYNC  = rSYNC;
assign BLANK = rSYNC;

wire [13:0] OutBuffer = (LimitedBuffer * 11) >> 3;
//assign ADC_OUT = (!EmptyFIFO_9d) ? OutBuffer[7:0] : 8'd0;
reg  [7:0] OUT_DAC;

always @(posedge CLK_27MHZ or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        rSYNC   <= 0;
        OUT_DAC <= 8'd0;
    end
    else
    begin
        OUT_DAC <= OutBuffer[7:0];
        rSYNC   <= wSYNC;
    end
end

assign ADC_OUT = OUT_DAC;
endmodule
