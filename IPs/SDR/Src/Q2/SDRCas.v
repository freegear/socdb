
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
input  [TL:0] BA_TT; // transaction type
input         BA_RW; // read/write
input         BA_REQ; // request
input  [ID:0] BA_ID;
input		  BA_PM;
input  [ 5:0] CMD;
input  [RAW+1:0] B0_LAST_RA;
input  [RAW+1:0] B1_LAST_RA;
input  [RAW+1:0] B2_LAST_RA;
input  [RAW+1:0] B3_LAST_RA;
output [BAW:0] CAS_0_BA;
output [RAW:0] CAS_0_RA;
output [CAW:0] CAS_0_CA;
output [TL:0]  CAS_0_TT;
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
reg [TL:0]  CAS_0_TT;
reg [ID:0]  CAS_0_ID;
reg        CAS_0_PM;
reg        CAS_0_RW;
reg        CAS_0_FINAL;
reg        CAS_0_NEWROW;
reg        CAS_EMPTY;
reg        CAS_FULL;

reg [CasQW:0] cas_1_data;

reg cas_1_final ;
reg cas_1_newrow;

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
    end
    else begin
        // process command
        if (CMD == bc_scas | CMD == bc_mcas) begin
            CAS_0_ID     <= cas_1_data[CasQW:CasQW-ID]; // 36:33
            CAS_0_BA     <= cas_1_data[BAW+RAW+CAW+TL+5:RAW+CAW+TL+5]; // 32:31
            CAS_0_RA     <= cas_1_data[RAW+CAW+TL+4:CAW+TL+4]; // 30:18
            CAS_0_CA     <= cas_1_data[CAW+TL+3: TL+3]; // 17: 7
            CAS_0_TT     <= cas_1_data[TL+2: 2]; // 6: 2
            CAS_0_RW     <= cas_1_data[1];
            CAS_0_PM     <= cas_1_data[0];
            CAS_0_FINAL  <= cas_1_final;
            CAS_0_NEWROW <= cas_1_newrow;

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

                    endcase
                end
                else begin
                    case(cas_cnt_pos)
                      		0 : CAS_0_NEWROW <= 1;
                      		1 : cas_1_newrow <= 1;
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
            endcase
            if (cas_cnt <= 1) begin
                cas_cnt  = cas_cnt + 1;
            end
        end
        CAS_EMPTY <= (cas_cnt == 0);
        CAS_FULL  <= (cas_cnt >= 1);
    end
end

endmodule
