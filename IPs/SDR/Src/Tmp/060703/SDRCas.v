
`timescale 1ns/10ps

module SDRCas (
    ARESETB,
    ACLK   ,

    BA_BA 	,
    BA_RA 	,
    BA_CA 	,
    BA_TT 	,
    BA_ID 	,
    BA_RW 	,
    BA_REQ	,
    BA_PM	,

    CMD       ,
    B0_LAST_RA,
    B1_LAST_RA,
    B2_LAST_RA,
    B3_LAST_RA,
    CAS_0_BA  ,
    CAS_0_RA  ,
    CAS_0_CA  ,
    CAS_0_TT  ,
    CAS_0_ID  ,
    CAS_0_RW  ,
    CAS_0_PM  ,
    CAS_0_FINAL,
    CAS_0_NEWROW,
    CAS_EMPTY,
    CAS_FULL
);

`include "../Rtl/SDRPara.v"

input         ARESETB; // asynchronous reset
input         ACLK    ;
input  [BAW:0] BA_BA; // bank address
input  [RAW:0] BA_RA; // row address
input  [CAW:0] BA_CA; // column address
input  [BL:0] BA_TT; // transaction type
input         BA_RW; // read/write
input         BA_REQ; // request
input  [ID:0] BA_ID;
input		  BA_PM;
input  [ 5:0] CMD   ;
input  [RAW+1:0] B0_LAST_RA;
input  [RAW+1:0] B1_LAST_RA;
input  [RAW+1:0] B2_LAST_RA;
input  [RAW+1:0] B3_LAST_RA;
output [BAW:0] CAS_0_BA;
output [RAW:0] CAS_0_RA;
output [CAW:0] CAS_0_CA;
output [BL:0]  CAS_0_TT;
output [ID:0] CAS_0_ID;
output        CAS_0_RW;
output		  CAS_0_PM;
output        CAS_0_FINAL;
output        CAS_0_NEWROW;
output        CAS_EMPTY;
output        CAS_FULL;
    
// global signals
reg [BAW:0] CAS_0_BA;
reg [RAW:0] CAS_0_RA;
reg [CAW:0] CAS_0_CA;
reg [BL:0]  CAS_0_TT;
reg [ID:0]  CAS_0_ID;
reg        CAS_0_PM;
reg        CAS_0_RW;
reg        CAS_0_FINAL;
reg        CAS_0_NEWROW;
reg        CAS_EMPTY;
reg        CAS_FULL;

reg [CasQW:0] cas_1_data;
reg [CasQW:0] cas_2_data;
reg [CasQW:0] cas_3_data;
reg [CasQW:0] cas_4_data;
reg [CasQW:0] cas_5_data;
reg [CasQW:0] cas_6_data;
reg [CasQW:0] cas_7_data;

reg cas_1_final ;
reg cas_1_newrow;
reg cas_2_final ;
reg cas_2_newrow;
reg cas_3_final ;
reg cas_3_newrow;
reg cas_4_final ;
reg cas_4_newrow;
reg cas_5_final ;
reg cas_5_newrow;
reg cas_6_final ;
reg cas_6_newrow;
reg cas_7_final ;
reg cas_7_newrow;

reg [CD:0] cas_cnt;
reg [CD:0] cas_cnt_pos;
reg [CD:0] cas_cnt_b0_pos;
reg [CD:0] cas_cnt_b1_pos;
reg [CD:0] cas_cnt_b2_pos;
reg [CD:0] cas_cnt_b3_pos;

always @(negedge ARESETB or posedge ACLK)
begin
    if (!ARESETB) begin
        cas_cnt         = 0;
        cas_cnt_b0_pos  = {CD+1{1'b1}};
        cas_cnt_b1_pos  = {CD+1{1'b1}};
        cas_cnt_b2_pos  = {CD+1{1'b1}};
        cas_cnt_b3_pos  = {CD+1{1'b1}};
        CAS_EMPTY      <= 1;
        CAS_FULL       <= 0;
        // redundant, for synthesis
        CAS_0_BA       <= 0;
        CAS_0_RA       <= 0;
        CAS_0_CA       <= 0;
        CAS_0_TT       <= 0;
        CAS_0_ID	   <= 0;
        CAS_0_RW       <= 0;
        CAS_0_PM       <= 0;
        CAS_0_FINAL    <= 0;
        CAS_0_NEWROW   <= 0;
        cas_1_data     <= 0;
        cas_1_final    <= 0;
        cas_1_newrow   <= 0;
        cas_2_data     <= 0;
        cas_2_final    <= 0;
        cas_2_newrow   <= 0;
        cas_3_data     <= 0;
        cas_3_final    <= 0;
        cas_3_newrow   <= 0;
        cas_4_data     <= 0;
        cas_4_final    <= 0;
        cas_4_newrow   <= 0;
        cas_5_data     <= 0;
        cas_5_final    <= 0;
        cas_5_newrow   <= 0;
        cas_6_data     <= 0;
        cas_6_final    <= 0;
        cas_6_newrow   <= 0;
        cas_7_data     <= 0;
        cas_7_final    <= 0;
        cas_7_newrow   <= 0;
    end
    else begin
        // process command
        if (CMD == bc_scas | CMD == bc_mcas) begin
            CAS_0_ID     <= cas_1_data[CasQW:CasQW-ID]; // 30:27
            CAS_0_BA     <= cas_1_data[BAW+RAW+CAW+BL+5:RAW+CAW+BL+5]; // 26:25
            CAS_0_RA     <= cas_1_data[RAW+CAW+BL+4:CAW+BL+4]; // 24:13
            CAS_0_CA     <= cas_1_data[CAW+BL+3: BL+3]; // 12:5
            CAS_0_TT     <= cas_1_data[BL+2: 2]; // 4:1
            CAS_0_RW     <= cas_1_data[1];
            CAS_0_PM     <= cas_1_data[0];
            CAS_0_FINAL  <= cas_1_final;
            CAS_0_NEWROW <= cas_1_newrow;
            cas_1_data   <= cas_2_data;
            cas_1_final  <= cas_2_final;
            cas_1_newrow <= cas_2_newrow;
            cas_2_data   <= cas_3_data;
            cas_2_final  <= cas_3_final;
            cas_2_newrow <= cas_3_newrow;
            cas_3_data   <= cas_4_data;
            cas_3_final  <= cas_4_final;
            cas_3_newrow <= cas_4_newrow;
            cas_4_data   <= cas_5_data;
            cas_4_final  <= cas_5_final;
            cas_4_newrow <= cas_5_newrow;
            cas_5_data   <= cas_6_data;
            cas_5_final  <= cas_6_final;
            cas_5_newrow <= cas_6_newrow;
            cas_6_data   <= cas_7_data;
            cas_6_final  <= cas_7_final;
            cas_6_newrow <= cas_7_newrow;

            cas_cnt       = cas_cnt - 1;
            if (cas_cnt_b0_pos != {CD+1{1'b1}}) begin
                cas_cnt_b0_pos  = cas_cnt_b0_pos - 1;
            end
            if (cas_cnt_b1_pos != {CD+1{1'b1}}) begin
                cas_cnt_b1_pos  = cas_cnt_b1_pos - 1;
            end
            if (cas_cnt_b2_pos != {CD+1{1'b1}}) begin
                cas_cnt_b2_pos  = cas_cnt_b2_pos - 1;
            end
            if (cas_cnt_b3_pos != {CD+1{1'b1}}) begin
                cas_cnt_b3_pos  = cas_cnt_b3_pos - 1;
            end
        end
        // save command
        if (BA_REQ) begin
            if (cas_cnt != 0) begin
                case(BA_BA)
                  2'b00   : cas_cnt_pos  = cas_cnt_b0_pos;
                  2'b01   : cas_cnt_pos  = cas_cnt_b1_pos;
                  2'b10   : cas_cnt_pos  = cas_cnt_b2_pos;
                  2'b11   : cas_cnt_pos  = cas_cnt_b3_pos;
                endcase
                if ((BA_BA == 2'b00 && {1'b0 , BA_RA} == B0_LAST_RA) |
                    (BA_BA == 2'b01 && {1'b0 , BA_RA} == B1_LAST_RA) |
                    (BA_BA == 2'b10 && {1'b0 , BA_RA} == B2_LAST_RA) |
                    (BA_BA == 2'b11 && {1'b0 , BA_RA} == B3_LAST_RA)) begin
                    case(cas_cnt_pos)
                      		0 : CAS_0_FINAL <= 0;
                      		1 : cas_1_final <= 0;
                      		2 : cas_2_final <= 0;
                      		3 : cas_3_final <= 0;
                     		4 : cas_4_final <= 0;
                      		5 : cas_5_final <= 0;
                      		6 : cas_6_final <= 0;
                      		7 : cas_7_final <= 0;

                    endcase
                end
                else begin
                    case(cas_cnt_pos)
                      		0 : CAS_0_NEWROW <= 1;
                      		1 : cas_1_newrow <= 1;
                      		2 : cas_2_newrow <= 1;
                      		3 : cas_3_newrow <= 1;
                      		4 : cas_4_newrow <= 1;
                      		5 : cas_5_newrow <= 1;
                      		6 : cas_6_newrow <= 1;
                      		7 : cas_7_newrow <= 1;
                    endcase
                end
            end
            case(BA_BA)
              2'b00   : cas_cnt_b0_pos  = cas_cnt;
              2'b01   : cas_cnt_b1_pos  = cas_cnt;
              2'b10   : cas_cnt_b2_pos  = cas_cnt;
              2'b11   : cas_cnt_b3_pos  = cas_cnt;
            endcase
            case(cas_cnt)
              		0 : begin
                        CAS_0_BA     <= BA_BA;
                        CAS_0_RA     <= BA_RA;
                        CAS_0_CA     <= BA_CA;
                        CAS_0_TT     <= BA_TT;
                        CAS_0_ID     <= BA_ID;
                        CAS_0_RW     <= BA_RW;
                        CAS_0_PM     <= BA_PM;
                        CAS_0_FINAL  <= 1;
                        CAS_0_NEWROW <= 0;
                        end
              		1 : begin
                        cas_1_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1_final  <= 1;
                        cas_1_newrow <= 0;
                        end
              		2 : begin
                        cas_2_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2_final  <= 1;
                        cas_2_newrow <= 0;
                        end
              		3 : begin
                        cas_3_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3_final  <= 1;
                        cas_3_newrow <= 0;
                        end
             		4 : begin
                        cas_4_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_4_final  <= 1;
                        cas_4_newrow <= 0;
                        end
              		5 : begin
                        cas_5_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_5_final  <= 1;
                        cas_5_newrow <= 0;
                        end
              		6 : begin
                        cas_6_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_6_final  <= 1;
                        cas_6_newrow <= 0;
                        end
              		7 : begin
                        cas_7_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_7_final  <= 1;
                        cas_7_newrow <= 0;
                        end
            endcase
            if (cas_cnt <= 7) begin
                cas_cnt  = cas_cnt + 1;
            end
        end
        if (cas_cnt == 0)
             CAS_EMPTY <= 1;
        else CAS_EMPTY <= 0;
        if (cas_cnt >= 7)
             CAS_FULL  <= 1;
        else CAS_FULL  <= 0;
    end
end

endmodule