`timescale 1ns/1ps

module PMCtl (
   				UExtClk,
   				ExtClk,
   				ExtResetb,
   				TestMode,
   				ARESETB,

// WakeUp Logic Interface
   				EINT,
   				EIntLvl,
   				EIntPol,
   				EIntMsk,

				LCDPDIV,
				VideoSyncEn,
				VideoBPAck,
				VidClk,

// System Clock
   				CpuClkOut,
   				SysClkOut,
   				PeriClkOut,
   				PeriClk2xOut,
				GDMAClkOut,
				DMAClkOut,
				DMClkOut,
				VIFClkOut,
				VidClkOut,
				NANDClkOut,
				DDRClk1xOut, DDRClk2xOut, nDDRClk1xOut, nDDRClk2xOut,
   				SEIPClkOut,
   				UsbClkOut,
   				LcdClkOut,
   
// POC Interface
   				CfgIn,
   				CfgEnb,
   				PocResetb,

// PLL Interface
				tPMSlow,
				MPllPD,
				MPllFR,
				MPllODR,
				MPllRR,
				
				MPllClk,
				
// Register Interface
				PCLK,
				PRESETB,
    			PSEL, 
    			PENABLE, 
    			PADDR, 
    			PWRITE, 
    			PWDATA, 
				PRDATA
);

input			UExtClk;		//External USB Clock
input         	ExtClk;			//External Clock
input			ExtResetb;		//External Reset#
input         	TestMode;
input			ARESETB;
input 	[7:0]   EINT;     		//External Interrupt
input  	[7:0]  	EIntLvl;
input  	[7:0]  	EIntPol;
input  	[7:0]  	EIntMsk;
input	[2:0]	LCDPDIV;
input			VideoSyncEn;
input			VideoBPAck;
input			VidClk;

output        	CpuClkOut;     	//ARM Clock, MCLK
output        	SysClkOut;     	//System Clock, ACLK
output        	PeriClkOut;    	//Peri. Clock, PCLK
output        	PeriClk2xOut;   //Peri. Clock, PCLK
output			GDMAClkOut;
output			DMAClkOut;
output			DMClkOut;
output			VIFClkOut;
output			VidClkOut;
output			NANDClkOut;
output			DDRClk1xOut, DDRClk2xOut, nDDRClk1xOut, nDDRClk2xOut;
output			SEIPClkOut;	
output			UsbClkOut;
output			LcdClkOut;	// Video/LCD Clock

input	[0:0]	CfgIn;
output			CfgEnb;
output			PocResetb;

output			tPMSlow;
output 			MPllPD;
output  [7:0] 	MPllFR;
output  [4:0] 	MPllRR;
output  [1:0] 	MPllODR;

input			MPllClk;

input         	PCLK;
input         	PRESETB;
input  [ 7:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;
//------------------------------------------------------------------
parameter PM_POC  = 6'b000001;
parameter PM_SLOW = 6'b000010;
parameter PM_LOCK = 6'b000100;
parameter PM_NORM = 6'b001000;
parameter PM_IDLE = 6'b010000;
parameter PM_PWDN = 6'b100000;

reg [5:0]  CurStPM, NxtStPM;

wire  tPMPoc  = CurStPM[0];
wire  tPMSlow = CurStPM[1];
wire  tPMLock = CurStPM[2];
wire  tPMNorm = CurStPM[3];
wire  tPMIdle = CurStPM[4];
wire  tPMPwdn = CurStPM[5];

reg	 [31:0] PRDATA;

wire		PllLocked;
//------------------------------------------------------------------
// APB Register Interface
wire RegWr   =  PWRITE;
wire RegRd   = ~PWRITE;
wire RegSel  =  PSEL & ~PENABLE;

wire Reg0Sel = RegSel & (PADDR == 6'h00);
wire Reg1Sel = RegSel & (PADDR == 6'h01);
wire Reg2Sel = RegSel & (PADDR == 6'h02);
wire Reg3Sel = RegSel & (PADDR == 6'h03);
wire Reg0Wr  = Reg0Sel & RegWr;
wire Reg1Wr  = Reg1Sel & RegWr;
wire Reg2Wr  = Reg2Sel & RegWr;
wire Reg3Wr  = Reg3Sel & RegWr;
wire Reg0Rd  = Reg0Sel & RegRd;
wire Reg1Rd  = Reg1Sel & RegRd;
wire Reg2Rd  = Reg2Sel & RegRd;
wire Reg3Rd  = Reg3Sel & RegRd;

// Clock Control Register
reg	CpuIdleEnR;
reg	SlowEnR;
reg PwdnEnR;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	CpuIdleEnR <= 1'b0;
	else if (Reg0Wr) 	CpuIdleEnR <= PWDATA[2];

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB)	SlowEnR <= 1'b0;
	else if (Reg0Wr) 	SlowEnR <= PWDATA[1];

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB)	PwdnEnR <= 1'b0;
	else if (Reg0Wr) 	PwdnEnR <= PWDATA[0];

reg GDMAClkEn;	// Graphic DMA Clock Enable
reg DMAClkEn;	// General DMA Clock Enable
reg DMClkEn;	// Display Module Clock Enable
reg VIFClkEn;	// Video Interface Module Clock Enable
reg DDRClkEn;	// DDR Controller Clock Enable
reg NANDClkEn;	// NAND Controller Clock Enable
reg USBClkEn;	// USB Clock Enable
reg SEIPClkEn;	// SEIP Clock Enable
reg PeriClkEn;	// Peri. Clock Enable except USB, SEIP

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) begin
			GDMAClkEn 	<= 1'b0;
			DMAClkEn 	<= 1'b0;
			DMClkEn 	<= 1'b0;
			VIFClkEn 	<= 1'b0;
			DDRClkEn 	<= 1'b1;
			NANDClkEn 	<= 1'b1;
			USBClkEn 	<= 1'b0;
			SEIPClkEn 	<= 1'b0;
			PeriClkEn 	<= 1'b0;
	end
	else if (Reg0Wr) begin
			GDMAClkEn 	<= PWDATA[8];
			DMAClkEn 	<= PWDATA[9];
			DMClkEn 	<= PWDATA[10];
			VIFClkEn 	<= PWDATA[11];
			DDRClkEn 	<= PWDATA[12];
			NANDClkEn 	<= PWDATA[13];
			USBClkEn 	<= PWDATA[16];
			SEIPClkEn 	<= PWDATA[17];
			PeriClkEn 	<= PWDATA[18];
	end

// Clock Divide Register
reg [1:0] UClkDiv;	// USB Clock Divide
reg		  PClkDiv;	// Peri. Clock Divide
reg [2:0] SClkDiv;	// System Clock Clock Divide

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		UClkDiv		<= 2'b0;
		PClkDiv		<= 1'b1;
		SClkDiv  	<= 3'b000;
	end
	else if (Reg1Wr) begin
		UClkDiv		<= PWDATA[7:6];
	    PClkDiv  	<= PWDATA[3];
	    SClkDiv		<= PWDATA[2:0];
	end

// Lock Time Control Register
reg			MPllWrEn;
reg [15:0] 	WaitLockCntR;
reg [15:0] 	WaitLockCnt;

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	MPllWrEn <= 1'b0;
	else if (Reg2Wr) 	MPllWrEn <= PWDATA[31];

always @(negedge PRESETB or posedge PCLK)
	if 		(!PRESETB) 	WaitLockCntR <= 16'hffff;
	else if (Reg2Wr) 	WaitLockCntR <= PWDATA[15:0];

// PLL Register
reg 		MPllPD;
reg  [7:0] 	MPllFR;
reg  [4:0] 	MPllRR; // Input Divisor
reg  [1:0] 	MPllODR; // Output Divisor

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		MPllPD	<= 1'b0;
		
	end
	else if (Reg3Wr) begin
		MPllPD	<= PWDATA[16];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		MPllFR	<= 8'd20;//33;
		MPllRR	<= 5'd3;//9;
		MPllODR	<= 2'd1;
		
	end
	else if (Reg3Wr & MPllWrEn) begin
		MPllFR	<= PWDATA[15:8];
		MPllRR	<= PWDATA[7:3];
		MPllODR	<= PWDATA[1:0];
	end

wire [31:0] Reg0Data = {21'b0, PeriClkEn, SEIPClkEn, USBClkEn,
						2'b0, NANDClkEn, DDRClkEn, VIFClkEn, DMClkEn, DMAClkEn, GDMAClkEn, 
						2'b0, tPMPoc, tPMLock, tPMNorm, tPMIdle, tPMSlow, tPMPwdn};
wire [31:0] Reg1Data = {24'b0, UClkDiv, 2'b0, PClkDiv, SClkDiv};
wire [31:0]	Reg2Data = {MPllWrEn, 14'b0, PllLocked, WaitLockCnt};
wire [31:0]	Reg3Data = {15'b0, MPllPD, MPllFR, MPllRR, 1'b0, MPllODR};

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)	PRDATA <= 32'b0;
	else begin
		case(1'b1) // synopsys parallel_case
    	  Reg0Rd  : PRDATA <= Reg0Data;
    	  Reg1Rd  : PRDATA <= Reg1Data;
    	  Reg2Rd  : PRDATA <= Reg2Data;
    	  Reg3Rd  : PRDATA <= Reg3Data;
    	  default : PRDATA <= 32'b0;
    	endcase
    end
//------------------------------------------------------------------
wire [7:0] IntSrc_polarity_adjusted;
wire [7:0] edge_detected;
wire [7:0] IntPend;

reg  [7:0] IntSrc_ff;
reg  [7:0] IntSrc_temp;

always @(negedge ExtResetb or posedge ExtClk)
begin
       if(!ExtResetb) begin
             IntSrc_ff   <= 8'h00;
             IntSrc_temp <= 8'h00;
       end
       else begin
             IntSrc_ff   <= EINT[7:0];
             IntSrc_temp <= IntSrc_polarity_adjusted;
       end
end

assign IntSrc_polarity_adjusted = EIntPol[7:0]^IntSrc_ff;
assign edge_detected = (~IntSrc_temp)&IntSrc_polarity_adjusted;
assign IntPend = (EIntLvl & IntSrc_polarity_adjusted) | ((~EIntLvl) & edge_detected);

wire ExtInt = ((IntPend & ~EIntMsk) != 8'h00);
 
reg IntRst1d;
reg IntRst2d;

always @(negedge ExtResetb or posedge ExtClk)
	if (!ExtResetb) begin
	    IntRst1d  <= 1'b0;
	    IntRst2d  <= 1'b0;
	end
	else begin
	    IntRst1d  <= ExtInt;
	    IntRst2d  <= IntRst1d;
	end 

wire WakeUp;
wire CpuWakeUp = WakeUp;// | ;
assign WakeUp = IntRst1d && ~IntRst2d;

reg SlowEnR0d;
reg SlowEnR1d;
reg SlowEnR2d;

always @(negedge ExtResetb or posedge ExtClk)
	if (!ExtResetb) begin
	    SlowEnR0d  <= 1'b0;
	    SlowEnR1d  <= 1'b0;
	    SlowEnR2d  <= 1'b0;
	end
	else begin
	    SlowEnR0d  <= SlowEnR;
	    SlowEnR1d  <= SlowEnR0d;
	    SlowEnR2d  <= SlowEnR1d;
	end

wire SlowEn = SlowEnR1d & ~SlowEnR2d;

reg SlowDisR0d;
reg SlowDisR1d;
reg SlowDisR2d;

always @(negedge ExtResetb or posedge ExtClk)
	if (!ExtResetb) begin
	    SlowDisR0d  <= 1'b0;
	    SlowDisR1d  <= 1'b0;
	    SlowDisR2d  <= 1'b0;
	end
	else begin
	    SlowDisR0d  <= ~SlowEnR;
	    SlowDisR1d  <= SlowDisR0d;
	    SlowDisR2d  <= SlowDisR1d;
	end

wire SlowDis = SlowDisR1d & ~SlowDisR2d;

reg PwdnEnR0d;
reg PwdnEnR1d;
reg PwdnEnR2d;

always @(negedge ExtResetb or posedge ExtClk)
	if (!ExtResetb) begin
	    PwdnEnR0d  <= 1'b0;
	    PwdnEnR1d  <= 1'b0;
	    PwdnEnR2d  <= 1'b0;
	end
	else begin
	    PwdnEnR0d  <= PwdnEnR;
	    PwdnEnR1d  <= PwdnEnR0d;
	    PwdnEnR2d  <= PwdnEnR1d;
	end

wire PwdnEn = PwdnEnR1d & ~PwdnEnR2d;

reg CpuIdleEnR0d;
reg CpuIdleEnR1d;
reg CpuIdleEnR2d;

always @(negedge ExtResetb or posedge ExtClk)
	if (!ExtResetb) begin
	    CpuIdleEnR0d  <= 1'b0;
	    CpuIdleEnR1d  <= 1'b0;
	    CpuIdleEnR2d  <= 1'b0;
	end
	else begin
	    CpuIdleEnR0d  <= CpuIdleEnR;
	    CpuIdleEnR1d  <= CpuIdleEnR0d;
	    CpuIdleEnR2d  <= CpuIdleEnR1d;
	end

wire CpuIdleEn = CpuIdleEnR1d & ~CpuIdleEnR2d;

// Power On Configuration
reg [3:0] PocCnt;
wire PocEnd = (PocCnt == 0);
always @ (negedge ExtResetb or posedge ExtClk)
  	if 		(!ExtResetb) PocCnt <= 4'hf;
  	else if (tPMPoc)     PocCnt <= PocCnt - 1;

// PLL Lock Wait Count
reg MPllWrEnM0, MPllWrEnM;	// Meta. FF
always @ (negedge ExtResetb or posedge ExtClk)
  	if 		(!ExtResetb) begin
			MPllWrEnM0 <= 1'b0;
			MPllWrEnM  <= 1'b0;
	end
	else begin
			MPllWrEnM0 <= MPllWrEn;
			MPllWrEnM  <= MPllWrEnM0;
	end

reg LockCntUpEnR1d;
reg LockCntUpEnR2d;

always @(negedge ExtResetb or posedge ExtClk)
	if (!ExtResetb) begin
	    LockCntUpEnR1d  <= 1'b0;
	    LockCntUpEnR2d  <= 1'b0;
	end
	else begin
	    LockCntUpEnR1d  <= MPllWrEnM;
	    LockCntUpEnR2d  <= LockCntUpEnR1d;
	end

//					PLL Register Update				or	SLOW to NORMAL
wire LockCntUpEn = (LockCntUpEnR1d & ~LockCntUpEnR2d) | SlowDis | PocEnd;

reg [15:0] WaitLockCntM0, WaitLockCntM;	// Meta. FF
always @ (negedge ExtResetb or posedge ExtClk)
  	if 		(!ExtResetb) begin
			WaitLockCntM0 <= 16'hFfff;
			WaitLockCntM  <= 16'hFfff;
	end
	else begin
			WaitLockCntM0 <= WaitLockCntR;
			WaitLockCntM  <= WaitLockCntM0;
	end

always @ (negedge ExtResetb or posedge ExtClk)
  	if 		(!ExtResetb) 	WaitLockCnt <= 16'h1fff;
  	else if (LockCntUpEn) 	WaitLockCnt <= WaitLockCntM;
  	else if (tPMLock)		WaitLockCnt <= WaitLockCnt - 1;

assign PllLocked = (WaitLockCnt == 0);
//------------------------------------------------------------------
// Power ManageMent Control State Machine
always @ (negedge ExtResetb or posedge ExtClk)
  	if (!ExtResetb) CurStPM <= PM_POC;
  	else         	CurStPM <= NxtStPM;

always @(tPMPoc or tPMLock or tPMNorm or tPMIdle or tPMSlow or tPMPwdn or 
		 PocEnd or PllLocked or LockCntUpEn or
		 SlowEn or CpuWakeUp or PwdnEn or CpuIdleEn or WakeUp) 
begin
  	NxtStPM = PM_POC;
  	case(1'b1)	// synopsys parallel_case
  		tPMPoc 	:	if (PocEnd|SlowEn)	NxtStPM = PM_SLOW;
  					else				NxtStPM = PM_POC;

  	  	tPMSlow  : 	if (LockCntUpEn)    NxtStPM = PM_LOCK;
  	  	          	else        		NxtStPM = PM_SLOW;

  		tPMLock	:	if (PllLocked)		NxtStPM = PM_NORM;
  					else				NxtStPM = PM_LOCK;

  	  	tPMNorm	: 	if 		(SlowEn)	NxtStPM = PM_SLOW;	// Operate External Slow Clock
  	  	          	else if (CpuIdleEn)	NxtStPM = PM_IDLE;	// Cpu Idle
  	  	          	else if (PwdnEn)	NxtStPM = PM_PWDN;	// All Chip Killed Except Wake Up Logic
  	  	          	else        		NxtStPM = PM_NORM;

  	  	tPMIdle  : 	if (CpuWakeUp)		NxtStPM = PM_NORM;
  	  	          	else        		NxtStPM = PM_IDLE;

  	  	tPMPwdn	 : 	if (WakeUp) 		NxtStPM = PM_NORM;
  	  	          	else        		NxtStPM = PM_PWDN;

  	  	default :               		NxtStPM = PM_NORM;
  	endcase
end

// Poc Latch
reg PocCfg;
always @(posedge ExtClk) if (tPMPoc) PocCfg <= CfgIn;

assign CfgEnb    =  tPMPoc;
assign PocResetb = ~tPMPoc;

wire WaitLock = (tPMPoc | tPMSlow | tPMLock);	// Operate External Clock
//------------------------------------------------------------------
// Clock Mux
wire MSrcClk = TestMode | WaitLock ? ExtClk : MPllClk;
//------------------------------------------------------------------
// Clock Divide
// System Clock Divider
reg [5:0] SClkDivCnt ;
always @ (negedge ExtResetb or posedge MSrcClk)
   if (!ExtResetb) SClkDivCnt <= {5{1'b0}};
   else            SClkDivCnt <= SClkDivCnt + 1'b1;

wire SClkDiv3;
PMCKD #(3,4,1) ClkDiv3 (
			.OutClk      	(SClkDiv3),
			.Clk         	(MSrcClk),
			.nReset      	(ExtResetb),
			.ScanClock   	(ExtClk),
			.ScanTestMode	(TestMode)
);

wire SClkDiv6Src = SClkDiv3;

reg SClkDiv6;
always @ (negedge ExtResetb or posedge SClkDiv6Src)
   if (!ExtResetb) SClkDiv6 <= 1'b0;
   else            SClkDiv6 <= SClkDiv6 + 1'b1;

wire SClkDiv12Src = TestMode ? ExtClk : SClkDiv6;

reg SClkDiv12;
always @ (negedge ExtResetb or posedge SClkDiv12Src)
   if (!ExtResetb) SClkDiv12 <= 1'b0;
   else            SClkDiv12 <= SClkDiv12 + 1'b1;

reg SysClkDiv;
always @ (SClkDiv or MSrcClk or SClkDivCnt or SClkDiv3 or SClkDiv6)
  case (SClkDiv)	// synopsys_parallel_case
   	3'b000  : SysClkDiv = MSrcClk;			// Bypass
   	3'b001  : SysClkDiv = SClkDivCnt[0]; 	// 1/2
   	3'b010  : SysClkDiv = SClkDiv3;			// 1/3
   	3'b011  : SysClkDiv = SClkDivCnt[1];	// 1/4
   	3'b100  : SysClkDiv = SClkDiv6;			// 1/6
   	default : SysClkDiv = SClkDivCnt[2];	// 1/8
  endcase

wire SysClk2x;
PMGFr SCKGtFree(
//			.TestMode	(TestMode),
//			.TestClk 	(ExtClk),
			.i_HCLK		(MSrcClk),
			.i_LCLK		(SysClkDiv),
			.i_RSTB		(ExtResetb),
			.i_SEL 		(|SClkDiv),
			.o_CLK 		(SysClk2x)
);

reg SysClk;
always @ (negedge ExtResetb or posedge SysClk2x)
   if (!ExtResetb) SysClk <= 1'b0;
   else            SysClk <= SysClk + 1'b1;

// Peri. Clock Divide
reg PeriClk2;
always @ (negedge ExtResetb or posedge SysClkOut)
   if (!ExtResetb) 	PeriClk2 <= 1'b0;
   else          	PeriClk2 <= PeriClk2 + 1'b1;

wire PeriClk = PClkDiv ? PeriClk2 : SysClkOut;

// USB Clock Div.
wire USrcClk = TestMode ? ExtClk : UExtClk;

reg [2:0] UClkDivCnt;
always @ (negedge PRESETB or posedge PeriClkOut)
   if (!PRESETB) UClkDivCnt <= {3{1'b0}};
   else          UClkDivCnt <= UClkDivCnt + 1'b1;

reg LcdClkDiv;
always @ (LCDPDIV or ExtClk or SClkDivCnt or SClkDiv6 or SClkDiv12)
  case (LCDPDIV)	// synopsys_parallel_case
   	3'b000  : LcdClkDiv = SClkDivCnt[0]; 	// Bypass System Clock 
   	3'b001  : LcdClkDiv = SClkDivCnt[1];	// 1/2
   	3'b010  : LcdClkDiv = SClkDiv6;			// 1/3
   	3'b011  : LcdClkDiv = SClkDivCnt[2];	// 1/4
   	3'b100  : LcdClkDiv = SClkDiv12;		// 1/6
   	3'b101  : LcdClkDiv = SClkDivCnt[3];	// 1/8
   	3'b110  : LcdClkDiv = SClkDivCnt[4];	// 1/16
   	3'b111  : LcdClkDiv = SClkDivCnt[5];	// 1/32
  endcase

										// VCLK or Bypass System Clock
wire LcdClkMux = VideoBPAck ? VidClk : VideoSyncEn ? ExtClk : LcdClkDiv;

reg UsbClk;
always @ (UClkDiv or USrcClk or UClkDivCnt)
  case (UClkDiv)	// synopsys_parallel_case
   	2'b00   : UsbClk = USrcClk;			// Bypass External USB Clock 
   	2'b01   : UsbClk = UClkDivCnt[0];	// 24MHz 
   	2'b10   : UsbClk = UClkDivCnt[1];	// 12MHz
   	2'b11   : UsbClk = UClkDivCnt[2];	// 6
  endcase
//------------------------------------------------------------------
// Clock Gating Logic(Logical OR)
wire CpuClkBuf    = TestMode ? ExtClk : ~(SysClk  | tPMPwdn | tPMIdle); 
wire SysClkBuf    = TestMode ? ExtClk : ~(SysClk  | tPMPwdn);
wire PeriClkBuf   = TestMode ? ExtClk : ~(PeriClk | tPMPwdn | PeriClkEn);
wire PeriClk2xBuf = TestMode ? ExtClk : ~(SysClk  | tPMPwdn | PeriClkEn);
wire VidClkBuf    = TestMode ? ExtClk : ~(VidClk  | tPMPwdn | VIFClkEn); 

BUFX2 CPUBUF(.A(CpuClkBuf),       .Y(CpuClkOut));
BUFX2 SYSBUF(.A(SysClkBuf),       .Y(SysClkOut));
BUFX2 PERI1XBUF(.A(PeriClkBuf),   .Y(PeriClkOut));
BUFX2 PERI2XBUF(.A(PeriClk2xBuf), .Y(PeriClk2xOut));
BUFX2 VIDBUF(.A(VidClkBuf),       .Y(VidClkOut));

//synopsys dc_script_begin
//set_dont_touch {CPUBUF, SYSBUF, PERI1XBUF, PERI2XBUF, VIDBUF}
//synopsys dc_script_end
//------------------------------------------------------------------
// Internal Logic Clock Gating For Low Power
wire GDMAClkBuf   = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | GDMAClkEn); 
wire DMAClkBuf    = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | DMAClkEn); 
wire DMClkBuf     = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | DMClkEn); 
wire LCDClkBuf    = TestMode ? ExtClk : ~(LcdClkMux| tPMPwdn | DMClkEn); 
wire VIFClkBuf    = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | VIFClkEn); 
wire NANDClkBuf   = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | NANDClkEn); 
wire DDRClk1xBuf  = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | DDRClkEn); 
wire DDRClk2xBuf  = TestMode ? ExtClk : ~(SysClk2x | tPMPwdn | DDRClkEn); 

wire IDDRClk1xBuf = TestMode ? ExtClk :  (SysClk   | tPMPwdn | DDRClkEn); 
wire IDDRClk2xBuf = TestMode ? ExtClk :  (SysClk2x | tPMPwdn | DDRClkEn); 

wire UsbClkBuf    = TestMode ? ExtClk : ~(UsbClk   | tPMPwdn | USBClkEn);
wire SEIPClkBuf   = TestMode ? ExtClk : ~(SysClk   | tPMPwdn | SEIPClkEn); 

BUFX2 GDMABUF(.A(GDMAClkBuf),   .Y(GDMAClkOut));
BUFX2 DMABUF(.A(DMAClkBuf),     .Y(DMAClkOut));
BUFX2 DMBUF(.A(DMClkBuf),       .Y(DMClkOut));
BUFX2 LCDBUF(.A(LCDClkBuf),     .Y(LcdClkOut));
BUFX2 VIFBUF(.A(VIFClkBuf),     .Y(VIFClkOut));
BUFX2 NANDBUF(.A(NANDClkBuf),   .Y(NANDClkOut));
BUFX2 DDR1XBUF(.A(DDRClk1xBuf), .Y(DDRClk1xOut));
BUFX2 DDR2XBUF(.A(DDRClk2xBuf), .Y(DDRClk2xOut));

BUFX2 SEIPBUF(.A(SEIPClkBuf),  .Y(SEIPClkOut));
BUFX2 USBBUF (.A(UsbClkBuf),   .Y(UsbClkOut));

BUFX2 IDDR1XBUF(.A(IDDRClk1xBuf), .Y(nDDRClk1xOut));
BUFX2 IDDR2XBUF(.A(IDDRClk2xBuf), .Y(nDDRClk2xOut));

//synopsys dc_script_begin
//set_dont_touch {GDMABUF, DMABUF, DMBUF, LCDBUF, VIFBUF, NANDBUF, DDR1BUF, DDR2BUF, IDDR1BUF, IDDR2BUF, SEIPBUF, USBBUF, IDDR1BUF, IDDR2BUF}
//synopsys dc_script_end
//------------------------------------------------------------------
endmodule
