
`timescale 1ns/10ps
//-----------------------------------------------------------------------------------
// Purpose : interface with 256 M bit sdram(4 bank x 4096 row x 256 column x 64 bit)
//-----------------------------------------------------------------------------------

module SDRRas (
    ARESETB , // asynchronous reset
    ACLK    ,

	RASUPDATE,
    BA_BA 	, // bank address
    BA_RA 	, // row address
    BA_TT 	, // transaction type
    BA_REQ	, // request

    CMD        ,
    CLOSING    ,
    B0_LAST_RA ,
    B1_LAST_RA ,
    B2_LAST_RA ,
    B3_LAST_RA ,
    RAS_0_BA   ,
    RAS_0_RA   ,
    RAS_0_TT   ,
    RAS_EMPTY  ,
    RAS_HEMPTY ,
    RAS_FULL
);    

`include "../Rtl/SDRPara.v"

input          	ARESETB; 
input          	ACLK; 
input			RASUPDATE;
input  [BAW:0] 	BA_BA; 
input  [RAW:0] 	BA_RA; 
input  [TL:0]  	BA_TT; 
input          	BA_REQ; 
input  [ 5:0]  	CMD;
input          	CLOSING;
output [RAW+1:0] B0_LAST_RA; 
output [RAW+1:0] B1_LAST_RA; 
output [RAW+1:0] B2_LAST_RA; 
output [RAW+1:0] B3_LAST_RA; 
output [BAW:0] 	RAS_0_BA; 
output [RAW:0] 	RAS_0_RA; 
output [TL:0] 	RAS_0_TT; 
output        	RAS_EMPTY; 
output        	RAS_HEMPTY; 
output        	RAS_FULL; 

reg [BAW:0] RAS_0_BA; 
reg [RAW:0] RAS_0_RA; 
reg [TL:0] RAS_0_TT; 
reg        RAS_EMPTY ; 
reg        RAS_HEMPTY; 
reg        RAS_FULL; 
    
// global signals
reg [RAW+1:0] l_b0_last_ra;
reg [RAW+1:0] l_b1_last_ra;
reg [RAW+1:0] l_b2_last_ra;
reg [RAW+1:0] l_b3_last_ra;
reg [RasQW:0] ras_1_data;
reg [RasQW:0] ras_2_data;
reg [RasQW:0] ras_3_data;
reg [RasQW:0] ras_4_data;
reg [RasQW:0] ras_5_data;
reg [RasQW:0] ras_6_data;
reg [RasQW:0] ras_7_data;

// aliases
assign B0_LAST_RA = l_b0_last_ra;
assign B1_LAST_RA = l_b1_last_ra;
assign B2_LAST_RA = l_b2_last_ra;
assign B3_LAST_RA = l_b3_last_ra;

reg [CD:0] ras_cnt;

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        ras_cnt       = 0;
        RAS_EMPTY    <= 1'b1;
        RAS_HEMPTY   <= 1'b1;
        RAS_FULL     <= 1'b0;
        l_b0_last_ra <= {1'b1, {RAW+1{1'b0}}};
        l_b1_last_ra <= {1'b1, {RAW+1{1'b0}}};
        l_b2_last_ra <= {1'b1, {RAW+1{1'b0}}};
        l_b3_last_ra <= {1'b1, {RAW+1{1'b0}}};
        // redundant, for synthesis
        RAS_0_BA     <= 0;
        RAS_0_RA     <= 0;
        RAS_0_TT     <= 0;
        ras_1_data   <= 0;
        ras_2_data   <= 0;
        ras_3_data   <= 0;
        ras_4_data   <= 0;
        ras_5_data   <= 0;
        ras_6_data   <= 0;
        ras_7_data   <= 0;
    end
    else begin
        if (CLOSING) begin
            l_b0_last_ra <= {1'b1, {RAW+1{1'b0}}};
            l_b1_last_ra <= {1'b1, {RAW+1{1'b0}}};
            l_b2_last_ra <= {1'b1, {RAW+1{1'b0}}};
            l_b3_last_ra <= {1'b1, {RAW+1{1'b0}}};
        end
        // process ras event
        if (CMD == bc_sras | CMD == bc_mras) begin
            if (ras_cnt != 0) begin
                RAS_0_BA   <= ras_1_data[RasQW:RasQW-BAW];	// 17:16
                RAS_0_RA   <= ras_1_data[RAW+TL+1: TL+1]; // 15:4
                RAS_0_TT   <= ras_1_data[TL: 0]; 		//  3:0
                ras_1_data <= ras_2_data;
                ras_2_data <= ras_3_data;
                ras_3_data <= ras_4_data;
                ras_4_data <= ras_5_data;
                ras_5_data <= ras_6_data;
                ras_6_data <= ras_7_data;
                ras_7_data <= 0;
                ras_cnt     = ras_cnt - 1;
            end
        end
        // save ras event
        if (RASUPDATE ? BA_REQ :
            (BA_REQ &&
            ((BA_BA == 2'b00 && ({1'b0, BA_RA} != l_b0_last_ra))||
             (BA_BA == 2'b01 && ({1'b0, BA_RA} != l_b1_last_ra))||
             (BA_BA == 2'b10 && ({1'b0, BA_RA} != l_b2_last_ra))||
             (BA_BA == 2'b11 && ({1'b0, BA_RA} != l_b3_last_ra))|| 
             (CLOSING)))) begin	// Fix Architecture Bug 2006/06/23
            case(BA_BA)
              2'b00   : l_b0_last_ra <= {1'b0, BA_RA};
              2'b01   : l_b1_last_ra <= {1'b0, BA_RA};
              2'b10   : l_b2_last_ra <= {1'b0, BA_RA};
              2'b11   : l_b3_last_ra <= {1'b0, BA_RA};
            endcase
            case(ras_cnt)
              		0 : begin
                        RAS_0_BA   <= BA_BA;
                        RAS_0_RA   <= BA_RA;
                        RAS_0_TT   <= BA_TT;
                        end
              		1 : ras_1_data <= {BA_BA, BA_RA, BA_TT};
              		2 : ras_2_data <= {BA_BA, BA_RA, BA_TT};
              		3 : ras_3_data <= {BA_BA, BA_RA, BA_TT};
              		4 : ras_4_data <= {BA_BA, BA_RA, BA_TT};
              		5 : ras_5_data <= {BA_BA, BA_RA, BA_TT};
              		6 : ras_6_data <= {BA_BA, BA_RA, BA_TT};
              		7 : ras_7_data <= {BA_BA, BA_RA, BA_TT};
            endcase
            if (ras_cnt <= 7) begin
                ras_cnt = ras_cnt + 1;
            end
        end
        if (ras_cnt == 0)
             RAS_EMPTY  <= 1'b1;
        else RAS_EMPTY  <= 1'b0;
        if (ras_cnt <= 3)
             RAS_HEMPTY <= 1'b1;
        else RAS_HEMPTY <= 1'b0;
        if (ras_cnt >= 7)
             RAS_FULL   <= 1'b1;
        else RAS_FULL   <= 1'b0;
    end
end

endmodule
