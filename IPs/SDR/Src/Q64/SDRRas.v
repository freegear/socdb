
`timescale 1ns/10ps
//-----------------------------------------------------------------------------------
// Purpose : interface with 256 M bit sdram(4 bank x 4096 row x 256 column x 64 bit)
//-----------------------------------------------------------------------------------

module SDRRas (
    ARESETB , // asynchronous reset
    ACLK    ,

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
reg [RasQW:0] ras_01_data;
reg [RasQW:0] ras_02_data;
reg [RasQW:0] ras_03_data;
reg [RasQW:0] ras_04_data;
reg [RasQW:0] ras_05_data;
reg [RasQW:0] ras_06_data;
reg [RasQW:0] ras_07_data;
reg [RasQW:0] ras_08_data;
reg [RasQW:0] ras_09_data;
reg [RasQW:0] ras_0a_data;
reg [RasQW:0] ras_0b_data;
reg [RasQW:0] ras_0c_data;
reg [RasQW:0] ras_0d_data;
reg [RasQW:0] ras_0e_data;
reg [RasQW:0] ras_0f_data;
reg [RasQW:0] ras_10_data;
reg [RasQW:0] ras_11_data;
reg [RasQW:0] ras_12_data;
reg [RasQW:0] ras_13_data;
reg [RasQW:0] ras_14_data;
reg [RasQW:0] ras_15_data;
reg [RasQW:0] ras_16_data;
reg [RasQW:0] ras_17_data;
reg [RasQW:0] ras_18_data;
reg [RasQW:0] ras_19_data;
reg [RasQW:0] ras_1a_data;
reg [RasQW:0] ras_1b_data;
reg [RasQW:0] ras_1c_data;
reg [RasQW:0] ras_1d_data;
reg [RasQW:0] ras_1e_data;
reg [RasQW:0] ras_1f_data;
reg [RasQW:0] ras_20_data;
reg [RasQW:0] ras_21_data;
reg [RasQW:0] ras_22_data;
reg [RasQW:0] ras_23_data;
reg [RasQW:0] ras_24_data;
reg [RasQW:0] ras_25_data;
reg [RasQW:0] ras_26_data;
reg [RasQW:0] ras_27_data;
reg [RasQW:0] ras_28_data;
reg [RasQW:0] ras_29_data;
reg [RasQW:0] ras_2a_data;
reg [RasQW:0] ras_2b_data;
reg [RasQW:0] ras_2c_data;
reg [RasQW:0] ras_2d_data;
reg [RasQW:0] ras_2e_data;
reg [RasQW:0] ras_2f_data;
reg [RasQW:0] ras_30_data;
reg [RasQW:0] ras_31_data;
reg [RasQW:0] ras_32_data;
reg [RasQW:0] ras_33_data;
reg [RasQW:0] ras_34_data;
reg [RasQW:0] ras_35_data;
reg [RasQW:0] ras_36_data;
reg [RasQW:0] ras_37_data;
reg [RasQW:0] ras_38_data;
reg [RasQW:0] ras_39_data;
reg [RasQW:0] ras_3a_data;
reg [RasQW:0] ras_3b_data;
reg [RasQW:0] ras_3c_data;
reg [RasQW:0] ras_3d_data;
reg [RasQW:0] ras_3e_data;
reg [RasQW:0] ras_3f_data;

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
        ras_01_data   <= 0;
        ras_02_data   <= 0;
        ras_03_data   <= 0;
        ras_04_data   <= 0;
        ras_05_data   <= 0;
        ras_06_data   <= 0;
        ras_07_data   <= 0;
        ras_08_data   <= 0;
        ras_09_data   <= 0;
        ras_0a_data   <= 0;
        ras_0b_data   <= 0;
        ras_0c_data   <= 0;
        ras_0d_data   <= 0;
        ras_0e_data   <= 0;
        ras_0f_data   <= 0;
        ras_10_data   <= 0;
        ras_11_data   <= 0;
        ras_12_data   <= 0;
        ras_13_data   <= 0;
        ras_14_data   <= 0;
        ras_15_data   <= 0;
        ras_16_data   <= 0;
        ras_17_data   <= 0;
        ras_18_data   <= 0;
        ras_19_data   <= 0;
        ras_1a_data   <= 0;
        ras_1b_data   <= 0;
        ras_1c_data   <= 0;
        ras_1d_data   <= 0;
        ras_1e_data   <= 0;
        ras_1f_data   <= 0;
        ras_20_data   <= 0;
        ras_21_data   <= 0;
        ras_22_data   <= 0;
        ras_23_data   <= 0;
        ras_24_data   <= 0;
        ras_25_data   <= 0;
        ras_26_data   <= 0;
        ras_27_data   <= 0;
        ras_28_data   <= 0;
        ras_29_data   <= 0;
        ras_2a_data   <= 0;
        ras_2b_data   <= 0;
        ras_2c_data   <= 0;
        ras_2d_data   <= 0;
        ras_2e_data   <= 0;
        ras_2f_data   <= 0;
        ras_20_data   <= 0;
        ras_21_data   <= 0;
        ras_22_data   <= 0;
        ras_23_data   <= 0;
        ras_24_data   <= 0;
        ras_25_data   <= 0;
        ras_26_data   <= 0;
        ras_27_data   <= 0;
        ras_28_data   <= 0;
        ras_29_data   <= 0;
        ras_2a_data   <= 0;
        ras_2b_data   <= 0;
        ras_2c_data   <= 0;
        ras_2d_data   <= 0;
        ras_2e_data   <= 0;
        ras_2f_data   <= 0;
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
                RAS_0_BA   <= ras_01_data[RasQW:RasQW-BAW];	// 17:16
                RAS_0_RA   <= ras_01_data[RAW+TL+1: TL+1]; // 15:4
                RAS_0_TT   <= ras_01_data[TL: 0]; 		//  3:0
                ras_01_data <= ras_02_data;
                ras_02_data <= ras_03_data;
                ras_03_data <= ras_04_data;
                ras_04_data <= ras_05_data;
                ras_05_data <= ras_06_data;
                ras_06_data <= ras_07_data;
                ras_07_data <= ras_08_data;
                ras_08_data <= ras_09_data;
                ras_09_data <= ras_0a_data;
                ras_0a_data <= ras_0b_data;
                ras_0b_data <= ras_0c_data;
                ras_0c_data <= ras_0d_data;
                ras_0d_data <= ras_0e_data;
                ras_0e_data <= ras_0f_data;
                ras_0f_data <= ras_10_data;
                ras_10_data <= ras_11_data;
                ras_11_data <= ras_12_data;
                ras_12_data <= ras_13_data;
                ras_13_data <= ras_14_data;
                ras_14_data <= ras_15_data;
                ras_15_data <= ras_16_data;
                ras_16_data <= ras_17_data;
                ras_17_data <= ras_18_data;
                ras_18_data <= ras_19_data;
                ras_19_data <= ras_1a_data;
                ras_1a_data <= ras_1b_data;
                ras_1b_data <= ras_1c_data;
                ras_1c_data <= ras_1d_data;
                ras_1d_data <= ras_1e_data;
                ras_1e_data <= ras_1f_data;
                ras_1f_data <= ras_20_data;
                ras_20_data <= ras_21_data;
                ras_21_data <= ras_22_data;
                ras_22_data <= ras_23_data;
                ras_23_data <= ras_24_data;
                ras_24_data <= ras_25_data;
                ras_25_data <= ras_26_data;
                ras_26_data <= ras_27_data;
                ras_27_data <= ras_28_data;
                ras_28_data <= ras_29_data;
                ras_29_data <= ras_2a_data;
                ras_2a_data <= ras_2b_data;
                ras_2b_data <= ras_2c_data;
                ras_2c_data <= ras_2d_data;
                ras_2d_data <= ras_2e_data;
                ras_2e_data <= ras_2f_data;
                ras_2f_data <= ras_30_data;
                ras_30_data <= ras_31_data;
                ras_31_data <= ras_32_data;
                ras_32_data <= ras_33_data;
                ras_33_data <= ras_34_data;
                ras_34_data <= ras_35_data;
                ras_35_data <= ras_36_data;
                ras_36_data <= ras_37_data;
                ras_37_data <= ras_38_data;
                ras_38_data <= ras_39_data;
                ras_39_data <= ras_3a_data;
                ras_3a_data <= ras_3b_data;
                ras_3b_data <= ras_3c_data;
                ras_3c_data <= ras_3d_data;
                ras_3d_data <= ras_3e_data;
                ras_3e_data <= ras_3f_data;
                ras_cnt     = ras_cnt - 1;
            end
        end
        // save ras event
        if (BA_REQ &&
            ((BA_BA == 2'b00 && ({1'b0, BA_RA} != l_b0_last_ra)) ||
             (BA_BA == 2'b01 && ({1'b0, BA_RA} != l_b1_last_ra)) ||
             (BA_BA == 2'b10 && ({1'b0, BA_RA} != l_b2_last_ra)) ||
             (BA_BA == 2'b11 && ({1'b0, BA_RA} != l_b3_last_ra)) || 
             (CLOSING))) begin	// Should Fix Bug
            case(BA_BA)
              2'b00   : l_b0_last_ra <= {1'b0, BA_RA};
              2'b01   : l_b1_last_ra <= {1'b0, BA_RA};
              2'b10   : l_b2_last_ra <= {1'b0, BA_RA};
              2'b11   : l_b3_last_ra <= {1'b0, BA_RA};
            endcase
            case(ras_cnt)
              		6'h00 : begin
                        RAS_0_BA   <= BA_BA;
                        RAS_0_RA   <= BA_RA;
                        RAS_0_TT   <= BA_TT;
                        end
              		6'h01 : ras_01_data <= {BA_BA, BA_RA, BA_TT};
              		6'h02 : ras_02_data <= {BA_BA, BA_RA, BA_TT};
              		6'h03 : ras_03_data <= {BA_BA, BA_RA, BA_TT};
              		6'h04 : ras_04_data <= {BA_BA, BA_RA, BA_TT};
              		6'h05 : ras_05_data <= {BA_BA, BA_RA, BA_TT};
              		6'h06 : ras_06_data <= {BA_BA, BA_RA, BA_TT};
              		6'h07 : ras_07_data <= {BA_BA, BA_RA, BA_TT};
              		6'h08 : ras_08_data <= {BA_BA, BA_RA, BA_TT};
              		6'h09 : ras_09_data <= {BA_BA, BA_RA, BA_TT};
              		6'h0a : ras_0a_data <= {BA_BA, BA_RA, BA_TT};
              		6'h0b : ras_0b_data <= {BA_BA, BA_RA, BA_TT};
              		6'h0c : ras_0c_data <= {BA_BA, BA_RA, BA_TT};
              		6'h0d : ras_0d_data <= {BA_BA, BA_RA, BA_TT};
              		6'h0e : ras_0e_data <= {BA_BA, BA_RA, BA_TT};
              		6'h0f : ras_0f_data <= {BA_BA, BA_RA, BA_TT};
              		6'h10 : ras_10_data <= {BA_BA, BA_RA, BA_TT};
              		6'h11 : ras_11_data <= {BA_BA, BA_RA, BA_TT};
              		6'h12 : ras_12_data <= {BA_BA, BA_RA, BA_TT};
              		6'h13 : ras_13_data <= {BA_BA, BA_RA, BA_TT};
              		6'h14 : ras_14_data <= {BA_BA, BA_RA, BA_TT};
              		6'h15 : ras_15_data <= {BA_BA, BA_RA, BA_TT};
              		6'h16 : ras_16_data <= {BA_BA, BA_RA, BA_TT};
              		6'h17 : ras_17_data <= {BA_BA, BA_RA, BA_TT};
              		6'h18 : ras_18_data <= {BA_BA, BA_RA, BA_TT};
              		6'h19 : ras_19_data <= {BA_BA, BA_RA, BA_TT};
              		6'h1a : ras_1a_data <= {BA_BA, BA_RA, BA_TT};
              		6'h1b : ras_1b_data <= {BA_BA, BA_RA, BA_TT};
              		6'h1c : ras_1c_data <= {BA_BA, BA_RA, BA_TT};
              		6'h1d : ras_1d_data <= {BA_BA, BA_RA, BA_TT};
              		6'h1e : ras_1e_data <= {BA_BA, BA_RA, BA_TT};
              		6'h1f : ras_1f_data <= {BA_BA, BA_RA, BA_TT};
              		6'h20 : ras_20_data <= {BA_BA, BA_RA, BA_TT};
              		6'h21 : ras_21_data <= {BA_BA, BA_RA, BA_TT};
              		6'h22 : ras_22_data <= {BA_BA, BA_RA, BA_TT};
              		6'h23 : ras_23_data <= {BA_BA, BA_RA, BA_TT};
              		6'h24 : ras_24_data <= {BA_BA, BA_RA, BA_TT};
              		6'h25 : ras_25_data <= {BA_BA, BA_RA, BA_TT};
              		6'h26 : ras_26_data <= {BA_BA, BA_RA, BA_TT};
              		6'h27 : ras_27_data <= {BA_BA, BA_RA, BA_TT};
              		6'h28 : ras_28_data <= {BA_BA, BA_RA, BA_TT};
              		6'h29 : ras_29_data <= {BA_BA, BA_RA, BA_TT};
              		6'h2a : ras_2a_data <= {BA_BA, BA_RA, BA_TT};
              		6'h2b : ras_2b_data <= {BA_BA, BA_RA, BA_TT};
              		6'h2c : ras_2c_data <= {BA_BA, BA_RA, BA_TT};
              		6'h2d : ras_2d_data <= {BA_BA, BA_RA, BA_TT};
              		6'h2e : ras_2e_data <= {BA_BA, BA_RA, BA_TT};
              		6'h2f : ras_2f_data <= {BA_BA, BA_RA, BA_TT};
              		6'h30 : ras_30_data <= {BA_BA, BA_RA, BA_TT};
              		6'h31 : ras_31_data <= {BA_BA, BA_RA, BA_TT};
              		6'h32 : ras_32_data <= {BA_BA, BA_RA, BA_TT};
              		6'h33 : ras_33_data <= {BA_BA, BA_RA, BA_TT};
              		6'h34 : ras_34_data <= {BA_BA, BA_RA, BA_TT};
              		6'h35 : ras_35_data <= {BA_BA, BA_RA, BA_TT};
              		6'h36 : ras_36_data <= {BA_BA, BA_RA, BA_TT};
              		6'h37 : ras_37_data <= {BA_BA, BA_RA, BA_TT};
              		6'h38 : ras_38_data <= {BA_BA, BA_RA, BA_TT};
              		6'h39 : ras_39_data <= {BA_BA, BA_RA, BA_TT};
              		6'h3a : ras_3a_data <= {BA_BA, BA_RA, BA_TT};
              		6'h3b : ras_3b_data <= {BA_BA, BA_RA, BA_TT};
              		6'h3c : ras_3c_data <= {BA_BA, BA_RA, BA_TT};
              		6'h3d : ras_3d_data <= {BA_BA, BA_RA, BA_TT};
              		6'h3e : ras_3e_data <= {BA_BA, BA_RA, BA_TT};
              		6'h3f : ras_3f_data <= {BA_BA, BA_RA, BA_TT};
            endcase
            if (ras_cnt <= 63) begin
                ras_cnt = ras_cnt + 1;
            end
        end
        if (ras_cnt == 0)
             RAS_EMPTY  <= 1'b1;
        else RAS_EMPTY  <= 1'b0;
        if (ras_cnt <= 7)
             RAS_HEMPTY <= 1'b1;
        else RAS_HEMPTY <= 1'b0;
        if (ras_cnt >= 63)
             RAS_FULL   <= 1'b1;
        else RAS_FULL   <= 1'b0;
    end
end

endmodule
