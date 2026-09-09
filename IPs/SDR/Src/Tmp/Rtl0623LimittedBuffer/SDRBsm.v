
`timescale 1ns/10ps

module SDRBsm (
    ARESETB      ,
    ACLK          ,
    TRP          ,
    TRRD         ,
    TRCD         ,
    TRASMIN      ,
    BA_BA        ,
    BA_RA        ,
    BA_TT        ,
    BA_REQ       ,
    CAS_0_BA     ,
    CAS_0_RA     ,
    CAS_0_TT     ,
    CAS_0_FINAL  ,
    CAS_0_NEWROW ,
    CAS_EMPTY    ,
    LAST_RA      ,
    RAS_0_BA     ,
    RAS_0_RA     ,
    RAS_0_TT     ,
    RAS_EMPTY    ,
    BF_NO        ,
    BF_CASBUSY   ,
    BF_TCASBUSY  ,
    BF_RASBUSY   ,
    BF_TRASBUSY  ,
    BF_READY     ,
    BF_TREADY    ,
    BF_IDLE      ,
    BF_LAST      ,
    BF_REQCMD    ,
    BF_CMD       ,
    ERCMD        ,
    ECMD
);

`include "../Rtl/SDRPara.v"

input     		ARESETB     ;                      // asynchronous reset
input     		ACLK         ;
input  [ 1:0] 	TRP         ;
input  [ 1:0] 	TRRD        ;
input  [ 1:0] 	TRCD        ;
input  [ 3:0] 	TRASMIN     ;
input  [BAW:0]	BA_BA       ; // bank address
input  [RAW:0]	BA_RA       ; // row address
input  [BL:0] 	BA_TT       ; // transaction type
input     		BA_REQ      ; // request
input  [BAW:0]	CAS_0_BA    ;
input  [RAW:0]	CAS_0_RA    ;
input  [BL:0] 	CAS_0_TT    ;
input     		CAS_0_FINAL ;
input     		CAS_0_NEWROW;
input     		CAS_EMPTY   ;
input  [RAW+1:0]LAST_RA     ;
input  [BAW:0]	RAS_0_BA    ;
input  [RAW:0]	RAS_0_RA    ;
input  [BL:0] 	RAS_0_TT    ;
input     		RAS_EMPTY   ;
input  [BAW:0]	BF_NO       ; // constant could be used
output    		BF_CASBUSY  ;
input     		BF_TCASBUSY ;
output    		BF_RASBUSY  ;
input     		BF_TRASBUSY ;
output    		BF_READY    ;
input     		BF_TREADY   ;
output    		BF_IDLE     ;
output 			BF_LAST     ;
output [ 5:0]	BF_REQCMD   ; // request command
input  [ 5:0]  	BF_CMD      ;
input  [ 5:0]	ERCMD       ;
input  [ 6:0]	ECMD        ;
    
// finite state machine
parameter bs_idle    = 5'b00001; 
parameter bs_pcing   = 5'b00010;
parameter bs_rowopen = 5'b00100; 
parameter bs_rasing  = 5'b01000; 
parameter bs_casing  = 5'b10000;

reg [4:0] currstate, nextstate;

wire cbs_idle    = currstate[0]; 
wire cbs_pcing   = currstate[1];
wire cbs_rowopen = currstate[2]; 
wire cbs_rasing  = currstate[3]; 
wire cbs_casing  = currstate[4];

// counters
reg [1:0] trp_cnt ;
reg [1:0] trrd_cnt;
reg [1:0] trcd_cnt;
reg [3:0] trasmin_cnt;
reg [BL:0] length;

// global regs
reg [5:0] i_bf_reqcmd; // request command
reg newrowenable;
reg newrowexist;

// alias
assign  BF_REQCMD = i_bf_reqcmd;

// counters
always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        trp_cnt     <= 0;
        trrd_cnt    <= 0;
        trcd_cnt    <= 0;
        trasmin_cnt <= 0;
        length      <= 0;
    end
    else begin
        if (BF_CMD == bc_pc | BF_CMD == bc_epc |
            ERCMD == erc_epc | (ERCMD == erc_normal & ECMD == ebc_epc))
            trp_cnt <= TRP;
        else if (trp_cnt != 0)
            trp_cnt <= trp_cnt - 1;
        if (BF_CMD == bc_sras | BF_CMD == bc_mras) begin
            trrd_cnt    <= TRRD;
            trcd_cnt    <= TRCD;
            trasmin_cnt <= TRASMIN;
        end
        else begin
            if (trrd_cnt != 0)
                trrd_cnt <= trrd_cnt - 1;
            if (trcd_cnt != 0)
                trcd_cnt <= trcd_cnt - 1;
            if (trasmin_cnt != 0)
                trasmin_cnt <= trasmin_cnt - 1;
        end
        if (BF_CMD == bc_scas | BF_CMD == bc_mcas) begin
            if (CAS_0_TT <= {BL+1{1'b1}} && CAS_0_TT >= 1)
                length <= CAS_0_TT;
            else
                length <= 0;
        end
        else if (length != 0) begin
            length <= length - 1;
        end
    end
end

assign BF_CASBUSY = (length   == 0) ? 1'b0 : 1'b1;
assign BF_RASBUSY = (trrd_cnt == 0) ? 1'b0 : 1'b1;
assign BF_READY   = ((cbs_rowopen & trasmin_cnt == 0) | cbs_idle) ? 1'b1 : 1'b0;
assign BF_IDLE    = (cbs_idle) ? 1'b1 : 1'b0;
assign BF_LAST    = (length   == 1) ? 1'b1 : 1'b0;

// extra finite state machine
reg cas_0_final_l  ;
reg cas_0_newrow_l ;
reg [RAW:0] openedrow ;

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        newrowenable   <= 1'b0;
        newrowexist    <= 1'b0;
        cas_0_final_l  = 1'b0;
        cas_0_newrow_l = 1'b0;
        openedrow      = {1'b1, {RAW+1{1'b0}}};
    end
    else begin
        case(1'b1)
          cbs_rowopen :
            if (BF_CMD == bc_scas || BF_CMD == bc_mcas) begin
                if (CAS_0_TT == 0) begin
                    if (CAS_0_FINAL)  newrowenable <= 1'b1;
                    if (CAS_0_NEWROW) newrowexist  <= 1'b1;
                end
                else begin
                    cas_0_final_l  = CAS_0_FINAL;
                    cas_0_newrow_l = CAS_0_NEWROW;
                end
            end
            else if (BF_CMD == bc_pc || BF_CMD == bc_epc ||
                ERCMD == erc_epc || (ERCMD == erc_normal && ECMD == ebc_epc)) begin
                newrowenable <= 1'b0;
                newrowexist  <= 1'b0;
            end
          cbs_casing :
            if (length == 1) begin
                if (cas_0_final_l) begin
                    newrowenable <= 1'b1;
                end
                if (cas_0_newrow_l) begin
                    newrowexist <= 1'b1;
                end
            end
        endcase
        if (BA_REQ && BF_NO == BA_BA && {1'b0, BA_RA} == openedrow && LAST_RA == openedrow) begin
            newrowenable <= 1'b0;
        end
        if (BF_CMD == bc_sras | BF_CMD == bc_mras) begin
            openedrow = {1'b0, RAS_0_RA};
        end
    end
end

//------------------------------------------------------------------------------
// operation decoding
//------------------------------------------------------------------------------

// request command
always @(cbs_idle or cbs_rowopen or 
         BF_NO or RAS_0_BA or RAS_0_RA or RAS_0_TT or RAS_EMPTY or BF_TRASBUSY or
         CAS_0_BA or CAS_0_RA or CAS_0_TT or CAS_EMPTY or BF_TCASBUSY or
         BF_TREADY or newrowenable or newrowexist or
         trp_cnt or trasmin_cnt or i_bf_reqcmd)
begin
    i_bf_reqcmd = bc_null;
    case(1'b1)
      cbs_idle :
        if (~RAS_EMPTY && BF_NO == RAS_0_BA && ~BF_TRASBUSY && trp_cnt == 0) begin
            if (RAS_0_TT == 0)
                 i_bf_reqcmd = bc_sras;
            else if (RAS_0_TT <= {BL+1{1'b1}})
                 i_bf_reqcmd = bc_mras;
            else i_bf_reqcmd = bc_null;
        end
        else     i_bf_reqcmd = bc_null;

      cbs_rowopen :
        if    (~CAS_EMPTY && BF_NO == CAS_0_BA && ~RAS_EMPTY && BF_NO == RAS_0_BA) begin
            if (CAS_0_RA == RAS_0_RA)
                if (trasmin_cnt == 0) i_bf_reqcmd = bc_pc;
                else				  i_bf_reqcmd = bc_null;
            else begin
                if (~BF_TCASBUSY) begin
                    if (CAS_0_TT == 0)
                         i_bf_reqcmd = bc_scas;
                    else if (CAS_0_TT <= {BL+1{1'b1}})
                         i_bf_reqcmd = bc_mcas;
                    else i_bf_reqcmd = bc_null;
                end
                else     i_bf_reqcmd = bc_null;
            end
        end
        else if (~CAS_EMPTY && BF_NO == CAS_0_BA) begin
            if (~BF_TCASBUSY) begin
                if (CAS_0_TT == 0)
                     i_bf_reqcmd = bc_scas;
                else if (CAS_0_TT <= {BL+1{1'b1}})
                     i_bf_reqcmd = bc_mcas;
                else i_bf_reqcmd = bc_null;
            end
            else     i_bf_reqcmd = bc_null;
        end
        else if (~RAS_EMPTY && BF_NO == RAS_0_BA) begin
            if (newrowenable && trasmin_cnt == 0)
                 i_bf_reqcmd = bc_pc;
            else i_bf_reqcmd = bc_null;
        end
        else if (newrowexist) begin
            if (trasmin_cnt == 0)
                 i_bf_reqcmd = bc_pc;
            else i_bf_reqcmd = bc_null;
        end
        else if (CAS_EMPTY && RAS_EMPTY) begin
            if (BF_TREADY)
                 i_bf_reqcmd = bc_epc;
            else i_bf_reqcmd = bc_null;
        end
        else     i_bf_reqcmd = bc_null;
    endcase
end

//------------------------------------------------------------------------------
// finite state machine
//------------------------------------------------------------------------------
always @(negedge ARESETB or posedge ACLK)
    if (!ARESETB) currstate <= bs_idle;
    else          currstate <= nextstate;

// next state
always @(cbs_idle or cbs_rowopen or cbs_pcing or cbs_rasing or cbs_casing or
		 BF_NO or RAS_0_BA or RAS_0_RA or RAS_0_TT or RAS_EMPTY or BF_TRASBUSY or
         CAS_0_BA or CAS_0_RA or CAS_0_TT or CAS_EMPTY or BF_TCASBUSY or
         BF_TREADY or newrowenable or newrowexist or
         trp_cnt or trcd_cnt or trasmin_cnt or length or i_bf_reqcmd or BF_CMD)
begin
    nextstate = bs_idle;
    case(1'b1)
      cbs_idle :
        if (~RAS_EMPTY && BF_NO == RAS_0_BA & ~BF_TRASBUSY & trp_cnt == 0) begin
            if (i_bf_reqcmd == BF_CMD) begin // request accepted
                nextstate = bs_rasing;
            end
            else nextstate = bs_idle;
        end
        else     nextstate = bs_idle;
      cbs_pcing :
        if (trp_cnt == 3'b1) 
             nextstate = bs_idle;
        else nextstate = bs_pcing;
      cbs_rasing :
        if (trcd_cnt == 3'b1)
             nextstate = bs_rowopen;
        else nextstate = bs_rasing;
      cbs_rowopen :
        if    (~CAS_EMPTY && BF_NO == CAS_0_BA && ~RAS_EMPTY && BF_NO == RAS_0_BA) begin
            if (CAS_0_RA == RAS_0_RA) begin
                if (trasmin_cnt == 0) begin
                    if (i_bf_reqcmd == BF_CMD)
                         nextstate = bs_pcing;
        		    else nextstate = bs_rowopen;
                end
      		    else     nextstate = bs_rowopen;
            end
            else begin
                if (~BF_TCASBUSY && CAS_0_TT > 0 && CAS_0_TT <= {BL+1{1'b1}}) begin
                    if (i_bf_reqcmd == BF_CMD)
                         nextstate = bs_casing;
        		    else nextstate = bs_rowopen;
                end
      		    else     nextstate = bs_rowopen;
            end
        end
        else if (~CAS_EMPTY & BF_NO == CAS_0_BA) begin
            if (~BF_TCASBUSY && CAS_0_TT > 0 && CAS_0_TT <= {BL+1{1'b1}}) begin
                if (i_bf_reqcmd == BF_CMD)
                     nextstate = bs_casing;
      		    else nextstate = bs_rowopen;
            end
   		    else     nextstate = bs_rowopen;
        end
        else if (~RAS_EMPTY && BF_NO == RAS_0_BA) begin
            if (newrowenable && trasmin_cnt == 0) begin
                if (i_bf_reqcmd == BF_CMD)
                     nextstate = bs_pcing;
      		    else nextstate = bs_rowopen;
            end
   		    else     nextstate = bs_rowopen;
        end
        else if (newrowexist) begin
            if (trasmin_cnt == 0) begin
                if (i_bf_reqcmd == BF_CMD)
                     nextstate = bs_pcing;
      		    else nextstate = bs_rowopen;
            end
   		    else     nextstate = bs_rowopen;
        end
        else if (CAS_EMPTY && RAS_EMPTY) begin
            if (BF_TREADY) begin
                if (i_bf_reqcmd == BF_CMD)
                     nextstate = bs_pcing;
      		    else nextstate = bs_rowopen;
            end
   		    else     nextstate = bs_rowopen;
        end
	    else         nextstate = bs_rowopen;
      cbs_casing :
        if (length == 1) nextstate = bs_rowopen;
        else             nextstate = bs_casing;
    endcase
end
    
endmodule
