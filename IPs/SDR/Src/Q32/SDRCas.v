
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
input  [ 5:0] CMD   ;
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

reg [CasQW:0] cas_01_data;
reg [CasQW:0] cas_02_data;
reg [CasQW:0] cas_03_data;
reg [CasQW:0] cas_04_data;
reg [CasQW:0] cas_05_data;
reg [CasQW:0] cas_06_data;
reg [CasQW:0] cas_07_data;
reg [CasQW:0] cas_08_data;
reg [CasQW:0] cas_09_data;
reg [CasQW:0] cas_0a_data;
reg [CasQW:0] cas_0b_data;
reg [CasQW:0] cas_0c_data;
reg [CasQW:0] cas_0d_data;
reg [CasQW:0] cas_0e_data;
reg [CasQW:0] cas_0f_data;
reg [CasQW:0] cas_10_data;
reg [CasQW:0] cas_11_data;
reg [CasQW:0] cas_12_data;
reg [CasQW:0] cas_13_data;
reg [CasQW:0] cas_14_data;
reg [CasQW:0] cas_15_data;
reg [CasQW:0] cas_16_data;
reg [CasQW:0] cas_17_data;
reg [CasQW:0] cas_18_data;
reg [CasQW:0] cas_19_data;
reg [CasQW:0] cas_1a_data;
reg [CasQW:0] cas_1b_data;
reg [CasQW:0] cas_1c_data;
reg [CasQW:0] cas_1d_data;
reg [CasQW:0] cas_1e_data;
reg [CasQW:0] cas_1f_data;

reg cas_01_final ;
reg cas_01_newrow;
reg cas_02_final ;
reg cas_02_newrow;
reg cas_03_final ;
reg cas_03_newrow;
reg cas_04_final ;
reg cas_04_newrow;
reg cas_05_final ;
reg cas_05_newrow;
reg cas_06_final ;
reg cas_06_newrow;
reg cas_07_final ;
reg cas_07_newrow;
reg cas_08_final ;
reg cas_08_newrow;
reg cas_09_final ;
reg cas_09_newrow;
reg cas_0a_final ;
reg cas_0a_newrow;
reg cas_0b_final ;
reg cas_0b_newrow;
reg cas_0c_final ;
reg cas_0c_newrow;
reg cas_0d_final ;
reg cas_0d_newrow;
reg cas_0e_final ;
reg cas_0e_newrow;
reg cas_0f_final ;
reg cas_0f_newrow;
reg cas_10_final ;
reg cas_10_newrow;
reg cas_11_final ;
reg cas_11_newrow;
reg cas_12_final ;
reg cas_12_newrow;
reg cas_13_final ;
reg cas_13_newrow;
reg cas_14_final ;
reg cas_14_newrow;
reg cas_15_final ;
reg cas_15_newrow;
reg cas_16_final ;
reg cas_16_newrow;
reg cas_17_final ;
reg cas_17_newrow;
reg cas_18_final ;
reg cas_18_newrow;
reg cas_19_final ;
reg cas_19_newrow;
reg cas_1a_final ;
reg cas_1a_newrow;
reg cas_1b_final ;
reg cas_1b_newrow;
reg cas_1c_final ;
reg cas_1c_newrow;
reg cas_1d_final ;
reg cas_1d_newrow;
reg cas_1e_final ;
reg cas_1e_newrow;
reg cas_1f_final ;
reg cas_1f_newrow;

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
        cas_01_data     <= 0;
        cas_01_final    <= 0;
        cas_01_newrow   <= 0;
        cas_02_data     <= 0;
        cas_02_final    <= 0;
        cas_02_newrow   <= 0;
        cas_03_data     <= 0;
        cas_03_final    <= 0;
        cas_03_newrow   <= 0;
        cas_04_data     <= 0;
        cas_04_final    <= 0;
        cas_04_newrow   <= 0;
        cas_05_data     <= 0;
        cas_05_final    <= 0;
        cas_05_newrow   <= 0;
        cas_06_data     <= 0;
        cas_06_final    <= 0;
        cas_06_newrow   <= 0;
        cas_07_data     <= 0;
        cas_07_final    <= 0;
        cas_07_newrow   <= 0;
        cas_08_data     <= 0;
        cas_08_final    <= 0;
        cas_08_newrow   <= 0;
        cas_09_data     <= 0;
        cas_09_final    <= 0;
        cas_09_newrow   <= 0;
        cas_0a_data     <= 0;
        cas_0a_final    <= 0;
        cas_0a_newrow   <= 0;
        cas_0b_data     <= 0;
        cas_0b_final    <= 0;
        cas_0b_newrow   <= 0;
        cas_0c_data     <= 0;
        cas_0c_final    <= 0;
        cas_0c_newrow   <= 0;
        cas_0d_data     <= 0;
        cas_0d_final    <= 0;
        cas_0d_newrow   <= 0;
        cas_0e_data     <= 0;
        cas_0e_final    <= 0;
        cas_0e_newrow   <= 0;
        cas_0f_data     <= 0;
        cas_0f_final    <= 0;
        cas_0f_newrow   <= 0;
        cas_10_data     <= 0;
        cas_10_final    <= 0;
        cas_10_newrow   <= 0;
        cas_11_data     <= 0;
        cas_11_final    <= 0;
        cas_11_newrow   <= 0;
        cas_12_data     <= 0;
        cas_12_final    <= 0;
        cas_12_newrow   <= 0;
        cas_13_data     <= 0;
        cas_13_final    <= 0;
        cas_13_newrow   <= 0;
        cas_14_data     <= 0;
        cas_14_final    <= 0;
        cas_14_newrow   <= 0;
        cas_15_data     <= 0;
        cas_15_final    <= 0;
        cas_15_newrow   <= 0;
        cas_16_data     <= 0;
        cas_16_final    <= 0;
        cas_16_newrow   <= 0;
        cas_17_data     <= 0;
        cas_17_final    <= 0;
        cas_17_newrow   <= 0;
        cas_18_data     <= 0;
        cas_18_final    <= 0;
        cas_18_newrow   <= 0;
        cas_19_data     <= 0;
        cas_19_final    <= 0;
        cas_19_newrow   <= 0;
        cas_1a_data     <= 0;
        cas_1a_final    <= 0;
        cas_1a_newrow   <= 0;
        cas_1b_data     <= 0;
        cas_1b_final    <= 0;
        cas_1b_newrow   <= 0;
        cas_1c_data     <= 0;
        cas_1c_final    <= 0;
        cas_1c_newrow   <= 0;
        cas_1d_data     <= 0;
        cas_1d_final    <= 0;
        cas_1d_newrow   <= 0;
        cas_1e_data     <= 0;
        cas_1e_final    <= 0;
        cas_1e_newrow   <= 0;
        cas_1f_data     <= 0;
        cas_1f_final    <= 0;
        cas_1f_newrow   <= 0;
    end
    else begin
        // process command
        if (CMD == bc_scas | CMD == bc_mcas) begin
            CAS_0_ID      <= cas_01_data[CasQW:CasQW-ID]; // 30:27
            CAS_0_BA      <= cas_01_data[BAW+RAW+CAW+TL+5:RAW+CAW+TL+5]; // 26:25
            CAS_0_RA      <= cas_01_data[RAW+CAW+TL+4:CAW+TL+4]; // 24:13
            CAS_0_CA      <= cas_01_data[CAW+TL+3: TL+3]; // 12:5
            CAS_0_TT      <= cas_01_data[TL+2: 2]; // 4:1
            CAS_0_RW      <= cas_01_data[1];
            CAS_0_PM      <= cas_01_data[0];
            CAS_0_FINAL   <= cas_01_final;
            CAS_0_NEWROW  <= cas_01_newrow;
            cas_01_data   <= cas_02_data;
            cas_01_final  <= cas_02_final;
            cas_01_newrow <= cas_02_newrow;
            cas_02_data   <= cas_03_data;
            cas_02_final  <= cas_03_final;
            cas_02_newrow <= cas_03_newrow;
            cas_03_data   <= cas_04_data;
            cas_03_final  <= cas_04_final;
            cas_03_newrow <= cas_04_newrow;
            cas_04_data   <= cas_05_data;
            cas_04_final  <= cas_05_final;
            cas_04_newrow <= cas_05_newrow;
            cas_05_data   <= cas_06_data;
            cas_05_final  <= cas_06_final;
            cas_05_newrow <= cas_06_newrow;
            cas_06_data   <= cas_07_data;
            cas_06_final  <= cas_07_final;
            cas_06_newrow <= cas_07_newrow;
            cas_07_data   <= cas_08_data;
            cas_07_final  <= cas_08_final;
            cas_07_newrow <= cas_08_newrow;
            cas_08_data   <= cas_09_data;
            cas_08_final  <= cas_09_final;
            cas_08_newrow <= cas_09_newrow;
            cas_09_data   <= cas_0a_data;
            cas_09_final  <= cas_0a_final;
            cas_09_newrow <= cas_0a_newrow;
            cas_0a_data   <= cas_0b_data;
            cas_0a_final  <= cas_0b_final;
            cas_0a_newrow <= cas_0b_newrow;
            cas_0b_data   <= cas_0c_data;
            cas_0b_final  <= cas_0c_final;
            cas_0b_newrow <= cas_0c_newrow;
            cas_0c_data   <= cas_0d_data;
            cas_0c_final  <= cas_0d_final;
            cas_0c_newrow <= cas_0d_newrow;
            cas_0d_data   <= cas_0e_data;
            cas_0d_final  <= cas_0e_final;
            cas_0d_newrow <= cas_0e_newrow;
            cas_0e_data   <= cas_0f_data;
            cas_0e_final  <= cas_0f_final;
            cas_0e_newrow <= cas_0f_newrow;
            cas_0f_data   <= cas_10_data;
            cas_0f_final  <= cas_10_final;
            cas_0f_newrow <= cas_10_newrow;
            cas_10_data   <= cas_11_data;
            cas_10_final  <= cas_11_final;
            cas_10_newrow <= cas_11_newrow;
            cas_11_data   <= cas_12_data;
            cas_11_final  <= cas_12_final;
            cas_11_newrow <= cas_12_newrow;
            cas_12_data   <= cas_13_data;
            cas_12_final  <= cas_13_final;
            cas_12_newrow <= cas_13_newrow;
            cas_13_data   <= cas_14_data;
            cas_13_final  <= cas_14_final;
            cas_13_newrow <= cas_14_newrow;
            cas_14_data   <= cas_15_data;
            cas_14_final  <= cas_15_final;
            cas_14_newrow <= cas_15_newrow;
            cas_15_data   <= cas_16_data;
            cas_15_final  <= cas_16_final;
            cas_15_newrow <= cas_16_newrow;
            cas_16_data   <= cas_17_data;
            cas_16_final  <= cas_17_final;
            cas_16_newrow <= cas_17_newrow;
            cas_17_data   <= cas_18_data;
            cas_17_final  <= cas_18_final;
            cas_17_newrow <= cas_18_newrow;
            cas_18_data   <= cas_19_data;
            cas_18_final  <= cas_19_final;
            cas_18_newrow <= cas_19_newrow;
            cas_19_data   <= cas_1a_data;
            cas_19_final  <= cas_1a_final;
            cas_19_newrow <= cas_1a_newrow;
            cas_1a_data   <= cas_1b_data;
            cas_1a_final  <= cas_1b_final;
            cas_1a_newrow <= cas_1b_newrow;
            cas_1b_data   <= cas_1c_data;
            cas_1b_final  <= cas_1c_final;
            cas_1b_newrow <= cas_1c_newrow;
            cas_1c_data   <= cas_1d_data;
            cas_1c_final  <= cas_1d_final;
            cas_1c_newrow <= cas_1d_newrow;
            cas_1d_data   <= cas_1e_data;
            cas_1d_final  <= cas_1e_final;
            cas_1d_newrow <= cas_1e_newrow;
            cas_1e_data   <= cas_1f_data;
            cas_1e_final  <= cas_1f_final;
            cas_1e_newrow <= cas_1f_newrow;

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
                      		0 : CAS_0_FINAL  <= 0;
                      		1 : cas_01_final <= 0;
                      		2 : cas_02_final <= 0;
                      		3 : cas_03_final <= 0;
                     		4 : cas_04_final <= 0;
                      		5 : cas_05_final <= 0;
                      		6 : cas_06_final <= 0;
                      		7 : cas_07_final <= 0;
                      		8 : cas_08_final <= 0;
                      		9 : cas_09_final <= 0;
                      		10: cas_0a_final <= 0;
                      		11: cas_0b_final <= 0;
                      		12: cas_0c_final <= 0;
                      		13: cas_0d_final <= 0;
                      		14: cas_0e_final <= 0;
                      		15: cas_0f_final <= 0;
                      		16: cas_10_final <= 0;
                      		17: cas_11_final <= 0;
                      		18: cas_12_final <= 0;
                      		19: cas_13_final <= 0;
                     		20: cas_14_final <= 0;
                      		21: cas_15_final <= 0;
                      		22: cas_16_final <= 0;
                      		23: cas_17_final <= 0;
                      		24: cas_18_final <= 0;
                      		25: cas_19_final <= 0;
                      		26: cas_1a_final <= 0;
                      		27: cas_1b_final <= 0;
                      		28: cas_1c_final <= 0;
                      		29: cas_1d_final <= 0;
                      		30: cas_1e_final <= 0;
                      		31: cas_1f_final <= 0;
                    endcase
                end
                else begin
                    case(cas_cnt_pos)
                      		0 : CAS_0_NEWROW  <= 1;
                      		1 : cas_01_newrow <= 1;
                      		2 : cas_02_newrow <= 1;
                      		3 : cas_03_newrow <= 1;
                      		4 : cas_04_newrow <= 1;
                      		5 : cas_05_newrow <= 1;
                      		6 : cas_06_newrow <= 1;
                      		7 : cas_07_newrow <= 1;
                      		8 : cas_08_newrow <= 1;
                      		9 : cas_09_newrow <= 1;
                      		10: cas_0a_newrow <= 1;
                      		11: cas_0b_newrow <= 1;
                      		12: cas_0c_newrow <= 1;
                      		13: cas_0d_newrow <= 1;
                      		14: cas_0e_newrow <= 1;
                      		15: cas_0f_newrow <= 1;
                      		16: cas_10_newrow <= 1;
                      		17: cas_11_newrow <= 1;
                      		18: cas_12_newrow <= 1;
                      		19: cas_13_newrow <= 1;
                     		20: cas_14_newrow <= 1;
                      		21: cas_15_newrow <= 1;
                      		22: cas_16_newrow <= 1;
                      		23: cas_17_newrow <= 1;
                      		24: cas_18_newrow <= 1;
                      		25: cas_19_newrow <= 1;
                      		26: cas_1a_newrow <= 1;
                      		27: cas_1b_newrow <= 1;
                      		28: cas_1c_newrow <= 1;
                      		29: cas_1d_newrow <= 1;
                      		30: cas_1e_newrow <= 1;
                      		31: cas_1f_newrow <= 1;
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
                        cas_01_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_01_final  <= 1;
                        cas_01_newrow <= 0;
                        end
              		2 : begin
                        cas_02_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_02_final  <= 1;
                        cas_02_newrow <= 0;
                        end
              		3 : begin
                        cas_03_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_03_final  <= 1;
                        cas_03_newrow <= 0;
                        end
             		4 : begin
                        cas_04_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_04_final  <= 1;
                        cas_04_newrow <= 0;
                        end
              		5 : begin
                        cas_05_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_05_final  <= 1;
                        cas_05_newrow <= 0;
                        end
              		6 : begin
                        cas_06_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_06_final  <= 1;
                        cas_06_newrow <= 0;
                        end
              		7 : begin
                        cas_07_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_07_final  <= 1;
                        cas_07_newrow <= 0;
                        end
              		8 : begin
                        cas_08_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_08_final  <= 1;
                        cas_08_newrow <= 0;
                        end
              		9 : begin
                        cas_09_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_09_final  <= 1;
                        cas_09_newrow <= 0;
                        end
              		10: begin
                        cas_0a_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_0a_final  <= 1;
                        cas_0a_newrow <= 0;
                        end
              		11: begin
                        cas_0b_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_0b_final  <= 1;
                        cas_0b_newrow <= 0;
                        end
              		12: begin
                        cas_0c_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_0c_final  <= 1;
                        cas_0c_newrow <= 0;
                        end
              		13: begin
                        cas_0d_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_0d_final  <= 1;
                        cas_0d_newrow <= 0;
                        end
              		14: begin
                        cas_0e_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_0e_final  <= 1;
                        cas_0e_newrow <= 0;
                        end
              		15: begin
                        cas_0f_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_0f_final  <= 1;
                        cas_0f_newrow <= 0;
                        end
               		16 : begin
                        cas_10_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_10_final  <= 1;
                        cas_10_newrow <= 0;
                        end
               		17 : begin
                        cas_11_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_11_final  <= 1;
                        cas_11_newrow <= 0;
                        end
              		18: begin
                        cas_12_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_12_final  <= 1;
                        cas_12_newrow <= 0;
                        end
              		19: begin
                        cas_13_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_13_final  <= 1;
                        cas_13_newrow <= 0;
                        end
             		20: begin
                        cas_14_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_14_final  <= 1;
                        cas_14_newrow <= 0;
                        end
              		21: begin
                        cas_15_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_15_final  <= 1;
                        cas_15_newrow <= 0;
                        end
              		22: begin
                        cas_16_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_16_final  <= 1;
                        cas_16_newrow <= 0;
                        end
              		23: begin
                        cas_17_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_17_final  <= 1;
                        cas_17_newrow <= 0;
                        end
              		24: begin
                        cas_18_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_18_final  <= 1;
                        cas_18_newrow <= 0;
                        end
              		25: begin
                        cas_19_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_19_final  <= 1;
                        cas_19_newrow <= 0;
                        end
              		26: begin
                        cas_1a_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1a_final  <= 1;
                        cas_1a_newrow <= 0;
                        end
              		27: begin
                        cas_1b_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1b_final  <= 1;
                        cas_1b_newrow <= 0;
                        end
              		28: begin
                        cas_1c_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1c_final  <= 1;
                        cas_1c_newrow <= 0;
                        end
              		29: begin
                        cas_1d_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1d_final  <= 1;
                        cas_1d_newrow <= 0;
                        end
              		30: begin
                        cas_1e_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1e_final  <= 1;
                        cas_1e_newrow <= 0;
                        end
              		31: begin
                        cas_1f_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_1f_final  <= 1;
                        cas_1f_newrow <= 0;
                        end
           endcase
            if (cas_cnt <= 31) begin
                cas_cnt  = cas_cnt + 1;
            end
        end
        if (cas_cnt == 0)
             CAS_EMPTY <= 1;
        else CAS_EMPTY <= 0;
        if (cas_cnt >= 31)
             CAS_FULL  <= 1;
        else CAS_FULL  <= 0;
    end
end

endmodule