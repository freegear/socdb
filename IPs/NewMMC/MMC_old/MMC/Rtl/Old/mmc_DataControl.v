// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : mmc_DataControl.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Data control state machine module of mmc/sd 
//  ============================================================================

`timescale 1ns/1ps


`define ST_DPSM_IDLE            9'b000000001
`define ST_DPSM_WAITS           9'b000000010
`define ST_DPSM_STREAM_SEND     9'b000000100
`define ST_DPSM_BLOCK_SEND      9'b000001000
`define ST_DPSM_BUSY            9'b000010000
`define ST_DPSM_WAITR           9'b000100000
`define ST_DPSM_STREAM_RECEIVE  9'b001000000
`define ST_DPSM_BLOCK_RECEIVE   9'b010000000
`define ST_DPSM_CONTINUE_SEND   9'b100000000


`define NoOperation             2'b00
`define OnlyBusyChk             2'b01
`define DatReceive              2'b10
`define DatTransmit             2'b11

//`include "./mmcParams.v"


module mmc_DataControl(
	nRst,
	SDreset,
	MCLK,
   	DIVlevelCo,      
   	DPSMEn,
	// register input
	//ByteOrder, // unused
	SDIDTimer,
	SDIBSize,
	//DataSize,	 // unused
	//PrdType, // for SDIO (unused)
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
	BlkCnt,
	NoBusySet,
	CrcStaSet,
	DatCrcSet,
	DatToutSet,
	DatFinSet,
	BusyFinSet,
	BusyFinSet2,

	TxDatOn,
	RxDatOn,
   
    DTSTClr,	
	RspFinSet,
	CmdSentSet,

	TxActive,
	TxRdPtrInc,
	RxActive,
	RxWriteEn,
	RxFWrData,

	TFEmpty,
	RFFull,
	FRdData,

	ENCLK2,
	nDATEN,
	DATOUT,
	DATIN
);

input           nRst;            
input			SDreset;
input           MCLK;        
input           DIVlevelCo;      
input           DPSMEn;
input	[7:0]	DATIN;      // Data input line
output	[7:0]	DATOUT;		// Data output line
output			nDATEN;
output			ENCLK2;
input  [22:0]   SDIDTimer;   	// Data Timer Register
input  [11:0]   SDIBSize;  	// Data Length Register

input			TARSP;
input			RACMD;
input			BlkMode;
input			WideBus;
input           MMCPlus;
input           RspFinSet;
input			CmdSentSet;
input			TFEmpty;
input			RFFull;			

input   [31:0]  FRdData;
input			DTST;
input	[1:0]	DatMode;
input	[11:0]	BlkNum;
input			BusyRsp;
input			AbortCmd;

output          NoBusySet;	
output			CrcStaSet;
output			DatCrcSet;
output			DatToutSet;
output			DatFinSet;
output			BusyFinSet;
output			BusyFinSet2;
output			TxDatOn;
output			RxDatOn;


output			DTSTClr;
output	[11:0]	BlkNumCnt;
output	[11:0]	BlkCnt;


output			TxActive;
output			TxRdPtrInc;
output			RxActive;
output			RxWriteEn;
output	[31:0]	RxFWrData;


reg 	[11:0]  BlkCnt ;

reg 			DTSTClr;
reg				ENCLK2;

// -----------------------------------------------------------------------------
// counter 관련 
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Data Shift Register 관련
// -----------------------------------------------------------------------------

reg [31:0]      DATShift;
reg [31:0]      NextDATShift;
reg             LdTxRxShiftD; // FIFO to Data Shift register
reg             BlkCntEn; // Data shift enable
reg             NextBlkCntEn;

// -----------------------------------------------------------------------------
// Data output 관련
// -----------------------------------------------------------------------------

reg             LdTxRxShift1; // Stop Bit를 로드함
reg             LdTxRxShift0; // Start Bit를 로드함

reg             LdCRC; // data out은 crc값으로 내보냄
reg [7:0]       NextDATOUT;
reg [7:0]       DATOUT;

// -----------------------------------------------------------------------------
// Block counter...
// -----------------------------------------------------------------------------

reg             LdBlkSize;  // BlkSize를 BlkCnt로 불러옴
reg [11:0]      NextBlkCnt; // 남은 block의 byte

// -----------------------------------------------------------------------------
// Block Number counter...
// -----------------------------------------------------------------------------

reg             LdBlkNum;
reg	[11:0]  	BlkNumCnt ;
reg [11:0]      NextBlkNumCnt;
reg				BlkNumCntSet;	
// -----------------------------------------------------------------------------
// Word counter...
// -----------------------------------------------------------------------------
reg             LdWRDCnt3;
reg [1:0]       NextWRDCnt;
reg [1:0]       WRDCnt;

// -----------------------------------------------------------------------------
// Nibble counter...
// -----------------------------------------------------------------------------
reg             LdNibbleCnt;
reg             NextNibbleCnt;
reg             NibbleCnt;

// -----------------------------------------------------------------------------
// Bit counter...
// -----------------------------------------------------------------------------
reg             LdBitCnt;
reg [2:0]       NextBitCnt;
reg [2:0]       BitCnt;

// -----------------------------------------------------------------------------
// Transferred block counter...
// -----------------------------------------------------------------------------

reg             LdBLKTCntR;
reg             LdBLKTCntT;
reg				LdBLKTCnt2;
reg             LdBLKTCnt7;
reg             LdBLKTCnt8;
reg             LdBLKTCnt15;
reg             LdBLKTCnt16;
reg [31:0]      NextBLKTCnt;
reg [31:0]      BLKTCnt;

// -----------------------------------------------------------------------------
//  Token counter
// -----------------------------------------------------------------------------

reg [2:0]		TokenCnt;
reg [2:0]		NextTokenCnt;
reg 			LdTokenCnt4;
reg 			LdTokenCnt1;
reg 			TokenChkSet;
reg				TokenChk;
reg				NextTokenChk;

// -----------------------------------------------------------------------------
reg 			BsyMode;

reg 			RxActive;
reg         	NextRxActive;    

reg				TxActive;
reg         	NextTxActive;    

reg         	NextTxRdPtrInc;  
reg         	TxRdPtrInc;      

reg 			Wtoken;

reg 			CRCCheck;
reg 			NextCRCCheck;
reg 			CRCCheckSet;
reg 			DBEndSet;
reg 			DCrcFSet1;

// -----------------------------------------------------------------------------
reg         	LdDataBufferSet;
reg         	LdDataBuffer;

reg [31:0]      RxFWrData;
reg             RxWriteEn;
reg [31:0]      NextRxFWrData;
reg             NextRxWriteEn;
reg             DATCRCTxSEn;

// -----------------------------------------------------------------------------
//  CRC block reg
// -----------------------------------------------------------------------------

reg [15:0]      NextDATCRCShift7;
reg [15:0]      NextDATCRCShift6;
reg [15:0]      NextDATCRCShift5;
reg [15:0]      NextDATCRCShift4;
reg [15:0]      NextDATCRCShift3;
reg [15:0]      NextDATCRCShift2;
reg [15:0]      NextDATCRCShift1;
reg [15:0]      NextDATCRCShift0;

reg [15:0]      DATCRCShift7;
reg [15:0]      DATCRCShift6;
reg [15:0]      DATCRCShift5;
reg [15:0]      DATCRCShift4;
reg [15:0]      DATCRCShift3;
reg [15:0]      DATCRCShift2;
reg [15:0]      DATCRCShift1;
reg [15:0]      DATCRCShift0;
reg             DATCRCTxEn;
reg             DATCRCRxEn;

reg [7:0]       CRCDataIn;
reg             NextDATCRCTxEn;  
reg             NextDATCRCTxSEn; 

//------------------------------------------------------------------------------
reg				NextnDATEN;
reg				nDATEN;


// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------

reg	    		TokenRxSEn;
reg         	NextTokenRxSEn;  
reg         	NextDATCRCRxEn;  
reg	   			DataPSave;
reg        		NextDataPSave;
reg         	NextShiftNotE;   
reg         	ShiftNotE;       
reg         	PendPulseSet;    
reg         	NextWtoken;      
reg        		NextBsyMode;     
reg         	DEndSet;         
reg         	DToutSet;        

// -----------------------------------------------------------------------------
// StateMachine 
// -----------------------------------------------------------------------------

reg [8:0]       NextDPSMState;   
reg [8:0]       DPSMState;

// -----------------------------------------------------------------------------
// StateMachine internal use
// -----------------------------------------------------------------------------

reg             NextStartBit;    
reg             NextStopBit;     
reg             StartBit;        
reg             StopBit;         



wire	DatToutSet;
wire	DatFinSet;
wire	TxDatOn;
wire	RxDatOn;
wire	CRC7Err;
wire	CRC6Err;
wire	CRC5Err;
wire	CRC4Err;
wire	CRC3Err;
wire	CRC2Err;
wire	CRC1Err;
wire	CRC0Err;
wire	TokenErr;
wire	CrcStaSet;

assign	DatToutSet = DToutSet;
assign  DatFinSet	= DEndSet;

assign	TxDatOn = ((DPSMState == `ST_DPSM_STREAM_SEND)|(DPSMState == `ST_DPSM_BLOCK_SEND)|
				(DPSMState == `ST_DPSM_WAITS)|(DPSMState == `ST_DPSM_BUSY))? 1'b1 : 1'b0;
assign	RxDatOn = ((DPSMState == `ST_DPSM_STREAM_RECEIVE)|(DPSMState == `ST_DPSM_BLOCK_RECEIVE)|
				(DPSMState == `ST_DPSM_WAITR))? 1'b1 : 1'b0;

assign CRC7Err	= (DATCRCShift7 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC6Err	= (DATCRCShift6 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC5Err	= (DATCRCShift5 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC4Err  = (DATCRCShift4 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC3Err  = (DATCRCShift3 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC2Err  = (DATCRCShift2 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC1Err  = (DATCRCShift1 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;
assign CRC0Err  = (DATCRCShift0 == 16'b0000000000000000) ?
                          1'b0 : 1'b1;

assign TokenErr = (DATCRCShift0[2:0] == 3'b010) ? 1'b0 : 1'b1;

assign CrcStaSet	= (TokenErr & TokenChk);

// -----------------------------------------------------------------------------
// 
// -----------------------------------------------------------------------------

wire	SD1bitMode;
wire	SD4bitMode;
wire	MMCPlusMode;
wire	DatCrcSet;
wire	BlkNumCnt0;

assign  SD1bitMode  = (((WideBus == 1'b0) && (MMCPlus == 1'b0)) == 1'b1)?
                            1'b1 : 1'b0;
assign  SD4bitMode  = (((WideBus == 1'b1) && (MMCPlus == 1'b0)) == 1'b1)?
                            1'b1 : 1'b0;
assign  MMCPlusMode = ((MMCPlus == 1'b1) == 1'b1)?
                            1'b1 : 1'b0;

assign DatCrcSet	=  (MMCPlusMode == 1'b1)?
					 	((CRC7Err|CRC6Err|CRC5Err|CRC4Err|CRC3Err|CRC2Err|CRC1Err|CRC0Err) & CRCCheck):
			    		(SD4bitMode == 1'b1)?
						((CRC3Err|CRC2Err|CRC1Err|CRC0Err) & CRCCheck):  (CRC0Err & CRCCheck);

//
assign  BlkNumCnt0  = (BlkNumCnt== 12'b000000000000) ? 1'b1 : 1'b0 ;

// -----------------------------------------------------------------------------
// Block Count Comparators
// -----------------------------------------------------------------------------
wire	BLKTCnt0;
wire	BLKTCnt1;
assign  BLKTCnt0         = (BLKTCnt == 32'h00000000) ? 1'b1 : 1'b0;
assign  BLKTCnt1         = (BLKTCnt == 32'h00000001) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Data Count Comparators
// -----------------------------------------------------------------------------

wire	BlkCnt0;
wire	BlkCnt1;
wire	BlkCnt7;
assign  BlkCnt0         = (BlkCnt == 12'b000000000000) ?
                          1'b1 : 1'b0;
assign  BlkCnt1         = (BlkCnt == 12'b000000000001) ?
                          1'b1 : 1'b0;
assign  BlkCnt7         = (BlkCnt == 12'b000000000111) ?
                          1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Data Length Comparator
// -----------------------------------------------------------------------------

wire	DataLenL7;
assign	DataLenL7        = (BlkNum < 16'b0000000000000111) ?
                          1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Word Count Comparators
// -----------------------------------------------------------------------------
wire	WRDCnt0;
assign	WRDCnt0          = (WRDCnt == 2'b00) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Nibble Count Comparators
// -----------------------------------------------------------------------------
wire	NibbleCnt0;
assign	NibbleCnt0          =  (NibbleCnt == 1'b0) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Bit Count Comparators
// -----------------------------------------------------------------------------
wire	BitCnt0;
assign	BitCnt0          = (BitCnt == 3'b000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Token Count Comparators
// -----------------------------------------------------------------------------
wire	TokenCnt0;
wire	TokenCnt1;
wire	TokenCnt2;
assign	TokenCnt0          = (TokenCnt == 3'b000) ? 1'b1 : 1'b0;
assign	TokenCnt1          = (TokenCnt == 3'b001) ? 1'b1 : 1'b0;
assign	TokenCnt2          = (TokenCnt == 3'b010) ? 1'b1 : 1'b0;

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
// LdTxRxShiftD : FIFO에서 읽어 Shift register로 값을 가져오는 신호
// BlkCntEn: shift동작 enable
//

always @(DIVlevelCo or LdTxRxShiftD or FRdData or
         BlkCntEn or DATShift or DATIN or MMCPlusMode or SD4bitMode or SD1bitMode)
begin
	NextDATShift = DATShift;
    if (DIVlevelCo == 1'b1) // For output sync
    begin
        if (LdTxRxShiftD == 1'b1)//전송할 data를 FIFO에서 읽어 SHIFT RESISTER에 위치
            NextDATShift[31:0] = {FRdData[7:0], FRdData[15:8],
                              FRdData[23:16], FRdData[31:24]};
        else if (BlkCntEn == 1'b1) // Shift enable
         begin
		    if (MMCPlusMode ==1'b1) // 8bit shifter for MMCPlus
		    NextDATShift[31:0] = {DATShift[23:0], DATIN[7:0]};
		    else if (SD4bitMode == 1'b1) // 4bit shifter for SD Card
	        NextDATShift[31:0] = {DATShift[27:0], DATIN[3:0]};
		    else
         	NextDATShift[31:0] = {DATShift[30:0], DATIN[0]};
 	    end
    end
end 

// -----------------------------------------------------------------------------
// Sequential part of the Data Shift Register
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin 
    if (nRst == 1'b0)
        DATShift <= 32'h00000000;
    else
		begin
		if (SDreset)
		DATShift <= 32'h00000000;
		else
        DATShift <= NextDATShift;
		end
end

// -----------------------------------------------------------------------------
// REGISTER = > FIFO DATA
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    LdDataBuffer <= 1'b0;
  else
    LdDataBuffer <= LdDataBufferSet;
end

always @(LdDataBuffer or WRDCnt or DATShift or RxFWrData or RxWriteEn)
begin 
    NextRxFWrData = RxFWrData;
    NextRxWriteEn    = RxWriteEn;
    if (LdDataBuffer == 1'b1)
    begin
        NextRxWriteEn = ~(RxWriteEn);
        if (WRDCnt[1:0] == 2'b11)// data receive SHIFT REGISTER TO FIFO
            NextRxFWrData = {DATShift[7:0], DATShift[15:8],
                            DATShift[23:16], DATShift[31:24]};
        else if (WRDCnt[1:0] == 2'b00)
            NextRxFWrData = {8'b00000000, DATShift[7:0],
                            DATShift[15:8], DATShift[23:16]};
        else if (WRDCnt[1:0] == 2'b01)
            NextRxFWrData = {16'b0000000000000000, DATShift[7:0],
                            DATShift[15:8]};
        else
            NextRxFWrData = {24'b000000000000000000000000,
                            DATShift[7:0]};
    end
end

always @(posedge MCLK or negedge nRst)
begin 
    if (nRst == 1'b0)
        begin
        RxFWrData <= 32'h00000000;
        RxWriteEn    <= 1'b0;
        end
    else
		begin
			if (SDreset)
			begin
			RxFWrData <= 32'h00000000;
        	RxWriteEn    <= 1'b0;	
			end
			else
	        begin
	        RxFWrData <= NextRxFWrData;
    	    RxWriteEn    <= NextRxWriteEn;
        	end
		end
end 

//------------------------------------------------------------------------------
// DATA OUTPUT ( 사용하지 않는 DAT line은 1을 내보냄 )
// -----------------------------------------------------------------------------
always @(NextDATShift or LdTxRxShift1 or LdTxRxShift0 or
         NextDATCRCShift0 or NextDATCRCShift1 or NextDATCRCShift2 or 
	 NextDATCRCShift3 or NextDATCRCShift4 or NextDATCRCShift5 or NextDATCRCShift6 or 
	 NextDATCRCShift7 or LdCRC or DATCRCTxSEn or DIVlevelCo or 
	 DATOUT or MMCPlusMode or SD1bitMode or SD4bitMode)
begin 
    NextDATOUT[7:0]  = DATOUT [7:0];
    if (DIVlevelCo == 1'b1)
    begin
        if (LdTxRxShift0 == 1'b1) // start bit 내보내기
        begin
                if (SD1bitMode)    
                NextDATOUT[7:0] = 8'b11111110;// start bit
                else if (SD4bitMode) 
                NextDATOUT[7:0] = 8'b11110000;// start bit
                else if (MMCPlusMode)    
                NextDATOUT[7:0] = 8'b00000000;// start bit
        end
        else if (LdTxRxShift1 == 1'b1)// end bit 내보내기
            NextDATOUT[7:0] = 8'b11111111;// transimit
        else if ((LdCRC == 1'b1) || (DATCRCTxSEn == 1'b1)) // CRC output
	        begin

    	    if (MMCPlusMode ==1'b1) // 8bit data line for MMCPlus
				begin
            	NextDATOUT[7] = NextDATCRCShift7[15];
            	NextDATOUT[6] = NextDATCRCShift6[15];
            	NextDATOUT[5] = NextDATCRCShift5[15];
            	NextDATOUT[4] = NextDATCRCShift4[15];
       	    	NextDATOUT[3] = NextDATCRCShift3[15];
    	    	NextDATOUT[2] = NextDATCRCShift2[15];
            	NextDATOUT[1] = NextDATCRCShift1[15];
            	NextDATOUT[0] = NextDATCRCShift0[15];
				end
			else if (SD4bitMode == 1'b1)
				begin
       	    	NextDATOUT[3] = NextDATCRCShift3[15];
       	    	NextDATOUT[2] = NextDATCRCShift2[15];
       	    	NextDATOUT[1] = NextDATCRCShift1[15];
       	    	NextDATOUT[0] = NextDATCRCShift0[15];
				NextDATOUT[7:4] = 4'b1111;
				end
			else
				begin
				NextDATOUT[0] = NextDATCRCShift0[15];
				NextDATOUT[7:1] = 7'b1111111;
				end
	        end
        else
	        begin
    	    if (MMCPlusMode ==1'b1) // 8bit data line for MMCPlus
                NextDATOUT[7:0] = NextDATShift[31:24];
	        else if (SD4bitMode == 1'b1) // 4bit data line for SD Card
	            begin
		        NextDATOUT[3:0]   = NextDATShift[31:28];
	 	        NextDATOUT[7:4]   = 4'b1111;
	            end
	        else
	            begin
        	    NextDATOUT[0]   = NextDATShift[31];
	            NextDATOUT[7:1] = 7'b1111111;
 	            end
	        end
    end
end 

// -----------------------------------------------------------------------------
// Sequential part of the DATOUT register
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin 
    if (nRst == 1'b0)
    DATOUT[7:0] <= 8'b11111111;
    else
		begin
		if (SDreset)
	    DATOUT[7:0] <= 8'b11111111;
		else
		DATOUT[7:0] <= NextDATOUT[7:0];
		end
end 

always @(TokenChkSet)
begin
  if (TokenChkSet == 1'b1)
    NextTokenChk = 1'b1;
  else
    NextTokenChk = 1'b0;
end 

always @(posedge MCLK or negedge nRst)
begin 
  if (nRst == 1'b0)
    TokenChk <= 1'b0;
  else
	begin
	if (SDreset)
    TokenChk <= 1'b0;
	else
    TokenChk <= NextTokenChk;
	end
end

//------------------------------------------------------------------------------
// Block counter ( remain block byte )
//------------------------------------------------------------------------------
always @(LdBlkSize or SDIBSize or BlkCnt0 or BlkCntEn or DIVlevelCo or  BitCnt0 or
         SD1bitMode or NibbleCnt0 or SD4bitMode or MMCPlusMode or BlkCnt)
begin 
    if (LdBlkSize == 1'b1) // Block size register 에서  load
        NextBlkCnt = SDIBSize;
    else if ((BlkCnt0 == 1'b0) && (BlkCntEn == 1'b1) && (DIVlevelCo == 1'b1) &&
           (((BitCnt0 == 1'b1) && (SD1bitMode == 1'b1))|((NibbleCnt0 == 1'b1) && 
           (SD4bitMode ==1'b1)) | (MMCPlusMode ==1'b1)))
        NextBlkCnt = (BlkCnt) - 1;//1 block에서 남은  바이트 수 계산
    else
        NextBlkCnt = BlkCnt;
end 

always @(posedge MCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BlkCnt <= 12'd0;
    else
		begin
		if (SDreset)
		BlkCnt <= 12'd0;
		else
        BlkCnt <= NextBlkCnt;
		end
end 

//------------------------------------------------------------------------------
// Block Number counter ( remain block Number )
//------------------------------------------------------------------------------
always @(BlkNumCnt or BlkNumCntSet or BlkNum or LdBlkNum)
begin 
    if (LdBlkNum == 1'b1) // Block number register 에서  load
        NextBlkNumCnt = BlkNum;
    else if (BlkNumCntSet) // 1 block 전송완료시
        NextBlkNumCnt = (BlkNumCnt) - 1;// 남은 block의 갯수 계산
    else
        NextBlkNumCnt = BlkNumCnt;
end 

always @(posedge MCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BlkNumCnt <= 12'd0;
    else
		begin
		if (SDreset)
		BlkNumCnt <= 12'd0;
		else
        BlkNumCnt <= NextBlkNumCnt;
		end
end 

// -----------------------------------------------------------------------------
// 32BIT FIFO이므로 읽거나 쓰기위해서는 32BIT 단위를 사용해야한다.
// 1 WORD가 되었는지 카운트하는 부분 (byte를   카운트한다 ) 
// -----------------------------------------------------------------------------
always @(WRDCnt or DIVlevelCo or LdWRDCnt3 or BitCnt0 or NibbleCnt0 or BlkCntEn or
         DPSMState or MMCPlusMode or SD1bitMode or SD4bitMode)
begin
    if (DPSMState == `ST_DPSM_IDLE)
        NextWRDCnt = 2'b00;
    else if (LdWRDCnt3 == 1'b1)
        NextWRDCnt = 2'b11;
    else if  (((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1)) && (((BitCnt0 == 1'b1) && (SD1bitMode == 1'b1))|
        ((NibbleCnt0 == 1'b1) && (SD4bitMode == 1'b1))|(MMCPlusMode == 1'b1)))
        NextWRDCnt = (WRDCnt) - 1;
    else
        NextWRDCnt = WRDCnt;
end 

// -----------------------------------------------------------------------------
// Sequential part of the Word Counter
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        WRDCnt <= 2'b00;
    else
		begin
		if (SDreset)
        WRDCnt <= 2'b00;
		else
        WRDCnt <= NextWRDCnt;
		end
end 



// -----------------------------------------------------------------------------
// Combinational part of the Nibble Counter
// NibbleCnt is a 1-bit down counter which decrements at the end of
// 4 bit-time of data tranfer. (For 4bit DAT Line)
// 4bit 모드에서는 bit counter를 사용하지 않고 nibble counter를 사용해서 byte와
// Word를 계산한다.
// -----------------------------------------------------------------------------
always @(NibbleCnt or DIVlevelCo or LdNibbleCnt or NibbleCnt0 or SD4bitMode or
         BlkCntEn)
begin
    if (LdNibbleCnt == 1'b1)
        NextNibbleCnt = 1'b1;
    else if (BlkCntEn==1'b0)
	NextNibbleCnt = 1'b0;
    else if ((SD4bitMode == 1'b1) && (BlkCntEn == 1'b1) && (DIVlevelCo == 1'b1)) 
	  // SD 카드 일 때만 사용 하는 카운터
        begin
        NextNibbleCnt = (~NibbleCnt);
        end
    else
        NextNibbleCnt = NibbleCnt;
end 

// -----------------------------------------------------------------------------
// Sequential part of the Nibble Counter
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        NibbleCnt <= 1'b0;
    else
		begin
		if (SDreset)
        NibbleCnt <= 1'b0;		
		else
        NibbleCnt <= NextNibbleCnt;
		end
end 

// -----------------------------------------------------------------------------
// Combinational part of the Bit Counter
// BitCnt is a 3-bit down counter which decrements at the end of
// one bit-time of data tranfer. (For 1bit DAT Line)
// -----------------------------------------------------------------------------
always @(BitCnt or DIVlevelCo or LdBitCnt or BitCnt0 or SD1bitMode or
         BlkCntEn)
begin 
    if (LdBitCnt == 1'b1)
        NextBitCnt = 3'b111;
    else if (BlkCntEn == 1'b0)
        NextBitCnt = 3'b000;
    else if ((BitCnt0 == 1'b0) && (DIVlevelCo == 1'b1) &&
            (SD1bitMode == 1'b1)) // 1bit mode에서만 사용
        begin
            NextBitCnt = (BitCnt) - 1;
        end
    else
        NextBitCnt = BitCnt;
end // p_BitCntComb

// -----------------------------------------------------------------------------
// Sequential part of the Bit Counter
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BitCnt <= 3'b000;
    else
		begin
		if (SDreset)
		BitCnt <= 3'b000;
		else
        BitCnt <= NextBitCnt;
		end
end
//------------------------------------------------------------------------------
// Transfering block time counter
// 스테이트 머신에서 transition을 위한 counter
//------------------------------------------------------------------------------ 
always @(BLKTCnt or LdBLKTCntR or LdBLKTCntT or BLKTCnt0 or LdBLKTCnt2 or
         LdBLKTCnt7 or LdBLKTCnt8 or LdBLKTCnt15 or LdBLKTCnt16 or
         BitCnt0  or NibbleCnt0 or SDIBSize or SDIDTimer or DIVlevelCo or SD1bitMode or SD4bitMode
        or MMCPlusMode)
begin : p_BLKTCntComb
    if (LdBLKTCntR == 1'b1)
        NextBLKTCnt = {20'b00000000000000000000, SDIBSize};
	else if (LdBLKTCnt2 == 1'b1)
        NextBLKTCnt = 32'b00000000000000000000000000000010;
    else if (LdBLKTCnt7 == 1'b1)
        NextBLKTCnt = 32'b00000000000000000000000000000111;
    else if (LdBLKTCnt8 == 1'b1)
        NextBLKTCnt = 32'b00000000000000000000000000001000;
    else if (LdBLKTCnt15 == 1'b1)
        NextBLKTCnt = 32'b00000000000000000000000000001111;
    else if (LdBLKTCnt16 == 1'b1)
        NextBLKTCnt = 32'b00000000000000000000000000010000;
    else if (LdBLKTCntT == 1'b1)
        NextBLKTCnt = SDIDTimer;// timeout register value load
    else if (((BLKTCnt0 == 1'b0) && (BitCnt0 == 1'b1) &&
           (DIVlevelCo == 1'b1)&& (SD1bitMode == 1'b1))|
          ((BLKTCnt0 == 1'b0) && (NibbleCnt0 == 1'b1) &&
           (DIVlevelCo == 1'b1)&& (SD4bitMode == 1'b1))|
           ((BLKTCnt0 == 1'b0) && (DIVlevelCo == 1'b1) &&
           (MMCPlusMode == 1'b1))) 
        NextBLKTCnt = (BLKTCnt) - 1;
    else
        NextBLKTCnt = BLKTCnt;
end

// -----------------------------------------------------------------------------
// Sequential part of the Block Counter
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
    if (nRst == 1'b0)
        BLKTCnt <= 32'h00000000;
    else
		begin
		if (SDreset)
		BLKTCnt <= 32'h00000000;
		else
        BLKTCnt <= NextBLKTCnt;
		end
end 
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Combinational part of CRC16(7) generator.
// CRCO generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift7 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn )
begin 
  NextDATCRCShift7 = DATCRCShift7;
  if (DIVlevelCo == 1'b1)
    begin
      if (DATCRCTxSEn == 1'b1)// 블록 모드에서 CRC부분 전송시
        NextDATCRCShift7 = {DATCRCShift7[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift7[15:13] = DATCRCShift7[14:12];
          NextDATCRCShift7[12]    = DATCRCShift7[15] ^ DATCRCShift7[11]
                                                     ^ CRCDataIn[7];
          NextDATCRCShift7[11:6]  = DATCRCShift7[10:5];
          NextDATCRCShift7[5]     = DATCRCShift7[15] ^ DATCRCShift7[4]
                                                     ^ CRCDataIn[7];
          NextDATCRCShift7[4:1]   = DATCRCShift7[3:0];
          NextDATCRCShift7[0]     = DATCRCShift7[15] ^ CRCDataIn[7];
        end
      else
        NextDATCRCShift7 = 16'h0000;
    end
end
// -----------------------------------------------------------------------------
// Combinational part of CRC6 generator.
// CRCO generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift6 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn )
begin 
  NextDATCRCShift6 = DATCRCShift6;
  if (DIVlevelCo == 1'b1)
    begin
      if (DATCRCTxSEn == 1'b1)
        NextDATCRCShift6 = {DATCRCShift6[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift6[15:13] = DATCRCShift6[14:12];
          NextDATCRCShift6[12]    = DATCRCShift6[15] ^ DATCRCShift6[11]
                                                     ^ CRCDataIn[6];
          NextDATCRCShift6[11:6]  = DATCRCShift6[10:5];
          NextDATCRCShift6[5]     = DATCRCShift6[15] ^ DATCRCShift6[4]
                                                     ^ CRCDataIn[6];
          NextDATCRCShift6[4:1]   = DATCRCShift6[3:0];
          NextDATCRCShift6[0]     = DATCRCShift6[15] ^ CRCDataIn[6];
        end
      else
        NextDATCRCShift6 = 16'h0000;
    end
end
// -----------------------------------------------------------------------------
// Combinational part of CRC5 generator.
// CRC5 generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift5 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn )
begin 
  NextDATCRCShift5 = DATCRCShift5;
  if (DIVlevelCo == 1'b1)
    begin
      if (DATCRCTxSEn == 1'b1)
        NextDATCRCShift5 = {DATCRCShift5[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift5[15:13] = DATCRCShift5[14:12];
          NextDATCRCShift5[12]    = DATCRCShift5[15] ^ DATCRCShift5[11]
                                                     ^ CRCDataIn[5];
          NextDATCRCShift5[11:6]  = DATCRCShift5[10:5];
          NextDATCRCShift5[5]     = DATCRCShift5[15] ^ DATCRCShift5[4]
                                                     ^ CRCDataIn[5];
          NextDATCRCShift5[4:1]   = DATCRCShift5[3:0];
          NextDATCRCShift5[0]     = DATCRCShift5[15] ^ CRCDataIn[5];
        end
      else
        NextDATCRCShift5 = 16'h0000;
    end
end 
// -----------------------------------------------------------------------------
// Combinational part of CRC4 generator.
// CRC4 generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift4 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn )
begin
    NextDATCRCShift4 = DATCRCShift4;
    if (DIVlevelCo == 1'b1)
    begin
        if (DATCRCTxSEn == 1'b1)
            NextDATCRCShift4 = {DATCRCShift4[14:0], 1'b0};
        else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
            NextDATCRCShift4[15:13] = DATCRCShift4[14:12];
            NextDATCRCShift4[12]    = DATCRCShift4[15] ^ DATCRCShift4[11]
                                                     ^ CRCDataIn[4];
            NextDATCRCShift4[11:6]  = DATCRCShift4[10:5];
            NextDATCRCShift4[5]     = DATCRCShift4[15] ^ DATCRCShift4[4]
                                                     ^ CRCDataIn[4];
            NextDATCRCShift4[4:1]   = DATCRCShift4[3:0];
            NextDATCRCShift4[0]     = DATCRCShift4[15] ^ CRCDataIn[4];
        end
        else
            NextDATCRCShift4 = 16'h0000;
    end
end 
// -----------------------------------------------------------------------------
// Combinational part of CRC3 generator.
// CRC3 generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift3 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn)
begin 
  NextDATCRCShift3 = DATCRCShift3;
  if (DIVlevelCo == 1'b1)
    begin
     if (DATCRCTxSEn == 1'b1)
        NextDATCRCShift3 = {DATCRCShift3[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift3[15:13] = DATCRCShift3[14:12];
          NextDATCRCShift3[12]    = DATCRCShift3[15] ^ DATCRCShift3[11]
                                                     ^ CRCDataIn[3];
          NextDATCRCShift3[11:6]  = DATCRCShift3[10:5];
          NextDATCRCShift3[5]     = DATCRCShift3[15] ^ DATCRCShift3[4]
                                                     ^ CRCDataIn[3];
          NextDATCRCShift3[4:1]   = DATCRCShift3[3:0];
          NextDATCRCShift3[0]     = DATCRCShift3[15] ^ CRCDataIn[3];
        end
      else
        NextDATCRCShift3 = 16'h0000;
    end
end 
// -----------------------------------------------------------------------------
// Combinational part of CRC2 generator.
// CRC3 generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift2 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn )
begin 
  NextDATCRCShift2 = DATCRCShift2;
  if (DIVlevelCo == 1'b1)
    begin
     if (DATCRCTxSEn == 1'b1)
        NextDATCRCShift2 = {DATCRCShift2[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift2[15:13] = DATCRCShift2[14:12];
          NextDATCRCShift2[12]    = DATCRCShift2[15] ^ DATCRCShift2[11]
                                                     ^ CRCDataIn[2];
          NextDATCRCShift2[11:6]  = DATCRCShift2[10:5];
          NextDATCRCShift2[5]     = DATCRCShift2[15] ^ DATCRCShift2[4]
                                                     ^ CRCDataIn[2];
          NextDATCRCShift2[4:1]   = DATCRCShift2[3:0];
          NextDATCRCShift2[0]     = DATCRCShift2[15] ^ CRCDataIn[2];
        end
      else
        NextDATCRCShift2 = 16'h0000;
    end
end 
// -----------------------------------------------------------------------------
// Combinational part of CRC1 generator.
// CRCO generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift1 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn)
begin 
  NextDATCRCShift1 = DATCRCShift1;
  if (DIVlevelCo == 1'b1)
    begin
    if (DATCRCTxSEn == 1'b1)
        NextDATCRCShift1 = {DATCRCShift1[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift1[15:13] = DATCRCShift1[14:12];
          NextDATCRCShift1[12]    = DATCRCShift1[15] ^ DATCRCShift1[11]
                                                     ^ CRCDataIn[1];
          NextDATCRCShift1[11:6]  = DATCRCShift1[10:5];
          NextDATCRCShift1[5]     = DATCRCShift1[15] ^ DATCRCShift1[4]
                                                     ^ CRCDataIn[1];
          NextDATCRCShift1[4:1]   = DATCRCShift1[3:0];
          NextDATCRCShift1[0]     = DATCRCShift1[15] ^ CRCDataIn[1];
        end
      else
        NextDATCRCShift1 = 16'h0000;
    end
end 
// -----------------------------------------------------------------------------
// Combinational part of CRC0 generator.
// CRCO generator is also used as a simple shift register in BUSY mode
// to receive the token bits send by the card.
// -----------------------------------------------------------------------------
always @(DATCRCShift0 or DATCRCTxEn or DATCRCRxEn or CRCDataIn or
         DIVlevelCo or DATCRCTxSEn or TokenRxSEn)
begin 
  NextDATCRCShift0 = DATCRCShift0;
  if (DIVlevelCo == 1'b1)
    begin
      if (TokenRxSEn == 1'b1)
        NextDATCRCShift0 = {DATCRCShift0[14:0], CRCDataIn[0]};
      else if (DATCRCTxSEn == 1'b1)
        NextDATCRCShift0 = {DATCRCShift0[14:0], 1'b0};
      else if ((DATCRCTxEn == 1'b1) || (DATCRCRxEn == 1'b1))
        begin
          NextDATCRCShift0[15:13] = DATCRCShift0[14:12];
          NextDATCRCShift0[12]    = DATCRCShift0[15] ^ DATCRCShift0[11]
                                                     ^ CRCDataIn[0];
          NextDATCRCShift0[11:6]  = DATCRCShift0[10:5];
          NextDATCRCShift0[5]     = DATCRCShift0[15] ^ DATCRCShift0[4]
                                                     ^ CRCDataIn[0];
          NextDATCRCShift0[4:1]   = DATCRCShift0[3:0];
          NextDATCRCShift0[0]     = DATCRCShift0[15] ^ CRCDataIn[0];
        end
      else
        NextDATCRCShift0 = 16'h0000;
    end
end 
// -----------------------------------------------------------------------------
// Sequential part of CRC0 generator
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
   begin	  
    DATCRCShift0 <= 16'h0000;
    DATCRCShift1 <= 16'h0000;
    DATCRCShift2 <= 16'h0000;
    DATCRCShift3 <= 16'h0000;
    DATCRCShift4 <= 16'h0000;
    DATCRCShift5 <= 16'h0000;
    DATCRCShift6 <= 16'h0000;
    DATCRCShift7 <= 16'h0000;
   end
  else
   begin
		if (SDreset)
		begin
	    DATCRCShift0 <= 16'h0000;
    	DATCRCShift1 <= 16'h0000;
	    DATCRCShift2 <= 16'h0000;
    	DATCRCShift3 <= 16'h0000;
		DATCRCShift4 <= 16'h0000;
		DATCRCShift5 <= 16'h0000;
		DATCRCShift6 <= 16'h0000;
		DATCRCShift7 <= 16'h0000;
		end
		else
		begin
	    DATCRCShift0 <= NextDATCRCShift0;
    	DATCRCShift1 <= NextDATCRCShift1;
	    DATCRCShift2 <= NextDATCRCShift2;
    	DATCRCShift3 <= NextDATCRCShift3;
	    DATCRCShift4 <= NextDATCRCShift4;
    	DATCRCShift5 <= NextDATCRCShift5;
	    DATCRCShift6 <= NextDATCRCShift6;
    	DATCRCShift7 <= NextDATCRCShift7;
		end
   end
end 

// -----------------------------------------------------------------------------
// Multiplexer to select the source of the CRC data
// During transmission, the DATOUT to the card is routed to the
// CRC generator.
// During reception, the DATIN from the card is routed to the
// CRC generator.
// -----------------------------------------------------------------------------
always @(DATCRCTxEn or DATOUT or DATIN)
begin
  if (DATCRCTxEn == 1'b1)
    CRCDataIn[7:0] = DATOUT[7:0];
  else
    CRCDataIn[7:0] = DATIN[7:0];
end


// -----------------------------------------------------------------------------
// The data state machine enters power down mode if it remains in
// the IDLE state for 8 MMCICLKs. The power down condition is disabled
// by the DPSMStart signal.
// -----------------------------------------------------------------------------
wire	DataPSaveSet;
assign DataPSaveSet     = ((BLKTCnt0 == 1'b1) & (DIVlevelCo == 1'b1) &
                           (DPSMState == `ST_DPSM_IDLE)) ?
                          1'b1 : 1'b0;
always @(DataPSave or DataPSaveSet or DTST)
begin 
  if (DTST == 1'b1)
    NextDataPSave = 1'b0;
  else if (DataPSaveSet == 1'b1)
    NextDataPSave = 1'b1;
  else
    NextDataPSave = DataPSave;
end

// -----------------------------------------------------------------------------
// Sequential part of the DataPSave signal
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    DataPSave <= 1'b0;
  else
	begin
	if (SDreset)
    DataPSave <= 1'b0;	
	else
    DataPSave <= NextDataPSave;
	end
end 


// -----------------------------------------------------------------------------
// Combinatioal part of the CRCCheck signal
// -----------------------------------------------------------------------------
always @(CRCCheckSet)
begin 
  if (CRCCheckSet == 1'b1)
    NextCRCCheck = 1'b1;
  else
    NextCRCCheck = 1'b0;
end

// -----------------------------------------------------------------------------
// Sequential part of the CRCCheck signal
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
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

// -----------------------------------------------------------------------------
// Combinational part of the Token counter
// -----------------------------------------------------------------------------
always @(TokenCnt or LdTokenCnt4 or LdTokenCnt1 or DIVlevelCo or
         DPSMState or TokenCnt0)
begin
  if (DPSMState == `ST_DPSM_IDLE)
    NextTokenCnt = 3'b000;
  else if (LdTokenCnt4 == 1'b1)
    NextTokenCnt = 3'b100;
  else if (LdTokenCnt1 == 1'b1)
    NextTokenCnt = 3'b001;
  else if ((DIVlevelCo == 1'b1) && (TokenCnt0 == 1'b0))
    NextTokenCnt = (TokenCnt) - 1;
  else
    NextTokenCnt = TokenCnt;
end 
// -----------------------------------------------------------------------------
// Sequential part of the Token counter
// -----------------------------------------------------------------------------

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
	begin
    TokenCnt <= 3'b000;
	end
  else
	begin
	if (SDreset)
    TokenCnt <= 3'b000;
	else
    TokenCnt <= NextTokenCnt;
	end
end

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

always @(posedge MCLK or negedge nRst)
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
// Combinational part of the DPSM
// -----------------------------------------------------------------------------
always @(DPSMState or DTST or DIVlevelCo or DatMode or TARSP or RACMD or AbortCmdSent or
	CmdSentSet or RspFinSet or StartBit or BlkMode or BLKTCnt0 or BlkCnt0 or BlkNumCnt0 or 
	DATCRCTxEn or BitCnt0 or SD1bitMode or NibbleCnt0 or SD4bitMode or MMCPlusMode or WRDCnt0 or BlkCntEn or 
	ShiftNotE or TokenCnt0 or TxActive or TokenCnt1 or DATCRCTxSEn or TxRdPtrInc or TokenCnt2 or RxActive or
	DPSMEn or TFEmpty or Abort or nDATEN or StopBit or MMCPlus or DATIN or BsyMode or DATCRCRxEn or CrcStaSet or
	DatCrcSet or Wtoken or BLKTCnt1 or TokenRxSEn or BlkCnt1 or BlkCnt7 or DataLenL7)

begin


  LdBlkNum	 	  = 1'b0;
  LdBlkSize       = 1'b0;
  LdBLKTCnt2	  = 1'b0;
  LdBLKTCnt7      = 1'b0;
  LdBLKTCnt8      = 1'b0;
  LdBLKTCnt15     = 1'b0;
  LdBLKTCnt16     = 1'b0;
  LdBLKTCntR      = 1'b0;
  LdBLKTCntT      = 1'b0;
  LdBitCnt        = 1'b0;
  LdNibbleCnt     = 1'b0;
  LdWRDCnt3       = 1'b0;
  LdTokenCnt1     = 1'b0;
  LdCRC           = 1'b0;
  LdTxRxShift0    = 1'b0;
  LdTxRxShift1    = 1'b0;
  LdTxRxShiftD    = 1'b0;
  PendPulseSet    = 1'b0;
  DToutSet        = 1'b0;
  DEndSet         = 1'b0;
  DBEndSet		  = 1'b0;
  LdDataBufferSet = 1'b0;
  TokenChkSet     = 1'b0;
  CRCCheckSet     = 1'b0;
  DTSTClr		  = 1'b0;
  AbortCmdSentClr = 1'b0;
  BlkNumCntSet 	  = 1'b0;


  NextRxActive    = RxActive;
  NextTxActive    = TxActive;


  NextDPSMState   = DPSMState;
  NextDATCRCRxEn  = DATCRCRxEn;
  NextDATCRCTxEn  = DATCRCTxEn;
  NextStopBit     = StopBit;
  NextStartBit    = StartBit;



  NextWtoken      = Wtoken;
  NextTxRdPtrInc  = TxRdPtrInc;
  NextBlkCntEn    = BlkCntEn;
  NextDATCRCTxSEn = DATCRCTxSEn;
  NextBsyMode     = BsyMode;
  NextShiftNotE   = ShiftNotE;
  NextTokenRxSEn  = TokenRxSEn;
  NextnDATEN	  = nDATEN;
  LdDataBufferSet = 1'b0;
  LdWRDCnt3       = 1'b0;
  LdBitCnt        = 1'b0;
  LdBLKTCntT      = 1'b0;
  LdTokenCnt4     = 1'b0;


  DCrcFSet1 	  = 1'b0;
  NextDPSMState   = DPSMState;


  AbortCmdSentClr = 1'b0;
  AbortClr = 1'b0;
  AbortSet = 1'b0;
  
	case (DPSMState)

	`ST_DPSM_IDLE :
		if (DPSMEn == 1'b0)
				NextDPSMState = `ST_DPSM_IDLE;
		else
		begin
    	case (DatMode)
		`NoOperation:
			begin
			NextDPSMState = `ST_DPSM_IDLE;
			if (DTST)
				DTSTClr = 1'b1;
			end
		`OnlyBusyChk:
			if (DTST) // command 후에 busy check mode하는가?
			begin
			NextDPSMState = `ST_DPSM_IDLE;
			DTSTClr = 1'b1; // data transfer clear
        	NextnDATEN    = 1'b1;

			end

		`DatReceive:	
			if (DTST && ((!RACMD) | (RACMD && CmdSentSet))) // command 후에 receive mode?
			begin
			NextDPSMState = `ST_DPSM_WAITR;
	    	LdBlkNum = 1'b1;	// BlkNum 값을 가져온다.
			LdBlkSize = 1'b1;	// Block size값을 가져온다.
			DTSTClr = 1'b1; 	// data transfer clear
     		NextRxActive  = 1'b1;	// rx을 fifo활성화
			NextTxActive  = 1'b0;
        	NextnDATEN    = 1'b1;
			LdBLKTCntT	  = 1'b1;
       		end
			else
			begin
			NextDPSMState = `ST_DPSM_IDLE;
     		NextRxActive  = 1'b1;	// rx을 fifo활성화
			NextTxActive  = 1'b0;
			end

		`DatTransmit:	
			if (DTST && ((!TARSP) | (TARSP && RspFinSet))) // command 후에 receive mode?
			begin
			NextDPSMState = `ST_DPSM_WAITS;
	   		LdBlkNum = 1'b1;	// BlkNum 값을 가져온다.
			LdBlkSize = 1'b1;	// Block size값을 가져온다.
			DTSTClr = 1'b1; 	// data transfer clear
			NextTxActive= 1'b1;  // Tx fifo 
			NextRxActive  = 1'b0;
			LdBLKTCnt2 = 1'b1; // for Nwr time
			end
			else
			begin
			NextDPSMState = `ST_DPSM_IDLE;
     		NextTxActive  = 1'b1;	// rx을 fifo활성화
			NextRxActive  = 1'b0;
			end

		default	:
			NextDPSMState = `ST_DPSM_IDLE;
		endcase
		end

   	`ST_DPSM_WAITS : // transmit 대기 
		if ((DPSMEn == 1'b0) || (BlkCnt0 == 1'b1))// 모든 block이 전송되었을 경우
	    	begin
    		NextDPSMState = `ST_DPSM_IDLE;
        	NextnDATEN    = 1'b1;
	    	end
		else if ((DIVlevelCo == 1'b1)&&(((BLKTCnt0 == 1'b1)&&(TARSP))|(!TARSP))) // Start bit 전송
			begin
        	NextnDATEN    = 1'b0;
	        NextStartBit  = 1'b1; // start bit
        	LdTxRxShift0  = 1'b1; // FIFO to SHIFT REGISTER에 0을 load한다.
			NextShiftNotE = 1'b0;
	   		if (BlkMode == 1'b0)
			NextDPSMState = `ST_DPSM_STREAM_SEND;
			else
			NextDPSMState = `ST_DPSM_BLOCK_SEND;
	    	end

	`ST_DPSM_STREAM_SEND : 
		// start + DATA + End bit
		if ((DIVlevelCo == 1'b1) && (StartBit == 1'b1)) // start bit후
		begin
	        NextDPSMState  = `ST_DPSM_STREAM_SEND;
        	NextStartBit   = 1'b0;
	        NextBlkCntEn   = 1'b1; // Shift enable
	        LdTxRxShiftD   = 1'b1; // 보낼 FIFO값 읽기
        	NextTxRdPtrInc = ~(TxRdPtrInc);
	        LdBitCnt       = 1'b1;
	        LdWRDCnt3      = 1'b1;
		end

		//End bit 전송
		// Stream mode (data) transmission ends abort command 가 들어오면...
		// command end bit 에서 2cycle에 전송종료할 것... adding...
	/*	else if ((DIVlevelCo == 1'b1) && (AbortCmd == 1'b1) && (CmdSentSet == 1'b1) && 
			(((BitCnt0 == 1'b1) && (SD1bitMode == 1'b0))|| 
			((NibbleCnt0 == 1'b1) && (SD4bitMode == 1'b0)) || (MMCPlusMode == 1'b1)))
		begin
			NextDPSMState   = `ST_DPSM_STREAM_SEND;
	        NextStopBit     = 1'b1; // stop bit 전송을 위해서~
	        NextBlkCntEn    = 1'b0; // Stream 모드에서 data shift 중지
	        NextDATCRCTxSEn = 1'b0; // CRC shift 중지
	        LdTxRxShift1    = 1'b1; // end bit를 data output에 load
		end
	*/	
		// END BIT 후의 STATE변화	
		// Stream mode에서 end bit는 crc전송 없이 나간다.
		// Transmission ends (data + stop bit) in Stream mode
		else if ((DIVlevelCo == 1'b1) && (StopBit == 1'b1))
		begin
        	NextDPSMState = `ST_DPSM_IDLE;
	        NextStopBit   = 1'b0;
	        NextnDATEN    = 1'b1;//
	        DEndSet       = 1'b1;// data가 모두 전송됨
        	LdBLKTCnt7    = 1'b1;
		end
   		// 보낼 BUFFER가 UNDERRUN되었을 경우
		// idle이 아니고 buffer가 찰때까지 기다리는 경우도 생각해야됨
		//
		else if ((DIVlevelCo == 1'b1) && (TFEmpty == 1'b1) &&
			(WRDCnt0 == 1'b1) && (BitCnt0 == 1'b1) &&
			((BlkMode == 1'b0) || ((BlkMode == 1'b1) && (DATCRCTxEn == 1'b1))))
    		begin
		NextDPSMState  = `ST_DPSM_IDLE;
	    NextDATCRCTxEn = 1'b0;
	    NextnDATEN    = 1'b1;//
		end

		// Word 경계에서 FIFO에서 값을 읽어옴
		// 
		else if ((DIVlevelCo == 1'b1) && (WRDCnt0 == 1'b1) && (BlkCntEn == 1'b1) &&
		(((BitCnt0 == 1'b1) && (SD1bitMode == 1'b1)) || 
		((NibbleCnt0== 1'b1) && (SD4bitMode == 1'b1)) || (MMCPlusMode == 1'b1)))
		begin
	        NextDPSMState  = `ST_DPSM_STREAM_SEND;
       		LdTxRxShiftD   = 1'b1;
			NextTxRdPtrInc = ~(TxRdPtrInc);
	        LdWRDCnt3      = 1'b1;
        	if (!MMCPlusMode)
	        LdBitCnt       = 1'b1;	
 		end

		// Byte boundary
		else if ((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1) && (((BitCnt0 == 1'b1) && (SD1bitMode==1'b1)) |
		((NibbleCnt0 == 1'b0) && (SD4bitMode == 1'b1)))) //|(MMCPlusMode == 1'b1)))
		begin
		NextDPSMState = `ST_DPSM_STREAM_SEND;
		LdBitCnt      = 1'b1;
		end
     
	`ST_DPSM_BLOCK_SEND : 
		// Transmit
		// 1 word단위로 FIFO pointer update
		// block 모드는 end bit 후에 busy state로
	
		// Start + DATA + CRC16 + End bit
		//if (DPSMEn == 1'b0)
		if ((DPSMEn == 1'b0)|| (CrcStaSet == 1'b1 ) ||(DatCrcSet == 1'b1))
		begin
        	NextDPSMState   = `ST_DPSM_IDLE;
        	NextDATCRCTxEn  = 1'b0;
       		NextDATCRCTxSEn = 1'b0;
	        NextBlkCntEn    = 1'b0;
        	NextStartBit    = 1'b0;
	        NextStopBit     = 1'b0;
	        NextnDATEN      = 1'b1;
        	NextShiftNotE   = 1'b0;
	        LdBLKTCnt8      = 1'b1;
		end
    
		// Block mode start bit
		else if ((DIVlevelCo == 1'b1) && (StartBit == 1'b1))//start가 이미 나간 시점으로 다음 data를 내보냄
		begin
			NextDPSMState  = `ST_DPSM_BLOCK_SEND;
	   	   	NextStartBit   = 1'b0; // start 된후 1block이 완료되기 전에 다시 이 루틴에 들어오지 않음
   	    	NextBlkCntEn   = 1'b1; // shift register shifting
    	   	NextDATCRCTxEn = 1'b1; // CRC block enable
    		LdBLKTCntR     = 1'b1; // 설정된 block size 만큼 전송하기 위해 전체 전송해야될 byte값 load
					// BlkSize를  block카운터로 넣는다.
	       	LdBitCnt        = 1'b1;// bit는 7부터 down 카운팅
    	   	LdNibbleCnt     = 1'b1;// 4bit mode에서 nibble 카운팅
        	NextTxRdPtrInc = ~(TxRdPtrInc);
	       	if (ShiftNotE == 1'b0)// shifter register가 비었다면 (block단위로 계속 보낼것이므로 )
                        	     // block 크기가 word 단위가 아닐수도 있다.!! 
           		begin
           		LdWRDCnt3      = 1'b1;
		   		LdTxRxShiftD   = 1'b1;
				NextTxRdPtrInc = ~(TxRdPtrInc);
				end                                    
    		end

		// block 전송중 stop command가 들어올 경우...
/*
    		else if ((DIVlevelCo == 1'b1) && (AbortCmd == 1'b1) && (CmdSentSet == 1'b1) &&
			(DATCRCTxEn == 1'b1) && (((BitCnt0== 1'b1) && (SD1bitMode == 1'b1))||
	             	((NibbleCnt0 == 1'b1) && (SD4bitMode == 1'b1))||(MMCPlusMode == 1'b1))) // 1block 전송중에
			begin
			NextStopBit     = 1'b1; // stop bit 전송을 위해서~
			NextBlkCntEn    = 1'b0;  // data shift 중지
			NextDATCRCTxSEn = 1'b0; // CRC shift 중지
			LdTxRxShift1    = 1'b1; // end bit를 data output에 load
			end
*/

		// Data 전송 1block 단위가 끝났을 경우 CRC를 전송해야됨
		// shift register를 enable 시켰으므로 전송됨	
		// block mode에서 데이터부분 전송 완료  16-bit CRC를 전송.  카운터 값을 15로...
		else if ((DIVlevelCo == 1'b1) &&  (BLKTCnt0 == 1'b1) && (DATCRCTxEn== 1'b1) &&
            		(((BitCnt0== 1'b1) && (SD1bitMode == 1'b1))||((NibbleCnt0 == 1'b1) && (SD4bitMode == 1'b1))||
        		(MMCPlusMode == 1'b1))) // 1block 전송완료시
		begin
	        NextDPSMState   = `ST_DPSM_BLOCK_SEND;
        	NextDATCRCTxEn  = 1'b0; // CRC disable
	        NextBlkCntEn    = 1'b0; // data shift register shift중지
	        NextDATCRCTxSEn = 1'b1; // CRC 부분을 그냥 shifting
        	LdCRC           = 1'b1; // CRC 부분을 output
		LdBLKTCnt15     = 1'b1; // 16bit crc bit전송을 위한 카운터
        	  // ShiftNotE is used as an internal flag to check the status
	          // of the shift register.
	          if (WRDCnt0 == 1'b0)
        	    NextShiftNotE = 1'b1;
	          else
        	    NextShiftNotE = 1'b0;
	        end

		// 블록모드의 경우 Transmission ends (data + CRC + stop bit) in Block mode
		else if ((DIVlevelCo == 1'b1) && (StopBit == 1'b1))
		begin
	        NextDPSMState = `ST_DPSM_BUSY; // NWR time을 맞추기 위해 
        	NextStopBit   = 1'b0;
	        NextnDATEN    = 1'b1;
	        NextWtoken    = 1'b1;  // write token...
	        LdBLKTCntT    = 1'b1;  // time out value setting

		end
		
		// 4. End bit 전송
		// Block mode (data+CRC)  transmission ends
		else if ((DIVlevelCo == 1'b1) && ((BLKTCnt0 == 1'b1) && (DATCRCTxEn == 1'b0) &&
		(((BitCnt0 == 1'b1) && (SD1bitMode == 1'b1))||
		((NibbleCnt0 == 1'b1) &&  (SD4bitMode == 1'b1))||(MMCPlusMode == 1'b1))))
		//1block 전송완료시
		// block 모드는 DATCRCTxEn이  disable 된 상태에서 BLKTCnt가 0이면
		// CRC까지 전송된 것이고
		begin
		NextDPSMState   = `ST_DPSM_BLOCK_SEND;
		NextStopBit     = 1'b1; // stop bit 전송을 위해서~
		NextBlkCntEn   = 1'b0; // Stream 모드에서 data shift 중지
		NextDATCRCTxSEn = 1'b0; // CRC shift 중지
		LdTxRxShift1    = 1'b1; // end bit를 data output에 load
		end
    	
	

		// 보낼 BUFFER가 UNDERRUN되었을 경우
		// idle이 아니고 buffer가 찰때까지 기다리는 경우도 생각해야됨
		//
		else if ((DIVlevelCo == 1'b1) && (TFEmpty == 1'b1) &&
			(WRDCnt0 == 1'b1) && (BitCnt0 == 1'b1) &&
			((BlkMode == 1'b0) || ((BlkMode == 1'b1) && (DATCRCTxEn == 1'b1))))
    		begin
			NextDPSMState  = `ST_DPSM_IDLE;
	        NextDATCRCTxEn = 1'b0;
	        NextnDATEN    = 1'b1;
		end

		// Word 경계에서 FIFO에서 값을 읽어옴
		// 
		else if ((DIVlevelCo == 1'b1) && (WRDCnt0 == 1'b1) && (BlkCntEn == 1'b1) &&
		(((BitCnt0 == 1'b1) && (SD1bitMode == 1'b1)) || 
		((NibbleCnt0== 1'b1) && (SD4bitMode == 1'b1)) || (MMCPlusMode == 1'b1)))
		begin
	        NextDPSMState  = `ST_DPSM_BLOCK_SEND;
       		LdTxRxShiftD   = 1'b1;
			NextTxRdPtrInc = ~(TxRdPtrInc);
	        LdWRDCnt3      = 1'b1;
        	if (!MMCPlusMode)
	        LdBitCnt       = 1'b1;	
 		end

		// Byte boundary
		else if ((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1) && 
			(((BitCnt0 == 1'b1) && (SD1bitMode==1'b1)) |
			((NibbleCnt0 == 1'b0) && (SD4bitMode == 1'b1))))
		begin
		NextDPSMState = `ST_DPSM_BLOCK_SEND;
		LdBitCnt      = 1'b1;
		end
    
	`ST_DPSM_BUSY :
	// NwR TIME 
	// crc RESPONSE
	// BUSY CHECK
	//
	//    
	//  BLOCK MODE 
   	//   Start+ CRC status + End + Nwr    
   	//   Start+ CRC status + End + Start+ Busy + End + Nwr
   	//
   	//  STREAM MODE
   	//   
	// DCrcFSet2 becomes high if the Token bits received are invalid.
	if ((DPSMEn == 1'b0)|| (CrcStaSet == 1'b1 ) ||(DatCrcSet == 1'b1))
        begin
	NextDPSMState  = `ST_DPSM_IDLE;
	NextShiftNotE  = 1'b0;
	NextWtoken     = 1'b0;
	NextTokenRxSEn = 1'b0;
	NextBsyMode    = 1'b0;
	LdBLKTCnt8     = 1'b1;
	NextnDATEN    = 1'b1;
        end
	// CRC status의 start bit
	else if ((DIVlevelCo == 1'b1) && (Wtoken == 1'b1) && (BLKTCnt0 ==1'b1)) //crc check bit timeout
	begin
       	if (DATIN[0] ==1'b0) // time out과  crc check값이 같이 들어오는 경우 
           	begin
        	NextDPSMState  = `ST_DPSM_BUSY;
	        NextWtoken     = 1'b0;
        	NextTokenRxSEn = 1'b1; // CRC STATUS bit을 저장
	        LdTokenCnt4    = 1'b1;
           	end
       	else
		    NextDPSMState   = `ST_DPSM_IDLE;
			NextWtoken	= 1'b0;
    	 	DToutSet    = 1'b1;
	end

	else if ((DIVlevelCo == 1'b1) && (Wtoken == 1'b1) && (DATIN[0] == 1'b0)) // crc check bit start
	begin
        NextDPSMState  = `ST_DPSM_BUSY;
        NextWtoken     = 1'b0;
        NextTokenRxSEn = 1'b1; // CRC STATUS bit을 저장
        LdTokenCnt4    = 1'b1;
	end
 
	// CRC check bit 후에 바로 start bit + zero가 오면 busy이다
	else if ((DIVlevelCo == 1'b1) && (TokenCnt0 == 1'b1) &&
               (Wtoken == 1'b0) && (BsyMode == 1'b0))
	begin
	// Non BUSY mode
	// busy가 아닌경우 
	        if (DATIN[0] == 1'b1)
        	begin
   		   	LdBLKTCnt2	  = 1'b1;// for Nwr time
			LdTokenCnt1   = 1'b1;
				if (BlkNumCnt0==1'b0)
				begin
				BlkNumCntSet = 1'b1;
				NextDPSMState = `ST_DPSM_CONTINUE_SEND;
				LdBlkSize    = 1'b1;
				end
				else
				begin
				BlkNumCntSet = 1'b0;
				NextDPSMState = `ST_DPSM_IDLE;
				end
        	end
    	// DATIN[0]이 low 인 경우에서 timeout발생시 
        	else if (BLKTCnt0 == 1'b1)
	        begin
        	NextDPSMState  = `ST_DPSM_IDLE;
	        NextTokenRxSEn = 1'b0;
        	NextShiftNotE  = 1'b0;
        	DToutSet       = 1'b1;
	        LdBLKTCnt7     = 1'b1;

        	end
         // BUSY mode
	        else // DATIN[0]이 low 인 경우
        	begin
	        NextDPSMState = `ST_DPSM_BUSY;
        	NextBsyMode   = 1'b1;
	        end
	 end

    // busy mode가 끝났을 알림
    // busy 상태에서 1이 들어오면...
    //
	else if ((DIVlevelCo == 1'b1) && (BsyMode == 1'b1) &&
               (DATIN[0] == 1'b1))
   	begin
        NextBsyMode   = 1'b0;
        LdTokenCnt1   = 1'b1;
		LdBLKTCnt2	  = 1'b1; 
    	if (BlkNumCnt0==1'b0)
        	begin
	        BlkNumCntSet = 1'b1;
        	NextDPSMState = `ST_DPSM_CONTINUE_SEND;
			LdBlkSize	  = 1'b1;
        	end
        else
	        begin
            BlkNumCntSet = 1'b0;
            NextDPSMState = `ST_DPSM_IDLE;
    	    end
	end

     // Token Check
     // CRC check bit 가 010인지 101인지 체크
     // 
	else if ((DIVlevelCo == 1'b1) && (TokenCnt2 == 1'b1))
        begin
	TokenChkSet    = 1'b1;
	NextTokenRxSEn = 1'b0;

          // Time out
          if (BLKTCnt0 == 1'b1)
            begin
              NextDPSMState  = `ST_DPSM_IDLE;
              NextTokenRxSEn = 1'b0;
              NextShiftNotE  = 1'b0;
              DToutSet       = 1'b1;
              LdBLKTCnt7     = 1'b1;
            end
          else
            NextDPSMState = `ST_DPSM_BUSY;
        end

     // DEnd and DBEnd 모든 block과 byte전송이 완료됨 전체 블록 전송완료
   	else if ((DIVlevelCo == 1'b1) && (TokenCnt1 == 1'b1) &&
               (BlkCnt0 == 1'b1)&& (BlkNumCnt0==1'b1))
   	begin
	DBEndSet = 1'b1;
	DEndSet  = 1'b1;
        // Time out
		if (BLKTCnt0 == 1'b1)
            	begin
              	NextDPSMState  = `ST_DPSM_IDLE;
             	NextTokenRxSEn = 1'b0;
              	NextShiftNotE  = 1'b0;
              	DToutSet       = 1'b1;
              	LdBLKTCnt7     = 1'b1;
            	end
          	else
            	NextDPSMState = `ST_DPSM_BUSY;// 대부분 곧장 busy가 오므로 busy check후에 종료하게 하여야한다.
        end

    // DBEnd 한 블록의 끝
	else if ((DIVlevelCo == 1'b1) && (TokenCnt1 == 1'b1))
	begin
        DBEndSet = 1'b1;

          // Time out
		if (BLKTCnt0 == 1'b1)
		begin
              	NextDPSMState  = `ST_DPSM_IDLE;
              	NextTokenRxSEn = 1'b0;
              	NextShiftNotE  = 1'b0;
              	DToutSet       = 1'b1;
              	LdBLKTCnt7     = 1'b1;
            	end
          	else
            	NextDPSMState = `ST_DPSM_BUSY;
        	end

    // Time out.
    // crc status가 오지 않을 때 
    // busy bit가 끝나지 않을 때 
	else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1))
	begin
        NextDPSMState  = `ST_DPSM_IDLE;
        NextShiftNotE  = 1'b0;
        NextWtoken     = 1'b0;
        NextTokenRxSEn = 1'b0;
        NextBsyMode    = 1'b0;
        DToutSet       = 1'b1;
        LdBLKTCnt7     = 1'b1;
	end

  `ST_DPSM_CONTINUE_SEND:
	if ((DPSMEn == 1'b0))// 모든 block이 전송되었을 경우
   	begin
  		NextDPSMState = `ST_DPSM_IDLE;
		NextnDATEN    = 1'b1;
   	end
	else if ((DIVlevelCo == 1'b1)&&(BLKTCnt0 == 1'b1)) // Start bit 전송
	begin
       	NextnDATEN    = 1'b0;
        NextStartBit  = 1'b1; // start bit
       	LdTxRxShift0  = 1'b1; // FIFO to SHIFT REGISTER에 0을 load한다.
		NextShiftNotE = 1'b0;
	   	if (BlkMode == 1'b0)
		NextDPSMState = `ST_DPSM_STREAM_SEND;
		else
		NextDPSMState = `ST_DPSM_BLOCK_SEND;
    end


  `ST_DPSM_WAITR : // Receive
	// RX BUFFER가  OVERRUN되었을 경우
	//
	// START BIT가 들어왔을 경우
	//
	// TIME OUT
    if (DPSMEn == 1'b0)
        begin
        NextDPSMState  = `ST_DPSM_IDLE;
        NextRxActive   = 1'b0;
        NextShiftNotE  = 1'b0;
        LdBLKTCnt8     = 1'b1;
        end
    // Receive Overrun
    // FIFO가 FULL되었을 경우

    // Valid start bit in Block mode
    else if ((DIVlevelCo == 1'b1) && (BlkCnt0 == 1'b0) &&
               (DATIN[0] == 1'b0) && (BlkMode == 1'b1))
    begin
        NextDPSMState  	= `ST_DPSM_BLOCK_RECEIVE;
        NextDATCRCRxEn 	= 1'b1; // CRC 모듈로 받기
        NextBlkCntEn  	= 1'b1; // shift register enable
        LdBLKTCntR      = 1'b1; // 전체 전송되는 data 갯수 load
        LdBitCnt       	= 1'b1; // 1BIT WIDTH DATA의 경우 BIT단위로 세야됨
        LdNibbleCnt		= 1'b1; // 4BIT
        // 8bit mode
        
        //if (ShiftNotE == 1'b0)
        LdWRDCnt3 = 1'b1;
    end

    // Valid start bit in Stream mode
    else if ((DIVlevelCo == 1'b1) && (BlkCnt0 == 1'b0) && (DATIN[0] == 1'b0) &&
               (BlkMode == 1'b0))
    begin
        NextDPSMState = `ST_DPSM_STREAM_RECEIVE;
        NextBlkCntEn  = 1'b1; // shift register enable
        LdBLKTCntR    = 1'b1; // 전체 전송되는 data 개수 로드
        LdBitCnt      = 1'b1; // Bit count
    	LdNibbleCnt   = 1'b1; // 4BIT
        LdWRDCnt3     = 1'b1; // byte align
        if (DataLenL7 == 1'b1)
        PendPulseSet = 1'b1;
    end

    // Time out  start bit가 오지 않을 경우
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) && (BlkCnt0 == 1'b0))
    begin
        NextDPSMState = `ST_DPSM_IDLE;
        NextRxActive  = 1'b0; // Read Disable
        NextShiftNotE = 1'b0; 
        LdBLKTCnt7    = 1'b1;
        DToutSet      = 1'b1; // Timeout interrupt signal 
    end

    `ST_DPSM_STREAM_RECEIVE :
	
    if ((DPSMEn == 1'b0) || (CrcStaSet == 1'b1 ) ||(DatCrcSet == 1'b1))
    begin
        NextDPSMState  = `ST_DPSM_IDLE;
        NextRxActive   = 1'b0;
        NextDATCRCRxEn = 1'b0;
        NextBlkCntEn   = 1'b0;
        NextStopBit    = 1'b0;
        NextShiftNotE  = 1'b0;
        LdBLKTCnt8     = 1'b1;
    end

      // Stream mode Receive end (Data + stop bit) 
      //
    else if ((DIVlevelCo == 1'b1) && (StopBit == 1'b1))
      begin
        NextDPSMState = `ST_DPSM_WAITR;
        DEndSet       = 1'b1;// Data End status를 나타내기위해 사용
        NextStopBit   = 1'b0;
      end

      // Stream mode data end
      // stream 모드에서는 지정된 데이터를 모두 받으면 end bit가 오는 것으로 
      // 인식 
    else if ((DIVlevelCo == 1'b1) && (BlkCnt1 == 1'b1) &&
             (BitCnt0 == 1'b1))
      begin
        NextDPSMState   = `ST_DPSM_STREAM_RECEIVE;
        LdDataBufferSet = 1'b1; // 
        NextBlkCntEn    = 1'b0; // shift 중지
        NextStopBit     = 1'b1; // stop bit 받기
      end
   
    // DEnd and DBEnd
    // 지정된 모든 data를 받음
    // time over를 기다림 
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) &&
             (BlkCntEn == 1'b0) && (BlkCnt0 == 1'b1))
        begin
            NextDPSMState = `ST_DPSM_WAITR;
            DBEndSet      = 1'b1; //
            DEndSet       = 1'b1; // status 레지스터에  data전송완료를 나타냄
        end

    // DBEnd
    // 1block data를 받음
    // 다음 block을 기다림
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) &&
            (BlkCntEn == 1'b0))
    begin
        NextDPSMState = `ST_DPSM_WAITR;
        DBEndSet      = 1'b1;// 1block 받음 완료
        LdBLKTCntT    = 1'b1;
    end

    // Word boundary
    // 4byte단위로 FIFO에 write해야한다.
    //
    else if ((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1) &&
            (WRDCnt0 == 1'b1) && (BitCnt0 == 1'b1))
    begin
        NextDPSMState   = `ST_DPSM_STREAM_RECEIVE;
        LdDataBufferSet = 1'b1;
        LdWRDCnt3       = 1'b1;
        LdBitCnt        = 1'b1;
        if ((BlkMode == 1'b0) && (BlkCnt7 == 1'b1))
            PendPulseSet = 1'b1;
    end

    // Byte boundary
    // 1bit와 4bit모드에서 1byte를 카운트해야 한다.
    //
    else if ((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1) &&
             (BitCnt0 == 1'b1))
    begin
        NextDPSMState = `ST_DPSM_STREAM_RECEIVE;
        LdBitCnt      = 1'b1;
        if ((BlkMode == 1'b0) && (BlkCnt7 == 1'b1))
        PendPulseSet = 1'b1;
    end

    `ST_DPSM_BLOCK_RECEIVE :

	if ((DPSMEn == 1'b0)|| (CrcStaSet == 1'b1 ) ||(DatCrcSet == 1'b1))
    begin
        NextDPSMState  = `ST_DPSM_IDLE;
        NextRxActive   = 1'b0;
        NextDATCRCRxEn = 1'b0;
        NextBlkCntEn   = 1'b0;
        NextStopBit    = 1'b0;
        NextShiftNotE  = 1'b0;
        LdBLKTCnt8     = 1'b1;
    end

    // Receive FIFO Overrun condition

      // DataCrcError condition in block mode. (Programmed DataLength
      // is not a multiple of block size)
    else if ((DIVlevelCo == 1'b1) && (BlkCnt1 == 1'b1) &&
             (BLKTCnt1 == 1'b0) && (BlkCntEn == 1'b1) &&
             (DATCRCRxEn == 1'b1))
    begin
        NextDPSMState  = `ST_DPSM_IDLE;
        NextRxActive   = 1'b0;
        NextDATCRCRxEn = 1'b0;
        NextBlkCntEn   = 1'b0;
        NextShiftNotE  = 1'b0;
        DCrcFSet1      = 1'b1;
        LdBLKTCnt7     = 1'b1;
    end

    else if ((DIVlevelCo == 1'b1) && (AbortCmdSent))// abort command transmitted 
	begin
		AbortCmdSentClr = 1'b1;
		LdBLKTCnt2 = 1'b1;
		NextBlkCntEn= 1'b0;
		AbortSet = 1'b1;
	end

	else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) && (Abort== 1'b1))
	begin
		AbortClr = 1'b1;
		NextDPSMState = `ST_DPSM_IDLE;
	end

       // 매 블럭마다 crc와 end bit이 전송된다.
       // crc 16bit과 end bit 1bit를 카운트 해야한다.
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) && // 1block data전송
             (BlkCntEn == 1'b1) && 
            (((BitCnt0 == 1'b1) && (SD1bitMode == 1'b1))|((NibbleCnt0 == 1'b1) && (SD4bitMode))|(MMCPlus== 1'b1)))
    begin
        NextDPSMState = `ST_DPSM_BLOCK_RECEIVE;
        NextBlkCntEn  = 1'b0;// block mode에서 crc부분에서 shift동작 중지 
        LdBLKTCnt16   = 1'b1;// 17 카운트 (CRC 16 + endbit 1)

        // Data is loaded into the receive FIFO only on a word
        // boundary.
        if (WRDCnt0 == 1'b0)
          NextShiftNotE = 1'b1;
        else
          begin
            NextShiftNotE   = 1'b0;
            LdDataBufferSet = 1'b1;
          end
    end

    // CRC Check
    // 데이터+CRC check
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt1 == 1'b1) &&
             (BlkCntEn == 1'b0))
    begin
        NextDPSMState  = `ST_DPSM_BLOCK_RECEIVE;
        CRCCheckSet    = 1'b1;
        NextDATCRCRxEn = 1'b0;
        if ((BlkCnt0 == 1'b1) && (ShiftNotE == 1'b1))
            LdDataBufferSet = 1'b1;
      end

    // DEnd and DBEnd
    // 지정된 모든 data를 받음
    // time over를 기다림 
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) &&
             (BlkCntEn == 1'b0) && (BlkCnt0 == 1'b1) && (BlkNumCnt0 == 1'b1))
        begin
            DBEndSet      = 1'b1; // 1 block data를 받음을 알리는 신호
            DEndSet       = 1'b1; // status 레지스터에  data전송완료를 나타냄
			BlkNumCntSet  = 1'b0;
			NextDPSMState = `ST_DPSM_IDLE;
        end

    // DBEnd
    // 1block data를 받음
    // 다음 block을 기다림
    else if ((DIVlevelCo == 1'b1) && (BLKTCnt0 == 1'b1) && (BlkCnt0 == 1'b1)&&
            (BlkCntEn == 1'b0))
    begin
        NextDPSMState = `ST_DPSM_WAITR;
        DBEndSet      = 1'b1;// 1block 받음 완료
		BlkNumCntSet  = 1'b1;
        LdBLKTCntT    = 1'b1;
		LdBlkSize     = 1'b1;
    end

    // Word boundary
    // 4byte단위로 FIFO에 write해야한다.
    //
    else if ((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1) &&
            (WRDCnt0 == 1'b1) && (((BitCnt0 == 1'b1)&&(SD1bitMode))|((NibbleCnt0==1'b1)&&(SD4bitMode))|(MMCPlusMode)))
    begin
        NextDPSMState   = `ST_DPSM_BLOCK_RECEIVE;
        LdDataBufferSet = 1'b1;
        LdWRDCnt3       = 1'b1;
        LdBitCnt        = 1'b1;
        if ((BlkMode == 1'b0) && (BlkCnt7 == 1'b1))
            PendPulseSet = 1'b1;
    end

    // Byte boundary
    // 1bit와 4bit모드에서 1byte를 카운트해야 한다.
    //
    else if ((DIVlevelCo == 1'b1) && (BlkCntEn == 1'b1) &&
             (BitCnt0 == 1'b1))
    begin
        NextDPSMState = `ST_DPSM_BLOCK_RECEIVE;
        LdBitCnt      = 1'b1;
        if ((BlkMode == 1'b0) && (BlkCnt7 == 1'b1))
        PendPulseSet = 1'b1;
    end
    
	default :
      NextDPSMState = `ST_DPSM_IDLE;
  endcase
end

// -----------------------------------------------------------------------------
// State transition process
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin 
  if (nRst == 1'b0)
    begin
      DPSMState		<= `ST_DPSM_IDLE;
      BlkCntEn		<= 1'b0;
      DATCRCRxEn	<= 1'b0;
      DATCRCTxEn	<= 1'b0;
      StopBit		<= 1'b0;
      StartBit		<= 1'b0;
      Wtoken		<= 1'b0;
      TxRdPtrInc	<= 1'b0;
      nDATEN		<= 1'b1;
      DATCRCTxSEn	<= 1'b0;
      BsyMode		<= 1'b0;
      TokenRxSEn	<= 1'b0;
      ShiftNotE		<= 1'b0;
	  TxActive		<= 1'b0;
	  RxActive		<= 1'b0;
    end
  else
    begin
		if (SDreset)
		begin
		DPSMState	<= `ST_DPSM_IDLE;
		BlkCntEn	<= 1'b0;
		DATCRCRxEn	<= 1'b0;
		DATCRCTxEn	<= 1'b0;
		StopBit		<= 1'b0;
		StartBit	<= 1'b0;
		Wtoken		<= 1'b0;
		TxRdPtrInc	<= 1'b0;
		nDATEN		<= 1'b1;
		DATCRCTxSEn	<= 1'b0;
		BsyMode		<= 1'b0;
		TokenRxSEn	<= 1'b0;
		ShiftNotE	<= 1'b0;
		TxActive	<= 1'b0;
		RxActive	<= 1'b0;
		end
		else
		begin
		DPSMState		<= NextDPSMState;
		BlkCntEn		<= NextBlkCntEn;
		DATCRCRxEn	<= NextDATCRCRxEn;
		DATCRCTxEn	<= NextDATCRCTxEn;
		StopBit		<= NextStopBit;
		StartBit		<= NextStartBit;
		Wtoken		<= NextWtoken;
		TxRdPtrInc	<= NextTxRdPtrInc;
		nDATEN		<= NextnDATEN;
		DATCRCTxSEn	<= NextDATCRCTxSEn;
		BsyMode		<= NextBsyMode;
		TokenRxSEn	<= NextTokenRxSEn;
		ShiftNotE		<= NextShiftNotE;
		RxActive		<= NextRxActive;
		TxActive		<= NextTxActive;
		end
	end
end 
reg	TxEmptyDetect;
always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
	TxEmptyDetect <= 1'b0;
	else
		begin
		if (SDreset)
			TxEmptyDetect <= 1'b0;
		else
			begin
			if (TFEmpty && WRDCnt0)
			TxEmptyDetect <= 1'b1;
			else if (~TFEmpty)
			TxEmptyDetect <= 1'b0;
			end
		end
end

wire	Empty4;
assign Empty4 = TxEmptyDetect && NibbleCnt0;
reg	TxEmptyDetect2;
always @(posedge MCLK or negedge nRst)
begin
    if (!nRst)
    TxEmptyDetect2<= 1'b0;
   // else if (TFEmpty && NibbleCnt0 && WRDCnt0)
	else
		begin
			if (SDreset)
		    TxEmptyDetect2<= 1'b0;	
			else if (TxEmptyDetect && NibbleCnt0)
		    TxEmptyDetect2 <= 1'b1;
		    else if (~TFEmpty)
			TxEmptyDetect2 <= 1'b0;
		end
end


reg	TxEmptyDetect3;
always @(posedge MCLK or negedge nRst)
begin
    if (!nRst)
    TxEmptyDetect3 <= 1'b0;
	else
		begin
			if (SDreset)
			TxEmptyDetect3 <= 1'b0;
		    else if (TFEmpty && BitCnt0 && WRDCnt0)
		    TxEmptyDetect3 <= 1'b1;
		    else if (~TFEmpty)
    		TxEmptyDetect3 <= 1'b0;
		end
end

// Clock Down Logic
// FIFO state 
always @(DPSMState or TFEmpty or RFFull or SD1bitMode or SD4bitMode or
		 MMCPlusMode or TxEmptyDetect or TxEmptyDetect2 or TxEmptyDetect3 or BlkCnt0)
begin
	if ((((DPSMState==`ST_DPSM_WAITS)|(DPSMState ==`ST_DPSM_STREAM_SEND)|
	(DPSMState == `ST_DPSM_BLOCK_SEND)) && ((TxEmptyDetect3&&SD1bitMode&&(BlkCnt0==1'b0))|
	(TxEmptyDetect2&&SD4bitMode && (BlkCnt0==1'b0))|(TxEmptyDetect&&MMCPlusMode&&(BlkCnt0==1'b0))))| 
	(((DPSMState == `ST_DPSM_WAITR)|(DPSMState == `ST_DPSM_BLOCK_RECEIVE)|
	(DPSMState == `ST_DPSM_STREAM_RECEIVE)) &&(RFFull == 1'b1)))
	ENCLK2 = 1'b0;
	else
	ENCLK2 = 1'b1;
end
// for Busy Check StateMachine
`define IDLEState 2'b00
`define BusyCheckState 2'b01
`define BusyState 2'b10




reg	[1:0]	BusyState;
reg	[1:0]	NextBusyState;
reg	[4:0]	NextBusyCnt;
reg	[4:0]	BusyCnt;
reg		NoBusySet;
reg		NextNoBusySet;
reg		BusyFinSet;
reg		NextBusyFinSet;

//reg		LdBusyCnt5;
reg		LdBusyCnt16;

wire	BusyCmdSent;
wire	BusyCnt1;
wire	BusyCnt0;
wire	BusyOut;

assign BusyCmdSent = CmdSentSet & BusyRsp;
assign BusyCnt1= (BusyCnt==3'b001) ?1'b1 :1'b0 ;
assign BusyCnt0= (BusyCnt==3'b000) ?1'b1 :1'b0 ;

reg DBusyOut;
assign BusyOut = (DPSMState == `ST_DPSM_BUSY)? 1'b1: 1'b0;

always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
	DBusyOut <= 1'b0;
	else
	begin
		if (SDreset)
		DBusyOut <=1'b0;
		else
		DBusyOut <= BusyOut;
	end
end

wire	BusyFinSet2;
assign 	BusyFinSet2 = ((BusyOut == 1'b0)&& (DBusyOut ==1'b1 )) ? 1'b1: 1'b0;
wire	DATIN0;
wire	DATIN1;
assign	DATIN0 = (DATIN[0]==1'b0)? 1'b1: 1'b0;
assign	DATIN1 = (DATIN[0]==1'b1)? 1'b1: 1'b0;

always @(BusyState or BusyCmdSent or DATIN0 or DATIN1 or BusyCnt1 or DIVlevelCo) 
begin
//	LdBusyCnt5=1'b0;
	LdBusyCnt16 = 1'b0;
	NextBusyFinSet= 1'b0;
	NextNoBusySet = 1'b0;
	case (BusyState)
	`IDLEState :
		if (BusyCmdSent)
		begin
			NextBusyState = `BusyCheckState;
//			LdBusyCnt5 = 1'b1;
			LdBusyCnt16 = 1'b1;
			NextBusyFinSet = 1'b0;
		end
		else
		begin
			NextBusyState = `IDLEState;
			NextBusyFinSet = 1'b0;
		end
	`BusyCheckState:	
		begin
		if ((DIVlevelCo== 1'b1) &&(DATIN1) && (BusyCnt1))
		begin
			NextBusyState = `IDLEState;
			NextNoBusySet = 1'b1;// Busy
		end
		else if ((DIVlevelCo == 1'b1) && (DATIN0))
		begin
			NextBusyState = `BusyState;
			NextNoBusySet = 1'b0;
			NextBusyFinSet = 1'b0;
		end
		else 
			NextBusyState = `BusyCheckState;
		end
	`BusyState:
		begin
		if ((DIVlevelCo == 1'b1)&&(DATIN1))
		begin
			NextBusyState = `IDLEState;
			NextBusyFinSet = 1'b1;
		end
		else
		begin
			NextBusyState = `BusyState;
			NextBusyFinSet = 1'b0;
		end
		end
	default : NextBusyState =`IDLEState;
	endcase
end

always @(BusyCnt /*or LdBusyCnt5*/  or LdBusyCnt16 or DIVlevelCo or BusyCnt0)
begin
/*	if (LdBusyCnt5 ==1'b1)
		NextBusyCnt = 5'b00101;
	else*/
	 if (LdBusyCnt16 == 1'b1)
		NextBusyCnt = 5'b10000;

	else if ((DIVlevelCo)&&(~BusyCnt0))
		NextBusyCnt = BusyCnt -1;
	else
		NextBusyCnt = BusyCnt;
end 

always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
	begin
		BusyState <= `IDLEState ;
		BusyCnt <= 1'b0;
		NoBusySet<= 1'b0;
		BusyFinSet <= 1'b0;
	end
	else
	begin
		if (SDreset)
			begin
			BusyState <= `IDLEState ;
			BusyCnt <= 1'b0;
			NoBusySet<= 1'b0;
			BusyFinSet <= 1'b0;
			end
		else
			begin
			BusyState <= NextBusyState;
			BusyCnt <= NextBusyCnt;
			NoBusySet<=NextNoBusySet;
			BusyFinSet <= NextBusyFinSet;
			end
	end
end


// synopsys translate_off

reg [8*10 : 1] CAState;

always @(DPSMState)
begin 
  if (DPSMState == `ST_DPSM_IDLE)
    CAState = "D_IDLE";
  else if (DPSMState == `ST_DPSM_WAITS)
    CAState = "D_WAITS";
  else if (DPSMState == `ST_DPSM_STREAM_SEND)
    CAState = "D_STREAMS";
  else if (DPSMState == `ST_DPSM_BLOCK_SEND)
    CAState = "D_BLOCKS";
  else if (DPSMState == `ST_DPSM_BUSY)
    CAState = "D_BUSY";
  else if (DPSMState == `ST_DPSM_WAITR)
    CAState = "D_WAITR";
  else if (DPSMState == `ST_DPSM_STREAM_RECEIVE)
    CAState = "D_STREAMR";
  else if (DPSMState == `ST_DPSM_BLOCK_RECEIVE)
    CAState = "D_BLOCKR";
  else if (DPSMState == `ST_DPSM_CONTINUE_SEND)
    CAState = "D_CONTS";
end

reg [8*10 : 1] NAState;

always @(NextDPSMState)
begin 
 if (NextDPSMState == `ST_DPSM_IDLE)
    NAState = "D_IDLE";
  else if (NextDPSMState == `ST_DPSM_WAITS)
    NAState = "D_WAITS";
  else if (NextDPSMState == `ST_DPSM_STREAM_SEND)
    NAState = "D_STREAMS";
  else if (NextDPSMState == `ST_DPSM_BLOCK_SEND)
    NAState = "D_BLOCKS";
  else if (NextDPSMState == `ST_DPSM_BUSY)
    NAState = "D_BUSY";
  else if (NextDPSMState == `ST_DPSM_WAITR)
    NAState = "D_WAITR";
  else if (NextDPSMState == `ST_DPSM_STREAM_RECEIVE)
    NAState = "D_STREAMR";
  else if (NextDPSMState == `ST_DPSM_BLOCK_RECEIVE)
    NAState = "D_BLOCKR";
  else if (NextDPSMState == `ST_DPSM_CONTINUE_SEND) 
    NAState = "D_CONTS";
end 
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// synopsys translate_on

endmodule

// --============================== End ======================================--



