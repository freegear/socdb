// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name        : pmcon_STM.v
// File Revision    : 0.1 
//  -----------------------------------------------------------------------------
//  Purpose         : Pseudo SRAM controller timing StateMachine
//  =============================================================================

`timescale 1ns/1ps
module  pmcon_STM (
			PCLK		,
			PRESETn		,
			PSEL		,
			PENABLE		,

			PWDATA		,
			PWSTRB		,
			PADDR		,
			Read		,
			Write		,
			PSRAMRDATA	, 
			Enable		, // register setting value
			PowerupSet	, // register setting value
			PowerupClr	, // register setting value
			PageSize	, // register setting value
			BurstRMode	, // register setting value
			NegCatch	,
			PSRAMTCON	, // register setting value
			PSRAMTOUT	, // register setting value

			DataRWAvail	, // APB memory interface for PREADY signal gen

			//---PSRAM_SIGNAL
			CSb			,
			ZZb			,
			OEb			,
			WEb			,
			UBb			,
			LBb			,
	
			ADDR		,
			DATAIN		,
			nDATAEN		,
			DATAOUT
			);

parameter ADDRESSWIDTH = 18;
input			PCLK;
input			PRESETn;
input			PSEL;
input			PENABLE;
input 	[31:0]	PWDATA;
input	[3:0]	PWSTRB;
input	[ADDRESSWIDTH:0]	PADDR;

input			Read;
input			Write;

output	[31:0]	PSRAMRDATA;

input			Enable;
input			PowerupSet;
input			PowerupClr;
input	[2:0]	PageSize;
input			BurstRMode;
input			NegCatch;
input	[31:0]	PSRAMTCON;
input	[10:0]	PSRAMTOUT;


output			DataRWAvail; // indicate Data updated

output			CSb;
output			ZZb;
output			OEb;
output			WEb;
output			UBb;
output			LBb;

output	[ADDRESSWIDTH-1:0]	ADDR; // PSRAM address

input	[15:0]	DATAIN;
output			nDATAEN;
output	[15:0]	DATAOUT;

////////////////////////////////////////////////////////////////
// STORE PREVIOUS ADDRESS FOR BURST READ
// 연속된 address 판별
//
reg 	[ADDRESSWIDTH:0]	PreviousAdr;
reg	cycle_cntEn ;
reg	nextcycle_cntEn ;
wire	ReadDone;
// 이전 address 저장
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	PreviousAdr <= 0;
	else if (ReadDone)
	PreviousAdr <= PADDR;
end

// support page 0, 2, 4, 8, 16
// Burst Addres Detect
reg		InPageAddr;
wire	CSb;

always @(PageSize or PreviousAdr or PADDR or CSb)
begin
	case (PageSize) // synopsys parallel_case full_case
		0:	InPageAddr = 1'b0;  // page size 0 
		1:	InPageAddr = (PreviousAdr[ADDRESSWIDTH:1] == PADDR[ADDRESSWIDTH:1])&(~CSb)? 1'b1 : 1'b0;	// Page Size 2
		2:  InPageAddr = (PreviousAdr[ADDRESSWIDTH:2] == PADDR[ADDRESSWIDTH:2])&(~CSb)? 1'b1 : 1'b0;	// Page Size 4
		3:  InPageAddr = (PreviousAdr[ADDRESSWIDTH:3] == PADDR[ADDRESSWIDTH:3])&(~CSb)? 1'b1 : 1'b0;	// Page Size 8
		4:  InPageAddr = (PreviousAdr[ADDRESSWIDTH:4] == PADDR[ADDRESSWIDTH:4])&(~CSb)? 1'b1 : 1'b0;	// Page Size 16
		default :
			InPageAddr = 1'b0;
	endcase
end

////////////////////////////////////////////////////////////////
//  MAIN STATE
//
// Memory access sequency
// 16bit => 32bit read/write
// main state 
// powerup => read/write
`define IDLE	 2'b00
`define POWER_UP 2'b01
`define WORKING	 2'b10


reg [1:0]	nextmain_state;
reg [1:0]	main_state;

always @(main_state or Enable or PowerupSet or PowerupClr)
begin
	nextmain_state = main_state;
	if (Enable & PowerupSet) // PowerupSet is Register setting input
	nextmain_state = `POWER_UP;
	else if (Enable & PowerupClr)
	nextmain_state = `WORKING;
	else if (~Enable)
	nextmain_state = `IDLE;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	main_state <= `IDLE;
	else 
	main_state <= nextmain_state;
end

//---------------------------------------------------------

//////////////////////////////////////////////////////////////
//	INTERNAL READ WRITE STATE
//
// state of working
// IDLE => READ => WRITE
// internal READ/WRITE state
// idle => read => burst read  =>idle
//                             => read
//              => read
//              => idle                
`define RW_IDLE			5'b00001
`define RW_READ			5'b00010
`define RW_BURSTREAD	5'b00100
`define RW_WRITE		5'b01000
`define RW_WAIT			5'b10000

///-------------------------------
// 16 bit to 32 bit repeat mode counter
//
wire    WriteDone;
reg     nextRW_cnt;
reg     RW_cnt;
reg 	[4:0]   nextrw_state;

/// 16bit X 2 cycle
// WAIT와 관계없이  Write나 Read가 발생하면 바뀐다.

reg UpperWrite;
reg LowerWrite;
always @(PWSTRB)
begin
	//if (PWSTRB[3:2] >0)
	if (PWSTRB[3]|PWSTRB[2])
	UpperWrite = 1'b1;
	else
	UpperWrite = 1'b0;
end

always @(PWSTRB)
begin
	//if (PWSTRB[1:0] >0)
	if (PWSTRB[1]|PWSTRB[0])
	LowerWrite = 1'b1;
	else
	LowerWrite = 1'b0;
end


always @(Write or WriteDone or Read or ReadDone or RW_cnt or
		UpperWrite or LowerWrite)
begin
    nextRW_cnt = RW_cnt;
    if (((Write)&(UpperWrite&LowerWrite))|(Read))
    nextRW_cnt = 1 ;
    else if (WriteDone|ReadDone)
    nextRW_cnt = 0;
end

always @(posedge PCLK or negedge PRESETn)
begin
    if (!PRESETn)
    RW_cnt <= 0;
    else
    RW_cnt <= nextRW_cnt;
end

/////////////////////////////////////////////////////////
// 2nd 16bit Read or Write signal
wire 	RepeatW;
wire 	RepeatR;
assign  RepeatW = (WriteDone) & (RW_cnt) ;
assign  RepeatR = (ReadDone) & (RW_cnt);

reg [4:0]	rw_state;
reg [10:0]	ToutCnt;

// State Trasition Signal

wire	go_rwidle;
wire	go_rwread;
wire	go_rwburstread;
wire	go_rwwrite;


assign go_rwidle 		= (((~Enable)|~(main_state ==`WORKING))&~((rw_state==`RW_IDLE)));

assign go_rwread 		= (main_state == `WORKING) &( 
						  ((
							(Read & (~BurstRMode|(rw_state == `RW_WRITE)|(rw_state == `RW_IDLE)|~InPageAddr))	)|
							(RepeatR&~BurstRMode)	));

assign go_rwburstread 	= (main_state == `WORKING) &
						  (
							(Read & ((rw_state == `RW_READ)|(rw_state == `RW_BURSTREAD)) & BurstRMode & InPageAddr)|
							(RepeatR & BurstRMode)
						   ) ;// Previous address is in burst area

assign go_rwwrite 		= (main_state == `WORKING) & ((Write&~cycle_cntEn)| RepeatW);// only single write


always @(rw_state or go_rwidle or go_rwread or 
		go_rwburstread or go_rwwrite ) 
begin
		nextrw_state = rw_state;
		if (go_rwidle)
		nextrw_state = `RW_IDLE;
		else if	(go_rwread)
		nextrw_state = `RW_READ;
		else if (go_rwburstread)   
		nextrw_state = `RW_BURSTREAD;
		else if	(go_rwwrite)
		nextrw_state = `RW_WRITE;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	rw_state <= `RW_IDLE;
	else 
	rw_state <= nextrw_state;
end


//---------------------------------------------------------------
// Read중 Write중 판별 signal

//---------------------------------------------------------
// Page READ Timeout Counter
// Down Counter 11bit counter

reg cur_CS;
wire CS_low;


// Time out 

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	ToutCnt <= 11'b11111111111;
	else if ((/*CS_low &*/ cur_CS ))//|(Read & ~InPageAddr))
	ToutCnt <= PSRAMTOUT;
	else if (~cur_CS & ~(ToutCnt==0))
	ToutCnt <= ToutCnt -1;
end

///////////////////////////////////////////////////////////
// counter 
///////////////////////////////////////////////////////////
// timer match value
reg	[3:0]	cycle_cnt;
reg	[3:0]	hold_cnt;
wire [3:0] tRC 	= PSRAMTCON[31:28];
wire [3:0] tAA 	= PSRAMTCON[27:24];
wire [3:0] tPRC = PSRAMTCON[23:21];
wire [3:0] tPA 	= PSRAMTCON[20:18];
wire [3:0] tWC 	= PSRAMTCON[17:14];
wire [3:0] tAS 	= PSRAMTCON[13:12]; // value 0 able
wire [3:0] tWP 	= PSRAMTCON[11:8]; //WP = tWC-tAS-tWR
wire [3:0] tDW 	= PSRAMTCON[7:4];  // tDW start point setting	
wire [3:0] tDH 	= PSRAMTCON[3:0];	// value 0 able  we are not using this value !! //
 

wire	tRC_time;
wire	tAA_time;
wire 	tPRC_time;
wire	tPA_time;
wire	tWC_time;
wire	tAS_time;
wire	tWR_time;
wire	tDW_time;
wire	Ld_0;
wire	Hold_Start;
wire	Hold_Done;
// match up
assign tRC_time		= (rw_state == `RW_READ)&(cycle_cnt == tRC)?	1'b1: 1'b0;
assign tAA_time 	= (rw_state == `RW_READ)&(cycle_cnt == tAA)?	1'b1: 1'b0; //data read time
// burst read count
assign tPRC_time 	= (rw_state == `RW_BURSTREAD)&(cycle_cnt == tPRC)?	1'b1: 1'b0;
assign tPA_time 	= (rw_state == `RW_BURSTREAD)&(cycle_cnt == tPA)?	1'b1: 1'b0;


// write cycle
assign tWC_time 	= (rw_state == `RW_WRITE)&(cycle_cnt == tWC)?	1'b1: 1'b0;
assign tAS_time 	= (rw_state == `RW_WRITE)&(cycle_cnt == tAS)?	1'b1: 1'b0;
assign tWR_time 	= (rw_state == `RW_WRITE)&(cycle_cnt == (tAS+tWP))?	1'b1: 1'b0;
assign tDW_time		= (rw_state == `RW_WRITE)&(cycle_cnt == tDW)?	1'b1: 1'b0; // tDW start time

//----------------------- 16bit read write done signal---------------------
assign ReadDone		=((rw_state == `RW_READ)&(tRC_time))|
					((rw_state == `RW_BURSTREAD)&(tPRC_time));

assign WriteDone 	= 	((rw_state == `RW_WRITE)&(tWC_time));



assign Ld_0 = 	(Enable) &(go_rwidle | go_rwread | go_rwburstread | go_rwwrite );

////////////////////////////////////////////////////////
// write cycle hold time
//
// hold start is (AStime + WPtime) - tDW
assign 	Hold_Start 	= /*(rw_state == `RW_WRITE)&(tDW_time)|*/
			((((nextrw_state == `RW_WRITE)&tDW_time)|((Write|go_rwwrite)&(tDW==0))))
 ?	1'b1: 1'b0;// revision


assign 	Hold_Done	= (hold_cnt ==  (tDH))?		1'b1: 1'b0;

reg		Hold;
reg		nextHold;

always @(Hold_Start or Hold_Done or Hold)
begin
	nextHold = Hold;
	if (Hold_Start)
	nextHold = 1;
	else if (Hold_Done)
	nextHold = 0;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	hold_cnt <= 0;
	Hold <= 0;
	end
	else 
		begin
		Hold <= nextHold;
		if (~Hold)
		hold_cnt <=0;
		else if (Hold)
		hold_cnt <= hold_cnt+1;
		end
end


///-----------------------------------------------------------------------
/// counting Read / Write Cycle
// 카운팅 구간 설정
always @(Read or Write or ReadDone or WriteDone or
		nextrw_state or	cycle_cntEn or RW_cnt or go_rwread or go_rwwrite)
begin
	nextcycle_cntEn = cycle_cntEn;
	if ((Read&~(nextrw_state==`RW_WAIT))|Write|go_rwwrite|go_rwread)
	nextcycle_cntEn = 1;
	else if ((ReadDone|WriteDone)&~RW_cnt)
	//else if ((ReadDone&~RW_cnt) |(WriteDone&~RW_cnt))
	nextcycle_cntEn =0;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn) 
		cycle_cntEn <= 0;
	else
		cycle_cntEn <= nextcycle_cntEn;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn) 
	begin
		cycle_cnt <= 0;
	end
	else
		begin
		if (Ld_0)
		cycle_cnt <= 0;
		else if (Enable & cycle_cntEn &((rw_state==`RW_READ)|(rw_state==`RW_WRITE)|(rw_state==`RW_BURSTREAD)))
		cycle_cnt <= cycle_cnt+1;			
		end
end

///////////////////////////////////////////////////////////////
//
//	DATA READ
//  16 bit to 32 bit 
//   Read timing 
/// for usign Negative Edge Data Catch


reg	[31:0]	NextPSRAMRDATA;
reg	[31:0]	PSRAMRDATA;
wire	ReadUpd;
wire	BurstReadUpd;
assign 	ReadUpd = (rw_state ==`RW_READ) && (tAA_time);
assign 	BurstReadUpd = (rw_state ==`RW_BURSTREAD) && (tPA_time);

always @(PSRAMRDATA or DATAIN or ReadUpd or BurstReadUpd)
begin
	NextPSRAMRDATA = PSRAMRDATA;
	//if  (ReadUpd | BurstReadUpd)
	if  (ReadUpd | BurstReadUpd)
	NextPSRAMRDATA = {DATAIN[15:0], PSRAMRDATA[31:16]};	
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	PSRAMRDATA <= 0;
	else 
	PSRAMRDATA <= NextPSRAMRDATA;
end

///////////////////////////////////////////////////////////////
// 
// DATA OUTPUT 32 bit data to 16 bit shift output
/*
reg	[31:0]	PSRAMWDATA;
reg	[31:0]	NextPSRAMWDATA;
// Write 가 들어오면  write data를 저장하고 16bit를 먼저 write
// 나머지 16bit를 write한다.
always @( PSRAMWDATA or Write or PWDATA)
begin
	NextPSRAMWDATA = PSRAMWDATA;
	if (Write)
		NextPSRAMWDATA = PWDATA;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	PSRAMWDATA <= 0;
	else
	PSRAMWDATA <= NextPSRAMWDATA;
end
*/
// DATA OUTPUT
reg [15:0] NextDATAOUT;
reg [15:0] DATAOUT;
//always @(rw_state or Hold_Start or DATAOUT or PSRAMWDATA or RW_cnt or
//		LowerWrite or UpperWrite)// revision 2.21
always @(nextrw_state or Hold_Start or DATAOUT or PWDATA or nextRW_cnt or
		LowerWrite or UpperWrite)
begin
	NextDATAOUT = DATAOUT;
	//if ((rw_state == `RW_WRITE) & Hold_Start  & RW_cnt)//Upper and lower write
	if ((nextrw_state == `RW_WRITE) & Hold_Start  & nextRW_cnt)//Upper and lower write // revision 2.21
	begin
//		NextDATAOUT = PSRAMWDATA[15:0];
		NextDATAOUT = PWDATA[15:0];
	end
	//else if ((rw_state== `RW_WRITE) & Hold_Start & ~RW_cnt)
	else if ((nextrw_state== `RW_WRITE) & Hold_Start & ~nextRW_cnt)// 2.21
	begin
		if (UpperWrite)
		NextDATAOUT = PWDATA[31:16];
		//NextDATAOUT = PSRAMWDATA[31:16];
		else if (LowerWrite)
		NextDATAOUT = PWDATA[15:0];
		//NextDATAOUT = PSRAMWDATA[15:0];
	end
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	DATAOUT <= 0;	
	else
	DATAOUT <= NextDATAOUT;
end

///////////////////////////////////////////////////////////////
//// Pin output
///////////////////////////////////////////////////////////////

wire	CS_high;
wire	ZZ_low;
wire	ZZ_high;
wire	OE_low;
wire	OE_high;
wire	WE_low;
wire	WE_high;
wire	UB_low;
wire	LB_low;
wire	UB_high;
wire	LB_high;
wire	ADRupdat;
assign	CS_low 	= 	(nextmain_state ==`WORKING)&
					(((Read&~(nextrw_state==`RW_WAIT))|go_rwread)|
						((nextrw_state== `RW_WRITE)&tAS_time)|((Write|go_rwwrite)&(tAS==0)));

assign	CS_high = 	(~cycle_cntEn& (ToutCnt==0))|// refresh done
					(nextmain_state ==`POWER_UP)|
					(nextmain_state == `IDLE)|
					(nextrw_state==`RW_WAIT)|
					(ReadDone&~RW_cnt&~(nextrw_state== `RW_BURSTREAD))|
					(WriteDone&~RW_cnt);

assign	ZZ_low	= 	(nextmain_state ==`IDLE);
assign	ZZ_high	= 	(nextmain_state ==`POWER_UP);

assign	OE_low	= 	(nextmain_state ==`WORKING) & 
					((nextrw_state == `RW_READ)|(nextrw_state == `RW_BURSTREAD));
assign	OE_high	= 	(nextmain_state ==`IDLE)|
					(nextrw_state == `RW_WRITE);

assign	WE_low	= 	(nextmain_state == `WORKING)&
					(((nextrw_state == `RW_WRITE)&tAS_time)|
					((Write|go_rwwrite)&(tAS==0)));

assign	WE_high	= 	(nextmain_state == `IDLE)|
					((nextmain_state==`WORKING)&((nextrw_state==`RW_READ)|(nextrw_state==`RW_BURSTREAD)|
					((nextrw_state == `RW_WRITE) & tWR_time)));

assign	UB_low	= 	(nextmain_state == `WORKING)&&
					((nextrw_state  == `RW_READ)|
					 (nextrw_state  ==`RW_BURSTREAD)|
					 ((nextrw_state  == `RW_WRITE)&&
					  ((RW_cnt&PWSTRB[1])|
					   (~RW_cnt&UpperWrite&PWSTRB[3])|
					   (~RW_cnt&~UpperWrite&LowerWrite&PWSTRB[1]))));

assign	LB_low	= 	(nextmain_state == `WORKING)&&
					((nextrw_state == `RW_READ)|
					 (nextrw_state==`RW_BURSTREAD)|
					 ((nextrw_state == `RW_WRITE)&&
					  ((RW_cnt&PWSTRB[0])|
					   (~RW_cnt&UpperWrite&PWSTRB[2])|
					   (~RW_cnt&LowerWrite&~UpperWrite&PWSTRB[0]))));

assign	UB_high= 	(nextmain_state == `IDLE)|
					((nextrw_state== `RW_WRITE)&
					((~PWSTRB[3]&UpperWrite)|
					 (~PWSTRB[1]&LowerWrite))) ;
assign	LB_high= 	(nextmain_state == `IDLE)|
					((nextrw_state== `RW_WRITE)&
					 ((~PWSTRB[2]&UpperWrite)|
					  (~PWSTRB[0]&LowerWrite))) ;

assign	ADRupdat= 	(nextmain_state == `WORKING)&&
					( (((Read|go_rwread)&~(nextrw_state==`RW_WAIT)))|(ReadDone&RW_cnt)|
					((Write&~(nextrw_state==`RW_WAIT))|go_rwwrite)|(WriteDone&RW_cnt));


reg	nxt_CS;
always @(cur_CS or CS_low or CS_high)
begin	
		nxt_CS = cur_CS;
		if (CS_low)
		nxt_CS = 1'b0;
		else if (CS_high)
		nxt_CS = 1'b1;
end

reg	nxt_ZZ;
reg	cur_ZZ;
always @(cur_ZZ or ZZ_low or ZZ_high)
begin	
		nxt_ZZ = cur_ZZ;
		if (ZZ_low)
		nxt_ZZ = 1'b0;
		else if (ZZ_high)
		nxt_ZZ = 1'b1;
end

reg	nxt_WE;
reg	cur_WE;
always @(cur_WE or WE_low or WE_high)
begin	
		nxt_WE = cur_WE;
		if (WE_low)
		nxt_WE = 1'b0;
		else if (WE_high)
		nxt_WE = 1'b1;
end

reg	nxt_OE;
reg cur_OE;
always @(cur_OE or OE_low or OE_high)
begin
		nxt_OE = cur_OE;
		if (OE_low)
		nxt_OE = 1'b0;
		else if (OE_high)
		nxt_OE = 1'b1;
end

reg nxt_UB;
reg	cur_UB;	
always @(cur_UB or UB_low or UB_high)
begin
		nxt_UB = cur_UB;
		if (UB_low)
		nxt_UB = 1'b0;
		else if(UB_high)
		nxt_UB = 1'b1;
end

reg nxt_LB;
reg cur_LB;
always @(cur_LB or LB_low or LB_high)
begin
	nxt_LB = cur_LB;
	if (LB_low)
	nxt_LB = 1'b0;
	else if (LB_high)
	nxt_LB = 1'b1;
end




/// ADDRESS UPDAT timing
// address store

// Address Gen
reg [ADDRESSWIDTH-1:0] ADR;
reg [ADDRESSWIDTH-1:0] NextADR;
always @(Read or Write or nextrw_state or PADDR or ADR or ADRupdat or RW_cnt )  
begin
	NextADR = ADR;
	if (Read&~(nextrw_state==`RW_WAIT))
	NextADR = {PADDR[ADDRESSWIDTH:2],1'b0};
	else if (Write&~(nextrw_state==`RW_WAIT))
	NextADR = {PADDR[ADDRESSWIDTH:1]};
	else if (ADRupdat & RW_cnt)
	NextADR = ADR+1;
end
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	ADR <= 0;
	else
	ADR <= NextADR;
end


//---------------------------------------------------------------
//	OUTPUT Stage
//
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
	cur_CS	<= 1'b1;
	cur_ZZ	<= 1'b0;
	cur_WE	<= 1'b1;
	cur_OE	<= 1'b1;
	cur_UB  <= 1'b1;
	cur_LB  <= 1'b1;
	end
	else
	begin
	cur_CS	<= nxt_CS;
	cur_ZZ	<= nxt_ZZ;
	cur_WE	<= nxt_WE;
	cur_OE	<= nxt_OE;
	cur_UB  <= nxt_UB;
	cur_LB  <= nxt_LB;
	end
end

assign CSb 	= cur_CS;// |(Read & ~InPageAddr);
assign ZZb	= cur_ZZ;
assign WEb 	= cur_WE;
assign OEb 	= cur_OE;
assign UBb 	= cur_UB;
assign LBb 	= cur_LB;
assign ADDR	=	ADR;
assign nDATAEN = ~Hold;

/// DATAREAD WRITE ABLE bit for PREDAY signal generation

// Time out 발생시 DataRWAvail을 내보내지 않는다.
// Refresh 후에 DataRWAvail을 high로 만든다. (Read 또는 Write가 끝나지 않았을 경우에)
// Read나 Burst Read Done이 발생한 상황에서 Timeout이 발생하면 CS를 high로 만들고
// 이때 들어오는 Read나 Write는 Refresh가 끝난 뒤에 start하게 된다.
// Write가 끝난 상태에서 Time out 발생시

/*assign DataRWAvail = Enable&
					((main_state ==`WORKING)&~(nextmain_state == `IDLE)&~(nextmain_state == `POWER_UP))&

					((rw_state==`RW_IDLE)|
					( ((rw_state == `RW_READ)|(rw_state==`RW_BURSTREAD))&~cycle_cntEn&~(ToutCnt==0) )| // ToutCnt는 refresh가 끝나면 reset

					((rw_state == `RW_WRITE)&~cycle_cntEn&nDATAEN&~(ToutCnt==0)) );
*/
// PREADY Signal Generate


reg	PREADY;
reg NextPREADY;
wire	go_pready1;
assign go_pready1=	((( (rw_state == `RW_READ)|(rw_state==`RW_BURSTREAD) )&~cycle_cntEn&~(ToutCnt==0) )| // ToutCnt는 refresh가 끝나면 reset
					((rw_state == `RW_WRITE)&~cycle_cntEn&nDATAEN&~(ToutCnt==0)) );

//assign Read1 = ~PENABLE & PSEL ;


always @(PREADY or Read or Write or go_pready1 or PENABLE) begin
	NextPREADY = PREADY;
	if (Read|Write|~PENABLE)
	NextPREADY = 1'b0;
	else if (go_pready1)
	NextPREADY = 1'b1;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	PREADY <=1'b1;
	else
	PREADY <= NextPREADY;
end

assign DataRWAvail = PREADY;








/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// synopsys translate_off
reg [8*10 : 1] MState;

always @(main_state)
begin
  if (main_state == 2'b00)
    MState = "IDLE";
  else if (main_state == 2'b01)
    MState = "POWER_UP";
  else if (main_state == 2'b10)
    MState = "WORKING";
end

reg [8*10 : 1] NMState;

always @(nextmain_state)
begin
  if (nextmain_state == 2'b00)
    NMState = "IDLE";
  else if (nextmain_state == 2'b01)
    NMState = "POWER_UP";
  else if (nextmain_state == 2'b10)
    NMState = "WORKING";
end

reg [8*10 : 1] InterState;

always @(rw_state)
begin
  if (rw_state == 6'b000001)
    InterState = "RW_IDLE";
  else if (rw_state == 6'b000010)
    InterState = "RW_READ";
  else if (rw_state == 6'b000100)
    InterState = "RE_BURSTR";
  else if (rw_state == 6'b001000)
    InterState = "RW_WRITE";
  else if (rw_state == 6'b010000)
    InterState = "RW_RPEND";
  else if (rw_state == 6'b100000)
    InterState = "RW_WPEND";
end

reg [8*10 : 1] NInterState;

always @(nextrw_state)
begin
  if (nextrw_state == 6'b000001)
    NInterState = "RW_IDLE";
  else if (nextrw_state == 6'b000010)
    NInterState = "RW_READ";
  else if (nextrw_state == 6'b000100)
    NInterState = "RE_BURSTR";
  else if (nextrw_state == 6'b001000)
    NInterState = "RW_WRITE";
  else if (nextrw_state == 6'b010000)
    NInterState = "RW_RPEND";
  else if (nextrw_state == 6'b100000)
    NInterState = "RW_WPEND";
end
// synopsys translate_on
endmodule
