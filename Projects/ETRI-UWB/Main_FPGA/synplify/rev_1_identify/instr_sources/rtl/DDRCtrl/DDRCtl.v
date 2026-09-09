
`timescale 1ns/10ps

module DDRCtl (
	nPOR,
    ARESETB ,
    ACLK	,

    BA_AA 	,
    BA_TT 	,
    BA_RW 	,
    BA_REQ	,
    BA_ID 	,
    BA_PM	,
    
	DiValid,
	DoValid,
	QueEmp,
	QueFul,
	QueErr,
	RdLast,
	RdId,
	DqsoValid,
	ColAddrSiz,
	RdDataInSel,
	RdDataPol,

    SDREnStatus,
    Dly1Sel, Dly0Sel,

    RQFull,
    WQFull,

    SD_CKE 	,
    SD_CSB 	,
    SD_RASB	,
    SD_CASB	,
    SD_WEB 	,
    SD_BADDR,
    SD_ADDR ,

	COEN, AOEN,

	PCLK,
	PRESETB,
    PSEL, 
    PENABLE, 
    PADDR, 
    PWRITE, 
    PWDATA, 
	PRDATA
);

`include "DDRPara.v"

input		nPOR;
input    	ARESETB  ;       // asynchronous reset
input    	ACLK      ;

// for bus arbiter
input  [AW:0]   BA_AA   ; // address
input  [BL:0]   BA_TT   ; // burst length
input    		BA_RW   ; // read/write
input    		BA_REQ  ; // request
input  [ID:0]   BA_ID   ; // id length
input			BA_PM;	// page miss indication

output			DiValid;
output			DoValid;
output			QueEmp;
output			QueFul;
output			QueErr;
output			RdLast;
output	[ID:0] 	RdId;
output			DqsoValid;
output	[1:0] 	ColAddrSiz;
output			RdDataInSel;
output			RdDataPol;

output			SDREnStatus;
output [ 7:0]	Dly0Sel, Dly1Sel;

// for sdram
output    		SD_CKE  ; // clock enable
output    		SD_CSB  ; // chip select
output    		SD_RASB ; // row address strobe
output    		SD_CASB ; // column address strobe
output    		SD_WEB  ; // write enable
output [BAW:0]  SD_BADDR; // bank address
output [RAW:0]  SD_ADDR ; // address

output			COEN, AOEN;

input			RQFull;
input			WQFull;

// miscellaneous
input         	PCLK;
input         	PRESETB;
              	
input  [ 7:2] 	PADDR;
input         	PWRITE;
input         	PSEL;
input         	PENABLE;
input  [31:0] 	PWDATA;
output [31:0] 	PRDATA;

reg			SD_CKE  ;
reg    		SD_CSB  ;
reg    		SD_RASB ;
reg    		SD_CASB ;
reg    		SD_WEB  ;
reg [BAW:0] SD_BADDR;
reg [RAW:0] SD_ADDR ;
reg [31:0]  PRDATA;

wire [3:0] cmd_moderegset  = 4'b0000;
wire [3:0] cmd_autorefresh = 4'b0001;
wire [3:0] cmd_precharge   = 4'b0010;
wire [3:0] cmd_setrowaddr  = 4'b0011;
wire [3:0] cmd_write       = 4'b0100;
wire [3:0] cmd_read        = 4'b0101;
wire [3:0] cmd_burststop   = 4'b0110;
wire [3:0] cmd_nop         = 4'b1111;

//-----------------------------------------------------------------------------------
// for bus arbiter
//-----------------------------------------------------------------------------------

// read/write
// +------+---------------+
// |  RW  |  description  |
// +------+---------------+
// |  0   |  read         |
// |  1   |  write        |
// +------+---------------+

// sdram finite state machine
wire [3:0] rs_idle  = 4'b0000;
wire [3:0] rs_wstop = 4'b0001;	// Write Stop
wire [3:0] rs_wtwr1 = 4'b0010;	// Wait tWR
wire [3:0] rs_wtwr2 = 4'b0011;
wire [3:0] rs_write = 4'b0100;
wire [3:0] rs_read;
reg  [3:0] rs_state;

// for bank finite status machines
wire [BAW:0] bf_0no;
wire [BAW:0] bf_1no;
wire [BAW:0] bf_2no;
wire [BAW:0] bf_3no;
wire       bf_0casbusy;
wire       bf_1casbusy;
wire       bf_2casbusy;
wire       bf_3casbusy;
wire       bf_tcasbusy;
wire       bf_0rasbusy;
wire       bf_1rasbusy;
wire       bf_2rasbusy;
wire       bf_3rasbusy;
wire       bf_trasbusy;
wire       bf_0ready;
wire       bf_1ready;
wire       bf_2ready;
wire       bf_3ready;
wire       bf_tready;
wire       bf_0idle;
wire       bf_1idle;
wire       bf_2idle;
wire       bf_3idle;
wire       bf_tidle;
wire       bf_0last;
wire       bf_1last;
wire       bf_2last;
wire       bf_3last;
wire       bf_tlast;
wire [5:0] bf_0reqcmd;
wire [5:0] bf_1reqcmd;
wire [5:0] bf_2reqcmd;
wire [5:0] bf_3reqcmd;
reg  [5:0] res0cmd;
reg  [5:0] res1cmd;
reg  [5:0] res2cmd;
reg  [5:0] res3cmd;
reg  [5:0] rescmd ;
reg  [5:0] bf_0cmd;
reg  [5:0] bf_1cmd;
reg  [5:0] bf_2cmd;
reg  [5:0] bf_3cmd;

// for cas event queue
wire [BAW:0] cas_0_ba;
wire [RAW:0] cas_0_ra;
wire [CAW:0] cas_0_ca;
wire [BL:0] cas_0_tt;
wire [ID:0] cas_0_id;
wire		cas_0_pm;
wire        cas_0_rw;
wire        cas_0_final;
wire        cas_0_newrow;
wire        cas_empty;
wire        cas_full;

// for ras event queue
wire [RAW+1:0] b0_last_ra;
wire [RAW+1:0] b1_last_ra;
wire [RAW+1:0] b2_last_ra;
wire [RAW+1:0] b3_last_ra;
wire [BAW:0] ras_0_ba;
wire [RAW:0] ras_0_ra;
wire [BL:0] ras_0_tt;
wire        ras_empty;
wire        ras_hempty; // half empty, need ras event
wire        ras_full;

wire        i_ba_req;
wire        closing;
wire        cmd_empty;
wire        cmd_full;
reg         cmd_mask;
reg         cmd_full_d;
wire        di_request;
wire  		dqs_request;
reg         do_valid;
reg 		bf_last;
wire [ID:0]	di_id;
reg [ID:0]	do_id;
reg [BAW:0] last_ba;
reg         read_bstop;
reg         rw_bstop0;
reg         rw_bstop1;
reg         rw_bstop2;
wire        rw_bstop;
reg [ 5:0]  ercmd;
reg [ 6:0]  ecmd ;

//-----------------------------------------------------------------------------------
// APB Register Interface
//-----------------------------------------------------------------------------------
// Control Register
reg        SDREn;
reg        SDREnStatus;
reg [ 1:0] ColAddrSiz;
reg        AddrSwapDis;
reg        PwDnEn;
reg [15:0] PwDnRef;

reg [ 7:0] Dly0Sel, Dly1Sel;
reg		   RdDataPol, RdDataInSel;

reg [15:0] PwDnCnt;
wire       ClrPwDnCnt, IncPwDnCnt;
wire       PwDnFlag;
reg		   SelfRefEn;
wire	   SRPwDnFlag;

// Time Count Register
wire [ 1:0] tmrs = 2'b1;
wire [ 1:0] trrd = 2'b1;
reg  [ 1:0] trp;
reg  [ 1:0] trcd;
reg  [ 2:0] tcl; // use input latch
reg  [ 2:0] tcl_s; // use input latch
reg  [ 2:0] tclp;
reg  [ 3:0] trasmin;
reg  [ 3:0] trc;           // trp + trasmin
reg  [15:0] trefresh;
reg  [ 3:0] refreshno;

reg [ 7:0]  wait_cnt;
reg [ 4:0]  stable_cnt;
reg [ 1:0]  tmrs_cnt;
reg [ 1:0]  trp_cnt;
reg [ 3:0]  trc_cnt;
reg [ 3:0]  ar_cnt;	// Refresh number
reg [15:0]  refresh_cnt;
reg [ 4:0]  selfref_cnt;

reg			DisableDLL;
reg			ReducedDrv;
reg			ResetDLL; // Reset DLL
     		
wire RegWr   =  PWRITE;
wire RegRd   = ~PWRITE;
wire RegSel  =  PSEL & ~PENABLE;

wire Reg0Sel = RegSel & (PADDR == 6'h00);
wire Reg1Sel = RegSel & (PADDR == 6'h01);
wire Reg2Sel = RegSel & (PADDR == 6'h02);
wire Reg3Sel = RegSel & (PADDR == 6'h03);
wire Reg4Sel = RegSel & (PADDR == 6'h04);
wire Reg0Wr  = Reg0Sel & RegWr;
wire Reg1Wr  = Reg1Sel & RegWr;
wire Reg2Wr  = Reg2Sel & RegWr;
wire Reg3Wr  = Reg3Sel & RegWr;
wire Reg4Wr  = Reg4Sel & RegWr;
wire Reg0Rd  = Reg0Sel & RegRd;
wire Reg1Rd  = Reg1Sel & RegRd;
wire Reg2Rd  = Reg2Sel & RegRd;
wire Reg3Rd  = Reg3Sel & RegRd;
wire Reg4Rd  = Reg4Sel & RegRd;

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        trp         <= 2'd2;
        trcd		<= 2'd2;
        tcl         <= 3'd3;
        tcl_s       <= 3'd3;
        trasmin     <= 4'd9;
        trc			<= 4'd11;
	end
	else if (Reg0Wr) begin
	    trp         <= PWDATA[ 1: 0];
        trcd		<= PWDATA[ 3: 2];
	    tcl         <= PWDATA[ 6: 4];
	    trasmin     <= PWDATA[11: 8];
        trc			<= PWDATA[15:12];
	    tcl_s       <= PWDATA[18:16];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		Dly1Sel 	<= 0;
		Dly0Sel 	<= 0;
		RdDataPol	<= 0;
		RdDataInSel	<= 0;
		ColAddrSiz	<= 0;
		AddrSwapDis <= 1'b1;
		SDREn  		<= 1'b0;
	end
	else if (Reg1Wr) begin
		Dly1Sel 	<= PWDATA[31:24];
		Dly0Sel 	<= PWDATA[23:16];
		RdDataPol	<= PWDATA[7];
		RdDataInSel	<= PWDATA[6];
	    ColAddrSiz	<= PWDATA[5:4];
		AddrSwapDis <= PWDATA[1];
	    SDREn		<= PWDATA[0];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
		SelfRefEn   <= 1'b0;
		PwDnEn		<= 1'b0;
		PwDnRef		<= 16'hffff;
	end
	else if (Reg2Wr) begin
		SelfRefEn	<= PWDATA[31];
	    PwDnRef		<= PWDATA[15:0];
		PwDnEn		<= PWDATA[16];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        trefresh    <= 16'h0410;
        refreshno   <= 4'b0;
	end
	else if (Reg3Wr) begin
	    trefresh    <= PWDATA[15: 0];
	    refreshno   <= PWDATA[19:16];
	end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB) begin
        DisableDLL  <= 0;
        ReducedDrv	<= 0;
        ResetDLL    <= 1;
        tclp        <= 2;
	end
	else if (Reg4Wr) begin
	    DisableDLL  <= PWDATA[0];
        ReducedDrv	<= PWDATA[1];
	    ResetDLL    <= PWDATA[2];
	    tclp        <= PWDATA[6:4];
	end

wire SDRBusy = cmd_full | cmd_mask | ~cmd_empty;

wire [31:0] Reg0Data = {16'b0,
						trc, 
						trasmin, 
						1'b0, tcl, 
						trcd, trp};

wire [31:0] Reg1Data = {Dly1Sel, Dly0Sel, 8'b0, RdDataPol, RdDataInSel, ColAddrSiz, 2'b0, AddrSwapDis, SDREnStatus};

wire [31:0] Reg2Data = {SRPwDnFlag, 14'b0, PwDnFlag, PwDnCnt};

wire [31:0] Reg3Data = {RQFull, WQFull, selfref_cnt, SDRBusy, stable_cnt, refreshno, trefresh};

wire [31:0] Reg4Data = {tclp, 1'b0, ResetDLL, ReducedDrv, DisableDLL};

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)	PRDATA <= 32'b0;
	else begin
		case(1'b1) // synopsys parallel_case
    	  Reg0Rd  : PRDATA <= Reg0Data;
    	  Reg1Rd  : PRDATA <= Reg1Data;
    	  Reg2Rd  : PRDATA <= Reg2Data;
    	  Reg3Rd  : PRDATA <= Reg3Data;
    	  Reg4Rd  : PRDATA <= Reg4Data;
    	  default : PRDATA <= 32'b0;
    	endcase
    end
//-----------------------------------------------------------------------------------
// Address Swapping
// Normal : BA-RA-CA
// Swap   : RA-BA-CA

// Column Address Size
// 0 : 8 Bit, 16MB at 16Bit Width
// 1 : 9 Bit, 32MB
// 2 : 10 Bit, 64MB
// 3 : 11 Bit, 128MB

reg [BAW:0] BA_BA;
reg [RAW:0] BA_RA;
reg [CAW:0] BA_CA;

always @(AddrSwapDis or ColAddrSiz or BA_AA)
	case (ColAddrSiz) // synopsys parallel_case
	    2'b00   : if (AddrSwapDis) begin BA_BA = BA_AA[21:20]; BA_RA = BA_AA[19: 7]; BA_CA = {3'b0, BA_AA[6:0], 1'b0}; end
	              else             begin BA_BA = BA_AA[ 8: 7]; BA_RA = BA_AA[21: 9]; BA_CA = {3'b0, BA_AA[6:0], 1'b0}; end
	    2'b01   : if (AddrSwapDis) begin BA_BA = BA_AA[22:21]; BA_RA = BA_AA[20: 8]; BA_CA = {2'b0, BA_AA[7:0], 1'b0}; end
	              else             begin BA_BA = BA_AA[ 9: 8]; BA_RA = BA_AA[22:10]; BA_CA = {2'b0, BA_AA[7:0], 1'b0}; end
	    2'b10   : if (AddrSwapDis) begin BA_BA = BA_AA[23:22]; BA_RA = BA_AA[21: 9]; BA_CA = {1'b0, BA_AA[8:0], 1'b0}; end
	              else             begin BA_BA = BA_AA[10: 9]; BA_RA = BA_AA[23:11]; BA_CA = {1'b0, BA_AA[8:0], 1'b0}; end
	    default : if (AddrSwapDis) begin BA_BA = BA_AA[24:23]; BA_RA = BA_AA[22:10]; BA_CA = {      BA_AA[9:0], 1'b0}; end
	              else             begin BA_BA = BA_AA[11:10]; BA_RA = BA_AA[24:12]; BA_CA = {      BA_AA[9:0], 1'b0}; end
	endcase

//wire [BAW:0] BA_BA = AddrSwapDis ? BA_AA[22:21] : BA_AA[9: 8];
//wire [RAW:0] BA_RA = AddrSwapDis ? BA_AA[20: 8] : BA_AA[22:10];
//wire [CAW:0] BA_CA =              {BA_AA[7:0], 1'b0};
//-----------------------------------------------------------------------------------
// Power Down
  // Need Auto Refresh During Pown Down Mode
  // Violating refresh requirements during power-down may result in a loss of data.

always@(negedge nPOR or posedge ACLK)
	if      (!nPOR)              	 PwDnCnt <= 16'hffff;
	else if (ClrPwDnCnt)             PwDnCnt <= PwDnRef;
	else if (IncPwDnCnt & ~PwDnFlag) PwDnCnt <= PwDnCnt - 1;

assign PwDnFlag = (PwDnCnt==0) ? 1'b1 : 1'b0;

assign ClrPwDnCnt  = BA_REQ | ~cmd_empty | (stable_cnt != 0);
assign IncPwDnCnt  = (stable_cnt == 0) & (rs_state == rs_idle) & bf_tidle & PwDnEn & ~SelfRefEn;

assign SRPwDnFlag = (selfref_cnt==10+2) ? 1'b1 : 1'b0;

wire iSD_CKE = ~PwDnFlag & ~SRPwDnFlag;
//					Prevent tWR Violation
wire burst_stop = ~bf_tcasbusy & (rs_state == rs_idle) & (cmd_empty | cmd_mask);
//-----------------------------------------------------------------------------------
// main controller
//-----------------------------------------------------------------------------------
always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin // more than two cycle RESET is needed.
        stable_cnt  <= 5'h1f;
        cmd_mask    <= 1'b1;
        ercmd       <= erc_powerup;

        trp_cnt     <= 2'd2;
        trc_cnt     <= 4'd10;
        tmrs_cnt    <= 2'b1;
        ar_cnt      <= 4'b0;
        refresh_cnt <= 16'h0410;
        SDREnStatus <= 1'b0;
        selfref_cnt <= 31;
        wait_cnt    <= 8'hff;
    end
    else if (SDREn) begin
        if (stable_cnt > 3'b111) begin
            stable_cnt  <= stable_cnt - 1;
        	trp_cnt     <= trp;
        	trc_cnt     <= trc;
        	tmrs_cnt    <= tmrs;
            ar_cnt      <= 1;//refreshno; more 2 refresh at Init
        	refresh_cnt <= trefresh;
        end
        else begin
        	SDREnStatus <= 1'b1;
            case(stable_cnt[2:0])
              3'b111 :	// PRE
                begin 
                    ercmd       <= erc_epc;
                    stable_cnt  <= stable_cnt - 1;
                end
              3'b110 :	// EMR
                begin 
                if (trp_cnt == 3'b000) begin
                    ercmd       <= erc_mrs;
                    trp_cnt     <= trp;
                    stable_cnt  <= stable_cnt - 1;
                end
                else begin
                    ercmd       <= erc_idle;
                    trp_cnt     <= trp_cnt - 1;
                end
                end
              3'b101 :	// LMR
                begin 
                if (tmrs_cnt == 3'b000) begin
                    ercmd       <= erc_mrs;
                    tmrs_cnt    <= tmrs;
                    stable_cnt  <= stable_cnt - 1;
                end
                else begin
                    ercmd       <= erc_idle;
                    tmrs_cnt    <= tmrs_cnt - 1;
                end
                end
              3'b100 :	// PRE
                if (tmrs_cnt == 3'b000) begin
                    ercmd       <= erc_epc;
                    tmrs_cnt    <= tmrs;
                    stable_cnt  <= stable_cnt - 1;
                end
                else begin
                    ercmd       <= erc_idle;
                    tmrs_cnt    <= tmrs_cnt - 1;
                end
              3'b011 :	// AR
                begin 
                if (trp_cnt == 3'b000) begin
                    ercmd       <= erc_ar;
                    trp_cnt     <= trp;
                    stable_cnt  <= stable_cnt - 1;
                end
                else begin
                    ercmd       <= erc_idle;
                    trp_cnt     <= trp_cnt - 1;
                end
                end
              3'b010 :	// AR
                begin 
                if (trc_cnt == 4'b0000 & ar_cnt == 4'b0000) begin
                    ercmd       <= erc_idle;
//                    cmd_mask    <= 1'b0;
                    trc_cnt     <= trc;
                    ar_cnt      <= refreshno;
                    stable_cnt  <= stable_cnt - 1;
                    wait_cnt    <= wait_cnt - 1;
                end
                else if (trc_cnt == 4'b0000) begin
                    ercmd       <= erc_ar;
                    trc_cnt     <= trc;
                    ar_cnt      <= ar_cnt - 1;
                    wait_cnt    <= wait_cnt - 1;
                end
                else begin
                    ercmd       <= erc_idle;
                    trc_cnt     <= trc_cnt - 1;
                end
                end
              3'b001 :	// Wait 200 cycle
                begin 
                if (wait_cnt == 8'b0) begin
                    ercmd       <= erc_normal;
                    stable_cnt  <= stable_cnt - 1;
                end
                else begin
                    ercmd       <= erc_idle;
                    wait_cnt    <= wait_cnt - 1;
                end
                end
              3'b000 :
                begin
                if (SelfRefEn & (selfref_cnt == 31) & cmd_empty) begin // 31-16 : should be minimum over 16
                	ercmd       <= erc_normal;
                	refresh_cnt <= trefresh;
                	cmd_mask    <= 1;
                	trp_cnt     <= trp;
                	selfref_cnt <= selfref_cnt - 1;
                end
                else if (SelfRefEn & (selfref_cnt < 31) & (selfref_cnt > 15) & burst_stop) begin	// At Write
                	ercmd       <= erc_idle;
                	selfref_cnt <= selfref_cnt - 1;
                end
                else if (SelfRefEn & (selfref_cnt == 15)) begin	// At Read
                	ercmd       <= erc_epc;
                	selfref_cnt <= selfref_cnt - 1;
                end
                else if (SelfRefEn & (selfref_cnt == 14)) begin
                		if (trp_cnt == 0) begin
                		    ercmd       <= erc_ar;
                		    trp_cnt     <= trp;
                			selfref_cnt <= selfref_cnt - 1;
                		end
                		else begin
                		    ercmd       <= erc_idle;
                		    trp_cnt     <= trp_cnt - 1;
                		end
                end
				else if (SelfRefEn & (selfref_cnt < 14) & (selfref_cnt > 10+2)) begin
                		ercmd       <= erc_idle;
                		selfref_cnt <= selfref_cnt - 1;
                end
				else if (selfref_cnt == 10+2) begin
                	if (~SelfRefEn)
                		 selfref_cnt <= selfref_cnt - 1;
                	else selfref_cnt <= selfref_cnt;
                end
                else if (~SelfRefEn & (selfref_cnt == 9+2)) begin
                		if (trp_cnt == 0) begin
                		    ercmd       <= erc_ar;
                		    trp_cnt     <= trp;
                		    selfref_cnt <= selfref_cnt - 1;
                		end
                		else begin
                		    ercmd       <= erc_idle;
                		    trp_cnt     <= trp_cnt - 1;
                		end
                end
                else if (~SelfRefEn & (selfref_cnt > 0) & (selfref_cnt != 31)) begin
                	ercmd       <= erc_idle;
                	selfref_cnt <= selfref_cnt - 1;
                end
                else if (~SelfRefEn & ((selfref_cnt == 0) | (selfref_cnt == 31))) begin
                	trc_cnt     <= trc;
                	selfref_cnt <= 31;
                	if    (refresh_cnt > 16'd4) begin
                	    ercmd       <= erc_normal;
                	    cmd_mask    <= 0;
                	    refresh_cnt <= refresh_cnt - 1;
                	end
                	else if (refresh_cnt == 16'd4) begin
                	    cmd_mask    <= 1;
                	    refresh_cnt <= refresh_cnt - 1;
                	end
                	else if (refresh_cnt == 16'd3) begin
                	    refresh_cnt <= refresh_cnt - 1;
                	end
                	else if (refresh_cnt == 16'd2) begin
                	    if (ecmd == ebc_epc) begin
                	        trp_cnt     <= trp_cnt - 1;
                	        refresh_cnt <= refresh_cnt - 1;
                	    end
                	    else if (cmd_empty & bf_tidle) begin
                	        ercmd       <= erc_ar;
                	        refresh_cnt <= refresh_cnt - 2'd2;
                	    end
                	end
                	else if (refresh_cnt == 16'd1) begin
                	    if (trp_cnt == 0) begin
                	        ercmd       <= erc_ar;
                	        trp_cnt     <= trp;
                	        refresh_cnt <= refresh_cnt - 1;
                	    end
                	    else begin
                	        ercmd       <= erc_idle;
                	        trp_cnt     <= trp_cnt - 1;
                	    end
                	end
                	else begin
                	    if    (trc_cnt == 2 & ar_cnt == 0) begin
                	        ercmd       <= erc_idle;
                	        cmd_mask    <= 1'b0;
                	        trc_cnt     <= trc_cnt - 1;
                	    end
                	    else if (trc_cnt == 0 & ar_cnt == 0) begin
                	        ercmd       <= erc_normal;
                	        trc_cnt     <= trc;
                	        ar_cnt      <= refreshno;
                	        refresh_cnt <= trefresh;
                	    end
                	    else if (trc_cnt == 0) begin
                	        ercmd       <= erc_ar;
                	        trc_cnt     <= trc;
                	        ar_cnt      <= ar_cnt - 1;
                	    end
                	    else begin
                	        ercmd       <= erc_idle;
                	        trc_cnt     <= trc_cnt - 1;
                	    end
                	end
                end
                end
               default : begin
                       	stable_cnt  <= stable_cnt ;  
        				cmd_mask    <= cmd_mask   ;
        				ercmd       <= ercmd      ;
        				ar_cnt      <= ar_cnt     ;
        				trp_cnt     <= trp_cnt    ;
        				trc_cnt     <= trc_cnt    ;
        				tmrs_cnt    <= tmrs_cnt   ;
        				refresh_cnt <= refresh_cnt;
        				SDREnStatus <= SDREnStatus;

               end
            endcase
        end
    end
end

assign DiValid = di_request;
assign DoValid = do_valid;
assign QueEmp = cmd_empty;
assign QueFul = cmd_full | cmd_mask;
assign QueErr = BA_REQ &  cmd_full_d;
assign RdLast = bf_last;
assign RdId = do_id;
assign DqsoValid  = dqs_request;

assign i_ba_req  = BA_REQ & ~cmd_full_d;
assign rs_read   = tcl_s + rs_write + 3'b011; // "read_precharge_truncation" ddr model, Further Study, DDR Burst4
//assign rs_read   = tcl_s + rs_write + 3'b101; // "read_precharge_truncation" ddr model, Further Study, DDR Burst4
//assign rs_read   = rs_write + 3'b110; // offset, DDR Burst8?

assign closing   = (ercmd == erc_epc | (ercmd == erc_normal & ecmd == ebc_epc)) ? 1'b1 : 1'b0;

always @(negedge ARESETB or posedge ACLK)
    if (!ARESETB) cmd_full_d <= 1;
    else		  cmd_full_d <= cmd_full | cmd_mask;

//-----------------------------------------------------------------------------------
// bank finite status machines
//-----------------------------------------------------------------------------------

assign  bf_0no = 2'b00;
assign  bf_1no = 2'b01;
assign  bf_2no = 2'b10;
assign  bf_3no = 2'b11;

reg  CAS_0_WTR1;
reg [2:0] BurstWTRCnt;
wire BurstWTREnd = (BurstWTRCnt == 0);

wire CAS_0_WTR0 = (cas_0_rw | cas_empty);

always @(negedge ARESETB or posedge ACLK)
    if      (!ARESETB)  CAS_0_WTR1 <= 1'b0;
    else				CAS_0_WTR1 <= CAS_0_WTR0;

wire WTRWaitEn = ~CAS_0_WTR0 & CAS_0_WTR1;

reg  BurstWTRWait;
always @(negedge ARESETB or posedge ACLK)
    if      (!ARESETB) 		BurstWTRWait <= 0;
    else if ( BurstWTREnd)	BurstWTRWait <= 0;
    else if ( WTRWaitEn)	BurstWTRWait <= 1;
    else					BurstWTRWait <= BurstWTRWait;

wire WriteToRead = WTRWaitEn || BurstWTRWait;

always @(negedge ARESETB or posedge ACLK)
    if      (!ARESETB)		BurstWTRCnt <= 0;
    else if (!BurstWTRWait) BurstWTRCnt <= 3;
    else if ( BurstWTRWait) BurstWTRCnt <= BurstWTRCnt - 1;

reg  SingleWTREnd;
always @(negedge ARESETB or posedge ACLK)
    if      (!ARESETB) 	   	SingleWTREnd <= 0;
    else                    SingleWTREnd <= BurstWTREnd;

DDRBsm B0SM (
    .ARESETB       (ARESETB),
    .ACLK           (ACLK),
    .TRP           (trp),
    .TRRD          (trrd),
    .TRCD          (trcd),
    .TRASMIN       (trasmin),
    .BA_BA         (BA_BA),
    .BA_RA         (BA_RA),
    .BA_TT         (BA_TT),
    .BA_REQ        (i_ba_req),
    .WriteToRead	(WriteToRead),
    .BurstWTREnd	(BurstWTREnd),
    .SingleWTREnd	(SingleWTREnd),
    .BurstWTRCnt	(BurstWTRCnt),
    .CAS_0_BA      (cas_0_ba),
    .CAS_0_RA      (cas_0_ra),
    .CAS_0_TT      (cas_0_tt),
    .CAS_0_FINAL   (cas_0_final),
    .CAS_0_NEWROW  (cas_0_newrow),
    .CAS_EMPTY     (cas_empty),
    .LAST_RA       (b0_last_ra),
    .RAS_0_BA      (ras_0_ba),
    .RAS_0_RA      (ras_0_ra),
    .RAS_0_TT      (ras_0_tt),
    .RAS_EMPTY     (ras_empty),
    .BF_NO         (bf_0no),
    .BF_CASBUSY    (bf_0casbusy),
    .BF_TCASBUSY   (bf_tcasbusy),
    .BF_RASBUSY    (bf_0rasbusy),
    .BF_TRASBUSY   (bf_trasbusy),
    .BF_READY      (bf_0ready),
    .BF_TREADY     (bf_tready),
    .BF_IDLE       (bf_0idle),
    .BF_LAST	   (bf_0last),
    .BF_REQCMD     (bf_0reqcmd),
    .BF_CMD        (bf_0cmd),
    .ERCMD         (ercmd),
    .ECMD          (ecmd)
);

DDRBsm B1SM (
    .ARESETB       (ARESETB),
    .ACLK           (ACLK),
    .TRP           (trp),
    .TRRD          (trrd),
    .TRCD          (trcd),
    .TRASMIN       (trasmin),
    .BA_BA         (BA_BA),
    .BA_RA         (BA_RA),
    .BA_TT         (BA_TT),
    .BA_REQ        (i_ba_req),
    .WriteToRead	(WriteToRead),
    .BurstWTREnd	(BurstWTREnd),
    .SingleWTREnd	(SingleWTREnd),
    .BurstWTRCnt	(BurstWTRCnt),
    .CAS_0_BA      (cas_0_ba),
    .CAS_0_RA      (cas_0_ra),
    .CAS_0_TT      (cas_0_tt),
    .CAS_0_FINAL   (cas_0_final),
    .CAS_0_NEWROW  (cas_0_newrow),
    .CAS_EMPTY     (cas_empty),
    .LAST_RA       (b1_last_ra),
    .RAS_0_BA      (ras_0_ba),
    .RAS_0_RA      (ras_0_ra),
    .RAS_0_TT      (ras_0_tt),
    .RAS_EMPTY     (ras_empty),
    .BF_NO         (bf_1no),
    .BF_CASBUSY    (bf_1casbusy),
    .BF_TCASBUSY   (bf_tcasbusy),
    .BF_RASBUSY    (bf_1rasbusy),
    .BF_TRASBUSY   (bf_trasbusy),
    .BF_READY      (bf_1ready),
    .BF_TREADY     (bf_tready),
    .BF_IDLE       (bf_1idle),
    .BF_REQCMD     (bf_1reqcmd),
    .BF_LAST	   (bf_1last),
    .BF_CMD        (bf_1cmd),
    .ERCMD         (ercmd),
    .ECMD          (ecmd)
);

DDRBsm B2SM (
    .ARESETB       (ARESETB),
    .ACLK           (ACLK),
    .TRP           (trp),
    .TRRD          (trrd),
    .TRCD          (trcd),
    .TRASMIN       (trasmin),
    .BA_BA         (BA_BA),
    .BA_RA         (BA_RA),
    .BA_TT         (BA_TT),
    .BA_REQ        (i_ba_req),
    .WriteToRead	(WriteToRead),
    .BurstWTREnd	(BurstWTREnd),
    .SingleWTREnd	(SingleWTREnd),
    .BurstWTRCnt	(BurstWTRCnt),
    .CAS_0_BA      (cas_0_ba),
    .CAS_0_RA      (cas_0_ra),
    .CAS_0_TT      (cas_0_tt),
    .CAS_0_FINAL   (cas_0_final),
    .CAS_0_NEWROW  (cas_0_newrow),
    .CAS_EMPTY     (cas_empty),
    .LAST_RA       (b2_last_ra),
    .RAS_0_BA      (ras_0_ba),
    .RAS_0_RA      (ras_0_ra),
    .RAS_0_TT      (ras_0_tt),
    .RAS_EMPTY     (ras_empty),
    .BF_NO         (bf_2no),
    .BF_CASBUSY    (bf_2casbusy),
    .BF_TCASBUSY   (bf_tcasbusy),
    .BF_RASBUSY    (bf_2rasbusy),
    .BF_TRASBUSY   (bf_trasbusy),
    .BF_READY      (bf_2ready),
    .BF_TREADY     (bf_tready),
    .BF_IDLE       (bf_2idle),
    .BF_LAST	   (bf_2last),
    .BF_REQCMD     (bf_2reqcmd),
    .BF_CMD        (bf_2cmd),
    .ERCMD         (ercmd),
    .ECMD          (ecmd)
);

DDRBsm B3SM (
    .ARESETB       (ARESETB),
    .ACLK           (ACLK),
    .TRP           (trp),
    .TRRD          (trrd),
    .TRCD          (trcd),
    .TRASMIN       (trasmin),
    .BA_BA         (BA_BA),
    .BA_RA         (BA_RA),
    .BA_TT         (BA_TT),
    .BA_REQ        (i_ba_req),
    .WriteToRead	(WriteToRead),
    .BurstWTREnd	(BurstWTREnd),
    .SingleWTREnd	(SingleWTREnd),
    .BurstWTRCnt	(BurstWTRCnt),
    .CAS_0_BA      (cas_0_ba),
    .CAS_0_RA      (cas_0_ra),
    .CAS_0_TT      (cas_0_tt),
    .CAS_0_FINAL   (cas_0_final),
    .CAS_0_NEWROW  (cas_0_newrow),
    .CAS_EMPTY     (cas_empty),
    .LAST_RA       (b3_last_ra),
    .RAS_0_BA      (ras_0_ba),
    .RAS_0_RA      (ras_0_ra),
    .RAS_0_TT      (ras_0_tt),
    .RAS_EMPTY     (ras_empty),
    .BF_NO         (bf_3no),
    .BF_CASBUSY    (bf_3casbusy),
    .BF_TCASBUSY   (bf_tcasbusy),
    .BF_RASBUSY    (bf_3rasbusy),
    .BF_TRASBUSY   (bf_trasbusy),
    .BF_READY      (bf_3ready),
    .BF_TREADY     (bf_tready),
    .BF_IDLE       (bf_3idle),
    .BF_LAST	   (bf_3last),
    .BF_REQCMD     (bf_3reqcmd),
    .BF_CMD        (bf_3cmd),
    .ERCMD         (ercmd),
    .ECMD          (ecmd)
);

assign bf_tcasbusy = bf_0casbusy | bf_1casbusy | bf_2casbusy | bf_3casbusy;
assign bf_trasbusy = bf_0rasbusy | bf_1rasbusy | bf_2rasbusy | bf_3rasbusy;
assign bf_tready   = bf_0ready  & bf_1ready  & bf_2ready  & bf_3ready;
assign bf_tidle    = bf_0idle   & bf_1idle   & bf_2idle   & bf_3idle;
assign bf_tlast    = bf_0last   | bf_1last   | bf_2last   | bf_3last;

//-----------------------------------------------------------------------------------
// priority resolve
//-----------------------------------------------------------------------------------
reg [5:0] preres0cmd;
reg [5:0] preres1cmd;
reg [5:0] preres2cmd;
reg [5:0] preres3cmd;
reg [5:0] bf_treqcmd;
reg mask1;
reg mask2;
reg mask3;
reg mask4;
reg mask5;

always @ (ercmd or bf_0reqcmd or bf_1reqcmd or bf_2reqcmd or bf_3reqcmd or
		  mask1 or mask2 or mask3 or mask4 or mask5)
begin
    if (ercmd == erc_normal) begin
        preres0cmd = bf_0reqcmd;
        preres1cmd = bf_1reqcmd & ~bf_0reqcmd;
        preres2cmd = bf_2reqcmd & ~(bf_0reqcmd | bf_1reqcmd);
        preres3cmd = bf_3reqcmd & ~(bf_0reqcmd | bf_1reqcmd | bf_2reqcmd);
        bf_treqcmd = bf_0reqcmd | bf_1reqcmd | bf_2reqcmd | bf_3reqcmd;
        mask1      = ~ bf_treqcmd[0];
        mask2      = ~(bf_treqcmd[0] | bf_treqcmd[1]);
        mask3      = ~(bf_treqcmd[0] | bf_treqcmd[1] | bf_treqcmd[2]);
        mask4      = ~(bf_treqcmd[0] | bf_treqcmd[1] | bf_treqcmd[2] | bf_treqcmd[3]);
        mask5      = ~(bf_treqcmd[0] | bf_treqcmd[1] | bf_treqcmd[2] | bf_treqcmd[3] | bf_treqcmd[4]);
        res0cmd[0] <= preres0cmd[0];
        res0cmd[1] <= preres0cmd[1] & mask1;
        res0cmd[2] <= preres0cmd[2] & mask2;
        res0cmd[3] <= preres0cmd[3] & mask3;
        res0cmd[4] <= preres0cmd[4] & mask4;
        res0cmd[5] <= bf_0reqcmd[5] & mask5; // epc
        res1cmd[0] <= preres1cmd[0];
        res1cmd[1] <= preres1cmd[1] & mask1;
        res1cmd[2] <= preres1cmd[2] & mask2;
        res1cmd[3] <= preres1cmd[3] & mask3;
        res1cmd[4] <= preres1cmd[4] & mask4;
        res1cmd[5] <= bf_1reqcmd[5] & mask5; // epc
        res2cmd[0] <= preres2cmd[0];
        res2cmd[1] <= preres2cmd[1] & mask1;
        res2cmd[2] <= preres2cmd[2] & mask2;
        res2cmd[3] <= preres2cmd[3] & mask3;
        res2cmd[4] <= preres2cmd[4] & mask4;
        res2cmd[5] <= bf_2reqcmd[5] & mask5; // epc
        res3cmd[0] <= preres3cmd[0];
        res3cmd[1] <= preres3cmd[1] & mask1;
        res3cmd[2] <= preres3cmd[2] & mask2;
        res3cmd[3] <= preres3cmd[3] & mask3;
        res3cmd[4] <= preres3cmd[4] & mask4;
        res3cmd[5] <= bf_3reqcmd[5] & mask5; // epc
        rescmd[0]  <= bf_treqcmd[0];
        rescmd[1]  <= bf_treqcmd[1] & mask1;
        rescmd[2]  <= bf_treqcmd[2] & mask2;
        rescmd[3]  <= bf_treqcmd[3] & mask3;
        rescmd[4]  <= bf_treqcmd[4] & mask4;
        rescmd[5]  <= bf_treqcmd[5] & mask5;
    end
    else begin
        res0cmd    <= bc_null;
        res1cmd    <= bc_null;
        res2cmd    <= bc_null;
        res3cmd    <= bc_null;
        rescmd     <= bc_null;
    end
end

//-----------------------------------------------------------------------------------
// sdram finite state machine
//-----------------------------------------------------------------------------------
// main finite state machine
always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        rs_state <= 0;//rs_idle;
    end
    else begin
        case(rs_state)
          rs_idle :
          begin
            if (rescmd == bc_scas | rescmd == bc_mcas) begin
                if (~cas_0_rw) rs_state <= rs_read;
                else		   rs_state <= rs_write;
            end
          end
          rs_wstop :
          begin
            case(rescmd)
              bc_scas , bc_mcas :
                if (~cas_0_rw) rs_state <= rs_read;
                else           rs_state <= rs_write;
              default :		   rs_state <= rs_state - 1;
            endcase
          end
          rs_wtwr1, rs_wtwr2 : rs_state <= rs_state - 1;
          rs_write :
          begin
            case(rescmd)
              bc_pc :
                if (~bf_tcasbusy) rs_state <= rs_state - 1;
                else              rs_state <= rs_state;
              bc_epc :            rs_state <= rs_state - 1;
              bc_scas , bc_mcas :
                if (~cas_0_rw)    rs_state <= rs_read; // --*** Modify BSM
                else			  rs_state <= rs_write;
              default :
                if (~bf_tcasbusy) rs_state <= rs_state - 1;
                else              rs_state <= rs_state;
            endcase
          end
          default :
          begin
			if (rs_state == rs_read) begin
               case(rescmd)
                  bc_pc :
                    if (last_ba == ras_0_ba) rs_state <= rs_state; // Need Single Only Access
                    else                     rs_state <= rs_state;
                  bc_epc :
                    rs_state <= rs_idle;
                  bc_scas , bc_mcas :
                    if (cas_0_rw) rs_state <= rs_state - 1;
                    else          rs_state <= rs_state;
                  bc_sras , bc_mras :
                    				rs_state <= rs_state;
                  default :
                    if (~bf_tcasbusy) rs_state <= rs_state - 1;
                    else              rs_state <= rs_state;
                endcase
            end
            else if (rw_bstop) rs_state <= rs_state - 1;
            else begin
                case(rescmd)
                  bc_pc :
                    if (last_ba == ras_0_ba) rs_state <= rs_idle;
                    else begin
                        if (rs_state == (rs_write + 1)) rs_state <= rs_idle;
                        else                            rs_state <= rs_state - 1;
                    end
                  bc_epc :
                    rs_state <= rs_idle;
                  bc_scas , bc_mcas :
                    if (~cas_0_rw) rs_state <= rs_read;
                    else           rs_state <= rs_write;
                  default :
                    if (rs_state == (rs_write + 1)) rs_state <= rs_idle;
                    else                            rs_state <= rs_state - 1;
                endcase
              end
            end
        endcase
    end
end

// burst stop finite state machine

wire rw_stop0 = (rs_state == rs_read) &  cas_0_rw & (rescmd == bc_scas | rescmd == bc_mcas);
wire rw_stop1 = (rs_state == rs_read) &  cas_0_rw & (rescmd == bc_null) & ~bf_tcasbusy & (last_ba != cas_0_ba);
//wire rw_stop1 = (rs_state == rs_read) &  cas_0_rw & (ecmd == ebc_bstop) & ~bf_tcasbusy & (last_ba != cas_0_ba);
wire rw_stop2 = (rs_state == rs_read) &             (rescmd == bc_null) & ~bf_tcasbusy & cmd_empty;
wire rw_clear = (rs_state == (rs_write + 2)) | (rs_state == rs_idle);

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        read_bstop <= 1'b0;
        rw_bstop0  <= 1'b0;
        rw_bstop1  <= 1'b0;
        rw_bstop2  <= 1'b0;
    end
    else begin
        if (rs_state == rs_read & ~bf_tcasbusy &
              ((ecmd == ebc_pc & last_ba != ras_0_ba) |
               ecmd == ebc_sras | ecmd == ebc_mras))
            read_bstop <= 1'b1;
        else if ((ecmd == ebc_pc & last_ba == ras_0_ba) |
               ecmd == ebc_epc | ecmd == ebc_scas | ecmd == ebc_mcas |
               ecmd == ebc_bstop)
            read_bstop <= 1'b0;

        if 		(rw_stop0) rw_bstop0 <= 1'b1;
		else if (rw_clear) rw_bstop0 <= 1'b0;
        if 		(rw_stop1) rw_bstop1 <= 1'b1;
		else if (rw_clear) rw_bstop1 <= 1'b0;
        if 		(rw_stop2) rw_bstop2 <= 1'b1;
		else if (rw_clear) rw_bstop2 <= 1'b0;
   end
end

assign rw_bstop = rw_bstop0 | rw_bstop1 | rw_bstop2;


// miscellaneous
always @(negedge ARESETB or posedge ACLK)
 	if (!ARESETB)   last_ba <= 2'b0;
    else if (ecmd == ebc_scas | ecmd == ebc_mcas)
       				last_ba <= cas_0_ba;

//-----------------------------------------------------------------------------------
// data request & valid
//-----------------------------------------------------------------------------------
assign di_request = (((ecmd == ebc_scas | ecmd == ebc_mcas) & cas_0_rw) |
                     (rs_state == rs_write & bf_tcasbusy));

assign di_id = di_request ? cas_0_id : 0;

assign dqs_request = ((ecmd == ebc_scas | ecmd == ebc_mcas) & cas_0_rw);

reg do_valid_0;
reg do_valid_1;
reg do_valid_2;
reg do_valid_3;
reg do_valid_4;

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        do_valid_4 = 1'b0;
        do_valid_3 = 1'b0;
        do_valid_2 = 1'b0;
        do_valid_1 = 1'b0;
        do_valid_0 = 1'b0;
        do_valid  <= 1'b0;
    end
    else begin
        do_valid_4 = do_valid_3;
        do_valid_3 = do_valid_2;
        do_valid_2 = do_valid_1;
        do_valid_1 = do_valid_0;
        do_valid_0 = ((ecmd == ebc_scas | ecmd == ebc_mcas) & ~cas_0_rw) |
            		  (rs_state == rs_read & bf_tcasbusy);
		case(tcl) // synopsys parallel_case
        	0 		: do_valid  <= do_valid_0;
        	1 		: do_valid  <= do_valid_1;
        	2 		: do_valid  <= do_valid_2;
        	3 		: do_valid  <= do_valid_3;
			default : do_valid  <= do_valid_4;
		endcase
    end
end

reg [ID:0] do_id_0;
reg [ID:0] do_id_1;
reg [ID:0] do_id_2;
reg [ID:0] do_id_3;
reg [ID:0] do_id_4;

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        do_id_4 = 0;
        do_id_3 = 0;
        do_id_2 = 0;
        do_id_1 = 0;
        do_id_0 = 0;
        do_id  <= 0;
    end
    else begin
        do_id_4 = do_id_3;
        do_id_3 = do_id_2;
        do_id_2 = do_id_1;
        do_id_1 = do_id_0;
        do_id_0 = ((ecmd == ebc_scas | ecmd == ebc_mcas) & ~cas_0_rw) ? cas_0_id : do_id_0;
		case(tcl) // synopsys parallel_case
        	0 		: do_id  <= do_id_0;
        	1 		: do_id  <= do_id_1;
        	2 		: do_id  <= do_id_2;
        	3 		: do_id  <= do_id_3;
			default : do_id  <= do_id_4;
		endcase
    end
end

reg bf_last_0;
reg bf_last_1;
reg bf_last_2;
reg bf_last_3;
reg bf_last_4;

reg cas_pm_0;

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        bf_last_4 = 1'b0;
        bf_last_3 = 1'b0;
        bf_last_2 = 1'b0;
        bf_last_1 = 1'b0;
        bf_last_0 = 1'b0;
        bf_last  <= 1'b0;
        cas_pm_0  = 1'b0;
    end
    else begin
        bf_last_4 = bf_last_3;
        bf_last_3 = bf_last_2;
        bf_last_2 = bf_last_1;
        bf_last_1 = bf_last_0 & ~cas_pm_0; // Mask First Read Last When Page Miss Occurs
        bf_last_0 = (ecmd == ebc_scas & ~cas_0_rw) | (bf_tlast & rs_state == rs_read);
        if (ecmd == ebc_scas | ecmd == ebc_mcas)
        	cas_pm_0 = cas_0_pm & ~cas_0_rw & ~cas_empty;
		case(tcl) // synopsys parallel_case
        	0 		: bf_last  <= bf_last_0;
        	1 		: bf_last  <= bf_last_1;
        	2 		: bf_last  <= bf_last_2;
        	3 		: bf_last  <= bf_last_3;
			default : bf_last  <= bf_last_4;
		endcase
    end
end

//-----------------------------------------------------------------------------------
// operation decoding
//-----------------------------------------------------------------------------------

// pre decoding
always @(rs_state or rs_read or rs_idle or rs_wstop or rs_write or rs_wtwr1 or 
         rescmd or res0cmd or res1cmd or res2cmd or res3cmd or rs_wtwr2 or
         cas_0_rw or ras_0_ba or bf_tcasbusy or read_bstop or rw_bstop)
begin
    case(rs_state)
      rs_idle :
      begin
        bf_0cmd  <= res0cmd;
        bf_1cmd  <= res1cmd;
        bf_2cmd  <= res2cmd;
        bf_3cmd  <= res3cmd;
        ecmd     <= {1'b0, rescmd};
      end
      rs_wstop :
      begin
        bf_0cmd  <= res0cmd;
        bf_1cmd  <= res1cmd;
        bf_2cmd  <= res2cmd;
        bf_3cmd  <= res3cmd;
        ecmd     <= {1'b0, rescmd};
      end
      rs_wtwr1, rs_wtwr2 :
      begin
        if (~bf_tcasbusy) begin
            bf_0cmd  <= bc_null;
            bf_1cmd  <= bc_null;
            bf_2cmd  <= bc_null;
            bf_3cmd  <= bc_null;
            ecmd     <= bc_null;
        end
        else begin
            bf_0cmd  <= res0cmd;
            bf_1cmd  <= res1cmd;
            bf_2cmd  <= res2cmd;
            bf_3cmd  <= res3cmd;
            ecmd     <= {1'b0, rescmd};
        end
      end
      rs_write :
      begin
        case(rescmd)
          bc_pc :
          begin
            bf_0cmd  <= bc_null;
            bf_1cmd  <= bc_null;
            bf_2cmd  <= bc_null;
            bf_3cmd  <= bc_null;
            ecmd     <= bc_null;
          end
          bc_epc :
          begin
            bf_0cmd  <= bc_null;
            bf_1cmd  <= bc_null;
            bf_2cmd  <= bc_null;
            bf_3cmd  <= bc_null;
            ecmd     <= bc_null;
          end
          bc_scas , bc_mcas :
          begin
            bf_0cmd  <= res0cmd;
            bf_1cmd  <= res1cmd;
            bf_2cmd  <= res2cmd;
            bf_3cmd  <= res3cmd;
            ecmd     <= {1'b0, rescmd};
          end
          default :
          begin
            if (~bf_tcasbusy) begin
                bf_0cmd  <= bc_null;
                bf_1cmd  <= bc_null;
                bf_2cmd  <= bc_null;
                bf_3cmd  <= bc_null;
                ecmd     <= bc_null;
            end
            else begin
                bf_0cmd  <= res0cmd;
                bf_1cmd  <= res1cmd;
                bf_2cmd  <= res2cmd;
                bf_3cmd  <= res3cmd;
                ecmd     <= {1'b0, rescmd};
            end
          end
        endcase
      end
      default :
      begin
        if (rs_state == rs_read) begin
            if (((rescmd == bc_scas | rescmd == bc_mcas) & cas_0_rw) |
                (rescmd == bc_null & ~bf_tcasbusy)) begin
                bf_0cmd  <= bc_null;
                bf_1cmd  <= bc_null;
                bf_2cmd  <= bc_null;
                bf_3cmd  <= bc_null;
                ecmd     <= ebc_bstop;
            end
            else begin
                bf_0cmd  <= res0cmd;
                bf_1cmd  <= res1cmd;
                bf_2cmd  <= res2cmd;
                bf_3cmd  <= res3cmd;
                ecmd     <= {1'b0, rescmd};
            end
        end
        else if (rw_bstop) begin
            bf_0cmd  <= bc_null;
            bf_1cmd  <= bc_null;
            bf_2cmd  <= bc_null;
            bf_3cmd  <= bc_null;
            ecmd     <= ebc_null;
        end
        else if (rescmd == bc_null & read_bstop) begin
            bf_0cmd  <= bc_null;
            bf_1cmd  <= bc_null;
            bf_2cmd  <= bc_null;
            bf_3cmd  <= bc_null;
            ecmd     <= ebc_bstop;
        end
        else begin
            bf_0cmd  <= res0cmd;
            bf_1cmd  <= res1cmd;
            bf_2cmd  <= res2cmd;
            bf_3cmd  <= res3cmd;
            ecmd     <= {1'b0, rescmd};
        end
      end
    endcase
end

// main decoding
reg [3:0] pttn;
reg COEN;
reg AOEN;
always @(negedge nPOR or posedge ACLK)
begin
	if (!nPOR) begin
		pttn     = 4'hf;
//		tclp     = 2;
		SD_ADDR  <= 0;
		SD_BADDR <= 0;
    	SD_CSB  <= 1'b1;
    	SD_RASB <= 1'b1;
    	SD_CASB <= 1'b1;
    	SD_WEB  <= 1'b1;
    	SD_CKE  <= 1'b0;
    	COEN    <= 1'b1;
    	AOEN    <= 1'b1;
	end
	else begin
    	case(ercmd)
    	  	erc_idle    : begin
				pttn  = cmd_nop;
    			COEN  <= 1'b0;
    			AOEN    <= 1'b1;
			end
    	  	erc_powerup : begin
				pttn  = cmd_nop;
    			COEN  <= 1'b0;
    			AOEN    <= 1'b1;
			end
    	  	erc_epc :
    	  	begin
    	  	  	pttn    = cmd_precharge;
    			COEN  <= 1'b0;
    	  	  	SD_ADDR[10] <= 1;
    			AOEN    <= 1'b0;
    	  	end
    	  	erc_ar : begin
    	  	  	pttn    = cmd_autorefresh;
    			COEN  <= 1'b0;
    			AOEN    <= 1'b1;	
			end
    	  	erc_mrs : 
    	  	begin
    	    	pttn    = cmd_moderegset;
    			COEN  <= 1'b0;
        		if (stable_cnt == 5) begin
        			SD_BADDR 	 <= 2'b01; // EMR
        			SD_ADDR[0]	 <= DisableDLL;
        			SD_ADDR[1]	 <= ReducedDrv;
        			SD_ADDR[RAW:2]<= 0;
    				AOEN    <= 1'b0;
        		end
        		else begin
        			SD_BADDR 	 <= 2'b00; // LMR
        			SD_ADDR[3:0] <= 4'b0011; // burst 8 mode
            		SD_ADDR[6:4] <= tclp; 	// cas latency
            		SD_ADDR[7]   <= 1'b0;
            		SD_ADDR[8]   <= ResetDLL; // Reset DLL
    				AOEN    <= 1'b0;
        		end
        	end
    	  	default :
    	  	begin
    	    	case(ecmd)
    	    	  ebc_pc :
    	    	  begin
    	    	  	pttn     = cmd_precharge;
    				COEN  <= 1'b0;
    	    	  	if      (bf_0reqcmd == bc_pc) SD_BADDR <= 2'b00;
    	    	  	else if (bf_1reqcmd == bc_pc) SD_BADDR <= 2'b01;
    	    	  	else if (bf_2reqcmd == bc_pc) SD_BADDR <= 2'b10;
    	    	  	else                          SD_BADDR <= 2'b11;
    	    	  	SD_ADDR[10] <= 0;
    				AOEN    <= 1'b0;
    	    	  end
    	    	  ebc_epc :
    	    	  begin
    	    	    pttn        = cmd_precharge;
    				COEN  <= 1'b0;
    	    	    SD_ADDR[10] <= 1;
    				AOEN    <= 1'b0;
    	    	  end
    	    	  ebc_sras, ebc_mras :
    	    	  begin
    	    	    pttn        = cmd_setrowaddr;
    				COEN  <= 1'b0;
    	    	    SD_BADDR    <= ras_0_ba;
    	    	    SD_ADDR     <= ras_0_ra;
    				AOEN    <= 1'b0;
    	    	  end
    	    	  ebc_scas, ebc_mcas :
    	    	  begin
    	    	    if (~cas_0_rw) pttn   = cmd_read;
    	    	    else           pttn   = cmd_write;
    				COEN  <= 1'b0;
    	    	    SD_BADDR    <= cas_0_ba;
    	    	    SD_ADDR     <= {{(RAW-CAW){1'b0}}, cas_0_ca};
    				AOEN    <= 1'b0;
    	    	  end
    	    	  ebc_bstop : begin
    	    	    pttn        = cmd_burststop;
    				COEN  <= 1'b0;
    				AOEN    <= 1'b1;
				  end
    	    	  default : begin
    	    	    pttn        = cmd_nop;
    				COEN  <= 1'b1;
    				AOEN    <= 1'b1;
				  end
    	    	endcase
    	  	end
    	endcase
    	SD_CSB  <= pttn[3];
    	SD_RASB <= pttn[2];
    	SD_CASB <= pttn[1];
    	SD_WEB  <= pttn[0];
    	SD_CKE  <= iSD_CKE;
    end
end

//-----------------------------------------------------------------------------------
// cas event queue & ras event queue
//-----------------------------------------------------------------------------------

DDRCas CasQ (
    .ARESETB       (ARESETB),
    .ACLK          (ACLK),
    .BA_BA         (BA_BA),
    .BA_RA         (BA_RA),
    .BA_CA         (BA_CA),
    .BA_TT         (BA_TT),
    .BA_ID		   (BA_ID),
    .BA_RW         (BA_RW),
    .BA_PM		   (BA_PM),
    .BA_REQ        (i_ba_req),
    .CMD           (ecmd[5:0]),
    .B0_LAST_RA    (b0_last_ra),
    .B1_LAST_RA    (b1_last_ra),
    .B2_LAST_RA    (b2_last_ra),
    .B3_LAST_RA    (b3_last_ra),
    .CAS_0_BA      (cas_0_ba),
    .CAS_0_RA      (cas_0_ra),
    .CAS_0_CA      (cas_0_ca),
    .CAS_0_TT      (cas_0_tt),
    .CAS_0_ID  	   (cas_0_id),
    .CAS_0_RW      (cas_0_rw),
    .CAS_0_PM      (cas_0_pm),
    .CAS_0_FINAL   (cas_0_final),
    .CAS_0_NEWROW  (cas_0_newrow),
    .CAS_EMPTY     (cas_empty),
    .CAS_FULL      (cas_full)
);
                    
DDRRas RasQ (
    .ARESETB       (ARESETB),
    .ACLK          (ACLK),
    .BA_BA         (BA_BA),
    .BA_RA         (BA_RA),
    .BA_TT         (BA_TT),
    .BA_REQ        (i_ba_req),
    .CMD           (ecmd[5:0]),
    .CLOSING       (closing),
    .B0_LAST_RA    (b0_last_ra),
    .B1_LAST_RA    (b1_last_ra),
    .B2_LAST_RA    (b2_last_ra),
    .B3_LAST_RA    (b3_last_ra),
    .RAS_0_BA      (ras_0_ba),
    .RAS_0_RA      (ras_0_ra),
    .RAS_0_TT      (ras_0_tt),
    .RAS_EMPTY     (ras_empty),
    .RAS_HEMPTY    (ras_hempty),
    .RAS_FULL      (ras_full)
);

assign  cmd_full  = cas_full  | ras_full;
assign  cmd_empty = cas_empty & ras_empty;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
reg FullStatus;
always @(negedge ARESETB or posedge ACLK)
begin
	if (!ARESETB) FullStatus <= 1'b0;
	else if (SDREnStatus & SDRBusy & (RQFull | WQFull)) begin
		FullStatus <= 1'b1;
		$display("Note : Make Bigger FIFO: %t  Current Data Count: %b%b", $time, RQFull, WQFull);
//		$stop;
	end
	else FullStatus <= 1'b0;
end

/*
always @(bf_tidle)
begin
    if (bf_tidle)
	$display("Note : All Bank Closed at Controller: %t", $time);
end
*/
reg di_request_d1;
reg di_request_d2;
always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) di_request_d1 <= 0;
	else		  di_request_d1 <= di_request;

always @(negedge ARESETB or posedge ACLK)
	if (!ARESETB) di_request_d2 <= 0;
	else		  di_request_d2 <= di_request_d1;

reg RWCollision0;
reg RWCollision1;
reg RWCollision;
always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin 
		RWCollision0 <= 1'b0;
		RWCollision1 <= 1'b0;
		RWCollision  <= 1'b0;
	end
	else if (SDREnStatus & SDRBusy & do_valid & ((tclp==2 & di_request) | (tclp==6 & di_request_d1))) begin
		RWCollision0 <= 1'b1;
	end
	else begin
		RWCollision0 <= 1'b0;
		RWCollision1 <= RWCollision0;
		RWCollision  <= RWCollision0 & RWCollision1; 
		if (RWCollision) $display("Note : Read/Write Collision: %t", $time);
//		$stop;
	end
end

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
