// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TestDM.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is AXI Internal NTSC/PAL video test 
// =======================================================================

`timescale 1ns/1ps


module TestDM(

        CLK,
        RESETn,

        Enable,
        HD_MODE,

        LCD_HSW,
        LCD_HBP,
        LCD_ACTPIXEL,
        LCD_HFP,

        LCD_VSW,
        LCD_VBP,
        LCD_ACTLINE,
        LCD_VFP,

        RqDATA,
        DATAin,

        HSYNCn,
        VSYNCn,
        BLANKn,
        Rout,
        Gout,
        Bout
        );

input CLK;
input RESETn;
input Enable;

input [1:0]  HD_MODE;
input [11:0] LCD_HSW;  //3
input [11:0] LCD_HBP;  //4
input [11:0] LCD_ACTPIXEL; //5
input [11:0] LCD_HFP; //6

input [11:0] LCD_VSW; //7
input [11:0] LCD_VBP; //8
input [11:0] LCD_ACTLINE; //9
input [11:0] LCD_VFP; //10

output RqDATA;
input [15:0] DATAin;

output [7:0] Rout;
output [7:0] Gout;
output [7:0] Bout;

output HSYNCn;
output VSYNCn;
output BLANKn;

reg HSYNCn_0d;
reg VSYNCn_0d;
reg BLANKn_0d;
reg HSYNCn_1d;
reg VSYNCn_1d;
reg BLANKn_1d;
reg HSYNCn_2d;
reg VSYNCn_2d;
reg BLANKn_2d;
reg HSYNCn_3d;
reg VSYNCn_3d;
reg BLANKn_3d;
reg HSYNCn_4d;
reg VSYNCn_4d;
reg BLANKn_4d;

/*
assign HSYNCn = (HD_MODE == 2'b00) ? HSYNCn_3d:HSYNCn_2d ;
assign VSYNCn = (HD_MODE == 2'b00) ? VSYNCn_3d:VSYNCn_2d ;
assign BLANKn = (HD_MODE == 2'b00) ? BLANKn_3d:BLANKn_2d ;
*/
assign HSYNCn = HSYNCn_2d ;
assign VSYNCn = VSYNCn_2d ;
assign BLANKn = BLANKn_2d ;

reg [11:0] Vcnt;
reg [11:0] Hcnt;

reg [1:0]  VStCnt;
reg [11:0] VCompareData;
reg EvenOdd;
reg BulkVSync;
reg [11:0] VshifCnt;

reg [1:0]  HStCnt;
reg [11:0] HCompareData;

reg [7:0] Rout;
reg [7:0] Gout;
reg [7:0] Bout;

wire UpVcnt = ((HStCnt == 3) && (Hcnt == LCD_HFP)) ? 1'b1 : 1'b0;

wire [15:0] Rin = {DATAin[15:11]} * 11'd1053;
wire [16:0] Gin = {DATAin[10:5] } * 11'd518;
wire [15:0] Bin = {DATAin[4:0]  } * 11'd1053;

wire [7:0] TempR = Rin[14:7];
wire [7:0] TempG = Gin[14:7];
wire [7:0] TempB = Bin[14:7];


always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        Rout <= 0;
        Gout <= 0;
        Bout <= 0;
    end
    else if(!Enable) begin
        Rout <= 0;
        Gout <= 0;
        Bout <= 0;
    end
    else begin
        Rout <= TempR;
        Gout <= TempG;
        Bout <= TempB;
    end

end


always @(VStCnt or 
         LCD_VSW or
         LCD_VBP or
         LCD_ACTLINE or
         LCD_VFP)
begin
    case(VStCnt) //synopsys parallel_case
        2'd0: VCompareData = LCD_VSW;
        2'd1: VCompareData = LCD_VBP;
        2'd2: VCompareData = LCD_ACTLINE;
        2'd3: VCompareData = LCD_VFP;
    endcase
end

reg [11:0] BulkCnt;

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        BulkCnt <= 0;
    end
    else if(!Enable) begin
        BulkCnt <= 0;
    end
    else begin
        if(VStCnt == 0 && BulkCnt < 1100) begin
            BulkCnt <= BulkCnt + 1;
        end
        else if(VStCnt == 0 && BulkCnt == 1100) begin
            BulkCnt <= 1100;
        end
        else if(VStCnt == 1 && BulkCnt > 0) begin
            BulkCnt <= BulkCnt - 1;
        end
        else if(VStCnt == 1 && BulkCnt == 0) begin
            BulkCnt <= 0;
        end
    end
end



reg FlagBulkDelay;
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        VSYNCn_0d <= 1'b0;
        VSYNCn_1d <= 1'b0;
        VSYNCn_2d <= 1'b0;
        VSYNCn_3d <= 1'b0;
        VSYNCn_4d <= 1'b0;
        FlagBulkDelay <= 1'b0;
    end
    else if(!Enable) begin
        VSYNCn_0d <= 1'b0;
        VSYNCn_1d <= 1'b0;
        VSYNCn_2d <= 1'b0;
        VSYNCn_3d <= 1'b0;
        VSYNCn_4d <= 1'b0;
        FlagBulkDelay <= 1'b0;
    end
    else if(VStCnt == 0 && !BulkVSync) begin
        VSYNCn_0d <= 1'b1;
        VSYNCn_1d <= VSYNCn_0d;
        VSYNCn_2d <= VSYNCn_1d;
        VSYNCn_3d <= VSYNCn_2d;
        VSYNCn_4d <= VSYNCn_3d;
    end
    else if(VStCnt == 0 && BulkVSync && BulkCnt == 1100) begin
        VSYNCn_0d <= 1'b1;
        VSYNCn_1d <= VSYNCn_0d;
        VSYNCn_2d <= VSYNCn_1d;
        VSYNCn_3d <= VSYNCn_2d;
        VSYNCn_4d <= VSYNCn_3d;
        FlagBulkDelay <= 1'b1;
    end
    else if(FlagBulkDelay && BulkCnt == 0) begin
        VSYNCn_0d <= 1'b0;
        VSYNCn_1d <= VSYNCn_0d;
        VSYNCn_2d <= VSYNCn_1d;
        VSYNCn_3d <= VSYNCn_2d;
        VSYNCn_4d <= VSYNCn_3d;
        FlagBulkDelay <= 1'b0;
    end
    else if(!FlagBulkDelay) begin
        VSYNCn_0d <= 1'b0;
        VSYNCn_1d <= VSYNCn_0d;
        VSYNCn_2d <= VSYNCn_1d;
        VSYNCn_3d <= VSYNCn_2d;
        VSYNCn_4d <= VSYNCn_3d;
    end
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        Vcnt   <= 0;
        VStCnt <= 3;
        EvenOdd <= 0;
        BulkVSync <=0;
    end
    else begin
         if(!Enable) begin
            Vcnt   <= 0;
            VStCnt <= 3;
            EvenOdd <= 0;
            BulkVSync <=0;
         end
         else if(UpVcnt) begin
            if(VCompareData == Vcnt) begin
                Vcnt   <= 0;
                VStCnt <= VStCnt + 1;
                if(Vcnt == LCD_VFP && EvenOdd == 1 && HD_MODE[1] == 1'b1) begin
                    EvenOdd <= 1'b0;  //0dd --> even field
                    BulkVSync <=1;
                end
                else if(Vcnt == LCD_VFP && EvenOdd == 0 && HD_MODE[1] == 1'b1) begin
                    EvenOdd <= 1'b1; //Even --> odd field
                    BulkVSync <=0;
                end
                else begin
                    //EvenOdd <= 1'b0;
                    BulkVSync <=0;
                end
            end
            else begin
                if(BulkVSync) begin
                    Vcnt <= 0; 
                    BulkVSync <= 0;
                end
                else begin
                    Vcnt <= Vcnt + 1;
                end
            end
        end
    end
end



reg StartFlag;
wire   RqBulk = (StartFlag && (VStCnt == 2'd1) && (HStCnt == 2'd0) && ((Hcnt ==  11'd0) | (Hcnt == 11'd1))) ? 1'b1 : 1'b0;

assign RqDATA = ((VStCnt == 2'd2) && (HStCnt == 2'd2)) ? 1'b1 : RqBulk;

always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        StartFlag <= 1'b1;
    end
    else if(!Enable) begin
        StartFlag <= 1'b1;
    end
    else begin
        if((VStCnt == 2'd1) && (HStCnt == 2'd1)) begin
            StartFlag <= 1'b0;
        end
        else begin
            StartFlag <= StartFlag;
        end
    end
end



always @(posedge CLK or negedge RESETn) begin

    if(!RESETn) begin
        BLANKn_0d <= 1'b0;
        BLANKn_1d <= 1'b0;
        BLANKn_2d <= 1'b0;
        BLANKn_3d <= 1'b0;
        BLANKn_4d <= 1'b0;
    end
    else if(!Enable) begin
        BLANKn_0d <= 1'b0;
        BLANKn_1d <= 1'b0;
        BLANKn_2d <= 1'b0;
        BLANKn_3d <= 1'b0;
        BLANKn_4d <= 1'b0;
    end
    else begin
        if(VStCnt == 2'd2) BLANKn_0d <= RqDATA;
        else               BLANKn_0d <= 1'b0;
        BLANKn_1d <= BLANKn_0d;
        BLANKn_2d <= BLANKn_1d;
        BLANKn_3d <= BLANKn_2d;
        BLANKn_4d <= BLANKn_3d;
    end
end


always @(HStCnt or 
         LCD_HSW or
         LCD_HBP or
         LCD_ACTPIXEL or
         LCD_HFP)
begin
        case(HStCnt) //synopsys parallel_case
            2'd0: HCompareData = LCD_HSW;
            2'd1: HCompareData = LCD_HBP;
            2'd2: HCompareData = LCD_ACTPIXEL;
            2'd3: HCompareData = LCD_HFP;
        endcase
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        HSYNCn_0d <= 1'b0;
        HSYNCn_1d <= 1'b0;
        HSYNCn_2d <= 1'b0;
        HSYNCn_3d <= 1'b0;
        HSYNCn_4d <= 1'b0;
    end
    else if(!Enable) begin
        HSYNCn_0d <= 1'b0;
        HSYNCn_1d <= 1'b0;
        HSYNCn_2d <= 1'b0;
        HSYNCn_3d <= 1'b0;
        HSYNCn_4d <= 1'b0;
    end
    else if(HStCnt == 0) begin
        HSYNCn_0d <= 1'b1;
        HSYNCn_1d <= HSYNCn_0d;
        HSYNCn_2d <= HSYNCn_1d;
        HSYNCn_3d <= HSYNCn_2d;
        HSYNCn_4d <= HSYNCn_3d;
    end
    else begin
        HSYNCn_0d <= 1'b0;
        HSYNCn_1d <= HSYNCn_0d;
        HSYNCn_2d <= HSYNCn_1d;
        HSYNCn_3d <= HSYNCn_2d;
        HSYNCn_4d <= HSYNCn_3d;
    end
end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        Hcnt   <= 0;
        HStCnt <= 3;     
    end
    else begin
        if(!Enable) begin
            Hcnt <= 0;
            HStCnt <= 3;     
        end
        else if(HCompareData == Hcnt) begin
            Hcnt <= 0;
            HStCnt <= HStCnt + 1;
        end
        else begin
            Hcnt <= Hcnt + 1;
        end
    end
end

endmodule
