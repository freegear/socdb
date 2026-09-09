// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : mmc_DataControl.v
// File Revision       : Ver 3.0 - CT2000 (TSMC)
// Revision History    : 
// 
//  ----------------------------------------------------------------
// Descrition          : Data control state machine module of mmc/sd 
//  ----------------------------------------------------------------


`timescale 1ns/1ps

`define DATA_IDLE           7'b0000001
`define DATA_TRANS_WAIT     7'b0000010
`define DATA_BLOCK_SEND     7'b0000100
`define DATA_BUSYCHECK      7'b0001000
`define DATA_RCV_WAIT	    7'b0010000
`define DATA_BLOCK_RECEIVE  7'b0100000
`define DATA_CONTINUE_SEND  7'b1000000

`define NoOperation             2'b00
`define OnlyBusyChk             2'b01
`define DatReceive              2'b10
`define DatTransmit             2'b11

module mmc_DataControl(
	nRst,
	SDreset,
	PCLK,
   	neg_CKPulse,      
   	CKPulse,      
	
	// register input
	ByteOrder,// 0: normal mode 1: ACMD51 ACMD13  read
	SDIDTimer,
	SDIBSize,
	TARSP,
	RACMD,
	BlkMode,
	WideBus,
	MMCPlus, // adding for MMCPlus Mode( 8bit DAT line)
	DTST,
	DatMode,
	BlkNum,
	
	BusyRsp,
	AbortCmd, // CMD12,CMD52등의 command가 완료되었는지를 나타내는 입력 
	
	// register output
	BlkNumCnt,
	BlkDatCnt,
	NoBusySet,
	CrcStaSet,
	DatCrcSet,
	DatToutSet,
	DatFinSet,
	BusyFinSet,

	TxDatOn,
	RxDatOn,
   
	DTSTClr,	
	RspFinSet,
	CmdSentSet,

	TxActive,
	TxRdPtrInc,
	RxActive,
	RxWriteEn,
	FIFOWriteData,

	TFREmpty,
	RFFull,
	FIFOReadData,

	ENCLK2,
	nDATEN,
	Inv_nDATEN,
	DATOUT,
	Inv_DATOUT,
	DATIN,
	BusyChkIdle,
	DatCtrlIdle
);
`define HSMMC

`ifdef HSMMC
parameter AW=8;
`else 
parameter AW=4;
`endif
input           nRst;            
input			SDreset;
input           PCLK;        
input           neg_CKPulse;      
input           CKPulse;      
input	[AW-1:0]	DATIN;      // Data input line
output	[AW-1:0]	DATOUT;		// Data output line
output	[AW-1:0]	Inv_DATOUT;
output			nDATEN;
output			Inv_nDATEN;

output			ENCLK2;
input			ByteOrder;
input  [31:0]   SDIDTimer;   	// Data Timer Register  revision
input  [15:0]   SDIBSize;  	// Data Length Register

input			TARSP;
input			RACMD;
input			BlkMode;
input			WideBus;
input           MMCPlus;
input           RspFinSet;
input			CmdSentSet;
input			TFREmpty;
input			RFFull;			

input   [31:0]  FIFOReadData;
input			DTST;
input	[1:0]	DatMode;
input	[15:0]	BlkNum;
input			BusyRsp;
input			AbortCmd;

output          NoBusySet;	
output			CrcStaSet;
output			DatCrcSet;
output			DatToutSet;
output			DatFinSet;
output			BusyFinSet;
output			TxDatOn;
output			RxDatOn;

output			DTSTClr;
output	[15:0]	BlkNumCnt;
output	[15:0]	BlkDatCnt;

output			TxActive;
output			TxRdPtrInc;
output			RxActive;
output			RxWriteEn;
output	[31:0]	FIFOWriteData;

output			BusyChkIdle;
output			DatCtrlIdle;

reg 	[15:0]  BlkDatCnt ;
reg 			DTSTClr;
reg				ENCLK2;

// -----------------------------------------------------------------------------
// Data Shift Register 관련
// -----------------------------------------------------------------------------

reg [31:0]      DATSR;
reg [31:0]      NextDATSR;
reg             LdFIFOData; // FIFO to Data Shift register
reg             BlkDatCntEn; // Data shift enable
reg             NextBlkDatCntEn;

// -----------------------------------------------------------------------------
// Data output 관련
// -----------------------------------------------------------------------------

reg             LdEndBit; // Stop Bit를 로드함
reg             LdStartBit; // Start Bit를 로드함

reg             LdCRC; // data out은 crc값으로 내보냄
reg [AW-1:0]    NextDATOUT;
reg [AW-1:0]    DATOUT;

// -----------------------------------------------------------------------------
// Block counter...
// -----------------------------------------------------------------------------

reg             LdBlkSize;  // BlkSize를 BlkDatCnt로 불러옴

// -----------------------------------------------------------------------------
// Block Number counter...
// -----------------------------------------------------------------------------

reg             LdBlkNum;
reg	[15:0]  	BlkNumCnt ;
reg				BlkNumCntSet;	
// -----------------------------------------------------------------------------
// Word counter...
// -----------------------------------------------------------------------------
reg             LdWORDCnt3;
reg [1:0]       WORDCnt;

// -----------------------------------------------------------------------------
// Nibble counter...
// -----------------------------------------------------------------------------
reg             LdNibbleCnt;
reg             NibbleCnt;

// -----------------------------------------------------------------------------
// Bit counter...
// -----------------------------------------------------------------------------
reg             LdBitCnt;
reg [2:0]       BitCnt;

// -----------------------------------------------------------------------------
// Transferred block counter...
// -----------------------------------------------------------------------------

reg             LdSDIBSize;
reg             LdSDIDTimer;
/*reg				LdStateCnt0;*/
reg				LdStateCnt1;
reg				LdStateCnt2;
reg             LdStateCnt7;
reg             LdStateCnt8;
reg             LdStateCnt15;
reg             LdStateCnt16;
reg [31:0]      StateCnt;

// -----------------------------------------------------------------------------
//  CRCStatus counter
// -----------------------------------------------------------------------------

reg [2:0]		CRCStatusCnt;
reg 			LdCRCStatusCnt4;
reg 			LdCRCStatusCnt1;
reg 			CRCStatusChkSet;
reg				CRCStatusChk;
wire			NextCRCStatusChk;

// -----------------------------------------------------------------------------
reg 			BusyStatus;

reg 			RxActive;
reg         	NextRxActive;    

reg				TxActive;
reg         	NextTxActive;    

reg         	NextTxRdPtrInc;  
reg         	TxRdPtrInc;      

reg 			CRCStatusGet;

reg 			CRCCheck;
wire 			NextCRCCheck;
reg 			CRCCheckSet;
reg 			DatBlkEndSet;

// -----------------------------------------------------------------------------
reg         	LdDataBufferSet;
reg         	LdDataBuffer;

reg [31:0]      FIFOWriteData;
reg             RxWriteEn;
reg [31:0]      NextFIFOWriteData;
reg             NextRxWriteEn;
reg             TxCRCSend;

// -----------------------------------------------------------------------------
//  CRC block reg
// -----------------------------------------------------------------------------
`ifdef HSMMC
reg [15:0]      NextD7CRCSR;
reg [15:0]      NextD6CRCSR;
reg [15:0]      NextD5CRCSR;
reg [15:0]      NextD4CRCSR;
`endif
reg [15:0]      NextD3CRCSR;
reg [15:0]      NextD2CRCSR;
reg [15:0]      NextD1CRCSR;
reg [15:0]      NextD0CRCSR;

`ifdef HSMMC
reg [15:0]      D7CRCSR;
reg [15:0]      D6CRCSR;
reg [15:0]      D5CRCSR;
reg [15:0]      D4CRCSR;
`endif
reg [15:0]      D3CRCSR;
reg [15:0]      D2CRCSR;
reg [15:0]      D1CRCSR;
reg [15:0]      D0CRCSR;
reg             TxCRCCal;
reg             RxCRCCal;

reg             NextTxCRCCal;  
reg             NextTxCRCSend; 

//------------------------------------------------------------------------------
reg				NextnDATEN;
reg				nDATEN;


// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

reg	    		CRCStatusStr;
reg         	NextCRCStatusStr;  
reg         	NextRxCRCCal;  
reg         	NextCRCStatusGet;      
reg        		NextBusyStatus;     
reg         	DatFinSet;         
reg         	DatToutSet;        

// -----------------------------------------------------------------------------
// StateMachine 
// -----------------------------------------------------------------------------

reg [6:0]       NextDATAState;   
reg [6:0]       DATAState;

// Power Save Signal

wire	DatCtrlIdle;
assign 	DatCtrlIdle = (DATAState == `DATA_IDLE);


// -----------------------------------------------------------------------------
// StateMachine internal use
// -----------------------------------------------------------------------------

reg             NextStartBit;    
reg             NextStopBit;     
reg             StartBit;        
reg             StopBit;         

// -----------------------------------------------------------------------------
// Bus Size Select (Support 1, 4, 8 bit Bus Mode)
// -----------------------------------------------------------------------------

wire	SD1bitMode;
wire	SD4bitMode;
wire	MMCPlusMode;
`ifdef HSMMC
assign  SD1bitMode  = (~WideBus && ~MMCPlus)?   1'b1 : 1'b0;
assign  SD4bitMode  = (WideBus && ~MMCPlus)?	1'b1 : 1'b0;
assign  MMCPlusMode = (MMCPlus)? 1'b1 : 1'b0;
`else
assign  SD1bitMode  = (~WideBus)?   1'b1 : 1'b0;
assign  SD4bitMode  = (WideBus)?	1'b1 : 1'b0;
assign  MMCPlusMode = 1'b0;
`endif
//-------------------------------------------------------------------------------
// Tx 데이터 전송 중. Status.
//-------------------------------------------------------------------------------

wire	TxDatOn;
wire	RxDatOn;
assign	TxDatOn = ((DATAState == `DATA_BLOCK_SEND)|(DATAState == `DATA_TRANS_WAIT)|(DATAState == `DATA_BUSYCHECK))? 1'b1 : 1'b0;

assign	RxDatOn = ((DATAState == `DATA_BLOCK_RECEIVE)|(DATAState == `DATA_RCV_WAIT))? 1'b1 : 1'b0;

//-------------------------------------------------------------------------------
// Receive CRC check 
//-------------------------------------------------------------------------------
`ifdef HSMMC
wire	D7CRCError;
wire	D6CRCError;
wire	D5CRCError;
wire	D4CRCError;
`endif
wire	D3CRCError;
wire	D2CRCError;
wire	D1CRCError;
wire	D0CRCError;
`ifdef HSMMC
assign 	D7CRCError  = (D7CRCSR == 16'd0) ? 1'b0 : 1'b1;
assign 	D6CRCError  = (D6CRCSR == 16'd0) ? 1'b0 : 1'b1;
assign 	D5CRCError  = (D5CRCSR == 16'd0) ? 1'b0 : 1'b1;
assign 	D4CRCError  = (D4CRCSR == 16'd0) ? 1'b0 : 1'b1;
`endif
assign 	D3CRCError  = (D3CRCSR == 16'd0) ? 1'b0 : 1'b1;
assign 	D2CRCError  = (D2CRCSR == 16'd0) ? 1'b0 : 1'b1;
assign 	D1CRCError  = (D1CRCSR == 16'd0) ? 1'b0 : 1'b1;
assign 	D0CRCError  = (D0CRCSR == 16'd0) ? 1'b0 : 1'b1;
//-------------------------------------------------------------------------------
// DATA read시 에러 체크  
//-------------------------------------------------------------------------------
`ifdef HSMMC
wire	MMCPlusError;
`endif
wire	SD4bitError;
wire	SD1bitError;
wire	DatCrcSet;

`ifdef HSMMC
assign 	MMCPlusError= (D7CRCError|D6CRCError|D5CRCError|D4CRCError|
						D3CRCError|D2CRCError|D1CRCError|D0CRCError);
`endif
assign 	SD4bitError	= (D3CRCError|D2CRCError|D1CRCError|D0CRCError);
assign 	SD1bitError	=  D0CRCError ;

assign NextCRCCheck = (CRCCheckSet)? 1'b1 : 1'b0;
always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CRCCheck <= 1'b0;
  else
    begin
    if (SDreset)
    CRCCheck <= 1'b0;
    else
    CRCCheck <= NextCRCCheck;
    end
end

`ifdef HSMMC
assign DatCrcSet	= (MMCPlusMode == 1'b1)? (MMCPlusError & CRCCheck):
			    	  (SD4bitMode == 1'b1)?  (SD4bitError & CRCCheck):
					  (SD1bitError & CRCCheck);
`else
assign DatCrcSet	= (SD4bitMode == 1'b1)?  (SD4bitError & CRCCheck):
					  (SD1bitError & CRCCheck);
`endif
// -----------------------------------------------------------------------------
// Transmit CRC Status Check
// -----------------------------------------------------------------------------
wire	CRCStatusErr;
wire	CrcStaSet;
assign 	CRCStatusErr = (D0CRCSR[2:0] == 3'b010) ? 1'b0 : 1'b1;

assign NextCRCStatusChk = (CRCStatusChkSet)? 1'b1 : 1'b0;
always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CRCStatusChk <= 1'b0;
  else
        begin
        if (SDreset)
	    CRCStatusChk <= 1'b0;
        else
	    CRCStatusChk <= NextCRCStatusChk;
        end
end

assign CrcStaSet	= (CRCStatusErr & CRCStatusChk);

// -----------------------------------------------------------------------------
//  블록 개수 count
// -----------------------------------------------------------------------------

wire	BlkNumCnt0;
assign  BlkNumCnt0  = (BlkNumCnt== 12'd0) ? 1'b1 : 1'b0 ;

// -----------------------------------------------------------------------------
// Block Count Comparators
// -----------------------------------------------------------------------------
wire	StateCnt0;
wire	StateCnt1;
assign  StateCnt0	= (StateCnt == 32'd0) ? 1'b1 : 1'b0;
assign  StateCnt1   = (StateCnt == 32'd1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Data Count Comparators
// -----------------------------------------------------------------------------

wire	BlkDatCnt0;
wire	BlkDatCnt1;
wire	BlkDatCnt7;
assign  BlkDatCnt0     = (BlkDatCnt == 16'd0) ? 1'b1 : 1'b0;
assign  BlkDatCnt1     = (BlkDatCnt == 16'd1) ? 1'b1 : 1'b0;
assign  BlkDatCnt7     = (BlkDatCnt == 16'd7) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Word Count Comparators for FIFO Read/Write
// -----------------------------------------------------------------------------
wire	WORDCnt0;
assign	WORDCnt0     = (WORDCnt == 2'b00) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Nibble Count Comparators for SD4bitMode
// -----------------------------------------------------------------------------
wire	NibbleCnt0;
assign	NibbleCnt0   = (NibbleCnt == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Bit Count Comparators for SD1bitMode
// -----------------------------------------------------------------------------
wire	BitCnt0;
assign	BitCnt0      = (BitCnt == 3'b000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// CRCStatus Count Comparators
// -----------------------------------------------------------------------------
wire	CRCStatusCnt0;
wire	CRCStatusCnt1;
wire	CRCStatusCnt2;
assign	CRCStatusCnt0    = (CRCStatusCnt == 3'b000) ? 1'b1 : 1'b0;
assign	CRCStatusCnt1    = (CRCStatusCnt == 3'b001) ? 1'b1 : 1'b0;
assign	CRCStatusCnt2    = (CRCStatusCnt == 3'b010) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
//
// wide bus support logic
//
// -----------------------------------------------------------------------------
// Combinational part of the Data Shift register.
// -----------------------------------------------------------------------------
//
// FIFO에서 SHIFT 레지스터로 
// SHIFT레지스터는 BUS WIDTH에 따라 SHIFT하는 BIT수가 달라짐
// FIFO DATA => REGISTER
// 8,4,1 bit Shifter
// 
// LdFIFOData : FIFO에서 읽어 Shift register로 값을 가져오는 신호
// BlkDatCntEn: shift동작 enable
//

always @(CKPulse or LdFIFOData or FIFOReadData or
         BlkDatCntEn or DATSR or DATIN or 
`ifdef HSMMC
MMCPlusMode or 
`endif
SD4bitMode or SD1bitMode or ByteOrder)
begin
	NextDATSR = DATSR;
    if (CKPulse == 1'b1) // For output sync
    begin
        if (LdFIFOData == 1'b1)//전송할 data를 FIFO에서 읽어 SHIFT RESISTER에 위치
		begin
		if (ByteOrder==1'b0)
	            NextDATSR[31:0] = {FIFOReadData[7:0], FIFOReadData[15:8],
                              FIFOReadData[23:16], FIFOReadData[31:24]};
		else // Futher Use
            	NextDATSR[31:0] = FIFOReadData;
		end
        else if (BlkDatCntEn == 1'b1) // Shift enable
         begin
`ifdef HSMMC
		    if (MMCPlusMode ==1'b1) // 8bit shifter for MMCPlus (Shift 1Byte)
		    NextDATSR[31:0] = {DATSR[23:0], DATIN[7:0]};
		    else 
`endif
			if (SD4bitMode == 1'b1) // 4bit shifter for SD Card (Shift 1Nibble)
	        NextDATSR[31:0] = {DATSR[27:0], DATIN[3:0]};
		    else
         	NextDATSR[31:0] = {DATSR[30:0], DATIN[0]};
 	    end
    end
end 

always @(posedge PCLK or negedge nRst)
begin 
    if (nRst == 1'b0)
        DATSR <= 32'h00000000;
    else
		begin
		if (SDreset)
		DATSR <= 32'h00000000;
		else
        DATSR <= NextDATSR;
		end
end

// -----------------------------------------------------------------------------
// Card ==> REGISTER ==> FIFO DATA
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    LdDataBuffer <= 1'b0;
  else
	begin
	if (SDreset)
	LdDataBuffer <= 1'b0;
	else
    LdDataBuffer <= LdDataBufferSet;
	end
end

always @(LdDataBuffer or WORDCnt or DATSR or FIFOWriteData or RxWriteEn or ByteOrder)
begin 
    NextFIFOWriteData = FIFOWriteData;
    NextRxWriteEn    = RxWriteEn;
    if (LdDataBuffer == 1'b1)
    begin
        NextRxWriteEn = ~(RxWriteEn);
        if (WORDCnt[1:0] == 2'b11)// data receive SHIFT REGISTER TO FIFO
		begin
			if (ByteOrder==1'b0)
        	NextFIFOWriteData = {DATSR[7:0], DATSR[15:8],
            	                DATSR[23:16], DATSR[31:24]};
			else// for SD Status and SCR register  
			NextFIFOWriteData = DATSR;
		end
    end
end

always @(posedge PCLK or negedge nRst)
begin 
    if (nRst == 1'b0)
        begin
        FIFOWriteData <= 32'h00000000;
        RxWriteEn    <= 1'b0;
        end
    else
		begin
			if (SDreset)
			begin
			FIFOWriteData <= 32'h00000000;
        	RxWriteEn    <= 1'b0;	
			end
			else
	        begin
	        FIFOWriteData <= NextFIFOWriteData;
    	    RxWriteEn <= NextRxWriteEn;
        	end
		end
end 

//------------------------------------------------------------------------------
// DATA OUTPUT ( 사용하지 않는 DAT line은 1을 내보냄 )
// -----------------------------------------------------------------------------
always @(NextDATSR or LdEndBit or LdStartBit or
         NextD0CRCSR or NextD1CRCSR or NextD2CRCSR or 
	 NextD3CRCSR or LdCRC or TxCRCSend or CKPulse or DATOUT or 
`ifdef HSMMC
MMCPlusMode or NextD4CRCSR or NextD5CRCSR or NextD6CRCSR or NextD7CRCSR or
`endif
SD1bitMode or SD4bitMode)
begin 
    NextDATOUT[AW-1:0]  = DATOUT [AW-1:0];
    if (CKPulse)
    begin
        if (LdStartBit) // start bit 내보내기
        begin
`ifdef HSMMC
                if (SD1bitMode)    
                NextDATOUT[7:0] = 8'b11111110;// start bit
                else if (SD4bitMode) 
                NextDATOUT[7:0] = 8'b11110000;// start bit
                else if (MMCPlusMode)    
                NextDATOUT[7:0] = 8'b00000000;// start bit
`else
                if (SD1bitMode)    
                NextDATOUT[3:0] = 4'b1110;// start bit
                else if (SD4bitMode) 
                NextDATOUT[3:0] = 4'b0000;// start bit
`endif
        end
        else if (LdEndBit)// end bit 내보내기
`ifdef HSMMC
            NextDATOUT[7:0] = 8'b11111111;// transimit
`else
            NextDATOUT[3:0] = 4'b1111;// transimit
`endif
        else if (LdCRC || TxCRCSend) // CRC 내보내기
	        begin
`ifdef HSMMC
    	    if (MMCPlusMode) // 8bit data line for MMCPlus
				begin
            	NextDATOUT[7] = NextD7CRCSR[15];
            	NextDATOUT[6] = NextD6CRCSR[15];
            	NextDATOUT[5] = NextD5CRCSR[15];
            	NextDATOUT[4] = NextD4CRCSR[15];
       	    	NextDATOUT[3] = NextD3CRCSR[15];
    	    	NextDATOUT[2] = NextD2CRCSR[15];
            	NextDATOUT[1] = NextD1CRCSR[15];
            	NextDATOUT[0] = NextD0CRCSR[15];
				end
			else 
`endif
			if (SD4bitMode)
				begin
       	    	NextDATOUT[3] = NextD3CRCSR[15];
       	    	NextDATOUT[2] = NextD2CRCSR[15];
       	    	NextDATOUT[1] = NextD1CRCSR[15];
       	    	NextDATOUT[0] = NextD0CRCSR[15];
				NextDATOUT[7:4] = 4'b1111;
				end
			else
				begin
				NextDATOUT[0] = NextD0CRCSR[15];
				NextDATOUT[7:1] = 7'b1111111;
				end
	        end
        else
	        begin
`ifdef HSMMC
    	    if (MMCPlusMode) // 8bit data line for MMCPlus
                NextDATOUT[7:0] = NextDATSR[31:24];
	        else 
`endif
			if (SD4bitMode) // 4bit data line for SD Card
	            begin
		        NextDATOUT[3:0]   = NextDATSR[31:28];
`ifdef HSMMC
	 	        NextDATOUT[7:4]   = 4'b1111;
`endif
	            end
	        else
	            begin
`ifdef HSMMC
        	    NextDATOUT[0]   = NextDATSR[31];
	            NextDATOUT[7:1] = 7'b1111111;
`else
        	    NextDATOUT[0]   = NextDATSR[31];
	            NextDATOUT[3:1] = 3'b111;
`endif
 	            end
	        end
    end
end 

always @(posedge PCLK or negedge nRst)
begin 
    if (nRst == 1'b0)
    DATOUT[AW-1:0] <= {AW{1'b1}};
    else
		begin
		if (SDreset)
	    DATOUT[AW-1:0] <= {AW{1'b1}};
		else
		DATOUT[AW-1:0] <= NextDATOUT[AW-1:0];
		end
end 
reg	[AW-1:0]	Inv_DATOUT;
reg			Inv_nDATEN;
always @(posedge PCLK or negedge nRst)
begin
	if (!nRst)
	begin
	Inv_DATOUT[AW-1:0] <= {AW{1'b1}};
	Inv_nDATEN	<= 1'b1;
	end
	else if (SDreset)
	begin
	Inv_DATOUT[AW-1:0] <= {AW{1'b1}};
	Inv_nDATEN <= 1'b1;
	end
	else if (neg_CKPulse)
	begin
	Inv_DATOUT[AW-1:0] <= DATOUT[AW-1:0];
	Inv_nDATEN <= nDATEN;
	end
end 

//------------------------------------------------------------------------------
// Block counter ( remain block byte )
//------------------------------------------------------------------------------
wire	OneByte;
`ifdef HSMMC
assign OneByte = ((BitCnt0 && SD1bitMode)|(NibbleCnt0 && SD4bitMode)|MMCPlusMode);
`else
assign OneByte = ((BitCnt0 && SD1bitMode)|(NibbleCnt0 && SD4bitMode));
`endif
always @(posedge PCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BlkDatCnt <= 16'd0;
    else
		begin
		if (SDreset)
		BlkDatCnt <= 16'd0;
		else if (LdBlkSize)
		BlkDatCnt <= SDIBSize;
    	else if (CKPulse && BlkDatCntEn && OneByte && ~BlkDatCnt0)
        BlkDatCnt <= BlkDatCnt-1;
		end
end 

//------------------------------------------------------------------------------
// Block Number counter ( remain block Number )
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BlkNumCnt <= 15'd0;
    else
		begin
		if (SDreset)
		BlkNumCnt <= 15'd0;
		else if (LdBlkNum)
		BlkNumCnt <= BlkNum;
		else if (BlkNumCntSet)
		BlkNumCnt <= BlkNumCnt - 1;
		end
end 

// -----------------------------------------------------------------------------
// 32BIT FIFO이므로 읽거나 쓰기위해서는 32BIT 단위를 사용해야한다.
// 1 WORD가 되었는지 카운트하는 부분 (byte를   카운트한다 ) 
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        WORDCnt <= 2'b00;
    else
		begin
		if (SDreset)
        WORDCnt <= 2'b00;
		else if (DATAState == `DATA_IDLE)
		WORDCnt <=2'b00;
		else if (LdWORDCnt3)
		WORDCnt <= 2'b11;
		else if (CKPulse && BlkDatCntEn && OneByte)
        WORDCnt <= WORDCnt - 1;
		end
end 

// -----------------------------------------------------------------------------
// 4bit 모드에서는 bit counter를 사용하지 않고 nibble counter를 사용해서 byte와
// Word를 계산한다.
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        NibbleCnt <= 1'b0;
    else
		begin
		if (SDreset)
        NibbleCnt <= 1'b0;		
		else if (LdNibbleCnt)
		NibbleCnt <= 1'b1;
		else if (~BlkDatCntEn)
		NibbleCnt <= 1'b0;
    	else if (SD4bitMode && BlkDatCntEn && CKPulse) 
		NibbleCnt <= (~NibbleCnt);
		end
end 

// -----------------------------------------------------------------------------
// (For 1bit DAT Line)
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BitCnt <= 3'b000;
    else
		begin
		if (SDreset)
		BitCnt <= 3'b000;
		else if (LdBitCnt)
		BitCnt <= 3'b111;
		else if (~BlkDatCntEn)
		BitCnt <=3'b000;
    	else if (CKPulse && ~BitCnt0 && SD1bitMode) // 1bit mode에서만 사용
        BitCnt <= (BitCnt) - 1;
		end
end
//------------------------------------------------------------------------------
// Transfering block time counter
// 스테이트 머신에서 transition을 위한 counter
//------------------------------------------------------------------------------ 
always @(posedge PCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        StateCnt <= 32'h00000000;
    else
		begin
		if (SDreset)
		StateCnt <= 32'h00000000;
		else if (LdSDIBSize)
        StateCnt <= {16'd0, SDIBSize};
		/*else if (LdStateCnt0)
		StateCnt <= 32'd0;*/
		else if (LdStateCnt1)
		StateCnt <= 32'd1;
		else if (LdStateCnt2)
		StateCnt <= 32'd2;
	    else if (LdStateCnt7)
        StateCnt <= 32'd7;
    	else if (LdStateCnt8)
        StateCnt <= 32'd8;
	    else if (LdStateCnt15)
        StateCnt <= 32'd15;
    	else if (LdStateCnt16)
        StateCnt <= 32'd16;
	    else if (LdSDIDTimer)
        StateCnt <= SDIDTimer;// timeout register value load
    	else if (~StateCnt0 && CKPulse && OneByte)
		// OneByte 신호는 data 전송 시 바뀌고 data전송이 아닐때 (CRC등) 1로 고정된다 
		// 따라서 CRC에서는 CKPulse마다 카운팅 된다
        StateCnt <= (StateCnt) - 1;
		end
end 

// -----------------------------------------------------------------------------
// CRC module input select
// -----------------------------------------------------------------------------
wire	[AW-1:0]	CRCDat;
assign CRCDat[AW-1:0] = (TxCRCCal)? DATOUT[AW-1:0] : DATIN[AW-1:0];

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
always @(
`ifdef HSMMC
D7CRCSR or D6CRCSR or D5CRCSR or D4CRCSR or 
`endif
		D3CRCSR or D2CRCSR or 
		D1CRCSR or TxCRCCal or RxCRCCal or CRCDat or
         CKPulse or TxCRCSend )
begin 
`ifdef HSMMC
  NextD7CRCSR = D7CRCSR;
  NextD6CRCSR = D6CRCSR;
  NextD5CRCSR = D5CRCSR;
  NextD4CRCSR = D4CRCSR;
`endif
  NextD3CRCSR = D3CRCSR;
  NextD2CRCSR = D2CRCSR;
  NextD1CRCSR = D1CRCSR;
  if (CKPulse == 1'b1)
    begin
      if (TxCRCSend)// 블록 모드에서 CRC부분 전송시
		begin
`ifdef HSMMC
        NextD7CRCSR = {D7CRCSR[14:0], 1'b0};
        NextD6CRCSR = {D6CRCSR[14:0], 1'b0};
        NextD5CRCSR = {D5CRCSR[14:0], 1'b0};
        NextD4CRCSR = {D4CRCSR[14:0], 1'b0};
`endif
        NextD3CRCSR = {D3CRCSR[14:0], 1'b0};
        NextD2CRCSR = {D2CRCSR[14:0], 1'b0};
        NextD1CRCSR = {D1CRCSR[14:0], 1'b0};
		end
      else if (TxCRCCal||RxCRCCal)
        begin
`ifdef HSMMC
          NextD7CRCSR[15:13] = D7CRCSR[14:12];
          NextD7CRCSR[12]    = D7CRCSR[15] ^ D7CRCSR[11] ^ CRCDat[7];
          NextD7CRCSR[11:6]  = D7CRCSR[10:5];
          NextD7CRCSR[5]     = D7CRCSR[15] ^ D7CRCSR[4] ^ CRCDat[7];
          NextD7CRCSR[4:1]   = D7CRCSR[3:0];
          NextD7CRCSR[0]     = D7CRCSR[15] ^ CRCDat[7];

          NextD6CRCSR[15:13] = D6CRCSR[14:12];
          NextD6CRCSR[12]    = D6CRCSR[15] ^ D6CRCSR[11] ^ CRCDat[6];
          NextD6CRCSR[11:6]  = D6CRCSR[10:5];
          NextD6CRCSR[5]     = D6CRCSR[15] ^ D6CRCSR[4] ^ CRCDat[6];
          NextD6CRCSR[4:1]   = D6CRCSR[3:0];
          NextD6CRCSR[0]     = D6CRCSR[15] ^ CRCDat[6];

          NextD5CRCSR[15:13] = D5CRCSR[14:12];
          NextD5CRCSR[12]    = D5CRCSR[15] ^ D5CRCSR[11] ^ CRCDat[5];
          NextD5CRCSR[11:6]  = D5CRCSR[10:5];
          NextD5CRCSR[5]     = D5CRCSR[15] ^ D5CRCSR[4] ^ CRCDat[5];
          NextD5CRCSR[4:1]   = D5CRCSR[3:0];
          NextD5CRCSR[0]     = D5CRCSR[15] ^ CRCDat[5];


          NextD4CRCSR[15:13] = D4CRCSR[14:12];
          NextD4CRCSR[12]    = D4CRCSR[15] ^ D4CRCSR[11] ^ CRCDat[4];
          NextD4CRCSR[11:6]  = D4CRCSR[10:5];
          NextD4CRCSR[5]     = D4CRCSR[15] ^ D4CRCSR[4] ^ CRCDat[4];
          NextD4CRCSR[4:1]   = D4CRCSR[3:0];
          NextD4CRCSR[0]     = D4CRCSR[15] ^ CRCDat[4];
`endif
          NextD3CRCSR[15:13] = D3CRCSR[14:12];
          NextD3CRCSR[12]    = D3CRCSR[15] ^ D3CRCSR[11] ^ CRCDat[3];
          NextD3CRCSR[11:6]  = D3CRCSR[10:5];
          NextD3CRCSR[5]     = D3CRCSR[15] ^ D3CRCSR[4] ^ CRCDat[3];
          NextD3CRCSR[4:1]   = D3CRCSR[3:0];
          NextD3CRCSR[0]     = D3CRCSR[15] ^ CRCDat[3];

          NextD2CRCSR[15:13] = D2CRCSR[14:12];
          NextD2CRCSR[12]    = D2CRCSR[15] ^ D2CRCSR[11] ^ CRCDat[2];
          NextD2CRCSR[11:6]  = D2CRCSR[10:5];
          NextD2CRCSR[5]     = D2CRCSR[15] ^ D2CRCSR[4] ^ CRCDat[2];
          NextD2CRCSR[4:1]   = D2CRCSR[3:0];
          NextD2CRCSR[0]     = D2CRCSR[15] ^ CRCDat[2];

          NextD1CRCSR[15:13] = D1CRCSR[14:12];
          NextD1CRCSR[12]    = D1CRCSR[15] ^ D1CRCSR[11] ^ CRCDat[1];
          NextD1CRCSR[11:6]  = D1CRCSR[10:5];
          NextD1CRCSR[5]     = D1CRCSR[15] ^ D1CRCSR[4] ^ CRCDat[1];
          NextD1CRCSR[4:1]   = D1CRCSR[3:0];
          NextD1CRCSR[0]     = D1CRCSR[15] ^ CRCDat[1];
        end
      else //Default Value is 0.
		begin
`ifdef HSMMC
        NextD7CRCSR = 16'h0000;
        NextD6CRCSR = 16'h0000;
        NextD5CRCSR = 16'h0000;
        NextD4CRCSR = 16'h0000;
`endif
        NextD3CRCSR = 16'h0000;
        NextD2CRCSR = 16'h0000;
        NextD1CRCSR = 16'h0000;
		end
    end
end

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
always @(D0CRCSR or TxCRCCal or RxCRCCal or CRCDat or
         CKPulse or TxCRCSend or CRCStatusStr)
begin 
  NextD0CRCSR = D0CRCSR;
  if (CKPulse == 1'b1)
    begin
      if (CRCStatusStr)
        NextD0CRCSR = {D0CRCSR[14:0], CRCDat[0]};
      else if (TxCRCSend)
        NextD0CRCSR = {D0CRCSR[14:0], 1'b0};
      else if (TxCRCCal||RxCRCCal)
        begin
          NextD0CRCSR[15:13] = D0CRCSR[14:12];
          NextD0CRCSR[12]    = D0CRCSR[15] ^ D0CRCSR[11] ^ CRCDat[0];
          NextD0CRCSR[11:6]  = D0CRCSR[10:5];
          NextD0CRCSR[5]     = D0CRCSR[15] ^ D0CRCSR[4] ^ CRCDat[0];
          NextD0CRCSR[4:1]   = D0CRCSR[3:0];
          NextD0CRCSR[0]     = D0CRCSR[15] ^ CRCDat[0];
        end
      else
        NextD0CRCSR = 16'h0000;
    end
end 

always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
   begin	  
    D0CRCSR <= 16'h0000;
    D1CRCSR <= 16'h0000;
    D2CRCSR <= 16'h0000;
    D3CRCSR <= 16'h0000;
`ifdef HSMMC
    D4CRCSR <= 16'h0000;
    D5CRCSR <= 16'h0000;
    D6CRCSR <= 16'h0000;
    D7CRCSR <= 16'h0000;
`endif
   end
  else
   begin
		if (SDreset)
		begin
	    D0CRCSR <= 16'h0000;
    	D1CRCSR <= 16'h0000;
	    D2CRCSR <= 16'h0000;
    	D3CRCSR <= 16'h0000;
`ifdef HSMMC
		D4CRCSR <= 16'h0000;
		D5CRCSR <= 16'h0000;
		D6CRCSR <= 16'h0000;
		D7CRCSR <= 16'h0000;
`endif
		end
		else
		begin
	    D0CRCSR <= NextD0CRCSR;
    	D1CRCSR <= NextD1CRCSR;
	    D2CRCSR <= NextD2CRCSR;
    	D3CRCSR <= NextD3CRCSR;
`ifdef HSMMC
	    D4CRCSR <= NextD4CRCSR;
    	D5CRCSR <= NextD5CRCSR;
	    D6CRCSR <= NextD6CRCSR;
    	D7CRCSR <= NextD7CRCSR;
`endif
		end
   end
end 

// -----------------------------------------------------------------------------
//CRCStatus counter (Return CRC OK counter)
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
	begin
    CRCStatusCnt <= 3'b000;
	end
  else
	begin
	if (SDreset)
    CRCStatusCnt <= 3'b000;
	else if (DATAState == `DATA_IDLE)
    CRCStatusCnt <= 3'b000;
  	else if (LdCRCStatusCnt4)
    CRCStatusCnt <= 3'b100;
  	else if (LdCRCStatusCnt1)
    CRCStatusCnt <= 3'b001;
  	else if (CKPulse && (CRCStatusCnt0 == 1'b0))
    CRCStatusCnt <= (CRCStatusCnt) - 1;
	end
end


// -----------------------------------------------------------------------------
// Stop Command 전송시 
// -----------------------------------------------------------------------------
reg AbortCmdSent;
reg	NextAbortCmdSent;
reg AbortCmdSentClr;
reg AbortSet;
reg	AbortClr;
reg	Abort;
reg	NextAbort;
always @(CmdSentSet or AbortCmd or AbortCmdSentClr or AbortCmdSent)
begin
	if ((AbortCmd) && (CmdSentSet))
	NextAbortCmdSent = 1'b1;
	else if (AbortCmdSentClr)
	NextAbortCmdSent = 1'b0;
	else
	NextAbortCmdSent = AbortCmdSent;
end

always @(AbortSet or AbortClr or Abort)
begin
	if (AbortSet)
	NextAbort = 1'b1;
	else if (AbortClr)
	NextAbort = 1'b0;
	else
	NextAbort = Abort;
end

always @(posedge PCLK or negedge nRst)
begin
	if (nRst == 1'b0)
		begin
		AbortCmdSent = 1'b0;
		Abort = 1'b0;
		end
	else
		begin
		if (SDreset)
			begin
			AbortCmdSent = 1'b0;
			Abort = 1'b0;
			end
		else
			begin
			AbortCmdSent = NextAbortCmdSent;
			Abort = NextAbort;
			end
		end
end

// -----------------------------------------------------------------------------
// STATE machine
// -----------------------------------------------------------------------------
wire	DatReceiveStart;
wire	DatTransmitStart;
assign	DatReceiveStart=  (DTST && ((!RACMD)|(RACMD && CmdSentSet)));
assign	DatTransmitStart = (DTST && ((!TARSP)|(TARSP && RspFinSet)));
always @(DATAState or DTST or CKPulse or DatMode or TARSP or AbortCmdSent or
		DatReceiveStart or DatTransmitStart or
	CmdSentSet or StartBit or BlkMode or StateCnt0 or BlkDatCnt0 or BlkNumCnt0 or 
	TxCRCCal or BitCnt0 or SD1bitMode or NibbleCnt0 or SD4bitMode or MMCPlusMode or WORDCnt0 or BlkDatCntEn or 
	CRCStatusCnt0 or TxActive or CRCStatusCnt1 or TxCRCSend or TxRdPtrInc or CRCStatusCnt2 or RxActive or
	/*TFREmpty or*/ Abort or nDATEN or StopBit or DATIN or BusyStatus or RxCRCCal or CrcStaSet or
	DatCrcSet or CRCStatusGet or StateCnt1 or CRCStatusStr or BlkDatCnt1 or BlkDatCnt7 or OneByte)
 
begin

  LdBlkNum 	  = 1'b0;
  LdBlkSize       = 1'b0;
  //LdStateCnt0	  = 1'b0;
  LdStateCnt1	  = 1'b0;
  LdStateCnt2	  = 1'b0;
  LdStateCnt7     = 1'b0;
  LdStateCnt8     = 1'b0;
  LdStateCnt15    = 1'b0;
  LdStateCnt16    = 1'b0;
  LdSDIBSize      = 1'b0;
  LdSDIDTimer     = 1'b0;
  LdBitCnt        = 1'b0;
  LdNibbleCnt     = 1'b0;
  LdWORDCnt3      = 1'b0;
  LdCRCStatusCnt1 = 1'b0;
  LdCRC           = 1'b0;
  LdStartBit      = 1'b0;
  LdEndBit    	  = 1'b0;
  LdFIFOData      = 1'b0;
  DatToutSet      = 1'b0;
  DatFinSet       = 1'b0;
  DatBlkEndSet	  = 1'b0;
  LdDataBufferSet = 1'b0;
  CRCStatusChkSet = 1'b0;
  CRCCheckSet     = 1'b0;
  DTSTClr	  = 1'b0;
  AbortCmdSentClr = 1'b0;
  BlkNumCntSet 	  = 1'b0;

  NextRxActive    = RxActive;
  NextTxActive    = TxActive;

  NextDATAState   = DATAState;
  NextRxCRCCal  = RxCRCCal;
  NextTxCRCCal  = TxCRCCal;
  NextStopBit     = StopBit;
  NextStartBit    = StartBit;

  NextCRCStatusGet= CRCStatusGet;
  NextTxRdPtrInc  = TxRdPtrInc;
  NextBlkDatCntEn = BlkDatCntEn;
  NextTxCRCSend   = TxCRCSend;
  NextBusyStatus  = BusyStatus;
  NextCRCStatusStr= CRCStatusStr;
  NextnDATEN	  = nDATEN;
  LdDataBufferSet = 1'b0;
  LdSDIDTimer     = 1'b0;
  LdCRCStatusCnt4 = 1'b0;

  NextDATAState   = DATAState;

  AbortCmdSentClr = 1'b0;
  AbortClr = 1'b0;
  AbortSet = 1'b0;
  
	case (DATAState)

	`DATA_IDLE :
		begin
    	case (DatMode)
		`NoOperation:
			begin
			NextDATAState = `DATA_IDLE;
			if (DTST)
				DTSTClr = 1'b1; // DTST register Clear
			end
		`OnlyBusyChk:
			begin
			NextDATAState = `DATA_IDLE;
			if (DTST) // Reserved State 
			DTSTClr = 1'b1; // data transfer clear
			end
		`DatReceive:	
			if (DatReceiveStart) 
			begin
			NextDATAState = `DATA_RCV_WAIT;
	    	LdBlkNum = 1'b1;		// BlkNum 값을 가져온다.
			LdBlkSize = 1'b1;		// Block size값을 가져온다.
			DTSTClr = 1'b1; 		// DTST register Clear
     		NextRxActive  = 1'b1;	// Rx mode fifo enable
			NextTxActive  = 1'b0;	// Tx mode fifo disable
        	NextnDATEN    = 1'b1;	// Input mode
			LdSDIDTimer	  = 1'b1;	// Data Time-out timer set
       		end
			else
			begin
			NextDATAState = `DATA_IDLE;
     		NextRxActive  = 1'b1;	// Tx fifo활성화
			NextTxActive  = 1'b0;
			end
		`DatTransmit:	
			if (DatTransmitStart)
			begin
			NextDATAState = `DATA_TRANS_WAIT;
	   		LdBlkNum = 1'b1;		// BlkNum 값을 가져온다.
			LdBlkSize = 1'b1;		// Block size값을 가져온다.
			DTSTClr = 1'b1; 		// DTST register Clear
			NextTxActive= 1'b1;  	// Tx mode FIFO enable 
			NextRxActive  = 1'b0;	// Rx mode FIFO disable
			LdStateCnt2 = 1'b1; 	// Nwr (write time) insert
			end
			else
			begin
			NextDATAState = `DATA_IDLE;
     		NextTxActive  = 1'b1;	// Tx fifo활성화
			NextRxActive  = 1'b0;
			end

		default	:
			NextDATAState = `DATA_IDLE;
		endcase
		end

   	`DATA_TRANS_WAIT : // transmit 대기 
		if (BlkDatCnt0)// 모든 block이 전송되었을 경우
	    	begin
    		NextDATAState = `DATA_IDLE;
        	NextnDATEN    = 1'b1;
	    	end
		else if (CKPulse &&((StateCnt0&&TARSP)|(!TARSP))) // Nwr time이 meet 되면Start bit 전송
			begin
        	NextnDATEN    = 1'b0;	// DAT line Output mode
        	LdStartBit    = 1'b1; 	// Output Register에 0을 load 하여 Start Bit를 만든다.
	        NextStartBit  = 1'b1; 	// Start bit Counter
			NextDATAState = `DATA_BLOCK_SEND;
	    	end
     
	`DATA_BLOCK_SEND : 
		// Transmit
		// 1 word단위로 FIFO pointer update
		// block 모드는 end bit 후에 busy state로
	
		// Start + DATA + CRC16 + End bit
		if (CrcStaSet||DatCrcSet)
		begin
        	NextDATAState   = `DATA_IDLE;
        	NextTxCRCCal  = 1'b0;
       		NextTxCRCSend = 1'b0;
	        NextBlkDatCntEn = 1'b0;
        	NextStartBit    = 1'b0;
	        NextStopBit     = 1'b0;
	        NextnDATEN      = 1'b1;
	        LdStateCnt8      = 1'b1;
		end
    
		// Block mode start bit
		else if (CKPulse && StartBit) 	//StartBit가 보내진 상태라면
		begin						  	// Data를 내보낸다.
			NextDATAState  = `DATA_BLOCK_SEND;
	   	   	NextStartBit   = 1'b0; 	  	// Start Bit Counter Clear
   	    	NextBlkDatCntEn= 1'b1;    	// Shift register shifting Enable
    	   	NextTxCRCCal = 1'b1; 		// CRC block enable
    		LdSDIBSize     = 1'b1; 		// 설정된 block size 만큼 전송하기 위해 전체 전송해야될 byte값 load
										// BlkSize를  block카운터로 넣는다.
	       	LdBitCnt        = 1'b1;		// bit는 7부터 down 카운팅
    	   	LdNibbleCnt     = 1'b1;		// 4bit mode에서 nibble 카운팅
        	NextTxRdPtrInc 	= ~(TxRdPtrInc); // FIFO read
       		LdWORDCnt3      	= 1'b1;		// Word Counter load 
	  		LdFIFOData   	= 1'b1;		// Shift register에 보낼 fifo load 
    		end

		// block 전송중 stop command가 들어올 경우...
		//  ---------------------------------------
   	else if (CKPulse  & AbortCmdSent &
		TxCRCCal & ~StateCnt0 /*&& (((BitCnt0== 1'b1) && (SD1bitMode == 1'b1))||
	    ((NibbleCnt0 == 1'b1) && (SD4bitMode == 1'b1))||(MMCPlusMode == 1'b1))*/) // 1block 전송중에
		begin
	    	NextDATAState   = `DATA_BLOCK_SEND;
	        NextTxCRCCal  = 1'b0; // CRC disable
			NextBlkDatCntEn = 1'b0;  // data shift 중지
			NextTxCRCSend = 1'b0; // CRC shift 중지
			LdStateCnt1     = 1'b1; 
			AbortCmdSentClr = 1'b1;
		end

		// Stop Command 후 1Cycle 대기
		else if (CKPulse && StateCnt0 && Abort)
		begin
			NextDATAState = `DATA_IDLE;
			AbortClr = 1'b1;
	        NextnDATEN    	= 1'b1;	// READ mode
			LdEndBit    	= 1'b1; // End bit를 data output
		end

		// Data 전송 1block 단위가 끝났을 경우 CRC를 전송해야됨
		// shift register를 enable 시켰으므로 전송됨	
		// block mode에서 데이터부분 전송 완료  16-bit CRC를 전송.  카운터 값을 15로...
		else if (CKPulse && StateCnt0 && TxCRCCal && OneByte) // 1block 전송완료시
		begin
	        NextDATAState   = `DATA_BLOCK_SEND;
        	NextTxCRCCal  = 1'b0; // CRC disable
	        NextBlkDatCntEn = 1'b0; // data shift register shift중지
	        NextTxCRCSend = 1'b1; // CRC 부분을 그냥 shifting
        	LdCRC           = 1'b1; // CRC 부분을 output
			LdStateCnt15    = 1'b1; // 16bit crc bit전송을 위한 카운터
	        end

		// 블록모드의 경우 Transmission ends (data + CRC + stop bit) in Block mode
		else if (CKPulse && StopBit)
		begin
	        NextDATAState 	= `DATA_BUSYCHECK; // NWR time을 맞추기 위해 
        	NextStopBit   	= 1'b0; 
	        NextnDATEN    	= 1'b1;	// READ mode
	        NextCRCStatusGet= 1'b1; // CRC Status 읽기 모드로 전환
	        LdSDIDTimer    	= 1'b1; // CRC Status가 들어올 때 timeout counter설정 

		end
		
		// End bit 전송
		// Block mode (data+CRC)  transmission ends
		// CRC까지 전송이 완료되었으므로 end bit 전송을 실시한다
		else if (CKPulse && StateCnt0 && ~TxCRCCal)// && OneByte)
		begin
			NextDATAState   = `DATA_BLOCK_SEND;
			NextStopBit     = 1'b1; // stop bit 전송을 위해서~
			NextBlkDatCntEn	= 1'b0;	// shift 중지
			NextTxCRCSend = 1'b0; // CRC shift 중지
			LdEndBit    	= 1'b1; // End bit를 data output
		end

		// Word 단위에서 FIFO에서 값을 읽어옴
		else if (CKPulse && WORDCnt0 && BlkDatCntEn && OneByte)
		begin
	        NextDATAState  = `DATA_BLOCK_SEND;
       		LdFIFOData   = 1'b1;
			NextTxRdPtrInc = ~(TxRdPtrInc);
	        LdWORDCnt3      = 1'b1;
        	if (!MMCPlusMode)
	        LdBitCnt       = 1'b1;	
 		end

		// Byte boundary
		else if (CKPulse && BlkDatCntEn  &&
				((BitCnt0 && SD1bitMode)|(~NibbleCnt0 && SD4bitMode)))
		begin
			NextDATAState = `DATA_BLOCK_SEND;
			LdBitCnt      = 1'b1;
		end
    
	`DATA_BUSYCHECK :
	// NwR TIME 
	// crc RESPONSE
	// BUSY CHECK
	//
	//    
	//  BLOCK MODE 
   	//   Start+ CRC status + End + Nwr    
   	//   Start+ CRC status + End + Start+ Busy + End + Nwr
   	//
	// CRC에러시 전송 중지
	if (CrcStaSet ||DatCrcSet)
        begin
		NextDATAState  		= `DATA_IDLE;
		NextCRCStatusGet   	= 1'b0;
		NextCRCStatusStr 	= 1'b0;
		NextBusyStatus    		= 1'b0;
		LdStateCnt8     	= 1'b1;
		NextnDATEN    		= 1'b1;
        end
	// CRC Status 
	// StartBit + CRC Status(3bit) + EndBit
	// CRC Status : 010 <= OK
	//				101 <= error
	// CRC status의 start bit
	else if (CKPulse && CRCStatusGet &StateCnt0)
		if (DATIN[0] == 1'b0) 
       		begin
	       	NextDATAState 		= `DATA_BUSYCHECK;
        	NextCRCStatusGet    = 1'b0;
	       	NextCRCStatusStr 	= 1'b1; // CRC STATUS bit을 저장
        	LdCRCStatusCnt4    	= 1'b1;
	       	end
		// SDIDTimer에 설정된 타이머 time out
		// Time out interrupt 발생
		else 
		begin
		    NextDATAState   	= `DATA_IDLE;
		NextCRCStatusGet	= 1'b0;
   	 	DatToutSet    		= 1'b1;
		end

	else if (CKPulse && CRCStatusGet & (DATIN[0] == 1'b0))
	begin
       	NextDATAState 		= `DATA_BUSYCHECK;
       	NextCRCStatusGet    = 1'b0;
       	NextCRCStatusStr 	= 1'b1; // CRC STATUS bit을 저장
       	LdCRCStatusCnt4    	= 1'b1;
	end

	// Busy 상태 판별 및 대기
	// StartBit => CRCStatus => EndBit => 'Low'
	// CRC check EndBit 후에 바로 start bit + zero가 오면 busy이다
	else if (CKPulse && CRCStatusCnt0 && ~CRCStatusGet && ~BusyStatus)
	begin
			// busy가 아닌경우 
	        if (DATIN[0] == 1'b1)  
        	begin
   		   	LdStateCnt2	  = 1'b1;// for Nwr time
			LdCRCStatusCnt1   = 1'b1;
				if (BlkNumCnt0==1'b0)
				begin
				NextDATAState 	= `DATA_CONTINUE_SEND;
				BlkNumCntSet 	= 1'b1;
				LdBlkSize    	= 1'b1;
				end
				else
				begin
				NextDATAState 	= `DATA_IDLE;
				DatFinSet	= 1'b1;  // ### BusyFin2 수정
				BlkNumCntSet 	= 1'b0;
				end
        	end
    		// DATIN[0]이 low 인 경우에서 timeout발생시 
        	else if (StateCnt0)
	        begin
        	NextDATAState  		= `DATA_IDLE;
	        NextCRCStatusStr 	= 1'b0;
        	DatToutSet       	= 1'b1;
	        LdStateCnt7    		= 1'b1;
        	end
         	// BUSY mode
	        else // DATIN[0]이 low 인 경우
        	begin
	        NextDATAState = `DATA_BUSYCHECK;
        	NextBusyStatus   = 1'b1;
	        end
	 end

    // busy mode가 끝났을 알림
    // busy 상태에서 1이 들어오면...
    //
	else if (CKPulse && BusyStatus && DATIN[0])
   	begin
        NextBusyStatus   = 1'b0;
        LdCRCStatusCnt1   = 1'b1;
		LdStateCnt2	  = 1'b1; 
    	if (BlkNumCnt0==1'b0)
        	begin
	        BlkNumCntSet = 1'b1;
        	NextDATAState = `DATA_CONTINUE_SEND;
     		LdBlkSize	  = 1'b1;
        	end
        else
	        begin
            BlkNumCntSet = 1'b0;
				DatFinSet	= 1'b1;  // ### BusyFin2 수정
            NextDATAState = `DATA_IDLE;
    	    end
	end

     // CRCStatus Check
     // CRC check bit 가 010인지 101인지 체크
     // 
	else if (CKPulse && CRCStatusCnt2)
    begin
		CRCStatusChkSet    = 1'b1;
		NextCRCStatusStr = 1'b0;
    	// Time out
        if (StateCnt0)
            begin
            NextDATAState  = `DATA_IDLE;
            NextCRCStatusStr = 1'b0;
            DatToutSet       = 1'b1;
            LdStateCnt7     = 1'b1;
            end
        else
            NextDATAState = `DATA_BUSYCHECK;
        end
//--------------------------------------------------------------------------------------------
// Reduce Interrupt (BusyFinSet2 delete)
/*
     // DatBlkEnd and DatFin 모든 block과 byte전송이 완료됨 전체 블록 전송완료
   	else if (CKPulse && CRCStatusCnt1 && BlkDatCnt0 && BlkNumCnt0)
   	begin
	DatBlkEndSet = 1'b1;
	DatFinSet  = 1'b1;// 모든 block 전송완료시
    	// Time out
		if (StateCnt0)
           	begin
           	NextDATAState  = `DATA_IDLE;
          	NextCRCStatusStr = 1'b0;
           	DatToutSet       = 1'b1;
           	LdStateCnt7     = 1'b1;
           	end
        else
           	NextDATAState = `DATA_BUSYCHECK;// 대부분 곧장 busy가 오므로 busy check후에 종료하게 하여야한다.
        end
*/
    // 한 블록의 끝
	else if (CKPulse && CRCStatusCnt1)
	begin
	DatBlkEndSet = 1'b1;
	
          // Time out
		if (StateCnt0)
		begin
           	NextDATAState  = `DATA_IDLE;
           	NextCRCStatusStr = 1'b0;
          	DatToutSet       = 1'b1;
           	LdStateCnt7     = 1'b1;
           	end
    	   	else
          	NextDATAState = `DATA_BUSYCHECK;
   	end

    // Time out.
    // crc status가 오지 않을 때 
    // busy bit가 끝나지 않을 때 
	else if (CKPulse && StateCnt0)
	begin
        NextDATAState  			= `DATA_IDLE;
        NextCRCStatusGet 	    	= 1'b0;
        NextCRCStatusStr 		= 1'b0;
        NextBusyStatus   		= 1'b0;
        DatToutSet       		= 1'b1;
        LdStateCnt7     		= 1'b1;
	end




  `DATA_CONTINUE_SEND:
	// 전체 Block 전송이 끝나지 않았을 경우 다음 블록을 전송하여야 한다.
	// 다음 Block 전송을 위한 Start bit전송

	if (CKPulse && StateCnt0)
	begin
	NextDATAState = `DATA_BLOCK_SEND;
       	NextnDATEN    = 1'b0; // OutPut Mode
        NextStartBit  = 1'b1; // start bit
       	LdStartBit    = 1'b1; // Output Register에 0을 load한다.
    end


  `DATA_RCV_WAIT :
	// Receive 대기

    // TimeOut 돼기 전에 StartBit가 들어올 때 
    if (CKPulse && ~BlkDatCnt0 && ~DATIN[0])
    begin
        NextDATAState  	= `DATA_BLOCK_RECEIVE;
        NextRxCRCCal 	= 1'b1; // Rx CRC Check Start
        NextBlkDatCntEn = 1'b1; // Shift Enable
        LdSDIBSize      = 1'b1; // 전체 전송되는 1 block의 data 갯수 load
        LdBitCnt       	= 1'b1; // 1BIT WIDTH DATA의 경우 BIT단위로 세야됨
        LdNibbleCnt		= 1'b1; // 4BIT
        LdWORDCnt3 		= 1'b1;
    end
    // Timeout : StartBit가 오지 않을 경우
    else if (CKPulse && StateCnt0 && ~BlkDatCnt0)
    begin
        NextDATAState = `DATA_IDLE;
        NextRxActive  = 1'b0; // Read Disable
        LdStateCnt7   = 1'b1;
        DatToutSet    = 1'b1; // Timeout interrupt signal 
    end

    `DATA_BLOCK_RECEIVE :

	if (CrcStaSet||DatCrcSet)
    begin
        NextDATAState  	= `DATA_IDLE;
        NextRxActive   	= 1'b0;
        NextRxCRCCal 	= 1'b0;
        NextBlkDatCntEn	= 1'b0;
        NextStopBit    	= 1'b0;
        LdStateCnt8    	= 1'b1;
		AbortClr		= 1'b1;
    end

	// Receive 중 Abort Command가 들어왔을 경우
	// 또한 4Byte 단위로 FIFO에 쓰게되므로 4byte align에 맞지 않으면 버려진다.
	// 따라서 소프트웨어는 전송중간에서 이러한 동작을 했을 때
	// FIFO에 들어있는 값을 비워야한다.
    else if (CKPulse && AbortCmdSent)// abort command transmitted 
	begin
        NextDATAState 	= `DATA_BLOCK_RECEIVE;
		AbortCmdSentClr = 1'b1;
		LdStateCnt2		= 1'b1; //Stop Command가 보내지고 2Cycle까지 유효 데이타임
		NextBlkDatCntEn	= 1'b0;
		AbortSet 		= 1'b1;
	end

	// Stop Command 후 2Cycle 대기
	else if (CKPulse && StateCnt0 && Abort)
	begin
		NextDATAState = `DATA_IDLE;
		AbortClr = 1'b1;
	end

       // 매 블럭마다 crc와 end bit이 전송된다.
       // crc 16bit과 end bit 1bit를 카운트 해야한다.
    else if (CKPulse && StateCnt0 && BlkDatCntEn && OneByte) // 1block
    begin
        NextDATAState = `DATA_BLOCK_RECEIVE;
        NextBlkDatCntEn  = 1'b0;// block mode에서 crc부분에서 shift동작 중지 
        LdStateCnt16   = 1'b1;// 17 카운트 (CRC 16 + endbit 1)

        if (WORDCnt0 == 1'b1)
            LdDataBufferSet = 1'b1;
    end

    // CRC Check
    // 데이터+CRC check
    else if (CKPulse && StateCnt1 && ~BlkDatCntEn)
    begin
        NextDATAState  = `DATA_BLOCK_RECEIVE;
        CRCCheckSet    = 1'b1;
        NextRxCRCCal = 1'b0;
       // if (BlkDatCnt0 == 1'b1)
       //   LdDataBufferSet = 1'b1;
      end

    // Data End and Block End
    // 지정된 모든 data를 받음
    // time over를 기다림 
    else if (CKPulse && StateCnt0 && ~BlkDatCntEn && BlkDatCnt0 && BlkNumCnt0)
        begin
			NextDATAState = `DATA_IDLE;
            DatBlkEndSet  = 1'b1; // 1 block data 완료
            DatFinSet     = 1'b1; // Status 레지스터에  data전송완료를 나타냄
			BlkNumCntSet  = 1'b0; // 모든 Block 전송
			//  Abort 상황 중간에
		AbortCmdSentClr = 1'b1;
		AbortClr = 1'b1;
        end

    // Block End
    // 1block data를 받음
    else if (CKPulse && StateCnt0 && BlkDatCnt0 && ~BlkDatCntEn)
    begin
        NextDATAState = `DATA_RCV_WAIT;// 다음 블록 대기
        DatBlkEndSet  = 1'b1;	// 1block 완료
		BlkNumCntSet  = 1'b1;
        LdSDIDTimer   = 1'b1;
		LdBlkSize     = 1'b1;
    end

    // 4byte단위로 FIFO에 write해야한다.
    else if (CKPulse && BlkDatCntEn && WORDCnt0 && OneByte)
    begin
        NextDATAState   = `DATA_BLOCK_RECEIVE;
        LdDataBufferSet = 1'b1;
        LdWORDCnt3       = 1'b1;
        LdBitCnt        = 1'b1;
    end

    // 1bit와 4bit모드에서 1byte를 카운트해야 한다.
    else if (CKPulse && BlkDatCntEn && BitCnt0)
    begin
        NextDATAState = `DATA_BLOCK_RECEIVE;
        LdBitCnt      = 1'b1;
    end
    
	default :
      NextDATAState = `DATA_IDLE;
  endcase
end

// -----------------------------------------------------------------------------
// State transition process
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge nRst)
begin 
  if (nRst == 1'b0)
    begin
      DATAState		<= `DATA_IDLE;
      BlkDatCntEn	<= 1'b0;
      RxCRCCal	<= 1'b0;
      TxCRCCal	<= 1'b0;
      StopBit		<= 1'b0;
      StartBit		<= 1'b0;
      CRCStatusGet	<= 1'b0;
      TxRdPtrInc	<= 1'b0;
      nDATEN		<= 1'b1;
      TxCRCSend	<= 1'b0;
      BusyStatus	<= 1'b0;
      CRCStatusStr<= 1'b0;
	  TxActive		<= 1'b0;
	  RxActive		<= 1'b0;
    end
  else
    begin
		if (SDreset)
		begin
		DATAState	<= `DATA_IDLE;
		BlkDatCntEn	<= 1'b0;
		RxCRCCal	<= 1'b0;
		TxCRCCal	<= 1'b0;
		StopBit		<= 1'b0;
		StartBit	<= 1'b0;
		CRCStatusGet<= 1'b0;
		TxRdPtrInc	<= 1'b0;
		nDATEN		<= 1'b1;
		TxCRCSend	<= 1'b0;
		BusyStatus	<= 1'b0;
		CRCStatusStr	<= 1'b0;
		TxActive	<= 1'b0;
		RxActive	<= 1'b0;
		end
		else
		begin
		DATAState	<= NextDATAState;
		BlkDatCntEn	<= NextBlkDatCntEn;
		RxCRCCal	<= NextRxCRCCal;
		TxCRCCal	<= NextTxCRCCal;
		StopBit		<= NextStopBit;
		StartBit	<= NextStartBit;
		CRCStatusGet<= NextCRCStatusGet;
		TxRdPtrInc	<= NextTxRdPtrInc;
		nDATEN		<= NextnDATEN;
		TxCRCSend	<= NextTxCRCSend;
		BusyStatus	<= NextBusyStatus;
		CRCStatusStr<= NextCRCStatusStr;
		RxActive	<= NextRxActive;
		TxActive	<= NextTxActive;
		end
	end
end 


//----------------------------------------------------------------
// FIFO 동작을 멈추기위해 FIFO Empty를 detect하기 위한 로직
//----------------------------------------------------------------

reg	TxEmptyDetect;
always @(posedge PCLK or negedge nRst)
begin
	if (!nRst)
	TxEmptyDetect <= 1'b0;
	else
		begin
		if (SDreset)
			TxEmptyDetect <= 1'b0;
		else
			begin
			if (TFREmpty && WORDCnt0)
			TxEmptyDetect <= 1'b1;
			else if (~TFREmpty)
			TxEmptyDetect <= 1'b0;
			end
		end
end

reg	TxEmptyDetect2;
always @(posedge PCLK or negedge nRst)
begin
    if (!nRst)
    TxEmptyDetect2<= 1'b0;
   // else if (TFREmpty && NibbleCnt0 && WORDCnt0)
	else
		begin
			if (SDreset)
		    TxEmptyDetect2<= 1'b0;	
			else if (TxEmptyDetect && NibbleCnt0)
		    TxEmptyDetect2 <= 1'b1;
		    else if (~TFREmpty)
			TxEmptyDetect2 <= 1'b0;
		end
end

reg	TxEmptyDetect3;
always @(posedge PCLK or negedge nRst)
begin
    if (!nRst)
    TxEmptyDetect3 <= 1'b0;
	else
		begin
			if (SDreset)
			TxEmptyDetect3 <= 1'b0;
		    else if (TFREmpty && BitCnt0 && WORDCnt0)
		    TxEmptyDetect3 <= 1'b1;
		    else if (~TFREmpty)
    		TxEmptyDetect3 <= 1'b0;
		end
end
//-----------------------------------------------------------------
// Clock Down Logic
// FIFO에 엉뚱한 값을 쓰거나 읽지 않기위해 SD/MMC로 나가는 클럭을 멈추게한다
//-----------------------------------------------------------------
// FIFO state
always @(DATAState /*or NextDATAState*/ or RFFull or SD1bitMode or SD4bitMode or MMCPlusMode or 
	TxEmptyDetect or TxEmptyDetect2 or TxEmptyDetect3 or BlkDatCnt0)// or TFREmpty )//(PSMode) (CMST or AbortCmd or CCMDState0)
begin
	/*if (CMST& AbortCmd & CCMDState0)
	ENCLK = 1'b1;
	else*/
	if ( ( ((DATAState==`DATA_TRANS_WAIT)|(DATAState == `DATA_CONTINUE_SEND)|(DATAState == `DATA_BLOCK_SEND)) && 
	((TxEmptyDetect3&&SD1bitMode&& ~BlkDatCnt0)|
	 (TxEmptyDetect2&&SD4bitMode && ~BlkDatCnt0)|
	 (TxEmptyDetect&&MMCPlusMode&& ~BlkDatCnt0)) ) | 
	/*((NextDATAState == `DATA_CONTINUE_SEND)&TFREmpty)|*/
	(((DATAState == `DATA_RCV_WAIT)|(DATAState == `DATA_BLOCK_RECEIVE)) &&(RFFull == 1'b1)))// revision add continue send
	//|PSMode 
	ENCLK2 = 1'b0;
	else
	ENCLK2 = 1'b1;
end
// PowerSave Mode adding
// DataPSave & (CCMDStat0)& (~CMSTSync) ==> Power Down (PowerSave mode =1)
// (PSaveMode & CMSTSync)| (CMSTSync& AbortCmd) ==> PowerSave mode =0
/*
wire	PowerSaveSet;
assign 	PowerSaveSet = (StateCnt0 & CKPulse & (DATAState == `DATA_IDLE)) ? 1'b1 : 1'b0;
always @(PSMode or PowerSaveSet or CMST or CCMDState0)
begin 
  if (CMST & AbortCmd & CCMDState0)
    NextPSMode = 1'b0;
  else if (PowerSaveSet)&(CCMDState0)
    NextPSMode = 1'b1;
  else
    NextPSMode = PSMode;
end

always @(posedge PCLK or negedge nRst)
begin
  if (nRst == 1'b0)
	PSMode <= 1'b0;
  else
	begin
	if (SDreset)
   	PSMode <= 1'b0;	
	else
	PSMode <= NextPSMode;
	end
end*/ 
//--------------------------------------------------------------
//	Busy Detect Logic for Busy Command Response (ex. R1b response) 
//--------------------------------------------------------------
// for Busy Check StateMachine
// Busy 응답을 갖는 command의 경우 사용
// 16 cycle 이내 Busy가 발생하지 않으면 NoBusy 신호발생 (SamSung MMC Spec 상에는 2Cycle)
// NoBusy를 빨리 발생시키기 위해 수정 필요
`define IDLEState 		2'b00
`define BusyCheckState 	2'b01
`define BusyState 		2'b10

reg	[1:0]	BusyState;
reg	[1:0]	NextBusyState;
reg	[4:0]	NextBusyCnt;
reg	[4:0]	BusyCnt;
reg			NoBusySet;
reg			NextNoBusySet;
reg			BusyFinSet;
reg			NextBusyFinSet;

reg			LdBusyCnt16;

wire		BusyCmdSent;
wire		BusyCnt1;
wire		BusyCnt0;

assign 		BusyCmdSent = CmdSentSet & BusyRsp;
assign 		BusyCnt1    = (BusyCnt==3'b001)? 1'b1 : 1'b0;
assign 		BusyCnt0    = (BusyCnt==3'b000)? 1'b1 : 1'b0;


wire	DATIN0;
wire	DATIN1;
assign	DATIN0 = (DATIN[0]==1'b0)? 1'b1: 1'b0;
assign	DATIN1 = (DATIN[0]==1'b1)? 1'b1: 1'b0;

always @(BusyState or BusyCmdSent or DATIN0 or DATIN1 or BusyCnt1 or CKPulse) 
begin
	LdBusyCnt16    = 1'b0;
	NextBusyFinSet = 1'b0;
	NextNoBusySet  = 1'b0;
	case (BusyState)
	`IDLEState :
		if (BusyCmdSent)
		begin
			NextBusyState  = `BusyCheckState;
			LdBusyCnt16    = 1'b1; // Busy TimeOut
		end
		else
		begin
			NextBusyState  = `IDLEState;
		end
	`BusyCheckState:	
		begin
		if (CKPulse && DATIN1 && BusyCnt1)
		begin
			NextBusyState = `IDLEState;
			NextNoBusySet = 1'b1;// Busy가 발생하지 않음
		end
		else if (CKPulse && DATIN0)
		begin
			NextBusyState  = `BusyState;
		end
		else 
			NextBusyState  = `BusyCheckState;
		end
	`BusyState:
		begin
		if (CKPulse && DATIN1)
		begin
			NextBusyState  = `IDLEState;
			NextBusyFinSet = 1'b1; // Busy가 끝남
		end
		else
		begin
			NextBusyState  = `BusyState;
		end
		end
	default : NextBusyState =`IDLEState;
	endcase
end

always @(BusyCnt  or LdBusyCnt16 or CKPulse or BusyCnt0)
begin
	 if (LdBusyCnt16 == 1'b1)
		NextBusyCnt = 5'b10000;

	else if ((CKPulse)&&(~BusyCnt0))
		NextBusyCnt = BusyCnt -1;
	else
		NextBusyCnt = BusyCnt;
end 

always @(posedge PCLK or negedge nRst)
begin
	if (!nRst)
	begin
		BusyState 	<= `IDLEState ;
		BusyCnt 	<= 1'b0;
		NoBusySet	<= 1'b0;
		BusyFinSet 	<= 1'b0;
	end
	else
	begin
		if (SDreset)
			begin
			BusyState 	<= `IDLEState ;
			BusyCnt 	<= 1'b0;
			NoBusySet	<= 1'b0;
			BusyFinSet	<= 1'b0;
			end
		else
			begin
			BusyState 	<= NextBusyState;
			BusyCnt 	<= NextBusyCnt;
			NoBusySet	<= NextNoBusySet;
			BusyFinSet 	<= NextBusyFinSet;
			end
	end
end

wire	BusyChkIdle;
assign 	BusyChkIdle  = (BusyState== `IDLEState);

endmodule
// --============================== End ======================================--
