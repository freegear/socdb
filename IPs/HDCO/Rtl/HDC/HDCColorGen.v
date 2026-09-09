// =======================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED Richentech
// -----------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : HDCColorGen.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is  colorbar genreation 
//                      for HD-Components 
// =======================================================================

`timescale 1ns/10ps

module HDCColorGen(
    CLK,
    RESETn,

    ACT_DISPLAY,
    HD_MODE,
    EN_INTERNAL_PATTERN,

    Rgen,
    Ggen,
    Bgen
);

parameter ACTIVE_STEP_480p     = 12'd103; /* Active 720  pixel */
parameter ACTIVE_STEP_720p     = 12'd183; /* Active 1280 pixel */
parameter ACTIVE_STEP_1080i    = 12'd274; /* Active 1920 pixel */
// =======================================================================
// Input & Ouput define
// -----------------------------------------------------------------------
input   CLK;
input   RESETn;

input   ACT_DISPLAY;
input   EN_INTERNAL_PATTERN;
input   [1:0] HD_MODE;

output   [7:0]   Rgen;
output   [7:0]   Ggen;
output   [7:0]   Bgen;

reg [7:0] R;
reg [7:0] G;
reg [7:0] B;

assign Rgen = (EN_INTERNAL_PATTERN) ? R:0;
assign Ggen = (EN_INTERNAL_PATTERN) ? G:0;
assign Bgen = (EN_INTERNAL_PATTERN) ? B:0;
// =================================================================
// Counting for generation pattern
// -----------------------------------------------------------------
reg     [11:0] BarCnt;
reg     [11:0] MaxCnt;
reg     [7:0]  ColCnt;
reg     ACT_DISPLAY_0d;
reg     ACT_DISPLAY_1d;
reg     ACT_DISPLAY_2d;

wire    EnArea = ACT_DISPLAY_0d | ACT_DISPLAY_1d | ACT_DISPLAY_2d;

always @(HD_MODE ) begin

    case(HD_MODE) 
        2'b00: MaxCnt = ACTIVE_STEP_480p;
        2'b01: MaxCnt = ACTIVE_STEP_720p;
        2'b10: MaxCnt = ACTIVE_STEP_1080i;
        default: MaxCnt = ACTIVE_STEP_480p;
    endcase

end

always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        ACT_DISPLAY_0d <= 0;
        ACT_DISPLAY_1d <= 0;
        ACT_DISPLAY_2d <= 0;
    end
    else begin
        ACT_DISPLAY_0d <= ACT_DISPLAY;
        ACT_DISPLAY_1d <= ACT_DISPLAY_0d;
        ACT_DISPLAY_2d <= ACT_DISPLAY_1d;
    end
end

wire [11:0] NxBarCnt;
assign  NxBarCnt = BarCnt + 12'd1;
always @(posedge CLK or negedge RESETn) begin
    if(!RESETn) begin
        BarCnt <= 12'd0;
        ColCnt <= 0;
    end
    else begin
        if(EnArea && (NxBarCnt == MaxCnt)) begin
            BarCnt <= 12'd0;
            ColCnt <= ColCnt + 1;
        end
        else if(EnArea) begin
            BarCnt <= NxBarCnt;
        end
        else begin
            BarCnt <= 12'd0;
            ColCnt <= 0;
        end
    end
end

// =================================================================
// Counting for generation pattern
// -----------------------------------------------------------------

always @(ColCnt) begin
    
    case(ColCnt) //synopsys parallel_case

        8'd0: begin
                R = 8'd255;
                G = 8'd255;
                B = 8'd255;
              end
        8'd1: begin
                R = 8'd255;
                G = 8'd255;
                B = 8'd0;
              end
        8'd2: begin
                R = 8'd0;
                G = 8'd255;
                B = 8'd255;
              end
        8'd3: begin
                R = 8'd0;
                G = 8'd255;
                B = 8'd0;
              end
        8'd4: begin
                R = 8'd255;
                G = 8'd0;
                B = 8'd255;
              end
        8'd5: begin
                R = 8'd255;
                G = 8'd0;
                B = 8'd0;
              end
        8'd6: begin
                R = 8'd0;
                G = 8'd0;
                B = 8'd255;
              end
        default: begin
                R = 8'd0;
                G = 8'd0;
                B = 8'd0;
                 end
    endcase
end
// -----------------------------------------------------------------

endmodule
