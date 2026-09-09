// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : mmc_CommandControl.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : command control state machine of mmc/sd 
//  =============================================================================
`timescale 1ns/1ps

`define CMD_IDLE        4'b0001
`define CMD_SEND        4'b0010
`define CMD_WAIT        4'b0100
`define CMD_RESPON	4'b1000

module mmc_CommandControl(
	nRst,
	SDreset,
	MCLK,
	neg_CKPulse,
	CKPulse,
	CMDIN,
	CMDOUT,
	Inv_CMDOUT,
	nCMDEN,
	Inv_nCMDEN,

// register input
	SDICmdArg, 	// command argument
	NoCRCRsp,
	//WithData,	// !!Present Not Support
	LongRsp,
	WaitRsp,
	CMSTSync,       // command start sync
	CMSTClr,	// to register... clear 
	CmdIndex,

// register set signal
	RspCrcSet,

// register output
	CmdSentSet,
	CmdToutSet,
	RspFinSet,
	CmdOn,
	RspIndex,
	Response0,
	Response1,
	Response2,
	Response3
);

//input
input		nRst;
input		SDreset;
input		MCLK;
input		neg_CKPulse;
input		CKPulse;

input	[31:0]	SDICmdArg;
input		NoCRCRsp;
//input		WithData;
input		LongRsp;
input		WaitRsp;
input		CMSTSync;
input 	[6:0] 	CmdIndex;

// Command line input / output
input		CMDIN;
output		CMDOUT;
output		Inv_CMDOUT;
output		nCMDEN;
output		Inv_nCMDEN;

//register output

output		RspCrcSet;
output		CmdSentSet;
output		CmdToutSet;
output		RspFinSet;
output		CmdOn;
output	[7:0]	RspIndex;
output	[31:0]	Response0;
output	[31:0]	Response1;
output	[31:0]	Response2;
output	[31:0]	Response3;
output		CMSTClr;

// Shifter register
reg	[31:0] 	CMDShift;
reg	[31:0] 	NextCMDShift;

// Command counter
reg	[7:0]	CMDCnt;

reg		CMDTxMode;
reg		CMDRxMode;

// CRC shifter register
reg	[6:0]  	CRCShift;
reg	[6:0]  	NextCRCShift;
reg		CRCTxMode;
reg		CRCRxMode; 
reg		NextCRCRxMode;
reg		CRCInput;

// state machine signal
reg	[3:0]	CMDState;
reg 	[3:0]	NextCMDState;

reg	[7:0]	RspIndex;
reg	[31:0]	Response0;
reg	[31:0]	Response1;
reg	[31:0]	Response2;
reg	[31:0]	Response3;

reg		CmdOn;
reg		NextCmdOn;

// counter value coincidence flag
wire	CMDCnt0;
wire	CMDCnt7;
wire	CMDCnt39;
wire	CMDCnt45;
wire	CMDCnt46;
wire	CMDCnt47;
wire	CMDCnt63;
wire	CMDCnt71;
wire	CMDCnt103;
wire	CMDCnt133;
wire	CMDCnt134;
wire	CMDCnt255;
assign	CMDCnt0	= (CMDCnt == 8'b00000000) ? 1'b1 : 1'b0;
assign 	CMDCnt7	= (CMDCnt == 8'b00000111) ? 1'b1 : 1'b0;
assign 	CMDCnt39 = (CMDCnt == 8'b00100111) ? 1'b1 : 1'b0;
assign 	CMDCnt45 = (CMDCnt == 8'b00101101) ? 1'b1 : 1'b0;
assign 	CMDCnt46 = (CMDCnt == 8'b00101110) ? 1'b1 : 1'b0;
assign 	CMDCnt47 = (CMDCnt == 8'b00101111) ? 1'b1 : 1'b0;
assign 	CMDCnt63 = (CMDCnt == 8'b00111111) ? 1'b1 : 1'b0;
assign 	CMDCnt71 = (CMDCnt == 8'b01000111) ? 1'b1 : 1'b0;
assign 	CMDCnt103= (CMDCnt == 8'b01100111) ? 1'b1 : 1'b0;
assign 	CMDCnt133= (CMDCnt == 8'b10000101) ? 1'b1 : 1'b0;
assign 	CMDCnt134= (CMDCnt == 8'b10000110) ? 1'b1 : 1'b0;
assign 	CMDCnt255= (CMDCnt == 8'b11111111) ? 1'b1 : 1'b0; 

wire	CCMDState0;
wire	CCMDState1;
wire	CCMDState2;
wire	CCMDState3;

assign 	CCMDState0 = CMDState[0];
assign 	CCMDState1 = CMDState[1];
assign 	CCMDState2 = CMDState[2];
assign 	CCMDState3 = CMDState[3];

wire	CmdSendStart;
wire	CmdSendEnd;
assign 	CmdSendStart = (CCMDState0 & CKPulse & CMSTSync & CMDCnt255);//Command Line Transmit
assign 	CmdSendEnd   = (CCMDState1 & CKPulse & CMDCnt47);// Command Trasmit 완료
wire 	RspRcvStart;
wire 	RspRcvEnd;
assign 	RspRcvStart = (CCMDState2 & CKPulse & (CMDIN==1'b0));// StartBit Detect
assign 	RspRcvEnd =  (CCMDState3 & CKPulse & ((CMDCnt46 & ~LongRsp) | CMDCnt134));//Receive Complete
assign	RspFinSet  = CCMDState3 & CKPulse & ((CMDCnt46&~LongRsp)|(CMDCnt134));
assign	CmdSentSet = CmdSendEnd;
assign  CMSTClr    = CmdSendStart;

wire	LdCnt0;
wire	LdCnt248;
// Command Counter
assign 	LdCnt0= (CmdSendStart|(CmdSendEnd & WaitRsp)|
		(CCMDState2&(CMDIN == 1'b0) & (CKPulse)));

assign 	LdCnt248=((CmdSendEnd & ~WaitRsp)|
		(CCMDState2 & CMDCnt63 & CKPulse)|
		(((CMDCnt46 & ~LongRsp)|(CMDCnt134&LongRsp)) & CCMDState3 & CKPulse));

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CMDCnt <= 8'b11110111;
  else
	begin
		if (SDreset)
			CMDCnt <= 8'b11110111;
		else if (CKPulse)
			begin
			if (LdCnt0)
    		CMDCnt <= 8'b00000000;
			else if (LdCnt248)
	    	CMDCnt <= 8'b11111000;
			else if (~CMDCnt255)
	   	CMDCnt <= (CMDCnt) + 1;
			else
	    	CMDCnt <= CMDCnt;
			end
	end		
end

//Command Shift register part
always @(CMDShift or NextCRCShift or CMDTxMode or CMDRxMode or
         CMDCnt0 or CMDCnt7 or CMDCnt39 or CMDCnt46 or CMDIN or
         CKPulse or CmdIndex or SDICmdArg)
begin 
  NextCMDShift = CMDShift;
  if (CKPulse == 1'b1)
    begin
      if ((CMDTxMode == 1'b1) && (CMDCnt0 == 1'b1))
        NextCMDShift[31:25] = CmdIndex[6:0];
      else if ((CMDTxMode == 1'b1) && (CMDCnt7 == 1'b1))
	NextCMDShift[31:0] = SDICmdArg;
      else if ((CMDTxMode == 1'b1) && (CMDCnt39 == 1'b1))
        NextCMDShift[31:25] = NextCRCShift;
      else if ((CMDTxMode == 1'b1) && (CMDCnt46 == 1'b1))
	NextCMDShift[31] = 1'b1;//end bit
      else if ((CMDTxMode == 1'b1) || (CMDRxMode == 1'b1))
        NextCMDShift[31:0] = {CMDShift[30:0], CMDIN};
      else
        NextCMDShift[31:0] = 32'd0;
    end
end 

always @(negedge nRst or posedge MCLK)
begin
	if (!nRst)
	CMDShift <= 32'd0;
	else
	begin
		if (SDreset)
		CMDShift <= 32'd0;
		else
		CMDShift <= NextCMDShift;
	end
end

// command output
assign CMDOUT = CMDShift[31];

always @(CRCTxMode or CMDOUT or CMDIN)
begin
  if (CRCTxMode == 1'b1)
    CRCInput = CMDOUT;
  else
    CRCInput = CMDIN;
end

// -----------------------------------------------------------------------------
always @(CRCShift or CRCTxMode or CRCRxMode or CRCInput or
         CKPulse or NextCRCRxMode)
begin
  NextCRCShift = CRCShift;
  if (CKPulse == 1'b1)
  begin
    if ((CRCTxMode == 1'b1) || (CRCRxMode == 1'b1) || 
        (NextCRCRxMode == 1'b1))
      begin
        NextCRCShift[6:4] = CRCShift[5:3];
        NextCRCShift[3]   = CRCShift[6] ^ CRCInput ^ CRCShift[2];
        NextCRCShift[2:1] = CRCShift[1:0];
        NextCRCShift[0]   = CRCShift[6] ^ CRCInput;
      end
    else
        NextCRCShift = 7'b0000000;
  end
end 

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CRCShift <= 7'b0000000;
  else
	begin
	if (SDreset)
	CRCShift <= 7'b0000000;
	else
	CRCShift <= NextCRCShift;
	end
end

//====================================================================
// Command Format
// 
// Start+ Command +Argument + CRC7 => 47bit  + EndBit

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CMDTxMode <= 1'b0;
  else
	begin
	if (SDreset)
    	CMDTxMode <= 1'b0;
	else if (CmdSendStart)
    	CMDTxMode <= 1'b1;
	else if (CmdSendEnd)
    	CMDTxMode <= 1'b0;
	end
end

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CMDRxMode <= 1'b0;
  else
	begin
	if (SDreset)
    	CMDRxMode <= 1'b0;
	else if (RspRcvStart)
    	CMDRxMode <= 1'b1;
	else if (RspRcvEnd)
    	CMDRxMode <= 1'b0;
	end
end

always @(CRCRxMode or RspRcvStart  or CCMDState3  or CMDCnt7 or CMDCnt45 or CMDCnt133 or CKPulse or LongRsp)
begin
  NextCRCRxMode   = CRCRxMode;
  if ((RspRcvStart&~LongRsp)|(CCMDState3&CKPulse&CMDCnt7))//CRC input start
	  NextCRCRxMode = 1'b1 ;
  else if ((CCMDState3&CKPulse&CMDCnt45&~LongRsp)|(CCMDState3&CKPulse&CMDCnt133))//CRC input end
	  NextCRCRxMode = 1'b0 ;
end
// -----------------------------------------------------------------------------
// Command StateMachine
// -----------------------------------------------------------------------------
always @(CMDState or CMSTSync or CKPulse or WaitRsp or LongRsp or 
	 CMDCnt7 or CMDCnt46 or CMDCnt47 or CMDCnt63 or CMDCnt134 or CMDCnt255 or CMDIN)
begin

  // Default assignments
  NextCMDState    = CMDState;
  
  case (CMDState)
  `CMD_IDLE :
// Nrc time count 필요
      if (CKPulse && CMSTSync)// command start?? 
        begin
          if (CMDCnt255)
            begin
              NextCMDState = `CMD_SEND;
	      end
          else
            NextCMDState = `CMD_IDLE;
        end

    `CMD_SEND :
      if (CKPulse)
        begin
       	 if (CMDCnt47 && WaitRsp)// response wait
          begin
            NextCMDState    = `CMD_WAIT;
          end
       	 else if (CMDCnt47)// no response type command
          begin
            NextCMDState    = `CMD_IDLE;
          end
        end

    `CMD_WAIT :
      if (CKPulse)
        begin
          if (CMDIN == 1'b0) // Long response type
            begin
              NextCMDState    = `CMD_RESPON;
            end
          else if (CMDCnt63)//timeout counter over... time out counter value is 64clk 
            begin
              NextCMDState = `CMD_IDLE;
    	    end
        end

    `CMD_RESPON :

      if (CKPulse)
        begin
          if ((CMDCnt46) && (LongRsp== 1'b0)) 
            begin
              NextCMDState    = `CMD_IDLE;
            end
          else if (CMDCnt134)
            begin
              NextCMDState    = `CMD_IDLE;
            end
        end
    default :
      NextCMDState = `CMD_IDLE;
  endcase
end

always @(posedge MCLK or negedge nRst)
begin 
  if (nRst == 1'b0)
    begin
      CMDState    <= `CMD_IDLE;
      CRCRxMode   <= 1'b0; // Rx CRC enable
    end
  else
    begin
		if (SDreset)
		begin
		CMDState    <= `CMD_IDLE;
	      	CRCRxMode   <= 1'b0; // Rx CRC enable
		end
		else
		begin
		CMDState    <= NextCMDState;
		CRCRxMode   <= NextCRCRxMode;
	  	end
    end
end 

always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
		CRCTxMode <= 1'b0;
	else
	begin
		if (SDreset)
		CRCTxMode <= 1'b0;
		else if (CmdSendStart)
		CRCTxMode <= 1'b1;
		else if (CCMDState1 & CKPulse & CMDCnt39)
		CRCTxMode <= 1'b0;
	end
end

reg nCMDEN ;
always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
		nCMDEN <= 1'b1;
	else
	begin
		if (SDreset)
		nCMDEN <= 1'b1;
		else if (CmdSendStart)
		nCMDEN <= 1'b0;
		else if (CmdSendEnd)
		nCMDEN <= 1'b1;
	end
end
//--------------------------------------------------------------
// output invert clock
reg	Inv_CMDOUT;
reg	Inv_nCMDEN;
always @(negedge nRst or posedge MCLK)
begin
if (!nRst)
    begin
    Inv_CMDOUT<= 1'b1;
    Inv_nCMDEN<= 1'b1;
    end
else if (neg_CKPulse)
    begin
    Inv_CMDOUT<= CMDOUT;
    Inv_nCMDEN<= nCMDEN;
    end
end


wire	CRCCheck;
wire	CRCErr;
wire	RspCrcSet;
wire	CmdOnSet;
wire	CmdOnClr;
wire	CmdToutSet;

assign CRCCheck = (CKPulse & CCMDState3)&((~LongRsp&CMDCnt45)|(CMDCnt133));
assign CRCErr	 = (NextCRCShift == 7'b0000000) ?
                          1'b0 : 1'b1;

assign RspCrcSet = CRCErr & CRCCheck & (~NoCRCRsp);

assign CmdOnSet =  (CCMDState0 & CKPulse & CMSTSync & CMDCnt255 );
assign CmdOnClr =  ((CCMDState1 & CKPulse & CMDCnt47 & ~WaitRsp) |
       		    (CCMDState2 & CKPulse & CMDCnt63) | 
		    (CCMDState3 & CKPulse & ((CMDCnt46 & ~LongRsp)|(CMDCnt134))));

assign CmdToutSet= CCMDState2 & CKPulse & CMDCnt63;

always @(CmdOnSet or CmdOnClr or CmdOn)
begin 
  if (CmdOnSet)
    NextCmdOn <= 1'b1;
  else if (CmdOnClr)
    NextCmdOn <= 1'b0;
  else 
    NextCmdOn <= CmdOn;
end

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CmdOn <= 1'b0;
  else
	begin
	if (SDreset)
	CmdOn <= 1'b0;
	else
    CmdOn <= NextCmdOn;
	end
end
//==================================================================
// Response0, Response1, Response2, Response3
//==================================================================
wire LoadRsp0;
assign LoadRsp0 = CCMDState3 & CMDCnt39 & CKPulse;

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
	Response0 <= 0;
	else
		if (SDreset)
			Response0 <= 0;
		else if (LoadRsp0)
			Response0 <= CMDShift[31:0];
end	  

wire LoadRsp1;
assign LoadRsp1 = CCMDState3 & CMDCnt71 & CKPulse;

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
	Response1 <= 0;
	else
		begin
		if (SDreset)
			Response1 <= 0;
		else if (LoadRsp1 & ~LongRsp)
			Response1 <= {CMDShift[6:0], 24'd0};
    	else if (LoadRsp1)
			Response1 <= CMDShift[31:0];
		end
end
wire LoadRsp2;
assign LoadRsp2 = CCMDState3 & CMDCnt103  & CKPulse;

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
	Response2 <= 0;
	else
		begin
		if (SDreset)
			Response2 <= 0;
		else if (LoadRsp2)
			Response2 <= CMDShift[31:0];
		end
end
wire	LoadRsp3;
assign LoadRsp3 = CCMDState3 & CMDCnt134 & CKPulse;

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
	Response3 <= 0;
	else
		begin
		if (SDreset)
			Response3 <= 0;
		else if (LoadRsp3)
			Response3 <= {CMDShift[30:0],1'b1};
		end
end

wire	LoadRspIndex;
assign LoadRspIndex = CCMDState3 & CMDCnt7 & CKPulse;

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
	RspIndex <= 0;
    else 
		begin
		if (SDreset)
		RspIndex <= 0;
		else if (LoadRspIndex)
		RspIndex <= CMDShift[7:0];
		end
end


endmodule


`define AUTO_RIDLE 	3'b001
//`define AUTO_RCMD17	4'b0010
`define AUTO_RCMD18	3'b010
`define AUTO_RCMD12	3'b100

module AUTORead (
	nRst,
	SDreset,
	MCLK,

	// Register input
	AutoReadEn,
	RCmdStart,
	RCmdStartClr,
	SingleMultiRead,
	
	Response0,
	
	NoBusySet,
	BusyFinSet,
	RspCrcSet,
	RspFinSet,
	CmdToutSet,
	DatCrcSet,
	DatFinSet,
	// for command control
	CmdArg,
	CmdIndex,
	CMSTSync,
	CMSTClr,
	NoCRCRsp,
        LongRsp,
        WaitRsp,

	// for Data register setting 
        BusyRsp, 
        AbortCmd, 

	// output
	CmdStartMuxO,
	CmdArgMuxO,
	CmdIndexMuxO,
	NoCRCRspMuxO,
	LongRspMuxO,
	WaitRspMuxO,
	BusyRspMuxO,
	AbortCmdMuxO,


	ResponseCMD18,
	AutoReadComplete,
	ErrorState
	);

input	nRst;
input	SDreset;
input	MCLK;

input	AutoReadEn;
input	RCmdStart;
output	RCmdStartClr;
input	SingleMultiRead;

input	[31:0] Response0;	
	

input	NoBusySet;
input	BusyFinSet;
input	RspCrcSet;
input	RspFinSet;
input	CmdToutSet;
input	DatCrcSet;
input	DatFinSet;

input	[31:0]	CmdArg;
input	[6:0]	CmdIndex;
input	CMSTSync;
input	CMSTClr;
input	NoCRCRsp;
input	LongRsp;
input	WaitRsp;

input	BusyRsp;
input	AbortCmd;

output	CmdStartMuxO;
output	[31:0]	CmdArgMuxO;
output	[6:0]	CmdIndexMuxO;

output	NoCRCRspMuxO;
output  LongRspMuxO;
output	WaitRspMuxO;
output	BusyRspMuxO;
output	AbortCmdMuxO;

output	[31:0] ResponseCMD18;
output	AutoReadComplete;
output	[1:0]	ErrorState;

// read command Sequence
// Single Block read 
// CMD17 -> command send check -> 
//
// Multiple Block read
// CMD18 (start address setting + data path setting)-> command send check
// ->response & data receive -> block transfer complete check -> 
// -> CMD12(stop command) -> end

reg 	[2:0]	C_AR_State;
reg 	[2:0]	N_AR_State;
reg		CmdStart;
reg	[31:0]	ACmdArg ;
reg	[6:0]	ACmdIndex;
reg		ANoCRCRsp;
reg		ALongRsp;
reg             AWaitRsp;
reg             ABusyRsp;
reg             AAbortCmd;

reg	[1:0]	Cnt;




wire	GoAUTO_RCMD12;
wire	GoAUTO_RCMD18;
wire	GoAUTO_RIDLE2;
wire	GoAUTO_RIDLE3;

assign 	GoAUTO_RCMD18 = (AutoReadEn)&(RCmdStart&&SingleMultiRead);// read command 전용레지스터 start bit
assign 	GoAUTO_RIDLE2 = (AutoReadEn)&(RspCrcSet|DatCrcSet|CmdToutSet);// data에서 crc error 발생시 
assign 	GoAUTO_RIDLE3 = (AutoReadEn)&(RspCrcSet|CmdToutSet|NoBusySet|BusyFinSet);// crc error 발생시 
assign 	GoAUTO_RCMD12 = (AutoReadEn)&DatFinSet;//

wire	Cnt0;
wire	Cnt1;
wire	Cnt3;
assign	Cnt0 = (Cnt==2'b00)? 1'b1: 1'b0;
assign	Cnt1 = (Cnt==2'b01)? 1'b1: 1'b0;
assign	Cnt3 = (Cnt==2'b11)? 1'b1: 1'b0;

assign RCmdStartClr = (C_AR_State== `AUTO_RCMD18);

always @(C_AR_State or AutoReadEn or GoAUTO_RCMD18 or 
	GoAUTO_RCMD12 or GoAUTO_RIDLE2 or GoAUTO_RIDLE3)
begin
	N_AR_State = C_AR_State;
	case (C_AR_State)
	`AUTO_RIDLE	:
		begin
	        if (~AutoReadEn)
                N_AR_State = `AUTO_RIDLE;
		else if (GoAUTO_RCMD18)
		N_AR_State = `AUTO_RCMD18;
		end
	`AUTO_RCMD18:// for multiple read
	        if (~AutoReadEn|GoAUTO_RIDLE2) // response time out or response
		N_AR_State = `AUTO_RIDLE;
		else if (GoAUTO_RCMD12)
		N_AR_State = `AUTO_RCMD12;
	`AUTO_RCMD12: // Stop Command
	        if (~AutoReadEn|GoAUTO_RIDLE3)
		N_AR_State = `AUTO_RIDLE;
	endcase
end

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
		begin	
		C_AR_State <= `AUTO_RIDLE;		
		end
	else 
		begin
		if (SDreset)
		C_AR_State <= `AUTO_RIDLE;
		else
		C_AR_State <= N_AR_State;
		end
end
//===================================================================
// State Output
//===================================================================
always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
		begin
		CmdStart <= 1'b0;
		end
	else
		begin
		if (SDreset)
		CmdStart <= 1'b0;
		else if (Cnt1&((C_AR_State==`AUTO_RCMD18)|(C_AR_State==`AUTO_RCMD12)))
		CmdStart <= 1'b1;
		else if (CMSTClr)
		CmdStart <= 1'b0;
		end
end

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
		begin
		ACmdArg   <= 0;
		ACmdIndex <= 0;
		ANoCRCRsp <= 0;
		ALongRsp  <= 0;
		AWaitRsp  <= 0;
		ABusyRsp  <= 0;
		AAbortCmd <= 0;
		end
	else
		begin
		if (SDreset)
			begin
			ACmdArg   <= 0;
			ACmdIndex <= 0;
			ANoCRCRsp <= 0;
	                ALongRsp  <= 0;
        	        AWaitRsp  <= 0;
                	ABusyRsp  <= 0;
	                AAbortCmd <= 0;
			end
		else if (Cnt0&(C_AR_State==`AUTO_RCMD18))
			begin
			ACmdArg   <= CmdArg;
			ACmdIndex <= 7'b1010010;
			ANoCRCRsp <= 1'b0;
	                ALongRsp  <= 1'b0;
        	        AWaitRsp  <= 1'b1;
                        ABusyRsp  <= 0;
                        AAbortCmd <= 0;
			end
		else if (Cnt0&(C_AR_State==`AUTO_RCMD12))
			begin
			ACmdArg   <= 0;
			ACmdIndex <= 7'b1001100;
			ANoCRCRsp <= 1'b0;
	                ALongRsp  <= 1'b0;
        	        AWaitRsp  <= 1'b1;
                        ABusyRsp  <= 1;
                        AAbortCmd <= 1;
			end
		end
end

always @(posedge MCLK or negedge nRst)
begin
	if (nRst == 1'b0)
		begin
		Cnt <= 0;
		end
	else
		begin
		if (SDreset)
		Cnt <= 0;
		else if ((C_AR_State == `AUTO_RIDLE)|((C_AR_State == `AUTO_RCMD18)&&(GoAUTO_RCMD12)))
		Cnt <= 0;	
		else if (~Cnt3)
		Cnt <= Cnt + 1;
		end
end

// Register input Value Mux
wire		CmdStartMuxO;
wire	[31:0]	CmdArgMuxO;
wire	[6:0]	CmdIndexMuxO;
assign 	CmdStartMuxO	= (AutoReadEn)? CmdStart : CMSTSync;
assign  CmdArgMuxO  	= (AutoReadEn)? ACmdArg : CmdArg;
assign  CmdIndexMuxO	= (AutoReadEn)? ACmdIndex : CmdIndex;

wire	NoCRCRspMuxO;
wire	LongRspMuxO;
wire	WaitRspMuxO;
wire	BusyRspMuxO;
wire	AbortCmdMuxO;

assign  NoCRCRspMuxO	= (AutoReadEn)? ANoCRCRsp : NoCRCRsp;
assign  LongRspMuxO	= (AutoReadEn)? ALongRsp : LongRsp;
assign  WaitRspMuxO	= (AutoReadEn)? AWaitRsp : WaitRsp;
assign  BusyRspMuxO	= (AutoReadEn)? ABusyRsp : BusyRsp;
assign  AbortCmdMuxO	= (AutoReadEn)? AAbortCmd : AbortCmd;


// Response to CMD18
wire	[31:0]	NextResponseCMD18;
reg	[31:0]	ResponseCMD18;
assign 	NextResponseCMD18 = (AutoReadEn&(C_AR_State == `AUTO_RCMD18) && RspFinSet)?Response0:ResponseCMD18 ;
always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
	ResponseCMD18 <= 32'd0;
	else
		if (SDreset)
		ResponseCMD18	<= 32'd0;
		else
		ResponseCMD18 <= NextResponseCMD18;
end

// ErrorState 
// ErrorState[0] is status bit about CMD18
// ErrorState[1] is status bit about CMD12
wire	[1:0]	ErrorState;
assign ErrorState[0] = ((C_AR_State == `AUTO_RCMD18)&&(RspCrcSet|DatCrcSet|CmdToutSet));
assign ErrorState[1] = ((C_AR_State == `AUTO_RCMD12)&&(RspCrcSet|CmdToutSet));

wire	AutoReadComplete;
assign	AutoReadComplete = ((C_AR_State == `AUTO_RCMD12)&&(~RspCrcSet)&&(NoBusySet|BusyFinSet));

endmodule
