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

`define ST_CPSM_IDLE            4'b0000
`define ST_CPSM_PEND            4'b0001
`define ST_CPSM_SEND            4'b0010
`define ST_CPSM_WAIT            4'b0100
`define ST_CPSM_RECEIVE         4'b1000
//`include "./mmcParams.v"

module mmc_CommandControl(
	nRst,
	SDreset,
	MCLK,
	DIVlevelCo,
	CMDIN,
	CMDOUT,
	nCMDEN,

	CPSMEn,

// register input
	SDICmdArg, 	// command argument
	NoCRCRsp,
	WithData,	// !!Present Not Support
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

// interrupt signal output	
);

//input
input		nRst;
input		SDreset;
input		MCLK;
input		DIVlevelCo;

input	[31:0]	SDICmdArg;
input		NoCRCRsp;
input		WithData;
input		LongRsp;
input		WaitRsp;
input		CMSTSync;
input 	[6:0] 	CmdIndex;
input		CPSMEn;



// Command line input / output
input		CMDIN;
output		CMDOUT;
output		nCMDEN;

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
reg	[31:0] CMDShift;
reg	[31:0] NextCMDShift;

// Command counter
reg	[7:0]	CMDCnt;
reg	[7:0]	NextCMDCnt;
reg		CMDLoad0;
reg		CMDLoad247;
reg		CMDLoad248;


reg		CMDTxShiftEn;
reg		CMDRxShiftEn;
reg		NextCMDTxShiftEn;
reg		NextCMDRxShiftEn;

// CRC shifter register
reg	[6:0]  	CMDCRCShift;
reg	[6:0]  	NextCMDCRCShift;
reg		CMDCRCTxEn;
reg		NextCMDCRCTxEn;
reg		CMDCRCRxEn; 
reg		NextCMDCRCRxEn;
reg		CRCDataIn;

// state machine signal
reg	[3:0]	CPSMState;
reg 	[3:0]	NextCPSMState;




reg	[7:0]	NextRspIndex;
reg	[31:0]	NextResponse0;
reg	[31:0]	NextResponse1;
reg	[31:0]	NextResponse2;
reg	[31:0]	NextResponse3;
reg	[7:0]	RspIndex;
reg	[31:0]	Response0;
reg	[31:0]	Response1;
reg	[31:0]	Response2;
reg	[31:0]	Response3;

reg		NextnIntCMDEN;
reg		nIntCMDEN;

reg		CmdOn;
reg		NextCmdOn;
reg		CmdOnSet;
reg		CmdOnClr;

reg		CRCCheck;

reg    	CmdSentSet;
reg		CmdToutSet;
reg		RspFinSet;

reg		LoadCmdRsp;
reg		LoadRsp0;
reg		LoadRsp1;
reg		LoadRsp2;
reg		LoadRsp3;

reg		CMSTClr;

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
assign CMDCnt0	= (CMDCnt == 8'b00000000) ? 1'b1 : 1'b0;

assign CMDCnt7	= (CMDCnt == 8'b00000111) ? 1'b1 : 1'b0;

assign CMDCnt39 = (CMDCnt == 8'b00100111) ? 1'b1 : 1'b0;

assign CMDCnt45 = (CMDCnt == 8'b00101101) ? 1'b1 : 1'b0;

assign CMDCnt46 = (CMDCnt == 8'b00101110) ? 1'b1 : 1'b0;

assign CMDCnt47 = (CMDCnt == 8'b00101111) ? 1'b1 : 1'b0;

assign CMDCnt63 = (CMDCnt == 8'b00111111) ? 1'b1 : 1'b0;

assign CMDCnt71 = (CMDCnt == 8'b01000111) ? 1'b1 : 1'b0;

assign CMDCnt103= (CMDCnt == 8'b01100111) ? 1'b1 : 1'b0;

assign CMDCnt133= (CMDCnt == 8'b10000101) ? 1'b1 : 1'b0;

assign CMDCnt134= (CMDCnt == 8'b10000110) ? 1'b1 : 1'b0;

assign CMDCnt255= (CMDCnt == 8'b11111111) ? 1'b1 : 1'b0; 

// Command Counter
always @(CMDCnt or DIVlevelCo or CMDCnt255 or CMDLoad0 or CMDLoad247 or
         CMDLoad248)
begin
  if (CMDLoad0 == 1'b1)
    NextCMDCnt = 8'b00000000;
  else if (CMDLoad247 == 1'b1)
    NextCMDCnt = 8'b11110111;
  else if (CMDLoad248 == 1'b1)
    NextCMDCnt = 8'b11111000;
  else if ((CMDCnt255 == 1'b0) && (DIVlevelCo == 1'b1))
    NextCMDCnt = (CMDCnt) + 1;
  else
    NextCMDCnt = CMDCnt;
end 

always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CMDCnt <= 8'b11110111;
  else
	begin
		if (SDreset)
		CMDCnt <= 8'b11110111;
		else
	    CMDCnt <= NextCMDCnt;
	end
end

//Command Shift register part
always @(CMDShift or NextCMDCRCShift or CMDTxShiftEn or CMDRxShiftEn or
         CMDCnt0 or CMDCnt7 or CMDCnt39 or CMDCnt46 or CMDIN or
         DIVlevelCo or CmdIndex or SDICmdArg)
begin 
  NextCMDShift = CMDShift;
  if (DIVlevelCo == 1'b1)
    begin
      if ((CMDTxShiftEn == 1'b1) && (CMDCnt0 == 1'b1))
        NextCMDShift[31:25] = CmdIndex[6:0];
      else if ((CMDTxShiftEn == 1'b1) && (CMDCnt7 == 1'b1))
	NextCMDShift[31:0] = SDICmdArg;
      else if ((CMDTxShiftEn == 1'b1) && (CMDCnt39 == 1'b1))
        NextCMDShift[31:25] = NextCMDCRCShift;
      else if ((CMDTxShiftEn == 1'b1) && (CMDCnt46 == 1'b1))
	NextCMDShift[31] = 1'b1;//end bit
      else if ((CMDTxShiftEn == 1'b1) || (CMDRxShiftEn == 1'b1))
        NextCMDShift[31:0] = {CMDShift[30:0], CMDIN};
      else
        NextCMDShift[31:0] = 32'd0;//{CmdIndex[7],31'd0};
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


//------------------------------------------------------------------------------
// CRC part
//------------------------------------------------------------------------------

always @(CMDCRCTxEn or CMDOUT or CMDIN)
begin
  if (CMDCRCTxEn == 1'b1)
    CRCDataIn = CMDOUT;
  else
    CRCDataIn = CMDIN;
end

// -----------------------------------------------------------------------------
// Combinational part of CRC generator.
// The CRC shift register should be loaded with zero if it is not
// active.
// -----------------------------------------------------------------------------
always @(CMDCRCShift or CMDCRCTxEn or CMDCRCRxEn or CRCDataIn or
         DIVlevelCo or NextCMDCRCRxEn)
begin
  NextCMDCRCShift = CMDCRCShift;
  if (DIVlevelCo == 1'b1)
  begin
    if ((CMDCRCTxEn == 1'b1) || (CMDCRCRxEn == 1'b1) || 
        (NextCMDCRCRxEn == 1'b1))
      begin
        NextCMDCRCShift[6:4] = CMDCRCShift[5:3];
        NextCMDCRCShift[3]   = CMDCRCShift[6] ^ CRCDataIn ^ CMDCRCShift[2];
        NextCMDCRCShift[2:1] = CMDCRCShift[1:0];
        NextCMDCRCShift[0]   = CMDCRCShift[6] ^ CRCDataIn;
      end
    else
        NextCMDCRCShift = 7'b0000000;
  end
end 

// -----------------------------------------------------------------------------
// Sequential part of CRC generator
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nRst)
begin
  if (nRst == 1'b0)
    CMDCRCShift <= 7'b0000000;
  else
	begin
		if (SDreset)
		CMDCRCShift <= 7'b0000000;
		else
	    CMDCRCShift <= NextCMDCRCShift;
	end
end


// -----------------------------------------------------------------------------
// Command StateMachine
// -----------------------------------------------------------------------------
always @(CPSMState or CMDRxShiftEn or CMDTxShiftEn or CMDCRCTxEn or CMDCRCRxEn or
	nIntCMDEN or CMSTSync or DIVlevelCo or WaitRsp or LongRsp or CPSMEn or 
	 CMDCnt7 or CMDCnt39 or CMDCnt46 or CMDCnt47 or CMDCnt45 or 
	 CMDCnt63 or CMDCnt71 or CMDCnt103 or CMDCnt133 or CMDCnt134 or CMDCnt255 or CMDIN)// or RspCrc)
begin

  // Default assignments
  NextCPSMState    = CPSMState;
  NextCMDRxShiftEn = CMDRxShiftEn;
  NextCMDTxShiftEn = CMDTxShiftEn;
  NextCMDCRCTxEn   = CMDCRCTxEn;
  NextCMDCRCRxEn   = CMDCRCRxEn;
  NextnIntCMDEN    = nIntCMDEN;
  CMDLoad0         = 1'b0;
  CMDLoad247       = 1'b0;
  CMDLoad248       = 1'b0;
  LoadCmdRsp       = 1'b0;
  LoadRsp0         = 1'b0;
  LoadRsp1         = 1'b0;
  LoadRsp2         = 1'b0;
  LoadRsp3         = 1'b0;
  CmdSentSet       = 1'b0;
  CmdToutSet       = 1'b0;
  RspFinSet        = 1'b0;
  CRCCheck         = 1'b0;
  CmdOnSet	   = 1'b0;
  CmdOnClr	   = 1'b0;
  CMSTClr	   = 1'b0;
  case (CPSMState)
  `ST_CPSM_IDLE :
// Nrc time count 필요
      if ((DIVlevelCo == 1'b1) && (CMSTSync == 1'b1))// command start?? 
        begin
          if (CMDCnt255 ==1'b1)
            begin
              NextCPSMState    = `ST_CPSM_SEND;
              NextCMDTxShiftEn = 1'b1;
              NextCMDCRCTxEn   = 1'b1;
              NextnIntCMDEN    = 1'b0;
              CMDLoad0         = 1'b1;
  	      CmdOnSet	       = 1'b1;
	      CMSTClr	       = 1'b1;
	      end
          else
            NextCPSMState = `ST_CPSM_IDLE;
        end

    `ST_CPSM_SEND :
      if (CPSMEn == 1'b0)
        begin
          NextCPSMState    = `ST_CPSM_IDLE;
          NextnIntCMDEN    = 1'b1;
          NextCMDTxShiftEn = 1'b0;
          NextCMDCRCTxEn   = 1'b0;
          CMDLoad247       = 1'b1;
	  CmdOnClr	   = 1'b1;
        end
      else if (DIVlevelCo == 1'b1)
        begin
	// 0~7 command index
	//	CRC module enable
	//	
	// 8~39 command argument
	// 40~46 crc7
	// 47 end bit 
	//  
	// CRC check is 0~39
	//
         if (CMDCnt39 == 1'b1)// CRC disable
          begin
            NextCMDCRCTxEn = 1'b0;
            NextCPSMState  = `ST_CPSM_SEND;
          end
       	 else if ((CMDCnt47 == 1'b1) && (WaitRsp == 1'b1))// response wait
          begin
            NextCPSMState    = `ST_CPSM_WAIT;
            NextnIntCMDEN    = 1'b1;
            NextCMDTxShiftEn = 1'b0;
            CMDLoad0         = 1'b1;
	    CmdSentSet       = 1'b1;
          end
       	 else if (CMDCnt47 == 1'b1)// no response type command
          begin
            NextCPSMState    = `ST_CPSM_IDLE;
            CMDLoad248       = 1'b1;
            CmdSentSet       = 1'b1;
            NextnIntCMDEN    = 1'b1;
            NextCMDTxShiftEn = 1'b0;
	    CmdOnClr	     = 1'b1;
          end
        end

    `ST_CPSM_WAIT :
      if (CPSMEn == 1'b0)
        begin
          NextCPSMState = `ST_CPSM_IDLE;
          CMDLoad247    = 1'b1;
          CmdOnClr	= 1'b1;

        end
      else if (DIVlevelCo == 1'b1)
        begin
          if ((CMDIN == 1'b0) && (LongRsp == 1'b0))// short response type
            begin
              NextCPSMState    = `ST_CPSM_RECEIVE;
              CMDLoad0         = 1'b1;
              NextCMDRxShiftEn = 1'b1;
              NextCMDCRCRxEn   = 1'b1; // R3의 응답은 crc check를 하지 않는다.. <- 추가해야됨
            end
          else if (CMDIN == 1'b0) // Long response type
            begin
              NextCPSMState    = `ST_CPSM_RECEIVE;
              CMDLoad0         = 1'b1;
              NextCMDRxShiftEn = 1'b1;
            end
          else if (CMDCnt63 == 1'b1)//timeout counter over... time out counter value is 64clk 
            begin
              NextCPSMState = `ST_CPSM_IDLE;
              CmdToutSet    = 1'b1;
              CMDLoad248    = 1'b1;
 	      CmdOnClr	    = 1'b1;
    	    end
        end

    `ST_CPSM_RECEIVE :

      if (CPSMEn == 1'b0)// || (RspCrc == 1'b1))
        begin
          NextCPSMState    = `ST_CPSM_IDLE;
          NextCMDRxShiftEn = 1'b0;
          NextCMDCRCRxEn   = 1'b0;
          CMDLoad247       = 1'b1;
        end
      else if (DIVlevelCo == 1'b1)
        begin
          if (CMDCnt7 == 1'b1)
            begin
              NextCPSMState  = `ST_CPSM_RECEIVE;
              LoadCmdRsp     = 1'b1;
              NextCMDCRCRxEn = 1'b1;// long response는 여기서부터 체크
            end
          else if (CMDCnt39 == 1'b1)
            begin
              NextCPSMState = `ST_CPSM_RECEIVE;
              LoadRsp0      = 1'b1;
            end
          else if ((CMDCnt45 == 1'b1) && (LongRsp == 1'b0))
            begin
              NextCPSMState  = `ST_CPSM_RECEIVE;
              CRCCheck       = 1'b1;
              NextCMDCRCRxEn = 1'b0;
            end
          else if ((CMDCnt46 == 1'b1) && (LongRsp == 1'b0)) 
            begin
              NextCPSMState    = `ST_CPSM_IDLE;
              NextCMDRxShiftEn = 1'b0;
              RspFinSet        = 1'b1;
              CMDLoad248       = 1'b1;
	      CmdOnClr	       = 1'b1;
            end
          else if (CMDCnt71 == 1'b1)
            begin
              NextCPSMState = `ST_CPSM_RECEIVE;
              LoadRsp1      = 1'b1;
            end
          else if (CMDCnt103 == 1'b1)
            begin
              NextCPSMState = `ST_CPSM_RECEIVE;
              LoadRsp2      = 1'b1;
            end
          else if (CMDCnt133 == 1'b1)
            begin
              NextCPSMState  = `ST_CPSM_RECEIVE;
              CRCCheck       = 1'b1;
              NextCMDCRCRxEn = 1'b0;
            end
          else if (CMDCnt134 == 1'b1)
            begin
              NextCPSMState    = `ST_CPSM_IDLE;
              NextCMDRxShiftEn = 1'b0;
              RspFinSet        = 1'b1;
              CMDLoad248       = 1'b1;
              LoadRsp3         = 1'b1;
	      CmdOnClr         = 1'b1;
            end
        end
    default :
      NextCPSMState = `ST_CPSM_IDLE;
  endcase
end

always @(posedge MCLK or negedge nRst)
begin 
  if (nRst == 1'b0)
    begin
      CPSMState    <= `ST_CPSM_IDLE;
      CMDRxShiftEn <= 1'b0; // RxShifter  enable
      CMDTxShiftEn <= 1'b0; // TxShifter enable
      CMDCRCTxEn   <= 1'b0; // Tx CRC enable
      CMDCRCRxEn   <= 1'b0; // Rx CRC enable
      nIntCMDEN    <= 1'b1;
    end
  else
    begin
		if (SDreset)
		begin
		CPSMState    <= `ST_CPSM_IDLE;
      	CMDRxShiftEn <= 1'b0; // RxShifter  enable
      	CMDTxShiftEn <= 1'b0; // TxShifter enable
      	CMDCRCTxEn   <= 1'b0; // Tx CRC enable
      	CMDCRCRxEn   <= 1'b0; // Rx CRC enable
      	nIntCMDEN    <= 1'b1;
		end
		else
		begin
		CPSMState    <= NextCPSMState;
		CMDRxShiftEn <= NextCMDRxShiftEn;
		CMDTxShiftEn <= NextCMDTxShiftEn;
		CMDCRCTxEn   <= NextCMDCRCTxEn;
		CMDCRCRxEn   <= NextCMDCRCRxEn;
		nIntCMDEN    <= NextnIntCMDEN;
	  	end
    end
end 

wire	nCMDEN;
wire	CRCErr;
wire	RspCrcSet;

// no sync signal 
assign nCMDEN = nIntCMDEN;

// for register output
// CRC Fail

assign CRCErr	 = (NextCMDCRCShift == 7'b0000000) ?
                          1'b0 : 1'b1;

assign RspCrcSet = CRCErr & CRCCheck & (~NoCRCRsp);


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

// -----------------------------------------------------------------------------
// Load the received response value into the command response register
// -----------------------------------------------------------------------------
always @(RspIndex or LoadCmdRsp or CMDShift)
begin 
  if (LoadCmdRsp == 1'b1)
    NextRspIndex = CMDShift[7:0];
  else
    NextRspIndex = RspIndex;
end 

// -----------------------------------------------------------------------------
// Sequential part of Command resonse register
// -----------------------------------------------------------------------------
always @(negedge nRst or posedge MCLK)
begin
  if (nRst == 1'b0)
    RspIndex <= 8'b00000000;
  else
	begin
	if (SDreset)
	RspIndex <= 8'b00000000;
	else
    RspIndex <= NextRspIndex;
	end
end 

// -----------------------------------------------------------------------------
//  Load the received response value into the Response0 register
// -----------------------------------------------------------------------------
always @(LoadRsp0 or Response0 or CMDShift)
begin
  if (LoadRsp0 == 1'b1)
    NextResponse0 = CMDShift[31:0];
  else
    NextResponse0 = Response0;
end 

// -----------------------------------------------------------------------------
// Sequential part of Response0
// -----------------------------------------------------------------------------
always @(negedge nRst or posedge MCLK)
begin 
  if (nRst == 1'b0)
    Response0 <= 32'h00000000;
  else
	begin
	if (SDreset)
	Response0 <= 32'h00000000;
	else
    Response0 <= NextResponse0;
	end
end

// -----------------------------------------------------------------------------
// Load the received response value into the Response1 register
// -----------------------------------------------------------------------------
always @(LoadRsp1 or LongRsp or Response1 or CMDShift)
begin 
  if ((LoadRsp1 == 1'b1) && (LongRsp == 1'b0))
    NextResponse1 = {CMDShift[6:0], 24'd0};
  else if ((LoadRsp1 == 1'b1)&& (LongRsp == 1'b1)) 
    NextResponse1 = CMDShift[31:0];
  else
    NextResponse1 = Response1;
end 

// -----------------------------------------------------------------------------
// Sequential part of Response1
// -----------------------------------------------------------------------------
always @(negedge nRst or posedge MCLK)
begin
  if (nRst == 1'b0)
    Response1 <= 32'h00000000;
  else
	begin
	if (SDreset)
	Response1 <= 32'h00000000;
	else
    Response1 <= NextResponse1;
	end
end

// -----------------------------------------------------------------------------
//  Load the received response value into the Response2 register
// -----------------------------------------------------------------------------
always @(LoadRsp2 or Response2 or CMDShift)
begin
  if (LoadRsp2 == 1'b1)
    NextResponse2 = CMDShift[31:0];
  else
    NextResponse2 = Response2;
end

// -----------------------------------------------------------------------------
// Sequential part of Response2
// -----------------------------------------------------------------------------
always @(negedge nRst or posedge MCLK)
begin
  if (nRst == 1'b0)
    Response2 <= 32'h00000000;
  else
	begin
	if (SDreset)
	Response2 <= 32'h00000000;
	else
    Response2 <= NextResponse2;
	end
end

// -----------------------------------------------------------------------------
//  Load the received response value into the Response3 register
// -----------------------------------------------------------------------------
always @(LoadRsp3 or Response3 or CMDShift)
begin
  if (LoadRsp3 == 1'b1)
    NextResponse3 = {CMDShift[30:0],1'b1};
  else
    NextResponse3 = Response3;
end

// -----------------------------------------------------------------------------
// Sequential part of Response3
// -----------------------------------------------------------------------------
always @(negedge nRst or posedge MCLK)
begin
  if (nRst == 1'b0)
    Response3 <= 32'h00000000;
  else
	begin
	if (SDreset)
	Response3 <= 32'h00000000;
	else
    Response3 <= NextResponse3;
	end
end

// synopsys translate_off

reg [8*10 : 1] CAState;

always @(CPSMState)
begin
  if (CPSMState == 3'b000)
    CAState = "C_IDLE";
  else if (CPSMState == 3'b001)
    CAState = "C_PEND";
  else if (CPSMState == 3'b010)
    CAState = "C_SEND";
  else if (CPSMState == 3'b011)
    CAState = "C_WAIT";
  else if (CPSMState == 3'b100)
    CAState = "C_RECEIVE";
end 

reg [8*10 : 1] NAState;

always @(NextCPSMState)
begin 
  if (NextCPSMState == 3'b000)
    NAState = "C_IDLE";
  else if (NextCPSMState == 3'b001)
    NAState = "C_PEND";
  else if (NextCPSMState == 3'b010)
    NAState = "C_SEND";
  else if (NextCPSMState == 3'b011)
    NAState = "C_WAIT";
  else if (NextCPSMState == 3'b100)
    NAState = "C_RECEIVE";
end
// synopsys translate_on
endmodule
