
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
reg [CasQW:0] cas_20_data;
reg [CasQW:0] cas_21_data;
reg [CasQW:0] cas_22_data;
reg [CasQW:0] cas_23_data;
reg [CasQW:0] cas_24_data;
reg [CasQW:0] cas_25_data;
reg [CasQW:0] cas_26_data;
reg [CasQW:0] cas_27_data;
reg [CasQW:0] cas_28_data;
reg [CasQW:0] cas_29_data;
reg [CasQW:0] cas_2a_data;
reg [CasQW:0] cas_2b_data;
reg [CasQW:0] cas_2c_data;
reg [CasQW:0] cas_2d_data;
reg [CasQW:0] cas_2e_data;
reg [CasQW:0] cas_2f_data;
reg [CasQW:0] cas_30_data;
reg [CasQW:0] cas_31_data;
reg [CasQW:0] cas_32_data;
reg [CasQW:0] cas_33_data;
reg [CasQW:0] cas_34_data;
reg [CasQW:0] cas_35_data;
reg [CasQW:0] cas_36_data;
reg [CasQW:0] cas_37_data;
reg [CasQW:0] cas_38_data;
reg [CasQW:0] cas_39_data;
reg [CasQW:0] cas_3a_data;
reg [CasQW:0] cas_3b_data;
reg [CasQW:0] cas_3c_data;
reg [CasQW:0] cas_3d_data;
reg [CasQW:0] cas_3e_data;
reg [CasQW:0] cas_3f_data;

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
reg cas_20_final ;
reg cas_20_newrow;
reg cas_21_final ;
reg cas_21_newrow;
reg cas_22_final ;
reg cas_22_newrow;
reg cas_23_final ;
reg cas_23_newrow;
reg cas_24_final ;
reg cas_24_newrow;
reg cas_25_final ;
reg cas_25_newrow;
reg cas_26_final ;
reg cas_26_newrow;
reg cas_27_final ;
reg cas_27_newrow;
reg cas_28_final ;
reg cas_28_newrow;
reg cas_29_final ;
reg cas_29_newrow;
reg cas_2a_final ;
reg cas_2a_newrow;
reg cas_2b_final ;
reg cas_2b_newrow;
reg cas_2c_final ;
reg cas_2c_newrow;
reg cas_2d_final ;
reg cas_2d_newrow;
reg cas_2e_final ;
reg cas_2e_newrow;
reg cas_2f_final ;
reg cas_2f_newrow;
reg cas_30_final ;
reg cas_30_newrow;
reg cas_31_final ;
reg cas_31_newrow;
reg cas_32_final ;
reg cas_32_newrow;
reg cas_33_final ;
reg cas_33_newrow;
reg cas_34_final ;
reg cas_34_newrow;
reg cas_35_final ;
reg cas_35_newrow;
reg cas_36_final ;
reg cas_36_newrow;
reg cas_37_final ;
reg cas_37_newrow;
reg cas_38_final ;
reg cas_38_newrow;
reg cas_39_final ;
reg cas_39_newrow;
reg cas_3a_final ;
reg cas_3a_newrow;
reg cas_3b_final ;
reg cas_3b_newrow;
reg cas_3c_final ;
reg cas_3c_newrow;
reg cas_3d_final ;
reg cas_3d_newrow;
reg cas_3e_final ;
reg cas_3e_newrow;
reg cas_3f_final ;
reg cas_3f_newrow;

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
        cas_20_data     <= 0;
        cas_20_final    <= 0;
        cas_20_newrow   <= 0;
        cas_21_data     <= 0;
        cas_21_final    <= 0;
        cas_21_newrow   <= 0;
        cas_22_data     <= 0;
        cas_22_final    <= 0;
        cas_22_newrow   <= 0;
        cas_23_data     <= 0;
        cas_23_final    <= 0;
        cas_23_newrow   <= 0;
        cas_24_data     <= 0;
        cas_24_final    <= 0;
        cas_24_newrow   <= 0;
        cas_25_data     <= 0;
        cas_25_final    <= 0;
        cas_25_newrow   <= 0;
        cas_26_data     <= 0;
        cas_26_final    <= 0;
        cas_26_newrow   <= 0;
        cas_27_data     <= 0;
        cas_27_final    <= 0;
        cas_27_newrow   <= 0;
        cas_28_data     <= 0;
        cas_28_final    <= 0;
        cas_28_newrow   <= 0;
        cas_29_data     <= 0;
        cas_29_final    <= 0;
        cas_29_newrow   <= 0;
        cas_2a_data     <= 0;
        cas_2a_final    <= 0;
        cas_2a_newrow   <= 0;
        cas_2b_data     <= 0;
        cas_2b_final    <= 0;
        cas_2b_newrow   <= 0;
        cas_2c_data     <= 0;
        cas_2c_final    <= 0;
        cas_2c_newrow   <= 0;
        cas_2d_data     <= 0;
        cas_2d_final    <= 0;
        cas_2d_newrow   <= 0;
        cas_2e_data     <= 0;
        cas_2e_final    <= 0;
        cas_2e_newrow   <= 0;
        cas_2f_data     <= 0;
        cas_2f_final    <= 0;
        cas_2f_newrow   <= 0;
        cas_30_data     <= 0;
        cas_30_final    <= 0;
        cas_30_newrow   <= 0;
        cas_31_data     <= 0;
        cas_31_final    <= 0;
        cas_31_newrow   <= 0;
        cas_32_data     <= 0;
        cas_32_final    <= 0;
        cas_32_newrow   <= 0;
        cas_33_data     <= 0;
        cas_33_final    <= 0;
        cas_33_newrow   <= 0;
        cas_34_data     <= 0;
        cas_34_final    <= 0;
        cas_34_newrow   <= 0;
        cas_35_data     <= 0;
        cas_35_final    <= 0;
        cas_35_newrow   <= 0;
        cas_36_data     <= 0;
        cas_36_final    <= 0;
        cas_36_newrow   <= 0;
        cas_37_data     <= 0;
        cas_37_final    <= 0;
        cas_37_newrow   <= 0;
        cas_38_data     <= 0;
        cas_38_final    <= 0;
        cas_38_newrow   <= 0;
        cas_39_data     <= 0;
        cas_39_final    <= 0;
        cas_39_newrow   <= 0;
        cas_3a_data     <= 0;
        cas_3a_final    <= 0;
        cas_3a_newrow   <= 0;
        cas_3b_data     <= 0;
        cas_3b_final    <= 0;
        cas_3b_newrow   <= 0;
        cas_3c_data     <= 0;
        cas_3c_final    <= 0;
        cas_3c_newrow   <= 0;
        cas_3d_data     <= 0;
        cas_3d_final    <= 0;
        cas_3d_newrow   <= 0;
        cas_3e_data     <= 0;
        cas_3e_final    <= 0;
        cas_3e_newrow   <= 0;
        cas_3f_data     <= 0;
        cas_3f_final    <= 0;
        cas_3f_newrow   <= 0;
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

            cas_1f_data   <= cas_20_data;
            cas_20_data   <= cas_21_data;
            cas_20_final  <= cas_21_final;
            cas_20_newrow <= cas_21_newrow;
            cas_21_data   <= cas_22_data;
            cas_21_final  <= cas_22_final;
            cas_21_newrow <= cas_22_newrow;
            cas_22_data   <= cas_23_data;
            cas_22_final  <= cas_23_final;
            cas_22_newrow <= cas_23_newrow;
            cas_23_data   <= cas_24_data;
            cas_23_final  <= cas_24_final;
            cas_23_newrow <= cas_24_newrow;
            cas_24_data   <= cas_25_data;
            cas_24_final  <= cas_25_final;
            cas_24_newrow <= cas_25_newrow;
            cas_25_data   <= cas_26_data;
            cas_25_final  <= cas_26_final;
            cas_25_newrow <= cas_26_newrow;
            cas_26_data   <= cas_27_data;
            cas_26_final  <= cas_27_final;
            cas_26_newrow <= cas_27_newrow;
            cas_27_data   <= cas_28_data;
            cas_27_final  <= cas_28_final;
            cas_27_newrow <= cas_28_newrow;
            cas_28_data   <= cas_29_data;
            cas_28_final  <= cas_29_final;
            cas_28_newrow <= cas_29_newrow;
            cas_29_data   <= cas_2a_data;
            cas_29_final  <= cas_2a_final;
            cas_29_newrow <= cas_2a_newrow;
            cas_2a_data   <= cas_2b_data;
            cas_2a_final  <= cas_2b_final;
            cas_2a_newrow <= cas_2b_newrow;
            cas_2b_data   <= cas_2c_data;
            cas_2b_final  <= cas_2c_final;
            cas_2b_newrow <= cas_2c_newrow;
            cas_2c_data   <= cas_2d_data;
            cas_2c_final  <= cas_2d_final;
            cas_2c_newrow <= cas_2d_newrow;
            cas_2d_data   <= cas_2e_data;
            cas_2d_final  <= cas_2e_final;
            cas_2d_newrow <= cas_2e_newrow;
            cas_2e_data   <= cas_2f_data;
            cas_2e_final  <= cas_2f_final;
            cas_2e_newrow <= cas_2f_newrow;

            cas_2f_data   <= cas_30_data;
            cas_30_data   <= cas_31_data;
            cas_30_final  <= cas_31_final;
            cas_30_newrow <= cas_31_newrow;
            cas_31_data   <= cas_32_data;
            cas_31_final  <= cas_32_final;
            cas_31_newrow <= cas_32_newrow;
            cas_32_data   <= cas_33_data;
            cas_32_final  <= cas_33_final;
            cas_32_newrow <= cas_33_newrow;
            cas_33_data   <= cas_34_data;
            cas_33_final  <= cas_34_final;
            cas_33_newrow <= cas_34_newrow;
            cas_34_data   <= cas_35_data;
            cas_34_final  <= cas_35_final;
            cas_34_newrow <= cas_35_newrow;
            cas_35_data   <= cas_36_data;
            cas_35_final  <= cas_36_final;
            cas_35_newrow <= cas_36_newrow;
            cas_36_data   <= cas_37_data;
            cas_36_final  <= cas_37_final;
            cas_36_newrow <= cas_37_newrow;
            cas_37_data   <= cas_38_data;
            cas_37_final  <= cas_38_final;
            cas_37_newrow <= cas_38_newrow;
            cas_38_data   <= cas_39_data;
            cas_38_final  <= cas_39_final;
            cas_38_newrow <= cas_39_newrow;
            cas_39_data   <= cas_3a_data;
            cas_39_final  <= cas_3a_final;
            cas_39_newrow <= cas_3a_newrow;
            cas_3a_data   <= cas_3b_data;
            cas_3a_final  <= cas_3b_final;
            cas_3a_newrow <= cas_3b_newrow;
            cas_3b_data   <= cas_3c_data;
            cas_3b_final  <= cas_3c_final;
            cas_3b_newrow <= cas_3c_newrow;
            cas_3c_data   <= cas_3d_data;
            cas_3c_final  <= cas_3d_final;
            cas_3c_newrow <= cas_3d_newrow;
            cas_3d_data   <= cas_3e_data;
            cas_3d_final  <= cas_3e_final;
            cas_3d_newrow <= cas_3e_newrow;
            cas_3e_data   <= cas_3f_data;
            cas_3e_final  <= cas_3f_final;
            cas_3e_newrow <= cas_3f_newrow;

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
                      		6'h00: CAS_0_FINAL  <= 0;
                      		6'h01: cas_01_final <= 0;
                      		6'h02: cas_02_final <= 0;
                      		6'h03: cas_03_final <= 0;
                     		6'h04: cas_04_final <= 0;
                      		6'h05: cas_05_final <= 0;
                      		6'h06: cas_06_final <= 0;
                      		6'h07: cas_07_final <= 0;
                      		6'h08: cas_08_final <= 0;
                      		6'h09: cas_09_final <= 0;
                      		6'h0a: cas_0a_final <= 0;
                      		6'h0b: cas_0b_final <= 0;
                      		6'h0c: cas_0c_final <= 0;
                      		6'h0d: cas_0d_final <= 0;
                      		6'h0e: cas_0e_final <= 0;
                      		6'h0f: cas_0f_final <= 0;
                      		6'h10: cas_10_final <= 0;
                      		6'h11: cas_11_final <= 0;
                      		6'h12: cas_12_final <= 0;
                      		6'h13: cas_13_final <= 0;
                     		6'h14: cas_14_final <= 0;
                      		6'h15: cas_15_final <= 0;
                      		6'h16: cas_16_final <= 0;
                      		6'h17: cas_17_final <= 0;
                      		6'h18: cas_18_final <= 0;
                      		6'h19: cas_19_final <= 0;
                      		6'h1a: cas_1a_final <= 0;
                      		6'h1b: cas_1b_final <= 0;
                      		6'h1c: cas_1c_final <= 0;
                      		6'h1d: cas_1d_final <= 0;
                      		6'h1e: cas_1e_final <= 0;
                      		6'h1f: cas_1f_final <= 0;
                      		6'h20: cas_10_final <= 0;
                      		6'h21: cas_11_final <= 0;
                      		6'h22: cas_12_final <= 0;
                      		6'h23: cas_13_final <= 0;
                     		6'h24: cas_14_final <= 0;
                      		6'h25: cas_15_final <= 0;
                      		6'h26: cas_16_final <= 0;
                      		6'h27: cas_17_final <= 0;
                      		6'h28: cas_18_final <= 0;
                      		6'h29: cas_19_final <= 0;
                      		6'h2a: cas_1a_final <= 0;
                      		6'h2b: cas_1b_final <= 0;
                      		6'h2c: cas_1c_final <= 0;
                      		6'h2d: cas_1d_final <= 0;
                      		6'h2e: cas_1e_final <= 0;
                      		6'h2f: cas_1f_final <= 0;
                      		6'h30: cas_10_final <= 0;
                      		6'h31: cas_11_final <= 0;
                      		6'h32: cas_12_final <= 0;
                      		6'h33: cas_13_final <= 0;
                     		6'h34: cas_14_final <= 0;
                      		6'h35: cas_15_final <= 0;
                      		6'h36: cas_16_final <= 0;
                      		6'h37: cas_17_final <= 0;
                      		6'h38: cas_18_final <= 0;
                      		6'h39: cas_19_final <= 0;
                      		6'h3a: cas_1a_final <= 0;
                      		6'h3b: cas_1b_final <= 0;
                      		6'h3c: cas_1c_final <= 0;
                      		6'h3d: cas_1d_final <= 0;
                      		6'h3e: cas_1e_final <= 0;
                      		6'h3f: cas_1f_final <= 0;
                    endcase
                end
                else begin
                    case(cas_cnt_pos)
                      		6'h00: CAS_0_NEWROW  <= 1;
                      		6'h01: cas_01_newrow <= 1;
                      		6'h02: cas_02_newrow <= 1;
                      		6'h03: cas_03_newrow <= 1;
                      		6'h04: cas_04_newrow <= 1;
                      		6'h05: cas_05_newrow <= 1;
                      		6'h06: cas_06_newrow <= 1;
                      		6'h07: cas_07_newrow <= 1;
                      		6'h08: cas_08_newrow <= 1;
                      		6'h09: cas_09_newrow <= 1;
                      		6'h0a: cas_0a_newrow <= 1;
                      		6'h0b: cas_0b_newrow <= 1;
                      		6'h0c: cas_0c_newrow <= 1;
                      		6'h0d: cas_0d_newrow <= 1;
                      		6'h0e: cas_0e_newrow <= 1;
                      		6'h0f: cas_0f_newrow <= 1;
                      		6'h10: cas_10_newrow <= 1;
                      		6'h11: cas_11_newrow <= 1;
                      		6'h12: cas_12_newrow <= 1;
                      		6'h13: cas_13_newrow <= 1;
                     		6'h14: cas_14_newrow <= 1;
                      		6'h15: cas_15_newrow <= 1;
                      		6'h16: cas_16_newrow <= 1;
                      		6'h17: cas_17_newrow <= 1;
                      		6'h18: cas_18_newrow <= 1;
                      		6'h19: cas_19_newrow <= 1;
                      		6'h1a: cas_1a_newrow <= 1;
                      		6'h1b: cas_1b_newrow <= 1;
                      		6'h1c: cas_1c_newrow <= 1;
                      		6'h1d: cas_1d_newrow <= 1;
                      		6'h1e: cas_1e_newrow <= 1;
                      		6'h1f: cas_1f_newrow <= 1;
                      		6'h20: cas_10_newrow <= 1;
                      		6'h21: cas_11_newrow <= 1;
                      		6'h22: cas_12_newrow <= 1;
                      		6'h23: cas_13_newrow <= 1;
                     		6'h24: cas_14_newrow <= 1;
                      		6'h25: cas_15_newrow <= 1;
                      		6'h26: cas_16_newrow <= 1;
                      		6'h27: cas_17_newrow <= 1;
                      		6'h28: cas_18_newrow <= 1;
                      		6'h29: cas_19_newrow <= 1;
                      		6'h2a: cas_1a_newrow <= 1;
                      		6'h2b: cas_1b_newrow <= 1;
                      		6'h2c: cas_1c_newrow <= 1;
                      		6'h2d: cas_1d_newrow <= 1;
                      		6'h2e: cas_1e_newrow <= 1;
                      		6'h2f: cas_1f_newrow <= 1;
                      		6'h30: cas_10_newrow <= 1;
                      		6'h31: cas_11_newrow <= 1;
                      		6'h32: cas_12_newrow <= 1;
                      		6'h33: cas_13_newrow <= 1;
                     		6'h34: cas_14_newrow <= 1;
                      		6'h35: cas_15_newrow <= 1;
                      		6'h36: cas_16_newrow <= 1;
                      		6'h37: cas_17_newrow <= 1;
                      		6'h38: cas_18_newrow <= 1;
                      		6'h39: cas_19_newrow <= 1;
                      		6'h3a: cas_1a_newrow <= 1;
                      		6'h3b: cas_1b_newrow <= 1;
                      		6'h3c: cas_1c_newrow <= 1;
                      		6'h3d: cas_1d_newrow <= 1;
                      		6'h3e: cas_1e_newrow <= 1;
                      		6'h3f: cas_1f_newrow <= 1;
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

               		32 : begin
                        cas_20_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_20_final  <= 1;
                        cas_20_newrow <= 0;
                        end
               		33 : begin
                        cas_21_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_21_final  <= 1;
                        cas_21_newrow <= 0;
                        end
              		34: begin
                        cas_22_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_22_final  <= 1;
                        cas_22_newrow <= 0;
                        end
              		35: begin
                        cas_23_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_23_final  <= 1;
                        cas_23_newrow <= 0;
                        end
             		36: begin
                        cas_24_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_24_final  <= 1;
                        cas_24_newrow <= 0;
                        end
              		37: begin
                        cas_25_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_25_final  <= 1;
                        cas_25_newrow <= 0;
                        end
              		38: begin
                        cas_26_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_26_final  <= 1;
                        cas_26_newrow <= 0;
                        end
              		39: begin
                        cas_27_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_27_final  <= 1;
                        cas_27_newrow <= 0;
                        end
              		40: begin
                        cas_28_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_28_final  <= 1;
                        cas_28_newrow <= 0;
                        end
              		41: begin
                        cas_29_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_29_final  <= 1;
                        cas_29_newrow <= 0;
                        end
              		42: begin
                        cas_2a_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2a_final  <= 1;
                        cas_2a_newrow <= 0;
                        end
              		43: begin
                        cas_2b_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2b_final  <= 1;
                        cas_2b_newrow <= 0;
                        end
              		44: begin
                        cas_2c_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2c_final  <= 1;
                        cas_2c_newrow <= 0;
                        end
              		45: begin
                        cas_2d_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2d_final  <= 1;
                        cas_2d_newrow <= 0;
                        end
              		46: begin
                        cas_2e_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2e_final  <= 1;
                        cas_2e_newrow <= 0;
                        end
              		47: begin
                        cas_2f_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_2f_final  <= 1;
                        cas_2f_newrow <= 0;
                        end

               		48 : begin
                        cas_30_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_30_final  <= 1;
                        cas_30_newrow <= 0;
                        end
               		49 : begin
                        cas_31_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_31_final  <= 1;
                        cas_31_newrow <= 0;
                        end
              		50: begin
                        cas_32_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_32_final  <= 1;
                        cas_32_newrow <= 0;
                        end
              		51: begin
                        cas_33_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_33_final  <= 1;
                        cas_33_newrow <= 0;
                        end
             		52: begin
                        cas_34_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_34_final  <= 1;
                        cas_34_newrow <= 0;
                        end
              		53: begin
                        cas_35_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_35_final  <= 1;
                        cas_35_newrow <= 0;
                        end
              		54: begin
                        cas_36_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_36_final  <= 1;
                        cas_36_newrow <= 0;
                        end
              		55: begin
                        cas_37_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_37_final  <= 1;
                        cas_37_newrow <= 0;
                        end
              		56: begin
                        cas_38_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_38_final  <= 1;
                        cas_38_newrow <= 0;
                        end
              		57: begin
                        cas_39_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_39_final  <= 1;
                        cas_39_newrow <= 0;
                        end
              		58: begin
                        cas_3a_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3a_final  <= 1;
                        cas_3a_newrow <= 0;
                        end
              		59: begin
                        cas_3b_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3b_final  <= 1;
                        cas_3b_newrow <= 0;
                        end
              		60: begin
                        cas_3c_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3c_final  <= 1;
                        cas_3c_newrow <= 0;
                        end
              		61: begin
                        cas_3d_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3d_final  <= 1;
                        cas_3d_newrow <= 0;
                        end
              		62: begin
                        cas_3e_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3e_final  <= 1;
                        cas_3e_newrow <= 0;
                        end
              		63: begin
                        cas_3f_data   <= {BA_ID, BA_BA, BA_RA, BA_CA, BA_TT, BA_RW, BA_PM};
                        cas_3f_final  <= 1;
                        cas_3f_newrow <= 0;
                        end
           endcase
            if (cas_cnt <= 63) begin
                cas_cnt  = cas_cnt + 1;
            end
        end
        if (cas_cnt == 0)
             CAS_EMPTY <= 1;
        else CAS_EMPTY <= 0;
        if (cas_cnt >= 63)
             CAS_FULL  <= 1;
        else CAS_FULL  <= 0;
    end
end

endmodule